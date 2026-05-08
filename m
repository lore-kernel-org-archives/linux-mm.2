Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4524FCD3436
	for <linux-mm@archiver.kernel.org>; Fri,  8 May 2026 16:12:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 82CF66B01AE; Fri,  8 May 2026 12:12:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8045D6B01B1; Fri,  8 May 2026 12:12:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 71AAB6B01B3; Fri,  8 May 2026 12:12:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5FF346B01AE
	for <linux-mm@kvack.org>; Fri,  8 May 2026 12:12:57 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id E849A1C00A8
	for <linux-mm@kvack.org>; Fri,  8 May 2026 16:12:56 +0000 (UTC)
X-FDA: 84744746352.01.091C53C
Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	by imf14.hostedemail.com (Postfix) with ESMTP id F379C10000D
	for <linux-mm@kvack.org>; Fri,  8 May 2026 16:12:54 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=ny9XdFK8;
	spf=pass (imf14.hostedemail.com: domain of jannh@google.com designates 209.85.128.54 as permitted sender) smtp.mailfrom=jannh@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778256775;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=DV4wqH3QxYXnjFXdGhWXuxESZRvhEx+akEv7Iop0Gs4=;
	b=35Sb+xiQuQVuz+2bEPEXHscvfqB13PEFbHQ1QPMb0M7BrZfK8DQR0YaK0uIni6TgTG7MpB
	L2DsHri/LwUJSVxzsaE1vXJcyCZhjPfPq6RPGYvqh42JAS7BLukICf+CW7jl665tmjpyR5
	hztkCabVUNneaW+xoR2PLATluGnqfOk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778256775; a=rsa-sha256;
	cv=none;
	b=AdfCHmc28aLDUquAri+hxOfVzajqlDLBsJXBsVkzS6Nij0v1BBJBCPL6oveQqypNcsWDiU
	H44wdG02TtjYwIQk+S8OwdmwRI/vijISFQefo6lDHzQ+UMrRW64VBRhAq0M/3ZsjsJNFn0
	qBzoAmP9tPrRpK4R9QJka9nvYdKLVlY=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=ny9XdFK8;
	spf=pass (imf14.hostedemail.com: domain of jannh@google.com designates 209.85.128.54 as permitted sender) smtp.mailfrom=jannh@google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-4891ca4ce02so116935e9.1
        for <linux-mm@kvack.org>; Fri, 08 May 2026 09:12:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1778256773; x=1778861573; darn=kvack.org;
        h=cc:to:message-id:content-transfer-encoding:mime-version:subject
         :date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=DV4wqH3QxYXnjFXdGhWXuxESZRvhEx+akEv7Iop0Gs4=;
        b=ny9XdFK8T5yjhexg4KzdfDmiLuheT5woEPK4G0tuKDjpI+oiRGIK2Eeqc/bLGLVLoe
         C4JV3Ds9Dpbh8RPBA+pUJyrg60Fs8Y2ruUX8+F6q/WKRGHDWM1PckDstecGLbELqy4dQ
         9u8wpmX16W4I3pxbJoqO7uxahz/XsETlCMwdMJ6pIfQcztcG6Pm30KtqlsOzYHBlALbB
         4/FrqMFzD60JSPqXu6jOPq/LQ9nN5DQmTR+JW4sexveB+DKZuEeEz7k/MNH94YfzgjX/
         6/ZcDIy8ZNh5QJ2BXPzWrkEDosMZHZ7qd28ru6y5CM+ugfkFDxfJ3dMNMlFoZE/y2Yx0
         OOEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778256773; x=1778861573;
        h=cc:to:message-id:content-transfer-encoding:mime-version:subject
         :date:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DV4wqH3QxYXnjFXdGhWXuxESZRvhEx+akEv7Iop0Gs4=;
        b=EG67qJocm3uyPNVLbKb/IILpMBwzAfioEColzHZ2CRlcFN/u4hEbZtSC5hXSQY31Mv
         sXl1pI5myRjqxI+U8qiLzkLxW/BJGBZeU98xw0c+fkLdCcLunoGAJxcxqK26LjoZ60EB
         8fYByuAXX1JnJSuPAfHNduKKuFMYY4x5svW/IbYL9+nahnxoyqhzSbktD4kBQSDn6xYr
         kiubIt0dkVnDxwKB1WykL+jokM1h5tSzjeSyTE70oYPvNBbcoY8gT9d61mp9kk9SsSpo
         /Gg7av7NxcTclIByut4gtDRfgAzc2MzSs4g9yMl8f8S6cVozfqvb685bvcliYSfKgj7F
         CjCw==
