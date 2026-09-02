Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 86F5AC61DD6
	for <linux-mm@archiver.kernel.org>; Wed,  2 Sep 2026 07:32:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 32E3C6B009D; Wed,  2 Sep 2026 03:32:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2DF516B009E; Wed,  2 Sep 2026 03:32:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1F4456B009F; Wed,  2 Sep 2026 03:32:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id CA4486B009D
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 03:32:53 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 31D691C209F
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 07:32:53 +0000 (UTC)
X-FDA: 85168005426.25.BEBBFF3
Received: from mail-pz2-f8.google.com (mail-pz2-f8.google.com [74.125.228.8])
	by imf22.hostedemail.com (Postfix) with ESMTP id 6A2C4C000C
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 07:32:51 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=bJ7TJJBa;
	spf=pass (imf22.hostedemail.com: domain of chenwandun1@gmail.com designates 74.125.228.8 as permitted sender) smtp.mailfrom=chenwandun1@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788334371;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Vi97MWhfZddiqmimgtB8vYuipDLussxDN6BUz0TYMFc=;
	b=4OGala/M2IaolxZzRBXELTP59ShkIqApd2d6+XYtx3Gz1Tm0C1JoY05irhm3rrW7EuTKY0
	xQDkLBmOQGvpMPxnvrVhYHDOi8WBtLv30jHIndkYLJ32Ig7+cugBzHd7pWqy2VDLSWRjiz
	lo/CmPBLw/Ij8t+JCac4+y66V6126S4=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788334371;
	b=bjlWdICZRgM/Gckt0VCKS10lqwbTuI80MrTbx4QRAQtu2mZr95x6K78euGRUC/khs6nPQ4
	7ctFn6NyxlE2ImOlSbSSisrjuHGKDySgMlOTMBiI/aG5Is3k82VOSBFbCeMnd2yMx3TvjI
	M29v7xSA7ac9GANuBNJhOiMSzgPZZjY=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=bJ7TJJBa;
	spf=pass (imf22.hostedemail.com: domain of chenwandun1@gmail.com designates 74.125.228.8 as permitted sender) smtp.mailfrom=chenwandun1@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pz2-f8.google.com with SMTP id 41be03b00d2f7-cc1d7f6f26aso411262a12.1
        for <linux-mm@kvack.org>; Wed, 02 Sep 2026 00:32:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788334370; x=1788939170; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Vi97MWhfZddiqmimgtB8vYuipDLussxDN6BUz0TYMFc=;
        b=bJ7TJJBawf55zoykgr0ELFJoa8OYnY27aF2wzjkEwTrts0FAMYlXM3uIxb1OrntqDR
         sGdTT9T27j6snjp9aNGmF15iCmIJtoSpXAhYMEA3akbg5THi5PFb4S46pKdN9SCJw9lM
         sY549klmVFgMSh4YVaZXoveBal+BEbb71jAiNSiogdi7IKiVJACpEw+pbGokAepBxmpf
         is55sdpgf7Dat26r04aNAltgXe6mB1/p/4OE++Q8zpxB9YpE1vMcj2g+jFshcgCbUY/6
         UVem0XlCOIXavh+wUXTbPTMa8GvANrAobmVCE6HcLJsLCxx0B6++5BVOPhm7zqzJSvCd
         bBNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788334370; x=1788939170;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=Vi97MWhfZddiqmimgtB8vYuipDLussxDN6BUz0TYMFc=;
        b=OZCxuKcZkJXqXqmsxLsgNSB/pE15uglskIRPEtvULV8fdOlAubPwkfzVMAF5+dPWuC
         wwTYH5W3kK8QwbnNS36hc/RTUjbh/ulEGwFU2xZ3ztZK+5epEslqG1oUnW2bDS7/wXyU
         1BPlqPtYO0TApX8f3U66F9tpmCIflKphkmRtw5raQiFFQc8ov7Z3yu1SO+VJO2LtaKUn
         hCzIjZf0JfU9YW9wJnEyzW1gyZ67svEB/whRtd6xUUcpeyFn8I7jfmZ2TseSmIQDFrNa
         2rliVTngPX8QwBZfzJ2RPFbUl+a0D5Y3dU+Yhyn9OwU3vno+1+r/U3sRMOGQKn++39BK
         7vTQ==
