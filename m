Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3D32A60A263E
	for <linux-mm@archiver.kernel.org>; Wed, 21 Oct 2026 06:03:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=Q1SYo9zg
Received: by kanga.kvack.org (Postfix)
	id 66F146B0606; Wed, 21 Oct 2026 02:03:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 646ED6B0608; Wed, 21 Oct 2026 02:03:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 50EC36B0609; Wed, 21 Oct 2026 02:03:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 30D206B0606
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 02:03:46 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id A1D3B16046A
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 06:03:45 +0000 (UTC)
X-FDA: 85345592010.12.D1F8B5C
Received: from mail-yx1-f54.google.com (mail-yx1-f54.google.com [74.125.224.54])
	by imf29.hostedemail.com (Postfix) with ESMTP id D5DF5120007
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 06:03:43 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Q1SYo9zg;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf29.hostedemail.com: domain of nphamcs@gmail.com designates 74.125.224.54 as permitted sender) smtp.mailfrom=nphamcs@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792562623;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+TsRxErWT6koYb6Xgo6QbB8vqh49N8f3WZDdlHz9iT8=;
	b=nd112B0+ZeQEejIWEhqIMZipJSdHIGwSUdnMSEisPMz/ewldI+NIeLC+WwL00vYW4T74VN
	7Nu4pr7w3S8jbfuQMTGeOwd1NBwvUEKr/CKSoehheIdLz4P3/qSWSid8ISt20z6UcBdt4k
	WsGaEr4GMjyjAbkihEOJPGLu/2LdkWs=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Q1SYo9zg;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf29.hostedemail.com: domain of nphamcs@gmail.com designates 74.125.224.54 as permitted sender) smtp.mailfrom=nphamcs@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792562623;
	b=GTQR0V524UQIsdobUR8vX6YvhBiPTl5wVJkGFywahUF1LiSQ+D98TvS5JWhT0ALIUcCKM2
	riUC1/BrVjFp308O56lLwAH3xeYFPUWe1LmgQOTXBAfb9trxsGbNQWgiFzOjT37zIbtig4
	SFvwkL5OpB+z0K1uvCryLW/vZaqk7lo=
Received: by mail-yx1-f54.google.com with SMTP id 956f58d0204a3-677d35fd1d2so345207d50.1
        for <linux-mm@kvack.org>; Tue, 20 Oct 2026 23:03:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792562623; x=1793167423; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=+TsRxErWT6koYb6Xgo6QbB8vqh49N8f3WZDdlHz9iT8=;
        b=Q1SYo9zgFjBLSg2xKa/MAdbFLVEK2+s7S46rO+2TjifldQKcZzFOhmaUjNCRA/mVqf
         UL1K1fBjioJ0a92sg2FreWSxlQom8RIPIliL75g1CsQqEX4OFipxjHefDzSdE+bOCZV6
         5/jjjFpD+CtQ//Iya3TK80cAaSE8W+8jPWAM6b8oOe8EOaPR82YwurXwFh9SH8P2fZXe
         YlACs3gMfgc6+0XjZhau+M5rm4EyWNcgTgwyVOgA5B0tqQGmGWPIBCxnve2HYHf5/dkb
         4RS56QaPuD4RMhSg5Vu7CfZocz1iWZCHDIEXEMQbuXFXIg1x2U3R075umjPusOAs7ZvB
         PEAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792562623; x=1793167423;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=+TsRxErWT6koYb6Xgo6QbB8vqh49N8f3WZDdlHz9iT8=;
        b=Oit2Pm8wUT/cF8vuB0L9L/bd5+sBPq9lRXqpI7ouDI+1bOB/qTr8Ew9JyRMSHhs8GI
         6RFV1jW78NIfM6e0Hxmgtcn84TCH0T1wiqVzcs5o+EVfmwDTeN7oA73OMxYEnwyVgQH1
         MTjjPbsv9zPyqHfT3b9ffJllNiExXy/uc76N0ZF5nbjQ3Uy0qIUVhe/fMFQcvsMPTT/u
         /X81auMxI/5R8Y5DvzdqwXgLWe3rdHFklk9ScRoEV3trYyAL+N2fTXHWkN6yEgkw2dYV
         YBTvqlFgE3zpxMul0XxarYivrfv9k59aP7cRWK7fu5z1MkzkzureUYMfZD9LImufYhpu
         5teA==
