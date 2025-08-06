Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1F3C1C87FD1
	for <linux-mm@archiver.kernel.org>; Wed,  6 Aug 2025 09:03:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 99B248E000F; Wed,  6 Aug 2025 05:03:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 972E78E0001; Wed,  6 Aug 2025 05:03:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8AFAC8E000F; Wed,  6 Aug 2025 05:03:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7E7018E0001
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 05:03:25 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 003F8C04AE
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 09:03:24 +0000 (UTC)
X-FDA: 83745743928.30.9DBD189
Received: from mail-ed1-f43.google.com (mail-ed1-f43.google.com [209.85.208.43])
	by imf21.hostedemail.com (Postfix) with ESMTP id EC7371C0013
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 09:03:22 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=BF7AhomX;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf21.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.208.43 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754471003; a=rsa-sha256;
	cv=none;
	b=hxauXpGnOA6AWYd4b5Su3wSxvVQUxNwdCkzjWlMqirHA1Ccfoaoc1YIlz7FVxF9bbrk+Wx
	CfGw9sZieoYjsNm/J3zPhDwwA0aH6yyWZ5CY0NZlP1QidsS3PRRBjv1QLbGF60pWLKHq9H
	o6eTg/IJ316F6wAxZcptS3Fy42fz79g=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=BF7AhomX;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf21.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.208.43 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754471003;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=X7VlvHodp5bmcUXkA6dSTDBa8OaE5M3KbiDKEm7c3mA=;
	b=I1ItUZ5v4ajdPTHT1usSdC1bR4flR2dAjqFz5svMuyMX7OrbHQ2LjlnSV2yvHd262Ocj1d
	y0kIahAwXaYib4b6bovv6AhFoqGWhbhi4eBhwWlDJdqeQ+cLbGGiTrEqWXl4BNL4L7+n2C
	IhnA4azeWkYDsMSBJp0I/DkC0zN7fGs=
Received: by mail-ed1-f43.google.com with SMTP id 4fb4d7f45d1cf-6154d14d6b7so6106140a12.2
        for <linux-mm@kvack.org>; Wed, 06 Aug 2025 02:03:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1754471001; x=1755075801; darn=kvack.org;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=X7VlvHodp5bmcUXkA6dSTDBa8OaE5M3KbiDKEm7c3mA=;
        b=BF7AhomXh8ERZEtUz9kbAETyzzSsc8yN8xv62fMdBxgHx433gJd24s1Yc2FxgI2FBr
         zJY97goHI7skDLEleTNO6++terK08MCWgKRvicIwMtQQIpqeyjelvNKPycJKnT0Kz2Da
         9l3pJwzpdqpmns4VYcI1p863pdlhR59MQ1iJ5D59RHIZ4Luwy6Irztr6Zuitqkz3K9qE
         wqZHF4BoB8bMTvAKu2vNmPrxdEkzQJgt7Y7Tvc6WD2ZbW3LDf4Ji52xEdPH6W5J4n9nj
         CYSZv7tMLlDHxAVR9tGba5XCf4DQtURtKFnskGvtHmGt5rtEbZ9VRru6YIfrIZ5ENfcn
         eRcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754471001; x=1755075801;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=X7VlvHodp5bmcUXkA6dSTDBa8OaE5M3KbiDKEm7c3mA=;
        b=s7V2DbbKfrQSQZBPMqhFY5yvVraB+/fpryehLmDXYb0rDJnyUbMErwscPS8lvcbs/A
         Lw81wrWuLomqfxvfmgf5hy0znB41Zd6U88s7W5yGq0DfYb7IcxGuxPnJzpuaqMw7t/wo
         3a1SYyOFLmrWn42djgQB6ER33aDoxWM53Zdc1FlkrqjooUtMbUg+BT6/GNFo2AbRH37R
         P4zRbGQMh1eNSvpkb1tPjLToTJzbzG4F5uTE0Bv0RWIP6E+vfPxSkeYNMy/7kl/PCgab
         HEypVb2iDoq4fWQ2kowq0H6symAeR3sUwtnEfZBzJq0DHpnzCnq3DXeCtw6v2/IYkl3T
         e4Pg==
X-Forwarded-Encrypted: i=1; AJvYcCV8LemB3GfMD6cB/ElM9rHn7zL7DsC0y6r4UZ7GAzJ0jTuPuAn3+Sj1DPpc4z7yxNQfxXwYtN7EmQ==@kvack.org
X-Gm-Message-State: AOJu0YyHSMhKyhdFz5NAMRnYkaCqQBqc8OCR/oz9KiF50vlOmCKezsfg
	mP2rIrEDmZa7kDJDxxc55z8zYil+eEpgeG+dyF6A4Hg/jE+JShCVg06D