X-Gm-Message-State: AOJu0YwUsBa+WKLhFoWP+VMhlHf2X2c7KYYUy0GDjqjfRlFz4X6ChVkF
	x1O6mWRTfHlGNCaZBDqRlxlo9UllDNUorIBAcosx6kK5ezA8ZS9+qV6M558pObApCg==
X-Gm-Gg: AeBDieu3vyJ+OjhmY/zjPPIe3Q5QlgGOnj22/MrmNVYAZia1XDqt7A+C+FBrm9rW/lj
	sMOn8HUBinMxTNooVFKp9Dp/d6ZJBJQ1Qg624aTKQ0tDW13drqHYe7VB+7o+SuDrp6v+jif/+mn
	vBY9due2v3pt6tViGKM6WvxNDomGNyQkHfE7zbQzjRijKEARnCk+dRdDT8h0el4NVUTQRWXmHSZ
	jk2ME2U3541jo00Hs8/nDrR8SNZISbE/XQErDN8A7seDgEe/Egoostnv0Fbv93FrBQ+1IIkuByg
	Z/SkbSdmMkUkwUiE6nm1oYXJO89rJ8eZK8LCqBhdDJwate52J9qkmzCw1gOam8VQHqpCZK5bm7f
	yjivrnlt14LNGr5BoDLVYe38Du6gFOwAsmU/Ib5r6+CoL/vCJPsaJrkyrK+6GdNba5J5AZx5Wax
	iimEicSEpubiN+fiXNn5AMT9tNdqtT4rtuBxP620Ae0Ua+3SmObZoIy2AdiDiZiA==
X-Received: by 2002:a05:600c:a10e:b0:48e:68e5:589e with SMTP id 5b1f17b1804b1-48e68e55966mr597585e9.12.1778256772825;
        Fri, 08 May 2026 09:12:52 -0700 (PDT)
Received: from localhost ([2a00:79e0:288a:8:9f14:b8a4:32a8:9c95])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48e6dd3fd0csm4395875e9.14.2026.05.08.09.12.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 May 2026 09:12:50 -0700 (PDT)
From: Jann Horn <jannh@google.com>
Date: Fri, 08 May 2026 18:12:42 +0200
Subject: [PATCH] mm: make zeropage read-only
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260508-ro-zeropage-v1-1-9808abc20b49@google.com>
X-B4-Tracking: v=1; b=H4sIAHkL/mkC/x2MQQqAIBAAvxJ7TjBJsb4SHazW2ovKChGJf086D
 sNMgYxMmGHuCjDelCmGBkPfwX65cKKgozEoqYzU0gqO4kWOyTVljd/sqCajHUIrEqOn578ta60
 fe/V0R10AAAA=
X-Change-ID: 20260508-ro-zeropage-86fb842965ae
To: Mike Rapoport <rppt@kernel.org>, 
 Andrew Morton <akpm@linux-foundation.org>, Arnd Bergmann <arnd@arndb.de>
Cc: linux-mm@kvack.org, linux-arch@vger.kernel.org, 
 linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org, 
 Jann Horn <jannh@google.com>
