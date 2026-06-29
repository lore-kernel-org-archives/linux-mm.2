Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 460DFC43327
	for <linux-mm@archiver.kernel.org>; Mon, 29 Jun 2026 12:24:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0DBDB6B00AA; Mon, 29 Jun 2026 08:24:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 08BE56B00B4; Mon, 29 Jun 2026 08:24:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E74786B00B2; Mon, 29 Jun 2026 08:24:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id B76DB6B00B2
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 08:24:31 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 33262A06C2
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 12:24:31 +0000 (UTC)
X-FDA: 84932868342.18.EC404E0
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id 7E5C640006
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 12:24:29 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fd5BiYHC;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782735869;
	b=FA7uv65RqIFbQLD0zHXEqiEnW1b/TgMvLQaLrtDJafjsXCqe0iJSxgkuQXKgAwEX1FEXo4
	W1fpKUDnauCqaM2+o7/H5T4NbLl1VeZKqBC+YH/s8JlSXh4gv+M+g+TVcQwX2FSxS/MAWG
	4ek2dLsA/xpyWFG7R/6EpRBsN1Y1uUU=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782735869;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UswI5k7//YYDNP6iqjwarg/8WzpO9KqTZGGmEfuQG6Q=;
	b=VuqxFkT/OqZC1it53UgFvyJfbkKk3fktrK8T0Z0mm4ug6fD3ND5a/aE/1QvCiRqsqG8+f2
	0+OUM5jGykqkd137y5R34VJiWqlJduI6GcTQPDeWnhIGX1eFDiTVZgi71RA0BMeAT+hpC0
	oiFfJtX60wvVYD8nqxWlthB8G9pR/1c=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fd5BiYHC;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id C1C6340472;
	Mon, 29 Jun 2026 12:24:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C04E21F00A3A;
	Mon, 29 Jun 2026 12:24:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782735868;
	bh=UswI5k7//YYDNP6iqjwarg/8WzpO9KqTZGGmEfuQG6Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fd5BiYHCPq/cwl+1+Rym0zfeZhvt61/icQWdqyx7O0AgVHpX6rG7cRfvIWQKJYLiy
	 6qErxgde5LANsPwbWxQoFLWzItFL9+/3MgT4q4aG2pjB1QIVFnAvC5VhQLo6Z1U9Ff
	 cc1fXpbP4ACrxn1/Y4WBFmBQ1Mvhev+NrKZtKhk10lAwVJptuB3wr9hYkm8H6kxCpu
	 gWT/GhcgdmXEEsEuiz9+zSpVwvyGPWRp1cpftuT7zyqj9Z6Lk0gCr84K0B/UCYxI+2
	 tcuhWfHHHHH4pZkRP6WPoUXVG1TO9EqruwVnGgaVU1IA0okQFLDNaBh/6Z5PQIPUiD
	 0CfKR+Z6RNVMw==
From: Lorenzo Stoakes <ljs@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Russell King <linux@armlinux.org.uk>,
	Dinh Nguyen <dinguyen@kernel.org>,
	Simon Schuster <schuster.simon@siemens-energy.com>,
	"James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
	Helge Deller <deller@gmx.de>,
	Jarkko Sakkinen <jarkko@kernel.org>,
	Thomas Gleixner <tglx@kernel.org>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	x86@kernel.org,
	Ian Abbott <abbotti@mev.co.uk>,
	H Hartley Sweeten <hsweeten@visionengravers.com>,
	Lucas Stach <l.stach@pengutronix.de>,
	David Airlie <airlied@gmail.com>,
	Simona Vetter <simona@ffwll.ch>,
	Patrik Jakobsson <patrik.r.jakobsson@gmail.com>,
	Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
	Maxime Ripard <mripard@kernel.org>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Rob Clark <robin.clark@oss.qualcomm.com>,
	Dmitry Baryshkov <lumag@kernel.org>,
	Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>,
	Thierry Reding <thierry.reding@kernel.org>,
	Mikko Perttunen <mperttunen@nvidia.com>,
	Jonathan Hunter <jonathanh@nvidia.com>,
	Christian Koenig <christian.koenig@amd.com>,
	Huang Rui <ray.huang@amd.com>,
	Ankit Agrawal <ankita@nvidia.com>,
	Alex Williamson <alex@shazbot.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	Dan Williams <djbw@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	David Hildenbrand <david@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	"Liam R . Howlett" <liam@infradead.org>,
	Matthew Wilcox <willy@infradead.org>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Arnaldo Carvalho de Melo <acme@kernel.org>,
	Namhyung Kim <namhyung@kernel.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Oleg Nesterov <oleg@redhat.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	SeongJae Park <sj@kernel.org>,
	Miaohe Lin <linmiaohe@huawei.com>,
	Hugh Dickins <hughd@google.com>,
	Mike Rapoport <rppt@kernel.org>,
	Kees Cook <kees@kernel.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-parisc@vger.kernel.org,
	linux-sgx@vger.kernel.org,
	etnaviv@lists.freedesktop.org,
	dri-devel@lists.freedesktop.org,
	linux-arm-msm@vger.kernel.org,
	freedreno@lists.freedesktop.org,
	linux-tegra@vger.kernel.org,
	kvm@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	nvdimm@lists.linux.dev,
	linux-mm@kvack.org,
	iommu@lists.linux.dev,
	linux-perf-users@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org,
	kasan-dev@googlegroups.com,
	damon@lists.linux.dev,
	Pedro Falcato <pfalcato@suse.de>,
	Rik van Riel <riel@surriel.com>,
	Harry Yoo <harry@kernel.org>,
	Jann Horn <jannh@google.com>
