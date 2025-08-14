Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 913B1CA0EDC
	for <linux-mm@archiver.kernel.org>; Thu, 14 Aug 2025 15:35:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2EE88900196; Thu, 14 Aug 2025 11:35:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 202CC900172; Thu, 14 Aug 2025 11:35:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 05417900196; Thu, 14 Aug 2025 11:35:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id DED5E900172
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 11:35:28 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 9F2F8C070E
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 15:35:28 +0000 (UTC)
X-FDA: 83775762336.01.C65919B
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2079.outbound.protection.outlook.com [40.107.92.79])
	by imf14.hostedemail.com (Postfix) with ESMTP id 9E076100009
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 15:35:25 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=1TUzs1dU;
	spf=pass (imf14.hostedemail.com: domain of Raghavendra.KodsaraThimmappa@amd.com designates 40.107.92.79 as permitted sender) smtp.mailfrom=Raghavendra.KodsaraThimmappa@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755185725;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=k5ESOs9Y3pdm6jtYpS7KpN9D0UPsottGxVqFvAze+WU=;
	b=mOHt8lqEFdv3IqdWbXYwoIHGp2LmfcCfyi4VWUu/Z/B51BhvxZqsFLRTYFt1R3RC09ai0E
	AmCapFRcr4b7mp/WgJmXLS42KJIc+apskt9Bf+Kiu4cMDhKrGH1TZM4cRh5nHoY1rUq/il
	GQiO/HtOyJgaXjGIT2bG6oLWVNmlxEA=
ARC-Authentication-Results: i=2;
	imf14.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=1TUzs1dU;
	spf=pass (imf14.hostedemail.com: domain of Raghavendra.KodsaraThimmappa@amd.com designates 40.107.92.79 as permitted sender) smtp.mailfrom=Raghavendra.KodsaraThimmappa@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1755185725; a=rsa-sha256;
	cv=pass;
	b=khLEjKEK7Rlx2CyCi0O2kqjhxsJzWM4MDsMXaziQgTEFFTPj/yXZatckZet8TFt298HUsk
	iJEbtLDtNApFbM6rrEH29UCehwajvQMi4biSgGI7BacTetEHDRiJnWOMsb13JdZhGiCGVe
	ed86D+Ny1erIResqZGPJY6GBtx61a7Y=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=uI1iCpTMFzh6xKY7eAjLcfA15CuJwKPsCvK2hc/LWtncyw1ag+wU7nekPAiQW3uXQzHgfMhIu0enzBaXwv6FBdHSA2vt//N4Y2EqBMg94e7ti8UlgiceRt2ybXfyY50gw0eVcl0qDq2pfgEPZXABjCMQsMy63wd4lonH4kwyFfffZUneeKCRIAlFrI8i/LpMJEDveqduETUfsW6Nqn5vL/dtFvTzRYh5yCcNqOecFKtWLx6oMN2xQeYOAOMcoxFogeKbAZzxOXR4qg8n31SoINnev+lWZiV3TUsyCqPq5XBEWyKh8Jt0E3CkPEjdGnUNP6iv2TQtg+hiRn+MLvA7XA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=k5ESOs9Y3pdm6jtYpS7KpN9D0UPsottGxVqFvAze+WU=;
 b=LQrnhgt63k1YMd0okbRQfx0DRiKSOsGs5wMVSc2fWgI+euvKHqAvZ5HWE1D7GJgCjT+g6CE3PqJDI3K0CXGTE+0XSz57c8bWTrsgI9H6kc4puTDvPTK8YQ+s+FrvXEMRF8yN5Yr8jlLt+nSJzRgPU4aWRZeFtugcDcf/FdUHADp6pfQ91/ufQ5/6sWvauFiR5i4NQ0gmzkgRKl8bimfVOzsK/bVqjJRZKHsiKuS+MLf6Hf8nOcBOV6uGHhbDHT8Vg/7XWwy04Xx24sdv2OjMviZu3sV3aiMoJx1jW0qyg2uF6hF3r044asncN27upMYDv/ztX5R3sImaJLzvJyidTQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=arm.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=k5ESOs9Y3pdm6jtYpS7KpN9D0UPsottGxVqFvAze+WU=;
 b=1TUzs1dU2Tlw9CWRd/KCNSO2zMNlkxMBPxuYeLE7QZxlGmb2MrktrfgZDNf3GD3SXSl/CRK0GLExgp4hrCcOwHIPiov3JVLOJ1/hWA62jtC2J0h3u1Zhd+cplfijQVWKbQ6dQkqcFHmpy/LPZu4CDuL1Hks4hdSBAKaGH0gpFuY=
