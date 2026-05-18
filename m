Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 63729CD343F
	for <linux-mm@archiver.kernel.org>; Mon, 18 May 2026 23:42:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1F3C06B00D1; Mon, 18 May 2026 19:41:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1802B6B00D5; Mon, 18 May 2026 19:41:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E76986B00D1; Mon, 18 May 2026 19:41:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id CA3F06B00D0
	for <linux-mm@kvack.org>; Mon, 18 May 2026 19:41:35 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 96AF91C20F6
	for <linux-mm@kvack.org>; Mon, 18 May 2026 23:41:35 +0000 (UTC)
X-FDA: 84782164950.16.6076001
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf07.hostedemail.com (Postfix) with ESMTP id D97964000D
	for <linux-mm@kvack.org>; Mon, 18 May 2026 23:41:33 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="o/Cy9yu6";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779147693;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sFaMlG/PhcrEyPv8jaSO7AT6//BIIl+ntsrA5GQ2zHM=;
	b=Mv6pGU7HgCru5dg+5NZtZ4F4xJ4NVy9h0TtU9cNdkLobpIOjDKU7oaJjWPWplANl3t8YCq
	cA0owmFfUyj0pn+UX+ydKgMxmGMuNz28HyXgy7MGH7oYjlL+mUjWA6P7Ex35nCo6+7YjHJ
	S/DuR7aHGBVeCRnVyKevoTf1+ltXzVc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779147693; a=rsa-sha256;
	cv=none;
	b=xSszS4K0bLqgyetDMkm0Uhpct4d2/ROcXoUHkUPGvrEfC0+p7RVIUvecAC1Vc6K2aRbBVG
	i/cX+rRj7/4VxtzN+lWoyPggIO1m3bUeE99+HIvqo9BsOjqUz27x7bAiLP/TCWMeqxA93/
	IQuDjq1pNr8LbTKEzL4J1GNKwMk6KEk=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="o/Cy9yu6";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 6A6D6601E4;
	Mon, 18 May 2026 23:41:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA329C2BCB8;
	Mon, 18 May 2026 23:41:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1779147693;
	bh=3s3z69DVFkBSKLZyIG6U8q13xayntuiDZ22yXUYaX4Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=o/Cy9yu6wDJmrd5LvgJQlhFZQKQMd+FYHdPtHHdwH8LcfwzNqCgCi7UvFFMBoh1J6
	 FBk/AYuGD4CtsTAx+LMzhNWYHGHl+499fKP4ZJFHY1oZ/mcVOZtJ+HW5Weo1T6ksyU
	 hoCgRdPQuOHxzHx6H9dvxkjdnOBssO4xAUM6nk4hwkiLTSbS/AeYgzQdrJqpHs+JN9
	 1hE6NwrYoi2hw4/xGwp+CK93A88XaqglyB27Y1vsAtX6bWDphgIl4+J3p8UtrhYvhq
	 qe+wFKoBU+tEuJVVBLhVjVkWrHVQThGD4k5SltvkxRAhcpqCaH5kh1wzs5Z8yBTID6
	 DfhKcR6rmaJhQ==
From: SeongJae Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SeongJae Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 25/28] mm/damon/sysfs-schemes: move memcg_path_to_id() to sysfs-common
Date: Mon, 18 May 2026 16:41:13 -0700
Message-ID: <20260518234119.97569-26-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260518234119.97569-1-sj@kernel.org>
References: <20260518234119.97569-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: D97964000D
X-Stat-Signature: 54jmj4rxpkocqr33eym377sz1dye1bfn
X-Rspam-User: 
X-HE-Tag: 1779147693-135191
X-HE-Meta: U2FsdGVkX18C71Q6CFsk0LeuZbNLhAOVaXvKyx0r0xKvYXAzwhJwvKh0g/vdhnRSxYWjfaBO9hPIO6LA/uKSxCKG8Ep/FU59UynApab+uV/AgUeP4JO6rbbgLm97CAEttbDI/Ny1DbPI5EetwCWqvwS7A/29sE+T8Z2GY2vC0zfxMR7px296tMK5SyZyYZJzA4PQcXzfZxLd09y7GA8qx78VNl652pA57NLl4RWrdWyU9xJhtY5/IOsQuvInkww2IxKSfFRNPDFFrdcpqZJ02yZFZyIgCpu7e1VIhwuZZx8lOd4qHKEPcRiVnfvE2fxtkJKmwia862L/H1v/LLlbcPzAJhouABnun1StB+a+fr4X4oaD2HxTSTUo6B6rdhOH4pvC7LKvNy8bn3b+SJsrhsMuUe7NytvJFd/QStSPfln/IKk7WnW4pQi7xpajmtHvJ61S5FEn11A66/XIW7Y3tZIwtGjxKR8sRyYvwmagxXIBlh4i46PcXQ3VL+DqnBjqJ7ftBn2LNtAB+nz4rTYf5qW4r/EiN/NPC2EVOD7KT5vUpD53cEnIEIiX7TDYoBiVSXuVGfMePKb+7iFn6lMHJzTIGbS9DWFPJk062ZpMKN8Thu1+h7opdg9JlYkkNhZOq2OfqW0w6QuxSVowjUi1QDEXJq1xGyU5lfCAgSNUE4x+ffnZkyAAfLRuSRqQbaxnRNGCFHDmPtgx7X/SbdMzdXkL5dcf0DQm6Qtw0/PZTNAtYR2aoJ8ZpETRVa1E2HiS2pWq13TDnP66XiLfbsxhs31f+YPPWDLiXX8YVGEknGVgtm8BN990YO1hbARhlNHCmhtQto+gWhaB1lvJBqwLt+WbFmE1OEgFW7aofhZy/kHsf4eMPrhp2E9MUGg+QtkUK2xXr8Ql5enEW65LXPHc3l+XqKjU1BSvfSRSfHRkcG/B6rGs7/6QVZqKV9VD4t61ycOibE5qYe/3/UHZFT0
 8Cm9VXhM
 Rkwuvuq5YQokTTPzelrMN3m4j/q5mmZVabaJX6lKt6kLPI4LVTU8yitjmFZRmbbXDBWjfRMYRGAXsEt/E/4c3C2IIv4z3Mg+mIICaeRZBJ4/KJbBh9b9wfPqQN/KYK3++8TYWF6Y5S1UQKjj0ZRavsbrL9BybDt/aU5kPwBBe0HbNvXiGZxEhi2KjdY0gPCuDtP6QGhdBxYJ9lSAOxZ2gqxE/QnbYYfGGKbfQzhvYHKuyFPbV8wWHwSWJQ3EvSbM1ZZZEmiGfDOaZy5+8hKiIkuGyaw==
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
index e25f4824b72fd..329cfd0bbe9f3 100644
--- a/mm/damon/sysfs-schemes.c
+++ b/mm/damon/sysfs-schemes.c
@@ -2791,47 +2791,6 @@ const struct kobj_type damon_sysfs_schemes_ktype = {
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

