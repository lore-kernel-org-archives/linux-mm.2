Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 722F2CD37BE
	for <linux-mm@archiver.kernel.org>; Mon, 11 May 2026 18:59:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D8FBF6B00D5; Mon, 11 May 2026 14:59:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D67CE6B00D8; Mon, 11 May 2026 14:59:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C573C6B00DA; Mon, 11 May 2026 14:59:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id B2BB66B00D5
	for <linux-mm@kvack.org>; Mon, 11 May 2026 14:59:04 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 5EBC7A0233
	for <linux-mm@kvack.org>; Mon, 11 May 2026 18:59:04 +0000 (UTC)
X-FDA: 84756051408.21.78AB8A2
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf27.hostedemail.com (Postfix) with ESMTP id 65F1A40012
	for <linux-mm@kvack.org>; Mon, 11 May 2026 18:59:02 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=YL0FBkrr;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf27.hostedemail.com: domain of npache@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=npache@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778525942;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/JPhj187Ku2FVbQi3OvFBdfXRG+B//yS9Kn6+Z/JjyA=;
	b=VNht4y6hONoAG79QT9YZPNZrtVGAJYEMmiiq7P6CWl9L2OSW972My1aattIAUxcnIWBfDZ
	v4o1bedcC9pWl6VQo8vus7zA3aAJGpfkuG6Nvn8Mr0PT2WuENDboF96DzOCOn/m+8ksyok
	74K9DAWvWLswoJfRok1eCIWu2VBtq+4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778525942; a=rsa-sha256;
	cv=none;
	b=i3Ra1zj0gX9m6m3+RInWS6fi+Ee6O1412nK3jjB5EcIMJZzSj1ldXcJNo6aCAuGniJSBFo
	RschO5C7wnbBbCgE4k2WWcfrJzjm8UEO5XUk2bkDBgKj+oShZdDIlT3En2Nr1/tf6ZJed2
	REzVbjMmuEB5MjQ0hcvJP9jGBrj6FqE=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=YL0FBkrr;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf27.hostedemail.com: domain of npache@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=npache@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1778525941;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=/JPhj187Ku2FVbQi3OvFBdfXRG+B//yS9Kn6+Z/JjyA=;
	b=YL0FBkrrLnqfqQjqwQjlJ4BbT/9elcN0ZmFdkfgCqo2XF7wjBipIJBFWmsqOTuWMdwwTbw
	4GtV+Y7Lrd9YXL7O0Plpbcu2HCTsxdixYEzOwx5EybCdd5bOxEh2fdy23XU8CMSUBXpQyt
	4FnSqrcgCqTEEHhf/QIxjnPgg3K+dzE=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-103-k5A7GUWlO3e5qs-ZP2yYTA-1; Mon,
 11 May 2026 14:58:55 -0400
X-MC-Unique: k5A7GUWlO3e5qs-ZP2yYTA-1
X-Mimecast-MFC-AGG-ID: k5A7GUWlO3e5qs-ZP2yYTA_1778525930
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 13FE918002CB;
	Mon, 11 May 2026 18:58:49 +0000 (UTC)
