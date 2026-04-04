Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0E62BE63FE6
	for <linux-mm@archiver.kernel.org>; Sat,  4 Apr 2026 16:40:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 520B86B0096; Sat,  4 Apr 2026 12:40:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 45C616B009D; Sat,  4 Apr 2026 12:40:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 372186B0096; Sat,  4 Apr 2026 12:40:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 14EAB6B0099
	for <linux-mm@kvack.org>; Sat,  4 Apr 2026 12:40:00 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id D7FEBBB996
	for <linux-mm@kvack.org>; Sat,  4 Apr 2026 16:39:59 +0000 (UTC)
X-FDA: 84621435318.28.F08C7C5
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id 40520140011
	for <linux-mm@kvack.org>; Sat,  4 Apr 2026 16:39:58 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="XT6/ux6/";
	spf=pass (imf23.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="XT6/ux6/";
	spf=pass (imf23.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775320798; a=rsa-sha256;
	cv=none;
	b=DCNqBIAoBIcJko1rgiQQx3NIIY7bHqA7asRGKQQyauSA+LJEJnLdlHTOmrv43mVRIPBvSH
	WjPoA0tNbHh4MQWHwSFzuIz9s3iXA2Z7nQ9eRnEuO+DYTM7c6vezsKKZpy61HNwUeR/gRs
	oTv7HIDpLkssIW7e7HZb0EzDsxMM8cM=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775320798;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4joi/1jxL0tMeoK2jtxaL6glpzvmpSwsvYu1Z1ZZFRc=;
	b=BWdIWel1cvaPm97czqxEn3E2fXKxf8y03j3rdFwKi9zZLpGWLonR724j03CUEagV62TzqL
	yFfiY2zH7AivTVm6waaTiWpLA5vcLJ7P0jnRVRaFiWbs3UKlNwUBU3BZTR0LmWlKfiAfjn
	5AhFrHAFlh4DbKQ/TY4FjaL1IbC2zEU=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 74C3A41885
	for <linux-mm@kvack.org>; Sat,  4 Apr 2026 16:39:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29B48C19424;
	Sat,  4 Apr 2026 16:39:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775320797;
	bh=EuOHul4fripHvwsgWhBfbomSmWCRXpHL6QQJMWdANgQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XT6/ux6/kNBlrwe1htvhTNCAIEdGvUZB675ShF8WnwYV69I4kEYGumhF8fcLM30nt
	 pLu+X+dtJ29r04akzFiQ2klABoTn5RG5O3+LmflOWKWb2TkgPtH6tAkXqguD73SgdR
	 sNm/Z7PTonuFopFRXQwNi2OX+x+v19d5mXesf+e09vo3pe3U1411KDNPWlyVjphDcK
	 5puN9zg5KkLAmINXErz3Q5/PFFPSPzR4zIdWAlW5wyZ+dZ8uEWtrShQ4aw+kW585it
	 nWcy2XMmmfMR9Mjtqe9hX+E9Nl1Xw2NPMBWTSekLQ5OQgt7jqRPShyRB96KRuoBV9A
	 3baCqkZJLGBIA==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	Shuah Khan <shuah@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH 8/9] selftests/damon/drgn_dump_damon_status: support failed region quota charge ratio
Date: Sat,  4 Apr 2026 09:39:38 -0700
Message-ID: <20260404163943.89278-9-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260404163943.89278-1-sj@kernel.org>
References: <20260404163943.89278-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 40520140011
X-Stat-Signature: sbcs3jytxma1ofqrg5wad1iio88gs9ut
X-Rspam-User: 
X-HE-Tag: 1775320798-716729
X-HE-Meta: U2FsdGVkX1+QZ2ZP04LZ8emPc0NA/qAXCG+SkT9B/WAxq5wqKOjnUwZuyGjFz7Lqp81/MMPZiddaOiCTBqJjJgnvCclzN4h/9J2sV42vy2Gu7kgQJbg4fTyW4+92ucfZi6KuPJjJbdJbSQXsn0bTOakDVnXdp29ovRqwfOZTF2wqgrqirx4RwN6wx18qm53ne9/O+qbJEuzZeyOg8g8oytlPpP/W+llcINXDRzk9ESJ0fU5jYBO+/1dvKAfkpJ702vkdnmJgd0iNdNcnXgztHwUx/FyQYHENO6SrMCqdsy0DzfIL532N5culegu9s7X3I95ZyGbFPUzEE9AoyWr/wz9oQ0leg5i3EZL3V0u4Z3LA3Z+TR9YGhlqb9yIQmXlYE0TOZF4CsOgjSgXSHvnp50hxw+JLLhvaAVLUE3dOE0XVlyOpbt4f0YAg8egl0pEGLXs9q0X9gwyDiEJXFlSc6QvQX8+TooQquOwF1dYMGAdJnHZyDLp2cIlZKBnx+voIdToRx9gfchPDeJ+v8nzoXjz1uU77ufqjbrOwUMQzUksEimEL0s+vckchZKjmiXQWgg1A3WBNSWXvGqDPaujvWITjVFw9/kLZRfavtd1LrxcUE+Qjs4cO/w3Bud18la2UKlzmZb7SJOR4Gr6kSzW8jzITUdsTtuiRTxz4pecd1MajfTz8AB8bE6eCHXjx2dmVon/6pDx3WHurO25o1LsW6nyxk/2NkLm0yHtNUc5MxRCgWgOTxo8FzXJyniNUQMba7tvBO3CE9KOPbwgAFokFse5bjYj1/bMr118rJxd3G63Cz1XCyKPRuua31/6TRPfhjP7+XERBvRiskRnkkAXTBxsRVP0eQ2XbUBTDvMC9ry55sMFQI1GoLwJQgKHG6HqGq0I6VTJS3udF7QzrN0aGjRMJ8VEGZAasi1Ev1eD8Nx24TOoWLvN+UJ9QFbeGFfibIG5Oeke+LD+G03rBT9I
 eBmC7Rq3
 GDZSJlZxPXZSNc6XFD6NuG3ODg4LZrlk1RvHKmq1ZJeLp0DOQ4AXqNq25V3IfAKML8FSsgUbsu25XNIjsJSoreVatA5lY1mnMBwWpXQKZWOYxua70ocz5Be9fv5e03pOV2pbgNn91XKTOku3qMcxWwNb+4i5xzftQeropmoNfjj3ljBt3S96jNHL3FLR9urWoM4LzdYj3xJ6KDWJgb4ws9Ikwh6J1f2PcQy5tO265UyKIaK8qyhG+lViXqB8zo7mJ8Q60ab6NvQdicCkri2tywYDy43bpmsGheIdvCw9nyQjwNobaLTRxHrmpMVTNzMmCMVFmBt0yGQQiuRNkLkK6LUVouNKgxz8KuQV8
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

