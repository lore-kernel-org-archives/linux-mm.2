Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 412B0E75448
	for <linux-mm@archiver.kernel.org>; Wed, 24 Dec 2025 11:15:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A70446B0005; Wed, 24 Dec 2025 06:15:18 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A1DCB6B0088; Wed, 24 Dec 2025 06:15:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8FFBB6B008A; Wed, 24 Dec 2025 06:15:18 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7B6096B0005
	for <linux-mm@kvack.org>; Wed, 24 Dec 2025 06:15:18 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 2A7B0160131
	for <linux-mm@kvack.org>; Wed, 24 Dec 2025 11:15:18 +0000 (UTC)
X-FDA: 84254108316.12.7D93867
Received: from BYAPR05CU005.outbound.protection.outlook.com (mail-westusazon11010063.outbound.protection.outlook.com [52.101.85.63])
	by imf14.hostedemail.com (Postfix) with ESMTP id 2552E100003
	for <linux-mm@kvack.org>; Wed, 24 Dec 2025 11:15:14 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=y9OQsLhH;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf14.hostedemail.com: domain of shivankg@amd.com designates 52.101.85.63 as permitted sender) smtp.mailfrom=shivankg@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766574915;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=Hv5zD3h6U+c6N9OZgK27ldCTVuNKhc5ZFfAlDcAsz7M=;
	b=lRTceVAmFFabo67Z4xP4iSwgXTnp1iS2Wq/R5jvKji/d5TW8kAz0snuvW7OJgqoqLCgNx9
	qcenPjo5SM1qrz176lzN4T531FXT8Ko6trXHIvIuSUdMJardD5xXyIzcJ+dYBOcXgPHk7Q
	/aWo6qnqVQEp+H3zVgwBeqjJFXDbOZA=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1766574915; a=rsa-sha256;
	cv=pass;
	b=BTTP69Kr7j+0r0um5TdkCBbUwExyXuMV0LIopJTGJXNdYla7meg8YVsqGfvNV0fe+rkgpR
	RWSUOs4vkAJAfF0SLTI6g8fRQqBQL2YY8GwoldURNQADVGX7/Y8Hn9AqwronOQZ1VLOiqJ
	OWjRYy4Ss6xnW0s2OefC8TvsQuwQ1Mg=
ARC-Authentication-Results: i=2;
	imf14.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=y9OQsLhH;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf14.hostedemail.com: domain of shivankg@amd.com designates 52.101.85.63 as permitted sender) smtp.mailfrom=shivankg@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=D1joBxMB+HmkXcCvl9rbukl+T3ywwuuW+nlfx8zDb/UB/FasN7oWR67NzzJMoUSDb5QayvLhmbbbX67tjS7GF6vwWllFWSNzSDMx5tb8MMBMoTHti0aMEGRmpUcgDyBUoJZHWbq2CTSMgArFhA2X7jVkrtxPIqhjVCEx65yRCfHXffEY0LZKMoODs2ndIfUKfc9FqlDaYHLqc0XEdoZvoDLPrqQv7yk4lxSbcLq4Q9iXkXZ3Ia1N6ZEGyPZjirjR0tLdJsgNr+Ab91Sz4EpL2XFjt4193b+NOq6BhA78QGyuVYh3JSKNmARgmDM6hk9/vpMn/I8tniY2U6IbsnTAuQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Hv5zD3h6U+c6N9OZgK27ldCTVuNKhc5ZFfAlDcAsz7M=;
 b=BqO42F8GbKwejcKV6R/OZNorjwgN/ygKNEuwU9E00YwCIiJ3Tczndv5B36yE1ndEBPOCRK1qflXsevzGK51hF4griFE6/rN1hvT3d0D5PYsgPB52R2WeH1ydOFJyH6te57F6ZP5zqi4abNBRAIAYdYcQK9JyZQU7ZvmwHW4OfEKw/iNvV8ny2bPUzpitczCtnPHCjQNJB9W859Yom2qznzrmoSkJ0Wl+VdNdqaG3SmPxWfIgbVdw76HPPL4hdWexsrPMd13B+LafEu9lTDoRSMmx74GV9J+K106mcjje2XR8GqNmdxkVc5yTvONckEOH2Uy7tqJBru1VBl915rBG+g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=linux-foundation.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Hv5zD3h6U+c6N9OZgK27ldCTVuNKhc5ZFfAlDcAsz7M=;
 b=y9OQsLhH8496LfG28Y3jcdGSiYb2O5EGxq+1Yj/JJUhRzW5eYbBG3QW5F20/JeOUoO4gaAcC7agkRHq4diaGOAtMK7XuY/oz3Hx2pxNbfchoYxso3PrvcLsbUG7io13OI4sAxZjKzY0f1qJEQ+LKA6inAKxZjVr4yXmmjcP6rTw=
