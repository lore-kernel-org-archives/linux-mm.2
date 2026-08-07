Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9CBA2C2A09B
	for <linux-mm@archiver.kernel.org>; Fri,  7 Aug 2026 20:21:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 16E3C6B00A0; Fri,  7 Aug 2026 16:21:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0F54F6B00A1; Fri,  7 Aug 2026 16:21:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E16196B00A2; Fri,  7 Aug 2026 16:21:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A668A6B00A0
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 16:21:20 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 332CF801B6
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 20:21:20 +0000 (UTC)
X-FDA: 85075593120.09.79F31D7
Received: from mail-oa1-f50.google.com (mail-oa1-f50.google.com [209.85.160.50])
	by imf01.hostedemail.com (Postfix) with ESMTP id 525D740012
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 20:21:18 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=C2kB79On;
	spf=pass (imf01.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.160.50 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786134078;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wktIFByfmvNWwU5aKwDRUJNG+vu9pXnbr6sGB9f+FbU=;
	b=VqWvKm50Voyr/5F4s7tfsfcPxSRjiAsE4+wiHauX4cHT8Euk9yDf+e2k/2MEBJnm0SIsVN
	Z//olpg4w8OBdJ1O5vsOIR0xTWUFzkf/VDWqMfCZOyBJfa0yPHikuximPKpn+RTrXts9Io
	Nh/EoslyAgujP0Xd6MwHM7IU3+yjkBc=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786134078;
	b=WDbGljhOLm9/k25Fog84qm5AP+XEATQ0lSqpziDkspUwc2Y7ochWKtpYfH9+CnmdM/Mweg
	9PqxD5h8HnHBHu3FAggOHSjju5l0PztBYzOi3RkN0gBeG/JPNS3xUa/Pe7thgYjxe1/GyQ
	ZlUTQpiXqD2gTmxF9Gw+9M7QnZBVYrY=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=C2kB79On;
	spf=pass (imf01.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.160.50 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-oa1-f50.google.com with SMTP id 586e51a60fabf-4563ac048f4so2211676fac.0
        for <linux-mm@kvack.org>; Fri, 07 Aug 2026 13:21:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786134077; x=1786738877; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=wktIFByfmvNWwU5aKwDRUJNG+vu9pXnbr6sGB9f+FbU=;
        b=C2kB79OnZMoCol7gQECslLcJZv/Z2iMR8kPRZS4hgBDmNXqxbBuLXGcd+716Jacl15
         zSnhAq3AmIr96NvtdtbXAd5F30PBA9Jj+hOL5iu28Xwyvi3BBsIiZ6S4vERE7rbbd+b5
         u3iOgvHQgw5gBFJSEwi7cjVzP3Ko1sFkcmJZ44L94zGI/c3t3rqxicY5nGoVzQVVBzD6
         I29Rw6Yb3iGNp1HnJbnic3221DHdLuOPne0p0EQIPHt7cCqOLBvQK0WK3yOdAhARkfKv
         0qDj9gs+OWVFevqpVV8qqA+WlaUtXlDEyb2Gezalwke7KMsucDfeZ/WzuHjMNUxckb+U
         ySCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786134077; x=1786738877;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=wktIFByfmvNWwU5aKwDRUJNG+vu9pXnbr6sGB9f+FbU=;
        b=k5r4SBaVgKvNLAoBkxsQD5aLyPvcvWwGvxAMpnbTDAPgBLlpAoHX/phpNq35YEJxhk
         a6lu0HLP9othdShM/dH2sKvYfd6m4/UId9X9XixclSv3camXkz6j3K8b9Tq+oXRtkaMf
         9YpmdxTFOg+w7jJgLNrUlfrHVxkPGwPvZJE6XacZ/nPWBhyDW0NlwAh26eA1D7ByU2sk
         jw/w45SpMBH9PSv1ffW8MhlBLQ5tSTrI/9bjOxzf3SV01C4M3tVuPGMR4K5GbbyS8mDb
         34SNQA4HWQVrPp45IOmvhKj21EVrv03X2V+OuFWFfExGxi6QCDsgnCJGcG79tKabzAwb
         Ps7g==
X-Forwarded-Encrypted: i=1; AHgh+RqV5uMSoCjBUfdvR6pNydgnEVSNFVFwbr3G98eeA4ZumFqYQbif1jLGbjCaVfs64I+oi5AqsfAEHA==@kvack.org
X-Gm-Message-State: AOJu0YwIwRAN17SpjjWM3YUgZkugq8XvqtmT/dizfv7gV+PKnavgfxr1
	uGPVUJzNp3VBCmdPZNrz8i/UFio0AmjOoW4c7UOZbBe0Y2QrUnlybpMs
X-Gm-Gg: AR+sD13poBE0Elb9UKUGzzIZ8IT7CQNaNgxO6a6VcF9d6P5UloZW/ZqR7J96HhQ2OP7
	TLgfu8mzVDJ4sBOCH9bR0l0XZg9CyU6eHB+ueLGYLyadgnR7buNvyrFIdZNESYBn4reED5Iom6x
	+52OX2UrcEFMudQQ/vn3vuGn5x8kAlSICm4qXORRxNK45dSlFQGpqUiknx5U1e/PdePIpT5e/mR
	UQVcMqXuSck2uPKKO1l1imO3nsiZcyU1N/bsXQjV6/G0AQFf3mCUoSKtc5oq1Xvyf2KzH0J0hmM
	2DR1mDFZipMdMfXLqym2x1apsLHdt7jVYsQosQu+v2AiAn0jTJfoDkN/Pr3sRg/OzPlufrObE4s
	2D954OFQ7vr8Z1fFyuEjn29KCDs/NGlMDWUDKDoJQBP0cQXhfeVsQnt151TtzPXoRM4IfXrZdrc
	/mhc9wZF8cave7a2cqvK9TAgE8i9lXKgwEXIb4IEDaTEOixvBgBxpTXUxLKaR6yMlUu3wcSeTaB
	Eou7kVtC0GSBVlrj1bxsCbaQ88r6R/DsmF5SAGe5A==
X-Received: by 2002:a05:6870:c250:b0:453:9b2b:f3f1 with SMTP id 586e51a60fabf-459ff6b0630mr3346442fac.5.1786134077083;
        Fri, 07 Aug 2026 13:21:17 -0700 (PDT)
Received: from localhost ([2a03:2880:10ff:55::])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-459f1e28910sm2664792fac.15.2026.08.07.13.21.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Aug 2026 13:21:16 -0700 (PDT)
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: Johannes Weiner <hannes@cmpxchg.org>,
	Gregory Price <gourry@gourry.net>
Cc: Alistair Popple <apopple@nvidia.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Barry Song <baohua@kernel.org>,
	Ben Segall <bsegall@google.com>,
	Brendan Jackman <jackmanb@google.com>,
	Byungchul Park <byungchul@sk.com>,
	David Hildenbrand <david@kernel.org>,
	David Rientjes <rientjes@google.com>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	"Harry Yoo (Oracle)" <harry@kernel.org>,
	Ingo Molnar <mingo@redhat.com>,
	Juri Lelli <juri.lelli@redhat.com>,
	K Prateek Nayak <kprateek.nayak@amd.com>,
	Kairui Song <kasong@tencent.com>,
	"Liam R. Howlett" <liam@infradead.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Matthew Brost <matthew.brost@intel.com>,
	Mel Gorman <mgorman@suse.de>,
	Michal Hocko <mhocko@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
	Peter Zijlstra <peterz@infradead.org>,
	Qi Zheng <qi.zheng@linux.dev>,
	Rakie Kim <rakie.kim@sk.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Steven Rostedt <rostedt@goodmis.org>,
	Suren Baghdasaryan <surenb@google.com>,
	"T.J. Mercier" <tjmercier@google.com>,
	Valentin Schneider <vschneid@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Wei Xu <weixugc@google.com>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	Yosry Ahmed <yosry@kernel.org>,
	Yuanchu Xie <yuanchu@google.com>,
	Zi Yan <ziy@nvidia.com>,
	cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	kernel-team@meta.com
Subject: [RFC PATCH v3 11/14] mm/memcontrol, migrate: Transfer tier charge on migration
Date: Fri,  7 Aug 2026 13:20:54 -0700
Message-ID: <20260807202059.2620949-12-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260807202059.2620949-1-joshua.hahnjy@gmail.com>
References: <20260807202059.2620949-1-joshua.hahnjy@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 525D740012
X-Rspam-User: 
X-Stat-Signature: kmj6nmqfxzebzmrp6kcakfu8duwx3bqc
X-HE-Tag: 1786134078-233012
X-HE-Meta: U2FsdGVkX18NeeMeZYvp0sqVnQWdtMFI+fcJuCra+iQkgtEUy+OAHxCR9rL1PegixXWKDkdpaXArz9Rnm4fj42xrQQ7zxGTf//h1d8qS5XLk1Tsh0AkpXvaWN2Ou6vum53j5hT+t3Nw1ah2hpcJR75A0JwiAL3wVW6vk6DL5RxEgmb96oFQO7KmGmkkScYds2DlZuoutxAXJ0aA/gi1zTMoVrhjiKpHl/sbgPVhkvlhPvbU354WmuPIF5IhaaOJ/f/lZmly0WlzYkh4bFCS0GUt8MvMue99fYrcrCrpWjTmo+kKNIs8WeEQiy7XZcbBEiGanRd/UPLWJktmvnpfJR7JtoI/SHthQGxcVfZNWbJCv69Zq30rZPLg5JKetQ9lfiYbxp5/7VSvmDooyIgHckvYiNY4eQ0CFRJ2IakCk02yaq/YMDiu/LV/9nMxWhqiebl3/OpLPDy0+mnLk8lhZi6PX71aTaeCHwJNdt0tKz9XDrhk5VADqVfdnvPbVtw9xtX4xb8gGVJiPyswkAI8qi+5Cl2I5IJpADl9jxg+oEbja64w6DF5Q8o8/F7Kyz6mP3gO1lpRBFS7SZEeyytWutH395D2QH+XgehjbuvffohswYaIwVDDsJM1EgLJnVRhmClGF6vmPpemP/vmb3gu1gZ0+N/hzbZJ8WHmjV2Cp4tuh0i1K9k+3EMXFuHftYGweGXmY7Pfx8VChEUnBET07qYrqWEoQuW7dx1nhA5AWf6ShTMvs4KNWe8oredzTdmcHtv22siyTFxThUuMmkIXr28YXBReQP+nz1+klJR5f/nt1WVDapXEAdlJhEpb1ZJYp530ZJ0pmMqXx6KvQgkjjwIj/IQrZLRwwb+ecJAiw0hUXTCAnw5YnSDCYKBPHR36nU7hGaVJJD+ZXvti381xo2jjTqOUaTPH4b1Mx/5uRIoLaankiucRnxd1U6yoB318xy4vnddx46wlNUIoUBCj
 /CBaII6i
 s8kL9bAeJesyTKQArgXtX1YdW2bP+jil0yuvAAEvwOkZynJsr66xhTuSun6TluzMzk5q2t9TGzRkyfyzOMSFXBh8bWbsBhzUYO0Vd3PXR31KE/V3KXD+/DGTDBIUJ0+WeUWkQDGNY7aIxQ+EYd8PBW+ZfXRnZEF+mLLfPCek0G5rYFoqwJfX3veNnjGCwj+9tM4kd6Yz087R2s/UN6nftszC3TXL9M6lJKk9Rx1GVEB/7cvENGiRVab5nRt893WK3iN8n4FIfqkg4rp5Bc5YQfrZsKZgbWQ43uPa1gHq1fytnfdqHEfQfwlgQ5aco8iFsR1FJ4mgDKdxiXIQR921DZGhVAljnKLnnH5IjTcK3IXDJmgff8l+iUFZ+DpT7kOOriShbnh2ILOYZ4faj1P0HoYYGU0UbC5zQrbcl5QdFf3flUsOaTbBfSrqam8egbNGkGt9d0fhhbDNjn0AA88tNVKQfMPsEi7J1dAsT33PrJ5hMrE1CKxSDWGEJTMRzVmj6ly37RoLnLs9QvYHJ40J2/yEzcx4rayCq+5yf41XAlZ0Bzf0Kbz75hvbNLk7UKv2S1pfd
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Folio migration is charge-neutral, and existing migration paths take
advantage of this fact to simply force destination folio charges or
just transfer memcg data across folios.

Per-tier memcg limits break this assumption. A migration across tiers
(i.e. promotion or demotion) keeps the memcg-level charge neutral,
but the per-memcg tier charges change. As a result, the destination tier
may go over the limit.

Charge the destination separately instead, from migrate_folio_unmap
where the destination folio has just been allocated but can still be
rolled back. This charge attempts a single pass at reclaim if it goes
over the hard limit, and fails the migration if not enough headroom is
created on the destination memcg tier.

Note that this source of migration failure returns -EBUSY and not
-ENOMEM since -ENOMEM will attempt the migration again by splitting the
folio and aborting the batch, which both do nothing to reduce the
memory usage of the memcg tier. We also don't try too hard to reclaim
here (__GFP_NORETRY) since failing migrations is cheap, and we don't
want to OOM kill because of a promotion attempt.

One side effect is that cross-tier migrations now hold both folios'
charges until the source is freed, the same way mem_cgroup_replace_folio
temporarily holds a duplicate charge.

No-op unless the system has tiered memcg limits enabled.

Suggested-by: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Joshua Hahn <joshua.hahnjy@gmail.com>
---
 include/linux/memcontrol.h |  8 ++++++++
 mm/memcontrol.c            | 35 +++++++++++++++++++++++++++++++++++
 mm/migrate.c               | 30 +++++++++++++++++++++++++++---
 3 files changed, 70 insertions(+), 3 deletions(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index ceba0fd6de184..9c2f11191a499 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -708,6 +708,8 @@ static inline void mem_cgroup_uncharge_folios(struct folio_batch *folios)
 
 void mem_cgroup_replace_folio(struct folio *old, struct folio *new);
 void mem_cgroup_migrate(struct folio *old, struct folio *new);
+int mem_cgroup_migrate_charge(struct folio *src, struct folio *dst,
+			      bool force);
 
 /**
  * mem_cgroup_lruvec - get the lru list vector for a memcg & node
@@ -1204,6 +1206,12 @@ static inline void mem_cgroup_migrate(struct folio *old, struct folio *new)
 {
 }
 
+static inline int mem_cgroup_migrate_charge(struct folio *src,
+					    struct folio *dst, bool force)
+{
+	return 0;
+}
+
 static inline struct lruvec *mem_cgroup_lruvec(struct mem_cgroup *memcg,
 					       struct pglist_data *pgdat)
 {
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index de6762520f475..1161934e81380 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -5716,6 +5716,41 @@ void mem_cgroup_replace_folio(struct folio *old, struct folio *new)
 	rcu_read_unlock();
 }
 
+/**
+ * mem_cgroup_migrate_charge - Charge a migration destination up front.
+ * @src: Folio being migrated away from.
+ * @dst: Folio being migrated to.
+ * @force: Charge even if the destination tier is at its limit.
+ *
+ * Folio migrations result in a net 0 memcg charge, but the node location of the
+ * charge may change during promotions or demotions. When this happens, charge
+ * @dst in its own right instead of inheriting @src's charge.
+ *
+ * Return: 0, or -ENOMEM if @dst could not be charged.
+ */
+int mem_cgroup_migrate_charge(struct folio *src, struct folio *dst, bool force)
+{
+	struct mem_cgroup *memcg;
+	gfp_t gfp = GFP_KERNEL;
+	int ret;
+
+	if (mem_cgroup_disabled() || !folio_memcg_charged(src))
+		return 0;
+
+	if (!mem_cgroup_tiered_limits() ||
+	    nid_tier_slot(folio_nid(src)) == nid_tier_slot(folio_nid(dst)))
+		return 0;
+
+	/* Refuse the migration if the first reclaim round fails */
+	gfp |= force ? __GFP_NOFAIL : __GFP_NORETRY;
+
+	memcg = get_mem_cgroup_from_folio(src);
+	ret = charge_memcg(dst, memcg, gfp);
+	mem_cgroup_put(memcg);
+
+	return ret;
+}
+
 /**
  * mem_cgroup_migrate - Transfer the memcg data from the old to the new folio.
  * @old: Currently circulating folio.
diff --git a/mm/migrate.c b/mm/migrate.c
index ab15a4dddd047..45d6d23d53859 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -862,7 +862,13 @@ void folio_migrate_flags(struct folio *newfolio, struct folio *folio)
 	folio_copy_owner(newfolio, folio);
 	pgalloc_tag_swap(newfolio, folio);
 
-	mem_cgroup_migrate(folio, newfolio);
+	/*
+	 * For failable memcg charge transfers (demotion / promotion) the charge
+	 * has already been transferred at this point. For everyone else simply
+	 * transfer the charge here, where it can no longer fail.
+	 */
+	if (!folio_memcg_charged(newfolio))
+		mem_cgroup_migrate(folio, newfolio);
 }
 EXPORT_SYMBOL(folio_migrate_flags);
 
@@ -1216,7 +1222,7 @@ static void migrate_folio_done(struct folio *src,
 static int migrate_folio_unmap(new_folio_t get_new_folio,
 		free_folio_t put_new_folio, unsigned long private,
 		struct folio *src, struct folio **dstp, enum migrate_mode mode,
-		struct list_head *ret)
+		bool force_charge, struct list_head *ret)
 {
 	struct folio *dst;
 	int rc = -EAGAIN;
@@ -1228,6 +1234,17 @@ static int migrate_folio_unmap(new_folio_t get_new_folio,
 	dst = get_new_folio(src, private);
 	if (!dst)
 		return -ENOMEM;
+
+	if (mem_cgroup_migrate_charge(src, dst, force_charge)) {
+		if (put_new_folio)
+			put_new_folio(dst, private);
+		else
+			folio_put(dst);
+		if (ret)
+			list_move_tail(&src->lru, ret);
+		return -EBUSY;
+	}
+
 	*dstp = dst;
 
 	dst->migrate_info = 0;
@@ -1918,8 +1935,15 @@ static int migrate_pages_batch(struct list_head *from,
 				continue;
 			}
 
+			/*
+			 * Hotplug must not be refused: offline_pages() retries
+			 * indefinitely and ignores migration failures, so a
+			 * refusal would hang it rather than fail it.
+			 */
 			rc = migrate_folio_unmap(get_new_folio, put_new_folio,
-					private, folio, &dst, mode, ret_folios);
+					private, folio, &dst, mode,
+					reason == MR_MEMORY_HOTPLUG,
+					ret_folios);
 			/*
 			 * The rules are:
 			 *	0: folio will be put on unmap_folios list,
-- 
2.53.0-Meta


