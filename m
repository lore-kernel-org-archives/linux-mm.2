Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 09793D3B7D1
	for <linux-mm@archiver.kernel.org>; Sat,  6 Dec 2025 10:17:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 64E446B036A; Sat,  6 Dec 2025 05:17:49 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 625A66B036B; Sat,  6 Dec 2025 05:17:49 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 514296B036C; Sat,  6 Dec 2025 05:17:49 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 37E2C6B036A
	for <linux-mm@kvack.org>; Sat,  6 Dec 2025 05:17:49 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id F1DD158F70
	for <linux-mm@kvack.org>; Sat,  6 Dec 2025 10:17:48 +0000 (UTC)
X-FDA: 84188645016.03.2FD02CF
Received: from BYAPR05CU005.outbound.protection.outlook.com (mail-westusazon11010067.outbound.protection.outlook.com [52.101.85.67])
	by imf02.hostedemail.com (Postfix) with ESMTP id DC48880002
	for <linux-mm@kvack.org>; Sat,  6 Dec 2025 10:17:45 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=xrb7TKUN;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf02.hostedemail.com: domain of bharata@amd.com designates 52.101.85.67 as permitted sender) smtp.mailfrom=bharata@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765016266;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rhrbxzHIppFUQyarUc+VlpeUzD6ZknPk8x64Kwb71+w=;
	b=b3SMV2w2IryRJFXDUffbB21ev8nPI1ThZMoDnVXvii5YbWr6s++wMc/QB5GGNIeY125V5c
	wM8bKjJL6MOypKWMQjIQwuOYD2BqmZKHbpk/dixAibYnnMeQusgBQKpzMpOEa8n28pFDaO
	ixZ1yLU+fzhuttqUzB/58kCcxRFsOd4=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1765016266; a=rsa-sha256;
	cv=pass;
	b=IeY98RFejkCbOVHUi83gn33T8M1es5IAoRkhBKGdhmBXTraK7GlTLvjfBB2P+aG1tajRru
	8cd6hYejbYQSXogzVnty3dX1c4V1eNH1egRDuZnsBoNX1Wi63d8imsqbEhTmJv4rmuzGgb
	wmdFctVlBGZN5khGVJoKSvLSz9I7Hrk=
ARC-Authentication-Results: i=2;
	imf02.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=xrb7TKUN;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf02.hostedemail.com: domain of bharata@amd.com designates 52.101.85.67 as permitted sender) smtp.mailfrom=bharata@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=dqjKcUIhFzSnf5BqGpKyoQr/rjdg/p7Grzic3slhPZK9hk9ysj1oGmGDyduxzVE0dg+uG4VeigmVS892feT6QnVhbyJkeYzTUhOTLtTqwK7X7zNZJhx4mMke0CvWa7LUozn5PL/qVMb5Zl7Mr4o5jagVnYas32bWcLvNwiWW5cYZmoI3lrQp91EoKRtxMZgfGtGKCimpNP2DCaEalAcebez50K1IEm2bBeSTOGea1QhAWPJzZANmM7tPwmu9fcc7Guoeal4vepVMiFkq5s8mLBDwUckb114Cj22XdGTWNzV6VVzT/tBvaGsd3MsiICcbSCpjomf/oJBYRonvr5qokw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rhrbxzHIppFUQyarUc+VlpeUzD6ZknPk8x64Kwb71+w=;
 b=gewOIdMWHuF0MLo8vn3T3mR/gk96CJJ8VI4GBEYR31witql8ON3IexCu+2RFtnTTNuI+l0yGhIJEUSJDq2fhSCnpwIa8V5KTrT32wiMl1MgtwK8w7b9Yo1Nj9yKylwvFCQnYCG/Vv5AcXYlcu4k5KrMYd0S52BCdjhwjGBf86bp20ZWMVM3ZWJmmjy9R847naG/C/mCbFbORNo/VZRdNLp/9IwV2sOFKQZWDKRbo8wJ5lSXI/DR/BZQdpMAJMp1mB/mlEAuuQL7EspjDpXm8ONFqcXho/6Mmd8L2rkeum9kcyq8VbHTXU0ctgkW99kEoRPwDF05PO+dKNKLvJJsM8Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rhrbxzHIppFUQyarUc+VlpeUzD6ZknPk8x64Kwb71+w=;
 b=xrb7TKUNe+T/tpFuTFgLZZ0k20qOvYTrsza94x8Ai0MpDzoKJEW1x7AXu0kzOcJ0yXymsy3zORRU65DEeRRmQ3xDKID/lLAqFSz/KO0hl2oZuhZAuwC1iPnG/6pRlXakXBcgTl+cuz1mFZTyn6e0KW9rRR1EXMI8TFqPAaqiZ7g=
