Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3FE3ED46BFB
	for <linux-mm@archiver.kernel.org>; Wed, 28 Jan 2026 20:41:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8B96E6B0089; Wed, 28 Jan 2026 15:41:31 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 89A6B6B008A; Wed, 28 Jan 2026 15:41:31 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 772636B008C; Wed, 28 Jan 2026 15:41:31 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 64F176B0089
	for <linux-mm@kvack.org>; Wed, 28 Jan 2026 15:41:31 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 04AA51407DC
	for <linux-mm@kvack.org>; Wed, 28 Jan 2026 20:41:30 +0000 (UTC)
X-FDA: 84382543182.01.BAAF921
Received: from SJ2PR03CU001.outbound.protection.outlook.com (mail-westusazon11012011.outbound.protection.outlook.com [52.101.43.11])
	by imf19.hostedemail.com (Postfix) with ESMTP id 08E2D1A0008
	for <linux-mm@kvack.org>; Wed, 28 Jan 2026 20:41:27 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=BQCILeAv;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf19.hostedemail.com: domain of PratikRajesh.Sampat@amd.com designates 52.101.43.11 as permitted sender) smtp.mailfrom=PratikRajesh.Sampat@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769632888;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ipvvnKrx1SakS7+MZbzrDKkStXoE5z+0Ps3X61zY/EA=;
	b=y0uGl86EFfOaBIxgMnm7uAhFu0J6Kfg7UB2GHeHu0UrpNhbqQsuyieLmzETQu8mx+bhHpl
	wLHqKg3w4+qOIivSnXyYm8uv5z7YxvgtNN5bM/V5iznUwREYELe+7t1qSMC46KZxufF5HF
	LRmyh4dFkaDgc4rYJaiz4u/ySymTw3E=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1769632888; a=rsa-sha256;
	cv=pass;
	b=0TIKEjgnC3Nd+c83JHkqUq9XROrQ6mdW0yb1lFEABhTZwUT17R+8HgsO68GdUox1g7H0al
	V7qYR1ODXG4OExGbHxw6TcWIVSgUifWmJlSxxVshIDOjgf3AKISF7SWbVddc9Gkbi+4zRD
	UouB8aLlLA1AlKxoVHKFNn9uD8sFuII=
ARC-Authentication-Results: i=2;
	imf19.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=BQCILeAv;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf19.hostedemail.com: domain of PratikRajesh.Sampat@amd.com designates 52.101.43.11 as permitted sender) smtp.mailfrom=PratikRajesh.Sampat@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=BU9135inF9PGBmbEzcderSCRTtfMYDqflNLn3dY0t+CsuSmhltykwW9Qjr0cucEUUiYx2BiwrtjYZJnEN6OuOechWD/c4CqJy/s77mphxC6MdIyusiJ2ETMZFGg3ZX5ngHjyoVBhYyP/8q5yyEzpTy0tWFfvSTtR1HAm1xeK+rGC5feUsnBKc6g6RV3Kn6xGjXBt+gFoSilAVFBAERfZW6E7oJKCjHIWC7dj7FKyNuDpn3U42g4OuiMjOChrTAPO49Vn45ATH27CcYdLdnj5I3QHaGsmzWMo0c6d4wLfSzXaE3Ns0qL0FEeuHVzoBkYVDhi1X6qXDTN7TzDjrqX/jw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ipvvnKrx1SakS7+MZbzrDKkStXoE5z+0Ps3X61zY/EA=;
 b=W9upoieSPRTxIcBC33FnoDv9vLNLOxv2FI/cC3tzMD4A26I2q4oKT1ZuTV/MhxTyY06eBi9z88ujPakWCFzbOo5U/MgZLRFh/yT2wyWv1K4BDSGVfV8axC7+WpLN67haGfC5yImWoNmaSL7SEnOw1whS4VPJGnvjISm1dBj4wePp7Amf1HPG8DL8nlzVpMK9jxnGlOMeIsijZ/c1POYzEGX+Un/Vv9YP6tJRvESmKdy5qOwc1+0CRM/QEtrxaGk+11XR0P5LDp1Tp6TSD0rEBwyWB+WzwUlynDVjqonRgaaOhmctO4iX5Eb/SrWLZsimnaI+1/I/kBub1eGvPVlb1g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kvack.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ipvvnKrx1SakS7+MZbzrDKkStXoE5z+0Ps3X61zY/EA=;
 b=BQCILeAvw9hXyMm9T5g/Llkf+0/ixbigVqx6Y9U44+C6CRpFD8fHyzWhVofHKCXKkQCd2KqReDTeRNsW9LEhZHKNYGSgdaidxMdEGIsUwomc28L8+/7c6V8HqvUt/lcuBDgPdaqKg7BaXDd9zXO5xk9PWAFpMzlBTJsZNe613hM=
