Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 12820103E185
	for <linux-mm@archiver.kernel.org>; Thu, 19 Mar 2026 05:27:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 189196B03F3; Thu, 19 Mar 2026 01:27:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 138676B03F4; Thu, 19 Mar 2026 01:27:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0001D6B03F5; Thu, 19 Mar 2026 01:27:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id E350E6B03F3
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 01:27:21 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 938261601E7
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 05:27:21 +0000 (UTC)
X-FDA: 84561679482.11.33D8A23
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf07.hostedemail.com (Postfix) with ESMTP id 38F574000B
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 05:27:18 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=Ft7kDxPw;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=gXfqEFXB;
	spf=pass (imf07.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773898038;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MruldowCAwelCFjZNyHVT6wT+XTKi9dmCL05skWpK/Y=;
	b=WFd2Hd+k5aHeQtxC8YdmlJeVHUocOcx1IPjhdlgqdCDZ5S9iPZ/Ih5UT0QckxcNbPTYWvs
	tzebUTxsM0TmYmSbxpSZ+uFc06EnXXqto9Tgu5LNvf8C+HGRVU89Wnjv/05pxaXo4SvHYC
	6sPop8GSJ6W1dvyG3C23bHnqsSadD3o=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1773898038; a=rsa-sha256;
	cv=pass;
	b=jzB2EXI9i0h4ibOn6yhHc4BA+tF/ODqWmMjMBg9p2q/8zJ95nctLNkFWIhkqyvkDZ/Hyf3
	Hbq9yHX1rh++gD3rb3JvIZxQPgCR4fJEDCGyJCDNPzR95UfZLiedwvSJGBI3Ja2dUFoYGm
	rzhR5YoBqHTyH9NnoRLtjBYmKPbIyoo=
ARC-Authentication-Results: i=2;
	imf07.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=Ft7kDxPw;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=gXfqEFXB;
	spf=pass (imf07.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 62J2Mbgi2009238;
	Thu, 19 Mar 2026 05:27:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=MruldowCAwelCFjZNy
	HVT6wT+XTKi9dmCL05skWpK/Y=; b=Ft7kDxPwYqB8gB9KS7WiVghvTFUh0zUi70
	JJw90ODIJgfYDmUOtuYLlPjVUWWwDGmeZF2rYCRAVxDrSCX4K2pyasq27g4Ndzbf
	SVxK4/iFEgHh37MiSLKwyTnfMFnZ2OmCpi4Cjjq+Irm+joOc2VRpVyjrlZWo49XP
	w7Zu9zdz2e4yzlLyI0Mz9aPLjLcSnHEFlRlRGbwNp9kJ8XD55IfbakS4BhNxQ0Mj
	BkZ2z5K5U1k8XnaFKQjcMaLzRR687tUN9b6zNJU5szUj+Qzb7urFMRQGi+BGnLCL
	fIMALGkdDUKhTVlkBeZPwVnXao8Bav46Uxpi0tS6x/w+hkQSh9xg==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4cvyqby9du-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 19 Mar 2026 05:27:13 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 62J3VbOF017938;
	Thu, 19 Mar 2026 05:27:12 GMT
Received: from co1pr03cu002.outbound.protection.outlook.com (mail-westus2azon11010006.outbound.protection.outlook.com [52.101.46.6])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4cvx4q4v3r-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 19 Mar 2026 05:27:12 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=YZsozoAUxsNc9AVAZqRDULPTWfkmvQ5IEcUQeEjp9tT5HJfOobKDOLV5kWeOD/BJ3SGBHIb1g+Efp6qS+PUVKcacmGc5HZ/N0PdubBsGIrmYKBxatiKF2V/blEHVOdpRq3jFgILLJYTdxbSCy2P8zwdSMdyPkYckvW0cGlQLHTaK6F5Johjbacsty5j993VpsvO1S+54KmvTBjOHaj6Dl22MNagvfj1Z6Favq23/23iqBAMsdo/4yCAe+yR4xaAf5wJhdE7LdSYQj7huhHVSmf2iiDuta9ALx3PPDoGcUIsp9ujOILLu+foZNZDbwoXX/spL0lULB8LZFB6C5G4SUw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MruldowCAwelCFjZNyHVT6wT+XTKi9dmCL05skWpK/Y=;
 b=FQ4l9Bu+Gh+VLMl0q7JOcQe/V8yU+/Sd/qBM73wCZhE/N22YvNWvzg7/u2FAmViro31tDEZRyxhx029wW3/ttcNnEMV9XZJ+D5XZMNiIoLNMHYejC7nfjmEBPSjhztQZUQJCv2BdCNk0NiqGls5Ze52fiwJB7NqB3erb41UIKrPGHvqTxLHPs8q7FDp9F0iGMiOfB82QbHWFdK3cStuY3P8tMndsKZj2St4qVRN/lqvAIOM0agJDD5BhQIx5qz2d/g/+yENEduNaAtVnVeMB74kVBIkChzkiS5LnRHZE7Tma4+WMopQfcSZLO39tavr5Nxhva4WqPm3rLBU5kr7F5w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MruldowCAwelCFjZNyHVT6wT+XTKi9dmCL05skWpK/Y=;
 b=gXfqEFXBDfp1n6nnYPiGCuIsBrRWzTYGLSU4v7Usns522T/87SOv/s9ZZJHqQkfZOUltBJYNZme2SPTAUS/+U5o75jjws8EjdZfWpuRaVNn6QKIpnJAJHnL72/D9MhiMXxT7c8IEOb5a8q2jwx06EFf8bwXgDrVn70znTHciRrw=
Received: from CH3PR10MB7329.namprd10.prod.outlook.com (2603:10b6:610:12c::16)
 by DS0PR10MB7980.namprd10.prod.outlook.com (2603:10b6:8:1b9::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9700.17; Thu, 19 Mar
 2026 05:27:07 +0000
Received: from CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::c2a4:fdda:f0c2:6f71]) by CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::c2a4:fdda:f0c2:6f71%7]) with mapi id 15.20.9723.019; Thu, 19 Mar 2026
 05:27:07 +0000
