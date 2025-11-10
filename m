Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CAC48CCFA1A
	for <linux-mm@archiver.kernel.org>; Mon, 10 Nov 2025 05:25:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 367F78E000C; Mon, 10 Nov 2025 00:25:40 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 318A88E0002; Mon, 10 Nov 2025 00:25:40 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1B97B8E000C; Mon, 10 Nov 2025 00:25:40 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id F25188E0002
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 00:25:39 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 981055CCC8
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 05:25:39 +0000 (UTC)
X-FDA: 84093559998.27.F359069
Received: from DM1PR04CU001.outbound.protection.outlook.com (mail-centralusazon11010047.outbound.protection.outlook.com [52.101.61.47])
	by imf21.hostedemail.com (Postfix) with ESMTP id 9F74D1C0007
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 05:25:36 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=fAeYySKf;
	spf=pass (imf21.hostedemail.com: domain of bharata@amd.com designates 52.101.61.47 as permitted sender) smtp.mailfrom=bharata@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762752336;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qzp+cHD6y7n0qgZUM660jxY6Usl6GCiSTZiE2/kM6DM=;
	b=EuVRKohIm0CjLl5NwfABkE/Z2uTAM1NO7BOSnT3yBi5x7tPSyHR5zasEEagIyyDAzquZU8
	wStM/H0YPQQosJQxa8Mkgn98wHlastucxnunCL0j5vA+eAmHnv6YFC25OaqBeQwSB7q9XE
	BKvnRFdm+nbqjikO4hCkGfQuDKUtV1s=
ARC-Authentication-Results: i=2;
	imf21.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=fAeYySKf;
	spf=pass (imf21.hostedemail.com: domain of bharata@amd.com designates 52.101.61.47 as permitted sender) smtp.mailfrom=bharata@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1762752336; a=rsa-sha256;
	cv=pass;
	b=8grpvluTyDGlGhYrRcLJ1/xBkEfKkbCDBg3JD4hAsxJNITwQ5cCTIjJgvLBxY0RuATOSpO
	ejCB4h5p0mVp+02/KlYZipp57lcSCzMHVyjiJLrX9kh3QLXlmavpFed/lv7n7rzRp3X6Fr
	uhy3Cay8mJQUH9CH+TM77dxFWSJ59qM=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Iu7R94cFDhbGIcFrFYQy3kjcWsR8BW2VUDCx8UV9s44wZbCuRs2r531uYr3JTjRY477rG/bUW5Z9QPKcFQdwYgfb/huXFX/yL/CRFPodzgRzxx/eEOw/wh1iCVhlifjMgavIp3gja5ypUazG5JqumbAdfgpeZYXGtEcmuQMZSliU6Ab49IujAdDTYhYS0AQ1MJY9K+DskDxaPV99KPSSadyvoAjEeewdFfzFeFVUUXOxnhd64uTu+uCEzR8Vy2qAkExGC61cWO3BullFMinGAIIAaotz0wnahlJ7f2Kkn2eMz1reGhwT7+YnG9IJGyqWtq7Oi0wN0RvIeMi1Qcbjdg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qzp+cHD6y7n0qgZUM660jxY6Usl6GCiSTZiE2/kM6DM=;
 b=G8hhFcJgFw81jZFXYa5bRdehnnKEIVV5fYEwJWFggAcsF1bQOkzuKFck3pmvyTiI55wBkqTpyBipMPb/trYyyT48uwR+i4y2E51AZWPJ5cydnmQUYy7XvBY12JFcsml1X3w5FOjD3nf0EKaUaVHnYxD/X29dpyDuqKobpw+bfWrPGZgqBOBTJ6TwS6G9kR7v/YCOXVDbfMghhm804hXg7w+PItNONQ51suQQhcFE6UeIfnENNBWEI4jjZrAxeM33F89oBDnSE51Jwiau6xEQ4koYPVrcD1cdG9xAr5FDXwHCaIMlejyZoSzmxYLohJKYXi5DCjeG5j9vfjnTYunWgA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qzp+cHD6y7n0qgZUM660jxY6Usl6GCiSTZiE2/kM6DM=;
 b=fAeYySKfBaA9V+U2lh0hJygVE7CfPOIlqNPSmLJ/PJr2KwJOFo/yGyMKhbaN5d6LbLdIiRKN2PBzXT4gfKDsUJij4UmU0PcGzBZYe1VZ289tKjyVYnLJucSe4lL+VMcg+VDPvy0V2RSQP7WVal+/mrL94SBLdEsw+QTh1lZXWnY=