Received: from BN0PR02CA0005.namprd02.prod.outlook.com (2603:10b6:408:e4::10)
 by CY8PR12MB7730.namprd12.prod.outlook.com (2603:10b6:930:85::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9031.17; Thu, 14 Aug
 2025 15:35:18 +0000
Received: from BN3PEPF0000B071.namprd04.prod.outlook.com
 (2603:10b6:408:e4:cafe::eb) by BN0PR02CA0005.outlook.office365.com
 (2603:10b6:408:e4::10) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9031.18 via Frontend Transport; Thu,
 14 Aug 2025 15:35:18 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN3PEPF0000B071.mail.protection.outlook.com (10.167.243.116) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.9031.11 via Frontend Transport; Thu, 14 Aug 2025 15:35:18 +0000
Received: from tunga.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Thu, 14 Aug
 2025 10:35:07 -0500
From: Raghavendra K T <raghavendra.kt@amd.com>
To: <raghavendra.kt@amd.com>
CC: <AneeshKumar.KizhakeVeetil@arm.com>, <Michael.Day@amd.com>,
	<akpm@linux-foundation.org>, <bharata@amd.com>, <dave.hansen@intel.com>,
	<david@redhat.com>, <dongjoo.linux.dev@gmail.com>, <feng.tang@intel.com>,
	<gourry@gourry.net>, <hannes@cmpxchg.org>, <honggyu.kim@sk.com>,
	<hughd@google.com>, <jhubbard@nvidia.com>, <jon.grimm@amd.com>,
	<k.shutemov@gmail.com>, <kbusch@meta.com>, <kmanaouil.dev@gmail.com>,
	<leesuyeon0506@gmail.com>, <leillc@google.com>, <liam.howlett@oracle.com>,
	<linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
	<mgorman@techsingularity.net>, <mingo@redhat.com>, <nadav.amit@gmail.com>,
	<nphamcs@gmail.com>, <peterz@infradead.org>, <riel@surriel.com>,
	<rientjes@google.com>, <rppt@kernel.org>, <santosh.shukla@amd.com>,
	<shivankg@amd.com>, <shy828301@gmail.com>, <sj@kernel.org>, <vbabka@suse.cz>,
	<weixugc@google.com>, <willy@infradead.org>, <ying.huang@linux.alibaba.com>,
	<ziy@nvidia.com>, <Jonathan.Cameron@huawei.com>, <dave@stgolabs.net>,
	<yuanchu@google.com>, <kinseyho@google.com>, <hdanton@sina.com>,
	<harry.yoo@oracle.com>
Subject: [RFC PATCH V3 10/17] mm: Add a heuristic to calculate target node
Date: Thu, 14 Aug 2025 15:33:00 +0000
Message-ID: <20250814153307.1553061-11-raghavendra.kt@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250814153307.1553061-1-raghavendra.kt@amd.com>
References: <20250814153307.1553061-1-raghavendra.kt@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN3PEPF0000B071:EE_|CY8PR12MB7730:EE_
X-MS-Office365-Filtering-Correlation-Id: e18778c0-8d4f-4708-afe8-08dddb482c2c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|1800799024|36860700013|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?xgLWA6DSXgk6bASZqFROIciQMibSILWhlt4uul1VCCRvUVxaTFQsqNCVJMbJ?=
 =?us-ascii?Q?P/PN5BF0MYCw0OW2h6J8Axr/0QjloWo6EY1DElkDcC5YjmLkL1IvPFuPOynj?=
 =?us-ascii?Q?Oori7j/VCGbGPNS7k5c169LlOHPHpD6hC69loZWlDh7wXr4XdLByrUxh6v4s?=
 =?us-ascii?Q?FAN6+cxZxxMEim+SgIuwVgpqr+cePFtpMihuF00zWSlcPbLn4zWHzA14TsGL?=
 =?us-ascii?Q?aEkDglltP6ie/q+MINGScw6LvfamqV8oHo1ThypWuWFNa+X4FjMRABWV26wv?=
 =?us-ascii?Q?/3P6BIOUHKQZuwm3mOAsYbmwXsJ52HQRKKY5ktxIkkDIuFLxC/zTBSEyUBiB?=
 =?us-ascii?Q?yuoYQRrA2gm8YA4L3nU/OeO2pK881bjLfhgL6yusL23/k/Y1tdak7q126byI?=
 =?us-ascii?Q?T296qngF4DMvNkuKvaJ+AWBVVli4F7P3T/xANhdgnx0LN1A9CN3xia3nMD63?=
 =?us-ascii?Q?wXHdcPfFV/gHqBRbJMu10mm1dydUJk1IgouUXV5Gmzdm5nrBvXeijtccGp2r?=
 =?us-ascii?Q?6QSwBxJtMu6cnymdwEhTzofUsGnQqMsLDiiSgPuUFh971ybgcn0dEUWZwYhz?=
 =?us-ascii?Q?rvkkHKG6s9SsVmw1n4n7nZijENScqxPUahpX5df1LZw+2M/4PZ3qmvEWrX5L?=
 =?us-ascii?Q?98UtqeTJb9tnWoaNgfA30G2cXT5GEIcKylmAI6gFWb1TxJPozxTOQ+fo4ns8?=
 =?us-ascii?Q?3GicTiPYufxaj2Nnbi2J1rVgTIndLthg0ullEpbezijehPty2BgKdn7pqO7l?=
 =?us-ascii?Q?awEFRnK2PC9SQq5VpRyjMW0FITInkqht2AXAzf+QFEpBdRq8qahvUqZU4YMI?=
 =?us-ascii?Q?X0mekNqL0D7qbc/Zfd8tGGDDXMk/YvFurqMGpZhRcND+4pke4smi0fcarTn9?=
 =?us-ascii?Q?kKv8CPMxazD3XVfynM2TkakOaDakGSdGfSPb847oG60+DshSpnQZLxmU0ymR?=
 =?us-ascii?Q?HePrNmImxm1tc1T4bTgayfoKkm4cEhOseuHAIl4Js0zAZ14q3X02qbjU4sW4?=
 =?us-ascii?Q?p9+IwSHzJsDvdCaQnTyM4fHVONM82gS5B9ZXvOeLaughpomyUwWqp2Jcf68u?=
 =?us-ascii?Q?tCO+mXWGUm75hsCP8uaF6bVUyZDOtd58KPFm7G7GsgsBKMgyZxspGTXfEv6Q?=
 =?us-ascii?Q?QKTNDM7Z9jGtNuD9zP3j9pvgLYfgs6cOL/tvPoztbSVX8WsS+K/zLV0jh1+V?=
 =?us-ascii?Q?TlF1/tUnlACYPfygNbljXFd0OgljneEHw0z/KHUQwyIHKpjjgq0NFd/Vdp7d?=
 =?us-ascii?Q?jUdkn9c1zITAYvFzulf7SVaL//cHFLCD8VMw/pG8MHxOeWSrCnEB7AEN59Ek?=
 =?us-ascii?Q?eUev7F0osHSJi+dUQ4XVRPLpxzwFsDSifcEd5xABJ7ZceuEPl34YePdF4R3Z?=
 =?us-ascii?Q?GFvgAGPkZb3nZ0D/5gc9T6h8aY02NkIqSJ8EHn1gPFUWar3glJAmmQuIwTk1?=
 =?us-ascii?Q?3mq1n8QhhYuCrDkO95smoIVBa1s3ynLesPbe89K/Jbxout0L98mcqo9HqBCA?=
 =?us-ascii?Q?UnSnVBMpgmdDP6E4xaOJf8tdIUiXvfsS/y6K?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(1800799024)(36860700013)(7416014)(376014);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Aug 2025 15:35:18.1283
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e18778c0-8d4f-4708-afe8-08dddb482c2c
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN3PEPF0000B071.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB7730
X-Rspamd-Queue-Id: 9E076100009
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: f1zfumgb39ituktuddhx3ifqy8okqq94
X-HE-Tag: 1755185725-333571
X-HE-Meta: U2FsdGVkX1+0/XOfqwQanP3dHBdvmGnYWf/yqaetUDH80gJMAeD7ZyP5NoFqoQBXNh98Gs4Uwy9PP3/XZSanUN3fJiEqZFQBK9YC8YP1wTolc7H5ZiX7LKQfX2BsjVqDh+mdoYT1DhaGBIMIQ3BxJ5Sz0EdLJ7aIv9DTQMLTNX9eHX1UklfM8avzheATP8EPYFGCBauxEWD0qqXVxWgA+Yg3ZoHUU0jwksvKT2LUWOTS4g7cJ02BVnS9uSQkF7HE0Nt6ijQJSuRXI6psDBQCF70+cjQXCleL1jAbrBlQVGmdKP4Bx+e1kljk++Mox6XhK5O7zmgNHLd4wAG8sBREsxSHt8Q2hfi37IQTUnUQ7li7L2oshvVTBL/IjZhEVmxf6yqBH80hifFiAe/KkC+/DqwnTzInhopOTxjqxVRBLKamXoRPxCSRMLZ0u4XDdn3w9QIkpiezAnxoZkCbvuxF8S4kKgqYE7Qd6Kc73Xd9kOEpL5JtSuotWJAvdoKDYL8F9I55W9KUuSrJYbxV+6JmWuVLjFhoZURXBLSix3Vl1NWPBZFRGhil/oxynNU9+En3k3KXJheXeSCivxNAE3Qd8aCIs+MJvwvKLwqHDPCYtyJhRTkXKA9/NIZw8EUMdRpgZFVs8LP1hytmNzfg2oxO/lr/pBaiNuggdZJW3AMP7g7rwZxSmAubUO/F0fZ7uWL7fk4FtsfazNDBGrd0NiNxBGD/BV+flR0ijEJg8lhV4hFO6M2HdGs5HV49SIVhBCOnU8d0fj5AuvIQUtvqGKDXX+oMYARJgwtTwOPG45wLOJNYXYSLEUcMdCOvMgcaMBp2bYCdlK2Qvpp9LHkn2Tx3CPXyx3cfwRTrPZjb0UwBZWS0jKikE8p76aqcAzJlRHFp5RmSFKoAs0RMpQ6aKF3Sn2vio7m4tBeWWS17WnApgww2PQoHs/vEYLs+Z1XqoYHIiUGlBrtBuQhFtH63+ss
 hc2ICzzA
 0UllEWORLpv2Ftu6UqFvQSwfe+FvkcCNW8skDbThhsyOr2dOcDik4e8kKixneM082H85okIxGIgdJBqUfkxjwjrn6pUIDJZiani3bvvJqzQf1U9TOTz7W2QE2wTPseiKXDiVrRS66g3q01BRP9n30Y3mgCv6oI5MkolXfG2ecLyg5d/V240eRf/S9ocllAgq98QzLqT43NTsGSXi2fv5hX6V+oVU96SwO757GUG83tt29cpH54ZsMqaORE9B5Q/rqmcx5dLal6iTyI8iafATDz9+S3ejeeIdN3Sbp0WBGsPl0r5xXH9xDoeTvqZlbk7iqlbUmWrE4N2Pt2opwiBaTJNGL5OB5KM37B7lpO/fWpUbmJmyFWt9nVkRRZGPp4rxEPgWxfCiKpC0tSeeHxTJucbGXxMD5F7w0Qhz+0kP4BLNdO7Irx6t5oXBQNJI4wHjzs7BNl0cbO7gb6GYO00sG07gIlRJi69Hyx2uOQs09tLo/OBmxcBYVxxquSTEeIWzEl760k5ABlvf3IIEeleCLP9CaUBZ5A/ZPJXz+hzSSRW5hbmkMLyNDiCq0ddtOLbjkig2H/fQtamzNA/oqkYnIn4F7UPSAbAMRD3eZbfLDGePXQvPMPsoXoV9bcDvq9GWuQiY0zgpSc8UrDy7RVvBV0oRUHmDA7A24CMZoTIu3TADW+czXoiBUKF7DPJJIxzS27aV4rCau60fdDI8MzppP82QxXmvY7h6DHUIj2EGHyDq4LrfACINHIdchyoNa9DrKQnBFgZs4qJwwDdF/1tTCXyn3ReNA+pcS3khAtYFJRZ9YS86s1IcR8B+6uplliYup3PrMv4HBNN+PhJkmOcUshtF0sjFbv9L9RpIABlVeJ18q3Pg=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

One of the key challenges in PTE A bit based scanning is to find right
target node to promote to.

Here is a simple heuristic based approach:
 1. While scanning pages of any mm, also scan toptier pages that belong
to that mm.
 2. Accumulate the insight on the distribution of active pages on
toptier nodes.
 3. Walk all the top-tier nodes and pick the one with highest accesses.

 This method tries to consolidate application to a single node.

TBD: Create a list of preferred nodes for fallback when highest access
 node is nearly full.

Signed-off-by: Raghavendra K T <raghavendra.kt@amd.com>
---
 include/linux/mm_types.h |   4 +
 mm/kscand.c              | 198 +++++++++++++++++++++++++++++++++++++--
 2 files changed, 192 insertions(+), 10 deletions(-)

diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
index d6b91e8a66d6..e3d8f11a5a04 100644
--- a/include/linux/mm_types.h
+++ b/include/linux/mm_types.h
@@ -1148,6 +1148,10 @@ struct mm_struct {
 		/* numa_scan_seq prevents two threads remapping PTEs. */
 		int numa_scan_seq;
 #endif
+#ifdef CONFIG_KSCAND
+		/* Tracks promotion node. XXX: use nodemask */
+		int target_node;
+ #endif
 		/*
 		 * An operation with batched TLB flushing is going on. Anything
 		 * that can move process memory needs to flush the TLB when
diff --git a/mm/kscand.c b/mm/kscand.c
index 880c3693866d..bf975e82357d 100644
--- a/mm/kscand.c
+++ b/mm/kscand.c
@@ -104,6 +104,7 @@ struct kscand_mm_slot {
 	unsigned long scan_size;
 	long address;
 	bool is_scanned;
+	int target_node;
 };
 
 /* Data structure to keep track of current mm under scan */
@@ -116,13 +117,23 @@ struct kscand_scan kscand_scan = {
 	.mm_head = LIST_HEAD_INIT(kscand_scan.mm_head),
 };
 
+/* Per memory node information used to caclulate target_node for migration */
+struct kscand_nodeinfo {
+	unsigned long nr_scanned;
+	unsigned long nr_accessed;
+	int node;
+	bool is_toptier;
+};
+
 /*
  * Data structure passed to control scanning and also collect
  * per memory node information
  */
 struct kscand_scanctrl {
 	struct list_head scan_list;
+	struct kscand_nodeinfo *nodeinfo[MAX_NUMNODES];
 	unsigned long address;
+	unsigned long nr_to_scan;
 };
 
 struct kscand_scanctrl kscand_scanctrl;
@@ -218,15 +229,129 @@ static void kmigrated_wait_work(void)
 			migrate_sleep_jiffies);
 }
 