Date: Thu, 19 Mar 2026 14:26:58 +0900
From: Harry Yoo <harry.yoo@oracle.com>
To: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        David Hildenbrand <david@kernel.org>, Rik van Riel <riel@surriel.com>,
        "Liam R . Howlett" <Liam.Howlett@oracle.com>,
        Vlastimil Babka <vbabka@kernel.org>, Jann Horn <jannh@google.com>,
        Sasha Levin <sashal@kernel.org>, Jiakai Xu <jiakaipeanut@gmail.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH mm-hotfixes] mm/rmap: clear vma->anon_vma on error
Message-ID: <abuJIvqdJYg8afBU@hyeyoo>
References: <20260318122632.63404-1-ljs@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260318122632.63404-1-ljs@kernel.org>
X-ClientProxiedBy: SEWP216CA0137.KORP216.PROD.OUTLOOK.COM
 (2603:1096:101:2c0::6) To CH3PR10MB7329.namprd10.prod.outlook.com
 (2603:10b6:610:12c::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR10MB7329:EE_|DS0PR10MB7980:EE_
X-MS-Office365-Filtering-Correlation-Id: ab68b341-dbce-4ad5-2cdc-08de85782951
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|366016|376014|1800799024|22082099003|56012099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	D4SbybmJZdE3bzLOd3RW6Oe9Z/obmfu198T5EtR9RyKvzIV4gCzpI56WfT+3OiYPbDaApCoRgKKdcaOaZ2q/FWetil72wBphQo38mgSi5x0yz2WgcGx+jPDqTDPznLpxt4vJfAfgeq6EhtmXSG0e2CgdZHHmwVlkZjsT4KSjc9BG4whPp67Gb4t7LSpuTB9tUk2I9OtbnHwwd4aCiOoYTIFTlhB/sfqItCuDqH7r1t6+wo3pUPu8uWKFCkq6xJs8AixZGcDqhPOomT6/zbka3kB5S619dRIPaAnrt9eZcq22XeUlDwzpfg2GIfVRM4+CfjkMHw3oCkQvOXPCKdv4WBsQMvnR7FRIf0pyeXAPUU+fbuksGuPotnrEFiu3QlWSmBeM8SjMmtQH8i39++kiMDUc7QCATMvWd0ThqcF6P7ctXd+H4RcslryUfTcwxZv2FqNDlPeHFtUG4lM6/QPZSvitn7BZzqP0v1ysuGyFgsr4ttZg8kqnS0AetbkUImrUrS1H0OycggNRjTxU5cEc5TRUV7Ya2X/bEQMv97rOqe7Yijdq80T0qUEkZ/1xtKWqLDrZ8obKhe28aFUjXrxKbE7HssyRyVMkhNmOeDCj4bM8985hotOuYK3d6fiVPAYFGgURjdOOHx7S7yBKQc0MA+E+YFaxH6AixoaF56OIY4/vc0x+PV/9NAmK8E9AFSZBThVVYy0QKfF8TuB8/+xGsFEM8J4td+Ij4Pk0VOUlbgprtn3Hdj+A0Zsa3xsmfE+M
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR10MB7329.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(366016)(376014)(1800799024)(22082099003)(56012099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?dzANiFFQ6MkwzfLajlIFWCW4YkOfkoxQSvZLLSlmsAlBqpoETQoSGT8g8Vb4?=
 =?us-ascii?Q?3dyLRv+v5C6Bv5znnuEbv3yq/fkWGoOAHmIa57S6zgXy96KbXEEgotmi79WY?=
 =?us-ascii?Q?ui3ckY/FGxUGdG5TtilQUZ3ieRMTmxCJiLQEQffU/Q2cDcWrodnWv7fSDzWX?=
 =?us-ascii?Q?f9r4p8KV5L8tSA1nuWypOxN2NUE3Bx5/lE+wzaCrFOhOkUEFhT24+Lrax4+t?=
 =?us-ascii?Q?rGL7xi+hy3PH4PkMzGiO/R2WHtkZ/Nn2XxKVBq87DvI9thq3W8ca3GXP70Fx?=
 =?us-ascii?Q?ZpAv3O80rpG6mzAVQennCiC+EpwCJ1v914dv0Jv9HGY/OW63TxRTUz+4eaLY?=
 =?us-ascii?Q?DSdzCcb7QF6oc+7HmBljnzHCdJtjlIc/Z8XHKSa6SG4oKhQ/KfdNo+Dmm5Vy?=
 =?us-ascii?Q?gqSex3ouQhqqMgkuiMkmyn0ZoltWT9hPYRw1pnQ5ne9plaiONN2VaYfzurrx?=
 =?us-ascii?Q?wkPzlozOmBzWyMfpSlqpM/I4VVFrRmKMHoGjZBEb3rxCNgDWbo9D+paBrPy4?=
 =?us-ascii?Q?JY7DOdyKfj5ezM1M3XyWQsVTTLps56QydzMR1AFSPBmcfbePkDvzwU0wkc2r?=
 =?us-ascii?Q?mtD00qnDZbo5RUTuXywXVnMdjlw9uGlXNChzGtbYnkJ1TDOiPW8vFXDSy5qN?=
 =?us-ascii?Q?GHAU9ONijNyGAvNED59FPzL2JQ1breb4fI4IotZz+rsX+4vxraSYZWyPbwV6?=
 =?us-ascii?Q?a86w30KKE2azUr3hk9tJJphXVU9l0tHbFbBB4rQseg6BKg7KgZM4T1uSkMuA?=
 =?us-ascii?Q?0TNaL4g0h/i68x1qRHrS0eS59rRl5P481u+zJtIW2O6zrtXhgqdl1+HnbaWv?=
 =?us-ascii?Q?tbKrWrC96ERP9bCjoazIBNGpwSGmng928Bm15fF/yyjHi44F+xQdfdD/ywhj?=
 =?us-ascii?Q?sKBryvrB9p+aVsyq6Sn+eH0DDYrWrk5Cz6MF2ufQPDBnIHh3h/CeWR5fEJ2Q?=
 =?us-ascii?Q?xyKkzuxGxDYMxy/2WyaSWn50T+3RwXyd5Gg1IuoHe43nbfv+MH6/C5DyRbcT?=
 =?us-ascii?Q?Dc71GQrLUhoWqpNIRmm6WuNXKLY47+tgJuoxgA8/AHPeDbZgpQo3t/a8+9l0?=
 =?us-ascii?Q?Nog5LzajICe/tYGgkMfo8zNSgalw2irMefwTXWXd1afZb01/8WPi7QXZG4hS?=
 =?us-ascii?Q?TWwc+xQO5LRuyCJl1NULK/WPmTXBSl2tTaLx9CIPi3qKwrG64M82koL3+KXU?=
 =?us-ascii?Q?ZiRo8lHViJMtObPzLs0oHNXamui+4KZYbSyj27k+JYqzstRmAw5n5IaiFtPa?=
 =?us-ascii?Q?OFnuRm5zkYPB8FMV7smIo9K/Gv7Oho30YRUUz3cwByKSqT2jm6tquH+A5Mgi?=
 =?us-ascii?Q?3834qMHSumJLNhK+W+dI4SLI1LBdpisG2GDYSSQpMoF930MRaHDfy42r8YSn?=
 =?us-ascii?Q?iPtB7JqdwerZzhyTYQ+PGJ9fGZItCQhU1oWjoVFQcwg5V/VOYQlwq6/S6Xu/?=
 =?us-ascii?Q?1Zk5y3h2CEL3gEt5HjKVo/Our9Dzoek6MWUaCJN7VEEPjBLYFufUwCqn63qR?=
 =?us-ascii?Q?imvbsgRip5nmWGLyqoUvPPlg8tuyKbfL38aDUAsAaSXNNvelgglY1LxxgBNF?=
 =?us-ascii?Q?kCT3kzbkzBUIGIOCQNAlQqbo8RcyoHW5vQ53vftzxeIBhcsU6OTNkt65h39E?=
 =?us-ascii?Q?sBs0X1T80hyzrQ7f9r0gRpqL2xLM2OmNtCchnCObZOMKpfq/IAlVytXB/YUa?=
 =?us-ascii?Q?4YHJXYUBQnQWW5LOaj3smyb65vu0mKtPp1t4u3ARP32OAvaIk4O7azvUxL3l?=
 =?us-ascii?Q?SP3ae32APw=3D=3D?=
X-Exchange-RoutingPolicyChecked:
	R27JwWePlMAaLqv5eg4nNlfBcrs45cMFJVCPGXY2xBdqxlZHZ/FE0poDt/0ZI3p6IvmINlnnzxL8m9t61MfI3ER2FtChTSAh+WpdVCeXxBsqs4Tw49iS4XkceRwZUfpPVH2+ZKSbsdI5xE3QYzzv0cXbalFo1bBB1iXO3asTZiLMQ8I8CcOoXXwlMZd5lDirrp/vlbqneAh2DHCFQHeHsGCGn1wGU+0DqwDgd7aBthrpQIWQ1VAy4sSy92ibT0Ktf/DfThHVxBrpsZdN00sgKCxoymYIN5HS+6fgZaAcyHz1j+WNhd0H7VOPrJcYFVMY7Zf/ZPzRF04s23ywiATElQ==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	QS6bht7HXKWYf8oepyQaCzh632+4mZKxaA5RREAIpSRv6PqBsmfnCNUhjR35x3Fba9/C0fv0qfnVWTuWalibIWDJ1OLg0gRL8gw7m6uJINikKN4VhWs3OoTHtrdvgcZmghPt92VYRlV+skSNmJYpqszJgFaFJp4Mmcbua7RXmYr71KnyMBaF3L++5yWjV4tAkJMzS4C6/14cllAhDXu9wms0oNisN0k7PtEAJ5+eCjlVE9So/LCfYi4wuIY7m6wsUtXNYdj0vkVxc4VoLyDaTDyNsRI4XtA4mOu8WjX2ddf70xm14HN74tAenJnzRY8KZpN+q4TuzcbErnZfLRuQDcnIOTg0j3lj1mFx2ud+wFcMDrEspUQ77lbjQqhL//yOFBmVem+UHr+MZg7fCKns7BWJretSV9Mtbd3L7oko+JFo+Cp8sNbmVox3PfIofta+7hZBjn3nHDNdA7wYQxkMaspO4wyK0nWcatYeCJ2408Q1OtQB3ehVgeY9HGss7MNGCARetGmFI2Pox22Fd2QUfefzRygp8B+Dvn7UekZOlEGAUm9BthF2w708hJfPFVSG88lwN1hfBQCrqo7dnnoNLw6+h98qjQsAfEh8GxoxC80=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ab68b341-dbce-4ad5-2cdc-08de85782951
X-MS-Exchange-CrossTenant-AuthSource: CH3PR10MB7329.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Mar 2026 05:27:07.2264
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: sX0uH5k/HhaEZP3QN0W5wEhd5eha+To85Pf3ysBZCauD4tv2IHbwmEWRDoY6ypO/p/JDWiNyzu0wbKDwuahNPA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB7980
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-19_01,2026-03-17_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 adultscore=0
 suspectscore=0 bulkscore=0 spamscore=0 phishscore=0 mlxlogscore=750
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2603050001 definitions=main-2603190039
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzE5MDAzOSBTYWx0ZWRfX7svezIFsl+PC
 efqd3V0FDLkYn4bK13DAF68oVHNFeu/5lpv5g7aI7UDQ8bJcOTcd7VxYNpi6dw9o9Fr4VdWj49a
 +oK0e95ewOzSCSArVpb1dqyRL8n5jUxC62rwFz2krjt+8E+dHdZG7QfvLXGX6ej9ZsD+iJ8cgP2
 DYRgNipsJ6aZ06Wxi4v4+9yFPaVL1KO/lErTcK5bq19kI032VKmLPudt3tqECl4lncfxUmqSwDQ
 h3UuMgUFokPJdQDXoOF0WLNhQUw4xzVRPLx0uJim/pl4x0FXdDhlWvV9P367jIuwiUNu2R1ef3m
 SFamAQmJT2r2ASf26BtzKvqeMz4SzaiEHiNLs2JVfvxIbXlsxkppfp5zWnXe6CiZBu9mLj8UU59
 53EWg4Df51VeYvFYUeqwU3O5jOBdI8Z3NrVWR8PaUZWCLAc6G4nhNuEA00clLDh7nJvRdG4qNLd
 tF95BCOsFAlzFN1t4lVH4vcI7CS+gXR3vyUeViWs=
X-Authority-Analysis: v=2.4 cv=J8WnLQnS c=1 sm=1 tr=0 ts=69bb8931 b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=Yq5XynenixoA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=BqU2WV_vvsyTyxaotp0D:22 a=VwQbUJbxAAAA:8
 a=pGLkceISAAAA:8 a=yPCof4ZbAAAA:8 a=50rXzT17iIHH42n1CvcA:9 a=CjuIK1q_8ugA:10
 cc=ntf awl=host:12273
X-Proofpoint-GUID: 5wWtnfMzi28HVenJBtrjlOeYd6e9K_WS
X-Proofpoint-ORIG-GUID: 5wWtnfMzi28HVenJBtrjlOeYd6e9K_WS
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 38F574000B
X-Stat-Signature: 34a8gs3es6bbq8pafayz55zpz4ieddk1
X-HE-Tag: 1773898038-278000
X-HE-Meta: U2FsdGVkX181we033RR2iUTC/t7nFVAIqh0kZh2WXxYABYFQPYLyitRCMrqM09SflFu++XJT5/Tqaj0t4rnffMF77WUn0bgpIVBB52Ka0V5Ge7gtSXOJRQHNvF4SSQiLCh4zj/U6gmwuimpcyChOErn5qAYW5w3xPz8iLhRiu1/Jvptuh8Y343pmyRXyA6Uv0moc9qn5VgnXB8tOFgtTiyrX4+FTdpfnwjVPh2mvy5ofTsE9VmPg3VuMcSuU/xiheRs/OzGZ+yh8hi3EabhFZ+o89TUa9IeeYdEZwOjgc30dsiK7u9rgsKj2cezpsZb9yf7MQQntLxi6nrMRBErsRnW7LC3lgy0E/xK0dzQZMkGDRAMAJv9+7sqImVKSFEE8BtF+soVNDZdibCaadjoyNT6+jzXszS8ZeXLpp7z56LuE4/R577+uqAKNQl1vPIw9cz84IpV9E8SVMnv8m3Wl2nCqYtcAKgrVKEZf7NAChdE3c2+rfyNJvEzcPR7VBzrdW9qJu6FFIwQIKvtVtrC6b1VvtH8LZ2mqVhlgWBSA2NaVpPcpMXR8OCU397/DlkqVdLDVGRS6hFKqpmipcEOBQU4QL1QfZxz6aksA31bj8D9R9Xvfe4wFpoBMTBFAsd+klBwiBe3OXOVlanX1ENpWs2JQFaP8+Ld+ie84XkhUi3+xAo4t/znXiJF6C99zxYiC1HpauJNESKMCZZw6yB9cL53KEVaSDujb1LPbRyLw1SxsAmmQzyIydfotYR4nHKfBNYQU0tYnqw5sw2pzJYlU3aBRLd2dNoLRe28U342VQ1sVu6AiHcRaQgOyAD/FWYEtpxbWmzj4dMKFgHbswFesvRxGZPfu6yKygDcjtrktFPPchqTp3T+BwklVyKspad287SVCRWswM2ZzEJQDuo+LNZ2xdlAMaZbzYop+BeXjWUFPWq+jg6LhWce8zvMXiiCFBaImYKgMBs8uBbAudPh
 lm2oDVN8
 fOZXalXsUhdFKisHyjsiQ9cl8Nax9YOHIhbYrCjBVqPdrS+sU0Lx4qK26ad/g4w6xDuB/x7sJf/1d5zmamTxqDtQH4jmbDGG3dU4z0ZtyadufFpcbPHPIXigZI9UlZ+JWK2QfUaCeBsINWGBTboMO07t7L4ZZJXiYTpd4TI+dZYgkrWsqlwLS7l0yJ/ZDvWLfFcyu5wDBhDmDoA66dkjJV4i9LWLJPKeycw5+wujRLxEG+TFaVOkKJ3Rac9CCW10i7TIAXgMZr2gM/Ytu8vkZdPsda3Us6yn3+Cvwk4LEu08mDINXcLaHwITzebv+4eg+RPzO6fm59lhCydQxDD4+nmegMogMrxlS9+10awrFhVs1LZSX8WTEX2poLsu19GJWXT0oTVJ+UfIMg5SafengFkhTflV8Zew+V9D2mvDuGvEX/zIDXzN+onZGdisdk8g8aV3RukAnWo9Z2STvRz4mwA/fuO471VD2DuNGHVB1puNHVqGNQj0RJ5BUXnCbNYqHiYY/spRTsJ1kkmMJYYeXnQ0+qVSFucCSbOCFy0MX4S4Je+DEVC9bFLm58l4gbKo/5tYzZdFMXPQw+dZaGrgS9qOgbxbcBn3VCFXV7D/CtXnRgM2vJ8zaPN+EcjgMm1oM0807YBwKebjHbCdYXlfgvho2oqX/ga8W1s7OE09SW1toGY6Wqb2rGoo/mm3PGms2oPVQrPaYs7hmF1tXLBlT/nrpcV1LObtwOT/+/sdncLuPE6k=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Mar 18, 2026 at 12:26:32PM +0000, Lorenzo Stoakes (Oracle) wrote:
> Commit 542eda1a8329 ("mm/rmap: improve anon_vma_clone(), unlink_anon_vmas()
> comments, add asserts") alters the way errors are handled, but overlooked
> one important aspect of clean up.
> 
> When a VMA encounters an error state in anon_vma_clone() (that is, on
> attempted allocation of anon_vma_chain objects), it cleans up partially
> established state in cleanup_partial_anon_vmas(), before returning an
> error.
> 
> However, this occurs prior to anon_vma->num_active_vmas being incremented,
> and it also fails to clear the VMA's vma->anon_vma field, which remains in
> place.
> 
> This is immediately an inconsistent state, because
> anon_vma->num_active_vmas is supposed to track the number of VMAs whose
> vma->anon_vma field references that anon_vma, and now that count is
> off-by-negative-1 for each VMA for which this error state has occurred.
> 
> When VMAs are unlinked from this anon_vma, unlink_anon_vmas() will
> eventually underflow anon_vma->num_active_vmas, which will trigger a
> warning.
> 
> This will always eventually happen, as we unlink anon_vma's at process
> teardown.
> 
> It could also cause maybe_reuse_anon_vma() to incorrectly permit the reuse
> of an anon_vma which has active VMAs attached, which will lead to a
> persistently invalid state.
> 
> The solution is to clear the VMA's anon_vma field when we clean up partial
> state, as the fact we are doing so indicates clearly that the VMA is not
> correctly integrated into the anon_vma tree and thus this field is invalid.
> 
> Reported-by: Sasha Levin <sashal@kernel.org>
> Closes: https://lore.kernel.org/linux-mm/20260302151547.2389070-1-sashal@kernel.org/
> Reported-by: Jiakai Xu <jiakaipeanut@gmail.com>
> Closes: https://lore.kernel.org/linux-mm/CAFb8wJvRhatRD-9DVmr5v5pixTMPEr3UKjYBJjCd09OfH55CKg@mail.gmail.com/
> Fixes: 542eda1a8329 ("mm/rmap: improve anon_vma_clone(), unlink_anon_vmas() comments, add asserts")
> Signed-off-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
> ---

Acked-by: Harry Yoo <harry.yoo@oracle.com>

-- 
Cheers,
Harry / Hyeonggon

