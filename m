Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4EE17CCD1BB
	for <linux-mm@archiver.kernel.org>; Wed, 22 Oct 2025 18:38:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A5B598E0013; Wed, 22 Oct 2025 14:38:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A33088E0010; Wed, 22 Oct 2025 14:38:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 948FB8E0013; Wed, 22 Oct 2025 14:38:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 84E2C8E0010
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 14:38:53 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 50826C08CC
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 18:38:53 +0000 (UTC)
X-FDA: 84026611746.04.31B4B3C
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf08.hostedemail.com (Postfix) with ESMTP id 92CDC160013
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 18:38:51 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=h0YDLWwg;
	spf=pass (imf08.hostedemail.com: domain of npache@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761158331;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YBXOPDN0v9xDB640xhjn9Ed0fmNS5BjRlMDmeX+oVkI=;
	b=HpTJIZL3/iwdrfuFG0AIzjNb3+biAEPdORBW2pMitKPHFjdUKueDZPsU3mmDGfcjnYd20+
	HNGnWYIuTLPlucT3UCJqoTA3LFNu3h98+RHvukV1Awnmeuiz78MLaqkIjC19cvGHOOKDNt
	GdfR28flLUeqMuNB3UglHkhzte71VyU=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=h0YDLWwg;
	spf=pass (imf08.hostedemail.com: domain of npache@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761158331; a=rsa-sha256;
	cv=none;
	b=xCOySLLMLD6oa25SNLpa/UwscjOh6owaIOEA1ksGG6D+i7yoLJbZaimwcccZ+5sPnImQ/1
	2KxfeLPgIresaTqweB+8/IPR0JWWULtkjP/V/zE1Q/MAeFo8L85ZWNY2+OA6F54XmLHkU5
	EqrG9uew+esS5IndVr+U7D1yOPZus/o=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1761158331;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=YBXOPDN0v9xDB640xhjn9Ed0fmNS5BjRlMDmeX+oVkI=;
	b=h0YDLWwg22if6vzeC/dK9GZ6Pc+ECN/V9nAHOWORVN+S5vIR75gBgO07RGtyQ6RVqWHGOh
	YkDG3qQCQkugzzfHKkCZf7sB7Oa6tMguCMoZ4esS4GA4YH58K5rIKIpP2YM5Yc/lvztaOd
	/KGHeg+Hm2yDTZxrNeLSm9vZhtIIE/k=
Received: from mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-153-9BxQdaYtNci1k4WsNv73TA-1; Wed,
 22 Oct 2025 14:38:46 -0400
X-MC-Unique: 9BxQdaYtNci1k4WsNv73TA-1
X-Mimecast-MFC-AGG-ID: 9BxQdaYtNci1k4WsNv73TA_1761158320
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 568D51955EC8;
	Wed, 22 Oct 2025 18:38:38 +0000 (UTC)
Received: from h1.redhat.com (unknown [10.22.64.41])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id B979619560A2;
	Wed, 22 Oct 2025 18:38:27 +0000 (UTC)
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
Subject: [PATCH v12 mm-new 02/15] introduce collapse_single_pmd to unify khugepaged and madvise_collapse
Date: Wed, 22 Oct 2025 12:37:04 -0600
Message-ID: <20251022183717.70829-3-npache@redhat.com>
In-Reply-To: <20251022183717.70829-1-npache@redhat.com>
References: <20251022183717.70829-1-npache@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Stat-Signature: ar4z7cpp8jqyg6hr1s4e3ueni3ktznx9
X-Rspamd-Queue-Id: 92CDC160013
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1761158331-477486
X-HE-Meta: U2FsdGVkX1/NXzSKOENLYf9o20K+lV1ij/GjS9uhj8iEPqP77Zc1EwvF1Mg+lI2MmOjkHqIGNEAnZwIz5VHdy29DWi07JV/YLX+4hM4Ui8LO8/aDpzZspUWBY6bJNfqow/a7eNgcggI+BIvo9ynygBA6RpL2KnNvq2SaYyMhwV+xSYaYOIx8sjCIWsVBFmXHm5aHQ8yPTFPD/hNrurKF0TaJju1VBZNQmynPb5ZkZe7JDeL34n3xYFtB5Ut9kHZH3ip6379/tG0c4M4N3u7SJhq56IiCY6iDpJAe7xuXlc5S5+OnY/ix4utgVoM9Y4iqHBDuakn/w0AwzmCPhiCWnsCgYd+8eP67fPP3R8N6/y+Dk3W+z5/QzFOtgv3Xhbn53NJ4JjcsY+9UlZenK+XxtHt0v4nWy2PfBsygj/8ZJBhir7EcFcd9OB+mA4Kd2bczJ4HnVI29WrCimwyZiceGnh6lbMHsDdNd+TKnlqlmuRQGBD0/t9UWvdVEzcZFRe/HwaN5OEUofuAvXAv67EFTxBN7U8k1iCloYMfkMxieaG9CWAHTrFD0uuAj3X7CWXI1oo8IgiaifUzh46/3eKsYVQg9OHkJ4RsKZUMlfE4Pl/zUzgI8IXsgICtZbZjbpxcYhkz6ojVyhRBAI8k8SOlpNSuORd/EHE5SCV+2RnusJYzblwcUlHXNcxr9rK+HwrX8fRXbzoZQ1k+Fkwb93NDBfgOVpxxRD3PIXnXyLXpwV9SSsa5thT+1hnF2YI3ob7T6slDCDUoEkJz4bqdwvE2Wk/xyzNk98oxUxN6DRj/LX2VMQTxTnWBeHBuxz4lWuW8fUc9Fq6wBP4UFb00KY4YnBp9zHUbKyyRWbZWOMSoQxuCtVtyYxe3+1jg5sjJmai+jiFhJ4Kn2xQc/Z/kD+xIhKyOZooszywnENDRiLjec2JwoLiU35AQCXhBa/8Btb4+lo+CZe1Z8xv7cAtrL+fq
 /tJpvq2q
 iuez7qOy7tCiGQ/KW5mvX0qDAjNn4bmVGKcaXpkVJ2aZebmrdThRxl03rVVTa+PZDx0tQ3wGnWOorYiGe6n+IV0vumMD4e8Jy6JYJsGcCeb9auqqa5ufZpXigL4cjf74RqYdP6gERN/HDnYxBwKtvHhD6p9Phtn+WQVPqIkEehaYyjUUEvtnz7aQvSbaDbKNF1eBywC9SJpUGlWx3GaWQH0U2GT3M4wNZ0bKmvj4x+eiRUgnTeGOUlCjaQw0rOn9gFbirZgQqZIoTmorWqwibW+eYaSTFqatAoJhQLyr9oSyyA5ivXzi0Q/dJmhONBE8zn3iQW4d/B7OQ0wUVeQ7G0s9HBV8xpj3Pula6BZHoDuEdhtfffust8yKfl/ABYDmHwjOD4LL9D+fwfbp7kf0xmKoDpyN7jW938ygxzMiiVFxnonPRxA68+D39m+ljWPpUqX8JG4mZX+GyHLkX/A5VYjHHtEV8X+AtIRVO
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The khugepaged daemon and madvise_collapse have two different
implementations that do almost the same thing.

Create collapse_single_pmd to increase code reuse and create an entry
point to these two users.

Refactor madvise_collapse and collapse_scan_mm_slot to use the new
collapse_single_pmd function. This introduces a minor behavioral change
that is most likely an undiscovered bug. The current implementation of
khugepaged tests collapse_test_exit_or_disable before calling
collapse_pte_mapped_thp, but we weren't doing it in the madvise_collapse
case. By unifying these two callers madvise_collapse now also performs
this check. We also modify the return value to be SCAN_ANY_PROCESS which
properly indicates that this process is no longer valid to operate on.

We also guard the khugepaged_pages_collapsed variable to ensure its only
incremented for khugepaged.

Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Acked-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Nico Pache <npache@redhat.com>
---
 mm/khugepaged.c | 97 ++++++++++++++++++++++++++-----------------------
 1 file changed, 52 insertions(+), 45 deletions(-)

diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index 6c4abc7f45cf..36e31d99e507 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -2370,6 +2370,53 @@ static int collapse_scan_file(struct mm_struct *mm, unsigned long addr,
 	return result;
 }
 
+/*
+ * Try to collapse a single PMD starting at a PMD aligned addr, and return
+ * the results.
+ */
+static int collapse_single_pmd(unsigned long addr,
+		struct vm_area_struct *vma, bool *mmap_locked,
+		struct collapse_control *cc)
+{
+	struct mm_struct *mm = vma->vm_mm;
+	int result;
+	struct file *file;
+	pgoff_t pgoff;
+
+	if (vma_is_anonymous(vma)) {
+		result = collapse_scan_pmd(mm, vma, addr, mmap_locked, cc);
+		goto end;
+	}
+
+	file = get_file(vma->vm_file);
+	pgoff = linear_page_index(vma, addr);
+
+	mmap_read_unlock(mm);
+	*mmap_locked = false;
+	result = collapse_scan_file(mm, addr, file, pgoff, cc);
+	fput(file);
+	if (result != SCAN_PTE_MAPPED_HUGEPAGE)
+		goto end;
+
+	mmap_read_lock(mm);
+	*mmap_locked = true;
+	if (collapse_test_exit_or_disable(mm)) {
+		mmap_read_unlock(mm);
+		*mmap_locked = false;
+		return SCAN_ANY_PROCESS;
+	}
+	result = collapse_pte_mapped_thp(mm, addr, !cc->is_khugepaged);
+	if (result == SCAN_PMD_MAPPED)
+		result = SCAN_SUCCEED;
+	mmap_read_unlock(mm);
+	*mmap_locked = false;
+
+end:
+	if (cc->is_khugepaged && result == SCAN_SUCCEED)
+		++khugepaged_pages_collapsed;
+	return result;
+}
+
 static unsigned int collapse_scan_mm_slot(unsigned int pages, int *result,
 					    struct collapse_control *cc)
 	__releases(&khugepaged_mm_lock)
@@ -2440,34 +2487,9 @@ static unsigned int collapse_scan_mm_slot(unsigned int pages, int *result,
 			VM_BUG_ON(khugepaged_scan.address < hstart ||
 				  khugepaged_scan.address + HPAGE_PMD_SIZE >
 				  hend);
-			if (!vma_is_anonymous(vma)) {
-				struct file *file = get_file(vma->vm_file);
-				pgoff_t pgoff = linear_page_index(vma,
-						khugepaged_scan.address);
-
-				mmap_read_unlock(mm);
-				mmap_locked = false;
-				*result = collapse_scan_file(mm,
-					khugepaged_scan.address, file, pgoff, cc);
-				fput(file);
-				if (*result == SCAN_PTE_MAPPED_HUGEPAGE) {
-					mmap_read_lock(mm);
-					if (collapse_test_exit_or_disable(mm))
-						goto breakouterloop;
-					*result = collapse_pte_mapped_thp(mm,
-						khugepaged_scan.address, false);
-					if (*result == SCAN_PMD_MAPPED)
-						*result = SCAN_SUCCEED;
-					mmap_read_unlock(mm);
-				}
-			} else {
-				*result = collapse_scan_pmd(mm, vma,
-					khugepaged_scan.address, &mmap_locked, cc);
-			}
-
-			if (*result == SCAN_SUCCEED)
-				++khugepaged_pages_collapsed;
 
+			*result = collapse_single_pmd(khugepaged_scan.address,
+						      vma, &mmap_locked, cc);
 			/* move to next address */
 			khugepaged_scan.address += HPAGE_PMD_SIZE;
 			progress += HPAGE_PMD_NR;
@@ -2781,34 +2803,19 @@ int madvise_collapse(struct vm_area_struct *vma, unsigned long start,
 		mmap_assert_locked(mm);
 		memset(cc->node_load, 0, sizeof(cc->node_load));
 		nodes_clear(cc->alloc_nmask);
-		if (!vma_is_anonymous(vma)) {
-			struct file *file = get_file(vma->vm_file);
-			pgoff_t pgoff = linear_page_index(vma, addr);
 
-			mmap_read_unlock(mm);
-			mmap_locked = false;
-			result = collapse_scan_file(mm, addr, file, pgoff, cc);
-			fput(file);
-		} else {
-			result = collapse_scan_pmd(mm, vma, addr,
-						   &mmap_locked, cc);
-		}
+		result = collapse_single_pmd(addr, vma, &mmap_locked, cc);
+
 		if (!mmap_locked)
 			*lock_dropped = true;
 
-handle_result:
 		switch (result) {
 		case SCAN_SUCCEED:
 		case SCAN_PMD_MAPPED:
 			++thps;
 			break;
-		case SCAN_PTE_MAPPED_HUGEPAGE:
-			BUG_ON(mmap_locked);
-			mmap_read_lock(mm);
-			result = collapse_pte_mapped_thp(mm, addr, true);
-			mmap_read_unlock(mm);
-			goto handle_result;
 		/* Whitelisted set of results where continuing OK */
+		case SCAN_PTE_MAPPED_HUGEPAGE:
 		case SCAN_PMD_NULL:
 		case SCAN_PTE_NON_PRESENT:
 		case SCAN_PTE_UFFD_WP:
-- 
2.51.0


