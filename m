Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C482DD0EE00
	for <linux-mm@archiver.kernel.org>; Tue, 25 Nov 2025 17:58:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2B3BD6B00AF; Tue, 25 Nov 2025 12:58:41 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 23CF06B00B0; Tue, 25 Nov 2025 12:58:41 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 08FE76B00B1; Tue, 25 Nov 2025 12:58:41 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id E3A6F6B00AF
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 12:58:40 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 8A751C0346
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 17:58:40 +0000 (UTC)
X-FDA: 84149889600.22.CBC157D
Received: from SA9PR02CU001.outbound.protection.outlook.com (mail-southcentralusazon11013028.outbound.protection.outlook.com [40.93.196.28])
	by imf08.hostedemail.com (Postfix) with ESMTP id 66E2D160008
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 17:58:37 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=QclNHlne;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf08.hostedemail.com: domain of PratikRajesh.Sampat@amd.com designates 40.93.196.28 as permitted sender) smtp.mailfrom=PratikRajesh.Sampat@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764093517;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1L0C8HDPTtYzTeeMbMzF3MQurU4F7W3wtMzX9+AwXmM=;
	b=AwnB7RxO2FRRhaj2HQsdaA2kZQ2fv8H16JNHuZpCF7q16mlyMswUtujt45YTlOku1SYqFf
	79Tbl76XLelbKu9VX+3ZPNH1/aF5bDR8P1Dz0+MtfboLGMY0T9GzZRIrp4WhmwKBd11Efc
	6FCYxk5UKqwVgyrfqUFctpy4siDZ6m4=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1764093517; a=rsa-sha256;
	cv=pass;
	b=wQkc3CuWFCWlr4gmbLsad1MzmKYPBlo8Ob8cXwm+ErAdfZQQiCko19V3rC4jzfX5NFqN3Y
	Vgt6R2BF/ossYdwdiRQvd41DZ2TBksv92aECXcyWb6/KdFm+otcd6BrpCnsGbzbKx2jU7K
	LWYPdF9AmeZG6jspWlJn+Hv/M7KDack=
ARC-Authentication-Results: i=2;
	imf08.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=QclNHlne;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf08.hostedemail.com: domain of PratikRajesh.Sampat@amd.com designates 40.93.196.28 as permitted sender) smtp.mailfrom=PratikRajesh.Sampat@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=chwVla9TCkD4lKGP0BgyVPmrDPb4LRvJWpBlBQ3v3CYLTINlyC26lBxqSl2LJsw1IPJS4Xynsl5ulYzySH3KVFVqJj7Bkw7c/CSjmhleK7q9c3ZVEfvc3r48kJzdLDYimM+//EPhf1Jjj1Sy/MwE+WbGVq00+1R5quhmRxTvK8qcVR4FQL76wchZHIT6luk7UA9F1bWUkrkxH+O35yE7DCybhcHgOZIpRmEbgpUKGwbsqwwZyLpT710LJcb/6gFYQJ29ve95wbG63+6cg/fPgd+B2ZxGICUqLCeha4uCRLPkeHuNr3/wj+0Ial9aGC062SaMZBBBHuQpjTaPkTjYYQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1L0C8HDPTtYzTeeMbMzF3MQurU4F7W3wtMzX9+AwXmM=;
 b=kSY/Z5inHdZdMSfokldRgtiuBA1s+GxP+wuUuOnCuzsGPdodfYMKhM72ictRZNLhF0gn4gVZW2uchQhFqetyg38NVDiPonWcAdsl4He1JwLINHI+l86dC1lwq9Mpkps/8LFwIoqmJ6wHDu4O3gB2UX1sOROQhkrfAUHytntymez2eVzw6q4wo/YrQTPN40JxH196meY+Ad9eYv6taNqTEivCKC2a3lMOE2ZGrYgwVqMj5G/ZP+MqBBRVi/SHwoxQTOhQsPyFhnRqjL5DHf6oWY54E5X6SzRwuKyXbjrtTmsQ98LDlswNvUSNamUeogfWBJpdhQEku+N8ArWMJr9AJQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kvack.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1L0C8HDPTtYzTeeMbMzF3MQurU4F7W3wtMzX9+AwXmM=;
 b=QclNHlneFCN+QJu2Q6W68gbrp92U6e6vk03BBpYnREg7CqxOLjoAW4yAo9VOoq8YgMp7STJ2xn7PZ+zire80nqCgPc5B5Y0CMt+3LvbjErPtmMCQUwycRpxse1rQmv/tMfSk1vG33KjnnScDagmAConinnB5IAqaueLz2hEUCJU=
