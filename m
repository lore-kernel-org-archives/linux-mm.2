Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5B2B3C87FCA
	for <linux-mm@archiver.kernel.org>; Fri,  1 Aug 2025 17:21:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A3B6B6B0089; Fri,  1 Aug 2025 13:21:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9C6E16B008A; Fri,  1 Aug 2025 13:21:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 88D646B008C; Fri,  1 Aug 2025 13:21:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 7B7B36B0089
	for <linux-mm@kvack.org>; Fri,  1 Aug 2025 13:21:09 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 3E23C113FC6
	for <linux-mm@kvack.org>; Fri,  1 Aug 2025 17:21:09 +0000 (UTC)
X-FDA: 83728854258.05.FCBD601
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	by imf07.hostedemail.com (Postfix) with ESMTP id 3B2AA40008
	for <linux-mm@kvack.org>; Fri,  1 Aug 2025 17:21:07 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=none;
	spf=pass (imf07.hostedemail.com: domain of shiju.jose@huawei.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=shiju.jose@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754068867;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=V96ziGpZpdAuZZcz/ARa78aqHPMzhR/tEerHldHLr18=;
	b=3Iaj0ZY/BRZceUpXRigkd4gCF8Edbo4x5VQwKUGM/P+a4W9eVaJEiL+mSvCl6lpgG685PL
	7AGbplzdIjh0+LKD9p25eKnT/qI9bIQSHjQejMAn9pef0QcN+p3G/GNaYBpCR0hnbssdRB
	/W7IK6V5pGpxjeVTty+sGSU/onG8NR8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754068867; a=rsa-sha256;
	cv=none;
	b=xS8F3DlAcNVTkdtZM57v1rm17tjFv5MsLog1b/V+6GPwpcgvWFkosiXW9zcWwKGPxLtPJm
	VN/+UZZmRoIQmrVpirWsULnKoWVt+sPE7nS4t4VrxWC9uecjCN++2nvdMijTHqrmgUTYH8
	oVLEEdvTNXQM68RRfdE/9h33LoUN4P4=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=none;
	spf=pass (imf07.hostedemail.com: domain of shiju.jose@huawei.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=shiju.jose@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
Received: from mail.maildlp.com (unknown [172.18.186.31])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4btt3B6q3Vz6L5BD;
	Sat,  2 Aug 2025 01:19:02 +0800 (CST)
Received: from frapeml500007.china.huawei.com (unknown [7.182.85.172])
	by mail.maildlp.com (Postfix) with ESMTPS id A50E51400D4;
	Sat,  2 Aug 2025 01:21:05 +0800 (CST)
Received: from P_UKIT01-A7bmah.china.huawei.com (10.195.32.206) by
 frapeml500007.china.huawei.com (7.182.85.172) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Fri, 1 Aug 2025 19:21:02 +0200
From: <shiju.jose@huawei.com>
To: <rafael@kernel.org>, <bp@alien8.de>, <akpm@linux-foundation.org>,
	<rppt@kernel.org>, <dferguson@amperecomputing.com>,
	<linux-edac@vger.kernel.org>, <linux-acpi@vger.kernel.org>,
	<linux-mm@kvack.org>, <linux-doc@vger.kernel.org>, <tony.luck@intel.com>,
	<lenb@kernel.org>, <leo.duran@amd.com>, <Yazen.Ghannam@amd.com>,
	<mchehab@kernel.org>
CC: <jonathan.cameron@huawei.com>, <linuxarm@huawei.com>,
	<rientjes@google.com>, <jiaqiyan@google.com>, <Jon.Grimm@amd.com>,
	<dave.hansen@linux.intel.com>, <naoya.horiguchi@nec.com>,
	<james.morse@arm.com>, <jthoughton@google.com>, <somasundaram.a@hpe.com>,
	<erdemaktas@google.com>, <pgonda@google.com>, <duenwen@google.com>,
	<gthelen@google.com>, <wschwartz@amperecomputing.com>,
	<wbs@os.amperecomputing.com>, <nifan.cxl@gmail.com>, <tanxiaofei@huawei.com>,
	<prime.zeng@hisilicon.com>, <roberto.sassu@huawei.com>,
	<kangkang.shen@futurewei.com>, <wanghuiqiang@huawei.com>,
	<shiju.jose@huawei.com>
Subject: [PATCH v10 1/3] mm: Add node_to_range lookup facility to numa_memblks
Date: Fri, 1 Aug 2025 18:20:27 +0100
Message-ID: <20250801172040.2175-2-shiju.jose@huawei.com>
X-Mailer: git-send-email 2.43.0.windows.1
In-Reply-To: <20250801172040.2175-1-shiju.jose@huawei.com>
References: <20250801172040.2175-1-shiju.jose@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.195.32.206]
X-ClientProxiedBy: lhrpeml500012.china.huawei.com (7.191.174.4) To
 frapeml500007.china.huawei.com (7.182.85.172)
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 3B2AA40008
X-Stat-Signature: rkaj7e7xdifnyg4ogtnooqgh4wk5uh9u
X-Rspam-User: 
X-HE-Tag: 1754068867-490928
X-HE-Meta: U2FsdGVkX19CVh/Casil4m4EBkDFUcV2IxYqz/CBBWEt6GnfGVa4alNNi2FYk/ZPMZdcaSGUif+OnJibCB5lRVZo0pzizc4zxmr8t2reQ4PJhIu0Ty9/eiO0sBsHpsXvZlm4QCxwAL+EuyRDGceTLtEYqpSsw+Fgn2czZigfnJ95tws68Rc4yjKhDQ5bQJY6lbBy/91zmnmA/DdwErlecxOwQ28PHw8OenZy8agtXBWb5TbKt2pQiagWqtxQIn1E+2vZcR2HP59rgfq+ZvMyWCEx8CQXN5UnEnj80eZ12SPlURDTGNvR3QR5EWU8KgnrNVWI5UQTbYfuKRkiEOltYfvZ7rsAynKcJc3ZHgsh7T+sF9CDchKi6JPuNkOljgDw74lafthj4fwUyyWp4f+3bZhLV2iwLbJaCk9BlSNkzcc/khXDt6SmjQfhiEgf+/sGQBH5N/jRkcCVkylMv7isCWdzMm/LJRwk2+Uve+4Q0J8EdHr3hjrcw6rdgD3Zyq4pe4I6HN4z6cLOIk7yGYxVCbeS7wO9BxyCvw3TCewH8jqYRH8G/ku8pEn/LVlBNgbmlECwcxYqTCqUEZ39lBaeU+VB1xl6Y3YUVIKIFAM6Gp6uWtLgXC0Yd2NJomM3n0WwyWPjcpWxPeEQK38zL+NQaJUxmPw5h5C/XpByTkRidDbjtMQSdb8h1wKctXMihwmZyK3xTvzMb2jGX1KPBbCOUMgyMcjLzIj/OeuThhM74MeNZ3vZYxEJM++5cxx/lTn7sQOpf8+OkSiZE49ufBy8QkQ2vcpHGCHnmDqqPqf82ftmbw3S3PaO/WIjTBWvcHZM0cD1H12BGPGziZyqxFOlpT631XW+Eq6Gww9iRyAbfRHBY1dfupkzGhGyepeGwAxrdOos+qLDlUaAwUXMeHMFNS2fbwmql9TyT5PqSrIVaOCc4MAxY04xtw/DMQZXbcGE63hHn/btydMsorIWhFC
 5tpEk0Hs
 cLeqvwRTCqMTuhxCkgZLZuojaKX04BIPsl4S5JtSed8TWqdVIG7XWbFR4NzFZypQcKi78Q8QaYezgpQ93Bd5koS6ZM44F/e1VWAvhifIqG4IoD9GMUCygEdlFISZ7PAVFfI3ziMt3zJggAOHHsGgUdKHOcEsT5XsO6tlCvWfucNt+bAJL5bIDkDlX18xcHi5sjdOpJxw8Cr0GkXzuCurbAtayX0Rz194Ml2brBsRR7Z8RZW/WgokHnzHfQTvj04qXJEs/5Zm9GVXxTyKckVRYDoZI4bpZI3XjabW8bdXvypBO05i1SmNe+wI7gaa2fi4TWR8Z7mQ8aJMNWRKxilGSh2L+evU51my+v6qIpDFQr1B69myoIYiE0rzpWg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Shiju Jose <shiju.jose@huawei.com>

Lookup facility to retrieve memory phys lowest continuous range for
a NUMA node is required in the numa_memblks for the ACPI RAS2 memory
scrub use case.

Suggested-by: Jonathan Cameron <jonathan.cameron@huawei.com>
Signed-off-by: Shiju Jose <shiju.jose@huawei.com>
---
 include/linux/numa.h         | 10 ++++++++++
 include/linux/numa_memblks.h |  2 ++
 mm/numa.c                    | 10 ++++++++++
 mm/numa_memblks.c            | 23 +++++++++++++++++++++++
 4 files changed, 45 insertions(+)

diff --git a/include/linux/numa.h b/include/linux/numa.h
index e6baaf6051bc..d41e583a902d 100644
--- a/include/linux/numa.h
+++ b/include/linux/numa.h
@@ -41,6 +41,10 @@ int memory_add_physaddr_to_nid(u64 start);
 int phys_to_target_node(u64 start);
 #endif
 
+#ifndef node_to_phys_lowest_continuous_range
+int node_to_phys_lowest_continuous_range(int nid, u64 *start, u64 *end);
+#endif
+
 int numa_fill_memblks(u64 start, u64 end);
 
 #else /* !CONFIG_NUMA */
@@ -63,6 +67,12 @@ static inline int phys_to_target_node(u64 start)
 	return 0;
 }
 
