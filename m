Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C7A46606A31E
	for <linux-mm@archiver.kernel.org>; Mon, 23 Nov 2026 13:52:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ionos.com header.i=@ionos.com header.a=rsa-sha256 header.s=google header.b=GYtrSJ7j
Received: by kanga.kvack.org (Postfix)
	id C8B796B05C5; Mon, 23 Nov 2026 08:52:11 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C3CF56B05C6; Mon, 23 Nov 2026 08:52:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B505F6B05C7; Mon, 23 Nov 2026 08:52:11 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 8CAEF6B05C5
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 08:52:11 -0500 (EST)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 1D0C81208B1
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 13:52:11 +0000 (UTC)
X-FDA: 85466522862.29.74BD473
Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	by imf28.hostedemail.com (Postfix) with ESMTP id 05F4FC000B
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 13:52:08 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=ionos.com header.s=google header.b=GYtrSJ7j;
	dmarc=pass (policy=reject) header.from=ionos.com;
	spf=pass (imf28.hostedemail.com: domain of max.kellermann@ionos.com designates 209.85.128.46 as permitted sender) smtp.mailfrom=max.kellermann@ionos.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795441929;
	b=ds4vsXMXbkGS024RccJdd98P3IbEIuGt4uh7xhncQ3mEO7zr0bofWf96WKNbVMTBOF/IIu
	vD4p/CqN/nHkeB0MjZm4+Lel22KTpVxo0VnINPIG2G1czQdWyERbZ6ZiG5/9jKNsI5oB52
	6mhKXmCzRhOOOPUWfDtF137ncdugrSk=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795441929;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YerUGZZjqZVHCBmjQM6BOEpwknjYpbKDzKBkgZmInLA=;
	b=ygCGZ3oQxpK3v6K+24vkpPryAUdTVmafEZVM84Fc4u18GOJlmFk2htJIpiRvDbqRYseMyZ
	+l8zY7IkRrZ/qSJe4HybX6IuisYrdrF6cQ9bb2PiXvCvUkJbmGFmB6GcyUjW9nvsIqSSRB
	TItB8J04Owh7hfvpelfXAiVJp08Aa8I=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=ionos.com header.s=google header.b=GYtrSJ7j;
	dmarc=pass (policy=reject) header.from=ionos.com;
	spf=pass (imf28.hostedemail.com: domain of max.kellermann@ionos.com designates 209.85.128.46 as permitted sender) smtp.mailfrom=max.kellermann@ionos.com
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-4a9a8d6cea8so42441975e9.1
        for <linux-mm@kvack.org>; Mon, 23 Nov 2026 05:52:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google; t=1795441928; x=1796046728; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=YerUGZZjqZVHCBmjQM6BOEpwknjYpbKDzKBkgZmInLA=;
        b=GYtrSJ7jaoWYM1OSUwid8n7J8GjSZ74TL8nyiUvXfw8c7LqnX/uN7whgxPPSVCgvno
         a3LlkN3Gi7Rh2Faw13dDZhNIEjjU5Qx17DpqFS+qonoErpImakV0BkZLhp3ZeUTlp1HM
         HzzPima1gRuUOBhhazE1TcJsvpfr2YMx5YAe82bxMuGlPvAI2VePYj4h4Fi0rQoT0fWG
         sL9XfENyXM3UU8Rre6L5OyzGBgfHJiO8SVYduoqke7MBfzwDOy6rZNzlXklCNLD33OA4
         M5uovf+iiWyKIYUlPYDEw8l7WzGkBUzEmna56D5LHjCvnSrAJ+0ne1zrwaY81VVwQ/BM
         og3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795441928; x=1796046728;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=YerUGZZjqZVHCBmjQM6BOEpwknjYpbKDzKBkgZmInLA=;
        b=rjAtBpgydk5v6zIEFA/kOOcdJ9IoKjA7vIAcakGGkqhcLKStp4w4SgRQG9uPvfaPil
         n4D6W4wYhMdxin1LDrm+jixlFxRUDZP2EPEUnWXm/i3v53PTdmWJfVIycJvOTaMg8NvU
         1HhfCEMAe5MVd1fA8Kt2J61y7aWwwfXrA2bsg/ynl9OX4n9vWA09SjuMVzFWSGtKiC7l
         q03C4tS62dKTAhupRykeQd/tyBT7azuh38kGggM9aDpkkT+PdYzjGWnFaYiwX/zhosA+
         jfN9793p80yFgS8fPW2Q4H0JPM0VYXWy9BGpR266BpciKS/ZMDBUaEzWC92evRPkd9Jc
         4WAg==
