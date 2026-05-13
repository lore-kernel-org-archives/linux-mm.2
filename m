Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AF276CD37AC
	for <linux-mm@archiver.kernel.org>; Wed, 13 May 2026 02:21:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 22A856B008C; Tue, 12 May 2026 22:21:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1DAF26B0092; Tue, 12 May 2026 22:21:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1182C6B0093; Tue, 12 May 2026 22:21:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 02A686B008C
	for <linux-mm@kvack.org>; Tue, 12 May 2026 22:21:43 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 8FC821607E0
	for <linux-mm@kvack.org>; Wed, 13 May 2026 02:21:42 +0000 (UTC)
X-FDA: 84760795644.14.6F8C360
Received: from out-180.mta0.migadu.com (out-180.mta0.migadu.com [91.218.175.180])
	by imf16.hostedemail.com (Postfix) with ESMTP id DF669180009
	for <linux-mm@kvack.org>; Wed, 13 May 2026 02:21:40 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=JHV+mvu6;
	spf=pass (imf16.hostedemail.com: domain of ye.liu@linux.dev designates 91.218.175.180 as permitted sender) smtp.mailfrom=ye.liu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778638901;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=I7u83GKnKUGOnUrGXw0W+nrtZL5sO6z6MsOIoWVl5DY=;
	b=MiRDiYNLM2wYC/7J9zZ0jrpWqUcwnzw9/uWQ1RbqNczXs2DIdhbic+GrFqWS2ex776c2Zq
	3whCDr7Rngsmzud+SJdfEe2SrDjSiRAlfsV/OzATWN8jxQ03ZsScuWxEaFC+OnUh2u0iCJ
	+xw/B5CjfCoMp7iaetPAsV5k7b9JX8g=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=JHV+mvu6;
	spf=pass (imf16.hostedemail.com: domain of ye.liu@linux.dev designates 91.218.175.180 as permitted sender) smtp.mailfrom=ye.liu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778638901; a=rsa-sha256;
	cv=none;
	b=eVc9ZxrUZGoL9t4VRHnDlj+DEs2t3bz68vXWUmI8MX9nSsmaZ38UHn/Uo60ont5WN4OcEX
	5zW+RcZmNoWl0HZhPcbAfq/gGlBhzJWLIKlS7HU8Ta0jljKWT67oNcamZ0kh3Js63c7+xX
	UXB8HSWoW7J6vWtkQe6hOIsR5x1MPGY=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1778638898;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=I7u83GKnKUGOnUrGXw0W+nrtZL5sO6z6MsOIoWVl5DY=;
	b=JHV+mvu6k0ZemGgYGRlIeWt0HO7fO21M3/FcMLEItPRrbJR2tLKpeMG2BEMPd9vQtzrxA2
	FvN0QI2kQhU7o8Gjcg4DmMNjQJy04jYwthQM7qwTzpiT7f3k6UQfQ7GIvnWhPZWR2/r3M1
	AnNLjeTlpqYgk71h6jhX2DaHgLOvVDk=
