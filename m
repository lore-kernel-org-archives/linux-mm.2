Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D6E23CD6E7D
	for <linux-mm@archiver.kernel.org>; Fri,  5 Jun 2026 16:14:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4BD4D6B008C; Fri,  5 Jun 2026 12:14:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 494E36B0093; Fri,  5 Jun 2026 12:14:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3AA736B0096; Fri,  5 Jun 2026 12:14:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 301806B008C
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 12:14:35 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id D23A31C095B
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 16:14:34 +0000 (UTC)
X-FDA: 84846356868.19.6538C3A
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf23.hostedemail.com (Postfix) with ESMTP id C7E48140006
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 16:14:32 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=dkOUdR2O;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf23.hostedemail.com: domain of npache@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=npache@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780676072;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xlR8fhzh8q63CKgSojQvD7fR1bfQEPbHYVxE9z/YBVA=;
	b=XBodt07WcLB5yEbyugIraZj1KGf+ikaEuIbX6MxNC/klm2yQClRbFOtLPo1BzMxbdyPvPX
	Kd1mtKTpOQRhvCp4i+DVgeQkFn0OiZ3wFcYr89h2khX3D7pW7pJBlruKaRYxnIVQr2GbaT
	/QytAnOuzOFt2rWL9XNR9bpgn9EDK3g=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=dkOUdR2O;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf23.hostedemail.com: domain of npache@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=npache@redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780676072;
	b=ZSCzbUaeKZaikklyKX4O1Gm3AEWw22Z2MkO61QGnolgXSKXrlk0FdXJasNQMW/gZnKcX9P
	0qnEPFeyM5p4h4035qYmj9WidtWJCCmz1oSVbmIU6htOzQNsHIkbLkVrP0izwtFyBmQTxn
	Mkk96ljIPplWrD1AIdE8Bk9qYPhVMlE=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1780676072;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=xlR8fhzh8q63CKgSojQvD7fR1bfQEPbHYVxE9z/YBVA=;
	b=dkOUdR2OlRTA2Q86QWQMFAoUwQ8EC+UnlyKKzU2Oam/4c8RaTSgZcQEcVVknEz8ddV1lly
	6XxC3dp27ANQyxmVhNXbhUN+anjLImKdsTaOsFHURNWfzTsEp5O/0F4h79rJshx3NntMwb
	jDkO/IUGoIphSj+dTUMf2HNnUUscwUM=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-256-kFikBiLrMRq2SejJHU2LoQ-1; Fri,
 05 Jun 2026 12:14:29 -0400
X-MC-Unique: kFikBiLrMRq2SejJHU2LoQ-1
X-Mimecast-MFC-AGG-ID: kFikBiLrMRq2SejJHU2LoQ_1780676064
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 171AA180057E;
	Fri,  5 Jun 2026 16:14:23 +0000 (UTC)
Received: from p1.redhat.com (unknown [10.44.22.9])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 306B1180049F;
	Fri,  5 Jun 2026 16:14:02 +0000 (UTC)
From: Nico Pache <npache@redhat.com>
To: linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-trace-kernel@vger.kernel.org
Cc: aarcange@redhat.com,
	akpm@linux-foundation.org,
	anshuman.khandual@arm.com,
	apopple@nvidia.com,
	baohua@kernel.org,
	baolin.wang@linux.alibaba.com,
	byungchul@sk.com,
	catalin.marinas@arm.com,
	cl@gentwo.org,
	corbet@lwn.net,
	dave.hansen@linux.intel.com,
	david@kernel.org,
	dev.jain@arm.com,
	gourry@gourry.net,
	hannes@cmpxchg.org,
	hughd@google.com,
	jack@suse.cz,
	jackmanb@google.com,
	jannh@google.com,
	jglisse@google.com,
	joshua.hahnjy@gmail.com,
	kas@kernel.org,
	lance.yang@linux.dev,
	liam@infradead.org,
	ljs@kernel.org,
	mathieu.desnoyers@efficios.com,
	matthew.brost@intel.com,
	mhiramat@kernel.org,
	mhocko@suse.com,
	npache@redhat.com,
	peterx@redhat.com,
	pfalcato@suse.de,
	rakie.kim@sk.com,
	raquini@redhat.com,
	rdunlap@infradead.org,
	richard.weiyang@gmail.com,
	rientjes@google.com,
	rostedt@goodmis.org,
	rppt@kernel.org,
	ryan.roberts@arm.com,
	shivankg@amd.com,
	sunnanyong@huawei.com,
	surenb@google.com,
	thomas.hellstrom@linux.intel.com,
	tiwai@suse.de,
	usamaarif642@gmail.com,
	vbabka@suse.cz,
	vishal.moola@gmail.com,
	wangkefeng.wang@huawei.com,
	will@kernel.org,
	willy@infradead.org,
	yang@os.amperecomputing.com,
	ying.huang@linux.alibaba.com,
	ziy@nvidia.com,
	zokeefe@google.com,
	Usama Arif <usama.arif@linux.dev>
