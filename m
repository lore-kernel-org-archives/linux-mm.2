Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3992CD41D74
	for <linux-mm@archiver.kernel.org>; Mon, 15 Dec 2025 08:47:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6FEBB6B0008; Mon, 15 Dec 2025 03:47:53 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6D6626B000A; Mon, 15 Dec 2025 03:47:53 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5C5126B000C; Mon, 15 Dec 2025 03:47:53 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 4CFCB6B0008
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 03:47:53 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 093B3160EA2
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 08:47:53 +0000 (UTC)
X-FDA: 84221077626.10.B8EB21C
Received: from BL0PR03CU003.outbound.protection.outlook.com (mail-eastusazon11012012.outbound.protection.outlook.com [52.101.53.12])
	by imf02.hostedemail.com (Postfix) with ESMTP id 28DCE8000B
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 08:47:50 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=DEUhDXXn;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	spf=pass (imf02.hostedemail.com: domain of shivankg@amd.com designates 52.101.53.12 as permitted sender) smtp.mailfrom=shivankg@amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1765788470; a=rsa-sha256;
	cv=pass;
	b=TT8lw/GAfigQoeAKao8mdkuThyrV0g/1obn1zOQWK9dVkD2PTXnGRdGDRryoie5jOQVhDD
	3Ki5qkuN0ZCf3xekbaM1676PR3szetcDFWBhJZxMoyFHI7D0+u8PybOICJUKp7dg6JVUA7
	9dQqarj6+CCg4tpm+1PsdrFiJPsHSz4=
ARC-Authentication-Results: i=2;
	imf02.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=DEUhDXXn;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	spf=pass (imf02.hostedemail.com: domain of shivankg@amd.com designates 52.101.53.12 as permitted sender) smtp.mailfrom=shivankg@amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765788470;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PWwrLB9amy9Jf/FSPwAn12dKpNXOoV6wl75rDRmX8hE=;
	b=PdH5G7NLVP4PGRQYyuRccXjDbxPelMbDMnYi2H1OQ5dL/fALs6ly/ckZNFMIIRlDDwsh74
	O8WGQo2E/PopCJG5nLsKQin1fB8vp9Qsd586GZhXHKPFOaWo7carg/ySm4IYZI/bv3E48i
	8MmDXgsqzoXQiwAVMk6jz5PG4tTnwTs=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=TgSrCVWOnsuCEGTqPpFXSfZN/hv38w0oDV9Apf6axWB2UmbK5JOrCQntVIm3IPFAUDhOIptlk84wxcqHQl3JP33u2gTTQtHTQwGGd4xMNqNfoC4eDfRpnori5z/YpkUpxmk+heCEV8+cndf/PZOfA5mSSINJCrevu+NAKerHe78XSVxsNomMfFlCq9XOppWkbhjLSq2r3c3qf+fgxRg+/gjgBOCFHds/uzrDqCx9VWNSAMLAP571BEieMzD9ocTxXC7dF106hKdfAWcnTEefQrBxEoo4LaBePGxWJJwl1qPGpp6VneUeviXf+5mozoI1o55L7+9OfkHGAOHQq/2A/Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PWwrLB9amy9Jf/FSPwAn12dKpNXOoV6wl75rDRmX8hE=;
 b=ps5xLFthE+TWRba5xoXlnMcLQ+98fCIDZIrPNTXM74jmVMukuRa2X3OONG+M2l3lqltURLEWInhMCzf9dMhklJUmzewPZy+KNx/xv87D3ZuHyKJ0JLOW17SJgHlpYsbyr6JtRUtytM9AKRRyKseTwAM83qy82K1+4xOlej1ayvgpzTbfvGyy6CmYl269bVq0twN+ulXgTkBUN+0t9Z9s4EznVYxyjPsciBmQ1IcQaJYqn4yqhyVWn80ympqgqdwCAjwTxyFcflo6Rb5jWv+40rgEw3peZB6syN/gDtQlGydChdWYSf+MfJPLkKkladtBzRTZMJCiyUscG1b4DjmZsg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=linux-foundation.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PWwrLB9amy9Jf/FSPwAn12dKpNXOoV6wl75rDRmX8hE=;
 b=DEUhDXXnm0iDIZz5uUwKxI9Oat7iwhHnNzmciuB4cap53gViWeZuec1QJQbodGqc0/PsE2RQYXzvGUo9qj/jNc2suS0op7ESIGGCy9M4DliP8Y5e017kyWWr/Cer890Ncjz9+4WMao05lHv5gh8sPPX0+5nhDMtqFHiXlyaE+Ec=
