Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5D344FC72CA
	for <linux-mm@archiver.kernel.org>; Mon, 23 Mar 2026 23:16:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9D9F96B0098; Mon, 23 Mar 2026 19:15:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9548F6B0099; Mon, 23 Mar 2026 19:15:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 86AD26B009D; Mon, 23 Mar 2026 19:15:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 67EF76B0098
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 19:15:48 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 2F9908CBEA
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 23:15:48 +0000 (UTC)
X-FDA: 84578887176.14.D3E46A1
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf19.hostedemail.com (Postfix) with ESMTP id 890081A0005
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 23:15:46 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=NPKMVkDO;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774307746; a=rsa-sha256;
	cv=none;
	b=qYt93pM4ws9jUGM+NRvJKYD+wCXbXq64VM/h5k47tmru0n+uKgp1YzNC/ybg5JUq1lie2y
	5Xe3TXWh9tBHi6ISlB9D2wVP/HAIINeJkPO4UOX/TYFqb8XcBqUa33UkA5lJU3dbbOSrD4
	1Ib4ajXy4OAA+ilVj3+Gb40sHeXp9gc=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=NPKMVkDO;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774307746;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qG0FiHq3122N0rcYK4oCE99i2nUfs/WX8BknwBpkd04=;
	b=lnzu38HsR8I5RB/ROwwK9/gZduR/tT8FfhExkC1uArZXxCXxnCEFshX40euMl0yk49ZFbI
	qiY2N40FZbdfq159OvdJ6RG3wL/JjoybkazgAmllYE1MEb/BJx7Q2HULHwFF7bQCm+yHIz
	ST6qPLudW6yjmFreN4M4U/Ytr7M8WOg=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 119E94457E
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 23:15:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF53BC2BCC4;
	Mon, 23 Mar 2026 23:15:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774307744;
	bh=O/0+EEFKC+kJrViTx1hpFrUcUp3ITetgY1I7Ly2ASvo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NPKMVkDOLtco3B7ZLPWAa2M8E1Ji3gZ2aXUcvMFntuLnLoYLD8/IJ/KasrOEe1jVU
	 Zva7aSnjH4FY3VCXaA5PM/39iceh62guADzcpUrE7xkQa5ziIHHv1E90uONN2BVvhK
	 SEu2mFYHCYtNmGOZrPWf3UARAkKM81Bk1wpM8D2Q+yLE8/aRvvlmzw6qxePYZtGKXR
	 jyb9DKLk2vk1Bo7rHriQ6pZNjaldjP3Jmyu6j9nTLVSdB5gR+Yd3x+1nAPpfCUPPGB
	 3h9AIKo3zyzqRlyu3J5l0pmodG/xArbIuEd7T9IQoi0tgD6Tsb9xm6O3MDZwzmAgGQ
	 2U5cqTpz6dc0w==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	Shuah Khan <shuah@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v5 09/10] selftests/damon/sysfs.py: check pause on assert_ctx_committed()
Date: Mon, 23 Mar 2026 16:15:34 -0700
Message-ID: <20260323231538.84452-10-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260323231538.84452-1-sj@kernel.org>
References: <20260323231538.84452-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 1kwszcopbx44a8dbsz3g9mczeubeifyg
X-Rspamd-Queue-Id: 890081A0005
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1774307746-996461
X-HE-Meta: U2FsdGVkX1/tDXxUnRTZQUJOn0IZSiCLgcVgsA603KHeZGRIiAPWAnCsmdtQl/bISHOgwabca3Rs3CQQ9y3H+ufeltDGkzvAb5IvZkgW3GXExeLMW0aInOiTBuv3a2M9TSN1BDiS9gh3mOlRxjYoA+XEvbdxTOT2rlc4D2RqAa2CzUcg/K8sxVDnDAOkmFCb2Ycgx9RX6SbBelmzAmkXsDEK8ktLmrrrdrFt51NPvFaakmwAMo/ncTePoRV5b/SzFSE4dUPUmrb7i/246VoyrNjuZkOLPXutOM8cu5SOLeUYzDnnrqGr69sRmiR4kT4CI++bMdudVzwj3LYtZa6QzoW8hSTONTVeTwGmqZssaS7gYkVZzK+TLv0a+YuDz/JAwxg67uea8q0IKNnwyKMCLBZN+YBYld4buOBgpMPGNpj0fJDQG03LwlS4Xb22xgpCwqUngTP0JjiKAz6GJ/3Vn2oOdTMz724Lte3lyXa3qYe/VC9U9qXLGYu3BUIlKJZVZ8o1JdPBTvuOpuWKHEFtTsLILVEvY6CEnEhk1mIqPeswlfIpWqOXqO3PeG7Sh3H3LCpYEv/kOA9uqpXG7XII0UL1B4BQIwVd75tHLHUvVAgJ+Mt+Uu7RuESYXJI910vSXE371Qo/cJRchgmPO2svJcKXFTtbV8pOSWYnqtnJxzlpYfbj80U6rXJK44tm5Rq0/kk0uam5qDbxnrgRor/v7s9qq0OkS9mSa3GW6JgqlKHJuwxjNQsTqcE5Xln8do7SNK4iE+7h8QVEo6pj9hsQHMS4WQHxDY0WYL0c0zxpCSC6jm3S0680cmOSE9rAEZQ/+UhSwT32VZQ55NuugAXDLJS87e5r7qMvhhOn8qP/04aqifQm8NR3OCJNVXy1Vsp1rYifuuUOBHEsDvGTYxvQF3QAlSZ+VihK3j5Z0b7OzyxxE/KLgni7Z9xCGVoNTc1hD8nDnNRHndV+zh9nlQN
 IAy4avM7
 +4zDl0cR1tAJCHemxd3EOvtEaBsB+/xfyUZ5TwBx9WemOxtDxmOX8072m/AopPQ46S5ko0b5NoNx/D7rweyzQFSlVjF7VYCQMlwaU/gDxkrwILjiGGJhGLnqe+o3eaCQpKDUHzAUxZVvOmlYawjyzmPAstJ3x+unCcUiQZVMH4oON2df61nRJ1YAeiaLs/FEYlGhJzdqe/iJJCliSflnGth1UzFQIhbN3c0yMqTLgcVgwsm7o7D1sydjSSRjfXwxpBIRhYaz8G9RyAXNCdJTyNAwF7dFDve62f6m7g87Aa3CyAfwMWMW8Xbzigd4P9Yv4uEHzPhgvzrilEfEgbBoBD8mJhhtSs0oPRPYOZpGJkuONr/+n3b1uOfd4kA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Extend sysfs.py tests to confirm damon_ctx->pause can be set using the
pause sysfs file.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 tools/testing/selftests/damon/sysfs.py | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/testing/selftests/damon/sysfs.py b/tools/testing/selftests/damon/sysfs.py
index 3aa5c91548a53..e6d34ba05893f 100755
--- a/tools/testing/selftests/damon/sysfs.py
+++ b/tools/testing/selftests/damon/sysfs.py
@@ -190,6 +190,7 @@ def assert_ctx_committed(ctx, dump):
     assert_monitoring_attrs_committed(ctx.monitoring_attrs, dump['attrs'])
     assert_monitoring_targets_committed(ctx.targets, dump['adaptive_targets'])
     assert_schemes_committed(ctx.schemes, dump['schemes'])
+    assert_true(dump['pause'] == ctx.pause, 'pause', dump)
 
 def assert_ctxs_committed(kdamonds):
     status, err = dump_damon_status_dict(kdamonds.kdamonds[0].pid)
-- 
2.47.3

