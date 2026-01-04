Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 447CEC2A06C
	for <linux-mm@archiver.kernel.org>; Sun,  4 Jan 2026 07:22:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0FEC26B008A; Sun,  4 Jan 2026 02:22:24 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0B3C56B0092; Sun,  4 Jan 2026 02:22:24 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EC1D66B0093; Sun,  4 Jan 2026 02:22:23 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id DB4716B008A
	for <linux-mm@kvack.org>; Sun,  4 Jan 2026 02:22:23 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 4A1278B4B6
	for <linux-mm@kvack.org>; Sun,  4 Jan 2026 07:22:23 +0000 (UTC)
X-FDA: 84293438166.05.9066D3D
Received: from CY7PR03CU001.outbound.protection.outlook.com (mail-westcentralusazon11010059.outbound.protection.outlook.com [40.93.198.59])
	by imf24.hostedemail.com (Postfix) with ESMTP id 58B86180003
	for <linux-mm@kvack.org>; Sun,  4 Jan 2026 07:22:20 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=Q2p7KnH2;
	spf=pass (imf24.hostedemail.com: domain of Honglei1.Huang@amd.com designates 40.93.198.59 as permitted sender) smtp.mailfrom=Honglei1.Huang@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1767511340; a=rsa-sha256;
	cv=pass;
	b=3VTD+TFvhuMaLBy88fetCMMZ/HvKyugFUB32+dtvOfN1Ys4rU32S+YYcBpBa0OwLECGSu4
	z07koNpfoWZs1RA1BUxAIkOLHysp1xK9TrFQayoum+0N4FHj10J9K+f6d23Uv+JNpPT/WZ
	tHcrDI1jJ4nWTMC20QaTJ1cxxe13xyA=
ARC-Authentication-Results: i=2;
	imf24.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=Q2p7KnH2;
	spf=pass (imf24.hostedemail.com: domain of Honglei1.Huang@amd.com designates 40.93.198.59 as permitted sender) smtp.mailfrom=Honglei1.Huang@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767511340;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=8M3QqARMEL1WjeYOmNLK2B8sXEdgGqFrC69ulfHJngE=;
	b=mw9SSsWrnkb1MymWiwyvPb8yQC4vuClFMCj+yo8dZJZxGBEVRFXChWAbi+8wBHzs/ON1KV
	uQHZuLno9ZaqzP6D8XGZd+hYfz5IPfWKW/N/W+YwqV9m53mI43GaxKKxnUGwDxhL/g7XaX
	emCbRZf/FSZ39P/S0beO4RAgiUsI+dY=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=SNI1WynM5pbGX8sRDhSdoZZ5MI4yPHO8lcQH+RLRMl5ZgW0th2duHcXPBMP3iB8mKOluxKUQLidx8M+7nFjDLAs1RORveRKEXPuesOSEfi/6dnEuPywJ5h8L5Cv97dnr4RDOLC7CVJF/PPWnIWbjtpa2xT2b3vqsMxVh5ixsoLBk3YePGQsYzZUco2ZwYthhN6QMDM7afjmyQJ/POhM10xs6D9TyLRaWGuEli8JUUBmW2teHkr7cRPCuWmPRXuZn0O9i/fH02tb/brCMTmTpAzYYdMxdgOMfiDd7IyJy/v1AczO1NMJRNgbXMn5OD4AD1B8IZBwO+2J8QcvNpmYvew==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8M3QqARMEL1WjeYOmNLK2B8sXEdgGqFrC69ulfHJngE=;
 b=ClkVFpFuqBmmKNqLvwHM/Z8IiTkSdWPZgvbVfYfSoutHVvJa2d2Zt8nDSg0LII69kJPtCmw0+4Yus00cusBBX4D9uwDpYQ5KdVSBFiuR7gXGA2yLt62qd4M7IaYJTfMzuyG/u+Q1019W6vyNAkx7pMBtAYxwW3hcQa5a8NuoJq9VVg5Znc4NRtu63ZE9m3fAmDd2JMVxdjH/zyd/1siQufsUTCOcRsL47bbHuw7NMgpW4ccz2xfEpi5syO8QjuLLD3qVh3ljBCKidHqmHPH9vh3xYIY6LYQGqkXYGQrOFl95VVeZ8Gm6/gOKGG04e/ihfmDg2Xe14HRro+8raA/hwQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=collabora.com smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8M3QqARMEL1WjeYOmNLK2B8sXEdgGqFrC69ulfHJngE=;
 b=Q2p7KnH2UbcdcgWTV50MNQusWOuxp2OmxCGnY6uLFRcqHSaVYL4w1RiXlRFMnhVNHgyGnPi3FeldLwLXJxtTADUhBp+lfuc05vJdAq0TeXyHIYJIvUnPT//rXMhK0dvZ6MnUCUyGuiKHAr3CsjI4bzyeESu00hHzUVf/85mFqK0=
