Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D93BEFD9E3A
	for <linux-mm@archiver.kernel.org>; Fri, 27 Feb 2026 20:12:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 204266B00E5; Fri, 27 Feb 2026 15:12:55 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1CF056B00EE; Fri, 27 Feb 2026 15:12:55 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0C51A6B00F0; Fri, 27 Feb 2026 15:12:55 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id E7AA56B00E5
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 15:12:54 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id DD005140912
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 20:12:46 +0000 (UTC)
X-FDA: 84491334732.24.82433A3
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id 0278140017
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 20:12:44 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=e5g0TPuA;
	spf=pass (imf07.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772223165;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xOAMwgzKb8EUHtWYRJDu3VoLceGWF1CqGbxvk9rxhzE=;
	b=tA3yP3eF/OC51WRCQ3736vgCk13iclvvreKPKAfpvm5eNL7FGKs66gGPO8sPLmDAHHcbm5
	v5h2nbWM0sHeRj1l9lNAIjp/V1+DReyAQJ+/kNmWI7dhut1Jw3RqPwQPV9lYsVfgs8JEaF
	BPH0TAoe61EiX/kP8d1+5Dc9fOMUPMc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772223165; a=rsa-sha256;
	cv=none;
	b=bEHHR2STNj1iemFbBx98vUGK6srms33XRDg/BIkA6ggj0xyyb2/g9fg0Yp9UxeyzYGMWRs
	a5FVS0TUTgesZt7aPbXxiBr82AyycSQiuhkEDSLNZ2RvmQJPa4hI22W0HCIUYCzaqV4HmJ
	pplDOImwMSp4elKUzDPQDYPfeh4iM5E=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=e5g0TPuA;
	spf=pass (imf07.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id D97E141843;
	Fri, 27 Feb 2026 20:12:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 624A8C4AF0E;
	Fri, 27 Feb 2026 20:12:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772223163;
	bh=B1yXnc32tXbLcJ8NQGFc5Arvb5lyHtOMPl4AdrDajl0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=e5g0TPuAG6gfesnF6qlduLlcGUBPnMhU3YENZOHkNsVPDgQhRnH1MFauWgeL7RMDC
	 ZDytxLL3/ocwf5PbRvFpVbk3pmvkdAD+XF1L6BzyancbBjD35yHtpfICb2QNxOw986
	 L5hI932ZW/hEh+Gw6fKcAGmpoqiF+z1NyH1tsVKuOA7DQSAhWxwkWr6RocVOmKV8XG
	 KFx3ANZlj2o1XSLVoqev/UhRxYfp7R7fG3oZ4hNen9Y8TdMB1iPdiGc3rcD8XmrotP
	 q4q3zeg0mjfjsk5BWqfRmyIBaT8twqj4E2sWv/18B/I98ZtV8ClTF3/ZnpUTnwGlob
	 z68EfQd2gz72g==
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
Subject: [PATCH v1 13/16] mm: rename zap_page_range_single_batched() to zap_vma_range_batched()
Date: Fri, 27 Feb 2026 21:08:44 +0100
Message-ID: <20260227200848.114019-14-david@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260227200848.114019-1-david@kernel.org>
References: <20260227200848.114019-1-david@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 0278140017
X-Stat-Signature: 31f5uidfd4ybrfkzp5in5sct7kra8ppy
X-HE-Tag: 1772223164-653548
X-HE-Meta: U2FsdGVkX1+wH0LXDi+ETu8YfHs1QCkQUpL8N6c6jCdyZ8lIqpdy8ftsoAPfgcIkzutIr6lLAbTDIKxzf2bP3CxtUXuA+9k+raJNCEClOGTGH9wA12LbKf6hJP9Hcp1heE5hhDPzxqrBw3lJC12glKK2oFh9XALT9OfPQ4e1GZ4WwP6v4gSTZ5kPya5aV7cm4qj7G92Wsi5dnuiPKmZWkr77FwPe3a4V+i8HGvhJiQUCuLlUDvcY0N1+O4/XVPZ+D4/KB6wDdCXorVo3VsPKosKZP6YiULQrW4GzStlMtPBOv3Q31cwjn9BUDLZp2AfsJWXeR+zwUqI/wIakeI4Ab4ryXUI9LaozsyrAaWvoHg7kOybDj9QLk6ZHVhDXzuKHqfYP2U/lao02AfVePZgLKsaABvY6Ex2WF4umgjfrOWl8n7CgkJP+ZzmXuRn6TMyErhPtbzM0RD6HyxBKho7k/sm2G/jmrxp2xSpiOKeNCs5ZdoJR97B6U2/bURUesadj91c2S2McleWIlbaNRA2HYnXasEEH7tlAIPZb75/LkSrC93yahlZLGiJau8JM+JeeLuTUysomIzzQXG0Uln6HsS8AbX90SUSnyCVB5/Zraev8ws0zhQ+rnI9hf/gnQdREfwj+WBosj+ntwy19/wj75XYKmRFBoqdz2H7u0H+iAkWcwNGyGsl2LLEy0FItMVZ3m3WajTVonEYjur3h2ZYKRsHWVFc7FFRgZG+riQ4i+37hyKgjjGxwypH9AO6Z83w/gwU3nVf3+CKtHwZPTCb3pBdp6sU8hP7WhHcJz5jTQ1Pp7DCv3M0JJfeIT8S3YAaBtcSIBc73tm/P9hCErDuSzPacz88pfBD/Zy1tuJdeXxBeiRzYUx4blhSzk6NHTz+Ksmrjc+exWZNopwfJOM2ysJCedujnn2eQwmNvQFMeUsBCTtVCt5N3CCzXj9+7ueexWZyKirPGWhWa67cLjTE
 ozPErUqP
 Cu9CBNg1NhC8NF3KKkVrzZVq3bz6wXGofCr5r9B3uIpF8Gfe7x1eoFvjiK2WvDf8UuaVco0R26KD3XAgAvDr//1RME5L4/SMdgr1zBqzq/d2VUoeZ9VSNS807MIyk8BKy/olOptkpch3NxOE/NMxdmhTOM9i+H/LSQ4Sf4SxgFmYFy/sQJzw2Jvuq0k3uNnoj01bmu+R8QuiQVnYvXgrzZGgtJwHeaPw5A3F7sKyowcQkqEwaGOUvo3ZkXtfzcFR2kZtTf0mWHFzMilUUfqzrWnT+BhwSjh1HfUSo
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Let's make the naming more consistent with our new naming scheme.

While at it, polish the kerneldoc a bit.

Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 mm/internal.h |  2 +-
 mm/madvise.c  |  5 ++---
 mm/memory.c   | 23 +++++++++++++----------
 3 files changed, 16 insertions(+), 14 deletions(-)

diff --git a/mm/internal.h b/mm/internal.h
index df9190f7db0e..15a1b3f0a6d1 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -536,7 +536,7 @@ static inline void sync_with_folio_pmd_zap(struct mm_struct *mm, pmd_t *pmdp)
 }
 
 struct zap_details;
-void zap_page_range_single_batched(struct mmu_gather *tlb,
+void zap_vma_range_batched(struct mmu_gather *tlb,
 		struct vm_area_struct *vma, unsigned long addr,
 		unsigned long size, struct zap_details *details);
 int zap_vma_for_reaping(struct vm_area_struct *vma);
diff --git a/mm/madvise.c b/mm/madvise.c
index b51f216934f3..fb5fcdff2b66 100644
--- a/mm/madvise.c
+++ b/mm/madvise.c
@@ -855,9 +855,8 @@ static long madvise_dontneed_single_vma(struct madvise_behavior *madv_behavior)
 		.reclaim_pt = true,
 	};
 
-	zap_page_range_single_batched(
-			madv_behavior->tlb, madv_behavior->vma, range->start,
-			range->end - range->start, &details);
+	zap_vma_range_batched(madv_behavior->tlb, madv_behavior->vma,
+			      range->start, range->end - range->start, &details);
 	return 0;
 }
 
