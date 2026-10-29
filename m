Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 65607606A31A
	for <linux-mm@archiver.kernel.org>; Thu, 29 Oct 2026 02:33:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 667416B05C0; Wed, 28 Oct 2026 22:33:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 618AF6B05C1; Wed, 28 Oct 2026 22:33:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5071D6B05C2; Wed, 28 Oct 2026 22:33:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 222DF6B05C0
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 22:33:30 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 9B6E81602B3
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 02:33:29 +0000 (UTC)
X-FDA: 85374092538.21.4935E6B
Received: from spam01.hygon.cn (unknown [101.204.27.37])
	by imf03.hostedemail.com (Postfix) with ESMTP id 59B9420002
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 02:33:27 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=none;
	spf=pass (imf03.hostedemail.com: domain of wujianyong@hygon.cn designates 101.204.27.37 as permitted sender) smtp.mailfrom=wujianyong@hygon.cn;
	dmarc=pass (policy=none) header.from=hygon.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793241207;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=CYdYh5WBrRXXCSf7pnLISM0Ny80SHTHVoHp4gT5qeTM=;
	b=cnWT/0v5adhtZT6hOww7gA0GA5KZP1JCvzG8D5jrgxzZEGSKx4Q3AUZa0NvKgR751z2TmN
	PQrWAVUyUgcjQJf0/txyZdsvFykRRrhDoaIQLcPm/hgSrp+wiETotxvkn4zupysmz1d7Ow
	mN2Rd2CVAElBmi7dwKVJzLE1qFSKNvw=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=none;
	spf=pass (imf03.hostedemail.com: domain of wujianyong@hygon.cn designates 101.204.27.37 as permitted sender) smtp.mailfrom=wujianyong@hygon.cn;
	dmarc=pass (policy=none) header.from=hygon.cn
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793241207;
	b=uYm3hd6iHksDZGMMqZd8ImBGelNSi4hq+a3KQairBXguGyZip1HLgeWmfmRgMS8FOpKcvA
	dnFWiMWwZ6Lkb5Z87vnZXz4aHOBI91llBzRxpJ4Xrwgy/xYN0WOndK7Y+ChQirEj/jhPh8
	LQgTNn4em+RTZEPrj383RfbH2C4yV2I=
Received: from maildlp2.hygon.cn (unknown [127.0.0.1])
	by spam01.hygon.cn (Postfix) with ESMTP id 4jFSvn08j0z171YW;
	Thu, 29 Oct 2026 10:33:25 +0800 (CST)
Received: from maildlp2.hygon.cn (unknown [172.23.18.61])
	by spam01.hygon.cn (Postfix) with ESMTP id 4jFSvm0NWVz171YW;
	Thu, 29 Oct 2026 10:33:24 +0800 (CST)
Received: from cncheex04.Hygon.cn (unknown [172.23.18.114])
	by maildlp2.hygon.cn (Postfix) with ESMTPS id AE93A314AC01;
	Thu, 29 Oct 2026 10:32:59 +0800 (CST)
Received: from jianyong.hygon.cn (172.19.20.52) by cncheex04.Hygon.cn
 (172.23.18.114) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.36; Thu, 29 Oct
 2026 10:33:21 +0800
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
 Hildenbrand <david@kernel.org>, <maddy@linux.ibm.com>, Michael Ellerman
	<mpe@ellerman.id.au>, <ljs@kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-mm@kvack.org>, <wujianyong@hygon.cn>, <jianyong.wu@outlook.com>,
	<zhongyuan@hygon.cn>, <huangsj@hygon.cn>, <wangfengyu@hygon.cn>,
	<yingzhiwei@hygon.cn>
