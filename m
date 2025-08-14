Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 48ABFCA0EE4
	for <linux-mm@archiver.kernel.org>; Thu, 14 Aug 2025 15:34:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BC430900190; Thu, 14 Aug 2025 11:34:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B4EA7900172; Thu, 14 Aug 2025 11:34:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9A0A9900190; Thu, 14 Aug 2025 11:34:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 840CA900172
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 11:34:21 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 4079A1DD91B
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 15:34:21 +0000 (UTC)
X-FDA: 83775759522.08.1B1FC33
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2057.outbound.protection.outlook.com [40.107.236.57])
	by imf24.hostedemail.com (Postfix) with ESMTP id 3D007180006
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 15:34:18 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=TzcMM+zj;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf24.hostedemail.com: domain of Raghavendra.KodsaraThimmappa@amd.com designates 40.107.236.57 as permitted sender) smtp.mailfrom=Raghavendra.KodsaraThimmappa@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755185658;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MqSNVJKUarTtk4qidv7ivgZ7qR/WuPYJzNjNjEwUemA=;
	b=FMyCItUk8eDSxJmyPZJfFxQRD2aAgrjX5slRmSuV92CkRCB5OsW1P/hMibkafZRBIPJjuK
	4DwI1RtWNvWaj9nbIokSzsaubegr2kyQ42yy+U+M5pwRExxaWnPDlnNt42S+px3bCdBhS8
	QNh4btswYzEHNaLp0EXwL1NzgJPsez4=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1755185658; a=rsa-sha256;
	cv=pass;
	b=AAtO9J1TIwY017+X+QRAfWdGfiD1h11zbBHLebT+8WYiS3UiFP180Xc6M7URAMvLOWddgv
	jrdRCrz00V9brxBLbLJSDvCigsFp3GZfo1YVfPywasyA4WIApP6O+ouG5v5AyJizpyQcJQ
	Kh/2Im7NazuDrc4l1wlEKqgYK+IvLlI=
ARC-Authentication-Results: i=2;
	imf24.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=TzcMM+zj;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf24.hostedemail.com: domain of Raghavendra.KodsaraThimmappa@amd.com designates 40.107.236.57 as permitted sender) smtp.mailfrom=Raghavendra.KodsaraThimmappa@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=GiesXj6Vt15HwW8viwr+36okH4RmOlARHzF/lAV7QcpIK+oykFwvdWhaAlIQAC9IyfcWqmd3lLGzf/J2YNOhbjMC1ZuPTHwN6b0CRY1ou4DMgPrUA2dkdNwSUnVtjyeW7z91+Oj7RUOFu/EgiOnopDWhDqCjAxSl8/ihxQj3402ZlBdYzMeFjqZQ9R0vaNcJYaKm3fYWp3+nrghp6ctrlgk5jRYiKlke/6VRJ52/u7AqnOd83/DBIf4l+763ilZY9Ze1AgjQo92eLxnT1ytqJZGzIMtmGVyFlRWliFZDzqJn3S/OhMk+mvV2JY19ntILRPn6br+B0bGOGy976WzllA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MqSNVJKUarTtk4qidv7ivgZ7qR/WuPYJzNjNjEwUemA=;
 b=D9J3jVrft9yXHV9f+NZlEc6rTo49bacxWeRD07HMEqSLeNICOMB0AB4YrM039EE98R+/55FSQspg6xTvoHrxwptmtWtlIlR4WodDWyAfMvkCmvSSoeAzhyQNB8mWeqVE2tilipMi5QiqdvZQfOY3eXW2tcOlx6uqAXkh9sKZAdeZe7tjlFNgVcNjr1yPSbpFrAA4cbpj5PoQhyQbRl1PqzhHr13hFGT37z8mQb3v9I3fHxB1dVtqAxehc35fVftI3xCR+oxWebjzut4u951vdvr8JhSOtvKiJ+wjVbyr10gQV4awhSpPgC427rsfuJrv1wF6STYtfARdn1SGCGr62g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=arm.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MqSNVJKUarTtk4qidv7ivgZ7qR/WuPYJzNjNjEwUemA=;
 b=TzcMM+zj7gjlJuVeAXy9JYPHrebnaW9ZgV7cGOfvy2GXwshmVYdJNfE0m08oQV1fKzRY2qhFzt4c2cY27JGvKswvRu85KXtk5jhO7KUEa/7BKsXkrKXevYAsPAoCyfyTPjTqktrW2JzI8StsapER/fmgb6RDomWUgNcKShO0WOs=
