Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DD2E8606A31D
	for <linux-mm@archiver.kernel.org>; Sat, 24 Oct 2026 10:46:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=O+biJyg6
Received: by kanga.kvack.org (Postfix)
	id CB2B36B008C; Sat, 24 Oct 2026 06:46:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C3AF86B0A8F; Sat, 24 Oct 2026 06:46:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B03116B0A90; Sat, 24 Oct 2026 06:46:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 75A9D6B008C
	for <linux-mm@kvack.org>; Sat, 24 Oct 2026 06:46:09 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 5B9E21A027F
	for <linux-mm@kvack.org>; Sat, 24 Oct 2026 10:46:08 +0000 (UTC)
X-FDA: 85357190016.01.4DB01B1
Received: from mail-ua1-f47.google.com (mail-ua1-f47.google.com [209.85.222.47])
	by imf16.hostedemail.com (Postfix) with ESMTP id AF87A180002
	for <linux-mm@kvack.org>; Sat, 24 Oct 2026 10:46:06 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=O+biJyg6;
	spf=pass (imf16.hostedemail.com: domain of joaoanandalima@gmail.com designates 209.85.222.47 as permitted sender) smtp.mailfrom=joaoanandalima@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792838766;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=yI6gnpr3iD8MepU4vdxCrnHeeo0inroAoiiaaC1yzbs=;
	b=F99c1poUYtdvT1ZdBaVPckokuqjefZ+UZPEtRWPH3Whb7iFvoxu8ysquf6FdGYpgl04rz0
	ZIDetkJarGIiU+ceA3URsN2m9PjBKNWfBfJsHNl9+kz2liA7K53vsoSvxKc40RXaGOFWp9
	xB00dOGk30qn2XYCfpMYqTv+eD6+r9E=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=O+biJyg6;
	spf=pass (imf16.hostedemail.com: domain of joaoanandalima@gmail.com designates 209.85.222.47 as permitted sender) smtp.mailfrom=joaoanandalima@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792838766;
	b=OM6kn2Tyt7wbV0WQNgfbNfhizpGkypZNR9c6dMa865Juia57NYm/n0LuF3BH4QbZsdHhXW
	e0rjNKBcOHVur3yZaPxWZFeZIlVjysQTxlYUC0Zla/318wEULih1MVV0qm3Qyagy1Xmbpr
	abH+L/xQLV1qLI8dMY99SZVsNCcUlKk=
Received: by mail-ua1-f47.google.com with SMTP id a1e0cc1a2514c-988c7371716so646730241.1
        for <linux-mm@kvack.org>; Sat, 24 Oct 2026 03:46:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792838766; x=1793443566; darn=kvack.org;
        h=content-transfer-encoding:content-type:mime-version:message-id:date
         :subject:cc:to:from:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=yI6gnpr3iD8MepU4vdxCrnHeeo0inroAoiiaaC1yzbs=;
        b=O+biJyg68nuSIPfSIVuAWh7EcLCJFpyMFkf8WkZSoc1eNU1EqWQmI9LJn0nzieX3hi
         1cmvB5NzDaH8q3DBWcCjUa1pu9afgZS3WONQ3cbABPag7qMCGnPodktMEVb35JuRtB7x
         2LNRaV6YIneF83Wkxsr16WTTKsqaStBAxiiLInO2P8KO9SGAJWzKR2xrGdFWXPmGOb/q
         tNkjNjs3bVeqO5loOXUR91BnIJc429/OBxX1FKNP8M8AoiW2N8pxXp3X8HSqdAqPQ37t
         3agv/LCbYUPd8UPrVBzsQIuNcQmmvGyGC7Kk/kP80QNNQXtF9IEKN5bEG+V6rkSe0dpC
         b4hQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792838766; x=1793443566;
        h=content-transfer-encoding:content-type:mime-version:message-id:date
         :subject:cc:to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=yI6gnpr3iD8MepU4vdxCrnHeeo0inroAoiiaaC1yzbs=;
        b=LETqmIBJ5+U3Z5kmduNa8y48+0R9IZcup62ubesXRlDKuhEYNySETtK0CBEHgOFLzq
         /yr6FGYOfmph5Bk5+zz5jQsHzdTc0NNF2mFLRWhoyr6E2voVGt76qvKW5Ohw0csin+rh
         AHITZW1V9HfNx3+z2P43ctkIpSbW8E7S0fvtOddr8VSzAuWv3gW7jYUNKB7wZyS03bG9
         0EdD4rBX7Lx2h+k5O4NynNaV7Ch+uXqIP9UpkeC07O3HJwL591mTcGQM/KLE8xrrWH1I
         7dPQG7GqFHaJe9NL736vqIgKrtAp3aX4eO+JfI0kQNFeh+iXrcHfP6LdB586Phm1T3/u
         QHOA==