Received: from BLAPR03CA0115.namprd03.prod.outlook.com (2603:10b6:208:32a::30)
 by LV8PR12MB9333.namprd12.prod.outlook.com (2603:10b6:408:1fa::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9388.12; Sat, 6 Dec
 2025 10:17:40 +0000
Received: from MN1PEPF0000F0E0.namprd04.prod.outlook.com
 (2603:10b6:208:32a:cafe::9b) by BLAPR03CA0115.outlook.office365.com
 (2603:10b6:208:32a::30) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9388.12 via Frontend Transport; Sat,
 6 Dec 2025 10:17:34 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 MN1PEPF0000F0E0.mail.protection.outlook.com (10.167.242.38) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9412.4 via Frontend Transport; Sat, 6 Dec 2025 10:17:40 +0000
Received: from BLR-L-BHARARAO.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Sat, 6 Dec
 2025 04:17:32 -0600
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
Subject: [RFC PATCH v4 6/9] mm: mglru: generalize page table walk
Date: Sat, 6 Dec 2025 15:44:20 +0530
Message-ID: <20251206101423.5004-7-bharata@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20251206101423.5004-1-bharata@amd.com>
References: <20251206101423.5004-1-bharata@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: satlexmb08.amd.com (10.181.42.217) To satlexmb07.amd.com
 (10.181.42.216)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN1PEPF0000F0E0:EE_|LV8PR12MB9333:EE_
X-MS-Office365-Filtering-Correlation-Id: 7fe11d01-5ebe-4e72-0ecc-08de34b0afc5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|82310400026|36860700013|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?lLIOsearM9icDXm5BDkP58XRhN4s0W1nxBGQvTXM5pk8AosD84pST1rikOLJ?=
 =?us-ascii?Q?djlwFMZyEYYwvJSc6a9SFSXaFUv6rP0oSAGPL+gqUODSlP/f/RItdXypVOV+?=
 =?us-ascii?Q?FOsg8OcbAfTTdPqmrErYaBTqTAMyRWddCKdIFyBwVxZUFk9S3XX5c6E799um?=
 =?us-ascii?Q?HCvD9r+pQXeCK809l8+yNMSN/glnwvEUJ5kgkYEfMAKq13Rsk8ZNx6j3oGF5?=
 =?us-ascii?Q?AVn4GZMHd3iTTQV8GcEwiYAo3p2KAzhVfv84BIcLQXcvACfAbRwVX5LEvR1q?=
 =?us-ascii?Q?STZ8zFQqDMccphBEDoKzDr9znk6/kAYlCqDMX1TOVShhPhYLV1WdPJBrz1yT?=
 =?us-ascii?Q?n9AQB7Jd65UWnwxxfms0Hz3gyd56AIfy/kHnN8vlKevDvW7042W6X3ZUQJNa?=
 =?us-ascii?Q?gPOgxE/V10dPned8xBr0bodS6AHx8509hFkYUbB7FO5L8qecwu0GUzhIux4j?=
 =?us-ascii?Q?UHNYipz3KH1fo0ZGEP27MCBPs91D8DLof9upxtgcI3qOqdBHuSspnHKfD4Oj?=
 =?us-ascii?Q?Uc0kxvHPsmJiIaxMBc5I5rdwlD8iGXAXJpvm06PQjjJPLJ5JUCElGtw4jagp?=
 =?us-ascii?Q?DlKjUaQv9+P2P7kFJVMYBHoHiSFbU7Gnbj61QyKwhgZ5rsthhHPK7k8FtfwX?=
 =?us-ascii?Q?ijuBX0fV/bW+QUTiz3gY+Tx3zJL/r+gKXNiwe270rhURnauhoUqTgYS1HpfH?=
 =?us-ascii?Q?QuUQNZCisjMtRWssWylsJpd34sbBjo3neoGCFbkGvg8DTBpcZWEaoIl1oOFt?=
 =?us-ascii?Q?gHRThGceKjPoTFlAgfL1ql0pbjSectaNCJgAAjfz+VcZihIS4Ai2xkTF6FfH?=
 =?us-ascii?Q?WlPKbM+UBqU+00pf5+JES44z7y5rCAEdBGAa0EuiHB809GZKb4VMD1QWKO+C?=
 =?us-ascii?Q?jGvWq4xog9Ef8IzaQvs/AaygKwsgAFYsEDhSEpsxz+buhmzyYYZxV5ln2O/b?=
 =?us-ascii?Q?zMt01YjhVGIDb3+r/yWus8q38N4TLMlNrEDhSZrYiEJql5r1kw6ytyVAwCMZ?=
 =?us-ascii?Q?XhHOiCLJ5farDh8Q+CMyIUc1spfFABB+DQU2M839HBIzdi3+EWisb9RZIRnO?=
 =?us-ascii?Q?ffaRuAbtzggu4QK/jm/eDcjligiUQuC1D+FSdcv31q0/I7ERVm5s4E1+gOH8?=
 =?us-ascii?Q?+AVth21CAQf7G3q6LbAWbb0GL3J9+7RZrhT7cml5ElDAJuT/DC6Wr0lmSecR?=
 =?us-ascii?Q?zN/a4hNMCUcg+gzWgZX/5ul4NxWVMV6l3RwalCso1337+3X09tL3SiN9H6C5?=
 =?us-ascii?Q?JEEJ+GCfTi7fOSaih+PBK6YMUGnkrt+1R42wGqKkAcW6b8HCMPrgdB7I26md?=
 =?us-ascii?Q?F1PxMXNXryMmGP1+duTzZv9Zn0qIIPtU+cpFTWfPxsoeRsfOKQYChBuG9FAA?=
 =?us-ascii?Q?0osYyLNf++8mnj86e8qlSFsBlOr1m6yBQCjpnY9lB6MKHwjq8XeKr3SaZJrc?=
 =?us-ascii?Q?HoqygqwO/qfrXRUCBMUC5hwgNa/wHwtqheyC+R3LU8iRSMQ8SYDiM2/kSjBw?=
 =?us-ascii?Q?FoGpo5kw6byNEj5EKnno4cZNjusCsZK6C7kktde8TzjhVFvD8t1xaRiWEFzH?=
 =?us-ascii?Q?CS0H1FlEonbr6rBLo6w=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(7416014)(376014)(82310400026)(36860700013)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Dec 2025 10:17:40.0491
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 7fe11d01-5ebe-4e72-0ecc-08de34b0afc5
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MN1PEPF0000F0E0.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV8PR12MB9333
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: DC48880002
X-Stat-Signature: fbzaejgwq7hh4nmkdbqm9dkxbhsnqq9x
X-Rspam-User: 
X-HE-Tag: 1765016265-946290
X-HE-Meta: U2FsdGVkX1/Put+xhe+GU9MfWkvU7obq04CNkkYhjGCNutaljfXV6QqK9ezaYac13K8Mu3+okX/HnuT/gtT2RdWxoG0R6ZHJbZn51teTmkkaB3r5sWRZQgTa+rg+LO1qqEoHHJP2BnO0BuO8cVAB0bvmQJbxUVc6/XlTqGMzrW/icycEqJypdVKQ2/mPhiTbAgPyq/UQWc9ptIcPzkxphInW+rcseMIlmVAdlXoaWFTsdmKYxjUkZa+/5VL8UNpjFRqaFkW8Qy0fDfB+pylwvcYhJQnp0Rg6LeYJRtIFEjb7oZ9Jr0EEXwasOcBkw/KrN4dDg4LnMi/9pEZNmawsrDA+BrmYYw2Ay5iKDNn7GiHf7zsAMFE+z86v9CLlLZ69RCNGjt/o9ZpDzXz/hFV9lOdoFD2NJvUGKlN767x2lsZDvC0CoEQs65yKxu4+P/kOtLY3XPV5+9ZHjuno2HrgzIZngrIFlzvxRLEnA9OccyzKG3YtnLzy/tJApJ5bXuXuL5d6uHNP/OrJ+TUZjPX+lm0qs73XTFcKemTRLHerXDvJ8WD+dlCv5NKGHuOqHwAYx5k37ORZ7oNb5ePESieFz6xCrDMh8XzkWQjRUaq8a0xrhVfRELyPIcW1IBz/TaqdePLEGG5gunRkTQ8R9Yo1xaxK/8ID9fH0yMMvSHBIuAMB3OPjxxiUlIh+2lYilAj8lyND8KD9Lb5wrP7cr2o5DgG2RbiojHIMnPAi+LTH4w5AjpEL5dqPhJXCOtqEcl6N4j43F2XFFEKuZ2bbZSwqv1hS4FTG8skZNIOiUtm8098mOc26lVemLwvuL4OnsfCGiip8Ib+aMnAdIrQPpXtcCGsPRGP36Ul/HMhtNCQH5V9f1GlYmLQ9y6n5n4LUtTdxuPoWDrzKXeajNoItTRnUgLqwU5WBxS7rGY07R6+p2If9BpeOqMT2sjGTZeR3eah+Vt6GeyPCYlLTaBKDLC+
 BHBxbduA
 1s9zqbx7N1YGjWzt4HGCZF15urKAqlSN4D64VQUCqy7o5cNw4EJIubIMkYVsCO+h9cxYc/yahz0hK9Q2c0e4Rm23srYTt65TCp13gfYNdUj9yf0qU4kFSiJKDF9DxgrI1uh66Vff6TVfp7Ir76lP4ip9Cfp4nvmlxLH603igZlXx9GDvcoqEB91tBNFozWSmv7EErgHMp0HzQ0yDYzC0p4xqx27AIEC4S46uoTpRDlem5BJLq3bqK5gQrN+Pihm3+NcfaIAHWY3Usmj2+oSWLbX9+Mf1YO6+32TDjN+F0uKvRO1NS9ZADIYz0AO7MZrtgb2O3zTDeXrR5SC3KLVW/9GJVibVjPTs8pEE+G0GMPZu7vbzwjnml0uVZW0PIKxsCXRCnRVDRGjKeSCRsF1Z6+tBdyQiFrWUjHwnd47328sjhhSQWHBNrZy7AUkn/aXMNIw8YFxpvtLwXmuCLw6T7iGWSp2mtwh79kDxWmDe35mMBvM5tdIvOeDYokZ6ia0DVcUnSaQ04VaYyua3PgCpNxMH6iisBm2H22Rm3VJGLtRcASaE=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kinsey Ho <kinseyho@google.com>

Refactor the existing MGLRU page table walking logic to make it
resumable.

Additionally, introduce two hooks into the MGLRU page table walk:
accessed callback and flush callback. The accessed callback is called
for each accessed page detected via the scanned accessed bit. The flush
callback is called when the accessed callback reports that a flush is
required. This allows for processing pages in batches for efficiency.

With a generalised page table walk, introduce a new scan function which
repeatedly scans on the same young generation and does not add a new
young generation.

Signed-off-by: Kinsey Ho <kinseyho@google.com>
Signed-off-by: Yuanchu Xie <yuanchu@google.com>
Signed-off-by: Bharata B Rao <bharata@amd.com>
---
 include/linux/mmzone.h |   5 ++
 mm/internal.h          |   4 +
 mm/vmscan.c            | 181 +++++++++++++++++++++++++++++++----------
 3 files changed, 145 insertions(+), 45 deletions(-)

diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index fde851990394..421b012fb60c 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -548,6 +548,8 @@ struct lru_gen_mm_walk {
 	unsigned long seq;
 	/* the next address within an mm to scan */
 	unsigned long next_addr;
+	/* called for each accessed pte/pmd */
+	bool (*accessed_cb)(unsigned long pfn);
 	/* to batch promoted pages */
 	int nr_pages[MAX_NR_GENS][ANON_AND_FILE][MAX_NR_ZONES];
 	/* to batch the mm stats */
@@ -555,6 +557,9 @@ struct lru_gen_mm_walk {
 	/* total batched items */
 	int batched;
 	int swappiness;
+	/* for the pmd under scanning */
+	int nr_young_pte;
+	int nr_total_pte;
 	bool force_scan;
 };
 
diff --git a/mm/internal.h b/mm/internal.h
index 1561fc2ff5b8..531104a96c51 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -538,6 +538,10 @@ extern unsigned long highest_memmap_pfn;
 bool folio_isolate_lru(struct folio *folio);
 void folio_putback_lru(struct folio *folio);
 extern void reclaim_throttle(pg_data_t *pgdat, enum vmscan_throttle_state reason);
+void set_task_reclaim_state(struct task_struct *task,
+				   struct reclaim_state *rs);
+void lru_gen_scan_lruvec(struct lruvec *lruvec, unsigned long seq,
+			 bool (*accessed_cb)(unsigned long), void (*flush_cb)(void));
 #ifdef CONFIG_NUMA
 int user_proactive_reclaim(char *buf,
 			   struct mem_cgroup *memcg, pg_data_t *pgdat);
diff --git a/mm/vmscan.c b/mm/vmscan.c
index b2fc8b626d3d..1bb637fd6e5e 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -289,7 +289,7 @@ static int sc_swappiness(struct scan_control *sc, struct mem_cgroup *memcg)
 			continue;				\
 		else
 
-static void set_task_reclaim_state(struct task_struct *task,
+void set_task_reclaim_state(struct task_struct *task,
 				   struct reclaim_state *rs)
 {
 	/* Check for an overwrite */
@@ -3093,7 +3093,7 @@ static bool iterate_mm_list(struct lru_gen_mm_walk *walk, struct mm_struct **ite
 
 	VM_WARN_ON_ONCE(mm_state->seq + 1 < walk->seq);
 
-	if (walk->seq <= mm_state->seq)
+	if (!walk->accessed_cb && walk->seq <= mm_state->seq)
 		goto done;
 
 	if (!mm_state->head)
@@ -3519,16 +3519,14 @@ static void walk_update_folio(struct lru_gen_mm_walk *walk, struct folio *folio,
 	}
 }
 
-static bool walk_pte_range(pmd_t *pmd, unsigned long start, unsigned long end,
-			   struct mm_walk *args)
+static int walk_pte_range(pmd_t *pmd, unsigned long start, unsigned long end,
+			   struct mm_walk *args, bool *suitable)
 {
 	int i;
 	bool dirty;
 	pte_t *pte;
 	spinlock_t *ptl;
 	unsigned long addr;
-	int total = 0;
-	int young = 0;
 	struct folio *last = NULL;
 	struct lru_gen_mm_walk *walk = args->private;
 	struct mem_cgroup *memcg = lruvec_memcg(walk->lruvec);
@@ -3536,19 +3534,24 @@ static bool walk_pte_range(pmd_t *pmd, unsigned long start, unsigned long end,
 	DEFINE_MAX_SEQ(walk->lruvec);
 	int gen = lru_gen_from_seq(max_seq);
 	pmd_t pmdval;
+	int err = 0;
 
 	pte = pte_offset_map_rw_nolock(args->mm, pmd, start & PMD_MASK, &pmdval, &ptl);
-	if (!pte)
-		return false;
+	if (!pte) {
+		*suitable = false;
+		return err;
+	}
 
 	if (!spin_trylock(ptl)) {
 		pte_unmap(pte);
-		return true;
+		*suitable = true;
+		return err;
 	}
 
 	if (unlikely(!pmd_same(pmdval, pmdp_get_lockless(pmd)))) {
 		pte_unmap_unlock(pte, ptl);
-		return false;
+		*suitable = false;
+		return err;
 	}
 
 	arch_enter_lazy_mmu_mode();
@@ -3557,8 +3560,9 @@ static bool walk_pte_range(pmd_t *pmd, unsigned long start, unsigned long end,
 		unsigned long pfn;
 		struct folio *folio;
 		pte_t ptent = ptep_get(pte + i);
+		bool do_flush;
 
-		total++;
+		walk->nr_total_pte++;
 		walk->mm_stats[MM_LEAF_TOTAL]++;
 
 		pfn = get_pte_pfn(ptent, args->vma, addr, pgdat);
@@ -3582,23 +3586,36 @@ static bool walk_pte_range(pmd_t *pmd, unsigned long start, unsigned long end,
 		if (pte_dirty(ptent))
 			dirty = true;
 
-		young++;
+		walk->nr_young_pte++;
 		walk->mm_stats[MM_LEAF_YOUNG]++;
+
+		if (!walk->accessed_cb)
+			continue;
+
+		do_flush = walk->accessed_cb(pfn);
+		if (do_flush) {
+			walk->next_addr = addr + PAGE_SIZE;
+
+			err = -EAGAIN;
+			break;
+		}
 	}
 
 	walk_update_folio(walk, last, gen, dirty);
 	last = NULL;
 
-	if (i < PTRS_PER_PTE && get_next_vma(PMD_MASK, PAGE_SIZE, args, &start, &end))
+	if (!err && i < PTRS_PER_PTE &&
+	    get_next_vma(PMD_MASK, PAGE_SIZE, args, &start, &end))
 		goto restart;
 
 	arch_leave_lazy_mmu_mode();
 	pte_unmap_unlock(pte, ptl);
 
-	return suitable_to_scan(total, young);
+	*suitable = suitable_to_scan(walk->nr_total_pte, walk->nr_young_pte);
+	return err;
 }
 
-static void walk_pmd_range_locked(pud_t *pud, unsigned long addr, struct vm_area_struct *vma,
+static int walk_pmd_range_locked(pud_t *pud, unsigned long addr, struct vm_area_struct *vma,
 				  struct mm_walk *args, unsigned long *bitmap, unsigned long *first)
 {
 	int i;
@@ -3611,6 +3628,7 @@ static void walk_pmd_range_locked(pud_t *pud, unsigned long addr, struct vm_area
 	struct pglist_data *pgdat = lruvec_pgdat(walk->lruvec);
 	DEFINE_MAX_SEQ(walk->lruvec);
 	int gen = lru_gen_from_seq(max_seq);
+	int err = 0;
 
 	VM_WARN_ON_ONCE(pud_leaf(*pud));
 
@@ -3618,13 +3636,13 @@ static void walk_pmd_range_locked(pud_t *pud, unsigned long addr, struct vm_area
 	if (*first == -1) {
 		*first = addr;
 		bitmap_zero(bitmap, MIN_LRU_BATCH);
-		return;
+		return err;
 	}
 
 	i = addr == -1 ? 0 : pmd_index(addr) - pmd_index(*first);
 	if (i && i <= MIN_LRU_BATCH) {
 		__set_bit(i - 1, bitmap);
-		return;
+		return err;
 	}
 
 	pmd = pmd_offset(pud, *first);
@@ -3638,6 +3656,7 @@ static void walk_pmd_range_locked(pud_t *pud, unsigned long addr, struct vm_area
 	do {
 		unsigned long pfn;
 		struct folio *folio;
+		bool do_flush;
 
 		/* don't round down the first address */
 		addr = i ? (*first & PMD_MASK) + i * PMD_SIZE : *first;
@@ -3674,6 +3693,17 @@ static void walk_pmd_range_locked(pud_t *pud, unsigned long addr, struct vm_area
 			dirty = true;
 
 		walk->mm_stats[MM_LEAF_YOUNG]++;
+		if (!walk->accessed_cb)
+			goto next;
+
+		do_flush = walk->accessed_cb(pfn);
+		if (do_flush) {
+			i = find_next_bit(bitmap, MIN_LRU_BATCH, i) + 1;
+
+			walk->next_addr = (*first & PMD_MASK) + i * PMD_SIZE;
+			err = -EAGAIN;
+			break;
+		}
 next:
 		i = i > MIN_LRU_BATCH ? 0 : find_next_bit(bitmap, MIN_LRU_BATCH, i) + 1;
 	} while (i <= MIN_LRU_BATCH);
@@ -3684,9 +3714,10 @@ static void walk_pmd_range_locked(pud_t *pud, unsigned long addr, struct vm_area
 	spin_unlock(ptl);
 done:
 	*first = -1;
+	return err;
 }
 
-static void walk_pmd_range(pud_t *pud, unsigned long start, unsigned long end,
+static int walk_pmd_range(pud_t *pud, unsigned long start, unsigned long end,
 			   struct mm_walk *args)
 {
 	int i;
@@ -3698,6 +3729,7 @@ static void walk_pmd_range(pud_t *pud, unsigned long start, unsigned long end,
 	unsigned long first = -1;
 	struct lru_gen_mm_walk *walk = args->private;
 	struct lru_gen_mm_state *mm_state = get_mm_state(walk->lruvec);
+	int err = 0;
 
 	VM_WARN_ON_ONCE(pud_leaf(*pud));
 
@@ -3711,6 +3743,7 @@ static void walk_pmd_range(pud_t *pud, unsigned long start, unsigned long end,
 	/* walk_pte_range() may call get_next_vma() */
 	vma = args->vma;
 	for (i = pmd_index(start), addr = start; addr != end; i++, addr = next) {
+		bool suitable;
 		pmd_t val = pmdp_get_lockless(pmd + i);
 
 		next = pmd_addr_end(addr, end);
@@ -3727,7 +3760,10 @@ static void walk_pmd_range(pud_t *pud, unsigned long start, unsigned long end,
 			walk->mm_stats[MM_LEAF_TOTAL]++;
 
 			if (pfn != -1)
-				walk_pmd_range_locked(pud, addr, vma, args, bitmap, &first);
+				err = walk_pmd_range_locked(pud, addr, vma, args,
+						bitmap, &first);
+			if (err)
+				return err;
 			continue;
 		}
 
@@ -3736,33 +3772,51 @@ static void walk_pmd_range(pud_t *pud, unsigned long start, unsigned long end,
 			if (!pmd_young(val))
 				continue;
 
-			walk_pmd_range_locked(pud, addr, vma, args, bitmap, &first);
+			err = walk_pmd_range_locked(pud, addr, vma, args,
+						bitmap, &first);
+			if (err)
+				return err;
 		}
 
 		if (!walk->force_scan && !test_bloom_filter(mm_state, walk->seq, pmd + i))
 			continue;
 
+		err = walk_pte_range(&val, addr, next, args, &suitable);
+		if (err && walk->next_addr < next && first == -1)
+			return err;
+
+		walk->nr_total_pte = 0;
+		walk->nr_young_pte = 0;
+
 		walk->mm_stats[MM_NONLEAF_FOUND]++;
 
-		if (!walk_pte_range(&val, addr, next, args))
-			continue;
+		if (!suitable)
+			goto next;
 
 		walk->mm_stats[MM_NONLEAF_ADDED]++;
 
 		/* carry over to the next generation */
 		update_bloom_filter(mm_state, walk->seq + 1, pmd + i);
+next:
+		if (err) {
+			walk->next_addr = first;
+			return err;
+		}
 	}
 
-	walk_pmd_range_locked(pud, -1, vma, args, bitmap, &first);
+	err = walk_pmd_range_locked(pud, -1, vma, args, bitmap, &first);
 
-	if (i < PTRS_PER_PMD && get_next_vma(PUD_MASK, PMD_SIZE, args, &start, &end))
+	if (!err && i < PTRS_PER_PMD &&
+	    get_next_vma(PUD_MASK, PMD_SIZE, args, &start, &end))
 		goto restart;
+
+	return err;
 }
 
 static int walk_pud_range(p4d_t *p4d, unsigned long start, unsigned long end,
 			  struct mm_walk *args)
 {
-	int i;
+	int i, err;
 	pud_t *pud;
 	unsigned long addr;
 	unsigned long next;
@@ -3780,7 +3834,9 @@ static int walk_pud_range(p4d_t *p4d, unsigned long start, unsigned long end,
 		if (!pud_present(val) || WARN_ON_ONCE(pud_leaf(val)))
 			continue;
 
-		walk_pmd_range(&val, addr, next, args);
+		err = walk_pmd_range(&val, addr, next, args);
+		if (err)
+			return err;
 
 		if (need_resched() || walk->batched >= MAX_LRU_BATCH) {
 			end = (addr | ~PUD_MASK) + 1;
@@ -3801,40 +3857,48 @@ static int walk_pud_range(p4d_t *p4d, unsigned long start, unsigned long end,
 	return -EAGAIN;
 }
 
-static void walk_mm(struct mm_struct *mm, struct lru_gen_mm_walk *walk)
+static int try_walk_mm(struct mm_struct *mm, struct lru_gen_mm_walk *walk)
 {
+	int err;
 	static const struct mm_walk_ops mm_walk_ops = {
 		.test_walk = should_skip_vma,
 		.p4d_entry = walk_pud_range,
 		.walk_lock = PGWALK_RDLOCK,
 	};
-	int err;
 	struct lruvec *lruvec = walk->lruvec;
 
-	walk->next_addr = FIRST_USER_ADDRESS;
+	DEFINE_MAX_SEQ(lruvec);
 
-	do {
-		DEFINE_MAX_SEQ(lruvec);
+	err = -EBUSY;
 
-		err = -EBUSY;
+	/* another thread might have called inc_max_seq() */
+	if (walk->seq != max_seq)
+		return err;
 
-		/* another thread might have called inc_max_seq() */
-		if (walk->seq != max_seq)
-			break;
+	/* the caller might be holding the lock for write */
+	if (mmap_read_trylock(mm)) {
+		err = walk_page_range(mm, walk->next_addr, ULONG_MAX,
+				      &mm_walk_ops, walk);
 
-		/* the caller might be holding the lock for write */
-		if (mmap_read_trylock(mm)) {
-			err = walk_page_range(mm, walk->next_addr, ULONG_MAX, &mm_walk_ops, walk);
+		mmap_read_unlock(mm);
+	}
 
-			mmap_read_unlock(mm);
-		}
+	if (walk->batched) {
+		spin_lock_irq(&lruvec->lru_lock);
+		reset_batch_size(walk);
+		spin_unlock_irq(&lruvec->lru_lock);
+	}
 
-		if (walk->batched) {
-			spin_lock_irq(&lruvec->lru_lock);
-			reset_batch_size(walk);
-			spin_unlock_irq(&lruvec->lru_lock);
-		}
+	return err;
+}
+
+static void walk_mm(struct mm_struct *mm, struct lru_gen_mm_walk *walk)
+{
+	int err;
 
+	walk->next_addr = FIRST_USER_ADDRESS;
+	do {
+		err = try_walk_mm(mm, walk);
 		cond_resched();
 	} while (err == -EAGAIN);
 }
@@ -4046,6 +4110,33 @@ static bool inc_max_seq(struct lruvec *lruvec, unsigned long seq, int swappiness
 	return success;
 }
 
+void lru_gen_scan_lruvec(struct lruvec *lruvec, unsigned long seq,
+			 bool (*accessed_cb)(unsigned long), void (*flush_cb)(void))
+{
+	struct lru_gen_mm_walk *walk = current->reclaim_state->mm_walk;
+	struct mm_struct *mm = NULL;
+
+	walk->lruvec = lruvec;
+	walk->seq = seq;
+	walk->accessed_cb = accessed_cb;
+	walk->swappiness = MAX_SWAPPINESS;
+
+	do {
+		int err = -EBUSY;
+
+		iterate_mm_list(walk, &mm);
+		if (!mm)
+			break;
+
+		walk->next_addr = FIRST_USER_ADDRESS;
+		do {
+			err = try_walk_mm(mm, walk);
+			cond_resched();
+			flush_cb();
+		} while (err == -EAGAIN);
+	} while (mm);
+}
+
 static bool try_to_inc_max_seq(struct lruvec *lruvec, unsigned long seq,
 			       int swappiness, bool force_scan)
 {
-- 
2.34.1


