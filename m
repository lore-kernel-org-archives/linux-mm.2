Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0DDA1CCD199
	for <linux-mm@archiver.kernel.org>; Mon, 20 Oct 2025 14:03:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 583428E001B; Mon, 20 Oct 2025 10:03:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 55AF58E0002; Mon, 20 Oct 2025 10:03:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 422F98E001B; Mon, 20 Oct 2025 10:03:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 2F94C8E0002
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 10:03:22 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id E644B850EE
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 14:03:21 +0000 (UTC)
X-FDA: 84018659802.17.F401342
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf27.hostedemail.com (Postfix) with ESMTP id 67F864000B
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 14:03:18 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=DLCbvEYI;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=QGhEqnv+;
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf27.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760968998;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oHDzDTCVUN/ENIO6HrnodaH1vKaHQfZAL7fpMWctNGc=;
	b=oreg721+2GheHtkjnWSCV3wCp99QKLid4zrrlUxapPGbI4OF5t/ZFew3Dc89GF0IO0KXzR
	gwQLOb0b304tS+i7Kihe2yn0tXQp3gZ2v4smafaSjeAJ6I1M69GDFGzJvYmnKVDWuIamtf
	P0Zanyr6gquvKJ/higgMneKx23GnrC0=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1760968998; a=rsa-sha256;
	cv=pass;
	b=RRNC85VX6/v81xJNWyT9CFakwcE2QCi1LRGQNZqEuNrxlkfsbsfZyrkcUI9Ii6tGl4Mrwa
	Gnpu0JYqY3HcX9FFYvchzy6OOqX+1ZXhdPtRZBtanea6AkuJfn39F3Xg08u+EjSsKL5EDR
	Isuo8zaTONpi6VXJk24sEIevUE0oYEs=
ARC-Authentication-Results: i=2;
	imf27.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=DLCbvEYI;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=QGhEqnv+;
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf27.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 59K8SCSY018297;
	Mon, 20 Oct 2025 14:03:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=oHDzDTCVUN/ENIO6Hr
	nodaH1vKaHQfZAL7fpMWctNGc=; b=DLCbvEYIapeHnie5zpiHKfC6EBig+5IxFO
	EYLfw8LHm1IR4qig9DL4L03y3cX6VQD1zySVbGrjcMrRappkzsyX+a8AnGNGoa/l
	sQ9UPntHflaWe2YKge5BpxqkTGsGzI0tiMf5X0CNst2RxwvFYXUQLP3Jr4R4WR/s
	9SLtSF49vCVCZAow+sqXrOobDfyrVgO1N/Q4LjplZ/Y3GLPeawqgNG/0vNnnVGJ7
	6V3s+xh/DDEO8F/kf0jbtlqRZFouCNCNUnjCEX8g82SyERx+51QxdHuRuZEnCJEa
	KNYnCt4vFwLcWJ1WHsA7flhtyqfCu5tYJC4zalmcuyDC5x1Ez78Q==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 49v2watbae-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 20 Oct 2025 14:03:12 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 59KDYx4J032334;
	Mon, 20 Oct 2025 14:03:11 GMT
