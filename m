Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2F711CAC599
	for <linux-mm@archiver.kernel.org>; Tue, 16 Sep 2025 16:02:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 883268E0021; Tue, 16 Sep 2025 12:02:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 85AA68E0001; Tue, 16 Sep 2025 12:02:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 776878E0021; Tue, 16 Sep 2025 12:02:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 668068E0001
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 12:02:23 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 3A346B7408
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 16:02:23 +0000 (UTC)
X-FDA: 83895580566.18.66C8C35
Received: from mail-ot1-f42.google.com (mail-ot1-f42.google.com [209.85.210.42])
	by imf26.hostedemail.com (Postfix) with ESMTP id 10D03140004
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 16:02:20 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=WSA39apG;
	spf=pass (imf26.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.210.42 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758038541;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xdHPoxeBxMdMqxDIR/SvXJLUUbVQxnjhjl+U1+Q8Oxs=;
	b=6tnHxGdnlaSciJUmiDGntNKbXFEVP0R4erDY2IaD7GDYOjTSknDvul2OYIdP0Vlg9UjTiI
	+jLVq8JK/fsdj2Lk3mBW2RQmyGpuuUXHLXIog59cU2KED4wEf0P2Wythb0SxGR7fCyAklw
	80akzxJZ0YUy3c1tcpVoZgBZ8Sb2/bo=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=WSA39apG;
	spf=pass (imf26.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.210.42 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758038541; a=rsa-sha256;
	cv=none;
	b=I3KU75FcJMPoJAcb58rjjP1OGe/mUz66xWjFiNSL4bHViV7UjxA+xuQhNUwmVnM5NQxVzE
	I25KW6mOZ9upucaKMfv0++aLvsDu4cwi09sO2Cnmz6yPTuuwhXyvWyb0qMbWBLgTph2V6y
	k7N7jdT4M6/3QXZDGH//gx5BcdWgn+E=
Received: by mail-ot1-f42.google.com with SMTP id 46e09a7af769-74381df387fso2548797a34.0
        for <linux-mm@kvack.org>; Tue, 16 Sep 2025 09:02:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758038539; x=1758643339; darn=kvack.org;
        h=content-transfer-encoding:mime-version:reply-to:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to;
        bh=xdHPoxeBxMdMqxDIR/SvXJLUUbVQxnjhjl+U1+Q8Oxs=;
        b=WSA39apGio/XpQICb5p/LGCyXXG8D+HDODP5RH/re04rUnk6o/yABBMYWhy4a350BM
         PNpDxLpwa7loWX0aTYT8MxNFw1ndiwvthwNpD4DDxoeIG7Bth458quIrNI1lNiWLHHaj
         7EIgWD3opkHULcLJESzbi8pqXOovASgomSrjt6LOGgC1ACry3SNqedOxvZmL5iqrDTsR
         iDGE2BiCrRqQNOKXcYXTHGY+By4D+wgwnJ28yGpauQAKwDzrO2T7Lb82ScKzuXfbGF7K
         Iz4katfUt/m5d7YPty8ARslmNzioDufIPuLxjjwKi07oClOa5Jk5GzUxP15b540p/tOO
         2ZFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758038539; x=1758643339;
        h=content-transfer-encoding:mime-version:reply-to:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=xdHPoxeBxMdMqxDIR/SvXJLUUbVQxnjhjl+U1+Q8Oxs=;
        b=O6f4T0XcFr6sAtcESabUlyRggQ7205OKpIHZQKBS3CwJsfuJ5QgunGlBQxPCfhUB15
         p0p5E4xAJln4WTVUk2BS0KZ1k5lZmQLP36+/vKmUj7TfmyiNlvgfLdnsePr5oM37/+2l
         o5Xc/Ox4FeysNzljcOwIVNUdK/VxJkSnURcf5Llm7rIUsrwvVdaLCyEXgegK0BYITuPz
         peBa/fJWQlZ21NMMoLWEABcSI6eh//I/KgIIkc5k9EVmwEOfmb3BZVGaGGXvglklGjz9
         7V2+lgsbJ6l6ikPN5xKtQk7UWhK4y35MFmH0UL4SUwSmmVzCWq3TsZi51AN9h6KxY5wK
         1fsg==
X-Gm-Message-State: AOJu0YyNJZGfLB7StA83G822kokt8wmeKOBe5jG8ohQlR/Tsty6N87Rd
	XNIgZxtzPEY/8WbfiBf6nA5BYHFO1nuIMcBY5DDBq7dsavM+E7bMWSGexbRBm7W2fxk=
X-Gm-Gg: ASbGnct7ZsvYrc2nQFMWLnZAGfBydayV244qlbQufqJbCanXOwnNtO5yNf98ZdraCk0
	WcuXeZpjaaefEAt+w0xade2xWWE6jR/VVDI/N+JynHnKeYDD996Nir8kLRlg5vmYJOuuG6ZkoaB
	UBzo/YMvcz/XT0Em7/zmVx51TGfSNLWQNEP10YfB6WogGLd9AJSs8EbB2K4ga9OdRVebevMHEvs
	NpPSZDhbiRN22IXYy50xaF5Sz3o4+ojI+LF5M7DPa7xNeU6E7dxfuHm130Nqf1mDGzm2uL5c2mC
	M45tm9+0mWjCrbRBofpFyp0xonER/WtvD0UmG94VcgbXgEyhA4IArR9KoDpcFkOpI4ZB+TH3CNk
	JDs/75KcOeft5jUcoPEbz6YHwW+lrTFCDAl0KR5xbLcxmooc=
X-Google-Smtp-Source: AGHT+IGHbYZsTFdHhkmVtFce8cMHp88HQXSjVc3SOFLAhgMSHQs6ZKwPtqA2adX5VFTn7SKvgD08Jg==
X-Received: by 2002:a05:6808:8801:b0:43d:1f40:754a with SMTP id 5614622812f47-43d1f408e97mr4480015b6e.10.1758038537425;
        Tue, 16 Sep 2025 09:02:17 -0700 (PDT)
Received: from KASONG-MC4.tencent.com ([101.32.222.185])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-820cd703f54sm969765485a.37.2025.09.16.09.02.11
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 16 Sep 2025 09:02:16 -0700 (PDT)
From: Kairui Song <ryncsn@gmail.com>
To: linux-mm@kvack.org
Cc: Kairui Song <ryncsn@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Matthew Wilcox <willy@infradead.org>,
	Hugh Dickins <hughd@google.com>,
	Chris Li <chrisl@kernel.org>,
	Barry Song <baohua@kernel.org>,
	Baoquan He <bhe@redhat.com>,
	Nhat Pham <nphamcs@gmail.com>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	David Hildenbrand <david@redhat.com>,
	Yosry Ahmed <yosryahmed@google.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Zi Yan <ziy@nvidia.com>,
	linux-kernel@vger.kernel.org,
	Kairui Song <kasong@tencent.com>
Subject: [PATCH v4 10/15] mm, swap: wrap swap cache replacement with a helper
Date: Wed, 17 Sep 2025 00:00:55 +0800
Message-ID: <20250916160100.31545-11-ryncsn@gmail.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250916160100.31545-1-ryncsn@gmail.com>
References: <20250916160100.31545-1-ryncsn@gmail.com>
Reply-To: Kairui Song <ryncsn@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 10D03140004
X-Stat-Signature: ibtaufwh5dkxbapepb78ow3fxoyxufhe
X-HE-Tag: 1758038540-784100
X-HE-Meta: U2FsdGVkX1/ewJXp0waHMvMdJvYJaPVBNRIexBGY/uV8qsPsIqoSBvcv8pIq7YaGD/O7uSLTDLV7asXF4K97FJrGXdWQvAmIPDA6tjcLZxsUMkEkxgFgKsatcIlmG979g8UlN3SYs1em5Y0DPip+/WUts848gVw3x3mHEMjNxBS0R80Lpnl0DqiY1ZbRPYDM+pm1vuznXtP+vzwu8AE75QbYreZVZJoSTw9aIBhnhafDRMvSjCPBQL1fPq3Ueyc1cgZC3OcJvt0FXeG7UlwQPhqP9k3vrVyJncjVOd6qmFOziEhBd+n1yKMXvSeWnxGSyZy4ca5iSE2ZBafhPoW6650wuUNRis+rr/z42b1Sb8IDaU4ytlCOQz59f5xb/puYQyodsqW1FDMRK8+XwgeT3G3IKeYYp35en4GmaFrfR+SmPbQlhd549Z2R8bCirgDIXa0AMQ2cwBtVIx0eCE/IFNmZTk+8xWHQS3nTxLu7AJWLGPeAm7jgn6AobuzRVrZSDy7g/kZw7gwns7VgKLdEHi0laKQjZonkTpDcKzO7pNno0ffsfY37OzKebVWHdV9IJ7THGfFR+xJNusGKsdzJdOyTcMSnoHDoBEhoCCe4/CpE/vExfXO6MS2KamQ88E5ZCHrzYaMiNlQ97D7rxToNRwNxI6Ps4ytYRfGU14+LmSQn/uRjADv1EwVhVuCmDSOuONx3rWQ8pHie+N6wXogFxR8HAevFDWzD1QPc7LQDalgDEnk7vA98RxOLAWdFbDvQiJHqZWpVPTsKrE706+XdYidQSkQx8Gx9o0MELtdhuCRlJvm1S9SbaAQ/57blZi93nvjJ97DklBMhL4+KPnmyinON+Vl9bVXYW5Oucc/q/nkbZC2PeMgIhUxfl3jQMg2/3USZPVIqUz8KIVL8Edn7A6khtHePz3eaiqHO+PWk3ieIlEWiolBiU8pQfPRR7qmeaWDZ3IQALpcy16oJcKe
 ljY1S9mj
 6lgIOsougVO2JwQK3Zaw6OLuu2ZzHgpRlMFHcSWubl5GwmsauYXcTJexu4t7x2iTXc8xsw0jUlzIKcuRT2fIC+PxbmbuHkFtbytgGR0UKSqfRTj18TeZRgqdU/RjLVEwQaCPRX4jr1Do3K5l4ZKcQGxHhZ04kMJFgYiWEf6DdQAO8p5XaWCqICN5VTnoxB4sOKL845TIMCoO2cRhIb302mE26rCxy0Ng/AFxZa8j98fxQU8sWnjdXtHYjbkD3B4G7dosnJfy/pJ2vGVNs00nshZdpw4WVr1g6NXt78aoiB3uGp+ueX+Z4xA4O9fLXa7wVCbKALTtgjngcR0sQl+YMXck0ZDS9mSpdYzPrH1U1ukUPzRqtD7ISRFAXX/XPfJZLL0I+l9p6WnepR+8xnwibJtJUGHrsK6jupYyYzC3pZau0Pkk6y4MePfX6iF032Rbh2fdD972VPj70EU4maGK4bw9DhZBtgzkph6cvgKlZHRbfkBB9I5SnfKfXbzoOOePNtQ0XzgMOr+a9ClKVt8gF389Ss/pUINttIruziHKbFO/v4dX5/eCzU94LQSk2ZYUchTHaGy1ffArKf1URglPyvHZdA/ANm3d0l/vX8Iw0uu80q/pWNhWSNoFA6iSoWG0CTZ7+
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kairui Song <kasong@tencent.com>

There are currently three swap cache users that are trying to replace an
existing folio with a new one: huge memory splitting, migration, and
shmem replacement. What they are doing is quite similar.

Introduce a common helper for this. In later commits, this can be easily
switched to use the swap table by updating this helper.

The newly added helper also makes the swap cache API better defined, and
make debugging easier by adding a few more debug checks.

Migration and shmem replace are meant to clone the folio, including
content, swap entry value, and flags. And splitting will adjust each
sub folio's swap entry according to order, which could be non-uniform in
the future. So document it clearly that it's the caller's responsibility
to set up the new folio's swap entries and flags before calling the helper.
The helper will just follow the new folio's entry value.

This also prepares for replacing high-order folios in the swap cache.
Currently, only splitting to order 0 is allowed for swap cache folios.
Using the new helper, we can handle high-order folio splitting better.

Signed-off-by: Kairui Song <kasong@tencent.com>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Acked-by: David Hildenbrand <david@redhat.com>
Acked-by: Chris Li <chrisl@kernel.org>
---
 mm/huge_memory.c |  4 +---
 mm/migrate.c     | 11 +++--------
 mm/shmem.c       | 11 ++---------
 mm/swap.h        |  5 +++++
 mm/swap_state.c  | 33 +++++++++++++++++++++++++++++++++
 5 files changed, 44 insertions(+), 20 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 26cedfcd7418..4c66e358685b 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -3798,9 +3798,7 @@ static int __folio_split(struct folio *folio, unsigned int new_order,
 			 * NOTE: shmem in swap cache is not supported yet.
 			 */
 			if (swap_cache) {
-				__xa_store(&swap_cache->i_pages,
-					   swap_cache_index(new_folio->swap),
-					   new_folio, 0);
+				__swap_cache_replace_folio(folio, new_folio);
 				continue;
 			}
 
diff --git a/mm/migrate.c b/mm/migrate.c
index 8e435a078fc3..c69cc13db692 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -566,7 +566,6 @@ static int __folio_migrate_mapping(struct address_space *mapping,
 	struct zone *oldzone, *newzone;
 	int dirty;
 	long nr = folio_nr_pages(folio);
-	long entries, i;
 
 	if (!mapping) {
 		/* Take off deferred split queue while frozen and memcg set */
@@ -615,9 +614,6 @@ static int __folio_migrate_mapping(struct address_space *mapping,
 	if (folio_test_swapcache(folio)) {
 		folio_set_swapcache(newfolio);
 		newfolio->private = folio_get_private(folio);
-		entries = nr;
-	} else {
-		entries = 1;
 	}
 
 	/* Move dirty while folio refs frozen and newfolio not yet exposed */
@@ -627,11 +623,10 @@ static int __folio_migrate_mapping(struct address_space *mapping,
 		folio_set_dirty(newfolio);
 	}
 
-	/* Swap cache still stores N entries instead of a high-order entry */
-	for (i = 0; i < entries; i++) {
+	if (folio_test_swapcache(folio))
+		__swap_cache_replace_folio(folio, newfolio);
+	else
 		xas_store(&xas, newfolio);
-		xas_next(&xas);
-	}
 
 	/*
 	 * Drop cache reference from old folio by unfreezing
diff --git a/mm/shmem.c b/mm/shmem.c
index dc17717e5631..bbfbbc1bc4d6 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -2086,10 +2086,8 @@ static int shmem_replace_folio(struct folio **foliop, gfp_t gfp,
 	struct folio *new, *old = *foliop;
 	swp_entry_t entry = old->swap;
 	struct address_space *swap_mapping = swap_address_space(entry);
-	pgoff_t swap_index = swap_cache_index(entry);
-	XA_STATE(xas, &swap_mapping->i_pages, swap_index);
 	int nr_pages = folio_nr_pages(old);
-	int error = 0, i;
+	int error = 0;
 
 	/*
 	 * We have arrived here because our zones are constrained, so don't
@@ -2118,13 +2116,8 @@ static int shmem_replace_folio(struct folio **foliop, gfp_t gfp,
 	new->swap = entry;
 	folio_set_swapcache(new);
 
-	/* Swap cache still stores N entries instead of a high-order entry */
 	xa_lock_irq(&swap_mapping->i_pages);
-	for (i = 0; i < nr_pages; i++) {
-		WARN_ON_ONCE(xas_store(&xas, new) != old);
-		xas_next(&xas);
-	}
-
+	__swap_cache_replace_folio(old, new);
 	mem_cgroup_replace_folio(old, new);
 	shmem_update_stats(new, nr_pages);
 	shmem_update_stats(old, -nr_pages);
diff --git a/mm/swap.h b/mm/swap.h
index 6c4acb549bec..fe579c81c6c4 100644
--- a/mm/swap.h
+++ b/mm/swap.h
@@ -185,6 +185,7 @@ int swap_cache_add_folio(struct folio *folio, swp_entry_t entry,
 void swap_cache_del_folio(struct folio *folio);
 void __swap_cache_del_folio(struct folio *folio,
 			    swp_entry_t entry, void *shadow);
+void __swap_cache_replace_folio(struct folio *old, struct folio *new);
 void swap_cache_clear_shadow(int type, unsigned long begin,
 			     unsigned long end);
 
@@ -336,6 +337,10 @@ static inline void __swap_cache_del_folio(struct folio *folio, swp_entry_t entry
 {
 }
 
+static inline void __swap_cache_replace_folio(struct folio *old, struct folio *new)
+{
+}
+
 static inline unsigned int folio_swap_flags(struct folio *folio)
 {
 	return 0;
diff --git a/mm/swap_state.c b/mm/swap_state.c
index f3a32a06a950..d1f5b8fa52fc 100644
--- a/mm/swap_state.c
+++ b/mm/swap_state.c
@@ -234,6 +234,39 @@ void swap_cache_del_folio(struct folio *folio)
 	folio_ref_sub(folio, folio_nr_pages(folio));
 }
 
+/**
+ * __swap_cache_replace_folio - Replace a folio in the swap cache.
+ * @old: The old folio to be replaced.
+ * @new: The new folio.
+ *
+ * Replace an existing folio in the swap cache with a new folio. The
+ * caller is responsible for setting up the new folio's flag and swap
+ * entries. Replacement will take the new folio's swap entry value as
+ * the starting offset to override all slots covered by the new folio.
+ *
+ * Context: Caller must ensure both folios are locked, also lock the
+ * swap address_space that holds the old folio to avoid races.
+ */
+void __swap_cache_replace_folio(struct folio *old, struct folio *new)
+{
+	swp_entry_t entry = new->swap;
+	unsigned long nr_pages = folio_nr_pages(new);
+	unsigned long offset = swap_cache_index(entry);
+	unsigned long end = offset + nr_pages;
+
+	XA_STATE(xas, &swap_address_space(entry)->i_pages, offset);
+
+	VM_WARN_ON_ONCE(!folio_test_swapcache(old) || !folio_test_swapcache(new));
+	VM_WARN_ON_ONCE(!folio_test_locked(old) || !folio_test_locked(new));
+	VM_WARN_ON_ONCE(!entry.val);
+
+	/* Swap cache still stores N entries instead of a high-order entry */
+	do {
+		WARN_ON_ONCE(xas_store(&xas, new) != old);
+		xas_next(&xas);
+	} while (++offset < end);
+}
+
 /**
  * swap_cache_clear_shadow - Clears a set of shadows in the swap cache.
  * @type: Indicates the swap device.
-- 
2.51.0