Received: from BN9PR03CA0215.namprd03.prod.outlook.com (2603:10b6:408:f8::10)
 by CH3PR12MB8188.namprd12.prod.outlook.com (2603:10b6:610:120::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9298.16; Mon, 10 Nov
 2025 05:25:30 +0000
Received: from BN2PEPF000044AA.namprd04.prod.outlook.com
 (2603:10b6:408:f8:cafe::31) by BN9PR03CA0215.outlook.office365.com
 (2603:10b6:408:f8::10) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9298.15 via Frontend Transport; Mon,
 10 Nov 2025 05:25:29 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 BN2PEPF000044AA.mail.protection.outlook.com (10.167.243.105) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9320.13 via Frontend Transport; Mon, 10 Nov 2025 05:25:30 +0000
Received: from BLR-L-BHARARAO.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Sun, 9 Nov
 2025 21:25:21 -0800
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
Subject: [RFC PATCH v3 3/8] mm: Hot page tracking and promotion
Date: Mon, 10 Nov 2025 10:53:38 +0530
Message-ID: <20251110052343.208768-4-bharata@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20251110052343.208768-1-bharata@amd.com>
References: <20251110052343.208768-1-bharata@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: satlexmb08.amd.com (10.181.42.217) To satlexmb07.amd.com
 (10.181.42.216)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN2PEPF000044AA:EE_|CH3PR12MB8188:EE_
X-MS-Office365-Filtering-Correlation-Id: 9c187ac2-1fd1-4cda-42ad-08de2019904f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|82310400026|7416014|376014|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?boXNT/HZuNA8/CjL5j58JyC57rN1uG3NOuRfGcTsEjkBCmg9nSGtsfC4lirJ?=
 =?us-ascii?Q?HYdCr6IZnlh5hLTpLyP86YGsRcPO7rXSnMOa944G0417vrA68XQiuSA2TjzT?=
 =?us-ascii?Q?04Uktl/xOpyvLuugYyWBxJm3RU2d+MlOdYr7H/PCtoB4fRJ3aeKlELC36FqU?=
 =?us-ascii?Q?YFYTGKvFFLj1dCofHVNRDQYUkvN9Hon6thoRzRPw1P91Eg3Hb+Y/+ULiIg9a?=
 =?us-ascii?Q?NZUJbg2u80ZCU+Tcvn2XKb0KXIBxAMySj2k/Fi68WZL9r1VaYeoG/CaFQTbg?=
 =?us-ascii?Q?/MflZt+pfkbVPm2MxtRY5idwUsbwdmqUws4V9VbXb7y5due6tmZvigrEQtNw?=
 =?us-ascii?Q?jNz1/8hYEBLYWrhhO1SrqZvtC+xqBphHP4uHjfnqIJNSJuaGX+Nr9tp/nAji?=
 =?us-ascii?Q?4uQJfYAu/WXr/jzp5T+jXbvwyU3avBzj8d69Wz9Q/upF5QM4KnAmH749xHrH?=
 =?us-ascii?Q?WKrKO297PehvHKssfgEGShKco9/2IMYDB1pj8Em5eGFriGjRO6EzStN4Ek9K?=
 =?us-ascii?Q?Bd//6wR/K8VCc+QNTM3bmPFV/JzY/mNb/81G5ngsE9For0AQFPxLzHGk4tUd?=
 =?us-ascii?Q?bSI3Asrq0Qv3Of70zqNEUALQGDdgcUzX3AyU0F3+p+xbjzosLZcBPr+/ggPi?=
 =?us-ascii?Q?15HbL701MklW4Thb2EGZB/w9iEkB8OLtIjCNXfEldCUuSGDGT2kH+qaYh9fn?=
 =?us-ascii?Q?CEgVKcRFPc8X+fDCMNaepm9aOq2HnbzQ3mA4cuY9ZtKTJluUx/SKomFn/XwE?=
 =?us-ascii?Q?sOjMsS/lvs7Qt3brWctGXsEa9TPBk0cy1mIckrUz6LMcY89+tAGWgVFkDByS?=
 =?us-ascii?Q?baNOGZN0+Br9ya0QublDqb3fKt6sVIhseaJc/+8agl/uaBC05CbJa2pi2iWF?=
 =?us-ascii?Q?99LywsYjoD/5azL32BV2R+WSAleKNOaM4CmIJ6gUUplLmDwycM0405aG/hZY?=
 =?us-ascii?Q?iXUogUu+u3PSN+sm1jeDrHokgeGpkp3iCQSNTJk/uhc35mT2N4KDjSDaTByB?=
 =?us-ascii?Q?gxy+6dbGcwEyNhbAPPPUcanKOMe2ZeI9r9uI4vG7yBbieFz6LPrFcQRdz34O?=
 =?us-ascii?Q?klMMAzuXicuVVTq2lU7gRPaVtKmtaFiQHvPdNKfqHumqxvxG/W0sAbr+PV+x?=
 =?us-ascii?Q?a+R6iguPfa/I07wIFMtEFinU/HPHQDnxDh+Yx50AMF9QFqmfuAUbRS9QSEva?=
 =?us-ascii?Q?bf4YipEQyDxFT64c9IcEuvNXCX/6FN5uv8BvVVb8KsrGTysEUB/VIpeC6Yu4?=
 =?us-ascii?Q?au4Xe9LKaG9ZmZKKL/2q/jBvbfErnzXIPe4Aq9aAxOXNyHQLSEZTkcLeJcuT?=
 =?us-ascii?Q?kGZk3BrNGMhvLP7maYRPvalXh6lfI+QNWS8kRDmwTCCbNI5OTVMxz9CQoXki?=
 =?us-ascii?Q?WXcub2lrHL7qjwlQGrwV+90HoLrQCQNYt9XgtmEKkkiUYlhiL+JhQeiBNuvQ?=
 =?us-ascii?Q?C1W8/2z01Pyl0MWuNFqcerTC+jpUvcIRvJKdKtmNxVnT76xGutbNTlGWjwYK?=
 =?us-ascii?Q?a+F0i/AtxHrW38pvNrJnOnlk5LsQtPR5hPJeNfdz7aVKrLe2/Pdl103vWxYP?=
 =?us-ascii?Q?LOWw25pObVr4Kd7S6pk=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(82310400026)(7416014)(376014)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Nov 2025 05:25:30.0155
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 9c187ac2-1fd1-4cda-42ad-08de2019904f
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN2PEPF000044AA.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB8188
X-Rspamd-Queue-Id: 9F74D1C0007
X-Stat-Signature: gouj8ptxn3f7e7xrygawge9awgqn7tz8
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1762752336-858156
X-HE-Meta: U2FsdGVkX18DKt/kEA/k8Xa5g9aZGSgyH2HJItLfwImVLc2re/rPtZu5ZvCxMsKJcBdx7Opyw9AsJ0qCNus4ycTtVkf3tmZNS54JTaNtJBH4zWyX+0C7RfUiOrpFW5JfDye0i07X7EE/nZIymJX/4ms3IqPcoqk7uauZTjotQEWS9ZGQyN41/QuL5zGECnEukNnDENSNN6mGoScK8L5/dYlvIRGVqspkXsG7oicOXYYqna7Pk6z6JzOtFMz9pDKqqbwiUAktA5wP1u004d+uGmU+Ut7kKkQColHhyQ+wePQZGbMvt3faOEdkgozo/7UVQxXHpqbAtm2UbWsBB5k32o7bb12tChhTmQdicdU7oEpFbDQCtRqdA9jzqaXGnc2BKMT1OAnmtcu7RNvAf2BA3ozp0EfyaNy2pU6hBPZgjRaLWvJ/i/kpf8c/D4y3pvb/0imT9qdwu1wmZCrZobCPRrzORGwSNXcBU2At3kOb9h9DEAaFCa0dOqY4BvfOu980xtoVvE9BnHjsbcjMnVj56x5oaVzPrCKwhFev5kCL0TyNNk9fqK6VmzKZCkAnF3/2RfBYu418DH+u2yVJn65x56fEzj2oGwMZOy98DGKgEoOP7utstbMUnh3mJ8Qx3ShMtPPtn2KbPEvkaT3he8aDQzTWvGB7iuxh4OcrjVn4uozYo8yMeaJA/cf7MlaW0A/79MX0kgpswf1KVsJoEU+U7sYuRpm1Vgv+XeLtUMLXDID2ck63+14MqQR20aAdlZC7AcH6jONw2kjFnsEWJmaPnDWJY0Gea8x5Cswm8m34qkoLMy5UJAYC+mzfVBP24wanXxTy7Ucon09q0Un6+aO2oXcEh7V8pMXvKb8XW+88VwCJzYIq6AgR36KebdyiZSpWn7bt9yH/S6iDZEaLcXZPW/4jDwZG4afAF0CzXwqw24Qv5Ytl4eSyGshopUJMp7eiM6sA8VdovBeN/+wVRZU
 TVo44Gl6
 hcaojffx581Q046UBYBmTrZlxRW3QlBhBGYJ0XG0KiEUCTT31Wo9rO20M15bhntZXGpnm0URAgABFqhuJxfeXApP4ra7gGVp2bbZYX8uzNzgcDvCxUwyXKo6VJL8Fa/ZBWdY8DdoXW14pnTA6ZBB7FKee3rA5dVSK4FbtksSbvDme5F/RVNByQYENMiCa6g7Xdk/woIiQURR9xbUwARB5UcOZWs1y/VVDUKAPNyoItRV20/wdp6aSQCXbW116+8Hr8Cv8Dynx0rE+4wrs2UjKSju1C89MQQomhbBbZH4svu0kfAjSi0P3mb/0zHYlWSoc2nOVm8W79Mrop+pdCmVNQys8mI/7zvx1cgdaiAZC/roWA0Cyx72yRkXrsjH8Z82yaXx5gN2hj4svzZ/XivJudtJ41KAuDuxIOR59E3phYXtsrR/i83JBc3FOtAwxTRJvt+cVgqsMMKsVJovEJOrJUURX+Bbd13hEp6tbBRAJZKQagyErqamVG3TcOg5JInXsR5a+VWoMsmfK9YCuPoJkWoNjB+9O8qUNDwT/hczFxytPZJzEEn7BfvbZfQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This introduces a sub-system for collecting memory access
information from different sources. It maintains the hotness
information based on the access history and time of access.

Additionally, it provides per-lowertier-node kernel threads
(named kmigrated) that periodically promote the pages that
are eligible for promotion.

Sub-systems that generate hot page access info can report that
using this API:

int pghot_record_access(unsigned long pfn, int nid, int src,
                        unsigned long time)

@pfn: The PFN of the memory accessed
@nid: The accessing NUMA node ID
@src: The temperature source (sub-system) that generated the
      access info
@time: The access time in jiffies

Some temperature sources may not provide the nid from which
the page was accessed. This is true for sources that use
page table scanning for PTE Accessed bit. For such sources,
the default toptier node to which such pages should be promoted
is hard coded.

Also, the access time provided some sources may at best be
considered approximate. This is especially true for hot pages
detected by PTE A bit scanning.

The hotness information is stored for every page of lower
tier memory in an unsigned long variable that is part of
mem_section data structure.

kmigrated is a per-lowertier-node kernel thread that migrates
the folios marked for migration in batches. Each kmigrated
thread walks the PFN range spanning its node and checks
for potential migration candidates.

Signed-off-by: Bharata B Rao <bharata@amd.com>
---
 include/linux/mmzone.h        |  14 ++
 include/linux/pghot.h         |  52 ++++
 include/linux/vm_event_item.h |   4 +
 mm/Kconfig                    |  11 +
 mm/Makefile                   |   1 +
 mm/mm_init.c                  |  10 +
 mm/page_ext.c                 |  11 +
 mm/pghot.c                    | 446 ++++++++++++++++++++++++++++++++++
 mm/vmstat.c                   |   4 +
 9 files changed, 553 insertions(+)
 create mode 100644 include/linux/pghot.h
 create mode 100644 mm/pghot.c

diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index 7fb7331c5725..fde851990394 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -1068,6 +1068,7 @@ enum pgdat_flags {
 					 * many pages under writeback
 					 */
 	PGDAT_RECLAIM_LOCKED,		/* prevents concurrent reclaim */
+	PGDAT_KMIGRATED_ACTIVATE,	/* activates kmigrated */
 };
 
 enum zone_flags {
@@ -1522,6 +1523,10 @@ typedef struct pglist_data {
 #ifdef CONFIG_MEMORY_FAILURE
 	struct memory_failure_stats mf_stats;
 #endif
+#ifdef CONFIG_PGHOT
+	struct task_struct *kmigrated;
+	wait_queue_head_t kmigrated_wait;
+#endif
 } pg_data_t;
 
 #define node_present_pages(nid)	(NODE_DATA(nid)->node_present_pages)
@@ -1920,12 +1925,21 @@ struct mem_section {
 	unsigned long section_mem_map;
 
 	struct mem_section_usage *usage;
+#ifdef CONFIG_PGHOT
+	/*
+	 * Per-PFN hotness data for this section.
+	 */
+	unsigned long *hot_map;
+#endif
 #ifdef CONFIG_PAGE_EXTENSION
 	/*
 	 * If SPARSEMEM, pgdat doesn't have page_ext pointer. We use
 	 * section. (see page_ext.h about this.)
 	 */
 	struct page_ext *page_ext;
+#endif
+#if (defined(CONFIG_PGHOT) && !defined(CONFIG_PAGE_EXTENSION)) || \
+		(!defined(CONFIG_PGHOT) && defined(CONFIG_PAGE_EXTENSION))
 	unsigned long pad;
 #endif
 	/*
diff --git a/include/linux/pghot.h b/include/linux/pghot.h
new file mode 100644
index 000000000000..7238ddf18a35
--- /dev/null
+++ b/include/linux/pghot.h
@@ -0,0 +1,52 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _LINUX_PGHOT_H
+#define _LINUX_PGHOT_H
+
+/* Page hotness temperature sources */
+enum pghot_src {
+	PGHOT_HW_HINTS,
+	PGHOT_PGTABLE_SCAN,
+	PGHOT_HINT_FAULT,
+};
+
+#ifdef CONFIG_PGHOT
+#define PGHOT_FREQ_WINDOW	(5 * MSEC_PER_SEC)
+#define PGHOT_FREQ_THRESHOLD	2
+
+#define KMIGRATE_DELAY_MS	100
+#define KMIGRATE_BATCH		512
+
+#define PGHOT_DEFAULT_NODE	0
+
+/*
+ * Bits 0-31 are used to store nid, frequency and time.
+ * Bits 32-62 are unused now.
+ * Bit 63 is used to indicate the page is ready for migration.
+ */
+#define PGHOT_MIGRATE_READY	63
+
+#define PGHOT_NID_WIDTH		10
+#define PGHOT_FREQ_WIDTH	3
+/* time is stored in 19 bits which can represent up to 8.73s with HZ=1000 */
+#define PGHOT_TIME_WIDTH	19
+
+#define PGHOT_NID_SHIFT		0
+#define PGHOT_FREQ_SHIFT	(PGHOT_NID_SHIFT + PGHOT_NID_WIDTH)
+#define PGHOT_TIME_SHIFT	(PGHOT_FREQ_SHIFT + PGHOT_FREQ_WIDTH)
+
+#define PGHOT_NID_MASK		((1UL << PGHOT_NID_SHIFT) - 1)
+#define PGHOT_FREQ_MASK		((1UL << PGHOT_FREQ_SHIFT) - 1)
+#define PGHOT_TIME_MASK		((1UL << PGHOT_TIME_SHIFT) - 1)
+
+#define PGHOT_NID_MAX		(1 << PGHOT_NID_WIDTH)
+#define PGHOT_FREQ_MAX		(1 << PGHOT_FREQ_WIDTH)
+#define PGHOT_TIME_MAX		(1 << PGHOT_TIME_WIDTH)
+
+int pghot_record_access(unsigned long pfn, int nid, int src, unsigned long now);
+#else
+static inline int pghot_record_access(unsigned long pfn, int nid, int src, unsigned long now)
+{
+	return 0;
+}
+#endif /* CONFIG_PGHOT */
+#endif /* _LINUX_PGHOT_H */
diff --git a/include/linux/vm_event_item.h b/include/linux/vm_event_item.h
index 92f80b4d69a6..4731d667231d 100644
--- a/include/linux/vm_event_item.h
+++ b/include/linux/vm_event_item.h
@@ -188,6 +188,10 @@ enum vm_event_item { PGPGIN, PGPGOUT, PSWPIN, PSWPOUT,
 		KSTACK_REST,
 #endif
 #endif /* CONFIG_DEBUG_STACK_USAGE */
+		PGHOT_RECORDED_ACCESSES,
+		PGHOT_RECORD_HWHINTS,
+		PGHOT_RECORD_PGTSCANS,
+		PGHOT_RECORD_HINTFAULTS,
 		NR_VM_EVENT_ITEMS
 };
 
diff --git a/mm/Kconfig b/mm/Kconfig
index 0e26f4fc8717..b5e84cb50253 100644
--- a/mm/Kconfig
+++ b/mm/Kconfig
@@ -1372,6 +1372,17 @@ config PT_RECLAIM
 config FIND_NORMAL_PAGE
 	def_bool n
 
+config PGHOT
+	bool "Hot page tracking and promotion"
+	def_bool y
+	depends on NUMA && MIGRATION && SPARSEMEM && MMU
+	help
+	  A sub-system to track page accesses in lower tier memory and
+	  maintain hot page information. Promotes hot pages from lower
+	  tiers to top tier by using the memory access information provided
+	  by various sources. Asynchronous promotion is done by per-node
+	  kernel threads.
+
 source "mm/damon/Kconfig"
 
 endmenu
diff --git a/mm/Makefile b/mm/Makefile
index 21abb3353550..a6fac171c36e 100644
--- a/mm/Makefile
+++ b/mm/Makefile
@@ -146,3 +146,4 @@ obj-$(CONFIG_SHRINKER_DEBUG) += shrinker_debug.o
 obj-$(CONFIG_EXECMEM) += execmem.o
 obj-$(CONFIG_TMPFS_QUOTA) += shmem_quota.o
 obj-$(CONFIG_PT_RECLAIM) += pt_reclaim.o
+obj-$(CONFIG_PGHOT) += pghot.o
diff --git a/mm/mm_init.c b/mm/mm_init.c
index 3db2dea7db4c..2c0199f7691b 100644
--- a/mm/mm_init.c
+++ b/mm/mm_init.c
@@ -1401,6 +1401,15 @@ static void pgdat_init_kcompactd(struct pglist_data *pgdat)
 static void pgdat_init_kcompactd(struct pglist_data *pgdat) {}
 #endif
 
+#ifdef CONFIG_PGHOT
+static void pgdat_init_kmigrated(struct pglist_data *pgdat)
+{
+	init_waitqueue_head(&pgdat->kmigrated_wait);
+}
+#else
+static inline void pgdat_init_kmigrated(struct pglist_data *pgdat) {}
+#endif
+
 static void __meminit pgdat_init_internals(struct pglist_data *pgdat)
 {
 	int i;
@@ -1410,6 +1419,7 @@ static void __meminit pgdat_init_internals(struct pglist_data *pgdat)
 
 	pgdat_init_split_queue(pgdat);
 	pgdat_init_kcompactd(pgdat);
+	pgdat_init_kmigrated(pgdat);
 
 	init_waitqueue_head(&pgdat->kswapd_wait);
 	init_waitqueue_head(&pgdat->pfmemalloc_wait);
diff --git a/mm/page_ext.c b/mm/page_ext.c
index d7396a8970e5..a32d43755306 100644
--- a/mm/page_ext.c
+++ b/mm/page_ext.c
@@ -76,6 +76,16 @@ static struct page_ext_operations page_idle_ops __initdata = {
 };
 #endif
 
+static bool need_page_mig(void)
+{
+	return true;
+}
+
+static struct page_ext_operations page_mig_ops __initdata = {
+	.need = need_page_mig,
+	.need_shared_flags = true,
+};
+
 static struct page_ext_operations *page_ext_ops[] __initdata = {
 #ifdef CONFIG_PAGE_OWNER
 	&page_owner_ops,
@@ -89,6 +99,7 @@ static struct page_ext_operations *page_ext_ops[] __initdata = {
 #ifdef CONFIG_PAGE_TABLE_CHECK
 	&page_table_check_ops,
 #endif
+	&page_mig_ops,
 };
 
 unsigned long page_ext_size;
diff --git a/mm/pghot.c b/mm/pghot.c
new file mode 100644
index 000000000000..7c1a32f8a7ba
--- /dev/null
+++ b/mm/pghot.c
@@ -0,0 +1,446 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Maintains information about hot pages from slower tier nodes and
+ * promotes them.
+ *
+ * Per-PFN hotness information is stored for lower tier nodes in
+ * mem_section. An unsigned long variable is used to store the
+ * frequency of access, last access time and the nid to which the
+ * page needs to be migrated.
+ *
+ * A kernel thread named kmigrated is provided to migrate or promote
+ * the hot pages. kmigrated runs for each lower tier node. It iterates
+ * over the node's PFNs and  migrates pages marked for migration into
+ * their targeted nodes.
+ */
+#include <linux/mm.h>
+#include <linux/migrate.h>
+#include <linux/memory-tiers.h>
+#include <linux/cpuhotplug.h>
+#include <linux/pghot.h>
+
+static unsigned int sysctl_pghot_freq_window = PGHOT_FREQ_WINDOW;
+
+/*
+ * Sysctl tunables to selectively enable access recording from different
+ * sources.
+ */
+static unsigned int sysctl_pghot_record_hwhints_enable;
+static unsigned int sysctl_pghot_record_pgtscans_enable;
+static unsigned int sysctl_pghot_record_hintfaults_enable;
+
+static DEFINE_STATIC_KEY_FALSE(pghot_record_hwhints);
+static DEFINE_STATIC_KEY_FALSE(pghot_record_pgtscans);
+static DEFINE_STATIC_KEY_FALSE(pghot_record_hintfaults);
+
+#ifdef CONFIG_SYSCTL
+static int sysctl_record_enable_handler(const struct ctl_table *table, int write,
+					void *buffer, size_t *lenp, loff_t *ppos)
+{
+	int err, val;
+
+	err = proc_dointvec_minmax(table, write, buffer, lenp, ppos);
+	if (err || !write)
+		return err;
+
+	val = *(int *)table->data;
+
+	if (table->data == &sysctl_pghot_record_hwhints_enable) {
+		if (val)
+			static_branch_enable(&pghot_record_hwhints);
+		else
+			static_branch_disable(&pghot_record_hwhints);
+	} else if (table->data == &sysctl_pghot_record_pgtscans_enable) {
+		if (val)
+			static_branch_enable(&pghot_record_pgtscans);
+		else
+			static_branch_disable(&pghot_record_pgtscans);
+	} else if (table->data == &sysctl_pghot_record_hintfaults_enable) {
+		if (val)
+			static_branch_enable(&pghot_record_hintfaults);
+		else
+			static_branch_disable(&pghot_record_hintfaults);
+	}
+	return 0;
+}
+
+static const struct ctl_table pghot_sysctls[] = {
+	{
+		.procname       = "pghot_record_hwhints_enable",
+		.data           = &sysctl_pghot_record_hwhints_enable,
+		.maxlen         = sizeof(unsigned int),
+		.mode           = 0644,
+		.proc_handler   = sysctl_record_enable_handler,
+		.extra1         = SYSCTL_ZERO,
+		.extra2         = SYSCTL_ONE,
+	},
+	{
+		.procname       = "pghot_record_pgtscans_enable",
+		.data           = &sysctl_pghot_record_pgtscans_enable,
+		.maxlen         = sizeof(unsigned int),
+		.mode           = 0644,
+		.proc_handler   = sysctl_record_enable_handler,
+		.extra1         = SYSCTL_ZERO,
+		.extra2         = SYSCTL_ONE,
+	},
+	{
+		.procname       = "pghot_record_hintfaults_enable",
+		.data           = &sysctl_pghot_record_hintfaults_enable,
+		.maxlen         = sizeof(unsigned int),
+		.mode           = 0644,
+		.proc_handler   = sysctl_record_enable_handler,
+		.extra1         = SYSCTL_ZERO,
+		.extra2         = SYSCTL_ONE,
+	},
+	{
+		.procname       = "pghot_promote_freq_window_ms",
+		.data           = &sysctl_pghot_freq_window,
+		.maxlen         = sizeof(unsigned int),
+		.mode           = 0644,
+		.proc_handler   = proc_dointvec_minmax,
+		.extra1         = SYSCTL_ZERO,
+	},
+};
+#endif
+
+static bool kmigrated_started __ro_after_init;
+
+/**
+ *
+ * pghot_record_access - Record page accesses from lower tier memory
+ * for the purpose of tracking page hotness and subsequent promotion.
+ *
+ * @pfn - PFN of the page
+ * @nid - Target NID to were the page needs to be migrated
+ * @src - The identifier of the sub-system that reports the access
+ * @now - Access time in jiffies
+ *
+ * Updates the NID, frequency and time of access and marks the page as
+ * ready for migration if the frequency crosses a threshold. The pages
+ * marked for migration are migrated by kmigrated kernel thread.
+ *
+ * Return: 0 on success and -EAGAIN on failure to record the access.
+ */
+int pghot_record_access(unsigned long pfn, int nid, int src, unsigned long now)
+{
+	unsigned long time = now & PGHOT_TIME_MASK;
+	unsigned long old_nid, old_freq, old_time;
+	unsigned long *phi, old_hotness, hotness;
+	bool new_window = false;
+	struct mem_section *ms;
+	struct folio *folio;
+	struct page *page;
+	unsigned long freq;
+
+	if (!kmigrated_started)
+		return -EINVAL;
+
+	if (nid >= PGHOT_NID_MAX)
+		return -EINVAL;
+
+	count_vm_event(PGHOT_RECORDED_ACCESSES);
+	switch (src) {
+	case PGHOT_HW_HINTS:
+		if (!static_branch_likely(&pghot_record_hwhints))
+			return -EINVAL;
+		count_vm_event(PGHOT_RECORD_HWHINTS);
+		break;
+	case PGHOT_PGTABLE_SCAN:
+		if (!static_branch_likely(&pghot_record_pgtscans))
+			return -EINVAL;
+		count_vm_event(PGHOT_RECORD_PGTSCANS);
+		break;
+	case PGHOT_HINT_FAULT:
+		if (!static_branch_likely(&pghot_record_hintfaults))
+			return -EINVAL;
+		count_vm_event(PGHOT_RECORD_HINTFAULTS);
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	/*
+	 * Record only accesses from lower tiers.
+	 */
+	if (node_is_toptier(pfn_to_nid(pfn)))
+		return 0;
+
+	/*
+	 * Reject the non-migratable pages right away.
+	 */
+	page = pfn_to_online_page(pfn);
+	if (!page || is_zone_device_page(page))
+		return 0;
+
+	folio = page_folio(page);
+	if (!folio_test_lru(folio))
+		return 0;
+
+	/* Get the hotness slot corresponding to the 1st PFN of the folio */
+	pfn = folio_pfn(folio);
+	ms = __pfn_to_section(pfn);
+	if (!ms)
+		return -EINVAL;
+	phi = &ms->hot_map[pfn % PAGES_PER_SECTION];
+
+	/*
+	 * Update the hotness parameters.
+	 */
+	old_hotness = READ_ONCE(*phi);
+	do {
+		hotness = old_hotness;
+		old_nid = (hotness >> PGHOT_NID_SHIFT) & PGHOT_NID_MASK;
+		old_freq = (hotness >> PGHOT_FREQ_SHIFT) & PGHOT_FREQ_MASK;
+		old_time = (hotness >> PGHOT_TIME_SHIFT) & PGHOT_TIME_MASK;
+
+		if (((time - old_time) > msecs_to_jiffies(sysctl_pghot_freq_window))
+		    || (nid != NUMA_NO_NODE && old_nid != nid))
+			new_window = true;
+
+		if (new_window)
+			freq = 1;
+		else if (old_freq < PGHOT_FREQ_MAX)
+			freq = old_freq + 1;
+		nid = (nid == NUMA_NO_NODE) ? PGHOT_DEFAULT_NODE : nid;
+
+		hotness &= ~(PGHOT_NID_MASK << PGHOT_NID_SHIFT);
+		hotness &= ~(PGHOT_FREQ_MASK << PGHOT_FREQ_SHIFT);
+		hotness &= ~(PGHOT_TIME_MASK << PGHOT_TIME_SHIFT);
+
+		hotness |= (nid & PGHOT_NID_MASK) << PGHOT_NID_SHIFT;
+		hotness |= (freq & PGHOT_FREQ_MASK) << PGHOT_FREQ_SHIFT;
+		hotness |= (time & PGHOT_TIME_MASK) << PGHOT_TIME_SHIFT;
+
+		if (freq > PGHOT_FREQ_THRESHOLD)
+			set_bit(PGHOT_MIGRATE_READY, &hotness);
+	} while (unlikely(!try_cmpxchg(phi, &old_hotness, hotness)));
+
+	if (test_bit(PGHOT_MIGRATE_READY, &hotness))
+		set_bit(PGDAT_KMIGRATED_ACTIVATE, &page_pgdat(page)->flags);
+	return 0;
+}
+
+static int pghot_get_hotness(unsigned long pfn, unsigned long *nid, unsigned long *freq,
+				    unsigned long *time)
+{
+	unsigned long *phi, old_hotness, hotness;
+	struct mem_section *ms;
+
+	ms = __pfn_to_section(pfn);
+	if (!ms)
+		return -EINVAL;
+
+	phi = &ms->hot_map[pfn % PAGES_PER_SECTION];
+	if (!test_and_clear_bit(PGHOT_MIGRATE_READY, phi))
+		return -EINVAL;
+
+	old_hotness = READ_ONCE(*phi);
+	do {
+		hotness = old_hotness;
+		*nid = (hotness >> PGHOT_NID_SHIFT) & PGHOT_NID_MASK;
+		*freq = (hotness >> PGHOT_FREQ_SHIFT) & PGHOT_FREQ_MASK;
+		*time = (hotness >> PGHOT_TIME_SHIFT) & PGHOT_TIME_MASK;
+		hotness = 0;
+
+	} while (unlikely(!try_cmpxchg(phi, &old_hotness, hotness)));
+	return 0;
+}
+
+/*
+ * Walks the PFNs of the zone, isolates and migrates them in batches.
+ */
+static void kmigrated_walk_zone(unsigned long start_pfn, unsigned long end_pfn,
+				int src_nid)
+{
+	int cur_nid = NUMA_NO_NODE;
+	LIST_HEAD(migrate_list);
+	int batch_count = 0;
+	struct folio *folio;
+	struct page *page;
+	unsigned long pfn;
+
+	pfn = start_pfn;
+	do {
+		unsigned long nid = NUMA_NO_NODE, freq = 0, time = 0, nr = 1;
+
+		if (!pfn_valid(pfn))
+			goto out_next;
+
+		page = pfn_to_online_page(pfn);
+		if (!page)
+			goto out_next;
+
+		folio = page_folio(page);
+		nr = folio_nr_pages(folio);
+		if (folio_nid(folio) != src_nid)
+			goto out_next;
+
+		if (!folio_test_lru(folio))
+			goto out_next;
+
+		if (pghot_get_hotness(pfn, &nid, &freq, &time))
+			goto out_next;
+
+		if (nid == NUMA_NO_NODE)
+			goto out_next;
+
+		if (folio_nid(folio) == nid)
+			goto out_next;
+
+		if (migrate_misplaced_folio_prepare(folio, NULL, nid))
+			goto out_next;
+
+		if (cur_nid != NUMA_NO_NODE)
+			cur_nid = nid;
+
+		if (++batch_count >= KMIGRATE_BATCH || cur_nid != nid) {
+			migrate_misplaced_folios_batch(&migrate_list, cur_nid);
+			cur_nid = nid;
+			batch_count = 0;
+			cond_resched();
+		}
+		list_add(&folio->lru, &migrate_list);
+out_next:
+		pfn += nr;
+	} while (pfn < end_pfn);
+	if (!list_empty(&migrate_list))
+		migrate_misplaced_folios_batch(&migrate_list, cur_nid);
+}
+
+static void kmigrated_do_work(pg_data_t *pgdat)
+{
+	struct zone *zone;
+	int zone_idx;
+
+	clear_bit(PGDAT_KMIGRATED_ACTIVATE, &pgdat->flags);
+	for (zone_idx = 0; zone_idx < MAX_NR_ZONES; zone_idx++) {
+		zone = &pgdat->node_zones[zone_idx];
+
+		if (!populated_zone(zone))
+			continue;
+
+		if (zone_is_zone_device(zone))
+			continue;
+
+		kmigrated_walk_zone(zone->zone_start_pfn, zone_end_pfn(zone),
+				    pgdat->node_id);
+	}
+}
+
+static inline bool kmigrated_work_requested(pg_data_t *pgdat)
+{
+	return test_bit(PGDAT_KMIGRATED_ACTIVATE, &pgdat->flags);
+}
+
+/*
+ * Per-node kthread that iterates over its PFNs and migrates the
+ * pages that have been marked for migration.
+ */
+static int kmigrated(void *p)
+{
+	long timeout = msecs_to_jiffies(KMIGRATE_DELAY_MS);
+	pg_data_t *pgdat = p;
+
+	while (!kthread_should_stop()) {
+		if (wait_event_timeout(pgdat->kmigrated_wait, kmigrated_work_requested(pgdat),
+				       timeout))
+			kmigrated_do_work(pgdat);
+	}
+	return 0;
+}
+
+static int kmigrated_run(int nid)
+{
+	pg_data_t *pgdat = NODE_DATA(nid);
+	int ret;
+
+	if (node_is_toptier(nid))
+		return 0;
+
+	if (!pgdat->kmigrated) {
+		pgdat->kmigrated = kthread_create_on_node(kmigrated, pgdat, nid,
+							  "kmigrated%d", nid);
+		if (IS_ERR(pgdat->kmigrated)) {
+			ret = PTR_ERR(pgdat->kmigrated);
+			pgdat->kmigrated = NULL;
+			pr_err("Failed to start kmigrated%d, ret %d\n", nid, ret);
+			return ret;
+		}
+		pr_info("pghot: Started kmigrated thread for node %d\n", nid);
+	}
+	wake_up_process(pgdat->kmigrated);
+	return 0;
+}
+
+static void pghot_free_hot_map(void)
+{
+	unsigned long section_nr, s_begin;
+	struct mem_section *ms;
+
+	/* s_begin = first_present_section_nr(); */
+	s_begin = next_present_section_nr(-1);
+	for_each_present_section_nr(s_begin, section_nr) {
+		ms = __nr_to_section(section_nr);
+		kfree(ms->hot_map);
+	}
+}
+
+static int pghot_alloc_hot_map(void)
+{
+	unsigned long section_nr, s_begin, start_pfn;
+	struct mem_section *ms;
+	int nid;
+
+	/* s_begin = first_present_section_nr(); */
+	s_begin = next_present_section_nr(-1);
+	for_each_present_section_nr(s_begin, section_nr) {
+		ms = __nr_to_section(section_nr);
+		start_pfn = section_nr_to_pfn(section_nr);
+		nid = pfn_to_nid(start_pfn);
+
+		if (node_is_toptier(nid) || !pfn_valid(start_pfn))
+			continue;
+
+		ms->hot_map = kcalloc_node(PAGES_PER_SECTION, sizeof(*ms->hot_map), GFP_KERNEL,
+					   nid);
+		if (!ms->hot_map)
+			goto out_free_hot_map;
+	}
+	return 0;
+
+out_free_hot_map:
+	pghot_free_hot_map();
+	return -ENOMEM;
+}
+
+static int __init pghot_init(void)
+{
+	pg_data_t *pgdat;
+	int nid, ret;
+
+	ret = pghot_alloc_hot_map();
+	if (ret)
+		return ret;
+
+	for_each_node_state(nid, N_MEMORY) {
+		ret = kmigrated_run(nid);
+		if (ret)
+			goto out_stop_kthread;
+	}
+	register_sysctl_init("vm", pghot_sysctls);
+	kmigrated_started = true;
+	return 0;
+
+out_stop_kthread:
+	for_each_node_state(nid, N_MEMORY) {
+		pgdat = NODE_DATA(nid);
+		if (pgdat->kmigrated) {
+			kthread_stop(pgdat->kmigrated);
+			pgdat->kmigrated = NULL;
+		}
+	}
+	pghot_free_hot_map();
+	return ret;
+}
+
+late_initcall_sync(pghot_init)
diff --git a/mm/vmstat.c b/mm/vmstat.c
index bb09c032eecf..49d974f8e8b3 100644
--- a/mm/vmstat.c
+++ b/mm/vmstat.c
@@ -1496,6 +1496,10 @@ const char * const vmstat_text[] = {
 	[I(KSTACK_REST)]			= "kstack_rest",
 #endif
 #endif
+	[I(PGHOT_RECORDED_ACCESSES)]            = "pghot_recorded_accesses",
+	[I(PGHOT_RECORD_HWHINTS)]               = "pghot_recorded_hwhints",
+	[I(PGHOT_RECORD_PGTSCANS)]              = "pghot_recorded_pgtscans",
+	[I(PGHOT_RECORD_HINTFAULTS)]            = "pghot_recorded_hintfaults",
 #undef I
 #endif /* CONFIG_VM_EVENT_COUNTERS */
 };
-- 
2.34.1


