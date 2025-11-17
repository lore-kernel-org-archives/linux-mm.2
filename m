Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9256ACEACEF
	for <linux-mm@archiver.kernel.org>; Mon, 17 Nov 2025 03:40:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7E5318E0040; Sun, 16 Nov 2025 22:40:36 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7956E8E0002; Sun, 16 Nov 2025 22:40:36 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 635CC8E0040; Sun, 16 Nov 2025 22:40:36 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4552A8E0002
	for <linux-mm@kvack.org>; Sun, 16 Nov 2025 22:40:36 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id DE27E140BC8
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 03:40:35 +0000 (UTC)
X-FDA: 84118696830.03.897F06D
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf18.hostedemail.com (Postfix) with ESMTP id 621591C000D
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 03:40:32 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=QRlG7rPS;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=CMOF+kol;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf18.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1763350832; a=rsa-sha256;
	cv=pass;
	b=mV/JcNDgukm7a4mntB9vZeY9sY7CPG7X/Z2/DZ606dBhoq1Z+VBkfjutUmglOoW/YubcR3
	oBVYC71iQpE5sSLQZmy7tlICYoCicIEe9q51MMeQKjcTAUytMQw8TNQAUi5gOA1c60h/bI
	ivdN9vrVg+VulxsPV6pwSRw+YTaPSdI=
ARC-Authentication-Results: i=2;
	imf18.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=QRlG7rPS;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=CMOF+kol;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf18.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763350832;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HR8Pm3hOq6WwZpQPVrVZwhvr9qtyeaFqEA6bnS5o99A=;
	b=TpzWBB1Bp+Kb6A3eA+Ur/w8CwCXbHREjf2SiKntUPlFccMIzwU5jxjGeDg/hkCGHioNmsD
	1p4V+Y/dzfzbqwTTPrOIO4FdykHgmcM4UnV+5LrG1EHCxaGagF0nXoWMA/Nvynapvtrvhy
	EILi8CrVSXNlgrjRIe/dFmM31E8qYDo=
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5AH1vCCk003635;
	Mon, 17 Nov 2025 03:40:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=HR8Pm3hOq6WwZpQPVr
	VZwhvr9qtyeaFqEA6bnS5o99A=; b=QRlG7rPSWABGm1hf+CdPz6vcPa+idtnxWp
	5mvho5drjQ51vnpolOSlX47wjRrpLi6pr3odCeCXhAhAU7h9XgoNkPKQDMe6ougB
	mK0EtxwfHRaReDQjfZEnNZfw1JG+i3zkibh2lTaLKj6wCOyemyS8F5AH/15ehvBF
	+J+dr1M5sbjDRZY4ehLdbc9ku5s/lHHN9zFipr+rxywCBJ4lxsfOqhQITmR0/NUX
	1ddetPiEXe5nI+teivvywCI+6HSpo3LXSlYnV00OD3jdA7YIQRTvOTyKsrsaP7Mj
	UHCArrvQh+mfd9DDYvye00BljjMkIth1hQDaSb9J22y5GvNv0bXw==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4aejbuhjdd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 17 Nov 2025 03:40:17 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5AGMukbu004341;
	Mon, 17 Nov 2025 03:40:16 GMT
