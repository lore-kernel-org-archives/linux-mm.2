Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0E2CBCA5FA1
	for <linux-mm@archiver.kernel.org>; Tue, 29 Sep 2026 08:01:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B071D6B00B4; Tue, 29 Sep 2026 04:01:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AB7C46B00B6; Tue, 29 Sep 2026 04:01:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A1CC76B00B7; Tue, 29 Sep 2026 04:01:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 826086B00B4
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 04:01:33 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id ED266C03E8
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 08:01:32 +0000 (UTC)
X-FDA: 85266055224.23.75E2D9A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf12.hostedemail.com (Postfix) with ESMTP id 51C0040012
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 08:01:31 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dSnpH1JM;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790668891;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=p5MTFE9QQQXmql1Ff0uVbm3O82yXZG24baiyBpjdw2E=;
	b=NlcH7qrrnIyscgIPgeLzNTi7I26S+mgVz0nrjjFcsfeWX6MJPBqPxLf/oSCtxNnLilYC3u
	eeUMkQhsPY9Ca6K00F/4jav6bfP6VNh7LRD03pbm9oWcLbtSTPEq3uZXcMiuM1tctXCVGE
	LAruKzaYBMbC9y+UXgBFQukJ6jpxPN0=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dSnpH1JM;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790668891;
	b=t2iUx4Per3lMMFgSwWXQdP1e0ZmPRmx5qgwyVgIVG+V8iTHeFLwf5cvw1hd2Eok5cUbE/Z
	nEDJf3Oy84cEpUsEhyY0y9/HPuCuct1ybvHezx8lz9ndDpH0p4QDD5SdtiTVQG9U4FoVR9
	R0O15jFxiAkWtHmrhopPStUNNV9Ew74=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id E07EF60210;
	Tue, 29 Sep 2026 08:01:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6F191F00893;
	Tue, 29 Sep 2026 08:01:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790668890;
	bh=p5MTFE9QQQXmql1Ff0uVbm3O82yXZG24baiyBpjdw2E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dSnpH1JM2kjxFrFhZEEdGQLnXTe5L3po33HSo50kOWWKDntUB5CC1VCBLe3pK1fj1
	 OesJjjjzMVlpx6QF9Yh3yoYIfLPReHsonNofbWRi8i7SareKzMfMaCehKAspL2A4Hw
	 TWDOi2ISRsc5Sx6V4n3zh+EjA1H+9a+q/5KS5VVX1aJKMeGLgtgI3TWRAsYIdyEoVa
	 r0khulDsgHlbykBniD2OQUV2UlnIc0BHtlpXkaNINrNnpRO0+SgnoA0IE+3GQxdNVP
	 w7pPOiGEAYjM6rpMqrJN9sJA7uliClKHo0iU/nltPAA1tm97208lD+LqhG0q37m1Xi
	 9X+HZG8g3DwzA==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SJ Park <sj@kernel.org>,
	Shuah Khan <shuah@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 5/8] selftests/damon/sysfs.sh: test quota goal complement flag file
Date: Tue, 29 Sep 2026 01:01:08 -0700
Message-ID: <20260929080113.41708-6-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260929080113.41708-1-sj@kernel.org>
References: <20260929080113.41708-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: itbjut36t7qehta6a8xqnudz7qnd5ad4
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 51C0040012
X-HE-Tag: 1790668891-22395
X-HE-Meta: U2FsdGVkX1+/DLZYjRLhShVXxRZNu8RyTgyYEqBHK8zd5W2hYhg8ta0TkCXd5PywMTYhXpFxREsEaMrdQB5eJJhIbAjLRBEsqZj60z+Q00mC2VJSL0WOr1THMF4OXBwZ1HJActBjVpEdnWL81kK2NDkzrHl6l9lTb7NDN7oVAt2xv87LHBgsFAVwPPwZxM+cy4SWzQf50Z0GphQkA9nPZ1fnBnqmIX1NJc3VFXVQhl5g2147VV73VqT4mYcpylWINJ6BkTFHfT+POehLH4/o2cLlhYAOXLi/MUtszb7SkmroMFxdxfLgVtBQsbauquD/uN33kizyPMHqDlAR22osm1CqXeD0gbRD92LmnCy13pLjz4dAQ9d+Xtm0EyBd3Pfj3DDk1bAiVh0feu9blid7GBFRjlEi+2AI9VTMzDhZooq9k84JIFk6zu07t2DVSZrmBnJOq2v6HAABI/A8AmNfXfbHUPpzcvB98wDQ/l8l8I5TW27ArgJ8USHq0lh270NOUuV/ufV4GTc12Vp8LwCtb8OllZ6UfZaze7PthbYou72z5jW8JPZ11uJR7BHRdpaNASaP+jzGs9SQxQlM1gBc8F+2D355seTDoI4uJ5bcGgPM5CRz7joFHjTqPs8vaFiBff5Kc4rU6aueKRMvVtpT3jZLjLffE3pGZit+y+PJ6qrdxSx96Zt1mJw+OyahfNxtGMIfAagKyoOirjALttD77lpdI6R4FFhJePdUrMqZjecoPtpYlI5WjAKFG8MDMgTOjq1vixMMrDtsHZ1y/81RaVBFpwi6FIP4RMaG/4K+YKD/snx9HKclP0ssrC2aCGpjv8gizCUEJiB9PwwHwwjD8RKQ/A39wnaAIAICwzyvmbQVSgulCu0I0lkqiT1dFRFSUu0Pmb0zczTEtxqXfW+NoJ1f4Tx6zPkKCPXc4sYzm0iNzJBUFjNJViSsTsbxbeg1ZXTkYbI7PBgXQB9OoQo
 ZgZ96Kb4
 e4rE6yuhzCqWJZKV6mjBh2nhFZ1hrSBWskB7XA08q/PQa0x0bJkJ4NyYXhG7bgppI4aF7ydQgQo8ZB6Ie30vA5E9W97yo2ORgRQveRl3dT9jYYQ0QJ1Ites+ANaIf+LsC6Pr20pLLlLx4BGOdwU5PdHurPRTTOEuFo/Fe78EuF/ZYvtFTDXXNbSjxiroRB0n0Dbcisq1Lvsn/xUbiAnRo4Al0HcM4MPk/cSPePzobwRmbwpg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Test the existence and the valid input acceptance of the newly added
quota goal complement flag sysfs file.

Signed-off-by: SJ Park <sj@kernel.org>
---
 tools/testing/selftests/damon/sysfs.sh | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/tools/testing/selftests/damon/sysfs.sh b/tools/testing/selftests/damon/sysfs.sh
index b66593c9ac47..1cc7ab2d7e22 100755
--- a/tools/testing/selftests/damon/sysfs.sh
+++ b/tools/testing/selftests/damon/sysfs.sh
@@ -212,6 +212,9 @@ test_goal()
 	ensure_write_succ "$fpath" "node_eligible_mem_bp" "valid input"
 	ensure_write_succ "$fpath" "hugepage_mem_bp" "valid input"
 	ensure_write_fail "$fpath" "foo" "invalid input"
+	ensure_file "$goal_dir/complement" "exist" "600"
+	ensure_write_succ "$goal_dir/complement" "Y" "valid input"
+	ensure_write_succ "$goal_dir/complement" "N" "valid input"
 	ensure_file "$goal_dir/nid" "exist" "600"
 	ensure_file "$goal_dir/path" "exist" "600"
 }
-- 
2.47.3

