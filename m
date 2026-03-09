Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ABFFAF3C240
	for <linux-mm@archiver.kernel.org>; Mon,  9 Mar 2026 12:09:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 11C0D6B009B; Mon,  9 Mar 2026 08:09:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0FE076B009D; Mon,  9 Mar 2026 08:09:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F14B36B009E; Mon,  9 Mar 2026 08:09:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id DD6A96B009B
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 08:09:22 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 807521383B6
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 12:09:22 +0000 (UTC)
X-FDA: 84526404564.16.11FFFE5
Received: from PH8PR06CU001.outbound.protection.outlook.com (mail-westus3azon11012029.outbound.protection.outlook.com [40.107.209.29])
	by imf09.hostedemail.com (Postfix) with ESMTP id 629D614000F
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 12:09:19 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=5bIZHJDN;
	spf=pass (imf09.hostedemail.com: domain of shivankg@amd.com designates 40.107.209.29 as permitted sender) smtp.mailfrom=shivankg@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773058159;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=j3JviBQpwSfrAAQVeEbzSZyJ9whuVjAN4LWwHJVqruM=;
	b=Oo8LNnamoFSy7Vr07rAB0noILNNhrDNT/Xy4HgR4UUbRqyA2CxW7WmeymFFx/ZFV30M5gS
	Rn59fUCHz961V0+v79LY/CfDuqLJcu4MlVxegtbAkAapSzBYxu1eoV1zh8JirWqAWDN9FK
	Hcnzp1RSLBgKxeqh1JYDr6HIe+wf/L4=
ARC-Authentication-Results: i=2;
	imf09.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=5bIZHJDN;
	spf=pass (imf09.hostedemail.com: domain of shivankg@amd.com designates 40.107.209.29 as permitted sender) smtp.mailfrom=shivankg@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1773058159; a=rsa-sha256;
	cv=pass;
	b=Cnys0iJ/TKfCkc9bnfsuS4CjY1a0NFtRViNaQRzQBp6bnCuMAacQuoMtcPxyT3ZisuwpxQ
	iGKM9tZKDvnAGta9MaiHKIYlWP42KoNnEwV05s3PN91ebwbiW6c8lP21zHxqs+ANmwXi9t
	dvGOuqkJlkus8t8ZQOeCyYYNKswa4JU=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=V9dyG6i/rbwchfI/KdGvICJHuwbLlxy0F+AKrnseRZt0Jlj1J23vptCTM7ommxACm0i/iLPC5B3xqERF+hKrtWAspUq9Q/uG9+pB/K/yamqU8HjV5iJNgr6vLaOZBlXfO1dAddetk2IYgcf6R8j+TxuTDj306LuZBwKFcGzyG5yclSKNJtOWNjb1ATZ/dS3YQiGFUeSUBrDMizrcb8r3Wiwh5Qy+7WNNW5K4gJwQKXIREi4k4ExAdHUQDwLylX5y8isQ6z6S01q+BgdjbZBcP3NPsj6oeSu6wHRHDycE3MPkWQNUPT0VUZ+jxjfbJc3yIAS5A3W3AbhRs/5GkmCMnw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=j3JviBQpwSfrAAQVeEbzSZyJ9whuVjAN4LWwHJVqruM=;
 b=QMm18C339j/8cq8gmXQCTusx5euyu/+lGMZSSnuyBJviJBn56w0wtV6U1ic+o10+WfjXGQw8VnNH27rwCgkslbYi9102dt4nxf6BJYAdrn4IviU63sdkfxVl+HbXb2IZUZP4jDfwzD9mbKciiVAUBAMexH3hM34kQutGpnI6t15PKDdffpZxrPhnTAPCyFMf4LKng4TPS/kQgEERbPJOqeQ3WomAg3lk4Qz/aJXUhVhS5xn/ZlfESZSN0gh5axt54MMQBkh0KMqvgbAovpf03BP9Mdc+JOu87Cn6k1+A6SCTiLuJ72aJ8QcxaRGb6A3jS3cME/N15hmysa/AYGfVng==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=linux-foundation.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=j3JviBQpwSfrAAQVeEbzSZyJ9whuVjAN4LWwHJVqruM=;
 b=5bIZHJDNyI4tlRCUGrLCzMJCY5GA9B/NPXiQRqj7E362D2YQnn/xmw5YkTyGCXa/O27C7EDikCXTh5IO2C9BN9Npvz0gUCKn3rVZHNG+xTCKn0SubcMnSK4/TIMfHrkufs3WfNabvOesvtC2tFBw75eQNtj8FsmPBq/vXUjKzFg=
