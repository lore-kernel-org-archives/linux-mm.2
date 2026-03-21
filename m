Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9419D1094478
	for <linux-mm@archiver.kernel.org>; Sat, 21 Mar 2026 18:14:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 028556B0116; Sat, 21 Mar 2026 14:13:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F1A946B0117; Sat, 21 Mar 2026 14:13:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E31C46B0118; Sat, 21 Mar 2026 14:13:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C59D96B0117
	for <linux-mm@kvack.org>; Sat, 21 Mar 2026 14:13:58 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 9924D1A05B3
	for <linux-mm@kvack.org>; Sat, 21 Mar 2026 18:13:58 +0000 (UTC)
X-FDA: 84570868956.06.47DBC77
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf29.hostedemail.com (Postfix) with ESMTP id E5651120011
	for <linux-mm@kvack.org>; Sat, 21 Mar 2026 18:13:56 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Kor2iOVN;
	spf=pass (imf29.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774116837;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qG0FiHq3122N0rcYK4oCE99i2nUfs/WX8BknwBpkd04=;
	b=x1iSErmk9gJTkvh8wZAyMn/mzkDRmRyOQi4pv1wNdfNDQZY43HyyucQ/1BpxJGoXMq2mLj
	jZzJ9TdnCLecY9RB8FVj9Vz3AvGmT2SB09CloyiObdHcdit+5vjjvWwd0YXii3vklXqTzC
	sqiKXfoYkW92JGmj4iLm/zCTDJh+sJE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774116837; a=rsa-sha256;
	cv=none;
	b=G5My8Y5bmdyTCGsBs6asLN4erBehfzKULJGFRgyUlIZpwSI255fnIw6C8F3GPoMvuNIHs1
	ZdmrAVrnmizK2qnthJi9nJubERVDSBwzpGYTXruQkppFGgrBwK3sx1/9kQ22PRPy1guPl3
	+jxTOc8E08j9BliQx32nFCdGKds7SoI=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Kor2iOVN;
	spf=pass (imf29.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 72BB64387D;
	Sat, 21 Mar 2026 18:13:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B7D0C2BCB2;
	Sat, 21 Mar 2026 18:13:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774116835;
	bh=O/0+EEFKC+kJrViTx1hpFrUcUp3ITetgY1I7Ly2ASvo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Kor2iOVNzoHJxwalPA3UN6OFYDWwAC1kmeN820N7EAGmtJnCbIv6S4kDN9nIHOG05
	 mpYVKOolGzmcFs+MQ44P3fHba8boPFpAwMewe93AYnPZvtbDOPf5HZwZF3/xCA/pg+
	 gq7dOC+FaboQe69izaNjXYEtINgs564L+7b4VTobLG+9+DRlU/L0mwXjT0dsCXka8N
	 ZB9rA6ATE776eUg/zNe/6FvZmda0ffITAfmlzcOYThubf8PF4VmcriVZ5sH07ZZrfv
	 oBSBqz4LpJ2yhBe+RT9MwWtZ8O7YwKRXnWdKgtlGh+KzQ9BI/4On207Wd5PKORu/Gx
	 0vnXK4HbEXneQ==
From: SeongJae Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SeongJae Park <sj@kernel.org>,
	Shuah Khan <shuah@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 09/10] selftests/damon/sysfs.py: check pause on assert_ctx_committed()
Date: Sat, 21 Mar 2026 11:13:39 -0700
Message-ID: <20260321181343.93971-10-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260321181343.93971-1-sj@kernel.org>
References: <20260321181343.93971-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: jm871ap1c58tk38fezi3zujeofz4xe5a
X-Rspamd-Queue-Id: E5651120011
X-Rspamd-Server: rspam03
X-HE-Tag: 1774116836-717872
X-HE-Meta: U2FsdGVkX19L1JKDhjUSDuE1Qu5ahbxRTQ8j5tmpLN9Jx4Hmrgeg2ivX29dgcyPLXD7yXQObxmh0WM8royNkIlFXS2aFAfLy6nGeS1oZOm39pWSOz97aZybWts7E2lvTgiCccYHjaFeT7Pr2Cmhkm6rXSrUGgL+VWwr/oJQ6HzRCoAl4BWcixiGxDxcRHFioBN+ZATenKkt0VYx+DY13poaJ1oqz0cBxwbM2D6DZSgFS+H6HogyPrYfjFWHTlscSVNxvTDqDNmqeaOCZlxPfje4i0M529fDhBwsb4eCt9geWsYVfrl5/BuZ90A9S8Dn7QcaGXHp/cx0L+LKyvhmmS09ENBve9CPoGteevq7ogsOqDGXiVc1MsNgnVztjEcx+bihz/vPR+fAhTNb2AZSB5i3cN1snGoXqr26mnjLzEDz9gfB+euc+VnL+l4cXwk8ZLW1fjrRiGfdzwh+nAGcae5L7Xq/GpidqPfzlH2jUafS6e6z3b45p1h8XxKgxPj2buG1a2xmONEJyA+V6slGwnTxPhSDHH2hEACy7ZxGfjvijNs0g3vtMeCKEW9toUIbbBJ4P9bB/DkFA1c4ucDuKBxLI2SpWY+hQ4YYYYVo7WGIEPuQU2YohBqfXQQCuRLXwMD7Kvf3ov+FM1lLDkR/oibLxaMIXA+bAeofpNGHst59uzbBzmLLkdt9eQz6VD91w6aeWp0cRyZzvrsiJN1bZNna11qXE7aSsaqqTFx/wJB8IwH1tHSyljx4/t4QXJH0KxsfZ6XXUvAgQGRUcs28pba7VFLkIwx+ZcJMiy/nN6hjzRWAMUWN1OSRUDo9CwW+udc9y254sAVaQE7mxICsl6dwEoa4kzOlkyROO9/QPVKumTGw2TtDFqbJWsJ9APxdwc66ENJxHo3Mj3yhnKD59pvLfFLBSL6+3dPJGctk7D0llQnh/toF9qmcv48ZztqiYykWEdzrnGlDBkZKpVGU
 c86ckHa0
 VvUmWECBv1lKl64UG4YMcOxp6Ed33UdKVswiaub1jn/z9TicgGvOHm9KiWZ/93QywPbxQUgKt5JGV0tnUunTQiZbbtW3Re8TGUg+6Cw43RWLXc3WjlpYLXWbhx/JM0d6M5w2BYnZWyiIjeIbcbUc5xAxRYSeam4+LnwB1JJcTiz4CuZdxM9P9ccuWSmDYjz2qk4qUMOwAe+7eSYYRfJDyxaFgYTnPWNJONxcTfevnupIQsTXftK0ArOjSOYhbNhYlyMGtMsOOoJ8SLAMp1W/vSr4/ngvQ8b/Wu420CkLgrQaQK0SGdlsyunLJDQ==
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

