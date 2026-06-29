Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 03503C43458
	for <linux-mm@archiver.kernel.org>; Mon, 29 Jun 2026 12:25:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4FAA46B00D3; Mon, 29 Jun 2026 08:25:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4D3516B00D7; Mon, 29 Jun 2026 08:25:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 39A5F6B00D8; Mon, 29 Jun 2026 08:25:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 045486B00D3
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 08:25:15 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 8A050A05F5
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 12:25:15 +0000 (UTC)
X-FDA: 84932870190.11.E22EF47
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf08.hostedemail.com (Postfix) with ESMTP id DF136160015
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 12:25:13 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=TgqC78of;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782735913;
	b=50jPqffbZmh/QsSbPRBT3tCNjFydPUYbZa7l+7iOWMfrAclZL5sqZFYrAIuWlyoAr0leZd
	uITEbEJjLanl/RlSvAdganggVbNZQYEIETm1q0LvUCIIevtBrUDVZzBaQ2Henmo5do0VSb
	Lh01y9b2/xva1s2C9oDtBAeYpow5q2Y=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782735913;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DVaVwtD/YAzrfGJ2wPEBHWUnW7o191nw2vqkxZjY3Jw=;
	b=HnNnc98M8iKeeiM+1PuLWoVr/wU34fUThNs7IcHB3QVP/Nz3Trfg+hPa+g/B50b0V65cq9
	kmSDjvMyhFgXQiXOSRIOccWxHYj3XFs6iX6U6r4JwkwVl0i7XJhMXDWF/P0E3tuNk9n2hK
	hNNgtDvOt7mZ5IxrzRGWZl9je4CSb4g=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=TgqC78of;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 739BE600AA;
	Mon, 29 Jun 2026 12:25:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A9FB1F000E9;
	Mon, 29 Jun 2026 12:25:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782735913;
	bh=DVaVwtD/YAzrfGJ2wPEBHWUnW7o191nw2vqkxZjY3Jw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TgqC78ofk9v1RrRyLce5+3TleoIZPAtXaIyZ6fzsHFjFdozTq2QBLY3gm4IGtuTiC
	 EwF+WyI2H/isawxxImP0y71reCK5jNgEK5nWyzuTw5dpKH9hDysj0jLSQ7m7EbtOGc
	 Nz3/MPcHAgDN2lkGo/hMPKHzyCWcv0QYrWPuQ9v7E9gfnrQACSB4LdjlRCrTJZiKnB
	 U9Sd2OpiW/Oifq+yv83CtBcL4hWV82gHlSrNEWvDOO4/Xde+nzxUKfwQJu0FGSn43x
	 Fhlnfp9yzmBZ5xXoM/j/e6KCGxDRbggvmrKSqPx2wzHJVSvYOjZc1wz8yqKynID0+s
	 mA89hNnI/tl3g==
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
Subject: [PATCH 26/30] mm/vma: introduce and use vma_set_pgoff()
Date: Mon, 29 Jun 2026 13:23:37 +0100
Message-ID: <37f4d951897641f304dba26f6f91ade03a50eb01.1782735110.git.ljs@kernel.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <cover.1782735110.git.ljs@kernel.org>
References: <cover.1782735110.git.ljs@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: DF136160015
X-Rspam-User: 
X-Stat-Signature: oi8h4ze5bkf9xfoc5piyo58taddhue3w
X-HE-Tag: 1782735913-476234
X-HE-Meta: U2FsdGVkX1+j3rQl7cAg3KRwgATD7y6BGa1HOQa2fEYKDxFXhX2peL/xevzz4rpFbEKc6WoNitiMmvWr16oPhNFKx1IqEluv+1Gb+bPjfVWdHEEwbVoT+wLiE99csXHtTXcNOwO0HUBtsgux3hs6sAwHh6DaGr6FmqjHLfFB/1vPEuxTJyAT1JoFR8sWUiy/2pdOQzndyY0TkDCs8dAkeQeWC1fKZYzZUFIKeHQ/oM649K9YnITTDPVH75dZQeqOG4Icqf5tqMlRiC6eUko5LjaPZmaGmYgKeNemeBHp0WHsr8qj6x3AbVR8qjNj3jDg4bB6bfIZeMIcYcIzhN5+wV1e6XS8BdYYTEEhLbQiYCe923JNIEgQovCBhMgFh2eJckJZGyHpt2MCrMmldRviPs005BTyqVu7/3w2iEUC7UMYhtfZiy4sXqCkU6skqovWdDbs+trMYkBPSWE6+Xw6sI3wm1pgopGhCizzss1gXrGXUimZ+iO5xyKlSu5IeqZh4xBO++nUyapNNstlIAeTouhKmCfYExZ9otzlyqiU88xznGFFqbgKkiXGx155H3hSbh8PkfosRE1rVX0en8RuwtamUEsAH64V3aKK8yYpFLX/15JBiIOO1SepuRx8ObJU/gpU4cIGQP0HwtshdLIosdJl8c8x3dtBCXRo2JktWu6B5k6JBq0Lbb0kdOKmHEA3qsGwdf2qoZsnNh4qJfvTD2sCh8DsN3PHzeik/Ls80OvPVJj3GOp+4Hw19GWRtU7Bjh5rh5idSO+tkhkcz2wxPPpovy0OmaT19D3n0x2KdvRVnvMfepEXiQx75b5IyBwDxbyEIvWYck8ScAe4K5b3Y3Um/KMHg7VAjhYnfqNrpP5ysHZuJ8lTkdGq0bW9afIFdpCrFeN4KvyxNRykk6yOZCigI2ydcCGfh56WtXoVOG/KhxZPiCBK4GqCQ7xel2kQa/EYZFqrYbour9VL+6w
 mOvEsGrK
 etDaan5BcqUNSYCZPVVHt4dDKMS0sz8znVslgFvghwStO2OQ+maEPlku8wYZ3Duk117FTl3DhG4/o0moKddsIEvGQudGq3dZRhi9xbsfCQ1FVbvJ5RnFgcAof6ApAqoVa4eJYSsglvSJlfd53PI/GIT/qDZOvNJbjUkmt69xAUNwswqN6Ol5muanXxfLp7qzhPgIp+mj4XDRC9hytXIAHhSNZ0OU3bcbqbVUCor6xJLPSVdV/OyxWImzSCEuLG63oDs1t8FvRh6ZPD9xf9XcyuoNwqo97g/LzXVOwRMN0McnDBSJHHGpovufErcfO8yPtO+0hdG1Aj/qpykZixbc/+yV82kmza58i/ESYlQmmxUylD8k=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

