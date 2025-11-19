Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7C3D1CF31B0
	for <linux-mm@archiver.kernel.org>; Wed, 19 Nov 2025 12:23:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BDF776B0022; Wed, 19 Nov 2025 07:23:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BB7A26B00A4; Wed, 19 Nov 2025 07:23:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ACCD56B00B4; Wed, 19 Nov 2025 07:23:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 9C1236B0022
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 07:23:32 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 657A1B9A29
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 12:23:30 +0000 (UTC)
X-FDA: 84127272180.19.6D11BC3
Received: from mail-ed1-f51.google.com (mail-ed1-f51.google.com [209.85.208.51])
	by imf04.hostedemail.com (Postfix) with ESMTP id 49BA640008
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 12:23:28 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Rii5bGNq;
	spf=pass (imf04.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.208.51 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763555008;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=w0XrMI668P3tvkUw9AIKNvZgD+A366ogSw2G82hvgsQ=;
	b=d6rPcDP37QHWynMK1O6rvdocmg1Xqx0tN5TCRdgwtE7ODH2atsVpZJWC/upXhR7573aMda
	S7OjxQYk5WkK5h3s0rob7JeK5T+j1QLTdoQ/E7kzcNUn3go1JKl6yyrNccvxhbIwmAR9OH
	wksWJTfG0hyoPLUuk5UKKAYkndO/G5U=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763555008; a=rsa-sha256;
	cv=none;
	b=KpMgBnblBRuO2nBzYMunvASDbibVxpBjgKs0sPN2CYfJPtBa6Rr4EgHmUw22eiIi82vTjs
	D3RCq2546Bx98hlHEPWewGef9vgL/1iAATMlK5VEfweHgZWb30d4BaL2JXwJyExqjcMOUw
	m096l0WSL6HE7JCwqJD7F429kPbjTNI=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Rii5bGNq;
	spf=pass (imf04.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.208.51 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-ed1-f51.google.com with SMTP id 4fb4d7f45d1cf-6419aaced59so8964942a12.0
        for <linux-mm@kvack.org>; Wed, 19 Nov 2025 04:23:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763555007; x=1764159807; darn=kvack.org;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=w0XrMI668P3tvkUw9AIKNvZgD+A366ogSw2G82hvgsQ=;
        b=Rii5bGNqlsvtjL4TsCHZ7oD03WGFsuaUF40XF5Tq3IAemJjMQ750ZfUXUJ/Xoj+2L0
         +7uDcKmkQjjXfNYEW2XtshQsoMQqjNTFAzr2tx/+G2SSXz+s2BCfiRyTi5hHBaHFdJiW
         08Ko/DOpRIqieHSElSAo4JMgtdehLKt9lm8tJjQTM80btLbAVuINxNpWp4i63yIfqulF
         zXM5IxOiLYkzZfYnx5AHBRB6havEPQs5mPtx0fCWux48ux+oZn3MMb7sp4MgNVYORg8c
         I4xbT07z8c6oxdnD4lBpPzRoFxtKit75J/HS4ZnjIOAHPY0qDGK6GEPp+9Y2mb0q6zgR
         FMAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763555007; x=1764159807;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=w0XrMI668P3tvkUw9AIKNvZgD+A366ogSw2G82hvgsQ=;
        b=JdzDBZA3ZtdL9vx9H+f+LoWsnGCJQep/5We2JMBVKh8DLQPVF4zZEpluQsi6WWqc9E
         6LlmeHS/FmhJ5/YOVpaqjdCi41VaicK5iSVLXzA3lNhaD2QoMuNe/lhTtkw99BQqYPUP
         Mozpg4bjLJ3/HASA4Ik+80/TT4WRFJRCLJ5hfnPor0liYFibuzWfksYQocHHeLBSAGZd
         I+eytEJ/UMahnRmVI8ohe9t3qIEeKPHvQKbFSTbF6MsUzRQf3OLAR1KWF1MRu4TL+DIl
         1HVAja/992GLE7gdPI7OlfkG4Y1ouYqCj4Z/rLxeLs/9ulC4SKg3xIexEYXWkipq8ksH
         yQ5A==
X-Forwarded-Encrypted: i=1; AJvYcCUFcaCEbjpcfz9MAKFDHs6K3rti6rnq5vR2RSzrbUYY50M9klb5qFhBdiGfnjvDAFUXpa/xmM3Jug==@kvack.org
X-Gm-Message-State: AOJu0Yx5ze5sM4doLKbq5TWVtegVK5dMgL6r7+rZvmr8QvqHDJsJR8qO
	HM4+6FHXLuZUzAauaaxCKaISxdMM19TlwnscnRzssAWrrlaeZQp2+Uzk
X-Gm-Gg: ASbGncvhnEzia7MK/nl6kZA+a49SZ4ctQt1R9DKErJdptRP9reaL28XXLIhVyEcrKKJ
	fKbzs5PouRoFe4G9IQPtcOpM0l6TMgJt+xbIL1sMKyEVMqqWeuDPpUfM+3ld2BpnlU0r1NJwNBg
	8nJKsZpbD2faX/OTrPe2ccXW7m9S1UnCDdSWH+O8/uCLuazAIWxB9cNr02lskLMyb/Gp4qL+vy7
	IurtS0r9B8pvwOzgo7+eLEJ85I4yhWiotUd21lFvDOCMyyOozQdwmJmfqoJZcOXd6ezsnxU5DHZ
	qjvZAMlyAtGpnx+h0M5UbSYHVSpDivs4dntzSMZhUY+0pZznMAvOAenkY2fFU4ExA7GpHqfCz13
	R/x0tLiN9e/hKy5haLPFlbXu7mB5O94XYdb04aImtJOFlkz8YySfcwTaN4EBDj4YRSRJdmmjCy/
	3vNX/SNU6nOyQsNw==
X-Google-Smtp-Source: AGHT+IHO5qH2kvjDZsWGJ+LB4SI840TAY6gesExXlHdFvqNMJ5imJmko/oI81ui1fW31BN4OO9lsZg==
X-Received: by 2002:a05:6402:848:b0:640:b814:bb81 with SMTP id 4fb4d7f45d1cf-64350ebd23dmr19750606a12.32.1763555006504;
        Wed, 19 Nov 2025 04:23:26 -0800 (PST)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-644f13ff4d4sm5729151a12.12.2025.11.19.04.23.25
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 19 Nov 2025 04:23:26 -0800 (PST)
Date: Wed, 19 Nov 2025 12:23:25 +0000
From: Wei Yang <richard.weiyang@gmail.com>
To: "David Hildenbrand (Red Hat)" <david@kernel.org>
Cc: Wei Yang <richard.weiyang@gmail.com>, akpm@linux-foundation.org,
	lorenzo.stoakes@oracle.com, ziy@nvidia.com,
	baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com,
	npache@redhat.com, ryan.roberts@arm.com, dev.jain@arm.com,
	baohua@kernel.org, lance.yang@linux.dev, linux-mm@kvack.org,
	stable@vger.kernel.org
Subject: Re: [PATCH] mm/huge_memory: fix NULL pointer deference when
 splitting shmem folio in swap cache
Message-ID: <20251119122325.cxolq3kalokhlvop@master>
Reply-To: Wei Yang <richard.weiyang@gmail.com>
References: <20251119012630.14701-1-richard.weiyang@gmail.com>
 <a5437eb1-0d5f-48eb-ba20-70ef9d02396b@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a5437eb1-0d5f-48eb-ba20-70ef9d02396b@kernel.org>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Stat-Signature: rknosjukzsotxtj66ocqcwm87gxzksoe
X-Rspam-User: 
X-Rspamd-Queue-Id: 49BA640008
X-Rspamd-Server: rspam01
X-HE-Tag: 1763555008-829923
X-HE-Meta: U2FsdGVkX19o8lxHwl/J4rD3ylRzvoNHLAMkk6vVVkVRqi1CFjKmv3YzTaKFqpXLvZBrg8ICGvZWhMoSh1PK3lZGDt9lOjPiChWZabxDZVsnMcNSSqrYqFMD8zrvaEi1+Sf1zJCOvzR3x9/82/FXMcVo8zr+6UDpZKhtIWxJNDanS4OD/kjY1ZCh2k8VoiaZQoJI0Vr0FLMYdxlHb7wTgdiVrjKvC6evjOCpXUUyKcAWcSc3YeCKzXfZt14M5/lHI92muHo/9MipGdxab9DSUvXkpJOf5t0+5Fd8vqoxtxNivOgLWOydiBfin9InZlp18L2TByQGmWrhfUmmYAPr03iYek1sXL6YoInV39yMRW8z4e1NlvpgNsBhtd7MhKg6EOapVDvWug20Tzrakh7STETjcDX47x1apkWN/EtZtnb/LFgO5jaXt7vgyA8oDZ+Skkuoewi9oyt8pEUc2aesp0w1pHo3lJMs244CSMwCN1USGsXuQe3YMvyN7hmcEdpO1l4OsMsFVMK26zFc/7j7KRlMBHyX5mVibDVvdSvYfqa9NQY3q2SGp6AQh93BGfjr9IM33Uex+98JVYiYxGzNa6f+sBlujqFGzJZ/ieB+6Jdm96P+v30ebR4+2M7gQix2e2u4HzJspcgsbX5I+0cjcrWvTW3jJQZgV47hHMcSdZ5V7/+1lFW3260ej6pq+NryK6f67fnf0MPzw3/7ypMC7wo1LzelxoRe2mmoDvwk2B4KyaZRXVLesZ36zM3H0evC56iA1s4qjwS2LZJCCeIK0NMDGIHJPD6WK7e1vJqAu6OZurUESvdCHAkOlMAtIOTAbpCFfvS7Kydh/vVCEtDJTuu+73sCKpKeMmflID2hoLnUDo1LWukmmkTbRayobk+DC+gRpqb2+RhKO3LbnwLQd5lQLzZnTulmBFK9I27SgfQ49ObOCPvC0GM7XJ1zkpJlls1xurHz8H4ys6IHwB4
 vv5CIZnV
 +Tau6tSAPF49VKy/UUO99Cj0oA5OTEaUXahDT2FZJAZz98nE32BWiQP5Jch6AU8yd/GcRUOCM1XqizOZ9FB86WeLUALzyVArED16LQ++0ZFnO3LC5E+qN9Py5c52axQd879THqcDsLGPiwIyzp2tcCP5wSXOMNeZ5MhV/McMgRdrgBlaVywr6ct+v0+yCz7V+a8hv57JqvrBS6rw8N8bExTtORBNXm8NwwG1rRh5kV2srb4KHh6Tzs8zMXpiJDL6HAQSu5s3AgMExnXAQrSwuO8f9ytgZE5imabsQgnnVwiftlSXmoZq9TA63ElVvF2YqEvYjaEkHfDjVAKw0viP2Z6dGHletW7R2ThBvYynI1QCNBh03cgYZuBCzLBICfYpsz7g6XNrq2qSege+O6U895BT6sZ3XF7K/mnVt5au4qrCK2vSzH/VX4Zz24DbBedUjQ0YT7tQSomROJMpFy/gMhY4aJRFIGlU2Vkb6iLL5AnH5Kc6plTc/5sIKc3OspSNtNhk0DE9RWO7b1TrCO9pSEi4bAFr1s9Yze09YM19EgPHlaQdR06J4z7/LeSuahjLE+4UOL8HXfZSqvUY+yo25SFLs6kSkNTVekOLUvRIUd3EnPZX16vktROjpeegF/WBK4w3aO+pmouWg9jP8OM3ljxqHsS/JpnD1kjuTmBtrhGg8Sxz0NmxPqZxo/KSp5XCJZUUaC14ogXrmyw2TSN3TjVpfz3CWl6W7oanXAX8b3AmcDwOXtCqLqgT6l/cLcrEPpOp/wpU3cq2y5jixCy/ohftiqRrKLCqPEN4dI7kgVz6F/6YAMLhfZ029qAbppFDDOW4lYt/jMzDNQhGRIF7ebuTK5IiQnvTeM2eH9xmuR7ldtCnUxesGRtwkzep8P9mL+zaP+xrns2GMNs/9D+mRj/q0800p6Q56nlIdDIKV4Okg/kukjpmjVODKcQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Nov 19, 2025 at 09:57:58AM +0100, David Hildenbrand (Red Hat) wrote:
>On 19.11.25 02:26, Wei Yang wrote:
>> Commit c010d47f107f ("mm: thp: split huge page to any lower order
>> pages") introduced an early check on the folio's order via
>> mapping->flags before proceeding with the split work.
>> 
>> This check introduced a bug: for shmem folios in the swap cache, the
>> mapping pointer can be NULL. Accessing mapping->flags in this state
>> leads directly to a NULL pointer dereference.
>
>Under which circumstances would that be the case? Only for large shmem folios
>in the swapcache or also for truncated folios? So I'd assume this
>would also affect truncated folios and we should spell that out here?
>

Sorry I don't mention it for my uncertainty.

Will add it.

>> 
>> This commit fixes the issue by moving the check for mapping != NULL
>> before any attempt to access mapping->flags.
>> 
>> This fix necessarily changes the return value from -EBUSY to -EINVAL
>> when mapping is NULL. After reviewing current callers, they do not
>> differentiate between these two error codes, making this change safe.
>
>The doc of __split_huge_page_to_list_to_order() would now be outdated and has
>to be updated.
>
>Also, take a look at s390_wiggle_split_folio(): returning -EINVAL instead of
>-EBUSY will make a difference on concurrent truncation. -EINVAL will be
>propagated and make the operation fail, while -EBUSY will be translated to
>-EAGAIN and the caller will simply lookup the folio again and retry.
>

Oops, I missed this case.

I will rescan users.

>So I think we should try to keep truncation return -EBUSY. For the shmem
>case, I think it's ok to return -EINVAL. I guess we can identify such folios
>by checking for folio_test_swapcache().
>

Hmm... Don't get how to do this nicely.

Looks we can't do it in folio_split_supported().

Or change folio_split_supported() return error code directly?

>
>Probably worth mentioning that this was identified by code inspection?
>

Agree.

>> 
>> Fixes: c010d47f107f ("mm: thp: split huge page to any lower order pages")
>> Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
>> Cc: Zi Yan <ziy@nvidia.com>
>> Cc: <stable@vger.kernel.org>
>
>Hmm, what would this patch look like when based on current upstream? We'd
>likely want to get that upstream asap.
>

This depends whether we want it on top of [1].

Current upstream doesn't have it [1] and need to fix it in two places.

Andrew mention prefer a fixup version in [2]. 

[1]: lkml.kernel.org/r/20251106034155.21398-1-richard.weiyang@gmail.com
[2]: lkml.kernel.org/r/20251118140658.9078de6aab719b2308996387@linux-foundation.org

>> 
>> ---
>> 
>> This patch is based on current mm-new, latest commit:
>> 
>>      056b93566a35 mm/vmalloc: warn only once when vmalloc detect invalid gfp flags
>> 
>> Backport note:
>> 
>> Current code evolved from original commit with following four changes.
>> We should do proper adjustment respectively on backporting.
>> 
>> commit c010d47f107f609b9f4d6a103b6dfc53889049e9
>> Author: Zi Yan <ziy@nvidia.com>
>> Date:   Mon Feb 26 15:55:33 2024 -0500
>> 
>>      mm: thp: split huge page to any lower order pages
>> 
>> commit 6a50c9b512f7734bc356f4bd47885a6f7c98491a
>> Author: Ran Xiaokai <ran.xiaokai@zte.com.cn>
>> Date:   Fri Jun 7 17:40:48 2024 +0800
>> 
>>      mm: huge_memory: fix misused mapping_large_folio_support() for anon folios
>> 
>> commit 9b2f764933eb5e3ac9ebba26e3341529219c4401
>> Author: Zi Yan <ziy@nvidia.com>
>> Date:   Wed Jan 22 11:19:27 2025 -0500
>> 
>>      mm/huge_memory: allow split shmem large folio to any lower order
>> 
>> commit 58729c04cf1092b87aeef0bf0998c9e2e4771133
>> Author: Zi Yan <ziy@nvidia.com>
>> Date:   Fri Mar 7 12:39:57 2025 -0500
>> 
>>      mm/huge_memory: add buddy allocator like (non-uniform) folio_split()
>> ---
>>   mm/huge_memory.c | 68 +++++++++++++++++++++++++-----------------------
>>   1 file changed, 35 insertions(+), 33 deletions(-)
>> 
>> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
>> index 7c69572b6c3f..8701c3eef05f 100644
>> --- a/mm/huge_memory.c
>> +++ b/mm/huge_memory.c
>> @@ -3696,29 +3696,42 @@ bool folio_split_supported(struct folio *folio, unsigned int new_order,
>>   				"Cannot split to order-1 folio");
>>   		if (new_order == 1)
>>   			return false;
>> -	} else if (split_type == SPLIT_TYPE_NON_UNIFORM || new_order) {
>> -		if (IS_ENABLED(CONFIG_READ_ONLY_THP_FOR_FS) &&
>> -		    !mapping_large_folio_support(folio->mapping)) {
>> -			/*
>> -			 * We can always split a folio down to a single page
>> -			 * (new_order == 0) uniformly.
>> -			 *
>> -			 * For any other scenario
>> -			 *   a) uniform split targeting a large folio
>> -			 *      (new_order > 0)
>> -			 *   b) any non-uniform split
>> -			 * we must confirm that the file system supports large
>> -			 * folios.
>> -			 *
>> -			 * Note that we might still have THPs in such
>> -			 * mappings, which is created from khugepaged when
>> -			 * CONFIG_READ_ONLY_THP_FOR_FS is enabled. But in that
>> -			 * case, the mapping does not actually support large
>> -			 * folios properly.
>> -			 */
>> -			VM_WARN_ONCE(warns,
>> -				"Cannot split file folio to non-0 order");
>> +	} else {
>
>
>Why not simply
>
>} else if (!folio->mapping) {
>	/*
>	 * Truncated?
>	...
>	return false;
>} else if (split_type == SPLIT_TYPE_NON_UNIFORM || new_order) {
>...
>

Ah, just not spot this :-(

>> +		const struct address_space *mapping = folio->mapping;
>> +
>> +		/* Truncated ? */
>> +		/*
>> +		 * TODO: add support for large shmem folio in swap cache.
>> +		 * When shmem is in swap cache, mapping is NULL and
>> +		 * folio_test_swapcache() is true.
>> +		 */
>
>While at it, can we merge the two comments into something, like:
>
>/*
> * If there is no mapping that the folio was truncated and we cannot
> * split.
> *
> * TODO: large shmem folio in the swap cache also don't currently have a
> * mapping but folio_test_swapcache() is true for them.
> */
>

Sure.

>-- 
>Cheers
>
>David

-- 
Wei Yang
Help you, Help me

