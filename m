Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DB0DF606A31C
	for <linux-mm@archiver.kernel.org>; Sat, 31 Oct 2026 12:35:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Zfm6PN8L
Received: by kanga.kvack.org (Postfix)
	id B50BE6B00EF; Sat, 31 Oct 2026 08:35:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ADA7C6B05B1; Sat, 31 Oct 2026 08:35:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9A2FF6B05B2; Sat, 31 Oct 2026 08:35:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 70E7E6B00EF
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 08:35:13 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id DFD681C3EB8
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 12:35:12 +0000 (UTC)
X-FDA: 85382866464.21.95D8D2E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf30.hostedemail.com (Postfix) with ESMTP id 3F06A8000C
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 12:35:11 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Zfm6PN8L;
	spf=pass (imf30.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793450111;
	b=OLtWb+ak56H3M4coLIm8jgsuZJGEf20oI04QWC2oJonAWvAwSvKorpcG0IMCpNAvNym8AY
	gaJYFAuy6Fq3KsGhSbHYMmF1OgmKWsDOTEWH/EZHW88m/FjLLGDqrjZV8IlckuepnE3MtH
	1bf+5txh6TsQlRo70xwcXc+/OEPgbgg=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Zfm6PN8L;
	spf=pass (imf30.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793450111;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=NGJd0b1x2Q+1ueL/OsZfD8yOd2huoS1n0KwD8HqgAlg=;
	b=IuynrbYGtlXtKdYf2tAPhPkFBoT1f+Wvz2imNCe1xW/ppvw6boKafKRY7rBa7Ifyb2dHPr
	TWYwAsEL1rLnkzpTwMHPUmB9TIr9vn6fSvk26IGZDqPQs/JCHo19nnRvQZGtJKhQ/h/Fd5
	dBq7XUXxp8S8J7rUnOL14VV7Au44Ark=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 9B237601EE;
	Sat, 31 Oct 2026 12:35:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 689D01F000C1;
	Sat, 31 Oct 2026 12:35:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793450110;
	bh=NGJd0b1x2Q+1ueL/OsZfD8yOd2huoS1n0KwD8HqgAlg=;
	h=From:Date:Subject:To:Cc;
	b=Zfm6PN8LblPUTpa6GSuOyMtI4rhBievlZLP8QmaQ2TBLtVx6AZDt0x78JwbUPawzn
	 YwsjaMNH/W+eJxs492Y5FR6uy8uquro2tsd80mZSO57H/XooUlyYF6sJPoJIwxiWih
	 CyBSNkjNtUE+BIYMqRebfP6YtCJI3CALiA0nxwItQFB1/s62xchPlQIv4P3BTG1oKB
	 IurDesNn8jhzIDPg/wf4CJILD04Ebb8xXbsqkWDUYLThn/O+3dQVIaeebLAZWy3MVz
	 XmbKRgkb+zJRZrTC7gI8KRv9W0Wrq7k5u/87+mxN5QEdnj13oT4lAMpgr4eOBkbyuj
	 DFgLtXHIYbE9Q==
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Date: Sat, 31 Oct 2026 14:35:05 +0200
Subject: [PATCH] userfaultfd: clear uffd state in child PTEs if uffd is
 released during fork
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261031-uffd-prot-bits-fork-event-v1-1-3572921c2111@kernel.org>
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/yWMyw7CIBBFf6WZtRMLRmL8FeOCx2BRgYaBxqTpv
 1t0eW7uOSswlUAM12GFQkvgkNMO4jCAnXR6EAa3M8hRKjGeBDbvHc4lVzShMvpcXkgLpYqOLlI
 4dRbaKNj9uZAPn1/7dv8zN/MkW3uwP4xmQlN0slOfYsw1HmPElrhq8ybYti8YyPTDoQAAAA==
X-Change-ID: 20261031-uffd-prot-bits-fork-event-de821d651ab6
To: Andrew Morton <akpm@linux-foundation.org>, 
 Mike Rapoport <rppt@kernel.org>
Cc: Peter Xu <peterx@redhat.com>, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, stable@vger.kernel.org
X-Mailer: b4 0.16.1-dev
X-Rspam-User: 
X-Rspamd-Queue-Id: 3F06A8000C
X-Stat-Signature: zxqgqb9n5ksm45w3zj8c7357o8ayg73k
X-Rspamd-Server: rspam01
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793450111-848125
X-HE-Meta: U2FsdGVkX19iNJRRZZyQ99HXWt8oKrdneKEQW3a/EonuUoY2tn1IIn/ngwn3acp5ZPH38fqpq4WbPJxsh6iQ60CXGOiLFj5T+lUJKYjdU9qzRxRUZ0anQi33HeQRpjITqYmGPZo9zEw+Bfi9HX4QHpBIel86pTC9V0SbFqMURP/AAC390seUbAA+qEl6iLuKqSk3WLsCKQWYi/o4QEyyARxYPRKzIp/lURKjR4X2lSKS7+JSBJYT3dKBxD4eEIW6yoTiunTROkk2NJHg3+0FolsG5tr5xFk9m3W7qGSnSrKDrmHfNf0CoI+W42JWKgH4mUKMGXG5IV1RAfc0eGDTxTDbMijCuEoCRGtk30FvPPtHIkfC6qi7Ykdailv9r8V1T5T5C+/e0CmdVZEaRgE6wYhI1vDfBFbk4FifLOW7z7oPe3Vc390iqHfOKDfb9Zjoa6nwDHzeSVUFV3E7rUbc7a4Z2OXqkmft1UiS9Li2uoEdMUiPTRhXoJ6JieaXnmqTVwgBkt7SgZ7lqjRfdD8affq+BA4X2wVU57dGsKWdiO+90d86tvBTE97/hGb6C4rRXVzVTedVS5JAYj2v2Fj74mIBU4iwAaCEY5o6wtuuDP9uFynz8SCgpC1pbz1E6S08vPLiVtjcqba1VMH+blGkH7wGyb77E34kqCnzYq32gkAu5nVZFEBi2UWEoXeccrpO0N+uEuv2VvT8jbt0QfdiKnBsOUc5tuEm6/pMBOY4nJNyy/IWnUokWxy57br5ARgo29Ry24Das53V/kPn5jymg6LnKrLq2ad1AZY/ckrosdHCQxacSfd2aWCzRNuYWRM74sEolG15OPfVtneSHTxvzH8ZASKzOW9u83vt7C5hWwkvfADCqQepQ5pJ7JaCDuPXA3ODxaPWKf5E7WNmx9KQm+uSMLYtp+C4dd7Zj6Wnc1KbegHOTcw7lg9xswSbHRX2zV6yKvgAb73POH4k2M/
 NSqr1Eax
 dOl2Zkb1qeGZ213lX5i4ishf1wFMvr9NkNCbohG3jy33tCzz2/WRF8TLLh/eGYhuzm+E/wnRgv+ZIJ9tL/dS1DMvuzB5OIZ3UWxE507rq3ex6PQQhT//rv9gb9rprWl8RGIHRsglaMxKhPwPS/D+XifDxGAgrnHlpARL6bRFDBfacb9gTd0CJBhYT8y1OyWs/Q7gJlcM3D6xeqPBKnSb7u2vYYAl0xmjHrVXBSHw0KGG/UXU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

With UFFD_FEATURE_EVENT_FORK the userfaultfd context is duplicated for the
child process, the child VMAs are registered with the new context, and uffd
protection state from the parent PTEs is copied into the child.

If the parent's userfaultfd is released before the fork event is read,
userfaultfd_release_new() resets the VMA flags but keeps uffd state in the
child PTEs.

This leaves the child's VMAs in an inconsistent state: they are not
registered with userfaultfd but their mappings carry uffd protection state.

If the child registers the range with userfaultfd again, the stale state
turns into protection the child never asked for.

When a write fault makes such a PTE writable without copying the page, the
uffd bit remains set and page_table_check_pte_flags() warns about it.

Split resolving of the uffd PTE state out of userfaultfd_clear_vma() and
call it from userfaultfd_release_new() before resetting the VMA.

Fixes: f369b07c8614 ("mm/uffd: reset write protection when unregister with wp-mode")
Cc: stable@vger.kernel.org
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 mm/userfaultfd.c | 43 ++++++++++++++++++++++++++-----------------
 1 file changed, 26 insertions(+), 17 deletions(-)

diff --git a/mm/userfaultfd.c b/mm/userfaultfd.c
index 3b71712edab4c..2c11ac5dad3d5 100644
--- a/mm/userfaultfd.c
+++ b/mm/userfaultfd.c
@@ -2220,6 +2220,28 @@ static void userfaultfd_reset_ctx(struct vm_area_struct *vma)
 	userfaultfd_set_ctx(vma, NULL, 0);
 }
 
+/* Clear the uffd bit and/or restore protnone PTEs */
+static void userfaultfd_clear_ptes(struct vm_area_struct *vma,
+		unsigned long start, unsigned long end)
+{
+	unsigned int mm_cp_flags = 0;
+	struct mmu_gather tlb;
+
+	if (!userfaultfd_protected(vma))
+		return;
+
+	if (userfaultfd_wp(vma))
+		mm_cp_flags |= MM_CP_UFFD_WP_RESOLVE;
+	if (userfaultfd_rwp(vma))
+		mm_cp_flags |= MM_CP_UFFD_RWP_RESOLVE;
+	if (vma_wants_manual_pte_write_upgrade(vma))
+		mm_cp_flags |= MM_CP_TRY_CHANGE_WRITABLE;
+
+	tlb_gather_mmu(&tlb, vma->vm_mm);
+	change_protection(&tlb, vma, start, end, mm_cp_flags);
+	tlb_finish_mmu(&tlb);
+}
+
 static struct vm_area_struct *userfaultfd_clear_vma(struct vma_iterator *vmi,
 					     struct vm_area_struct *prev,
 					     struct vm_area_struct *vma,
@@ -2239,22 +2261,7 @@ static struct vm_area_struct *userfaultfd_clear_vma(struct vma_iterator *vmi,
 	if (start == vma->vm_start && end == vma->vm_end)
 		give_up_on_oom = true;
 
-	/* Clear the uffd bit and/or restore protnone PTEs */
-	if (userfaultfd_protected(vma)) {
-		unsigned int mm_cp_flags = 0;
-		struct mmu_gather tlb;
-
-		if (userfaultfd_wp(vma))
-			mm_cp_flags |= MM_CP_UFFD_WP_RESOLVE;
-		if (userfaultfd_rwp(vma))
-			mm_cp_flags |= MM_CP_UFFD_RWP_RESOLVE;
-		if (vma_wants_manual_pte_write_upgrade(vma))
-			mm_cp_flags |= MM_CP_TRY_CHANGE_WRITABLE;
-
-		tlb_gather_mmu(&tlb, vma->vm_mm);
-		change_protection(&tlb, vma, start, end, mm_cp_flags);
-		tlb_finish_mmu(&tlb);
-	}
+	userfaultfd_clear_ptes(vma, start, end);
 
 	ret = vma_modify_flags_uffd(vmi, prev, vma, start, end,
 				    &new_vma_flags, NULL_VM_UFFD_CTX,
@@ -2353,8 +2360,10 @@ static void userfaultfd_release_new(struct userfaultfd_ctx *ctx)
 	/* the various vma->vm_userfaultfd_ctx still points to it */
 	mmap_write_lock(mm);
 	for_each_vma(vmi, vma) {
-		if (vma->vm_userfaultfd_ctx.ctx == ctx)
+		if (vma->vm_userfaultfd_ctx.ctx == ctx) {
+			userfaultfd_clear_ptes(vma, vma->vm_start, vma->vm_end);
 			userfaultfd_reset_ctx(vma);
+		}
 	}
 	mmap_write_unlock(mm);
 }

---
base-commit: b61fa14ce6bcbba2cb9a96feea31b760226d6b43
change-id: 20261031-uffd-prot-bits-fork-event-de821d651ab6

--
Sincerely yours,
Mike.


