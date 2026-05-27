Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BDEA0CD5BD0
	for <linux-mm@archiver.kernel.org>; Wed, 27 May 2026 18:48:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 33BDD6B008A; Wed, 27 May 2026 14:48:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 29E6C6B008C; Wed, 27 May 2026 14:48:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 18CAE6B0092; Wed, 27 May 2026 14:48:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 064DA6B008A
	for <linux-mm@kvack.org>; Wed, 27 May 2026 14:48:04 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id B0787C240B
	for <linux-mm@kvack.org>; Wed, 27 May 2026 18:48:03 +0000 (UTC)
X-FDA: 84814084446.11.A6EF23D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf22.hostedemail.com (Postfix) with ESMTP id 26679C000A
	for <linux-mm@kvack.org>; Wed, 27 May 2026 18:48:01 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=gr2yuIiX;
	spf=pass (imf22.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779907682; a=rsa-sha256;
	cv=none;
	b=mu2wvbXP/oaSAD9uda15161pEPaufFcadztlszATYvHZY6pZNvL6YKcHcg99ft7ycVA+Qe
	OcW/PT5RG5BmDkL6yP6cz+YrGh6vqEtSNQzQikINXyUeXxEuhXKxe7t4CI9dei0e0+v0Dg
	Jb+V4Ynl1inMsOT3YQgaZG38PExQqZM=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=gr2yuIiX;
	spf=pass (imf22.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779907682;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZxtKBAoMGY0dqUDczpf/VIzNJfYrrM3Xd71tALEzopQ=;
	b=DMM0jDtDnIf97Q8TvVG5c6KeMeiAP6qY762bHBrcPATS+sPtwE9g2IPVpo4hmEo6/R8IaX
	h0BS39WoBjr10YfEtpAJLg5MRFrwEDp0LBNSo6VgLF1Vi0uITj3d6hxi56pMWUbKoqj1lM
	0OKTP99jUl5yE3l99ujaBABKfTEi4bg=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id B572760589;
	Wed, 27 May 2026 18:48:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA9111F00A3E;
	Wed, 27 May 2026 18:47:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779907681;
	bh=ZxtKBAoMGY0dqUDczpf/VIzNJfYrrM3Xd71tALEzopQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gr2yuIiX/P/O2PNJpAF1ruWuSkVo/3UsgZmscmZBGHP9V4h9dlm88SAXIjr4OqEWf
	 9aHpzWbyd/zUZWTX7HTgRyjTo50UkURWD1Rs43Lzw1ION1jS+xHLObpkJeRLH0Et5W
	 dTJ2j91wJHMl01exagRu7JO7KMb/uUZZ5nwRQ+5BgXhXZPW15ru544aQ9z2BCGrxY4
	 JOz0AMQt3BeT3nP3b3mZCHVKO3YW5bS+Zub3gPYL++4ZGooRKVrwqXHLEK/ttM+4OS
	 dGEKBOvt4T5PZOqhwxBwITFYFEpRHdtDPIDChp43b/HvMtY9zXYtJTT7PqVKoV63kY
	 EfdmDk2aknCCA==
From: Mike Rapoport <rppt@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Carlier <devnexen@gmail.com>,
	David Hildenbrand <david@kernel.org>,
	Heechan Kang <gganji11@naver.com>,
	"Liam R. Howlett" <liam@infradead.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Michael Bommarito <michael.bommarito@gmail.com>,
	Mike Rapoport <rppt@kernel.org>,
	Peter Xu <peterx@redhat.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 1/3] userfaultfd: verify VMA state across UFFDIO_COPY retry
Date: Wed, 27 May 2026 21:47:49 +0300
Message-ID: <20260527184751.4147364-2-rppt@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260527184751.4147364-1-rppt@kernel.org>
References: <20260527184751.4147364-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 26679C000A
X-Rspamd-Server: rspam03
X-Stat-Signature: pjte1f8pqzjb8mbd319zia9sugzuuwhu
X-HE-Tag: 1779907681-817515
X-HE-Meta: U2FsdGVkX18qeI4LPw0VFLFyFn1o/UpmTbKXRyVfUcrGRDZ5Ps7gGARMopMRoCepfbAONKeK5ka2CCsT3GwL051B1rUJawSrPb410oLcMQu5yiZ9nN/Tk1GGsSiKn7QllIfW18Cr+Me64+s8KvscoS/IzhSjjeO9M6ZNRaE2KmSqvsYKZf9gVB40YKnexfHoeSC4xbyqgL7jzo5a2gaaElMt1v7xnzcgIsNAz3+YGhOuPIfVlmjg20eV0wuHwa1v4q+tNvWhJ1uewkJSxSlsMLDaGEey5pR2x5FKtkK/s/1vlQwXv97n4U8M/bgymueY9wAoyNYpUwRhMZCnPVvmMr568K2PYkmo0veFoRygbSZoivm7o8plZKY0xfxYO3VeiGWIawuGBHbD0vPMXLsT8ZZs9Vz5xEf/IBOjqefLakYf0MIezD1YAeklIj6GCVAvhsolC+nFbdQMMm+Vf54XOQFeVUl0YbqJOwqWKq121BNHPWhEF5d6Euk8DsWLubfw/UjgBczmnUunJL8j8HJeEbExKlTuLkDa5XODoP6GmFG1Z/21QM2EyIFQOiaAUqdPhwC6lcjDphvgHMGB7KaB717d3g2xjscrB2Gk3IMzxSaRZbWX3/n62iZioPPW9tSe5RZ2eeVoL4ozSw9wCwSHfq8Cs8RTPl0vltWuybjQTQw5EUAYZGb4BcZLYlmwCE8Tq4VbtHlc+PA0Z8D03dCczE2jMd9d2TBvm8Pr2zowMX4lhD8YuCwyEF6qfCHNsuHdrpZMxLsH2ivcyY4g96Dpj4ZxcUIHezFXvOjlFBFdVDVphuNaQ9IJrNzRjYsDTdn1xrlgCVIEl3kdMKGkUu9AadQybsgB+MYWtZneGawuwb5Hpd8qIgdzGsPgYVlDHlmfDbXWqc9t8CkzSdEXo1eBCQGo8v/CYUenrFZaf9FoahrbZCKy/BHtuuimohn4nZOOrtbTDssA3Qk77vBqs6g
 BdDT1xzn
 Yupdlf+AoyrsnxeTTc+s1Spq2dt56FjBHUBwqM2EliozyHf9uQlCR4lHCdWgIy4lG799+/nels44mOT52JWmQglIRbMDBBrNAjRmvJdb4t7OEHHDDdi74mt/rzi/xftGQJlspTN/7wSQEElA4FTt81BCvxI8pWBAkK0MPdk7Y4ZCB4Ek8BoVz9j0saBpDoWGktcK7Xr31kxWnGdQ4lOYfoYUKAvViqR334NFcIjrjcwGWED7Ri9aGhxn4249jFhjGzoEGObGP5qD3nBrxoJvdo86V21R1J2N67/gkxFI5WXBW56xuDp2sZ/XMmfV3SDq+xGixwgj9p8t5Hqn6QSEmMq0VNrH24i06wMtich60Idzj1f4sxdYfgyyuKQn3FEwpof4yt9zJr19U0tU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>

mfill_copy_folio_retry() drops the VMA lock for copy_from_user() and
reacquires it afterwards. The destination VMA can be replaced during that
window.

The existing check compares vma_uffd_ops() before and after the retry, but
if a shmem VMA with MAP_SHARED is replaced with a shmem VMA with
MAP_PRIVATE (or vice versa) the replacement goes undetected.

The change from MAP_PRIVATE to MAP_SHARED will treat the folio allocated
with shmem_alloc_folio() as anonymous and this will cause BUG() when
mfill_atomic_install_pte() will try to folio_add_new_anon_rmap().

The change from MAP_SHARED to MAP_PRIVATE allows injection of folios into
the page cache of the original VMA.

There is no need to change for hugetlb because it never uses
mfill_copy_folio_retry().

Introduce helpers for more comprehensive comparison of VMA state:
- mfill_retry_state_save() to save the relevant VMA state into a struct
  mfill_retry_state (original uffd_ops, relevant VMA flags, vm_file and
  pgoff) before dropping the lock
- mfill_retry_state_changed() to compare the saved state with the state
  of the VMA acquired after retaking the locks
- mfill_retry_state_put() to release vm_file pinning.

Use DEFINE_FREE() cleanup to wrap mfill_retry_state_put() to avoid
complicating error handling paths in mfill_copy_folio_retry().

Fixes: 292411fda25b ("mm/userfaultfd: detect VMA type change after copy retry in mfill_copy_folio_retry()")
Fixes: 6ab703034f14 ("userfaultfd: mfill_atomic(): remove retry logic")
Suggested-by: Peter Xu <peterx@redhat.com>
Co-developed-by: David Carlier <devnexen@gmail.com>
Signed-off-by: David Carlier <devnexen@gmail.com>
Co-developed-by: Michael Bommarito <michael.bommarito@gmail.com>
Signed-off-by: Michael Bommarito <michael.bommarito@gmail.com>
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 mm/userfaultfd.c | 85 +++++++++++++++++++++++++++++++++++++++++-------
 1 file changed, 73 insertions(+), 12 deletions(-)

diff --git a/mm/userfaultfd.c b/mm/userfaultfd.c
index 180bad42fc79..e5d2fb3ce2c1 100644
--- a/mm/userfaultfd.c
+++ b/mm/userfaultfd.c
@@ -14,6 +14,8 @@
 #include <linux/userfaultfd_k.h>
 #include <linux/mmu_notifier.h>
 #include <linux/hugetlb.h>
+#include <linux/file.h>
+#include <linux/cleanup.h>
 #include <asm/tlbflush.h>
 #include <asm/tlb.h>
 #include "internal.h"
@@ -443,16 +445,80 @@ static int mfill_copy_folio_locked(struct folio *folio, unsigned long src_addr)
 	return ret;
 }
 
