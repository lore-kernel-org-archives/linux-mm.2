Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 10A45CCFA03
	for <linux-mm@archiver.kernel.org>; Sat,  1 Nov 2025 18:20:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 38A6B8E0006; Sat,  1 Nov 2025 14:20:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3132F8E000A; Sat,  1 Nov 2025 14:20:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 203DF8E0006; Sat,  1 Nov 2025 14:20:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 0A11C8E000A
	for <linux-mm@kvack.org>; Sat,  1 Nov 2025 14:20:41 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id CC12D4A77D
	for <linux-mm@kvack.org>; Sat,  1 Nov 2025 18:20:40 +0000 (UTC)
X-FDA: 84062853840.11.37C8294
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf29.hostedemail.com (Postfix) with ESMTP id 3F22D120005
	for <linux-mm@kvack.org>; Sat,  1 Nov 2025 18:20:39 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=lnytKmMm;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762021239;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8P8XNrTTH8QlKDN6k7DCg492XY12rCEVxPm3PAgZC5c=;
	b=J6xtFHnxkg76R/kBQgHxfPHL1qZrWSpmSrKEi+QJBb+/H+9BvBchuM96GqixOZXwG3th0J
	y6Ij78keFEW3YUBq+csJTgamoE3CqwP2yTi1OGORruHb4f+7R5OoSxKCrzFPIuC09OirGd
	KZBXvL3Mgfx6creJXc5uSFJhghnG8eY=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=lnytKmMm;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762021239; a=rsa-sha256;
	cv=none;
	b=wzk5t7DKgEWvhrQtT0z1qL7YygGFJqZeSSpcNmYh0fuUGsQRo+/QFucJX9GY4P70ANZGgt
	o61Z7dVsn75SyFKVkIPoyRhwyG5CC6rHcS2tiAySb78OPpcVwZEesmwR6P348UIr1mzwRW
	kZ+FR4LJmrv3Xh5RRUH8/BGYLRrdoNE=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 63C08442D8;
	Sat,  1 Nov 2025 18:20:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D2FCC4CEF1;
	Sat,  1 Nov 2025 18:20:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762021238;
	bh=N0sjlEOjAoI+Rw+maQxTDR5r9ce2wPbMV20M9TtSgUo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lnytKmMmhwH7ctE3pW95SaD8GKebhnNqUSr+FWjzJEvCgLZooM6anHIe2iE2OmJ0b
	 ZYGxHaWCOZHC8K/p0IOyOAyJV/Gazga2XGl3QWnCSTKFxUXCOdKi2GjVwbckAaCxDb
	 /G2XmsKfz4DVQdHmEmq2skYgeRKlTZ7iSBZDKXQCEI6g2Azi8JUvFGLLqVh6EgQ1jc
	 W/Tbmtj1811G8oaN7zrZaVyCO8WXnEI7w24HmS7ZuLDY1kE5OF/ceXBZD/X+/3d4wt
	 bou/2a25glhCCPZ6snb5bm++oAmwyVnN6S60rW6wUzIMfsRKo37V4JeLvocWNaOZRS
	 bsfRTKt1mo57A==
From: SeongJae Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SeongJae Park <sj@kernel.org>,
	"# 5 . 15 . x" <stable@vger.kernel.org>,
	Brendan Higgins <brendan.higgins@linux.dev>,
	David Gow <davidgow@google.com>,
	damon@lists.linux.dev,
	kunit-dev@googlegroups.com,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 07/22] mm/damon/tests/core-kunit: handle alloc failures on dasmon_test_merge_regions_of()