Subject: [PATCH 11/30] mm/vma: introduce and use vmg_pages(), vmg_[start, end]_pgoff()
Date: Mon, 29 Jun 2026 13:23:22 +0100
Message-ID: <f7b4f8a611ab4d36eb3cf2e394610a3744a93895.1782735110.git.ljs@kernel.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <cover.1782735110.git.ljs@kernel.org>
References: <cover.1782735110.git.ljs@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 7E5C640006
X-Rspam-User: 
X-Stat-Signature: irh694a8hkkwcaj1ap47qkhedkfnyiwk
X-HE-Tag: 1782735869-647186
X-HE-Meta: U2FsdGVkX194LjeghjHxy5WSpx0e2RqNSfl5UqFHY/ypN8hAVhhna9/t6vywAw4a6xU9V/p6zB5P3QTu4qbOxmp3gtbanTNhPheCQYKoZljbsQvKQoC/y1rpyypuLZyuUmqBH+CqWMpgnbuq/hNZOkOm3jfZD4TFVG/w0ZHqubItslHs4OzxUGrhojk/TLD16mX79fzqFecX9F+OuVy/qY2EGPhx9AzgtwNbmb9Vdaup6jpNN7o+up3iw28n6C8oa5NHSmWa7KurLz1ZPt+pKdfNvf41NUBniNlTILquJzTpfQ5au7UHOEQSHOj9sQPSFnBMCzwC3syN3JmXmcFGiYU53OC5h9dUAyyamruYp+gr7UHjCgx7FoXouG1pS5v4A1I/tf3IgtQBrJjsmv5yzBQvFzt3P1rkv4iqG7zcWcwFSC1cWaeWxQ9yHge+bkkZ9Qgbls/pz5qoSy4P2kGix4s0iMuxWzbpNvgSGxscGqBoJAdl3ACTG0CmwEtGbJohoNyj7gl0kpZwzZx88XAXT8saBtWWfG7WLz0Cr3cMojsNKOhNZE+9T/Qlc/Ticb5nKEA/qYb5t4KUSi+L/3FfNW6hFmkJpaTO5kMVnHYYPcZllvUw9BARq3apBDAwpASeOnwnVdFMV8iBA+kj90XMVdEp30+qVZGYtKEXptk5mKU+fn31N1BscVhXeXrpNppDAz98T0ZF1igZEAYxyNFEUMoJTxZPRog5UcpETtMOQAR3tZXJVhrj9On3Ae+VMbN1OKzz//Rcd6+WiWjOrjQ1m8TfZ3bj1hojhykDqtxpQ8ts8jAfUXk6P+1ALUy/txBloQQTovHZxwwhhzFmBQICoMBtdOJUMRDZ3bQtEUaVtvA5S9FAvgxIdb8zsEPJk4HsGFTljP8XFzlM2Ihk4p0iQMmQyoZEbXNqqgNXeDbmBrd4KFKjD2Ae/zJXDvA1HhULND5VoE/KrWZWCTATIzp
 BWTmkS4O
 t1zQwje16JWk5hpzsVeekL5ZoP/NbjApZx689aLVUPhJdxL3S90RM2/u5vTsEx7Qs6dj/Pp7DhFWAFCS/z1MYP+8yWcNmiIZ5HFo5GQZmYjBPUTBhg3TA9Enk/PuW3mNXg4QExoE2id9Fmi81+vGLWZEPno7GhIW5ypjrMn1SweV5whdtQJqIijrL2hq/4Ec8O69zH7ensJb4fss9Umk0VS0AS0IxOXBRhAEbTvrVgf+MBwat8AtIjKdY/OsBaPFs18XPVk36KX/MCynuknCGtFPogtL324sddCiE2AZlv1IibWvW4hKxn9hztULqsr+pgOV4jZ6Qzl0lPW7kAxwux1XyXOEkJ/+Kqt1HKRvvN+UpJHA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

In the VMA logic we often need to determine the number of pages in the
specified merge range, as well as the start and end page offsets of that
range.

Introduce and use helpers for these purposes.

