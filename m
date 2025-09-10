Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CE7B5CA101F
	for <linux-mm@archiver.kernel.org>; Wed, 10 Sep 2025 14:47:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 37CC88E0003; Wed, 10 Sep 2025 10:47:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 305FE6B0022; Wed, 10 Sep 2025 10:47:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1A7226B0012; Wed, 10 Sep 2025 10:47:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id F1EEE6B0010
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 10:47:34 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 802DB140904
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 14:47:34 +0000 (UTC)
X-FDA: 83873619228.04.3B0EEB8
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2075.outbound.protection.outlook.com [40.107.94.75])
	by imf01.hostedemail.com (Postfix) with ESMTP id B00EE40004
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 14:47:31 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=cmIVAQX6;
	spf=pass (imf01.hostedemail.com: domain of bharata@amd.com designates 40.107.94.75 as permitted sender) smtp.mailfrom=bharata@amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=quarantine) header.from=amd.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757515651;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=rmGcqjx9GXo+OEu7AZRyO9BJWyBHo1CptDAPtt0g1Pc=;
	b=Xcm7K5nBPeu8o9GDAKoIQ4reH9Et4eIDT7szQ6SJe//26H923JD5uwVIygsWrSBDOowaxX
	ciYi+N5+JquqQxGHl3BjKfEKrFiTg9ir9mWf4rewUHpE8frCPVVf8AfdJ3uB0DgocsWei9
	aKAjhXfFE5bfo6XCQTh3CpjTam2JYC4=
ARC-Authentication-Results: i=2;
	imf01.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=cmIVAQX6;
	spf=pass (imf01.hostedemail.com: domain of bharata@amd.com designates 40.107.94.75 as permitted sender) smtp.mailfrom=bharata@amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=quarantine) header.from=amd.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1757515651; a=rsa-sha256;
	cv=pass;
	b=rn8Uv9hVDCcq/+ujLVdia1tuXGQX6JL9pjnjHFD26/OEZq1jn0a+ojFlOW7B896VTIebUE
	i4eAnKyCvD09XT1cq8NW3X2GmzghK5W984gNQT+vTYRcJ3aIkraVETBLqp+hMbzyIW7gZ0
	1j64u8sFtvjOI3bGX+xRMR6V22Swp5s=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=T21mOeQn9cETm/RtL9hHzOQxbNewx5aryqAOmiGuXNrdDdQbRLBN/jn4Le8+R5kp4YLatAQDW/5MNvg1jjlcPPisKRWeL+KH9MQd2v+TERFqWd/U/aMU4r7hWiDVJ4XOI9Yd0ZNhOxwZuB2n1eMGNFeXJ/XQ2Gl1C/aWRTKIWDXG+4GrqmU5iHPLl4Qu5N/d23TRcKpnEiMphQTY0x00xw+s02nQuvm+IWeldNfweWO3uwovLNWJl6e+Pclh7uqH2XgfR61UR20QsdXkpR8OPG4X+4FOW0QxiCYpCgm9ZdIQKssZTRehEGBF6HKL94Oa8tgQeGI7yL/AYmbMApg3VQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rmGcqjx9GXo+OEu7AZRyO9BJWyBHo1CptDAPtt0g1Pc=;
 b=CEwM4GnStsZfei4IUqDz7OG3Fl4C+JpkJnc5CKURMiqLwPvwA1PglOodmn+owCwvb0YUdex2VY5HPgHenhjdsPVwaSh+ff8UUkC99Lou6rPI6OvXS543NsAjDXHJ/fKP5nHDmixj6ynIvxxJnpTblXXJfsXvwJco2aeUnfJjzbrGmi1YJM+KnHTxn0XrOluqgpV9nDa9L/EqAw5VG7xVSBp5Oasb8tcu5UJkseapjyzOLyLlvI4hqOSPsM0vLPNM077XOkdV/AsArBANXCm4jtxyGOlFdeCniaD7OFmgjlDA5Hs+BKfV2lsSb4u3Kl40yaBHF2TMgyFWFjKG8CIIRA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rmGcqjx9GXo+OEu7AZRyO9BJWyBHo1CptDAPtt0g1Pc=;
 b=cmIVAQX6nq2omxJ/CNe/4hSggfVoU1stRyP1LmY7WCSnRLpVNZLn0RFDjMVxkETp7/+27uAdZv9TulQOnwEtDv3krPWEHYyAP5i5gi/2bZj9I/3XAcIgzbUmkNizv7oggEln1vohyXvhooTumIkvjZdzXH2/Y3fSXoaIp29PQQY=
