Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A5E19CD343F
	for <linux-mm@archiver.kernel.org>; Tue,  5 May 2026 15:39:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7B6A56B00A8; Tue,  5 May 2026 11:39:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7684B6B00A9; Tue,  5 May 2026 11:39:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 51E816B00AA; Tue,  5 May 2026 11:39:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 3B9386B00A8
	for <linux-mm@kvack.org>; Tue,  5 May 2026 11:39:22 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id A5741A03F0
	for <linux-mm@kvack.org>; Tue,  5 May 2026 15:39:21 +0000 (UTC)
X-FDA: 84733775322.12.62C65D7
Received: from mail-oa1-f46.google.com (mail-oa1-f46.google.com [209.85.160.46])
	by imf28.hostedemail.com (Postfix) with ESMTP id 9FCA3C0002
	for <linux-mm@kvack.org>; Tue,  5 May 2026 15:39:19 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=HoUjqqpO;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf28.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.160.46 as permitted sender) smtp.mailfrom=nphamcs@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777995559; a=rsa-sha256;
	cv=none;
	b=1bN5SiTkaV6qeS06xIw8Iw0RX8X9RTjD0LjkUQ3NV5wjtBDwY2LwyIHwdBNmdST50MDvTZ
	BZw8debF1xT/2kXpVWzyHa28p0HJZFbjZL+UFuq0M/tbECXca7+TDrPFXdUXnykYXhvgFY
	VsdlTpfful8oXx3wmScJhieIDfYcMLQ=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=HoUjqqpO;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf28.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.160.46 as permitted sender) smtp.mailfrom=nphamcs@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777995559;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=e35P/OP06CBwJ2CvgGAm38hrV6M0VW30Y7aJyYxGvPg=;
	b=ApUwvdE9r52GJLYI4Cp56X5+1SGAY9GBS8ZfwzKvKEt6ymNp+WwkvRvgGmly6XAKCRxLXS
	c7u5HsBX3DYM2Ocnhv6JeOs7rbUu0eie80R/pyXscEbFOuaOa8449B/Ku8FcjsifpNSVKJ
	XZe7p9htZTF0FFbsZ6/Wz/68UBReq2o=
Received: by mail-oa1-f46.google.com with SMTP id 586e51a60fabf-42fc6923f38so3696877fac.1
        for <linux-mm@kvack.org>; Tue, 05 May 2026 08:39:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1777995558; x=1778600358; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=e35P/OP06CBwJ2CvgGAm38hrV6M0VW30Y7aJyYxGvPg=;
        b=HoUjqqpObA9tT3TDBPzLClN7oi8jwv8lnWkHLVuz0Gkysep9/yrqSSI6zYPMs+ymOC
         8OwxHfw7g5BT9pGl1H08XEmMr5iFM60hWwZPgBZzS2J5nQhx6+EjZA6tWBPWjId4vYBH
         MpEzbI0EqtBvWEcSMkkL5A94TSvHcZPcn3QEsN7u0bAbkUqwmQRnzV6VsKz5vxHGmYgh
         GFervzUZ13xe75Zqp7bnyf5scJXIqWSFq96tOgqwn41CC0VessOStywUOBeNqytMkuZ4
         /C3EUtcGOjqYcfeichnZSt9nBSH35BLxHBMRWoTM/DDCc0u6k7UhHZTUyDL/untODGW4
         a3uQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777995558; x=1778600358;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=e35P/OP06CBwJ2CvgGAm38hrV6M0VW30Y7aJyYxGvPg=;
        b=XjnNtU3wWHNHFBw/hn4buGasBcfFKxfMHjYYqA9sTL6FJGELwILMZBSCET+aX6GYWT
         TGwxlOY/1/2mdSoZnvebtt6NeaGFGu/ufmveWZKPnvJQWQidfZPQAR1KFygjbrQwlGM6
         lqONoHgj9rLZ8S3XtftOj7WFUrohr2sLxDq+vwRwNUZEGUtbokb2k7jCJ3is3PcxHrbP
         U9VD9a8D9R1odc1HlhG6F/FBzy+X8qIoAIy8BYFVU+dp6e+lqRnImB98OMozm0bGVfDp
         eUiUgzrPJHG83GPaFyPu1Wy6q6KUo2hpBkORoNENW3pT00xKtgPHqKfEvjwqaQD5hn7O
         xwxg==
X-Forwarded-Encrypted: i=1; AFNElJ+4Gl9mBswFvYSS3P/WYrNAa17L0Qs1vJLK8iHp2IlYcjOfaNLpfuQoU4Aku1y4FN05Ok/R0OukkQ==@kvack.org
X-Gm-Message-State: AOJu0YzO5a/gLLlsI+A0bOJZ+n2rShNzRz1nAStVwMjNeEzxbzTrT9cO
	cNqofhpTZmseTAHk4WsZeXebsmgD7d90Qos9Wex/5bMamZiA+F8eS1uT
X-Gm-Gg: AeBDiesG4ob4f7VrSUiJYKOJdSLNeguNRT7wgoN2HwppXoVy3AP6yX0S78KmSZqf9G/
	W7AjmpF1nmPqOya8y0UrBAXabYMEVNnKF3kfXFGL6mSqOhwANHdGq//QV5HfeFP5GK2pAuCGfv5
	jsCV7C2siOv4vbwmlUxb9k3T9a1CUAV/It77iJd1tPGNsN5qOt8glFmoCSvm/CGR/dUcGp3IQyq
	KHlSoPtN9x6FOT9uko5CkV17bb7WZjWQsyeq1Qoiq0I9UWy/7nld1A8lHvH1XWyNE5VxsVBBUUh
	Zbka1pe8vcf1YZvPm0sfYQD4qfhOKyEGx5O8iMEVOFXFwwjcXf42DzyYcH4UFHUKO1h0J8WvmWt
	WB7qFWmOo/+u1YUk5m1R1U1E1RSaY/VZEjX9EpBpxW/VWxXH80N3eaExpdQ52+XSJgVklnNPvMG
	TUwErxEeR38BxNGue4D2gfv/cod1vNGtM3J2WI+/sCTz4F2b7GMEsR6wE=
X-Received: by 2002:a05:6808:1a2a:b0:479:eb0e:670a with SMTP id 5614622812f47-47d365dc22dmr1986221b6e.29.1777995558176;
        Tue, 05 May 2026 08:39:18 -0700 (PDT)
Received: from localhost ([2a03:2880:10ff:6::])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-47c769ca2a6sm8651987b6e.18.2026.05.05.08.39.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 May 2026 08:39:16 -0700 (PDT)
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
	riel@surriel.com,
	haowenchao22@gmail.com