Received: from MN0P220CA0012.NAMP220.PROD.OUTLOOK.COM (2603:10b6:208:52e::35)
 by CH1PPFDA34A4201.namprd12.prod.outlook.com (2603:10b6:61f:fc00::625) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9478.4; Sun, 4 Jan
 2026 07:22:12 +0000
Received: from BN3PEPF0000B371.namprd21.prod.outlook.com
 (2603:10b6:208:52e:cafe::f1) by MN0P220CA0012.outlook.office365.com
 (2603:10b6:208:52e::35) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9478.4 via Frontend Transport; Sun, 4
 Jan 2026 07:22:04 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 BN3PEPF0000B371.mail.protection.outlook.com (10.167.243.168) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9520.0 via Frontend Transport; Sun, 4 Jan 2026 07:22:12 +0000
Received: from honglei-remote.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Sun, 4 Jan
 2026 01:22:08 -0600
From: Honglei Huang <honglei1.huang@amd.com>
To: <Felix.Kuehling@amd.com>, <alexander.deucher@amd.com>,
	<christian.koenig@amd.com>, <Ray.Huang@amd.com>
CC: <dmitry.osipenko@collabora.com>, <Xinhui.Pan@amd.com>,
	<airlied@gmail.com>, <daniel@ffwll.ch>, <amd-gfx@lists.freedesktop.org>,
	<dri-devel@lists.freedesktop.org>, <linux-kernel@vger.kernel.org>,
	<linux-mm@kvack.org>, <akpm@linux-foundation.org>, <honghuan@amd.com>
Subject: [PATCH v2 0/4] drm/amdkfd: Add batch userptr allocation support
Date: Sun, 4 Jan 2026 15:21:18 +0800
Message-ID: <20260104072122.3045656-1-honglei1.huang@amd.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: satlexmb07.amd.com (10.181.42.216) To satlexmb07.amd.com
 (10.181.42.216)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN3PEPF0000B371:EE_|CH1PPFDA34A4201:EE_
