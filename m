Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 663A8606A31A
	for <linux-mm@archiver.kernel.org>; Sat, 31 Oct 2026 09:42:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=MRMlhKX5
Received: by kanga.kvack.org (Postfix)
	id 6FF076B05BD; Sat, 31 Oct 2026 05:42:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6D4D86B05BE; Sat, 31 Oct 2026 05:42:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5C48B6B05C1; Sat, 31 Oct 2026 05:42:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 27F6A6B05BD
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 05:42:23 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 42AF0A859A
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 09:42:22 +0000 (UTC)
X-FDA: 85382430924.08.1A01AF7
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf07.hostedemail.com (Postfix) with ESMTP id 8B14340006
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 09:42:20 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=MRMlhKX5;
	spf=pass (imf07.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793439740;
	b=r3U5Q8msGSba+QKqZ7cUNwW19quaYCT3+K2T2B86dhL/94PjRqv+on1mfVN11b0GvAwSs6
	+FGjp/W/XNsKcPkg3sUN7wZuowlcWvol7o70YZytqIt07pX7cU1fBq1bDvjjMOMNn5ht4e
	8q1yLGiRN+m2Voisgdq2KTOHEwkuOI4=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=MRMlhKX5;
	spf=pass (imf07.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793439740;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CIQELR659Q9Tf/3uwyZF+FBJ9ojsDWRhmuf6iagVj0E=;
	b=eSGC8kTmxnwPo3j6BinyCHe+XRQ9Curj5/bV5mCiOnkpWkcsEpQD9QO54V+7iN8z0UTz4d
	cbezQ70Q27nRz0sQzj+yCP7bRgXU30EITUiDIjqBzjMOd8dNZMd9LKH6KVKbK2RsPm/PjC
	qWEN9sjISa3AcaKK3SPWjxOHrp0XTPY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 1F2FA600C8;
	Sat, 31 Oct 2026 09:42:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD04B1F00919;
	Sat, 31 Oct 2026 09:42:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793439739;
	bh=CIQELR659Q9Tf/3uwyZF+FBJ9ojsDWRhmuf6iagVj0E=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=MRMlhKX5yYtu9Zu1TIoDkRBx6SKZ77pEsqYPoGWttWMJ789xLuskCTAEOHqJOJjK5
	 RzdNIM06+bIZ8ucQfJiba1rtB+ygtl4RpPvBNUGW8+OqH7db7KnS/Xh+NhRAceixnr
	 Hllht5oMWUQbmnzHBqQOgXVy2DHi7TUe7BPA2VLRKwiTCqR98M6YBJilNAFUhWZ2BR
	 oWA18ApNVRD15Vz4alM9A15A+UxrdFEGnaeEA9nsPJipiLfQ65pUp5sd7MnyR7XMvg
	 I0w9rpePXECj6FXlcAjS5Aayn6NFP8ciD3KQhSySn1eaCEPkz6ykj+FfCNCvMpRlRh
	 kr+/KKjMUexCA==
From: "David Hildenbrand (Arm)" <david@kernel.org>
Date: Sat, 31 Oct 2026 10:39:37 +0100
Subject: [PATCH v3 08/47] mm/filemap: finish fault cleanup before dropping
 the fault lock
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261031-fixes_core-v3-8-d6437171ecc3@kernel.org>
References: <20261031-fixes_core-v3-0-d6437171ecc3@kernel.org>
In-Reply-To: <20261031-fixes_core-v3-0-d6437171ecc3@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>, 
 Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
 Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
 Lorenzo Stoakes <ljs@kernel.org>, Kairui Song <kasong@tencent.com>, 
 Barry Song <baohua@kernel.org>, Axel Rasmussen <axelrasmussen@google.com>, 
 Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
 Baoquan He <baoquan.he@linux.dev>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Kees Cook <kees@kernel.org>, 
 Peter Zijlstra <peterz@infradead.org>, Jann Horn <jannh@google.com>, 
 Pedro Falcato <pfalcato@suse.de>, Hugh Dickins <hughd@google.com>, 
 Pasha Tatashin <pasha.tatashin@soleen.com>, 
 Pratyush Yadav <pratyush@kernel.org>, 
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>, 
 Zi Yan <ziy@nvidia.com>, Lance Yang <lance.yang@linux.dev>, 
 Rik van Riel <riel@surriel.com>, Harry Yoo <harry@kernel.org>, 
 Alistair Popple <apopple@nvidia.com>, Nico Pache <nico.pache@linux.dev>, 
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
 Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>, 
 Matthew Brost <matthew.brost@intel.com>, John Hubbard <jhubbard@nvidia.com>, 
 Peter Xu <peterx@redhat.com>, Will Deacon <will@kernel.org>, 
 "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>, 
 Nick Piggin <npiggin@gmail.com>, Oscar Salvador <osalvador@suse.de>, 
 Minchan Kim <minchan@kernel.org>, Muchun Song <muchun.song@linux.dev>, 
 Xu Xin <xu.xin@linux.dev>, Chengming Zhou <chengming.zhou@linux.dev>, 
 Chris Li <chrisl@kernel.org>, Kemeng Shi <shikemeng@huaweicloud.com>, 
 Nhat Pham <nphamcs@gmail.com>, Youngjun Park <youngjun.park@lge.com>, 
 Gregory Price <gourry@gourry.net>, Joshua Hahn <joshua.hahnjy@gmail.com>, 
 Rakie Kim <rakie.kim@sk.com>, Ying Huang <ying.huang@linux.alibaba.com>, 
 Jason Gunthorpe <jgg@ziepe.ca>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 kexec@lists.infradead.org, linux-fsdevel@vger.kernel.org, 
 linux-arch@vger.kernel.org, linux-cxl@vger.kernel.org, 
 stable@vger.kernel.org, Chris Mason <mason@kernel.org>, 
 Thadeu Lima de Souza Cascardo <cascardo@igalia.com>, 
 Muhammad Usama Anjum <usama.anjum@arm.com>, 
 "David Hildenbrand (Arm)" <david@kernel.org>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=4136; i=david@kernel.org;
 h=from:subject:message-id; bh=jVrwzE4M+fmc5d2w4GN18QrhLHyd8aSra6LYB2SIrA4=;
 b=owGbwMvMwCF2/OVpCdfQ3ZWMp9WSGLKebk+b+6H3hOLR81MWSLv0Hb1lHPeKQ3yn+BWW1bcWx
 SsFrtW+2lHKwiDGwSArpsgSFHzf4OXLdbXVbnzMMHNYmUCGMHBxCsBEHlxjZFhw5bPZdF2D6YK9
 mk13VwVUGl+P4ZQNmdc6o1XNLHgH33JGhpuBCUeajn/PNOkO2lFuk8DzyDPmUE3P9m0XVR+/zPn
 SyAAA
X-Developer-Key: i=david@kernel.org; a=openpgp;
 fpr=1BD9CAAD735C4C3A460DFCCA4DDE10F700FF835A
X-Rspam-User: 
X-Rspamd-Queue-Id: 8B14340006
X-Stat-Signature: icykugug5yu3nce3u5akakfmqyu7q9o8
X-Rspamd-Server: rspam01
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-HE-Tag: 1793439740-320863
X-HE-Meta: U2FsdGVkX19nX8Gjflbgadf0zbXaEGFFAEMlWn5pjp6NFj3sILHoW6yGq1yHRqFcyrkcy6wqEIz6yn3d9bvBvB8+bMIZDfAa1n1PYE625m56ypLEbTcAA74fdWBT8zLmwzG8ZsBP4aw3UWGbkWtMnnBwdNUysTZ/UO9flELvBtt1OGEcIlJP+lODhAqW+Cj3+7/j2VQsbN2bxIaoBq+2mZejm3361b9T5WPdMW4K1PUakebVBuoPUj3liW0N/8sC/c6/FUBrUUjA4fz/KcEogzss6gLuRoGtCY/N8HFTIrrrXvw1YLgc8tpwJ2M/jOj/kaCsSoChEpwgvaZfnM6y6cA6tHFnwLgeVXCjGPP6IjKRigujKSkjopu0xAL0YyO3INznkhA3pq97aj/XiJeoJxNjD24A5cVqObY5t4v/OvAC0fUFNkA09KILcDPrVrGgLHYWYhnSMK6ylCkX/y4Hs9a/kzBeL+s57SzmfDp1H8mgT2K8qcLhXCuqTZ3GY+CmKRLVciNuuJRGXjZkTMfGMgwzDY9vCgSLOc8RSsftCcn8Ze4pFImVX35nXQh7GTIvhFnf5JyeX1kUCPut2zRh+gpEy+w3M7t5jO6ibJbhtodygWifdWSm4sXkuVMW9XImWCnyV5U02wUMwWvOA4z5OEwVyXU4EdHmhV9P4yGVAWiQW162m9uaguPMGkBjmSQHjsO9C0o1tL3tNF8Xgmk38rhxpfl7/sRwWhMd5J0StQCgaUbSGDYP9aEsAX+vpqeGWcYmus/UW045CEDyBhZFmq9n/vT/qgNHNa+rdpTS7UjXEX1eOorG2oNkdvapOCsgca1t68sWacb0gUNOWgXGlhtVORGvQXP1c6cNtkt+qCxIGI4t1XB4GEjSwA92PoN1OBF92eBNEj4ShwuR+W7A4deEXXVpCkctSZELA1YC+amnLivCDLoE5gmwzvXMolos25B+OBeYGgLziKBHP7D
 6XikAJds
 DbYFDwcwHpDMrxjRRF6XM7KrtUhunh9Wc3UekPvRWXAJV6i0em2PMnSZxH7thVm/NWdJA5QxvMRO1Espx0ZTYvKRwk1RK0S6z4mJdKMP+qgVZ0h1PUHOkhpp0mhD67iD0s7bO0m3qt8wxatl654V2PHmT/cdCsO3F/Y3LINlsGN9bwLHaTrkYvOElIy43DWFYX8XkpsZHgrJz7WoFjC38sFkWf9mP/45TcV7GY8Bc2QcOGSyS6jK+kgzVU57HccB0ZE/O9CBNMuBPwy9RP3R0IwggzrJ8TnHzCB7WQG3Di5n7VRRpXtjYe4OfltjZBiDGf+DawKdZxKeXB3FafBSJuh38yvoAlW/fcFZcCG+3YYKEVfme5pTaLS8zjOI6DSLKkAYSuZF4PamYxPHW/iu5CtpqbwMYiHZ+9sMXJU0/gE6W3Q+oEw9NvPcCGA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On a retried fault, a fatal signal interrupting the folio lock wait
makes lock_folio_maybe_drop_mmap() drop the fault lock without pinning
the file. However, filemap_fault() may still need to release
mapping->invalidate_lock. A concurrent munmap() can release the last
file reference and free the mapping before that unlock.

Defer dropping the fault lock to filemap_fault()'s retry cleanup, after
releasing invalidate_lock. If the fault lock was already dropped for
I/O, release the existing file reference instead. Keep the fault lock
held for FAULT_FLAG_RETRY_NOWAIT as before.

Fixes: 730633f0b7f9 ("mm: Protect operations adding pages to page cache with invalidate_lock")
Cc: stable@vger.kernel.org
Reported-by: Chris Mason <mason@kernel.org>
Reviewed-by: Thadeu Lima de Souza Cascardo <cascardo@igalia.com>
Tested-by: Muhammad Usama Anjum <usama.anjum@arm.com>
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 mm/filemap.c | 37 +++++++++++++------------------------
 1 file changed, 13 insertions(+), 24 deletions(-)

diff --git a/mm/filemap.c b/mm/filemap.c
index 6b5e1d866a9e0..b04be64a5069f 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -3308,11 +3308,11 @@ loff_t mapping_seek_hole_data(struct address_space *mapping, loff_t start,
  * @folio - the folio to lock.
  * @fpin - the pointer to the file we may pin (or is already pinned).
  *
- * This works similar to lock_folio_or_retry in that it can drop the
- * mmap_lock.  It differs in that it actually returns the folio locked
- * if it returns 1 and 0 if it couldn't lock the folio.  If we did have
- * to drop the mmap_lock then fpin will point to the pinned file and
- * needs to be fput()'ed at a later point.
+ * Returns 1 with the folio locked, or 0 if locking failed.
+ *
+ * On both entry and return, a non-NULL *fpin means the fault lock has
+ * already been dropped and the caller must eventually fput() the file.
+ * Otherwise the fault lock is still held, including on failure.
  */
 static int lock_folio_maybe_drop_mmap(struct vm_fault *vmf, struct folio *folio,
 				     struct file **fpin)
@@ -3329,21 +3329,9 @@ static int lock_folio_maybe_drop_mmap(struct vm_fault *vmf, struct folio *folio,
 		return 0;
 
 	*fpin = maybe_unlock_mmap_for_io(vmf, *fpin);
-	if (vmf->flags & FAULT_FLAG_KILLABLE) {
-		if (__folio_lock_killable(folio)) {
-			/*
-			 * We didn't have the right flags to drop the
-			 * fault lock, but all fault_handlers only check
-			 * for fatal signals if we return VM_FAULT_RETRY,
-			 * so we need to drop the fault lock here and
-			 * return 0 if we don't have a fpin.
-			 */
-			if (*fpin == NULL)
-				release_fault_lock(vmf);
-			return 0;
-		}
-	} else
-		__folio_lock(folio);
+	if (vmf->flags & FAULT_FLAG_KILLABLE)
+		return !__folio_lock_killable(folio);
+	__folio_lock(folio);
 
 	return 1;
 }
@@ -3572,7 +3560,7 @@ static vm_fault_t filemap_fault_recheck_pte_none(struct vm_fault *vmf)
  * vma->vm_mm->mmap_lock must be held on entry.
  *
  * If our return value has VM_FAULT_RETRY set, it's because the mmap_lock
- * may be dropped before doing I/O or by lock_folio_maybe_drop_mmap().
+ * may be dropped before doing I/O or when aborting an interrupted wait.
  *
  * If our return value does not have VM_FAULT_RETRY set, the mmap_lock
  * has not been released.
@@ -3728,9 +3716,8 @@ vm_fault_t filemap_fault(struct vm_fault *vmf)
 
 out_retry:
 	/*
-	 * We dropped the mmap_lock, we need to return to the fault handler to
-	 * re-find the vma and come back and find our hopefully still populated
-	 * page.
+	 * With fpin set, the fault lock was already dropped. Otherwise it is
+	 * still held. Release invalidate_lock before dropping either protection.
 	 */
 	if (!IS_ERR(folio))
 		folio_put(folio);
@@ -3738,6 +3725,8 @@ vm_fault_t filemap_fault(struct vm_fault *vmf)
 		filemap_invalidate_unlock_shared(mapping);
 	if (fpin)
 		fput(fpin);
+	else if (!(vmf->flags & FAULT_FLAG_RETRY_NOWAIT))
+		release_fault_lock(vmf);
 	return ret | VM_FAULT_RETRY;
 }
 EXPORT_SYMBOL(filemap_fault);

-- 
2.43.0


