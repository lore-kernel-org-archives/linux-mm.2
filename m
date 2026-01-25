Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5CD9CE63CAC
	for <linux-mm@archiver.kernel.org>; Sun, 25 Jan 2026 17:58:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C2F4F6B0092; Sun, 25 Jan 2026 12:58:27 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C003A6B0093; Sun, 25 Jan 2026 12:58:27 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B18E46B0095; Sun, 25 Jan 2026 12:58:27 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id A22BA6B0092
	for <linux-mm@kvack.org>; Sun, 25 Jan 2026 12:58:27 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 59BFC8B0A2
	for <linux-mm@kvack.org>; Sun, 25 Jan 2026 17:58:27 +0000 (UTC)
X-FDA: 84371245854.28.FC5C17C
Received: from mail-pf1-f177.google.com (mail-pf1-f177.google.com [209.85.210.177])
	by imf20.hostedemail.com (Postfix) with ESMTP id 660E31C0002
	for <linux-mm@kvack.org>; Sun, 25 Jan 2026 17:58:25 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=SNnlO+9G;
	spf=pass (imf20.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.210.177 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769363905;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CkTKKula0DQd5wgE6uWfgSKH0QJhpKGSFifSGYvHSoo=;
	b=Fdmy/3bloTqhYOt+3I/YbXtwxhYQLY5N69TMLZ+/w/yKX8jP0qdDePFWa+K0UOShZUpUrc
	rBiTnd8CX9mEHv//sfQI4HROj+vg9zKphco/t4YXYMZcsEvEy/h3A9r4OWEIMRuMmkb70S
	xfoWTMqnXBv+F3SpA1S99N9RH7f4Og8=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=SNnlO+9G;
	spf=pass (imf20.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.210.177 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769363905; a=rsa-sha256;
	cv=none;
	b=r0/SeOlLHZPAsCK9XMr9e/ADd25RWhoQ/FH0IIv67eKamjio9kR4iC459XbdFqyd8quvfV
	CuLcIf7q1UU9Ko45It+HvsuQPI/2F4hWtwV4QFsOdRvJa2RY2siVcZvR+NSKX5VKj4Kuwc
	dAaD+oWhKSNqP3jxFDoluDZ6eoR0qg8=
Received: by mail-pf1-f177.google.com with SMTP id d2e1a72fcca58-82318b640beso1214524b3a.0
        for <linux-mm@kvack.org>; Sun, 25 Jan 2026 09:58:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1769363904; x=1769968704; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=CkTKKula0DQd5wgE6uWfgSKH0QJhpKGSFifSGYvHSoo=;
        b=SNnlO+9G4BH65LZzrQqigh3cK8LQc2QBHlMGf0aJVFPF9hGrk6ewm5GcsrhjWcXR7e
         ZKtKMHAtNI1lPHHYL+aagWvxu+r5STOgUWCSiYp+TuslLC1APhO5A14HozLwCoptXB+w
         ceSiZyiwKUnWJKewz/1foecVYurpaGRnu8F5zzZQis2V3PNfOl+MjcxfzvL8JBo3wYni
         9aOeAKUHNFdLFJpCvzWfAwh5tlrTtt0HfjDaCQIW4V0Wmwk/ukXfq7RTDQdgBtddfmOE
         62aP7VKaD1PE6s3wwxRw3tmp8Oy/OyDweP+60IzQtfW4pjkYC5k/G0pYQx+//taQR3Jq
         efQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769363904; x=1769968704;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=CkTKKula0DQd5wgE6uWfgSKH0QJhpKGSFifSGYvHSoo=;
        b=c22bEx4jW4mzAkmxn2zNl4/qOg8YoKX3bkmHX8SY/GnPcjDUcLmaiLOamgskLXqqZ7
         Utll4hqn859n7FODes9h7advTg6TbARane7mMnq15P2JirLFyINRESFdw25ya0ZAQn3N
         bs+C/V7q8Q30vN/vhtnQakQO1T8FbP1LieguzJkEyfnZzJIyXnzh+W4y1JWefzW2UVqO
         zKgFmmmcJj0j3tOSZOBNt3sAcjGxVs3Yaa83mYVymDbmbRfRlGxyZi+ieEzFnlszFkiE
         k6d8UdVdr7mml731y3uJ1sX9Ub1tRj5gJddQfLF+JBuzMWasVrOVO5TWHgsl6p05f/7+
         sevw==
X-Gm-Message-State: AOJu0YyqLlw6/eLsEZYagd5x5hqCfSGd2F7HZo5kavAg3WAR5eqO9SGG
	LdctkcE2JFTsDvElFdgdE21W4b7fwlV/KykN8cfs8ssJ21o2nWFMGQq3
X-Gm-Gg: AZuq6aIlnp4BwGAqWh9LrKxMXD7K+dVgatKZKIx2GiCuT/RNlw8H0tb1ePf5S4n9XYf
	A2FiHwLC3DhmULRvCOkTZg5t4SmVb0WyDjjfLTj4RPAbpqeU+KBfjVtCNFFE9/MKTWP8QoeYOQO
	GnbfzIlE/dPEcbZqODtKI1LMtHvUoyIXfrEQeLNjknaKslwAYbjAsV+GfrflJG3MVnCCUH7T0Oi
	1kC/WgH/W8vHQA02V+d5UyzGR69vpr/5Msvy7+tI3Un36I+w5cCMmbM5DrzYIzlhUN/NxxyvH94
	+fTCxXjjArtAjHoBSdDSKta7Lj6vbHD250TSnCOPKB8IzBw1Pm3O8DyJiwZJHNcuwH8HAj9ZeP3
	TxXF54qd65ByPe4Ua9Wq1yaGDF7tzwKwHb3uiyE0dSEH3Ppylxre7K7HKmQq/a09oDCNA4c02si
	OdRjK97JKnVJErjBdrISwdwxFpE28KdArUP2q0/XFpU2dWBcEIsZRv6D/GzQw=
X-Received: by 2002:a05:6a00:418c:b0:81e:81fb:b392 with SMTP id d2e1a72fcca58-823411dd0bbmr1927837b3a.11.1769363904271;
        Sun, 25 Jan 2026 09:58:24 -0800 (PST)
Received: from [127.0.0.1] ([101.32.222.185])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8231876e718sm7405963b3a.62.2026.01.25.09.58.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 25 Jan 2026 09:58:23 -0800 (PST)
From: Kairui Song <ryncsn@gmail.com>
Date: Mon, 26 Jan 2026 01:57:28 +0800
Subject: [PATCH 05/12] mm/workingset: leave highest bits empty for anon
 shadow
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260126-swap-table-p3-v1-5-a74155fab9b0@tencent.com>
References: <20260126-swap-table-p3-v1-0-a74155fab9b0@tencent.com>
In-Reply-To: <20260126-swap-table-p3-v1-0-a74155fab9b0@tencent.com>
To: linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>, 
 Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, 
 Baoquan He <bhe@redhat.com>, Barry Song <baohua@kernel.org>, 
 Johannes Weiner <hannes@cmpxchg.org>, David Hildenbrand <david@kernel.org>, 
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, linux-kernel@vger.kernel.org, 
 Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1769363877; l=8883;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=FaLMbQqW7ETAqIJMdO/kAwe98yiKvc5zz/kgiu2u1QQ=;
 b=zZFLWTrUx22bzcHL3DV9tNiGxIw22UXloT7umwsUfIDGmzimDMLLgL1mCbikMWqIVoer/2AwY
 jU8qKLCxKR+C3BqaGaZIwT3R3S++voh36ZJ1yDI6KK7CyQoaVFJQdrj
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Stat-Signature: jeigik81913nrxix7pbdkbg19hhkgbr8
X-Rspamd-Queue-Id: 660E31C0002
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1769363905-904307
X-HE-Meta: U2FsdGVkX1+j0BjUIavLxgnR2Oll1luUCCd2aa4bPQS+mbjbBSkT69+HPYSdKPD4XKUjlvk/UOWYJrokRJvhblmxiVFIbBNCVbTpVi4oIgdLvE+XtwEXBlzywE+vcwmvPCtM6lder4TKyulQXn6KrZZKMa+dUjNGkDGy69GZzOk9MUByhTW4tSESYS3gUpY8eYo9XDXhJdbRC29mGLhVszfFNWmQyGHa6KTO2dUVhEYTf888wGPzE88yhwxQh6chDEJ2qAuQFB8sCyd1QjZuxMVSvscQuD1eEtih5pMr/o5snssYN1vQneSEPlvlmJz+qikUAfInGVHvntFJd218IcD9jO0N8qs4nhAh+xXYs4lg9zPaNq+tPipKxoUTvlbK99OTCsqI0MJ7d/7IeflWq39uD4Mn9+auRep7OlQxZVTIIhwdG2NzHcfOr9jFW6zN01qnHVAMCZOfQYyPhDsTEngTEjoaA0XGLP32yQVZSeic1du6hDuV4SX77tbiHjmG7QknFxFglIaCmKEBlJbwGovVI8LNVd1EZXWQCP3evGe3zSP2YGce+UwAjHrYl5tcJg7di0vkx57GF69k12uh7PN8Z5dkMuvlyc2QywH0n/24bclcX5E4pyuon2l0pfGcq9lrxNyVe03C6chVxf40toHtIof0daALy7C+T8wsgQCccV1AIhblL4HlyvttdgP6+toMiBVuffuhyf+4KaCkLuAQJC95l3mxZ2oQ+PG1vUxJISvdEkj1WQ4+mCu4oepSndMRAnk8oMlnFzK7tl3zXSJ1fBIGgOOY/O0X0U+KYLIsLz6bJxlQtj0jrCX5AxFTZSmosGaIFf65kjppW2cp10/IQ0f/JMxNLAB+SdGj5eMUY/49P5E0FBIXC1Kxwt7Oqa0h0ZOH1Km6MSVBM92gp/lplehJ5Gk0r5SCAgrNZ76+tSCas+xf6lSMmW+UaU6zPoIsKJ3ZhYFGi3z43vc
 kD4Ds21I
 QXvtCUyylNj5ksB6/p00QsnbKCgx5J0/VgJ/8ziFmZY5WyQBUdmAX2hqvgrnr+ZIHALW4Ah6vBWDwksO4baACbcdT0+qc2R6b50KQRvFJZHMubUIHvGux6f9rOjryYmjA7L1+jmCH27+f8AjXO/LfcdIlmHiD7TcaBdfpiZzeuDpdQDp+MVroASGRXFfqX684/ZEGw9LLHAPvhYTzVi3aqwcZER4hTWiwvgIelJuGeR6N9lD4R8mzVeDiFyrA2FlIfskstqIEuKpFEoKQAFiR9WcTRWbUf8Q2VwQiD4HSa2HjId6O2ybSnAmtUDrtV94LMiktJrahxgHxSJV/y5Yq41m0DNBEG1agAyZI0V4iLqQs21O5IL9GoB1APXW9ewLh6hJZ/pRDI/YCqV/tTI70vKKNRcXK6QgEjLp7OxOIcMcPcXwsBD2HYGFgkg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kairui Song <kasong@tencent.com>

Swap table entry will need 4 bits reserved for swap count in the shadow,
so the anon shadow should have its leading 4 bits remain 0.

This should be OK for the foreseeable future. Take 52 bits of physical
address space as an example: for 4K pages, there would be at most 40
bits for addressable pages. Currently, we have 36 bits available (64 - 1
- 16 - 10 - 1, where XA_VALUE takes 1 bit for marker,
MEM_CGROUP_ID_SHIFT takes 16 bits, NODES_SHIFT takes <=10 bits,
WORKINGSET flags takes 1 bit).

So in the worst case, we previously need to pack the 40 bits of address
in 36 bits fields using a 64K bucket (bucket_order = 4). After this, the
bucket will be increased to 1M. Which should be fine, as on such large
machines, the working set size will be way larger than the bucket size.

And for MGLRU's gen number tracking, it should be even more than enough,
MGLRU's gen number (max_seq) increment is much slower compared to the
eviction counter (nonresident_age).

And after all, either the refault distance or the gen distance is only a
hint that can tolerate inaccuracy just fine.

And the 4 bits can be shrunk to 3, or extended to a higher value if
needed later.

Signed-off-by: Kairui Song <kasong@tencent.com>
---
 mm/swap_table.h |  4 ++++
 mm/workingset.c | 49 ++++++++++++++++++++++++++++++-------------------
 2 files changed, 34 insertions(+), 19 deletions(-)

diff --git a/mm/swap_table.h b/mm/swap_table.h
index ea244a57a5b7..10e11d1f3b04 100644
--- a/mm/swap_table.h
+++ b/mm/swap_table.h
@@ -12,6 +12,7 @@ struct swap_table {
 };
 
 #define SWP_TABLE_USE_PAGE (sizeof(struct swap_table) == PAGE_SIZE)
+#define SWP_TB_COUNT_BITS		4
 
 /*
  * A swap table entry represents the status of a swap slot on a swap
@@ -22,6 +23,9 @@ struct swap_table {
  * (shadow), or NULL.
  */
 
+/* Macro for shadow offset calculation */
+#define SWAP_COUNT_SHIFT	SWP_TB_COUNT_BITS
+
 /*
  * Helpers for casting one type of info into a swap table entry.
  */
diff --git a/mm/workingset.c b/mm/workingset.c
index 13422d304715..37a94979900f 100644
--- a/mm/workingset.c
+++ b/mm/workingset.c
@@ -16,6 +16,7 @@
 #include <linux/dax.h>
 #include <linux/fs.h>
 #include <linux/mm.h>
+#include "swap_table.h"
 #include "internal.h"
 
 /*
@@ -184,7 +185,9 @@
 #define EVICTION_SHIFT	((BITS_PER_LONG - BITS_PER_XA_VALUE) +	\
 			 WORKINGSET_SHIFT + NODES_SHIFT + \
 			 MEM_CGROUP_ID_SHIFT)
+#define EVICTION_SHIFT_ANON	(EVICTION_SHIFT + SWAP_COUNT_SHIFT)
 #define EVICTION_MASK	(~0UL >> EVICTION_SHIFT)
+#define EVICTION_MASK_ANON	(~0UL >> EVICTION_SHIFT_ANON)
 
 /*
  * Eviction timestamps need to be able to cover the full range of
@@ -194,12 +197,12 @@
  * that case, we have to sacrifice granularity for distance, and group
  * evictions into coarser buckets by shaving off lower timestamp bits.
  */
-static unsigned int bucket_order __read_mostly;
+static unsigned int bucket_order[ANON_AND_FILE] __read_mostly;
 
 static void *pack_shadow(int memcgid, pg_data_t *pgdat, unsigned long eviction,
-			 bool workingset)
+			 bool workingset, bool file)
 {
-	eviction &= EVICTION_MASK;
+	eviction &= file ? EVICTION_MASK : EVICTION_MASK_ANON;
 	eviction = (eviction << MEM_CGROUP_ID_SHIFT) | memcgid;
 	eviction = (eviction << NODES_SHIFT) | pgdat->node_id;
 	eviction = (eviction << WORKINGSET_SHIFT) | workingset;
@@ -244,7 +247,8 @@ static void *lru_gen_eviction(struct folio *folio)
 	struct mem_cgroup *memcg = folio_memcg(folio);
 	struct pglist_data *pgdat = folio_pgdat(folio);
 
-	BUILD_BUG_ON(LRU_GEN_WIDTH + LRU_REFS_WIDTH > BITS_PER_LONG - EVICTION_SHIFT);
+	BUILD_BUG_ON(LRU_GEN_WIDTH + LRU_REFS_WIDTH >
+		     BITS_PER_LONG - max(EVICTION_SHIFT, EVICTION_SHIFT_ANON));
 
 	lruvec = mem_cgroup_lruvec(memcg, pgdat);
 	lrugen = &lruvec->lrugen;
@@ -254,7 +258,7 @@ static void *lru_gen_eviction(struct folio *folio)
 	hist = lru_hist_from_seq(min_seq);
 	atomic_long_add(delta, &lrugen->evicted[hist][type][tier]);
 
-	return pack_shadow(mem_cgroup_private_id(memcg), pgdat, token, workingset);
+	return pack_shadow(mem_cgroup_private_id(memcg), pgdat, token, workingset, type);
 }
 
 /*
@@ -262,7 +266,7 @@ static void *lru_gen_eviction(struct folio *folio)
  * Fills in @lruvec, @token, @workingset with the values unpacked from shadow.
  */
 static bool lru_gen_test_recent(void *shadow, struct lruvec **lruvec,
-				unsigned long *token, bool *workingset)
+				unsigned long *token, bool *workingset, bool file)
 {
 	int memcg_id;
 	unsigned long max_seq;
@@ -275,7 +279,7 @@ static bool lru_gen_test_recent(void *shadow, struct lruvec **lruvec,
 	*lruvec = mem_cgroup_lruvec(memcg, pgdat);
 
 	max_seq = READ_ONCE((*lruvec)->lrugen.max_seq);
-	max_seq &= EVICTION_MASK >> LRU_REFS_WIDTH;
+	max_seq &= (file ? EVICTION_MASK : EVICTION_MASK_ANON) >> LRU_REFS_WIDTH;
 
 	return abs_diff(max_seq, *token >> LRU_REFS_WIDTH) < MAX_NR_GENS;
 }
@@ -293,7 +297,7 @@ static void lru_gen_refault(struct folio *folio, void *shadow)
 
 	rcu_read_lock();
 
-	recent = lru_gen_test_recent(shadow, &lruvec, &token, &workingset);
+	recent = lru_gen_test_recent(shadow, &lruvec, &token, &workingset, type);
 	if (lruvec != folio_lruvec(folio))
 		goto unlock;
 
@@ -331,7 +335,7 @@ static void *lru_gen_eviction(struct folio *folio)
 }
 
 static bool lru_gen_test_recent(void *shadow, struct lruvec **lruvec,
-				unsigned long *token, bool *workingset)
+				unsigned long *token, bool *workingset, bool file)
 {
 	return false;
 }
