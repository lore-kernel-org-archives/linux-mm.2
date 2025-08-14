Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 57055CA0EDC
	for <linux-mm@archiver.kernel.org>; Thu, 14 Aug 2025 15:34:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ED16C90018F; Thu, 14 Aug 2025 11:34:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E81D1900172; Thu, 14 Aug 2025 11:34:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D494C90018F; Thu, 14 Aug 2025 11:34:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id BFD99900172
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 11:34:13 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 4F61AC069D
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 15:34:13 +0000 (UTC)
X-FDA: 83775759186.15.9E1D4CB
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2042.outbound.protection.outlook.com [40.107.102.42])
	by imf03.hostedemail.com (Postfix) with ESMTP id 000EF2000F
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 15:34:09 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=IpTGdT3y;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	spf=pass (imf03.hostedemail.com: domain of Raghavendra.KodsaraThimmappa@amd.com designates 40.107.102.42 as permitted sender) smtp.mailfrom=Raghavendra.KodsaraThimmappa@amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1755185650; a=rsa-sha256;
	cv=pass;
	b=vZDxwNrdBeiRPHtinL9r6N6IFlUKhLcEwjJ9BCU35xngzDt6u2/5a6Waf0wGZMBgEAuGra
	GWIg7oCy4FdHv3TTyUPgLK+jldce4HCR5y+lCd49Dkpt39vpnc25dVQZ03PFZluPSw1b/n
	ES/zp9mHG2VFab5jwSmQU+0McsPUyRk=
ARC-Authentication-Results: i=2;
	imf03.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=IpTGdT3y;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	spf=pass (imf03.hostedemail.com: domain of Raghavendra.KodsaraThimmappa@amd.com designates 40.107.102.42 as permitted sender) smtp.mailfrom=Raghavendra.KodsaraThimmappa@amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755185650;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=D7cB5zU1ByDq5a++Mtl9WuTdBPv0fgnoAzM9mfcpqIg=;
	b=rZhvH46lpV3nXVysV1bc+eWOo6BHiz15jvYhPLO3UbHc/E/HQGY20XUR24MZ8F0Pndl9C6
	MF8+LjbmKNvixCVInJqAjGL2XndgaizDYUi+ryHAddN+2dep06T1/Y8jJfH3DnmPgJvE2T
	DBI7/ERxQ+cxy1Z2e2Bvfa+3zCvkOCQ=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=kjODYYIxwM7NftDrilUpDZSkm0VIv3/FDGJHL1P6Saw8NbisV1Tuop/APPjMRR1hLd/Mtw9cOSfpzlS/cunayn80VCjuuIilc/prrRL6sr3pUHVeizQx384dXmsio0ZIOIeGFWpqj90f7Z/sufGlAc0mwnjqDv1kUDal+wZ2N3g5nIBQ26M1t5uTyAnFjOg2XoR5kLJRUIfdwnHt7k/G4Nw5hWfXs13UlM+V6uKv/KZDXflH0J/i9Osg6lIaBTsow+ZseWlTk1TOB9q59yHQdtPG/gqcDo8KWXayOpTZZwdraw9Bj4uw9o7U+2RiYN2T6gEuXQrUpWNIvHQReOMRTA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=D7cB5zU1ByDq5a++Mtl9WuTdBPv0fgnoAzM9mfcpqIg=;
 b=MJhZsDmnVDLBjavhBrYXTGFPXP+7hvjHgkgv13RG6VfORnjQ6iuSWdXVUeIN71EO2CfIFLMfyVfcl6t0OIuFiHe1TS9nqYB+55NsQBxfDfz12FirMfrjhDPpxG0UtIXbVgezvOrhVd/d5gHbI7wBeRiUlKrPSFrNKHg9OH9YyS++4T3qh7LuP/11doNeLaeYkvE/Z5naCpSIJF0Nrv4PvE+OUBMfHw2vS4cDwAjYIzQrZezSbEsVq+cP9NpqvKkafCzIE1ACVcuBVsvQOWpAOKmQJSkAwII0RqS7+MWArq4k/7UmcNljBGjpfaEaXr0agaFQ+OcNzc6dJr/3blAtOw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=arm.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=D7cB5zU1ByDq5a++Mtl9WuTdBPv0fgnoAzM9mfcpqIg=;
 b=IpTGdT3y99vV05TTKMHVHwIsYrhV8wbBRAo9orT938jJzauSy9M3YQcX7FI2+mL+UwRyt129wJyDymWcsEjaLjOV+Es5Ji1wieif3M8ZXRCZq8YsEiKVaLTSrJJdOhkQNQBS1t/QUsNqvyAVZYwHdkFDdbkRPyMZfi/GyaNIr90=
