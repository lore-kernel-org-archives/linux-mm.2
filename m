Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 89157C61DB9
	for <linux-mm@archiver.kernel.org>; Fri, 28 Aug 2026 19:24:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7D0526B008A; Fri, 28 Aug 2026 15:24:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7A7C86B008C; Fri, 28 Aug 2026 15:24:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6E4D46B0092; Fri, 28 Aug 2026 15:24:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 48E0A6B008A
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 15:24:58 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id C337CA01CE
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 19:24:57 +0000 (UTC)
X-FDA: 85151655834.24.C97A0E7
Received: from mta0.migadu.com (out-224.mta0.migadu.com [91.218.175.224])
	by imf27.hostedemail.com (Postfix) with ESMTP id BA39140011
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 19:24:55 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=jQOflQML;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf27.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.224 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787945096;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=UJqifLmmFq4cxqSQosXu9tXcerQCm+U5Op/WyLQcj8Y=;
	b=1BsbvA2UhdNhZWu6L7PUmx3+XsGn4YP6kmpMSSzzjDZtQk3cxaN19su2763g+bFA3fEtSp
	Dt9WXEg8YC9BInx8ZgkjvfqVfuD43cUEL3LyUB7dJowr1ZWrDReMnl+GgRkjmPBT6PnnD2
	v2/Elg10MZhcSn5Jp4iUaQig/QPxOZU=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=jQOflQML;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf27.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.224 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787945096;
	b=pvQP4O/MX0IP1IAlFVmzCdi4q/jVnL7CKsFhfmcy3eB8YcnVQIo34ERD/iuyRgFbihbPy1
	tqeV/eqPfnTDLKJrfVk5WDFu6mTfT7VkqNONGFAMhes62aG0/qr9UqUq8ZZ8ADg0yTBEG1
	bxUJ7LhhMdRuMJILAtnwQGnLUQwOAlI=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=TfHpnzMcF+zAkZEjIfKiZONKrvtQEIIuCJ+9jCgmo5E=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787945094; v=1; x=1788549894;
 b=jQOflQMLLSXvF4RhH9T39JLmhIlr+hXTlgvUTmQqK2S39rimNS1UowlQOljTXHZMzi/sPe7n
 OIozzK5ugM07jT7eadhZMzgSJh08DgGksHzqOBMAnyKJkq+nZA+daUgC7WF0Q8NSHUlOyTcWQU2
 WLTuBKQHFbNLZutGsTUBuOf0=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 94f82fffaa8d6179;
	Fri, 28 Aug 2026 19:24:44 +0000
X-Mizu-Trace-ID: 94f82fffaa8d6179
X-Migadu-Flow: FLOW_OUT
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Rik van Riel <riel@surriel.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@suse.com>,
	Muchun Song <muchun.song@linux.dev>,
	Qi Zheng <qi.zheng@linux.dev>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Meta kernel team <kernel-team@meta.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Sashiko <sashiko-bot@kernel.org>
