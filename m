Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7F6F3CAC5A7
	for <linux-mm@archiver.kernel.org>; Mon, 22 Sep 2025 08:12:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A9E268E000A; Mon, 22 Sep 2025 04:12:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A71DC8E0001; Mon, 22 Sep 2025 04:12:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9880D8E000A; Mon, 22 Sep 2025 04:12:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 709918E0001
	for <linux-mm@kvack.org>; Mon, 22 Sep 2025 04:12:31 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 1008786DE8
	for <linux-mm@kvack.org>; Mon, 22 Sep 2025 08:12:31 +0000 (UTC)
X-FDA: 83916169302.30.C6B55C3
Received: from mail-ej1-f44.google.com (mail-ej1-f44.google.com [209.85.218.44])
	by imf20.hostedemail.com (Postfix) with ESMTP id 05F981C000F
	for <linux-mm@kvack.org>; Mon, 22 Sep 2025 08:12:28 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=bucqfkIS;
	spf=pass (imf20.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.44 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758528749;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UNmDvRMaSkcvZG7ST5TBgZ5i6Q9pv+qPhkMttelgFNc=;
	b=3XLbvAqpDwdcABzGB6kdRLgN9Wrn+/vviw6lQgpf5JAr4QXTJp437y1JPzpwI4MWEOrnyR
	/IbFkUGXEYwcK2hsQJ3xg8ag0hCnyW/i+dXoS14Gm0HbsjTZHAnmsa/nSj2tQH1n1NQe4A
	2zXEpBsqBwr8FD1TSzr7k9hJJiNK71M=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=bucqfkIS;
	spf=pass (imf20.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.44 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758528749; a=rsa-sha256;
	cv=none;
	b=z/nzXGa6Ult2ClyW6o1qDbG5BElc6uwkcjHvqymwTv/apQGOxBo1OlaFf+tASQI+Of9szR
	Pya9M6T6e8JOreq1+dMROUH/z+e7AhvzY3yvpdAWKDNJeqkSyqNlbJ68uHOHr8XPmhobmT
	FOtvZvfAjF/86SpiQrFlCPXbxPl0r8M=
Received: by mail-ej1-f44.google.com with SMTP id a640c23a62f3a-b07d4d24d09so685361166b.2
        for <linux-mm@kvack.org>; Mon, 22 Sep 2025 01:12:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758528747; x=1759133547; darn=kvack.org;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UNmDvRMaSkcvZG7ST5TBgZ5i6Q9pv+qPhkMttelgFNc=;
        b=bucqfkISWQP0SRZ9Kp/9JS5Q8vMY5QbLqoNijmr1Y+3F3Pfbce9a8hFlmpEtdgpD1Y
         jYjcD/M33vpddUmPg26PrfNRb0mf0ifEUvEL3g4IBr3d0XRyRelyuPrMUN5zNPGNn67+
         7PPEpENOxteI0HpGiBsQd52jx6OD1FR66KgVMIYYxLtE9ajDMyac1uMask8yM7Y0iMLO
         Bdckz7g/DwDdX4mDrp2BzNSdkr1ppY6L1sgs08ii2MzjY6gE6SClcz3+kR1tJX1gr2MA
         K8Fb1fMItRs0JTRed0qEGpYu2JqX7vIdcI+ZySo/VHIHMq3I8XkqLilflgJD5OBxtmhF
         Jjzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758528747; x=1759133547;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=UNmDvRMaSkcvZG7ST5TBgZ5i6Q9pv+qPhkMttelgFNc=;
        b=mUmBuL6SAzfvGfdovbA+cMOjTa7WAv5450JXAjqrIghFqavF7p8/v6PiO/+AyNXoBk
         dkS4/CYLPjV2/ferFl6I6RWVstknP9xTtmFjk4oqh+hGJAgs05VaRdiSg69t8ikjcPEm
         8+nE0oeB4H35cPJvKq3Mfym75Jdevk+RrFquOpRsLV4ac/kJfpKSC8idUsnzrrEf9ZaE
         srt0HZ7fJpgh7jDDfQMA8Gd8jFyqV4t0PfqV0/SNPf/Uls+9rLc5CRhCXcyacySSjfz3
         Y+tLvo9lELqU9UL+nTQNrcL/3I1x3Rwv3sFn0BUA7lNdSGf0+pWIRP6hU0yRpNu4UvRz
         pupw==
X-Forwarded-Encrypted: i=1; AJvYcCXHgs95pyTnbv721Tkd5CoSou8k5HkuCU4arwwwjJuFgxaBvhKPoX510HSja023JbMbjRPz74phaQ==@kvack.org
X-Gm-Message-State: AOJu0YzTYK5V+A+YMoHfliB5HwkQHcd1Hcljx4fn57NFLi0UDbDZ4Uy2
	XKbzHZDeSbdwgmZyE2L6W9lhCStlmzzp+e9t3ZIOT7fukxj02a2S0r6p
X-Gm-Gg: ASbGncsWWhK0828WVnes2Qfqqv0E2qe6Kin0C0rdXLJOGGwznO0pW/+U0Fs/2hfA5W6
	PZOwZbzRuysyoPm4gkNMqBnkUtVXltstI8uyUOSoi40yR7vMBWvSgNWfwCnFNz1sixThdROsQtP
	xsKYWkPYFDzTvMjo/QUavE56HGSHGBFd9TanCmkY65KMstmTwg2qbaRM1pWRuxbjFW/ZmGU0L4T
	xcCHujyHVCQ3dYNrkfCXnCu5V1CVjBWX6Qa7kUvFGHMS475nXJGiqOnWklQhdZaa1uz1UO1Curt
	qGNQ3Hfq3PehdRZJb73m8kPHypfpMWhv/gszyxdjKQCdyirAe4R3d8vI+yU4uxUQ1a45+qdCeyD
	tDLiw77xT2TUANn7P/ByO/BbTfQoYodIB
X-Google-Smtp-Source: AGHT+IHSaseFS5jlA28txuPozOKp9ulmfO6fq7wQNDvdaL2AS5cR+Yqp9TgNqu46LTwEVLB7qOxcRg==
X-Received: by 2002:a17:906:c155:b0:b24:3412:7cfe with SMTP id a640c23a62f3a-b24f5b59e7dmr1193447566b.63.1758528747129;
        Mon, 22 Sep 2025 01:12:27 -0700 (PDT)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b29b80eaec6sm425023666b.87.2025.09.22.01.12.26
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 22 Sep 2025 01:12:26 -0700 (PDT)
Date: Mon, 22 Sep 2025 08:12:26 +0000
From: Wei Yang <richard.weiyang@gmail.com>
To: Dev Jain <dev.jain@arm.com>
Cc: Wei Yang <richard.weiyang@gmail.com>, akpm@linux-foundation.org,
	david@redhat.com, lorenzo.stoakes@oracle.com, ziy@nvidia.com,
	baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com,
	npache@redhat.com, ryan.roberts@arm.com, baohua@kernel.org,
	lance.yang@linux.dev, linux-mm@kvack.org
Subject: Re: [PATCH] mm/khugepaged: use [pmd|pte]_addr for better reading
Message-ID: <20250922081226.hsglokm74lh2eng6@master>
Reply-To: Wei Yang <richard.weiyang@gmail.com>
References: <20250920005416.5865-1-richard.weiyang@gmail.com>
 <4fb37530-3826-4ff5-ad7a-dc9dac4937de@arm.com>
 <20250920090228.lovkrpwj23bqdamj@master>
 <93095f34-d7ac-40c7-87c7-60d2c64d4800@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <93095f34-d7ac-40c7-87c7-60d2c64d4800@arm.com>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Rspamd-Queue-Id: 05F981C000F
X-Stat-Signature: co95d9k1hpjjxnmfimx98k5au74iz6gs
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1758528748-855775
X-HE-Meta: U2FsdGVkX1+BUjXrcWTFaH+BOI1BUnhwH75sF00mNHb1FAJdw8UODfeJwab83A/ObV/ea4U3r8M2CdBTSxsOwUZdfiLK6NwVEVqN8PaeTTK496+/amu8smLHKZMbFIuW6gaj+sTDy3iPs+LqqCqXu40oY8mE/h3cIufGnR9yUT/UvBozb1hUSSquYgV/ZFENCjubxXB99l5S/XoC38WhmDDQGH1/pMVvO9inuNn+ghpAnQUL4LbI6lnRUveSCqLo8dGHdKE0MwGvzLomIVfTa23gNbIpaDHMT6NL5Vm9ifBhxGAomBfHRDrQ/V3xdzJrnygZNhBy9TsE+hsKMagqnxvWCPmReSje+QvPEQAVrw5Iu3BUzSlY6JQatjjNw0Aa8KIvjpuSY2vDX9ipjIayfVYqnm2yG23SaCuVONwfUMg81dh4hbZ9UyENZJmRYJSWHN2wwyy6siZPhM+nV5FXa1NTgNUM7Mj35kOc9X8FGHrWFHLpYboqiZmYC+QnR5ETfX/5H7ikm6v/G62XUExkxZjOcUTg6ToIzfMPLmroJcMP3f0m1cxmX+DduUaubNAHxV6o479TehQdkORmvTZj/r0SzFoIveuks6KY8xk3R+Dg5pDEg9BiaG5LeD43y+FgkrCnUFcXjJtUpzTWVb7+6ZMhd8EnQ8Rm02vhooIvi9beP6kKAQmuuHDt5vZzHV2IYmpqZbNMKJYV9C8N2pP9ZTdBMWiBmp4OwAOfTfcH4/7tN7bE30zgyLSDqs5ISEGKK+jyJ2HiYRNj1kXWIGxnugv1ECGGGqSIE2/vQintztPvCN3SBpIJDHgC7pEmuBjeO4SGAuA5/MhbT/phPGUas3cjTQDijQjvLFCUQSWA+7G+NUfSuHjHpP14GVqh2iDY1JQvMlruy9PBGEn96zpUGsl/P4t+jizEzWIxvXm03tMURkk+eBexbW4hhyeeJunImFN+4gpbsmCDx+le1u1
 aQDVlT33
 VSrMRPJo6VL+xNTVNYBzMB6fELGeEsMEyHouRNlKkUonz3oSJK4RpPSPRhP1ZoH5QU56nWdbFkRdclwDvfKw6lrxl0PMvgTvFi1JRmuzY77dlp6t6Ilh+sKR5fTCN3j65cdgOiU+guM1pji4AF1by51ql8S8+s3X2l5pg5q4a+TrfiCiAJy6ZQu9Mm5lHnYCH0erysabd/laOgS2AWek9JDOBDIG4jJuyRmh2G0HRId96WWlk0FAGtS/M4kiIcVbw9uc78IZIs74RF+yuSTUnPjcKc6aVtsgtJD/OLcLtr6rrOcuOCYjHcd4HOMV4aRhIoGQZYePNNaE/K2nOlm9VwgEn2z50owCYAwoS2yc8Pm5PPbmcdZUFkG/GkWGY5bml4HoC2rOgmXJpjwOVWNNP2t9hxf8NvldfJoOEN9lQ8efXfacVfr3nYeJdbyDnJUm2yJw2vNYdqaWouTQMyFqT+y125i5RbmhCtvF2JSRS6atzKmYVvdkP1bCvHvP9lvaqcPCQxQnfOgEWgRYrtxhE7juep8PHLizFbpjU8gq+5nU4NAaDvbdKIoXMYJaKN5GLlHxYA9M6lDu48koA0Y+xFANyqN8yjS/jbcScO4nKlVJTd11D4cNA6elWNLs6vGxXdcMA2NHba1UFG2ZcCOFi8KQf2gsUOQTczeD0bopgqPMCvC6i0yYw/b0rz6DQv4WlcKxV6t5hin64WEAs21dm08xOSYQZuWXDWH2Z5GW6dSXkIebY7xqnT9ns88oOlSGLWY6vDgwz+Qt3fAfrPDftQG0M7B3wh048YnwjpHimwk6CS1WBd3arx7AymDIc8PwWFG5R9lCCQlno80Q=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Sep 20, 2025 at 06:01:59PM +0530, Dev Jain wrote:
>
>On 20/09/25 2:32 pm, Wei Yang wrote:
>> On Sat, Sep 20, 2025 at 10:21:56AM +0530, Dev Jain wrote:
>> > On 20/09/25 6:24 am, Wei Yang wrote:
>> > > When collapse a pmd, there are two address in use:
>> > > 
>> > >     * address points to the start of pmd
>> > >     * address points to each individual page
>> > > 
>> > > Current naming is not easy to distinguish these two and error prone.
>> > > 
>> > > Name the first one to pmd_addr and second one to pte_addr.
>> > > 
>> > > Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
>> > > Suggested-by: David Hildenbrand <david@redhat.com>
>> > > ---
>> > >    mm/khugepaged.c | 43 ++++++++++++++++++++++---------------------
>> > >    1 file changed, 22 insertions(+), 21 deletions(-)
>> > > 
>> > > diff --git a/mm/khugepaged.c b/mm/khugepaged.c
>> > > index 4c957ce788d1..6d03072c1a92 100644
>> > > --- a/mm/khugepaged.c
>> > > +++ b/mm/khugepaged.c
>> > > @@ -537,18 +537,19 @@ static void release_pte_pages(pte_t *pte, pte_t *_pte,
>> > >    }
>> > >    static int __collapse_huge_page_isolate(struct vm_area_struct *vma,
>> > > -					unsigned long address,
>> > > +					unsigned long pmd_addr,
>> > >    					pte_t *pte,
>> > >    					struct collapse_control *cc,
>> > >    					struct list_head *compound_pagelist)
>> > >    {
>> > >    	struct page *page = NULL;
>> > >    	struct folio *folio = NULL;
>> > > +	unsigned long pte_addr = pmd_addr;
>> > >    	pte_t *_pte;
>> > >    	int none_or_zero = 0, shared = 0, result = SCAN_FAIL, referenced = 0;
>> > >    	for (_pte = pte; _pte < pte + HPAGE_PMD_NR;
>> > > -	     _pte++, address += PAGE_SIZE) {
>> > > +	     _pte++, pte_addr += PAGE_SIZE) {
>> > >    		pte_t pteval = ptep_get(_pte);
>> > >    		if (pte_none(pteval) || is_zero_pfn(pte_pfn(pteval))) {
>> > >    			++none_or_zero;
>> > > @@ -570,7 +571,7 @@ static int __collapse_huge_page_isolate(struct vm_area_struct *vma,
>> > >    			result = SCAN_PTE_UFFD_WP;
>> > >    			goto out;
>> > >    		}
>> > > -		page = vm_normal_page(vma, address, pteval);
>> > > +		page = vm_normal_page(vma, pte_addr, pteval);
>> > >    		if (unlikely(!page) || unlikely(is_zone_device_page(page))) {
>> > >    			result = SCAN_PAGE_NULL;
>> > >    			goto out;
>> > > @@ -655,8 +656,8 @@ static int __collapse_huge_page_isolate(struct vm_area_struct *vma,
>> > >    		 */
>> > >    		if (cc->is_khugepaged &&
>> > >    		    (pte_young(pteval) || folio_test_young(folio) ||
>> > > -		     folio_test_referenced(folio) || mmu_notifier_test_young(vma->vm_mm,
>> > > -								     address)))
>> > > +		     folio_test_referenced(folio) ||
>> > > +		     mmu_notifier_test_young(vma->vm_mm, pte_addr)))
>> > >    			referenced++;
>> > >    	}
>> > > @@ -985,21 +986,21 @@ static int check_pmd_still_valid(struct mm_struct *mm,
>> > >     */
>> > >    static int __collapse_huge_page_swapin(struct mm_struct *mm,
>> > >    				       struct vm_area_struct *vma,
>> > > -				       unsigned long haddr, pmd_t *pmd,
>> > > +				       unsigned long pmd_addr, pmd_t *pmd,
>> > >    				       int referenced)
>> > Will this be a problem when mTHP collapse is in? You may have the starting
>> > address lying in the PTE table.
>> > 
>> > Personally "haddr" is pretty clear to me - I read it as "huge-aligned addr".
>> > I will vote for naming the starting addresses everywhere as "haddr", and use
>> > addr as the loop iterator. This is a short name and haddr will imply that it
>> > is aligned to the huge order we are collapsing for.
>> > 
>> So your suggestion is
>> 
>>      pmd_addr -> haddr
>>      pte_addr -> address
>
>pmd_addr -> haddr
>pte_addr -> addr
>

Take another look into the code.

The change touch three functions:

  __collapse_huge_page_isolate()
  __collapse_huge_page_swapin()
  hpage_collapse_scan_pmd()

Use pmd_addr/pte_addr look reasonable for hpage_collapse_scan_pmd().
And haddr/addr would be suitable for the other two.

Is this ok for you?

-- 
Wei Yang
Help you, Help me

