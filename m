Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 88E88CD4F39
	for <linux-mm@archiver.kernel.org>; Thu, 14 May 2026 14:10:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 60C426B00AE; Thu, 14 May 2026 10:09:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4D2E46B00AF; Thu, 14 May 2026 10:09:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2D6026B00B0; Thu, 14 May 2026 10:09:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id EF55E6B00AF
	for <linux-mm@kvack.org>; Thu, 14 May 2026 10:09:29 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id BAE1E1A02DD
	for <linux-mm@kvack.org>; Thu, 14 May 2026 14:09:29 +0000 (UTC)
X-FDA: 84766208058.11.49F80D0
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id D5A451C000B
	for <linux-mm@kvack.org>; Thu, 14 May 2026 14:09:27 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=YotgPjwi;
	spf=pass (imf20.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778767768;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7YUZCOhs53s47KnHMfX09ioIAPoOvG+Fq04cUhP7p9A=;
	b=YyXOljDP8iDgqY03BmsX/9Nk0h8A/kp3mWPqPfPSJoM+HSkU6Fz+9V7aa7ZPEAFP0vzbr/
	+3JRxVPTbx59S5mQXft/8R7K5jM5soYQvfk0yaNOwcvlIn637omEpN4LBr954P090aek4e
	Oh58XsWl3RMXEImsGA+oEmb+jTCh8lU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778767768; a=rsa-sha256;
	cv=none;
	b=EAtTjY0x1NKyDfJZLKCW/M7JzUVdtdkie8ISVpLS5wESx+k6m3H7IIEa65bsD++g+8i4gy
	h4QuA5SWn4XC68uFzi/r4iWQaDcpHYsGJYbXTHUcTnZ00L3XjAXr+dWC2u03vZYwZ15JMt
	ECfP6VdvUd2IjpKFbaP6hai8mIt9clg=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=YotgPjwi;
	spf=pass (imf20.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 99BB5444DB;
	Thu, 14 May 2026 14:09:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 568BAC2BCB8;
	Thu, 14 May 2026 14:09:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778767767;
	bh=jW0kOVlO76z3Unib/m3BDQZ8Lhaae0dgTTAXYzXNV0c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YotgPjwirOwx8uED8R1YFTvMXp06UJ+PObnbH6ZNN//RwqeQ+F6lZ5Rp2t5bnf/qc
	 O53pWE1SDH/Wb0yAOVtdr190Saf0ILB6gkN4HT3LrqYzgE3XhEoqK6bMga+j+ccjbg
	 INqyByzZqga6NYtqO9INLzae+tKksWQPLvvt2VID4tTFSKYk/BtLk7sP8jceJl43sr
	 qd972ePOTan9sV3GgkRhz/cHsrA8U5gwmm6BBG+Dbk9Dc+kOvTksHUoCYjDST4T8bn
	 9rD5SgJ6epwjq4Eve68pO+wV5LiFrL2/vQhxQmfRJGsP3ETPxIx37rRzH2xR56CWyQ
	 RBG9MQ1JN4kQQ==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v2.1 25/28] mm/damon/sysfs-schemes: move memcg_path_to_id() to sysfs-common
Date: Thu, 14 May 2026 07:08:58 -0700
Message-ID: <20260514140904.119781-26-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260514140904.119781-1-sj@kernel.org>
References: <20260514140904.119781-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: D5A451C000B
X-Stat-Signature: tjbfxuphc99odeec5qyabk4bgreowcuk
X-Rspam-User: 
X-HE-Tag: 1778767767-638179
X-HE-Meta: U2FsdGVkX18LEVTVbtPan/WXcEjyQ58k0F/NUFzTPnGzaJP0kUn29adX1Gxp4ATUQZjilSiZmjXArTaDPoT04vw9XWBXrYSKD9klgnIRRroyn0UBby3QMQ1N02fz1ofJXjpctz8cSej/lUT9NBTpJlLPJIH7Pyxz6YHYJmje+V7SkUVMSObLtGQuwm85kj8FZcpcdjCzUCa2bFaeYrjXNR/KHJnYZxJJHzN7+fc45rybJPaM/VGyqqa4ZrqY0nFiPHOM6Nk03gDjxGl+HTqZtHTARE1tjdo5gAeCPppHYSHJkING9OVomNjXD9oFPRvXphd70HLuBluC9/AlTzlJSrZYeTjh2s+DuXJtVlsaBvkMMaAm5PdDWvfwkhZI3PAGiYmMeEkArsl5fYWaLOLSBeUHoqg1P1Masqdi8rKR02Vs0EGmoONZMXznMoo6980SzdTvVab7gh3hYxxLx2KszJQrwvD4C1xa1gJXr8v57zkCzk0H5e28Q1JlhkNc8+yqdz/AH8g5OQPRMQs9cR1xpYbldZ9PTBT+NJhykKFLISdPB1wcNWOiWh9e/E5idRohO5FzjQXs5bvKLtunr1c2iJJIx3BIlm2ILZKyXuBlfxEmxBLt9YpytOD3oTGodbeyay/Xl4mts0EvO6zz87IqBrmG0s/5e9uyJgnTuuTdaYOBz/4C630PMxI3o08145HlOnDKDUHokAHNqUXt2Lf1UorVsr9Pbn1U6aFq3qDXU6X/x/bLWt/1RDtja9AhxJgC9xxDw8STgP8OyzYHXOm2zNGpXMqM5mQrRP50N2jiX39VPAKDq3bGOh5v+M7/+/Hz/jUakm/JYY+iP3Fy04fBEyHbvfRhgbLW5chSSUDNQwQ6WkXK/qN/UswqVhjvrCxpEmR013dOl7+pZNwiNdrwqGWAybLblUzkjgx0rPPa0YZtphjzMDbABJ+bmVACpcq+4KZeTXSd+jxl+bbJGEK
 +1K+cSsW
 tMTzcoOrGPdCQykGR3x979PUr2TlxBrw/W7zfDmRDEZTCJyC2l3MY0kiuuVyWOzLYYe5g5mnFBqErMgOAaIuSVeCVQZsxf8rJ/6nG7blMKxsLrslZcWWIRfDpIGouMwKWmvHrgNwwi1/NSfGOvVR0g54J9/UbmvlgXIFn2xROkxSPNnt1NTUmS0J8MeSmlzxB+PMdwO0hTfhBEYwUJp2YjTwfLav6SVOcBAw4GcVeeoLjWg2WkWniBc1JpoYXiYv4r9TT8DegslX0OHgMqQiHE46bPQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The next commit will need to find the memcg id from the user-passed path
to the memory cgroup, from sysfs.c.  memcg_path_to_id() is doing that,
but defined in sysfs-schemes.c as a static function.  Move the function
to sysfs-common.c and mark it as non-static, so that the next commit can
reuse the function.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 mm/damon/sysfs-common.c  | 41 ++++++++++++++++++++++++++++++++++++++++
 mm/damon/sysfs-common.h  |  2 ++
 mm/damon/sysfs-schemes.c | 41 ----------------------------------------
 3 files changed, 43 insertions(+), 41 deletions(-)

diff --git a/mm/damon/sysfs-common.c b/mm/damon/sysfs-common.c
index 83e24a9b5a0db..bdc6ae2639e4f 100644
--- a/mm/damon/sysfs-common.c
+++ b/mm/damon/sysfs-common.c
@@ -104,3 +104,44 @@ const struct kobj_type damon_sysfs_ul_range_ktype = {
 	.default_groups = damon_sysfs_ul_range_groups,
 };
 
+
+static bool damon_sysfs_memcg_path_eq(struct mem_cgroup *memcg,
+		char *memcg_path_buf, char *path)
+{
+#ifdef CONFIG_MEMCG
+	cgroup_path(memcg->css.cgroup, memcg_path_buf, PATH_MAX);
+	if (sysfs_streq(memcg_path_buf, path))
+		return true;
+#endif /* CONFIG_MEMCG */
+	return false;
+}
+
+int damon_sysfs_memcg_path_to_id(char *memcg_path, u64 *id)
+{
+	struct mem_cgroup *memcg;
+	char *path;
+	bool found = false;
+
+	if (!memcg_path)
+		return -EINVAL;
+
+	path = kmalloc_array(PATH_MAX, sizeof(*path), GFP_KERNEL);
+	if (!path)
+		return -ENOMEM;
+
+	for (memcg = mem_cgroup_iter(NULL, NULL, NULL); memcg;
+			memcg = mem_cgroup_iter(NULL, memcg, NULL)) {
+		/* skip offlined memcg */
+		if (!mem_cgroup_online(memcg))
+			continue;
+		if (damon_sysfs_memcg_path_eq(memcg, path, memcg_path)) {
+			*id = mem_cgroup_id(memcg);
+			found = true;
+			mem_cgroup_iter_break(NULL, memcg);
+			break;
+		}
+	}
+
+	kfree(path);
+	return found ? 0 : -EINVAL;
+}
diff --git a/mm/damon/sysfs-common.h b/mm/damon/sysfs-common.h
index 2099adee11d05..3079306966a91 100644
--- a/mm/damon/sysfs-common.h
+++ b/mm/damon/sysfs-common.h
@@ -59,3 +59,5 @@ int damos_sysfs_set_quota_scores(struct damon_sysfs_schemes *sysfs_schemes,
 void damos_sysfs_update_effective_quotas(
 		struct damon_sysfs_schemes *sysfs_schemes,
 		struct damon_ctx *ctx);
+
+int damon_sysfs_memcg_path_to_id(char *memcg_path, u64 *id);
diff --git a/mm/damon/sysfs-schemes.c b/mm/damon/sysfs-schemes.c
index 43a8224d991e8..6b21bbe97d04a 100644
--- a/mm/damon/sysfs-schemes.c
+++ b/mm/damon/sysfs-schemes.c
@@ -2792,47 +2792,6 @@ const struct kobj_type damon_sysfs_schemes_ktype = {
 	.default_groups = damon_sysfs_schemes_groups,
 };
 
-static bool damon_sysfs_memcg_path_eq(struct mem_cgroup *memcg,
-		char *memcg_path_buf, char *path)
-{
-#ifdef CONFIG_MEMCG
-	cgroup_path(memcg->css.cgroup, memcg_path_buf, PATH_MAX);
-	if (sysfs_streq(memcg_path_buf, path))
-		return true;
-#endif /* CONFIG_MEMCG */
-	return false;
-}
-
-static int damon_sysfs_memcg_path_to_id(char *memcg_path, u64 *id)
-{
-	struct mem_cgroup *memcg;
-	char *path;
-	bool found = false;
-
-	if (!memcg_path)
-		return -EINVAL;
-
-	path = kmalloc_array(PATH_MAX, sizeof(*path), GFP_KERNEL);
-	if (!path)
-		return -ENOMEM;
-
-	for (memcg = mem_cgroup_iter(NULL, NULL, NULL); memcg;
-			memcg = mem_cgroup_iter(NULL, memcg, NULL)) {
-		/* skip offlined memcg */
-		if (!mem_cgroup_online(memcg))
-			continue;
-		if (damon_sysfs_memcg_path_eq(memcg, path, memcg_path)) {
-			*id = mem_cgroup_id(memcg);
-			found = true;
-			mem_cgroup_iter_break(NULL, memcg);
-			break;
-		}
-	}
-
-	kfree(path);
-	return found ? 0 : -EINVAL;
-}
-
 static int damon_sysfs_add_scheme_filters(struct damos *scheme,
 		struct damon_sysfs_scheme_filters *sysfs_filters)
 {
-- 
2.47.3

