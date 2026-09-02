Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 63494C61DD6
	for <linux-mm@archiver.kernel.org>; Wed,  2 Sep 2026 00:27:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 732D96B008C; Tue,  1 Sep 2026 20:27:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 70A176B008A; Tue,  1 Sep 2026 20:27:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5845D6B0095; Tue,  1 Sep 2026 20:27:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 38B946B0092
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 20:27:36 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 9A69BA4405
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 00:27:35 +0000 (UTC)
X-FDA: 85166933670.02.9E09A20
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf06.hostedemail.com (Postfix) with ESMTP id 0A0D8180007
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 00:27:33 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="EBp/q+jh";
	spf=pass (imf06.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788308854;
	b=QcDLMbUwWnSJQigQ8EM5zi3P/Y185dlwURZZetpECEQuhBWAtCyYRqn7hML1diWOglomWP
	b02L1CwK4+/QZvkVEqGtAS0FNJsfDS3JQ5d9dPm5RZ+aHwltqnOnkv6JwIJ+EG7BGiFsP7
	258EMQ1DhkrUTg6tVRKcqlgp+RjED6k=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="EBp/q+jh";
	spf=pass (imf06.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788308854;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4Aq7mCS1n7SM9+gwhZmdlAUpokje7QH5p7CwEaALh/c=;
	b=IfTm1cxqfd+gbae08gvE0sB+CLbH1HT5CRhjfZ1QubMgbPON6W9eN3B1nBYwCqkmL9shvt
	FTAqwiblpMzXWw/MqFGAQRf16L/U7AdeYMf6b/JhLIQwSmIUTlVmwMiXgr8GA1DE6QnJao
	TrC/wMVOVLcnXtwP1gUV51ObsyAwFIE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 2F14E4060F;
	Wed,  2 Sep 2026 00:27:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BBDDD1F00A3D;
	Wed,  2 Sep 2026 00:27:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788308853;
	bh=4Aq7mCS1n7SM9+gwhZmdlAUpokje7QH5p7CwEaALh/c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EBp/q+jhGmoX23PF/KR8yCsXY3rmPIUMsqyxq4V7hhR2ZmeEMYnHNawW7n+XfpQig
	 B1G9yahk9AAoxz0k8lFwwlUpi380TZXoouESL8l8Il9BLlUTCRTtJf2W/jn5dVUywp
	 9eroAfIphosA0O9NWWvBEzwx++PuM+POU6kUJqq8pFOT191rb2OXS7JgYdnz6VWmwn
	 Vyt2pKdhGytPl+2a/LsRz8Ch+GAtbWwtHxrCTo3xzwdwYa8PkzBcpoY7ZtlUko1wSc
	 52cWJM4A6MwNm+AYEKRCq2QYH2Ld46OUbmBLFGBcAh4i0SU6D8CwzCGHyC4+CdSwNY
	 RLaCZ0mXnFshg==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SJ Park <sj@kernel.org>,
	stable@vger.kernel.org,
	Brendan Higgins <brendan.higgins@linux.dev>,
	David Gow <davidgow@davidgow.net>,
	damon@lists.linux.dev,
	kunit-dev@googlegroups.com,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 1/4] mm/damon/tests/core-kunit: test committing psi goal to psi goal
Date: Tue,  1 Sep 2026 17:27:20 -0700
Message-ID: <20260902002725.108635-2-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260902002725.108635-1-sj@kernel.org>
References: <20260902002725.108635-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: ifpx18ct36o3rguik1twhf5uqgfo3ocb
X-Rspamd-Queue-Id: 0A0D8180007
X-Rspamd-Server: rspam06
X-HE-Tag: 1788308853-553568
X-HE-Meta: U2FsdGVkX18IxVjNXF6y+Zf/qy6ZeGWdnI2d4M32VQ8CMS1++v8i2W52Ave/x4rSY/wAl6mIGR1uQdXK8LTCK543EtZ/E117GIyZL26WQQYwGNOScPKMzJx+Rm/o+t6cB5TzteqeSWOSOyTUBklYKE5R1rI81xzWj1MF2lQ97eD2lJJy6danxQszbBrVlRAfosMdsS4u0OhhYBOjDrGSYW6nDluVw3hFRouEAtOHCM+3vjpQqIu/dGVO6X6KM8jc8ULmZetHEL112XVhV1Qml2wQ5tCAm8Eh8l713Bc2R4GqSm072iz36YxMoFopcRaS2vvlfbqfIrwBkeyEjONASz2BfEY+x6iCDnQpct352vHf6DNxcmYmoYzjscgS2MaEVK/6daMz1o+xhqS7BXbUVsSslbuIYLykACDUQF5k2Zs8U6XC1Oib/4isw4E0KiZKPTpyPg3gweZBTd8IFI0ThOYQj+6QvlOpoYM6Bvchqd9yjJjB/DRUzHzoxz8GZxFeZOF8nfAiAeE4mRU+Y+0rU7dDenLGt+iJHD/YevT6REvCsUI1M+1XWSPd6KBlButJ5SO2S1zJX9D1YffJgpsAHg2Fvrixt/hDoUrLIww516cuT2iWLuZHu9tzAy0W3UmOWxaNS3bRwdweJzSo31EjJsh7dGfhKyxAoUJG1dTKQYLPiBohMLj3gVbNqDjDPTVE1HpwjvV+c98kLJibZkSN+sjZQDsE1z1vPHHLDh/mERFKr4xlRgWsx6CbBLYUDva4zGlgBlQ61fjr9Uiz+tfB1vXgCW1KocduHsgveEtwXuKn5p5fRheDpjxm0vLabbxlE6WfftYgsceZT6mFMYmyZ4midqBo5XJUN4Fd+8T2FFq4YnirpA55fJHhrwkViVcKRaJYJOjxWh8lNCUd5rJTOr0P6DOpeki52sDRgKJ4XilXVof+RtT96/785j8rr6rCziUJUxc3eF1/il7oYGo
 jnWhtmN+
 KDmQZEMcuWyU2aMTaPWP7HAySlPe7kt5/5ONuUPPj7+4vJriKxKuophVXLALNVverLQB1JdR9WTNF/QVRXgDhSFy90RhCWLGSRFqX7G+hLiFgH5i8KwyBS6kvMY2XZ+ju5R6amD8fWABFpVZIoVQelqz0KIkvGb2SXx7I6fMNpm3yb7ftkQwkbw5Gm4LfaGnkuwsnPjNOGyKiC6f1KltNrbqTO/Fv+4nqZv4xz8gyprG5eEc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

damon_test_commit_quota_goal_for() is set to test committing a new psi
goal on an existing psi goal.  However, damon_test_commit_quota_goal()
is mistakenly not covering the test case.  Add the test case.

Fixes: 99f89debafc5 ("mm/damon/tests/core-kunit: add damos_commit_quota_goal() test")
Cc: <stable@vger.kernel.org> # 6.19.x
Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/tests/core-kunit.h | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/mm/damon/tests/core-kunit.h b/mm/damon/tests/core-kunit.h
index 7071ec277b007..f1e11548c771b 100644
--- a/mm/damon/tests/core-kunit.h
+++ b/mm/damon/tests/core-kunit.h
@@ -793,6 +793,13 @@ static void damos_test_commit_quota_goal(struct kunit *test)
 		.last_psi_total = 456,
 	};
 
+	damos_test_commit_quota_goal_for(test, &dst,
+			&(struct damos_quota_goal) {
+			.metric = DAMOS_QUOTA_SOME_MEM_PSI_US,
+			.target_value = 234,
+			.current_value = 345,
+			.last_psi_total = 567,
+			});
 	damos_test_commit_quota_goal_for(test, &dst,
 			&(struct damos_quota_goal){
 			.metric = DAMOS_QUOTA_USER_INPUT,
-- 
2.47.3

