Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BEB69D39426
	for <linux-mm@archiver.kernel.org>; Thu,  2 Apr 2026 13:44:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 194536B0089; Thu,  2 Apr 2026 09:44:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 144E06B008A; Thu,  2 Apr 2026 09:44:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 05AF06B008C; Thu,  2 Apr 2026 09:44:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id E99D36B0089
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 09:44:24 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 8C6981A06CD
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 13:44:24 +0000 (UTC)
X-FDA: 84613735248.12.F5626B8
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf15.hostedemail.com (Postfix) with ESMTP id 0D047A000D
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 13:44:22 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=GD2w7grr;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775137463;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=9FBBIhpGTa/c7qj8p2grOiUf8oqGfURMv4tx+4pz6EA=;
	b=6mg30lHb9fPeqqxiCAiYXxIIHLEVWyZ5BbMv0+6NX2YQi1HV0gyqfYH6iQOkqs3sLh8dWm
	F0hVQhuBVLQKQP9ouYM+Q0ygW6dDMgoDb399zuIsPOwqi+W7wiaJrQQQYNWPHJ2IpdmXtF
	b5Yclq8tkvTmzeDV3ZB4G3ZGZ04fcFQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775137463; a=rsa-sha256;
	cv=none;
	b=QVj8lBozA7cCoU9/6ZmVv6v9jJl/EDk60kElyLFKScRWseTxEgTyJYicKs+W8pn2UnfPhi
	Xsw1Dn12grxeJyDAbyQ3z4ST1QhovNdWN9KYQWSMCO0f11EmuNpns9fw999NlGUUyXX5tv
	O9mtckVuZIauI/NM1oPyGQZ/jr0Dnls=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=GD2w7grr;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 7C88360008;
	Thu,  2 Apr 2026 13:44:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0B5CC116C6;
	Thu,  2 Apr 2026 13:44:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775137462;
	bh=vWy3Mr67e/mUpyvjLCi1g5zQ4l/TF12eriSgynYdpHc=;
	h=From:To:Cc:Subject:Date:From;
	b=GD2w7grrtrr/CZlQzleyPPGReQ7JmOI3FDQy9Qnv2i3qEpYQmSmHG2u1tdK9IB55J
	 27BCM+MqpYGj3aMVBGVj34Zbk7VK93KuJIEJ21BEI6myezF5Z65YwY0pmsoYQLV1pr
	 4d9HL3CdRGCvOCB6ihzmLaMbHwgnCH+HAzerWviXKkjPvV5JIDCZqtaDNUF/PDmN76
	 MFTyY8jOGqzZZasYLp/z4HdtVAmMEJhcyja5WjDRtBGeP1Z+Ukhuky019III8aaSU+
	 VKNl5FxVFjt1XlKqxBuYmt1hd+ZuqNTAEDL+vEnqYxowEHWO50ZQAtH+f50EqJZu+g
	 RzzZ6fOPXdLLw==
From: SeongJae Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SeongJae Park <sj@kernel.org>,
	"# 6 . 17 . x" <stable@vger.kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH v2] mm/damon/stat: deallocate damon_call() failure leaking damon_ctx
