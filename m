Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 71E82D3B7E5
	for <linux-mm@archiver.kernel.org>; Sun, 28 Dec 2025 18:31:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A0F936B0005; Sun, 28 Dec 2025 13:31:19 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9BC7D6B0089; Sun, 28 Dec 2025 13:31:19 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8EA6A6B008A; Sun, 28 Dec 2025 13:31:19 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 7C9DE6B0005
	for <linux-mm@kvack.org>; Sun, 28 Dec 2025 13:31:19 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 00B141A0608
	for <linux-mm@kvack.org>; Sun, 28 Dec 2025 18:31:18 +0000 (UTC)
X-FDA: 84269722278.21.2D877F1
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id 53F6B1C0006
	for <linux-mm@kvack.org>; Sun, 28 Dec 2025 18:31:17 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=DYnZ8Xo9;
	spf=pass (imf18.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766946677;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=3oYIXZvUwX8LB6kZO1OIAgTBArB7oZETPRCdXfAfWnM=;
	b=qg1jfh42Uh5tFE3Nx4mlVg0ZW4wM+i3dn1ZRZeKERdnQI3yphVIJp9Q81b6Y4UoF0yF3PP
	0gqsH5tCqJkaTj2kfRkZgCBert9vXb3VL6J4vcxp2u08MrAqHDw2eGiBX+rj6ncMNYHiUD
	x06q4okLOHbcuMIaHgc74uWIeEJgFXU=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=DYnZ8Xo9;
	spf=pass (imf18.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766946677; a=rsa-sha256;
	cv=none;
	b=gtzp1GLhpQvG5gC5vvhU2Ht0lsa+T6WSLF5E0VY7/h1tlDl6cINlcjHU3MnmK/VeklCZmq
	rWlvCwbdQW10fSCt7jr4p0DWjCG0Hm6znM4R2fDr+Yntrdu8hLBbsT48c4J00nUkK4S0Uq
	g2P4vE/27Nqsf3XF322ujny4NS7BfJA=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 1B67643BCE;
	Sun, 28 Dec 2025 18:31:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2152C4CEFB;
	Sun, 28 Dec 2025 18:31:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1766946676;
	bh=Nl0zExVnGcv+a6pnsdYADQIl//NbnM0mSNK2Npcc274=;
	h=From:To:Cc:Subject:Date:From;
	b=DYnZ8Xo98Bp2Z6dXet8yKsrCR2Erlm2v2pr7WNLZeGlYXUjXF1TqK/dv4vH7nBE9q
	 4kudQE8gdhcLigBS2AjF4K2/Q2yCRbphFe4wW1UuBjpeSy5p4DyetWylA/DLGmBoCg
	 lWkdtl0FARxcNKg75U0fO1Ssz+CB8vpSvQUYJ8wRWYPLPNe0VILMCPB/rflOgXTmon
	 xePXxLN72myp/SxUo4UjOwfmVZyHwGuuwO5vQAIFRAKv2h2mPNwOKq1Ql8Qok1y9P2
	 ewl5MrwUrN7uAZpaVecbOzRi2fly51VlXgher4q4/2KyqwUT8146c/uGn/TITFFw7I
	 MWvuMwVfsqanw==
From: SeongJae Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SeongJae Park <sj@kernel.org>,
	"# 6 . 14 . x" <stable@vger.kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	JaeJoon Jung <rgbi3307@gmail.com>
Subject: [PATCH] mm/damon/core: remove call_control in inactive contexts
Date: Sun, 28 Dec 2025 10:31:01 -0800
Message-ID: <20251228183105.289441-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: nxbhdso1oba6gckwsaz8ca586azfndkm
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 53F6B1C0006
X-HE-Tag: 1766946677-175599
X-HE-Meta: U2FsdGVkX183JsEsKlxgVqaSC5dom++V8xdQq8UgTV1ozNbZpmMEYULXuzJSWifvedN9zM3ur3t20iuNJZkGCZ2FUy0OdI9jB8vEUTIb54pLvwDwDLc/0Y556Pn9i1cf2AnrHXZckRGmroSkpkpjT2L0t7eHX+GutSqLbE/nFs1lbbY4nqDPWpXhWf1+ocMllVbUUUdVNesM9szECDTnYsVAUiVM5B0nFw/wxptdQMn1SY8TsOZFBRyr243ZX0uIk+Xvy1YE7NWOOfKo7G8H9AKfoJOLSOab357uNmMClv4F2jKcn8srYRT/l8uMXTMPAhA0MfUzxCLuoUXU6biPLhIUHd0lunxNN1DKAMva4PQ+Kykw/PQG7CuWZhfMDb6zvFButjtlCC4YVC/2V4jJ2beEH9EizWDcVgg0B9cDrILx30rl2YGolnhqYPN+9KLLQ+acXHsO7pKuUwrtO8DlXsSSEyRJIyD1IBKbtW99NzYPQC9M60WHdSN6N2+tWXRAijy1swX5Qggmi6kyigAkuAR8ypaYlvd6XaU56eVCr9Qyih5XsgPB8ZIy/fDPRtQdDwLh2AvOn5xs05KdMC5luULXRwomNZMGU/YJq/rc8T/s9Ud/NqBn0eotOtDYo/pM1YVDpfM9mG8chahC3ZtKpeD6E3Z8EQAGZOKdnIYcqWKmar5CBwGjAbGUwILE2J3HJfUtJR5GbDevU8z5bg9wMDm5h9+6OnhA8/nj6GYpf3hE469NiPNqnDZoQ7WhYY6DJAKdPZjNql+OFar707o0Euut5a4GV8EJO4qM4fXqDrr/uzwlfA041ahkxfZg51hpOW+Z2kFz5EplKiLmQL3oeTUshRC5KzrvZV5Lfud4BbbiPv40Nsv9l64hpFwl+yvixmlj6t1BPUH49JG3XZnTXic7ILZdrWI1IdYkLknp6U8QSetcH8Pt3uAvarPUl2oc/iD+dJM3OWf1XG/RYnX
 tzv2ZEr6
 HmuOOSOC/+Fc4TTN4Y9wMGN1kUE3KYTsti306ny3w2VE6IHUUvRx+w2+4a2SGyE0DEfMP9MI4zQ8GagzccZZ9WPbpxvkU/2iKhTY8F9Xr1FJw8BwpvYzhJ0pIn6XG+jW9MyJLTkdE14sreJQyVkVtRlOpi8cJHC49u0rLlCPcmgbM7tY7eLm1H4MhvrTYt3S6NdxUZiXWSZYXeQofzUWLxqE3ea4hj5qNIysGTScCZt2WewWSvMpGCkRd6e9Frc4k89Mie2RwcLpBU6EvXnmPlly7cRo5xK6WODBvBc7/qJUwIjI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

If damon_call() is executed against a DAMON context that is not running,
the function returns error while keeping the damon_call_control object
linked to the context's call_controls list.  Let's suppose the object is
deallocated after the damon_call(), and yet another damon_call() is
executed against the same context.  The function tries to add the new
damon_call_control object to the call_controls list, which still has the
pointer to the previous damon_call_control object, which is deallocated.
As a result, use-after-free happens.

This can actually be triggered using the DAMON sysfs interface.  It is
not easily exploitable since it requires the sysfs write permission and
making a definitely weird file writes, though.  Please refer to the
report for more details about the issue reproduction steps.

Fix the issue by making damon_call() to cleanup the damon_call_control
object before returning the error.

Reported-by: JaeJoon Jung <rgbi3307@gmail.com>
Closes: https://lore.kernel.org/20251224094401.20384-1-rgbi3307@gmail.com
Fixes: 42b7491af14c ("mm/damon/core: introduce damon_call()")
Cc: <stable@vger.kernel.org> # 6.14.x
Signed-off-by: SeongJae Park <sj@kernel.org>
---
 mm/damon/core.c | 31 ++++++++++++++++++++++++++++++-
 1 file changed, 30 insertions(+), 1 deletion(-)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index 2d3e8006db50..65482a0ce20b 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -1442,6 +1442,35 @@ bool damon_is_running(struct damon_ctx *ctx)
 	return running;
 }
 
+/*
+ * damon_call_handle_inactive_ctx() - handle DAMON call request that added to
+ *				      an inactive context.
+ * @ctx:	The inactive DAMON context.
+ * @control:	Control variable of the call request.
+ *
+ * This function is called in a case that @control is added to @ctx but @ctx is
+ * not running (inactive).  See if @ctx handled @control or not, and cleanup
+ * @control if it was not handled.
+ *
+ * Returns 0 if @control was handled by @ctx, negative error code otherwise.
+ */
+static int damon_call_handle_inactive_ctx(
+		struct damon_ctx *ctx, struct damon_call_control *control)
+{
+	struct damon_call_control *c;
+
+	mutex_lock(&ctx->call_controls_lock);
+	list_for_each_entry(c, &ctx->call_controls, list) {
+		if (c == control) {
+			list_del(&control->list);
+			mutex_unlock(&ctx->call_controls_lock);
+			return -EINVAL;
+		}
+	}
+	mutex_unlock(&ctx->call_controls_lock);
+	return 0;
+}
+
 /**
  * damon_call() - Invoke a given function on DAMON worker thread (kdamond).
  * @ctx:	DAMON context to call the function for.
@@ -1472,7 +1501,7 @@ int damon_call(struct damon_ctx *ctx, struct damon_call_control *control)
 	list_add_tail(&control->list, &ctx->call_controls);
 	mutex_unlock(&ctx->call_controls_lock);
 	if (!damon_is_running(ctx))
-		return -EINVAL;
+		return damon_call_handle_inactive_ctx(ctx, control);
 	if (control->repeat)
 		return 0;
 	wait_for_completion(&control->completion);

base-commit: a100272b3541cb00a5e29fdc16e428234ebfddd1
-- 
2.47.3