+static inline int node_to_phys_lowest_continuous_range(int nid, u64 *start,
+						       u64 *end)
+{
+	return 0;
+}
+
 static inline void alloc_offline_node_data(int nid) {}
 #endif
 
diff --git a/include/linux/numa_memblks.h b/include/linux/numa_memblks.h
index 991076cba7c5..ccc53029de8b 100644
--- a/include/linux/numa_memblks.h
+++ b/include/linux/numa_memblks.h
@@ -55,6 +55,8 @@ extern int phys_to_target_node(u64 start);
 #define phys_to_target_node phys_to_target_node
 extern int memory_add_physaddr_to_nid(u64 start);
 #define memory_add_physaddr_to_nid memory_add_physaddr_to_nid
+extern int node_to_phys_lowest_continuous_range(int nid, u64 *start, u64 *end);
+#define node_to_phys_lowest_continuous_range node_to_phys_lowest_continuous_range
 #endif /* CONFIG_NUMA_KEEP_MEMINFO */
 
 #endif /* CONFIG_NUMA_MEMBLKS */
diff --git a/mm/numa.c b/mm/numa.c
index 7d5e06fe5bd4..0affb56ef4f2 100644
--- a/mm/numa.c
+++ b/mm/numa.c
@@ -59,3 +59,13 @@ int phys_to_target_node(u64 start)
 }
 EXPORT_SYMBOL_GPL(phys_to_target_node);
 #endif
