Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F35A5C624D6
	for <linux-mm@archiver.kernel.org>; Thu,  3 Sep 2026 01:03:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C198F6B00C7; Wed,  2 Sep 2026 21:03:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B7BB16B00CF; Wed,  2 Sep 2026 21:03:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9A76A6B00C7; Wed,  2 Sep 2026 21:03:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 755A06B00C8
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 21:03:45 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id F0A22403DF
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 01:03:44 +0000 (UTC)
X-FDA: 85170653568.22.7137DB0
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf23.hostedemail.com (Postfix) with ESMTP id 58A8914000B
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 01:03:43 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JxkebG5+;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788397423;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IGhJqVBSrLsY1DzUKQNwEOVO0mpPemu5G2qZNzm4L3A=;
	b=KtAe7Fwdk2+QkJiMpN40eK0Mg+qGGoIzIvd3Ys6TTNn+EMi70wsVdSeKzltPnjIqeSqhMv
	NbtCnLn4z1zWLQGz91KXoQgrQ3p7asjBPQQDcSgvcYA4FpINuNPFhY9a6abcX08+qFdagC
	nZdU/CUL8q/vjowq2v3cejnVRAC3KOU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788397423;
	b=uRpxeLTWZAQYxzpX583uWZrXYa2zQkoSgc6Riov/wzMCaa1IXnKsgfX8C+jnl8LQJYgpx6
	5eiVveNvbTXBWTn8bJ2Dns4hkKdi1Awuv8NQZ3L2+wcqvg+yyvvgJc4hRiBqgrClfjZu9T
	I5mSgYD2FJny+4o7+JzbON5Vc53/rD8=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JxkebG5+;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id DED2C600D4;
	Thu,  3 Sep 2026 01:03:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6EB0C1F00A3E;
	Thu,  3 Sep 2026 01:03:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788397422;
	bh=IGhJqVBSrLsY1DzUKQNwEOVO0mpPemu5G2qZNzm4L3A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JxkebG5+E8aGwnRfz/OniYrZag3n4/XPkJqX5Tm87e4rNVmo6wdRr90sWwcjiQVBN
	 9Zq4LsUbD6kBbBE0PPZbanuKErFKPRY7yaqR8fwJkwlmqcLccHiPSpvtphAAjFpHn6
	 h0RJYVerE0G4KsesZiqoRlgb+QTaoU2r8xHAoE/NPmKpBrkz2BVx8wzcWz1mU55FUV
	 5VTEewVF9LnBXMXV6cV19OI/+B3qPjyCGD3syTkbYprtTZQLOptL4ULZVFIJVG7vql
	 lUlllxycWVippoZ+v0yTHSX689mOWA1MSTm/hT0u8RUFTFWbUNE1agPI5DQTAK9djK
	 KJVd6fB6wp9tw==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SJ Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 1/4] mm/damon/core: handle NULL ctx parameter in damon_call()
Date: Wed,  2 Sep 2026 18:03:30 -0700
Message-ID: <20260903010334.93622-2-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260903010334.93622-1-sj@kernel.org>
References: <20260903010334.93622-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 58A8914000B
X-Stat-Signature: jycnwg5r1huixogma3fr9p61idqqo4zw
X-Rspam-User: 
X-HE-Tag: 1788397423-460190
X-HE-Meta: U2FsdGVkX18Gle/1OzNtCzXdy/INjW95ToqWzet/Ghr8HbhJBhyLJte93vuiKVsyEt9m6WcL5f5EH4dzc1PhKBwfp6mElTZs33xYmtIeF7N8Ur8jjQ49NLHr4ML2Y9SWEqhFTPykLoi9rdmx+MdfA1EYh4O6plP92qvzY9NCjrFQvG2YQ3gxmIsc40/EOyMz3yYNf75B8ciNbcNJ2sMgIfFZxnrtYUP10B50rIlNS6NzzDRlHMDM8rKBmxoAYaxwDm2exceogyOmSQYzUmkp4usM0yJWPeXHiyJplH/FBBTk/Q3OKbTGO44TSwKbZ0osyRxBztJrhrNT3RgA3ry3g2wk3xnaRk+8yPOSFe7HEdNCQSb88WtDXXb+MwoXweS3youz/4czPqpa3n0BGUYeJnz73R7Kiikt5TLOSYiaWhDZdq9krTDFlt6LlmP7q8zIgjad6iLLRaM0ITd0e/aRgYRrvAh4utkYR9w8GS+4BE36tEwMsGCsPIdFE5xQVLCzruR+y9gYsuVdDQpfs0D1RRpAG83XafHTuU/d0Zs5DzTvHRFBFxKQwLmMNbxK5vsQrPOHY82f01stL/O5XGQXjXIBpONZVeUvgE+qIkGJl5BAcauhfY0hDhL0LGr51/7PXIG590WLy/Z3gcOpURC4HIdIAh353dx4vzW9RrRHWHrNHPC/rHHxQgg3sd8NlnsJgLrAlc00uNtVOOljsHd+QudU2rNlzcLaLbAt1z2XzEk1AoGC4A9UrsHmWZYN2XFFbPbJM7qxwGPghXG5dZrV/1N6l/ip/ZnS1uSsRbgplOHA7Koze2Hk/jCrvrzuN1bvT0Bx3VE3yyyPHrmo9NeJA53OFZ3TysPwjvu6Cy8265HbIWPFNeJs9PK0+OWDyKwqp/d+2bZCe4UACQVre6leRbfQayEuPo+NiQ/NDQpkcccxghCbQwJKVoQsZ4trA0In3uSKHKRsO0ICZM1s9Jl
 4G0BtdNP
 57qSy6L+4Gjg/DsS3yhfA9H4sNzEQ5waqDuU7V90dM1H6Wnijfy4gWwYAR0huXLoduZaA2wfoKMaQVmk7chU9FF7YYmp2UEvRcYArN3UMtwFGJ+YDCnUutfan6m+8CM+QvyO9sChl+lkIkiLzs+YZaSxuIlVFel4+DY2DxFu3LF4kdKP/mZL6LRZQkqlwVfQKPpyp2+HgzMeiucCkIGzJEmET96A+G9CKVZmnlrChESk4sGrL1Mv3TQScaJxAOWRLEZ5rmZn73t9VyO+HvQ2MH/uyPpa5dDi+trEPIWvn148/YGs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When NULL damon_ctx pointer parameter is passed, damon_call() could do
NULL dereference.  The caller is responsible to avoid that.  It is easy
to forget, and there are many damon_call() callers.  Meanwhile,
damon_call() is never meant to be performance critical.  It uses mutex
and completion.  Add the NULL pointer check inside damon_call() so that
callers can pass the parameter without NULL checks.

Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/core.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index 85d29c76c00cf..03407cf7f9646 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -2206,6 +2206,8 @@ int damon_kdamond_pid(struct damon_ctx *ctx)
  */
 int damon_call(struct damon_ctx *ctx, struct damon_call_control *control)
 {
+	if (!ctx)
+		return -EINVAL;
 	if (!control->repeat)
 		init_completion(&control->completion);
 	control->canceled = false;
-- 
2.47.3

