Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3EBE6C43458
	for <linux-mm@archiver.kernel.org>; Sun, 28 Jun 2026 21:55:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4F0456B0093; Sun, 28 Jun 2026 17:54:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 478876B0095; Sun, 28 Jun 2026 17:54:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 38E616B0096; Sun, 28 Jun 2026 17:54:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id EDED56B0093
	for <linux-mm@kvack.org>; Sun, 28 Jun 2026 17:54:57 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 447701A04DF
	for <linux-mm@kvack.org>; Sun, 28 Jun 2026 21:54:57 +0000 (UTC)
X-FDA: 84930677034.10.939BCC9
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id A9496C0002
	for <linux-mm@kvack.org>; Sun, 28 Jun 2026 21:54:55 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=RAh3iceE;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782683695;
	b=HAbmHCb2p5xwm7MIjsiBX+/8Qi32ScT12ehAH0BYF5qadgyiSAdO+OjzOcDYQoR4smFQ+J
	hMjdaJJpupIEt8xatXtHJ6cCkz19YAjvBjnfa8evNHVpw7+EltwHB67D30eLDUMEedvAMT
	QdiP5V8JCWkBNoKBn12Y+Q/kr6Wds0c=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782683695;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qdss7KwiVKURhK0NoHx/6TLcyP6FekMODUWc+wtuLzQ=;
	b=NBsD9bq+Vc3otR8r4NQJiD148/QhuG/bO3La7kLn0CzDQp6l+GUcngzdZzJLYmaprBp1zS
	nlyQBXxE1+PG/r288GKrEfLD6cjQsRuMZ54qD0RWO45mpDjAuQvNSoLP3GuWm+zEvDb+jf
	r8ZIO1ajjn8kiFl5+NSi/dX+nQJtIpQ=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=RAh3iceE;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id F120A43C78;
	Sun, 28 Jun 2026 21:54:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E1D91F00A3A;
	Sun, 28 Jun 2026 21:54:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782683694;
	bh=qdss7KwiVKURhK0NoHx/6TLcyP6FekMODUWc+wtuLzQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RAh3iceE+2/jLRIbPExiF4OEJXdK1pOSagWGRv2I22jnZuwEXyPdTVEoMGr9MedDV
	 HepS3fjZxFpRxcffJphSwDhqy2/m4O0B0I7mtMdwXSZAaUme/oCsB4GZiOYBLHrhQT
	 uoKkRg3WyJ4/SC4ErgiQ5AUKonTAE+1LDgeIobyGAGB6VvvPfUoP3h+UPCubvhWIZP
	 P9Fb71spOW/ehbld5FNPoBXyUVRqxBRYg8dalvE6umO6egz3WjrQtX39oJ6u2Cp4r0
	 aXw2fOKURDb+ZHGiNoy1KVZscF4PeLXuYAsjRaOlRJuAmVXbhcE7bahFHYTeLTjGm7
	 L0vL7r2qhp3nw==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SJ Park <sj@kernel.org>,
	"# 6 . 16 . x" <stable@vger.kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Zenghui Yu <zenghui.yu@linux.dev>
