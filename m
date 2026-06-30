Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D3CE3C43458
	for <linux-mm@archiver.kernel.org>; Tue, 30 Jun 2026 04:08:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 29BE06B00B0; Tue, 30 Jun 2026 00:08:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1FEA66B00B1; Tue, 30 Jun 2026 00:08:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0C6526B00B2; Tue, 30 Jun 2026 00:08:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id BD93C6B00B1
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 00:08:29 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 058D140367
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 04:08:29 +0000 (UTC)
X-FDA: 84935247138.30.0B0D18F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf18.hostedemail.com (Postfix) with ESMTP id 7186B1C0003
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 04:08:27 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="mF3MoQG/";
	spf=pass (imf18.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782792507;
	b=H8u0ku8NYg250o4NdcnqczfY/vPegOl+OxYW3f0swVyPG7850S6vHuWYhN/323NLlV+la0
	pJ2fD+ZP/OcW8bZOv7VNgSK/NgE5QBK+1w5LyjyweKdxuaguq8AOy+5oYoIKzpzuLvk56t
	1UCW7S9CnQtkCd2ZpLjS7KgP2o1hzJ4=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782792507;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qVKKQyZNxinKbnhBlGVW7XhXLiIyfL9tA4LU8cChtL4=;
	b=qVDyrvYQCDVBCF42zp7rs7/ZhpTvq9elv66HRSu6JGJfYXpcUMPZQkaCV573/Y7rdQjFZk
	fXYR34yvpkvN8M3erC6e97sGus5TF2WEXKsOO8EzZfAYNkMUV5dA6t/jy5qQfyVRtvwrz2
	oFCyxxN/ECOrfN5rwGqHwd9i+QRVE3U=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="mF3MoQG/";
	spf=pass (imf18.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 10CA1601D7;
	Tue, 30 Jun 2026 04:08:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85D3A1F00A3D;
	Tue, 30 Jun 2026 04:08:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782792506;
	bh=qVKKQyZNxinKbnhBlGVW7XhXLiIyfL9tA4LU8cChtL4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mF3MoQG/P2hCjrSEvrbxYB5IrFcDVx2kd5qTnlBgzdPoRqt5e5hGTSGGxNK/ojTz8
	 1u8rcs6tmzSJv496Y9Pg7uw1iZG7T6CmiVpxseUg2EbzoeIRv6ooizXw3J55meeV8v
	 Rk9RndqGCivT43hCq6bejGBQHwthNOJqOpD17JE6zd4WmGLH6fc5tW61XP/WspvbZY
	 eCYPMzE18LEal/VJQ8bWvlUD//CkQgLO2OrBLV2kgZB19WM+HWm7u+nu3k1njf3Eh7
	 X897mGZvDc0+IcE0opQ420Ia4L5GhNC+VLdnW4o83iz3Yif83HaYQqf9QBPD2d5yuI
	 fUcyB+CoZaNuQ==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SJ Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 07/18] mm/damon/sysfs-schemes: use damon_nr_accesses_mvsum() for damo regions
Date: Mon, 29 Jun 2026 21:08:00 -0700
Message-ID: <20260630040812.149729-8-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260630040812.149729-1-sj@kernel.org>
References: <20260630040812.149729-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: cbb7je3696p94zsxdb9he7hwu1eknx5n
X-Rspam-User: 
X-Rspamd-Queue-Id: 7186B1C0003
X-Rspamd-Server: rspam02
X-HE-Tag: 1782792507-561297
X-HE-Meta: U2FsdGVkX1+ffiQStJEcJkhAahp4OnWC8eSenbYwgfmGL0uqodSqQvfavLyCCpR4hlskeJSIO/5IT5ynIgLxGE80JpqNwpAyU2PDqDifDfm9iNAAnKMaL90EsRBh6klmDigPBQuo3vGlE8NzBuPulZ8sJFwMGRIgK5ZJg3J3IDmlms9C2xUpeRpnbItp9hxOjisZIK1Dztb2bnkxs/K6iXtgxSIN1QfuZrg3SksqAW0gifqonIT83z2RrLuzv+GbMffN/0u7XordCx9g8sKl2OMa1P0kMfLii3ND4WsHiQOqYxs8Vz8az4Ax62nLXZYY9CzFho4+XXspgk29xF0lKX0LfMiwaZoThHkIDa/e8y2DX6jEfVXLKiDuEIx5w+N+Q248FB2ieGAlIhgMMrfVoGClpqVBz0elHnMhofcGkmqSZJ3xn/NUPEsKXx+Pv6hiQ/O9wy3OxyGbv7Gb+wpPxTdwc4bwMrht8HsJTCIljsMisOJspd93b3K5lOSGL8hk+9g2qmlDz7yrIEMl4QZ87TJWF45qeQoH+zgcEOap88BdaZ+toqYGnrv4oTql7PK1A+CkwZpvEba/bg5jvsUtDlNU9H7DC1G9SGLxMBql1PEOxDfk3Bk8cDdZyNHSN5gLb6+aB80N4FJqVqXzVJKvK3huAyRyiZAvjC62CZpz9a7XLF2wHWC80RnsJdc1KhAowYEhGIQecVof4sl89sSn+0KnW9bNqwnC18ZNXWlStR5hi8I02AJsTDAqYBb1w1qyHhB0ZDr8xRv7HsTpRu4SsjcZUm6bCgpqvNBb3hmorC4BEvRroimnlAihq2KtFa6BHoYohmc/LUvP4PcALYyDlQD4ADZI+rl1dfD9mNraVbHPL2KMN31d8042apYWeep5CrnIeh6oaM4IBI8IhKQohHWz9uczIkhUxc9/Gwgl97fvaaisYjtQjFnfVfZJMIzXNE1Ik+BBT5IRLdpcf8x
 uAjQ3T52
 5hxLbWSpejaFSgTgQqnZnVkmEExLlgmYOAmJOJCBgLpLakSMOYkjLflRWVBJm/H0AIdz0hdGc39q6LTi7fNc8FuJzcv0ekl4/jCx2aq7Z8WFoS8yUQJJY+kv5FA4OVjyuITurBmS4ce/S8CvVHhW9XFGpat3q0yKtLE2V9XSIYpyOzGKHZDMw9009CDe9VQHBwQSIJSJj+8wMhTe0DGwYuO7A+LDAnsypP73RNkSEFSz6vg1A/lRDuJrvum9TUTmP318i/eyAe39Q6Y7dLQIHIc/uYw==
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

Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/sysfs-schemes.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/mm/damon/sysfs-schemes.c b/mm/damon/sysfs-schemes.c
index 41f93a1823bf1..dbf2b0515d582 100644
--- a/mm/damon/sysfs-schemes.c
+++ b/mm/damon/sysfs-schemes.c
@@ -157,7 +157,7 @@ struct damon_sysfs_scheme_region {
 };
 
 static struct damon_sysfs_scheme_region *damon_sysfs_scheme_region_alloc(
-		struct damon_region *region)
+		struct damon_region *region, struct damon_ctx *ctx)
 {
 	struct damon_sysfs_scheme_region *sysfs_region = kmalloc_obj(*sysfs_region);
 
@@ -165,7 +165,7 @@ static struct damon_sysfs_scheme_region *damon_sysfs_scheme_region_alloc(
 		return NULL;
 	sysfs_region->kobj = (struct kobject){};
 	sysfs_region->ar = region->ar;
-	sysfs_region->nr_accesses = region->nr_accesses_bp / 10000;
+	sysfs_region->nr_accesses = damon_nr_accesses_mvsum(region, ctx);
 	sysfs_region->age = region->age;
 	sysfs_region->probes = NULL;
 	INIT_LIST_HEAD(&sysfs_region->list);
@@ -3122,7 +3122,7 @@ void damos_sysfs_populate_region_dir(struct damon_sysfs_schemes *sysfs_schemes,
 	if (total_bytes_only)
 		return;
 
-	region = damon_sysfs_scheme_region_alloc(r);
+	region = damon_sysfs_scheme_region_alloc(r, ctx);
 	if (!region)
 		return;
 	region->sz_filter_passed = sz_filter_passed;
-- 
2.47.3

