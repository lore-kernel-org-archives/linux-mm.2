Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5E53DFD9E3A
	for <linux-mm@archiver.kernel.org>; Fri, 27 Feb 2026 20:10:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C11BB6B00E1; Fri, 27 Feb 2026 15:10:50 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BC8EC6B00E3; Fri, 27 Feb 2026 15:10:50 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AE8656B00E4; Fri, 27 Feb 2026 15:10:50 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 983A36B00E1
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 15:10:50 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 490AF1608FA
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 20:10:50 +0000 (UTC)
X-FDA: 84491329860.11.B0F3FA0
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf08.hostedemail.com (Postfix) with ESMTP id CD4EB16000A
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 20:10:48 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=nfvnOh6G;
	spf=pass (imf08.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772223048;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VzLysLIDiziqT+z+8O0U2+zIe52qtwqEAHv4JAZVhAg=;
	b=XTsGYlfVKHc82xyoGkA15HA74t4nfryw2oR5tNNLpi48m9k1Nwsyc1Lb/9pFpdkOLckPSP
	7OUEAXAO26heIrtjLVnmYxnjbj7Bewxv6GtqaEGz8FCKGTPSGdEVG+VuDL3O+c+cVj2mG9
	1XpHVNKbrvMfvotvypP+CtUF6f2MCvs=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772223048; a=rsa-sha256;
	cv=none;
	b=tFYkNrCkh8un0ZyIpuW1vVQZ6jJrNyjD/ga+6ma4lBOu5dNQAF6Ul3AjQt1teuy9G7EjB2
	nsQqnVVMIh0FTVpr1dJqZ76YvuCoXwx2xrgJTGvx1/FUQMBU2FNpseCJwUNlPwJFiA+/J1
	Ik6rkuZlP/xqPTyBWeihakD4B7Fh6YM=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=nfvnOh6G;
	spf=pass (imf08.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 265ED60130;
	Fri, 27 Feb 2026 20:10:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8338C4AF0B;
	Fri, 27 Feb 2026 20:10:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772223047;
	bh=QGXGGpOpfFdi5KYtLppZ0pqbJn7DahplTB4anRf43p0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nfvnOh6GFZtYgZiN0uOTy634vV7a2URwKLO9gYY3hSmWrxWYugIhQMwjmKAP0Ou7H
	 E7yQ2swT+jt/BCllVI65b1rCvucLmydteEcAWJgvmR6s7NVl1dOcUQKed/pO6sinW9
	 lwoqUdfj2/aHynj1hfJQjMN4BDqIw/yLezbCWepQA0SY428UknnSWvQAdl5uw8Pw0I
	 ZMvoXeKbY2uAT7ljvl10AXyMqsQZJg6xW3aCfxZ3Rd8l7duGBMlC0mAecn8AsWYubD
	 FGcjbDKLIzBns5l13QGee7VBjeTjFl4JHAPE0WATVKG/4R/uphdDwPX6uX4D9dFGKx
	 IeNq3bC5UkO4w==
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
Subject: [PATCH v1 06/16] mm/oom_kill: factor out zapping of VMA into zap_vma_for_reaping()
Date: Fri, 27 Feb 2026 21:08:37 +0100
Message-ID: <20260227200848.114019-7-david@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260227200848.114019-1-david@kernel.org>
References: <20260227200848.114019-1-david@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: sarq3qf9xtxityqogxgtxh7qqipen59k
X-Rspam-User: 
X-Rspamd-Queue-Id: CD4EB16000A
X-Rspamd-Server: rspam12
X-HE-Tag: 1772223048-236272
X-HE-Meta: U2FsdGVkX1+O28t8hRyyoRN8Yro3YYWRP9r+zTxxyuyBHHB9XRmt0cl6CXZMfuqQ4N/ixJYly4i8EEb1k78PGJqzmyGpGwChFzMFjLQyXfpJaR+RcJ4yTDq6kvvFs0cb3fnQK1UWC/eiWwCt1YPkp4ByxhWDuKQCHpkfdvtxZm6pRtb4bvfoUDES9ekrQdEt2P2xiEygNNzBFTywuEZ+vyRTYOf9MjeewCT11Yn0fx2hB2qGcVHm56zQaVcyjQEdug7eIdc48C/X2yY+h+8yZ3xd7/yZ+nkhOvFDuKmcFSdcairaVcmHP3aXB1ubY1UouEouX/4CsIy7/dfeGlnAK1kOelQ6jRhygrbYkTqDSNKhr9+wuluHyRf6TvdmE1wDn0bbluNxEn+G/Kr6rd7kSPTIF1yM7LHIeYZQlfa/aX2EzZpiq88aWzcM7dQKFTLl1DXo8rUbEUAW/i8/95Hfsho9Cw+q7HDNKRhRCn52szRt3aU/1TMRE5ZzTJZVwadIL7MhiMLRf4hSOlfeKG1C1/IUUL6Kl6zhC5f+AZ/90s4j+Uai/IuAKEJFDGjJjE/7ZG33waMJ3230wBF6KvGpNW3UOK3NM+80DZheowBoxmBzWgYXkXOO6WAeNk4iPCdQayBBwz1tU4OVxJxnOT7gLUX1u91XqhXl59nh0UVWzZVd7dbOelj/ahDskiyyqD+ZuC61zuLKSJavUPd2w+YwiaEEsPetB/8NJkSbx5rjcvQXYnYsNz7IiTuvhwpY7ji1ez/3ss+NFaLzByuc+5yz+pfl2yJtpPMMddljBsB8LsHsh6XygJIdBpKCvCa7R99C5RjscCKlTtD5yGKc2uN/FTDURdyXlHgQVFZ3i9lFk/5Vypv+w0g5WDff7iKbDiw0Vxvy+31wjQdcsGjAkaaj62mnFioh7Tz84mUwEyYyFS9oZIl513sQ+bpYAYvd6gjV
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Let's factor it out so we can turn unmap_page_range() into a static
function instead, and so oom reaping has a clean interface to call.

Note that hugetlb is not supported, because it would require a bunch of
hugetlb-specific further actions (see zap_page_range_single_batched()).

Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 mm/internal.h |  5 +----
 mm/memory.c   | 36 ++++++++++++++++++++++++++++++++----
 mm/oom_kill.c | 15 +--------------
 3 files changed, 34 insertions(+), 22 deletions(-)

diff --git a/mm/internal.h b/mm/internal.h
index 39ab37bb0e1d..df9190f7db0e 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -536,13 +536,10 @@ static inline void sync_with_folio_pmd_zap(struct mm_struct *mm, pmd_t *pmdp)
 }
 
 struct zap_details;
-void unmap_page_range(struct mmu_gather *tlb,
-			     struct vm_area_struct *vma,
-			     unsigned long addr, unsigned long end,
-			     struct zap_details *details);
 void zap_page_range_single_batched(struct mmu_gather *tlb,
 		struct vm_area_struct *vma, unsigned long addr,
 		unsigned long size, struct zap_details *details);
+int zap_vma_for_reaping(struct vm_area_struct *vma);
 int folio_unmap_invalidate(struct address_space *mapping, struct folio *folio,
 			   gfp_t gfp);
 
diff --git a/mm/memory.c b/mm/memory.c
index e4154f03feac..621f38ae1425 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -2054,10 +2054,9 @@ static inline unsigned long zap_p4d_range(struct mmu_gather *tlb,
 	return addr;
 }
 
-void unmap_page_range(struct mmu_gather *tlb,
-			     struct vm_area_struct *vma,
-			     unsigned long addr, unsigned long end,
-			     struct zap_details *details)
+static void unmap_page_range(struct mmu_gather *tlb, struct vm_area_struct *vma,
+		unsigned long addr, unsigned long end,
+		struct zap_details *details)
 {
 	pgd_t *pgd;
 	unsigned long next;
@@ -2115,6 +2114,35 @@ static void unmap_single_vma(struct mmu_gather *tlb,
 	}
 }
 
+/**
+ * zap_vma_for_reaping - zap all page table entries in the vma without blocking
+ * @vma: The vma to zap.
+ *
+ * Zap all page table entries in the vma without blocking for use by the oom
+ * killer. Hugetlb vmas are not supported.
+ *
+ * Returns: 0 on success, -EBUSY if we would have to block.
+ */
+int zap_vma_for_reaping(struct vm_area_struct *vma)
+{
+	struct mmu_notifier_range range;
+	struct mmu_gather tlb;
+
+	VM_WARN_ON_ONCE(is_vm_hugetlb_page(vma));
+
+	mmu_notifier_range_init(&range, MMU_NOTIFY_CLEAR, 0, vma->vm_mm,
+				vma->vm_start, vma->vm_end);
+	tlb_gather_mmu(&tlb, vma->vm_mm);
+	if (mmu_notifier_invalidate_range_start_nonblock(&range)) {
+		tlb_finish_mmu(&tlb);
+		return -EBUSY;
+	}
+	unmap_page_range(&tlb, vma, range.start, range.end, NULL);
+	mmu_notifier_invalidate_range_end(&range);
+	tlb_finish_mmu(&tlb);
+	return 0;
+}
+
 /**
  * unmap_vmas - unmap a range of memory covered by a list of vma's
  * @tlb: address of the caller's struct mmu_gather
diff --git a/mm/oom_kill.c b/mm/oom_kill.c
index 0ba56fcd10d5..54b7a8fe5136 100644
--- a/mm/oom_kill.c
+++ b/mm/oom_kill.c
@@ -548,21 +548,8 @@ static bool __oom_reap_task_mm(struct mm_struct *mm)
 		 * count elevated without a good reason.
 		 */
 		if (vma_is_anonymous(vma) || !(vma->vm_flags & VM_SHARED)) {
-			struct mmu_notifier_range range;
-			struct mmu_gather tlb;
-
-			mmu_notifier_range_init(&range, MMU_NOTIFY_CLEAR, 0,
-						mm, vma->vm_start,
-						vma->vm_end);
-			tlb_gather_mmu(&tlb, mm);
-			if (mmu_notifier_invalidate_range_start_nonblock(&range)) {
-				tlb_finish_mmu(&tlb);
+			if (zap_vma_for_reaping(vma))
 				ret = false;
-				continue;
-			}
-			unmap_page_range(&tlb, vma, range.start, range.end, NULL);
-			mmu_notifier_invalidate_range_end(&range);
-			tlb_finish_mmu(&tlb);
 		}
 	}
 
-- 
2.43.0