@@ -381,6 +385,7 @@ void workingset_age_nonresident(struct lruvec *lruvec, unsigned long nr_pages)
 void *workingset_eviction(struct folio *folio, struct mem_cgroup *target_memcg)
 {
 	struct pglist_data *pgdat = folio_pgdat(folio);
+	int file = folio_is_file_lru(folio);
 	unsigned long eviction;
 	struct lruvec *lruvec;
 	int memcgid;
@@ -397,10 +402,10 @@ void *workingset_eviction(struct folio *folio, struct mem_cgroup *target_memcg)
 	/* XXX: target_memcg can be NULL, go through lruvec */
 	memcgid = mem_cgroup_private_id(lruvec_memcg(lruvec));
 	eviction = atomic_long_read(&lruvec->nonresident_age);
-	eviction >>= bucket_order;
+	eviction >>= bucket_order[file];
 	workingset_age_nonresident(lruvec, folio_nr_pages(folio));
 	return pack_shadow(memcgid, pgdat, eviction,
-				folio_test_workingset(folio));
+			   folio_test_workingset(folio), file);
 }
 
 /**
@@ -431,14 +436,15 @@ bool workingset_test_recent(void *shadow, bool file, bool *workingset,
 		bool recent;
 
 		rcu_read_lock();
-		recent = lru_gen_test_recent(shadow, &eviction_lruvec, &eviction, workingset);
+		recent = lru_gen_test_recent(shadow, &eviction_lruvec, &eviction,
+					     workingset, file);
 		rcu_read_unlock();
 		return recent;
 	}
 
 	rcu_read_lock();
 	unpack_shadow(shadow, &memcgid, &pgdat, &eviction, workingset);
-	eviction <<= bucket_order;
+	eviction <<= bucket_order[file];
 
 	/*
 	 * Look up the memcg associated with the stored ID. It might
@@ -495,7 +501,8 @@ bool workingset_test_recent(void *shadow, bool file, bool *workingset,
 	 * longest time, so the occasional inappropriate activation
 	 * leading to pressure on the active list is not a problem.
 	 */
