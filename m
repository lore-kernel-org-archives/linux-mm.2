Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ABCCECA1002
	for <linux-mm@archiver.kernel.org>; Thu,  4 Sep 2025 13:44:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 19DEE8E000B; Thu,  4 Sep 2025 09:44:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 14EFE8E0001; Thu,  4 Sep 2025 09:44:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 03DD48E000B; Thu,  4 Sep 2025 09:44:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id E3C9F8E0001
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 09:44:41 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id A59CF1401DD
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 13:44:41 +0000 (UTC)
X-FDA: 83851687962.24.04FBAD5
Received: from szxga04-in.huawei.com (szxga04-in.huawei.com [45.249.212.190])
	by imf27.hostedemail.com (Postfix) with ESMTP id 269154000B
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 13:44:37 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf27.hostedemail.com: domain of tujinjiang@huawei.com designates 45.249.212.190 as permitted sender) smtp.mailfrom=tujinjiang@huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756993479;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references; bh=i2yE/smLIh8oDrhASznoRsd+SXHsG7ksJil0lri4ZSM=;
	b=zGvdW5aPnNO7DDVEEtuP67DDeoxUZEqB3HZLbgrxuI1F1eq6yF1Z/Hzm+RgkSqk+YgFinJ
	5ApdLy2edJSySmKc1V+rDnkvHZynPYSP0ME2vepwKzpJBnLEjgdw58bMFt4uZWTVcU/G7J
	08vDG6Zt2osGPvqs4bK//8uDfrja9vs=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf27.hostedemail.com: domain of tujinjiang@huawei.com designates 45.249.212.190 as permitted sender) smtp.mailfrom=tujinjiang@huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756993479; a=rsa-sha256;
	cv=none;
	b=4R6laZTg3vVphR5GF/RaLinnMvD9TsxkYg1Z5rxDYAXjZoNCYhDWn2UdE6ImAg0aBP4Mx9
	o7gNlGHl7/xI7iyHsil61tt4oVK08qejH2mDLbeAzw09qSswomi6+bq4axKxpMsDeqc8+u
	nIxUDFwRiTp++CdbMe4mcpX7juSXzRQ=
Received: from mail.maildlp.com (unknown [172.19.163.17])
	by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4cHgcM2z3hz2VRhY;
	Thu,  4 Sep 2025 21:41:23 +0800 (CST)
Received: from kwepemr500001.china.huawei.com (unknown [7.202.194.229])
	by mail.maildlp.com (Postfix) with ESMTPS id D6FBA1A0190;
	Thu,  4 Sep 2025 21:44:31 +0800 (CST)
Received: from huawei.com (10.50.85.135) by kwepemr500001.china.huawei.com
 (7.202.194.229) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Thu, 4 Sep
 2025 21:44:31 +0800
From: Jinjiang Tu <tujinjiang@huawei.com>
To: <mhocko@suse.com>, <rientjes@google.com>, <shakeel.butt@linux.dev>,
	<akpm@linux-foundation.org>, <david@redhat.com>, <ziy@nvidia.com>,
	<matthew.brost@intel.com>, <joshua.hahnjy@gmail.com>, <rakie.kim@sk.com>,
	<byungchul@sk.com>, <gourry@gourry.net>, <ying.huang@linux.alibaba.com>,
	<apopple@nvidia.com>, <linux-mm@kvack.org>
CC: <wangkefeng.wang@huawei.com>, <tujinjiang@huawei.com>
Subject: [PATCH] mm/oom_kill: kill current in OOM when binding to cpu-less nodes
Date: Thu, 4 Sep 2025 21:44:31 +0800
Message-ID: <20250904134431.1637701-1-tujinjiang@huawei.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.50.85.135]
X-ClientProxiedBy: kwepems200002.china.huawei.com (7.221.188.68) To
 kwepemr500001.china.huawei.com (7.202.194.229)
