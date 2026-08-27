Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 42F1CC61DC6
	for <linux-mm@archiver.kernel.org>; Thu, 27 Aug 2026 12:34:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0B0CF6B00A2; Thu, 27 Aug 2026 08:33:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 060B26B00A3; Thu, 27 Aug 2026 08:33:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EE01E6B00A4; Thu, 27 Aug 2026 08:33:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C1E6E6B00A2
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 08:33:45 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 4419840408
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 12:33:45 +0000 (UTC)
X-FDA: 85146990810.17.F5FF989
Received: from mailgw1.hygon.cn (unknown [101.204.27.37])
	by imf26.hostedemail.com (Postfix) with ESMTP id 196D214000E
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 12:33:42 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=hygon.cn;
	spf=pass (imf26.hostedemail.com: domain of wujianyong@hygon.cn designates 101.204.27.37 as permitted sender) smtp.mailfrom=wujianyong@hygon.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787834023;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ZXITsS6oLVwdm3fm5C2B6e6r+kwxrwhz0JiGWfN3jcI=;
	b=0W5OtWzpq+3pIEPo4yo73sEaI0sYm7z3AAQsOyuYCfqrSKB3qWjyRLi9GvKYEDGERQuyUH
	8ohXM8zrxQl7ljX6ljKfKlt2ARXUsAUWQwsqQrQWspnZG8fZBtHqygcb3bViOxIF/OetHq
	o7j72ZQtf3MUJQOsQUKI3Qd8UbSIKM4=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787834023;
	b=rBYBg7+Q0nbBET8zwlJfoSAvDZ7gAcyr2d0u8UKptTo/b64dgXNhwLBZCjkKaKo0Dbu9HX
	TJgYoePeTZv09OW3DqbzwXeCt6JAjRr+b4W/Wsv0jFZArMPGDkkaDAwTsRDB30Xr+BwVQs
	GqS5e/FltmqALmBxGjk3yXY02fJ16X4=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=hygon.cn;
	spf=pass (imf26.hostedemail.com: domain of wujianyong@hygon.cn designates 101.204.27.37 as permitted sender) smtp.mailfrom=wujianyong@hygon.cn
Received: from maildlp2.hygon.cn (unknown [127.0.0.1])
	by mailgw1.hygon.cn (Postfix) with ESMTP id 4hW1CS0WpPzBJb6y;
	Thu, 27 Aug 2026 20:33:40 +0800 (CST)
Received: from maildlp2.hygon.cn (unknown [172.23.18.61])
	by mailgw1.hygon.cn (Postfix) with ESMTP id 4hW1CR1NWszBJb6w;
	Thu, 27 Aug 2026 20:33:39 +0800 (CST)
Received: from cncheex04.Hygon.cn (unknown [172.23.18.114])
	by maildlp2.hygon.cn (Postfix) with ESMTPS id 00DA736F1F84;
	Thu, 27 Aug 2026 20:29:57 +0800 (CST)
Received: from jianyong.hygon.cn (172.19.20.52) by cncheex04.Hygon.cn
 (172.23.18.114) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.36; Thu, 27 Aug
 2026 20:33:37 +0800
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
Subject: [RFC PATCH v2 14/23] sched/cache: Drop prefer_sibling restriction for llc_balance
Date: Thu, 27 Aug 2026 20:28:07 +0800
Message-ID: <20260827122816.756234-15-wujianyong@hygon.cn>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260827122816.756234-1-wujianyong@hygon.cn>
References: <20260827122816.756234-1-wujianyong@hygon.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [172.19.20.52]
X-ClientProxiedBy: cncheex05.Hygon.cn (172.23.18.115) To cncheex04.Hygon.cn
 (172.23.18.114)
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 196D214000E
X-Stat-Signature: 9bjdfxrh8jeraosc4mmwizxxhcwdw1xp
X-Rspam-User: 
X-HE-Tag: 1787834022-351871
X-HE-Meta: U2FsdGVkX1+gPJTntLIbA5WFUOIVjbilayD6VQjSsXPs74XfD5GSU3LT0RNiuGLX/1aTDSBVrR3ip7H2hYX7fI6j1oaVXeO7JvbUSIRljTeQDBViCNEsFIloQy/rXyQhzdZ93oq4RGx/y6pZlCpvXV6f/x9MKzxY7Lyio7HxkdH+Jgaq5/Wmf1sldyOYK5NS6ZJCUYHDRD38G+KMOcZPritf/OweSQbTniqyDXYydwIUF4sOMxyZF/ME2BQmHJv108Lmc+hhNjd62z4+mFe8AB8Q3UDQ6u/MUNfkoC6dDG/rIgM3bYCRD9ibuQOplggR9lz9hu9HWIjyR2HbusbpsRFutCMvAJQ7Q98yQ9Nb4TNyarE9SOfOllmED7Kz4UT27ajnKT+g0AT+xIh7knE1Y3gUj5llr9EwiJWNju9JvDpPQtzoYsHmkC5lSFCZAUwuXZTG4r+M2Wn7LO0/W+9dVN+I/jr1LQFDxgV50MCxPkL1YBJEoPIOgoUF7YcLXZEAimfcaYi1s7pgiy5H6TRexg0EgP2BX7MBvr9P6VUk/AQPBLu8oBqDDwp+grh8pI8id18DDc2PVWY+sEtOMerqnehlS3wsK2GkjAC8EQfLROn+eenXAm8W8WTLebC8QL6/MMPI8TguFsOQaZIcIs26hjdTXN5E+z8rsdRstP7osV1btqzsPwE1lvY1T4kx+BXU0EZb2TZ3INlBIUy8INg+kyvNl2QiJMUAYdco+6sTsvip1QAVBnni1r+87gTqYNZ0Wjb4WNUxCMDSCvvOVWWitjdDXLvjaAfOpIOLMGgHaEHOoLDUaM6AAayltfWjkwSWlR+9H0WlkSRJtjnKExZpDIAYHUQ0yMDgw2kAI0MYWxXRPbQU5KysRRXZc7coiRl37W2fcn5THq/6nuS1F35x6BKxkoNqsuAgmsud0/b2Qtn96EOqKzKoQYIYG8QdjndU4onI5rtOEMgjbf4jX3U
 1E52omb8
 iQCJss1XBhwXnZHRbrUcfqePxz0WHUhspLyox+Lb9PGrZipckn4572G5y3vgBDYI8n5EnbyUuQXC64OmxCRuXNV4AiBfmmkm3+MtkjwFDth407Xi04bFb9XF6Uz+oa8CWtOT+WiWRaUuqqmu7hSaXsEQv8CNhSGG//KF+p9NZ7XSZVJFLuecXu01z7KWSBLZ8u3jjQLosvD+K66itlosJ30B9ViOas2ZpVX7eDfAwZKcn58/lkE04+TyK3JhzhaNqzaZEZXjrTC2HANSmuyktO/Y5nEeCseEzCwMnjlEwjdcgLW7l1cBNCAnvDLm71NiKPmaGmRtXUNnlMSEfI/D2/6O9rA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

group_llc_balance performs balancing across LLC and NUMA domains.
The prefer_sibling constraint unnecessarily limits its scope, so remove
this requirement entirely from the branch condition.

Signed-off-by: Jianyong Wu <wujianyong@hygon.cn>
---
 kernel/sched/fair.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 584297528a9e..5c35a43e5e38 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -13274,9 +13274,9 @@ static struct sched_group *sched_balance_find_src_group(struct lb_env *env)
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