Received: from sj2pr03cu001.outbound.protection.outlook.com (mail-westusazon11012024.outbound.protection.outlook.com [52.101.43.24])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4aefy6v51n-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 17 Nov 2025 03:40:16 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=B0HbZ5P7soUqBpd2eGpgH+FhXMxloS4i7sTqTVFxwk1NsQYf0trbsKgvVL7HDEXG1EBtxcTDalEdATK/b3gowksE1rBA0bfTaS6kRgG+xXoMEzwCjg7rXd3DDidWH145z9XCFr92gYPi7NunRcoESuhbUceCooLUZjOBkD3onXt+FHvSvKH8FyMiLQEihMClEGBXqvyRgxox5QnKRcAB5r52t9iOr7V+zBfwpYLs7JJOeLzh7c8neqqpC4RvjIsQhm2feZRaiDAtwmhMD0r2eJ4IANE0nnNU/PuApzthzEGT7S/498Hph8rv35z+2JPCfRI+TsH/E7o4LMaw2ZGTEA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HR8Pm3hOq6WwZpQPVrVZwhvr9qtyeaFqEA6bnS5o99A=;
 b=UBUdVc5LrqGTjKDGsdAK+K9QB0TrKQWlA7oFjamLAJWdLhLDUDtmD7cfA/PuXz+YTEXaRa0iiP2J8ENIedVt/QoXE85N+hLhXGZp2Yn8KBjuETnSmSTd6kYLNLRs68UG6SJs0m00mekyFrsMFDEW6P/8qYnvAZ0YjtVFNbMgc1DCrJVFXA852C9arBQW6sQRFEgahkeQoUbTM1CF7m9CMMBo1EyQ0RxQEw1Rncd4AfsAsYXX7cdBbrDhF3cxW8b1YLeiHVWSfsqMMcgvWwij0xBDcUDFjoszyjUPxsd2LwEP7UVa1YjVPtiVpnS2FolqEG9vCtVNGAqtB2Ut534wrg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HR8Pm3hOq6WwZpQPVrVZwhvr9qtyeaFqEA6bnS5o99A=;
 b=CMOF+kolOlD4g0a3EXfsjJinUgiZGgtvnfy3YVu4j2pi7c+z/jIgSurTi8t020DRzzFcNaJUl+GflDrm8Wha7hNlnA2/tlJXRf1rlmHzoTpLFhPBcvWxhtxevP71Jk6AiYfi+7Zci4f5HimP8Ojl4NgL1KU9c4FNIVMBK5SmhIo=
Received: from DS0PR10MB7341.namprd10.prod.outlook.com (2603:10b6:8:f8::22) by
 PH0PR10MB5579.namprd10.prod.outlook.com (2603:10b6:510:f2::18) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9320.19; Mon, 17 Nov 2025 03:40:14 +0000
Received: from DS0PR10MB7341.namprd10.prod.outlook.com
 ([fe80::3d6b:a1ef:44c3:a935]) by DS0PR10MB7341.namprd10.prod.outlook.com
 ([fe80::3d6b:a1ef:44c3:a935%5]) with mapi id 15.20.9320.018; Mon, 17 Nov 2025
 03:40:13 +0000
Date: Mon, 17 Nov 2025 12:39:46 +0900
From: Harry Yoo <harry.yoo@oracle.com>
To: Zi Yan <ziy@nvidia.com>
Cc: Matthew Wilcox <willy@infradead.org>, Jiaqi Yan <jiaqiyan@google.com>,
        nao.horiguchi@gmail.com, linmiaohe@huawei.com, david@redhat.com,
        lorenzo.stoakes@oracle.com, william.roche@oracle.com,
        tony.luck@intel.com, wangkefeng.wang@huawei.com, jane.chu@oracle.com,
        akpm@linux-foundation.org, osalvador@suse.de, muchun.song@linux.dev,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, Vlastimil Babka <vbabka@suse.cz>,
        Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
        Brendan Jackman <jackmanb@google.com>,
        Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH v1 1/2] mm/huge_memory: introduce
 uniform_split_unmapped_folio_to_zero_order
Message-ID: <aRqZApBuzxzo9rF9@hyeyoo>
References: <20251116014721.1561456-1-jiaqiyan@google.com>
 <20251116014721.1561456-2-jiaqiyan@google.com>
 <aRm6shtKizyrq_TA@casper.infradead.org>
 <aRqTLmJBuvBcLYMx@hyeyoo>
 <4C3B115F-5559-430A-A240-A6A291819818@nvidia.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C3B115F-5559-430A-A240-A6A291819818@nvidia.com>