X-Mailer: b4 0.15-dev
X-Developer-Signature: v=1; a=ed25519-sha256; t=1778256766; l=3448;
 i=jannh@google.com; s=20240730; h=from:subject:message-id;
 bh=UDRiTFNTGMxGNkj85pCGPItAs9ImXHnWYb2myZlsZfE=;
 b=6KqEx7t+ZT40aQbtMzUIvTH4xK3X3hxmWX3hc5lSdW7XA53LJ93tRfQmpK7GlNRW+7SUX/bw9
 QzYV5++j9b0AY7W8PMPxo890xz3CkG2XIGkdQXdTDJo5LjzVhI9nffW
X-Developer-Key: i=jannh@google.com; a=ed25519;
 pk=AljNtGOzXeF6khBXDJVVvwSEkVDGnnZZYqfWhP1V+C8=
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: F379C10000D
X-Rspam-User: 
X-Stat-Signature: whihprbycshb7zaycotet65nzj9jwdwf
X-HE-Tag: 1778256774-790966
X-HE-Meta: U2FsdGVkX1/7cyPTP+V+mBlcIjz8gw7/8nwScYi0U7Qx5YxWPzw0B4DiMImsIMkWLNhXmTBDykKryy6yTM7UkULthqyHXMWYAvun7NNO7XJ3NMsXBru/TCz7SZZeXS0ItjH8Kxef5C3yNVlC/yEuD7P7ZAzEL6XjJJgfDtPIgcBs9FrxiQKeaeItecMajQsUT6p1FNM9Cd+HKJ/NfKbT9LCrodRt6IoLeIKo7aF8xQOUbNqJwRzLLuy+XqMQcLQW9tPR3CmMx5nyj+A9B5BqUVfROkxRGcfMvj3gut9xsepNXmCsyPuLhvZ6Xpg4Aw9HLYs0Hco8P/btbpiGQla3+qgPHK2P6h0qwkph0MMcA4EMKyUPGf1iBf83rQq8AFkc6q2FIDNk9z0n/Izcd9pAPYh2/Fr00OBgx9FSTV7oxcZbMKlyHqOxRIXZUxGeZVZCl483Bl5zRHploUAjh+f976lyiZb3eU11acF+jUj6HILBy18oBPRwjhIo8fHKOze092Jxei/r3hkVoMd03R7Exbn/BNwh4fYJU8MM93fXcgzXwCgzBwBTqNaYr77VfgvirrmyLpi8q7uT0dKeWLIojzBXnkA+6mxyeRLRhV7vzL3YjXA+TGNhBPG7G34tRDBH0kx2jqVaakgkeqYAi4HCAziknvoKVqnEaaIyEFVP85tgBPqKGHhTDRpe9a5DQhJr8MLprq2BPyP9frnhNvw+4R9aQUUVPRyAEBmgapi9+mWSeai4Jz88YlD5VbVTApWEXXbL+1MYcwxMEUcOjZ9bQwTQ/Uo64rM1txCgbuWmOpAR1LTdHXbImSL1A52owQ0pni9UBPKIsWUbmpLjL/sXjYc+CJ/ZjUnxO+G3kLEXN5TgD2s9ox2JX2OCj7+YcsvRMNvs7n9Z1Vjh6FQ5nLmH5mS3dMqFQDjP5si4S7kRivCR3LwrFJ0BEAQkKMLMDujmowZGZTsdTK+UlEIuLF4
 +8X6AdfT
 UGWPxlN73mrr48arZIt5g8JU+5bf+wvIAK1+RWvi+ypRZi5R/txcW08ruednvn5dJ/aEZ39ek0pUFDUhsS7A4tHY8JRUsnsafrsD4mgvNFBjf1pEPFg0usZpy9wkWFwNiOePNB/eOnD5Go+8dmUyqEZlZV/5oXAs18CRUpieOXGqbcUWpza6bt3W8sQW7k4Wjg6QHlFRNMt9jtNujYoi/+7UNvLbdZGW41ofg2D+XlPWk95eDylTA9dN2B1YZW2ktl8qjtrQ+5Lp+HYEcYcyF4922Ku0v0ii0pC9hQH+Zr+bjFy1yoZBYiw6HANoOX/fKwMzUrNjNa0GSX/kr6RxrQvhdb+xNFw4k1Pa37sycqSoUeOUhdfJwokIEgg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Put the zeropage in the read-only data section - nothing should ever change
