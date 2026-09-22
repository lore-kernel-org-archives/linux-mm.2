Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BF37DC982F1
	for <linux-mm@archiver.kernel.org>; Tue, 22 Sep 2026 08:44:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BDAD66B00A5; Tue, 22 Sep 2026 04:44:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B3F0C6B00A6; Tue, 22 Sep 2026 04:44:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9DEB36B00A7; Tue, 22 Sep 2026 04:44:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 735B86B00A5
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 04:44:14 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 5EC5E16041F
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 08:44:13 +0000 (UTC)
X-FDA: 85240761186.06.BE7F087
Received: from mail-pj2-f11.google.com (mail-pj2-f11.google.com [74.125.227.139])
	by imf12.hostedemail.com (Postfix) with ESMTP id 927F940003
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 08:44:11 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=YVvSj1G4;
	spf=pass (imf12.hostedemail.com: domain of chenwandun1@gmail.com designates 74.125.227.139 as permitted sender) smtp.mailfrom=chenwandun1@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790066651;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XrAQfB99bFPUaNh0c5d2OUhMy2tKXocwdCbeEYRe5yE=;
	b=QNmPouvskkgtXdoElG/xJem6Sk6hMyCiTp2lmWbFuL/PJX4TMtzfXbomfiLKsngQ/Xu/ss
	fLLAQyktPZ/YYR7MhXJt9SdYSseGzs3CI25AU2jfFWeno0dZ6rvkpsn6uov7e4wHNcK3ab
	5lbRpd48jw2iQain5uPH4Rd3ypS/O0E=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=YVvSj1G4;
	spf=pass (imf12.hostedemail.com: domain of chenwandun1@gmail.com designates 74.125.227.139 as permitted sender) smtp.mailfrom=chenwandun1@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790066651;
	b=5WvNF/yZFJhTYuv4wS0R1Fql04zNAWO8f51pRZwITmoTFOLdnmoGsy3RCUENtgR+gy+Wn0
	fBUbDaLDhIwwusJ8HHxo6A2UjG5tb2razV1Wi030XnlhlMPHeE9bdV0kZLGbJ4UKUZ/ZQT
	V6O32Uo53YJQSHIQ+RMbIEKJzpgk/tQ=
Received: by mail-pj2-f11.google.com with SMTP id 98e67ed59e1d1-3989fdf58bcso351683a91.0
        for <linux-mm@kvack.org>; Tue, 22 Sep 2026 01:44:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790066650; x=1790671450; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=XrAQfB99bFPUaNh0c5d2OUhMy2tKXocwdCbeEYRe5yE=;
        b=YVvSj1G4d6fJSf5W5IoTEJuAXwG+cTcS4ox/z+F4T80aRcS19fneY3R7EgzNug2MbS
         tpdC5/6zhAcugC3ErdmDRWr6q7gOTJiazdLhVD88+gwUO0BvGsjkhE5Nz4zaBPtgBuSM
         In2MeRZG5UaAlefL3MxbBLF8mfWDfEYAbe/oO2LvvKJzYj0aXs/2uuEtFrXSgNBQHgTu
         wTspufq9K6an7dMe07q/IRZFJ7x3M9y24XvKFvZC4F/2qq/3lbiDqg/KE0/zmCMxLG5/
         BTB/DQGGe3kbgrdqYBCgn1MiQi0UKfp3ilBCiUDV5sq2/S8TVOK9c82HoKWAicqUTmGU
         oPlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790066650; x=1790671450;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=XrAQfB99bFPUaNh0c5d2OUhMy2tKXocwdCbeEYRe5yE=;
        b=Ilo+AqrZOlgOvSKUj6RBAjTz/a7G7NGBJo/C14K7zlCWsIzC6NwYVpG1p7kV+8dinC
         /y9QEUyBW/Rxxz9ULjfY/RzDUNmt4f6MzdNx6ZvzQjHlgz9a6zzoXcB0bu3hPok2dNVJ
         f2iUQbUgtpUpfJNH9I+8wUn/JOpxt07v8FWpmvl1JbAyrAdJ2MO7QVfzoPNVDB6z+lGA
         rza++nQnIRr86LvTx6LYTIjufm9OBZ2bKQ2gFfVktIy9OqropoilfNzInpizhvPHBh/3
         5sZwvlRNwenB4CvvLrFuA7xeF3aydigTKwkPzmv+gikYaNPY/sykggHxDPhWUi6sRxot
         9zsQ==
