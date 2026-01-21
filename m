Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6B920C44502
	for <linux-mm@archiver.kernel.org>; Wed, 21 Jan 2026 09:07:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 643206B0089; Wed, 21 Jan 2026 04:07:37 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6049F6B008A; Wed, 21 Jan 2026 04:07:37 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 54D626B008C; Wed, 21 Jan 2026 04:07:37 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 4632C6B0089
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 04:07:37 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id ED935D29D4
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 09:07:36 +0000 (UTC)
X-FDA: 84355392912.24.4E4EFE8
Received: from SHSQR01.spreadtrum.com (mx1.unisoc.com [222.66.158.135])
	by imf29.hostedemail.com (Postfix) with ESMTP id EE37D120004
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 09:07:33 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=unisoc.com header.s=default header.b=IGSBgW9r;
	spf=pass (imf29.hostedemail.com: domain of zhaoyang.huang@unisoc.com designates 222.66.158.135 as permitted sender) smtp.mailfrom=zhaoyang.huang@unisoc.com;
	dmarc=pass (policy=quarantine) header.from=unisoc.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768986455;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=Ti/VJ8zqauemkj5X2GjKo0Pb5M0bLDQ2QV+IUZscyAc=;
	b=l7PuYQQzBxE1JhjO+D3nO6/bwPlkBKb4Jqj9wNlGNaKMylDFwQ+GrtUcD4Ht32SQc93SLI
	PpSHe8QL7cdUQkHLFKOQSDp/k+9m/gAkg/qDSfvk1KsAwQqzba/RBa8Iy2oak1Ltv91Np9
	vTlGE/DrZfjaN4msdHqxLbQDfYBkpmA=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=unisoc.com header.s=default header.b=IGSBgW9r;
	spf=pass (imf29.hostedemail.com: domain of zhaoyang.huang@unisoc.com designates 222.66.158.135 as permitted sender) smtp.mailfrom=zhaoyang.huang@unisoc.com;
	dmarc=pass (policy=quarantine) header.from=unisoc.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768986455; a=rsa-sha256;
	cv=none;
	b=NoAKCYxQLNSqYalVsNaU/ABEYeIlo2BkoT4CmINESjP1xz1ikwpiiKY/1kvyXLC262cjWb
	icR1myRvNjv+8/sp36E3q+WU9PNSfZHFqynIsDX1pRS8Qlx3iTKnMs4YusJ4b8BHT9IbNX
	thRymcUpREC1I0u/F2mSC/kdCBFYcZQ=
Received: from dlp.unisoc.com ([10.29.3.86])
	by SHSQR01.spreadtrum.com with ESMTP id 60L96UuJ012986;
	Wed, 21 Jan 2026 17:06:30 +0800 (+08)
	(envelope-from zhaoyang.huang@unisoc.com)
Received: from SHDLP.spreadtrum.com (BJMBX01.spreadtrum.com [10.0.64.7])
	by dlp.unisoc.com (SkyGuard) with ESMTPS id 4dwypS02FCz2MGpnb;
	Wed, 21 Jan 2026 17:00:47 +0800 (CST)
Received: from bj03382pcu03.spreadtrum.com (10.0.73.40) by
 BJMBX01.spreadtrum.com (10.0.64.7) with Microsoft SMTP Server (TLS) id
 15.0.1497.48; Wed, 21 Jan 2026 17:06:28 +0800
From: "zhaoyang.huang" <zhaoyang.huang@unisoc.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        Michal Hocko
	<mhocko@kernel.org>,
        Johannes Weiner <hannes@cmpxchg.org>, <linux-mm@kvack.org>,
        <linux-kernel@vger.kernel.org>,
        Zhaoyang Huang
	<huangzhaoyang@gmail.com>, <steve.kang@unisoc.com>
Subject: [PATCH] mm: bail out when meet the goal of proactive memcg reclaim
Date: Wed, 21 Jan 2026 17:06:20 +0800
Message-ID: <20260121090620.559242-1-zhaoyang.huang@unisoc.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.0.73.40]
X-ClientProxiedBy: SHCAS03.spreadtrum.com (10.0.1.207) To
 BJMBX01.spreadtrum.com (10.0.64.7)
X-MAIL:SHSQR01.spreadtrum.com 60L96UuJ012986
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=unisoc.com;
	s=default; t=1768986410;
	bh=Ti/VJ8zqauemkj5X2GjKo0Pb5M0bLDQ2QV+IUZscyAc=;
	h=From:To:Subject:Date;
	b=IGSBgW9rSzEU/BbXcaDhvmqhTe497jczaQL9kQ6+Bb1FA67/1or0fVU7DYYD/1Wbj
	 qC+zVF5v7yJs/Xne0eiV4KMJZe9urhqQ5Z/K+m8yOQWwF+Q/dEZXmCrcMfigK7anxI
	 zfteYpCKgCXKuibq8Q+q8MLSTjDAqVUgPcPR5kOxGWW/8f0ScQtBLAnmPQHOtjGN63
	 tSvjxLnbmi5W/Byy65qOrepuzgZwoBsOyiR4EvHbBi+jO6dIDmVBh6LnU08QhiXdpr
	 aRHg4eW+Aynv3JDFkwy7kzY9Z8ki44WHycyRjltzZcXM21CvMBLJlD3YcxzbzTjGnw
	 W7cfc2+mdVIKw==
