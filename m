Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CEF11CAC5A0
	for <linux-mm@archiver.kernel.org>; Wed, 17 Sep 2025 15:48:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 35A4B8E004F; Wed, 17 Sep 2025 11:48:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 332418E003B; Wed, 17 Sep 2025 11:48:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 247978E004F; Wed, 17 Sep 2025 11:48:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 106728E003B
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 11:48:37 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id C3691139FF1
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 15:48:36 +0000 (UTC)
X-FDA: 83899174632.21.C5DACCA
Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	by imf11.hostedemail.com (Postfix) with ESMTP id E619E40003
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 15:48:34 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=iJG6Bods;
	spf=pass (imf11.hostedemail.com: domain of alexjlzheng@gmail.com designates 209.85.214.173 as permitted sender) smtp.mailfrom=alexjlzheng@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758124115;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=k5RPYj2govdLgAJsVUJ2S305q8KB/kIKY0e8R/KfmxA=;
	b=t7HBYqra+sDnh8UKnPx2bV9XQ/WGV1oVo/90jAYUrkGLQR9muw4Xe83s1Z+XCEl/1Y5Rck
	qK3hWhiFyuKqIOz2XYyGDWybZiKVbLPDfA/DU8FKM7zIIzt9kdqhKtqdxthOmvZIA/qo6F
	pXbZLkyPGENoMSpcI3dqp1ENoIUQ26k=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=iJG6Bods;
	spf=pass (imf11.hostedemail.com: domain of alexjlzheng@gmail.com designates 209.85.214.173 as permitted sender) smtp.mailfrom=alexjlzheng@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758124115; a=rsa-sha256;
	cv=none;
	b=AiIx5BgWNmyY3YaSm23Xpi4QX9n1RxXx2kSMJhEEIaKojwXMlpkg5pMNlz7nJEwtzlw9Bh
	TZx6MN2uRHoLEa9Oi3hTsIpYb2zJBVbuP4O8WFH+HxYUPIr8uS44WxpjP47qMKIfwpBX5B
	xmbvflPwRclJyXDKekNd0PlHh89KNI4=
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-2445824dc27so63093895ad.3
        for <linux-mm@kvack.org>; Wed, 17 Sep 2025 08:48:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758124114; x=1758728914; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=k5RPYj2govdLgAJsVUJ2S305q8KB/kIKY0e8R/KfmxA=;
        b=iJG6BodsK0bhcAqTlkBtkSW3RCHHTiS6OW6HvYtlwuXoCBLH+Mta7DVNChjjO2JZ9J
         tr2bplnZh1jzEvypTUi9SpNFSv8GJUcvNjH8+WgyotthFRsXegp+8KYfR8EnIooBsUMG
         UeJiwr5XKIH5TB8l15l/RF/wLrSD6Q/h24csf3qzAhqfcVOJfZqZ0Q2NffESlKR731Dy
         LJ6TThREXQ/SaAPD1s72Syhs8WzQEIEBB3/xGdnoK0prg71r97sUtileG0yfL/h0/HJc
         wxWsJLbRT79yU+y0O+Yk+lQ1tY4n1Ip6KhYrt4LZsq0fhMm6Z9OWY+D5kNoUURh2lvV9
         vc3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758124114; x=1758728914;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=k5RPYj2govdLgAJsVUJ2S305q8KB/kIKY0e8R/KfmxA=;
        b=pXWdzt/jDArybTjtrg2J/C4nuVcQPppf65V42E9deqiNcxPeyCRp/PA+T93zcoc+HZ
         7GNtg6VUvEayw0RzCdwrMpthRf0+4HgaoVsiA1oMLCMD2dJDxZ66JMZcE6QjVYC3e3b9
         ibTrn6pwS7u9niZk094Hz7sz4/MOMlEm64NH+jPaWvRX7Q3osAfRcbCcrPZ/oA2Ru5VU
         uo1nst0TxbbSjui+LzfVuGawjMO+twoHvOaEIWEsdO4RbI/N56dIVGtvxKmb7yZJHV7O
         Gey/wwo7PgdPv/lUBYHBkksP8haYB0j5vQGRvOjo1kDW5CS03/x4HWjHEQWXCKBrLRoJ
         lslg==
X-Forwarded-Encrypted: i=1; AJvYcCWywVPNCOCgslqbOz8BAfVf2IKT1GbX0GkBr6q2QZeQh5GAuw10/iYlRtWr2hN6zfm8JzdkuoWFtg==@kvack.org
X-Gm-Message-State: AOJu0YzuFR5Vs4RJ5oGSz1wTAtt/o1U8fL6OXXVICwpIFrBPbTl00+4g
	KHagvsHgHckb7sLqL2pcyQVvkSkAdLNncezKw8OI1tFMioFLJstNaOoK
