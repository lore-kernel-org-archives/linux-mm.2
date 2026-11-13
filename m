Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9118A606A881
	for <linux-mm@archiver.kernel.org>; Fri, 13 Nov 2026 22:06:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=zpSa1ylf
Received: by kanga.kvack.org (Postfix)
	id DB3DA6B05B4; Fri, 13 Nov 2026 17:05:53 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D91896B05B6; Fri, 13 Nov 2026 17:05:53 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C72466B05B4; Fri, 13 Nov 2026 17:05:53 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 91C766B05B4
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 17:05:53 -0500 (EST)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id EA312C014B
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 22:05:52 +0000 (UTC)
X-FDA: 85431478944.29.6E89665
Received: from mail-yw1-f179.google.com (mail-yw1-f179.google.com [209.85.128.179])
	by imf21.hostedemail.com (Postfix) with ESMTP id 169E01C000E
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 22:05:50 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=zpSa1ylf;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf21.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.128.179 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794607551;
	b=8cElegF6auGzSZhj6imUxVmuFHzBBPaTNkPhmO4b0COpbPxuTNSxjvjMCNdzF0PcWyOnLl
	QwLYXy3zuRlznb4Behv5wKOHxvHu6YA5Azpq3O8sQNxiOOKQ85aI7YtvTJwqoLx5WBlBPQ
	8tVNyO12DnCFWWZwO6PsFns5to2UB78=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794607551;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RjswVOHO5sVxrAeAWnMLkts0RZq5oWih+6CZ1AINTug=;
	b=PWi1PsEFmJiDL/BW69ZnFk2zV/ZDZh/6dC9c7SBZoZqWoodH8vELvA8LC0zVTUSbstjEaD
	T44IuYbGvTxTGClR2Ur4RlF53U6nmzXQ/Ycp70QNtFhnvw8o+IXRSMranfbOgohFbC+0cp
	roBj4RJCPOrGcQD0qljUJB6vwzemVV0=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=zpSa1ylf;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf21.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.128.179 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com
Received: by mail-yw1-f179.google.com with SMTP id 00721157ae682-8b331cad3cfso12008347b3.1
        for <linux-mm@kvack.org>; Fri, 13 Nov 2026 14:05:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794607550; x=1795212350; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=RjswVOHO5sVxrAeAWnMLkts0RZq5oWih+6CZ1AINTug=;
        b=zpSa1ylfGkgpr3rKUxWbVmzmMrP3uEATDhcfJYEJ6tTht3PRKvugP6fqICI61zvwr8
         rUlLI5hfrhDPhpbOLO7cEqyKkss37zHG0JKJNMYUvn+uxkJbQ2zPuDLm058KD7fFu02H
         W91JcNSUZtPJrrn0S+wDP2Pysjx2kHw4Lg69+HDw2cO9ibdwCqVbglPvtCF1fYr/tbU7
         jiqskEXEEOF7AdtAvtlmo8n7ARlr1vR/k7ICqa8l1p6bm0LdsCTrpr9r2pCp/IJk2D4+
         5kO98ewUM2D90/i1Ju1y8LLKHpyOGgdB75rUmi1zsNmz6HIWjkIHeTThQps+OQG2E+SE
         zACA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794607550; x=1795212350;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=RjswVOHO5sVxrAeAWnMLkts0RZq5oWih+6CZ1AINTug=;
        b=O3MPp0inkfywPYCyu8n4ZbtwxknQ/J8prsbqySuufJJDmOVeXz3WC1+BGZJiBxKRd6
         aNuRR6a5dKcm9t0yt1Pw0ys119I8aTFgDld9Sl3zB1wI65wc7/CDqEjY04pC8ETGkxKc
         Htz5UpPD0KieQ4uytgLPNbFQsUbhE0QFE0K9tgRAc0RZRimuYznRxK+gOfUPNg8bHsuF
         WnQuJ7qHjhm4T1AW9BLZJcyaLER5xu6Ue20QxYEz6ahaHAtaHbXQ5/+LUFTyw/zibWca
         +1iBS9QN/L4cAu4ZhKBvFZ7x6V0mJqp5kIjxUzFPxdkpZaQlxJ7U2kIsSe6/vGr6DxBn
         go7g==
