Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4659BCCD184
	for <linux-mm@archiver.kernel.org>; Thu,  9 Oct 2025 21:21:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 758188E00B2; Thu,  9 Oct 2025 17:20:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 730578E0002; Thu,  9 Oct 2025 17:20:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5AA828E00B2; Thu,  9 Oct 2025 17:20:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 3050F8E0002
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 17:20:56 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id DD5E8BD1DD
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 21:20:55 +0000 (UTC)
X-FDA: 83979845670.12.653BF16
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf02.hostedemail.com (Postfix) with ESMTP id 652A980010
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 21:20:54 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=cwwztoHQ;
	spf=pass (imf02.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760044854;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WmloNy9hmOA6N/9Pp4Wt7SLFwcCoUc3bRTsbzbgtvnQ=;
	b=Nk+NLFSPu8ohSD/Za7Td+87PXN4iVvppc8A11fLFzsqWMggWhSOY99u5Zwwu/IEAHwjnpe
	zNHJB55+IQvLtuA17q017aXZi8iOIdwBz3IYM5RjFvLhQVP8a1qNkchRKsk07r3/sH6NXA
	Dyg7SmqoZMnewdvTt6TiaREsQrbOqCk=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=cwwztoHQ;
	spf=pass (imf02.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760044854; a=rsa-sha256;
	cv=none;
	b=ToFhM9Q7RDhbflxiggsZKnIu7kK9sC4d11IaaiZEsM/Rm+JtiBPPMhktZcy5paAW1+qdDd
	5Mfl0etjWWAd4mYKxRVx4doSdm5oWBPNkhItKPPpcvntFeW+tl7b7T3AU4iSL9F0K4MuoN
	O0cskrzCLMzktlq4K0ZwWLSiCyxAa88=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id C195562420;
	Thu,  9 Oct 2025 21:20:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 678EAC116B1;
	Thu,  9 Oct 2025 21:20:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760044853;
	bh=HTdQH6mS8J+MYD3Rj6pztEN9kH+IjfPCcbROi0+eWaY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cwwztoHQq0gOcUnJhit9e34YwWQL1uZxDEk3qMp3ncNP0zWYl+8aCxSBwwT/s171Y
	 pN3DDPCQayfFcwVCLZc3jsdyFnVGQ1rLXDNPoTjBK/rquZ/pFLQw2UIuyTJnkhGfT+
	 CvuTkinu3pEdQkgy2C+GSfZ1qJNmJnNsuzakgsM9c8wAm6uilNyWneV5KX5L2KnDqc
	 W8w6P8XPeQPCVFRjwQ8IRe1bQR8n1nxzY0IJrd64qV3I3QWafo2bCYYrxA/2l1xjEX
	 bzPdq7GL3XSozfrTBGW3QRrCJX96184b+EKytuCv5b8BmevNQxMlA4Vtnsafcm5f9D
	 iCC9XZQOc5dgQ==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	kernel-team@meta.com,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v2 05/10] mm/damon/sysfs-schemes: support DAMOS_QUOTA_NODE_MEMCG_USED_BP
Date: Thu,  9 Oct 2025 14:20:37 -0700
Message-Id: <20251009212042.60084-6-sj@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20251009212042.60084-1-sj@kernel.org>
References: <20251009212042.60084-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 652A980010
X-Stat-Signature: 161jypdqndnit4466fneru9d3imcm37i
X-Rspam-User: 
X-HE-Tag: 1760044854-750443
X-HE-Meta: U2FsdGVkX1+xeBwyS6xZdLkOepLK8WcaOtiEpjJZuliG+LSL5KH35O9XoApDbzf2Ew5G/+mYe5ZeA/0zOxX4LK4q36YD2cZwoAl4azUjZJU26eduwMKYWDKPkHJyDsuhwqtoYJhzeVywB5kU0liqS0EaHZRnWEWIz109oWlXahww1IddhsE3+Xw5wJraboMNxAoSoWIlzCpYZG3DYWw3SP2+ygj3CiKuw9rNTl3yr2Tha0H5xhPSGcS+hySPt/4l/SCrBi3tZifi6uvBND6jdyp9BCO6qCh6GlarF+gkriWRU5e5caXovhTQd3m2k6lzMOBdibLiX9LvG1ayDFs/v0wHC5UOOnR5lUzF0yduzlj45z9J0tMxDwY3ZDisSkbcDyjnNnXTCzaU/Q1h6eeGqJMtAyed9uFUKFrgdVG96JQQmLzDVW27y66H4tPoCMfDl89EPKLv69La2VIzO8SdRn/fEIZf84x4QE2b5r2goWEZavDrcXvz552Unpu4bf0i6QFTWV2J2i8rpA+BY30UosIF4NEKWUeowQQ3d0f9nk2e9Br9636WxhuPfIuHrWVC/EJFF0k3Y2/u8OscQmvYym7y/tR01BwZKCWtoUvqCeQuEiLKrryqWnr/18MS1QH5mfmbFceysjVgj9hh7nHqJyZY6jXJctf9SdKpXO1zGBSaicPG+ONi3YRSplr8+vscLXT6aVQJA5R4+pMPEfXaWKMIp7sNoGaAtouf6M1kvLmv43JxSDP96xK02S6FCAQokKO+C4jkVtU1E/2BmaUvJgRzouVVL81EsiLq70UmDj44JMWEFWGNV2qxJjjnZhaU8H27u6DIw0iwFQ8MAtCPRaBOBq9tOUo6VX+lOu5l4xY+2wSrXsirBVbYDOhsUNSGm6dULYnQI7Q3NFsbQcg3vwyCKncQr5jR5LadmFXOb0d21lPbOZloRPevaX+z94wN954nPZI9HQwDKogGHVK
 S7tk13an
 00lI7jmMp3mAU5Z6nTR1Wdzs4OVUJS7HYkA3wVPLItMQVTrv5L9gFEjsWPoupazcfJ/D5S7vl5CSLABB0Hp/7LNJce31c8yswPyabzi9r9BPZ6ax8I7UrezBfz73qfhLG5EA+A2gk8dA+wd7V0E9Zz3bfIdSu04k0JtbZ0JzJdqrKmonCqw2uko8wW86eNa0ib8mVPzy4xaAP/r2rtcdAXCWVw6/kVBD3MFgSswR3f1MSZJn0TE3OW3m6+LfsGp8D1q1EH/S6wMWZ75pi2jTM1el6Ew==
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
2.39.5

