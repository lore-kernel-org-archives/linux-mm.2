Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 10F9CD3B7D1
	for <linux-mm@archiver.kernel.org>; Sat,  6 Dec 2025 10:19:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6A0006B036F; Sat,  6 Dec 2025 05:19:01 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 677286B0371; Sat,  6 Dec 2025 05:19:01 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 566386B0372; Sat,  6 Dec 2025 05:19:01 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 424956B036F
	for <linux-mm@kvack.org>; Sat,  6 Dec 2025 05:19:01 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 0E1C2B914A
	for <linux-mm@kvack.org>; Sat,  6 Dec 2025 10:19:01 +0000 (UTC)
X-FDA: 84188648082.22.13AC808
Received: from BL2PR02CU003.outbound.protection.outlook.com (mail-eastusazon11011023.outbound.protection.outlook.com [52.101.52.23])
	by imf20.hostedemail.com (Postfix) with ESMTP id 53E331C0015
	for <linux-mm@kvack.org>; Sat,  6 Dec 2025 10:18:58 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=wZx+UeTa;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	spf=pass (imf20.hostedemail.com: domain of bharata@amd.com designates 52.101.52.23 as permitted sender) smtp.mailfrom=bharata@amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1765016338; a=rsa-sha256;
	cv=pass;
	b=GlbG68Q8mfHrNjy2Ot7bQvX/rOeUdC0tCoPh0xgATM3L4pRtG+wueK/OqbqskaTnt0PGEA
	jERJ7TtkjiCfXN3P9lUU+eeT//EHn9bA0dPpuUGKKCbi7YTBJDMGBTfYQIAiTl+sZEjRpI
	Gkwi7/0j4XHpCr79GHK8Mk+mCcJMzks=
ARC-Authentication-Results: i=2;
	imf20.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=wZx+UeTa;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	spf=pass (imf20.hostedemail.com: domain of bharata@amd.com designates 52.101.52.23 as permitted sender) smtp.mailfrom=bharata@amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765016338;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=axsjd7B0xZ75s+ndOSF3CKmYiMIzg90s3Itcumjx4xo=;
	b=oTLopyM5TNcBvgNdUq7GSCTsimDdiQVjlrElnjcFl4EOlKJH+shgmnE7ZlYGhdA4MKCJdq
	zRRtrCwGLV0Sq6erfCyncTl2A1aY5apLMwEu82yPbvRV60H61CoHuIJ9IeE9W2kRANourd
	iJ7W0gFTUA4NwOeckhJ3VkQe8W0+JPw=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=iN5h4rg5SJahmCKQGjK/ZNO2M5MjlCcZ8u2kXe7Hp+O8/+NW+4bBYjPMu3Ihp7vpGeEjcCEEHjmO6PVhbBdN/CDJI+OQ0o8mbwZAjGaFRLyThyLmV3I1vhYM7ibtjMyS3LSAKLF2YOPiwLCaetYL60+xHRVw8jyctslZ/FcnaZC6zuDzRXHIqqsRVgUN64uHzb29YQn5WblRykEIGCAwlfIk04ZSVWVuWXBKuH/XaqKWdhx7Dc7KzkYxSNuFGuLgDP0vZ6DhZp2r2Kd31gQ4Ap0L0wfdyzwX0nrKQsz87GP9KLDZmyrcGQSb3HVrYarPQL2UU8Z3iFPP3P6TDk63eQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=axsjd7B0xZ75s+ndOSF3CKmYiMIzg90s3Itcumjx4xo=;
 b=i+nThe1c5PUIqs+3Zph9ICKP0ToD9PFVtdQv68ycF/YUwsCkLB3rp42E+IdO45GkZKsmBMSjOw2Uc56s/ceWDr1WY7vgWwuHz2TJq4dhNGildBq65a2d96IGINS8jCer9EunP/Y3dQYAq0SM6foRf17h8FW1KTK5i1akVlpXYeRVj2oMniTmHZDZB8IcVWkoZl+8ygEz42mzgFsKTicTjl3685rqVRlMaHLE0zN1GzpC40WEdcZCN5iMdomHMbr4yYcwPsQAayAvrL6G6PDMIaLFM6bEZJLJqOwVVtt8dFIYAwBJXYWh4QN3rIGBVrPbB94pWPEaR+9Ut2N6/UDJwA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=axsjd7B0xZ75s+ndOSF3CKmYiMIzg90s3Itcumjx4xo=;
 b=wZx+UeTaiPepQKRewrFML0seC5yYcHcTDJMfqZmhqq/vyET4zx9MFjp90Wwq8LE3T5VvOg8yGOhaeoTWXcO/6URzD7YfD+ljDls+JU7O+GkjMhu1vp8onJwyxXtASAZ6DCBxss5w+kl4q82IYpphliQ3FCmKCB9v6J4cWNu5WNY=