X-Forwarded-Encrypted: i=1; AKwUvBxfFjAw53RCVHux69vufX0SemKb5Pi3j2zSBwC0WNNVoa56/MaaWQ7DKWBslK3oU2XwYqmCXQj0CQ==@kvack.org
X-Gm-Message-State: AFq9FYJb83591cg7ft2yiXUa17Ef37g/JmydM4TLYaPD6PVRabclJcnf
	ceaMc7Fi1b1wB6/6XNV1kyxmc9dmn0QPgm7Ot78oyQ8AdcgidZoKplOB
X-Gm-Gg: AYBFou3e7mI2t0VplyYhJkL5qckfuVVUHDP4Nhjh1jfYcCTTlKfiR1rFxi3QPsr4eTK
	OqVnrHc0lCIaPqT4Db1cnjNu15qKPBzm0lWFVItpr6Urb/KGlhG6ZvWr4FZFRRPoY1bFXE/awft
	e3kMhFjhq7lIKrre84Gm+xa6+74YCthFtDpsp7Pl5jJalyyA7NYm1HjUAOhUB3H14VQj0PvnJso
	XiqKgiAPTMwz4OkZN2CDNiLwInFx3ThaZ7517RPCzoZpPA5MjOs46vbqXzdExmJhdlyRwZ6rMKB
	VOzgkY9wo8UTB677Q3QQq3HZPQ3rysJhPuyAdWb+xC+3GmHDwpS1wYeaYVxlpU380BjNSWsnCii
	sfMTd6au9juukT30KAYjfOOR2M1RqLlmNMTLnCivTQad0RdG2VL5yL1Hb7rgXjxx8SQ/D1SJKS7
	WI1qAdWEx1pAaJQBQd/8DzSjGIiKgAwZmLMVsbGmTW/GEpO67LTialilTFrVeKXx3N2tJSG8/Ls
	jyq2bJ3Td3TKWaDXnQM7Oq7/mQZjeENm8OujIsyOalwbz+DhTBV69SK4DCINAffZrwwISWPi4pw
	6pzC3+0wNVRO3j/EG2zfymnxpwVd7i/cQK//4cV48tmm8EwYgE42+hG/jewIjrAsYg1f/bjTD16
	YCXbMag==
X-Received: by 2002:a05:690e:488d:10b0:679:8c5f:3fb6 with SMTP id 956f58d0204a3-67a0e0417acmr381635d50.9.1792562622988;
        Tue, 20 Oct 2026 23:03:42 -0700 (PDT)
Received: from localhost ([2a03:2880:10ff::])
        by smtp.gmail.com with ESMTPSA id 956f58d0204a3-67a0e496732sm619480d50.5.2026.10.20.23.03.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Oct 2026 23:03:41 -0700 (PDT)
From: Nhat Pham <nphamcs@gmail.com>
To: akpm@linux-foundation.org
Cc: chrisl@kernel.org,
	kasong@tencent.com,
	hannes@cmpxchg.org,
	mhocko@kernel.org,
	roman.gushchin@linux.dev,
	shakeel.butt@linux.dev,
	yosry@kernel.org,
	david@kernel.org,
	muchun.song@linux.dev,
	shikemeng@huaweicloud.com,
	baoquan.he@linux.dev,
	baohua@kernel.org,
	youngjun.park@lge.com,
	chengming.zhou@linux.dev,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	qi.zheng@linux.dev,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	riel@surriel.com,
	gourry@gourry.net,
	haowenchao22@gmail.com,
	corbet@lwn.net,
	hughd@google.com,
	baolin.wang@linux.alibaba.com,
	tj@kernel.org,
	mkoutny@suse.com,
	skhan@linuxfoundation.org,
	rdunlap@infradead.org,
	kunwu.chan@linux.dev,
	kernel-team@meta.com,
	nphamcs@gmail.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	cgroups@vger.kernel.org
