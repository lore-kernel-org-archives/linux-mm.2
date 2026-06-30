Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D3DFDC43458
	for <linux-mm@archiver.kernel.org>; Tue, 30 Jun 2026 11:26:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C41356B00E1; Tue, 30 Jun 2026 07:26:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C18896B00E2; Tue, 30 Jun 2026 07:26:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B572A6B00E3; Tue, 30 Jun 2026 07:26:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 877406B00E1
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 07:26:38 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 016A21A045C
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 11:26:37 +0000 (UTC)
X-FDA: 84936351276.28.8F35AB6
Received: from out-184.mta0.migadu.com (out-184.mta0.migadu.com [91.218.175.184])
	by imf21.hostedemail.com (Postfix) with ESMTP id E7A4E1C0007
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 11:26:35 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="VAb/Ziqx";
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf21.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.184 as permitted sender) smtp.mailfrom=usama.arif@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782818796;
	b=cGh6ogX0XtsQKPluiuuGLrQJJXp1N6T07xlzqwpFFvWAF+uT9arMLqWPCGZ3QW98wQ8fBs
	mSZb48HQUhkV9maa7vHwwfgtjd34w7UOe+CnH+pwIzzLswTllgu7FcC7dAmLeMWmYCVNJS
	pTR9y13F5VuqNMek7rBQ9vBx+2TxJSA=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782818796;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3Mj2gt/hTNZzbuZtdAFTmoZ+udDIFe1awW9U5cT+0b8=;
	b=Lf0AY6eEPNu0l7y6IcAYziazmkoaBAxBmW0s0eE9UwoJA7PE/ggy5FH14rG0moTA3bLPV9
	1DG7GlCvd8z9yWan0VIwiXQR8rsdbvccHuWrdF+E9vszJpu5JtgK747KfE6X+Lb2bZss+R
	GgnbabDmJ6D2961wH8CcySZnI1zK4HE=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="VAb/Ziqx";
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf21.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.184 as permitted sender) smtp.mailfrom=usama.arif@linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1782818794;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=3Mj2gt/hTNZzbuZtdAFTmoZ+udDIFe1awW9U5cT+0b8=;
	b=VAb/ZiqxxeVFuLbXWM9H86MbL2OFoE0FsfHmvhx16AaZQq2rgYfCswak+teC/ZAgzKpTGY
	OZDEY5vQd8RaNzNzK//bN49H4MRDPMwAmQl1SYnDOoVic5i1ms+ZB9fziGv5iXzNoa1RyF
	jNi59nVMZQ+T3Me4Z+FxLP9To3LQInU=
From: Usama Arif <usama.arif@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>,
	david@kernel.org,
	linux-mm@kvack.org
Cc: hannes@cmpxchg.org,
	tj@kernel.org,
	mkoutny@suse.com,
	shakeel.butt@linux.dev,
	roman.gushchin@linux.dev,
	liam@infradead.org,
	linux-kernel@vger.kernel.org,
	ljs@kernel.org,
	mhocko@suse.com,
	rppt@kernel.org,
	surenb@google.com,
	vbabka@kernel.org,
	kernel-team@meta.com,
	Usama Arif <usama.arif@linux.dev>