its contents. Set up a new section .rodata..page_aligned to mirror the
existing .data..page_aligned and .bss..page_aligned sections.

There have been several security bugs where the kernel grabs references to
pages from some userspace-specified source, via GUP or splice, with
read-only semantics; and then later on, the kernel loses track of the
pages' read-only semantics and writes into them.

I have seen such bugs in out-of-tree GPU drivers before, and recently
upstream Linux bugs of this shape have been discovered as well.

One problem with these bugs is that fuzzers and such will have a hard time
noticing them, because the kernel has no mechanism to directly detect that
such a bug has occurred. It would be nice if we had debug infrastructure to
keep track of whether file pages are supposed to be writable, or such; but
for now, the easiest way to make these bugs detectable in at least some
cases is to make sure that writing the 4K zeropage is mapped as read-only
in the kernel, so that attempting to write into it immediately crashes
(unless the write happens through a vmap mapping or such).

This patch might increase the size of vmlinux by 4K since .rodata is stored
in the ELF file while .bss is not; but the compressed kernel image size
shouldn't change much, since it's compressed.

I have tested that with this patch applied, calling
`get_user_pages_fast(address, 1, 0, &page)` on a freshly-created anonymous
VMA and writing into the page with
`*(volatile char *)page_address(page) = 0` will cause an oops.

Signed-off-by: Jann Horn <jannh@google.com>
---
 include/asm-generic/vmlinux.lds.h | 1 +
 include/linux/linkage.h           | 1 +
 mm/mm_init.c                      | 2 +-
 3 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/include/asm-generic/vmlinux.lds.h b/include/asm-generic/vmlinux.lds.h
index 60c8c22fd3e4..e6e96bce506f 100644
--- a/include/asm-generic/vmlinux.lds.h
+++ b/include/asm-generic/vmlinux.lds.h
@@ -479,6 +479,7 @@
 	. = ALIGN((align));						\
 	.rodata           : AT(ADDR(.rodata) - LOAD_OFFSET) {		\
 		__start_rodata = .;					\
+		*(.rodata..page_aligned)				\
 		*(.rodata) *(.rodata.*) *(.data.rel.ro*)		\
 		SCHED_DATA						\
 		RO_AFTER_INIT_DATA	/* Read only after init */	\
diff --git a/include/linux/linkage.h b/include/linux/linkage.h
index b11660b706c5..49997b292c01 100644
--- a/include/linux/linkage.h
+++ b/include/linux/linkage.h
@@ -38,6 +38,7 @@
 
 #define __page_aligned_data	__section(".data..page_aligned") __aligned(PAGE_SIZE)
 #define __page_aligned_bss	__section(".bss..page_aligned") __aligned(PAGE_SIZE)
+#define __page_aligned_rodata	__section(".rodata..page_aligned") __aligned(PAGE_SIZE)
 
 /*
  * For assembly routines.
diff --git a/mm/mm_init.c b/mm/mm_init.c
index f9f8e1af921c..67b260acc27e 100644
--- a/mm/mm_init.c
+++ b/mm/mm_init.c
@@ -57,7 +57,7 @@ unsigned long zero_page_pfn __ro_after_init;
 EXPORT_SYMBOL(zero_page_pfn);
 
 #ifndef __HAVE_COLOR_ZERO_PAGE
-uint8_t empty_zero_page[PAGE_SIZE] __page_aligned_bss;
+uint8_t empty_zero_page[PAGE_SIZE] __page_aligned_rodata;
 EXPORT_SYMBOL(empty_zero_page);
 
 struct page *__zero_page __ro_after_init;

---
base-commit: 917719c412c48687d4a176965d1fa35320ec457c
change-id: 20260508-ro-zeropage-86fb842965ae

--  
Jann Horn <jannh@google.com>


