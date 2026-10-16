Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 17E4ECCA463
	for <linux-mm@archiver.kernel.org>; Fri, 16 Oct 2026 03:10:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 203FF6B009E; Thu, 15 Oct 2026 23:10:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1DB076B009F; Thu, 15 Oct 2026 23:10:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0F14E6B00A0; Thu, 15 Oct 2026 23:10:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id CA9526B009E
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 23:10:19 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 5A7C780292
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 03:10:19 +0000 (UTC)
X-FDA: 85327010958.23.52C2BA5
Received: from mail-pj2-f11.google.com (mail-pj2-f11.google.com [74.125.227.139])
	by imf25.hostedemail.com (Postfix) with ESMTP id 8C16FA0007
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 03:10:17 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=aw7WftqB;
	spf=pass (imf25.hostedemail.com: domain of chenwandun1@gmail.com designates 74.125.227.139 as permitted sender) smtp.mailfrom=chenwandun1@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792120217;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6w2trImMBsUXcJxF+8CP2LmtHij/l89KoLcRCpS0ni8=;
	b=Bi3O2/KZRUXPD5rvgcHgbzlqXCguN9d8tHh6x3zMVb1mrtKMRVsd+hhvMFz+PS6YR5fYcK
	HQjCTOKGs17gxwVScOQ8Jl1B2uxILFc7MpSi4T9LneH0Np3nG5+5ES2JPeyajRFzvufOSS
	pSKLfErwtjuQix83aYsNmcyZZwVxS7k=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=aw7WftqB;
	spf=pass (imf25.hostedemail.com: domain of chenwandun1@gmail.com designates 74.125.227.139 as permitted sender) smtp.mailfrom=chenwandun1@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792120217;
	b=tOq19b9ronM5vt6B21q+/LQqC2vHvan5/RdjruKQ6gZh3KQyiHE1b5maZizwtfpWhmi1WD
	+MXrUgYHqSzRlskqAyX1beicJhMI8g2CUA8QI+Tt0hw2crASHMQDJ8qxgSz1XKPQ6jYcZn
	PaezpvSrv2R0fX7wBeLKm3wggaRd8u0=
Received: by mail-pj2-f11.google.com with SMTP id 98e67ed59e1d1-398a0a87595so1267946a91.1
        for <linux-mm@kvack.org>; Thu, 15 Oct 2026 20:10:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792120216; x=1792725016; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=6w2trImMBsUXcJxF+8CP2LmtHij/l89KoLcRCpS0ni8=;
        b=aw7WftqBdVbhknysUmDY2IWp7E/FCCisin1dtMg6qXrQ8mBFzMgmF8b1g7GXeGf7XM
         iaKmSHbmKqVzjKlPLrKQU4n2G1qgowBuP2Sgnm+5F15J3HIaoGeoift4hoSokU8NUTND
         Ck54BQ+fORB5k1UezksGLa4rSSagPHGu70QwF5z99b0SMO9JsGj6Oilk+G50mngBLJKf
         xq5db97QwkrIRZNmElS091tyBhJAO5p87gBjkHZSsgde/o+EuPgZASsmiH+KSTeqn9i3
         UiL6bJA7vIWc3hIWJCCYpsgqUk1rYkoKrzTfCbNTvDS7Fz3vxIrhy/N8Okw8aWXqpepY
         E9bg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792120216; x=1792725016;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=6w2trImMBsUXcJxF+8CP2LmtHij/l89KoLcRCpS0ni8=;
        b=s209tMFS4/xrvD34P+NQlJbTtkxXVAHXFk6lyISQXQIK61KbxoiJzHySG9uLvI7BJN
         mQX4vFFkF0x3+c4jB7WjScrYWQGeY48PUWAtB7kuYlkT7fWhUfnigX1nZSyqGlGzhE7d
         r1lTVwt8BQ2BsTqUUTa74TlGbHLPsaCzyZne4Xdwo5jhYXGsPQ/ZPHZ4whxa2luqnGOS
         asMaP8A6fJklkqIKGFzzeh/i2iguVaKmtRGfDzxH79+OmEMXqX2wodY3YeF3cmjXjHue
         W2w0ilIW33J6jwD0VlInObLcB/blaLInDAmARX/qBu1M2weL8pZ/wrq6jFHM18bQaDdY
         8D9Q==
X-Forwarded-Encrypted: i=1; AKwUvBzyEASXxn+Y0yPRs8+pqYNhEfb3reLxG5t0aNsFCBq7w9QNdqhsrmty7bVZypLKHgMUgCD6CwilVw==@kvack.org
X-Gm-Message-State: AFq9FYK6aATAUxSeB2GKJ2NOgmXuxwxhM+c2dQHVCQWrnlxnMZQIiFip
	bm5T0RcRoJGjkHAy9hqFOcdVne2MgOV5p+MEsLNySWnoqPJxiPIUVYPq
