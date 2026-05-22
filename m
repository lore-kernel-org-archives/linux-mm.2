Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 80A50CD5BB3
	for <linux-mm@archiver.kernel.org>; Fri, 22 May 2026 15:00:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EA6AE6B00A4; Fri, 22 May 2026 11:00:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E7E356B00A5; Fri, 22 May 2026 11:00:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D46126B00A6; Fri, 22 May 2026 11:00:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C50956B00A4
	for <linux-mm@kvack.org>; Fri, 22 May 2026 11:00:48 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 82D8F1C08D0
	for <linux-mm@kvack.org>; Fri, 22 May 2026 15:00:48 +0000 (UTC)
X-FDA: 84795367776.10.423669E
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf07.hostedemail.com (Postfix) with ESMTP id 716DE40019
	for <linux-mm@kvack.org>; Fri, 22 May 2026 15:00:46 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="HYjBcT/f";
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf07.hostedemail.com: domain of npache@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=npache@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779462046;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Hc6duGOKmiUk6kDlCqH/UpN0JQZbmL1uWsr7EilOzFs=;
	b=msKe6PdZXiLImIR6aBXpBPTPxTPD7mM2qfpARxKnX3aDu94JzD3ALFZz75AB6Kcyx7enD8
	MAaZrwjTqz32ii+AvGY7xU6DQksFz+I2xPui25IvmKyArt2g3PSwZdaZH1mEdMs5V5Cm2H
	U3apg+37RkuoMC1GGXXekqh5gnNtcMk=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="HYjBcT/f";
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf07.hostedemail.com: domain of npache@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=npache@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779462046; a=rsa-sha256;
	cv=none;
	b=b+uII4XN1BX9ZJFQsVmO/H9CIgkBZoiMkvLiJ52aVgBfqrXQP3mBC0JRRIVX3lu0UkVIF8
	3/SsVl74umjqO8j3+5WBrT+//GQgJg2+RWl7pHyvjdo0q4ib0EkmUJp+QjIJtVGyFKAEkg
	GWvyzqvuSgyQXGLqtSdeFGPigJ6OK9c=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1779462045;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Hc6duGOKmiUk6kDlCqH/UpN0JQZbmL1uWsr7EilOzFs=;
	b=HYjBcT/fUWdGOQNf6h7xL6euwmkxhZHtujUYRSxneBePFbeLcDvflT5KacSRi/osSvf6nG
	WhZrWvhh3qDPgMfJSFdMb3TOxEwiMhm8WcyUJ1MFV8y1T/Vy4lGucPWHGXLUQe4KxxwL+s
	m8UdkAAr/NKp/c2G0SXJzg0injm/e60=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-479-Q6DxVdiLMFKDku0uuKiEGA-1; Fri,
 22 May 2026 11:00:43 -0400
X-MC-Unique: Q6DxVdiLMFKDku0uuKiEGA-1
X-Mimecast-MFC-AGG-ID: Q6DxVdiLMFKDku0uuKiEGA_1779462032
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 302CF1956056;
	Fri, 22 May 2026 15:00:31 +0000 (UTC)