From: Ye Liu <ye.liu@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Ye Liu <liuye@kylinos.cn>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 2/3] tools/mm/page-types: Fix ternary operator precedence in sigbus handler
Date: Wed, 13 May 2026 10:21:17 +0800
Message-ID: <20260513022120.58033-3-ye.liu@linux.dev>
In-Reply-To: <20260513022120.58033-1-ye.liu@linux.dev>
References: <20260513022120.58033-1-ye.liu@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: DF669180009
X-Rspam-User: 
X-Stat-Signature: 7op37njtu4rcogir5853eqyqooxobds5
X-HE-Tag: 1778638900-944180
X-HE-Meta: U2FsdGVkX19GvY9Njt2mHrL07X9iae99yQm9nI+vomAOSN0f5C56dBKzMDyO22y1NMuMfasL0k260egahfP7025j3MkXRwVk49aXmdftRJ6Rdj1EMeO4mJQidfFc3Am4uW6nbhFn/3DgmQ3sLF0e0EU6seufy/3sWA9XNHAAGlyNG35QX+hjOWp0wfW5YweJD1HXzwY2tYCZHQmHj9O/Nr4iguJn3uwv3Mc9eDk4NbilIcbjbsPZeZ6bhLQOetflUeiRkpQx6FVp8IQDyNftKphh/e+/IO5yiSKWJQJthem2itPambJNeY2soZhHcQzWL+qbKCUu+RJgdYU1URK5eA8kOUjH8n8ZQ11Q+sKu2sMxuUiCIBAB0ivQCAmH64jXoN5IKQOGmUvvkioyx80WwTDMGT3WMKG/0g92VGzDGooQMbMMyWy9ZqjFVft4SK2W7wEAaMMH4FKN5Mn84r/RCRAieGWfHfhDnUROKjgKv2MyPmO7eM1XblAzYlm9Ir5Zbzni7hhOBsCsd5M3a0Cre4x5oX7bp1czDRaXtt0ut1MQURjnb6xljiDLCN6iY4s1PECpdzyYeML2ZiaAEgRLecIxcqxD82McCGAcLmA8XGLtMESL69eZ9fVTcnUTIFDwfn4OsHAz+49w7wa3veS4a98fBC7/75aEFMm1fG4uhM4VQOnMLxYZKLzhQf38kzx4ojF6DwzeA5Hi8bnEDJFW35YTuV2xLEbYNN1eiVLz+Bw4i62gLLxsGyrJuHlw/dluzR0gRbTS5YrFGMvs5c1uUUjyRmVDYAjfBNQIBy+SZxqiJbDxYpjdihRINqAyCpXLBiPRo+qNZuDgh00iHHVZHsPVYWiMrS94XQlMdGRQHFP5cdXpWMSA/5tnEDp799PdkyIsODQW2USrSH5wDdUEmuBtKHdT/HiCxSmFOCE6zgy3DjI8N9HbQmuES/XU6tROfI1Gez+Oxn+g+hkO5PR
 93o6QSGp
 EXw8hublvC1ZCODjKzmzM9WC77+GvD5N/cClHIjj1kSp0uqqOkhl+cASRnzhlhRmCZMN9RKIR77nfoQQkkPGth35Zf1qqWWzNLfUzrndrbnDwNWjtfkvbBbGRB5EvxfiwVLXC/dAgRG72sI8gZyYd46n8ts1QVc9MtTDI1GgsS3OZY2Zy4Wh4S2NO3Q+SO+4Jittn
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Ye Liu <liuye@kylinos.cn>

The ternary operator (?:) has lower precedence than addition (+), so
the expression `off + sigbus_addr ? sigbus_addr - ptr : 0` was parsed
as `(off + sigbus_addr) ? (sigbus_addr - ptr) : 0` rather than the
intended `off + (sigbus_addr ? sigbus_addr - ptr : 0)`. Add explicit
parentheses to ensure the correct evaluation order.

Signed-off-by: Ye Liu <liuye@kylinos.cn>
---
 tools/mm/page-types.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/mm/page-types.c b/tools/mm/page-types.c
index 6594245217a8..66f429f2b698 100644
--- a/tools/mm/page-types.c
+++ b/tools/mm/page-types.c
@@ -1000,7 +1000,7 @@ static void walk_file_range(const char *name, int fd,
 			fatal("madvise failed: %s", name);
 
 		if (sigsetjmp(sigbus_jmp, 1)) {
-			end = off + sigbus_addr ? sigbus_addr - ptr : 0;
+			end = off + (sigbus_addr ? sigbus_addr - ptr : 0);
 			fprintf(stderr, "got sigbus at offset %lld: %s\n",
 					(long long)end, name);
 			goto got_sigbus;
-- 
2.43.0


