Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4370EC43458
	for <linux-mm@archiver.kernel.org>; Fri, 10 Jul 2026 00:24:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C166D6B00A2; Thu,  9 Jul 2026 20:24:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B9FF36B00A4; Thu,  9 Jul 2026 20:24:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A67D56B00A5; Thu,  9 Jul 2026 20:24:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 76AD86B00A4
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 20:24:06 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id CDFC3C1ABB
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 00:24:05 +0000 (UTC)
X-FDA: 84970969650.13.C8500B2
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf12.hostedemail.com (Postfix) with ESMTP id 46AE940008
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 00:24:04 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=MkYSa4Iy;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783643044;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tjxwjzI1jDT7bs2h2B+hgVQdgy3iqBX4IuJ/qCYlBQc=;
	b=eTgjAV1nR1/NJTUj7QespdEI8ZG6qCSPFPslqfhaQYMf5QD9qWwQf/He9aO9EhE+Xj/pEz
	wQp4g9jsfUnP18adiV0AS6q2VPUYS4cBH5eCdIT/wvoIHzI1EDRf2e/ha4bn8SXOnadlVF
	q7fDhHtXkgl32soyhSw0KejqReaiX88=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=MkYSa4Iy;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783643044;
	b=P3AYR3GnGjO25erNqtHH4hKQOmPyiD05ITG+akLB272S8YxM+BXJmLbUhtRiPEAA07T/OF
	oif/jycJeRVS0gNq9wojhETmg+CNIWgnk0DLiArnUzosyK8jhd7k51isDEbFvn3sSEhWfc
	wPWEwSf4kElk93lhUdHne4w5r2g89kE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id E5E886182F;
	Fri, 10 Jul 2026 00:24:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7AD931F00A3E;
	Fri, 10 Jul 2026 00:24:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783643043;
	bh=tjxwjzI1jDT7bs2h2B+hgVQdgy3iqBX4IuJ/qCYlBQc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MkYSa4Iyv4ugv/7PS5lTOfs0Zml+OVskOYO6D0FbHs9Qd81yU/33+OMYQuoVr46tn
	 tU+aEFzflx7+P8sZObAD1SCvXnZvVVsfDQwNeKkEyBL8f7ACFGRTrgGL7v61rEw0/g
	 yNlgccdptqOy8xKiwCamCjdxa9wA2nrfWuVsoLk1jdFxg/MqhpvFSzTaI8FmR9pDT9
	 0jSJT0VnqXm/HCGbs6YCeCXTS5oIfKuJ8NiPSiJB4QV9I6TM52kIAQTJRybJ8CpcD3
	 2hZoL3dyRS1eKQdUtuNCvVOx2QL2H10mzcaGFiIjAN0eZeWVE+WsJGzunbTxDCi2Gz
	 JD9SkRCrUztMw==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v1.3 15/19] mm/damon/core: implement damon_has_probe_weight()
Date: Thu,  9 Jul 2026 17:23:41 -0700
Message-ID: <20260710002349.111414-16-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260710002349.111414-1-sj@kernel.org>
References: <20260710002349.111414-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 7enhy7by6dtc34rimatbwbk4ixwnut7w
X-Rspamd-Queue-Id: 46AE940008
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-HE-Tag: 1783643044-558662
X-HE-Meta: U2FsdGVkX18paqxTWjWg0Se1YD11ESW6iGMGKffaC1yfbNUdStRr5aKjNIhWQW14eTJ9NqYdO489rwWy2cJ60tOsCFjqglngvExfGOXBkSnurrb8I7BWRra+3m+G2mfro3LnGGdXtHl6NF6UXZ8o4aNiO/9Bozf2cuTWeiuX0XCSEiN3+U+hALvx16HsehQhQb/f1LwvwJ/kQLZ09V53ACjO7Bxc6sjafydY9SNTXQw/5oUXWYntvLZzPX9oZWKI/RiHeHSEM8vj3WEv9FEK3bp37ysqlLbhmQq1ILHVLxnejvb7D9hm3qC6hehfcBS4ACLXpd9+PEPvkNNg+qoOWQpbguxG1EUTbaFFUTP4j2CcQ19ItySawvOvYLkaHc0w2BIQ9HC9/K1+vwHqs6pbOvRLhOzWpJTJVzudwQxpmFiS6FqFjZ7rvNsD4AzKRM0hG4nks+zK/V00MmVs80fuqxedoKwx8o2t506VLx1zzj+viPRAFaMxPE1eufo2s+K/dZkHeTfqrpVfcvtNVhntya/O4CpYGJVlA2z/9jhayoYz4xzE8ZbNZ5sWvWUXIdDhcoqxom28PkecVMuVTUksU4fVLBz8CTjCmEI80ApNbQGsJ4RX7JWh49gyncyOJkzPIOuEZ+s2u2S9l5l5pFjY1sdcboHgb2hS/8znm5iCnV+c31Stg4oWBu+dD7ceWl+x5W/CChF8u7rR+yEs7zePateKUzHd1jKQ376cSBLfjEp0hhrwml6rudAmo5frdeArRJOkIxKPnJWPo20ZSUXSEH40X4FQ8PzO3Y+wIaFXOvrxnxKCUOkOBDORpI5Gdvnv0JtKvgQFFAxb26Gc3OIzghRIFpQP9Si7mWY2D6246CJNHQtAGzDZL0TE86hy/4Q/ysyqMqMv/bBgvoGCmT6RCQM8Ebq3/1fwns9sOtenM4bHRIqZSM4WuhkUCsasgxHVjc5pcMWoSKje6jdord4
 blKppMo0
 ZDu3rZedIHDMY/r8GclcNvijqIL224RlJtH7HZkcPY7kreNc6VPw56hBlrnYU+EXN/AV2fNqAgca6hASh742y/n3QGpA1XVG1s01tPSuSLlzl4jQRjJ7jTZ4ByxTCqrqw2qX7CzHCUm3qfWwWOvxstKdjhRF+irhSqekgZ1dK9JU2d0V2f4A1dHENPX0+uyXhAp+rS8NcgH3/mIM90kHH7vmKUMb5+STKf+9/BkzWnkNb4RD/gJL0dUGp0SyK7s5HM47cdCcLIu2uILfVXUrDTPbpRw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

DAMON monitors only data attributes when probe weights are set.
However, the function for detecting it is intentionally returning false
always.  The intention was to make changes for complete support of the
mode in a safe and incremental way.  Now all the building blocks are
made.  Complete the mode detection function so that the mode can really
start working.

Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/core.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index 91964336ce31e..806a67d02a6e9 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -211,6 +211,12 @@ static struct damon_probe *damon_nth_probe(int n, struct damon_ctx *ctx)
 
 static bool damon_has_probe_weights(struct damon_ctx *c)
 {
+	struct damon_probe *p;
+
+	damon_for_each_probe(p, c) {
+		if (p->weight)
+			return true;
+	}
 	return false;
 }
 
-- 
2.47.3

