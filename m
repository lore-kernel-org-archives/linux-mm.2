Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D1761C61DC2
	for <linux-mm@archiver.kernel.org>; Thu, 27 Aug 2026 12:33:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A4BA16B0096; Thu, 27 Aug 2026 08:33:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A23B96B0098; Thu, 27 Aug 2026 08:33:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9608E6B009B; Thu, 27 Aug 2026 08:33:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 700D36B0096
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 08:33:24 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id E8C54A03EF
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 12:33:23 +0000 (UTC)
X-FDA: 85146989886.13.1E042F2
Received: from mailgw1.hygon.cn (unknown [101.204.27.37])
	by imf28.hostedemail.com (Postfix) with ESMTP id BA096C000B
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 12:33:21 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=hygon.cn;
	spf=pass (imf28.hostedemail.com: domain of wujianyong@hygon.cn designates 101.204.27.37 as permitted sender) smtp.mailfrom=wujianyong@hygon.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787834002;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=VNBgXdZfjSKQGP1Qiq4W7a8s8BgIkEG8pSVDPwbpdpA=;
	b=YDsRroxeS7U1edG0I8ZCd1Tu1aadbDJZape7XP3SRWz0nlKe3jbUb4gIbPKXokBabRG7x3
	4WpsPHUYSaBt+asRbVqKmNTTx8DXqkhRYN7CxcC86nnZBnEBIWz/aPggNNZieS8Ebz4YhP
	tI1K+tjvbLqpkqmFgSQ9+EfnVlTLjHk=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=hygon.cn;
	spf=pass (imf28.hostedemail.com: domain of wujianyong@hygon.cn designates 101.204.27.37 as permitted sender) smtp.mailfrom=wujianyong@hygon.cn
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787834002;
	b=Oh1oke813+4ySotMY74beCy3YSBvtomR7KFTqvr3EmB5EQT2dMdZtmv+ApaZN3N5sXMY2w
	JXPK3eju7drpCxOYgBnkoVh5KacDXPo+fMI+IhXEVkVvl++9u+fhb0Sd5EqOGtIN6Rq8dy
	++7u+5qi3If3wwA3zLoadX7j4rjtDog=
Received: from maildlp2.hygon.cn (unknown [127.0.0.1])
	by mailgw1.hygon.cn (Postfix) with ESMTP id 4hW1C30WBGzBJb6d;
	Thu, 27 Aug 2026 20:33:19 +0800 (CST)
Received: from maildlp2.hygon.cn (unknown [172.23.18.61])
	by mailgw1.hygon.cn (Postfix) with ESMTP id 4hW1C20vCjzBJb5x;
	Thu, 27 Aug 2026 20:33:18 +0800 (CST)
Received: from cncheex04.Hygon.cn (unknown [172.23.18.114])
	by maildlp2.hygon.cn (Postfix) with ESMTPS id E3EC036F1F84;
	Thu, 27 Aug 2026 20:29:35 +0800 (CST)
Received: from jianyong.hygon.cn (172.19.20.52) by cncheex04.Hygon.cn
 (172.23.18.114) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.36; Thu, 27 Aug
 2026 20:33:16 +0800
From: Jianyong Wu <wujianyong@hygon.cn>
To: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
	Juri Lelli <juri.lelli@redhat.com>, Vincent Guittot
	<vincent.guittot@linaro.org>, Chen Yu <yu.c.chen@intel.com>, Tim Chen
	<tim.c.chen@linux.intel.com>
CC: Dietmar Eggemann <dietmar.eggemann@arm.com>, Steven Rostedt
	<rostedt@goodmis.org>, Ben Segall <bsegall@google.com>, Mel Gorman
	<mgorman@suse.de>, Valentin Schneider <vschneid@redhat.com>, K Prateek Nayak
	<kprateek.nayak@amd.com>, Shrikanth Hegde <sshegde@linux.ibm.com>, Phil Auld
	<pauld@redhat.com>, Andrew Morton <akpm@linux-foundation.org>, David
 Hildenbrand <david@kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-mm@kvack.org>, <wujianyong@hygon.cn>, <jianyong.wu@outlook.com>,
	<zhongyuan@hygon.cn>, <huangsj@hygon.cn>, <wangfengyu@hygon.cn>,
	<yingzhiwei@hygon.cn>, <justin.he@arm.com>
Subject: [RFC PATCH v2 06/23] sched/topology: Add sd_node for the NODE sched domain
Date: Thu, 27 Aug 2026 20:27:59 +0800
Message-ID: <20260827122816.756234-7-wujianyong@hygon.cn>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260827122816.756234-1-wujianyong@hygon.cn>
References: <20260827122816.756234-1-wujianyong@hygon.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [172.19.20.52]
X-ClientProxiedBy: cncheex05.Hygon.cn (172.23.18.115) To cncheex04.Hygon.cn
 (172.23.18.114)
