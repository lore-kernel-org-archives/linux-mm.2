Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 01D5010F3DEC
	for <linux-mm@archiver.kernel.org>; Sat, 28 Mar 2026 16:39:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E977D6B008C; Sat, 28 Mar 2026 12:39:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E489F6B0095; Sat, 28 Mar 2026 12:39:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D5E366B0096; Sat, 28 Mar 2026 12:39:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id C7D7D6B008C
	for <linux-mm@kvack.org>; Sat, 28 Mar 2026 12:39:37 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 2595A540FC
	for <linux-mm@kvack.org>; Sat, 28 Mar 2026 16:39:37 +0000 (UTC)
X-FDA: 84596032794.24.40DF129
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id 8F17D140003
	for <linux-mm@kvack.org>; Sat, 28 Mar 2026 16:39:35 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=eIYNftcv;
	spf=pass (imf09.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=eIYNftcv;
	spf=pass (imf09.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774715975; a=rsa-sha256;
	cv=none;
	b=3gks4R9znRRoWY5N08rBbUsrH9h0MbmEu1XkMNirfiIOsk0CA6vzGE6dirxby0hwA455sD
	T/UfhShuaViy0Puxx2ArZPkahyGLEBIwFmMsDcEtHkkB0RJcpgcZTkMVbabbNqGhzwIxPi
	NgaSuya0O/P6UKDmHWwtBkPUAB4PRbE=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774715975;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=fz6GVc1C4nxxAmFHiKc47hrJ8uhEehTWwa6sEf2vnVk=;
	b=vQJ1GBegbF9y3SXL9RO02SsHatLCruHDPnk18aIFBzgFn14GU2QdlOWJk6roDFNgUzvy9r
	glJnLx1F/cQTlIP2/jWWXAhQV0f2/ONW63mDHZOQ4BMC6AXuNy0h108Vqa95a40K274aIZ
	bvnZTAmRy6nNkIJmZZ4ljA3wSv59xLY=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 45C2C42D7C;
	Sat, 28 Mar 2026 16:39:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B971C4CEF7;
	Sat, 28 Mar 2026 16:39:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774715974;
	bh=0PwI1SI+BDoBCXPBrRWqvfcXP+Y8eEc47YaiUYRUruI=;
	h=From:To:Cc:Subject:Date:From;
	b=eIYNftcvj4/Ctr6vTYsINJDWwdgeG9ARYoqiCYAqw8w/O9OPck+HDa45FAtD4/anz
	 lyebe3WhNSw2Ujhm7UXdF9RzgPWL0a5kmTnEcSazr3lVtFXjAinHX5EpQEe8GlIZO6
	 5vC9eGR8AD2KUgPOeRMHjWTi1Dn9mXos4Z2nEPdRoTMx8cF8RcNclfHjjHpPvySU+x
	 NNCruFzN7VoBcW5MUelbNo6jvAsSq8swN5wqXGpN1GobwyRF53R7GFkXeqKeib4h87
	 uoK3DTxzcigI7DUq4Dm2VINyxUJ0boLq2ujjhSG84sPLidKL+NmYjaluOPjdWNlTnm
	 dsVBAcrgemEHw==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	"# 5 . 16 . x" <stable@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH] mm/damon/core: use time_in_range() for damos quota window start
Date: Sat, 28 Mar 2026 09:39:29 -0700
Message-ID: <20260328163930.47096-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 8F17D140003
X-Stat-Signature: 71fh1xbmwut1ur5jseyjuqqokix1sp8n
X-Rspam-User: 
X-HE-Tag: 1774715975-628025
X-HE-Meta: U2FsdGVkX19QGekBNkQYLNX42YBV03GToq9ylm8dW5ZxaftBJZY8mCwRoIW1NYcfEjAP8mGKa/KbucDs5juyX4FLixeaafzh7EEzr8KJTkHDfu9ehFRNbVkz9hgQoVNxQFP67W3K+i312lHYT9Lv42i0yGWJouDqm+FjHKzRy0A5q0pgK1MaBVhA3GfUm2D6mPpeFyqoltP6ZUU55nq/upAmurqaej0imf8LexNeKVCy436pILqx/ZREDggYbgUi0Z7Q/OQCwodFTl8dvTguPUZR0igfnD7tVDWoxDgOSiKikZRME/b7nvW8lqYrEMy3AUA4OhDOV5Fmw2Gek/xmochWq7wTCxaHBDMsfRImUIF0G45JWYOJ42/aX3n2JF1GrxnV6H8cqurHdc2sh6fvxuEiJ5Ed+dnjD2n3wO7rayZLEIE2MZDSoE5uB/i3RknYsJw6diMQ/k4mWlbBCqEG2JGh31OYFC0K28TTqsJOpft0rrBFDkdlk1le7q9yAUAxq6jot5dy9bq5G2AYhh4NHEFCH17XvM+82L5W8kkl5pmP6fr8BhQElJCm8ReluZXXXOkR0WPme5mWbvglp8pPZEmLcnhDoWvl981kDgASuI+H13+G73XILVE8soSl6E3xECMfCtRcXjW5BzpEVY2QSHbrnZRputB0wL6T+5Wytr5DD1TtQbt6ESfJRjqr78Vo3AEpmea8rB6XI7BGP1OmdrDpnrA/t3dvrPgs5bswOy1STGIHi922szHSdWeacpdMuEEzHVVP++RIwuduzIdo/m+VWVP3XeaBX6Tz14OIUvuCxQF09gfVoGDPt043ty+eVcJe46YXUSVlM0VWcx5JAq2zBrQDarn4cyc2KpeCaJoElSahPMDk5Bc17IcmIiEsOo/LLqce7zNOBR1qkrGUZVQWMUUE/l7Al3Qi6mz6SFI2VLUWDDXL6Y+RcMc+ExZcWrSkBijPBElPaVebAjE
 nv0waqI7
 yqv4wICha1joU1cVtZjZat9Dmyb1jtFon0+rDCCoxUleJW/17t4Znw2h6M7rkDtaZ1qgPdbJiM9Q1TPHsHnYFbl3sOEq9TmmV+iSBN2wXoHldYP3VJpRLxrqUD3l2p3ilwgg8/A0KVWTTjB1fjCkqWzhwBqXRSBCJfx8wpBHOnLyDh2FC8fPXC+KKY8yGAmOVAtQyTBnPqgL2DicjZMngRf3fZNFbdJIeao0pbCUOQ9LYN0Y=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

damos_adjust_quota() uses time_after_eq() to show if it is time to start
a new quota charge window, comparing the current jiffies and the
scheduled next charge window start time.  If it is, the next charge
window start time is updated and the new charge window starts.

The time check and next window start time update is skipped while the
scheme is deactivated by the watermarks.  Let's suppose the deactivation
is kept more than LONG_MAX jiffies (assuming CONFIG_HZ of 250, more than
99 days in 32 bit systems and more than one billion years in 64 bit
systems), resulting in having the jiffies larger than the next charge
window start time + LONG_MAX.  Then, the time_after_eq() call can return
false until another LONG_MAX jiffies are passed.

This means the scheme can continue working after being reactivated by
the watermarks.  But, soon, the quota will be exceeded and the scheme
will again effectively stop working until the next charge window starts.
Because the current charge window is extended to up to LONG_MAX jiffies,
however, it will look like it stopped unexpectedly and indefinitely,
from the user's perspective.

Fix this by using !time_in_range() instead.

The issue was discovered [1] by sashiko.

[1] https://lore.kernel.org/20260324040722.57944-1-sj@kernel.org

Fixes: ee801b7dd782 ("mm/damon/schemes: activate schemes based on a watermarks mechanism")
Cc: <stable@vger.kernel.org> # 5.16.x
Signed-off-by: SeongJae Park <sj@kernel.org>
---
 mm/damon/core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index 3298ee8d8f64..19ae388ff1e0 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -2449,7 +2449,7 @@ static void damos_adjust_quota(struct damon_ctx *c, struct damos *s)
 	}
 
 	/* New charge window starts */
-	if (time_after_eq(jiffies, quota->charged_from +
+	if (!time_in_range(jiffies, quota->charged_from, quota->charged_from +
 				msecs_to_jiffies(quota->reset_interval))) {
 		if (damos_quota_is_set(quota) &&
 				quota->charged_sz >= quota->esz)

base-commit: f16846f15feb80ea9553b860bd0f70d9072101aa
-- 
2.47.3

