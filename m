Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 415F8E9B258
	for <linux-mm@archiver.kernel.org>; Tue, 24 Feb 2026 13:23:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 88A186B0088; Tue, 24 Feb 2026 08:23:44 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 838386B0089; Tue, 24 Feb 2026 08:23:44 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7366D6B008A; Tue, 24 Feb 2026 08:23:44 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 5D2866B0088
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 08:23:44 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 0E37513796B
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 13:23:44 +0000 (UTC)
X-FDA: 84479417568.02.66FD65D
Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	by imf29.hostedemail.com (Postfix) with ESMTP id 5C0E3120010
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 13:23:42 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=gLOZLgXZ;
	spf=pass (imf29.hostedemail.com: domain of ritesh.list@gmail.com designates 209.85.214.180 as permitted sender) smtp.mailfrom=ritesh.list@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771939422;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=h/vTWhMTFB0Dk21wQu2UrghHtfm/CBbtvTcuyWrVL08=;
	b=Mbxg+Rs7s6KHOWHFd/tG3Ji1+2AOrSOG6NXpWetHDirlY29hTI3dKnske0hNsRS1K625Sq
	d+yuWp/a3duerbB5u8bWI7zDloAd45iw+0LA9SQtdRxSxuRZyYsnz6PxFnyiyGYEQc+DKo
	ZLF/CqDpLRhuwIvki8dJz4cANwbuE6A=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771939422; a=rsa-sha256;
	cv=none;
	b=KCZEprPeS8blIQbK7R69CagP0xpXPoQP/RvzHBc7eY5vqMo3pnqyWO/JG/BUU2HaSxANsU
	NFHtO6jtC1mTdOvN3K2+P3u76753rX9sHg8Skzkcxh326C4JNaO42DVJRS2/DfcF1qPuTV
	h2saQz66AaYO09g/hH3J7REoaKbDW0k=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=gLOZLgXZ;
	spf=pass (imf29.hostedemail.com: domain of ritesh.list@gmail.com designates 209.85.214.180 as permitted sender) smtp.mailfrom=ritesh.list@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-2a871daa98fso38967115ad.1
        for <linux-mm@kvack.org>; Tue, 24 Feb 2026 05:23:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1771939421; x=1772544221; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=h/vTWhMTFB0Dk21wQu2UrghHtfm/CBbtvTcuyWrVL08=;
        b=gLOZLgXZX2CSNgi7eb/FaaCk940WKRwCP0z0uu/9/jkHZsF/38OlZfApZi8ONNiBM/
         ++WIbBc+U5FZDBpDHcqr7R+WB3vpDnr7WEtTLc2C3xT4mvH1E0ARU0ZdqsBB1qy+ErOj
         eaaRvCSgrY8TqMSamiFgqkXOfy/zdtuzbObu9umGn1Z3DiuJ07N0e1P/NeNfLKZOhxtp
         FkwSrkEh9rMiW7VX3NgH8CP9OA31tIKE5EYLYMct4EVQuTGC3bwiBdooMNUZEyAkc6FX
         yV6pGMIbJWni7FyDvAOaU6l8+TZQaYLO5NFKzV9T0pnvL2DdFUCJOate47EwBlUIStWu
         TEGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771939421; x=1772544221;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=h/vTWhMTFB0Dk21wQu2UrghHtfm/CBbtvTcuyWrVL08=;
        b=c9FpM2hB7Rc6vQDEJkYz76hZbah2POZ8Oke/dHSEKbND7wxHrr6/zMBJ3l5Lgfm4qO
         CfCkAP4BtK8lZBlFe2NIdqgQ2CR9/XYGvOLAaid1uoymbX//N7KMsqSmqMgXuvP4VLIp
         CHJGs4oOx5A1a5+KSi4l90fahfv4mTPUE93SvYyWxkKWYKcXhOHSlgTD4y1u30BjsRQt
         lsQSHJJf8zn2+TUPQj3BKP3c2YDrUxXrKI9wZkNlIu5RFliiO5NbjAzPl3nUH0ib0EPM
         2i93WXSM5Og7EhmF3brBSXFU9QRF1K5Nv4c+YahdeXdc2oNstG4pvPOM0Ux0UR/ZJoFx
         wEkw==
