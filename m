Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 72190F30283
	for <linux-mm@archiver.kernel.org>; Sun, 15 Mar 2026 21:00:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 522726B00D7; Sun, 15 Mar 2026 17:00:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 150336B00DB; Sun, 15 Mar 2026 17:00:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E0E686B00D6; Sun, 15 Mar 2026 17:00:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 96A196B00D8
	for <linux-mm@kvack.org>; Sun, 15 Mar 2026 17:00:28 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 6030B1A0D30
	for <linux-mm@kvack.org>; Sun, 15 Mar 2026 21:00:28 +0000 (UTC)
X-FDA: 84549515736.14.8EC37CB
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id A9FE140015
	for <linux-mm@kvack.org>; Sun, 15 Mar 2026 21:00:26 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=mv9sn8r3;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773608426;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vJistnFWnDMgPen+vzENlGukE6NrPtXcqWX8OD67mjA=;
	b=OsIjEsqao1vMoqik4IQif7qdnw5pQaa5OVyMlE/9x+jmQIRPAUouGypp7IitVb7toLddba
	8HgXmeNHNbkamJmM1jweIpUXKKVuKaT3zrH5A9SFW+ds3cXFGl+C7W7s6DvngFtrSq0y0L
	iPVEpaxpuNuFB+oqhEu0HtRufsbIpzg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773608426; a=rsa-sha256;
	cv=none;
	b=MBjFJMCXeRU+aAL5ONsJMg3nKaJ4XLDZ1siLZD3iUtwL8Rwp38BpW4pHqXn+bzTOHd83Na
	D4+v5PdL+QWcGEXnSDfXxqsRvMflGx9lpzAQvXtJCoP1HrD7UCMCMEAzl+8rBn2BNUOuhF
	aHJlFWGpaPp1GJ8XOivc3RICVi1IxDI=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=mv9sn8r3;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id E29B44470A;
	Sun, 15 Mar 2026 21:00:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B2CEC2BC9E;
	Sun, 15 Mar 2026 21:00:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773608424;
	bh=K+t0IBDIG7HXVVaXmRTS++wFYmoNTkKzAJmGYrkNPTI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mv9sn8r3K6vky9qU7ER4NsTzi7rEvDXGZEa6QWEd4OKBB1TTtjpYCawkrwKSAuv8/
	 p61zmi1755sjHSRP8epCQfX4zq/4TWiLEdK3ufEZrAyA+Ktr8HCquMI0ia3AIApZd0
	 mqZ/42zV0zSCVAIh9K3NrBn6DsW91ZNzkKhmiVSMYVFXp2KTZvtLgvl/pCrnrPVGRI
	 7o2OuvjsXG1x9s0TJyvlosUrJMn/+6Bx40388X+JQvmP2jkRcvAwLTOyRwU/GDP6w7
	 SyeB8jGkZdtCIUQCNAnuVwoo6/bRIIZo97YZU6UFESzzBfIkWenOe5Qa6Yccz8JUiz
	 rW7O7QFJSZ6TQ==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Brendan Higgins <brendan.higgins@linux.dev>,
	David Gow <davidgow@google.com>,
	damon@lists.linux.dev,
	kunit-dev@googlegroups.com,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH 06/10] mm/damon/tests/core-kunit: test pause commitment
Date: Sun, 15 Mar 2026 14:00:05 -0700
Message-ID: <20260315210012.94846-7-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260315210012.94846-1-sj@kernel.org>
References: <20260315210012.94846-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: A9FE140015
X-Stat-Signature: fw7e996ifhbkuxip6bqozru36ixorpwh
X-Rspam-User: 
X-HE-Tag: 1773608426-612921
X-HE-Meta: U2FsdGVkX1/m57nTSYq/0bNEZIrWYlto3w+gGx1lS7VFi6PoRnxbjrR0s2rGXJgRPSSimN3VbCYAgvDus5Op5ADBVwD3vNvPxs8htskfxemcXg9q/iJaQBH1AsoWGGvGqVwzXoEOuXuwTklfMBTBbQIGK7sy4F19FVzLTbM6Q8PAyj1OGc1bfNpUm8IvIDtb0zapeEE/BE1CPrAecyTTOuKLyufG845DzuaUJHWed1cqrg1btoAItO+x/OJzTOBZ9d0+50reNPT8zqP/DRjjsBM3tKvsZ/5giGtDiZpDZMCj48bBZbT89Mf7pNWjdKTx2it0PwLq5r/oczCbm4McmufmisUnSRsvc8GZKBEOaf4Xlal6mRd0LrJpSHhtRvxEYFhg/8J0Wp2omWay1izaf7ioWf/IfCVlYs9R1NgW6FZNNTDBW0inbijBnjkrJyRVGU8GDJDMgO2uZnQro0G6z2BnId15oDfV7+SVCCMhUDtAk14wuSKQ/QwpAJgrpVvc7DISj14lrnLVCE5ODs7xiQbW1fLL9y8qHwxNamoj8tdB4hHOZcpOl96YyjSXgPbNjR6/L1AKpsjvrVJYLfQJL8UYflhGztK246OdeJ/xym31PCCUp5Wb4qMcKY5JctFDVfMD3yq15J766wbS50qYKIiwHpEvxxFsntO4sgSZzAYtENGM+0w8XAXsvPmimj2a/ProBziwal8x63gGzY9SmDivNOlozMOj6u2pCvMoekEzDqyIIc3IkSshFHw7wGra1YU/T/2SwJqqeIuYtY0HfssRZuM+xV5c5AmV9ayhPa/LnF1CI5qBGA8JNrkRII+GnoZbKqNEEVDvuGHbpAr7G5yy91nBTI40/RauB3urhY6mnNCUat2kcgfxOYGhPOBLPt2XWKflERTT2y4/EslGnRyH1btHNvzFnW06dxiJqj9osgB+2OHYlw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add a kunit test for commitment of damon_ctx->pause parameter that can
be done using damon_commit_ctx().

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 mm/damon/tests/core-kunit.h | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/mm/damon/tests/core-kunit.h b/mm/damon/tests/core-kunit.h
index 9e5904c2beeb2..0030f682b23b7 100644
--- a/mm/damon/tests/core-kunit.h
+++ b/mm/damon/tests/core-kunit.h
@@ -1077,6 +1077,10 @@ static void damon_test_commit_ctx(struct kunit *test)
 	KUNIT_EXPECT_EQ(test, damon_commit_ctx(dst, src), 0);
 	src->min_region_sz = 4095;
 	KUNIT_EXPECT_EQ(test, damon_commit_ctx(dst, src), -EINVAL);
+	src->min_region_sz = 4096;
+	src->pause = true;
+	KUNIT_EXPECT_EQ(test, damon_commit_ctx(dst, src), 0);
+	KUNIT_EXPECT_TRUE(test, dst->pause);
 	damon_destroy_ctx(src);
 	damon_destroy_ctx(dst);
 }
-- 
2.47.3

