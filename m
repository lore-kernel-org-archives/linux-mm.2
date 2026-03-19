Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 237E91088E58
	for <linux-mm@archiver.kernel.org>; Thu, 19 Mar 2026 01:49:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6A33C6B03A9; Wed, 18 Mar 2026 21:49:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 67CB86B03AA; Wed, 18 Mar 2026 21:49:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5428D6B03AB; Wed, 18 Mar 2026 21:49:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 402066B03A9
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 21:49:38 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id ED4F48AAE4
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 01:49:37 +0000 (UTC)
X-FDA: 84561130794.19.308B028
Received: from CH5PR02CU005.outbound.protection.outlook.com (mail-northcentralusazon11012012.outbound.protection.outlook.com [40.107.200.12])
	by imf01.hostedemail.com (Postfix) with ESMTP id 1B03D40007
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 01:49:34 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=nl0oJmhH;
	spf=pass (imf01.hostedemail.com: domain of apopple@nvidia.com designates 40.107.200.12 as permitted sender) smtp.mailfrom=apopple@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773884975;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9+gIaSvN+wOUNEuwH5Ov1wQyr8hFKW7bDhg5sedJ2B4=;
	b=uJyfHvXf5CfI/Xmzh4uUAroiyB44RWlK8s+fTLHeA5R7/ygDpt6T0VlFZBuxf9o3mUy4UN
	YOPjcITICqe4SatCrCJCi8XtVssWe8DYjWTru6oNv8D55rXaXeM6kk1sTXcFtg2Mql+vgH
	7V4SGRiNxRgKvV6xFEWDt5Gid4GUVAQ=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1773884975; a=rsa-sha256;
	cv=pass;
	b=ibIahQAx2TOlJLo5MtIv/oqcA9zfUNDRFyV87taYi800yqbHIs0PvKw1SKMzDXtJM+QJgP
	RbAMPXnVNnkDCP2QDZVnWBe+hVZyBfU4j6Dlxi9tyr04q9mg3ChCdMURD7qp4JuJzduBMS
	vD2HLH2hIUSIJxjQTwEH83BsHnSJv1M=
ARC-Authentication-Results: i=2;
	imf01.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=nl0oJmhH;
	spf=pass (imf01.hostedemail.com: domain of apopple@nvidia.com designates 40.107.200.12 as permitted sender) smtp.mailfrom=apopple@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=skUUcViQGr6TtfCD4Q0kNGkPm8H0no8E2O3FgN1EADEKNYuKB/R9rcVXauSq8S5Rpv48Ha+/bTajZhFkrs4K/X37OcOYtyJnGPNMEzM8iXyjnsoULIdDXyqPBdjGM7CDVs78eNiOg/23NG/dbh7wxoUfsGPrEdFIBqH32GJsvq6ZQR5cVL/MsfRF48DTQ6S/Vufa/v3h3/w8Ag44jiIzYX5UEsX3pXf63tDIEiLRCfWKvn1CwTioAYGM2LDzTfo2Wow/O1+5RzMWCh8ASIJ3ZAEvlLh3nVp0z1EF0n5h8ScfFfGyK7aPHDEvBDIpXkwfxSkKuDGjbRkdqEn7W4e30w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9+gIaSvN+wOUNEuwH5Ov1wQyr8hFKW7bDhg5sedJ2B4=;
 b=dH3gttiKOLmMVRPjEKWQJmlCCSogXxse4dHe5RGT0ci4udciAp7AON0Y/RA3OR7QF5LuZ/GbtVe3ayI8bUaAhzGUF17MFpNVqN9QpAqWdUiXXtBMkQRHtUjMFD9OieEWEE40jiTHeRN3tMeCgXaepnAKXhx9mgMjAm9WDPQ7lCFzRRC9ESDL04/MDXk61OqAvbkajOiSlnAN17wbZqqBbimjtg7/+8DpYyrz1IIK9FH1h8Z9DtxrOLouAX+5oDXRo4xUUENV4ovEC2Ck8beHp8S47x24Y4Nc6HM6d+uaNQjq4QojOFinXSKSA7/1TB2Ox5TJKEapZCUMu4xrBzIQjw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9+gIaSvN+wOUNEuwH5Ov1wQyr8hFKW7bDhg5sedJ2B4=;
 b=nl0oJmhHa15V6I/ePSx4jetMieGvlGQh53PtSMLaYziG2glUTYJUNL9OPHXJu8lfb6RtQGCqklDCuSNr3P8RVxt+fboh2v0hPuMS8F9qC85Wy7IbrBb1JcU3UvImQef0BRcBK8e5vf1d8S8HiQjhJsTmt7nxnMkb/3jSou7fWoKcXgCg+BF+qaenKvtp1+OCrOlhNUrznnzcWT/m5Q+IpW+PBlNw+UXV62cYyLTwYp3TXUNIxEQ109gjIbKzpg8V7OBjMOlMrr36+3Xz0eoWm7RWhyrMewRCSpf/J3pxSZuHjp707sMu2pRjouwSU3OiCn/CdOH/DPQ6cItOic2GhA==
