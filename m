Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8DCC7CCD195
	for <linux-mm@archiver.kernel.org>; Fri, 17 Oct 2025 21:27:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B78B48E0029; Fri, 17 Oct 2025 17:27:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AAA8A8E0006; Fri, 17 Oct 2025 17:27:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 972028E001F; Fri, 17 Oct 2025 17:27:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 11A048E0006
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 17:27:17 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id B993385D3B
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 21:27:16 +0000 (UTC)
X-FDA: 84008892072.06.D77DEF0
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf07.hostedemail.com (Postfix) with ESMTP id 3318040004
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 21:27:15 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=tFC9b+qE;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760736435;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MgHnqKPUjHdosBqykwchH49hPeBvcRQNEmJEbImkO08=;
	b=VqFG0X/ayzgIQ4gbZBH+01pcGW6H+w2Qz2KPAzPZluKxHPVUzIwEVkojKCn2I68Uk4EAIT
	ZtwKDi2Ra6eJL7Lt73n0Oj3nu0oR864yL1Coj1/lNRZ+9eQ6yEmmkM2qbBitkyIxUUq8so
	0xmhH8OgwFug64nDRuVQ8xt3/aBpfA0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760736435; a=rsa-sha256;
	cv=none;
	b=HXwvn/9a85DaisE3i7pk6fAM1ZwYaKS3jjQEz1XVV4VR5GSB0MaK6kT8OkRRtjW3edf1oQ
	x5pGduoifVazZacbj4cCOTM+RDH7HruuQdOaPn8w6BYTGNK+xgOx/K9B44PtmbsEsnn171
	AQSpGTF6NSF04NFBn9/fTzo4YZSGfwE=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=tFC9b+qE;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 931F8645C0;
	Fri, 17 Oct 2025 21:27:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29999C4AF09;
	Fri, 17 Oct 2025 21:27:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760736434;
	bh=aLHLz1HJxT2tP86bchmItKLfg1FQG0fbZ+VFjhe7w9w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tFC9b+qEhqdnWztJkXarAi+NxYFURzOYI1PWHkcRwhVFz7e+OHpN+oCboovEo0yNL
	 mq0k50l7jGzMjUdGkd9ynLOvO7JARmNL+m+kUEa/F+hJ6vPBgfwSHQOAaMekIGTpkW
	 oUkhb07u8Cb4rVqpvKdKKvg9xiuiodLHfBKDNVzHc5pRKJn6At/gFLzKq7ekOFyLwG
	 Z/ahQKFQi2QEwn80N/mtbN1vjSXCPptw7eIWuYK6ZD3eMXTczV65m+KNCUoIbckvTM
	 lwwM50AsLb8azsnzSMbgF0FzemJOAv5/rz05smuuUDVrAyP+n9XFSXaL8Gh4hBkRKr
	 t5JYwcwezfXfA==
From: SeongJae Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SeongJae Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 01/10] mm/damon: document damos_quota_goal->nid use case
Date: Fri, 17 Oct 2025 14:26:53 -0700
Message-ID: <20251017212706.183502-2-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251017212706.183502-1-sj@kernel.org>
References: <20251017212706.183502-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 3318040004
X-Rspamd-Server: rspam02
X-Stat-Signature: 8uqse7mq4q6obz8tmb6no9q4o5s3ueg9
X-HE-Tag: 1760736435-120997
X-HE-Meta: U2FsdGVkX18telLOcoAZRzliVGyPUwARykOhUeLcRuTJXESx0bY/4p1c+x7u2E+Cph08ep+lJ98IYeuOhendrodXPW+lzUS56rXZDRY5zMJJZVDUy43ybya8ayYtVWrfEbUXJ9rBqESgEWZPWa35tB007hZMqH1wFP82Ki6zgUn1yMjE4NRNVT2YvhuoAU5bgJHjLFYEvxJcC2Cw2VWy+pjsgKLglyfANOEsv9fisOXJIzBiE1S0DU56S8bdWzAuJAQUQXBFV5lMxsZpGmmEURfxp8QOx4fyFjqC4HZ20FvvKe01+bjE7BpAKzbwNjonMhCoA5tzRtO/ZwRFnLEvPjV74dxsSswYYWIrM1IyfydUe2w9CUdg+Z+jY0/iLktV6to8/z0xSWzkcfbnf8M7d0kqsCzNNxqrqTQd4CrYM7PfDmrkiA4NyF62uJve/bxyVNF58LjZ2hF1Lqv7vHTFncwSfsVNzFlfeJfgJFPtyL6YbT5wzaUrSCvj8S8ajffwSQ2uHtgl6YM4FIIh4taxmoEnjyj0avrlxB0RrJ7G2maKBYm16BR+5xtxBeB+Kg0xoOECIdRtaRgINd6Pn4S5iiLXQ5Cg9aePmekkKm1O76wJ1KNQlYzSRJFkz9gW3juTkyu+4Gm7wxejHCyqGxGfCL5UesEinHE+h1P0lwbteW6eJTNAFFL0vAaxNa2M7shtO1qLhYFpgWePU+oEukBI0SpAkdAa4aEx5pZXr4EQO4xKJ8hlsb2FGv/QHbcTWmqmlFjvOKLsWSvSlcIE/ml/qnNG5CBYI6g46LmjQYVsLOs21ts0ErfCUIV1LNmpEBZumHGBamcTv13OHjORZCGTCLh7BO3rnk6s5xZCR0/zooE5D7bcXDk36TU77aGnhk/1yNiiMIG3h2tLqVaWG5KpBSkwNx5+ttFi9k2R61vsmLYQ8ZNW8RjAAA1ml+JVbmTjdBkY5NcDm0fg0dT+8rU
 UaIFPN3j
 iOYbz5A1vADZ3LOjY21niCqJroZ0CZ5aeWf86RRthXUz5r/kiSfWvBZ+OKrmhM4iOup4S1nQiy7pCT7ng/6ft3vyLRa9FJiDQ3FGe6MZ1nPasteuX0LDRrGEkWC/6OHLIkcgjjLo5gHOr5Lp0GATfhBt73+HS61lyKbhcN/hXftZbko5KohX/G/2Pohn2/KiFiFf5BcCDuedDWhkpkdNXswXtWkvm79QUGwkLUvUkzPU+7kP3l+m2hyDTSDjS0cKH6TQ2sAHrmZLczgypvy16/x2KSnrRmTUfNoLmCqGTxnTPDqog11/wC0myXWPnPw08rWEig8t3uFA/Kng=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

damos_quota_goal kerneldoc comment is not explaining when @metric is
used.  Update the comment for that.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 include/linux/damon.h | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/include/linux/damon.h b/include/linux/damon.h
index 1ce75a20febf..bb92c5f396cf 100644
--- a/include/linux/damon.h
+++ b/include/linux/damon.h
@@ -176,6 +176,9 @@ enum damos_quota_goal_metric {
  * If @metric is DAMOS_QUOTA_USER_INPUT, @current_value should be manually
  * entered by the user, probably inside the kdamond callbacks.  Otherwise,
  * DAMON sets @current_value with self-measured value of @metric.
+ *
+ * If @metric is DAMOS_QUOTA_NODE_MEM_{USED,FREE}_BP, @nid represents the node
+ * id of the target node to account the used/free memory.
  */
 struct damos_quota_goal {
 	enum damos_quota_goal_metric metric;
-- 
2.47.3

