Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8DECEC83F17
	for <linux-mm@archiver.kernel.org>; Mon, 28 Jul 2025 05:19:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EE81C6B0088; Mon, 28 Jul 2025 01:19:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E71DA6B0089; Mon, 28 Jul 2025 01:19:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CEB4D6B008A; Mon, 28 Jul 2025 01:19:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id B5F126B0088
	for <linux-mm@kvack.org>; Mon, 28 Jul 2025 01:19:54 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 2788480133
	for <linux-mm@kvack.org>; Mon, 28 Jul 2025 05:19:54 +0000 (UTC)
X-FDA: 83712521508.21.E28D04D
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf30.hostedemail.com (Postfix) with ESMTP id 9C5C280006
	for <linux-mm@kvack.org>; Mon, 28 Jul 2025 05:19:50 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=nKy1w83m;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=ch9F9O38;
	spf=pass (imf30.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1753679990; a=rsa-sha256;
	cv=pass;
	b=n+eouChQg8uTD+GQXkM/gHy/0UhtOiR+XcBKUY8FHha1wF3TF1By1worhQVi3Pu790+hOu
	+SQPhpRVP/e2Dt5dVTC1wNk/RHfkpzirg89ZwTmXaRsOfjVeKFTO+/XHABzfT871BlK6GW
	nUHT5qXXNl9x6ifas5iCkHPkXOvxAn8=
ARC-Authentication-Results: i=2;
	imf30.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=nKy1w83m;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=ch9F9O38;
	spf=pass (imf30.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753679990;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=j9/IklV/tDntwa4S1mLAJ84bbT3q+Pbz25/KxlbUuLY=;
	b=uo6G790o+gW+Z5J+4BK4DwdevBi3ue2LC3FVI9il2hjytNCHDopB/Cno8dSGoNkkVDkLiB
	WbSWLlURye3QG/tjDu185VmrlA1qOsR4wUPLsfmqmMzK9SrEQokOajx/Gv3MVdpqxh0FYu
	Y3KRC9XXVd2zz1Xn5ktMh4R4gzkwMf0=
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 56RJhUE4006017;
	Mon, 28 Jul 2025 05:19:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=j9/IklV/tDntwa4S1m
	LAJ84bbT3q+Pbz25/KxlbUuLY=; b=nKy1w83m/ldSnwd4I+5TFeM3CxeS+8qSrJ
	Wo9ZpFkQjfb/Pg7wdyMADw3IWNeiUFOiMQ56R7A+Gu+uhPDigjdrjZSUc5QW+6h+
	zVoezN26Gy5RUph9I2zagzxwf5+pVSTdfzlBK15+O0R+5NiJyDiUrA9sUf5qT+KT
	T0BuCcxZxHvlcW91InkdPoU1cpgUcTYuSLcbBTJYrA/fq9Q0rT4Jg46CU6qQmPNY
	vBl03FEeSsbIp2LfATBV47Ur3LaeBlxVlexHB+iW5AJVv8AUTRgy/1Tr0zZuGr64
	Z008o3pcwi4Ncv5sFKBnGXrOX2Y2qhZsNyLXSM90hOujjUgbCuyw==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 484qjwjc49-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 28 Jul 2025 05:19:44 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 56S3YLh4016708;
	Mon, 28 Jul 2025 05:19:43 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11on2070.outbound.protection.outlook.com [40.107.223.70])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 484nfeaeas-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 28 Jul 2025 05:19:43 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=pP6n5Zh3rL6H6FFbWs9IUG3gh4PNxJkf9gfw1VUdvtvIrs+x6jOBq0nL9iyXzoJZPg7SUM6lg/fcFCKpNxB7XBcMSGbo8q8n/oW1ndLlkyH/1QM8S2BMp2Bcpy2npVZuyxuAkiMpyrbshS3PjowbJYY/2KNOQ3GMCzO08HQPtpYWYNb2Gd9k2fF3/JBSxe/grZX+u5O65c4OcsKeOJgBCnv6l4Uxihce9He5LNqhaGHrsYzkfPk2urdi7HgQAnTf/P9bGm1jmjswC2QKyVvDzkuVCT+c6+DeLLFaZ78DDlKiyCJcsx299lFfaqBdKyEaSgKCKUmvrfUTz3PGA5CApg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=j9/IklV/tDntwa4S1mLAJ84bbT3q+Pbz25/KxlbUuLY=;
 b=YT9LGUkBvTxwAyEmaOK3i/aaurxv0TbohJrPJsVRICvOqeYfK827MGu41FddtmdDq8NZEHwCNEMd5IsH9Z6VzPD/+aQJa6ICMt9AHiB0rHNTFBUrmHBExiyWcCUxo/k4HB42cfEdSeAepnk+YlmY6BuMNwf6ZeAOQIXYUuLsT+z5qSNnx5JmWVPxgXOmgFgZX5lRLiClPyhg/j/yi2f3Xz0/my/I/jmEd1gBXuHLuipQlqXJg+pBiB/rjUpdsIF49LPKr7Q3LrJ1mlwQDakIX26/nekKVgyUU6196p39x+HiolV9rgEag203+ZaYe5SBuEIt/H0SCrA3q74cBdHe/Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=j9/IklV/tDntwa4S1mLAJ84bbT3q+Pbz25/KxlbUuLY=;
 b=ch9F9O38FCJtWyBFu+NlqSkpjOgZHIdz9jzpng0ouSjr8N96aAhgpVhSwU+1sTlsr+lQeMp7uT7+Oa399bgLU2zeGWYMKMToFGREdWKfHw7qpzK7dCz3n93NIb5Iv1oLhveqNG+6zN68vYgm2DnsNTkavVjsuiBh1D/OKh4hsL8=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by CH0PR10MB4908.namprd10.prod.outlook.com (2603:10b6:610:cb::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8964.26; Mon, 28 Jul
 2025 05:19:37 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%5]) with mapi id 15.20.8964.025; Mon, 28 Jul 2025
 05:19:37 +0000
