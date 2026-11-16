Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5A75A606A31C
	for <linux-mm@archiver.kernel.org>; Mon, 16 Nov 2026 08:14:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ionos.com header.i=@ionos.com header.a=rsa-sha256 header.s=google header.b=SKGZqHu7
Received: by kanga.kvack.org (Postfix)
	id 47EEF6B05B4; Mon, 16 Nov 2026 03:14:21 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 459D26B05B5; Mon, 16 Nov 2026 03:14:21 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 345516B05B6; Mon, 16 Nov 2026 03:14:21 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id F2B3E6B05B4
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 03:14:20 -0500 (EST)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 83168408F3
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 08:14:20 +0000 (UTC)
X-FDA: 85440269880.12.E58FDB9
Received: from mail-wr1-f51.google.com (mail-wr1-f51.google.com [209.85.221.51])
	by imf12.hostedemail.com (Postfix) with ESMTP id 93DF340005
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 08:14:18 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=ionos.com header.s=google header.b=SKGZqHu7;
	dmarc=pass (policy=reject) header.from=ionos.com;
	spf=pass (imf12.hostedemail.com: domain of max.kellermann@ionos.com designates 209.85.221.51 as permitted sender) smtp.mailfrom=max.kellermann@ionos.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794816858;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bGXfKLiq/xapUarMj/h8JL1wFySyJOjdq/BDGf5JeCg=;
	b=8P/aaMGwhesdBGRosGJdLmJ+Gq9rlB5IXLzKwG2Gbsiql/x3XMNjavmkmIzCUT9UPoncUN
	tz2hrv7Bnbo+5+yU1OIH2Tvwwa1HQFqcz6LMDxpfOMIqK4ElEDfAP8BiQ61rUPKK43OMhD
	cjBNY7AzS2WQiy9NqsS9wJWGHf/twLY=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=ionos.com header.s=google header.b=SKGZqHu7;
	dmarc=pass (policy=reject) header.from=ionos.com;
	spf=pass (imf12.hostedemail.com: domain of max.kellermann@ionos.com designates 209.85.221.51 as permitted sender) smtp.mailfrom=max.kellermann@ionos.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794816858;
	b=cGJtBc3U1z/ovCd4cBjdfR6CwGRLZNAO44IzbkJr/9t5/7fH/xb2cl/tew7+I+TKFlauvK
	aC7td9G9umvplc6W9E5B0RzUaP72+SJgIiepLNBSHr2YF5W575kJJijSXF77fQOKTUCqVV
	xPRCGYls3mew2m87Jn+33nA8kfl6dyo=
Received: by mail-wr1-f51.google.com with SMTP id ffacd0b85a97d-4918c2d727fso1661878f8f.3
        for <linux-mm@kvack.org>; Mon, 16 Nov 2026 00:14:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google; t=1794816857; x=1795421657; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=bGXfKLiq/xapUarMj/h8JL1wFySyJOjdq/BDGf5JeCg=;
        b=SKGZqHu7uD4EANzJnYwhH1ukL/0gbXcTTnb7pa/XGswGVqJpqH2aDHeKGcdoxw60fl
         DP4TNiljkcDP6tM3CiyyXcdCFoKClBqxGgBQDQgRFU9lvH4Mon7pHbTtSo4aNBNAMPom
         xHEDErds1k2yKuHgSCVtXcry2WN/wfHH640kTkG/1UQXJG8pyg3fq8pFeIFAfQ+Xa5JC
         vWRlfRgih3Ucp4HoZHitcQ8BsovFLosChT21k+q3QGaWH92BxQJCDpov2MJ73O8oE8JX
         j4+lzpBhmc5HHLOXHlOfIglkPiApKKXwDNIPqhdFiXR91nWmAdM9Zx9E/cSe40hHaw5U
         bPmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794816857; x=1795421657;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=bGXfKLiq/xapUarMj/h8JL1wFySyJOjdq/BDGf5JeCg=;
        b=O6TwLFJ936ztxLCXlqfyvnTSs9+WAMkhAcoP3u0Ixorcb7/teT5kiA5XUxBa3I+Vmy
         d4EwMTyqiFOLZ3A0p0/4Hou8D8xbTR8rBX5jfphMUKM8UVeGcad1dzycT3H4LBMmSvxj
         B/8d32e3usUJdDmyqEm0Q0GGGCYTYpZurPb1vGDkA/227dU5FpKoRPqbY5TjUCzUPqkn
         9muZFlnDPxr+T2xi/yyK+GWVIGjKrhJsnraw0KoCbu6wCuHDX6JEB+/eBcs9K/l061ea
         ft10QPdHv0fzekA42XfnepZvgHJAfYJuhwjzvpTiMelE7E9XiOMKcYUhy5xmBu0cF+Om
         XDtw==