-	refault_distance = (refault - eviction) & EVICTION_MASK;
+	refault_distance = ((refault - eviction) &
+			    (file ? EVICTION_MASK : EVICTION_MASK_ANON));
 
 	/*
 	 * Compare the distance to the existing workingset size. We
@@ -780,8 +787,8 @@ static struct lock_class_key shadow_nodes_key;
 
 static int __init workingset_init(void)
 {
+	unsigned int timestamp_bits, timestamp_bits_anon;
 	struct shrinker *workingset_shadow_shrinker;
-	unsigned int timestamp_bits;
 	unsigned int max_order;
 	int ret = -ENOMEM;
 
@@ -794,11 +801,15 @@ static int __init workingset_init(void)
 	 * double the initial memory by using totalram_pages as-is.
 	 */
 	timestamp_bits = BITS_PER_LONG - EVICTION_SHIFT;
+	timestamp_bits_anon = BITS_PER_LONG - EVICTION_SHIFT_ANON;
 	max_order = fls_long(totalram_pages() - 1);
-	if (max_order > timestamp_bits)
-		bucket_order = max_order - timestamp_bits;
-	pr_info("workingset: timestamp_bits=%d max_order=%d bucket_order=%u\n",
-	       timestamp_bits, max_order, bucket_order);
+	if (max_order > (BITS_PER_LONG - EVICTION_SHIFT))
+		bucket_order[WORKINGSET_FILE] = max_order - timestamp_bits;
+	if (max_order > timestamp_bits_anon)
+		bucket_order[WORKINGSET_ANON] = max_order - timestamp_bits_anon;
+	pr_info("workingset: timestamp_bits=%d (anon: %d) max_order=%d bucket_order=%u (anon: %d)\n",
+		timestamp_bits, timestamp_bits_anon, max_order,
+		bucket_order[WORKINGSET_FILE], bucket_order[WORKINGSET_ANON]);
 
 	workingset_shadow_shrinker = shrinker_alloc(SHRINKER_NUMA_AWARE |
 						    SHRINKER_MEMCG_AWARE,

-- 
2.52.0


