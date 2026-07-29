Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7840BC54F51
	for <linux-mm@archiver.kernel.org>; Wed, 29 Jul 2026 14:03:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6A3706B00BC; Wed, 29 Jul 2026 10:03:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 605BC6B00C1; Wed, 29 Jul 2026 10:03:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 457596B00BE; Wed, 29 Jul 2026 10:03:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 1615A6B00BF
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 10:03:07 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 9FFC9406C2
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 14:03:06 +0000 (UTC)
X-FDA: 85041980772.16.F96E345
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf23.hostedemail.com (Postfix) with ESMTP id 08EBB140012
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 14:03:04 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UDou7hQm;
	spf=pass (imf23.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785333785;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OrmqzezRZHpLkQbXvsx8kdT8w9xKKaZj6lZcjNbOnP4=;
	b=j+aO6S4L8K8YoFSQwmccgCnxMrHGOjRDvuPbOm/tj6KPaTxl+f76z+wURf1rRrpm07grh4
	4nxSTJ30sFoE7x0J+DKVT18HoMG9T2gmt5qkWpKrQIw3G0sSWfHd3z9vzca/87PRNW8OjJ
	D/4pdzHto4FGub4VsiODRHtXxOvHohI=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785333785;
	b=gmKClQFdWY7FUFFGR5Hp4s0I6WAFdTjTk4ARwli08I9g7zyQd9DNLZa0xLvBWeWuKcwhwF
	+we3+d0AB9x5mqGHfoEHtFDZTV1xtjzsXg0Ykz/v1M8hQeMYpf1FDHZh+WGpsb0bYuwZxP
	UfmkVQ4xBydfllH7kHA3gTDVoEqPFcc=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UDou7hQm;
	spf=pass (imf23.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 85D06600B1;
	Wed, 29 Jul 2026 14:03:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11DF91F00AC4;
	Wed, 29 Jul 2026 14:03:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785333784;
	bh=OrmqzezRZHpLkQbXvsx8kdT8w9xKKaZj6lZcjNbOnP4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UDou7hQm8vW0dPRY6gFTdF1SgjemoxQagg77mAPX+a4NY9m3P7Kw6WrAOG/8aqN0x
	 jEYqHYi1MsuHDf1rgYgQ44SrTRCq/hJmUp/UK01jxnlqA6q+jg4yCSlJgSMS8gkNh0
	 doi0Rxcagff5hG8uv63lsr6URjmvU+G7Dbldvg62YBWpjTD/2vKYHrutZw0EfuO3/J
	 UNx+rfb6wcfHU1XDgeFcBowbcQvSpB4srourGDDwihw9lpg5I3pjlHS8Ul5YpIlxQh
	 Bxliw8lw5wzuH6gYPTMB/abkUguG4ejKOLHvQCGVxnU+6AZf8XR3qfgY+22VstepU8
	 INsw7p4ffNUVQ==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v1.2 03/12] mm/damon/vaddr: remove a debug message
Date: Wed, 29 Jul 2026 07:02:43 -0700
Message-ID: <20260729140253.87753-4-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260729140253.87753-1-sj@kernel.org>
References: <20260729140253.87753-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 08EBB140012
X-Stat-Signature: 3pqizpwe3rtqojkfaperzt6w75pyzyj3
X-Rspam-User: 
X-HE-Tag: 1785333784-379896
X-HE-Meta: U2FsdGVkX1+FznaKnfyy4Rt7AQNTeVykpFdnOFWAiHrFY5s/uJW10LaTotvpEJt7qUwUzDOxaX9bFE4nc+3iisUhzGpOak5WsYawzCeWlWj99krtjHXwyjpHoyT8v5ts4EqEtYLOFCwDywL7sg2WjtgpIMEeeBFmuGKT2OtTeuLe5g1jovqkW9a01NNk0Hsyos5EQJuZOdY59pHIGY0nGSVFQwBC6Ok+iZATjNMqEmQus9O1wF8m7EyDvb4zK93yrFHyDEsi76aqdMin+7auhgJIit4uzR50bLjavnp9+jzu/lpt6LjgeM/GVn+iduVGcV5lgh0I7xVVFvxw6jtKGdCXvAauSmIZZpldvTbvo4vy0cbWWC0Kzw1xASMOMjGGXywJxB+Fg5s1PRjGPt1ViWTcD9Tnv31EU2W5lpS1jBFdl3RGdxxbdbOb3SfiWcQv7LCCmGg3Lrwpbd9xUlAWnt0JkOAwT7cwjSaMUySpled98zJR+/7+Qj+hA2miuBr/GsSxEE1F6aL6jxoqoV4OpvWpjlz4Y5+cxbSu4/iq9TJFrWAn+QVsk1+rc/WsFzy7+8vOE7YIYKctZLuVjMfJRzxV5mox9usTNrpUF68Xochf1YikavRAj6y+0Z73aCm7sLdL3LxbysRF1UN2fBB3dwDog6aq+t1lCk3TDubFH0Odsx8eLQLMZG70+JNnjaYcK+wakOH3v1jIQR9Q/S2/hbf8Tpc5eBm8o8DFTQiicfXKvNWbh+bxlWpVEAVsA+UN6AmGSTyvW7ywLffbPVdJbHMNTSOQFFeo9qSoFvlkMMIZMajNCLyVAX1w9qr7N4kWWsTgWUhtcXWM6Xt59M1YjqCwUetWTP5/DB5Rn/b6Vpw6in0cWkcMgGawn0dwZaS4+kb+Ml3nOE6/sqdTmTrjVkXmWb4PGH09z5FyUQliwZmXOKx+FBSSJ1Xx0T9W439ZY4xnxVPogBwWNP7Srtw
 sPWXmYfy
 vWl52/Qv4kLyhfoZO11v3BqvvV2X8RSDpG5lehMRqbJmACKEouQzBd+2SUaUtr8gfqb3ISpwSvuZzL9vI3t0tiJ1fRQHX3ya3gsUaiyk+9umUEsfllBKSw0J9g51qRjGT2pAa6unrOofjW/m7MKCcELVrjZD/df1+2rMq10DzsvH7p96AqjE21C2sMG2sasRSoISee+jqm55Go/BSWq0/+AJa9woyyVPeH4BZ6zZkT12ScN8=
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
index 0648400b2d65b..1b220f6f2632b 100644
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