Subject: [PATCH v3 1/2] mm/vmpressure: skip tree=true accounting on cgroup v2
Date: Tue, 30 Jun 2026 04:23:32 -0700
Message-ID: <20260630112617.1198623-2-usama.arif@linux.dev>
In-Reply-To: <20260630112617.1198623-1-usama.arif@linux.dev>
References: <20260630112617.1198623-1-usama.arif@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: E7A4E1C0007
X-Rspam-User: 
X-Stat-Signature: s13c86mfijbhpsoe8f1mqzo6fxn7dcw3
X-HE-Tag: 1782818795-74511
X-HE-Meta: U2FsdGVkX194DU4qHtsq7mTrcL9/+6KPZM18mbLyi6Qf1rAay4xh/MOs36C05Dwhw6Q3PrJ8pE8ywjgCAz+07c3o9iSOfzc+rIjImbdQkDob0laTgrGH1NpAQ3pYCf76S/7g0ZWuPnhPeBRicq1uwDR1rVAEX29fZ9y5KBd1AnK15mJ7ryXgj1TeAeMII60HzzYUy0MwO9Cngl7Rs99jzMC5qtOsiJikS7yl9ztoamArSPZ+ip7KSFjDupHcO/K6ocxhCdB141THj/jAeSti2r+XPtPyopOkfvWsVmxc4uaypeVL+fNs8dU9obGnPnqfssMxbjZpEJrzQy4b87fFCVH13l9H2QZX4C7vVh6Jh4M+mELRYKEQOzHwMgCD+AfteJ2jWlLIvWgabrsFOJZVPStnF4sg9j6KckRs2ycYZc+fS61xEOhrtdOumtdhwU3vTGWz71hE0tCWIM6Bffdb88r2ZZQasDiEYZR7jbAMu3bwpBb7sKE2f7PMpME+mmLecX3TZrauHgxhkE2PMe/VBlEV6mnAnKh2cNNluCGcSC0pAqSLwm/Qob6/oMWA9fXaPFPiwsoxsDdsCVzAKQ2aKWBtWmBJeUzestXLxBKhMkz7o0TaYVG+NiikwRkMyxTsVr6diSYEWrzntHBU57GiJ1mptIom62gLmhirQLWB0U5cH8yh2MlR2+8EfbDRJF8HrKu2xe+1Nc5SvEJe4fkEUNiZ9tkJNix59WYhO/55Lqo77FtWavcS/TqXyYtJHRE5zCmqF0zkNG1IWvGRBxUDc80jaF4qsaKJQ0NtNIv+8f82QI7Ukq+x8U1CeS/1l1JQfnt6ElUcV/aTOVOKfdeeOxV1VbGDy2dccZ/SCqTUAXei9E2H5DdLlIfGaR5rQIXtm092oRfuh2I9UbcFXPz9HPoRV8+MNEmu6rQAguRrvdqdzQYZDwNjTr/JLAgBVJsV1Jn5m59HebO+7NfZnYB
 Lt1G3dP0
 Rg5KG2qf7+NmbUwJkJCohNVTbuKKjB5NTz+SVO9neYG+hBZaUSTVeqiJ4bxYoePCiJfhm0paMQVasYzI81D/hjgs4eOhiglh5PA5e2pCV/2bJCQqxLYaFAnQQyWf5DXUGpLQ9Ij1rzlOTIdWiJ7zBeXIMjVSImG0wlqLkKc1mO8aTjrkhC1yEi194WClvHMdp+Obcjm0OBFs42ZY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

vmpressure() has two outputs gated by the @tree argument:

  @tree=false drives in-kernel socket pressure (mem_cgroup_set_
              socket_pressure), consumed by TCP/SCTP. This only
              applies on cgroup v2; on v1 socket memory is charged
              separately via tcpmem and the consumer reads
              memcg->tcpmem_pressure instead.

  @tree=true  drives userspace eventfd notifications via the v1
              memory.pressure_level / cgroup.event_control interface.
              v2 has no equivalent: userspace gets reclaim signals
              through memory.pressure (PSI), which does not touch
              vmpressure.

The existing early return covered v1 + @tree=false. The symmetric
v2 + @tree=true case was falling through and doing the full lock /
accumulate / schedule_work / parent-walk dance for an events list
that can never be populated. bpftrace on a 176-core production host
(cgroup v2, CONFIG_MEMCG_V1=n, 285 memcgs, sustained reclaim) showed
~16,200 @tree=true vmpressure() calls per minute. Add an early return
that skips cgroup v2 + tree = true which avoids us doing all this work.
On a v2-only host this also eliminates a lock contention path that can
serialise reclaimers on a single global sr_lock.

Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
Signed-off-by: Usama Arif <usama.arif@linux.dev>
---
 mm/vmpressure.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/mm/vmpressure.c b/mm/vmpressure.c
index f053554e5826..c82cee1ab43b 100644
--- a/mm/vmpressure.c
+++ b/mm/vmpressure.c
@@ -246,11 +246,13 @@ void vmpressure(gfp_t gfp, int order, struct mem_cgroup *memcg, bool tree,
 		return;
 
 	/*
-	 * The in-kernel users only care about the reclaim efficiency
-	 * for this @memcg rather than the whole subtree, and there
-	 * isn't and won't be any in-kernel user in a legacy cgroup.
+	 * Only two combinations have a consumer:
+	 *   cgroup v2 + tree=false -> in-kernel socket pressure
+	 *   cgroup v1 + tree=true  -> userspace eventfds (memory.pressure_level)
+	 * Skip the other two: nothing consumes the result.
 	 */
-	if (!cgroup_subsys_on_dfl(memory_cgrp_subsys) && !tree)
+	if ((!cgroup_subsys_on_dfl(memory_cgrp_subsys) && !tree) ||
+	    (cgroup_subsys_on_dfl(memory_cgrp_subsys) && tree))
 		return;
 
 	vmpr = memcg_to_vmpressure(memcg);
-- 
2.53.0-Meta


