Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6CD8EEF06F8
	for <linux-mm@archiver.kernel.org>; Sun,  8 Feb 2026 21:58:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 298066B0093; Sun,  8 Feb 2026 16:58:53 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 222AE6B0096; Sun,  8 Feb 2026 16:58:53 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1180D6B0098; Sun,  8 Feb 2026 16:58:53 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id E99276B0093
	for <linux-mm@kvack.org>; Sun,  8 Feb 2026 16:58:52 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id B084D1B3124
	for <linux-mm@kvack.org>; Sun,  8 Feb 2026 21:58:52 +0000 (UTC)
X-FDA: 84422654904.16.650D500
Received: from mail-oo1-f45.google.com (mail-oo1-f45.google.com [209.85.161.45])
	by imf16.hostedemail.com (Postfix) with ESMTP id DDD06180004
	for <linux-mm@kvack.org>; Sun,  8 Feb 2026 21:58:50 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=YNn0J6B3;
	spf=pass (imf16.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.161.45 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770587930;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bkTf0BqWuQBW5wS4SMRRzp+y8TABCQWi3klTIzIW13I=;
	b=sMIKb/gxqPrqjv/UhS7ZFrFhvMs9HTaSONP9YnRLYrsclf9cqET7LjMgvn3OGaTw9+S3cr
	I2pab8TEYC40G1oI+ONecr/B7fiGgdGZrsxfvvDJrx6LXBE1dEthcGYTDBVF7hnv6cQfxR
	1NZip9c+zS3sYjT8WLDQ+KSECEnMqxk=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=YNn0J6B3;
	spf=pass (imf16.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.161.45 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770587930; a=rsa-sha256;
	cv=none;
	b=0I+9Hg3gnZLzWu8w3FtKsbdAGXdnY/cFEvO1TXh6STp+tMJ9eT1VYvahx+xKstPAYPngFI
	wZWVcODP17KFRB1+I0OmxeVxWCLuQVsXhmbSsnCCKV863HQ/kbA9Jg5XFTF5StSvuT1RMR
	AcjNlwXJ+hOvkbN98PY2ErF8bvhfwNU=
Received: by mail-oo1-f45.google.com with SMTP id 006d021491bc7-663170b9472so2300026eaf.3
        for <linux-mm@kvack.org>; Sun, 08 Feb 2026 13:58:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770587930; x=1771192730; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bkTf0BqWuQBW5wS4SMRRzp+y8TABCQWi3klTIzIW13I=;
        b=YNn0J6B3L9tCooL0flGS3GPEtmrTAuux/DpMCh4yfHP9pqyBVoSkhCHN3IM5vJLHDj
         F6Q15aX0RRbWyDXlptVxIu0xo//TgOuYSTWZ5mZOmXijLlZoBr7++r+Q8bkKSs0IU+t5
         EH2HiwGVk+7hP40DC6Nf5bDN8VvH6+5xNlDk2dVIj6G/xIgziUPq8ft0fAfl4lH2uEmF
         vX91XjcxN3Xm4XWHne0bU1PeDkqEbOLzxzODRraLauNQbM+A6ziDYnyK6AhrbfUBUSSj
         D1+Fm3hvy0rVhnmBXKbVvTFOwrcQLEcCL1xfR/m1ClCxpDEn0fajnvybowXKyKsvEtnU
         QQHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770587930; x=1771192730;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=bkTf0BqWuQBW5wS4SMRRzp+y8TABCQWi3klTIzIW13I=;
        b=aZ5lyCCnKLJt+BIDA3YjuSMHsoelvNxDgphuhtdKzJTMGDfKqvpiNf4b0WsARUyKPX
         UAQx/Q2ZAM2IyNaRdOZdStJM/Dgwy3X+NKOgruey9BJI355VFkfTlf/PDLPvAyn5pUhB
         W2jnL1G1/8ho+hbc00Hdw40PACnrEKY6rjws/BhDBMfAMMivp258D7+rzDQGaKlzebC8
         ty18235o57oyND5cDKfC5tekrR7EIJv75BoykDfgaE7hf7Gh9bOIOZfRRM1l8gDkzLcu
         f1/OxIQjjuQbSSP0qD6vKkG4GaZccUUPfG9WthFzoMZV56UI8+2ON57mmHDhDYWN8ZtG
         6C4g==
X-Gm-Message-State: AOJu0YxEy0nb35jrosR2qgWAWwVzZZSyR62ssN6jlHaXP2DnZ5e6OFP1
	sN55JiY2W4WkMRmU4+duxTGiLq+9IP6fK/KuRQClK1oUsN6dJtDCkd9wmcWjqIJ2r8UZ4w==
X-Gm-Gg: AZuq6aI49QTnZPBPauV3C2vD14SLSJGQ03p4D0NhTY8VByvJW2dTBq188qxuAWU83Zk
	/i5skGxkRJ2CQkr5ijyBdgDZzA3prlHYXz1baujMFPqB01AtKLA8jQ/DJO6iLzSLrdwFZzFyUvB
	GY5+NCxLX70iO8ReUArNTzXcasuIjK5bqW/nrL8Qh27pIODS0s0w+l5h+grN5twRanGzb2150BC
	UQ93X3YoAsg9dFicvcc7hi8Y9XD0y8BEFjnrs7qYXXXoF5u3Hc/tJylxYoQLsjYbNf8WO+hcuih
	Egg86/6knBLc9yClfASsnZ/yvrUFJIjbJKM6N3SUzNjNg0L7SlKXUW175cQ/gmL1f5rLsOqSwZS
	pzgMe6bdelcM2g9TKJkUU7rFGRbY5kIOIzLvdMcOFD4hKJkXwKinWLmLVTabBq+ozP1nQqXUBhc
	6EMop7prGexy4a5SWzNAz/qPLfv3b+i4pxrQ==
X-Received: by 2002:a05:6820:3088:b0:663:888:6093 with SMTP id 006d021491bc7-66d0ce25452mr4103771eaf.70.1770587929794;
        Sun, 08 Feb 2026 13:58:49 -0800 (PST)
Received: from localhost ([2a03:2880:10ff:56::])
        by smtp.gmail.com with ESMTPSA id 006d021491bc7-66d391ae639sm4736638eaf.7.2026.02.08.13.58.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 08 Feb 2026 13:58:49 -0800 (PST)
From: Nhat Pham <nphamcs@gmail.com>
To: linux-mm@kvack.org
Cc: akpm@linux-foundation.org,
	hannes@cmpxchg.org,
	hughd@google.com,
	yosry.ahmed@linux.dev,
	mhocko@kernel.org,
	roman.gushchin@linux.dev,
	shakeel.butt@linux.dev,
	muchun.song@linux.dev,
	len.brown@intel.com,
	chengming.zhou@linux.dev,
	kasong@tencent.com,
	chrisl@kernel.org,
	huang.ying.caritas@gmail.com,
	ryan.roberts@arm.com,
	shikemeng@huaweicloud.com,
	viro@zeniv.linux.org.uk,
	baohua@kernel.org,
	bhe@redhat.com,
	osalvador@suse.de,
	lorenzo.stoakes@oracle.com,
	christophe.leroy@csgroup.eu,
	pavel@kernel.org,
	kernel-team@meta.com,
	linux-kernel@vger.kernel.org,
	cgroups@vger.kernel.org,
	linux-pm@vger.kernel.org,
	peterx@redhat.com,
	riel@surriel.com,
	joshua.hahnjy@gmail.com,
	npache@redhat.com,
	gourry@gourry.net,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	rafael@kernel.org,
	jannh@google.com,
	pfalcato@suse.de,
	zhengqi.arch@bytedance.com
Subject: [PATCH v3 03/20] mm: swap: add an abstract API for locking out swapoff
Date: Sun,  8 Feb 2026 13:58:16 -0800
Message-ID: <20260208215839.87595-4-nphamcs@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260208215839.87595-1-nphamcs@gmail.com>
References: <20260208215839.87595-1-nphamcs@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: DDD06180004
X-Stat-Signature: yq7iss4gw363nscperwzgjb81rmxdb9w
X-Rspam-User: 
X-HE-Tag: 1770587930-480296
X-HE-Meta: U2FsdGVkX1+urZ4J0wHUqrjxFcoSAPQQEVkDejLSsBW9nzYexCSzpz+WHPH1yEoXGKAuhqtdAa1AOGcTqUOOth3LsPUNHWb6pYYCP6RmyMZRsINlXAz6SzDV1Dcn1CkHGMlwpBK9ShUhdEWagWZ6AZ24+sAw4hTXprAqZ20o3JZ0OnidX2XR0xeWkAmTrHJVwQQmxfGk+qE+ApspKlJuz6nkvKzlFbYwnzet/e58pVYXJtRuS1yUaHzxiZp8+1pkRvKgpbzCEsZ6O52RnAyA+rlIdiTqHW/QFa58ZoLFH6A3R/X+r0CwiepCHuD4w5koQ0gZwSQ112kDuF6D+bwiVR3cVdkNsigy0qE9CQDxlmUnRci2U/CnDg3SbKfzQqg9H5iiweBt9t2AOBceFwJq4TtPMe/hMMztfEnv9OXo6iqbnI4/dpza+keQL6nYVWULiYMczOZaqktoU66fsYdVmeWu269BhtGhJljJCo8/U0EEq7iKvp3RweO8hjPcVcQo3+/msoqUzVg36PS4VCvmhzjqXkTXxfbu+pR7Sy+ExIOqQ66LtRpne0j1dnZasR+oyRWG/APkm1iResZgUtf1XkscFj9SnCGVz5KQt5ueTFNA9T/RO3BuI0iUsNijtm3z1nuH9vzh08wCaxeU25mQusQ7MGz6kGLkAWujAaHfoj4V4DzYBSjafb/6+gLFD5iVf3rEuM/xY5pLVUYqUWFJVtLYjnCr4RWH4qdJmh7L2sSKnjDOypw6zKOw2Q/p4QIfWbD8gyc/0G31b7udsnRqwpFjweC6qsuFt0Keqai8Tq37Vc9P4KU7Wr7gBiX71pB9ylVWj9keV6Dt+qc+40DGPwRG53i/tqnV340ts5sl7nKLzIE5GFkwaZMVZ3nlftUalGUbdFxBKUroUeUosEv//G+K20UEQoYswxxywXPxX8BRBzQpfTR5KVL1XvRb5urA5cokNiXfIaU76ITQsTV
 O/vIjGvp
 8ApD8jnXPzrD0gwI2x7fLU9jLDVraquf3LQ7HijWx3dujmHErbpC7VGb299mevJ/lfVwQPYpgz1mctBlJwUKKchUfAm50h46dLr9Xo1Z2+MYEDtniM2sta/t+TTVcn4RzNMV6UBwKTuDgRoL3+nP11hIz8BEkrxlsXx6LGIROrFHxAPUENpyRM9AcY+IydmjO/JumJSTPVqLVXQHmfF7ufQlkA5wNT36q7Sa6lv3Y80RfmJ7jxtFxxP38fb++KouE7rabe+0pTOfun5CnYw8D60VvAw9PRipEedXFrna4hpTIPT/PflavuIGBkh6s5JyEleAE9VucPHn291I8DFQOBMlQmNrZ0drn8VgDbup/Lw1SgWr29qkTOaXTxOXzyc5uHKPCKOKpb00mTk/isanjz9BkBh3039Vpx9S63jBErikqZNkOJ4BA8Ory+CfdJr2BkQYxGaX+kkgWJi7CB7sHfhOnYoPapRIIVix/hZdPKPi408wCvI5AwnGxPCfQCJqZsoOTuCIHFk2IZfLOBgsxJWFs0Rr0HEn1BPD/y4sGExoDxWM66vDQgc3S+mScapGZpQWS
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Currently, we get a reference to the backing swap device in order to
prevent swapoff from freeing the metadata of a swap entry. This does not
make sense in the new virtual swap design, especially after the swap
backends are decoupled - a swap entry might not have any backing swap
device at all, and its backend might change at any time during its
lifetime.

In preparation for this, abstract away the swapoff locking out behavior
into a generic API.

Signed-off-by: Nhat Pham <nphamcs@gmail.com>
---
 include/linux/swap.h | 17 +++++++++++++++++
 mm/memory.c          | 13 +++++++------
 mm/mincore.c         | 15 +++------------
 mm/shmem.c           | 12 ++++++------
 mm/swap_state.c      | 14 +++++++-------
 mm/userfaultfd.c     | 15 +++++++++------
 mm/zswap.c           |  5 ++---
 7 files changed, 51 insertions(+), 40 deletions(-)

diff --git a/include/linux/swap.h b/include/linux/swap.h
index aa29d8ac542d1..3da637b218baf 100644
--- a/include/linux/swap.h
+++ b/include/linux/swap.h
@@ -659,5 +659,22 @@ static inline bool mem_cgroup_swap_full(struct folio *folio)
 }
 #endif
 
+static inline bool tryget_swap_entry(swp_entry_t entry,
+				struct swap_info_struct **sip)
+{
+	struct swap_info_struct *si = get_swap_device(entry);
+
+	if (sip)
+		*sip = si;
+
+	return si;
+}
+
+static inline void put_swap_entry(swp_entry_t entry,
+				struct swap_info_struct *si)
+{
+	put_swap_device(si);
+}
+
 #endif /* __KERNEL__*/
 #endif /* _LINUX_SWAP_H */
diff --git a/mm/memory.c b/mm/memory.c
index da360a6eb8a48..90031f833f52e 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -4630,6 +4630,7 @@ vm_fault_t do_swap_page(struct vm_fault *vmf)
 	struct swap_info_struct *si = NULL;
 	rmap_t rmap_flags = RMAP_NONE;
 	bool need_clear_cache = false;
+	bool swapoff_locked = false;
 	bool exclusive = false;
 	softleaf_t entry;
 	pte_t pte;
@@ -4698,8 +4699,8 @@ vm_fault_t do_swap_page(struct vm_fault *vmf)
 	}
 
 	/* Prevent swapoff from happening to us. */
