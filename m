Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C6ACFE8784C
	for <linux-mm@archiver.kernel.org>; Tue,  3 Feb 2026 17:50:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 36BCF6B00B6; Tue,  3 Feb 2026 12:50:28 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 345A26B00B7; Tue,  3 Feb 2026 12:50:28 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 21F276B00B8; Tue,  3 Feb 2026 12:50:28 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 090136B00B6
	for <linux-mm@kvack.org>; Tue,  3 Feb 2026 12:50:28 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id C0CF113B291
	for <linux-mm@kvack.org>; Tue,  3 Feb 2026 17:50:27 +0000 (UTC)
X-FDA: 84403884894.13.202FE74
Received: from BYAPR05CU005.outbound.protection.outlook.com (mail-westusazon11010053.outbound.protection.outlook.com [52.101.85.53])
	by imf30.hostedemail.com (Postfix) with ESMTP id ABBBF80002
	for <linux-mm@kvack.org>; Tue,  3 Feb 2026 17:50:24 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=JBEhEOmj;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf30.hostedemail.com: domain of PratikRajesh.Sampat@amd.com designates 52.101.85.53 as permitted sender) smtp.mailfrom=PratikRajesh.Sampat@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770141024;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=S5niGBnGgpdeJrbspiwEbnfx27x0RTQBe+lLIh+HrMA=;
	b=TcKmjsYpBcM0HOXPzvKUv1M1Qt2n9B7mF7w4WR+VvgtCo8t1PfaDvov/meh1d4ahhvtb7i
	mMrnUtDkuF+t9I/ZgpNbNhNZa5mgXk3BPH1UNNBuBqMmvlFbFeGe7qrhQY+5rxKex7IcMT
	N0btSkXCTcsOAlTXq/zezCRXKSRP3Z0=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1770141024; a=rsa-sha256;
	cv=pass;
	b=GWKZhmZ+iRj71FglKvuhncZk3LhLmCniLmoN1wPXDwn3emjwIYhRQkzkqYtVwgJQxdUshQ
	P3apIuueAjA/3Dn7TWC2WfgGI7YcqNxrpCKg6BYs4vY+Q+5EF5UEnZsk6aO/lh6RiOa+i2
	gCXIWFmWeQZAFYqlh3R4RRYeoMqts+8=
ARC-Authentication-Results: i=2;
	imf30.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=JBEhEOmj;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf30.hostedemail.com: domain of PratikRajesh.Sampat@amd.com designates 52.101.85.53 as permitted sender) smtp.mailfrom=PratikRajesh.Sampat@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=KZSVQJaim+YPWDpkOcFbTcQrzRj2bt9rz1PEYdUt1aQZBUB7h1UxNHDGdrO2ccwCVW/ib/g3SMzFTJhSth7w+uS46ztecg9YlnKJJJOlWdR1a3+Am10uPL9lxlPcC+bnCNeXNTc38XWDhmfiS/EwX8XRiVPnGpkAx4MkuMICUH85ZRQksNUvoUQiTvz9hU0sTM+XzsK17KSYgxYG6uAIQ85E3LKdl5sDmCUkG/NCFaskXy+LdG5lwVOi4nV9FQ90whZZYIrofKAHzoNnOTPNazOKrQ7vBzs2tHRkPaBgZ9+N22lwGMe2Sps03YdVd87D7QKYZEqo/qx5ZPV8UppaMw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=S5niGBnGgpdeJrbspiwEbnfx27x0RTQBe+lLIh+HrMA=;
 b=UTt65kc3Yg2O2pdsxA5U8BTnStvgPhvLec9gpV5WU4VgqO0ccoMWWbms1cFRhdFDxqzx0XcTr14fEiYC23H/9zT2DgROk3gzSirhEAUU1Z59nSdn3a7CpoWjL50VRdN/FM8G7Roxu4lgYu6+vMDwshv7ThYeUj9VPLG3LDJBHF/egNDPDfBTx2TMWqBCwxmIoIY5pN3OGbj817mwBYG3Gc9gOW/jrkummPTuE4IaY67uTkCpVvcA2JxwpHXPSW1QkaxGjPej1/oLwY7IcMbCJe/LsvUVqHMPOZHXIbswsydR34zXDMbm/mWwfchD8lUNYUUnFkd71LqI0Izb/tTP1g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kvack.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=S5niGBnGgpdeJrbspiwEbnfx27x0RTQBe+lLIh+HrMA=;
 b=JBEhEOmj5Fv7lbcGt6sUAHZy0mqyYBrFwhsQ3v6fc6D2eeROLrVMDo4BRBvPQXOUemNor/HXKuqfS0/grSCG/07W9ZKnILyjDv+PcwZN91tSvuSYNN6ONWZolZvmDYD8v770l0EByCN5TfKudzdYBOTXzf77ewvwXzJI45hidN8=