Received: from SJ0PR05CA0134.namprd05.prod.outlook.com (2603:10b6:a03:33d::19)
 by SJ0PR12MB6710.namprd12.prod.outlook.com (2603:10b6:a03:44c::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9542.15; Wed, 28 Jan
 2026 20:41:23 +0000
Received: from BY1PEPF0001AE17.namprd04.prod.outlook.com
 (2603:10b6:a03:33d:cafe::a9) by SJ0PR05CA0134.outlook.office365.com
 (2603:10b6:a03:33d::19) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9564.7 via Frontend Transport; Wed,
 28 Jan 2026 20:41:23 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 BY1PEPF0001AE17.mail.protection.outlook.com (10.167.242.107) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9564.3 via Frontend Transport; Wed, 28 Jan 2026 20:41:23 +0000
Received: from ellora.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Wed, 28 Jan
 2026 14:41:22 -0600
From: "Pratik R. Sampat" <prsampat@amd.com>
To: <linux-mm@kvack.org>, <linux-coco@lists.linux.dev>, <x86@kernel.org>,
	<linux-kernel@vger.kernel.org>
CC: <tglx@linutronix.de>, <mingo@redhat.com>, <bp@alien8.de>,
	<dave.hansen@linux.intel.com>, <kas@kernel.org>, <ardb@kernel.org>,
	<akpm@linux-foundation.org>, <david@kernel.org>, <osalvador@suse.de>,
	<thomas.lendacky@amd.com>, <michael.roth@amd.com>, <prsampat@amd.com>
Subject: [PATCH v3 1/2] mm/memory_hotplug: Add support to accept memory during hot-add
Date: Wed, 28 Jan 2026 14:41:04 -0600
Message-ID: <20260128204105.508855-2-prsampat@amd.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260128204105.508855-1-prsampat@amd.com>
References: <20260128204105.508855-1-prsampat@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: satlexmb08.amd.com (10.181.42.217) To satlexmb07.amd.com
 (10.181.42.216)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY1PEPF0001AE17:EE_|SJ0PR12MB6710:EE_
X-MS-Office365-Filtering-Correlation-Id: 41a0cf5e-203a-4123-11f6-08de5ead99a2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|82310400026|7416014|36860700013|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?G3Lfy/UjjUAuyOuBAgK1ClIc1mSHWG6G/YVjBEklL7kmH2/08cfN/26EHRk9?=
 =?us-ascii?Q?JJLUA9OfE3cuRPJ6nSjcfLxzCmMG/5DmniHr7laPTVz6sDDN7lwRpoZDmIaL?=
 =?us-ascii?Q?QpAdTtgloIJ9ZV+iW2C/zB9CiIlnymQpbA+HuqEe/kXZrmY9EfX7xvw03nuf?=
 =?us-ascii?Q?DO8Yu5RGfYKv4fbB0uwl7TA7jvKLFkEKa3tSvN79l5+kCyfP/rmKyShOR9Yf?=
 =?us-ascii?Q?9lj5pIC4dZyLfPAdQ21oi5SZY41Giubk9WpXmeNoWsBVUOOs2ti3gi9cVO/U?=
 =?us-ascii?Q?BQqrXyC6qO0Oo6xDuh6mus38+GJueNcl8VKXdWwbNjEwJtvi56y0aFf1VdE+?=
 =?us-ascii?Q?w86p5hYwG59naUIcHVm2HZX4MnP8R2rhmhGuMj7Kw7PS0q0mdugaT1/WRp4i?=
 =?us-ascii?Q?kLUjiqdIt+UzBhYA8N8PLHZz1F16xvDbrNvytQh7UbGfzsupHn4U3N1mJarp?=
 =?us-ascii?Q?OrvB8wEq+vepox9XXrnIie859ToF8MmbkEq03cl3obp5DYxoNW8n+gG7Z0qw?=
 =?us-ascii?Q?Fw3ZIijfemy7HecNiRhfT3YKBF9lOwM3yO6oCdugKUN/BOlsAs9G2KT6/gy7?=
 =?us-ascii?Q?2LvtvcScMnmRQIjrDB6mfy0mgp6ZnZFb91aXhYfbrRCcvyCo0r0yIXzl+9+u?=
 =?us-ascii?Q?WSzEvnM/4cRl2oupInVHWS6KqRpkXDUmc8mf+1+DNDN0gjILuQANMMiu+ebv?=
 =?us-ascii?Q?Ip3IXI6pdaJeLhkC8Wwz4h6djIWkMPVIS0U9I2XhFbgfwW1VT9oxHAEc9P/Q?=
 =?us-ascii?Q?P/KjT2kHhZUrFUOiFo97CBp3IUl8wyAVpPR2+Cq0fzCTZuLO/xDvgdUYBI++?=
 =?us-ascii?Q?REusK6quNjBbEtuFiUQ8ErOJ0e2V3umeEDUTuAbk6kXh3VutV5Jn5Y/OeXGG?=
 =?us-ascii?Q?772hUytNWidKDqRQMKoF6VUrf2mr50Crf/h2krYuxMaurCW4PtscscXUr27S?=
 =?us-ascii?Q?1yYeSs02twB1UBNtUZ9xLKsPjWngJYKFgxDXJmZKMBdDEvsfnWkhqs7MS3Jy?=
 =?us-ascii?Q?YGP/S9RHYaCETGAsfUhB6dLFYTBBV3LvehVpVCyl5jxaVrN3ZZ6K8VX2m/cm?=
 =?us-ascii?Q?mIaJq0+y3jAA2LcICsX6tLo/4JL6nIFTt4gWSRqIxyc6ZB+K8OGTFPbGTVBN?=
 =?us-ascii?Q?lthhDMobqZvucuocFta8GWZEKAhzZywI7ea9yHDTlvx/3LpeJTSHAHdgx4NJ?=
 =?us-ascii?Q?WZg2r3oyeyCtohxXyZ77UUZHcR0l+iujiv5D5EiwOd/CBhT2s51ZhqVLRB3d?=
 =?us-ascii?Q?qJ+FXnQ6dYI8qnCJp36VQg0wm52wRLPRBXiBw8XbFn8dooXHas2v0DvIPkGq?=
 =?us-ascii?Q?/rekHyxZx0MJcry6KhByXu13Pjo3KLTi/7/pDql5EUBRCKwwgMyYnqPD1hAr?=
 =?us-ascii?Q?e+dqR6O1lv1URa5nluYYYiTS+M7/dnpdozcx4RM4Idfwl89ssetoOdHIiavJ?=
 =?us-ascii?Q?90Ae3YaFsVfHQyp6lJzeQekrTFxb+z/Voa0ZnmeBVnRZ3dMfsYCqey8c8L2y?=
 =?us-ascii?Q?HNAGjbSDbgsLKXmBdVy/tcVzSBmEva5RbSlg/jDUKGBbi6b92ybhMIMHVzTU?=
 =?us-ascii?Q?8pkwhY1B6ohdp9aOk4nb6kilK7mRs+FhXnhDk2ERbFnAcyP1QuKa3S0nDQ7z?=
 =?us-ascii?Q?ucpoTGqp8wNU0qu6Kf9oIcIh5YSklxbeOdon2TALDZyCVoOD4REp0aHnKU5p?=
 =?us-ascii?Q?Dijnrw=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(82310400026)(7416014)(36860700013)(376014);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jan 2026 20:41:23.2230
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 41a0cf5e-203a-4123-11f6-08de5ead99a2
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BY1PEPF0001AE17.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB6710
X-Rspamd-Queue-Id: 08E2D1A0008
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: 9x3yqzg8ikshgbqbqehebrh9pwztdioi
X-HE-Tag: 1769632887-10043
X-HE-Meta: U2FsdGVkX1/jIzaYBtnoVKOHLGogA4eGrv6LDMXIp72Rw5EqWk9PLD1zYDaw3AHFo7NHzFg9w5hFzlu8R3uDm0RAI2ziRQWJ1G5TS3/WdUIhEmKtjzaFMGDpRgJm8vW1GeicfqH8fosf7ZbO9aIs5BNhAjlk/ULeKkx/FTL2Nh3tY1htekC4TpcC5Yl2WAoEEGpVgNVgp3jlGuzn5lLlrkM0kSVtJ7IwPMSYL5x5b2PQIc7c8GD1zVqBWhhcq8flrldcMT5oPYnSOQ1Do4MkTRoJnnueDU3kfOJ73KznhF19AuglxfEa0+z1Jp2Yx8T/YoP1l4VbgaNoN138LRnB5QKjRAOLpbjZvKSV/1cialKLVEDbGhkdmMvQ+/8EY6R8e5DyifYD7zA7pCTPCmFfuK9bLYheGv5GbQ4YfUSSdi6OT5hNSRsf4KXu3q/POhCMOKTE6KGN9rnD6NnedqYQiyNKcTlxphAL/PU34I0Wb5jkjL20ldLniTz+NDQ1bJAqzxXzXuHohkSVppK120NeBSpXxK5a78DB/F8pRZ6eNju0QDiHHHK0syQsbObPjLMyaHD1y79dxnvAEXO8C9Q8ST1rXhDyqgG+M97yFvPe15RCGht0R/8Myu6tmoqCuGqwj99Rr54mKghSrFbsAHUF4fwJcgn5YIxp0Srxbq5yGEFfLL30ekFqIC/3LBiAlR9b66JfVn0JPkltBj48BurVyzHCVy/Sti+KIrcUZwZLUFHIbIQrvjHn9hQCM/nWpxT1QXhvNJ1hWWMd++uTfxOL5tFMuq2xJ7dF86saK2cTCkuj6sCZfELoytKgMfT18yKHVHy0nbiXCyqa+KTgAaGauikq0sVUSTtNV1a75BHf33B7I8M6Ssjf1isWqw7e9qZPncB9QwfzZXnujwDjmnAjVF17uGK2uUEL/yeB5eEBYTcta7YtjgB7MGB+aFlZjTScY/xsdIrH9qVUS7avuQC
 b7VW4QQ+
 lWP76l7Uj3NY+eoCASkyd0MyyugW5utwsETf74Wqga5uXUlyxF/3EWQH2W24mIgo8Wd28iQkuk2vqz9XRmeX2yCXu8B81nkt7TUPSX9ZEGcILd8NOTe5VOx/LieAsz6GxkPSWp3Yz3p6WBUoeHp3lM8IuG3J9G6Ex97F44Tmyo6ikFO3e2Hv9rndOlN/RtzvFNXTl3GQiaG5A8HjbeFzuOGdhjINx6ZBO1DSC/z/YAYsSFlXRxiD/sy6PMDkYl6Ag+Uml4QwZMglfA4UCjownTAqYRJSC+KDLPPVqpFjlMRE4jJYOMYxyRtQSqwtrnPbGcQbxmSBn4DjtWMprx2YspqkGRvy9dO/KVdw8E4i6skkANilVRkZV2M/EZKmyQbnwEq6Gi6tIO/A/7y0YpSXFT4RWSEzd6Y8IRch8LeHxcxH5vmlOgt/3qf0r8ZqpnF9KA8Q3M9fqzl2vbvHrYsr740GAF7SFP2ac0Xg+gqskDaGHNCVoH3NFr/2XTxcd7X+sA0pNmCNK/J79x94PganXirq1Ykrrk9aWJcmOjW4QRH4IjaMY9ig9Z1rmZ4tM5128PB8okx7vQqRY8bwKV5x83+d4iG77ZyI3gIHsip6wRbhFaqtcGJ6hp7MZNS017o/B+wZ+RICXQRjQt/A=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Confidential computing guests require memory to be accepted before use.
The unaccepted memory bitmap maintained by firmware does not track
most hotplugged memory ranges apart from system memory annotated to be
cold plugged at boot.

Explicitly validate and transition the newly added memory to a private
state, making it usable by the guest.

Signed-off-by: Pratik R. Sampat <prsampat@amd.com>
---
 drivers/firmware/efi/unaccepted_memory.c | 18 ++++++++++++++++++
 include/linux/mm.h                       |  5 +++++
 mm/memory_hotplug.c                      |  2 ++
 3 files changed, 25 insertions(+)

diff --git a/drivers/firmware/efi/unaccepted_memory.c b/drivers/firmware/efi/unaccepted_memory.c
index c2c067eff634..5a4c8b0f56c8 100644
--- a/drivers/firmware/efi/unaccepted_memory.c
+++ b/drivers/firmware/efi/unaccepted_memory.c
@@ -209,6 +209,24 @@ bool range_contains_unaccepted_memory(phys_addr_t start, unsigned long size)
 	return ret;
 }
 