Subject: [PATCH v6 09/22] mm: swap: allocate a virtual swap slot for each swapped out page
Date: Tue,  5 May 2026 08:38:38 -0700
Message-ID: <20260505153854.1612033-10-nphamcs@gmail.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260505153854.1612033-1-nphamcs@gmail.com>
References: <20260505153854.1612033-1-nphamcs@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: ii1oe6q8dggget94bapi3wiugwiaen68
X-Rspam-User: 
X-Rspamd-Queue-Id: 9FCA3C0002
X-Rspamd-Server: rspam07
X-HE-Tag: 1777995559-281426
X-HE-Meta: U2FsdGVkX1/E79e0UmYtkEIvbHXGIPpuAdFvLchf5EfpuFdStTlo8maGdDxBAw0l348vBv//Dx5X7gwNoL4q3cJoRSBw5vy6fOPihBw1/GMq3aeVsZmGE4Xt8gITKnGNMQjeurcPFiJ/h1FkiDfChiYZwuGYGOsmcwVFcvG3fBCKHpCpQgllBjn5wVTh7L3jxIm5/Pqq1VOlNbammr7PCBZ1KYkbq9yVeit7aUqF9gje7w8j8wyFNYjVCZRqRQ7ZillmxbHdAw0qoVlDLVHkgmn8nBYtE1JgGriFucqming0+ScvVC1mMkUYpd8PAOHQao0K4jfB6Kklxi/nxxoBIJRDyr1q9EJhaMr1kKYf+kAne3cEOaQg6nAU3UvV0Ht9HbN36J5l6HKXzR505mH4PyqPu8ahkVC8VsPrvuSFBE+1ft0cO8xzGhyXW3hpzx/TS0uLb08SArUW8m2wNAANLRdBZE7jDuPis4e7HkkgJxMCvArPjwChPqTIiy7VUfbLM7X34tHAgeaQ6hqySVlQAvul5Ja8q7OczFEBUhi0aQorGRXryPYPUTij1+dB1cje/HRv3zfCpLqyk4en9nBsWfrRQy2RZzHdTkONYaH0snHLdnP73iMkCjJcEIKfkgrACXZ6FmXrJPwWk/jdgdqaFGfDQvEUWfRJelxg9FnlN72ibU6yBwwyLuHtJnp6KqFaAy4VxcHHXX4MVn9LsW82dM64K0bwjfUkqYfhDya3z1+sXaHHgN0DmMz+5TZ/ybLSsYQEmfARbrfotSOs8iZ3qNsWxKevcMfEVZo0g+/y6LnmpeTFaMZpdYql3zAzd6+lUsQQ3VG6RcqbPYlFOxaX4IO4HP6G39lTJJb/I+tkIm90VrXjCCguhkTr96nOmmHix2x1szUQ64pDMLlthcfdSdyQ9ulKHJdA1hUrqFeBvh03FdklfaLUXnJWf5XOc3OR805GL+FRTddXzEPAX4s
 qdnbse+/
 hH9E/3TDjtc4owMPNJPvZW8GeWz3qQedm33AGdhWOSrB+sw5U3fXM9E3iu7rTbugx3cCg3gafSTtTaV/0BB/a5ucf162xXMpAZu3c8KW0jjruehADTBre09cNQt2wVss+ZiW3hByWcfltqppU6N/qs3xfnzLlPEwlU5wPGdJ/1q8l57uHpjk+MYizTPyTeAe3cWJbl1wpCTnkASAv1waeveYG65ukyTQWNzFutkMBx/lt6GXM2eJtg6WcQpX+vHfNX4aCAFf0+VtnmIA4Asd2T8dGmxviFSXtBIVq3QvttGt6fp9ToB4eW/yDtex5+zCMvDdh/nB2NMCV9zx8tzgfOsxFpkYXM4msKwWhN8FA4IlUwCph0g+xsN9cBmjPrAs65fgpp5cVsXdu15E3yTE7WnfaCNO4WXwcppVhaPiiHtMw/X8A7HuixPfJjBikGTN40opHCiCYmP1HYPFobiXQKXX2ijcDZtxk1QbbTOzUp33g17qKkdTR75ivub67U+Pksm7A+a/PhiL1knVkEsyHtFv7o6PpAhyDhO6z
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

For the new virtual swap space design, dynamically allocate a virtual
slot (as well as an associated metadata structure) for each swapped out
page, and associate it to the (physical) swap slot on the swapfile/swap
partition. This virtual swap slot is now stored in page table entries
and used to index into swap data structures (swap cache, zswap tree,
swap cgroup array), in place of the old physical swap slot.

For now, there is always a physical slot in the swapfile associated for
each virtual swap slot (except those about to be freed). The virtual
swap slot's lifetime is still tied to the lifetime of its physical swap
slot. We do change the freeing ordering a bit - we clear the shadow,
invalidate the zswap entry, and uncharge swap cgroup when we release the
virtual swap slot, as we now use virtual swap slot to index into these
swap data structures.

We also repurpose the swap table infrastructure as a reverse map to look
up the virtual swap slot from its associated physical swap slot on
swapfile. This is used in cluster readahead, as well as several swapfile
operations, such as the swap slot reclamation that happens when the
swapfile is almost full.  It will also be used in a future patch that
simplifies swapoff.

Signed-off-by: Nhat Pham <nphamcs@gmail.com>
---
 include/linux/cpuhotplug.h |   1 +
 include/linux/swap.h       |  72 ++--
 mm/internal.h              |  28 +-
 mm/page_io.c               |   6 +-
 mm/shmem.c                 |   9 +-
 mm/swap.h                  |   8 +-
 mm/swap_state.c            |   5 +-
 mm/swapfile.c              |  64 +---
 mm/vswap.c                 | 683 +++++++++++++++++++++++++++++++++++++
 9 files changed, 759 insertions(+), 117 deletions(-)

diff --git a/include/linux/cpuhotplug.h b/include/linux/cpuhotplug.h
index 62cd7b35a29c..85cb45022e79 100644
--- a/include/linux/cpuhotplug.h
+++ b/include/linux/cpuhotplug.h
@@ -86,6 +86,7 @@ enum cpuhp_state {
 	CPUHP_FS_BUFF_DEAD,
 	CPUHP_PRINTK_DEAD,
 	CPUHP_MM_MEMCQ_DEAD,
+	CPUHP_MM_VSWAP_DEAD,
 	CPUHP_PERCPU_CNT_DEAD,
 	CPUHP_RADIX_DEAD,
 	CPUHP_PAGE_ALLOC,
diff --git a/include/linux/swap.h b/include/linux/swap.h
index df0771903a95..940f467f2af1 100644
--- a/include/linux/swap.h
+++ b/include/linux/swap.h
@@ -425,6 +425,12 @@ extern void __meminit kswapd_stop(int nid);
 
 /* Virtual swap space API (mm/vswap.c) */
 int vswap_init(void);
+void vswap_exit(void);
+void vswap_free(swp_entry_t entry, struct swap_cluster_info *ci);
+swp_slot_t swp_entry_to_swp_slot(swp_entry_t entry);
+swp_entry_t swp_slot_to_swp_entry(swp_slot_t slot);
+bool tryget_swap_entry(swp_entry_t entry, struct swap_info_struct **si);
+void put_swap_entry(swp_entry_t entry, struct swap_info_struct *si);
 
 /* Lifecycle swap API (mm/swapfile.c) */
 int folio_alloc_swap(struct folio *folio);
@@ -474,6 +480,7 @@ static inline long get_nr_swap_pages(void)
 }
 
 void si_swapinfo(struct sysinfo *);
