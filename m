Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 25DCBC61DD3
	for <linux-mm@archiver.kernel.org>; Tue,  1 Sep 2026 16:52:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 27B5A6B008A; Tue,  1 Sep 2026 12:52:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 22B4B6B008C; Tue,  1 Sep 2026 12:52:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 11C8E6B0095; Tue,  1 Sep 2026 12:52:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id DA0AF6B008A
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 12:52:53 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 621FFC03E8
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 16:52:53 +0000 (UTC)
X-FDA: 85165787826.13.0895F81
Received: from mail-pg1-f173.google.com (mail-pg1-f173.google.com [209.85.215.173])
	by imf24.hostedemail.com (Postfix) with ESMTP id A72F118000D
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 16:52:51 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=UbjbsdLR;
	spf=pass (imf24.hostedemail.com: domain of ekffu200098@gmail.com designates 209.85.215.173 as permitted sender) smtp.mailfrom=ekffu200098@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788281571;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=RHHQttzmL/RMe7qqTs0lkFSMfGHWu89ckwe8EHNKjuE=;
	b=1U/txvN3RWUBgOBiqw3jAuEjRAJene006mcFVWQVFhjk24m1k4Kq9WW1AyyZUfiEP9lVSW
	pJgBdU/nYlI28WWNfUjaXANRvYsfgzYtqR0+y0dYOQ3eyGHlhap759XhN5Ledajl4Yf8yR
	JU07Fn5gzplrPr//jOqW2O7cjYob5yY=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=UbjbsdLR;
	spf=pass (imf24.hostedemail.com: domain of ekffu200098@gmail.com designates 209.85.215.173 as permitted sender) smtp.mailfrom=ekffu200098@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788281571;
	b=fChlkcxnK7TzBqRsZgti9KJz7Hf1/A1HT2wfJ8ITukz0jfwNVjCwLOSEvWc+83G0ROWGLx
	NteoWWDhweqUBxLT575fBz2f9P6Yo4sEKpshRWFd17UgAhwLCxspFnH0fsfdnV9sZXYSiR
	fZxthrWofCa/BoJ3S1yu0j+m9kwc1eM=
Received: by mail-pg1-f173.google.com with SMTP id 41be03b00d2f7-cc1c7364550so98655a12.1
        for <linux-mm@kvack.org>; Tue, 01 Sep 2026 09:52:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788281570; x=1788886370; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=RHHQttzmL/RMe7qqTs0lkFSMfGHWu89ckwe8EHNKjuE=;
        b=UbjbsdLRGfEcNvOf30+pKll8+NKBDrN+/mq6tXJmBRe+TiZf/SPVXn1ZiIUDQDpmOq
         eZUm5NARqN/nii/UhWBa78VlSZ2RERnj/TNaVD+73bB4otUsEo5FswLm8pjlMe8slzfk
         xNctBnC6POWIX5G/pmuUAYFm+FiztZ6rfyr2w6fxKB5/ztJp26zQXbH69U5AMM0HDK8u
         d5xxmI5SoKFXGdzHcYt/7+h4GGnrJWLB6RPIx8T49JdXwcNvyDfjl+aRjg1HGiiGxHg3
         IBMMlR+ZvndujYtv7DuI7AvqIm2c3joiUMsSCG9/SOfqmC8R5L+ooIJYUkt7xm7ORh5f
         iW0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788281570; x=1788886370;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=RHHQttzmL/RMe7qqTs0lkFSMfGHWu89ckwe8EHNKjuE=;
        b=ARqgTOnz0WIOIUBwLsCIhuT2QcnEktqc/ceUybsMBEdppSBMg5SCQviaDtW+bOZLXl
         iClVpFZhQtHe7plHjAALolnBej5MAs//07sdQuhDRYDzkHZsiLigahyTDuRhe1sc1bcY
         ARhMEA6/dT0YE2PhYj307fo5OAzuZqvzbXYyYOSiBtWmDrfLsnP1EtfWefAsV+tgZjGG
         IthWZedMvCW2N5EJc8VLwWiS+pd477r26ByyuzpPifs+MJ2owU5o5Ce1TekNeXQWfGKc
         ylGUFmQE60H8BjO6EvrLYA9uYlbKb8DRpfEkgsWxHsSSpqWHFKONLdEUY/ylfHhUKhrB
         qmsw==
