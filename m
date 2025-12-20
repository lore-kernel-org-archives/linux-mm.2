Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3C10EE668A7
	for <linux-mm@archiver.kernel.org>; Sat, 20 Dec 2025 03:24:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 940C56B0088; Fri, 19 Dec 2025 22:24:12 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9215D6B0089; Fri, 19 Dec 2025 22:24:12 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 858376B008A; Fri, 19 Dec 2025 22:24:12 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 6D7846B0088
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 22:24:12 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 32D281A03F9
	for <linux-mm@kvack.org>; Sat, 20 Dec 2025 03:24:12 +0000 (UTC)
X-FDA: 84238405944.11.0BF6F87
Received: from mail-ej1-f51.google.com (mail-ej1-f51.google.com [209.85.218.51])
	by imf30.hostedemail.com (Postfix) with ESMTP id 3319580002
	for <linux-mm@kvack.org>; Sat, 20 Dec 2025 03:24:09 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=FeMHDBO5;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf30.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.51 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766201050; a=rsa-sha256;
	cv=none;
	b=SoJoF4GiS22eiJbVwMLyrKY43R/moC4SDCURmyivellQSfym9H+lChrNJ7qo6DSNDT2BN+
	Jk0M31RZwWr2yTXg/5vrCG3YNgYqhQuZPpjTMTlaVp28+9k3J0IMj5iYJIVN7N+hXt5eMw
	niHvhvb2FTf1t/NtxtGJG3vXjpRJn1o=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=FeMHDBO5;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf30.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.51 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766201050;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mjaaQbGCilX+QTlDAoBr5owkPKMEsDgEzRlO9ba8qkk=;
	b=ghTd/iQH3gNTeLiL23wlyS/g1bHxftaaSPcyDznPZ9ZRgcpBmCh5a4JK05a4Qe67pOMpM8
	fNuoq9J0oXN2BxJ1lhB9fiz3OGSWXCv6NDGrrCu1MBcVuuyOB4hxsdhUcnFtHfA0yxNZiY
	B87jo1cAg/MEFr3BdtRSedc99qLbNXM=
Received: by mail-ej1-f51.google.com with SMTP id a640c23a62f3a-b72b495aa81so396664466b.2
        for <linux-mm@kvack.org>; Fri, 19 Dec 2025 19:24:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1766201048; x=1766805848; darn=kvack.org;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mjaaQbGCilX+QTlDAoBr5owkPKMEsDgEzRlO9ba8qkk=;
        b=FeMHDBO59Sq+vO+biLo+tcJ5ybux1tnzo1feK2yaj7fNBXyIBeudCjyvwXxxWSXjyU
         V+3YbmkHc14xXKujq8Mn4DIf31AVh2tY3JqyDoIcyh1iT+uH6xPtZ1vidmIcyH3OkJRs
         LnPFlDk7M+sV2kFD0WXWlyRt+cTGpAA4+n6hxgrpczNXknZQpi7uMWU25QunWzl6fTd5
         /oqTuD0rKLM5iraKbCRQCl+OxHczYvWNL13I0Kg97LuFEfTK25w6oXbhj8oMGyWRjZSl
         Cl7nVtmKxmoFdcbEhhNySQxWd3fhrjD1+zJQIEHMtxddM5nFmHKRVyZ3mB+H0RfRm6iU
         uWvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766201048; x=1766805848;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=mjaaQbGCilX+QTlDAoBr5owkPKMEsDgEzRlO9ba8qkk=;
        b=rWAB91oOfcsltg3TvBHK4iwCx5Ap/sZAvRm5syGw6tkBVuJ60SaFNlBT8gXdIeZlZG
         zFpYEhWKm94XPsTRqYBvMlW5l8DN+oZI8QOoYKLdxLLbkGygGoyOBrfMNSRaf1HSkKcJ
         3g7R5DCiu2qUC/IzK4lg7nq4FIlMMC9p+fDQqIeXQR8FL+hQkutkxzkQG29stNJMdpJF
         52b6HzAkphi1Tjeg1GdZhrqRey9laqiu+B8k5hI1H0msBY5oeLRlgu7JFPRSvT/uoCmU
         19Ixa+WeTX38yVfK7/3VGX7VAkNfAb63JW9Rl7gwFNTJJOT0BeYUCmyCdPF2K17lyUJP
         F8oQ==