X-Forwarded-Encrypted: i=1; AL+hErF57wh018rkS10DPKcvv7lXFNsL0JX7yDoEOvcVQAl9H1ujTXpFbiSnKM4kNg9FC/CS2yYz0A6yRw==@kvack.org
X-Gm-Message-State: APuU4Z8bCrsinww6btmS63QsugAyvSMhE0zUgx//CfHAO8DpoS/uaOZg
	U3sru3QeQDxpA/uBKf+28SmqbRXdJc8RjCKSEt00mdq/VIL72TcM+fvBTCTnWHV3glw=
X-Gm-Gg: AZFdTZd847QiiSj9HljkUF2mA5Inc3MkLtDvY7cWd+vtwESVfqTFZNplrjnnUUEJnYa
	NAW5nJBmO+AjF6u3J3NBjgrRAGf8cANS/EriKmrnN0sySpoSl4A1/Y0CW2b2gAGceT93pfKVzHi
	OTY2QcGvleQD2t3CFgE00R3FallkV37SlLProYn+WRuu9tjwMmDI9zTviwiqIP558h1zaLPcnHE
	eLqXqqYEVTnPhL5v0A6o9vauxOYVOsySqsnV0ZgcNTflRKMMT/zdnlvgG98Iucfn6qJq2JPw9nC
	6OS3OUmRalTJgQtIO3t98cNBeUnpdnSzTc5Lgm1fc8IvH6XX8aHQOy/IndpIb4BBQCqGgcXHWHz
	Fx8S7OLLfSSDai7J4O44wbPryuXAqegHk+P403dgB7+nfeTlCiNCvVijR7cT08J+tyqMg9vh8rx
	eJb9Ut5uipJe9mF3BwUMQWXSBHVXNjDjlydjibJZDVt8llWf890iGIQ/Vy1o1YGEkHyfPGMKIBI
	qrOeeFDe+tEvfiCOAG8GqXvTJjsdwaUTlZ4ZoEVGsG7txnHyLvEG8bICi7dgMcGmj0Z36IHxUa6
	Pfb96ZHlc93tK9tE7MApakYrQ5QmYK04j40s0WnUvfrtEjax1aZXevkSQmvouDSs/EyxHHLD7yA
	6QcjZFo2lib0Rkc0afm7DeKvRGrZXMQF/kL4fmRGgR/f0D9NWgYc=
X-Received: by 2002:a05:600c:1d09:b0:4bb:66fd:ad68 with SMTP id 5b1f17b1804b1-4bb888160cdmr251315095e9.14.1795441927506;
        Mon, 23 Nov 2026 05:52:07 -0800 (PST)