Date: Mon, 28 Jul 2025 06:19:35 +0100
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: SeongJae Park <sj@kernel.org>
Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Hildenbrand <david@redhat.com>, Jann Horn <jannh@google.com>,
        Michal Hocko <mhocko@suse.com>, Mike Rapoport <rppt@kernel.org>,
        Pedro Falcato <pfalcato@suse.de>,
        Suren Baghdasaryan <surenb@google.com>,
        Vlastimil Babka <vbabka@suse.cz>, damon@lists.linux.dev,
        kernel-team@meta.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [RFC v2 5/7] mm/memory: implement MM_CP_DAMON
Message-ID: <804015e3-78f7-47d8-b887-434f0f7edf8a@lucifer.local>
References: <20250727201813.53858-1-sj@kernel.org>
 <20250727201813.53858-6-sj@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250727201813.53858-6-sj@kernel.org>
X-ClientProxiedBy: MM0P280CA0012.SWEP280.PROD.OUTLOOK.COM
 (2603:10a6:190:a::31) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|CH0PR10MB4908:EE_
X-MS-Office365-Filtering-Correlation-Id: c79b61fb-1608-4ea6-be66-08ddcd9658c3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|7416014|376014|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?AWC+HuJxr3qQuZNZEu0QU1ljTiQWe8/m6FaJ7wdzfosgNNRuFb52nhapp711?=
 =?us-ascii?Q?CUKKNMCOxg1qm2uuF+kq+Kau4oJwhvanSuSRgiUZWvsCqmATrih8djgrDKGP?=
 =?us-ascii?Q?Mory11dssVdGp4bQBdkPDVbLAEFcZawQUPcTd5yabEJe2DOnm1CwHRA5MIv6?=
 =?us-ascii?Q?Kl7LU6asUH3bQtetu8OQN3xFHCCbdBEBDB3e1S/nE8die7UBmtDLSL4XsxLM?=
 =?us-ascii?Q?xXoWpSQuyLSa4+oCcsHYv0wEwvrjXNvsDirFKljR9Bs/6sVOq08Od3khBYEH?=
 =?us-ascii?Q?2nxfCIygA2n2c5nCBHD9FXOnQT7s7m2LF6+wC7qDbGEx1Mr3u5FDEFqkNLyv?=
 =?us-ascii?Q?1tYo5/iQAwlzink4zGPLrobcSJPGVGTVpsVzEo+p9pJ7CKoBl/1yrBrYSqxn?=
 =?us-ascii?Q?etVUC2wVG+FkXs4BI8Os99XygKEl2C6Q0uIpTYvp8KljRyZfFdpNfJnxqxOn?=
 =?us-ascii?Q?3OWZY9J1VNh7xrMKFZwWxI49VdhwRF7g2r5aAiXsUA4g/bj1o3uBO3V8e/S4?=
 =?us-ascii?Q?PgZbXyCuPF8EywK8S2QEE9gCYF02c/nlyyi8LxUM6AjH3UKCz+QmgNgaibec?=
 =?us-ascii?Q?ILt4mms6jCej/pJc1LGbB9rGlXpKhWp1myMjuRT3sfwa9Xls1vZW0pq6f1a3?=
 =?us-ascii?Q?KkO+i25ePPAxs7RB5e4+x15X54i22F77krBZYxTkazvbVqqx5KDUoG4MmeVu?=
 =?us-ascii?Q?JUsALCfIdbSeCKZPldFR79eXidDJLzR3WFzBg5vGQ5/zqf8npOb92rbmdhwu?=
 =?us-ascii?Q?lZs6RC9fNGRNxaGDJqiQx0ZzhMPlk3pye99WS3uBWUQT9XGiC2FEsZlz/YLy?=
 =?us-ascii?Q?GkA3MKgO1sayr9/n15GJYDigzBY6tzEEilvgsVqw+5L150AZOixEUUbM4AcJ?=
 =?us-ascii?Q?BtSMwszDIhP7T4rp6b28kXOVRFo5ieAqm/yznTTuns0Rj6sVrB95pRvqFTjE?=
 =?us-ascii?Q?bPFiPmXQzRJT9jvCgBXSBHo8qd2AstZoJaawOq4PD4UkFuJJwximTI7C3ZiJ?=
 =?us-ascii?Q?IgJhH/srmfuCuzlDTTCqkJrud/7ggIdhylPINk9TEhLgZSDG4RaVhfN/Mjkx?=
 =?us-ascii?Q?ivGhTilQLk6LgSRVnQQnI8w3NS8W4ebWnwrCOAuYT+pTXPLqgoNymnk7Jgtu?=
 =?us-ascii?Q?GD0i2W/E7up7T2GieUJtscc/gIsmpvCPfEO2w7USF7fGnLStcndtwCnQNZrt?=
 =?us-ascii?Q?jJhtsNjpnHBLSqYP/gORHPFc4IwHn3crzZIp/RJUAmU0eBsPkzAJZpaKl9D8?=
 =?us-ascii?Q?k/7X0MjYalXzDglEXhNFSAseBNCJGDY2XQZKhB3LczvwLAvu5mUlGNaR+X7+?=
 =?us-ascii?Q?c7UaF5H5okKzGGkH17GrBKN79j/O8LHcaZASqJIWA3Z9dwX7PrMk+b6PRk4k?=
 =?us-ascii?Q?o3ta23a4joT/oxtsfVe6ShecGydUiJjoQHQHaVFWYeqYKAIZFk23ciAlNIIy?=
 =?us-ascii?Q?YNI/CryHuVM=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?ME2CLbl6iPtYHl6AEfkB2ejBltiok2chrwUzolTM5HxEM8pJskUnlybxtICN?=
 =?us-ascii?Q?BZy9fkLd3m9Y47ruAVeprlLCfoDyLvvKfmxXJTMKeGmi1TqbCgnFGsY9XYa2?=
 =?us-ascii?Q?K1E4DflpPnDd2h85bOy9tsVN8538XWJfjOQKztMCLuw8gIZtB/sdr+PGHlze?=
 =?us-ascii?Q?X2lTIVQP8Jfa065oXa4Qm+Q1wM9qAuKDS7Ifkdw80Ht4eOelv3yFd9zWDWmc?=
 =?us-ascii?Q?SYMGwqLVtjowDZKREq2vxa758x0qPVirHchCezNz09Fql/s5SJVRZjoLYdH6?=
 =?us-ascii?Q?Bd6V7k1O5XYmY5gw7QNOzFD4RTTg2h5+GFtL1uYNsmk/uRwSoQ1Y/DC+byMg?=
 =?us-ascii?Q?Z2Ta8/Ukg+QbAMLozM6dzTx3oB9mEzyMnyssrK2cVorjnLsIZ58IuXeosrPe?=
 =?us-ascii?Q?KIg+LKRvPaf4YI24CSWVxODXrrAY2f+CFLiL62kMF50JVxDwBKlVe+J4S9is?=
 =?us-ascii?Q?CMmwc7Gtye4Z78eGi5CTPr/3VeQqycmeSYb9YnPW22pVVKqBAodpMYQk3mcA?=
 =?us-ascii?Q?2k5DAVmLqtH3Mkrk5A4yfbBc5O1koN50W/W+qJCxtQ+zfrDz73XL71Ccq/Ky?=
 =?us-ascii?Q?ztcNSZGds/73RFcFRPzAsTAVPDSWsMovKOK1DYbbe1OYyAdOeY2fvgCUAgFQ?=
 =?us-ascii?Q?DmCdylswIz0BIM9BXkl7YhkiOIg3bwn8J3Dwhg5HzP9jRNAqqbO95bKlW3Dl?=
 =?us-ascii?Q?SvkHirgYq8ME1Tokm0pjE5BV73IJ4k1AibjqiC34KzxY2IfMoUMYRGxezQsN?=
 =?us-ascii?Q?PTi2vUoRQwxwo416RSBYhtSkthxPnnE13qlsFXLe6bEVEVSuYAYfx0zda+k6?=
 =?us-ascii?Q?//c0AlZWY3A3/Zoo50pis74DJlv4z5uok+hbhQKy8bsFp0Bx9c/uCkRDTrt1?=
 =?us-ascii?Q?b3eZpsUMX2nhiYRHzOlNW+sXmFgNwy63ykQW7ve/Ix0yeTLAdnCTwzW/IZtW?=
 =?us-ascii?Q?Dd/VlzS7v18EOEWzT3XX+LS0ISGcDQKIJC4VkxFQQiJRs48TqM1Y1spOrg5T?=
 =?us-ascii?Q?K/AkhnpI1/K/hPyBoXRi94xhK0k+o8t1hk4CZZrN6Mb89pHXgs9ZCI5yYeko?=
 =?us-ascii?Q?G6Pm3gaxs+ww/aF6sFqJKilCLIqWwAHr9w9d4lw065FZkeOXNDvti5hQcfg5?=
 =?us-ascii?Q?wpKNB1NSJyLjrkKuFAWQagxdrTI66L/GTEpCW6DRtVHo/1kX25shDeUIYP5X?=
 =?us-ascii?Q?IVMkSOvWefAyyFL1WnvmsbxMkwc+fO0bYD10Px7g8002mlR4CmDmHyF9WAMI?=
 =?us-ascii?Q?dHTbOJE0GJUFWdcPIdsIJV6EvBBO4XyuRSlgJvnaWRgxyw5rExW9scaVVosy?=
 =?us-ascii?Q?lTTLtvlOjj64QU/q1LmlMMKi1cCWxHbQd6MTU63H9MkrR3DqAsEcV8mDxJk2?=
 =?us-ascii?Q?TckgYIFxYNkeb7MkyqY71doPeH8bEufPl+kKzUpIn67FtHupjI/Mp8XCjD3z?=
 =?us-ascii?Q?YO60xDRbZiJ0urFWZCOdp06+zyOZFvuBnKbCTp52sstvRs/Pag8DY0In2dy0?=
 =?us-ascii?Q?ABnOz39m/mk95UOzF8AbQSydFOFAKwDYptOA1gK9YxE39d2o0cvVSIXQoMc4?=
 =?us-ascii?Q?N9BkNqKx4AzGs/6y8sgohqpvjnXkKb2HCouhSUQYiCnoqFbaGbbR0j0J1KWy?=
 =?us-ascii?Q?8w=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	0noamwHFM/MuWb3Rhf+g+pkVzc38Fyrqn0uXQLOuKSow4R6ULh+3O0VcOLYwaPa//J6Xl5mMmmpSu0rCCUmaH9nOtFoxEjoSbRywilIYoD1dnOmzqSkl1groSezhQaPK3cym8JoG/JP4PCU7SyzGC4xYSRtLWhjb92H8zhSJ/jcNO5WfiaFdAGJ2kNoH5Y2NeONaqiOtdZMKjmp0r78HrIJPLcU7Kizy60J5/MzmdK8lKFi2UEsZ4YPSlYitap3xDPL6sYoobu/mqKpgaT/cRBRKtZ7vrcbqZ3k04oRI2iegSC9/hvwCgxyG855Z+AO2oLI9cBBS/i2ul8p2UvOqrBN3DTiqPZm+tzvohNQ5ccVp3bYLtdSNxET6yqHg/oAuS0Yt+66dnEeA4palkfl/ZDedmfnMAx72aYnyAHYKDWbZ+wz9bEWCrY/bSonGbpC/B+FP18jkQST8sce3+cEqcMMR8FCeBBPWMt68ra8RFZheRuIIp0qAxcmajQOh/JqXxXqV2eP3Ad+6OtgsQEDLgKJUIyjkC8JelDLYLL1O6TYgXd0v0zRQ98agN3BZpGGwtYV9BYRG0tAdaCkZF/Kw0oKktNCkVdheNNneuKl/lp4=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c79b61fb-1608-4ea6-be66-08ddcd9658c3
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jul 2025 05:19:37.6627
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tkQk14AoAm+9UJoC33EjM+FvnNvyINxkWbSOHg0xSb3fbns4OOE7QOG+w7i+KedsCJRqY8xLL5h+JQbbImxlu9U8VKFn55gj36ZCyQoygl0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB4908
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-07-28_02,2025-07-24_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 mlxscore=0
 phishscore=0 suspectscore=0 mlxlogscore=999 adultscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2505160000
 definitions=main-2507280038
