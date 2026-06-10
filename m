Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 376C1CD98C7
	for <linux-mm@archiver.kernel.org>; Wed, 10 Jun 2026 01:14:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 79A4F6B00B4; Tue,  9 Jun 2026 21:14:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7234A6B00B7; Tue,  9 Jun 2026 21:14:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5762F6B00B8; Tue,  9 Jun 2026 21:14:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 323AA6B00B7
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 21:14:33 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id EE05816509D
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 01:14:32 +0000 (UTC)
X-FDA: 84862232784.16.D4CAF19
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id 5250E40002
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 01:14:31 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=OO6bucwx;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781054071;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wvTmgzWVeo+cgK/5Fasuy9LNL6Vq1lM40f7iFKommVk=;
	b=NHgySE0TfI9+vGM2QduRvInDHw21WvQVZIFjGoBDWuM4SI8TW/qioroL97sSAyF1M9LM5Y
	RzzHsxC4ZevB//FfAWQn4Py0K9Vz1oKQ559/W+CwNECGplivKxxEZsNiNHcCUNWtAbA40L
	R5TibVmoNA7vsi6GqjeCXrBGRHwVG84=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=OO6bucwx;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781054071;
	b=F1eff7LtJ2c5hN2uoW3xplpFoP+dnG7tPBxx40bYfQdlnDpUjfM7sFM4ALLx94ZpBBG902
	b8HiKUqbFfI1PSnojKrTEFApBGBsx4ie/AXaUhrlb5fCNOgMnREZOnJbauFtI8Jo4T6s5a
	ikFToDmfmutq6y7oq06rd8tyQPVIoNc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id A760E444D9;
	Wed, 10 Jun 2026 01:14:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5DE111F00898;
	Wed, 10 Jun 2026 01:14:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781054070;
	bh=wvTmgzWVeo+cgK/5Fasuy9LNL6Vq1lM40f7iFKommVk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OO6bucwx7vW5YEMf9brXc184EBcBckfFxzpfLJAKindDpNCCAwVjQ5kCkNUKTngNT
	 NYxpjaSP1wymrtUvspJt+VwOlKLkkwDHT/plNs6NdxModjlMUBqYw2oLgNmWI2wN/i
	 /9xxWMxiTCvyFRyco5xuNRQdpEpcWCPLvyIBbOO7KwEEE9OJbMcT/slewHi3pW3gzp
	 x9PiEr42PNnPLaQDesMQGjajOY4DkPEYqGwp4lOk+aFqdZhLVI1kZePVCwIAoRhQR3
	 qeLMcTkcOQCN2BulCCYNgKxweIxiDiwqjzzTMtEM9+IynkbPMr7BPLsiezp/SDapfY
	 9LqourOYK8NdQ==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	"# 6 . 16 . x" <stable@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v3 4/4] samples/damon/mtier: handle damon_stop() failure
