Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DC3D6C9830C
	for <linux-mm@archiver.kernel.org>; Sun, 18 Jan 2026 19:27:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 508376B00BB; Sun, 18 Jan 2026 14:27:09 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4B2F86B00BD; Sun, 18 Jan 2026 14:27:09 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3BBD76B00BE; Sun, 18 Jan 2026 14:27:09 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 2A3486B00BB
	for <linux-mm@kvack.org>; Sun, 18 Jan 2026 14:27:09 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id CC0C559800
	for <linux-mm@kvack.org>; Sun, 18 Jan 2026 19:27:08 +0000 (UTC)
X-FDA: 84346067736.28.2C43FDA
Received: from BL2PR02CU003.outbound.protection.outlook.com (mail-eastusazon11011061.outbound.protection.outlook.com [52.101.52.61])
	by imf01.hostedemail.com (Postfix) with ESMTP id F23EA40003
	for <linux-mm@kvack.org>; Sun, 18 Jan 2026 19:27:05 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=bc+mMATi;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf01.hostedemail.com: domain of shivankg@amd.com designates 52.101.52.61 as permitted sender) smtp.mailfrom=shivankg@amd.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1768764426; a=rsa-sha256;
	cv=pass;
	b=pu0Kc8fCJ53nKwYB3cyLWDPYP3aIS6ardXRSruoAew3bbe+nPNnv/ODf37RRCEugYUjjkI
	dRnQAc9T0XEqf5BZzb6BNpJQv+f/P/Pr1/azeNnC7Y8s70fSmm598juOSv8HdpI3aENrQN
	BbzDwEuZdj55r5mdEZAOFD7bewGy8IY=
ARC-Authentication-Results: i=2;
	imf01.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=bc+mMATi;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf01.hostedemail.com: domain of shivankg@amd.com designates 52.101.52.61 as permitted sender) smtp.mailfrom=shivankg@amd.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768764426;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+9mkwIVOCFLqRySd16GZAq3q/7K0ukQ/gPvWr34d37E=;
	b=3WNR5upGpAycMEqGOB9QSYxAZGTRIsIyoXe9bc8cPm2/KjOPtuILDl9OWPbyCjMo6MF2Wy
	JREBfXk0QpXhtev4pgOaFTrhArZUM5xT9HEKS6rEqfTGdXvZohqFVaeU+t1Wm0m0NcUJFH
	EqJz4tX7UnGrg4tzAedzZCjgG8/S0rM=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=nyQ/UKtR3KoZ51gHJiQAY9DS5f/deR+M0po7+YpI8H7xEXkSvazLOEVylA9q172j0gnwNv1o1lU74+exlAGXT3Tbl3wRA0LhV7grUY4RaWgtAmM/FheGCPU9NnDD9DfqX3fdmfc7id2jYdhYl0WIO6kzYeX5yceZjdRuS5Oa7OLG+r3a6OfmNVV2uJnhnxkGwKdBCRXztPdm0MNYUD55joHzYp1wDJTVWS4C+JvlFVFaVULArfJ7RA7Xopqloosqv5hhiOUplxQj/m3/rFDw/ZpHmi3a3vi1SAJj6cz+jgVg14cSo2mGHeDCcBRqJCSQYk5abdC3T/gubdPp79qTJA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+9mkwIVOCFLqRySd16GZAq3q/7K0ukQ/gPvWr34d37E=;
 b=r7UMwgK/mamaeSXpcMxOG877Cyqy8ZN2Z0oJ7JNG/I2mTA+0JHQ/8/YSeqDQz3Y3ZCSxapU5UKB2USsvnHujEiV61r55+BluLtPJJOZHUqNfyN/XHPEUrIz3CB45NQTZvwq+Sqr0Ux1WrOLfG2RWkha1zBTF0LGpSexp8GL6juj28yuBY9tvpyc/f/i8ctW+pOHOxIZSBBNw1CdxaXyV4NppsEeEyhMoPXes18d87q/A6BnpFWlP/YrOhNkpJwkNeNH+FR0xhf1Bcecn2qT9SXlLBryHRG4PkLYo45PbrRZnhy0/E53OyJ6euervSnIGpyW2pk3I8aq6ofeIfIO6Ww==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=linux-foundation.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+9mkwIVOCFLqRySd16GZAq3q/7K0ukQ/gPvWr34d37E=;
 b=bc+mMATi3bzoJCNL9K6IOl79OOKCDhog+T+kLUEilo8sXqJJLsjM4RcIB0MHdehdZ6BVQ3vl+YRvPPEU8fQ6nKO4gT9hgqaYlsuLQZ1/efbAfkbi5y/0uqg3FIgHlGgNKzTP7HImC34alWTm5ZnrXjU4lM2uaOG1/tK2+NpK7Gg=