X-MS-Office365-Filtering-Correlation-Id: 50b42585-6303-4ad7-91fb-08de4b61faa8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|1800799024|82310400026|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?hQtd5nMp7v7bzVnid4ZS11fPNpH2iydBQ1wQ2POfMzhJ5fZxOcsO0SvzYZ+J?=
 =?us-ascii?Q?jov7sEUozqfHva0vLSbjUHF7MWDplkHQp00g6wdaLZU2G9fRAmSEVnPPmAgs?=
 =?us-ascii?Q?8t0LMmc/sH0lDkls50Vd8MuITi5sXz/X4h8BWUrQ4Krtwo/wYZWPoZCtxIxd?=
 =?us-ascii?Q?nMZJq+AJvw0+U+WtRvPQgJvwLOx8b9xpBJfxgpW/Pv81Wt2W21K3KegxByH4?=
 =?us-ascii?Q?tbm8I+eCbvvGfMSJFn0xhuM+w1MQyi80rjBKsdKzo/RU6DJ7/DinRj3kRd8Q?=
 =?us-ascii?Q?T6InR+dwpWKW5nFyg0tdLGNiKM4N8VKq72i2cX9K/Y3teW3OlqTGWXW5jq3k?=
 =?us-ascii?Q?id/YqEjiTQgpYo0Kn7ilHZUpyFw4aby0guuwKxXiJZGW8RxMhhBQLxdu5IRh?=
 =?us-ascii?Q?POVA58NJsTgs3TZcHz8qkQOzHSvuFdSb6Ko2ZLLFmfNcT0AYtURnAe2rK9bB?=
 =?us-ascii?Q?Q+B5WXc11UEM2lGinFwx6iJA+p+cVchaqAesFc3Jmq+sb3clQrb4ZMVvIrKr?=
 =?us-ascii?Q?7YnavpJaZGEdSKgtOQ2h+iHCHMsIoyNPd5RYGY5ZdbQXyt9t8obnfttfGDQ/?=
 =?us-ascii?Q?rFxRF9yYur8V3vp0HP2zAR8E2BxzSH8mzWnOQNaZ5g6ft7lHgGObQ4wHkrU8?=
 =?us-ascii?Q?ldmOvaYJfQcPcK3k6OX2MCBazystQ1Q26zVPyFp3CucjKVeYhFvcL7Q0/6XS?=
 =?us-ascii?Q?WuaeR4P9CJjCqvDiLlMk59+rhkoiq3HHuiFCpo2mGaS+YSSLGYgTypNz7rV8?=
 =?us-ascii?Q?QjZl2YniVmHMFBZmIiKj5p7S29X4kykxZ1/E3b6g8vntWwuPwJqAOVipahTA?=
 =?us-ascii?Q?AG4fCDCezLSUP8Qfvc2qY8uGPM1O3W9MdICq3vP5WEdLwV1u4uUCYM9DhZei?=
 =?us-ascii?Q?QdWr/AEDjI7dBa7ucd94JeoajhOB2BQOARwcSkpiQ/VuFWIY+4QxtbRL15XP?=
 =?us-ascii?Q?sAz5nwIz8MTdaTj43XPRDupugQG1KmBxf+xKjk/4HDsIelKo0aayzLwqywpT?=
 =?us-ascii?Q?2/Uu8SkzkcPy/p/otooSX5ZmF1H1lcrjIXtBmxXGXwkVrjME5HQn5kEYRuSw?=
 =?us-ascii?Q?WW7CR3xJv0R/K335KUevYcEnOZ9qWC+6JfoppTBqjwtLSfFlsD2mJVrGSBX7?=
 =?us-ascii?Q?x7e1J7UW+3BdKSfMHGdMpUdFHGfuZAN9GxukxwnFwOmehqqD9gcIuCh5fgH5?=
 =?us-ascii?Q?eJCp1EVyoJjEp/3TH//mx6eaQ21TRm23HtF+RwbjdBg0ihj9b46ZVK+5YirG?=
 =?us-ascii?Q?GzEkML45iORIWcSZzYyJdpK25/cj06kpBIzA+JP3Js2fDiLUdviH6X5I1tgN?=
 =?us-ascii?Q?Y0gi/p8LgF3YiLFijWOVEJjLoWKBWbHvBo1ovbT4S1h5INast2BNi1LUOIPP?=
 =?us-ascii?Q?sEYwYovYn8gLDARQBVv7YlA2AhZo543naKoD1Z+laaGbnCjw7zkJ3yzBV02I?=
 =?us-ascii?Q?3rYPALzuXnX2Rh/jmmrIg0C2VISM3A0WFjAMlT0/3Ym6x2blvv9EOLCqxLNA?=
 =?us-ascii?Q?+prMa3QNCa4KHtvcOUPY0PE9mhXW/j02Pba4SWHqOOPBcvHfgR2KIlW/aNCq?=
 =?us-ascii?Q?GpTRLfm5Pj2CvdIKgDe7RBS41fgDmsTec16jD0xx?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(1800799024)(82310400026)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Jan 2026 07:22:12.2020
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 50b42585-6303-4ad7-91fb-08de4b61faa8
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN3PEPF0000B371.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH1PPFDA34A4201
X-Rspam-User: 
X-Rspamd-Queue-Id: 58B86180003
X-Rspamd-Server: rspam04
X-Stat-Signature: 7krcubhjw1caik37tyo8ffs7hwqm3cpr
X-HE-Tag: 1767511340-226430
X-HE-Meta: U2FsdGVkX192ieBZp65ZQrXdiTFwkfGBAOH5maSGBLo5wZf0TERP1m5BYeO431hdy6U9PCZoZ7Xte/ELsvtjzp2AbBtczBIk92nuphGet2ocQHDsz1bSDnPkLicO/5QJRbk9HKwSz5fQ85eH+TkdTaN8wxleFujoqnXwPuLoIAyQzU7BPOv0wpD/U66GRRdWh8rWoP0vVG06XNptNvPZK7iPdAQWkd+zV2pmwwFajtKYtFDtZrbTQJeAeuWns8wEF925pqHTbvX5WMW9/CE/sJF6hHfHZRS4ouXUXwCiXTGMVW2WHkrkQMVj/nqgR8zdgj0FyKuFDG7BcAz22qrhRcNV6rXHxwmjRVIo3ZfDseB3ZcXCanCWgSuG+oBIBJdvBtJPXcm/PXDIQ94krRhSvs39uwP2ppXdfUJ28MFdVivVF6K4AvnZ0HhgyIyTijN2mOyY1NaRklQJH+1V0WK0pVzQJw2u2+Zii/Zo2z95DyeVeC1rqm/wFmLxX4SoNN5RYuifseBOlHEKRmq9DqWtMbaNhCVAZZn4+5orBiGKyBwntTeDcTEyi0N04oCwig4c4Ih8pDbYbCXPcXXvNyMd4d69SL0BK9QKcCmQ9FdtQBzsRKAcHN33dstUImb59N3DdqGdPyJRPf76vF22FpdRnOiXcAZe3tVItRsTFAMgW8nIrsxIuNV71RHcI4nI8dS2P3PoPMWWCJKsZCO62f/VyjCuNxOSJE8idkZ57HNu9Jr2PcL8PXF0KH7kFh939flEwwoldOiiDDsd6NAhJwYjuI6BcMyoNvJkxIh7Vf8EWD5NMnSvJ6UJ6AtRcNEkuVA3wYxqDX5S7haxhm+RfIeMkgwjNMtdNzV+2xemx7Q4x8nQYP0CgJ+sThN39WJGFMk/HvXZq2BzDhlrE7SNpIent48ZyMd79Aaczmir4F6r7w4MpeD1u6LX9zJ+AY0C3PEGDfiKI66FN5LWCbvwb19
 vH4eVtRy
 Wv3uczk4KHzqPaK94JCUlInKFefThxQzhkHVoN2XYhhzwu/TCUMp180hrir3S7v0zXpb6AjWqereGkVqhua/EtvSkzmBpm2QfAo4Pm7XF9cR0gqT5I+6QRtwgXoHTIYJkNbrt/w7//urMhPJepy3+rFWLZLJMC5Pqa68Q8oe4daOw21g8si5Do404K+3wK6mrCGBaNvNVu4SWBhaxOmwEpp+McuQjcKe5fg2nQCl3BjrIeDTq38DS3f7k/v/KXdSIZmHT5G4lsURUDPeA4GyR7ITwVYHp9FXl3N+Jl8xZXgX9yNaO2zsPdJrKC6O5UNtS79EATN3Ql1XRK422wctrXgQ6WbQvg3/vnpNjXb0Or0iUafke7Y1otJOlT3//i8reb7hptZ6m7KeOuZykPOkg/lLFEIXm2P7ONdeTQthy/jARKcDb7kPPjdlXcJFuY+LPcBWynAP5HF1um9YZNSCdTbZSTpypMIYooP2V
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Honglei Huang <honghuan@amd.com>