Date: Tue,  9 Jun 2026 18:14:17 -0700
Message-ID: <20260610011420.3018-5-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260610011420.3018-1-sj@kernel.org>
References: <20260610011420.3018-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 5250E40002
X-Stat-Signature: urr9uiq4s6wox1jqtc4894gt5bqzp4u4
X-HE-Tag: 1781054071-170152
X-HE-Meta: U2FsdGVkX18WyjKjAvmDhNO77nvr3ZsTb29VzyqT+A+a7VyJvagisxNVn49OXEd+4z1PRWAwO3qJSwJMIRR0L7E1lF8C0T5MJ0SBPwyWKKqwh+jDRbMpQv1PreZzybZP6qa9mHnr81KNDYedKSTZu6nMYlhHQa30epYZhjqHwCyteVWcXUWA9Tqvvnnz7SPCIt1bqIYFmR29So5h0FVXAFGvhCRq63vioTNocFXMiwNuQpGi9UGYHK1dutRLthrDVY2ZXIaK/VCy/m/MMvKzsrh3/Q8KKOCna3dkLJFLNiwFon6EfB/DEwOv4puldq+NnxBkP0g8RAbdTb+I6XwmJW3/qXn/O0DK28EIcT0MTdSbxFqAXEysnjD/dvJq3mNd/GOsd8vfKxXJYz3JXGeHaEixHdnqXM5Z06oBeNpzqXgbOjkD88mYr5G0YA8PZXE1Z8AvyyR6QFmVrf5iuT+fkh1419wc895M4Yv4eMhEDxNXtOQsZs2mfhH4bswKfixtsnDwaH/5OUZ3sRlJa4DNhsffrOEW1bF+Eg6Stv3R9AwefcWv/ueUl5m27JTfaCt1uZ88FZgnryEzoSwzWtaBH+fUidbVvqeBrkH+SRob8SR41pRtb8kexuDYsf7MZ5aqojQKtktb8TNtid1E/FY5sRAn/pljxCJxLXELggFsgsLFA27V6ayDhFgRK6IK0NeIjVrxKwt0NoA0vBXR751yW7tLlbBqGEMmX7Sx+e7mZi7MXsbw9TA7G6xSjC01GXR/1GVdZdsJ9+euos+9f4AcRYxQVRk8s7uk1dMVYDZJg8K4qg0y1I6V9RJC/xzSoG8rZDOWnKO4c8z/QpNuAjaVtTKuPHcVx7ze1RH2PJwtPXqyJf1X/0tq/H1SDmHiKPjNUKmmtezAAtC86C8EqigN5ThEZVVPoeDHAfI6fWqw9Ilf0rHoFT7tr/4VZa1NnS7DXoLE6A6Ivb0okvc7Hky
 6NS3u4QS
 oBfngm/KAdEr2hqerEwwfTvhrg18rZ3KMo3YwpIftt2UyaTDwJy+9cqd9OrMEhb9qxseLLVt2nYpsIoKpDhCdU1bA7qjKv/Gnh8kp11pEhujIcdz6vz5oGMUuZ4jnp9B71n1x6wBeoBKwKrqMiQ0O9CuXVVE5UO7xEn5LoOrcVVGU5cPwhvzNsbZuC8ywCRPQfgDQ65Ack6ku0q9cdzUZfg/xFBk0gLqH50fBQHYPDnQYkRHCIxM3Cmc65uM1G6Z5TLdB3V7aI8kxaxhlokemSRfuAQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

damon_sample_mtier_stop() assumes its damon_stop() call will always
successfully stops the two DAMON contexts.  Hence it deallocates the two
DAMON contexts after the damon_stop() call.  However, if a given context
is already stopped, damon_stop() fails and returns an error while
letting the DAMON contexts that have not yet stopped keep running.  This
kind of unexpected early DAMON context stops could happen due to memory
allocation failures in kdamond_fn().  Because damon_sample_mtier_stop()
just deallocates all DAMON contexts with damon_target and damon_region
objects that are linked to the contexts, the execution of the unstopped
DAMON context (kdamond) ends up using the memory that freed
(use-after-free).  Fix the issue by separating the damon_stop() to be
invoked per context.

Note that DAMON_SYSFS also allows multiple DAMON contexts execution.
But, it calls damon_stop() for each context one by one.  Hence this
issue is only in mtier.

For the long term, it would be better to refactor damon_stop() to always
ensure stopping all contexts regardless of the failures in the middle.
Make this fix in the current way, though, to keep it simple and easy to
backport.  I will do the refactoring later.

The issue was discovered [1] by Sashiko.

[1] https://lore.kernel.org/20260609014219.3013-1-sj@kernel.org

Fixes: 82a08bde3cf7 ("samples/damon: implement a DAMON module for memory tiering")
Cc: <stable@vger.kernel.org> # 6.16.x
Signed-off-by: SeongJae Park <sj@kernel.org>
---
 samples/damon/mtier.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/samples/damon/mtier.c b/samples/damon/mtier.c
index 66b591f2180fa..faaaaa12e6206 100644
--- a/samples/damon/mtier.c
+++ b/samples/damon/mtier.c
@@ -199,7 +199,8 @@ static int damon_sample_mtier_start(void)
 
 static void damon_sample_mtier_stop(void)
 {
-	damon_stop(ctxs, 2);
+	damon_stop(ctxs, 1);
+	damon_stop(&ctxs[1], 1);
 	damon_destroy_ctx(ctxs[0]);
 	damon_destroy_ctx(ctxs[1]);
 }
-- 
2.47.3