X-Authority-Analysis: v=2.4 cv=OvdPyz/t c=1 sm=1 tr=0 ts=68870870 b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19
 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19
 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10 a=Wb1JkmetP80A:10 a=GoEa3M9JfhUA:10
 a=VwQbUJbxAAAA:8 a=lnP3P7fCHPjDMHUImOsA:9 a=CjuIK1q_8ugA:10 cc=ntf
 awl=host:12061
X-Proofpoint-GUID: lXqyVRwmu9sH_RYXU_mPfkP5XCt2zqwc
X-Proofpoint-ORIG-GUID: lXqyVRwmu9sH_RYXU_mPfkP5XCt2zqwc
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNzI4MDAzOCBTYWx0ZWRfX1Vb41tRujI11
 FHhKxQwKUut3JmyT+8l36yLgW3exLQyqyP+tPOEtLpGzyhAitsTOVq69NC0yslAoG5VAXSt1zfy
 zRSwExbRVurgN9FiD+j5XLw82fMa8gnj9Mlphlig3Qs8OQGBlq6jW1Imrpqf1kxfRd8+3aWQJcd
 U97nHvsnOLjuvRUifZY233J49eberZoK2g80fRCu05YidhG6GCtn7Ly+jkRcpvnnKSfUFWD6T4o
 LFNeoSfzFNDcsgyaemE1AyKpmH8eZ+ynxAXv+bDngHwDl9lNpqcVsDuhT3eeE3JpryB/LsVNEqp
 wIvjY9KvdwZRJTeP1DDUbt2h6qjgvn2YHRQ/XEDWG+wCxJTQIYqpWZ0P3WuB8Yux1uklDYtLlc8
 Ii6yRmCevYZs9clLTzwKapmd5j8Xgjn3BShvGfpSAxNTy39cuv3IASp6UTBYCoPqPM5RucAV
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 9C5C280006
X-Stat-Signature: ozjcatwpkhqoufdnukpu7pwebtsarw5i
X-HE-Tag: 1753679990-396952
X-HE-Meta: U2FsdGVkX1/ikkVNLoKwyA+aSP/2v6Hg4NCvTv5GVw2xjijXJkNK2/ZTAsyjcnBgXbhO98f/nPiBKtt9XNXfTDP6imynsqKYymOIMsZt3M4uPxZPZ7NncO3SstBsQrwUD/kh3gy5ohDYiuTHvFEsFvQJuDrTvVJddiOIfOjX0lqBifbqsZKMBkxeZgcKMYHOJ5nIxXKFn6xUE2+qHP59AJjPQuK3LaEynBWkb9Lzkr4ZwSR0ws3hoBxfkJ6DzEu619QEbLsuWcNFYYqF8Q/u9qHTPNQFccYxsjXBsAuLRrbfKdMlSbF/S1hvS5icxiAJiAqm19hjV8Hfzf7X2JYvtEmWU060lOB5huv+Lx5SqpZxhazYw/sCOS1CS2nC7Hca2513GaJwKANpJPTOfNs6zS3X5hVcuFcqvqzzOc10Htczp68hh2d8SHa8cVoCZkMw03JWIHrBtyxt2iBlfKDCREXYkKexVhBZsV5+oDqMJ/SEg/qYjfoKtgeMO5QjWUvBbcDEWasBymIG3Crfn/0rbiACVoEU3yZ1OYkxGzeCLdIqJDAvvvlXXoPmx1zJRnKzovV5cApneIKpIfXsD+iJMY0a0q5azMIdSyQzwyVGef4R63MT+I9x4yNWgiuCVLvoibYDYJ1JyH2hHMUzQgWqSXPYEiaa66GYjNCe+tyj5jOSQKVPRKpuWdv7XkNhNYpJ7tEy9J3piTE8kzo0rQc6Mn05tfLc1E1zLFeF/6sptW9PCGwV53u1C6RfQ/8eMIhZmLbTwVsyiezxaWEXFUeX4u/AZfbdXckABBcmlmuXveN6RGFAgJj4CvP7kBi4SAd1aEA5OoFhDqIZmh5Zo+Si5hAviy6bTRJkOMEjpj7XzUIZSLxfTf/ubt2wSkzFOM6Daz9JxAz38YuQk///2ty2AwozMD9fnuE98RQ7ZmHFDabc2Z/qZghP5JYpDp9nsk4f1WuYSbqNAUQTHnXjUxK
 Qq9Pliw+
 WNvC84fZLEfj5EIzq1fVpxdUF42itWY7Ui393oTSy2lOqLjeCIFXjamIJ4DARnCvNlsh7aVce7/c0ZUKO9IlC9cbGQv0z35lsQ/fcAhwM0T39Ax4n9pgP1Ttsfl9zWSrI5LZUCYN3gTtfbyOz9QFosg/sm/R+pIV4a8P8X4h6k7b3BLTGK92sqDDOmFmzgEveCnaec/t1l/rTJVnohTByziJutOgfDOCw36SleudkqfSgCP3NMwrpXRldQZskfiCdy+V/m+0xx3p260t73Wlc6stK5xtzT8toi6ak24XorYct74tSbo/iCUQVnVt/UpOhTeYwf955+T81Ub4pKG/liAkLF7fFDrasUIrNa8W1ziK5T9yI9yB33KeFsYGmoGn1jAjzWI6x/0SHMA8axZoFq9jS779AwFzVQdeTbsRbpd4lxfQ2MbHpXr4BWL6TbP9SG5AAVrbJRkv8O2eruT0makbU7voTVYGv/lZr3cAl41vh9icqUrupabb2fUjv7QMjmwcuawW4bJvA9Y6sJuMZxn5OA/568avP30ESxkHGAySQJcLV0t5P2uXsvI3v+LymX7XHQXj+0dXEC9XW2h0s9/oYHF/pbw+ndA9dxWW9i7MZBZA7PjCnpOlHfroz0x1xb+4XKqM1y6L3QRZEzr7Eds3z/+A/tkK8//X27E7HiNYI12pDqYjfjPDF3timkCvuQwoK37w4swt2GAw7itnEX6bpj/WCOOAF8kp3ls3MQwEQf0zd+I3dj2yZSzXlIWJzj/amYavUGOgps4EUjIOUMYfiFg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Jul 27, 2025 at 01:18:11PM -0700, SeongJae Park wrote:
