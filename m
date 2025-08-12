Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A3C23CA0EC4
	for <linux-mm@archiver.kernel.org>; Tue, 12 Aug 2025 14:31:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0B3CA8E0148; Tue, 12 Aug 2025 10:31:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 08B818E00B0; Tue, 12 Aug 2025 10:31:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EBC018E0148; Tue, 12 Aug 2025 10:31:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id DA8D08E00B0
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 10:31:18 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 7CB5F137579
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 14:31:18 +0000 (UTC)
X-FDA: 83768343036.20.ADD2F35
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	by imf12.hostedemail.com (Postfix) with ESMTP id 84D0D40014
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 14:31:15 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf12.hostedemail.com: domain of shiju.jose@huawei.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=shiju.jose@huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755009076; a=rsa-sha256;
	cv=none;
	b=RLfuZJgdBtcctWBV1N5V4ziK3nE5pQwBbWY43ITyrd00pnFUJxlZJjLw/7Xcf0hlL6x9OA
	LRmrc3UM4LhnH3bakOgnOKnICoQjCxgzLoCj0MobQ8dhoXa45MIzKLmGL728DpfYQtc3om
	1knazGOTGccKFly+fnb/pRGoAG8eo5Q=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf12.hostedemail.com: domain of shiju.jose@huawei.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=shiju.jose@huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755009076;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=SgTGVPwpC9Ks8Df/PGtcQU0YiALgvIoq+xhlKw6PaEs=;
	b=1CrNUJvqQFWqggDhe9+VAOteUtr300SMDhgsbr79a2Go6G7hj9URVzI+xM1YXvlRpiRVRt
	SR32wvOGLoGnebL3Zjn+qBEBajvvgGLHvxo+IJEMIL+oUcLeuBk6Ll4OpalfXTGGNtuarq
	S/mST+aIeSeQCR76jq5ORvfyNthdFjQ=
Received: from mail.maildlp.com (unknown [172.18.186.31])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4c1YlR1TGKz6L52D;
	Tue, 12 Aug 2025 22:28:35 +0800 (CST)
Received: from frapeml500007.china.huawei.com (unknown [7.182.85.172])
	by mail.maildlp.com (Postfix) with ESMTPS id 061901402EC;
	Tue, 12 Aug 2025 22:31:13 +0800 (CST)
Received: from P_UKIT01-A7bmah.china.huawei.com (10.48.144.134) by
 frapeml500007.china.huawei.com (7.182.85.172) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Tue, 12 Aug 2025 16:31:11 +0200
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
Subject: [PATCH v11 1/3] mm: Add support to retrieve physical address range of memory from the node ID
Date: Tue, 12 Aug 2025 15:26:13 +0100
Message-ID: <20250812142616.2330-2-shiju.jose@huawei.com>
X-Mailer: git-send-email 2.43.0.windows.1
In-Reply-To: <20250812142616.2330-1-shiju.jose@huawei.com>
References: <20250812142616.2330-1-shiju.jose@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.48.144.134]
X-ClientProxiedBy: lhrpeml100012.china.huawei.com (7.191.174.184) To
 frapeml500007.china.huawei.com (7.182.85.172)
X-Stat-Signature: zff7u3wdpy1pj9ytttgf3s3pgezsseze
X-Rspam-User: 
X-Rspamd-Queue-Id: 84D0D40014
X-Rspamd-Server: rspam02
X-HE-Tag: 1755009075-706032
X-HE-Meta: U2FsdGVkX1+NTVvlfEWxYaAXjKv1o9XvE3wurI8+pJxX/xR2R9nzg6AX+J0KmrQXR+HUVOt8cRQ8h4hEcT1k95egZkO1Wv7xuQleauxzbJsewtxh1c6wHURSKfyW06La9M17cKzAkdQrK00rTi1w2eCK8awyZdE+UTIwnnHyB/2W3qhV9n1ueKX2vb8ojqo7vYTwvTYObB05U0kJEf/CG8aXNCPtAbA3BdEA/2p7e0JSYn9thRDbi2icLHmFYyYWFqSbBOJVWRSPmqrXy5kFW0r4f2Zf6vo/l2JgnBH9NDrvEq4itIbUvlEpjJHOzmWPyJHvAxPFWroA1NqEfF10YhTg98wuvarSDOZd29E8WyremRI5Pqam8hYV4d5tSHIghCgpsW/X+qGBPK9scSlyKzICrQPAV7lErjARrvSZl0FRDuW1D5zWRB16sQTlYN6e68YyGr3WAknlo2rbSULoHplURAbbtblMpMcwuktpTxCOO1Js8B8sNj/vPFzcVinrO/C/3bY4d/GoLMxQfN/ZVm5fhcR0Cyb3luBKKMAzhPgicN7qAZflTjrr84u5/qzVzUYXaIWH7RHQgXbYNSgjb/ydZVRlSrkGzX7tlPf0CaGX5gYX8hJjSk0LkOZSOpM5b1c6mk3x2q+WjLqW3IAWv5DB2l6r8ML9xW6PUqbOnzR0kivqGy2ZNkjsDx/KFgQWiRLg/x9I2WrHdd7XV407ZZqK2GVIiWUvOABct2rzzwR9iL0iQvKiPh4UUgkaZOqX+oZ6q4qtgbFHcMpKhWIHeq/7P3Z7hvpl0qlGb8wCxkSD43LuyP2O1KMtzH5iIifyXX44R/QDEqpcpZG3G02ryCKmo8lBciWpoph6TuhpqZB7cfgKYSoN8qwXQijWQ5mtAeyqs5oVQct1fZRJBSd/SX0X7w+M04QnRxQT1Er2Xap7r7kF8MmEZWMgDYKu78D5JilSV1tptIZRywKU3Db
 zV+UAhGu
 8IPGwfrHDUuQz8XowfFkKK/gm7nmgzCU4lJvfUUxy9p+5DGLa9I3W0zFCLvXqaBMl76LjpmuBnMFo/T+ioQT2isxZL2Ywg0/Zs+PK0JH9CljcJ4I0GBTt2xJTHAUPxAyOkx/5F5kJdpH7UL8LUkLFAPzG+D8Nm8wPbpbEPnRJnQp1rkvzb1hsfgabLyJMi3KOb2iOMOCZC6h66hD+ctpXdLfcqigtozDPB0JdlPz4mW+HBBTKDhVk1oHSjnOvs7aflwcYjSbY+FhWduLvxYWK4/g0c5zdca33UbrSot4vdMu2Jdjjad1Xwu6xkARlixCqcK/6lfBrcsehtHc=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Shiju Jose <shiju.jose@huawei.com>

