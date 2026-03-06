Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 97985FCC048
	for <linux-mm@archiver.kernel.org>; Fri,  6 Mar 2026 17:19:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E73166B009E; Fri,  6 Mar 2026 12:18:59 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E54826B009F; Fri,  6 Mar 2026 12:18:59 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D74136B00A0; Fri,  6 Mar 2026 12:18:59 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id C905C6B009E
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 12:18:59 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 9624CC236E
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 17:18:59 +0000 (UTC)
X-FDA: 84516298398.03.6AF9B5B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf07.hostedemail.com (Postfix) with ESMTP id 148B540006
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 17:18:57 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="L9/3UiF0";
	spf=pass (imf07.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772817538;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ypXOy/46SJyEO8/XuqFJ1+QX6XByCxN8UdseGl4Tyhs=;
	b=KJxshjdeXXz8BTG6D4UJZcR/i4KpxKwFpHWtG4siK1RCy0Sf1SMyQjBMl2Z/mcd0HYuF80
	BZAmkAD5KDNQY7NrA40g3hIpIDAf+n6BLJb4kHzfB0TYZN2XxMGZMKb8If4Y7I6FHkMeUW
	N20tSHtr/VRvH0IGXBwshqa47VoL3Mw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772817538; a=rsa-sha256;
	cv=none;
	b=trfUxK5A+qcvGWCayGXBBzEQzZ+arbCyyTRHuaXg7d4okH7Aly8D7dzjbj0aJBuHfcLK5K
	XMUfvj7wLitpfyPbltU+sJCbxXF+3ivD2/2ElyqvLrqTdGdceU9+m9p/OOme8uHaW1gAo1
	81ugEjdvkVZane1S3o9tsviHcjZTTYk=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="L9/3UiF0";
	spf=pass (imf07.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 8F35A60018;
	Fri,  6 Mar 2026 17:18:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E93AC2BCB5;
	Fri,  6 Mar 2026 17:18:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772817537;
	bh=uK6YVn1uE8/KerH/03wILxjQbYg54EfQnPDfF+duTRs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=L9/3UiF0bLNrJW644W0ccpADpS02wFJO0vTsEAx70zQnWCc+CmzLC0z5GNaljf838
	 9kmqMyDToEUngqQ0VlIu9ohLy+iRzBw5PM10ms0ZQHGffSwdW7ZtQLvPOEb/LG72K5
	 Tyf2dRIFqQqYxpoPFkaaSXkl1Y3ixUfXKoG2LPnxrMu1X3zUB9mdO75veRF4I0Nxam
	 i3rxEdp3qAx0Y5UmJj9Yx209e0qhdG6Ui7U2tA1sWXPKk8npq4f9C/K9lIebErZiRW
	 mGCHmipp5578CvkR5Qrznyly///YQ/XqjCCFnDB4oUAP9zMjtseOfZO+kh8Dpt3KvP
	 bjE4FGXWmF+vw==
From: Mike Rapoport <rppt@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Andrea Arcangeli <aarcange@redhat.com>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	David Hildenbrand <david@kernel.org>,
	Hugh Dickins <hughd@google.com>,
	James Houghton <jthoughton@google.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
	Nikita Kalyazin <kalyazin@amazon.com>,
	Oscar Salvador <osalvador@suse.de>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Peter Xu <peterx@redhat.com>,
	Sean Christopherson <seanjc@google.com>,
	Shuah Khan <shuah@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	kvm@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH v2 05/15] userfaultfd: retry copying with locks dropped in mfill_atomic_pte_copy()
Date: Fri,  6 Mar 2026 19:18:05 +0200
Message-ID: <20260306171815.3160826-6-rppt@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260306171815.3160826-1-rppt@kernel.org>
References: <20260306171815.3160826-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 148B540006
X-Stat-Signature: iyji7yt1r9e4heggkwzjxr3sbkujrkru
X-HE-Tag: 1772817537-931090
X-HE-Meta: U2FsdGVkX19oIlx6rasJlLGj8GNjZE54vnc4ERwgWJiEwf8usp1tHi7OvBO8N7uge+PZhtkAL1fNIKeDM5bVB2Orgh9KVMH08da0BIlgcBJkpOYl7VTX8oddlZbP9/PcnxCUYaDb8EZCnxb9ZD+i4vZoYZb0srNb390vRqKbWIYd/+FjL2FJS/xuapaZst8qhV70RGauUHZ1nto9y2ax+Mner8IzY+ixcugXRvkA2iHch+PneRmeuumJGdPASd8HfCzoDXOc6BRLo7bgwT+OOLz6AxrQ1cTv0TGgHPykuTz8s+iVDrvV4FXtGeBUSa4vxWJw2o1KlrhMxwXutASKRoipvSHT3gLq+x01D6OcFMVOaz2iypUlp3bNu8G/Nzb+x8aB+C3Q6RG9avL0vigPudYJVWVKWvKjmHhsDCTP9y5ZT5ZBsowzkytblkoWagCSLRqEqEGtlmkV9x1ia6MEjcG487LjwwZXKmSmDobgv6lUqWmxQN9KUL4FtP1h28kJzdIY8TKiLRb1QKqUElP6Sq77lR5OVggMbf2Ib7ezG5wcj+36Ee3c5oDwm+kKnutSDT6jdQ+eGlSRr32+y/cPRIUnlnawS0YHays+/nK3vD5Zsa9eAXpFhjVEC/jG0UzN7Mpk/0NNiSIdIkAOBKrrg0lEZ82IJM2NWC1udAxa/tOm7FKCQ60oUSNUVsLg5UWnWXgWhhNi26s8ST53e1InKLsB1Q7cxY717TN3extpGtMXprBqI+/kUUXhjdovQdqH+iOQi7vne1v1veNTZPumRtLeur9oWhhbEqzMLdaEP4iRXC3DRtVqxnroWquhzAgvpjPaudLWF1fv3by5iGCleb45MUjYKpENMRwaDIO0QDvH9EdiTJwgIm3SWFpHlAflp/p++pfeHFx07bMCoZkjml0dp64DohXmBh5m052HChbRPfioHKbK2qVwRecq51P82tXsh3c2x/pzeHcJa3l
 kAvcbUpb
 tuWmnGffj6MmOPC9goW6WmdiAcSwD8CAVFcLwV9FUUwwQot6iW2SUZ9obM+w2MgL4idotx5xctPwhtKw473aXz1oC+/SqbBkfoepKYjaa4qzCtV1skHpR86/JgWVBO8pHhU0rLngSBFOsDO0dv/sjscnjnS/DbXt7EMLHL0SXfZtIdxpLbG9BLeHzRYnuLog0+2ALib52B/yg8otGPy8wBydhi1ZYHkeQaMFY/yqc4IwvdC07KRjlBa1uGelEKKLRp+oBHrjuz48eTaEty7C2iAjPPQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>

Implementation of UFFDIO_COPY for anonymous memory might fail to copy
data from userspace buffer when the destination VMA is locked (either
with mm_lock or with per-VMA lock).

In that case, mfill_atomic() releases the locks, retries copying the
data with locks dropped and then re-locks the destination VMA and
re-establishes PMD.

Since this retry-reget dance is only relevant for UFFDIO_COPY and it
never happens for other UFFDIO_ operations, make it a part of
mfill_atomic_pte_copy() that actually implements UFFDIO_COPY for
anonymous memory.

As a temporal safety measure to avoid breaking biscection
mfill_atomic_pte_copy() makes sure to never return -ENOENT so that the
loop in mfill_atomic() won't retry copiyng outside of mmap_lock. This is
removed later when shmem implementation will be updated later and the
loop in mfill_atomic() will be adjusted.

Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 mm/userfaultfd.c | 78 +++++++++++++++++++++++++++++++++---------------
 1 file changed, 54 insertions(+), 24 deletions(-)

diff --git a/mm/userfaultfd.c b/mm/userfaultfd.c
index baff11e83101..828f252c720c 100644
--- a/mm/userfaultfd.c
+++ b/mm/userfaultfd.c
@@ -159,6 +159,9 @@ static void uffd_mfill_unlock(struct vm_area_struct *vma)
 
 static void mfill_put_vma(struct mfill_state *state)
 {
+	if (!state->vma)
+		return;
+
 	up_read(&state->ctx->map_changing_lock);
 	uffd_mfill_unlock(state->vma);
 	state->vma = NULL;
@@ -404,35 +407,63 @@ static int mfill_copy_folio_locked(struct folio *folio, unsigned long src_addr)
 	return ret;
 }
 
+static int mfill_copy_folio_retry(struct mfill_state *state, struct folio *folio)
+{
+	unsigned long src_addr = state->src_addr;
+	void *kaddr;
+	int err;
+
+	/* retry copying with mm_lock dropped */
+	mfill_put_vma(state);
+
+	kaddr = kmap_local_folio(folio, 0);
+	err = copy_from_user(kaddr, (const void __user *) src_addr, PAGE_SIZE);
+	kunmap_local(kaddr);
+	if (unlikely(err))
+		return -EFAULT;
+
+	flush_dcache_folio(folio);
+
+	/* reget VMA and PMD, they could change underneath us */
+	err = mfill_get_vma(state);
+	if (err)
+		return err;
+
+	err = mfill_get_pmd(state);
+	if (err)
+		return err;
+
+	return 0;
+}
+
 static int mfill_atomic_pte_copy(struct mfill_state *state)
 {
-	struct vm_area_struct *dst_vma = state->vma;
 	unsigned long dst_addr = state->dst_addr;
 	unsigned long src_addr = state->src_addr;
 	uffd_flags_t flags = state->flags;
-	pmd_t *dst_pmd = state->pmd;
 	struct folio *folio;
 	int ret;
 
-	if (!state->folio) {
-		ret = -ENOMEM;
-		folio = vma_alloc_folio(GFP_HIGHUSER_MOVABLE, 0, dst_vma,
-					dst_addr);
-		if (!folio)
-			goto out;
+	folio = vma_alloc_folio(GFP_HIGHUSER_MOVABLE, 0, state->vma, dst_addr);
+	if (!folio)
+		return -ENOMEM;
 
-		ret = mfill_copy_folio_locked(folio, src_addr);
+	ret = -ENOMEM;
+	if (mem_cgroup_charge(folio, state->vma->vm_mm, GFP_KERNEL))
+		goto out_release;
 
-		/* fallback to copy_from_user outside mmap_lock */
-		if (unlikely(ret)) {
-			ret = -ENOENT;
-			state->folio = folio;
-			/* don't free the page */
-			goto out;
-		}
-	} else {
-		folio = state->folio;
-		state->folio = NULL;
+	ret = mfill_copy_folio_locked(folio, src_addr);
+	if (unlikely(ret)) {
+		/*
+		 * Fallback to copy_from_user outside mmap_lock.
+		 * If retry is successful, mfill_copy_folio_locked() returns
+		 * with locks retaken by mfill_get_vma().
+		 * If there was an error, we must mfill_put_vma() anyway and it
+		 * will take care of unlocking if needed.
+		 */
+		ret = mfill_copy_folio_retry(state, folio);
+		if (ret)
+			goto out_release;
 	}
 
 	/*
@@ -442,17 +473,16 @@ static int mfill_atomic_pte_copy(struct mfill_state *state)
 	 */
 	__folio_mark_uptodate(folio);
 
-	ret = -ENOMEM;
-	if (mem_cgroup_charge(folio, dst_vma->vm_mm, GFP_KERNEL))
-		goto out_release;
-
-	ret = mfill_atomic_install_pte(dst_pmd, dst_vma, dst_addr,
+	ret = mfill_atomic_install_pte(state->pmd, state->vma, dst_addr,
 				       &folio->page, true, flags);
 	if (ret)
 		goto out_release;
 out:
 	return ret;
 out_release:
+	/* Don't return -ENOENT so that our caller won't retry */
+	if (ret == -ENOENT)
+		ret = -EFAULT;
 	folio_put(folio);
 	goto out;
 }
-- 
2.51.0