X-Forwarded-Encrypted: i=1; AKwUvBx5KN/h5rc66+B9J7Wn4lT0chZka4Xs7vAXJUhyAwAqGKGHRn/yY17nEoYL2uehTO0WTVBNhReSYg==@kvack.org
X-Gm-Message-State: AFuF++mojlmZFzB+eJ5N8FoGwi+Qv2Nv3p5kGUamNgUDc88xlU1LvgLh
	TmIqZYqKIwryq9HTHnf32Hy25gl3gX5C/c9l4mqinodVMBgzlzr3KGrP
X-Gm-Gg: AYBFou0vM1whTBHmCmhwdKik8Ll/XGDtTLMSKfUwA2c5jrhtlSNHcMjBwCI0mijQrrW
	irL3F3uc7FMqBAYABFBsUFD0Wjc84pFu5iW8m84QGZK1rvlbTO86sONrn26hg65AyRgqPZtKyy7
	r3CNkLDTWYDQ+hKcZ6PxTAhK9oWe3nKwsVOmwH5hD/PceVsdYAlB9ybKAVa3yWGhB9CVz+qW7LU
	6ftgu//vW7j9Ouq3ZDPPFN/j7Q2lX5H4rtxs9XxnPZB53s99WMpi+Zp0FTjnjICpfeiW1tbKO5d
	mIsDUTF4SLwDICA0fkka68r+ecmLtd/drlnaZi6k/hm1KsYZstGsvPM0t6qRRMMPiIGCvxhImeB
	s2T8qhpc3tvD0+R7r8TUbOWtkOZAVQYjrBoGld03Bv/GDYr9aAIWM3jZhevj0hz++PXgKsUhWbY
	Hct5wRogosIUp6P1k8i3/oedjnLhleJGnRd4/bUEu3gBehgcHt1gkTjahhTOonutlpjE6AlITYg
	/hKbsv8d4w=
X-Received: by 2002:a17:90b:1e4a:b0:39e:4c7e:bc6 with SMTP id 98e67ed59e1d1-3a073666c4dmr246498a91.20.1790066650350;
        Tue, 22 Sep 2026 01:44:10 -0700 (PDT)
Received: from intel.company.local ([122.11.210.25])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3a0674a5ae4sm3670016a91.12.2026.09.22.01.43.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Sep 2026 01:44:09 -0700 (PDT)
From: Wandun Chen <chenwandun1@gmail.com>
To: robh@kernel.org,
	baoquan.he@linux.dev,
	rppt@kernel.org,
	m.szyprowski@samsung.com
