Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AC076C61DC4
	for <linux-mm@archiver.kernel.org>; Thu, 27 Aug 2026 16:40:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C68DE6B0095; Thu, 27 Aug 2026 12:40:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C192B6B0096; Thu, 27 Aug 2026 12:40:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B2FD76B00A2; Thu, 27 Aug 2026 12:40:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 8BA1F6B0095
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 12:40:27 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 1DBF41C0030
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 16:40:27 +0000 (UTC)
X-FDA: 85147612494.03.C4A743F
Received: from mta1.migadu.com (out-212.mta1.migadu.com [95.215.58.212])
	by imf30.hostedemail.com (Postfix) with ESMTP id 85A8E8000E
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 16:40:23 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=rE8JDmzy;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf30.hostedemail.com: domain of zenghui.yu@linux.dev designates 95.215.58.212 as permitted sender) smtp.mailfrom=zenghui.yu@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787848825;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=gJjIxhjd1cUO29Hx2OkFx9Nt+LZ8nqrvpRueSS0RCXM=;
	b=giFYF9sRNEIUFMCuH+bQ15jnHHLf5RBt6GnmoRgt+4MI/w79HfJnkEdjFpgbMt6FI2rgMQ
	VsgiEj+4ZCwQSyrMT6svVXLXIrr6ZTiej6LHxC+/1M+ZKn4gx4ew0l2G84ujt7clr2hgeC
	s00gkgxrWSQnuG+V57gxcf0mSixdEvc=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=rE8JDmzy;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf30.hostedemail.com: domain of zenghui.yu@linux.dev designates 95.215.58.212 as permitted sender) smtp.mailfrom=zenghui.yu@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787848825;
	b=02tyVmVYKsTKu5eSsjorrziesoHLV003aBiG1Rn6z2WygscSfK244RH3C8t35MGfsCc1+Z
	nEW8NI2xlFb3aST64B99a7jKu/reMHPwAvEiTXQiLHNRzgPAYlAuJz2JgOn8hE5KjHl1Rn
	+RcqkOo0UawAsXgJkSX0NTYmuAmWl1M=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=dAqjXOjzhNh5omqUcK6UrCGKxTg0RuYnBXOWEvx4Koo=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787848821; v=1; x=1788453621;
 b=rE8JDmzyKRZicmA6jqR7XjvmJseeZi+IftQ0YgvRRQvnFdeZNuzvtHihcKbpdA+fXF2v9Gv6
 qROut+tNUDH4y8QjZciNTiVtOcLvlg5tadjTyLmAZT707W4UXazyGe8FsEvmT1h1WBNvP53W9nk
 jrGdrP9vd7CUxwnh77OSqrEk=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id b5233e2837e3b3f5;
	Thu, 27 Aug 2026 16:40:09 +0000
X-Mizu-Trace-ID: b5233e2837e3b3f5
X-Migadu-Flow: FLOW_OUT
From: Zenghui Yu <zenghui.yu@linux.dev>
To: damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Cc: sj@kernel.org,
	akpm@linux-foundation.org,
	"Zenghui Yu (Huawei)" <zenghui.yu@linux.dev>
Subject: [PATCH] mm/damon/core: remove declaration of kdamond_fn()
Date: Fri, 28 Aug 2026 00:39:53 +0800
Message-ID: <20260827163953.83520-1-zenghui.yu@linux.dev>
X-Mailer: git-send-email 2.53.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 1pffww1rrnh5c6rdhqp96n5i1t9rxdri
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 85A8E8000E
X-Rspam-User: 
X-HE-Tag: 1787848823-701086
X-HE-Meta: U2FsdGVkX18S4IQNU8sQh2Nd/czAfNwGIysv1zvMKCxdPv54eb4UMEGW13styDslehveeB+wu3nkkvg9TQBZsZNb5XV/WcTrE/FRIvu/sjMD0d+SHlJw+WONAh7N5/ug9F6LG2YX7trOMX9jSQAC7bDtBnbiALjmuW4eUjf/elZuKCsxRs3Qj9hLJRU0o3lnQsgVr5TOfty0DzvxZpWNGiUG6bESi9uzPkbcUotwkIQvcVOq/Kgnpk/Lwb9m2FHtVpPqOQ0kJ8jvk2rg3wjwqCEDK/hO42XVsnRuuruXQAJz5NLOpInzIBkHHcCqYk3P6OqxmaiF+OGyZpPhqPDDbVsTVD5xQcrzK0xBoedKlaYW7Ey8EwmCgTY4G2k+bbTmSFcdCTsdBSQYclGn1gjx0kpCcpkW9vQm4bAQxLctkS0M3+aXdEaynnZWAkegQ2PPvdpQGv7i4gmsTpqGJ5VeDQea1Nb0u9DOCGavBM7zLYZbrwy8wUGOX+f2UiQHvar82nixP4Ft7S2KnUfG44al7RUbO61EoahEH7FVfwNm8fRCe/egAuXaACo0fMSPsATtoTXvPLC5yVMBeaZZNVz2Jkc5MvMYiFBWUtd+L03sRefFnd87cqu3mBPIfIPR4gyT/kB8r3nR2ylwy9e/wPqntmuk+6H2ZmWYp/+dJDQTuT8UdgbuAHmknjRP3Y2oHnWJv0aHcwAZn1f75+h2JQFMV56AiWxltVtlUZVz/bMLr4v0hPraegLWzneJF4KNFidBILlmtaVzLLGooN5ukdwfEW65r0nhDVKv/wEgxHZj0UP7nelphaiXECy6qU0yRTwPBVb8GjpXXJvYsf8pEoUepsxW05HRCsJyin/RjqAc0F1U+vy4Xv55d2hrcGd5jBv4tKIJjjprcrV8GLr+HA9NR2hdf+DQ48QoCZtTWM95A/ud5IVRMyoLe0gftTNNphbA1f7bg3jgFlpyH6Cq1Fe
 G154IFwP
 BUauAYwPtFkhcfVvmDeSvjQrHiPfbzGQoeY39shAGkYFfRrsBL/y8q6t/UTB6fZyoZ3FrmempKUtNBYYBIbfQj2w9FVUAxbg1zWMyn0j60j8rkqGjFdeYVo2VkT3Li0FpgqKbpI8rPTMhncFqTVOYMrN7Bl/UL2OAGqNNGazJikY7iaTFIqqFNJArzlC6BWhSLH0qIcj/l/FZqoCmAVTAK2WEmaaItrrrqJQiHG3jMvf1+BUWKNcz+mIRqIaOY7BA5ZcTaSVDec5ABgYr6LqcgG9xl9ux33fM1w6mRQrLOe+ZgjU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Zenghui Yu (Huawei)" <zenghui.yu@linux.dev>

It was added by commit 2224d8485492 ("mm: introduce Data Access MONitor
(DAMON)") but is actually not needed.  Remove it.

Signed-off-by: Zenghui Yu (Huawei) <zenghui.yu@linux.dev>
---
 mm/damon/core.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index 37d661e2bbc1..183080556404 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -1922,8 +1922,6 @@ static unsigned long damon_apply_min_nr_regions(struct damon_ctx *ctx)
 	return max_region_sz;
 }
 
-static int kdamond_fn(void *data);
-
 /*
  * __damon_start() - Starts monitoring with given context.
  * @ctx:	monitoring context
-- 
2.53.0


