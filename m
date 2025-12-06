Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 39567D3B7D1
	for <linux-mm@archiver.kernel.org>; Sat,  6 Dec 2025 10:15:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C3B966B00C2; Sat,  6 Dec 2025 05:15:03 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C12436B00C4; Sat,  6 Dec 2025 05:15:03 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A8C3E6B00C3; Sat,  6 Dec 2025 05:15:03 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 782D06B00C1
	for <linux-mm@kvack.org>; Sat,  6 Dec 2025 05:15:03 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id CD7721A0413
	for <linux-mm@kvack.org>; Sat,  6 Dec 2025 10:15:02 +0000 (UTC)
X-FDA: 84188638044.06.0C68FC8
Received: from CH4PR04CU002.outbound.protection.outlook.com (mail-northcentralusazon11013026.outbound.protection.outlook.com [40.107.201.26])
	by imf22.hostedemail.com (Postfix) with ESMTP id C8069C0003
	for <linux-mm@kvack.org>; Sat,  6 Dec 2025 10:14:59 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=LU9vsO3g;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	spf=pass (imf22.hostedemail.com: domain of bharata@amd.com designates 40.107.201.26 as permitted sender) smtp.mailfrom=bharata@amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765016100;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=Y8tPnMYgEimbtMqdUhjXjBG9Mr2ZYKt1eLNMlRyyPSk=;
	b=l4YYngB1c+7j8cssG8vSOnZVkkMao4xYLA+EMvL7MVgPbw3FtQKcsvJ9++YCzoAYepIyEK
	uKdJX3GUMs9f32dejFWobBtP5NyRPjC8P5MG7lv9x9SALvE8ycAxn4B0R5pZIlcFkTlD/2
	1ycVoAWrIj/im2wNOIYeGee1UcrxXlg=
ARC-Authentication-Results: i=2;
	imf22.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=LU9vsO3g;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	spf=pass (imf22.hostedemail.com: domain of bharata@amd.com designates 40.107.201.26 as permitted sender) smtp.mailfrom=bharata@amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1765016100; a=rsa-sha256;
	cv=pass;
	b=IMeAtLpbX4hChC4idNWbEAezGZSodw+ZNQAg8BDGp5v1UhpZrCjNqtnOe+Jp+Cspwc4mVB
	xWvCwZby6H0NIY+cOjD35AY1k5ThhM2IwUV912c9uKsyBFKhFtJqoQbmE4E/sTNAo85V7r
	vPxJFK6/0+bnxntHwiuyLrfRXjKhgq8=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=nnEpy15fZSr3jC7gVlustMLwkbOLVkX22lojtRlcP7JTVNt0JBESJf7h0WX/vrokIKDBZf+Wbm+gLT6d8pHmh0Vc5F+gpoSTWwhpBzSSzJVuBOU5u+gKnL2Jx1YR03fUH4i9XlDNcMEMxvhPO1kZRdKKCWzI+DLCtvy6Ddy05RIz+S+gNXW4QIS3Gor/pagkTTnkBG/dyYNf+HY6aI1CtQRj6jEYkFqQY+4taPTRsDlo5KY1zluBeQH3TqDk1Yq6GTnUntSu2bOs6rvyUnpHZHCpuxMNUvknkyIDwDwd759QrNQDI2rFDMbZToKZkgeyOdCxyOkS6Xxl0VyOUEhjig==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Y8tPnMYgEimbtMqdUhjXjBG9Mr2ZYKt1eLNMlRyyPSk=;
 b=XH+M8pHux2BfNrcMoeR5T6BrZkpWIs7CJQGq+UPqufsHgF9WYxoTLvxVLUM+O+wU+5pbC6V1wzUnOmzWqlaKagIPEFvLETq68SuoBKGUyXYfFm7NUtUSws7UpuSDyuARJGGai5Hyt8MRWdmUPSWlS7bmfAMCrlc4yBbqtqpacgSsQ5N5QaOiUA68NHl04JkFBHGqnPt+I77bGUtGcsg+pcAN2KJsJxOxr93rKdnttKb8Gh89QNFr6QucqJDFcCTbBRKX2nwpUjmyNvQbF/ZkhiL2mN4P9Rb2gyzewIanKviepcvRuC/JafJbkfDSIaiMnwPc5TzbetVh+kCieuf+vg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Y8tPnMYgEimbtMqdUhjXjBG9Mr2ZYKt1eLNMlRyyPSk=;
 b=LU9vsO3g1FbxjHTdJKPy6D/D+pOg0NWSt4csA5TzhnESPb9QtVnHFnt2EPXuSv2vzsI9/ZFUyT6z2eGcToDSE2OB3D3op8OS43P6OdLKhPq+QJQsjRLTaPeM77PFTf6KZmTthKjCE+g7ADX5F0Mmmbdv3KA2cW7K00J6zRgB1cY=
