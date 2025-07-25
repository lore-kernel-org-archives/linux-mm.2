Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AA870C83F26
	for <linux-mm@archiver.kernel.org>; Fri, 25 Jul 2025 08:30:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4D21F8E0005; Fri, 25 Jul 2025 04:30:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4A9678E0001; Fri, 25 Jul 2025 04:30:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3713B8E0005; Fri, 25 Jul 2025 04:30:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 222648E0001
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 04:30:45 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id A2E4CBAAB6
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 08:30:44 +0000 (UTC)
X-FDA: 83702116008.20.EEDA8DB
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf26.hostedemail.com (Postfix) with ESMTP id 31F82140005
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 08:30:40 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=q1Yi+aqu;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=n235iMZ5;
	spf=pass (imf26.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1753432241; a=rsa-sha256;
	cv=pass;
	b=R2Y1Kcppz3RGUqMgmFqoE2lbE72/7+oCaVSmz/8ie4is/J3DADT9LmSWqLonWviXgAUTsj
	LEsKBoSnlXS3zoYPUUA+OBia/EKHUWyIFgadnnwbCRuQXMn1l3QKdY09QF+lAT32vnUOSO
	d+ksBfqIAoUDZzoeYoRz0sUmyYVIjQE=
ARC-Authentication-Results: i=2;
	imf26.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=q1Yi+aqu;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=n235iMZ5;
	spf=pass (imf26.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753432241;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2SWHnODwaZHc7cbsXpb7KgRvwcB9iipkBvdz3VRiUbI=;
	b=b6RmR+gqTjWjTI29OGzywqP4rdadePvUcrnf0Y06kx7fjL3qzLYKYkiVYE+UcCk3PqA6Ss
	6XfeI6QpNciGT9rtsrvz6wykNbL0Sz6xl4j8mq2HH3Gjr+jlOO2yvyXA7tmAwgQP+WHYiU
	KE7Yxt4Z6iToYulx9cmyOVfev/Of0uk=
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 56P7fpUq013030;
	Fri, 25 Jul 2025 08:30:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=2SWHnODwaZHc7cbsXpb7KgRvwcB9iipkBvdz3VRiUbI=; b=
	q1Yi+aqu5+CjUK6frzR7eXVJU78l6f6cvih4YD5+3RMWzMtwfA7TNLm+waBinh73
	hIjfmHxekDF1HmXMlfBOf8/ihVAAp6ekB7C2MoKIulHrqHitqGrUsEQ9lxMmRRcc
	47tnQogLd5Uq/HH6EAvOLpmcbRxNeHxM3HzoOxSZrXceClyDzNBCSicVRSiB8p8p
	e+yQfDjlX0m1yQDpNsFNcwJhvFzfv5IIVpp1QTcQyxPQikCYKRtWzcpyXJihFqb+
	eHY0Z8Mjr7mBj+IPmnFOwbyCCNPA0LyH8TI3MFFKZkJ+c8pZ0Oq6VaNV0pz6PgZd
	wZr8GWTOQp5PeCGfuEurzg==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 483w3wgm8u-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 25 Jul 2025 08:30:35 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 56P8U2I4014553;
	Fri, 25 Jul 2025 08:30:34 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12on2042.outbound.protection.outlook.com [40.107.244.42])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4801tk5gt8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 25 Jul 2025 08:30:34 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Hjf9AtAw1nG7VsonJZpb5p4Z4kHXnioe/MOiw9KSSQbDdPPs7ZJvWs9OLSFE9YM8Td6qI2Qbui+9UbThs7bNz04MFqR8qvxncMckkLKOcDYfVuIDc4T0TUZClYls/5lYZXn76TbKy/l3lfCGJzWonXHdrg2QpO/x5JIjm+NI2lPoQtxBrxaMAtKRKgod6//+yXAyt9lwxrgTVmQkXxVqczOk7aY3NRk7B8FRL68Y713pUdxvXIzP4SGOgV946AJfaqc2xCjP9t8Z0S9xqdIVUvEufiw8R1EnPWhO71F67X7QmnTygg1FAXXBq7JJi8qx6SImbTxdS9aNDR7eatRK3w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2SWHnODwaZHc7cbsXpb7KgRvwcB9iipkBvdz3VRiUbI=;
 b=fcuC1KkMTgdSoTZ8yRCNRmXATs+f1jUQLcDxeEAU+WlO4+a+l1IC3VPiO5mlrtYwF20VDLrn3qTvZ/RTiqnWZhs7ybxU/XdkfK9dvoCVApiGsQkw6uWcZ6cOkj8CNvtwbgjzUOivAkfrerUnnoMWL6uIkDBhc3RJr0LiKv+NQfwjhNUccQGKeiERvBqjEinol8KuLaGqmdrPoqs0Cw739OWyndlbnrGpTcClsvuKPBOHiIhxrN7ym8N/erR8Hr9xR6fxivs1wlfBqDxNS9l0/puaqM/ozUE+nOSqohxoDZqVMsZOq002Vv/gyypPQ/vQhFvsGJlpIhQXgBHkQCCYPw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2SWHnODwaZHc7cbsXpb7KgRvwcB9iipkBvdz3VRiUbI=;
 b=n235iMZ5FfjsM1orvYWCNAT4PG6J2Xqvg9QkZqWUwQR7mdTo3AornEkWMHWEfJWZTdiQny6VGRRACKmIahZcFOWcOyNP6+rh0gE8OI5KVPuFWSXnXDjneCbYwvM21BRR94xhuBQ4TPcZ6SON3W5MvRIDcY+2aLafSdkmJLRJyTw=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by SJ0PR10MB6422.namprd10.prod.outlook.com (2603:10b6:a03:44c::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8964.22; Fri, 25 Jul
 2025 08:30:31 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%5]) with mapi id 15.20.8964.019; Fri, 25 Jul 2025
 08:30:31 +0000
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Liam R . Howlett" <Liam.Howlett@oracle.com>,
        David Hildenbrand <david@redhat.com>, Vlastimil Babka <vbabka@suse.cz>,
        Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Jeff Xu <jeffxu@chromium.org>, Kees Cook <kees@kernel.org>