Received: from SJ0PR03CA0183.namprd03.prod.outlook.com (2603:10b6:a03:2ef::8)
 by PH8PR12MB7325.namprd12.prod.outlook.com (2603:10b6:510:217::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9564.16; Tue, 3 Feb
 2026 17:50:17 +0000
Received: from SJ1PEPF000023DA.namprd21.prod.outlook.com
 (2603:10b6:a03:2ef:cafe::e1) by SJ0PR03CA0183.outlook.office365.com
 (2603:10b6:a03:2ef::8) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9587.12 via Frontend Transport; Tue,
 3 Feb 2026 17:50:18 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 SJ1PEPF000023DA.mail.protection.outlook.com (10.167.244.75) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9587.0 via Frontend Transport; Tue, 3 Feb 2026 17:50:17 +0000
Received: from ellora.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Tue, 3 Feb
 2026 11:50:16 -0600
From: "Pratik R. Sampat" <prsampat@amd.com>
To: <linux-mm@kvack.org>, <linux-coco@lists.linux.dev>, <x86@kernel.org>,
	<linux-kernel@vger.kernel.org>
CC: <tglx@linutronix.de>, <mingo@redhat.com>, <bp@alien8.de>,
	<dave.hansen@linux.intel.com>, <kas@kernel.org>, <ardb@kernel.org>,
	<akpm@linux-foundation.org>, <david@kernel.org>, <osalvador@suse.de>,
	<thomas.lendacky@amd.com>, <michael.roth@amd.com>, <prsampat@amd.com>
Subject: [PATCH v4 2/2] x86/sev: Add support to unaccept memory after hot-remove
Date: Tue, 3 Feb 2026 11:49:46 -0600
Message-ID: <20260203174946.1198053-3-prsampat@amd.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260203174946.1198053-1-prsampat@amd.com>
References: <20260203174946.1198053-1-prsampat@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: satlexmb08.amd.com (10.181.42.217) To satlexmb07.amd.com
 (10.181.42.216)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PEPF000023DA:EE_|PH8PR12MB7325:EE_
X-MS-Office365-Filtering-Correlation-Id: 4e684234-07e3-42a9-36c0-08de634cb135
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|376014|7416014|82310400026|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?YiJJhcwPPTAct/P4tit4PoN1CLeAwb6fZLjbNGfYsXE/MP84T0s5xiTKQaw0?=
 =?us-ascii?Q?aRYq/7OwwtiET78GbNeqkbVld/8FxqBxMC0BspjBJ9nsOsld1RRdEL6zdaFd?=
 =?us-ascii?Q?rQo6KODVWYcX7ITb4Be3VvLUtQGyoYUvm0b/I/z3AhbVslN0xoX94z/Mc2NR?=
 =?us-ascii?Q?Qgmw5pVqhBE+T9BglieFKD0z2gX6rhW3uD1joE1LhofaFzX4fbGCke0qOHnn?=
 =?us-ascii?Q?oLbeSV2iuzwqfDNPXGqya9yhycRac4TETw0HzdGfBXM1tKjMxzyDAxhiIDfG?=
 =?us-ascii?Q?JMZYcr85305irpTKbw7fQzXLO06g8T4T3oFBo1B5RzFNZijR15WUdF/j8AzY?=
 =?us-ascii?Q?vYNyuhArj+TeYGxwIbv7tBjeQ2c3P/hy8SKOaPqVCKJIyM6u1/b5h1b05JGp?=
 =?us-ascii?Q?N1tVZ8cYlIywmNoVFTgmok2Ah3bBaSqD1wz3iTlNKnbPEqKRM4NJPPXyXDK2?=
 =?us-ascii?Q?HzYRnOFhJIrP78UZ2wrNYig/JSEJpb/N1hL+OMNIjteR2taBb1Qd7Lkjftmo?=
 =?us-ascii?Q?2+2fQBWoCvY/jeGy9JdeeHqdU43cEVsgq6JUGJtGn/qycHMii38zBhU7WNLZ?=
 =?us-ascii?Q?PPSgvlETnS/8DaBiQiSrYtYT0q5KaoCHoGcNnPFvKxY6VU60KrYx19k/s0s0?=
 =?us-ascii?Q?RwbnwR68bqkPL0DR6iiPHLJvMNoCAKz3idEJyoBlyDRG2AuYPNpeqNekOWqA?=
 =?us-ascii?Q?6xohFRzqNtT2wpx8inwOeYYRygCgMomAQ0803mz4x/gyNPRiWsvy0SI9QFUu?=
 =?us-ascii?Q?PV7drJ+Mr8nOAIk0GMRqDEMqL5nVZ6gQumq6MkNjkSkR02i0aCS/hNqDteUi?=
 =?us-ascii?Q?5CUe8gNiG3WqyDGjz5LBLvxvesji1w44Bo7wnadApmjb7GejZJJQTWz/MVZQ?=
 =?us-ascii?Q?aRubnJXcGrbwgQuzrPSHDiN8UDHuEs+ZOpS71zU+gBPa0yzQ4Fhc9h3ghSHQ?=
 =?us-ascii?Q?VEIz/cSdEQiKEq9A5tkRt5zjm5WTc7aoPc6ubhmsEvFnnKyXXojCOT5J7eiO?=
 =?us-ascii?Q?9e0Z4r4UBoM0VLM0i9UH3JRwHNqKIvmeq6LsSZfi02NZNtYrp1LlPNPVf6F+?=
 =?us-ascii?Q?w3yS10YdGuPcqFMM+sYnmEhlyZXHUi5vuXuUeKmZt7gTsYVrX9sUkzW8S9Ry?=
 =?us-ascii?Q?3zrnO417g6qFUpB+3D7W5jrdjuuDjC4JDHmmVm7yJmAkhkphgAMXvx8NmdOt?=
 =?us-ascii?Q?aZx/B1D01JoSihFDzp1nkN/tYCQF2XdBo7oQSI1dcZQuzbZO2ppYQUN5q+TD?=
 =?us-ascii?Q?4UgsMHGjW/2Km6a5pknygVJX29HFLqlm5kJqrn3NnWW0nYGwUQievtkuJyl3?=
 =?us-ascii?Q?pGraMNwtqNSDykO+OINwxVArk6f4tz7wa4KV2wSt0MWGawev1iPxmkfwHN/Z?=
 =?us-ascii?Q?VJv7SVNBD/jFLZ63Cj33dCu/SOOCRDH41zePyMGQLWwp6j9Zd16KuFMzU/cq?=
 =?us-ascii?Q?dzbrhIjgtoxT7l6vQrJxhbPcE8XWsuChOt0AZ5EvxHfg3O1MIAzz7qJi2YX+?=
 =?us-ascii?Q?wa2ZntrwHCJI8ThOqxXwUDBJrmp8CzUsNrNLan1385TOlFilYO7iisqaL2il?=
 =?us-ascii?Q?N++giM9sVDxMD40T947JUMMA4KwodEDvOZ/6BU0UixQTgfLkmN9EqNBCnNhA?=
 =?us-ascii?Q?r0OfZIThXwXSMxmV7x3axK5flAn/rSNxdb+hvkLI1vCgXX3YLO2IOeYPAzk5?=
 =?us-ascii?Q?GZCOSw=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(376014)(7416014)(82310400026)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	sC/Nv6R9yotm69sBx0WzQkok+MYIlcLRsmkFL7ek3jS0H7zTZ5rxYI0thKdTUrTzL4saLkD6mb1KqzYEzjLKFRG4RJPbvCCFvN+OZMW2rWUHuK3fRt1CpI3+mnLK/FDBang85EQ4/JHNVBtJ4oRpHx58/wllAImR/lozGmoWs7r04Gqm/268fqPUDc0JXRynT1Eljb4fuqtQJnYDt8qyyURb8zuvVp06Pd3bjYTJUQhmXiYlmgUiY19/ot1g2qF2LNsL5HDWRMH+JfydWLHkECil7maSudnPMK2jZ5aFrHfS10zR0ZDWgFCaerphLLdT221qQ/hHghaBFcX1kibKJKHIOWJzN1VqrRSzqj+JLbHdENs4bRL+PdDPuJxdUEi4H/zGSTRqvfJ7WqaJnfomar4AxGrNRmEm9tR630bZ9quhKdyXvSTe3a4iwwk747ga
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Feb 2026 17:50:17.3569
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 4e684234-07e3-42a9-36c0-08de634cb135
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF000023DA.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB7325
X-Rspamd-Queue-Id: ABBBF80002
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: 8j5zs3w99og6whstizw4qqe6rswkp848
X-HE-Tag: 1770141024-204348
X-HE-Meta: U2FsdGVkX1/6cqKFPrJ7TgpGAF20Oyzn2S2nD3PMbPrFNWn+NuamQ2IsknZFq6sJJUe+Q6SBqR61qX022WmVyK4XZvlLPt5Rf35BZagaQRD14ih9xyli5cpIMl75FGUPPZniMXriareR7qY/z2Km/jBW6fOfECsHHKgQFkT7Fs7Zd6Pp91xIp8X/mFwSEAijBSDT9E1wjubJuIPlFp6Xa71yfN/xp529tV1O6oQ30LZCc36k1SALr/8VcsLe7hqCAyAluAJaJKc9h1mSV9RKiy0EkfwywSZ6cItYJxTqGv0RvxxkSSWLVdW3OLWfKd5UAvssNl2PxXZ8RTUhNx8vwYgM+Q7nZKsgJsDjY3V4XECdVj0sOLl7dltZSuvGkdYo9aIWfFuFO2Rjw8zTLYqYAS0ph6wRF4icy3+d5ZW+Y6PJuSgHcBBxoj1XPNNrh8S8227zVGg8qd3qaCgLff41VZnxkcRcFQ5VM2dtVuD5ISUgUMXdyX5RTfok6MV8gR0K38xjuBH8CjiYxUDfo9WDqzrbHdOMJh4P+YGlmmZ6mjVRrui6guUSwa1o0UmzvQZ5vLU7OGp1qVxtvehiCQ9Tu/DY9Y/WH3HHyuT4Q6JQu4WQkt4tXGGnhf/vXdalT6jyP0FffwCL15/cAZcEEjYtF7xcV6Qcm4RV/oWpeiiWbXdI9epDkNJx7lpAy44bCNCeTUD2Q1t9lAq1jeSyxa+Q2+i1lx4Sfshq5TAS/67lyJtLXb0LuaxpzOy8VpuKfrADherVFAwfb9EVtB3huZaacjnnaDYr5iiTjF0AK81b03wqYrH2POnjF28Tw2lgLihOLy1jRiuUzzPRpqQ39aXnZ3+hOXqjBlAHW/r5ZJfkx/NG6RLiysUO7JuyW1Vkv7hfTWWPbOFC1tqls2q38bIPqTHe8Y7psSvBU0LEi1FfHS93GC5xU4iJID5qm3jA2ict869xf/hlNUrsG9gGvi+
 fOplGuH3
 JEmtRLJXETaHiqYbmmMJpVo8HyjqeA52BMM9LYiv7McwMCLSQwS1AbsWTfN4sBRAOwHwptvGwPJlwa0x2KBgYY2YOx2zWKqufvgJkm1FKPdJu+DEHJTxtnQhQ9Yzpcz3grJqF4lqGHK6Y1iNPMkbPERrgyc6Xj4fh1/IJd24IVRL8qW79Yp0CA+Utbxslwjfdj8h22lrSQDuyJ46+KKkO3XoteRl8kZG8NjdbcbL+uLUhoo71g1LgA6d0j7RNr29Jx3DBOQrpMZHtoYy0ycIItxUokOfRFSAPFyAzv4QSBowsL3md7gHztAv8Y2HXFUCu9KnZ5A1lwLHR18x7R4Or8qpSMu+fKgQOQjxvuZhJHK+lgtFIoL1bLK6aLbzmDUBssLJPrZweqql3/E4TyTfasJGnik+ZCLv9sVHZvgOgzJ0o1FkO6djaxDn9tVKsishEN6Heq15v5L7IhRD4mZ+UjKUPx36dgzKir8IsT/12hpZ3oB8p88WB2SCCUpl37gdQ4ICZF388FJVvIbOdT3Yruooa2LSUt9+uhW774Tql02JbFQGFt7ui6J6JQVD980Jh59qmquwk0a/Ub/lbsQ2adyhDUQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Transition memory to the shared state during a hot-remove operation so
that it can be re-used by the hypervisor. This also applies when memory
is intended to be hotplugged back in later, as those pages will need to
be re-accepted after crossing the trust boundary.

Signed-off-by: Pratik R. Sampat <prsampat@amd.com>
---
 arch/x86/coco/sev/core.c                 | 13 ++++++
 arch/x86/include/asm/sev.h               |  2 +
 arch/x86/include/asm/unaccepted_memory.h | 15 ++++++
 drivers/firmware/efi/unaccepted_memory.c | 59 ++++++++++++++++++++++++
 include/linux/mm.h                       |  4 ++
 mm/memory_hotplug.c                      |  2 +
 6 files changed, 95 insertions(+)

diff --git a/arch/x86/coco/sev/core.c b/arch/x86/coco/sev/core.c
index 9ae3b11754e6..63d8f44b76eb 100644
--- a/arch/x86/coco/sev/core.c
+++ b/arch/x86/coco/sev/core.c
@@ -703,6 +703,19 @@ void snp_accept_memory(phys_addr_t start, phys_addr_t end)
 	set_pages_state(vaddr, npages, SNP_PAGE_STATE_PRIVATE);
 }
 
