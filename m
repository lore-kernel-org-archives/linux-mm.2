Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2D9331099B39
	for <linux-mm@archiver.kernel.org>; Fri, 20 Mar 2026 19:27:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 805136B014A; Fri, 20 Mar 2026 15:27:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7DC2D6B014C; Fri, 20 Mar 2026 15:27:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 655966B014D; Fri, 20 Mar 2026 15:27:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 5880D6B014A
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 15:27:42 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 1D0FC160329
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 19:27:42 +0000 (UTC)
X-FDA: 84567425964.30.4DCFBD3
Received: from mail-oi1-f171.google.com (mail-oi1-f171.google.com [209.85.167.171])
	by imf01.hostedemail.com (Postfix) with ESMTP id 3818D40010
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 19:27:40 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=O5kQm3uW;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf01.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.167.171 as permitted sender) smtp.mailfrom=nphamcs@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774034860;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lQz9gXtG0BjRbamDLXajf4zSV33YchOog2Zf6fZXOug=;
	b=Pqfhrm8t3OM1IL/jhIXa23DHWwqmbzxB8XTj6tUFbInLXuyKjNSsgUAOnfMN3hE7LYUBgU
	A6SQoMVZtkOrrUycWU6rYEJJDXQC0MqofEZ/I8dvr67eSefChzjkF5MDdOQhgoaBB3JKzC
	7uTkbFBAagZ9CQKMbVLQjDSbPpeGdco=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774034860; a=rsa-sha256;
	cv=none;
	b=fBYpVSwM6Jh6ZX7PrYzSmYPw4PRrHaJVQlj3UsGqgt4r7j0a6us5p4RBya5+sghfIE2Ny1
	OO/KAJL7bET8+e6GcI1q0Reotgu0FmW9oBLdsP1kUYO0fhzEJdjE5gBL9NzJz4LOTjyRhg
	bmA+18r1zVGLHRf9ontLtQBGcTod42w=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=O5kQm3uW;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf01.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.167.171 as permitted sender) smtp.mailfrom=nphamcs@gmail.com
Received: by mail-oi1-f171.google.com with SMTP id 5614622812f47-4670bcc40d7so781524b6e.2
        for <linux-mm@kvack.org>; Fri, 20 Mar 2026 12:27:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1774034859; x=1774639659; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lQz9gXtG0BjRbamDLXajf4zSV33YchOog2Zf6fZXOug=;
        b=O5kQm3uWmlDqeMxDPTUT4TSvluv8vFhSZCQBgK3v3oEE80QtoujOYXA8Pqbghgnu2Z
         tmZPvw5gKyqJlt4+puQWkh1xwlNmbUN85qxJJTjwNYKN9689KPZaAQWayVA5G44WO2v1
         iYvHCIH20qjB6SngfdKwVRH2sM12IiBs8/6hKno/5zVaPywk1/YfvjfZ4o8kyzOK6fmL
         VNPzM/2JKVbcPs7a6CAnZQkrx99Y9WWe/pjGS9ZYmj0iw6wXtDvIUvJEMGInjTLlPUqV
         FJ8WL3jlrgp9MvMlqGRQgMWZLYRBMIks7ZnwJyMXgYpUdDczcJwc1s95LjFHrzfLmuBn
         gNzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774034859; x=1774639659;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=lQz9gXtG0BjRbamDLXajf4zSV33YchOog2Zf6fZXOug=;
        b=ME+43+kZDiIht7676rMwQJlrCcwfF8natirKjHMsks3zHtjmzj7Hw77CjezZHbwy0v
         aPPW6bBrFB5RMvcoxAoA6pJZD1AUYU07gO/llH88BDnKvFeiKboSyg6TViASuAw1XFiK
         no+fGMfNY4L8QquXx+Az6psgJ/PoLQc53r2TcPZUOOQwuKFL59g4ql+f3DA8v5pVnG8P
         7dfwCkZx1MfNj0/wOie4qXCV0pJzTY4uEEqsjW1LRpfW0Z10+BuKhzwm4OWPcSOIqyGH
         Qtirv5zykCQFdUWKY7D89FD3mjgfDhK7nLcGBqZVRBsaTz+7ll4zwWortcM0qymJ9uHN
         AUPg==
X-Forwarded-Encrypted: i=1; AJvYcCV5TJOcsMoAU7VHWfPzoaavRcwmSdyuJsKZmp78YgqUZ5tKz5nNWBlsuMcyl181C47/lmfLYuKp5Q==@kvack.org
X-Gm-Message-State: AOJu0YywtHgWlEQxEhW9BGNgRVWlK2nAWdHUsXJWkvmKp5d/52Zw+w3m
	cWgGuB5yUD5FxvZODgUCKxjaBfftH11RPCCXvIjTzJQ+tPlc7Hqd4E5h
X-Gm-Gg: ATEYQzx+pzoVQxFia6paCZv4MS7T5io+tTpW1p0rhPW7fo0OTY+WKc4BjV9IY9mfFeG
	0Fi5DaP++xR3ysSDLyytNUB/sbHstDJEks/dOcE2qL/+SjH8akHOBVDzlJs9kTvu6QnrKO883ng
	B8rUPbSW689QVelINb5lQhIhn9mV0iRC26OHUk5VRlABhVv4HIN4WkaRTZJjJmlgaOD+Qwtw64G
	/dT1ffqB9H6Q5Xz42a7knQ0g5oynrA6lq0/q+FtK7OiDG6VtbECKx9wSckHm7MET095UCl8CH96
	7nOlk3tdMU8eXaYOQgWwKlFRUzDvD2a9/itK6lu2eHUwx/hx3VnR9mKDmsFUHnB5ceGUGHWNKVl
	Y40xyVXTf2UFJ9xeVOkfdiJJQySl1nOjSpPn8wYxlBlSP8rWloKzneCnS24c8pM1jEfQzF7L62s
	aAggK1jKXVqvGKZdOt2B5AJu8ORln7kn32Up3sNYTEYWPjew==
