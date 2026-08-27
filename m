Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5AA21C61DC6
	for <linux-mm@archiver.kernel.org>; Thu, 27 Aug 2026 12:33:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C959F6B009D; Thu, 27 Aug 2026 08:33:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C47A06B009E; Thu, 27 Aug 2026 08:33:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B84566B009F; Thu, 27 Aug 2026 08:33:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8EF336B009D
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 08:33:33 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 2F6A31403F6
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 12:33:33 +0000 (UTC)
X-FDA: 85146990306.06.6E6ED71
Received: from mailgw1.hygon.cn (unknown [101.204.27.37])
	by imf22.hostedemail.com (Postfix) with ESMTP id 0162AC0004
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 12:33:30 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=hygon.cn;
	spf=pass (imf22.hostedemail.com: domain of wujianyong@hygon.cn designates 101.204.27.37 as permitted sender) smtp.mailfrom=wujianyong@hygon.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787834011;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=1Utb3Q7G8s+pTu7yvm21kkGDSVaEw3sY8+d32eCabIE=;
	b=J8GX58c3G1OHz2T1ytGP0Gl0097dqn+o6d+Y43zkigqMutnqbd/5LiL1BGT/aWZSoBEezs
	xSQXB6Qd2I+bGfCM8la/PTrFsplOhpBVAvwlSR8QBSKgGRSXo0rZQ86Cp92fFXDE7qdmpK
	xUgvaY9j99rtnm88SvX7nNrR8csH+Ws=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787834011;
	b=h2Ooyw18dcOXnguuZ0d9FpHasmbDvLV0XJiX9sltckgZhebNoKASR6tmhwF1UIoLT/xeTB
	PRwexVw9tqw/NIo0irMMg7eO8W1ERqO6Hh6daDifkMsOZuAtmGB15xXda82MZzP7pbwOZL
	WFRRa2SnUNgaRwFHY2b2S10C9IUl4kY=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=hygon.cn;
	spf=pass (imf22.hostedemail.com: domain of wujianyong@hygon.cn designates 101.204.27.37 as permitted sender) smtp.mailfrom=wujianyong@hygon.cn
Received: from maildlp1.hygon.cn (unknown [127.0.0.1])
	by mailgw1.hygon.cn (Postfix) with ESMTP id 4hW1CD0WTMzBJb6m;
	Thu, 27 Aug 2026 20:33:28 +0800 (CST)
Received: from maildlp1.hygon.cn (unknown [172.23.18.60])
	by mailgw1.hygon.cn (Postfix) with ESMTP id 4hW1CB26nYzBJb6h;
	Thu, 27 Aug 2026 20:33:26 +0800 (CST)
Received: from cncheex04.Hygon.cn (unknown [172.23.18.114])
	by maildlp1.hygon.cn (Postfix) with ESMTPS id DAF1978AD;
	Thu, 27 Aug 2026 20:33:18 +0800 (CST)