X-Gm-Gg: ASbGncuqyCys1OTxZausDJCqv+3lJnufl0vROeRBSSbPMRnaSUAAS2Mi3uBcVBugWYw
	QeXaeYmrA5to8m0t6ntKcaGnB71HlQ+/IopC03p1HSFG+DcsqrqFkYAXSmTk7D3PVL2IRtwz+Gb
	g1nkYEbwIdohUylHIxi4iz/w6w8bA3I+t15RmPjuuQD9uCjVqOAqt5punFukW6gkrRgPG2wt8LS
	+dgSig1GB38QwydTnbHb2SRYY6U9fv/q1ax3vRVi20wLoDMHEV+7dCj4dv8c0d4680U8wT9xosT
	+h7LtGTzwwgC8LeV08FjT5Ax1F9lRcO1wqebJezMegS8XmZ6rU4IzQd7AbFkkpDjRMTR/tsN2S5
	UlexJbNnQnTJqzX6Y+dZIDg==
X-Google-Smtp-Source: AGHT+IGKQsNAIUh+xJlHzy3nN2xphCyw1az4JEJ6yq9Qx4/Oq6uuF5spFilgh+DFG3Lfh7up2OBaUA==
X-Received: by 2002:aa7:d386:0:b0:615:481c:7e03 with SMTP id 4fb4d7f45d1cf-61797de13b0mr1103751a12.21.1754471001035;
        Wed, 06 Aug 2025 02:03:21 -0700 (PDT)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-615a8ffbd97sm9780487a12.53.2025.08.06.02.03.20
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 06 Aug 2025 02:03:20 -0700 (PDT)
Date: Wed, 6 Aug 2025 09:03:20 +0000
From: Wei Yang <richard.weiyang@gmail.com>
To: Sumanth Korikkar <sumanthk@linux.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	linux-mm <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
	David Hildenbrand <david@redhat.com>,
	Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	linux-s390 <linux-s390@vger.kernel.org>