X-Gm-Gg: AYBFou2wf+kTSSJHTKd84tD+vyf3gvVKGbFybvOD3SY4BlHgCNkYbTpLvKCZrzjZYH1
	WhZR0YK9EIuv5picTahOIZvvHBUcjjp4MHzQ2RTHdH9z1HZaArZ5ewRDv8spwN55QSQhkmTugBM
	PFqX59ozOTNN7OpwODqeZRAOj+LZQIJGnEEAjVBqsAIPUTCUF8CILd7DM3Fd1P5LzShlZRiQpNl
	KdQ7jHmh3GtCCN0VpK9GLOzxqabn75xQH9UgibgRk8DlseqNK/BkO01VrfPHeWeMYJMfwVTvMf2
	vWLjMqJFjL/fxrkmqZ+mBTfztfB7e5wsEFrOKwsVTo6Axz7NpPBf2eCtD8rP7Cxuirt4eF8YReG
	RFaFSbKObKH6MJ34FH6SFR1p9kr/XT0Ps2xBe25nCTfDS4fjdvdhujzbJjEDU3cK5ZmNmccZ0VJ
	rmIQjN0Ycm5ZnuBZHLtp9lJ2LzetvVw9hy2ThkWXbrCFpRaicgFaAHEYZzYG5q7RKcuG+17uyPb
	NkFuO6RCZY=
X-Received: by 2002:a17:90b:224c:b0:3a8:bbc2:5551 with SMTP id 98e67ed59e1d1-3ab3a0f0a1dmr21861671a91.0.1792120216184;
        Thu, 15 Oct 2026 20:10:16 -0700 (PDT)
Received: from intel.company.local ([122.11.210.25])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3acd3cc73c7sm370085a91.4.2026.10.15.20.10.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Oct 2026 20:10:15 -0700 (PDT)
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
Subject: [PATCH v8 5/8] memblock: introduce MEMBLOCK_NODUMP flag
Date: Fri, 16 Oct 2026 11:08:52 +0800
Message-ID: <20261016030855.4062882-6-chenwandun1@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261016030855.4062882-1-chenwandun1@gmail.com>
References: <20261016030855.4062882-1-chenwandun1@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 8C16FA0007
X-Rspam-User: 
X-Stat-Signature: 1g4qdi8pinqirjmm44gp7bnyugo4w9w3
X-HE-Tag: 1792120217-203087
X-HE-Meta: U2FsdGVkX1/DmXK1Q8KoXfLaJuyXcVJm7qd9AER/S6NV/HbshaCOplBr/Ln0IdUHAn2y8sghVcp/STvo3WvwT2VMRL1dZE+Qf3R+Ew5eRs3VTPJ2FfGJOvAAK1o0SaX1ENL6uSdUsd4Ro9dg5Lw5KaSdleTY+qDOOGoYOO/FSsnQKsKxBrAtnPh1EBIFrllkHRmx7yNoLOwqYA8VIjSEIqr1Tzq3JXDDVG3wt12aa30yZfiU018mVXa/qDgOEU06t/gI/owahWvzEhw5Z0GIdguBVTTvgg9Zs+tEDl+Gf5F4z2XG99E+zeZM39kw4ucDnLwyWNLNGLlu5O2SGxs1nLmouyNOIql6YSivdMcOIKloaUcNiS9qG4EQcLnzz8aTDKEHlPjk2eVQNEAIkEjg0bo8wN17bhpznyjafwZf0fx7lWKZHyGr7cRzUnk7L/dHV9pBj4yhFMxVBzpwQK2gUoQcpX0hvnEAFBKNWhtonDVR7HRmvIDrKaxQkZ+uF5Avlrf7bkP+if81o/+6AFkWBDSns3+Wxf/ck83xygM/7qqdIVssVqKkivDmxievRk0v4I8JOrkRtv17VqBPZw1eQRUM3cJsumLKdvLFaxLrTCKRi4KSPALfmMxNTOfyxXdl009WsNcMvAz7f5mfB0GelUmL3eAQOEn79q2lnrrudWHjlhN4jok48mP3azUrVTDnboMiE3eUUXK+t0Jp8Ed+y1YPfrZiXQ7RUSUqapT4CHneyVnhQuSqMUpZtZM5C6unw+jsujdP/IEl2R308A3JEJDUC1EzAuSw5ODyVIzExTBulvauxkoU1nilPJV1dpAn52uGF+FFofUF7asaFuOjpBg7BRtlkgu51VA9x0wtQbHmvCjhUknWAgklGApKOeXWl+Mtdh1iOzUBZczSfrW+dQhrAda98oj0G2hn37LvAWXOLGnEVeB7rpV/bx6LOaFK4MSq8Faf7J93SAWugUH
 DriTNLVb
 /aTqRXFQQUiAsNehlBdnntCSoY70MZrldbg+Ub8vFGswXw94Lk5UFgXBDmndGW0Yn8tibJEqjmemSqtFOZzrHoJAl0qvsMeuwWec41EBTfgNDJgxCxwWEEOukFy6Nny/fz5XqXk66Gx6u7lKKWgmkfT0uoLicNgX5V3DqN7hhInb9K2bcFvKeAL6NdZ2nA5Y4FcEHNitM0iCLsmrKmlLJNQLbkjJ+B48TJibeBNYMAqIANKa69WpvVT2Uyn0dMZHcTLeH4DKAPtr97sCVXqn4Qxgn75emMsmNkob9QfPp8PXrowvFs9ohs46rhPhVgPlg1uqvPgT6nFI+xaGHSghuzMDXQQiX6w9I+cGqxkq5//eoN7RLPa/O1MU6tn+/bq2jqyaheQxvhv5motHsd69kyD738+cMAHeqb4CW5rBL88ytiTPMUbXM17y9YjekuTSq8YQt0aZ9FZkEroILcC09xm/ib1pAokUVIcXmmudn/1hA4qScQJCjNBpd06Xe0/oXUmiTEkvlmzSkZnM=
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
patches wire this up for /reserved-memory entries.