X-Received: by 2002:a05:6808:1645:b0:462:dc57:f8ba with SMTP id 5614622812f47-467e5f095d0mr2364034b6e.27.1774034859050;
        Fri, 20 Mar 2026 12:27:39 -0700 (PDT)
Received: from localhost ([2a03:2880:10ff:51::])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-41c14ddbca8sm2951988fac.15.2026.03.20.12.27.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Mar 2026 12:27:38 -0700 (PDT)
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
Subject: [PATCH v5 02/21] swap: rearrange the swap header file
Date: Fri, 20 Mar 2026 12:27:16 -0700
Message-ID: <20260320192735.748051-3-nphamcs@gmail.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260320192735.748051-1-nphamcs@gmail.com>
References: <20260320192735.748051-1-nphamcs@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 3818D40010
X-Stat-Signature: 6yg3wsppq8kt7swo6dfrpszwfip69rge
X-Rspam-User: 
X-HE-Tag: 1774034860-330127
X-HE-Meta: U2FsdGVkX1+VBhnbkZRCDUNFMA1+j3V3S6LKq5Zt/3eBuvzk6ZdDvuRrTSUK0PDNNGaEQA5yAZHfv1JtvwDHhdb4d3zr8IBqa+n38jJ72pLUgbmJGUnC2hyrfJY4L1nv+LEXrcNlgxAMplIaSYOoGPl9ZVbgJjm9nj5lneEJtAdCqqEcqj4SG/G2IB/nBgflw3ZBcCsQ/Y60aoNjqzGafDZAgoJ6x5q2p2PKlVOmwYJJr4dP+2tLWt5u7Ztfx+SyflLPmo+lM2WiSk5XhyIZvGHwWr9iaFNkUYPDujvky57hULrw9BW42ZzSQ4x+1bzfU9dtJn6aXDvnynGK1WXqHHrAACEcXX7o9OV2I3BwshgbdmmTf+GavyD6TrVy4Tmfk1ehQ8gMjQxQxEpxsmazENLf0vYlZlBE3p+0O0umGZ5C7wLxnFcN7s4B4crqeXVPyd7waDA3J8Msa5dITJkEYJazkpoun0C0oJ01rEBgp/nWDFU5xnBhpK51cz2IXJCxI98Es7+xa4SYTc1nBxjGtPNkJNdgJ0Im9zoc+zihbbChkRQOG86cAxo5en50EsFfA1U2Wyz6hhFhGrCAhzOzvIe/rzcoxKQS5Jg+oNSUbW0BXP4+A59yo7VshXag9TyTqD4qYu7x0AjNUxVD3BhzJziOIO0XWo8DkIVtIOqt0bAJe2W1kQrSRpLlBkb11nndFH0yEPjfhY2/d+89UDTEe4TJfACuw/BOjWI2sbmscH8OFdHhOzihXHrWEWjn4HFw6nRVKlYbRc6VmSQbM0wCN9AW0fkGCg366+iZl7SzyKbJEhKSEwG51eYU3bDyVsxOMKvZu3ZUOjQPkcu+u1P3DHDciA4DzJN+/btg2h9KEjLeg+/WnJoJMHlLFAKbXLJGEX6PzRdhy6XoMk26gWx4VSyD11cJNdjrzdHJ5SBAsvCaAH9Bmq+8K3LakI2B3hNfic4HHyn5ms+q+1f4by5
 D/xWgnJT
 zGIX/sloi+lPYhJHGuEqGIyxfGfqlCVO2rhyvX8Tp9yic357jZih/ExmTjug7juy7p4VlZvRcgi9rOH74TUHx7g6CWmcWrYgcPtpdIkf7Jw4TWoUTrzEcZ0wF22LD+EFkvoqImwIAtEr/PkcObOpcmr0M9eBt+j28LHw4D68/d6N1rJgIpxOebCLia9Mphgm0q7krL1Rqsfb9jm/7l+u4VZvbjG43c7qGMDJBf+HWIXEKGElcPJwi7glgYDqtZJUSHSicKN2oilkBSL3hNy8Fyi2Aq5FKm+ZtrkVjowxL010Hkn5pZJeUdrmBYZlsOPZVH2R8s4SZOmsnMHRxgjkC1KZGbVDwcv7W2tleNel9VepRbontHypRwCka5a6YKarBRumpXCnHwNG8o2/c4l7bWHQVgQcVUpxFhrnFnGY6OBbmCVi8+vNahO5S/DaqrtirxnixcoOyZ9fPmHbTb0gNcDrmzyN/jQpQLNtZgrcyAWvJi++we7zjZkhlRIToCBPi5w5OHKAiIogjnOXv7fuaz46Rp8Cw2PaWSrDV7kSmBCfrOhH9v5jVixVzKdHr8D5/zKK6
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
index 38ca3df687160..aa29d8ac542d1 100644
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


