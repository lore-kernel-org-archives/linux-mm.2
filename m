Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 58D9CCF45CE
	for <linux-mm@archiver.kernel.org>; Mon, 12 Jan 2026 20:23:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BF8286B0088; Mon, 12 Jan 2026 15:23:28 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BCFA86B0089; Mon, 12 Jan 2026 15:23:28 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AB19A6B008C; Mon, 12 Jan 2026 15:23:28 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 98FC46B0088
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 15:23:28 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 3AC521AEED7
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 20:23:28 +0000 (UTC)
X-FDA: 84324436896.23.2D8DDF8
Received: from SJ2PR03CU001.outbound.protection.outlook.com (mail-westusazon11012022.outbound.protection.outlook.com [52.101.43.22])
	by imf02.hostedemail.com (Postfix) with ESMTP id 4E4FD80006
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 20:23:25 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=SIsLtivY;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf02.hostedemail.com: domain of PratikRajesh.Sampat@amd.com designates 52.101.43.22 as permitted sender) smtp.mailfrom=PratikRajesh.Sampat@amd.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1768249405; a=rsa-sha256;
	cv=pass;
	b=Y3reWR22jqnBVC3fhxYDHY7Fdb1gDvrQ5Ku0w27ZeV+ED8w1xOhdyCY2X5OMkMsiY2zNXD
	IXufFUBv5+SXMDQGOYsHqK/GUs1rp1vSQSaHHkl8xKNji5NVmJLdFhqqhRifSJmC+2ldvw
	Y0eNgkRhC15smwil9PfYftyiHyHNKqY=
ARC-Authentication-Results: i=2;
	imf02.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=SIsLtivY;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf02.hostedemail.com: domain of PratikRajesh.Sampat@amd.com designates 52.101.43.22 as permitted sender) smtp.mailfrom=PratikRajesh.Sampat@amd.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768249405;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EVlyJfBY+TxW8330bmRrTRH8oxQkICGB4rxgQ8APyxI=;
	b=gYWHxh9aGXYZF6CyV1KmV07R1JTW3cWY9bopZXlYaX+mNWecAbj1v4Sf9V/r/P2l2aod5q
	p75fmADzcNsLmIsLbKxwHs6ybvB2wD9UdWqtKKKwg+NB6Y4aefW7GbSOVnFTexpMVg3B6a
	qO5tujh3vruJSARx6V3vptZqTpCFT2o=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=TwQ+q6fK3ZuuE0XoCYVYlGnP2nxKEKoUwfEpEhAEEemekYtAnr4PsekxLjTLppzND4CyBhDMmAP/JZY7iHwOMbqhtU+FZmPBFDI2Nzq38JM/0b3FpS+infm2aAkWrZU1QSpOJlZqs5ceAEmXrOtcrnMTtwpgmkOkG07e/74xanxOZyQ21wkP2h6HR5eU8yADelI2e5Xm4tgu1FUxv9aKHAUDXy4psNe/G90+XLls7rBeeXmChMdAVTRZRTSoYCnGP/lCuTmms4xfUkI4TSPwIoPIkglW3aRsqzXbxoT6Ed3ngVknbeUSu6VE6Dpkn53e8e5ml144QK87sEaFrUn9EQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EVlyJfBY+TxW8330bmRrTRH8oxQkICGB4rxgQ8APyxI=;
 b=SMhRUreZp97+ygqXYl6do1JaB5UjvZqbFp63LkYCWV64yxfhHTG3RxB2kOvtJ8whqDGXjXKj2LPTLnOfWpECY9HOYNWyTyiOXiTC/wwzH0jZ/+PJnlXk8H00GAyAbb+vYN0P/U/NoJn3qkROoUo4gZ2JWji0Nhv+gi/FdJ7KF2/AT7MA/s0uDWE9IrJr8JIbO+5rhNjJ42Pfr11GwzTujS1XJui1Mw1Yz464Hannx34I/Bd/ZbV1QYKSmvQXNf/tOxsnBJ7TDt8IXf6OPasvDsDV4P72ZolrCEHMvYQGdZwKhqV80OeMJO4X0lhXGtecLUGdej/tgOmicJJ4JCPTnA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kvack.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EVlyJfBY+TxW8330bmRrTRH8oxQkICGB4rxgQ8APyxI=;
 b=SIsLtivY6aCVcsk7YUD7rpr3/D0LEF8+6NsheNmpfmWDabHnDqHdKYl2BVfzBCOGW0hZsuDwfUpsD/oYB6WlZgdxPDxQpW1RL52doh0hDOE7+0m0djR6KQq0uXZh+KfbQ7k1mp42O0KkfTTCA+jG4/IKTr5L6bVcUUs4rLghjig=
