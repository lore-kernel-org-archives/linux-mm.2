Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 99577CD4F3D
	for <linux-mm@archiver.kernel.org>; Fri, 15 May 2026 00:45:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 867876B00AB; Thu, 14 May 2026 20:45:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 817CE6B00AC; Thu, 14 May 2026 20:45:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 707336B00AD; Thu, 14 May 2026 20:45:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 577496B00AB
	for <linux-mm@kvack.org>; Thu, 14 May 2026 20:45:00 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 171D94065E
	for <linux-mm@kvack.org>; Fri, 15 May 2026 00:45:00 +0000 (UTC)
X-FDA: 84767809560.11.2D870AB
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf30.hostedemail.com (Postfix) with ESMTP id 8728A80008
	for <linux-mm@kvack.org>; Fri, 15 May 2026 00:44:58 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=DNX6r3YH;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778805898;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yZvYn7s5Cj9vXycsI0aCOv+QGFFy7jZ5ss+JIZh3szw=;
	b=NqvDkykt+SZv2yfx2ATyNc8+1wZKByiPpDFAHAR7VxOE7iiIgTyV0Cs8ObhxZxELF8sMD4
	KA6pUW8x0PWCV9MpsifIORqMHVNVC86vqramJ+/gz3TX6mRuF/lFqQZO8dydju+SFHkroM
	fc6yN2l5kIChQPgdmcaqCUMgUTsHVSM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778805898; a=rsa-sha256;
	cv=none;
	b=1Pnvd9oxW9rRBURZYz44tG75X98R3IzhcjjIV3cFs3EqIuw0fifHbN0ffwY1kxPXmfAwMq
	jMBXJA6FKfxK6T42HHdgD1zf4Deo2YqQgG5AW4GhWMP0KQdvcPQn628C+E9Rm1G+qwWHgp
	aTGGTCJjd7+DkhROBRndpWmJazjzgVg=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=DNX6r3YH;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 16D8761143;
	Fri, 15 May 2026 00:44:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C545C2BCF5;
	Fri, 15 May 2026 00:44:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778805897;
	bh=91vAwCvsnDDGZ8DbEONtLZN4Ag+nx3FvJWUyLnt0KZ0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DNX6r3YHo3mglvkQ1wAYFifwXjwYeX/JziaMJ7dlRr9CHCcdESTBWQ9ME7Kk4hVFB
	 SrkcKtQGNsI4vSyzKLvo8IQsLJzUssUV66Yd4WqYS2Ltk3X8v8La9QcU5pL3reNdGk
	 1MpcsF9AZ/15r0CBdqo5hMC3INPEPJI9lh1XxwPTnNYs/9OaNapkNq0gQVcxqhQcdG
	 JK2wQ2vH/CoVaFAJvrWAkCYN5fgK9pvlupEExTsqfVJtR7A7L4JR+D8ol4hFTP5JGx
	 VL9F9VT42XEJ8hW+0NNiAcyWlLNBUmnwcQ0C1vEduaxRsfMEx+PnVI0q0TUJ04vzKk
	 PFs+idCoVEidw==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v2.2 25/28] mm/damon/sysfs-schemes: move memcg_path_to_id() to sysfs-common
Date: Thu, 14 May 2026 17:44:26 -0700
Message-ID: <20260515004433.128933-26-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260515004433.128933-1-sj@kernel.org>
References: <20260515004433.128933-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 8728A80008
X-Stat-Signature: ab89hboooixpf3qarcdbck4hdccshbku
X-Rspam-User: 
X-HE-Tag: 1778805898-552024
X-HE-Meta: U2FsdGVkX1/M1gwXtYKr9KvjMMF9pbIqxQFyLAPyBu+Kst7X/6iHm9j6eS9xxqcN0flEvExPYvnIttDqD54yPWsOf5louc19XMszqKCxXFIinDjSNBx7b/iXKxNMV0h12+1kr8Y6ROYZfV2QkCstMOQaTSGsiWBlCpb/AOh/t5wbmCaAefasVu1HUtIQQFEBR2L5U0+N8mupU5/AAYC69Q8SWaKXMRNktBbTvc6WiQKK9oeP9wRS8HRftiBrVuJ0qu/R58tldaP0Ss5y52eI72qXNVAe0u3GhrV37nvrYpg20nOMvXC3E2TwOXi6Pk2n+oum06C+caywED6VTcWFiYlA1hIQcG7kSyUfm/Vkx5uL36KDyfOhyZoWXaUKRz2ZPblNZEsurRpANucBj6XlQs19Kt+M2h26mTTo6t5oF+l4lvnJk9/XS+++86+CWHIwF/YCOgDAYIvjv5LITczJKwYu7RidIKjEbNke/55WQg25uBCMthV2X/XDI/AncVR52eyZ58AoC2lAs9XTKwW4FVxT9PJ8V6RC/A3KgYHo4k66sYkJ9TY8cy/tLF2u4lv5awOqpGU0K59RSK49XKAhurwojxjN/sHOo3swXH8ESU77I/swfCRzoWIAOowG2/rMJjAbuXLrvLNSX8ZsQ1aJqR2bFTmvYafDw+whSnEaJqR6b/0ETe0boqg5k/k+TJZWBQxUGzswgdd594bBffRgCjNOf3MpEJhhx3MCTiSNhz2B/+i9gNZ6IF0ei68PUXLHe/U/a8DFk0OpTEfRcHQKLDIxBroRehEu8MgLnoBXV5t1BAbRERaZrkCHPwDUodYP+et8YyECMb6uPqjqqYvakB+L1JI4bicSdZMdS1Om1PsJojf82KLK0pJrLCEQ9x9CbWFocs8sV2UaNYpjKXH4YGD0whCjF4NqUfaNsQufwhZNjk3CDwMztnEoC4poL4J76nesj+PxSErqKdcm9mV
 h2Xzsp+i
 ZIScyPfSSCbcdwd6A1DdqJ/OrLUVkTCn/2IpYLQHtQRam0R7iJixSA9KYXvgTHwWpIkXSqhzBdFUbWUEftal5V5i+hwnU+aKvXN1eNHSa3iGEoiqmqo5yXC2hLiHqWVA7dHGip69yWlIwXXHobWK+r0JU/0FLWijpdrXkqeSm/icxYxq8zwr9mk7LfMxpda7Q9U+fFEk414eLJZIXTr4aY+qg3axS7edf9Q1+hNbi2GFFcHw6DDo6FZu8to1aj/eGvZXZLv+pPk0+No+EpbhoMm6SHQ==
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
index 36f6e4bc57ba7..b8c164b6759cb 100644
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

