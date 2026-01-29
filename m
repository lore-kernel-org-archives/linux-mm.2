Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 89785D61020
	for <linux-mm@archiver.kernel.org>; Thu, 29 Jan 2026 14:46:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F23486B009D; Thu, 29 Jan 2026 09:46:06 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ED7466B009E; Thu, 29 Jan 2026 09:46:06 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DC6606B009F; Thu, 29 Jan 2026 09:46:06 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id CB2F06B009D
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 09:46:06 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 9B79CD3035
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 14:46:06 +0000 (UTC)
X-FDA: 84385276332.15.159588A
Received: from SN4PR0501CU005.outbound.protection.outlook.com (mail-southcentralusazon11011020.outbound.protection.outlook.com [40.93.194.20])
	by imf26.hostedemail.com (Postfix) with ESMTP id 8E0AB140003
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 14:46:03 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=IRkbbFDC;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf26.hostedemail.com: domain of bharata@amd.com designates 40.93.194.20 as permitted sender) smtp.mailfrom=bharata@amd.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1769697963; a=rsa-sha256;
	cv=pass;
	b=Gwh4Ep2Nfao0yD9uIBEfXq8UdttmhnKx/PU3ZnwY95zQMiLZFBLoEbXJxcBHZM1M6ujlZH
	FtAO3FC8Od6/5oqHW6ibsFbUSnFdNszmN9N0aQNb9QE1rRySlRdwAIgBUWQ9cRKB19dCmT
	MxfLJM0DKh/bohKMa4tDXByRf2Km/ek=
ARC-Authentication-Results: i=2;
	imf26.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=IRkbbFDC;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf26.hostedemail.com: domain of bharata@amd.com designates 40.93.194.20 as permitted sender) smtp.mailfrom=bharata@amd.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769697963;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rUzm6Hs5+cDmiHjR7KYrOgazFoFm5vKrZX+/+4jyRck=;
	b=4A5ADbNKHstlIJuxBJUErCzO2FJLStV2FDEm5X4whKB400eC9U/RL3hLaD73e434oRQ+QR
	vXsETvKqMh86gA9HW1sFQQrN8XfQoPX1/aSCSkiSoFZVH3Di1vdCy8XF3XbsNUyFxrjv31
	eDebomdaYSnmx9uugPIBvgr1+uG/Yfk=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=er++v9Evjxy3uB05dS1RlRa4mVBkc3dsS7gS6uLshufmPrrCN+xuQ3Tzfg6CZWzrmtL+UV6dtoEzBVGVDI0KMIweIvvbcs+ft66pkkUwTd9txKKwOotnw2UPoIKTdVyxQPyE0ymwii91+AnB0HOj9CEV4K6HtaIWnSNk0OR+MWMK2msZ4YxbH0hts3rdaCjn0yqxPVu9cJOibjfEJtbF0GitsBzDbFgrBSgS64bwLpS+LEK7b/665czoqgpu7paEU8/X9Z7ADhTGT2N6gZLXQ2DUGVk8fDeT9Iebf5M95s4dDWxiwmauCYzXG47dT1hW+614F77yA0a/SBUuQLFI2g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rUzm6Hs5+cDmiHjR7KYrOgazFoFm5vKrZX+/+4jyRck=;
 b=f3d27apH01IuJQMtWcuCGYTY2TnOjoKbQKWPjTDJ8hkmZ+W8uyCMYbMOT+2PksUwK3Y38kPyGs1rY/ST9szXY3zBA3QUh2z/HttCiRRK3G8ilRTN4pASVe2JtFh2o//C7cc5vSEwoos7k9Z3yTtVfFc55BRnDUrbzCb9OA+p+wgRubwlezO9KmygLecWOS4Tcpr/rlOmecsnmZP5+oKQnpE/Ytg1Kj9caACUCbprhTxvqZf/v7aFSzoSibPIwvkC6Y+GKaX71Nqbfv2AGxPNK0Dpx/ot2d//h1Y9sJfpkvlhnv711xsv0jCjTygPh3pgNAeQoC/VFxUKt9Dul2kyIw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rUzm6Hs5+cDmiHjR7KYrOgazFoFm5vKrZX+/+4jyRck=;
 b=IRkbbFDCn4MOizfQitHnOvhpB5ws6/9wRbNeClJaPcYQgBik9+WlyLHdTwsm60935sxzb7N7o763Doh2MOuNwljxGd8VX7n0/lZxXLw6QZU1cdbQtiRZ16FnBMMOpF1fkBxOVeCKKxnbRsl+j4E4AMgjWV1GPmnXuHwhEJrjYC0=
