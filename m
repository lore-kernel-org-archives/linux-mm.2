Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5C5B5CD4F3C
	for <linux-mm@archiver.kernel.org>; Sat, 16 May 2026 18:42:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 833F86B0095; Sat, 16 May 2026 14:42:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7E5016B00AB; Sat, 16 May 2026 14:42:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 722926B00AF; Sat, 16 May 2026 14:42:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 644EC6B0095
	for <linux-mm@kvack.org>; Sat, 16 May 2026 14:42:52 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 194B31A03C0
	for <linux-mm@kvack.org>; Sat, 16 May 2026 18:42:52 +0000 (UTC)
X-FDA: 84774154584.29.CEDFC37
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id 55BBA40006
	for <linux-mm@kvack.org>; Sat, 16 May 2026 18:42:50 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=VvcVtMFp;
	spf=pass (imf17.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778956970;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=q/3ifT7rRP9B5zVzFbDUrFbYHYGGpKeT22pL6kpCIhs=;
	b=Fmy/vTk0Di5GQrtdd0y23wl684Xv2HgDA3rfvB8Wab5WORETgm44PBCond+V9lYTZYrVwm
	v4aVrwxr3WxIawsGhSAHSUL7Scyf8fqtbzGMfKc+049v+d2W3+w9uvL6+IzJ/b/hOLrDTF
	kvGQL3mkHyEavsvCj+HmmQPVPXAulmo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778956970; a=rsa-sha256;
	cv=none;
	b=Jezlx1PMkNpYz9TNZoAS0fWTQAGKRIudQfuOqR2Mvk4zE+6D19Gw9D/BzbS8+3abW63TMv
	BVU2lUigtXFtJA6BfYncBfgiN8hOqokZ//xC45gvM3yQ1Jph+iOHfk/kr7Ne8uIi5aYHU+
	OL6tViXT/dycblSKr/483lFvUKP11j8=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=VvcVtMFp;
	spf=pass (imf17.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 70DA040E22;
	Sat, 16 May 2026 18:37:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24849C2BCC9;
	Sat, 16 May 2026 18:37:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778956654;
	bh=qHHHZqgQa9Lg/3bYJzNijBUd9h6TB/zAV5V5qHZIdH8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VvcVtMFpoNllpLjv58cFlkW9QPmJjBmBcKFmfW32PjdEBHy1vHGWF2b/XFCVPSByU
	 3V1wy+LZHO6MZgrll9javFT4mUsvstGPchlb8lcPrEGEm4z7xYYUlcLrUMKnjUsG0l
	 hQHf1hUVgAOZjeLuruO11dX9gzpdR7FbycMlifCZ8q3KF3aAuAR1lJFR0aW4jAYMjy
	 6A+PzAPaLDlXA7xvU9PaNd1UC1DF6IncDcUOz1vslm6bvAGvUBh04yhtN6UUZHjn/5
	 PzrlrjO8BSwXYO47vs2lJpwtCW35s5rS7YUEJUEDqsDmw/usNG9DunzLzPWZTuzueN
	 XdBOjplDLm7jg==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v3 25/28] mm/damon/sysfs-schemes: move memcg_path_to_id() to sysfs-common
Date: Sat, 16 May 2026 11:37:06 -0700
Message-ID: <20260516183712.81393-26-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260516183712.81393-1-sj@kernel.org>
References: <20260516183712.81393-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 55BBA40006
X-Stat-Signature: 5y9qmk6ndw1grdhf7o4t9x1n4hj7q5p8
X-Rspam-User: 
X-HE-Tag: 1778956970-193644
X-HE-Meta: U2FsdGVkX1/JBQCF2eE0fXt0YeNV4/1K8ih1k/cLfn1KUvuZzFOPDhq1eEzJ+gjV0rGpqpvccimBvXqDPX8sDtvnRP1NJrYdHGLGwTti3gbTP3+Ze2o9kzYbcyP2WRGkOrVC45rkbpHKMvLgs9tIgH8P7yjB57KFdUNfVSQyD/KvJAcK/F44Voyl57fziB5G70OmOVmEbLXqyrWp5ejOynBCgwQMVNlqEfU0Qqw01lkbYsGZVTBosd+RcbBze8C2Cb8nBbN1chFCg5kWag9wCxJLhIq7ue4OXDK41ltViZybICL+V/HoXtOfvRTHW3Q957knk0PqweUfHeNCjSsGIPY2AiV0Tr3VKomdKSRUYYcozWaxKHnlHXIJrGOp7u0hF81RHgtqXovl9cJAqEoskiqI/keQqpwuR+qe1Cxauv4ui5Hs6ruGlyQ0P6pcgwZxL/ztSQLR6+9Y9YQm0BGtKtXOgV1gmBvJk0jg46TksG8c9Y+mWpBcCaVbViJkwsrqgJ7RhrD0A99eQTTsSFkauovHO7r29XzH/3GQH0CCKCjsJltOseQRuIxCboiAE8t7Qo+/v36wHpoiZMJ49E4g3UevRWaNMM/f+VZaF+BwzYw4EfjrF3qTWs9DsdoGkMv3Ht3q7W0BiEyjYAXXzdUbT026iHvIj/l/p/khuKvdk+21rfd94tgBOwo8fDcg00CmUiVCW5t/eI0mHI0jnS1llA5LJfbJpM2+hIwsHmGNj3MYV95z93H3p4DIkg4RsPf1aoDvaMbutpHUXC1KpcACJeiRf4b97kg+ZmIk8l638wkRmwH6Qco6Zm+qhzGpTUCw36BohexSqtKD9w2Laoi6e0QiQDGKlffZRHQwUISQXO0+02hp3QD3dbhL1k9ZI5F49FvSGwCTtKieRYvcH4s2pOASLA7yWNpNIovI1cKVrHY1MGzUY4QsuJR9BB9vFK/jv6VarcqEZaNjMj+qid2
 j5mSIt2j
 2hT/uAkVYAOLi2zkv0eTUlrB1TObKfy9Rtfr0kMu1nd+a7UgQQI4NvDcBaJwOlrwcB5JfthGgQWXB97pCbRL4/0siNJpAsR4S4eMuoRogNfkHQh8sID1+JfeF03bAOrKbAEo/jimvoMvoNzcRSU0r4hoXuXDuXOIpQNp7fF8sFB5bD0/hlnAWC4TlsIwsZmF0S/6PGRodQKt4eQUS7HlNGyWIgpaaPocBUEGxEK93yue2MMpm8A31NH3SlrFraDlMxE17h/OfgU5vAoTMdEW6OpGr6Q==
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
 mm/damon/sysfs-schemes.c | 40 ---------------------------------------
 3 files changed, 43 insertions(+), 40 deletions(-)

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
index d680c785770a9..9462aba9c6cbc 100644
--- a/mm/damon/sysfs-schemes.c
+++ b/mm/damon/sysfs-schemes.c
@@ -2732,46 +2732,6 @@ const struct kobj_type damon_sysfs_schemes_ktype = {
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

