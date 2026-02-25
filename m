Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2B20DFD3768
	for <linux-mm@archiver.kernel.org>; Wed, 25 Feb 2026 15:40:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7054E6B0089; Wed, 25 Feb 2026 10:40:09 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5D9EF6B008A; Wed, 25 Feb 2026 10:40:09 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4DCE96B008C; Wed, 25 Feb 2026 10:40:09 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 3D28C6B0089
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 10:40:09 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 0DC7216065B
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 15:40:09 +0000 (UTC)
X-FDA: 84483390138.28.1980701
Received: from mail-ed1-f73.google.com (mail-ed1-f73.google.com [209.85.208.73])
	by imf15.hostedemail.com (Postfix) with ESMTP id 3140CA000E
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 15:40:06 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="hIZr/1nR";
	spf=pass (imf15.hostedemail.com: domain of 31RefaQoKCNQC2B0F8DIA86EE6B4.2ECB8DKN-CCAL02A.EH6@flex--mclapinski.bounces.google.com designates 209.85.208.73 as permitted sender) smtp.mailfrom=31RefaQoKCNQC2B0F8DIA86EE6B4.2ECB8DKN-CCAL02A.EH6@flex--mclapinski.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772034007;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ipTaz++qTtdDCBjKXU7vNcSleKIn31kyDo4+ZfAiimU=;
	b=Va+mhERke/lD5ZzHgWY24V8HyHIC4F5ANVV6dzCs/oZkmaf4FIiCUK7thfUl8soe2sGGVQ
	3iWWXVBAJ70sDrfIO1E3bbzAG02qOhcfux/frs3HBLAZZzTCQwBsRMGM+yB4Dot1yo1kMC
	brCz2mSZpT+YoDUo3ooRus5XKeW1tTk=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="hIZr/1nR";
	spf=pass (imf15.hostedemail.com: domain of 31RefaQoKCNQC2B0F8DIA86EE6B4.2ECB8DKN-CCAL02A.EH6@flex--mclapinski.bounces.google.com designates 209.85.208.73 as permitted sender) smtp.mailfrom=31RefaQoKCNQC2B0F8DIA86EE6B4.2ECB8DKN-CCAL02A.EH6@flex--mclapinski.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772034007; a=rsa-sha256;
	cv=none;
	b=JUbS22jbILGDv+ZTa6oI4pgo4DsaMjlU9DfnHmX6hJSz5MOfGWykducjNp3SY/WKWQGD3P
	2NHPI+RKGGaMGD0eEYveS6rdRtfdHnyX9DFDZGZiLbS4Eo/RhQP0NaEVvQup3fimMHWAl3
	fmXgXPoFaCo2Tqy5Fu9tLbeDCXSr9cg=
Received: by mail-ed1-f73.google.com with SMTP id 4fb4d7f45d1cf-65f99e631bfso841871a12.1
        for <linux-mm@kvack.org>; Wed, 25 Feb 2026 07:40:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772034005; x=1772638805; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=ipTaz++qTtdDCBjKXU7vNcSleKIn31kyDo4+ZfAiimU=;
        b=hIZr/1nR4pTvUxCGP+qTeHBaBSCZvuaZUFGwrw3GaLsIAhhFb2y51K0lDF5uMPIGeL
         vHPp5HC2Q+1DXJqqwfkndUIHQO3XfNboElfZZP5j6oT94ULghMP+UDMW5uj7w96KvGhu
         tzh0q68LENbNf2DYcU1vcYIKRafIoS4HeNL9JGT79NogFZ4VkYfWFH6ajc+/sD0CPHvQ
         IB9u6PxfwlTJEP5rVGFUqarKnuf79KW262o7A0xcuhZnBnT55uv6ZK2lnZ4/Mo2MzvZX
         fYDoE7IYae4JvbPmNAAw7iUfGVuoFwTburkBMoIoPqqeXLGuY2YKE5oJEbryUMjghRjj
         ufTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772034005; x=1772638805;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ipTaz++qTtdDCBjKXU7vNcSleKIn31kyDo4+ZfAiimU=;
        b=P4xSWqPnX4zN9NhBG1bx0+nmLUa9phg1NxNbH24dxAoQNTmruxYPe5nuep/lp84ZDG
         R8rojMEuIWi6yOI3ut+nvmdpYm6vUpWuwF6PUYspxMISiUw3dQAHTJexAVXzayIn67Z8
         KIfTk0S0zRnyWs6Yqpi4J+mOF6koacbSimneEVv3FT1YacA5RsjSnzBLXpr8qTMMMJQn
         WYgmy1gzt5KUE9JLbJRzTqHZjVn5yABkOztStX8jb91aAV/cP95dcXSLH7/4HyrvXHrz
         WZvuZWrSalba+X2Dpd9lJNA0O2HxKwoanh5vAGg7cM0Awgw0r9l3j/IQIOhAlirY60x+
         1quA==
