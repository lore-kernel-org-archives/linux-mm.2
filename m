Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D9122606A32E
	for <linux-mm@archiver.kernel.org>; Wed, 25 Nov 2026 22:38:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Hd2Wiu/P
Received: by kanga.kvack.org (Postfix)
	id DF2A86B0B17; Wed, 25 Nov 2026 17:38:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DC9276B0B19; Wed, 25 Nov 2026 17:38:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CB7736B0B1A; Wed, 25 Nov 2026 17:38:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 9B9E66B0B17
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 17:38:34 -0500 (EST)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 29FA11C4A9E
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 22:38:34 +0000 (UTC)
X-FDA: 85475106948.17.CC65CD2
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id 572F3180003
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 22:38:32 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="Hd2Wiu/P";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795646312;
	b=jS0HS5z2kVOkqQ6MOyJhT4MYNYu2NP0nsD6PYb1irvOu2HXU1yeeaXhWZRUWc/gfyYbkp7
	Wo6Go94MS3jZCWHBSEdHHMOOAM1k1LO6uGdhwtdHy7hibe8BlEIEtdz0pMuQFDdW5QcSkM
	6CyU4NqfHXgDztytkfHa4la7VzaMsS0=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795646312;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xAZnRy4ClkSREhxpzPfANj/gGJeGD+jD2/eNSheQ1pc=;
	b=nlRY+bwxcptq2r0O8+j3X7EX6QvkJ0Of6dX/FcztMhXMAG3VAnWhLeTJj81sOzM/NqdzY1
	fY+BiiHYZGU3/3W9ibUsodG0qhWBDhSNdWS68mt8aaWx39PkS+VUuVYVVvBtRnu2vWRhZ2
	8xohrE4QujtLVBw6/4+M7ZU1I8mW5zY=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="Hd2Wiu/P";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 86490456E9;
	Wed, 25 Nov 2026 22:38:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45AC91F000D0;
	Wed, 25 Nov 2026 22:38:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795646311;
	bh=xAZnRy4ClkSREhxpzPfANj/gGJeGD+jD2/eNSheQ1pc=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=Hd2Wiu/P8uIxlKTdjUOUTYFoij2bc4AjUep+hFytgDGFz4JyXIiyXD9VW3wDxpNxS
	 +obf+ckENrzeA9vbQqu2NviMHORKBVMsJ6b8Q2lXjNIu9DbkFlA9HaLBF33edWjPGi
	 hckgy6Xe0kuB9i4sqQELrUCO84TtwrwjvLMXIC7NYlalyxmv5BtReOOsdVrdOqQZql
	 QygU+eT9s2nYmFzzl+CPwZbLPHsC3v/CKciZKSw3Qp67i7cXRgz9+APlIbouBE7DG7
	 baFeo5B21tKkkv0WtMffh4PXCv8ZcbXuV2L21g07upLcGqRlswmAoY8Kkak91j23sE
	 1iMeICdwga3XA==
From: "David Hildenbrand (Arm)" <david@kernel.org>
Date: Wed, 25 Nov 2026 23:33:17 +0100
Subject: [PATCH 19/21] mm/hugetlb: use the VMA lock to stabilize flags for
 PMD sharing
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261125-hugetlb_fixes_2-v1-19-db27fd2f71a8@kernel.org>
References: <20261125-hugetlb_fixes_2-v1-0-db27fd2f71a8@kernel.org>
In-Reply-To: <20261125-hugetlb_fixes_2-v1-0-db27fd2f71a8@kernel.org>
To: Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 Jinmeng Zhou <jinmengzhou22@gmail.com>, Hongfu Li <lihongfu@kylinos.cn>, 
 Andrea Arcangeli <aarcange@redhat.com>, 
 Mike Kravetz <mike.kravetz@oracle.com>, 
 Naoya Horiguchi <nao.horiguchi@gmail.com>, Hugh Dickins <hughd@google.com>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 Dave Airlie <airlied@redhat.com>, 
 Vivek Kasireddy <vivek.kasireddy@intel.com>, 
 Gerd Hoffmann <kraxel@redhat.com>, Mike Rapoport <rppt@kernel.org>, 
 Mel Gorman <mel@csn.ul.ie>, Dave McCracken <dave.mccracken@oracle.com>, 
 Andy Whitcroft <apw@shadowen.org>, Adam Litke <agl@us.ibm.com>, 
 Lorenzo Stoakes <ljs@kernel.org>, Rik van Riel <riel@surriel.com>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Harry Yoo <harry@kernel.org>, Jann Horn <jannh@google.com>, 
 Lance Yang <lance.yang@linux.dev>, James Houghton <jthoughton@google.com>, 
 Yang Shi <shy828301@gmail.com>, Suren Baghdasaryan <surenb@google.com>, 
 Shakeel Butt <shakeel.butt@linux.dev>, Pedro Falcato <pfalcato@suse.de>, 
 Gregory Price <gourry@gourry.net>, Zi Yan <ziy@nvidia.com>, 
 Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>, 
 Ying Huang <ying.huang@linux.alibaba.com>, 
 Matthew Brost <matthew.brost@intel.com>, Byungchul Park <byungchul@sk.com>, 
 Alistair Popple <apopple@nvidia.com>, 
 Wanpeng Li <liwanp@linux.vnet.ibm.com>, Andi Kleen <ak@linux.intel.com>, 
 Kenneth W Chen <kenneth.w.chen@intel.com>, Hugh Dickins <hugh@veritas.com>, 
 Michal Hocko <mhocko@suse.com>, David Rientjes <rientjes@google.com>, 
 Joern Engel <joern@logfs.org>, Jonathan Corbet <corbet@lwn.net>, 
 Shuah Khan <skhan@linuxfoundation.org>, 
 Randy Dunlap <rdunlap@infradead.org>, Michal Hocko <mhocko@suse.cz>, 
 "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>, 
 KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, 
 "Kirill A. Shutemov" <kirill@shutemov.name>, 
 Sasha Levin <sasha.levin@oracle.com>, 
 Guillaume Morin <guillaume@morinfr.org>, Wanpeng Li <liwp.linux@gmail.com>