Received: from raven.intern.cm-ag (p200300dc6f1b7800023064fffe740809.dip0.t-ipconnect.de. [2003:dc:6f1b:7800:230:64ff:fe74:809])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4bb906817ccsm169279215e9.5.2026.11.23.05.52.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Nov 2026 05:52:07 -0800 (PST)
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
Subject: [PATCH v4 3/5] mm/mglru: cache the last memcg node, make tail insertion constant time
Date: Mon, 23 Nov 2026 14:51:58 +0100
Message-ID: <20261123135200.4086519-4-max.kellermann@ionos.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261123135200.4086519-1-max.kellermann@ionos.com>
References: <20261123135200.4086519-1-max.kellermann@ionos.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User:
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 05F4FC000B
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: ezqrdkdz7mkzpmcbrjxnaepn116psepn
X-HE-Tag: 1795441928-963527
X-HE-Meta: U2FsdGVkX1+2KQYq1sAzWc5TMvDql3aPWQ+SFizDAZ7/NSRSRfY80s5IV1xUiomr4aUqV5O3C954M1O0ZjPujGfEAhysq/msoalcSqTCYWxm0xlHlD4mzfJifAdNbOdf3f2z6e+/DtdZFDNJuF2FsUjy45IHHm1jI6xWVmmaj8xbASHqmiHTsRGMDte+5qjCNKNtZwKFGOozgTHFwnSlfydVJTapoizA/8At0AhMgrJGKUKTfXixl/6VLyz+5/SzIii4xhl+4tqBt4yD8s3pFHZju1PsGf3LHCakPL9Z9gfqxJ4gSarWJZ+p88HPYV0iT9WDo28+lHxfJNi/Sem4NMwtKJuADrqF75Pabu0bNoj6vHLtaCo7G/6awvOIsO+ELk/8UnjKj0tAD26feB8kJBzSnTIUzwTgxvPLEuNk8dOteOihBBzHy2Hq6ngPT77EBRJAGp6LZvm7fnzNbPwm3swnLz1piUzpEwXvvJvSrTILLA5QWhCFi7ioilOYGc8HUrTbbIGZI+ovWRMfjSVmxVRzIQowoG4D2+IiZIEa43nNIFv+btC8KKRJ7rq1srgju2S4BX1xdcuhhsmHCpxJV31BmtQ6J1hGYtPRuh0pMVsx0A/ix1g+gqXS/V4QaIQWtbY6DdyzEdRDdh+a2V4M4L4nWcxORyKI/MHcB0oSxdUGp8u9YDYSpw4mtXPPlPKdbb/C5EJG/j5cwMnRPR79RMVKPSHSN2mDdBULM9eNr7RFNiY3pMfPsXhE6uuE7yGqS0lv0Y0Wc2dYXsavuUUMoS/7CZ75uwUW8bZFdhEDpBrdICnINfOgiUQiA+UBHHe5EDOiEeCrrqAuR1EpT8+Tn/mFUesdk5pO5YArnG4FmkUkMpvUPJDlObBo+MPjFn1LAp1FbEYJhoVjTxVrVAjhOnjEY2LR/xxdmzFwWJUGiBVx7WHyir6iFAufw9u0/vaKaaGp/mylT9yd+YHK6Y9
 0zSSFbqN
 StCLrZHJmVeINgMZ+SCTPDnnefRtV3iCHrs9DBTarTBNRQreepQCuspWlQT1ZcpJKNtbQXoAPIS40nK/Q3CFPa+J+iWdbjpGFy2prEQ46Xar9C8WdX1l6ZxeXVtze1MU5Pok9cc6Atm1QuqsjONZ8A/Icdsl8IboLywgiB1zVf+Bs9GMcm0MMrEMe4QZtwZEFXjjO34OEtLehTX9NqC7wK24VpvFgs3vX6UnDAJ+9Bi3b9WiHes3lYWxtbWD9a44NxxZiDCG2wf4rh8sFYaA0F+Ynq4XLIjkhoYwuS8faTACMC3XM6haabGxbPzV5uC3EoRkYTwlC5PfyCEomhUZ5IWNhlusKAf9HNnl7UcENpns/uNKF06nvVAD5Ti9T7H5TgeVjD+ZB6VdG2ZD/v0aI/bHstl6d2VPe67+ZJUlBbEcOJDGW4EKmFyV0lvNQN3HcFfvY1wGwcX1uzjrc2iYWy06dAfPgcdaFkORWi8LhtdLO5F8iN61Zmai/Gf8h6IJnU0wth69DLUSqsKvlJRNnzEkfwIWsMy2uoCbOUms6GIkzuCABFSYhOvrLk0iaknwYGzpTMS/h2v7QSDeZ2ZSa91RJu8M0+nbD1rIL
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
Reviewed-by: Barry Song <baohua@kernel.org>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
---
 include/linux/mmzone.h |  4 ++++
 mm/vmscan.c            | 26 ++++++++++++++++++++++++--
 2 files changed, 28 insertions(+), 2 deletions(-)

diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index 6a2ad0cff795..b2ded8f97eaf 100644
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
index 1d63647e3710..91f31b65f9f6 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -4434,18 +4434,38 @@ static void lru_gen_add_memcg(struct lru_gen_memcg *memcg_lru,
 			      int gen, int bin)
 {
 	struct hlist_nulls_head *head = &memcg_lru->fifo[gen][bin];
+	struct hlist_nulls_node *last = memcg_lru->tail[gen][bin];
 
 	lockdep_assert_held(&memcg_lru->lock);
 
-	hlist_nulls_add_tail_rcu(&lrugen->list, head);
+	VM_WARN_ON_ONCE((!last) != hlist_nulls_empty(head));
+
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
 
@@ -6106,8 +6126,10 @@ void lru_gen_init_pgdat(struct pglist_data *pgdat)
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