X-Forwarded-Encrypted: i=1; AJvYcCWQLsAM8lyhrFRpp0oZHonG4yJ0HUFjFWUt+NP5LNfWRVaWiWy2wU2NVy8H4+KzyQXqxAfrY/Sj8A==@kvack.org
X-Gm-Message-State: AOJu0YynKeLDReiAeLsWtXV4POmiT9EwKYNk7pdWvEIJARO5RFShkT4K
	JDJPlqGSm4zFp3Tbd6fCk1oBL9V0ICjN3NevCcanGp4I56XR4ssxKdkugU/TDA99GP4eXN85Zr8
	r01XX70JuUEeG21SXkdj8fQ==
X-Received: from edsu1.prod.google.com ([2002:aa7:d981:0:b0:65a:1eb4:60db])
 (user=mclapinski job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6402:360e:b0:65f:7000:928f with SMTP id 4fb4d7f45d1cf-65f700095a8mr3689412a12.0.1772034005339;
 Wed, 25 Feb 2026 07:40:05 -0800 (PST)
Date: Wed, 25 Feb 2026 16:39:54 +0100
In-Reply-To: <20260225153955.1006649-1-mclapinski@google.com>
Mime-Version: 1.0
References: <20260225153955.1006649-1-mclapinski@google.com>
X-Mailer: git-send-email 2.53.0.414.gf7e9f6c205-goog
Message-ID: <20260225153955.1006649-2-mclapinski@google.com>
Subject: [PATCH v5 1/2] kho: fix deferred init of kho scratch
From: Michal Clapinski <mclapinski@google.com>
To: Evangelos Petrongonas <epetron@amazon.de>, Pasha Tatashin <pasha.tatashin@soleen.com>, 
	Mike Rapoport <rppt@kernel.org>, Pratyush Yadav <pratyush@kernel.org>, Alexander Graf <graf@amazon.com>, 
	kexec@lists.infradead.org, linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, 
	Michal Clapinski <mclapinski@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: cmuge1yfju4nyugwsa866q8z8a5pjbip
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Rspamd-Queue-Id: 3140CA000E
X-HE-Tag: 1772034006-324581
X-HE-Meta: U2FsdGVkX1/Gq6aOe1jM+uvAK9UZvHZbunpGWiqPqLvzR2UoMoXi1bHsr/vb6y6T0SMS/VV1sXgeov3Pn5JaGP2J5veyU9VbRkWpgCW3u7tMDTDQI5Kog47xcu9f9IcNPcyBngyqWnv0ekB241rRktKqPuVx3lNkv+5FOZEzjA5AZJZHf55a3BTRx3O/gZER1RvlaDdRujkM7bs7egXr1RYzKYDPqREu6BG5LS0cbpgfDEalm5B5uSEqANIAjktKHLhalRmjXf5Bqhoh3iRXG+TRIqDXMUQcvIKm13j6jrSB1bM+8BWKxSRZmDH4ujWwex9mzZo7WaKtPwLcR+8fBGrnpgQq3wcH00L8ZD/+dpMV+W0oiuO4MxYLzBYcQcd7rmlgvLBa54nABf7670IMNcpXp2m9+JynKj9RMmSmktXxRZELnOqw6+dsK3ufEantXnlzdOwb8X73plIuvwLtTlV5pF+9CNx4sYlbi9pNcMwnw42Xsyj2ceQB8jLi/bTK7S52WBhVF/iJXNaa184Rlbhjpf5zdO0Ea3WrvrCCCMljsktVb0L/tPrEcJcL7LKEzuXfn1syXaCXgkruBI6vOD54YkjQjVqdv2tWMokRysHg5SYF3b/ku+uGDENEniMHacmsvzF3FzUyOKQx7mQbzP0CpJEz9BkyN2k5Xh+tsIQiS9VamZYCgQUOYDd7ptJqdMiE2wB7jrezrd8Wjx+0wWBEIxYq5NQQNMRhqYilRi/9B6ddmAoWitU8tgTgA1BjX3Lvy+6v3JUD9uDLXQLjaPFsNbouIAbHYnc3g4tIdKbZlFeevGNZEp/UG4TvYCqaiK4OaBT7xU9drBiOt1xdlBTWj5PnrbbCRxz3ziSKT5BJcfdlVnDroZraTjWA+TVwbzCWZrgm+4nZK/66JuXF5wRzoxcLGmGpr2PVNCkwW50QMxmELX9MzSYXOMr7mGGvDaI1qAPRyg3MYEPj2/6
 vU5KwNIm
 yWoN0RyeQ7lSBuPc5nESqxWtMKag0RjH5maLuY0XqqrMJaF4sqt2AdJJoFGgOHypjIh99U3bVAlOxsDxIqrEx7U/FnrRADDBw5hVHTTfs1SQajdoqJIDNBi8B4hiLJ13o+TbUJL8gwzt1VUJqw0QkejcSrOPOiPbxSYTD9z++gjZ7lXD7dn4WGBWFHo/KTz5bxhA8bfD5iO17W8823QzgTKGJEpgmoz9sK8BxwM+V8/Ok1vsllO1ovC8CZMSS9WpFWx0hYBbLePc1+teYVtm7nxY+P/rtXrZeZPKV6s1haJeGYosnqsNoZWYkJ1VgZsbzWopBHB8CvyLJmPz2s8a2plthIk6xL1qWXGhjqRHbHKnNXdLNTBtnGyQFKTR+dbc7p+QoXSJ4PnC++r0TTeHjucH4aQ44N3x1flmJEX+qGY7hISUPONCKRirMG3crHL36ShuVtSkjZXXo21Fs/r2sF8EhN+Wbr4OvIV6ZYOFiFSohbs+SN333Lg5oepqsFM5dWO6VTPh0uLO9J+XiBUIFLnsS2QWXOWdOi4Gss7xXi9Ek+4Fjs4BUX3py6GysPTYdyYstKAem8LOgZwkBn3/zjx23d0c1C/gz/AH1tGVBiMukT5tYCW9j2d2zcpDrI13gFN94VikAW61x27BzpEbQYR87QF8Ac4frKCjv+V9hEyXqFu3CWScu+e94kw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Currently, mm_core_init calls kho_memory_init, which calls
kho_release_scratch.

If DEFERRED is enabled, kho_release_scratch will first initialize the
struct pages of kho scratch. This is not needed. We can just let
page_alloc_init_late init it.

Next, kho_release_scratch will mark scratch as MIGRATE_CMA. If DEFERRED
is enabled, this will be overwritten later in deferred_free_pages.

To fix this, I removed the whole kho_release_scratch.
Marking the pageblocks as MIGRATE_CMA now happens in kho_init, which
runs after deferred_free_pages.

Signed-off-by: Michal Clapinski <mclapinski@google.com>
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 include/linux/memblock.h           |  2 --
 kernel/liveupdate/kexec_handover.c | 43 ++++++++----------------------
 mm/memblock.c                      | 22 ---------------
 3 files changed, 11 insertions(+), 56 deletions(-)

diff --git a/include/linux/memblock.h b/include/linux/memblock.h
index 6ec5e9ac0699..3e217414e12d 100644
--- a/include/linux/memblock.h
+++ b/include/linux/memblock.h
@@ -614,11 +614,9 @@ static inline void memtest_report_meminfo(struct seq_file *m) { }
 #ifdef CONFIG_MEMBLOCK_KHO_SCRATCH
 void memblock_set_kho_scratch_only(void);
 void memblock_clear_kho_scratch_only(void);
-void memmap_init_kho_scratch_pages(void);
 #else
 static inline void memblock_set_kho_scratch_only(void) { }
 static inline void memblock_clear_kho_scratch_only(void) { }
-static inline void memmap_init_kho_scratch_pages(void) {}
 #endif
 
 #endif /* _LINUX_MEMBLOCK_H */
diff --git a/kernel/liveupdate/kexec_handover.c b/kernel/liveupdate/kexec_handover.c
index 410098bae0bf..1e1f69b10457 100644
--- a/kernel/liveupdate/kexec_handover.c
+++ b/kernel/liveupdate/kexec_handover.c
@@ -1388,11 +1388,6 @@ static __init int kho_init(void)
 	if (err)
 		goto err_free_fdt;
 
-	if (fdt) {
-		kho_in_debugfs_init(&kho_in.dbg, fdt);
-		return 0;
-	}
-
 	for (int i = 0; i < kho_scratch_cnt; i++) {
 		unsigned long base_pfn = PHYS_PFN(kho_scratch[i].addr);
 		unsigned long count = kho_scratch[i].size >> PAGE_SHIFT;
@@ -1408,8 +1403,17 @@ static __init int kho_init(void)
 		 */
 		kmemleak_ignore_phys(kho_scratch[i].addr);
 		for (pfn = base_pfn; pfn < base_pfn + count;
-		     pfn += pageblock_nr_pages)
-			init_cma_reserved_pageblock(pfn_to_page(pfn));
+		     pfn += pageblock_nr_pages) {
+			if (fdt)
+				init_cma_pageblock(pfn_to_page(pfn));
+			else
+				init_cma_reserved_pageblock(pfn_to_page(pfn));
+		}
+	}
+
+	if (fdt) {
+		kho_in_debugfs_init(&kho_in.dbg, fdt);
+		return 0;
 	}
 
 	WARN_ON_ONCE(kho_debugfs_fdt_add(&kho_out.dbg, "fdt",
@@ -1435,35 +1439,10 @@ static __init int kho_init(void)
 }
 fs_initcall(kho_init);
 
-static void __init kho_release_scratch(void)
-{
-	phys_addr_t start, end;
-	u64 i;
-
-	memmap_init_kho_scratch_pages();
-
-	/*
-	 * Mark scratch mem as CMA before we return it. That way we
-	 * ensure that no kernel allocations happen on it. That means
-	 * we can reuse it as scratch memory again later.
-	 */
-	__for_each_mem_range(i, &memblock.memory, NULL, NUMA_NO_NODE,
-			     MEMBLOCK_KHO_SCRATCH, &start, &end, NULL) {
-		ulong start_pfn = pageblock_start_pfn(PFN_DOWN(start));
-		ulong end_pfn = pageblock_align(PFN_UP(end));
-		ulong pfn;
-
-		for (pfn = start_pfn; pfn < end_pfn; pfn += pageblock_nr_pages)
-			init_pageblock_migratetype(pfn_to_page(pfn),
-						   MIGRATE_CMA, false);
-	}
-}
-
 void __init kho_memory_init(void)
 {
 	if (kho_in.scratch_phys) {
 		kho_scratch = phys_to_virt(kho_in.scratch_phys);
-		kho_release_scratch();
 
 		if (kho_mem_retrieve(kho_get_fdt()))
 			kho_in.fdt_phys = 0;
diff --git a/mm/memblock.c b/mm/memblock.c
index b3ddfdec7a80..ae6a5af46bd7 100644
--- a/mm/memblock.c
+++ b/mm/memblock.c
@@ -959,28 +959,6 @@ __init void memblock_clear_kho_scratch_only(void)
 {
 	kho_scratch_only = false;
 }
-
-__init void memmap_init_kho_scratch_pages(void)
-{
-	phys_addr_t start, end;
-	unsigned long pfn;
-	int nid;
-	u64 i;
-
-	if (!IS_ENABLED(CONFIG_DEFERRED_STRUCT_PAGE_INIT))
-		return;
-
-	/*
-	 * Initialize struct pages for free scratch memory.
-	 * The struct pages for reserved scratch memory will be set up in
-	 * reserve_bootmem_region()
-	 */
-	__for_each_mem_range(i, &memblock.memory, NULL, NUMA_NO_NODE,
-			     MEMBLOCK_KHO_SCRATCH, &start, &end, &nid) {
-		for (pfn = PFN_UP(start); pfn < PFN_DOWN(end); pfn++)
-			init_deferred_page(pfn, nid);
-	}
-}
 #endif
 
 /**
-- 
2.53.0.414.gf7e9f6c205-goog