Received: from DS0PR12MB7726.namprd12.prod.outlook.com (2603:10b6:8:130::6) by
 DM4PR12MB7696.namprd12.prod.outlook.com (2603:10b6:8:100::10) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9745.9; Thu, 19 Mar 2026 01:49:29 +0000
Received: from DS0PR12MB7726.namprd12.prod.outlook.com
 ([fe80::5807:8e24:69b0:f6c0]) by DS0PR12MB7726.namprd12.prod.outlook.com
 ([fe80::5807:8e24:69b0:f6c0%4]) with mapi id 15.20.9723.018; Thu, 19 Mar 2026
 01:49:29 +0000
Date: Thu, 19 Mar 2026 12:49:23 +1100
From: Alistair Popple <apopple@nvidia.com>
To: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
Cc: Zenghui Yu <zenghui.yu@linux.dev>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, jgg@ziepe.ca, leon@kernel.org, akpm@linux-foundation.org, 
	david@kernel.org, Liam.Howlett@oracle.com, vbabka@kernel.org, rppt@kernel.org, 
	surenb@google.com, mhocko@suse.com, balbirs@nvidia.com
Subject: Re: running mm/ksft_hmm.sh on arm64 results in a kernel panic
Message-ID: <abtUZpLOSaSMAkCK@nvdebian.thelocal>
References: <8bd0396a-8997-4d2e-a13f-5aac033083d7@linux.dev>
 <3f58a6f6-bf26-4c6c-8bc4-c05264ad0cc3@lucifer.local>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3f58a6f6-bf26-4c6c-8bc4-c05264ad0cc3@lucifer.local>
