Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 025B5C9830C
	for <linux-mm@archiver.kernel.org>; Sun, 18 Jan 2026 19:26:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 55E216B00B8; Sun, 18 Jan 2026 14:26:20 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 505F26B00B9; Sun, 18 Jan 2026 14:26:20 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3B3576B00BA; Sun, 18 Jan 2026 14:26:20 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 298666B00B8
	for <linux-mm@kvack.org>; Sun, 18 Jan 2026 14:26:20 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id B6E738788A
	for <linux-mm@kvack.org>; Sun, 18 Jan 2026 19:26:19 +0000 (UTC)
X-FDA: 84346065678.20.42FEC84
Received: from PH7PR06CU001.outbound.protection.outlook.com (mail-westus3azon11010027.outbound.protection.outlook.com [52.101.201.27])
	by imf13.hostedemail.com (Postfix) with ESMTP id D44DD20004
	for <linux-mm@kvack.org>; Sun, 18 Jan 2026 19:26:16 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=Mpf6Snmu;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf13.hostedemail.com: domain of shivankg@amd.com designates 52.101.201.27 as permitted sender) smtp.mailfrom=shivankg@amd.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1768764377; a=rsa-sha256;
	cv=pass;
	b=V9fZYinVQzoo4OVhYbIoh9DQoqyPKKmpIRI2dnC0h+Ls65vXEBGT2JhQDpTg6v4/sGXsZ1
	JLwBEz3Vb5+g0wrMigaEXwEogOpNQ+VxmzkjxRHc+Mmb4FDGpBgOCBewO2xcm5QnLweqNt
	XfxYPBroZV4zYQ7T8N+MEAw3mCyBa1E=
ARC-Authentication-Results: i=2;
	imf13.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=Mpf6Snmu;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf13.hostedemail.com: domain of shivankg@amd.com designates 52.101.201.27 as permitted sender) smtp.mailfrom=shivankg@amd.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768764377;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=LhDhKJ13hp7zqCWg6kFUR8hCQa141ev+0LFOOVaFKLM=;
	b=YyKm7H8Bb5v0UGXbfsoPPpFi2o8xGiHR7mekwfR9+P1RCLbu8x1VaHjtn5gmDXvPJOTJEb
	IRWGrR+472nQv0AmBWGqfkU/rDu4GjPLIS3ukYUaGo/DlyX/0D6rhijX07hlX6Kyqowvop
	2UV5oSCycF+zM/Qv+CxMfzK0iGiW9iU=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=iLnIegfFr4S4vlzqqjhXu1QpIypqO+fnA6kmRG++uQwQQX4pZJNn0K8NQq4BQgf87fqwTcMUfXJuFI/1igr5XIEXZ3xbLgNazfJUix73PM9If/fEtbSFsnRWgSIIkPjroUTlusJVwQNRd6l1vQVTWQR12YvJrWf4QvN/A5qElwRski5lNCFu9RBPTefjz8w3Ng4Sp+cA2hnRpIpEOeeHIF8Z4JSReC8IfFnMJrRZ/ED2qt36CACN5s8ckgZ2VGwH+l/c1Be2qv0RCxbOpW6Hu0DVLaOmrX5KuC5ypelObBIgBymbhdSwbl9elCvoNUSrh03YeVPY41ej6TqMbNwg9Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LhDhKJ13hp7zqCWg6kFUR8hCQa141ev+0LFOOVaFKLM=;
 b=kW9It6Xd8OUGtjqvEd23JTlA4tp9obU7JTGQhw6COlT+4p+iDthqJY3GeWmBbUUojcH0PyekAeLeW3fVlDufM0F/+1ieY47B1x8z8/eoFM33WbVCkGolzbBdO1j8QupXZKZF53Q4VKt5mgu95x7HMqxEga6W9GMI2+q2wvPzHbWQRhV8wwlzQPJ9a+NULjeLfYrhLo2ulvKiRYR9QGPgOy88sar+YPUtvBj6CHseuZiC8y+RzohJl1ERn8GX1iCXsjaHSBbUuMfktiUkiBRbOb1Bvr9N0q6MZARNlJne74CwjK9h+LXD1Yx+GUU9i70rq/Kra8fyqJqExaHSsU5d5g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=linux-foundation.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LhDhKJ13hp7zqCWg6kFUR8hCQa141ev+0LFOOVaFKLM=;
 b=Mpf6SnmuM2OV76iY8cSaImNIqMTp9Pq8mf54RxQWne4B/bJFAiemR9emzMfkNVj5K9R6xEqw/lqX1QckNtrZt+mwEl3Sb9P9FDf6Z7Mvp/F4mgQVnX+N7UJMHOiGMQDfST7KiRwBtkJOpylbTqvroLAB/Lv7jTsm3fX/V21IunU=