-/*
- * Do not know what info to pass in the future to make
- * decision on taget node. Keep it void * now.
- */
+static unsigned long get_slowtier_accesed(struct kscand_scanctrl *scanctrl)
+{
+	int node;
+	unsigned long accessed = 0;
+
+	for_each_node_state(node, N_MEMORY) {
+		if (!node_is_toptier(node) && scanctrl->nodeinfo[node])
+			accessed += scanctrl->nodeinfo[node]->nr_accessed;
+	}
+	return accessed;
+}
+
+static inline unsigned long get_nodeinfo_nr_accessed(struct kscand_nodeinfo *ni)
+{
+	return ni->nr_accessed;
+}
+
+static inline void set_nodeinfo_nr_accessed(struct kscand_nodeinfo *ni, unsigned long val)
+{
+	ni->nr_accessed = val;
+}
+
+static inline unsigned long get_nodeinfo_nr_scanned(struct kscand_nodeinfo *ni)
+{
+	return ni->nr_scanned;
+}
+
+static inline void set_nodeinfo_nr_scanned(struct kscand_nodeinfo *ni, unsigned long val)
+{
+	ni->nr_scanned = val;
+}
+
+static inline void reset_nodeinfo_nr_scanned(struct kscand_nodeinfo *ni)
+{
+	set_nodeinfo_nr_scanned(ni, 0);
+}
+
+static inline void reset_nodeinfo(struct kscand_nodeinfo *ni)
+{
+	set_nodeinfo_nr_scanned(ni, 0);
+	set_nodeinfo_nr_accessed(ni, 0);
+}
+
+static void init_one_nodeinfo(struct kscand_nodeinfo *ni, int node)
+{
+	ni->nr_scanned = 0;
+	ni->nr_accessed = 0;
+	ni->node = node;
+	ni->is_toptier = node_is_toptier(node) ? true : false;
+}
+
+static struct kscand_nodeinfo *alloc_one_nodeinfo(int node)
+{
+	struct kscand_nodeinfo *ni;
+
+	ni = kzalloc(sizeof(*ni), GFP_KERNEL);
+
+	if (!ni)
+		return NULL;
+
+	init_one_nodeinfo(ni, node);
+
+	return ni;
+}
+
+/* TBD: Handle errors */
+static void init_scanctrl(struct kscand_scanctrl *scanctrl)
+{
+	struct kscand_nodeinfo *ni;
+	int node;
+
+	for_each_node(node) {
+		ni = alloc_one_nodeinfo(node);
+		if (!ni)
+			WARN_ON_ONCE(ni);
+		scanctrl->nodeinfo[node] = ni;
+	}
+}
+
+static void reset_scanctrl(struct kscand_scanctrl *scanctrl)
+{
+	int node;
+
+	for_each_node_state(node, N_MEMORY)
+		reset_nodeinfo(scanctrl->nodeinfo[node]);
+
+	/* XXX: Not rellay required? */
+	scanctrl->nr_to_scan = kscand_scan_size;
+}
+
+static void free_scanctrl(struct kscand_scanctrl *scanctrl)
+{
+	int node;
+
+	for_each_node(node)
+		kfree(scanctrl->nodeinfo[node]);
+}
+
 static int kscand_get_target_node(void *data)
 {
 	return kscand_target_node;
 }
 