Subject: [PATCH v6 05/12] mm, swap: enable THP swapin for vswap entries
Date: Tue, 20 Oct 2026 23:03:16 -0700
Message-ID: <20261021060323.553433-6-nphamcs@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261021060323.553433-1-nphamcs@gmail.com>
References: <20261021060323.553433-1-nphamcs@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: D5DF5120007
X-Stat-Signature: iramf43n9p9qn4855kqbigg7mi7zbbjq
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1792562623-53314
X-HE-Meta: U2FsdGVkX19X1VMyUO7zi03gmtC8eH1gKUWW/IzbbH13ujamr8Racixe1Yn1aTrm2TN7gl+B/4NFKFur9bskr9du+wu5AahJJWDQqIRi0CV5w6apskIJg5oxClEZTaWoUI0HIMVB8IjNgFf4DBHtA0Y8DLxWTcxvewwOmt6F/WjDuwX9B1Dwwc1mTW3bX5x/lFFbt7iL3dq2N9fcNLaH+UnbQgFAewtYkxsVYZe9QAnWyOT4WaruhXzlulrJ1S7tWkXPQbpXip/PkTpeGHnWTQ57DfCa+VOA6Wtj6qwJbtowBGbaUgKxcnzySXD1sGOoqdkwB22X9hEqGiUlZNQI6EBUjtvUNRlAn2iRaJKA/J+2Y6INq0+d3uNvjKUZtPVk0Sz+mkbtftCOhmTC0TZIVYF52vbU4Dk1+BhbZNCuBKK4PobckxRjDiIh6VsjdTxjKLKy1D/gqmPsIwViRmIYRSrsJO8SRAxgrzWXmtDtklUBiyoly0c+YyCBDaC2Nlixu2w5EVuC18QSwq9wemT/LOX0DDP1jAy16js5q2GKn2zZPRwlIHGNF/qSMJzgwS9hJwoYh69iBM3/bOdqurSOHvtMjr5BLckLPG5+c/s933oiPZiall11j5r1+gZnNxjwSSquo33u9zFh496hg+1oQ7Cwr96sFit0cCmCx9SgxO20uCJGRf4SYAvDY1y1EfmF3rDHGzzHp/Q1LrID+4rlAwcS/2hbyXwdsy+SqjmGYZ+DmrH9yReIabaeZwhKdk6V9azOtxBfd0sWlmWeFBhEjQ8hQYz7tI/XWFf0zma+C9+gliZBEFuIAmg37RNHAURJi0d2bhVRfEK/9ScBUrmXSCmMEnRZpgY8Qliz4o5EAUS+bf2e8ZWNaq/FMAWwRUd0Csz7LiCOq5jvlfdaL0Mm6k7SJQomx4Kle3FyyUgyIss7NQBf6m7ggJeYdDQ10Ur8SODm1SbLeWQZHNE1irN
 fl/ZoLJS
 1TS/zKdHkLZkDCYnQ3vlnUtrsQux+QxvbU08BxGNVR9V1xj3FY+SOvUmH8KPkhesKZmXECUDDI+KwIv4XHp+zu0x6vFq6pijpfrNMUCMNStEmujlKWqTOym2QvB5DORXYnVOmE8KtGQMR0GNaCyoTesq5JrLoA2yn+RmOl5f0sn23Rm4aV42otzWN5PwLtSKug1XSfdGYZwKNCxgCkxPlUTzPIesFEiLyAjr9CKF0RWPCGjwp1/75FIwTlQ676M3ymRuRX/TYrh76tqoCbc18PoZongZ8+Sydq7ANdfpiLVq+pA2oXkKOcUsAlTMUe/DNxKPBD0snoIJxRIV/plXNyPfIIMlWa4UBDTyK0J8EA6mUsPebK33rjBFnP4qUeu2kw3u59k9aL7oYADuVEsvaEHK3I3oJhmh9lW3lp5LDvEWPCkmlhKVDdD/J9d540cYjkln1voFG3DumfIoJRmz4/QqBXA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Swap a large anon folio back in as a unit when its vswap entries share a