X-Gm-Gg: ASbGncst/m4DI/EirCqPOLZGuiclJkW8r0szxohR0q5c3U1RNam8b6E205pLAMfVVxw
	CVvx7tUzmO54MwQvz4Rhkifz6SqAu/BbztIRaqJkjhiqQn5wCa+Y4gt26fz6r+LvdI3hnr6UwVu
	DC15Ho6PkuC+/LxrL7sFauM+OadnuaVpNuY8vNtTaxhGKZC3A+Vyxyhx+DyCkzqSVuoQiVeDgNK
	FfO7Wn8Tv+BD9l//b3Y/Azg0qUGyMZZZt55/ceq4XUpm3mp+BE881M4JvILn8zIvVDay8ICdvEO
	u4rw2Wal5mys3aO8iiSnHEB2kcSDAw5LqldaIdH2NsuG9SBKVSovazuqSE2lASaPjeuvvGh3Hdo
	08JuFFW6o/aANC1rhwvTT1agt509s7Fr+Pw==
X-Google-Smtp-Source: AGHT+IG+Qiac11pmTk0tCinNrp10vTINXiw2GLyFTb6yRHVut739dW6S796H6UTFDPxnHEvjt3sMJg==
X-Received: by 2002:a17:903:19eb:b0:266:e8c3:4712 with SMTP id d9443c01a7336-26813f198d7mr36117175ad.58.1758124113638;
        Wed, 17 Sep 2025 08:48:33 -0700 (PDT)
Received: from VM-16-24-fedora.. ([43.153.32.141])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-32ea0f94005sm2569799a91.1.2025.09.17.08.48.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Sep 2025 08:48:33 -0700 (PDT)
From: alexjlzheng@gmail.com
X-Google-Original-From: alexjlzheng@tencent.com
To: mingo@redhat.com,
	tglx@linutronix.de,
	jroedel@suse.de
Cc: linux@armlinux.org.uk,
	bp@alien8.de,
	dave.hansen@linux.intel.com,
	x86@kernel.org,
	hpa@zytor.com,
	akpm@linux-foundation.org,
	david@redhat.com,
	lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com,
	vbabka@suse.cz,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	urezki@gmail.com,
	arnd@arndb.de,
	vincenzo.frascino@arm.com,
	geert@linux-m68k.org,
	thuth@redhat.com,
	kas@kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Jinliang Zheng <alexjlzheng@tencent.com>