Received: from BY1P220CA0001.NAMP220.PROD.OUTLOOK.COM (2603:10b6:a03:59d::14)
 by BL4PR12MB9478.namprd12.prod.outlook.com (2603:10b6:208:58e::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9520.11; Sun, 18 Jan
 2026 19:26:10 +0000
Received: from SJ5PEPF000001F0.namprd05.prod.outlook.com
 (2603:10b6:a03:59d:cafe::d7) by BY1P220CA0001.outlook.office365.com
 (2603:10b6:a03:59d::14) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9520.11 via Frontend Transport; Sun,
 18 Jan 2026 19:26:12 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 SJ5PEPF000001F0.mail.protection.outlook.com (10.167.242.68) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9542.4 via Frontend Transport; Sun, 18 Jan 2026 19:26:09 +0000
Received: from kaveri.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Sun, 18 Jan
 2026 13:26:05 -0600
From: Shivank Garg <shivankg@amd.com>
To: Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand
	<david@kernel.org>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
CC: Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>,
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song
	<baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, <linux-mm@kvack.org>,
	<linux-kernel@vger.kernel.org>, <shivankg@amd.com>
Subject: [PATCH V3 0/5] mm/khugepaged: cleanups and scan limit fix
Date: Sun, 18 Jan 2026 19:22:51 +0000
Message-ID: <20260118192253.9263-4-shivankg@amd.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: satlexmb07.amd.com (10.181.42.216) To satlexmb07.amd.com
 (10.181.42.216)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ5PEPF000001F0:EE_|BL4PR12MB9478:EE_
X-MS-Office365-Filtering-Correlation-Id: e8de222c-090a-4edc-5774-08de56c76f65
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|7416014|376014|1800799024|82310400026|13003099007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?vcKPA4F3HbpgdV3nkDCVNVyrgipzFS4Vs7CiMGKkcTXyx4szDNS+I9x526Yp?=
 =?us-ascii?Q?ODUjk0eggNTVxNWRamRSaOr4bz97Z/o6fmgO4z9eAaCkhvifPBbDbhEGbcBx?=
 =?us-ascii?Q?WsOmkMPCJnTkfpB0LYpR5erI3ZBKi4E0qX064VXpuYa4n/AP+ImmntGrdbfs?=
 =?us-ascii?Q?7RmMScMk+nHBKNSuHDewCr2gcaRop0Gvmqi1UI7eCYdEqyAFHMPyPW/eHRva?=
 =?us-ascii?Q?g8vMxirfnDShhIxtfP2521hsSuX20tKQGgoy7vIjU5quBzAWzgv3ZiXIK9YF?=
 =?us-ascii?Q?hJvVB+bcDC780t1bTjohe9ipqpvNz4rBeKvT30JF1VnaN9e3sY671bjceKpL?=
 =?us-ascii?Q?/AIvI2rfRCcN8Usm5wrPJ40VGzieR4dxNbyAIe5duBgMUCZnYvTctwcjacUj?=
 =?us-ascii?Q?aG099L9Pn/4SH9SCYol6intqBF5q0r9YQbuS5N6YtG8+f5szUKSzcYgd7V0m?=
 =?us-ascii?Q?ynUnpJqB6/jqFTba0lphRGLnovUKsp3klBD7EJ0khHFPYzstBJHXXeycjl/W?=
 =?us-ascii?Q?OSXCNXFtV/ANVmzQmxfXWp6NgpAhmj0azlNCorPIMAcQ5iiAGfPWNYwcW2T6?=
 =?us-ascii?Q?F+EHXDdrqkCgLL2a2dWj+8sIffEqgnPkSadJaR0rH9i/LPLsjVHJgs3XW71g?=
 =?us-ascii?Q?g+Hikx1kEbsb8md14j8P4GH19NzdEqPraHq6cETGXQWMuCga1qmetll35k9W?=
 =?us-ascii?Q?Cvpv0L3n93Np3DK7FyKVgmFeRFyHj56QVTA+jtjMlp5pb7WRZvWwTvibLWDN?=
 =?us-ascii?Q?kNOVbO6/0vfGjQI78EPlCqn6NRmZb5rJXrwlTVUIPo/SwKtJg7/gu0dOMh6J?=
 =?us-ascii?Q?pNcwdpHbUwxteCt/mXRipEsM51SEZwTkvaE4DPE2+1BfN0ujkT7AVJRZqctp?=
 =?us-ascii?Q?62z+TytTAeUgRpAOoqU68Ukik2VmoNBIqe5cY3zLxBiyNrl4cFXseOkwLA3t?=
 =?us-ascii?Q?1R/JEJ17097TkBeYJU5s8LjFm9l2PUp7zOghTrpEVtCE5CdDbBq7Z8dS26+c?=
 =?us-ascii?Q?eZTVjAmQ8B+wvmyrphQjjSeN2R1D7w/djYVOd0LXex6FQG2376YhJof0QTFI?=
 =?us-ascii?Q?NiuwrINOruqF9WjTIGRInO/o+5FWtD4212KoEc8ngkkSTZ9deW4rlv5h7Ni0?=
 =?us-ascii?Q?SNzKi39oWYGmGpJOMtrKTF7cfyPCYMnVhKjT+OZSTYYuLOnyPhxaLM/mmgu0?=
 =?us-ascii?Q?CyEukEwpgkB5H6/3ihhE6cwYmuBYK48D0tQilPCBeghXOuTw23CfCrj1K71o?=
 =?us-ascii?Q?KcaVtsHTXs4Mp7mrVrAwG+nbqVqVW6Yiq4732cQCHPxBZrlebEz4p+8YQ1ka?=
 =?us-ascii?Q?P6ma+LQWcvtYZlU1PE7MpfquNm9MXEj1Ners77TvQGCT5JaIGMKrYQriyssP?=
 =?us-ascii?Q?FEI5GMbK1fRyZgouBZCgsdebHuCl+RgLN4XaFKbsSiLSSeEtlXfF9HtaRGys?=
 =?us-ascii?Q?HBVDcgZbfLF01iT88rGOZZDDf9XwK7QOV8p5CZ6s5VO9EKiAQiYIMAZo9I01?=
 =?us-ascii?Q?VGvkQgFzD5hw07AMYtwHOjO0DWhZwH3mHAMfXaYf+S9OIiPrMyKoRPG+UsTI?=
 =?us-ascii?Q?8B/9JdEVhPVDHh+9arPvQAMkT9YgTv62JH55glPphYINToOCUEXbSikYwyTb?=
 =?us-ascii?Q?oBp1309nHpshWoX/pB4vhgnrK/ECPcfBLwgIUN+X2CS8drIpioGPgAdEad9i?=
 =?us-ascii?Q?4F4bv4mBvrGmskMwenIPcxa7Cz0=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(7416014)(376014)(1800799024)(82310400026)(13003099007);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Jan 2026 19:26:09.9241
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e8de222c-090a-4edc-5774-08de56c76f65
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ5PEPF000001F0.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL4PR12MB9478
X-Rspamd-Queue-Id: D44DD20004
X-Rspamd-Server: rspam06
X-Stat-Signature: wzqp1pkqss9z3gos94n4i1mathr48mhy
X-Rspam-User: 
X-HE-Tag: 1768764376-696905
X-HE-Meta: U2FsdGVkX18BIo84crkWtP2t31kHqypl+AKGHMHtmeJfe4ytPew10Jnkj/e/vgTtYIx/JcWgqls8phV1yWUbOAA5PWTIHqJqBIq6Xz9Ci+aOx3RL5DZ+e43w7ZlNWUIWo53zcZZlxEZ0RF3t5/DZHxe2Jj9kL1YNmrFpzuuvCreZ1swX/tWRPxQpjj0vfdpBZGXMuTFQtasAUFUOFLUrF5YzOVxL/1oVGtWADlXTRIYqNdEgQ4qlGIuguOWNep7mquNL1j9fOrdjICo8zOw0t1t8lzxHASy5WWcxDlejJ32gElRroPFTC42aT579pd2BAb1eNmdEan4Oho/qHqQaedT8ycQG2AZgWADPWI5GWAJudiqJddJ/5TYs8D98qoYe0dYMdFYHNIlJZRCihgPfBPRu1SqCNhfbajINI7g07bXo3Khtx6Z5AbN76338iy5xq7BcJQW90KfhgV0Eqw9wlwpwylWzECPcg1IUjzldpNRFnG8DIvQuNN6C1AQ3E/tqc0c5dJcENmdN95spVPeSvWXS+rFKYj20BYwkJq+n/Gadv8jzYrscdGVthu7HzgHKVuQ4ACp3wMiQJlP+CMkvCbYkC55f22xFfzjWW19x19C0jotXvvRXC28A7veWh+80lqKxD8Ae6roi9Cn1G4HXV4vraFehWyh62KNMj/o3dY3aVm/NUEhdmdqUBCGnxf19lofhCDq1UOhrAmsKU6ZXESOKp4qq61wFLze+6kJFIc5m1sQv86R8uoHQfzl5FnGvPO4m4gZxd/DJ8xPGthsJ9rIlWGfex3YnYo9zs8S+3MxkiMh17j8Eup4ip1BSHNK/SVpU1CB6TlVnBF4Z9dqNYJUme6crvVSEVu6LZIJYanMvJ8qnI5eJmWhnKd3bFzV4VP1cZwSn2Ev+/YOkocRnlfKN2UkkeHLyalC2wwLtsnQSk7FRutt1khzvq5XI503fHKesMAykVW0lvPrkiiB
 unR1CdkL
 4s5wwJ7CPrGLxhiwZRuB6SMIoWEBDwjU6LM3adkJbKNAlMEQVj0yxGITRErJCxLVNHJrVA7gZ2wn4waVYQdoJtA7dlq32itNA7tRlpPkAMlIavgjgSy4lhJxVVUoCfQIn0DzLCDdxjJRnUWMz638NvXIDjxOHiFnW5LVxfulGzEAAQPEVLmksneSwodVHszMwkgKK3fj4fbRKWExcPkFduW4ED9SnAuYIHt22GRGtyC6EB6e/xo9DX268ku5wZ+GY+z1wDXoeNmBNMOLb68SCDERN8Ovc+hGXGryhwvtZKzjiR2B1SRGdEjlFbbBlTwb1bc/VEiA3n2I3sIHmL65Da8c+IRdUgDGs0LFehoXYBSfwFnHWiYegKyZMmvUpqekaQ93d5Br20PuYBllvCMTx5Y7kU5gYz5offvcYjfBjbinVHhwy2eND93Ny7TXiJOYlc1Fn3kWLjspHuGRTahW5zaXyY4PJ44/N1A7S
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This series contains several cleanups for mm/khugepaged.c to improve code
readability and type safety, and one functional fix to ensure
khugepaged_scan_mm_slot() correctly accounts for small VMAs towards
scan limit.

To apply this series on mm-new, please drop:
- 20251215084615.5283-3-shivankg@amd.com:
  [PATCH V4 0/2] mm/khugepaged: fix dirty page handling for MADV_COLLAPSE
- 20251224111351.41042-4-shivankg@amd.com:
  [PATCH V2 0/5] mm/khugepaged: cleanups and scan limit fix

- Apply https://lore.kernel.org/all/20260118190939.8986-2-shivankg@amd.com
  [PATCH V5 0/2] mm/khugepaged: fix dirty page handling for MADV_COLLAPSE

Thanks,

v3:
- Fold mm-khugepaged-count-small-vmas-towards-scan-limit-fix: add comment (Lance)
- Remove extern and use two tabs indent (David) 

v2:
- https://lore.kernel.org/all/20251224111351.41042-4-shivankg@amd.com
- Added a fix for small VMAs not being counted in the scan limit (Wei)
- Updated 'progress' to 'unsigned int' to match types
- Update return types of internal functions to use enum scan_result (Zi)
- Add void wrapper collapse_pte_mapped_thp() for external callers to avoid
  exposing internal enum (David)

v1:
https://lore.kernel.org/linux-mm/20251216111139.95438-2-shivankg@amd.com

Shivank Garg (5):
  mm/khugepaged: remove unnecessary goto 'skip' label
  mm/khugepaged: count small VMAs towards scan limit
  mm/khugepaged: change collapse_pte_mapped_thp() to return void
  mm/khugepaged: use enum scan_result for result variables and return
    types
  mm/khugepaged: make khugepaged_collapse_control static

 include/linux/khugepaged.h |   9 +--
 mm/khugepaged.c            | 149 +++++++++++++++++++------------------
 2 files changed, 79 insertions(+), 79 deletions(-)

-- 
2.43.0