Received: from MN0PR04CA0018.namprd04.prod.outlook.com (2603:10b6:208:52d::11)
 by PH0PR12MB7816.namprd12.prod.outlook.com (2603:10b6:510:28c::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9031.13; Thu, 14 Aug
 2025 15:34:06 +0000
Received: from BN3PEPF0000B077.namprd04.prod.outlook.com
 (2603:10b6:208:52d:cafe::d0) by MN0PR04CA0018.outlook.office365.com
 (2603:10b6:208:52d::11) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9031.17 via Frontend Transport; Thu,
 14 Aug 2025 15:34:05 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN3PEPF0000B077.mail.protection.outlook.com (10.167.243.122) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.9031.11 via Frontend Transport; Thu, 14 Aug 2025 15:34:05 +0000
Received: from tunga.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Thu, 14 Aug
 2025 10:33:52 -0500
From: Raghavendra K T <raghavendra.kt@amd.com>
To: <raghavendra.kt@amd.com>
CC: <AneeshKumar.KizhakeVeetil@arm.com>, <Michael.Day@amd.com>,
	<akpm@linux-foundation.org>, <bharata@amd.com>, <dave.hansen@intel.com>,
	<david@redhat.com>, <dongjoo.linux.dev@gmail.com>, <feng.tang@intel.com>,
	<gourry@gourry.net>, <hannes@cmpxchg.org>, <honggyu.kim@sk.com>,
	<hughd@google.com>, <jhubbard@nvidia.com>, <jon.grimm@amd.com>,
	<k.shutemov@gmail.com>, <kbusch@meta.com>, <kmanaouil.dev@gmail.com>,
	<leesuyeon0506@gmail.com>, <leillc@google.com>, <liam.howlett@oracle.com>,
	<linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
	<mgorman@techsingularity.net>, <mingo@redhat.com>, <nadav.amit@gmail.com>,
	<nphamcs@gmail.com>, <peterz@infradead.org>, <riel@surriel.com>,
	<rientjes@google.com>, <rppt@kernel.org>, <santosh.shukla@amd.com>,
	<shivankg@amd.com>, <shy828301@gmail.com>, <sj@kernel.org>, <vbabka@suse.cz>,
	<weixugc@google.com>, <willy@infradead.org>, <ying.huang@linux.alibaba.com>,
	<ziy@nvidia.com>, <Jonathan.Cameron@huawei.com>, <dave@stgolabs.net>,
	<yuanchu@google.com>, <kinseyho@google.com>, <hdanton@sina.com>,
	<harry.yoo@oracle.com>
Subject: [RFC PATCH V3 03/17] mm: Scan the mm and create a migration list
Date: Thu, 14 Aug 2025 15:32:53 +0000
Message-ID: <20250814153307.1553061-4-raghavendra.kt@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250814153307.1553061-1-raghavendra.kt@amd.com>
References: <20250814153307.1553061-1-raghavendra.kt@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN3PEPF0000B077:EE_|PH0PR12MB7816:EE_
X-MS-Office365-Filtering-Correlation-Id: 20d75f28-a20c-45c5-ca67-08dddb480121
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|36860700013|1800799024|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?Ou/yncPx/fCmioDGh51mshp6fmT96HwmtNojBMrjL/3Fg9lht6cVfNvAvw9a?=
 =?us-ascii?Q?V7Us184xzfKEdSQr8HcPPkAGrw2XWSyoGgwvL0hqsNo7YSJbF+73/mXZT9VC?=
 =?us-ascii?Q?7vaT4tNIWGOQ9PRo83J9huOcwF/b8SwruAdfrqFL55lyZSz5R2oQ84GmprJq?=
 =?us-ascii?Q?sQ+rap0l/LI/FUdnKZnoVJunFDHN0tAFwJlzDd1kDERvgJBIDq6UdtrKl2YH?=
 =?us-ascii?Q?dUCfnoCI40BSnYwqmOM8bS2aF1xLcGMMOiYT+zFolMsNDAujhynrm/nWbc6i?=
 =?us-ascii?Q?aOclMmBCTf2nOn+RJk6xenczStnOx8363MGctI1ANBD2RTPNTrsio3arbTiH?=
 =?us-ascii?Q?KwRLWACrad7rSFxDGNURVhyEduLYLXG1vBp6/4C3sT3sGLWkeM8QgWCHJZBQ?=
 =?us-ascii?Q?vmW6PvYzr2Z5pJlvCYRSqYnE2vfFmZbQhAJhy2pW5FPPE7jP40F5Ob4WyNqN?=
 =?us-ascii?Q?YEjSh6rvmuzERU0cU2CkWN7vrUQNgcJriyoRjRS2zN07Mziu8GOm3naLMtXD?=
 =?us-ascii?Q?66R7S7WWpBIaYQs2StifPbsJWsxnaBEO1aTaoUQwDQaKP/kNOvjZSfNKUHZW?=
 =?us-ascii?Q?WURuuoMAuXTJDP3OOQYer3wRRhJca3vgcjH0q/ZSP92PKf5Mh5qCLdDjvmFz?=
 =?us-ascii?Q?SZtKe5viVMyDfy4rbqk253MUfDasEzLZepoV/WgArMkZRQwBxgdDNp6i8znA?=
 =?us-ascii?Q?pNj1iFb3LG1dyMpPrQ5CgQQ9cKZ6xSnzENqF2WkvYLgQd1QivF5+g9k9LG+i?=
 =?us-ascii?Q?/eAFTHKZOBrDZ1LnHYRkYcSfcfNxbUJl1FdMNy04vlAttzvwYVxFBYCKP3+8?=
 =?us-ascii?Q?HfxoKK5rmFARxSy0kwRFdNLvp3bOCVgQsS7Ydg8JFukKNCPlIfBkIRNkub1J?=
 =?us-ascii?Q?KZssPzXyGyit5gcLBzXYMZ+952t/a63SfHm+EIoGtQyBhETnpdpBJqS0J2Eh?=
 =?us-ascii?Q?wnkUjd1DCPlTgnHg3jt5HxindbxLZva2bhEP48JhiBzZYnb3LsCzBPN3dqsx?=
 =?us-ascii?Q?5+L8YeGQnQmM4I6N3qwplfhU0Ehg7lA15fw+zM+grKgzWF9tKjM/6tkj0q+Y?=
 =?us-ascii?Q?A1hmU6lEkawaB7tIS7yjOVk++KaMhDcjSJs4swH/FI9NAiLOt3Z5lHkBTncq?=
 =?us-ascii?Q?fh6yN6mZ7AZdXEmnn00aSXvkLH2Fi/wHjKYuR17FXdUEpFNg6U0S8wEeumtq?=
 =?us-ascii?Q?cJqYGGhD1jsZtPHh6UnIQGpvuszhGBUacGAfWdd5PEXgSItTIJ9XCL3cX9N8?=
 =?us-ascii?Q?5OO4W1a1nQ+oOLBxHtGND4DNGzjn2jhVlUTXNH4XAZFnoJNjUwglnq6YYW+S?=
 =?us-ascii?Q?zJfku1cwY++dWzS0x4aS/Ix1KKQdEO8oIhfhFxKG5Sgxay/I00NS+fZlCuD2?=
 =?us-ascii?Q?PPvHCJ5OVor708ak85IjH8b6XPVB55+95OW2fumPUGo5C5WV1sGzn5un82Zf?=
 =?us-ascii?Q?QK1bjmF63KgctVwpJ4h/FEKINgKUbzmAp2fCvLIpGd4z+wFwlhzetWa1memc?=
 =?us-ascii?Q?PaSObciRvly/5mDdOrPRWMDjFhNq3mrHwSk3?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(36860700013)(1800799024)(7416014)(376014);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Aug 2025 15:34:05.9194
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 20d75f28-a20c-45c5-ca67-08dddb480121
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN3PEPF0000B077.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB7816
X-Rspamd-Queue-Id: 000EF2000F
X-Stat-Signature: gbj6kdummck7of8h7jr9c4psu9mcdyfo
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1755185649-489170
X-HE-Meta: U2FsdGVkX18SY3SZ3J8xnNtwtL9ml4QimB0h75j/zUGugFU8Ymv6bZEA6JcCRqWaUEY3jFFvQY3Krd51ddkOQJn8vEF1iI8QdsJBhlEZrVVLHtHhevk9T8yeLrtEf9yEk04w9glemaJRmcq2UkxfrY1sqCd9Obj64mJoN8GkXa9k2UYkYaxh8zVWhZ9q2mH77bUQbvPzsdiUkM9e0fjEn2lFQQqRl8bLgGD7+Xr5eFlB9j/XE5+55GY6+rDdFjRAAqMROCKJy4TCCH2Q4gV28CUIEt4QXRStFpr0SpjCqRmFe/N9V894HTXaeDH8g7tI38+75S4f2K+zPBfYcbWT8YbnLpzw65NbRSXtRknzOgXkjmZmIc0b6yizsorpqliGh1uxx+SqmrU5g2Sg2GxV8yEb0UoBwxgD2rZ9gnSjeiSlRN0oKHENSBSwsSWvAuZQlHisV8//b5B+KKAsV0zNcFq/ICtfuftP9oTiBAVEmkDiPmvpFyioidN3Cthexp4d35/NoaiP3KhQpLFUZY1n3iS387C+m+Z6MktNcLFygRYdOABfOICDiyhUFDLUt38ouhzPqyfAEuZAC6TureiKwdtw6LlTS9gKVmQJWEJ8FoqiZ4A/VGb9/5QT+vC5eIIQzZdfbWaoM63h3bgSgkGd08eW9m/2Uhx+g1ZIy9wQv+vyqAuRIMPvSKiIv7Lb4yiWdcT9D+76L2tLv56FuUOnTroKdKHNh4hBlfb49GpROk5aXkUAVWuvVLhUp36lGrwt8jhEJMR/5cvgMO85GQkBs2WbXEH3CXzZ/YZdPUJS0oyIQXQwUbWmu7AgtNBLlrUOY1xWW8BHL6CFxQdYzKzXiQmurPBh3O2tk2DphDfvFmL+4/EpiGHIg7Z3Epi54fIrbQILru3MhBXQ7yWLPR+1R4abE+X6Joq2vbKhmGT5Ef9Mzcf2g4aFwWQRyTTAdT3nrnjjcDqWEYww3Xqn3/2
 rVMwWo5y
 zxAWFuuVUyr1bCQr0cnt3g4IANjU8pl8h8Hrh8XJtuCck9i9SZ5k6WiqG6JTjkOcPpluoI7p3Fo4wYRTbtkWyN1ZV4ChnaYuRDp2X8AldzSUK+gGOPbstcz69AfFcvMn6/ZAVxlCxnESLfMegCAnj292k5yn/WafPe4AQoaje/2OQdTV+dzam6uu2HZzlzlOHvrELCsX9W1NMODc2o3yupTAZaVnpzrTFaAxisvce3sztdwydO3tUc6HzlLMIwWvCxu+Wy73cvNUzur60xyxosLhwBdkUDGEW4iI+/9ZGYYDnmOSGXSpn2mMd8ARTCsRZRKz6Q5O4eeUQZokU5Fq1gnlzwGZAyiAbHcdz0oEWxIs/GRLP+avxDjQ08IHyNW2vU94sIenNjIvIZjhQbhTNW7tJ4Yf0EA5/OzeAP50hh3WJxWJQXeCx/Py15ztQ/9U+j3XawkwuFBxdQ6p+79ji7v1w/XGV2XD6/Dm+0sBHPGtWaN2EmW/2xEQL7zbppggbcewu548mqFwDMxIXZdyuRVuywdaLN8oxOAeU0S+C31Fw7v7bdpRgi+xznUJaJ3iKhJWd/f9aDulOUyv2CvHn7o7kfKiiTzqNCqM9NwHRc8HASMX3h8F4vYpHLkl3PwNT7HadsYTk9raGuK7rX2tynmfaB68rKmIiOWwtvXwb7l+/hc/BInPW2XajUg/DAQBCZIK7weL4ynPPHetDl7+AzR7VhB6PoYvqOzXrDEZpL7a5eisjOlikgKlPVyRl8EAf6F+KFSXohgEOtVMR5e5BWFvdPVg12Flh/qjD3//RVV/g/PnSI8IumgIQ3DqqLjoxG8boWKfH0BeSFMv3akHnue9RpHllfx8e4ZDRIDZy9EanCBU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Since we already have the list of mm_struct in the system, add a module to
scan each mm that walks VMAs of each mm_struct and scan all the pages
associated with that.

 In the scan path: Check for the recently acccessed pages (PFNs) belonging
to slowtier nodes. Add all those to a list.

Signed-off-by: Raghavendra K T <raghavendra.kt@amd.com>
---
 mm/kscand.c | 321 +++++++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 320 insertions(+), 1 deletion(-)

diff --git a/mm/kscand.c b/mm/kscand.c
index d5b0d3041b0f..1d883d411664 100644
--- a/mm/kscand.c
+++ b/mm/kscand.c
@@ -4,10 +4,18 @@
 #include <linux/sched.h>
 #include <linux/sched/mm.h>
 #include <linux/mmu_notifier.h>
+#include <linux/rmap.h>
+#include <linux/pagewalk.h>
+#include <linux/page_ext.h>
+#include <linux/page_idle.h>
+#include <linux/page_table_check.h>
+#include <linux/pagemap.h>
 #include <linux/swap.h>
 #include <linux/mm_inline.h>
 #include <linux/kthread.h>
 #include <linux/kscand.h>
+#include <linux/memory-tiers.h>
+#include <linux/mempolicy.h>
 #include <linux/string.h>
 #include <linux/delay.h>
 #include <linux/cleanup.h>
@@ -18,6 +26,11 @@
 
 static struct task_struct *kscand_thread __read_mostly;
 static DEFINE_MUTEX(kscand_mutex);
+/*
+ * Total VMA size to cover during scan.
+ */
+#define KSCAND_SCAN_SIZE	(1 * 1024 * 1024 * 1024UL)
+static unsigned long kscand_scan_size __read_mostly = KSCAND_SCAN_SIZE;
 
 /* How long to pause between two scan cycles */
 static unsigned int kscand_scan_sleep_ms __read_mostly = 20;
@@ -42,6 +55,8 @@ static struct kmem_cache *kscand_slot_cache __read_mostly;
 /* Per mm information collected to control VMA scanning */
 struct kscand_mm_slot {
 	struct mm_slot slot;
+	long address;
+	bool is_scanned;
 };
 
 /* Data structure to keep track of current mm under scan */
@@ -54,6 +69,29 @@ struct kscand_scan kscand_scan = {
 	.mm_head = LIST_HEAD_INIT(kscand_scan.mm_head),
 };
 
+/*
+ * Data structure passed to control scanning and also collect
+ * per memory node information
+ */
+struct kscand_scanctrl {
+	struct list_head scan_list;
+	unsigned long address;
+};
+
+struct kscand_scanctrl kscand_scanctrl;
+/* Per folio information used for migration */
+struct kscand_migrate_info {
+	struct list_head migrate_node;
+	unsigned long pfn;
+	unsigned long address;
+};
+
+static bool kscand_eligible_srcnid(int nid)
+{
+	/* Only promotion case is considered */
+	return  !node_is_toptier(nid);
+}
+
 static inline int kscand_has_work(void)
 {
 	return !list_empty(&kscand_scan.mm_head);
@@ -84,11 +122,277 @@ static void kscand_wait_work(void)
 			scan_sleep_jiffies);
 }
 
