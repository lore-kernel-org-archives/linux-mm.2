Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F1E2CCD98F2
	for <linux-mm@archiver.kernel.org>; Sun, 21 Jun 2026 15:57:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E0CD16B0098; Sun, 21 Jun 2026 11:57:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D47E36B0099; Sun, 21 Jun 2026 11:57:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BE91C6B009B; Sun, 21 Jun 2026 11:57:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 8CD296B0098
	for <linux-mm@kvack.org>; Sun, 21 Jun 2026 11:57:35 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id DE561C17EE
	for <linux-mm@kvack.org>; Sun, 21 Jun 2026 15:57:34 +0000 (UTC)
X-FDA: 84904374828.05.36A126D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf04.hostedemail.com (Postfix) with ESMTP id 52C6040005
	for <linux-mm@kvack.org>; Sun, 21 Jun 2026 15:57:33 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=C97Ow5Hn;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782057453;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HUk5Cck1sJbUUjMgjgxqdG3j5G1J/Fn/sddbtTw+llU=;
	b=rjGh/NlERYSMvpxIJKK3ZiHWeMn3MUig/REaDLy+i3+5fHP8Vw7O02upw7F7IcNfJAn3ic
	BFAlL0OkjIyZOJAj6clxnkq7ZD4LLhMhz7tk6/g/6jWjcc+rhCWrHLDGXmegLZAxo921hV
	HOVg9q9fmujscID4bDHmroXAGc3XyJA=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=C97Ow5Hn;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782057453;
	b=JpJDTG/QrpyITWSirOOV06Ta9xMNWQrzkSwVMsZys3nrcExZQapmuMBUQ9h6pxFuYcHRaB
	W1qq3CBAcTXbxpw1Z8sQu1Xek1bI80mL19fo6OI3q+gYpNT2DB0RvPHJrwYGWTX0RCzWvE
	1HvxMZboPfgda8WQuo0j0h/pxXdoAWc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id E890C601FD;
	Sun, 21 Jun 2026 15:57:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 075561F00A3D;
	Sun, 21 Jun 2026 15:57:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782057452;
	bh=HUk5Cck1sJbUUjMgjgxqdG3j5G1J/Fn/sddbtTw+llU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=C97Ow5HnfxplLkK+NVpgTZYd4oj2I9AULKD4yRHRT6klAV8l/mMgdXDxZSD0h8cLv
	 g1+m3EHaPtH+NtSdtYy4uBDgPf25Zhb+BBjxZFOG9RNOl0WTwrNnpmPkVU/kie/cqN
	 D6FshYCABVRPkSNTjRBHqIR3gzx5xzbNvhzUhxyP34lLh0iT91fG/WajZbQxp3zTX1
	 aa1v0MzHqTb+26CLeZcrbkq78r/LVHHlXsKqqG3sBn6XqxHSt6OMBxtq8YdAf6sNAU
	 AcIhWOZxqA2/Ms4lWjcZyK8Kzxa1SQ7Dz4B5J/+W30bBfv+1NaSNTjqmso3zA2R3j9
	 Ly81p9WjhCzwA==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v1.2 06/17] mm/damon/sysfs-schemes: use damon_nr_accesses_mvsum() for damo regions
