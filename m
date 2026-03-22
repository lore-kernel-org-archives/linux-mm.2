Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DACCDFC72C4
	for <linux-mm@archiver.kernel.org>; Sun, 22 Mar 2026 15:57:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B045F6B0092; Sun, 22 Mar 2026 11:57:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AB0676B008C; Sun, 22 Mar 2026 11:57:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8488B6B0095; Sun, 22 Mar 2026 11:57:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 62F336B008A
	for <linux-mm@kvack.org>; Sun, 22 Mar 2026 11:57:41 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 1D4771A051E
	for <linux-mm@kvack.org>; Sun, 22 Mar 2026 15:57:41 +0000 (UTC)
X-FDA: 84574154322.15.533D1B6
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf19.hostedemail.com (Postfix) with ESMTP id 78F421A0005
	for <linux-mm@kvack.org>; Sun, 22 Mar 2026 15:57:39 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Wz1XKTrp;
	spf=pass (imf19.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774195059;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qrwBOaagiB21sc+4Tujrh9HlKIXyQFwIJW5FlrlxHt0=;
	b=dy+YwP67nq+ZWypfA5MFw8tIR5Zqx6heIDJAFoVotAh0kus1UbcYyxA7eVNyvwrPCb5Ir3
	WEvzcPwfblDa9oOygGCf/EUBCfLCtUqxpD5e19iWoA+FmIamsrt2Mo8HEVP0fCLdTBxXTh
	IInFe3m+iIrnpS+EOpF3ahrNwVNIdZU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774195059; a=rsa-sha256;
	cv=none;
	b=Vs9mqwm7m1XTQMPci/PNtZLFdH87FUhZDJXL8zYEpC+0JSpjGox2qTZE7FltWg4OfIdLE2
	xwr+1TMnxJ60jhI3TiLJojtO5v2AnQfI8zUcIRnoboZGZiWAVoTF0T2Yj4BjB071hm6GVe
	KLIDpQa72Jue9oDAC7eTRqwLrLeFLIY=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Wz1XKTrp;
	spf=pass (imf19.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 425E6437E2;
	Sun, 22 Mar 2026 15:57:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F67FC2BCB4;
	Sun, 22 Mar 2026 15:57:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774195058;
	bh=3QrXyfjqZ9NePuFwbE4wZWagxs5zgqv9GB3oTqtAgRM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Wz1XKTrpjc5jVSunEF2PXKKjeBoJl/FMlWfuA2LfY83AyKI4xzeFCepvGvaGckP13
	 tynRtQNuLdSLPzMPfUUWxJDKMjLjb8s/U8iF9Kx668wMB+6WupglbFdor7ydtqy/K3
	 5KIYrQUWiMhjVAVNprW3oGyfH90y5SC4rlnatLZPeRjmlr7dE1CoLq9YtFlpcoKiNs
	 +OgurlwTEhtUOHTzoHeRMIOWFHNKvzMuKc8arNWRbwaUEpB9B0aIir7h0dXD5Z9uR9
	 ijBq5MIaW8c+bDUqDyTlT47THllXIzKvDQfpdz56bhk0ORHv5VJ2fAjqk4wJvD1dEO
	 ihWN9cwd8KYNw==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v4 01/10] mm/damon/core: introduce damon_ctx->paused
Date: Sun, 22 Mar 2026 08:57:15 -0700
Message-ID: <20260322155728.81434-2-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260322155728.81434-1-sj@kernel.org>
References: <20260322155728.81434-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: pms8c1hk61t53nyqsr1nxdafscweu79k
X-Rspamd-Queue-Id: 78F421A0005
X-Rspamd-Server: rspam03
X-HE-Tag: 1774195059-696459
X-HE-Meta: U2FsdGVkX19xRKme1HrwGyKrmpjeIkmKjlHsAEtdsfOw44ezEWSKCzhd4momiB4ppb0RdEDI1Ukp9oO9GP7HTvB8qaVmuIaKNdTktavbxh+9o10Uhj5kK9isayVrAz4Lliku1XT7IeYqJSwTSM/5Rm3QpCyXYtjkx/LMotyRDzr7tQEXc+LmHvY9mPbxYg+3yMJiWNVZ+zVq3iflYNh+drcVmFLwEbw+RzVguCy8wNoTpwluYslvAsTk0QgPKvQx5uk93yH812QnkKNKCS7o7jEFfsc1VkQScjUFQqStA3MMUDSsMKIjO93sy6/tW7zpmw05NbX3t2eFOjlIZyRczyXbRbPJVppoPiBsAKnxplqD57c20+4foguebIwtPZQEFwJdhIQzSOeaBoKXPuh+TkCaPg3xm1ysSZUexA9TNXOO1RNdwP6fCdqr6s1W8R3NO/KOGhRhspzCV91mSQipvYQpMXh1YxX5rWk7C1/369N5JNAaZkdggKD14dDpac/OVu/AwjAY0EN1eard9zFPIr1TXW0YyXETj0Gfyl5mNs8u/Vj33120b/4ckE2DCQ3rSpgb1/PBwiZPpWA7GUX3DzQEo/NykSHyRirD54Kmr6hG5akrxiKWk0uA5Oaxx1ZF2ez5Gr3cwe0jwUxbBkzwoBBUYecotCnaYLamA8R5nq2dTSRAImg6i3bVX1UxwnQSSGhqf1l+9WYZwHKPOT+XrC3PIXqb+7f+3iMDiL318kf1MCJaT9TPN0gFnGKJTzZWLSrzGPYdCWEiV1fTlWu/5kcLh1hOlf3fqM+6QyXtSB/OyOJ51AWcN9sPGkmDWIrfEbewZcq0UuZ4lwPKxV2E+wKirqDztuiVS9j5Ou0rBatDcQ3GlyaJbG7LfdYM6z65qRGRXTn+pIa1NUGHpTE4cCzRkBn2gMFz6B66iDI4Q8oYTVhO9KGH5mbaeWhH+99kdJCEdMdRBvS8zxfHcQ+
 Rd7bwEqH
 S2us9MtuY2XPAgVebErMaHRydA+XpvWXr2rrXtDGL/dzHdK+gfD64y1kWO4lhj/J4vdZbDLtKXahJwnA80HT3m0cJ39K+6gG9M/7p7pE6zLfZTx9mGvaHOp5khgnleB62pUJDtTiLaCAhqFdbNHkk32WWOz0L0WyVTos1JuQ1jIKfa+z1lqEoXDwXZEXtCWZ5aU6Zc957uxNZD0P1Ls7bdXjGpyGWw/RJ+rC9o/ATyc4hNfbW5g2OYXchUcceuXBK5rUp4PwRHxbPM70Q7PsqPjYIeg==
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
 mm/damon/core.c       | 9 +++++++++
 2 files changed, 11 insertions(+)

diff --git a/include/linux/damon.h b/include/linux/damon.h
index d9a3babbafc16..ea1649a09395d 100644
--- a/include/linux/damon.h
+++ b/include/linux/damon.h
@@ -787,6 +787,7 @@ struct damon_attrs {
  * @ops:	Set of monitoring operations for given use cases.
  * @addr_unit:	Scale factor for core to ops address conversion.
  * @min_region_sz:	Minimum region size.
+ * @pause:	Pause kdamond main loop.
  * @adaptive_targets:	Head of monitoring targets (&damon_target) list.
  * @schemes:		Head of schemes (&damos) list.
  */
@@ -838,6 +839,7 @@ struct damon_ctx {
 	struct damon_operations ops;
 	unsigned long addr_unit;
 	unsigned long min_region_sz;
+	bool pause;
 
 	struct list_head adaptive_targets;
 	struct list_head schemes;
diff --git a/mm/damon/core.c b/mm/damon/core.c
index db6c67e52d2b8..0ab2cfa848e69 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -1349,6 +1349,7 @@ int damon_commit_ctx(struct damon_ctx *dst, struct damon_ctx *src)
 		if (err)
 			return err;
 	}
+	dst->pause = src->pause;
 	dst->ops = src->ops;
 	dst->addr_unit = src->addr_unit;
 	dst->min_region_sz = src->min_region_sz;
@@ -3003,6 +3004,14 @@ static int kdamond_fn(void *data)
 		kdamond_call(ctx, false);
 		if (ctx->maybe_corrupted)
 			break;
+		while (ctx->pause) {
+			damos_walk_cancel(ctx);
+			kdamond_usleep(ctx->attrs.sample_interval);
+			/* allow caller unset pause via damon_call() */
+			kdamond_call(ctx, false);
+			if (kdamond_need_stop(ctx) || ctx->maybe_corrupted)
+				goto done;
+		}
 		if (!list_empty(&ctx->schemes))
 			kdamond_apply_schemes(ctx);
 		else
-- 
2.47.3

