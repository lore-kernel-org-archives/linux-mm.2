Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1306BE6F084
	for <linux-mm@archiver.kernel.org>; Tue, 23 Dec 2025 11:08:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2213A6B0005; Tue, 23 Dec 2025 06:08:15 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1CED56B0089; Tue, 23 Dec 2025 06:08:15 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0B0196B008A; Tue, 23 Dec 2025 06:08:15 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id EDF726B0005
	for <linux-mm@kvack.org>; Tue, 23 Dec 2025 06:08:14 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 984F21A018E
	for <linux-mm@kvack.org>; Tue, 23 Dec 2025 11:08:14 +0000 (UTC)
X-FDA: 84250461708.28.249DCCD
Received: from canpmsgout03.his.huawei.com (canpmsgout03.his.huawei.com [113.46.200.218])
	by imf18.hostedemail.com (Postfix) with ESMTP id E06FF1C000C
	for <linux-mm@kvack.org>; Tue, 23 Dec 2025 11:08:10 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=TFI7seo6;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf18.hostedemail.com: domain of tujinjiang@huawei.com designates 113.46.200.218 as permitted sender) smtp.mailfrom=tujinjiang@huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766488092; a=rsa-sha256;
	cv=none;
	b=lAA3ZS9bfUypc9FfBwpLMRNb1XWPrJBTLlODs/DbpjOQs8YSqrKN83Htw2ImKlrdxZQlkP
	7y1RrrclPo5tfhfFMLwfACP3en0LZxDcZUQast8QrNAZPn0t/J7tYnrDavyHsJYs5USRO0
	t0G/EpkeuhC1RU2NJFuWCF5mFEdk2F0=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=TFI7seo6;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf18.hostedemail.com: domain of tujinjiang@huawei.com designates 113.46.200.218 as permitted sender) smtp.mailfrom=tujinjiang@huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766488092;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=aJmteYNRk5nfQRpcjerZpmUsEzTE1YCfXcizPcPYM70=;
	b=w1IgBBAIyDn/Y8gcZEHrIZHDyX++8oWjK4OKgZLX7WxbDbcRV3tUEzo0gwP+mmleHnk1j+
	MjfBANl1ZQOhYGKWbQULPapDXFsPBes4Gws/vJmrvM71JDSHZOnnDAB4b187DavjS9H6wL
	mlQjjIazhQ/y+EhkgLlWslKSbsHmiNI=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=aJmteYNRk5nfQRpcjerZpmUsEzTE1YCfXcizPcPYM70=;
	b=TFI7seo6opg0nuzInlGP4iqFFwLgXtQsOfazDTyyC40ulQ32RInYA2NoOJ/W4yofUrayeJjGZ
	vqQzstTn73bmMG2Rt0RhDGCUnhcxAmiPCbWwWF853HR3E/Ff0P2EqNHmi7qkPtVF5aQhzjiS7zA
	fEG/eGaFqGCCZsw99hsYZu4=
Received: from mail.maildlp.com (unknown [172.19.163.104])
	by canpmsgout03.his.huawei.com (SkyGuard) with ESMTPS id 4dbBxK2d8kzpStQ;
	Tue, 23 Dec 2025 19:05:09 +0800 (CST)
Received: from kwepemr500001.china.huawei.com (unknown [7.202.194.229])
	by mail.maildlp.com (Postfix) with ESMTPS id 365C94056A;
	Tue, 23 Dec 2025 19:08:04 +0800 (CST)
Received: from huawei.com (10.50.85.135) by kwepemr500001.china.huawei.com
 (7.202.194.229) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Tue, 23 Dec
 2025 19:08:03 +0800
From: Jinjiang Tu <tujinjiang@huawei.com>
To: <akpm@linuxfoundation.org>, <david@kernel.org>, <ziy@nvidia.com>,
	<matthew.brost@intel.com>, <joshua.hahnjy@gmail.com>, <rakie.kim@sk.com>,
	<byungchul@sk.com>, <gourry@gourry.net>, <ying.huang@linux.alibaba.com>,
	<apopple@nvidia.com>, <mgorman@suse.de>, <linux-mm@kvack.org>
