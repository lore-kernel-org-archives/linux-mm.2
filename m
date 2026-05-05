Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 83D4ECD343F
	for <linux-mm@archiver.kernel.org>; Tue,  5 May 2026 15:39:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6A6BD6B00AE; Tue,  5 May 2026 11:39:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 67E8E6B00AF; Tue,  5 May 2026 11:39:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4832B6B00B0; Tue,  5 May 2026 11:39:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 3036A6B00AE
	for <linux-mm@kvack.org>; Tue,  5 May 2026 11:39:28 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id EAE0D14052D
	for <linux-mm@kvack.org>; Tue,  5 May 2026 15:39:27 +0000 (UTC)
X-FDA: 84733775574.21.05E7966
Received: from mail-ot1-f50.google.com (mail-ot1-f50.google.com [209.85.210.50])
	by imf26.hostedemail.com (Postfix) with ESMTP id 04969140012
	for <linux-mm@kvack.org>; Tue,  5 May 2026 15:39:25 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=bluHBDwv;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf26.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.210.50 as permitted sender) smtp.mailfrom=nphamcs@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777995566; a=rsa-sha256;
	cv=none;
	b=nCM3vAh6V5Kgh0nJGCUjPY8m3MvleCLJ/Urwk0zj9FnO/8qtdMn/Lotkp9IBraLHVd2D7H
	UMhIG8S20SGZQ/hcK0aAHJ3MSUmGiIiY5IllFBFJ0ubcMjRpWbLVV3dD8D+VCgyqYhXivi
	r6MXGwIkjoT4zVtOJ7El2TQA0br84bg=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=bluHBDwv;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf26.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.210.50 as permitted sender) smtp.mailfrom=nphamcs@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777995566;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1iWhNRQ/BjX4vM08TzPXcDtOAMxQqfUACU7NnRIKH+E=;
	b=v04eQcFR7vwM4CP2TP8Do/rfP0122D9/8d2PlaRXgCY+stObP6Aot9535mMpBIA3Cl++B/
	vk7UgQhb8FcGat8ag/5pKndYtt0lKg+yfl0YMPXbhv68jqq6HG6BEZ9ErNy2WydOie2o8D
	aHA0Ny4LVvk+nJjsaA4fOt4XChrNBeM=
Received: by mail-ot1-f50.google.com with SMTP id 46e09a7af769-7dbccf6a23dso4775128a34.2
        for <linux-mm@kvack.org>; Tue, 05 May 2026 08:39:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1777995565; x=1778600365; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1iWhNRQ/BjX4vM08TzPXcDtOAMxQqfUACU7NnRIKH+E=;
        b=bluHBDwvIs0L39/yylGEugKQaXCthfIpxn+h8GP8jVZUWjTs78Lp73eRqzzx5y/LWz
         KEa4RMew4ijxVXx6cdirUuni3EkJEcxdDJ37vuNIfLdzGBz3sSOV1U86EE/weK1D1Ii6
         ptu/IaZb4KKjhjc7/nK55fXr6RWIdDHS01j5eLSJhdecco0FHLxQmblXbJlItgM4uQof
         Qt4gduDS91bgD9AkqUfareH8SdQ17+R0OGSSEFll6nmadXBWNX3BchG92oQ/WAbp+dbU
         7sLfPzCO6PpwjLKCUibrmrhYTZg3hA+OxHuEnD0U9d7LlgkaSj8iVy6Tk20QAjuRtRju
         xY8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777995565; x=1778600365;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=1iWhNRQ/BjX4vM08TzPXcDtOAMxQqfUACU7NnRIKH+E=;
        b=JY3i9/8L7iM+FD+ocMiPGrbz8dp9Ft+LmqAABctfngVykqUhz1HqKH4haSRiphnU9n
         nEumOmREWlMIPJWJdUxpad3rrFJxUS42B+1nnmcpIzuLEFnZJVD5EaVmSUwAgPw8k6iF
         /pcCvL8mVQ212rXlvhVMRVNYElvJijZTMFV4McHo6a37hzcRkm556mHsP+1eDOIcJpF0
         VPyORkJYRwZ2hCdU9zU6hAI7Dkb8Gy2a5y6BItUFdriv9/Gz4rVZyVjRA/18PDvS4RTs
         4/6UWPYxyIqqZ6g29GMbFuMHp1sqMx7RyKT9c54T+h5QMGzAHskpkO63BsIwOzZfyna2
         qwIQ==
