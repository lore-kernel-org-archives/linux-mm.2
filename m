Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7AA65CFA46B
	for <linux-mm@archiver.kernel.org>; Sun, 23 Nov 2025 10:27:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BDED46B00A7; Sun, 23 Nov 2025 05:27:25 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B8F1F6B00AA; Sun, 23 Nov 2025 05:27:25 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A7D976B00AC; Sun, 23 Nov 2025 05:27:25 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 8B0EA6B00A7
	for <linux-mm@kvack.org>; Sun, 23 Nov 2025 05:27:25 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 249F812ED44
	for <linux-mm@kvack.org>; Sun, 23 Nov 2025 10:27:25 +0000 (UTC)
X-FDA: 84141494850.13.A692D58
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf08.hostedemail.com (Postfix) with ESMTP id 914B1160004
	for <linux-mm@kvack.org>; Sun, 23 Nov 2025 10:27:23 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=l1nW6j9s;
	spf=pass (imf08.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763893643;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VA0pvSz7aljo4H8EOhEeYnm1pxpxxtMILjlDV6dqzzY=;
	b=MxO2kzVrIlDKfSrcaKNqzSOmGc0rfDaxxcGFI8tXQKWNLvd9iMWmhdQ/C4XbfOJ8gJtDOL
	3SRAPAqZFEu3Kq1I44RDnTV8MwppGVfANIMeYF4Ny8MOI3/LDfyPlgkjPlWIhB5PZTjDcl
	ucxEkHxOOX+MsRQa9fi5N48ioK+l2gE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763893643; a=rsa-sha256;
	cv=none;
	b=p3p2bc7YBiuZ7r5QzWlo+X4WmyWgjlTj1fVQygFgkuaM5sT8on1nEc+ZigrQOO0/J0yULb
	KWrs7Nl7/5Qi7IpkpEEGl+HBHIKcgbEIDpFVaC7TUW/OAvS8Tfd4GvP2qP6WnSvPFYjjDi
	aVFQMhuQhcGvcpUMtNQQQeWuCm7Jo7c=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=l1nW6j9s;
	spf=pass (imf08.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 9300260158;
	Sun, 23 Nov 2025 10:27:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D54D7C116B1;
	Sun, 23 Nov 2025 10:27:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763893642;
	bh=WZL3dOi9JF12AwW63UbE2JZ210f4aDb9qSF2OCoPSt4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=l1nW6j9sn6FoE5js92l/pHRlJhGv8ZSxi/MPWghrw/vFeAL14TcupB8vZtV0DeKRg
	 VGW2WRNd12kfuKspl6yPLZ/Fy0mFJiWPE/4UTbQ+EYKiWE37mHujvH/4+CQt2Aq4he
	 GRbMEEWfedQePLiIIBwWKC7SX/nX+pETBeEyFN4KEQNqbw7W94uOqXY6UU7jhyG2/8
	 Kn24IkHUtsDNlLP59DtKl3ZIL26IwZV81ePXPjOr9P134gxFm0gmjkbCpB2aLTbREs
	 VvJ5v1vnKnH06yjlUNP8N1FuFLRhplm++wF28CVvtaLRH6ADHcqB+iGK1lC0YbZYDK
	 1oK061Lqmu/Sg==
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
Subject: [PATCH 1/5] userfaultfd: move vma_can_userfault out of line
Date: Sun, 23 Nov 2025 12:27:03 +0200
Message-ID: <20251123102707.559422-2-rppt@kernel.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20251123102707.559422-1-rppt@kernel.org>
References: <20251123102707.559422-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 914B1160004
X-Stat-Signature: 9bdn67aowpzcqstksmwa1q7aucpfusfh
X-Rspam-User: 
X-HE-Tag: 1763893643-166621
X-HE-Meta: U2FsdGVkX1+67f0YHDb64Sn/UmUDlvrdFMBRh78bH3rvFiaUulKJoaEUKsNvkDRIoBNErGcVcbezv79bh5IZPIVENxk66yzo4vsluLgsI2eFu8RSeHErlQCi4lifndUk7vSjlyMCi193p1qqFslH/4btRt8sBVJrtaWinu4YgtHVwpvm3abxkCXXirbpL0d7peuBsMpMYGJ3jexx9xmZa2Kh+kZnVz5RmvOpC5TBWaa93YV4bBhkpKZUI/bWfU0/t0rTouwVPi7sntVbpYhnsyEITfBViefmQzK65Hx+rRzCDF/YnfqV1fuPuVlStRbAEGFtC8BtRzlHRC1wqdfJRBOCVZueaVZWvrxpMi45T3vPdcoRohBrMGghR3gZktYjTkSwgSq54BB2fdLaQx/gJae7RzHJ/Px9B4i90cu8GSuVK6HAEZQVDTesWEi+C/3HPaiX+nfnR940tlul4doXIMxkjUpx35bNdPVUPCD3NnzA+O16wqp1eLuyFBpKVs0MXKuWgnd3UcRZdwZlzfWQQmhc3677KIWg9wCw9yr6AgXXKOKpqUccPX2hKhpY2h2lgq3hF9S5OS/unmn9nx2a0pLrWQFb7SZzMs6neOG2zPIulBcJmYtTZ0wFcoJjbuw+0ybUSPH3DF3HQqdJF0eOpL9P+i1jVe5mjezoOz4sV/9VLGQiByPdgXQ+QyW+dILogupbNMOADM78yDwB1SgabKoOfZFQA8YbzD9H9+KslYQRMoOzZKXCOIQS1epChw5rpfIEFv8OkaCwpS7tPPFRXn7FO1nq3E10JEwU94MC6xlL2iRARCZQP2Dwl//bt1RGQ33LcrRMmKyErSXtv4rxUuZiP/ey0hy6wusf/ZN6xchABdHNkPaUhmouH3A2ex7FAF9s8gZaxml0VkFc04q/AHO7DYSFcolNK/0V6xw9o7JEXgcpzjZ/m/SCbbcojObw20Gnl+/Fc3E8A01egCv
 lTUzR/j0
 tLCbUnToFZMjGJCVGSjsLIsJ9JQE6SAmttULKUC1MPo5O3CbAb1forwcbMN1SMJOJVgFqUBO04CAi69WqODCj7a6W8RzZIlX+vbaYpJu/6ydlXB1GAA7Ge5FXamEnflSKl08EIeb6vaCVVDtU6l0gwngxLGbz7TeHofbkf9XKoEOC1pHtVyFQcLdReDQ2mPLyaK1OZUozAFXpLF7x4ALZozDUvTwBMBpsRjVBIWzXI1cpbMgMBhbVAVWERNTXD8pQhS1lbijykONQ7jO4qdQyj0q3P6GAwa5233japtFlvyfpTp5kh0qG0CDhpz4rSrJk70R0
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


