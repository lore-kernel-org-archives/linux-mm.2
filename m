Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 42DCF606A320
	for <linux-mm@archiver.kernel.org>; Wed, 21 Oct 2026 08:31:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=QVUyskAf
Received: by kanga.kvack.org (Postfix)
	id 627CB6B0670; Wed, 21 Oct 2026 04:31:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5D8A96B0673; Wed, 21 Oct 2026 04:31:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4A6486B0670; Wed, 21 Oct 2026 04:31:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 12C9E6B0670
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 04:31:45 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id A0C821A04B4
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 08:31:44 +0000 (UTC)
X-FDA: 85345964928.29.D5971AA
Received: from mail-pz2-f2.google.com (mail-pz2-f2.google.com [74.125.228.2])
	by imf08.hostedemail.com (Postfix) with ESMTP id C6856160002
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 08:31:42 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=QVUyskAf;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf08.hostedemail.com: domain of chenwandun1@gmail.com designates 74.125.228.2 as permitted sender) smtp.mailfrom=chenwandun1@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792571502;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fKpfFiVoVVnNbFsiCGN8s68JTp1We4GBLmYun2RkI28=;
	b=2H6Ot75G4/fuE6XbE2ZvScGocNqaJkAYX5b06iQmAAus8u+F5aTWLJN//44T94Hb3JYpfF
	ltn3t0W5/Ps4q/TA0NWzaKRSNShq6GrJZCT1VzFcTU8W2YarDUOipiTIPYkKzlObuLdHe+
	Qbf1RIksUOz+SIEz3/dnMniigNobjWU=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=QVUyskAf;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf08.hostedemail.com: domain of chenwandun1@gmail.com designates 74.125.228.2 as permitted sender) smtp.mailfrom=chenwandun1@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792571502;
	b=KdRQPIzRJJTCYECmof6TjDU/L4kTV4fzOj8vZozLz60NesyfR/IpffTxUB1qfHW+or97em
	X++7ilA5ergKcwt3opnCxadQjuY0iI5mADaJJ1FZph2X5LBMzi07PKGC0ezzPr1DoSS4Tc
	dnt8cYB47PwncaPkL8AaUeR11J+aJDU=
Received: by mail-pz2-f2.google.com with SMTP id 41be03b00d2f7-ccc451ef3a7so38755a12.1
        for <linux-mm@kvack.org>; Wed, 21 Oct 2026 01:31:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792571502; x=1793176302; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=fKpfFiVoVVnNbFsiCGN8s68JTp1We4GBLmYun2RkI28=;
        b=QVUyskAfDnVF3TTimUk3ib1mKmmmkScd5AbC7q80GcgiPA1AfIU4it9sSIOZYqlB9T
         C+3QMU+2uEHh1/XaRySmYDORvc0JIOtyZHSiVRx/FdoE0l9Pajj8LZ9q4UaURBrg9Nae
         fOz9lNjoWVAW7lbgBxnUFSpsU+6ODAcq2j7fQuIHPgsS6KB3+LZqjPJfzRwaj6KbGNma
         b/QrGlGU6dkU9cvge4T0aKJpM6dSfyIUrVMAO/n+Kh1NtjMLC7+DdS1mcGzKGw3ZHKrW
         u1ogqzYK7SwhopTTPi+u+6ojoGsAPmmeYIGFCq4JMJ95Uzr1pPemEsIFZS9DWpA+csIx
         za9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792571502; x=1793176302;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=fKpfFiVoVVnNbFsiCGN8s68JTp1We4GBLmYun2RkI28=;
        b=O+JkeL40CNTETJbwY3CypccDKkqr0AZEw2jUc7kgIRdjx3S2vpsXCEUKpIL6ZKtrMA
         UcUMi2OdDKbVJB1yXPsgp6n+c/j0j/l9IS2wb75PZQLgqU/hTfwMGqvwZuyoc/o+Fb+T
         zZJvzHJSVjX66Jai8cJo+iXo2nvXwcEdwI/AWRwiRlr07wrC1vojCX8TpmkJgNmI0l0+
         lFAZftzL//JuLQZcGbJgxgZCpuisoreBkU81vAQBNF93FXWj1zTCvbbW8vIVv15w0ik2
         /PZ6UMyY9P8sUepEj2g3tkHoYBPLXK6Wp/L91GTBReZ66JnsPfVNdHB+lDUA8BqxjCTO
         1jEw==
