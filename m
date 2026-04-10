Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A69CBF44874
	for <linux-mm@archiver.kernel.org>; Fri, 10 Apr 2026 14:21:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 074D66B00BB; Fri, 10 Apr 2026 10:20:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EF15B6B00BA; Fri, 10 Apr 2026 10:20:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D98036B00B6; Fri, 10 Apr 2026 10:20:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id C268A6B00B6
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 10:20:50 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 719158BFC8
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 14:20:50 +0000 (UTC)
X-FDA: 84642857460.02.75C0F31
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf23.hostedemail.com (Postfix) with ESMTP id C1932140002
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 14:20:48 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=HwVHDgR6;
	spf=pass (imf23.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775830848;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4rdaam9BwVxK+HQPMM/xSyzd71ZxUQuLXDJfRzSuG9c=;
	b=pOF1rnedykqjrDrTcv18NTHNuFnvffYWentfpBP9nq2EumJuoCbplRlXjgTRYTSdK1P1xu
	kiZtQX/n5NSJXdCVV856tPxeVWeKHNV6kh6V59W3uoFoS+9FiOAhcqejTyNBfSI47eexa5
	krv5vKdWKf9abF+Nbn1Y3gJEPEJHiNA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775830848; a=rsa-sha256;
	cv=none;
	b=gQRDNLvVaGvp3jOTB66h7YupKhrkDZjtPjVj2o7R1dVqWfQqWJoOGao2oedfYA/Cn9gyvf
	rzOLEx54WNXwXT9Q6NzMVlJJTWtmKSVwCnwpMC4Mf2RsJ8zPzPabE4P78qXqC6bDY4+UC9
	bXflCxHoTnb7Wf/HxOdWN8u9oW5hgMs=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=HwVHDgR6;
	spf=pass (imf23.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 3C84C6111B;
	Fri, 10 Apr 2026 14:20:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A09F2C19421;
	Fri, 10 Apr 2026 14:20:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775830847;
	bh=oBXW5uIN8lzshHczxlHFHeX8VLmiX/5T2Hz8N+WZ/sY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HwVHDgR6EL7sgMIXcHCBMmFmJ6erdjL60dPRizRABv0CcjtOOuk/gfNy3QPZzkDZz
	 2dQcvYmokpHQ/ug7alVYo2LgaLmetwmA9aQ1NxW/mzdCdqfhwCFWuTFDqKPrazEFlz
	 LwwaBR25VXA2YKVRfotLF+8KM5Ltgt/4vIR4oovDGaVJzHSF2jgg5I+P+wzrB8Klp3
	 ojrKNihjZgm2S9KYK8wm81cUuNftlIbMDwgWWJaJOYsXucpKKquRoHHgJlnvDa0hFL
	 m7aFC8Yui8oQyXkA4tsW9mWhr2dx4OP3mratBwo2eRGYvtElZuE+F5/IzG+z4ZMfZa
	 YcNPbDBh/wqoQ==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Brendan Higgins <brendan.higgins@linux.dev>,
	David Gow <davidgow@davidgow.net>,
	damon@lists.linux.dev,
	kunit-dev@googlegroups.com,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v5 08/11] mm/damon/tests/core-kunit: test fail_charge_{num,denom} committing
Date: Fri, 10 Apr 2026 07:20:29 -0700
Message-ID: <20260410142034.83798-9-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260410142034.83798-1-sj@kernel.org>
References: <20260410142034.83798-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: C1932140002
X-Stat-Signature: 1oufi4wxg61x7bkxmq55qo5euwyhzswc
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1775830848-222104
X-HE-Meta: U2FsdGVkX1+55a2pr5DrdKXwfEFGqGtZPJZ5xyzaGOK/X3KruSxkB+emqrbaGaJ8bktyT7pwzpFzS4+0/NgIcplb/nYzZhX13cpiHcBwScmbaFbBg8IJkP7JakygLCHPLfrBFMHRpCV8aQvmGscc9dS6YdapJcdNDt4ThwROmlhvX1/ije4KJaegwHjP/5sP5fVode2y08cs4stb4e0Ulm9xaNfo6i0phIet90vwm6Xs1CwckZZI8ts+7U3uPhJAo9GtEzq8nnO0VdqFWXXlVkpRWcYivLeMSHegMs9ahKpsHuG5nlMM/iRCWB6+ab3cHF+Va5zxW4ochVPl9VIpaYs8i9wZA5af7aXtLcjZlYlMABX2sn5mvTrLhIIwtntcdIyloXYuQ6tTqAsjwRBEXv771Lyhy2qiR6RTiWLwLP0Vq8tlmN3q2gHLLunBXQwT41Bw2mv3rw0AXNwqzXCd/Jf1SGschfdiAOamftgi+/IqoqX2qXQFL+xiQN72JJnBxkKrlu99ooul9C9woOPpsXC6kxmVQSmGUt/HD6hjgldnK2NL56qRYyxw04dlhSpcAPdRyVjEMkzCtAgX94AxtkNEzq1uWgqtDa0wfJcMwQeY4Byxa81wsbdauspT5tMqU+ISLNr3lVNfiOXMNrdrQ9d76m3QLD/J9txczmb5xfawxoGEQXNTlBD3vFuDitP0E4GuJyEwrIrb0RM1yMWwpb2jQtEp6GML0eZHgkXS69tZ1qBnQEl+nAPGC1aUfVjEH0ow+Mp/CZlAnpCT7FyigL1Qrc1nyciD66qfhLrBW49KViiwKikP6owbeCTUpE8Tke8700SH6nJDLQVvuZGC2YI/zkrzFjDo2u+lgNnuuMv9LmOQB/imyM470H93dbgiTFtGtISciKuva7lGhoLA/ZGMah6sXUUxTzw+jsMf9ZUjBfMjTXfeS+ikGU6tl0o2fF7b2Z5ZFdS9ahPa6g0
 eG47vzvf
 WOLH/Je+Gsj62u8Cc850Hrl1GfmOh4t6/k6n2pSk1XjyqVOH2qRHyAUjk/U1+G2n/JOjS6eHlalzuhrhGNjQ/ovnpmgQlf17mUWv5iFC1rb9lY3Knv+r4HBbALTf0a7FE7pDkmvD9vzg0vfDCuXGXV9Sn1mnJOzRiktT2J5/gijsHS1JtAmUPbgQS5DSOnJzEp7q9i1CHkeGNg+HVLx2sWnZPdU+oNIk7q7ljdynrlWjhdOcijsYIRAxSBI1P0jcCyXvRv8TnwzMPBWBFv0N7PqwE7Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Extend damos_test_commit_quotas() kunit test to ensure
damos_commit_quota() handles fail_charge_{num,denom} parameters.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 mm/damon/tests/core-kunit.h | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/mm/damon/tests/core-kunit.h b/mm/damon/tests/core-kunit.h
index 0030f682b23b7..1b23a22ac04c4 100644
--- a/mm/damon/tests/core-kunit.h
+++ b/mm/damon/tests/core-kunit.h
@@ -694,6 +694,8 @@ static void damos_test_commit_quota(struct kunit *test)
 		.ms = 2,
 		.sz = 3,
 		.goal_tuner = DAMOS_QUOTA_GOAL_TUNER_CONSIST,
+		.fail_charge_num = 2,
+		.fail_charge_denom = 3,
 		.weight_sz = 4,
 		.weight_nr_accesses = 5,
 		.weight_age = 6,
@@ -703,6 +705,8 @@ static void damos_test_commit_quota(struct kunit *test)
 		.ms = 8,
 		.sz = 9,
 		.goal_tuner = DAMOS_QUOTA_GOAL_TUNER_TEMPORAL,
+		.fail_charge_num = 1,
+		.fail_charge_denom = 1024,
 		.weight_sz = 10,
 		.weight_nr_accesses = 11,
 		.weight_age = 12,
@@ -717,6 +721,8 @@ static void damos_test_commit_quota(struct kunit *test)
 	KUNIT_EXPECT_EQ(test, dst.ms, src.ms);
 	KUNIT_EXPECT_EQ(test, dst.sz, src.sz);
 	KUNIT_EXPECT_EQ(test, dst.goal_tuner, src.goal_tuner);
+	KUNIT_EXPECT_EQ(test, dst.fail_charge_num, src.fail_charge_num);
+	KUNIT_EXPECT_EQ(test, dst.fail_charge_denom, src.fail_charge_denom);
 	KUNIT_EXPECT_EQ(test, dst.weight_sz, src.weight_sz);
 	KUNIT_EXPECT_EQ(test, dst.weight_nr_accesses, src.weight_nr_accesses);
 	KUNIT_EXPECT_EQ(test, dst.weight_age, src.weight_age);
-- 
2.47.3