Received: from bn1pr04cu002.outbound.protection.outlook.com (mail-eastus2azon11010004.outbound.protection.outlook.com [52.101.56.4])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 49v1bbqmtb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 20 Oct 2025 14:03:11 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ptTFYmaotngAs0pbEn1S/z6LXzOUbdmzSr+wKfvoCu5i4Dez1Vh14CGvzu4+9ESl9QbSn5EF65Ow3EOSrsX1sUNxwdhylhOdw4yycEZkgEzAMJmzamRw1XuP+7+LkguqEtfBXM5S7HLiG2avL+BvGJ4bOlHlheb2yPa0oTkUsuqv60eN9+qJV8P47DyBkmMaRoB3V85ccYSE9kaMvzh0FWKsgywRk389UNeidWg5HnRuC5UZeOXR0omBwlMJivHWuhCvbAdHfG0qvsFgtKJiC5MMzD6/fSrwxwINWBlZ79zrqAu6z3haWI4oiHSkeFjdxE9EGEUs7CZely79euk7Sw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oHDzDTCVUN/ENIO6HrnodaH1vKaHQfZAL7fpMWctNGc=;
 b=UyoPlkv5s4vfYpMdBfIHJE6SDIR5DAZeKoi1jDPEqB8HdYXngHifNi+6q/L0L240ni4X5zeXcLIQicaGMWQVEFCpebXM+wASq+x7FTeeMY9EZmI/a9JCcu5aMToEhD7jcsjI30grTZg/YlmWMOnW/InkHrneNttfBgPq79RTpaFyO07rc+a/ITR25ArhaXWOXpIDBCbjzXUxScP8WQFd7CBpdM6kgswGheLtv/2vTqpWnXAG+r5JlCJjtE5ftxagn4sME2uQFdMz05VCVtRi46a5nBmTDZQp7kMgSrwIwwKvwhLsrHjClchqM/7BrGMe2QqFPWNrH9hyNo+h30INXQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oHDzDTCVUN/ENIO6HrnodaH1vKaHQfZAL7fpMWctNGc=;
 b=QGhEqnv+Vq5EW/uewJvCXlQH/bATC28zA9avTlalDb1kV4y2O44vsduAQ5pR8kQspeRVt019fbwx1WOb97xbSAGZLROZnTDAzI+A60KYAUyPXSe+yE2ylP8FjZ4RMe1Fezmb+28nxq5HbxpwFIMW0EPdLtFoZjIKDZPwswTbuvg=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by MW4PR10MB6511.namprd10.prod.outlook.com (2603:10b6:303:225::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9228.16; Mon, 20 Oct
 2025 14:03:08 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%2]) with mapi id 15.20.9228.016; Mon, 20 Oct 2025
 14:03:08 +0000
Date: Mon, 20 Oct 2025 15:03:06 +0100
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Zi Yan <ziy@nvidia.com>
Cc: David Hildenbrand <david@redhat.com>, Wei Yang <richard.weiyang@gmail.com>,
        akpm@linux-foundation.org, baolin.wang@linux.alibaba.com,
        Liam.Howlett@oracle.com, npache@redhat.com, ryan.roberts@arm.com,
        dev.jain@arm.com, baohua@kernel.org, lance.yang@linux.dev,
        linux-mm@kvack.org
Subject: Re: [Patch v2 2/2] mm/huge_memory: Optimize and simplify
 __split_unmapped_folio() logic
Message-ID: <8dadd256-175a-4706-84d0-180eda04ce89@lucifer.local>
References: <20251016004613.514-1-richard.weiyang@gmail.com>
 <20251016004613.514-3-richard.weiyang@gmail.com>
 <7ed84d61-0a7b-4961-82eb-fc8d38b77162@lucifer.local>
 <154924ED-0CD0-458E-B760-F9F0A92CDC89@nvidia.com>
 <d0a2c81b-a0e0-4457-b355-2363f30ecfb8@redhat.com>
 <cdd37933-d2e7-4675-82fe-62b7f0ccdd80@lucifer.local>
 <A67D1276-D59B-41E9-8A88-E54E05A0F479@nvidia.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <A67D1276-D59B-41E9-8A88-E54E05A0F479@nvidia.com>
