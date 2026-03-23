Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BD4BFEC01B6
	for <linux-mm@archiver.kernel.org>; Mon, 23 Mar 2026 09:51:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 232186B0088; Mon, 23 Mar 2026 05:51:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 209226B0089; Mon, 23 Mar 2026 05:51:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 11FE76B008A; Mon, 23 Mar 2026 05:51:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id F31116B0088
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 05:51:47 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id A55D78C88C
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 09:51:47 +0000 (UTC)
X-FDA: 84576861054.02.56B6195
Received: from BN8PR05CU002.outbound.protection.outlook.com (mail-eastus2azon11011065.outbound.protection.outlook.com [52.101.57.65])
	by imf09.hostedemail.com (Postfix) with ESMTP id AA75214000E
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 09:51:44 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=g4XgEb1V;
	spf=pass (imf09.hostedemail.com: domain of bharata@amd.com designates 52.101.57.65 as permitted sender) smtp.mailfrom=bharata@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774259504;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iaATkYsbyA5exeptDiOgOt0HKO4PaYF80Qu0mf2RYzY=;
	b=EhXnvPa+U/tsY6+DADhH8/ubbAl4IqK+JslxWn60XCzZEJmcJ1M99jGSECGCnfh4baRYww
	IHMjTRQb6fBRD71gRfqQwDUuWzKyvsQ+7CueeiDEDOJu1hNeRaXic+MKMISQBO34dbjpVz
	5Lz/fo7TsN8SOn8COD3FkGpWV6s6x2g=
ARC-Authentication-Results: i=2;
	imf09.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=g4XgEb1V;
	spf=pass (imf09.hostedemail.com: domain of bharata@amd.com designates 52.101.57.65 as permitted sender) smtp.mailfrom=bharata@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1774259504; a=rsa-sha256;
	cv=pass;
	b=qUwK91hyatrX41sx+m63m2kBbYRxg4HT+3lWfMhGeQC3e3AjDcygvsPO9UtqOlbeTgD8rH
	8ZJs9opOnQDr7C5EIfCo1+8Kq17mXT6fIa+wUe6Tmixggl171xDYbcYHrv62hC/VBE0EZr
	krTjB7VMSSrLuXlCMmfjfsYr/zofDno=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=pdV2pD9CIQP31ucEnDcH1PQUjBDt0R4RpsCsE8msxr0AcTCpb46LzDpenMklU3inXAzxu40/ZRJzadeNawvbiSaz4DYYpFYczsJqlDn3+7MDHNK7Qx7Cp7q5LCRV9hOeQD/4c7GGuv9UPqYQH6ystYTfzBUqio9ar1u3FAqmoqVlojLX271ZToLGkb9RFAbVBMn0lfjlcf4Cn6zYRnjY9JzZX2R//ANV/vXR+jeUI9j9KAmZ1KvOGZ5bLsQ9jA53bvQpZNc6QGJuKHwyCIalF7VAQM6rAWBSnXVto8lHo/e7Sm+1GDMNE6RSauHoc+cCHikf9wnQ/xWivv6HfQbKrA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iaATkYsbyA5exeptDiOgOt0HKO4PaYF80Qu0mf2RYzY=;
 b=ij4Lu4y/M5m5438pbFmXXSCWCsGWgeLPv0sjn5pEA89EvhyrViyUNbVj2+CZ9vHAICGeB6+C8z6nP/tF0Cy8kRc5zxyYwq4LFCzT8lZzVpS49UFjzWhvgUch+DbyT8+3yt9O7Ptskvd4l+WbNUnri03sWp9zCKlxTNy6lTZ8Wg7qD7Nh1FW/ObCwgrIN1q3oWtLesg4yizSvi8N6n8JwpcYy5z0zKo2Krm4nes6Oba5lR0tjeY76KybUHJMqKaNTizBmQiwRis56xqZCsWw9eHo4jiob5Dzqa8m4Aoo8CyeaaBWM6XRQ/JxQ5MzV6ru2ESrjTLBWXrttPXMNNqc+7g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iaATkYsbyA5exeptDiOgOt0HKO4PaYF80Qu0mf2RYzY=;
 b=g4XgEb1VFMfRYC93DULzv5rqguaaq4fSBkT+iwyxo3TalXBz2XtnvIwxBm215+cQhh7nZe6U9TyKYmcYSY1SuuDby74dx/pwTNcMk7kg+Owwdm9Qwu5jTJhoRHEClAn19RriCCv6vj001HqQItHYlOVXk8abDgU7m1aZU0EiuwA=
