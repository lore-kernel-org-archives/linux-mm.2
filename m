Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DC0C3CAC582
	for <linux-mm@archiver.kernel.org>; Sat, 13 Sep 2025 00:12:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 47E288E000A; Fri, 12 Sep 2025 20:12:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 429428E0001; Fri, 12 Sep 2025 20:12:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 33D7F8E000A; Fri, 12 Sep 2025 20:12:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2115F8E0001
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 20:12:04 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id DFB2858DAB
	for <linux-mm@kvack.org>; Sat, 13 Sep 2025 00:12:03 +0000 (UTC)
X-FDA: 83882299326.06.93DCD10
Received: from mail-ej1-f44.google.com (mail-ej1-f44.google.com [209.85.218.44])
	by imf18.hostedemail.com (Postfix) with ESMTP id C70071C0009
	for <linux-mm@kvack.org>; Sat, 13 Sep 2025 00:12:01 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=GOIqqNsV;
	spf=pass (imf18.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.44 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757722321;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cfDQQUU5oGkiiYtYM/v8xrRfjVH+9wKoO55lVwiMx/A=;
	b=CVHkVhIGwBeujIUL+iZ9R1Y90MwYp+h7NDi4Hk09LfeXlRa3ZZdf9K3GQh1qBju4xez1Cx
	/7o+SQIraLKefLUgJZeZi6KaiCuHpkVuiZz1OpKm1x/WwNGg5QoKNAwgh4ld0n5NekTRmO
	ZPr1ON50sDehqURRF7uxWj+IewQ2O7M=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757722321; a=rsa-sha256;
	cv=none;
	b=2psIi1d+jV1hFPk4pYv32giBrF0SFwocUbOBlfHe/hqF7ztTfYWT8pGfJduLEz+QvhBAdJ
	YfxdQGAji9p5cf+2AYI8/er+4NSS2r/nS5yTD3D2pPJcEsvuL2UwjtLuogU5LJakgCrLP+
	rp4IJhXWhwPcXqEDweYOgC9gSMD12q8=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=GOIqqNsV;
	spf=pass (imf18.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.44 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-ej1-f44.google.com with SMTP id a640c23a62f3a-b0787fc3008so350864766b.3
        for <linux-mm@kvack.org>; Fri, 12 Sep 2025 17:12:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757722320; x=1758327120; darn=kvack.org;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cfDQQUU5oGkiiYtYM/v8xrRfjVH+9wKoO55lVwiMx/A=;
        b=GOIqqNsVXXkMZ9ZkZdHZ9n+RlAqEzlKf0tFV1M6NlZP4b2jv6JsQe8SKoGs5ZxFTDQ
         fWPTzoqkzCwNQgrcGPeI0dsm36U1r6OeOrIeY2xtqJsNKjEByJXf1Bp91lTQRZCMUpC1
         KeoxxsYCE+dT0DWRnurFm4D2T+RtVfp+250I3vyNoWuc6d4K26q0nm6qEPCCCAZl7ZDo
         mtWjKrGo4W7FhAur5JlcEalmYYoiYlVrou3a5fplzRgm1PGUr+NZfgdssOtZtk+ujGY8
         QJpWIbbmxjjE+5MX8IqBiCinhBvWTJF+KtGirZPgeZy+H5VwL4EREBW1EK4rlYzUHI+f
         9puw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757722320; x=1758327120;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=cfDQQUU5oGkiiYtYM/v8xrRfjVH+9wKoO55lVwiMx/A=;
        b=cwAnKImCO+aiSb5D0PoTco+BgPZwaIUUvRwzq/Zcp+ibUWFtCrg+l8ggt4wGanRDWo
         W/JzH0DgVvW4Lep1ERyWMZq1BelfBy+nez3hPdpNAAr1Y8zghEuIxcR9ah2yypktx81P
         pVlTlu280V31TxePxeSeEdFQdXiAFw6TdaBOCWx2tt2neNFEO8scDJxCnekXCbrZG3GK
         wPzhm4KE++FbpwOotXSALuGbTm2DRjmKbAkohC2808ZSpjoo5KTAdfrk4slaE41wCDaF
         Iw2jI0+7oSMYNf59X34NEm7eTTXQYYBu4uDFXCEgr4oUAeR4s9jCH9ZdA17BbaMpVBcG
         BM3g==
X-Forwarded-Encrypted: i=1; AJvYcCUKJcL4vgcdTAIEodAlnnJLIvkjK8Q87vsrXADqhFUyzwK/Klh9tgpiDhJg8zFXxwhRCLqQY8svcw==@kvack.org
X-Gm-Message-State: AOJu0YzsCmTX9UL/klt4OV7C8DKLNNVIqu6WZ+fXhiDW6QWx4t4PXzCQ
	/vuxycw2SxV2yWrys0h85jrriv7iy0rZQDrUSj9vAHK3fzIndsCTfFkh
X-Gm-Gg: ASbGncuJ5vFfE59iv/1H5rjgQLMNo31PwE4A19+g9v5+U5qcsWpg3ehuDhX7Ner/SSG
	bMj/i3oxqLMcdr+N2SbSHUWSwvJ+NMnqE3WOkkCqNPHrq0s8Pa1PP8kpL5V8Cu/EMuqnoghPpfW
	N4pv4l8erM3oyzTJlHP2uwCEA8BcS+0T1JDQqSzhC9k4Nw6ki+8vspnIjrIL/EJNxGoaS687PJC
	eJYcAoUJujQgijX7GLauEenGloD8ohmecIai5jf7lpz9C+GiywbbfBiFbuVF7VDxv1XvRq4bz2l
	eoEzxcQ0TWhCzwIR8hInC/P/0fQTd5Wm5hEO46Pv4dKkxSZA0LIVI9y7lSu7cjwj7faqaSN+G5C
	YDcgLatEl/cb9rBsZ5TSYSTabWe6KCaK4Dm5N0CUDHAGfurM=
X-Google-Smtp-Source: AGHT+IHlHnsEFUmYdE6yH8DNPlzEOR+XxDNHd+uRFCixTF9DbS1ax3cJx7cENRih7UqzJPRXfnqyBQ==
X-Received: by 2002:a17:906:4788:b0:b04:b435:fc6b with SMTP id a640c23a62f3a-b07c3a79fefmr484465466b.60.1757722320110;
        Fri, 12 Sep 2025 17:12:00 -0700 (PDT)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b07bf0011d7sm331689666b.91.2025.09.12.17.11.59
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 12 Sep 2025 17:11:59 -0700 (PDT)
Date: Sat, 13 Sep 2025 00:11:59 +0000
From: Wei Yang <richard.weiyang@gmail.com>
To: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>
Cc: Zi Yan <ziy@nvidia.com>, Wei Yang <richard.weiyang@gmail.com>,
	akpm@linux-foundation.org, vbabka@suse.cz, surenb@google.com,
	mhocko@suse.com, jackmanb@google.com, hannes@cmpxchg.org,
	wangkefeng.wang@huawei.com, linux-mm@kvack.org,
	Oscar Salvador <osalvador@suse.de>
Subject: Re: [PATCH] mm/compaction: fix low_pfn advance on isolating hugetlb
Message-ID: <20250913001159.2oamn2veekw2f6li@master>
Reply-To: Wei Yang <richard.weiyang@gmail.com>
References: <20250910092240.3981-1-richard.weiyang@gmail.com>
 <20250911012521.4p7kmxv46kwz5fz5@master>
 <5F7DCC9D-4CA2-4BA2-9EA8-F04C3883E289@nvidia.com>
 <20250911032751.khtgvdhcqzyf3rgr@master>
 <3DE28F4B-ACB1-468F-89B9-D7750D24BE4E@nvidia.com>
 <aMMGbPX9uUj7TfoG@fedora>
 <20250912010721.zd67xbfdava2u26e@master>
 <ED7450E4-51F9-4749-A74E-C3AE8927E577@nvidia.com>
 <aMRWuS-Ore7jgna3@fedora>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aMRWuS-Ore7jgna3@fedora>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Stat-Signature: ixd3z4wge3qhgmaff3b8yjtrxxukunyh
X-Rspam-User: 
X-Rspamd-Queue-Id: C70071C0009
X-Rspamd-Server: rspam10
X-HE-Tag: 1757722321-865711
X-HE-Meta: U2FsdGVkX1/vUqFoWqhrCJcydgSbQnLDeavqyfRxMW27UJAu+Jba3avELw5PNIpUA3CCKbhy5Scgq/5wR+q0WFWxOoEQJCUZ8Efb85u8gErFikwWbHcfDXxadbs+u8pwTdWEsvpVQjF8GbFBvUyrz5bUCuPzvhPqdvYcc6QgZI9rkr0VPLHHEgkOet3iSsCLEP62dsTXilpJ0d2PkeBKp3mp5bHo60qB+O1BkYgkn0Hi7bJIHPsrBautFaKE1Gyv7TM/U2r2ELJfzgQwVKZYXSEqiz4q+7FbvAFn7BVOYUPcwIWWeOaE/inEeJieFsEKzQD0jEvMtiLnGNoGFTaZzF0yLtm6aEIFn7QSCVwaVBgamNDKQc2S28LuhmQ60DPmHEBwlSnnx8CehvhqgVcijq1kqRMH8YoyZK6yIrvBQTbU0n9QjL0Yvj6G2YivH/54bForUtZrFJlk6gCSCwxvtNGXGx+YJEBHkqlKNRYYtwSqUZQy6yRwpUIoqiL4yebvAipetdzWj7/7KQucR9vdMItvhvmj3S6/KfEB/GLJht05pzGxMAKntqm+rFlTuJ9aYPP5NeOCoQmTXtEq5OcbP0KtGmyZjRZPL3AQiXJYx8pCuUy71PlMUBcKEc8d5Bz1JpJClEz0Z05D/w5ZjH8zjjMovp5Xq4f/IApVwawskqnGHFWUIbxDMYkzi7ggfXg+JfKEk65BJYLFOjTUjx/zN2qwfNUjz8ezQ3BK9mcegecaZ8IsIDD/U0LTzThwu6owP++Gm7vV4vIMj1RxZOpV3DJ/c95omC1REiUH1FeiHN1qlPVJ+zHkZQJ18UJJpstZJaiykR0T3YcU1DOuAp20yPA4wp4nwu3DO2+xClXcxFoYAnovG+7n9dEoegPhsEy8ZKd4JOi4PzfujFesE2NOXLjqWYrQf6felVXnlcuB6202fmh1S2k2CP+HbbQE1r34mFK9YrqAy/4Nf0Fcyox
 GhVqEKG7
 GAMQDjyOgbPKdUs6SNrk4DkyCmbUJfF2eHaPbE+Ddem7NOaAhnP12778BoZUwW7CTsAPwaYDs5fm4gH//tGGZK1zeRMysZVmXnt2qHU33YE6JByU1wp8qNlRILcmaLDRdFvcFSoMkKiqffCQvvWrx2XwP+XFlZXBrMc1QXLzRO+V8Wo5t9vayy9Uew64tRJXe/2K1fV9LnM3KNpHmAHBDLJCjB2g5fs3YvvPOrvmdQcb0zbyfcNrYDAU0mwK2+0rlK+XwbUgZ9MYLzkh2HyNbhrE4Zn8PHkoq/BWoPo5tND8UAC7OWcDPPGmB6cQ87K5zFQfPnL8BOyzr0q0yggw58158Zft02hLTZ6tlLtekJS/cN1cvmuKxJIpfSyUqcUzbN3Pc1ArjJZgre+wcusaXSabn6jiUrmi8DR3AUGky8Af2/zM8keAoeeH70xf/y9BnjkcdHAQ+MDpDjDhtSak0XvqSQvNtpq2PAWeyFrfjEg1/WCFzKeHM8PgnXncweBkfgevBjk3k9Dr8j+Un9qPHk9yyGx/TFsDfJfNoxtcCkIEQVnnMevsdiMlJcIZ4DJ31PfljComT10G/QBNw9jfLWG/2D+7i0krAY3TI9EoNKpwxoc5QMBVup8WqZT0EBKjayK0nkfDrsOf58VS2ySSuByN8lqb9bS+gcMqPBqdG3VFLsBRWkdktAzujmPhdk6w/1jF3A7EVfG7lPqjAk17x41glC1zLp6IVHyp3pFgpOU9uMzSYCLKnk5NtK1CDIHmhGaPR
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Sep 12, 2025 at 10:22:01AM -0700, Vishal Moola (Oracle) wrote:
[...]
>> >>>>>>> ---
>> >>>>>>> mm/compaction.c | 2 +-
>> >>>>>>> 1 file changed, 1 insertion(+), 1 deletion(-)
>> >>>>>>>
>> >>>>>>> diff --git a/mm/compaction.c b/mm/compaction.c
>> >>>>>>> index bf021b31c7ec..1e8f8eca318c 100644
>> >>>>>>> --- a/mm/compaction.c
>> >>>>>>> +++ b/mm/compaction.c
>> >>>>>>> @@ -989,7 +989,7 @@ isolate_migratepages_block(struct compact_control *cc, unsigned long low_pfn,
>> >>>>>>> 				 * Hugepage was successfully isolated and placed
>> >>>>>>> 				 * on the cc->migratepages list.
>> >>>>>>> 				 */
>> >>>>>>> -				low_pfn += folio_nr_pages(folio) - 1;
>> >>>>>>> +				low_pfn += folio_nr_pages(folio) - folio_page_idx(folio, page) - 1;
>> >>>>>>
>> >>>>>> One question is why we advance compound_nr() in original version.
>> >>>>>>
>> >>>>>> Yes, there are several places advancing compound_nr(), but it seems to iterate
>> >>>>>> on the same large page and do the same thing and advance 1 again.
>> >>>>>>
>> >>>>>> Not sure which part story I missed.
>> >>>>>
>> >>>>> isolate_migratepages_block() starts from the beginning of a pageblock.
>> >>>>> How likely the code hit in the middle of a hugetlb?
>> >>>>>
>> >>>>
>> >>>> OK, this is a kind of optimization based on the knowledge it is not likely to
>> >>>> be a tail page?
>> >>>
>> >>> No, it might be that most of the time page is the head, or people assume so.
>> >>
>> >> For compound pages, we will always have tail pfn < head pfn, so we should
>> >> always find the head page first.
>> >>
>> >
>> > I think you want to say tail pfn > head pfn?
>> >
>> >> If you did find a case where we somehow encounter a tail page here, I'd
>> >> love to see it. And then you'd also want to make sure the other compaction
>> >> trackers are appropriately accounted for.
>> >
>> > I may not follow you here, below is the call flow for
>> > isolate_migratepages_block() invoked during __alloc_contig_pages().
>> >
>> > __alloc_contig_pages(nr_pages, ..);
>> >     start = ALIGN(zone->zone_start_pfn, nr_pages);
>> >     alloc_contig_range_noprof(start, ..);
>> >         __alloc_contig_migrate_range(.., start, ..);
>> >             pfn = start;
>> >             isolate_migratepages_range(.., pfn, ..);
>> >                 isolate_migratepages_block(.., pfn, ..);
>> >                     page = pfn_to_page(pfn);
>> >     start += nr_pages;
>> >
>> > In the loop of __alloc_contig_pages(), it iterate on each nr_pages range. And
>> > nr_pages seems could be any positive number, so it looks the first pfn checked
>> > by isolate_migratepages_block() could be not aligned with page order or less
>> > than MAX_PAGE_ORDER. This mean it could be a tail page per my understanding.
>> >
>> > Maybe I missed some point here?
>
>That looks right, I missed the comment:
>        /* Scan block by block. First and last block may be incomplete */
>
>> You are right.
>> 
>> But nr_pages cannot be any positive number, since ALIGN only accepts
>> power of 2 as the alignment. So alloc_contig_pages() might need another
>> fix to handle the case nr_pages is not power of 2.
>> 
>> Oh, after I checked pfn_range_valid_contig(), I find your example does not
>> apply, since it returns false when any page in the range is PageHuge.
>> This means with your example, PageHuge branch will never be executed.
>> But alloc_contig_range_noprof() is exported and can be used directly,
>> the @start input can be any pfn, which can be in the middle of PageHuge.
>> So your fix is still needed for this case.
>
>Makes sense to me.

Thanks :-)

-- 
Wei Yang
Help you, Help me