X-Forwarded-Encrypted: i=1; AL+hErFZ27GGJwSLbC3g/0F9Xn2V4wVM0BPnBdXxgs+ZBeMUN4tPyghBSlxcFpWAo5mYFYxoE5GQ+D5FBQ==@kvack.org
X-Gm-Message-State: APuU4Z/hdupTZYUcRdN9Ypas10rTlgJGWoMM9HdLYzUuzCRLC0g/KhNs
	T8M7seHAVIVSdFpH9ipMWFAOGrx1Bm4Zu90wssUeZqPRJDrJZzQTZbGlxVA7uLQPx1E=
X-Gm-Gg: AZFdTZfkQfl5Y8k0nXY2dp3n+pN7U2p/b0ELqAKncxad+8u3dM+z86W2Ls2X7DAqNv4
	D7QsrIsh8tr0IJuIhmmcKAe2CtY+xM8h/RQ9K1Xpa6ID8CGAH+IQNC4gZhXKuhG7A2Z5C+MIswK
	ncGN574VMOcu0yzsHBO7kzsGoikXGk07JGQsgmYusd9yUFOo93CvNfEkgrW4CqsX3B2vYiwI2qo
	8m2K0m583w5rGYJcXnxSm9KsgesMu+GYtSf46mhnKn+p1pVOlNel9Z1JpkFR2LKtoqFdirkUjeS
	kcy/HpB61dUzHcgeVvKdvp/kn6WhDwAjWiv3s5V7MDG3JwKucvs1LUBhDB9FxDQ0BBnkCMG+hyR
	qFrtarOQfCi4IXudJRUIL4ru6cwQVwK63v14zCO8gFfeC57Vh0j+1C5V/JANRIsYG21JJzloYDR
	AdMqnhJ1ewnX2yocGdFsDaAerIsJ8HLlUqUvUp8dkc8BrhNX0IY2O1xq5lmFf25phZZ649FvdDw
	nXVeUTS2/ObSCqi5yNhfbdqxpGF33njtdmAw3mVrytVMkKeWa3C8LWy2GcHxA9ZLrdNWuZglOT8
	reRHrIrWZoQPYOiEbIIhPAhTK17gYooQ39arl0miFsqbqDEPgIZQFyazQmA/1EgPY3w069xCREz
	esPZq5Hi6d/jhkepRPiv6CBaUJanzZ5GJBMWkMDfipVtFa1rdcZw=
X-Received: by 2002:a5d:5f56:0:b0:48d:f36e:fbcb with SMTP id ffacd0b85a97d-49c70ed9069mr24699139f8f.14.1794816857186;
        Mon, 16 Nov 2026 00:14:17 -0800 (PST)
Received: from raven.intern.cm-ag (p200300dc6f4cbe00023064fffe740809.dip0.t-ipconnect.de. [2003:dc:6f4c:be00:230:64ff:fe74:809])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-49c5f1c1797sm22902289f8f.11.2026.11.16.00.14.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Nov 2026 00:14:16 -0800 (PST)
From: Max Kellermann <max.kellermann@ionos.com>
To: akpm@linux-foundation.org,
	kasong@tencent.com,
	qi.zheng@linux.dev,
	shakeel.butt@linux.dev,
	baohua@kernel.org,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	baoquan.he@linux.dev,
	baolin.wang@linux.alibaba.com,
	david@kernel.org,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	hannes@cmpxchg.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	rcu@vger.kernel.org
