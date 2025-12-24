Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F0E9AE75448
	for <linux-mm@archiver.kernel.org>; Wed, 24 Dec 2025 11:18:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 53DD26B0005; Wed, 24 Dec 2025 06:18:09 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4E84E6B0088; Wed, 24 Dec 2025 06:18:09 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3EA3A6B008A; Wed, 24 Dec 2025 06:18:09 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2F2AA6B0005
	for <linux-mm@kvack.org>; Wed, 24 Dec 2025 06:18:09 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id ECED0140140
	for <linux-mm@kvack.org>; Wed, 24 Dec 2025 11:18:08 +0000 (UTC)
X-FDA: 84254115456.14.5311D9D
Received: from CO1PR03CU002.outbound.protection.outlook.com (mail-westus2azon11010040.outbound.protection.outlook.com [52.101.46.40])
	by imf28.hostedemail.com (Postfix) with ESMTP id 0744AC0007
	for <linux-mm@kvack.org>; Wed, 24 Dec 2025 11:18:05 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=NY8J8u8Y;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf28.hostedemail.com: domain of shivankg@amd.com designates 52.101.46.40 as permitted sender) smtp.mailfrom=shivankg@amd.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1766575086; a=rsa-sha256;
	cv=pass;
	b=gJdg748l1EXf7wpvTS5irjCkgLncLya1ta5T6sXsr7sL+foxSxB0vSrpxYvqc2opdPvSHi
	f0h6bFBslYiq7KQl3MpJfWXWzMxtmJ/ll+xrzLO+/jAOLN3E+4BZY8sEiMkY+rnkEAxCIA
	UoGYjP6Uf7pNuzHYftRIUZm0WyKzCwY=
ARC-Authentication-Results: i=2;
	imf28.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=NY8J8u8Y;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf28.hostedemail.com: domain of shivankg@amd.com designates 52.101.46.40 as permitted sender) smtp.mailfrom=shivankg@amd.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766575086;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mg5DqstHA9Qey8Eses9NLRZENqO2j/haqqIgUaLJSRc=;
	b=Gul/vCdPA3Fv4KRFJN2PXfdiUsGQrtHK+SYlzGdavE+pO4+SXjduUeP6JHTxQB8n2eJCHM
	JjmMDRnoA6uGe79bXo8spgmWTU6PKqx5VAh3P3nA1FnbKbJh16bBMNf3EBTjj+zKuEnyBH
	3eBDZr0zo4c9s4VGr5ohd8BgKjbIhDk=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=C4q44w8YE5R613S83MClXUAg6QxkbT0JM88WIbm+TqxFvIJxAVsS/bb4aTgFdLIwRRXMqN5VsteNekZqVsYWpBlXv5Q+dgp7q9Oh1a4pyAzuonTBx2fK2qItYZI56GrejIWOywvUlC3Q0XkoRMTFXFqPJtg1xG7ymJk2J1rs+Kn2Jco/7r/IDU9jviu9EhrL/eALDkrvvFa21Sz91/Zi6Au7dOwZU1qLhoRSwAcnlgcJ9IbSu3FqkiKBZFtzX7kCRoprH9r2n5oCYcmLGCUnllX5rm5MZUnT9iQOD+OB+WVQV2hyLfrb1Nvz+7fp+vJ8AzmzNOCWrIxAXoDf56lHrw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mg5DqstHA9Qey8Eses9NLRZENqO2j/haqqIgUaLJSRc=;
 b=hkMil6ZYq7zLvKLaGB2d9BKEVDZif4qZGPv+jb2EeYmkS5CykQ3D7x24GFT01vzO6PeluhxXEs1cf2FeZWPoe0W88K9zCu9yugO17k7zT7spKjlgYG/48S+AYx6K82NjzNCBMb4Vpxoal373AHIIAuC1/fx/OCqmYtahxlWK3sXTRrj5pC/7J+szaX/j2uDCITrENjZQPe8pEHJHF/i4SEoAH+/92kNsEZaBqMQohIq89/f1Shg86ZjpM7qLE3IFQs3f3oSAcKeYx1ky9ceSM7wifNF91LIjtM1oM2J45mgY/N3RMfeliveIH6lkxzBeILuj5L8WXqjSHVvEJEmuVw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=linux-foundation.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mg5DqstHA9Qey8Eses9NLRZENqO2j/haqqIgUaLJSRc=;
 b=NY8J8u8YfBnypLlwm+MR9PUbz8C2MqXEeLLuaR8zi2VpkQsShx4dBh5SWfg1a50xvWKwEOCE02MW4a520x/JcB6kLvrBkYFJBQc+ZHOQppoTemuxAgE41za3MnWTfVGp4HtLc0mk4fYY1rqx2A5O+dL/P8arsDpIBkDpcE55rrk=