In order to lay the foundation for work that permits us to track the
virtual page offset of MAP_PRIVATE file-backed mappings, we abstract the
assignment of vma->vm_pgoff to vma_set_pgoff().

We additionally add a lock check here using the newly introduced
vma_assert_can_modify(). This asserts the VMA write lock if the VMA is
attached.

We also assert that, if this is an anonymous VMA and unfaulted, that its
(virtual) page offset is equal to the page offset of the VMA's address.

In order to maintain correctness given this assert, we also update
__install_special_mapping() to invoke vma_set_range() after it's set
vma->vm_ops (which determine whether the VMA is anonymous or not).

We do not use vma_set_pgoff() in vm_area_init_from(), as at the point of
forking, we don't necessarily have correct locking state.

Updating vma_set_range() covers most cases, but in addition to this we also
update insert_vm_struct(), compat_set_vma_from_desc() and nommu callers.

We also update vma_add_pgoff() and vma_sub_pgoff() to use vma_set_pgoff().

While we're here, we drop a BUG_ON() and update insert_vm_struct()'s
comment to reflect the fact anonymous mappings can be added here.

No functional change intended.

Signed-off-by: Lorenzo Stoakes <ljs@kernel.org>
---
 mm/nommu.c                      |  2 +-
 mm/vma.c                        | 14 +++++++-------
 mm/vma.h                        | 15 ++++++++++++---
 tools/testing/vma/include/dup.h |  2 +-
 4 files changed, 21 insertions(+), 12 deletions(-)