Date: Sat,  1 Nov 2025 11:20:01 -0700
Message-ID: <20251101182021.74868-8-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251101182021.74868-1-sj@kernel.org>
References: <20251101182021.74868-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 3F22D120005
X-Rspamd-Server: rspam03
X-Stat-Signature: stgersz9ygeooxa7tqc1wmr7ynnycbso
X-HE-Tag: 1762021239-673183
X-HE-Meta: U2FsdGVkX1+wC8WL/uSt8I4lpuzHPCkJLWS6/r62q7QaB5bOmGybnBGorZViUgSKqvwtAj0LjxOgi0F1ttsPGhs/9YrLDjG8a02Ml9vOO8sPeed/GEHHNGaZJxP4y70bbevQibEECggW1fFBHA809WsiREN+zxY7Ssi5nHmQgpVC+wrGnsLwsrwkgwj/cJBmN334jrpcBXw/DtEdqBnD6FMaGgHVcrPopH+0WYF2pI2Kom19OESIJ7hg094V34ntqup9WRHrbGg1XGgj57oTf96URjQGuFMGoFXJvdubzmG2a3mvx4fqJ7x3GaRwCoUGDTGkgKLv3Fa+buMRcISxICdAKBa7pIFoEd4DmiIIaGwfB2rJaz7DezukjFoK5lQ1N/sajzu5bNNv6ira6USnAU5FfdVboI6Y3ZsxR9spKLEBz2Y+cbUMkWlM2i636Y1TcNObE/JNDitMhzSffGAwCr4sT4ip3CDitamzDIvjLWux4/qbVntQMmt3TqHNPcow38eendGNIpwVM5QAIs466j/dmBifW37YoukdWz4vO2OIcKJE4SKkjBKKyp089/JcyA1I9omgJqbFrDal02i8KlBa30nPLl/tciDAxvzHmHO1s7bmFepjIuNVjHoYcbXtEHfDO1yUK1ZlmmUeYgUgOxPOWKbfjm59hlBzfKl7Ul8UCoVGb5vbtwPoZxpDVFDJxzCT68/qLNmbEwThYCEsN+lUyAogtslmYNlhs4jYHk9iGp75ZgWjak8G+aDk9V+CK98sh0nx/lqjMu2ozc0cEb0TXwFtBz9wRtj7h7FHb0yZxsFq9M9yYZ4ZBYCuhA85MG0mdvCAvt72jGh/GuDtY5+REzHR4+tvxPcm8iHz5eOyNrFFj8scZTSOndbqVhQ90LYg8Qk7p/KfcVZLEYjDRnnUulWopH7sXeq0nHN4bo4kZ0zQi7/mrbWigO3IeFb/kyKihmIcn8dsUroiaX+
 alBiQxFk
 oWgoiB3YsuSmtXL4zEGPwEGXwRaQ+IsQ6et4E5MwZqCeL3wBRzahFtUPwep5FJbniy7j4kmAzCDWXjSCOAbyZekMANr04ADOBGSedzjh4haw3J0OKY8GmDSUANsoZEJsiG1dDzDYTA5W+WvpjxIRfYNhPa66Qbn5pDx8omFBxMtUTm7608VVOg41n1wZ+UDjNGvm4WCv8IMyXu5i9ZgD8WcB+XwKZ0k/AaUnBCXxdggiA0wUoGZM3Gu0d1es7cgZjSd4b3TqNC4CHdAyBDA0p9Jk9JaMex+AtncjUsLL7m3sqVQzcScLy4yKSWYK+FXsOb6lM
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

damon_test_merge_regions_of() is assuming all dynamic memory allocation
in it will succeed.  Those are indeed likely in the real use cases since
those allocations are too small to fail, but theoretically those could
fail.  In the case, inappropriate memory access can happen.  Fix it by
appropriately cleanup pre-allocated memory and skip the execution of the
remaining tests in the failure cases.

Fixes: 17ccae8bb5c9 ("mm/damon: add kunit tests")
Cc: <stable@vger.kernel.org> # 5.15.x
Signed-off-by: SeongJae Park <sj@kernel.org>
---
 mm/damon/tests/core-kunit.h | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/mm/damon/tests/core-kunit.h b/mm/damon/tests/core-kunit.h
index e8219fd23318..98f2a3de7cea 100644
--- a/mm/damon/tests/core-kunit.h
+++ b/mm/damon/tests/core-kunit.h
@@ -248,8 +248,14 @@ static void damon_test_merge_regions_of(struct kunit *test)
 	int i;
 
 	t = damon_new_target();
+	if (!t)
+		kunit_skip(test, "target alloc fail");
 	for (i = 0; i < ARRAY_SIZE(sa); i++) {
 		r = damon_new_region(sa[i], ea[i]);
+		if (!r) {
+			damon_free_target(t);
+			kunit_skip(test, "region alloc fail");
+		}
 		r->nr_accesses = nrs[i];
 		r->nr_accesses_bp = nrs[i] * 10000;
 		damon_add_region(r, t);
-- 
2.47.3