Subject: [PATCH mm-unstable v19 02/14] mm/khugepaged: generalize alloc_charge_folio()
Date: Fri,  5 Jun 2026 10:14:09 -0600
Message-ID: <20260605161422.213817-3-npache@redhat.com>
In-Reply-To: <20260605161422.213817-1-npache@redhat.com>
References: <20260605161422.213817-1-npache@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: QGgh-4M7nzpgR0_b2t5wZ4bO7y8-5LoHyVMym1SJ0Ts_1780676064
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: C7E48140006
X-Stat-Signature: mwz8sag844zud7cz5rhnqen96teck5n5
X-HE-Tag: 1780676072-264578
X-HE-Meta: U2FsdGVkX19Qty14ANdetQs6ejDydEvvw540M7BHipg3Ooxbh7lGwc9rQWLkhtHZtyT8xmSocOdentVhdvhbQVzqzLl/fV4ads945hDYnNJacOTVSh6EItKZpeRUnavEKs6G9UGoVvBHgfqJiLpLGjN2wK02kTn81vA/6p12newTdUjiNONrMvUXUFHzTjnV6CMI0jLkG/me5ym7HM/x8MB3562h4WeNenZdihLhl8bidaUwbb2fJi8tuqVl5V/SGE4Hix+x7KDMXk43DxD3y5o6NdTHPlxPNY5IWvp7Q4ZccDweDMPHg/4w40FRUKK9m/MRezljdcyaeAWZig2bACRmfnx/kZ5nv4uSQ0Y+qzwyPXwTbr4HTnF58ijv47RzB0iO4Je2nfkgs5wVcrAxTyRJlLyuNjLDXjU7X62xbb8WY1txDV4jIiqC1qibcH8jCbWZUxTT0x+g+n/0VbeVjcds0tKOfOQdwHeOa7HQFLTBtkE/rns+wYqhZ1DXVmqWzlUVES0gAJI1LeMpWPCggZt1ovxrFIDpzYwQet7glvO+f088YbUa1ZPSREo4Qs+c8PDzTqFlLo0kubvctKTu86YV4qbw3B+davCxuJMO/Rxqy9MdbfXy/2jJ+kgq37QRkTQtgPMyr8mBJnMkptZmgAzv1V9Qa31xAEsfDoNtQAL/mHqxLo1WwQcide4Arce8siP03LCZMvWFGlTp9NiFIqviSygej38yq94XekfnGjoywep4zIc7iASVl8jMhXwPzLfYd8gv5TttuRtleZymtgzk5lgGe54gziSw05AfeLKW2Y30rxwFFf7SgbMqFnwEX2KgDl5LuBGvCbNIfRzp/pxjKygSb13NJCceFK8odjMeI4yJG0kv5cHlbeOgudYDglhr139nyUZXlDowAmrm/3aw1RZhFUbCMx3py1O1ws387Pemkhxnz/Du3B6wNKbZhdg5l3ypdH+xRhJjy2P
 P/ofyORY
 exeSSGy/sxpxfJyvkfK2b2aQM3pF4z1biuqlxbju5jgsvVRBDEPJl5PzUjjTEYD6IHucaY6VHSTHrqXJ0wIVZEGQ7ARqJbsAVCePePxTmzM2URojXUaP++tJfxrLj/e0upl+ySupIF/Mbgqmxk5WcNGH1hjYRVkTw3VyNclM6pnAvVDEWzOvqf9V4US+EgNTiezFMc6HkfDWcjkIUAlSK+zOQqbtnA0zxe0dYEUvH2W+QdTlE4ErbX021yxASOyPTfjICYCEdaA6MJQJ5hK7poHJZPxXga+j3l51A2dBhoFJoxewjG3xZZaOPoVR8LU3osaoLfNa9FN/RI1yFQJfK9T5Wt4PGpkhtxRUwqRZoK/oM059Rt5vPUPBBnwZFfE/p6NZe//cIdBtFpXhmUBMlu3HbvtFJUTjt+VYOT27ffKVJn/ngnqm4e7E2HTR++yGFndC4FQlS0G0OgO6BYmZ4WD5GhQKhA+PUpL06pydEqRdoM5ys7fgCxrrMW21gxu2EXMQXs3r8u3FpijxUEnBUh5a5iORzjrFRvtLeXWVFWP9yLA+1VJBcKTOSgWvy44rQRrNYil+zD3Hme7QukSNjqELqbxsBGhSvTafvNGyE7Fz5zsU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Dev Jain <dev.jain@arm.com>

Pass order to alloc_charge_folio() and update mTHP statistics.

