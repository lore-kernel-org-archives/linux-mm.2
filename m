Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0BF4FD116F3
	for <linux-mm@archiver.kernel.org>; Mon,  1 Dec 2025 17:48:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 63B436B008C; Mon,  1 Dec 2025 12:48:14 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5EC806B0092; Mon,  1 Dec 2025 12:48:14 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4B41A6B0093; Mon,  1 Dec 2025 12:48:14 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 34D556B008C
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 12:48:14 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 01E4D13A941
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 17:48:13 +0000 (UTC)
X-FDA: 84171636108.02.480BB50
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf20.hostedemail.com (Postfix) with ESMTP id 4639E1C0015
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 17:48:12 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=RG0bGaPf;
	spf=pass (imf20.hostedemail.com: domain of npache@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764611292;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pj+ZKfsPj3iEPn8o+OC+myTpHHQqwiatEzWnF+qvDXo=;
	b=ENIurDf8i406Kdcg6Ph4NI0yAMX8eaYllsN4DuPjxVHN2UNTDdzv2ylOL+xmrIuu1PbU30
	TIpynaQkAXyCb3l1iQGySqPQZhUEqRVdDlZV6VO4CPzii1eDOPhvlXB/yaGvscY6+fcJFm
	qCGiTiC9xLktKSpn+Zku35Xu98jYulQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764611292; a=rsa-sha256;
	cv=none;
	b=oVpEsx2B1i4ar6FK+dP0DIRZ6MKVfHHnQ1P3B+ykfuhZt4WRXY03WYNcrv0wa9/eToKrmP
	GYLrAMCK5hJZa5zs46ud/FZU7uijTbswiwIgQ84T13UhBskSX75Duobao9HqRLBOLdieJ/
	t3ad1PizQp8646mGoV1GuM7MmeFzP+w=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=RG0bGaPf;
	spf=pass (imf20.hostedemail.com: domain of npache@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1764611291;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=pj+ZKfsPj3iEPn8o+OC+myTpHHQqwiatEzWnF+qvDXo=;
	b=RG0bGaPflq2hqRRgINOcINtY9kS0t+nHm/SjnWgvycwsiJ8VLAGxJ2PSEy7FRp4wtskK4W
	+Q4uhNyryvOh1M5Hxgo9cMgT2+mEzYJ45KVmzRCTl6kPVpRopfg2Hjc1Ln57ibZFNMxX7e
	gYnG2MEvxEGeWxD28yGYrUQkSLkLX9k=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-310-C4QKJ2ARNc2norS1zRmiaQ-1; Mon,
 01 Dec 2025 12:48:10 -0500
X-MC-Unique: C4QKJ2ARNc2norS1zRmiaQ-1
X-Mimecast-MFC-AGG-ID: C4QKJ2ARNc2norS1zRmiaQ_1764611285
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id C664C1956096;
	Mon,  1 Dec 2025 17:48:04 +0000 (UTC)
Received: from h1.redhat.com (unknown [10.22.66.60])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 83E60180047F;
	Mon,  1 Dec 2025 17:47:54 +0000 (UTC)
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
Subject: [PATCH v13 mm-new 04/16] khugepaged: generalize alloc_charge_folio()
Date: Mon,  1 Dec 2025 10:46:15 -0700
Message-ID: <20251201174627.23295-5-npache@redhat.com>
In-Reply-To: <20251201174627.23295-1-npache@redhat.com>
References: <20251201174627.23295-1-npache@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 4639E1C0015
X-Stat-Signature: cj4udd1nr1hrqdwa6etk364xjyahhawo
X-Rspam-User: 
X-HE-Tag: 1764611292-729915
X-HE-Meta: U2FsdGVkX1+PJz8tvCy18O/tGvOSGRn8kJDkcoE0R+ev1pNIv9ljucw7zn9b2RrWllyxqhK0LzswGlEVaUGO+CR0jJ/TqZhqynon+3TvGTdWABoCGw5TLalfAcMmg+UdAVaKNm9/1eEpTPrtrtbrhNCpoSJiQj+65/eUbUXBH9eLUGhXyzDkrQdgOjhX1ACrGPPAFmVJqtZhFMFrjK1SyKIJCy74FI8WdsA8TI5kWWluH7Bq1sbAd+JB012ljgnBWy0iyeBpDLM+BuptLEd91zYodqNuEHHYxGkPED5QJEq+Mkj055BbcP84Hnap0rjLwUmNbGiwTyNeHvt6k2mt3XRQae6yqlqlIaEuDoGcqpFgv7VHGJkqAt51WBwKEl5UwKX71y87+Kw9RKZBHRes9F4cZKEddNQxP/c3uJVMuE6irXeLd5ZgaD0QhF5Ot5mMy635aOiu2vkQV8FDdy7DUAZFAl/OqEGZQ+uNisrAJKhB9yM2YbgL+Rbl+EHneCWr6YbMMW5vetIrYI8RMWzCG1zC2vCGerUp4qEwTrFr8+5W1uENCDyh+yL36nHDWCHgaokuj5EHUtr0MrXAIz10X48DrXTHDDhwlpEc71S/4SjQ1R/INhKJfG/8eWEnuAAgpMRLyusjR0LUBnHZoBBr+Kl99Q3zqzB/p5gf7HZh/6TgveXFiqiuIraLNJsEfkRUwUqldvSHjgLpSNUik67VllRrgH9orKMR4O+m6CdjN87xQk+uBhPZvVmGJORRLnn0CvXiueT2tx1z9mwoGiQ2H7RAXzV2szPRJMUuMZeoRB1iTe3nhWkn2GPIsvEiz4nJBUo/feNfjiWn1+aebNWISdlDLY1XVThG/xy1MOHQq2+EqJsomMKLSSYe8JiBot7HYW/Nz2AvPKh9jEpG8rpiU0RLWBJF6jUOAr+zMNkjuQH7rYSycLVcOtWwb2DKR2umbr+hEFou997c7PJhR8W
 CtJf8P3t
 O1ReCvdaxenayLVy4Gz69YL7uOIeC6qpMbulYy6NBI3SiUMCfMQpUoSir3xSlsD/VxIp6/KyCQBDyVKtDAKeblW0Z1/q+ySur+pLV2qg4z28wRnUaOr/nBR2lGmd58eAA9IZ4noFHiwZoTGMQUe7cJfKV/+cqSbjdjspRjfuEMPNX17tY4GuhW9jSuzPvQr9c5SYKnUSM0QwFcxxlLbyzsel8gY9xjaxr9dSkpuoHTflGJA8BODVI5MfZtscxQhZjSwq2Pgsq5SMSnjrHeLkBVkDsrS3IJYHtX0gunzto+RIyEoqZ5MiJFY6hZmDoj8R43u0m0SEJfCJ0S62dDd9XtPztOn/mLoFJDiH5EMqCH1V6GSl21EJQe0dhJ0nOAKERZxb5FsJlRxSD1cfp1zPlVgds6rpb1/879y/GKzlyXxkbPhqGpmSnDDqn7xJ0U86ogl34eFCd1rJAAEH328znu2NOyvdE6qWnmuv4hB33Jnyk/HEZ10K4gYh6KRaZ4vvLthACgi++sKYGeHS4QtPhDPjDpP518ngveqlvZVXMR7nFK3WdICQp3zoh8rtL5kxk2EGJAMbxkGgWh74=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
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
index 21162493a0a0..f93365e182b4 100644
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
index 8db0d81fca40..c1e1e91b0e61 100644
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
index 69fc6b41f010..8599c7fa112e 100644
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
 
@@ -1872,7 +1877,7 @@ static int collapse_file(struct mm_struct *mm, unsigned long addr,
 	VM_BUG_ON(!IS_ENABLED(CONFIG_READ_ONLY_THP_FOR_FS) && !is_shmem);
 	VM_BUG_ON(start & (HPAGE_PMD_NR - 1));
 
-	result = alloc_charge_folio(&new_folio, mm, cc);
+	result = alloc_charge_folio(&new_folio, mm, cc, HPAGE_PMD_ORDER);
 	if (result != SCAN_SUCCEED)
 		goto out;
 
-- 
2.51.1


