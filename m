Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F1F19CD98F2
	for <linux-mm@archiver.kernel.org>; Mon, 22 Jun 2026 14:28:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E6BE66B00B5; Mon, 22 Jun 2026 10:22:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E1CEA6B00B6; Mon, 22 Jun 2026 10:22:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D0AF36B00B7; Mon, 22 Jun 2026 10:22:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id CC32A6B00B5
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 10:22:09 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 40D7B401B3
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 14:22:09 +0000 (UTC)
X-FDA: 84907763178.29.C6012D4
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf30.hostedemail.com (Postfix) with ESMTP id AC98B80016
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 14:22:07 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=TQk78hTn;
	spf=pass (imf30.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782138127;
	b=6wc6nY5UVhd9fFjvQgiCuECpriOjAH/iVBWDnQuE5uKgSL4mFgX7ow9BrvopC3xcj3ABTJ
	zn5/ezL8IwmUg0GHv5E4vN8AE4AO7/IECzBpfe6+q/h3sY5VNqyO7hxlldnlFi4WxIkmPV
	7tnZTA/oR0ICz+8UW9++nJAXqm05knU=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=TQk78hTn;
	spf=pass (imf30.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782138127;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4SCo6lzfTq2NnUpvCBQ4Z8jQXScoLCzX5q9Y3rAVGW0=;
	b=CRURnxQL8Q0dWGAM2eG6Q7xkGRuR0ezQWzf7IOb5ROCZXuuw5n2BzRPnT0si/AkRFy1udw
	S9fpbZPgyHLb2QamqyaRwqCM6+wn6lxqW+MoKm8sILOjjb6UP1ylYPi6fvZfZM7xHc1Zao
	JD9PGqkRxSkIxuOSeBpXo5jyfvZRO6s=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id E9D584169E;
	Mon, 22 Jun 2026 14:22:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B2971F00A3E;
	Mon, 22 Jun 2026 14:22:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782138126;
	bh=4SCo6lzfTq2NnUpvCBQ4Z8jQXScoLCzX5q9Y3rAVGW0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TQk78hTnJ8eNlf1ewgMytoD3vl5FB50qv1ZN1hvnJoB7BPPBS6sG0RXknLtEEYTfp
	 5k5gHrTrnGZu+vIgJ4U4TW6UX8m9/bjSPKW67R2hseYeEO0N2d3tZ1CE0dM/evRsSZ
	 Wrxx9bcY97kzpjUO+DoQI4Q9a169qG22CQMGJlY3jC0DyLm+/cOrk0RS2ZlpDjH+fh
	 Y1qy9KKHth5FiqNHhkomyE8qiPZlltujKfU4oA19/AXsmyCGT6iPDSNkzJeUy8qda+
	 1Or/EDQcxnGgBiMiF9ouh5aNquaGcJUOzGQfhvFuHpQ7RY2pwdMwrZLxG/MfcXR2jc
	 IAjlparSKqkwg==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v1.3 15/18] mm/damonn/paddr: remove attrs param from __damon_pa_check_access()
Date: Mon, 22 Jun 2026 07:21:35 -0700
Message-ID: <20260622142139.30269-16-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260622142139.30269-1-sj@kernel.org>
References: <20260622142139.30269-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 17qfrbi3qyfh6xghqxnfoqqy5yesio3s
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: AC98B80016
X-HE-Tag: 1782138127-709507
X-HE-Meta: U2FsdGVkX1/lEL1fGI7vZJwhWbuf9PW2FizTlbBO3wvVcRbsR0XmwLARmey/VtrozWnrmh+lBGEm3R/UBlMyIhZa0e0MVaP1Kd7z8Nya9kGR0mh82ndBfaThvF6G2VYP47Q4K+1mOVF7R/BehhTlfrDOTNNSZ054Xfv7Fftc747e4s0QooxVavUAt3bXWV/wah9Xd7ZEvbcO6tEnAR7Nbp90oRfM+92MT2JNI8jEUSuEZzFU72nxRlGU23LPN37KOmWuBdTfe9s3BAA6/LBI8KOoFY6BuWVnj0u9T4S065l2iSsZU+n9QyLq9TX+Ibus1qn1OTHeE8iyn0bbDF88VeScQ4CVCHOshrLja0rJjSttIpKz5R4iajBQ1UtxCe2UT4P2YirjGS6fjUeJWL3EQ8mnps2D/8d1gmXZm+bNmXn4J3HB/vir2LSN9bB7Vdmqs9+RcG70V9s33yVkn0y7uKaNEfnrlY/WB7fEt/HLK9kYPdUI1nvMbXGV7zVUsPmh080Zuyva7WCPk6lK6VxamNRIDzTVmW5smI/r7jRo6JzgHWNu3goAb6xQeN2IMapGLBeExgfXutMy4ruf7SivPIxSLkwzS0mtYXYMkSxIsxZFnsOIvH4HtioTSySo2ebu0CvRFELFv/THobPXP/Xx5/5WrHnGbdCaesOEYvHZwlStBkyPMZSKYBeTt7N3ie00hmDtaH+7JEspUVG2xWa2izffvlYZjd4rEiuFY6hwCdNGvwHckAifucmAttNHGi6uSLxsv3KkVKjyAQ5o5YjcjrNiyaJvQdGCHps5n2iPQJ8hjl/uaga0jru/q47BfQnuchyQO/NWaLlJRC2Fb8xprcNWEaWK32yz/QzshLkuG2tZ3hV/VHkX7q982CN5hEtrEWBkxa6unWXeZ5fnyG+jS+GA22gwoJokF/BxzrHQ2RADS+MffrhZ+q9hSz2cQ17KqvRUVnf/CUDcKEkZXtg
 nuw6z8zj
 jMTf6IAnHvpYusjM9xNuPX2m/SswxHjaw22QrReutRN7zEWtmy4w8IouMGS8D68VlhL3SIOtkIG1SDTGoQ4F5oseDwOz6qkrJqGRog7978PbU2PPDTFvI774B/vEODHQEUirY+zQVXppOYJKfY8YTk666Ca4vVZUoUJJfUX1bcnodxccyFzl6wW2obkT57JuNAqDXVM+0HCHDATFeAwLKGE8D5ztkd5FHSj4FnnIkJ21tVBuxJT3b5JcBaHwv8Os1oELa22yj29iG2Z9GIuYBNGhpqA==
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