+/*
+ * Unaccepted memory bitmap only covers initial boot memory and not the
+ * hotpluggable range that is part of SRAT parsing. However, some initial memory
+ * with the attribute EFI_MEMORY_HOT_PLUGGABLE can indicate boot time memory
+ * that can be hot-removed. Hence, handle acceptance in accordance with the
+ * unaccepted bitmap. Otherwise, perform the state change for the memory range
+ * up-front.
+ */
+void accept_hotplug_memory(phys_addr_t start, unsigned long size)
+{
+	if (range_contains_unaccepted_memory(start, size)) {
+		accept_memory(start, size);
+		return;
+	}
+
+	arch_accept_memory(start, start + size);
+}
+
 #ifdef CONFIG_PROC_VMCORE
 static bool unaccepted_memory_vmcore_pfn_is_ram(struct vmcore_cb *cb,
 						unsigned long pfn)
diff --git a/include/linux/mm.h b/include/linux/mm.h
index 15076261d0c2..2d3c1ea40606 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -4504,6 +4504,7 @@ int set_anon_vma_name(unsigned long addr, unsigned long size,
 
 bool range_contains_unaccepted_memory(phys_addr_t start, unsigned long size);
 void accept_memory(phys_addr_t start, unsigned long size);
+void accept_hotplug_memory(phys_addr_t start, unsigned long size);
 
 #else
 
@@ -4517,6 +4518,10 @@ static inline void accept_memory(phys_addr_t start, unsigned long size)
 {
 }
 
+static inline void accept_hotplug_memory(phys_addr_t start, unsigned long size)
+{
+}
+
 #endif
 
 static inline bool pfn_is_unaccepted_memory(unsigned long pfn)
diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
index a63ec679d861..549ccfd190ee 100644
--- a/mm/memory_hotplug.c
+++ b/mm/memory_hotplug.c
@@ -1567,6 +1567,8 @@ int add_memory_resource(int nid, struct resource *res, mhp_t mhp_flags)
 	if (!strcmp(res->name, "System RAM"))
 		firmware_map_add_hotplug(start, start + size, "System RAM");
 
+	accept_hotplug_memory(start, size);
+
 	/* device_online() will take the lock when calling online_pages() */
 	mem_hotplug_done();
 
-- 
2.52.0


