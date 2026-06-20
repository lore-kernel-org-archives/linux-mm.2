Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9FC81CD98F2
	for <linux-mm@archiver.kernel.org>; Sat, 20 Jun 2026 17:23:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7C0986B0099; Sat, 20 Jun 2026 13:23:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 771936B009B; Sat, 20 Jun 2026 13:23:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 660C76B009D; Sat, 20 Jun 2026 13:23:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3C8556B0099
	for <linux-mm@kvack.org>; Sat, 20 Jun 2026 13:23:04 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 8AADE8C69A
	for <linux-mm@kvack.org>; Sat, 20 Jun 2026 17:23:03 +0000 (UTC)
X-FDA: 84900961446.04.82B548B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf19.hostedemail.com (Postfix) with ESMTP id EA1731A0005
	for <linux-mm@kvack.org>; Sat, 20 Jun 2026 17:23:01 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XTEIVe6o;
	spf=pass (imf19.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781976182;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HUk5Cck1sJbUUjMgjgxqdG3j5G1J/Fn/sddbtTw+llU=;
	b=5nUsFoSgzGPxLB5o1Jy1Xd7twcdeoct0+9E0ddjMTEJQVKZRa46J6xsu37Egchd0u20Xpp
	NlaJKMeo2gujxE5iYRu6OqnhVF1bw3Vg+LeQ2LkeGjIvuI5fbOmvZF+DngmaIqM+Cm4TMR
	r/e/shkDVY8lz8o+oZZdsemTOHNPekc=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XTEIVe6o;
	spf=pass (imf19.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781976182;
	b=zEh0h69uk8/tdEfhAMApOoREdrKz7a/D+L4w1RB6M9rsohhCx6sTQ3OqGwZplhRCfkIYMw
	a/+LvxQzCEj/6Mteh82a+RrGXdb21WC1/3d6HMfcp+Vj/nfCISu9Ted2Q4SnsI5MxIlFVg
	lmPITqhk9sNUVmKK66zDcaJNnKHzPqk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 46CA7443D1;
	Sat, 20 Jun 2026 17:23:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 373F61F00A3A;
	Sat, 20 Jun 2026 17:23:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781976181;
	bh=HUk5Cck1sJbUUjMgjgxqdG3j5G1J/Fn/sddbtTw+llU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XTEIVe6ooWmjl6A5hvUJ7G1nD3Z3UhRAXiawgQ3122HI37NrW7y6ty0Hv0yP79/Vq
	 XVtFJ26EKsianOMCXsTYRbBi4enF28mCunFUEg82EQzyzoEFjQ+OU3gjscyotvbLhI
	 dQMzn29ywiJwgCm1hGjB9mTHbiO1MagUPYfv2C9uhbt5zEreg0jxlJYXuM61fFVlG6
	 +bF3Efh53RiMREw8CWXqT3LVn3VTCnckjsFIrEYEdzEA1wqGobIUSbQmrU0VVWTJm3
	 JT/sL7zeK62cDWOo5cXOj9UQyk9V6JjxFgBYd346aQOTutBCQB+xGskcIQvDVesdST
	 ze27yBznSA64A==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v1.1 05/13] mm/damon/sysfs-schemes: use damon_nr_accesses_mvsum() for damo regions
Date: Sat, 20 Jun 2026 10:22:35 -0700
Message-ID: <20260620172244.90953-6-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260620172244.90953-1-sj@kernel.org>
References: <20260620172244.90953-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: EA1731A0005
X-Rspam-User: 
X-Stat-Signature: dtjdukgudjxto7rz7gwzbqwrejcfqw3u
X-HE-Tag: 1781976181-594893
X-HE-Meta: U2FsdGVkX18tLd/yQm5G4fmKhI+V4Xnfj6P1iHUkLIi+Y1iTrmGdBB7qd0Sq75pJskTyX1+TZw7jCzZ6ZRJ8N4sOMAPpIRkNdH1FPW7bNS+l9PbnYhko6zPrA7Xf3PnQGo5KrKFCUCjqVYpiKKESCou2QgVyBpWOeo5W6JpQMBeNgipZzS6P2pZTq6Gm7oJVTR2S6igKUa5zILCX4jI73X0QiVqmuUO1ZZNHq/EiaOfqf6aF2vOT0ngJmge795nCTDr7PEkEqVXkg2IaKoWB8HNHKOUnT9WCnU3ZOV9nLYFe5S2lSYreyvGJLtikaHaCOAHMU6XznWIc/DJS1Cx4YH46Zv2Vz5SVjxZ8IVfNzNngmwnPEPoXwdqggb9r3CgGlIEyUPIAJLvkTOBpuETPaSJXBonJ23SqoIu3ZOtTo/IqbMENAdnXsOJtfQWyv3IDrE7NJpRIgsC6UO6WFM1SOEbqBJRgUpxaW5TEMtntPtdif/MqkzsLSk+g912H8172PoQ/dig7+xgH1Md89X0MGfLW94fVHCPx8P7M3md8qA4WN8NEMQX00f56YEKb4rRZlhxo1zZE74Jx6O75ghtfp3aTzuc6fu7A/K0fIqCdh3tqSiwCLB8NH0e1pRWZ0axbCvzqVGs1tTZX7z1xJrRT0aOo9tGgrbfhJ/LeFyESgzhHvSEXO1eR3lm5GCNHry2U7xafMmG20W1SfOvNsmzWmkSO75gpXGo1khNE0x98TZrfE3wdfJLb0Ld9J5wmdP7SxDryOhqqJ9hSVwzz9TNIPflUxKYI97iW6hY2g0PdG/X13X/whzEHpAbxuVLukNLygc9+9NC/VmpjHugoTn8ur69JK6II4kQFtPW+85coKciRvSHgzL8NSwHG1Jqo/Imy5RGKr2xP+tMeNE8AjWIJgPpadTJNVNFsDDffvGLL1U5yGpIn2UJd13BUrMBTudVwEVv7uCVh8rIcwg4LkQd
 daaIuyhg
 KJFFS64xyl9G8NgNTr3r3aI4G9M1acGeF7LX7dzicqXtccuvxdbftVKh27BSOg5BA2uJJN3OveHDd4eB5DYVQ/R5xBeqhPejIAqeH5/4nvL4Q4cYjJiDMb13Wi05Vi+wbM6c0UJVwV8RGTY/H7SPTA6etKILhl5QvYo6NyWHPomOHWgSQnPbO1h7j/sYGCvrjRJRvbMtH3NuYrj2aXi9viIGvKQE9WkHuLEiM/HX9oYxwh13TwA9M5ntp6BEYf95k0ejy2HaiNd0xXpTJOWStiwF+wQ==
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

