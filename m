Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4AA4A60A262C
	for <linux-mm@archiver.kernel.org>; Sun,  1 Nov 2026 02:14:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gourry.net header.i=@gourry.net header.a=rsa-sha256 header.s=google header.b=bTxgYZWh
Received: by kanga.kvack.org (Postfix)
	id F2FDB6B05B4; Sat, 31 Oct 2026 22:13:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F07866B05B5; Sat, 31 Oct 2026 22:13:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DF5956B05B6; Sat, 31 Oct 2026 22:13:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B65006B05B4
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 22:13:54 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 53B781C3D5E
	for <linux-mm@kvack.org>; Sun,  1 Nov 2026 02:13:54 +0000 (UTC)
X-FDA: 85384929588.19.C44B7D5
Received: from mail-qk1-f181.google.com (mail-qk1-f181.google.com [209.85.222.181])
	by imf18.hostedemail.com (Postfix) with ESMTP id 735891C0006
	for <linux-mm@kvack.org>; Sun,  1 Nov 2026 02:13:52 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=bTxgYZWh;
	dmarc=none;
	spf=pass (imf18.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.181 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793499232;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KAOVkIrNNyhi9D/V3dLJ+NSr5WjrzmwZ1Aks/FNVQtc=;
	b=PkHRBjBmq+hF2AamARxx3Qv+7ST3GRUgFizk1yCdQUstD8R68/B+hfdF0ynECxzZufb/bp
	/j/StTdIsn3pxE/0EHhrAlmD+TTXdXf+XBqQ8XPIL9nrbMuCjFigk3oUsP1xwqxBTK1pxx
	5rIr+WXp+FrzLLCvS3IYA6NAdHN/wVk=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=bTxgYZWh;
	dmarc=none;
	spf=pass (imf18.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.181 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793499232;
	b=ILQAjNzvqO1Is9Vhc/XBwWcv9HOntdehmXSgKlooajueEtlTTd5heeDmo9dAxQv9pswc7+
	yZJ5VKdMsy0b5pjVMyra/kWynTiruQqAh1bSnvUgO+6p4+T5IiQHRKs15faGtnxuoOjgrc
	RzCKS4DZuPOuIHUz7GjvGDG/u4Gqb3k=
Received: by mail-qk1-f181.google.com with SMTP id af79cd13be357-945ae2daa3eso39836385a.0
        for <linux-mm@kvack.org>; Sat, 31 Oct 2026 19:13:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1793499231; x=1794104031; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=KAOVkIrNNyhi9D/V3dLJ+NSr5WjrzmwZ1Aks/FNVQtc=;
        b=bTxgYZWhBcZMNUr9I84sMK4mjhm/rnrZCk+2QZXKOUF3q1PvHPQrkf24mluGdxW/HI
         qxa+GVlSdrhPlmlQY9IUzqDN07ZWaTg0Ik6ITQZH3FjqRVH0t8hfKG9nJvLYdvwCcDFv
         N4cICVBJ0WAZRsr67gm7bRgrWBrbCFboRtXD9JI4R7hB9f/B6eKWt5FF67UDI42qOadX
         mqEUDwnMWmt0tELIZ7Y4yMFs/7gnu25W+tmbsRd5UyDAL2dAkxz+OkwLmd3HjZGvnx6e
         754cNtjxmR9anfg2P6BOyy79zZvf/qw6NQhNt1hxhYb5mZ/oLqRpOwcImnkfPuA07dkS
         tpWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793499231; x=1794104031;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=KAOVkIrNNyhi9D/V3dLJ+NSr5WjrzmwZ1Aks/FNVQtc=;
        b=VDiv2GcqMVesQVAtBe9CeSWzD1AlM++8jTJ8w5Ex0NZ0XLxo1VQ7UnXEdd8QNDAheu
         JmqWTY4uziOZi5D7k83LlRwqDV6+MNIpHXiqODvolOjmPmTcgjHTuUawSMvMAjjIOaGl
         YMDrDYE8sRFh34kT8J2MKa87VJGORdhCqu4umnpUeRHPR7UL9w9az3wuKkgH1XivhEoz
         AuPL8RYJp9GMfJwDbcr3MQy9heKDqTWRFPYGdzDfGeVTkglKIqsZZUU/vG7RYIM+4Ylj
         zpSMgpveQZpT85MgnI7h4l48gOP2HB1ckfnHjZWZJY6nesjNGzjJsStOrGdtlzjRVkCh
         dmqA==
X-Gm-Message-State: AFq9FYL7qTfyh+yQnVUkrZ9CvgqX6IJ0lGl/1dLZk0J/JDs0JN44a2dY
	S/gZbimNPzIH44UDGIiV3DieSuI63gcVgBRn+LPiTizjoD6hErVJkXFkkK34pGCGsCMviVHxvt9
	dmnA3
X-Gm-Gg: AYBFou1AnFsBdgdAhFuML4xGGr2BS2U7vm2RfI/I5d5vo9iVmnrdn5LLI8Z4dH3eaAU
	t/WBSzQVPcbYqAYEPz+4pPEdLfbs2YBbtHMAO58qGDEFZenMQUFfGs2S8o2DW2MtXcJZUT/fFt4
	lAoXcFZFcWnW5v9sR+g0MPogvR6AjDpjWK2nB7Zspngt87ibHG0OJlkz/lLC8DT9vaIKC1rgSxL
	MC3Nl7ONt5tzVlKKIMBKcEf7j/gZ54/JlxlIaHux1oE3QadfqOWhZD21PYxgs7ZCzVp1tOfy8Av
	OERDQZCCQZrOqugXQuFYPrroYbOLR6EDCR31pvAYAD85aIkiQgRC3T12JG9QeC9fm0kFEcahpgl
	FwoOUKJGzq74xEMvvS5D4ryF0dvisQjGKV6vx+er91AkCEiQfYwsXbTitOG6zGhsmaE/iWLLhoT
	M9mQqTuZ/MGGtFG5LKP93B6BSHvTpBsfPsGo4AvKYAWYq2UtjXNE2eCHMYrTQd7MQS31ROxyGbc
	LChydROLJBm8NYbRz33OsujBB6hathIjYfm1BZ/OwfLHeIYBdZcv1JHkKNpmaUjc1uUIeLmtBi1
	8BlWoX3XHv6WHGUOVkaQYw+ruojqNJ8sr0+4/to2KVS9thA2GJmbJdNzFXiZzSxHpltbR3m9+pE
	LkOmJKeQacA==
X-Received: by 2002:a05:620a:254a:b0:93e:6325:ae6d with SMTP id af79cd13be357-9442175ae31mr1053484485a.40.1793499231477;
        Sat, 31 Oct 2026 19:13:51 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-94425858552sm498131985a.18.2026.10.31.19.13.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 31 Oct 2026 19:13:51 -0700 (PDT)
From: "Gregory Price (Meta)" <gourry@gourry.net>
To: linux-mm@kvack.org
Cc: linux-trace-kernel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	kernel-team@meta.com,
	akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	kasong@tencent.com,
	qi.zheng@linux.dev,
	shakeel.butt@linux.dev,
	baohua@kernel.org,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	baoquan.he@linux.dev,
	baolin.wang@linux.alibaba.com,
	rientjes@google.com,
	rostedt@goodmis.org,
	mhiramat@kernel.org,
	mathieu.desnoyers@efficios.com,
	muchun.song@linux.dev,
	osalvador@suse.de,
	gourry@gourry.net,
	ziy@nvidia.com,
	joshua.hahnjy@gmail.com,
	rakie.kim@sk.com,
	ying.huang@linux.alibaba.com,
	brendan.jackman@linux.dev,
	hannes@cmpxchg.org,
	bigeasy@linutronix.de,
	clrkwllms@kernel.org,
	nathan@kernel.org,
	ndesaulniers@google.com,
	morbo@google.com,
	justinstitt@google.com,
	Bessel.Wang@huawei.com,
	jiang.liu@huawei.com,
	mgorman@techsingularity.net,
	anshuman.khandual@arm.com,
	Josef Bacik <josef@toxicpanda.com>,
	stable@vger.kernel.org
Subject: [PATCH v5 03/12] mm, page_alloc: pass zone pointer to trace_reclaim_retry_zone
Date: Sat, 31 Oct 2026 22:13:31 -0400
Message-ID: <20261101021340.2251928-4-gourry@gourry.net>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261101021340.2251928-1-gourry@gourry.net>
References: <20261101021340.2251928-1-gourry@gourry.net>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 735891C0006
X-Stat-Signature: uxp5emhxnr1u3or4hqztfuke6wwjjif9
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	T_SPF_TEMPERROR,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=4.0.1
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1793499232-365767
X-HE-Meta: U2FsdGVkX19A342+gRpDcoe2f/fwqhZT2lkOm/X0+3LxWN9BW+sAfsSMTmYjEHsU9MiKW4xy/5Rvod2bz/UvUIF5LQPqtkZnMLhqwqihfjo8PlMIy2N4N2f740DYW26D8dYR4MB/f7/h6VIQdAH3sGUSroO1TZvBuFFsXJbgYZNI3ZPQyEMOdX/6EA+jszJ++vUKiv/YZFQvUY9KXlcmICk+fxjGaiFlXxyfIywN5bEfhppj2PUHJFL4ngyEwCYZrTW+5BHJg7As+28YW4IHT0CMODXcTmOtMh8hUwxad/ZGzU1nEeVpciVRBl4iYweKZxNimsDxH9mvq8hVswGSvAwXrXxTCfYVdb6INjziQRjMFS2UJ4+K4Jbt3NTuRR/I1RlaCMMNnsK09luP2ZpIsB8ujMXXaIGfPrnokfU71z99LN+bRgluALZyV9emLfyq7+NAawQ1MszLbffSCAdpSLZcCFMpHea0tk+XatEkmulM/cnrMhnmpPmOh03w8tld1KWxnVfeOrDwpTWMqGsOGSuCvmcsSQSfJMVN7IU9l8bDFCtqi5zIIJ5GEMj7oJfaojZJIou7xptSbJWZoSFZY06FIQhe0bOXGJrL5as9HgoVgQsDK27w2nswIMcsLMo7+p7U2Ckvyz2BCZXl46fxLBrlryoSjoTdLiLihzCQr/nNS6jkmG9bk5o51Uz9rfUnDqcLuKL9ddvNkOhKQQiSa5rLiyWG2gKoWQUYchSA2ueUm+u53eQgkM/AR0iuNH+dN5yjsG2hJBIfcyxnJpK6Hx8ZjjXhWCLotDDZ3M0Xtk++NjJMnxhD0tffYfs2ZrWbUA6cBNLoKRqHtWNtkd5rXPIbTv+05VxYMT3zpkfeJhDIMVEgflY4litlSj/73NYFx1iftK1UNSNB89Hgvqmn1hmRLaKItHjk/UoddftW5qEznL/c2AlUTxpfqAgKk7PozVgO3I+NWd7CkV7dQRY
 kE7MmrBr
 /tC0AhJti6M7f7KOTNgrEa5/AgghYz5fqZIs2zVq4XtoVIdXk7ZzowDvHcsnV7FhbDNmo1ZEDjNDRsUAVOq0HREj7ATlU1y6aopdIkzt/qbV8b3R2UNy4zskcukuZcFFlcVASAvHeEIh6doB7T/nfMREGMBTnV4HbLyNmuIgohzGPSXb2swENe9P+YlR+Idxe9UR+uhVTlPJ5PzKkdS2GjDLEv4krkhCit4n7J0ZfVHOE/u22AO0AmSwC40oplhYDNVdL3U2YS8JF/z0wWKWGqTSlNp1Ud0B59ZjIwIw2BPJOo4/7+i8WoLxImqzEhNKg61FL8eMjNR0CZUc2LgoI8B7HpuV4Mq2p3J9VdPXv+z4618nbiwFYLaxAC8/gf6GkLPkroJnPd8QBoryG7mLjjNxaChhKmVzorUjJ2/CoGj0L8meIrbCEw9VQsdUvXphVCxsCxt+PEcL6I7587ZvHmtmow/W0SEDl58EWuMnJ7MaAPoUj4mHS7SBAef4mNu0jOrdi
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Josef Bacik <josef@toxicpanda.com>

should_reclaim_retry() walks a zonelist and passes the zoneref pointer
to the reclaim_retry_zone tracepoint, which loads the zone from the
entry again to find the node.

Memory hotplug rebuilds the zonelists in place while allocations are
under way. When a zone in front of the zoneref entry has become empty,
the entries move up, and this one can be the end marker by the time the
tracepoint looks at it. zonelist_node_idx() then dereferences a NULL
zone. Short of that, the event can name another zone than the one its
numbers belong to.

Pass the zone pointer instead of the zoneref pointer.

Fixes: d379f01de095 ("oom, trace: add oom detection tracepoints")
Cc: <stable@vger.kernel.org>
Assisted-by: LLM
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Signed-off-by: Gregory Price (Meta) <gourry@gourry.net>
---
 include/trace/events/oom.h | 8 ++++----
 mm/page_alloc.c            | 2 +-
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/include/trace/events/oom.h b/include/trace/events/oom.h
index 9f0a5d1482c4..cbcf6fe4cc61 100644
--- a/include/trace/events/oom.h
+++ b/include/trace/events/oom.h
@@ -33,7 +33,7 @@ TRACE_EVENT(oom_score_adj_update,
 
 TRACE_EVENT(reclaim_retry_zone,
 
-	TP_PROTO(struct zoneref *zoneref,
+	TP_PROTO(struct zone *zone,
 		int order,
 		unsigned long reclaimable,
 		unsigned long available,
@@ -41,7 +41,7 @@ TRACE_EVENT(reclaim_retry_zone,
 		int no_progress_loops,
 		bool wmark_check),
 
-	TP_ARGS(zoneref, order, reclaimable, available, min_wmark, no_progress_loops, wmark_check),
+	TP_ARGS(zone, order, reclaimable, available, min_wmark, no_progress_loops, wmark_check),
 
 	TP_STRUCT__entry(
 		__field(	int, node)
@@ -55,8 +55,8 @@ TRACE_EVENT(reclaim_retry_zone,
 	),
 
 	TP_fast_assign(
-		__entry->node = zonelist_node_idx(zoneref);
-		__entry->zone_idx = zonelist_zone_idx(zoneref);
+		__entry->node = zone_to_nid(zone);
+		__entry->zone_idx = zone_idx(zone);
 		__entry->order = order;
 		__entry->reclaimable = reclaimable;
 		__entry->available = available;
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 1850a41f24f7..e14d550d4128 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -4670,7 +4670,7 @@ should_reclaim_retry(gfp_t gfp_mask, unsigned order,
 		 */
 		wmark = __zone_watermark_ok(zone, order, min_wmark,
 				ac->highest_zoneidx, alloc_flags, available);
-		trace_reclaim_retry_zone(z, order, reclaimable,
+		trace_reclaim_retry_zone(zone, order, reclaimable,
 				available, min_wmark, *no_progress_loops, wmark);
 		if (wmark) {
 			ret = true;
-- 
2.56.0


