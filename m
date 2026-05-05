Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 59D3BCD3440
	for <linux-mm@archiver.kernel.org>; Tue,  5 May 2026 15:39:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 655B36B0095; Tue,  5 May 2026 11:39:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6073A6B0096; Tue,  5 May 2026 11:39:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4CF296B0098; Tue,  5 May 2026 11:39:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 3E1FA6B0095
	for <linux-mm@kvack.org>; Tue,  5 May 2026 11:39:04 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id F36E6A04FC
	for <linux-mm@kvack.org>; Tue,  5 May 2026 15:39:03 +0000 (UTC)
X-FDA: 84733774566.27.DF939E2
Received: from mail-ot1-f51.google.com (mail-ot1-f51.google.com [209.85.210.51])
	by imf14.hostedemail.com (Postfix) with ESMTP id 1F9A3100016
	for <linux-mm@kvack.org>; Tue,  5 May 2026 15:39:01 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=a+clhjN8;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf14.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.210.51 as permitted sender) smtp.mailfrom=nphamcs@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777995542; a=rsa-sha256;
	cv=none;
	b=lygaw6nH0wTf07ZthBxy2lCXoVh+5gmO78qkLLh64MVlg+LvnZndbv2MJnKmsEa2xbWckr
	QKfd8vNy4iDDqgVTo+uE3qZsUC6K6oWQCdVJ5H7O0Z8zDYxjPxkUk7irhA3TV+yKNJY75s
	8fPAHDOUDYfPS0jzGpI+3+ePIW9ye0Y=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=a+clhjN8;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf14.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.210.51 as permitted sender) smtp.mailfrom=nphamcs@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777995542;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UPCSau5pSh9+F1pyHZnzuS9hVsnYodnKvGY7/tGPc+Q=;
	b=bNrA2CUP7fHrwCqG6k63oCJ0EF8Gp7Ovxg41U1b89lm23jrNkFcZ3gmIW6Tdl7r6cfOtI+
	K54y+6aB3X18OJuIMb7blGbws7VLU2SNaUMF8CQfXiwLXlHYUYWYbbGNo+/UM6kn9Etvp9
	I9B8eUGmDySTrq0BJIEAP8FiAiwqXeA=
Received: by mail-ot1-f51.google.com with SMTP id 46e09a7af769-7de4e6c5a30so4713925a34.0
        for <linux-mm@kvack.org>; Tue, 05 May 2026 08:39:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1777995541; x=1778600341; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UPCSau5pSh9+F1pyHZnzuS9hVsnYodnKvGY7/tGPc+Q=;
        b=a+clhjN8qHomfmzOqUar9yhOMoKudqdc8oGyvbhbt/qVjhoBFwBZHGbasmkrne/0MZ
         UtLnlCikjpNSBvBpzZyZW2n6jZNg7E6Z5BgobWnZh6SBFFBTHlAiYiC8kA0fZqwVlIZt
         rvX/gl2It2IpyZdMCyifJHaAfLpUwOYKi2ofk055a65CdfVzGCCPdToXrH/QvRGiKIzO
         ZQtLfgb2VtyiT8QEi6Ollk523Yy4b4QvXkOHhTGLC3X6sCR7WmGt2cYfbfskGNfq5K+u
         en9pW/fg1kHlydY0W0mssNf5TxATw7lwLLKOT4ulrPHJidYSihLDTleguhLwCB4fMb/i
         QVIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777995541; x=1778600341;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=UPCSau5pSh9+F1pyHZnzuS9hVsnYodnKvGY7/tGPc+Q=;
        b=lwYEr5HxqK78oCOVMt1fv7KcXbgNoC9DF/TiFW3ftGABfThcqT5swjgsCmYEo9tFXG
         OoELa0Xice83NaTB0Nd4UNH+j7hlwwxDIur6e9z+erXVQfnL4rDQPZYR4UcHGc6tmk3o
         rpl+gg6WgjsUS6+PnPCFDJJfuRbvQOBeYMz2shV40jrPt2BVv/AVXOXYGLk1mIZx/J7d
         NruAwVFJj0M9ojpjl4nfxiNjedfLSGVYmkaaTrdlBu6EWq5iZBmUM84iLDjCXSS+eWQ9
         rPdTkUOIu+CnEImlOiQD9ZIzy1sv9YE1FPKAEY58jWVVvX8KLGaYHS4iVA5SfONK2Ryf
         71zw==
