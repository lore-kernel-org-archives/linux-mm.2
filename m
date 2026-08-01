Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 902A7C5516F
	for <linux-mm@archiver.kernel.org>; Sat,  1 Aug 2026 21:13:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F13526B007B; Sat,  1 Aug 2026 17:13:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EC42E6B0088; Sat,  1 Aug 2026 17:13:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DD9D06B008A; Sat,  1 Aug 2026 17:13:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B63746B007B
	for <linux-mm@kvack.org>; Sat,  1 Aug 2026 17:13:26 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 5811EA15D0
	for <linux-mm@kvack.org>; Sat,  1 Aug 2026 21:13:26 +0000 (UTC)
X-FDA: 85053951612.07.EA13C78
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id CFB0040005
	for <linux-mm@kvack.org>; Sat,  1 Aug 2026 21:13:24 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=N2qQ8ZkN;
	spf=pass (imf04.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785618804;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=Zgds1KWwyKC+2cnQi37FJX/dPPIH+eZIO9DX1EvW4BM=;
	b=dMV+Xyc+V2rg/DqrAwaRV+6DXsNXku8ZUeKsZk5QiJL6Qq+b0wUcBUC2Q5Oj3hwUY0AORJ
	1k0GQPIwy0rIAtUOtfxRpQPQ1vDygNIVj1zHREvOl8xX2gKYyMrrrMxlTlefNSFtBu/ooC
	dQWxq7OSt5a8t3LhhQ4ouR/kqoAMjmw=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785618804;
	b=Td3V784TczWKSQhs0/Zi2/DX72VxlDzTY/0Wl8VXDqcVs9HJ4mybAzGMDvXDjZMSlnfORI
	1dpBTHbEsnkB0Va87FvbGx8U1tNsMmw1UX9XYMNcjcCEF5wAq7LTH/QBGsjGUek5SxMuRL
	vZHqX1crJJowpVhd95ROw0901gjMA+0=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=N2qQ8ZkN;
	spf=pass (imf04.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 9221743474;
	Sat,  1 Aug 2026 21:13:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3DBE41F00AC4;
	Sat,  1 Aug 2026 21:13:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785618803;
	bh=Zgds1KWwyKC+2cnQi37FJX/dPPIH+eZIO9DX1EvW4BM=;
	h=From:To:Cc:Subject:Date;
	b=N2qQ8ZkNxXx6ISsQ8TaGZ+cCD8ZUA+9+/V6FRYXNsce37R+Ou2N1Hc4PGW6x92v3g
	 f7/7wRdJGMfo2OCn1ybsZRz8kmVQFG06S/Kl5mg4lPjTqgRA5Pkd5/Z1tgy6Qiy37/
	 2bieEOWzmlCkYJ0BqAeneOlpXHUmevhGsBIN5rb44Za0nXxaWFxS0M0LFuJGMQwcAD
	 UW30BTR4MWsZTTtbLyU7IXRZNookNIeem5reab0R4yl9IScvMVjU/2l6SwHc8dVFY1
	 lxqxOju361z63bWP5lTOGYZYQzuioxr505pI7a6L3YG0XVcggq2HL+EEdvQ3g9CUm+
	 a36M0RbtXg+aw==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	stable@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Yunjeong Mun <yunjeong.mun@sk.com>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH] samples/damon/mtier: error out for zero quota goal target values
Date: Sat,  1 Aug 2026 14:13:14 -0700
Message-ID: <20260801211315.2456-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: CFB0040005
X-Stat-Signature: ya78xg5hparwkfex8qjqy839up9hco1z
X-HE-Tag: 1785618804-73258
X-HE-Meta: U2FsdGVkX1+qhrcSILRiEi18HShiYcgfM1vUKo+eRMih6nZa4HV65f77+22utDu2LqSmjGvYmpNgWl2Cy23Cf//rvwVCYfg99YXj9f20GFtZBJC3C8cax1WBbujoy4+v2psirUfHIiXv1vQqEp+qX4E7GGazbGDTTGIXfr4Q2yC6Ym/mJEHcs1bYo4DgoM4Y48FHsnDok0FmxTSqCMjrmjtIp0eIdMbjYzOcq5FgXX5ie3ubB/1pxoJhkhF+V4eyg1VwJNlMA6RHln3tOY71gg9h+SP2j4moN8zappLp/UPZ30epU7ii/d25ddYoR+35hlWJqbamR6bRmD5ZWUotFA7Q7ti/86HMpc60DvBBucvpvb2DvX3eixOtYkwwTGX7DhT4O9h3Qil4BML9uRJ5BwG6w+SbKsN8qlnqec55LGULNuvW4o0Jv0FBW938Qbh+vzd8wEn1eJ7GxBHJeoDnv1qPVz0RNSvQ9EnxuiAtCsy6GJE3cP4fN7asbMoUcPWpAKMcN7lnZVveEc3/9ULtGuaBWDqEwsFYlueW29d/pt4+hHbISzJgRHeLCJrJ2A/LEQvoOm/asYNu18bbw17xjOh6dxAtJIPS0uc5ZWAaAjeeX41E8y9rQjFuOUYUx6XAaPELqXqr4OimnBuW8w4Xio/9dk41n37+dHbG9dZn6epwekG7gCwtad0UiCHAZ8Y+a1oIhVa3ffYcYDFqLkwkb5hMEbBlWaUd5fizqfV+1Yc5XTrhjr50KzmIAPXfnnXF3/WW0icVytgg6LyFf7vMLNekfU8HmW1KO6WriBFrsOMpyN0vUMrYmlXbyk1df6Z+A9/EoHaYF6np4gmJ6cy6xaS8cRLRvK45TEmtSGpfwOsAQhnmmfpdpzFUN8LIsFWeejkH/YJi0SaN/0bNKrom8xS0EzmP6XdSveYhpKR0AJkavxU3ClrjGjF4671ec8INT8YZfeV3vId5gP6sr83
 J296fV3O
 u5SFsuIe+cvEhypIsr3ZNzOcV/ix1NpaoRMI/rOyY+pBG19ZOaLyO3hXLOK9NbEcHbepOXauRjSH+6dujSisOWZ9Jp3WcmSOjgotfXjSdYNTuZZF0YyCHjn7epMdaJECBQA4eyGA5WraxomfEZdX9Fjde3zPUv8SGSkdMLVNWh3BINhgHug5S2usSyGCTqjohM0g095XSUU80MAO7hY+XbkVH9uN8O5u4jCTCdWYE/uG5G44=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

damos_quota_score() can trigger division by zero if the target_value is
zero.  DAMON_SAMPLE_MTIER lets users set the target_value via
node0_mem_{used,free}_bp parameters.  It doesn't guard zero value case,
though.  As a result, users can trigger division by zero.  Fix the issue
by returning an error when the user tries to start DAMON with zero
node0_mem_{used,free}_bp parameter values.

DAMON_SAMPLE_MTIER is just a sample module, but the consequence is quite
bad.  Also the zero node0_mem_free_bp parameter might look like a
reasonable setup to some users.  Hence, the issue might really happen in
the real world.

One reliable way to reproduce the issue is like below:

    # cd /sys/module/damon_sample_mtier/parameters
    # echo 4096 > node0_start_addr
    # echo 8192 > node0_end_addr
    # echo 8192 > node1_start_addr
    # echo 81920 > node1_end_addr
    # echo 0 > node0_mem_free_bp
    # echo Y > enabled
    # dmesg -w
    [...]
    [18792.235916] Oops: divide error: 0000 [#1] SMP NOPTI
    [...]
    [18792.242787] RIP: 0010:damos_quota_score+0x6f/0x480
    [...]

This issue was discovered [1] by Sashiko.

[1] https://lore.kernel.org/20260801202657.117135-1-sj@kernel.org

Fixes: c5e67d40a102 ("samples/damon/mtier: add parameters for node0 memory usage")
Cc: <stable@vger.kernel.org> # 6.17.x
Signed-off-by: SJ Park <sj@kernel.org>
---
 samples/damon/mtier.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/samples/damon/mtier.c b/samples/damon/mtier.c
index ac9c24b92ead8..d1123ebbfab90 100644
--- a/samples/damon/mtier.c
+++ b/samples/damon/mtier.c
@@ -156,6 +156,9 @@ static struct damon_ctx *damon_sample_mtier_build_ctx(bool promote)
 	if (!scheme)
 		goto free_out;
 	damon_set_schemes(ctx, &scheme, 1);
+	/* zero target value causes division by zero in damos_quota_store() */
+	if (!node0_mem_used_bp || !node0_mem_free_bp)
+		goto free_out;
 	quota_goal = damos_new_quota_goal(
 			promote ? DAMOS_QUOTA_NODE_MEM_USED_BP :
 			DAMOS_QUOTA_NODE_MEM_FREE_BP,

base-commit: 51b0df5cb9a4175af0e3c9e471cd70e91ff8eb4b
-- 
2.47.3