Cc: linux-mm@kvack.org, Jason Gunthorpe <jgg@ziepe.ca>, 
 linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
 Andrew Morton <akpm@osdl.org>, linux-doc@vger.kernel.org, 
 "David Hildenbrand (Arm)" <david@kernel.org>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=6785; i=david@kernel.org;
 h=from:subject:message-id; bh=PwP2RLUs3pwQwesqKHMjKcPs2SdsbC0XZtUwTfW/jbY=;
 b=owGbwMvMwCF2/OVpCdfQ3ZWMp9WSGLLZk1T/hT3qEOxbNI3jiYVKS0y/7dL2txxznbbt1PirY
 3bgnOPpjlIWBjEOBlkxRZag4PsGL1+uq61242OGmcPKBDKEgYtTACZyypDhr/yPUyqfzity8EUq
 q7U33lSM9a9qFqmQWF985N/8PRa1KowMX9qi9PY7pn01Ouho8OuZ/jUrtS3+ga4X7kamhEuv7Wl
 nAwA=
X-Developer-Key: i=david@kernel.org; a=openpgp;
 fpr=1BD9CAAD735C4C3A460DFCCA4DDE10F700FF835A
X-Rspamd-Queue-Id: 572F3180003
X-Stat-Signature: y4baxnouqj84c74c3icey7cst6izeree
X-Rspam-User:
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam04
X-HE-Tag: 1795646312-22927
X-HE-Meta: U2FsdGVkX18qTfrHpyM7iGGh9Qu6DLIzwQZCp73Eb4epCEzweGOvp++T6IhJRxqYnyqpcCpq6nKQ7iYqhI0NBab9RFowhnUVwp049zlS8L0vSRcIan0HnuSNjN/ttusTgS40nCDKYlMmJKgY7eekYn9AgexysEBE3Ljx1VR9aVVp1X8EsVTXailIqgZw/pjnaB34DTS6FY7ccoN+HFCThem+MTXDevYGt0+jl4EElzBic/8uCVZBsVWzUlFKef0jeedqgWnTh+TtUGSfRRmBWR3k8JMWoMIQySFHw7Kc1ue6zxRym/+MXff4kImfzAKUh9iiGezmOWhKOHm9iTIAoZOUP6nVaDATCIRpVcR80JZygZO0QnXgHzh5uD3L7dK6OS65tbCSS0eCsQRoIkSgWCppOXbzvFLBJt25OZsMfzGVEFv9xRUIa0pJfky+FWGnJfATcztVTFM/r+FcGS7JxzVYi/cJtqwFNVBoYM6njZgMcuZI05dfE1/R75+zyD8u4Ob2MpDLy8wT2YSCDL1Vjkw9rTTAjKscfEcZOjVFHWdf7wlORbDNso86ymwLIokRyeL1NNEPau4RrKU0jteOoE0w3EknizqlhgMQ65TrHj6cZDvkDfy8R+nfCiS0z8Vuyx6NkBm58bkvVO0BWhU4n4w2Vkf0VcNFIGlrVaa2aqAocXylrBcjTA/BD8lniBl1U7R1QpVVFZw8StwYltJfmtpoCAOO2/UlO6laFiwJh6N1xtGE4IsVwhF18sawpxwy8+mlQzLETjI+vbSd7Db9VV8yPkN2HQUzrOxalD/o3rBicQ5eOyXTrUyqRA5mR3rlcFuN731S0B5q3PysvpR/EBouC1PyP28T+5cbrwkTE/waT4R5X1h4YDtl7VkytklogxAUNhcaG0tE81aV8jimw8FkjxqJGwybGfVJHc05pr627fpxZVwrJVafT37MZ//ajF4YAskvhC1ojgcaAaw
 bCpnvvBY
 BiUa+R+UbKBYf4+EjfOcrZ+MH/xJiVIcpQAjzuCxsbdpsKK3OFkMPinVgWy0QupQRIBXWXW+Wm6SQ/5YiIeLRJWAR15vTf3r4QyxTcHNR5EoaVBrDoe+74yIQrc9x7vTeWZVACg1aN1A8C1XGADEVXbD0XifJhdv0WIJJKq3OaoOTqFi54YNGB8hcolzo/RRiWJX7XO7Ea5w8l0954i2BUtG9ykFw5urP38VmLmZKIMGTolo9e2EOH9qb89d3sCA8NiwigQ+mBeahtuiyjRgWdxbGPEX+QqLBW1Hh+5poP2OgnSzwVAdxeFb8PnAqfJ+Y6Do1rRS7w1mhsxqYo88PGR0MJe8bxI0zmredBwSYwk6AOoHVRVKmOM0tgEDbwA5Ye3M1JRzg5YzJbPLq3TCBrR/br0khhJH4z63mP8us8eFhq2VJCulm7iTgkK9/oGsIdLdJZc5ae73wki/SVP2hIRPTEcJYEMAP/HVhl94mxINnpr2gIBPfr4K1FO+UpuEwOrT5CYboxwF+OGiSyl6WGi/KDElnbxvP/KK56Zfc54oaiBw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