X-Forwarded-Encrypted: i=1; AL+hErEIjTC08RzScCgHpePypQ/wvFP8yBCflW2FX4BrcnJqUCsq2d9oGGjKXtX6TmTMrmycaM8bzu67Cg==@kvack.org
X-Gm-Message-State: APuU4Z9SDkTEjPkh8pepfJAMeXBSb9WYOjMh53gzraBQTNDoyHfNBGvj
	QhA9wsBAP9K8XNe0qeJ+nHo7rJozmunF0IrlfSS1FOHbJNkbCPPOe0B9
X-Gm-Gg: AYBFou0Qm01nd4bHd88FcVGmw67b/5/kEqzxQ9FZTwsMMaognCisjdvKj2KTYxE5d5T
	q/mRleel2SXjTfDnTblCbaWnWEAVzfnDX4Aap9wk3KIgos/lmHCTMPHqQlSFsPZ2t6ucQo22Qs+
	DN1Qgzgvy81N6MyBnjeJwsIrs/emFcBbhVrCEoPM2LRjKiSKGrdQqfkUYRRNQ9CnIENiWUmax4q
	hiY524jkYf43d/FAQ3oMtAzSnbz+SRreYeg0MCGZJAb55YQFMhSwSSLOKaikimjwT/s90r5h1g/
	Ba4We+Kxx7SzhwiJjbnjvUxMIyVM+pacP3yqtHWFIbBOvUNlVf6DvhTEletlqN2yJdjLNxzoZ/5
	MnDk41toQJuW8n4JYX4NLE3HFpTyUK36qIPRdZ+KVrp4f+yyNHZN1NV4P9O/RQqHAajelio4qpd
	arWQhN/ROSQpTGxKym83EFEzh+EZ5DqFmE+GRTaYOpxdyTFYbAbyZafklmqlV7JVC8aHd1Odnx/
	h25ouIOGIpeX6HMTQNgwEBWIcWXdamcXzkye7+nJuH9JTFGI4x/I3uQnUiFKrX+tJdeD7Q8a/R+
	vgubxNCzU1TmacKGR9lyDabYolUSvSiN48gCDPl/n9cAfpztGxXVfPSsgbXk/bbqyBiZZPC6SV1
	rVFpQBqU=
X-Received: by 2002:a05:690c:c6c2:b0:8b3:2d97:b8d4 with SMTP id 00721157ae682-8b4aa37bf16mr19608777b3.49.1794607549317;
        Fri, 13 Nov 2026 14:05:49 -0800 (PST)
Received: from localhost ([2a03:2880:10ff:59::])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-8b4aa99f7a1sm30911297b3.29.2026.11.13.14.05.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Nov 2026 14:05:48 -0800 (PST)
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: Johannes Weiner <hannes@cmpxchg.org>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Michal Hocko <mhocko@kernel.org>,
	Michal Koutny <mkoutny@suse.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Harry Yoo <harry@kernel.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Maarten Lankhorst <dev@lankhorst.se>,
	Maxime Ripard <mripard@kernel.org>,
	Natalie Vock <nat@pixelcluster.dev>,
	Tejun Heo <tj@kernel.org>,
	Oscar Salvador <osalvador@suse.de>,
	Balbir Singh <balbirs@nvidia.com>,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	kernel-team@meta.com
