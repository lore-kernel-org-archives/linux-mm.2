Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 88C6ED7879F
	for <linux-mm@archiver.kernel.org>; Fri, 19 Dec 2025 19:45:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F15796B00A1; Fri, 19 Dec 2025 14:45:07 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EC91B6B00A3; Fri, 19 Dec 2025 14:45:07 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DA0B06B00A4; Fri, 19 Dec 2025 14:45:07 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id C6BF96B00A1
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 14:45:07 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 9076B13709C
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 19:45:07 +0000 (UTC)
X-FDA: 84237249054.06.791957D
Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	by imf18.hostedemail.com (Postfix) with ESMTP id 85DEC1C000A
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 19:45:05 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=anMBd4HX;
	spf=pass (imf18.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.214.174 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766173505;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4HyDXgqLqhgB1GreDyVhfU9ccv+OxUjYGBlnoKiwIUg=;
	b=F9njARxJgpvN719O3FWHV/vaCvNzz0T4JV3P0uZ10ZshoxrWFgceiItnjNJ7OIh4s6QrfX
	b+7I3x56sGrhhnTpqKonFdsD8upkUuu3PYKSM40JFjH0MKp6pXR8lCngSwc79ZUppKZSFK
	WY+EzHIUfwPchjBxBdQsRtYx2QGxvqE=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=anMBd4HX;
	spf=pass (imf18.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.214.174 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766173505; a=rsa-sha256;
	cv=none;
	b=FvKaGurJ0LO5wKSA1gz+yzyPwFrbLaUG+6J7WIvM9UQez1K8GRUwdLFSaDjTOi7F2UN7yX
	Nf06phGQiMFXEAUODMDAAkNdf+2DL3Eae4ipedTiI4dWkOBdpCAvieeQzIcBiZaPXCgVsJ
	sFfjcj3opI9qLugvcP3LmPLoZmCx2xc=
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-2a09d981507so15055895ad.1
        for <linux-mm@kvack.org>; Fri, 19 Dec 2025 11:45:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1766173504; x=1766778304; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=4HyDXgqLqhgB1GreDyVhfU9ccv+OxUjYGBlnoKiwIUg=;
        b=anMBd4HXRbtz0gBHylZ3LZ+Td64OaeKU3cqO2lRKTUSWa+lwWqbecJW+/VNOO4USNz
         XD7DJUAI2pXSFiC62GISiWLB50mzvMw5f6Ue2ey2KxRXWOvvTxjd99ZR6GCMaOk98fYa
         g6dTdqEkrs+Qa5Wv30pnE3FK6OvPvRQtAevLs7dwGOzUmus0PoLj9CLD6B+UQ0Oduu5X
         FwrWhOXiLbyhPaKMJIrgxVfnjRPscrcKYEMDiohbpR7exAtdZjDjVtCU+hl3aVzXDBVG
         VvFAKrgieuNLk4HT6F53Qipu1u6ZoN0Q3XRImJluEMpI3CvYvvMQY9vFKomqiXLgqzgr
         gvVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766173504; x=1766778304;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=4HyDXgqLqhgB1GreDyVhfU9ccv+OxUjYGBlnoKiwIUg=;
        b=eFOFdjZpqI7vI2TtKbgkVBXe9kuOo5KA44Spd/QBUWD6ZoTmS6DhpEVu5Ex6jvJww1
         lH8pVWqPBo8mfKMq2Doqqy93EgeiXSf7qkQXJ6gF3VJUkrNJZyfTGv1xMxE+pc//WZFl
         odvfIQiZDA9g4Wu5glu4XtDFGXX6dqBM3WH3A3oCP4GiAE6DKOKd/JYQuPuOuatX9wge
         +oWJSqQ/9jmzyvsWvDUsxwULZCCYpe072NYjT4rumfVmxJstCiKmztNlJ2SR75akkzl7
         QlMV2rK9cYhUUxYebKy84oMYCIQX5Ydnf451NLImLrWeFXPv0NC00n8S8YT75pFCFvN5
         v+RA==
X-Gm-Message-State: AOJu0YxqAiCuPTnG3VMsP/1LU/kKAsq62d+Q+ck0WOirc1iYdD3fe/2I
	SubxgMB2dlK7xIVpStub3h2B7mWq/AlAqjSFJa/EcveObuEWBCrzBwuA
X-Gm-Gg: AY/fxX5eeny5HM6c7h8Qh+ZTClG6yZv/tLPc3yYmF5GU8fafHaCyTYjOJV6fAARWQQl
	vxXb7D21PYAN1OOUzl5PAzvPEXz+UdK3yhbPgyydzZ84mAjWytEQ2v4v+JATTUCOVDo0qVoQhz4
	osATx0lZSRnutzSjiPrdyqKB9F9I0Kb22NzTGv2xMYOzrKBrfDm8cOS8bpVVuNULMd0GyDk7Koo
	sOURi01FR4TpwW0VKaZfGIbkaZIHYCu69upK8Nz8VbY11WiX0BDgOSbahD8//A774xAALqE0cQY
	KZLc+RSvZA81CdLvUB0BVkjxkQZlo1kFIiRDkYMvtgxK4ZuI3EKAeZUDK3QuzipNYvzhlXfeZ6p
	VaU3hdZX5hUScwPnicfmYUhP7bL9074Bt7vZn5I6+mK+6tnY0LkIu+YZQpUIDilPpLnIe7OyOo0
	idfk4+mjXJjOjKYzZ20oGDoD1qfp+wv9+DDMincrOeUyIgNpwOcx/U
X-Google-Smtp-Source: AGHT+IEGbaYJLQwz82Y32ZQr8sGHVrxAKjqjmAa8Er6Pz2+vPVIlkrRIfDFe5BuAafoIgT8PdMNOUA==
X-Received: by 2002:a17:903:228e:b0:296:547a:4bf2 with SMTP id d9443c01a7336-2a2f0d5d63emr37997225ad.27.1766173504336;
        Fri, 19 Dec 2025 11:45:04 -0800 (PST)
Received: from [127.0.0.1] ([101.32.222.185])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2a2f3d76ceesm30170985ad.91.2025.12.19.11.44.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Dec 2025 11:45:03 -0800 (PST)
From: Kairui Song <ryncsn@gmail.com>
Date: Sat, 20 Dec 2025 03:43:39 +0800
Subject: [PATCH v5 10/19] mm, swap: consolidate cluster reclaim and
 usability check
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251220-swap-table-p2-v5-10-8862a265a033@tencent.com>
References: <20251220-swap-table-p2-v5-0-8862a265a033@tencent.com>
In-Reply-To: <20251220-swap-table-p2-v5-0-8862a265a033@tencent.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1766173451; l=4270;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=xnDm6QZuEKeEGBDI1eFAFieFZ69pdwgSuhajCqwh5kM=;
 b=pZFw4tAOtubaYjGkG7HZR43CluQtM+Je8zGxoWNwlsDS5aDQ0BsoQxekZjMJh12Tio/q49Cjp
 tgD9gG0XVyrBHTqTLZKoZLHUkwOqd9MNDB0iA5jtvC+Pq/1gFy6KW3r
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Stat-Signature: wscxhyhhpt39siej1tream91kpi9dqqm
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 85DEC1C000A
X-HE-Tag: 1766173505-932317
X-HE-Meta: U2FsdGVkX1+XxymLxLxh+JSoUymIiOYzcMz7MVnnUSQMeUZzBAuqxEKFY/4ID6c4hB/FaLYoLplDVr4z9dLU/ApnBY6Zqfwr8Qry0bv0KvY9awDSzgSY1ZzZfF6nSciMQprYT2YtR0Ek9Dyk4pVyhPQixP7Q+/xVZNQc/ME2T+JuoRAtm3b4GzQiU00dzmae8adrXHzfNI0A086/J7EGEnPZ9SPJaWiXrzM/idY9cusHKg7OxuJNCqBO0uQj9eEZuyOPOzNJUzaTUBsUBu9lQYMI4EW7BU4FacK66s3imk2CRQb4OhlWt7BSyS1qc734VBCnw9rTTzfLv109q/pN12jFwTOmKHYy8EEN3K5X2Msrf7cRUBxQsbc+5rdhOrdw9BK+v+2x90g33oFunjR/jJv0fK8gJHxOb6lDF2SmO+NWZgQN72GfbHZOgRCNDtIvSh1cEZniNkD8mjX+bYawEmCg9uPkNqm4OwvTnasJZzaH0CiRcWJ+NPVgYkb6kjKPndjB8Zm4V5dcQNn4/1M2ErUUXQGnGBsyeBsaR6OI10CgSZj0gb0V7kUbTetTvEf4U6V3yAJfHTgh80YJjx2oawTMzz5Tipu26ctALoH/K16EzJhtT/EURf8eZjts186SiMHVwwvm8eEdSN85M3hVsqsHn96XBQKgtphSy/S4VpgxSNjNip6bXrwgQxobZLhUW5ek9i3TG19rBMyEhvyz2G3y73Sc0gE0ihVk7CdBdKlxVIE731BN4O5nRXf+Qcm2ho1hXI8Kh/WSlufChpbW+dVdhPEtFi4ATRy7855w74wCdNW7I7OcBWTCzRYuijJ6P65B7S6BO8UUMHFpuRFY4O3pk9L8nHGYulqjbZqff5MYbKhPFaoqMROHfHhhXaPJy1soTBTAfaRQ8H7Kqz5/NO5K4HfyW9Up/M22zY4HE5Ux5zBcv0S/Nmb9AzvY2S4yE6vc902WdAjwTVB5Xi+
 5i2fchOt
 NIsFamCApOpBzc2i3J4xaptHOCk+jpjZrLFGZtDOFn6cOJXCZ18HSTykq/tOQ2euaTWPGAVmOZXl2dGqLQ3AYLeLA+6UHo4yswcyfUmUn4qY2+DsTsRWYhVd3DUEqqPYHn2YN/xOmysmbL6c2L0fXGImNLfXE3L9cFRZ71xc033Pi0F87CzJ2++sTP18idLjLHIeDfZyP1lE09WItJqPbr0aqQbmVL78C1k354gkaaM34HQ6tOWhcks2onsRGTNnOW+K2W5Hd1m6SiR5j+wG7vnUiCUTtgKNS9KRbZ9YlWKzK2FTSWzrnHGhC930yLO0C5x/PcN3adXiVnNuw9YLJ6ACO9dbze6+uVmqFtljl1XXoTCmjc5ssol+Fb63GENylF3+xtOOSPhuSnar2+traHrZK7nodZqwiBLhUi5jtjHT1R14tkbBo37l0hA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kairui Song <kasong@tencent.com>

Swap cluster cache reclaim requires releasing the lock, so the cluster
may become unusable after the reclaim. To prepare for checking swap
cache using the swap table directly, consolidate the swap cluster
reclaim and the check logic.

We will want to avoid touching the cluster's data completely with the
swap table, to avoid RCU overhead here. And by moving the cluster usable
check into the reclaim helper, it will also help avoid a redundant scan of
the slots if the cluster is no longer usable, and we will want to avoid
touching the cluster.

Also, adjust it very slightly while at it: always scan the whole region
during reclaim, don't skip slots covered by a reclaimed folio. Because
the reclaim is lockless, it's possible that new cache lands at any time.
And for allocation, we want all caches to be reclaimed to avoid
fragmentation. Besides, if the scan offset is not aligned with the size
of the reclaimed folio, we might skip some existing cache and fail the
reclaim unexpectedly.

There should be no observable behavior change. It might slightly improve
the fragmentation issue or performance.

Signed-off-by: Kairui Song <kasong@tencent.com>
---
 mm/swapfile.c | 45 +++++++++++++++++++++++++++++----------------
 1 file changed, 29 insertions(+), 16 deletions(-)

diff --git a/mm/swapfile.c b/mm/swapfile.c
index 6d2ee1af0477..f3516e3c9e40 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -777,33 +777,51 @@ static int swap_cluster_setup_bad_slot(struct swap_cluster_info *cluster_info,
 	return 0;
 }
 
+/*
+ * Reclaim drops the ci lock, so the cluster may become unusable (freed or
+ * stolen by a lower order). @usable will be set to false if that happens.
+ */
 static bool cluster_reclaim_range(struct swap_info_struct *si,
 				  struct swap_cluster_info *ci,
-				  unsigned long start, unsigned long end)
+				  unsigned long start, unsigned int order,
+				  bool *usable)
 {
+	unsigned int nr_pages = 1 << order;
+	unsigned long offset = start, end = start + nr_pages;
 	unsigned char *map = si->swap_map;
-	unsigned long offset = start;
 	int nr_reclaim;
 
 	spin_unlock(&ci->lock);
 	do {
 		switch (READ_ONCE(map[offset])) {
 		case 0:
-			offset++;
 			break;
 		case SWAP_HAS_CACHE:
 			nr_reclaim = __try_to_reclaim_swap(si, offset, TTRS_ANYWAY);
-			if (nr_reclaim > 0)
-				offset += nr_reclaim;
-			else
+			if (nr_reclaim < 0)
 				goto out;
 			break;
 		default:
 			goto out;
 		}
-	} while (offset < end);
+	} while (++offset < end);
 out:
 	spin_lock(&ci->lock);
+
+	/*
+	 * We just dropped ci->lock so cluster could be used by another
+	 * order or got freed, check if it's still usable or empty.
+	 */
+	if (!cluster_is_usable(ci, order)) {
+		*usable = false;
+		return false;
+	}
+	*usable = true;
+
+	/* Fast path, no need to scan if the whole cluster is empty */
+	if (cluster_is_empty(ci))
+		return true;
+
 	/*
 	 * Recheck the range no matter reclaim succeeded or not, the slot
 	 * could have been be freed while we are not holding the lock.
@@ -900,9 +918,10 @@ static unsigned int alloc_swap_scan_cluster(struct swap_info_struct *si,
 	unsigned long start = ALIGN_DOWN(offset, SWAPFILE_CLUSTER);
 	unsigned long end = min(start + SWAPFILE_CLUSTER, si->max);
 	unsigned int nr_pages = 1 << order;
-	bool need_reclaim, ret;
+	bool need_reclaim, ret, usable;
 
 	lockdep_assert_held(&ci->lock);
+	VM_WARN_ON(!cluster_is_usable(ci, order));
 
 	if (end < nr_pages || ci->count + nr_pages > SWAPFILE_CLUSTER)
 		goto out;
@@ -912,14 +931,8 @@ static unsigned int alloc_swap_scan_cluster(struct swap_info_struct *si,
 		if (!cluster_scan_range(si, ci, offset, nr_pages, &need_reclaim))
 			continue;
 		if (need_reclaim) {
-			ret = cluster_reclaim_range(si, ci, offset, offset + nr_pages);
-			/*
-			 * Reclaim drops ci->lock and cluster could be used
-			 * by another order. Not checking flag as off-list
-			 * cluster has no flag set, and change of list
-			 * won't cause fragmentation.
-			 */
-			if (!cluster_is_usable(ci, order))
+			ret = cluster_reclaim_range(si, ci, offset, order, &usable);
+			if (!usable)
 				goto out;
 			if (cluster_is_empty(ci))
 				offset = start;

-- 
2.52.0