CC: <wangkefeng.wang@huawei.com>, <tujinjiang@huawei.com>
Subject: [PATCH v3] mm/mempolicy: fix mpol_rebind_nodemask() for MPOL_F_NUMA_BALANCING
Date: Tue, 23 Dec 2025 19:05:23 +0800
Message-ID: <20251223110523.1161421-1-tujinjiang@huawei.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.50.85.135]
X-ClientProxiedBy: kwepems100001.china.huawei.com (7.221.188.238) To
 kwepemr500001.china.huawei.com (7.202.194.229)
X-Rspam-User: 
X-Rspamd-Queue-Id: E06FF1C000C
X-Rspamd-Server: rspam10
X-Stat-Signature: azs5w4e98o1k5y8ixhpsaox8yp734jwx
X-HE-Tag: 1766488090-314898
X-HE-Meta: U2FsdGVkX1+jYrV9Phr5bnJAPB2TG/BFZVAw1GDc5eRhnqENH/b2rlA24rVKbbzUF6CuoUD9qc1fE+RRBINa0WRdMRXTbtZ4Bs16TcalBDxidRDJ46udJtPh51HQvgwgYqkuhXQJqEbhtcaROoHfN/QZJYtat/BtYUSQgswRoE2uVRBnJM9wapL+8LJe1CIUosnJXCReIOMVTjDYDpAgU3HffsiqVeNKLLwsyOxkc0nFEnPcs8xhvw8Qis4R+ZHfD91a7mVZPI2fquFjsPJhWF5tseiXxGR4aea40xZf90G6bWTVjgasUXuv8Qv1TguQZMsESuI2lF1BNvLKCFiEpu/TqPVu605owgotF/mMw5GdwB+2wvAJW90EcPOY6zjz5TAgmlfgjDsYSUUemwqrzM7skv95ot00BtDUHSwmgD5lQzHQlZV6RxFbCZSuukqjCQZh92FvWBQS0Y9guNB3PJ3DAOcwQyiDb1s5jVHsV+WBo3V7t2Y9bfC+TRt3CQIwZcxDCx8sKarBmsJ3NWFmarU0pf+MnddWzySiWBkr4FrMVHkF6DlaFSHWiXfyn4m5WEft2gV52Vcd6zJrzmTNJkYwVFKAtM6veVuXCRjsCtzR+CgPSqe9sPZA7fl/bwzfNUqf1Ggb64Eb45IAj9oW5JJuSC3J+66vFZp6F+bwDFCSChajLNZGR6GO/iZWp4Nv7/YcjRZt+pbQXzkwMyxio3cx86DTV41dCSfp9+p/1J2W8rIyGe1nrye8t/yWubfETT5gjVxr3iYIkAOpd3Eo1RVgYDjGINuLlybKAPpcrR0ENZ6vW+2+vW8Tx/g+LEOOI4JD4Zlxum2DOegke/5wdxlvQPZ+v6Dn6zdWGV2fC4FWgfTMOAaAhue4dUsGdX74z/Hx06EueK5EZm/Vk5zXSc81+jWPXZmeg4ZqfU6eYEfar0iNQknbsHH13AtXEm9kh53uvaYHFAGAUhs6oPA
 afVvK6Tf
 ywJDZNDFpop2TqNYQFmcXVNznhUDNz030YKmxTEjifbRu6weQCnjD1hQ1XC66H3ho75M4U4GclfZ7NO+sJjQX2ZVJ2dFLQQM37uctyxbPwFKU0DcpnME8xH3Lfx8xkkn3J2azjjNSR8Kk0hURP9aEe+0DlJo/UWA0uWRx0l+FTJiNMNtZl8IDEoWff7HrbwzdpyN9mKCIxbrWq7rhMxl8TFdTCG51AiflxrPAi1cEGY3sRm78LuxJ6yhIgDY/7sC7sMf/DRShW2TeT0G1GM2aDqtCMVaq4pyF5hsXk/VpUg/6e5NTjQmGiD1+mN63Q1Eu+JNYJ7fNNXhpEQFeD4q/MFfk150IiK/gpTkL4OEDlQsRjJ/c3eqUdyL+1i0xT10pO8Uk9g2eaYxuenhxT20T1TnK8OTn9H1fGlUWocGfmSzvv72Sui7sWWD8Ck4L3YRaHm8McYsrlJ4ZLUWlvIRJwl0Vap6JvOxEY/4pkbb5Ejm4os8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

