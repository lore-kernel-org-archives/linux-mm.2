Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 27FC3D1F9A1
	for <linux-mm@archiver.kernel.org>; Thu,  4 Dec 2025 10:04:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8516F6B0027; Thu,  4 Dec 2025 05:04:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 828466B0028; Thu,  4 Dec 2025 05:04:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 765AF6B0029; Thu,  4 Dec 2025 05:04:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 65BFC6B0027
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 05:04:10 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 188678AB99
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 10:04:10 +0000 (UTC)
X-FDA: 84181353060.28.CC8B24F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id AD86C10000D
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 10:04:08 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Wl65G0nu;
	spf=pass (imf14.hostedemail.com: domain of arnd@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=arnd@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764842648;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=owrCoUVmLpd5CVrJFHTYIbaX9tAD+TuN4gN/XLXZV5o=;
	b=CveyT0uQxPZCru58lwfUcmp/YQLTrNgCeJ6Yw96rZeZZlmHD4yUx/ZzcL/0mnUfTFmxCew
	wq/8qTuBrV+YMoOt9zgRNz+B/rzFkWKOFfhIt52Zatunt7DOxKcgwtA43B+nWlqqV5Kvwy
	kLzfyVneFDRd+/fJAcxJecBETwOQp4Q=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Wl65G0nu;
	spf=pass (imf14.hostedemail.com: domain of arnd@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=arnd@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764842648; a=rsa-sha256;
	cv=none;
	b=b+5MlPto/DmMV0qs/pPRRrC/0k+qJfpIj6VI/J/stPBkAZqHwYFWqfD7Mih6iYpe5/M663
	qPHCBn7PrquLmiG5f75g/zrDv6eHlQU3+zupc15+Xn/GGBPs/unxZr7n0Cxh/kJWCvElTz
	e5o5m3ZEcTKZyHeNTN44x6FgHcO3ELM=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 76ACF409E0;
	Thu,  4 Dec 2025 10:04:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD75EC4CEFB;
	Thu,  4 Dec 2025 10:04:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764842647;
	bh=ArE/hdVTiVvxgqAXC1TACYkyTmhmvDBhTBXlLDgls4M=;
	h=From:To:Cc:Subject:Date:From;
	b=Wl65G0nuaALQFV4IweK54wl0c2W2lLgcJK4D9+9fDo6TlZgDmnfvpG3IeN1koRwlR
	 nKDnneiUJR5EYB8zVWL03kjdD8sSthJWa2npK75m9XGo1ks1HWHWXq+ld78VrQK1n3
	 oKMM16POl2li41iO3P8PRLSGYFsIHXvalDu1voHPpOrylrVQ2P5alIfMKJiC8fvNYt
	 oTQSEggm6gjc6BXh8KnUnPoA0Vha9Eone25cEPc64lmY/xfFcU1gD0S+0IElxt67LI
	 /u7oGpfifeIhQNvfwSops+BCovGgMwH1Sa3f7JX6NBfCMNnyIJvUFVpwvREXzDmUM3
	 AoUPhUEWbxkGQ==
From: Arnd Bergmann <arnd@kernel.org>
To: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: Arnd Bergmann <arnd@arndb.de>,
	Quanmin Yan <yanquanmin1@huawei.com>,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] mm/damon/tests/core-kunit: avoid damos_test_commit stack warning
Date: Thu,  4 Dec 2025 11:03:54 +0100
Message-Id: <20251204100403.1034980-1-arnd@kernel.org>
X-Mailer: git-send-email 2.39.5
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: AD86C10000D
X-Rspamd-Server: rspam02
X-Stat-Signature: qrjrwtsbiyc4wcq1jxw9oqh4kco3j4qk
X-Rspam-User: 
X-HE-Tag: 1764842648-742426
X-HE-Meta: U2FsdGVkX18itUdKQ482HGjl8qJ5Zz1+B+K5NdUPMcn4ulWR52b/juIwskQBw3pe4MvO61vrpZSZsnv2feKRTCNV7wiVihpokaI6SzF+mDJWHD4DlY0zuy58K7M91xTNKxTUTH7bN074m8rzC0aUf1h/rNG0g3wTj0q625CeEOSex8UM2x+4LsVsjshRQmNGSrF6rW2c0YGErakw+fFgzOrkHPXRPRA6yJe5yMaOQReZIyJt3fJxyRo9Zhri+XAUHYysfYGsubmV00ZWu3QVvJ1+2RbvbVFTLYwIZmOxpAJQ+//eVfIK5w2J3zyeEmD6jCO0mmjZkqhdOBXXkJFx8O3bwys2RyjrnfycT/OnhAmFZq7o+HCaFNgxiOq2sSf5ztREjzhUiR1XZjlb+3BJGRTrZNSaAA28Tozc4zHtadq3L4LB97pILtW1JIJo9GpWy80MI3TlrGr3mzkLqxcd6nCdpuoMMrBtlSjxOLjq7AhN2farKQ7p4vFCh+yZQasV5bgVXOU7TClKNxMYcPO6oC2XIBy5patYtOe6UNgYDHwtm9h6JV7cOj249CRVQgHuL0Tx0XjP4KH4Nw6S5OrmktzvLZDg3jTSFeo9T/7DQG6q33TKW/WrbLjsHDlH+0QuMAjWtzHK4ed8MdTW1YKCAQOY+j07jZmch1Q7kROUiXquAcW4G4fEiNYxvE5cWKLEmW48RucOM7yfKCiliKFiWfS0UJeGg6Z46O+SLLWe5F6Dq+XFM6uDqSfFwfUTu/HW9Z75XK25ZARQ7gvqwJCYLS7CIuE7euD/toNGcAyVkm/+/c+GioTdHRntkj7e0yg0OAGYFgmNj2HYDwUNI5vYYfcbO3VjnN08jNSQMGEtpaNy3+EFjRLQt3OJVn+nusAFy58UeRV7307sw2sh80fwcVFN960Xn24lVr0YzrAXjIggtJKvygh8ZbjDSVrmn67MzlyNcvi3NNpvxVxrPoD
 oPoIF5Tl
 UY9/O
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Arnd Bergmann <arnd@arndb.de>

The newly added damos_test_commit() constructs multiple large structures
on the stack, which exceeds the warning limit in some cases:

In file included from mm/damon/core.c:2941:
mm/damon/tests/core-kunit.h: In function 'damos_test_commit':
mm/damon/tests/core-kunit.h:965:1: error: the frame size of 1520 bytes is larger than 1280 bytes [-Werror=frame-larger-than=]

Split this function up into two separate ones that are called sequentially,
so they can occupy the same stack slots.

Fixes: 299a88f6ec13 ("mm/damon/tests/core-kunit: add damos_commit() test")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 mm/damon/tests/core-kunit.h | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/mm/damon/tests/core-kunit.h b/mm/damon/tests/core-kunit.h
index a1eff023e928..8cb369b63e08 100644
--- a/mm/damon/tests/core-kunit.h
+++ b/mm/damon/tests/core-kunit.h
@@ -924,7 +924,7 @@ static void damos_test_commit_for(struct kunit *test, struct damos *dst,
 	}
 }
 
-static void damos_test_commit(struct kunit *test)
+static void damos_test_commit_pageout(struct kunit *test)
 {
 	damos_test_commit_for(test,
 			&(struct damos){
@@ -945,6 +945,10 @@ static void damos_test_commit(struct kunit *test)
 					DAMOS_WMARK_FREE_MEM_RATE,
 					800, 50, 30},
 			});
+}
+
+static void damos_test_commit_migrate_hot(struct kunit *test)
+{
 	damos_test_commit_for(test,
 			&(struct damos){
 				.pattern = (struct damos_access_pattern){
@@ -1230,7 +1234,8 @@ static struct kunit_case damon_test_cases[] = {
 	KUNIT_CASE(damos_test_commit_quota),
 	KUNIT_CASE(damos_test_commit_dests),
 	KUNIT_CASE(damos_test_commit_filter),
-	KUNIT_CASE(damos_test_commit),
+	KUNIT_CASE(damos_test_commit_pageout),
+	KUNIT_CASE(damos_test_commit_migrate_hot),
 	KUNIT_CASE(damon_test_commit_target_regions),
 	KUNIT_CASE(damos_test_filter_out),
 	KUNIT_CASE(damon_test_feed_loop_next_input),
-- 
2.39.5