> DAMON is using Accessed bits of page table entries as the major source
> of the access information.  It lacks some additional information such as
> which CPU was making the access.  Page faults could be another source of
> information for such additional information.
>
> Implement another change_protection() flag for such use case, namely
> MM_CP_DAMON.  DAMON will install PAGE_NONE protections using the flag.
> To avoid interfering with NUMA_BALANCING, which is also using PAGE_NON
> protection, pass the faults to DAMON only when NUMA_BALANCING is
> disabled.
>
> Signed-off-by: SeongJae Park <sj@kernel.org>

This seems to not be an upstreamable series right now unless I'm missing
something.

Firstly, you're making a change in behaviour even when CONFIG_DAMON is not
specified, and Linus already told you we can't have that default-on.

I'm very very much not happy with us doing something for 'damon'
unconditionaly when !CONFIG_DAMON on the assumption that an acessible
mapping has PROT_NONE set.

This change makes me nervous in general ANYWAY as you are now changing core
mm and introducing a new faulting mechanism specifically for DAMON.

And we are assuming that NUMA balancing being disabled is not racey in a
way that will cause things to break.

I really also dislike the idea of an _implicit_ assumption that we are good
to use the NUMA balancing faulting mechanism to 'tack on' DAMON stuff.

Is it really all that useful to provide a method that requires NUMA
balancing to be diabled?

