Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5E6BD606A326
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 16:23:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7320A6B00EF; Tue, 10 Nov 2026 11:23:18 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6E3396B05B0; Tue, 10 Nov 2026 11:23:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5AAF76B05B5; Tue, 10 Nov 2026 11:23:18 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 313D06B00EF
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 11:23:18 -0500 (EST)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 839C3809A5
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 16:23:15 +0000 (UTC)
X-FDA: 85419729150.05.B3B69D8
Received: from mail-yw1-f181.google.com (mail-yw1-f181.google.com [209.85.128.181])
	by imf18.hostedemail.com (Postfix) with ESMTP id B28721C0009
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 16:23:13 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=debian.org (policy=none);
	spf=pass (imf18.hostedemail.com: domain of breno.debian@gmail.com designates 209.85.128.181 as permitted sender) smtp.mailfrom=breno.debian@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794327793;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=9YuRkRGnxp0vWQ1dHMpnKuM8tkA2uFdXTQzJ8jzW5DI=;
	b=heA1N1gM4Qbb7mrhna87GtYEwl3arwtr48Aq45vIFisJWJg7+YizCOXOCJFS4oMe/mU/J1
	7zoxfEOYZzXJac4EN35OoD2OIvAfCQcbuMB5gmFdpgIw0pNtfY3eUokaP27e3JYD/lfruB
	pZ7SIMbQtXVlRTLWPI3lTrzQcjgSK9s=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794327793;
	b=k4o5FIlZKbgtAdbav0KMNOADpC+qrsVMfuvSgnAip5bDk00N4nxAQI036sgIwuPTHv3MoK
	aznSnapTnZ2nahnAEVfWUBg9SHAy5DUM96zbRWNNwfPfk4Cc4vjyUDLlXUaFdzhn/Vv49X
	ES9JPcnkMQ8mIC3/YviGWI+WwJEt/PU=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=debian.org (policy=none);
	spf=pass (imf18.hostedemail.com: domain of breno.debian@gmail.com designates 209.85.128.181 as permitted sender) smtp.mailfrom=breno.debian@gmail.com
Received: by mail-yw1-f181.google.com with SMTP id 00721157ae682-8b354d27917so19142607b3.0
        for <linux-mm@kvack.org>; Tue, 10 Nov 2026 08:23:13 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794327793; x=1794932593;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=9YuRkRGnxp0vWQ1dHMpnKuM8tkA2uFdXTQzJ8jzW5DI=;
        b=hD2YgLGJthmpcz1yLAOieSAfEKGP7G71ZEerTeak6b1Mco3mDDRfifYa1wTzOuJl5d
         YV7B7+r0u2UYyDLetFUI6rb3MXaC399xv06NnCLMKI/Zb2P2XAgSYzgn3CwaBFpw1ert
         ysgHoJXVf7AWXYa+o3PwH/eCeYZud5220U76BsH3b+uz1jCbsFo1cuh8ENNlchRx4u1C
         1oxz27DBWCy1hnhr/yopowpDI6Rk9CI7PEUzpTvPx777W6kc5kHnfpu/8Sx5glWpgVtB
         yMHKWX555fPnHjiLpXam/4QawOj4Zb6RL4uUgyHDAyphALWUwkzuKP8zX5tyFUWwQEGU
         SXNw==
X-Forwarded-Encrypted: i=1; AL+hErHw8tIULlzLAr6U4lBzlwEHnvc+E84+jEj1S2P7DEDZSOiNWhyYb02tZ2cyLHGpowDM9noCar8pLw==@kvack.org
X-Gm-Message-State: APuU4Z/m90daBiJOJbW09g7vKmBHEdETDMfLBR+pf+FFY71+JZvrTFyB
	zruMPHbYGuZqZCqcFsmD3NX0/EtrDoVOh1ZELjp7soISh4FyhIPJQwMK
