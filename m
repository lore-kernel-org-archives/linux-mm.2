Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DEF99CE8D6B
	for <linux-mm@archiver.kernel.org>; Mon, 17 Nov 2025 11:46:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 484E48E0029; Mon, 17 Nov 2025 06:46:49 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 435238E0003; Mon, 17 Nov 2025 06:46:49 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 324DC8E0029; Mon, 17 Nov 2025 06:46:49 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 1C7678E0003
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 06:46:49 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id BF22D8A1E1
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 11:46:48 +0000 (UTC)
X-FDA: 84119922096.16.B763F47
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id 1391B1C0004
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 11:46:46 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=IIkB+ZO6;
	spf=pass (imf18.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763380007;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vYyaMuTtgFLOMELFp5UCDhR3EXWgDts6OA9xxINrkpk=;
	b=sv0zANlPQFNJ206qxUHaXbXcktNnyOpn5QkVzy+T90ZP9wgRgLG57JcfkBPhP0Tt42cm3w
	o65biTFupLvEKQ9qrgGqAZsJmV0k2nefh/MYkQkhptWBbZAMQvjCCFbElKiqymIy2kBhfs
	yNYE4XEkPqfEMDw9JwXBRetBokxrRCI=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=IIkB+ZO6;
	spf=pass (imf18.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763380007; a=rsa-sha256;
	cv=none;
	b=njrp++I8ueybn/ZyeTmrgr/FWhh27Kmdzpo8RTqRsGLr5C6W4UQAdhtybxUWybtIruowSa
	cLF3HEpMc5Om+ws7nU7SfeiicZo1G7Hmr474wCgn1HnDULWSoGO+M8VJKmSWOJBmVv5hXY
	CbxpLagMrTqQyvklejRkJoDa7BekeIE=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 0D90D43D95;
	Mon, 17 Nov 2025 11:46:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0743EC2BC86;
	Mon, 17 Nov 2025 11:46:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763380005;
	bh=IWNZrq9x24Lzm+UDNOmC86glMjR/3VEA7eqKJIQ4L98=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IIkB+ZO6MY7IVFrcCRruJ75sEdHUJaBxiYEX3wpNhlMwR+KfO5mS+r/f4LAx/Bg1B
	 gzoJ+o9mRcq0sk2EJsHo+hakZ6ACSrwuZvCb5dXrEvgB3m/9EaqNQS1n0bI4NUwlAv
	 mJ7ZHwywcg3Ebnm/YytQK6R7fybylkM696PnKCwNMNTmiRX29PgXMr8M/IAUhVDZ2D
	 B5gPzQG4AakfJizYk9MfNtMVw3bti63xXdQQsiRW9B+1OcbquuQdzhwnYNlgNP0m4M
	 MM1hucigpwnuJVRP69L3D7uGZWm54HKgANVCUgTBHOJ76czq+vKF5TUD3sqy5tnXM/
	 apk0eplUMDpCQ==
From: Mike Rapoport <rppt@kernel.org>
To: linux-mm@kvack.org
Cc: Andrea Arcangeli <aarcange@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	David Hildenbrand <david@redhat.com>,
	Hugh Dickins <hughd@google.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Nikita Kalyazin <kalyazin@amazon.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Peter Xu <peterx@redhat.com>,
	Sean Christopherson <seanjc@google.com>,
	Shuah Khan <shuah@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org,
	linux-kselftest@vger.kernel.org
Subject: [RFC PATCH 1/4] userfaultfd: move vma_can_userfault out of line
Date: Mon, 17 Nov 2025 13:46:28 +0200
Message-ID: <20251117114631.2029447-2-rppt@kernel.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20251117114631.2029447-1-rppt@kernel.org>
References: <20251117114631.2029447-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 1391B1C0004
X-Stat-Signature: fann74fhmm49cz96tjhu7zx4quu99ntk
X-Rspam-User: 
X-HE-Tag: 1763380006-239280
X-HE-Meta: U2FsdGVkX18K7APPNL5WpBfBcPr4N4ENAWVX6NSbAdbuY3l2LdM2+oQ6yuD7vEWkIWr2bGYoEvE5jZPdUNIw/MdhbMzM/6Tsnn30HlWea2D214qHqPxXEmibM2NnmDJN/S2apkpcadHvnzXKrGu3pMCWG8HDKMBGBv07hZggR7HHTRyjZSFL4E+q0gR37zRUsz3QbT/jpjZ3l9Pn0LlPEKPctks0Q4fJCg+bOeMerQUqEeSwZ/JWcbwPFnBZ6b6kVBeN2eomwKu2mLcrcBDTJqDDEz69L7RCin5rmRZowMhVNfemGHnVvj125/567J2Jt0GZ/zpsVDvaFgrRstxCXntp3sEhLKl0rL0PqBbKa1nG1rSzuDwgyrP02C6aENcgDFP/1MAc31FkmoJB7LV4qaIdAX/o3amxSB43+tc3LPkyU1XOTw0Cj4vzgTYlmXsjEozm6a3svb+BwBU4Qx4HD0gKhd1dGzL5oFcHZHHlmzsvSFyw0iZm7J72NcqUPv/VqVxWY0q5nl+Nvh+hzwG8qsGtLBDdIKiyfGfzy2A3rLBdyI0O4AReJmt+Z5LkJozTttFErfDBKpJvwpuWAtHk8RADqbc2uAaXGekoaFE5qwWXoSRKsdEh0pWhTcSJD32tFU2VdXHEC+GePYlDp/gqkG4DB1rPu/L02vVmlvDqmPhRs8p4YxNaW+GMYGZ03mVDdiYTXXaZa2lBNUh23TGfSkcVHjZObgqxb1RsggrNm3rq/H06DtkvcaQm3aukrZaYGAafqWO42xLhki7O0M5304Wm4PTckYAao42Ev43vJK3zW9AizZTE4OHMhbAMGXjTcW2+ksHB2YSsIAtUkWo1/DHQwO/H+5ywzQrgTYteosIbJ29wTQJ/QAjuRI2xDYP0S4MnEVWN+sMKGWMnMxunKGDyVSo3gJQySy1qEuuhCldF2UP/hajllUeZ+eby70nRzciyMizolKZNSnTUNtM
 xr437y5q
 PEZ2bxWUTysRcGRrb3Gha1q9VKFOcFk6AbArVfLiCDW1ve2BQ5D0nApgAtIp7tFM6z0LEAVSAzB/oa5y+Y4BuVzvLll3xFH87BWwf8Tws59RGtHZrLI0Tz40+pzaRmm4coK2whajzRKTmYZyepUaTRQWcLO0mhujWLLi3JUwXTcvH3p5qWU9wUiT1Qzw1BakfHbT5O87Z8g3ZpMSIdsJmW9dLSvnUUa+sRMFO3k05OxZIl/zhNQloVFhlf0FbXnwU4yTpukIettVQ2quHz5aYQfk5bmXX/Vw74fGFg2llDm4dXG1rZ3s9Ch2p6gRDk4OZfMYD
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>

vma_can_userfault() has grown pretty big and it's not called on
performance critical path.

Move it out of line.

No functional changes.

Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 include/linux/userfaultfd_k.h | 36 ++---------------------------------
 mm/userfaultfd.c              | 34 +++++++++++++++++++++++++++++++++
 2 files changed, 36 insertions(+), 34 deletions(-)

diff --git a/include/linux/userfaultfd_k.h b/include/linux/userfaultfd_k.h
index c0e716aec26a..e4f43e7b063f 100644
--- a/include/linux/userfaultfd_k.h
+++ b/include/linux/userfaultfd_k.h
@@ -208,40 +208,8 @@ static inline bool userfaultfd_armed(struct vm_area_struct *vma)
 	return vma->vm_flags & __VM_UFFD_FLAGS;
 }
 
-static inline bool vma_can_userfault(struct vm_area_struct *vma,
-				     vm_flags_t vm_flags,
-				     bool wp_async)
-{
-	vm_flags &= __VM_UFFD_FLAGS;
-
-	if (vma->vm_flags & VM_DROPPABLE)
-		return false;
-
-	if ((vm_flags & VM_UFFD_MINOR) &&
-	    (!is_vm_hugetlb_page(vma) && !vma_is_shmem(vma)))
-		return false;
-
-	/*
-	 * If wp async enabled, and WP is the only mode enabled, allow any
-	 * memory type.
-	 */
-	if (wp_async && (vm_flags == VM_UFFD_WP))
-		return true;
-
-#ifndef CONFIG_PTE_MARKER_UFFD_WP
-	/*
-	 * If user requested uffd-wp but not enabled pte markers for
-	 * uffd-wp, then shmem & hugetlbfs are not supported but only
-	 * anonymous.
-	 */
-	if ((vm_flags & VM_UFFD_WP) && !vma_is_anonymous(vma))
-		return false;
-#endif
-
-	/* By default, allow any of anon|shmem|hugetlb */
-	return vma_is_anonymous(vma) || is_vm_hugetlb_page(vma) ||
-	    vma_is_shmem(vma);
-}
+bool vma_can_userfault(struct vm_area_struct *vma, vm_flags_t vm_flags,
+		       bool wp_async);
 
 static inline bool vma_has_uffd_without_event_remap(struct vm_area_struct *vma)
 {
diff --git a/mm/userfaultfd.c b/mm/userfaultfd.c
index af61b95c89e4..8dc964389b0d 100644
--- a/mm/userfaultfd.c
+++ b/mm/userfaultfd.c
@@ -1977,6 +1977,40 @@ ssize_t move_pages(struct userfaultfd_ctx *ctx, unsigned long dst_start,
 	return moved ? moved : err;
 }
 
+bool vma_can_userfault(struct vm_area_struct *vma, vm_flags_t vm_flags,
+		       bool wp_async)
+{
+	vm_flags &= __VM_UFFD_FLAGS;
+
+	if (vma->vm_flags & VM_DROPPABLE)
+		return false;
+
+	if ((vm_flags & VM_UFFD_MINOR) &&
+	    (!is_vm_hugetlb_page(vma) && !vma_is_shmem(vma)))
+		return false;
+
+	/*
+	 * If wp async enabled, and WP is the only mode enabled, allow any
+	 * memory type.
+	 */
+	if (wp_async && (vm_flags == VM_UFFD_WP))
+		return true;
+
+#ifndef CONFIG_PTE_MARKER_UFFD_WP
+	/*
+	 * If user requested uffd-wp but not enabled pte markers for
+	 * uffd-wp, then shmem & hugetlbfs are not supported but only
+	 * anonymous.
+	 */
+	if ((vm_flags & VM_UFFD_WP) && !vma_is_anonymous(vma))
+		return false;
+#endif
+
+	/* By default, allow any of anon|shmem|hugetlb */
+	return vma_is_anonymous(vma) || is_vm_hugetlb_page(vma) ||
+	    vma_is_shmem(vma);
+}
+
 static void userfaultfd_set_vm_flags(struct vm_area_struct *vma,
 				     vm_flags_t vm_flags)
 {
-- 
2.50.1


