Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 85B42E9A76B
	for <linux-mm@archiver.kernel.org>; Tue, 24 Mar 2026 11:32:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F0B6C6B008C; Tue, 24 Mar 2026 07:32:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EBB566B0092; Tue, 24 Mar 2026 07:32:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DAA6B6B0095; Tue, 24 Mar 2026 07:32:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C71706B008C
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 07:32:22 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 627365FC6A
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 11:32:22 +0000 (UTC)
X-FDA: 84580743324.13.E53BC29
Received: from out-183.mta0.migadu.com (out-183.mta0.migadu.com [91.218.175.183])
	by imf02.hostedemail.com (Postfix) with ESMTP id B9A8080003
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 11:32:20 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=NaNSuwSY;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf02.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.183 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774351941; a=rsa-sha256;
	cv=none;
	b=vGbn7SZ9hZnpm7LAl7MxE5HC+810T6KLHgkNxg6U+g8YYyKE+JXM7T3gUITz9kT4SNQ2Mx
	q0ThMj3cjm2uA8SI43vKw22njkmXfuafuvl7CAFZ+meBRrS8JY5wrldQi46alwSweYfoQq
	Cw4cAcHCt2M6SuYQ7RVNUNJ9f48xpQ0=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=NaNSuwSY;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf02.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.183 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774351941;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BCaKEuNZgtMKShDR3GzW8YFYwaQK2TRr8wn9CI/U184=;
	b=HEIMx0n/qQod1AL0eOkawCaMt+H0BpVfu/O+/iJOeZnYXlirEWDUCLrU7F0VOuCopRoD4P
	rLlBAPEk4Wg1y093f5WC753u81wCbITSXDntE31v/F3mLTNvUXrFshhl6aYm7WQVPJx/fl
	wdhHkpj8ZSuh8dzrgR+swuB1WRz4xVM=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1774351938;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=BCaKEuNZgtMKShDR3GzW8YFYwaQK2TRr8wn9CI/U184=;
	b=NaNSuwSYI6PnCqbD9J36YVjsVWmD6Ny8LaZejVUy68EH3pyfRieEISYijBF4m5yDJeyGRP
	+dj6NIgziOLWGBmGEBSubDSqCvxnQdtELXU2nx8lAbayEDtzZLhTJuRMv+sksKvuRa+Jk5
	QsUBnXjkLaFWa//A4bOe5dINv1WYedY=
From: Qi Zheng <qi.zheng@linux.dev>
To: hannes@cmpxchg.org,
	hughd@google.com,
	mhocko@suse.com,
	roman.gushchin@linux.dev,
	shakeel.butt@linux.dev,
	muchun.song@linux.dev,
	david@kernel.org,
	lorenzo.stoakes@oracle.com,
	ziy@nvidia.com,
	harry.yoo@oracle.com,
	yosry.ahmed@linux.dev,
	imran.f.khan@oracle.com,
	kamalesh.babulal@oracle.com,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	chenridong@huaweicloud.com,
	mkoutny@suse.com,
	akpm@linux-foundation.org,
	hamzamahfooz@linux.microsoft.com,
	apais@linux.microsoft.com,
	lance.yang@linux.dev,
	bhe@redhat.com,
	usamaarif642@gmail.com
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Qi Zheng <zhengqi.arch@bytedance.com>,
	Usama Arif <usama.arif@linux.dev>
Subject: [PATCH] fix: mm: memcontrol: convert objcg to be per-memcg per-node type
Date: Tue, 24 Mar 2026 19:31:26 +0800
Message-ID: <20260324113206.26539-1-qi.zheng@linux.dev>
In-Reply-To: <cover.1774342371.git.zhengqi.arch@bytedance.com>
References: <cover.1774342371.git.zhengqi.arch@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: pc1jkuny1k1ia4mrm41pum8ortrfgeac
X-Rspamd-Queue-Id: B9A8080003
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1774351940-113609
X-HE-Meta: U2FsdGVkX19nFDGpIDo25iPjVJsKf3ElDFMr3gfiC6AG4TPV9GowYvnDUkVbH4xi8KSe6ra0JuVpdiLPSFAHJey/X20OsESWHiBGX8y34s1gBnh5OF1GCP7Gy59MDm1dCgM4dPsBNVv8YZNenFRk37ECtCFNMDQOmdeXtMRZJp5vDKZt3Svu6lWdzhl79N9gs2NoJ0drdfPE/+B1dlTa3w/I8ax1fL648T9xzOJoofbAkm2FC4HJaIq/op7ARovZ++EHHAwZi4LZlG6rOQtVkaKnEu4DSefeCcSSRcb9F9HCDGfv0VtlyAsebBGYtRq8ihzVLIhF5H0VvkB4v6d6jrIMXdUDrNPFZY4rgLbpBGjUjAYEu94su87E/LOvHsjG8AZICzvxJP4Xt45vbm4nRvwL5apL5IIFTYK1pUHitWk4ierU2H9+w+FPWo1G0gX4UYLrz6aUm03MebFIOTNmrwosxXwzqAUuIjWnjbkFvwXY4o63MeFBrozrGnoP8oO0/x2TNX3Pojckxng45+COuD5f9FZdcC6MzsRE1ArXLGQk6TMTXsCnVTVPapwF2figmtMvMeT3ovQpW9CDYWSZ/coStdbuTIfdxcEUTmHyimEXNqAgv0qjs5K3U7xve9hFpp5xX2OUcMgdtXF7MBvf6AmX2bjtPpcP2PSeTBo3fXVxgPio2dY2ob3lAHVXSWRcknhMsQz+35RFcJL7RQtQHbmJ9VhWfvoOSUnFHoK7sRqucGaX81eME+VhlRTAcompK0vvi/gEx3/M3J6cP8JdA/DBk6iJ60RHscm8ROBGucUcsjb/fc/AGo1Tc64nqT76C/jzn7oLOZGfQKdiGlB7qa4mWmiZdaXVpaUpBRaEeQrqA5qVEQ0Gww==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Qi Zheng <zhengqi.arch@bytedance.com>

Reset pn->orig_objcg to NULL to prevent obj_cgroup_put()
from being called agagin in __mem_cgroup_free().

Reported-by: Usama Arif <usama.arif@linux.dev>
Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
---
 mm/memcontrol.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 992a3f5caa62b..ad32639ea5959 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -4140,8 +4140,14 @@ static int mem_cgroup_css_online(struct cgroup_subsys_state *css)
 	for_each_node(nid) {
 		struct mem_cgroup_per_node *pn = memcg->nodeinfo[nid];
 
-		if (pn && pn->orig_objcg)
+		if (pn && pn->orig_objcg) {
 			obj_cgroup_put(pn->orig_objcg);
+			/*
+			 * Reset pn->orig_objcg to NULL to prevent obj_cgroup_put()
+			 * from being called agagin in __mem_cgroup_free().
+			 */
+			pn->orig_objcg = NULL;
+		}
 	}
 	free_shrinker_info(memcg);
 offline_kmem:
-- 
2.20.1