X-Gm-Gg: AYBFou2ykwMmHHgcKcQDe72iZeWpWBQGvJgiT7r5/c25lfwh7QwzjZ8+XemUJYqt9x3
	hQ4PlLRS7wYl4Wqslej2XKjL7Qh9SdtFVZ3FcC1uoJu/FmMPkMSHpsPcc75QWPg5RUfnYLmfTUD
	mukJ0BiQirzB5SIFj2/xS1zkViR5OKft0Wki1B8Y9fi8+ev0IjwHNe+yZmE0n9RWPERbM1lYm44
	pBI2920szUBG/7gb0p9U4IAMyzPSWXty/c/kxqiGL3R5dgQ31RsPJg/uZRuycU7HMFoeF9k0/tm
	ZNsYF8y28xSJ7Gj1FYh5Q1yl95a6jjOr2MyoK7QBHLMjzrhb2a0+IVyYWL80f3In3tqWuxDmWgI
	M21lPwBSw+/f0fI7jtLbxZnLO4WHxvvzJag66nfUatqMMD3tMCrv+BqG5wusxREpxZZpfOt+JDg
	KZHkPo05CZeZcLioYBE3DZnzLG2638cQ4fzOsyoyyNbj5YycOiqSW2VGAz2UyTCVmMx6MJJqgiO
	dSH1BLInTn3usq+753vc4aStjOkmJqrpxb4S/ddkT1J3djl1LwIxXvO0svO//NptQ0fX9UgqlfW
	0Njt2lhhHCDAp0FSXe8=
X-Received: by 2002:a05:690c:6607:b0:8b1:901:b9ee with SMTP id 00721157ae682-8b392a58fdcmr20600847b3.13.1794327792882;
        Tue, 10 Nov 2026 08:23:12 -0800 (PST)
Received: from gmail.com ([2a03:2880:24ff:6::])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-8b39324bbf5sm22932117b3.1.2026.11.10.08.23.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Nov 2026 08:23:12 -0800 (PST)
Date: Tue, 10 Nov 2026 08:23:11 -0800
From: Breno Leitao <leitao@debian.org>
To: "Kiryl Shutsemau (Meta)" <kas@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Lorenzo Stoakes <ljs@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, David Hildenbrand <david@kernel.org>, stable@vger.kernel.org, 
	Sashiko AI review <sashiko-bot@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, 
	=?utf-8?B?TWljaGHFgiBNaXJvc8WCYXc=?= <mirq-linux@rere.qmqm.pl>, Muhammad Usama Anjum <usama.anjum@arm.com>, 
	Stephen Rothwell <sfr@canb.auug.org.au>, Arnd Bergmann <arnd@arndb.de>, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 1/6] fs/proc/task_mmu: fix make_uffd_wp_huge_pte()
 prot-update race
Message-ID: <avNEgmvYdoukt6MS@gmail.com>
References: <20260529172331.356655-1-kas@kernel.org>
 <20260529172331.356655-2-kas@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260529172331.356655-2-kas@kernel.org>