-static int mfill_copy_folio_retry(struct mfill_state *state,
+#define MFILL_RETRY_STATE_VMA_FLAGS \
+	append_vma_flags(__VMA_UFFD_FLAGS, VMA_SHARED_BIT)
+
+/*
+ * VMA state saved before dropping the locks in mfill_copy_folio_retry().
+ * Used to detect VMA replacement or incompatible changes after reacquiring the
+ * locks.
+ */
+struct mfill_retry_state {
+	const struct vm_uffd_ops *ops;
+	struct file *file;
+	vma_flags_t flags;
+	pgoff_t pgoff;
+};
+
+static void mfill_retry_state_save(struct mfill_retry_state *s,
+				   struct vm_area_struct *vma)
+{
+	s->flags = vma_flags_and_mask(&vma->flags, MFILL_RETRY_STATE_VMA_FLAGS);
+	s->ops = vma_uffd_ops(vma);
+	s->pgoff = vma->vm_pgoff;
+
+	if (vma->vm_file)
+		s->file = get_file(vma->vm_file);
+}
+
+static bool mfill_retry_state_changed(struct mfill_retry_state *state,
+				      struct vm_area_struct *vma)
+{
+	vma_flags_t flags = vma_flags_and_mask(&vma->flags,
+					       MFILL_RETRY_STATE_VMA_FLAGS);
+
+	/* Have any UFFD flags (missing, WP, minor) changed? */
+	if (!vma_flags_same_pair(&state->flags, &flags))
+		return true;
+
+	/* VMA type or effective uffd_ops changed while the lock was dropped */
+	if (state->ops != vma_uffd_ops(vma))
+		return true;
+
+	/* VMA was anonymous before; changed only if it no longer is */
+	if (!state->file)
+		return !vma_is_anonymous(vma);
+
+	/* VMA was file backed, but file, inode or offset has changed */
+	if (!vma->vm_file || vma->vm_file->f_inode != state->file->f_inode ||
+	    state->file != vma->vm_file || vma->vm_pgoff != state->pgoff)
+		return true;
+
+	return false;
+}
+
+static void mfill_retry_state_put(struct mfill_retry_state *s)
+{
+	if (s->file)
+		fput(s->file);
+}
+
+DEFINE_FREE(retry_put, struct mfill_retry_state *,
+	    if (_T) mfill_retry_state_put(_T));
+
+static int mfill_copy_folio_retry(struct mfill_state *mfill_state,
 				  struct folio *folio)
 {
-	const struct vm_uffd_ops *orig_ops = vma_uffd_ops(state->vma);
-	unsigned long src_addr = state->src_addr;
+	struct mfill_retry_state retry_state = { 0 };
+	struct mfill_retry_state *for_free __free(retry_put) = &retry_state;
+	unsigned long src_addr = mfill_state->src_addr;
 	void *kaddr;
 	int err;
 
+	mfill_retry_state_save(&retry_state, mfill_state->vma);
+
 	/* retry copying with mm_lock dropped */
-	mfill_put_vma(state);
+	mfill_put_vma(mfill_state);
 
 	kaddr = kmap_local_folio(folio, 0);
 	err = copy_from_user(kaddr, (const void __user *) src_addr, PAGE_SIZE);
@@ -463,19 +529,14 @@ static int mfill_copy_folio_retry(struct mfill_state *state,
 	flush_dcache_folio(folio);
 
 	/* reget VMA and PMD, they could change underneath us */
-	err = mfill_get_vma(state);
+	err = mfill_get_vma(mfill_state);
 	if (err)
 		return err;
 
-	/*
-	 * The VMA type may have changed while the lock was dropped
-	 * (e.g. replaced with a hugetlb mapping), making the caller's
-	 * ops pointer stale.
-	 */
-	if (vma_uffd_ops(state->vma) != orig_ops)
+	if (mfill_retry_state_changed(&retry_state, mfill_state->vma))
 		return -EAGAIN;
 
-	err = mfill_establish_pmd(state);
+	err = mfill_establish_pmd(mfill_state);
 	if (err)
 		return err;
 
-- 
2.53.0