Subject: [PATCH] mm: introduce ARCH_PAGE_TABLE_SYNC_MASK_VMALLOC to sync kernel mapping conditionally
Date: Wed, 17 Sep 2025 23:48:29 +0800
Message-ID: <20250917154829.2191671-1-alexjlzheng@tencent.com>
X-Mailer: git-send-email 2.49.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: E619E40003
X-Stat-Signature: mhnhpj38ny3ie3sjf9z33p16ckdip61p
X-HE-Tag: 1758124114-186082
X-HE-Meta: U2FsdGVkX1+o/KD5nI1D39Ku8LYNjH19Tb81mIn0pywyc8LivIQFOGNULxqPyXNSaKEvYdaJmKFJ4McyNemvbcy9zqBZmfsTcvofN6udv3XN6FsHUZ271U9BdXlujmjQip+TqBeDVm0tPrpTFawlP4+2DPgknCFjT8lNRDWsfECdfPUk7jKuL3XwzYcDGFXxuWEaPup6OmdGtOoyKm54IyJmDlEbFxuyWYk/hD2AHXjLDwSV9+5H8izfvaF95VdSZqgSqA70r7PxgQZEWzu90sF4w6NugcjbPi9dN2Ej+S6GxZJw5rtrRNSc6BjqACAeihUqMSt+gEBUMC59Tz0wE2yAgg3ZP3WsPBWKEkf4VA/RistnX7Qf5Xnkw4JF5ZvJiUjOEOnfpyy1jZ5hGAs8MuRSbOMmYbWjaBTk2LLQhvWnbRz6Vro17QAinqT9do8CbluOe1FkurSJtWMk4uLUdee9RBA1vd6HcZIgTSAcq+efkaxl7iRuK6S1Bh5Z3WVSYYRB/nasOBLXfboa0Y+3W9dE0LPRpcHvhtZwHldebPuF5QPIXAnbu9KNUn2zMkExRDv04ZV5vMAPh8tAEUy+TkzuTSAayCUorO5zMDeMyCkeQh6N6mgitBjhzBM5rOkNIkP1DA6kull5FQgvwO13Ql6aYslD4BSQuMtD12I7uK+UI20wOgoHdGOULa7UzYt3Hmg2dAYtmFQF7IwNaeC/CQ8/VCzbypy5eFwGGAL/uF6uYWr7O5NL6GGOtPGu1tdn9OcReAeizpB6XpSF9PlJQqy4oNi/H6nEC9zX9VhB9N/J/7v9gAgGBmMgjUcqBWBkLCcAYdk/cOjx3I33iMjq9cG59j3Huk6xJDttIFEUWNrtRfxeCrOKsGOxw6hDCaGHfohNWU43fZ6D484oES2J+0v4iOMCnDHYaefbVkAhodLEfgPiI5nE/2n9DBiw8nBdzWFpDQrD8sC1G9/gInj
 2MtEpmTM
 dYXnZvIbylxkmdkjXEIaGmFsNAnuKmFizvx/CpBtwu+GR2uLLWkG99rxQdU0zLxmnqbDwY+7cW+/gDGogHQxcYd6ncZrrafdPsgqHNKQWHwh+RAgqM9hH/SZMwPcJ6Nuyybt89ZtB8A6X+54OVzNyBAX3ZkKFvS2OL1+xqUjZAal+em/pldNX4RBUfka4Ft+j7D1CruW3yXWK/vOm2/LUOSOBa0OhGukwCCz3D0Iq5Log5m76W+b8yXgxDSuzroMHX8wySe+HmeMRZ45PqTfZVah31NOigQ9BaCmbHIaZl11BBgTqgkIVao6p0FjSuNKRK8jGiyJUoTgCfAQn7dh8yARzsq1hFttsbT/AdC9Zv3nMWIhRzrVNJ/LgaNdY5mIFhvP1rkcYXq7L/rT6sAXpEU/GVh+dxgpQeH5err3MVV6M3nSbN8PSjknuK1lUTsHYoDJy
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Jinliang Zheng <alexjlzheng@tencent.com>

