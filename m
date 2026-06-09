Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6229FCD98C5
	for <linux-mm@archiver.kernel.org>; Tue,  9 Jun 2026 14:21:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B9B3E6B0093; Tue,  9 Jun 2026 10:21:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AD3CA6B0098; Tue,  9 Jun 2026 10:21:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9C5226B0099; Tue,  9 Jun 2026 10:21:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 89CA26B0096
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 10:21:25 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 5183D1A05C9
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 14:21:25 +0000 (UTC)
X-FDA: 84860586930.30.E50E944
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf30.hostedemail.com (Postfix) with ESMTP id A4F5180016
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 14:21:23 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dBYBOWtN;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781014883;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wvTmgzWVeo+cgK/5Fasuy9LNL6Vq1lM40f7iFKommVk=;
	b=nrMtmXpkkmdRqqR5gMnMuwxYts+T58mXxl+60/Fb6wd43KdhA2jL8cMxgK5DMsVJ7rFZ5G
	FwZyo3dsYEA/LxSOzNVa/mLqFuufvUvGZA+mDSTrS0u6+yRUKCkibydOI6cHPKcW1BX+D1
	MaHhoP0tu46nMwGRA/mfKFtHLk7nIRU=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dBYBOWtN;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781014883;
	b=B88Gd7HTrAB8KTaPVzL/vJ/6iufbz8BeQ/PyhPT3YoI7IT7ZBtgSJmRpdaGJAm/kuAwxqY
	2Jnpb1sC7ss+NytesGPp9D+Z0WayXBhBH0MoVzyQljnTnzpv9HXHL2SpizaneDCmj+0k9C
	cakWSVxeEgFsaDIC+poE5actWvFoLRQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 39C2960208;
	Tue,  9 Jun 2026 14:21:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9C0C1F0089D;
	Tue,  9 Jun 2026 14:21:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781014882;
	bh=wvTmgzWVeo+cgK/5Fasuy9LNL6Vq1lM40f7iFKommVk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dBYBOWtNu/9rQ/xS6E0Bw2JnAvyTScw1/GnV+s5gpa21kSaJ5OgEOXYiBRekApavu
	 0Z+vAyNSAatnCKVudQPt//H/Wewnad9lZvbZp22exymEo+BS7h8wRx9eCBB2OB+7v7
	 dLnhKOANWGhxGTbWLcO2MZdu/jdp/s2gYVedTw0qqhV7Tz2n6MVxZPSl1DF3mqiNf8
	 LAvVA/sUOP8PYD0LTy0dhWVVqpvhGg0a7cHs1wuRMBQFucoL9G1cbydrMrZSmqAqUX
	 ZK30IofnXwoemrHCcWtANjWbnIg7Kk7tWLzBFys7O+8j97A1HPH2uz5vYPCCfwGh7h
	 53aM/zUo1sY4w==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	"# 6 . 16 . x" <stable@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v2 2/2] samples/damon/mtier: handle damon_stop() failure
Date: Tue,  9 Jun 2026 07:21:17 -0700
Message-ID: <20260609142119.68120-3-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260609142119.68120-1-sj@kernel.org>
References: <20260609142119.68120-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: A4F5180016
X-Stat-Signature: 3qewfu4i1gwcus9u6ctapozndyij7fzu
X-HE-Tag: 1781014883-906887
X-HE-Meta: U2FsdGVkX19TJieNuLDwCoSds1DN6t2zWBubNQFxZA+FaRY4PBG+YXzZYuuCJl8o6W+dwst7XJvQb9F0UD5/OgZHE0m61efprApDRMrqTrv+OsVonZbqbsCD/EPqff6Td5ffoj/vtWwVny5H4ZJuvEjZQ8KgiVGscTGpeFPkNCmRe0n9C2ujrHBgRQn7GEoFTesBEtrKCzZ1icucROWoh7St1Z07aJN78A4BmfTzrZiy4/bXkz4e/9qXGLTP7Cd1H9FcNRBbaa3ub/SUizYZ5DTyPtmFrCYtPiHs8oURmh0cNoNGhCSBcxqOcBXK/niNjgDYM5wutBC/a2xROyV0aivAN3ZztWPmzBSJBHLnz4TFgyu8vHnSMuJisNsR7X1mTOMbR9vFuzfNj9AatGKD/4LVp1koBFkcr9RtbbvkrZp0MF8uHO3QLaCSHOBzthATDfuJ+zvGZ9Wk9YNUpkhK6b/Ri64eFsRAWusX3NOgjTops43DoZUgOoQRqUDnypq9ekTw5GIlWfe8Slx1iOM8aKx9ivqVboVO3x2CXZjy9pu4cUHxnexV0CL8bXTZz8F0AZfahnhG0bjccLv3Mm6yGb2T1p3qdBmZ4tK4hQ42HF9OHz94uVWajWTp4KRXYY3Hik8PMSEa4TejcyGUe+KIYH6c2dj5l0JMaxd1WG8tmARBw/sG/YHxXc0RPGNhYA7RHCSUSBwpSK0cGmpljUKI9nxEWOvvndp/DdB6DBSTEhrSrG7OcExfqgXDZyFJG8WEjIIq8PP9Wyqa/eh41BqfmSC6GoUxhctaAOATNsqAV3dnVmbUdCW6f9mWyLdpkjcu1O9JIKO4lnE3XKl3PrXSHnyx+6EaJ43M3Gwy6YVcTd9WdIb2AgQucnysgYFaQJcHwWby+lMCRpv8mjGH/MkvlfaOSU32HPRa9kiiN/n9nF4TTbQDcOwAQpN+g6Cw5gxOVEfT7TPjHsl4qsomQWT
 keM+azsC
 vCvvQr3s5jQXMNAowzawMHYey901hZxTIu0muXMJ3xehKNfUE7WdM3ey4IyLPvcOpolffdR0ha+MI8Y2v8A/kEKio9IwM1sPtGQw/NOTaALbgUh/QgbIOZMtBaids1d32ze+pDwQiucsxiwyPYAd74+4/KPQ7x6AJKUYL3KycXyzklrl6RmnAByw/7OwS2dce1bq4nrUedIF/DUeGJEyy3mWfLwuB0LQ17ct6Tbc/NTlKjlDTbz8s6QzNr08DaiLBdTOki25A2JmiqgnFi+APWeMylA==
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
Signed-off-by: SeongJae Park <sj@kernel.org>
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