X-Forwarded-Encrypted: i=1; AFNElJ/pkE8/8f5jy9Um6IEimohsOTwpMjBGxKrQvziBfgTK5+25xLqdBDU0ncPJn54nUVrhd01xMo8OEA==@kvack.org
X-Gm-Message-State: AOJu0YwfS30oXgyI3m/G++wNnoFbxSnUeLqO4XITbYaEpcPhDNEmRAsT
	UGXvI1t/F+jYDmYrYkm7NN2JdT6MlxOXHlwL5tHAGuislMr+H0ingy/F
X-Gm-Gg: AeBDievtoBLXOqs8eR+ZXIUSNX92kizZ+U4Qcm4UQ0N23FPCS5bKrNta59TbFKNI6p+
	ZuwD61r2SNrEPuhV/6o5ofya/P9xtyoH4Pp8qI6Hy81zrPqc70gqnue3E8biZEIJEO1eovE3cJV
	dCdQ5f9KDLjytYhT+T+2r4v2mpqtP1QM0GkNrLKdDAROWnL/RUu/XcpaPBeDcQKWiRA7ZWbyYcP
	z/1qCJzKfHoMiXFZISdDyPVAkkh9jzhC9YAm5dwN8q2F26fysER334JoikhFf0mq4VgQVvOLQdG
	9CDv/TLOS34hQ8tQaBxKMWK2nc+9YgaN6vkcAMd86UC+/77D9wqUEiWqXcWp+BEUzCkNPl3qYH7
	ONIphswHDLH7u50dUpTd48rwFk40voceXJqKXSDOHrDdcqXLpXo6sBW7AEUzYTIjQIUqNkJXOMf
	IArkV9Lp7miKXY5TpEKY1GnyZaoRwQoHislN7x4HvZatV81v17c6fy+YnIQWfuE2NP5sU=
X-Received: by 2002:a05:6830:3906:b0:7d7:e844:7f4e with SMTP id 46e09a7af769-7dee14562acmr7829174a34.22.1777995540927;
        Tue, 05 May 2026 08:39:00 -0700 (PDT)
