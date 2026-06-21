Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DEB22CD98F0
	for <linux-mm@archiver.kernel.org>; Sun, 21 Jun 2026 15:58:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C12066B00A2; Sun, 21 Jun 2026 11:57:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B4D776B00A3; Sun, 21 Jun 2026 11:57:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 978AD6B00A4; Sun, 21 Jun 2026 11:57:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 649FB6B00A2
	for <linux-mm@kvack.org>; Sun, 21 Jun 2026 11:57:45 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id CBBC8C17EE
	for <linux-mm@kvack.org>; Sun, 21 Jun 2026 15:57:44 +0000 (UTC)
X-FDA: 84904375248.17.C2D79B9
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id 450634000B
	for <linux-mm@kvack.org>; Sun, 21 Jun 2026 15:57:43 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="lqNv7/Du";
	spf=pass (imf27.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782057463;
	b=GX1PWdYprkUt3C5rcvuRTg8Qe8NpDTTZSrsuuKJLyTnk9njEmez22r2OOYs3Jw/AQ5Zo9q
	anBnvUNlQLTWpHz6OMcAnfD61AL/nFxDWzPaiQ0MTSvHOEQO/qWxVZEcsJhLcQo1/dNzJi
	ILbd9dYA+KiP/nqDXg3wV+7fY/FIepY=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="lqNv7/Du";
	spf=pass (imf27.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782057463;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4SCo6lzfTq2NnUpvCBQ4Z8jQXScoLCzX5q9Y3rAVGW0=;
	b=nvxyDLv96e8KJ5XUSS4nCn/2NR/IUUlDgBL8zBUZ2ZZNNBSAAoDjhKDy6n2CtQXcxpZOP2
	ahCeuRMk3m8jfmgvy5h7E6N7eVebAdzhZOALeBOQEad53vxscbwoZbVJ1XEk0KLbKzHMoc
	ANXdL3XiHBAmHtqQUH9Tfv0d+hJc1sE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id A00744453A;
	Sun, 21 Jun 2026 15:57:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E833B1F00A3E;
	Sun, 21 Jun 2026 15:57:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782057462;
	bh=4SCo6lzfTq2NnUpvCBQ4Z8jQXScoLCzX5q9Y3rAVGW0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lqNv7/Du8+OBKTSKBj6MYibfAgRaqYsLp2aNRZOlHdnSQQoofM9LS7XWeKKGazW71
	 bICjE0aaZEavlvoBmRcW1ey3b6zwYgfJIhKsXoOmhPczFv1Aby5cBXZkrXoNemBc/B
	 SMhaWr1TVLHQXW9FT+4iw3jFpu8gfLbA31kDeZDqVu5miYyALaqjLhnxJR2HfBQm6z
	 k931Hm3fKMGRXXyDrXVg0tVglaHRgAMzcMOZNrZKFm4DNfc+Hie0k9wuTpCoonB6t9
	 gWP6XVG2xJNKp4XHclXT0eN7hqZ/6PdKigzWiGWqRN1feCtbhcAJjDMa0xUiUSGxxX
	 WU9ow8qXt3Kmw==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v1.2 14/17] mm/damonn/paddr: remove attrs param from __damon_pa_check_access()
Date: Sun, 21 Jun 2026 08:57:10 -0700
Message-ID: <20260621155715.87932-15-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260621155715.87932-1-sj@kernel.org>
References: <20260621155715.87932-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 450634000B
X-Stat-Signature: bcjgdh4j895wzihd31xcbu9txdmmjx6u
X-Rspam-User: 
X-HE-Tag: 1782057463-215277
X-HE-Meta: U2FsdGVkX1+RMMcgVOJKLpNqAyVXS+CprpljNIK5AaIUvdqg/3l4ub21xSoEVed6/NO4Zdj8anElJfTAhHs241bsggzUg4Vb5X7IDKPjo1OZpBrPzidYYgjwRt6x2PizsdkoUbJu+L9wFKZYAWoUkZRrk7QdHpD0zhex5XXnMjjNlyIhxU2CqdmLy+mhz3A5S9kRNvOAsREA0kcuZMTsicxtuIzQ9dQwwCAhPWX5m7XbsZzBL9bsxSTb4m4RyRjfGNGgaoQ9WMEPcyLS4WQZkV/trl23ESNK27kZ+NV2tJDOyobk2X6pxGCD3HHPlXYnenZcHDc6kJihx1DXpor12tFkqYX0s0nYVZXD7hUc1JdEpFKTd1egQCfFYtl68TpW+LL/lQpTeRD32jgbxNmRcJCRY7U+00ODXk3hxriFJYXZqREOqJtNi1V1/ysPrFtQobFL1x7QA4sTolveZmAPd9Ye1aGppxFU7cEJjMX48iR80yO4oUuufpkLWTPAHrPJLGXIAuOH0jph1htbBXXq6mcJ2qZPritsPSnZ0WsI3xnnrFJtza5dQjkrsjCPX9Ry6aTNhVLBlAHoO9VKtv89KIDze/ZZ47TEViNZlRNfB7Tcs4keue8fSRDPoAQ4y/DVmcv05g8M1LEu0bQhEbp3qFKLkQdMJvDhDbn0LZ3pUuU02GmHv2PQfxh/iWmZI6JkwXVJAUa1zhlHxbpe6tI9vZQVlqtBA44h8CV/o/18mdU6i/LGyQif42GRVpvudjNYyf9SoTwEIUBNQ3OxEtad84ShPN+4d75uILMrw5Ry/5oWbs3y21wvmlD0tiIqngVtlV80zr0ebEBGeq56l1YBRB2dNqjcFK5EkWh/hvkr4gpyfEGbWf2GBFIjxhO+soYlj33yFuqt5FNCXacW1HK3IQW7U494QLJ0UkK9b6TzHtPXbY2AfOCRJUGYTeYijmYWjKIdvnRW7dKozUL5o+7
 xnASi7LY
 jLR1QfUx52+AvUBXg+SfzH0g9t9tRotiI8J6huGcwJydzgyy5PYftl0hTGkVBcr+NYZ0zPiQMnLHfTcOpegT6+f7UWkDkGiXNb5UNVp6MWujYz3Y93jOaZBqtPiNqEWQGoBWCIPmPFA1RA3Xp2KJ/SLBrFKiCW6LO8ulXpaBVsVyR8rhjENtDOEBR/8EZYehKl21BMmqOINd5WX82vjQ3AC/MSOMHvYMzi0mGKB2AxGEebe5IO9zJVCS7DLs+TLxMAuWbGLHu5ZnDsDaTOIZKGhZgBA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The function is not using the parameter.  Remove it.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 mm/damon/paddr.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/mm/damon/paddr.c b/mm/damon/paddr.c
index db48ad274b078..a301e831a3945 100644
--- a/mm/damon/paddr.c
+++ b/mm/damon/paddr.c
@@ -82,7 +82,7 @@ static bool damon_pa_young(phys_addr_t paddr, unsigned long *folio_sz)
 }
 
 static void __damon_pa_check_access(struct damon_region *r,
-		struct damon_attrs *attrs, unsigned long addr_unit)
+		unsigned long addr_unit)
 {
 	static phys_addr_t last_addr;
 	static unsigned long last_folio_sz = PAGE_SIZE;
@@ -111,8 +111,7 @@ static unsigned int damon_pa_check_accesses(struct damon_ctx *ctx)
 
 	damon_for_each_target(t, ctx) {
 		damon_for_each_region(r, t) {
-			__damon_pa_check_access(
-					r, &ctx->attrs, ctx->addr_unit);
+			__damon_pa_check_access(r, ctx->addr_unit);
 			max_nr_accesses = max(r->nr_accesses, max_nr_accesses);
 		}
 	}
-- 
2.47.3

