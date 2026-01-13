Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 07BC4D2F339
	for <linux-mm@archiver.kernel.org>; Tue, 13 Jan 2026 15:27:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A79FF6B008C; Tue, 13 Jan 2026 10:27:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A4D156B0093; Tue, 13 Jan 2026 10:27:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8318D6B0095; Tue, 13 Jan 2026 10:27:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 40E716B0092
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 10:27:34 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id E8BFF1401A9
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 15:27:33 +0000 (UTC)
X-FDA: 84327319986.14.0B82277
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id 26BC44000D
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 15:27:31 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=RwOWgdQb;
	spf=pass (imf12.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768318052;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FO0Z9MlkH+d2MgRUsi6pU8HCVFyqzwNWAZJs2n/LFo4=;
	b=y2OUUciCAe3Xjznys7cucbXfpMHrOckWk/TwQi7fyHZdIsJwO59EY8D+zfH1+pq0aqQWRt
	SrdIKo2zID6nNG5WCOoRM1j/2UqZKPOuPc8spgXy91tAZ18F/rcLjbzDb9EaDv/EZU2wYl
	aHLJE27HQw32p1wnfsLiiD/LUB41QJQ=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=RwOWgdQb;
	spf=pass (imf12.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768318052; a=rsa-sha256;
	cv=none;
	b=ipTokUIqRrTx+D43tnA/a5O18TCSQI++N79paTHbQa+1LsQxxlKUWr8Wp1VCR3SMWtdngr
	E9ae+rAUOctfLjqxkLNbfiXA938mKqunoK6V8JnvOiDhXuLm/Ztcq81L3E3fj6p1s9TLOC
	S7TYY6V6zMcqpx0SEBq28EmLEDYhKzM=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id E5FB44432B;
	Tue, 13 Jan 2026 15:27:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4D71C19422;
	Tue, 13 Jan 2026 15:27:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768318050;
	bh=1yLzbYEUiETjkqkRJcB6Pqye8DL4YZB4qDv/HnOmOps=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RwOWgdQbKo9fy3X4sYy5porDOpEkj5B8IZSuP7I1voJXWf0bUifkU7luWi7BAelAG
	 EBp/NJl+5Neo2tfWcVA/cxrjFOsXWAZ2XMX8JbaOw+aolPfDPm3+eVoo+5FLjarI5S
	 N3tnJOfb76yBcvBxTTZU4gpvsqsInowHNEsr/rPR5mXP2OFoODacz2H4r8Ps6qcsxS
	 SfOrlcZ/rKvRNo5NVdcY5hWqkwz0s14IIoBg9Wm1EDUetYIucnzEJyqZqMWWSOHSL3
	 nngr2TF2IdrVx1b14UpB8ea1TUgkcUYzAqpnHXnhfxCt8m5ES4xFx7N2AUcUCFBoCM
	 88J7IWrf+VTnQ==
From: SeongJae Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SeongJae Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 02/11] mm/damon/sysfs-schemes: support DAMOS_QUOTA_[IN]ACTIVE_MEM_BP
Date: Tue, 13 Jan 2026 07:27:07 -0800
Message-ID: <20260113152717.70459-3-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260113152717.70459-1-sj@kernel.org>
References: <20260113152717.70459-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: oqq1nbx778zam9gcc7pyh8d4mr8pr4bu
X-Rspamd-Queue-Id: 26BC44000D
X-Rspamd-Server: rspam04
X-HE-Tag: 1768318051-645885
X-HE-Meta: U2FsdGVkX1+5hyUeO4t3fYT8691lRcbXVhh2+p4Ycgpm+V/UemaYv92VQYZbTnZcTje4Fgq4ilKt31/rhm2K7idVlK+LPqgbAdThgnS4F/LS2oFO+XghxpF2g8AeFsR2uyX1ZkSgUNlMNloTVRjfUN6Yot3zlUU2B48mB1uNKVsaxWFRPSkRpu2XVDcDXHIn+l4DK9Nimr8HvS+CWjfQXfKSvTsRCctjuAf8ZBpmUUVuN6p/NuW9hyNrWueynqxGdTTZ7DCpPkfirtAETH8uMff3gXZZuLFgUWdlvogiVeXCKga1JjZ/k+/yvsSc53+uXShu5EOM04CC7eMWW/8TeiIrawtPolycFf8RftTEUKPo/w7plpAduAG915qfRKsTBPUig01dGRQ3uzhBuHRkwroyn2Z6r0bKobaTzxW/GK03/wxDb2Rhq9r5Rfqr5OYOxulh0rP2NaFOLJ86yAubUdlYzfI85d/Yio5rpbX3pQurWprc2PkIWTEwulUU+kvkNkYMJKv0VKbInYmX9lsqwwTrJq9aYUpomy99nx9a9Be12dMcS+GoeMdKj1LwSHt+x3cbndbiF8cFtB2TjAujkI50FYdtXbHrk0rLmcLT6BPYZhqOorvF25z/HxEOm0zskHr3JMq+ly8pbMmMDgs6NwvTJS4vJF4jvHjvBfgkigHd7WwEBuvduW+gn1b9wY+8yVjtMPKrtWOnw2rS8pgakjgcTHSb2lZqbXdlBXL8Ageez/RNYqPuRsokMeS7dgiqEmma8Pf+JkqcY4r4NTSYi6sjo2dQAyCg3qh1IXSBI3WwPRBb8vEQU06EEjhtNTrt0QUbzvXPhodBf7Kvly0lwx727SpECiBjg9TUu2mrX7i3YWSV8LITJvoHj7Dl69vk8VMZInyAwyAPOv/+lwts0+Q0YSJwf/7ftQjVaDPFD+nwTO5EDINV740imf89LO7fv762xrKoN1btm7ak5lT
 tQPHuErT
 b0p6DDP7UWoZwO2DDFn+5z3alQs2JlihORfGsL26MV9QySpKOL26a8HZlFbYt1zHO9RbI43520rRigXnvvYMkKMnmKLR0sJBFE4tzfPSRu1zGgzCPkCOtZBgXsMDIkyT9T1aKz/rFMJIQOnPPV/eLOb2M9t0w/UPx7isdswvFmYhCsUMwEnEA/5qYx0fOcwe3Va2aD0/UDqObUZEjEi5vABuPdN1ozrPxnfZ9ei3rtgxcd1hBlINtCb5NQWRD4SULgBdpr7iOlTNEGeD/esy05tu+BQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add support of DAMOS_QUOTA_[IN]ACTIVE_MEM_BP on DAMON sysfs interface.
Users can use [in]active_mem_bp keyword input to the target_metric sysfs
file to use the new DAMOS quota auto-tune target metrics.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 mm/damon/sysfs-schemes.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/mm/damon/sysfs-schemes.c b/mm/damon/sysfs-schemes.c
index 419d6e7ee945..2b05a6477188 100644
--- a/mm/damon/sysfs-schemes.c
+++ b/mm/damon/sysfs-schemes.c
@@ -1079,6 +1079,14 @@ struct damos_sysfs_qgoal_metric_name damos_sysfs_qgoal_metric_names[] = {
 		.metric = DAMOS_QUOTA_NODE_MEMCG_FREE_BP,
 		.name = "node_memcg_free_bp",
 	},
+	{
+		.metric = DAMOS_QUOTA_ACTIVE_MEM_BP,
+		.name = "active_mem_bp",
+	},
+	{
+		.metric = DAMOS_QUOTA_INACTIVE_MEM_BP,
+		.name = "inactive_mem_bp",
+	},
 };
 
 static ssize_t target_metric_show(struct kobject *kobj,
-- 
2.47.3

