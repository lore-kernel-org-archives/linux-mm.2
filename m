Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 247C8C61DBD
	for <linux-mm@archiver.kernel.org>; Fri, 28 Aug 2026 18:37:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AF9926B009B; Fri, 28 Aug 2026 14:37:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AD0A76B0099; Fri, 28 Aug 2026 14:37:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9BF0A6B009B; Fri, 28 Aug 2026 14:37:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7EAEE6B0098
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 14:37:01 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 067D91A0531
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 18:37:01 +0000 (UTC)
X-FDA: 85151535042.01.995EDB6
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf09.hostedemail.com (Postfix) with ESMTP id 711E614000F
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 18:36:59 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=T05ammM8;
	spf=pass (imf09.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787942219;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+fW2+xE2H0LI68hS7+oEWra7KzRlcB7nNxeFxWmibVg=;
	b=zp1M7HEppUqeom0+g+PmpCplh153510va6D3zPdN92AiHX24OZtjV9OXQSBx5moOy1Yb8J
	fye1N465j4ccZcsbJK7JusGuSWfyD3CbbKjMo4++Ew9eTS2BEBYFZbMNfIh5O08cUTlpc9
	0j4vuOPdwQyqaw+q2rs3lkpAd9g7kk4=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787942219;
	b=i1rQRdpj7dOzkfeQnEgufdwVspyD1LibVH3lQFbsSFBfxlfEmiF9vsyvJbOWVP0hwAGE05
	modQmoCR3qViLDAD062+8rjw2gQn+1y6NEo9iB6NGZdc/T3soo+yU3syNun7Im20ZC4Eq2
	b0aTnbrl/v8XNBky4i4/xdv6wlqHQ2o=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=T05ammM8;
	spf=pass (imf09.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id E96F060209;
	Fri, 28 Aug 2026 18:36:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 555551F00A3F;
	Fri, 28 Aug 2026 18:36:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787942218;
	bh=+fW2+xE2H0LI68hS7+oEWra7KzRlcB7nNxeFxWmibVg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=T05ammM8ldq+G6bXx1kNn1wOtHyf0oeGDeu71AbtcDekKRYIydOLwGmjIc9uhk9X5
	 Ir3MfGZmKvcqnkGMsfP8dOUx4l/yB+CvyNAfA3lDzGNCMD6g2BPsqrTtwdNJVnoCvx
	 x1C585X5TVS6xngWNLwcL2NnOeE6d7obk61ADtzwmfTa+0WnSTIjclPNl+itxnCpcT
	 mRSGfb1O64QAV7SL4PK/Szh24CsX3fnmtH/wtaGh+HCbK+a/AVTQwgQzNpUCLY83SI
	 EmDj1bcECwJxe8t9cIV8/9Mqx8I4Y0Lxjh0L9855tu+uInpjH5wGvgdwEQS1SVkFl/
	 kCjORItPBKqAg==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	stable@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Brendan Higgins <brendan.higgins@linux.dev>,
	David Gow <davidgow@davidgow.net>,
	damon@lists.linux.dev,
	kunit-dev@googlegroups.com,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v1.3 1/4] mm/damon/tests/core-kunit: test committing psi goal to psi goal
Date: Fri, 28 Aug 2026 11:36:45 -0700
Message-ID: <20260828183649.71192-2-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260828183649.71192-1-sj@kernel.org>
References: <20260828183649.71192-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 18t7s86rrbg9o3ny14rg6pbrufxx4whw
X-Rspamd-Queue-Id: 711E614000F
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1787942219-910783
X-HE-Meta: U2FsdGVkX19qr9zqOJY0mV+d3+WEpGwojoLCxeVfgD1JWed6DdPPVsFFjtL73/6wvh4xWL8tSbZSOdhu5RDXMr8GHZlB74K1OWu5Plohf90qJm5Hh0mSskYL0CzfEuj90G8gA8xySWafajfdFcH+woCyUUFrFjL1ntK4ZI4lWk/2kWS+hrgHfae/+I7WPdMs+Mr1MTIVjMPoT3DMDXVFIHvCdtujPzwDWAMvsR0eQxuNZ2hiedpiaqFNqaJ0dx3Te4r+5/fF7Z3ngJL9NdFo3Lk5agBs8CMnmg2nIk8Bd4WcEOsfK9rB2JzZkVis8VESbQZPaBKWPSDQOdpYFtFiMEPMzJU4jlkmqoH6oSmUXquB0XKNH2dJdrnZs7RKDK3RpvPkrdKK5i/bnDE+x3BIucjLLVT7ez2EqI+F1ENFAA8PxCEVIelzRMGNM8dPSA6j48D/PG3K1EgsOmIhqJkt5Y7PzCCUn6n4b0j3GG/kI/aQHwUYZ/IXauAF7xN7GQXccwEyKncaa3vCSwhTLr/1SYaJ1JHyE6eHKZxTrliwnHj2KBXtjXiPxfHfXFjvqUcfZ5/RoBEz44C/lns2QjnzSngVvaR75v/zGua1HuOXhzbvYQC7QF6wCvvOb6afl3WSpjVOHv85ZtfdZro6COtAlB+AeHAzXmFeohKhwc4Lv+pyqQA/XrGSe5xj9ZI//Q1ktcuuxQZzEdZmlCysSj7kyH5RSWZIzIDtlgixH0TmWUgMb6QSuWzWkyrB+CCM+GyGIQQWZpfNB2zK38QafSzQokkFbNecwXkQfxz+LlosogZPOTpoc1lc+dgZaZmdhz1D8UGax4H5S2+zM1RVLvOBbBNeVmdRPx1co81Ue7W86ncbToXl/aoArdqd/bkV+06YUxHEDSNlPvUwF88/F1J+lWD9a1IvPBGIaD4OY7d4e/dI91Tywl6CF9AB09IYQzpt4L7GFxEz3dcJwwvPMzl
 N/FZBtEV
 fj8QGVzNteQ39dsKlbD+wduRQZeCl9E/xjR1gK4cC9IgI1+mSsB3qSTxNJlLJfjAvKzA3Qw4Pge6160n5STp/4OBZjNN0dAWGh1gQpoJzQxxC0YUEQnjWX9DC2qBIYXYAhq5N0UubIRKnZywega9y7y4x/uUHo8Q1X92kzyPXvp9yhgHsdg4Ajx3izk4x9SuByBG5tOHqZdRW/8CywtRrTnHdUiQH3W2H5HHGHE8P8CuvfDw=
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
index 4a536d41cdb2d..b643f9a83f14a 100644
--- a/mm/damon/tests/core-kunit.h
+++ b/mm/damon/tests/core-kunit.h
@@ -787,6 +787,13 @@ static void damos_test_commit_quota_goal(struct kunit *test)
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

