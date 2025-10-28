Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AEDA0CCD1BF
	for <linux-mm@archiver.kernel.org>; Tue, 28 Oct 2025 14:03:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1A2358015B; Tue, 28 Oct 2025 10:03:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 152788013F; Tue, 28 Oct 2025 10:03:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 01A3C8015B; Tue, 28 Oct 2025 10:03:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id DB2708013F
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 10:03:55 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 9E742C02B8
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 14:03:55 +0000 (UTC)
X-FDA: 84047691630.10.29665E5
Received: from out-180.mta0.migadu.com (out-180.mta0.migadu.com [91.218.175.180])
	by imf06.hostedemail.com (Postfix) with ESMTP id CBD1618001A
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 14:03:53 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Mcp43v4U;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf06.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.180 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761660234; a=rsa-sha256;
	cv=none;
	b=jNUp/E0LRCTpdwhw9JLvK+hnJEGx6dbRxeB8+mOG3WL6o0qcuQVopFyXEvTmQCkJk1LIsz
	wQ4z+gKg/WVN0f666/WfJ7hmGQybUZlrKMtzEyPBlg/XMw0g2UEkpiqAtTodsVJpPniEl0
	mmSUc/rE5KrDDoqX8lf2JoUYlhoHNsk=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Mcp43v4U;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf06.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.180 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761660234;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=N6cy0qJU4vZTky6WsO6fPgmyrH0v2+1c03Oi7wqa5+0=;
	b=oLC6LqBc5pSdklt2/1IB6oXfvRwNo3TVSo0E4GN1T6JBJF6DCagiJdwS4DfV5q0B2QEMV1
	u/+q4TDKhQ4FzVU1LkrwdVBt9Bt34cN+Nv3bzgHGgQd8UyPennQJCimWzP0upVEaFzy+Ap
	hI7REch8NGkW0tr9waBnhhsd15g57kA=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1761660232;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=N6cy0qJU4vZTky6WsO6fPgmyrH0v2+1c03Oi7wqa5+0=;
	b=Mcp43v4Uw1DN1te6MLoGfIu4JBZPPNa/YdsIikEd59YRXiDP67BQ+YkTF+91+BLyLuIPFr
	EZQ+DNJ0Tz9/WrVUMTS7op86uCagBE5emzwbk0TROnKZweY3Opo2prHAUcrb+eDsox0mLI
	BN26/J6xOdjx6l2HOhJ2q5avXrQhhH8=
From: Qi Zheng <qi.zheng@linux.dev>
To: hannes@cmpxchg.org,
	hughd@google.com,
	mhocko@suse.com,
	roman.gushchin@linux.dev,
	shakeel.butt@linux.dev,
	muchun.song@linux.dev,
	david@redhat.com,
	lorenzo.stoakes@oracle.com,
	ziy@nvidia.com,
	harry.yoo@oracle.com,
	imran.f.khan@oracle.com,
	kamalesh.babulal@oracle.com,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	akpm@linux-foundation.org
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	cgroups@vger.kernel.org,
	Muchun Song <songmuchun@bytedance.com>,
	Qi Zheng <zhengqi.arch@bytedance.com>
