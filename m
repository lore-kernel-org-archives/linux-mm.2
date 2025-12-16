Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 30556D5B161
	for <linux-mm@archiver.kernel.org>; Tue, 16 Dec 2025 08:00:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D787F6B0089; Tue, 16 Dec 2025 03:00:03 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D436F6B008C; Tue, 16 Dec 2025 03:00:03 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B10336B0089; Tue, 16 Dec 2025 03:00:03 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 9AAA56B0089
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 03:00:03 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 50579592F0
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 08:00:03 +0000 (UTC)
X-FDA: 84224585886.20.0119A23
Received: from mail-ej1-f46.google.com (mail-ej1-f46.google.com [209.85.218.46])
	by imf27.hostedemail.com (Postfix) with ESMTP id A9EC34000A
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 08:00:01 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=RtRlVawc;
	spf=pass (imf27.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.46 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765872001; a=rsa-sha256;
	cv=none;
	b=c+TnBzVo16wwRmU2ojXE5SOuC0AieMUmgGSEXYO6t8813GfBV66BYFIxG608N5pFQqZ1Aq
	AvEiTxLGOUD0aeFZqKByosR+jy1nQmV9191tKCBaxsXpIy5SZJi+fTTE2p7cmOWaUyj7UU
	4PTvxfQKeW1Pc7eoXQ6quUQiuBImU1Q=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=RtRlVawc;
	spf=pass (imf27.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.46 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765872001;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:
	 references:references:dkim-signature;
	bh=ZO1PEu/0/K1oMgOCC+9uHQEITDWxO1rX/96ca4rKfkg=;
	b=g9k0vqOO68zaaRNRIuH9oQ6R5NSUwylc18nVKz1rEgHNu8DwUNDB+3yjx81BXmrhK39Tu4
	Wswa3uLHdFaA3QxQQ/B++UofFKaF2MpbhIGYzlHKpL35lrEFz5gwy2n0Ku2ZrOuPde3ZkL
	oKTk0wiGsC8ZgI5YRQTtH4HDlw3A3n8=
Received: by mail-ej1-f46.google.com with SMTP id a640c23a62f3a-b79af62d36bso817165666b.3
        for <linux-mm@kvack.org>; Tue, 16 Dec 2025 00:00:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1765872000; x=1766476800; darn=kvack.org;
        h=references:in-reply-to:message-id:date:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to;
        bh=ZO1PEu/0/K1oMgOCC+9uHQEITDWxO1rX/96ca4rKfkg=;
        b=RtRlVawc+Hon9mA2lv9AyAKHaZ4kSwqxpYOKoFMbaNHTEuUY+PyfgodCL7zj/DNmAZ
         Nw87K6uJj5CJVPHbPaJUQvM8aEJsYBehyvEKmyxAojVucJtkyz0NCA9HE9jHSSGIEzsc
         D1h3ROWWJ0vdbPuoHt0OVrzdKye1/F3glf3fy06ACi6GS3QKjsuHkqZpibJOWNLxuF0p
         IcEkuSMozm6qvbif0ejqtGnS4VlTLmka2mlUzku9icCRz/tjzoPRinu/JIR8QpK3x3uy
         +msAxWfxiTvATIm3q/Oyg+pe0vax2cRVKz9mgPU2IVVHz+aLIYMOYJAxo0GXpUEu2Uxd
         2BmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765872000; x=1766476800;
        h=references:in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ZO1PEu/0/K1oMgOCC+9uHQEITDWxO1rX/96ca4rKfkg=;
        b=Xr3c1sMuFnnv1TjEZ54xtCZphuxrPoQj8yMTyvaF6/J8U8C8LSE1j0SJ9m7AgATGuo
         qA8MnWUBfYfHr3OlkACixRh7MP54kkE1VxjB8dlql3rs7yKdyReBV7/gyBLzR9E1Ag2M
         Fo4M6f5lKkZGNPQya1Be/JC1iWHe/2X2a4iqnDAQRGysD/OpAk/3ohBYGQv/2cr/RkYo
         6VL6s/EQ9RF3tk5EIIZqLHwPvaI30Ll18iP0w20gpj8XflAskjuGmDVOwBd3Mvu0joTN
         6VF7lpaABvYLC4agEObS/VmYcBvUQB+5y+GGOmmhfbcN7h2MNQZf5k4Sjv2PS1IQeQD2
         WRfg==
X-Gm-Message-State: AOJu0YxlCbAH0Qq2L5XhDOF9FebChYPnuzq4CmLeUEOTdiXs3BGB1ddS
	RdsOMKeD3vjT3dj6orlHwmpC64K0vpPA4H8UG2coNpSgkukUx7AzrKu6
X-Gm-Gg: AY/fxX7FypWaPE1kjKDmkoETOhPOzx2zxP4OF1e0InrMIZBI3tgOG6xb0ZYvKVQ8DQT
	wKSLcJP/LFvz9EgP7ART5GoPH6Cdl9w191yffXdFnjXJhqLhvtKEZTY7yl/TKaViH+7yZaAGc+k
	42+v78Cr0uk9/dvDli67qweigiC+2iediEeEA6PqDtOSbTg9oBvGHspgSVGEcTRx9Trk1nfUy7U
	sN6EPaPnWvT0Q544QYXa1f82gjGY54a/JZUS2x5HAS+zuLEeO3hcr2EwLm2d0sXDZ9Kq5K46z8s
	lKcBIScLaAcnESfzJq68/jODVleG/zvdU6d3fA8ZnfZ+b3APqxBwuHfOxMqztgBQew85aoFFfLP
	SpMqfYw4/IhuKGiRe1XjakIuMS/Q9Kqaa5ggi8ZMLimhi1SRamtsM3TW7+777aqjgwuYv7WRSJu
	ffwlD2fMGnhg==
X-Google-Smtp-Source: AGHT+IEZPijD4PzFb+9yz5Q3oqGXk8IlzwTdV5jpWcxguGfuNbgaZ+oWaH0YD0q61acxFRbqygrzng==
X-Received: by 2002:a17:907:3da4:b0:b72:af1f:af7d with SMTP id a640c23a62f3a-b7d236c7876mr1441557866b.29.1765871999769;
        Mon, 15 Dec 2025 23:59:59 -0800 (PST)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b7cfa51b864sm1552937666b.37.2025.12.15.23.59.59
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 15 Dec 2025 23:59:59 -0800 (PST)
From: Wei Yang <richard.weiyang@gmail.com>
To: akpm@linux-foundation.org,
	david@kernel.org,
	lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com,
	vbabka@suse.cz,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com
Cc: linux-mm@kvack.org,
	hanchuanhua@oppo.com,
	v-songbaohua@oppo.com,
	Wei Yang <richard.weiyang@gmail.com>
Subject: [PATCH 1/2] mm: bail out do_swap_page() when no PTE table exist
Date: Tue, 16 Dec 2025 07:59:42 +0000
Message-Id: <20251216075943.29593-2-richard.weiyang@gmail.com>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20251216075943.29593-1-richard.weiyang@gmail.com>
References: <20251216075943.29593-1-richard.weiyang@gmail.com>
X-Rspam-User: 
X-Rspamd-Queue-Id: A9EC34000A
X-Rspamd-Server: rspam04
X-Stat-Signature: a6q5sat3t3fhecdyaqc9ywdtj6bgwsyi
X-HE-Tag: 1765872001-639253
X-HE-Meta: U2FsdGVkX18pfGnpnEdnaIFTMjGuja/7rVPll+hctLFuLLFwkC1E7oULFKtUwy/Xyk8ehq1G5Wlu+xnRT9y+wa0Pf4YOUXReTEN3re9WMebBz0ULwYbE57eiawzCZYi0DXnKUDp/+F2xMvwx9kmP9wVL2WuGtgeElHAqtL4oIojbtUAdq7G6/UshuV9IcV++dyIwkHMLsMvJ4TFYLPNQ+okQmloMBKglg+U2uq7A1QrloHtGIPd0zDZ//zuM2pp7TeHE91I91fICYFfIythcIGMvQ/YZYKPjSptv0FP58bygdVm1LT9OSlsF9R/QXykBW2Qj1SKitU3lj+kBmfNEgs+u+Xpfk7wLclbyUsMReITRnZuzz8fRQX5gqxTenoaGDmgEmX9EBtGPcgYwnJmdWFxk+3YDXxGCEgLW8IbuM9rWJVpcia92V5fJVytXEGPx3NiUdc3CwkAO6J1jaZIH8pFcLmTynMnOOLbyg5i7pVgHxtYYu/CNHSVHgr//S52jA4+EqF8uVQBBsvoKPpV9O66nfDcQsJpGJeeQU96HSs1i6ztO/l5JAvdSl3jpczAJrfJDkrR+UNbLcRN5yB1LzR599uPY2TROJU3V6SPHEmTETF8yfCMM0jXi4TIzuolHabbVQB4JaqsLyD6fZZVuymN+6h8HYTOHNjMvHMtlgJNOioVnBpaCWvTjphUI3tTOfQSD3LCuTeUxc9v9K1k9zqrWh/bCTB+/Fz3he8dYB9YDdBct56lBDlrYoMFta++EZl1s5TWN1LaojpgV9sWRJ9CoHW9xzQu3zSkVJOu095iCjztZCo5pw0AdD9foOJbfCEqYBZJS+la1u6IF/L4yrcz5MAdSmyHOQm+Wj0ALB1l9zjrldJvalv+b6Ga0bnxRFscQkdORiIp0We2dRA+5ew7bGXjLYXAAW0yfhVNq2lFMbfK6jaxY9v8j4TNBRMycsqZfeHzkrzuRZOxkHuP
 4ilrWM3L
 zKxkZ1lZe9u9Sw7fodeAewpQgRv0+OUnQH0yqM92T6efhHOPdFTH/Tf94NEiS+7b1X6Lv06AU5A2XeNlOx8zjjxEFC4XtROE1hMDjtJuVD9JDdhIp3Qv9yZU+Fz1OP5+oX86EVUVtyyK8cC87G1hxZfDx7yuKsJwsW8fuKlRFXhLAx3KeDisWC9bT0PHj6cLWpVIzMnDFP9t9OIAHu/Qw/7tUAA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The alloc_swap_folio() function scans the PTE table to determine the
potential size (order) of the folio content to be swapped in.

Currently, if the call to pte_offset_map_lock() returns NULL, it
indicates that no PTE table exists for that range. Despite this, the
code proceeds to allocate an order-0 folio and continues the swap-in
process. This is unnecessary if the required table is absent.

This commit modifies the logic to immediately bail out of the swap-in
process when the PTE table is missing (i.e., pte_offset_map_lock()
returns NULL). This ensures we do not attempt to continue swapping when
the page table structure is incomplete or changed, preventing
unnecessary work.

Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
Cc: Chuanhua Han <hanchuanhua@oppo.com>
Cc: Barry Song <v-songbaohua@oppo.com>
---
 mm/memory.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/mm/memory.c b/mm/memory.c
index 2a55edc48a65..1b8ef4f0ea60 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -4566,7 +4566,7 @@ static struct folio *alloc_swap_folio(struct vm_fault *vmf)
 	pte = pte_offset_map_lock(vmf->vma->vm_mm, vmf->pmd,
 				  vmf->address & PMD_MASK, &ptl);
 	if (unlikely(!pte))
-		goto fallback;
+		return ERR_PTR(-EAGAIN);
 
 	/*
 	 * For do_swap_page, find the highest order where the aligned range is
@@ -4709,6 +4709,8 @@ vm_fault_t do_swap_page(struct vm_fault *vmf)
 		    __swap_count(entry) == 1) {
 			/* skip swapcache */
 			folio = alloc_swap_folio(vmf);
+			if (IS_ERR(folio))
+				goto out;
 			if (folio) {
 				__folio_set_locked(folio);
 				__folio_set_swapbacked(folio);
-- 
2.34.1