X-ClientProxiedBy: LO4P265CA0168.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:312::11) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|MW4PR10MB6511:EE_
X-MS-Office365-Filtering-Correlation-Id: 669fbd82-f30e-4c68-c77d-08de0fe165d0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?O6wZNNjz8ZyWjiXSylbg1xxW3i2ZeDMyVfenkwd16Q2WkhmqkWHpv7F9dUrY?=
 =?us-ascii?Q?wwA89EjvZ3R9GTA5NVvgCvuSGydHEQ+pjivz0sKiyImfygGtfaNo823QxT5I?=
 =?us-ascii?Q?yZHHrv7zdu6YtRIzNoQDyR9yjeLcD96vI4YsNY6KuJAYqIYaolzCbj4suJXg?=
 =?us-ascii?Q?aWti7MVMNTbQWZOezzQjm5yuaImuYQP9MiS7YZv+Yps4OfNk/xCS4ZBHXqX4?=
 =?us-ascii?Q?s6B4PUEftoGb8Ej1d16ExrLJlLaXlghNYY/cBybwiXTchPLKlEP3fUYehbKe?=
 =?us-ascii?Q?9WgMQXiXMlH7mUQKZ1OKbrj3Q1l5KXscdtvRrYfaxiO4Uli69dYxDzQ/4VLN?=
 =?us-ascii?Q?Y7VSLuHSNPhtWKqvGirHQiMAA5DSYeYgc7sm66ag1Mm7mdwzxYkbpIIg4mq9?=
 =?us-ascii?Q?YYH5EfJ1LsttpKDC3ZjiwRCwZOY82twnTG0fetJEHJtMOxa6XDpLmj6n6pDe?=
 =?us-ascii?Q?2sXM0ATf/9EPutA3IgiHcV8GRX5xZdAvDecfN1Mb7ixsv/yKGRjThpz7MXqj?=
 =?us-ascii?Q?zLGbzYSLd1UnDWp4OVVwKXnsmNaTk3O1SUvP+NuThN4N9EjeEsrznQPp2TUR?=
 =?us-ascii?Q?Ekp11bvjX20xTcdZah6Eq+/JOwWZt2TgFe24HDnzI1pKuUo5KgkA+dCN4ceY?=
 =?us-ascii?Q?+CamtqiJp/jfGO0xmsQDm2C74WM0JH/iYuNZnjI7ZPz/aqe1vhFQqnTAXR6I?=
 =?us-ascii?Q?2pzVXypa8OYh8BBM5riCVvbnM3zEScanK+RiWwMwVdRDLPE1NozNVKJt/97r?=
 =?us-ascii?Q?aOvPrRNnIxv/MqHBudAQBcCFOKtf98rp81UuHo2nlQUYX7+K3KsPJtjRqP48?=
 =?us-ascii?Q?Os27vv45svzqa3CqLuZMPv3YBVBnwc9sqiPhzHrX3dUTaHyzeKcADxcriqQZ?=
 =?us-ascii?Q?Rjjm+smMsbT47tsJKd+QqqUyTrxBHl9dbny2R7Xn0/e16tZu1cjNbAIjMh86?=
 =?us-ascii?Q?KmM/jbT/GpTCfxE64trCtk06jt1OArHCm5WlEyOZUxrwPFs1VMmVUA6f6MTj?=
 =?us-ascii?Q?rgYPNBFqEBVfZTwr8Khg1qtFJKX8IXY3JgeSg96uVLTBzyEx6E9EUyGjk3eB?=
 =?us-ascii?Q?2P8Tlte3dNmGbFlqWPY5hwmSUUYeMipOWS/ruCU6pyOqLZIfJ0AIkx02gguu?=
 =?us-ascii?Q?r1ed3ktvTGSPpVWq7ptL7WRtGzyJm/XcIfeepj2RMMsHEdPNMUv+zKqN8KSo?=
 =?us-ascii?Q?WoEPtf2yTu3mZ7y6nJ0U6Wf3GMmS7rLWoNqpcDOvhIkmj4irDNj1WPh3BTbL?=
 =?us-ascii?Q?0Wz15C3LUZkXp0ihcfWPkuD6VcjqeEpsicVOxLYHlX/ndXhcXpnffOJYWhGW?=
 =?us-ascii?Q?RLB1wMxzswHKARtxHP6IunZx9DLhECI1YYsmCOsRP9rJNTwKh5ZCJ7bBTTvN?=
 =?us-ascii?Q?Z8yf02dMMsKgQFedOxXdQghnlPd7nxKNiEAQZKvntmjeh8NWZA=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?C6qmw8ItewSNMnQPigRF2HZklXqn/TsNjPG+64fTZf/sAwrvZ5ejbvFnfnCW?=
 =?us-ascii?Q?UWTu02gWVY/YaDCvvE4lR5WYkmvx8P7t6zNchPMpv1riiXz30xZP67ewykjR?=
 =?us-ascii?Q?MlbjcOwahORC+5Ugmnb1UQ7O4hm4oAVpqLfjNGGOSrFhxPSQf1RcUT2o5dsm?=
 =?us-ascii?Q?oncAuPXEOExhiYyo8Vb17gonYCmuV5t23OXxeaxVF7UZoQYD3bUA2IBCPx38?=
 =?us-ascii?Q?VQzyExOtrMoPocnzh9wEm8ajF3SlvMoVwsF/hMVAnnsfD/xov4gIzQQtXi+4?=
 =?us-ascii?Q?O1ZzEyPSnwvCUe4eyo/t+X+Wi++Bd0s3bHi5GY+KpQ1CPV4t7uC5oQdzo3ed?=
 =?us-ascii?Q?1YOq2qXWBeD4JbUGadXL3B1nBz9JUEb1mFBwLLNzKkeQY+CVGbxuNy0KDUew?=
 =?us-ascii?Q?wdTedgN2ob1mHCd8020En/KcmhNHrjgamNJUowe1khHebq/PLq7zjTBDNMeO?=
 =?us-ascii?Q?mbWO1PhUaBnxzj+C1U7gEI0uSpQxloQJj6a7t4dOINZFt8qNM4JR6qjUmjaQ?=
 =?us-ascii?Q?ybPmaOwL8ahHGolDsvUxb2T7OwRu4WgukBRihpqsWoR/kwGluUS/7TyV6gwq?=
 =?us-ascii?Q?gmb6DxGoyx8iR0mc+NrCW9T6EyxlnAcBWWqfClwRayB27ku1rflP4CBd/4an?=
 =?us-ascii?Q?Ei1+1eTdKsJLBLyqbbHs8mntE/E314sKvoQvKWU2sYBIP66M/qW3uW2xgTx1?=
 =?us-ascii?Q?WXsjYwjKwvyUrJxJuXNezT9hlDT7Z1D0QhCJcNY6IO5tRXFhCi8kfcsLp2Ua?=
 =?us-ascii?Q?hTcbFcQjSxFPdGnjXrzj7+RbUVVmN0xJwrYnIAa/trepxybPsuDOyywfGLqY?=
 =?us-ascii?Q?fBcFxzDNIBiIIQxV9pxV46pz/m/kbWQ+OXiwSvy2rBBOYR8d60ZQLYkV+Dt9?=
 =?us-ascii?Q?Gh1d75wvkxh4bVNvsYXgzbPmriy2Ersm5taeq/IzW39NrGie0+RXwW5vMEr0?=
 =?us-ascii?Q?uNEaXUiusLrRQnrIbCJQd6t1kjVJC0U9aPd3gpilqdFiUyO8Ce1SDUjhhqhc?=
 =?us-ascii?Q?z6hVagJkWRqWHmhOCWlHrWkZzizpOgAKHOt3eY4qIWQAaPgQjrr7YSJRnv3t?=
 =?us-ascii?Q?1/2Gwg94vee9W35KVHUIexs+FzCBUcrSuCoqYHq9EEkHPygSpOZ5qgrZAuv7?=
 =?us-ascii?Q?zLAuch43XyBsHRcR/E9WPXyA2UhiSZPNXLPN+FKl9tF+LkA5G2hqvdLArTh7?=
 =?us-ascii?Q?DKLd+3sdT1kSg80KoZs3gR4bMkrMWGANvkEx0N8EMH7zCytPp+JzNoRY5ySV?=
 =?us-ascii?Q?yBDD8uUmyLxVRF1Mglip2H0JSgdB+ylf1U++gosWqLRq4iyyOksWdywIkwop?=
 =?us-ascii?Q?ke23f7QAkgc9EwP4s/QX636+JOj4+QeqCAfJDRjh6tsZY/h/m9tHhF2xiXoL?=
 =?us-ascii?Q?QKFCO3xCoj94sEOXHIsXqWDmUZvqV72vYZGsQ/TRxotVnLYWLUOsb9GDHAXc?=
 =?us-ascii?Q?Np8ZTil+m6jhn7tZXIGExVqu+DQEhC+Vi6ORE9BMA8b7MN4kwTsqOYN7zm6w?=
 =?us-ascii?Q?qCwlwXU68fdXvEnsPlYsjK+10q7wRiN6cAUCK+yH4pT0XBrwNOaHl3HYDYvz?=
 =?us-ascii?Q?axVRA+XHnkRZSFitpy8+H0liJrzfPa+XiCvyYtgRz4olB02Xlb+A+Hr3+rXh?=
 =?us-ascii?Q?0Q=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	E+HneoyPtOTaTogAdxBuCf6o1GwNz+RIt2RTaICAAPmysJ10Rnn9yZ0eN+lCKJxkvEflK0j8GtvljBIK0eRu+uBPSOt+5iI2TYgtSrb51HgodDE4Qt2DcIPQVe+joH9hR/UqLsvELQ56rfOkWXVtDXp28yFsyhg8Z0UioVMZmfZ8vITtsKyfzzpeyGJ8xDRVGKBM8v61pqSQhK96fxje7tuBvFHmIE91Hyu/9/F9Nn3POM/We6Ey1EFqEGPNQsujgrd5Loh2IjTZrcnhySzKjoBCjvfl1aI7B+UrM0/cHDCykTYXKaPXrMQ9DoMeVAcjoc4ObLmzX9VxSPYsraq/3XzM7Q6GwQkBf+iRJfURs5rKVXqGdQ8PWUfOBGa4PXsgVBKxXFj2NAA0msV6bw3RHOVzUFhb0ivCBgWhHCzGBYg9k35tnyohM07YPp5VWkUNv+94W7kULEFpeWyVLiUUetEDjGsquvLtnpjg0hAOoiyop0R0xeGBQs/513A3BdMdHI0nAceXGIB1DhpMyvqUakltsa/ADaxm70JavG4wm5Ax3Ua0UFJzenOqpSGvUAB1ore4hZ+Q2VPQFuF+fMa0Qe0iF/hBOsbXPGmZAgM2J5g=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 669fbd82-f30e-4c68-c77d-08de0fe165d0
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Oct 2025 14:03:08.5084
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rfHKHZ8ksDUv2Wb1APm1Bjki7qxgldBzo/D0uWkbuR3mZUbu/cqao3ThROcLksIC3JpXEv6bEGuumRssO4SNW2DtIVSNsBkX4/yVomVsvJE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR10MB6511
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-20_04,2025-10-13_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=999
 phishscore=0 bulkscore=0 mlxscore=0 adultscore=0 malwarescore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2510020000 definitions=main-2510200116