Received: from jianyong.hygon.cn (172.19.20.52) by cncheex04.Hygon.cn
 (172.23.18.114) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.36; Thu, 27 Aug
 2026 20:33:24 +0800
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
Subject: [RFC PATCH v2 09/23] sched/cache: Account percpu sd task NUMA preference
Date: Thu, 27 Aug 2026 20:28:02 +0800
Message-ID: <20260827122816.756234-10-wujianyong@hygon.cn>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260827122816.756234-1-wujianyong@hygon.cn>
References: <20260827122816.756234-1-wujianyong@hygon.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [172.19.20.52]
X-ClientProxiedBy: cncheex05.Hygon.cn (172.23.18.115) To cncheex04.Hygon.cn
 (172.23.18.114)
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 0162AC0004
X-Stat-Signature: panhbeuxjbn9fzimtsyxzymmqj3c999u
X-HE-Tag: 1787834010-104583
X-HE-Meta: U2FsdGVkX1/t1aIO+zDBs2gUd8IURTa8jZu3/T0AkeeVPP5SWemTO3L+tBrFowT4QdYLZgEPM9y2Wd/gMz+P8CyGFRlTaotiKJX3LQ0bIEUcL55mczj63tpKEa7breNR+4RS9KSyc5o3Z0SFH/MjYhWIUtKHY9YxfE+tPRJQSw/KHW4ShvGKqGg2OGlDb0Dn0Ujv84UKxiKZCsro2i5OvYR1YUqyScjsQaxXxMKMJ/z+M2JnueQq0q6xT3csxCU8cIXeN9ztmW1lXm81oEd1DHU26FAn1ADL6YLmeIQDFG8GMmiGDBCDORfb5jqYb18RHdM9Lc3VcgPD+zh9e4uXHEQaf/iEvsgTmgn+XfRIO3eY25QSp4g3yTopEDSrf/LH/RvkviRbPV4++zbhwHguanPCMSCs5Jd9KKrDlbo0Q+r+C2gKm09XqhfN0FRV+SSbYmWaeTria4GcNmxbL+C1bE1POZvopZSsPOdNtWjsg6iCvJ1l65jMBfagC1C116e06mtq7muCdP68y73ipYO7g4OBAqhasgM3NGKdsNGTJkjnPliz6hpPJTldy4buJqg1KEtZE5QUl/+jvbbHiBABSI3zTle2mX5MqEPSDdVzYU1aWdDROkNLGNzV4+iP9dTHLl6YrgCEvZtPqdTFl7/UNwsmD0Ia+pmqvp2/VDGjnddwuGpUdI/B51fwbqA3I0jh3OVv37VIrJKXzmvQ6XVmc8GXiQulOeQNdjQf0Jb10s8La+BBA3wPPIjDAJ3j5WLIK5w4SC+u/dEV2oKDiFrWw7UC/E2VGvODVIpl5fT0ZeBT1eE8fLAmvny/YhSc1X4PlD0/3TkUCSJlAMd5M4PCZ+JITQkLNZubNhsCdMKA+zQlzaM9IjDDT5oAnLnyLrqPlzA+tbfyQ2vnr+UKbSiYa7QRthfNqbWsdPIB7K2f/Xi3OqdZXzjZ14Tq4ofw0xyC3wWNst/uuavztAhqyjo
 LNStmot7
 GF2QFfvZSS8ZaG4BeyM9ASSf6YBBteoUYd2Zh8AobZcMwee6kvtmv+zSaCNQqCeHhv+X0LK9uiRFdwJTlCUPwRbCDMc7vty5W0rgEdNxAMy9SFmULnj+f3g75U8VSJW1BsT71tTZKRBMohW/RLgFJFtzZXm+yNZ5+nqIN1aQwg0UgJalGHfIhLmlvwFBDZcLjxdBEiL6PfzU/vt1467L0zWgRZFBD/RZW2GDbFmKKyyjWEVY08PiQ9Bemhe0i8VVfc0HAaLVN1NUEVtCOz+1Gbs+8qvue1zgKME4s
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Account for per-NUMA task count preferences within per-CPU sched domains,
mirroring the existing implementation of LLC task preference logic.

Signed-off-by: Jianyong Wu <wujianyong@hygon.cn>
---
 kernel/sched/fair.c | 26 +++++++++++++++++++-------
 1 file changed, 19 insertions(+), 7 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 30de09ebd9f6..dc7bbdb1ab98 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -1529,8 +1529,13 @@ static void account_llc_enqueue(struct rq *rq, struct task_struct *p)
 	p->pref_llc_queued = pref_llc_queued;
 
 	sd = rcu_dereference_all(rq->sd);
-	if (sd && (unsigned int)pref_llc < sd->llc_max)
+	if (sd && (unsigned int)pref_llc < sd->llc_max) {
+		int pref_numa = llc_to_node(pref_llc);
 		sd->llc_counts[pref_llc]++;
+		if (sd->numa_counts &&
+		    (unsigned int)pref_numa < nr_node_ids)
+			sd->numa_counts[pref_numa]++;
+	}
 }
 
 static void account_llc_dequeue(struct rq *rq, struct task_struct *p)
@@ -1567,8 +1572,14 @@ static void account_llc_dequeue(struct rq *rq, struct task_struct *p)
 		 * This undercount is temporary and accurate accounting
 		 * will resume once the rq has a chance to be idle.
 		 */
-		if (sd->llc_counts[pref_llc])
+		if (sd->llc_counts[pref_llc]) {
+			int pref_numa = llc_to_node(pref_llc);
 			sd->llc_counts[pref_llc]--;
+			if (sd->numa_counts &&
+			    (unsigned int)pref_numa < nr_node_ids &&
+			    sd->numa_counts[pref_numa])
+				sd->numa_counts[pref_numa]--;
+		}
 	}
 }
 
@@ -1727,11 +1738,12 @@ void account_mm_sched(struct rq *rq, struct task_struct *p, s64 delta_exec)
 	mm_sched_llc = get_pref_llc(p, mm);
 
 	/* task not on rq accounted later in account_entity_enqueue() */
-	if (task_running_on_cpu(rq->cpu, p) &&
-	    READ_ONCE(p->preferred_llc) != mm_sched_llc) {
-		account_llc_dequeue(rq, p);
-		WRITE_ONCE(p->preferred_llc, mm_sched_llc);
-		account_llc_enqueue(rq, p);
+	if (task_running_on_cpu(rq->cpu, p)) {
+		if (READ_ONCE(p->preferred_llc) != mm_sched_llc) {
+			account_llc_dequeue(rq, p);
+			WRITE_ONCE(p->preferred_llc, mm_sched_llc);
+			account_llc_enqueue(rq, p);
+		}
 	}
 }
 
-- 
2.34.1



