Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E1770CAC5AE
	for <linux-mm@archiver.kernel.org>; Tue, 23 Sep 2025 17:49:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 595768E0014; Tue, 23 Sep 2025 13:49:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4D25A8E0001; Tue, 23 Sep 2025 13:49:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3735E8E0014; Tue, 23 Sep 2025 13:49:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 148328E0001
	for <linux-mm@kvack.org>; Tue, 23 Sep 2025 13:49:55 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id AE9F11DF61B
	for <linux-mm@kvack.org>; Tue, 23 Sep 2025 17:49:54 +0000 (UTC)
X-FDA: 83921253108.17.7D1B3F7
Received: from DM5PR21CU001.outbound.protection.outlook.com (mail-centralusazon11011060.outbound.protection.outlook.com [52.101.62.60])
	by imf27.hostedemail.com (Postfix) with ESMTP id 9617B40013
	for <linux-mm@kvack.org>; Tue, 23 Sep 2025 17:49:51 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=x7midnkY;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf27.hostedemail.com: domain of shivankg@amd.com designates 52.101.62.60 as permitted sender) smtp.mailfrom=shivankg@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758649791;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0wFXi6tT2mAPntQV3UQ5NM7KkuZqtFOlhy0rFkInSa4=;
	b=DQfGZ65SOUOokRslTAY69TEr7v3VOC8bbkDcLLJ8oyqTKR569Z7Piex3eWxb15IObcd210
	h5ZpxrWyjFYHOiBaXw/5NcujH8sPDCrUAnkdAsxQMOYhkdK/c0R35WrGcb4Tv0jjH2JXr2
	ky65cJTvAeVFihIUxtFzOxHr5o/8gtA=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1758649791; a=rsa-sha256;
	cv=pass;
	b=gIQiBIRfKnCuYfkuNdZzzeIs94d6wr//8XzLj+JZjGekFgxpRBSNaXr1gvbUsqDi0+OSx9
	MWPSm6a8e5fHoQynxpFmWvsVWCBVZmadUtXwu2Yj02lEowZ/sXqfUO1L+LOQpGqATzzo+i
	XWpcUzJP6FV849GYXY+10LYJaaHO3n4=
ARC-Authentication-Results: i=2;
	imf27.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=x7midnkY;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf27.hostedemail.com: domain of shivankg@amd.com designates 52.101.62.60 as permitted sender) smtp.mailfrom=shivankg@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=vTSDa/8qsPoGc6qDn+zm9zqKkYMa/Hz+M+OAjqSLDSqxG1xBx6U2feTRNu4iBe09BUK1ELQg/1QtFslhz5xNZjwy7nMymdZz3v8CR7HRDtVJskUGjmX/knovJ4aSx2EEGWYW54AGRBputiHxS/9RQz/QfV9ogARsHYZ8p605Ywq69d6nMzYWxqnxD93Sc+NRwJ3ut8SeiYXYWeFpHwEeNBIht+Vn1GTSEUl3H1U+cckryCmtAH5WWQ3XPtcgIujRIih7FkvHs1Q3dBOxGa/memQkhpsM1HxtuKPkfL9e5NOEU98XK59Sd/rCUUI9U+Ng7FdMLRMoJGUfb0S3njr9Rw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0wFXi6tT2mAPntQV3UQ5NM7KkuZqtFOlhy0rFkInSa4=;
 b=InU6Sqb+DAEevQ41h551tutzA4cwYR2IlIxrxiI+iJU/FJ/eRoq5iFfKpdGVuWGlXHCoKDcOouanpGRpxHlNLNme+Yffm9DQBuHvd5FYiCrJ+42QxI2z4bPWWjBuHguSy2usjUJoUEgFvfLHxs1Kk1D88S02jqWvspHkbuwFLx/rKL759r1620+l4jZ4rmhidesTAI5UIN2LeW5xlXY/7b6IIU8n5xm9G22Ft/XCsyCyDEJ/STFaw7NIOgcqI5rM7B6NX6NpVmosygWaVuFGJQFvIqwVwsFetmXaINcvoNV/+QjO45O5q0lKhvxXa1LqoRaE6pG28FvNHGNz+VPLiA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=linux-foundation.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0wFXi6tT2mAPntQV3UQ5NM7KkuZqtFOlhy0rFkInSa4=;
 b=x7midnkYDsK/Q6I9yIjizpY3M56ktbUyNyYpJanx8xoZQJ8dPU/GAKjc1box06Y2aHen3O+CJJ+usegAzfx4h2WhGRcaxwfsH1b1QO07VLrhZrTanddA64ko4yPDOZ7NRdRwrvceW6DZKe1Fc9tlIF0mKPLux4Fvt7R2BKsbO7Q=
