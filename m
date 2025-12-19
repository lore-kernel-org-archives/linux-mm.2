Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 07152D7879F
	for <linux-mm@archiver.kernel.org>; Fri, 19 Dec 2025 19:58:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3DED96B00AC; Fri, 19 Dec 2025 14:58:12 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 395816B00AE; Fri, 19 Dec 2025 14:58:12 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2A2606B00B0; Fri, 19 Dec 2025 14:58:12 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 170C96B00AC
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 14:58:12 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id B283E1401B8
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 19:58:11 +0000 (UTC)
X-FDA: 84237281982.30.D06AFE2
Received: from mail-pl1-f195.google.com (mail-pl1-f195.google.com [209.85.214.195])
	by imf16.hostedemail.com (Postfix) with ESMTP id ADD5B180006
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 19:58:09 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=ecOPy6Ob;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf16.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.214.195 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766174289; a=rsa-sha256;
	cv=none;
	b=YCTJlYwXD5zXfY1ggWhz/67pSxlgrMyCVjvZ7fq425VgI4IrsMSgoCOr+33QU8cFXMyINv
	N3m/8qDfM3rCqpGHr2ZMTseu4Q33myXAgsaqt92yPNi5EUVE2OHXipc+llWne3zmn4a29C
	A6qjejdrqNjHfQveRzuweqxzr8qc6GQ=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=ecOPy6Ob;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf16.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.214.195 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766174289;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4H4DuUxDB6oobQYa52xvrq3Ax3h4Y1Qt9zUrdq7LqpM=;
	b=MSADkWpuBWZhSfSHmszHFk3tWQBr1SlWUawM9etU1H2kzFfBt2mfETA1dlKiWLwGDe8F1F
	JYeF2q+RGZgQclXRaVUGe4O7zPh17uQonR/fZkCYi/ymVXJJtcdRLgWDwQRUcjZ3dhd5CW
	mbZxzYVOaGG3faXvMW1AqpYeYd0KeNk=
Received: by mail-pl1-f195.google.com with SMTP id d9443c01a7336-2a081c163b0so20661245ad.0
        for <linux-mm@kvack.org>; Fri, 19 Dec 2025 11:58:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1766174288; x=1766779088; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4H4DuUxDB6oobQYa52xvrq3Ax3h4Y1Qt9zUrdq7LqpM=;
        b=ecOPy6Ob8TJsni/K2uhPaJY7IxmPRsQh68iP/wh+g8T3qLjNkl9SGi8U8IU2DWvmqU
         WNe4TrMC9fA5bOGNfMQ+60PoB8oouKOlFsmGOpFyMdwrv3CX/Ixdb1nTx/ddmCcUvE5c
         hd9H1x5Lrw+Epc6lUyxsK2r83EVsFIYfjuHu4ne/uwmzEnwetPrISrP/Yme727tV+wYx
         9X+u96RLEakGj7OgLWqLbr6UxVM58tbdOgylSUzSqhzocgQoaoXjElyJOZK/lzNqC9k2
         DcogszyFX52udgsCGITll/wIJXwLFFSnaMXmcd+nEGgRUJDZGRJXejQN6Y4mauYfXuX9
         ADlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766174288; x=1766779088;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=4H4DuUxDB6oobQYa52xvrq3Ax3h4Y1Qt9zUrdq7LqpM=;
        b=vh9YCYaufGk4WAVNcrYk3c5A/PgMU/FbxHKzznmSp6EdtQAVqJlJ/58KefgFRlrire
         6c0ltG82hCMyKynbV4EwHUmRJM+/0Xit2r1DrQUSpBsv3d8yeEa3tEPDE0Co6IOWT+Qm
         VBXJhg4VjVTRjt3rufDsc5Oj6oYDgmhc6HNOHDCJwE5tpLv4m7iQl8BQwMpOgP+8BsaF
         9CeRaPGHbGnA/pbEOh105YQVN9W0sFIn2UyjFRXZZEGGVBrOhhKr1rUUYQcBfuEfwHHv
         z/8t1BjIHdc96j9u09+bOPEhzc6j+pOz56RdaHP0LVOyxRZCHFsJyME6nCvY2GmD96Dl
         zO8g==
