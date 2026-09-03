Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 64F1EC61DD6
	for <linux-mm@archiver.kernel.org>; Thu,  3 Sep 2026 01:07:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 67B4C6B00A9; Wed,  2 Sep 2026 21:07:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 653A56B00AA; Wed,  2 Sep 2026 21:07:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 56E036B00B2; Wed,  2 Sep 2026 21:07:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2FC376B00A9
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 21:07:32 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id C197EA42D2
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 01:07:31 +0000 (UTC)
X-FDA: 85170663102.17.744664E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf03.hostedemail.com (Postfix) with ESMTP id 3D0EF20008
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 01:07:30 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=huWcm2b3;
	spf=pass (imf03.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788397650;
	b=jKRPw/wA8PWQH3e0dx+1MhwcW6w9QHWl0P/WiSbp//8Gg3qYDBXFq0fwEyJgZpKEc/4EYl
	jXJPzPKAkdcmjTWtV+MqdWih4Y1sYUlUd60KhHOse+EJYaJWDn5DOZOiDle03GisH2oswW
	IGsg1vhoBP7wXoOIlOjKszYlFbpJpRI=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=huWcm2b3;
	spf=pass (imf03.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788397650;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=a9IM/Ej4irsu0tekSCIZa7xad+wT2QHGn683VTr7Q88=;
	b=IOt32ktBXMenQ7FZKXpEAS4nv8Ay14oX2LjrWh6r0zdz8ZotHzWvKXGVPl9e2unBFCAHLC
	Ne5+dPQl9eq7l7r4wXkYuokNYKEhE+I4E5qk2cMykfmWs/CRg4USJ82YRGCvH83PSQLCt7
	3eYNZVU2s49+2uqNGySO6LdcVsK80bU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id D44D9600D1;
	Thu,  3 Sep 2026 01:07:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64AEF1F00A3A;
	Thu,  3 Sep 2026 01:07:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788397649;
	bh=a9IM/Ej4irsu0tekSCIZa7xad+wT2QHGn683VTr7Q88=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=huWcm2b3wYceGKjjjwjPQBzLv+hRL5m1+3L96P+Dy7mb8+EOVh0ZG7ka055pt4CQ4
	 O/yPRyz4jI002lrsN1mNDvJJirJXLV8WEwBh08RFyqVJsYYnyvJw5v1HEt/FDS1fIz
	 wjex7RFagx+jP6A4+tQrp2zPlXnczIk2g3zd7bLlgSGjBqYt28/7NCEIJiyRn9zuUZ
	 tPQxJvCPWAP8d2ZQld1rkG6FABZbFKrUp908uIUDKnioz7ozLp91G5QAwX1V3K3b76
	 kSWO/++MpfPUfEtHnDPJC1zA7KY/v7TqP3LOnZNX6FbcROeznspzN4wOoIGpnVsl/K
	 HpKzS1nupRz2w==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SJ Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 1/3] mm/damon/core: error damos_commit_quota_goal() for zero target_value
Date: Wed,  2 Sep 2026 18:07:19 -0700
Message-ID: <20260903010722.94244-2-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260903010722.94244-1-sj@kernel.org>
References: <20260903010722.94244-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 3D0EF20008
X-Stat-Signature: j351p3nb55gfqmnjn9rn41kd7arf118j
X-Rspam-User: 
X-HE-Tag: 1788397650-429538
X-HE-Meta: U2FsdGVkX1/P6no7ElG1hYiqJ3KmXxiyu1kKV20yRnx/E+mPpw6bz1PUJuF40fOFBrpA1OlzL9ei+SH/Kd71QhqyAB1djI3PsSaoMDnwM+WC+B1aXsJ0+04b9pBb4tmwn9a/1lwVK9l19sE8evfcPQU1nQnjQLmpb6os4IVELQjU+tv4QOSKLa5k/NKt2gVlSky7RVSGmWw80FyziNBw952LRI0wJ8agczgFtlA37AM9gh064ilVlL1Sa4ZYVbVBm022X0SFX0iTSGv9aq4HSnvzgtQ+UbMzLX3ajAxDZMtwfoldnA6NlNTRix6nqTx7jtq69hyVUN+Hwh2adL2WteHP3N8x4JX/NUxMHLYtuuxE+z6vE2THWRLsRVKeoWUT0fblAMYe6Nl6Twb7/DTHAzka4Sd4CEeF3vhl5TFTwPt2Sdq+v+y8Cob9BSJW+JhM76qL/zW8gGSrXnec9dRdgV5sVuuXVu3oiYXlJOTJKsVf6f0IWLNccO6N9mGPOdSIume/cBJfJFssAAzkuxNJI5V/ocgJ8W8C59qs/8E334MaW/cbPGshMNjlm1gk+nOu8XaOtT76VwYkvgbHHu5wNrXeK6gxE5SE04ZuJM5K8Ec5oiXOP/u5+feivq+mQeaBGXYdqeVr8qtFeMeaxJlU5BTdrID6ViCTN8DOVr//UUUCnSA415Q1e6LkXVYJ2uUpMkULK9nKZNz3e1hJJa6oA+Oi5CGW+zffUA+HZ62WPVUAOeXMVuJ1X19uur1fps7H0BXtRpHPZBrXLgvMt/cBd+SBOuySTKuYebwNoqjenyDlXfuN3NVRnSzX18zzoOjW2u87eIJbnSld6EqFQSrmGPjamO7VPjX6fdFRZjCmVOyBsBDGh9s0cAzNJFsqUQRGs/qPdpSqlZgxNBITsO1csHDBrEGPq0Yhk1qKIPs0WcXBPzkdNp4lCN2k8EYGMo6wYbGG1lNK8nrW6oMOb0y
 J1HLYZ95
 2o1SJhnFX9fd+3rhyT+b20cGNvN0rpq81PzdEMc23pQVETqMEnUYpwdmHZ7G0uaveukxDxJ30nEFDK5hxVzzltsCmLmuc+bOVm4aTI2mYHbOd5L5cG7bAjvzSGbITr6LrkNsi241ZAxs1Sc7lPj7t43xoG9JyAPSynFFvgXh3QZa1U6k2bycCh0rJCaN3CnC2eHRjzg2nPEFem0/Tp1NkclwKYawWSh9M3KFwes/iwOSD+F4bRUGLuZsU/XEwMPJ0udy/RYXBeuAlX4zF3rm/xKEKHzVSezFGAlyVi2qB+alPgaEck51o1T0YJw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

If a DAMOS scheme has a damos_quota_goal of zero target_value,
damos_quota_goal() could trigger division-by-zero error.  Hence each
DAMON API callers should do the zero target_value validation.  It is
easy to make mistakes.  Actually such bugs in DAMON_LRU_SORT and
DAMON_SAMPLE_MTIER were found and fixed [1].

It is better to handle the corner case only once in the core layer,
instead of multiple places in all DAMON API callers.  One
straightforward option is using an alternative denominator for the
corner case in the damos_quota_goal().  However, the zero target_value
is meaningless.  In this case, the quota goal is always evaluated as
achieved or over-achieved.  The quota will only keep being reduced.

Simply avoid using zero target_value by adding a check in the core layer
DAMOS quota goal parameters validation/commit path,
damos_commit_quota_goal().  Update it to return an error in the case.
Also update its caller to propagate the error.

[1] https://lore.kernel.org/20260803134034.15217-1-sj@kernel.org

Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/core.c | 22 ++++++++++++++++------
 1 file changed, 16 insertions(+), 6 deletions(-)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index 56ec6f616fa9a..89d1c77417450 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -1212,14 +1212,17 @@ static void damos_commit_quota_goal_union(
 	}
 }
 
