Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BDDD9FD9E3A
	for <linux-mm@archiver.kernel.org>; Fri, 27 Feb 2026 20:11:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 27FC96B00E7; Fri, 27 Feb 2026 15:11:24 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 253AC6B00E8; Fri, 27 Feb 2026 15:11:24 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 13F5B6B00E9; Fri, 27 Feb 2026 15:11:24 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id F1DE16B00E7
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 15:11:23 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id ADEBFC2E88
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 20:11:23 +0000 (UTC)
X-FDA: 84491331246.02.27DCF90
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf03.hostedemail.com (Postfix) with ESMTP id 3D0EF2000C
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 20:11:22 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=PYP8hi5N;
	spf=pass (imf03.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772223082;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qAaAKrA9C/+XAY4LI5BZgGXKSy2ztkeyRwN6gL5w5a8=;
	b=OHAqeW4S/08lresEQwpmr5n29bhuoc9HNf0zFp+EWIHVcWpbuyascgMVFcV0fhVm/BH3ti
	JbTNYDTt0BRmquzFx2vLssED8EPu2Wh8r50XJwZdpc/jWGgivDBEKFm3jfWb2CTFaUhPok
	qfh3yMhkept5o52IxTNS9CtiFlR9Hl8=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=PYP8hi5N;
	spf=pass (imf03.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772223082; a=rsa-sha256;
	cv=none;
	b=a27kLjCOtppzbncyGPQTnJqWcsruf/c+98m0u7dPUmyqT9ZmzTC4nNvu3NNnUqxEGZVWuU
	Q4p61KX0PlXUd3oJsUTRJrlkDlmRM1Poy9g9rm6ql0dTDizt7en5zkiZetQhGX7LKhygvE
	sskY1Ktx1zGNA3TtPwUvJWscsS3kqLw=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 9BCB560126;
	Fri, 27 Feb 2026 20:11:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11DAAC116C6;
	Fri, 27 Feb 2026 20:11:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772223081;
	bh=Ms86RD0Otoj1d6fzyHR5o28Ex/YjZExC3FyxUcdS+A8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PYP8hi5N5sGdSXGeQeQx0PGG2qoBngPOdHIav4EUqj7du6tyiIkdIqI1w8m/NqulN
	 yXTxgx+g53/5ilvSpYisK6g/8IOBFrnfp7OT3nq69Vw+lSxB4peBlnL7oBBrBFteR+
	 M2xZ9SjZBvkW0pqpQ/Xabhkha8T9/aSY5mi7v8CLxJ+sb4/YPmxDWucCxYnzccFDiZ
	 EBFkzzUicUwOCfYz7Mnqy0dyy3jiaAtOm+CqJElfZ27AJo9RZVjXuSUjS95x5xGJ2w
	 JLFZQYbU59MSVTJrtE+3FkB7Em2PBv3oHfoONvXgNLI0cd8vWkaGCUZ4/ZP0s9duB7
	 TSoGd5pRM7nbA==
From: "David Hildenbrand (Arm)" <david@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: "linux-mm @ kvack . org" <linux-mm@kvack.org>,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Jann Horn <jannh@google.com>,
	Pedro Falcato <pfalcato@suse.de>,
	David Rientjes <rientjes@google.com>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Alice Ryhl <aliceryhl@google.com>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Janosch Frank <frankja@linux.ibm.com>,
	Claudio Imbrenda <imbrenda@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Jarkko Sakkinen <jarkko@kernel.org>,
	Thomas Gleixner <tglx@kernel.org>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	=?UTF-8?q?Arve=20Hj=C3=B8nnev=C3=A5g?= <arve@android.com>,
	Todd Kjos <tkjos@android.com>,
	Christian Brauner <brauner@kernel.org>,
	Carlos Llamas <cmllamas@google.com>,
	Ian Abbott <abbotti@mev.co.uk>,
	H Hartley Sweeten <hsweeten@visionengravers.com>,
	Jani Nikula <jani.nikula@linux.intel.com>,
	Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Tvrtko Ursulin <tursulin@ursulin.net>,
	David Airlie <airlied@gmail.com>,
	Simona Vetter <simona@ffwll.ch>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Leon Romanovsky <leon@kernel.org>,
	Dimitri Sivanich <dimitri.sivanich@hpe.com>,
	Arnd Bergmann <arnd@arndb.de>,
	Alexei Starovoitov <ast@kernel.org>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Andrii Nakryiko <andrii@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Arnaldo Carvalho de Melo <acme@kernel.org>,
	Namhyung Kim <namhyung@kernel.org>,
	Andy Lutomirski <luto@kernel.org>,
	Vincenzo Frascino <vincenzo.frascino@arm.com>,
	Eric Dumazet <edumazet@google.com>,
	Neal Cardwell <ncardwell@google.com>,
	"David S. Miller" <davem@davemloft.net>,
	David Ahern <dsahern@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Miguel Ojeda <ojeda@kernel.org>,
	linuxppc-dev@lists.ozlabs.org,
	kvm@vger.kernel.org,
	linux-s390@vger.kernel.org,
	linux-sgx@vger.kernel.org,
	intel-gfx@lists.freedesktop.org,
	dri-devel@lists.freedesktop.org,
	linux-rdma@vger.kernel.org,
	bpf@vger.kernel.org,
	linux-perf-users@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	netdev@vger.kernel.org,
	rust-for-linux@vger.kernel.org,
	x86@kernel.org
Subject: [PATCH v1 08/16] mm/memory: move adjusting of address range to unmap_vmas()
Date: Fri, 27 Feb 2026 21:08:39 +0100
Message-ID: <20260227200848.114019-9-david@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260227200848.114019-1-david@kernel.org>
References: <20260227200848.114019-1-david@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 3D0EF2000C
X-Stat-Signature: k1azjaz53okb9emhecfqmo6d8mm6w6uc
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1772223082-489733
X-HE-Meta: U2FsdGVkX1/SDCoqRAYQf14GcracZSLnlA4ipFTQxYOxu/9TVw/7SJezHuMzo3HMg1+4VZ8lCzDu+HKfQ6YNZvXmJJW63eipQbE3coJ+nEpHYM+sGedimpJEA5zSI8WIhP6/h3TWWu2mm+hRAZ8FlBdZNggD1zZ5xLGrI/GrIefxrRbav9bJevXT7Ozf9DBLgcbWt5hkm2MA1ZIOYLPSZzj7pM+qw9AFqjE1hYO52NsJJdAKW/gxrh+DkTNMf9lpzs9UfLUV3Fr7wKfW6etIyeCZM5iPfWaKoNhcPybgJKDn4mT7OLkauohIP9TVnMRnQHjTHwUzjKU9doDHhaBpJRk0+++cUb2ksy9bOyTvWCFxJ7tAwjR/JlRLVvv9YdklAUA4x5PHuMqzPZgJyCbvPsAU/9UbSCtG7ZFoxwYL4j8bEAL6a5eG4EzOrFF7rVF3SEjh9wz0PtLqCVbspqeq7sdEgyJCh5Ms6NZzlXH3liD5K7efxkcLKSsUAsP94x1tUW8xpPCvMzP+MiROmvEeDFELNB8vR/4kvxGHVT0gde536nTJQdWwUadd04Ub2u2mEwYqtD1aeEwKs4A1oF4wDXMoBPUo/KlAzwFPlh4nkHoHm+sNWjgKWVDlUO2iJ6/HPnxQjfPcUhO3ttF3qagT8xb0+6Qm01uZbv01QbUoEOFUNaiLEDAhtqM9VFp5xgHtLuxKfhndhV3XB6Nb/va20WKDBiBpYE3KDqFy5CJUeUYyXne6Z1pkSr1YAkr9iw58402KREg+tfdUbBqfmlisoytiNql84diBDkdZB8a03hoiVqSR4q7W9WL3rj9eeL6L+WzCINEsjeXLWzBsg7QZUud6UVHkuPZ5ndOwC8BGiMqo727dI/efPm6yrXRcC94HQMtxGgD3ojIWL8kn8em6DJzb1zxigAJ9pxglsGhY9QM+lQZv6j9bmyXi9uZ4nEjmKGBFUPSkQMOvoy1ov8S
 V/OADpVi
 H0ajyng1y64rEIp0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

__zap_vma_range() has two callers, whereby
zap_page_range_single_batched() documents that the range must fit into
the VMA range.

So move adjusting the range to unmap_vmas() where it is actually
required and add a safety check in __zap_vma_range() instead. In
unmap_vmas(), we'd never expect to have empty ranges (otherwise, why
have the vma in there in the first place).

__zap_vma_range() will no longer be called with start == end, so
cleanup the function a bit. While at it, simplify the overly long
comment to its core message.

We will no longer call uprobe_munmap() for start == end, which actually
seems to be the right thing to do.

Note that hugetlb_zap_begin()->...->adjust_range_if_pmd_sharing_possible()
cannot result in the range exceeding the vma range.

Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 mm/memory.c | 58 +++++++++++++++++++++--------------------------------
 1 file changed, 23 insertions(+), 35 deletions(-)

diff --git a/mm/memory.c b/mm/memory.c
index f0aaec57a66b..fdcd2abf29c2 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -2073,44 +2073,28 @@ static void unmap_page_range(struct mmu_gather *tlb, struct vm_area_struct *vma,
 	tlb_end_vma(tlb, vma);
 }
 
-
-static void __zap_vma_range(struct mmu_gather *tlb,
-		struct vm_area_struct *vma, unsigned long start_addr,
-		unsigned long end_addr, struct zap_details *details)
+static void __zap_vma_range(struct mmu_gather *tlb, struct vm_area_struct *vma,
+		unsigned long start, unsigned long end,
+		struct zap_details *details)
 {
-	unsigned long start = max(vma->vm_start, start_addr);
-	unsigned long end;
-
-	if (start >= vma->vm_end)
-		return;
-	end = min(vma->vm_end, end_addr);
-	if (end <= vma->vm_start)
-		return;
+	VM_WARN_ON_ONCE(start >= end || !range_in_vma(vma, start, end));
 
 	if (vma->vm_file)
 		uprobe_munmap(vma, start, end);
 
-	if (start != end) {
-		if (unlikely(is_vm_hugetlb_page(vma))) {
-			/*
-			 * It is undesirable to test vma->vm_file as it
-			 * should be non-null for valid hugetlb area.
-			 * However, vm_file will be NULL in the error
-			 * cleanup path of mmap_region. When
-			 * hugetlbfs ->mmap method fails,
-			 * mmap_region() nullifies vma->vm_file
-			 * before calling this function to clean up.
-			 * Since no pte has actually been setup, it is
-			 * safe to do nothing in this case.
-			 */
-			if (vma->vm_file) {
-				zap_flags_t zap_flags = details ?
-				    details->zap_flags : 0;
-				__unmap_hugepage_range(tlb, vma, start, end,
-							     NULL, zap_flags);
-			}
-		} else
-			unmap_page_range(tlb, vma, start, end, details);
+	if (unlikely(is_vm_hugetlb_page(vma))) {
+		zap_flags_t zap_flags = details ? details->zap_flags : 0;
+
+		/*
+		 * vm_file will be NULL when we fail early while instantiating
+		 * a new mapping. In this case, no pages were mapped yet and
+		 * there is nothing to do.
+		 */
+		if (!vma->vm_file)
+			return;
+		__unmap_hugepage_range(tlb, vma, start, end, NULL, zap_flags);
+	} else {
+		unmap_page_range(tlb, vma, start, end, details);
 	}
 }
 
@@ -2174,8 +2158,9 @@ void unmap_vmas(struct mmu_gather *tlb, struct unmap_desc *unmap)
 				unmap->vma_start, unmap->vma_end);
 	mmu_notifier_invalidate_range_start(&range);
 	do {
-		unsigned long start = unmap->vma_start;
-		unsigned long end = unmap->vma_end;
+		unsigned long start = max(vma->vm_start, unmap->vma_start);
+		unsigned long end = min(vma->vm_end, unmap->vma_end);
+
 		hugetlb_zap_begin(vma, &start, &end);
 		__zap_vma_range(tlb, vma, start, end, &details);
 		hugetlb_zap_end(vma, &details);
@@ -2204,6 +2189,9 @@ void zap_page_range_single_batched(struct mmu_gather *tlb,
 
 	VM_WARN_ON_ONCE(!tlb || tlb->mm != vma->vm_mm);
 
+	if (unlikely(!size))
+		return;
+
 	mmu_notifier_range_init(&range, MMU_NOTIFY_CLEAR, 0, vma->vm_mm,
 				address, end);
 	hugetlb_zap_begin(vma, &range.start, &range.end);
-- 
2.43.0