X-Proofpoint-ORIG-GUID: LaOPx0JLLeLx2vyiwhy1y-FzVirTZW9H
X-Authority-Analysis: v=2.4 cv=Pf3yRyhd c=1 sm=1 tr=0 ts=68f64120 b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=x6icFKpwvdMA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=P-IC7800AAAA:8 a=yJvm__zhgca5vBAywUgA:9 a=CjuIK1q_8ugA:10
 a=d3PnA9EDa4IxuAV0gXij:22 cc=ntf awl=host:13624
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDE4MDAyMiBTYWx0ZWRfX3f5gwH7JPNqt
 bVFHHlHkV+xBVUJ5URHUwpMG30VKPnGnDpLybAv7ql5jXPTQ1MCUaIdD1OIVTBqw6nVFZDOOM3m
 eX8rpUgZvUZpDRyc0i6ZowZfzj6MXZ3bReYCiEyHepoG9HkPOaJu0rbMJcfUgM31BnBJcnRvybJ
 lZ/nxfJYkMHf6KbtcCF4qkehSLkZwO9c1fA9t0/4+aELZhBUw6EHyh1kWMZsax7rJYMCANaCv76
 sMJJO1bOMzLYhJaBYMdiagjwQqo6vqpcLG3C7fGBFrdUiiF2iekm0IdeKMSLThcdPtCOLzhDmMO
 sjN3xyJ80yNDqkjqxLan8fQOuxbK0ay8jamKYpf4wk6WDQ4lDNH7vxl3n4ySel2TGiuC3TCBHQG
 Dj2sutB0tF+SPDJj4bo9BmrVtFzvSq8yeTaVSw45pdDYjNCooWc=