-	si = get_swap_device(entry);
-	if (unlikely(!si))
+	swapoff_locked = tryget_swap_entry(entry, &si);
+	if (unlikely(!swapoff_locked))
 		goto out;
 
 	folio = swap_cache_get_folio(entry);
@@ -5047,8 +5048,8 @@ vm_fault_t do_swap_page(struct vm_fault *vmf)
 		if (waitqueue_active(&swapcache_wq))
 			wake_up(&swapcache_wq);
 	}
-	if (si)
-		put_swap_device(si);
+	if (swapoff_locked)
+		put_swap_entry(entry, si);
 	return ret;
 out_nomap:
 	if (vmf->pte)
@@ -5066,8 +5067,8 @@ vm_fault_t do_swap_page(struct vm_fault *vmf)
 		if (waitqueue_active(&swapcache_wq))
 			wake_up(&swapcache_wq);
 	}
-	if (si)
-		put_swap_device(si);
+	if (swapoff_locked)
+		put_swap_entry(entry, si);
 	return ret;
 }
 
diff --git a/mm/mincore.c b/mm/mincore.c
index e5d13eea92347..f3eb771249d67 100644
--- a/mm/mincore.c
+++ b/mm/mincore.c
@@ -77,19 +77,10 @@ static unsigned char mincore_swap(swp_entry_t entry, bool shmem)
 	if (!softleaf_is_swap(entry))
 		return !shmem;
 
