Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DB710CAC58E
	for <linux-mm@archiver.kernel.org>; Mon, 15 Sep 2025 05:50:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 45A038E000E; Mon, 15 Sep 2025 01:50:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 431DC8E0001; Mon, 15 Sep 2025 01:50:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 347CA8E000E; Mon, 15 Sep 2025 01:50:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 263518E0001
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 01:50:20 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id BA7E785FDD
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 05:50:19 +0000 (UTC)
X-FDA: 83890409358.26.CC7C055
Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	by imf13.hostedemail.com (Postfix) with ESMTP id EBEA720006
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 05:50:17 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=linaro.org header.s=google header.b=Z+inJ1xG;
	spf=pass (imf13.hostedemail.com: domain of dan.carpenter@linaro.org designates 209.85.128.46 as permitted sender) smtp.mailfrom=dan.carpenter@linaro.org;
	dmarc=pass (policy=none) header.from=linaro.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757915418;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=HU5/MQQViK4b/UziByBlT4kUJzN1BpctHBOgMBQGgMA=;
	b=fyPQZq/7pHeD88i5b2tsRU8SmyMPicVUho7WrtMw4OtoC+//T+OOb2WUKcWuhQVDGFfA2K
	vGtp+dCYWxvM5dDRAzJqZXP3npc75iX5Q5m6hLXvRrJLbfY5D66SiIyz0OyZ5EH7dyEsPz
	MuayXRX95J24CgICGh0FnGN8uUr8piA=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=linaro.org header.s=google header.b=Z+inJ1xG;
	spf=pass (imf13.hostedemail.com: domain of dan.carpenter@linaro.org designates 209.85.128.46 as permitted sender) smtp.mailfrom=dan.carpenter@linaro.org;
	dmarc=pass (policy=none) header.from=linaro.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757915418; a=rsa-sha256;
	cv=none;
	b=oYJrvkAyfmvHykVCRPqXBzICkBHUwmoDp5+3vbZ8elsACbCZIUnj2iPKqz/ZX2Z0Uf2kQG
	39yqACKo/SH+I63cWrVgyFQkx0OMzm6b3RoMnTCkmtbMMtFtib/5Ty8xZgz/QKLBs0BMNR
	1reV25SbnT1tdOkTjrMolvyBwgUEe1k=
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-45dd5e24d16so35443745e9.3
        for <linux-mm@kvack.org>; Sun, 14 Sep 2025 22:50:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1757915416; x=1758520216; darn=kvack.org;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=HU5/MQQViK4b/UziByBlT4kUJzN1BpctHBOgMBQGgMA=;
        b=Z+inJ1xGxwx2eR78wT8SkueEObg0CMsEyc1ikQPcX/t+IqZgSXH2NVQr7p9e6vKmjK
         WtINvciEhH3NTYVVnABaJZFOwEgnHk5RWSxySXh3oR9uHapYz+G3yP7gQ5X3Mb5ojxyC
         n9K/odxZnCAU/33OP3QRtfjFNpskFL1u/o+857srz5ftVr1VFXlZMrI/ysKwFljuphte
         js4k7iCXhL1F6NHm22PC8vpNiDHV9MoexIrPC7WCBOIM6rrBuqa0byaaoVL5AP0i977u
         wpd7Vw+FY3T1a6TrwBiTQAY1v9JCaVx1kjcV0R/QCh+zKqHrqTAbZZVk0MuCFTgFnaLC
         pvOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757915416; x=1758520216;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=HU5/MQQViK4b/UziByBlT4kUJzN1BpctHBOgMBQGgMA=;
        b=aYz15Vj7F5ugHDXTNOdHn9c7ZXcBMJ/zT6XJl5SSKjY8iGGQTdVcnEugpT2pShDV0R
         QJqRjKm2G6K3/mGhOVza1uV72UyrmECiWIR078hlOeLZ4Z1a8Uum05xjDPxiQVeH+cd5
         I1tO9nPt405Yk+36uHAKYsutBGCTqgiDwpRbVSD9stpGCyZ1uhPkl1V0O+ssG+XwL5aK
         GicRaiwlM0mw6SJSAIwGQidwm256tom+8rVodOIgGPeF2aabevSZTTYscW+lFRi3QyCJ
         FZEucqoQmM8hYbyJ40PBLjgv3C2RXvkTHbbPpewjM4ib0ka5ZdoLkLbDipI3Q7w5HCaR
         wAIg==