Subject: [PATCH v9 4/7] mm/memcontrol: check PF_MEMALLOC after trying the limits
Date: Fri, 13 Nov 2026 14:05:31 -0800
Message-ID: <20261113220539.2275715-5-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.53.1
In-Reply-To: <20261113220539.2275715-1-joshua.hahnjy@gmail.com>
References: <20261113220539.2275715-1-joshua.hahnjy@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 169E01C000E
X-Rspamd-Server: rspam12
X-Stat-Signature: r9h8ybxsw1hu69crsk889s9786ts6y5i
X-Rspam-User:
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794607550-558066
X-HE-Meta: U2FsdGVkX19W2TGr3xWr+oGH4FOIkhgkyqjbzyHmi7Yi3cU9gu0qS40MYen/owhJM2zP6FWL2DrNZPGupNw8bY+MpAgEmgSM2hSBY6PiziwdcrLVDSokn96B5h4i2sEND0392VDTJyU8Z95gicTDZvZAzsqbpk3MgZfrSECa1Tq9wqMThsiozBLPyT2X56hPJ2ZpI52fUlfg9755QGPWUNPT7YXBnpXqUeKeRk5IWu/gF6pnvwmnb9lyUqABNR5a9SxfK99DCDAC42g6zZ3GVdTjWeXxAZSf3ALgaBw5vDTb6U1i/tXGJM9cCxNsG+jVmRAUFUKREW2Lsmb9dEPruJuBQq4PuftJFVIT8GvbRYg0EaVsVtCElcVjjyKWr/3DOOxSq2Uj5AvdMoJ98vbWg7KkYScXKJopB+WY0wyQn3PQTNQ878jw+faGvxSC4QiIu7tazExzgnT+gRvZvfMb/RwknMYhQGpMvV2CQi3uZ8/2TGVTRBbDOlQSkfyV38JwjWSLbW3yvymJCr4x9H8mpP6V31knUf529e5bI+5B/JlYPy2VnACk8rmWzC/0QR422TZVk5C54pElt/P0LG9BBJ+2tunnwStO3QL+9dMNyrSy23Dvy2RBFLmbwS9dP+F8tAqIo+G+KU7vj6dqpCm0tEEFiNcP61qGFvc5p6aIQFRMqK9KccWkKYEdGkMbgMUMIgF6MN4/R57D1E1UZPW1ig7fQzVrA/oMyCNRegZFjGd0vh+jG6MZfQGMaZpQO9sFkJ3TDX5dGgeJYJ4R8eW237v55iO2soh9BYen1kN2Kzqr3BaSUnbFy4eRsK9kWXN6SFUcJPdcYgDWmYsMaE+jfu/Dj+u4Op2uJ45eVGL8U8c3fcO7h+LD5uUzsMCPKR889D9QXkVKh+aJ2tkzhZ7uUwQKdG4mPBKqU8Uam7dTeA3WuBF846Or0PgmFWg3R3qxnQsVezUkSwaPDlbbd8l
 wGqOTsvo
 2hbMe8vZt6PM8ikZJFsK8hRQKVnuPzBUCI2zdodnn4KrDcCP9aztKzBioT6+eZ/yiqA2Fmu02XdjREmyRaCbHa4ZszuEUNPMUxFlzEx9FKP5CJzw7q9bglfJijMabhJkFy5NdYs6+LCmwrwa8/Wb8gYHmCb3lxhcEq2tckyzDGqXjcDezXZXcNHcUlE+OXjdBXbxdggBZT2jkhEOTVEkYqSM89kDUfaruDFzweMVE4mACZxfxpIZNRsUX8vtBFCZTQTbbnzbuSJKXVsH2v40SCpUSDUS+EqPpLD8nG3ImQonI7Tg8ez7oJXZY/BVfp2r0kOpAOQGcVAVGtGhr9go4Gu0wh5GJjPY1OmTmt3t5/bU9IqhYZHmEfTejAJZURxsq3sEvDaBC4kQvg57U484xayRkYSN0J3MDWB4xJF38eysl+TfAY86q8OTdnZr0FYzJ1ZUHExRy5nv4A20Gq5vog7qyFmg3Ptq5DWqmkEm251gZStLUq0Mz2eA2IHjp7wes0gKM6xujPHmcvslczlMzHqvp2OyoEXVzrP4hsSXfm8+1dBxeqlGv44ofTGRh+DIXH4t666EOp/naK4GeNO5T42+PopqNYmTPJEXY/8tH7CC6iXa7oAsQmXZwlQErAjfoJ+gLz1fY/2zEi2IoqUKFMVC21uBL0dZhSlbFr7KCVHN82SaUfOp7ZRaHpXPMtXdeJOetW+sPn9nesPQnG7ihtSSPArOyw0f81h+ddr18tKPr+zE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