contiguous run of physical swap slots on a synchronous IO device,
instead of always falling back to order-0 faults.

A zswap-backed or mixed-backing batch is still refused, and the fault
retries at a smaller order.

Signed-off-by: Nhat Pham <nphamcs@gmail.com>
---
 mm/memory.c     |  5 +++--
 mm/swap_state.c | 17 +++++++++++++----
 mm/zswap.c      |  6 +++++-
 3 files changed, 21 insertions(+), 7 deletions(-)

diff --git a/mm/memory.c b/mm/memory.c
index 9f651d247eef..430b83900ba8 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -4885,9 +4885,10 @@ static unsigned long thp_swapin_suitable_orders(struct vm_fault *vmf)
 	 * lack handling for such cases, so fallback to swapping in order-0
 	 * folio.
 	 *
-	 * THP swapin for vswap is not supported yet either.
+	 * Vswap entries are checked later, under the cluster lock in
+	 * __swap_cache_add_check().
 	 */
-	if (is_vswap_entry(entry) || !zswap_never_enabled())
+	if (!is_vswap_entry(entry) && !zswap_never_enabled())
 		return 0;
 
 	/*
diff --git a/mm/swap_state.c b/mm/swap_state.c
index 3900975c675f..6c8e8f49e349 100644
--- a/mm/swap_state.c
+++ b/mm/swap_state.c
@@ -174,6 +174,9 @@ static int __swap_cache_add_check(struct swap_cluster_info *ci,
 	unsigned int ci_off, ci_end;
 	unsigned long old_tb;
 	bool is_zero;
+	struct swap_cluster_info_dynamic *ci_dyn;
+	enum vswap_backing_type type;
+	int ret;
 
 	lockdep_assert_held(&ci->lock);
 
@@ -202,11 +205,17 @@ static int __swap_cache_add_check(struct swap_cluster_info *ci,
 		return 0;
 
 	/*
-	 * Reject a vswap batch so __swap_cache_alloc_folio falls back to
-	 * order 0.
+	 * For a vswap entry batch, reject if the backing is not THP-amenable
+	 * (e.g. uniformly ZSWAP, or mixed). The order-fallback loop in
+	 * __swap_cache_alloc_folio will retry with a smaller order on -EBUSY.
 	 */
-	if (is_vswap_entry(targ_entry))
-		return -EBUSY;
+	if (is_vswap_entry(targ_entry)) {
+		ci_dyn = container_of(ci, struct swap_cluster_info_dynamic, ci);
+		ret = __vswap_check_backing(ci_dyn, round_down(ci_off, nr),
+					    nr, &type);
+		if (ret != nr || type == VSWAP_ZSWAP)
+			return -EBUSY;
+	}
 
 	is_zero = __swap_table_test_zero(ci, ci_off);
 	ci_off = round_down(ci_off, nr);
diff --git a/mm/zswap.c b/mm/zswap.c
index 24c4e7a73d56..1b91dba992ab 100644
--- a/mm/zswap.c
+++ b/mm/zswap.c
@@ -1753,9 +1753,13 @@ int zswap_load(struct folio *folio)
 	 * range on the backing device, so scan the range rather than rejecting
 	 * it outright. The caller has pinned every slot, so zswap cannot start
 	 * a store or a writeback into the range while we look.
+	 *
+	 * A vswap batch is checked when the folio enters the swap cache, and
+	 * its backing cannot change after that.
 	 */
 	if (folio_test_large(folio)) {
-		if (WARN_ON_ONCE(zswap_is_present(swp,
+		if (WARN_ON_ONCE(!swap_is_vswap(si) &&
+				 zswap_is_present(swp,
 						  folio_nr_pages(folio)))) {
 			folio_unlock(folio);
 			return -EIO;
-- 
2.53.0-Meta


