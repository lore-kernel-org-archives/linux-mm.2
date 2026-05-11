Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1F1CDCD37BE
	for <linux-mm@archiver.kernel.org>; Mon, 11 May 2026 18:58:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 838006B00D3; Mon, 11 May 2026 14:58:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 80FEE6B00D5; Mon, 11 May 2026 14:58:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6FEC86B00D7; Mon, 11 May 2026 14:58:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 5CFA96B00D3
	for <linux-mm@kvack.org>; Mon, 11 May 2026 14:58:45 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 207188B82C
	for <linux-mm@kvack.org>; Mon, 11 May 2026 18:58:45 +0000 (UTC)
X-FDA: 84756050610.02.7FF8269
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf03.hostedemail.com (Postfix) with ESMTP id 18E792000E
	for <linux-mm@kvack.org>; Mon, 11 May 2026 18:58:42 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=QRz9dPcH;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf03.hostedemail.com: domain of npache@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=npache@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778525923;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AWM0A8g1VXtUsrVncoVe7opeISGydXfiM+Alh+OuQqk=;
	b=VncyRG3Vvz6LzQ7Gi8gIwnUA+UVUQC+ERkcbC57ScqSDdx/leUz34liwP5nBIql71JUbli
	10grixrhrP4865u04WDuSf0I++TE4XR5+2SeAV9GbS5YYsU7BEQDEDUnDmNGEzQCxo7ymS
	I5qpcacIPniVM+abWjwtPVFmGyxQXRY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778525923; a=rsa-sha256;
	cv=none;
	b=jgYF1ND/Vug3wDhkIMZwjj4jZnXGlJVCwWKxZF/n4tFjlLQw6Sw7QUQ2FBs5cfcVIQ0m5+
	QhrFF7ZzjvxfJ3CNHS7tW3LzOVfdnul2HRxNfFsYSQ5rxZPYTGk19mMFcQPCvklXoPY4KO
	Y7P2k1ZECiJrYBZ2Mkhf37b+JBK2eGQ=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=QRz9dPcH;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf03.hostedemail.com: domain of npache@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=npache@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1778525922;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=AWM0A8g1VXtUsrVncoVe7opeISGydXfiM+Alh+OuQqk=;
	b=QRz9dPcHosApkckkwiLKsTW2jtyEbAIvKKQLZf8s38Lwqu6Ask8VLmM2d3WwWJ0XVEFnpA
	3ED4HBNlsI6JOfvh2mynu41DqPRfPKAWvEesxwOiWUHsGTroLaZtAi3wH2Z7KGwU0xEyLy
	p9iyC0J9efjmhMc5ZNtFrFDJOl3wMTw=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-65-jFw7nOnQNzK-RHc1qlGwXA-1; Mon,
 11 May 2026 14:58:36 -0400
X-MC-Unique: jFw7nOnQNzK-RHc1qlGwXA-1
X-Mimecast-MFC-AGG-ID: jFw7nOnQNzK-RHc1qlGwXA_1778525909
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id D662019560B2;
	Mon, 11 May 2026 18:58:28 +0000 (UTC)
