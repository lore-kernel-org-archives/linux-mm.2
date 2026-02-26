Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5D8FBFD45F9
	for <linux-mm@archiver.kernel.org>; Thu, 26 Feb 2026 03:23:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B05776B008A; Wed, 25 Feb 2026 22:23:51 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ADDC36B008C; Wed, 25 Feb 2026 22:23:51 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9B2206B0092; Wed, 25 Feb 2026 22:23:51 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 884436B008A
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 22:23:51 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 2FEF21B74B1
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 03:23:51 +0000 (UTC)
X-FDA: 84485163462.04.97C88B6
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf05.hostedemail.com (Postfix) with ESMTP id 0C561100003
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 03:23:48 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=dI0E0mzc;
	spf=pass (imf05.hostedemail.com: domain of npache@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772076229;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2XsXcjm0A9FGka+evZGhV+xgK+L+c6bwLP6PgnBz78Y=;
	b=jLvpkLrjsW7zDySX25cN+6GrYC7wR+uI6VqYz/DoO6+1o2r4J5g3q3vb5MA5pfU5ipG99K
	Gn4QW2w4KU2/44Ax0RIR8+Cc9QGDzPE2NwEDB7Sv/t8dHjLs6el2xuhMJL3p1ztsf3Ivhk
	NZu4TflWi0Mzr5PswPKqS6mEB8GXs+w=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=dI0E0mzc;
	spf=pass (imf05.hostedemail.com: domain of npache@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772076229; a=rsa-sha256;
	cv=none;
	b=m0aLALwWoUSDmUTzPfG9t6jLfotnk2Y1/+vs2wvdwh0iPKRQ4AAErMNrnZebcV143o9yRz
	tkwwSOsbsCodcwGDLu+QecQBcp8KnKJyqlNgLQ/bzd1H3bAtlySYAYnaA/2aErbrrbtIFO
	0kbp346TXB2B2SEum+3DMZnL2vTxUDk=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1772076228;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=2XsXcjm0A9FGka+evZGhV+xgK+L+c6bwLP6PgnBz78Y=;
	b=dI0E0mzc58r7gWQc0qNnfPQFHBdC6bTN1Kd4RhwYqv0/VEVsAqWsQEaf9go8WBUij5moI/
	IZ3OZqYpJAEspQ2a6/Bk3hqB7ng1pYXCkumTAD6dq6w2zD6VV1p9P/2xuRF7LpvXGXxa5h
	U4K0E57ZTlxKL24Q3Br7gfHKMI8m1eI=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-52-ZVUl656OOx6SxdQR69VifQ-1; Wed,
 25 Feb 2026 22:23:46 -0500
X-MC-Unique: ZVUl656OOx6SxdQR69VifQ-1
X-Mimecast-MFC-AGG-ID: ZVUl656OOx6SxdQR69VifQ_1772076220
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id BCC40180025C;
	Thu, 26 Feb 2026 03:23:39 +0000 (UTC)
Received: from h1.redhat.com (unknown [10.22.64.173])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 2F5163003D88;
	Thu, 26 Feb 2026 03:23:29 +0000 (UTC)
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
Subject: [PATCH mm-unstable v15 02/13] mm/khugepaged: generalize alloc_charge_folio()
Date: Wed, 25 Feb 2026 20:23:26 -0700
Message-ID: <20260226032326.232770-1-npache@redhat.com>
In-Reply-To: <20260226031741.230674-1-npache@redhat.com>
References: <20260226031741.230674-1-npache@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: _sN7TBH1HprK95NqXqALyth-ws1d2sSiTbeb6Z1MXgk_1772076220
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Rspamd-Server: rspam05
X-Rspam-User: 
X-Rspamd-Queue-Id: 0C561100003
X-Stat-Signature: 1jknoy4mcwz74f68jy5j3r359tx3y3nw
X-HE-Tag: 1772076228-786927
X-HE-Meta: U2FsdGVkX1/IZyHRe+E3Otr0OPGEc60d7MMHVJ30vlb1V4/lK0oBK5HM5tQ6A/ljlAQJX02NoxOK5euBZBqqEnw7tU5r/77LhTaDGsXbw4k1nL419pGXH+dhyLnJvOIBCxpTDlaxWtsINzR26nsB6EUFLRLq+D9H8GUd51U2/8EfzleMe15NhokT264EGU+9BgFgOZHMpByA147T4dfCjG+SKlDLp0pkWPENJIFi+nDquoGYLF1PVA0x9jxs3h0TFkSME8ohEIb/+VJSzsacneko/YVOkvnlqnGZuJw6HdpNHGSMX4Trgb8Uxz7h7yT7dSHNeqrM6WO1tCv/IHR1CO/HGlG43mGvsrYlKp1383HpizjxiRH/EEykRNJ6tkmNQUwiYYiNrgbmBpEL/CFikmaM+3lF6hcV1zA8y8+Eo8TUlytUWj7M4C/BZ1ffq2Agb2W+ix90Uq+/cgcx/R8HkoaKQKktHwuzGBbzyQsUeQn2ZjT1tiM/MX+MtGu93Nw9WsOwSgPcjNMv1RjzPFTy/1g244PW3NjlB9vjrHV4z7uMBe/Cry4PeoUTuf8Z2ujV7Q7DnncfRUTQIR5jO6ybOMlQUNZpDebBBvvw/tL3neYlLJit/U36+Q4qXKDNcGsEgunuNeo2e1hPoVAkhMip6q3XFop7W681R63eb8QCm0QuzgOMUKLf7W45xznmOANExG37oe4fkwyjeM+QEai0/RKPqg+8hE7hT6sWBZXUcGBCmYNNO8EXhem1xv0jFQnkGlWqz2g6A+OMA+4lOZquDXxumL7Hda0vnr83JZmFoWpV9C9YrTjvPgA+CEkdfaxaMlhFCLYJ1o+TMR+03C4BmOZ/pW4GRCJ6nYUdPqtxG6bvZxQsQQtsZfj8/qQKFf/mpNB+nNAqPWyAKWaY8RIHwBtd7ABIq7c1NGApcUYGveJ54ubXyHGRYgfrvZRLxdNwWBcDmJNFkXcbqZ07gIn
 l445bNyB
 g4Kpsa9KEsc7jfhSWQYMKYw+qDUu4//hatR7RyQFv4K+p7TENOAqqo0byd8HH7J74DEHaII1WkZcf6sxw4XDiVpdu9Bq+1Dv+Csc/Mw1Jbtg+EXJhddf1pykqoGT7yFycj1E1wqpu4jSS9ie24ORq3gmXhHSIERKR73oMb9/vNlHMFp8Q54Y+ltiyLmYa+N7aU5aRz2W0GyPoAFWieuFL/rwRzwJ85i1VkMecFMtWJElzmvV4F69FBpKlmWGhO7CuXTJcSOZ42PcNsIXNty534wewjzPoRji9GWG9onXBLoumpamlzwI9i677fe1YbMa3/jj/wpqRUSEhWqCplN6TkhrOwRJJcR6HKptLLnqKiAmyrqvqkw413T2cjRO/ueIT0zDFV4xH8YvK1fnkwGFwhi70gaG+HgV57SWTm3yXOxbVdwyDF7NQXAusstfCQ8ewgT4rvH4rKgMhE9G4jpCpPyDyV0OwMRblJYGXdkv4iq/z4aGwUmAq/oBQbobtkkSuU8AbqPe0qRwgTF5V9Vr1Mb0+g61cPbI9kWKEezVcs2s0JDPuEkRvntZjLF6a/DJUZ+2b5Yl/kOqbV7h88gzMyaH4paYpMpc4yvPfyYoGeV9T+rg=
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
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Reviewed-by: Zi Yan <ziy@nvidia.com>
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
index 5fbc3d89bb07..c51932e6275d 100644
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
index bd7f0e1d8094..9941fc6d7bd8 100644
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
index a688d5ff806e..228f35e962b9 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -624,6 +624,8 @@ static struct kobj_attribute _name##_attr = __ATTR_RO(_name)
 DEFINE_MTHP_STAT_ATTR(anon_fault_alloc, MTHP_STAT_ANON_FAULT_ALLOC);
 DEFINE_MTHP_STAT_ATTR(anon_fault_fallback, MTHP_STAT_ANON_FAULT_FALLBACK);
 DEFINE_MTHP_STAT_ATTR(anon_fault_fallback_charge, MTHP_STAT_ANON_FAULT_FALLBACK_CHARGE);
+DEFINE_MTHP_STAT_ATTR(collapse_alloc, MTHP_STAT_COLLAPSE_ALLOC);
+DEFINE_MTHP_STAT_ATTR(collapse_alloc_failed, MTHP_STAT_COLLAPSE_ALLOC_FAILED);
 DEFINE_MTHP_STAT_ATTR(zswpout, MTHP_STAT_ZSWPOUT);
 DEFINE_MTHP_STAT_ATTR(swpin, MTHP_STAT_SWPIN);
 DEFINE_MTHP_STAT_ATTR(swpin_fallback, MTHP_STAT_SWPIN_FALLBACK);
@@ -689,6 +691,8 @@ static struct attribute *any_stats_attrs[] = {
 #endif
 	&split_attr.attr,
 	&split_failed_attr.attr,
+	&collapse_alloc_attr.attr,
+	&collapse_alloc_failed_attr.attr,
 	NULL,
 };
 
diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index c7f2c4a90910..a9b645402b7f 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -1061,21 +1061,26 @@ static enum scan_result __collapse_huge_page_swapin(struct mm_struct *mm,
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
@@ -1111,7 +1116,7 @@ static enum scan_result collapse_huge_page(struct mm_struct *mm, unsigned long a
 	 */
 	mmap_read_unlock(mm);
 
-	result = alloc_charge_folio(&folio, mm, cc);
+	result = alloc_charge_folio(&folio, mm, cc, HPAGE_PMD_ORDER);
 	if (result != SCAN_SUCCEED)
 		goto out_nolock;
 
@@ -1891,7 +1896,7 @@ static enum scan_result collapse_file(struct mm_struct *mm, unsigned long addr,
 	VM_BUG_ON(!IS_ENABLED(CONFIG_READ_ONLY_THP_FOR_FS) && !is_shmem);
 	VM_BUG_ON(start & (HPAGE_PMD_NR - 1));
 
-	result = alloc_charge_folio(&new_folio, mm, cc);
+	result = alloc_charge_folio(&new_folio, mm, cc, HPAGE_PMD_ORDER);
 	if (result != SCAN_SUCCEED)
 		goto out;
 
-- 
2.53.0