X-Forwarded-Encrypted: i=1; AJvYcCWezCyfkT3sUWfZHTRy5usFQOGpGH7kZoG1sDErjqVNuS+2hKO3Akt02q5+3BuNcoylptisnMKDPg==@kvack.org
X-Gm-Message-State: AOJu0YyqLfacq/UdFmg8/nmcwVnfrKeLnkMjSlTTrklYd/QXT42Mh4hh
	g8ItCJkfc8BRlJ4Ma4thhPFKLJArjbE1BtzZRRHZ2OPevbrh67PgDTrg
X-Gm-Gg: AY/fxX7jl1uzgeKHiHAKjD/7hO3aYeiJj1jjVLRVnz1GsElli2AO6VoxDnF6VkLYnc2
	/TL3B5CpiBhpdNB+uXBxdaGTbppCs/+1oEB/9KvrE/fOOMOzt/FijYqZDJEgVnlui2uyNLXEW83
	cdWcyM2VNhDci9cY3YmPO+hyxXdDQqqOjb0XGN+35Lc4j2C0biIx7cZNNq3tVnkjFujPWIMDBru
	sVuUJcUesqmI8X/WwGlMMLv3lgy36JDVavV/Lc0/En5GVyrJ4Dvl1goZeCG+tR2aTQpRG3DK+Wo
	XOSvWTI23e65WY+3Wc1Ecw05uxGThaiDevzVYCIqxNsYE74qGYn27pASNEbNypCGhiaVJBHj02/
	VCf7CzFKpVjeyZlJOObVfWxZeiQ/p6GVE6YpK5BFj/v1BLbeCsIwrdqPXUaaB3c08vHsFpnDDHj
	sS7DgREEgOSg==
X-Google-Smtp-Source: AGHT+IEBUU+i5igZdM1AcnFNk8rSk+v7D6YYygZwlK066iTkW8ZtBdmpF1j7kEMa1rmDlFNxsm05+w==
X-Received: by 2002:a17:907:970f:b0:b7c:e597:f444 with SMTP id a640c23a62f3a-b8037261014mr487307566b.54.1766201048229;
        Fri, 19 Dec 2025 19:24:08 -0800 (PST)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b8037ae2de9sm399445466b.26.2025.12.19.19.24.07
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 19 Dec 2025 19:24:07 -0800 (PST)
Date: Sat, 20 Dec 2025 03:24:07 +0000
From: Wei Yang <richard.weiyang@gmail.com>
To: "David Hildenbrand (Red Hat)" <david@kernel.org>
Cc: Wei Yang <richard.weiyang@gmail.com>, akpm@linux-foundation.org,
	lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, vbabka@suse.cz,
	rppt@kernel.org, surenb@google.com, mhocko@suse.com,
	linux-mm@kvack.org, hanchuanhua@oppo.com, v-songbaohua@oppo.com
Subject: Re: [PATCH 1/2] mm: bail out do_swap_page() when no PTE table exist
Message-ID: <20251220032407.xeszwxus664jp7tq@master>
Reply-To: Wei Yang <richard.weiyang@gmail.com>
References: <20251216075943.29593-1-richard.weiyang@gmail.com>
 <20251216075943.29593-2-richard.weiyang@gmail.com>
 <4c2027d3-2665-42e0-8cfa-712b1d8f8870@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4c2027d3-2665-42e0-8cfa-712b1d8f8870@kernel.org>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Rspam-User: 