Received: from SJ0PR03CA0153.namprd03.prod.outlook.com (2603:10b6:a03:338::8)
 by SA1PR12MB999108.namprd12.prod.outlook.com (2603:10b6:806:4a2::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9456.11; Wed, 24 Dec
 2025 11:18:01 +0000
Received: from SJ1PEPF0000231B.namprd03.prod.outlook.com
 (2603:10b6:a03:338:cafe::18) by SJ0PR03CA0153.outlook.office365.com
 (2603:10b6:a03:338::8) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9434.11 via Frontend Transport; Wed,
 24 Dec 2025 11:18:01 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 SJ1PEPF0000231B.mail.protection.outlook.com (10.167.242.232) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9456.9 via Frontend Transport; Wed, 24 Dec 2025 11:18:01 +0000
Received: from kaveri.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Wed, 24 Dec
 2025 05:17:56 -0600
From: Shivank Garg <shivankg@amd.com>
To: Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand
	<david@kernel.org>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
CC: Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>,
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song
	<baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, <linux-mm@kvack.org>,
	<linux-kernel@vger.kernel.org>, <shivankg@amd.com>, Wei Yang
	<richard.weiyang@gmail.com>
Subject: [PATCH V2 2/5] mm/khugepaged: count small VMAs towards scan limit
Date: Wed, 24 Dec 2025 11:13:53 +0000
Message-ID: <20251224111351.41042-8-shivankg@amd.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20251224111351.41042-4-shivankg@amd.com>
References: <20251224111351.41042-4-shivankg@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: satlexmb08.amd.com (10.181.42.217) To satlexmb07.amd.com
 (10.181.42.216)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PEPF0000231B:EE_|SA1PR12MB999108:EE_
X-MS-Office365-Filtering-Correlation-Id: 0b86a8ce-eead-4834-9a4d-08de42de1990
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|82310400026|36860700013|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?7KAYoRfGQGXZMhbORO4bon/xjjlC/x7oWMrIkP5IHUDryUo2ZHE/vZX5VvsG?=
 =?us-ascii?Q?xZrbUj8ncHajHfg/guohj6m9FZIMC+peUoiixebgtrH96AlhicUyWA2nl+JF?=
 =?us-ascii?Q?3AJ33zMo1ykKc9H/naEU3OPCIDtOQ/8RoLmbCBodrZ5Jp7uaS9rrXR3Wk8yP?=
 =?us-ascii?Q?Y8t66BAa1kDiM9aWEWoVJGRaXeUtU3tlySIfyYV/ZQ6jH8qV2w6skL6+dUU8?=
 =?us-ascii?Q?QrLKzJrYXMll/mpwtYCGqMK/GTpygbv2Jypd7IhFjcGbt9O5L3MthbDti7k7?=
 =?us-ascii?Q?zTyGSsVODdvl7yO7M1ZI0mgkYHOBpvsJW67hbjDs34m0eBW/ysCYGt+Nx7we?=
 =?us-ascii?Q?L6jceT2hNOS22yjgZD54ek2OBm1hA87Vy9BtV5eNQj7wWOcuEUxieQv39s15?=
 =?us-ascii?Q?Kr4KHyMPn49Ox0AZKsjgArrDptpMVaTPfIjd9TAFxGqd0YqU1EnrZrpBrZ+/?=
 =?us-ascii?Q?PZ7rd4R0mx+7cQ1q+W0zQD699vNjM0WcCdARfDFJSQCtt+bwBPw4LqhKRIt8?=
 =?us-ascii?Q?wdOeyYHjGqNGqsI1XEtuuW5+7eOEap5SUK0GWzb4fEUMa55gl3RO8PVCLLuL?=
 =?us-ascii?Q?Hwhzyix/AVl1eTpGtjz2BTxncviJU2LB69zBmwAw00Q6ckPlrAIr/k3UBg+w?=
 =?us-ascii?Q?esM011IL6j7AAIBQoe1XrQoMah7qaWpyFjx4h71Iyakhha1eSgMBVlnDqASK?=
 =?us-ascii?Q?a3r5kYP1dAc6Ed0J+7GVnKdKzuZD+Rc4yKY0wBtHNct/RxEyWyJ9FJCqC4Ga?=
 =?us-ascii?Q?AXAgIroaziaWCjXP0dBdOHO8Zkq1muhs8dcuCi+wHfRCEIptTyC1pKDVnQM1?=
 =?us-ascii?Q?aZEGOIqruMuGvXPGYxbM3YUj6ufBSfqSEzZ8MLlcinQrWV0obVsDdP+3/ZVz?=
 =?us-ascii?Q?D2O5uTsSJKMLITsAfQb/bVjAN48xCLpi9NrIUaOVlNJQ1LZ/p95N5qEzEVpj?=
 =?us-ascii?Q?TwLc/mKMkR/J0dFgz6qlIJi5FFlucyUNzhZ5fz46iwod/flNWmFekQSciPt0?=
 =?us-ascii?Q?nfcNddtnrEc/KbSU6PHmsqrTR48W9Z/XbGrR1XPFQSe0T3sk+aLHJxNG4kJj?=
 =?us-ascii?Q?yQGwVUF3wiB0mrRXQsTwuBPwG6mYt/ljW2lKMPCLz88Yd3xzYZfg4yQa6Sem?=
 =?us-ascii?Q?hQyOfCWnA58V0VaGzZjVER8PeVMdIsAZrwtej2E8BeIdsjh/RtnxAzNNUFAj?=
 =?us-ascii?Q?Xy8Yv8gCH64wG5cA5Hzgxa+Y/VXW+yv9JTM+FXp8EKrhiJQKwt/Dn7BaSAoi?=
 =?us-ascii?Q?g8s8KAzGeasGeU1TvJ1n357zq0a0k50myq9dCI1iABygyfdvplRSv4DolKzh?=
 =?us-ascii?Q?8J9PNDFg0xcCfkuDMbm9Bxm3DycIln5iAGCI/VjEsJFOy+B3UhdQ00I/hgJ0?=
 =?us-ascii?Q?GNQ2IpeJqLe882dz4Z2PifUsdb49dpGLxo7bUgMcQ+POYlRZ1iWOCB6RqpTU?=
 =?us-ascii?Q?MmXxbMe7ArDf52o9P56ORIpjwXBsgnunBonl5AhBDp4FMIt1ThS40EE4Is+m?=
 =?us-ascii?Q?yNOvTljY30n9p2AbDeJp8yR9v0GbCG5FOWo5ZobFdLkI713Skl8hzMOv8UJa?=
 =?us-ascii?Q?1DNXvPqCsKVGCMFaU8w=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(376014)(82310400026)(36860700013)(7416014);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Dec 2025 11:18:01.1522
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 0b86a8ce-eead-4834-9a4d-08de42de1990
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF0000231B.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB999108
X-Rspamd-Queue-Id: 0744AC0007
X-Stat-Signature: au3adfzaccx6bntqro7hctr97tzii6he
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1766575085-724988
X-HE-Meta: U2FsdGVkX1+TAAeS5iViXE5+U8q/C8DjwYRoIvWn9taKx4x37Nl0hkdXWLoKa34zeq1ZbODM5y+lNKD65oVR1ELYqU2ndAZb8YCSyyAhMHcnzJ7n5XDAr3b6bHvP6tZqVgcr28e1sVpmvBYLO71q1Cah6fxobW22NdiqBz4hJskhAw0A66IgVVJgMDHcbyQmgIjyFnKYQ/eDJyj80fQHVRijdw90Kfz40npP5j+1C33pcuynfUTqXBKJz4LETsbSWO7B6gNi8bSNIfo1cI8be0aph91lcXnItLrgYpvE6DEwdXJ4hafcX3ubwfl3vQzXHxsItQ6037hnF+VTEjU/YSCOeggJf9bMADZOuEyU130u3VDzeyv1c3f9d6lIuGbeCNyPsG2gtdofgRSPmFhmSb+mdYaIvNb6WN/Rx472CGxNzbbXHd/6o9gnEtoxI/eDbKlTtyCMqwpuGWQji26l3Q2dbF9/1wrhZZHFMSXgu5yKMpS1BakD8j3veRWwNlCMjqR78H0olJrDdzTSGDXhpeFNiZYy+0YTyKcqb2SkieErkSsNOUcVeifDx0M+Z3fBxE8JNSFU+EmSDIXhJKOz0gftvhiZnsQ9x/Ul87okiQb7xKSDAwF9B246czqQh4/WwtiG9mCg0JTgjZiNGXSwXmoDfMpsuc0NVC+gNqpR5I9IOpcQ/nfU8TUjjhY1FHJvRjW740BM+OHvPES3f5W0Ao8NY9htMtR2Pdd/9DCO/XG3Vexgnnk0zW4vQ+wiPiq7538sECK7XFU4eJWyToZjBhQId4rdkLBniv+4qxlygjm87o6JDZfy0Ept+ocKF/0hW3H72diQy5xF5ESKcL1GBi4QWL/Jtp+cp3/KfxGjhnIDIqxeus3rwGegvZXytuxWBjLtX/G/ZaNyVpinzQ0OMTCPSBLsuaDrPi6cBN+Kj3dD0Z5taH3NKhcvWdQVUfepk3Dv+FA7y2NKIF8lKX6
 1a+XBfXR
 MVx9nKAEYdhmHgKFAEp9ob9RAzgdgPGW4ZcIAaY/drDwq2b2LfyVSUhJ17uhBLczrvjWfu8ylzSlhgi/DBugcN5OTXgbB0lTXfvhTfVUqKwEnfqD/YNhCwcbNV4oPNM/m+0XUgdPrhUNRlc9MN6c8YP3PbPKJ+4lkZDCI/rGaMi2LzSqAMLNfo4cjVgTBZnryBAmYMThp6ro1rTB4GGEwtm0+1DbEl3xTQfFjaCU5ZY2xhEFIdLN/B7eyfzIisUdNuh41IYr3SdbkbTN8OS8zYqA33i/o9EoFkklbtJOYHjD+nW7P121jZkAjlEdo6qRxXUc08xQaxKX1ke9atiYl7CPu6ay0bqRE1ZKdUd9LZoWOK9hdnZjipB/qPJz5KNjwi826+kjirQyUtWkh70X5Qm5rDim0eryas78oCg9JWWEmFeuEwbfqxiRkyk5YCmAhWg4s+SLjF8j6MkRSC+1W4/ZWLDcM4vDX/EeQ8kqZSdoyhGIY0EE9Is/jrz0IBdpUXWKi3lttMeLwTfBgSsnuEomZr8TWfK6ytPX9yvdeW4rYZa8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The khugepaged_scan_mm_slot() uses a 'progress' counter to limit the
amount of work performed and consists of three components:
1. Transitioning to a new mm (+1).
2. Skipping an unsuitable VMA (+1).
3. Scanning a PMD-sized range (+HPAGE_PMD_NR).

Consider a 1MB VMA sitting between two 2MB alignment boundaries:

     vma1       vma2   vma3
    +----------+------+----------+
    |2M        |1M    |2M        |
    +----------+------+----------+
               ^      ^
               start  end
               ^
          hstart,hend

In this case, for vma2:
  hstart = round_up(start, HPAGE_PMD_SIZE)  -> Next 2MB alignment
  hend   = round_down(end, HPAGE_PMD_SIZE) -> Prev 2MB alignment

Currently, since `hend <= hstart`, VMAs that are too small or unaligned
to contain a hugepage are skipped without incrementing 'progress'.
A process containing a large number of such small VMAs will unfairly
consume more CPU cycles before yielding compared to a process with
fewer, larger, or aligned VMAs.

Fix this by incrementing progress when the `hend <= hstart` condition
is met.

Additionally, change 'progress' type to `unsigned int` to match both
the 'pages' type and the function return value.

Suggested-by: Wei Yang <richard.weiyang@gmail.com>
Signed-off-by: Shivank Garg <shivankg@amd.com>
---
 mm/khugepaged.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index 107146f012b1..0b549c3250f9 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -2403,7 +2403,7 @@ static unsigned int khugepaged_scan_mm_slot(unsigned int pages, int *result,
 	struct mm_slot *slot;
 	struct mm_struct *mm;
 	struct vm_area_struct *vma;
-	int progress = 0;
+	unsigned int progress = 0;
 
 	VM_BUG_ON(!pages);
 	lockdep_assert_held(&khugepaged_mm_lock);
@@ -2447,7 +2447,7 @@ static unsigned int khugepaged_scan_mm_slot(unsigned int pages, int *result,
 		}
 		hstart = round_up(vma->vm_start, HPAGE_PMD_SIZE);
 		hend = round_down(vma->vm_end, HPAGE_PMD_SIZE);
-		if (khugepaged_scan.address > hend) {
+		if (khugepaged_scan.address > hend || hend <= hstart) {
 			progress++;
 			continue;
 		}
-- 
2.43.0