Received: from SJ0PR13CA0100.namprd13.prod.outlook.com (2603:10b6:a03:2c5::15)
 by CH3PR12MB8257.namprd12.prod.outlook.com (2603:10b6:610:121::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9094.22; Wed, 10 Sep
 2025 14:47:28 +0000
Received: from SJ1PEPF00002311.namprd03.prod.outlook.com
 (2603:10b6:a03:2c5:cafe::19) by SJ0PR13CA0100.outlook.office365.com
 (2603:10b6:a03:2c5::15) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9137.6 via Frontend Transport; Wed,
 10 Sep 2025 14:47:28 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 SJ1PEPF00002311.mail.protection.outlook.com (10.167.242.165) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9115.13 via Frontend Transport; Wed, 10 Sep 2025 14:47:28 +0000
Received: from BLR-L-BHARARAO.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Wed, 10 Sep
 2025 07:47:18 -0700
From: Bharata B Rao <bharata@amd.com>
To: <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>
CC: <Jonathan.Cameron@huawei.com>, <dave.hansen@intel.com>,
	<gourry@gourry.net>, <hannes@cmpxchg.org>, <mgorman@techsingularity.net>,
	<mingo@redhat.com>, <peterz@infradead.org>, <raghavendra.kt@amd.com>,
	<riel@surriel.com>, <rientjes@google.com>, <sj@kernel.org>,
	<weixugc@google.com>, <willy@infradead.org>, <ying.huang@linux.alibaba.com>,
	<ziy@nvidia.com>, <dave@stgolabs.net>, <nifan.cxl@gmail.com>,
	<xuezhengchu@huawei.com>, <yiannis@zptcorp.com>, <akpm@linux-foundation.org>,
	<david@redhat.com>, <byungchul@sk.com>, <kinseyho@google.com>,
	<joshua.hahnjy@gmail.com>, <yuanchu@google.com>, <balbirs@nvidia.com>,
	<alok.rathore@samsung.com>, Bharata B Rao <bharata@amd.com>
Subject: [RFC PATCH v2 0/8] mm: Hot page tracking and promotion infrastructure
Date: Wed, 10 Sep 2025 20:16:45 +0530
Message-ID: <20250910144653.212066-1-bharata@amd.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: satlexmb07.amd.com (10.181.42.216) To satlexmb07.amd.com
 (10.181.42.216)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PEPF00002311:EE_|CH3PR12MB8257:EE_
X-MS-Office365-Filtering-Correlation-Id: 609f168f-10df-46ad-b7a6-08ddf078f6a7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|36860700013|82310400026|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?8yxaSIA+cIAbYIG0+8wLj+g8iWpOASgOopS1JHSylIUt7aQ606goofuVVYu1?=
 =?us-ascii?Q?nDHAVg1bQD673paoHaq0kwpwVJ00ct7zSjVy6L2TSHfnRhr89ALwISMBkTCc?=
 =?us-ascii?Q?C1p+lk9nFGu0gtLVaDEKrldPLfehDjr6f9zbmL5lC4y+gc3MYvu/U9ydGdau?=
 =?us-ascii?Q?mJ0XiQ9BrkPVzDbEHWEdALYvzj/rjeP3MqLUY3ROlQg6VJifvPL+2N7ZoSJf?=
 =?us-ascii?Q?zCwI4C8hXV2vHG2371C5mwiVo99dphgjGR32HvcP5OnqbPGWnVGFIe1gWrCQ?=
 =?us-ascii?Q?cVPH16Q/u3Pama4yPn/qrsUkkx78yKSMOaD+od35cJpW3lWCqBFpTzpAQvCp?=
 =?us-ascii?Q?WCKUo5qhGYET+gqsaXZA1nOfphF8B6fi8qRqCerzKqB/SEIr+3EKJ0CSQ7AX?=
 =?us-ascii?Q?L/YsPFkJfOh921AGnfGQ+B3NcYuvPnPiuF/pzdWGg+mGHaJy3BWmYiMi4QZJ?=
 =?us-ascii?Q?AN17aJymlBS7sgHfSjDxW0ZXOD1hG5czTVUH8GmU1FwI8fAWuJVelCJMy7hA?=
 =?us-ascii?Q?6lJ1ZyR56QHBcYqT6eKwD3VyVwueBIMFwbihbOdaC+8RfuhZlkSmT/TfdAON?=
 =?us-ascii?Q?9McZdfwmse5BPotHCl9hjMQAoS1glADLAoG4lmQM2XckBW9hHrq8KhaFrIpC?=
 =?us-ascii?Q?UNR0Nk4a6kNqaoB/8zsW7fYFL3B7plKid3/Dg+Rbm8p03RMDVy1Ht1tvjpMM?=
 =?us-ascii?Q?ub56VNyCZcYDN637fnjEZqmKWRL2p3I7yrVZW2e1PG19eGilOl6gb2tXx4OY?=
 =?us-ascii?Q?RHE2kiABpYCWZVsBpRrHt40kb+EOrJsZanTjAhDsZ/ZG1EeJVdVzDX+Pt1ip?=
 =?us-ascii?Q?Q34fU78OugMuFsbfg8HVd0aLaLrVT4erXCM/G1poRE9r/fZ/9KE41LGqhjd7?=
 =?us-ascii?Q?E/HCVJNq4vuhzCrtiIRXCC8rBGRHD+TBYN6Rp3vgqdZiBJTSWkGA5Ow5Gr9z?=
 =?us-ascii?Q?fMhdVZwqq0hdf3ZjwXFzP0gMSDUONhHlYo3l+cDIv9JKWMxEIk1mzxteplAF?=
 =?us-ascii?Q?UufIABiI8qqouooPD8g9fFJkhfksdjX2HWvb5Jbuvrwt9XQ08c4ZlIqxiOE6?=
 =?us-ascii?Q?jfX88TZ/I8G5fWBnR+L7O4GEPl7DNul/v+68D4eocmzelFZi074u2Q3J9x5U?=
 =?us-ascii?Q?5Jc/U1MO2Wv2CFTawG2PyILAGebsb7HpbaAfdmBxmbfeNyAhALLlSuhBWnG4?=
 =?us-ascii?Q?8cnmQMpDmzW8qLD59s7nZaZlU16QdBLbLyHnoamTMKofs7oY5ncxZqBmC+Gw?=
 =?us-ascii?Q?r3lWsFSCdl0V3vFUFuaTjaYh5BIwH20qw09dpotjmrzdnXa5/dBD5A+U0I9Z?=
 =?us-ascii?Q?MjbemgBKR7z4V1+8jROg32UbDsap9/EWuxJwaLU1aq9hRA4T7sRdPWTSPl0B?=
 =?us-ascii?Q?hdcDgpjoa7cHyjZUbK0SYo8G8XsfTQW+5HrvNkLxWYU2+ogk3neySfGyIm1d?=
 =?us-ascii?Q?b2oTlJz0x3hV6tXqvz/dhmjFw1J1AswGqNKhHGwjVFjHG7El/G9Gckz4iULo?=
 =?us-ascii?Q?6Eu7K2JUMszKqBVrNcWDn6JFhi+LP065ymLyJTHk+QLyEiRNvtxkjQLnIg?=
 =?us-ascii?Q?=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(36860700013)(82310400026)(7416014)(376014);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Sep 2025 14:47:28.0064
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 609f168f-10df-46ad-b7a6-08ddf078f6a7
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF00002311.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB8257
X-Rspamd-Queue-Id: B00EE40004
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: udu58po3h6gsw41mjsqf61jpoxopz1aw
X-HE-Tag: 1757515651-342860
X-HE-Meta: U2FsdGVkX1+YWFnz7TlSsvEITL507szw/n4wU1l+5jDrpS+ZNVtCi/IGh86lrpbMHTcjXiEUVS5Mss1MzdTOazQ8GjXcS/XFB0ehuk94BAMZgvclXY+hIFm1ps7PJBTUD7s2It1WQbSGeH7cmTZJuz4v7dsbIo6YwA//3U7yhNnR8EYdEF5YtNPC0/c8jyOU6jsCF7beiZGjLdcELq2ES0uTLfjJDEq6TOEy0ArwwUG7P4UR1yupy+49h6XKVSSX0FywopFhPhZIFLV3BjuZZo8jdV9dmmR5UEamnTdIimqZBFnCV+EmBTM6+jSKNCBFzNPdddDi2qv8h3drRoJaL8MVfASCijiJ3q/0+jPbEGFklkPEwQL3ORg/XKiT+3P3HBiDdCWtlyb7HacjdbHWGtqBUAmAkH7gY8+Fjj26ZdFuwYqPHPuAzTOxG+9MxihJXvfsKy9oOyZwbgNfm7py5dKKzAMfrqAjD+vznDxgwbtrC8vIKtCqhphFEh0Wadv82NC9J7KVSdhxwPziMuWjQJOhNidbR259SNPyKe36I/IOEfdAAdGAlv3UoCW1bda9SAcriGR8IaTT/go/hFtDK/JXWo7Cktx7dFBIVkxDPWL5o+BX5IoHCVagqMim6YemcmgwwRryA1HMOd9Frh110g7xB9yJZUjcxwCOzFXHoeOQlG3K400s70QsKoVPMO6b7wSXZdJ3u8uIuNKCMKwDESk90bLvxeaitdQbuiGpPHNja7MExEpHkiFuNGv9QAC+byepP0JK8F6AUUe12mCsxuiuQTw6pRfakkxlTMl98I4gBYJigrYMxyHtZohS1l9CQCfdneBX85H1MoX3gCE7s2baQg34Hw98SpTyToN0xFPFjSKcgAH1FHrGeYu/4wc1yL59brPUbuvjU/3gERyFIG07UpRwCfJw4OY2RhNNGahqXPbPuOheOv+38EkmwY4meOFQHiVnEDexGCop5XV
 2OB26lIV
 kCMun5Q1VW2QAfa0j2L2EgX/g+9t1C5VtYcQZ1BSZD9RMnYxhUgF9+/E8zqV83VfLouPxao9hRyfv6CYlfRQ381MtTeatZwtVVE5F/2pAxysF0NA=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi,

This patchset introduces a new subsystem for hot page tracking
and promotion (pghot) that consolidates memory access information
from various sources and enables centralized promotion of hot
pages across memory tiers.

Currently, multiple kernel subsystems detect page accesses
independently. For eg.

- NUMA Balancing via hint faults
- MGLRU via page table scanning for PTE A bit

This patchset consolidates the accesses from these mechanisms by
providing a common API for reporting page accesses and a shared
infrastructure for tracking hotness at PFN granularity and per-node
kernel threads for promoting pages.

Here is a brief summary of how this subsystem works:

- Tracks frequency, last access time and accessing node as
  part of each access record.
- Maintains per-PFN access records in hash lists.
- Classifies pages as hot based on configurable thresholds.
- Uses per-toptier-node max-heaps to prioritize hot pages for promotion.
- Launches per-toptier-node kpromoted threads to perform batched
  migrations.

When different subsystems report page accesses via the API
introduced by this new subsystem, a record for each such page
is stored in hash lists (hashed by PFN value). In addition to
the PFN and target_nid, the hotness record includes parameters
like frequency and time of access from which the hotness is
derived. Repeated reporting of access on the same PFN will result
in updating of hotness information. When the hotness of a
record (as updated during reporting of access) crosses a threshold,
the record becomes part of a max heap data structure. Records
in the max heap are arranged based on the hotness and hence
the top elements of the heap will correspond to the hottest
pages. There will be one such heap for each toptier node so
that per-toptier-node kpromoted thread can easily extract the
top N records from its own heap and perform batched migration.

Three page hotness sources have been integrated with pghot
subsystem on experimental basis:

1. IBS
2. klruscand (based on MGLRU page table walks)
3. NUMA Balancing (mode 2).

Changes in v2
=============
- Moved migration rate-limiting and dynamic threshold logic from
  NUMA Balancing subsystem to pghot. With this, the logic to
  classify a page as hot resembles more closely to the existing
  mechanism.
- Converted NUMA Balancing mode 2 to just detect accesses through
  NUMA hint faults and delegate rest of the processing (hot page
  classification and promotion) to pghot.
- Packed the three parameters required for hot page tracking
  (nid, frequency and timestamp) into a single u32 for space
  efficiency.
- Misc cleanups and refactoring.

This v2 patchset applies on top of upstream commit 8742b2d8935f and
can be fetched from:
https://github.com/AMDESE/linux-mm/tree/bharata/kpromoted-rfcv2

v1: https://lore.kernel.org/linux-mm/20250814134826.154003-1-bharata@amd.com/
v0: https://lore.kernel.org/linux-mm/20250306054532.221138-1-bharata@amd.com/

TODOs
=====
- Memory allocation: High volume of allocations and frees (millions)
  from atomic context needs evaluation.
- Memory overhead: The amount of data needed for tracking hotness is
  also a concern.
- Integrate Kscand[1], the PTE A bit based approach that Raghavendra KT
  is working upon, so that Kscand acts as temperature sources and
  uses pghot for hot page heuristics and promotion.
- Heap pruning: Consider adding heap pruning mechanism for periodic
  cleaning of cold records.
- Address Ying Huang's comment about merging migrate_misplaced_folio()
  and migrate_misplaced_folios_batch() and correctly handling memcg
  stats counting properly in the latter.
- Testing: Light functional testing done; performance benchmarking and
  stress testing will follow in the next iterations.

Any feedback is welcome!

Bharata B Rao (5):
  mm: migrate: Allow misplaced migration without VMA too
  mm: Hot page tracking and promotion
  x86: ibs: In-kernel IBS driver for memory access profiling
  x86: ibs: Enable IBS profiling for memory accesses
  mm: sched: Move hot page promotion from NUMAB=2 to kpromoted

Gregory Price (1):
  migrate: implement migrate_misplaced_folios_batch

Kinsey Ho (2):
  mm: mglru: generalize page table walk
  mm: klruscand: use mglru scanning for page promotion

 arch/x86/events/amd/ibs.c           |  11 +
 arch/x86/include/asm/entry-common.h |   3 +
 arch/x86/include/asm/hardirq.h      |   2 +
 arch/x86/include/asm/ibs.h          |   9 +
 arch/x86/include/asm/msr-index.h    |  16 +
 arch/x86/mm/Makefile                |   3 +-
 arch/x86/mm/ibs.c                   | 343 +++++++++++++++
 include/linux/migrate.h             |   6 +
 include/linux/mmzone.h              |  16 +
 include/linux/pghot.h               |  98 +++++
 include/linux/vm_event_item.h       |  26 ++
 kernel/sched/fair.c                 | 149 +------
 mm/Kconfig                          |  19 +
 mm/Makefile                         |   2 +
 mm/internal.h                       |   4 +
 mm/klruscand.c                      | 118 +++++
 mm/memory.c                         |  32 +-
 mm/migrate.c                        |  36 +-
 mm/mm_init.c                        |  10 +
 mm/pghot.c                          | 648 ++++++++++++++++++++++++++++
 mm/vmscan.c                         | 176 ++++++--
 mm/vmstat.c                         |  26 ++
 22 files changed, 1535 insertions(+), 218 deletions(-)
 create mode 100644 arch/x86/include/asm/ibs.h
 create mode 100644 arch/x86/mm/ibs.c
 create mode 100644 include/linux/pghot.h
 create mode 100644 mm/klruscand.c
 create mode 100644 mm/pghot.c

[1] Kscand - https://lore.kernel.org/linux-mm/20250814153307.1553061-1-raghavendra.kt@amd.com/
-- 
2.34.1