+void snp_unaccept_memory(phys_addr_t start, phys_addr_t end)
+{
+	unsigned long vaddr, npages;
+
+	if (!cc_platform_has(CC_ATTR_GUEST_SEV_SNP))
+		return;
+
+	vaddr = (unsigned long)__va(start);
+	npages = (end - start) >> PAGE_SHIFT;
+
+	set_pages_state(vaddr, npages, SNP_PAGE_STATE_SHARED);
+}
+
 static int vmgexit_ap_control(u64 event, struct sev_es_save_area *vmsa, u32 apic_id)
 {
 	bool create = event != SVM_VMGEXIT_AP_DESTROY;
diff --git a/arch/x86/include/asm/sev.h b/arch/x86/include/asm/sev.h
index 0e6c0940100f..3327de663793 100644
--- a/arch/x86/include/asm/sev.h
+++ b/arch/x86/include/asm/sev.h
@@ -514,6 +514,7 @@ bool snp_init(struct boot_params *bp);
 void snp_dmi_setup(void);
 int snp_issue_svsm_attest_req(u64 call_id, struct svsm_call *call, struct svsm_attest_call *input);
 void snp_accept_memory(phys_addr_t start, phys_addr_t end);
+void snp_unaccept_memory(phys_addr_t start, phys_addr_t end);
 u64 snp_get_unsupported_features(u64 status);
 u64 sev_get_status(void);
 void sev_show_status(void);
@@ -623,6 +624,7 @@ static inline int snp_issue_svsm_attest_req(u64 call_id, struct svsm_call *call,
 	return -ENOTTY;
 }
 static inline void snp_accept_memory(phys_addr_t start, phys_addr_t end) { }
+static inline void snp_unaccept_memory(phys_addr_t start, phys_addr_t end) { }
 static inline u64 snp_get_unsupported_features(u64 status) { return 0; }
 static inline u64 sev_get_status(void) { return 0; }
 static inline void sev_show_status(void) { }
diff --git a/arch/x86/include/asm/unaccepted_memory.h b/arch/x86/include/asm/unaccepted_memory.h
index f5937e9866ac..91f01ad0ee03 100644
--- a/arch/x86/include/asm/unaccepted_memory.h
+++ b/arch/x86/include/asm/unaccepted_memory.h
@@ -18,6 +18,21 @@ static inline void arch_accept_memory(phys_addr_t start, phys_addr_t end)
 	}
 }
 
