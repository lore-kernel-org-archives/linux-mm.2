Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E1F98C43327
	for <linux-mm@archiver.kernel.org>; Mon, 29 Jun 2026 12:24:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C25606B00AD; Mon, 29 Jun 2026 08:24:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BFC6B6B00AF; Mon, 29 Jun 2026 08:24:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A013B6B00B0; Mon, 29 Jun 2026 08:24:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 6AA8A6B00AD
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 08:24:25 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id E2E0B1680B4
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 12:24:24 +0000 (UTC)
X-FDA: 84932868048.16.F9EC3AA
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf07.hostedemail.com (Postfix) with ESMTP id 5535240009
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 12:24:23 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=amzMk8Db;
	spf=pass (imf07.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782735863;
	b=4eeJzZUiL9BC2zF89IL6yQ8EF8JOHexs68vJlxQVyqXKQPrv9PDgyf4qtu2TZlgPaJgbpw
	61LFTRZvvzD5Qq6tBdNyDghzIe+2/1wLtw1rGhwjuzcZc+DLQBarZUOpNjlZEjQhveYp8Q
	vKl2n/TFYTsgbIFBJh+eO/7CsaYZI0Y=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782735863;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hQBhrlaFFzk+ZEcRGFKtVXitFg8rNyhgcTwmw17Dzcc=;
	b=NcVvTLwWNeFukPu99rqtf/3FHex8+e/VbZb5/monjSe6JbVCODwVpGMOnU7fQ+pTW12qwj
	dnDAY+ezWcQbCGv1gfCNQewnL10c5hVK80PbgMAKxTkRZAZmpVP5qhNZZ5ORmcQbqZEaX+
	3CJac0gJz2g+5QCvN6I3jSpJoDnwxuM=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=amzMk8Db;
	spf=pass (imf07.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id CF64C601BF;
	Mon, 29 Jun 2026 12:24:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B76661F00A3E;
	Mon, 29 Jun 2026 12:24:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782735862;
	bh=hQBhrlaFFzk+ZEcRGFKtVXitFg8rNyhgcTwmw17Dzcc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=amzMk8DbKDuhgmPjwVqU/huK5Y97Ptitr13OYucPMSAAlWOHQvBHeXwZN7m0Ph+Zb
	 Ca1QkgMNan2TxDbZWvZpyUwEVUbZLHWqIVfGpqGQglbKIoNYZL2pcronT9GkzAH0N2
	 5cKYzCylPojC/iT2hsGojmuNj79gUpL5+pB7oMEnNyCFEbCXgDNHBy3SJw7hcGfnHc
	 gj6B1qSn3JpSNWFuCvaBtt5VRADfwN+d96UGq+BzM+1t7AWWvABsgM2yoOQ7n3hdTT
	 w+S/iYqLwhYHF2tsFEBg9XjF3mJ+84R1mbn80AICmXJyLgGmsLEgOo+kNBOzFiY+3w
	 AKqrjMBIO2IoQ==
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
Subject: [PATCH 09/30] mm/rmap: parameterise anon_vma_interval_tree_*() by anon_vma
Date: Mon, 29 Jun 2026 13:23:20 +0100
Message-ID: <1c1df7b905ef340cbf2effef769a4e770a8e0eb1.1782735110.git.ljs@kernel.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <cover.1782735110.git.ljs@kernel.org>
References: <cover.1782735110.git.ljs@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 5535240009
X-Stat-Signature: dur7mi8ep5n1k31qp3cw8my3q8oz43ip
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1782735863-959080
X-HE-Meta: U2FsdGVkX1+wufJWLWFvDZWYbG2jM90548+XsNOY08z14smtlF5XwL5WAhC5qSKzwVvoBVR409PKuS9p0NycteyYAVyGnvVk3fHIDA1/O0eNxqUD2/VDVPumj3CsKk+FaZ/WBlfskGv7YrZ3GUG2qOQ7D8BFLZhO1+VmFwFg4ZuMj9Cc4hLi1dfm8dTsImOvGyQuiHfD4gJtor2/HBzxinabyUm4fMM+RkPofJL1lfU2PNmPdglfjkIHf1uAf/IMJVEbS9H42zLLhGe1IWT/b/0Du5Q/tbBQtHPrtAlSc9HgucaKaoHxih9BUaNoggOz6qp8BAVY7i7rC20Ow55HFdgfzU18dpMq+FnjU6njf15VvRE73VSmmMz1cGqNBu1FpF2ISdaLQRysNnvaL3VP81jJ1Ti9NLlpBFU4EKNCmjpSwk6rI5FORZOLDpMiTuiqt8IMuonzBxkU9PNkhuD2ygCZ4bHZVgV8BfC6STlh0k//BCLG86KtCpM3YBVJAlvPM9BtnT+aNLUadqzmz3BmhwgCSb/JQxsIKcNRQrGrhgPtFxSk61PAexMxSev0iGpNT8zX5NGB3iQYOVVpIWCpgKbFuEj1GYNHMGYyBaH1XryLwUJmpD5fdDTcbrYzpXbDULaKef3MG1+m/vj1F8HjCzZx2wEj8XaQm/momCmYRvU72DHkhBVBzo/dWcTHsNZExcep1j46G2R1GvsY06DBUBCDD0bdv2ABer6rSAsOj4L98RAUH6QpWk05ud00tXIc2XBi/iRa0w66SchcOam1XR7pnszZo/9uAHiW6keMAUKHicnoKrhhFa/F1f+jc2agth9S9RpeddQrnaLSRnazkzJj+k0jXX78hj1N+PlABPzc6emI/QPfErSLcf38SKFI2OeTQdGtwLgYeqiMVB+ZaNRKY2vyDKFpS2oQBcjAyDhd1mtk+2pRkUmI4qlag8khWV8QBT1r2uGbks4x88a
 5a8bHXlr
 qJLhg0inUVlHoxOJ02DmhInebwIFSY+OuKCz6C72gvEkz4hQhepvkEJXrsb49uYU9h2FEhH/uG1CvcJXB7FETcV4d9x81Bxv0FnsztI+OxgawnHE5ZP/GUFwuicYtmXGwakiOH29eD5RzKTlXtR7XBkI8fyyVNeb55Sat8SnI3KmVvVF2fcj6gNgBYpc4cqhQxja8vTZGsA1lF/+BkhnABEPHZCjQ/3qTPteby78iTZFD8jUPVWaAVtaNgxKNOI1lj906puoPYGKIW/a+WicwfyzaWwfKX+M3aQCJPlM6JT8J0Gt4WPsOKKIk6LkkMH9Wg+mekcVEiUt08Ig+Q/y8rWxR7+iqOxIERNtX
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Similar to what we did with mapping_interval_tree*(), let's declare
anon_vma_interval_tree*() in terms of anon_vma rather than rb_root_cached.

In each case the rb tree referenced is &anon_vma->rb_root, so just pass
anon_vma and the functions can figure this out themselves.

Additionally, rename 'node' to 'avc', 'index' to 'pgoff_start', and 'last'
to 'pgoff_last' to make clear what is being passed.

Finally express page offsets in terms of pgoff_t to be consistent.

No functional change intended.

Signed-off-by: Lorenzo Stoakes <ljs@kernel.org>
---
 include/linux/mm.h                | 27 +++++++++++---------
 mm/interval_tree.c                | 41 ++++++++++++++++---------------
 mm/ksm.c                          |  7 ++----
 mm/memory-failure.c               |  3 +--
 mm/rmap.c                         | 11 ++++-----
 mm/vma.c                          |  4 +--
 tools/testing/vma/include/stubs.h |  4 +--
 7 files changed, 48 insertions(+), 49 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 703e07ff7d12..cf2d42747064 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -4081,22 +4081,25 @@ mapping_interval_tree_iter_next(struct vm_area_struct *vma,
 	     vma; vma = mapping_interval_tree_iter_next(vma, pgoff_start,    \
 							pgoff_last))
 
-void anon_vma_interval_tree_insert(struct anon_vma_chain *node,
-				   struct rb_root_cached *root);
-void anon_vma_interval_tree_remove(struct anon_vma_chain *node,
-				   struct rb_root_cached *root);
+void anon_vma_interval_tree_insert(struct anon_vma_chain *avc,
+				   struct anon_vma *anon_vma);
+void anon_vma_interval_tree_remove(struct anon_vma_chain *avc,
+				   struct anon_vma *anon_vma);
 struct anon_vma_chain *
-anon_vma_interval_tree_iter_first(struct rb_root_cached *root,
-				  unsigned long start, unsigned long last);
-struct anon_vma_chain *anon_vma_interval_tree_iter_next(
-	struct anon_vma_chain *node, unsigned long start, unsigned long last);
+anon_vma_interval_tree_iter_first(struct anon_vma *anon_vma,
+				  pgoff_t pgoff_start, pgoff_t pgoff_last);
+struct anon_vma_chain *
+anon_vma_interval_tree_iter_next(struct anon_vma_chain *avc,
+				 pgoff_t pgoff_start, pgoff_t pgoff_last);
 #ifdef CONFIG_DEBUG_VM_RB
-void anon_vma_interval_tree_verify(struct anon_vma_chain *node);
+void anon_vma_interval_tree_verify(struct anon_vma_chain *avc);
 #endif
 
-#define anon_vma_interval_tree_foreach(avc, root, start, last)		 \
-	for (avc = anon_vma_interval_tree_iter_first(root, start, last); \
-	     avc; avc = anon_vma_interval_tree_iter_next(avc, start, last))
+#define anon_vma_interval_tree_foreach(avc, anon_vma, pgoff_start, pgoff_last) \
+	for (avc = anon_vma_interval_tree_iter_first(anon_vma, pgoff_start,    \
+						     pgoff_last);	       \
+	     avc; avc = anon_vma_interval_tree_iter_next(avc, pgoff_start,     \
+							 pgoff_last))
 
 /* mmap.c */
 extern int __vm_enough_memory(const struct mm_struct *mm, long pages, int cap_sys_admin);
diff --git a/mm/interval_tree.c b/mm/interval_tree.c
index cbd3038e46a9..d90e962b28f7 100644
--- a/mm/interval_tree.c
+++ b/mm/interval_tree.c
@@ -81,54 +81,55 @@ mapping_interval_tree_iter_next(struct vm_area_struct *vma,
 
 /* Anonymous interval tree (anon_vma->rb_root) */
 
-static unsigned long avc_start_pgoff(struct anon_vma_chain *avc)
+static pgoff_t avc_start_pgoff(struct anon_vma_chain *avc)
 {
 	return vma_start_pgoff(avc->vma);
 }
 
-static unsigned long avc_last_pgoff(struct anon_vma_chain *avc)
+static pgoff_t avc_last_pgoff(struct anon_vma_chain *avc)
 {
 	return vma_last_pgoff(avc->vma);
 }
 
-INTERVAL_TREE_DEFINE(struct anon_vma_chain, rb, unsigned long, rb_subtree_last,
+INTERVAL_TREE_DEFINE(struct anon_vma_chain, rb, pgoff_t, rb_subtree_last,
 		     avc_start_pgoff, avc_last_pgoff,
 		     static, __anon_vma_interval_tree)
 
-void anon_vma_interval_tree_insert(struct anon_vma_chain *node,
-				   struct rb_root_cached *root)
+void anon_vma_interval_tree_insert(struct anon_vma_chain *avc,
+				   struct anon_vma *anon_vma)
 {
 #ifdef CONFIG_DEBUG_VM_RB
-	node->cached_vma_start = avc_start_pgoff(node);
-	node->cached_vma_last = avc_last_pgoff(node);
+	avc->cached_vma_start = avc_start_pgoff(avc);
+	avc->cached_vma_last = avc_last_pgoff(avc);
 #endif
-	__anon_vma_interval_tree_insert(node, root);
+	__anon_vma_interval_tree_insert(avc, &anon_vma->rb_root);
 }
 
-void anon_vma_interval_tree_remove(struct anon_vma_chain *node,
-				   struct rb_root_cached *root)
+void anon_vma_interval_tree_remove(struct anon_vma_chain *avc,
+				   struct anon_vma *anon_vma)
 {
-	__anon_vma_interval_tree_remove(node, root);
+	__anon_vma_interval_tree_remove(avc, &anon_vma->rb_root);
 }
 
 struct anon_vma_chain *
-anon_vma_interval_tree_iter_first(struct rb_root_cached *root,
-				  unsigned long first, unsigned long last)
+anon_vma_interval_tree_iter_first(struct anon_vma *anon_vma,
+				  pgoff_t pgoff_start, pgoff_t pgoff_last)
 {
-	return __anon_vma_interval_tree_iter_first(root, first, last);
+	return __anon_vma_interval_tree_iter_first(&anon_vma->rb_root,
+						   pgoff_start, pgoff_last);
 }
 
 struct anon_vma_chain *
-anon_vma_interval_tree_iter_next(struct anon_vma_chain *node,
-				 unsigned long first, unsigned long last)
+anon_vma_interval_tree_iter_next(struct anon_vma_chain *avc,
+				 pgoff_t pgoff_start, pgoff_t pgoff_last)
 {
-	return __anon_vma_interval_tree_iter_next(node, first, last);
+	return __anon_vma_interval_tree_iter_next(avc, pgoff_start, pgoff_last);
 }
 
 #ifdef CONFIG_DEBUG_VM_RB
-void anon_vma_interval_tree_verify(struct anon_vma_chain *node)
+void anon_vma_interval_tree_verify(struct anon_vma_chain *avc)
 {
-	WARN_ON_ONCE(node->cached_vma_start != avc_start_pgoff(node));
-	WARN_ON_ONCE(node->cached_vma_last != avc_last_pgoff(node));
+	WARN_ON_ONCE(avc->cached_vma_start != avc_start_pgoff(avc));
+	WARN_ON_ONCE(avc->cached_vma_last != avc_last_pgoff(avc));
 }
 #endif
diff --git a/mm/ksm.c b/mm/ksm.c
index 7d5b76478f0b..c6a6e1ef581d 100644
--- a/mm/ksm.c
+++ b/mm/ksm.c
@@ -3186,8 +3186,7 @@ void rmap_walk_ksm(struct folio *folio, struct rmap_walk_control *rwc)
 			anon_vma_lock_read(anon_vma);
 		}
 
-		anon_vma_interval_tree_foreach(vmac, &anon_vma->rb_root,
-					       0, ULONG_MAX) {
+		anon_vma_interval_tree_foreach(vmac, anon_vma, 0, ULONG_MAX) {
 
 			cond_resched();
 			vma = vmac->vma;
@@ -3248,9 +3247,7 @@ void collect_procs_ksm(const struct folio *folio, const struct page *page,
 				task_early_kill(tsk, force_early);
 			if (!t)
 				continue;
-			anon_vma_interval_tree_foreach(vmac, &av->rb_root, 0,
-						       ULONG_MAX)
-			{
+			anon_vma_interval_tree_foreach(vmac, av, 0, ULONG_MAX) {
 				vma = vmac->vma;
 				if (vma->vm_mm == t->mm) {
 					addr = rmap_item->address & PAGE_MASK;
diff --git a/mm/memory-failure.c b/mm/memory-failure.c
index 5b97d26ee9b6..cbdec52b6d23 100644
--- a/mm/memory-failure.c
+++ b/mm/memory-failure.c
@@ -552,8 +552,7 @@ static void collect_procs_anon(const struct folio *folio,
 
 		if (!t)
 			continue;
-		anon_vma_interval_tree_foreach(vmac, &av->rb_root,
-					       pgoff, pgoff) {
+		anon_vma_interval_tree_foreach(vmac, av, pgoff, pgoff) {
 			vma = vmac->vma;
 			if (vma->vm_mm != t->mm)
 				continue;
diff --git a/mm/rmap.c b/mm/rmap.c
index 567e46799c64..183603813255 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -211,7 +211,7 @@ int __anon_vma_prepare(struct vm_area_struct *vma)
 	if (likely(!vma->anon_vma)) {
 		vma->anon_vma = anon_vma;
 		anon_vma_chain_assign(vma, avc, anon_vma);
-		anon_vma_interval_tree_insert(avc, &anon_vma->rb_root);
+		anon_vma_interval_tree_insert(avc, anon_vma);
 		anon_vma->num_active_vmas++;
 		allocated = NULL;
 		avc = NULL;
@@ -354,7 +354,7 @@ int anon_vma_clone(struct vm_area_struct *dst, struct vm_area_struct *src,
 	list_for_each_entry_reverse(avc, &dst->anon_vma_chain, same_vma) {
 		struct anon_vma *anon_vma = avc->anon_vma;
 
-		anon_vma_interval_tree_insert(avc, &anon_vma->rb_root);
+		anon_vma_interval_tree_insert(avc, anon_vma);
 		if (operation == VMA_OP_FORK)
 			maybe_reuse_anon_vma(dst, anon_vma);
 	}
@@ -434,7 +434,7 @@ int anon_vma_fork(struct vm_area_struct *vma, struct vm_area_struct *pvma)
 	anon_vma_chain_assign(vma, avc, anon_vma);
 	/* Now let rmap see it. */
 	anon_vma_lock_write(anon_vma);
-	anon_vma_interval_tree_insert(avc, &anon_vma->rb_root);
+	anon_vma_interval_tree_insert(avc, anon_vma);
 	anon_vma->parent->num_children++;
 	anon_vma_unlock_write(anon_vma);
 
@@ -499,7 +499,7 @@ void unlink_anon_vmas(struct vm_area_struct *vma)
 	list_for_each_entry_safe(avc, next, &vma->anon_vma_chain, same_vma) {
 		struct anon_vma *anon_vma = avc->anon_vma;
 
-		anon_vma_interval_tree_remove(avc, &anon_vma->rb_root);
+		anon_vma_interval_tree_remove(avc, anon_vma);
 
 		/*
 		 * Leave empty anon_vmas on the list - we'll need
@@ -2986,8 +2986,7 @@ static void rmap_walk_anon(struct folio *folio,
 
 	pgoff_start = folio_pgoff(folio);
 	pgoff_end = pgoff_start + folio_nr_pages(folio) - 1;
-	anon_vma_interval_tree_foreach(avc, &anon_vma->rb_root,
-			pgoff_start, pgoff_end) {
+	anon_vma_interval_tree_foreach(avc, anon_vma, pgoff_start, pgoff_end) {
 		struct vm_area_struct *vma = avc->vma;
 		unsigned long address = vma_address(vma, pgoff_start,
 				folio_nr_pages(folio));
diff --git a/mm/vma.c b/mm/vma.c
index 7dc9d087c2c7..2be0dbd7bb7b 100644
--- a/mm/vma.c
+++ b/mm/vma.c
@@ -272,7 +272,7 @@ anon_vma_interval_tree_pre_update_vma(struct vm_area_struct *vma)
 	struct anon_vma_chain *avc;
 
 	list_for_each_entry(avc, &vma->anon_vma_chain, same_vma)
-		anon_vma_interval_tree_remove(avc, &avc->anon_vma->rb_root);
+		anon_vma_interval_tree_remove(avc, avc->anon_vma);
 }
 
 static void
@@ -281,7 +281,7 @@ anon_vma_interval_tree_post_update_vma(struct vm_area_struct *vma)
 	struct anon_vma_chain *avc;
 
 	list_for_each_entry(avc, &vma->anon_vma_chain, same_vma)
-		anon_vma_interval_tree_insert(avc, &avc->anon_vma->rb_root);
+		anon_vma_interval_tree_insert(avc, avc->anon_vma);
 }
 
 /*
diff --git a/tools/testing/vma/include/stubs.h b/tools/testing/vma/include/stubs.h
index 9c151b860f36..51d03e9c23c5 100644
--- a/tools/testing/vma/include/stubs.h
+++ b/tools/testing/vma/include/stubs.h
@@ -272,12 +272,12 @@ static inline void flush_dcache_mmap_unlock(struct address_space *mapping)
 }
 
 static inline void anon_vma_interval_tree_insert(struct anon_vma_chain *avc,
-						 struct rb_root_cached *rb)
+						 struct anon_vma *anon_vma)
 {
 }
 
 static inline void anon_vma_interval_tree_remove(struct anon_vma_chain *avc,
-						 struct rb_root_cached *rb)
+						 struct anon_vma *anon_vma)
 {
 }
 
-- 
2.54.0


