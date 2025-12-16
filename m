Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 99031D5E131
	for <linux-mm@archiver.kernel.org>; Tue, 16 Dec 2025 11:12:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0F3736B0005; Tue, 16 Dec 2025 06:12:52 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0CAE26B0089; Tue, 16 Dec 2025 06:12:52 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F0B916B008A; Tue, 16 Dec 2025 06:12:51 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id DFC6B6B0005
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 06:12:51 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 85B81BA305
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 11:12:51 +0000 (UTC)
X-FDA: 84225071742.29.5127222
Received: from DM5PR21CU001.outbound.protection.outlook.com (mail-centralusazon11011051.outbound.protection.outlook.com [52.101.62.51])
	by imf24.hostedemail.com (Postfix) with ESMTP id 999F1180016
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 11:12:48 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=i1n7TCTO;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf24.hostedemail.com: domain of shivankg@amd.com designates 52.101.62.51 as permitted sender) smtp.mailfrom=shivankg@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765883568;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qt0tXILyXXWvsj+ZJ/t382VC8zZKLoHMNpaTxzpoQ1E=;
	b=2HyINW/AZdNaIoDYY79QKuSmSSA6KE0UIjx0Yw7HJ0BTEWz9pWbCwPWn1V7h+3Bq8k0q6z
	Fo9NJLk+hyFcfuP+dVbj1SQfeHE5AnLTbfCz68Qu1QojVZkqAh+ioEfD7IOOwBte7TFILx
	pkm+BjWDww9Z6ZFDZNorEQdHLHgdkPM=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1765883568; a=rsa-sha256;
	cv=pass;
	b=6uHU5yUmALOMRvyHPFntpTiMcrxglwOoYSKk8c1ygkazNojXvSqoCQuQxei6AYUS1GcMx+
	vnxj8uDHZwUWhGnXOIuoCdnPjk/WmLP4GC6DWSi033DhPnxHge/yHB0QurKmqbobO/NKyZ
	KfDnL2b6GIR6RFrKvhYKW78NouYlneg=
ARC-Authentication-Results: i=2;
	imf24.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=i1n7TCTO;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf24.hostedemail.com: domain of shivankg@amd.com designates 52.101.62.51 as permitted sender) smtp.mailfrom=shivankg@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=d6a0pIP8/p89hBsockzXRO0g6/fBBCU3G1FS0axPJ8eqw8ZA74o1OP/6BB1OTQFCBpWIfCPy1vt8/s0Cn0/XPfnyMGEXyeDbkfRum2+12A5N72uUufyVmL/jsppJqP+ISI1uuGJDwiTeVFmZAwSw9BHGdPzOa+I8LvpiBLfEYw06nopOgH+Vlp+JSTdEDCFdx+UmcJ2jTmxu8CmK4L+wXK9RSB2CWZTEGb3ngYvNxoRJqWV44P4FMOMGIj2fhZsniER1LiFM4D2Xk57/T1KaNDb7t4mcP0GOymUF5xZtRK8aNmrhvAQFounC3y3GDYgMAgkeDlA7qZDQQDFLwmp1jA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qt0tXILyXXWvsj+ZJ/t382VC8zZKLoHMNpaTxzpoQ1E=;
 b=oybCVS6emvjkl6mtN4wSMStZAVHyZBGVvSUOpqYIZd4WO8r175Hq/6k/AyOrpDidtKqbM5gmkmbbR6eD/x/kYnlofkHQrs6knAalhHgLx2aEJgnGbOOoihYVuKiBtdPDH1M7T9+WabJ8SAKuG/CLWpSK/6QvwoBfBd+wSKdlz81Wbe8FxuGNd+sq1ZjkJQSHGdUeICHfnMn/x9TvsoRKcD8fT2tx5BQ29lMB8bHkXnGhhvRMcZQPoN0ib/Ta5Ie3EiM2nBnDdM2qBzal7h+1dZZrTdNmLTL3KirSQetefJFzu3G3n0F/KBggfJKJRqDkSYOXSNXnqD3dWirb/rlk8w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=linux-foundation.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qt0tXILyXXWvsj+ZJ/t382VC8zZKLoHMNpaTxzpoQ1E=;
 b=i1n7TCTOwE2UkmlzP+jIFrnA5irG4AMyUar1FOGgggr4bfgOkMYBK2+lmifr+Tn6O2waAy6dZoQndq/BRP5i8vo9DDhEOcFanzjJQkI6x1hsvfk3xgUYU+BkelY55sipXzPZCDn3Ro6zx3CnkCq9owmCYiZdqppelY3ZiGoNcZQ=