Hi all,

This is v2 of the patch series to support allocating multiple non-contiguous
CPU virtual address ranges that map to a single contiguous GPU virtual address.

**Key improvements over v1:**
- NO memory pinning: uses HMM for page tracking, pages can be swapped/migrated
- NO impact on SVM subsystem: avoids complexity during KFD/KGD unification
- Better approach: userptr's VA remapping design is ideal for scattered VA registration

Based on community feedback, v2 takes a completely different implementation
approach by leveraging the existing userptr infrastructure rather than
introducing new SVM-based mechanisms that required memory pinning.

Changes from v1
===============

v1 attempted to solve this problem through the SVM subsystem by:
- Adding a new AMDKFD_IOC_SVM_RANGES ioctl for batch SVM range registration
- Introducing KFD_IOCTL_SVM_ATTR_MAPPED attribute for special VMA handling
- Using pin_user_pages_fast() to pin scattered memory ranges
- Registering multiple SVM ranges with pinned pages

This approach had significant drawbacks:
1. Memory pinning defeated the purpose of HMM-based SVM's on-demand paging
2. Added complexity to the SVM subsystem
3. Prevented memory oversubscription and dynamic migration
4. Could cause memory pressure due to locked pages
5. Interfered with NUMA optimization and page migration

v2 Implementation Approach
==========================