Subject: [PATCH v4 5/5] mm/mseal: rework mseal apply logic
Date: Fri, 25 Jul 2025 09:29:45 +0100
Message-ID: <ddfa4376ce29f19a589d7dc8c92cb7d4f7605a4c.1753431105.git.lorenzo.stoakes@oracle.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <cover.1753431105.git.lorenzo.stoakes@oracle.com>
References: <cover.1753431105.git.lorenzo.stoakes@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: LO4P123CA0343.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:18d::6) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|SJ0PR10MB6422:EE_
X-MS-Office365-Filtering-Correlation-Id: 2a0274da-efbe-435a-4886-08ddcb558488
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?2yH8bsAYmUJz675CGsWHNgocBeC1s5Pdro9c+o1Uish7S46/DB2BLB2xdjEu?=
 =?us-ascii?Q?nDon22SNpgf8yYup93nCkPsy5xpUc6YikZ9GkUg5LkZPXKWCZ++lhdKfsLai?=
 =?us-ascii?Q?7Z71k1eekZ+7zKqH1zXFBXDMpafTOVm/tyYe8+zcw4jgnnT7UyB9ep/xbzNj?=
 =?us-ascii?Q?ZDZhB3FQvqyVvmxf07DTJ5bWUEtwpLYmfIxngsbzZu5xkGWX1EsBfxQzxvX8?=
 =?us-ascii?Q?YjVd884BYFSTa51kk2ujysEQGLv3qyj/4gZIZAzKn3k/IGlmrF7xcY2sB0gq?=
 =?us-ascii?Q?xQC5Xn4efKNyMIpESyYE2tXC0yEWehc5L2CxiuCUnSHS7SyidcNrgP5quFQR?=
 =?us-ascii?Q?SeI24+wPhlE1sJ6P/FBDkYstF977hqFLxYqr/VuUAvFN7kT84VZSSOwovV10?=
 =?us-ascii?Q?SdG+cUIL7RntFn4T05p75uwJMZYPmK8XebgxuHBys/G966DTm4d4ITvnXels?=
 =?us-ascii?Q?D8b2P9vzHhfxkuY23FMGve728wD5NQKrXlAwuB6lwwsDwBLAIfG6yVEb1FLU?=
 =?us-ascii?Q?tqxzNUkiWQeUhWFJUKXEsKXBjKL1ceC1XZliC+4OPGvtwxHwK2mraDTiFGAL?=
 =?us-ascii?Q?xigcT1aO4rF0LfmoOuOe5oeTglCAUcThzqqm+Q/PFF7Z5eFlqzxYQyZWj8LQ?=
 =?us-ascii?Q?GdvhCkCfgMnWkuMDO78p2NM0x4siQ8BPo8usun8hjk0G5lawFeS2lrAtHZoI?=
 =?us-ascii?Q?WlMwh0PKRG4H20qpqQaQ6vkYLmdTWbqHGdltyBzgWCOPCVzXOzd+Hsf7nytM?=
 =?us-ascii?Q?tLRj+0LNzqvgCYUDYjW6NvVqBB0u/vLgJSC66XG0Zhuy2X+hQLrQbJFWS0jh?=
 =?us-ascii?Q?98gyahnv2mWPsDkRZY2Oj4A9Z8Z48yMIu3kwiRbOTC2D6h8TLEgzXoE2xXJR?=
 =?us-ascii?Q?SmTEZBwEf19h11FtYlqAf4Q2OURLI6NZrZC5v22q71CRUpJusBnikXViBN66?=
 =?us-ascii?Q?PPniS7wdSMTnfDhFtfAclEpdW8hSBVeoQFxuJMnPDqwGNghtrXdeLeaP/A1n?=
 =?us-ascii?Q?O+SXgjiAH7thgGEskiVi44sj/H94n9p4934tKXEMWMMTT0REHN+saVmoWFnE?=
 =?us-ascii?Q?lZTdU6M366yStKqMckKTZdVcI2C9E9gUVmKaf0H4zqRtG/LmWCRBl8ngLhHa?=
 =?us-ascii?Q?e/6PZO2NdJj/w1La1dDJQjpsI8Gt7nU2/xtFMe3Wwu672qHzOyaApaQS+OIM?=
 =?us-ascii?Q?ZIrXUBa96bXi/RYNygACFuONC+oIv63bmET1C831L3olnxkAybRsi/WhiqM/?=
 =?us-ascii?Q?SPktTQvO2GHzwKMBbmwte/4fHHB5A6dQehL8tf6eHPXrXHqqsINKY2TPlL4P?=
 =?us-ascii?Q?B7NTi2ee3La2/bjd6TODCarTr3ChW1DNd2Sl7SbrJk40Zq4PbLfhPq3HDqmB?=
 =?us-ascii?Q?k4nvpVnt1VegPIz3EnaJBj71O7C1/GJY6VdZV3C0Zwys6uyDeFMY1OjSD7r6?=
 =?us-ascii?Q?fcH53Md85V8=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?+yxMLjGwVG4cn3y0RivPhEK6ihMCjkmupoE8DRjfAZYw7jeQ9ytkYvn0Mgnx?=
 =?us-ascii?Q?gwpCcK79UhRN1Ptpp/tM44LLD3g11s6pJftW992HKtajZgd5xfo5bOQRc0/v?=
 =?us-ascii?Q?xscI//ePD9FsQk7Nbv2hbjnbj/VLTPM2KnMA7JnXFR72FP011nEnBK6IB03N?=
 =?us-ascii?Q?SxG5AnoTutpLUc7J0oMUSLMFT9SHru6BRzNlmQ9ea3kcTCC/TOcVrfGGWRCL?=
 =?us-ascii?Q?ZFR1Z8WtlazuwrGqy/FhkXoi+NZRQUKvkricSeX5sPkldQY1TAI1bmSuvAss?=
 =?us-ascii?Q?C2DEAQ2d6esCHZ6pqwCmbDHoalbh5F0VsVAe5v3Mm8ZmGClcaRKt1B05Z6Gb?=
 =?us-ascii?Q?l0+aPNigDDDqw/e8F7SKMyHynQtgONT6825rCpOThj/oaJ9BbMugy27QhdFd?=
 =?us-ascii?Q?ZMrug+1PhzwNS3Thp0Yn+MSUunXZHD5ktn7Jsl0xtLXyHALR0xCQdMd3aasW?=
 =?us-ascii?Q?xAd5O0kL+UShFNyBy5/JxiGPwrvgmRHQcDxCKQgx/PXB4mPKlI4DrG3cchGC?=
 =?us-ascii?Q?Sntnzv2nFkdsTt81fjLiLhiXdn9xRD8Pdf5BA2a8vrO6s2GlLLoUW9qSrNoN?=
 =?us-ascii?Q?bqutysYrPL8Bzyb2GB+2bv9dKVq1mFM9aVvDJ+F8XH6Th66+AXJ9skFrUrpN?=
 =?us-ascii?Q?zDRVPiwx9uXTBJf8xlhi5xR0oDlSonOgqXFOWmH3brnLkgw/2ADcKpQZHWUu?=
 =?us-ascii?Q?Cucg4H2mYG9HaQ70ScNxzl45AB2vB6zbHo6nJVEAC+7+iww9j2NA05LfgbpB?=
 =?us-ascii?Q?m39vh9/IQ4p/I5sjOqHeb+nNODKKm5/KPVA+2E8YOQMQmVU7HFaPvQHjuQzg?=
 =?us-ascii?Q?iTQUU/vv8B5SNTpEJQ+XkKhTkrkB10RrW3X+zldjPPjELmgoc9mRNmmg0RUj?=
 =?us-ascii?Q?51PT1LnwBt6f+qCsM93uTbXqj2+1jjwzDE3BQUfKjef2zAOn9+0UAbfCf/+V?=
 =?us-ascii?Q?+yRqtL9e9GTeFZ4xgPmwaM7VQRfb1j688ZEgS37ZLt87XvG1wh2TYMjj0NAd?=
 =?us-ascii?Q?XMm7d6kwW0JjttxUR16ITfOP3I43SnSgCkp0sDa/wScai2ldbBoy8hlJuTUk?=
 =?us-ascii?Q?3Y7rIUj0DAI1Yk/v8iAfrxVLbCiRZwH+1NDTHDpO9Mn4ccfl1e2kevlLXr8y?=
 =?us-ascii?Q?CPWY7sjTx5yflLV71Q4wxhfufXrcI0QRlYhssx3WvCa4WL5LkOC6KMTJERqk?=
 =?us-ascii?Q?ntxTRksPYOvxuUQi9O5nhtMzGENIzUeDgRp+3qo1Z8a/2cIxR0bfz5JNO1qx?=
 =?us-ascii?Q?6e4uiKm4ADZB3hOQBbVbLkpxKqcbURzPqMKSy+4NIX4sYIbT7L+hzcJ9CfmE?=
 =?us-ascii?Q?HJIqQ4dBlDQU0m9c/DwXTXslvYKKlGCun6wvOuTE2LZUDr2BJL2bwqXeyKPe?=
 =?us-ascii?Q?t2VJe3dCKBhN/5/gHh+425tVdXVk46mt0w085OB6Qw1oyonqS9e/n5DSibrs?=
 =?us-ascii?Q?+nJkQCnAdn4u3g3IvNh6eLDahdct9kZzftVL9mW7KvKWH+siaXEK2jDW8viZ?=
 =?us-ascii?Q?yU9/kAKTUkc28HQS52YdXuwiBFwSGVR8CiRt++vORRFIEF80RZ7DFcMiNtkk?=
 =?us-ascii?Q?fwS1FRfSv17zI1EJvkUcOQBpZbIinoRGNHcLK6HMKMxaqkLZSp0HgXlcYlhW?=
 =?us-ascii?Q?2g=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	g67IYPRIYRaca+ruc1u2fKjqhuBxHfifufLvaNOqe8FT+OhL9YfH1F3xZ/kUxUGLiqN2/BFL1bCK9z4xmKyhqxYhi95v2paBaU9USz5TJajtOXAU1Jv99fyGL+y2Q3TQzoJadD71wRIgLKrQKqRJx67/4FodJpTqBHsW2Vy137jBqzMYN6+GpuUT0/aM3eBIq2sJRSo/Ge3O1TtUKNLeZ01hhh489TrmEC/E+XrB+IRWg4XCkfMmw/BWR8QAh45sRf4IFYZWOTFp6I3xs+9bS1E62ZYWKaz/QlvGtusj2CuiE1Gbf+pQCDUaFhqr2HaS87F0uVVECFm5SgzipYTCKRDwHH3nCXqxaRZTmhqPmvoOSMIf0rrx533vQzFoRbo8r0HXH9FKryhPk+a5gdpmP1CIWs691s+FI/FemF+9IVAj8Zlehqo9eV7W3QlJJa1rjqxZmWddDTwiGNuO6/nL2Tt10JNMSc6zBxlZLpaRDXw7VfobyimTesqhW4jXpqo2k2ZAVypOtWvTmYzWX0yUN7Tl28wPSCpmr2fH5qFpJueWg0oy/6m5rRE1Y05YKdqGMGAjWJx1zKig9pAuWu/caHV7D+gRfdQpGnXxEsX9aAg=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2a0274da-efbe-435a-4886-08ddcb558488
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Jul 2025 08:30:31.3221
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: j56cdTZs4aHeLrZVyqA0PeebVFWeH3q4nYQslojQIJSo2brBnEiOnHLxQ54OEuRRGF6pZHvyuqaz+qnYVhq48izooh1l1P0U8wVbwDsXZi8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB6422
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-07-25_02,2025-07-24_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 adultscore=0 bulkscore=0
 suspectscore=0 mlxscore=0 phishscore=0 mlxlogscore=981 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2505160000
 definitions=main-2507250071