diff --git a/mm/nommu.c b/mm/nommu.c
index c7fafcd87c14..ba1c923c0942 100644
--- a/mm/nommu.c
+++ b/mm/nommu.c
@@ -1059,7 +1059,7 @@ unsigned long do_mmap(struct file *file,
 	region->vm_pgoff = pgoff;
 
 	vm_flags_init(vma, vm_flags);
-	vma->vm_pgoff = pgoff;
+	vma_set_pgoff(vma, pgoff);
 
 	if (file) {
 		region->vm_file = get_file(file);
diff --git a/mm/vma.c b/mm/vma.c
index 0579fc8c9bd5..d727150e377a 100644
--- a/mm/vma.c
+++ b/mm/vma.c
@@ -81,7 +81,7 @@ static void vma_set_range(struct vm_area_struct *vma, unsigned long start,
 			  unsigned long end, pgoff_t pgoff)
 {
 	__vma_set_range(vma, start, end);
-	vma->vm_pgoff = pgoff;
+	vma_set_pgoff(vma, pgoff);
 }
 
 /* Was this VMA ever forked from a parent, i.e. maybe contains CoW mappings? */
@@ -3345,9 +3345,9 @@ int __vm_munmap(unsigned long start, size_t len, bool unlock)
 	return ret;
 }
 
-/* Insert vm structure into process list sorted by address
- * and into the inode's i_mmap tree.  If vm_file is non-NULL
- * then i_mmap_rwsem is taken here.
+/*
+ * Insert vm structure into process list sorted by address
+ * and into the inode's i_mmap tree if file-backed.
  */
 int insert_vm_struct(struct mm_struct *mm, struct vm_area_struct *vma)
 {
@@ -3373,8 +3373,8 @@ int insert_vm_struct(struct mm_struct *mm, struct vm_area_struct *vma)
 	 * Similarly in do_mmap and in do_brk_flags.
 	 */
 	if (vma_is_anonymous(vma)) {
-		BUG_ON(vma->anon_vma);
-		vma->vm_pgoff = vma->vm_start >> PAGE_SHIFT;
+		WARN_ON_ONCE(vma->anon_vma);
+		vma_set_pgoff(vma, vma->vm_start >> PAGE_SHIFT);
 	}
 
 	if (vma_link(mm, vma)) {
@@ -3420,7 +3420,6 @@ struct vm_area_struct *__install_special_mapping(
 	if (unlikely(vma == NULL))
 		return ERR_PTR(-ENOMEM);
 
-	vma_set_range(vma, addr, addr + len, 0);
 	vm_flags |= mm->def_flags | VM_DONTEXPAND;
 	if (pgtable_supports_soft_dirty())
 		vm_flags |= VM_SOFTDIRTY;
@@ -3429,6 +3428,7 @@ struct vm_area_struct *__install_special_mapping(
 
 	vma->vm_ops = ops;
 	vma->vm_private_data = priv;
+	vma_set_range(vma, addr, addr + len, 0);
 
 	ret = insert_vm_struct(mm, vma);
 	if (ret)
diff --git a/mm/vma.h b/mm/vma.h
index 9658e0c678ad..155eadda47aa 100644
--- a/mm/vma.h
+++ b/mm/vma.h
@@ -247,16 +247,25 @@ static inline pgoff_t vmg_end_pgoff(const struct vma_merge_struct *vmg)
 	return vmg_start_pgoff(vmg) + vmg_pages(vmg);
 }
 
+static inline void vma_set_pgoff(struct vm_area_struct *vma, pgoff_t pgoff)
+{
+	vma_assert_can_modify(vma);
+
+	VM_WARN_ON_ONCE(vma_is_anonymous(vma) && !vma->anon_vma &&
+			pgoff != vma->vm_start >> PAGE_SHIFT);
+	vma->vm_pgoff = pgoff;
+}
+
 static inline void vma_add_pgoff(struct vm_area_struct *vma, pgoff_t delta)
 {
 	vma_assert_can_modify(vma);
-	vma->vm_pgoff += delta;
+	vma_set_pgoff(vma, vma_start_pgoff(vma) + delta);
 }
 
 static inline void vma_sub_pgoff(struct vm_area_struct *vma, pgoff_t delta)
 {
 	vma_assert_can_modify(vma);
-	vma->vm_pgoff -= delta;
+	vma_set_pgoff(vma, vma_start_pgoff(vma) - delta);
 }
 
 #define VMG_STATE(name, mm_, vmi_, start_, end_, vma_flags_, pgoff_)	\
@@ -332,7 +341,7 @@ static inline void compat_set_vma_from_desc(struct vm_area_struct *vma,
 	 */
 
 	/* Mutable fields. Populated with initial state. */
-	vma->vm_pgoff = desc->pgoff;
+	vma_set_pgoff(vma, desc->pgoff);
 	if (desc->vm_file != vma->vm_file)
 		vma_set_file(vma, desc->vm_file);
 	vma->flags = desc->vma_flags;
diff --git a/tools/testing/vma/include/dup.h b/tools/testing/vma/include/dup.h
index 41fea90a344d..5d7d0afd7765 100644
--- a/tools/testing/vma/include/dup.h
+++ b/tools/testing/vma/include/dup.h
@@ -1186,7 +1186,7 @@ static inline void vma_assert_can_modify(struct vm_area_struct *vma)
 
 static inline void vma_assert_detached(struct vm_area_struct *vma)
 {
-	WARN_ON_ONCE(refcount_read(&vma->vm_refcnt));
+	WARN_ON_ONCE(vma_is_attached(vma));
 }
 
 static inline void vma_assert_write_locked(struct vm_area_struct *);
-- 
2.54.0