Received: from MN2PR22CA0020.namprd22.prod.outlook.com (2603:10b6:208:238::25)
 by DS7PR12MB8230.namprd12.prod.outlook.com (2603:10b6:8:ed::5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9499.7; Mon, 12 Jan 2026 20:23:18 +0000
Received: from BL6PEPF0001AB4A.namprd04.prod.outlook.com
 (2603:10b6:208:238:cafe::1f) by MN2PR22CA0020.outlook.office365.com
 (2603:10b6:208:238::25) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9499.7 via Frontend Transport; Mon,
 12 Jan 2026 20:23:09 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 BL6PEPF0001AB4A.mail.protection.outlook.com (10.167.242.68) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9520.1 via Frontend Transport; Mon, 12 Jan 2026 20:23:18 +0000
Received: from ellora.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Mon, 12 Jan
 2026 14:23:17 -0600
From: "Pratik R. Sampat" <prsampat@amd.com>
To: <linux-mm@kvack.org>, <linux-coco@lists.linux.dev>, <x86@kernel.org>,
	<linux-kernel@vger.kernel.org>
CC: <tglx@linutronix.de>, <mingo@redhat.com>, <bp@alien8.de>,
	<dave.hansen@linux.intel.com>, <kas@kernel.org>, <ardb@kernel.org>,
	<akpm@linux-foundation.org>, <david@kernel.org>, <osalvador@suse.de>,
	<thomas.lendacky@amd.com>, <michael.roth@amd.com>, <prsampat@amd.com>
Subject: [PATCH v2 1/2] mm/memory_hotplug: Add support to accept memory during hot-add
Date: Mon, 12 Jan 2026 14:22:59 -0600
Message-ID: <20260112202300.43546-2-prsampat@amd.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260112202300.43546-1-prsampat@amd.com>
References: <20260112202300.43546-1-prsampat@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: satlexmb07.amd.com (10.181.42.216) To satlexmb07.amd.com
 (10.181.42.216)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL6PEPF0001AB4A:EE_|DS7PR12MB8230:EE_
X-MS-Office365-Filtering-Correlation-Id: 9b3ceb9d-9172-4ebd-d88d-08de52186c65
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|36860700013|1800799024|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?66JpWwiHsTOAXgCLyytz9jkMQG8Lwx3tltIBCghHs5/i428hdTAcbXdtZ5UV?=
 =?us-ascii?Q?nGeazdqvba/y7RcDT+mt9RiNrzN6RaKweXt+zG4UrW25B5EfuV/F2mGFH+bZ?=
 =?us-ascii?Q?wrNjk+dD4Wfl/stHYLuZrIspUy68sVR1jVsNinOPzMvUzriHEcGkjmK/+36l?=
 =?us-ascii?Q?HVSz1tLaFI76jO/G7TOLS65e9nCCTZ6gv9nySwhRWwSub2VVLsgSZcQCfnfW?=
 =?us-ascii?Q?7A/vLWBvPgEbOp+3GARfEMsdB5x889ErzO5OC+9bmZQtzi2hjc35I3p+4nSj?=
 =?us-ascii?Q?uRUeHrBT5f4sgiqURK+Jgcqgh4FcTIRXLzNqtk6SbHQ8b1x4Aw6EBiJL9wdr?=
 =?us-ascii?Q?xJpucwlxjVi4f3NE/Fya5JP+Knxi+pJR38+/IIU6ft8eNzrPc0cueA7yLKCm?=
 =?us-ascii?Q?Gc8rm/+mGackBgEOFvNtfJW1jVVl8SnISJV6PNEXI7BkjLxyrNGPA3O57mLO?=
 =?us-ascii?Q?tBwra/YLRjdJkBBaadtQikEpJ078qgXG3rqu0rjVqmv8bF90ws8A2Rt+1cKC?=
 =?us-ascii?Q?b8Z02XinOvQHm8oACCDxn9DDhlYdM/3uLtXapZ7D2z5CT82qIuySfYnAAPUF?=
 =?us-ascii?Q?nvSMzDbFWPHHlsdJJiNcKs0tG11ilLqSMVhfOG1EkgQdk+fGGFBW2oCMsUlK?=
 =?us-ascii?Q?oNLDUiRKBEric8sTr7J3OAD1RldH/Gtr4iIAxBGyEbYnrXbEEk9/zyvmRPDn?=
 =?us-ascii?Q?j+OROcbVFV+ntxIVdi7G3dbrFiqeZ8zLo+iNOo/pG3s+kCxmX+BDtyel6qrI?=
 =?us-ascii?Q?TyFaXc1T5Ldo0gdgeKC92OU4elLnac8Yu9Mhof/FSSSx56tZG3DwA+kHbk4u?=
 =?us-ascii?Q?UUHt7179rfUVzGCWy3qB9E93gJm03YS7uComP7NYaCa95t5O1Sf3EVQMJk9S?=
 =?us-ascii?Q?VbcQHsBJUqmsNX2OpNsNw96+BNXlP0dItbN96QTO0jqiCnwSdOg27EVnr+AF?=
 =?us-ascii?Q?m1Y98VtykKzJz7LKW/nb49yb76G4X7lz55caLhy2fBSTGZmelpRlUKaitYCz?=
 =?us-ascii?Q?IUaDCtAmUZBe1rbwwxGTXk73qZTibWH/2vPQlce3XR1dXODHiGNfuHXt2QRQ?=
 =?us-ascii?Q?uCY7BPQsCn2X/0rvBgDpqaGN2OX+OuIlUQCTKjSqAnxOZac0e6yUP5//r8+4?=
 =?us-ascii?Q?S9LNgywqGD8uzxKKeIOVfk/tgVo+rAM+vQ5W5EB5bgidkUchFOusIiz0tyFh?=
 =?us-ascii?Q?UIo8EPorPg/1Ju2KateFkc8roSIzU8qTXuXT45XZJN8gAARseUF+Nf5BuSe/?=
 =?us-ascii?Q?OuGUAvfKC87wb824TB+qmGKi9OgkyGmfcyPu3AYg2KfXYbZi/HUP5a+vhV+j?=
 =?us-ascii?Q?DNIBplF7DfPmoj05Czsg90UB/7LwjMjBWUq+G1no0T9GSIqcwG5BSHbzS02P?=
 =?us-ascii?Q?DuEAewHiMYbcq++lDQJ5tDrYxBOSQXSBN77LBs7/YEnHi/mNWdFIXO1wgNuI?=
 =?us-ascii?Q?Ngu315x+7Fs1Mq6qtLQwKMc5j2dKkhvPeu1Ru+ga6cj/0Uav8EtaA/WRSefH?=
 =?us-ascii?Q?WxLE44K+VCSdbal/UAfUpxjhOpKxdvDBw31Zzk+szdlkFTd6GXhbg6EL/fil?=
 =?us-ascii?Q?2QbNHyP7t0A47tjC9i0=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(7416014)(376014)(36860700013)(1800799024)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jan 2026 20:23:18.4137
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 9b3ceb9d-9172-4ebd-d88d-08de52186c65
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL6PEPF0001AB4A.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB8230
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 4E4FD80006
X-Stat-Signature: kusdropsy9s7w618j836fkxkeb63t6wy
X-Rspam-User: 
X-HE-Tag: 1768249405-912619
X-HE-Meta: U2FsdGVkX187ZxEvlxWN+KIupU1Mkhuo38V7NbvMBmZtcZLR/NQkSK9npl8Gp/V4B52c05s8JhZv1Zm28SAFlvwCvXJhW4tx68EryE77mOfqwpngXrbnrB0U7sUjeKj/4TEOXXS2SkQz0o6ZYfX1Ezo/LZtCUFjpiYG1NVMYvRR5sPe8blmBcQnbrhlAyx5l/hTKBTxccMG2V1wCxqkzxPnvDWNpoL3CGryxvf15udPvbt7NYygPAXDUniS3wd+Hp9ghic7jWMs245YYyO97/wXfonAxV/xcgmO+faOYKQ+5FuArEKtyqVM11QWP/7NjMJe63w739RU+1x4Kk/K08Y4MzBFBX7u4XuU4wKRf0KshusvJ9WwivTxq1dACSg4cg0UIW2Z2RnkWk4O0BJSZsIFui3bHFjigsp+zN7qN15psrfGwZDzSXUBy2wnfjgZPmVzL6EYtU644OEea6WFRfmx0xl6k1q3KrHSPZ8aCsD1+KQ4d4hoebFmqQJ/18l7VzxuTjK8Kdb2TFKRMvjgUxdcLS8QzTOKVgirNMifbRbb5C0k/g8663wH/NAA3J6Ov8XWHH8t1HtJIMDEbMfMLxK0/HgeWwl+CrN4BDT0SuWzkJuqmiIqpKFOA2HQ5NqfAeqvgsj3CqZFsTpLMgH96CeFsWod80AVwiQTNveMgN0LUFI9ZubtY8Sd0t0+CH8Y1M2DiqFQEbLDhG+l1UHMhsGT37dqgHLA9PBZLYqUowxEU7zwHM+cWK4MctQSA5+BViMzv7v9Q/dQfhLuDCl9q+VEC6thm3WRtstHoTUkXXQ7F3lr1BbhQQX/hI7SKjqh36OcrF6rvbf9h9tA7pbpQZl5k1fK4+8bEoK4GIYZcTE0mjJsfHv6HZwP9hYEOfCfF/rkmZckvkk34rjTaCe+CU9jZIV95EHJ2I2RsfedpZrlfVRkXsCxcO1Bk2DGhfRxJ3B8LbqvnhuroHw5s/io
 z7n0C6c6
 0XjOYC0qqWKo5NODAttLyBOEf766gyskScCrs6gb5t7ivbidBRqPL7XaEa+RuAtx8uuaSsciTqRDHG0TzXvA5dBhc1MV6Gzz4CkAIZiEDsi6zPNvGR9Gh5qSnRsTba7hahQb1N/H1WO3CaxO60czraXsxOEUTmMP6ehMDba3v199a4laD6N14xhF1jU6HxJDHohl19Qk0PTtXzRgjIUri8kjM1ntjzLUK0VCXKUnarCKr+f6ND7Sa5O0G4PFrpXXiQgyTZQtx7Oyjml68IxhMY7W7IWMd14ILY2OewrrIa9ON8hsxmXKZibA3xlK9fuB1LkhHs/m/Df2cdyHojRh11Vn/B0IyJQPgXASOy4KA/tmMZhAyKu5CQAWNYEdWZtDoUHjVICL8sQcylJZFdy/eqh7vwDUDHI3VLhc92PuV/wRctHBAoUqgOmWxpbynvDAfyAfp+WJ1Cl1rtj6ZFr6CAyE5FiVYMyslfkF53ABwY4Y/C8e10kxjkHrfpTPg8RkELhyKg1aQSj5WBH+c75k1/bSBu0M/bIJ/eFdkwGeP19vxXTigtWojffDwoZD3t3OdzD6pkhKomGFXQ38ObSX2su/ppxC2zGtKsOqWjUyufuzyzrjd7fcXgk6ZEDZYA7F9JRIIwMTb2D4U7v0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Confidential computing guests require memory to be accepted before use.
The unaccepted memory bitmap maintained by firmware does not track
hotplugged memory ranges.

Call arch_accept_memory() during the hot-add path to explicitly validate
and transition the newly added memory to a private state, making it
usable by the guest.

Signed-off-by: Pratik R. Sampat <prsampat@amd.com>
---
 mm/memory_hotplug.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
index a63ec679d861..8cfbf0541430 100644
--- a/mm/memory_hotplug.c
+++ b/mm/memory_hotplug.c
@@ -38,6 +38,7 @@
 #include <linux/node.h>
 
 #include <asm/tlbflush.h>
+#include <asm/unaccepted_memory.h>
 
 #include "internal.h"
 #include "shuffle.h"
@@ -1567,6 +1568,9 @@ int add_memory_resource(int nid, struct resource *res, mhp_t mhp_flags)
 	if (!strcmp(res->name, "System RAM"))
 		firmware_map_add_hotplug(start, start + size, "System RAM");
 
+	if (IS_ENABLED(CONFIG_UNACCEPTED_MEMORY))
+		arch_accept_memory(start, start + size);
+
 	/* device_online() will take the lock when calling online_pages() */
 	mem_hotplug_done();
 
-- 
2.52.0