Finally, you're making it so DAMON can mprotect() something to use the
DAMON/NUMA balancing fault handler, which doesn't appaer to check to see if
NUMA balacing is disabled, but anyway it could be re-enabled?

And then now DAMON is making stuff fault as NUMA balancing faults
incorrectly?

This just seems broken.

Unless there's really good justification I'm really not inclined for us to
merge this as-is right now unfortunately.

> ---
>  include/linux/mm.h |  1 +
>  mm/memory.c        | 53 ++++++++++++++++++++++++++++++++++++++++++++--
>  mm/mprotect.c      |  5 +++++
>  3 files changed, 57 insertions(+), 2 deletions(-)
>
> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index 21270f1664a4..ad92b77bf782 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -2567,6 +2567,7 @@ int get_cmdline(struct task_struct *task, char *buffer, int buflen);
>  #define  MM_CP_UFFD_WP_RESOLVE             (1UL << 3) /* Resolve wp */
>  #define  MM_CP_UFFD_WP_ALL                 (MM_CP_UFFD_WP | \
>  					    MM_CP_UFFD_WP_RESOLVE)

/* Comment here :) */

> +#define MM_CP_DAMON                        (1UL << 4)

Shouldn't this be something more specific like MM_CP_DAMON_REPORT_FAULT ?