-	/*
-	 * Shmem mapping lookup is lockless, so we need to grab the swap
-	 * device. mincore page table walk locks the PTL, and the swap
-	 * device is stable, avoid touching the si for better performance.
-	 */
-	if (shmem) {
-		si = get_swap_device(entry);
-		if (!si)
-			return 0;
-	}
+	if (!tryget_swap_entry(entry, &si))
+		return 0;
 	folio = swap_cache_get_folio(entry);
-	if (shmem)
-		put_swap_device(si);
+	put_swap_entry(entry, si);
 	/* The swap cache space contains either folio, shadow or NULL */
 	if (folio && !xa_is_value(folio)) {
 		present = folio_test_uptodate(folio);
diff --git a/mm/shmem.c b/mm/shmem.c
index 1db97ef2d14eb..b40be22fa5f09 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -2307,7 +2307,7 @@ static int shmem_swapin_folio(struct inode *inode, pgoff_t index,
 	softleaf_t index_entry;
 	struct swap_info_struct *si;
 	struct folio *folio = NULL;
-	bool skip_swapcache = false;
+	bool swapoff_locked, skip_swapcache = false;
 	int error, nr_pages, order;
 	pgoff_t offset;
 
@@ -2319,16 +2319,16 @@ static int shmem_swapin_folio(struct inode *inode, pgoff_t index,
 	if (softleaf_is_poison_marker(index_entry))
 		return -EIO;
 
-	si = get_swap_device(index_entry);
+	swapoff_locked = tryget_swap_entry(index_entry, &si);
 	order = shmem_confirm_swap(mapping, index, index_entry);
-	if (unlikely(!si)) {
+	if (unlikely(!swapoff_locked)) {
 		if (order < 0)
 			return -EEXIST;
 		else
 			return -EINVAL;
 	}
 	if (unlikely(order < 0)) {
-		put_swap_device(si);
+		put_swap_entry(index_entry, si);
 		return -EEXIST;
 	}
 
@@ -2448,7 +2448,7 @@ static int shmem_swapin_folio(struct inode *inode, pgoff_t index,
 	}
 	folio_mark_dirty(folio);
 	swap_free_nr(swap, nr_pages);
-	put_swap_device(si);
+	put_swap_entry(swap, si);
 
 	*foliop = folio;
 	return 0;
@@ -2466,7 +2466,7 @@ static int shmem_swapin_folio(struct inode *inode, pgoff_t index,
 		swapcache_clear(si, folio->swap, folio_nr_pages(folio));
 	if (folio)
 		folio_put(folio);
-	put_swap_device(si);
+	put_swap_entry(swap, si);
 
 	return error;
 }
diff --git a/mm/swap_state.c b/mm/swap_state.c
index 34c9d9b243a74..bece18eb540fa 100644
--- a/mm/swap_state.c
+++ b/mm/swap_state.c
@@ -538,8 +538,7 @@ struct folio *read_swap_cache_async(swp_entry_t entry, gfp_t gfp_mask,
 	pgoff_t ilx;
 	struct folio *folio;
 
-	si = get_swap_device(entry);
-	if (!si)
+	if (!tryget_swap_entry(entry, &si))
 		return NULL;
 
 	mpol = get_vma_policy(vma, addr, 0, &ilx);
@@ -550,7 +549,7 @@ struct folio *read_swap_cache_async(swp_entry_t entry, gfp_t gfp_mask,
 	if (page_allocated)
 		swap_read_folio(folio, plug);
 
-	put_swap_device(si);
+	put_swap_entry(entry, si);
 	return folio;
 }
 
@@ -763,6 +762,7 @@ static struct folio *swap_vma_readahead(swp_entry_t targ_entry, gfp_t gfp_mask,
 	for (addr = start; addr < end; ilx++, addr += PAGE_SIZE) {
 		struct swap_info_struct *si = NULL;
 		softleaf_t entry;
+		bool swapoff_locked = false;
 
 		if (!pte++) {
 			pte = pte_offset_map(vmf->pmd, addr);
@@ -781,14 +781,14 @@ static struct folio *swap_vma_readahead(swp_entry_t targ_entry, gfp_t gfp_mask,
 		 * holding a reference to, try to grab a reference, or skip.
 		 */
 		if (swp_type(entry) != swp_type(targ_entry)) {
-			si = get_swap_device(entry);
-			if (!si)
+			swapoff_locked = tryget_swap_entry(entry, &si);
+			if (!swapoff_locked)
 				continue;
 		}
 		folio = __read_swap_cache_async(entry, gfp_mask, mpol, ilx,
 						&page_allocated, false);
-		if (si)
-			put_swap_device(si);
+		if (swapoff_locked)
+			put_swap_entry(entry, si);
 		if (!folio)
 			continue;
 		if (page_allocated) {
diff --git a/mm/userfaultfd.c b/mm/userfaultfd.c
index e6dfd5f28acd7..25f89eba0438c 100644
--- a/mm/userfaultfd.c
+++ b/mm/userfaultfd.c
@@ -1262,9 +1262,11 @@ static long move_pages_ptes(struct mm_struct *mm, pmd_t *dst_pmd, pmd_t *src_pmd
 	pte_t *dst_pte = NULL;
 	pmd_t dummy_pmdval;
 	pmd_t dst_pmdval;
+	softleaf_t entry;
 	struct folio *src_folio = NULL;
 	struct mmu_notifier_range range;
 	long ret = 0;
+	bool swapoff_locked = false;
 
 	mmu_notifier_range_init(&range, MMU_NOTIFY_CLEAR, 0, mm,
 				src_addr, src_addr + len);
@@ -1429,7 +1431,7 @@ static long move_pages_ptes(struct mm_struct *mm, pmd_t *dst_pmd, pmd_t *src_pmd
 					len);
 	} else { /* !pte_present() */
 		struct folio *folio = NULL;
-		const softleaf_t entry = softleaf_from_pte(orig_src_pte);
+		entry = softleaf_from_pte(orig_src_pte);
 
 		if (softleaf_is_migration(entry)) {
 			pte_unmap(src_pte);
@@ -1449,8 +1451,8 @@ static long move_pages_ptes(struct mm_struct *mm, pmd_t *dst_pmd, pmd_t *src_pmd
 			goto out;
 		}
 
-		si = get_swap_device(entry);
-		if (unlikely(!si)) {
+		swapoff_locked = tryget_swap_entry(entry, &si);
+		if (unlikely(!swapoff_locked)) {
 			ret = -EAGAIN;
 			goto out;
 		}
@@ -1480,8 +1482,9 @@ static long move_pages_ptes(struct mm_struct *mm, pmd_t *dst_pmd, pmd_t *src_pmd
 				pte_unmap(src_pte);
 				pte_unmap(dst_pte);
 				src_pte = dst_pte = NULL;
-				put_swap_device(si);
+				put_swap_entry(entry, si);
 				si = NULL;
+				swapoff_locked = false;
 				/* now we can block and wait */
 				folio_lock(src_folio);
 				goto retry;
@@ -1507,8 +1510,8 @@ static long move_pages_ptes(struct mm_struct *mm, pmd_t *dst_pmd, pmd_t *src_pmd
 	if (dst_pte)
 		pte_unmap(dst_pte);
 	mmu_notifier_invalidate_range_end(&range);
-	if (si)
-		put_swap_device(si);
+	if (swapoff_locked)
+		put_swap_entry(entry, si);
 
 	return ret;
 }
diff --git a/mm/zswap.c b/mm/zswap.c
index ac9b7a60736bc..315e4d0d08311 100644
--- a/mm/zswap.c
+++ b/mm/zswap.c
@@ -1009,14 +1009,13 @@ static int zswap_writeback_entry(struct zswap_entry *entry,
 	int ret = 0;
 
 	/* try to allocate swap cache folio */
-	si = get_swap_device(swpentry);
-	if (!si)
+	if (!tryget_swap_entry(swpentry, &si))
 		return -EEXIST;
 
 	mpol = get_task_policy(current);
 	folio = __read_swap_cache_async(swpentry, GFP_KERNEL, mpol,
 			NO_INTERLEAVE_INDEX, &folio_was_allocated, true);
-	put_swap_device(si);
+	put_swap_entry(swpentry, si);
 	if (!folio)
 		return -ENOMEM;
 
-- 
2.47.3