PF_MEMALLOC charges are currently forced right after consume_stock(),
before trying the limits, so that they skip memory.high and the
high_work worker can't queue itself from its own reclaim.

A later patch in this series moves the memory stock into the page
counter, so that the stock is consumed inside page_counter_try_charge().
That leaves no place between consuming the stock and trying the limits
for the PF_MEMALLOC check.

Prepare for this by checking PF_MEMALLOC on both outcomes of the page
counter charge instead: skip memory.high on success, and force the
charge on failure. These charges still do not batch, so the resulting
usage is the same. The differences are that a PF_MEMALLOC charge that
hits a limit is counted in the cgroup-v1 failcnt again, and its
MEMCG_MAX event goes to the cgroup whose counter failed, as for any
other charge.

Suggested-by: Shakeel Butt <shakeel.butt@linux.dev>
Signed-off-by: Joshua Hahn <joshua.hahnjy@gmail.com>
---
 mm/memcontrol.c | 37 ++++++++++++++++++-------------------
 1 file changed, 18 insertions(+), 19 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 0e7500624b9e3..fe97b320b2589 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2795,23 +2795,8 @@ static int try_charge_memcg(struct mem_cgroup *memcg, gfp_t gfp_mask,
 	if (consume_stock(memcg, nr_pages))
 		return ret;
 
-	/*
-	 * Reclaim may need memory to free memory. Let it go over the
-	 * limits for a while rather than fail or OOM kill. Doing this
-	 * before trying the limits also skips memory.high, so the
-	 * high_work worker can't queue itself from its own reclaim.
-	 */
-	if (unlikely(current->flags & PF_MEMALLOC)) {
-		/* Find the cgroup this charge puts over its limit, if any. */
-		for (mem_over_limit = memcg; mem_over_limit;
-		     mem_over_limit = parent_mem_cgroup(mem_over_limit))
-			if (mem_cgroup_margin(mem_over_limit) < nr_pages)
-				break;
-		goto force;
-	}
-
-	if (!allow_spinning)
-		/* Avoid the refill and flush of the older stock */
+	/* Charges from reclaim or non-spinning contexts don't batch. */
+	if (!allow_spinning || (current->flags & PF_MEMALLOC))
 		batch = nr_pages;
 
 	reclaim_options = MEMCG_RECLAIM_MAY_SWAP;
@@ -2836,6 +2821,13 @@ static int try_charge_memcg(struct mem_cgroup *memcg, gfp_t gfp_mask,
 		goto retry;
 	}
 
+	/*
+	 * Reclaim may need memory to free memory. Let it go over the
+	 * limits for a while rather than fail or OOM kill.
+	 */
+	if (unlikely(current->flags & PF_MEMALLOC))
+		goto force;
+
 	if (unlikely(task_in_memcg_oom(current)))
 		goto nomem;
 
@@ -2931,9 +2923,9 @@ static int try_charge_memcg(struct mem_cgroup *memcg, gfp_t gfp_mask,
 out:
 	/*
 	 * Don't forget to raise a MEMCG_MAX event for forced or rejected
-	 * requests. mem_over_limit is NULL if a PF_MEMALLOC charge fits.
+	 * requests.
 	 */
-	if (!raised_max_event && mem_over_limit)
+	if (!raised_max_event)
 		__memcg_memory_event(mem_over_limit, MEMCG_MAX, allow_spinning);
 
 	return ret;
@@ -2942,6 +2934,13 @@ static int try_charge_memcg(struct mem_cgroup *memcg, gfp_t gfp_mask,
 	if (batch > nr_pages)
 		refill_stock(memcg, batch - nr_pages);
 
+	/*
+	 * Skip memory.high for charges from reclaim, so the high_work
+	 * worker can't queue itself from its own reclaim.
+	 */
+	if (unlikely(current->flags & PF_MEMALLOC))
+		return ret;
+
 	memcg_enforce_high(memcg, batch, gfp_mask);
 	return ret;
 }
-- 
2.53.1-Meta