+static inline bool is_valid_folio(struct folio *folio)
+{
+	if (!folio || !folio_mapped(folio) || !folio_raw_mapping(folio))
+		return false;
+
+	if (folio_test_unevictable(folio) || folio_is_zone_device(folio) ||
+		folio_maybe_mapped_shared(folio))
+		return false;
+
+	return true;
+}
+
+
+static bool folio_idle_clear_pte_refs_one(struct folio *folio,
+					 struct vm_area_struct *vma,
+					 unsigned long addr,
+					 pte_t *ptep)
+{
+	bool referenced = false;
+	struct mm_struct *mm = vma->vm_mm;
+	pmd_t *pmd = pmd_off(mm, addr);
+
+	if (ptep) {
+		if (ptep_clear_young_notify(vma, addr, ptep))
+			referenced = true;
+	} else if (IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE)) {
+		if (!pmd_present(*pmd))
+			WARN_ON_ONCE(1);
+		if (pmdp_clear_young_notify(vma, addr, pmd))
+			referenced = true;
+	} else {
+		WARN_ON_ONCE(1);
+	}
+
+	if (referenced) {
+		folio_clear_idle(folio);
+		folio_set_young(folio);
+	}
+
+	return true;
+}
+
+static void page_idle_clear_pte_refs(struct page *page, pte_t *pte, struct mm_walk *walk)
+{
+	bool need_lock;
+	struct folio *folio =  page_folio(page);
+	unsigned long address;
+
+	if (!folio_mapped(folio) || !folio_raw_mapping(folio))
+		return;
+
+	need_lock = !folio_test_anon(folio) || folio_test_ksm(folio);
+	if (need_lock && !folio_trylock(folio))
+		return;
+	address = vma_address(walk->vma, page_pgoff(folio, page), compound_nr(page));
+	VM_BUG_ON_VMA(address == -EFAULT, walk->vma);
+	folio_idle_clear_pte_refs_one(folio, walk->vma, address, pte);
+
+	if (need_lock)
+		folio_unlock(folio);
+}
+
+static int hot_vma_idle_pte_entry(pte_t *pte,
+				 unsigned long addr,
+				 unsigned long next,
+				 struct mm_walk *walk)
+{
+	struct page *page;
+	struct folio *folio;
+	struct mm_struct *mm;
+	struct vm_area_struct *vma;
+	struct kscand_migrate_info *info;
+	struct kscand_scanctrl *scanctrl = walk->private;
+	int srcnid;
+
+	scanctrl->address = addr;
+	pte_t pteval = ptep_get(pte);
+
+	if (!pte_present(pteval))
+		return 0;
+
+	if (pte_none(pteval))
+		return 0;
+
+	vma = walk->vma;
+	mm = vma->vm_mm;
+
+	page = pte_page(*pte);
+
+
+	folio = page_folio(page);
+	folio_get(folio);
+
+	if (!is_valid_folio(folio)) {
+		folio_put(folio);
+		return 0;
+	}
+	folio_set_idle(folio);
+	page_idle_clear_pte_refs(page, pte, walk);
+	srcnid = folio_nid(folio);
+
+
+	if (!folio_test_lru(folio)) {
+		folio_put(folio);
+		return 0;
+	}
+
+	if (!kscand_eligible_srcnid(srcnid)) {
+		folio_put(folio);
+		return 0;
+	}
+	if (!folio_test_idle(folio) &&
+		(folio_test_young(folio) || folio_test_referenced(folio))) {
+
+		/* XXX: Leaking memory. TBD: consume info */
+
+		info = kzalloc(sizeof(struct kscand_migrate_info), GFP_NOWAIT);
+		if (info && scanctrl) {
+			info->pfn = folio_pfn(folio);
+			info->address = addr;
+			list_add_tail(&info->migrate_node, &scanctrl->scan_list);
+		}
+	}
+
+	folio_put(folio);
+	return 0;
+}
+
+static const struct mm_walk_ops hot_vma_set_idle_ops = {
+	.pte_entry = hot_vma_idle_pte_entry,
+	.walk_lock = PGWALK_RDLOCK,
+};
+
+static void kscand_walk_page_vma(struct vm_area_struct *vma, struct kscand_scanctrl *scanctrl)
+{
+	if (!vma_migratable(vma) || !vma_policy_mof(vma) ||
+	    is_vm_hugetlb_page(vma) || (vma->vm_flags & VM_MIXEDMAP)) {
+		return;
+	}
+	if (!vma->vm_mm ||
+	    (vma->vm_file && (vma->vm_flags & (VM_READ|VM_WRITE)) == (VM_READ)))
+		return;
+
+	if (!vma_is_accessible(vma))
+		return;
+
+	walk_page_vma(vma, &hot_vma_set_idle_ops, scanctrl);
+}
+
 static inline int kscand_test_exit(struct mm_struct *mm)
 {
 	return atomic_read(&mm->mm_users) == 0;
 }
 
