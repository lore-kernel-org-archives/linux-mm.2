Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E0FA0C5B572
	for <linux-mm@archiver.kernel.org>; Thu, 13 Aug 2026 10:03:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 51E4E6B046E; Thu, 13 Aug 2026 06:03:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4F5496B0470; Thu, 13 Aug 2026 06:03:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3E4A26B0471; Thu, 13 Aug 2026 06:03:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E494A6B046E
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 06:03:11 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 7ABDB1C0943
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 10:03:11 +0000 (UTC)
X-FDA: 85095808182.25.6BD960F
Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	by imf26.hostedemail.com (Postfix) with ESMTP id A865E140008
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 10:03:09 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b="jr/gtnYU";
	spf=pass (imf26.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org;
	dmarc=pass (policy=none) header.from=debian.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786615389;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nW4dx7azFe7LSVA6jpBULm/JBvhTDPlBwBxqVX/o6v4=;
	b=16hTIecyR5lANQ88MVh3h4qrk9OeF5mENK5BQT5ov7b+RmxJWk6nf2U3/vRh6cL06p9+WL
	wrgV0/t79K9kdJ+XYtJfGQH/IG3/LCznl2x8eNcZdMEP0T5zVzbxkej8exUtAqP3361aI5
	Olhzk0y203TW2y68rPTER3WT8DBm480=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786615389;
	b=2mz8KXQ2wXLSWHLy4UjKE4BBglKJ9IAgBZ2hE6u4irsAngUiXwCZ7UNrSRpcVo9LEgJ9qz
	ALwNX5EWDLzt6nT8dz3fVjcGoW8HNSJp8p/KgVooJNdgeRtGA28hrFtG6CIm2LqP9tufJL
	XW3NiehSs2hKAWEyuCjOorWpH9FDBsw=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b="jr/gtnYU";
	spf=pass (imf26.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org;
	dmarc=pass (policy=none) header.from=debian.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:Cc:To:In-Reply-To:References:
	Message-Id:Content-Transfer-Encoding:Content-Type:MIME-Version:Subject:Date:
	From:Reply-To:Content-ID:Content-Description;
	bh=nW4dx7azFe7LSVA6jpBULm/JBvhTDPlBwBxqVX/o6v4=; b=jr/gtnYUPJn35bFbgnTThAFd3i
	mtksnuQUghedUQr8c6jm5LlOllAB3R3ehY7g8J5bELF1jP0o3HetsYcimWm2JUzWAnntKmcEmRew/
	0CO2R6zOVxeYRRBuaIlNPypBSg0M8i7+AZ4fDeCZRrZRLUd66S9L//+vgLQLN3VrZl9osXejugCT4
	+XaU3SwWsLaxHctoOvodE1LaJbqWxFFzwWsxV2KcNxVKaHHbxVQ4zLgiNMoau8G0Q6ntO8VW2SquM
	MVakD19DCowOIFfjMTzUrht2wdHhVEpkNznqMEdyALli7zSP7PhwW9VQ81L2yCcGmsKaK1XfOQh2G
	1y6HIqPw==;
Received: from authenticated-user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1wuSGp-00520d-2l;
	Thu, 13 Aug 2026 10:02:44 +0000
From: Breno Leitao <leitao@debian.org>
Date: Thu, 13 Aug 2026 03:02:21 -0700
Subject: [PATCH v2 2/3] mm, swap: distinguish a malformed swap entry from a
 dying device
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260813-swap-v2-2-4a625ccabdae@debian.org>
References: <20260813-swap-v2-0-4a625ccabdae@debian.org>
In-Reply-To: <20260813-swap-v2-0-4a625ccabdae@debian.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=5745; i=leitao@debian.org;
 h=from:subject:message-id; bh=NTv5/DwTN5mFixsR8Cr3qjEgNKg+xDGXeNdv6HjXAnI=;
 b=owEBbQKS/ZANAwAIATWjk5/8eHdtAcsmYgBqfZYwXdMP2H5UT67k+zQAurHB5wIbkOKJoS0l9
 Y8qCjVrOzaJAjMEAAEIAB0WIQSshTmm6PRnAspKQ5s1o5Of/Hh3bQUCan2WMAAKCRA1o5Of/Hh3
 bXLmD/wPbEfuG7uCd9zWW4kPRlgxcvF5VGKtVq6f0teE3v3NYCo6u5yMsJW1nVjzEJ4fHyAcvnX
 Mgay5zRzzIQLWKD3xqyzNrzaFZ7ZibMRFeg1FPGPw5vwFQ3cPD5rQetn649hcZ+Gia/5aPpy2UQ
 /hEkp8mvn3E9kMPYQpR0M03lp//wNPCkK4PMzJVwH5VGLJDoTA83hQ0Gu3izR+ZnJMbvJidiYEi
 5+atSAKQaInTlKfOHpAAublGxU65jMRRUiUuoPLFWza+dyd/C9DCd46TMJYi1KTQI5zF+wXkj/w
 jLauqHPKs4jqT3vMQ5zJbeYx+4l/Mhui48yP8i48KmPzvaFbpQ4msnMIW4Hv60gM28SlIkW7vZw
 W8W485kjSWmwLLX5t7CwARFVdxIFEEJqDfhi8U2bckFjDWuPJnN7DKjFQPNbeyTCxgTskQZPWcW
 tHsI9TtvbwT8AlEZiaSP6sqQHyxnoLrJUo5pqDUpee8NFNKzzipeN5kbRAcaRxOLxhHwxsShDQA
 3KdJc5M7bwzlrsi61/6JK1B5f6kKBZZq+EJd7icEG4LD86z2UxxswrfORGzANxJvVZkI67cOOVA
 zPeC3/mpoHHDYUpnDMXkfskHLF78FUtt9SlYbTSJC6HZFmmuANrSXN49GO5f3Cq367PjRCSPW6W
 ry3nkTKzvFvrCyg==
X-Developer-Key: i=leitao@debian.org; a=openpgp;
 fpr=AC8539A6E8F46702CA4A439B35A3939FFC78776D
X-Debian-User: leitao
X-Rspam-User: 
X-Stat-Signature: rrjss5iyyuyngkjgofc5rcsc7nucisjr
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: A865E140008
X-HE-Tag: 1786615389-299789
X-HE-Meta: U2FsdGVkX19nlHBFnrwM/dMZdU7L1PJF/DNsgD8Dqr0UB+ujgdW5eM7nJZYABTpV/7qbMMM380/R1xhxZ9j/vWtcvFdBf2TPM+6d5c7XEy8LmEEH+GLaiqnMYDvOHa2ZlXMEL/8WfIoixVhgvEXDUPk2u4vkepANE0ymFarqoPwOMZvKUklTi1MDL6UkZDTM7QMGX570nuY35kcHjMt1ELo8EaCajUptrVziLvXCKb2uApv19nQgVb+bjkiXSRotR9b1APPqMVK992eFIGkKdVMfVTQ6ouU5ms+KuN2A4PrqfDkd87zab6S/MCWqdkLq+vycZ1cPU68HUBBSblryUXG5lK6UB7gWbO0LnZXSwSsdExt3aQGw6O9G8ZL32N2xUMEgkr7yjgH8Ljlt7CQQtIatORlLKHSOsVFLqIf4SPk+6pTv8bjsHl0AejTq/WOikejfzQ1v012qqKbTks2wdARH1Vaj+v51QQMJX7W5srJcJByeN01civLOkYkbS/WhSszc3TSBzjeekUwhv9y+3uIcoj6Nt4RLSVPPITBzH8x3XU5Sax/CwJ/HPMaIMAx6fLTw1fDUmj2lcez1Ua1FVRBM9J/1Elx3Cay1j5BiG8pTIotIC1ncxVriovWTyZP7JPHXYLoA1UYXJFEa70n//SszPqz+pdf4UtNyvCnJdm11mcwCatuicVoKHs0JmQUHWjaY0fs3ItfFh7MCRIgpnR03XgMcBjofQbhxqeW8vs+ktuZdfkuoTaRgrcsSIWDb/Ivlt0lwWlNSugIPYjaJpW8xq5/FqqbYFZLYgOjBNDbKb1+Y94lt2o3awzQDq/9yz1J3JokcVbKtGWormTrzvotzBNNbM4Gun5p8SJFUDHndWzZnUeEFiMZYc1pnKeH7vCl/f76OKSn3qOqVVrmQcW4f/Qrdvp9dzeUSwuBXYULOOyVyf4+VU1IIdWpfeyi/AA0LIf6l5XJh2TkuIh+
 05Ts3C/g
 RWUNhoTCuDbgDM1XxJewmvrFO+DSM9sNojBqJOjE9NEqLN8RP1iKEquFdJT7pMYFWl3azeRN9iTVpzsQdNM73Bsl6VVSVIlq7/2/mn+A6/YVWkGmr6yD9Jsak6NcxRY/Ix7wCnZQr99Y6b+W5FLr8Cd6lMvryQNgppRKgQ4CF7jpoIB+Y2o96eGxnqYK3AVQnVA4pFW52CnH6siOb9CMKuUWdV6iIdFTz7VV+xFS020F+66dTO5cl1I1GFJGMgghiSb7pN+IURU5S0Vwb/7zHQMQW5we7v2l6G3B2
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

get_swap_device() returns NULL for two different things: an entry whose
type names no swap device or whose offset is past the end of one, and a
device that swapoff is taking away. The first never becomes valid, the
second does, and callers cannot tell them apart.

Return ERR_PTR(-EIO) for the two malformed cases and keep NULL for
swapoff. copy_nonpresent_pte() already reports -EIO for the same
corruption on the fork path.

Callers bail out on failure either way, so switch them to
IS_ERR_OR_NULL() and clear si where the cleanup path would otherwise
put an ERR_PTR. No functional change.

Signed-off-by: Breno Leitao <leitao@debian.org>
---
 mm/memory.c      |  6 ++++--
 mm/mincore.c     |  2 +-
 mm/shmem.c       |  2 +-
 mm/swap_state.c  |  4 ++--
 mm/swapfile.c    | 14 +++++++++-----
 mm/userfaultfd.c |  3 ++-
 mm/zswap.c       |  2 +-
 7 files changed, 20 insertions(+), 13 deletions(-)

diff --git a/mm/memory.c b/mm/memory.c
index d9cf941967cf0..7201e848129a7 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -4954,10 +4954,12 @@ vm_fault_t do_swap_page(struct vm_fault *vmf)
 		goto out;
 	}
 
-	/* Prevent swapoff from happening to us. */
+	/* Prevent swapoff from happening to us, and reject a bad entry. */
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
index 31c8a340606bb..b96bc89815935 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -1504,7 +1504,7 @@ int swap_retry_table_alloc(swp_entry_t entry, gfp_t gfp)
 	unsigned long offset = swp_offset(entry);
 
 	si = get_swap_device(entry);
-	if (!si)
+	if (IS_ERR_OR_NULL(si))
 		return 0;
 
 	ci = __swap_offset_to_cluster(si, offset);
@@ -1859,7 +1859,10 @@ void folio_put_swap(struct folio *folio, struct page *page)
  * Check whether swap entry is valid in the swap device.  If so,
  * return pointer to swap_info_struct, and keep the swap entry valid
  * via preventing the swap device from being swapoff, until
- * put_swap_device() is called.  Otherwise return NULL.
+ * put_swap_device() is called.  Return NULL for an empty entry or a
+ * device that is going away, and ERR_PTR(-EIO) if the entry's type
+ * names no swap device or its offset is past the end of one. These EIOs
+ * are preceded by pr_err().
  *
  * Notice that swapoff or swapoff+swapon can still happen before the
  * percpu_ref_tryget_live() in get_swap_device() or after the
@@ -1900,12 +1903,13 @@ struct swap_info_struct *get_swap_device(swp_entry_t entry)
 	return si;
 bad_nofile:
 	pr_err_ratelimited("%s: %s%08lx\n", __func__, Bad_file, entry.val);
+	return ERR_PTR(-EIO);
 out:
 	return NULL;
 put_out:
 	pr_err_ratelimited("%s: %s%08lx\n", __func__, Bad_offset, entry.val);
 	percpu_ref_put(&si->users);
-	return NULL;
+	return ERR_PTR(-EIO);
 }
 
 /*
@@ -2001,7 +2005,7 @@ int swp_swapcount(swp_entry_t entry)
 	int count;
 
 	si = get_swap_device(entry);
-	if (!si)
+	if (IS_ERR_OR_NULL(si))
 		return 0;
 
 	ci = swap_cluster_lock(si, swp_offset(entry));
@@ -2127,7 +2131,7 @@ void swap_put_entries_direct(swp_entry_t entry, int nr)
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


