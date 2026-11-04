Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F2E12606A32F
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 02:35:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=bytedance.com header.i=@bytedance.com header.a=rsa-sha256 header.s=google header.b=XFbis7xr
Received: by kanga.kvack.org (Postfix)
	id 6F6CC6B05B3; Tue,  3 Nov 2026 21:35:50 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6CC826B05B5; Tue,  3 Nov 2026 21:35:50 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 56A2C6B05B3; Tue,  3 Nov 2026 21:35:50 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 172836B05B3
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 21:35:50 -0500 (EST)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 73CB6C062A
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 02:35:49 +0000 (UTC)
X-FDA: 85395871218.11.773587B
Received: from mail-pf1-f179.google.com (mail-pf1-f179.google.com [209.85.210.179])
	by imf02.hostedemail.com (Postfix) with ESMTP id 70C1E80002
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 02:35:47 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=XFbis7xr;
	spf=pass (imf02.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.210.179 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793759747;
	b=NFT4VHGvZ4Y8fcU9wPZ/iUX/omqvXv65Kz8xbIl0RGF9f2kdTrnXp3jHtf7/Ji8O9kw8F/
	RBfLZYy5k5UA1tQ53xSllapaTv8g7XW8Fg47fvBCLwKR2Yi0FA9f1Lv8UdkvCuE0VFWEQR
	J7cv4SwAJletkkhVmWJbBjxviUttpzo=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=XFbis7xr;
	spf=pass (imf02.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.210.179 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793759747;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lTMXZFe5gyQw5mYi0ReIkJiMtVGiDJG8MERdlHxMBwM=;
	b=IQZbIvx1M+N2T47TfbCwxD7J3Lfz+z87inT70yO0BIL3PK+qjpJYJRNO+RLUgZAhIpN6Tn
	V1qe45ak16uOrBlb2vwzNzWeGsz+niwW4+eZSFiF3hjakLx/Dg58EOspRDvHVtHrCkYOY2
	Q3XsXQZB17HEKpJrKdAejYGsu2j2kJI=
Received: by mail-pf1-f179.google.com with SMTP id d2e1a72fcca58-89ff475a152so105729b3a.3
        for <linux-mm@kvack.org>; Tue, 03 Nov 2026 18:35:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1793759746; x=1794364546; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=lTMXZFe5gyQw5mYi0ReIkJiMtVGiDJG8MERdlHxMBwM=;
        b=XFbis7xr9/8MInXaKJBWbf9ReHHXoR+v52FHfCVDntHq2KOAPhFec3z6Qyx+tkPNAa
         boDEaQcL2MEHt0wN2cHckbT9VP6RFKL+2uUEg/K6cb7WLDYzsrxB9p1vLPAqon4kEqXI
         T1iquEp64KG8LmJuX+SAqqH4qepyIyAhEpRuT5KoKm6wCbSnCMd1jIgwdVFwQ09H+gfn
         awkQk5EINgkJM0b9viJrZ9sajBTnFKv6Y+8PBX4RuirOci4DMiOJq7D9FGSRtBwuO1Ua
         yWBvZaSGZ5ZqiZLtxhERFyk/dBnbYZ2fnPzDGRRxsKdAzBRoo+W/GeLHk/pL8gnDauKx
         hJLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793759746; x=1794364546;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=lTMXZFe5gyQw5mYi0ReIkJiMtVGiDJG8MERdlHxMBwM=;
        b=rbOmNatU5fOJmeFbc2uGPikNx1WJ7vly4C1nN4pdVh8m9d206x3T1Os81eAzIjyMpQ
         Pa/V15wLqTHaBp+CRkEJHYF4AJdDiIHiFWMR8WgAcde5MlpDYWtuLZlV3Brd/oRGpA1l
         c1gT6YeQEFwZE8IV0V5pfk5P9EoxrpQx9FJBVTFQ8T7obDLd8uWFYxNheAEXzExqDsUI
         rocgC3XlKRSoeHMOQlajESM7ybbXLKitsuCKedsXUxMQKqFsRYEnLtPDKlBXUDi89bNR
         GYfH2ukWK5wMlKJBzTjwBFnEDKzQJY2wdOEFdUKBti8NUxigENK568dD+MBhDrruTYoW
         tiQg==
X-Forwarded-Encrypted: i=1; AKwUvBxfOcFvpn68YAGugTnKvV/WfGohQLzObUrJOUWrF+etuNYIA2s5Gv6jA2DFsuDzGTTVdPPtmCiBvQ==@kvack.org
X-Gm-Message-State: APuU4Z8SyZhIAcSv2MmSet51AKyZyxULbT+xfL4nsr74zReUtLEGShCl
	5GfLw/1RXbr3Mtnnw8n6ca7d8T4cnpAfG642L0wepx7ul3JhUrF0m7q1BrH8x+NuF1A=
X-Gm-Gg: AYBFou37IwybYHKI05+wX9BiGKs3xIWJCjuYfdBWZ5H5J+070dzaKxfnNamc/UDrztZ
	IpbJtjR6wyIR5ePv2TEIf4NVCbvsFX6P/4aL2k3GF0WVZpPN642KW7wtWrriuo9glSGcK4PXMzs
	3EOsl0HTlsfijodcIOp13YJ5KXKyvwQ1MnROV21PvH8rFaIg5M4RIdGb5x3oxGtzZcMienbzBFD
	q7YZ2SGppPFc7F8Mkl9btNDaIQT2QZrMFKszCNNC27hzU4EvFubfw+YO2SVHk04KX1ksanS2Dla
	3ATp6SLZqrgvWz21kk5LlrYAomym8ogX5onZGa0V3cnptbF5j6sZx8EF18PagRn5bk8V/+OkY7v
	3NJxCG6DjRStcU/azYquoJRbPpYp8KaqJsWOMR0pMRCeM+uH8m83trLKWPwTNkfWpzjD4jdVYD/
	mfsCXWc+XwNJuYgtk5UrwWlxdokiAnLfF3/GjSg56nLS0kGNwxQCPoInbsPDB4knzKKcoCtTrcq
	WM8kEU+U2BZiRQBQRCc9jAgG3nj6aXWHZdNhCucF+j725fv9xsLPglnARlL13sC4kk6N3RxP038
	oJqlD2dlrSW0q8QtvPUKH9/qmfW59l50S9I/t2zTxlDp236zOQ==
X-Received: by 2002:a05:6a00:c24a:20b0:8a0:3ed7:93a2 with SMTP id d2e1a72fcca58-8aeaf9be0fcmr3360573b3a.52.1793759745870;
        Tue, 03 Nov 2026 18:35:45 -0800 (PST)
Received: from n232-176-004.byted.org ([36.110.163.99])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8b09bc3d1f2sm240815b3a.50.2026.11.03.18.35.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Nov 2026 18:35:44 -0800 (PST)
From: Muchun Song <songmuchun@bytedance.com>
To: Oscar Salvador <osalvador@suse.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	Mike Rapoport <rppt@kernel.org>
Cc: Qi Zheng <qi.zheng@linux.dev>,
	Lance Yang <lance.yang@linux.dev>,
	James Houghton <jthoughton@google.com>,
	David Hildenbrand <david@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Muchun Song <songmuchun@bytedance.com>
Subject: [PATCH v3 02/12] mm: hugetlb_vmemmap: unify VMEMMAP_{SPLIT,REMAP}_NO_TLB_FLUSH
Date: Wed,  4 Nov 2026 10:35:00 +0800
Message-ID: <20261104023510.260766-3-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20261104023510.260766-1-songmuchun@bytedance.com>
References: <20261104023510.260766-1-songmuchun@bytedance.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: bixsxgszbsbuhycocadr38aw81b17fid
X-Rspamd-Queue-Id: 70C1E80002
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793759747-66994
X-HE-Meta: U2FsdGVkX1+bokyUFXViv53gkpohc0OXIU4sTUeZHwysEKowflfzZd4nPk+rOesdAi2mmpUymMYHxxPnB1dxnVRAizwwWbqOEXeOF5x/ghAfnObDGLfq0QbYD449wPGQIS8VMjCAJDbwsVqOlUKUj1o/yLg5xVF/Ut4WrHEUz7YmUKv5fHYuDtl+Wa33EqZUgk/bshv8DcUuyqlJobK+4P6jKq567HnTqcAifnKHH4K0WvICCg7QXKieJJt7VSCvhjqfCDqsWWjo3We2LA0xXaqZZggzUiqS77tKf1X2XlIDvZqVMUF4vJjKTNLNE94hcKO2gkUH1KhtMCI2tEb1t6hpf6hg4nc9rIlNEFh3gQCHyC7XSbs51rsFOyXyRapnseU1qqPEvY0eKOXVtzQ6cFMTey/P5Pj4xuye0PeV89HWgNsPCFcA5MUu56/XeMLWBrs5m4sWxGoBTxuG+4JG6HKhmNsFAs7n4c9dt4ufVM5BKVb39KTO9ZdVG28VQwPiJkmyZaZ9/HS+V9+ubnap/vNIlGouFGAwas0zghWt2PySaY3dVgfE2GXVsUJXbC3sLGdG0xRm1n7VA/XBlV5SmRWX/YL6B4TxyWmZdCzw9lhDIUXS2IGbUtO17fPSx3Wt3eOoAmwoaWenAx8dwiaPc/B1OSoE/5wDVvzpHoGJuTQxtwe5VRbyyzm8oSYBY/2tytcGNwCrxxnJ+9DFuXIFY7PfqdkX4QoLJstBc0WIb0V+bCc5A8C/TEVQawLsNmy0bLZl5CZDj9PGXkKH1yaSdD2FfTjnWkntKpo6jrYeGWhnbsPj4TuiNniPeRiPh6qvUABTfPFG2B7Lv71rOPQDEeyzzVFrhnYuWEaxmlr1smi/J6h795b7JMxUo6YpQw263g8EhBu+BqP1PNvD9VNIfjD5OGCmmLdpUYjLU+ygSil26+ohdddQTJCM91f+7N4rNXK+j0LKi5zAPKRb/hW
 40PKO+gt
 NNbloj0QAuhK/zlodb3G4Ov4G85n8KwUc75VL02tcpL+eNbB0UVil08J/HyfEQMOU0hFdAljtPcC5WcsdOBLEhliTwUTgT2QKWEcUjmg1atEFRil3s4wcqtTrOijYzr73Iu1P7mjTPOrpxinQi0YKxdkz4N/Da4b81U8AoYYH/nzevIyJvqBxPRj+Avx2b82xm/OVux4C1p9guIO7GDifrcs89Sl/GHr72+7E81goqPdMtpA+5up2sPEe3/mLbBMVIl5Oeoqc9M+ySNwSeu5PwnpLUWHe57a3dQSxD2hKsG1zzDymGYa/qPZER4BwQ0cb/cpikEB3jRslChsvRro6iYgXxsRJLeb2wmRL8CiqiOY3axE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

VMEMMAP_SPLIT_NO_TLB_FLUSH and VMEMMAP_REMAP_NO_TLB_FLUSH do not
describe fully independent choices. A split-only walk can defer the
PMD-split flush to a later global flush, and a remap-only walk can
defer the final remap flush. However, when a PMD split is followed
by PTE remapping, the split flush must happen before the PTEs are
changed, because stale large-page translations must not overlap with
new small-page translations that map different physical pages.

Replace the two flags with a single VMEMMAP_DEFER_TLB_FLUSH flag. The
new name reflects that only safely batchable flushes are deferred. Keep
split-only walks able to defer the flush, but force the split flush
whenever a remap_pte callback is present. Callers that batch HVO work
can still defer the final remap flush and issue their own global flush.

Current callers keep the same flushing behavior.

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Reviewed-by: Lance Yang <lance.yang@linux.dev>
Reviewed-by: Qi Zheng <qi.zheng@linux.dev>
---
v2:
- Rename the unified flag to VMEMMAP_DEFER_TLB_FLUSH and update its
  comment (suggested by Qi Zheng)
- Update the commit message for the new flag name
- Collect Reviewed-by from Lance Yang and Qi Zheng
---
 mm/hugetlb_vmemmap.c | 23 +++++++++++++----------
 1 file changed, 13 insertions(+), 10 deletions(-)

diff --git a/mm/hugetlb_vmemmap.c b/mm/hugetlb_vmemmap.c
index 4b73d6ec8dce..63e899cfaac3 100644
--- a/mm/hugetlb_vmemmap.c
+++ b/mm/hugetlb_vmemmap.c
@@ -42,10 +42,8 @@ struct vmemmap_remap_walk {
 	struct list_head	*vmemmap_pages;
 
 
-/* Skip the TLB flush when we split the PMD */
-#define VMEMMAP_SPLIT_NO_TLB_FLUSH	BIT(0)
-/* Skip the TLB flush when we remap the PTE */
-#define VMEMMAP_REMAP_NO_TLB_FLUSH	BIT(1)
+/* Defer safely batchable TLB flushes to the caller. */
+#define VMEMMAP_DEFER_TLB_FLUSH	BIT(0)
 	unsigned long		flags;
 };
 
@@ -85,7 +83,12 @@ static int vmemmap_split_pmd(pmd_t *pmd, struct page *head, unsigned long start,
 		/* Make pte visible before pmd. See comment in pmd_install(). */
 		smp_wmb();
 		pmd_populate_kernel(&init_mm, pmd, pgtable);
-		if (!(walk->flags & VMEMMAP_SPLIT_NO_TLB_FLUSH))
+		/*
+		 * Modern MMUs allow overlapping TLB entries with different mapping
+		 * granularities only if they map the same physical address. So
+		 * remapping must not proceed without first flushing the TLB.
+		 */
+		if (walk->remap_pte || !(walk->flags & VMEMMAP_DEFER_TLB_FLUSH))
 			flush_tlb_kernel_range(start, start + PMD_SIZE);
 	} else {
 		pte_free_kernel(&init_mm, pgtable);
@@ -166,7 +169,7 @@ static int vmemmap_remap_range(unsigned long start, unsigned long end,
 	if (ret)
 		return ret;
 
-	if (walk->remap_pte && !(walk->flags & VMEMMAP_REMAP_NO_TLB_FLUSH))
+	if (walk->remap_pte && !(walk->flags & VMEMMAP_DEFER_TLB_FLUSH))
 		flush_tlb_kernel_range(start, end);
 
 	return 0;
@@ -274,7 +277,7 @@ static int vmemmap_remap_split(unsigned long start, unsigned long end)
 {
 	struct vmemmap_remap_walk walk = {
 		.remap_pte	= NULL,
-		.flags		= VMEMMAP_SPLIT_NO_TLB_FLUSH,
+		.flags		= VMEMMAP_DEFER_TLB_FLUSH,
 	};
 
 	return vmemmap_remap_range(start, end, &walk);
@@ -458,7 +461,7 @@ long hugetlb_vmemmap_restore_folios(const struct hstate *h,
 	struct folio *folio, *t_folio;
 	long restored = 0;
 	long ret = 0;
-	unsigned long flags = VMEMMAP_REMAP_NO_TLB_FLUSH;
+	unsigned long flags = VMEMMAP_DEFER_TLB_FLUSH;
 
 	list_for_each_entry_safe(folio, t_folio, folio_list, lru) {
 		if (folio_test_hugetlb_vmemmap_optimized(folio)) {
@@ -516,7 +519,7 @@ static int __hugetlb_vmemmap_optimize_folio(const struct hstate *h,
 
 	/*
 	 * Very Subtle
-	 * If VMEMMAP_REMAP_NO_TLB_FLUSH is set, TLB flushing is not performed
+	 * If VMEMMAP_DEFER_TLB_FLUSH is set, TLB flushing is not performed
 	 * immediately after remapping.  As a result, subsequent accesses
 	 * and modifications to struct pages associated with the hugetlb
 	 * page could be to the OLD struct pages.  Set the vmemmap optimized
@@ -595,7 +598,7 @@ void hugetlb_vmemmap_optimize_folios(struct hstate *h, struct list_head *folio_l
 	struct folio *folio;
 	unsigned long nr_to_optimize = 0;
 	LIST_HEAD(vmemmap_pages);
-	unsigned long flags = VMEMMAP_REMAP_NO_TLB_FLUSH;
+	unsigned long flags = VMEMMAP_DEFER_TLB_FLUSH;
 
 	if (list_empty(folio_list))
 		return;
-- 
2.54.0


