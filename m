Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 396C8C9832F
	for <linux-mm@archiver.kernel.org>; Sat, 17 Jan 2026 17:53:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 563E16B0096; Sat, 17 Jan 2026 12:53:09 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4CD3A6B009B; Sat, 17 Jan 2026 12:53:09 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 295176B0098; Sat, 17 Jan 2026 12:53:09 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E1A8D6B0095
	for <linux-mm@kvack.org>; Sat, 17 Jan 2026 12:53:08 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id A42581602F7
	for <linux-mm@kvack.org>; Sat, 17 Jan 2026 17:53:08 +0000 (UTC)
X-FDA: 84342202056.16.499791E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id 033481C0002
	for <linux-mm@kvack.org>; Sat, 17 Jan 2026 17:53:06 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ZD+CWFO2;
	spf=pass (imf18.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768672387;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cE64oI52RCW0HyFXgETWJL7AUZwopVumMBM11uXhLzA=;
	b=uCCNP0bKaFqMRL2uBXf0xpMF8l3GoNiCHZD/8QIOdYdLyvmm8LQrdF7zfPEGRctPLIxibg
	LCiVLkjZWmVsQuMZy/Ui5D7t/RA168A9df7s7h3YiF3f0/67ls0T8kYesWo72XNfatb1kK
	ikTJIxca7g8/jVOzzUlrNoxwNnZ6N8U=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ZD+CWFO2;
	spf=pass (imf18.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768672387; a=rsa-sha256;
	cv=none;
	b=QC14G/M59J8iq+xbJrnbH6/0q/l+4N7Pda2fT+P9HLVOWa0qYhXDrEZn5ZzyoBAeF8ZfbI
	uIkHHWTCsVoIZvoqF/Vl8r+qv04/13R7Yheyi5725DN2b0zhlqW1nI2YOmOaRUctiVaKy7
	eH50v7iUjDgjvuNX3GMDtxKooZhMQyc=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 3146B44509;
	Sat, 17 Jan 2026 17:53:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75CA0C19423;
	Sat, 17 Jan 2026 17:53:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768672386;
	bh=OpNBmjSVIXZeLwKSC0iBB/4oylJS3GFwqsmSW7MYMwo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZD+CWFO2bByzHP1/Ma1LCn2h64LHsI2D7NRiTxOT21csK0eerKc4/8LCnGXSMglka
	 rjIN1W5CEsFQr1PmX7TzAa8uHeMsXK/2T6FnIZQ58Vc2wqOkK7K7C4RoK7iC1oVRX2
	 skBjw6qjxQjlMTloFm4wiomgLW225lxj0gDjqudo+RhQjxQLirUaT1zhiA+4zX/3lp
	 iiR1FO9o2EkHskCXr/cCc2v4LxzxqJeJAlIdLN4yOO9otcGAOn6VVtkjMX5e/vSLE3
	 3OvgWAlo5ucZ+lPqpLGMdJGu+QEcw7w0cqhdQ++w3wYsIddpZ5u62oyQSK3N/T7A90
	 n9hJM8a3GkHcA==
From: SeongJae Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SeongJae Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 4/8] mm/damon/core: process damon_call_control requests on a local list
Date: Sat, 17 Jan 2026 09:52:51 -0800
Message-ID: <20260117175256.82826-5-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260117175256.82826-1-sj@kernel.org>
References: <20260117175256.82826-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: utsm7arz74ho34gif869g7om1aactn8s
X-Rspamd-Queue-Id: 033481C0002
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1768672386-995993
X-HE-Meta: U2FsdGVkX1/j+1XPACg6YgbBKHgDXol2a5gHzU/ytfuW6gQKpJVAHMpuNrSERc+hL4upvA769AFEqwtNDpxTd4bo4X+q0WxoWFpE8naFZL6qS7IgBYFU0BLdx/ZJwugJVm3cPKcjy8yv9WW6xFqF/tD28sHpnTIwBlMvmGnSt+G1JqzDvU0uYkDp+6iC2/A2v2eD/LcuSo3wfhHRSNbIG5PM6zhpdq4tz15OmSla0OfcLUV/Jqzznkubc4esMppDqc25tXiKWki6mHIjP7WOHAAak/ePeW2mN+1Kw6gg2CjBZgSk17sIA8tB/i2CbOv1P+Xd2qJh11tYKirIbvOjZ1CqqJ9BWHCvKoGUQ6EyHq1wJYkDDtkm2eenljiNTxvAqxoD+qMfSUYwiMtF+qa6HjwGI3fNYqjHIbLqIochI3hLxY6Prny7tAKko8K1ZyE88E/afcqloh2eePSrgFCRhJaLaKNku4EEij7AeIdUZ/u+QkB5Uxf+3HMOvOvmvGmUQYU59VygGW5d41JGZK2ochmJqgV5/DR1L8k7Qr9yQ3lXA/85C5CuRN9z4PcZzBgUgDZex/stMX9y82wSJf1NZmir1ICqZ6doaYu614aNFOfL6TOYbYb8SexB+KxW21u7Qn8kCkuazkYCkT7WkRgPwlOnYvjCdLueX0yfDeqr9eDQEW6M5yMvhw2wz/JVFkCk/sauFOr1e9zRRZgsA6UREV3n9AGRpPQ2UsxeL9W5piVFwbsEg15ww7ShGjo3AlSRxD91ZKJsrHZrI08L7TbJ5FRgb8HSD92x8z9Ae6ZgcWA6zxXrv3No58Vo9lsu3KfaRzPFMvUbwVQ+6iKCpz9Pd1U8L634Kn/gziYxqscPw5WCFBGP1RyBb6wP59w32+MPvfoJS7ZX45daaFdd0YtWEOU5d6wmfqKlZyjEUx2AIDBtTVgVZfg0jrXzL9hBG2+nqXXliloggxEFuFhxZuP
 DYUPyMoh
 uZ2LrqnU17ZGfPmNr3+6xRfT5U4Dv4Ye7UJGxhPVGios6WVaAxf5bfr/m/UaSEDepglrPUJMV57ztYGy8JkR1nQ6auGJT6DOoKPeN8epV29/k/WztUCN1SAkAXRw3Le51kMDQvEZtXQ0vqt+DWuSFtbhxBa/bVQoFkGTp1glVong7yUCEZZwyyjcCkqyaAZGP+WqPO/VbBbjjuZlwGcRgDT74wL/E01AjNRPsGGu99D+IlLtENW3dTm1V9Q1xUQqCeFrez9OyjCOkJKcrXs9UYu+WXw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

kdamond_call() handles damon_call() requests on the ->call_controls list
of damon_ctx, which is shared with damon_call() callers.  To protect the
list from concurrent accesses while letting the callback function
independent of the call_controls_lock, the function does complicated
locking operations.  For each damon_call_control object on the list, the
function removes the control object from the list under locking, invoke
the callback of the control object without locking, and then puts the
control object back to the list if needed, under locking.  It is
complicated, and can contend the locks more frequently with other DAMON
API caller threads as the number of concurrent callback requests
increases.  Contention overhead is not a big deal, but the increased
race opportunity can make headaches.

Simplify the locking sequence by moving all damon_call_control objects
from the shared list to a local list at once under the single lock
protection, processing the callback requests without locking, and adding
back repeat mode controls to the shared list again at once again, again
under the single lock protection.  This change makes the number of
locking in kdamond_call() be always two, regardless of the number of the
queued requests.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 mm/damon/core.c | 59 ++++++++++++++++++-------------------------------
 1 file changed, 21 insertions(+), 38 deletions(-)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index 0bed937b1dce..54a7ea98340a 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -2649,48 +2649,31 @@ static void kdamond_usleep(unsigned long usecs)
  */
 static void kdamond_call(struct damon_ctx *ctx, bool cancel)
 {
-	struct damon_call_control *control;
-	LIST_HEAD(repeat_controls);
-	int ret = 0;
-
-	while (true) {
-		mutex_lock(&ctx->call_controls_lock);
-		control = list_first_entry_or_null(&ctx->call_controls,
-				struct damon_call_control, list);
-		mutex_unlock(&ctx->call_controls_lock);
-		if (!control)
-			break;
-		if (cancel) {
+	struct damon_call_control *control, *next;
+	LIST_HEAD(controls);
+
+	mutex_lock(&ctx->call_controls_lock);
+	list_splice_tail_init(&ctx->call_controls, &controls);
+	mutex_unlock(&ctx->call_controls_lock);
+
+	list_for_each_entry_safe(control, next, &controls, list) {
+		if (!control->repeat || cancel)
+			list_del(&control->list);
+
+		if (cancel)
 			control->canceled = true;
-		} else {
-			ret = control->fn(control->data);
-			control->return_code = ret;
-		}
-		mutex_lock(&ctx->call_controls_lock);
-		list_del(&control->list);
-		mutex_unlock(&ctx->call_controls_lock);
-		if (!control->repeat) {
+		else
+			control->return_code = control->fn(control->data);
+
+		if (!control->repeat)
 			complete(&control->completion);
-		} else if (control->canceled && control->dealloc_on_cancel) {
+		else if (control->canceled && control->dealloc_on_cancel)
 			kfree(control);
-			continue;
-		} else {
-			list_add(&control->list, &repeat_controls);
-		}
-	}
-	while (true) {
-		control = list_first_entry_or_null(&repeat_controls,
-				struct damon_call_control, list);
-		if (!control)
-			break;
-		/* Unlink from the repeate_controls list. */
-		list_del(&control->list);
-		if (cancel)
-			continue;
-		mutex_lock(&ctx->call_controls_lock);
-		list_add(&control->list, &ctx->call_controls);
-		mutex_unlock(&ctx->call_controls_lock);
 	}
+
+	mutex_lock(&ctx->call_controls_lock);
+	list_splice_tail(&controls, &ctx->call_controls);
+	mutex_unlock(&ctx->call_controls_lock);
 }
 
 /* Returns negative error code if it's not activated but should return */
-- 
2.47.3