X-Forwarded-Encrypted: i=1; AHgh+RoopvN+tejyvVSYVzXyLnQqwPMOokOSYL0J96+97yb/V2sLuivtnRIGpCQ3aSjW2QLtp6zk3QZHkw==@kvack.org
X-Gm-Message-State: AFuF++mG4pkOMpyvM0QoxRBtSE/EoDDCA93+SHnT8pWMmnBh+6sr0EsF
	R4l3ufvF34UdECU50REtevoeM8fhxo4ZLgA40MtokMus8gyUkkPlpJPz
X-Gm-Gg: AR+sD12v2npaPTP/DdI5AXEQNECwEsJIieWZ1g3P8HK8c3Nzb71Y5Cck6kAEBBOF4Io
	Mgu7n+xnMVX4wMidyXZDfk4H080xmIzpCWsVrVxClSQdBMdGwONXN/w9PaiPr8AeF5QbpnEBPd2
	GZ4hzO4vV+TXXcnFDgk80PlZVXiKaZWmlfH/zcjLzHozMPRXl4x3YBX7LVNkHj0918w4w3/LkG3
	oR+Ti18jFQdxaMah/KE5JBBBgkDiK36prEXcuwiSC6d7gDyDzPm6fYxP8+yrjfLkWWGhAqXCjrx
	vE5SqHkDRPnPMAJFjYPS3mp6rxEpoYW8KIOvgFZhiNXx+OeTeLjAj59RT/Sm62Ze8w85FazJ3wd
	xJEbwUAHz4LhCI5yhX8rUjzQf4lR5WOrROx0xO1oIPtV+YfNkU+Ot+F5OWb3NBUCvg4FlPwHOJn
	qY07QyXQa5LsbexNNRq69qnfFad1Q6F2CTSdFbmhJfyDxCdA0+OeCQ+R4=
X-Received: by 2002:a05:6a20:9396:b0:3c3:791e:5e18 with SMTP id adf61e73a8af0-3d7ae4ee59bmr15597749637.7.1788281570393;
        Tue, 01 Sep 2026 09:52:50 -0700 (PDT)
Received: from ubuntu.. ([110.9.142.4])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cc1f36ae4ccsm6732204a12.19.2026.09.01.09.52.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Sep 2026 09:52:49 -0700 (PDT)
From: Sang-Heon Jeon <ekffu200098@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	Mike Rapoport <rppt@kernel.org>
Cc: Jason Gunthorpe <jgg@ziepe.ca>,
	linux-mm@kvack.org,
	Pratyush Yadav <pratyush@kernel.org>
Subject: [PATCH] memblock: fix page count when preserving reserve_mem regions
Date: Wed,  2 Sep 2026 01:52:35 +0900
Message-ID: <20260901165237.1025973-1-ekffu200098@gmail.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 7f6dpqy8aycrgz4jecbby7weqdxdfenf
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: A72F118000D
X-Rspam-User: 
X-HE-Tag: 1788281571-637585
X-HE-Meta: U2FsdGVkX1+Bs6jpNtkkON3gPwyCpDtiNjncUuA9Fx1RXsUJ6/rikgHUXXZQXX8goBgiit9NeGZwAtGFZyYJjStCy9mzab22rSsoEq9tenc/nBmXdqyxkKvajJV1Zy3HO2WZEa91VV6UTDL7kTbb/dM5yGTwJ5fpVrXr14eIOd5peA47Akn1aFtqBPCwV3pk0jbNBLukG1Elr2hfmsPA5emjXf3BMd9PA6GQN5Zj7PWA+ohWyekj5YWmWRCPdkbiSRHrKYyQgMOcMpjTwD1iiFGiHk22bxqT7lJ/lW/1GASrCOexw4HQFYJ3urnPjIZyFpJ91oilRLDyoDZyR5EBpPlqrYpS/8IvXDfkojNEw582sluRD6nWTHq4YJUFn1pK800FwwZGS+MkJVI7lG+8u32d6/7VKp1Qup6OZ6b72BCGRrwTiXaQs/wbk+1xGO11EM1ZJU054TVgWNdloCDjz838WoEAu4i5mLZXY9MP6CVTVgfjsIP7s4n1lRvTW7Dp9VDN/DunlLml4+v/nZWMOgUEvfxy4WYpIBaH8BM/YYIHMWjpRDBG/fQaCmt7yPvxsr+kVnWdTJsELK0NvNxtdgCZjtGPRK/CpjX7I/BRKQZc2dqXfAmgQ2MgypOEJxnQ9ZHYbGfbuSBzfWceFhLsYqR8fz4vcppj9v9zxzRmQOh/6ewBPPJQjciKXq6ip7gIt0w/fswXwyXntaRa6MiK132asCKh7sOhW/uHX2hGud028xmGkg/MgcM984Xs9aXqD2RMCZiBDx9v8zb464JQaf6QP4shQNaCCiXJjF+wbuYn/MzM42defYTQwnnKd71BREun2JFkuRTVb3MkRFBUxx9ToGxvfQgb1ouNKZCT77uZAB9jDPCzlK+n/wk1a3yf7mJnnpzHKE/wFhwmSspxSzw43bjQoh2Yinj7OAWjPwDeP0mAuWcXquKVjnqBKvHXz3V2CtDXSaAc5VrMRpa
 3Lv6JahF
 Wc4tU2942RqF1y3qdlVysivVw3ClRAn8fhxmJgPLa42KBpQeDvbGNI8GX/944Y1Ie2PFfGaAm8yvX//+JiRKGBOEv4HL2lhaJoPFwvgRXwSbWNbvlkNZ1e1o6ym07uON+VAa+nZ6OzqdA38wixfgKp0zr/ixdZNcqcjXNrKVm0V5c8t8wxB8/ICho2TKwKIkT666Pg8hANdzdV4Yl5h+tXyzlMv77J38Bvy7DVcreXIGcom4r90NdTVJ+WtDR7OtgcDFgwP8xvv3gnl9A7YDFFk1mKKHVMK9/zjq3gwfTlS34O5+m3qVwHzE94CNoaP3WOkx31Bl6dlrHWs+4x9bHzLrIwhmWeVQ5QSXWm4vF9uO0BpVV8CUCol5fp647V7NivIvZP6dA+oXFDPhDIIL2rZDJH0zCikf+PdMGuXNJONqz75OUH1TkSXmSxJ6Xr4xViuFteGvGqHTDWZScpKaj2BwJzlJpkSKBWhYdoOLCLb7N+IdtEXONUB4KCQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When map->start or map->size is not page aligned,
