Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1B7C3C88E56
	for <linux-mm@archiver.kernel.org>; Sat, 12 Sep 2026 20:08:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B3BCD6B00BB; Sat, 12 Sep 2026 16:08:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A22426B00BC; Sat, 12 Sep 2026 16:08:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8C3A46B00BB; Sat, 12 Sep 2026 16:08:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 3C14E6B00B7
	for <linux-mm@kvack.org>; Sat, 12 Sep 2026 16:08:26 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 8161A40548
	for <linux-mm@kvack.org>; Sat, 12 Sep 2026 20:08:26 +0000 (UTC)
X-FDA: 85206197412.03.F07C271
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id EF91BA0005
	for <linux-mm@kvack.org>; Sat, 12 Sep 2026 20:08:24 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="K51/4QtD";
	spf=pass (imf15.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789243705;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=80o1zjbsa4JPAD6h+nen9K5vfO8rOszkn9G9ncWmsSc=;
	b=KHa6Kc5PgWis5p7IdLCkF++BSVMzZTwX5NQyrQVA4x2HBeVn1AeloPX0Ct8ITz63NxnVlv
	rMal92gx1GJXx43n714+YkIvMHp3po9UkZmpD5RnVC9vqTDndL60r+5l9np0AxsdNWi9WL
	pNXGpYIYLbNPf9PbybESotaZknsHEKg=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789243705;
	b=QEsL9btWwm6j+4YuOMGvA302AEuXU0aiijekhABpfawWfR15N4W/yMZRZqpAVkjp0zjxdB
	eGDQTqQtVk5aTmU0uywHtAWPp4rUZ+3gCQYj+ha5yx0s2i9ZXNNhGAB/kHk9xOCLbAVheH
	H1ZeR0kLSoHqNWRFxn8BpVW2llp7XcY=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="K51/4QtD";
	spf=pass (imf15.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 492CA40402;
	Sat, 12 Sep 2026 20:08:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07DAD1F000FF;
	Sat, 12 Sep 2026 20:08:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789243704;
	bh=80o1zjbsa4JPAD6h+nen9K5vfO8rOszkn9G9ncWmsSc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=K51/4QtDTuI+oO9+RACODBQv8TubJPnAUtItpnPP6GukNKjppgbjKYWcNGcqCZ6Yv
	 9VfBdalwvsB4kFJWZBKs/UUqhIT+aZjDy0kmv/40J69p1gLXyWm5gbaBfMlckAx8YI
	 N94b7jc5WVLsE4xfBn+SxUHy/9umzdyJgEmzk4Vw5nKQWTmSngH2RPElybq3mYEQeB
	 bSCm9D7/YAZ0e8FWFxmnHoHadjjOe/ztB1tMiYmxpICjWbT0gy3zg/G3KOp5ujn9l4
	 mBnNmfl4qJnXOv3DurRcnPbke2PQj2sc3dFQbsgeAawxU0OB32Iex431JNchtNjMoT
	 ZYdg/avyDDm6w==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH 5/9] mm/damon/core: document damon_call()/damon_start() race hang issue
Date: Sat, 12 Sep 2026 13:08:06 -0700
Message-ID: <20260912200814.145612-6-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260912200814.145612-1-sj@kernel.org>
References: <20260912200814.145612-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: EF91BA0005
X-Stat-Signature: rrmy4b9trkkqs4ubg6zsejphayuhqbhz
X-Rspam-User: 
X-HE-Tag: 1789243704-965760
X-HE-Meta: U2FsdGVkX19sBEpPMGPLn7uXDYVB3ttg0ZmqPMwrj81Osb8Y53DswUT+BL48bQc3kyPmBU24Tszhge6165uxqxlS2MTcZBmnbaPKqxMkSooLAz9f96JPNest34mJQ7LyT3tk443Bs7Qo5fTeJp3wPvzC002sFSN8/kAdi6+vMY0zdsp8VQ2qtF7rG5pbXVuQbtqwt6liszGWlnlL/4Mhmt3TfF8W33DyXo4paipUMnjAAypeH/a8TZ7ZJ7dT//KDvifBe05hSf80U3KzIb0XH5gSlvgHf0LW2+Vj6DG9HwHD4sP8Ryx8piMH2oBrIv7dVrQVXDQFbB0URl0cG7yyRsY78h5CBYKp/mfAZWWOp9KnfHCUT7KGTuh+wwUc7yNgIgWqsDJecqhd0oD3T9+n6fxkpKC5Ff0eCZ+/nUHL1oX7+L8t391YzcrpmfxsRvU8nApykwQkBxoI9hvY9NmfK57vYdP3825ky44MbqZFfWTXy1rZQ/dc1M8SFlmfJ+7PVpkvcaO0Zj4tv3qxyKG6nIjo1qP9nwVYZmhpnB10k+fXcAmpt9tFC74+W3kquguTsjI0fEOCfl6xPJboDIlg2J2l1MmzT7IWDyUA55T3fTti548rAxlu9pvdAsZlksSNq/haHhJMwP8u9iTUdWWEnVFOVPxxftcToKozHDl3eR+pmacYV54cvw6xDPCv9agfUWrW4VQkKJwNZ7THd4s/kbk25xED8ziBUibke4VPAYDEevctAP9S96zunXbDykrMVz4O8Dg9a9umB+9BvRyqIHZNqcBanFPpG0ZHMvDDlnm+Nja1rOV2k911yzsIV8Kmnudisf+y/w479GChxAzwaxA4/2b6xuSDp2h68Mp1Nz3yCSI6qZDWCwk2quUKnbqn0/qFlkr2TN9mZXxAIHW7U1/wxOmRe2jwhUCuCwX4Y4JeLeB9qygJEpvXMhCA3tAq9f/2Thrq8POK/MV6xtQ
 UED5Rdn0
 QsS7KIi+nO9Mzpv36nG7/ozphdkiMcLiyMUOpKem/2O+b7/dRrDM/xTzVp75MEes02Ns0csWd4XCMNGphGoKKAVbkhcAnb5rvl73okyXUPa253qacGoLBdjg4tbAdc4DLB2fjqiNczrkvjcJ0nAbgeEuuoZNGdOyAXxHkSxgo3KvexWNjq1CImsmSJ3XuuTHQNpB800aHMR99Gf84hT/xBaHCOr+OLVwF1/0aoef2dvXQVUUQ8ZYsdKI1cgFOCrgbehitrw3pj8fHZJNxMtUieHLVQQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Let's suppose damon_start() and damon_call() are executed in parallel
for the same DAMON context.  Then, damon_call() could show
ctx->damon_calls_obsolte set while ctx->kdamond is unset.  If
damon_start() sets ctx->kdamond before damon_call() starts the
cancelling, damon_call() can indefinitely hang.  No DAMON API caller
does such parallel execution of damon_start() and damon_call(), so the
issue doesn't exist.  But who knows what will happen in future.  Add a
clarification comment for caution.

Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/core.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index dd27068cb83e3..080355b1f2d9f 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -2251,6 +2251,9 @@ int damon_kdamond_pid(struct damon_ctx *ctx)
  *
  * When this function is failed, the @ctx is guaranteed to be stopped.
  *
+ * This function should not be called in parallel to damon_start() for the
+ * @ctx.  In the case, this function could indefinitely hang.
+ *
  * Return: 0 on success, negative error code otherwise.
  */
 int damon_call(struct damon_ctx *ctx, struct damon_call_control *control)
-- 
2.47.3