X-Proofpoint-GUID: LaOPx0JLLeLx2vyiwhy1y-FzVirTZW9H
X-Rspamd-Server: rspam01
X-Stat-Signature: 6kkg6gfsrgoiixt7cmza3gmwauexi6de
X-Rspam-User: 
X-Rspamd-Queue-Id: 67F864000B
X-HE-Tag: 1760968998-707626
X-HE-Meta: U2FsdGVkX181Z1Vl3OgfUPm8ScBMr9+1iBz0T9sH9auuVDG93KdSxnN48DW189XMpcSLOC4qJhB3NqVCjkafpxqIoZgZRkMe4ckfIgGSGkdGFNBfHFseUqPW/XDDpTsjbUgaj+INkSGuHS6SEPQanPCzwXn1x6YqAcGR9y5OWBJiLgMcKS8PMPnzFZVIckGqL3oUJfIJ8JJgkfHBX4dmv95AyCGaD+VIdec5hLvfH52aLRn7X6EQzTmHV1yZxh+8r9dajAG4HMZEGGdPyJbpeyRl3DrvtGs96RBCcG4Yai7G7dfKUHeKtX5xvm++diF3F94PaOUvhmSnzRO0ojxVvaae+GvPySIaOE0kfahjWl4TR9Kptk3zmG7ZpNOrJ5PhptDQr+t7VtaSsis/g6hd5/YzKrpdRYhN3gnxlhyEfzQNPeQRt3mWEgF1gEpKbDHjQJqAlP/MfiUmyZ8a8I4mNLsxavlzZxAEAIjpanCSsSmrzSlZG2qDGeNIru6Pn9tDXRMmQW2mT5pwb+NiyOq0y7Wa0oGIRoZsa8sf8BhhlN0QDIDjpP8wdReST1cLkL2tk2s5Pj9nBgLu2qwAV3MavOBqsBETrasDglJNM8heuDhCIXiO1pt6DnRltM0vLu/bHmJ/t3tPrnAc7vAJPzXEw+KS3FQ0j0VN6MeKBD2LVyFMQdiDJ+kfhPTv9gl//FOkOAhqv3lSzCit4kzCBExQLfWFIhKma+yYpIPJzuzP6pPaqmp9iF7+pb/n7X9QEabrCVt2/vxSqRLD5WtSHuW9w+b/DlykoYXvemy0zufKz2Ntb1i+j89cGPJM/AKAxzw/wDujphpK0hzAdKpd9hZVtMQlfuewOuYsyMQtHZv29NB7vOmdqMlWLZVCGzEarJRX21PEPki2jHtiaaEofVNntoir5o9A0dvt039UK/LP/BHRLvLxMSP27JZ1LkEmoRNHZg31Y/yOm7NWEeOi9Z2
 5vSVCz0U
 1El8bnH5TUPe2U7rq9kOzHCabV47HodrmruU7DYtEm9Ot0vuaHuJ4tyo7mUQIIlyB6Ne6H/uC6DycRc4MHFu05PmxmnBVzoBF3iV4NlWWwnoQhCAcFE83axY+1KfFmocPjh++52I6vQxvbhyE1OX/wpfos1CKCXx17kMqZNGo7wVdacOFXcV+6C2s0b0x65nY+tG7GQHJo6d93qDOYAP88IKZ9LgNVWPbiJHfMqFaRE2fDIrhGHv/jCYkJxo2g2XUAPnXRDf2uCNfy6ys7347Mtlljls+ByDmwFxPeFP3A+d/nGOWPVKtqr6SNuHEygr8rkmojPTSaVR753kDdM64wiRP9rqi6ZjcVgtqphnYie7adQCfo8asabJOpfhsq9D2ERxg6qmT+L+vOnc9KS6mDMjs7dhADII2qGHh+Rh5Rvv3Da1p5yHL21foVM4C/RNzB+f5AvY4R+EXO7/BDBJbft7B6XuArbdb5m8NQ+JGlui0l+Jfo7pbSmv3YCp7XdKFNT7DRqSrVyq4A1r8aHvkBP7cgLZkL2JMT3E/gt/m84GHmFV6ONG96Sf4R7oFBwcMDXwt0AKvlVTnULIsrLYY2fPyAzUi1rsOOW3se7tMw6QjryyNs6jgHMGmkaBx92OsEklVKqwcUQOD7tmnH4wDdA0oktY3PlW7pjYgcAU0PABSLhIlD9CA6cCC0h7wNEFOuelX7GJjtcYKZZTkOczOArx15z1L7Cv2Wm1t/McZW/CEjZim3XdINLxg+TBRE7AK0ovXRhW9v7ZYtT1EU80KJ2EHyhtI8swQlfT8n4MFpYYEXlI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Oct 17, 2025 at 01:24:37PM -0400, Zi Yan wrote:
> Let me explain the changes in details below, so that we might find a
> good way of splitting it up for an easy review:

Thanks, much appreciated!

Looking through it seems to me there should be 3 patches:

- Getting rid of the trailing loop
- Stats fixups
- Remaining trivial cleanups

Do you agree?

Each can have a commit message that describes in detail what's happening
and why it's ok.

This is also useful for bisection purposes.

>
> > diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> > index 4b2d5a7e5c8e..68e851f5fcb2 100644
> > --- a/mm/huge_memory.c
> > +++ b/mm/huge_memory.c
> > @@ -3528,15 +3528,9 @@ static int __split_unmapped_folio(struct folio *folio, int new_order,
> >  		struct address_space *mapping, bool uniform_split)
> >  {
> >  	bool is_anon = folio_test_anon(folio);
> > -	int order = folio_order(folio);
> > -	int start_order = uniform_split ? new_order : order - 1;
> > -	bool stop_split = false;
> > -	struct folio *next;
> > +	int old_order = folio_order(folio);
> > +	int start_order = uniform_split ? new_order : old_order - 1;
> >  	int split_order;
> > -	int ret = 0;
>
> These remove unused variables and do a order->old_order rename.
>
> > -
> > -	if (is_anon)
> > -		mod_mthp_stat(order, MTHP_STAT_NR_ANON, -1);
>
> In the original __split_unmapped_folio() implementation, I probably
> moved the stats in split_huge_page_to_list_to_order() (now __folio_split())[1]
> in to __split_unmapped_folio() and needed to handle xas_try_split() failures,
> so left mod_mthp_stat(order, ..., -1) here. It should have been put
> together with mod_mthp_stat(new_order, ..., 1 << (order - new_order).
>
> [1] https://elixir.bootlin.com/linux/v6.13/source/mm/huge_memory.c#L3622
>
> >
> >  	folio_clear_has_hwpoisoned(folio);
> >
> > @@ -3545,17 +3539,13 @@ static int __split_unmapped_folio(struct folio *folio, int new_order,
> >  	 * folio is split to new_order directly.
> >  	 */
> >  	for (split_order = start_order;
> > -	     split_order >= new_order && !stop_split;
> > +	     split_order >= new_order;
>
> stop_split was used to handle xas_try_split() failure, since the stats separation
> I had in the initial code, I needed to add the -1 stats back. Now with Wei's
> change, subtracting old folio and increment new folios are done together,
> stop_split is no longer needed.
>
> >  	     split_order--) {
> > -		struct folio *end_folio = folio_next(folio);
> > -		int old_order = folio_order(folio);
> > -		struct folio *new_folio;
> > +		int nr_new_folios = 1UL << (old_order - split_order);
>
> stats for counting new after-split folios.
>
> >
> >  		/* order-1 anonymous folio is not supported */
> >  		if (is_anon && split_order == 1)
> >  			continue;
> > -		if (uniform_split && split_order != new_order)
> > -			continue;
>
> split_order is always new_order when uniform_split is true, so it is useless
> code.
>
> >
> >  		if (mapping) {
> >  			/*
> > @@ -3568,49 +3558,31 @@ static int __split_unmapped_folio(struct folio *folio, int new_order,
> >  			else {
> >  				xas_set_order(xas, folio->index, split_order);
> >  				xas_try_split(xas, folio, old_order);
> > -				if (xas_error(xas)) {
> > -					ret = xas_error(xas);
> > -					stop_split = true;
> > -				}
> > +				if (xas_error(xas))
> > +					return xas_error(xas);
>
> xas_error() was not returned immediately because the -1 for old folio needed
> to be fixed later. Now since the stats is not changed upfront, it can simply
> return.
>
>
> >  			}
> >  		}
> >
> > -		if (!stop_split) {
> > -			folio_split_memcg_refs(folio, old_order, split_order);
> > -			split_page_owner(&folio->page, old_order, split_order);
> > -			pgalloc_tag_split(folio, old_order, split_order);
> > +		folio_split_memcg_refs(folio, old_order, split_order);
> > +		split_page_owner(&folio->page, old_order, split_order);
> > +		pgalloc_tag_split(folio, old_order, split_order);
> > +		__split_folio_to_order(folio, old_order, split_order);
> >
> > -			__split_folio_to_order(folio, old_order, split_order);
>
> No more stop_split, so all these are unconditional.
>
> > +		if (is_anon) {
> > +			mod_mthp_stat(old_order, MTHP_STAT_NR_ANON, -1);
> > +			mod_mthp_stat(split_order, MTHP_STAT_NR_ANON, nr_new_folios);
> >  		}
>
> Update the stats when the actual split is done, much better than
> the original one, which assumes the split would happen and recovers
> when it does not.
>
> >
> >  		/*
> > -		 * Iterate through after-split folios and update folio stats.
> > -		 * But in buddy allocator like split, the folio
> > -		 * containing the specified page is skipped until its order
> > -		 * is new_order, since the folio will be worked on in next
> > -		 * iteration.
> > +		 * For uniform split, we have finished the job.
> > +		 * For non-uniform split, we assign folio to the one the one
> > +		 * containing @split_at and assign @old_order to @split_order.
> >  		 */
> > -		for (new_folio = folio; new_folio != end_folio; new_folio = next) {
> > -			next = folio_next(new_folio);
> > -			/*
> > -			 * for buddy allocator like split, new_folio containing
> > -			 * @split_at page could be split again, thus do not
> > -			 * change stats yet. Wait until new_folio's order is
> > -			 * @new_order or stop_split is set to true by the above
> > -			 * xas_split() failure.
> > -			 */
> > -			if (new_folio == page_folio(split_at)) {
> > -				folio = new_folio;
> > -				if (split_order != new_order && !stop_split)
> > -					continue;
> > -			}
> > -			if (is_anon)
> > -				mod_mthp_stat(folio_order(new_folio),
> > -					      MTHP_STAT_NR_ANON, 1);
> > -		}
>
> This loop was needed to update after-split folios in the xarray and unfreeze
> folios, but since last refactor, neither is here. And the stats update can
> be done in one shot instead of the originally one by one method. So
> this hunk can be removed completely.

Which refactor in particular? This is the bit that really needs separating as
it's the most confusing and begs the question 'why can we avoid doing this'?

>
> > +		folio = page_folio(split_at);
> > +		old_order = split_order;
>
> These two are for non-uniform split, where the code moves to split next
> folio after it splits the current one into half. And the old_order needs
> to be updated, since the folio has been split.
>
> For uniform split, the for loop is done once, these two effectively does
> nothing, since the for loop ends.
>
> >  	}
> >
> > -	return ret;
> > +	return 0;
>
> xas_try_split() failure is handled above, code should always succeed at this
> point.
>
> >  }
> >
> >  bool non_uniform_split_supported(struct folio *folio, unsigned int new_order,
>
> --
> Best Regards,
> Yan, Zi
>