+static inline void arch_unaccept_memory(phys_addr_t start, phys_addr_t end)
+{
+	/*
+	 * TDX platforms do not require the guest to transition pages on remove
+	 * rather expect the VMM to remove the unplugged memory from SEPT
+	 */
+	if (cpu_feature_enabled(X86_FEATURE_TDX_GUEST)) {
+		return;
+	} else if (cc_platform_has(CC_ATTR_GUEST_SEV_SNP)) {
+		snp_unaccept_memory(start, end);
+	} else {
+		panic("Cannot unaccept memory: unknown platform\n");
+	}
+}
+
 static inline struct efi_unaccepted_memory *efi_get_unaccepted_table(void)
 {
 	if (efi.unaccepted == EFI_INVALID_TABLE_ADDR)
diff --git a/drivers/firmware/efi/unaccepted_memory.c b/drivers/firmware/efi/unaccepted_memory.c
index 359779133cb4..d11e7836200a 100644
--- a/drivers/firmware/efi/unaccepted_memory.c
+++ b/drivers/firmware/efi/unaccepted_memory.c
@@ -256,6 +256,65 @@ void accept_hotplug_memory(phys_addr_t start, unsigned long size)
 	spin_unlock_irqrestore(&unaccepted_memory_lock, flags);
 }
 