Date: Sun, 21 Jun 2026 08:57:02 -0700
Message-ID: <20260621155715.87932-7-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260621155715.87932-1-sj@kernel.org>
References: <20260621155715.87932-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 52C6040005
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Stat-Signature: oynqjqkas1r41aq8ap6aqy83shjcxpj5
X-HE-Tag: 1782057453-124915
X-HE-Meta: U2FsdGVkX18U32sTAx1TKlx7wVCvu7PbIIj8dIVdU6B2kiMeXOPHwRq5uDxyG5YS4r7LVL16CJcKU0qvB8I6B8jwITXGvt+zBHKpdDSiwpILFspCbyxi27gV2lmkAoRkXTaVGUNpbjt+dc/M1E7npG62DzFY0H0Mxw17jL2Y/Ra+v9wO125b3DtV7w8PUTMgOnNcLYMPzUslC1uJ2hJJz3V7HnWK6nC8mpOIy1HUABEq4qdK5P/RA6VJFSNuOOgQkI+df9e4RmxZBMzUC8HlH+HFY3KmyyHgitDup2GECMJbIAr+BrF/Yh4J09jHzz2hq6gK/EpHDnFYGmEIAbLvXL2iA6DXiB2JRZLZLY8wdlyNnzJdeZI31z4QpKGzAsxa7pPyo9BX5WprZLrcGTA1WzeVSTuloeYBFu3ToYzY2A5D2IQ+JcTid0Nf/EZEU7WpEFf88ZEsMO3FEIl7m1d5ALo45dc9Wn0ONep7FRD8fVehXD46a8RWLam40UfUz/1kdec0v5gVr6hB3a/P5whTTnG3qRntatMlUP5CITNT51qG2Xob8hSB74oFRVaGKWSJ39QM1fSljUR3RpHaOhvj2XPSxQxout4OmhYwgPh3I8ZdVCK+0SJmaQT2DB0UJE47mho2nfXlmg43fLihSyYdPzSoVjUi8rXzr3zIyltDqKQ7dhK31HIwT0Ax5YT25rijxocLr4GP2OPdvIWkCNiEAkztcJc0P+bq8XpFOSzBb20GAZiy6BBuTA2gw6Jmpf3Y6C7mJdEq3JTw7KtkTlFtIqSa06h83FVkq2ioBN58rtMh5oV3BK9gP07BLE2xoeqJ356+Yag3Ucb+alLrGnLuRUethTXExn+l4RiuNtLM2t+MVrIgbryl1F2DqDGTZNPTWcyDTs/1Bz9n5MTvhBx1M8R5a9F8zRUXhNcWSd47rGk6DwIgcyJn4cFoxGsF8AxSeIyhX4SbEISQTcwTkuX
 w44Yn2Py
 uYIDKc9c0o+0K/999l62GgplPQ8j1hKx9INvI4+aNrUfF5hj8NkJLvliJ1xsiwvA7B0EzcpCjvHoqdeOmEVM/UtbOYxJ07DgcI24pGllbUIyJVUyebdoYlTtEwzsZbggpedj6j/nkvIiLXfx2MsBRLs/g3wkJo/nT+LgKXpstCYQTYOaF9UkHZGv7D0G9M9iJV3MEL3qhwN4mDZJZ707O7JexFIl6qNhow2dXmK90gv7rNlRx3NbEkkxLdLyNu7InoEHE+d9NT9QDSTS7sKk/TtHNSw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

damon_nr_accesses_mvsum() returns a value same to nr_accesses_bp.  Also
the function is more simple and therefore more tolerant to errors.
Execution of the function would be more expensive than the simple read
of the field, but because the function is quite simple, the overhead
should be negligible.  Use it in the DAMON sysfs interface for
scheme-tried regions, instead of the nr_accesses_bp.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 mm/damon/sysfs-schemes.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/mm/damon/sysfs-schemes.c b/mm/damon/sysfs-schemes.c
index 9d8fab32b80f7..30a007bcf82f4 100644
--- a/mm/damon/sysfs-schemes.c
+++ b/mm/damon/sysfs-schemes.c
@@ -159,7 +159,7 @@ struct damon_sysfs_scheme_region {
 };
 
 static struct damon_sysfs_scheme_region *damon_sysfs_scheme_region_alloc(
-		struct damon_region *region)
+		struct damon_region *region, struct damon_ctx *ctx)
 {
 	struct damon_sysfs_scheme_region *sysfs_region = kmalloc_obj(*sysfs_region);
 
@@ -167,7 +167,7 @@ static struct damon_sysfs_scheme_region *damon_sysfs_scheme_region_alloc(
 		return NULL;
 	sysfs_region->kobj = (struct kobject){};
 	sysfs_region->ar = region->ar;
-	sysfs_region->nr_accesses = region->nr_accesses_bp / 10000;
+	sysfs_region->nr_accesses = damon_nr_accesses_mvsum(region, ctx);
 	sysfs_region->age = region->age;
 	sysfs_region->probes = NULL;
 	INIT_LIST_HEAD(&sysfs_region->list);
@@ -3124,7 +3124,7 @@ void damos_sysfs_populate_region_dir(struct damon_sysfs_schemes *sysfs_schemes,
 	if (total_bytes_only)
 		return;
 
-	region = damon_sysfs_scheme_region_alloc(r);
+	region = damon_sysfs_scheme_region_alloc(r, ctx);
 	if (!region)
 		return;
 	region->sz_filter_passed = sz_filter_passed;
-- 
2.47.3

