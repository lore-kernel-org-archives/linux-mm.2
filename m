Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 83A72D61020
	for <linux-mm@archiver.kernel.org>; Thu, 29 Jan 2026 14:44:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E9F6C6B0093; Thu, 29 Jan 2026 09:44:26 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E571F6B0095; Thu, 29 Jan 2026 09:44:26 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D228B6B0096; Thu, 29 Jan 2026 09:44:26 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id BD6B06B0093
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 09:44:26 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 519BAAA720
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 14:44:26 +0000 (UTC)
X-FDA: 84385272132.02.8CC4AA2
Received: from SN4PR2101CU001.outbound.protection.outlook.com (mail-southcentralusazon11012037.outbound.protection.outlook.com [40.93.195.37])
	by imf06.hostedemail.com (Postfix) with ESMTP id 4A934180005
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 14:44:23 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=3b+7pqk7;
	spf=pass (imf06.hostedemail.com: domain of bharata@amd.com designates 40.93.195.37 as permitted sender) smtp.mailfrom=bharata@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769697863;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5zyXb6PRMNn1wV8HEhtyzL1c9ciblwBC2YNS1A9HsW0=;
	b=YAJxr5PY3MJlKKLzVib8oDZV4/CkuyTb/6J/R3iQUhLxJSvxT6WuDF9KZGqIji5Jx+sunF
	7zdT6GwFdEqqNuC6IMzqUZh0k5TZvYXnMj7pRYAvQvkUPVnme9gzhN24m0HVFCsHDC+6wA
	O8+lJywOWekojdUuBzawm1Mq10j0T50=
ARC-Authentication-Results: i=2;
	imf06.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=3b+7pqk7;
	spf=pass (imf06.hostedemail.com: domain of bharata@amd.com designates 40.93.195.37 as permitted sender) smtp.mailfrom=bharata@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1769697863; a=rsa-sha256;
	cv=pass;
	b=TE+rIpHt1OP9HbDFQc+Vy4B3GKup8r1pyXEu0Mg7NZLshtG+R+Jvoe/rHNlwxzONFqkdfP
	SUUR5WXDpMWxemo22rGGuKYNSyDpm3Ruaxrr6xhXtWR3LTTEb4xyp2QYv3YA3K/NSwoXgI
	PxRyf78PixYeW9PbJApPBya/2E08Tus=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ujYCR9sdRJhGAYUBjWU303fLyLG0cb7bR+v5Y24NbL/mKj7wpq+F3ZuVET/syi508zfVn0XUtqfiegQeC1UbLK4EyqtaubDbsDx6eZD5SbbS47uGmTwcwPbnBTr9WCpsqlDBa7MFt0bND2HI4vLFuG0fyVIPncyiqQeelzCL/9GWQySFw2+P09zUFONpi0l1yJ5dBniATgZFimCJ/cX45hDJPnjpfCzSSXa/esYvTduG+zlhGZBvOLj6LNV04SSmw18KStwDr0gNxxHD51rmX664ZJgw3ivPIT58Jump8LXhhTegP/hsN/YAJNYFquWurDh0RdMVkSYJKtRk7iKZGQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5zyXb6PRMNn1wV8HEhtyzL1c9ciblwBC2YNS1A9HsW0=;
 b=MmZSreioy+cLs6IcK83C+P5ttWzTg3ifTQU4f/VKbwpwWzqhDroRfZqoyn9x1n6y/8DbOsWggIhjumZHJ1EDVhYKwiVQGd4vkuktlksj/3Pc31Avz7LWoSrxsWOHxJAoocLjPGi9EDZijW3+TZpy2k1vKHlhdNzVfmwtjBmXyAdtO5jDmr7XCMf4lJxruxp1+IJMsx9qnsUJ/LyWKMzq3tpL0vaYk2o3657pWm33pmdgffYRP0UsuPn2ZCtYnxp0Is82a+rkVrBW5DK7kXuTgm8wS89ThkwcXZVg3aWS9CwWQxMuoYLA+J+jR0rAI/2mXDXqJIb0puzQVPKGshJ3Hg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5zyXb6PRMNn1wV8HEhtyzL1c9ciblwBC2YNS1A9HsW0=;
 b=3b+7pqk71wfk1J+VIcYWyqLgnKRR/NRiiCTCDGp6PolTEkNbRoAtxyrtnGl02Of0GiESyEGEJyeLcnfBcTFGLtz68yh0Cou7cCw8ZBjJSGRjd+fp9dkHlimQJN3hQr3MYlg+bZA5WSTx2gZ8noKxFQuHzLe/WmyPI952NJk5wYk=
