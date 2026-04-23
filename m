Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 918A8F589AD
	for <linux-mm@archiver.kernel.org>; Thu, 23 Apr 2026 12:47:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BCB266B0005; Thu, 23 Apr 2026 08:47:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B7BDF6B008A; Thu, 23 Apr 2026 08:47:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A6B4D6B008C; Thu, 23 Apr 2026 08:47:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 94FF66B0005
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 08:47:30 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 2B18FC0506
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 12:47:30 +0000 (UTC)
X-FDA: 84689796660.15.DB2B179
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf07.hostedemail.com (Postfix) with ESMTP id 70B2240010
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 12:47:28 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=FM34rKm0;
	spf=pass (imf07.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776948448;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=R7tMtHpLxvIj79/pcrqQ/Wgt4Q6MffZmC8I5a/JMEGE=;
	b=RN/pO/I6jsog1YP1x1RsDJujoxbeemAesJP6tEXIjT0oX+QNkaZm/3oKZPg35AdOwX2An5
	AGxjyfKi2fsMo4HIMDjAcLwSu9OJqgwaMatsKdEHbSOVOhEt2lT1bbox+D3ER2daZGsBen
	6bbw+tHN3gYBC79tCwxBo4ZHKWuUOao=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776948448; a=rsa-sha256;
	cv=none;
	b=A+SrAQGWVUzkw6JsMaMdAnvxgLtfH68KNMGsLEGLcgx8/K+eX/42SFGAfHBaThj5qjmtVv
	Qry4AdCY0Ku+ZiMpeHM4MAey3TBRN8PLMuq/U9C7OdHjv9cdcwoc52+sO1+tgFvS52UMGR
	LkNytbN8c+HSi8ZeXxz8lKjWcj4fHDQ=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=FM34rKm0;
	spf=pass (imf07.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id E562D6013B;
	Thu, 23 Apr 2026 12:47:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94E6BC2BCAF;
	Thu, 23 Apr 2026 12:47:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776948447;
	bh=BvepwwNd0J+yd//IBNL4vgYlnVadtAqRJ+ts3qFctMk=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=FM34rKm022qsNqEJyh/tZT+Bey1v/VykVSzsV/EbwIuH2x3+upga4IRqgSl+FiX8R
	 1a0dVDZOslXJNwLpIFxa3SLGWunSUYa7QNnXT96D1VOZHE11Gu5IiVtekw25TkQeQt
	 WRRKRX1b1akRoeKiX0+3KiilHmKc6RH4FCBkYt91sTkx4QERBWCXilfjY2CFqhK7mv
	 zA5Kp0AsOf/JJoVCE8HEWHCY0TWlGYfyXb1XYuMQ209ABgwPIdhCTt/3bUwSSbvU04
	 Fm041OhduNyQrQ9QUIvsUBqzvJ7VS1oqtml2GNEEezH9iPtwJW4UpxCvAdHZwyiX6L
	 nl8POOqP7EwqA==
Message-ID: <dee5b7e8-864d-48b5-99cf-282eedaba927@kernel.org>
Date: Thu, 23 Apr 2026 14:47:23 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/gup: honour FOLL_PIN in NOMMU
 __get_user_pages_locked()
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
 Jason Gunthorpe <jgg@ziepe.ca>, John Hubbard <jhubbard@nvidia.com>,
 Peter Xu <peterx@redhat.com>
References: <2026042334-acutely-unadorned-e05c@gregkh>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <2026042334-acutely-unadorned-e05c@gregkh>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 70B2240010
X-Rspamd-Server: rspam07
X-Stat-Signature: bf1wyys31rgqxo9oitrztheciq6ofgza
X-Rspam-User: 
X-HE-Tag: 1776948448-352460
X-HE-Meta: U2FsdGVkX185XJdQO4P132bkSG2mlox+8ZVK34cbeqKXfEL/Lbb7fwvxepz9SzfQLenemFC8T0Dpq8IeVl7f37b/VU4StEEKHC5rD2Mi/A5qquYQAMfS3rbPQQsQDVpvYkB65Mx3JLhHkhNTwCSKvcEmDiKv6TVRns3xMmUU4cKxygGaLcS+ZIZJDll97v4XzVtsMSWNVd12TGS6RDH/c5NU/DpoM5ojHYTg5XJrEl4ZX6MY7KAw6MxW/uos1zEMLpi/7EctkJSV4i31M2TLh59kjoWraqpKOLhCFcsiLnUh8u7fozj5kE0TJUAVwh6Ci0ZwKzxwOI38mNMSfve5zpG3VwdBhLPca3m8GTtuIn8Lk0I4g3ZEvGLB0SbpHbUkQRpsq+VaujMIziMTzYvl2FBmL2X8KXfqRcI1Vqbkeuev0jh2JkCps1VSiMQQ6xcDxOVwwJcKW6HkKa7HSUGre6DVrV+2fk4sZb91HiJREPkLbKCj1QUq+EUsWWTracF5Z2Fo1JCMgeMaVvqz7q0vRLshdRNieqY5OuwVS6XkMyiTEuhaaW/Beoq95j9fIOM055P8YLVeX5SzqNlFZFY0nIbaHAusawJWIDRCZvIG1maQ93b1K9ummgDoa62AGYkzc1lWTy5Cem6+4JPbQu9e/Z0tPhn6COW7dE/4bbasIbrVSFw/NtgDC5fDqNhPQsvQ1ulwdwQ+L05ll0qWktgKNHMU5z4yO/C1DpC28fxg9elxBPX7NS9ycqGznjxMHbK9/SRPH0ALP9NiRUjFBHkXQgzWPP4caXMaAx+u54RwW6fiIGSgJ3ZWoniwNpnYUYo+hr2iXXig3uFyX4tjlniTKbMXIrW/VObvlI1WHasNTbZp23ujIK9pZfYPRE3owluE22nGlMTjVLq96ivHLPVWPjD1HzbLreu4bvK0rZIn/SHXij/lAnp6rKa2rLnQ4bcFr8FFgbwZaTUdlt5i3pL
 9Kx4Go8s
 +yNcCT6Z3kkibDQL3qBqL48eaPYHPfFD8xwMGMJV/+IalXeQ14S1f+GoN3T0fj5tVvp9hRlY1dtXPPnPX9UYJfxAS38Ct7B/6liZOyXdAqmsdVB6jaqr2W2FI0qFRAPYXfVv5sJdhLMsvzbZxE18BWyxk6Jd4ok7s4GT2eyLfAsKGD6UmTNSnNxdcnWMfeUF1GpESKy2fv6IpQerF9xF0hvBEXWPV8DJD04edtllLMXRfOUgc6zMqb/WFsbItvy9QYJApQ/eWGyVsp5vuYbYQBf0suV2SXjeq3ymJy4TE3bXLlEumfaH02AeFVH9S3k2Ov2zzW48Wtn6oTAjNBpd0q6rsuH41GOnEogmluwYt8SfNco5TkqqV+BfwxRjoXpw8hiYkWl6CTeXo9uiQ5wrNenrzif5uRzXXidw1F2kOuU9vDKRet1mtfNn/lE6elwAJ0uXYSqh8TsoVJDJUhwmWCBa3rvg7h58ZrnnJLu0pscsRluxhJvmw/mM3T6YEh6Zk8qKKvSGgs9dYwJy2z/YCGPmRr70Ta8IgMRVoOx4DKEynuHg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4/23/26 14:31, Greg Kroah-Hartman wrote:
> The !CONFIG_MMU implementation of __get_user_pages_locked() takes a bare
> get_page() reference for each page regardless of foll_flags:
> 	if (pages[i])
> 		get_page(pages[i]);
> 
> This is reached from pin_user_pages*() with FOLL_PIN set.
> unpin_user_page() is shared between MMU and NOMMU configurations and
> unconditionally calls gup_put_folio(..., FOLL_PIN), which subtracts
> GUP_PIN_COUNTING_BIAS (1024) from the folio refcount.
> 
> This means that pin adds 1, and then unpin will subtract 1024.
> 
> If a user maps a page (refcount 1), registers it 1023 times as an
> io_uring fixed buffer (1023 pin_user_pages calls -> refcount 1024), then
> unregisters: the first unpin_user_page subtracts 1024, refcount hits 0,
> the page is freed and returned to the buddy allocator.  The remaining
> 1022 unpins write into whatever was reallocated, and the user's VMA
> still maps the freed page (NOMMU has no MMU to invalidate it).
> Reallocating the page for an io_uring pbuf_ring then lets userspace
> corrupt the new owner's data through the stale mapping.
> 
> Use try_grab_folio() which adds GUP_PIN_COUNTING_BIAS for FOLL_PIN and 1
> for FOLL_GET, mirroring the CONFIG_MMU path so pin and unpin are
> symmetric.
> 
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: David Hildenbrand <david@kernel.org>
> Cc: Jason Gunthorpe <jgg@ziepe.ca>
> Cc: John Hubbard <jhubbard@nvidia.com>
> Cc: Peter Xu <peterx@redhat.com>
> Reported-by: Anthropic
> Assisted-by: gkh_clanker_t1000
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> ---
> My first foray into -mm, eeek!

Oh, nommu ... what a great use of our time.

I was briefly wondering if we want to add a Fixes: ... but then, this was likely
broken for years and nobody cared so far in practice.

> 
> Anyway, this was a crazy report sent to me, and I knocked up this
> change, and I have a reproducer if people need/want to see that as well
> (it's for nommu systems, so be wary of it.)

[...]

> -				get_page(pages[i]);
> +			if (pages[i]) {
> +				/*
> +				 * pin_user_pages*() arrives here with FOLL_PIN
> +				 * set; unpin_user_page() (which is not
> +				 * !CONFIG_MMU-specific) calls
> +				 * gup_put_folio(..., FOLL_PIN) which subtracts
> +				 * GUP_PIN_COUNTING_BIAS (1024).  A bare
> +				 * get_page() here adds only 1, so 1023 pins on
> +				 * a fresh page bring refcount to 1024 and a
> +				 * single unpin then frees it out from under the
> +				 * remaining 1022 pins and any live VMA
> +				 * mappings. Use the same grab path as the MMU
> +				 * implementation so pin and unpin are
> +				 * symmetric.
> +				 */

Yeah, drop all that. Especially the hardcoded 1024/1022 is just screaming for
trouble longterm.

It just follows what we do everywhere else (e.g., follow_page_pte()).


> +				if (try_grab_folio(page_folio(pages[i]), 1,
> +						   foll_flags)) {
> +					pages[i] = NULL;
> +					break;
> +				}
> +			}

If it fails on the first iteration, we return -EFAULT instead of -ENOMEM.

I know, I know, nobody cares. But if we touch it, we might just want to return
the error we get from try_grab_folio().

-- 
Cheers,

David

