Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2E956CA101F
	for <linux-mm@archiver.kernel.org>; Fri, 12 Sep 2025 03:30:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7E1656B0007; Thu, 11 Sep 2025 23:30:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 791A06B0008; Thu, 11 Sep 2025 23:30:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 659FA6B000C; Thu, 11 Sep 2025 23:30:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4E5FA6B0007
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 23:30:02 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 1B933BA668
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 03:30:02 +0000 (UTC)
X-FDA: 83879169444.26.D599844
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf02.hostedemail.com (Postfix) with ESMTP id 67C8080008
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 03:30:00 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=fdg8z1Br;
	spf=pass (imf02.hostedemail.com: domain of npache@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757647800;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8/zPLf+eIzOBCmqNcyV6l1/de0O/nJtADzIVrStQZTs=;
	b=Hwvc79N2MF6lEQoyx7IKHF72gGm2Zy2GdknGgN+85sOOH6cZRKs6gHdtFLao3vkH3bdlkV
	DGJ8r5gyHJmP0KVLpl5DMTFylHePoSSTXqEGJt73YkGAyf9bWUhoxvP/aRtkXCPS08tOug
	A0vYwbjjVzIDE4JkQtqib+V46E8FxZI=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=fdg8z1Br;
	spf=pass (imf02.hostedemail.com: domain of npache@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757647800; a=rsa-sha256;
	cv=none;
	b=6b/Xv+D0dpmU5iydcfqUikTeumvDgo+akhh4+huxy9xkB3qG0ZFnIOFseQqvcxjYMFzF/7
	spCvTfcwFoXTdwSf/g2W25/RPHI4kiGcJ8VT86Uj1zQkZvOIFmHb0W8vZ00EoNF1i6RFEy
	NOLVIQ4fbEtO2nScBj/cuhdA171lfJQ=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1757647799;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=8/zPLf+eIzOBCmqNcyV6l1/de0O/nJtADzIVrStQZTs=;
	b=fdg8z1Brow1/CDhmT5msnqcRzVq8XG4nNupYggu0SDWg5kOPeUYNFNlmpxC6m82/HhbzqW
	DDghgJLyyWkVFEnn0dbDoPW+W7KscBGqnMI9TegAKe3p6Tt4GlHznHZ+NMXpdPN5ermrRZ
	R/Ld7rQHdIJmAdSq5hJ9SmReIv7y0Ks=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-119-lRdZ3CZoORy9VQvj-Uv2-w-1; Thu,
 11 Sep 2025 23:29:55 -0400
X-MC-Unique: lRdZ3CZoORy9VQvj-Uv2-w-1
X-Mimecast-MFC-AGG-ID: lRdZ3CZoORy9VQvj-Uv2-w_1757647789
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id A79BD180045C;
	Fri, 12 Sep 2025 03:29:48 +0000 (UTC)
Received: from h1.redhat.com (unknown [10.22.80.28])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 5C5AE180035E;
	Fri, 12 Sep 2025 03:29:39 +0000 (UTC)
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
Subject: [PATCH v11 03/15] khugepaged: generalize hugepage_vma_revalidate for mTHP support
Date: Thu, 11 Sep 2025 21:27:58 -0600
Message-ID: <20250912032810.197475-4-npache@redhat.com>
In-Reply-To: <20250912032810.197475-1-npache@redhat.com>
References: <20250912032810.197475-1-npache@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Stat-Signature: y3apyr6t18sj4c47cwc4nxh433y5y847
X-Rspam-User: 
X-Rspamd-Queue-Id: 67C8080008
X-Rspamd-Server: rspam04
X-HE-Tag: 1757647800-627467
X-HE-Meta: U2FsdGVkX1+wCRzhvaMtMpAkVjpIglXNWt0lS/QuHFHhBoLffdc4fvFfIiyeQGI0I8fVL61AC4reZH9HnR1A2mvbfLJBT53oFY2GLymfrNTPs6HqcxKDNNv5axDGmfNuEL4UAo6HuWV9A1+OkVfogX4rw/s1wu9XdBuk9esnzS+ffD55q6V0hbQu91D0mSbcqIpCESZQ5IAJoLb0k0J7bg0OWh98lmjGO/DRkjyjL/Ll00M+e6v5P/OypYynGEKzyaU7w/b3ODyl2OgADcCISlW2b/HzGpT0/2sHlidUo8cwjIwfR79E9Vd0BCGEzSUmNHY8vDOaYpcn7Cv+nXcwHypl24LuS5cHpkznb8jPbVBtRKNAO+Qd2b2HAHO0ZcTrvXbL8saajkJRsptX+n0HjM/SpfrfWQSwdgvDWR53iMmk6abNH8lsd+SjfTYr9Mz3cXVkfqFhcbBFcYHMMd95NFdWmCQJy2PQ5ndy4wWe34Stv90upK3tcmQURiILxJx8f5pqrer9R0d54gALPBjUZkRp+HPEg8fx8tA5oaDTZE/5wMbGFfoXd8TXabBXZQYjBStJ2NwJ75yiRF+9r1vySri8H6C2+wnjDNMioCwLi9RpP087Fsuqy1rJuS+6IAK8XJ8v5JL7qv5+JlcKUWNkU8GAoS1P4f9NNj09Xvjuz5N6Ub2kvyoDzT0rfcndqdJw8JbdE7/NpKswyqBDmzd+iZ/MT8HwV8KOnSQMuBHbzQaKLLqaoKg49pBsSTdeEyR7eFrkLqn6fyTAcArJ1D1G9HGY6mGQosFvC8VIuPxRt1dBtcFGuR9PcWIG+ta3lO9FTUzTVqQup9CturQb5GmaFgYPy7uql+wxOoAmUEPtXQP/3ltBd+2hNMKY64ba850biPMmX2QougPcf4/C269t4qwxCLW1mz36hbo9kK10i5I69a3E69waEJuT+w/2nAaQhqe4l0ZsvYe+A2L0NR/
 acgLOEn/
 +JqZioEeUTEpKDo9SqTnEC8RIxK5lGOq7VIH7nD+I6jT+OsKo0mZVAl3e30JepRt2Bhy/fmUWYAxCnrA8f7+LlkzZWiHmad30wxJkRXtYo0hSakuiVIGiyyr9kUNvaCiaDQSqohd5ylTwt0dMs+B7bSzScywvM+UFdpF9FsIx6DWhE0uLXmu4Yewc7eFpC4O088S69hdxfsPggt9sVf+RFMD7R/JS7z2iHWK98pkHPwyrSW/muwdQsXPE2YgeMPgS9QaQacxa2H/+ZiMMFiGugfaTdEM4rBD9PmjnlUkIU+K6MIvDXLPR7oV2pvcyKxc/LjOmrE/0rwaROPs6rc3uOuhf5ezSJluVHRXQgzCWyJp7AyEORx0xGqrsVBkPrcsX03b+t61XjXOIrbvDLgmD+MkvJBw+Ut3ZxdNlCKxjEVSLN8Vawvxa3kl7rtfvig+JkFBWsTyPnwAUGjaZI1KOvJuI/j031TyVOP/dxiwE2j6Y9HMttlVkpNPasowOZEFzZrYhyq5bDVzGTnXIOKFNhAlPWGJ8EWwBwZF5uUdB0NFsyO01bzNSngvD9Q==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
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
functionality of the revalidation.

Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Acked-by: David Hildenbrand <david@redhat.com>
Co-developed-by: Dev Jain <dev.jain@arm.com>
Signed-off-by: Dev Jain <dev.jain@arm.com>
Signed-off-by: Nico Pache <npache@redhat.com>
---
 mm/khugepaged.c | 20 +++++++++++---------
 1 file changed, 11 insertions(+), 9 deletions(-)

diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index 63d2ba4b2b6d..6dbe2d0683ac 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -903,14 +903,13 @@ static int collapse_find_target_node(struct collapse_control *cc)
 
 /*
  * If mmap_lock temporarily dropped, revalidate vma
- * before taking mmap_lock.
+ * after taking the mmap_lock again.
  * Returns enum scan_result value.
  */
 
 static int hugepage_vma_revalidate(struct mm_struct *mm, unsigned long address,
-				   bool expect_anon,
-				   struct vm_area_struct **vmap,
-				   struct collapse_control *cc)
+		bool expect_anon, struct vm_area_struct **vmap,
+		struct collapse_control *cc, unsigned int order)
 {
 	struct vm_area_struct *vma;
 	enum tva_type type = cc->is_khugepaged ? TVA_KHUGEPAGED :
@@ -923,15 +922,16 @@ static int hugepage_vma_revalidate(struct mm_struct *mm, unsigned long address,
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
@@ -1127,7 +1127,8 @@ static int collapse_huge_page(struct mm_struct *mm, unsigned long address,
 		goto out_nolock;
 
 	mmap_read_lock(mm);
-	result = hugepage_vma_revalidate(mm, address, true, &vma, cc);
+	result = hugepage_vma_revalidate(mm, address, true, &vma, cc,
+					 HPAGE_PMD_ORDER);
 	if (result != SCAN_SUCCEED) {
 		mmap_read_unlock(mm);
 		goto out_nolock;
@@ -1161,7 +1162,8 @@ static int collapse_huge_page(struct mm_struct *mm, unsigned long address,
 	 * mmap_lock.
 	 */
 	mmap_write_lock(mm);
-	result = hugepage_vma_revalidate(mm, address, true, &vma, cc);
+	result = hugepage_vma_revalidate(mm, address, true, &vma, cc,
+					 HPAGE_PMD_ORDER);
 	if (result != SCAN_SUCCEED)
 		goto out_up_write;
 	/* check if the pmd is still valid */
@@ -2797,7 +2799,7 @@ int madvise_collapse(struct vm_area_struct *vma, unsigned long start,
 			mmap_read_lock(mm);
 			mmap_locked = true;
 			result = hugepage_vma_revalidate(mm, addr, false, &vma,
-							 cc);
+							 cc, HPAGE_PMD_ORDER);
 			if (result  != SCAN_SUCCEED) {
 				last_fail = result;
 				goto out_nolock;
-- 
2.51.0


