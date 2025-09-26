Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1944BCAC5B0
	for <linux-mm@archiver.kernel.org>; Fri, 26 Sep 2025 00:25:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EF2738E0003; Thu, 25 Sep 2025 20:25:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ECAA38E0001; Thu, 25 Sep 2025 20:25:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DDF918E0003; Thu, 25 Sep 2025 20:25:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id C9F0B8E0001
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 20:25:48 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 5CAF7140550
	for <linux-mm@kvack.org>; Fri, 26 Sep 2025 00:25:48 +0000 (UTC)
X-FDA: 83929508376.17.A00AE05
Received: from mail-ej1-f49.google.com (mail-ej1-f49.google.com [209.85.218.49])
	by imf17.hostedemail.com (Postfix) with ESMTP id 533F640004
	for <linux-mm@kvack.org>; Fri, 26 Sep 2025 00:25:46 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=VIxMBxPU;
	spf=pass (imf17.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.49 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758846346;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NMC81w+JaNK7q2bunYAj8hHN6HLRojIWD4Z/O2pUXCA=;
	b=c5EVq6xA9pWUX2HsfhCSFQnNbUnjiQsCUUm9IHdLbbHNuDd0ZQIOm3arrmCDiGIR22ZHNS
	i/tI27R+FTWfhmSn+hK+mwr9Fkl92y8T7rZnpW97ecIxsPZ3XVDGa4zPMRnkeFe3Ntqtn2
	5dLEFgiXlwuLBW3udGhE4yvtNX6jmAM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758846346; a=rsa-sha256;
	cv=none;
	b=M+4BaXUCHq8lZvIR+SmazoacC/F6JtgEWEZq9Af+0KJU2x/TJzdSIeAQN9B9FVrfvvqDNl
	9eAiur8dkjcl1cDzNAU+A2kzmjof/Be2iG44uG2si0IjmZaYryWuHpwlB7W8f2OyZtPAXq
	czWzaT9P1XYj2qdmXpmUjJwu8jVAjYc=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=VIxMBxPU;
	spf=pass (imf17.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.49 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-ej1-f49.google.com with SMTP id a640c23a62f3a-b30ead58e0cso273924866b.0
        for <linux-mm@kvack.org>; Thu, 25 Sep 2025 17:25:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758846345; x=1759451145; darn=kvack.org;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NMC81w+JaNK7q2bunYAj8hHN6HLRojIWD4Z/O2pUXCA=;
        b=VIxMBxPU6xDYaHi8RhOXYd8q+156QmjHy4jXkzCtO67lQPaQnRxpbgKaZyYQS549Io
         d0NTkjX5larD7r9wAQNYM6dFNIwosyKb5W7HlnEuhnX8zuFapbQ/FliiFTjN/ve3LqfY
         cA51cYGq/bWyUTE2G5W4siHffkryOmZlXDlebaiTnZbekutFSY0e/T+9p9prRFeh2Zud
         u+bWHjBXks3GJ7G431yscLl3pgobsN/tqwsOROPo9QDyXo8RkocnbWEjJKC6w5ukRcUZ
         mTOR6B/CAOR7lQZz+tNud90kZTEa+ez/ySQqd8yrKxK349YoZqSbwNfdiNfpovlZgLyE
         kdMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758846345; x=1759451145;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=NMC81w+JaNK7q2bunYAj8hHN6HLRojIWD4Z/O2pUXCA=;
        b=FYXUAXnfknRzIjJotazDcJNe8HGf3I+BWb+/0yOdyZr7s4cpI5dsdN9eVepB0Zi8tB
         VgGPPV9/JJz/F3wnGeBdoUG+w73dHM4kvA9cl8vd5lsfOivxuht4zvbTjRtqOs8z/Quy
         ypF1Q7UJ2kaYiq1mlv/7FmykEWoQQgGxZdGoDunPOiwLqy5YNMwxQFUAKYLIV5LeEoKD
         lTsgp1HNEY91ozK4UfnjpwqR9s5/IgiFU3QHVxl9woM8Q1IRVeJIYEb8XUW77db/aeut
         xBqlC8Vszci4Jp7solviMC4d7cLFp7OVjXEbcpweRkU2UctiFnIXE92Sx8jYh1kcmm7R
         kcpQ==
X-Forwarded-Encrypted: i=1; AJvYcCXPfBC4Sk/9DukTnrSwR6WwHaejZUkIp5ry6HaA3C01bvV1elXNhBSNoCaMqCqDHUq5J0E7ucPlCA==@kvack.org
X-Gm-Message-State: AOJu0Yz4tG1KRDU5FnNWckTgE9Eaxo2p0Qyjjld9pK43r/eY7+f03XZ+
	fcILnF283B/yRK9apH7ezJdWcc5ojaIhSpSuOMMfV6qTdL+EmvnY48cv
X-Gm-Gg: ASbGncsngQOBMFK7SJYEhHIVMGKYx8EMf0oMkc53OEO007pTeB88pNqDTEsq4X541ea
	px1srquxpTM7FGlShLjMkeOpCgZDXPK9mRDpLE5qVtK2EF5V3sbwbEAcVGcwHjWOUXrj8NPWNwS
	Q6w8CCYT1CgTH/7lvhqECqxBEEsnPnZRBTOuCePyg7Ujn7ZH1Opr6jxWdon0zlPi+Bv55qONXZR
	BiTgjlw0VRITGp/APPsW+sFdJMlAqxybkMuWmMlWhH1ry4a6hoPx4/iY8+gpTpRMUWaK7m+XX8T
	kqc9VPRNR9S7R44dnlyBzj/Ui6EUMcykivNwePYYg33tUx62mFN41y0QCrODboFkHRJb/UHSbLx
	MN/uXO8kwkLjJ+CADnRv0d8eSP6TaYhWixEg3
X-Google-Smtp-Source: AGHT+IFrncgRgp1cO6kD9iqXJ1acMD+hFDb5TMf4B2VASiURfzNNm3MkxN444XZaQPI6JQA/i5XruA==
X-Received: by 2002:a17:907:7e88:b0:b0f:a22a:4c3c with SMTP id a640c23a62f3a-b34bb41ad93mr619135966b.48.1758846344556;
        Thu, 25 Sep 2025 17:25:44 -0700 (PDT)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b353e5d2ddfsm260259566b.14.2025.09.25.17.25.43
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 25 Sep 2025 17:25:44 -0700 (PDT)
Date: Fri, 26 Sep 2025 00:25:43 +0000
From: Wei Yang <richard.weiyang@gmail.com>
To: Mike Rapoport <rppt@kernel.org>
Cc: SeongJae Park <sj@kernel.org>, Alexander Potapenko <glider@google.com>,
	akpm@linux-foundation.org, david@redhat.com, vbabka@suse.cz,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, elver@google.com,
	dvyukov@google.com, kasan-dev@googlegroups.com,
	Aleksandr Nogikh <nogikh@google.com>
Subject: Re: [PATCH v2] mm/memblock: Correct totalram_pages accounting with
 KMSAN
Message-ID: <20250926002543.fwkf5qldhkapcmqr@master>
Reply-To: Wei Yang <richard.weiyang@gmail.com>
References: <20250924100301.1558645-1-glider@google.com>
 <20250925123759.59479-1-sj@kernel.org>
 <aNVWzaxq82UI3wWO@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aNVWzaxq82UI3wWO@kernel.org>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Rspamd-Queue-Id: 533F640004
X-Stat-Signature: y876kewtu1gh1g3i64tbsrfhfuzwf6ay
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1758846346-272627
X-HE-Meta: U2FsdGVkX18izIXTzE0vPdA8ZPmoB2aUyeGAVVNp7pmWhUsoFZ60P045SPR23wknB3aRCbG/JWDLOdVoyPdvC9LLtVE4ajMsKe9Ovgw00DkpepeAa80IzQKclJCk2Odm6tZnD9rV8G8yclJ/CQ2WVpi/HizMjMF1AVkUoaqI36nA1C74wimW7xQozbb7+QNDs4DiFz4pGKxn06manl4ofCNDfeP/ovgzOdOyEXa+MnTNErtxrwna+it7ynNcbwuw9r9MqmSDIQuUy+oZKnAJVecsxDA1l9RE0u/QM4PE3khZE6ajZVJIjCYglIC7p9LJdHVvgK9Wz4oNtmS1ux91bjkrrgD6eeRXbEUOkTFBz00feeKcxTOWyIRZ9TNWqHmaqFiGqbDsxCypzRHHFb+DGadVAs2MItF2Kl/0WxOEuDN6tcoAxbeMAInxxeiDjrFajY2H0Fg3P+ZOc7WKtd/vVFAJtWidq/YIS0KdRW9yl61Bi4vfLES2Fv8bxPhjhr/qho8SMMz/EzuLjOmqqTAWtC0pKTTBCl83BRHbXhB/vDH1NCijccc4jFXdIxTQfJ8bh4Ov5zyigqlfbiwE+MsbuIGXCtyrg7gA/WClsbYIEPwFf5b3ml9x6Sso0j2zXe9E5FYyYGoXLeOzEzuUWdijAD57jMw8g8nposRmBz25HQXMxEsYLCphK3KS6VVW9nK1+J+mQ79f7TiPCi0Kdiud0tBdylXXWh0B6H3oxdNv4elWVgoYM+/kaiPiu6h/G28tCyt2pgZ+1Ey0u8KLdX6Qg9D7PP81x6gmUGCcQy7YMwzpRDGqZGtfiE1vCdQpnJESrj8iqweojz0PUhdzPfShpGKdI392bMUlszQLZBYZ+wxHNHkqTnJY2lnRh+0n7hvUdXFJjWj+9mRRvVNuDrvH2ITvXTfsS4MqpfzfBKnA8Gjs5on9yqCd5q1+RREcOAlaxG26SfSBTpB+H9dqTnw
 wXhtVR8b
 pHObM+lOieadS8LrtXgW4pxJevCVFIwuwNc8ko6sCS+CMVDTAYMmX9zb35BafsmBaGB18XEpSSQCL58KpCIFuE4+i1XX8iHssF3ePxJNJaAeuCYDhAdmBfRGXn2FkCu89uCkWqlinB4/9f3F3s4bxNSNUgKkgttYFJ8hEaugElL+Lix0CHd7lK5IA5G0E56U5c5VPyTL7Ms72Q8eKOxdsNc0FBSAADs7tZKi9CWkEHDlLha3jo989gSo2BjTXDx09CQ4E1r9L4rAUbiuSeCragzpBmr9fb+fskk+/60B5LFTm+OtuaW997WMYH395X7/DEg1K9ElHThpBpfeHo7gea4O+foVoLYZfoLSlCadi9W5Gfx4r25EG2EWjwZcHwVlWeKUkearacLVlz/xWAnqNqP0CeQLiCLSiJvOIf0qqNLzNf4sIxE7S3ExqVM7gLYCzXmFbEolmfQfmlKuD9zwQj+/vqPZ8HuEbNcynKc9OLQk0xnEIfv/ndfg+SrDD02pyssA9vXYjuqbKgcBRB9IraXMYXpko3ntCJT6VJDRQ3Gpa8Z5OxCAaftmyFlvS7zmmlontU42ktijeg4XrA5Z8AkY8BtHzF2FURvOF5EDN1kpJ+BMAD24wMfv72JyPoJa7K5cjOrG2zD58Bvc0OO4C6IfznNuyH3ZGpQ8a3dG+ExufAXB1e06ho2t11rgwECjNIX1YLHJB/VkOusD/goNuaurwM2gynpr3HqsM2VpEznwW399E8fFwHnCeq7iCm/GRey3NZc587HRJonUkn4tOOiiU/g==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 25, 2025 at 05:50:53PM +0300, Mike Rapoport wrote:
>On Thu, Sep 25, 2025 at 05:37:59AM -0700, SeongJae Park wrote:
>> Hello,
>> 
>> On Wed, 24 Sep 2025 12:03:01 +0200 Alexander Potapenko <glider@google.com> wrote:
>> 
>> > When KMSAN is enabled, `kmsan_memblock_free_pages()` can hold back pages
>> > for metadata instead of returning them to the early allocator. The callers,
>> > however, would unconditionally increment `totalram_pages`, assuming the
>> > pages were always freed. This resulted in an incorrect calculation of the
>> > total available RAM, causing the kernel to believe it had more memory than
>> > it actually did.
>> > 
>> > This patch refactors `memblock_free_pages()` to return the number of pages
>> > it successfully frees. If KMSAN stashes the pages, the function now
>> > returns 0; otherwise, it returns the number of pages in the block.
>> > 
>> > The callers in `memblock.c` have been updated to use this return value,
>> > ensuring that `totalram_pages` is incremented only by the number of pages
>> > actually returned to the allocator. This corrects the total RAM accounting
>> > when KMSAN is active.
>> > 
>> > Cc: Aleksandr Nogikh <nogikh@google.com>
>> > Fixes: 3c2065098260 ("init: kmsan: call KMSAN initialization routines")
>> > Signed-off-by: Alexander Potapenko <glider@google.com>
>> > Reviewed-by: David Hildenbrand <david@redhat.com>
>> [...]
>> > --- a/mm/mm_init.c
>> > +++ b/mm/mm_init.c
>> > @@ -2548,24 +2548,25 @@ void *__init alloc_large_system_hash(const char *tablename,
>> >  	return table;
>> >  }
>> >  
>> > -void __init memblock_free_pages(struct page *page, unsigned long pfn,
>> > -							unsigned int order)
>> > +unsigned long __init memblock_free_pages(struct page *page, unsigned long pfn,
>> > +					 unsigned int order)
>> >  {
>> >  	if (IS_ENABLED(CONFIG_DEFERRED_STRUCT_PAGE_INIT)) {
>> >  		int nid = early_pfn_to_nid(pfn);
>> >  
>> >  		if (!early_page_initialised(pfn, nid))
>> > -			return;
>> > +			return 0;
>> >  	}
>> 
>> I found this patch on mm-new tree is making my test machine (QEMU) reports much
>> less MemTotal even though KMSAN is disabled.  And modifying the above part to
>> be considered as free success (returning '1UL << order') fixed my issue.
>> Because the commit message says the purpose of this change is only for
>> KMSAN-stashed memory, maybe the above behavior change is not really intended?
>> 
>> I'm not familiar with this code so I'm unsure if the workaround is the right
>> fix.  But since I have no time to look this in deep for now, reporting first
>
>With DEFERRED_STRUCT_PAGE_INIT we count totalram_pages in
>memblock_free_all() but actually free them in deferred_init_memmap() and
>deferred_grow_zone().
>
>So returning '1UL << order' is a correct workaround, but the proper fix
>should update totalram_pages in the deferred path IMHO.
>

Maybe I did something similar at [1].

But this hit a problem for shmem, since shmem_fill_super() use
totalram_pages(). And before DEFERRED_STRUCT_PAGE_INIT finish, the size is too
small, so it can't boot up.

Per my understanding, shmem_fill_super() could be invoked after
memblock_discard(), so it is not proper to refactor to get ram size from
memblock.

Could we adjust shmem_default_max_blocks/shmem_default_max_inodes use memblock
at boot stage and use totalram_pages() after system is fully up? Or any other
suggestions?

[1]: http://lkml.kernel.org/r/20240726003612.5578-1-richard.weiyang@gmail.com

>-- 
>Sincerely yours,
>Mike.

-- 
Wei Yang
Help you, Help me