Received: from BN0PR04CA0098.namprd04.prod.outlook.com (2603:10b6:408:ec::13)
 by PH7PR12MB5783.namprd12.prod.outlook.com (2603:10b6:510:1d2::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9564.7; Thu, 29 Jan
 2026 14:44:09 +0000
Received: from BN2PEPF000055E0.namprd21.prod.outlook.com
 (2603:10b6:408:ec:cafe::ed) by BN0PR04CA0098.outlook.office365.com
 (2603:10b6:408:ec::13) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9542.16 via Frontend Transport; Thu,
 29 Jan 2026 14:43:50 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 BN2PEPF000055E0.mail.protection.outlook.com (10.167.245.10) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9587.0 via Frontend Transport; Thu, 29 Jan 2026 14:44:09 +0000
Received: from BLR-L-BHARARAO.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Thu, 29 Jan
 2026 08:44:01 -0600
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
Subject: [RFC PATCH v5 06/10] x86: ibs: In-kernel IBS driver for memory access profiling
Date: Thu, 29 Jan 2026 20:10:39 +0530
Message-ID: <20260129144043.231636-7-bharata@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260129144043.231636-1-bharata@amd.com>
References: <20260129144043.231636-1-bharata@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: satlexmb08.amd.com (10.181.42.217) To satlexmb07.amd.com
 (10.181.42.216)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN2PEPF000055E0:EE_|PH7PR12MB5783:EE_
X-MS-Office365-Filtering-Correlation-Id: 4e3570a1-62ad-46a8-8cd5-08de5f44dc94
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|376014|7416014|1800799024|36860700013|13003099007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?h04WKilV/ZrpmKBCQM/CLVdvTvDyagINShho3s3MDOMjNkt3PJDE9PAaBAN3?=
 =?us-ascii?Q?3w50jg/yyuGNGNtMa4il9E2q/L0xzZueFa0nxIxocvZO6IRIeVAJsSAJXRFv?=
 =?us-ascii?Q?lWvV61Y9ygADm57lFh2a0WXOsdF7LHyzwRzdyUYsdbNEpVuoFNdYjTL9wzzG?=
 =?us-ascii?Q?CoyAy0VE6bZrIkxcueaOJ8mD3+Acb8je9jMQgXJcZrDCT+x95sQU8MGWFjV5?=
 =?us-ascii?Q?pCN75nz23S5N2TTRW4Fs94bZYNjNr4PIYotOnvQFEhjX6hYewLmDOXzM0kud?=
 =?us-ascii?Q?+RFrkXXaqgWMH9x95OL5daGgRmmCCOopTIf4DoDJH3h4Q1YGKVKlUG/Thi1y?=
 =?us-ascii?Q?HLyLkOIi5HtidA3Z4Pc5LdQ3kzLiUbnT6ohhhgJnseKg22HV5CmFNFXxfS2t?=
 =?us-ascii?Q?6mjTuPmR5RF8Eauill3GmtwALfr/38mbqb2DDIU7/XT+1py76oZez+3Kyb8U?=
 =?us-ascii?Q?f/a++lSMk0OGyGYV2EYPYXzNMWAE+YREvgkx9mUAQR+X50sabaLn1TR64J2w?=
 =?us-ascii?Q?pDUYzUOT7IHoqIZlIX3pDz1ou5jAxiOhHkaNONVhVOYdpPxXaDO6kSvjX36m?=
 =?us-ascii?Q?isUblxvvZsqBZ9lUdaFuV5VogLmCwkYplaAHiy5J7daOUxvPzgpxDAtYOZj9?=
 =?us-ascii?Q?xXd9wq3pmDubkzghxPlq3TRD/zzhxm625bgd8ahPBMoGWhpzaDP8WeaHmmUe?=
 =?us-ascii?Q?ZLM3TmwIezJ2nZN+WX2xF1Khl/29WJ62OzY0coud+zwT0ZiZFX0TvsF/RYrB?=
 =?us-ascii?Q?XG1HaEXRCy0R94V/CsrD5MTOXPs8kwMlLVLJarxNHlfNBcVppZT1m4NXIQWe?=
 =?us-ascii?Q?Dnt9FaRJ9128ONYWBcDfxAahrFR/G6RgzaYGUxETF0sqqP2GHqtPa3zqdQ+v?=
 =?us-ascii?Q?yLmmCdttx4n7V215pOC+YTWCtWvVtme0iD0/JQRBSzRnDEWtTR6VSUT0x9EX?=
 =?us-ascii?Q?GaL2M2H/YUzdLUR5/U6F9/AV4XbI+KHDHCcya1YIOYr6EarzcGu31pTJPAA8?=
 =?us-ascii?Q?3qKBDJU7tO4714vV8mo83oByzxYaEgCDcK8tCFQ9oHyltUsvR1WrCP9o9VfU?=
 =?us-ascii?Q?kusEb3Lg5mokP/+lSQgpGrZr5JT5Whq5+nrVT2382aVpOW09mRoQF/u8y0hy?=
 =?us-ascii?Q?uTC7/V9NJKndMro3pSAiFFgiG2OY1lLy/4A1eXyGXXCLjxwBrx8lWPu3oP3m?=
 =?us-ascii?Q?ciFr1G0iWFvBmwOe27XT+C1LCoPBGV4Ftr7NnTryoEejrS40oRbSk+1FWnkJ?=
 =?us-ascii?Q?XS6dbRUFecEyiF/xNadbskwutd9YDuT7RXJ8OoLQb011Y343D7ecBJGyYaul?=
 =?us-ascii?Q?N4tSrMGhXlcuo8W3uQ+4rbkflUtOh2wi5iC+sPaEpXMsjjRiHjFuS76wLZCI?=
 =?us-ascii?Q?1Hq+IP50M5jxToAxKHFatTHrRXnS+dyYM4SgxOP38pYoN9t4JWZVR1y448ZO?=
 =?us-ascii?Q?DpO7/DFQI9ZWY9nuTDh+h6NZEBaAYjjTjcJwmUghUKB1mN5cDnN+LoKQ2NA1?=
 =?us-ascii?Q?HNOz41Z4pF5QXvNQYIjAo7g2UvKVsutRveh7c3FUqg59yIzqchixjDIQ8sF1?=
 =?us-ascii?Q?Yqu9pBWqIae5kCTZpA9dmJf/HH0df2O8ghmwxPFcy7tTqpHgtHMx83xyI+Zj?=
 =?us-ascii?Q?HZ22acsg8cb0fX3H74QPdcpl1mtd8lNd9V7RvRcCNHrUJg+p8Sibzkw6F+Cj?=
 =?us-ascii?Q?KInIbwRk8Q5ZKWZeYljDp6fDgAA=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(376014)(7416014)(1800799024)(36860700013)(13003099007);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jan 2026 14:44:09.5899
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 4e3570a1-62ad-46a8-8cd5-08de5f44dc94
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN2PEPF000055E0.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB5783
X-Rspam-User: 
X-Rspamd-Queue-Id: 4A934180005
X-Rspamd-Server: rspam07
X-Stat-Signature: 79m9wrdoppi7uiyaiozb4euhxgmq3isg
X-HE-Tag: 1769697863-928258
X-HE-Meta: U2FsdGVkX18nMu1/HzwQuJoHzqGM2NpBB0/eqetxWYhFLPaPsmOpuarGXAS0ZzbONHwWIS9mUFmseAF+t7xf0EIhmBv/xDvPGKxhLg2xwZGpTn5OjY8BlLmWSFEI5BjfjKiFKxgysOo2z3mW4vI+qjn7MXbmQ+kzT+871eMdHeVWwdl5TsGv1Rd2Zy5EiaxEHceL4HZbe8/LgjllHb7v63VwAKSiZ+VzWiBixD5JoRc3pccNnUeuk4FpNn/8wbMTFklkGYgze/2vSL/ZCxhYPPpLePn2Dvw6oMmBI2aWh2dwOUUa+MYVOK3iPOxn7Q4SeCAKEosiFxwYZDRxrnKMs0k6Ho1/kwoJXtqaLYN9TxJnHEB6SSSA6Qzv4KsLUqVuNrYEIBngVdIllQPIomGPPqcOiSfffUfIqtaz175LXqYL1IjEdrS+zhvrTN+xae+Y8vDh77jzXg5vYwAIl1LwdhZQ/9gJhYEi4EhESV5V3vqcIjkSa9I6RA615jhO4OTiq7Mqn3DxXX2VJXu6RdvlQbQfCzszSx7p+ywmg/0AatEbchmok7jUGqib4Mnt1NU14eWUQpjRDdIDw7aw4mloQ6wH1fwcNkrZl2JXD7j177P3ZY8csWOeM4MIkWBWarU5a6Se8oDaMDiMleIsQkonRVg68XJ8vDZYtYdmNdLaGCztyMZe9oVx1iw5bzPfIEqCZVD0UWU9JTQccldWA3XiIOvL6kfKtvSTXSc2VE+gwSGoJL4cHaiGO9m0uaFrPWRPYU+qsGWIP3Qt62b7ItcfSuLkrh0q1wK13sQVlG2IL74TXLpHjrtK/Dv2cSleDr9gx/TC6B2K+wvi4z2VVAR6sOPIuo0vSyn09jfhgi+Nb4aCT1gjdTfNA2/gZL7JUTd8lvzs7WCVb+CU29+yIufaBf+qGp8v948rRaiaT/uq+EA78wgppGFQ6ZSJ1NGKjQKV8Nh/A/BB1oG5OwBJH7K
 jLw+c9tw
 NLfAiYrBU5SxFeeATHbS3Ee4sQh05d/HFfAqp/hd+vjCOWdKg4rr5O4p1s0+msynOudBG8nbI0ixm62Imo4joFCiKri5FxoYIeSp9ETQKlKUbJH9L54RNuvXEHqGF5ubW+EsnbaE2EknZrQhYw8lJediwJQfXcrBCjmnWF8iVYVVP4XRZ1yJltDo7G6XMuGdCZw7+gqHI/odZWOsTF3qZ8I7PmM5itEE/QkVsH9WEU8fzudoa8xluG77cJKI2EE38aOkpfD2kyJxgDK8h7nHMD/wvV+iO4xZGY0LBqlUXS15cOLQgSiYG7IGph0H24utYKKCohocHTnxEcsbCOc7e5sYs/OJUCxTORNRtCNxPDBhaPFGK2TmsALt2SY3VOuG1De8pMNCfBi/O0toVSYfLlLou7dGk6WOf/j1cQDnnPF7IV9DvwR/7mj2j6vg4jN10XN101ivhqf1gtlNbroC6EAmWR1NtQijKOnZtFAfOgJr1QnYDEClhn4flIZALXivg3VRg8F9C5mr6h1r+aD2oJXj/ALmskOt3bWtegkzrgv93V14=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Use IBS (Instruction Based Sampling) feature present
in AMD processors for memory access tracking. The access
information obtained from IBS via NMI is fed to pghot
sub-system for futher action.

In addition to many other information related to the memory
access, IBS provides physical (and virtual) address of the access
and indicates if the access came from slower tier. Only memory
accesses originating from slower tiers are further acted upon
by this driver.

The samples are initially accumulated in percpu buffers which
are flushed to pghot hot page tracking mechanism using irq_work.

TODO: Many counters are added to vmstat just as debugging aid
for now.

About IBS
---------
IBS can be programmed to provide data about instruction
execution periodically. This is done by programming a desired
sample count (number of ops) in a control register. When the
programmed number of ops are dispatched, a micro-op gets tagged,
various information about the tagged micro-op's execution is
populated in IBS execution MSRs and an interrupt is raised.
While IBS provides a lot of data for each sample, for the
purpose of  memory access profiling, we are interested in
linear and physical address of the memory access that reached
DRAM. Recent AMD processors provide further filtering where
it is possible to limit the sampling to those ops that had
an L3 miss which greately reduces the non-useful samples.

While IBS provides capability to sample instruction fetch
and execution, only IBS execution sampling is used here
to collect data about memory accesses that occur during
the instruction execution.

More information about IBS is available in Sec 13.3 of
AMD64 Architecture Programmer's Manual, Volume 2:System
Programming which is present at:
https://bugzilla.kernel.org/attachment.cgi?id=288923

Information about MSRs used for programming IBS can be
found in Sec 2.1.14.4 of PPR Vol 1 for AMD Family 19h
Model 11h B1 which is currently present at:
https://www.amd.com/system/files/TechDocs/55901_0.25.zip

Signed-off-by: Bharata B Rao <bharata@amd.com>
---
 arch/x86/events/amd/ibs.c        |  10 +
 arch/x86/include/asm/msr-index.h |  16 ++
 arch/x86/mm/Makefile             |   1 +
 arch/x86/mm/ibs.c                | 317 +++++++++++++++++++++++++++++++
 include/linux/pghot.h            |   8 +
 include/linux/vm_event_item.h    |  19 ++
 mm/Kconfig                       |  13 ++
 mm/vmstat.c                      |  19 ++
 8 files changed, 403 insertions(+)
 create mode 100644 arch/x86/mm/ibs.c

diff --git a/arch/x86/events/amd/ibs.c b/arch/x86/events/amd/ibs.c
index aca89f23d2e0..dc544d084c17 100644
--- a/arch/x86/events/amd/ibs.c
+++ b/arch/x86/events/amd/ibs.c
@@ -13,6 +13,7 @@
 #include <linux/ptrace.h>
 #include <linux/syscore_ops.h>
 #include <linux/sched/clock.h>
+#include <linux/pghot.h>
 
 #include <asm/apic.h>
 #include <asm/msr.h>
@@ -1760,6 +1761,15 @@ static __init int amd_ibs_init(void)
 {
 	u32 caps;
 
+	/*
+	 * TODO: Find a clean way to disable perf IBS so that IBS
+	 * can be used for memory access profiling.
+	 */
+	if (hwmem_access_profiler_inuse()) {
+		pr_info("IBS isn't available for perf use\n");
+		return 0;
+	}
+
 	caps = __get_ibs_caps();
 	if (!caps)
 		return -ENODEV;	/* ibs not supported by the cpu */
diff --git a/arch/x86/include/asm/msr-index.h b/arch/x86/include/asm/msr-index.h
index 3d0a0950d20a..3c5d69ec83a2 100644
--- a/arch/x86/include/asm/msr-index.h
+++ b/arch/x86/include/asm/msr-index.h
@@ -784,6 +784,22 @@
 /* AMD Last Branch Record MSRs */
 #define MSR_AMD64_LBR_SELECT			0xc000010e
 
+/* AMD IBS MSR bits */
+#define MSR_AMD64_IBSOPDATA2_DATASRC			0x7
+#define MSR_AMD64_IBSOPDATA2_DATASRC_LCL_CACHE		0x1
+#define MSR_AMD64_IBSOPDATA2_DATASRC_PEER_CACHE_NEAR	0x2
+#define MSR_AMD64_IBSOPDATA2_DATASRC_DRAM		0x3
+#define MSR_AMD64_IBSOPDATA2_DATASRC_FAR_CCX_CACHE	0x5
+#define MSR_AMD64_IBSOPDATA2_DATASRC_EXT_MEM		0x8
+#define	MSR_AMD64_IBSOPDATA2_RMTNODE			0x10
+
+#define MSR_AMD64_IBSOPDATA3_LDOP		BIT_ULL(0)
+#define MSR_AMD64_IBSOPDATA3_STOP		BIT_ULL(1)
+#define MSR_AMD64_IBSOPDATA3_DCMISS		BIT_ULL(7)
+#define MSR_AMD64_IBSOPDATA3_LADDR_VALID	BIT_ULL(17)
+#define MSR_AMD64_IBSOPDATA3_PADDR_VALID	BIT_ULL(18)
+#define MSR_AMD64_IBSOPDATA3_L2MISS		BIT_ULL(20)
+
 /* Zen4 */
 #define MSR_ZEN4_BP_CFG                 0xc001102e
 #define MSR_ZEN4_BP_CFG_BP_SPEC_REDUCE_BIT 4
diff --git a/arch/x86/mm/Makefile b/arch/x86/mm/Makefile
index 5b9908f13dcf..361a456582e9 100644
--- a/arch/x86/mm/Makefile
+++ b/arch/x86/mm/Makefile
@@ -57,3 +57,4 @@ obj-$(CONFIG_X86_MEM_ENCRYPT)	+= mem_encrypt.o
 obj-$(CONFIG_AMD_MEM_ENCRYPT)	+= mem_encrypt_amd.o
 
 obj-$(CONFIG_AMD_MEM_ENCRYPT)	+= mem_encrypt_boot.o
+obj-$(CONFIG_HWMEM_PROFILER)	+= ibs.o
diff --git a/arch/x86/mm/ibs.c b/arch/x86/mm/ibs.c
new file mode 100644
index 000000000000..752f688375f9
--- /dev/null
+++ b/arch/x86/mm/ibs.c
@@ -0,0 +1,317 @@
+// SPDX-License-Identifier: GPL-2.0
+
+#include <linux/init.h>
+#include <linux/pghot.h>
+#include <linux/percpu.h>
+#include <linux/workqueue.h>
+#include <linux/irq_work.h>
+
+#include <asm/nmi.h>
+#include <asm/perf_event.h> /* TODO: Move defns like IBS_OP_ENABLE into non-perf header */
+#include <asm/apic.h>
+
+bool hwmem_access_profiling;
+
+static u64 ibs_config __read_mostly;
+static u32 ibs_caps;
+
+#define IBS_NR_SAMPLES	150
+
+/*
+ * Basic access info captured for each memory access.
+ */
+struct ibs_sample {
+	unsigned long pfn;
+	unsigned long time;	/* jiffies when accessed */
+	int nid;		/* Accessing node ID, if known */
+};
+
+/*
+ * Percpu buffer of access samples. Samples are accumulated here
+ * before pushing them to pghot sub-system for further action.
+ */
+struct ibs_sample_pcpu {
+	struct ibs_sample samples[IBS_NR_SAMPLES];
+	int head, tail;
+};
+
+struct ibs_sample_pcpu __percpu *ibs_s;
+
+/*
+ * The workqueue for pushing the percpu access samples to pghot sub-system.
+ */
+static struct work_struct ibs_work;
+static struct irq_work ibs_irq_work;
+
+bool hwmem_access_profiler_inuse(void)
+{
+	return hwmem_access_profiling;
+}
+
+/*
+ * Record the IBS-reported access sample in percpu buffer.
+ * Called from IBS NMI handler.
+ */
+static int ibs_push_sample(unsigned long pfn, int nid, unsigned long time)
+{
+	struct ibs_sample_pcpu *ibs_pcpu = raw_cpu_ptr(ibs_s);
+	int next = ibs_pcpu->head + 1;
+
+	if (next >= IBS_NR_SAMPLES)
+		next = 0;
+
+	if (next == ibs_pcpu->tail)
+		return 0;
+
+	ibs_pcpu->samples[ibs_pcpu->head].pfn = pfn;
+	ibs_pcpu->samples[ibs_pcpu->head].time = time;
+	ibs_pcpu->samples[ibs_pcpu->head].nid = nid;
+	ibs_pcpu->head = next;
+	return 1;
+}
+
+static int ibs_pop_sample(struct ibs_sample *s)
+{
+	struct ibs_sample_pcpu *ibs_pcpu = raw_cpu_ptr(ibs_s);
+
+	int next = ibs_pcpu->tail + 1;
+
+	if (ibs_pcpu->head == ibs_pcpu->tail)
+		return 0;
+
+	if (next >= IBS_NR_SAMPLES)
+		next = 0;
+
+	*s = ibs_pcpu->samples[ibs_pcpu->tail];
+	ibs_pcpu->tail = next;
+	return 1;
+}
+
+/*
+ * Remove access samples from percpu buffer and send them
+ * to pghot sub-system for further action.
+ */
+static void ibs_work_handler(struct work_struct *work)
+{
+	struct ibs_sample s;
+
+	while (ibs_pop_sample(&s))
+		pghot_record_access(s.pfn, s.nid, PGHOT_HW_HINTS, s.time);
+}
+
+static void ibs_irq_handler(struct irq_work *i)
+{
+	schedule_work_on(smp_processor_id(), &ibs_work);
+}
+
+/*
+ * IBS NMI handler: Process the memory access info reported by IBS.
+ *
+ * Reads the MSRs to collect all the information about the reported
+ * memory access, validates the access, stores the valid sample and
+ * schedules the work on this CPU to further process the sample.
+ */
+static int ibs_overflow_handler(unsigned int cmd, struct pt_regs *regs)
+{
+	struct mm_struct *mm = current->mm;
+	u64 ops_ctl, ops_data3, ops_data2;
+	u64 laddr = -1, paddr = -1;
+	u64 data_src, rmt_node;
+	struct page *page;
+	unsigned long pfn;
+
+	rdmsrl(MSR_AMD64_IBSOPCTL, ops_ctl);
+
+	/*
+	 * When IBS sampling period is reprogrammed via read-modify-update
+	 * of MSR_AMD64_IBSOPCTL, overflow NMIs could be generated with
+	 * IBS_OP_ENABLE not set. For such cases, return as HANDLED.
+	 *
+	 * With this, the handler will say "handled" for all NMIs that
+	 * aren't related to this NMI.  This stems from the limitation of
+	 * having both status and control bits in one MSR.
+	 */
+	if (!(ops_ctl & IBS_OP_VAL))
+		goto handled;
+
+	wrmsrl(MSR_AMD64_IBSOPCTL, ops_ctl & ~IBS_OP_VAL);
+
+	count_vm_event(HWHINT_NR_EVENTS);
+
+	if (!user_mode(regs)) {
+		count_vm_event(HWHINT_KERNEL);
+		goto handled;
+	}
+
+	if (!mm) {
+		count_vm_event(HWHINT_KTHREAD);
+		goto handled;
+	}
+
+	rdmsrl(MSR_AMD64_IBSOPDATA3, ops_data3);
+
+	/* Load/Store ops only */
+	/* TODO: DataSrc isn't valid for stores, so filter out stores? */
+	if (!(ops_data3 & (MSR_AMD64_IBSOPDATA3_LDOP |
+			   MSR_AMD64_IBSOPDATA3_STOP))) {
+		count_vm_event(HWHINT_NON_LOAD_STORES);
+		goto handled;
+	}
+
+	/* Discard the sample if it was L1 or L2 hit */
+	if (!(ops_data3 & (MSR_AMD64_IBSOPDATA3_DCMISS |
+			   MSR_AMD64_IBSOPDATA3_L2MISS))) {
+		count_vm_event(HWHINT_DC_L2_HITS);
+		goto handled;
+	}
+
+	rdmsrl(MSR_AMD64_IBSOPDATA2, ops_data2);
+	data_src = ops_data2 & MSR_AMD64_IBSOPDATA2_DATASRC;
+	if (ibs_caps & IBS_CAPS_ZEN4)
+		data_src |= ((ops_data2 & 0xC0) >> 3);
+
+	switch (data_src) {
+	case MSR_AMD64_IBSOPDATA2_DATASRC_LCL_CACHE:
+		count_vm_event(HWHINT_LOCAL_L3L1L2);
+		break;
+	case MSR_AMD64_IBSOPDATA2_DATASRC_PEER_CACHE_NEAR:
+		count_vm_event(HWHINT_LOCAL_PEER_CACHE_NEAR);
+		break;
+	case MSR_AMD64_IBSOPDATA2_DATASRC_DRAM:
+		count_vm_event(HWHINT_DRAM_ACCESSES);
+		break;
+	case MSR_AMD64_IBSOPDATA2_DATASRC_EXT_MEM:
+		count_vm_event(HWHINT_CXL_ACCESSES);
+		break;
+	case MSR_AMD64_IBSOPDATA2_DATASRC_FAR_CCX_CACHE:
+		count_vm_event(HWHINT_FAR_CACHE_HITS);
+		break;
+	}
+
+	rmt_node = ops_data2 & MSR_AMD64_IBSOPDATA2_RMTNODE;
+	if (rmt_node)
+		count_vm_event(HWHINT_REMOTE_NODE);
+
+	/* Is linear addr valid? */
+	if (ops_data3 & MSR_AMD64_IBSOPDATA3_LADDR_VALID)
+		rdmsrl(MSR_AMD64_IBSDCLINAD, laddr);
+	else {
+		count_vm_event(HWHINT_LADDR_INVALID);
+		goto handled;
+	}
+
+	/* Discard kernel address accesses */
+	if (laddr & (1UL << 63)) {
+		count_vm_event(HWHINT_KERNEL_ADDR);
+		goto handled;
+	}
+
+	/* Is phys addr valid? */
+	if (ops_data3 & MSR_AMD64_IBSOPDATA3_PADDR_VALID)
+		rdmsrl(MSR_AMD64_IBSDCPHYSAD, paddr);
+	else {
+		count_vm_event(HWHINT_PADDR_INVALID);
+		goto handled;
+	}
+
+	pfn = PHYS_PFN(paddr);
+	page = pfn_to_online_page(pfn);
+	if (!page)
+		goto handled;
+
+	if (!PageLRU(page)) {
+		count_vm_event(HWHINT_NON_LRU);
+		goto handled;
+	}
+
+	if (!ibs_push_sample(pfn, numa_node_id(), jiffies)) {
+		count_vm_event(HWHINT_BUFFER_FULL);
+		goto handled;
+	}
+
+	irq_work_queue(&ibs_irq_work);
+	count_vm_event(HWHINT_USEFUL_SAMPLES);
+
+handled:
+	return NMI_HANDLED;
+}
+
+static inline int get_ibs_lvt_offset(void)
+{
+	u64 val;
+
+	rdmsrl(MSR_AMD64_IBSCTL, val);
+	if (!(val & IBSCTL_LVT_OFFSET_VALID))
+		return -EINVAL;
+
+	return val & IBSCTL_LVT_OFFSET_MASK;
+}
+
+static void setup_APIC_ibs(void)
+{
+	int offset;
+
+	offset = get_ibs_lvt_offset();
+	if (offset < 0)
+		goto failed;
+
+	if (!setup_APIC_eilvt(offset, 0, APIC_EILVT_MSG_NMI, 0))
+		return;
+failed:
+	pr_warn("IBS APIC setup failed on cpu #%d\n",
+		smp_processor_id());
+}
+
+static void clear_APIC_ibs(void)
+{
+	int offset;
+
+	offset = get_ibs_lvt_offset();
+	if (offset >= 0)
+		setup_APIC_eilvt(offset, 0, APIC_EILVT_MSG_FIX, 1);
+}
+
+static int x86_amd_ibs_access_profile_startup(unsigned int cpu)
+{
+	setup_APIC_ibs();
+	return 0;
+}
+
+static int x86_amd_ibs_access_profile_teardown(unsigned int cpu)
+{
+	clear_APIC_ibs();
+	return 0;
+}
+
+static int __init ibs_access_profiling_init(void)
+{
+	if (!boot_cpu_has(X86_FEATURE_IBS)) {
+		pr_info("IBS capability is unavailable for access profiling\n");
+		return 0;
+	}
+
+	ibs_s = alloc_percpu_gfp(struct ibs_sample_pcpu, GFP_KERNEL | __GFP_ZERO);
+	if (!ibs_s)
+		return 0;
+
+	INIT_WORK(&ibs_work, ibs_work_handler);
+	init_irq_work(&ibs_irq_work, ibs_irq_handler);
+
+	/* Uses IBS Op sampling */
+	ibs_config = IBS_OP_CNT_CTL | IBS_OP_ENABLE;
+	ibs_caps = cpuid_eax(IBS_CPUID_FEATURES);
+	if (ibs_caps & IBS_CAPS_ZEN4)
+		ibs_config |= IBS_OP_L3MISSONLY;
+
+	register_nmi_handler(NMI_LOCAL, ibs_overflow_handler, 0, "ibs");
+
+	cpuhp_setup_state(CPUHP_AP_PERF_X86_AMD_IBS_STARTING,
+			  "x86/amd/ibs_access_profile:starting",
+			  x86_amd_ibs_access_profile_startup,
+			  x86_amd_ibs_access_profile_teardown);
+
+	pr_info("IBS setup for memory access profiling\n");
+	return 0;
+}
+
+arch_initcall(ibs_access_profiling_init);
diff --git a/include/linux/pghot.h b/include/linux/pghot.h
index d3d59b0c0cf6..20ea9767dbdd 100644
--- a/include/linux/pghot.h
+++ b/include/linux/pghot.h
@@ -2,6 +2,14 @@
 #ifndef _LINUX_PGHOT_H
 #define _LINUX_PGHOT_H
 
+#include <linux/types.h>
+
+#ifdef CONFIG_HWMEM_PROFILER
+bool hwmem_access_profiler_inuse(void);
+#else
+static inline bool hwmem_access_profiler_inuse(void) { return false; }
+#endif
+
 /* Page hotness temperature sources */
 enum pghot_src {
 	PGHOT_HW_HINTS,
diff --git a/include/linux/vm_event_item.h b/include/linux/vm_event_item.h
index 5b8fd93b55fd..67efbca9051c 100644
--- a/include/linux/vm_event_item.h
+++ b/include/linux/vm_event_item.h
@@ -193,6 +193,25 @@ enum vm_event_item { PGPGIN, PGPGOUT, PSWPIN, PSWPOUT,
 		PGHOT_RECORD_HWHINTS,
 		PGHOT_RECORD_PGTSCANS,
 		PGHOT_RECORD_HINTFAULTS,
+#ifdef CONFIG_HWMEM_PROFILER
+		HWHINT_NR_EVENTS,
+		HWHINT_KERNEL,
+		HWHINT_KTHREAD,
+		HWHINT_NON_LOAD_STORES,
+		HWHINT_DC_L2_HITS,
+		HWHINT_LOCAL_L3L1L2,
+		HWHINT_LOCAL_PEER_CACHE_NEAR,
+		HWHINT_FAR_CACHE_HITS,
+		HWHINT_DRAM_ACCESSES,
+		HWHINT_CXL_ACCESSES,
+		HWHINT_REMOTE_NODE,
+		HWHINT_LADDR_INVALID,
+		HWHINT_KERNEL_ADDR,
+		HWHINT_PADDR_INVALID,
+		HWHINT_NON_LRU,
+		HWHINT_BUFFER_FULL,
+		HWHINT_USEFUL_SAMPLES,
+#endif /* CONFIG_HWMEM_PROFILER */
 #endif /* CONFIG_PGHOT */
 		NR_VM_EVENT_ITEMS
 };
diff --git a/mm/Kconfig b/mm/Kconfig
index fde5aee3e16f..07b16aece877 100644
--- a/mm/Kconfig
+++ b/mm/Kconfig
@@ -1489,6 +1489,19 @@ config PGHOT_PRECISE
 	  4 bytes per page against the default one byte per page. Preferable
 	  to enable this on systems with multiple nodes in toptier.
 
+config HWMEM_PROFILER
+	bool "HW based memory access profiling"
+	def_bool n
+	depends on PGHOT
+	depends on X86_64
+	help
+	  Some hardware platforms are capable of providing memory access
+	  information in direct and actionable manner. Instruction Based
+	  Sampling (IBS) present on AMD Zen CPUs in one such example.
+	  Memory accesses obtained via such HW based mechanisms are
+	  rolled up to PGHOT sub-system for further action like hot page
+	  promotion or NUMA Balancing
+
 source "mm/damon/Kconfig"
 
 endmenu
diff --git a/mm/vmstat.c b/mm/vmstat.c
index f6f91b9dd887..62c47f44edf0 100644
--- a/mm/vmstat.c
+++ b/mm/vmstat.c
@@ -1506,6 +1506,25 @@ const char * const vmstat_text[] = {
 	[I(PGHOT_RECORD_HWHINTS)]		= "pghot_recorded_hwhints",
 	[I(PGHOT_RECORD_PGTSCANS)]		= "pghot_recorded_pgtscans",
 	[I(PGHOT_RECORD_HINTFAULTS)]		= "pghot_recorded_hintfaults",
+#ifdef CONFIG_HWMEM_PROFILER
+	[I(HWHINT_NR_EVENTS)]			= "hwhint_nr_events",
+	[I(HWHINT_KERNEL)]			= "hwhint_kernel",
+	[I(HWHINT_KTHREAD)]			= "hwhint_kthread",
+	[I(HWHINT_NON_LOAD_STORES)]		= "hwhint_non_load_stores",
+	[I(HWHINT_DC_L2_HITS)]			= "hwhint_dc_l2_hits",
+	[I(HWHINT_LOCAL_L3L1L2)]		= "hwhint_local_l3l1l2",
+	[I(HWHINT_LOCAL_PEER_CACHE_NEAR)]	= "hwhint_local_peer_cache_near",
+	[I(HWHINT_FAR_CACHE_HITS)]		= "hwhint_far_cache_hits",
+	[I(HWHINT_DRAM_ACCESSES)]		= "hwhint_dram_accesses",
+	[I(HWHINT_CXL_ACCESSES)]		= "hwhint_cxl_accesses",
+	[I(HWHINT_REMOTE_NODE)]			= "hwhint_remote_node",
+	[I(HWHINT_LADDR_INVALID)]		= "hwhint_invalid_laddr",
+	[I(HWHINT_KERNEL_ADDR)]			= "hwhint_kernel_addr",
+	[I(HWHINT_PADDR_INVALID)]		= "hwhint_invalid_paddr",
+	[I(HWHINT_NON_LRU)]			= "hwhint_non_lru",
+	[I(HWHINT_BUFFER_FULL)]			= "hwhint_buffer_full",
+	[I(HWHINT_USEFUL_SAMPLES)]		= "hwhint_useful_samples",
+#endif /* CONFIG_HWMEM_PROFILER */
 #endif /* CONFIG_PGHOT */
 #undef I
 #endif /* CONFIG_VM_EVENT_COUNTERS */
-- 
2.34.1