Cc: Max Kellermann <max.kellermann@ionos.com>
Subject: [PATCH v3 3/5] mm/mglru: cache the last memcg node, make tail insertion constant time
Date: Mon, 16 Nov 2026 09:14:01 +0100
Message-ID: <20261116081403.216452-4-max.kellermann@ionos.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261116081403.216452-1-max.kellermann@ionos.com>
References: <20261116081403.216452-1-max.kellermann@ionos.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 93DF340005
X-Stat-Signature: k9uhwhn35bdqn4h43hs44c79ekkyee13
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794816858-524316
X-HE-Meta: U2FsdGVkX1/D2RumwoE4l6qYBasvLVJj15mTpLWLLs2Z83FoXyEIcoN5esguf9K4yTQCaYXoSRs46v+rRMYHs7vBhycKVcjjuSXeHDyjEaAZGtgdT78bfc5cKDFOaoaYYpOU1uJspyIpk4XYaovUsfiBMqcNfk4m4Dcr5jhsEfCRjHXbZfKAIEtvEzr/2PutfCDExOwOF6BbwNEs0H2ajK8IQZSExQzJRP6QqW2nLPcEH0IDOLvylmlFPxOPoORrX7KjGg4YjhJGY2cgL6p6UE+ljFq6UuaOq3FLoOD85uLhaWbj9WiLCroxHOjCEL2HMw9ltTBxxe2sM17VEqhBu6DuNGp7AEjd/Dxp64cRBWwsMCZEDe55bdTWuwpXuHAKLgAW7e8Hl/wwKlc47PmN8g23Jo/A65XJbj1m9YqscFKARjVO1ZhENs18FypSyR3j62TXVCstPVPWnYQB4v08OrNa5X1u3DqcrygTkz7KLBroIDyBCqnuwf4yJ1ID0cGYbO93q2etNCWEu4hw5rgeVMZf3p6/mUH4/4G/To3YEwzBZF4Fzgvnc/7Pr3qRi+l8q5FmPC3u9OwHTU1CicVxReyv1DzCQdDrnQWpbmqHiUB7Qv29udp/mWhOdhoIN2AimwdDd6tOxEtoFfIm3xpKM3ZxkUNjFwb/q1Bk1bsfhsFnghKH64gF4M+67LpAk3KgDqrcJ67y7JiHmv3bAfB/upR8D086XvbvoB3dMxp0jGULiEAwxUWWNXfWmckwAS8GyYQOs8tfJeupWRiU3JnVd/hqUcQo1wtRjVKhyhIWpP2z1f4I278FKi4B22pUlpl3zL/GjGZ3Kf5bWsbsGHx6ZtdP4x/xzxL+AULH4xGgCvkR3BAbDS6ytCCiifILN2VjfxYMf4fLUmpOlfqgWNg6K1+AnW+hVBTg1RRhqJvYsW3gbJaYcHbVdNx7ciuAixlvM05+23vvZ4gc5OR+Gqz
 q76AB4Os
 8IN4RIe1LUQDIAWHiH6smxr4Qzf81sLINtwkyFEAQVKKBNfj2sGSgF0SYHoDAxG/UenPnG/Srd9GExW8hHqXVaJDzGol4Fbc4z100izm12UQs8DrE+tv7iY5t2DReuesyYnOuHNMqtCCzPVjBDvSi2Rka7SoBb6Ox6PYsqRkn+nyQHUBaZmLp/FkDhQuPFHFOKQoIKYE7fx9n2WBkzYYUCy+0xXxO9sw4IVzGRkLul8wt3fPJxg/FKbQnFIDahL1PjH16cUhfWIDAyHh4P56HAoARdoM/7xy9e4FeddTEOr1QPovG4UfkH6FIjr5LUWx8liWogOjrAX0ehmY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Rotating or onlining a memcg currently uses hlist_nulls_add_tail_rcu()
which walks the destination bin to find its tail while holding
`memcg_lru.lock` with interrupts disabled.  With thousands of cgroups,
this takes a long time and causes severe lock contention.

Cache a pointer to each bin's last node, making tail insertion O(1).
This requires remembering the bin number (but the new struct field
occupies a hole, so it does not grow).

