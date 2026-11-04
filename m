Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B0BA2606A334
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 13:02:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=UjMCkRY3
Received: by kanga.kvack.org (Postfix)
	id C2E0C6B05BE; Wed,  4 Nov 2026 08:02:21 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BDF4C6B05BF; Wed,  4 Nov 2026 08:02:21 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AF4E46B05C0; Wed,  4 Nov 2026 08:02:21 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7BB266B05BE
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 08:02:21 -0500 (EST)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 0FC391406F0
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 13:02:21 +0000 (UTC)
X-FDA: 85397450082.29.5B7D868
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf03.hostedemail.com (Postfix) with ESMTP id 1B64620018
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 13:02:18 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UjMCkRY3;
	spf=pass (imf03.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793797339;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MLMUyhdzk/noOyENVlDlfK94lvgbxXguMgh8R60gx84=;
	b=uRCqP6vA+NRBg4altoRk89LmUOX+plfCby/e3N+HO7PfhiGoedHi1QdIHATG7E7HXt3GJj
	mdxg88UYQT/4bT8K71CBbec68Fk7yBW77mB+ehU/Y0DRJ+qsd9nECZbaCTQPuaBi44P4kH
	tMbyZYwDjhL0ltfuBwWRs2qgZcmt5x8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793797339;
	b=WLrDCj4AkkkqSdo2Rc1jcv0BvfKY47ZXScfZFL5FlmMzediKibPe7ajDz7W3RSvZO1Gm+f
	atiz67KDx2fHeecq0ql7vCR0fsM3Avv4gdFVWrl0E1WBR8WAFZE2sKEfieRXtmX5o9DNGK
	D0EBElC/HhUCLNhkXWbBIkrHC+98l5E=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UjMCkRY3;
	spf=pass (imf03.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 9D8E360A97;
	Wed,  4 Nov 2026 13:02:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 607C81F00A17;
	Wed,  4 Nov 2026 13:02:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793797338;
	bh=MLMUyhdzk/noOyENVlDlfK94lvgbxXguMgh8R60gx84=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UjMCkRY3e5y95n28AJKow5Anskxk7woj5bQXQq/rwl19FvzF+XjRf7RaYOtp09tJ5
	 J/7BsP1Qwq7hHv3sMJjx0O0kwWrbjxTFGp25e7YrlBL4uzca0Yqeu2dwETYlOKp8dZ
	 Y/dPGJdx7aVrPJwSK/nKRuFD8OOliPkWcvfPHNZAK7CMVOnHwf71/1kN3zZv0vmwVY
	 jVBsUrjlAeLD42MOX6iHNaRcexvf3rX/tUpUtUZpOXJH+Dtzwb3HzFX3+vo+ZrcOVY
	 +4kQ4K6XWrQOBzNc3XSCc7qqd4hCGTbyCU84DbejtlKxjqFdt+lPZNc5XK7RKXXpDg
	 gkVcBSNJ7ufGg==
Received: from phl-compute-05.internal (phl-compute-05.internal [10.202.2.45])
	by mailfauth.ams.internal (Postfix) with ESMTP id 31E881980052;
	Wed,  4 Nov 2026 08:02:11 -0500 (EST)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-05.internal (MEProxy); Wed, 04 Nov 2026 08:02:14 -0500
X-ME-Sender: <xms:0izraupDhaEQGFDMq6Iy4t0MnGYC0Rb6eTg4xD05b7PVKLoT9I4nRQ>
    <xme:0izrah46V7-Y8BNqivCCxwaUu5dO7bo5La9Q0hjpFwtKxLzudWEg9uaDxv755YzxU
    uScc1pPKcbtXdFQHa_ljNzputNMDMMLOhsbRu619SVgB6z89PHASYQ>
X-ME-Received: <xmr:0izral0CT5KMzV2Qk1bzOvpPV53W-6s_Nq-xJMPUsnVZsC2VDYpkd6GjYPU>
X-ME-Proxy-Cause: dmFkZTGhPc1Yg5t9Q8eRQaKCLT0heVoXQqf6h4uqMuRtXQYzheOI1jp47nBw26mcWoxz9A
    DH10HnpPYob7RxaCTf32YkHXSpJmh1hLC1IxxzXB90aJAI2wMnFT+nxhjDMKjWZ9Ablulj
    X6EGhbUdQWvr3vCsmIbyKlTdtYm8QJi2H9b42DzXiIRq27TGzwIAKeq7xgftm17WrW++J+
    RK/ZhBFKi/01LbyIuttpTNhw8T5nzUYT3/gbSIkELTYoQfWYa9TU1xDsUR8Sja7r663Vhq
    dT9Vb6Q8iqTkFCbamg7ObiOCckNJsrzr7UPmHz2jvO2iFJ92ew01ZxP0mcoMzU2JutwOVF
    8u+V40EsbW3Xm19sfo4Oy0BtGYrJ+rDGsmaV/Kus0W8Htiy2bsPuViVsmyIYkLeevGJAtH
    h0iz39M/T+K/qBGGGeXvMu4rBFjQRHTjU1ZK8f1mUPMV1VO2wj+TLFjnw26BYULH/8FfTe
    1w3gQ/UarqXmQmwUTIpb/JUxos5OXhxdIXVlnKTj1rWyePytEvna8Lsl0PJKZXm1hP9Ova
    v39yitZDVVeGHjQ4cJhoaac4oo9Ja1doxwuIxCCh6Xda7rpbXU5w1HAqkhHOo9bKl43cTs
    gLwIs1gHymXAW7aAb2PgnRy+eqAteBWCDRbNyKzAdA/aG+hdRslAIuPTncuA
X-ME-Proxy: <xmx:0izratmrRt0eSJTMfEPusZmPdI5uXn88JaGkJv6MTbsMrBh_xQFfLQ>
    <xmx:0izrauivoASPu0vf94NsePIXppPs14EHLUQcQpobahRMu1POT6Ppdw>
    <xmx:0izrak1orvV1Vrf01IjcsY15Rs-MF9hR_Uq5WSU-1ZgnjMsjTnla9A>
    <xmx:0izrarbQc4GWVyu_ITVwoxLjhwkfGFgwQGkrjCmdowAZS8y4AklCdQ>
    <xmx:0izrahmndiq1ff-toqKwyeg82b3eR7tQ05BOIfOJ8S4eAjzj7InKQcyu>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 4 Nov 2026 08:02:10 -0500 (EST)
From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Matthew Wilcox <willy@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Jan Kara <jack@suse.cz>,
	Hugh Dickins <hughd@google.com>,
	Christian Brauner <brauner@kernel.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Harry Yoo <harry@kernel.org>
Cc: "Kiryl Shutsemau (Meta)" <kas@kernel.org>,
	Miklos Szeredi <miklos@szeredi.hu>,
	Miaohe Lin <linmiaohe@huawei.com>,
	Naoya Horiguchi <nao.horiguchi@gmail.com>,
	Oscar Salvador <osalvador@suse.de>,
	"Liam R. Howlett" <liam@infradead.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <brendan.jackman@linux.dev>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Nico Pache <nico.pache@linux.dev>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	Usama Arif <usama.arif@linux.dev>,
	Kairui Song <kasong@tencent.com>,
	Qi Zheng <qi.zheng@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>,
	Wei Xu <weixugc@google.com>,
	Baoquan He <baoquan.he@linux.dev>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Pedro Falcato <pfalcato@suse.de>,
	Luis Chamberlain <mcgrof@kernel.org>,
	Ilya Gladyshev <ilya.gladyshev@linux.dev>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	fuse-devel@lists.linux.dev,
	kernel-team@meta.com
Subject: [RFC PATCH v2 08/18] mm/compaction: free the migrated folios that wait for a grace period
Date: Wed,  4 Nov 2026 13:01:04 +0000
Message-ID: <20261104130118.2507513-9-kas@kernel.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20261104130118.2507513-1-kas@kernel.org>
References: <20261104130118.2507513-1-kas@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 1B64620018
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: y9gxo3k8qqjgf4tdmi5csbpeteiobgq8
X-Rspam-User: 
X-HE-Tag: 1793797338-560123
X-HE-Meta: U2FsdGVkX1+J39fzZjDyECZ4WEtiFD7pIEe4ivrVb4wgFdsxVI/BLM6xIy8iGRmapI4AM6iQTeNch8EJoj44s0b+c4a0YoI9/FDGpCpSgbZGdUsjP3YGzS5DORY5879B94MaowAmszGMkI1UbCfuBf69mLuplbe9tdczX1H/w5CJIs9SgiyONoftqclB96bzDcijJXbsGYCJeKWEUebKfoLL1j45dLlZLZEJte1FqLgsbEhci9SNff4luIzrp2YQtuaTZJPI//+QLtV0eVdRDs9RkQGM+UaVUiAJ/CrD2+iNjL5PDV0/mq+NnE1fFbBlulrdSrQzKTdo3d2s7RFeHpIOf9XXo/vXeW+3GKGWsEhbdv3XLAZE3dgl59wPkoMwK8Vin2EDTaNvWOpbzo/As+iZN36pVupXc3PnvHNZo0YcM4ks1iuImlhQoRLjfg+Mi8+K+cTax+vovW4m3emniYjP9beODBZ0NGHXT8gUudy27q9G2He8YXkntWa1q0ZgXlgSrR4I8w0OIfosU6NPSKkw0AhF+iOAU0egd5Vxz5RC9RcL58feJvQ/hfQnfsAOUbFsl/IUYSR8iM14EPhMD5UUUOu7NIcnzCPQRBE0YC2CPFOAf1STdlZ/HxCjgpNOHwA3zmHXlil47BgUcsG04JC7zn6A0/YrqsT6Knt3Y+DN0EW9o+BhIcONlzZw5MUsX/mZKkgPQ1fuV9aNUaG7M0Vy1SgW576XT3Ir1AXf6Oz1ihSKgbSyHyP9nxtHUloPF9g9TWiMTqwlVbb8XVLvu/rIjMXsdB5EI+y0Eq9RF2IP6W89Y4zNU6y2jiIE1OusNfzByFf+CtGLiri7JR0IMVzD/aQIkFqpe/OyG1UDUAPd2yytxaba3wjEKWvy0s273aoNJQOQ+UyRy/oWZQ2wjIBRA3yTlVYstTlJwa+7URHIPTmiML1I/nFOfBhB/HsoGh7hilVLwSsMVn71SN5
 t6aHtBXU
 kqxMu6NkhTjfgHFuAUrA6RrIDZxmRSHbefq49z7pf7gbrfbIq4j9VnZHPO2f/Qjyg7Pw34jt92Ap2O+dTEhtITYDicmrquRMKtNbSraWbwqpmnDGu56DwrIGkO1nRS+nPohfOYL9WWD98SuEQyha6L+dejoEGxdwJzexedpQ9oQtThdzApFZq6TBjJPkZ8EwzpYK8ycmTBqwDgce/QYHUZnUlAIJQrNgHEMR+xeGRulRnI45nkoTG8WZIpXbXdosabDcPPfb+W08lyvrHlxSCyBclo8km/33U7ObxAkjSEyYSOYNWhM35RygZJLCRwLlB5ix9Xa81akuFx2rah+J43Nr1hu5sT4A2QMSmKhiVWcLn+I8Ko0t/2ZEMDw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

A block that compaction has migrated every folio out of becomes free
once those folios are back in the buddy lists.  A migrated folio that
had PG_rcu_free comes back only after a grace period, so compaction
finds the block still in use, migrates more blocks than it needs and
fails more often.  defrag_mode relies on compaction making whole free
blocks, and there it shows up as allocation stalls.

When compaction moves past a block it migrated from and the zone has
pages waiting, free them before it drains the per-cpu lists and checks
whether it is done.  The drain costs an expedited grace period, so
async compaction, which must not block, skips it.

Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
---
 mm/compaction.c | 8 ++++++++
 mm/page_alloc.c | 2 +-
 mm/page_alloc.h | 1 +
 3 files changed, 10 insertions(+), 1 deletion(-)

diff --git a/mm/compaction.c b/mm/compaction.c
index a049415512c6..2acb87a3446d 100644
--- a/mm/compaction.c
+++ b/mm/compaction.c
@@ -2760,6 +2760,14 @@ compact_zone(struct compact_control *cc, struct capture_control *capc)
 				block_start_pfn(cc->migrate_pfn, cc->order);
 
 			if (last_migrated_pfn < current_block_start) {
+				/*
+				 * Folios migrated away from lockless readers
+				 * are freed after a grace period.  Async
+				 * compaction does not wait for it.
+				 */
+				if (cc->mode != MIGRATE_ASYNC &&
+				    zone_rcu_free_waiting(cc->zone))
+					rcu_free_drain();
 				lru_add_drain_cpu_zone(cc->zone);
 				/* No more flushing until we migrate again */
 				last_migrated_pfn = 0;
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index eea287ab2a01..afd4343ad572 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -1457,7 +1457,7 @@ static void rcu_free_defer(struct folio *folio)
  * callers want to allocate the pages next.  A concurrent drain holds the
  * lock until it has freed what it took.
  */
-static void rcu_free_drain(void)
+void rcu_free_drain(void)
 {
 	static DEFINE_MUTEX(lock);
 	LIST_HEAD(list);
diff --git a/mm/page_alloc.h b/mm/page_alloc.h
index 764e3f43b3b9..4f5f06adbfdc 100644
--- a/mm/page_alloc.h
+++ b/mm/page_alloc.h
@@ -235,6 +235,7 @@ struct page *__alloc_frozen_pages_noprof(gfp_t gfp, unsigned int order, int nid,
 	alloc_hooks(__alloc_frozen_pages_noprof(__VA_ARGS__))
 void free_frozen_pages(struct page *page, unsigned int order);
 void free_unref_folios(struct folio_batch *fbatch);
+void rcu_free_drain(void);
 void rcu_free_sync(void);
 
 /* Whether @zone has pages waiting for a grace period */
-- 
2.54.0


