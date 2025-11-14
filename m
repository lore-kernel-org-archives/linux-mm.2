Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 96C40CDB47A
	for <linux-mm@archiver.kernel.org>; Fri, 14 Nov 2025 03:03:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E6B348E0011; Thu, 13 Nov 2025 22:03:07 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E1B6E8E0002; Thu, 13 Nov 2025 22:03:07 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D0A658E0011; Thu, 13 Nov 2025 22:03:07 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id BB4018E0002
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 22:03:07 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 646BD140260
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 03:03:07 +0000 (UTC)
X-FDA: 84107716014.25.5FC18EE
Received: from mail-ed1-f44.google.com (mail-ed1-f44.google.com [209.85.208.44])
	by imf23.hostedemail.com (Postfix) with ESMTP id 54056140009
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 03:03:05 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=BlUdTQE0;
	spf=pass (imf23.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.208.44 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763089385;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wImo6xIEAtfnesgyH3gpiEpBXEt/Sogp+5hWTrSBLa8=;
	b=k4hyLGTnnAA6yElDDIiWm6OQOTaG7lNMG9FVi1nW6pzE9pzHjdmjUaVEjM/+KRwF0Z47yP
	ZbfRuWarFUc/T0M7OUpHNZ7+plVYDS4yp3nrPmFLNbZsctVtAXnD2Pfk/JQ3QLDUFkIky5
	694UcswEF+FEuQ6ZVCUwYaIj6i+A11U=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=BlUdTQE0;
	spf=pass (imf23.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.208.44 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763089385; a=rsa-sha256;
	cv=none;
	b=Xhw4WmA0073bckqowvZwlKTxiPA5AFMNfezsOKZSbNhTx1qPoVrKAoLXyt9e8O3veA7RSA
	asgYci8uNOXdyB4R1rNAlX/RNtbFVBjCFGS+SCkw66uQ45BwQNdb/hssaXTRars6MBgpkj
	cUfBr9FJij6qM3I4DddPZ4shDmj+zZc=
Received: by mail-ed1-f44.google.com with SMTP id 4fb4d7f45d1cf-6419aaced59so2344575a12.0
        for <linux-mm@kvack.org>; Thu, 13 Nov 2025 19:03:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763089384; x=1763694184; darn=kvack.org;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wImo6xIEAtfnesgyH3gpiEpBXEt/Sogp+5hWTrSBLa8=;
        b=BlUdTQE0WCBF8LvpQsuLQO3KDclUThSzZ8kfTLEOTR0lZV2exKGRVXWqsIpi4bX/qi
         gR/rqCH6weYbur97GwrCRZRNjuEPU5SZZQXDQW7hajISQG/1WBM+/YBZ7F6DOzs9wmok
         TvhqiKprHRV0OVgbP8hAaqTv9K2uAryGL8xhk+A1ZHcsmcAHa9UbVt0l8ugOi9DmYCHg
         pC9iCJRK6+zC7xXI/0wtbzu0H+l0YPkHfq3lVYqUtlTFAQ2WhLvVxZpA45pIHsASxGDG
         tUJ1kC8csWuWbYSppzKlt/qq6YP8V9kQ3OvpozXb0mxeoQENc93Jkmsp4QkrH51assH9
         YSww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763089384; x=1763694184;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=wImo6xIEAtfnesgyH3gpiEpBXEt/Sogp+5hWTrSBLa8=;
        b=DKC3dVmo4Xzloy+GiBcAjQWm/rska2Mo49GjMClIDzzxrbjexE5BfZFYjF05EvkPse
         tQnPkU+lRO0Pk3b8EyRZmCb4A603H3Wh0M9OpuNGUzcrK81P01mjJ3jvcmUnSNuH6flH
         XnbPw1+QtvgczufM8rBGDuRimTAGqz15loAgvkkEHow+X0Gv9vQj/CfkggIL/kqjd46N
         F4rEbDgkTPhnYBJgRBEry/S4fOxa8j4VkzJ6cu66uQW6gF7sStOd4PmfnLP91G/1Q23p
         IoXScxTFlmna0FdkTnL7fYx+da9MCXnVTzuI+zBwgCqlT/7Uiw/AsyA71grtW3tG3zjA
         GY2w==
X-Forwarded-Encrypted: i=1; AJvYcCWkXFAJJKRnTWIdq1AFdCv2stwKAVDj0Y7M/Rv3axoE50mlaFP5ASoM+gP5eLJb/pE2qjsmSm8nEw==@kvack.org
X-Gm-Message-State: AOJu0YwEb8j8r4bvPvpCjlmA4Dh5YAscr8feuM2EdOO+pDBhnwVP7cQl
	hyPdXIxYB5Z80R8ApjWrLTp8gQaX/oGjEyc3NxgTYaP/nBoYBu7UAg+w
X-Gm-Gg: ASbGncswfBN4TpGpFVnnuriaG0XQb9lcIY/eT7z2u8Xat+QuhGXpMIgRMyAavJz+vgk
	HIXeuPnS/tBNI8T6p3vL4DhTQiCCOkZwPQbEHKs+jYzuBnQbhcJYt5TCq6xmHDtJprahKjM7Ael
	Fr9Irh/8Yqgolf5ki3USkuQet4m1K/4e4mNFGvt2bYH/TFbOo14exzuO9Jp3nAjGmLHjSNtFaQI
	69ydU+kJvQ15eLMOzc+2CuTau2D7RXnqnqeMEcqqsPjfZFJDH1zNFEVReQ1vzA7HMadluRx0Srk
	Y1N7XeCqBZhrIpTmJBE+icuJeSuW3JqnWgGXM7VAqlzNdDrjumM+zp6jdopub7QeIZKuZztZK5d
	fyc0komreaKu9WrxlOnQ1RvvRIUZOKwinWJoskBF2vcuXy+Evy3Sqrs6dFdKjuc9aIF+HWlP8EZ
	4AQTHpxM1cldaeGOy8wNF+t2be
X-Google-Smtp-Source: AGHT+IEV04c87GuvAA1wLw2kSkuvNfKUylUDEw/id+LhUDT9bMvUUiGYc56hplZYQbQSZ1c7lFEG2A==
X-Received: by 2002:a17:907:7e93:b0:b70:4757:eb01 with SMTP id a640c23a62f3a-b73678f47c5mr144816666b.32.1763089383745;
        Thu, 13 Nov 2025 19:03:03 -0800 (PST)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-6433a4c5834sm2601597a12.33.2025.11.13.19.03.02
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 13 Nov 2025 19:03:02 -0800 (PST)
Date: Fri, 14 Nov 2025 03:03:01 +0000
From: Wei Yang <richard.weiyang@gmail.com>
To: Wei Yang <richard.weiyang@gmail.com>
Cc: Zi Yan <ziy@nvidia.com>, akpm@linux-foundation.org, david@kernel.org,
	lorenzo.stoakes@oracle.com, baolin.wang@linux.alibaba.com,
	Liam.Howlett@oracle.com, npache@redhat.com, ryan.roberts@arm.com,
	dev.jain@arm.com, baohua@kernel.org, lance.yang@linux.dev,
	linux-mm@kvack.org
Subject: Re: [Patch v3 2/2] mm/huge_memory: merge uniform_split_supported()
 and non_uniform_split_supported()
Message-ID: <20251114030301.hkestzrk534ik7q4@master>
Reply-To: Wei Yang <richard.weiyang@gmail.com>
References: <20251106034155.21398-1-richard.weiyang@gmail.com>
 <20251106034155.21398-3-richard.weiyang@gmail.com>
 <0D94CF57-A9C9-4C01-A9E5-CE47AE3F10EB@nvidia.com>
 <20251107011721.ez6pile62o3vmjz3@master>
 <136E8B1C-3352-412C-8038-627F5CC8A112@nvidia.com>
 <20251107024902.6qu5h6rsmwktzutm@master>
 <9271B00E-FF43-4EA5-B180-7A509E839DEB@nvidia.com>
 <20251107072944.zvqvr4kyibyofhuw@master>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251107072944.zvqvr4kyibyofhuw@master>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 54056140009
X-Stat-Signature: wjnpo78amytr6uw318fk5pd18f1xnt9w
X-Rspam-User: 
X-HE-Tag: 1763089385-216868
X-HE-Meta: U2FsdGVkX18cYf2xm5CxVWR8Mi8mz0jbTVb8W6Jhb8OVeFb/T/ivBBucAbmzJvUqmx9MHFagxPggVQEy530csEDS1FP0NTqIJOoEbZdF8D1SnhVWD7/StNAKbEmKFdEcVGwZnroZWD5PloD/lqVUwPPpwneTkhVR72Rq4knQV87E81uXUvI0tcguB8UKdrZt+8mo27VinWvBZerzLpcpMEdcZu48HULVKTuwObrMh6dGfTvs5qiAvEQ6I5xNGDi40HP5woLvf/u/xbWNQGtihzsYRRwqnhUUhHeeDxPyg+pa9w+YAXsOAsAusUD1LKqwBUqWstdh5F7vAEMsdmVkw7tz9vIw5c61OkGK492YWL/5kKl+tD7VNsOetkckWAB3bZWChuH3RTFqp8BmhRWAJswtvJfAyUUOwnYrS+chKDu1NFq4Lb2SfoSujk2yFRGkltZ6flExWgMW/pq+t3tJdt/CNMux7v33h6FljkO4kmsMqDg+D5E0YOQYURGd8uF/y5G9j5A0nTFOTfddyz0c/5B521XoHLQ0DA1Ax41ZJ1zBdk/DnpnewIAV/gK0IpTwR0cUFbKKCLY1nTMwxy20xnBqszT8OOckMk1JeYW7P/8PR55ZDFvdhpKE3EMbpwklnwYhjcLEAGAJyBnm9sh4zdwfQGeFk4RHueN5RXaohbeBuNGn+rGxWwAUP1d6EpjN/7pBQYAnaqT2xL1G0Cbt0Tvgp8fR1l1JCI3z/eMSpSpYek0IHDiOedwX5JtIt1aAlzL60DcuWifXsryOxwY2XbTD0r3AS+cTq6gJpzA0T+WXKNb+OZSZ5cNE8XgeANCSo1kvRfjmF9GB27v8jyWNU/2cCvJ0dWX1MXPxm/yzb1e3WKsSgOv5JWrn9QwWHvy/8ze3KWTAH0cjcepZMmkGiRws5LdKnqcAWnEO1jG0tY+eLH92mbpH7BaeDp6BB0EywFdhkcKL81BaveSfoFD
 d6svcon7
 kJ0Vply6JyUilTQ+9H6xDaX57Tkp3ZKeekMhm81cnQcgIoxAGj2tRZ7H9yXTpVrL+KdDL1MfXZoU52Ds3NmignbSKuymuDPKth0RIuBSg6cr8O+eSyyXqrb8ku3UvhSjGcDLFmLazaNzK7RULfpa+vZY6RsNf1OKlTGSxaehkzF7o76JhPFckXxKWETQGdpRN44Rstan4UjhhuckEbVd8Cx0I0rUFUOSu9MtCQe38NuntHETN9sAnEdyR4jGbxpQJh1pIMqf4T14TWNu3wLVr1VnpybNMqHoghnfrYkGaH5d6mhowXn01jrmeJnx1J3O5pL7gRxuOQJ04idOkqQl0mI/slv0XHTPplq/rajzf2mz6u5oa+rv3UYy+7q8iSdV1Fg4kWCgc3MHul6VM/rpR68Xzk1JtqclmTImhl/DX51bqJa/gi5MhlikYCvPv87Sice7wiXz3AJXglCxkF/mtIow27fg6WI6RdSAx7ARShlYqOrQ8nH9KRk2b4PSvENsZvJ8PLhQOVIbj3mGtLX5aHyUir3NTjw4VkaXY87g/PqGFBfUa75dAQ4IR0KyesaKZ/JUyf3fOPq/NHsGmO7FdCYKD8ngC+D53yPaAihr7tJ8sprEDiAGUTNkgOy1UaTm88KVOFFGwVbaSrAot14SFWapBlEPy5lyKDcwi5TpMb48m11AAUEzGrZ95jlP4t9dJEERx6i1lxVMobGxA+c7Bkj4Zz+MLIZjG1gq7VJ/9j4Vj3B6SwaccJV04PCX1U0gLMtr9+x4StlKoAiKsq6/KZVPKR8bbbI7KTX/MAjPWXRNxAsctDX8lluGjM/sQJb1niG6A
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Nov 07, 2025 at 07:29:44AM +0000, Wei Yang wrote:
>On Thu, Nov 06, 2025 at 10:21:21PM -0500, Zi Yan wrote:
>>On 6 Nov 2025, at 21:49, Wei Yang wrote:
>>
>>> On Thu, Nov 06, 2025 at 09:07:22PM -0500, Zi Yan wrote:
>>>> On 6 Nov 2025, at 20:17, Wei Yang wrote:
>>>>
>>>>> On Thu, Nov 06, 2025 at 07:46:14PM -0500, Zi Yan wrote:
>>>>>> On 5 Nov 2025, at 22:41, Wei Yang wrote:
>>>>>>
>>>>>>> The functions uniform_split_supported() and
>>>>>>> non_uniform_split_supported() share significantly similar logic.
>>>>>>>
>>>>>>> The only functional difference is that uniform_split_supported()
>>>>>>> includes an additional check on the requested @new_order.
>>>>>>>
>>>>>>> The reason for this check comes from the following two aspects:
>>>>>>>
>>>>>>>   * some file system or swap cache just supports order-0 folio
>>>>>>>   * the behavioral difference between uniform/non-uniform split
>>>>>>>
>>>>>>> The behavioral difference between uniform split and non-uniform:
>>>>>>>
>>>>>>>   * uniform split splits folio directly to @new_order
>>>>>>>   * non-uniform split creates after-split folios with orders from
>>>>>>>     folio_order(folio) - 1 to new_order.
>>>>>>>
>>>>>>> This means for non-uniform split or !new_order split we should check the
>>>>>>> file system and swap cache respectively.
>>>>>>>
>>>>>>> This commit unifies the logic and merge the two functions into a single
>>>>>>> combined helper, removing redundant code and simplifying the split
>>>>>>> support checking mechanism.
>>>>>>>
>>>>>>> Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
>>>>>>> Cc: Zi Yan <ziy@nvidia.com>
>>>>>>> Cc: "David Hildenbrand (Red Hat)" <david@kernel.org>
>>>>>>>
>>>>>>> ---
>>>>>>> v3:
>>>>>>>   * adjust to use split_type
>>>>>>>   * rebase on Zi Yan fix lkml.kernel.org/r/20251105162910.752266-1-ziy@nvidia.com
>>>>>>> v2:
>>>>>>>   * remove need_check
>>>>>>>   * update comment
>>>>>>>   * add more explanation in change log
>>>>>>> ---
>>>>>>>  include/linux/huge_mm.h |  8 ++---
>>>>>>>  mm/huge_memory.c        | 71 +++++++++++++++++------------------------
>>>>>>>  2 files changed, 33 insertions(+), 46 deletions(-)
>>>>>>>
>>>>>> LGTM. Thanks. Reviewed-by: Zi Yan <ziy@nvidia.com>
>>>>>
>>>>> Hi, Zi
>>>>>
>>>>> I am thinking whether it is proper to move the check (new_order < min_order)
>>>>> from __folio_split() to folio_split_supported(). So that we could bail out
>>>>> early if file system couldn't split to new_order.
>>>>>
>>>>> Not sure you like it or not.
>>>>
>>>> It sounds reasonable. My only concern is that that might add another
>>>> indentation to the else branch in folio_split_supported().
>>>>
>>>> You can send a patch, so we can see how it looks.
>>>>
>>>
>>> Here is what come up my mind.
>>>
>>> If !CONFIG_READ_ONLY_THP_FOR_FS, we directly compare new_order and min_order.
>>>
>>> If CONFIG_READ_ONLY_THP_FOR_FS, one thing I am not sure is for the khugepaged
>>> collapsed THP. If its min_order is 0, it looks we can cover it with following
>>> check.
>>
>>1. mapping_large_folio_support() checks if mapping_max_folio_order() > 0, meaning
>>   !mapping_large_folio_support() is mapping_max_folio_order() == 0,
>>2. mapping_max_folio_order() >= mapping_min_folio_order(),
>>3. combining 1) and 2) means
>>   mapping_min_folio_order() <= mapping_max_folio_order() == 0,
>>   meaning mapping_min_folio_order() == 0.
>>
>>so a FS without large folio support always has min_order == 0.
>>
>>>
>>> Look forward your insight.
>>>
>>> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
>>> index dee416b3f6ed..ef05f246df73 100644
>>> --- a/mm/huge_memory.c
>>> +++ b/mm/huge_memory.c
>>> @@ -3704,8 +3704,8 @@ bool folio_split_supported(struct folio *folio, unsigned int new_order,
>>>  		if (new_order == 1)
>>>  			return false;
>>>  	} else if (split_type == SPLIT_TYPE_NON_UNIFORM || new_order) {
>>> -		if (IS_ENABLED(CONFIG_READ_ONLY_THP_FOR_FS) &&
>>> -		    !mapping_large_folio_support(folio->mapping)) {
>>> +		unsigned int min_order = mapping_min_folio_order(folio->mapping);
>>> +		if (new_order < min_order) {
>>
>>This check is good for !CONFIG_READ_ONLY_THP_FOR_FS, but
>>for CONFIG_READ_ONLY_THP_FOR_FS and !mapping_large_folio_support(),
>>min_order is always 0, how can new_order be smaller than min_order
>>to trigger the warning below? You will need to check new_order against
>>mapping_max_folio_order().
>>
>>OK, basically the check should be:
>>
>
>Thanks for your analysis.
>
>>if (new_order < mapping_min_folio_order() || new_order > mapping_max_folio_order()).
>>
>
>This reminds me one thing, we don't check on max_order now.
>
>For example, the supported split order is [3, 5]. But new_order is set to 6.
>
>In current kernel, we don't do this. try_folio_split_or_unmap() pass
>min_order. But selftest will split from pmd_order - 1.
>
>>Then, you might want to add a helper function mapping_folio_order_supported()
>>instead and change the warning message below to "Cannot split file folio to
>>unsupported order [%d, %d]", min_order, max_order (showing min/max order
>>is optional since it kinda defeat the purpose of having the helper function).
>>Of course, the comment needs to be changed.
>>
>>Hmm, but still how could the above check to trigger the warning when
>>split_type == SPLIT_TYPE_NON_UNIFORM and new_order is 0? It will not
>>trigger, since new_order (as 0) is supported by the mapping.
>>
>>I guess the min_order check code has to be in the else branch along
>>with the existing "if (split_type == SPLIT_TYPE_NON_UNIFORM || new_order)".
>>
>
>I am trying to think another way.
>
>For uniform split, after-split folio order is new_order.
>For non-uniform split, after-split folio order is [new_order, old_order - 1].
>
>So I come up following draft change.
>
>diff --git a/mm/huge_memory.c b/mm/huge_memory.c
>index dee416b3f6ed..873680ab4cbb 100644
>--- a/mm/huge_memory.c
>+++ b/mm/huge_memory.c
>@@ -3703,28 +3703,18 @@ bool folio_split_supported(struct folio *folio, unsigned int new_order,
> 				"Cannot split to order-1 folio");
> 		if (new_order == 1)
> 			return false;
>-	} else if (split_type == SPLIT_TYPE_NON_UNIFORM || new_order) {
>-		if (IS_ENABLED(CONFIG_READ_ONLY_THP_FOR_FS) &&
>-		    !mapping_large_folio_support(folio->mapping)) {
>-			/*
>-			 * We can always split a folio down to a single page
>-			 * (new_order == 0) uniformly.
>-			 *
>-			 * For any other scenario
>-			 *   a) uniform split targeting a large folio
>-			 *      (new_order > 0)
>-			 *   b) any non-uniform split
>-			 * we must confirm that the file system supports large
>-			 * folios.
>-			 *
>-			 * Note that we might still have THPs in such
>-			 * mappings, which is created from khugepaged when
>-			 * CONFIG_READ_ONLY_THP_FOR_FS is enabled. But in that
>-			 * case, the mapping does not actually support large
>-			 * folios properly.
>-			 */
>+	} else {
>+		/*
>+		 * Some explanation here.
>+		 */
>+		if (new_order && !mapping_folio_order_supported(new_order)) {
>+			VM_WARN_ONCE(warns,
>+				"Cannot split file folio to unsupported order: %d", new_order);
>+			return false;
>+		}
>+		if (split_type == SPLIT_TYPE_NON_UNIFORM && !mapping_folio_order_supported(old_order - 1)) {
> 			VM_WARN_ONCE(warns,
>-				"Cannot split file folio to non-0 order");
>+				"Cannot split file folio to unsupported order: %d", old_order - 1);
> 			return false;
> 		}
> 	}

Hi, Zi Yan

Does it look good to you?

-- 
Wei Yang
Help you, Help me

