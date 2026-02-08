Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F0AE0EF06F7
	for <linux-mm@archiver.kernel.org>; Sun,  8 Feb 2026 21:59:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 532486B00A2; Sun,  8 Feb 2026 16:59:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4C8716B00A3; Sun,  8 Feb 2026 16:59:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1EDE06B00A4; Sun,  8 Feb 2026 16:59:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id EA9096B00A2
	for <linux-mm@kvack.org>; Sun,  8 Feb 2026 16:59:09 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id B98A01B309D
	for <linux-mm@kvack.org>; Sun,  8 Feb 2026 21:59:09 +0000 (UTC)
X-FDA: 84422655618.10.DE2D765
Received: from mail-ot1-f52.google.com (mail-ot1-f52.google.com [209.85.210.52])
	by imf26.hostedemail.com (Postfix) with ESMTP id E0CC5140002
	for <linux-mm@kvack.org>; Sun,  8 Feb 2026 21:59:07 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=PQ9VZhM2;
	spf=pass (imf26.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.210.52 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770587947;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=e8bNI/GS1vV3CKrDoFoyeQFdwXdHl+beBAT/+JTFa9I=;
	b=nvr4vEUw2tC1EK43WE+MKBo3ZaIzWKpXpRotSta/GhrpRy4GUN6EIZcI6aUtzfHMlB9OUE
	SdM2z82YSbAdMFhb631F8vE7m8JIVfugJkk45epwKLtWDHDRQOQbGkdRDq1DO88qgBJlbK
	IZfjmvM8OmoHdnEI5cygnzkR1j5dAaw=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=PQ9VZhM2;
	spf=pass (imf26.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.210.52 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770587948; a=rsa-sha256;
	cv=none;
	b=mw0S4slC2sj+oYjy2JV6Db3mBnyx7dw6oJY9WxOW8l7W+mTsORnLXc13ztk7DkwNaXBZEZ
	+qc1uAhRw6yli0vWGbzzK84AgZogGsqy83StRFwFm8qVw8NrQbBviZvSy+nufZ37+YLixH
	15gIF+sDkSaUjAIPKDnBTH01fNJkIx4=
Received: by mail-ot1-f52.google.com with SMTP id 46e09a7af769-7cfd8ca8191so839431a34.3
        for <linux-mm@kvack.org>; Sun, 08 Feb 2026 13:59:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770587947; x=1771192747; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=e8bNI/GS1vV3CKrDoFoyeQFdwXdHl+beBAT/+JTFa9I=;
        b=PQ9VZhM2Hk+43yVBSmQkNVUNoZB0gVBgVtibf9rvpHQeF8hTHrZUvepVqv3UdfmjWW
         nUmTzy7wTlOOsVSQSKapAE8JVugkx3fFc+rwvcM0yyc4jhfXEAtEdel6DHJ0nLyN2gJE
         cN+AykNbl+8V0uF4T/OHwhezDZDYdPsXFl282XLw8J4ibQe1RJ2atdbQBaJipI5prrOB
         /DeNF+XmfyWENQqWDi1KCXEEeHi5jhbi3FTwN9UytBdEQ3rX6ZgooeNnxBLOeyDJxXvF
         xwPF2B2kHuHS+TfI3/ol1CM9ykAMoB1UTpEgB/yPpkZh+INxZM+AUt4dEHRq78hfsTsK
         EHKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770587947; x=1771192747;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=e8bNI/GS1vV3CKrDoFoyeQFdwXdHl+beBAT/+JTFa9I=;
        b=wX7y6IDhGbN0q2A7jr/EzWd3qrTLH7BfM51fG+mxEPPSH1tJF4LCr6jIGuJbOBfI8Z
         Lf3c5IVhNO3pZiSEJV16WzB8AeyN/cGk3ELPZcogi9HAXI8M8kMd5KVdGdAzNAMCNMF+
         SIsRC+3V74YpslKGScblUfhVxAja3TP11Kwtt5eFD8zMLsGFycMNeD5Q6+GSKOYMHkV+
         el/HpzYg/S+7gdIfphcgA0qdQITtpsLd9Fe+6yJtMgYVdUy5xRZ4kDfOe7QPBU7M6nH+
         Tch/mu5bXlNvHXFS370iAUgwXFTmO5Do7oiJnPDMm1rRuGa0bpHq1ixrpCxSqhV1fb/L
         ciCw==
X-Gm-Message-State: AOJu0YzXO49aeJvJyDGixRjSWZbg7og4Va9wMaZe4GiDgWtXj7G8G298
	Uios5P6Ix8kwMoASthppGCWJnYFr1IcumW+PQCgEMy/SlaMOQNvHREjjy3YFUDkcim+jyA==
X-Gm-Gg: AZuq6aL2vN4JlykX5yCS+2+0NDmGOuK4/RlV9Cf/0Xc80MleOJlRU1CfZhWqZ4exg/s
	s7Fz51XTciuLlc0p6ARSnxIfnM+PitYPnkwCNd1+YFTN/pvPkQRFKKuXQZBtBNisml+44ZWtMRw
	C63VqHiGVpHpWemi/OM/h1iZtivhOszJ4ugsQz4opflRO4RDKkqr3d0PeJjE/ZKwUcUdihDRC5J
	8NvDkt86VrAy/Xdfmepe32W6OTa244jbdjxsaoyGp8O/1rzF8SQ4G7QdpDvglnuZavzxYxaOZ/d
	+WRDXyDDG6W5WJNytDFry0MxITKwduro4EWB9Oq+ww7a0ocRzuSEMiy/9HjzFho/LkR41CSF3GJ
	wSQSYITeLBPbcvIYl7PcsPbdR7dYzenyqvLwgGgk61qLTdzX7NFCXaeYzHqiKtIG76Io+ekS87u
	i7eVgCnjP+vTzSqGyQWGHtTUfOL25wkFAl3w==
X-Received: by 2002:a05:6830:2b0e:b0:7cf:c485:be43 with SMTP id 46e09a7af769-7d4643e7eddmr5001314a34.7.1770587946806;
        Sun, 08 Feb 2026 13:59:06 -0800 (PST)
Received: from localhost ([2a03:2880:10ff:48::])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7d46470da04sm6394135a34.7.2026.02.08.13.59.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 08 Feb 2026 13:59:05 -0800 (PST)
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
Subject: [PATCH v3 12/20] swap: implement the swap_cgroup API using virtual swap
Date: Sun,  8 Feb 2026 13:58:25 -0800
Message-ID: <20260208215839.87595-13-nphamcs@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260208215839.87595-1-nphamcs@gmail.com>
References: <20260208215839.87595-1-nphamcs@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Stat-Signature: zuxas3y4sh4qed9ag4gaj9zqj515p4e6
X-Rspamd-Queue-Id: E0CC5140002
X-Rspam-User: 
X-HE-Tag: 1770587947-636421
X-HE-Meta: U2FsdGVkX1+tOT3x2su88aOQOjDOmKpxXHyeqqspZ5qLDhNe3FhT9eTsCT6QhzExAzBt7qhvQ0D+P8bh2ZROmNWmlewXDbh2gQLgI+MMEiqwz+9YaQjZFZ+uUAI2GU/43a448G4E0QWHLNELfueEj2264wnOv1ob9XCbUxSczlb7+nbIxXpHD8sVLGnIgY4dGit8EPiFqvpP7/m2Mrun4CkrvU6xrvUfevAY9IxAI8ro0ocQPd+iZv9dBbvl1aGZ3Db6BfrVyO+Tkjgh0OASbRdv3J9jhQlD8eIETOdVHrv1rnXHBBbYlH++baKeOdnJC30wdprQ96uTVVYzgB5zpUzKrOal6cHB/ZAVAnzeE3AGW+AGzlcgbco3Wj1VMn9YAbz1wEbaugUgmYTcRJp8Y9NhK9sgVCjTneGsib8K+RpBLmbynIFtasaj6FzZkop4LCnJjt8Xol4tUOc/+3KjqTlnj1zcb0rADdGY18rWMBh2lOf1EhU365Oq8PtyYj76H5Oq49ZopO/w/ZiJxZDZb43IjHgzorwBFazchkOHSo3q4HWpQZy2q7rpYZ7N53gmYvKGBSCh2hq4W9hrLgfFe6XztP1r2xKfTveH0q1lh0vrvbunBzVtKClfI0I9Y8T+p5WEjFcvTavp05IZelvmUmyEIZIVSaIOVdYUbz5J08yZsxxvBG5d+j8Nw1eah7u3tpB7UV/Ta+T11RivddXQYUOplK3F76lIE6OSwo1BA50TpclxfrlMqp15ftJbQJo22kC42Fd20mk7cKf4FqQu3D5MGIVTrqmmtpECQkYo4yhx7y3Blc1am7LQZuP7GKvu+5Teptep44iygQpDE9UCjlUE/rMyYOPgoegaUN1ZaRBBcgdpwxVrPKbtAfSpY6pV1kmbtdv6DRyOYiwWEeP+WcMuX2ttfKVlJs4atscE2wkAVsqkatxI/wnxrx3p3s3lp2E5FJR3xjtqNbxCfgl
 hhFUvxwr
 kLVovzySsTbCwQ+Z42no8HeD3ucyXHYR+mv13n/Oi7pYFihJluXWFeP3HLOU0/22g5esHU8JSB+oaGRjSWZvAsAXDNiUMFEnTLe9nRMk/Pxp7BuC9go8JpHBnwPjTzvS4rdaufsUMl1L16tvmBHrfax/1xq8EnC/AvhQ7H922KNE4NnQPXJw5FfBlQa1oWys4e+28w8cbxR6ZMxNOLHa0tPOPIJAB9gVSVtMcNRk7YlafJnTAp59YmUlbdW3zhiyE/FVbICiVTXkSZ1V2ecOLv6Bk3jFi0UpajXlwm4bN1E5GE7+KjS7McRWVVcl8K2/k0Oki3hHGk945bma4lZyazv+p+wBQQyc/mEx2wdr9YQ7uIB+GVZVFrrZVk+JbTgioWf2oJqzYaDjEKGFmITLB7aS3AtxaCdZoh5C8dShUvbZOZJgBRvFW+1IpBuxE5UlihCInvompTV9PAVNEpiEmVKNZsF860a3pzVzuGcyZBm+3p3RU5Vpui7SNhKSvorBumk5J1Zvxx7DH6lROI4M8Nr7gxdbU0Zp6bKGHgHXRTyuRgmAniey4o/vOZfgRHrdbfO+3jwzDeaMWpiw=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
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
 include/linux/swap_cgroup.h |  13 ---
 mm/Makefile                 |   3 -
 mm/swap_cgroup.c            | 174 ------------------------------------
 mm/swapfile.c               |   7 --
 mm/vswap.c                  |  95 ++++++++++++++++++++
 5 files changed, 95 insertions(+), 197 deletions(-)
 delete mode 100644 mm/swap_cgroup.c

diff --git a/include/linux/swap_cgroup.h b/include/linux/swap_cgroup.h
index 91cdf12190a03..a2abb4d6fa085 100644
--- a/include/linux/swap_cgroup.h
+++ b/include/linux/swap_cgroup.h
@@ -9,8 +9,6 @@
 extern void swap_cgroup_record(struct folio *folio, unsigned short id, swp_entry_t ent);
 extern unsigned short swap_cgroup_clear(swp_entry_t ent, unsigned int nr_ents);
 extern unsigned short lookup_swap_cgroup_id(swp_entry_t ent);
-extern int swap_cgroup_swapon(int type, unsigned long max_pages);
-extern void swap_cgroup_swapoff(int type);
 
 #else
 
@@ -31,17 +29,6 @@ unsigned short lookup_swap_cgroup_id(swp_entry_t ent)
 	return 0;
 }
 
-static inline int
-swap_cgroup_swapon(int type, unsigned long max_pages)
-{
-	return 0;
-}
-
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
index 68ec5d9f05848..345877786e432 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -2931,8 +2931,6 @@ SYSCALL_DEFINE1(swapoff, const char __user *, specialfile)
 	vfree(swap_map);
 	kvfree(zeromap);
 	free_cluster_info(cluster_info, maxpages);
-	/* Destroy swap account information */
-	swap_cgroup_swapoff(p->type);
 
 	inode = mapping->host;
 
@@ -3497,10 +3495,6 @@ SYSCALL_DEFINE2(swapon, const char __user *, specialfile, int, swap_flags)
 		goto bad_swap_unlock_inode;
 	}
 