Subject: [RFC PATCH v3 11/17] sched/cache: Drop prefer_sibling restriction for llc_balance
Date: Thu, 29 Oct 2026 10:20:29 +0800
Message-ID: <20261029022036.4002331-12-wujianyong@hygon.cn>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261029022036.4002331-1-wujianyong@hygon.cn>
References: <20261029022036.4002331-1-wujianyong@hygon.cn>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: cncheex05.Hygon.cn (172.23.18.115) To cncheex04.Hygon.cn
 (172.23.18.114)
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 59B9420002
X-Stat-Signature: kmt4dtg5d4tz75sfsfbsfte7eyk8ordr
X-Rspam-User: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1793241207-309908
X-HE-Meta: U2FsdGVkX1+6wm3LZxPNHBX552ZIfoQ09H8c0uOZ2p/ytAZz7hBB8Q/zTYa+5DwJWcr62xh17kRqUHhbhmVH+2nP+xwn0aIxLuXG52T/SnVo++ccqjS2xrUE6zhhH6PVDj1SC2mwiutTBmQokez2nm7XFxUsCh2Grx91RNaJ5q566nLy0+4NNmB1QY5rOcZfTM0m8rU6UD8wbfjREhAU2bYVc+aCKonGWjSz8AhzD8vv2QJfCwzJDmQ09OgyV11FFPe6iJJgKyxqGC7fVwL7edR22UaDvb2098jeJnfLOIvd2O2Y3azf+5OAImY4MbnzmsP3abCpVnEIdAbJUpgW9fC4ydwtmdTdnQDpEDEaF4dfAV8YV+KSJniU/xY72BsbmOcE+/SXNPMPwtRLFlVhFlruGH9UUjrzMNJKekm8Hy8RPESBqEKjt0tKzeOYuzscCS1ESU+GHanj5xrqCnVh1YAmc+7MtfbcuvGsf8lTNyFiBPUjBFPxyuCKFTlERKhXgN8f3tHB8Q5OhvE29EiIJauxw85q+dMV3cko8Q0vGTiM0AgUtDX/Je/cevtpAPyAv9rbuJJNa8koO+XQKKWgsuOrDbdHdJRhFe1dGf0rEjyfJ1Ywxl+dd0xJB1d0SqTDTrsCf4PwamADmFjxQ3p4jiWzaXff/oN6LuNxgt+hDqSt2aJcjz9C72PrlJ4UeNdW0m7kdc579H0GPn6r/r/c17ebYFpa4wyeXKL4ERMlYbofOx1xisWWMLaGvoWoYPsQxOPKHYF1BzPTVWPVaUdsRBTZDMAuEPeme8jaPZLcI1/LF9Bi9+wx/hTiPNF4KzjppiEK37Yn0S2E/1FH7O62lHkULRiGixEX6yVVqN1gzO5MeHs6pKoPeh3Yy8meUdVV+yqpcyudPn+f7Y1F2KMPagKrCM5IKCPwWalEeItxkCsnVwoUTDNCWfYVseDpndKM/MGN9TV8ndMN60UZBXv
 sLoO9B4u
 tIGtD3rlEdXQhiuiG7iE17Hszz4iO5fSYdxoyimyjNy/3EFeyo8b1ko5vCg1VyLJ9W8y03svP6q1/tgx6R07mcCy3I526z1h2YDUwPQAxzBvGdQMwnBvp6ozm0fJUeod6OnddNAZpzYkgezSkSCh27mkK/waXy1UYwUV55eXGGc5P29VP8chCppc44ksUER3Zok/YmfL/UFZRYDI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

group_llc_balance performs balancing across LLC and NUMA domains.
sched_balance_find_src_group() forces balancing for it only when the
busiest group's child domain prefers siblings. However, sd_init() clears
SD_PREFER_SIBLING on NUMA domains. On systems with multiple NUMA levels,
prefer_sibling is therefore false at the upper NUMA levels, whose groups
are NUMA domains themselves, and cache-aware aggregation cannot force
tasks across those groups, e.g. between sockets.

Force balancing for group_llc_balance whenever the local group has spare
capacity, regardless of prefer_sibling. Keep the prefer_sibling
requirement for the sibling_imbalance() path.

Signed-off-by: Jianyong Wu <wujianyong@hygon.cn>
---
 kernel/sched/fair.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index e9a803433b16..03bb5c85a8b7 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -13334,9 +13334,9 @@ static struct sched_group *sched_balance_find_src_group(struct lb_env *env)
 	 * Try to move all excess tasks to a sibling domain of the busiest
 	 * group's child domain.
 	 */
-	if (sds.prefer_sibling && local->group_type == group_has_spare &&
-	    (busiest->group_type == group_llc_balance ||
-	    sibling_imbalance(env, &sds, busiest, local) > 1))
+	if (local->group_type == group_has_spare &&
+	    ((busiest->group_type == group_llc_balance) || (sds.prefer_sibling &&
+	    sibling_imbalance(env, &sds, busiest, local) > 1)))
 		goto force_balance;
 
 	if (busiest->group_type != group_overloaded) {
-- 
2.34.1



