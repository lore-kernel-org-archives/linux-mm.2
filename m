Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B897B1088E78
	for <linux-mm@archiver.kernel.org>; Thu, 19 Mar 2026 05:30:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 203806B03F4; Thu, 19 Mar 2026 01:30:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1B2736B03F6; Thu, 19 Mar 2026 01:30:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0C87F6B03F7; Thu, 19 Mar 2026 01:30:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id EB67E6B03F4
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 01:30:41 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 9CF38C13B6
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 05:30:41 +0000 (UTC)
X-FDA: 84561687882.24.5519706
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id 005B34000A
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 05:30:39 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=JkAeejlL;
	spf=pass (imf07.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773898240;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qG0FiHq3122N0rcYK4oCE99i2nUfs/WX8BknwBpkd04=;
	b=vHV4cRcaztuSkt9VPyTSv/IPynO1QHe3NbHq0hRKYWJ91g7KjYg9rum+c+xRf60x4JHier
	Cz5tARrgFjO5sOy9hS3mvFfa9WtZcsvhDrG7LLUUC8DQR5ajFeGs9Is8T6wu3ix+VdaNLL
	MPnFQrwrlwiMhvmum0Br+ln/E0vsZ+w=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=JkAeejlL;
	spf=pass (imf07.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773898240; a=rsa-sha256;
	cv=none;
	b=p5RXtGWSGMOY54alwfjaGOTmcj9hY04vriIEizQlAeMFTVJJ8yfErhToL7vnb5SYStQNPh
	sfz/1YNZuW4HCPI984sjaaLzoEhhKbnOvJWXSekkp9AAVWcQVWbz7iB7iKntgMG8DvLj1r
	NLc34wTSHCFp91kDINkSpJLEqqOmxBY=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id ABF14443D1
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 05:22:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B41DC2BCB7;
	Thu, 19 Mar 2026 05:22:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773897729;
	bh=O/0+EEFKC+kJrViTx1hpFrUcUp3ITetgY1I7Ly2ASvo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JkAeejlLb2INZGMTagXHPmD0+O8ZKjh5Fd/EXV1aG2pLl/g6jZPq1Mrvo6C3VVz3j
	 Dtoq9xah3y+18e9JrM6ZFUsBbhxCivwTPWNWIF6kjZM7na4WuYT1sGb30QQFU1uk5b
	 1DP7vpyqeTlB91DbbkaQNDCOtT28PYNWqaoS2ZomHCPkaUKmsTteNIEgMeHcK9NXj4
	 ONRxfJTwwUpw92w/suTNZEna0WTn3Bwso985LWfWJCHIr3HwOSSUcPlYaUd9vdHEo9
	 F+rKzY9X/L7ayyFot0FhpuPsVyQfRUw1eWZp6UczBsqqJJAoicDXrOanc3624URkSY
	 4hLVq2xQdY0Sw==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	Shuah Khan <shuah@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v2 09/10] selftests/damon/sysfs.py: check pause on assert_ctx_committed()
Date: Wed, 18 Mar 2026 22:21:52 -0700
Message-ID: <20260319052157.99433-10-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260319052157.99433-1-sj@kernel.org>
References: <20260319052157.99433-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 9sy1cydx5mn5apt1ghonszga8gq1y694
X-Rspamd-Server: rspam09
X-Rspam-User: 
X-Rspamd-Queue-Id: 005B34000A
X-HE-Tag: 1773898239-384790
X-HE-Meta: U2FsdGVkX19j06DmmITb979lVc0cSCuxxDt9qlXCZFOSOXVU4oJZJ8P9qorYFCATscRlJDagtp0HXPdWjk+92Kc1BOz6Ac+7bng2qjQAAPpZPr62tWXCmwan/JgZ0WGFexI+XIoxmJbMqZTpiN9A4aFXRe7YH7ydBTuK90ChX/KEmr4IOBvooz3rfveg+WsjBughBrPGkhDciTB3b82Kdb1fnHcBiMD9kkiicizLK3irBTYs0YLYiqXIA8tVeSs5sfOWesQSivfdAPfdWD1yW/ZLCrpcT/9WNXEohvLVqZovMnE5rnbuA8MkE3JAPhZXbmJOPSSB59T2Ow4o1XVHEUcbPqETG9Rb80AMmxUCxpHZP7MppKp8In/h6i98AIh4YOurqmkAA4DHfm7EcTcRY0cvgpfBt19HeCif9cPzDAvynwxWUCgQYeYv/EJHVSDlZBJCwnWdbcEdsyeOLmPhiRBoccl1/t7xxjHoMmRielyWHcgjsTijP+3vqw7EukXMvuPPphHIIxJLp5vRJS8VOStDdPuIcYH7pVjzH8+zQcI/VAnomZUFXePjl//YIhlrTEihz/NJGxRQS2LdoY67ZNgPIvUP5arrf5pOox/EtrW+XZJjJrC3gi0e80S+VSUsAE+xx9grz86eblbul3add1UxANwNRiDp+AibLj/HfR7xzotOb1sx29lTnd+Ck4wYScKvzhzJDHoROHDEzR0ry98+U9qHyOwCijW1XY/E8gZQ/eE15QHJavG6FLvmWWz9n0mreTcXOlscTUiNUaiHhnrsNraH/HSndzsu6jUr9fuxMvoXcE2A7qYyinE0wQ9JBr2am6/tecRp7qAuI6HBM18OkK+juUA5Xe77qK4XCZQqjBOWvsR7CEpevRc+JPb0mAbdL1l1goVbjMD8cYaYWTZnsx2lhfApN91LD3NV2nEddgg4Dz9JEqqp3USMSnGgwoE3ifnASOgx6IwUk/b
 Id7SPtNg
 slMkBtDS7ycoRTO9kVO1pl050VkI0oWUi7rgktbPO4WKmyK7Bmt/kNggmUpdOWqKy/FvIQ5vs83/43ygQ0moTjE4jANU139DP15/bP2PFLd590g0O0/zsR7YrTSZEl1sdmkjGPbcTXTcn3XvvX/V9iiAFkQPznh4UwlLDgwW2WNHgSS4kLpBOx3deKBERWhm7tHILvf71jp3W4Z9fid0jW8MvMA0pdpmeO2MAamEXhy7/MCkDvB2xFKHwiGre9aX6WcKxbN4tpCsXehLawGQg5wIH8y+vfZkrhNHFHxp3xUhwYZpQSTr17QIwG+Z+UcGD2xefYmO1WjEEtpgkTOvvBWu+8CSiWAzbvmosKlerhbBT+fFUytjPO7lxpA==
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