X-Rspamd-Queue-Id: EE37D120004
X-Stat-Signature: kkbwfd9jhwabx8e8qmw4yxko8qty4jng
X-Rspamd-Server: rspam09
X-Rspam-User: 
X-HE-Tag: 1768986453-115931
X-HE-Meta: U2FsdGVkX1+LhMa2gB8QNn6GQtwcHNqksaUJF0IpPN7sTYxdm4ie253U0iHSloeX689vBVH+nAFkMvrCfJkrOj4Yz4LCt99kBoZxkw0b9Cq+Lam/qj6xan3qi9cZ+DxYDE0QR74oNowIUqdaOChubPzNnDShWb1ibUMmIhpvmTgSfLih+dZwKf9KfjkmW74lWYNquzQcdTC1YybJmqPZun/okrLN1cRf6uXU3hJVrJrg7D9zV++Ga32JJhNN9X1llGTsVqaGoRo3Qa+0sv08zDz26/BCNemVTjGWJHwl+WB83aaSElUlD/Lr0sZsHU6jIVDbRc4e3fRaxtp/emK2NHIeG+0JmT+qufBEz3dn4ekpIksiGR3dt5Ieq+ox8ApNQN9jHT0jnbKO6cD7mpD1jGIIW4mDTSYTLNr/kBX4z5RXOhN0+O8CoHhYSCNVV5q0AdwLGcRsrEzg8CMGPlzyJdrYSH5BHs9zr8QKqh3e5eyInOQOm6OkkpZeiNnYAYgm233xUsvMm7yCKXcUlm/cwHrfEX75EFc62fWc/sB7bTiieFKdt9uzjnKovYtiF7MxnBxq03VI/0M2yZQZ/Nz03rCiVc3ypLlJkPd1296PH6V0QNftpuSXmefZ1BmK8J9YhBp/JyOaBSNF6zGyXwVifhNvOt+M81lORbdcfG91LIc3q5W25YdDRh+LrZ9GujVtg7Xkm+3i6dBA7bPOhUrtJEZ0NgAckKNPx5YZ0a1OcJw7D+7bCKQe/fPvc12MqiJgSvE+loFrL3/z+t9Gbjy+vEzU021bGjkKkIaL54k3O9EfSLN1IspQuH8FTGLo03z5Vj4qd+36M/qkPVTOHvbjtOGX4qGIF05W9/v4pGlL75Et47+qpHCpCTnc2cd4gZ6SOLXtMwLosxEpW+r0RHn8NGcZLOhprotAo6jflmhyDaStw/XjvA+xXdn40JVxE/3MYNAhsE8nhA/tWITqklE
 1GBHYzuc
 hb4dsMlA3iyMNglY82JNvDLfRNot9gKxZmxjczfG39KS9yFnZMDSvZ9kZMPsvblmAyB7VI27Gq/HOXBZrJ603HnjInxE4MUQ1N4SbnZVbjsToaOuaqWGBpL50doqfth+lDYXSsL7SvtngweMxoRwQWSAFRhUw58RcWzy2FzgOOow4Zoi8wbwwSG6a4byN34UXkd9zXfkUOVRbSGS2GIAVRga6x4/A1uuAs13MAHvtH7nfik/xZNDFDFG0gLhNROTwndVe+7NfRiL81qX/M9MeVEIVI9nLRKOQ3hIY7sEFK7TM4uXcFiYcAThGzQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Zhaoyang Huang <zhaoyang.huang@unisoc.com>

The proactive memcg reclaim defines the specific target mem cgroup
as well as a certain number of memories, which is different to
the kswapd and direct reclaim that need to keep the fairness among
cgroups. This commit would like to introduce a criteria to have
proactive reclaim bail out when target mem cgroup could meet the goal
via its own lruvec, which means the reclaim would also go through the
whole tree if the iter start on the desendants.

Signed-off-by: Zhaoyang Huang <zhaoyang.huang@unisoc.com>
---
 mm/vmscan.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 670fe9fae5ba..5dcca4559b18 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -6028,8 +6028,15 @@ static void shrink_node_memcgs(pg_data_t *pgdat, struct scan_control *sc)
 				   sc->nr_scanned - scanned,
 				   sc->nr_reclaimed - reclaimed);
 
-		/* If partial walks are allowed, bail once goal is reached */
-		if (partial && sc->nr_reclaimed >= sc->nr_to_reclaim) {
+		/* If partial walks are allowed, or proactive reclaim where
+		 * the target memcg is clearly defined that could let us ignore
+		 * the fairness thing, bail once goal is reached.
+		 * note: for proactive reclaim, the criteria make sense only
+		 * when target_memcg has both of descendant groups and folios
+		 * charged. Other wise, walk the whole tree under target_memcg.
+		 */
+		if ((partial || (sc->proactive && target_memcg == memcg)) &&
+			       sc->nr_reclaimed >= sc->nr_to_reclaim) {
 			mem_cgroup_iter_break(target_memcg, memcg);
 			break;
 		}
-- 
2.25.1