Received: from SA1PR02CA0010.namprd02.prod.outlook.com (2603:10b6:806:2cf::16)
 by CY5PR12MB6226.namprd12.prod.outlook.com (2603:10b6:930:22::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9343.17; Tue, 25 Nov
 2025 17:58:23 +0000
Received: from SN1PEPF000252A3.namprd05.prod.outlook.com
 (2603:10b6:806:2cf:cafe::8f) by SA1PR02CA0010.outlook.office365.com
 (2603:10b6:806:2cf::16) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9366.11 via Frontend Transport; Tue,
 25 Nov 2025 17:58:21 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 SN1PEPF000252A3.mail.protection.outlook.com (10.167.242.10) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9366.7 via Frontend Transport; Tue, 25 Nov 2025 17:58:22 +0000
Received: from ellora.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Tue, 25 Nov
 2025 11:58:21 -0600
From: "Pratik R. Sampat" <prsampat@amd.com>
To: <linux-mm@kvack.org>, <linux-coco@lists.linux.dev>,
	<linux-efi@vger.kernel.org>, <x86@kernel.org>, <linux-kernel@vger.kernel.org>
CC: <tglx@linutronix.de>, <mingo@redhat.com>, <bp@alien8.de>,
	<dave.hansen@linux.intel.com>, <kas@kernel.org>, <ardb@kernel.org>,
	<akpm@linux-foundation.org>, <david@redhat.com>, <osalvador@suse.de>,
	<thomas.lendacky@amd.com>, <michael.roth@amd.com>, <prsampat@amd.com>
Subject: [RFC PATCH 2/4] mm: Add support for unaccepted memory hotplug
Date: Tue, 25 Nov 2025 11:57:51 -0600
Message-ID: <20251125175753.1428857-3-prsampat@amd.com>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251125175753.1428857-1-prsampat@amd.com>
References: <20251125175753.1428857-1-prsampat@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: satlexmb07.amd.com (10.181.42.216) To satlexmb07.amd.com
 (10.181.42.216)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN1PEPF000252A3:EE_|CY5PR12MB6226:EE_
X-MS-Office365-Filtering-Correlation-Id: eb81faa2-a0b8-4505-b5d0-08de2c4c3999
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|82310400026|376014|7416014|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?SBy4v+3dYQn0B/1rgE3waz29IotYrdoEk60smvYLhJ/9sd9EqxxUjy+93sXm?=
 =?us-ascii?Q?Ny6LHrQZXNIhmt9wg+jJsO7L0ZYV84JSVE3O0uvfk/Dm/tZ1uExflaPr7KuV?=
 =?us-ascii?Q?wjDh6PoP2n6jzfG2XJdiIT0dwEzsuUn+7iWi7o6b6WpL/PBPWlIR+CREOJ0i?=
 =?us-ascii?Q?LWYzirvAxAyrnNEcq+PoUbPM2+pOZq4VHyG7qAK5/HUEYUFEcbYp5VoF5Uo/?=
 =?us-ascii?Q?84zqhTVoqTnWvRfXTer2YlK+tHdTe9+8AD2ZGNxU2Q4wZ3qnhQNFeClzyKgv?=
 =?us-ascii?Q?IqVbqv44Ss6++tDpWH19HIzSUsK2d4KOSHlH8sAQPStkcbRqpXH7RkzHAL3F?=
 =?us-ascii?Q?X5g0eNGbh6QCa5bsvMWxn9Ca4TKHasQqpn5DN+aCYWBFCiybNmTJBUx7cH5U?=
 =?us-ascii?Q?ayqsgvGiU2KKnQEU7+7fpyJjzMuxS+WOfUT+/Iovzi8ga28Ei9WcHFHBU39F?=
 =?us-ascii?Q?ngepjeNl+Kx2ubH2scdSt6I9zv42TYQuH1CLWbm5WXfUp+rBehY0PR9gttK3?=
 =?us-ascii?Q?e5RtPQvJuQB0AunRz0SEG4VDsvv4WK2pLgp5JcWOwXCVzQv3krqzozZZuESQ?=
 =?us-ascii?Q?8dGhBXSf0HCe2bIONOEVC18akWAweSQqdmMADgIzrUhrkJsY01HOVVrjiG/v?=
 =?us-ascii?Q?P+4Vlmi7OxJAgaKOTwLvtbzxLyL4deySTygDQcArxzC7uxNUjBhA4xqufaQx?=
 =?us-ascii?Q?rU2blsbrUmsUYg1GgGqAoCaR6Kqeze0bbfunGLBbAxIb4MGStw9PwhoamoN3?=
 =?us-ascii?Q?+D2ceA8clFBkXZhFRmm2M9GrLKEcj4hHh8p+K8r7K8Hp/9vLPwKKiyR2iqgj?=
 =?us-ascii?Q?gf6uuMdfBin2pzRKn3WOUT5sNFrPBOdyrs9wx7iZphHrP/1b3EfwR+Aa+p0U?=
 =?us-ascii?Q?P2hKI90TGuZfmosXfQOCVc4112aS9JBKjotzVOcwoqOdU+MBShvk7v0ReCYT?=
 =?us-ascii?Q?nFR7JR0rtS/9qAoIAAapPd2APx3G3Q9aLEOQAAT/mdxLQZ043Fuo6LlQpccq?=
 =?us-ascii?Q?n89TkflELn7+RoK4BNFlnWP+S9DYbZ6Iz/tB6Xd2UrFLFjqBfqzhu1R5ygYt?=
 =?us-ascii?Q?EP4y2bvKAzMp7F7c2ko06Fk/Cc+Q3gfsfI3RyvcF2YLoo+W9scyN4P10g2EN?=
 =?us-ascii?Q?QVawycl1NPaVEIjDuKyonLMUOJr+/lDa3QHn14ADqLCZf0ImZF3R6eJVcuU8?=
 =?us-ascii?Q?O0EcphIx7NO/youo7iHm+WBC1ra4HgThJPoismF81q3ZQ1BPSClEU3yvAXJl?=
 =?us-ascii?Q?hIdMRs8TzDPHgbIPBrYPThOY1oKDZVFfQR1S4WD/BlKGBH6uE92xZ9yLNojK?=
 =?us-ascii?Q?EP5/4Z7yLTuwlsA4QeXcjmG/XWqg/+M06cEsYJIbTRyH9R/qV2HrJgXAld/a?=
 =?us-ascii?Q?xphF3PTqO6AQ20EYVt+d3CglTmQ1cTgWzc+C2Ulbv16jo4wnLBLgxjO3eWft?=
 =?us-ascii?Q?45WrTS0qCfINmaILK2lWgzkyKA2AXLd9F6f6xHu/3LiMYR+l4ezaNnvnz/HQ?=
 =?us-ascii?Q?5V6obdAp97tWvWC68sh2zPTgPiehk59x1YCalGTQ5uGNWjrcLXO654vlhh8Z?=
 =?us-ascii?Q?iIOcxkDxUtgEWCWlhb8=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(82310400026)(376014)(7416014)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Nov 2025 17:58:22.8069
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: eb81faa2-a0b8-4505-b5d0-08de2c4c3999
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SN1PEPF000252A3.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB6226
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 66E2D160008
X-Stat-Signature: m13xw18af9ds6otj6aaxasfrgysnq8zs
X-Rspam-User: 
X-HE-Tag: 1764093517-326331
X-HE-Meta: U2FsdGVkX1/umrh8tbrdxGWe/+HZ0x0pF40i8iNjS/Btp8uW0yrNN/JvKhQKcsCsDiRjXhot5Daftl2qrHpvoNCVPRZ0YiIFGam85v05/NAyZtQros7d8avgjH6P8h1EGhzbS9pSTn5M9IJRZTosbeHqt6sFxvsD4JlemHXHSuGfIe9kr3L0nqYzm2HmlPnlB20VmXkdhlITOeKdslAjOX3l2UkJp6Wg10qPtAsX4H6oELkOpRcxJIUEKhrpEfwpRd8BcvstFquYy+JwtQmM5Zaadeemsubd1hEZTKKcrZZg1L4HFQSHhtNifBXhL7yiSbVzDl2D9MU/FJbsn54pVFOnR7uunkQDol6T7t04s1Ho8LevVYx7omJoUAXxaXsghH6u7AjpoxadKNc7nKD2TNp1KdcbcQO5eq4ZqOyvLyNzdtVI9tISXtMc5xMRDGqL20gwgVk3hg7g1PFkrPo0twl/Yb3sr0YQGolFtQZVOXsxJ7mnpfSewOaLHDkolMpxEY8/O/1YJlGlNZFdKEYzrGj+Ac5FVJEOzd/xgZs2k6C+6He7B91e9TvAN50n+Yti3MkyvKMkyU454suuSdYNLqzKVKmBxaRnUUawi5e0swGOG6AEk06pMCcjYjVmJ4UxMHpvru1m3CcYW/+CDUN945SSnHifA8fU0M+lc7IvT8mvwfc/LzDK2rr7H++JtONQ0z32qrREb0MV18ndRPeAguX6hLBlGyqjz1SpdhzrTCcA1pc9rm6EC99A60p8EXudSZSw8CgzGDgY/L/cXGHBlhkwcIYRjxsK2nGsOFF4iywLe1uj9ibE+AOolXfCuwFeQvCI8u8m3zDE0AmtXFPzxueOZq1tL6rSpj+peivbqMTsTo0bhZXccU9/X1ViX/+WncLX50IKRyoKXzF/ZetoF+BXWRtXv1RY0LLshJtmQ7s8SzaaBo1HbvxaPTBUklgSovp+ToAssQ1IdnlkXi/
 pMHyi2V4
 IWjOHmRXXDp48rAcRjasWrzDR6kySnvltYE+ofkzrUCOaYyJL8Dn4w8q3InG353Azu2y2LD2nOPEkQgpRqDW2J9z8GCpAY2Z3L7SeCnAvCOU3arFaQ52Eyc/fdExj2ZxskdcZMVsXFE/wj9pB3phpld//jLeIIAb++X3CSCzoQ33VWWAR2avXtTQwxuHrQbrfY+7cfTO81OWAQTnfe3ZOLqdXrqtoMOomke8rOWffofoU+SaFIo2T7CrR0kouU3DQv8HNS0PIFzEIONNuEGnvoXA4KEpdROcftOt3qLOXqHrjoPPpvMBWDOCCMYvgs3v7MiUIBMKIu+Am6kwGFV98o+fEjA+1ymWAx16nfc2Z7amnzj2F3ZBokiPiud3nZgdLOO62ZtoxMvKye6sPL6ylNd8SRiztnz6XedGhvitSqhbyaJPxHTFz6cQiJYmpUlEsbuPnptbf3LAFUxO6MpW6axWZnOmJJoP12k+X5yKy55IbMut98aMQHl+Ib4lAD6CdqGzWypcmtQpB3dB6zOPRVaZPHY02Vf7jvfz+UpKM+lXs55OANKf19aLpIilZzGXQ19LX5E4rWlHSm8Rvet2cO93ekw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The unaccepted memory structure currently only supports accepting memory
present at boot time. The unaccepted table uses a fixed-size bitmap
reserved in memblock based on the initial memory layout, preventing
dynamic addition of memory ranges after boot. This causes guest
termination when memory is hot-added in a secure virtual machine due to
accessing pages that have not transitioned to private before use.

Extend the unaccepted memory framework to handle hotplugged memory by
dynamically managing the unaccepted bitmap. Allocate a new bitmap when
hotplugged ranges exceed the reserved bitmap capacity and switch to
kernel-managed allocation.

Hotplugged memory also follows the same acceptance policy using the
accept_memory=[eager|lazy] kernel parameter to accept memory either
up-front when added or before first use.

Signed-off-by: Pratik R. Sampat <prsampat@amd.com>
---
 arch/x86/boot/compressed/efi.h                |  1 +
 .../firmware/efi/libstub/unaccepted_memory.c  |  1 +
 drivers/firmware/efi/unaccepted_memory.c      | 83 +++++++++++++++++++
 include/linux/efi.h                           |  1 +
 include/linux/mm.h                            | 11 +++
 mm/memory_hotplug.c                           |  7 ++
 mm/page_alloc.c                               |  2 +
 7 files changed, 106 insertions(+)

diff --git a/arch/x86/boot/compressed/efi.h b/arch/x86/boot/compressed/efi.h
index 4f7027f33def..a220a1966cae 100644
--- a/arch/x86/boot/compressed/efi.h
+++ b/arch/x86/boot/compressed/efi.h
@@ -102,6 +102,7 @@ struct efi_unaccepted_memory {
 	u32 unit_size;
 	u64 phys_base;
 	u64 size;
+	bool mem_reserved;
 	unsigned long *bitmap;
 };
 
diff --git a/drivers/firmware/efi/libstub/unaccepted_memory.c b/drivers/firmware/efi/libstub/unaccepted_memory.c
index c1370fc14555..b16bd61c12bf 100644
--- a/drivers/firmware/efi/libstub/unaccepted_memory.c
+++ b/drivers/firmware/efi/libstub/unaccepted_memory.c
@@ -83,6 +83,7 @@ efi_status_t allocate_unaccepted_bitmap(__u32 nr_desc,
 	unaccepted_table->unit_size = EFI_UNACCEPTED_UNIT_SIZE;
 	unaccepted_table->phys_base = unaccepted_start;
 	unaccepted_table->size = bitmap_size;
+	unaccepted_table->mem_reserved = true;
 	memset(unaccepted_table->bitmap, 0, bitmap_size);
 
 	status = efi_bs_call(install_configuration_table,
diff --git a/drivers/firmware/efi/unaccepted_memory.c b/drivers/firmware/efi/unaccepted_memory.c
index 4479aad258f8..8537812346e2 100644
--- a/drivers/firmware/efi/unaccepted_memory.c
+++ b/drivers/firmware/efi/unaccepted_memory.c
@@ -218,6 +218,89 @@ bool range_contains_unaccepted_memory(phys_addr_t start, unsigned long size)
 	return ret;
 }
 
+static int extend_unaccepted_bitmap(phys_addr_t mem_range_start,
+				    unsigned long mem_range_size)
+{
+	struct efi_unaccepted_memory *unacc_tbl;
+	unsigned long *old_bitmap, *new_bitmap;
+	phys_addr_t start, end, mem_range_end;
+	u64 phys_base, size, unit_size;
+	unsigned long flags;
+
+	unacc_tbl = efi_get_unaccepted_table();
+	if (!unacc_tbl || !unacc_tbl->unit_size)
+		return -EIO;
+
+	unit_size = unacc_tbl->unit_size;
+	phys_base = unacc_tbl->phys_base;
+
+	mem_range_end = round_up(mem_range_start + mem_range_size, unit_size);
+	size = DIV_ROUND_UP(mem_range_end - phys_base, unit_size * BITS_PER_BYTE);
+
+	/* Translate to offsets from the beginning of the bitmap */
+	start = mem_range_start - phys_base;
+	end = mem_range_end - phys_base;
+
+	old_bitmap = efi_get_unaccepted_bitmap();
+	if (!old_bitmap)
+		return -EIO;
+
+	/* If the bitmap is already large enough, just set the bits */
+	if (unacc_tbl->size >= size) {
+		spin_lock_irqsave(&unaccepted_memory_lock, flags);
+		bitmap_set(old_bitmap, start / unit_size, (end - start) / unit_size);
+		spin_unlock_irqrestore(&unaccepted_memory_lock, flags);
+
+		return 0;
+	}
+
+	/* Reserved memblocks cannot be extended so allocate a new bitmap */
+	if (unacc_tbl->mem_reserved) {
+		new_bitmap = kzalloc(size, GFP_KERNEL);
+		if (!new_bitmap)
+			return -ENOMEM;
+
+		spin_lock_irqsave(&unaccepted_memory_lock, flags);
+		memcpy(new_bitmap, old_bitmap, unacc_tbl->size);
+		unacc_tbl->mem_reserved = false;
+		free_reserved_area(old_bitmap, old_bitmap + unacc_tbl->size, -1, NULL);
+		spin_unlock_irqrestore(&unaccepted_memory_lock, flags);
+	} else {
+		new_bitmap = krealloc(old_bitmap, size, GFP_KERNEL);
+		if (!new_bitmap)
+			return -ENOMEM;
+
+		/* Zero the bitmap from the range it was extended from */
+		memset(new_bitmap + unacc_tbl->size, 0, size - unacc_tbl->size);
+	}
+
+	bitmap_set(new_bitmap, start / unit_size, (end - start) / unit_size);
+
+	spin_lock_irqsave(&unaccepted_memory_lock, flags);
+	unacc_tbl->size = size;
+	unacc_tbl->bitmap = (unsigned long *)__pa(new_bitmap);
+	spin_unlock_irqrestore(&unaccepted_memory_lock, flags);
+
+	return 0;
+}
+
+int accept_hotplug_memory(phys_addr_t mem_range_start, unsigned long mem_range_size)
+{
+	int ret;
+
+	if (!IS_ENABLED(CONFIG_UNACCEPTED_MEMORY))
+		return 0;
+
+	ret = extend_unaccepted_bitmap(mem_range_start, mem_range_size);
+	if (ret)
+		return ret;
+
+	if (!mm_lazy_accept_enabled())
+		accept_memory(mem_range_start, mem_range_size);
+
+	return 0;
+}
+
 #ifdef CONFIG_PROC_VMCORE
 static bool unaccepted_memory_vmcore_pfn_is_ram(struct vmcore_cb *cb,
 						unsigned long pfn)
diff --git a/include/linux/efi.h b/include/linux/efi.h
index a74b393c54d8..1021eb78388f 100644
--- a/include/linux/efi.h
+++ b/include/linux/efi.h
@@ -545,6 +545,7 @@ struct efi_unaccepted_memory {
 	u32 unit_size;
 	u64 phys_base;
 	u64 size;
+	bool mem_reserved;
 	unsigned long *bitmap;
 };
 
diff --git a/include/linux/mm.h b/include/linux/mm.h
index 1ae97a0b8ec7..bb43876e6c47 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -4077,6 +4077,9 @@ int set_anon_vma_name(unsigned long addr, unsigned long size,
 
 bool range_contains_unaccepted_memory(phys_addr_t start, unsigned long size);
 void accept_memory(phys_addr_t start, unsigned long size);
+int accept_hotplug_memory(phys_addr_t mem_range_start,
+			  unsigned long mem_range_size);
+bool mm_lazy_accept_enabled(void);
 
 #else
 
@@ -4090,6 +4093,14 @@ static inline void accept_memory(phys_addr_t start, unsigned long size)
 {
 }
 
+static inline int accept_hotplug_memory(phys_addr_t mem_range_start,
+					unsigned long mem_range_size)
+{
+	return 0;
+}
+
+static inline bool mm_lazy_accept_enabled(void) { return false; }
+
 #endif
 
 static inline bool pfn_is_unaccepted_memory(unsigned long pfn)
diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
index 74318c787715..bf8086682b66 100644
--- a/mm/memory_hotplug.c
+++ b/mm/memory_hotplug.c
@@ -1581,6 +1581,13 @@ int add_memory_resource(int nid, struct resource *res, mhp_t mhp_flags)
 	if (!strcmp(res->name, "System RAM"))
 		firmware_map_add_hotplug(start, start + size, "System RAM");
 
+	ret = accept_hotplug_memory(start, size);
+	if (ret) {
+		remove_memory_block_devices(start, size);
+		arch_remove_memory(start, size, params.altmap);
+		goto error;
+	}
+
 	/* device_online() will take the lock when calling online_pages() */
 	mem_hotplug_done();
 
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index d1d037f97c5f..d0c298dcaf9d 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -7331,6 +7331,8 @@ bool has_managed_dma(void)
 
 static bool lazy_accept = true;
 
+bool mm_lazy_accept_enabled(void) { return lazy_accept; }
+
 static int __init accept_memory_parse(char *p)
 {
 	if (!strcmp(p, "lazy")) {
-- 
2.51.1


