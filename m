Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9025FC83F25
	for <linux-mm@archiver.kernel.org>; Wed, 23 Jul 2025 05:09:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 269338E0003; Wed, 23 Jul 2025 01:09:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 213BE8E0001; Wed, 23 Jul 2025 01:09:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0B3468E0003; Wed, 23 Jul 2025 01:09:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E8EEE8E0001
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 01:09:00 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 6CA8C133748
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 05:09:00 +0000 (UTC)
X-FDA: 83694350040.16.5F3A73C
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf04.hostedemail.com (Postfix) with ESMTP id 1DB9440007
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 05:08:56 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=bRd4frhw;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=djxSDuDK;
	spf=pass (imf04.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753247337;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ncwFfPFx8+k9DF2p5m7CNAXXV+Yc8lodPLAdRNoOBS0=;
	b=A/+LtRJQ9Y6B/FhXDekOZ03M+sT7LllGYLP/lYDrzlbH5PMGBsTOuQAZY8jWg/Fa3g2vds
	1QlvWq7blQG9dK/FNPCPD60QgCnXnHAQ9UcBRO4jmSCvRKVDcjnIXplhRRfXW1xypY6zI0
	D9NviGZPP039W1ZHCLBXydkZmT8AV4s=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1753247337; a=rsa-sha256;
	cv=pass;
	b=591aHaRgU0nsMVHlrfAKnEx5bKBp8zUR4Wcd5qw2w+vcip3CD1Ota/RKBqF9IwofYwn4J6
	SVoqrnBuUikLch//re3pR1wcOGLhCe/TX+UCx+QiH/JyUqm8keqW6nmDRcksgpXYuXmmCt
	59OSMxR9AG5UdlwpPcjThsphDN8lcQc=
ARC-Authentication-Results: i=2;
	imf04.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=bRd4frhw;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=djxSDuDK;
	spf=pass (imf04.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 56MMR2UA002858;
	Wed, 23 Jul 2025 05:08:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=ncwFfPFx8+k9DF2p5m
	7CNAXXV+Yc8lodPLAdRNoOBS0=; b=bRd4frhwe/BwUbR57Qk7M/LSpngdWtUcHu
	OcH2G1HjwgY9Ci2nRNs618coMIpnHuIZoXWFWPIuv8//VWHJckIVqp6k5RYNCvG3
	LM2sCGRLGX8HZwYGlBsZIWO/Zqx/KD17q3LyfyzU9NcpKxBrESIFnIfL4wLvUmUn
	BsgB2iaoA7ti5GjHie/yb01NMBsxUxzjGHt3IYEPTc9RlxisrdAjzyNvgsbRYitJ
	O6BCrZc5IaKeg0A48avXOc6UCkvrwC7qv0UdoPdwODKYPpfvirIFGqAmp6y6eTbu
	GeR8OWzFR7wYP6qYfvCQFRJNnTNev8YLN98uDplDalngvlTHwv7w==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48057qxuem-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 23 Jul 2025 05:08:50 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 56N1iT1Q031647;
	Wed, 23 Jul 2025 05:08:49 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11on2089.outbound.protection.outlook.com [40.107.223.89])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4801tgex12-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 23 Jul 2025 05:08:49 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=BfGxCgzlgbJ9yV+TiDHIm1qEE4QDj79qhdpbWHmNQMhL8XE22/gRTy2vH2i3+kBHe8tH3krbVuELkFbGgSCgbsc183tx0LcA4kNIPHBtMqvNuI5M4jekK+U48eKW5I6ak6taIuaeJ4kp7v7U1Yx6cjpjF0w7n0T+TC3AEjShHF/EjREskffQSsTbDrQDNHQjKSb5V5pDl/KJZwD8H8/oARocsmh45cCmEOpgetPTwR9J7cbsnrP49kPBln3rnqNWG6RB4Q8BIG74qYDhhcmet2GQu1AvoXcIGIptFNBiMImm/8U1MSo0LcuLxIWnsUZF1x/FAifmoHKYiOkG4deczw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ncwFfPFx8+k9DF2p5m7CNAXXV+Yc8lodPLAdRNoOBS0=;
 b=WmYBTxDDiXLUSevGsj9jiFpWyJLKZbF/pYLpXeJymSLOgUw2GOw8/3i3SRpgmCLQHq7Usn+zW9aO4JTLEj1qxjJI3GZ7TZ4l82IT6Cn7k6MYBYCCDnUm1xySA72eoBZvkf2KJXanXQTiw7kscNd0f0Ov0IkuaoiXOfd4LhtzEz/ArsHoepKLSuMw0z4K/UoeCr1n0PDWgeZ3fCLnJx5jfswLzx8bdgjGcVm1+DplLq71y66pddUAVDTd6DAuN5esucdrGbteMISVGxFszaIivOlRWx+Vm+kEigcTe+NaIr13I9p7QUZFp/lnQ104I9h2P4piAtozjMcMuIuEiOFoaQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ncwFfPFx8+k9DF2p5m7CNAXXV+Yc8lodPLAdRNoOBS0=;
 b=djxSDuDKtn/F3o2RV3+19KIrMUupz8kv4rHNu63PHyErs6y3gnMUibsSeeI2C/RQvL44+A846mwKtMj/OkquGqY1l/hudtqREk7xDrVQu0dl4IFg9wr0tKbxUQyHfgz50L51Jp7IMXgHV2c84b4ic6yVi+TE73GyN35S6r1OL4A=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by SJ2PR10MB7082.namprd10.prod.outlook.com (2603:10b6:a03:4ca::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8943.30; Wed, 23 Jul
 2025 05:08:47 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%4]) with mapi id 15.20.8943.029; Wed, 23 Jul 2025
 05:08:47 +0000
