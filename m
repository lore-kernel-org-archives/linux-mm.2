Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 82506C61DFD
	for <linux-mm@archiver.kernel.org>; Wed,  2 Sep 2026 05:48:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 701466B008A; Wed,  2 Sep 2026 01:47:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6CFB16B0098; Wed,  2 Sep 2026 01:47:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 549396B009B; Wed,  2 Sep 2026 01:47:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 319D86B0096
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 01:47:58 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id B874B4074C
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 05:47:57 +0000 (UTC)
X-FDA: 85167740994.17.BAD53A7
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf01.hostedemail.com (Postfix) with ESMTP id 33EDB40006
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 05:47:56 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=kUoiPmmq;
	spf=pass (imf01.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788328076;
	b=FaekwxlGK/2cl25uLEXX3pQCDyAzvGhxUfoa3WatS8adNQYDgjLlad9bZd7aIKeQT9Qu+2
	SZucu9LZs+YVPAZLo2GT1n8A6K0Z/NleeXMqxm+04h5A+BNbmZyBLk3JAatdY/e2iG1Ex1
	p2vnPdO2lqY09B33Sf83ymoqv4AIu8w=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=kUoiPmmq;
	spf=pass (imf01.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788328076;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/2GY869qZ/WdOTeEodZMAmxRd6cUaT9eWkbGwKB6Io0=;
	b=5pqbmFTEtTzt+u4upmrkaJmaMLzCiBaym1xbyGoAp8N22GTFQ4xUC/8QvoNABbaAAkcBFW
	OClqz4tn2Kpchs1xnoNHfwAygep673kqBsKE5cG0XlDhHpsZ2lJJsfo5j+IFRJlLNw/gKc
	XH0kLQ+vMmVCLcHfysrnNWSUD+mp6s4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id C5ADF6022D;
	Wed,  2 Sep 2026 05:47:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54FD91F00A3F;
	Wed,  2 Sep 2026 05:47:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788328075;
	bh=/2GY869qZ/WdOTeEodZMAmxRd6cUaT9eWkbGwKB6Io0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kUoiPmmq03z/pb7EKGpCiPYdf45lsEaJSgpcEVNGLP7V9FyprLGvAUBD7xhy1y4Sw
	 qoXrgWdYnlre3eDn2J4hryFgCgMUZczJj+sVEQB5XhAWABL0/gtqMKZ26RhAAOX+E8
	 5mZK6VGdSDUd5B3nrxq6+7YS74Kia36vMOGaAjY7UNGqVB3abzr28N9Hx0b1pYiH59
	 94pce2AY6l87qeXrKloejLqv8ilvg1jwU1HqXpmHLadZAVyxti8oC7nQ/Bdj38Oas9
	 LdStC6DskZNiKJsZhvkJJDxDAhZiVFEOhEYRbGRvlWariFc75TAlJxXpoaEgySQZ8M
	 Ezrm9zfSFQKUQ==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SJ Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 03/12] mm/damon/vaddr: remove a debug message
Date: Tue,  1 Sep 2026 22:47:36 -0700
Message-ID: <20260902054747.99370-4-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260902054747.99370-1-sj@kernel.org>
References: <20260902054747.99370-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 33EDB40006
X-Stat-Signature: kyhz47uzfbmd6opdzn8amny4yoinemjz
X-HE-Tag: 1788328076-582023
X-HE-Meta: U2FsdGVkX1/jPjCc2dLcKZcORmca4kOL140T7mTLpeMTI5tSoA/On1vs13dWQxyW+W1SkDF4+fqsLnxT45wNCYIWF0zN3kgBT88WkZn5gW2etaFGxWNjJUSrvwzyZLJOZ+CCFhP0Txp8tC9pcMhBRLzJoLId8t67qpeagZfkE+vZ1CCkuYX9SsU4+/HRcmWfgIbYfdpQFVT6KqmVLNawUt1mewJod/OIkXfQqFnpCk9nWkdmQ4NjIsHkZS/DuCUo4gguwUmmpuAVZ6RF4iyCygNwn2N6IfwDATMQtPRw1hArVS+HZWvJi/Zz9mVGQPFsJK11X82JkwQBhWsUSqvOf6XeqlX53Mxyao960NFXM8qCe1G1Qs+GN8FIzbOrtysrHUZYsdDqddcoioXfYwuwc/udm4aMGZswDZ+pCmsjknDmW5x1D3aP/PRWh55p3TjqTVOSqRKDqN+o0icVQdZu+08ul6ojNZTtMrK6YtFZQOlKWlQama5VnI5WbaU5nMHFfnU/tky8004HH5NBVt3p04WxZFKVJ3P+eqFXn6Sk46XVZowEB37LTSoZTlP+FLmOY4fzwTuXT6CQU9035vZErFSGcshJIERziJu2EkWy9X5hAr+Tw9ZzpIV5KjKILxETMqPnr2qbyQMBRLTPJE1voSeYUPAMYB7MgK/1ilqZQiTq4zx5WCdw25TFp0qM7hLb7+9SJybOZ61i0Ky5Cz9apzp4qgafTMfCfPmIWLmhPQ3OtrPZxfr6aHcOsFKwTYEwz8r7gLtSiHsKq2OF18lMzjakseeqwy3Llu+OuHsU7NKWFe7EDCIGxkXjs0rMx4UJhmessuN/oyb+cO+60nBGcmtel0Lk5GXdCE8QYr5MWXYxf53iKn90Q9xpgaIxLoavKrmmtPeJQ9QcRommVhjy2Avc+66jFC4Xx8/LCDBVcYrVNVHscxnHf7XOFWEfMyv8T5YqdROhE+Kdu6sr6Pj
 oJo3f+l9
 ptJ3wqzMcpB1Ar2cYH9koO8vWFuqeC7J+JV8lONB8K2DHX4/LeWN/tQNH6W8xP205fBqHkGv0/kjjmWTdpLrVrKIETSVCOHvt+8Fo8fka8KXd+6u2VkZf+GV5BW6n0YXwb0+AUFWYHKTY1hlfudryX6XbImIeg1MiTAUEQPFpLagsZJvdQ2uXgjXtQDgCAV2oFQSVL8zyaj9uxTRifpd90Kw89cyOV2rydWPUVWsCKuyDDOw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

There is a debug message in the DAMON virtual address space operation
set.  It has not really been used in a meaningful way for the last few
years, though.  Remove it.

Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/vaddr.c | 16 +++-------------
 1 file changed, 3 insertions(+), 13 deletions(-)

diff --git a/mm/damon/vaddr.c b/mm/damon/vaddr.c
index c8c32b2ae0402..f884d3f78f30a 100644
--- a/mm/damon/vaddr.c
+++ b/mm/damon/vaddr.c
@@ -189,22 +189,12 @@ static int damon_va_three_regions(struct damon_target *t,
  *   <BIG UNMAPPED REGION 2>
  *   <stack>
  */
-static void __damon_va_init_regions(struct damon_ctx *ctx,
-				     struct damon_target *t)
+static void __damon_va_init_regions(struct damon_target *t)
 {
-	struct damon_target *ti;
 	struct damon_addr_range regions[3];
-	int tidx = 0;
 
-	if (damon_va_three_regions(t, regions)) {
-		damon_for_each_target(ti, ctx) {
-			if (ti == t)
-				break;
-			tidx++;
-		}
-		pr_debug("Failed to get three regions of %dth target\n", tidx);
+	if (damon_va_three_regions(t, regions))
 		return;
-	}
 
 	damon_set_regions(t, regions, 3, DAMON_MIN_REGION_SZ);
 }
@@ -217,7 +207,7 @@ static void damon_va_init(struct damon_ctx *ctx)
 	damon_for_each_target(t, ctx) {
 		/* the user may set the target regions as they want */
 		if (!damon_nr_regions(t))
-			__damon_va_init_regions(ctx, t);
+			__damon_va_init_regions(t);
 	}
 }
 
-- 
2.47.3

