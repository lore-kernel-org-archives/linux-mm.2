Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EA4FB109E557
	for <linux-mm@archiver.kernel.org>; Thu, 26 Mar 2026 06:24:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 788EA6B0093; Thu, 26 Mar 2026 02:23:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 739CE6B0095; Thu, 26 Mar 2026 02:23:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 676306B0096; Thu, 26 Mar 2026 02:23:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 4A82A6B0093
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 02:23:58 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 04C981A0B1D
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 06:23:57 +0000 (UTC)
X-FDA: 84587223756.20.E63817B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id 58784180009
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 06:23:56 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="BdE/wPLf";
	spf=pass (imf24.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774506236;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rripEDGLSr0fk6OIk11FGfmcCSBj7/tUsr/7v3HOFNI=;
	b=iauwkat4a8CsPvWisz53CSY/V9Sd8ArM7z0tFIQ0/3F3iKbKSvNPKMQPRjaFdyMub4E5Yn
	LMCik1ReoIPQV5q5AqgdpHhWddHzcuWKGF93nYh0pxbtEBjJZiqU+doDeg3NJTM5L9hk2s
	tGuMGfXlbw9v6aTI2yusAkR2CuqjPL0=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="BdE/wPLf";
	spf=pass (imf24.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774506236; a=rsa-sha256;
	cv=none;
	b=mBQqnPmyLPYrHokLfub6lL4PFnw1GAlAB5Z0HR3EEHMz6jMPHSyTU4mvoaKkbnlnY2xP/d
	MihjKVMShsMBUTrYOj0Bsn2wgQjyjC3Xmspu3iGMN5V+1ztYIV50Bjec26JGeYwF1Geui0
	bGq2Hhjobwn7Dkb5YFKYhcuK8ztLhW0=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 3E4B3438E1;
	Thu, 26 Mar 2026 06:23:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 063D8C2BCB1;
	Thu, 26 Mar 2026 06:23:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774506235;
	bh=RlvImuIw6Gj0I6frcAflxi6JM5UxJrr64Xql9+sFKw8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BdE/wPLfegTP3LfMONDrnSHdGGjqAP02qzisOsg/6SVv0il2Gz6Zo7psUV2GZR0La
	 UYN1pyOIXYh+3pmFwvWs4Hv8fwX2/wUbJbLr0+gSajvOZmZzOEhVRhhCdVj2O4F3xc
	 YiF0Sf5qct5ls494NsQVYa2Qr6i3X3ExK7hn1VTGkK3dNj7XyZ2729pT/1uqpdVpst
	 5+K8p+ATViUkRPdZX3bqi2gT85e7lPGApnlbLSxZ2snON6BVR+u7hxTwVrT5F/Rq4a
	 ZZ8PgLYH409iRytJezh4+If98jlziGUqidgTXPbf70Kb2jrCvbXOuqYt/qX1wiXury
	 Exr884/Z7/gBA==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH 1/2] mm/damon/sysfs: dealloc repeat_call_control if damon_call() fails
Date: Wed, 25 Mar 2026 23:23:45 -0700
Message-ID: <20260326062347.88569-2-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260326062347.88569-1-sj@kernel.org>
References: <20260326062347.88569-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 58784180009
X-Stat-Signature: n1q9rogoj3gxsx5wujgs3djdfyfmxjjg
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1774506236-667361
X-HE-Meta: U2FsdGVkX1/FKsGKY4rRRcD0N6gvotdPkzUfvmqcCTli0c0VAZcjAa/mv+OKmp8/CdpjOP3UXdeAG3KiuWNX++aFFOX6jARpLPk75JJr3p+4MM5JN/oDB5cPWcV97VJsX5miSyWeepL2vrwIx2ZMqbLlfCN5UuYNLuYkL9FbMQsDx1skG2IfZnfltnA1RYwPq690U37BT0V7xZbeNhygwrw/v95MTL2I3H7M6gK8Xd8Ygal7w2kyJskMSNTSrM3KmxJBsh7YbhlSq9yfT8OKm8xuBxQEaS3jYEr7xNV97ZSHu3J5VxIaOTbre1r2kkWK5dL5rUhqolKfG5ItUjgJn6FPwRJ/vCqqjoUSgFmxft55TgBJKpMQA85exqG+/c8AXZulMwkAYnNu+qHHMAhHV9W//2pcZwZe+/e+Bw03u2LiW2pfRCyVhmvCOK4hYicAelqi9BEvIUwy/W24PQ3JHsLLN/sz7WqPY+6lyUYqYzkvLb4vAGhgXwpegpIS7MtbxUl26iuJu8KqEiI0EQX0+7nCADyB8ZQ65PFpBmwh/nWqW2dfDXdjr0VpcsXsqHPbFm1yXaNZ4SE0+/6o5Pe+x4wplhGq7uwPLv8rXLxkPlVld24VsKT5tY4+B/2XQlspwOrY5MgWwfTafXG73EzbeFIlPo6r57N5kgHUZMylbR5qjVhR306vQCpvV/Hy4q46Qb1LwLLltOmpjJFf+d9gKQ/7+TnXiPOyGDoTAuGv9d5w1z3KtmZj2tGL8rzymYMYP+8La9alDym7IT0jYM/n4lBdkp6xJcvW+WxOq4pgLEFJwRYYde8ezYBi9oPviYVopkjVSiMp7tQ+WaAvQ1cl8NLJPENZdo9w96brZ5R7ALxjSxgZWygkO7ht+sj3Ysufdit1n3kSLToC0FoDKwALSX2BzT25FZuhVWYJiJC53mjhgat0AGLlYwMm3v1h5uqQMxS6JH4OAn0QSP0FP9M
 7tp76xNO
 CUeyqFik8bQbopde0LTB4zEOJqW6MutZA2F3BtxPMvrhoreMZughS6dapK+jQB/7nu1vCASwoyeW/AfL2C8yDvuTD0NytxyYi/YKLSOrdlkhhnTkpUGb9yLwh9h5V6pxESjor2rwo4nP7OyQ2tnlF+zxIiQ2ctuaNhCP/RXEZPILwkSB8NXVKjZVLbu3GFWFntDYy+JH1n5cc/aVGSYsOXG5qV6dyD4+Y5zVHvpj0UTaRaUSRkWVuqiQOzpFxZJZnV5fVtx8j6zf5Im9+iGceHj1jGg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

damon_call() for repeat_call_control of DAMON_SYSFS could fail if
somehow the kdamond is stopped before the damon_call().  It could
happen, for example, when te damon context was made for monitroing of a
virtual address processes, and the process is terminated immediately,
before the damon_call() invocation.  In the case, the dyanmically
allocated repeat_call_control is not deallocated and leaked.

Fix the leak by deallocating the repeat_call_control under the
damon_call() failure.

This issue is discovered by sashiko [1].

[1] https://lore.kernel.org/20260320020630.962-1-sj@kernel.org

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 mm/damon/sysfs.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/mm/damon/sysfs.c b/mm/damon/sysfs.c
index 6a44a2f3d8fc9..eefa959aa30ae 100644
--- a/mm/damon/sysfs.c
+++ b/mm/damon/sysfs.c
@@ -1670,7 +1670,8 @@ static int damon_sysfs_turn_damon_on(struct damon_sysfs_kdamond *kdamond)
 	repeat_call_control->data = kdamond;
 	repeat_call_control->repeat = true;
 	repeat_call_control->dealloc_on_cancel = true;
-	damon_call(ctx, repeat_call_control);
+	if (damon_call(ctx, repeat_call_control))
+		kfree(repeat_call_control);
 	return err;
 }
 
-- 
2.47.3

