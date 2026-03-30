Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E3400FB3CF7
	for <linux-mm@archiver.kernel.org>; Mon, 30 Mar 2026 10:12:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 585A56B009E; Mon, 30 Mar 2026 06:12:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 50F916B009F; Mon, 30 Mar 2026 06:12:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3FEB96B00A0; Mon, 30 Mar 2026 06:12:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 27EA86B009E
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 06:12:10 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id E1BB6C2902
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 10:12:09 +0000 (UTC)
X-FDA: 84602313978.04.E13B0BC
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id 35DB4180003
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 10:12:08 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=T6bfA0ev;
	spf=pass (imf24.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=T6bfA0ev;
	spf=pass (imf24.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774865528; a=rsa-sha256;
	cv=none;
	b=QNUwdEowuCChR/hKFgRT87IxrC42Dym52DTZM4+CXYIlI+nQHDmxlT7CqCqo0hxmZSxu2g
	roxe5NRQj/UPWa+nq5fI3aKxPVIge6PzUWu47Y1/lJ6g6Y3vmnsYSbbLiotfBh3P88LqGP
	D2wX/QK4BjWAWbgesc6QZrkGzn07Mow=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774865528;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iEMlhW5QpBeFmLMydXcgVtUh+l5tRz9bHoUq9G74KYc=;
	b=j+FYlMbGD3hr1hGZ6edThlFIyKYsmeqmXQBxN2LqtJybRQdHHUqOWjE5zZR/HsNceuIDOn
	yvnks/wrXmf1+KeLE3b0h7KJ8BldEO51xoBaMw00YWNnqCiYEYlIDte/3zhKZWfMZNVWdf
	mXblTRxsTLC/aDc07RQkNbz1jIEUXGk=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 624F8437B5;
	Mon, 30 Mar 2026 10:12:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D561C2BC9E;
	Mon, 30 Mar 2026 10:12:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774865527;
	bh=KXI5bMAAl/JthbpgvCWeg45Zai/zTi+2zYeJ12CGtXQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=T6bfA0evPK6ZnzfPf76G9AX7uo/ynI67VOh0Hf/CutXRlQb3EPL88lYCZz2+4TSrP
	 sJIISfG6sHGFw9HmV1v6gYmvdowqir8TX8d8mVJ/4DEkDjbTAn/ki/j6G+sfRNp0B6
	 kwhAYekUhsiVtrkqnoS4dm0lHKcwvmgPQYM/gnGBppKnBXxrSP6yyL0Xg8OweIPT4v
	 5zpDdT7M1DsnFNq69Jo6hbg0Mi7dvmXWEqFSwddaGdz4kK+9pwBX4rs1PUXtm990SK
	 Lx6kEfL6C59ZHFzVD49d8upGPQanG343lclCQnvD+Gur37QQ6dxQatn5d5pgJbJ9Oj
	 AnFSQd2dspewA==
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
Subject: [PATCH v3 06/15] userfaultfd: move vma_can_userfault out of line
Date: Mon, 30 Mar 2026 13:11:07 +0300
Message-ID: <20260330101116.1117699-7-rppt@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260330101116.1117699-1-rppt@kernel.org>
References: <20260330101116.1117699-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 35DB4180003
X-Stat-Signature: ydeu856m4yjsqfhsjfq48rigsp7uqg8n
X-Rspam-User: 
X-HE-Tag: 1774865528-411484
X-HE-Meta: U2FsdGVkX19QtZoTtDFGjBQKRJVDLS9vvdwOm6DsKvMQ6CZIWcXzfCqIzBRfPgw6Z6HwCvDaFIIz+iUZfm3DLlP0u5BxgpDt5GPN27kLAs73dxWoAmp+lwibszF66mIco+a6JCLiw0OM83j9kSfnUGd7S1SZ3TEmLx5lPbFIPSqUhi6XoOXHIMagpe1Ip0bb2i4wHMu641nrsgvYDsQg+PGeLay+0TaTcGJA3U1n4AxQsLaG3dw1mEo+i9SwEbbUhJKs3rnda4oxzYBs+v1Gv36h9tkmbWKpMW7IsTYTVNiGpQZCeNo7o5ZXuLceYP7f09CeZKrTFzzCSyQYOIIVvK++mbmTYUpx0lTzKjYEW1TO3pQuelYQlxDoKVba7A8OAeBz0Pz5zn0I9+gOrhjMumIZBbjjzeU4uC1v8/ukf864XEF9Al3DB86yVvUR4aodlJFUolizzKD+MBCprhjuhhQhjtHoU06fd7IfsIVJpAS9U62j4uHQ86flyD821+FaroyCuwtz/YlCP7OZwJ8gfkU7p2Nv/ZZvYakNMoOCgvRBBCqq8XLejrenMBqk1tI1bsRQOY3GmXl86ZGX13Fx5jqqFJJ4YoN9J41QLQU+UZ2Ky2Xv8FfVh5nRIAKgE+kcs+prpVZ2NZbal4t/ax9ck3LhmO+korisRBjHDLGJyl09NcGqdbFBxPw1nXGMH3BS09tBgQpr5fpFtsQRUYaZHGrGmlY0ww1MaKPfn7qCqJakK25se4KlASaWirIIQvnfZzmkJwvqlDPXLK/quuZmaoITUaGDuF7dc9RsojlBVgwLf3wZ5oDZ8JJsXc+PKzwmB1nsCmgvg5ZPwl7RsGGJvGd68pr59kDtZQi5r9NBEq0tYzMEV8TAGTKWi0vDhc+7IJ8w6Sl/gfbZ6/cHLCt81s/NckcD1JC+lybLYWfXWKQ4U1QCwJim72p/vxfTdS9G0tE5lPfsGk/Oe/8ysxm
 kKF7hR9d
 BoJe/K0qQjv3zyfzHqupNocu/Vep2CJwHCL0nyDQv0J1e2pUkuAOyJ50/4LXJuJE4uUcZKPE5juYgxVycOHaeDkvVLnZgnip8/em0D/ZHvgbtayn9xtAVSo2N31e/33go0qrw3P2Kl8Ors2Z9VXUy6cczTlPZo48vWiwmRPfUp0/NBKfwsrpRnHsxIjlSNFHjbGz1TivyKxxAPn7BSTUBfzNp11vEA8M+V3Xq7K/2zp8KZWx1RICIG309y5CiV0xHs4nZFzpHWixTbHQ=
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