Received: from SJ0PR03CA0024.namprd03.prod.outlook.com (2603:10b6:a03:33a::29)
 by IA1PR12MB9738.namprd12.prod.outlook.com (2603:10b6:208:465::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9412.7; Mon, 15 Dec
 2025 08:47:47 +0000
Received: from SJ5PEPF000001D2.namprd05.prod.outlook.com
 (2603:10b6:a03:33a:cafe::ca) by SJ0PR03CA0024.outlook.office365.com
 (2603:10b6:a03:33a::29) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9388.15 via Frontend Transport; Mon,
 15 Dec 2025 08:47:47 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 SJ5PEPF000001D2.mail.protection.outlook.com (10.167.242.54) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9434.6 via Frontend Transport; Mon, 15 Dec 2025 08:47:46 +0000
Received: from kaveri.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Mon, 15 Dec
 2025 02:47:41 -0600
From: Shivank Garg <shivankg@amd.com>
To: Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand
	<david@kernel.org>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
CC: Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>,
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song
	<baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, Steven Rostedt
	<rostedt@goodmis.org>, Masami Hiramatsu <mhiramat@kernel.org>, "Mathieu
 Desnoyers" <mathieu.desnoyers@efficios.com>, Zach O'Keefe
	<zokeefe@google.com>, <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
	<linux-trace-kernel@vger.kernel.org>, <shivankg@amd.com>, Branden Moore
	<Branden.Moore@amd.com>, wang lian <lianux.mm@gmail.com>
Subject: [PATCH V4 1/2] mm/khugepaged: map dirty/writeback pages failures to EAGAIN
Date: Mon, 15 Dec 2025 08:46:17 +0000
Message-ID: <20251215084615.5283-5-shivankg@amd.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20251215084615.5283-3-shivankg@amd.com>
References: <20251215084615.5283-3-shivankg@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: satlexmb08.amd.com (10.181.42.217) To satlexmb07.amd.com
 (10.181.42.216)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ5PEPF000001D2:EE_|IA1PR12MB9738:EE_
X-MS-Office365-Filtering-Correlation-Id: 109f7568-8e65-4bfe-9ec0-08de3bb69ef0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|82310400026|36860700013|1800799024|13003099007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?E4AUwYqcoxYe1ACX3jKzw+0inOcjalNdf8R6aVSA8SMiAcdTeQI8bfhEdDzo?=
 =?us-ascii?Q?4c0P9MS+1qy6rfKRgSdzeVNVmgvZpEDbY4PoMgijJyK92O9YDTDIcsZDkNPm?=
 =?us-ascii?Q?R4Xar1/iapDyOw8G4uF93ZH/RnriVL5vSCPZWXKMvQv2kOIs0V+8+r7pXPBc?=
 =?us-ascii?Q?6PE1fw647HfP/STKQlOKn/rjxDiPDSriPk7QrrOCQlncTIzzQQDBmqWbWwwW?=
 =?us-ascii?Q?M9wnCTmYAEVxGC8TYn8ui8Volc7t1MIHfMqB+SrGhhAa75ZxGCbVYKVuRE2+?=
 =?us-ascii?Q?YZeFLwdRIHs11xHk3UqSiR1PLOqumR+euz2JAnlSXwqcMsaFsnzeGgFI3ef/?=
 =?us-ascii?Q?bL67nWjRmNI+ymRbEkvRYyBIkQU52ZQE6rEBl+N5Z+r7uRf/i52G5XYdRpy3?=
 =?us-ascii?Q?+rSgJ7Q8uiqitr9mRvrHNwfWCL8r82YEQgak7KPXLXqVV9cy1+Dvw0VvPdDp?=
 =?us-ascii?Q?h/SYZOQImmOh/7I76rUa08QXZLnwdsr94EpI5mSGKNiBA6yThHba717Y5MST?=
 =?us-ascii?Q?+cunxsSk+277nuYdSZBlKRlltHLIT//uzytMbhfMBBLHzzafngEvlaVcOlR6?=
 =?us-ascii?Q?DMa24sEdMzcrfj7JcaYi7jZVZfiD/owBTeKofefj7ilqVZYCHmL6tPe2a7xT?=
 =?us-ascii?Q?X9kuHBBqjYfylJye6ZhxSWZMazGwuUNFqb15jyrMYjvNT4Wha1nHk6FWyHxW?=
 =?us-ascii?Q?occablTvBq4LUHx3JsfcH9SWSoIUF7uc6sj58m09aIK97HHGsKVvq7QzjGsQ?=
 =?us-ascii?Q?EQ6aB+MGjWQfwj4h4X3CHMxnG80+qCRUNleff/BZf2cRLjbHAlIYj2TVk4Va?=
 =?us-ascii?Q?SUF/CwzYZSdmOULe89U3577STDvMEensMAJBJhldUoERxAbejcHceWt4QfBQ?=
 =?us-ascii?Q?I6u6ecbhYlHXIZb/c67Q353uzomP+wreFz+JYEC9ZzmwK5ZNNivKz4V5j72K?=
 =?us-ascii?Q?G5dcbLVEplGzcb16o/TaKb3dQHfQ63SBuUCOlM5HXMolnwxtb8SfUpn2Zwdu?=
 =?us-ascii?Q?ZZAWPJy67RoEsMkTa4xxJ7ED/BVbwHncA3IJRiEHqTlLh217MvtkW1y6OVOj?=
 =?us-ascii?Q?HJsZycewlfcNafFGfMyQsKgV8YQqBGli0QPZhVFCISKgJJeRV0cXOG/bvLei?=
 =?us-ascii?Q?N5XsV2O3a8Qe6WBKhCeZjm3o9WB0tFdeC9N7o2x/wbA+4q4qCFiLFQf3nrjE?=
 =?us-ascii?Q?qsCOgqX+EvAN8o6OLw79zIyKO0igx8NQ8L3v8a5eVHUqlnAzgJ92VHUQGz9D?=
 =?us-ascii?Q?F2A2IIDeXnMNf4AmmB4Ue1OEcwUsC0TrnuFMml6o6PBwgkb5hRBGEKPUgiY9?=
 =?us-ascii?Q?yG9HMJxtL999nK7e0CLL5JZKFifHNIanJUwtgpusfXoKcoum+bW1PnY9PDZt?=
 =?us-ascii?Q?D47JbHBfgWJwAkh2hwJBHhuNIWf38djb6+6S5QnGm4cwDyj1d1QnvxH5pffT?=
 =?us-ascii?Q?6lPyvOYUpJ4Cqtp3yYzsbPaLuXZ7Xa/IM3JxpyY3kQRvxXBpc9VdMIPvfCue?=
 =?us-ascii?Q?Cq11oC5b9g/QlyQGnpuVb2Rc8D+DHwQP3UjPYNQvVar3X4nLtqKJA2l/KKSq?=
 =?us-ascii?Q?9aWzv22hQOSRLqb5S3M=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(7416014)(82310400026)(36860700013)(1800799024)(13003099007);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Dec 2025 08:47:46.8510
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 109f7568-8e65-4bfe-9ec0-08de3bb69ef0
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ5PEPF000001D2.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB9738
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 28DCE8000B
X-Stat-Signature: zoubqw5uxk9q1x599qc7r13kpuy37swm
X-Rspam-User: 
X-HE-Tag: 1765788470-158470
X-HE-Meta: U2FsdGVkX1/EOUiBCAaHvGIi91YeEbx4VN4g2Ht6gOVvwHm95l5iMMGW1m0L0FBs2zg8r2HdAlSExWAtLMLriG9UNgazLttQUg1DlL1bxCJMpastQISRVJNAx3377FP7DHUjQZ0StdNnKxxQMF8DwIECrCLTlGWRZ4jc+SciDJDUeVnSqc5wCXLNegfIAID/tE6+dajb22ZHavKNi7WSZgiNoryxlZyDoXTvsrpNL9tnl5lUdAN451SiCfc2VwWHAz6yEbayVaeM15HYAMJC5Fq/V/8P9Ny6XK+FGJREmmlYpxkJQgw1b+OVJq9M76SJvtM4x6dTrXvoa7WBbnEHuOQKgjnbz0BqMw10w7DtFmX0o6JWh+5s2VZpq3S3UoyNFN2bdFMkxScWxo6Xu46yPIr6Qxh4lYGlSiJ+LTJlTBno6bfathT+CoOuxB3t0NkT1hSuH/TDMZfZU0GkzjysF50+Vu1rNg5pkUwHG4aKbzrWTdbJLMboQdBCDUWPN9kidA++yuXMDSUJNNttw5CPm4rCaAXriWcTExr1NcoAKQfqu3uCMM6+RMlxBG+O8NIgpWeoVEibOor5Q7oZG/dRMy9eeQeHLj6nEc8WrA69bWBvYyaSn0t6PaPCvbyxtOuJBYfr03Nsjk6YsC742pXDs8PAiokn8WLQOtyJnMPNHMCsssnP/d3HF/dVt5RW2ZSejurPAOJGCnZGZ+hgGDUNDG0+8T+5oJsC5SfcQ9CPp/4qIzSSvJvudFL3i66UvD+1+bYbLcykxTdfnPtfDwqy2ElvvvBAbx2tycMqroMBsxb+fH6TQHWTD6OvQc6Mw6+8M/6BwMQDaodYp8KHo+Wu7TN2HT9pXGE963M92l/BUOwXJkvyApc8bI2oac0TNkMauZlNzGBKGgy+RQp1yTW5nMyy4W2Y6PP2Dbr6qyAFNxuCVF+LnXq/gC1WrTjFNVKDccLLstMCoNFpJhfVrqs
 MKaLZrHc
 0Yb3DSPxg41Qgl3e2SuqTvtiXTav5g5u5gh118VGzRn+sZcn4zbgPgbDcVLeAZu8TIutp0GSNV94mz9qOENO8MN24y3FSFullUalsfcbZCjqBOAbXuk6YufiMylYet/Z5LqWbMmpUTOA7Fjq7Suo2vnjlbzqJ4rwVO5rfxLQUNHsUYRkBh4IDMC3q28pac8vqYO+9KyqS0FNO7+pQNwMWLtPW2Xs07a72KB5hFuwHgSIwmVBk8hiyNQIG8kNyll7t1cZ0xsqtUh5WyytkUBtn0s53NGI1sDoZ9olvbX4M8bU9xEJsjxZao3dyUR5+n7/55Vkes2xl6KQzWqUzBMbJppOLjaTT5IfSrmQy+7yrsDfRm6hJLif8LJJyjWqWgNciULVgcVGxJVhVfNt9hR4JCjg9OIOS6PvDfQXZkQXW50XtlphPxm7robWi+IY0RInprOm3iMVOzkBw96oC4iVzEPQhVMGlgNN5Y65ktlf0g7qxpza/DVVqnbg1PVEqTmQgRPeuUeepH3YO3XbA+wUemU1v1isv2OjlGINzeueJlykGQvfv8RuLbK0dUpuA2PZ2MoEXsl94AzygxCz1Xw/+QkVxiY4HlYFQJjhsrtRWh+hzCjI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When collapse_file encounters dirty or writeback pages in file-backed
mappings, it currently returns SCAN_FAIL which maps to -EINVAL. This is
misleading as EINVAL suggests invalid arguments, whereas dirty/writeback
pages represent transient conditions that may resolve on retry.

Introduce SCAN_PAGE_DIRTY_OR_WRITEBACK to cover both dirty and writeback
states, mapping it to -EAGAIN. For MADV_COLLAPSE, this provides userspace
with a clear signal that retry may succeed after writeback completes.
For khugepaged, this is harmless as it will naturally revisit the range
during periodic scans after async writeback completes.

Reported-by: Branden Moore <Branden.Moore@amd.com>
Closes: https://lore.kernel.org/all/4e26fe5e-7374-467c-a333-9dd48f85d7cc@amd.com
Fixes: 34488399fa08 ("mm/madvise: add file and shmem support to MADV_COLLAPSE")
Reviewed-by: Dev Jain <dev.jain@arm.com>
Reviewed-by: Lance Yang <lance.yang@linux.dev>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Reviewed-by: wang lian <lianux.mm@gmail.com>
Signed-off-by: Shivank Garg <shivankg@amd.com>
---
 include/trace/events/huge_memory.h | 3 ++-
 mm/khugepaged.c                    | 8 +++++---
 2 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/include/trace/events/huge_memory.h b/include/trace/events/huge_memory.h
index 4cde53b45a85..4e41bff31888 100644
--- a/include/trace/events/huge_memory.h
+++ b/include/trace/events/huge_memory.h
@@ -37,7 +37,8 @@
 	EM( SCAN_PAGE_HAS_PRIVATE,	"page_has_private")		\
 	EM( SCAN_STORE_FAILED,		"store_failed")			\
 	EM( SCAN_COPY_MC,		"copy_poisoned_page")		\
-	EMe(SCAN_PAGE_FILLED,		"page_filled")
+	EM( SCAN_PAGE_FILLED,		"page_filled")			\
+	EMe(SCAN_PAGE_DIRTY_OR_WRITEBACK, "page_dirty_or_writeback")
 
 #undef EM
 #undef EMe
diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index 97d1b2824386..219dfa2e523c 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -58,6 +58,7 @@ enum scan_result {
 	SCAN_STORE_FAILED,
 	SCAN_COPY_MC,
 	SCAN_PAGE_FILLED,
+	SCAN_PAGE_DIRTY_OR_WRITEBACK,
 };
 
 #define CREATE_TRACE_POINTS
@@ -1967,11 +1968,11 @@ static int collapse_file(struct mm_struct *mm, unsigned long addr,
 				 */
 				xas_unlock_irq(&xas);
 				filemap_flush(mapping);
-				result = SCAN_FAIL;
+				result = SCAN_PAGE_DIRTY_OR_WRITEBACK;
 				goto xa_unlocked;
 			} else if (folio_test_writeback(folio)) {
 				xas_unlock_irq(&xas);
-				result = SCAN_FAIL;
+				result = SCAN_PAGE_DIRTY_OR_WRITEBACK;
 				goto xa_unlocked;
 			} else if (folio_trylock(folio)) {
 				folio_get(folio);
@@ -2018,7 +2019,7 @@ static int collapse_file(struct mm_struct *mm, unsigned long addr,
 			 * folio is dirty because it hasn't been flushed
 			 * since first write.
 			 */
-			result = SCAN_FAIL;
+			result = SCAN_PAGE_DIRTY_OR_WRITEBACK;
 			goto out_unlock;
 		}
 
@@ -2747,6 +2748,7 @@ static int madvise_collapse_errno(enum scan_result r)
 	case SCAN_PAGE_LRU:
 	case SCAN_DEL_PAGE_LRU:
 	case SCAN_PAGE_FILLED:
+	case SCAN_PAGE_DIRTY_OR_WRITEBACK:
 		return -EAGAIN;
 	/*
 	 * Other: Trying again likely not to succeed / error intrinsic to
-- 
2.43.0


