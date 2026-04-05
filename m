Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 81B46E9D809
	for <linux-mm@archiver.kernel.org>; Sun,  5 Apr 2026 15:12:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 592176B00A6; Sun,  5 Apr 2026 11:12:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 520B46B00A7; Sun,  5 Apr 2026 11:12:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 40B8D6B00A8; Sun,  5 Apr 2026 11:12:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 1B1F56B00A6
	for <linux-mm@kvack.org>; Sun,  5 Apr 2026 11:12:43 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id E57F21B9107
	for <linux-mm@kvack.org>; Sun,  5 Apr 2026 15:12:42 +0000 (UTC)
X-FDA: 84624844164.13.5BA2507
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf13.hostedemail.com (Postfix) with ESMTP id 5133C2000B
	for <linux-mm@kvack.org>; Sun,  5 Apr 2026 15:12:41 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=OAhxzr1b;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775401961; a=rsa-sha256;
	cv=none;
	b=muYspodZtFHAUwFZ7rb7H3vS8d7+fgVVPSHc3HEhGiO0GxhDcOhbGUCVQgcwzyMcWuIOES
	oNtCucA8ZjShNs856CNA7QvROmxp50PUp6CxvnvTuihB5FGVjjXh5WXh0WO0cndKMDIqFQ
	Lqya7beiswaCKQt1iysEIQB+GbiSKyg=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=OAhxzr1b;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775401961;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4joi/1jxL0tMeoK2jtxaL6glpzvmpSwsvYu1Z1ZZFRc=;
	b=Wg9c8/mdYBfVNGeSk/up3Rl1ZyHzL4+YQFN151nwyb31elg+OOSrtW6ySD6KGiKG0bQtiK
	6C9XQ99LmUH94RcBzTK2TTCJCwNNKOqcRKephIOKRJ8ACUWYoswa3qdSSi5RPqz2r8v1jQ
	s4N8V8IYeAZhc0n05xGSfZPG8sCOGHY=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 97B9560126
	for <linux-mm@kvack.org>; Sun,  5 Apr 2026 15:12:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A86EC2BCB3;
	Sun,  5 Apr 2026 15:12:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775401960;
	bh=EuOHul4fripHvwsgWhBfbomSmWCRXpHL6QQJMWdANgQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OAhxzr1bnG9SRGkzpc/ub0X2fD7lRQkA+jDr+LOlf82Il7d0WZ0uWYwGgfTUH5VZu
	 0nhkRRCNPT85pSaMyrB5mGedggPtTX94tKYtlUFPsW96kt55LLkDr4vjQ/R6MQvNpZ
	 aifQQXagGzKeQVGaRM3W/UJ2lYk/O88enXmPRbAUl+9iIM7O7+6U3j4vDCASpdj3b3
	 bSLDvTtrjkJTAxO0DCeS1igoS1EGBNjUu3K6TAB/nm6jEb/j98dYMuG+v1HdFoQISE
	 ABX+N33zGMNfSyZgbCZdou0BWAbEUCXr9KOgoo1HX9E0hdvQftzxQ2LPs0MkIcIPoJ
	 hMWehmld3pwHg==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	Shuah Khan <shuah@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v2 8/9] selftests/damon/drgn_dump_damon_status: support failed region quota charge ratio
