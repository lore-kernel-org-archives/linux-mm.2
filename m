Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EA6951099B3A
	for <linux-mm@archiver.kernel.org>; Fri, 20 Mar 2026 19:28:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8A0AF6B0160; Fri, 20 Mar 2026 15:27:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 82A566B0162; Fri, 20 Mar 2026 15:27:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6F2626B0163; Fri, 20 Mar 2026 15:27:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 5AFD76B0160
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 15:27:57 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 2B1898AAD8
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 19:27:57 +0000 (UTC)
X-FDA: 84567426594.01.21E660D
Received: from mail-ot1-f41.google.com (mail-ot1-f41.google.com [209.85.210.41])
	by imf14.hostedemail.com (Postfix) with ESMTP id 5545010000D
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 19:27:55 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=OzADdzH0;
	spf=pass (imf14.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.210.41 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774034875;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5/hCJezq6i9YBJbsR8fO/KYYPUcAwg9EMc6jEkUFETU=;
	b=iK++/1iLfWIC/gQLcm8qEBTtqAxVc/hbQyWN0pE1bp8n1MTlX3gEGQei9+5ex36x7K51Ao
	VQwrTVg9vb4WUCLJefSHCYc0ao4sjhDdwcRIBe8f4btFczN7BE3FmDyvRCYkSBMHeMd9zc
	IA83y9KN93T0TFoOolMzFUSaiBrLo0E=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774034875; a=rsa-sha256;
	cv=none;
	b=q2/HmBrqvZcfZvCWco5EkzOHAk8hZxaOQI3JKeo6Qe3FVQekxj9t/FIFbWGxUcIZePGyle
	XL6kGfhpQO7BR0q7On/jt5dfa2NdkqDBf1U+BKSfAyY+A3AJNb6GURwR5HWaeN4nRi3tno
	DmFlJ9HH4vmIRrESPqHChk2JTcS2Rnc=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=OzADdzH0;
	spf=pass (imf14.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.210.41 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-ot1-f41.google.com with SMTP id 46e09a7af769-7d77b179b52so1740907a34.2
        for <linux-mm@kvack.org>; Fri, 20 Mar 2026 12:27:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1774034874; x=1774639674; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5/hCJezq6i9YBJbsR8fO/KYYPUcAwg9EMc6jEkUFETU=;
        b=OzADdzH00COcEHZ7qb19pN+TuGulB2RCmkZ5uOy9Mj9tcVnZkfi4xFNviBkoyMZgGE
         0D7elK5NkOipaaRwoa+hlN46c9I0ud5zXJ8tsj9MfOUNwJCFuxzibm+/yYcfcHA4fwNh
         yZMx3EapZIKkAGbJbV2cC6fKRN7TEqMGmZNdmMJtXd20kkdG0a3Gl1FvLIHrNb6o88dX
         9p34yYdNWbHeHRwqI79YW1CloCJIM9vRp87tlSmsmnnc0M5sDx6NaNHHAm6QTkBSRzjf
         f45tfffntiPJuBDz+QpAMsKVuHc+qFGZeBLaxRsQCokZuX67OH63KS5/NFIKSmceJGeE
         H9Wg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774034874; x=1774639674;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=5/hCJezq6i9YBJbsR8fO/KYYPUcAwg9EMc6jEkUFETU=;
        b=jHzIAqjwhCX+e+0xWocBqkqse1miJncjt46LkBNtcDFjrrL7Dnti+oJ1fxbIjlqENS
         ZbzSpuLudqSc8jlYU5z+fXNIcfASmcArVkdT6q/zhUSXvPTaZTywp+nt0uYVUKLLeB+n
         idAX2kI/oSMIskv2AQP+c18tvfvm1/5HkRNNWdHLDo+vxwPhWXXGLwS9IBykqzMb2H2A
         4Enw5l1qi/m2BPv3ZxZW6+uRqE57EKVPTwr01RiUdl0WmLaBhQJkwGzqDq4Uw1bftgrO
         7iiVKhCFm7PDmQBNDzXfjXkLy5KSk6YoaUeYIVSB5yki071zCwk7e+iK5vqvsFIXWJMY
         mHcQ==
X-Forwarded-Encrypted: i=1; AJvYcCUmxEGDcVK30ORYbDh6zUhorpLZISsLgapgvqjJwH0Oqu1RRCs+7hkGYxIO0j4vRigXMi+pD2F67Q==@kvack.org
X-Gm-Message-State: AOJu0Yz9ScMFBVlqeQLwx8nC+ZTImcvky1SPIANmiV4QjTUqe8iiSLjE
	xevO5dl9g3QRxBXPMrL5HkoHww6mbX+nTiwLwwWIm4Cu4CrRUlRfRlxL
X-Gm-Gg: ATEYQzzhqVHiFkzgkUsbLAEOxSPpOUebKVroUopz8+egAUtRCW8rx96PrVXG/aB1xTA
	rgK2lXTj9gMxUj6HylnQ43H+mF9oJas5OouTVp63u5+QlcJjaYyrTZLxGAbjFIquIBfLoVcV/j4
	otzld6UifqKe/ZICiqQbDcQfL9NGlG3XaggbfnTa7psYRLy8iCsSePbQwFXDnH4yctmB/dNdgku
	g7PhqU596TeeIcKOfYxmJBb2eUksaaKd4KNVqt4sep1GZu5In7CJSLfOp/Wy5sB5a5zslI2qEnh
	69yj8UjcCIPl9u2UrDro3QglYkD9/5FjhC3wc3qeY9+g+1zsNsdBynI3dXOlmoIOPuBv3v8NPxU
	vekvbL7Hl8QQUxQKNfna78snQj6wVZdxg/7ZKsux0igIEWNNjSIsYsFObzyd58LyUp7IdEVeGHW
	umBeUaYmVXpYDh4ioRrvUNVHdh/Dy/XspHpsZF7wD7x7ivSg==
X-Received: by 2002:a05:6830:8382:b0:7d7:ea04:6654 with SMTP id 46e09a7af769-7d7eaeced6fmr2911142a34.15.1774034874277;
        Fri, 20 Mar 2026 12:27:54 -0700 (PDT)
Received: from localhost ([2a03:2880:10ff:46::])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7d7eac17471sm3081351a34.7.2026.03.20.12.27.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Mar 2026 12:27:53 -0700 (PDT)
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
Subject: [PATCH v5 12/21] swap: implement the swap_cgroup API using virtual swap
Date: Fri, 20 Mar 2026 12:27:26 -0700
Message-ID: <20260320192735.748051-13-nphamcs@gmail.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260320192735.748051-1-nphamcs@gmail.com>
References: <20260320192735.748051-1-nphamcs@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: 5eqkghh3d6w5o3kdhrn8qa4bcsc3h1sk
X-Rspamd-Queue-Id: 5545010000D
X-Rspamd-Server: rspam03
X-HE-Tag: 1774034875-410118
X-HE-Meta: U2FsdGVkX1/IRa5GDssQbF+vzit6M/vDXsgzTVqFrbsksIOaAJHtae41qwFfqBqgHCUauU97BPgTjP8NCJDTj0E3JmiuvOEr/tmkuGmcCFYjBR7Rb9Ca1Vv1FLvm5911Rto32fD4v3peypNjVEq4bx2Q9ExtMndXut2QFg8OqXH/9qh4LhASWlNxBiMAi6IIBkeUKDvXg+1/p3XPgOozORtptobYOE4aqeazk0QpW2beKYn5oITqofBlgdtNb1MnJkrjrPtd+5K2mYzy4JMb8yKFRgHpDa0a7shZ3Okd9Ebobd1VnqAz2RsuVe7x/sGP6KzkbCZIxcwxEgt4PwYnXEkaAEt2MGEr4dL3NJ4xqh7hxTYzw8bexHykc4BbmfLmmLgwyXoC/dEMf5tT1FJkonCosfQHBGZUTU+GPStPVgMYSP6O1nplr4WwJLEgyR9JefFvPmvFMDeQWVTC6X9w0R61SlwALsu4O8hA2/wY6NhYIzbc1kQEM/of6f2kAHO0dOy6ciP38LWeli/VvYAXLhkdfDe57zSvKJViFF+cd2URoKbsePBmNzChmWIQ4Zt2VGPeIAukYXJYcMzSWRVXAmVIeErvcfGXPDcWXWd51bSIncPvip0kEPAH+goxKq/WN0jvH3rghmiePpaGv0/+apFVJ+MA/I/z5YHQLtl785b1wVJF7TwazWJ1jjL7VEvcJf5myAggoJ2vCS8sh0LttpQgjEj7RvKMIwgnS9Sl9nfyWM+EUllmDSzBGQwM4j8BTmg2A1jtPU3UuxBX642Wc7a973Wki6D7CElcu2EsV8ghEkbundFO5CrLe+pIoSneKZ1uhDUpgRJ+59H5O9aejdIwr/nSitKMGYiNN2LHw70jiMlZCyEvdFfenhbPLFL6AVY5UbXVi1JYxsQRJZoU5hPp2e7WI43wycChA+W4N5akyvLC9mESr82f/FN88qrkMY/sxyaSeovBzpxMBt4
 gJPy46Cj
 8uUXLSE4dpIYDpgVbYvd/bZ3bBE4XzpEg/YkHt4uU/ufOYBj3DdTY0ryyuAVk1ICTIYxHU/G3Zhzgfz+ypr4EitxNmkUjgjaMcw8ef4i/SSkdSRi/twFxJDAIJZ7JKgV/lMvfUq7OyvrRA9lgfuFzrl5REf0Qci8HLnj2zMO0yIsqBz6a+WYo3pBVSeMxl67Od++A4Toc07AJLZ8GiebeEl4+UQgJIOBn+flQ6zD+HZ7Di/XQ9X0TbEKuLHY1Aw1o/GE29eRbepg7LOho+TohsH3ooS2kqBiirruUyHBGAAzh2rJtm7tAkSSpSrhOmhpWgnmmJFS05deXcDyPKI8pF2tyBtrW10bEa9OyL/JM3lPaLu2G06aMS+L6pjSBvs7Tk20uMOKctCJKDfFxC0CsvQrIfXiZ8kC+ZkZmv9JEnls6V2SXoMk1ThTFd3cmYm5bYvfJqDBJtbNCSHjmgyBL/uaGZm+5mzwlwB0bSOAeO56gjkbj9jkFtddtMAtAcsxM+JO1XF8jw20TLF7iU2ngk3qDpbSue11f81mawyh2pPoANtob8qVZsvs2Zz5RWGfpyT2k5blVpo4JSWI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Once we decouple a swap entry from its backing store via the virtual
swap, we can no longer statically allocate an array to store the swap
entries' cgroup information. Move it to the swap descriptor.

Note that the memory overhead for swap cgroup information is now on
demand, i.e dynamically incurred when the virtual swap cluster is
allocated. This help reduces the memory overhead in a huge but
sparsely used swap space.

For instance, a 2 TB swapfile consists of 2147483648 swap slots, each
incurring 2 bytes of overhead for swap cgroup, for a total of 1 GB. If
we only utilize 10% of the swapfile, we will save 900 MB.

Signed-off-by: Nhat Pham <nphamcs@gmail.com>
---
 include/linux/swap_cgroup.h |  17 ++--
 mm/Makefile                 |   3 -
 mm/memcontrol-v1.c          |   2 +-
 mm/swap_cgroup.c            | 174 ------------------------------------
 mm/swapfile.c               |   7 --
 mm/vswap.c                  | 142 +++++++++++++++++++++++++++++
 6 files changed, 148 insertions(+), 197 deletions(-)
 delete mode 100644 mm/swap_cgroup.c

diff --git a/include/linux/swap_cgroup.h b/include/linux/swap_cgroup.h
index 91cdf12190a03..a5b549a9ba3c3 100644
--- a/include/linux/swap_cgroup.h
+++ b/include/linux/swap_cgroup.h
@@ -7,10 +7,9 @@
 #if defined(CONFIG_MEMCG) && defined(CONFIG_SWAP)
 
 extern void swap_cgroup_record(struct folio *folio, unsigned short id, swp_entry_t ent);
+extern void __swap_cgroup_record(struct folio *folio, unsigned short id, swp_entry_t ent);
 extern unsigned short swap_cgroup_clear(swp_entry_t ent, unsigned int nr_ents);
 extern unsigned short lookup_swap_cgroup_id(swp_entry_t ent);
-extern int swap_cgroup_swapon(int type, unsigned long max_pages);
-extern void swap_cgroup_swapoff(int type);
 
 #else
 
@@ -20,28 +19,22 @@ void swap_cgroup_record(struct folio *folio, unsigned short id, swp_entry_t ent)
 }
 
 static inline
-unsigned short swap_cgroup_clear(swp_entry_t ent, unsigned int nr_ents)
+void __swap_cgroup_record(struct folio *folio, unsigned short id, swp_entry_t ent)
 {
-	return 0;
 }
 
 static inline
-unsigned short lookup_swap_cgroup_id(swp_entry_t ent)
+unsigned short swap_cgroup_clear(swp_entry_t ent, unsigned int nr_ents)
 {
 	return 0;
 }
 
-static inline int
-swap_cgroup_swapon(int type, unsigned long max_pages)
+static inline
+unsigned short lookup_swap_cgroup_id(swp_entry_t ent)
 {
 	return 0;
 }
 
-static inline void swap_cgroup_swapoff(int type)
-{
-	return;
-}
-
 #endif
 
 #endif /* __LINUX_SWAP_CGROUP_H */
diff --git a/mm/Makefile b/mm/Makefile
index 67fa4586e7e18..a7538784191bf 100644
--- a/mm/Makefile
+++ b/mm/Makefile
@@ -103,9 +103,6 @@ obj-$(CONFIG_PAGE_COUNTER) += page_counter.o
 obj-$(CONFIG_LIVEUPDATE) += memfd_luo.o
 obj-$(CONFIG_MEMCG_V1) += memcontrol-v1.o
 obj-$(CONFIG_MEMCG) += memcontrol.o vmpressure.o
-ifdef CONFIG_SWAP
-obj-$(CONFIG_MEMCG) += swap_cgroup.o
-endif
 obj-$(CONFIG_CGROUP_HUGETLB) += hugetlb_cgroup.o
 obj-$(CONFIG_GUP_TEST) += gup_test.o
 obj-$(CONFIG_DMAPOOL_TEST) += dmapool_test.o
diff --git a/mm/memcontrol-v1.c b/mm/memcontrol-v1.c
index 6eed14bff7426..7b010e165e1ba 100644
--- a/mm/memcontrol-v1.c
+++ b/mm/memcontrol-v1.c
@@ -620,7 +620,7 @@ void memcg1_swapout(struct folio *folio, swp_entry_t entry)
 		mem_cgroup_id_get_many(swap_memcg, nr_entries - 1);
 	mod_memcg_state(swap_memcg, MEMCG_SWAP, nr_entries);
 
-	swap_cgroup_record(folio, mem_cgroup_id(swap_memcg), entry);
+	__swap_cgroup_record(folio, mem_cgroup_id(swap_memcg), entry);
 
 	folio_unqueue_deferred_split(folio);
 	folio->memcg_data = 0;
diff --git a/mm/swap_cgroup.c b/mm/swap_cgroup.c
deleted file mode 100644
index 77ce1d66c318d..0000000000000
--- a/mm/swap_cgroup.c
+++ /dev/null
@@ -1,174 +0,0 @@
-// SPDX-License-Identifier: GPL-2.0
-#include <linux/swap_cgroup.h>
-#include <linux/vmalloc.h>
-#include <linux/mm.h>
-
-#include <linux/swapops.h> /* depends on mm.h include */
-
-static DEFINE_MUTEX(swap_cgroup_mutex);
-
-/* Pack two cgroup id (short) of two entries in one swap_cgroup (atomic_t) */
-#define ID_PER_SC (sizeof(struct swap_cgroup) / sizeof(unsigned short))
-#define ID_SHIFT (BITS_PER_TYPE(unsigned short))
-#define ID_MASK (BIT(ID_SHIFT) - 1)
-struct swap_cgroup {
-	atomic_t ids;
-};
-
-struct swap_cgroup_ctrl {
-	struct swap_cgroup *map;
-};
-
-static struct swap_cgroup_ctrl swap_cgroup_ctrl[MAX_SWAPFILES];
-
-static unsigned short __swap_cgroup_id_lookup(struct swap_cgroup *map,
-					      pgoff_t offset)
-{
-	unsigned int shift = (offset % ID_PER_SC) * ID_SHIFT;
-	unsigned int old_ids = atomic_read(&map[offset / ID_PER_SC].ids);
-
-	BUILD_BUG_ON(!is_power_of_2(ID_PER_SC));
-	BUILD_BUG_ON(sizeof(struct swap_cgroup) != sizeof(atomic_t));
-
-	return (old_ids >> shift) & ID_MASK;
-}
-
-static unsigned short __swap_cgroup_id_xchg(struct swap_cgroup *map,
-					    pgoff_t offset,
-					    unsigned short new_id)
-{
-	unsigned short old_id;
-	struct swap_cgroup *sc = &map[offset / ID_PER_SC];
-	unsigned int shift = (offset % ID_PER_SC) * ID_SHIFT;
-	unsigned int new_ids, old_ids = atomic_read(&sc->ids);
-
-	do {
-		old_id = (old_ids >> shift) & ID_MASK;
-		new_ids = (old_ids & ~(ID_MASK << shift));
-		new_ids |= ((unsigned int)new_id) << shift;
-	} while (!atomic_try_cmpxchg(&sc->ids, &old_ids, new_ids));
-
-	return old_id;
-}
-
-/**
- * swap_cgroup_record - record mem_cgroup for a set of swap entries.
- * These entries must belong to one single folio, and that folio
- * must be being charged for swap space (swap out), and these
- * entries must not have been charged
- *
- * @folio: the folio that the swap entry belongs to
- * @id: mem_cgroup ID to be recorded
- * @ent: the first swap entry to be recorded
- */
-void swap_cgroup_record(struct folio *folio, unsigned short id,
-			swp_entry_t ent)
-{
-	unsigned int nr_ents = folio_nr_pages(folio);
-	swp_slot_t slot = swp_entry_to_swp_slot(ent);
-	struct swap_cgroup *map;
-	pgoff_t offset, end;
-	unsigned short old;
-
-	offset = swp_slot_offset(slot);
-	end = offset + nr_ents;
-	map = swap_cgroup_ctrl[swp_slot_type(slot)].map;
-
-	do {
-		old = __swap_cgroup_id_xchg(map, offset, id);
-		VM_BUG_ON(old);
-	} while (++offset != end);
-}
-
-/**
- * swap_cgroup_clear - clear mem_cgroup for a set of swap entries.
- * These entries must be being uncharged from swap. They either
- * belongs to one single folio in the swap cache (swap in for
- * cgroup v1), or no longer have any users (slot freeing).
- *
- * @ent: the first swap entry to be recorded into
- * @nr_ents: number of swap entries to be recorded
- *
- * Returns the existing old value.
- */
-unsigned short swap_cgroup_clear(swp_entry_t ent, unsigned int nr_ents)
-{
-	swp_slot_t slot = swp_entry_to_swp_slot(ent);
-	pgoff_t offset = swp_slot_offset(slot);
-	pgoff_t end = offset + nr_ents;
-	struct swap_cgroup *map;
-	unsigned short old, iter = 0;
-
-	map = swap_cgroup_ctrl[swp_slot_type(slot)].map;
-
-	do {
-		old = __swap_cgroup_id_xchg(map, offset, 0);
-		if (!iter)
-			iter = old;
-		VM_BUG_ON(iter != old);
-	} while (++offset != end);
-
-	return old;
-}
-
-/**
- * lookup_swap_cgroup_id - lookup mem_cgroup id tied to swap entry
- * @ent: swap entry to be looked up.
- *
- * Returns ID of mem_cgroup at success. 0 at failure. (0 is invalid ID)
- */
-unsigned short lookup_swap_cgroup_id(swp_entry_t ent)
-{
-	struct swap_cgroup_ctrl *ctrl;
-	swp_slot_t slot = swp_entry_to_swp_slot(ent);
-
-	if (mem_cgroup_disabled())
-		return 0;
-
-	ctrl = &swap_cgroup_ctrl[swp_slot_type(slot)];
-	return __swap_cgroup_id_lookup(ctrl->map, swp_slot_offset(slot));
-}
-
-int swap_cgroup_swapon(int type, unsigned long max_pages)
-{
-	struct swap_cgroup *map;
-	struct swap_cgroup_ctrl *ctrl;
-
-	if (mem_cgroup_disabled())
-		return 0;
-
-	BUILD_BUG_ON(sizeof(unsigned short) * ID_PER_SC !=
-		     sizeof(struct swap_cgroup));
-	map = vzalloc(DIV_ROUND_UP(max_pages, ID_PER_SC) *
-		      sizeof(struct swap_cgroup));
-	if (!map)
-		goto nomem;
-
-	ctrl = &swap_cgroup_ctrl[type];
-	mutex_lock(&swap_cgroup_mutex);
-	ctrl->map = map;
-	mutex_unlock(&swap_cgroup_mutex);
-
-	return 0;
-nomem:
-	pr_info("couldn't allocate enough memory for swap_cgroup\n");
-	pr_info("swap_cgroup can be disabled by swapaccount=0 boot option\n");
-	return -ENOMEM;
-}
-
-void swap_cgroup_swapoff(int type)
-{
-	struct swap_cgroup *map;
-	struct swap_cgroup_ctrl *ctrl;
-
-	if (mem_cgroup_disabled())
-		return;
-
-	mutex_lock(&swap_cgroup_mutex);
-	ctrl = &swap_cgroup_ctrl[type];
-	map = ctrl->map;
-	ctrl->map = NULL;
-	mutex_unlock(&swap_cgroup_mutex);
-
-	vfree(map);
-}
diff --git a/mm/swapfile.c b/mm/swapfile.c
index a47e024f2152c..adfcce286258f 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -2934,8 +2934,6 @@ SYSCALL_DEFINE1(swapoff, const char __user *, specialfile)
 	vfree(swap_map);
 	kvfree(zeromap);
 	free_cluster_info(cluster_info, maxpages);
-	/* Destroy swap account information */
-	swap_cgroup_swapoff(p->type);
 
 	inode = mapping->host;
 
@@ -3500,10 +3498,6 @@ SYSCALL_DEFINE2(swapon, const char __user *, specialfile, int, swap_flags)
 		goto bad_swap_unlock_inode;
 	}
 