Suggested-by: Rob Herring <robh@kernel.org>
Signed-off-by: Wandun Chen <chenwandun@lixiang.com>
Tested-by: Meijing Zhao <zhaomeijing@lixiang.com>
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 include/linux/memblock.h |  9 +++++++++
 mm/memblock.c            | 16 ++++++++++++++++
 2 files changed, 25 insertions(+)

diff --git a/include/linux/memblock.h b/include/linux/memblock.h
index ea288cf21400..04fbdff2b808 100644
--- a/include/linux/memblock.h
+++ b/include/linux/memblock.h
@@ -52,6 +52,8 @@ extern unsigned long long max_possible_pfn;
  * know is good to use. It is the only memory that allocations may happen from
  * in this phase.
  * @MEMBLOCK_RSRV_HUGETLB: memory is reserved for hugetlb pages
+ * @MEMBLOCK_NODUMP: exclude from kdump vmcore. It carries no data useful
+ * for crash analysis (e.g. firmware carveouts).
  */
 enum memblock_flags {
 	MEMBLOCK_NONE		= 0x0,	/* No special request */
@@ -63,6 +65,7 @@ enum memblock_flags {
 	MEMBLOCK_RSRV_KERN	= 0x20,	/* memory reserved for kernel use */
 	MEMBLOCK_KHO_NOPRSRV	= 0x40,	/* memory with no KHO preservations */
 	MEMBLOCK_RSRV_HUGETLB	= 0x80, /* memory reserved for hugetlb pages */
+	MEMBLOCK_NODUMP		= 0x100,/* exclude from kdump vmcore */
 };
 
 /**
@@ -160,6 +163,7 @@ int memblock_reserved_mark_noinit(phys_addr_t base, phys_addr_t size);
 int memblock_reserved_mark_kern(phys_addr_t base, phys_addr_t size);
 int memblock_mark_kho_noprsrv(phys_addr_t base, phys_addr_t size);
 int memblock_clear_kho_noprsrv(phys_addr_t base, phys_addr_t size);
+int memblock_mark_nodump(phys_addr_t base, phys_addr_t size);
 
 void memblock_free(void *ptr, size_t size);
 
@@ -305,6 +309,11 @@ static inline bool memblock_is_kho_noprsrv(struct memblock_region *m)
 	return m->flags & MEMBLOCK_KHO_NOPRSRV;
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
index cbb172fbf06a..31c89bd64036 100644
--- a/mm/memblock.c
+++ b/mm/memblock.c
@@ -1204,6 +1204,21 @@ __init int memblock_clear_kho_noprsrv(phys_addr_t base, phys_addr_t size)
 				    MEMBLOCK_KHO_NOPRSRV);
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
@@ -2880,6 +2895,7 @@ static const char * const flagname[] = {
 	[ilog2(MEMBLOCK_RSRV_KERN)] = "RSV_KERN",
 	[ilog2(MEMBLOCK_KHO_NOPRSRV)] = "KHO_NOPRSRV",
 	[ilog2(MEMBLOCK_RSRV_HUGETLB)] = "RSV_HUGETLB",
+	[ilog2(MEMBLOCK_NODUMP)] = "NODUMP",
 };
 
 static int memblock_debug_show(struct seq_file *m, void *private)
-- 
2.43.0