X-Gm-Message-State: AOJu0YzcX+XsaZU51e5mqFLG8UBznLr+jkb40ukWzrBpGdaOE14oTcaP
	/xbJYf5SgKDvBxYmJAWAIFW+6SpUFTLYALi0W2frpumR2Ym3zfXEZd+2
X-Gm-Gg: ATEYQzwUnixG8xdjrLd0Pb1QESwf25u0WmrY/xwuiYWsCpsMjSg8KDBi7bt6JQuq9+p
	bg4GwzUJD3n1H/SDtNwTzhnVCON/EjuQ/hLq2QPgnhqtvOe1kpU3jwuU5gezFmeqKhrDOxigXNU
	27pLl/z1XESr+5APLESm+37fPB8wEZvWPlQNlSa0QmUqRTRLPysrlIVgMmw4e0XJIBfMqaleflp
	UN9AQybHrzJk4FE3BOBbrkHPgntwCQ4obOk6l+4ZcohwiFGdwnO6ZIDB5IUGKPB8CY0ZF4EisIW
	ARKDvkeBX4GLVLQlKwC/M3Jd5SKe987ooHKOg/OJcUmqL23aWSaxNxsFrkffdaagIbEUxnBpRJu
	nW22dyh4FHK1cnmghcY+gFOjf9XkM/elCjEL/CwWpMfy78zkQZ6Z79DIn+jV1Jpx9U54MbSjmn5
	B9MNw5RzIdEbjIXw3GgA==
X-Received: by 2002:a17:902:e787:b0:2a9:3396:738 with SMTP id d9443c01a7336-2ad74547d8dmr105272735ad.44.1771939420973;
        Tue, 24 Feb 2026 05:23:40 -0800 (PST)
Received: from dw-tp ([203.81.243.253])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2ad7500e1cbsm96620195ad.50.2026.02.24.05.23.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Feb 2026 05:23:40 -0800 (PST)
From: "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>
To: kasan-dev@googlegroups.com
Cc: linux-mm@kvack.org,
	Andrey Ryabinin <ryabinin.a.a@gmail.com>,
	Alexander Potapenko <glider@google.com>,
	Andrey Konovalov <andreyknvl@gmail.com>,
	Dmitry Vyukov <dvyukov@google.com>,
	Vincenzo Frascino <vincenzo.frascino@arm.com>,
	linuxppc-dev@lists.ozlabs.org,
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
	stable@vger.kernel.org,
	Venkat Rao Bagalkote <venkat88@linux.ibm.com>