X-Forwarded-Encrypted: i=1; AKwUvByHDiG5TITPs0J2SlSM9UnD9oXGtmZyswlL7hcJux1lrfJVwkThRf4IOeJUNULOmWuu5VmLr3DyVw==@kvack.org
X-Gm-Message-State: AFuF++nxeJNcUxYWui1QpkKaDaaCRbS28QBEaBn+KyF4KPsPGNRZ9WOj
	gQSYu0LsxYw6GdfJoSXSTNeSgod1MINeTJIweMVRigIRUm0V1g6MqLDP
X-Gm-Gg: AYBFou10y8m9vS3G/qM8eDOvFtoq/ssWtm2IscvUk8gmHnQDeXfohxF5h/xyFCIHt9o
	c9D0XaY8DZC+hqF5XrhK4au497vSGNgG0p+ezLL+Wlreje4lgojmRMcMLuoGFL69chmD05KjgxM
	Ny5nRNmdupkK3dkvSdqZvGieUiM+SE89gb4ECaFCW1d7P6h0zIPkIgmP+FpRgNH1piw4EELPrul
	D+8JeCPT+0ZAOnPOf/Dtz2MqoUFE46/feg6hT90xbMA9L6icKSUcS7hWydYpiN2IvFDTOG5RoKt
	Ni3n6OtW+RxvcIlbvG+CoOfAFPAG5a9msrP4RznZSCs6yhEp8r/Nzu8qcOIyAaNNADB7j9esaxI
	TYiaeYBnLwLej/1PSpc6bu2zahzJXNkSEpGP96dHh1oVk8RjQU96x4sFPEZMZFumAo74AYlsIYM
	UeNG0jGdoZrwnIbMPuFHLLYPYXMZdZjj9bBQqFyJLHk1gn6oJEa1+MYPoS8gFYulhBYhBdzLdv
X-Received: by 2002:a05:6a00:8017:b0:851:ba04:ca02 with SMTP id d2e1a72fcca58-85ed398adccmr5532767b3a.16.1788334370199;
        Wed, 02 Sep 2026 00:32:50 -0700 (PDT)
Received: from intel.company.local ([122.11.210.25])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-85db2adcbedsm926914b3a.20.2026.09.02.00.32.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Sep 2026 00:32:49 -0700 (PDT)
From: Wandun Chen <chenwandun1@gmail.com>
To: catalin.marinas@arm.com,
	will@kernel.org,
	chenhuacai@kernel.org,
	pjw@kernel.org,
	palmer@dabbelt.com,
	aou@eecs.berkeley.edu,
	tglx@kernel.org,
	mingo@redhat.com,
	bp@alien8.de,
	dave.hansen@linux.intel.com,
	x86@kernel.org,
	robh@kernel.org,
	saravanak@kernel.org,
	akpm@linux-foundation.org,
	baoquan.he@linux.dev,
	rppt@kernel.org,
	pasha.tatashin@soleen.com,
	pratyush@kernel.org,
	m.szyprowski@samsung.com
Cc: mark.rutland@arm.com,
	kernel@xen0n.name,
	alex@ghiti.fr,
	hpa@zytor.com,
	ruirui.yang@linux.dev,
	robin.murphy@arm.com,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	loongarch@lists.linux.dev,
	linux-riscv@lists.infradead.org,
	devicetree@vger.kernel.org,
	kexec@lists.infradead.org,
	linux-mm@kvack.org,
	iommu@lists.linux.dev