+static void kscand_collect_mm_slot(struct kscand_mm_slot *mm_slot)
+{
+	struct mm_slot *slot = &mm_slot->slot;
+	struct mm_struct *mm = slot->mm;
+
+	lockdep_assert_held(&kscand_mm_lock);
+
+	if (kscand_test_exit(mm)) {
+		hash_del(&slot->hash);
+		list_del(&slot->mm_node);
+
+		mm_slot_free(kscand_slot_cache, mm_slot);
+		mmdrop(mm);
+	}
+}
+
+static unsigned long kscand_scan_mm_slot(void)
+{
+	bool next_mm = false;
+	bool update_mmslot_info = false;
+
+	unsigned long vma_scanned_size = 0;
+	unsigned long address;
+
+	struct mm_slot *slot;
+	struct mm_struct *mm;
+	struct vm_area_struct *vma = NULL;
+	struct kscand_mm_slot *mm_slot;
+
+
+	spin_lock(&kscand_mm_lock);
+
+	if (kscand_scan.mm_slot) {
+		mm_slot = kscand_scan.mm_slot;
+		slot = &mm_slot->slot;
+		address = mm_slot->address;
+	} else {
+		slot = list_entry(kscand_scan.mm_head.next,
+				     struct mm_slot, mm_node);
+		mm_slot = mm_slot_entry(slot, struct kscand_mm_slot, slot);
+		address = mm_slot->address;
+		kscand_scan.mm_slot = mm_slot;
+	}
+
+	mm = slot->mm;
+	mm_slot->is_scanned = true;
+	spin_unlock(&kscand_mm_lock);
+
+	if (unlikely(!mmap_read_trylock(mm)))
+		goto outerloop_mmap_lock;
+
+	if (unlikely(kscand_test_exit(mm))) {
+		next_mm = true;
+		goto outerloop;
+	}
+
+	VMA_ITERATOR(vmi, mm, address);
+
+	for_each_vma(vmi, vma) {
+		kscand_walk_page_vma(vma, &kscand_scanctrl);
+		vma_scanned_size += vma->vm_end - vma->vm_start;
+
+		if (vma_scanned_size >= kscand_scan_size) {
+			next_mm = true;
+			/* TBD: Add scanned folios to migration list */
+			break;
+		}
+	}
+
+	if (!vma)
+		address = 0;
+	else
+		address = kscand_scanctrl.address + PAGE_SIZE;
+
+	update_mmslot_info = true;
+
+	if (update_mmslot_info)
+		mm_slot->address = address;
+
+outerloop:
+	/* exit_mmap will destroy ptes after this */
+	mmap_read_unlock(mm);
+
+outerloop_mmap_lock:
+	spin_lock(&kscand_mm_lock);
+	WARN_ON(kscand_scan.mm_slot != mm_slot);
+
+	/*
+	 * Release the current mm_slot if this mm is about to die, or
+	 * if we scanned all vmas of this mm.
+	 */
+	if (unlikely(kscand_test_exit(mm)) || !vma || next_mm) {
+		/*
+		 * Make sure that if mm_users is reaching zero while
+		 * kscand runs here, kscand_exit will find
+		 * mm_slot not pointing to the exiting mm.
+		 */
+		if (slot->mm_node.next != &kscand_scan.mm_head) {
+			slot = list_entry(slot->mm_node.next,
+					struct mm_slot, mm_node);
+			kscand_scan.mm_slot =
+				mm_slot_entry(slot, struct kscand_mm_slot, slot);
+
+		} else
+			kscand_scan.mm_slot = NULL;
+
+		if (kscand_test_exit(mm)) {
+			kscand_collect_mm_slot(mm_slot);
+			goto end;
+		}
+	}
+	mm_slot->is_scanned = false;
+end:
+	spin_unlock(&kscand_mm_lock);
+	return 0;
+}
+
 static void kscand_do_scan(void)
 {
 	unsigned long iter = 0, mms_to_scan;
@@ -101,7 +405,7 @@ static void kscand_do_scan(void)
 			break;
 
 		if (kscand_has_work())
-			msleep(100);
+			kscand_scan_mm_slot();
 
 		iter++;
 
@@ -148,6 +452,7 @@ void __kscand_enter(struct mm_struct *mm)
 	if (!kscand_slot)
 		return;
 
+	kscand_slot->address = 0;
 	slot = &kscand_slot->slot;
 
 	spin_lock(&kscand_mm_lock);
@@ -175,6 +480,12 @@ void __kscand_exit(struct mm_struct *mm)
 		hash_del(&slot->hash);
 		list_del(&slot->mm_node);
 		free = 1;
+	} else if (mm_slot && kscand_scan.mm_slot == mm_slot && !mm_slot->is_scanned) {
+		hash_del(&slot->hash);
+		list_del(&slot->mm_node);
+		free = 1;
+		/* TBD: Set the actual next slot */
+		kscand_scan.mm_slot = NULL;
 	}
 
 	spin_unlock(&kscand_mm_lock);
@@ -224,6 +535,12 @@ static int stop_kscand(void)
 	return 0;
 }
 
+static inline void init_list(void)
+{
+	INIT_LIST_HEAD(&kscand_scanctrl.scan_list);
+	init_waitqueue_head(&kscand_wait);
+}
+
 static int __init kscand_init(void)
 {
 	int err;
@@ -234,6 +551,8 @@ static int __init kscand_init(void)
 		pr_err("kscand: kmem_cache error");
 		return -ENOMEM;
 	}
+
+	init_list();
 	err = start_kscand();
 	if (err)
 		goto err_kscand;
-- 
2.34.1