Date: Thu,  2 Apr 2026 06:44:17 -0700
Message-ID: <20260402134418.74121-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 0D047A000D
X-Stat-Signature: x3mmotfmcigmpdwoqy656ky3uxzch4g1
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1775137462-897688
X-HE-Meta: U2FsdGVkX1+faQ9em4uyMjQHN8W/5pVj5wIFti3R4FP17VyRGN3GXB6Z1I3pDOIRMwnZTa5xowNZyf8lFhRg3yGgNpCjL/9rtuqbeZVshOOJny3XsGN2AIb77wAWnagDo8keuCmVtP+nB7dteOCZFiHSL+5EbJVHXE+uHXzqYI219dQbs+aIdkVuvLZSWu/cr3hGQVUYDnE8FmZkuwqPo0iidg5e805c363DUZTlFNcdPW3QL+5FuL0Buy9akb7Td4gaiWmHU2Isysnjzv/HLK4PjH08q2bm+piIvpYTIOks8f5j6L/K96O4vJ28KiXsDOa68v8Lw/yiwwy6DjqziUUIz8FBIaOcO4dCqV3LNiDp+aQpUCKk9820AjkIn+V23/ZtLKaYdFa5JzvGwrkP+sDjXMyZi6gSXs5YTwf2lJYWBndXn80fMp+gL0DpZhfjB1Ozs62TWI2FIq8ZHgfGRtSPteSU667YKbAQo5HKwNpt+KY8xc2hVVL81vokdJkppAPlx6QvslfytaPjT5cK04Rov4pP4igUum+tftGc0wNnfdVbg7htvEL7wqHRaFmXegc2eUJ40GoTvuRK3vAtVGCW2LR/xXZ5S3a1Ot/rqOdiyphskHq0xYY+xaoXZjm9w7g+OiLXOB3sCh6gYyXZf1hjNBB5AX8iTEo34XUl0GDsxuPg6PCN/wjleYfMte0TXFtm+hRnU0Wxley/9tDxHt8/+GUMTnLscnEuBfkqjaf/ISXP6wCUQ3zd60ecsDPEdD/Qa3T23GrIAd6Fg141Qc5cmsG8YcrPWq3ozqdBx5FCTBWMBXhYlIi/ywgVSXWWVKIqvVPYuWi+NX533pVAEedb8HhqyNPdCT8zKV1Fpe+CAhCWtw/yGYHR08p2NZ3pCepF+gYc9+rhbRumelKzK3Hlzngijd40ugjEYL3htlqFdcKeC7iAdoJGi60qyUYgu5B3c7eM+kcEai1CP5c
 AHs70Acp
 m/p1H8kl5mqJZRdZSIkHl3ycFtNo5wtHKk1UXJtsho6Ell7O6R6Ish1MQQ5RReVCH20JCcVKIVMGyzc498jp8eBDIwE5rop5q2Z6QKRdg3EXUmhiCbLAx6O6Vv5Pqyi2kSHFjIrRD944TxYOYlYAZq/LXc+uQh9pMjO61PMdLk3ivgKDHNXordPlU/HkoBig+5zCvFFmN0eq9bTGCULuluDNv3f7z6YofQG4A/lktuH9+1OR/3kzyDPKeRLaU14AdjDMsRUJgczvRlNQZCaQVAMqC9HZskZGlfnXM08TEoGslzHESUajbEVtFpQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

damon_stat_start() always allocates the module's damon_ctx object
(damon_stat_context).  Meanwhile, if damon_call() in the function fails,
the damon_ctx object is not deallocated.  Hence, if the damon_call() is
failed, and the user writes Y to “enabled” again, the previously
allocated damon_ctx object is leaked.

This cannot simply be fixed by deallocating the damon_ctx object when
damon_call() fails.  That's because damon_call() failure doesn't
guarantee the kdamond main function, which accesses the damon_ctx
object, is completely finished.  In other words, if damon_stat_start()
deallocates the damon_ctx object after damon_call() failure, the
not-yet-terminated kdamond could access the freed memory
(use-after-free).

Fix the leak while avoiding the use-after-free by keeping returning
damon_stat_start() without deallocating the damon_ctx object after
damon_call() failure, but deallocating it when the function is invoked
again and the kdamond is completely terminated.  If the kdamond is not
yet terminated, simply return -EAGAIN, as the kdamond will soon be
terminated.

The issue was discovered [1] by sashiko.

[1] https://lore.kernel.org/20260401012428.86694-1-sj@kernel.org

Fixes: 405f61996d9d ("mm/damon/stat: use damon_call() repeat mode instead of damon_callback")
Cc: <stable@vger.kernel.org> # 6.17.x
Signed-off-by: SeongJae Park <sj@kernel.org>
---
Changes from RFC
(https://lore.kernel.org/20260402045928.71170-1-sj@kernel.org)
- Drop RFC tag again.
- sashiko didn't find any real issue on this version.
Changes from v1
(https://lore.kernel.org/20260402010457.66860-1-sj@kernel.org)
- Avoid sashiko-discovered use-after-free.
- Add RFC tag.

 mm/damon/stat.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/mm/damon/stat.c b/mm/damon/stat.c
index 5a742fc157e4..99ba346f9e32 100644
--- a/mm/damon/stat.c
+++ b/mm/damon/stat.c
@@ -245,6 +245,12 @@ static int damon_stat_start(void)
 {
 	int err;
 
+	if (damon_stat_context) {
+		if (damon_is_running(damon_stat_context))
+			return -EAGAIN;
+		damon_destroy_ctx(damon_stat_context);
+	}
+
 	damon_stat_context = damon_stat_build_ctx();
 	if (!damon_stat_context)
 		return -ENOMEM;
@@ -264,6 +270,7 @@ static void damon_stat_stop(void)
 {
 	damon_stop(&damon_stat_context, 1);
 	damon_destroy_ctx(damon_stat_context);
+	damon_stat_context = NULL;
 }
 
 static int damon_stat_enabled_store(

base-commit: 4fd04f750d79667937931314ed64c9d79b0d82ef
-- 
2.47.3