Subject: [PATCH v1 15/26] mm: workingset: prevent memory cgroup release in lru_gen_eviction()
Date: Tue, 28 Oct 2025 21:58:28 +0800
Message-ID: <847c35eb649fde525eecde97fcee3d01708b7b3a.1761658310.git.zhengqi.arch@bytedance.com>
In-Reply-To: <cover.1761658310.git.zhengqi.arch@bytedance.com>
References: <cover.1761658310.git.zhengqi.arch@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: CBD1618001A
X-Stat-Signature: 3sos14y4w3c31tg3cex59jkifdr5b4ua
X-HE-Tag: 1761660233-99411
X-HE-Meta: U2FsdGVkX1/Fc20yT1kxv+uxjl5n5FG3/P6s/oxGHayCtetdxRrmGbnifHhk+ZDrrw+8UNwnkvRTMybMORIRWnTzhvat9/rMrTBXtNF7Fjf92mg06wXyDsYGNh+Zp5sTmzUWTE792p+QCRjqV1PKTrfUqWPOFc5EKeobgm8D1fZXs9QN/qNVLgiYLP00tiUFHsQ4P0Rt146KiXpzIqcDFqKcQtiG7on2YoEUd7q9NkCLNnN3+gXEOcTmi8ouWTqqewBs9hx9gfhNeNhLU3uDKEjRZjDNU+IW3MsUPf4rhr+NlSKyb5oPT8qZH7oJir/Gwqd/EBJZg9Q8J2sAJpJkjcb8zYt+Iy8n+8Cy5/uischpdi0AesDikATEtDHUD5moObgVQMREvMj7O70mQSpzCtkG/giHckoeR2+11/kJ46KlWrCbeRhQuUrj7tdxIfft2rBuJiez4pUnZvUqVtretbwAIAVxcQ3YgJ8nD4fBtrMZDn0R15ScWq5X/UEbGvXf1lvgzV8PcIwhZ7JEmzUh0h/S0Zih9jyp5eN00lXjWvkw0f/6QE56zGFK4LF6kXVV3NihZeUeQ+/a5a5RiQTi9YimIFuhDCCqXrR0UWm8Imml0PpWtxykW1F1piAw1H/6PBUzuOtXQFJz5Rzs03R9skY5ltO9QWGFav5/ANC37U+dSh9SFKOhlFxzLt/qNUDmzPX1K/31NfVHA79KjosfW2l1NwzU/pB3muonwzgPQhzmpFAh+C2Ahjtvkh7s4S72hvocYEOyy5YJi1XT+XSoBPmevCSeu2/QDxOjpEkvmO8yyT3ex/80T7b87+yOnQQ0Qid2ifl97+SEv7itR4XOguVaD92XafcaKclvyok3D6eRuwWUc0eD2852Nv6/C+uFpgByjbEMxRG/awVe764a1kOqyjwhdXkQrHwlHBQpEYSuVgAxpX6mBJbca9Z3w56K2PK9xa77wtDOnfoyQCu
 6TaIDv6C
 G4CadptAsY3knCLmYKgBNKLRExkgUct0+vcPdc/bJWLYJqrtj8wvJtqmrPAOjbqsHKd62LsO3xg5PrrAixpAvI2Xlk42A+B8btV+K+JWVkkF8SkEpaqKBkXXirF0fT39GNSYu7eefGCmAyJcMqmKPYQtqdjZ6EyusAWa/a7oJA5tqeTJb3R5QBKrpY3ylGOIIasoCYBzk7p6qKsyuL5ItiEsMTxaQhdxhg7Rd
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Muchun Song <songmuchun@bytedance.com>

In the near future, a folio will no longer pin its corresponding
memory cgroup. To ensure safety, it will only be appropriate to
hold the rcu read lock or acquire a reference to the memory cgroup
returned by folio_memcg(), thereby preventing it from being released.

In the current patch, the rcu read lock is employed to safeguard
against the release of the memory cgroup in lru_gen_eviction().

This serves as a preparatory measure for the reparenting of the
LRU pages.

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
---
 mm/workingset.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/mm/workingset.c b/mm/workingset.c
index 8cad8ee6dec6a..c4d21c15bad51 100644
--- a/mm/workingset.c
+++ b/mm/workingset.c
@@ -241,11 +241,14 @@ static void *lru_gen_eviction(struct folio *folio)
 	int refs = folio_lru_refs(folio);
 	bool workingset = folio_test_workingset(folio);
 	int tier = lru_tier_from_refs(refs, workingset);
-	struct mem_cgroup *memcg = folio_memcg(folio);
+	struct mem_cgroup *memcg;
 	struct pglist_data *pgdat = folio_pgdat(folio);
+	unsigned short memcg_id;
 
 	BUILD_BUG_ON(LRU_GEN_WIDTH + LRU_REFS_WIDTH > BITS_PER_LONG - EVICTION_SHIFT);
 
+	rcu_read_lock();
+	memcg = folio_memcg(folio);
 	lruvec = mem_cgroup_lruvec(memcg, pgdat);
 	lrugen = &lruvec->lrugen;
 	min_seq = READ_ONCE(lrugen->min_seq[type]);
@@ -253,8 +256,10 @@ static void *lru_gen_eviction(struct folio *folio)
 
 	hist = lru_hist_from_seq(min_seq);
 	atomic_long_add(delta, &lrugen->evicted[hist][type][tier]);
+	memcg_id = mem_cgroup_id(memcg);
+	rcu_read_unlock();
 
-	return pack_shadow(mem_cgroup_id(memcg), pgdat, token, workingset);
+	return pack_shadow(memcg_id, pgdat, token, workingset);
 }
 
 /*
-- 
2.20.1