X-Proofpoint-ORIG-GUID: RT3vwfHGKGLsY7ssBUXHaocLyGfjoLTG
X-Proofpoint-GUID: RT3vwfHGKGLsY7ssBUXHaocLyGfjoLTG
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNzI1MDA3MCBTYWx0ZWRfXytKy/q32w1+0
 E08qxA+jqsvoERIPD6YVHOp8pMG1fJ3VGY1DWlGfJcIyGv4ph7N3rrdYvTKVRsS6fwsC+mbD0YQ
 wBDvr2LTPmgw0EvKxkXEKVDo2kpAnPwbU6kT7YQxzz8RO46/08cKeoFiutV6F00YfVZoqJup+mn
 n+Rw/MmnNIpRsHRk59aEXH4wC0FdGXqkqT0D8XTtwpGLHd+WX7+CQog0+ch1APpld8zODGEaw3k
 NioVstGbY5g8+BZKHR6omcrneFDVu5HO1NqApO818zTWEH4AHowuIo2PD7XQVtCJk57NEDaaojo
 JZdvGHpIYTxXeaRhn1LgiCyZv3Hzmf3SN0z9qH87P4dB2PRllB0rtQs6TSGgkAVu8FdGRG625nk
 ov3oknulgynzGC/VvSCy6yF4qaqN7XvRQty4+TCA3laapGnXFLswBMxqqXXS1m1+0O5s9CI4