Received: from CH0PR03CA0409.namprd03.prod.outlook.com (2603:10b6:610:11b::17)
 by LV3PR12MB9094.namprd12.prod.outlook.com (2603:10b6:408:19e::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9745.20; Mon, 23 Mar
 2026 09:51:41 +0000
Received: from CH2PEPF0000009F.namprd02.prod.outlook.com
 (2603:10b6:610:11b:cafe::4a) by CH0PR03CA0409.outlook.office365.com
 (2603:10b6:610:11b::17) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9723.31 via Frontend Transport; Mon,
 23 Mar 2026 09:51:41 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 CH2PEPF0000009F.mail.protection.outlook.com (10.167.244.21) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9723.19 via Frontend Transport; Mon, 23 Mar 2026 09:51:41 +0000
Received: from BLR-L-BHARARAO.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Mon, 23 Mar
 2026 04:51:33 -0500
From: Bharata B Rao <bharata@amd.com>
To: <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>
CC: <Jonathan.Cameron@huawei.com>, <dave.hansen@intel.com>,
	<gourry@gourry.net>, <mgorman@techsingularity.net>, <mingo@redhat.com>,
	<peterz@infradead.org>, <raghavendra.kt@amd.com>, <riel@surriel.com>,
	<rientjes@google.com>, <sj@kernel.org>, <weixugc@google.com>,
	<willy@infradead.org>, <ying.huang@linux.alibaba.com>, <ziy@nvidia.com>,
	<dave@stgolabs.net>, <nifan.cxl@gmail.com>, <xuezhengchu@huawei.com>,
	<yiannis@zptcorp.com>, <akpm@linux-foundation.org>, <david@redhat.com>,
	<byungchul@sk.com>, <kinseyho@google.com>, <joshua.hahnjy@gmail.com>,
	<yuanchu@google.com>, <balbirs@nvidia.com>, <alok.rathore@samsung.com>,
	<shivankg@amd.com>, <bharata@amd.com>
Subject: [RFC PATCH v6 1/5] mm: migrate: Allow misplaced migration without VMA
Date: Mon, 23 Mar 2026 15:21:00 +0530
Message-ID: <20260323095104.238982-2-bharata@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260323095104.238982-1-bharata@amd.com>
References: <20260323095104.238982-1-bharata@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: satlexmb08.amd.com (10.181.42.217) To satlexmb07.amd.com
 (10.181.42.216)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH2PEPF0000009F:EE_|LV3PR12MB9094:EE_
X-MS-Office365-Filtering-Correlation-Id: 95f4ad32-587e-4153-ede4-08de88c1c8e0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|1800799024|36860700016|7416014|376014|18002099003|22082099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	QQ88nRa0ldXBrAkqQpErlBo7VABkHPpsxgVkiHWyIedlfoy5th/ibB1+bowvxT/z1K3qIGHMucQRR2F0IYgDR3DKAahuQPNLL1ZTAy5odh6RQYB6rCPUBakKh5n/AM7VHUhiHmrqcFRsO3dmcKPb/A8W5lvMiW80rP0uEhh6Ud1f/sQy8ClJIFK5wdCGImS+mR7CX8JnD5/w9MiaRP488cL3ZZwWcCN3eehKnIpfG2IKeyPvIk6EgVAsliEl8kkI+70DImI41GNoK53/NGInsCrpMOUA+SnJ8MzNEa9qm+Qa1LaBRmfagpdu6MfieSXRtzDwCcAGDXRAs1nP1cqRcaW4mc8TYEv5SiIASR12vVk2V+1kp6FsF0tT4t4o4hzwz0a4ZwIWMWgHcpSmSrMiAoFONkW2P47mvrVYc3EO+aIUTYd1rHXRvrwjGh+kq6NfkHe7SqgWLxVlDWnhiQP7EswxlutQtLmmujNspq4kP4Hn+fd8Ora/nRZHEKyzn2JbJL8IzGQp6MnbWFw8yNukI2ZcFcfzLzsLiM/wv2Z+F4NJYTtEYUBK0DNR3LMFWF578TwlcD0Ep2m4RiPno+WgnuRDyw149XCD91WuVD8Q49Pqc2jalWMIbXRUZHYCUqOa1rxALOU6KKbFfeVxORan5k9+8YlSYFWM1ZWrXuLyEOJ0JKUzL+IhCujSg/5+qGRITXpvAS9weWSP6J4KQ+HleYEN7ZHRaWa6HhvNOfs2h4vKJbZNOpD2OPd0JBgrViUzVUHsUC/9oUvZNVvsBZKa/A==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(1800799024)(36860700016)(7416014)(376014)(18002099003)(22082099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	dwQJZiooeUKmJu1jSj2WKO0MGqjJyTDvGv2N/pvt9soZSNjEF/EUUcBwliIW/NYVhg2n0FC3RIvVeDpJMyTtOq+m1mxM5q54dopYZ4Ol+pap/z9mbtofS9AoCTu2ZJWSXGCN7iRNtdP6IhbmZ9M/ILq5EF8W9xRi1hG2HeVk7rqTySWMtIaOZ8vZFOVsCR9Y0D+wkJGu5DLX9kHxYrWSDsfIpSUYJiSXcyJcu3UKfsjtpwxLl1Ev9E+xoivnWtddCOyin3j8t5wfmVWFnJoNiKo89N/2dffoFIG4dZqmLngJ1Q4J8l3YsbKyBCTnvGJyMaQrp9wRJFpn9tII/bJoH8y26aHacjOwwgVdrymTZVV0ONlZvA4hiMWBPJeTEatt6IoKCV6rAFPzjjliZs5C7sJca2KeLH2JZt60NeijPxokYXPQR/nkGEBZnjLm0LmJ
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Mar 2026 09:51:41.2826
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 95f4ad32-587e-4153-ede4-08de88c1c8e0
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH2PEPF0000009F.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR12MB9094
X-Rspamd-Queue-Id: AA75214000E
X-Rspamd-Server: rspam07
X-Stat-Signature: 6u19ru5m9yt18x8bppr3a3dmx67c819b
X-Rspam-User: 
X-HE-Tag: 1774259504-826293
X-HE-Meta: U2FsdGVkX1/KScE8G1DarJfjPJnjnFIzDo5hNrEcFVWDKLRj/PxlYhgBqY8elzX7d4Tks+3Ad7YfndkjVMtXmqCuEdbGvfZb4SDjofmOq3uDfMnvhFPR1PBZBh1KGLT9jLVKkbBxkIze6Gl8gvM/uOLuFGSZQWA9qjtMDdkYetC4dgXlXt4L1VIXCBOBRwR1eti2ahKEChU84JIPksEQzPOtt7jTsl9n/ObYQ3UyuB/d4iNay6wTUpXs/4nfc6NcSIWj9Tfr3HlNaMmhrkcBiYL2dft40IpKcDQahr3x/uy2WWQJfau2M7ZcQxVgG7iN4MwlXuQIbCLu6g+PxQ/GzKg3TcjHGNzELt5DdH7Sm1xEPyH9fcxygqxxjfgRuni+KKUmQ3JJ8U1Hr1tysEmfMP2Ak0IRLqNA5762HMqF9VZurh4so1/gBG50ye3Y+i1UNnjaB3zGxoydfArV39pM4IkN65zqel6eZOp6DXL7RI7WfQ4rx+7VgVtl65aQWxAFitKgJLoxsz5n3QF0F4VW+B9ix/INFypSp4jfNmPtjzyiPPYUHd0cDx39rYafd5X0xE3Xkgsn+ioepFhap/WDZHPy6JT+2vg/cpqKAotO7dbdPNJ84+hPZs1S7S3iv20ApD5oDYA5jCDCYjPaF9LyujNpYCUYFF4qt7JBzERLqVmz/4AuCQ9hxHhEAFArX6cZZ4rhmA3Dj23Je3EIhTZ2uLRfbcZvxcQUJWL1nvox7E1YjmLt8BXe2oALN6Q2Ugp59+/FwPwFP0cmM/mSE5WMIGV3PeDOJvKqDwpdo6aISpnl2TYnCLa177NCHc6VPJiDbKqfhDu24I3rjns3beCXDpNTo8Tr0fXs9FPYYxVrZ0P4ejuF7eQSYRsaT4zgWQtTlKmugpaDxJRD6o5ZpgaC+jNzV9KRJhcDUA1zOy1QJmyrR4URg3/4s5zPdcSrNMUalG6ptnEXzCTO3zZJwBX
 bvCvLTsg
 WAxYY1ne2QlbNIdG9aJ3Kn0CtcvKSHv9kED2G6wRaOAHbIWE2hfFLJob2hEqcmUifIv8dmfQg8pF8rFTUJ0OEK8tMZn0omIXXD3DI0B0AZoB8/+ofEhrUGa/Q48soo2oYtp9IvMHkM8Va41zpzuDoDpoIddEYMFk8qgSMcGZ2PBhGrZvXi/SPv5/czfQ/z6F2hGdApQT//i2JpzMJeQhoFMnZpw+VJ4eavcQ93XNkTDslUNL7yAHMUsrYZ3bVlJFKEIB1Vjb/6Z9D93KcQiLJkxZUsH7aJbw8pV1YuCcCMVJ1CECOdqPUJS2YOx21rvbRjsZQOT2lrHyakHi16++pS7H6dXJs+fj8UTudwYiQ/H4Q5zIk1/fbgDH5jN5u3ld7Vz+HLV4lnllY7xEzthcjJ1gIlQdQMLXt+vLZheptJqX+PTtul0fzBc4k4WGRicmfNMZ3aVuOK5UFnScfWtL77sBgnbOAf4smMx60dbsE/CsJTe2hhW6vT1pME8GXr2mReOkOovWC0xKJpcw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

We want isolation of misplaced folios to work in contexts
where VMA isn't available, typically when performing migrations
from a kernel thread context. In order to prepare for that,
allow migrate_misplaced_folio_prepare() to be called with
a NULL VMA.

When migrate_misplaced_folio_prepare() is called with non-NULL
VMA, it will check if the folio is mapped shared and that requires
holding PTL lock. This path isn't taken when the function is
invoked with NULL VMA (migration outside of process context).
Therefore, when VMA == NULL, migrate_misplaced_folio_prepare()
does not require the caller to hold the PTL.

Signed-off-by: Bharata B Rao <bharata@amd.com>
---
 mm/migrate.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/mm/migrate.c b/mm/migrate.c
index 2c3d489ecf51..a15184950e65 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -2652,7 +2652,12 @@ static struct folio *alloc_misplaced_dst_folio(struct folio *src,
 
 /*
  * Prepare for calling migrate_misplaced_folio() by isolating the folio if
- * permitted. Must be called with the PTL still held.
+ * permitted. Must be called with the PTL still held if called with a non-NULL
+ * vma.
+ *
+ * When called with a NULL vma (e.g., kernel thread initiated migration),
+ * migrate_misplaced_folio_prepare() will allow shared executable folios
+ * to be migrated.
  */
 int migrate_misplaced_folio_prepare(struct folio *folio,
 		struct vm_area_struct *vma, int node)
@@ -2669,7 +2674,7 @@ int migrate_misplaced_folio_prepare(struct folio *folio,
 		 * See folio_maybe_mapped_shared() on possible imprecision
 		 * when we cannot easily detect if a folio is shared.
 		 */
-		if ((vma->vm_flags & VM_EXEC) && folio_maybe_mapped_shared(folio))
+		if (vma && (vma->vm_flags & VM_EXEC) && folio_maybe_mapped_shared(folio))
 			return -EACCES;
 
 		/*
-- 
2.34.1


