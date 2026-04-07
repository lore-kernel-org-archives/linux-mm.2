Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 984A8FB5178
	for <linux-mm@archiver.kernel.org>; Tue,  7 Apr 2026 01:06:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EE3266B009B; Mon,  6 Apr 2026 21:05:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E1FBB6B009D; Mon,  6 Apr 2026 21:05:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D35526B009F; Mon,  6 Apr 2026 21:05:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id BF66E6B009B
	for <linux-mm@kvack.org>; Mon,  6 Apr 2026 21:05:46 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 88BA81B8484
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 01:05:46 +0000 (UTC)
X-FDA: 84629967492.04.2C2773E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id DAFD7140003
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 01:05:44 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=mcfFgWl0;
	spf=pass (imf26.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775523945;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4joi/1jxL0tMeoK2jtxaL6glpzvmpSwsvYu1Z1ZZFRc=;
	b=Mz9WRuJOZHGf7sW9uieyzZRfomDo9KPl6OBkHuPUH6siZKwl1EgYq9ZPaFB7DA32KKLgtX
	ilyQ8ec/Y1OArHYh16iKGLbCbDdtWfLwvrk5k3a9y3EcVXaMsl7ZINkX9b/R1gOVfbQCH+
	azEDR8X8XNH5Nj/utGEEug/UuFoP0hw=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=mcfFgWl0;
	spf=pass (imf26.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775523945; a=rsa-sha256;
	cv=none;
	b=lucizlEP80+GiO5E+uk0eA1vu3PMWZhZw1GAlKypH5UwAtw/ceb29mb/0Qc6qc6GNCmO4b
	tFD1NXqnDrY6tJEuCHVShsVdN/oVxtQHRu3nq3kyzMf50X2Ax3Ft94ouYwITwq58XuFDcz
	NzxOF6Hok1qNlSiuw8NNtP1ioKWl1ks=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 0046144564
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 01:05:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E792C2BC9E;
	Tue,  7 Apr 2026 01:05:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775523943;
	bh=EuOHul4fripHvwsgWhBfbomSmWCRXpHL6QQJMWdANgQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mcfFgWl0wSbjxpNVJs8/dkU9XnwsM/Trq3uFVxnc/VzfDu/QnRptO3YCzH1Nd6bKk
	 Sdhu1R79eFEDSYMWVIcXjDRUaV/4HqF0/5FGh1oDPuL/hniuPauNKU56AKFhilUs6h
	 Qd/wzKUY5jZ2GYuiCxde6sEKTFSoUDBUGHxAxj8yurENvKcNLTSEKQugviIyVB1Xgr
	 BgrTRjpsz2pIvswFyA+M37irFMTduQSZ43w/KegrS5uWj60aX/xfnsuQH0HlKtYjFx
	 BQot8LH7qSHFBTK7kVfIXj8b0hy+7A0JiTv7SQgreod8grZMUQyoy8gUZsxaGkf2IH
	 wVGOdLY1mGHGg==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	Shuah Khan <shuah@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v3 09/10] selftests/damon/drgn_dump_damon_status: support failed region quota charge ratio
Date: Mon,  6 Apr 2026 18:05:31 -0700
Message-ID: <20260407010536.83603-10-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260407010536.83603-1-sj@kernel.org>
References: <20260407010536.83603-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: cy5sxj7wwj84bor4yyuh76yegqw9ubqo
X-Rspamd-Queue-Id: DAFD7140003
X-Rspamd-Server: rspam09
X-HE-Tag: 1775523944-953272
X-HE-Meta: U2FsdGVkX1+lPvCoG4Rf3UgvTwrfPjmZZfsV28lO3HHocc4zUcLwhFIuU1NjLRoqVWKtr33gr48MdamDEfyR71TegQb0eu/IbZsCS2YFjICgrbuCXXLxdnC+Awd7e+koGCeq3vt3Wau5lpb/LQbhcwATMTsspXloqHc1t5UlBR1+BslAUvQi8hfEenzxFxDEVlrJEDczS5NLuWmO8wUQddNzPzixDZiv479uvl8iNUv5Rtbvbz7SWe0m/k3TEv9IoOu+D/uUB64YCojU8fZ1Wd5sI0bBXDq3+Slce2eYBDc+kt9e3CudoqZ63VYdGjhALDILh1KDEdCTmfLKnd4oMXbm78Umh82ABwt6M0rQGtq81C2cjyeklEpIBPElvuLOFBg/ae7EZBF3y5pC7IkxbuM+GM15V9RB4DxPxosWqbGOoEpyMPrQDf96/iBjAXvGe8T2lq6gKLZf7S6gO0pIQJeTYNs2Sgr+8OnHpzZ2DAtdh0i2UN6iiEikuxydNPfL2mNv4fqpxEkCD1V1Ds7HL3IDWxRdkAaenC/o/vumy7FPktKt8kVOFsd5Lmm39SpVhurFA5CetiPKGCicavBjViSDmb5KHRntlutFeTR1Sp51vGVrXZGp1s2WjhFkfHwFWjJMpSr02zVO5X31vLpNZRzJRCvbSFhXjxl+C66Dw22wQTAIHJTpcfdmAn7iauG3euq+BwPVCfwV19NaVxmkytMo75l3cN/U02oy8G54HouKhAmDGQ/Q7kjUGND6MZZECnFBQRsYta2pb0NQIcZNh/2/umfninx24JELU8o9wPzLBv5avvHdE4voVjbsuPxmHxi3K+MlzS7s0pNTCk3+OYpUcX97ipgv5iyMK3ju6rAblOnvGPFB7MVOnnmu6RKmmDJp/fVGbQNkYZHZFaMdt2G6IQhmLVfGV6APHjsF+kJj0KUzCFraSYFkRducAsUromym/+RM9tvDv0ue0Yl
 5F1QCrhc
 vvRZif8TUSZFZcxTKkV8HI0ooa0P+sw6vA80lrEPFuFDbmuHzzNLDNkK1tzkVBh6kv6MIrVgARl9Oaa2t2SEQ4WyKtE5Scjvui6IKjtsLIPW8xC1KimbatfYd7uFgWPrSL4WnFsuEhY8Yd7tLaODUrzPyjAXlDOvjyMgdO5xMAceeXALfEXDuFny1EYKaHAXJ7jsw6N1nTfyW4naZo25wptzPjctzOos4KVIMsTMXEHA+c1wR58lLjtwvgrbOsafM0Pbd8JmehW1WZO304knbeTbTj55ZvFVO4HLjh50+ryJl7wuQIrgz2pQGIpzWslCfBlH3RRvmUGxdqZc7lqkmjNXd6aD1b5vhnDQY
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

