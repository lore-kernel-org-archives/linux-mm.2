Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EEA03CC6B01
	for <linux-mm@archiver.kernel.org>; Thu,  2 Apr 2026 04:12:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 603FA6B0096; Thu,  2 Apr 2026 00:12:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5B48E6B0098; Thu,  2 Apr 2026 00:12:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4C9D06B0099; Thu,  2 Apr 2026 00:12:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 4094A6B0096
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 00:12:50 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id ED1491A02B8
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 04:12:49 +0000 (UTC)
X-FDA: 84612294858.28.8554A12
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf29.hostedemail.com (Postfix) with ESMTP id 706B6120007
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 04:12:48 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="nzAN/Pwg";
	spf=pass (imf29.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775103168;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iEMlhW5QpBeFmLMydXcgVtUh+l5tRz9bHoUq9G74KYc=;
	b=AaRb+8ZWm1WxuYH6T2/93HyCybkCI/fXRNudRyeT68QVknV4FcICtpT8mU9GexgKzFeSQ0
	CKZhOt4pMHSZIhEBoDZFGVK3Rb8CC3zTQGNPEh5v8N+98m/BfGA7ivJbr5pCvgM91N/j6J
	eaHpLmRdAyzLuXQ6JQsemwPxWxEN0uQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775103168; a=rsa-sha256;
	cv=none;
	b=zEVLRHDe9j+WhT3E9yZKvZOv/tlgVhFE2xukuqdvGTsFVvJFLbN0ZYUEX47fWNiFAYyG5k
	n19FPxUoQtyzT7Bv9MMSUJpN/RiSepakVWL0esZRQxgOKtjfJKu632wuUdUAQDXy2gfKdV
	dQ3t3DChhngvqZggx7p97KS7je2J7Oo=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="nzAN/Pwg";
	spf=pass (imf29.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 8DC4F407FB;
	Thu,  2 Apr 2026 04:12:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D665C19423;
	Thu,  2 Apr 2026 04:12:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775103167;
	bh=KXI5bMAAl/JthbpgvCWeg45Zai/zTi+2zYeJ12CGtXQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nzAN/PwgIhRrXh6o5q6czyx+j2qGkpgSR9hhBZHWcg1db6kDw2la96KkXrHtUesC7
	 Tm7y161q2JIRVC7hoUR4rlJg1P0VFJLO62HPhdF8MTfxciMMdcPzRap/2LALcbFHel
	 I5BGurbQjYKjEoWYpj3dNsbCAKQdt1tyXNFiCThckleb1wb8x9yzNbbTLR6iKhtLWj
	 kbsEU1yZZ2vGqgkUXPBv316tlVxnf5mjXM855VBXtE1izHv19rF85ftU59w14hLwMq
	 gxl+yuXyzZDcQZm04VdpvGHeTFZZrGq6r/daHFZ8gLwpnZAtIN3cdYt9i6XZHA5Uie
	 C/GlvqKPQVhCQ==
From: Mike Rapoport <rppt@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Andrea Arcangeli <aarcange@redhat.com>,
	Andrei Vagin <avagin@google.com>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	David Hildenbrand <david@kernel.org>,
	Harry Yoo <harry.yoo@oracle.com>,
	Hugh Dickins <hughd@google.com>,
	James Houghton <jthoughton@google.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	"Lorenzo Stoakes (Oracle)" <ljs@kernel.org>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
	Nikita Kalyazin <kalyazin@amazon.com>,
	Oscar Salvador <osalvador@suse.de>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Peter Xu <peterx@redhat.com>,
	Sean Christopherson <seanjc@google.com>,
	Shuah Khan <shuah@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	kvm@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH v4 06/15] userfaultfd: move vma_can_userfault out of line
Date: Thu,  2 Apr 2026 07:11:47 +0300
Message-ID: <20260402041156.1377214-7-rppt@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260402041156.1377214-1-rppt@kernel.org>
References: <20260402041156.1377214-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 706B6120007
X-Stat-Signature: 3mdu5bduc99zt1eg8k1d6ig6p4bfg8tu
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1775103168-430099
X-HE-Meta: U2FsdGVkX1/QcNIfSR1xGycNDc6myUkwqL+QpRXCRTQ9adWB2OErbOeUbBScX2aQJ3MAJnwBiDDZnRHh9K5akjJqyEi/yasTOjTz1mEJXT0YhkcHW73sn964BEqxCvcjCHGRXTbXQDAXIktRSePQLnzvpiCxLnNsGi9H3t9X6l6UrWp14QfUgEgkefcTCe+CiIZjEj9+EoWcL17D39nUvwjQPgUuyAscCFxB0nNbW3Z95ObjNnAc3X20BARxqusHpqf8oqzkN7pTkHLZkZuOBpv+hXUHv0rAN19qNikbKCGNJRNHrdoQwLs366dgg8XnPRQPe/Wh6881gn7Y/qytzXWKw6B/MzPAJNkn8hGXHSZPkovFOp0BnN/oXTARl1f2gZyAVvkvsbb0dLxhhQltTF+xLWIoZPsDUd7GEGtdRQ65nbfemX872EWGRXfQzTAG7zrm3HWn2DfulcUSgRf5z2pN5sd4IPw/zqv1VJjpa40zq8gRoQ91AbjwjhmYqXorVq6VRu97cDm3ATB8FYX2dukwKSMfoFHV/zCgKNTUmHsnUuGLSbOzL6fH+XppwDW/q0ujdV7EnogZGyXB13g1VD+89xhqEzKLfAVISLN654kegLoUWgr5xIeiB0khXE+oprAasnDegYbGl6DKA1SZRxVCeSHfUpJB3hB0An2IjE207Fz9wj9IIk3ygwWPj8xjUEsF0sA/F/qDHNGYdzKyp2pdKH2snsFpXrWJz9tKFxAwHRCbxaO/Q0H0n1AJl4p/neaVwMhw2mSI629DV9SYNkcgRZEROuvDY/Cvh4NObEw99R+6P2cMyXtZbeTHjTlW1nqP5Bt33gAu9kQ0460mGnIitb1Z0QZ0N+IZXMagO7/sP7HWseEcg/Jlj0/p5jmyRIPsDdkAAPHJR+9/0ac9t1YUSVGGP8vVvvLFHRphmUBaVcA3kxg5j2IKyI85Jm5Z
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
Reviewed-by: David Hildenbrand (Red Hat) <david@kernel.org>
Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>
---
 include/linux/userfaultfd_k.h | 35 ++---------------------------------
 mm/userfaultfd.c              | 33 +++++++++++++++++++++++++++++++++
 2 files changed, 35 insertions(+), 33 deletions(-)

diff --git a/include/linux/userfaultfd_k.h b/include/linux/userfaultfd_k.h
index fd5f42765497..a49cf750e803 100644
--- a/include/linux/userfaultfd_k.h
+++ b/include/linux/userfaultfd_k.h
@@ -208,39 +208,8 @@ static inline bool userfaultfd_armed(struct vm_area_struct *vma)
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
-	/*
-	 * If user requested uffd-wp but not enabled pte markers for
-	 * uffd-wp, then shmem & hugetlbfs are not supported but only
-	 * anonymous.
-	 */
-	if (!uffd_supports_wp_marker() && (vm_flags & VM_UFFD_WP) &&
-	    !vma_is_anonymous(vma))
-		return false;
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
index 82e1a3255e1e..d51e080e9216 100644
--- a/mm/userfaultfd.c
+++ b/mm/userfaultfd.c
@@ -2018,6 +2018,39 @@ ssize_t move_pages(struct userfaultfd_ctx *ctx, unsigned long dst_start,
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
+	/*
+	 * If user requested uffd-wp but not enabled pte markers for
+	 * uffd-wp, then shmem & hugetlbfs are not supported but only
+	 * anonymous.
+	 */
+	if (!uffd_supports_wp_marker() && (vm_flags & VM_UFFD_WP) &&
+	    !vma_is_anonymous(vma))
+		return false;
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
2.53.0


