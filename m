Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9579C606A51B
	for <linux-mm@archiver.kernel.org>; Fri, 20 Nov 2026 06:08:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=odTTA3E9
Received: by kanga.kvack.org (Postfix)
	id 64CA56B05B5; Fri, 20 Nov 2026 01:07:53 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 625AD6B05B6; Fri, 20 Nov 2026 01:07:53 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 539A46B05B8; Fri, 20 Nov 2026 01:07:53 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1DD106B05B5
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 01:07:53 -0500 (EST)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id EAB1D80DAB
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 06:07:51 +0000 (UTC)
X-FDA: 85454466342.23.AD62654
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf07.hostedemail.com (Postfix) with ESMTP id 576C040004
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 06:07:50 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=odTTA3E9;
	spf=pass (imf07.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795154870;
	b=BFcB2BfkvQFu9M23UwO3DmzDFa97iexJZhdofAAvW4A+/eXR/3L18TmiNbsy7Rduzu3TKE
	eS94VXz8Chxzv/WEcD5uuscp54r9KHUWdU0dbc4OrUjg/2pWle9XH/57BGSK4I1i1pZmi1
	tEgpJ/AGlV3lm0Xcw0IF6zk9TpU/cdo=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795154870;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sgy2HIqRDs7m+gqismXK/OQPULwkzU1byqrsLzKFNC8=;
	b=QhBo4Rk9JMx72InKZTs6pZd5JklSBDMD5FDYNPXFIzmKU6rJGriC1C+fAmDsODeE955cJy
	hJqFJMptHFfqWVBpKLrRU5pnc4A0gjYbBIUUGaSjxEY4vJkNqilbc1lDJ7nDyRBx7HWOct
	UR0DlW54cEN6C8XBrOoBKOLCAeCuydk=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=odTTA3E9;
	spf=pass (imf07.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id D552560D2A;
	Fri, 20 Nov 2026 06:07:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6CC2C1F000C4;
	Fri, 20 Nov 2026 06:07:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795154869;
	bh=sgy2HIqRDs7m+gqismXK/OQPULwkzU1byqrsLzKFNC8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=odTTA3E9ruj1lmSPYq58HBpyJV42EJK0m7a/spYdlFG9ckTqxi1k84yFRQWnDRwUi
	 Thtqg3tkVjHbZhmoDbBSH4dJ2E9qLnDBqvoPixW1O11sfHQ0kEFiP3y7tYjysIejl6
	 qmSyDPVhsjbUSbs5hlW3OrRhESAhoM3ft4Z+jISMHvKrTiad8u9BYaNXE5MQ6wIheN
	 +n5rvaEIJT0LwI0uNYNUFYr1YKLsCgVdJkSBIwLDSZeeqVA2I5JcuHtrLQjqb7aXwY
	 IIttQX8Dz2GlGaGqvAprO+Ss8qaSiUIiFQw3zKWMZVTO3uOHWbbkHmpzO5GwUx+2Tw
	 wdf04U7Cx1YJA==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org
Subject: [RFC PATCH 1/4] mm/damon/reclaim: enable monitoring intervals auto-tune by default
Date: Thu, 19 Nov 2026 22:07:35 -0800
Message-ID: <20261120060741.92121-2-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261120060741.92121-1-sj@kernel.org>
References: <20261120060741.92121-1-sj@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 576C040004
X-Rspam-User:
X-Stat-Signature: 3zxmrnnyxi1dp87kus6eta3xumu1y74t
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795154870-34277
X-HE-Meta: U2FsdGVkX19JHKqNb0F1pGjXUqp0j3MpNjV8s/xhOnBWYm/QffSvq/keE1XI2+qaiPhvCYngbT1/0/ZCb/f53/+YPJ3lpD00XRJA9jy1FEEkU1ZfPX+pL6TkQRrUbqsftLe7Zjn4ANDJ8RWQrld7TpG0ftXk/W110YpflJnbo6NiPqijpUIANFqyFCxO9cxHD3FLkZlJ4xGm7tM10TFX5W4YbHfjpbzfjZ1uHT0SXC37qqClaSqhB8xDsarY8ZsCalNrweWdfx5fwZZWnO/V7oYBET9hkkoDQoatrIwtFIm8JzN4cKD/6HZfCkagfzJ3iHntORIVhlrCPMSQopjeQWjuVHR8E0/9nhAq+Dv+NLQuJNv2jDC/V9zyzlZoEPeDvv+S6XaOeoaL2P6xKRnJOclF5C7gm3M6e1t6NveVmztYgU1SJIWk196/iwS4ugCGTlZqMQnoYpPSdn91iOOZ27uaKxls5YEoZBxMg+7sxdKOd9/6Qu03qpYB011AYM7ST9FtFDiW4N+sTUy+jKD8Nw9fvHdJkf/hAdoJNhl2bnpu5oHYFXsGd3BXc8LlVwi7dQ+PjJ1yb7Wud3gVFVPEdkySu9KrenmnfomkbroQBY/48DuuL3ngUPyPc80lWWYhqHGien8nqJZZVSN5VSuaXg6DpFmxLTs3ZFbQM8QiY7bcHv73BHH+DWFn1KmOoYu+fFrPMO6z0tAg0i8j42lVjq/XgMFA2Q1xIm2kjyNk5qvJ3pJpHuIzbCdkNd9jF0WdGSEEXb419tJK0YelWYhkjp0kD9mW6oYPpeQ5bEHikT8XzY+l4gTXp2y6UsmLTdl4p/KQI5xxi4rOiLzRTzPoZTIHVgU+JCcgVd3BYav3vPvlU7ph1xVzQooIezERia88tvceYbcYqMrzTMl/cFjMtgNdmaHprYvHelw+Ka/PAcZwWHnD0NQKMbsplI5e/nFgCMrVp6oxYQGnVUQUsdX
 IZDEzyev
 zGhG5wWwZwM3OO5wvgABDK52kEheuMl9gaNfr0nZKRsoGpcsuGerHBN8JJ4fX9a+44mjnwSf5qPsF1/ymjnieRzrXmF3VQfuQjUd4RHvQ6H0TvH3OwpS97GH4RGw0DghfeK6IxC7Q0i1mYaeMkRYnwgvWrMWxYxjSP/1vtamIYThkuw89Amivn9Szdjnnhchkcr1mtLsWY4+tlAzSJjT7PfbkPQCQLjv3WRSINbAMZrJlR8GCjUYiwEm3TwgQsQKUjeebPe0yoM50q5hdsOwJ/eqUojlhJy3pCX+cQiUDRRV8RjlO1N1J0n3/JrunIqpZN1Vz1ZDwYou8d4tUncpxJmdkqQkULeWYsXSMef7fPCRcBuUEfTAHoI3zMjXZNIGGxv9MllyatQx3+KswFy/kfG/a+qyc+tgwwcSDQmD0wFXzCmMv+mr7x/c6LPumrROG0N0oYFmY7aRYo4s=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

DAMON_RECLAIM provides monitoring intervals auto-tuning feature.  It is
turned off by default, though.  It is expected to be only better than
the default values of static intervals in real use cases.  Enable the
auto-tuning.

Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/reclaim.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/damon/reclaim.c b/mm/damon/reclaim.c
index a84cea070ec76..2241b3e9145ef 100644
--- a/mm/damon/reclaim.c
+++ b/mm/damon/reclaim.c
@@ -98,9 +98,9 @@ module_param(quota_autotune_feedback, ulong, 0600);
  * sampling intervals 5 milliseconds in minimum, and 10 seconds in maximum.
  * Setting this to ``N`` disables the auto-tuning.
  *
- * Disabled by default.
+ * Enabled by default.
  */
-static bool autotune_monitoring_intervals __read_mostly;
+static bool autotune_monitoring_intervals __read_mostly = true;
 module_param(autotune_monitoring_intervals, bool, 0600);
 
 static struct damos_watermarks damon_reclaim_wmarks = {
-- 
2.47.3