X-Gm-Message-State: AOJu0YwUJ9uluv1SOEX+sxz2IxYynqpWAT2v1Ia2bZg+ICi7/JU3KwfR
	fFSNrSQp6aFrzj72OpZJcaZogXya9hAdCtR3zHGSf8nUDQuItiZ9wbzPG2KwK6Ee7pSJRK9wleI
	LoDKu7V7csw==
X-Gm-Gg: ASbGncv2mhNQ6G0EmymDolRBh2TiikgL3huMFlhqPAyCehyLQjBCcVREfAbGxLSL/Fs
	8wq/Cv2MUZnnX3o4YOc4w91G2uev432xuhe1QgiExSmfYab2exLKdJaUMYBqDowJ0KcPf1pUKGQ
	vXsGFDyhOYOlseewArQUfFt2thy1BPmzrZxakoIdBXVmSrAe3KQ+gEOAmQXzCIBIkI8WpnPStxO
	Uo4umZTkr8yt6+Rl4+NRHsBHTy1euFDg9+5vcJHZvzbuZUAk+iDNS8oLb8S5sxtQCFguntqZxI0
	BTgKAF+gW1KDTuKZc+d9usQTHnHqfW0Xyhkm6NProfwM3yfJ+ACZOp/ymGHqleWz4R0cdtRlu1N
	eqDvDrtOrVYFzfELhnA+stmRf/I9Np6FfNIhE9w==
X-Google-Smtp-Source: AGHT+IGh5/JjzDXPftX3S+nlB8LFm1pOcDEKiHPHI/WFfamrsuXHNDaAFsyKodUxEAiPjhFzFfB3WQ==
X-Received: by 2002:a05:600c:1d20:b0:45f:2cd5:507c with SMTP id 5b1f17b1804b1-45f2e1b5a98mr7288725e9.36.1757915416432;
        Sun, 14 Sep 2025 22:50:16 -0700 (PDT)
Received: from localhost ([196.207.164.177])
        by smtp.gmail.com with UTF8SMTPSA id 5b1f17b1804b1-45edd9f75d1sm141180745e9.17.2025.09.14.22.50.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 14 Sep 2025 22:50:16 -0700 (PDT)
Date: Mon, 15 Sep 2025 08:50:13 +0300
From: Dan Carpenter <dan.carpenter@linaro.org>
To: Balbir Singh <balbirs@nvidia.com>
Cc: linux-mm@kvack.org
Subject: [bug report] mm/migrate_device: handle partially mapped folios
 during collection