X-Gm-Message-State: AOJu0YzEu1ZUXz0Pe+ftQlMTyIK42n0iDbb/qHaJpQhirsj9Jj6FYuzn
	DSrLRf2BS9QyZloCUcjcGlhe3Rn7a+FyIKZxGKw06vPPoC+vJ++QGBi9vry+QLziV5j89A==
X-Gm-Gg: AY/fxX65R1RL/FFkyyyvJVZvoXzm1AcxLgZI0gBcL6tb0xgstE0lrZGZbiJPVffiMgL
	VXfl3W/pLOLQTuq+cTo9vlGaFBiKzNRtdLgH3hVVC1waIjS4iqIu2LlMomI5sMGK8HstVqx2y7t
	TnePfV8r7wsDv9G5yVt22UZ4kssSTC0f4+V+v/qKoZqO3X6PYZNN4+jZtMu2rV2BqjuFUz+QeGG
	kKxqMKeeG8r60RZX2FiSIXaPG/mH2gfdcs3yYp2XL+/aWgnaQOUS9kaWdQnLZa+iMNnIwLVOwbV
	2sEkiKvva2JxUPCTFrlSSxmE576lvsvJntqKusP3t4H0hIqHiKBW3C4/S/ObIgSAeHkSZYJCoGm
	+gzBzqKtCRXpZ9Z/Ol8K2EV2lZyWLyra8brLNAjQV8Qm9mE8PlQ2ww5o1IeTfWhu5XmZxC7i9uE
	P8PR28dY9yWWRB7jBpfWnejpUh8hhVtfDM99hhLaIVLqSpOsE1lJkrtDZPt0GOQUpmpPAtbVYmW
	/i/qA==
X-Google-Smtp-Source: AGHT+IG3wtyX2kCqK0/+5Lh2TLFmivYjvnsdXdS7J5h4wcZuh9jh+Qx4ARXEJV+u1nbtB3ROW7TP9g==
X-Received: by 2002:a17:902:d50b:b0:2a0:f47c:cfc with SMTP id d9443c01a7336-2a2f283685amr38147215ad.34.1766174287808;
        Fri, 19 Dec 2025 11:58:07 -0800 (PST)
Received: from KASONG-MC4.tencent.com ([101.32.222.185])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2a2f3d6ec6bsm29561605ad.87.2025.12.19.11.58.03
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Fri, 19 Dec 2025 11:58:07 -0800 (PST)
From: Kairui Song <ryncsn@gmail.com>
To: linux-mm@kvack.org
Cc: Kairui Song <ryncsn@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Baoquan He <bhe@redhat.com>,
	Barry Song <baohua@kernel.org>,
	Chris Li <chrisl@kernel.org>,
	Nhat Pham <nphamcs@gmail.com>,
	Yosry Ahmed <yosry.ahmed@linux.dev>,
	David Hildenbrand <david@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Youngjun Park <youngjun.park@lge.com>,
	Hugh Dickins <hughd@google.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	linux-kernel@vger.kernel.org,
	Kairui Song <kasong@tencent.com>