+static int get_target_node(struct kscand_scanctrl *scanctrl)
+{
+	int node, target_node = NUMA_NO_NODE;
+	unsigned long prev = 0;
+
+	for_each_node(node) {
+		if (node_is_toptier(node) && scanctrl->nodeinfo[node]) {
+			/* This creates a fallback migration node list */
+			if (get_nodeinfo_nr_accessed(scanctrl->nodeinfo[node]) > prev) {
+				prev = get_nodeinfo_nr_accessed(scanctrl->nodeinfo[node]);
+				target_node = node;
+			}
+		}
+	}
+	if (target_node == NUMA_NO_NODE)
+		target_node = kscand_get_target_node(NULL);
+
+	return target_node;
+}
+
 extern bool migrate_balanced_pgdat(struct pglist_data *pgdat,
 					unsigned long nr_migrate_pages);
 
@@ -495,6 +620,14 @@ static int hot_vma_idle_pte_entry(pte_t *pte,
 	page_idle_clear_pte_refs(page, pte, walk);
 	srcnid = folio_nid(folio);
 
+	scanctrl->nodeinfo[srcnid]->nr_scanned++;
+	if (scanctrl->nr_to_scan)
+		scanctrl->nr_to_scan--;
+
+	if (!scanctrl->nr_to_scan) {
+		folio_put(folio);
+		return 1;
+	}
 
 	if (!folio_test_lru(folio)) {
 		folio_put(folio);
@@ -502,13 +635,17 @@ static int hot_vma_idle_pte_entry(pte_t *pte,
 	}
 
 	if (!kscand_eligible_srcnid(srcnid)) {
+		if (folio_test_young(folio) || folio_test_referenced(folio)
+				|| pte_young(pteval)) {
+			scanctrl->nodeinfo[srcnid]->nr_accessed++;
+		}
 		folio_put(folio);
 		return 0;
 	}
 	if (!folio_test_idle(folio) && !prev_idle &&
 		(folio_test_young(folio) || folio_test_referenced(folio))) {
 
-		/* XXX: Leaking memory. TBD: consume info */
+		scanctrl->nodeinfo[srcnid]->nr_accessed++;
 
 		info = kzalloc(sizeof(struct kscand_migrate_info), GFP_NOWAIT);
 		if (info && scanctrl) {
@@ -697,7 +834,13 @@ static void kmigrated_migrate_mm(struct kmigrated_mm_slot *mm_slot)
 
 			spin_unlock(&mm_slot->migrate_lock);
 
-			dest = kscand_get_target_node(NULL);
+			if (!mmap_read_trylock(mm)) {
+				dest = kscand_get_target_node(NULL);
+			} else {
+				dest = READ_ONCE(mm->target_node);
+				mmap_read_unlock(mm);
+			}
+
 			ret = kmigrated_promote_folio(info, mm, dest);
 
 			kfree(info);
@@ -783,7 +926,7 @@ static void kmigrated_migrate_folio(void)
  *		Increase scan_size by (1 << SCAN_SIZE_CHANGE_SHIFT).
  */
 static inline void kscand_update_mmslot_info(struct kscand_mm_slot *mm_slot,
-				unsigned long total)
+				unsigned long total, int target_node)
 {
 	unsigned int scan_period;
 	unsigned long now;
@@ -831,6 +974,7 @@ static inline void kscand_update_mmslot_info(struct kscand_mm_slot *mm_slot,
 	mm_slot->scan_period = scan_period;
 	mm_slot->scan_size = scan_size;
 	mm_slot->scan_delta = total;
+	mm_slot->target_node = target_node;
 }
 
 static unsigned long kscand_scan_mm_slot(void)
@@ -839,6 +983,7 @@ static unsigned long kscand_scan_mm_slot(void)
 	bool update_mmslot_info = false;
 
 	unsigned int mm_slot_scan_period;
+	int target_node, mm_slot_target_node, mm_target_node;
 	unsigned long now;
 	unsigned long mm_slot_next_scan;
 	unsigned long mm_slot_scan_size;
@@ -872,6 +1017,7 @@ static unsigned long kscand_scan_mm_slot(void)
 	mm_slot_next_scan = mm_slot->next_scan;
 	mm_slot_scan_period = mm_slot->scan_period;
 	mm_slot_scan_size = mm_slot->scan_size;
+	mm_slot_target_node = mm_slot->target_node;
 	spin_unlock(&kscand_mm_lock);
 
 	if (unlikely(!mmap_read_trylock(mm)))
@@ -882,6 +1028,9 @@ static unsigned long kscand_scan_mm_slot(void)
 		goto outerloop;
 	}
 
+	mm_target_node = READ_ONCE(mm->target_node);
+	if (mm_target_node != mm_slot_target_node)
+		WRITE_ONCE(mm->target_node, mm_slot_target_node);
 	now = jiffies;
 
 	if (mm_slot_next_scan && time_before(now, mm_slot_next_scan))
@@ -889,24 +1038,41 @@ static unsigned long kscand_scan_mm_slot(void)
 
 	VMA_ITERATOR(vmi, mm, address);
 
+	/* Either Scan 25% of scan_size or cover vma size of scan_size */
+	kscand_scanctrl.nr_to_scan =	mm_slot_scan_size >> PAGE_SHIFT;
+	/* Reduce actual amount of pages scanned */
+	kscand_scanctrl.nr_to_scan =	mm_slot_scan_size >> 1;
+
+	/* XXX: skip scanning to avoid duplicates until all migrations done? */
 	kmigrated_mm_slot = kmigrated_get_mm_slot(mm, false);
 
 	for_each_vma(vmi, vma) {
 		kscand_walk_page_vma(vma, &kscand_scanctrl);
 		vma_scanned_size += vma->vm_end - vma->vm_start;
 
-		if (vma_scanned_size >= kscand_scan_size) {
+		if (vma_scanned_size >= mm_slot_scan_size ||
+					!kscand_scanctrl.nr_to_scan) {
 			next_mm = true;
 
 			if (!list_empty(&kscand_scanctrl.scan_list)) {
 				if (!kmigrated_mm_slot)
 					kmigrated_mm_slot = kmigrated_get_mm_slot(mm, true);
+				/* Add scanned folios to migration list */
 				spin_lock(&kmigrated_mm_slot->migrate_lock);
+
 				list_splice_tail_init(&kscand_scanctrl.scan_list,
 						&kmigrated_mm_slot->migrate_head);
 				spin_unlock(&kmigrated_mm_slot->migrate_lock);
+				break;
 			}
-			break;
+		}
+		if (!list_empty(&kscand_scanctrl.scan_list)) {
+			if (!kmigrated_mm_slot)
+				kmigrated_mm_slot = kmigrated_get_mm_slot(mm, true);
+			spin_lock(&kmigrated_mm_slot->migrate_lock);
+			list_splice_tail_init(&kscand_scanctrl.scan_list,
+					&kmigrated_mm_slot->migrate_head);
+			spin_unlock(&kmigrated_mm_slot->migrate_lock);
 		}
 	}
 
@@ -917,9 +1083,19 @@ static unsigned long kscand_scan_mm_slot(void)
 
 	update_mmslot_info = true;
 
+	total = get_slowtier_accesed(&kscand_scanctrl);
+	target_node = get_target_node(&kscand_scanctrl);
+
+	mm_target_node = READ_ONCE(mm->target_node);
+
+	/* XXX: Do we need write lock? */
+	if (mm_target_node != target_node)
+		WRITE_ONCE(mm->target_node, target_node);
+	reset_scanctrl(&kscand_scanctrl);
+
 	if (update_mmslot_info) {
 		mm_slot->address = address;
-		kscand_update_mmslot_info(mm_slot, total);
+		kscand_update_mmslot_info(mm_slot, total, target_node);
 	}
 
 outerloop:
@@ -1113,6 +1289,7 @@ static int stop_kscand(void)
 		kthread_stop(kscand_thread);
 		kscand_thread = NULL;
 	}
+	free_scanctrl(&kscand_scanctrl);
 
 	return 0;
 }
@@ -1168,6 +1345,7 @@ static inline void init_list(void)
 	spin_lock_init(&kscand_migrate_lock);
 	init_waitqueue_head(&kscand_wait);
 	init_waitqueue_head(&kmigrated_wait);
+	init_scanctrl(&kscand_scanctrl);
 }
 
 static int __init kscand_init(void)
-- 
2.34.1


