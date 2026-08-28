Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A659FC61DBD
	for <linux-mm@archiver.kernel.org>; Fri, 28 Aug 2026 13:46:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AD4BB6B0099; Fri, 28 Aug 2026 09:46:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A11BD6B009B; Fri, 28 Aug 2026 09:46:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8B2E16B009D; Fri, 28 Aug 2026 09:46:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 59E9C6B0099
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 09:46:43 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 46BF61603B3
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 13:46:42 +0000 (UTC)
X-FDA: 85150803444.15.73D637B
Received: from shelob.surriel.com (shelob.surriel.com [96.67.55.147])
	by imf25.hostedemail.com (Postfix) with ESMTP id A85B9A0002
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 13:46:39 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b="NnZNH0 /";
	spf=pass (imf25.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com;
	dmarc=pass (policy=quarantine) header.from=surriel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787924800;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9TfgXIoukN/RPVFm1I+e7bggSQFoinJyk03xgumztOQ=;
	b=QOJiP5qi64ALJEgNbSXARLBfmRDQ5SW8z8PKPKJ6eejGsb59K+wIIvbiyyd/Xi1/r3n1XW
	KDmixOuO3krszkRqGgRMvuKI2lkAehyD3skxAEGoTFW5BceTjMgRpP7OG6e2IgUl2U61oO
	cHLmaMVxDuTFk4wCe7s12uuxusKvmH8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787924800;
	b=JSz5ZtTh9/foNENj0QWJRqrzWITErhLQzmBisQHmrF5Qt6JojqBjen18M3xmz+E5BKVjyY
	zZpZvTnzwod947paZJfRmhHq0xHJASw85jIw1V3aay0zpgJVxkBW+XAhvPz3EwzX08/9y4
	NIydyavAPMBK1C3DYO0gfREoN9lbnKQ=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b="NnZNH0 /";
	spf=pass (imf25.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com;
	dmarc=pass (policy=quarantine) header.from=surriel.com
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=surriel.com
	; s=mail; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID; bh=9TfgXIoukN/RPVFm1I+e7bggSQFoinJyk03xgumztOQ=; b=NnZNH0
	/Kz1ZEAaFeSw5eQJXsW2aeU6YbzoXE+iOLimV0vZZtb1oVYNMYEUZCo8JMBjKpMZ5yH3S+fV7vcOO
	qKk461zeTFImkVEIeTIpUS67b/cbPvv3oafPXwDHdNEvexeCxV7yIC+3LB96cKgC5sPzpJRSvRdbh
	010F/tSvQC0fN4cxlXGclzSXZr30Ef+qTdbZ8anTTk9OJG99VpeaZlkMMnKqTjBwdyzPVONjx6mDP
	Em0DOkkIWD5/vDbr5QmPWTt8vECuVzUT9VG1tCybO8bgQ4lmCMr3+GuPwOzV4reJwTTlSiEurXxNN
	xGPVYZIIcqD5gp6WYwvyp/Ai+onA==;
Received: from [2601:18c:8100:a0e0:5a47:caff:fe78:8708] (helo=fangorn.surriel.com)
	by shelob.surriel.com with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
	(Exim 4.99.5)
	(envelope-from <riel@surriel.com>)
	id 1wzwuY-00000008zmT-0utG;
	Fri, 28 Aug 2026 13:46:26 +0000
From: Rik van Riel <riel@surriel.com>
To: linux-kernel@vger.kernel.org
Cc: Rik van Riel <riel@surriel.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	kernel-team@meta.com,
	stable@vger.kernel.org
Subject: [PATCH] mm/memcontrol: avoid stuck FLUSHING_CACHED_CHARGE bit on isolated cpus
Date: Fri, 28 Aug 2026 09:46:21 -0400
Message-ID: <a611f2bc40d30f9c14a6f41b173185975c46a203.1787890328.git.riel@surriel.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <cover.1787890328.git.riel@surriel.com>
References: <cover.1787890328.git.riel@surriel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: A85B9A0002
X-Stat-Signature: zg3ch47oxz9fwfu1xw3fyyyimxwj8kn4
X-HE-Tag: 1787924799-834776
X-HE-Meta: U2FsdGVkX19Zfv4JSA2cwlwAO9Bqg0hnFjWGYl0pYvK9u8wYE97RBH43eqAFWjcXftNBRHhy+iCc0SQdJ9u/B+tDf48w3BLP7aJzd89CUqzSASpbnZMgnDE0/mWvu8lJrugThcVnBIauOD+kQ7e7sgOAjdrvUp0cT/vGEbmpvbgJATKtOdhaiGCkNuy+FycJHg7Dizupzvw3hTFcxZS2koF/GLIMOeLvLR0lk91yscrRVC0thCUcwkecc629Rsl8UMm3lQxKWr61U5CwCjR4elt3yZZ2lk572Hd2FJ4UoQlo8EtSxv/JpUnQfPr3Pj6viC9M30FUwRTT/acsbMF+QwW30EurIUNUgJN+GTVXeBb83Ne0QkCxqZkk0hBDYsF8zeIPxVG5pxz+WJNSP0gGF9xRI+0lgjJG3UQThuPuMAqPqsHuflbV5MLrb3OONaETE92WRIZ4NayYkxLIsUj3EHVDSl8NTgT0ac1XG/72R97oHyhPJNAm6OxHcHhdkcWcwHEaPTIkAsZulBIjWRCHhS9/y5BH1lB3qJ/ZXbwFd4qmKRIF7Hd7wNRu26BcGT2i+EzyUiCtA8yFw4cfNMICcY7mtWuqzOJEr0rbDNGwoMKqDlbbHJkuuvEXJKaXPnGzcBl0Ri5kB9dXnGT0ao6YOw1q+bnbIQFawftv90Ve0COn1D0jnuRWcxAj1a1RnC1qpvFO5HTw1EFkB4/d7p9ApywFrcbKSA7VTnIfPlp3hqS3FhczHm/Crn38zhYztGIw5GY4D6JwickUjnwYur0rR4MHTzNEIVaQ0GGpOaWA2ISfxBxRRAXxzws3BBw40ztY4TD/nZQcsSNrzY1csOKNhJJdG/Oc4yPUE/QyLxfyWTwS+Y88KkXWPYHYPMMse8AM6cRPZJ74app9WJl9qQsBHZCn+cEbddRO5CESrjHaQfR7QXcx8OoT5sEwjEr+DAWsCC/NR4Zx6nOckIlbodZ
 4zgVpppB
 QVWUd11tgnWVCaMTTcJXzjhlqxVQowxYiUrUpNDtsQcyby1Q2mFNZw2WXzWKEZ8cAN6XE5uDIeq+urXzXp4LMZLq4z+FOWi/bimXAre3Cp3opF3Cw7Clx/eMF4wHDxtbgyDZP/3CKDLad49acK/ZrUUo6qcbPpj606gwINc1LmnXdZgR7/wgd22/0UVMgXPpWhDc8ZNNltO4F2A1vKWL4Ss0WjAfgwO2iQKHHxkZI8dOL5Pvo9aaHv1R94dY8yh14Nw5IOShbQJwr8Hgi/qYKpzayKQdoolEo3SbpJiTJ18GoZf4vNdtVTCRc4tgdJKHnFTGAxcFymFy7y/fnjY3gVELBlZShwUFoVi7+x/J/eqb4EMl3UCTCXvcKBBI/xwA1MCg+5OPFu1Vj2pI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

drain_all_stock() can leave FLUSHING_CACHED_CHARGE set after the
work is dropped.  It sets the bit before checking isolation and
schedule_drain_work() checks isolation and queues in a separate RCU
critical section, so housekeeping_update()'s synchronize_rcu() can
race the second check.

drain_local_stock() only clears the bit for work that ran, so the bit
remains set and the stock is never drained again.

Reorganize the drain_all_stock() loop, reducing nesting, splitting
out local vs remote cpu handling, and skipping everything on isolated
cpus, which solves the stuck FLUSHING_CACHED_CHARGE flag.

Fixes: 6a792697a53a ("memcg: do not drain charge pcp caches on remote isolated cpus")
Cc: stable@vger.kernel.org
Assisted-by: Hermes:muse-spark-1.2
Signed-off-by: Rik van Riel <riel@surriel.com>

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index a660ea0f820b..b0d8ec042d48 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2330,19 +2330,6 @@ static bool obj_stock_should_drain(struct obj_stock_pcp *stock,
 	return true;
 }
 
-static void schedule_drain_work(int cpu, struct work_struct *work)
-{
-	/*
-	 * Protect housekeeping cpumask read and work enqueue together
-	 * in the same RCU critical section so that later cpuset isolated
-	 * partition update only need to wait for an RCU GP and flush the
-	 * pending work on newly isolated CPUs.
-	 */
-	guard(rcu)();
-	if (!cpu_is_isolated(cpu))
-		queue_work_on(cpu, memcg_wq, work);
-}
-
 /*
  * Drains all per-CPU charge caches for given root_memcg resp. subtree
  * of the hierarchy under it.
@@ -2366,19 +2353,23 @@ void drain_all_stock(struct mem_cgroup *root_memcg)
 		struct memcg_stock_pcp *memcg_st = &per_cpu(memcg_stock, cpu);
 		struct obj_stock_pcp *obj_st = &per_cpu(obj_stock, cpu);
 
-		if (memcg_stock_should_drain(memcg_st, root_memcg)) {
-			if (cpu == curcpu)
+		if (cpu == curcpu) {
+			if (memcg_stock_should_drain(memcg_st, root_memcg))
 				drain_local_memcg_stock(&memcg_st->work);
-			else
-				schedule_drain_work(cpu, &memcg_st->work);
-		}
-
-		if (obj_stock_should_drain(obj_st, root_memcg)) {
-			if (cpu == curcpu)
+			if (obj_stock_should_drain(obj_st, root_memcg))
 				drain_local_obj_stock(&obj_st->work);
-			else
-				schedule_drain_work(cpu, &obj_st->work);
+			continue;
 		}
+
+		/* Pairs with RCU barrier in housekeeping_update(). */
+		guard(rcu)();
+		if (cpu_is_isolated(cpu))
+			continue;
+
+		if (memcg_stock_should_drain(memcg_st, root_memcg))
+			queue_work_on(cpu, memcg_wq, &memcg_st->work);
+		if (obj_stock_should_drain(obj_st, root_memcg))
+			queue_work_on(cpu, memcg_wq, &obj_st->work);
 	}
 	migrate_enable();
 	mutex_unlock(&percpu_charge_mutex);