Subject: [PATCH v2] mm/kasan: Fix double free for kasan pXds
Date: Tue, 24 Feb 2026 18:53:16 +0530
Message-ID: <2f9135c7866c6e0d06e960993b8a5674a9ebc7ec.1771938394.git.ritesh.list@gmail.com>
X-Mailer: git-send-email 2.53.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 5C0E3120010
X-Stat-Signature: foip9wgr7yzkq4smoa5yiew99zycucqe
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1771939422-623605
X-HE-Meta: U2FsdGVkX1+KokRialvCEXmihqRpIQm1U1jFcBgQYW78kKciO/GGjJvqzPzEiEt/a1pyrIoHgflTIfYm6U0lvsXPsmxX+sWZ65iU1ar+eH4kewOEsAOwFPEZbP45D2WnSg7A8uYeUcPDHnFoMY17i37ZnCNQwYhWp765FtnA9JAK/AlDUDqJWRZ2+z9j2PCDO38R45TBTfHeubvKoVC7B78L0zi8fMvP2txfbaqpPmuerzjARqDbHbNXS0MEpgdHMzM+jlHs9ry5XABMK0ICmVFwXnFmCCNUKo4vG/q6HjNKPMh6VQlfhpuMtCDCzQ9bE95oigTNf6yl1lLStUUn5hvv9MMMRwtK+beMMZ2gjnNbrWUJ+ge/spBd+9j3HRD43yeHCQ33uedFgNTOg22FHJhcrdm/tBVL5D/9TIQSP4nmRYWrEUPvD/bZfmUG3Yq4s6pVA21/Jok8fCRsMyAzM1W7ffinJo6zIGaOHOxQioOtZJNX0JzMvrzDgdO5WNIRU6vYtyX6L8jpj57yEkgHN6A/2Xc9OWUZxWZaLwiInF7O5lZdXDWiwut4RVSESIZvUqhAG07aDBPL5irrQJsP+D/TkAwZexOKB85mW2HCkL6CNteGhtYh5st/heCCMWR5ZqwRDsh24diUiG7WAfmJ1QFIrGPJRysBGBaWm31iFztNodqGtqf80QM6GcKGmouIpid92jQWneSHzZJYN+necIEa24Zbhc+7QdSEDDT7pBabeaXpcD5Iq9OPFtNuTkmWETbBuEeOxE9tRIDvQ0TH6lXXD9fgTG3cYfsJGL/UlWp4DoSHBmXXNOy0IoZBRAYWqPCcxXePNpla++1Fl7mdo3TlF+fh7aCzZbs+FMFRIOArB0KfF7ZmOHn/McvnUaQbU3pKUVDNW7DEUQoAM/QLFwxeP7L0fOiLcnso1cASF49NFA7GGAlkEkqfbM4wr4cWZAM4tuHfrVLZt48GccK
 WrseeHdK
 xlngiYCUT8/RTFTlg2O/svPuYlYdLTQmgI99CNzXPDNuxI1rPEN9c2SDV4Ew4E2zvEMUq9BhRJvXQCM4KZc2syoHvCgBJiLPks2ZICHRzTOyX/WMNhITsMKyzuPhJu7pOdvN37M49qUX+XMN73NRi7pm+HylXwITpRU6zT2eDq9QsIsjSAhjEqDaTrjBwmlt5keXhNB+11BBkHwrLuvOIGPzx1L5FRamAO7B6n/pbadQLU6ACdNL3qob3BioSuUyxSD0XxlGlLBaGGr7I4bY9UQst1CdewK29OmtPFjBZrNOv72xVIscHQQ6gTcqo5PFnI/rTASEPRIKoIRVIQj5R2qO717TmHZDZFliOPzHRKxd4QflsvMXsweRYRtNc1iS/ALW8jhQlAmJ73kBZb3YgH0MIPbWO7YolzDzek5VUAAjxFEKtrGbLgZSpPPoVhFtmBVJsqNS3BuLdlSHqi7Wbitec8RQlEezHHAad44rnGcQ97Vm1n8I2E7g9nFhvbcXpYlNmCynO0dVnYqBoJWAH2h9lu9qqXZPNUt2tJ5sWUD+6TJaGSE5T3sSnng==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

kasan_free_pxd() assumes the page table is always struct page aligned.
But that's not always the case for all architectures. E.g. In case of
powerpc with 64K pagesize, PUD table (of size 4096) comes from slab
cache named pgtable-2^9. Hence instead of page_to_virt(pxd_page()) let's
just directly pass the start of the pxd table which is passed as the 1st
argument.

This fixes the below double free kasan issue seen with PMEM:

radix-mmu: Mapped 0x0000047d10000000-0x0000047f90000000 with 2.00 MiB pages
==================================================================
BUG: KASAN: double-free in kasan_remove_zero_shadow+0x9c4/0xa20
Free of addr c0000003c38e0000 by task ndctl/2164

CPU: 34 UID: 0 PID: 2164 Comm: ndctl Not tainted 6.19.0-rc1-00048-gea1013c15392 #157 VOLUNTARY
Hardware name: IBM,9080-HEX POWER10 (architected) 0x800200 0xf000006 of:IBM,FW1060.00 (NH1060_012) hv:phyp pSeries
Call Trace:
 dump_stack_lvl+0x88/0xc4 (unreliable)
 print_report+0x214/0x63c
 kasan_report_invalid_free+0xe4/0x110
 check_slab_allocation+0x100/0x150
 kmem_cache_free+0x128/0x6e0
 kasan_remove_zero_shadow+0x9c4/0xa20
 memunmap_pages+0x2b8/0x5c0
 devm_action_release+0x54/0x70
 release_nodes+0xc8/0x1a0
 devres_release_all+0xe0/0x140
 device_unbind_cleanup+0x30/0x120
 device_release_driver_internal+0x3e4/0x450
 unbind_store+0xfc/0x110
 drv_attr_store+0x78/0xb0
 sysfs_kf_write+0x114/0x140
 kernfs_fop_write_iter+0x264/0x3f0
 vfs_write+0x3bc/0x7d0
 ksys_write+0xa4/0x190
 system_call_exception+0x190/0x480
 system_call_vectored_common+0x15c/0x2ec