X-Stat-Signature: uiywz9qot74a5kxw1refd1eetbzqjr6i
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: BA096C000B
X-Rspam-User: 
X-HE-Tag: 1787834001-627178
X-HE-Meta: U2FsdGVkX18M9aLNpiXzxhDjRQH5qpWIU4VnsJIAYtJVWHYd6SVZ5jOXNYDAf+qenaMwHHisuApvO6Tm5wh7xaQAtkyfKpw/+eupyQ450ZP4VrXuuC4mYftVzLR+aTvhL6UWvFgW7yM4OYvOdVtZB+cE0Y0Z0uUJApF+xHuE2S3wLIJEoL8tA/J5zuQzuGCeehnnlZeiFyNezbJbnChgT+Q9paNIDGdNHF2cmfKxRRLDxKcVXVn/puHXbkFqXKZBNQcTixpp4AtSNjOcO3awBTTLptkAKvJw+uESTEnTkN0V/ELiQZ91sXxrZpOBpsj2Yg1iLNXdWfhEockaI86pvUSQ1PNEG/VnNIyrRzrkfPxairbQ8a9LLGAxcpLqO6wRuzGjt9ndDPx5TlnwE3z0YRT0Oj+XJTTSAY15/yJIjqbfWuWZILDnWLoYmq6ta1cjjCe6qlzfcjHdNrcNFJ+07M5HILH9y5Hv51Vpp/JxYZY5uviDMfXtCmDzItvHCup/Wv7+WFA8pf4KVX7P7vHN7AZmVLnFKgC1RmGZdYs5Rhds0/zsSriwUgHfJE6JCj8ib/6BWqWAyH18YGWs7H6458IACRzYp47vVJoLSLy8qr0bud8I0ibPWwHsy3fZyPXkYSHDCRIuZpTPfHA1xcbPdcqgI3dWxDaI3KVADSfT5nmqlqRd7uHIevCDJtb06TbsiM7lNwkTThziMoq/zhdbKSO4NNGf6sIZL/Y5m9F630CP0umEeMi7300VWfPfpS6BJ337r7zUMzsQ/STeIRKaTCTwy9SvNPkOkloYaFAoCXOaSgeE2Bskfkn/fJcmdJl/aS7lVZBAFFyH52HuEyJOQ1ojqvqKBGnSjDscMGnRN0w4rn974xLgqohgT023M7jPbi/jJfDDBmngY5cFlpbR8eqLNqJShtCou2Ykq0uIPHZTnmeSTJJBSVWjmYEbLsj/Kn1931MljWy0D8Ya1rR
 awqtME9A
 qREN9nA1gqUjBFjIjA3GcKGdGz94m1sjD9gSkX1lBMACwTje7Z1w2AmIU7RWRVmCMA0sMs0w9XFasX1VZp98FrESTuaulQ1+9QO9HhO60Y90b12e1sKKrrvKK30K+BKFj0X/lDfQg4O6rRZQHhai6/0zlrUHQFJYG69dat4tcHJx3gUGRC0exNi1f3YJnCXXFXtsmDig0nAjc256KQuQiuOqf+yxIc5fV73Mo0Xufcd/Y9xnlDRRayI/lNpQXOZ4viezAU9VKsuoMCmsSwN82cG67TbSyqElFlW7WrRTxGyOZ1KOarDrb9GpXMiFPouFxzpmPvjed0QNOm+QJ3Ti/fGKGdQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

There is no straightforward way to retrieve the NODE-level sched domain,
which will be used in subsequent patches. To simplify this, add a per-CPU
variable `sd_node` for convenience.

Signed-off-by: Jianyong Wu <wujianyong@hygon.cn>
---
 kernel/sched/sched.h    |  1 +
 kernel/sched/topology.c | 17 +++++++++++++++++
 2 files changed, 18 insertions(+)

diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index 38453a78c885..3d3f1d40a672 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -2197,6 +2197,7 @@ DECLARE_PER_CPU(int, sd_llc_id);
 DECLARE_PER_CPU(int, sd_share_id);
 DECLARE_PER_CPU(struct sched_domain_shared __rcu *, sd_llc_shared);
 DECLARE_PER_CPU(struct sched_domain_shared __rcu *, sd_balance_shared);
+DECLARE_PER_CPU(struct sched_domain __rcu *, sd_node);
 DECLARE_PER_CPU(struct sched_domain __rcu *, sd_numa);
 DECLARE_PER_CPU(struct sched_domain __rcu *, sd_asym_packing);
 DECLARE_PER_CPU(struct sched_domain __rcu *, sd_asym_cpucapacity);
diff --git a/kernel/sched/topology.c b/kernel/sched/topology.c
index eaaca6c9a805..46ae1f94e9f5 100644
--- a/kernel/sched/topology.c
+++ b/kernel/sched/topology.c
@@ -679,6 +679,7 @@ DEFINE_PER_CPU(int, sd_llc_id) = -1;
 DEFINE_PER_CPU(int, sd_share_id);
 DEFINE_PER_CPU(struct sched_domain_shared __rcu *, sd_llc_shared);
 DEFINE_PER_CPU(struct sched_domain_shared __rcu *, sd_balance_shared);
+DEFINE_PER_CPU(struct sched_domain __rcu *, sd_node);
 DEFINE_PER_CPU(struct sched_domain __rcu *, sd_numa);
 DEFINE_PER_CPU(struct sched_domain __rcu *, sd_asym_packing);
 DEFINE_PER_CPU(struct sched_domain __rcu *, sd_asym_cpucapacity);
@@ -721,6 +722,19 @@ static struct llc_local_rank_topology __rcu *llc_local_rank_topo;
 static void rebuild_llc_local_rank(int size);
 #endif
 
+/* Get sched domain by its name */
+static struct sched_domain *get_sched_domain_by_name(int cpu, char *name)
+{
+	struct sched_domain *sd = NULL;
+
+	for_each_domain(cpu, sd) {
+		if (!strcmp(sd->name, name))
+			break;
+	}
+
+	return sd;
+}
+
 static void update_top_cache_domain(int cpu)
 {
 	struct sched_domain_shared *sds = NULL;
@@ -753,6 +767,9 @@ static void update_top_cache_domain(int cpu)
 	 */
 	per_cpu(sd_share_id, cpu) = id;
 
+	sd = get_sched_domain_by_name(cpu, "NODE");
+	rcu_assign_pointer(per_cpu(sd_node, cpu), sd);
+
 	sd = lowest_flag_domain(cpu, SD_NUMA);
 	rcu_assign_pointer(per_cpu(sd_numa, cpu), sd);
 
-- 
2.34.1