Cc: catalin.marinas@arm.com,
	will@kernel.org,
	mark.rutland@arm.com,
	chenhuacai@kernel.org,
	kernel@xen0n.name,
	pjw@kernel.org,
	palmer@dabbelt.com,
	aou@eecs.berkeley.edu,
	alex@ghiti.fr,
	tglx@kernel.org,
	mingo@redhat.com,
	bp@alien8.de,
	dave.hansen@linux.intel.com,
	x86@kernel.org,
	hpa@zytor.com,
	saravanak@kernel.org,
	akpm@linux-foundation.org,
	pasha.tatashin@soleen.com,
	pratyush@kernel.org,
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
Subject: [PATCH v7 5/9] memblock: introduce MEMBLOCK_NODUMP flag
Date: Tue, 22 Sep 2026 16:42:52 +0800
Message-ID: <20260922084256.1515554-6-chenwandun1@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260922084256.1515554-1-chenwandun1@gmail.com>
References: <20260922084256.1515554-1-chenwandun1@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: dys3j8ouz491zueswf4nfqfrhfsim4ti
X-Rspamd-Queue-Id: 927F940003
X-Rspamd-Server: rspam07
X-HE-Tag: 1790066651-338999
X-HE-Meta: U2FsdGVkX18WLIOyCCEuMkZWvngnR12YIzuigGY0UBaQlkrmzCPLVHnhjwZa1qcBp2D6xax4xRBhF9DZi9wYL26+c3n92M2CeZf1+bFVCQd7CMH05YB9t9LNheHCwwN9Q0Dy3pHp/GSZtU8WFFx9ewMvEUekTLsPwaewe8X/EI1gj9yb0hDAzLr2Lz33id2RJY5B+935xxpxdiLUPtSknymOBB1FD4a+6NPfj6T9dJIzATGg80JYHji4dumFCxhKFhCrhi3RTubAVnIRjDbngJCw4kNFKCcKQDuVTf0bZBCNyDRRqvPlLK/XA1b2h0FpI6Z1QqQZc3ziBzooVTo6//wvfku1t72eCtBTfP1FugN1XlB2bE49JILXyuSQiCzpZAS/eVs4hSCemMZGbVcHkV9WZMM0uH2QdseuI2S5lksWKLTAMuqf2t0Hw743OsjsfSKR+W/kjy943D89oUslOELpcBj5MC+hEvMqG/IDYVfOz53nkiciuYsUKk0upK3ZL8k3zsXlvJndTW0rkdNXCTT+ZREHSYINjTjPAkoyMFSBRYJgkl7AaQ61uK7pppJHOLWx7oWjKOJ5RPEHHi0UWIF8G2iLHkqq0WA/UhuiFrHN9TlSKKiHFfQp3eSqBVClHk9md+wzd9s4J+t+boeI8nPzR9osll0xkPqF9ACo6Is1SQp9Zz3gQSGuymeJGD/TNFdCc0DNhkODaCYv1CDLhi96M/sbsHqAiiS6IuPRXXU2Ca6E6/yFj/CLDnIze7u2X9+ZUEwgcvfiVy3tM1cVXjEJ4LU3MImX3HXjobJvNUISr22UZ2+jRl/ociExbc0iCAi/wY8H0V/WNk3ZxFSIibTOP+meDEaT1L1fkb6YSRirUDjo+ibR6GBcKujsrn32y25GEQkQKdUcPbrNV0gLl9p0QVzq4k1DIjHVxIZ3HvKu8s7ye6rMLx7GgH1RA/TeLZ1zt4DxdkSw+Z2kpfq
 /D/dNj1p
 YW4EbGqmF4f9bziRfCBGuOXoQqqpd2zHerN6mC2nq2z9nYh73ufiZPKAj85tuH21nBqykfi0FQRet6d8Bowt6ff71mbTc1NPGckUgxapv9sMfSSexAc4Dk0j1W+GSM0Uej8WMfoib9Ky1+mGjIGCeWv98wSW055fhZgQ3VQiTesyEYmGI9v3RDuu3ENySRNIprWmPMR7dxAq3O3stas/WAw6cPOYIp3cip9+Dl85rcIuXtBZgH1K0ss7mPlDoAKu1XmsTl6gW950WX4K32EryjIiVWDkzIakwp+8890hR1Ly2ceb+3o6yB4xXNyf6s2mewAla1+gd7oz7KdxTr2ftKwLsBU7UAx1kbNSxIWplTskc8DURrMBpmE/IPruvf9KuYzHVBQSHqNMhGTJ5lkHivQaEjeMLiwb7kmWvNVQWJxp0w5noE4w20BKG9Jk95LopvarSFGsxqXhIWqT8GDQ8nQ0/vgSF0JFQdyQ2TlmAJ6W+ln320SUbadB5UeXi7Nx/40FFts4BSM9QaUU=
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

Regions in /memreserve/ (such as the initrd) may be reserved at the
beginning and freed later, so we also need to clear the flag when
freeing reserved memory.