diff --git a/mm/memory.c b/mm/memory.c
index 1c0bcdfc73b7..e611e9af4e85 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -2167,17 +2167,20 @@ void unmap_vmas(struct mmu_gather *tlb, struct unmap_desc *unmap)
 }
 
 /**
- * zap_page_range_single_batched - remove user pages in a given range
+ * zap_vma_range_batched - zap page table entries in a vma range
  * @tlb: pointer to the caller's struct mmu_gather
- * @vma: vm_area_struct holding the applicable pages
- * @address: starting address of pages to remove
- * @size: number of bytes to remove
- * @details: details of shared cache invalidation
+ * @vma: the vma covering the range to zap
+ * @address: starting address of the range to zap
+ * @size: number of bytes to zap
+ * @details: details specifying zapping behavior
+ *
+ * @tlb must not be NULL. The provided address range must be fully
+ * contained within @vma. If @vma is for hugetlb, @tlb is flushed and
+ * re-initialized by this function.
  *
- * @tlb shouldn't be NULL.  The range must fit into one VMA.  If @vma is for
- * hugetlb, @tlb is flushed and re-initialized by this function.
+ * If @details is NULL, this function will zap all page table entries.
  */
-void zap_page_range_single_batched(struct mmu_gather *tlb,
+void zap_vma_range_batched(struct mmu_gather *tlb,
 		struct vm_area_struct *vma, unsigned long address,
 		unsigned long size, struct zap_details *details)
 {
@@ -2225,7 +2228,7 @@ void zap_page_range_single(struct vm_area_struct *vma, unsigned long address,
 	struct mmu_gather tlb;
 
 	tlb_gather_mmu(&tlb, vma->vm_mm);
-	zap_page_range_single_batched(&tlb, vma, address, size, NULL);
+	zap_vma_range_batched(&tlb, vma, address, size, NULL);
 	tlb_finish_mmu(&tlb);
 }
 
@@ -4251,7 +4254,7 @@ static inline void unmap_mapping_range_tree(struct rb_root_cached *root,
 		size = (end_idx - start_idx) << PAGE_SHIFT;
 
 		tlb_gather_mmu(&tlb, vma->vm_mm);
-		zap_page_range_single_batched(&tlb, vma, start, size, details);
+		zap_vma_range_batched(&tlb, vma, start, size, details);
 		tlb_finish_mmu(&tlb);
 	}
 }
-- 
2.43.0


