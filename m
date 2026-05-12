Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 70B8BCD4851
	for <linux-mm@archiver.kernel.org>; Tue, 12 May 2026 14:38:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EAEBF6B00B0; Tue, 12 May 2026 10:37:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E60FD6B00B3; Tue, 12 May 2026 10:37:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C62766B00B0; Tue, 12 May 2026 10:37:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id A60E36B00B1
	for <linux-mm@kvack.org>; Tue, 12 May 2026 10:37:09 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 736B7C1E65
	for <linux-mm@kvack.org>; Tue, 12 May 2026 14:37:09 +0000 (UTC)
X-FDA: 84759020178.04.FA0A008
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id C81CC20017
	for <linux-mm@kvack.org>; Tue, 12 May 2026 14:37:07 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=l01JjO28;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778596627; a=rsa-sha256;
	cv=none;
	b=w5SK1miv/ltGgTt+T0L2SkbNGkGh+5vwplpZYij2Z93ZYmNtRFbfd39HspWj3OJSFTjTeO
	eybR7+UmAOlp4VCSUq4mdy3Wo0pC7vUqCybo6V3WWRhaLqyln8tEKkcyiazkogVPGU5/HN
	Ry1+kMKoBsKnbd0Pa1viL7ZwkvX3Omo=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=l01JjO28;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778596627;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7YUZCOhs53s47KnHMfX09ioIAPoOvG+Fq04cUhP7p9A=;
	b=sTaSVHKzxybm+GaukB3XbNW3gAlFQT3hZf0Z3IEWWc7lwEDmRNH4dz6uO8ozvATrjIbDIs
	dyRfaq+9gfPx9IngNzcIcMGVjg+0t/Z75uCC8cFE8mTgQMl7T1AhrmAHXsAGxQ2gxN5ZX0
	wF+WO6C4koqFbZcuf2J3OUyLc60Pm9U=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 8F64B44AAA;
	Tue, 12 May 2026 14:37:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 450FFC2BCFA;
	Tue, 12 May 2026 14:37:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778596627;
	bh=jW0kOVlO76z3Unib/m3BDQZ8Lhaae0dgTTAXYzXNV0c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=l01JjO28+FAaW8Vmp3vllMET+9x80dN8OmtZhIZxCVkkCjMfYEDbhTzPACiE/nYBg
	 2f5sKGQSik7yNKUA4x5GmzbfXIxPdFW/0gIBw/G1KNaJq+Wy7+OtdWurh1O07tytbb
	 FuIFgjiuhw5tztw73N+lcHfCCxKSB79yoZDdmw9/zZ9GFiL2P1El1nZqxMcJJaywbg
	 feQHtsZUhBRAKeCXokwowXuWeJU9saxwVsr65Pdv8mx+e433RGp4mzfSaHIUA7Vjs0
	 vyhxQ4JAtIXvTET4+qtwbdMBOZfaof+OGKIVcHvqaLGoyWCeZCXuhSwAo/MTQo4Znu
	 DpHjS9NUCGUuA==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v2 25/28] mm/damon/sysfs-schemes: move memcg_path_to_id() to sysfs-common
Date: Tue, 12 May 2026 07:36:40 -0700
Message-ID: <20260512143645.113201-26-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260512143645.113201-1-sj@kernel.org>
References: <20260512143645.113201-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: bp7f8e6uqtre789u8fsxddh38s3uwqse
X-Rspam-User: 
X-Rspamd-Queue-Id: C81CC20017
X-Rspamd-Server: rspam07
X-HE-Tag: 1778596627-129430
X-HE-Meta: U2FsdGVkX1+AIy6TI0ZJhW96cpxl9QGax5d7h5eA00n2+tbAeD2FTmJ3rSnkBkAO8w/nyk0nTiFSzH2rPuScGm3g+CrV4NuF11UtqxB3I+Uo3mKZqgjbfBsLObFvtFT9Aep0awhd5aV6VUkeiI4HoCZdtgOCpTSuYsw9LDo9FS0Z0iW1aXzgRGT4u7JWseRVVWeWuQL8b5PW+j2wbO7acZpWbwh5HyHaJYmOVlNBGSbeJt8gdKBOTPokiQQPK+sBz0iMZDEFQUYHHsYe7bGuAqX5se0PqT4lb1a9kaeAU7mt3dlfVQ+QSqbWn7sp0qi14W4TeOC/phlJRzWND0qWQTZPXHp58NqBegq9EjLUZ9IcfAUVXy7P2nBwlW55yAeSETkLy25m0S24auHRWcA3LYlk1vkrBJtGM5IqRuXrYvtXDlFad8nG6FUXK4xuE3QaRBXI1oi9f215DmGk2uDS74GDyxq/fyIQMV3zcB3R3spqJ5QYm94W6uzvavVxEdeqfjL5MxFZ1OfA+MFw2fkmTV3juR45IvCX7P0yoUdY6vzR1K9m8UPWqPQPQs99uQL7h+EWLpEY5d4HE0+Zbo8/XeUDvXQym0qmrdK8oXw7nBR0NGpVcqXnzV3L5yydxiHFSsJAIuBKCcXHB405sya+x2/hwU7GwaTUfGfKNj7jEManaT09GHLuqvz/FS8tSa/DJpewFy5u74b54EJOG2Qp4RmHZs0ah6+cGAqJJk708qn998keHxEunAehsxKhOde9TU85xoD77IlwSuNg0qUUWTN5akoTJ/Fj10N+BvDW6BesU4tJgUJExcAmDlsqhzXLIKtIQEMWYXy3RUpCad/IvjGnWvyGXDsG3avyxV9OSkykblUp7ccxtHOTp8Gw/V8dMMGvQtShpQViSqJNnVPaI1+HM3aBoBvQdWEwQWUuDGwUZgdh+Ly9zpXCcDStH0uNZMCyrIvMEkGc8dU6IkX
 h56cLtdT
 FRW/e4QNWCji6tzID95gs8DE6QwI3iTdGs6yy1Jq3K4CrmYD8W1b2UM/h6+bkE/aS3lCiM9VZ7RTiyTAWoyDPu3djaB40cITtcHcqiCGF21j8a9sc4/VNYO5XPrWCBEjWjF3aOHUQDsvU0ip7UI5nhTlZxJoKnm4eWF5CQ2ubsi8JrUnLWEKrMZOSOmizv00D78oiDfRkIqsaPHIhAXn0geNF6590fmDi8STRwARJBnG2QWx5MtowP9xOkHzVxfk0GKnhxRuLHFTYM5zQfVj/zitg4w==
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

