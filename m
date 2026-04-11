Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A1EFDF3ED5C
	for <linux-mm@archiver.kernel.org>; Sat, 11 Apr 2026 21:36:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6E8F76B0089; Sat, 11 Apr 2026 17:36:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 66AA46B008A; Sat, 11 Apr 2026 17:36:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 559676B0092; Sat, 11 Apr 2026 17:36:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 4170F6B0089
	for <linux-mm@kvack.org>; Sat, 11 Apr 2026 17:36:46 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id E5D16BBAFC
	for <linux-mm@kvack.org>; Sat, 11 Apr 2026 21:36:45 +0000 (UTC)
X-FDA: 84647584770.07.3991D5A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf07.hostedemail.com (Postfix) with ESMTP id 7D1C440005
	for <linux-mm@kvack.org>; Sat, 11 Apr 2026 21:36:44 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=GG59J4Qu;
	spf=pass (imf07.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775943404;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=hJF6xNfoGeJ45gEkjJGcLEw/RAb8FdLOtYPoLZpjWNk=;
	b=CU4k/18a+NEvM5S7xBJOmAwXled+HOl/JmUWBKx3IkA1rEPoMs5z17jIsOWOA4H4y/N58m
	gQsmQyVkofbROp9LhGVPZHW/q1CXnHCxZBY4v9q9BkOv4lMWZJl7coK+vjE1VX7Zyn0tg5
	rtDAW2vW/9/CylJ1pvGQFlpwhgvdV9E=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=GG59J4Qu;
	spf=pass (imf07.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775943404; a=rsa-sha256;
	cv=none;
	b=fHx161gfmcK1Iam1h/lS2kXKIxOH9RXZ9GiVvRPh45lis+Hyvspas0nhxm6XJDRgrotwih
	dxZghv0lC5olosWcsBwTM12KbBR18ks1K1pbPqGoIVQxECvjDFtkXb5CtkLc6+0brf7K+o
	CBahAhsc0oQvIXDmBucSQlqvR7z9saY=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id D373D6015B;
	Sat, 11 Apr 2026 21:36:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49E15C116C6;
	Sat, 11 Apr 2026 21:36:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775943403;
	bh=QPyTCBOcvix0CTzcdOfzWMx07raK0kRLMFwQNf37D0Y=;
	h=From:To:Cc:Subject:Date:From;
	b=GG59J4QuLV9E77nTCwE5A0NmaXg4XnCb9AHxSdTolltGc5w6hPwUzKtPiGUZt5ttt
	 WeivEuzp+8KD5CUscFpoGf5ckvEThPb/gBUGdGLiMgL7Aye8xX1BMseiH/8gDjJAL7
	 zDy0ZiH8NTtyr8QE7NuyvRhS80hHKPE4O5h/SXmkozeit7AdSD2c9Ir1UMDe3+IDMq
	 mHDYgkRfpYmxv+ax1TmLIuC+SVmwlGaFy+L9GchgfbxzRehhG5988aGS8l6rbOdDuG
	 MXUj9F4V5oR8b9sDZY357POBMSypneEah9DLjST58YwC/fvkHX7Yk6IoY2TwnT6yPn
	 hhj7jeZrblGzg==
From: SeongJae Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SeongJae Park <sj@kernel.org>,
	"# 6 . 18 . x" <stable@vger.kernel.org>,
	Quanmin Yan <yanquanmin1@huawei.com>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH] mm/damon/core: disallow non-power of two min_region_sz on damon_start()
Date: Sat, 11 Apr 2026 14:36:36 -0700
Message-ID: <20260411213638.77768-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 7D1C440005
X-Stat-Signature: xf4z6f7roxq63gss7w6ibrc9za7frutn
X-Rspam-User: 
X-HE-Tag: 1775943404-578284
X-HE-Meta: U2FsdGVkX1+X82Jrzv4OvieMj/uyqLWsFMz95gJvtj0ycFU1aXhvTiKoSfpYR/lHGqeo6iZM9ckCgf3t59VIX3WgxiXohFky71ejti6EDZvNIy1nNtNWaAS1nY2bPTtmcrvFBFTvgUs0cFxHCRBZ3dhfi5f570fLWvQTHVmgpFHKO4Y4G0xpKF3AkcPyQr48YiYEgART0ByQGdDlPowCWSK55BSvvXu7FjPsZI1A/9ZL+vWqQBXaje8UDDVyCahK5es1YlwmsLJCbOV1A89dhIqsz4HV7ZBRg2qFBUcT7+Q3b8Px5I/mjATIkmmPOrLkd37yYpKFqtkfnDg2SP0jwdpP2/8xfsftZv5ilOA8Xph3V3tdKXZyi8wB/eWY2WFA9TOhNnLLvu8YeU9yrj+mMCTMFKvVf3aVZClL1ev/TuBidxKS6i3Cx+MiptIRR4X6AQuBo6HfZmGMchYM6frFiXAGe6c21H40nuDJG64J+8LdSI53ujOn8UzpLSRqLNTv8DJDtBpDntnp2ADKc9nYKMEqpbUl1IjCT6uGLdCDf3MJtpkKKLcJLpWz/GsX6DPBq6HehDZMshSZf8AVbr8w7Us21zwLKSsq5AsTFJyeZORXf1L1AIOMTasKvmRXsZe76u9InQpmu7vvoitHBxVSvop8OUETG3Hl8mHJ1x2xbgEp7TyNj9YAum+Xk/NrKBn6y1vhtUGGxJ903fIQE4UkUd8i0xL9R9mxTt07iyoKgLS9LIz7mzk96mOBxVA138QBvprPkHKtvxaswi3mX3O4GUFtcCRr4N40W9U386/n5jbfKz/P3iCToMN9kGCPSmb7BZkm3YIW2Tqq1kAMdQGp1RbGo8aMfBku0GUHRyMrDUIgADp0RNj0yiKbxDTrP1VH460G1emssmqvz+QKk6nip41vXEbyDJpij2Jr6EbDQeT7KeP/rDSGtVqpPD0R+6q1JwyXHHw9o7QdBvkkT2w
 Yx/9b1cI
 See5K5LDUxQmwLz6GQfYkrR6TUrg5H/9WNRiHY4f7ArN0d2mFhSBqlnR5SZ18wJJ4uy5SHORQNDyA5EsdxajaEo78SBhOgmhXOSiHJ1AV6wXV+GfT++vAEDWjL+7lp5qwFyHiJjN/KwRYXhIzNXCO+K9pHC+xSfOqvRjIDGGVt+mTiIgFjDFbXuRxsX0amgs5PLgCUvrntxhPCEGfqdygWRC3+yRgkHj9wYw/ZUg1X/r9UJ3Cta6Z1NKg16J2u4rjshl/JIoaGNZw67PUTXvmE0Q1mA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Commit d8f867fa0825 ("mm/damon: add damon_ctx->min_sz_region")
introduced a bug that allows unaligned DAMON region address ranges.
Commit c80f46ac228b ("mm/damon/core: disallow non-power of two
min_region_sz") fixed it, but only for damon_commit_ctx() use case.
Still, DAMON sysfs interface can emit non-power of two min_region_sz via
damon_start().  Fix the path by adding the is_power_of_2() check on
damon_start().

The issue was discovered by sashiko [1].

[1] https://lore.kernel.org/20260403155530.64647-1-sj@kernel.org

Fixes: d8f867fa0825 ("mm/damon: add damon_ctx->min_sz_region")
Cc: <stable@vger.kernel.org> # 6.18.x
Signed-off-by: SeongJae Park <sj@kernel.org>
---
 mm/damon/core.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index 3703f62a876b3..c107d74c77e74 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -1368,6 +1368,11 @@ int damon_start(struct damon_ctx **ctxs, int nr_ctxs, bool exclusive)
 	int i;
 	int err = 0;
 
+	for (i = 0; i < nr_ctxs; i++) {
+		if (!is_power_of_2(ctxs[i]->min_region_sz))
+			return -EINVAL;
+	}
+
 	mutex_lock(&damon_lock);
 	if ((exclusive && nr_running_ctxs) ||
 			(!exclusive && running_exclusive_ctxs)) {

base-commit: 872b6168e577ea326324255fa8b6716a89124680
-- 
2.47.3