Received: from p1.redhat.com (unknown [10.44.24.8])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 439A11803A8E;
	Fri, 22 May 2026 15:00:10 +0000 (UTC)
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
Subject: [PATCH mm-unstable v18 02/14] mm/khugepaged: generalize alloc_charge_folio()
Date: Fri, 22 May 2026 08:59:57 -0600
Message-ID: <20260522150009.121603-3-npache@redhat.com>
In-Reply-To: <20260522150009.121603-1-npache@redhat.com>
References: <20260522150009.121603-1-npache@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 5Dbl2yIkH5cL8cPQbnDFGN1OTTnaNe5ERVKQ1cTfCNE_1779462032
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 716DE40019
X-Stat-Signature: dhp8g9h8w4fja955hudd4g3ghben13gu
X-Rspam-User: 
X-HE-Tag: 1779462046-136421
X-HE-Meta: U2FsdGVkX1+3/5ON5X22JVbiLzctRf86Zx20w6WUdPoMzqnzdGTouO2nUAYqzGrlFZFPhCYOZ1bLwpDmS8ITqr/q3HIhj3nH1tpWc73Ys5rOqCuv79nmdUIKam1AErDDVnI/Fpvhf7669S/6SgBgsRTi+zF/1obUne7okvpJeGKitWs18siJIWw1ErIhFnV7nQmZ8iXZHAdgeMoCxarFRhUcLNzbC9KwD+W30GrEQQP+zxCk4eztRExBoNknRSHA9ivbkZUnK3Q0XZWGixJpXVpXLlcOkwJIcdlnpOs6aucTJc8QsJmyfa8pjHZtASuXMC0dYhqk3sOs+DoUv9L73JZscaXl8OKAeAku2MtwQNrTlt4oPq2jfoMXe3/+cEvGVyCoVRNxKjxe3UcG1BYWP78vWGNhNrMKAiMZd6FRcr3ll2n7WLK5DRy9v2F+wJgrKqweJcua1n0rYjC6cdod9BIsHzCWhd3J8DICCjw6zWWYyoaO4nmnrJSpHjfo7I1OxLD/bMTITcWv7eGAznS8TQsnlivXu9H0Dt6F9fMYNZlK0j1bK/cf2Z2zFXuONy/UKrJZd94gf+2zc7fs7yWV6N4eh7OllPcu7m+G6+/e5k4VObeJpGGKglOYbnPVis2PHiQze96tl6b3t9ITtv/phYg+biE6PkQ1smTZCRQN/DVn8q9ZxntwnUEA8EBCU/tqGEFGoMLL5qw7TIaop4kQdyy9DXdod0G3o/GA6QYjRP1uVil/aUGdCRaHhNSN1Tmb3zaeq8KhJF2iaB/G0o7a5GX8juqhIqdpjRD9FQa6GaJ0qLjjD+DX4kb4WTd4/EGAE5eEN1Jo990Zm6gXghINekPGUW3b+fH2RuSpFVIk3vRbwKrCnhu7qQt7X3cmm0GAdZRrdiXhm/mxUWfFfg1RLLS+zCilTwEiZdnbPlE0FrBbKW4EJvHRbjY7VZMVPMvUHhw11fMsJCWKpJynISt
 S6xfKQSY
 FQbRCTWPTLxKXpHwN/eO2czR79/K5US9L2KwpCziSPNo88/jhUowBnBXvvcS/UfrvPbiXEnd1+rMOI4jf8aQZ34uz8+rxbwrsvQkYEiabQVGH2DTWZShbCB5k1a0klMlACrNTsP3Qo3n22zmUPgwqDfKoM56726RbLK2LVZXerYEvJS41jV1V28ZWVLoantp0R9ucfVc7S6zm5gT3SV3EtMRo6AzYewS+2U/R0ro7xT+asTeWhM570rhg91IO7Pynfm57r+9AhnPLsEKIpTjv9CeQqq5s8mg5IPd5jxSeRdvaRg8V6I3rvVOFNVzGcpSdnlTQ90WFAHfR7cYW1zscKrdJOZWWlUTifNykf86T6BRFdMSUCvwry3tN7Nt7EHsa0m3UCKTirzHHBdIZe64x01r8PMhlAOidCI1srddUBj97uBmb5CyNPQfaK0QaWY13KjLbOMLPoL9OelCRhenf6pKg8O9A78L6Rk6M2JwhzphLwBNyhlXNzMhopMXZqKeiRkQvsMs4Tf9MWozRAZnHKP3Fio3N9Zyxzos+nyrfgndLnwAs3uNrrHWu8U01C0FZ3bW0qyGn88spOEpwovKPz3YCR/KUl5EU8buZ+Nt0HWqZt+A=
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
index 2949e5acff35..ba7ae6808544 100644
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
index 970e077019b7..345c54133c83 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -685,6 +685,8 @@ static struct kobj_attribute _name##_attr = __ATTR_RO(_name)
 DEFINE_MTHP_STAT_ATTR(anon_fault_alloc, MTHP_STAT_ANON_FAULT_ALLOC);
 DEFINE_MTHP_STAT_ATTR(anon_fault_fallback, MTHP_STAT_ANON_FAULT_FALLBACK);
 DEFINE_MTHP_STAT_ATTR(anon_fault_fallback_charge, MTHP_STAT_ANON_FAULT_FALLBACK_CHARGE);
+DEFINE_MTHP_STAT_ATTR(collapse_alloc, MTHP_STAT_COLLAPSE_ALLOC);
+DEFINE_MTHP_STAT_ATTR(collapse_alloc_failed, MTHP_STAT_COLLAPSE_ALLOC_FAILED);
 DEFINE_MTHP_STAT_ATTR(zswpout, MTHP_STAT_ZSWPOUT);
 DEFINE_MTHP_STAT_ATTR(swpin, MTHP_STAT_SWPIN);
 DEFINE_MTHP_STAT_ATTR(swpin_fallback, MTHP_STAT_SWPIN_FALLBACK);
@@ -750,6 +752,8 @@ static struct attribute *any_stats_attrs[] = {
 #endif
 	&split_attr.attr,
 	&split_failed_attr.attr,
+	&collapse_alloc_attr.attr,
+	&collapse_alloc_failed_attr.attr,
 	NULL,
 };
 
diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index 53e7e4be172d..13d82993755f 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -1068,28 +1068,34 @@ static enum scan_result __collapse_huge_page_swapin(struct mm_struct *mm,
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
@@ -1118,7 +1124,7 @@ static enum scan_result collapse_huge_page(struct mm_struct *mm, unsigned long a
 	 */
 	mmap_read_unlock(mm);
 
-	result = alloc_charge_folio(&folio, mm, cc);
+	result = alloc_charge_folio(&folio, mm, cc, HPAGE_PMD_ORDER);
 	if (result != SCAN_SUCCEED)
 		goto out_nolock;
 
@@ -1899,7 +1905,7 @@ static enum scan_result collapse_file(struct mm_struct *mm, unsigned long addr,
 	VM_BUG_ON(!IS_ENABLED(CONFIG_READ_ONLY_THP_FOR_FS) && !is_shmem);
 	VM_BUG_ON(start & (HPAGE_PMD_NR - 1));
 
-	result = alloc_charge_folio(&new_folio, mm, cc);
+	result = alloc_charge_folio(&new_folio, mm, cc, HPAGE_PMD_ORDER);
 	if (result != SCAN_SUCCEED)
 		goto out;
 
-- 
2.54.0