X-Forwarded-Encrypted: i=1; AFNElJ9w3RlD13hXkukyR600jt8ZQlEzR5XEpR53lHoQDy4AU9Yh8MTbZDByV7Ub/op0daKQiuNok6kaDA==@kvack.org
X-Gm-Message-State: AOJu0YyllsdPxVuap2OICEIDTHHLwctKVJ1xXcP+F3GEgdynBtlllq3o
	uEcgHR5DD75tIkRcmIrYWXGjiIxRHeZS0XvpwR+8EHQdZufaqEywjii9
X-Gm-Gg: AeBDiet84LT4BVJ++An6f4TEX8X5Az2E06bPAX3KXRvwVmMeMtdt75FiCRokGTKuEGV
	bTj/v9QH/qs8JAjFhh2Sf4c0LAlMZtIeMPGohXyyPfm/tpFSRhPjpg7gd5VIzuqwlyBO4copucC
	0bOIHAPdMazrmRbfs+If3TDKz/hx0sazAuhcK9v/5OhlGomVG/bJB08QbVyPz4EuffzdV8k21EP
	fLZOzEeme/H2D2zWdGt1kDhpwDOVLVA17QdJx6JNG+Ay6NEG8rZcKjVERh1HnR5/ujsM32Wtubh
	UzxLBPaqO4eauDs5qKELFgfLPOBLAmzj8Cl1DMIbIv53KBuLL0/WoCXZBJKiJWt4ArmGPyz/xvY
	0PNGkEAMmQ4NKvaMAd0ub2nyLdTm6N8EsxD7kk6aC0gsnLSZGJzOVt3ohoYcXySnyXeQwHGxE9y
	o5+LtpYjzkAA+bpxBRjB6DOz8iSIQSHIQHhxpJYsVOhz4v7WbdEE1bAKgz
X-Received: by 2002:a05:6830:81f0:b0:7d7:d524:bc8a with SMTP id 46e09a7af769-7dee126583amr8194076a34.9.1777995564773;
        Tue, 05 May 2026 08:39:24 -0700 (PDT)
Received: from localhost ([2a03:2880:10ff:56::])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7ded51a9612sm9219094a34.26.2026.05.05.08.39.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 May 2026 08:39:24 -0700 (PDT)
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
Subject: [PATCH v6 12/22] swap: implement the swap_cgroup API using virtual swap
Date: Tue,  5 May 2026 08:38:41 -0700
Message-ID: <20260505153854.1612033-13-nphamcs@gmail.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260505153854.1612033-1-nphamcs@gmail.com>
References: <20260505153854.1612033-1-nphamcs@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: n6erycuaeyp46fgqxwrqd56iadz3ja6t
X-Rspam-User: 
X-Rspamd-Queue-Id: 04969140012
X-Rspamd-Server: rspam07
X-HE-Tag: 1777995565-920225
X-HE-Meta: U2FsdGVkX18PbhU2n2WNWTN+beQJAtWrVesL6ddrkYooc4DXvZAXis8T3Fd+tz0hlrQKW3MGREaZZf+fgPKVscZsE6qQfC4LGwc6o3imAsXSmLPxpTKYDYliu2rxklGl8hEGEAcgmGhuBofrkpGeEJdsZIPYgJlAdGJbEI4sztpQQUt8h2Xd+Wm9sLL0QCLahNxvh/ie+NhFeEg1RqH5FZmx5TZgWBz3xOurVV5U9F/M6Z3m85Q/mwoPhXzZRJ+coAb97f5Uuow2QwcNgX0E/x6dDWdLIoZBujjLQZBIhp1+kN20XGvFXhDGIV721sd6NNIHWMYGbf+a/FCRdjkNH82xNs4WiYk4K42/7kxtEygVWFUjv0lVFoBs5nsmedXNJLfr9839koYrFA3EPEvGX7xwWT+5t1FMFe/1PLXaOyiMtgOUS2mfU9Yy8o31xn7InK1t9dJezapIl0OCiixzeFqRS+bzcP9NLboTEsRYX8H4Af5t4ndA4j7aJHOs/+CYI9OeT1JeH0NsWya0uxDhhp4hSqBLVmqkJD0dfTV0y2mXXh1fO9KJcZ+2BMMIdDa7hsjupdJWLpsx17gUrOWoIh9j4mIWq/guRTOBHh2c/GtvKayogoSPOvffG2O65EpwzEpGKCx5mX9Ths4jFsmF0Qn23Ku1B7IHlxRRD6jqdMXcISUQM7ThYJW6AYEekhEGNKgP3Cw4pGpR7cRiK8b89mprCT5KlmxRAxcwbZa5UtssZKEl/hNcThbDfEu952Z/bvOPHyndqKdLP1hQlRJyhN98Paub6HBRw1PaxjGY4AndzcDYaRJ8VoEeQfv7/UYH8kHlXBMFBPE4g21NZ38LwtowNvUDA9EDfoIRr4oj1hRJ1cmSTPHQzA3ZWhOqLCVDZ6Hr/CcWQ9ymTmcarGQ2i7KAXKU/wPbRPiz4bF0n65rXyB+oTy+VSdHQk1bgkTo/O5W/8XNOpBvL4hWNAPD
 +DltSXfs
 nYM2wS9DzOPJkD338OyenHfQvXj42i53dOteeZB0zZUXcTgM6EDPNGUUXqStR75inExrwYbbbFCldukxFoZi5BK8RDSWW5YtBgLEGyZCIhnZRDnrg2kdC1Om3QCchObRNW2SZ5em/SUR6/0tNCQfVK/sZBqeOSxgV0IAJv7pUuuwtf522BAPgyNewnOxIIun48X6hNhljw9VGU0AYGBv7zTXDVFsF/s6SlzhRfOTd+2MeCIzH4+0bNvWivgTKWOSGhCK68/SiZHuSep1V7ruGQUFMwNFJGvR8alx8iTuZS7DNg06EoGzxzd1btBwARg91YbdFADjYrFoK1CLDDdcEBv6MPF4TDSzJw0rWou6Agx6gU2WpolIDbhx+xGOPKWrVLJjHWHowVO7q36I15IfhPn5oaSWn8XbwlpXm4K04Ff2GEY1deSkofAGJodk3YaGVtwWlCAqeCze60lTjhxXuxU6keWbXg0UhimG6HU0dCIoMzLRlDpYIfE5UCxl7kzhbGD0ujzEx2Pra4le2fLb+lga5UTyk29nuMpQNfSZXzCLyVNI32nPvkab4wCbGnkkFNvWzBhyalqnxf12w/KT9vU0eXNMOHsEGOFyeENjy87XQYDNFO69R2p2I83H2WQcbWpotwqAb0buVgfVioq72aYJ8pN6nq+bKtN96v44hXZiJXLg=
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
 MAINTAINERS                 |   1 -
 include/linux/swap_cgroup.h |  17 ++--
 mm/Makefile                 |   3 -
 mm/memcontrol-v1.c          |   2 +-
 mm/swap_cgroup.c            | 174 ------------------------------------
 mm/swapfile.c               |   7 --
 mm/vswap.c                  | 142 +++++++++++++++++++++++++++++
 7 files changed, 148 insertions(+), 198 deletions(-)
 delete mode 100644 mm/swap_cgroup.c