Received: from BY1P220CA0013.NAMP220.PROD.OUTLOOK.COM (2603:10b6:a03:59d::17)
 by IA1PR12MB8264.namprd12.prod.outlook.com (2603:10b6:208:3f5::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9520.10; Sun, 18 Jan
 2026 19:27:02 +0000
Received: from SJ5PEPF000001F1.namprd05.prod.outlook.com
 (2603:10b6:a03:59d:cafe::84) by BY1P220CA0013.outlook.office365.com
 (2603:10b6:a03:59d::17) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9520.11 via Frontend Transport; Sun,
 18 Jan 2026 19:27:05 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 SJ5PEPF000001F1.mail.protection.outlook.com (10.167.242.69) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9542.4 via Frontend Transport; Sun, 18 Jan 2026 19:27:01 +0000
Received: from kaveri.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Sun, 18 Jan
 2026 13:26:56 -0600
From: Shivank Garg <shivankg@amd.com>
To: Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand
	<david@kernel.org>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
CC: Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>,
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song
	<baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, <linux-mm@kvack.org>,
	<linux-kernel@vger.kernel.org>, <shivankg@amd.com>, Wei Yang
	<richard.weiyang@gmail.com>
Subject: [PATCH V3 2/5] mm/khugepaged: count small VMAs towards scan limit
Date: Sun, 18 Jan 2026 19:22:55 +0000
Message-ID: <20260118192253.9263-8-shivankg@amd.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260118192253.9263-4-shivankg@amd.com>
References: <20260118192253.9263-4-shivankg@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: satlexmb07.amd.com (10.181.42.216) To satlexmb07.amd.com
 (10.181.42.216)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ5PEPF000001F1:EE_|IA1PR12MB8264:EE_
X-MS-Office365-Filtering-Correlation-Id: f1b92ba7-342f-46b4-4723-08de56c78e19
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|7416014|376014|1800799024|82310400026|13003099007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?1sZC4w6QGfhrz0qgbK/qtFpU2HNnS4hWPyNNsz7OJt4/w9nXnotsok081eOm?=
 =?us-ascii?Q?b4GWYYMy1xxXuyuORkA4m6x5yRK5R42Yqs7wRjNYSwlQfJLhExqREz47/gcw?=
 =?us-ascii?Q?9gKb1oUvtTrBHMkpTr170lqUMsru1o+cTjUr0gC1IBFxxzu/+QyvlzT7HZnT?=
 =?us-ascii?Q?ypETWVV2H5UXPH1G0tPpWNqTvrwBNGoB50UmzyOt293IiJedUMOvcjJidDxO?=
 =?us-ascii?Q?4MwZwovVGviQjnf/0WeiOKagkVo0qtGVBj7CB5PTiXtrYY29/xDdccEClQ6j?=
 =?us-ascii?Q?jSROBSBBobekYJKUvyVqY9XuwgjIGBetCKSjYL7nXBCIN5xOtizwRc992z1a?=
 =?us-ascii?Q?5b+VprTMs5LU8CVpJSdBfa+mxFrmnEIIQlMwYA47ULNBmEZA86y0z8jCkjhF?=
 =?us-ascii?Q?+IbXN9baakExlmPRwcYxhS8OJQAaRymsTK559wlzAt4lBwZGG/8yeC0jfIlD?=
 =?us-ascii?Q?Ec0o3iGe99ysAXZAAn4Ij9FL3vU81TpZ7wPfE5nD2HdpPSAQRSGtMN4OqpUU?=
 =?us-ascii?Q?wkCJkXaI9g77wUdvTj8rr9r5Ko2fmL7/qtdITgQjqMpqAPFjYZBf5nMMBW4/?=
 =?us-ascii?Q?cc75cyfNAAbIH0L3RtUGny4QzuHD4isiOGa6Ds0Ie06fWEo8ekulZRxK574E?=
 =?us-ascii?Q?eMfmSVyuMF3ihRwCFqgRsc4pj7tmQQLf9rloXTnromZ89pMZR/RLjWmCkymS?=
 =?us-ascii?Q?1sYdKpgeyrm55uLzRfzJlbhbOnAFdcYViPHM8X1v1t5NPSacISqGWT5X7xYB?=
 =?us-ascii?Q?ZLQCFXCQ1adVj1wVfx6yK/sVP5nMYkYHnrzLp7+jc9eYLs7ZgS8Y81Ldxlem?=
 =?us-ascii?Q?6Ve1P8aimjwYKyPZKHrjEb+IAxV/T1YmVaawNrCwBPZMMUGfE/MfYIM4AD3s?=
 =?us-ascii?Q?0GLedBtf9wbG2yUGpM3P1i87t5Ieob8l+j7WvrG0RfwOjOilQR2Xm1YDaHIh?=
 =?us-ascii?Q?uKPv3wZ3IUaLfN+gI1oDJLxsF2m1/Im5FoOmb5h02GFGy8SgzwkBZVqXQxvy?=
 =?us-ascii?Q?vo+r0NlxZf7hc1hrg/Sq8nLSQ98cG9SoYLzFXlmn9y9YI+lfFIITuEjAtdVy?=
 =?us-ascii?Q?+nE6jDUGsBaXinW+XyR6IrwGhU8nAPrBa9OchdrUwwjJDk6IeZ0cdh8pREHp?=
 =?us-ascii?Q?s9tINHQPN+732YVN0FOnc7cMU+LnAVnrNP5yqmRv/BjEoNgoMV/LZkx+BS/N?=
 =?us-ascii?Q?kMi5WwuoOWomDr/7rrFmCNckR50rz+F0m99cGETdbOfuFU7rAnLsJ6Jc1Drh?=
 =?us-ascii?Q?h26duLtberb/Y3gPA9XOPCujDHnyn1AT4u026WIeuWTbjOQzugE0w0Z0QLRm?=
 =?us-ascii?Q?98KNWjvRd/4b/AKBUKKmQRfOlhb87e1RZhJK6WWNhANKormTwZGctT3EvnfQ?=
 =?us-ascii?Q?lI6I2Q/0Ttw7L9pLJs7qacyzctXVb/XGvINkcmUU2IgihhVrKDcrPaNva9KD?=
 =?us-ascii?Q?laxV//15wyu6K0EPKFgHvCGzZw5cx1LqcsMegES5gwLcX21VVkOB6zW3WGMq?=
 =?us-ascii?Q?q09K+7G7xuUM1uzENE7ee1UrYtgFgo3Vcfg9ziVHpt/5OSbwKP3EZdUN2Lgl?=
 =?us-ascii?Q?aCUX5XiarETNauQ32+RClpri0OclSv7KoNffDQaR0LjFN/sNRcRNkWC/W7cm?=
 =?us-ascii?Q?L6EuqB9fC4yuOeOUrXRmPTK4mGLjBKKKYeg+lQTCAhdxry7nd/jaqrnRv9wg?=
 =?us-ascii?Q?xNgrgw=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(7416014)(376014)(1800799024)(82310400026)(13003099007);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Jan 2026 19:27:01.4358
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f1b92ba7-342f-46b4-4723-08de56c78e19
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ5PEPF000001F1.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB8264
X-Rspamd-Queue-Id: F23EA40003
X-Rspamd-Server: rspam06
X-Stat-Signature: sbc8s1584pzd15ff1utm3ar6zdknzo5d
X-Rspam-User: 
X-HE-Tag: 1768764425-21524
X-HE-Meta: U2FsdGVkX18VlFKxXofa+83JGPis3b1IcEBwmhdIVZhc+tinDrbcVvvOlj9N3fGr0ecQTfT45DKRxRAuo7fQ2DK3SMHjt1GeMaFQUYdHDAaT0EZuuo+iUUZ5s+nkFcbGecJXiR6vV7wdmCO4XGt1xeRh19IzQh0CYW1l+uqdkhobHp7aBChViha393al7lcW0COO1mghM+tE9s10NFaDgFplR1a8NwSVMT7smiQm+aZy20rOO80v16fswfWP2T72QxSquez/jdQmC2RLFVUxxl658jlqvlS1sa/E4on2L/IbxSY/SJQc/JIZz2wsD1qFumXpW1Mo+E+GYovWA+Bd6a/jHEC2S6pWj2+9ldLsCYGWc6BYvv9ZRropGib0CWof738kalUhkJKj7kYrzYKyYBij5bLVFxPszm0ZuhnxskS1rGJzO9nXo5aXLHSW7Q30zOb9jH891i0xyeUnc04y9vwTmZGRSev4PEBAVELnsU1PjS2yz6uvnx0z3Fh7z8GejbGGwIYZ0jUmB2CQ8GZ+1ULd33FdaE1+Xgz6CjFCOpaVTsN+XnxU0KgHc6wmeIORwu5GrDikXLv1G/CZNcm5NbCv+OmgJmnPEVIJMrgy4uIHRZiMnfUO/OTCTMaPNl9HaBw7kP5HTqB5GkeTGuB04UdqEkMbF4LtcvQfBtiplEX/SQIh7zjYY0C1g3C3VZpCkaiF/YFNt1Eg8mg0v5DSGdPnn5l5pyDSlNUpyJOY5CjGI5Q/rfuxh0Lv9trCcif7jMDRkLNe/pfFSP1kXLZrF3NrOAO1QNIp/rlgXIQA2vkoFc0H6gMcT5NIXq3CxtIcWhdcyDD+gCsM4CPC6Swcm745D0YILDPbIPWGMklFb3im4wxTciTjlomRkHWdcNjwc2QRIZsHVJHw/35O7NsdxUPVL6L1gsAH1IssV8AesbLhaJJhFhWasd1gGEqiF9WwpOJcmgmKt46YDQ0h3nW
 ezqaQUSl
 gm89RXfq9x4GBPi6HxWFjXbOVYScXz/gR3g9nRiV328SbSt2MxlOqOYiT4xq/QyPcB/EDJgjEtb+BEbBsoiOEoUwO8rBh0Jz8cxWvDaoqKDCYm0EBTt3MjnNeIhQgmJ7qKlhI09T+AICDANECZ+XGQI2GpVEbVSbsnG044muIpn/LlaQEo5oMWT/hvP0zhg5XmbivvXMSTQWbMYX0aYbKKxUnhA3FST5Eghny+fMRrp117eTxAdmw658XodJhxOm0x7YFfjxfxPpSPUGvSUR86hVkNgWU9A0ECLeORz6ycuon5hAJLedZmHuDTxFFJ4883CorMZc367rZIWWTvxbxWFvbeMkbewKLuy4C64p+36uA66BNT/0BWxKsyevJIucQHg7mNqBGNgpp97SWIs1vV6PtN8tyR9m/N4XBp/ibyMJN+avWkRPuhu8UdK3bagXVjZF1ZHWBA+2MNgFATunoMxXU26H8X5VXECVF3c/dT5lelfS0bpuItEa2D3cWfMiBBu1mR1kZutSTdFL3eUim21PUrXml3W6bOsf4aeHWByMIDH+jvYeJKR1spbJEJQCx+NkC
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
Reviewed-by: Wei Yang <richard.weiyang@gmail.com>
Reviewed-by: Lance Yang <lance.yang@linux.dev>
Signed-off-by: Shivank Garg <shivankg@amd.com>
---

Incorporate comment feedback from Lance:
https://lore.kernel.org/linux-mm/6b408736-978a-4d40-adfc-97819951c3a6@linux.dev

 mm/khugepaged.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index 984294a16861..93ce39915f4a 100644
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
@@ -2447,7 +2447,8 @@ static unsigned int khugepaged_scan_mm_slot(unsigned int pages, int *result,
 		}
 		hstart = round_up(vma->vm_start, HPAGE_PMD_SIZE);
 		hend = round_down(vma->vm_end, HPAGE_PMD_SIZE);
-		if (khugepaged_scan.address > hend) {
+		if (khugepaged_scan.address > hend || hend <= hstart) {
+			/* VMA already scanned or too small/unaligned for hugepage. */
 			progress++;
 			continue;
 		}
-- 
2.43.0


