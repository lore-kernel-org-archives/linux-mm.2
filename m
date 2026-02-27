Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 87689FD9E3A
	for <linux-mm@archiver.kernel.org>; Fri, 27 Feb 2026 20:13:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E91DA6B00F1; Fri, 27 Feb 2026 15:13:18 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E5CB46B00F3; Fri, 27 Feb 2026 15:13:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D278A6B00F4; Fri, 27 Feb 2026 15:13:18 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B76B26B00F1
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 15:13:18 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 7549913BCA1
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 20:13:18 +0000 (UTC)
X-FDA: 84491336076.23.3DE4A08
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf06.hostedemail.com (Postfix) with ESMTP id BD64C18000F
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 20:13:16 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=BoKOHAuN;
	spf=pass (imf06.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772223196;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tGcj024N/3/Sdl4LkKivnSwcbObEcpHcloksqRsVDAE=;
	b=NR9NjplLn+AXGb9+NM6jDrzmVjEIYPU9DMoVp0UCZcaSsM7V7WLpx05OnqTMQk1/jurOiE
	FNzEuvD+/gDwFKOlI5iRtmfYlk9D+XJ+Bm1dtvOKhmb0hVCMeohfMn7cEzBp55I9NWTV7D
	F7GF6g8qzrab7EJsjsq0khhCRVK1xv8=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=BoKOHAuN;
	spf=pass (imf06.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772223196; a=rsa-sha256;
	cv=none;
	b=paa+N5N10HHdnGAVK8TEo+P3GR1U2+jrshpPDO/KZhYSAvU7JKZteybpOr1+SM0STBvcww
	Osms5JinsuVfyzYhA0hcMKltwnx1JcqkGDlPQnoXwXmX5HmAEQ67YwG8RN/n7Wg/zMzuek
	WCEJC/oKmrlhArmR0HTBqtfJyfwp01o=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id CC4A4401C0;
	Fri, 27 Feb 2026 20:13:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 152E5C19421;
	Fri, 27 Feb 2026 20:12:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772223195;
	bh=DPPIBtN2jxViPTx92f0FRSM/ZG0jW4iTVJwPfrqzIh8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BoKOHAuNZ9Lyo7Qtb0Xof+aunTUAVWSO8ZoPbTGOPgLQXtV0Yd5aS+UZIgyjqPWyG
	 vZmzq/IjgABznEGt/QBHMye+nvxDauSyr1ob8vYx++A8qeditQSZhx0juhW4Ku3jLI
	 EtPn/NcjeZf5E8HIOEKZaesHsYySld9X2Gq2lh2UwrWDeRAQwg7S8EQwWCpzWOPF3h
	 02mpsuNIVLh3B+yx1arHr+zdp9OkH7YJ2G8iXKu8/U/Is9ylU8rZYRnHH3VXp0Rngh
	 IFj2yD+bA6f/hZFicveu86BbVaR/MWonPQjll+u10qmI3mZsQJPdrOpCxQ5+dIctJ1
	 g6P8BOcpXbHBw==
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
Subject: [PATCH v1 15/16] mm: rename zap_vma_ptes() to zap_special_vma_range()
Date: Fri, 27 Feb 2026 21:08:46 +0100
Message-ID: <20260227200848.114019-16-david@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260227200848.114019-1-david@kernel.org>
References: <20260227200848.114019-1-david@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: BD64C18000F
X-Stat-Signature: r1f9wfod1z53judys4nw8ybxkhkgh7ds
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1772223196-446947
X-HE-Meta: U2FsdGVkX1/49KLxLWix8adeX0UxVZB7eQUb2YaIgZXPjw+w6WbAv7HxZxh1eWqBR9+8oFFY1geCsdWMsd6eH4hNSX8OFayR1yy/S01NAjscyd6hPCwskEY1pdSKFZ+Pzz6Eq7cNBwqpON90j4iiyCpEPQu4uoIvLi6tFchy9Diho1lSlwr/GwCR/xJXrI2Zju4OUKJiI0iNBMtswuSdn0PMqEzZdffG4psFj03xQ+TS5uYPECH+gorPVy9YOEJDE5zdP5apzX0pN6GM5hGk/NsgijgNMYMRUXG7ehH4l3IxWcXb+N+vXQXeihsocLn0cv8zkNi701CHG1aFqY5Uu2RW71Wmea71K00FUQqT+w3iaA42+uyU0dEcnKk/bghVITVWBRxb4AXYbkBT0L0GX44PN9x8rLHuj/22ArnCB00V4jru1VGM1cwOPNB4eknsDNFeycmZeNZ4y078q/9PCoH9gCfU+c03g4ulurRnoOHV8Li5y/f7f+QKDIP7L01AczT0//FjpfQeUHVPTQTyy+pdp4290hreLzhch784x6FWuazRdNjVj0fSfZtYbBUiAnBqUVpLqGbR5p9v3DVcwn3Ytp/+HV2ubl15gJf0xUQIkA7+K/P/aAtnVEgy4J8cAwa+l9rVpFzY/XCAWrsWsz3467DXDO8HG78p3GoIrl3Obpsu9HmaPsxwxp+MzzltYvaieBUi2l5T9f4wSICWAdAQYCWlNfsKYn/PWc0IqmZ2yItri9f+EFHl6sgImrbxkqftPHebnj86FQt4fHDzpPwxsrQiYGfIjl8MDyHf6Nzf1YorraxRbQc+UCv1sbw67wlOkpqOQ4tmDX5xybx/LEEe2KTyI05LBCTgv1YnbZAP+R3VASsy6KP87twzfkRlSPTorkDM4WijNnY6UHnqOKIh+7QSA1OvjGQBs7qYBwkiiIzAPHQlgjxj2thWboW9VbNWAOl6cjBQOLDTV8l
 9SvMZsAF
 xKZOoCG7an+eYEZq8KAPIJRVOdRPlvjFyWbNlPvr5HuD7UDgtHaSqqav+0Ma53sf6we/fdXV4PG5VoCLhGoNx22tDJWJNAEAXyRnv0ogp5t0IRwE3GLCBm6/R/8ip9sDsm0wJJoCiUyDMEvbYouw5LgqEWLp4zjYv6V03LmuivF1hrCj8kld6N1tTEpbxNusXqlwsLSOWSM6Qkr7IS01gLiK7oR/jyuM/LcpsP9IIo1rxlj47HsAkrZzi9Z70iR/64fL5IoTSNzMPRAUvnW/OgIO5Bw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

zap_vma_ptes() is the only zapping function we export to modules.

It's essentially a wrapper around zap_vma_range(), however, with some
safety checks:
* That the passed range fits fully into the VMA
* That it's only used for VM_PFNMAP

We might want to support VM_MIXEDMAP soon as well, so use the
more-generic term "special vma", although "special" is a bit overloaded.
Maybe we'll later just support any VM_SPECIAL flag.

While at it, improve the kerneldoc.

Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 arch/x86/kernel/cpu/sgx/encl.c        |  2 +-
 drivers/comedi/comedi_fops.c          |  2 +-
 drivers/gpu/drm/i915/i915_mm.c        |  4 ++--
 drivers/infiniband/core/uverbs_main.c |  6 +++---
 drivers/misc/sgi-gru/grumain.c        |  2 +-
 include/linux/mm.h                    |  2 +-
 mm/memory.c                           | 16 +++++++---------
 7 files changed, 16 insertions(+), 18 deletions(-)

diff --git a/arch/x86/kernel/cpu/sgx/encl.c b/arch/x86/kernel/cpu/sgx/encl.c
index ac60ebde5d9b..3f0222d10f6e 100644
--- a/arch/x86/kernel/cpu/sgx/encl.c
+++ b/arch/x86/kernel/cpu/sgx/encl.c
@@ -1220,7 +1220,7 @@ void sgx_zap_enclave_ptes(struct sgx_encl *encl, unsigned long addr)
 
 			ret = sgx_encl_find(encl_mm->mm, addr, &vma);
 			if (!ret && encl == vma->vm_private_data)
-				zap_vma_ptes(vma, addr, PAGE_SIZE);
+				zap_special_vma_range(vma, addr, PAGE_SIZE);
 
 			mmap_read_unlock(encl_mm->mm);
 
diff --git a/drivers/comedi/comedi_fops.c b/drivers/comedi/comedi_fops.c
index 48a8a607a84c..b91e0b5ac394 100644
--- a/drivers/comedi/comedi_fops.c
+++ b/drivers/comedi/comedi_fops.c
@@ -2588,7 +2588,7 @@ static int comedi_mmap(struct file *file, struct vm_area_struct *vma)
 	 * remap_pfn_range() because we call remap_pfn_range() in a loop.
 	 */
 	if (retval)
-		zap_vma_ptes(vma, vma->vm_start, size);
+		zap_special_vma_range(vma, vma->vm_start, size);
 #endif
 
 	if (retval == 0) {
diff --git a/drivers/gpu/drm/i915/i915_mm.c b/drivers/gpu/drm/i915/i915_mm.c
index c33bd3d83069..fd89e7c7d8d6 100644
--- a/drivers/gpu/drm/i915/i915_mm.c
+++ b/drivers/gpu/drm/i915/i915_mm.c
@@ -108,7 +108,7 @@ int remap_io_mapping(struct vm_area_struct *vma,
 
 	err = apply_to_page_range(r.mm, addr, size, remap_pfn, &r);
 	if (unlikely(err)) {
-		zap_vma_ptes(vma, addr, (r.pfn - pfn) << PAGE_SHIFT);
+		zap_special_vma_range(vma, addr, (r.pfn - pfn) << PAGE_SHIFT);
 		return err;
 	}
 
@@ -156,7 +156,7 @@ int remap_io_sg(struct vm_area_struct *vma,
 
 	err = apply_to_page_range(r.mm, addr, size, remap_sg, &r);
 	if (unlikely(err)) {
-		zap_vma_ptes(vma, addr, r.pfn << PAGE_SHIFT);
+		zap_special_vma_range(vma, addr, r.pfn << PAGE_SHIFT);
 		return err;
 	}
 
diff --git a/drivers/infiniband/core/uverbs_main.c b/drivers/infiniband/core/uverbs_main.c
index 7b68967a6301..f5837da47299 100644
--- a/drivers/infiniband/core/uverbs_main.c
+++ b/drivers/infiniband/core/uverbs_main.c
@@ -756,7 +756,7 @@ static void rdma_umap_open(struct vm_area_struct *vma)
 	 * point, so zap it.
 	 */
 	vma->vm_private_data = NULL;
-	zap_vma_ptes(vma, vma->vm_start, vma->vm_end - vma->vm_start);
+	zap_special_vma_range(vma, vma->vm_start, vma->vm_end - vma->vm_start);
 }
 
 static void rdma_umap_close(struct vm_area_struct *vma)
@@ -782,7 +782,7 @@ static void rdma_umap_close(struct vm_area_struct *vma)
 }
 
 /*
- * Once the zap_vma_ptes has been called touches to the VMA will come here and
+ * Once the zap_special_vma_range has been called touches to the VMA will come here and
  * we return a dummy writable zero page for all the pfns.
  */
 static vm_fault_t rdma_umap_fault(struct vm_fault *vmf)
@@ -878,7 +878,7 @@ void uverbs_user_mmap_disassociate(struct ib_uverbs_file *ufile)
 				continue;
 			list_del_init(&priv->list);
 
-			zap_vma_ptes(vma, vma->vm_start,
+			zap_special_vma_range(vma, vma->vm_start,
 				     vma->vm_end - vma->vm_start);
 
 			if (priv->entry) {
diff --git a/drivers/misc/sgi-gru/grumain.c b/drivers/misc/sgi-gru/grumain.c
index 8d749f345246..278b76cbd281 100644
--- a/drivers/misc/sgi-gru/grumain.c
+++ b/drivers/misc/sgi-gru/grumain.c
@@ -542,7 +542,7 @@ void gru_unload_context(struct gru_thread_state *gts, int savestate)
 	int ctxnum = gts->ts_ctxnum;
 
 	if (!is_kernel_context(gts))
-		zap_vma_ptes(gts->ts_vma, UGRUADDR(gts), GRU_GSEG_PAGESIZE);
+		zap_special_vma_range(gts->ts_vma, UGRUADDR(gts), GRU_GSEG_PAGESIZE);
 	cch = get_cch(gru->gs_gru_base_vaddr, ctxnum);
 
 	gru_dbg(grudev, "gts %p, cbrmap 0x%lx, dsrmap 0x%lx\n",
diff --git a/include/linux/mm.h b/include/linux/mm.h
index 833bedd3f739..07f6819db02d 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -2833,7 +2833,7 @@ struct page *vm_normal_page_pmd(struct vm_area_struct *vma, unsigned long addr,
 struct page *vm_normal_page_pud(struct vm_area_struct *vma, unsigned long addr,
 		pud_t pud);
 
-void zap_vma_ptes(struct vm_area_struct *vma, unsigned long address,
+void zap_special_vma_range(struct vm_area_struct *vma, unsigned long address,
 		  unsigned long size);
 void zap_vma_range(struct vm_area_struct *vma, unsigned long address,
 			   unsigned long size);
diff --git a/mm/memory.c b/mm/memory.c
index dd737b6d28c0..f3b7b7e16138 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -2233,17 +2233,15 @@ void zap_vma_range(struct vm_area_struct *vma, unsigned long address,
 }
 
 /**
- * zap_vma_ptes - remove ptes mapping the vma
- * @vma: vm_area_struct holding ptes to be zapped
- * @address: starting address of pages to zap
+ * zap_special_vma_range - zap all page table entries in a special vma range
+ * @vma: the vma covering the range to zap
+ * @address: starting address of the range to zap
  * @size: number of bytes to zap
  *
- * This function only unmaps ptes assigned to VM_PFNMAP vmas.
- *
- * The entire address range must be fully contained within the vma.
- *
+ * This function does nothing when the provided address range is not fully
+ * contained in @vma, or when the @vma is not VM_PFNMAP.
  */
-void zap_vma_ptes(struct vm_area_struct *vma, unsigned long address,
+void zap_special_vma_range(struct vm_area_struct *vma, unsigned long address,
 		unsigned long size)
 {
 	if (!range_in_vma(vma, address, address + size) ||
@@ -2252,7 +2250,7 @@ void zap_vma_ptes(struct vm_area_struct *vma, unsigned long address,
 
 	zap_vma_range(vma, address, size);
 }
-EXPORT_SYMBOL_GPL(zap_vma_ptes);
+EXPORT_SYMBOL_GPL(zap_special_vma_range);
 
 static pmd_t *walk_to_pmd(struct mm_struct *mm, unsigned long addr)
 {
-- 
2.43.0