Date: Wed, 23 Jul 2025 06:08:44 +0100
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Dev Jain <dev.jain@arm.com>
Cc: akpm@linux-foundation.org, david@redhat.com, ziy@nvidia.com,
        baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com,
        npache@redhat.com, ryan.roberts@arm.com, baohua@kernel.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Oscar Salvador <osalvador@suse.de>,
        Anshuman Khandual <anshuman.khandual@arm.com>
Subject: Re: [PATCH v3] khugepaged: Reduce race probability between migration
 and khugepaged
Message-ID: <ae5f4566-2692-41e5-8d14-653ab2a6af02@lucifer.local>
References: <20250704040417.63826-1-dev.jain@arm.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250704040417.63826-1-dev.jain@arm.com>
X-ClientProxiedBy: LO4P123CA0077.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:190::10) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|SJ2PR10MB7082:EE_
X-MS-Office365-Filtering-Correlation-Id: 84b5e8ad-913a-4cd3-fed2-08ddc9a700ee
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|1800799024|7416014|366016|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?1jQnx5ahAYzvS1IHq1NRHcfP2yBdmB7dbWp+jhJLOqsFIg1ZRg7b67urJK9y?=
 =?us-ascii?Q?xGL6f77ZpNBI3LvBkKmrW5PB6S+80KFor/XuXo79mMFRKssDGQL9ghkzNh3/?=
 =?us-ascii?Q?5wnnx4NyjVstowdNhnWHqDPp+GjsPo/NQgG/oSRkjWqLwhatphGd9MTC9bJ2?=
 =?us-ascii?Q?UwKirhFrSbIlTndvJ3qdGXGljU+59reatIu+eyZtS+1WelMkPysu3bCvrAJp?=
 =?us-ascii?Q?dav0NVQ+wADHMkT8GF59SK49XcemFBz6wVy/rc7sB9shhUtg4UMgCkz4ZRFe?=
 =?us-ascii?Q?7BT0MVO6vvNwGPTnXHlcM9RYRHQZoeeGfR9DTFcz6N4bEScr46jBQVsNNx4+?=
 =?us-ascii?Q?4GUDyRJ/FlCOl6hdZSuj9IAYl/QNKmoItD01hd6MsiEeaK4qitKdGZ1wn2IN?=
 =?us-ascii?Q?ZT/RZilYBorDj2tVRMla683RpM8dSkCjx66Gqe97od4xG0ue0k228/VfLrgc?=
 =?us-ascii?Q?X+WH8j6sj27MV82rE3JRjo2xPy8Su25JydxlTOoIHMdmzjQ9rhrCbJMr58YN?=
 =?us-ascii?Q?rTygNo1ZkYI60G2kq042f5NtBlvQaG62F/ofk3RT/wkFLUcQ65CzWXRa08v/?=
 =?us-ascii?Q?KebeHwiL2bYZbGNHM7YDcgVbQ8JR7JuCT2QRzch35mVXdwFo199ooUBsb3cx?=
 =?us-ascii?Q?LDNzLTvNdpwuhi+7s+rv4Fc7nj35WABxgkNBDLw+6J+q2mEFS43bCpscezJm?=
 =?us-ascii?Q?19TeGnTb5fs7MturPnmLA68h6mKQsY0rGNoRQ5uq5s3tmlR6fWUYVmJciC86?=
 =?us-ascii?Q?ofEpZ2fzGQNIPjiY8R1shTRoaaQdHstB9eEX3o3sSe0NUVJLn54ZuEhjA/9e?=
 =?us-ascii?Q?v9TWuBIo5LqTrH+SN+qngFvHWPGjKXC/x9pC4aHa4aKILrpRzEH74V4vl2ga?=
 =?us-ascii?Q?6p46ilAhYek5dbltI41RRkNvfC6Gb6OXW+rBfv1zYI2KvrktgoHyaxzMiW3B?=
 =?us-ascii?Q?B2mhoAODw1QqV/pyMusutGfmhDZcDQqxA7Z5DHb3I5TGc+/uFV1nSabvJcyZ?=
 =?us-ascii?Q?JzSkn6IgIEeJZq6Kz63j6HsDD3z7N8qIGCQyVTAke1Fauz+0HUelhrW5Zxy4?=
 =?us-ascii?Q?rFHmxyveqFpwIkFr16WKkmT+LxORolSBlADpM788y/+44XntR43AjRwWur8Z?=
 =?us-ascii?Q?7HPjkHnh5ZRVwOiaElexoj+cAVq29zaB1/xT7vNKBeGRNEwzb0vz1VF7Yqac?=
 =?us-ascii?Q?I7TslxWc7C7YcAmudQ4+Z7eMlvcPTyVa1/4+lFvLQ3oRaHGoTgvREN89fAct?=
 =?us-ascii?Q?Tf8fgcbXZIvDYMAtZZ5ciiqBaYAGqWlOPVG/vMhRVcoZRz10zCpP3YKTcAst?=
 =?us-ascii?Q?BWBmINY1g2U1K4Qf0uv7wy2umpYrw0eUYWLOhgoX/pXSwjdk6zLSzNVYDYaN?=
 =?us-ascii?Q?/+nfgPoU6yEIlYmKUUBv2yaEmHjNlMi6jcZAHGK86WzSbKTaDtcZxBLh+oVa?=
 =?us-ascii?Q?mt0rZoedOX0=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(7416014)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?uKxQDRGfyZhq701hMuWdWHLBKrs6E9xx7ZpEEJfm1CLQqUGG0IRdMg9PaGjD?=
 =?us-ascii?Q?cAujhLEA9t0azB/fnIMnsCCwlTkrD2UO6F7NHZHOsiyhl4VzqxVJ/P5AyKM7?=
 =?us-ascii?Q?jAdVLqxKMl41+pNlq/akRZ9zClo9LY6SrVvnCsbjvZ/oXdG+jaQGAf0Mq87B?=
 =?us-ascii?Q?N9dyWNup4z3CC8XDLX6ffouCsJlT1xjVvN8HpXd7TT7zDBqXB/w2R0IWJsFs?=
 =?us-ascii?Q?AQSH244jduHjVzqzTAZepSGEn+8NKQ2Eb1RDXfW4sNEmy+/um2BLOCoPAu5y?=
 =?us-ascii?Q?Uqx+YJ17v1a/5JgzuePXfi7+GoXHPDJVSqnDBSAfPePZLpmGtO5eRtJf2Vwa?=
 =?us-ascii?Q?JgKRlO7r4Xu7dGxQZiUV8uheZ1e6HIosgoBoFDYbW2r8wHFxwJmq1W0IWp9w?=
 =?us-ascii?Q?bVm0aVAeBOraVa4Ks29OD0UeuDQsZH1c7EsUZWnTM/cJeIRbVbVfuRQEeHqU?=
 =?us-ascii?Q?FftM0LiFS/Ot45pFaVOAM/mvFJRR0eLDkxzwKcByX5xLQOCeEYlpxmuHGss/?=
 =?us-ascii?Q?WqIqtn/j/v7RuQx5Q4i3B2wl6Mo/FxBFiru9HOdJ5kuOVUluXajtB537QudL?=
 =?us-ascii?Q?k9dUHoPn9Br5qwnxeAj/gLKrmQv3pdzFE6CiF2sUCXCzrmhwX/uoBIX15ufy?=
 =?us-ascii?Q?GopOUfd+p+6zIH8ziJmDnfHkb011CwE0Xp3Xl5cw02NByoksXcvXkXumsc6D?=
 =?us-ascii?Q?UxkzPBUE5+Gjc4qzl6wuz7YSpvnacfMuwq9oNSKiKfU17tirxxPG7eI+jjo8?=
 =?us-ascii?Q?NzN36I/64SF57XX8zs330au3KtF+dAIGAB/Go8e3jj8p90qg7+bpaTARM70t?=
 =?us-ascii?Q?dsabzkqzPQHX4uvbDBibRltKj0H/cMwHeqW5Mkc211alMEefL9TD296d4gez?=
 =?us-ascii?Q?21HVUJzn8fWicoLsivbvxmKhCVNJYDlouMjE2OGevXNqB45OEwIjN/FM8NiU?=
 =?us-ascii?Q?Y7752CtohcAvWaQ2/gxEtMpAfh9/GW5WOCuU6icr4J4W7QKRklQ1wPtXoi/G?=
 =?us-ascii?Q?M5qqx/+CQpZzPzSNSH3Ow8zhsUDVvkzrcuzjrwKgpDxOx04t/JLwjyxUa9o6?=
 =?us-ascii?Q?x9374+ZYg3jLTcAVw8r3/CnX6OKexqxaNNorL5zMwtT6KatqD7IQlbp2sjys?=
 =?us-ascii?Q?BEig/1eyTwV332uZLKKCZFxAzRRrUeMBoYt85zS7xFfIGxJZ5EQ3T9MmVn3u?=
 =?us-ascii?Q?8t743z7amjbtOv0SlzuIM8aujwgFHYjvJBxK/0tXXTGXzQ9zHRgkodHAMLfz?=
 =?us-ascii?Q?vckG3F4bDd7haLNMlZZjOYizBIrEPMZIxjAzffDEvJHxgqE4uZF+H/m5W5nt?=
 =?us-ascii?Q?VnCqnxR9LnLcJtYz2Aa4uJb2hmTTC6mnCXhP1PteadbmFpt1LXFjT2RAcOSU?=
 =?us-ascii?Q?57k/r0yIFvjIdNKuCpuPFAV9+QQEezTKeJO4aX1RVdd5OEdfAi/sDIy3ttY5?=
 =?us-ascii?Q?yjqeVoMEG65E4uHA6lL79O3lRXv57VyoUBA5d/Hgzk08rcAkzRCZLkAD27Nu?=
 =?us-ascii?Q?zLh28IEyqYLTcHdr1skRYicLK2ZpkxcNrBjRrV3s0w1K91zK1I69Bhpl9h0k?=
 =?us-ascii?Q?jRrLfVbulwiXFktrbg8plurmU23EMH9LmQwRmoIDN+FeMMMY+HhTOIs6OQT/?=
 =?us-ascii?Q?WQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	0i7c2CzVAkTxDpyDsMTuRLkEr4X+1XgVJiwWeBFLXORl32q8mznXNDEzRbvfR8/78eBYN5HztQz9LzACEgzAl7TYYranehStE22tOXnjaB3yg0+zON1L2/1xmrjrFXMvcJB+JY05xBe3e+/9zMLmdUJ/oqIQKqG19SUw9uLxdzKEXUAGLEn4v/OgKOr4UUDsZGvDmbym6qbQEYhFcdPTK4AR31YQoTGQDigJkxqawi8Vuh35XkZUZs3U5F+nHYuaXDYrvADpBiOtQN45WRfFoElTQcUJO79w70yJLLqaY2HdUUkddPuB4U2fXsy9oFpq+QEemwfw+ao/Bun6dDxH8/hLEqXN98tu1PB4Ah+LpMXLZbAk51gv79C6sphl+a8G1Gv+HQsaRKvK/iiKC0lKWZso2daHreuYoOP143rfkWVjPx30YsrPV5acR42H1QilTFhP52imF6BVcdbzLfcSEiH7IHiB42y2/VvpUIr5EPs0DvpssHrunOwrOh6qAHXD66nGTzdSObn3Q349HkCOCACNwP9MUGid9Ty0/0iDK5t74CU+SOSZMEwbGA9wgFV74fhA6P/PPjYWL5ayykyqTZo7TKMRa4WuI6jTZJMJDTQ=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 84b5e8ad-913a-4cd3-fed2-08ddc9a700ee
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jul 2025 05:08:46.9487
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VUriFT9cZQ7s+zRq7cqt9zFn3CNN9XxsPOrSb4D7rw1LUA/rZujGr+vAxbivTLfAGSOx2/aRdqgdWmbl2qHhVHd0imbY2EWDBoaRB+CAGUE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR10MB7082
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-07-23_01,2025-07-22_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 mlxscore=0
 suspectscore=0 malwarescore=0 spamscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2505160000
 definitions=main-2507230041