Received: from p1.redhat.com (unknown [10.44.22.3])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 347D33002D32;
	Mon, 11 May 2026 18:58:06 +0000 (UTC)
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
Subject: [PATCH mm-unstable v17 01/14] mm/khugepaged: generalize hugepage_vma_revalidate for mTHP support
Date: Mon, 11 May 2026 12:58:01 -0600
Message-ID: <20260511185817.686831-2-npache@redhat.com>
In-Reply-To: <20260511185817.686831-1-npache@redhat.com>
References: <20260511185817.686831-1-npache@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: xlYBaMDRNbiwiu6uc4lX2Q_QRNYluZYRP6HIlu_XIow_1778525909
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 18E792000E
X-Stat-Signature: ndd76gyua8tnc7pajotfcxwi3cjchfyx
X-Rspam-User: 
X-HE-Tag: 1778525922-491014
X-HE-Meta: U2FsdGVkX1/XD8Ez0kZdt4boM5TqJnVg/EWoTgteN3AJxvHltpPt0z5b7WRx2eCnUmyA9Hwb1psCWZYmkelIuuvQPbNQVhVrpneg8scB4f7HGyXgSJq/tcEFD3fqHUHOs+gDD+0L+PSZ/kjEpsfIGWRMAJZOumywg3e+43ILNkIX7Hj8lpGE3E0hLzHbnYZGJ9JV79E2WC0P0ge2EGZb1YGRz6XH/Ae7tCkxvPZgFQrW6dWh+GO+NRBoxPVSW4VIpfdrC3DQmb2JbMHXXFH4VKacvr2AZI8aSyWHXncmeSy6JK4cjM4wI8OzJroqbchQXGZPzpGMYgqFDY5cX9u3FmOGGue6Zc3hGTYwbka1sWsJqNVPzjNKTAdeQLVmwKD0rhTTHh5Efxjk2l4DPa4eoJEwCi0EdNz+49GMQWVjMmzfluhfC4ZsrMz53jaHHBesSq0paPyCBFLDONiz1Ao4da9YAl85pydjh3E3RxeD9nGsoN812QtwOfEePPn9Dj5h+uH0Yi71Httb6ReEmYzQWwKppVg8poy+dSr+Leg0i6wwkCLkyGqLG8nZwmRx0aTa69lz7D9bZyYe6AU57b1s0wVKOKiTpOWiCzkh8rjvZCzXG6XdoJOqQ40soSFj+edZNMWdpnU1uBGxR0dlSdBLE2X3AuVvIyQV/e+kmo3he7575sgdP+5Cjx/Oftc0ShMLVuspXnMwPxLamJv3DB+1c0mWH8+jYpbflwtCbUAXOB4HRdLMPcXecdlqiUisG82qUn59BTl0Y7zCXMv4Jot2c7B1gV1KqfDEyjldpSDck4v7qRJTQG3HPzJrZOx7ziVQwjrif7Lq6BpcA9wyc+TFc1o6Peb5DcIXwMs62tqmeng1bMSc1JPdCEeS9dAshcIFXZ5ZC+M3XSvPL9ZaTCcF9ZmAbT9urFMFQWxIL9IA+ukTSvQQbJK/pT48MDJl4S/CSPLajsS9vEf1q9Pk+Wy
 MPQv4Fh/
 IU/CWz7M0gihr+7lTM1ZNz6tttMmivevh7DbVUyK4hedadtihHMdNRopcD2UIoXXpThG/1XITXxMlPQ4NBBK5pVzXqQCf9NkQDj1IMs+67CI7rx38hQug9cYVBpFzpArAvMgbb1mj+QDFtTOBMNLz7IJ6vVi7bK+kDmX6sB6vaAzSjhCgIoeq3nVEM62VTDlgFtP5lnZVNIQAyV9dCyyY0JoyiCDpNKdmMvQvmnGKBDkUJ1NBhglTazLl1E0efEpHbYK24LS24FiJWAOuQTdGfcidDu1x8bvyAEDDsi+U0244nqXjRNZ95UvO3O3rK91Jon0Ih+lDVNssGIqVbgGMymeTX7PXstTn3XfAXqQE4lLQTtRzS8+T8vZAuBxHx3aEFjomSdb82VIbnPsRMurbz1kFNlQCKhznPrCdDL4IdnrMR8/xykDVxNI955KoV20zVirzKTUWzkhmZABNn/Blwc2XE26y6vPUzXtqzv+10YBOf053wOn7ss9WFAJoSHCecxC4MemTkPbgmXJ02m05bhkXV1G8/lfDMB2ZvJwi62Jy0ubk7bF8GMzDss4XCpqCgnR/MylhEeyDyW3hV04FC4leVP1vlFAWlPRu/YIoZu7cd5I=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

For khugepaged to support different mTHP orders, we must generalize this
to check if the PMD is not shared by another VMA and that the order is
enabled.

No functional change in this patch. Also correct a comment about the
functionality of the revalidation and fix a double space issues.