Reviewed-by: Wei Yang <richard.weiyang@gmail.com>
Reviewed-by: Lance Yang <lance.yang@linux.dev>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Reviewed-by: Lorenzo Stoakes <ljs@kernel.org>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Acked-by: Usama Arif <usama.arif@linux.dev>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Dev Jain <dev.jain@arm.com>
Co-developed-by: Nico Pache <npache@redhat.com>
Signed-off-by: Nico Pache <npache@redhat.com>
---
 Documentation/admin-guide/mm/transhuge.rst |  8 ++++++++
 include/linux/huge_mm.h                    |  2 ++
 mm/huge_memory.c                           |  4 ++++
 mm/khugepaged.c                            | 20 +++++++++++++-------
 4 files changed, 27 insertions(+), 7 deletions(-)

diff --git a/Documentation/admin-guide/mm/transhuge.rst b/Documentation/admin-guide/mm/transhuge.rst
index 76f4eb14e262..a74844e01f1e 100644
--- a/Documentation/admin-guide/mm/transhuge.rst
+++ b/Documentation/admin-guide/mm/transhuge.rst
@@ -639,6 +639,14 @@ anon_fault_fallback_charge
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
index 58382e97a66d..443852423790 100644
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
index 1f14c5c48b4a..eea83da9114a 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -699,6 +699,8 @@ static struct kobj_attribute _name##_attr = __ATTR_RO(_name)
 DEFINE_MTHP_STAT_ATTR(anon_fault_alloc, MTHP_STAT_ANON_FAULT_ALLOC);
 DEFINE_MTHP_STAT_ATTR(anon_fault_fallback, MTHP_STAT_ANON_FAULT_FALLBACK);
 DEFINE_MTHP_STAT_ATTR(anon_fault_fallback_charge, MTHP_STAT_ANON_FAULT_FALLBACK_CHARGE);
+DEFINE_MTHP_STAT_ATTR(collapse_alloc, MTHP_STAT_COLLAPSE_ALLOC);
+DEFINE_MTHP_STAT_ATTR(collapse_alloc_failed, MTHP_STAT_COLLAPSE_ALLOC_FAILED);
 DEFINE_MTHP_STAT_ATTR(zswpout, MTHP_STAT_ZSWPOUT);
 DEFINE_MTHP_STAT_ATTR(swpin, MTHP_STAT_SWPIN);
 DEFINE_MTHP_STAT_ATTR(swpin_fallback, MTHP_STAT_SWPIN_FALLBACK);
@@ -764,6 +766,8 @@ static struct attribute *any_stats_attrs[] = {
 #endif
 	&split_attr.attr,
 	&split_failed_attr.attr,
+	&collapse_alloc_attr.attr,
+	&collapse_alloc_failed_attr.attr,
 	NULL,
 };
 
diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index b3910042bbf7..44564c179636 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -1077,28 +1077,34 @@ static enum scan_result __collapse_huge_page_swapin(struct mm_struct *mm,
 }
 
 static enum scan_result alloc_charge_folio(struct folio **foliop, struct mm_struct *mm,
-		struct collapse_control *cc)
+		struct collapse_control *cc, unsigned int order)
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
+		if (is_pmd_order(order))
+			count_vm_event(THP_COLLAPSE_ALLOC_FAILED);
+		count_mthp_stat(order, MTHP_STAT_COLLAPSE_ALLOC_FAILED);
 		return SCAN_ALLOC_HUGE_PAGE_FAIL;
 	}
 
-	count_vm_event(THP_COLLAPSE_ALLOC);
+	if (is_pmd_order(order))
+		count_vm_event(THP_COLLAPSE_ALLOC);
+	count_mthp_stat(order, MTHP_STAT_COLLAPSE_ALLOC);
+
 	if (unlikely(mem_cgroup_charge(folio, mm, gfp))) {
 		folio_put(folio);
 		*foliop = NULL;
 		return SCAN_CGROUP_CHARGE_FAIL;
 	}
 
-	count_memcg_folio_events(folio, THP_COLLAPSE_ALLOC, 1);
+	if (is_pmd_order(order))
+		count_memcg_folio_events(folio, THP_COLLAPSE_ALLOC, 1);
 
 	*foliop = folio;
 	return SCAN_SUCCEED;
@@ -1127,7 +1133,7 @@ static enum scan_result collapse_huge_page(struct mm_struct *mm, unsigned long a
 	 */
 	mmap_read_unlock(mm);
 
-	result = alloc_charge_folio(&folio, mm, cc);
+	result = alloc_charge_folio(&folio, mm, cc, HPAGE_PMD_ORDER);
 	if (result != SCAN_SUCCEED)
 		goto out_nolock;
 
@@ -1908,7 +1914,7 @@ static enum scan_result collapse_file(struct mm_struct *mm, unsigned long addr,
 	VM_BUG_ON(!IS_ENABLED(CONFIG_READ_ONLY_THP_FOR_FS) && !is_shmem);
 	VM_BUG_ON(start & (HPAGE_PMD_NR - 1));
 
-	result = alloc_charge_folio(&new_folio, mm, cc);
+	result = alloc_charge_folio(&new_folio, mm, cc, HPAGE_PMD_ORDER);
 	if (result != SCAN_SUCCEED)
 		goto out;
 
-- 
2.54.0