X-Authority-Analysis: v=2.4 cv=MNRgmNZl c=1 sm=1 tr=0 ts=68806e62 b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19
 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19
 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10 a=Wb1JkmetP80A:10 a=GoEa3M9JfhUA:10
 a=VwQbUJbxAAAA:8 a=7CQSdrXTAAAA:8 a=20KFwNOVAAAA:8 a=Ikd4Dj_1AAAA:8
 a=SRrdq9N9AAAA:8 a=yPCof4ZbAAAA:8 a=gGF6y580_tjd7iHf1XQA:9 a=CjuIK1q_8ugA:10
 a=a-qgeE7W1pNrGK8U0ZQC:22 cc=ntf awl=host:13600
X-Proofpoint-ORIG-GUID: Sb6X5Y-EejNlwK_V-k5EZ6E4iVk6TkF2
X-Proofpoint-GUID: Sb6X5Y-EejNlwK_V-k5EZ6E4iVk6TkF2
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNzIzMDA0MSBTYWx0ZWRfX8r1L+5UxODcd
 gu/CxNfrE5oTV6O7OrHDJ088fTf8ksO+j5E3El4/6RuQJndJovyLm1zU0kUYqnbi1nDBnkACgWA
 pTOfq9V8GoJ3ohXxXneOYFTVqZWiGcnP+TAy9tdBPjQJhLpvc9y/UXHOnuQ+ZGTajGJetnx5tuJ
 vPf0eQhSkPT777E1bVnksMSfWinglAI+QmJvOKwCIs/xKr89QU+lGzcpHiEAYKyPY/iqViSHTcq
 h14gqP6Okae8f+Y8KNjlh+Lea1m+STTqe2JbSqPQD0dG20EGW12Z14fX9naB7O0vm/I/NCFTeuA
 mZaTFJZZVHafxr67hNumLnQtamKqVhcZF3pZemjc3lAYQGFwr+lHSACVNUKsnHRpNghWCmRVMRj
 7ex94aoHmLk+9ln40E5UucihXw5TlhzBuiZNg0qPFy9LiLv1ZqW7oDMoid2jpU2eUxkKAUXz