Reviewed-by: Wei Yang <richard.weiyang@gmail.com>
Reviewed-by: Lance Yang <lance.yang@linux.dev>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Reviewed-by: Lorenzo Stoakes <ljs@kernel.org>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Acked-by: Usama Arif <usama.arif@linux.dev>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Co-developed-by: Dev Jain <dev.jain@arm.com>
Signed-off-by: Dev Jain <dev.jain@arm.com>
Signed-off-by: Nico Pache <npache@redhat.com>
---
 mm/khugepaged.c | 20 ++++++++++++--------
 1 file changed, 12 insertions(+), 8 deletions(-)

diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index 28a843f30b32..979885694351 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -902,12 +902,13 @@ static int collapse_find_target_node(struct collapse_control *cc)
 
 /*
  * If mmap_lock temporarily dropped, revalidate vma
- * before taking mmap_lock.
+ * after taking the mmap_lock again.
  * Returns enum scan_result value.
  */
 
 static enum scan_result hugepage_vma_revalidate(struct mm_struct *mm, unsigned long address,
-		bool expect_anon, struct vm_area_struct **vmap, struct collapse_control *cc)
+		bool expect_anon, struct vm_area_struct **vmap,
+		struct collapse_control *cc, unsigned int order)
 {
 	struct vm_area_struct *vma;
 	enum tva_type type = cc->is_khugepaged ? TVA_KHUGEPAGED :
@@ -920,15 +921,16 @@ static enum scan_result hugepage_vma_revalidate(struct mm_struct *mm, unsigned l
 	if (!vma)
 		return SCAN_VMA_NULL;
 
+	/* Always check the PMD order to ensure its not shared by another VMA */
 	if (!thp_vma_suitable_order(vma, address, PMD_ORDER))
 		return SCAN_ADDRESS_RANGE;
-	if (!thp_vma_allowable_order(vma, vma->vm_flags, type, PMD_ORDER))
+	if (!thp_vma_allowable_orders(vma, vma->vm_flags, type, BIT(order)))
 		return SCAN_VMA_CHECK;
 	/*
 	 * Anon VMA expected, the address may be unmapped then
 	 * remapped to file after khugepaged reaquired the mmap_lock.
 	 *
-	 * thp_vma_allowable_order may return true for qualified file
+	 * thp_vma_allowable_orders may return true for qualified file
 	 * vmas.
 	 */
 	if (expect_anon && (!(*vmap)->anon_vma || !vma_is_anonymous(*vmap)))
@@ -1121,7 +1123,8 @@ static enum scan_result collapse_huge_page(struct mm_struct *mm, unsigned long a
 		goto out_nolock;
 
 	mmap_read_lock(mm);
-	result = hugepage_vma_revalidate(mm, address, true, &vma, cc);
+	result = hugepage_vma_revalidate(mm, address, true, &vma, cc,
+					 HPAGE_PMD_ORDER);
 	if (result != SCAN_SUCCEED) {
 		mmap_read_unlock(mm);
 		goto out_nolock;
@@ -1155,7 +1158,8 @@ static enum scan_result collapse_huge_page(struct mm_struct *mm, unsigned long a
 	 * mmap_lock.
 	 */
 	mmap_write_lock(mm);
-	result = hugepage_vma_revalidate(mm, address, true, &vma, cc);
+	result = hugepage_vma_revalidate(mm, address, true, &vma, cc,
+					 HPAGE_PMD_ORDER);
 	if (result != SCAN_SUCCEED)
 		goto out_up_write;
 	/* check if the pmd is still valid */
@@ -2858,8 +2862,8 @@ int madvise_collapse(struct vm_area_struct *vma, unsigned long start,
 			mmap_unlocked = false;
 			*lock_dropped = true;
 			result = hugepage_vma_revalidate(mm, addr, false, &vma,
-							 cc);
-			if (result  != SCAN_SUCCEED) {
+							 cc, HPAGE_PMD_ORDER);
+			if (result != SCAN_SUCCEED) {
 				last_fail = result;
 				goto out_nolock;
 			}
-- 
2.54.0