Received: from BN0PR04CA0106.namprd04.prod.outlook.com (2603:10b6:408:ec::21)
 by SA3PR12MB9198.namprd12.prod.outlook.com (2603:10b6:806:39f::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9542.14; Thu, 29 Jan
 2026 14:45:57 +0000
Received: from BN2PEPF000055E0.namprd21.prod.outlook.com
 (2603:10b6:408:ec:cafe::af) by BN0PR04CA0106.outlook.office365.com
 (2603:10b6:408:ec::21) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9542.16 via Frontend Transport; Thu,
 29 Jan 2026 14:45:28 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 BN2PEPF000055E0.mail.protection.outlook.com (10.167.245.10) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9587.0 via Frontend Transport; Thu, 29 Jan 2026 14:45:54 +0000
Received: from BLR-L-BHARARAO.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Thu, 29 Jan
 2026 08:45:47 -0600
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
	<shivankg@amd.com>, Bharata B Rao <bharata@amd.com>
Subject: [RFC PATCH v5 10/10] mm: pghot: Add folio_mark_accessed() as hotness source
Date: Thu, 29 Jan 2026 20:10:43 +0530
Message-ID: <20260129144043.231636-11-bharata@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260129144043.231636-1-bharata@amd.com>
References: <20260129144043.231636-1-bharata@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: satlexmb08.amd.com (10.181.42.217) To satlexmb07.amd.com
 (10.181.42.216)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN2PEPF000055E0:EE_|SA3PR12MB9198:EE_
X-MS-Office365-Filtering-Correlation-Id: 5028aa15-3d37-4d69-e51e-08de5f451b61
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|1800799024|36860700013|82310400026|13003099007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?qFce0gvOTFTkT7ztL/buvPlWPFEQyLGlkKKSoo/6bRV4aLlyURb3ZuMSc5RN?=
 =?us-ascii?Q?L7H64cyxi9b7lxT9C1uSa9bKRN0GSdstTOUX1L3Nfgcdwu2Bf4Opv6rurMu7?=
 =?us-ascii?Q?uT9JQBArjIgWeUlGqbQuGConerHo32j9hTgxOGe2Vo4XK+fKo8rzyfIfL+JY?=
 =?us-ascii?Q?KIzvIUIRvYKwKDMRSZXI9ZDoKpKf+yAnCSx209yyaWqkUrUmJypcXYXTqy3Y?=
 =?us-ascii?Q?mwcM8ZNmFk8l+Yus4klt9jwyk3T6geoJ8z4ZQbGjMy9Eq5UKGIyCnaPenCP2?=
 =?us-ascii?Q?j9Y8Sq4wutFNvt0JWux5D1nBb6nvzPGzCkZou7p8fqOUbSobHBoyZ2iHB6bf?=
 =?us-ascii?Q?V//ZRnmH6WLJcV2vO/1ULwAZnowIWFOTX8a+G8+7BUcFGqOo7Awp0+eMzlaD?=
 =?us-ascii?Q?HRcCeQttDlvXWB1wnOWXO6LCIpJ4uzi0UTdwWyiZXWfWaStoFhuw9+5mfNhj?=
 =?us-ascii?Q?b50dB5Tc8loNhTm+7AkYS0NyYVQAd/KLaHCtCqaVEtdyG15uUPOwbwByn1eP?=
 =?us-ascii?Q?MIQf+U/Sh389KI5HZOM/QtEqxFFQeRF9Bm/CQDAiL6eVVasjk6sn9/tIzg5O?=
 =?us-ascii?Q?pEN2eMWgVa8IDwCpSNuNPRypAGvq1sv+2jqLXEipCH2he4vcwttsKo1UuW1B?=
 =?us-ascii?Q?leimTXYvKIr16fA1jq8L002ZCO/LjPl+cuhBtidmscdtIXj5uDt1v5ajUgh8?=
 =?us-ascii?Q?HWHl1XmXMltNuWRDlY7e0STXFxg+gXUANqXjDs/pH5dEW42Hb40HCEBoLHqL?=
 =?us-ascii?Q?VgBf1VNPpsOq0Oeax2aikWrGh4wIJIbO6nbXV9PhUQ84O6AgI1qK+HW2+bnF?=
 =?us-ascii?Q?py7skb0wxskT06gS54uVYVR3KzN7a3HDwvZ4iSFeYvlrb6LzDv3A3PXMgsOC?=
 =?us-ascii?Q?NTiiBs5LKqiEMyNv8JpR2gUseMhiLF4BOBUg5bzeh0aogx04QJCF8sQTrASZ?=
 =?us-ascii?Q?IYa0lLkG+bDLXcVBhvLuJbyMz+TNPvgXjk31pZRLvk5RumKBho0Hf5F24SK+?=
 =?us-ascii?Q?RovGHn7Uk9CYX77PqdFrUxCqUXZOcgzxLYVsXsVBlmgwPDX0xyYn3M/gnfXp?=
 =?us-ascii?Q?sAhe23bS8Y6ML0b32jWHpeytv1fyc9tRvJH6ljhTW67/Gn+oPLeereLmz4J/?=
 =?us-ascii?Q?9vdpWXWEREdWcIQ3JYI+VyO/aZ0BE4Isr3JDr3oAzMmdHZVl2/RFUIc6UY8L?=
 =?us-ascii?Q?MK8pJvY6Ol/dGYEAR4xvlUq+EaVT6MVsBt6q5yUaFmrpOfpxEqGG7p2J5gBC?=
 =?us-ascii?Q?8Jp+5jCbrodYaNbeWlhLZLSTMc9VXxQEh+RhdIpbxPwFMvOb47SXlU1JTc45?=
 =?us-ascii?Q?GY9eUB533Su6EHsHIVM25XuKmSjx90mj0m7fQUdlCTFhtmq6Itby6tyxzom+?=
 =?us-ascii?Q?Kz2ugVpBiKL0ykwtQxEggzcziN1qhRPmYYMrcwFlnO7CnUQwZrHcewH3Z+LM?=
 =?us-ascii?Q?ymWr6xfRSYebWKTHVXJ3P75Z/G4qtNe2hgmoYD8ny1EKgDpedS8MRXE9sE8Y?=
 =?us-ascii?Q?j9arJ2+7/SsuEa34mAUwrsFAZ0d8YI5mNUZrb3FaNkc7MhG7rkCvi7JHaYD4?=
 =?us-ascii?Q?0G2WUmXY15OJd/nti6M9N3bSrS2Vy6wBsmbQHj2Y1u7EVn38B9cxIF0MbGjt?=
 =?us-ascii?Q?mD4xygcczW/wSw4RZZpfueYP631EpBq0a8jw7LxgLozH3y6dOeqDQiLHxAC6?=
 =?us-ascii?Q?uswEtw=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(36860700013)(82310400026)(13003099007);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jan 2026 14:45:54.9547
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 5028aa15-3d37-4d69-e51e-08de5f451b61
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN2PEPF000055E0.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR12MB9198
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 8E0AB140003
X-Stat-Signature: e9uo5suxe67mn5cr5yfmi4qocaxfkhty
X-HE-Tag: 1769697963-804350
X-HE-Meta: U2FsdGVkX18ffn426fDRZM0Fx44WumNmPKjvw1Udd7jDVMgNQXAAysHBRcZjtV9+Qd8kc39ZIa01KoTMwnCrLvgqPM+Jco5IbyzOY6NJEx9ABjmYigobqQM3avegE4T5VtqKdBiU0T6Md3Ibwkyl9pg2QRLnVcd71FZUN5F402t+F1dn9lZd73jmTKcZesUrZTldzyhAzIkvUlJ0eERDu24KwYGULAtNtesvvybWFCbZ1a1zLiZg3+B7ZgzVkrkXADGtYDYw1u86aQED+bVxat2IwU1dmWWSJmavNFKshn2Lhmu4bipojVHOQXsxEd49jvgRtChHCW0E0bmEbchJ0TxuTaH6o02OJnZwyMtGexUirD6aKIkZ80EVuDgPdhpQ4WmxSutIGvYrcYYVcImLSlmbTRKAhr3K6dBUbbZKknu+pE/2uR4hhCcSZEHnlC/uJznQbmaso+ttGNUwJqkgxojceR2nHQ1cX7uGjhHgZzqsLnF7yBlwS77h4aMFg+0XxdfiROrmv2S/tjZOvAeNMDOz0FneZ+fgEAOGZwilp0htH09RJeBGCx8KS3SBYJukO/EXt9+ZhSAul1vXeT9iB82hDTbTZg93U4ZZxREga39LtEM+uBZLpo7r+f2I/8llBbbmo1ThbNEmRgWHBLdZ1pFbBE+18Q/gIV/zalawXY03+AQN/ccdgBqfLaStfTMhNIiiNeM9YmxHjs1FgNhD4Cu4oAYIYiL+lUerxguK/aontXUdaSQ+mscmUS5CBjGA82A0b6ea/oRuBwpR8wWwhVTzHlamY7al3/dFl7C5ldmDSVA/u64A02hKAKssiHXMLEtZ5IAOIV7ti7jthO4poF+sv0aYnZ4UcR5cgmjtxF4/xINN5JxdhY9vGSXc2+lwf8iAopWFcn2CwTRTIpGJVEHaDSEtF0S1UekLihrCcrhjJVGyzaU1cZxQm4OiSiRLDwU8idM+moelMbO5MnV
 UxzCb2ck
 jKErMfPmoJxMoNZYsEQavpajRTcWc5NwiNotUValm8oMtfiCLDXuFK7/lel/XjSby/cUJJNJH9t+hqObRp7KL445F+UfOZtEca1nxDCFYboSxWIQkRXhwsMSEClBmin7rymeU1lL9w5M9X0ozK0mYduQWc3Aot9YMw92LWVYfWVnDsQaDZpwIDi4LQOMRzGB1/IQabqABntbRckljuaCp+ZZX+vP5NLWveAYH3Ozlv9BNNMo5Ijm7ZY6ogPIN02D6dQUCjp9qnJtck4cryy2XuxV1/oijWycbw5eMHuMPpsVZvEppkWmaXzeLxwRX0uWwFxQhptfdsIJeT9/heBrJnktYyiFYd03/F2OArT4LCn53loI+QBPpWncWuK1JDYfaiFFdLfNepltrUhz/6ce+zjQoewMBE6fxaAKyii95U/YdgsVZifP/5KDO5cFhV2q2YsuZDuyiFCclPEbQYxxxZFuFxJIeKguiOmmvZJmY4NdqQxfQ/Kp0HIrNlcetRGc9YWCKo+dvvwh3S1FNzCwRApxmIRh5PP4eMnrsMEX1Z8MRmQLVwwjUGVJeHX/aTSE4K4dhaOhuiSPpr0xmmh17w+JXu76/DDT5QFVXKAc2nJ34IjcZC7bgEJd9pw0yxeyBhT3bf1mrYOj2/1IL2mAwLoigWPhtBerZd0CXL9BoR71nOu4OX0hILxi+0A==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Unmapped page cache pages that end up in lower tiers don't get
promoted easily. There were attempts to identify such pages and
get them promoted as part of NUMA Balancing earlier [1]. The
same idea is taken forward here by using folio_mark_accessed()
as a source of hotness.

Lower tier accesses from folio_mark_accessed() are reported to
pghot sub-system for hotness tracking and subsequent promotion.

TODO: Need a better naming for this hotness source. Need to
better understand/evaluate the overhead of hotness info
collection from this path.

[1] https://lore.kernel.org/linux-mm/20250411221111.493193-1-gourry@gourry.net/

Signed-off-by: Bharata B Rao <bharata@amd.com>
---
 Documentation/admin-guide/mm/pghot.txt | 7 ++++++-
 include/linux/pghot.h                  | 5 +++++
 include/linux/vm_event_item.h          | 1 +
 mm/pghot-tunables.c                    | 7 +++++++
 mm/pghot.c                             | 6 ++++++
 mm/swap.c                              | 8 ++++++++
 mm/vmstat.c                            | 1 +
 7 files changed, 34 insertions(+), 1 deletion(-)

diff --git a/Documentation/admin-guide/mm/pghot.txt b/Documentation/admin-guide/mm/pghot.txt
index b329e692ef89..c8eb61064247 100644
--- a/Documentation/admin-guide/mm/pghot.txt
+++ b/Documentation/admin-guide/mm/pghot.txt
@@ -23,9 +23,10 @@ Path: /sys/kernel/debug/pghot/
      - 0: Hardware hints (value 0x1)
      - 1: Page table scan (value 0x2)
      - 2: Hint faults (value 0x4)
+     - 3: folio_mark_accessed (value 0x8)
    - Default: 0 (disabled)
    - Example:
-     # echo 0x7 > /sys/kernel/debug/pghot/enabled_sources
+     # echo 0xf > /sys/kernel/debug/pghot/enabled_sources
      Enables all sources.
 
 2. **target_nid**
@@ -82,3 +83,7 @@ Path: /proc/vmstat
 4. **pghot_recorded_hintfaults**
    - Number of recorded accesses reported by NUMA Balancing based
      hotness source.
+
+5. **pghot_recorded_fma**
+   - Number of recorded accesses reported by folio_mark_accessed()
+     hotness source.
diff --git a/include/linux/pghot.h b/include/linux/pghot.h
index 603791183102..8cf9dfb5365a 100644
--- a/include/linux/pghot.h
+++ b/include/linux/pghot.h
@@ -19,6 +19,7 @@ enum pghot_src {
 	PGHOT_HW_HINTS,
 	PGHOT_PGTABLE_SCAN,
 	PGHOT_HINT_FAULT,
+	PGHOT_FMA,
 };
 
 #ifdef CONFIG_PGHOT
@@ -36,6 +37,7 @@ void pghot_debug_init(void);
 DECLARE_STATIC_KEY_FALSE(pghot_src_hwhints);
 DECLARE_STATIC_KEY_FALSE(pghot_src_pgtscans);
 DECLARE_STATIC_KEY_FALSE(pghot_src_hintfaults);
+DECLARE_STATIC_KEY_FALSE(pghot_src_fma);
 
 /*
  * Bit positions to enable individual sources in pghot/records_enabled
@@ -45,6 +47,7 @@ enum pghot_src_enabled {
 	PGHOT_HWHINTS_BIT = 0,
 	PGHOT_PGTSCAN_BIT,
 	PGHOT_HINTFAULT_BIT,
+	PGHOT_FMA_BIT,
 	PGHOT_MAX_BIT
 };
 
@@ -52,6 +55,8 @@ enum pghot_src_enabled {
 #define PGHOT_PGTSCAN_ENABLED		BIT(PGHOT_PGTSCAN_BIT)
 #define PGHOT_HINTFAULT_ENABLED		BIT(PGHOT_HINTFAULT_BIT)
 #define PGHOT_SRC_ENABLED_MASK		GENMASK(PGHOT_MAX_BIT - 1, 0)
+#define PGHOT_FMA_ENABLED		BIT(PGHOT_FMA_BIT)
+#define PGHOT_SRC_ENABLED_MASK		GENMASK(PGHOT_MAX_BIT - 1, 0)
 
 #define PGHOT_DEFAULT_FREQ_THRESHOLD	2
 
diff --git a/include/linux/vm_event_item.h b/include/linux/vm_event_item.h
index 67efbca9051c..ac1f28646b9c 100644
--- a/include/linux/vm_event_item.h
+++ b/include/linux/vm_event_item.h
@@ -193,6 +193,7 @@ enum vm_event_item { PGPGIN, PGPGOUT, PSWPIN, PSWPOUT,
 		PGHOT_RECORD_HWHINTS,
 		PGHOT_RECORD_PGTSCANS,
 		PGHOT_RECORD_HINTFAULTS,
+		PGHOT_RECORD_FMA,
 #ifdef CONFIG_HWMEM_PROFILER
 		HWHINT_NR_EVENTS,
 		HWHINT_KERNEL,
diff --git a/mm/pghot-tunables.c b/mm/pghot-tunables.c
index 79afbcb1e4f0..11c7f742a1be 100644
--- a/mm/pghot-tunables.c
+++ b/mm/pghot-tunables.c
@@ -124,6 +124,13 @@ static void pghot_src_enabled_update(unsigned int enabled)
 		else
 			static_branch_disable(&pghot_src_hintfaults);
 	}
+
+	if (changed & PGHOT_FMA_ENABLED) {
+		if (enabled & PGHOT_FMA_ENABLED)
+			static_branch_enable(&pghot_src_fma);
+		else
+			static_branch_disable(&pghot_src_fma);
+	}
 }
 
 static ssize_t pghot_src_enabled_write(struct file *filp, const char __user *ubuf,
diff --git a/mm/pghot.c b/mm/pghot.c
index 6fc76c1eaff8..537f4af816ff 100644
--- a/mm/pghot.c
+++ b/mm/pghot.c
@@ -43,6 +43,7 @@ static unsigned int sysctl_pghot_promote_rate_limit = 65536;
 DEFINE_STATIC_KEY_FALSE(pghot_src_hwhints);
 DEFINE_STATIC_KEY_FALSE(pghot_src_pgtscans);
 DEFINE_STATIC_KEY_FALSE(pghot_src_hintfaults);
+DEFINE_STATIC_KEY_FALSE(pghot_src_fma);
 
 #ifdef CONFIG_SYSCTL
 static const struct ctl_table pghot_sysctls[] = {
@@ -113,6 +114,11 @@ int pghot_record_access(unsigned long pfn, int nid, int src, unsigned long now)
 			return -EINVAL;
 		count_vm_event(PGHOT_RECORD_HINTFAULTS);
 		break;
+	case PGHOT_FMA:
+		if (!static_branch_likely(&pghot_src_fma))
+			return -EINVAL;
+		count_vm_event(PGHOT_RECORD_FMA);
+		break;
 	default:
 		return -EINVAL;
 	}
diff --git a/mm/swap.c b/mm/swap.c
index 2260dcd2775e..31a654b19844 100644
--- a/mm/swap.c
+++ b/mm/swap.c
@@ -37,6 +37,8 @@
 #include <linux/page_idle.h>
 #include <linux/local_lock.h>
 #include <linux/buffer_head.h>
+#include <linux/pghot.h>
+#include <linux/memory-tiers.h>
 
 #include "internal.h"
 
@@ -454,8 +456,14 @@ static bool lru_gen_clear_refs(struct folio *folio)
  */
 void folio_mark_accessed(struct folio *folio)
 {
+	unsigned long pfn = folio_pfn(folio);
+
 	if (folio_test_dropbehind(folio))
 		return;
+
+	if (!node_is_toptier(pfn_to_nid(pfn)))
+		pghot_record_access(pfn, NUMA_NO_NODE, PGHOT_FMA, jiffies);
+
 	if (lru_gen_enabled()) {
 		lru_gen_inc_refs(folio);
 		return;
diff --git a/mm/vmstat.c b/mm/vmstat.c
index 62c47f44edf0..c4d90baf440b 100644
--- a/mm/vmstat.c
+++ b/mm/vmstat.c
@@ -1506,6 +1506,7 @@ const char * const vmstat_text[] = {
 	[I(PGHOT_RECORD_HWHINTS)]		= "pghot_recorded_hwhints",
 	[I(PGHOT_RECORD_PGTSCANS)]		= "pghot_recorded_pgtscans",
 	[I(PGHOT_RECORD_HINTFAULTS)]		= "pghot_recorded_hintfaults",
+	[I(PGHOT_RECORD_FMA)]			= "pghot_recorded_fma",
 #ifdef CONFIG_HWMEM_PROFILER
 	[I(HWHINT_NR_EVENTS)]			= "hwhint_nr_events",
 	[I(HWHINT_KERNEL)]			= "hwhint_kernel",
-- 
2.34.1


