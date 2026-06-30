Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 33836C43458
	for <linux-mm@archiver.kernel.org>; Tue, 30 Jun 2026 04:09:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7CCB96B00B9; Tue, 30 Jun 2026 00:08:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 707B86B00BA; Tue, 30 Jun 2026 00:08:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5A7BA6B00BB; Tue, 30 Jun 2026 00:08:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 152306B00B7
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 00:08:34 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 6CDD98D2BD
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 04:08:33 +0000 (UTC)
X-FDA: 84935247306.27.A3792AB
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id E2012C0003
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 04:08:31 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="JyyUENg/";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782792512;
	b=0paO9xSWSNwsF7UJDF00nB7/7tD3nXh4KkWXL1hR/NpeAtMrq2Y9GT2cGL/di4FdmpEV+x
	ECj+uFcJ84iig/Edl4ZvSf9OOP25+1ZoT8PIUwy7+VvNUpU37fgb4oc+qqO8BvZE0EzzKx
	4oW/UBulqAL3SpqCzj0hhiFT4GLoMT4=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782792511;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=REsPlW5rz/ejlgovHVfV3cC0b+76O7l13CD/hxOvCFA=;
	b=V95N4b4PlMZCdP0s/Kf5utfc20CG/uuXY0pp/zBdKRFE3UtkCl9RDUwm//xYrBlgdiGgfX
	IxKUOaY3VsPO8f1AqUIii/+kD/4qrfHE3MM08oHSgLEzqf9XMR5s3dTRsqlAq2Wc77Vat5
	jDcKG86hSA4kLLMxXHNJ4/hKyHhYvUA=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="JyyUENg/";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id F423143CD2;
	Tue, 30 Jun 2026 04:08:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB9831F000E9;
	Tue, 30 Jun 2026 04:08:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782792510;
	bh=REsPlW5rz/ejlgovHVfV3cC0b+76O7l13CD/hxOvCFA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JyyUENg/cAqjSWQn4bv0oGWIwmqm8pgtqaZyga9Jvka1KwCzhMmeAZsKfg2bVxj2T
	 +YX4Ylc/1q5e2v46hikoith015fy3WE7EqmvQqAXZWqTp2e3Hh2zbFjQPoy0H3XBQ1
	 kMmWGgp2+hohBZi/2P7NIKAW2iO4Yow8zy11nMdyAUNjOY1Lu43zg0En+lVRthT60f
	 nSpzXPmmxKhu1fkdRYaJLtZeM+q2CNezNC32G9f8b5QMawZie8mYYXQeKC6Wfvpeat
	 WJDrmp706pp7u1OlIkbtPXuN3UY9q8b/V5A++W0rbFgNJnrldm2W3dmc3t0j0nFDsX
	 ci9AruMdQT8ag==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SJ Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 15/18] mm/damon/paddr: remove attrs param from __damon_pa_check_access()
Date: Mon, 29 Jun 2026 21:08:08 -0700
Message-ID: <20260630040812.149729-16-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260630040812.149729-1-sj@kernel.org>
References: <20260630040812.149729-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: E2012C0003
X-Stat-Signature: jouq6ur7rnz1d91nocw4yy4uzehbe71i
X-HE-Tag: 1782792511-531298
X-HE-Meta: U2FsdGVkX18jXRuoQ5NpVyAdTDqsFdCYHHYVk5J3n2CHTfXn6TDk2819puahkGVaYNPTno+TJ/a78mrAiY6m+ZMs7RL76HxiNAf4NyFC+IfOiP5i6CtFsYzG+fSBIhSnSV2LIHCjmN4+5MBIPSQDxkLnvvf6aNeFxbonpdcB87cVSpgFPKeenNeC25VCKZW7dEkV8oD8ZXr3qdlowjNEp+OUeo36v6tGIUoe1/AugKo6/GF+un6YGB43AT98RFCBmASq4I7YQg8eV48K30QpxS4/fUBbLFs7T9xopzTj3vt6fmCOApDOIrofQDDIaFarBwxjfPpAN9Ep6EDk47NJ5msE5uDseuOFzFYZNjbg3SsCbV+fKunTo+3Wen+G8joqlCJEgmW5TRvun8GWUBmPe965FUril/O9w/C7GA722xc011Ppxu7+R+LooM7wHb+nN56+U4QSZE4gKiTlLQ3wVeEypY/qzT/2BnM74oekquRX15vMbrQJJaO4W5d4pgZofo9Snczi60Oh9GUtEL1UegoPT5GOHi0r2EAwj8AeeFE0FoEFKHPSSr/IadcEDLBZN5n2PrO0C45n1DUYQvvvSXDgIJSdPSANcFaJ0r5M9ckDJzVH/2FPpGw/XJ6Q9k02CwPlM7I4SvJcQRsZIUV7hd6imMJy3AbmFkQ30QLzACGlvHVSmHfV9xo4fewLequIQ6YGF9dWKT/ZxsbZPNCRq31D8macepcXMS5UJNkiR7EQqWQu/1VbgEVw2vZNt83V2ClkUHSdKbp4fblekarcpAsPG05YBDf1XTQXBEQL6ZqJAljlTYaY57UBeOUJ7QAUG9huDIcWoyvSnRkQqbN4XawlzHB6PFK9W70K9UKcIsUploVRWmrGwq//MPdbEHN43m6HImHgLnSi0Qk1d61e/9kGcCFPl/j+ebqJg4y9jS7UqPwGmbjieDlsIoKQk/BOptQ8eBikQXt6zNXhdSL
 imoC3Y4q
 NW7uQN+3KJT6Vr4OgCKZs3YRjEg2elIMW9cEG6ZfSOmoPtftUTNj10tOozk3ch4oxusFlqqoBhNMVySZRxNNDwhpFYJcazbYqdpobEs+vfj+/UoFEpGHYLwo4PVulroFLw2HFCrCOXCyua6mAY5deZKcxdIBJvvMsWnE0BdbYC4mI9xynT4q8/FbUrPVUMBRHQ6zE0ySyruODtTRifnsLQHGRsWnTCS3HwKR+P8kAyJgFvP8e7he8Ll+lbqeefGIPU4Hf7Ljah/RlIL7kXsf8BfyXbA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The function is not using the parameter.  Remove it.

Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/paddr.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/mm/damon/paddr.c b/mm/damon/paddr.c
index 8530213086691..6172464981730 100644
--- a/mm/damon/paddr.c
+++ b/mm/damon/paddr.c
@@ -80,7 +80,7 @@ static bool damon_pa_young(phys_addr_t paddr, unsigned long *folio_sz)
 }
 
 static void __damon_pa_check_access(struct damon_region *r,
-		struct damon_attrs *attrs, unsigned long addr_unit)
+		unsigned long addr_unit)
 {
 	static phys_addr_t last_addr;
 	static unsigned long last_folio_sz = PAGE_SIZE;
@@ -109,8 +109,7 @@ static unsigned int damon_pa_check_accesses(struct damon_ctx *ctx)
 
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