Received: from localhost ([2a03:2880:10ff:47::])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7deced80854sm9907964a34.18.2026.05.05.08.39.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 May 2026 08:39:00 -0700 (PDT)
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
Subject: [PATCH v6 02/22] swap: rearrange the swap header file
Date: Tue,  5 May 2026 08:38:31 -0700
Message-ID: <20260505153854.1612033-3-nphamcs@gmail.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260505153854.1612033-1-nphamcs@gmail.com>
References: <20260505153854.1612033-1-nphamcs@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: i5mato93ky3o5io1g17jf64su63f57p8
X-Rspam-User: 
X-Rspamd-Queue-Id: 1F9A3100016
X-Rspamd-Server: rspam07
X-HE-Tag: 1777995541-760813
X-HE-Meta: U2FsdGVkX1+nzQsoDKYXXqLLsYno6TFGESvTJs7y9GwEbueGPIjJBvWVt11KS3Fg29IkJgEarTtLMVBMbQcJbGujajW/n5UQ+2n3l8r5/vqlcB0oMh9A5EViYA4aLgFFNxdB3MPraNOWhXhcT44pEG6n7IPC2izOT3jlZlcLcaz7jPIYY+jssCkHzddEMT6rEmUXOifjwGZC5HD+nnb9BNCk2rZzb/o5+0agyNrsqlRg9HXdLJ0LE+Se5tauvl6T5V1p0L2JC4Bh25kXMejqASSwFhNkk0nxth3QqKQkj1fG9QaIBbNBmT0a3XZyvVQvlYye8a5KqTlsJgEN8j6RcKXiAKvc/ivdN1X9AIQ7jEEaG6A4EeHE8o9F13Cb+7RjLd6ClvExM3yTJJE/F58usxPAAdlYmFZL/bmTyIHoOIheZtfdoxq4pNnxo3o62UhNzHbP9x9aL+9hstC/QWbGqjpQa8njDNrQUVgFFdiaoiFoTRvM8xxIv8MRKs4cz8DXzPNs/MI8nHWrZ1DFNOPREhMHYMJZyMC+NgFPqt+37z9lIyoWsEZd2W98GycMu4tN6ZYZhYrRLl1untPNI4y/LtN69Lr2b/cHrJe8J0iwHPtvw7xj0dUnNxjGHl5KD8io7lPMEXmekGqx+zaiF16qFktMI2QLTrpRzkXZasF9qtDvB6kjA9yLui6z6Z/GhVG7p3ocJO+fJjk/exbV/1VInwBaq9izKSwc4FMtszTRJ/lISyvElhrxBL23j3mcjUBjYh5k33BucAkuameaNXsJJZTH2TaUuG9evWdcUS+Q2Lh9PFNtxrcLkgik9a7/YTLTdMWzRgBCpGni1xT32Nt5V5rk47UMBqyI1spjuPtd2WfVHNFxYbxPZOp2wpvZT58d2tVGGOXVQuQ/AFo93xfUH5KVvxRk1n4uf/eKmRE6tFxd1Mt3iTIGTgXxB4EXDUv1GvPnVfwz7z01+RM3LVz
 N9d/indB
 WuYAIp8/p4l5Z9Y+uR6Fr9Hpw2zzyQnYojFU+0GU8vUYFaLDi+Hf0NFbQsDwzBSUCylwPNeLp3GjttPs6ZcoiKG+H9b49B4iNhoaKyade3+ExchvCTytLzvWlDpeXc50XTYn3DmvZjAP2hZsZ5vRVAYu+CGMMbclXwELheqYVyvgEnA/b4WFXPzxg7udjMkCnI4AUlcXcScWpHV641quTdac+thn47HJ+gDWCVAROAKiynGRrPQftbyuyvyuYndVVWjyyDnSBZk8ZEzqpsHWFtbhC6MHN3/T1DwIwAiiLPB33Y9Tg/dsTku66rnX6OXmsRRSWlrSXcK4hgETtrs2RDFFmGQVZMAK/CBdHtbbp4jcCoBsPsSu1Hju97qV5sZwfM/3la8sAdhRS2ZTML5cpJyGSPS5isNMdOBCjji7fBzrKlS5rpqLRxlR17lJOrxe6oFkjWLBeG4mMEy7gQQGN4iEK41kh95Kl2KF+SbSJxRAZFd4J9ktqgKif8wTxcbR1ZbHVAFuxq/c5D8GzC+tuyin5kr3f2ltuX5pr0+2q18N8rfGAgj1NT3Nk4vAOs/IdYFE2
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

In the swap header file (include/linux/swap.h), group the swap API into
the following categories:

1. Lifecycle swap functions (i.e the function that changes the reference
   count of the swap entry).

2. Swap cache API.

3. Physical swapfile allocator and swap device API.

Also remove extern in the functions that are rearranged.

This is purely a clean up. No functional change intended.

Signed-off-by: Nhat Pham <nphamcs@gmail.com>
---
 include/linux/swap.h | 53 +++++++++++++++++++++++---------------------
 1 file changed, 28 insertions(+), 25 deletions(-)

diff --git a/include/linux/swap.h b/include/linux/swap.h
index 38ca3df68716..aa29d8ac542d 100644
--- a/include/linux/swap.h
+++ b/include/linux/swap.h
@@ -423,20 +423,34 @@ extern void __meminit kswapd_stop(int nid);
 
 #ifdef CONFIG_SWAP
 