X-Rspamd-Queue-Id: 3319580002
X-Rspamd-Server: rspam10
X-Stat-Signature: bu173pq9fp9fb7ay45h97hg1tue1enfi
X-HE-Tag: 1766201049-460274
X-HE-Meta: U2FsdGVkX18YrQeIveRwWmBg1l4H2WE3Adw4yX9KamvYJm8IXiBjrPgnXV//9OH5XiOY+c0+Bpkb6aFgcuaqzz3nTi4N5WEeiNtEcOCpLbumm2PlnP7E/ZP4ClZ4lA91OOSv13Na4yYmolqoZ2s7x0+wJro8RN9hyHgbnVOIRCAAf7xql3qwrYcZIqQECr+vcXWP4ow2UuJsw1n9gblz5nUmCLSIrJV8Iii8TsUUoENk/AvEcKGzYpnAd8s1DNksN2d9lYJsaAJx2LRvQiHi9+BZucG7lwMpIBDHXtwct5tQ9H05cNSltp0COxhl4nzLIZqi98smuLaEJGOx7oRpEX5P/8PRCEudCUcqQ7E0Qp80OG2aIOzrz4jz1h/jv+6TfkxloPFnapDt8GmUZM+6gPg1BOpJlFqMhMBJ6GXVT0yztTC47LZsjPvRbMA2HLUqw0R5zvVzzITT37SaoZsiRXGZLYkWtvNB7RFr3ZadYeM3cGClxuwXOyUdUXzEptg8JafmisCH8Bd/2Kr50Xn4KEasNXLZPBaexrG8xGctKnj84nXjLdmLz5FYeeNe1XUPZmD3WfIrYQ+q5chNW47JU9ie3Q2EOLyjHHrPIyXwX35Q17L4mKcAKO+rYA0RKC0g5GBHa+ikrk7JmUlgTbOaLH1kNAgaBI5Xg4c6muPncIa1nmLKnSbaqtoOfgizhf0A0AOIOF3xovWpjHjZWIeLPO5ylNccurc7x3Nt/bCgYoJy1pV27QrugEWwu43kvz7Sx7gtNz+ARtXxTN3TtIuv0J3Dh0aRMqztkFLtYHUnsunVGupyyAdbN+A2WoDwTD5dwyhYEbdap6BkJRnp6IbqUhMyN62kaPRHW387LwkX2Jvk4RJfcmGq+Gg3xPFUcP3csjhmwQgUDosFqiC2FnWZNFd60iLNAFeM8eQJu59zmmDPBJr6V1HKxtSqyP1vgEc2sXI05KHisysKqvGNgNT
 eXRojA4R
 93sI/pLu2xx8jnhBUEY2cRwYLO1gt9zwyyPMJIVBvSrAABIO78E7BcN1poJG+o5OfWLVr23mSJGYqT6vKOkalOIGT4bPWUlyTfmcKhsUN3IZxRhzJV74IbWQrbiSzrlaphXOWh45qZlHquFSBWywy7GTaf1TSVNCSVrgJ/q0/TYMK3YLoEQ/BuKeISg6xdPdpRxLVMNzKRZGx58iEqQjnOBuz9e9KvpItc/o4IKMftmIJEvUiZxTs9mhSScChGdFUfjh7ds4yzNS0pyC7RA6jz60/GyZMb48vfJwAqOh00rpyxpHCX6a+vzJvpuUiRCn6S4iLbpLQCn9q5kgpAEnIEcwnOtwFHBRno409pn/nff6FhATnAjlH4LUTuA7W8MtpRkzF+1zoRc3oI59mgrq+VF/o7PD3N49SF3K1c+txquRatSZbgIJQXUxJYtViWxCmIgElGk9eMQ2An5lWPSi15Ca11IcJYeIjz3frcdO6+OQzE7xoIp4rd77XNSR9KLE6Pelk2Hhh530CDHRLIibDJVucwces9Kytq5rWsXx0i1M29N0vlMn/v2XyY+VPWyayU8EpXetacaKbdcDuQDva0hGa1IFfeKgbri8L5hXUA8BUxG0IPEXgnojUWeJd7SWEs4ZHJcah+diWawfIamV5MZdYFUjvfpkXzSL0b4AaJGfhdRHS5Gv11FKaZPwc+34D3WPINRmCF5UQx0KyKbvQ5BeCtjvxFuo39CqAjvUEcWnBZ35KNI4dFS09IKnmPNWc0T4jB1DGOUBFHJkuVc/GIK6B770Cn3Sz2yCl8OdyPFLyhio=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Dec 19, 2025 at 09:42:16AM +0100, David Hildenbrand (Red Hat) wrote:
>On 12/16/25 08:59, Wei Yang wrote:
>> The alloc_swap_folio() function scans the PTE table to determine the
>> potential size (order) of the folio content to be swapped in.
>> 
>> Currently, if the call to pte_offset_map_lock() returns NULL, it
>> indicates that no PTE table exists for that range. Despite this, the
>> code proceeds to allocate an order-0 folio and continues the swap-in
>> process. This is unnecessary if the required table is absent.
>> 
>> This commit modifies the logic to immediately bail out of the swap-in
>> process when the PTE table is missing (i.e., pte_offset_map_lock()
>> returns NULL). This ensures we do not attempt to continue swapping when
>> the page table structure is incomplete or changed, preventing
>> unnecessary work.
>> 
>> Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
>> Cc: Chuanhua Han <hanchuanhua@oppo.com>
>> Cc: Barry Song <v-songbaohua@oppo.com>
>> ---
>>   mm/memory.c | 4 +++-
>>   1 file changed, 3 insertions(+), 1 deletion(-)
>> 
>> diff --git a/mm/memory.c b/mm/memory.c
>> index 2a55edc48a65..1b8ef4f0ea60 100644
>> --- a/mm/memory.c
>> +++ b/mm/memory.c
>> @@ -4566,7 +4566,7 @@ static struct folio *alloc_swap_folio(struct vm_fault *vmf)
>>   	pte = pte_offset_map_lock(vmf->vma->vm_mm, vmf->pmd,
>>   				  vmf->address & PMD_MASK, &ptl);
>>   	if (unlikely(!pte))
>> -		goto fallback;
>> +		return ERR_PTR(-EAGAIN);
>>   	/*
>>   	 * For do_swap_page, find the highest order where the aligned range is
>> @@ -4709,6 +4709,8 @@ vm_fault_t do_swap_page(struct vm_fault *vmf)
>>   		    __swap_count(entry) == 1) {
>>   			/* skip swapcache */
>>   			folio = alloc_swap_folio(vmf);
>> +			if (IS_ERR(folio))
>> +				goto out;
>>   			if (folio) {
>>   				__folio_set_locked(folio);
>>   				__folio_set_swapbacked(folio);
>
>How would we be able to even trigger this?

To be honest, I haven't thought about it. Thanks for the question.

>
>Trigger a swap fault with concurrent MADV_DONTNEED and concurrent page table
>reclaim.
>

Let me try to catch up with you.

  swap fault is triggered because user is access this range.
  MADV_DONTNEED is also triggered by user and means this range is not necessary.

So, we don't expect user will do these two contrary behavior at the same time.
This is your point, right?

>Is that really something we should be worrying about?
>

Now I question myself why alloc_anon_folio() need to bail out like this.

page fault vs MADV_DONTNEED is not in concern. So page fault vs khugepaged
is the case? But I see khugepaged would mmap_write_lock(), which prevent page
fault in my mind, before collapsing pmd.

I am curious alloc_anon_folio() tries to handle which case here.

>-- 
>Cheers
>
>David

-- 
Wei Yang
Help you, Help me

