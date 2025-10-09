Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AA46ACCD184
	for <linux-mm@archiver.kernel.org>; Thu,  9 Oct 2025 21:21:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 92C9E8E00B4; Thu,  9 Oct 2025 17:20:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 88D268E0002; Thu,  9 Oct 2025 17:20:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 756BE8E00B4; Thu,  9 Oct 2025 17:20:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5D3E68E0002
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 17:20:58 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 187E55C673
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 21:20:58 +0000 (UTC)
X-FDA: 83979845796.08.509746A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf11.hostedemail.com (Postfix) with ESMTP id 89C3D40007
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 21:20:56 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=tz90siZg;
	spf=pass (imf11.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760044856;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/rcgYZ4V6BL/hQnxtqXLkZW/oOHx9ZyGJvp5onxEBmU=;
	b=mQKBtVo7c1XmyPybGj/ScHrzHZVqk9lYxSkZifVsnQKbX25Hf38ch9YlHk+sOY9w8890de
	kaKTnF+mATXMJyz16Ai0OZ3U8FHvBWouJ7nC1TDigxTt0HpqKPh479BbcyPIgvWfkWvFQP
	3xSda8Gl04HyUlAukFiIrJPq5A+a+hU=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=tz90siZg;
	spf=pass (imf11.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760044856; a=rsa-sha256;
	cv=none;
	b=uN39OdoqA4872hmiC/ViJs8oBzz62qn6FtW0UZ8p1sW27c2wI+TEhCa52c9B+eY80d1Qs5
	BYC+wm7KBxoPJ1Ij9WMzv2vr3zKAcCh40aGG26KF2b/VWB44ydD5f+YC1XSdMWu1dO3hM0
	BeYolCXCXV7WN9so738tVltSr2htPz8=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id F1AB46243A;
	Thu,  9 Oct 2025 21:20:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9BA1CC116D0;
	Thu,  9 Oct 2025 21:20:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760044855;
	bh=LW/6mDf7N5tp3NVaa/MTw5MzAUr1eIrJZfX1KpNkybA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tz90siZgJeVmm6nJG5948QdV75YE3e3vx6SMoOo30urTFGr8SXMhYgE1BdGVItvUE
	 ao0smPENqeNMT+3IRdPWVPkxrh63rfPjDqPIqecuGVQgdowuXFvPOtSEqlf6S3WU7w
	 sIlL7ZjanGac5t9WD7wpXlJFwiy0yainSj6eVtsZEznYvZ0RJFXl5izlXaYz4INTZU
	 3EaBRmhJpQs+qKyjY14VqNVGzhYbjfRz++1EtaCBKfWoFtMuHcrzY0eI6n0qP55wKN
	 PAe0T1j6IhOVZVGWfG4rCXmh9/jBzqt+mj0hDMRt6lx113NgKZX5COGYZJUzTCr7MZ
	 q2rNXksuqaeXw==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	kernel-team@meta.com,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v2 07/10] mm/damon/sysfs-schemes: support DAMOS_QUOTA_NODE_MEMCG_FREE_BP
Date: Thu,  9 Oct 2025 14:20:39 -0700
Message-Id: <20251009212042.60084-8-sj@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20251009212042.60084-1-sj@kernel.org>
References: <20251009212042.60084-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 89C3D40007
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: kh6dxwtht9qb17j3hcnp8ziqnfwkcdyc
X-HE-Tag: 1760044856-853911
X-HE-Meta: U2FsdGVkX1/gKS7dtjcNw8/C3DFUbbu/ri2W1X1ZE1ATV/6flT3T7yvL7rcmneKKYVvyeU7evtnWOMYAM+1rDa8eqydYpJlsNtGxDTJv+LkCpu3aJFSsvtsw+L6ihgK5XjXKNMzD8TXdeh1QreqsC6OAkSMXL1+w2oTqpHYaUFy++aMG24Y5ZBF9ZQwB9eWcoa/zcPqUVAR1B7PfTjl+X+ZFbE1bkk3gBdqww0fj78D1F4JYUCubEe5EIqlh8f1n2Df95Zjqg+pnWom5Z391Cmw5NGRYFygKJ/6/8ORoe4DAcSN7+emItgyQdZy3YpJaxMKlBzncs7bBlBziGChlrG0jP51YwIyniiBYExtGR3MIgyAWl4E96ItZKDLZ0x4pnVUOVD5M3K50eoymFreX1/7u5PCj5q/tg6eMzLdzo7NrOYf9eDWJLp4e4CMhiGjxBqKPQ8f8P2aznG0huZV0Iym1PS2ZPxNXsSzIZV73fVft0IXbC2Qr0bOIAZvR4ZS6pXbI9P9ENgVsrKlu7jx2V5JJEYLqTH5mmzS39CSrVNZptcm7avVyxeGR3gTZh0BDZK8FBII6c+cqB1bu2rOKbcYSdzuiLw3E6kr/zNbXVNZYExYXQENaNsVq0QpaPR4DW3zfEh6PqjfZ6MF+WQdp7MzFb5seKSjtFIutQiWfvLMuEkWsAaM2LQpR86qTuPcKd0JI/v2EJh8gyv+3IOk3ps3g0VQm6N0KOE36X2+/Ic3q2PIktbQGu/ZqXL148oQc6wZTOTcuV5LkIamDGXUcB3p0oaiReythBJL6CV5ionaJUjUic2Gea3082YZEH1AJVPEn7qax/q/Yz4dYivqNJT0U1zd9iizUYrXGFjyrvOVnI0l77VDOv2wYl9+6E19QzOnosB2lrGnV5rarR8UVGh7Y2/6FtyzX8Dqx4Q2X7Vo20rtoohiCptLRtBY/lAI4izYPCs2ZDE49gVHkUpA
 GHCENncf
 3525A/uTschVZsgUqBNQNPYwXrsF4fX6OmdJ3srbjRzokhyLUpv3rYUQkyu2QbRmBbRRfMIu3eUORNMSFQFXBMjV1SKsOX/3SIH/SJzldvNziEfhvfQawIig/IH/Y19m2k6XxG2e4a6x7NOWOcIsi/QGiPwVAnEifZK3tkM/6TWVvW0bAInr2hq5k/6BLZSgjcML40S08d210iUEMymENSqGwkOF1J6vGR2nErNhc4X+AQTgm332pY69krr0wH9mkWxz+mvuVBzJ31c/rAENyHN1gnA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Extend DAMON sysfs to support DAMOS_QUOTA_NODE_MEMCG_FREE_BP.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 mm/damon/sysfs-schemes.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/mm/damon/sysfs-schemes.c b/mm/damon/sysfs-schemes.c
index c679e62fd4b9..c98cf4bd2fbb 100644
--- a/mm/damon/sysfs-schemes.c
+++ b/mm/damon/sysfs-schemes.c
@@ -1034,6 +1034,10 @@ struct damos_sysfs_qgoal_metric_name damos_sysfs_qgoal_metric_names[] = {
 		.metric = DAMOS_QUOTA_NODE_MEMCG_USED_BP,
 		.name = "node_memcg_used_bp",
 	},
+	{
+		.metric = DAMOS_QUOTA_NODE_MEMCG_FREE_BP,
+		.name = "node_memcg_free_bp",
+	},
 };
 
 static ssize_t target_metric_show(struct kobject *kobj,
@@ -2552,6 +2556,7 @@ static int damos_sysfs_add_quota_score(
 			goal->nid = sysfs_goal->nid;
 			break;
 		case DAMOS_QUOTA_NODE_MEMCG_USED_BP:
+		case DAMOS_QUOTA_NODE_MEMCG_FREE_BP:
 			err = damon_sysfs_memcg_path_to_id(
 					sysfs_goal->path, &goal->memcg_id);
 			if (err) {
-- 
2.39.5