X-Forwarded-Encrypted: i=1; AKwUvBxs9APab5Qem10EdVgitaqkH4BmYc6+cAJ5vo9tCh3Z7cnJyxBiZ3UqRDy17E5cAhraq1R71s2BYw==@kvack.org
X-Gm-Message-State: AFq9FYKGyUPJP8p1lDbmtXfvvDYOnlsi7suP6Ig25AGJutaU4HEskteX
	u4uKtO400ayN2rKMyiep5it4BP1qsqaqt2FEdv9/7XXWHzxXU8Nq58ws
X-Gm-Gg: AYBFou0sDje+rHkSj9zjd18jFMt1h+nzjvJkDCOgOQ1coe4Y1WuTzmO041cZW29cz68
	7quj6U0L2UOgpUgXWwdNoKyzKryB7cvZJDdE9EuZ3z56WEyw2rdqw64utBPV9R9JHepylpWRyo6
	5q3aDWkVs9QKFsp9WocgBq7uCe5Z5xNPNMx8hWfR/owqw7gzlxNdgRQjX/N3QXq1JThpqeRzcbk
	OAUbrJnNgK56oYGx9nSTUTQ8jzTy/fdrbXX9jh/J5+csvRZIiisN6tJnj+ZNtwFHux7PH+UaaI8
	haHeJvh90bgl4k5Z+ch92E0UjdOzw8OIu4MsvPex4g0p2bAXLgZYxWuniJ27KOu6VRx3OmBU4Te
	YuGw3I+rtWddXfpfI+od0nBITgWFB9Llyfsosa0lmmf7wvz6WDqWNX4+pp5E5wTVLJk7YANPH4g
	zTtB+L6uvQTIjCXbT19j3RRgyGSKuNcb1haif9MvdSP7UHkN76jPxopg5m+1xCgRuuQl6pT7DQ+
	xEYhod8OFfSEHQpYSXZH426+zAahJtqaN1wSmUcl1XtXG3yLat5IskuTwxUX5cvpmEke00E+yKk
	sN1l6pUNqT7mqg==
X-Received: by 2002:a05:6a00:2d12:b0:882:e366:d99f with SMTP id d2e1a72fcca58-8a089d871famr1118755b3a.51.1792571501524;
        Wed, 21 Oct 2026 01:31:41 -0700 (PDT)
