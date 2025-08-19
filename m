Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 85C63CA0EEB
	for <linux-mm@archiver.kernel.org>; Tue, 19 Aug 2025 13:44:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 284688E003A; Tue, 19 Aug 2025 09:44:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 234658E0007; Tue, 19 Aug 2025 09:44:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 125008E003A; Tue, 19 Aug 2025 09:44:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id F2C218E0007
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 09:44:23 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 2F7A41407B5
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 13:44:23 +0000 (UTC)
X-FDA: 83793626406.05.BEA7020
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf16.hostedemail.com (Postfix) with ESMTP id 5956218000E
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 13:44:21 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=XdC7SYt+;
	spf=pass (imf16.hostedemail.com: domain of npache@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755611061; a=rsa-sha256;
	cv=none;
	b=ghdtGId0Sja7QiwLdbJ7yAv83quaUtWkPx2p2/tuWIGmPwsW2ffxfqHOR7Ycd2gmOO9SYA
	wvB9w/Tn/4VvcQVriIQbj8G1O5nOzwIlX58mUJ4zFjInLFHWHGY2grK2KzfQpTOFmdBiBJ
	k3d0sEEqB4DItMkzauuJkLlvPOJfUWQ=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=XdC7SYt+;
	spf=pass (imf16.hostedemail.com: domain of npache@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755611061;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UxQsevBiJ70Rw00mZJVyjG8jNrue1O6FFG6Ma5YZCUg=;
	b=adRb9phucHqjk5f/752jZGNuqe83A64xqpUkIpgOEssG7AwlV4v1Mud0/rLqV0BUoNpNVc
	0yfu+bGOuE0B8lgLMtzMpr8jqWOzMvs+xFnrBXYMMkXJtv9eg+0SYIdhZt3ptFIIVGnvME
	HreDvJ4qIC63VWd93Cw0cRWI+vlh73U=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1755611060;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=UxQsevBiJ70Rw00mZJVyjG8jNrue1O6FFG6Ma5YZCUg=;
	b=XdC7SYt+EnvOMEkjHS8FgupOYhn3KM47F155+IlY52/Nre2MzePOfqQaDInFVz7R7MWgvB
	JpdjoIzq1HlMLjghT6PY25LnnfNcT021xg3Zq7dXORiDtydwH2hiZ5N59jtm6cOkr3eCkg
	1i28zvI5ZqBOokudgJX1oznayBbCfqc=
Received: from mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-160-Tgq5OxZFNF6PrFs2YTge4A-1; Tue,
 19 Aug 2025 09:44:16 -0400
X-MC-Unique: Tgq5OxZFNF6PrFs2YTge4A-1
X-Mimecast-MFC-AGG-ID: Tgq5OxZFNF6PrFs2YTge4A_1755611052
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 978DA1955BD9;
	Tue, 19 Aug 2025 13:44:11 +0000 (UTC)
Received: from h1.redhat.com (unknown [10.22.64.137])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id BF58419560AB;
	Tue, 19 Aug 2025 13:43:52 +0000 (UTC)
From: Nico Pache <npache@redhat.com>
To: linux-mm@kvack.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org
Cc: david@redhat.com,
	ziy@nvidia.com,
	baolin.wang@linux.alibaba.com,
	lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	corbet@lwn.net,
	rostedt@goodmis.org,
	mhiramat@kernel.org,
	mathieu.desnoyers@efficios.com,
	akpm@linux-foundation.org,
	baohua@kernel.org,
	willy@infradead.org,
	peterx@redhat.com,
	wangkefeng.wang@huawei.com,
	usamaarif642@gmail.com,
	sunnanyong@huawei.com,
	vishal.moola@gmail.com,
	thomas.hellstrom@linux.intel.com,
	yang@os.amperecomputing.com,
	kirill.shutemov@linux.intel.com,
	aarcange@redhat.com,
	raquini@redhat.com,
	anshuman.khandual@arm.com,
	catalin.marinas@arm.com,
	tiwai@suse.de,
	will@kernel.org,
	dave.hansen@linux.intel.com,
	jack@suse.cz,
	cl@gentwo.org,
	jglisse@google.com,
	surenb@google.com,
	zokeefe@google.com,
	hannes@cmpxchg.org,
	rientjes@google.com,
	mhocko@suse.com,
	rdunlap@infradead.org,
	hughd@google.com
Subject: [PATCH v10 04/13] khugepaged: generalize alloc_charge_folio()
Date: Tue, 19 Aug 2025 07:41:56 -0600
Message-ID: <20250819134205.622806-5-npache@redhat.com>
In-Reply-To: <20250819134205.622806-1-npache@redhat.com>
References: <20250819134205.622806-1-npache@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 5956218000E
X-Stat-Signature: 17fe1o6jrakn87dms9bsc1hjdyoqmsma
X-Rspam-User: 
X-HE-Tag: 1755611061-35956
X-HE-Meta: U2FsdGVkX18SbEw4Id1y6aXIz0jCfwdCYu39ffBzhK4JJd3QRugCDQfg05V7NxnCZWfDOgGvN762EbobAQsKspg/TCWkxUr0S5IcC6RbjYkwB0MYoObScHkn+rah1Ea3lc58h1P9IZgLESmchM4NnHrZHV3zmkgCRYj08Ca4HILWmsyCOxpyYZvQs1u4uUz2WcnWnCCswvE5t9V9Ruikd1E8rcIhJtoDFugPP+VmWGGrKOlQCqq6dk4IpuJnK1yeUeLaxNz8MR05WqzODLnlh3bIOJ+0heB2H5yOCvISicmGlcRxvb4/i2lS9n4yGSHuq8rvxyfT51y+S6fYyzKuS4mJvSAysL5k6dxkCIFWssEW0ki/Mm8UvM3427VS4DvRRPZ9HOqeVsJ9NvincVpuQXSOklPbMo//taPOmaLzMhNe3OJ30REqbbcArLzM72pxXJ/YRlYWohv6BO8FtIMQi7jnRy48Li9NEQ1oLJcWFYfUfeUgnPiL5bEtm+ApfthaQ2lJ3/RrZS6uBA60vdI007xgQjgVP5XWixAbuU6bokZ7GVLKiPvTMqHtt6OQVxZBycHc7B3CIE8F9AlDp4Cl1TFwJQ6nB/ccF44kUkBKTgHwcsk5hW4ZhTGK2pMcqMBkLz8PvCU8mJ2XFzAmY6w6ud5oq5Mca7cie8eizw72rg9quJHV4z+9k1g0QnGOJuFRepnhymS10J2Mbrk1hPtQdke64l8wPiGqfhHNe/ZUbaAByYAF9IazquyViPtaSf+dperUAvLE6GOMI3fqVdaPi6dCVD0jKj2sRSeDODzlbnM42FJ0wZ6/fr8LO/wfC9sVsNJ2qBqZd4MGq5wiWdxEET4WYFL+y84KS1CDvtvi2efSFoiUQp4+DDtt+tSz22fMYXYI7YA1hY916D2zPhmJYXOHyY6WMXtmg4o/sCX4mYPGiW/aFFMLYGbdqldIB37RRgBa6okNzqEDLa5z3k0
 DY6I3PLn
 +ZLe+A0xvEvoMgNfu1THwInnTA78ttoljYQVeGd6KmgPcFjfblah7uy4GRc+LmNrTXArI3K7+d6p0VgCI1yl/KIG0Xl9cQ43e2P/c1bYBA8RBh/f1aFotNRYs/jsaRkD7kY7sh3wU+P1s4f/UIBgjJ6U2746GIw9vXYaQtWEr4Lza250WTUPMHG6bKm3xWEAkM2MZ9jYBXT56qwf4H+Uj/IHEfdyNjSCpj8iPESblywW1OlKmoYY+XNLKWqjf+TgXR9VLSafLoSnq06GBntnVE8wT9UNgfzmZuaWG+VGVFmDaWfd22cbhhqFQiu+9vgsdy4NgqeATFXHXAi9BRChsGXkZkxpbdQWdcu4jOOq28aeBBCkXvR4nh/ee2uWPMoFDid57OxVIGEZEpG1xDqG/Um1Ea1/R911jHLqJ3Q1IVuNGIsWTogRVeOVhoT4RZL62qiFOUldt8AWJC06c87n+TewCd+QPUs26owvKoSNyVpQW4XD7aDKoXItw6IzvRWp+bF/IsuM1yMvhv9Tk7LWapyCiXw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Dev Jain <dev.jain@arm.com>

Pass order to alloc_charge_folio() and update mTHP statistics.

Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Acked-by: David Hildenbrand <david@redhat.com>
Co-developed-by: Nico Pache <npache@redhat.com>
Signed-off-by: Nico Pache <npache@redhat.com>
Signed-off-by: Dev Jain <dev.jain@arm.com>
---
 Documentation/admin-guide/mm/transhuge.rst |  8 ++++++++
 include/linux/huge_mm.h                    |  2 ++
 mm/huge_memory.c                           |  4 ++++
 mm/khugepaged.c                            | 17 +++++++++++------
 4 files changed, 25 insertions(+), 6 deletions(-)

diff --git a/Documentation/admin-guide/mm/transhuge.rst b/Documentation/admin-guide/mm/transhuge.rst
index a16a04841b96..7ccb93e22852 100644
--- a/Documentation/admin-guide/mm/transhuge.rst
+++ b/Documentation/admin-guide/mm/transhuge.rst
@@ -630,6 +630,14 @@ anon_fault_fallback_charge
 	instead falls back to using huge pages with lower orders or
 	small pages even though the allocation was successful.
 
+collapse_alloc
+	is incremented every time a huge page is successfully allocated for a
+	khugepaged collapse.
+
+collapse_alloc_failed
+	is incremented every time a huge page allocation fails during a
+	khugepaged collapse.
+
 zswpout
 	is incremented every time a huge page is swapped out to zswap in one
 	piece without splitting.
diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
index 1ac0d06fb3c1..4ada5d1f7297 100644
--- a/include/linux/huge_mm.h
+++ b/include/linux/huge_mm.h
@@ -128,6 +128,8 @@ enum mthp_stat_item {
 	MTHP_STAT_ANON_FAULT_ALLOC,
 	MTHP_STAT_ANON_FAULT_FALLBACK,
 	MTHP_STAT_ANON_FAULT_FALLBACK_CHARGE,
+	MTHP_STAT_COLLAPSE_ALLOC,
+	MTHP_STAT_COLLAPSE_ALLOC_FAILED,
 	MTHP_STAT_ZSWPOUT,
 	MTHP_STAT_SWPIN,
 	MTHP_STAT_SWPIN_FALLBACK,
diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index aac5f0a2cb54..20d005c2c61f 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -621,6 +621,8 @@ static struct kobj_attribute _name##_attr = __ATTR_RO(_name)
 DEFINE_MTHP_STAT_ATTR(anon_fault_alloc, MTHP_STAT_ANON_FAULT_ALLOC);
 DEFINE_MTHP_STAT_ATTR(anon_fault_fallback, MTHP_STAT_ANON_FAULT_FALLBACK);
 DEFINE_MTHP_STAT_ATTR(anon_fault_fallback_charge, MTHP_STAT_ANON_FAULT_FALLBACK_CHARGE);
+DEFINE_MTHP_STAT_ATTR(collapse_alloc, MTHP_STAT_COLLAPSE_ALLOC);
+DEFINE_MTHP_STAT_ATTR(collapse_alloc_failed, MTHP_STAT_COLLAPSE_ALLOC_FAILED);
 DEFINE_MTHP_STAT_ATTR(zswpout, MTHP_STAT_ZSWPOUT);
 DEFINE_MTHP_STAT_ATTR(swpin, MTHP_STAT_SWPIN);
 DEFINE_MTHP_STAT_ATTR(swpin_fallback, MTHP_STAT_SWPIN_FALLBACK);
@@ -686,6 +688,8 @@ static struct attribute *any_stats_attrs[] = {
 #endif
 	&split_attr.attr,
 	&split_failed_attr.attr,
+	&collapse_alloc_attr.attr,
+	&collapse_alloc_failed_attr.attr,
 	NULL,
 };
 
diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index 2d192ec961d2..77e0d8ee59a0 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -1079,21 +1079,26 @@ static int __collapse_huge_page_swapin(struct mm_struct *mm,
 }
 
 static int alloc_charge_folio(struct folio **foliop, struct mm_struct *mm,
-			      struct collapse_control *cc)
+			      struct collapse_control *cc, unsigned int order)
 {
 	gfp_t gfp = (cc->is_khugepaged ? alloc_hugepage_khugepaged_gfpmask() :
 		     GFP_TRANSHUGE);
 	int node = collapse_find_target_node(cc);
 	struct folio *folio;
 
-	folio = __folio_alloc(gfp, HPAGE_PMD_ORDER, node, &cc->alloc_nmask);
+	folio = __folio_alloc(gfp, order, node, &cc->alloc_nmask);
 	if (!folio) {
 		*foliop = NULL;
-		count_vm_event(THP_COLLAPSE_ALLOC_FAILED);
+		if (order == HPAGE_PMD_ORDER)
+			count_vm_event(THP_COLLAPSE_ALLOC_FAILED);
+		count_mthp_stat(order, MTHP_STAT_COLLAPSE_ALLOC_FAILED);
 		return SCAN_ALLOC_HUGE_PAGE_FAIL;
 	}
 
-	count_vm_event(THP_COLLAPSE_ALLOC);
+	if (order == HPAGE_PMD_ORDER)
+		count_vm_event(THP_COLLAPSE_ALLOC);
+	count_mthp_stat(order, MTHP_STAT_COLLAPSE_ALLOC);
+
 	if (unlikely(mem_cgroup_charge(folio, mm, gfp))) {
 		folio_put(folio);
 		*foliop = NULL;
@@ -1130,7 +1135,7 @@ static int collapse_huge_page(struct mm_struct *mm, unsigned long address,
 	 */
 	mmap_read_unlock(mm);
 
-	result = alloc_charge_folio(&folio, mm, cc);
+	result = alloc_charge_folio(&folio, mm, cc, HPAGE_PMD_ORDER);
 	if (result != SCAN_SUCCEED)
 		goto out_nolock;
 
@@ -1863,7 +1868,7 @@ static int collapse_file(struct mm_struct *mm, unsigned long addr,
 	VM_BUG_ON(!IS_ENABLED(CONFIG_READ_ONLY_THP_FOR_FS) && !is_shmem);
 	VM_BUG_ON(start & (HPAGE_PMD_NR - 1));
 
-	result = alloc_charge_folio(&new_folio, mm, cc);
+	result = alloc_charge_folio(&new_folio, mm, cc, HPAGE_PMD_ORDER);
 	if (result != SCAN_SUCCEED)
 		goto out;
 
-- 
2.50.1