+
+#ifndef node_to_phys_lowest_continuous_range
+int node_to_phys_lowest_continuous_range(int nid, u64 *start, u64 *end)
+{
+	pr_info_once("Unknown target phys addr range for node=%d\n", nid);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(node_to_phys_lowest_continuous_range);
+#endif
diff --git a/mm/numa_memblks.c b/mm/numa_memblks.c
index 541a99c4071a..9cbaa38cb92d 100644
--- a/mm/numa_memblks.c
+++ b/mm/numa_memblks.c
@@ -590,4 +590,27 @@ int memory_add_physaddr_to_nid(u64 start)
 }
 EXPORT_SYMBOL_GPL(memory_add_physaddr_to_nid);
 
+static int nid_to_meminfo(struct numa_meminfo *mi, int nid, u64 *start, u64 *end)
+{
+	int i;
+
+	if (!numa_valid_node(nid))
+		return -EINVAL;
+
+	for (i = 0; i < mi->nr_blks; i++) {
+		if (mi->blk[i].nid == nid) {
+			*start = mi->blk[i].start;
+			*end = mi->blk[i].end;
+			return 0;
+		}
+	}
+
+	return -ENODEV;
+}
+
+int node_to_phys_lowest_continuous_range(int nid, u64 *start, u64 *end)
+{
+	return nid_to_meminfo(&numa_meminfo, nid, start, end);
+}
+EXPORT_SYMBOL_GPL(node_to_phys_lowest_continuous_range);
 #endif /* CONFIG_NUMA_KEEP_MEMINFO */
-- 
2.43.0