-	error = swap_cgroup_swapon(si->type, maxpages);
-	if (error)
-		goto bad_swap_unlock_inode;
-
 	error = setup_swap_map(si, swap_header, swap_map, maxpages);
 	if (error)
 		goto bad_swap_unlock_inode;
@@ -3608,7 +3602,6 @@ SYSCALL_DEFINE2(swapon, const char __user *, specialfile, int, swap_flags)
 	si->global_cluster = NULL;
 	inode = NULL;
 	destroy_swap_extents(si);
-	swap_cgroup_swapoff(si->type);
 	spin_lock(&swap_lock);
 	si->swap_file = NULL;
 	si->flags = 0;
diff --git a/mm/vswap.c b/mm/vswap.c
index 9b2122647b850..d85fd0fdace97 100644
--- a/mm/vswap.c
+++ b/mm/vswap.c
@@ -41,6 +41,7 @@
  * @zswap_entry: The zswap entry associated with this swap slot.
  * @swap_cache: The folio in swap cache.
  * @shadow: The shadow entry.
+ * @memcgid: The memcg id of the owning memcg, if any.
  */
 struct swp_desc {
 	swp_slot_t slot;
@@ -49,6 +50,9 @@ struct swp_desc {
 		struct folio *swap_cache;
 		void *shadow;
 	};
+#ifdef CONFIG_MEMCG
+	unsigned short memcgid;
+#endif
 };
 
 #define VSWAP_CLUSTER_SHIFT HPAGE_PMD_ORDER