X-Rspamd-Server: rspam06
X-Stat-Signature: 6453su9tazsth13x31c8frjgifxa9kxr
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: B28721C0009
X-Rspam-User: 
X-HE-Tag: 1794327793-276330
X-HE-Meta: U2FsdGVkX1+01W/0ry7t7+IS0BMJMYuxFD8EYeIevfxfgHUo1CrXJI3n9gGnPbh9TkzYAIR3GKijRgSh4x78dM4QL+dGVAqE2oYNX3EzSBJVYy8E+m7QGVAipAvEIQmQf3/q2xiWICmT5oo73sodLL5ji724N2vaBiSeKs9KdMa0II9F5WIKbFKt/47NEfvUpC86EC+sLr1VlYcTmLuv3vM8WAvJqQVljvCtEgqvcYDeQWzf9VOfU5iwaXOhNrMErDJ8sj5WY8XAX6VY14s7nipzoBiWtKNhUBnbcYgBTfWaFxQDFvtq8rKrlacWlaoz4vYHc50hg3qMCfWPLHJebRPxfnM7htt9KbYP9503AAGmClWuE6xwffs3teKt1DAnVgz0e+JVOU56jep5iOKje1bojOuTLnDPYTiwN5x033HVtNzZRFszUP7aLigJ4SY0dqI7CScBWLP/frBFZdBOrWkEVlU3+lW58MA12CzE8ZS9Gk+yZWLncqzo4XEJM+6F7arKEtAULSz+5jwogbDnavD9Nzo0FGrAjVs25qKgUu/Nly983CYUO8V6ShLFCmUfKG8dkqJrzoPxDK8Mhok0/8hIGY3gSom90nFYfMcHoOOoUqYcoJDbmS6UcGhznQx8mzSDYo/heHwWW0qrI3o7zhDvZpm8Hoai4taJN8jAadoyLqko4LEXX8PdWh+MVexkNFr/aSoO+H72eiN6VZ7MGVcJ7qfxe6FR2jo3tTYX6K+5VuWQloFMorsBluLz3OE72BIFQtqiR4LNI3qeVKS6rjL7103oy8x+S3I0ewbA6kTHiyoHr5hoBcOUBZjOG/bqBQ5rTYPhIpp8WQhI30kwYe99WPIBJxSLMX59Wn3WOJoVQXT/E7VKe3ryThZBPKS4e1m2ymYkyrW2sOioiNh9dV79Jq+2Es2wi73MK9kZ+KU7jB0IUWI1p05gpLvNFS5kzicdBC6QPT8knflu/QA
 FtTGKqcI
 XFNBv++x746FppCnJBe8CZJ9zU+l7zVWSmz2rR6BUBGHU5WW8VAitDajRqOlJQGGs7afnhDAA8Gd9W4s9r+jijwAPsvgtyTc7gCLnPUn1b+OBksDXc2KfCL1u+vhoujNxnzEuhSaEB8W+lWQJAOIu0L6X/cxMFRqroPvFrksURXI70J4TH0afrGHfbD6E/1yzuJ3D04tWWnfx1ChuHdA4CnVFrFT7GpUTxryN/5AeBm9CF18vhmN68dWANYLn0EQwALzNndt1NaLEdZUEh56m5cWIsCm7tIxYBDOyWpzKuZTlbLv930+t8x3orfqqOKHZr5ywm+rxGYiQx90/XRus3RKdamFR22ACK7f08QPBS+uJylKxYP1mHCKtLrjDdhQw54UsCyQRLdov6s30p9roVpZTaZqFyH7XFkf1LbHtoW6r4bLNvwHwCeWGlb8C1pNHUowVqWAXpXc4fT6fefmueTCZ1UF4YTkeeA4wXeXfZs2dSwJ+aPs/9K1J0qq+ITLzK9exTNQ/wNoLEiafK8jx0HVa6aZhUCsRVQs/QBmYRgjMohKUIOCQNsbg9+An2z6jfk3Z
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hello Kiryl,

On Fri, May 29, 2026 at 06:23:25PM +0100, Kiryl Shutsemau (Meta) wrote:
> The non-hugetlb sibling make_uffd_wp_pte() does this correctly via
> ptep_modify_prot_start() / ptep_modify_prot_commit(). Mirror that
> pattern for the present-PTE branch. The migration case stays as-is --
> migration entries are non-present, so there's no hardware update to
> race against.

I am  seeing this on next-20261109 (arm64, PAGE_TABLE_CHECK) while the
pagemap_ioctl kselftest runs next to a workload that migrates pages:

    WARNING: mm/page_table_check.c:206 at __page_table_check_ptes_set+0x168/0x178, CPU#21: pagemap_ioctl/894691
    Call trace:
     __page_table_check_ptes_set+0x168/0x178 (P)
     __set_ptes_anysz+0x50/0x240
     make_uffd_wp_pte+0x104/0x1c8
     pagemap_scan_pmd_entry+0x1b98/0x1df8
     walk_pgd_range+0x7b4/0xd00
     __walk_page_range+0x108/0x510
     walk_page_range_mm_unsafe+0x150/0x3e8
     do_pagemap_cmd+0x418/0x7d0
     __arm64_sys_ioctl+0xc08/0x1338

given you've touched this recently, I am wondering if you've seen it.

--breno