>
>  bool can_change_pte_writable(struct vm_area_struct *vma, unsigned long addr,
>  			     pte_t pte);
> diff --git a/mm/memory.c b/mm/memory.c
> index 92fd18a5d8d1..656e610867b0 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -75,6 +75,7 @@
>  #include <linux/ptrace.h>
>  #include <linux/vmalloc.h>
>  #include <linux/sched/sysctl.h>
> +#include <linux/damon.h>
>
>  #include <trace/events/kmem.h>
>
> @@ -5972,6 +5973,47 @@ static vm_fault_t wp_huge_pud(struct vm_fault *vmf, pud_t orig_pud)
>  	return VM_FAULT_FALLBACK;
>  }
>
> +static vm_fault_t do_damon_page(struct vm_fault *vmf, bool huge_pmd)

You need to explain what this function is doing at least.

> +{
> +	struct damon_access_report access_report = {
> +		.addr = vmf->address,
> +		.size = 1,
> +	};
> +	struct vm_area_struct *vma = vmf->vma;
> +	struct folio *folio;
> +	pte_t pte, old_pte;
> +	bool writable = false, ignore_writable = false;
> +	bool pte_write_upgrade = vma_wants_manual_pte_write_upgrade(vma);
> +
> +	if (huge_pmd)
> +		access_report.addr = PFN_PHYS(pmd_pfn(vmf->orig_pmd));
> +	else
> +		access_report.addr = PFN_PHYS(pte_pfn(vmf->orig_pte));
> +
> +	spin_lock(vmf->ptl);
> +	old_pte = ptep_get(vmf->pte);
> +	if (unlikely(!pte_same(old_pte, vmf->orig_pte))) {
> +		pte_unmap_unlock(vmf->pte, vmf->ptl);
> +		return 0;
> +	}
> +	pte = pte_modify(old_pte, vma->vm_page_prot);

This is little weird, you're applying VMA protection bits to the PTE then
later asking about protection bits? Can't you just tell from the VMA flags?

Seems like do_numa_page() copy/pasta.

> +	writable = pte_write(pte);
> +	if (!writable && pte_write_upgrade &&
> +			can_change_pte_writable(vma, vmf->address, pte))
> +		writable = true;
> +	folio = vm_normal_folio(vma, vmf->address, pte);
> +	if (folio && folio_test_large(folio))
> +		numa_rebuild_large_mapping(vmf, vma, folio, pte,
> +				ignore_writable, pte_write_upgrade);
> +	else
> +		numa_rebuild_single_mapping(vmf, vma, vmf->address, vmf->pte,
> +				writable);
> +	pte_unmap_unlock(vmf->pte, vmf->ptl);
> +

All of this seems to be duplicating aspects of do_numa_page().

Seems more sensible, if it makes sense to accept this change (I'm still a
bit dubious about changing the faulting mechanism here), we should probably
implement a 'do_non_present_acessible()' function that avoids duplication +
bit-rot, with #ifdef CONFIG_DAMON's in place, or even better, just a hook
into damon code that's static inline void {} if not enabled.

Note that the numa fault handling logic is called _even if numa balancing
is disabled_. So we'd avoid all the other changes too.

> +	damon_report_access(&access_report);
> +	return 0;
> +}
> +
>  /*
>   * These routines also need to handle stuff like marking pages dirty
>   * and/or accessed for architectures that don't do it in hardware (most
> @@ -6036,8 +6078,11 @@ static vm_fault_t handle_pte_fault(struct vm_fault *vmf)
>  	if (!pte_present(vmf->orig_pte))
>  		return do_swap_page(vmf);
>
> -	if (pte_protnone(vmf->orig_pte) && vma_is_accessible(vmf->vma))
> +	if (pte_protnone(vmf->orig_pte) && vma_is_accessible(vmf->vma)) {
> +		if (sysctl_numa_balancing_mode == NUMA_BALANCING_DISABLED)
> +			return do_damon_page(vmf, false);

Making an assumption here that, even if damon is disabled, we should handle
a 'damon' fault is just icky, sorry.

Also are we 100% sure that there's no races here? When we disable numa
balancing do we correctly ensure that absolutely no racing NUMA balancing
faults can happen whatsever at this juncture?

Have you checked that and ensured that to be the case?

You really have to be 100% certain you're not going to wrongly handle NUMA
page faults this way, on a potentially non-CONFIG_DAMON kernel to boot.

Keep in mind fault handling is verrrry racey (purposefully) and can be done
under VMA read lock alone (and that's only very loosely a lock!).

This is just, yeah, concerning.

>  		return do_numa_page(vmf);
> +	}
>
>  	spin_lock(vmf->ptl);
>  	entry = vmf->orig_pte;
> @@ -6159,8 +6204,12 @@ static vm_fault_t __handle_mm_fault(struct vm_area_struct *vma,
>  			return 0;
>  		}
>  		if (pmd_trans_huge(vmf.orig_pmd)) {
> -			if (pmd_protnone(vmf.orig_pmd) && vma_is_accessible(vma))
> +			if (pmd_protnone(vmf.orig_pmd) && vma_is_accessible(vma)) {
> +				if (sysctl_numa_balancing_mode ==
> +						NUMA_BALANCING_DISABLED)
> +					return do_damon_page(&vmf, true);

Now we have _more_ weirdness around what CONFIG_TRANSPARENT_HUGEPAGE
enables/disables.

>  				return do_huge_pmd_numa_page(&vmf);

This function will be called only if THP is enabled, but now damon
overrides that...

Let's try and make this consistent.

> +			}
>
>  			if ((flags & (FAULT_FLAG_WRITE|FAULT_FLAG_UNSHARE)) &&
>  			    !pmd_write(vmf.orig_pmd)) {
> diff --git a/mm/mprotect.c b/mm/mprotect.c
> index 78bded7acf79..e8a76114e4f9 100644
> --- a/mm/mprotect.c
> +++ b/mm/mprotect.c
> @@ -714,6 +714,11 @@ long change_protection(struct mmu_gather *tlb,
>  	WARN_ON_ONCE(cp_flags & MM_CP_PROT_NUMA);
>  #endif
>
> +#ifdef CONFIG_ARCH_SUPPORTS_NUMA_BALANCING
> +	if (cp_flags & MM_CP_DAMON)
> +		newprot = PAGE_NONE;
> +#endif

OK this just seems broken.

Firstly, again you're introducing behaviour that applies even if DAMON is
disabled. Let's please not.

And predicating on -the architecture even supporting NUMA balancing- seems
rather bizarre?

Secondly, somebody can disable/enable NUMA balancing, and thus you are now
allowing this function to, when somebody specifies 'DAMON', get NUMA
balancing fault handling??

If you don't bother checking whether NUMA balancing is disabled when you
set it, then boom - you've broken the faulting mechanism, but even if you
_do_, somebody can just switch it on again...

Sorry but unless I'm wildly missing something here we're going to need a
new faulting mechanism (if we even want to allow DAMON to have its own
fault handling that is!)

> +
>  	if (is_vm_hugetlb_page(vma))
>  		pages = hugetlb_change_protection(vma, start, end, newprot,
>  						  cp_flags);
> --
> 2.39.5

Cheers, Lorenzo