Received: from SJ0PR13CA0130.namprd13.prod.outlook.com (2603:10b6:a03:2c6::15)
 by LV3PR12MB9437.namprd12.prod.outlook.com (2603:10b6:408:21d::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9434.11; Wed, 24 Dec
 2025 11:15:11 +0000
Received: from SJ5PEPF000001D5.namprd05.prod.outlook.com
 (2603:10b6:a03:2c6:cafe::14) by SJ0PR13CA0130.outlook.office365.com
 (2603:10b6:a03:2c6::15) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9478.2 via Frontend Transport; Wed,
 24 Dec 2025 11:15:11 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 SJ5PEPF000001D5.mail.protection.outlook.com (10.167.242.57) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9456.9 via Frontend Transport; Wed, 24 Dec 2025 11:15:10 +0000
Received: from kaveri.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Wed, 24 Dec
 2025 05:15:05 -0600
From: Shivank Garg <shivankg@amd.com>
To: Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand
	<david@kernel.org>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
CC: Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>,
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song
	<baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, <linux-mm@kvack.org>,
	<linux-kernel@vger.kernel.org>, <shivankg@amd.com>
Subject: [PATCH V2 0/5] mm/khugepaged: cleanups and scan limit fix 
Date: Wed, 24 Dec 2025 11:13:49 +0000
Message-ID: <20251224111351.41042-4-shivankg@amd.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: satlexmb08.amd.com (10.181.42.217) To satlexmb07.amd.com
 (10.181.42.216)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ5PEPF000001D5:EE_|LV3PR12MB9437:EE_
X-MS-Office365-Filtering-Correlation-Id: 5cb42052-0c60-4740-0aeb-08de42ddb407
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|82310400026|376014|7416014|36860700013|13003099007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?rIpWlxhH/aruqAZ99roZbqopQfIag4RYDRXwfCn+mT8L8tv0I/kkQeUgZums?=
 =?us-ascii?Q?SOMEbRzjHi+2bdBR1KlnQ4sBfr3XrEhOfr3sM30qgpBGcycivYa6hKDvC6SH?=
 =?us-ascii?Q?D7KkAn3sbX0Xupk7duFpAVl5uBNoheLj1u4y90ku+qI/hV4JoyYe8CWnTzAx?=
 =?us-ascii?Q?pMKOzaT/jQ8xSxqMZ27O9g8385uBkyqeco0qFafuhFUSjp429nXD/eE66mmz?=
 =?us-ascii?Q?lPe51DmwMQHHcMc/wyOjNcBRn0Pg0p9KJAtZKWdg6Alk4RiKg8+qepJNixa5?=
 =?us-ascii?Q?J3rUmky3xly1OmMegyTYxiOJ+iJ6LPyjiWvFGA+QXcVL6DA07YqaTkcFtuSu?=
 =?us-ascii?Q?YmToSCLg7KkjJpXSDNH0quW2+sGTZsz4BYUJQxr39m3in2VRN5cfAllGCZJR?=
 =?us-ascii?Q?6orIpAByiQXBudy8Kb2gEsR20qO2mAzRIIUQTvj/cLjll1A+6yzf03uxoXit?=
 =?us-ascii?Q?YE8VZ0COciegO6vJOVxVKxlBXlBTzxzORafVlRkV/quIsQbQFgD1WzY0Uyy6?=
 =?us-ascii?Q?9xt4Q0XOOhr2CAIjEQIwwkOUF30bquuC7n9Papctfor4lnOJYlGFkE1uhTcX?=
 =?us-ascii?Q?q1nPWhxBA6B6MycdFap5JHT329UQWZlca7lCEkKS/vHolfb5FJA1PNRxQJvW?=
 =?us-ascii?Q?WErYiVSZ5aT8uAJLhEZv81uoa+rHgbtWVVjy3L+2Be7CIL0FmXvQmkJYPtfo?=
 =?us-ascii?Q?1jWB+BL1NAK4Zy8q2gxu8o2YJuKg6tyrMbJXqRC1qbqVxPbem8xsMEAPRb/4?=
 =?us-ascii?Q?iL4XWbgFMHimiUdb9G6zheYchUWWIAHxo7VrWgL2KBnmcy+75PHPa5JsoD6L?=
 =?us-ascii?Q?fjhq36FAbrKsX7uZyNGKJg8PgGhGhsUBIwqyjSEaJ2Z3BYUQNnSt1UIik0xs?=
 =?us-ascii?Q?mMYuY/oZj49eQ/6do800GjLbCgS9LQohrhLqs5B3aB+q0lr9lZiZ5Fh4bWVL?=
 =?us-ascii?Q?8PZSHQFb9GwKXrecypt70rqCQ/9F4z7evcMM1peUc1Z/GDgc7u0z0gFSjBsG?=
 =?us-ascii?Q?zhlarJqbhQiaVuA2T8c617STFKSap9cH1/vO0ruajYpxou9dSVwJ/idwtwHn?=
 =?us-ascii?Q?d05xbOMouC/BBDFymY7I3QP26qfFLC8VH1+89qhHbPeIoSUqgncrvI1scZPt?=
 =?us-ascii?Q?kPtZT5yjBqLRhIX4VdV7XCDfwi3vOyBYsoiXUqqcsgud+HHC9+VNz4fkOVV9?=
 =?us-ascii?Q?7ggMg0P965h7A/Zv6Phn9FEmhZ1I90jq3cSwo+coCGVZ+AN2BjhOvhOfLPHg?=
 =?us-ascii?Q?V0JG1kUC7qLM/xL+2eT1SFk4cStUAaL1pyZv4ByoUBAyKVoGiKmW6PbEWZ3d?=
 =?us-ascii?Q?upUU94G8s9qZFbXn4rW5AGmEp9s7hZ567fELwlMBqXfS3iO5R+TmHAH8IIVG?=
 =?us-ascii?Q?CiV+31cNWB+zCRmX5mfAeiG/nT0AzQ3rmYKUIbOv3ExT+b/+HV+ws3aS2ZfU?=
 =?us-ascii?Q?w/RzAU8tY3Qz0sclNSn2/+RTAe5QCD3lOkenB/PdJ+O6DlZjQZb7evrObLG2?=
 =?us-ascii?Q?vWynJ4N3V9UaXGnXejM4pfVAMmhC+MCVWoqiza/c9GIMIbTpfcp1N1y6bvCQ?=
 =?us-ascii?Q?6vzAG8di+nCk5f1EnQ4=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(82310400026)(376014)(7416014)(36860700013)(13003099007);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Dec 2025 11:15:10.7985
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 5cb42052-0c60-4740-0aeb-08de42ddb407
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ5PEPF000001D5.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR12MB9437
X-Stat-Signature: 86nyzbjmspatdtyzcmu58qmc6zzgnd5y
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 2552E100003
X-Rspam-User: 
X-HE-Tag: 1766574914-493994
X-HE-Meta: U2FsdGVkX1/1ZMMqZQs98J1r4ZrEMxEN4eBrJuv8yHsvqKOSv6roRRUoa/qh2fxqfAKeZlNV5JxajiTn8y+ffWjwS7j9rqaoOCFWKvrHjn1cAnJHTPsm3KkTdosGLI1JCvSYtfmh8sGFJAoqKzoJO3vjZCdczE5uGo88LBNxtM3kqiauTKpnsYR2+rSas4n7E1VoCZpLCykV1S7BGM7drPE7uMoYIlhSc4FLU5gfsEC6WFZIWQyc+VYfjNyZgkKosfBwayKNaRpg/aPI3wdztvYq9v9cQtRDzXgUr9X+I6x22T2CyNLQxE6Fe/e4Pn0q9sM6zNA8GsKkUpBdY1E+0R/AaQA8dN38D2RtMpf397cv0M1FOBxUh/7UIe9j+Rjg2TuOoa16mf/i39+0CSEd6ft/JRpXUfkfVw+Kc/9Nl4+HuM1iZXbYJhB53B/NMYQyRwEYmumRYJaGYQEdm2buHzVaY9SXyZWGcxyk9c3GfbiNlvjBLvBhniUVI6vhJfWmo1CSXI9WTwAZabRPy03TJEvdS6eZ6qY2V1Geyx02MmqTiO0UbE3AKno58su5v5agpCz/TvCNHSHCXX1leZopsaI97Gcl0JGLv0l+sAUqr46Z1SKjCChMmy9F+tEaOLuYqG3KbSo3WTh0LVRZBBBI2PId3312sN9OYtHcT9rTjKV1SrwMfaVnkwTqRNkpAJMG/Gis5cyzu4XZq2Y5lBItFOLXoG+PhDlFOHti7zpMMY/ySQZi5+f8pywLgagzlaunoiTwqJfxsy0S12InSfoL22CSAJYk/n2baMFt132r0RDdyKq41U0DMYAuk8eg7GxaziOuqOwstk7+d+yQYRPd1CFfKFEB7xGC6W84/eBZi+5BxitWMI3zOgN22bqy8b5+oNFz3YHAwROmj6S+wqutjLTE1T/PJ9koaYhzshzIYHevfqQ/UBGYeBBTauKSFjPPYtnRpXxSJBlpk5TEyJB
 3lMMSmD2
 UyRBPPkyU/Dt4Wx1Kg2Xzg8pkdgNqA9tFpwbi+0kLCO4tV0ml5P/nuFbE0/j22+l34VHyyAiYSK0YdxBRTOm0Tcr7EcoqtVvyx/ACaZ4UIpcC3a0uNC1iJTtqDP9ofbaWLMOmiko1Gn7fiPwg3KdC+xrlFr7iagzZJy1O1usQv3D129zliu4Ta4Hc1igYr7TadSf55AgIexEJn/MRD1HAzLe9WBGSkWWj4rvJw855Qn2rnbmvZjPZY/qHNeQTkbzsVmU8OTgNuudCGUNU8QlFMbD/ANYDIQzkkJELBzspLCRuvSUjuAOKaPT7YJ03DC2boMio8/36YMkdWrqC4rkHY40bx7RZTiNtXjc6OHUh87EIyblqxzNoa/oKrEX5ZXGvSGONJKGSPY6SlDByAu/4vuYWzfI4eG2JjPA1Sa/5MEaV4cM2GVUbVi1yTgMFuCwGvBShvZfixGBQg6i2XyS1oPcwTqABhQ6vCLUEhvqlEyluXkel/PWG2PGm6GrC6nT6k1zxa2ZSViqbKDs=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This series contains several cleanups for mm/khugepaged.c to improve code
readability and type safety, and one functional fix to ensure
khugepaged_scan_mm_slot() correctly accounts for small VMAs towards
scan limit.

Thanks,

v2:
- Added a fix for small VMAs not being counted in the scan limit (Wei)
- Updated 'progress' to 'unsigned int' to match types
- Update return types of internal functions to use enum scan_result (Zi)
- Add void wrapper collapse_pte_mapped_thp() for external callers to avoid
  exposing internal enum (David)

v1:
https://lore.kernel.org/linux-mm/20251216111139.95438-2-shivankg@amd.com

Shivank Garg (5):
  mm/khugepaged: remove unnecessary goto 'skip' label
  mm/khugepaged: count small VMAs towards scan limit
  mm/khugepaged: change collapse_pte_mapped_thp() to return void
  mm/khugepaged: use enum scan_result for result variables and return
    types
  mm/khugepaged: make khugepaged_collapse_control static

 include/linux/khugepaged.h |   9 +--
 mm/khugepaged.c            | 158 ++++++++++++++++++++-----------------
 2 files changed, 88 insertions(+), 79 deletions(-)


base-commit: cd119c65a615bd7bfe8cda715a77132c8e3da067
-- 
2.43.0