In the numa_memblks, a lookup facility is required to retrieve the
physical address range of memory in a NUMA node. ACPI RAS2 memory
features are among the use cases.

Suggested-by: Jonathan Cameron <jonathan.cameron@huawei.com>
Signed-off-by: Shiju Jose <shiju.jose@huawei.com>
---
 include/linux/numa.h         |  9 +++++++++
 include/linux/numa_memblks.h |  2 ++
 mm/numa.c                    | 10 ++++++++++
 mm/numa_memblks.c            | 37 ++++++++++++++++++++++++++++++++++++
 4 files changed, 58 insertions(+)

diff --git a/include/linux/numa.h b/include/linux/numa.h
index e6baaf6051bc..1d1aabebd26b 100644
--- a/include/linux/numa.h
+++ b/include/linux/numa.h
@@ -41,6 +41,10 @@ int memory_add_physaddr_to_nid(u64 start);
 int phys_to_target_node(u64 start);
 #endif
 
+#ifndef nid_get_mem_physaddr_range
+int nid_get_mem_physaddr_range(int nid, u64 *start, u64 *end);
+#endif
+
 int numa_fill_memblks(u64 start, u64 end);
 
 #else /* !CONFIG_NUMA */
@@ -63,6 +67,11 @@ static inline int phys_to_target_node(u64 start)
 	return 0;
 }
 
+static inline int nid_get_mem_physaddr_range(int nid, u64 *start, u64 *end)
+{
+	return 0;
+}
+
 static inline void alloc_offline_node_data(int nid) {}
 #endif
 
diff --git a/include/linux/numa_memblks.h b/include/linux/numa_memblks.h
index 991076cba7c5..7b32d96d0134 100644
--- a/include/linux/numa_memblks.h
+++ b/include/linux/numa_memblks.h
@@ -55,6 +55,8 @@ extern int phys_to_target_node(u64 start);
 #define phys_to_target_node phys_to_target_node
 extern int memory_add_physaddr_to_nid(u64 start);
 #define memory_add_physaddr_to_nid memory_add_physaddr_to_nid
+extern int nid_get_mem_physaddr_range(int nid, u64 *start, u64 *end);
+#define nid_get_mem_physaddr_range nid_get_mem_physaddr_range
 #endif /* CONFIG_NUMA_KEEP_MEMINFO */
 
 #endif /* CONFIG_NUMA_MEMBLKS */
diff --git a/mm/numa.c b/mm/numa.c
index 7d5e06fe5bd4..5335af1fefee 100644
--- a/mm/numa.c
+++ b/mm/numa.c
@@ -59,3 +59,13 @@ int phys_to_target_node(u64 start)
 }
 EXPORT_SYMBOL_GPL(phys_to_target_node);
 #endif
+
+#ifndef nid_get_mem_physaddr_range
+int nid_get_mem_physaddr_range(int nid, u64 *start, u64 *end)
+{
+	pr_info_once("Unknown target phys addr range for node=%d\n", nid);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(nid_get_mem_physaddr_range);
+#endif
diff --git a/mm/numa_memblks.c b/mm/numa_memblks.c
index 541a99c4071a..e1e56b7a3499 100644
--- a/mm/numa_memblks.c
+++ b/mm/numa_memblks.c
@@ -590,4 +590,41 @@ int memory_add_physaddr_to_nid(u64 start)
 }
 EXPORT_SYMBOL_GPL(memory_add_physaddr_to_nid);
 
+/**
+ * nid_get_mem_physaddr_range - Get the physical address range
+ *				of the memblk in the NUMA node.
+ * @nid: NUMA node ID of the memblk
+ * @start: Start address of the memblk
+ * @end: End address of the memblk
+ *
+ * Find the lowest contiguous physical memory address range of the memblk
+ * in the NUMA node with the given nid and return the start and end
+ * addresses.
+ *
+ * RETURNS:
+ * 0 on success, -errno on failure.
+ */
+int nid_get_mem_physaddr_range(int nid, u64 *start, u64 *end)
+{
+	struct numa_meminfo *mi = &numa_meminfo;
+	int i;
+
+	if (!numa_valid_node(nid))
+		return -EINVAL;
+
+	for (i = 0; i < mi->nr_blks; i++) {
+		if (mi->blk[i].nid == nid) {
+			*start = mi->blk[i].start;
+			/*
+			 * Assumption: mi->blk[i].end is the last address
+			 * in the range + 1.
+			 */
+			*end = mi->blk[i].end;
+			return 0;
+		}
+	}
+
+	return -ENODEV;
+}
+EXPORT_SYMBOL_GPL(nid_get_mem_physaddr_range);
 #endif /* CONFIG_NUMA_KEEP_MEMINFO */
-- 
2.43.0


