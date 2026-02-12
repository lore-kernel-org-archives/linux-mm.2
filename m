Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7C3D4E9E31B
	for <linux-mm@archiver.kernel.org>; Thu, 12 Feb 2026 02:24:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A016F6B0089; Wed, 11 Feb 2026 21:24:00 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9AF906B008A; Wed, 11 Feb 2026 21:24:00 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 85A0E6B0092; Wed, 11 Feb 2026 21:24:00 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 730176B0089
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 21:24:00 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 3D239160747
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 02:24:00 +0000 (UTC)
X-FDA: 84434209440.04.322A44E
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf04.hostedemail.com (Postfix) with ESMTP id 230FA40005
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 02:23:57 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="R4O/SSMM";
	spf=pass (imf04.hostedemail.com: domain of npache@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770863038;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=397xlPpjUxFvY954VRGPkHg8dIT/MsS+yMoqJGr/bMM=;
	b=sQn3bRAlJfhNo5J8eiDnD9PRIv5VcjyaxsO4INDcyGPmdffsC4lkk1apgn5dpDDUmVnuci
	oHoWIfyus/JOLqtjeW3HFhD5gYVfrf2buv/duhrp+0A7fyy1QiaFXuDgVRmHhX+Wc8sj3j
	VJ7XglyUyreJwUYBmg/Zx5yNc5eGgbY=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="R4O/SSMM";
	spf=pass (imf04.hostedemail.com: domain of npache@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770863038; a=rsa-sha256;
	cv=none;
	b=sAChvdqjkd58VwPjtNaGTu0hbguHlYehqncR7ELC+UQS67FIxQXDVn4qlmSElICACiOjrN
	JrFb/oXPUtlHCdA6LW9RK36qeeqjBzufmlPp7ReoAIeItp8xQueVOO/UYILvcsM42/04f9
	Zr8sbqMMwJUFz/A2K8VYNVqbpcNfVgI=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1770863037;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=397xlPpjUxFvY954VRGPkHg8dIT/MsS+yMoqJGr/bMM=;
	b=R4O/SSMMqgwxoOsRiburcl0zTnc509zLTgRxDegHfnWW/C10nzTUEyi4OUnsIm1kGxKA9i
	5E6Q/OhffILZF8AdXs7j+a3biFaEsYPjsXrdtWMbmTbHxvUZCaMDT+PVuTI3rysMu9LeUF
	pdqXguKM22AR0Gd1LwvGcyt4lOwN/Cg=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-390-mq0WiXcCOqe_0ruYBe2j4g-1; Wed,
 11 Feb 2026 21:23:54 -0500
X-MC-Unique: mq0WiXcCOqe_0ruYBe2j4g-1
X-Mimecast-MFC-AGG-ID: mq0WiXcCOqe_0ruYBe2j4g_1770863028
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id B82A2195609E;
	Thu, 12 Feb 2026 02:23:47 +0000 (UTC)
Received: from h1.redhat.com (unknown [10.22.80.91])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 566751800464;
	Thu, 12 Feb 2026 02:23:38 +0000 (UTC)
From: Nico Pache <npache@redhat.com>
To: linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
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
	jackmanb@google.com,
	jack@suse.cz,
	jannh@google.com,
	jglisse@google.com,
	joshua.hahnjy@gmail.com,
	kas@kernel.org,
	lance.yang@linux.dev,
	Liam.Howlett@oracle.com,
	lorenzo.stoakes@oracle.com,
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
	zokeefe@google.com
Subject: [PATCH mm-unstable v1 4/5] mm/khugepaged: rename hpage_collapse_* to collapse_*
Date: Wed, 11 Feb 2026 19:23:28 -0700
Message-ID: <20260212022329.18892-1-npache@redhat.com>
In-Reply-To: <20260212021835.17755-1-npache@redhat.com>
References: <20260212021835.17755-1-npache@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: Dkwf8uAgUrQX6pn2sN5DKcK2MWH2pWUnjMf0t872y8g_1770863028
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Rspamd-Server: rspam11
X-Stat-Signature: rongm76kokk6yyf9fq9mtbsh1kgo5yfy
X-Rspam-User: 
X-Rspamd-Queue-Id: 230FA40005
X-HE-Tag: 1770863037-932802
X-HE-Meta: U2FsdGVkX19jKFKWmDBqz0UhwUHxQXx4A5Eb4AoJE2HDscZFs1Na6r/wNRPvXlGHFkGUAPD2TpDB05kkIlIaXtYEuaG0rcIoI+W8JQYT88qNCagbX9nrwJ13ZPS4FSVA1S2vm5s7hfDKQbX4VXIi2sf6ralYvU39Mdp7NOVESRb6dmnb6P+LAfqAI/yXSbBYk57+Jmn4zeAhWAFl1e5sn1mLnH5itZfrzX9YM8hLLVdEe840iwrgEpJLWi1pqwwkVpb9wIsH5kS3B4B2Cdz/tuptfIRi5vBz7U4fsjgihiuvBOBQXKbHyImGG+TdUmnFwaPetbbUA6PlKt5CPlh4FiYPPsDynkMvZ/WspqQD+i3HlFpyJvN1+A0Vuyf3I0NNIZOQMBNbwaYODnxR0WU1Igzvu37z2hI9qVcWimVQymSAHA2vz1/YT3vKuwPHU5hgJ8m4Sn/ohQAhGkz20W9jElnStI4YONX0DnMfPyH1H/IlQw7KavporlJgG311ej35kuG+Br5M0JLBUt/ih8ciHOVTlN1rcOHfBDJQNQ97HkSii1EoBuxDcB6OLANcAut70rN2cn8DgWHhWR+kccKj+WODtopott8NT1wm8GcCc+EDXA6f23SXNhwP3dxzdnxSWPKGPG2eNKzb/0KBh9SEG6hRW4SE8U20gXylUhizfqfPyMJHgAzytAW/cGP49STX0Py44WiofE1Sj530U4Ca516h92/nQcT6phWRn4e3M6wT61CXNc8viXKaCtzJybsu3KRcDdych1bucyUHcPrOq3d5tvy/I/FLK811GHL70Bo+qnDPZ68AhpCuNqPn16mu4HCglsFmfhU7ZXLT6ngGUdWDfoT/wco1mNb4TgHc+Avo4S4JY2dLUirNOvNKLYTclVt3OvRmblqmKPfAKFbeIAtna+fOV1ErGWqye0++Vd8NVU1y+Orr0GVo0Hmlif0y6fo3VKbxYaFhT8W5com
 ZRhAWjPP
 G/69iwwNK99we17tL9WIAYChM/7ECD5U7zOpWcxmIdH1NpZ8WUcdPiSvyQeo4OpDN+up3I6lrMZc5CJ5Ta9JMGpiuIvfJjVCqeskah7TGtIdbHrA15yOqZIQ8d12gtbST+kDRFkpkvjYwnH1paHmvFe0jeDSzh1uqMf6umpUATt398JKix5gq8pbV6rPssbG4S7OFR7XpxJc3O4Zq9G3hXMp9i8suJY0oIcFZ10fv4MjEnbDrdoWon0h8BcjerjFHmdmYI6ZvZMPAr2tI4+CODS9QDOAAqxPcE0kEvTZVM+nFk0B1xxVUXQqEHQBdMzWLlP+tQnPxv1Qw8BxlViQPALFkLZYTOQkMVy2lqMEuhth7w2xk1lnrXqe5sy5KbHQniQWoI8gkD0aUYFQN5zzGKD80CuVNZ6uso0ONEiihUn4toUyzU1px1l1+4PH36mPW4HAuMSBx7ILx36XZqp92IIOAdvopVynI2IGtnnNKpJHr8Akrqwg4FT0tSELElb9tHHNdRZMkbWxFEJtGGw0m9uIEmhdPSpbzCjsTLcuulQhPvBY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The hpage_collapse functions describe functions used by madvise_collapse
and khugepaged. remove the unnecessary hpage prefix to shorten the
function name.

Reviewed-by: Wei Yang <richard.weiyang@gmail.com>
Reviewed-by: Lance Yang <lance.yang@linux.dev>
Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Signed-off-by: Nico Pache <npache@redhat.com>
---
 mm/khugepaged.c | 62 ++++++++++++++++++++++++-------------------------
 mm/mremap.c     |  2 +-
 2 files changed, 31 insertions(+), 33 deletions(-)

diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index 3dcce6018f20..fa41480f6948 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -397,14 +397,14 @@ void __init khugepaged_destroy(void)
 	kmem_cache_destroy(mm_slot_cache);
 }
 
-static inline int hpage_collapse_test_exit(struct mm_struct *mm)
+static inline int collapse_test_exit(struct mm_struct *mm)
 {
 	return atomic_read(&mm->mm_users) == 0;
 }
 
-static inline int hpage_collapse_test_exit_or_disable(struct mm_struct *mm)
+static inline int collapse_test_exit_or_disable(struct mm_struct *mm)
 {
-	return hpage_collapse_test_exit(mm) ||
+	return collapse_test_exit(mm) ||
 		mm_flags_test(MMF_DISABLE_THP_COMPLETELY, mm);
 }
 
@@ -438,7 +438,7 @@ void __khugepaged_enter(struct mm_struct *mm)
 	int wakeup;
 
 	/* __khugepaged_exit() must not run from under us */
-	VM_BUG_ON_MM(hpage_collapse_test_exit(mm), mm);
+	VM_BUG_ON_MM(collapse_test_exit(mm), mm);
 	if (unlikely(mm_flags_test_and_set(MMF_VM_HUGEPAGE, mm)))
 		return;
 
@@ -492,7 +492,7 @@ void __khugepaged_exit(struct mm_struct *mm)
 	} else if (slot) {
 		/*
 		 * This is required to serialize against
-		 * hpage_collapse_test_exit() (which is guaranteed to run
+		 * collapse_test_exit() (which is guaranteed to run
 		 * under mmap sem read mode). Stop here (after we return all
 		 * pagetables will be destroyed) until khugepaged has finished
 		 * working on the pagetables under the mmap_lock.
@@ -581,7 +581,7 @@ static enum scan_result __collapse_huge_page_isolate(struct vm_area_struct *vma,
 		folio = page_folio(page);
 		VM_BUG_ON_FOLIO(!folio_test_anon(folio), folio);
 
-		/* See hpage_collapse_scan_pmd(). */
+		/* See collapse_scan_pmd(). */
 		if (folio_maybe_mapped_shared(folio)) {
 			++shared;
 			if (cc->is_khugepaged &&
@@ -832,7 +832,7 @@ static struct collapse_control khugepaged_collapse_control = {
 	.is_khugepaged = true,
 };
 
-static bool hpage_collapse_scan_abort(int nid, struct collapse_control *cc)
+static bool collapse_scan_abort(int nid, struct collapse_control *cc)
 {
 	int i;
 
@@ -867,7 +867,7 @@ static inline gfp_t alloc_hugepage_khugepaged_gfpmask(void)
 }
 
 #ifdef CONFIG_NUMA
-static int hpage_collapse_find_target_node(struct collapse_control *cc)
+static int collapse_find_target_node(struct collapse_control *cc)
 {
 	int nid, target_node = 0, max_value = 0;
 
@@ -886,7 +886,7 @@ static int hpage_collapse_find_target_node(struct collapse_control *cc)
 	return target_node;
 }
 #else
-static int hpage_collapse_find_target_node(struct collapse_control *cc)
+static int collapse_find_target_node(struct collapse_control *cc)
 {
 	return 0;
 }
@@ -905,7 +905,7 @@ static enum scan_result hugepage_vma_revalidate(struct mm_struct *mm, unsigned l
 	enum tva_type type = cc->is_khugepaged ? TVA_KHUGEPAGED :
 				 TVA_FORCED_COLLAPSE;
 
-	if (unlikely(hpage_collapse_test_exit_or_disable(mm)))
+	if (unlikely(collapse_test_exit_or_disable(mm)))
 		return SCAN_ANY_PROCESS;
 
 	*vmap = vma = find_vma(mm, address);
@@ -976,7 +976,7 @@ static enum scan_result check_pmd_still_valid(struct mm_struct *mm,
 
 /*
  * Bring missing pages in from swap, to complete THP collapse.
- * Only done if hpage_collapse_scan_pmd believes it is worthwhile.
+ * Only done if khugepaged_scan_pmd believes it is worthwhile.
  *
  * Called and returns without pte mapped or spinlocks held.
  * Returns result: if not SCAN_SUCCEED, mmap_lock has been released.
@@ -1062,7 +1062,7 @@ static enum scan_result alloc_charge_folio(struct folio **foliop, struct mm_stru
 {
 	gfp_t gfp = (cc->is_khugepaged ? alloc_hugepage_khugepaged_gfpmask() :
 		     GFP_TRANSHUGE);
-	int node = hpage_collapse_find_target_node(cc);
+	int node = collapse_find_target_node(cc);
 	struct folio *folio;
 
 	folio = __folio_alloc(gfp, HPAGE_PMD_ORDER, node, &cc->alloc_nmask);
@@ -1240,7 +1240,7 @@ static enum scan_result collapse_huge_page(struct mm_struct *mm, unsigned long a
 	return result;
 }
 
-static enum scan_result hpage_collapse_scan_pmd(struct mm_struct *mm,
+static enum scan_result collapse_scan_pmd(struct mm_struct *mm,
 		struct vm_area_struct *vma, unsigned long start_addr, bool *mmap_locked,
 		struct collapse_control *cc)
 {
@@ -1350,7 +1350,7 @@ static enum scan_result hpage_collapse_scan_pmd(struct mm_struct *mm,
 		 * hit record.
 		 */
 		node = folio_nid(folio);
-		if (hpage_collapse_scan_abort(node, cc)) {
+		if (collapse_scan_abort(node, cc)) {
 			result = SCAN_SCAN_ABORT;
 			goto out_unmap;
 		}
@@ -1416,7 +1416,7 @@ static void collect_mm_slot(struct mm_slot *slot)
 
 	lockdep_assert_held(&khugepaged_mm_lock);
 
-	if (hpage_collapse_test_exit(mm)) {
+	if (collapse_test_exit(mm)) {
 		/* free mm_slot */
 		hash_del(&slot->hash);
 		list_del(&slot->mm_node);
@@ -1771,7 +1771,7 @@ static void retract_page_tables(struct address_space *mapping, pgoff_t pgoff)
 		if (find_pmd_or_thp_or_none(mm, addr, &pmd) != SCAN_SUCCEED)
 			continue;
 
-		if (hpage_collapse_test_exit(mm))
+		if (collapse_test_exit(mm))
 			continue;
 
 		if (!file_backed_vma_is_retractable(vma))
@@ -2289,7 +2289,7 @@ static enum scan_result collapse_file(struct mm_struct *mm, unsigned long addr,
 	return result;
 }
 
-static enum scan_result hpage_collapse_scan_file(struct mm_struct *mm, unsigned long addr,
+static enum scan_result collapse_scan_file(struct mm_struct *mm, unsigned long addr,
 		struct file *file, pgoff_t start, struct collapse_control *cc)
 {
 	struct folio *folio = NULL;
@@ -2345,7 +2345,7 @@ static enum scan_result hpage_collapse_scan_file(struct mm_struct *mm, unsigned
 		}
 
 		node = folio_nid(folio);
-		if (hpage_collapse_scan_abort(node, cc)) {
+		if (collapse_scan_abort(node, cc)) {
 			result = SCAN_SCAN_ABORT;
 			folio_put(folio);
 			break;
@@ -2395,7 +2395,7 @@ static enum scan_result hpage_collapse_scan_file(struct mm_struct *mm, unsigned
 	return result;
 }
 
-static unsigned int khugepaged_scan_mm_slot(unsigned int pages, enum scan_result *result,
+static unsigned int collapse_scan_mm_slot(unsigned int pages, enum scan_result *result,
 					    struct collapse_control *cc)
 	__releases(&khugepaged_mm_lock)
 	__acquires(&khugepaged_mm_lock)
@@ -2430,7 +2430,7 @@ static unsigned int khugepaged_scan_mm_slot(unsigned int pages, enum scan_result
 		goto breakouterloop_mmap_lock;
 
 	progress++;
-	if (unlikely(hpage_collapse_test_exit_or_disable(mm)))
+	if (unlikely(collapse_test_exit_or_disable(mm)))
 		goto breakouterloop;
 
 	vma_iter_init(&vmi, mm, khugepaged_scan.address);
@@ -2438,7 +2438,7 @@ static unsigned int khugepaged_scan_mm_slot(unsigned int pages, enum scan_result
 		unsigned long hstart, hend;
 
 		cond_resched();
-		if (unlikely(hpage_collapse_test_exit_or_disable(mm))) {
+		if (unlikely(collapse_test_exit_or_disable(mm))) {
 			progress++;
 			break;
 		}
@@ -2460,7 +2460,7 @@ static unsigned int khugepaged_scan_mm_slot(unsigned int pages, enum scan_result
 			bool mmap_locked = true;
 
 			cond_resched();
-			if (unlikely(hpage_collapse_test_exit_or_disable(mm)))
+			if (unlikely(collapse_test_exit_or_disable(mm)))
 				goto breakouterloop;
 
 			VM_BUG_ON(khugepaged_scan.address < hstart ||
@@ -2473,12 +2473,12 @@ static unsigned int khugepaged_scan_mm_slot(unsigned int pages, enum scan_result
 
 				mmap_read_unlock(mm);
 				mmap_locked = false;
-				*result = hpage_collapse_scan_file(mm,
+				*result = collapse_scan_file(mm,
 					khugepaged_scan.address, file, pgoff, cc);
 				fput(file);
 				if (*result == SCAN_PTE_MAPPED_HUGEPAGE) {
 					mmap_read_lock(mm);
-					if (hpage_collapse_test_exit_or_disable(mm))
+					if (collapse_test_exit_or_disable(mm))
 						goto breakouterloop;
 					*result = try_collapse_pte_mapped_thp(mm,
 						khugepaged_scan.address, false);
@@ -2487,7 +2487,7 @@ static unsigned int khugepaged_scan_mm_slot(unsigned int pages, enum scan_result
 					mmap_read_unlock(mm);
 				}
 			} else {
-				*result = hpage_collapse_scan_pmd(mm, vma,
+				*result = collapse_scan_pmd(mm, vma,
 					khugepaged_scan.address, &mmap_locked, cc);
 			}
 
@@ -2520,7 +2520,7 @@ static unsigned int khugepaged_scan_mm_slot(unsigned int pages, enum scan_result
 	 * Release the current mm_slot if this mm is about to die, or
 	 * if we scanned all vmas of this mm.
 	 */
-	if (hpage_collapse_test_exit(mm) || !vma) {
+	if (collapse_test_exit(mm) || !vma) {
 		/*
 		 * Make sure that if mm_users is reaching zero while
 		 * khugepaged runs here, khugepaged_exit will find
@@ -2571,8 +2571,8 @@ static void khugepaged_do_scan(struct collapse_control *cc)
 			pass_through_head++;
 		if (khugepaged_has_work() &&
 		    pass_through_head < 2)
-			progress += khugepaged_scan_mm_slot(pages - progress,
-							    &result, cc);
+			progress += collapse_scan_mm_slot(pages - progress,
+							  &result, cc);
 		else
 			progress = pages;
 		spin_unlock(&khugepaged_mm_lock);
@@ -2816,8 +2816,7 @@ int madvise_collapse(struct vm_area_struct *vma, unsigned long start,
 			mmap_read_unlock(mm);
 			mmap_locked = false;
 			*lock_dropped = true;
-			result = hpage_collapse_scan_file(mm, addr, file, pgoff,
-							  cc);
+			result = collapse_scan_file(mm, addr, file, pgoff, cc);
 
 			if (result == SCAN_PAGE_DIRTY_OR_WRITEBACK && !triggered_wb &&
 			    mapping_can_writeback(file->f_mapping)) {
@@ -2831,8 +2830,7 @@ int madvise_collapse(struct vm_area_struct *vma, unsigned long start,
 			}
 			fput(file);
 		} else {
-			result = hpage_collapse_scan_pmd(mm, vma, addr,
-							 &mmap_locked, cc);
+			result = collapse_scan_pmd(mm, vma, addr, &mmap_locked, cc);
 		}
 		if (!mmap_locked)
 			*lock_dropped = true;
diff --git a/mm/mremap.c b/mm/mremap.c
index 2be876a70cc0..eb222af91c2d 100644
--- a/mm/mremap.c
+++ b/mm/mremap.c
@@ -244,7 +244,7 @@ static int move_ptes(struct pagetable_move_control *pmc,
 		goto out;
 	}
 	/*
-	 * Now new_pte is none, so hpage_collapse_scan_file() path can not find
+	 * Now new_pte is none, so collapse_scan_file() path can not find
 	 * this by traversing file->f_mapping, so there is no concurrency with
 	 * retract_page_tables(). In addition, we already hold the exclusive
 	 * mmap_lock, so this new_pte page is stable, so there is no need to get
-- 
2.53.0