Received: from intel.company.local ([122.11.210.25])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8a0895e273bsm600653b3a.41.2026.10.21.01.31.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Oct 2026 01:31:39 -0700 (PDT)
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
Subject: [PATCH v9 5/8] memblock: introduce MEMBLOCK_NODUMP flag
Date: Wed, 21 Oct 2026 16:30:08 +0800
Message-ID: <20261021083011.2170525-6-chenwandun1@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261021083011.2170525-1-chenwandun1@gmail.com>
References: <20261021083011.2170525-1-chenwandun1@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: C6856160002
X-Stat-Signature: moj6kyzmrs8mqiooki858gkn4xe3ifus
X-Rspamd-Server: rspam06
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1792571502-820154
X-HE-Meta: U2FsdGVkX19DIYgsQHgLEhLe3teF1Hug4BgByim0zw4pj4N3Vyg70eQtItj6canavhJtPkAvbjYkJwCenisHcGKY/ckP6AazrHu5TxoA+HZ/6QG+xTeuqooRnNeJD/ufTijPfHohGRMwkTs0VlEyH0TGRxg206uDF9WOmu+19K5GLP78Bv2J4Uy5EvijoyuJk5UYtmPy723Uw3KHFVTVHFrgtnOIRsSQ0y6FMEHrHPUi2axls+Bz3+yrqDWXrvzE/bnjsQSKcWORnwAkSi8949cGg7BbIn3MQ/XoPcIh2wm16AIa8DMJdj1e+qsLOlmOYXSsqorG9zGXhnzU9BptlO6nQc50fSYDZjf9rqfCyLtl6zH39pv25ethuJS8gCPvoxBINXLSvE22Esx9JgYUZ2c3a54RqLqwSz8rcHhRzJ7IFPtqrXEpg+nQ389UjjQ5wHlyzNQa7CIWmn6zuZ4zlArQtIJctN1TJVDgDLd9TUXWASbGmKDft52PxV0a5kGtkOMRkgUGv2odRE8jJeW3oc57+3nejIvLpvkrcnnfJbpCh+UEk/jj++mLO0QeQsDc0Ufvwb1NoqnrkJ1YTeAraBnBteUQU1dwzaivmHYqMrfRBAEPe41ET+HEyPFF2Afm2+kv0jVDwjP3FL0L6A79n8FQZJRdhFskdLkblhLj26CVFYwXfN2gNwZg3Tnlf8K3Qp0ZRRzULcAhOugk3nRuWHI7vsIP460nSwEgnwQekiFAJS4HeHPyRIKbN+NW7svtDOkgt1i0uweXHUxkoeOlqYWhF9c1r3yyipileCCYhu+Zsxns+Lkjih0NgQNLU+5ZCDCkx8fTVlTkuehslKzuVU8SSR19V47bPov004Tbf5PTfwi98b8fgVJ+tyoU7OxtNLKtkhkS+HqcX3pkbSXd+eRInWJ9UCdhvUzxQxyvXgym5RBKwtb3+59XcH2umvVGggRSWXJ3IQCXPNe2iVT
 JjoQVbTk
 SJbF/AQdH3XrVEyGumzyPP1/0JBzN+8m3WWUfbC/wF11X7C8YA9O0BUphR5AYUBU3q7fbnUNPYLYUHGRk//d0jpGrVl+eFRHMQHkLi7TXNIoligCebG/LiabJ0LAlXSMMM8SgsZTowXHs1ka78dhbdvwmQLxcEFD+0fiC5tD53eKuvR73MKFbsJTnZ9tGLqmzhYWKy3nKUhFtszxYruK7LszAbW7/us1tQ5ywpN2r2Kxa+J70FbVoSuJqZI758bvlWhVpjBK76O/yasswPv3fgbrLs7a+mtx53VdHfb7kqEmTMPoyZHf1etElas4Q/w8MudyRSvM+z08k1RpKsybt1zGp7rb3LW4a5K2GuyGQvX0YlEPpBkZf76F4SeAg0RHSth1l78AlRmQk5x1WCEsU4BExMzliTOGN5sQvTLY+gUtiRsQhVtytAj4mD2MntXEqMrREJ/X0Y5+kEd8gS/oBLrm4Q979SMPrMonAGExv8IS0PI98jqnfdxp7iQENgw4DIivtn9L8Lrf1r+OOt5yS/V/XWpJHuLtUu3mqv+aZ8z+OE22/lDfaI78QT9dAP8sfZrfOIC0ga8lZLLvKHdFUeYzyvCHnsYxfJEeTlaUWcCTwp9pnv11DeccaQ/SPYck7lxeK
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

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
index 40e6e0aa2f8d..67dbcfda6f49 100644
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
index a450092a80fb..ab1432241432 100644
--- a/mm/memblock.c
+++ b/mm/memblock.c
@@ -1221,6 +1221,21 @@ __init int memblock_clear_kho_noprsrv(phys_addr_t base, phys_addr_t size)
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
@@ -2854,6 +2869,7 @@ static const char * const flagname[] = {
 	[ilog2(MEMBLOCK_RSRV_KERN)] = "RSV_KERN",
 	[ilog2(MEMBLOCK_KHO_NOPRSRV)] = "KHO_NOPRSRV",
 	[ilog2(MEMBLOCK_RSRV_HUGETLB)] = "RSV_HUGETLB",
+	[ilog2(MEMBLOCK_NODUMP)] = "NODUMP",
 };
 
 static int memblock_debug_show(struct seq_file *m, void *private)
-- 
2.43.0


