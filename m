Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 55477CA0EEB
	for <linux-mm@archiver.kernel.org>; Thu, 21 Aug 2025 03:42:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 85D228E0006; Wed, 20 Aug 2025 23:41:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 834E78E0002; Wed, 20 Aug 2025 23:41:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 723A08E0006; Wed, 20 Aug 2025 23:41:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 5DC3F8E0002
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 23:41:59 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 959ED5740B
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 03:41:58 +0000 (UTC)
X-FDA: 83799365916.26.075CC80
Received: from mail-ej1-f47.google.com (mail-ej1-f47.google.com [209.85.218.47])
	by imf17.hostedemail.com (Postfix) with ESMTP id B188740002
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 03:41:56 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=i0UB2b+S;
	spf=pass (imf17.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.47 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755747716;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ly8HhEQvY9JxMVhrYHzoh/hAff3HjFqcoEOj5b7KCq4=;
	b=bT3X1FSlrcAsnZncr9znfBBPM87RmdSKWfWqyG6KCmy2hkPkkx6fngebKJZtpk48eMlmAR
	gnCZZJcPvl8Gt0huITY0wjYXRfNqg1Reljnicc7xuTFlEllUNX2eKxmyFMZLbDkbY0zgnu
	GzuyiLHSiral9tvaEpy8TDtWgKTq47Y=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755747716; a=rsa-sha256;
	cv=none;
	b=e7za/R/R/8voL4RCKsE2iIBRTbcHFxgDAzrNBEULn1xoITrEuxgJvLrQABtSZuWmE5BV0v
	I4i3H0T04nbuzeQLxHWNULqHB7tOAXSW/sm9fMXqAnJVKY8/o7hsGyIk98vg0f5tzavxZo
	FyU3RZuHLO1LKAlQPA+w2cmIutWsaSw=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=i0UB2b+S;
	spf=pass (imf17.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.47 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-ej1-f47.google.com with SMTP id a640c23a62f3a-afcb7a3b3a9so68262566b.2
        for <linux-mm@kvack.org>; Wed, 20 Aug 2025 20:41:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755747715; x=1756352515; darn=kvack.org;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ly8HhEQvY9JxMVhrYHzoh/hAff3HjFqcoEOj5b7KCq4=;
        b=i0UB2b+SCcuRknsfgpBGPtnOuA+Hz3lF7vfuvElpV8/ZYIWRIwT90ElCF163CIcab2
         yLtFpv0YdgH3u1i/2bHfEjODg8c1fRCiphqdLte2CGGtVPZyKUzZ5unxsNGr0B8sno0Y
         AxDUyElJMAufisXlTVSCmSqxJR/Z0s+vYi/rgMtsztFGGY4hdQMJTTsfLIufg9Raqlpy
         byH0Dw/CJgVZPzrKyW7aLA6hF+CernvJ0YmohcLobkgpzi1JTIXPVxGAilOaYl99izKq
         7ET6ULB+vJyMdie5XZc0j8sPZJOgvYtCpw7sxwpoE/lnU8w4EUSzzV4pELtCYcLy7E1g
         Qy4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755747715; x=1756352515;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=ly8HhEQvY9JxMVhrYHzoh/hAff3HjFqcoEOj5b7KCq4=;
        b=sHYX4SggvSbY7k0IVCseDVvhpe7epP0bCOmt/Bfbmmo6kqsTscEd9XMO0YeL2FN7wm
         QjSBYF4pQaIP7eOPUdo3xeJ/TSTtpHcD+VB8sG8Qb9JcMYuwta92LNY7Z6Cblmo7PDXY
         U5kDXOwsDu6IypNaDapdDPb+bcltWHtxdK2e/uJY3jK9HtBPmwAgCPBOquMFly5mMnXA
         LcawIuXv8q1ExDuKCVS5CtvhkvSpYhr4ALB47ir02oAlvMI4OJpxRoJcArySGkp9UyMb
         KlNPoa1b7EjpPsygWzDSMKGfo9Dgxm1x23m9rmZQFIaYu5Yc8FBXdk4jrS3mr0RTkbXp
         gaZg==
X-Forwarded-Encrypted: i=1; AJvYcCWRRltNaUMkb9e2YBIucsdrNoLDjrVTPX3FBwHreZ7b+ajNeQhGCfTwSKRTNQVy4BA939OErkw/pw==@kvack.org
X-Gm-Message-State: AOJu0YxE2ZWyMZc+4Q/vsz3kx94meqtexEod8GV3Ze1o1lB05Xv82a2x
	bzG/uVilW7yYELr0x0n5hFS3n1ngLZDaDghQvBjWMf8xZXy6UmfeAgoi
X-Gm-Gg: ASbGnctD+3Lp1go4lgJEKzKJKP0oBZKWlaYc7BVtj/Icmn//Y29Z4K1SveK4N/0E0CU
	O2zAINjCI5OS5DWoN0guGr7PMU2bIyEGRIIAwjZO/aM0Ae0U124MbDMh8qJqbOkp1BfQKc488rX
	ylYSMul7s8oiTltSVlWWpAy5tU8TYanjJBQDUHk+/XqCluDvvpZyeK8+b5l946mKF2aJKnbuKz4
	FzUzMVXkd0mKCNg+JIodrwQJP+fcDckk+168Ugm0b0+5BUbZ5QQO4MTcMhhvChJSme9v4hKJjSe
	byrVMqWQivCKweygrPaMPPmtjQpWNAmuLdXuo3PjXaH6g8dK+TlCBe9Z/XyVCZxCi2ieWf1SviZ
	klWcj9Cfyfdnas/3PIQwc8A==
X-Google-Smtp-Source: AGHT+IGaJqB8Du4nZbwZH6+ZZ1UR1jsjKqH51Z9VenWWYM+Y2riY0qwNibopPt1+EA0CWK1IUnGClQ==
X-Received: by 2002:a17:907:3e8d:b0:af2:5a26:b32a with SMTP id a640c23a62f3a-afe07c154d7mr97515766b.30.1755747714772;
        Wed, 20 Aug 2025 20:41:54 -0700 (PDT)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-afded2ba31dsm299249166b.12.2025.08.20.20.41.54
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 20 Aug 2025 20:41:54 -0700 (PDT)
Date: Thu, 21 Aug 2025 03:41:53 +0000
From: Wei Yang <richard.weiyang@gmail.com>
To: Nico Pache <npache@redhat.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, linux-mm@kvack.org,
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org, david@redhat.com,
	ziy@nvidia.com, baolin.wang@linux.alibaba.com,
	Liam.Howlett@oracle.com, ryan.roberts@arm.com, dev.jain@arm.com,
	corbet@lwn.net, rostedt@goodmis.org, mhiramat@kernel.org,
	mathieu.desnoyers@efficios.com, akpm@linux-foundation.org,
	baohua@kernel.org, willy@infradead.org, peterx@redhat.com,
	wangkefeng.wang@huawei.com, usamaarif642@gmail.com,
	sunnanyong@huawei.com, vishal.moola@gmail.com,
	thomas.hellstrom@linux.intel.com, yang@os.amperecomputing.com,
	kirill.shutemov@linux.intel.com, aarcange@redhat.com,
	raquini@redhat.com, anshuman.khandual@arm.com,
	catalin.marinas@arm.com, tiwai@suse.de, will@kernel.org,
	dave.hansen@linux.intel.com, jack@suse.cz, cl@gentwo.org,
	jglisse@google.com, surenb@google.com, zokeefe@google.com,
	hannes@cmpxchg.org, rientjes@google.com, mhocko@suse.com,
	rdunlap@infradead.org, hughd@google.com
Subject: Re: [PATCH v10 03/13] khugepaged: generalize hugepage_vma_revalidate
 for mTHP support
Message-ID: <20250821034153.uyxjy5yvxx5no5sf@master>
Reply-To: Wei Yang <richard.weiyang@gmail.com>
References: <20250819134205.622806-1-npache@redhat.com>
 <20250819134205.622806-4-npache@redhat.com>
 <cd4dd743-679f-4c55-9635-6d32e6fa5ff7@lucifer.local>
 <CAA1CXcDORXqm4JoHn4ZSEhT3ajsuY2MAPwefMXk3+YMXcpvqkw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAA1CXcDORXqm4JoHn4ZSEhT3ajsuY2MAPwefMXk3+YMXcpvqkw@mail.gmail.com>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: B188740002
X-Stat-Signature: qrwy49953nb3iwjefq1gaexbjoriitrj
X-Rspam-User: 
X-HE-Tag: 1755747716-749487
X-HE-Meta: U2FsdGVkX1/e2FPG3/EvsirlaLtw83cgghXdGYNI6/S/22wGUmtRB5caX679hn5yDhpPJXOGFMEpTpT6v8Tmc1m/HUUa20OwvF4G1yK8NaWHEB6B+iWrMTB7Lw+fiy7a5KAtIUVG9lWw82IQQyZxAB+yPTGiHsEroXDiyM0HikgjZhi06kgyfQtir4jPKgm5xL+ZMTCfnaG7hjYguFndYHPuIdGO8/8syOa96j+4psYl2+smgr6yZSyQWraNmLwxpPUbkv2Z4jdfNpRWWRBvTd9kbS8hTSy4QyVGCvDSNwO3e7hGFD6YrmI/18cpqwqfYnkMh5g55YsGHKuJpryvYD1M9MNumQiklgPMMc6JmY5quMRufPW+K1oaIT2G6Kargc56PB1AxAoUJe+y6iN6lRIA7gv8CPMSdjuJ2MnFz256R+HTC+9IGwVPIjZWoHMyAvq82jee/jAwk0LEAUMpQ0+0sm+IfXVDsvNeDKExG6T05kFzhHrn0UHCqi+UjsuKCbVSi/E9Ok/odLOYzPjoqC4wDPHkisOTNBY+w2HO5yJJK166cEHRfH/H//zQed5D5bmeDBJ7odsQ7HRJ4BzShJB2byb3IG6AhT3mNpAgCTSwZGUA2RyfObOhzb+by4+uHAwrJgtZtCBVlHrT7Ykyyv7YFDkx75XBg4laNjU068HK6N9qksUXyfJ7f8f8GARM+F8lIw4regJ+Rhldf70BR4uHHWdr1P/EVQCHDDwKEPsnPfXWEh9VlvlO2DwF3JmUsNPDJZ9lm3Qse2WaPAsxGNFl4RrRpgvgcZAFqTfMq4j59MeGbrFUhNPqEY8ohc6FX8fDvD3MDb+Dp3C1ISzrRKmZ4K5ze3sCrSZ0Xjxv+1AQHQRNzL7M3GOEJQD+BG3e79g7Gab2i3O+fCMDMtrXr4iUKaO0ZUEJUFm/iwYNNmQRZ2gTlW5Fy6bVVn55Hb+QYGnikwaxgN8WWhjWhBi
 MHE7qQKt
 eIShV8f1qD+YMdbfJ2zz3qgbvhCR2AbqBGJ6pZBphQks0OFFiQXV6kb2Od5UXHpmzGRErnTZwJGloEqlQ04BkiLxf/ArFBJfLOkL0kayfSYvIqM88pAxcnzsvKyzNKV6RYofyvmVnM2R3XdGQeB+/11wCo4D5xS3FkcXJiw8LsfKteiDeydSEfF61nRQRZiQi4EXxuPY7H0dYSrVm4c5xuUSGMQIS5YgkiHAtHFeJRB65khptC/M2PphUY3kOb80ZS5kjYv2Vk90d2gtYsa34ewY8cCrSEOaJXsgsPv4KdkhzTAeJlACYlJnwMVrnO2xHVUa2
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Aug 20, 2025 at 09:40:40AM -0600, Nico Pache wrote:
[...]
>>
>> >       if (!thp_vma_suitable_order(vma, address, PMD_ORDER))
>> >               return SCAN_ADDRESS_RANGE;
>> > -     if (!thp_vma_allowable_order(vma, vma->vm_flags, type, PMD_ORDER))
>> > +     if (!thp_vma_allowable_orders(vma, vma->vm_flags, type, orders))
>> >               return SCAN_VMA_CHECK;
>> >       /*
>> >        * Anon VMA expected, the address may be unmapped then
>> > @@ -1134,7 +1135,8 @@ static int collapse_huge_page(struct mm_struct *mm, unsigned long address,
>> >               goto out_nolock;
>> >
>> >       mmap_read_lock(mm);
>> > -     result = hugepage_vma_revalidate(mm, address, true, &vma, cc);
>> > +     result = hugepage_vma_revalidate(mm, address, true, &vma, cc,
>> > +                                      BIT(HPAGE_PMD_ORDER));
>>
>> Shouldn't this be PMD order? Seems equivalent.
>Yeah i'm actually not sure why we have both... they seem to be the
>same thing, but perhaps there is some reason for having two...

I am confused with these two, PMD_ORDER above and HPAGE_PMD_ORDER from here.

Do we have a guide on when to use which?

>>
>> >       if (result != SCAN_SUCCEED) {
>> >               mmap_read_unlock(mm);
>> >               goto out_nolock;
>> > @@ -1168,7 +1170,8 @@ static int collapse_huge_page(struct mm_struct *mm, unsigned long address,
>> >        * mmap_lock.
>> >        */
>> >       mmap_write_lock(mm);
>> > -     result = hugepage_vma_revalidate(mm, address, true, &vma, cc);
>> > +     result = hugepage_vma_revalidate(mm, address, true, &vma, cc,
>> > +                                      BIT(HPAGE_PMD_ORDER));
>> >       if (result != SCAN_SUCCEED)
>> >               goto out_up_write;
>> >       /* check if the pmd is still valid */
>> > @@ -2807,7 +2810,7 @@ int madvise_collapse(struct vm_area_struct *vma, unsigned long start,
>> >                       mmap_read_lock(mm);
>> >                       mmap_locked = true;
>> >                       result = hugepage_vma_revalidate(mm, addr, false, &vma,
>> > -                                                      cc);
>> > +                                                      cc, BIT(HPAGE_PMD_ORDER));
>> >                       if (result  != SCAN_SUCCEED) {
>> >                               last_fail = result;
>> >                               goto out_nolock;
>> > --
>> > 2.50.1
>> >
>>
>

-- 
Wei Yang
Help you, Help me