-	error = swap_cgroup_swapon(si->type, maxpages);
-	if (error)
-		goto bad_swap_unlock_inode;
-
 	error = setup_swap_map(si, swap_header, swap_map, maxpages);
 	if (error)
 		goto bad_swap_unlock_inode;
@@ -3605,7 +3599,6 @@ SYSCALL_DEFINE2(swapon, const char __user *, specialfile, int, swap_flags)
 	si->global_cluster = NULL;
 	inode = NULL;
 	destroy_swap_extents(si);
-	swap_cgroup_swapoff(si->type);
 	spin_lock(&swap_lock);
 	si->swap_file = NULL;
 	si->flags = 0;
diff --git a/mm/vswap.c b/mm/vswap.c
index 9bb733f00fd21..64747493ca9f7 100644
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
@@ -1109,6 +1116,94 @@ bool zswap_empty(swp_entry_t swpentry)
 }
 #endif /* CONFIG_ZSWAP */
 
+#ifdef CONFIG_MEMCG
+static unsigned short vswap_cgroup_record(swp_entry_t entry,
+				unsigned short memcgid, unsigned int nr_ents)
+{
+	struct vswap_cluster *cluster = NULL;
+	struct swp_desc *desc;
+	unsigned short oldid, iter = 0;
+	int i;
+
+	rcu_read_lock();
+	for (i = 0; i < nr_ents; i++) {
+		desc = vswap_iter(&cluster, entry.val + i);
+		VM_WARN_ON(!desc);
+		oldid = desc->memcgid;
+		desc->memcgid = memcgid;
+		if (!iter)
+			iter = oldid;
+		VM_WARN_ON(iter != oldid);
+	}
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
2.47.3