+int swap_slot_alloc(swp_slot_t *slot, unsigned int order);
 swp_slot_t swap_slot_alloc_of_type(int);
 int add_swap_count_continuation(swp_entry_t, gfp_t);
 int swap_type_of(dev_t device, sector_t offset);
@@ -499,6 +506,29 @@ static inline void swap_slot_put_swap_info(struct swap_info_struct *si)
 {
 }
 
+static inline swp_slot_t swp_entry_to_swp_slot(swp_entry_t entry)
+{
+	swp_slot_t ret = { .val = 0 };
+	return ret;
+}
+
+static inline swp_entry_t swp_slot_to_swp_entry(swp_slot_t slot)
+{
+	swp_entry_t ret = { .val = 0 };
+	return ret;
+}
+
+static inline bool tryget_swap_entry(swp_entry_t entry,
+				     struct swap_info_struct **si)
+{
+	return false;
+}
+
+static inline void put_swap_entry(swp_entry_t entry,
+				  struct swap_info_struct *si)
+{
+}
+
 #define get_nr_swap_pages()			0L
 #define total_swap_pages			0L
 #define total_swapcache_pages()			0UL
@@ -672,47 +702,5 @@ static inline bool mem_cgroup_swap_full(struct folio *folio)
 }
 #endif
 
-/**
- * swp_entry_to_swp_slot - look up the physical swap slot corresponding to a
- *                         virtual swap slot.
- * @entry: the virtual swap slot.
- *
- * Return: the physical swap slot corresponding to the virtual swap slot.
- */
-static inline swp_slot_t swp_entry_to_swp_slot(swp_entry_t entry)
-{
-	return (swp_slot_t) { entry.val };
-}
-
-/**
- * swp_slot_to_swp_entry - look up the virtual swap slot corresponding to a
- *                         physical swap slot.
- * @slot: the physical swap slot.
- *
- * Return: the virtual swap slot corresponding to the physical swap slot.
- */
-static inline swp_entry_t swp_slot_to_swp_entry(swp_slot_t slot)
-{
-	return (swp_entry_t) { slot.val };
-}
-
-static inline bool tryget_swap_entry(swp_entry_t entry,
-				struct swap_info_struct **sip)
-{
-	swp_slot_t slot = swp_entry_to_swp_slot(entry);
-	struct swap_info_struct *si = swap_slot_tryget_swap_info(slot);
-
-	if (sip)
-		*sip = si;
-
-	return si;
-}
-
-static inline void put_swap_entry(swp_entry_t entry,
-				struct swap_info_struct *si)
-{
-	swap_slot_put_swap_info(si);
-}
-
 #endif /* __KERNEL__*/
 #endif /* _LINUX_SWAP_H */