Subject: [PATCH 4/6] samples/damon/mtier: handle damon_stop() failure
Date: Sun, 28 Jun 2026 14:54:43 -0700
Message-ID: <20260628215447.96166-5-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260628215447.96166-1-sj@kernel.org>
References: <20260628215447.96166-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: A9496C0002
X-Rspam-User: 
X-Stat-Signature: 6nddcp417bxtmufnt9ggmuy7hn86ep4z
X-HE-Tag: 1782683695-995123
X-HE-Meta: U2FsdGVkX19CcgS8eIB/yBjoq6Ona+dZYHNMD60/RcagXKQVZ6nBMxWQUc9g9uEX2ZGBw17n03Zrk4x5XZ0A3n8wIU/NFH7KBz5gXAM71157ujU6Qtrt4ukPjydqS/qDCnh3idrlRKwSBmYk0Ryry6E00ZP8GyNm4p/xk2dm+I4FiQvpwwLha1gnvKpP/62VU2ASmHxRKI0Rh0rA/G6M5eqjXzH+0F8UmmkU+vUwC/Ut8JINVaS/zpEYC4aGX5Nme2rZDhXEb3Yw1lBVRMf43M/Mgcw2l7E9VgWngX/B9iBqcj185oiexmc6VKMz25aFvBWE37PtBmyHOd1SixcVveScK4F+Zkk+Ei5E2KH1Xs5R4l++ioyDv3RlH9PbEUnMsYvfIkAwSI8IPDbxYwIYAZT3nX0deM63Hj2DJ7gyOAUrqihdH+qalLaP2awaD/btUdGirrDsdqbo3+5BJzVMU53EVfoQsV4FDO3V3Mgw5fa8bsNYw+e0TeO5K5NH2cBmqH4Z6awsjMHyPZHChrtjfiSwHsr2nlmNwYZlsihG/4fVCAXnsIRlYZOjIzjW4QIJEJ50z8OBRLLQ+qt99VWIkVNk0FxiQ+9+aaHdw83RYkm3liCqDxAfZTeMLYZQj+plTyg17b9jwphFE4+cepGVB7i+OSwgD2ujX2cHxcGKVWRBNZMzkdHzrp2F3xra59+e8FRGoQfG6DzU+r8y7IYtydKOsMnPMqyoNzEhNV5i3Y97WxCV5DpRToJE8YxeFfXrXSIjfMQ69Kviwv27IkZDqy2o4v9iz3VWO0wQ84wCicGk/MXGoJYnIw26njfCk+0nTCRqbzgFEHPLMbAramFrGS0mzT2OvUCeyWYt2nJWE4ZfVo1ZSjlqOGQV16ISiNPAlITbEeZB97X8F/p08uGxEk1dVtEveT3SsB8jQcI29DOMiBS2YmSM8aTPWqCjvI39Cf7duMne9SV6i7Ek85Y
 wqYnWuze
 wHKDv4Y/3yOWVgD2OaOJIi30vZa7VZSpkLbT7dIbYjIg2r05tiKGSGsnX0nnz4HwBrPmtFUUOMhYuJPsn5EjiPRK8LHbOO8Cb8Y/EFyXpP0cVQT9YzUIdUt1cxBFX6V4fRgsvz0DSFwdfUf16yxc84cg3lYvVRoYBSpBQheeUznbWfj3/h8kDShE4kOpSfIdLLOWn8xOEgZ4U0MIsjI/OasbzY1414/GXvg5DT4r39Rmxcxx3qtLBt6/BKDjqGOg6G/1XdDC0RoFE4gmSY52+G6sjNQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

damon_sample_mtier_stop() assumes its damon_stop() call will always
successfully stops the two DAMON contexts.  Hence it deallocates the two
DAMON contexts after the damon_stop() call.  However, if a given context
is already stopped, damon_stop() fails and returns an error while
letting the DAMON contexts that have not yet stopped keep running.  This
kind of unexpected early DAMON context stops could happen due to memory
allocation failures in kdamond_fn().  Because damon_sample_mtier_stop()
just deallocates all DAMON contexts with damon_target and damon_region
objects that are linked to the contexts, the execution of the unstopped
DAMON context (kdamond) ends up using the memory that freed
(use-after-free).  Fix the issue by separating the damon_stop() to be
invoked per context.

Note that DAMON_SYSFS also allows multiple DAMON contexts execution.
But, it calls damon_stop() for each context one by one.  Hence this
issue is only in mtier.

For the long term, it would be better to refactor damon_stop() to always
ensure stopping all contexts regardless of the failures in the middle.
Make this fix in the current way, though, to keep it simple and easy to
backport.  I will do the refactoring later.

The issue was discovered [1] by Sashiko.

[1] https://lore.kernel.org/20260609014219.3013-1-sj@kernel.org

Fixes: 82a08bde3cf7 ("samples/damon: implement a DAMON module for memory tiering")
Cc: <stable@vger.kernel.org> # 6.16.x
Reviewed-by: Zenghui Yu <zenghui.yu@linux.dev>
Signed-off-by: SJ Park <sj@kernel.org>
---
 samples/damon/mtier.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/samples/damon/mtier.c b/samples/damon/mtier.c
index 66b591f2180fa..faaaaa12e6206 100644
--- a/samples/damon/mtier.c
+++ b/samples/damon/mtier.c
@@ -199,7 +199,8 @@ static int damon_sample_mtier_start(void)
 
 static void damon_sample_mtier_stop(void)
 {
-	damon_stop(ctxs, 2);
+	damon_stop(ctxs, 1);
+	damon_stop(&ctxs[1], 1);
 	damon_destroy_ctx(ctxs[0]);
 	damon_destroy_ctx(ctxs[1]);
 }
-- 
2.47.3