X-Rspamd-Queue-Id: 1DB9440007
X-Stat-Signature: j9yzfc1jfzbiuozb8iy3ynr3zikff41e
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1753247336-330555
X-HE-Meta: U2FsdGVkX1/uMPpvKZbgY2k7/MGhw6g9S9krPDDbUhFE7ibdduRc6uTIHhh9Oaqz4uq7pHEtQPrpmFUYBhr+oHnMHm7SBdtlB8pw3bh0ZB0Vxp8Xrkw5uYANKqlaJe0+PFynFn57iLLQo5RBF5VUw2g6V7XbCTILgXlElBwD48DLtusKNBBGdhP6ALCq5nSzxGrUrJ2vJPpyzN2cW87nL7cnk1B3opPS4XwJVKYDgpLIWS/Mx3q6NjzQ7d1qpCaEZa7TcdWmptwtfTwsDQqF+VT41GSv1pt/ej7uzkKuKhpbL5xr5WAJz607VzZuDT1uATVmT5shMZV885htwsamG5sYJT2peR73vAb/m0+X1XqOWgfgKQgCDLqzdRmUGtu7+vk21yUrRDQ/jtwCylRAwbl+3SfPccD/zLHPREdXCLzgPAyGTTFnDYqC6gE1fadT79tdnyImLwFNLVUaw4I9s0u47T8kU+TwIeAM0mcqHHK49ig+O7H4VhenMWOBZ2T8EWx+KGOvRWdYIpMZagjUdiPC4mXoJa3Zfyi/Li9mZoZr1fLQOPQwtoeR16w+4qJs/J2I3QJkjkqF0LXmlaz9YoJLXUNd3EMRS3UzB7U0tUPlcqbpZQ82f321WCQJwzCiMm/C3rEsMkaPbnI7s4vxvehNDip0UIX9g+K0WecwfB7iocOZfUBsbUZOr0hMtdmHYwvXbsP9TKXxbfvXmTNx9qCOQumd/3LwrIjpBypnWEpLbdkz0smbDr3r/AadIBWR4JlttC3Fh0893IG/F/3kXVAAZ2nDJYBVwFxZgWgyL5qyPQtcQSRICjCluaGAXUKUQodMoNqPNPkJL842xeyjhJAciXvOPFD5SNrBLEQ0RD84p7MRoRsVJ+p04dChYRxjCOZCp1QRBv/z8pSGglLIYO7vDsQHDb4CfWP8MWRI0bdv22FNS53dwTW5KjZcglKO1sASLf2fXZjPC2dxXLh
 um3i+nDk
 3u2zmYVJ909+SWcTAOK3cuXWGIrU+k8cqr9jT7wY4AzsartZzYncc40WYH/riRJT7xtc5P3WeCI4iO3oOByJ7KkPS0tdsQtVraPJ4AfohGZuuxU7KXbe0yQ3bw+MG+aAeBDnwpXJZlM3P47HQ079DNKFVx2bcy9Ha6I7Aajuazly/UH2vudqFmVJgPCJ7jWElt7G/YeblXCbpgPlhes/Mcbkt5EEN4l28imo3NjhkdRz2/jXb8I3UIXwdK9KcWBrE9wt5PT5Ktvi0mQFW3UkqXObGMKS9RmifLlOCKKXTU6BWOBD8788rdDApy7wxtzvzBCKM7mm5hoRfNzQtyTj4+pWA3Dyc78kpsHvSOCuevnU5My6m9R0xCYeMtWAoT1gF2St+ZABgGmBH2phV3Cg7KLUAuZUEIql5wplIKCAoYmQvUYFcImzqlTnTznvugYJcGmiWr0O0kO2oef01I2stKn92RSwpeDd2NKrIRtkHWt2GV0XkGw3Mk1Z8Yz0MznovseMb6K8bKDb48cAoF3BWvAfI+pcxjIhTwEF0N1jtWamBU/ZYvPj8mgGaJTQkX5MjCyhs50Ghc3dOtuxRDE4eeKpm/AJ4+gThWpI9ApQthGEGEFPH0vlLhGCOkqfOOrWshiKodDTUcrKanDld3uPi6qvafV+pKxkyTbrRN/wCQXB51TSY9V2fE8OVjLaqW3yDEdqScqE8tiXhVGHbGB9kEE3zqd9yMLSOpkB4fSk+l7wIxiqPYU34CvfVbLk89w/9LqayJZ0jmAydGyYaGPKGSEAFFpAhJ+094mnDZuDsAiP51RVsiuEA7Cc7Sw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jul 04, 2025 at 09:34:17AM +0530, Dev Jain wrote:
> Suppose a folio is under migration, and khugepaged is also trying to
> collapse it. collapse_pte_mapped_thp() will retrieve the folio from the
> page cache via filemap_lock_folio(), thus taking a reference on the folio
> and sleeping on the folio lock, since the lock is held by the migration
> path. Migration will then fail in
> __folio_migrate_mapping -> folio_ref_freeze. Reduce the probability of
> such a race happening (leading to migration failure) by bailing out
> if we detect a PMD is marked with a migration entry.
>
> This fixes the migration-shared-anon-thp testcase failure on Apple M3.
>
> Note that, this is not a "fix" since it only reduces the chance of
> interference of khugepaged with migration, wherein both the kernel
> functionalities are deemed "best-effort".
>
> Acked-by: David Hildenbrand <david@redhat.com>
> Acked-by: Oscar Salvador <osalvador@suse.de>
> Reviewed-by: Anshuman Khandual <anshuman.khandual@arm.com>
> Reviewed-by: Zi Yan <ziy@nvidia.com>
> Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
> Signed-off-by: Dev Jain <dev.jain@arm.com>

LGTM, so:

Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>

> ---
>
> v2->v3:
>  - Improve comment (David)
>
> v1->v2:
>  - Remove SCAN_PMD_MIGRATION, merge into SCAN_PMD_MAPPED (David, Anshuman)
>  - Add a comment (Lorenzo)
>
> v1:
>  - https://lore.kernel.org/all/20250630044837.4675-1-dev.jain@arm.com/
>
>  mm/khugepaged.c | 8 ++++++++
>  1 file changed, 8 insertions(+)
>
> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> index 1aa7ca67c756..a55fb1dcd224 100644
> --- a/mm/khugepaged.c
> +++ b/mm/khugepaged.c
> @@ -941,6 +941,14 @@ static inline int check_pmd_state(pmd_t *pmd)
>
>  	if (pmd_none(pmde))
>  		return SCAN_PMD_NONE;
> +
> +	/*
> +	 * The folio may be under migration when khugepaged is trying to
> +	 * collapse it. Migration success or failure will eventually end
> +	 * up with a present PMD mapping a folio again.
> +	 */
> +	if (is_pmd_migration_entry(pmde))
> +		return SCAN_PMD_MAPPED;
>  	if (!pmd_present(pmde))
>  		return SCAN_PMD_NULL;
>  	if (pmd_trans_huge(pmde))
> --
> 2.30.2
>

