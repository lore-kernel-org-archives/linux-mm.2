Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 109ECC61DFD
	for <linux-mm@archiver.kernel.org>; Wed,  2 Sep 2026 05:48:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E9A586B009B; Wed,  2 Sep 2026 01:47:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E74CF6B009D; Wed,  2 Sep 2026 01:47:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DB0516B009E; Wed,  2 Sep 2026 01:47:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B8B886B009D
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 01:47:59 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 4CA5D1C23F5
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 05:47:59 +0000 (UTC)
X-FDA: 85167741078.18.ABF72A2
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf08.hostedemail.com (Postfix) with ESMTP id B8549160006
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 05:47:57 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="g/bSpy1o";
	spf=pass (imf08.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788328077;
	b=jxQuaMHwqI1xaFvANu1oMn+WbkMQc6BN5ou1ehKpq1dPINV2DIHh6/oQwHkIEho1uG40Y2
	4uE/Gz66NM/uFuQ5fpcMquNanfS3LFN1W09bhx1cuMX2NUd/dDIlUmNl3SKOmUOmUlYTFm
	h0GvavfG8/yxP2/FkpX6/D5QnabJrxc=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="g/bSpy1o";
	spf=pass (imf08.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788328077;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KmA3XIkDsEGWw9Q0yqvFSyXfLgWn5kQtFO0BvVaBzPA=;
	b=TMk3d51TqehCsgQm9JJh1LRu6m81KYvRc4D1iwc8lEP9yGNg/h4L7GrlcQcCQWXjeTYpRk
	KSx/H2tybbMycahLSLjCGhmu44L0KCNNLE6Q+azK9uM7iYy/KLsDOTuzTOquQn6ZyAdZFM
	O1KQ+EQESW212CaM7h+AB5lJfY2GvVc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 596E06022C;
	Wed,  2 Sep 2026 05:47:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC6491F00A3A;
	Wed,  2 Sep 2026 05:47:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788328077;
	bh=KmA3XIkDsEGWw9Q0yqvFSyXfLgWn5kQtFO0BvVaBzPA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=g/bSpy1oP6r9W1m5m4QtCcakQBc2X9gSn8wCas9R2qnb8rZfo0TiEGsjmLT0SsUz1
	 Y5JhKg7MqDK+IPWptQ+GXfm7P2YCBQxEutJhb89J0+QettPXBWEAe8ICmMz/2D6ROw
	 mCIQ/WW8hq3EPMKg7LrOqwLvcs86GZQu72nmLWV7sXxCr3I6g2t7caVI94oheqG5hi
	 kcx3PpznSKVhwaBpYSpy/Ky35l7a1/yny/YvbvjDcxd1S+j1OqEe8gcmrEfBPPWROw
	 dgViNOVYb1iI4882eDw2Q6RF53sfLGTEMOdhApqlbbWYFhfdTd5u0eX16kTTDAivu4
	 OPTlUF0FemY4Q==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SJ Park <sj@kernel.org>,
	Brendan Higgins <brendan.higgins@linux.dev>,
	David Gow <davidgow@davidgow.net>,
	damon@lists.linux.dev,
	kunit-dev@googlegroups.com,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 07/12] mm/damon/tests/core-kunit: test <=0 size damon_set_regions() inputs
Date: Tue,  1 Sep 2026 22:47:40 -0700
Message-ID: <20260902054747.99370-8-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260902054747.99370-1-sj@kernel.org>
References: <20260902054747.99370-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: B8549160006
X-Stat-Signature: p4k7e4bco45n47ox3fddm4y6na5wyy7o
X-HE-Tag: 1788328077-859598
X-HE-Meta: U2FsdGVkX1/SH65Da1rDIAGK/3Z94KCBcT1stn4ZzmBUHsPRGal0T0juAj6TLLTb6Sw9fdCvVMbrQRDt9C8aE3KGrbPgWqPJe1y0qQ9hJ1Nhgn+O7iS00Jj4+sGtysq4s7pfEnBpDBH6hoiyPwuPCxbVHE+41VbM3r4uRxBn+TPNXlT24oTuUUqEEk2yy+Tzrt9ibOamQjfQeuwtO9UXuMZNV7BILDCkm73Kl/E6j5sl7aoOCAS4KEmQdvJsZR0am0URZ0KZJ6TbvLjcWKZBTJFNkISzcFYSEnVmvOd9+uUvyFwY+aFNj8XbeUc4Em64kZsxe8iC5mxAEhnAJ11LXyZElM8Y638yCittPP+PmeTsxteQUIZYNxJ9jHdyjGY5F8k7bzFim+L5csAL7gg5z44OmCdI/bHLwGWgG7k4ZVD8t3kNfjRTnJ+/H1kbdemNrpQhGsjrCdDQ8Ir6mtoq0VOG1Jqm3sg6dPypcdAAJ2DZVjZ068aJ+RdUqwaVxRzorxWFteC8YcLQ2xAEXL93IRuW7Qg1+aD2DAa+aipJWkZhBej+yucTafP9CD6RgGdT3SLq60NUBeZdtuIi6bXsrBxlWper1+Yivxjh4yl+QrJSm28FFI8aehQ/Zy200GW9SXhRxj23PEMVHOIn/iedrx875WdaTZwScYg5uJHDWw6/4j4c9q7OrTdWIJ2tHkWzNDW0xupnVbZmVhHBtpEmdPJJ2OJSQNpqACbbfzoD8KRUnjD48bNpNwFv0aZHape3/4lR7j3Eq5P8wYd4KIY6UKd/NS7TMWG4YEfEXdfNx2Y2K72au94stcriEayQ4UwUxgOTmkGGz+o4PyMKNulEDnaYTXUqi+krZInhBQjOuo9c25l56XE7x3UNftOb3a2wnCLwo8jsQ7zb84JE0qaktAsufy17fcdoLO1XMnFXPIFocZemyX9s7Hzft77BN256GdvWCHUzLWVVRYqsnqv
 FBocrClC
 a3YNo+YZ5WViHgPs7BXUM4BZTZ2HO/Ci36COyZjS06mvBk9CX5dMLawHbdvvN1uiTB/LF3Gdl4pLJD7S/xggpbnERyy+Lzvd9AHwKOstYYBdc8Vf8eRJUGOclFMOUnxsHeMeakYTj5cTYZ9QQjPg4Ei64d3K5FzH/J1ZqnpU4a6OEngIDg5XhJBzziSIO/DIknvR+1jGZGKSet2aBh2sAsI1P3Nx1FFr5/jiQXKV+Lx/oCReKusQ803YRBl19Oc/03xsGHwWh6sKcShlamkDULxUT9Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Commit 1292c0ecb1ca ("mm/damon/core: validate ranges in
damon_set_regions()") disallowed passing zero or negative size input
ranges to damon_set_regions().  Add kunit test cases for those inputs.

Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/tests/core-kunit.h | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/mm/damon/tests/core-kunit.h b/mm/damon/tests/core-kunit.h
index 2bcf3bafe2e29..3cbbbcbfbef8f 100644
--- a/mm/damon/tests/core-kunit.h
+++ b/mm/damon/tests/core-kunit.h
@@ -598,6 +598,20 @@ static void damon_test_set_regions(struct kunit *test)
 			{.start = 25, .end = 40},
 			{.start = 44, .end = 50},
 			}, 3, 0);
+	/* Zero size regions should return -EINVAL. */
+	damon_test_set_regions_for(test,
+			(struct damon_addr_range[]){}, 0,
+			(struct damon_addr_range[]){
+			{.start = 42, .end = 42},
+			}, 1, 1,
+			(struct damon_addr_range[]){}, 0, -EINVAL);
+	/* Negative size regions should return -EINVAL. */
+	damon_test_set_regions_for(test,
+			(struct damon_addr_range[]){}, 0,
+			(struct damon_addr_range[]){
+			{.start = 42, .end = 21},
+			}, 1, 1,
+			(struct damon_addr_range[]){}, 0, -EINVAL);
 }
 
 static void damon_test_update_monitoring_result(struct kunit *test)
-- 
2.47.3