Subject: [PATCH v6 06/10] memblock: introduce MEMBLOCK_NODUMP flag
Date: Wed,  2 Sep 2026 15:31:12 +0800
Message-ID: <20260902073116.802752-7-chenwandun1@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260902073116.802752-1-chenwandun1@gmail.com>
References: <20260902073116.802752-1-chenwandun1@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: p6cmht6w3ss14t7kd8t4yzbzz4gnwdhd
X-Rspamd-Queue-Id: 6A2C4C000C
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1788334371-217666
X-HE-Meta: U2FsdGVkX1+gXGRv6LpmDZV367qSmb64DnC+vYXoG1IJ63QtMOO4S5sKpfXTrl+iVU8Ikq7k2t+9iy481quv41as4IZctC+LAEXcrDAufvwDmpSy/U61RHfil8XbwBfKFyoGRXE9BNYJ6oSz/cHE125jL6OnKyVbqPf4zjNu3vrqiLnXg164QQrCpt60wM7Iy5eXuv5Q+nTerLbd5ZIsCPEyMzQe4IDCDX2tkRvbANjeV6UELLRe/HdnT3xzGKpoRH4PFv+AJzL4jJ35SydTEHNYkm4hTQ0M6mjFvuuGSva0e+i4Y3nwS+uC4g4j4xESYnZuLOXjYaQ0LS87du0VZWNT0uAjeYEDdfd0bjn8fY/fvAld/f1ViOc8w26jbkLGogUdYolJBlzSHzxpwFOTB88t1Zf8yFSReVOyO/ksW+I/3zmLhxWbN3plHpVIsYDdRKxaEuy/PPCF8+rOmntGtN1uyWuarlWM5T5IHYzhjIxEAP4bRkw8Z+TN8utw+Rhg+6ZKBi8ZkdLar4I78VSBGhUuE0b+RI0Aiqk0Xf5+ne7IFobmd8FB8oLkTIWqMIRuteVBSi8PFbyTrlUSadCiaLUBgL8YPimHdNHQddrr1VvgMvvXtcK7HWfgywp7coq6Pl6UvJeWUORAUV21rNMJ5ceNH156bjEN2YjzkO+Y3FipSGGoSLJY3kpzolrZW5ox4UM5sU+5MG4v7dl6czcYHkUe5G+r0BH5BdHjZ49sM5s3Qs9e3aEWmGXinP8zopbPmcP/CXzN4w2oGpHWncby9vuuH84gn+Le9jyukZ79605/U71r79ZJblato6fmAh+xBDN/hDvWHUBUrx09PrWk1JkdJ9QVM96fk0vuklHAp5ZDByz5ZDPq+Tjtp0v4sjGeaaXLxlQR27AmcYgjPinflJ2EGyEoq0Xar450HLVVKooiXgSrtCVlNQxrW9yuej2tLSZC9/2m0Jp8qHH2fcN
 gmKU4Ko3
 Y++BTR7VJmu38csai0+QhtgXRgELQc6cEuMkn5L9qO7TDUNz4pi0zdIfgG2KynVmijLcZU/J481uxzj/ucoNUF/YtKxiY/RjhS7nmntsddNMDL3Wlg20M0KFT64amvPWBJg6dxVhKIvhL9VDzYhTTSN2Pw2OJx2B2JVpCS8cXgOqeLaIPXjjw4rGLMqp7tX9daD28JZZcw3a019ukqxtesVfaEBZPBHJ+sYyo9DMga54URCiqIuJ5d8zS/wdbfyu1bD4t5fY0gQaFbVzyEADUjTquE/UtVxqjgmi3+xIJ3K5QXxt4tz3nU74caGiucGgu4kDw8lmAmlbJHFwr5fB30jVTZaH98TObZvAgrbPowI4x6VWGnaolVGvlbxZ6l3J9OrmIDXkBcv9Tw0AmbprDtIpW7AIjNZLA94PzzqZFhl9MNkl4q9DJcjpJdvLatArYA7yr4keLh4yRgv5q0nLFsK2uGaYUk/eOWjzpF4aBRA1vQUhfIZ2HTMLUUjwPEtjJ85YNhYu5lH+pPt8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Wandun Chen <chenwandun@lixiang.com>

Add MEMBLOCK_NODUMP to mark regions that should be excluded from
kdump vmcores.

The flag is meant for reserved memory that carries no data useful for
crash analysis. Reusable reserved regions such as CMA may hold useful
data, so these regions must not be marked MEMBLOCK_NODUMP. Subsequent
patches wire this up for /reserved-memory and /memreserve/ entries.

Suggested-by: Rob Herring <robh@kernel.org>
Signed-off-by: Wandun Chen <chenwandun@lixiang.com>
Tested-by: Meijing Zhao <zhaomeijing@lixiang.com>
---
 include/linux/memblock.h |  9 +++++++++
 mm/memblock.c            | 16 ++++++++++++++++
 2 files changed, 25 insertions(+)

