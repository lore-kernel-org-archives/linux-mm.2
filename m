Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3A18BCCFA03
	for <linux-mm@archiver.kernel.org>; Sat,  1 Nov 2025 18:20:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E33258E000A; Sat,  1 Nov 2025 14:20:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DC2E08E000F; Sat,  1 Nov 2025 14:20:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B2AE78E000A; Sat,  1 Nov 2025 14:20:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 994108E000B
	for <linux-mm@kvack.org>; Sat,  1 Nov 2025 14:20:42 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 5F89312BBB1
	for <linux-mm@kvack.org>; Sat,  1 Nov 2025 18:20:42 +0000 (UTC)
X-FDA: 84062853924.09.E04D076
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id E12D7C000B
	for <linux-mm@kvack.org>; Sat,  1 Nov 2025 18:20:40 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=kVlar5I+;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762021241;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YnQdUkYVhxW7vExCjfUGPP/y4AIf4JvwahT8D2RGfMI=;
	b=J6zPaLItDYwxWjtPJuJSTpzkoU4IRhor7swDf03yTYAjonPNuqp3f3uq6/p1jRuguAcfCH
	KUykBKtN45Wg6tfYL9RdMvhkIvXkpvR0XVQiQ1KbcMlLgK17v7ObflNEgHtiuChvFBA/FV
	Rf9Qof/7S75XKT1cem0DM2s3ouUlSDI=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=kVlar5I+;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762021241; a=rsa-sha256;
	cv=none;
	b=gR7CAQ2dsF3ztXgu6edNu6iPI1QRUHfjfHx+AS86d6HWzY+1/UQKiZIdOiLxDgaJxZrv7v
	Zwkul+Uc3HcCPTNmLq/uQdhmUcngJUUAWl9THepCjC/SBZKrIoRt8pTw+2WZbkwObiQyX3
	lNGMLgNnyVpZDPg5GRG7CdRmKD/GGHg=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id AA33E44090;
	Sat,  1 Nov 2025 18:20:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61AC2C19424;
	Sat,  1 Nov 2025 18:20:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762021239;
	bh=oHkIjcA8qu06VIriuctGm/Bl5usqrU/VIxGOhoxmkJo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kVlar5I+77xLhdhlMqli0zqKISxDQR3PpChs2MikS2WxH/2uyinmBsbauj612EoNj
	 C8OL+5Xy/Cxfqhusr8xL7TjP+9PSq3bTiYIwRF+k/+ffUroFfgo2kCLqr83007Uf81
	 6z8/swOvObW2pChaUmpj+/JwA9YLy97/EeyBMw0H8UH4MrrfVKX3z1mduQ+47OBuTX
	 QbTHYq6Fk3O39yYp0+879I5R4zEB6n5rMTlzK/BkFOEXRfCh3W6BsZFHRSMSjffyXA
	 KtdQiGk+SQ673mbnyPMruQ0jUBC1AtNdG89NwgiODKTbylUasjPnZ8nEtzrGkJu87S
	 0grc33RzWwU4Q==
From: SeongJae Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SeongJae Park <sj@kernel.org>,
	"# 6 . 3 . x" <stable@vger.kernel.org>,
	Brendan Higgins <brendan.higgins@linux.dev>,
	David Gow <davidgow@google.com>,
	damon@lists.linux.dev,
	kunit-dev@googlegroups.com,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 11/22] mm/damon/tests/core-kunit: handle alloc failures in damon_test_update_monitoring_result()
Date: Sat,  1 Nov 2025 11:20:05 -0700
Message-ID: <20251101182021.74868-12-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251101182021.74868-1-sj@kernel.org>
References: <20251101182021.74868-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: E12D7C000B
X-Rspamd-Server: rspam03
X-Stat-Signature: rg7aj81rajxj9fzi85qf31y9yhhnrpjf
X-HE-Tag: 1762021240-20501
X-HE-Meta: U2FsdGVkX18PhVsjDp6EKDLXx1Zo172osYp50qUW5LZi40xIykI7C0xM74btAKDRHMB5XtD3hDZnnedQFLi55S+i6pRjG/E6zlklqr0m/1RmNqjkPtQgX3njF/obTnxEPvr2cT55P2P2Il+A6QmF0W0mhPB9vH2pBul953+uvxcZRjfQTwl3GcChUvPb8HzlMz4Z8Me7ENZLkidlqaUPfQr/8X3s/llsZB105I8jFJ1evcyTk0TsHicEFc8Yiv0QNhPTiMIShrgFpszgRHZ3ovVTuppzVxtDplzfk+9w7KKSwgh5G4Trb8iA3+RyxbMexUJzZLYG+A8srVLCROtd/0S5/bkahbIAuxdcrohEocfcwx9sK6uezTkmdnprEVOUuWlwu8gP9O2+pOu/1sbnyH/vNA6vIafGIlP15mM8AG8ekfV3wscI9dPBVyG0zJ0Yof5msWT9/DpeM8/n7NStkI68Cf0ZLgtst+n+V/IdQ5OgMaCqHBi5W9n0oZUFkFZDRk5NBAptBqPxL4HitZUpcJ1WA6nLZW9JhtXCRSm4WOUfQgpj8srjFEDwIUmV/Gu9KD3I3CEr8Y/O3Au2c4GC3Pe8EsAk/8gh/s9j3lKJA7xFIzYsMM8sanTcy84LOalTO15za3ZX0DTLIsCgY/meq7fGyRXYwFfAzcw53XlSai20GeXJoN9CH+mG5318nUOGs94VgWpQ1ZkPfnZkDRz+55EqRXHhdLr98RODjrp7ucnZT6CoQgxyn1rF4y1vYPVaXTAsBra849aaIrCQQs1nGlDAM3yBFhP/wUH9EYnQOjEwxRgung+jlnVFv0UON9Rw/AumVgLeXMcNxX2+BNrR4jXUb0DNi8VnYEFLziwN+bPfEGJTBujXy5pwuCBugd4aJT78M4HuIozi1I0JxxPkaqLDIrj75GeUoAdbUSBMoCpFwOaKte+JbbVZwgBNDT2U+bgC0YqCA52DWPNcS4G
 QhhtEUvS
 lprrhNur2CXai150=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

damon_test_update_monitoring_result() is assuming all dynamic memory
allocation in it will succeed.  Those are indeed likely in the real use
cases since those allocations are too small to fail, but theoretically
those could fail.  In the case, inappropriate memory access can happen.
Fix it by appropriately cleanup pre-allocated memory and skip the
execution of the remaining tests in the failure cases.

Fixes: f4c978b6594b ("mm/damon/core-test: add a test for damon_update_monitoring_results()")
Cc: <stable@vger.kernel.org> # 6.3.x
Signed-off-by: SeongJae Park <sj@kernel.org>
---
 mm/damon/tests/core-kunit.h | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/mm/damon/tests/core-kunit.h b/mm/damon/tests/core-kunit.h
index e38c95f86a68..10c9953581ee 100644
--- a/mm/damon/tests/core-kunit.h
+++ b/mm/damon/tests/core-kunit.h
@@ -429,6 +429,9 @@ static void damon_test_update_monitoring_result(struct kunit *test)
 	struct damon_attrs new_attrs;
 	struct damon_region *r = damon_new_region(3, 7);
 
+	if (!r)
+		kunit_skip(test, "region alloc fail");
+
 	r->nr_accesses = 15;
 	r->nr_accesses_bp = 150000;
 	r->age = 20;
-- 
2.47.3