commit bda420b98505 ("numa balancing: migrate on fault among multiple
bound nodes") adds new flag MPOL_F_NUMA_BALANCING to enable NUMA balancing
for MPOL_BIND memory policy.

When the cpuset of tasks changes, the mempolicy of the task is rebound by
mpol_rebind_nodemask(). When MPOL_F_STATIC_NODES and MPOL_F_RELATIVE_NODES
are both not set, the behaviour of rebinding should be same whenever
MPOL_F_NUMA_BALANCING is set or not. So, when an application calls
set_mempolicy() with MPOL_F_NUMA_BALANCING set but both MPOL_F_STATIC_NODES
and MPOL_F_RELATIVE_NODES cleared, mempolicy.w.cpuset_mems_allowed should
be set to cpuset_current_mems_allowed nodemask. However, in current
implementation, mpol_store_user_nodemask() wrongly returns true, causing
mempolicy->w.user_nodemask to be incorrectly set to the user-specified
nodemask. Later, when the cpuset of the application changes,
mpol_rebind_nodemask() ends up rebinding based on the user-specified
nodemask rather than the cpuset_mems_allowed nodemask as intended.

To fix this, only set mempolicy->w.user_nodemask to the user-specified
nodemask if MPOL_F_STATIC_NODES or MPOL_F_RELATIVE_NODES is present.

Fixes: bda420b98505 ("numa balancing: migrate on fault among multiple bound nodes")
Reviewed-by: Gregory Price <gourry@gourry.net>
Reviewed-by: Huang Ying <ying.huang@linux.alibaba.com>
Signed-off-by: Jinjiang Tu <tujinjiang@huawei.com>
---
Change in v3:
 * update changelog
 * collect RB from Huang Ying

 include/uapi/linux/mempolicy.h | 3 +++
 mm/mempolicy.c                 | 2 +-
 2 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/include/uapi/linux/mempolicy.h b/include/uapi/linux/mempolicy.h
index 8fbbe613611a..6c962d866e86 100644
--- a/include/uapi/linux/mempolicy.h
+++ b/include/uapi/linux/mempolicy.h
@@ -39,6 +39,9 @@ enum {
 #define MPOL_MODE_FLAGS							\
 	(MPOL_F_STATIC_NODES | MPOL_F_RELATIVE_NODES | MPOL_F_NUMA_BALANCING)
 
+/* Whether the nodemask is specified by users */
+#define MPOL_USER_NODEMASK_FLAGS (MPOL_F_STATIC_NODES | MPOL_F_RELATIVE_NODES)
+
 /* Flags for get_mempolicy */
 #define MPOL_F_NODE	(1<<0)	/* return next IL mode instead of node mask */
 #define MPOL_F_ADDR	(1<<1)	/* look up vma using address */
diff --git a/mm/mempolicy.c b/mm/mempolicy.c
index 68a98ba57882..76da50425712 100644
--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -365,7 +365,7 @@ static const struct mempolicy_operations {
 
 static inline int mpol_store_user_nodemask(const struct mempolicy *pol)
 {
-	return pol->flags & MPOL_MODE_FLAGS;
+	return pol->flags & MPOL_USER_NODEMASK_FLAGS;
 }
 
 static void mpol_relative_nodemask(nodemask_t *ret, const nodemask_t *orig,
-- 
2.43.0


