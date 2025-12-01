Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D2C38D116F3
	for <linux-mm@archiver.kernel.org>; Mon,  1 Dec 2025 17:47:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 306196B0088; Mon,  1 Dec 2025 12:47:54 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2B6F06B0089; Mon,  1 Dec 2025 12:47:54 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 17ED66B008A; Mon,  1 Dec 2025 12:47:54 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 02EF36B0088
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 12:47:54 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id ABEEE131C2A
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 17:47:53 +0000 (UTC)
X-FDA: 84171635226.25.24A8FFB
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf09.hostedemail.com (Postfix) with ESMTP id F34ED140011
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 17:47:51 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Lr0mQMf1;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf09.hostedemail.com: domain of npache@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=npache@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764611272; a=rsa-sha256;
	cv=none;
	b=f4ZB2PNswI01K0/U/hKp4jmiGp3shMXVY+m/w2qYjRf2uTkKsq3LF+K+31IC0DwOKAHKwN
	j9on+4Uazi57hG3JJ2xkFBXuovoPcBix7BO/mNtS8R/TSrpENw60DcqFx8QkIuwlgAa3eB
	465rbfSKEGpvxF5EPylf8BWo1z7/8Ts=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Lr0mQMf1;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf09.hostedemail.com: domain of npache@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=npache@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764611272;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yKXW/K7ymjHyGKDCTJy4JYNyA0BeZsYQVRnAWbMmZqM=;
	b=P+PVHkg6NsJGv0itswmuH/vaSF79SbUrt8+Aldgymv3RjJ56ycv5uAhOucweGEjpNwrJlM
	9UteEGLw+G/KcAhpqT1ZeBF6JVwqiwNEWrTJh1C9vKy7Ox7jJ3G5aFXXfZGtVwUae5Brts
	V+JKv4jNshII7y5SykWeErCveq/Owj4=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1764611271;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=yKXW/K7ymjHyGKDCTJy4JYNyA0BeZsYQVRnAWbMmZqM=;
	b=Lr0mQMf1ljfIm8A3txO/Mdd609yq6kkTZ7q5LLzQ9Hs5y0fECSxrSERa2E4pQZve8mz0/k
	yT738VMyRjMzsJVjk7cJ7SMjrGfsxaPHqpeqLuKj2OUBe0sAWBdSGqKsVvZMZhBa+QLYVH
	pDk0ME1YfqK7DBaTwLXRHb80ad08DOM=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-249--UWGGQB9P5qEOEyfE8TNsg-1; Mon,
 01 Dec 2025 12:47:49 -0500
X-MC-Unique: -UWGGQB9P5qEOEyfE8TNsg-1
X-Mimecast-MFC-AGG-ID: -UWGGQB9P5qEOEyfE8TNsg_1764611265
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 4CD6019560B3;
	Mon,  1 Dec 2025 17:47:44 +0000 (UTC)