+/*
+ * Cold-plugged memory used with lazy acceptance may partially set pages to
+ * private. On removal, iterate through the bitmap to unaccept those ranges.
+ * For hotplug ranges beyond the bitmap, unaccept unconditionally.
+ */
+void unaccept_hotplug_memory(phys_addr_t start, unsigned long size)
+{
+	unsigned long range_start, range_end, bitrange_end;
+	phys_addr_t bitmap_end, end = start + size;
+	struct efi_unaccepted_memory *unaccepted;
+	u64 phys_base, unit_size;
+	unsigned long flags;
+
+	unaccepted = efi_get_unaccepted_table();
+	if (!unaccepted)
+		return;
+
+	phys_base = unaccepted->phys_base;
+	unit_size = unaccepted->unit_size;
+	bitmap_end = phys_base + unaccepted->size * unit_size * BITS_PER_BYTE;
+
+	/* Unaccept the entire hotplug range beyond the bitmap immediately */
+	if (start >= bitmap_end) {
+		arch_unaccept_memory(start, end);
+		return;
+	}
+
+	start = max(start, phys_base);
+	if (end < phys_base)
+		return;
+
+	/* Unaccept ranges when start is within the bitmap but end is beyond */
+	if (end > bitmap_end) {
+		arch_unaccept_memory(bitmap_end, end);
+		end = bitmap_end;
+	}
+
+	start -= phys_base;
+	end -= phys_base;
+
+	range_start = start / unit_size;
+	bitrange_end = DIV_ROUND_UP(end, unit_size);
+
+	/* Only unaccept memory that was previously accepted in the bitmap */
+	spin_lock_irqsave(&unaccepted_memory_lock, flags);
+	for_each_clear_bitrange_from(range_start, range_end, unaccepted->bitmap,
+				     bitrange_end) {
+		unsigned long phys_start, phys_end;
+		unsigned long len = range_end - range_start;
+
+		phys_start = range_start * unit_size + phys_base;
+		phys_end = range_end * unit_size + phys_base;
+
+		arch_unaccept_memory(phys_start, phys_end);
+		bitmap_set(unaccepted->bitmap, range_start, len);
+	}
+	spin_unlock_irqrestore(&unaccepted_memory_lock, flags);
+}
+
 #ifdef CONFIG_PROC_VMCORE
 static bool unaccepted_memory_vmcore_pfn_is_ram(struct vmcore_cb *cb,
 						unsigned long pfn)