X-Authority-Analysis: v=2.4 cv=Jt7xrN4C c=1 sm=1 tr=0 ts=688340ab b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19
 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19
 a=xqWC_Br6kY4A:10 a=Wb1JkmetP80A:10 a=GoEa3M9JfhUA:10 a=yPCof4ZbAAAA:8
 a=20KFwNOVAAAA:8 a=cm27Pg_UAAAA:8 a=ZfV5uqM9ac08Jx8ArasA:9 cc=ntf
 awl=host:12061
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 31F82140005
X-Stat-Signature: upy1mg8qsbjxz5wbq7p5phamdmg5ww5q
X-HE-Tag: 1753432240-874282
X-HE-Meta: U2FsdGVkX1/OZu7OhUwFtgpq+Ng1dkMGWnD9omXcTaRk66Ieb+ZOjc1o3kjympIgU/JsEpK+8DXOe9NrNV/Y9uSzNjhtf6elfFXBLOZNylzMUG369IUXsJqdj/D/G3TbWpzEuhO/ENukHA79ZkIM3fFZP0E4XtIYWQN91kexaFgQNahvVqcuxXQrbHEVz+JS4ILY5QDfXk+ez0DeYXKkVUKh1MGa57B/3fGUt0zya2rTO+17t6wZBhRwm1BOWbnuWIqSZn7dvVaM5lVxnhumWKIp0k9iCw11IWVxdpEd1DG/DYdwtmYgnra3FqUphTW6A4be6V+jRHJwaAGnGva2mxF283f+eR3PI9FwVxQpDHupXl1BKe+ijBU+ufy2bwUo3H5tPv8HbvN2MiSDuszeLrsC8//2fFSiYmCNRGnU1kLPLhTjBKfVJM+X3BTfXdv18bQnULqm9c17uHBp26vUtYNgh4CvH18FCSSF6S6wcMS9UNFTXNC08Gur6E0Ih2V3u531+NSH5tU+EFrGK0qlYjuagTzFiPakfaMem0xmKl6ABkDM4M3fRTDYqWUEPRZGO3/doQYZO+uJ3IjX0t3E/Z6QYuOZkslr/ow0bXYcFsyCUaopN9l5fh0ir/jkxqPMCblMjifnCQSuax39X/fIFQ8iuqKreFASx9Db9gZF/bEUV/GBn4wkoSiGr6UC7F5kmYNI6qn9bAyEkwl10a7ckrdFVvm5K8dMyABpYqrlomUeHKA2bGbg9UceYW6SOyw3KOyf2ineEvYDiLT8JUByaOG1iugFKtcys5QV1/W5nBFzADNg1T96H82R2GZiKGFawlPXHj0xLHHopPMha4FQMo4yLyiKwNNEF7VHophj1K7fz6VgbqcROhRhHtylI7wkJTRFB7u7jQ6UsrkA+t9fOyClU0b4epY8S/LIlh6/3KjdX6605E1f0ZoIzYZidLsA06C1b2YJ0nqf52QBgPg
 TIjSXWXX
 Ybs1NKoiD1bf8o29EyhNiE2nFny5oPRPD48g1aqs+NHAL5VMd2CvwfzKn0abgvtp8hh3QQt20cRop8LPpTW8PVuVqugAw3ecoZjmJ96aSKCGPOfxI5QiQGaFoAVKXiMeVtI8CKqDyLfQUk2525BMpEtJ3/4jmoV7eUNqzKMpo4GhPHMw6P3GO3Jg7Cw7h6js8rII/ZleLj+7Gqc/s8rEkuFTrBRNqfchHxkKis4egFQDnVf1SPBNCt1En2WNEIMVIoWHCKKeSerp5eTwrMzosYHJIPOY2TBLfTGL4SeE18WPMqYo9lPzmuWRpcM/lx4oDjMDUz5ZXoTObbQGInB0J6fzR8380TyQENdVCP1cBWbR89DYnfVfh+ZyEaTYla8igECMPXGlqzF4U+q+sMNGRLsU6ek+cC5GqfQiQM2GWZsTch0mqd8Q9qV7TcKpDzDZMruJanIxsDrZo/TuHf0Z4qmOMD1ROppgNSwcVSQEfgu1SqnUaiZVIkgCQ+Uw/VkggObhHYX2g5F32sfQhRMcf4JjVdr3l/MMEBhMVDjD3HRz3FBF5R0dLiTcV0vtsdN/eVwOHospvxucNuZiyivg0lV5OP/ovfGXnqSXO4h4hzGu7095jVAatWM25/ieGwHa639cYhuTjEJOGs2o8uXHkNA+9pKZd2DzaLgyCpplxlHpA/v5prwLTMymrxtpchsZSVP5DdzF7cAyz1ds4sE6okjKmMcYAOqillQvFdxQMLF0/Rq1VD5X8tzXF5v9UFtzc+vnGYPyXEy63KYgOVB+GZUMPSA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The logic can be simplified - firstly by renaming the inconsistently named