Subject: [PATCH] memcg: clear FLUSHING_CACHED_CHARGE on cpu offline
Date: Fri, 28 Aug 2026 12:24:19 -0700
Message-ID: <20260828192419.3057939-1-shakeel.butt@linux.dev>
X-Mailer: git-send-email 2.53.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: BA39140011
X-Stat-Signature: 5xkkcj7u9k5bpc4qscptd7mqdtqcdey4
X-Rspam-User: 
X-HE-Tag: 1787945095-834709
X-HE-Meta: U2FsdGVkX18IbrnsowWLdICqs45zJ/EsZdDIujXY7Mg2vnBTn81D3JvpRdaEoHoFtJHmeJNNuUOqfaV0n2yhKyBt+VLOaKMhN/77dXoWJisyPZ7ncUD8ioV1AtBRXI7DRx3n3zH9G64RBBIEHnRK/PGKSBFnXiIfIrg9mk6eSpXuhJsM6mG4RSaHzhqAPhGloa4/yRr4gDS4hA7VP5U0iFcoAKoYrZAZzwm8aND35KzATntfuqK2v7rQC0RSbtxVtYR1kSGnRYqf71FTV3UmqSMk8LAYcus0rkbZ//w5WQPjttLMhd9Iikbv7phhLafUmgHkP52VLPfa6T2RNqUrbBl08eaoHAZSbeDGIMVdBP41pjj4T9vY8ovmPYvm/3CNjDhscHcrJH4pbrZn6VDUthQwFLeNsJ18q7bkc7XwydxqClseK+cD8r4euyIhg1mvLDtL9JXm9Xw/mu3TTzT8gEbN//edBt8eENHgJlA3Mjq9EZF8qK5s/J4yhuKD3jARG3nq8yneL2TG7sLDW01LbgogC/wYAQJrpncUZMuhO/hbaH/KDPdrbfJ6SKax6GPD6bnnb7beP9OPhLffV6UUhjGpxRy6gMyAJDSEX+OOPSUfM/5bp8IgdMolYVGagEyoqG0CDGMv/sENgZzDM2ytb+JtFbZ5xMCNtELZ4h0tiIXfIZVSQ0Pk/buDescNAIGaYmyjY2B46nX2YBQQvUPGFxBsB55Rccr4hc65p+Fo5CdqIHv1tL+oFgZK/tddzRwa2vt3mWctdHeVHArD1g5Po4xTu0E2aOkw7E6yuCVj18AgTo758Hc2XY4dVCJ4X94uDSD0blCsJPIRU5px2NZuL5teKOS2rqLIPZw7MdpHdHPpQxBMusvHBUOBRPfs/Twb9jzfvLwqzvoU1glY1p68ZABNW7vUWYkn32VkU7aMwsa7hYxoMMSs6vI6AqnGMR0ZPKTrxLg+sGPmRB8A5Nf
 jW5cn2O8
 7wasrdR1FUVLJoRiUXm9fRzQZKve1ACj3LV7SKzafF7Zm+5NbsJ9oD4RXp9neiL9mSjVm4Y2v9vhOafp/+kd6Qx97bBEKQW0APc7cnu+VkDr2/0MDW79yOT/fnye0HpiuRFiAFskn0fM6Wz4DClsa+VkYUunxj1hvBWdrxQbQm0pqMd3pR+uTa1IAUcJicOFMq18DeVMZW5oJnoJN34dwUxHFnrgJ61fx02H9vF8LH1ZpvqwVveX3FC/k3TgP87z8IHKpg0iwFsNkpFeXAAV7ZY+B2gt7fVPkMHv2YVNG0yCmuQGqwtqQ2Hk7Btt5n3HO21iZi6/KhZGWsZUkbrsKVDXziPr3XAOk/FYQuX2+n46PKCg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Sashiko [1] reported that memcg_hotplug_cpu_dead() drains the stocks
of the CPU which went away but leaves FLUSHING_CACHED_CHARGE alone.

The flag can be set at that point: drain_all_stock() may have claimed
the stock and queued the drain work shortly before the CPU went down.
workqueue_offline_cpu() unbinds the per-cpu workers, so such a pending
work item is executed by an unbound worker on some other CPU, where
drain_local_memcg_stock() operates on this_cpu_ptr() and thus drains
and clears the flag of that other CPU instead.  Nothing clears the flag
of the dead CPU, so drain_all_stock() would skip its stock forever once
the CPU comes back online.

Clear the flag of both stocks after draining them.

Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
Reported-by: Sashiko <sashiko-bot@kernel.org>
Link: https://sashiko.dev/#/patchset/20260828135036.7d44361f%40fangorn [1]
---
 mm/memcontrol.c | 16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index e082aa68fa5c..872115c6b0f2 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2378,9 +2378,21 @@ void drain_all_stock(struct mem_cgroup *root_memcg)
 
 static int memcg_hotplug_cpu_dead(unsigned int cpu)
 {
+	struct memcg_stock_pcp *memcg_st = &per_cpu(memcg_stock, cpu);
+	struct obj_stock_pcp *obj_st = &per_cpu(obj_stock, cpu);
+
 	/* no need for the local lock */
-	drain_obj_stock(&per_cpu(obj_stock, cpu));
-	drain_stock_fully(&per_cpu(memcg_stock, cpu));
+	drain_obj_stock(obj_st);
+	drain_stock_fully(memcg_st);
+
+	/*
+	 * A drain work queued before the CPU went away is executed by an
+	 * unbound worker on some other CPU and clears that CPU's flag, so
+	 * clear the flags here to make these stocks drainable again once
+	 * the CPU comes back online.
+	 */
+	clear_bit(FLUSHING_CACHED_CHARGE, &memcg_st->flags);
+	clear_bit(FLUSHING_CACHED_CHARGE, &obj_st->flags);
 
 	return 0;
 }
-- 
2.53.0-Meta


