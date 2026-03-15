Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B1651F30288
	for <linux-mm@archiver.kernel.org>; Sun, 15 Mar 2026 21:00:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CCB376B00A5; Sun, 15 Mar 2026 17:00:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BF4006B00CF; Sun, 15 Mar 2026 17:00:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6D46F6B00A7; Sun, 15 Mar 2026 17:00:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 426546B00A6
	for <linux-mm@kvack.org>; Sun, 15 Mar 2026 17:00:26 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id E306B160C8B
	for <linux-mm@kvack.org>; Sun, 15 Mar 2026 21:00:25 +0000 (UTC)
X-FDA: 84549515610.13.D028B26
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id 3F4421C0005
	for <linux-mm@kvack.org>; Sun, 15 Mar 2026 21:00:24 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Bm6ND14r;
	spf=pass (imf18.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773608424;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QNeP2F9nQVP68H9rkc7UFwUaqfLVd9zWeOWbTgW6yw4=;
	b=Pu1EwE6i7dZgyrTJMI1UU3bTX46WYsVl76VcqEBH7Jok0ygW1BqAgMADSLLihAHji00oyB
	pdPxVsX4566Yp+wIp8uhsS9J6h81lgi0askwwVHJGBKnFeGpmurN4nm5BRwHaC7JmK0vI1
	M4y2QD90kjS2QsZ2pSxs9TW/4u+kBNs=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Bm6ND14r;
	spf=pass (imf18.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773608424; a=rsa-sha256;
	cv=none;
	b=gr2MkUrvRE6RXE5T7af9F4/+FdheICNAcskvTwXFhdYbJQRZyoDWX7dk2u0/StKwstDS87
	w1HHPZYe4xoW9lJ2ii2VeOFAzxGCy425P1Rh+JtkFylw7xodGMS3rH1q3SOpGgqLCnwfoy
	Jc8GaVk24/vvwZQdVbrLGrWjLjhO57w=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 5E7444444F;
	Sun, 15 Mar 2026 21:00:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A70CC4AF09;
	Sun, 15 Mar 2026 21:00:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773608423;
	bh=2Ts0pyl+UtHEQzIBfWhdhwzgiRHuVs9/Q4ZdnI3FxRA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Bm6ND14rLgcPbSPnIIoteONEB6bgXcEmZWVRki0Fr3DRoi+IawOvHV/KpB7D5im1z
	 cbvWVc6vKg3+VkJTeIOlnwajo5AswOqle86S3bWlA073eaObXa4QMUVNQ5fldt/v96
	 0W0usSu8lBcELqlDL4RaPsECX81dLcFoWR5hKupviomobU7nbTco2Aoc2jKMIAkIeR
	 uwJfFBeeX5xR54/K1NGrBxmcT+mlCHoLJKsW+xaBPePBhRr7yNHN70SJfh4P/6WiJe
	 K6MxH1qZ5uM9wol+C08tP22+tI2FekDQhbrD911j3W8Cupkvqf8Bh3M1gRErsiOzVs
	 70tSmCtxdqfBA==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH 01/10] mm/damon/core: introduce damon_ctx->paused
Date: Sun, 15 Mar 2026 14:00:00 -0700
Message-ID: <20260315210012.94846-2-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260315210012.94846-1-sj@kernel.org>
References: <20260315210012.94846-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 3F4421C0005
X-Stat-Signature: xkh48zu91nck4d48hhuj543cr8m7fsm4
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1773608424-511707
X-HE-Meta: U2FsdGVkX19cszt8Gs2H9aVmITko/5aHxaaRWbUMZCOKUs9knFXa9JqypoiqaZJ70T4GKXFJ3iuUrL/SY7DfLpaU0kI/+ZygH0K1ontrl0Bc8RJLQ+RKnxbsWTu3DWMYAKLDJ7II7f4vi/uS9OkI0sFUnVcB7QVSpZ/0eJQDZdAFVVa91+pWcgRuvYVuDMO9FGk59e0ylYOQswXAPxKF2Spes5vSscK+tP1wF6ZXg9K5tTCAPDwn/+SSb2+rbCnaQnJw+j2rSbTLRJXlUbIOWfiunH4RgWdhJqid1d8stkTFnBKgdrpG99mFAsPWbEyIYWY4lHe29Wt71iDQEtZ5vto/Qe5EeQZ45jVsCzaoY09vjz6OPjhUdB0MXABbEIWKTlOWjVk1L0w0v6mXWWg+nltcuGundGe2NVJY5p5vLXaAdmh6RwIXzpHQzYqo3/5cAGX2ms8cUp5YItDhjS4AVrKeufl6MT9gcgUB1LWZxWFymuW4jbn5D6JF4v9EqpUdvvFhvfbTljVQ6//Ct4LciHcbIM6e7rtckkOsO6O/66UZW1jxnhAiKMQ2/ZqC4Eh+UUMn6k5/qZrFeawfOPFJ+ycdF6QtMx8OUjh8RVAuK09IK7QlO3XJp5OBRUPIRgEtrHYMdxL23Cxiw1cxZTgprH0TJs2Wp+tzQT/iGzU7LrG44Xxv3qs1kV1U1qTv6LyrSMULl9D8VoGqQO4nUF+AStWRJmnwpTpQ2lVWG/vV1xV8PeV0v9nZjI137fdlfrvhHf4L4LwXsjn2TZkxO8doAKpshgAq8tBVwD0/FvJTYbmuS1aMSYWIkBPvRlVN2iRiiSb9hCnr9Ex7QUGMNMym+ATlS+SHP07QR/witMWl3q/LmhG/YOBZwCNGSIjpfBDEtVpVt/MGeBc5pW1L8y/sRR0ebIAOpw5sYPXJQlbeUEnSxVlgthmDSBFegOwEWBNdlY/cUG+9SFgdMcTFfrc
 BInqCfBA
 pWu745sk9REouKu5HXsux4uD75T/zNYrBHh9l8bHSzuF9qgNfZt+gs7urLgsJs4qOCD/Jf5xy5sQ0C52vuKwKR9DZuUoFh3G4sf7ubk+AKNFHUu93UY+DfM5UxyjrOCBQlCzpLfF0OjHADg2Wgy31xu0vWxHCz5ygfTu0DXO9Gf1VSm43u5TscYy+k+ofv62xJAA9uXZ+QYzW+k+ZhorY73qpbxDUK9NsAZJcsUBDs3WnBhxZ56wtW1CXuhLndEXchrpMxNfONLdow+04WWknpc+0Wg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

DAMON supports only start and stop of the execution.  When it is
stopped, its internal data that it self-trained goes away.  It will be
useful if the execution can be paused and resumed with the previous
self-trained data.

Introduce per-context API parameter, 'paused', for the purpose.  The
parameter can be set and unset while DAMON is running and paused, using
the online parameters commit helper functions (damon_commit_ctx() and
damon_call()).  Once 'paused' is set, the kdamond_fn() main loop does
only limited works with sampling interval sleep during the works.  The
limited works include the handling of the online parameters update, so
that users can unset the 'pause' and resume the execution when they
want.  It also keep checking DAMON stop conditions and handling of it,
so that DAMON can be stopped while paused if needed.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 include/linux/damon.h | 2 ++
 mm/damon/core.c       | 8 ++++++++
 2 files changed, 10 insertions(+)

diff --git a/include/linux/damon.h b/include/linux/damon.h
index 3a441fbca170d..421e51eff3bd2 100644
--- a/include/linux/damon.h
+++ b/include/linux/damon.h
@@ -811,6 +811,8 @@ struct damon_ctx {
 	 * intervals tuning
 	 */
 	unsigned long next_intervals_tune_sis;
+	/* pause kdamond main loop */
+	bool pause;
 	/* for waiting until the execution of the kdamond_fn is started */
 	struct completion kdamond_started;
 	/* for scheme quotas prioritization */
diff --git a/mm/damon/core.c b/mm/damon/core.c
index f9854aedc42d1..1e9f6aa569fd2 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -1331,6 +1331,7 @@ int damon_commit_ctx(struct damon_ctx *dst, struct damon_ctx *src)
 		if (err)
 			return err;
 	}
+	dst->pause = src->pause;
 	dst->ops = src->ops;
 	dst->addr_unit = src->addr_unit;
 	dst->min_region_sz = src->min_region_sz;
@@ -2978,6 +2979,13 @@ static int kdamond_fn(void *data)
 		 * kdamond_merge_regions() if possible, to reduce overhead
 		 */
 		kdamond_call(ctx, false);
+		while (ctx->pause) {
+			if (kdamond_need_stop(ctx))
+				goto done;
+			kdamond_usleep(ctx->attrs.sample_interval);
+			/* allow caller unset pause via damon_call() */
+			kdamond_call(ctx, false);
+		}
 		if (!list_empty(&ctx->schemes))
 			kdamond_apply_schemes(ctx);
 		else
-- 
2.47.3