Received: from MN2PR07CA0017.namprd07.prod.outlook.com (2603:10b6:208:1a0::27)
 by LV8PR12MB9406.namprd12.prod.outlook.com (2603:10b6:408:20b::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9388.12; Sat, 6 Dec
 2025 10:18:54 +0000
Received: from MN1PEPF0000F0E0.namprd04.prod.outlook.com
 (2603:10b6:208:1a0:cafe::e5) by MN2PR07CA0017.outlook.office365.com
 (2603:10b6:208:1a0::27) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9388.12 via Frontend Transport; Sat,
 6 Dec 2025 10:18:52 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 MN1PEPF0000F0E0.mail.protection.outlook.com (10.167.242.38) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9412.4 via Frontend Transport; Sat, 6 Dec 2025 10:18:54 +0000
Received: from BLR-L-BHARARAO.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Sat, 6 Dec
 2025 04:18:46 -0600
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
Subject: [RFC PATCH v4 9/9] mm: pghot: Add folio_mark_accessed() as hotness source
Date: Sat, 6 Dec 2025 15:44:23 +0530
Message-ID: <20251206101423.5004-10-bharata@amd.com>
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
X-MS-TrafficTypeDiagnostic: MN1PEPF0000F0E0:EE_|LV8PR12MB9406:EE_
X-MS-Office365-Filtering-Correlation-Id: 6a67bce3-7032-4221-2b31-08de34b0dc37
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|36860700013|82310400026|376014|7416014|13003099007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?1FDNlq6C/DWyfZ6AMzN8/HqxSPyZ1V78W1CGAY6G2Qisfzp6qUHBLyZCSIBb?=
 =?us-ascii?Q?TxD/+2wA94FThC5Pdaejn/bIUlVBbxJ7tahJKjDLTkMFmXGYQeMAsvzkqyYM?=
 =?us-ascii?Q?uWAFjwADRJowrgdfkcsivsgWzkhp9xacKtqEBCNLcxPkrUo5p7drewte1iA+?=
 =?us-ascii?Q?uym8SNb2Wz/RhQQowv8pIRmnt5hXMyK/NtukBFag1+vaHpO1jc8apH/h6lfq?=
 =?us-ascii?Q?BSs5JeBoSO5ufPhxVqHX4PjJNarC/+/ldIwfySS78C4LHCZJtcyBz43JcvBS?=
 =?us-ascii?Q?ASzyXzXIcy2g/5ocpNjHU2d11tEdRn2odhb1HxcQKk/lJ9QIWvk4gzTq8/6k?=
 =?us-ascii?Q?bvMSWDl19ilVtdM6iG26chiGKEkG3W3BGnPL+9nxRb1I+wfJy+dhG6OPAFdx?=
 =?us-ascii?Q?hgO3kXdsMC5J2/wkUzakKBV987Ft8HkxZXA69yKy0u6nGV348jVxiNBMBhVw?=
 =?us-ascii?Q?Z89sSVDIIHeh5e1bQ8NfcmTUYtFu+ZfDJA5qp2vVOKWVbK/X8+O/MGS5wGE6?=
 =?us-ascii?Q?y43AGdCED/1RfVZrJfHZZDzhbeixM6y9NBDeL6HTPvhURCQ21YXFEtixCQs1?=
 =?us-ascii?Q?mBnEzceuNicWbQqizmB4UBWm1dpC/SvfHDSnvvB+HqFKW37xrjJrzhrIDq2h?=
 =?us-ascii?Q?j/o9a6gHwRQCiB8jhQWaCRWK5RM5EWjI/woeo5z6nXjXQkmrqSPJmJHs0o5M?=
 =?us-ascii?Q?k+1l/YBlA1towEPZapqn0W3vF9wW/LiRDJTWlIQJHUNGJMZwJ0v3WIkKFoyk?=
 =?us-ascii?Q?ipoHvmWXjlGGCGd20U933MCcNy96cfoEaMYJn6Cbbe5QMb/HFrNyASfUCTae?=
 =?us-ascii?Q?XahpdaUsdcAXnXMMYERInyvCZg7sFjC4F9I58y3SEivFTP18djG+QLL9WNQE?=
 =?us-ascii?Q?XBh0XClkgeUjTtlJZnqL8qJnlyzLPyOn2AeSO+vrkifoSN3fdHRWmYmPy7s5?=
 =?us-ascii?Q?GW+bc6I8IdYOfd/spgCf/vkEbuP2enouBlh7O+OwqMPKs1vMDFItQ4T97+I9?=
 =?us-ascii?Q?8Sn2WJ/v6q83tUDMX1XgFx5/jqfXZEzQDUVLROZeg5EeDGJkxEvqUbiwR366?=
 =?us-ascii?Q?eczT0j/KFYt+ly31yHp0kaOm+dHYl5gbcJaUlCegM6VkMW3wHsnPComb5RsO?=
 =?us-ascii?Q?4DZA/7VXy5cszk68GtmxOnxthMP/IAhAG4Kqe2IG57OAUOaMMPn0855H4FmH?=
 =?us-ascii?Q?OKqsp76RKYO0mAJ9BlQwatLI8h22iEuPuwAN/kHC6UdSAaXDVYrHKHb+ObiW?=
 =?us-ascii?Q?JAfnUq2kaDeihVBW3L0I15qoTt/OE4ETbaOQxf7z1/0XWjY+zIkFIBkRmeem?=
 =?us-ascii?Q?tO8jfiQmLDTIemR8SfLbTom01j41zDdqWKxsY6pcrvfnTf96ir2kYyDKJhAX?=
 =?us-ascii?Q?SW2QxjA6AFn/piZqNuU06KctHFTghRYyaS8rK9z8/xYSt3TSTymOkImt9tVh?=
 =?us-ascii?Q?wR841h9mUzVgg2MOyRkYiNy+zYGHetp/AnbLXVaQT8RbSbtfFKwBKCnUIJ8C?=
 =?us-ascii?Q?IYwWHJV2GeYhyEYfa2Hp+57X8d5ehOSPYy3nuFallqsbXmsuQAZ/622/2PAW?=
 =?us-ascii?Q?1UCBCM2S/AsFMpCZ7pE=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(36860700013)(82310400026)(376014)(7416014)(13003099007);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Dec 2025 10:18:54.6258
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 6a67bce3-7032-4221-2b31-08de34b0dc37
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MN1PEPF0000F0E0.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV8PR12MB9406
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 53E331C0015
X-Stat-Signature: qocs4cq3aqz1sm3ik4i7k9z5uyj54ubj
X-Rspam-User: 
X-HE-Tag: 1765016338-746600
X-HE-Meta: U2FsdGVkX1/Ta3LWNFn/mkYfQ8Nu6oqHJXijvXyiMr9mIX3MXCXqdTnnkX+MPMySfP+CteDLKWKqLypfEY2mMFnRuOsLZZJiaauIvSF2pWZ9q5A6xzBMWF9X1mr+Y7+UrJll7f0UFeu4p905jh7f5ZEjeber95jGLbim/mW1oUa2OEGPQ9GltW5uAXGq0bHBCoxQMzVkE+Bwr9aF4MUwqJRPif6uvVDbaeWvSCwWoMKw6OfpyKK+6rmSl7m5q6n/S7yDe+Y/IoDs72O2n9LREYtOEV8fqrnbF4G0zehDtG6gnCUkTyY3dO8BqTvxOGF7gxVbR3T+RE5sYcNFRRGcrCsUMX2uEEDAfrh5MlBApD3DUcl5Uj4QBKgnmGjGU/cFvYn1CFTVXdRJHGZs+4utQMTnhJZ91k9kOVxr5obCQawJzBpSh/lZH2pluL6L7Vg5VtfV9pUG1/8p+hMx11w8kYE7z+CizMsj/ckoUk7YeKD2f2xTky0sAr4KEOmWFwG/DhxvNjOIr/WQloQ3F0s/xzxSdJLFuae8lkOpWoj14XKeWGj6pwg7x5idevhm98uo5Wrv5iVBwWLcDyN6SVFJevsnsVbPfvs30D8xBCBnp3GGYToy3iORyBhgBByyWiHrYKenBCSU1x/lR6S9G3qaIKC6HHGp+ApOVbN4kCD2TmpmuYWuaA9rQ1uysZTZslu0dxuJppl4FGZVVpvjARIq2CESPt2bONatLR3CmXig60uHlBRgQKOwL1IAemQAx1thwYzdLy8bYC4NfHsO7JVlijc2gFdFountsOxzb4yS2DF4ZIpZ1JfO4XsGE1OkystCK3oF1F5PQBDrV27nCXeOFDYoiGJWINzAP8OUrgxLHH6Z01nxAW+DVH7QE3nN20Tqkp55WxAfc4f/ExUnjByzPwMqBXiRH7SOm3vPK8O4j/ET3fQdzYFkwTHyKzIwm5p/LXRBsjnNSMiVkcMAY1x
 ELI2aWIG
 xFy5S9kvO+I+cIWXKeuO1i5CkaklqUOXjoeH3t7hZbvv5r71MoCgaMnLV1snHHd8ILP5N/ZznPl6GL2DM/SsPoXXLxudCB/1cAcs32wo+o0ei5nPi5AbUfrEG3CwuJ+JQ/G5q2iDukf4qA7d3A9E3nPylibgzryXM0EKSdhDjTAuSQ/rDY8kgbazmdXyCtANxIUoQ
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Unmapped page cache pages that end up in lower tiers don't get
promoted easily. There were attempts to identify such pages and
get them promoted as part of NUMA Balancing earlier [1]. The
same idea is taken forward here by using folio_mark_accessed()
as a source of hotness.

Lower tier accesses from folio_mark_accessed() are reported to
pghot sub-system for hotness tracking and subsequent promotion.

TODO: Need a better naming for this hotness source. Need to
better understand/evaluate the overhead of hotness info
collection from this path.

[1] https://lore.kernel.org/linux-mm/20250411221111.493193-1-gourry@gourry.net/

Signed-off-by: Bharata B Rao <bharata@amd.com>
---
 Documentation/admin-guide/mm/pghot.txt | 3 ++-
 include/linux/pghot.h                  | 3 +++
 include/linux/vm_event_item.h          | 1 +
 mm/pghot-debug.c                       | 7 +++++++
 mm/pghot.c                             | 6 ++++++
 mm/swap.c                              | 8 ++++++++
 mm/vmstat.c                            | 1 +
 7 files changed, 28 insertions(+), 1 deletion(-)

diff --git a/Documentation/admin-guide/mm/pghot.txt b/Documentation/admin-guide/mm/pghot.txt
index 13b87bcfa6a4..485407f2b288 100644
--- a/Documentation/admin-guide/mm/pghot.txt
+++ b/Documentation/admin-guide/mm/pghot.txt
@@ -23,9 +23,10 @@ Path: /sys/kernel/debug/pghot/
      - 0: Hardware hints (value 0x1)
      - 1: Page table scan (value 0x2)
      - 2: Hint faults (value 0x4)
+     - 2: folio_mark_accessed (value 0x8)
    - Default: 0 (disabled)
    - Example:
-     # echo 0x7 > /sys/kernel/debug/pghot/enabled_sources
+     # echo 0xf > /sys/kernel/debug/pghot/enabled_sources
      Enables all sources.
 
 2. **target_nid**
diff --git a/include/linux/pghot.h b/include/linux/pghot.h
index 615009a39348..c0919baf69e4 100644
--- a/include/linux/pghot.h
+++ b/include/linux/pghot.h
@@ -17,6 +17,7 @@ enum pghot_src {
 	PGHOT_HW_HINTS,
 	PGHOT_PGTABLE_SCAN,
 	PGHOT_HINT_FAULT,
+	PGHOT_FMA,
 };
 
 #ifdef CONFIG_PGHOT
@@ -28,12 +29,14 @@ enum pghot_src_enabed {
 	PGHOT_HWHINTS_BIT	= 0,
 	PGHOT_PGTSCAN_BIT,
 	PGHOT_HINTFAULT_BIT,
+	PGHOT_FMA_BIT,
 	PGHOT_MAX_BIT
 };
 
 #define PGHOT_HWHINTS_ENABLED	BIT(PGHOT_HWHINTS_BIT)
 #define PGHOT_PGTSCAN_ENABLED	BIT(PGHOT_PGTSCAN_BIT)
 #define PGHOT_HINTFAULT_ENABLED	BIT(PGHOT_HINTFAULT_BIT)
+#define PGHOT_FMA_ENABLED	BIT(PGHOT_FMA_BIT)
 #define PGHOT_SRC_ENABLED_MASK	GENMASK(PGHOT_MAX_BIT - 1, 0)
 
 #define PGHOT_DEFAULT_FREQ_WINDOW	(5 * MSEC_PER_SEC)
diff --git a/include/linux/vm_event_item.h b/include/linux/vm_event_item.h
index 67efbca9051c..ac1f28646b9c 100644
--- a/include/linux/vm_event_item.h
+++ b/include/linux/vm_event_item.h
@@ -193,6 +193,7 @@ enum vm_event_item { PGPGIN, PGPGOUT, PSWPIN, PSWPOUT,
 		PGHOT_RECORD_HWHINTS,
 		PGHOT_RECORD_PGTSCANS,
 		PGHOT_RECORD_HINTFAULTS,
+		PGHOT_RECORD_FMA,
 #ifdef CONFIG_HWMEM_PROFILER
 		HWHINT_NR_EVENTS,
 		HWHINT_KERNEL,
diff --git a/mm/pghot-debug.c b/mm/pghot-debug.c
index b6bee0f32389..fc1506c3134c 100644
--- a/mm/pghot-debug.c
+++ b/mm/pghot-debug.c
@@ -117,6 +117,13 @@ static void pghot_src_enabled_update(unsigned int enabled)
 		else
 			static_branch_disable(&pghot_src_hintfaults);
 	}
+
+	if (changed & PGHOT_FMA_ENABLED) {
+		if (enabled & PGHOT_FMA_ENABLED)
+			static_branch_enable(&pghot_src_fma);
+		else
+			static_branch_disable(&pghot_src_fma);
+	}
 }
 
 static ssize_t pghot_src_enabled_write(struct file *filp, const char __user *ubuf,
diff --git a/mm/pghot.c b/mm/pghot.c
index b28d11bf4c9f..b5780ae08522 100644
--- a/mm/pghot.c
+++ b/mm/pghot.c
@@ -35,6 +35,7 @@ static unsigned int sysctl_pghot_freq_window = PGHOT_DEFAULT_FREQ_WINDOW;
 static DEFINE_STATIC_KEY_FALSE(pghot_src_hwhints);
 static DEFINE_STATIC_KEY_FALSE(pghot_src_pghtscans);
 static DEFINE_STATIC_KEY_FALSE(pghot_src_hintfaults);
+static DEFINE_STATIC_KEY_FALSE(pghot_src_fma);
 
 #include "pghot-debug.c"
 
@@ -110,6 +111,11 @@ int pghot_record_access(unsigned long pfn, int nid, int src, unsigned long now)
 			return -EINVAL;
 		count_vm_event(PGHOT_RECORD_HINTFAULTS);
 		break;
+	case PGHOT_FMA:
+		if (!static_branch_likely(&pghot_src_fma))
+			return -EINVAL;
+		count_vm_event(PGHOT_RECORD_FMA);
+		break;
 	default:
 		return -EINVAL;
 	}