X-ClientProxiedBy: SE2P216CA0139.KORP216.PROD.OUTLOOK.COM
 (2603:1096:101:2c8::11) To CH3PR10MB7329.namprd10.prod.outlook.com
 (2603:10b6:610:12c::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR10MB7341:EE_|PH0PR10MB5579:EE_
X-MS-Office365-Filtering-Correlation-Id: 53fe9e74-ce74-48cc-f58b-08de258afa9a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?PkHT+JjPdKaZAL9Xnk4Ta/CEn4+QdCCO1lORndkKURmKu/or58xg2ipgLf2B?=
 =?us-ascii?Q?Fti9t5pZPe6OwBEjRwH5L9o0uSWWQjeiPvUhpeUJstKkgiC+DsPeZTWh3+5b?=
 =?us-ascii?Q?NMmVf5R8f5/F28+cmIRKQY1AulOdu5PJdjulMZZlw0eBbjlpYRTBk4Flu413?=
 =?us-ascii?Q?kNhBwB1yUSTJjQT/K7pLV/KefO+59R9dNrfwseoRsRvrnY4oM1BeDrC2LFr8?=
 =?us-ascii?Q?Ceq0PKRsrIhGZ5JE4xBfMWl6VZK5TJOvH44iglxyWZ5dwq4C7kLoemseoUbw?=
 =?us-ascii?Q?Prdg8YltWtDA4FrfY0oiTx9d/a3hIozuETq+VEflwZbQJ6AV0bawGCbgb8Ji?=
 =?us-ascii?Q?fkgFngt70QNq+c+tzrb8Gc1RXEzqoMXO8037J8qanR9eyeJJCoCelIENVP2n?=
 =?us-ascii?Q?4GNynU5KDC9b9iLtGhBC8iDJpDOEhoZMVYPXe4mZ/w4xFlFxcQl/UlKJlZmV?=
 =?us-ascii?Q?KknwjtLprRdtyIEXrGCDOqOcU1pcz4I9D2MNXTt2BOnhwvD93peKvrN/moqw?=
 =?us-ascii?Q?ofTuGYz6nLqfX/Er7Hf2HOxtk1xbR/AYjJq9tBi9d/1yaVEE0g4XJU/r7GGu?=
 =?us-ascii?Q?cMte2MdImy7oxUoIn5apZpDo+SJVJ4kDHswe5E1Ios3V1uZWrpRXjDw+Kz5K?=
 =?us-ascii?Q?kgOMgYRGMjqAaj8w7OB2qC8Wi3wthoJYBdVkzuexdCg1mVbTPPn1G7Z3qKQi?=
 =?us-ascii?Q?AX2RC+ZBG9zWtxYj4qqScxQEnOepILEjG2+M1XXY0fXbVJ7uy5Cfo4mYEsyH?=
 =?us-ascii?Q?0EC0lUtlWg3ZK2nuoWpaP2uAuHk+lzEKsLsw3R1r5Pcz/xTghWUJUF+ot3qR?=
 =?us-ascii?Q?tV+bOdMENvDDsWONiqupplHmx84QKQz63tB40NM7OaLOiRsQdVTcUGRHh+Ob?=
 =?us-ascii?Q?ZnQEJuplH+O5EtRpEZKwrXE1KwrrVCj16VRKH7YDpZmJTlj2J+JBaFFeEDuz?=
 =?us-ascii?Q?2Js/083zmUXjW3Vg5c4lPIibWc2Up5IphZ4YIYV5DYQ1PgjUWPd7cI0497OJ?=
 =?us-ascii?Q?fVPmyT2fQuY+5W2CAvn7I2bLZ+jJNU2Wu8hNABDh9X9aH/2DQWTyvdJ76lki?=
 =?us-ascii?Q?6bb58/6RM1XaFbSbSOlQW9cHRsFkl3xW+5t45wF7KrarPUbx7BQ+IaTGv3nh?=
 =?us-ascii?Q?dRH4a7lD+/k5CENhwgLmNI/8910SM7Nva4zG4tc2xq9wXcJqXkWWb8+weGAL?=
 =?us-ascii?Q?vowj6n1Mv6P1YWsDgfv3U1OadaKupEwSg05Q5Jx7qAfF2pnodim3UC9L7/D+?=
 =?us-ascii?Q?DuifHrD+IuQv4Cv8IIeNO4EKYfwsOcH7nUaOiJtKpvKyUXswvvxA2cTcpWeT?=
 =?us-ascii?Q?afV2UKKa5ipyDUyOs6n1ta6G6jfnXF7I+sHtaNKkLIu66+Br7i+Crvpu+C50?=
 =?us-ascii?Q?gVOTC8eWoCxw/xgC0TsA7oZ29Qd38M3ISDx2ne392h4hP5ugpCcw+CTm9fxw?=
 =?us-ascii?Q?Uovylrw4ibTfYT6T/ZWCzYaJM7uni+Vd?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR10MB7341.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?GN2DSSP1Ox5MaxO42Wdhayta57EfAv8IqXtScrcNng5MBto+dUw48LyvuP99?=
 =?us-ascii?Q?zqZwTUXdUxTDIfLkHuN+E2CrHfs+tw7Y53O/JiWRQ4DGkqssJhkxsQ8Jirjr?=
 =?us-ascii?Q?DWdw/ZKLOKO9SPPTO9yvHco+TsuCq7MhobuEL0hSbX/WyLqW9Fmv8q0r6GWl?=
 =?us-ascii?Q?DGYu86MebtPcPzTWj4NjBUfEZoQBvXDjzlzvV+Z45c+L4AQTgkYKAZaJq33m?=
 =?us-ascii?Q?PYYERh8PyiLFREf0jKyQk8bj0POo59U3vMDN00DI8qtXWh1hnUE4j+Rxwv9j?=
 =?us-ascii?Q?+bMiIcoCYYR5GDz/5my25KGB3kAdkBTInFCEl8LvMrqi9PsPM5mk9aazDVw4?=
 =?us-ascii?Q?I4ebE3TbxdRsi5bsBtFfghGHphEVMFnuaAIzvUcu35xIOL17aUUklfKzJw+m?=
 =?us-ascii?Q?tnkcKNUr+gscns3NxcANeUVwZG1hacQ0V9HRrYgaRDgG8beyIkuiZhOnMNeT?=
 =?us-ascii?Q?aSZuNKOoFy6OAT8IiDtvwUY5oIhJQe31t+bmlGGmkF5a67uZY6uJdRW+LnyC?=
 =?us-ascii?Q?RFNR8J3fKv9Fxe4PMwtd+YTk+LoW2bCaBoORvLr0ZWoFr9Etr2QSZqUi8Ej2?=
 =?us-ascii?Q?9YHSEPY9iQFopXRxEpOKjKeUWDpquKiqZcIjby/Hf1oqPsk/xCSmpIm7MWi1?=
 =?us-ascii?Q?I1neiERHdYI+mprixJSJmQMn6W8Tj+Q7ATn+kXIk3YAYymeJe376I4M4vNtS?=
 =?us-ascii?Q?26u+CvANOGOAR2V0+foVSL5IZsXZvBNBFaGHrU1wzX8NfRMr6gQ0lKyJ+8kV?=
 =?us-ascii?Q?t8W/7mGcdPnmE5tM8e2DDjPISfeaJhTmAN5qRKfQh/hz9xjsTwdds6ygkM7Q?=
 =?us-ascii?Q?W8mbdVvhxh/6PXT200h7rRZK3R3P2/eBrWuxE+1/ftlmlKgn7a6vLkeOHT/h?=
 =?us-ascii?Q?w9CkugZO5wU2YyrQ5dOAomkr9YwLvED4pujbz+a6fap6S8f1h0Ve645NIHs+?=
 =?us-ascii?Q?sb50g3SpKRPBn7mAATECMTPSvoEhh4rcqAgsC4OxwH5dPT1aeDx9qmdysY3g?=
 =?us-ascii?Q?dJu0E7zglndI3ETEnt4Tz4uUiYULHI1yoTpepFIwVlq/6RrzpiwSa9msepR0?=
 =?us-ascii?Q?8LT8LNBs3/btgY9OADU0iL3TuvYxMX/GkfgCaWs5nH5wvun3qUpITENT27Pd?=
 =?us-ascii?Q?JKqi8IzUgzBVW+59XkU3SCpphR91ACHMxpUNNnWMz+lf2WKxVqdVdIjbge1a?=
 =?us-ascii?Q?XtF9mTODle17yfDLDvi2FxL7//8aBRv9moYdOp1nwTHZ7TluiFyadSaNpb10?=
 =?us-ascii?Q?8hihE+W6V+GFbXrNgDs4+yg1UcbuoI33w+k/VR5pi5r37kslQQWFfSa3OUT1?=
 =?us-ascii?Q?/RjctOjT++HEVa+mTpd5EeMln75zolfPAmUpFho7nrmMnov6DG02JpRcDwB8?=
 =?us-ascii?Q?Mye5769K8sis5TKqmvi2oa3R/0I4JLhXB65FDLRYImJaCHA4ZVcLSxfxrrUb?=
 =?us-ascii?Q?pigk4AxlTI1w4vlM9yTGQ52H+O89YgjcjI4OSrAwusBtK04F83H27Hty6f+x?=
 =?us-ascii?Q?qgb943wl6Xr29ZObCRaq3aWaat5Elt6YmgmSJAGmnCIvBNDN3PvIejASQWjp?=
 =?us-ascii?Q?6aZx/Y3ndnah/IrKLRiGq5bpLg1SoeO6Ha37+N63?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	pTmWTsk6j2yO9H+pYOgIFeK3gBXpvvC9Q7epZFiiYQ5KB6La5UfZFVIted1/aFkehZ3OfqpqEcn0hLZOrR0UkTcW695VeQ5vh7UI1eOeDFNQSsTRqzouJW6jGzWHO8VLvCCJpjKLnCurm2sje+VbyNTrByHPKE8Gf8En4riVL2qeHiuPOzu5RJGDrAyxF3KpMM2NW0GJWxnLRme4z9MVJcurGl6RQq1jcgxjHRe4o217VCuBWjLw8Icd25HgD5jR8egTP+EKt/7K8h/SW9VNzCfZzmj3BFbWWg/HW2syKirGGEyTuCrM6vxk1R3OACyhXhfl9MquRiaBlA9rRZfKPvjI+FFh5fBJ4IFufdcw1ZoauLUW7KyBxJO7bpzIeCTsdnSOkhFhz3EUK3/VGdy6k3uphHlYdQvjhNAK3uI1aS3/OAAAbtZlESzyKIkUCBVsaHQdBcDX7H8ClpS8lJzlWIpEEkkR5NdOoHge50NC7iR22FaPLIjvljYrajwwejWqQOf1+CIsCFiaL65wX69SKRRfGQFiBzf6pE/ea+mkE0A09Sg9Bh+Cs1GwbAcRjhdQEvZTkT2LtEJqmwOmBue8cPsYbP05HJmsfYCJgNrNlig=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 53fe9e74-ce74-48cc-f58b-08de258afa9a
X-MS-Exchange-CrossTenant-AuthSource: CH3PR10MB7329.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Nov 2025 03:40:13.8466
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tX3Ccly26uLDO0rOC1PtWPKhKw8HnH8SxODn6PeFmi93T7z2eMpRTmzVjFCGs3NtHNfz1jDgh/GP2gQ64UnwxA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5579
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-17_01,2025-11-13_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=999
 suspectscore=0 malwarescore=0 mlxscore=0 bulkscore=0 phishscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2510240000 definitions=main-2511170029
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTE1MDAzMiBTYWx0ZWRfX71dcaIRdfabm
 J5mEw92gqFmra2YouUOH880Z9x4B4lkYCyJ96s4Q+/Q2HPF0XdmTepqX7ipiwnzIXMW3aO54W51
 FQv7E3tpRrI6Ixl3z7zTU7m+4lN5jFKNuTX/virsk5sjZB1fWOJCkLvTKv+aRB9wEMtwddkNjz3
 NlSsq54IVEZI6+pA9J+g19Kso8Zj0Y9gRoAXS8KVZNWVEuAtsscU1i+IcKznFM9YmyshKEAIT+f
 P5l9GnlNSR7jURRT0ddEYFDUyyW/8gHtBj6BisyS34KJv28wVGPeFhKE2n9qzlcaHTXqpDVJQn5
 ZpRhlo+deXg1ZMBQNW0ygyXG8myQOy9QBkRGC+6JwJWnOMJhokt3mRkhuY/F+eblhLHZNv2xn7O
 MGZieuLf1stNFombUpW5vubEczhEAA==
X-Proofpoint-GUID: U9I_DmfloSaPfzWueBAisIiwU6X518Wt
X-Proofpoint-ORIG-GUID: U9I_DmfloSaPfzWueBAisIiwU6X518Wt
X-Authority-Analysis: v=2.4 cv=Rdydyltv c=1 sm=1 tr=0 ts=691a9921 cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=6UeiqGixMTsA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=XCkL_OM5tw57guKWEfYA:9 a=CjuIK1q_8ugA:10 a=cPQSjfK2_nFv0Q5t_7PE:22
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 621591C000D
X-Stat-Signature: jwwzj4d1txyb3i6khxysmqckzx6h3tc6
X-HE-Tag: 1763350832-125842
X-HE-Meta: U2FsdGVkX1/sRRnmCVKWS+JuAskl7tIcj82MA8T9pvJn740BpOkusWjBOC/nKxkYTPZGxDgdTKXiwWIVXo/5bY1y0i0N1q5jK7GvyrHuaGLJOoWbmC16zmC+48A2x7+eOvsdgq+NURsxs5HWp7DopzIwzopIDlHAF57T0bUvWhSy7mbKsBgC/dIApUjTtPtamITzjOztsGCBqVyM+QuHEx3I3qZe0JavA123ZhwkOB4LqEj49jUpVyre1QDUGfgvrdUbdxmxtk+GFetDD/IQO+5MS9oXRt7HlTN3NM0D+NXEeM1FqArzPKB/szEEU25iuYgUlxXSfYO6iSCXE26QnVNuUdn2BsHpcr5SzZ2QfTFpINcNoYyEjUuHyRKukoua1mstW3lwTA+8PHsjiN+KaR0RW5WV6KW45xCoSMk94mP+k2WIE+M1NMu7+M92YzFxMxrjulloWhitSA6Oas7CsYkRlE3bLiBrIQ8FguZAUdE0z/Ytx2Hn6O5s9cDdJ1U4CK2zQiVWQQoaUn40nq7QTEzfIZEHY37Gxm0w583ceU903jvPSCUIvj0fsdAas2TWcMP8QZ+Bfjv0zEjJ9GZ2IXXYCM6jlbLCRriOy9mjAXtuXD0mXPC4fdydDHvLSf6jf1jjBf/Z0+I9WzDcjVRKo5n3SXJPkmPXcAvs/mlL/0qz8hFZJmgaNXROXj5vmALLbPyX30uAP5iVNA2xEURHgIdrjx+DWkK4ZjUyKjrUqGWwHyKQ1L4NoCrzj//6fbj5pqizdws4vB/VxFE/NtOa+AYqoT725UbcHQJ4Ka0Lo4D9esOc32n/TnbLi4i8Ws7Mk7XR8bg2ZgpD0GK2yBb8p1tSag6RgVKa8T+ZwcM3Ao8gPzCPOo6bN1ddLtIx1gqrJ8IeoQ+erb8N2TkObz+nIkIR56S8JenXGOlw6y8PcZG705jnFHEqg7HzrEpxPBBjy/T+WFMSNHJj8z04Y4U
 g5d94yJ8
 BMDjBdOVpzXwR/Vnq8aoPG+hAmSFLO4Hpx0D7jZm1WK7BR82DB60qB+j8VH/an6K/peT6sH2AOs4R11CLalIzDP6EUL6GRaLeGnSGIubTVKrC6CYNJU7ZChwpX/b0OJThqw61JbLbHPUkqYk9i6HT6/d0gPufNltlpt6Ggw7ok23dvzbQf3jrqR1IoHVsMcuRHUw9yCQnVmwED5uGxwq3UFpN99CkNB0D4uTvvF5QBEKSTpJkY3LPnm03+sc4GWV+L4UVH2kztKKGXgktJHXWA8Ko0ijHX2fHiPvxYa87sT0Q6OsGQcc0lh861NcVtXz2Er0pGXSPUIhaTpKWdJfSUZezvwuiYUVY61+20npkLF1/4NoV4yNC9Aiui4Rbf4o2eFFDWjUbxKFsm5ZVx7OI9Le/dI4LPS/05gr/cpDLw3o4DXZ3YdAUpDpNLEdUXrKww0jZh2bgGVuZmps+GJt1noVsaIbbpeNoEXno0p/Qwz4ScKN19KxfcfPG6FYGBGtFeH30gHYXEIUlF2G2UI9xPS6Aiqb/CnQM3LRIT3hNbVUkxMt40NKOmfaMe8s5Uv46oRUUmGaSSTl48bYitVq2DsIDw8HyjtQfbKPwG6DxfLaBPgCAmUeD7zuB7wl7YCT7AWbKYlK8Id37oXvCsburlft+1afmibc+UTDBM/XR+UwpUBrLU31NkCG61DjxMOVtAK8T0ir+omr4yHzMHTCrdlP6fMABfBwzZCZet8S0lKLHcb0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Nov 16, 2025 at 10:21:26PM -0500, Zi Yan wrote:
> On 16 Nov 2025, at 22:15, Harry Yoo wrote:
> 
> > On Sun, Nov 16, 2025 at 11:51:14AM +0000, Matthew Wilcox wrote:
> >> On Sun, Nov 16, 2025 at 01:47:20AM +0000, Jiaqi Yan wrote:
> >>> Introduce uniform_split_unmapped_folio_to_zero_order, a wrapper
> >>> to the existing __split_unmapped_folio. Caller can use it to
> >>> uniformly split an unmapped high-order folio into 0-order folios.
> >>
> >> Please don't make this function exist.  I appreciate what you're trying
> >> to do, but let's try to do it differently?
> >>
> >> When we have struct folio separately allocated from struct page,
> >> splitting a folio will mean allocating new struct folios for every
> >> new folio created.  I anticipate an order-0 folio will be about 80 or
> >> 96 bytes.  So if we create 512 * 512 folios in a single go, that'll be
> >> an allocation of 20MB.
> >>
> >> This is why I asked Zi Yan to create the asymmetrical folio split, so we
> >> only end up creating log() of this.  In the case of a single hwpoison page
> >> in an order-18 hugetlb, that'd be 19 allocations totallying 1520 bytes.
> >
> > Oh god, I completely overlooked this aspect when discussing this with Jiaqi.
> > Thanks for raising this concern.
> >
> >> But since we're only doing this on free, we won't need to do folio
> >> allocations at all; we'll just be able to release the good pages to the
> >> page allocator and sequester the hwpoison pages.
> >
> > [+Cc PAGE ALLOCATOR folks]
> >
> > So we need an interface to free only healthy portion of a hwpoison folio.
> >
> > I think a proper approach to this should be to "free a hwpoison folio
> > just like freeing a normal folio via folio_put() or free_frozen_pages(),
> > then the page allocator will add only healthy pages to the freelist and
> > isolate the hwpoison pages". Oherwise we'll end up open coding a lot,
> > which is too fragile.
> 
> Why not use __split_unmaped_folio(folio, /*new_order=*/0,
> 								  /split_at=*/HWPoisoned_page,
> 								  ..., /*uniform_split=*/ false)?
> 
> If there are multiple HWPoisoned pages, just repeat.

Using __split_unmapped_folio() is totally fine. I was just thinking that
maybe we should hide the complexity inside the page allocator if we want
to avoid allocating struct folio at all when handling this.

> > In fact, that can be done by teaching free_pages_prepare() how to handle
> > the case where one or more subpages of a folio are hwpoison pages.
> >
> > How this should be implemented in the page allocator in memdescs world?
> > Hmm, we'll want to do some kind of non-uniform split, without actually
> > splitting the folio but allocating struct buddy?
> >
> > But... for now I think hiding this complexity inside the page allocator
> > is good enough. For now this would just mean splitting a frozen page
> > inside the page allocator (probably non-uniform?). We can later re-implement
> > this to provide better support for memdescs.

-- 
Cheers,
Harry / Hyeonggon