No functional change intended.

Signed-off-by: Lorenzo Stoakes <ljs@kernel.org>
---
 mm/vma.c                        | 11 ++++-------
 mm/vma.h                        | 17 +++++++++++++++++
 tools/testing/vma/include/dup.h | 10 ++++++++++
 3 files changed, 31 insertions(+), 7 deletions(-)

diff --git a/mm/vma.c b/mm/vma.c
index 2be0dbd7bb7b..b60375c6c5c3 100644
--- a/mm/vma.c
+++ b/mm/vma.c
@@ -197,11 +197,9 @@ static void init_multi_vma_prep(struct vma_prepare *vp,
  */
 static bool can_vma_merge_before(struct vma_merge_struct *vmg)
 {
-	pgoff_t pglen = PHYS_PFN(vmg->end - vmg->start);
-
 	if (is_mergeable_vma(vmg, /* merge_next = */ true) &&
 	    is_mergeable_anon_vma(vmg, /* merge_next = */ true)) {
-		if (vmg->next->vm_pgoff == vmg->pgoff + pglen)
+		if (vmg_end_pgoff(vmg) == vma_start_pgoff(vmg->next))
 			return true;
 	}
 
@@ -221,7 +219,7 @@ static bool can_vma_merge_after(struct vma_merge_struct *vmg)
 {
 	if (is_mergeable_vma(vmg, /* merge_next = */ false) &&
 	    is_mergeable_anon_vma(vmg, /* merge_next = */ false)) {
-		if (vmg->prev->vm_pgoff + vma_pages(vmg->prev) == vmg->pgoff)
+		if (vma_end_pgoff(vmg->prev) == vmg_start_pgoff(vmg))
 			return true;
 	}
 	return false;
@@ -759,7 +757,7 @@ static int commit_merge(struct vma_merge_struct *vmg)
 	 */
 	vma_adjust_trans_huge(vma, vmg->start, vmg->end,
 			      vmg->__adjust_middle_start ? vmg->middle : NULL);
-	vma_set_range(vma, vmg->start, vmg->end, vmg->pgoff);
+	vma_set_range(vma, vmg->start, vmg->end, vmg_start_pgoff(vmg));
 	vmg_adjust_set_range(vmg);
 	vma_iter_store_overwrite(vmg->vmi, vmg->target);
 
@@ -962,8 +960,7 @@ static __must_check struct vm_area_struct *vma_merge_existing_range(
 		 *    middle     next
 		 * shrink/delete extend
 		 */
-
-		pgoff_t pglen = PHYS_PFN(vmg->end - vmg->start);
+		const pgoff_t pglen = vmg_pages(vmg);
 
 		VM_WARN_ON_VMG(!merge_right, vmg);
 		/* If we are offset into a VMA, then prev must be middle. */
diff --git a/mm/vma.h b/mm/vma.h
index 8e4b61a7304c..527716c8739d 100644
--- a/mm/vma.h
+++ b/mm/vma.h
@@ -230,6 +230,23 @@ static inline bool vmg_nomem(struct vma_merge_struct *vmg)
 	return vmg->state == VMA_MERGE_ERROR_NOMEM;
 }
 
+static inline pgoff_t vmg_start_pgoff(const struct vma_merge_struct *vmg)
+{
+	return vmg->pgoff;
+}
+
+static inline pgoff_t vmg_pages(const struct vma_merge_struct *vmg)
+{
+	const unsigned long size = vmg->end - vmg->start;
+
+	return size >> PAGE_SHIFT;
+}
+
+static inline pgoff_t vmg_end_pgoff(const struct vma_merge_struct *vmg)
+{
+	return vmg_start_pgoff(vmg) + vmg_pages(vmg);
+}
+
 /* Assumes addr >= vma->vm_start. */
 static inline pgoff_t vma_pgoff_offset(struct vm_area_struct *vma,
 				       unsigned long addr)
diff --git a/tools/testing/vma/include/dup.h b/tools/testing/vma/include/dup.h
index bf26b3f48d3a..535747d7fee4 100644
--- a/tools/testing/vma/include/dup.h
+++ b/tools/testing/vma/include/dup.h
@@ -1301,6 +1301,16 @@ static inline unsigned long vma_pages(const struct vm_area_struct *vma)
 	return (vma->vm_end - vma->vm_start) >> PAGE_SHIFT;
 }
 
+static inline pgoff_t vma_start_pgoff(const struct vm_area_struct *vma)
+{
+	return vma->vm_pgoff;
+}
+
+static inline pgoff_t vma_end_pgoff(const struct vm_area_struct *vma)
+{
+	return vma_start_pgoff(vma) + vma_pages(vma);
+}
+
 static inline int vfs_mmap_prepare(struct file *file, struct vm_area_desc *desc)
 {
 	return file->f_op->mmap_prepare(desc);
-- 
2.54.0