Message-ID: <aMepFTHx0wq-ZBAt@stanley.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: EBEA720006
X-Stat-Signature: mkb3qe3tmpha5e6bg8j8kofedni87c6m
X-HE-Tag: 1757915417-297760
X-HE-Meta: U2FsdGVkX19l3zl9PSo8EC/An/TrBlC9w+U7TPgfCsGcqaiQd/RQT3TufKrHQ8Ji99RdcQInBVvLsHioRs5HHykm4HsmTKbNz7/6xH2eAUCqXuMMye4ThyuxbuAnzVh4CfsC71ls2jsNZoQp3t8eLkGg4Hl/Xz7bJEysBzSLlNgAu8D4hmk7LCXJGJ0htmpdmGFpYSqkLMjhtiz1A2dQ3fDrAGorrOYpCHtUMZvHwkMYgDk3vXvxvinCBJ+XSIbkwKjxueLeCIlfnKbuWFFBtBfGRASiNCzpCJblfKs0piATEMCpY3UNOvtqfNVtNfmbZtLYgmg1A+bIxzFpYRTZ40693VLE2IP6EJ2Bm+MzikkAO77dqxKbMChEVJwptMghJHz+OJM1Tbv7mKzUBoRFTPCwU3WxpqLwPPI7yk6JWOVkM4LI9vCj3qdixEEekmUECRvUXgbYBKroIfP7jLoop4iIMrMyBlSbJFxDudjLRlndXlztaBlV6KkFFq69owLvFIREt9tfoFs8sxa04RndcK7d0RRR3QqYj283CAu7UFEAC79mH94ailDLYUAZqvo309/dU0XdQPSMGxrpHUMJ257fKLVZW11Nl7rxXYIOSqxoK/77S/KXVY9qxnifbv4ff6tuVvnpy0ugfAN27ibUH+0bpVcNI5BZfSl0ONZv+str12EtTRxQquy69nhm+hRzKke7Iw6OjiAyzpkfyMFuoxF0W0dOpopGSHEX7tvuPuDXgEZyEnR8nBxYCFWSK/g/nQ/r0Ak6LUJ7P5t0oBx3tfJbUMaQQEfju/mALY+fQ1bc28PgVhZJBlt/xaix1Y4yIyLkNrBs6jRp1C2TuA0yL1WDxn70f4Hhq7CE6N39noTqHoUtrkIBX1EvNDVY6cBC7VaoXizVZZXLiLhZOvLBdl+IkzO+T7nBygWdieEwLfV0TW5UnBEt0mUBhisMfCpP14hPPYX/tFhTlsgYku8
 200cxSm1
 DIbxyUm6ENs47L4squejUQB6/80FYwev/CV9TThEggXTvjnV4U60K4XCjfniga579ABCtRTHM3YQxFdX8kuaJHj//sU33gjxpxCpGY8EtaSkkKxRI3BcBVmYOLTxh18t3/H8t7IP7lvxqBK2TRJUFjoH0ZdDSJv/JeAANGRiYRpww75f0a92PTG8i0z5+fW6LNDCA96PwKg9wQ0ZybR3ARZId0Ag7hp5oudcwVwjudOXcIPo97JKQy++T8A1o+VFNOLbQYggQ2V21t3diMalvka9fGwNtI6RH8MZvn0trE+mrSij8vdkuSfPQK33rTwa6xTEz
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello Balbir Singh,