Received: from DS7P222CA0002.NAMP222.PROD.OUTLOOK.COM (2603:10b6:8:2e::30) by
 CY5PR12MB6372.namprd12.prod.outlook.com (2603:10b6:930:e::5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9388.12; Sat, 6 Dec 2025 10:14:53 +0000
Received: from CY4PEPF0000EE35.namprd05.prod.outlook.com
 (2603:10b6:8:2e:cafe::96) by DS7P222CA0002.outlook.office365.com
 (2603:10b6:8:2e::30) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9388.12 via Frontend Transport; Sat,
 6 Dec 2025 10:14:53 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 CY4PEPF0000EE35.mail.protection.outlook.com (10.167.242.41) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9412.4 via Frontend Transport; Sat, 6 Dec 2025 10:14:52 +0000
Received: from BLR-L-BHARARAO.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Sat, 6 Dec
 2025 04:14:44 -0600
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
Subject: [RFC PATCH v4 0/9] mm: Hot page tracking and promotion infrastructure
Date: Sat, 6 Dec 2025 15:44:14 +0530
Message-ID: <20251206101423.5004-1-bharata@amd.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: satlexmb08.amd.com (10.181.42.217) To satlexmb07.amd.com
 (10.181.42.216)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PEPF0000EE35:EE_|CY5PR12MB6372:EE_
X-MS-Office365-Filtering-Correlation-Id: 04eba214-6697-40dc-aed4-08de34b04c22
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|1800799024|82310400026|7416014|376014|13003099007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?NRiQLoZeVIIe0R6txB8cKWk4cLB22wABltsjhfUq9IV/tgcMhowVRcpvxcv7?=
 =?us-ascii?Q?VxB9ivLK9R0kofkxZmP8UdjZTeSRgNPHI9S49zItrFf6Pp1SJIUsDLcFNza3?=
 =?us-ascii?Q?n+yBt/byU7PDRYCID2iOePe51CHYDqXRWA8zSAeu69ybHYksNG9+PDbquLWa?=
 =?us-ascii?Q?P4fFIG4q07RbC1iuMHGb2PbhMX42rmDZbBmkRGwfNjSyBLI7VTmVqv5A0gsv?=
 =?us-ascii?Q?CzJ+/NlRTytd3kiVKF6BXJ2K+ZhimkOFBgBad4zv7pPUOBrgqKy+mGvYUb5c?=
 =?us-ascii?Q?AWicjK5kBm4aCXeEwtXDO1pIgPLGJJ1N1l0213G94E10uM95N5Gtisf/UOdF?=
 =?us-ascii?Q?5xwgcRvy8NfwbfQXm3TjZ1e/GnuCCDz3kAut8UPk8/jXZis0oDOj8A0XPXIO?=
 =?us-ascii?Q?ezmxPHeykkGBYLKNvw2DmKEhhR/2w06uXmHTFB3ok1jq/5zHj48T5MWBtS7y?=
 =?us-ascii?Q?JDyqnsWuWlgf90KT+v/S+kebvs2MhqNdyQo5cC1gUH9732azUuYUaSXZlBBv?=
 =?us-ascii?Q?QC27cqTxQgrQ1AQJ48Wgi/65j2PWpn427HUtZnj9Uyx0NGXyuJHwye7Yv207?=
 =?us-ascii?Q?m/A6ZKPGKwRkxbiJuBvJPMU973JLizqB6I8uMDdPU8Nc1p9tGDCx00lphd1X?=
 =?us-ascii?Q?kPEhrX4kK+gf+JWS1H/AvpP3nKh7auZcKHH0ma3xzNf4P0nmsEZr/JrIeA2H?=
 =?us-ascii?Q?SHrWkvR4zKmGobCRE1/a941wOpqrshLVsS/+wbCvYOKgxqLzBEKn20n6lV6Y?=
 =?us-ascii?Q?HA9jruVYgcd8bCAu+XO9I8Xv7wM8gePWK3rm+MtI9fIOhvLAiB6/vm3+ms+x?=
 =?us-ascii?Q?ryarIogSpFpsSobo3exn6Y1wQFnHeywKpJKD5oAdZYPZ3Y/nNzB9IxspaGGF?=
 =?us-ascii?Q?KPEVdICXzVEsA4s5umSFGTVhMrELS8HHte8EwbX/CdN8sBLezYd2zT3MIxAW?=
 =?us-ascii?Q?Z7/Ke16QL2Jcv4viVgE8JlpsmIpnibmgOvjDXdnBDxtJ0nheO+HNYyVdmG0K?=
 =?us-ascii?Q?46DVAs74GQCATkGxFsjdk1G1ufDhnp0WFX37IG8J2+2xDDXFdDrKT+pqE2zO?=
 =?us-ascii?Q?f2a0c5Ci9kL1oqAmyWB7S6XvkFvCmNoyFSPeTCvUsWL5CXyRS1SnfkaTQSue?=
 =?us-ascii?Q?fcTuQteLp0YjfTn4dVqA/EEPTErgR5OV5OJw5KMy/Lm5VtadljbbOIOOOMWu?=
 =?us-ascii?Q?Ocg3TcdwUIzJuaxw62EQgzZUgLWaBt056IYTwC6xGKoRwDHFz4csk1c0R2ra?=
 =?us-ascii?Q?eRnd3uFflKByBLhZxhfw4RkL4zEUdT5grYnbiLENSBbgtwIFC0WkNUg4JRoA?=
 =?us-ascii?Q?PhfZ8C3pF3U8nGf/CVQtiw6z1G5CveuZLRqeygqDcERU8PZXeC3P0XrWmtDf?=
 =?us-ascii?Q?O5ckkLKrXiWiFvX4b6KgGZhEBA6VWWj9jhjrprYUUKwfKvQ9uFKcJnxOpU+i?=
 =?us-ascii?Q?SNXYWpMIUSS6CcYKvBibr7GQt10J/dgGuZNO+vCm21d7/oM/hYhWbpqCF6Nc?=
 =?us-ascii?Q?hprkmupmFJNeKEF2rhMFEOVYDCPpcr6l5cJtwvg23xF5alflM+finTqOxMsM?=
 =?us-ascii?Q?yyN8vrnBLIsN/sKKE4Q=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(1800799024)(82310400026)(7416014)(376014)(13003099007);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Dec 2025 10:14:52.8537
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 04eba214-6697-40dc-aed4-08de34b04c22
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CY4PEPF0000EE35.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB6372
X-Rspam-User: 
X-Stat-Signature: o96bz9d3fz3gand5p6sawgk5uezkik7x
X-Rspamd-Queue-Id: C8069C0003
X-Rspamd-Server: rspam06
X-HE-Tag: 1765016099-540659
X-HE-Meta: U2FsdGVkX18cO56mubR/dbEMSIQmHvA7BZb28d36jgm81KmBaK7TcqqFf+tHN0H05lGxTk78s9nz68tIUleUH5zdJrA31Y+A7sa3pkRFmbBR4MvLUPLi+lwlG8tHMUFMH4qImAqogdNxP6mjQJUmEhcrBoQfOTtrxvyaD03AI3h0CvhXQexLYHdH+/7zbIZrKLT5XyX0pGxi66cGJ3wmo5X8LMV0hdBs9o1ffxsodkk8ZANRIWK8j6u1fX1lBqGc0XOqj1xTJ9b6+CWQecCtFOoQa+zxAZT7BhNPXocMagY0JefKEA+eTr23u2ITdmjDUplKxYTyYdMD7Ib6Ty5ZWzq9D79IqypHoJvj6HMC24gN8XC4Uvr3IDFu5D7mGjQGr9ypgAYqTC+HEGLS6BOmgQNbDyW83g4fOl0t7aNuvlnRFlGzT+fozwOTYF94RbXC1GYPwX6txDODAo2sLWA/SSPCPeeBgnqlezkOQWKUnoOdkrN23nA5+MiB7WDsjKcDxpzu6uSm4nglDbcaqamW3rK74Veugb+OOE10Q1I7PGe0lCCXqsxpkX5j3FYN2/U3OF+Fq23skM3fxouM662cG+wSi3euFe4AVkrweC8xYtkZ605CIBq4IKSLlSLkOSK6YyWbfIa8D3F5bNqlcNK7gwXgG1kyZcSkh85amG5BH8I2viaZIooPB0V4XQo++jfxQNxJmItw4OWMA+7P54N9vc7TfnCqmnmB++aRNRlOH3QJTven2d0rOB3p/wvuLpHhfQZ1Lsu62BF6Db+3JZQP1ylI33oemSslN5/eWBJ1hRTuPlNgA4d/qY+2DWM8FMuJG+Enocry5FKQeVUSbk+2TdBitdiWvoLYyO51f7Ig6DEdswOrjc/kdc/bBgODVzgvqbQ9P7zCNxGY0G4W9G909N8vX61WHYZuxT0/yL2fyvAxJ4Luu7j7UN4B2BcQ4IbyKA0VFy+edTBzRCj/DbN
 cSC1AAjV
 +TyX2xlnRslGFpOMJ1Rh/qDDaGG2wpukkt3kbjkHGXEV0tdk6tBpbRYjQLFcT78l70zIUroKf+GjaBey/4990V/pey4tLAbC+Wik1pLW5tMNsEL43ieghW9dN+AAdBB93fnAKOfjh75zI7xFOEcmqjKP0+6f5TPf5VfnK9wSqsxbzTjq9w1hbFFMsxUysc6q7w1GVEHgEvfPkLOJkTIJ5ewnPITpUJTyVls8MEMtMX2vhqtF0sHyXjXEXt9Dc8A83tdb9pxCyIxMQ2s+ggkHzpTI+4xBWLEdiBwK24xKZ0yC0M1JE+eyQy6SgFOLDSPJxILWd1bQulPpn6Gm1HWPH4BbB60y77yqthUugA1d6GTrcoyRPm8Z/PExMi+rQ6L1FOKwA3biBcVwO0+67Br74Op0i/suTRGnGj7PlZwyWw3zF3jqCzFBBrMwDS2hRPB/vNKxIDlaRaBuncwNeBfHLdBB/PPSGuP3vw4GeXBoFkH5akJTSfh2S21Zs5KXZBTzhrTylD3tnoSyh2gQ+hi1k19Ra0DzZZ/J82/zmHgORSu2rI8qBhmYH+WQiLdJI0OoiIdn8
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi,

This is v4 of page hotness tracking and promotion sub-system pghot.

This patchset introduces a new subsystem for hot page tracking and
promotion (pghot) with the following goals:

- Unify hot page detection from multiple sources like hint faults, page table
  scans, hardware hints (IBS).
- Decouple detection from migration.
- Centralize promotion logic via per-lowertier-node kernel thread.
- Move migration rate limiting and associated logic in NUMAB=2 (current NUMA
  Balancing based hot page promotion) from scheduler to pghot sub-system to
  enable broader reuse.
  
Currently, multiple kernel subsystems detect page accesses independently.
This patchset consolidates accesses from these mechanisms by providing:

- A common API for reporting page accesses
- Shared infrastructure for tracking hotness at PFN granularity
- Per-lowertier-node kernel threads for promoting pages.

Here is a brief summary of how this subsystem works:

- Tracks frequency, last access time and accessing node for each recorded
  access.
- These hotness parameters are maintained on a per-PFN in an unsigned long
  variable within the existing mem_section data structure.
  Bits 0-31 are used to store nid, frequency and time.
  Bits 32-62 are unused now.
  Bit 63 is used to indicate the page is ready for migration.
- Classifies pages as hot based on configurable thresholds.
- Pages classified as hot are marked as ready for migration using the ready bit.
- Per-lowertier-node kmigrated threads periodically scan the PFNs of lower tier
  nodes, checking for the migration-ready bit to perform batched migrations.

Four page hotness sources have been integrated with pghot subsystem on
experimental basis:

1. IBS
2. klruscand (based on MGLRU page table walks)
3. NUMA Balancing (mode 2).
4. folio_mark_accessed()

Changes in v4
=============
- Addition of folio_mark_accessed() as source to track and promote unmapped
  page cache pages.
- Per-section indicator for hotness based on which a section is taken up for
  scanning. This should considerably reduce the scanning effort by kmigrated.
  The LSB of the pointer used to store the hotness data for each section is
  reprovisioned as section hotness indicator.
- Added a file under admin-guide to document the usage of pghot sub-system.
- HWhint source IBS is under its own config option now.
- All vmstat counters are under appropriate config options now.
- Most tunables are moved to a dedicated debugfs dir.
- Some code cleanup.

Results
=======
System details
--------------
3 node AMD Zen5 system with 2 regular NUMA nodes (0, 1) and a CXL node (2)

$ numactl -H
available: 3 nodes (0-2)
node 0 cpus: 0-95,192-287
node 0 size: 128460 MB
node 1 cpus: 96-191,288-383
node 1 size: 128893 MB
node 2 cpus:
node 2 size: 257993 MB
node distances:
node   0   1   2 
  0:  10  32  50 
  1:  32  10  60 
  2:  255  255  10

Hotness sources
---------------
NUMAB0 - Without NUMA Balancing in base case and with no source enabled
	 in the patched case. No migrations occur.
NUMAB2 - Existing hot page promotion for the base case and
	 use of hint faults as source in the patched case.
pgtscan - Klruscand (MGLRU based PTE A bit scanning) source
hwhints - IBS as source
FMA - folio_mark_accessed()

==============================================================
Scenario 1 - Enough memory in toptier and hence only promotion
==============================================================
Microbenchmark details
----------------------
Multi-threaded application with 64 threads that access memory at 4K granularity
repetitively and randomly. The number of accesses per thread and the randomness
pattern for each thread are fixed beforehand. The accesses are divided into stores
and loads.

Benchmark threads run on Node 0, while memory is initially provisioned on
CXL node 2 before the accesses start. There are three modes in which the
benchmark is run:

Mode 1: Regular 4K page accesses. The memory is provisioned on CXL node using
mmap(MAP_POPULATE). 50% loads and 50% stores.

Mode 2: mmapped file 4K accesses. The memory is provisioned on CXL node using
mmap(fd, MAP_POPULATE|MAP_SHARED). 100% loads.

Repetitive accesses results in lowertier pages becoming hot and kmigrated
detecting and migrating them. The benchmark score is the time taken to finish
the accesses in microseconds. The sooner it finishes the better it is. All the
numbers shown below are average of 3 runs.

Mode 1 - Time taken (microseconds, lower is better)
------------------------------------------------------
Source		Base		Patched		Change
------------------------------------------------------
NUMAB0		118,986,471	116,240,187	-2.3%
NUMAB2		104,025,651	105,636,591	+1.5%
pgtscan		NA		110,800,511	NA
hwhints		NA		100,442,082	NA
------------------------------------------------------

Mode 1 - Pages migrated (pgpromote_success)
---------------------------------------
Source		Base		Patched
---------------------------------------
NUMAB0		0		0
NUMAB2		2097152		2097152
pgtscan		NA		2097152
hwhints		NA		1232876
---------------------------------------

Mode 2 - Time taken (microseconds, lower is better)
------------------------------------------------------
Source		Base		Patched		Change
------------------------------------------------------
NUMAB0		113,352,595	110,053,021	-2.9%
NUMAB2		72,339,008	84,999,971	+17.5%
pgtscan		NA		66,189,266	NA
hwhints		NA		71,644,577	NA
------------------------------------------------------

Mode 2 - Pages migrated (pgpromote_success)
---------------------------------------
Source		Base		Patched
---------------------------------------
NUMAB0		0		0
NUMAB2		2097152		2095978
pgtscan		NA		1993077
hwhints		NA		2097129
---------------------------------------

==============================================================
Scenario 2 - Toptier memory overcommited, promotion + demotion
==============================================================
Single threaded application that allocates memory on both DRAM and CXL nodes
using mmap(MAP_POPULATE). Every 1G region of allocated memory on CXL node is
accessed at 4K granularity randomly and repetitively to build up the notion
of hotness in the 1GB region that is under access. This should drive promotion.
For promotion to work successfully, the DRAM memory that has been provisioned
(and not being accessed) should be demoted first. There is enough free memory
in the CXL node to for demotions.

In summary, this benchmark creates a memory pressure on DRAM node and does
CXL memory accesses to drive both demotion and promotion.

The number of accesses are fixed and hence, the quicker the accessed pages
get promoted to DRAM, the sooner the benchmark is expected to finish.

DRAM-node			= 1
CXL-node			= 2
Initial DRAM alloc ratio	= 75%
Allocation-size			= 171798691840
Initial DRAM Alloc-size	=	 128849018880
Initial CXL Alloc-size		= 42949672960
Hot-region-size			= 1073741824
Nr-regions			= 160
Nr-regions DRAM			= 120 (provisioned but not accessed)
Nr-hot-regions CXL		= 40
Access pattern			= random
Access granularity		= 4096
Delay b/n accesses		= 0
Load/store ratio		= 50l50s
THP used			= no
Nr accesses			= 42949672960
Nr repetitions			= 1024

Time taken (microseconds, lower is better)
------------------------------------------------------
Source		Base		Patched		Change
------------------------------------------------------
NUMAB0		61,537,418	59,165,269	-3.8%
NUMAB2		62,070,563	63,087,940	+1.6%
pgtscan		NA		66,886,552	NA
hwhints		NA		63,35,4394	NA
------------------------------------------------------

Pages migrated (pgpromote_success)
---------------------------------------
Source		Base		Patched
---------------------------------------
NUMAB0		0		0
NUMAB2		0		0
pgtscan		NA		6481483
hwhints		NA		304
---------------------------------------

===============================================================
Scenario 3 - Numbers from folio_mark_accessed() (FMA) as source
===============================================================
Single threaded microbenchmark that provisions a file of 2G size on
CXL node initially, runs on Node 0 and reads random file pages at
4k granularity iteratively and repetitively. FMA source detects the
reads on unmapped page cache pages residing on CXL node and mark
them for promotion.
------------------------------------------------------------------
			Base		Patched		Patched
					FMA source	FMA cource
					Disabled	Enabled
------------------------------------------------------------------
Time taken(us)		96,511,260	119,332,436	82,807,865
pgpromote_success	0		0		524242
------------------------------------------------------------------

Results summary
===============
- The observations from v3 pretty much remain the same for 1st
  and 2nd scenarios.
- FMA source: Compared to the base kernel, the time taken to complete
  the file accesses decreases with promotion of file pages in the patched
  version. However when the FMA source isn't enabled we see a regression
  compared to base that needs to be investigated.

This v4 patchset applies on top of upstream commit 4941a17751c9 and
can be fetched from:

https://github.com/AMDESE/linux-mm/tree/bharata/pghot-rfcv4

v3: https://lore.kernel.org/linux-mm/20251110052343.208768-1-bharata@amd.com/
v2: https://lore.kernel.org/linux-mm/20250910144653.212066-1-bharata@amd.com/
v1: https://lore.kernel.org/linux-mm/20250814134826.154003-1-bharata@amd.com/
v0: https://lore.kernel.org/linux-mm/20250306054532.221138-1-bharata@amd.com/

TODOs
=====
- Check if the page is still within the hotness time window when
  kmigrated gets to it.
- Bulk access reporting may be desirable for sources like IBS.
- Take care of memory hotplug for allocation/freeing of mem_section->hot_map.
- Currently I am defaulting to node 0 if target NID isn't specified by the
  source. The best fallback target node may have to determined dynamically.
- Provide compatibility alias for the sysctls moved from sched to pghot.
- Wider testing and benchmark coverage.
- Address Ying Huang's comment about merging migrate_misplaced_folio()
  and migrate_misplaced_folios_batch() and correctly handling memcg
  stats counting properly in the latter.


Bharata B Rao (6):
  mm: migrate: Allow misplaced migration without VMA too
  mm: Hot page tracking and promotion
  x86: ibs: In-kernel IBS driver for memory access profiling
  x86: ibs: Enable IBS profiling for memory accesses
  mm: sched: Move hot page promotion from NUMAB=2 to pghot tracking
  mm: pghot: Add folio_mark_accessed() as hotness source

Gregory Price (1):
  migrate: implement migrate_misplaced_folios_batch

Kinsey Ho (2):
  mm: mglru: generalize page table walk
  mm: klruscand: use mglru scanning for page promotion

 Documentation/admin-guide/mm/pghot.txt |  64 +++
 arch/x86/events/amd/ibs.c              |  10 +
 arch/x86/include/asm/entry-common.h    |   3 +
 arch/x86/include/asm/hardirq.h         |   2 +
 arch/x86/include/asm/msr-index.h       |  16 +
 arch/x86/mm/Makefile                   |   1 +
 arch/x86/mm/ibs.c                      | 348 ++++++++++++++++
 include/linux/migrate.h                |   6 +
 include/linux/mmzone.h                 |  19 +
 include/linux/pghot.h                  |  87 ++++
 include/linux/vm_event_item.h          |  26 ++
 kernel/sched/debug.c                   |   1 -
 kernel/sched/fair.c                    | 152 +------
 mm/Kconfig                             |  32 ++
 mm/Makefile                            |   2 +
 mm/huge_memory.c                       |  26 +-
 mm/internal.h                          |   4 +
 mm/klruscand.c                         | 110 +++++
 mm/memory.c                            |  31 +-
 mm/migrate.c                           |  41 +-
 mm/mm_init.c                           |  10 +
 mm/pghot-debug.c                       | 187 +++++++++
 mm/pghot.c                             | 533 +++++++++++++++++++++++++
 mm/swap.c                              |   8 +
 mm/vmscan.c                            | 181 ++++++---
 mm/vmstat.c                            |  26 ++
 26 files changed, 1686 insertions(+), 240 deletions(-)
 create mode 100644 Documentation/admin-guide/mm/pghot.txt
 create mode 100644 arch/x86/mm/ibs.c
 create mode 100644 include/linux/pghot.h
 create mode 100644 mm/klruscand.c
 create mode 100644 mm/pghot-debug.c
 create mode 100644 mm/pghot.c

-- 
2.34.1


