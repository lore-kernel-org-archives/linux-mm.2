Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 498B3EEC2B8
	for <linux-mm@archiver.kernel.org>; Tue, 24 Feb 2026 01:11:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1339E6B0005; Mon, 23 Feb 2026 20:11:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0E1A26B0089; Mon, 23 Feb 2026 20:11:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F2FCC6B008A; Mon, 23 Feb 2026 20:11:07 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id DC8126B0005
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 20:11:07 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 53F65C1A41
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 01:11:07 +0000 (UTC)
X-FDA: 84477571374.13.5619059
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf14.hostedemail.com (Postfix) with ESMTP id AD3A8100002
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 01:11:05 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=CBFe1Nbk;
	spf=pass (imf14.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771895465;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=rOMpt1A8U+J5nyx+JtJlpXpXMg4NWhIkB/48YRZPzEM=;
	b=CyZ8cspSX1dPgklbAb1gPoOfVpsZhiqm3Glv3Dz39zNHQPCW3fl9RMc2VvNpWItLk6K97c
	qeXhF7gb5raRwqIX8yIK1cGtiQTyTidQFmnz0gvVtWqBgBdhYvRmq62PJFcqbEoWO78XGh
	V7+sfLDU+NEhMqB5Klqw9UiShlYOUnA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771895465; a=rsa-sha256;
	cv=none;
	b=vfbVCTdCwUfYDKlUHg8BcUMysA4afT+dKhy4IYfEyGL/Ld80RVn1BIuqLme8TDDTBjGiEh
	WLscy2sHYeO1PR9VosksbvSSQ/rx0EZMJJrk+o1kQLjKfqmCqW/ISK9viZi9l1Jcsm/6q0
	wl3OkFI4H+lQ3rfedG7quyNxoNZcldw=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=CBFe1Nbk;
	spf=pass (imf14.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id F381660131;
	Tue, 24 Feb 2026 01:11:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B221C116C6;
	Tue, 24 Feb 2026 01:11:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771895464;
	bh=pGqupyrZkQnB2v5wYbkX7u71u2AJYUynj+S6P+vLWew=;
	h=From:To:Cc:Subject:Date:From;
	b=CBFe1Nbk9AM8YhBVdghjlxim5aur6yj0JF82zynSCGe2OEvY1/yYz3R8XejaDKB9Y
	 S8ugX+IHHyXJKcBNNPkt15M3PWSh67XxOrVXHZO9Ycu1tryAdsPaS80+tAEEL0KXdV
	 Yjie6LVSQcY8us6CbdxUHp442OU4gl7jVTcev7gwykoqRzjDljLELDJhbJg7pPnDNR
	 QGxgPO4wW1zsYTGca1Yn5pM3xCX1Rm1zSYkFrKEQK7HHq3LJpL7tMJtZKr5L3NQUYR
	 knUjeHOstMbS7HtfEHNthIL/fcyw5CgdiOVyHwMNwb88I48KMlAIdnCQoeMJbfelUV
	 2+srb6kvI553g==
From: SeongJae Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Raul Pazemecxas De Andrade <raul_pazemecxas@hotmail.com>,
	SeongJae Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	stable@vger.kernel.org
Subject: [PATCH v2] mm/damon/core: clear walk_control on inactive context in damos_walk()
Date: Mon, 23 Feb 2026 17:10:59 -0800
Message-ID: <20260224011102.56033-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam09
X-Stat-Signature: 8c8om5wkxhdbw3rscbctpr4tsdu9mugh
X-Rspamd-Queue-Id: AD3A8100002
X-Rspam-User: 
X-HE-Tag: 1771895465-999605
X-HE-Meta: U2FsdGVkX1/2P2tv6eX/+0aaCQ0klUWgQmQVgxcrw2HlJML9HJquqVaPEZWqDwMgBsJrTYM8hs/O6LeiXdCN2nWQqY1hb5eJKllpWwc7N6xdA3U3nhZCQTURnl01Afa2Sv15Ge+j9hk51pO3hyaudFI3pcrn6U89/1BMc0xpDn8+mG1mtW5jHRYGcngPKc8Pv6EEwtwGo/SrRqDP5Wi32xfJYUlc0bcYTPSboWg1/PyGj3GlyluZMvLqzVqM/Ih5AVKvIYHWpB3QbW29UI6XOyNK+WRKvjOgj0QKzPI0GV9qLpyQ1ez12+cNua2br9N+Foc9rIdz9A/4HnJXLkmF7biFMK3fKem7C5/fJwcpeA4EYyJOLyMwmJPe6Tll9KpviPwErON0IQtAbSkblmTFgI5Cynt+zWaJutZbP3eP7a79HeOE0tm3nllvwI/8lYIvFYFQpJ4jOvg5zm+CfqqAiVMddBRasAV7GsoXJ8QLglFBvASUGC03loLXxQQgP+ooIu8bCj7vf/QGXEE40JNgScQYkLXCQAoUmbTtXamPBdDHGtitovR19SQGECAq0kBYhRrh5NwdXuOHyRgtOZAEbbN5WykvD6MRrioOAQle5sqRYFLNZTXRTlwdG+MNyz7XbIO6EoBzmwXMfzQT7jbtOR/D00nmRxE2HSCGA1Hj1jAu7EUELq6NZmoG9Uivt7MYrq3bmQPKZ3gG+BCcth5b0M0CHGVjqk/myeP9IWHD9lzoRXeDCKl+qooCNI4dq57CQRKtlX25vXTEScZ7R5xVG3pWcGPLJmSxIWPMizaDue5hyc3kpUjqKNjcO9ol56rvltsKnwq0/yy8uZxD41pECuIrIzRH73JSFHuD9AYFfkzKhW9GwQSXkztVfMqnOYQijhfMlE2L6GXUL8kaSkKHD6PKQR+GG5RaV5b9neBteik9v90uAK64FWOID24mJTIQeOShhx5FH5TZ5MkSov2
 Rj41GyV1
 s4r/1WCC0NH3Kfkq8Unk/mKU+KNe2/mc87pWGM6I7MtA8HRZdMlrMs+1CpgW08Jf5mnslxFm/qMQQvULklQjSEQK1Gut87V7W2eHRxCWkW9n/xGhKJvRsr+7/VC+U9WvepSXWWQCsl6BktddAnGxEoCW82vZu35Lb6FubJn/meeVOLv0qWNvfVf1IPCcbtVmfKHJxaR8y2zl1Bdlyk6icJlu73JrUGr917wDC94QGRH0/dkY3A+i0YnwHH0U9VyHePF+zNdTXb9Ed95GWNJ9WF3henqEMVZaImehX4EbAVVeKnrXY0Q5BnPsIeyg3cdkjV68Jj+TylxXYLXG+kZSlHTFbE+2ohnXs+gE10P2K8Tk83dk=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Raul Pazemecxas De Andrade <raul_pazemecxas@hotmail.com>

damos_walk() sets ctx->walk_control to the caller-provided control
structure before checking whether the context is running. If the context
is inactive (damon_is_running() returns false), the function returns
-EINVAL without clearing ctx->walk_control. This leaves a dangling
pointer to a stack-allocated structure that will be freed when the
caller returns.

This is structurally identical to the bug fixed in commit f9132fbc2e83
("mm/damon/core: remove call_control in inactive contexts") for
damon_call(), which had the same pattern of linking a control object
and returning an error without unlinking it.

The dangling walk_control pointer can cause:
1. Use-after-free if the context is later started and kdamond
   dereferences ctx->walk_control (e.g., in damos_walk_cancel()
   which writes to control->canceled and calls complete())
2. Permanent -EBUSY from subsequent damos_walk() calls, since the
   stale pointer is non-NULL

Nonetheless, the real user impact is quite restrictive.  The
use-after-free is impossible because there is no damos_walk() callers
who starts the context later.  The permanent -EBUSY can actually confuse
users, as DAMON is not running.  But the symptom is kept only while the
context is turned off.  Turning it on again will make DAMON internally
uses a newly generated damon_ctx object that doesn't have the invalid
damos_walk_control pointer, so everything will work fine again.

Fix this by clearing ctx->walk_control under walk_control_lock before
returning -EINVAL, mirroring the fix pattern from f9132fbc2e83.

Reported-by: Raul Pazemecxas De Andrade <raul_pazemecxas@hotmail.com>
Closes: https://lore.kernel.org/CPUPR80MB8171025468965E583EF2490F956CA@CPUPR80MB8171.lamprd80.prod.outlook.com
Fixes: bf0eaba0ff9c ("mm/damon/core: implement damos_walk()")
Cc: stable@vger.kernel.org # 6.14.x
Signed-off-by: Raul Pazemecxas De Andrade <raul_pazemecxas@hotmail.com>
Reviewed-by: SeongJae Park <sj@kernel.org>
Signed-off-by: SeongJae Park <sj@kernel.org>
---
Changes from v1
(https://lore.kernel.org/all/CPUPR80MB81718B12798BCF9959535B05956CA@CPUPR80MB8171.lamprd80.prod.outlook.com/)
- Rebase to latest mm-new
- Add notes about real user impacts

 mm/damon/core.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index 6be8c4cc14162..eae387d4e0786 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -1562,8 +1562,13 @@ int damos_walk(struct damon_ctx *ctx, struct damos_walk_control *control)
 	}
 	ctx->walk_control = control;
 	mutex_unlock(&ctx->walk_control_lock);
-	if (!damon_is_running(ctx))
+	if (!damon_is_running(ctx)) {
+		mutex_lock(&ctx->walk_control_lock);
+		if (ctx->walk_control == control)
+			ctx->walk_control = NULL;
+		mutex_unlock(&ctx->walk_control_lock);
 		return -EINVAL;
+	}
 	wait_for_completion(&control->completion);
 	if (control->canceled)
 		return -ECANCELED;

base-commit: 252ff65aa9536c88ef66dedfbdafe63a479a4b3d
-- 
2.47.3