Subject: [PATCH v5 07/19] mm/shmem: never bypass the swap cache for SWP_SYNCHRONOUS_IO
Date: Sat, 20 Dec 2025 03:57:51 +0800
Message-ID: <20251219195751.61328-1-ryncsn@gmail.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251220-swap-table-p2-v5-0-8862a265a033@tencent.com>
References: <20251220-swap-table-p2-v5-0-8862a265a033@tencent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
X-Developer-Signature: v=1; a=ed25519-sha256; t=1766173451; l=8383;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=sKGl3ENiC74FwrANABEUQMRrBkxGAp/uMm91rZRl9xM=;
 b=yf5gksHPlsaqtrml++5CgCNI5OX/44vVNb6duB9fWkQkMKDNXC+FFx8Jxgs7hLdW9/Lsta7Bm
 l1nNK9Cc7AWBVfWv/5eQgmJ/f2SGNDpuQOKI16R60HkMmte2972R59h
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: ADD5B180006
X-Stat-Signature: dcnejyju9y9oa84hcde1acygxobu7tzo
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1766174289-636184
X-HE-Meta: U2FsdGVkX19cNuk/fmqK7lsyC70u9cjAPskm9+0oIvLsfq8OUY0/y50Rh5AkIfIoMgscN34peKflwHauoeZMO6EsVxl8f9CO2Velr6VAwpZyNyl/2h9zOSs76GkwCrY10W0L1oVYxsmNppE3CGVVN81z9/nTSH8EF5B+Oj0qtxFc0IX4vJ+nj+14QLQiDili6sXZBzrEcmZ8GEj6OWmsxOjWICFHglIar4GBdC50wcsRnGE6CtacUnTza7ELmBnmwKf6GYcrrR3LOiOmaQbjsddciy+v+ewflbzHO4c1987vDW8givFU+NXNQFGkUmkNGgJA3utvHh/Rm87AjSsX+fzSok+tz/AaYhaCzRZpTMA0zWYoHXbxSbK4xPODQtVj6QN2jtsNYacV20DgG96V+b5KgyDZPgxyGXO9yXWZ4Rze66f6FXwBM5p48SfRkfZ4tHKFDOKEAPmS1czGmJZKKzYf4A6T8Dwnbj8gjocIQHgBJQtmCeJKl9/dtujP6x9sKd84m3PrX9cZnqHbr3/uYVDkjs8FcTWAtqoTFtg+Klfuxqdv/H50JN0a66rjgZbZioC8xtlF9RuzWr3lpkq8TGE6Js05REzd9NvGRH2YA09oSIBTzfD68CEkmnDBXUzYQ5a/ZV5ZZ1uujr7WBAYKhH5BhcZE1MchuTTl+Q3Yt28d4/RyvSiv8Af+KDwhEdKVZXW8chKlylSCKde2luq6LSkOAYdtZSIJ4jXnyflJoEaF0pQVA0SJbbX3eVQCdBgb6KgEr/2xUhBMW7ICGIVT/wBhQOIjYHEVUJf/9uChMm998fYLsiMNrZlwmnqMNWNJYgdWZSI2SCSe+lMHiv3Y2goR0Udn91jj8Oi4s6VbU1Dzxvo6nFKErFSZsXWOFJSx5G/OsTnIlLPcbuDP6wNVwxIUXFxQ7Q5vpj3Iioqh5+79qv1kTHzEfPapE9rBsVP+CEO+lxCNEjItmwhp6DW
 bQhmdyh2
 fcoXIu+0Y4shuePLdAwXoEQ9+3roUQ7JUBfbRyBGOT3ZkE4bFbtvUAthMrQ2mqKgdOBQKwhZnvEFJQ8BdW0J4b7fKVVADhQyOXiC4EGnzbQJElfX14kX3tZuMzZgsurmgcWs69U1X4q2l/0DilpitOP6wsDbWo8C3P3lR7p7EJQlMbjPik4NVswiePxOexzKt4eJaY9YMLCP2sHFjTs8cTxjPfpx5zrYBvtDwRdFL+0g1RTL5o7SJMopw43CkPcDJtUFEd+Uuu8RkJEvUiNpswGl5eMaXECiMbcc4uIDST1bJDbFR7zMDFrkDKhGF8p284YD4u4dgN4OHhgXGOLcMvNUoUf/4fXh39YwxQQ58bKgrvJ9KSdzrKkL++4kXsmh6zCY2bbhX3og6SRyIVTVrt1vfTmPfex5uPXBqws9fTk3ZDu4tCTsJkn/uO6l0YDAqBNm5HUTGXnl/+g+LKxE6E7FTy97/OsQfktrArzVthUDKzINqj3Z2Y7yxALFwqtmc/WvHPLzr4ygDN6/aAYsPR5zMpqdXlw2y+0vb
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kairui Song <kasong@tencent.com>=0D
=0D
Now the overhead of the swap cache is trivial to none, bypassing the=0D
swap cache is no longer a good optimization.=0D
=0D
We have removed the cache bypass swapin for anon memory, now do the same=0D
for shmem. Many helpers and functions can be dropped now.=0D
=0D
The performance may slightly drop because of the co-existence and double=0D
update of swap_map and swap table, and this problem will be improved=0D
very soon in later commits by dropping the swap_map update partially:=0D
=0D
Swapin of 24 GB file with tmpfs with=0D
transparent_hugepage_tmpfs=3Dwithin_size and ZRAM, 3 test runs on my=0D
machine:=0D
=0D
Before:  After this commit:  After this series:=0D
5.99s    6.29s               6.08s=0D
=0D
And later swap table phases will drop the swap_map completely to avoid=0D
overhead and reduce memory usage.=0D
=0D
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>=0D
Tested-by: Baolin Wang <baolin.wang@linux.alibaba.com>=0D
Signed-off-by: Kairui Song <kasong@tencent.com>=0D
---=0D
 mm/shmem.c    | 65 +++++++++++++++++--------------------------------------=
