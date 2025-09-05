Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 12330CA1017
	for <linux-mm@archiver.kernel.org>; Fri,  5 Sep 2025 19:15:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 681FE6B0011; Fri,  5 Sep 2025 15:15:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 60C148E0021; Fri,  5 Sep 2025 15:15:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4AD408E0020; Fri,  5 Sep 2025 15:15:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 1F0236B0011
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 15:15:08 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id AB3471401C0
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 19:15:07 +0000 (UTC)
X-FDA: 83856149454.12.513F69B
Received: from mail-pf1-f171.google.com (mail-pf1-f171.google.com [209.85.210.171])
	by imf03.hostedemail.com (Postfix) with ESMTP id C323B20013
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 19:15:05 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=h9SsumcA;
	spf=pass (imf03.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.210.171 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757099705;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qeydI8/HJylw/79KhdbsUGz3ARLAznWN2FgVE73ocLM=;
	b=0DdATErB9B0yIIXRhtVrSnKvkhwU0QGOE3wJka1QHULLUaOfkqzY1wajDJ91lNJCB7AtZX
	xesSjSiCOu/kyczeFsxCrmDY3YZgo69+uIAfqL3QW+YgrmeVvSCyeQX6utlGGusv1rTr4q
	i8FO8CHkWSjoOwtUtvRI9XLbNNaQ8FQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757099705; a=rsa-sha256;
	cv=none;
	b=OxKhY7vI4WspQZIklJlvlDK6RoXtG9QX5M8nn/8qb8JQssODth5Iln3unmuOMl/p9LckYX
	09xSYhewvxaA+eGke2rYNlc/7Tbh2Tkt1BNmKEvvQXfUlXh0oYCnF+23bWV93OgpDPBmch
	8zTBsqM+b96+YsPF/CnzXrgigVGko+k=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=h9SsumcA;
	spf=pass (imf03.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.210.171 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pf1-f171.google.com with SMTP id d2e1a72fcca58-77281ea2dc7so2097406b3a.2
        for <linux-mm@kvack.org>; Fri, 05 Sep 2025 12:15:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757099704; x=1757704504; darn=kvack.org;
        h=content-transfer-encoding:mime-version:reply-to:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to;
        bh=qeydI8/HJylw/79KhdbsUGz3ARLAznWN2FgVE73ocLM=;
        b=h9SsumcABvZflN+DhXw5hYl5TTyM4fg33Cr3PozjxX1qGGrwC1sH43L85RC3UmNcWk
         xnyZU973E7NCFHZNdTVZolTM6pRT8Bel3W2dkvvnRYq0ss3Ov1Jm/sfIKgFqIvx917Dj
         mfuUJ3DBnQHCa2b0JKeOB05dRccaPPSiZhsSpH/y7Zobiq4G9vPwZcAMPYqd08w+9d46
         jgf5vMXJWnWxkxQibQvZJTpcf2W3cgaSBGSfKjXcVtZub4zKixobYeDX5N/C5pVITeyC
         9eJ/httY5+8uYXmBaiVlBs7MiNN3Z4X1iCYzB8hhx2Yn+I9ZQzGJItdoh8YD+eCPA0Ym
         iO1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757099704; x=1757704504;
        h=content-transfer-encoding:mime-version:reply-to:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=qeydI8/HJylw/79KhdbsUGz3ARLAznWN2FgVE73ocLM=;
        b=Ja7N0KSWwdNTXiqdGbJY8YZCYvXdOEEtw7mU5mA8Qo+8WzqJJC1WyEZpaaC7dSYnR2
         dS+ZyR0HqePecbdfuC1mnTt/Hiq1m2ksx3o+5i0VNOnTQ092qO8aBalMTn5R5DsB7JcU
         +Hu0PJAKSQa0sojZKsnY9KMmEIwXmk/fDp2BDC0Z2TQkUP88pZh+JCT1JQwC9UNsGToE
         WKJxw1zHHgWBiJIL3DzipBESTrbxsqJVIaeRIBGHrazs8i9iRb4FlVnskNi8XByckY/H
         WA4be3Rr97oSZx9LX7z8R4vQex46c7fqo8pyGmLdea52ojOpOFbD6XUqJXxfd71r9Ehx
         O7pA==
X-Gm-Message-State: AOJu0Yx79eClfUY7vtAT2aJhUis61OwcLxeEeL+9VK3pB09457REmVsC
	fa9+kz9fIEolimgUfBk5oErvAwjCtzaYi5FlfQmO2/5AC5hXRuQKphH0vZvWCP5zhXI=
X-Gm-Gg: ASbGnct3JoHgc42WL7XAjxIDX4CLDQ9ZhCZILWaTO6xhnRxN0K1JpZPzUi9+kPWEkrJ
	QVMahUOHTYcCvo5woXhYG4KIs5sQ9/O2GDhc1gLAu/4Ynbx8Z59ot2ZQoGBC/XQgl4OLE8VKaCB
	tobggZu0Qjcu3si4fOmHRPsvOicETfZ2iRsKtS98baziT2VOay1Y5uO4XlAnh7sakhYDsgsRDLv
	qFt48B1C7sJVUe6d1kxnVKZ3e5bOQypFYt5s447+OQacHPiOYhAw0aOQYQZOA5xSDRCe1vxMWfr
	5MS2/lkOngP1QSD2tx2Zjy/FelqnmH0CzLQZ8s/WYQNosNUCoqlaKIYFfMUUQ+4cEupTcqKr2TV
	7UF2s1HHG83nGEz7EZyaztJ6Xd4YcCA785bY+0qJwjHFd6iFntembm3nQ5Q==
X-Google-Smtp-Source: AGHT+IHWPtwM9o9BiVGBGT6c2v5RdaBjzKiZLU1Y6x4jyh1hpXCSNboWEG37cyccl+n7P+1hlaOKmA==
X-Received: by 2002:a05:6a00:2e24:b0:771:ec42:1c1e with SMTP id d2e1a72fcca58-7723e342f91mr28182850b3a.16.1757099704147;
        Fri, 05 Sep 2025 12:15:04 -0700 (PDT)
Received: from KASONG-MC4.tencent.com ([101.32.222.185])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-77256a0f916sm15871442b3a.63.2025.09.05.12.14.59
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Fri, 05 Sep 2025 12:15:03 -0700 (PDT)
From: Kairui Song <ryncsn@gmail.com>
To: linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
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
Subject: [PATCH v2 10/15] mm, swap: wrap swap cache replacement with a helper
Date: Sat,  6 Sep 2025 03:13:52 +0800
Message-ID: <20250905191357.78298-11-ryncsn@gmail.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250905191357.78298-1-ryncsn@gmail.com>
References: <20250905191357.78298-1-ryncsn@gmail.com>
Reply-To: Kairui Song <kasong@tencent.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: C323B20013
X-Stat-Signature: z57qc1ymb6ursruuz9imb9jxhqxc3hxm
X-HE-Tag: 1757099705-988775
X-HE-Meta: U2FsdGVkX19eOxs5TeBG4vVhCoQOHa++qA9BARdbyvzrstlCG23CFFo0EWF8TvS7JKR1Ny9yHXCO0awe78YxeZ3YOhUSjv2FpZPFuoa7wnayjBcdaniaT/NzmuO8tIicS4alu2a7GNif9aCV8+9fQKkRV16mBQUFaN0ULUu6L6Y7YQpiOFiRCLVgupmyw3jmgdxegP4m0+525AYHYYN8TdijwrsCFXurWEXOCUbx3mH4b1xQBkHG7X4v5ZuliUbnG3xJWDM0qfftmbwd/yaMpCDjghZYL/ePB3mL1xS0+4FBfnTrU1rMge6Yy7lXTnkFUL+Q5syqEt+YVPD08zb0PgRPdB6NQp8edpCgf82W/5u03lAK4LveOMrVT//I984j9HVNz3wX52Ba3Z/wyFTL4aU1dFOn3EjZ9nDUs+lRLuD14iRKWwaH8iGcZZWf9iRXJk4H/hco7AIdK29yOEZtF0IA0uPXUQGBkJNET7AcDiBXpoeRMPrIDrvSEwd+4mTD5noPE+tWuNr33KEbf7ZnY3W4edZqj2o78e1gNPuucomRESZlW7NGIRVz62d8Ze7XHctucsm52/XCfCX6Vszw+wsmgIWvPJKA7AyY4deBSO6SjRHadZLehBfPHcfUviHdcLZMrfxI4TcbfWCq+sQZQPzmaHK484hFuYZpJK6R8y4wsqd5SiUnoEVE8vlibPuZikpVDJWG27AtCTmGV2EwNUDRxkx2wh/vJ1JccJcxnYJqs115ufU1NfTTJft4CWeqprU0iYD/gdRkTleS97VCScmnWoA2tDmhSmLzrpo9V/w5Wv5G5fJWQnNAtJCSlTg0HaGEG8v6igYk9du95VxdkjeI4nEkN4/Q2Y8cZ8sEFPFwtA1FIJI39WhIErEqC7Ap1NMz9jTyhf/RWXzE4VYTXzOfAvakD/ywuWcU8IXdahJQnJFXzQrBSvZecZ1uPwqMVF25dXs0CfFluJH1zpX
 pPwhKCII
 YiLj/wlgpfc0Nxv6KH/cbCrccKUEN3ysOVtUHFKj1VIyOMjXhx/oi/7Or/X9QapGsmiUwapiq76XkazAoc1RZZdrkzo25JxOD3IR59GxUpJRqiM/wzsYZOZQqaedrgATlFysBBqrkr+EJ8Iqc1AuX1DLAhzvIcLdtI37tCAIyA/5Hx8SZDNYNt2qFYMGNFCcoHykR0MLHOt1X++mUe+r1TU/BxibNrR7+ReFfVL8CRoY95Q474tl+nmpnPKqP4n75eza7BCioTgr/wtdLbtjdNF72M+6sFwb2emt3Q2/vtMxUS+/zB1O6fU+zmEBStDG4vggEI5rwb3FB+AvZ/IoEbCgPYdvmaisNpt5HM9jr1ZdnWO0+Nd9q8Mcu004V0Kfhy7QMIysqvdkJbcyJ7QLjg30zHb/TstbulhnQriUnb0H1fj0FtEZCNaYgvOZZkob7VvPpEdAqY4BSfGBXr/OJ8q+rdSS7t1N4ZGPu4cOSUkpvjaV3cVwtA2XW6VajuEGFRaiwEo166ZeXSHK2E5KmluZkmJbKJF760IcdLrp9ZkzIamQs/TjmRe/h5L6vkkUvH+q44y76sfI6Fa6XtC7PNF0O4Lz8F1FKnw+y
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

Introduce a common helper for this. In later commits, they can be easily
switched to use the swap table by updating this helper.

The newly added helper also makes the swap cache API better defined, and
debugging is easier.

Signed-off-by: Kairui Song <kasong@tencent.com>
---
 mm/huge_memory.c |  5 ++---
 mm/migrate.c     | 11 +++--------
 mm/shmem.c       | 10 ++--------
 mm/swap.h        |  3 +++
 mm/swap_state.c  | 32 ++++++++++++++++++++++++++++++++
 5 files changed, 42 insertions(+), 19 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 26cedfcd7418..a4d192c8d794 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -3798,9 +3798,8 @@ static int __folio_split(struct folio *folio, unsigned int new_order,
 			 * NOTE: shmem in swap cache is not supported yet.
 			 */
 			if (swap_cache) {
-				__xa_store(&swap_cache->i_pages,
-					   swap_cache_index(new_folio->swap),
-					   new_folio, 0);
+				__swap_cache_replace_folio(swap_cache, new_folio->swap,
+							   folio, new_folio);
 				continue;
 			}
 
diff --git a/mm/migrate.c b/mm/migrate.c
index 8e435a078fc3..7e1d01aa8c85 100644
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
+		__swap_cache_replace_folio(mapping, folio->swap, folio, newfolio);
+	else
 		xas_store(&xas, newfolio);
-		xas_next(&xas);
-	}
 
 	/*
 	 * Drop cache reference from old folio by unfreezing
diff --git a/mm/shmem.c b/mm/shmem.c
index cc6a0007c7a6..823ceae9dff8 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -2123,10 +2123,8 @@ static int shmem_replace_folio(struct folio **foliop, gfp_t gfp,
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
@@ -2155,12 +2153,8 @@ static int shmem_replace_folio(struct folio **foliop, gfp_t gfp,
 	new->swap = entry;
 	folio_set_swapcache(new);
 
-	/* Swap cache still stores N entries instead of a high-order entry */
 	xa_lock_irq(&swap_mapping->i_pages);
-	for (i = 0; i < nr_pages; i++) {
-		WARN_ON_ONCE(xas_store(&xas, new));
-		xas_next(&xas);
-	}
+	__swap_cache_replace_folio(swap_mapping, entry, old, new);
 	xa_unlock_irq(&swap_mapping->i_pages);
 
 	mem_cgroup_replace_folio(old, new);
diff --git a/mm/swap.h b/mm/swap.h
index 8b38577a4e04..a139c9131244 100644
--- a/mm/swap.h
+++ b/mm/swap.h
@@ -182,6 +182,9 @@ int swap_cache_add_folio(struct folio *folio, swp_entry_t entry,
 void swap_cache_del_folio(struct folio *folio);
 void __swap_cache_del_folio(struct folio *folio,
 			    swp_entry_t entry, void *shadow);
+void __swap_cache_replace_folio(struct address_space *address_space,
+				swp_entry_t entry,
+				struct folio *old, struct folio *new);
 void swap_cache_clear_shadow(int type, unsigned long begin,
 			     unsigned long end);
 
diff --git a/mm/swap_state.c b/mm/swap_state.c
index f3a32a06a950..38f5f4cf565d 100644
--- a/mm/swap_state.c
+++ b/mm/swap_state.c
@@ -234,6 +234,38 @@ void swap_cache_del_folio(struct folio *folio)
 	folio_ref_sub(folio, folio_nr_pages(folio));
 }
 
+/**
+ * __swap_cache_replace_folio - Replace a folio in the swap cache.
+ * @mapping: Swap mapping address space.
+ * @entry: The first swap entry that the new folio corresponds to.
+ * @old: The old folio to be replaced.
+ * @new: The new folio.
+ *
+ * Replace a existing folio in the swap cache with a new folio.
+ *
+ * Context: Caller must ensure both folios are locked, and lock the
+ * swap address_space that holds the entries to be replaced.
+ */
+void __swap_cache_replace_folio(struct address_space *mapping,
+				swp_entry_t entry,
+				struct folio *old, struct folio *new)
+{
+	unsigned long nr_pages = folio_nr_pages(new);
+	unsigned long offset = swap_cache_index(entry);
+	unsigned long end = offset + nr_pages;
+	XA_STATE(xas, &mapping->i_pages, offset);
+
+	VM_WARN_ON_ONCE(entry.val != new->swap.val);
+	VM_WARN_ON_ONCE(!folio_test_locked(old) || !folio_test_locked(new));
+	VM_WARN_ON_ONCE(!folio_test_swapcache(old) || !folio_test_swapcache(new));
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