Received: from SA1PR05CA0013.namprd05.prod.outlook.com (2603:10b6:806:2d2::19)
 by SAWPR12MB999141.namprd12.prod.outlook.com (2603:10b6:806:4e1::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9700.10; Mon, 9 Mar
 2026 12:09:16 +0000
Received: from SA2PEPF00001505.namprd04.prod.outlook.com
 (2603:10b6:806:2d2:cafe::7e) by SA1PR05CA0013.outlook.office365.com
 (2603:10b6:806:2d2::19) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9678.24 via Frontend Transport; Mon,
 9 Mar 2026 12:09:12 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 SA2PEPF00001505.mail.protection.outlook.com (10.167.242.37) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9678.18 via Frontend Transport; Mon, 9 Mar 2026 12:09:16 +0000
Received: from satlexmb10.amd.com (10.181.42.219) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Mon, 9 Mar
 2026 07:09:16 -0500
Received: from kaveri.amd.com (10.180.168.240) by satlexmb10.amd.com
 (10.181.42.219) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Mon, 9 Mar
 2026 07:09:05 -0500
From: Shivank Garg <shivankg@amd.com>
To: <akpm@linux-foundation.org>, <david@kernel.org>
CC: <lorenzo.stoakes@oracle.com>, <Liam.Howlett@oracle.com>,
	<vbabka@kernel.org>, <willy@infradead.org>, <rppt@kernel.org>,
	<surenb@google.com>, <mhocko@suse.com>, <ziy@nvidia.com>,
	<matthew.brost@intel.com>, <joshua.hahnjy@gmail.com>, <rakie.kim@sk.com>,
	<byungchul@sk.com>, <gourry@gourry.net>, <ying.huang@linux.alibaba.com>,
	<apopple@nvidia.com>, <dave@stgolabs.net>, <Jonathan.Cameron@huawei.com>,
	<rkodsara@amd.com>, <vkoul@kernel.org>, <bharata@amd.com>, <sj@kernel.org>,
	<weixugc@google.com>, <dan.j.williams@intel.com>, <rientjes@google.com>,
	<xuezhengchu@huawei.com>, <yiannis@zptcorp.com>, <dave.hansen@intel.com>,
	<hannes@cmpxchg.org>, <jhubbard@nvidia.com>, <peterx@redhat.com>,
	<riel@surriel.com>, <shakeel.butt@linux.dev>, <stalexan@redhat.com>,
	<tj@kernel.org>, <nifan.cxl@gmail.com>, <linux-kernel@vger.kernel.org>,
	<linux-mm@kvack.org>, Shivank Garg <shivankg@amd.com>
Subject: [RFC PATCH v4 1/6] mm: introduce folios_mc_copy() for batch folio copying
Date: Mon, 9 Mar 2026 12:07:22 +0000
Message-ID: <20260309120725.308854-5-shivankg@amd.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260309120725.308854-3-shivankg@amd.com>
References: <20260309120725.308854-3-shivankg@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: satlexmb07.amd.com (10.181.42.216) To satlexmb10.amd.com
 (10.181.42.219)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA2PEPF00001505:EE_|SAWPR12MB999141:EE_
X-MS-Office365-Filtering-Correlation-Id: 4e1614c5-54e7-4ef6-dd57-08de7dd4af8d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|82310400026|36860700016|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	o+yzEPjzqwMnXxWwIQIxHPIa/KMFJ24FraqeV0p/tYyDVcHIx8atWR0fu5CvJJpPyFY6y30tO/cjeOSY0eBR1rM5PuID1mZYZou0kUbBKWcj4LBnu5nSwePZgqX8i5OgKlgaZDieiXDDMJG+V3PctaFJn8jEc/rQt2TL/A+k7ppBa8RyhCEGliHAdZSBEjnJ/XriT6zniILfl7YjpuI1nYXzkOKHB+6QKZFC3jQMSBs1GP/szPGRfJws58dXjcowbCXcnLyMXH7tM51Hldf2rzYSU2Jw3PM1evoFFwdHwbkKoL0kduBNAUEX1dTFJLIVLGwu1L0OwD8XHrHvCbvI4M42ihWevXfievMac/Na7lDvXhZ7aV/E5B0z1FCbcAWtUMETfhby0ffQals98pL1LmHiUwi6EicbnTB9T2pwzEQBrBLySm/fYpJ4MipBoZk0MHKbrC35+L0AKQS9lq3nNgSUA4x17lhH2aVTIrK6IpQGwmlOoulXxjJzb1iaIovTpV+h2inOf37WfPOqZrSsnkNebxP4hWaAzYv5v3zv5HD07CXchH175Wl4i15+rVUCQM+WwbOU3eiMsG6rFwBAB7lFvHnpB1GunlhjNbcSu8SojkW8eJixtVCk+tbKTiH9iNzVEqfzbRzDCg7WBWccsAQo2ZVA2lnBfN3ahpOGnmSNSHAgliEllPwZol3O7HKdJEaV35rBDx4q5NUJ53mhPAIdt41ZdxVF6a81L5OKRidarHEUe+0Ud0k+0wMCzqvQzvZ/EJTZwbZvS7uwQVAzvA==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(82310400026)(36860700016)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	PKUbSv92d6ato9RgZBRV18xICSFjDHf9+Yg42SqSdH4q9II4VoMpCUOiaG6Ya88m5/7Zf6gYFK5KGTwoPbFQ45vZyTZPovVFg+csGD/y+4fVEnoFgDSYLpOd1h+uhqGZSoWJcLxvCbxnQcGYnWLmadDohYxFwzf886EJTU+4zwDNajzwGMwccZnWxod3nog5Kq+ESdrW/4j7TN6o7oURwSdnc4kYSAaOq3StLPT6IEk06eqhlgyhWQF5Ge29l/wPKQqbKfHo7kfNVeroa9oIbeFeXDar12SjcaB3G5e9AmS4lu+2k9tgw4BvIy4tKxgoLRdeJP09VC4twbdIbp47uukvOzLeo0yN82a40VRQxMJs+pF90SP8ZFzp2CXyG55dsoY0eVdijltgfYkAGzKWhxK42LKjRgWYVohDlyxLUAC0ToHnb5FYA6ey92YxEWjI
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Mar 2026 12:09:16.4410
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 4e1614c5-54e7-4ef6-dd57-08de7dd4af8d
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SA2PEPF00001505.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SAWPR12MB999141
X-Rspamd-Queue-Id: 629D614000F
X-Stat-Signature: zqrj4ttsi489ffzofn5tum4emce9eycg
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1773058159-413500
X-HE-Meta: U2FsdGVkX1/VsbliGstnnFyZJvIhmNAMHK3nXaXTWUgnShLj0j/pmsfg4fMduA1LHh4yQDqjbczo3c2hF/Dnb278JNjjwIkWcArkhvQ6i0yYEAl/R7a67AvZHQA9I3/dJhQdpRfy5o7OXZR+7pLdIu8/Dme1EXXnFXP6PAT2R6gOUw3tTUk5ObtSUSs74EQlX0WtcHEJ3eXeD3IXBohcVIiqsDM12vu/byopkoGiChtkPFi7p2teCmWRk9GhpmJ2MLqtP+Z4Yl62M+oee5HEmZl4rexGrv1mpFW1H6Wq8bMhGhjuUT3WMCHLXL0v1XOLXJn7D7Ln/077hke+owc7Kx6cWfC40EJGK10mJPnMnIOeiyr2CVYgxQ9ZLdITYr+zuxGKrMSEE17v7ndfZqUmmCTPUrbrRLY3IoKqXyFG6ptt71j8OU2iEDasASPCZ1kdqVukK5CDQq+hyHO0Y82Udl6T78AP1yHyk5bRqpsLu6l7ZjEQxRVgTexJOEDxFrAqjKxE6YdS/zgVFoXXb988P9Gnswdf2zhINit3eScn3Yq/epQbv86XtSCOw7W+Vzye90HzPpgSoSodE3Ac4jkLnXdlS8E7g1aX3Bn4IRo45014e651BHf2HjOtxHuLW97Qk1+8OBlRwYsX/JxDGSId7n8EW2HGPwMrsnRtH8ovcwziTEq6pUrFi4AYHwDgNEFBN0Ef+xvvZnu5WIF17Oh4rY7QBP41e7cGQgAAphiUSHLe8W8p+PNZF8iC7it1Asd79yRowTvj/hFv+c0WlDF/lWPj3dCLpO1NqY2ePEuoi4wrVA6UbFEi/0YdKGZj/M8fI69XfBG/ABCzMEcfoU54e57duv0a8NNHB3+eA2BDuJpdteWp3Tu4TwC5ZhaiECdvMKemutIQv5SuxPRIFqX6pHkoM2bfBhsfwlZ5VEZ2AyaB0/6KrhUgf/gMicBFImxdk8Mx8FNu7DO8ehgsz3Y
 npx7Seqz
 hwVuEXQ6Kcn7xl2t4N4lHeXYVK+MCRIhcN/holhUfc0xaKMRRHgrtapAvz76TPZ/8H4+bm3oruOwCNNGMVqZNdlYV7cTIaxgm+tRV2AR7DudSuDblpIJI2wz/lbDmz36L0X10ndjl8zOvuEu68Gas6mAkhHR0dFjX/HFH7Tb8l2uUh/iBH+pF3oMslHIyhIDG9NYqABcku9wh9+OsReSm9vAWXQWf5ZgUR3GSLQw1likJ7kKG6Qc+l3/7m5h6KZHs42FBPiTyb1Wn2fY9Bme/CvUaAhLahdA6C+pcYoVi9h+TRDEA8tw02SJYYYC0YQp2s+C02ruYGWubTGUMHT94DUNCr0LA1K1tuEttUzwq6UmwyaCwRoYFQM1QheYzTTsfBppXZ5iToG8Ju9YIxHT3cWfWIY1bzcXGa8xhExyKhre4TWAyuuPmjnYccbikxLMUpsl5oI8YnmYOKF93WUEUYenBOQQSriVwV/ufEfnYcBCGSFQERb3ifTwieb45ScOmK7CLNaMjIGkITTZXERRjlCWeU+vz2j913O/hDqJwqE/9nHcHZ7K31Wq7+TzOnBg0JKvlefZF3NSp1NeU5u2MnJVVA8ptMzBRhibE
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add folios_mc_copy() which walks list of src and dst folios in lockstep,
and copies folio content via folio_mc_copy(). folios_cnt parameter is
unused here, but is part of the offload_copy callback signature used by
later patches in the series.

Signed-off-by: Shivank Garg <shivankg@amd.com>
---
 include/linux/mm.h |  2 ++
 mm/util.c          | 31 +++++++++++++++++++++++++++++++
 2 files changed, 33 insertions(+)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 5be3d8a8f806..e1ca4d6b7361 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -1644,6 +1644,8 @@ void __folio_put(struct folio *folio);
 void split_page(struct page *page, unsigned int order);
 void folio_copy(struct folio *dst, struct folio *src);
 int folio_mc_copy(struct folio *dst, struct folio *src);
+int folios_mc_copy(struct list_head *dst_list, struct list_head *src_list,
+		unsigned int __always_unused folios_cnt);
 
 unsigned long nr_free_buffer_pages(void);
 
diff --git a/mm/util.c b/mm/util.c
index b05ab6f97e11..5bda599168f8 100644
--- a/mm/util.c
+++ b/mm/util.c
@@ -749,6 +749,37 @@ int folio_mc_copy(struct folio *dst, struct folio *src)
 }
 EXPORT_SYMBOL(folio_mc_copy);
 
+/**
+ * folios_mc_copy - Copy the contents of list of folios.
+ * @dst_list: destination folio list.
+ * @src_list: source folio list.
+ * @folios_cnt: unused here, present for callback signature compatibility.
+ *
+ * Walks list of src and dst folios in lockstep and copies folio
+ * content via folio_mc_copy(). The caller must ensure both lists have
+ * the same number of entries. This may sleep.
+ *
+ * Return: 0 on success, negative errno on failure.
+ */
+int folios_mc_copy(struct list_head *dst_list, struct list_head *src_list,
+		unsigned int __always_unused folios_cnt)
+{
+	struct folio *src, *dst;
+	int ret;
+
+	dst = list_first_entry(dst_list, struct folio, lru);
+	list_for_each_entry(src, src_list, lru) {
+		cond_resched();
+		ret = folio_mc_copy(dst, src);
+		if (ret)
+			return ret;
+		dst = list_next_entry(dst, lru);
+	}
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(folios_mc_copy);
+
 int sysctl_overcommit_memory __read_mostly = OVERCOMMIT_GUESS;
 static int sysctl_overcommit_ratio __read_mostly = 50;
 static unsigned long sysctl_overcommit_kbytes __read_mostly;
-- 
2.43.0