diff --git a/mm/swap.c b/mm/swap.c
index 2260dcd2775e..31a654b19844 100644
--- a/mm/swap.c
+++ b/mm/swap.c
@@ -37,6 +37,8 @@
 #include <linux/page_idle.h>
 #include <linux/local_lock.h>
 #include <linux/buffer_head.h>
+#include <linux/pghot.h>
+#include <linux/memory-tiers.h>
 
 #include "internal.h"
 
@@ -454,8 +456,14 @@ static bool lru_gen_clear_refs(struct folio *folio)
  */
 void folio_mark_accessed(struct folio *folio)
 {
+	unsigned long pfn = folio_pfn(folio);
+
 	if (folio_test_dropbehind(folio))
 		return;
+
+	if (!node_is_toptier(pfn_to_nid(pfn)))
+		pghot_record_access(pfn, NUMA_NO_NODE, PGHOT_FMA, jiffies);
+
 	if (lru_gen_enabled()) {
 		lru_gen_inc_refs(folio);
 		return;
diff --git a/mm/vmstat.c b/mm/vmstat.c
index 4160476c4ee5..5085ff248ccc 100644
--- a/mm/vmstat.c
+++ b/mm/vmstat.c
@@ -1501,6 +1501,7 @@ const char * const vmstat_text[] = {
 	[I(PGHOT_RECORD_HWHINTS)]		= "pghot_recorded_hwhints",
 	[I(PGHOT_RECORD_PGTSCANS)]		= "pghot_recorded_pgtscans",
 	[I(PGHOT_RECORD_HINTFAULTS)]		= "pghot_recorded_hintfaults",
+	[I(PGHOT_RECORD_FMA)]			= "pghot_recorded_fma",
 #ifdef CONFIG_HWMEM_PROFILER
 	[I(HWHINT_NR_EVENTS)]			= "hwhint_nr_events",
 	[I(HWHINT_KERNEL)]			= "hwhint_kernel",
-- 
2.34.1