X-Gm-Message-State: AFq9FYK4p/sJ0pkzgQtOqcLO7Yj/3qcXc5WZiOVKWMTw6iy2KNB6QPtk
	WR3Q2aKyONJuNduiGH/jaiwfPYdixukas3qBIQciATMJo5DhXgc/raWKHTOfknC9
X-Gm-Gg: AYBFou2TgZfJ71L+KeJdjFClIO8/TVe2y5ht8BhBV6GQfDDPe3wi7XjEkgguWda1kOH
	pCaKJBH4xHCXYrGD/6gvjSH859+QC1UvSjErRCaOoUO1unXUnvyALX3cAsXvkuSBsgxYtrti0Bo
	+83gN96Xo4aupeu++95m7+4n0r8a6IEgqw5qG1ptxIT3kQdE74yeSRqzEy3i2Kz5eEqCJs0whn8
	IyEWwRW9w9VS8hiD5qOus+B2HrHarFXmBpgr52WAXxdqiao+5v1KYY8weoDlunOfvO0oY+CHBkc
	WksskKOWGR9uC7L0HwHdtyTwWBOskuVySEBz6OO7wszCbx6Ta1wc2AhOUIo6nR8TIzS9cCJxt29
	TiUgr3zWfL7NfTS05hDQlhltxGM7alue6V7SwRV37CcKm/+mNdK+RqqgmOVjwf1wnt+1kVf6tP1
	VxRqJjy4jpZE4C1dzjX9hJ3nX4OL1b7sbsUScLJ4rhuHTWrOMOr1L8f3Vn81f4Wzbe2ik2zK6XS
	Da5g3cUW7HyOLYkbu1Gb12DbevYrFIlqiO9R4p/mLXSdZnuC4+9ioksylaYTBupsON9RGoeBHlt
	pF98
X-Received: by 2002:a05:6102:1492:b0:7cc:32da:56e with SMTP id ada2fe7eead31-7ce5cd41446mr429300137.19.1792838765631;
        Sat, 24 Oct 2026 03:46:05 -0700 (PDT)
Received: from DESKTOP-7QP7L26 ([45.190.211.148])
        by smtp.gmail.com with ESMTPSA id a1e0cc1a2514c-9910e7b7069sm2191025241.3.2026.10.24.03.46.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 24 Oct 2026 03:46:05 -0700 (PDT)
From: dev12124 <joaoanandalima@gmail.com>
To: linux-mm@kvack.org
Cc: linux-efi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	ardb@kernel.org,
	keescook@chromium.org,
	dev12124 <joaoanandalima@gmail.com>
