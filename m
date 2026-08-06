Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B421DC56205
	for <linux-mm@archiver.kernel.org>; Thu,  6 Aug 2026 19:22:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BC32D6B009F; Thu,  6 Aug 2026 15:22:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B735B6B00A4; Thu,  6 Aug 2026 15:22:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A3EB06B00A5; Thu,  6 Aug 2026 15:22:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 7B6C26B009F
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 15:22:56 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id DDC43A01D5
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 19:22:55 +0000 (UTC)
X-FDA: 85071817110.26.2AD6AE5
Received: from mail-qv1-f51.google.com (mail-qv1-f51.google.com [209.85.219.51])
	by imf13.hostedemail.com (Postfix) with ESMTP id 9A3592000A
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 19:22:53 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=l3gDom2Z;
	dmarc=pass (policy=none) header.from=cmpxchg.org;
	spf=pass (imf13.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.219.51 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786044174;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ed/LSBroZxO0PfqLTAzd0hHdaL+KK4UGWxAVAlrHj6I=;
	b=G63q+dSA+9P55UgHm82DxX+makRQV/iAbPtmBwQjcHm1oagDMuZK2XPKZUrpJiLtfgczP4
	P0ttZrTfEGGNdQazoh+3ZFE6T2ggQDoLhaFEeahVkoRexLLc1/+CoFg3J1oDYJa2TyXwpv
	2NkVuPMHcZJcDT2zCSUOUvndrp/cZcI=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=l3gDom2Z;
	dmarc=pass (policy=none) header.from=cmpxchg.org;
	spf=pass (imf13.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.219.51 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786044174;
	b=yved8r5parL3Cr+KAL+dsw+S8SGnowUcofw0tBeVMy5yn1VMntWToOYApZ2w4sWkDvyyj1
	8hzoBi7NzJkWrg4JyuEHKjs7dDexZn+3hJxaMmf+OrC4m+Plu7lJ5UjkxoFVrwVzMbwJto
	5OHAgDxbWtdmreNWkflrzLqzWoSJzBs=
Received: by mail-qv1-f51.google.com with SMTP id 6a1803df08f44-902e4af2d9dso10369816d6.0
        for <linux-mm@kvack.org>; Thu, 06 Aug 2026 12:22:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1786044172; x=1786648972; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=Ed/LSBroZxO0PfqLTAzd0hHdaL+KK4UGWxAVAlrHj6I=;
        b=l3gDom2ZP8QtHFgRjBgsaNjo265TVIpxnfiJm8Ym4LMxXZxeg0niPz3ypKrf8j+V/r
         /YMY4Y46Fo0LOch/gVXrw7Y9s+pI4Soymp8JX2aQSNRtBNkmDiEnqgq5zYsGwyZAZHNJ
         +OVmB0t9pEPVDd60S+ve5bLpogY7Dq1AdfelGQNXcU956QtIG5CphBo0c/E2amlFofJQ
         x1lZVZr8E+q/57yVuVULMOisSyON+tVWAHD1HEalb6N+uP4fkuU6slIvj/fx4ufEDE+L
         P+n1gp4Q0uEM7tK3SRyKdT4grB4jqJuu9cqzQUXvkVqGuFLKYhuuYF5SxUjB+7qQ70al
         ZjlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786044172; x=1786648972;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Ed/LSBroZxO0PfqLTAzd0hHdaL+KK4UGWxAVAlrHj6I=;
        b=eI1MiX17iUh0XCIx3T+IDRGytENvw874b3Kj5OAf65sWc4XCnIKmlH+u5TF/oMcu1c
         00b9GqbIB4iTaXlhpGhDw6RGT50ncI3qfqSx3nal8K4ujIk0MKrk6E5UJ7q28Uc63jZ7
         r8Cjw3vHi0s1i15q7b9oeia4zieqvwd2yylkW8JHHNCWIApbkeRaKnBUfV76Gg9TIMhp
         6G0G3ibJuF+KFSMGTibLCEn7hAh7L4MH4qkxv1kFuo8C/3ABfKtiiU5rCZWPKKO0GyEY
         UvWIl3Cny5EA20q6/OfX5yfspmHu5cY+dH8zZr9A3CIpYsxtZCheY1JCKnRXzgUo3N0R
         wwyg==
X-Forwarded-Encrypted: i=1; AHgh+RqdpNBkY8XSkDoo+ZZ0R+G3U30tPLTurhvIPY2EEIe1OaHiS989niUc4zbGoZuG+XQNMdZuCoaPiw==@kvack.org
X-Gm-Message-State: AOJu0YwUDLKHfXJ+z1yRG4TUc8lnmhQNloSaipVkadZ9hwkN+7PnuZ9m
	3BqcnRS0xIDxnSVI357n2rPToXIl2RonUeP18zq+QrDmFzpFqEQD3iO7u/aViGxXJ9c=
X-Gm-Gg: AR+sD13O/zuXzYzccMl/he5w9RF5NLtkQOsO4bwv1LBcT9iH8asWeHKYa3U6sEjayFQ
	19YG6Vw+pbkeGRns5/dsJ+F12dfrttmOo7oqti6IisEgltKe9dh+j4HrHJNsA+HK33X4ewR3r2x
	zdtSw1/nZcb7HzJapSKlPXvPxB5dykPX5JSsaUbxwJXaS6jgRMaWQGFCCr6pr9TaNAcCLVCzMDY
	FjsmFAd1DPNSB0VpVBlT7YO7nAt6i4qjkMN5SQ64/13q2IDzQySvvLBeSVOH0yVC2RCJ5tx+Oz0
	QShtUppM0Pr6eyaYfC5pDRptYkbr+VIzDwAiFqWs2Lis3CEtNx3PkLcfXVW4FDmIL9MtGOKZ4Pi
	OpEec0MHZmmZXVzUEiM3V03kqt5mlnMwK58BIfUsVAMYzjfh2HWMRCc0ie2AuzU2nikDON7KcK5
	bIrnyHoPpIq7ADho54AIVhFvP+4AuVof/8cE8DP5yDMl30CNO3ewv3RJh170E=
X-Received: by 2002:a05:6214:3210:b0:8ee:756a:bc32 with SMTP id 6a1803df08f44-90893232a46mr86763646d6.15.1786044172481;
        Thu, 06 Aug 2026 12:22:52 -0700 (PDT)
Received: from localhost ([2603:7001:f100:500:365a:60ff:fe62:ff29])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-908800cabedsm58786346d6.46.2026.08.06.12.22.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Aug 2026 12:22:51 -0700 (PDT)
Date: Thu, 6 Aug 2026 15:22:50 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Michal Hocko <mhocko@suse.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Muchun Song <muchun.song@linux.dev>, Qi Zheng <qi.zheng@linux.dev>,
	Meta kernel team <kernel-team@meta.com>, linux-mm@kvack.org,
	cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
	Karl Erik Hofseth <karl.e.hofseth@opoint.com>,
	stable@vger.kernel.org
Subject: Re: [PATCH v2] memcg: keep folio's objcg same as its node
Message-ID: <anTfChWlK998-7sY@cmpxchg.org>
References: <20260806165813.2526415-1-shakeel.butt@linux.dev>
 <anTPPr5hVV4aQLRD@cmpxchg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <anTPPr5hVV4aQLRD@cmpxchg.org>
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 9A3592000A
X-Stat-Signature: qtp9ugarc1fhimnt5q848ts3m41ro8x9
X-Rspam-User: 
X-HE-Tag: 1786044173-469465
X-HE-Meta: U2FsdGVkX1/bnairhsFDKDYSphVJ9Hjx8g4MaahsDL7CVf7FS/PbmeINqAefsjAjqxUMQetA4md2oAHcf45Zv+CyJOZPJPnT109+tZjGkGM6Yjk4Nb+aryApihmknySqM9eEj0KYMJbSqKxwKyH/JXUrz0q6Ach07MYpMO/zWI208Lsj47eafHa+jyWtniCcdtiN3Vze3eyNmFLhzzQ0MtFbYEIuJQxEcxWMysBWyi3uNyYR1Gz0qqXy0CxstYDQtiS2u2pNsZqinK7gbrn9LC8bQHCqMTRlNzCHGk7mikrXsxgHQ58KhFh6Vow0QJnYNx6i8L2XzI39F7RstWePvXQQl89bHxXwOZsHklrw0LYvpnGeCHDm104LUjkHc4bMjUaVZv3xO/MEhNdutyw9WmwSvvO1aHL1hDsm0qB0fNLHJFUgvIkSR6Bbx66hpyLUbtXUfQ9GhHzfHBaOj5AiaSrGyp4Nb4+DVxBItecyJHE8wVYk6U/rthE0k8N9bi0VOg+7CxBqbIitZ+QVG/7FatGJigDjI8xFJUROFt+T2Wa/JO2cnnxTpNgN8vQ1Cq/XwgMBRTkkgxSr4CfiNfOLOnyS0wO4MjUUfSjwU9V6hPLTK9kpKTEkSfnKPKn10NSvrUGSjN8X0zS4BjgaPG5QXzvN5DZYKuA/FuV7CY8/xrGWyyEufBxiysWTNS5v9q5fglWJvWu9nrout1pRvn0iihawrz0pgRfrgKL3ZApb3AglQnvlc6tsUar7NcdwtqLDfxlJR64ojipJLehNY3qzWUCjO184COwrJuv5r96aQxEM2QqzoKqug+7fRBdGj//2UXnLb7BSLQT+ZZ8JxWtATgvuyHlhJT/23tsEKL513EiVIl2Ux5/yXTLKoeKtsyDtjIZdxQynjqROKAodiHK6OU4JgOjI/+oOKljkVmm8vaxSA2ouhwacTXx+mdMgP+z3/8YwZ84SMNdQhdg2XWi
 r+bhIvJo
 2d3nJCz5RqLadR4KFL1ACb43mvB6Fu343opAA5AIRaPdcpmeH66EN7gzj5zN69uI39cHUlZXLeUhds0xFowC9UuzXiodM7DHtZ7bwS4cDfmtIWDq0MKx5Py4Koz739gfvhgozep6PejmTCa6iOFUtFGpLHWitv5epk807T3MUB7Sn/cA5V4Q+mqvmRJUPRP+INYc++BwdDK0rh6fjNPUeuu8lDqyjuYu+bW174fHAi2IwZkb8L6xsjtjPdA8oRL4Oq+89ezws/PLeDd6SU86CNgudxAkPkkSE9TzBNGwWRuWTVzHZ9Q0dTQ2bwys1wMkL4c488RKBLaBOr7BneHi2sWDnLZWRQJUuy9MU3S+yrw72jyuhOYuhhWG5rKC5eh/KARkl8N4Y4pr5mqFVLqkitXKR2Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hm, it's still not quite right.

When there is a root mismatch, we cannot fall back to committing the
old objcg. That would reintroduce Karl's issue. Not as broadly as
before, but can still happen if the memcg tree died up to the root.

So we have to commit to the new objcg, always.

What obj_cgroup_is_root() then comes down to is whether uncharge will
balance the page counters or not.

mem_cgroup_replace_folio() gets a new charge for the new page. We can
just conditionalize that right away on whether the new objcg will
actually uncharge.

mem_cgroup_migrate() currently trades the charge, but that won't work
if the new objcg is root and won't uncharge. So we have to settle it
right then and there.

This?

@@ -5319,6 +5319,46 @@ void __mem_cgroup_uncharge_folios(struct folio_batch *folios)
 		uncharge_batch(&ug);
 }
 
+/*
+ * An LRU folio must hold the objcg belonging to its own node.
+ *
+ * memcg_reparent_objcgs() reparents a dying cgroup one node at a time:
+ * the folios on that node's LRU lists move to the parent and that
+ * node's objcg is redirected to the parent, atomically under the
+ * node's lru_lock. folio_lruvec_lock() relies on this to provide a
+ * stable folio<->lruvec binding. If a folio holds another node's
+ * objcg, its list membership and its lruvec resolution change in
+ * separate lock sections, and an LRU operation in between can re-add
+ * the folio to, and strand it on, the LRU list of a dead memcg.
+ *
+ * So when migration transfers the memcg state to a folio on another
+ * node, re-derive the objcg for the destination node. If the memcg is
+ * dying and the destination node has already been reparented, the
+ * lookup walks up to the nearest live ancestor - which is also where
+ * that node's LRU lists went.
+ *
+ * Returns the objcg to commit to @new, with a reference for the caller.
+ */
+static struct obj_cgroup *get_migration_objcg(struct folio *old, struct folio *new)
+{
+	struct obj_cgroup *old_objcg, *new_objcg;
+	int new_nid = folio_nid(new);
+
+	old_objcg = get_obj_cgroup_from_folio(old);
+
+	if (folio_nid(old) == new_nid)
+		return old_objcg;
+
+	rcu_read_lock();
+	new_objcg = __get_obj_cgroup_from_memcg(obj_cgroup_memcg(old_objcg),
+						new_nid);
+	rcu_read_unlock();
+
+	obj_cgroup_put(old_objcg);
+
+	return new_objcg;
+}
+
 /**
  * mem_cgroup_replace_folio - Charge a folio's replacement.
  * @old: Currently circulating folio.
@@ -5347,21 +5387,27 @@ void mem_cgroup_replace_folio(struct folio *old, struct folio *new)
 	if (folio_memcg_charged(new))
 		return;
 
-	objcg = folio_objcg(old);
-	VM_WARN_ON_ONCE_FOLIO(!objcg, old);
-	if (!objcg)
+	VM_WARN_ON_ONCE_FOLIO(!folio_objcg(old), old);
+	if (!folio_objcg(old))
 		return;
 
+	objcg = get_migration_objcg(old, new);
+
 	rcu_read_lock();
 	memcg = obj_cgroup_memcg(objcg);
-	/* Force-charge the new page. The old one will be freed soon */
+	/*
+	 * Force-charge the new page. The old one will be freed soon.
+	 *
+	 * The rootness of the committed objcg decides whether the final
+	 * uncharge of @new goes through the page counters (see
+	 * uncharge_folio()); charge them only if the uncharge will.
+	 */
 	if (!obj_cgroup_is_root(objcg)) {
 		page_counter_charge(&memcg->memory, nr_pages);
 		if (do_memsw_account())
 			page_counter_charge(&memcg->memsw, nr_pages);
 	}
 
-	obj_cgroup_get(objcg);
 	commit_charge(new, objcg);
 	memcg1_commit_charge(new, memcg);
 	rcu_read_unlock();
@@ -5373,14 +5419,15 @@ void mem_cgroup_replace_folio(struct folio *old, struct folio *new)
  * @new: Replacement folio.
  *
  * Transfer the memcg data from the old folio to the new folio for migration.
- * The old folio's data info will be cleared. Note that the memory counters
- * will remain unchanged throughout the process.
+ * The old folio's data info will be cleared. The memory counters remain
+ * unchanged, unless the charge moves out of a fully reparented ancestry
+ * and has to be settled (see below).
  *
  * Both folios must be locked, @new->mapping must be set up.
  */
 void mem_cgroup_migrate(struct folio *old, struct folio *new)
 {
-	struct obj_cgroup *objcg;
+	struct obj_cgroup *objcg, *new_objcg;
 
 	VM_BUG_ON_FOLIO(!folio_test_locked(old), old);
 	VM_BUG_ON_FOLIO(!folio_test_locked(new), new);
@@ -5401,12 +5448,30 @@ void mem_cgroup_migrate(struct folio *old, struct folio *new)
 	if (!objcg)
 		return;
 
-	/* Transfer the charge and the objcg ref */
-	commit_charge(new, objcg);
+	new_objcg = get_migration_objcg(old, new);
+
+	/*
+	 * @old was charged through a non-root objcg, so its charge is in
+	 * the page counters. If the re-derivation walked up to the root
+	 * objcg - @old's entire ancestry is dying and already reparented
+	 * - the final uncharge of @new will skip the page counters (see
+	 * uncharge_folio()). Settle them now: this is @old's eventual
+	 * uncharge, moved up to the point where its charge record ends.
+	 */
+	if (obj_cgroup_is_root(new_objcg) && !obj_cgroup_is_root(objcg)) {
+		rcu_read_lock();
+		memcg_uncharge(obj_cgroup_memcg(objcg), folio_nr_pages(old));
+		rcu_read_unlock();
+	}
+
+	commit_charge(new, new_objcg);
 
 	/* Warning should never happen, so don't worry about refcount non-0 */
 	WARN_ON_ONCE(folio_unqueue_deferred_split(old));
 	old->memcg_data = 0;
+
+	/* @new holds its own reference now, drop @old's */
+	obj_cgroup_put(objcg);
 }
 
 DEFINE_STATIC_KEY_FALSE(memcg_sockets_enabled_key);