Received: from h1.redhat.com (unknown [10.22.66.60])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id A8ADC1800361;
	Mon,  1 Dec 2025 17:47:33 +0000 (UTC)
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
Subject: [PATCH v13 mm-new 02/16] introduce collapse_single_pmd to unify khugepaged and madvise_collapse
Date: Mon,  1 Dec 2025 10:46:13 -0700
Message-ID: <20251201174627.23295-3-npache@redhat.com>
In-Reply-To: <20251201174627.23295-1-npache@redhat.com>
References: <20251201174627.23295-1-npache@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: F34ED140011
X-Stat-Signature: ptts9sb3utgg96im7hm7o654paitwwzc
X-Rspam-User: 
X-HE-Tag: 1764611271-424554
X-HE-Meta: U2FsdGVkX18mcmYN4E148WBl0cVio/kMVSWS7HqGFjFsnumaqe5i6M0Hv5BHU2EogQKVryWK2jG7atIzdwgYQIw6FFA57XazNWi52Ei9LTnv/LlWmU6aE0vjVqZDgIxAJgPdlgV4DJzl4urGIh/GWK7Djsh0nIBmZXcyr2M+49XNRor4dtrIVyfPL9AoIQWjNZtG/qKEFmpwk9rHkamiGbI+0a3u4Xu+wsSo32MOUGzlvutGOpjqAF5sdrPla5JVaX3zRVx9yjtPjGGroDY2bNbUigrf2YgZ4pxSuPIJlZsqqJwWXTeQVdGFRT+Xm8UA424qLOIo7pFrqwS85CZzsVgfWHQpzuFl2MmVSZxHsG0gueGFRQLYwA/Xktx2XTivPXieenzZgkZqCJvI8VzB2FHy7OsvwJnuMQhh4/kqY2UNMkOPhBqedKFp7CfNbliiDQGTrWua23NeiYw5szXihN6CfJseMVAxJtbEI/XwpTO0glDgxFUvGDs7+QJkrqKJwngUB1dq2qSYVYgTRtNdexBii7VeAFZWodUh/pM/I5zcoXFAaK5KbuIvFlPfh7F8dAYJ2Y/Mn0qzHAKs1jbjKmMFtc5+KW0pBUW3PUuBZsIGeB5peHLvTM0AEP/G/zl6bYtTvKGR+dDq29asVLk6ZM0LgprtpSBqJ6+RYwO2YC2fH0hsn7+VoJzt9RQFSrsenHe3aDsibHeQeBYUxQLztdsrppirbboqV/m6IC/OvBfbD8CNukdR/0r4Xq9nbqIP6DA1IIaS6mfvBgYb07Gmhd+8yJ9Rj2Ey8b+obaKtlP1yCAVUrkmugwNWsmer0Pun6UiRD3ZNP9nAzSWfC+Mwf68qPSTW8fTy8O9n9WOZNDXGM41MjMbwssYmqZYrciwJIXZOlIUF+fydEsSBuMViUa0Ynh7Z5nTAYpjljJgDN32INd2y/1VNs4vvtyJnopCJdP4/YiF/cSI74R4XCdn
 zbuxHBBk
 qEXUV//l1NtCdUp9rUN+reXH1TVeprCEPoKyMOjeB7x+FYZnCdgWF/h+cGrZItz21zlyk+8jPlzRKgPdaKEgKctLiAUcOpg2LauM5DAfwX/uFyJPtZBbWcX/MWrFMWnW96nXyFbX38IQJ0HQ3Jg90lkOEu7Uda154r3YIjqGF7qLYtiAGK7vf24CgTbmITGF84dL7ROHfPM199iTe1YfFK4oAXIt5cYXlSjDtDmHru2WzYiRktSj8lnrKnDgBtAE/VoGZcBv4Q0YePKmmUIAKU3flVTNun8UTGSdpqZzYrn1BAnIvKXzW317+AWmg1JSYipV7toWsTMc2df+zLJTdFCM1OsurQ5kqLxPnPR9LNJhSTNPB8i4COc684qc4NVZKqHDwdgSY9n7ZerIrir9/EFTazUWvlE7W8AbDB9lr41sazT9fysqTBlessYgjP5wJk6tPEckLJzHvyX4Ro3zuIWrmylCZFZh4717KMnxLgUCMTfGH4NrZS1jPBZDAhbkXmKL1Tyx1A8nyX7s=
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

Reviewed-by: Wei Yang <richard.weiyang@gmail.com>
Reviewed-by: Lance Yang <lance.yang@linux.dev>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Acked-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Nico Pache <npache@redhat.com>
---
 mm/khugepaged.c | 97 ++++++++++++++++++++++++++-----------------------
 1 file changed, 52 insertions(+), 45 deletions(-)

diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index 959be77f2e65..433ea7283488 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -2392,6 +2392,53 @@ static int collapse_scan_file(struct mm_struct *mm, unsigned long addr,
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
@@ -2462,34 +2509,9 @@ static unsigned int collapse_scan_mm_slot(unsigned int pages, int *result,
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
@@ -2801,35 +2823,20 @@ int madvise_collapse(struct vm_area_struct *vma, unsigned long start,
 			hend = min(hend, vma->vm_end & HPAGE_PMD_MASK);
 		}
 		mmap_assert_locked(mm);
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
 		case SCAN_NO_PTE_TABLE:
+		case SCAN_PTE_MAPPED_HUGEPAGE:
 		case SCAN_PTE_NON_PRESENT:
 		case SCAN_PTE_UFFD_WP:
 		case SCAN_LACK_REFERENCED_PAGE:
-- 
2.51.1