Subject: [PATCH] mm: ppm: add PPM (Page-Plugger Under Memory) to Page Fault and Overcommit elimination
Date: Sat, 24 Oct 2026 07:45:42 -0300
Message-ID: <20261024104552.394-1-joaoanandalima@gmail.com>
X-Mailer: git-send-email 2.55.0.windows.3
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: AF87A180002
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Stat-Signature: b88mdaejntp59h8oxk55uwzwz3oiddb9
X-HE-Tag: 1792838766-120
X-HE-Meta: U2FsdGVkX192R0NBpcbKg0m7WVQ41/U5ZbUerX0qMTH3gK2RFWQa2VrBMw5zTDk5fPh6ltOQuLpypLifLM44yVoO9O0DvsfezNeLyd9Zt9y78rLuPlTA5MoL2/yyyC0VZZdJ/ulskHhefxoK03qDMInyVuTz0dU6C5eE6mncfphfuAuOG8xDm/GaI4OsQctFZLueIdCzMafz8h3hkYFb5IKgi4xhsc8FGT9xcc3fY3EJt+P8UznsaD1trk7CYvDwCzJgh+lGwGWD8UumFDRber2+eBh6FPtyYctwAD95zrxmKbAwlfYh+S95YnpY5ehWS7ysUk9ObXKd9uqJGc5Jdhw3nRh01IvdfawCcsQ9fZBIeQ/yTqBJKY+G0Xns9i5u/ElC7Sg+AHd5ONXw456zlJWrzDZwqeoQS/UGyeWsihHbtPygitcso72zx0XamXE7qL8J8mu14gmaqZ1RPZiICt6Uy/AUNW9/FoEOElSPlH+hq+opP4pfhBFGnp+vK881afFIPyExjdTZTTh49IkVRfs2WCYDsO08zas8p9fbEQs9D4Hm0gFE/zpIFm+FArNu3mfWFXsg9fq1Tx4vO+xVcEo9DmXNtwUgSJdHOhKV3FrNIXWUSpFfStnnrEmznyfeMe/e64r5nfBAD96Lw70PAMvXTeIN0HBvQWi2rXZ8Vyezid4tJAtB4JuCRRwPr0g9/kErTK8LhWqWU6iQe57t05r1DGGbl+I/QvsV+hyeWNjq9CINGHpXo176IZyBF3r5kQHEefKz8a9Q2CWiZcJ5jweerJ1PkuSucHYQV6BlSPC6ddIh6L2xs5ApqOUChjddaGW3wZ2Z7xBvw3/0v9tTExTg2CeCH+ttQG/r6bBjelfE7CJvsujEaFekASIFVE8zZrc9lS2TrVCWWlq51g16paU95zPd7KlsvYtzyCfhYcXqBYBOXkzg40cWB8C+S20LYVVB2ci0ShCouOcEmH/
 pAl8zU66
 CVtTubjzBGg7gg4zTz7urFdIwHKqvocjx1vSWnEEyub4Iv7X2RGkqcGIbm3vVcSF2B+/BHP5IrfgpFUR7kQWByFDlCuNm1AdVUX8Ctk6XppRq3hvqqjAUFXAke6+vtcVU9rG6reRW7Nyl7lx0BN+WmHO8e0PkSbEzv/3eCmNctWQUwCtsV42vL9izJobFZiI22bcIdWkcb/wIrozV7DH+eNfhnEI42qqdU98aEhvSwl1ww/2s8xj8FeakNf0OhKPJdND//YSYPL1LAF9fCQ2fuJo4qzSG7KPYNiCeh3lDcj4AqG6FDEEB+gpZrhvdLvy7rO1VTasSv7ZSVp6rWDUZJEtXK+TfPYJTfViQRxdhAFqWpwP3eV0NuneYDk7dUtuw2PkZobglqvQvHvLpDWCbifsP8KYSafQJZvKJtqUiuLFKmv6BmEpXbbOMIanh3VmWgAHJ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi mm subsystem,

This patch implements the Memory Tatic called PPM, Page-Plugger Under Memory.
The Main Objective is: Page Faults and Overcommit Elimination.

A few points under additionate:

1. Allocation Handshake (ppm_kalloc):
Using the GFP_PLUG_MEMORY mask, the allocator completely bypasses
passive overcommit verification. It instantly isolates physical frames
on the RAM, maps the page table entries síncronamente, and forces the
Present Bit and Writable Bit to 1 before returning the address block
register to the CPU.