Received: from MN0PR04CA0021.namprd04.prod.outlook.com (2603:10b6:208:52d::32)
 by CH3PR12MB8481.namprd12.prod.outlook.com (2603:10b6:610:157::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9031.16; Thu, 14 Aug
 2025 15:34:14 +0000
Received: from BN3PEPF0000B077.namprd04.prod.outlook.com
 (2603:10b6:208:52d:cafe::eb) by MN0PR04CA0021.outlook.office365.com
 (2603:10b6:208:52d::32) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9031.17 via Frontend Transport; Thu,
 14 Aug 2025 15:34:14 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN3PEPF0000B077.mail.protection.outlook.com (10.167.243.122) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.9031.11 via Frontend Transport; Thu, 14 Aug 2025 15:34:14 +0000
Received: from tunga.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Thu, 14 Aug
 2025 10:34:03 -0500
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
Subject: [RFC PATCH V3 04/17] mm/kscand: Add only hot pages to migration list
Date: Thu, 14 Aug 2025 15:32:54 +0000
Message-ID: <20250814153307.1553061-5-raghavendra.kt@amd.com>
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
X-MS-TrafficTypeDiagnostic: BN3PEPF0000B077:EE_|CH3PR12MB8481:EE_
X-MS-Office365-Filtering-Correlation-Id: abce2e1e-1336-42d1-0e5b-08dddb480653
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|7416014|376014|36860700013|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?E2Z9490f9ZjIk1Tmo9uHh3dUPiEkAPEmEpWzlAjLZbtFf0kefrowYe9+uRgO?=
 =?us-ascii?Q?75/+aGxffofyj861wjNRpkTOaXE2nsl3A8FO0ET3x0zhfrUezPe8SP0tZLUP?=
 =?us-ascii?Q?eJaGmDeKydl53Z9GdMLKufedOthNptD362eTZxgn2P0wfnKSOufVWjopYWkK?=
 =?us-ascii?Q?4FU67mR2AOqdefyp4r9yX10qni57E8kvtWmFPQzRbDkWgNgQOsC8qIUpQLe/?=
 =?us-ascii?Q?CH9/A59mzXbJSGtfb6/hU46kIyH8civCBTtrZhO5AEdcLCAg9Sf66IbpyPm9?=
 =?us-ascii?Q?aNYZkDr48VhALZqDigVbVB5VtOAVuThAbAKb9q+HwdAHHZxRfb9MF7Ks7a+q?=
 =?us-ascii?Q?4BMKN9f/e0VyWTyrV9tQ5qXI175mhKIg9PulCGZACHeD3VvQWPQ6EMjZM1Q3?=
 =?us-ascii?Q?L4UBEt5qxUlYwYfHvzIP1z1/tEJ0QRRugFGfhoR8nl0I/qSZk5BljXXwQhal?=
 =?us-ascii?Q?iaea52Qbzn/YBDxIT/CWIl/fB8ckFhznn1qSW8X7EkzKVk/pup6p1k12LJcl?=
 =?us-ascii?Q?ps5EPv8wHhynpIPmpcS2TCHVSEnbLxls/HEXYB2dim0nQSihJq/NNvQWA3LC?=
 =?us-ascii?Q?T75QBIIwXlORgrYKg3tb3C/XpgOFaMPerkVS2yKoH+mMaTFIdDxbSS8LsxYR?=
 =?us-ascii?Q?0t34nsml6ee0vfSPT5mxI1fBkeO0ZhzZTx6Ig6Dr0eme0OcUyhQmYuhwwx17?=
 =?us-ascii?Q?DO2XeCcDQvtsycFtGWOhZatUUrRx3t6Vmhb7+WW6O8QFZTcTr94JaDu4Jkj7?=
 =?us-ascii?Q?whkDikCiXGGp+FIZCitiuVFjucIV2tiExFVrZHspP/vPJFgnlxqUd35q3Lh3?=
 =?us-ascii?Q?NRswZMul8gl/2IryNvj1ORsafh1wOewwCAcwRh+7hHEJnCPIAIJ71M10hAVB?=
 =?us-ascii?Q?LEqHC+zqgxJPukrjyH8BaR7BXKP2m7N2Lwn5fHm2bpXkFVtJ0DU9v9RN3UQ+?=
 =?us-ascii?Q?KVIJl67eynCW035vMYDUG2ngF0xpJyXjRZdR75N1JHm6ZYs3EN7hI9/HTmeL?=
 =?us-ascii?Q?P9cJzLuT79zKJz5CIE2g1GX8NCId3wmxb9qDPlDxKa6gNIo97LHC2rg0DW70?=
 =?us-ascii?Q?rIpBpumLrm8Qut1mNGLYc4FtsNt3X6DLiWa/2AOalCZamLdANyV1gK/pj35H?=
 =?us-ascii?Q?lrf5zQBTehpPBhEKjTFu8MzeiLI2B8mdyiqzkR+Yc8uKuFvkXeFiwB/fbVUt?=
 =?us-ascii?Q?tPC60TPfNXUHGPqLO5snDTpfM1VRH1bY8E9VexwT5KzqZ+psKHhWNJoyXq2g?=
 =?us-ascii?Q?xe1Rki5uth9a8o/U9mnMcGq81I/SfHMaPxScjr1jpbBhlqBxWzweaRrCCHhn?=
 =?us-ascii?Q?OY6V5eMJY/07LBuVSBl3UA0durVw2HA8TvOQ0ZhE5LWftF2T0sTVCctSeQFG?=
 =?us-ascii?Q?ymgQFIA/aGShFx9jA51pfgDKJFE0ttc5k9MU4S5wDWca0idcIlGbo8RAmCKR?=
 =?us-ascii?Q?Lb8erM6t/aB27MT0/F5clVmfP+xRHbTlgA0/3EBeWdxflxx7jZvH7ueOP9af?=
 =?us-ascii?Q?gcIImjwaoqZtGohrzuEdNi6BakRjoqQn//Se?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(36860700013)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Aug 2025 15:34:14.6290
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: abce2e1e-1336-42d1-0e5b-08dddb480653
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN3PEPF0000B077.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB8481
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 3D007180006
X-Stat-Signature: dinku7anhho7c1591yc35j4f4kxzupxd
X-Rspam-User: 
X-HE-Tag: 1755185658-841256
X-HE-Meta: U2FsdGVkX1/RRZRmFailAnEanrzgZ2NUilLODU/3rkNfkfaMrVh1ITMGp6frO6T2YuuVFZbGn0CLFXFKjrqVw+04DriDzsloxDQ3pbYxMIrZ5Hd0ydpYWswb4X+HZnYaXFPdBXQZndjFzQMaJJl2IzJAeimZlyMzYt3U2d2wJzWopQ4Bs1LfAVoz+fd2XPF4O04vnc+REcre+aUrDvIOuHbx1WRt16D/9iIZERH6W5f4ky/GkgZNH5KWiPVuuzMJSuJUQ/rzNcfULVR8AoVF+MdQYcTLKbCIWu+GjdQPtfguiHM+muJSXzFMUctK/5KI4Mpz0x9nvI3LoF3uGl2NCd/LsqvpqII+SThRiQJ1JAtq//M/hgTPjRiR4Pgwfg6VpTM/ytL+zzgt5RQjmkWUqELffCCvb+f6NTz0fiAig/BH5dXIBnfuduLydp6YHBsnN+AGE/PAr04z1XYhhFpqvPzLQTRn4MP2sA/Cmgjs067341HKxnhF9khv/F0mkc5dNe9aQvsq7MhHzDr3QcDm483E6pAOKY8YJlr+Epnub4H853r1gpsYD5FUdD559VH/BBgw5RBoLpJV+Rc8sjtBRZBvd13Ksg/vRUeG+fZp2P89sSosxOVFv8iDcct+4WRwhF+0IDm3NfQWDDtfBafWzC+t9VWnT8/mdF95uq0PZi1Z3IZRG8gswK/n+He4k/nAJJYGoVDomiID5NJnqIwmozHwyhT9dWuJyU93pqJOzh/hog5RGMsA30s1OpE3uBinU9G80f7KHpQ4QkCdXKyRaixrlxn4p7UOHE178Lza2NeiUIkHXSjm06l9cSEjIWYxH7KTi439pt94D3jo8vGv6QM/9FTyWHvCswG9vMOTaVPUK7gWGSMXn1+QTZrYlGu7pStzqX7ccV0YJvZG16dg9AYURgrU4ReUjhjUuv1/QC9yCNzlCXi5/m4eZnaF7REA3Hz4idkVbS/od9eD/7D
 idjJXeET
 hVAtyTAXsipTNi2iVIQcgqvCiJHWIU74rHnyg0nJymeBRVdT5PhbvuKKEWqemj0JZYlSh8q8z1kwKF/Q5WudNXZgD782xPsHKvnr51QtXAyTS+PNEuZo30ig3dBKoNfPJjtv3oznIOa21Ml33JDRlSbe4Vn/E8LkuZT4tEbELAJ+Kgn0pVvBbrdrBx1tv42zqsH1AbRXSjQNkxYgab0AQYt2kF1za8Pu/b7GV+VOieItwaG7zqjdci1PX2YCix3q9qq5xm4wicMq2zK5/AeWFyoKs1M/i54RZ8dp6IEDyw0+CVMJpNYfZW5aPu9ptYE4P40DmxjEOw52LLXiBZqWlYEddGz+8/Ih9R+daI6JPg1x26ALBmS3e8gbr+LnqCM7OX1xB4JTlvHZzADbm8X7PEbECVcCROX6gUpDXJazeooG50dQmjnm/zzW5OcUvwrmDWk02G4d8c1y0+1thA9HHoqiR1mVI2Ya4FJkoKYJEldNwJJH80GrxQ8kgaIVZh3nKuVVJZwanivL3vHu9qxT5L9nS3tWr9VhYOK5VJ+7XcIVIxQ+5vq7wXb2/KhgGKRKS5v9ZMfR+tuDCq4c+gBVlG8tuQc+xrveKL68/pRccmQi9BN8gSRtA+YQS8tHF3u5/POXJQa+nW4mLPnh3kUAo6guVoGBRJxv6K7BYceQTvJf1tGQ+5e4PbZXz0eu+Cm6FC7u+uzzpOSF9eOjC6WWTJUpyKFqyLrSaz7uEepUUaR/4+qxLdn2FpYcXPhSaHA/Riyvwr9UnRPqkuw8T5KR0HHVfbf7ouiLRN40PGaiub+n0vlj+nOanrEhLPeEnCvXlPJLSjZssMxXtCJI7l4bHiH7Yk3Vs6WRfXQ1s+M5pjkBVHLA=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

 Previously all pages, accessed once are added.
Improve it by adding those that are accessed second time.

This logic is closer to current NUMAB implementation
of spotting hot pages.

Signed-off-by: Raghavendra K T <raghavendra.kt@amd.com>
---
 mm/kscand.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/mm/kscand.c b/mm/kscand.c
index 1d883d411664..7552ce32beea 100644
--- a/mm/kscand.c
+++ b/mm/kscand.c
@@ -196,6 +196,7 @@ static int hot_vma_idle_pte_entry(pte_t *pte,
 	struct kscand_migrate_info *info;
 	struct kscand_scanctrl *scanctrl = walk->private;
 	int srcnid;
+	bool prev_idle;
 
 	scanctrl->address = addr;
 	pte_t pteval = ptep_get(pte);
@@ -219,6 +220,7 @@ static int hot_vma_idle_pte_entry(pte_t *pte,
 		folio_put(folio);
 		return 0;
 	}
+	prev_idle = folio_test_idle(folio);
 	folio_set_idle(folio);
 	page_idle_clear_pte_refs(page, pte, walk);
 	srcnid = folio_nid(folio);
@@ -233,7 +235,7 @@ static int hot_vma_idle_pte_entry(pte_t *pte,
 		folio_put(folio);
 		return 0;
 	}
-	if (!folio_test_idle(folio) &&
+	if (!folio_test_idle(folio) && !prev_idle &&
 		(folio_test_young(folio) || folio_test_referenced(folio))) {
 
 		/* XXX: Leaking memory. TBD: consume info */
-- 
2.34.1


