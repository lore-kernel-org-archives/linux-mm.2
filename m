Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6AE0D1088E48
	for <linux-mm@archiver.kernel.org>; Wed, 18 Mar 2026 22:30:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3ECDF6B034E; Wed, 18 Mar 2026 18:30:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 377296B0350; Wed, 18 Mar 2026 18:30:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1C98C6B0351; Wed, 18 Mar 2026 18:30:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 01A386B034E
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 18:30:01 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 9E3BA1A01B4
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 22:30:01 +0000 (UTC)
X-FDA: 84560627802.16.8B35D86
Received: from mail-ot1-f44.google.com (mail-ot1-f44.google.com [209.85.210.44])
	by imf23.hostedemail.com (Postfix) with ESMTP id BE2AE140012
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 22:29:59 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=XRBL79c3;
	spf=pass (imf23.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.210.44 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773872999;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=c2YShPZ4Jwzd3oBlE3QRrECRq+KlYIXhWhrhg6PnH0Y=;
	b=OdPwlSNVk5f6/kOTedsSt2m4rv+NT0bntiP7IDzLUjp7O+w9PQ/3Ifu5aIEtaz1VrkdNv6
	zVLL0qrl14UlstXYo/6mCJfrbcweR0i/MwG+tt35e7L3cIlcSNgu2WZcMzOp6LPqH/le7d
	hx/fb8fDARhaqCapDwqbRLev71Nv3HE=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=XRBL79c3;
	spf=pass (imf23.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.210.44 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773872999; a=rsa-sha256;
	cv=none;
	b=IipdyLWcKyla1ZeYQ1sgZxQ+iFdcdCuhkW2w7N6nXoYNbmlqjB1feB+jVdvoF/qLCS/1Cf
	UzpHKuYPJ++xm6aZuLbFm+a/4JM/mVV+hAoHOoJ1qsFPeNNcKUVEImEo+Gr6s3kqIR9CuR
	xqgp63i+Q7hMHF5NpSarQ4SWDkzmEYo=
Received: by mail-ot1-f44.google.com with SMTP id 46e09a7af769-7d7d675e5b5so203417a34.0
        for <linux-mm@kvack.org>; Wed, 18 Mar 2026 15:29:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773872998; x=1774477798; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=c2YShPZ4Jwzd3oBlE3QRrECRq+KlYIXhWhrhg6PnH0Y=;
        b=XRBL79c3IpdIPLcREPQ9tVs66rsUHn9mtrWuUm4G7IBrB0e33h/JrfPwxNRxhThBq4
         3Hhocro0ZOEZ6lJCW1s+Wxr+mEe1FK6oQ7yf63PqTFT+0BOywXvdMFpmZsYlUqg4px30
         xAHJ7bHegN6xaTIxU4ajNbc5nJtXI9hF09gEhggOQUkKpdYvstA7K2k89FmH20xddYWa
         G5KAg8S49JkY+bPc0h5R4MpvWqSOI4bB2cqpf6dQPsgX4P7+9hCIJItRhEDCI7mW0FtJ
         eWCQCRSarhMaHmnf1CwoFKCN5ejz5ZOL1sI/IQbZRi49H2WF4U5IJOIUO5OSJxzN8iU2
         11KA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773872998; x=1774477798;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=c2YShPZ4Jwzd3oBlE3QRrECRq+KlYIXhWhrhg6PnH0Y=;
        b=UkIMW0r1QuVOOvGe9MXc1KDsQS+A1dB1PFtTIIs9jfP3G15Pj8+9qb69UbWAVbp5ES
         2imAwYExJ22XbHx8u8u+O1fcPdSPABjWhviVuh6Z9hz6yI3qByLTAltgHxQWKDbW9o51
         KekNM2ebtLRPYY2cAvUhy2EpaX3ySHH8Sikc/UVMYqlg3Q9EAWJxCmIdQBy4S5bUlQto
         QR33swF+fG2tMEp3NwGOYKPXwvscOi8usLdcW6U49fJP1ndn7yYRGtBrT8geXDWcAvZt
         iwQExNVMVCu8gUx865fmLFZWH4fbdCS1AHfSEN+7eI3+d2DNKq6czU4gJsK2YHdCvef0
         oEIg==
X-Forwarded-Encrypted: i=1; AJvYcCVTIAXs9hKI94PNXEJQtOTBfPU7qd6iu40FgPYl1edLgWIRY5tYZN+Vm0Wam4Lplyv3/PoD9YgBFQ==@kvack.org
X-Gm-Message-State: AOJu0YxB9oudzLXWCl/kVYtkUCODcOhnWDU2UTQyVIkf/g/AsgRBcp/E
	CUPEvUPAvh7lmnisbQOYYMmjEFzmeFW3nNh3YWse+evJ0JUhKF7qxGEV
X-Gm-Gg: ATEYQzxQGqi9UenzOMBvb1oGfBF3DcNNgLAXpsCEu4TXzJoICOKt1+baEbtVTTCY59/
	9wa/X251ak/lWkASkgjOzsCSbsB+PP4HceXo4Tz/So1LtedYHOul+ktuTMjqaHhP+LrxIDuI4qH
	2PJ4tTLNYyZLWod2eRT4jZCON3zbkFv1RSwVXUfhH8idTupTW6TUXNo7mVtyqLN3CCV3nf4byDE
	oic6HwrJHAM2hYpWtaQNOiMU+q+HE5/1wBmpMBBTineg9sp1rQjrS/IQaXhyyEQSkrG6SFyuLJy
	QRIY6rpzrz4KejB62nL8J0r7qtK5yn5bvkA+S6aYznZxBX4ZxXLJ7Z2w79yezYK36eF3lfBhPlA
	7xK+TrH/SOuiHuyGLbwRDF8bKi2uReppkG3QunldUU+lCqsLtxHL0slcEfyWZYuZaPIxM+0SygP
	0Wf8ISkspaLxf6qW+WxPbzUBPOnCoe7xpS+NzkI/Aq1ifa7Q==
X-Received: by 2002:a05:6830:3148:b0:7d7:cda1:36b with SMTP id 46e09a7af769-7d7cda10537mr2804540a34.20.1773872998497;
        Wed, 18 Mar 2026 15:29:58 -0700 (PDT)
Received: from localhost ([2a03:2880:10ff:4e::])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7d7c9b39e11sm2988989a34.18.2026.03.18.15.29.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Mar 2026 15:29:58 -0700 (PDT)
From: Nhat Pham <nphamcs@gmail.com>
To: kasong@tencent.com
Cc: Liam.Howlett@oracle.com,
	akpm@linux-foundation.org,
	apopple@nvidia.com,
	axelrasmussen@google.com,
	baohua@kernel.org,
	baolin.wang@linux.alibaba.com,
	bhe@redhat.com,
	byungchul@sk.com,
	cgroups@vger.kernel.org,
	chengming.zhou@linux.dev,
	chrisl@kernel.org,
	corbet@lwn.net,
	david@kernel.org,
	dev.jain@arm.com,
	gourry@gourry.net,
	hannes@cmpxchg.org,
	hughd@google.com,
	jannh@google.com,
	joshua.hahnjy@gmail.com,
	lance.yang@linux.dev,
	lenb@kernel.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-pm@vger.kernel.org,
	lorenzo.stoakes@oracle.com,
	matthew.brost@intel.com,
	mhocko@suse.com,
	muchun.song@linux.dev,
	npache@redhat.com,
	nphamcs@gmail.com,
	pavel@kernel.org,
	peterx@redhat.com,
	peterz@infradead.org,
	pfalcato@suse.de,
	rafael@kernel.org,
	rakie.kim@sk.com,
	roman.gushchin@linux.dev,
	rppt@kernel.org,
	ryan.roberts@arm.com,
	shakeel.butt@linux.dev,
	shikemeng@huaweicloud.com,
	surenb@google.com,
	tglx@kernel.org,
	vbabka@suse.cz,
	weixugc@google.com,
	ying.huang@linux.alibaba.com,
	yosry.ahmed@linux.dev,
	yuanchu@google.com,
	zhengqi.arch@bytedance.com,
	ziy@nvidia.com,
	kernel-team@meta.com,
	riel@surriel.com
Subject: [PATCH v4 03/21] mm: swap: add an abstract API for locking out swapoff
Date: Wed, 18 Mar 2026 15:29:34 -0700
Message-ID: <20260318222953.441758-4-nphamcs@gmail.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260318222953.441758-1-nphamcs@gmail.com>
References: <20260318222953.441758-1-nphamcs@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: BE2AE140012
X-Rspamd-Server: rspam07
X-Stat-Signature: n59q9hnay6hrbigkw35ex1x8gtfm43td
X-Rspam-User: 
X-HE-Tag: 1773872999-38528
X-HE-Meta: U2FsdGVkX180m5+tMm4tt6kyDH9gs5ss3iRwiC0G0rNdZOWtBpYhERJcmof0BEF1KvxFNgHvPD+UlgG+z86ih//c7RuVAyjyljTpf9iXe3IBtM3fY0Lh3zgElVniRw4dwMY+wPA7MXJboz/wJKtVwTLhO3ZuiNJi5miDAyIZKAIcUm7bI8ayS8CBPJymRUC9kMVu/T4KdsSdNR1JZAVxlsOGRfK3xGsIGBzWIAAgHZaryRUYuf/sDWbg5zIr75uR4fE5GE3iM1OStErtNllgo7jCGSgsZuM/UVd/kB0GUymmSaSIc8pgbroI4og8PUrbyTNf1SAUQjOuIBHa4Ug/yCG8R07ehpl+vKMSkDoLRCa0lLxjyaCLTg4EVmh+gwq3Z44TC/1HiCeeJ7K5T9XfCH8bm5e2SbEo0lM0YCNJIfD67lZ7G4Btt1CQCyj+23tdsonmneleV/i6y457Kz+Co0w4IwWvkWkN3mazyB7ecazgtShvBtJNL0ODrBw5cjDkVIl7kfMBRz+gxx2VBVDk3jEZUlYunut2JGP5A7T7fGTp2lknUr6cHSTBKdou4dJ0jcrzEHuu0vEvZGxiG04kHsLRo0PA7s2tWLgIdYOguI/ifhWT/G8bBkapsczGuqsnATmsrSUzWv2l8m/L9lOoqffn7qkNF6Io59kNmVmMy8i/f29fH3Ya3lpYoAEDWPA7DsS+ouhPFTCdGNKr0ok+034+N8k7wJfpezharQQJVdjr1Ban1jLW7VObGpsrmGl/u0SOtVz9Fm6oU6x/K3Jx3T65VH8QuJIrisNAnARU1QPkTtubnIHwQ16xyAwL8ODrRGAtPpHXFO57nSD5qHCNQZqbIV0utvj/s3HrK4VkGGO5VAPo/MDJTGMBnvsKuO0delosDmyrUASmwA2ap8yuii4zBiMQLshcOSY5avRBCqTzgSywZThInaILVWD8J8otYKsfh9677zu+tHAwqn2
 cxrU2ebT
 +STl65/rqxHFn0Y1BdoU8UVSn7hI+/O73cKOB5NFHDxna+SYpaMkY0Um+Y26DA7g9ceqGilaLwLoW3mndwqBrDdbdGu5XN+Q26IQYlEybz4RDlpd0N4aqSmAIPoQYKKJi1b30DPCpf3LqauaTvyLlNUseZWmxZfqKw9xRuOhybhZmCi6X2RzvqxkAHHX83nC8LFxP7yWQdHb22pITzecPcQRMqwApK6sKYYq3RBuH+HAPLPIBONdj3UV+zjvauGhWxqojh2z6NdJpolByDwJC516CxxEOTdWXbzIeUAn5cT5vWnIYTNq2VadE4iZNlryN0FXHdcTLDQOO6XgCFHCE0BpxoB7lOmcYwUAjf6EA01kT1b35hP8FhJDTcteUoU+klxIxkFGP49eUVkX73UVUFkZjMgTr840wHFg0hN6wu0jRFVn4oigkkETK5fdxRPp7TnmE0XrYz39rJ5Fz2ROLwMPgw9MPJbJDjepuf8vsXPvuBTumTN2SVDntdurrvWKZ1YgAFpoXMjRcVA8qsrEDzOeViuHLqD8e2nh5mpj4Mc6s8YU5hurSIRMwptzItpnkMHEF
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
2.52.0


