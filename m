Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E8EA4CD4F3E
	for <linux-mm@archiver.kernel.org>; Sun, 16 Nov 2025 18:13:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 528978E0032; Sun, 16 Nov 2025 13:13:48 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4D9218E0029; Sun, 16 Nov 2025 13:13:48 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3EEE48E0032; Sun, 16 Nov 2025 13:13:48 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 295948E0029
	for <linux-mm@kvack.org>; Sun, 16 Nov 2025 13:13:48 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id E2A7D5C1D6
	for <linux-mm@kvack.org>; Sun, 16 Nov 2025 18:13:47 +0000 (UTC)
X-FDA: 84117268494.11.B67B111
Received: from mail-qk1-f170.google.com (mail-qk1-f170.google.com [209.85.222.170])
	by imf22.hostedemail.com (Postfix) with ESMTP id EFCA5C000B
	for <linux-mm@kvack.org>; Sun, 16 Nov 2025 18:13:45 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=F7CAqa6r;
	spf=pass (imf22.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.222.170 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763316826;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9JRhX/M2scbj4JEpu0T8hvGiOE6wUVEvfQwnSBwG0A4=;
	b=63GlYIkbJhA+AUdKW91r5vfO7fBJzrRhwC4pB0nTZFRThn8N5JdYtxsM5KvutSLXvoivQm
	pzNb0JXMAD9/1W12x0KdsQrLA9+Um+LVFzaU+VMLG0XlTeWK9775QGP9AbDXDCjQ6Ckjwe
	Eqg/tT2RE9fMv9aaX2uTO1yz38cfNJE=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=F7CAqa6r;
	spf=pass (imf22.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.222.170 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763316826; a=rsa-sha256;
	cv=none;
	b=F8Kd/0tsqsClhRsN20qY8ezNS+cJQmBqhUGavezztz5NI1VeGF7GWnTcv8jcfS3TccoDaF
	YQt+BiGj2hTK00DfQWfa1Ox2Lfqz28IbT0gEXSoZyK5FnGZmhlk8Dk26Bz9BiTBJrj7rvW
	W6TnJvej3T/aSOUkp/InTeuPz1uqee4=
Received: by mail-qk1-f170.google.com with SMTP id af79cd13be357-8b1b8264c86so371880185a.1
        for <linux-mm@kvack.org>; Sun, 16 Nov 2025 10:13:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763316825; x=1763921625; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=9JRhX/M2scbj4JEpu0T8hvGiOE6wUVEvfQwnSBwG0A4=;
        b=F7CAqa6rC3mSRtQkGyxVgfgmIf51g6PNm1ygtrfdZYFF2YVclZ8o6XdDPSzwzlQGAX
         QmmOzVvszuUHzNAI+oJMaj7yAo0iVfE5eQQqzhg8PzKmIzxlnxFnibCZ/YlLx87r1f+h
         kyqwdxfoNnLPB8KQtPQtGZk7HffpV+mOvkU7vTqvtJ/em0uPsVLOzbTAS1ZGeoyiaWr4
         +89ecKQ3iFNKkQN9zd+vOgUavD+htDP4xXD8XPCLzAzYNAr01q9yvcUTpaBPrMTErR2u
         Pv34Jgcl/o4NqvlaHy4LjAEGwBzzR37pa/dewSlGrjD1izQZ2BQ33uDENFUET00GyC5T
         e0wg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763316825; x=1763921625;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=9JRhX/M2scbj4JEpu0T8hvGiOE6wUVEvfQwnSBwG0A4=;
        b=LrUTTQvBribAvs6M4PtoxG50wjuTQNLxFbm+p8rJhdcDvlbogcLjct87xCnwWjsLuY
         8+GcPyuofZWa7/0Sgf0A4l6UGBITHANFtQgQKzdfIFAPgvJ8bpoPYLBrhIzYrlWLgsy7
         DYk4TC9nUoVhzgZgLytevJXDJoFljydpChww0RDn59n91QlULNbTBQ0fa2rLqmexw7dN
         l2Me7hUmc0Die2T6648kZE9TVkPQGBC/YLAZs2/U9gB45wEOc0E1eT8Hd+VPbthURRBR
         AVGLAm5uvr8SbicErPguijW+LOPTdyDjU+pfCnucsMLfYSC1lPqTvqkIbAKzF8IHlnt9
         7owA==
X-Gm-Message-State: AOJu0YzWI3w+TC42dZ9LwyLsZMan6BfEhBogGe88+iswZazpoTkZegQ0
	N1g3NYJ+EXlvbGVqtOxHKmFY9aXZWqOMdI4+xj7GcA8ibwyq38qhHx3r
X-Gm-Gg: ASbGncvQgFO0z3fkwLB+b56LiUYCeXLlEeTbWZpLxGyHKh/6fNYw2XmVDmwqggABrm1
	UixiZmAWCNVwPb9NU5O42ICdA6DO766Dq+ow/5Q+CGu1kGoRZjpm265wobd1to31fWrq/zs0H34
	NnhO7pgv1ZvIUEMoep776n3TeX49gK8Z3ywWqgySX5INmcstoEJSyWVb/BYFkJAUlweoliYwty5
	52fPf99C7Av8rD6464lSJz31JjjNuxLb98Y8MKolsgVgoP4TH+3xUB+PdvnHFCjbiipBGQW+d4C
	Qu/DRF9jGmU4DusP8JGYBJb2BLrUbAPOG8u0fLvY7OCoeaTpa45WlQf62x5xNRZ23B+XshotM84
	8F4wnv7bbBHCUEjA0nVfOkiZJeYOcRPe3eLPhPTfj0l4RZ3TVh9NM8X82LyC8ruWHN1KtkG0Bdu
	FuJ2+19iyf/5nk46dOIfEwYezsDF6P+0MQX144EskSrg==
X-Google-Smtp-Source: AGHT+IHHDbTZrWWSde0cDap+tMSMP4g51LOtboNKkcgFRy3HrHD986F4QHikawdOtCeVWBjLY+0X0w==
X-Received: by 2002:a05:620a:3197:b0:8b1:d8f5:6d08 with SMTP id af79cd13be357-8b2c2e5cd41mr1219229185a.0.1763316824982;
        Sun, 16 Nov 2025 10:13:44 -0800 (PST)
Received: from [127.0.0.1] ([101.32.222.185])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8b2e089b436sm305447785a.45.2025.11.16.10.13.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 16 Nov 2025 10:13:44 -0800 (PST)
From: Kairui Song <ryncsn@gmail.com>
Date: Mon, 17 Nov 2025 02:11:58 +0800
Subject: [PATCH v2 17/19] mm, swap: clean up and improve swap entries
 freeing
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251117-swap-table-p2-v2-17-37730e6ea6d5@tencent.com>
References: <20251117-swap-table-p2-v2-0-37730e6ea6d5@tencent.com>
In-Reply-To: <20251117-swap-table-p2-v2-0-37730e6ea6d5@tencent.com>
To: linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>, Baoquan He <bhe@redhat.com>, 
 Barry Song <baohua@kernel.org>, Chris Li <chrisl@kernel.org>, 
 Nhat Pham <nphamcs@gmail.com>, Yosry Ahmed <yosry.ahmed@linux.dev>, 
 David Hildenbrand <david@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, 
 Youngjun Park <youngjun.park@lge.com>, Hugh Dickins <hughd@google.com>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 Ying Huang <ying.huang@linux.alibaba.com>, 
 Kemeng Shi <shikemeng@huaweicloud.com>, 
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
 linux-kernel@vger.kernel.org, Kairui Song <kasong@tencent.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1763316712; l=13631;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=lMYoYBAMdSWChAGvxsy09xoTUwHOmUXPetgfqB7MVMk=;
 b=xdN6yPF8YK+zcdtDyWdnYu7bdeVHzJSwKtH3U9wzaftf8MZCmtd8Qq9HUWBf6rk02w67KNl2A
 ePW09rB5Y8sAjhfBtzjZBQQ9jcwl5S+5Mvj0t+6SUZJwsPdlTDiXa5f
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: EFCA5C000B
X-Stat-Signature: ebq8mx3ojoiu5r8watm6yqk6mgmhfftg
X-Rspam-User: 
X-HE-Tag: 1763316825-265169
X-HE-Meta: U2FsdGVkX1+eCOzZCKdLaknp/Fm+3FdJcQnhDF8rTkfL9P30OLfVawzf6kRGHfSzRLREMIx5Ai1g4JfNqqXAVp+IsMF3awopdIxk3pmIzDN0yxevksuS/d30SPo7fATudWtqZAcywPisWREk3jzlSg10zoBE7XnuU9TFFuq7Ve5QKLXbSPMo/x+wLVRR5tQd5zpE+z5QIVb8SuoV/U1byW1BV6KIJGU+X0oObbJgcpDkHSpIdHWqC0NMeZgJ5Sn4P2FLlTqIBF7irekgVOlmvANkP+nN1vC5d8BqOOEhYQTEVhaQQBmhkpuAdei3kWzZqJdViZ7fwERVJ2CyIr2Ab4ZSigd+HLNlmyLt8EGMEt83SRd7AKyHsn4nruQov+51SEfDIX4GyLINHtRBkDMloyI57Xg0wymZc2QVZzxOCEX3xeKACCfmQJdhAoxh2Hl70CldnzW+Y7kwZXDesYrmyjP8eez6OgnqlYX0GDNFSi3DPqxYcixMnrKP4g1bqDIlrJ0c0X2OdDbK2cL+XrX2VnrJnsaqMjI7et8J66y1mtUcnQjSmh7hIs3LhsIPLQPyPSz/KajetXNgDjJPQNEaBBJj3yApxxFpfV/+iu/KqCwruKqJzIJBeuW7TEQrnaH2Qlh5meFXtm9RJor5rxyoseOJvd8FKjUJyHELyJmKYWhYrg4lmCIYGvnDScdj5GHzuIC1BxVHOLLzJzZzpEk8FblkaYAIryh6Pk16vayGLz0QvwbLlTKpkdroPEfyT02V1ptBMFvgyT6/g8rfRIjrTh7WjE18pOnlQjGL65+TNh6Fr6MwWxcM5ojvnovY7DAtICnKpVU42chJDY1VPmnbo8BZCHHoaKw74Rb1ga/4T8pwl21MIW1y5d6SIM36C7/wOn/TOh6dqrjQRzlGjKjfr/OtxJGFPQc5mdTZTkGnr9MK7UEJ7eEInHEMo42DXNFYY1Sc0JWugOQtVsju0FK
 NTVtraHy
 TQMfefNERalr4qcnreo1zcV3TDhxPrD23hGWAB7Sq912RvyMO6XsWZAVSz9U/3SQYKtguIvqik93gotp4Yv7jK9b/IAAyn0zbUfdxW2rUgcojoE4KBUobqhxDGFAYn+p7mlTEspJld5QpxZMpBX47W+916SlgLDHm4UZtpAfQiLwCxhyE6Yqu/rY3gy8euzU92ILxSZqNaMp2QVnjArKoboDrOMZ5px9ylkftQE9E+aIWO2xSOhJe4sJWJGw6hRc/PTNNDx3EN0I+8EhwnMU0KeqfMSFBSFVPz6h5qac6U6zTFgPhQMyOV43HfXjuP9GrlYDNEgqlaWoAjDaf3XbTjWSB4w/83ru8iYJx13MYsIf+d+FXaAEcX6z01QHqr8DYRFhNPvaBs46mUsdn9u71+c6U4oO+gvpSJUD4JYCeSpiylx9Ec4eDS7H2hw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kairui Song <kasong@tencent.com>

There are a few problems with the current freeing of swap entries.

When freeing a set of swap entries directly (swap_put_entries_direct,
typically from zapping the page table), it scans the whole swap region
multiple times. First, it scans the whole region to check if it can be
batch freed and if there is any cached folio. Then do a batch free only
if the whole region's swap count equals 1. And if any entry is cached,
even if only one, it will have to walk the whole region again to clean
up the cache.

And if any entry is not in a consistent status with other entries, it
will fall back to order 0 freeing. For example, if only one of them is
cached, the batch free will fall back.

And the current batch freeing workflow relies on the swap map's
SWAP_HAS_CACHE bit for both continuous checking and batch freeing, which
isn't compatible with the swap table design.

Tidy this up, introduce a new cluster scoped helper for all swap entry
freeing job. It will batch frees all continuous entries, and just start
a new batch if any inconsistent entry is found. This may improve the
batch size when the clusters are fragmented. This should also be more
robust with more sanity checks, and make it clear that a slot pinned by
swap cache will be cleared upon cache reclaim.

And the cache reclaim scan is also now limited to each cluster. If a
cluster has any clean swap cache left after putting the swap count,
reclaim the cluster only instead of the whole region.

And since a folio's entries are always in the same cluster, putting swap
entries from a folio can also use the new helper directly.

This should be both an optimization and a cleanup, and the new helper is
adapted to the swap table.

Signed-off-by: Kairui Song <kasong@tencent.com>
---
 mm/swapfile.c | 238 +++++++++++++++++++++++-----------------------------------
 1 file changed, 96 insertions(+), 142 deletions(-)

diff --git a/mm/swapfile.c b/mm/swapfile.c
index e321093d0552..f98529f5c209 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -55,12 +55,14 @@ static bool swap_count_continued(struct swap_info_struct *, pgoff_t,
 static void free_swap_count_continuations(struct swap_info_struct *);
 static void swap_entries_free(struct swap_info_struct *si,
 			      struct swap_cluster_info *ci,
-			      swp_entry_t entry, unsigned int nr_pages);
+			      unsigned long start, unsigned int nr_pages);
 static void swap_range_alloc(struct swap_info_struct *si,
 			     unsigned int nr_entries);
 static int __swap_duplicate(swp_entry_t entry, unsigned char usage, int nr);
-static bool swap_entries_put_map(struct swap_info_struct *si,
-				 swp_entry_t entry, int nr);
+static void swap_put_entry_locked(struct swap_info_struct *si,
+				  struct swap_cluster_info *ci,
+				  unsigned long offset,
+				  unsigned char usage);
 static bool folio_swapcache_freeable(struct folio *folio);
 static void move_cluster(struct swap_info_struct *si,
 			 struct swap_cluster_info *ci, struct list_head *list,
@@ -197,25 +199,6 @@ static bool swap_only_has_cache(struct swap_info_struct *si,
 	return true;
 }
 
-static bool swap_is_last_map(struct swap_info_struct *si,
-		unsigned long offset, int nr_pages, bool *has_cache)
-{
-	unsigned char *map = si->swap_map + offset;
-	unsigned char *map_end = map + nr_pages;
-	unsigned char count = *map;
-
-	if (swap_count(count) != 1)
-		return false;
-
-	while (++map < map_end) {
-		if (*map != count)
-			return false;
-	}
-
-	*has_cache = !!(count & SWAP_HAS_CACHE);
-	return true;
-}
-
 /*
  * returns number of pages in the folio that backs the swap entry. If positive,
  * the folio was reclaimed. If negative, the folio was not reclaimed. If 0, no
@@ -1421,6 +1404,76 @@ static bool swap_sync_discard(void)
 	return false;
 }
 
+/**
+ * swap_put_entries_cluster - Decrease the swap count of a set of slots.
+ * @si: The swap device.
+ * @start: start offset of slots.
+ * @nr: number of slots.
+ * @reclaim_cache: if true, also reclaim the swap cache.
+ *
+ * This helper decreases the swap count of a set of slots and tries to
+ * batch free them. Also reclaims the swap cache if @reclaim_cache is true.
+ * Context: The caller must ensure that all slots belong to the same
+ * cluster and their swap count doesn't go underflow.
+ */
+static void swap_put_entries_cluster(struct swap_info_struct *si,
+				     unsigned long start, int nr,
+				     bool reclaim_cache)
+{
+	unsigned long offset = start, end = start + nr;
+	unsigned long batch_start = SWAP_ENTRY_INVALID;
+	struct swap_cluster_info *ci;
+	bool need_reclaim = false;
+	unsigned int nr_reclaimed;
+	unsigned long swp_tb;
+	unsigned int count;
+
+	ci = swap_cluster_lock(si, offset);
+	do {
+		swp_tb = __swap_table_get(ci, offset % SWAPFILE_CLUSTER);
+		count = si->swap_map[offset];
+		VM_WARN_ON(swap_count(count) < 1 || count == SWAP_MAP_BAD);
+		if (swap_count(count) == 1) {
+			/* count == 1 and non-cached slots will be batch freed. */
+			if (!swp_tb_is_folio(swp_tb)) {
+				if (!batch_start)
+					batch_start = offset;
+				continue;
+			}
+			/* count will be 0 after put, slot can be reclaimed */
+			VM_WARN_ON(!(count & SWAP_HAS_CACHE));
+			need_reclaim = true;
+		}
+		/*
+		 * A count != 1 or cached slot can't be freed. Put its swap
+		 * count and then free the interrupted pending batch. Cached
+		 * slots will be freed when folio is removed from swap cache
+		 * (__swap_cache_del_folio).
+		 */
+		swap_put_entry_locked(si, ci, offset, 1);
+		if (batch_start) {
+			swap_entries_free(si, ci, batch_start, offset - batch_start);
+			batch_start = SWAP_ENTRY_INVALID;
+		}
+	} while (++offset < end);
+
+	if (batch_start)
+		swap_entries_free(si, ci, batch_start, offset - batch_start);
+	swap_cluster_unlock(ci);
+
+	if (!need_reclaim || !reclaim_cache)
+		return;
+
+	offset = start;
+	do {
+		nr_reclaimed = __try_to_reclaim_swap(si, offset,
+						     TTRS_UNMAPPED | TTRS_FULL);
+		offset++;
+		if (nr_reclaimed)
+			offset = round_up(offset, abs(nr_reclaimed));
+	} while (offset < end);
+}
+
 /**
  * folio_alloc_swap - allocate swap space for a folio
  * @folio: folio we want to move to swap
@@ -1522,6 +1575,7 @@ void folio_put_swap(struct folio *folio, struct page *subpage)
 {
 	swp_entry_t entry = folio->swap;
 	unsigned long nr_pages = folio_nr_pages(folio);
+	struct swap_info_struct *si = __swap_entry_to_info(entry);
 
 	VM_WARN_ON_FOLIO(!folio_test_locked(folio), folio);
 	VM_WARN_ON_FOLIO(!folio_test_swapcache(folio), folio);
@@ -1531,7 +1585,7 @@ void folio_put_swap(struct folio *folio, struct page *subpage)
 		nr_pages = 1;
 	}
 
-	swap_entries_put_map(__swap_entry_to_info(entry), entry, nr_pages);
+	swap_put_entries_cluster(si, swp_offset(entry), nr_pages, false);
 }
 
 static struct swap_info_struct *_swap_info_get(swp_entry_t entry)
@@ -1568,12 +1622,11 @@ static struct swap_info_struct *_swap_info_get(swp_entry_t entry)
 	return NULL;
 }
 
-static unsigned char swap_entry_put_locked(struct swap_info_struct *si,
-					   struct swap_cluster_info *ci,
-					   swp_entry_t entry,
-					   unsigned char usage)
+static void swap_put_entry_locked(struct swap_info_struct *si,
+				  struct swap_cluster_info *ci,
+				  unsigned long offset,
+				  unsigned char usage)
 {
-	unsigned long offset = swp_offset(entry);
 	unsigned char count;
 	unsigned char has_cache;
 
@@ -1599,9 +1652,7 @@ static unsigned char swap_entry_put_locked(struct swap_info_struct *si,
 	if (usage)
 		WRITE_ONCE(si->swap_map[offset], usage);
 	else
-		swap_entries_free(si, ci, entry, 1);
-
-	return usage;
+		swap_entries_free(si, ci, offset, 1);
 }
 
 /*
@@ -1669,70 +1720,6 @@ struct swap_info_struct *get_swap_device(swp_entry_t entry)
 	return NULL;
 }
 
-static bool swap_entries_put_map(struct swap_info_struct *si,
-				 swp_entry_t entry, int nr)
-{
-	unsigned long offset = swp_offset(entry);
-	struct swap_cluster_info *ci;
-	bool has_cache = false;
-	unsigned char count;
-	int i;
-
-	if (nr <= 1)
-		goto fallback;
-	count = swap_count(data_race(si->swap_map[offset]));
-	if (count != 1)
-		goto fallback;
-
-	ci = swap_cluster_lock(si, offset);
-	if (!swap_is_last_map(si, offset, nr, &has_cache)) {
-		goto locked_fallback;
-	}
-	if (!has_cache)
-		swap_entries_free(si, ci, entry, nr);
-	else
-		for (i = 0; i < nr; i++)
-			WRITE_ONCE(si->swap_map[offset + i], SWAP_HAS_CACHE);
-	swap_cluster_unlock(ci);
-
-	return has_cache;
-
-fallback:
-	ci = swap_cluster_lock(si, offset);
-locked_fallback:
-	for (i = 0; i < nr; i++, entry.val++) {
-		count = swap_entry_put_locked(si, ci, entry, 1);
-		if (count == SWAP_HAS_CACHE)
-			has_cache = true;
-	}
-	swap_cluster_unlock(ci);
-	return has_cache;
-}
-
-/*
- * Only functions with "_nr" suffix are able to free entries spanning
- * cross multi clusters, so ensure the range is within a single cluster
- * when freeing entries with functions without "_nr" suffix.
- */
-static bool swap_entries_put_map_nr(struct swap_info_struct *si,
-				    swp_entry_t entry, int nr)
-{
-	int cluster_nr, cluster_rest;
-	unsigned long offset = swp_offset(entry);
-	bool has_cache = false;
-
-	cluster_rest = SWAPFILE_CLUSTER - offset % SWAPFILE_CLUSTER;
-	while (nr) {
-		cluster_nr = min(nr, cluster_rest);
-		has_cache |= swap_entries_put_map(si, entry, cluster_nr);
-		cluster_rest = SWAPFILE_CLUSTER;
-		nr -= cluster_nr;
-		entry.val += cluster_nr;
-	}
-
-	return has_cache;
-}
-
 /*
  * Check if it's the last ref of swap entry in the freeing path.
  */
@@ -1747,9 +1734,9 @@ static inline bool __maybe_unused swap_is_last_ref(unsigned char count)
  */
 static void swap_entries_free(struct swap_info_struct *si,
 			      struct swap_cluster_info *ci,
-			      swp_entry_t entry, unsigned int nr_pages)
+			      unsigned long offset, unsigned int nr_pages)
 {
-	unsigned long offset = swp_offset(entry);
+	swp_entry_t entry = swp_entry(si->type, offset);
 	unsigned char *map = si->swap_map + offset;
 	unsigned char *map_end = map + nr_pages;
 
@@ -1955,10 +1942,8 @@ void swap_put_entries_direct(swp_entry_t entry, int nr)
 {
 	const unsigned long start_offset = swp_offset(entry);
 	const unsigned long end_offset = start_offset + nr;
+	unsigned long offset, cluster_end;
 	struct swap_info_struct *si;
-	bool any_only_cache = false;
-	unsigned long offset;
-	unsigned long swp_tb;
 
 	si = get_swap_device(entry);
 	if (WARN_ON_ONCE(!si))
@@ -1966,44 +1951,13 @@ void swap_put_entries_direct(swp_entry_t entry, int nr)
 	if (WARN_ON_ONCE(end_offset > si->max))
 		goto out;
 
-	/*
-	 * First free all entries in the range.
-	 */
-	any_only_cache = swap_entries_put_map_nr(si, entry, nr);
-
-	/*
-	 * Short-circuit the below loop if none of the entries had their
-	 * reference drop to zero.
-	 */
-	if (!any_only_cache)
-		goto out;
-
-	/*
-	 * Now go back over the range trying to reclaim the swap cache.
-	 */
-	for (offset = start_offset; offset < end_offset; offset += nr) {
-		nr = 1;
-		swp_tb = swap_table_get(__swap_offset_to_cluster(si, offset),
-					offset % SWAPFILE_CLUSTER);
-		if (!swap_count(READ_ONCE(si->swap_map[offset])) && swp_tb_is_folio(swp_tb)) {
-			/*
-			 * Folios are always naturally aligned in swap so
-			 * advance forward to the next boundary. Zero means no
-			 * folio was found for the swap entry, so advance by 1
-			 * in this case. Negative value means folio was found
-			 * but could not be reclaimed. Here we can still advance
-			 * to the next boundary.
-			 */
-			nr = __try_to_reclaim_swap(si, offset,
-						   TTRS_UNMAPPED | TTRS_FULL);
-			if (nr == 0)
-				nr = 1;
-			else if (nr < 0)
-				nr = -nr;
-			nr = ALIGN(offset + 1, nr) - offset;
-		}
-	}
-
+	/* Put entries and reclaim cache in each cluster */
+	offset = start_offset;
+	do {
+		cluster_end = min(round_up(offset + 1, SWAPFILE_CLUSTER), end_offset);
+		swap_put_entries_cluster(si, offset, cluster_end - offset, true);
+		offset = cluster_end;
+	} while (offset < end_offset);
 out:
 	put_swap_device(si);
 }
@@ -2050,7 +2004,7 @@ void swap_free_hibernation_slot(swp_entry_t entry)
 		return;
 
 	ci = swap_cluster_lock(si, offset);
-	swap_entry_put_locked(si, ci, entry, 1);
+	swap_put_entry_locked(si, ci, offset, 1);
 	WARN_ON(swap_entry_swapped(si, offset));
 	swap_cluster_unlock(ci);
 
@@ -3806,10 +3760,10 @@ void __swapcache_clear_cached(struct swap_info_struct *si,
 			      swp_entry_t entry, unsigned int nr)
 {
 	if (swap_only_has_cache(si, swp_offset(entry), nr)) {
-		swap_entries_free(si, ci, entry, nr);
+		swap_entries_free(si, ci, swp_offset(entry), nr);
 	} else {
 		for (int i = 0; i < nr; i++, entry.val++)
-			swap_entry_put_locked(si, ci, entry, SWAP_HAS_CACHE);
+			swap_put_entry_locked(si, ci, swp_offset(entry), SWAP_HAS_CACHE);
 	}
 }
 
@@ -3930,7 +3884,7 @@ int add_swap_count_continuation(swp_entry_t entry, gfp_t gfp_mask)
  * into, carry if so, or else fail until a new continuation page is allocated;
  * when the original swap_map count is decremented from 0 with continuation,
  * borrow from the continuation and report whether it still holds more.
- * Called while __swap_duplicate() or caller of swap_entry_put_locked()
+ * Called while __swap_duplicate() or caller of swap_put_entry_locked()
  * holds cluster lock.
  */
 static bool swap_count_continued(struct swap_info_struct *si,

-- 
2.51.2