Suggested-by: Rob Herring <robh@kernel.org>
Signed-off-by: Wandun Chen <chenwandun@lixiang.com>
Tested-by: Meijing Zhao <zhaomeijing@lixiang.com>
---
 include/linux/memblock.h |  9 +++++++++
 mm/memblock.c            | 43 ++++++++++++++++++++++++++++++++++++++--
 2 files changed, 50 insertions(+), 2 deletions(-)

diff --git a/include/linux/memblock.h b/include/linux/memblock.h
index aa845f488327..0126b47bc3c4 100644
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
 
@@ -305,6 +309,11 @@ static inline bool memblock_is_kho_scratch(struct memblock_region *m)
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
index ea0de4b5f356..48cabfe5cdf1 100644
--- a/mm/memblock.c
+++ b/mm/memblock.c
@@ -929,6 +929,8 @@ static unsigned long __free_reserved_area(phys_addr_t start, phys_addr_t end,
 	return pages;
 }
 
+static int memblock_clear_nodump(phys_addr_t base, phys_addr_t size);
+
 unsigned long free_reserved_area(void *start, void *end, int poison, const char *s)
 {
 	phys_addr_t start_pa, end_pa;
@@ -949,9 +951,13 @@ unsigned long free_reserved_area(void *start, void *end, int poison, const char
 	}
 
 	if (IS_ENABLED(CONFIG_ARCH_KEEP_MEMBLOCK)) {
-		if (start_pa < end_pa)
+		if (start_pa < end_pa) {
 			memblock_remove_range(&memblock.reserved,
 					      start_pa, end_pa - start_pa);
+
+			if (IS_ENABLED(CONFIG_CRASH_DUMP))
+				memblock_clear_nodump(start_pa, end_pa - start_pa);
+		}
 	}
 
 	pages = __free_reserved_area(start_pa, end_pa, poison);
@@ -995,8 +1001,11 @@ int __init_memblock memblock_phys_free(phys_addr_t base, phys_addr_t size)
 
 	kmemleak_free_part_phys(base, size);
 
-	if (!slab_is_available() || IS_ENABLED(CONFIG_ARCH_KEEP_MEMBLOCK))
+	if (!slab_is_available() || IS_ENABLED(CONFIG_ARCH_KEEP_MEMBLOCK)) {
 		ret = memblock_remove_range(&memblock.reserved, base, size);
+		if (IS_ENABLED(CONFIG_CRASH_DUMP))
+			memblock_clear_nodump(base, size);
+	}
 
 	if (slab_is_available())
 		__free_reserved_area(base, base + size, -1);
@@ -1204,6 +1213,35 @@ __init int memblock_clear_kho_scratch(phys_addr_t base, phys_addr_t size)
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
+/**
+ * memblock_clear_nodump - Clear a memory region with flag MEMBLOCK_NODUMP.
+ * @base: the base phys addr of the region
+ * @size: the size of the region
+ *
+ * Return: 0 on success, -errno on failure.
+ */
+static int __init_memblock memblock_clear_nodump(phys_addr_t base,
+						 phys_addr_t size)
+{
+	return memblock_setclr_flag(&memblock.memory, base, size, 0,
+				    MEMBLOCK_NODUMP);
+}
+
 static bool should_skip_region(struct memblock_type *type,
 			       struct memblock_region *m,
 			       int nid, int flags)
@@ -2880,6 +2918,7 @@ static const char * const flagname[] = {
 	[ilog2(MEMBLOCK_RSRV_KERN)] = "RSV_KERN",
 	[ilog2(MEMBLOCK_KHO_SCRATCH)] = "KHO_SCRATCH",
 	[ilog2(MEMBLOCK_RSRV_HUGETLB)] = "RSV_HUGETLB",
+	[ilog2(MEMBLOCK_NODUMP)] = "NODUMP",
 };
 
 static int memblock_debug_show(struct seq_file *m, void *private)
-- 
2.43.0