Received: from BL1PR13CA0151.namprd13.prod.outlook.com (2603:10b6:208:2bd::6)
 by BL3PR12MB6475.namprd12.prod.outlook.com (2603:10b6:208:3bb::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9094.22; Tue, 23 Sep
 2025 17:49:33 +0000
Received: from MN1PEPF0000F0DF.namprd04.prod.outlook.com
 (2603:10b6:208:2bd:cafe::aa) by BL1PR13CA0151.outlook.office365.com
 (2603:10b6:208:2bd::6) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9160.9 via Frontend Transport; Tue,
 23 Sep 2025 17:49:33 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 MN1PEPF0000F0DF.mail.protection.outlook.com (10.167.242.37) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9160.9 via Frontend Transport; Tue, 23 Sep 2025 17:49:33 +0000
Received: from kaveri.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Tue, 23 Sep
 2025 10:49:13 -0700
From: Shivank Garg <shivankg@amd.com>
To: <akpm@linux-foundation.org>, <david@redhat.com>
CC: <ziy@nvidia.com>, <willy@infradead.org>, <matthew.brost@intel.com>,
	<joshua.hahnjy@gmail.com>, <rakie.kim@sk.com>, <byungchul@sk.com>,
	<gourry@gourry.net>, <ying.huang@linux.alibaba.com>, <apopple@nvidia.com>,
	<lorenzo.stoakes@oracle.com>, <Liam.Howlett@oracle.com>, <vbabka@suse.cz>,
	<rppt@kernel.org>, <surenb@google.com>, <mhocko@suse.com>,
	<vkoul@kernel.org>, <lucas.demarchi@intel.com>, <rdunlap@infradead.org>,
	<jgg@ziepe.ca>, <kuba@kernel.org>, <justonli@chromium.org>,
	<ivecera@redhat.com>, <dave.jiang@intel.com>, <Jonathan.Cameron@huawei.com>,
	<dan.j.williams@intel.com>, <rientjes@google.com>,
	<Raghavendra.KodsaraThimmappa@amd.com>, <bharata@amd.com>,
	<shivankg@amd.com>, <alirad.malek@zptcorp.com>, <yiannis@zptcorp.com>,
	<weixugc@google.com>, <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>
Subject: [RFC V3 6/9] mtcopy: introduce multi-threaded page copy routine
Date: Tue, 23 Sep 2025 17:47:41 +0000
Message-ID: <20250923174752.35701-7-shivankg@amd.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250923174752.35701-1-shivankg@amd.com>
References: <20250923174752.35701-1-shivankg@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: satlexmb07.amd.com (10.181.42.216) To satlexmb07.amd.com
 (10.181.42.216)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN1PEPF0000F0DF:EE_|BL3PR12MB6475:EE_
X-MS-Office365-Filtering-Correlation-Id: 736972ed-754a-42e8-0513-08ddfac98e1a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|36860700013|82310400026|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?HQmF6aRZUWSXwMH7y/RR0z1RlyPdcwrT6YkJANnRZZeiIguhPyWByM6SMVSY?=
 =?us-ascii?Q?FRXDCc8L9ElahyllY1eeMm1sLwrTvlW71esYF+2jddqmIzuV/9SWYl+fPrCz?=
 =?us-ascii?Q?dhMcGc7q10RJpH7CH4UewMY+Kmc7N9FTvG5svf/9YJQ156OeOox6ZrKuUnqL?=
 =?us-ascii?Q?CIto6DYqjmq70Wd2xNKYyxQDSKE6JS70eGVmIGF3LOMdfPrnda8ehQWoAtnF?=
 =?us-ascii?Q?+0lEykx1Jf2LYHmFr0LW2oDTBNAwnvDJDhhn0jngWm+WFpm6SmcwydMDguqI?=
 =?us-ascii?Q?aCvCTOp6BkO4XhdbaT8F9JpagVsavNseHHl8o05Z0cBojqxjdmZX2q8ZEMwb?=
 =?us-ascii?Q?I/JGue2DIxwGSjDIcnN5BUGmv0Arc1NR8CnRgEBBJuoX12o2ko61eKctIneR?=
 =?us-ascii?Q?AUhahQljos6zZL/Yc0SFAYVBKSEaTvsJHjH691pHuaguH03Wxj882/v3SUsX?=
 =?us-ascii?Q?KSywmhYC/vzq7QO+15qnNit7J9PWOKZdt+1LZRxdSedhYZKGusoqUEg1HgiK?=
 =?us-ascii?Q?Fa78VEx1sEaoge1hjdvmmtiEgRBHpUM9SbT3xZnox3vI8LI4fVeJymJcAWoH?=
 =?us-ascii?Q?IZEN4PkIgjr/XzyeE1Gr7jkp088QY61brvRlW8pL6adh4NR1Kq9jJBdMoNeu?=
 =?us-ascii?Q?UY4c9MpcwsLCne+HTUTeT76YFD5d89JrPVo/yklOjFU4CBDrg+GH7sFT0in+?=
 =?us-ascii?Q?CqDWg9Hlcq2KnIM2lBCQl7ryKsI2p4yCuwfXxkUzZomaHW1FW+InM/e2mTJy?=
 =?us-ascii?Q?quwT4MZxnB9y2DB8uZQTU59Wwh9ca/69M2JOR0KJkcF1woxh+Wvtz0S6aLN1?=
 =?us-ascii?Q?LOqqNdN/kXqCDN0c053/YVkbv7NlVAkv04ouO9wL37qO9TTAS1qvwL4oUrYg?=
 =?us-ascii?Q?lJZbk/pdLFlqPmox2aA+pHR7nGTOwjCeosUcZnzz60r9Epw/XYZjUegLXo2U?=
 =?us-ascii?Q?GEG6JxSpW8HnCF8CmYqdcDN7ZUAX1tml5TEIMV57LXf/MAtmednQAa7qiPFr?=
 =?us-ascii?Q?0g0sJAkFozQvZFiOO7zsiJAkkYc89rXMTUZnjOuGwwgGnA1XY8Xy5cVYjf3i?=
 =?us-ascii?Q?YDdaiD2Q4AcjNEheKpdOT7TM6wIOlpf+z2vyPB4Jan8Mh4AbhPo5B0uwhtWp?=
 =?us-ascii?Q?Q27IQinAfASNMbIg7bd+/LZN/PxMF5qT9E5vVfmuGUmUKcr8GdEN7ErQyFky?=
 =?us-ascii?Q?et6tFErVhEK3bHmpNJnO5sh44pXu/FGXqojvlLm/X2jJIRHFK+QXXT4goDiF?=
 =?us-ascii?Q?Lj+ZHrVTqyJ0tVefBjf/fPPRfROb1YzE9uO/Hv1CG79G8iamJMmxrb9ic1hb?=
 =?us-ascii?Q?WMzOVw6rHS6UdC1t2cZPIvQwIy8FoH4GXos5/c3n2E0ckv1oziKslV78j2k8?=
 =?us-ascii?Q?2fZn8wsZBlEUkhnyS2XcBwUaLI803Xi+igG2dNmr0ut2VIIdPOrCqXt2vv3O?=
 =?us-ascii?Q?T5ZaU314STH6uFczncOBS6BUlM7NaKCMEpnxpXzlaTRgsxuNK1C7FtUxTkWS?=
 =?us-ascii?Q?RflglKJOcMFNdoKULzjgxNRrptIiKo7jdkBM?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(36860700013)(82310400026)(376014)(7416014);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Sep 2025 17:49:33.5480
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 736972ed-754a-42e8-0513-08ddfac98e1a
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MN1PEPF0000F0DF.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR12MB6475
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 9617B40013
X-Stat-Signature: ud6mfnyehejmmgikkpbgj5a58myqcku1
X-Rspam-User: 
X-HE-Tag: 1758649791-748250
X-HE-Meta: U2FsdGVkX1/mLMWLjX5f8onuPsJv+3CyoZxfw7W+H4xA+j5q2vC+EbCXSFv4dwTYf6ibxV5xsvWPTpk+5+d2odAUyFZlbF91TEF6K7Q5cI/4NxEQm3NMtFTXaJJZLl9mz9gsXn1iWKBtp/iWQL+0lVbtBNsrRinWFvELNB7I6SL0POHe9zpbFl5lNZYLH4SBlWAnAzOY/rGhnqb2iLzv+mSKngtc24Y7iFUaiTxCwp6nk7JPvoLK+cdZlfloQkyrGLfb7qut4RjKAulgRiHG0rSzSa+SE8NGBzaylWWt6cBinRaL6QKfccfXUKlUz+OS4B6IHEGo4Idc0hmyxuEdKFABZWAD5z6b7sJjxTfePeHTmN6vgBGvvWKwPNCYO76Mvr3tyf2zEGNiHVDTFP7sce/xhjGFxljWEVoKPx6viRCc1LYU+89/EG4N5lkgZPn4ZGOvQrbOPMx/SxsKvHVxOUTeLCJbqQk9QcU5Qz2bRJ9+Kya/jvhMyJIQc5tABR4+9C+FGptnWB1cbY+7zDrtMrArk6TsvkSwHswn7EtSYarO48v8YDzwYS72JucsItQ2OcDoHCnmhxb4SDflgP/oY+QCHfdFhBnz3yEViySRj6tWQfGIIcFDHW/G2etMErM6pqkkxBQfrMm1BxVsrH+1QZT0V04OOqt+1nuJaRbqgwK/VB+IbUTrPS+UWGiPZySRQJcqOjmBtUiF9jEw267Ely7HBLwi008dG9Cp9EQNK9P0XvZyztkpvrDviji5NedWUmJKuYNoOZmN5S0Vu0NK1a9n6aCe3A6LQ0ovjsWCcECE6PRV0pcdbw3bqI9Rr9j4I8xG2jWUj7qs9/ORxU2cmg047PnVISVLvWhRRlSUw1u8HbZOAwwWg3SPeKddoIbw0uk4csKgpLSeHiPY33A925r/wgqjcODudx+5ciTQV8wIvxaoL5qtK6uhX8fF7rV0/016wzrzqThMuQOm9gL
 OtSIs+e9
 FdPLR5AHp9AvUY3EBHbDpQqQ3zHMizsxi0exOJ+NCClGhZqJk4HB+rKoaBy+Qv8443bFHQ4jCP947+j8AR3gj3Dt2GWuCcQf6AsAYowmKcPfIp+co3lQOsCD6aUMT/oVC17acQHRyCYtwDk0sLlQSCU8Mwsmu69W2+DAqoW+MfsD5nSEesIVjlLo28UMKZ/4QUPUidIPsHJLbhm1QN566QucHylPW1M/uJUOP1oEBDb5dXs37qkcQiXY80DzEZH132RVKKOWmtwaa75APpRw4hEQfp9iPlt53zcngh35ua243H+mixIx5V4VwwEMcXOPWfA/ercvOybv0Ecl/Xtj4w8xc8AGBOE44Nun2gT3Fdm2rJYA9ROQpK7L5Y8sHYc4Z6eQV3h8cxh6iOhlDxWAOQv1u9TYYofrqE0xY1a6kml4D2yEWb68+VMOmaaLqNMOqa4Z1LOihVD2kS/GTcBjzkh08BEjVGYR2WimuQR8JIxQiEopIg+MlinaO8qHRgBMCyINdH1nM2yRmp3KDSZSJCn+ubm4lpxBDFjHkmSspcu35FX4LzcX3K0v3CN8jZjHe7YMOaAmIQFQY5dAIjXnCsCDN+Ia0niy6u/H951NKq4bMIOrwYl0Zo1uf6tngBwjj6M3sBumyBeGjicedgT8eNd13yvTDbvmnD1K8PNiwe3JSTDnHAsg7wN2WhWTf5sPLKqlUo9q0D2XX4avOp+Sas7jDMw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Zi Yan <ziy@nvidia.com>

Now page copies are batched, multi-threaded page copy can be used to
increase page copy throughput.

Enable using:
echo 1 >  /sys/kernel/cpu_mt/offloading
echo NR_THREADS >  /sys/kernel/cpu_mt/threads

Disable:
echo 0 >  /sys/kernel/cpu_mt/offloading

Signed-off-by: Zi Yan <ziy@nvidia.com>
Co-developed-by: Shivank Garg <shivankg@amd.com>
Signed-off-by: Shivank Garg <shivankg@amd.com>
---
 drivers/Kconfig                        |   2 +
 drivers/Makefile                       |   3 +
 drivers/migoffcopy/Kconfig             |   9 +
 drivers/migoffcopy/Makefile            |   1 +
 drivers/migoffcopy/mtcopy/Makefile     |   1 +
 drivers/migoffcopy/mtcopy/copy_pages.c | 327 +++++++++++++++++++++++++
 6 files changed, 343 insertions(+)
 create mode 100644 drivers/migoffcopy/Kconfig
 create mode 100644 drivers/migoffcopy/Makefile
 create mode 100644 drivers/migoffcopy/mtcopy/Makefile
 create mode 100644 drivers/migoffcopy/mtcopy/copy_pages.c

diff --git a/drivers/Kconfig b/drivers/Kconfig
index 4915a63866b0..d2cbc97a7683 100644
--- a/drivers/Kconfig
+++ b/drivers/Kconfig
@@ -251,4 +251,6 @@ source "drivers/hte/Kconfig"
 
 source "drivers/cdx/Kconfig"
 
+source "drivers/migoffcopy/Kconfig"
+
 endmenu
diff --git a/drivers/Makefile b/drivers/Makefile
index b5749cf67044..5326d88cf31c 100644
--- a/drivers/Makefile
+++ b/drivers/Makefile
@@ -42,6 +42,9 @@ obj-y				+= clk/
 # really early.
 obj-$(CONFIG_DMADEVICES)	+= dma/
 
+# Migration copy Offload
+obj-$(CONFIG_OFFC_MIGRATION)	+= migoffcopy/
+
 # SOC specific infrastructure drivers.
 obj-y				+= soc/
 obj-$(CONFIG_PM_GENERIC_DOMAINS)	+= pmdomain/
diff --git a/drivers/migoffcopy/Kconfig b/drivers/migoffcopy/Kconfig
new file mode 100644
index 000000000000..e73698af3e72
--- /dev/null
+++ b/drivers/migoffcopy/Kconfig
@@ -0,0 +1,9 @@
+config MTCOPY_CPU
+       bool "Multi-Threaded Copy with CPU"
+       depends on OFFC_MIGRATION
+       default n
+       help
+         Interface MT COPY CPU driver for batch page migration
+         offloading. Say Y if you want to try offloading with
+         MultiThreaded CPU copy APIs.
+
diff --git a/drivers/migoffcopy/Makefile b/drivers/migoffcopy/Makefile
new file mode 100644
index 000000000000..0a3c356d67e6
--- /dev/null
+++ b/drivers/migoffcopy/Makefile
@@ -0,0 +1 @@
+obj-$(CONFIG_MTCOPY_CPU) += mtcopy/
diff --git a/drivers/migoffcopy/mtcopy/Makefile b/drivers/migoffcopy/mtcopy/Makefile
new file mode 100644
index 000000000000..b4d7da85eda9
--- /dev/null
+++ b/drivers/migoffcopy/mtcopy/Makefile
@@ -0,0 +1 @@
+obj-$(CONFIG_MTCOPY_CPU) += copy_pages.o
diff --git a/drivers/migoffcopy/mtcopy/copy_pages.c b/drivers/migoffcopy/mtcopy/copy_pages.c
new file mode 100644
index 000000000000..68e50de602d6
--- /dev/null
+++ b/drivers/migoffcopy/mtcopy/copy_pages.c
@@ -0,0 +1,327 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Parallel page copy routine.
+ */
+
+#include <linux/module.h>
+#include <linux/kernel.h>
+#include <linux/printk.h>
+#include <linux/init.h>
+#include <linux/sysctl.h>
+#include <linux/sysfs.h>
+#include <linux/highmem.h>
+#include <linux/workqueue.h>
+#include <linux/slab.h>
+#include <linux/migrate.h>
+#include <linux/migrate_offc.h>
+
+#define MAX_NUM_COPY_THREADS 64
+
+unsigned int limit_mt_num = 4;
+static int is_dispatching;
+
+static int copy_page_lists_mt(struct list_head *dst_folios,
+		struct list_head *src_folios, unsigned int nr_items);
+
+static DEFINE_MUTEX(migratecfg_mutex);
+
+/* CPU Multithreaded Batch Migrator */
+struct migrator cpu_migrator = {
+	.name = "CPU_MT_COPY\0",
+	.migrate_offc = copy_page_lists_mt,
+	.owner = THIS_MODULE,
+};
+
+struct copy_item {
+	char *to;
+	char *from;
+	unsigned long chunk_size;
+};
+
+struct copy_page_info {
+	struct work_struct copy_page_work;
+	int ret;
+	unsigned long num_items;
+	struct copy_item item_list[];
+};
+
+static unsigned long copy_page_routine(char *vto, char *vfrom,
+	unsigned long chunk_size)
+{
+	return copy_mc_to_kernel(vto, vfrom, chunk_size);
+}
+
+static void copy_page_work_queue_thread(struct work_struct *work)
+{
+	struct copy_page_info *my_work = (struct copy_page_info *)work;
+	int i;
+
+	my_work->ret = 0;
+	for (i = 0; i < my_work->num_items; ++i)
+		my_work->ret |= !!copy_page_routine(my_work->item_list[i].to,
+					my_work->item_list[i].from,
+					my_work->item_list[i].chunk_size);
+}
+
+static ssize_t mt_offloading_set(struct kobject *kobj, struct kobj_attribute *attr,
+		const char *buf, size_t count)
+{
+	int ccode;
+	int action;
+
+	ccode = kstrtoint(buf, 0, &action);
+	if (ccode) {
+		pr_debug("(%s:) error parsing input %s\n", __func__, buf);
+		return ccode;
+	}
+
+	/*
+	 * action is 0: User wants to disable MT offloading.
+	 * action is 1: User wants to enable MT offloading.
+	 */
+	switch (action) {
+	case 0:
+		mutex_lock(&migratecfg_mutex);
+		if (is_dispatching == 1) {
+			stop_offloading();
+			is_dispatching = 0;
+		} else
+			pr_debug("MT migration offloading is already OFF\n");
+		mutex_unlock(&migratecfg_mutex);
+		break;
+	case 1:
+		mutex_lock(&migratecfg_mutex);
+		if (is_dispatching == 0) {
+			start_offloading(&cpu_migrator);
+			is_dispatching = 1;
+		} else
+			pr_debug("MT migration offloading is already ON\n");
+		mutex_unlock(&migratecfg_mutex);
+		break;
+	default:
+		pr_debug("input should be zero or one, parsed as %d\n", action);
+	}
+	return sizeof(action);
+}
+
+static ssize_t mt_offloading_show(struct kobject *kobj,
+		struct kobj_attribute *attr, char *buf)
+{
+	return sysfs_emit(buf, "%d\n", is_dispatching);
+}
+
+static ssize_t mt_threads_set(struct kobject *kobj, struct kobj_attribute *attr,
+		const char *buf, size_t count)
+{
+	int ccode;
+	unsigned int threads;
+
+	ccode = kstrtouint(buf, 0, &threads);
+	if (ccode) {
+		pr_debug("(%s:) error parsing input %s\n", __func__, buf);
+		return ccode;
+	}
+
+	if (threads > 0 && threads <= MAX_NUM_COPY_THREADS) {
+		mutex_lock(&migratecfg_mutex);
+		limit_mt_num = threads;
+		mutex_unlock(&migratecfg_mutex);
+		pr_debug("MT threads set to %u\n", limit_mt_num);
+	} else {
+		pr_debug("Invalid thread count. Must be between 1 and %d\n", MAX_NUM_COPY_THREADS);
+		return -EINVAL;
+	}
+
+	return count;
+}
+
+static ssize_t mt_threads_show(struct kobject *kobj,
+		struct kobj_attribute *attr, char *buf)
+{
+	return sysfs_emit(buf, "%u\n", limit_mt_num);
+}
+
+int copy_page_lists_mt(struct list_head *dst_folios,
+		struct list_head *src_folios, unsigned int nr_items)
+{
+	struct copy_page_info *work_items[MAX_NUM_COPY_THREADS] = {0};
+	unsigned int total_mt_num = limit_mt_num;
+	struct folio *src, *src2, *dst, *dst2;
+	int max_items_per_thread;
+	int item_idx;
+	int err = 0;
+	int cpu;
+	int i;
+
+	if (IS_ENABLED(CONFIG_HIGHMEM))
+		return -EOPNOTSUPP;
+
+	/* Each threads get part of each page, if nr_items < totla_mt_num */
+	if (nr_items < total_mt_num)
+		max_items_per_thread = nr_items;
+	else
+		max_items_per_thread = (nr_items / total_mt_num) +
+				((nr_items % total_mt_num) ? 1 : 0);
+
+
+	for (cpu = 0; cpu < total_mt_num; ++cpu) {
+		work_items[cpu] = kzalloc(sizeof(struct copy_page_info) +
+						sizeof(struct copy_item) *
+							max_items_per_thread,
+					  GFP_NOWAIT);
+		if (!work_items[cpu]) {
+			err = -ENOMEM;
+			goto free_work_items;
+		}
+	}
+
+	if (nr_items < total_mt_num) {
+		for (cpu = 0; cpu < total_mt_num; ++cpu) {
+			INIT_WORK((struct work_struct *)work_items[cpu],
+					  copy_page_work_queue_thread);
+			work_items[cpu]->num_items = max_items_per_thread;
+		}
+
+		item_idx = 0;
+		dst = list_first_entry(dst_folios, struct folio, lru);
+		dst2 = list_next_entry(dst, lru);
+		list_for_each_entry_safe(src, src2, src_folios, lru) {
+			unsigned long chunk_size = PAGE_SIZE * folio_nr_pages(src) / total_mt_num;
+			char *vfrom = page_address(&src->page);
+			char *vto = page_address(&dst->page);
+
+			VM_WARN_ON(PAGE_SIZE * folio_nr_pages(src) % total_mt_num);
+			VM_WARN_ON(folio_nr_pages(dst) != folio_nr_pages(src));
+
+			for (cpu = 0; cpu < total_mt_num; ++cpu) {
+				work_items[cpu]->item_list[item_idx].to =
+					vto + chunk_size * cpu;
+				work_items[cpu]->item_list[item_idx].from =
+					vfrom + chunk_size * cpu;
+				work_items[cpu]->item_list[item_idx].chunk_size =
+					chunk_size;
+			}
+
+			item_idx++;
+			dst = dst2;
+			dst2 = list_next_entry(dst, lru);
+		}
+
+		for (cpu = 0; cpu < total_mt_num; ++cpu)
+			queue_work(system_unbound_wq,
+				   (struct work_struct *)work_items[cpu]);
+	} else {
+		int num_xfer_per_thread = nr_items / total_mt_num;
+		int per_cpu_item_idx;
+
+
+		for (cpu = 0; cpu < total_mt_num; ++cpu) {
+			INIT_WORK((struct work_struct *)work_items[cpu],
+					  copy_page_work_queue_thread);
+
+			work_items[cpu]->num_items = num_xfer_per_thread +
+					(cpu < (nr_items % total_mt_num));
+		}
+
+		cpu = 0;
+		per_cpu_item_idx = 0;
+		item_idx = 0;
+		dst = list_first_entry(dst_folios, struct folio, lru);
+		dst2 = list_next_entry(dst, lru);
+		list_for_each_entry_safe(src, src2, src_folios, lru) {
+			work_items[cpu]->item_list[per_cpu_item_idx].to =
+				page_address(&dst->page);
+			work_items[cpu]->item_list[per_cpu_item_idx].from =
+				page_address(&src->page);
+			work_items[cpu]->item_list[per_cpu_item_idx].chunk_size =
+				PAGE_SIZE * folio_nr_pages(src);
+
+			VM_WARN_ON(folio_nr_pages(dst) !=
+				   folio_nr_pages(src));
+
+			per_cpu_item_idx++;
+			item_idx++;
+			dst = dst2;
+			dst2 = list_next_entry(dst, lru);
+
+			if (per_cpu_item_idx == work_items[cpu]->num_items) {
+				queue_work(system_unbound_wq,
+					(struct work_struct *)work_items[cpu]);
+				per_cpu_item_idx = 0;
+				cpu++;
+			}
+		}
+		if (item_idx != nr_items)
+			pr_warn("%s: only %d out of %d pages are transferred\n",
+				__func__, item_idx - 1, nr_items);
+	}
+
+	/* Wait until it finishes  */
+	for (i = 0; i < total_mt_num; ++i) {
+		flush_work((struct work_struct *)work_items[i]);
+		/* retry if any copy fails */
+		if (work_items[i]->ret)
+			err = -EAGAIN;
+	}
+
+free_work_items:
+	for (cpu = 0; cpu < total_mt_num; ++cpu)
+		kfree(work_items[cpu]);
+
+	return err;
+}
+
+static struct kobject *mt_kobj_ref;
+static struct kobj_attribute mt_offloading_attribute = __ATTR(offloading, 0664,
+		mt_offloading_show, mt_offloading_set);
+static struct kobj_attribute mt_threads_attribute = __ATTR(threads, 0664,
+		mt_threads_show, mt_threads_set);
+
+static int __init cpu_mt_module_init(void)
+{
+	int ret = 0;
+
+	mt_kobj_ref = kobject_create_and_add("cpu_mt", kernel_kobj);
+	if (!mt_kobj_ref)
+		return -ENOMEM;
+
+	ret = sysfs_create_file(mt_kobj_ref, &mt_offloading_attribute.attr);
+	if (ret)
+		goto out_offloading;
+
+	ret = sysfs_create_file(mt_kobj_ref, &mt_threads_attribute.attr);
+	if (ret)
+		goto out_threads;
+
+	is_dispatching = 0;
+
+	return 0;
+
+out_threads:
+	sysfs_remove_file(mt_kobj_ref, &mt_offloading_attribute.attr);
+out_offloading:
+	kobject_put(mt_kobj_ref);
+	return ret;
+}
+
+static void __exit cpu_mt_module_exit(void)
+{
+	/* Stop the MT offloading to unload the module */
+	mutex_lock(&migratecfg_mutex);
+	if (is_dispatching == 1) {
+		stop_offloading();
+		is_dispatching = 0;
+	}
+	mutex_unlock(&migratecfg_mutex);
+
+	sysfs_remove_file(mt_kobj_ref, &mt_threads_attribute.attr);
+	sysfs_remove_file(mt_kobj_ref, &mt_offloading_attribute.attr);
+	kobject_put(mt_kobj_ref);
+}
+
+module_init(cpu_mt_module_init);
+module_exit(cpu_mt_module_exit);
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Zi Yan");
+MODULE_DESCRIPTION("CPU_MT_COPY"); /* CPU Multithreaded Batch Migrator */
-- 
2.43.0