reserved_mem_preserve() does not preserve the last pages of the region
from map->start to map->start + map->size.

After kexec the new kernel reserves only the preserved pages, so the
last pages are released to the buddy allocator. But
reserve_mem_find_by_name() still returns the whole region including the
last pages, so they can be allocated while the subsystem is still using
them.

Preserve every page the region spans so the new kernel reserves all of
it.

Fixes: 8375b76517cb ("kho: replace kho_preserve_phys() with kho_preserve_pages()")
Signed-off-by: Sang-Heon Jeon <ekffu200098@gmail.com>
---

QEMU-based test results

- Booted with "memblock=debug kho=on reserve_mem=5000:64:oops"

  # kexec -s -l /bzImage --initrd=/initramfs.gz --reuse-cmdline
  # kexec -e
  # dmesg | grep kho_preserved_memory_reserve

1) AS-IS (before fix)
[    0.188536] __memblock_reserve: [0x000000013ffee000-0x000000013ffeefff] nid=-1 flags=0 kho_preserved_memory_reserve+0x3d/0x70

2) TO-BE (after fix)
[    0.076935] __memblock_reserve: [0x000000013ffee000-0x000000013ffeffff] nid=-1 flags=0 kho_preserved_memory_reserve+0x3d/0x70

 mm/memblock.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/mm/memblock.c b/mm/memblock.c
index 777c69f05400..a17b1cccaf3d 100644
--- a/mm/memblock.c
+++ b/mm/memblock.c
@@ -2534,7 +2534,8 @@ static int __init reserved_mem_preserve(void)
 	for (unsigned int i = 0; i < reserved_mem_count; i++, nr_preserved++) {
 		struct reserve_mem_table *map = &reserved_mem_table[i];
 		struct page *page = phys_to_page(map->start);
-		unsigned int nr_pages = map->size >> PAGE_SHIFT;
+		unsigned int nr_pages = PFN_UP(map->start + map->size) -
+					PFN_DOWN(map->start);
 
 		err = kho_preserve_pages(page, nr_pages);
 		if (err)
@@ -2547,7 +2548,8 @@ static int __init reserved_mem_preserve(void)
 	for (unsigned int i = 0; i < nr_preserved; i++) {
 		struct reserve_mem_table *map = &reserved_mem_table[i];
 		struct page *page = phys_to_page(map->start);
-		unsigned int nr_pages = map->size >> PAGE_SHIFT;
+		unsigned int nr_pages = PFN_UP(map->start + map->size) -
+					PFN_DOWN(map->start);
 
 		kho_unpreserve_pages(page, nr_pages);
 	}

base-commit: dde94c26af59f5020adafafa08ece21ccd32590b
-- 
2.43.0