X-ClientProxiedBy: SY6PR01CA0104.ausprd01.prod.outlook.com
 (2603:10c6:10:111::19) To DS0PR12MB7726.namprd12.prod.outlook.com
 (2603:10b6:8:130::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR12MB7726:EE_|DM4PR12MB7696:EE_
X-MS-Office365-Filtering-Correlation-Id: d315487e-b42d-4358-9040-08de8559c1fa
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|1800799024|366016|7053199007|22082099003|18002099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	ecfdP1Ptuxv0jD3Rs4d7Dn41O5VcD89pHTk/5IFkX+Fwh0VhK/gKZl5pT2RzRMLww3MaTCwtSO21o8BpumiVNAxvtE7Nw4sisQLRMzXI/P67ZsriKJ9dJksmZIBvSAM33DZ52hGkBZRyKEOpKhDz1C1vHFoNi0eRNj2O6I1rw2XfmZ89XcaGBttggLEenNdU2QPYY+NXaFm1BuPSK8ctpaNJiK1cBCss7NUSkplwdpNhns5B/WFWfe2ZntGj+B1gZkViGdQXRed82wI1gYnEcVVLFu/x7FiL44igZyuteJ0VX47x+ChgAxC3kU4hrM/TbpG/E5weyq1M60Pr+UpSkqv6fp2kZynuT71B4gPkF+nQO5xD6HTMxYpiGxAwNMVYe/9aMIhYVHrgBLB5+X+1bGSVCyibszj2Ks3n1TAyUe4kQCR7kjiB/Ahg1kEbe8vCKMGM0k+573TaoJdi0p5tEkzF9d5PYwWbFUxBp6LC5Rh7W9/ljWIHiMoIhiHHGIMtZ2NmFCHXHxGRvSb1cxauDPoivn4mq/bJjSuyaD8J/QqsaojjwA4IbuhkISEbHIqm73VgTsWJO7U5lsL6GYVv8KAZ/de3LpJs5HoX6Ck5JNM/ATnwXYPRDjV1dRbuCoAJ85+7DyLyYnRMg0iKj0PSxPPAbRGVVSKo/rve7on6Z5AMtPYp7FNF+6E1i9Pb75jIxFbh3aO1t3SGBjiFQzPt+lEQgykA41nxEHisCETDSlg=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR12MB7726.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016)(7053199007)(22082099003)(18002099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?k1TN37Z2YVN8OFKOW86D0+jCroQNdGD6k3DKkws2eWgPHkxpjS8LrhdIJxUO?=
 =?us-ascii?Q?lvw7S6uw8EIQF46PWbk+WmikV3vdqEHU0+Z+vHnzoLZuO/8bsSzG45jFcD9c?=
 =?us-ascii?Q?2rBZCI4I0Cy0XGPmogowAQt+iBbM53X5YGco/zjE59FAh67lW8QJVMGt+fwl?=
 =?us-ascii?Q?Qw1iqa1c6iyMrOpz1fqokpi3CDOrvvLz4JY/1vkD+oN5lNDCRtgVFnqQtzZW?=
 =?us-ascii?Q?kG3dkDf4NVB0FMVUXNn+8Mu45tkfbyuoRAzwXeZlAFO0FfbkQDJYtDkeOaO1?=
 =?us-ascii?Q?7FibETfVfXf/ZEyYtpIbpnJsQj4HgVHyveHas34XWzV/CC4Gdo65o+ancsMR?=
 =?us-ascii?Q?80lJ8UI8T6djRNtLgiP3vPtp951ZnY60jV4GsCglFba9DVz8Lj4OAYageTKs?=
 =?us-ascii?Q?hqwpaAp67IsFk1iPTEqJQcj0sBgpyRQGirbXpamoOQ3k30BDzyqbeW7Y5jzm?=
 =?us-ascii?Q?Sm7w7yFNPJv4zidm7i2zgXZt5uKkmvK24T0OXg5LbPbaUXO7Syhj7K34gZSC?=
 =?us-ascii?Q?EJx1gnEiBYW1iOGVmbLgjAWBoj6KLvp1B8TI0nMFPwaq/K6DJV0bOSlG/PcF?=
 =?us-ascii?Q?fntwu52TNM1WEkG38EfU2NMYAU8k12riKHrzxbyHPqNdf5szEZcRPb1nq/mq?=
 =?us-ascii?Q?tmO8jOAo88hEQ/8hJx9NpiRIlSDIRYE3J9sWZptRwP4JQuF+NfUX67nw/9ma?=
 =?us-ascii?Q?NqMEZXhZgYc22HVCqb1Aen9pDYgrBAQCl9POTter26WZFKKqh21eafUTG/72?=
 =?us-ascii?Q?K4ehzTnVMfFre8vjSKB9KF/v2VWxAvyRwUR+3tWobJKVeS+20YtYoZMWtvBQ?=
 =?us-ascii?Q?l85ug6qDgz7Cfi76xGw8cJGcHrbZcCvK+CiMEBLP7C3h0qClqzr2eXxgWWFl?=
 =?us-ascii?Q?7qpYgAyBq9wEThQ1wcHbpUkdSOKzX3Ir4j4NGY6SRYYlnT3pZYP/X5Ba17So?=
 =?us-ascii?Q?Kh10Rhp2UVOy6vfxPPag/efhetlDGGJJQ5Kr+qVmcwcYuyRR3h9TVMNgydbD?=
 =?us-ascii?Q?BYstRNzUoz4iqJxZKiw1fPp1p3jZ7X5e7xMJzZ6vo7nUcK1t3c0KwXBNFSS5?=
 =?us-ascii?Q?XnRATE0qxds0Mxf8/5yo1MUF46sYSgXr+t/Tp/cT5687VaYZ1Kt3H3DvaKxV?=
 =?us-ascii?Q?ej3id8yEkrlyOdj5SieBxgy30GIW6Tdw9iwA/yLB58yzDpsgQFSbILBpoXrC?=
 =?us-ascii?Q?XSuNPXz6h5lBgq43NDVBe5EcGc03Vlbosp51ThSGfXlpWWYFVsdsUW4EkdzD?=
 =?us-ascii?Q?pRlm2MTkv1LBTpX7wHvQmMpuFYZxtPJs3A5DVOO5Ed9mMRxefk4eMQiKKIqO?=
 =?us-ascii?Q?Xmkwqj+Vf7+vDYlmW3QJJhfoomD6Utq5F9DMHOX/obT19TQYzN3ShaeMZ029?=
 =?us-ascii?Q?ewgrYE3PJs0wlYFP1RZn+5KBkR1aDVFdLhcmcUJVNX2kgEQtmPuHQ15fTpZR?=
 =?us-ascii?Q?Pmda1pobtG+62mCtO1cgnosqSq6dyBHFNy55saKVfeWeaVnBv/Yz3eCkEHfe?=
 =?us-ascii?Q?eoAHxPEbji7nyoRTX/cKQSJ3XHEAr+FG6Bl4j1dPGi0jl45d0vAMNYCYJsD4?=
 =?us-ascii?Q?t8+erpMDDBwzV7iqf0wiwSNUoSS0mvIpepQ8swuKRfk4xop4aoBQmS5odZBF?=
 =?us-ascii?Q?FRQIZIMrg0irQkcAW3rijdvs2kG3CuLG/eP3GRTJhEUpwMO8R2n8toD7vXaG?=
 =?us-ascii?Q?pR+Aw+k0x8w8EZsp2qhLeQwld42mONTbNsfnylzl04X6U+MlZuel8u3PW/jc?=
 =?us-ascii?Q?lrVNLWnIVA=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d315487e-b42d-4358-9040-08de8559c1fa
X-MS-Exchange-CrossTenant-AuthSource: DS0PR12MB7726.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Mar 2026 01:49:28.9343
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NSHZ8ysyt79zs0uQJNeEYPPRyPfcp/gM+k76G6d3t2rzUHF6Y07xm65U2UBhQXT3cO5YOOtuC9i7yGDwG2gnjQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB7696
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 1B03D40007
X-Stat-Signature: 4q3k1gby1co3ijgrpkndr5p9954cfp81
X-Rspam-User: 
X-HE-Tag: 1773884974-818986
X-HE-Meta: U2FsdGVkX19g6F4P/I5UaJy2m23clVbr0re7iPgbCSWprE3/bIyUWCyLcal4LxV2u4ywjNLJzUgiDemCaFY60c58f42zKbizRyNxCJjGZtiInDZ4hSQ0/owGRpGwNBRDWZJDxNTpym8RKpti2bHoYQwVA3mI4PeQir70UwoLRHoKbbYwjlIBypES3WTIiUlPbydFZZrRrS6NiX0M0qf4xVDUVa7KU9QmU9V6yQ2Q1YKze7Jaab5CKQtLZ+E1YY6l/PrZgUtxGZHyM6sZc5V5CPRlVUBRBgl8PQ69TdLozxa/01WCpayTPaRrX216OU2j+YrWSPfMM7lLwjXvjjCAmo05dnei1A1hEkSvBwiqHcZIVdL29Ro6GqdGpT2SKrLeYpCv4kQp8LFwxuEbES5GPQBGmjVdoWCE6mWNgA/n4DdF6r4xL+1w8l/tSBHzcVtnfScD46sZ4aqoRvGBSukvred6DQBIDqqWlVkfZGhO6PZtK+U/Bi6EAUGBPYdLw4kQlbGhcxgO2C4Wbwgp3dzE5AfL7bbO6beAdJlXV2+cM7ATETrYAOhgblhNOOw6/gTpCvNiaNit3YNFuocnFdQk6vlTPF5R7oMh2kZGATauxzYhC4eLY86Es+R4cA7cIYUbzVyWwuwn4Mjyfenpocrr0a7itRS+f0XmDa87WEsrnmS8Nt7PVR0MKDzRRLLQO5j3HAKL5lHeJW8NVcnBBoDte5MusQvfunIkK5R/SZsiF6aGUoe1Dk1/4/rOwkHE7QsDzEv41ksCBOySbtsr9XYq9kH7NgMYqjKfuwezDUOKm3S+jOhXFjAiRSZCu8TI5+9yGbqkdpgFEoy4haRHqaa4EIxhVBxoXcAB49xvMkTLBGocQFiyV+hzlU2qrOCs/2Dpvi9vBHNwMP4BUlvgXMHmE2D3LuvdBDhMWbs3kQKkYQ0zgcQ6BvbkNKPqoHW5GgAvSzMqSZ/nh7aZEByOgxB
 9m7FVmlh
 fMJQG+dpw5GrbBHGf4muemXlmwnOTKkme1ijEAysjwcCA2k34ejWbTeb+5DWYYDYJBDSUpX6Mo2oEDzO3fyhyefXPa/oe3FRRTZw8ydvA7aaSVlSY7R9oLtwyIylMDvDe4uWbKCjyfH/6EI3OgBh2MGGy92Dw3FGowKjU493ZnB7Z3RIPh6PbFFtAfrm3Lnph41euGQqB80sBAGcdUefQPwZm9h6pGSeqBI/paihQq4jVNE6jsT8rmSEApfjQdxSRotQPVE0kDXyDz0Dg265eE+h1uuANk74wMD7d9/Gsn6L9qKvfTUTuYZMoLnzxdnFhU/CrQ8wqo6aDOyzfOdsPUfidXZ+zBVSz0ZkOxCRS80ylLIQxm6k7dHIraST6ppisiLhlZ5Wvz8/MUn55nyCFqVkH3O4D3eDb3v3vEW46lCKgyO6pVJcx6oJKLgSOShPj6R0YWRCGcj7do3NleeL0d8ZK2xVy9L3VXdPMJ9Oq/UnDg3nrqR/yjdaq9g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026-03-19 at 02:05 +1100, "Lorenzo Stoakes (Oracle)" <ljs@kernel.org> wrote...
> On Wed, Mar 18, 2026 at 01:26:39PM +0800, Zenghui Yu wrote:
> > Hi all,
> >
> > When running mm/ksft_hmm.sh in my arm64 virtual machine, I ran into the
> > following kernel panic:
> >
> > [root@localhost mm]# ./ksft_hmm.sh
> > TAP version 13
> > # --------------------------------
> > # running bash ./test_hmm.sh smoke
> > # --------------------------------
> > # Running smoke test. Note, this test provides basic coverage.
> > # TAP version 13
> > # 1..74
> > # # Starting 74 tests from 4 test cases.
> > # #  RUN           hmm.hmm_device_private.benchmark_thp_migration ...
> > #
> > # HMM THP Migration Benchmark
> > # ---------------------------
> > # System page size: 16384 bytes
> > #
> > # === Small Buffer (512KB) (0.5 MB) ===
> > #                      | With THP        | Without THP     | Improvement
> > # ---------------------------------------------------------------------
> > # Sys->Dev Migration   | 0.423 ms        | 0.182 ms        | -133.0%
> > # Dev->Sys Migration   | 0.027 ms        | 0.025 ms        | -7.0%
> > # S->D Throughput      | 1.15 GB/s      | 2.69 GB/s      | -57.1%
> > # D->S Throughput      | 18.12 GB/s      | 19.38 GB/s      | -6.5%
> > #
> > # === Half THP Size (1MB) (1.0 MB) ===
> > #                      | With THP        | Without THP     | Improvement
> > # ---------------------------------------------------------------------
> > # Sys->Dev Migration   | 0.367 ms        | 1.187 ms        | 69.0%
> > # Dev->Sys Migration   | 0.048 ms        | 0.049 ms        | 2.2%
> > # S->D Throughput      | 2.66 GB/s      | 0.82 GB/s      | 222.9%
> > # D->S Throughput      | 20.53 GB/s      | 20.08 GB/s      | 2.3%
> > #
> > # === Single THP Size (2MB) (2.0 MB) ===
> > #                      | With THP        | Without THP     | Improvement
> > # ---------------------------------------------------------------------
> > # Sys->Dev Migration   | 0.817 ms        | 0.782 ms        | -4.4%
> > # Dev->Sys Migration   | 0.089 ms        | 0.096 ms        | 7.1%
> > # S->D Throughput      | 2.39 GB/s      | 2.50 GB/s      | -4.2%
> > # D->S Throughput      | 22.00 GB/s      | 20.44 GB/s      | 7.6%
> > #
> > # === Two THP Size (4MB) (4.0 MB) ===
> > #                      | With THP        | Without THP     | Improvement
> > # ---------------------------------------------------------------------
> > # Sys->Dev Migration   | 3.419 ms        | 2.337 ms        | -46.3%
> > # Dev->Sys Migration   | 0.321 ms        | 0.225 ms        | -42.6%
> > # S->D Throughput      | 1.14 GB/s      | 1.67 GB/s      | -31.6%
> > # D->S Throughput      | 12.17 GB/s      | 17.36 GB/s      | -29.9%
> > #
> > # === Four THP Size (8MB) (8.0 MB) ===
> > #                      | With THP        | Without THP     | Improvement
> > # ---------------------------------------------------------------------
> > # Sys->Dev Migration   | 4.535 ms        | 4.563 ms        | 0.6%
> > # Dev->Sys Migration   | 0.583 ms        | 0.582 ms        | -0.2%
> > # S->D Throughput      | 1.72 GB/s      | 1.71 GB/s      | 0.6%
> > # D->S Throughput      | 13.39 GB/s      | 13.43 GB/s      | -0.2%
> > #
> > # === Eight THP Size (16MB) (16.0 MB) ===
> > #                      | With THP        | Without THP     | Improvement
> > # ---------------------------------------------------------------------
> > # Sys->Dev Migration   | 10.190 ms        | 9.805 ms        | -3.9%
> > # Dev->Sys Migration   | 1.130 ms        | 1.195 ms        | 5.5%
> > # S->D Throughput      | 1.53 GB/s      | 1.59 GB/s      | -3.8%
> > # D->S Throughput      | 13.83 GB/s      | 13.07 GB/s      | 5.8%
> > #
> > # === One twenty eight THP Size (256MB) (256.0 MB) ===
> > #                      | With THP        | Without THP     | Improvement
> > # ---------------------------------------------------------------------
> > # Sys->Dev Migration   | 80.464 ms        | 92.764 ms        | 13.3%
> > # Dev->Sys Migration   | 9.528 ms        | 18.166 ms        | 47.6%
> > # S->D Throughput      | 3.11 GB/s      | 2.70 GB/s      | 15.3%
> > # D->S Throughput      | 26.24 GB/s      | 13.76 GB/s      | 90.7%
> > # #            OK  hmm.hmm_device_private.benchmark_thp_migration
> > # ok 1 hmm.hmm_device_private.benchmark_thp_migration
> > # #  RUN           hmm.hmm_device_private.migrate_anon_huge_zero_err ...
> > # # hmm-tests.c:2622:migrate_anon_huge_zero_err:Expected ret (-2) == 0 (0)
> >
> > [  154.077143] Unable to handle kernel paging request at virtual address
> > 0000000000005268
> > [  154.077179] Mem abort info:
> > [  154.077203]   ESR = 0x0000000096000007
> > [  154.077219]   EC = 0x25: DABT (current EL), IL = 32 bits
> > [  154.078433]   SET = 0, FnV = 0
> > [  154.078434]   EA = 0, S1PTW = 0
> > [  154.078435]   FSC = 0x07: level 3 translation fault
> > [  154.078435] Data abort info:
> > [  154.078436]   ISV = 0, ISS = 0x00000007, ISS2 = 0x00000000
> > [  154.078459]   CM = 0, WnR = 0, TnD = 0, TagAccess = 0
> > [  154.078479]   GCS = 0, Overlay = 0, DirtyBit = 0, Xs = 0
> > [  154.078484] user pgtable: 16k pages, 47-bit VAs, pgdp=000000010b920000
> > [  154.078487] [0000000000005268] pgd=0800000101b4c403,
> > p4d=0800000101b4c403, pud=0800000101b4c403, pmd=0800000108cd8403,
> > pte=0000000000000000
> > [  154.078520] Internal error: Oops: 0000000096000007 [#1]  SMP
> > [  154.098664] Modules linked in: test_hmm rfkill drm fuse backlight ipv6
> > [  154.100468] CPU: 7 UID: 0 PID: 1357 Comm: hmm-tests Kdump: loaded Not
> > tainted 7.0.0-rc4-00029-ga989fde763f4-dirty #260 PREEMPT
> > [  154.103855] Hardware name: QEMU QEMU Virtual Machine, BIOS
> > edk2-stable202408-prebuilt.qemu.org 08/13/2024
> > [  154.104409] pstate: 61400005 (nZCv daif +PAN -UAO -TCO +DIT -SSBS
> > BTYPE=--)
> > [  154.104847] pc : dmirror_devmem_fault+0xe4/0x1c0 [test_hmm]
> > [  154.105758] lr : dmirror_devmem_fault+0xcc/0x1c0 [test_hmm]
> > [  154.109465] sp : ffffc000855ab430
> > [  154.109677] x29: ffffc000855ab430 x28: ffff8000c9f73e40 x27:
> > ffff8000c9f73e40
> > [  154.110091] x26: ffff8000cb920000 x25: ffffc000812e0000 x24:
> > 0000000000000000
> > [  154.110540] x23: ffff8000c9f73e40 x22: 0000000000000000 x21:
> > 0000000000000008
> > [  154.110888] x20: ffff8000c07e1980 x19: ffffc000855ab618 x18:
> > ffffc000855abc40
> > [  154.111223] x17: 0000000000000000 x16: 0000000000000000 x15:
> > 0000000000000000
> > [  154.111563] x14: 0000000000000000 x13: 0000000000000000 x12:
> > ffffc00080fedd68
> > [  154.111903] x11: 00007fffa3bf7fff x10: 0000000000000000 x9 :
> > 1ffff00019166a41
> > [  154.112244] x8 : ffff8000c132df20 x7 : 0000000000000000 x6 :
> > ffff8000c53bfe88
> > [  154.112581] x5 : 0000000000000009 x4 : ffffc000855ab3d0 x3 :
> > 0000000000000004
> > [  154.112921] x2 : 0000000000000004 x1 : ffff8000c132df18 x0 :
> > 0000000000005200
> > [  154.113254] Call trace:
> > [  154.113370]  dmirror_devmem_fault+0xe4/0x1c0 [test_hmm] (P)
> > [  154.113679]  do_swap_page+0x132c/0x17b0
> > [  154.113912]  __handle_mm_fault+0x7e4/0x1af4
> > [  154.114124]  handle_mm_fault+0xb4/0x294
> > [  154.114398]  __get_user_pages+0x210/0xbfc
> > [  154.114607]  get_dump_page+0xd8/0x144
> > [  154.114795]  dump_user_range+0x70/0x2e8
> > [  154.115020]  elf_core_dump+0xb64/0xe40
> > [  154.115212]  vfs_coredump+0xfb4/0x1ce8
> > [  154.115397]  get_signal+0x6cc/0x844
> > [  154.115582]  arch_do_signal_or_restart+0x7c/0x33c
> > [  154.115805]  exit_to_user_mode_loop+0x104/0x16c
> > [  154.116030]  el0_svc+0x174/0x178
> > [  154.116216]  el0t_64_sync_handler+0xa0/0xe4
> > [  154.116414]  el0t_64_sync+0x198/0x19c
> > [  154.116594] Code: d2800083 f9400280 f9003be0 2a0303e2 (b9406800)
> > [  154.116891] ---[ end trace 0000000000000000 ]---
> > [  158.741771] Kernel panic - not syncing: Oops: Fatal exception
> > [  158.742164] SMP: stopping secondary CPUs
> > [  158.742970] Kernel Offset: disabled
> > [  158.743162] CPU features: 0x0000000,00060005,11210501,94067723
> > [  158.743440] Memory Limit: none
> > [  164.002089] Starting crashdump kernel...
> > [  164.002867] Bye!
> 
> That 'Bye!' is delightful :)
> 
> >
> > [root@localhost linux]# ./scripts/faddr2line lib/test_hmm.ko
> > dmirror_devmem_fault+0xe4/0x1c0
> > dmirror_devmem_fault+0xe4/0x1c0:
> > dmirror_select_device at /root/code/linux/lib/test_hmm.c:153
> > (inlined by) dmirror_devmem_fault at /root/code/linux/lib/test_hmm.c:1659
> >
> > The kernel is built with arm64's virt.config plus
> >
> > +CONFIG_ARM64_16K_PAGES=y
> > +CONFIG_ZONE_DEVICE=y
> > +CONFIG_DEVICE_PRIVATE=y
> > +CONFIG_TEST_HMM=m
> >
> > I *guess* the problem is that migrate_anon_huge_zero_err() has chosen an
> > incorrect THP size (which should be 32M in a system with 16k page size),
> 
> Yeah, it hardcodes to 2mb:
> 
> TEST_F(hmm, migrate_anon_huge_zero_err)
> {
> 	...
> 
> 	size = TWOMEG;
> }
> 
> Which isn't correct obviously and needs to be fixed.
> 
> We should read /sys/kernel/mm/transparent_hugepage/hpage_pmd_size instead.
> 
> vm_utils.h has read_pmd_pagesize() So this can be fixed with:
> 
> 	size = read_pmd_pagesize();
> 
> We then madvise(.., MADV_HUGEPAGE) region of size, which is now too small.:
> 
> TEST_F(hmm, migrate_anon_huge_zero_err)
> {
> 	...
> 
> 	size = TWOMEG;
> 
> 	...
> 
> 	ret = madvise(map, size, MADV_HUGEPAGE);
> 	ASSERT_EQ(ret, 0); <-- but should succeed anyway, just won't do anything
> 
> 	...
> 
> 	ret = hmm_dmirror_cmd(self->fd, HMM_DMIRROR_FLAGS, buffer,
> 			      HMM_DMIRROR_FLAG_FAIL_ALLOC);
> }
> 
> Then we switch into lib/test_hmm.c:
> 
> static void dmirror_migrate_alloc_and_copy(struct migrate_vma *args,
> 					   struct dmirror *dmirror)
> {
> 	...
> 
> 	for (addr = args->start; addr < args->end; ) {
> 		...
> 
> 		if (dmirror->flags & HMM_DMIRROR_FLAG_FAIL_ALLOC) {
> 			dmirror->flags &= ~HMM_DMIRROR_FLAG_FAIL_ALLOC;
> 			dpage = NULL;  <-- force failure for 1st page
> 
> 	...
> 
> 		if (!dpage) {
> 			...
> 
> 			if (!is_large) <-- isn't large, as MADV_HUGEPAGE failed
> 				goto next;
> 
> 	...
> next:
> 		src++;
> 		dst++;
> 		addr += PAGE_SIZE;
> 	}
> }
> 
> Back to the hmm-tests.c selftest:
> 
> TEST_F(hmm, migrate_anon_huge_zero_err)
> {
> 	...
> 
> 	ret = hmm_dmirror_cmd(self->fd, HMM_DMIRROR_FLAGS, buffer,
> 			      HMM_DMIRROR_FLAG_FAIL_ALLOC);
> 	ASSERT_EQ(ret, 0);                  <-- succeeds but...
> 	ASSERT_EQ(buffer->cpages, npages);  <-- cpages = npages - 1.
> }
> 
> So then we try to teardown which inokves:
> 
> FIXTURE_TEARDOWN(hmm)
> {
> 	int ret = close(self->fd);  <-- triggers kernel dmirror_fops_release()
> 	...
> }
> 
> In the kernel:
> 
> static int dmirror_fops_release(struct inode *inode, struct file *filp)
> {
> 	struct dmirror *dmirror = filp->private_data;
> 	...
> 
> 	kfree(dmirror);  <-- frees dmirror...
> 	return 0;
> }
> 
> So dmirror is fred but in dmirror_migrate_alloc_and_copy(), for all those pages
> we DID migrate:
> 
> static void dmirror_migrate_alloc_and_copy(struct migrate_vma *args,
> 					   struct dmirror *dmirror)
> {
> 	...
> 
> 	for (addr = args->start; addr < args->end; ) {
> 		...
> 
> 		if (!dpage) { <-- we will succeed allocation so don't branch.
> 			...
> 		}
> 
> 		rpage = BACKING_PAGE(dpage);
> 
> 		/*
> 		 * Normally, a device would use the page->zone_device_data to
> 		 * point to the mirror but here we use it to hold the page for
> 		 * the simulated device memory and that page holds the pointer
> 		 * to the mirror.
> 		 */
> 		rpage->zone_device_data = dmirror;
> 
> 		...
> 	}
> 
> 	...
> }
> 
> So now a bunch of device private pages have a zone_device_data set to a dangling
> dmirror pointer.
> 
> Then on coredump, we walk the VMAs, meaning we fault in device private pages and
> end up invoking do_swap_page() which in turn calls dmirror_devmem_fault() (via
> the struct dev_pagemap_ops
> dmirror_devmem_ops->migrate_to_ram=dmirror_devmem_fault callback)
> 
> This is via get_dump_page() -> __get_user_pages_locked(..., FOLL_FORCE |
> FOLL_DUMP | FOLL_GET) -> __get_user_pages() -> handle_mm_fault() ->
> __handle_mm_fault() -> do_swap_page() and:
> 
> vm_fault_t do_swap_page(struct vm_fault *vmf)
> {
> 	...
> 		entry = softleaf_from_pte(vmf->orig_pte);
> 	if (unlikely(!softleaf_is_swap(entry))) {
> 		if (softleaf_is_migration(entry)) {
> 			...
> 		} else if (softleaf_is_device_private(entry)) {
> 			...
> 
> 			if (trylock_page(vmf->page)) {
> 				...
> 
> 				ret = pgmap->ops->migrate_to_ram(vmf);
> 
> 				...
> 			}
> 
> 			...
> 		}
> 
> 		...
> 	}
> 
> 	...
> }
> 
> (BTW, we seriously need to clean this up).

What did you have in mind here?

> And in dmirror_devmem_fault callback():
> 
> static vm_fault_t dmirror_devmem_fault(struct vm_fault *vmf)
> {
> 	...
> 
> 	/*
> 	 * Normally, a device would use the page->zone_device_data to point to
> 	 * the mirror but here we use it to hold the page for the simulated
> 	 * device memory and that page holds the pointer to the mirror.
> 	 */
> 	rpage = folio_zone_device_data(page_folio(vmf->page));
> 	dmirror = rpage->zone_device_data;
> 
> 	...
> 
> 	args.pgmap_owner = dmirror->mdevice; <-- oops
> 
> 	...
> }
> 
> So in terms of fixing:
> 
> 1. Fix the test (trivial)
> 
> Use
> 
> 	size = read_pmd_pagesize();
> 
> Instead of:
> 
> 	size = TWOMEG;

Adding Balbir as this would have come in with his hugepage changes.

> 2. Have dmirror_fops_release() migrate all the device private pages back to ram
>    before freeing dmirror or something like this

Oh yeah that's bad. We definitely need to do that migration once the file is
closed.

> You'd want to abstract code from dmirror_migrate_to_system() to be shared
> between the two functions I think.
> 
> But I leave that as an exercise for the reader :)

Good thing I can't read :) I can try and put something together but that won't
happen before next week, so I won't complain if someone beats me to it. Thanks
for the detailed analysis and report though!

> > leading to the failure of the first hmm_migrate_sys_to_dev(). The test
> > program received a SIGABRT signal and initiated vfs_coredump(). And
> > something in the test_hmm module doesn't play well with the coredump
> > process, which ends up with a panic. I'm not familiar with that.
> >
> > Note that I can also reproduce the panic by aborting the test manually
> > with following diff (and skipping migrate_anon_huge{,_zero}_err()):
> >
> > diff --git a/tools/testing/selftests/mm/hmm-tests.c
> > b/tools/testing/selftests/mm/hmm-tests.c
> > index e8328c89d855..8d8ea8063a73 100644
> > --- a/tools/testing/selftests/mm/hmm-tests.c
> > +++ b/tools/testing/selftests/mm/hmm-tests.c
> > @@ -1027,6 +1027,8 @@ TEST_F(hmm, migrate)
> >  	ASSERT_EQ(ret, 0);
> >  	ASSERT_EQ(buffer->cpages, npages);
> >
> > +	ASSERT_TRUE(0);
> 
> This makes sense as the same dangling dmirror pointer issue arises.
> 
> > +
> >  	/* Check what the device read. */
> >  	for (i = 0, ptr = buffer->mirror; i < size / sizeof(*ptr); ++i)
> >  		ASSERT_EQ(ptr[i], i);
> >
> > Please have a look!
> 
> Hopefully did so usefully here :)
> 
> >
> > Thanks,
> > Zenghui
> 
> Cheers, Lorenzo
> 