diff --git a/MAINTAINERS b/MAINTAINERS
index 042dbc06c3d3..04b833f24fd6 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -6462,7 +6462,6 @@ F:	mm/memcontrol.c
 F:	mm/memcontrol-v1.c
 F:	mm/memcontrol-v1.h
 F:	mm/page_counter.c
-F:	mm/swap_cgroup.c
 F:	samples/cgroup/*
 F:	tools/testing/selftests/cgroup/memcg_protection.m
 F:	tools/testing/selftests/cgroup/test_hugetlb_memcg.c
diff --git a/include/linux/swap_cgroup.h b/include/linux/swap_cgroup.h
index 91cdf12190a0..a5b549a9ba3c 100644
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
index 67fa4586e7e1..a7538784191b 100644
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
index 6eed14bff742..7b010e165e1b 100644
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
index 77ce1d66c318..000000000000
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
index a47e024f2152..adfcce286258 100644
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
index fad1fd86e0f5..170d55289fa0 100644
--- a/mm/vswap.c
+++ b/mm/vswap.c
@@ -42,6 +42,7 @@
  * @zswap_entry: The zswap entry associated with this swap slot.
  * @swap_cache: The folio in swap cache.
  * @shadow: The shadow entry.
+ * @memcgid: The memcg id of the owning memcg, if any.
  */
 struct swp_desc {
 	swp_slot_t slot;
@@ -50,6 +51,9 @@ struct swp_desc {
 		struct folio *swap_cache;
 		void *shadow;
 	};
+#ifdef CONFIG_MEMCG
+	unsigned short memcgid;
+#endif
 };
 
 #define VSWAP_CLUSTER_SHIFT HPAGE_PMD_ORDER
@@ -245,6 +249,9 @@ static void __vswap_alloc_from_cluster(struct vswap_cluster *cluster, int start,
 		desc = &cluster->descriptors[start + i];
 		desc->slot.val = 0;
 		desc->zswap_entry = NULL;
+#ifdef CONFIG_MEMCG
+		desc->memcgid = 0;
+#endif
 		desc->swap_cache = folio;
 	}
 	cluster->count += nr;
@@ -1134,6 +1141,141 @@ bool zswap_empty(swp_entry_t swpentry)
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


