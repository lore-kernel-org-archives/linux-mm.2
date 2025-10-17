Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1347FCCD199
	for <linux-mm@archiver.kernel.org>; Fri, 17 Oct 2025 21:27:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 314F78E0012; Fri, 17 Oct 2025 17:27:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 023BE8E008A; Fri, 17 Oct 2025 17:27:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8AFE68E005D; Fri, 17 Oct 2025 17:27:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 121C58E0012
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 17:27:18 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id CA79C13A7D9
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 21:27:17 +0000 (UTC)
X-FDA: 84008892114.10.BD77789
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id 27F3A100005
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 21:27:15 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=bXPurDvo;
	spf=pass (imf14.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760736436;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JgMmGlEyMU+rV9IRBbdimsiRco5lmCECp8O5PzaYOOA=;
	b=JC83/eERyFh/jRLv/yEB479IWRYzmuXpx79Ywid5AdE7hCWAVvbddPCveXBLE7vqJuQM/4
	Ka+Tuk3lJKVkDwQhvqE7DWC7X5tWhv3I9/goFLXuS8f3y3z1O4WtxVENnSydMKftfWP+/S
	HeSWfUOsKuGXeobr/+BpF/0WU9tuG/U=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=bXPurDvo;
	spf=pass (imf14.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760736436; a=rsa-sha256;
	cv=none;
	b=yiAIspuqMAOFvcjNjGLvnn8a45RwJi+l0YdOGw7jWFkzXKOrKV43qA7HKW182r2fUExESF
	FbBRHKEdwe3YCt9OAgKuGmcSENGQaoIjYlVzuHdr2/JlRXZFUetecSUoNjz39laf+DPKFB
	OBJ1VYYlsY7eTZGWW4FVa/Uh62/6neI=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 2CC264BACB;
	Fri, 17 Oct 2025 21:27:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0FB7C4CEF9;
	Fri, 17 Oct 2025 21:27:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760736435;
	bh=n763b0RvpTofaCr5BebrQgTgr0bAylRbyPom2ZqFCig=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bXPurDvoVIqh6Gs78MmE9b9zfXanaNR/Zyl3bbgzgt2brOSRKT5h5EmzoXmXS8708
	 pgULRBZdxO/78W0f6MUUiCDe3zOlAx3VQ1EpInR+bm0eJ28d5Nf2uCz6OqYJ+nKGw3
	 tLnhskbnFaoR5JtWXw5TruFQP4oQbs4hdCdyKJy19gW3hD11mAlLGUVvssb/LpKbs3
	 GJrw5FOsg9E6sB1QHWcfbOdyNYYIxhv1Q3lnzpF7pebwDT6AfWx53aKCHrqaMGruma
	 aeCC4uYHQGGtJ0HKvXt+pkcFZN0bbegKwbenrkG3oUfIE/PWbb6h06Dtgxv6llZFyZ
	 ot/eb8MQm9AqQ==
From: SeongJae Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SeongJae Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 05/10] mm/damon/sysfs-schemes: support DAMOS_QUOTA_NODE_MEMCG_USED_BP
Date: Fri, 17 Oct 2025 14:26:57 -0700
Message-ID: <20251017212706.183502-6-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251017212706.183502-1-sj@kernel.org>
References: <20251017212706.183502-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: f5iounzyw3fknr5i93s3oahboi44s73y
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 27F3A100005
X-HE-Tag: 1760736435-976798
X-HE-Meta: U2FsdGVkX180PQwDKJxWEGfh0v49EWZTAS7KmGpuhg8Hb6rlMwuTiAEpIjcz7xqsP4y/nDTT3CjTf2K5Rt58xK9tAwPbIRUMRM73Y9KLBPIAfPrCT61E6Ro7D4qYTqKRexDmlLqbqSVBnTeweXWL3n5cLy6Fkunr1l9rU2nEU+MlLiz1x3Y7E1z11AutpILDKfyXIjQ6M1EdPStFR23V3ai49ksBPOmCvykaWgLdhdt0Oo0xyVYwhpTKukY4jytj8lw1O/SgyxxXBq2fBByRLncXhhNHGf54utFSbyBf79SQtuQHhAhAD5WfrsBqlw+H9QNkXr/vwi5hT2BDCp9LMPQ9Jvup6w3CoQ+nNc2cE8KqyzlzLGR3b4qDRbJZJesHxN7yjVM5CekojaOOozkAy2nZCBgWd+ljjjtX7Ssr0y9IpU+VY7iPzJwmqIpQbhrZUqGempioDQ5ru+871jT/E2h1xz7u6ysKT1QWDUqmmmWns4nmluiuge8UKyXcwJ2KjJ3oEc50+KBJIFjspVf6BtMzGYAbEryW2e1J66CjFanADAFXp+gCePsdlSkOqkQfvDszQnnGllBsv9pZMDGqTg0VEJjdJaQYFlRmxDn+QkzguD1ZlxfEb9FjgaqOEO2PKi/FA6EGBQQABvgVSsL5PqqPkRrOY8zBJ3eiCnzzWuvbQKffTh2orJIEMaNkwruBpFjolk3vT9IJfYH9z06bBaXQdVEgg6siyW+Wpt0vJJ/sDHqPorh1Oe29nJ1SAKMtYrElXfnKJAJt6JU8XIsE0G/JJiztMQtLVrigo+QyHYd4bSoKN502zyKM4Jm6OAim+AQhQ98Pygj7hxt8CuGkYBdRRxhzuPsE2WpncdtC0ohCbSLfpRvbLx5ZxQasF6ynLICbwbXuFBYGRsV/tQOCjH3qvnBEk8zkKp9pN3gfUaIBK6Cn7k7MFV+/Z62Uo79e0JYX8X/s6DytVKO4wVc
 ECaVO0D+
 FRjTFMEGEOfJC7GTuxJNDvvT/euwfGKSWCiqRsqgUbgC15XeIEus9wRTlNm3G5of2yJnkLc/D+2kjPYKeJmfap9PcH1GiIrLhZ8WemLfe+FL8hQMhQ9SjbGng+KTMCAuhXxxLtXllsBkEoc6T8TJIMmmQyn/Z3ILEjdWdN1d2pfYVzMm+Eka/Uxq/TWdvAfV2kcXnzqlCupnfjlPK+aL8uaNgZUOlbVtQvN/1Vr5AkFNtT1zfpCrUYgOyFBDRjf5ujccpNue76oQEYG9AjBw9sb23yg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add support of DAMOS_QUOTA_NODE_MEMCG_USED_BP.  For this, extend quota
goal metric inputs for the new metric, and update DAMOS core layer
request construction logic to set the target cgroup, which is specified
by the user, via the 'path' file.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 mm/damon/sysfs-schemes.c | 15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

diff --git a/mm/damon/sysfs-schemes.c b/mm/damon/sysfs-schemes.c
index 2c440a2b80e6..c679e62fd4b9 100644
--- a/mm/damon/sysfs-schemes.c
+++ b/mm/damon/sysfs-schemes.c
@@ -1030,6 +1030,10 @@ struct damos_sysfs_qgoal_metric_name damos_sysfs_qgoal_metric_names[] = {
 		.metric = DAMOS_QUOTA_NODE_MEM_FREE_BP,
 		.name = "node_mem_free_bp",
 	},
+	{
+		.metric = DAMOS_QUOTA_NODE_MEMCG_USED_BP,
+		.name = "node_memcg_used_bp",
+	},
 };
 
 static ssize_t target_metric_show(struct kobject *kobj,
@@ -2526,7 +2530,7 @@ static int damos_sysfs_add_quota_score(
 		struct damos_quota *quota)
 {
 	struct damos_quota_goal *goal;
-	int i;
+	int i, err;
 
 	for (i = 0; i < sysfs_goals->nr; i++) {
 		struct damos_sysfs_quota_goal *sysfs_goal =
@@ -2547,6 +2551,15 @@ static int damos_sysfs_add_quota_score(
 		case DAMOS_QUOTA_NODE_MEM_FREE_BP:
 			goal->nid = sysfs_goal->nid;
 			break;
+		case DAMOS_QUOTA_NODE_MEMCG_USED_BP:
+			err = damon_sysfs_memcg_path_to_id(
+					sysfs_goal->path, &goal->memcg_id);
+			if (err) {
+				damos_destroy_quota_goal(goal);
+				return err;
+			}
+			goal->nid = sysfs_goal->nid;
+			break;
 		default:
 			break;
 		}
-- 
2.47.3