diff --git a/include/linux/mm.h b/include/linux/mm.h
index 2d3c1ea40606..49b194cddda7 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -4505,6 +4505,7 @@ int set_anon_vma_name(unsigned long addr, unsigned long size,
 bool range_contains_unaccepted_memory(phys_addr_t start, unsigned long size);
 void accept_memory(phys_addr_t start, unsigned long size);
 void accept_hotplug_memory(phys_addr_t start, unsigned long size);
+void unaccept_hotplug_memory(phys_addr_t start, unsigned long size);
 
 #else
 
@@ -4522,6 +4523,9 @@ static inline void accept_hotplug_memory(phys_addr_t start, unsigned long size)
 {
 }
 
+static inline void unaccept_hotplug_memory(phys_addr_t start, unsigned long size)
+{
+}
 #endif
 
 static inline bool pfn_is_unaccepted_memory(unsigned long pfn)
diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
index 549ccfd190ee..21b87f2af930 100644
--- a/mm/memory_hotplug.c
+++ b/mm/memory_hotplug.c
@@ -2240,6 +2240,8 @@ static int try_remove_memory(u64 start, u64 size)
 
 	mem_hotplug_begin();
 
+	unaccept_hotplug_memory(start, size);
+
 	rc = memory_blocks_have_altmaps(start, size);
 	if (rc < 0) {
 		mem_hotplug_done();
-- 
2.52.0