1. **No memory pinning required**
   - Uses HMM (Heterogeneous Memory Management) for page tracking
   - Pages are NOT pinned, can be swapped/migrated when not in use
   - Supports dynamic page eviction and on-demand restore like standard userptr

2. **Zero impact on KFD SVM subsystem**
   - Extends ALLOC_MEMORY_OF_GPU path, not SVM
   - New ioctl: AMDKFD_IOC_ALLOC_MEMORY_OF_GPU_BATCH
   - Zero changes to SVM code, limited scope of changes

3. **Perfect fit for non-contiguous VA registration**
   - Userptr design naturally supports GPU VA != CPU VA mapping
   - Multiple non-contiguous CPU VA ranges -> single contiguous GPU VA
   - Unlike KFD SVM which maintains VA identity, userptr allows remapping,
     This VA remapping capability makes userptr ideal for scattered allocations

**Implementation Details:**
   - Each CPU VA range gets its own mmu_interval_notifier for invalidation
   - All ranges validated together and mapped to contiguous GPU VA
   - Single kgd_mem object with array of user_range_info structures
   - Unified eviction/restore path for all ranges in a batch

Patch Series Overview
=====================

Patch 1/4: Add AMDKFD_IOC_ALLOC_MEMORY_OF_GPU_BATCH ioctl and data structures
    - New ioctl command and kfd_ioctl_userptr_range structure
    - UAPI for userspace to request batch userptr allocation

Patch 2/4: Extend kgd_mem for batch userptr support
    - Add user_range_info and associated fields to kgd_mem
    - Data structures for tracking multiple ranges per allocation

Patch 3/4: Implement batch userptr allocation and management
    - Core functions: init_user_pages_batch(), get_user_pages_batch()
    - Per-range eviction/restore handlers with unified management
    - Integration with existing userptr eviction/validation flows

Patch 4/4: Wire up batch userptr ioctl handler
    - Ioctl handler with input validation
    - SVM conflict checking for GPU VA and CPU VA ranges
    - Integration with kfd_process and process_device infrastructure

Performance Comparison
======================

Before implementing this patch, we attempted a userspace solution that makes
multiple calls to the existing AMDKFD_IOC_ALLOC_MEMORY_OF_GPU ioctl to
register non-contiguous VA ranges individually. This approach resulted in
severe performance degradation:

**Userspace Multiple ioctl Approach:**
- Benchmark score: ~80,000 (down from 200,000 on bare metal)
- Performance loss: 60% degradation

**This Kernel Batch ioctl Approach:**
- Benchmark score: 160,000 - 190,000 (80%-95% of bare metal)
- Performance improvement: 2x-2.4x faster than userspace approach
- Achieves near-native performance in virtualized environments

The batch registration in kernel avoids the repeated syscall overhead and
enables efficient unified management of scattered VA ranges, recovering most
of the performance lost to virtualization.

Testing Results
===============

The series has been tested with:
- Multiple scattered malloc() allocations (2-4000+ ranges)
- Various allocation sizes (4KB to 1G+ per range)
- GPU compute workloads using the batch-allocated ranges
- Memory pressure scenarios and eviction/restore cycles
- OpenCL CTS in KVM guest environment
- HIP catch tests in KVM guest environment
- AI workloads: Stable Diffusion, ComfyUI in virtualized environments
- Small LLM inference (3B-7B models) using HuggingFace transformers

Corresponding userspace patche
================================
Userspace ROCm changes for new ioctl:
- libhsakmt: https://github.com/ROCm/rocm-systems/commit/ac21716e5d6f68ec524e50eeef10d1d6ad7eae86

Thank you for your review and waiting for the feedback.

Best regards,
Honglei Huang

Honglei Huang (4):
  drm/amdkfd: Add batch userptr allocation UAPI
  drm/amdkfd: Extend kgd_mem for batch userptr support
  drm/amdkfd: Implement batch userptr allocation and management
  drm/amdkfd: Wire up batch userptr ioctl handler

 drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd.h    |  21 +
 .../gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c  | 543 +++++++++++++++++-
 drivers/gpu/drm/amd/amdkfd/kfd_chardev.c      | 159 +++++
 include/uapi/linux/kfd_ioctl.h                |  37 +-
 4 files changed, 740 insertions(+), 20 deletions(-)

-- 
2.34.1


