Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 059DCCCD1AB
	for <linux-mm@archiver.kernel.org>; Wed, 22 Oct 2025 18:39:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 63C798E0015; Wed, 22 Oct 2025 14:39:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 614718E0010; Wed, 22 Oct 2025 14:39:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 503418E0015; Wed, 22 Oct 2025 14:39:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 3C8E18E0010
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 14:39:10 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 06AC7C093F
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 18:39:10 +0000 (UTC)
X-FDA: 84026612460.26.FD0C7B1
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf11.hostedemail.com (Postfix) with ESMTP id 4F3E940004
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 18:39:08 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=AZjBeZLS;
	spf=pass (imf11.hostedemail.com: domain of npache@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761158348;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2REGf03JWcvDSZSsPzScdNEpBV9wevechnucut1WH7k=;
	b=k51VNmiiTe80j+58fJpVzkr8odKF050VhVFsRv+n+WTjyr/Cl/82lbx13gx7ESxrhT2am/
	nz5sLgi6xnxHVqtMbPE7js296d7d/Tb3FhyRJq1kbVpfdUArYbJpdTG4VBiLKJwrp85XiN
	o23ls/qAL4W02MOiGLQMOadNIdGwr4w=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=AZjBeZLS;
	spf=pass (imf11.hostedemail.com: domain of npache@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761158348; a=rsa-sha256;
	cv=none;
	b=GhT/KefWi1B7a18H/dGh7HT4AVVSAr9LkD5LOf13WCJoS9LLQf9Hehmf9ahPxPDAi4//5w
	GsA55edES5Bve0f9VnlztC7vwKWmwta3AtblyU40WxNJb8uhlq2Hqvy2OwI20T4dkEY0j2
	52WT0Pl7OEo99uPgCtTzs1zs08iC1wE=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1761158347;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=2REGf03JWcvDSZSsPzScdNEpBV9wevechnucut1WH7k=;
	b=AZjBeZLS5DTGwjfnmwi+uaHF00jr9XpzQD7Src9fAFAzqASOeOMhdxxeW7xiyvdaQSFf82
	26ugSC9BtTNwI1PyDq+iVgItQi+Gz59aFxa1d2hZSjZ7JrO/Fshu2PLF6e1onzvpHFeClD
	ah9aLNbg8UrGxMOl/DaFePVX01vmOBA=
Received: from mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-282-vEmx2dYTPn2aYKj8HQdtdw-1; Wed,
 22 Oct 2025 14:39:04 -0400
X-MC-Unique: vEmx2dYTPn2aYKj8HQdtdw-1
X-Mimecast-MFC-AGG-ID: vEmx2dYTPn2aYKj8HQdtdw_1761158339
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 0BB851956086;
	Wed, 22 Oct 2025 18:38:59 +0000 (UTC)
Received: from h1.redhat.com (unknown [10.22.64.41])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 7CC5419560B5;
	Wed, 22 Oct 2025 18:38:49 +0000 (UTC)
From: Nico Pache <npache@redhat.com>
To: linux-kernel@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-doc@vger.kernel.org
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
Subject: [PATCH v12 mm-new 04/15] khugepaged: generalize alloc_charge_folio()
Date: Wed, 22 Oct 2025 12:37:06 -0600
Message-ID: <20251022183717.70829-5-npache@redhat.com>
In-Reply-To: <20251022183717.70829-1-npache@redhat.com>
References: <20251022183717.70829-1-npache@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 4F3E940004
X-Stat-Signature: sf4nnwbmq8guk8kjactraib5sgrsy8ig
X-Rspam-User: 
X-HE-Tag: 1761158348-949951
X-HE-Meta: U2FsdGVkX1+p9RyCkc3KDQcoFgpa1+gN3hR7oBgZB2wDbe1GTneyg2z4eAQtQVDq4G4TrmttWm2ZssdaKcGcc9G/72Zmi4kHYU2YZMwZDnwrI3yeRanMNe67pG/kgn1ZZ3yPXafx5Dog2rLcvZx4RC5VqkPFXHu42S4TiGIDD/G4OQ9BVS1e9WKhsRez1E4GLPTtcvlNELyIOX+hn7VHMeDns+mr3X/6J8s96j4Q87GD51AJ3P6BXgZSpc14jZ5MtVLeBlJi5GEEFk1dMY7H4y9CvpKY6TXLP46tXsoDAsVT48JMAC17ixf1ysukeMma00j+oY/FvvGfKlqKtB4WJviMLBrFAmn+S/KT2teQf8c1fnk1BtqBtHNqoZTRU1O4R8NWDgJzTzOP/pDIVwkN3IzUwbdIfJH/UDojHsbnpqSqgpE6digS6pQCoN+qIapQHXf0bFBCGP43OPAF/lQAQjVpT4BuYmDNtPxxGWYAg29JN5/n29+aawum6cQ5YSeYwel2VBMRzBghUoHx4ydYAufhjrZCHQIjHvWB0R3/uNoS+Bx8eP7GRmw6R3dC3DxRH6vo2qXdQEaQwWUke5/uQHKDUO2nXzxN7ctkzvpQvfFml0+9yTZJ93nB3OiLX/4/cGpwJdMsQtE9/vxmlVGTCHSGAAFNohyMGOSiJSoaaY1jSFW/lsuK8Q6PozGIyN+YJvbgC0QbIEypLi/9We5+bhdNaGPL2YkIjpYU5dds9b/J3MZXIm9zknjiTHhiYtxyPfAUPvJhQq4mq1j132eoLiWI+RoRIkB9Omaz6cCvDpZt97EOJhTQJ4ADsyUHBaHhofhr5LH4PQ295JDz/Ri2cyFJ9q78ssBcksoU20RzM4qIFaY2JdzC5az4zMtbGf5t6kKiXPJD3CW/mwoYlXEF2HX0U0HfTVXJRHmYzusMcs3rYE0a9K9XMAg3Gg0/Osv8s6XE1mxeuWXKNnaZOPZ
 V9wDc4gS
 PRuqVI/zehySeQCkD1TLGZnC08NwraSEys9L8Aqollz3dLqo0xAHsKDJcEaPRjp/AxqYiwWbQyW5QLfSchuEWHt7DGiemXMd9VXIg5P3emjkVu5tplkQnBSpcy1Ox5Efu4ohEdPhsXIULi0raufCLxaL8MkdPR0F7cXyWMFviQSyOvnXiW1IXtrViFs1J9INE5JRm//ZjClijhT5r1ntb1nRWgGxd4SaWfyDvvn8zY86eeVIoXOGwQ65JLLBPSz1cRD8PuEY6q37czChxJOU6Szvp/bQle1akFISjwHlL1oyNXN0o17YZGzN34cN3JZRioHuCpt8OCdYnclkYux/MO38BJLzVWOljaC5tRwfPJ6lWurdngnB52tXMn+nw9q4pUP3og2Ro5B/0Hd3oln61XsvhPBtF6uhihs4IZhOivgeyS1dXFTxZZNkLZRs1fhDsu0X7LOplr6qwQdIInyx09AWxG4/2Np20y/VaZAHXjHFEi4Uo4y9E/CliWjNv7m+Q+YctMUXxmerpnEoh4OwO4u7GfD3kNdeWBLdVQgAJLgXppx4Y229vlhFw9A==
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
index 7698b3542c4f..3d29624c4f3f 100644
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
index 370ecfd6a182..0063d1ba926e 100644
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
index 6cf8700823f9..36ee659acfbb 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -1061,21 +1061,26 @@ static int __collapse_huge_page_swapin(struct mm_struct *mm,
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
@@ -1112,7 +1117,7 @@ static int collapse_huge_page(struct mm_struct *mm, unsigned long address,
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


