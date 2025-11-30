Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6B9EDD111A8
	for <linux-mm@archiver.kernel.org>; Sun, 30 Nov 2025 11:18:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C8F756B000C; Sun, 30 Nov 2025 06:18:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C40186B000D; Sun, 30 Nov 2025 06:18:29 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B2F8F6B000E; Sun, 30 Nov 2025 06:18:29 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id A1F576B000C
	for <linux-mm@kvack.org>; Sun, 30 Nov 2025 06:18:29 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 4774B51526
	for <linux-mm@kvack.org>; Sun, 30 Nov 2025 11:18:29 +0000 (UTC)
X-FDA: 84167025138.13.854AFEE
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id BAE9A80006
	for <linux-mm@kvack.org>; Sun, 30 Nov 2025 11:18:27 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=u22qDJe9;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764501507; a=rsa-sha256;
	cv=none;
	b=nvjH6xiOqFvHpjiIH6R4QFSe5g8T6O9d9qmzBHOZe2dNKYm+siKP/7ZAf/uSvRntCc8Bf3
	vRXqe1gHOsrsqnALqygeslyV2c5EXOfZfUPwAdSYGLOXv4GhafRJU8qhO/2ubbqVpFjhaG
	9+qbr6ytsn0JgRl0tlXxMtonddKM5Jg=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=u22qDJe9;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764501507;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dXIi4eMsTPo9LZgyKY7Sa8yMzvCnkhtRY6ifX8gN6BE=;
	b=N3HssLUJBr66DyqpC75qw03PkP7MomTjS2DT2Xumha92xABhn6iHqhxmajl8Mem1iN761t
	aQT7O+7nqqgjsOm2JLfXAZ6qmQvTtn4UxQd+AY+bycPJxDl0pyvnHghwFkdm+AvONBdGqz
	649W8+fxuAm6HhsqzH5ez0lAXCWr1as=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id C9BB9440AE;
	Sun, 30 Nov 2025 11:18:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62A53C116B1;
	Sun, 30 Nov 2025 11:18:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764501506;
	bh=M3yfj9Aq9Ecb/VyGmdsiKpQj2lliUSutXUvuxf84MWc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=u22qDJe9yyfE9b0SEkH5kKwgmFUHYDDFq+6wlb/PHEFZTcyJQHuwm7/PK3YmJmuig
	 I/OaxNv/MX4j/UfdzT2pvMWImwdJFoo4+5PBgAV9kLt/bYyFRR8QEGiqmcBN5O8YnQ
	 phtYcipFli54J+Kax26kfnNNeXL46lCU5aDEP+ZzNsQE96TzGu42rs6agH4zRymw/Y
	 r0lu7M64VcpNcVq0wtXsraGDQk65Zt3/IrNhO19KlMjOHkpWsB/anS1B8UA5Yu1d1s
	 zjhHAYN8Dreo7ziAunpNhRalMI8xuAzdN0zUQtvVx/KvdMEg0kpKB7fS2lIfOdXb0H
	 OFmfIYFu2v0LA==
From: Mike Rapoport <rppt@kernel.org>
To: linux-mm@kvack.org
Cc: Andrea Arcangeli <aarcange@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	David Hildenbrand <david@redhat.com>,
	Hugh Dickins <hughd@google.com>,
	James Houghton <jthoughton@google.com>,
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
	linux-kselftest@vger.kernel.org,
	"David Hildenbrand (Red Hat)" <david@kernel.org>
Subject: [PATCH v3 1/5] userfaultfd: move vma_can_userfault out of line
Date: Sun, 30 Nov 2025 13:18:08 +0200
Message-ID: <20251130111812.699259-2-rppt@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251130111812.699259-1-rppt@kernel.org>
References: <20251130111812.699259-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: BAE9A80006
X-Stat-Signature: c36rmgcx16sfbsz73ad9efqaygj4zzhb
X-Rspam-User: 
X-HE-Tag: 1764501507-780875
X-HE-Meta: U2FsdGVkX1+/MCJcYo6RqGm7MhMAVN+qHJje4QC3vsHmRINhZspc7qAiEMN+woTLr+RJNvBHf0yk8c0y/Oqao2u5GknK57PiuoTMhf3sGHauypHOUb1yly8kAVmeZgDWxJK8bOIo+vEYeAuHvjWUas9YHjNEy6028LlyFe7aXicXA+coPnWWM7EsVVuvU++lqIrlhrBn95XiSnnRkY6RqLz96irdUg3EOyrtYDZZpGi7JFImwr3pHlOAheXOM9gkfrRDcqAFASOCf718I35tMi1f9oAK6CW8FdNvDJ9MWCT+tSwCVSIfAADky6JyIXi7yV2PLiF52GowKvOI5Fd6rbmyY4r5/eiPXBEOViN374L6AnNLgLVUIU8bGR/p1PokXMs/MTTKlP0MgAMcFxPU5MHsNx/JsAY9pC1oS3BTkOembMn5TZjSd2Ls4Hq+Dslcm/767TJHcKc5I3k4IxL4PwhWJQN6Azrveh4z0jI6ZUKvuG0wPvuDS5w0VEDWbDnmnvWC3NWjl/PHkmINHxeYCoQ9g0fSJ0NlpFEdJNrcxe/85Td/IxSuwA92JZrhnYAteN7y4BstMd+1tJEdvneYinG3WJ2XZu7gLJHDP6a28BQlw3XczVifRPCmbhP9niZyqCjsQdY8r0QlZzOe7wtHr5E3HmYLZZ1CITtvbT8waBTsBIKmxR1uJwKcShxHLuF2S/XMKk9FXSMRMr6Gv1zeOO7HlNNkQfz9DsFo5FydWX3jpCwnOyvuesea8KsVjj0LhR9ZNnprH++GjpyCP4UzOztd3Q6s+KNHYyLtnslvK001WE19JYhgf1pmzuTQd7JuGUF4b5badqquAve3yX3Lq3XGwV73PXrn3QYmTN9gf4LYNjr/v5BHJVLLVpE4KWGzWC13nwrXAqStoBMC6Xh1SbjfNdCTC+MUMMl8Zo2SyAwzMOUGLcqxNHggK1SkeGtVaHcmgU9bQeBKmQWW8g9
 3eOp8/WW
 w39FrzhDS2QxQAmN7mp3bJ0loZT3sMleUtSdizA6FwE8oCXM=
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

Reviewed-by: David Hildenbrand (Red Hat) <david@kernel.org>
Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>
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
2.51.0