apply_mm_seal() to mseal_apply().

We then wrap mseal_fixup() into the main loop as the logic is simple
enough to not require it, equally it isn't a hugely pleasant pattern in
mprotect() etc.  so it's not something we want to perpetuate.

We eliminate the need for invoking vma_iter_end() on each loop by directly
determining if the VMA was merged - the only thing we need concern
ourselves with is whether the start/end of the (gapless) range are offset
into VMAs.

This refactoring also avoids the rather horrid 'pass pointer to prev
around' pattern used in mprotect() et al.

No functional change intended.

Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Reviewed-by: Pedro Falcato <pfalcato@suse.de>
Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Acked-by: David Hildenbrand <david@redhat.com>
Acked-by: Jeff Xu <jeffxu@chromium.org>
---
 mm/mseal.c | 67 ++++++++++++++++--------------------------------------
 1 file changed, 20 insertions(+), 47 deletions(-)

diff --git a/mm/mseal.c b/mm/mseal.c
index 1059322add34..3df9581ec828 100644
--- a/mm/mseal.c
+++ b/mm/mseal.c
@@ -15,28 +15,6 @@
 #include <linux/sched.h>
 #include "internal.h"
 
-static int mseal_fixup(struct vma_iterator *vmi, struct vm_area_struct *vma,
-		struct vm_area_struct **prev, unsigned long start,
-		unsigned long end, vm_flags_t newflags)
-{
-	int ret = 0;
-	vm_flags_t oldflags = vma->vm_flags;
-
-	if (newflags == oldflags)
-		goto out;
-
-	vma = vma_modify_flags(vmi, *prev, vma, start, end, newflags);
-	if (IS_ERR(vma)) {
-		ret = PTR_ERR(vma);
-		goto out;
-	}
-
-	vm_flags_set(vma, VM_SEALED);
-out:
-	*prev = vma;
-	return ret;
-}
-
 /*
  * Does the [start, end) range contain any unmapped memory?
  *
@@ -62,38 +40,33 @@ static bool range_contains_unmapped(struct mm_struct *mm,
 	return prev_end < end;
 }
 
-/*
- * Apply sealing.
- */
-static int apply_mm_seal(unsigned long start, unsigned long end)
+static int mseal_apply(struct mm_struct *mm,
+		unsigned long start, unsigned long end)
 {
-	unsigned long nstart;
 	struct vm_area_struct *vma, *prev;
-	VMA_ITERATOR(vmi, current->mm, start);
+	unsigned long curr_start = start;
+	VMA_ITERATOR(vmi, mm, start);
 
+	/* We know there are no gaps so this will be non-NULL. */
 	vma = vma_iter_load(&vmi);
-	/*
-	 * Note: check_mm_seal should already checked ENOMEM case.
-	 * so vma should not be null, same for the other ENOMEM cases.
-	 */
 	prev = vma_prev(&vmi);
 	if (start > vma->vm_start)
 		prev = vma;
 
-	nstart = start;
 	for_each_vma_range(vmi, vma, end) {
-		int error;
-		unsigned long tmp;
-		vm_flags_t newflags;
-
-		newflags = vma->vm_flags | VM_SEALED;
-		tmp = vma->vm_end;
-		if (tmp > end)
-			tmp = end;
-		error = mseal_fixup(&vmi, vma, &prev, nstart, tmp, newflags);
-		if (error)
-			return error;
-		nstart = vma_iter_end(&vmi);
+		unsigned long curr_end = MIN(vma->vm_end, end);
+
+		if (!(vma->vm_flags & VM_SEALED)) {
+			vma = vma_modify_flags(&vmi, prev, vma,
+					curr_start, curr_end,
+					vma->vm_flags | VM_SEALED);
+			if (IS_ERR(vma))
+				return PTR_ERR(vma);
+			vm_flags_set(vma, VM_SEALED);
+		}
+
+		prev = vma;
+		curr_start = curr_end;
 	}
 
 	return 0;
@@ -192,10 +165,10 @@ int do_mseal(unsigned long start, size_t len_in, unsigned long flags)
 	 * reaching the max supported VMAs, however, those cases shall
 	 * be rare.
 	 */
-	ret = apply_mm_seal(start, end);
+	ret = mseal_apply(mm, start, end);
 
 out:
-	mmap_write_unlock(current->mm);
+	mmap_write_unlock(mm);
 	return ret;
 }
 
-- 
2.50.1