Date: Sun,  5 Apr 2026 08:12:26 -0700
Message-ID: <20260405151232.102690-9-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260405151232.102690-1-sj@kernel.org>
References: <20260405151232.102690-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 5133C2000B
X-Stat-Signature: org6bp4mc1u6ja8qitu36jf4k3d3cg3p
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1775401961-356727
X-HE-Meta: U2FsdGVkX191GTzMU7cM3TNW3rOZNdOR1FceBO0b4JRuIY8ugYjycPbJlbSarWGLE7DX5R5JE7bU35g3yn3AAyHm/nXe8U44bczgyuLT1lfpnrR1tIkq26FLbVevLAihtFcjebpVRZ38aKnHW+THaMB2dE3hfBlBI9EowVPYVu6w6oi8ywBxcBQEAiIjfllwf6dEcF+OtHSMK7Tq2BbFZPZlTSwgxyV6t2BPAqDls4h3qWQCW376++nrB2dS/R129LwbS6c97b3lbNveaTgrQxLvudtJ5M3XB7ddILQccFbvcLSnVDYb3A3P+BlzvOXHWninRNwMY8n/fkg552tC1IrgjCyrsbskMNbly2ILvpE7GQQV8gT3l5rZFtDjMWqf0pCIjX7tksCWLxFEFvF16aXjbpDNoH17u4RD9+M3drLZzprMoJgiSkt9cbnkv90e4IJiynz/mtTZdefTZxcMl/qyr50dGVyiaZbgQdEB0nKTlZy6Ins6D3HLWZ8/4m1AEFioggMdn+yS65IbDDTFDGXQq7BZ87BnuAYDC9MMbpwFzbYnJBdaZqDhg4E1wZa1nL9nm6DDhS3ZIuppa+ko6g65E7pu6WloxgFDlfN37Td7y7XXd6TA1Hm0vAhS6YAr/VWdet/AeNbnjk12riNF6STEC1k8FJVXk0uuwbo810U7OnvBewC4qgB1666fmAQ5LDYnoQqaw+bR7zRCaT7x659etbOeBJbONfEYmp7+qW1mwYIbQuGGSZaFmtjsZQklP4z9EkEXUGzA4m3lZUUvqoWBdUUDrSNKznMawUuTJchc3+kd96p3cMmLAJ6HA3TW6tx9QX+VP1ceTyCj11yIAf61MaXfGkInqqKxDqBqTJOoJ8U9C25BAHdsKrKB0neRPjOcTF2dfVECK2FCMnZJBVkr1nmjKlERZF4LSA4R018pDJamuTMQMCX8VYbXX7Igw93MHkS5BJw/FIdvIX1
 Ydmic/7/
 IDeWO+2uEY9g+nlMz+YxiG0InCZBHKz3HTnfxP5jDo/7p09Lopu8xYp+rrirjqQ6YhoqnjUspb9o6XxdaISoqip+foSHNFuTTopTtfKdRVVOqK4BhR4E+N+h29zJXnjrqy066wID4plKRWswJx8GOuH9NIOqq4hiySa8PdvQUmnQH+8CpBekbJ+FPU3lrYNiDVgUZ9rouypr1DrFKnw+vGgI2opYpxsNOtL90wwUEml1ssqlqx8knEsDx4fAcvUHT5+fsdcmmvVdxpsVuLiZ/iS2VfEg18/DkI5dJW0q9zxsoAKnwuNn+94LnzsuLa9IN+ygBOOJg7WlO1/fajKcwHjY4Tw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Extend drgn_dump_damon_status.py to dump DAMON internal state for DAMOS
action failed regions quota charge ratio, to be able to show if the
internal state for the feature is working, with future DAMON selftests.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 tools/testing/selftests/damon/drgn_dump_damon_status.py | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/tools/testing/selftests/damon/drgn_dump_damon_status.py b/tools/testing/selftests/damon/drgn_dump_damon_status.py
index 5b90eb8e7ef88..972948e6215f1 100755
--- a/tools/testing/selftests/damon/drgn_dump_damon_status.py
+++ b/tools/testing/selftests/damon/drgn_dump_damon_status.py
@@ -112,6 +112,8 @@ def damos_quota_to_dict(quota):
         ['goals', damos_quota_goals_to_list],
         ['goal_tuner', int],
         ['esz', int],
+        ['fail_charge_num', int],
+        ['fail_charge_denom', int],
         ['weight_sz', int],
         ['weight_nr_accesses', int],
         ['weight_age', int],
-- 
2.47.3

