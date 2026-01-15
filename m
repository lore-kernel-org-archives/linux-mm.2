Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 211ACD46617
	for <linux-mm@archiver.kernel.org>; Thu, 15 Jan 2026 20:10:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 856986B00EC; Thu, 15 Jan 2026 15:10:47 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 820576B00ED; Thu, 15 Jan 2026 15:10:47 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 722896B00F0; Thu, 15 Jan 2026 15:10:47 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 644FC6B00EC
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 15:10:47 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 2754214047A
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 20:10:47 +0000 (UTC)
X-FDA: 84335291334.26.2407E99
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf22.hostedemail.com (Postfix) with ESMTP id 48129C000D
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 20:10:45 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=K9ZlsuHJ;
	spf=pass (imf22.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768507845; a=rsa-sha256;
	cv=none;
	b=ekZw+5u/7/8vTXVEaRq8cmKLtjatVMj7c7xKMxSJ5S54+i+NYlyb6HPmnmKnPOWVx8XJTo
	PGgrpVA/mwq3uK9qVKTW7jQpRnaCguwcnR/B3v4RarpMM0DcO86BfN4ROdKyND8onqw96L
	bjlxwma0CTN0uDGsUcL7D7Z+ecz5FeY=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=K9ZlsuHJ;
	spf=pass (imf22.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768507845;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=r+oHRaJAl4VfavwUixLNAAMO8Pre9Y76Yp3j6JTKruw=;
	b=TusE/SfJKSsQpVccgrvvqZ9L4CrxBLoXpVzUc9DfROARY15eYSlzunfSzTfIehid12PHvI
	RQfjkn2hyn4xWicbENvg0myEt3mJjAHNBWwfLJvMJsodyCBb0p+uOjAqVDEKWgHvQQSoGr
	JnU0tqOwWHshW5ahdoJs0MtKPFdLX9k=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id BBE446015E;
	Thu, 15 Jan 2026 20:10:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA15EC116D0;
	Thu, 15 Jan 2026 20:10:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768507844;
	bh=mDIggy5139IqPA20EejhYHaVHu2JkcRx+xJOC7xyLCg=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=K9ZlsuHJ2KfFuEVMaA8anN2yEbbVbhcoLF7Oml3FbWJzy5jKNtuViaDl0o2+OiuZo
	 U6lIejZ3HnzbAwi1EAZjpuuZmeX9WtKoqknnWhA44IaGP7c+gIy0vRyREnEI+m9oLz
	 xda0vLU+oD3CKwJII4V6agNk9H5RMxJyA3QSyB6nPD+tzFJoTdQCgNSYaP+ojEf3WJ
	 ZrJiF+JaeEOjLJJKr+qQisWoL22xX13mQxjD0gLd82+9XsVLKodx+Q0vCIeY3bNTq5
	 rTjw2vSJVaGmPPj86fc8kCg84gkTN/n3mAxP1At0fvUk8mXDNJacVB7VbcjX6mwYgk
	 NA6bBAbVVE9Uw==
Message-ID: <a0760613-5c57-4f04-848b-a0a6ff05c0e8@kernel.org>
Date: Thu, 15 Jan 2026 21:10:41 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/3] mm/hugetlb: Enforce brace style
To: Joshua Hahn <joshua.hahnjy@gmail.com>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org
References: <20260115181438.223620-1-joshua.hahnjy@gmail.com>
 <20260115181438.223620-4-joshua.hahnjy@gmail.com>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
In-Reply-To: <20260115181438.223620-4-joshua.hahnjy@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 48129C000D
X-Stat-Signature: yhbdz9akk8i36iijtfzyykprg6fs4jt1
X-Rspam-User: 
X-HE-Tag: 1768507845-790455
X-HE-Meta: U2FsdGVkX19a7Uussz5jXUFXXKxJ5dh5NJQ/MzhOuTKswZSw7k212xFW4FDEJo2+j+ReoZtkKJWFvQbM+xvU0jS/QiFMpeGv0zxtJj4GYk6xnRsPizwcIyC8LGIL7j3tEQlVzwIyQcj2slTu7NCLuetOns9KmxbftEyP5Zf/T9OnZtjYm2UmStO17GhM5CzpLUilVeiOzYP5YobR2HaoLZmYOKG6L5qyjot2PUyqphUgiu5lJWkEkj8+PF7Em2B8FirzxoDP4YnwNplwsjJNS6lagyDNN3JQKbKCFnLf8wIxJ90V+DuXotSue5AkLTf0QFrP/rWJXqwXy2rH67ohmY4smoRyTm5rvYr8dU/d8VSWEX3hnUbOL3Xy2Didakeoq/8bsvNfFwqWUV9YQaU5BGC7FD3tgxtGOMcDs2AE76+VpsLSoBtk3Bmuv5T3IXYHNNz6WmRB7A5rO2ggRptc9SCY1mjxLVLuQGVEXOqznskeI6QqEd/V4zT+epcyHZuOz/ZNOrZpXiMZNip9rmJu1m1z33Cm5nO43GNfCCh4N/OIYePUxPKeqmUQMgAzVD+wrtFBuV3b+Z2Fzyerqsn49zPSm0dwYpibt3H1iOjJj7OSpg8lmkKsOPWFNMR1Z9nDRBVA48z96jnqX+N2gZSRiEx1MdbUbF2Uhm0aG96mZJIvAu8DA3oUb16aiiMdj1xo2URfvIa3HBOQTWXSM0xW9/ewzP0QpsP3U5rqNjtdzZL2Bh6M2nplXXlJhbJsh0/sozpu3MXkCUOnGm7jNcMqldllESQJalj2NKFEEzFIxjz/G+jjX+pyNXgxEhhLmfxrUZu4Echr/p4tFnl6JHHA4OpKdYH7kemEvYc+rwEq/xj7Da+BAv/ttU3egUlSswU635nda4ubqOGpQBxAsoXkRJRtY+RW74JrRV5OROx/Xa/B5MvYcMmbcN45RkDBf6rXAgsC4RItfuLf+nmuyrp
 nCCNSmX6
 mqK225QbTCQsXdqWKyR57y1lh785qWklBDr9wh81qvd1uyna+vx/3kaLqiWoiBNyfwTQT5IfuY0KGbUshXsYmhJzJ2xEWWep4sOSNUE4qvUXe3qWIh3fdAD2a/Ty7jUxPrToflQ0A1rXKIHEi53B/Rbc0bE+TKSxwk8bb0eZqF5su7LLNUo6o2P5jbPct/dBZtWSzpD7rYW2jf+owh6r1MsJZo5Nz7eDd7m/co1UNYVLjJkm/6+DQT8l1iyX5b/U/BxRk+AZ/+m1MULo9u+FTjHGkwjSAbq6TG/YtbRFsOWSuoo7z6mgfCfqYm28t38uk856iOVyyENFAfXZBbCUsqW5gtlIvdl3u3WQS
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 1/15/26 19:14, Joshua Hahn wrote:
> Documentation/process/coding-style.rst explicitly notes that if only one
> branch of a conditional statement is a single statement, braces should
> be used in both branches. Enforce this in mm/hugetlb.c.
> 
> No functional change intended.
> 
> Signed-off-by: Joshua Hahn <joshua.hahnjy@gmail.com>
> ---

[...]

>   		update_and_free_hugetlb_folio(h, folio, false);
>   		return rc;
> @@ -2672,11 +2675,13 @@ void restore_reserve_on_error(struct hstate *h, struct vm_area_struct *vma,
>   				 * be consumed on a subsequent allocation.
>   				 */
>   				folio_set_hugetlb_restore_reserve(folio);
> -		} else
> +		} else {
>   			/*
>   			 * No reservation present, do nothing
>   			 */
>   			 vma_end_reservation(h, vma, address);
> +

But why the empty line? :)

> +		}
>   	}
>   }



-- 
Cheers

David

