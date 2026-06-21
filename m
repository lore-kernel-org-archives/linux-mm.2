Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 387C7CD98F2
	for <linux-mm@archiver.kernel.org>; Sun, 21 Jun 2026 15:58:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8DD3D6B00A3; Sun, 21 Jun 2026 11:57:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 866C56B00A4; Sun, 21 Jun 2026 11:57:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6E2456B00A5; Sun, 21 Jun 2026 11:57:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 2AA1F6B00A3
	for <linux-mm@kvack.org>; Sun, 21 Jun 2026 11:57:46 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id A2D7DC1A98
	for <linux-mm@kvack.org>; Sun, 21 Jun 2026 15:57:45 +0000 (UTC)
X-FDA: 84904375290.08.A4C6702
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf19.hostedemail.com (Postfix) with ESMTP id 1EDEC1A000A
	for <linux-mm@kvack.org>; Sun, 21 Jun 2026 15:57:43 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=PhOnWHb9;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782057464;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yDzAJDAVQX7rFXuERBq8+a6fsMKEIvYdRJNiU0vHoME=;
	b=VyNKrTRA/UjyYilIxb4G62sDde1iY2Prd7OOfkLL2Dq5K72fWD86YV3KRapebWDOqV29hX
	eQSpDMX/okwyisrbmpliBZJp87vAAhh8wQJ4rTN/XnXlSX8BdQBa94/xGjHB4JW91G4aE8
	NYt6N4UE8cbSaQrLrZZLBiY3TQCTwPM=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=PhOnWHb9;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782057464;
	b=QBzA0lb1hWDrHHDZGe8LYNq4mHJX0Nz0isM3PHRIq505tpqiER3tIeH5FompLJ1DyRj2aF
	OFjFynmtucY5x2Zhqaesu7iCRonUIXR4qFCaKP5ttMV6mju00VU931aiol1dumMVOnYzJL
	STaS0VJTZm1pBzzaoWPGgrKA6B72ZjY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 7B1954453D;
	Sun, 21 Jun 2026 15:57:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF43A1F00AC4;
	Sun, 21 Jun 2026 15:57:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782057463;
	bh=yDzAJDAVQX7rFXuERBq8+a6fsMKEIvYdRJNiU0vHoME=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PhOnWHb9n4REOSc7fN+gT35oSni0CW5rcKMysozwL17Yfmor7IlyIcGxiLZUvYZYT
	 DRPTNJH8Yh14wUFlkAUqcbXqZnH2icH9uMhosiKuwhQapU825XHj1CNhnya2YPTaPv
	 HgND5m4qGXyhrg1ps9TQAJSCCxTMYWHBesffCOPeBvJeFwLeqhmdidQG/5FbH/Sgp8
	 /vx36FeydesJNO6aH8Dz22rDz7DekLfdRh8CQRscI1ebtkTdc3ZzqmpFaj1CRTTWMo
	 cdAJy8QpRPWmLNrpZauP5OUo3sq4Q0ePSOMCmU12CNryvZ3xON+LRyfny66B32r/VX
	 DJ6eoFxr0Nkxw==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v1.2 15/17] mm/damon/vaddr: remove attrs param from __damon_va_check_access()