In a micro benchmark that creates 1500 cgroups and repeatedly writes
`1024M swappiness=0` to `memory.reclaim` in 8 threads, the request
rate increases by a factor of 9.5 and the average duration of each
write request is reduced by 89%.

All writes return EAGAIN in both runs; the benchmark measures the cost
of reclaim attempts that cannot meet their requested target, not
reclaimed throughput.

Fixes: e4dde56cd208 ("mm: multi-gen LRU: per-node lru_gen_folio lists")
Signed-off-by: Max Kellermann <max.kellermann@ionos.com>
---
 include/linux/mmzone.h |  4 ++++
 mm/vmscan.c            | 24 ++++++++++++++++++++++--
 2 files changed, 26 insertions(+), 2 deletions(-)

diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index c161d563ce8f..8382fc86cf0d 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -570,6 +570,8 @@ struct lru_gen_folio {
 	u8 gen;
 	/* the list segment this lru_gen_folio belongs to */
 	u8 seg;
+	/* the memcg bin, protected by memcg_lru.lock */
+	u8 bin;
 	/* per-node lru_gen_folio list for global reclaim */
 	struct hlist_nulls_node list;
 };
@@ -661,6 +663,8 @@ struct lru_gen_memcg {
 	unsigned long nr_memcgs[MEMCG_NR_GENS];
 	/* per-node lru_gen_folio list for global reclaim */
 	struct hlist_nulls_head	fifo[MEMCG_NR_GENS][MEMCG_NR_BINS];
+	/* last entry in each bin, or NULL if empty */
+	struct hlist_nulls_node *tail[MEMCG_NR_GENS][MEMCG_NR_BINS];
 	/* protects the above */
 	spinlock_t lock;
 };
diff --git a/mm/vmscan.c b/mm/vmscan.c
index 49ef29a86553..7cfaeca9a605 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -4434,18 +4434,36 @@ static void lru_gen_add_memcg(struct lru_gen_memcg *memcg_lru,
 			      int gen, int bin)
 {
 	struct hlist_nulls_head *head = &memcg_lru->fifo[gen][bin];
+	struct hlist_nulls_node *last = memcg_lru->tail[gen][bin];
 
 	lockdep_assert_held(&memcg_lru->lock);
 
-	hlist_nulls_add_tail_rcu(&lrugen->list, head);
+	lrugen->bin = bin;
+
+	if (!last)
+		hlist_nulls_add_head_rcu(&lrugen->list, head);
+	else
+		hlist_nulls_add_behind_last_rcu(&lrugen->list, last);
+
+	memcg_lru->tail[gen][bin] = &lrugen->list;
 }
 
 static void lru_gen_del_memcg(struct lru_gen_memcg *memcg_lru,
 			      struct lru_gen_folio *lrugen,
 			      int gen)
 {
+	const int bin = lrugen->bin;
+	struct hlist_nulls_head *head = &memcg_lru->fifo[gen][bin];
+
 	lockdep_assert_held(&memcg_lru->lock);
 
+	/* pprev points to head->first for the only entry, otherwise prev->next. */
+	if (memcg_lru->tail[gen][bin] == &lrugen->list)
+		memcg_lru->tail[gen][bin] = lrugen->list.pprev == &head->first
+			? NULL
+			: container_of(lrugen->list.pprev, struct hlist_nulls_node, next);
+
+	/* Keep next intact for readers that still hold this entry. */
 	hlist_nulls_del_init_rcu(&lrugen->list);
 }
 
@@ -6106,8 +6124,10 @@ void lru_gen_init_pgdat(struct pglist_data *pgdat)
 	spin_lock_init(&pgdat->memcg_lru.lock);
 
 	for (i = 0; i < MEMCG_NR_GENS; i++) {
-		for (j = 0; j < MEMCG_NR_BINS; j++)
+		for (j = 0; j < MEMCG_NR_BINS; j++) {
 			INIT_HLIST_NULLS_HEAD(&pgdat->memcg_lru.fifo[i][j], i);
+			pgdat->memcg_lru.tail[i][j] = NULL;
+		}
 	}
 }
 
-- 
2.53.0