Received: from p1.redhat.com (unknown [10.44.22.3])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 67CC630001BE;
	Mon, 11 May 2026 18:58:29 +0000 (UTC)
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
Subject: [PATCH mm-unstable v17 02/14] mm/khugepaged: generalize alloc_charge_folio()
Date: Mon, 11 May 2026 12:58:02 -0600
Message-ID: <20260511185817.686831-3-npache@redhat.com>
In-Reply-To: <20260511185817.686831-1-npache@redhat.com>
References: <20260511185817.686831-1-npache@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: rYZLxRv36vRxw4ENISAaGN0XtQ1HzN6EJo3rKSb-p70_1778525930
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Rspam-User: 
X-Rspamd-Queue-Id: 65F1A40012
X-Rspamd-Server: rspam04
X-Stat-Signature: 434xpnpfobt77hhmd8jytedubfkhucp1
X-HE-Tag: 1778525942-251533
X-HE-Meta: U2FsdGVkX19LYPUAFt19zd7EjTf3oM9nm7EKn8JSlXFq7sT9EEtc7SwEA6hJeqxLTY/SNQHcSBda40SBEkDHzvLm/G5llk4HRtWzGPu7Wz2b4eLhfB7d2ZGvSATjYZxlVkEJOxz+lVpcS5yOY6wWMHcm4LsE1DTO7Ro7qxwvNhlIrjFljd9QgXEVcbyekxE2BPlI79yf/gqxTNnS5Ymcagr7guYIo/weBMr5BqbWg9i+IjimssafVeLsTDQxC5/xGRa4XanFZyLsPzli7jQuSpR/C1MRoMfDiUn4ZM+3sn2GNCRN5VOuJBVJUHCOJwNrPhTEl/H5UyCwpYy4a1lVj7sSNkO19fDNveL/HGSSc9RjQ+GfXuTCc9WKP+DyD9r7m6/zCPODvkutQeK3YYruQUGntrUcx2sFgUmqpg65flfkQLkB1TlGVkWWQK81rFfq5RgM3w9aHpMY3WXXtskLDzJJRYH928dqDTeA7IkUwZHKOWgcWIDohX8jS7uDqkfdbRTaUBUcMh+88HTqV/FmLyO+GD5k5aUym3XSDdCsoYZPjzOGYvsFMUGqoULfelGK7bL/ag/pHRLt440K1QWHzF6MrbL+bXaPDPun1Z8sF6vckekW7N8LSBpwpynmyPd2CPP2ENP4WcuWZfA96+fQ1n2rPIOVxsrgWrizxL/6VKaJKNG2gwnibnRABKfJuezM5CwekWuX7j/RTnOeSpDV7vAjQlOOFT77fDt6cLG9oUgNbP5ioNfQAfNCb2tqEW5jzsIMeEkuovuKZuOWheZpMbTdyPx4IEqUizIauRLr5qwl9NrszDxgdcPS9sdlNbi4gPJr2yD07fui9imBQ3IpvEy9fY+v1gbS3x1M/H3pOaycYomZvujMsYvkcUc0AXjAOG+YJg9PRYH2ndaop0ZyUEcf6Qsm9737/LF8Ug1N4E5Easzoow54tGfVzbXvc8C36L+SF5LOl7a6G+/+eOx
 7wamOAiE
 5GiHFjeOMIccKlxbLGHlZZb/O7+JJt0GerNux2IUyL4wXgsTO0nmeX+LsYKlawElvA81eyKEmxcLFEA3Z8pLJkAo0YdlmcKLUMTNAbxHg4x/gbz7SogJ4SAa/50fFEPOBaqTAPeivcqJUGQpjfcl+MEpmxWhFR/J+aEGyjdRQkW25/Z/LC054FbTnEG+pTHdxFR4Y7U3BohhJp7/ssmvI95yNDf39hKq32ownNagVMAsKaIi8ofpywu/aC62CHCSm5rfLsqwKeGvNRcAg/Fvhvaip9YXFJDOk+PDGwB5qPcZ2M2r0NS5VJlCpSWATdFN/a4M5BP+lRTOOGVQjVM0+I+3UnQZaaK3E3AcwEmxHZeaE1No4UYXvww0KcqWhWRRBVq1OfEFIkFMo75n+0fK5uHt3eLDmKJbSPWfMAIe0AtZa4qSrZJMF89cQ9wcOHi3b6HiV3ZD9MWtM/VSflJuLQk/6cAQoCXA/YOKOjUIpCOEJXFz6AmsViBwyXb3aTHHvmEmj1zRJYjSsSnHaF8PHq9voVeCspuc6ujI03ACWBNeuNtXxz23+lGrGGEjIvJlIXl4AKeYnEo7WjucR5jSqKndD9879XjO+4TI8FL/3+IAwTg4=
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
index e9d499da0ac7..05f482a72a89 100644
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
index 979885694351..f0e29d5c7b1f 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -1068,21 +1068,26 @@ static enum scan_result __collapse_huge_page_swapin(struct mm_struct *mm,
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
@@ -1118,7 +1123,7 @@ static enum scan_result collapse_huge_page(struct mm_struct *mm, unsigned long a
 	 */
 	mmap_read_unlock(mm);
 
-	result = alloc_charge_folio(&folio, mm, cc);
+	result = alloc_charge_folio(&folio, mm, cc, HPAGE_PMD_ORDER);
 	if (result != SCAN_SUCCEED)
 		goto out_nolock;
 
@@ -1899,7 +1904,7 @@ static enum scan_result collapse_file(struct mm_struct *mm, unsigned long addr,
 	VM_BUG_ON(!IS_ENABLED(CONFIG_READ_ONLY_THP_FOR_FS) && !is_shmem);
 	VM_BUG_ON(start & (HPAGE_PMD_NR - 1));
 
-	result = alloc_charge_folio(&new_folio, mm, cc);
+	result = alloc_charge_folio(&new_folio, mm, cc, HPAGE_PMD_ORDER);
 	if (result != SCAN_SUCCEED)
 		goto out;
 
-- 
2.54.0