-int add_swap_extent(struct swap_info_struct *sis, unsigned long start_page,
-		unsigned long nr_pages, sector_t start_block);
-int generic_swapfile_activate(struct swap_info_struct *, struct file *,
-		sector_t *);
-
+/* Lifecycle swap API (mm/swapfile.c) */
+int folio_alloc_swap(struct folio *folio);
+bool folio_free_swap(struct folio *folio);
+void put_swap_folio(struct folio *folio, swp_entry_t entry);
+void swap_shmem_alloc(swp_entry_t, int);
+int swap_duplicate(swp_entry_t);
+int swapcache_prepare(swp_entry_t entry, int nr);
+void swap_free_nr(swp_entry_t entry, int nr_pages);
+void free_swap_and_cache_nr(swp_entry_t entry, int nr);
+int __swap_count(swp_entry_t entry);
+bool swap_entry_swapped(struct swap_info_struct *si, swp_entry_t entry);
+int swp_swapcount(swp_entry_t entry);
+
+/* Swap cache API (mm/swap_state.c) */
 static inline unsigned long total_swapcache_pages(void)
 {
 	return global_node_page_state(NR_SWAPCACHE);
 }
-
-void free_swap_cache(struct folio *folio);
 void free_folio_and_swap_cache(struct folio *folio);
 void free_pages_and_swap_cache(struct encoded_page **, int);
-/* linux/mm/swapfile.c */
+void free_swap_cache(struct folio *folio);
+
+/* Physical swap allocator and swap device API (mm/swapfile.c) */
+int add_swap_extent(struct swap_info_struct *sis, unsigned long start_page,
+		unsigned long nr_pages, sector_t start_block);
+int generic_swapfile_activate(struct swap_info_struct *, struct file *,
+		sector_t *);
+
 extern atomic_long_t nr_swap_pages;
 extern long total_swap_pages;
 extern atomic_t nr_rotate_swap;
@@ -452,26 +466,15 @@ static inline long get_nr_swap_pages(void)
 	return atomic_long_read(&nr_swap_pages);
 }
 
-extern void si_swapinfo(struct sysinfo *);
-int folio_alloc_swap(struct folio *folio);
-bool folio_free_swap(struct folio *folio);
-void put_swap_folio(struct folio *folio, swp_entry_t entry);
-extern swp_entry_t get_swap_page_of_type(int);
-extern int add_swap_count_continuation(swp_entry_t, gfp_t);
-extern void swap_shmem_alloc(swp_entry_t, int);
-extern int swap_duplicate(swp_entry_t);
-extern int swapcache_prepare(swp_entry_t entry, int nr);
-extern void swap_free_nr(swp_entry_t entry, int nr_pages);
-extern void free_swap_and_cache_nr(swp_entry_t entry, int nr);
+void si_swapinfo(struct sysinfo *);
+swp_entry_t get_swap_page_of_type(int);
+int add_swap_count_continuation(swp_entry_t, gfp_t);
 int swap_type_of(dev_t device, sector_t offset);
 int find_first_swap(dev_t *device);
-extern unsigned int count_swap_pages(int, int);
-extern sector_t swapdev_block(int, pgoff_t);
-extern int __swap_count(swp_entry_t entry);
-extern bool swap_entry_swapped(struct swap_info_struct *si, swp_entry_t entry);
-extern int swp_swapcount(swp_entry_t entry);
+unsigned int count_swap_pages(int, int);
+sector_t swapdev_block(int, pgoff_t);
 struct backing_dev_info;
-extern struct swap_info_struct *get_swap_device(swp_entry_t entry);
+struct swap_info_struct *get_swap_device(swp_entry_t entry);
 sector_t swap_folio_sector(struct folio *folio);
 
 static inline void put_swap_device(struct swap_info_struct *si)
-- 
2.52.0


