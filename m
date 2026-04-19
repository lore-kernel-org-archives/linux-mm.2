Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 55703EA71A2
	for <linux-mm@archiver.kernel.org>; Sun, 19 Apr 2026 18:59:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BF9ED6B0338; Sun, 19 Apr 2026 14:59:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BD1C86B0339; Sun, 19 Apr 2026 14:59:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AE7EB6B033A; Sun, 19 Apr 2026 14:59:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 9E6636B0338
	for <linux-mm@kvack.org>; Sun, 19 Apr 2026 14:59:27 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 35EE81A07AF
	for <linux-mm@kvack.org>; Sun, 19 Apr 2026 18:59:27 +0000 (UTC)
X-FDA: 84676218774.04.66B7F76
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf02.hostedemail.com (Postfix) with ESMTP id 49A0C8000B
	for <linux-mm@kvack.org>; Sun, 19 Apr 2026 18:59:25 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Qd9r5h7U;
	spf=pass (imf02.hostedemail.com: domain of npache@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776625165;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9q2oERcjlj7R4rFcsbNivHzvRliiiDrWRWufI9/VkAY=;
	b=Uc2hXP9X65FMHQ5KPX0jcV+FClyAs+3scJ3keC8E9KE/cjMSPdwEamja8IVh66ydT9zOVj
	k6zzd06xydSmV1jQjg/bShArMEsygEwJ1LIOnRGgV31zuaTAOBZN9dZ2n9VyeyJ3QccrJh
	/JE52YBZCFqSe8hcydl07JU4eeEU/3c=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776625165; a=rsa-sha256;
	cv=none;
	b=bc6sYL7QS/fLpnsFrdj6Szm7ZyLB5ArybPnuC64ItU0UGw3F2hC3a/z0dLikAiwpARCHL/
	0/6hF9Dhh302/qRxCFqbXPrl3xJYPW4IWKuLDAmrzpKNVBBAdKuJPlpqrENcYsdf3VJDOA
	uR3fwAH0Pl9tljwjiOe82rdg+ICwXPE=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Qd9r5h7U;
	spf=pass (imf02.hostedemail.com: domain of npache@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1776625164;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=9q2oERcjlj7R4rFcsbNivHzvRliiiDrWRWufI9/VkAY=;
	b=Qd9r5h7U3pKUKve8qHoZhedj0lJQ+YVqwF1I4WuwPGZ64JH11dlILZQEoT5RnL9Jh2Kr5X
	w1M3ouBGllKi+Pdg5TQrEZHVcZMtCrVOkMfB55mSOGc3Xh4XITjVH/TxTdqN8dqx6jHusq
	+KXxL7DsLB5Q5x2u9KffiGr/EJccSH4=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-468-a0U2vqlrOVKMNaC29x316Q-1; Sun,
 19 Apr 2026 14:59:21 -0400
X-MC-Unique: a0U2vqlrOVKMNaC29x316Q-1
X-Mimecast-MFC-AGG-ID: a0U2vqlrOVKMNaC29x316Q_1776625156
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 6AEB61800345;
	Sun, 19 Apr 2026 18:59:15 +0000 (UTC)
Received: from p1.redhat.com (unknown [10.22.74.5])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id D0CD51956095;
	Sun, 19 Apr 2026 18:58:56 +0000 (UTC)
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
	zokeefe@google.com
Subject: [PATCH 7.2 v16 02/13] mm/khugepaged: generalize alloc_charge_folio()
Date: Sun, 19 Apr 2026 12:57:39 -0600
Message-ID: <20260419185750.260784-3-npache@redhat.com>
In-Reply-To: <20260419185750.260784-1-npache@redhat.com>
References: <20260419185750.260784-1-npache@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: SNR9_xMuGt8zYYBlifvkJC2_QznQd66yj9DtToH4Ujs_1776625156
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Rspamd-Queue-Id: 49A0C8000B
X-Rspamd-Server: rspam07
X-Stat-Signature: 9stwbknq9hcpg7z78zyfmg4my1z9w4ti
X-Rspam-User: 
X-HE-Tag: 1776625165-626182
X-HE-Meta: U2FsdGVkX1+jAFz9ztSzdRJL1djguFEwtYovgyYJ3b2188fxFe4dFix+kK93FD3uGYK1Lr7IOkyZxlUeYH48uN10ThWGuz5tUvKervzKA91Hrvpb3NFgwfUthbW6ueQdtgBxwRxT+Q4zaVnnQN85ZucV+XvdYktznuzZtiYT7SL4jwAYYrrBRiiQVxm4aNMB/nf0PsJUtM/l/utjuvZbEPAXiQ47KgHD62HSeDA4eUccsOqUyOmsZ/yuXoDGGTOdK9rHWaDUNZobkPOnKMAahWFCIvB0DSaiacRQ1nEZ/o8cpj81Hd2fVLZmlI2D/vo6MMqvj37M+XQYv/t9nDDjVibGnuMermisSMhIYYcV1jsgzzLduYeDJjUhDow19WSdxW/W+DlKrbW6+m0m98N8ASGgobkHICt0wqq+PKWFLjAFvWR+sRm7cTw9KYwBu7b76AwkEd2NxsDKD5UoFVN+fALzrJDM+6HiwFgYi7NrxmvYs8Nx32Rvso0l0at065hHRq5aXiDCKbnGIrbJOx+rkRIiIjHneWo1dCu5XmYhK/xvJ7rhDEcu/M4vS0IyrK8FxgIPA/IVURlOpq6Et2Xrk6MA/sZg1mF67OKzCDu6cKIB47GnmyFUre3ha3i4FKaz/VssAMboxfPvu+Nl2SMWVxrRqlEpUydDdDj3T6tqNEIJar8GVkKtEDh5oANnW6aOwcMo3aD9gBFx9vbkSDrcJ673cjSc+nxLCL7QSjLhw19cqofyOKTYeNcbKRfAZudfOn3k90F8Ypdf9tmCr+0Bi6RoY7aDx+Qj5CooCS3k1c0mXqYx3ZIF5lXfdCL6GHvbkj2UU3palsKEukwV6ot8Rd/zDMuRZkadX9wTj6dgokoC8o/I9NLKoRIFeXuVkZs2TICa4XqljmcRNsaVvjOqmtmlTKPwXagkkptep63WeN9hx37AZgwwKRXYenN8cHGXrF7JE0D6MtwbHt45v96
 +k/1miBY
 miw5POJyz4XfkCrMid/or6Vo95YpZuayYIj1J38kBndNSUI/PRPEqI/IqD4iREBCKqspibceEVUBsvcS5hmZU2ZXaXMfSQmAyNtQZTaiQJq3P15bpAFAm66+qO7oSEHXZVRSLw6T9sRNtuJIn+v1tJagMvXBSNUS4JeXPAYbwmpXVT6CTymGOg0NKqaQiCXY+1YZ8+sWWLCw2jAijlrd8M0pDBvC2mMbTrDNp3wvTGpyfGXImZBR+ookSiokEhsj9rgNN7QSd1Z21zFkkv/VKoGv6hhZ0PyKVlUORU6END3/ELebo/2JpU1bk1haJrD4x6S7TuBvpkt+zZJH67FaTCzeJm/qlKYQSHBAhlHR2jmfTEZhJ5XSGPUoP3LjrhyZcBe7jJaG3kTz/V7DV46kDt/hQ2fLm39TpCa1DXFYyn+iTaxOOOzHBenhvTVhnHinulbT1tgA+Yju6rOaZJHjQGmzxs0R8d8KpDHnU0PxOrhIBSyBekHVDd6XTtm5a5o61/dxugw+y2Gu4hGRAFSpvdZIKGIiRfTUFVAn7KVYIaFeGZ3dOkZiAf9UiZ4s/rUPXpyk7GZ9tzRFStDgQ/WFq7beTU6zKPSEVzf3e7coeo2L8LHQ=
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
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
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
index 53e7e4be172d..afac6bc4e76d 100644
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
2.53.0


