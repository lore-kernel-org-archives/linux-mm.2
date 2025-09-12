Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 947E7CAC582
	for <linux-mm@archiver.kernel.org>; Fri, 12 Sep 2025 03:30:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 019A16B0008; Thu, 11 Sep 2025 23:30:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F33186B000C; Thu, 11 Sep 2025 23:30:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E49566B000D; Thu, 11 Sep 2025 23:30:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id D32D16B0008
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 23:30:11 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 7C015140658
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 03:30:11 +0000 (UTC)
X-FDA: 83879169822.23.8DD24D8
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf20.hostedemail.com (Postfix) with ESMTP id C25731C0006
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 03:30:09 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=PMw2ajvI;
	spf=pass (imf20.hostedemail.com: domain of npache@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757647809;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=g2z83/9qPq5Wjmo5BrRPgJsjDp/pEICW14/vfPUKdO0=;
	b=lExbshAxN0cI7dH/ZJkiQbYOkdInpYS7Rmn8nJEMWhFYYC+qEJ7AfJJoLU4IWeggSlgDpQ
	Qpai92wHaLvzAktV8nKZvejqMFZl09XwfGJJywayuxW6bzYB8imYZe3zvhOAN+3BEqzUeO
	oX6jMWQF6HHVSzqY6zjrTQOfQkJGJT4=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=PMw2ajvI;
	spf=pass (imf20.hostedemail.com: domain of npache@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757647809; a=rsa-sha256;
	cv=none;
	b=mf0eRwWsDqAlbS7RDRUaCJ/aGl6RrPFbuy2kY0Vy7741opgLH1HA9VwN2guGPJpluIaahQ
	n+W9Tq/S6vyP2khuBs8qWfYlhODuBvnb9zfQV5G5sEn0n3i82tgtUNQy2BpekLCt2H3kmy
	dEaSMpxJfa/+iEs6wNZJkPhn38q7dJ4=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1757647809;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=g2z83/9qPq5Wjmo5BrRPgJsjDp/pEICW14/vfPUKdO0=;
	b=PMw2ajvIARCdfWj4D4BaKJMWGQ7xHgAjQ0VSBPWOs0f2pl31vsNx8tNVU9tJOY9PbTZZVa
	I/JPRzq38AjTOjc3AGOBjOiGYJ6hu+5aEHYjt0uMxVI+fLXZRPFo7vEN9cLEdCA5kvzS6H
	Yg11JowmOQROV0hijo+iIotLLM0Dn4k=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-604-4E5lNFqlN0WrNzq7CiVYUw-1; Thu,
 11 Sep 2025 23:30:04 -0400
X-MC-Unique: 4E5lNFqlN0WrNzq7CiVYUw-1
X-Mimecast-MFC-AGG-ID: 4E5lNFqlN0WrNzq7CiVYUw_1757647799
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 40A351945102;
	Fri, 12 Sep 2025 03:29:59 +0000 (UTC)
Received: from h1.redhat.com (unknown [10.22.80.28])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 0423D1800451;
	Fri, 12 Sep 2025 03:29:48 +0000 (UTC)
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
	kas@kernel.org,
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
	hughd@google.com,
	richard.weiyang@gmail.com,
	lance.yang@linux.dev,
	vbabka@suse.cz,
	rppt@kernel.org,
	jannh@google.com,
	pfalcato@suse.de
Subject: [PATCH v11 04/15] khugepaged: generalize alloc_charge_folio()
Date: Thu, 11 Sep 2025 21:27:59 -0600
Message-ID: <20250912032810.197475-5-npache@redhat.com>
In-Reply-To: <20250912032810.197475-1-npache@redhat.com>
References: <20250912032810.197475-1-npache@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: C25731C0006
X-Stat-Signature: 5nh3kg83trrg7exajhm8hnm7z49jcwfs
X-HE-Tag: 1757647809-962919
X-HE-Meta: U2FsdGVkX1+6yiZyvLlQ9DuQnX+4aAqgt8esONzFi0U6FYK2eT8RWHi5fvML9xpJpqUaqzQkdGYYy4u6OmIDgCxHmFSx92fCliL/1oQy9qpCan2rvuFXyob5eOrHB38jlAYRpU9ldDLPdK9r6pupP+Da9K9PTNqwUK6vTAtrCL608Qtn81YJs1iAlA58bplTQSI1iF4JZZFzG5wLCY6xGqIBBnA+lH2XVKzyY1jaYI6L2nMOtWxLNn3FnGH0CVmR8ETOlKvByFj3SaZd5oC/f8rOHeUEe91cvO3NliPaQa7m92xCp6xDJT6dtL0Me+UoZM1gc6hEMr3XEULFOXtOgfZubd/+dzJLVRyVJUXfNhh3Tnw1T05WutC9OjCY8TvT8NfMc1V4X+sbTo1JDSOejblclL5+ZV90UiQZhyaoO84taMnKaJKXGiiIxf1wnheqrwcCqGQGm++zmVdgTeuHprBMLlcQgEFI7y/SrlSF/GOWn6Jnb3vrgj3U8rhsDvv5MGRPlwQsdwOUQhTXFlMhcH9lYF3JoDp2o+gdclMmUyu5RBK2F9ELNcJPw42UU/5c5tB7OiI6pH05coDz263Vbe/w2Isg7ubOZ8qSZjGYN0QGcHx4Y33mSfJi4yQ9diJojoJK118UFxOogdCWb2iuhrC+XmVlY9pMPqS5vd3nvt1NgrVPmpYeuGtW76LSbiW8ZjNXUHX1ih1YE/KKwB72b0EhYkFYMegqWjEOsg9zZ6KOzd4kl4BENewpTSKdItbFe4h7ghMB3+Qt/iYl0GeYOgYqLjFDcFHwiMDRBZp8nOlCWIgRuHb8KgWpOO9kikMHuPP3vKfXQNytxdbO/LVGZGkUSYqR4ox6Kug9KcpC2xqYtCfWE1xqaODWLmh2WI33Gcnc5WqQzgHZ5KG6Q2XkEPeeDbiz76MF52RkihxhTla9WwUSqy3R012Gbxij3YHAN2HhIieIlMoKR7vs9Qp
 uKztkMpt
 3vh2IxIa6vN2T1WMFnm/jXZx2wrbBVMZ4WMXot6qzbEQ5uegXNpBWA+LusO52n0GwZguHxZRE75gfDtUEA8kPg7WQWu6V6G/1mh+rPFwNKQiNbj/jGfyL3xywpr4eVLI+Ie3sWIFqjSjk8t+sTIOwoHJf0hZPlDNnpYh94FWhd33PrdrQd6L6ZuQBXYZqBl7YNzYzjFn6REz558/W4kaisMmfO/eu9zdNzq9KB00pJ44RTgJCuPWkhmyrbQlsorpH072FqaRAKfTfLPETQPPVOCyUw/z4CnMdRxJFt6W0q7zMj1VFDSuBQ3+LIvNQmxN7mC6ptcBOQos49XIdDJol/F3PK18aEVHuklqJCLfhkhiTgxs3OlPfpF6BA4NppF6u6Pyh01P8U5QZ/vQuTa+VC1mFt2xa+1Ok9TgjLSVUaV/QTf8+URny+/i7ObP73GEDVGeYhEaE/k/oJ48ZoBs6c0UXMrjfWQ+sCW0xvt41ydbCWrHfXpv0bcAQbLVBUGTkqzqExlV555Ty574iK+3hT3LCE7Eu0xv1JV5P0rq9sKnNeSbQzL5Fc4dXng==
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
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
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
index 1654211cc6cf..13269a0074d4 100644
--- a/Documentation/admin-guide/mm/transhuge.rst
+++ b/Documentation/admin-guide/mm/transhuge.rst
@@ -634,6 +634,14 @@ anon_fault_fallback_charge
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
index a166be872628..d442f45bd458 100644
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
index d6fc669e11c1..76509e3d845b 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -620,6 +620,8 @@ static struct kobj_attribute _name##_attr = __ATTR_RO(_name)
 DEFINE_MTHP_STAT_ATTR(anon_fault_alloc, MTHP_STAT_ANON_FAULT_ALLOC);
 DEFINE_MTHP_STAT_ATTR(anon_fault_fallback, MTHP_STAT_ANON_FAULT_FALLBACK);
 DEFINE_MTHP_STAT_ATTR(anon_fault_fallback_charge, MTHP_STAT_ANON_FAULT_FALLBACK_CHARGE);
+DEFINE_MTHP_STAT_ATTR(collapse_alloc, MTHP_STAT_COLLAPSE_ALLOC);
+DEFINE_MTHP_STAT_ATTR(collapse_alloc_failed, MTHP_STAT_COLLAPSE_ALLOC_FAILED);
 DEFINE_MTHP_STAT_ATTR(zswpout, MTHP_STAT_ZSWPOUT);
 DEFINE_MTHP_STAT_ATTR(swpin, MTHP_STAT_SWPIN);
 DEFINE_MTHP_STAT_ATTR(swpin_fallback, MTHP_STAT_SWPIN_FALLBACK);
@@ -685,6 +687,8 @@ static struct attribute *any_stats_attrs[] = {
 #endif
 	&split_attr.attr,
 	&split_failed_attr.attr,
+	&collapse_alloc_attr.attr,
+	&collapse_alloc_failed_attr.attr,
 	NULL,
 };
 
diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index 6dbe2d0683ac..2dea49522755 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -1071,21 +1071,26 @@ static int __collapse_huge_page_swapin(struct mm_struct *mm,
 }
 
 static int alloc_charge_folio(struct folio **foliop, struct mm_struct *mm,
-			      struct collapse_control *cc)
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
@@ -1122,7 +1127,7 @@ static int collapse_huge_page(struct mm_struct *mm, unsigned long address,
 	 */
 	mmap_read_unlock(mm);
 
-	result = alloc_charge_folio(&folio, mm, cc);
+	result = alloc_charge_folio(&folio, mm, cc, HPAGE_PMD_ORDER);
 	if (result != SCAN_SUCCEED)
 		goto out_nolock;
 
@@ -1850,7 +1855,7 @@ static int collapse_file(struct mm_struct *mm, unsigned long addr,
 	VM_BUG_ON(!IS_ENABLED(CONFIG_READ_ONLY_THP_FOR_FS) && !is_shmem);
 	VM_BUG_ON(start & (HPAGE_PMD_NR - 1));
 
-	result = alloc_charge_folio(&new_folio, mm, cc);
+	result = alloc_charge_folio(&new_folio, mm, cc, HPAGE_PMD_ORDER);
 	if (result != SCAN_SUCCEED)
 		goto out;
 
-- 
2.51.0