---- interrupt: 3000 at 0x7fff93b3d3f4
NIP:  00007fff93b3d3f4 LR: 00007fff93b3d3f4 CTR: 0000000000000000
REGS: c0000003f1b07e80 TRAP: 3000   Not tainted  (6.19.0-rc1-00048-gea1013c15392)
MSR:  800000000280f033 <SF,VEC,VSX,EE,PR,FP,ME,IR,DR,RI,LE>  CR: 48888208  XER: 00000000
<...>
NIP [00007fff93b3d3f4] 0x7fff93b3d3f4
LR [00007fff93b3d3f4] 0x7fff93b3d3f4
---- interrupt: 3000

 The buggy address belongs to the object at c0000003c38e0000
  which belongs to the cache pgtable-2^9 of size 4096
 The buggy address is located 0 bytes inside of
  4096-byte region [c0000003c38e0000, c0000003c38e1000)

 The buggy address belongs to the physical page:
 page: refcount:0 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x3c38c
 head: order:2 mapcount:0 entire_mapcount:0 nr_pages_mapped:0 pincount:0
 memcg:c0000003bfd63e01
 flags: 0x63ffff800000040(head|node=6|zone=0|lastcpupid=0x7ffff)
 page_type: f5(slab)
 raw: 063ffff800000040 c000000140058980 5deadbeef0000122 0000000000000000
 raw: 0000000000000000 0000000080200020 00000000f5000000 c0000003bfd63e01
 head: 063ffff800000040 c000000140058980 5deadbeef0000122 0000000000000000
 head: 0000000000000000 0000000080200020 00000000f5000000 c0000003bfd63e01
 head: 063ffff800000002 c00c000000f0e301 00000000ffffffff 00000000ffffffff
 head: ffffffffffffffff 0000000000000000 00000000ffffffff 0000000000000004
 page dumped because: kasan: bad access detected

[  138.953636] [   T2164] Memory state around the buggy address:
[  138.953643] [   T2164]  c0000003c38dff00: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
[  138.953652] [   T2164]  c0000003c38dff80: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
[  138.953661] [   T2164] >c0000003c38e0000: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
[  138.953669] [   T2164]                    ^
[  138.953675] [   T2164]  c0000003c38e0080: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
[  138.953684] [   T2164]  c0000003c38e0100: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
[  138.953692] [   T2164] ==================================================================
[  138.953701] [   T2164] Disabling lock debugging due to kernel taint

Fixes: 0207df4fa1a8 ("kernel/memremap, kasan: make ZONE_DEVICE with work with KASAN")
Cc: stable@vger.kernel.org
Reported-by: Venkat Rao Bagalkote <venkat88@linux.ibm.com>
Signed-off-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
---

v1 -> v2:
1. cc'd linux-mm
2. Added tags (Fixes, CC, Reported).

 mm/kasan/init.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/mm/kasan/init.c b/mm/kasan/init.c
index f084e7a5df1e..9c880f607c6a 100644
--- a/mm/kasan/init.c
+++ b/mm/kasan/init.c
@@ -292,7 +292,7 @@ static void kasan_free_pte(pte_t *pte_start, pmd_t *pmd)
 			return;
 	}

-	pte_free_kernel(&init_mm, (pte_t *)page_to_virt(pmd_page(*pmd)));
+	pte_free_kernel(&init_mm, pte_start);
 	pmd_clear(pmd);
 }

@@ -307,7 +307,7 @@ static void kasan_free_pmd(pmd_t *pmd_start, pud_t *pud)
 			return;
 	}

-	pmd_free(&init_mm, (pmd_t *)page_to_virt(pud_page(*pud)));
+	pmd_free(&init_mm, pmd_start);
 	pud_clear(pud);
 }

@@ -322,7 +322,7 @@ static void kasan_free_pud(pud_t *pud_start, p4d_t *p4d)
 			return;
 	}

-	pud_free(&init_mm, (pud_t *)page_to_virt(p4d_page(*p4d)));
+	pud_free(&init_mm, pud_start);
 	p4d_clear(p4d);
 }

@@ -337,7 +337,7 @@ static void kasan_free_p4d(p4d_t *p4d_start, pgd_t *pgd)
 			return;
 	}

-	p4d_free(&init_mm, (p4d_t *)page_to_virt(pgd_page(*pgd)));
+	p4d_free(&init_mm, p4d_start);
 	pgd_clear(pgd);
 }

--
2.53.0