2. Desallocation Cleanup (ppm_kfree):
Triggered via the GFP_FREE_T parameter, the release phase executes an
immediate length truncation to 0. It forces a synchronous TLB
invalidation (via invlpg execution) and flushes the data out of the L3
cache lines using clflushopt instructions before moving the hot clean
pages into a dedicated priority recycling pool.

I additionate a Buffer/Cache with store important objects.






---
 include/linux/ppm/gfp_types.h |  74 ++++++++++++++++
 include/linux/slab.h          |  11 +++
 mm/memory.c                   | 158 ++++++++++++++++++++++++++++++++++
 3 files changed, 243 insertions(+)
 create mode 100644 include/linux/ppm/gfp_types.h

diff --git a/include/linux/ppm/gfp_types.h b/include/linux/ppm/gfp_types.h
new file mode 100644
index 000000000..741122b2d
--- /dev/null
+++ b/include/linux/ppm/gfp_types.h
@@ -0,0 +1,74 @@
+/* 
+  Memory Tatic: PPM (Page-Plugger Under Memory).
+  This File is for PPM Flags/Macros/Functions/Types.
+  Engineer (brazilian): João Guilherme da Silva Freitas Lima <joanandalima@gmail.com>
+ */
+
+/* Types Include Guards */
+#ifndef __PPM_TYPES_MEMORY 
+#define __PPM_TYPES_MEMORY 
+
+typedef unsigned char uint8_t;
+typedef unsigned short uint16_t;
+typedef unsigned int uint32_t;
+typedef unsigned long long uint64_t;
+typedef uint64_t gfp_t;
+/* For errors in Allocation */
+#define __PPM_ALLOC_ERROR -102
+/* For errors in Desallocation */
+#define __PPM_FREE_ERROR 0x04 
+/* For success */
+#define __PPM_SUCCESS 0
+#endif
+
+/* Functions Include Guards */
+#ifndef __PPM_FUNCTIONS_MEMORY
+#define __PPM_FUNCTIONS_MEMORY 
+
+/* Initializer */
+void __init_ppm_memory();
+
+/* Allocator Optimized */
+int ppm_kalloc(unsigned long address, uint64_t size, gfp_t flags);
+
+/* Desallocator Optimized */
+int ppm_kfree(uint64_t size);
+
+#endif
+
+/* Flags Include Guards */
+#ifndef __PPM_FLAGS_MEMORY 
+#define __PPM_FLAGS_MEMORY
+
+/* PPM inits/starts in Bit 54 of a 
+   64-bit variable 
+ */
+gfp_t GFP_PLUG_MEMORY = (1ULL << 54); 
+
+/* For free memory, the Bit 55 is 
+   used 
+ */
+gfp_t GFP_FREE_T = (1ULL << 55);
+
+#endif 
+
+/* Macros Include Guards */
+#ifndef __PPM_MACROS_MEMORY
+#define __PPM_MACROS_MEMORY
+
+/* For Kernel Kernel tests 2 Bits (54 and 55) in 
+  1 Clock Cycle (or in small clocks, example: 5 Clocks), 
+  is used a mask using | 
+ */
+gfp_t GFP_MASK = GFP_PLUG_MEMORY | GFP_FREE_T;
+
+#endif
+
+/* 
+  Notes:
+    E-Mail of RFC:
+        [RFC] mm: page-fault: overcommit: PPM (Page-Plugger Under Memory)
+    
+    
+    Assigned-Off-by: João <joanandalima@gmail.com>
+ */
diff --git a/include/linux/slab.h b/include/linux/slab.h
index cda126def..c76243128 100644
--- a/include/linux/slab.h
+++ b/include/linux/slab.h
@@ -22,6 +22,17 @@
 #include <linux/percpu-refcount.h>
 #include <linux/cleanup.h>
 #include <linux/hash.h>