@@ -242,6 +246,9 @@ static void __vswap_alloc_from_cluster(struct vswap_cluster *cluster, int start)
 		desc = &cluster->descriptors[start + i];
 		desc->slot.val = 0;
 		desc->zswap_entry = NULL;
+#ifdef CONFIG_MEMCG
+		desc->memcgid = 0;
+#endif
 	}
 	cluster->count += nr;
 }
@@ -1108,6 +1115,141 @@ bool zswap_empty(swp_entry_t swpentry)
 }
 #endif /* CONFIG_ZSWAP */
 
+#ifdef CONFIG_MEMCG
+/*
+ * __vswap_cgroup_record - record mem_cgroup for a set of swap entries.
+ *
+ * Entered with the cluster locked. We will exit the function with the cluster
+ * still locked.
+ */
+static unsigned short __vswap_cgroup_record(struct vswap_cluster *cluster,
+				swp_entry_t entry, unsigned short memcgid,
+				unsigned int nr_ents)
+{
+	struct swp_desc *desc;
+	unsigned short oldid, iter = 0;
+	int i;
+
+	for (i = 0; i < nr_ents; i++) {
+		desc = __vswap_iter(cluster, entry.val + i);
+		VM_WARN_ON(!desc);
+		oldid = desc->memcgid;
+		desc->memcgid = memcgid;
+		if (!iter)
+			iter = oldid;
+		VM_WARN_ON(iter != oldid);
+	}
+
+	return oldid;
+}
+
+static unsigned short vswap_cgroup_record(swp_entry_t entry,
+				unsigned short memcgid, unsigned int nr_ents)
+{
+	struct vswap_cluster *cluster = NULL;
+	struct swp_desc *desc;
+	unsigned short oldid;
+
+	rcu_read_lock();
+	desc = vswap_iter(&cluster, entry.val);
+	VM_WARN_ON(!desc);
+	oldid = __vswap_cgroup_record(cluster, entry, memcgid, nr_ents);
+	spin_unlock(&cluster->lock);
+	rcu_read_unlock();
+
+	return oldid;
+}
+
+/**
+ * swap_cgroup_record - record mem_cgroup for a set of swap entries.
+ * These entries must belong to one single folio, and that folio
+ * must be being charged for swap space (swap out), and these
+ * entries must not have been charged
+ *
+ * @folio: the folio that the swap entry belongs to
+ * @memcgid: mem_cgroup ID to be recorded
+ * @entry: the first swap entry to be recorded
+ */
+void swap_cgroup_record(struct folio *folio, unsigned short memcgid,
+			swp_entry_t entry)
+{
+	unsigned short oldid =
+		vswap_cgroup_record(entry, memcgid, folio_nr_pages(folio));
+
+	VM_WARN_ON(oldid);
+}
+
+/**
+ * __swap_cgroup_record - record mem_cgroup for a set of swap entries.
+ *
+ * Same as swap_cgroup_record, but assumes the swap cache (vswap cluster)
+ * lock is already held.
+ *
+ * @folio: the folio that the swap entry belongs to
+ * @memcgid: mem_cgroup ID to be recorded
+ * @entry: the first swap entry to be recorded
+ */
+void __swap_cgroup_record(struct folio *folio, unsigned short memcgid,
+			  swp_entry_t entry)
+{
+	struct vswap_cluster *cluster;
+	unsigned long cluster_id = VSWAP_CLUSTER_IDX(entry);
+	unsigned short oldid;
+
+	rcu_read_lock();
+	cluster = xa_load(&vswap_cluster_map, cluster_id);
+	VM_WARN_ON(!cluster);
+	oldid = __vswap_cgroup_record(cluster, entry, memcgid,
+				      folio_nr_pages(folio));
+	rcu_read_unlock();
+
+	VM_WARN_ON(oldid);
+}
+
+/**
+ * swap_cgroup_clear - clear mem_cgroup for a set of swap entries.
+ * These entries must be being uncharged from swap. They either
+ * belongs to one single folio in the swap cache (swap in for
+ * cgroup v1), or no longer have any users (slot freeing).
+ *
+ * @entry: the first swap entry to be recorded into
+ * @nr_ents: number of swap entries to be recorded
+ *
+ * Returns the existing old value.
+ */
+unsigned short swap_cgroup_clear(swp_entry_t entry, unsigned int nr_ents)
+{
+	return vswap_cgroup_record(entry, 0, nr_ents);
+}
+
+/**
+ * lookup_swap_cgroup_id - lookup mem_cgroup id tied to swap entry
+ * @entry: swap entry to be looked up.
+ *
+ * Returns ID of mem_cgroup at success. 0 at failure. (0 is invalid ID)
+ */
+unsigned short lookup_swap_cgroup_id(swp_entry_t entry)
+{
+	struct vswap_cluster *cluster = NULL;
+	struct swp_desc *desc;
+	unsigned short ret;
+
+	/*
+	 * Note that the virtual swap slot can be freed under us, for instance in
+	 * the invocation of mem_cgroup_swapin_charge_folio. We need to wrap the
+	 * entire lookup in RCU read-side critical section, and double check the
+	 * existence of the swap descriptor.
+	 */
+	rcu_read_lock();
+	desc = vswap_iter(&cluster, entry.val);
+	ret = desc ? desc->memcgid : 0;
+	if (cluster)
+		spin_unlock(&cluster->lock);
+	rcu_read_unlock();
+	return ret;
+}
+#endif /* CONFIG_MEMCG */
+
 int vswap_init(void)
 {
 	int i;
-- 
2.52.0