----=0D
 mm/swap.h     |  4 ----=0D
 mm/swapfile.c | 35 +++++++++-----------------------=0D
 3 files changed, 27 insertions(+), 77 deletions(-)=0D
=0D
diff --git a/mm/shmem.c b/mm/shmem.c=0D
index dd136d40631c..d7eeeaa9580d 100644=0D
--- a/mm/shmem.c=0D
+++ b/mm/shmem.c=0D
@@ -2014,10 +2014,9 @@ static struct folio *shmem_swap_alloc_folio(struct i=
node *inode,=0D
 		swp_entry_t entry, int order, gfp_t gfp)=0D
 {=0D
 	struct shmem_inode_info *info =3D SHMEM_I(inode);=0D
+	struct folio *new, *swapcache;=0D
 	int nr_pages =3D 1 << order;=0D
-	struct folio *new;=0D
 	gfp_t alloc_gfp;=0D
-	void *shadow;=0D
 =0D
 	/*=0D
 	 * We have arrived here because our zones are constrained, so don't=0D
@@ -2057,34 +2056,19 @@ static struct folio *shmem_swap_alloc_folio(struct =
inode *inode,=0D
 		goto fallback;=0D
 	}=0D
 =0D
-	/*=0D
-	 * Prevent parallel swapin from proceeding with the swap cache flag.=0D
-	 *=0D
-	 * Of course there is another possible concurrent scenario as well,=0D
-	 * that is to say, the swap cache flag of a large folio has already=0D
-	 * been set by swapcache_prepare(), while another thread may have=0D
-	 * already split the large swap entry stored in the shmem mapping.=0D
-	 * In this case, shmem_add_to_page_cache() will help identify the=0D
-	 * concurrent swapin and return -EEXIST.=0D
-	 */=0D
-	if (swapcache_prepare(entry, nr_pages)) {=0D
+	swapcache =3D swapin_folio(entry, new);=0D
+	if (swapcache !=3D new) {=0D
 		folio_put(new);=0D
-		new =3D ERR_PTR(-EEXIST);=0D
-		/* Try smaller folio to avoid cache conflict */=0D
-		goto fallback;=0D
+		if (!swapcache) {=0D
+			/*=0D
+			 * The new folio is charged already, swapin can=0D
+			 * only fail due to another raced swapin.=0D
+			 */=0D
+			new =3D ERR_PTR(-EEXIST);=0D
+			goto fallback;=0D
+		}=0D
 	}=0D
-=0D
-	__folio_set_locked(new);=0D
-	__folio_set_swapbacked(new);=0D
-	new->swap =3D entry;=0D
-=0D
-	memcg1_swapin(entry, nr_pages);=0D
-	shadow =3D swap_cache_get_shadow(entry);=0D
-	if (shadow)=0D
-		workingset_refault(new, shadow);=0D
-	folio_add_lru(new);=0D
-	swap_read_folio(new, NULL);=0D
-	return new;=0D
+	return swapcache;=0D
 fallback:=0D
 	/* Order 0 swapin failed, nothing to fallback to, abort */=0D
 	if (!order)=0D
@@ -2174,8 +2158,7 @@ static int shmem_replace_folio(struct folio **foliop,=
 gfp_t gfp,=0D
 }=0D
 =0D
 static void shmem_set_folio_swapin_error(struct inode *inode, pgoff_t inde=
x,=0D
-					 struct folio *folio, swp_entry_t swap,=0D
-					 bool skip_swapcache)=0D
+					 struct folio *folio, swp_entry_t swap)=0D
 {=0D
 	struct address_space *mapping =3D inode->i_mapping;=0D
 	swp_entry_t swapin_error;=0D
@@ -2191,8 +2174,7 @@ static void shmem_set_folio_swapin_error(struct inode=
 *inode, pgoff_t index,=0D
 =0D
 	nr_pages =3D folio_nr_pages(folio);=0D
 	folio_wait_writeback(folio);=0D
-	if (!skip_swapcache)=0D
-		swap_cache_del_folio(folio);=0D
+	swap_cache_del_folio(folio);=0D
 	/*=0D
 	 * Don't treat swapin error folio as alloced. Otherwise inode->i_blocks=0D
 	 * won't be 0 when inode is released and thus trigger WARN_ON(i_blocks)=0D
@@ -2292,7 +2274,6 @@ static int shmem_swapin_folio(struct inode *inode, pg=
off_t index,=0D
 	softleaf_t index_entry;=0D
 	struct swap_info_struct *si;=0D
 	struct folio *folio =3D NULL;=0D
-	bool skip_swapcache =3D false;=0D
 	int error, nr_pages, order;=0D
 	pgoff_t offset;=0D
 =0D
@@ -2335,7 +2316,6 @@ static int shmem_swapin_folio(struct inode *inode, pg=
off_t index,=0D
 				folio =3D NULL;=0D
 				goto failed;=0D
 			}=0D
-			skip_swapcache =3D true;=0D
 		} else {=0D
 			/* Cached swapin only supports order 0 folio */=0D
 			folio =3D shmem_swapin_cluster(swap, gfp, info, index);=0D
@@ -2391,9 +2371,8 @@ static int shmem_swapin_folio(struct inode *inode, pg=
off_t index,=0D
 	 * and swap cache folios are never partially freed.=0D
 	 */=0D
 	folio_lock(folio);=0D
-	if ((!skip_swapcache && !folio_test_swapcache(folio)) ||=0D
-	    shmem_confirm_swap(mapping, index, swap) < 0 ||=0D
-	    folio->swap.val !=3D swap.val) {=0D
+	if (!folio_matches_swap_entry(folio, swap) ||=0D
+	    shmem_confirm_swap(mapping, index, swap) < 0) {=0D
 		error =3D -EEXIST;=0D
 		goto unlock;=0D
 	}=0D
@@ -2425,12 +2404,7 @@ static int shmem_swapin_folio(struct inode *inode, p=
goff_t index,=0D
 	if (sgp =3D=3D SGP_WRITE)=0D
 		folio_mark_accessed(folio);=0D
 =0D
-	if (skip_swapcache) {=0D
-		folio->swap.val =3D 0;=0D
-		swapcache_clear(si, swap, nr_pages);=0D
-	} else {=0D
-		swap_cache_del_folio(folio);=0D
-	}=0D
+	swap_cache_del_folio(folio);=0D
 	folio_mark_dirty(folio);=0D
 	swap_free_nr(swap, nr_pages);=0D
 	put_swap_device(si);=0D
@@ -2441,14 +2415,11 @@ static int shmem_swapin_folio(struct inode *inode, =
pgoff_t index,=0D
 	if (shmem_confirm_swap(mapping, index, swap) < 0)=0D
 		error =3D -EEXIST;=0D
 	if (error =3D=3D -EIO)=0D
-		shmem_set_folio_swapin_error(inode, index, folio, swap,=0D
-					     skip_swapcache);=0D
+		shmem_set_folio_swapin_error(inode, index, folio, swap);=0D
 unlock:=0D
 	if (folio)=0D
 		folio_unlock(folio);=0D
 failed_nolock:=0D
-	if (skip_swapcache)=0D
-		swapcache_clear(si, folio->swap, folio_nr_pages(folio));=0D
 	if (folio)=0D
 		folio_put(folio);=0D
 	put_swap_device(si);=0D
diff --git a/mm/swap.h b/mm/swap.h=0D
index 214e7d041030..e0f05babe13a 100644=0D
--- a/mm/swap.h=0D
+++ b/mm/swap.h=0D
@@ -403,10 +403,6 @@ static inline int swap_writeout(struct folio *folio,=0D
 	return 0;=0D
 }=0D
 =0D
-static inline void swapcache_clear(struct swap_info_struct *si, swp_entry_=
t entry, int nr)=0D
-{=0D
-}=0D
-=0D
 static inline struct folio *swap_cache_get_folio(swp_entry_t entry)=0D
 {=0D
 	return NULL;=0D
diff --git a/mm/swapfile.c b/mm/swapfile.c=0D
index e5284067a442..3762b8f3f9e9 100644=0D
--- a/mm/swapfile.c=0D
+++ b/mm/swapfile.c=0D
@@ -1614,22 +1614,6 @@ struct swap_info_struct *get_swap_device(swp_entry_t=
 entry)=0D
 	return NULL;=0D
 }=0D
 =0D
-static void swap_entries_put_cache(struct swap_info_struct *si,=0D
-				   swp_entry_t entry, int nr)=0D
-{=0D
-	unsigned long offset =3D swp_offset(entry);=0D
-	struct swap_cluster_info *ci;=0D
-=0D
-	ci =3D swap_cluster_lock(si, offset);=0D
-	if (swap_only_has_cache(si, offset, nr)) {=0D
-		swap_entries_free(si, ci, entry, nr);=0D
-	} else {=0D
-		for (int i =3D 0; i < nr; i++, entry.val++)=0D
-			swap_entry_put_locked(si, ci, entry, SWAP_HAS_CACHE);=0D
-	}=0D
-	swap_cluster_unlock(ci);=0D
-}=0D
-=0D
 static bool swap_entries_put_map(struct swap_info_struct *si,=0D
 				 swp_entry_t entry, int nr)=0D
 {=0D
@@ -1765,13 +1749,21 @@ void swap_free_nr(swp_entry_t entry, int nr_pages)=
=0D
 void put_swap_folio(struct folio *folio, swp_entry_t entry)=0D
 {=0D
 	struct swap_info_struct *si;=0D
+	struct swap_cluster_info *ci;=0D
+	unsigned long offset =3D swp_offset(entry);=0D
 	int size =3D 1 << swap_entry_order(folio_order(folio));=0D
 =0D
 	si =3D _swap_info_get(entry);=0D
 	if (!si)=0D
 		return;=0D
 =0D
-	swap_entries_put_cache(si, entry, size);=0D
+	ci =3D swap_cluster_lock(si, offset);=0D
+	if (swap_only_has_cache(si, offset, size))=0D
+		swap_entries_free(si, ci, entry, size);=0D
+	else=0D
+		for (int i =3D 0; i < size; i++, entry.val++)=0D
+			swap_entry_put_locked(si, ci, entry, SWAP_HAS_CACHE);=0D
+	swap_cluster_unlock(ci);=0D
 }=0D
 =0D
 int __swap_count(swp_entry_t entry)=0D
@@ -3784,15 +3776,6 @@ int swapcache_prepare(swp_entry_t entry, int nr)=0D
 	return __swap_duplicate(entry, SWAP_HAS_CACHE, nr);=0D
 }=0D
 =0D
-/*=0D
- * Caller should ensure entries belong to the same folio so=0D
- * the entries won't span cross cluster boundary.=0D
- */=0D
-void swapcache_clear(struct swap_info_struct *si, swp_entry_t entry, int n=
r)=0D
-{=0D
-	swap_entries_put_cache(si, entry, nr);=0D
-}=0D
-=0D
 /*=0D
  * add_swap_count_continuation - called when a swap count is duplicated=0D
  * beyond SWAP_MAP_MAX, it allocates a new page and links that to the entr=
y's=0D
=0D
-- =0D
2.52.0=0D
=0D

