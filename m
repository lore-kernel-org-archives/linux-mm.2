Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 01360CCD195
	for <linux-mm@archiver.kernel.org>; Fri, 17 Oct 2025 21:27:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D42188E0075; Fri, 17 Oct 2025 17:27:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B70BA8E003A; Fri, 17 Oct 2025 17:27:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7EB5F8E004C; Fri, 17 Oct 2025 17:27:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id E70D28E004C
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 17:27:17 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id AE9561A032E
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 21:27:17 +0000 (UTC)
X-FDA: 84008892114.20.AAF0823
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf19.hostedemail.com (Postfix) with ESMTP id 24F831A000F
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 21:27:15 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=KRBgGGWz;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760736436;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=x6O6UnBhm72k+JCLvOtkOn+BY0eRjPvoi22v1kYbt6k=;
	b=rGFQC1EnJmLcx6BNlFZH4mKijlHJqkg27H+EZUMUSKwYMRahmcnnqQ1vaLsugovGnXvWDi
	vwAXqf94t5HtfB82pVoSYy68UFftJgbr53oggUDjpx/fC2Cemdv6kEJ0Z5nXMN1Wy+UugY
	0NggO7MrSIh246IxZpkFgTHaTt7FVJo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760736436; a=rsa-sha256;
	cv=none;
	b=wm1QaNUUXfBW4Hf9JgkLLfELNxOWeWKWDMS2ZvWzLEIZN+J4PV9eKWGQHkAR8U3G5eL4tB
	ROHiJU9v5pP/LEGfxu8E8LeW5KRsy0LGhvRTsSjZLys6Vu62UXTtE6PULp8tnqwzlGsWdT
	olH6MydfPytShySTigXFzH1Po5XlrTI=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=KRBgGGWz;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id A355C645D1;
	Fri, 17 Oct 2025 21:27:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 626AFC116B1;
	Fri, 17 Oct 2025 21:27:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760736435;
	bh=PeYfeE2IAy0+xdX4Fi40UdJR+73VcJkJ2XijKRhczHg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KRBgGGWzBbvi48oZxlBMJilkQ39aJ5kTPsrxNezkedQxg5ESYKEAoiBMBs23dJlZ7
	 iAxuFABZq4nh0DVOcsCx3oeluVIoFlLUDRJTGQgUwhbx46BQMlE4vDbCa43JuKODEw
	 v+IkO6XF/YZK0NWK8QPx3p9wv2MGqN4VrPNaDuXaOwaCV4mQE3kjhTmG/5pqwEfm+F
	 18SgycU4J7Mntq5hoiAokrpztEmKXIuM1yZeNCuQv1q775St4DH/yosDqyR3/igebY
	 0UK0uSFPQR2+Z4VxYYIdw43Pw8Z0z8A3NGPPV1INCqCvs4M1PGndx3a5wdSDV2eex4
	 gSUwbiCKiX84g==
From: SeongJae Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SeongJae Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 07/10] mm/damon/sysfs-schemes: support DAMOS_QUOTA_NODE_MEMCG_FREE_BP
Date: Fri, 17 Oct 2025 14:26:59 -0700
Message-ID: <20251017212706.183502-8-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251017212706.183502-1-sj@kernel.org>
References: <20251017212706.183502-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 24F831A000F
X-Rspamd-Server: rspam02
X-Stat-Signature: dwsks9cweasr6kh569dkw46ihusfjy35
X-HE-Tag: 1760736435-150549
X-HE-Meta: U2FsdGVkX18Maj1R+TEW7wRW9muGs3L/SCf+7Ciffro7bnj6CuYBpY6KfC3zfYvUD8UQuC7jBa2oyB4r+yEVW6ZEPhHueO3vlNttl3Va+AN4wPvf8f9baUBpPnW9k4b8zcHMksbFJXk1lVCnj7JJpmARpHKEwW8qv3kQfyGxmimL/IBD54ejRFhwon2MtpB8O4Daf9HosQfB97JmCSIW82tLUZcnnbng8KevjPgeDx329rfiYmaOtBfehFJRnQcwMxFCPqFiVwsC8dW9mshNbwYd2AY+7K5PFWlFvAzN5BGssVORYKLgfJRmWsf+jO5zRQz2cDoYrVhENTg0DG2O/n/t38xWrkEQGzoZ0jAKXJp/d4hANHM+7zgkNSqyZT3EXYC6WS0wlWHvHWaXzTUsA6KcWpp502s+YX5WHYc74+gnXPsQsjyVmr+HGdaiL2pSsVuzgmTF5nQm9a0vCMF2PBwberOhmvDP7jr/3F8VsjvJJO2KHFYrWSOxvzjYixvKeFqFScXj5kB1xHtCFjTInT6Z8p8dgMibUKfbXl1/M8rD0oM5naKcgDH4J4q//Ir5DPTLpMqs6CMCEf30yrax29Hk7nSD/Sz1hxrEiGqRC3yXl7tCa4kZr548Uvt8yR0Qnwl/uh1PTabA242Lk44fb5OPvNegJsWy4NL7mTJ5v/OVb3uJADuRAvBChlO4IrF3ofwn9I27t70Xx0EHZmqdCn2YINnn5JxUpA1aVLocsVTEFT/qOV0pyYtz78jMmhPHJxHbnenF9cw05JibmJ5A6cOcJ/YaebqTq7pW9CYPkHMcybEu7sC3aPLuTnMvgZRz/xS9HjLUO1gbOsHXRQF0VxyFIDmznqKCkQmiOWrgySMlAi/Aoyu1fxcEN50W6f3s8v1YbNd32NWj7hKVPAHzRKrp4e+7knWYXgxfO9VBxOlXLzNbRSNeBdmHoQr6h5TAU9lZf+bbEah8TL6wmq5
 hqTgziCf
 1kr/W440JOlTsTpr5+SKaneoYpOfrbbGvEL8aiBB9/JQCD1dQW1bj104kwXvoKJZL4BhmB+2hql3rey/8OfIVFtgfmPXj0dZjyM/Im8wrHdfxFs3H3eMqKizMtLEbKfFeMPwunVa6+WUOsGbleDuJpFU1FKPI/6D+y68GCsELEU2atWAH4B4JqzHtESqCLHb3NQxEI+QTbEk6ujO62zBv7DRykGJhLvLmfmXfdLW9QJrSeMefGC+19+Wl8zYGzomhIgBQcxBbRrLW92mNJ2e6zNHbuQ==
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
2.47.3