X-Stat-Signature: 1j3877jmgpfz5pgfmgb3ggq6ma3u9uiq
X-Rspam-User: 
X-Rspamd-Queue-Id: 269154000B
X-Rspamd-Server: rspam01
X-HE-Tag: 1756993477-69770
X-HE-Meta: U2FsdGVkX19JFhbURRJuMChewzsSwOPxvJVta4tJTnWfN02kuKb22ovkmaLG6M2bndRmD7k9pVwpyCL/d92GoGDScjDRHA+rJZ6xFeZ3p8eWmxXKKZRWxQkqsg3X3qeUO97OpDHXdagG7fZgZnq8m903vAs161Z03dVBoI/fMTA7SCx4/o2iqoH41PJ0GtlGtArRld9yB+tuYAywp5gFh+uvJONdGUu/1YL5epDj9hV7r1VHE2kfmPXuZ7pHZAxvlLDKxl6ogAocHC4054Rwo+ttuWOFKR2I9vHZbcog3pGYRInaBOMMaFdI3zCyYhrF2sYcCO2dDhYYrXIVFYL3lKZwoOIFUmY86tiCCEbwwYy0mKKkVWvvBcwrrJcYspbgoei7i3bQ1eY1WRokc7/FcM/bntEGdrD79qmrBb822HRaKCJU5Xm4vyuOJZM6KewOPyUMmJjGUSlsR3NPxOamSuvZgx4Mbl//dDWeNEQIm1WJkGibeIEKXxR4JsHKiTONYOAlmPXmhx2jMY2Yu92HliXAEUJOAf1T45t4j4RivvZGNKhF83FBu9eoXeXrRjtgVbLgkCvjXP8hpBnzAe7UMcm028+DnStjjMlhGIx3pw/N0X9b0l7HQoTzZIv78WuOcAOxcuhtewEV+Bnwh4zUWqkdtdinVUjuVapScN52z3dW76tf6bg6FjTfQfoYX0cM/zqMMCy4QhkYuGWJ2yzDcVHyV+8LNaM6vHXa5CJ8BzI9gI8uXgI0DNjdNjuQDpKCaq7c66Ikw29GLEmTkadh4zsKKmOFC/6Ivz0FhHhAJCiiTJVK8WOkA4WTnss+UAqhyx/muL2ZVaRTfV9ALlaOwXHkINW5VyyaDOXrHDJaWS3M/ib9ZSLTUqjXGqZulnu3VM06e3OwdrZAPqN/ks21zcD22f1CpIfaixVfzYBRJWeH7WamLwZn5HntrTsLhck2zn9+spKabFK+iCEbj6D
 fusU7gsb
 xcmrn4X8zUPLAY1skmq7atxskiinfv1T/Pt+UkmDilnM1INVOEiAPPiZPtwj08dpEpt20KYNF0S+1I2qPiwhkGW75YQmfpRiqxNP5mXc9vd+/qF0uaP51Q9MD811Ffr/BRtBT3lNaaH/khuWQFyVvLIczKgTtlzVhS6rlanYSsqysYNySfsWyaGexUeiQJewpz8EtW5HLsV8k6+xx3Op4HMekQXMQ3OHf8FAFpkz2B2xnmQ4Lwpa7gppy0uLXEU3uzoPm+aJq86Ja/HU97Ji6gHgkpyGtls7fdExqtSwd1LJVr6+7ckXJTQ634Q==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

out_of_memory() selects tasks without considering mempolicy. Assuming a
cpu-less NUMA Node, ordinary process that don't set mempolicy don't
allocate memory from this cpu-less Node, unless other NUMA Nodes are below
low watermark. If a task binds to this cpu-less Node and triggers OOM, many
tasks may be killed wrongly that don't occupy memory from this Node.

To fix it, only kill current if oc->nodemask are all nodes without any cpu.

Signed-off-by: Jinjiang Tu <tujinjiang@huawei.com>
---
 mm/oom_kill.c | 16 +++++++++++++++-
 1 file changed, 15 insertions(+), 1 deletion(-)

diff --git a/mm/oom_kill.c b/mm/oom_kill.c
index 25923cfec9c6..8ae4b2ecfe12 100644
--- a/mm/oom_kill.c
+++ b/mm/oom_kill.c
@@ -1100,6 +1100,20 @@ int unregister_oom_notifier(struct notifier_block *nb)
 }
 EXPORT_SYMBOL_GPL(unregister_oom_notifier);
 
+static bool should_oom_kill_allocating_task(struct oom_control *oc)
+{
+	if (sysctl_oom_kill_allocating_task)
+		return true;
+
+	if (!oc->nodemask)
+		return false;
+
+	if (nodes_intersects(*oc->nodemask, node_states[N_CPU]))
+		return false;
+
+	return true;
+}
+
 /**
  * out_of_memory - kill the "best" process when we run out of memory
  * @oc: pointer to struct oom_control
@@ -1151,7 +1165,7 @@ bool out_of_memory(struct oom_control *oc)
 		oc->nodemask = NULL;
 	check_panic_on_oom(oc);
 
-	if (!is_memcg_oom(oc) && sysctl_oom_kill_allocating_task &&
+	if (!is_memcg_oom(oc) && should_oom_kill_allocating_task(oc) &&
 	    current->mm && !oom_unkillable_task(current) &&
 	    oom_cpuset_eligible(current, oc) &&
 	    current->signal->oom_score_adj != OOM_SCORE_ADJ_MIN) {
-- 
2.43.0