Date: Sun, 21 Jun 2026 08:57:11 -0700
Message-ID: <20260621155715.87932-16-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260621155715.87932-1-sj@kernel.org>
References: <20260621155715.87932-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: yn856nqnfzqdodtgkjndrczdxdik1hsi
X-Rspamd-Queue-Id: 1EDEC1A000A
X-Rspamd-Server: rspam11
X-HE-Tag: 1782057463-908933
X-HE-Meta: U2FsdGVkX19hFsZlhASr8ITXhj1ILhqIsC08PX2eEISUoOX69pIIkriy5YLrqZuZMBfac8G3IpHaua4ZWetyMo9QSC5Efw1CtiS6dro4SyYaXLXz8VlD1AwCKMvx/yCtE5JFaFmGDS9Voymx1ba6+N+wF/WxHNFgaQ+mPZt9nx4NTVFjDCLvy0qaL1J+/Rl87gopyG4/jLsjaRWfJXKNJW+oAjEa1SB1a2TxUBdOWuJ2J7BNN/Dcn3Ua0clz/gFNZ93+29wWP5jtMi3PSaq2eL0Yjch2GjhoWAJv6033p0ePe8TWP4HCMpDdZwGRrr2ZKdyAp0qllt4uiqywfHNrX34+Mg+v3d59Ti6O13wbCdvAGFy+g349LH36ioOVHQN8LJRrCnm2ryOAjRHoXxJGjqnjaMy+CyC5QnuZyRn9Wc9ScPDvrFPtRtEY79yGDZnXlvReQu/+nPbHJvkUlCNQExFcYuiSlzbCV05GzF47xMcrQDUoh+GHNHTtNNVLb52RRCDxe/MeUgpF3+jH4P6D1YdIel64J3yvytWmEgx5LABI4dpjRAKu9y+JnrMK8epe4fyeDSfSLqM6uZnrhLfd04YC44zP++fGz+sZFlEDniEVIUyYObAvPJRjjAgUoxQ9MFNhVvSTa0jlahE3vTHHoI1rY0dxm7A6oNKxowi4kZzVtSXSyG+to8a94k+ZwUKtrjUDewCCULMAB6iWZc/vjTBpmWdGqldlZ83HG2v0KCktquwfi8NtgT6SSL8Ialxwxw/zj4xK6VeUHwTcBNpfOaymGJJXFT4+tdUuRuXJ8s3noApSDr9ObltYMTLT+YYWmNWiHuOpEfQUHdZpqWTrJopFON4qDRMIvC72KHbNFB0zhBwAPjNcRlhYBaqygKkYFH2slgf3GBG7iL7IzrR2nvsXm7xWAoezzyglIOfhYQK/OSh1RW4BF6v1Y65h8SDhOvLLvwlYlFco78kMTPu
 DStYxJv8
 1UDO/TOhjAQioXhQv7YDH59fCf2FFXuQPoMrUqeRr6Pek1vdUvsZ3WSefuAIjir/ZHfw1F6o/l7G0G7RJaTmmSVRAxWVnt1n6iX23M5ED9ps1h49B+mtmykvm/2iH6Avl7qU/fbgdp75HeJWmIP7I5rjKkMJPXzD7ozZXWwrc0ECsmCQGLbKarBoMpbU2fo/jt1f95bD1lYVTbu0+RrgihctNzcusD64/3davys+ZGQ8TYcnT0ReF3GyGbClwyJ9jme46IVaYlGbhPXwuniJlC9jApw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The function is not using attrs parameter.  Remove it.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 mm/damon/vaddr.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/mm/damon/vaddr.c b/mm/damon/vaddr.c
index 2e12cc628fea0..ec08fc6624479 100644
--- a/mm/damon/vaddr.c
+++ b/mm/damon/vaddr.c
@@ -495,8 +495,7 @@ static bool damon_va_young(struct mm_struct *mm, unsigned long addr,
  * r	the region to be checked
  */
 static void __damon_va_check_access(struct mm_struct *mm,
-				struct damon_region *r, bool same_target,
-				struct damon_attrs *attrs)
+				struct damon_region *r, bool same_target)
 {
 	static unsigned long last_addr;
 	static unsigned long last_folio_sz = PAGE_SIZE;
@@ -532,8 +531,7 @@ static unsigned int damon_va_check_accesses(struct damon_ctx *ctx)
 		mm = damon_get_mm(t);
 		same_target = false;
 		damon_for_each_region(r, t) {
-			__damon_va_check_access(mm, r, same_target,
-					&ctx->attrs);
+			__damon_va_check_access(mm, r, same_target);
 			max_nr_accesses = max(r->nr_accesses, max_nr_accesses);
 			same_target = true;
 		}
-- 
2.47.3