Commit a7e62d34c9bf ("mm/migrate_device: handle partially mapped
folios during collection") from Sep 8, 2025 (linux-next), leads to
the following Smatch static checker warning:

	mm/migrate_device.c:352 migrate_vma_collect_pmd()
	error: we previously assumed 'page' could be null (see line 344)

mm/migrate_device.c
    244 static int migrate_vma_collect_pmd(pmd_t *pmdp,
    245                                    unsigned long start,
    246                                    unsigned long end,
    247                                    struct mm_walk *walk)
    248 {
    249         lazy_mmu_state_t lazy_mmu_state;
    250         struct migrate_vma *migrate = walk->private;
    251         struct vm_area_struct *vma = walk->vma;
    252         struct mm_struct *mm = vma->vm_mm;
    253         unsigned long addr = start, unmapped = 0;
    254         spinlock_t *ptl;
    255         struct folio *fault_folio = migrate->fault_page ?
    256                 page_folio(migrate->fault_page) : NULL;
    257         pte_t *ptep;
    258 
    259 again:
    260         if (pmd_trans_huge(*pmdp) || !pmd_present(*pmdp)) {
    261                 int ret = migrate_vma_collect_huge_pmd(pmdp, start, end, walk, fault_folio);
    262 
    263                 if (ret == -EAGAIN)
    264                         goto again;
    265                 if (ret == 0)
    266                         return 0;
    267         }
    268 
    269         ptep = pte_offset_map_lock(mm, pmdp, addr, &ptl);
    270         if (!ptep)
    271                 goto again;
    272         lazy_mmu_state = arch_enter_lazy_mmu_mode();
    273 
    274         for (; addr < end; addr += PAGE_SIZE, ptep++) {
    275                 struct dev_pagemap *pgmap;
    276                 unsigned long mpfn = 0, pfn;
    277                 struct folio *folio;
    278                 struct page *page;
    279                 swp_entry_t entry;
    280                 pte_t pte;
    281 
    282                 pte = ptep_get(ptep);
    283 
    284                 if (pte_none(pte)) {
    285                         if (vma_is_anonymous(vma)) {
    286                                 mpfn = MIGRATE_PFN_MIGRATE;
    287                                 migrate->cpages++;
    288                         }
    289                         goto next;
    290                 }
    291 
    292                 if (!pte_present(pte)) {
    293                         /*
    294                          * Only care about unaddressable device page special
    295                          * page table entry. Other special swap entries are not
    296                          * migratable, and we ignore regular swapped page.
    297                          */
    298                         struct folio *folio;
    299 
    300                         entry = pte_to_swp_entry(pte);
    301                         if (!is_device_private_entry(entry))
    302                                 goto next;
    303 
    304                         page = pfn_swap_entry_to_page(entry);
    305                         pgmap = page_pgmap(page);
    306                         if (!(migrate->flags &
    307                                 MIGRATE_VMA_SELECT_DEVICE_PRIVATE) ||
    308                             pgmap->owner != migrate->pgmap_owner)
    309                                 goto next;
    310 
    311                         folio = page_folio(page);
    312                         if (folio_test_large(folio)) {
    313                                 int ret;
    314 
    315                                 pte_unmap_unlock(ptep, ptl);
    316                                 ret = migrate_vma_split_folio(folio,
    317                                                           migrate->fault_page);
    318 
    319                                 if (ret) {
    320                                         ptep = pte_offset_map_lock(mm, pmdp, addr, &ptl);
    321                                         goto next;
    322                                 }
    323 
    324                                 addr = start;
    325                                 goto again;
    326                         }
    327 
    328                         mpfn = migrate_pfn(page_to_pfn(page)) |
    329                                         MIGRATE_PFN_MIGRATE;
    330                         if (is_writable_device_private_entry(entry))
    331                                 mpfn |= MIGRATE_PFN_WRITE;
    332                 } else {
    333                         pfn = pte_pfn(pte);
    334                         if (is_zero_pfn(pfn) &&
    335                             (migrate->flags & MIGRATE_VMA_SELECT_SYSTEM)) {
    336                                 mpfn = MIGRATE_PFN_MIGRATE;
    337                                 migrate->cpages++;
    338                                 goto next;
    339                         }
    340                         page = vm_normal_page(migrate->vma, addr, pte);
    341                         if (page && !is_zone_device_page(page) &&
                                    ^^^^

    342                             !(migrate->flags & MIGRATE_VMA_SELECT_SYSTEM)) {
    343                                 goto next;
    344                         } else if (page && is_device_coherent_page(page)) {
                                           ^^^^
This code assume page can be NULL

    345                                 pgmap = page_pgmap(page);
    346 
    347                                 if (!(migrate->flags &
    348                                         MIGRATE_VMA_SELECT_DEVICE_COHERENT) ||
    349                                         pgmap->owner != migrate->pgmap_owner)
    350                                         goto next;
    351                         }
--> 352                         folio = page_folio(page);
                                                   ^^^^
Unchecked dereference

    353                         if (folio_test_large(folio)) {
    354                                 int ret;
    355 
    356                                 pte_unmap_unlock(ptep, ptl);
    357                                 ret = migrate_vma_split_folio(folio,
    358                                                           migrate->fault_page);
    359 
    360                                 if (ret) {
    361                                         ptep = pte_offset_map_lock(mm, pmdp, addr, &ptl);
    362                                         goto next;

regards,
dan carpenter