-static void damos_commit_quota_goal(
+static int damos_commit_quota_goal(
 		struct damos_quota_goal *dst, struct damos_quota_goal *src)
 {
+	if (!src->target_value)
+		return  -EINVAL;
 	dst->metric = src->metric;
 	dst->target_value = src->target_value;
 	if (dst->metric == DAMOS_QUOTA_USER_INPUT)
 		dst->current_value = src->current_value;
 	damos_commit_quota_goal_union(dst, src);
+	return 0;
 }
 
 /**
@@ -1237,14 +1240,17 @@ static void damos_commit_quota_goal(
 int damos_commit_quota_goals(struct damos_quota *dst, struct damos_quota *src)
 {
 	struct damos_quota_goal *dst_goal, *next, *src_goal, *new_goal;
-	int i = 0, j = 0;
+	int i = 0, j = 0, err;
 
 	damos_for_each_quota_goal_safe(dst_goal, next, dst) {
 		src_goal = damos_nth_quota_goal(i++, src);
-		if (src_goal)
-			damos_commit_quota_goal(dst_goal, src_goal);
-		else
+		if (src_goal) {
+			err = damos_commit_quota_goal(dst_goal, src_goal);
+			if (err)
+				return err;
+		} else {
 			damos_destroy_quota_goal(dst_goal);
+		}
 	}
 	damos_for_each_quota_goal_safe(src_goal, next, src) {
 		if (j++ < i)
@@ -1253,7 +1259,11 @@ int damos_commit_quota_goals(struct damos_quota *dst, struct damos_quota *src)
 				src_goal->metric, src_goal->target_value);
 		if (!new_goal)
 			return -ENOMEM;
-		damos_commit_quota_goal(new_goal, src_goal);
+		err = damos_commit_quota_goal(new_goal, src_goal);
+		if (err) {
+			damos_free_quota_goal(new_goal);
+			return err;
+		}
 		damos_add_quota_goal(dst, new_goal);
 	}
 	return 0;
-- 
2.47.3