Received: from BYAPR06CA0015.namprd06.prod.outlook.com (2603:10b6:a03:d4::28)
 by MN0PR12MB6368.namprd12.prod.outlook.com (2603:10b6:208:3d2::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9412.13; Tue, 16 Dec
 2025 11:12:44 +0000
Received: from SJ1PEPF00002314.namprd03.prod.outlook.com
 (2603:10b6:a03:d4:cafe::87) by BYAPR06CA0015.outlook.office365.com
 (2603:10b6:a03:d4::28) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9412.13 via Frontend Transport; Tue,
 16 Dec 2025 11:12:38 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 SJ1PEPF00002314.mail.protection.outlook.com (10.167.242.168) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9434.6 via Frontend Transport; Tue, 16 Dec 2025 11:12:42 +0000
Received: from kaveri.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Tue, 16 Dec
 2025 05:12:38 -0600
From: Shivank Garg <shivankg@amd.com>
To: Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand
	<david@kernel.org>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
CC: Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>,
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song
	<baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, <linux-mm@kvack.org>,
	<linux-kernel@vger.kernel.org>, <linux-trace-kernel@vger.kernel.org>,
	<shivankg@amd.com>
Subject: [PATCH 1/3] mm/khugepaged: remove unnecessary goto 'skip' label
Date: Tue, 16 Dec 2025 11:11:38 +0000
Message-ID: <20251216111139.95438-4-shivankg@amd.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20251216111139.95438-2-shivankg@amd.com>
References: <20251216111139.95438-2-shivankg@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: satlexmb07.amd.com (10.181.42.216) To satlexmb07.amd.com
 (10.181.42.216)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PEPF00002314:EE_|MN0PR12MB6368:EE_
X-MS-Office365-Filtering-Correlation-Id: 1712dc7c-dcda-4e06-740c-08de3c9408a6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|36860700013|376014|7416014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?YEl/YtVO1BdM8tWiQ22eNaZ0QBMvuzIsHy5pswueX3qubmZy93AolnVFIzP4?=
 =?us-ascii?Q?FR6FOBEMmzF3xP1rZs4gkQ1X8OgdsZ/euy6jL0gJnj+ZXrCcsuJu4njjnCqi?=
 =?us-ascii?Q?cRE0L1hArMfF+iSgGWaV2Av1U12dIb8/BdNZWCW4nMqq6GIKNhKP8rQ5ArzC?=
 =?us-ascii?Q?Uwnb4bTd3bLByZnr2T0sG+BnYs60HJhLWOKmxPurhSJ0d+tnSw7L5+i5FBt4?=
 =?us-ascii?Q?7sSrPr/m7x3yC9qJe3CpVpqbaVopC/QKS6Hj6dZsXcAFUerTFEIxz0EWJONo?=
 =?us-ascii?Q?WWFRKbVCmsxHUWHzglrYm+s6nUdx1XIm2VeO2d/xETSDVRbwFB6qRs3vgW3P?=
 =?us-ascii?Q?/kr0h8RE2FDLWH3MmrtSH/D8eAEDPlXiK4svrYoZ5Ld3bT2BXg939HmwvDse?=
 =?us-ascii?Q?B0hjSDbwWbMYU/dtzYmhBxSDEFqe/Z4Qdpn90pAQJtum7jSkZZBOWfgZ7UkK?=
 =?us-ascii?Q?WNvyCXMKTmixNqQnpkhcy1XudAC3K2DL91r5PcFvE2BMY7TptdC+vbuTENZc?=
 =?us-ascii?Q?GTi42vaUlPjT3PQTOxqCBN56dhNiqqchq/w8fztVdT7gt6pRMdI8R7WLCKvJ?=
 =?us-ascii?Q?7OTW91BHw6r+P9wmaf7agbqcFqIsrnur6Yu38g8e+BqiXO5SkvZl/Rtp5pUE?=
 =?us-ascii?Q?X1RfmziQOm0kvEKK6vI8QtnKvN+gbLqOF4lEkxHcfjydKoX/M0Xkt780uWLC?=
 =?us-ascii?Q?AmoBZujD+Jaxcjsy6TP3SBGZRHft0XQI8++arIk6+xkRWfGFuGQ53czHHMGx?=
 =?us-ascii?Q?1uvGGvTpRYtn3Dng2+6gwySNdIgdw/Bl+yBRoZddyN8x1g3kHRQ0icnYx61+?=
 =?us-ascii?Q?ng44GvJ7RV49Jxz9mrik7HyQzkyNcYRcQyzTZqoo/7kZwnON3PApA/DPF6KX?=
 =?us-ascii?Q?uEtDeYl5f1Yi6tQIONpQ9ZpkCUvZfSX8FOHyp7ZNHAEHsrqd9YRWK5dPLHYO?=
 =?us-ascii?Q?/tpTBQBXaANn/4Y7AERQqqdMHjijhjFGDLU5rZ4Zg1xox9GTLXaUGRWsil8p?=
 =?us-ascii?Q?d6hisdfVnqkPKMk6FhGY5qyB6C6qVNxPHA1zbrx5ftJCFWddCxFj1JvX8c7U?=
 =?us-ascii?Q?XIdO/ZT3YIlqh/Fuc7+KntRGDTdqNX1C4WIGlscZBTjz9zJ8qsBlq8qeRqUe?=
 =?us-ascii?Q?i2OGwZ2n7sgXnmrly8dThnGpQpok+HLsca57T4Fdt6BcBDRTNLIUtyS94oWS?=
 =?us-ascii?Q?foQLPifqHsI2rD3fdI816EMcRtDV04KbXVCK7viYDR7xQxeRCJY3m5TyEwpq?=
 =?us-ascii?Q?yBKGnMgjgQ/T2zk6Qn62uY7Gkea4xnu45+4I/EL6Mmgg3xNZSkJPLWteU8/c?=
 =?us-ascii?Q?XcLwQOHNdnGtp69Lc3JzFd4f1AYHfJudSmGFYN1ZzR8iuO9/dVTV2vkNbn5O?=
 =?us-ascii?Q?Or9CkUdmtnwh8EYzFHBLdZpY4KdowisHdvPTEAOVOgNMgHEfh6as4/Z345jr?=
 =?us-ascii?Q?BwvDrXihFBxQg9kwez90IC9VO6Ikufh8nVXtS8mj1A5YYu7khnFxXtmtmpav?=
 =?us-ascii?Q?7xC7wFPnLuWwke9bEKJbBAPgqbsO69+Hpw1baixv2MaAjYazeLR5m1J35dQ4?=
 =?us-ascii?Q?dQH/hDAtqrR05N+Wjow=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(36860700013)(376014)(7416014)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Dec 2025 11:12:42.9810
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 1712dc7c-dcda-4e06-740c-08de3c9408a6
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF00002314.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB6368
X-Stat-Signature: kxhgj5oxkh1rf7ic3wfrf3i86jjg3fcg
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 999F1180016
X-Rspam-User: 
X-HE-Tag: 1765883568-895370
X-HE-Meta: U2FsdGVkX18AaxTMS+DWrxahmCNXWCc5Vfuo8yA6/KcMrMkgYKe6TpI3ly7sY+t7ONErEM80sHcCht59ZLb6mem7xjEO2IhoUn9FFXU7Pd5jUk3/W1bXerCtRBjE7cXWbet3WPkIRQdeY9b0irXjI209IIkF5ciyxBILEpslJeqfQJxZEHJypAXVaXd1TfvSGqouaonT0bt2P5l5xCTVbZ1g1tCy/1wQsULibgSt32PDrkzMadSLMGnyZE1Wi00zhSX8rLay8DAIjvyW1DjbL6TySauwaIJwxYJ7syIRN+1uOPX1HaiQ5UdHj1eJVPNuP6DQpW7nmjRLucUbd8LENg6aNnV0lqMc2kS/S3uuUp546bw+GkjMdh2TO8yhW5Xw2V0y+i5owBcjU56hCKqJnvzzKvJj8bnOkgUjHQ0ei3hSKl+R9E9IjqhnRpyVfRc1XrCSRehdWZ++ru1Q95nlgh1iHGxKmFXTG8rtkCCsl1esT9N/8nGNW5Ge6w7YpNXUZ6HyN6gu81DRYW0DPTyrmJjnUy7tze4snpKiHwJNXoZ8bRAEGqRJON05+EwDp/MRFmw2xZ9mfO2JfMZ6OwzyMN6WG/rmW8S06I2Y20ApwDE7kdGnK0sPKXpfxSgXdMaeI551w42K537ySX08+hoN+R19fRAVqBeTYYEoLCafM1Q2ecPgiXxxsXbQro+7OWAhvo7vc6Cn4Dsxu0FQpOLpWiq5lQDtG9mXkpHXKH/3TYdLcHFirjlpjrjSDKMJuM32lc+qxJja39pGUZwlq7lclTyzaTVJGhQX5Vz45SF9m1Zb1wUKbfei59A9Kq9EMFSTGyS3dbgrazrOiH1cNcwn55WfSw1isVl7PtxvFCD5DpXcdwq0CG6/friKJkk7LDIvSzTmIha8wgIa1FoEGlpJo719L6+CD50zhtHxZIC7zsWxiaITH86oSsMrQ0kYXTRXH3SnB3Z5EpehP2SGSum
 XSdZcYHA
 vfgGbO8qugT+uwnIH6r9fZYFkfadxFSrZT1SIQMHTLqUaEVSa2K9xzrkmMkzuqU5HMKd1ynnGa/cmy3O6XRHwgU7L/ANqqQdCEx1B0OEb7lxqpxNlWI1jhmIiap5eC56nbrtFiMxLwdSiPizgxFqebjrYYNCkJuQdJ0liLy0uYlj3Blx2UGI3zsDGlgYxuKJRAWdExfsL4TimmX0j4RwvjtPjR2ShQtYcUTvaw9dX/XqcvHOgEi/h+Dk0oU3jTXV8I+Xc1A6llih/oGLQOz1W72W1sSgGPsji9OgOFmyFe+zFcaYUqWYgaRF4HJyItQiHsJCWq56j8eMUtNF9Q1xy/iNj6CI80g1xsF9MbiO1n0b9t2p7MQxNXXdHm/bjRvqDcOClRwleJVSdpvd3YWgaeA4qM6UAWzaJzzg9i+mbwk6hp2ux+pJQGecMdB6rLD9jQ5C8PBmgQMi1rfE=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Replace 'goto skip' with actual logic for better code readability.

No functional change.

Signed-off-by: Shivank Garg <shivankg@amd.com>
---
 mm/khugepaged.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index 6c8c35d3e0c9..107146f012b1 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -2442,14 +2442,15 @@ static unsigned int khugepaged_scan_mm_slot(unsigned int pages, int *result,
 			break;
 		}
 		if (!thp_vma_allowable_order(vma, vma->vm_flags, TVA_KHUGEPAGED, PMD_ORDER)) {
-skip:
 			progress++;
 			continue;
 		}
 		hstart = round_up(vma->vm_start, HPAGE_PMD_SIZE);
 		hend = round_down(vma->vm_end, HPAGE_PMD_SIZE);
-		if (khugepaged_scan.address > hend)
-			goto skip;
+		if (khugepaged_scan.address > hend) {
+			progress++;
+			continue;
+		}
 		if (khugepaged_scan.address < hstart)
 			khugepaged_scan.address = hstart;
 		VM_BUG_ON(khugepaged_scan.address & ~HPAGE_PMD_MASK);
-- 
2.43.0