After commit 6eb82f994026 ("x86/mm: Pre-allocate P4D/PUD pages for
vmalloc area"), we don't need to synchronize kernel mappings in the
vmalloc area on x86_64.

And commit 58a18fe95e83 ("x86/mm/64: Do not sync vmalloc/ioremap
mappings") actually does this.

But commit 6659d0279980 ("x86/mm/64: define ARCH_PAGE_TABLE_SYNC_MASK
and arch_sync_kernel_mappings()") breaks this.

This patch introduces ARCH_PAGE_TABLE_SYNC_MASK_VMALLOC to avoid
unnecessary kernel mappings synchronization of the vmalloc area.

Fixes: 6659d0279980 ("x86/mm/64: define ARCH_PAGE_TABLE_SYNC_MASK and arch_sync_kernel_mappings()")
Signed-off-by: Jinliang Zheng <alexjlzheng@tencent.com>
---
 arch/arm/include/asm/page.h                 | 3 ++-
 arch/x86/include/asm/pgtable-2level_types.h | 3 ++-
 arch/x86/include/asm/pgtable-3level_types.h | 3 ++-
 include/linux/pgtable.h                     | 4 ++++
 mm/memory.c                                 | 2 +-
 mm/vmalloc.c                                | 6 +++---
 6 files changed, 14 insertions(+), 7 deletions(-)

diff --git a/arch/arm/include/asm/page.h b/arch/arm/include/asm/page.h
index ef11b721230e..764afc1d0aba 100644
--- a/arch/arm/include/asm/page.h
+++ b/arch/arm/include/asm/page.h
@@ -167,7 +167,8 @@ extern void copy_page(void *to, const void *from);
 #else
 #include <asm/pgtable-2level-types.h>
 #ifdef CONFIG_VMAP_STACK
-#define ARCH_PAGE_TABLE_SYNC_MASK	PGTBL_PMD_MODIFIED
+#define ARCH_PAGE_TABLE_SYNC_MASK		PGTBL_PMD_MODIFIED
+#define ARCH_PAGE_TABLE_SYNC_MASK_VMALLOC	ARCH_PAGE_TABLE_SYNC_MASK
 #endif
 #endif
 
diff --git a/arch/x86/include/asm/pgtable-2level_types.h b/arch/x86/include/asm/pgtable-2level_types.h
index 54690bd4ddbe..650b12c25c0c 100644
--- a/arch/x86/include/asm/pgtable-2level_types.h
+++ b/arch/x86/include/asm/pgtable-2level_types.h
@@ -18,7 +18,8 @@ typedef union {
 } pte_t;
 #endif	/* !__ASSEMBLER__ */
 
-#define ARCH_PAGE_TABLE_SYNC_MASK	PGTBL_PMD_MODIFIED
+#define ARCH_PAGE_TABLE_SYNC_MASK		PGTBL_PMD_MODIFIED
+#define ARCH_PAGE_TABLE_SYNC_MASK_VMALLOC	ARCH_PAGE_TABLE_SYNC_MASK
 
 /*
  * Traditional i386 two-level paging structure:
diff --git a/arch/x86/include/asm/pgtable-3level_types.h b/arch/x86/include/asm/pgtable-3level_types.h
index 580b09bf6a45..272d946a3c7d 100644
--- a/arch/x86/include/asm/pgtable-3level_types.h
+++ b/arch/x86/include/asm/pgtable-3level_types.h
@@ -27,7 +27,8 @@ typedef union {
 } pmd_t;
 #endif	/* !__ASSEMBLER__ */
 
-#define ARCH_PAGE_TABLE_SYNC_MASK	PGTBL_PMD_MODIFIED
+#define ARCH_PAGE_TABLE_SYNC_MASK		PGTBL_PMD_MODIFIED
+#define ARCH_PAGE_TABLE_SYNC_MASK_VMALLOC	ARCH_PAGE_TABLE_SYNC_MASK
 
 /*
  * PGDIR_SHIFT determines what a top-level page table entry can map
diff --git a/include/linux/pgtable.h b/include/linux/pgtable.h
index 2b80fd456c8b..53b97c5773ba 100644
--- a/include/linux/pgtable.h
+++ b/include/linux/pgtable.h
@@ -1476,6 +1476,10 @@ static inline void modify_prot_commit_ptes(struct vm_area_struct *vma, unsigned
 #define ARCH_PAGE_TABLE_SYNC_MASK 0
 #endif
 
+#ifndef ARCH_PAGE_TABLE_SYNC_MASK_VMALLOC
+#define ARCH_PAGE_TABLE_SYNC_MASK_VMALLOC 0
+#endif
+
 /*
  * There is no default implementation for arch_sync_kernel_mappings(). It is
  * relied upon the compiler to optimize calls out if ARCH_PAGE_TABLE_SYNC_MASK
diff --git a/mm/memory.c b/mm/memory.c
index 0ba4f6b71847..cd2488043f8f 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -3170,7 +3170,7 @@ static int __apply_to_page_range(struct mm_struct *mm, unsigned long addr,
 			break;
 	} while (pgd++, addr = next, addr != end);
 
-	if (mask & ARCH_PAGE_TABLE_SYNC_MASK)
+	if (mask & ARCH_PAGE_TABLE_SYNC_MASK_VMALLOC)
 		arch_sync_kernel_mappings(start, start + size);
 
 	return err;
diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index 5edd536ba9d2..2fe2480de5dc 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -311,7 +311,7 @@ static int vmap_range_noflush(unsigned long addr, unsigned long end,
 			break;
 	} while (pgd++, phys_addr += (next - addr), addr = next, addr != end);
 
-	if (mask & ARCH_PAGE_TABLE_SYNC_MASK)
+	if (mask & ARCH_PAGE_TABLE_SYNC_MASK_VMALLOC)
 		arch_sync_kernel_mappings(start, end);
 
 	return err;
@@ -484,7 +484,7 @@ void __vunmap_range_noflush(unsigned long start, unsigned long end)
 		vunmap_p4d_range(pgd, addr, next, &mask);
 	} while (pgd++, addr = next, addr != end);
 
-	if (mask & ARCH_PAGE_TABLE_SYNC_MASK)
+	if (mask & ARCH_PAGE_TABLE_SYNC_MASK_VMALLOC)
 		arch_sync_kernel_mappings(start, end);
 }
 
@@ -629,7 +629,7 @@ static int vmap_small_pages_range_noflush(unsigned long addr, unsigned long end,
 			break;
 	} while (pgd++, addr = next, addr != end);
 
-	if (mask & ARCH_PAGE_TABLE_SYNC_MASK)
+	if (mask & ARCH_PAGE_TABLE_SYNC_MASK_VMALLOC)
 		arch_sync_kernel_mappings(start, end);
 
 	return err;
-- 
2.49.0


