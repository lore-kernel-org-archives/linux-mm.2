Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 93A83C5AD7B
	for <linux-mm@archiver.kernel.org>; Mon, 10 Aug 2026 16:28:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5F6CD6B009B; Mon, 10 Aug 2026 12:28:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5CE546B009D; Mon, 10 Aug 2026 12:28:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 50B986B009E; Mon, 10 Aug 2026 12:28:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 29C786B009B
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 12:28:01 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 9BFFF120203
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 16:28:00 +0000 (UTC)
X-FDA: 85085891520.08.86D55B9
Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	by imf11.hostedemail.com (Postfix) with ESMTP id B1E6C40008
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 16:27:58 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=AB6MGyo3;
	spf=pass (imf11.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org;
	dmarc=pass (policy=none) header.from=debian.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786379278;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OSmw4/JATZovKQ82nG8xj7k3y5w0Jj+3EtzqrkfFalA=;
	b=YXHuZKfwD7pZww4/GngrMs6xv/ZYjp+jb8SYZ4c3YQBxCXJgtpz4YIilbtCcK9ZB/hPv/e
	RAavZJVY7gVrg2EtoN4qkZJ5J9re9JBThc6v1E5sdlAq9LEMJowU/CHSzG6OrY/lEy2j84
	38mJYF+d1TnUEwemoXiZQFlqjvTrQTY=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786379278;
	b=ki4brAu376NWOvWiHCZA/dLNzJjG2uR4hPMIp/xX+rDm8SFCvTQgrx6pwkyB39kBpxJ/hz
	Z2v2hJhM/JXoe08p3F9jY72dfHDLXPLuw99AXWRSeBQ8iBjZFr6XJlGqbj7/3ml46IosTR
	2kai0AxD+f7xkaLiYZV/rWCg8dKgT9M=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=AB6MGyo3;
	spf=pass (imf11.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org;
	dmarc=pass (policy=none) header.from=debian.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:Cc:To:In-Reply-To:References:
	Message-Id:Content-Transfer-Encoding:Content-Type:MIME-Version:Subject:Date:
	From:Reply-To:Content-ID:Content-Description;
	bh=OSmw4/JATZovKQ82nG8xj7k3y5w0Jj+3EtzqrkfFalA=; b=AB6MGyo3gw+2RDp5miWNY20TK6
	pJAKLOjit0gHXPP9YB2LYkP4Yyd1Fd+gDj4OdnSs7dwu8joPMpKM2R7cecwRtp/ROdOyx3J1qzUle
	z0VFdpXoZ8aY3adq30wDtDWDPdwcLGnOYG7CJIHp1eLrmmnNF/E7oexhzC2fRBFsN+eyfeYfFD2TA
	JmHdNnTvAPa5QuUvXzgNqs4E71UF4Jey+NvsfxOKmMAgR0/b5aHSW3K/E9iODpOPhFkiy6k8XbJo/
	WgXd+DhbNFcgp0oZwQlaf2oIXJo0d48RyYL9ECLUw8KRbEEe/uORMAqSmFjF+zqwjxFOxiJG2UdmG
	NYStYK1A==;
Received: from authenticated-user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1wtSqv-002ufJ-0j;
	Mon, 10 Aug 2026 16:27:54 +0000
From: Breno Leitao <leitao@debian.org>
Date: Mon, 10 Aug 2026 09:26:50 -0700
Subject: [PATCH 2/3] mm, swap: distinguish a malformed swap entry from a
 dying device
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260810-swap-v1-2-375ef0767206@debian.org>
References: <20260810-swap-v1-0-375ef0767206@debian.org>
In-Reply-To: <20260810-swap-v1-0-375ef0767206@debian.org>
To: Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>, 
 Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
 Nhat Pham <nphamcs@gmail.com>, Baoquan He <baoquan.he@linux.dev>, 
 Barry Song <baohua@kernel.org>, Youngjun Park <youngjun.park@lge.com>, 
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Jann Horn <jannh@google.com>, 
 Pedro Falcato <pfalcato@suse.de>, Hugh Dickins <hughd@google.com>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, Peter Xu <peterx@redhat.com>, 
 Johannes Weiner <hannes@cmpxchg.org>, Yosry Ahmed <yosry@kernel.org>, 
 Chengming Zhou <chengming.zhou@linux.dev>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, kernel-team@meta.com, 
 Breno Leitao <leitao@debian.org>
X-Mailer: b4 0.16-dev-f8e9d
X-Developer-Signature: v=1; a=openpgp-sha256; l=5482; i=leitao@debian.org;
 h=from:subject:message-id; bh=MqqCc24oSI55SE/DlZ1XKDzsXt4cdmCRfefdgxzpBK0=;
 b=owEBbQKS/ZANAwAIATWjk5/8eHdtAcsmYgBqefvp5TjJccBIh+J0r6eZ4piAUO/GtD+HNrZmI
 4QZrutDYe+JAjMEAAEIAB0WIQSshTmm6PRnAspKQ5s1o5Of/Hh3bQUCann76QAKCRA1o5Of/Hh3
 bb2VD/9Vxf3WlBBc2dcGI4uVUmsmR7oy86IfaeOP4RDEzioh21udsESJl837Ovv5AO0oPcp7xF4
 AAW6ZgWuN+avbIsYeuFdvqsRnTusqWbNVqKb44YKTv8VWAxbL6Qfu0DRKUB4HHGvm6y/qYlVKAQ
 xirzjsPSgLnbgz59SVclw+kDPssDXX+ut5/S8VQWgNb5Jvvc6V4jepCcRBq4dPrkP23Lbf9WOI/
 RbXTt0VtoYM0MmprrESBwNXumNFBvcQj+YmvdEG55hZWwwjv63qV+q5RkWK0PlD5sB3hcQH4shS
 /9SoPlqn7Q5boo0JBOtdPkahbJdeKrP+mkwwGFdViT7Gb+F4pez1wv/52qoGrE0wxxlgfYV2NaS
 +3NES/FWfzgE0KT+M8G8FRBloANBMM8/hSAXWq7i4n5pD3R5QrxasSUvzh7ymSJ9GyxN0Wf4Fr7
 PdR/u3eMWkB9q3XO0Caq/S2mv96+fgZF5rVM7h/A36QlYZW8PnR71n5nDYiOuEFQjsXglJmSke5
 neqf3Atzo+YwAIn32kd3d1ZNhxTuWfvOWPAk/qoInl24R/Vt6vtyQfj0oBP7oDf5WSXOMBKRGMq
 OilHxNFDDESrauSetRj+/t+iJB99ZOqZ9tG5KbvGvV6I4rQYzbJ7huLa8xjUiVHQCgL2ASvxDOa
 uaQhHQYgEW4cYYw==
X-Developer-Key: i=leitao@debian.org; a=openpgp;
 fpr=AC8539A6E8F46702CA4A439B35A3939FFC78776D
X-Debian-User: leitao
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-Stat-Signature: myagah9ahr65hjuid4xs3k1bhobbiby6
X-Rspamd-Queue-Id: B1E6C40008
X-HE-Tag: 1786379278-474575
X-HE-Meta: U2FsdGVkX1+lE2bkQGE5SUXkY+vbMKS/wcwwgW0vanmG2iDhRTBWoQUksH9H+qwe2RmZ3aj5DAVyFDg8P84Fk5jmqBAhzkWmKbVqy8V8NKedMM0SiQDUQ7ybWD8Vz14AuchyCk00A7KOpJhbGjR74h6OD+qPeLWwIJXsMFKwWZlFaKvMS8Le9nVQO0jbk31MeNrXO/B4E3iKZmc84v4Kid9OfAVmHrDI2T/tlRV6l2Xtv1fhAdu8KjsFoQlA62YZUf0SYyPsFd/65CafQmkCUYjaYV+kyiGPV8c6UEyUmXvGZF4s/CIg9kkcAOiKnDmHjGqEc2HNuiQ/fnodN/I0jjdnbyGh2DwUjK/jbNuSc6FyXF9wntv+kTSigi6l3QEgEf+wgRJ/zJ5Tdlnjum3F6H25zLSNGLVoWu9wrZ4YOOUS5M4ztcm0dq91ohwdoZei1Bpz25M1SGTnYMe5c3YR+GdbsbbqudHpUYO//Hb0vex7MD1HjmpKqaSNlv3K4uvS60OdfZp9LktqjYDO5OYH91A9dqZVCLQxgfbvnEQCu27Lr4d+hFfrmerHQrxlLc1Qqt9GNcGQkbFcaEQ3xk1k57OwpMpPJMvorBgBAupwDNeNN/AM2C3RFLUJLO1nHDKRLtD+skTNrJjSX4icfcfyp5bsu20Q7MYsTm4HCnLllnRpXEXIVEVz4LfOrwRBeIQibBrEVPo80I6ErwqcLcae6pzLExtnDJtdKow2Xj1AJj5RDv4+8wdhzEcFtmfKCVZ69w9EG4mRLFFoeXz6UYWM8B6AnSFrSZaH3TNQ/OqCGFlZW3miLM7m3OpLOofv7HiikZHDKQqlWpzTNl9JFQ2y6hXyB7Gaj6oI5vCj89mcRy9VREjq4EMzNDf+NANo0SeaWCJQiGrGmrlT8Bap6F3+fINtEJB7iBNJd/JVCdfXMaCtr1xJGHKoFdvxY2L1+3cHecGW8uT/5rQCrLkFo7p
 PqzjoH8t
 C/u+/OvK/OacGPXKx7AyUCJypAAma0v2MIuJXeUZWD8uYw6tGjX6g4SUxxaT7HOEOaWC3a6algCzRCTzEfkwgYHqwurydh8isZROXdnFduaiSbNT5rypTPTfMsh9M7nnLm13biBy8OUCdS+2EbpgEZorQpjRrn6fpeC65hoiQgnDGxslwv85pCXTUP1wF9zNwdRrsTgobPbGSlpW6DwjJMYRvabwlqlD1Ro/HQMYg5gqkTofO8j+3PMzJ9OR2ih6BqWDk9ZnvkMeeJawE3/Yjk3o2Bs8QzocC/jc3
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

get_swap_device() returns NULL both for an entry that can never name a
slot on any device and for a device that swapoff is taking away. The
first never becomes valid, the second does, and callers cannot tell
them apart.

Return ERR_PTR(-EINVAL) for the two malformed cases and keep NULL for
swapoff. Callers bail out on failure either way, so switch them to
IS_ERR_OR_NULL() and clear si where the cleanup path would otherwise
put an ERR_PTR. No functional change.

Signed-off-by: Breno Leitao <leitao@debian.org>
---
 mm/memory.c      |  4 +++-
 mm/mincore.c     |  2 +-
 mm/shmem.c       |  2 +-
 mm/swap_state.c  |  4 ++--
 mm/swapfile.c    | 13 ++++++++-----
 mm/userfaultfd.c |  3 ++-
 mm/zswap.c       |  2 +-
 7 files changed, 18 insertions(+), 12 deletions(-)

diff --git a/mm/memory.c b/mm/memory.c
index d9cf941967cf0..4238778b66c42 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -4956,8 +4956,10 @@ vm_fault_t do_swap_page(struct vm_fault *vmf)
 
 	/* Prevent swapoff from happening to us. */
 	si = get_swap_device(entry);
-	if (unlikely(!si))
+	if (IS_ERR_OR_NULL(si)) {
+		si = NULL;
 		goto out;
+	}
 
 	folio = swap_cache_get_folio(entry);
 	if (folio)
diff --git a/mm/mincore.c b/mm/mincore.c
index ff4ac82817683..c086836bc4bcc 100644
--- a/mm/mincore.c
+++ b/mm/mincore.c
@@ -71,7 +71,7 @@ static unsigned char mincore_swap(swp_entry_t entry, bool shmem)
 	 */
 	if (shmem) {
 		si = get_swap_device(entry);
-		if (!si)
+		if (IS_ERR_OR_NULL(si))
 			return 0;
 	}
 	folio = swap_cache_get_folio(entry);
diff --git a/mm/shmem.c b/mm/shmem.c
index 65572cbf1bd3c..d0a9f52bfed71 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -2276,7 +2276,7 @@ static int shmem_swapin_folio(struct inode *inode, pgoff_t index,
 
 	si = get_swap_device(index_entry);
 	order = shmem_confirm_swap(mapping, index, index_entry);
-	if (unlikely(!si)) {
+	if (IS_ERR_OR_NULL(si)) {
 		if (order < 0)
 			return -EEXIST;
 		else
diff --git a/mm/swap_state.c b/mm/swap_state.c
index 4b7a3303c463b..f2e86d6626ecc 100644
--- a/mm/swap_state.c
+++ b/mm/swap_state.c
@@ -715,7 +715,7 @@ struct folio *read_swap_cache_async(struct swap_io_ctx *ctx, swp_entry_t entry,
 	struct folio *folio;
 
 	si = get_swap_device(entry);
-	if (!si)
+	if (IS_ERR_OR_NULL(si))
 		return NULL;
 
 	mpol = get_vma_policy(vma, addr, 0, &ilx);
@@ -951,7 +951,7 @@ static struct folio *swap_vma_readahead(swp_entry_t targ_entry, gfp_t gfp_mask,
 		 */
 		if (swp_type(entry) != swp_type(targ_entry)) {
 			si = get_swap_device(entry);
-			if (!si)
+			if (IS_ERR_OR_NULL(si))
 				continue;
 		}
 		folio = swap_cache_read_folio(&ctx, entry, gfp_mask, mpol, ilx,
diff --git a/mm/swapfile.c b/mm/swapfile.c
index 9ab11dc24e4f1..29612a0cf7afa 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -1504,7 +1504,7 @@ int swap_retry_table_alloc(swp_entry_t entry, gfp_t gfp)
 	unsigned long offset = swp_offset(entry);
 
 	si = get_swap_device(entry);
-	if (!si)
+	if (IS_ERR_OR_NULL(si))
 		return 0;
 
 	ci = __swap_offset_to_cluster(si, offset);
@@ -1859,7 +1859,9 @@ void folio_put_swap(struct folio *folio, struct page *page)
  * Check whether swap entry is valid in the swap device.  If so,
  * return pointer to swap_info_struct, and keep the swap entry valid
  * via preventing the swap device from being swapoff, until
- * put_swap_device() is called.  Otherwise return NULL.
+ * put_swap_device() is called.  Return NULL for an empty entry or a
+ * device that is going away, and ERR_PTR(-EINVAL) if the entry itself
+ * is malformed and can never name a slot on any device.
  *
  * Notice that swapoff or swapoff+swapon can still happen before the
  * percpu_ref_tryget_live() in get_swap_device() or after the
@@ -1900,12 +1902,13 @@ struct swap_info_struct *get_swap_device(swp_entry_t entry)
 	return si;
 bad_nofile:
 	pr_err_ratelimited("%s: %s%08lx\n", __func__, Bad_file, entry.val);
+	return ERR_PTR(-EINVAL);
 out:
 	return NULL;
 put_out:
 	pr_err_ratelimited("%s: %s%08lx\n", __func__, Bad_offset, entry.val);
 	percpu_ref_put(&si->users);
-	return NULL;
+	return ERR_PTR(-EINVAL);
 }
 
 /*
@@ -2001,7 +2004,7 @@ int swp_swapcount(swp_entry_t entry)
 	int count;
 
 	si = get_swap_device(entry);
-	if (!si)
+	if (IS_ERR_OR_NULL(si))
 		return 0;
 
 	ci = swap_cluster_lock(si, swp_offset(entry));
@@ -2127,7 +2130,7 @@ void swap_put_entries_direct(swp_entry_t entry, int nr)
 	struct swap_info_struct *si;
 
 	si = get_swap_device(entry);
-	if (WARN_ON_ONCE(!si))
+	if (WARN_ON_ONCE(IS_ERR_OR_NULL(si)))
 		return;
 	if (WARN_ON_ONCE(end_offset > si->max))
 		goto out;
diff --git a/mm/userfaultfd.c b/mm/userfaultfd.c
index 24a4d92ffa3c2..bf7bc7fb1aa0f 100644
--- a/mm/userfaultfd.c
+++ b/mm/userfaultfd.c
@@ -1700,7 +1700,8 @@ static long move_pages_ptes(struct mm_struct *mm, pmd_t *dst_pmd, pmd_t *src_pmd
 		}
 
 		si = get_swap_device(entry);
-		if (unlikely(!si)) {
+		if (IS_ERR_OR_NULL(si)) {
+			si = NULL;
 			ret = -EAGAIN;
 			goto out;
 		}
diff --git a/mm/zswap.c b/mm/zswap.c
index f7c9c89f6449c..bc9b931d6f447 100644
--- a/mm/zswap.c
+++ b/mm/zswap.c
@@ -997,7 +997,7 @@ static int zswap_writeback_entry(struct zswap_entry *entry,
 
 	/* try to allocate swap cache folio */
 	si = get_swap_device(swpentry);
-	if (!si)
+	if (IS_ERR_OR_NULL(si))
 		return -EEXIST;
 
 	mpol = get_task_policy(current);

-- 
2.53.0-Meta