diff --git a/mm/internal.h b/mm/internal.h
index e739e8cac5b5..7ced0def684c 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -322,6 +322,25 @@ static inline unsigned int folio_pte_batch_flags(struct folio *folio,
 unsigned int folio_pte_batch(struct folio *folio, pte_t *ptep, pte_t pte,
 		unsigned int max_nr);
 
+static inline swp_entry_t swap_nth(swp_entry_t entry, long n)
+{
+	return (swp_entry_t) { entry.val + n };
+}
+
+/* similar to swap_nth, but check the backing physical slots as well. */
+static inline swp_entry_t swap_move(swp_entry_t entry, long delta)
+{
+	swp_slot_t slot = swp_entry_to_swp_slot(entry), next_slot;
+	swp_entry_t next_entry = swap_nth(entry, delta);
+
+	next_slot = swp_entry_to_swp_slot(next_entry);
+	if (swp_slot_type(slot) != swp_slot_type(next_slot) ||
+			swp_slot_offset(slot) + delta != swp_slot_offset(next_slot))
+		next_entry.val = 0;
+
+	return next_entry;
+}
+
 /**
  * pte_move_swp_offset - Move the swap entry offset field of a swap pte
  *	 forward or backward by delta
@@ -334,13 +353,8 @@ unsigned int folio_pte_batch(struct folio *folio, pte_t *ptep, pte_t pte,
  */
 static inline pte_t pte_move_swp_offset(pte_t pte, long delta)
 {
-	softleaf_t entry = softleaf_from_pte(pte), new_entry;
-	swp_slot_t slot = swp_entry_to_swp_slot(entry);
-	pte_t new;
-
-	new_entry = swp_slot_to_swp_entry(swp_slot(swp_slot_type(slot),
-			swp_slot_offset(slot) + delta));
-	new = swp_entry_to_pte(new_entry);
+	softleaf_t entry = softleaf_from_pte(pte);
+	pte_t new = swp_entry_to_pte(swap_move(entry, delta));
 
 	if (pte_swp_soft_dirty(pte))
 		new = pte_swp_mksoft_dirty(new);
diff --git a/mm/page_io.c b/mm/page_io.c
index 0b02bcc85e2a..5de370557295 100644
--- a/mm/page_io.c
+++ b/mm/page_io.c
@@ -364,7 +364,7 @@ static void sio_write_complete(struct kiocb *iocb, long ret)
 		 */
 		pr_err_ratelimited("Write error %ld on dio swapfile (%llu)\n",
 				   ret,
-				   swap_slot_pos(swp_entry_to_swp_slot(page_swap_entry(page))));
+				   swap_slot_dev_pos(swp_entry_to_swp_slot(page_swap_entry(page))));
 		for (p = 0; p < sio->pages; p++) {
 			page = sio->bvec[p].bv_page;
 			set_page_dirty(page);
@@ -384,7 +384,7 @@ static void swap_writepage_fs(struct folio *folio, struct swap_iocb **swap_plug)
 	swp_slot_t slot = swp_entry_to_swp_slot(folio->swap);
 	struct swap_info_struct *sis = __swap_slot_to_info(slot);
 	struct file *swap_file = sis->swap_file;
-	loff_t pos = swap_slot_pos(slot);
+	loff_t pos = swap_slot_dev_pos(slot);
 
 	count_swpout_vm_event(folio);
 	folio_start_writeback(folio);
@@ -549,7 +549,7 @@ static void swap_read_folio_fs(struct folio *folio, struct swap_iocb **plug)
 	swp_slot_t slot = swp_entry_to_swp_slot(folio->swap);
 	struct swap_info_struct *sis = __swap_slot_to_info(slot);
 	struct swap_iocb *sio = NULL;
-	loff_t pos = swap_slot_pos(slot);
+	loff_t pos = swap_slot_dev_pos(slot);
 
 	if (plug)
 		sio = *plug;
diff --git a/mm/shmem.c b/mm/shmem.c
index 400e2fa8e77c..13f7469a04c8 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -2227,7 +2227,6 @@ static int shmem_split_large_entry(struct inode *inode, pgoff_t index,
 	XA_STATE_ORDER(xas, &mapping->i_pages, index, 0);
 	int split_order = 0;
 	int i;
-	swp_slot_t slot = swp_entry_to_swp_slot(swap);
 
 	/* Convert user data gfp flags to xarray node gfp flags */
 	gfp &= GFP_RECLAIM_MASK;
@@ -2268,13 +2267,7 @@ static int shmem_split_large_entry(struct inode *inode, pgoff_t index,
 			 */
 			for (i = 0; i < 1 << cur_order;
 			     i += (1 << split_order)) {
-				swp_entry_t tmp_entry;
-				swp_slot_t tmp_slot;
-
-				tmp_slot =
-					swp_slot(swp_slot_type(slot),
-						swp_slot_offset(slot) + swap_offset + i);
-				tmp_entry = swp_slot_to_swp_entry(tmp_slot);
+				swp_entry_t tmp_entry = swap_nth(swap, swap_offset + i);
 
 				__xa_store(&mapping->i_pages, aligned_index + i,
 					   swp_to_radix_entry(tmp_entry), 0);
diff --git a/mm/swap.h b/mm/swap.h
index 238d96869432..e8fac77a6e4c 100644
--- a/mm/swap.h
+++ b/mm/swap.h
@@ -36,7 +36,11 @@ struct swap_cluster_info {
 	u16 count;
 	u8 flags;
 	u8 order;
-	atomic_long_t __rcu *table;	/* Swap table entries, see mm/swap_table.h */
+	/*
+	 * Reverse map, to look up the virtual swap slot backed by a given physical
+	 * swap slot.
+	 */
+	atomic_long_t __rcu *table;
 	struct list_head list;
 };
 
@@ -154,7 +158,7 @@ static inline struct address_space *swap_address_space(swp_entry_t entry)
 }
 
 /* Return the swap device position of the swap slot. */
-static inline loff_t swap_slot_pos(swp_slot_t slot)
+static inline loff_t swap_slot_dev_pos(swp_slot_t slot)
 {
 	return ((loff_t)swp_slot_offset(slot)) << PAGE_SHIFT;
 }
diff --git a/mm/swap_state.c b/mm/swap_state.c
index fca17e7e7ae6..69303e949862 100644
--- a/mm/swap_state.c
+++ b/mm/swap_state.c
@@ -892,7 +892,8 @@ static int __init swap_init(void)
 	swap_kobj = kobject_create_and_add("swap", mm_kobj);
 	if (!swap_kobj) {
 		pr_err("failed to create swap kobject\n");
-		return -ENOMEM;
+		err = -ENOMEM;
+		goto vswap_exit;
 	}
 	err = sysfs_create_group(swap_kobj, &swap_attr_group);
 	if (err) {
@@ -905,6 +906,8 @@ static int __init swap_init(void)
 
 delete_obj:
 	kobject_put(swap_kobj);
+vswap_exit:
+	vswap_exit();
 	return err;
 }
 subsys_initcall(swap_init);
diff --git a/mm/swapfile.c b/mm/swapfile.c
index 0372062743ef..a47e024f2152 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -1249,7 +1249,6 @@ static void swap_range_alloc(struct swap_info_struct *si,
 static void swap_range_free(struct swap_info_struct *si, unsigned long offset,
 			    unsigned int nr_entries)
 {
-	unsigned long begin = offset;
 	unsigned long end = offset + nr_entries - 1;
 	void (*swap_slot_free_notify)(struct block_device *, unsigned long);
 	unsigned int i;
@@ -1258,10 +1257,8 @@ static void swap_range_free(struct swap_info_struct *si, unsigned long offset,
 	 * Use atomic clear_bit operations only on zeromap instead of non-atomic
 	 * bitmap_clear to prevent adjacent bits corruption due to simultaneous writes.
 	 */
-	for (i = 0; i < nr_entries; i++) {
+	for (i = 0; i < nr_entries; i++)
 		clear_bit(offset + i, si->zeromap);
-		zswap_invalidate(swp_slot_to_swp_entry(swp_slot(si->type, offset + i)));
-	}
 
 	if (si->flags & SWP_BLKDEV)
 		swap_slot_free_notify =
@@ -1274,7 +1271,6 @@ static void swap_range_free(struct swap_info_struct *si, unsigned long offset,
 			swap_slot_free_notify(si->bdev, offset);
 		offset++;
 	}
-	swap_cache_clear_shadow(swp_entry(si->type, begin), nr_entries);
 
 	/*
 	 * Make sure that try_to_unuse() observes si->inuse_pages reaching 0
@@ -1405,7 +1401,7 @@ static bool swap_sync_discard(void)
 	return false;
 }
 
-static int swap_slot_alloc(swp_slot_t *slot, unsigned int order)
+int swap_slot_alloc(swp_slot_t *slot, unsigned int order)
 {
 	unsigned int size = 1 << order;
 
@@ -1438,56 +1434,10 @@ static int swap_slot_alloc(swp_slot_t *slot, unsigned int order)
 			goto again;
 	}
 
-	return 0;
-}
-
-/**
- * folio_alloc_swap - allocate swap space for a folio
- * @folio: folio we want to move to swap
- *
- * Allocate swap space for the folio and add the folio to the
- * swap cache.
- *
- * Context: Caller needs to hold the folio lock.
- * Return: Whether the folio was added to the swap cache.
- */
-int folio_alloc_swap(struct folio *folio)
-{
-	unsigned int order = folio_order(folio);
-	swp_slot_t slot = { 0 };
-	swp_entry_t entry = {};
-	int err = 0, ret;
-
-	VM_BUG_ON_FOLIO(!folio_test_locked(folio), folio);
-	VM_BUG_ON_FOLIO(!folio_test_uptodate(folio), folio);
-
-	ret = swap_slot_alloc(&slot, order);
-	if (ret)
-		return ret;
-
-	/* XXX: for now, physical and virtual swap slots are identical */
-	entry.val = slot.val;
-
-	/* Need to call this even if allocation failed, for MEMCG_SWAP_FAIL. */
-	if (mem_cgroup_try_charge_swap(folio, entry)) {
-		err = -ENOMEM;
-		goto out_free;
-	}
-
-	if (!slot.val)
+	if (!slot->val)
 		return -ENOMEM;
 
-	err = swap_cache_add_folio(folio, entry,
-				   __GFP_HIGH | __GFP_NOMEMALLOC | __GFP_NOWARN,
-				   NULL);
-	if (err)
-		goto out_free;
-
 	return 0;
-
-out_free:
-	put_swap_folio(folio, entry);
-	return err;
 }
 
 static struct swap_info_struct *_swap_info_get(swp_slot_t slot)
@@ -1735,6 +1685,13 @@ static void swap_slots_free(struct swap_info_struct *si,
 	unsigned char *map = si->swap_map + offset;
 	unsigned char *map_end = map + nr_pages;
 	swp_entry_t entry = swp_slot_to_swp_entry(slot);
+	int i;
+
+	/* release all the associated (virtual) swap slots */
+	for (i = 0; i < nr_pages; i++) {
+		vswap_free(entry, ci);
+		entry.val++;
+	}
 
 	/* It should never free entries across different clusters */
 	VM_BUG_ON(ci != __swap_offset_to_cluster(si, offset + nr_pages - 1));
@@ -1747,7 +1704,6 @@ static void swap_slots_free(struct swap_info_struct *si,
 		*map = 0;
 	} while (++map < map_end);
 
-	mem_cgroup_uncharge_swap(entry, nr_pages);
 	swap_range_free(si, offset, nr_pages);
 
 	if (!ci->count)
diff --git a/mm/vswap.c b/mm/vswap.c
index e68234f053fc..f28ca2517c10 100644
--- a/mm/vswap.c
+++ b/mm/vswap.c
@@ -4,7 +4,149 @@
  *
  * Copyright (C) 2024 Meta Platforms, Inc., Nhat Pham
  */
+#include <linux/mm.h>
+#include <linux/gfp.h>
 #include <linux/swap.h>
+#include <linux/swapops.h>
+#include <linux/swap_cgroup.h>
+#include <linux/cpuhotplug.h>
+#include <linux/vmalloc.h>
+#include "swap.h"
+#include "swap_table.h"
+
+/*
+ * Virtual Swap Space
+ *
+ * We associate with each swapped out page a virtual swap slot. This will allow
+ * us to change the backing state of a swapped out page without having to
+ * update every single page table entries referring to it.
+ *
+ * For now, there is a one-to-one correspondence between a virtual swap slot
+ * and its associated physical swap slot.
+ *
+ * Virtual swap slots are organized into PMD-sized clusters, analogous to
+ * physical swap allocator. However, unlike the physical swap allocator,
+ * the clusters are dynamically allocated and freed on-demand. There is no
+ * "free list" of virtual swap clusters - new free clusters are allocated
+ * directly from the cluster map xarray.
+ *
+ * This allows us to avoid the overhead of pre-allocating a large number of
+ * virtual swap clusters.
+ */
+
+/**
+ * Swap descriptor - metadata of a swapped out page.
+ *
+ * @slot: The handle to the physical swap slot backing this page.
+ */
+struct swp_desc {
+	swp_slot_t slot;
+};
+
+#define VSWAP_CLUSTER_SHIFT HPAGE_PMD_ORDER
+#define VSWAP_CLUSTER_SIZE (1UL << VSWAP_CLUSTER_SHIFT)
+#define VSWAP_CLUSTER_MASK (VSWAP_CLUSTER_SIZE - 1)
+
+/*
+ * Map from a cluster id to the number of allocated virtual swap slots in the
+ * (PMD-sized) cluster. This allows us to quickly allocate an empty cluster
+ * for a large folio being swapped out.
+ *
+ * This xarray's lock is also used as the "global" allocator lock (for e.g, to
+ * synchronize global cluster lists manipulation).
+ */
+static struct kmem_cache *vswap_cluster_cache;
+static DEFINE_XARRAY_FLAGS(vswap_cluster_map, XA_FLAGS_TRACK_FREE);
+
+#if SWP_TYPE_SHIFT > 32
+/*
+ * In 64 bit architecture, the maximum number of virtual swap slots is capped
+ * by the number of clusters (as the vswap_cluster_map xarray can only allocate
+ * up to U32 clusters).
+ */
+#define MAX_VSWAP	\
+	(((unsigned long)U32_MAX << VSWAP_CLUSTER_SHIFT) + (VSWAP_CLUSTER_SIZE - 1))
+#else
+/*
+ * In 32 bit architecture, just make sure the range of virtual swap slots is
+ * the same as the range of physical swap slots.
+ */
+#define MAX_VSWAP	(((MAX_SWAPFILES - 1) << SWP_TYPE_SHIFT) | SWP_OFFSET_MASK)
+#endif
+
+static const struct xa_limit vswap_cluster_map_limit = {
+	.max = MAX_VSWAP >> VSWAP_CLUSTER_SHIFT,
+	.min = 0,
+};
+
+static struct list_head partial_clusters_lists[SWAP_NR_ORDERS];
+
+/**
+ * struct vswap_cluster
+ *
+ * @lock: Spinlock protecting the cluster's data
+ * @rcu: RCU head for deferred freeing when the cluster is no longer in use
+ * @list: List entry for tracking in partial_clusters_lists when not fully allocated
+ * @id: Unique identifier for this cluster, used to calculate swap slot values
+ * @count: Number of allocated virtual swap slots in this cluster
+ * @order: Order of allocation (0 for single pages, higher for contiguous ranges)
+ * @cached: Whether this cluster is cached in a per-CPU variable for fast allocation
+ * @full: Whether this cluster is considered full (no more allocations possible)
+ * @refcnt: Reference count tracking usage of slots in this cluster
+ * @bitmap: Bitmap tracking which slots in the cluster are allocated
+ * @descriptors: Array of swap descriptors for each slot in the cluster
+ *
+ * A vswap_cluster manages a PMD-sized group of contiguous virtual swap slots.
+ * It tracks which slots are allocated using a bitmap and maintains the
+ * swap descriptors in an array. The cluster is reference-counted and freed when
+ * all of its slots are released and the cluster is not cached. Each cluster
+ * only allocates aligned slots of a single order, determined when the cluster is
+ * allocated (and never change for the entire lifetime of the cluster).
+ *
+ * Clusters can be in the following states:
+ * - Cached in per-CPU variables for fast allocation.
+ * - In partial_clusters_lists when partially allocated but not cached.
+ * - Marked as full when no more allocations are possible.
+ */
+struct vswap_cluster {
+	spinlock_t lock;
+	union {
+		struct rcu_head rcu;
+		struct list_head list;
+	};
+	unsigned long id;
+	unsigned int count:VSWAP_CLUSTER_SHIFT + 1;
+	unsigned int order:4;
+	bool cached:1;
+	bool full:1;
+	refcount_t refcnt;
+	DECLARE_BITMAP(bitmap, VSWAP_CLUSTER_SIZE);
+	struct swp_desc *descriptors;
+};
+
+#define VSWAP_VAL_CLUSTER_IDX(val) ((val) >> VSWAP_CLUSTER_SHIFT)
+#define VSWAP_CLUSTER_IDX(entry) VSWAP_VAL_CLUSTER_IDX(entry.val)
+#define VSWAP_IDX_WITHIN_CLUSTER_VAL(val) ((val) & VSWAP_CLUSTER_MASK)
+#define VSWAP_IDX_WITHIN_CLUSTER(entry)	VSWAP_IDX_WITHIN_CLUSTER_VAL(entry.val)
+
+struct percpu_vswap_cluster {
+	struct vswap_cluster *clusters[SWAP_NR_ORDERS];
+	local_lock_t lock;
+};
+
+/*
+ * Per-CPU cache of the last allocated cluster for each order. This allows
+ * allocation fast path to skip the global vswap_cluster_map's spinlock, if
+ * the locally cached cluster still has free slots. Note that caching a cluster
+ * also increments its reference count.
+ */
+static DEFINE_PER_CPU(struct percpu_vswap_cluster, percpu_vswap_cluster) = {
+	.clusters = { NULL, },
+	.lock = INIT_LOCAL_LOCK(),
+};
+
+static atomic_t vswap_alloc_reject;
+static atomic_t vswap_used;
 
 #ifdef CONFIG_DEBUG_FS
 #include <linux/debugfs.h>
@@ -17,6 +159,10 @@ static int vswap_debug_fs_init(void)
 		return -ENODEV;
 
 	vswap_debugfs_root = debugfs_create_dir("vswap", NULL);
+	debugfs_create_atomic_t("alloc_reject", 0444,
+		vswap_debugfs_root, &vswap_alloc_reject);
+	debugfs_create_atomic_t("used", 0444, vswap_debugfs_root, &vswap_used);
+
 	return 0;
 }
 #else
@@ -26,10 +172,547 @@ static int vswap_debug_fs_init(void)
 }
 #endif
 
+static struct swp_desc *vswap_iter(struct vswap_cluster **clusterp, unsigned long i)
+{
+	unsigned long cluster_id = VSWAP_VAL_CLUSTER_IDX(i);
+	struct vswap_cluster *cluster = *clusterp;
+	struct swp_desc *desc = NULL;
+	unsigned long slot_index;
+
+	if (!cluster || cluster_id != cluster->id) {
+		if (cluster)
+			spin_unlock(&cluster->lock);
+		cluster = xa_load(&vswap_cluster_map, cluster_id);
+		if (!cluster)
+			goto done;
+		VM_WARN_ON(cluster->id != cluster_id);
+		spin_lock(&cluster->lock);
+	}
+
+	slot_index = VSWAP_IDX_WITHIN_CLUSTER_VAL(i);
+	if (test_bit(slot_index, cluster->bitmap))
+		desc = &cluster->descriptors[slot_index];
+
+	if (!desc) {
+		spin_unlock(&cluster->lock);
+		cluster = NULL;
+	}
+
+done:
+	*clusterp = cluster;
+	return desc;
+}
+
+static bool cluster_is_alloc_candidate(struct vswap_cluster *cluster)
+{
+	return cluster->count + (1 << (cluster->order)) <= VSWAP_CLUSTER_SIZE;
+}
+
+static void __vswap_alloc_from_cluster(struct vswap_cluster *cluster, int start)
+{
+	int i, nr = 1 << cluster->order;
+	struct swp_desc *desc;
+
+	for (i = 0; i < nr; i++) {
+		desc = &cluster->descriptors[start + i];
+		desc->slot.val = 0;
+	}
+	cluster->count += nr;
+}
+
+static unsigned long vswap_alloc_from_cluster(struct vswap_cluster *cluster)
+{
+	int nr = 1 << cluster->order;
+	unsigned long i = cluster->id ? 0 : nr;
+
+	lockdep_assert_held(&cluster->lock);
+	if (!cluster_is_alloc_candidate(cluster))
+		return 0;
+
+	/* Find the first free range of nr contiguous aligned slots */
+	i = bitmap_find_next_zero_area(cluster->bitmap,
+			VSWAP_CLUSTER_SIZE, i, nr, nr - 1);
+	if (i >= VSWAP_CLUSTER_SIZE)
+		return 0;
+
+	/* Mark the range as allocated in the bitmap */
+	bitmap_set(cluster->bitmap, i, nr);
+
+	refcount_add(nr, &cluster->refcnt);
+	__vswap_alloc_from_cluster(cluster, i);
+	return i + (cluster->id << VSWAP_CLUSTER_SHIFT);
+}
+
+/* Allocate a contiguous range of virtual swap slots */
+static swp_entry_t vswap_alloc(int order)
+{
+	struct xa_limit limit = vswap_cluster_map_limit;
+	struct vswap_cluster *local, *cluster;
+	int nr = 1 << order;
+	bool need_caching = true;
+	u32 cluster_id;
+	swp_entry_t entry;
+
+	entry.val = 0;
+
+	/* first, let's try the locally cached cluster */
+	rcu_read_lock();
+	local_lock(&percpu_vswap_cluster.lock);
+	cluster = this_cpu_read(percpu_vswap_cluster.clusters[order]);
+	if (cluster) {
+		spin_lock(&cluster->lock);
+		entry.val = vswap_alloc_from_cluster(cluster);
+		need_caching = !entry.val;
+
+		if (!entry.val || !cluster_is_alloc_candidate(cluster)) {
+			this_cpu_write(percpu_vswap_cluster.clusters[order], NULL);
+			cluster->cached = false;
+			refcount_dec(&cluster->refcnt);
+			cluster->full = true;
+		}
+		spin_unlock(&cluster->lock);
+	}
+	local_unlock(&percpu_vswap_cluster.lock);
+	rcu_read_unlock();
+
+	/*
+	 * Local cluster does not have space. Let's try the uncached partial
+	 * clusters before acquiring a new free cluster to reduce fragmentation,
+	 * and avoid having to allocate a new cluster structure.
+	 */
+	if (!entry.val) {
+		cluster = NULL;
+		xa_lock(&vswap_cluster_map);
+		list_for_each_entry_safe(cluster, local,
+				&partial_clusters_lists[order], list) {
+			if (!spin_trylock(&cluster->lock))
+				continue;
+
+			entry.val = vswap_alloc_from_cluster(cluster);
+			list_del_init(&cluster->list);
+			cluster->full = !entry.val || !cluster_is_alloc_candidate(cluster);
+			need_caching = !cluster->full;
+			spin_unlock(&cluster->lock);
+			if (entry.val)
+				break;
+		}
+		xa_unlock(&vswap_cluster_map);
+	}
+
+	/* try a new free cluster */
+	if (!entry.val) {
+		cluster = kmem_cache_zalloc(vswap_cluster_cache, GFP_KERNEL);
+		if (cluster) {
+			cluster->descriptors = vzalloc(array_size(VSWAP_CLUSTER_SIZE,
+						sizeof(struct swp_desc)));
+			if (!cluster->descriptors) {
+				kmem_cache_free(vswap_cluster_cache, cluster);
+				cluster = NULL;
+			}
+		}
+		if (cluster) {
+			/* first cluster cannot allocate a PMD-sized THP */
+			if (order == SWAP_NR_ORDERS - 1)
+				limit.min = 1;
+
+			if (!xa_alloc(&vswap_cluster_map, &cluster_id, cluster, limit,
+						GFP_KERNEL)) {
+				spin_lock_init(&cluster->lock);
+				cluster->id = cluster_id;
+				cluster->order = order;
+				INIT_LIST_HEAD(&cluster->list);
+				/* Initialize bitmap to all zeros (all slots free) */
+				bitmap_zero(cluster->bitmap, VSWAP_CLUSTER_SIZE);
+				entry.val = cluster->id << VSWAP_CLUSTER_SHIFT;
+				refcount_set(&cluster->refcnt, nr);
+				if (!cluster_id)
+					entry.val += nr;
+				__vswap_alloc_from_cluster(cluster,
+					(entry.val & VSWAP_CLUSTER_MASK));
+				/* Mark the allocated range in the bitmap */
+				bitmap_set(cluster->bitmap, (entry.val & VSWAP_CLUSTER_MASK), nr);
+				need_caching = cluster_is_alloc_candidate(cluster);
+			} else {
+				/* Failed to insert into cluster map, free the cluster */
+				vfree(cluster->descriptors);
+				kmem_cache_free(vswap_cluster_cache, cluster);
+				cluster = NULL;
+			}
+		}
+	}
+
+	if (need_caching && entry.val) {
+		local_lock(&percpu_vswap_cluster.lock);
+		local = this_cpu_read(percpu_vswap_cluster.clusters[order]);
+		if (local != cluster) {
+			if (local) {
+				spin_lock(&local->lock);
+				/* only update the local cache if cached cluster is full */
+				need_caching = !cluster_is_alloc_candidate(local);
+				if (need_caching) {
+					this_cpu_write(percpu_vswap_cluster.clusters[order], NULL);
+					local->cached = false;
+					refcount_dec(&local->refcnt);
+				}
+				spin_unlock(&local->lock);
+			}
+
+			VM_WARN_ON(!cluster);
+			spin_lock(&cluster->lock);
+			if (cluster_is_alloc_candidate(cluster)) {
+				if (need_caching) {
+					this_cpu_write(percpu_vswap_cluster.clusters[order],
+					       cluster);
+					refcount_inc(&cluster->refcnt);
+					cluster->cached = true;
+				} else {
+					xa_lock(&vswap_cluster_map);
+					VM_WARN_ON(!list_empty(&cluster->list));
+					list_add(&cluster->list, &partial_clusters_lists[order]);
+					xa_unlock(&vswap_cluster_map);
+				}
+			}
+			spin_unlock(&cluster->lock);
+		}
+		local_unlock(&percpu_vswap_cluster.lock);
+	}
+
+	if (entry.val) {
+		VM_WARN_ON(entry.val + nr - 1 > MAX_VSWAP);
+		atomic_add(nr, &vswap_used);
+	} else {
+		atomic_add(nr, &vswap_alloc_reject);
+	}
+	return entry;
+}
+
+static void vswap_cluster_free_rcu(struct rcu_head *head)
+{
+	struct vswap_cluster *cluster =
+		container_of(head, struct vswap_cluster, rcu);
+	vfree(cluster->descriptors);
+	kmem_cache_free(vswap_cluster_cache, cluster);
+}
+
+static void vswap_cluster_free(struct vswap_cluster *cluster)
+{
+	VM_WARN_ON(cluster->count || cluster->cached);
+	lockdep_assert_held(&cluster->lock);
+	xa_lock(&vswap_cluster_map);
+	list_del_init(&cluster->list);
+	__xa_erase(&vswap_cluster_map, cluster->id);
+	xa_unlock(&vswap_cluster_map);
+	rcu_head_init(&cluster->rcu);
+	call_rcu(&cluster->rcu, vswap_cluster_free_rcu);
+}
+
+static inline void release_vswap_slot(struct vswap_cluster *cluster,
+		unsigned long index)
+{
+	unsigned long slot_index = VSWAP_IDX_WITHIN_CLUSTER_VAL(index);
+
+	lockdep_assert_held(&cluster->lock);
+	cluster->count--;
+
+	bitmap_clear(cluster->bitmap, slot_index, 1);
+
+	/* we only free uncached empty clusters */
+	if (refcount_dec_and_test(&cluster->refcnt))
+		vswap_cluster_free(cluster);
+	else if (cluster->full && cluster_is_alloc_candidate(cluster)) {
+		cluster->full = false;
+		if (!cluster->cached) {
+			xa_lock(&vswap_cluster_map);
+			VM_WARN_ON(!list_empty(&cluster->list));
+			list_add_tail(&cluster->list,
+				&partial_clusters_lists[cluster->order]);
+			xa_unlock(&vswap_cluster_map);
+		}
+	}
+
+	atomic_dec(&vswap_used);
+}
+
+/*
+ * Update the physical-to-virtual swap slot mapping.
+ * Caller must ensure the physical swap slot's cluster is locked.
+ */
+static void vswap_rmap_set(struct swap_cluster_info *ci, swp_slot_t slot,
+			   unsigned long vswap, int nr)
+{
+	atomic_long_t *table;
+	unsigned long slot_offset = swp_slot_offset(slot);
+	unsigned int ci_off = slot_offset % SWAPFILE_CLUSTER;
+	int i;
+
+	table = rcu_dereference_protected(ci->table, lockdep_is_held(&ci->lock));
+	VM_WARN_ON(!table);
+	for (i = 0; i < nr; i++)
+		__swap_table_set(ci, ci_off + i, vswap ? vswap + i : 0);
+}
+
+/**
+ * vswap_free - free a virtual swap slot.
+ * @entry: the virtual swap slot to free
+ * @ci: the physical swap slot's cluster (optional, can be NULL)
+ *
+ * If @ci is NULL, this function is called to clean up a virtual swap entry
+ * when no linkage has been established between physical and virtual swap slots.
+ * If @ci is provided, the caller must ensure it is locked.
+ */
+void vswap_free(swp_entry_t entry, struct swap_cluster_info *ci)
+{
+	struct vswap_cluster *cluster = NULL;
+	struct swp_desc *desc;
+
+	if (!entry.val)
+		return;
+
+	swap_cache_clear_shadow(entry, 1);
+	zswap_invalidate(entry);
+	mem_cgroup_uncharge_swap(entry, 1);
+
+	/* do not immediately erase the virtual slot to prevent its reuse */
+	rcu_read_lock();
+	desc = vswap_iter(&cluster, entry.val);
+	if (!desc) {
+		rcu_read_unlock();
+		return;
+	}
+
+	if (desc->slot.val)
+		vswap_rmap_set(ci, desc->slot, 0, 1);
+
+	/* erase forward mapping and release the virtual slot for reallocation */
+	release_vswap_slot(cluster, entry.val);
+	spin_unlock(&cluster->lock);
+	rcu_read_unlock();
+}
+
+/**
+ * folio_alloc_swap - allocate swap space for a folio.
+ * @folio: the folio.
+ *
+ * Return: 0, if the allocation succeeded, -ENOMEM, if the allocation failed.
+ */
+int folio_alloc_swap(struct folio *folio)
+{
+	struct vswap_cluster *cluster = NULL;
+	struct swap_info_struct *si;
+	struct swap_cluster_info *ci;
+	int i, err, ret, nr = folio_nr_pages(folio), order = folio_order(folio);
+	struct swp_desc *desc;
+	swp_entry_t entry;
+	swp_slot_t slot = { 0 };
+
+	VM_BUG_ON_FOLIO(!folio_test_locked(folio), folio);
+	VM_BUG_ON_FOLIO(!folio_test_uptodate(folio), folio);
+
+	entry = vswap_alloc(folio_order(folio));
+	if (!entry.val)
+		return -ENOMEM;
+
+	/*
+	 * XXX: for now, we always allocate a physical swap slot for each virtual
+	 * swap slot, and their lifetime are coupled. This will change once we
+	 * decouple virtual swap slots from their backing states, and only allocate
+	 * physical swap slots for them on demand (i.e on zswap writeback, or
+	 * fallback from zswap store failure).
+	 */
+	ret = swap_slot_alloc(&slot, order);
+	if (ret || !slot.val) {
+		/* Need to call this even if allocation failed, for MEMCG_SWAP_FAIL. */
+		mem_cgroup_try_charge_swap(folio, (swp_entry_t){0});
+
+		for (i = 0; i < nr; i++)
+			vswap_free((swp_entry_t){entry.val + i}, NULL);
+
+		return ret ? ret : -ENOMEM;
+	}
+
+	/* establish the virtual <-> physical swap slots linkages. */
+	si = __swap_slot_to_info(slot);
+	ci = swap_cluster_lock(si, swp_slot_offset(slot));
+	vswap_rmap_set(ci, slot, entry.val, nr);
+	swap_cluster_unlock(ci);
+
+	rcu_read_lock();
+	for (i = 0; i < nr; i++) {
+		desc = vswap_iter(&cluster, entry.val + i);
+		VM_WARN_ON(!desc);
+
+		desc->slot.val = slot.val + i;
+	}
+	if (cluster)
+		spin_unlock(&cluster->lock);
+	rcu_read_unlock();
+
+	/*
+	 * XXX: for now, we charge towards the memory cgroup's swap limit on virtual
+	 * swap slots allocation. This is acceptable because as noted above, each
+	 * virtual swap slot corresponds to a physical swap slot. Once we have
+	 * decoupled virtual and physical swap slots, we will only charge when we
+	 * actually allocate a physical swap slot.
+	 */
+	if (mem_cgroup_try_charge_swap(folio, entry))
+		goto out_free;
+
+	err = swap_cache_add_folio(folio, entry,
+				   __GFP_HIGH | __GFP_NOMEMALLOC | __GFP_NOWARN,
+				   NULL);
+	if (err)
+		goto out_free;
+
+	return 0;
+
+out_free:
+	put_swap_folio(folio, entry);
+	return -ENOMEM;
+}
+
+/**
+ * swp_entry_to_swp_slot - look up the physical swap slot corresponding to a
+ *                         virtual swap slot.
+ * @entry: the virtual swap slot.
+ *
+ * Return: the physical swap slot corresponding to the virtual swap slot.
+ */
+swp_slot_t swp_entry_to_swp_slot(swp_entry_t entry)
+{
+	struct vswap_cluster *cluster = NULL;
+	struct swp_desc *desc;
+	swp_slot_t slot;
+
+	slot.val = 0;
+	if (!entry.val)
+		return slot;
+
+	rcu_read_lock();
+	desc = vswap_iter(&cluster, entry.val);
+	if (!desc) {
+		rcu_read_unlock();
+		return (swp_slot_t){0};
+	}
+	slot = desc->slot;
+	spin_unlock(&cluster->lock);
+	rcu_read_unlock();
+	return slot;
+}
+
+/**
+ * swp_slot_to_swp_entry - look up the virtual swap slot corresponding to a
+ *                         physical swap slot.
+ * @slot: the physical swap slot.
+ *
+ * Return: the virtual swap slot corresponding to the physical swap slot.
+ */
+swp_entry_t swp_slot_to_swp_entry(swp_slot_t slot)
+{
+	swp_entry_t ret;
+	struct swap_cluster_info *ci;
+	unsigned long offset;
+	unsigned int ci_off;
+
+	ret.val = 0;
+	if (!slot.val)
+		return ret;
+
+	offset = swp_slot_offset(slot);
+	ci_off = offset % SWAPFILE_CLUSTER;
+	ci = __swap_slot_to_cluster(slot);
+
+	ret.val = swap_table_get(ci, ci_off);
+	return ret;
+}
+
+bool tryget_swap_entry(swp_entry_t entry, struct swap_info_struct **si)
+{
+	struct vswap_cluster *cluster;
+	swp_slot_t slot;
+
+	slot = swp_entry_to_swp_slot(entry);
+	*si = swap_slot_tryget_swap_info(slot);
+	if (!*si)
+		return false;
+
+	/*
+	 * Ensure the cluster and its associated data structures (swap cache etc.)
+	 * remain valid.
+	 */
+	rcu_read_lock();
+	cluster = xa_load(&vswap_cluster_map, VSWAP_CLUSTER_IDX(entry));
+	if (!cluster || !refcount_inc_not_zero(&cluster->refcnt)) {
+		rcu_read_unlock();
+		swap_slot_put_swap_info(*si);
+		*si = NULL;
+		return false;
+	}
+	rcu_read_unlock();
+	return true;
+}
+
+void put_swap_entry(swp_entry_t entry, struct swap_info_struct *si)
+{
+	struct vswap_cluster *cluster;
+
+	if (si)
+		swap_slot_put_swap_info(si);
+
+	rcu_read_lock();
+	cluster = xa_load(&vswap_cluster_map, VSWAP_CLUSTER_IDX(entry));
+	spin_lock(&cluster->lock);
+	if (refcount_dec_and_test(&cluster->refcnt))
+		vswap_cluster_free(cluster);
+	spin_unlock(&cluster->lock);
+	rcu_read_unlock();
+}
+
+static int vswap_cpu_dead(unsigned int cpu)
+{
+	struct vswap_cluster *cluster;
+	int order;
+
+	guard(rcu)();
+	for (order = 0; order < SWAP_NR_ORDERS; order++) {
+		cluster = per_cpu(percpu_vswap_cluster.clusters[order], cpu);
+		if (cluster) {
+			per_cpu(percpu_vswap_cluster.clusters[order], cpu) = NULL;
+			spin_lock(&cluster->lock);
+			cluster->cached = false;
+			if (refcount_dec_and_test(&cluster->refcnt))
+				vswap_cluster_free(cluster);
+			spin_unlock(&cluster->lock);
+		}
+	}
+
+	return 0;
+}
+
+
 int vswap_init(void)
 {
+	int i;
+
+	vswap_cluster_cache = KMEM_CACHE(vswap_cluster, 0);
+	if (!vswap_cluster_cache)
+		return -ENOMEM;
+
+	if (cpuhp_setup_state_nocalls(CPUHP_MM_VSWAP_DEAD, "mm/vswap:dead", NULL,
+				vswap_cpu_dead)) {
+		pr_err("Failed to register vswap CPU hotplug callback\n");
+		kmem_cache_destroy(vswap_cluster_cache);
+		return -ENOMEM;
+	}
+
 	if (vswap_debug_fs_init())
 		pr_warn("Failed to initialize vswap debugfs\n");
 
+	for (i = 0; i < SWAP_NR_ORDERS; i++)
+		INIT_LIST_HEAD(&partial_clusters_lists[i]);
+
 	return 0;
 }
+
+void vswap_exit(void)
+{
+}
-- 
2.52.0