+#include <linux/ppm/gfp_types.h>
+
+/* A Structure enum with objects and codes
+  for PPM Tatic Memory 
+ */
+enum __PPM_OBJ_CDE_BITS {
+	_PPM_OBJECT_CACHE, /* A Simple Cache to store objects */
+	_PPM_OBTAIN_CODE, /* 0x04, -102 or 0 */
+    _PPM_FLAGS__ /* The Special Flags to PPM (Page-Plugger Under Memory) */
+};
+
 
 enum _slab_flag_bits {
 	_SLAB_CONSISTENCY_CHECKS,
diff --git a/mm/memory.c b/mm/memory.c
index 8b0c2c735..5e1ca12c4 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -78,6 +78,8 @@
 #include <linux/sched/sysctl.h>
 #include <linux/pgalloc.h>
 #include <linux/uaccess.h>
+#include <linux/ppm/gfp_types.h>
+#include <linux/slab.h>
 
 #include <trace/events/kmem.h>
 
@@ -94,6 +96,137 @@
 #warning Unfortunate NUMA and NUMA Balancing config, growing page-frame for last_cpupid.
 #endif
 
+/* Small Variables for 
+  PPM uses 
+ */
+int ppm_free_error;
+int ppm_alloc_error;
+int ppm_success;
+unsigned int order;
+unsigned int nr_pages = 1 << order;
+unsigned int i;
+struct vm_area_struct *vma;
+spinlock_t *ptl;
+
+/* Initializer of PPM */
+void __init_ppm_memory() 
+{
+	
+	/* 1. Define the variables for 
+	 the rest of System uses 
+	 */
+	ppm_free_error = __PPM_FREE_ERROR;
+	ppm_alloc_error = __PPM_ALLOC_ERROR;
+	ppm_success = __PPM_SUCCESS;
+
+	/* 2. Connect __PPM_OBJ_CDE_BITS to 
+	   flags under gfp_types.h 
+	 */
+	__PPM_OBJ_CDE_BITS.__PPM_OBJECT_CACHE = 4 * 1024 * 1024; /* 4MB for alloc, used to store important objects */
+	__PPM_OBJ_CDE_BITS.__PPM_OBTAIN_CODE = 0; /* Is modifyed in ppm_kalloc() and ppm_kfree() */
+	__PPM_OBJ_CDE_BITS.__PPM_FLAGS__ = GFP_MASK; /* The Kernel uses this for test */
+
+	/* 3. Alloc the Cache of Objects */
+	char *ppm_identifier = "PPM Cache";
+	int *result_ptr = kmem_cache_create(ppm_identifier, 
+		8, 
+		_slab_flag_bits._SLAB_HWCACHE_ALIGN,
+		_slab_flag_bits._SLAB_PANIC 
+	); /* Number 8 for a 64-bit Pointer */
+	__PPM_OBJ_CDE_BITS.__PPM_OBJECT_CACHE = result_ptr;
+
+	/* 4. Return success */
+	ppm_success = __PPM_SUCCESS; /* The Kernel Optional-Action is verify if ppm_success is __PPM_SUCCESS */
+}
+
+/* Allocator to PPM */
+int ppm_kalloc(unsigned long address, uint64_t size, gfp_t flags) 
+{
+	if (unlikely(!size)) 
+		return __PPM_ALLOC_ERROR;
+
+	/* 1. Alloc the size */
+	order = get_order(size);
+	struct page *pages_ppm = alloc_pages(
+		flags | GFP_PLUG_MEMORY,
+		order
+	);
+
+	/* 2. Navigation in PTE (Page Table Walk) */
+	/* 2.1. Obtain PGD */
+	pgd_t *pgd = pgd_offset(current->mm, address);
+	/* 2.2. Obtain P4D */
+	p4d_t *p4d = p4d_alloc(current->mm, pgd, address);
+	/* 2.3. Obtain PUD */
+	pud_t *pud = pud_alloc(current->mm, p4d, address);
+	/* 2.4. Obtain PMD */
+	pmd_t *pmd = pmd_alloc(current->mm, pud, address);
+	
+	/* 3. Plugging */
+	/* Entry in PTE */
+	pte_t *pte = pte_offset_map_lock(current->mm, pmd, address, &ptl);
+	for (int i = 0; i < nr_pages; i++)
+	{
+		/* Calcle the memory allocated in 1 step */
+		pte_t entry = pfn_pte(page_to_pfn(pages_ppm) + i, vma->vma_page_prot);
+		entry = pte_mkdirty(entry); /* Active bit dirty */
+		entry = pte_mkyoung(entry); /* Active bit young/present */
+	}
+
+	/* 4. Finalize setting in the RAM the page */
+	pte_t *new_pte;
+	set_pte_at(current->mm, address, pte, new_pte);
+
+	/* 5. Unlock */
+	pte_unmap_unlock(pte, ptl);
+
+	/* 6. Return */
+	ppm_success = __PPM_SUCCESS; /* If value returned == __PPM_SUCCESS? */
+	return ppm_success;
+}
+
+/* Desallocator to PPM */
+int ppm_kfree(uint64_t size) 
+{
+	if (unlikely(!size)) 
+		return __PPM_FREE_ERROR;
+	
+	/* 1. Entry in MMU Directories */
+	pgd_t pgd = pgd_offset(current->mm, address);
+	p4d_t p4d = p4d_alloc(current->mm, pgd, address);
+	pud_t pud = pud_alloc(current->mm, p4d, address);
+	pmd_t pmd = pmd_alloc(current->mm, pud, address);
+
+	/* 2. Entry in PTE */
+	pte_t pte = pte_offset_map_lock(current->mm, pmd, address, &ptl);
+	/* Verify if the PPM plugged the page */
+	pte_t result_for_check = ptep_get(pte);
+	pte_val(result_for_check) & GFP_PLUG_MEMORY;
+	if (result_for_check > 1) 
+	{
+		pte_clear(current->mm, address, pte);
+	} else `{
+		/* No executes/call, is ignored */
+		
+	}
+
+	/* 3. Flush for clear the TLB */
+	flush_tlb_page();
+
+	/* 4. Unlock PTE */
+	pte_unmap_unlock(pte, ptl);
+
+	/* 6. Extract the Pointer to free */
+	int identifier_numeric = pte_pfn(result_for_check);
+	struct page *ptr_result = pfn_to_page(identifier_numeric);
+	free_pages(ptr_result, order);
+
+	/* 7. Return success */
+	ppm_success = __PPM_SUCCESS;
+	return ppm_success;
+}
+
+
 static vm_fault_t do_fault(struct vm_fault *vmf);
 static vm_fault_t do_anonymous_page(struct vm_fault *vmf);
 static bool vmf_pte_changed(struct vm_fault *vmf);
@@ -6848,6 +6981,31 @@ vm_fault_t handle_mm_fault(struct vm_area_struct *vma, unsigned long address,
 
 	__set_current_state(TASK_RUNNING);
 
+	/* If PPM returns no is == __PPM_SUCCESS, ignore the PPM Mode and 
+	   sign the default flow 
+	 */
+	int code_error = __init_ppm_memory();
+	if (code_error == 0) 
+	{
+		/* Verify flags */
+		unsigned int ppm_check = flags & GFP_MASK;
+		if (ppm_check == GFP_PLUG_MEMORY)
+		{
+			ppm_kalloc(address, size, flags);
+			return VM_FAULT_NOPAGE;
+		} else if (ppm_check == GFP_FREE_T) {
+			ppm_kfree(size);
+			return VM_FAULT_NOPAGE;
+		} else {
+			/* Executes none */
+		}
+
+	} else {
+		/* Executes none, is jump to the instruction of 
+		   'ret = sanitize_fault_flags(vma, &flags)' and next 
+		 */		
+	}
+
 	ret = sanitize_fault_flags(vma, &flags);
 	if (ret)
 		goto out;
--


Signed-Off-by: João Guilherme da Silva Freitas Lima <joaoanandalima@gmail.com>







2.55.0.windows.3