huge_pmd_share() currently only shares the page tables of another VMA if
it can read-lock the mmap lock of the corresponding mm. That refuses
sharing whenever that mm is write-locked or if the mmap lock is
contended.

mprotect() holds the VMA write lock while changing the flags and the
page table entries, so let's read-lock only that VMA instead. As we hold
i_mmap_rwsem, that VMA remains part of its mm and cannot go away.

Add vma_trylock_read(), a variant of vma_start_read(), that does not
require being called with the RCU read lock held, and will also not drop
it itself.

Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 include/linux/mmap_lock.h |  1 +
 mm/hugetlb.c              |  4 +--
 mm/mmap_lock.c            | 78 +++++++++++++++++++++++++++++++----------------
 3 files changed, 55 insertions(+), 28 deletions(-)

diff --git a/include/linux/mmap_lock.h b/include/linux/mmap_lock.h
index bada7a03ddf4b..f42444069e76c 100644
--- a/include/linux/mmap_lock.h
+++ b/include/linux/mmap_lock.h
@@ -278,6 +278,7 @@ static inline bool vma_start_read_locked(struct vm_area_struct *vma)
 
 struct vm_area_struct *vma_start_read_unlocked(struct mm_struct *mm,
 					       unsigned long address);
+bool vma_trylock_read(struct vm_area_struct *vma);
 
 static inline void vma_end_read(struct vm_area_struct *vma)
 {
diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 5db97f6d15595..62ed8d9aeeadd 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -7287,7 +7287,7 @@ pte_t *huge_pmd_share(struct mm_struct *mm, struct vm_area_struct *vma,
 		 * Stabilize the svma flags, as mprotect() changes flags
 		 * before adjusting page tables.
 		 */
-		if (!mmap_read_trylock(svma->vm_mm))
+		if (!vma_trylock_read(svma))
 			continue;
 
 		saddr = page_table_shareable(svma, vma, addr, idx);
@@ -7297,7 +7297,7 @@ pte_t *huge_pmd_share(struct mm_struct *mm, struct vm_area_struct *vma,
 			if (spte)
 				ptdesc_pmd_pts_inc(virt_to_ptdesc(spte));
 		}
-		mmap_read_unlock(svma->vm_mm);
+		vma_end_read(svma);
 		if (spte)
 			break;
 	}
diff --git a/mm/mmap_lock.c b/mm/mmap_lock.c
index c7261f980cef1..68c16281e52a5 100644
--- a/mm/mmap_lock.c
+++ b/mm/mmap_lock.c
@@ -212,26 +212,17 @@ static bool vma_seqcount_is_write_locked(unsigned int vma_seq, unsigned int mm_s
 }
 
 /*
- * Try to read-lock a vma. The function is allowed to occasionally yield false
- * locked result to avoid performance overhead, in which case we fall back to
- * using mmap_lock. The function should never yield false unlocked result.
- * False locked result is possible if vma gets reused and attached to a
- * different mm before we lock it.
- * Returns the vma on success, NULL on failure to lock and EAGAIN if vma got
- * detached.
- *
- * IMPORTANT: RCU lock must be held upon entering the function, but upon error
- *            IT IS RELEASED. The caller must handle this correctly.
+ * Like vma_start_read(), but without RCU handling: the caller must make sure
+ * that the vma cannot be freed, for example by holding the RCU lock.
  */
-static struct vm_area_struct *vma_start_read(struct mm_struct *mm,
-					     struct vm_area_struct *vma)
+static struct vm_area_struct *__vma_start_read(struct mm_struct *mm,
+		struct vm_area_struct *vma)
 {
 	unsigned int vma_seq;
 	unsigned int mm_seq;
 	struct mm_struct *other_mm;
 	int oldcnt;
 
-	RCU_LOCKDEP_WARN(!rcu_read_lock_held(), "no rcu lock held");
 	/*
 	 * Check before locking. A race might cause false locked result.
 	 * We can use READ_ONCE() for the mm_lock_seq here, and don't need
@@ -241,10 +232,8 @@ static struct vm_area_struct *vma_start_read(struct mm_struct *mm,
 	 */
 	vma_seq = READ_ONCE(vma->vm_lock_seq);
 	mm_seq = READ_ONCE(mm->mm_lock_seq.sequence);
-	if (vma_seqcount_is_write_locked(vma_seq, mm_seq)) {
-		vma = NULL;
-		goto err;
-	}
+	if (vma_seqcount_is_write_locked(vma_seq, mm_seq))
+		return NULL;
 
 	/*
 	 * If VM_REFCNT_EXCLUDE_READERS_FLAG is set,
@@ -257,8 +246,7 @@ static struct vm_area_struct *vma_start_read(struct mm_struct *mm,
 	if (unlikely(!__refcount_inc_not_zero_limited_acquire(&vma->vm_refcnt, &oldcnt,
 							      VM_REFCNT_LIMIT))) {
 		/* return EAGAIN if vma got detached from under us */
-		vma = oldcnt ? NULL : ERR_PTR(-EAGAIN);
-		goto err;
+		return oldcnt ? NULL : ERR_PTR(-EAGAIN);
 	}
 
 	__vma_lockdep_acquire_read(vma);
@@ -288,14 +276,9 @@ static struct vm_area_struct *vma_start_read(struct mm_struct *mm,
 	mm_seq = raw_read_seqcount(&mm->mm_lock_seq);
 	if (unlikely(vma_seqcount_is_write_locked(vma_seq, mm_seq))) {
 		vma_refcount_put(vma);
-		vma = NULL;
-		goto err;
+		return NULL;
 	}
 
-	return vma;
-err:
-	rcu_read_unlock();
-
 	return vma;
 err_unstable:
 	/*
@@ -309,11 +292,54 @@ static struct vm_area_struct *vma_start_read(struct mm_struct *mm,
 	mmgrab(other_mm);
 	vma_refcount_put(vma);
 	mmdrop_async(other_mm);
-	rcu_read_unlock();
 
 	return NULL;
 }
 
+/**
+ * vma_start_read() - Try to read-lock a vma looked up under RCU.
+ * @mm: The mm the vma is expected to belong to.
+ * @vma: The vma to read-lock.
+ *
+ * The function is allowed to occasionally yield false locked result to avoid
+ * performance overhead, in which case we fall back to using mmap_lock. The
+ * function should never yield false unlocked result. False locked result is
+ * possible if vma gets reused and attached to a different mm before we lock it.
+ *
+ * Context: RCU lock must be held upon entering the function, but upon error
+ * IT IS RELEASED. The caller must handle this correctly.
+ *
+ * Return: The vma on success, NULL on failure to lock and ERR_PTR(-EAGAIN) if
+ * the vma got detached.
+ */
+static struct vm_area_struct *vma_start_read(struct mm_struct *mm,
+		struct vm_area_struct *vma)
+{
+	RCU_LOCKDEP_WARN(!rcu_read_lock_held(), "no rcu lock held");
+
+	vma = __vma_start_read(mm, vma);
+	if (IS_ERR_OR_NULL(vma))
+		rcu_read_unlock();
+	return vma;
+}
+
+/**
+ * vma_trylock_read() - Try to read-lock a VMA that belongs to its mm.
+ * @vma: The VMA to read-lock.
+ *
+ * Unlike vma_start_read(), this function does not deal with VMAs that might
+ * get freed and reused in another mm concurrently.
+ *
+ * Context: The caller must make sure that @vma remains part of @vma->vm_mm
+ * and cannot go away.
+ *
+ * Return: true if @vma is read-locked, false otherwise.
+ */
+bool vma_trylock_read(struct vm_area_struct *vma)
+{
+	return !IS_ERR_OR_NULL(__vma_start_read(vma->vm_mm, vma));
+}
+
 /*
  * Lookup and lock a VMA under RCU protection. Returned VMA is guaranteed to be
  * stable and not isolated. If the VMA is not found or is being modified the

-- 
2.56.1