diff --git a/include/linux/memblock.h b/include/linux/memblock.h
index d62db9e776cf..b2fcf11fba2b 100644
--- a/include/linux/memblock.h
+++ b/include/linux/memblock.h
@@ -52,6 +52,8 @@ extern unsigned long long max_possible_pfn;
  * kernel that we know is good to use. It is the only memory that
  * allocations may happen from in this phase.
  * @MEMBLOCK_RSRV_HUGETLB: memory is reserved for hugetlb pages
+ * @MEMBLOCK_NODUMP: exclude from kdump vmcore. It carries no data useful
+ * for crash analysis (e.g. firmware carveouts).
  */
 enum memblock_flags {
 	MEMBLOCK_NONE		= 0x0,	/* No special request */
@@ -63,6 +65,7 @@ enum memblock_flags {
 	MEMBLOCK_RSRV_KERN	= 0x20,	/* memory reserved for kernel use */
 	MEMBLOCK_KHO_SCRATCH	= 0x40,	/* scratch memory for kexec handover */
 	MEMBLOCK_RSRV_HUGETLB	= 0x80, /* memory reserved for hugetlb pages */
+	MEMBLOCK_NODUMP		= 0x100,/* exclude from kdump vmcore */
 };
 
 /**
@@ -160,6 +163,7 @@ int memblock_reserved_mark_noinit(phys_addr_t base, phys_addr_t size);
 int memblock_reserved_mark_kern(phys_addr_t base, phys_addr_t size);
 int memblock_mark_kho_scratch(phys_addr_t base, phys_addr_t size);
 int memblock_clear_kho_scratch(phys_addr_t base, phys_addr_t size);
+int memblock_mark_nodump(phys_addr_t base, phys_addr_t size);
 
 void memblock_free(void *ptr, size_t size);
 void reset_all_zones_managed_pages(void);
@@ -306,6 +310,11 @@ static inline bool memblock_is_kho_scratch(struct memblock_region *m)
 	return m->flags & MEMBLOCK_KHO_SCRATCH;
 }
 
+static inline bool memblock_is_nodump(struct memblock_region *m)
+{
+	return m->flags & MEMBLOCK_NODUMP;
+}
+
 int memblock_search_pfn_nid(unsigned long pfn, unsigned long *start_pfn,
 			    unsigned long  *end_pfn);
 void __next_mem_pfn_range(int *idx, int nid, unsigned long *out_start_pfn,
diff --git a/mm/memblock.c b/mm/memblock.c
index f2952d725c10..2e87f39826dd 100644
--- a/mm/memblock.c
+++ b/mm/memblock.c
@@ -1204,6 +1204,21 @@ __init int memblock_clear_kho_scratch(phys_addr_t base, phys_addr_t size)
 				    MEMBLOCK_KHO_SCRATCH);
 }
 
+/**
+ * memblock_mark_nodump - Mark a memory region with flag MEMBLOCK_NODUMP.
+ * @base: the base phys addr of the region
+ * @size: the size of the region
+ *
+ * Mark the region as not to be included in crash dumps.
+ *
+ * Return: 0 on success, -errno on failure.
+ */
+int __init_memblock memblock_mark_nodump(phys_addr_t base, phys_addr_t size)
+{
+	return memblock_setclr_flag(&memblock.memory, base, size, 1,
+				    MEMBLOCK_NODUMP);
+}
+
 static bool should_skip_region(struct memblock_type *type,
 			       struct memblock_region *m,
 			       int nid, int flags)
@@ -2887,6 +2902,7 @@ static const char * const flagname[] = {
 	[ilog2(MEMBLOCK_RSRV_KERN)] = "RSV_KERN",
 	[ilog2(MEMBLOCK_KHO_SCRATCH)] = "KHO_SCRATCH",
 	[ilog2(MEMBLOCK_RSRV_HUGETLB)] = "RSV_HUGETLB",
+	[ilog2(MEMBLOCK_NODUMP)] = "NODUMP",
 };
 
 static int memblock_debug_show(struct seq_file *m, void *private)
-- 
2.43.0


