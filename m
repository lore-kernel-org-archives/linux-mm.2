Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 33088CD3447
	for <linux-mm@archiver.kernel.org>; Fri,  8 May 2026 10:57:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6F33E6B013F; Fri,  8 May 2026 06:57:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6A4736B0140; Fri,  8 May 2026 06:57:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5BAB66B0141; Fri,  8 May 2026 06:57:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4B2736B013F
	for <linux-mm@kvack.org>; Fri,  8 May 2026 06:57:31 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 13615A07E3
	for <linux-mm@kvack.org>; Fri,  8 May 2026 10:57:31 +0000 (UTC)
X-FDA: 84743951502.11.0696BA5
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id 03330C000E
	for <linux-mm@kvack.org>; Fri,  8 May 2026 10:57:28 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=LrGgn3Ox;
	spf=pass (imf10.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778237849;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OsMDP5BrYLVxH0EwTMKhjiUdq3XBI2YqWpwic+U63wk=;
	b=0qnCWpaSPZgmyjjy4MGVpYHeO5AjRybrAOfHvNpflGS2TyDCbWhkq99zH7n5DR3deLOAV9
	xDM5hi0PsyGvATfHULvACueghAdgqAwXgAIg6IqBe++ywmLAYj2hp/gVQVWOjoTsf3CsEB
	eSUY69SMz8wzuSEyCHY+qwQ0XoUBJUg=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=LrGgn3Ox;
	spf=pass (imf10.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778237849; a=rsa-sha256;
	cv=none;
	b=d982VuxgaTC9tpk7Ec4Bai6YoL/wwkRG/xuC9RvIdOJH+xMHUsYNPAdKZuG2dNR/yrdlLD
	awcEyc25GgQs2fDvgxY/4rXiVOA9K+dXRUwEDfDBCT0uN+V8i5rsM/wnvnWxrX09iuIwCR
	eSNO/EfcI1x2VtZ24t9QRKKorwkIpbA=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id C8DDA434C0;
	Fri,  8 May 2026 10:57:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E68FC2BCB8;
	Fri,  8 May 2026 10:57:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778237847;
	bh=udQ4Jq6eD/ebeug3+k+Eyz11JbU7qI1F+3+4yt5Acc4=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=LrGgn3Ox5ZGIvBqqowkgjurDUzsmCXxB1b5uzzxiy8ZLH/hepOR/vZa1NGtteFl7L
	 mUQTd+pjUqqVTGu72dUfFT9UGI5ZhoUs4NF0L8tpLntIM9NLIbOrpUIie7FCiOPrTf
	 pKqKx3G/RqSlie0EZWHLy6N9ntkJYHRu3DCv2P2O4Tw9VCneL6ckZUs2qw86zUZ6SO
	 hp35Y1hKpeEGUT6DFHM24oJmowltxQap32QzFKAsTaWYosO7aofUCYY4OfZNVdMMkr
	 0eMqzHPHNEBTEtuWwwd481k3lk0fkN7663OCPUYnDdvbhw/ZlymZO3V/ewc2TPcjhf
	 16jJhr2BzjAjQ==
Message-ID: <f2964e78-0151-4552-b0b5-1b597bf02180@kernel.org>
Date: Fri, 8 May 2026 12:57:24 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] mm/balloon: expose per-node balloon pages in node
 meminfo
To: Hao Ge <hao.ge@linux.dev>, Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, virtualization@lists.linux.dev,
 linux-kernel@vger.kernel.org
References: <20260508094736.142467-1-hao.ge@linux.dev>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260508094736.142467-1-hao.ge@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 03330C000E
X-Stat-Signature: hxiftasz9pdyu3sk3p4yj6yimxpgt6fw
X-HE-Tag: 1778237848-542980
X-HE-Meta: U2FsdGVkX18ZQQDxmMeL7dZD3pVY7nNYWTKdRpk2BME0YDzInFDmH8VGYqgSNRcD7+C8OzPGBMa9iyJ9Yiie12cN5C2JOaokkoOhrAp1kTYWWadB9Kz5NgAOa/9ZPmBfJWAQtKNUb8Oh5dlOS5vZSh4VFRGDJ6sM8jyPavADObRb4sP8VsRHLptL7aaervEDwd7BsiHavG9mHOIHTMZF8po0VsyvQsSQ5LpvF15s18/aHWmMOGrzL0azSinPq53i3zf5VJEU+t9TUF8bfM9p+SqK/54JpU8Nt5PpSd3cH6pF/zzTWG67J5uqueqCRZDMw7hwRbIeBHYORM8W/jB4EWft2ULmgTQOAy84kOwDm9rjJehtw5pdnW5BUyMmLfm5pSmKoy0MfCtHuQ4JZmnEO58z1lsbzqNKhTwLWODRShPZ/37O3z1MbL7E9mtuOI8wn90tjpbtLFI6kwXg5v55OQNdyqykYsy32CKMvbY591Wtt7J93x94O399Q7HcoR9Xx8jdu+ZDHJC2GWeefmCRmd6cpZ4wcP/9tMRdduvElkUPhpoHShcEf4WYU6ZQco6u0JFslVu8fnzuCRR4LpLKiuDfqBBh7V8Q1P5ntEI6h+kD1rFAFE8ZkF3IItGOzVf+Ta0O+0au0cLL6E302pVAMgwQ1t1MeZoOwiMrc+8itFXdHWSoLRVJptqX35REmKwFGFKyLKOUYJL970DRXFtd18+EA6+q9gfD1eiN29zeT9qjucHNvuWSRdD/Pj9iQxerjiXV0PCgyneAHSazgpv9+KaXcBldQJKiFEH6WKKHNdm4GNTLhB1VjgC08AhFo0sZDHfNDh3wHOVOHWSZcqPZoorWN0q09ppOxZXBjxFRcssLNp5knJfyA7UgZeosye4g7U4EmU84Xw79a/r1P9WrQjfAe/PC6bOZjOav1VSCr6lAFnHW2YOV1mPjLGepv1IX5x3D73UrrykLPtLTwBy
 CR82CS5N
 TyMg0rPwTCOqxpLrjBFOXxPPa0/JeeV+Ht6eanhOwLQwL35EhFMZ2A8eSSwE4GSjqolt5JwhNY2+/E5ARnnB7z1fIOIdyPf20VBIDTXSUps8Yn6yd2nw0HUN8VKI3gFn0Ee2f30rFzyct5aPwKa+SGmpjjMwNQIu3BdyLhE+GT2HaO6JpXuaWzHQtdibeZwoCG7AIFS2zDciaivC+bSHikH6ka3Svw+kp7f6L/hjo+NOub85URZKSL7iIGqnmvUuLmk27QqEpLJfcXi5COTPVqerrkw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 5/8/26 11:47, Hao Ge wrote:
> Commit 835de37603ef ("meminfo: add a per node counter for balloon
> drivers") added NR_BALLOON_PAGES and exposed it in /proc/meminfo.
> However, the per-node view at /sys/devices/system/node/nodeX/meminfo
> was not updated, even though the counter is already tracked per-node.
> 
> Add it to node_read_meminfo() so users can see balloon usage per
> NUMA node without having to parse the raw vmstat file.
> 
> Signed-off-by: Hao Ge <hao.ge@linux.dev>
> ---

Patch subject should not start with "mm/balloon:".

"proc/meminfo: " might be the better choice. Likely can be changed when picking up

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