Subject: Re: [PATCH v2] mm: fix accounting of memmap pages for early sections
Message-ID: <20250806090320.wdt4zsfiambtgkvy@master>
Reply-To: Wei Yang <richard.weiyang@gmail.com>
References: <20250804151328.2326642-1-sumanthk@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250804151328.2326642-1-sumanthk@linux.ibm.com>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: EC7371C0013
X-Stat-Signature: uuj7srqpr3x1onc86f1z6khrrpbn6hzc
X-Rspam-User: 
X-HE-Tag: 1754471002-145131
X-HE-Meta: U2FsdGVkX18YBe4otxOxIZ147gK0lSOy3DCMmBLr+ahuFO7YKZ9m6k/Mcu/4BmYyV4PtZ9ouXaTq7sdBv8gdVhnFK5Y7NchJDs7O+0hOFseC+pUjqOB/ZB91EPbbXh/0KTolxvWoje01E+IX73TPnHNvP9zSdWZnukJEvGek7lBUfr6LORrmkm1cQZw1ClcVkxip6OD31WZnmWEb1XH4AWO26OwkWgtbhfWgFmYoMIBA/ar7gkeoIQsDLleJvXDUA/Fx3tCdgxyWXCuvXx3OfuMXy3dcw/2NP07AVt1JtywyifeX495taEa5sPhdSOMUU0CklaP3aL3mkMBlJfBb4zr5eDvQGG1h00+DeugwzLFI5G0rh7SgksxIpRH4+zkULSfDoGWyZ57QtqfFuLOx4bo2BkBhghewkTyYXOksLVBDOg1KA18a3U2qBEMjAUmSitfX+lFoU1r8t1ZjO0r/PhCIjdjDpM47EtmLq/LkcuPWjsHBVa5clulDIbsvxCypnfW4hEkWlH6y0A5Bbs0DVe3ZyXN0jmK746YSmcDgVReT1VcxuLmMIRryMXy3ii1unBskSpnHpo7cNDVCLiomhUmznrrq2nbVtcd33wdiCyefDICo40622PEaAQCXJznZRpn6xZOvrKkoXllq13irwxWGIcil3+/OHbRAvIjm4aPeTZqLAoQb8njD2oPSnUXbjVKp5GFcnBCSHgIfm6vtKXU/Oec0rRLA6ONr4QOcyqT+nWAvkV6Yo5os0qMmlel1xakGdxoAUCmxuRMofagiKumIGn1iKMEAAq+UQ59lyHaum9DFxgLTh3vbA1ZkFbvy302FTpC1KATkWStnmY3twXKnBWu9UmLEEtTAmVrzoB5kbaNe0LHCFe0BBQwEBIPqJcVn/9LS2gwgSXGrTgPl8bNPQDRcOSHL3krZZd6gTVuY3R7C8gtG2oGbqEBtpOhGYjpYKDHP7zoyvH7EooF
 iXVoaio7
 MIAQ1K0rNTAO6zLx+sNtx/T4oGxoiYzL+e5U5fZTXdsKuF89IeWVjZTzVtvvytkMS9OE0v+Dus9j5ZfmeriXnJa93Lc1e+5eUp6URDppxbP2EFa/odoY3W2DYksoSm68wB3RHvY9w43VSEUwWxvi9RO8Px1HGbG5g7Rg/eIrqctr/wk5TymX0ZrjfBBfRNMqmHr8G6Lb4JMOGSXwUiuFryXgPtd7I8SJSKaBACaR5zaQQApLzIlMTgjm7ofvW7BO3HxfHM6upQpXno+QEGpHxVI3FwmDLlCE9/aQzVVxZqLVwFpmS4LNhf3HG+uRQNHxWCZeUZUDMifDIDyU5pJHmMVKJQpFfARjkvZUBA1Blzm8XV7olqKvyx90s6fMZI4zgbOHzT2g5Z+puHdEbECNtV2LXs45gS63uQb+CeNdPmKuR9UGFvGID45O0DbDXSmExIcRn/eAGAtRsrZiQJEgmO1Ri5CZ3dRHkblBVjgsUpH66TalnnWVxER7vWfzB7YAYTfdZZqrUqBRUGx2x7rdiNq4an6RusyV1vltKEZYBpVrkioqEK/uLjV2H+5W52BhsQmsAarM6HsbGLEdnByB+m5zELmRr0vGJ2uiuwa922MWnGUhR4ARa+4ECZBljLjQL3LnmYDQtneN0M0SA575eNw9vBxZPZZ6LXwlz
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 04, 2025 at 05:13:27PM +0200, Sumanth Korikkar wrote:
>memmap pages can be allocated either from the memblock (boot) allocator
>during early boot or from the buddy allocator.
>
>When these memmap pages are removed via arch_remove_memory(), the
>deallocation path depends on their source:
>
>* For pages from the buddy allocator, depopulate_section_memmap() is
>  called, which should decrement the count of nr_memmap_pages.
>
>* For pages from the boot allocator, free_map_bootmem() is called, which
>  should decrement the count of the nr_memmap_boot_pages.
>
>Ensure correct tracking of memmap pages for both early sections and non
>early sections by adjusting the accounting in section_deactivate().
>
>Cc: stable@vger.kernel.org
>Fixes: 15995a352474 ("mm: report per-page metadata information")
>Suggested-by: David Hildenbrand <david@redhat.com>
>Signed-off-by: Sumanth Korikkar <sumanthk@linux.ibm.com>
>---
>v2: consider accounting for !CONFIG_SPARSEMEM_VMEMMAP.
>
> mm/sparse.c | 9 ++++++---
> 1 file changed, 6 insertions(+), 3 deletions(-)
>
>diff --git a/mm/sparse.c b/mm/sparse.c
>index 3c012cf83cc2..b9cc9e548f80 100644
>--- a/mm/sparse.c
>+++ b/mm/sparse.c
>@@ -680,7 +680,6 @@ static void depopulate_section_memmap(unsigned long pfn, unsigned long nr_pages,
> 	unsigned long start = (unsigned long) pfn_to_page(pfn);
> 	unsigned long end = start + nr_pages * sizeof(struct page);
> 
>-	memmap_pages_add(-1L * (DIV_ROUND_UP(end - start, PAGE_SIZE)));
> 	vmemmap_free(start, end, altmap);
> }
> static void free_map_bootmem(struct page *memmap)
>@@ -856,10 +855,14 @@ static void section_deactivate(unsigned long pfn, unsigned long nr_pages,
> 	 * The memmap of early sections is always fully populated. See
> 	 * section_activate() and pfn_valid() .
> 	 */
>-	if (!section_is_early)
>+	if (!section_is_early) {
>+		memmap_pages_add(-1L * (DIV_ROUND_UP(nr_pages * sizeof(struct page), PAGE_SIZE)));
> 		depopulate_section_memmap(pfn, nr_pages, altmap);
>-	else if (memmap)
>+	} else if (memmap) {
>+		memmap_boot_pages_add(-1L * (DIV_ROUND_UP(nr_pages * sizeof(struct page),
>+				      PAGE_SIZE)));
> 		free_map_bootmem(memmap);
>+	}

The change here is reasonable. While maybe we still miss the counting at some
other points.

For example:

a. 

  sparse_init_nid()
    __populate_section_memmap()

If !CONFIG_SPARSEMEM_VMEMMAP, and sparse_buffer_alloc() return NULL, it
allocate extra memory from bootmem, which looks not counted.

b. 

  section_activate()
    populate_section_memmap()

If !CONFIG_SPARSEMEM_VMEMMAP, it just call kvmalloc_node(), which looks not
counted.

Do I missed something?

> 
> 	if (empty)
> 		ms->section_mem_map = (unsigned long)NULL;
>-- 
>2.48.1
>

-- 
Wei Yang
Help you, Help me

