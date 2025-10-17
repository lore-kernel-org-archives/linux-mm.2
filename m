Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 47EADCCD195
	for <linux-mm@archiver.kernel.org>; Fri, 17 Oct 2025 08:48:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A5DE08E0050; Fri, 17 Oct 2025 04:48:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A35068E0016; Fri, 17 Oct 2025 04:48:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8FD498E0050; Fri, 17 Oct 2025 04:48:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 7B2F88E0016
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 04:48:02 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 2C3C511A6D5
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 08:48:02 +0000 (UTC)
X-FDA: 84006978804.18.3C117E3
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf26.hostedemail.com (Postfix) with ESMTP id DFC9414000D
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 08:47:58 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=gmldD4Rj;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=hsvNMlkS;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf26.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1760690879; a=rsa-sha256;
	cv=pass;
	b=tQc5TRk3VUbbXdpto4WT0TEIbkjtRjgk0BBo3kBq0Wx+o23k3VFENVvAkxWnZ7FUDjAZT7
	tMteR3+Js4x0Zv9akxEHwsGiE4NDromhlhfvoFIyxUikn1PXpsFxudjsmh/4q5DjWmNdl4
	wdIQiQwnhvjZcT/Wz89k/6r8LiIBGuw=
ARC-Authentication-Results: i=2;
	imf26.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=gmldD4Rj;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=hsvNMlkS;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf26.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760690879;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=exMiA9lScmmSXTrg6mnxynrbA64Z8/RTjghEx6COajs=;
	b=0pSEOpyVHSskTdKxIL3J5dhU8AYH5aa5RB3+V/ToTG7c0uql5FbnBDbO247Vv4O03OpdgI
	qHmATdjPhd8V61LrrOVXqd5xIBOoFnlDS2vYjEvzfXr9fgGC19q1kHUKq0blZL5Hc0cKTj
	hWXIJMVVDha6yrNWUzTgyvtIk4R4mPs=
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 59H7uCGY007977;
	Fri, 17 Oct 2025 08:47:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=exMiA9lScmmSXTrg6m
	nxynrbA64Z8/RTjghEx6COajs=; b=gmldD4RjWVMiM1SZPv3gX/YHXcAR75tYaZ
	W2x8yYXmZ2HkIhnvkTVw2ozjM9k2Y2CuF8YospKslPhJSHJT6TLWAVwtmblPA7+t
	hTHzgaPcKDt5bFAorKRhxKvkYxhqDmUccrQC9hupnryaodw5bmcI8TY64CClDb/d
	9bxopQ1HZGwmDGfym4KLmtsYBpQUT/NKAwyuGo+JqfY4a6XZAEdYhjN/kLv/c5JO
	M6OeaMXGiLugGhDMFxvKiJP11w45HOKM44PQos1SQ+ZZI+AU5joBppXDE/P+EDXR
	pV+jTtyXf8gV9bZsW6UbTgV5ip3I/KPEhQn0u3rw8+R+njLIlnUA==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 49qdtytkkj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 17 Oct 2025 08:47:49 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 59H8fCsG002251;
	Fri, 17 Oct 2025 08:47:48 GMT
Received: from ch1pr05cu001.outbound.protection.outlook.com (mail-northcentralusazon11010044.outbound.protection.outlook.com [52.101.193.44])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 49qdpjsqyw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 17 Oct 2025 08:47:48 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=OfMGKL4pUekSw/RmiBhTMCNjk95Wu5kyp8sgxiuv0WxQl9MeHDNuNR8WF+cONmadNvnOXH/lqK5Lv1X2hk9ZIfFZhgxzGVAZ5mVi8t4vRfrUZqy7JxcQWA6BoRUt+ISmzDtgJftvyPHuJK8xOdO5JGx4KwG53UFU3rLjuzT9KGnkwa1PNa1H6g9oIlsx/qBL/O6SjfoPQM/yBqdE9DVtCOmPxkwG66KHUZeJzSiCKI+L9BwFcCWwk0K0/4jGdwzOokHieBH4XGc7XJZEZcSgUbkbKMWDgRuP0C6+CGxHsey4mVIxcKsChR3QYiTKNrZl4iljlSVpyyTiJlxEE0ecWg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=exMiA9lScmmSXTrg6mnxynrbA64Z8/RTjghEx6COajs=;
 b=ZUwtlIXqI6O50ap2fOTv6j6rexymX4/tYrFmMAUUMnqjk+KCvavBE0oILfMjwKctheqSPdHyzZRublFIZXnJehffQPq06IWMS2PDzn+HCeIJqqvoM7mBJDSFk9HXYjSSf0Xy6gXgveK+QJmnqyM981OhUfU27MRPSWpsB28FRg+bwThUS6WFwAAILg/nIlsMH2xvd/Kiks8IeofKscgjS9xvDPG5VNLIJQMQxWtqmRMHdonHRZ6O4V4JgSlyhN+UwNy6I+hV8Ol1RuvM9ZdXEnHxjwBEurZ970OQ9GNAv9e8bFdnzXD7kpEbbhuE9/p0OPG558U+HrZhWIbPON0Iyw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=exMiA9lScmmSXTrg6mnxynrbA64Z8/RTjghEx6COajs=;
 b=hsvNMlkSN14G3jWfob5fPABmL1o61Jic9oCawpDg5jT171qzA6BhNmUcWIBsuXMovkDi5SR1S6mK9YMfUh+l+qSWLZXYA2qc+yaEq+3EMdGAxbk7b/4yo9I5bXVUIuxUF96H4WLHKee6+Tndu32eJnMQq4Kx9bagHV9rKuxBgc0=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by DM4PR10MB6862.namprd10.prod.outlook.com (2603:10b6:8:105::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9228.10; Fri, 17 Oct
 2025 08:47:44 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%2]) with mapi id 15.20.9228.011; Fri, 17 Oct 2025
 08:47:44 +0000
Date: Fri, 17 Oct 2025 09:47:42 +0100
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: David Hildenbrand <david@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
        Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
        Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
        Liam.Howlett@oracle.com, Sidhartha Kumar <sidhartha.kumar@oracle.com>
Subject: Re: [PATCH v3 2/3] mm: mprotect: avoid unnecessary struct page
 accessing if pte_protnone()
Message-ID: <34993f2e-b491-46e1-aa4c-10b2451d9be1@lucifer.local>
References: <20251015123516.2703660-1-wangkefeng.wang@huawei.com>
 <20251015123516.2703660-3-wangkefeng.wang@huawei.com>
 <db3fedc0-6ed3-429d-b124-d1e67992d6f8@lucifer.local>
 <2c2a9527-e52b-46db-ac8b-b13f4ba6d0cb@redhat.com>
 <fb525b11-c60e-4a97-a5ed-be0792957ef6@huawei.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fb525b11-c60e-4a97-a5ed-be0792957ef6@huawei.com>
X-ClientProxiedBy: LO4P123CA0419.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:18b::10) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|DM4PR10MB6862:EE_
X-MS-Office365-Filtering-Correlation-Id: 539cba4d-4625-468a-6641-08de0d59d6ef
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?xImDLmRdkp0L3K6liB4fubEeeqtx7so4q+UihdnHinFcpEh/Y00K0f2xxBsk?=
 =?us-ascii?Q?ENsBe5DKYIUamTUHRzKVSilsz5ivaD8O6P6bweJtePsr+naVOhdTYbM8Vojw?=
 =?us-ascii?Q?n0QzlQhiDzLX4P8l6y7Dlnx6c20fwSb9UyD+29kW4Q1EQ1zymV12+MiCct/v?=
 =?us-ascii?Q?7dASgvnUePDO2hq268sQ8sPPneZQniPFatSBmJ0NxYUwawIJBNzES6JddDNa?=
 =?us-ascii?Q?QDNmzXFRcbvBkza2jxkJuq2M7ZGNmgwCn+UKKNfEVJnZdadx6WPl2VRwgoT2?=
 =?us-ascii?Q?fFvL8jBo58YEcc2ofTGdsoxqjNTdWjX+YQF3sylrOi0yLaW1MiT+GspSADky?=
 =?us-ascii?Q?lga1M9VK5LfmFhd7NkkEl/TQBO0OkJA+ew1ULRvkakuF7Z1GwzR5jeyWW4oy?=
 =?us-ascii?Q?t+f3iFTFL1/ZJR2FefaAm8cZ5dL6oE5aUrPUEaQuGBV9OdbZXXeLDoU169Tb?=
 =?us-ascii?Q?wScCos02DaJjGdEeBblzTBEH3MfbitSLAEN8eF+SBdQMNfcA91kEsb+WB49M?=
 =?us-ascii?Q?waR9DcGVO1b1zoGz1s8TowibnovlBsBmA6hIZbKTsNeL3HFSppKLh3uEJKhN?=
 =?us-ascii?Q?9s4q3JnzFiVNONq7rwbGuUwmsuvB2VRSeBW2Bm6eXHzZucvpKjZywvYuhr0i?=
 =?us-ascii?Q?DhPFSZpAI3JlhMHJ0Yg7ltkG/+9PuA2n2R8Ija/6T+Djp4HUSB9dmiVyaMLj?=
 =?us-ascii?Q?Z94cOUhWvCyUzJFvoAQWRL0cWaoPY1PBxQUuWGiFvbgEfEC9JNIh9St4Fosb?=
 =?us-ascii?Q?5ysqxwr+SCqEhcYqccSnqn95PhW31bDcP02mbROKC+n/JfnEuLj8/KzrEBq8?=
 =?us-ascii?Q?tj8qXTmOjCy2bL8oX5nANQXDphFxL27OaVTCliDjQL3Vc5ppZxy52T4Kt8Ti?=
 =?us-ascii?Q?cPnHVgwUrh/QXILBLKsvJ2c2IqyptJ7AZhg2WPQPRkLn+SfM9Zh903+EeMVe?=
 =?us-ascii?Q?rJ38PTbOS4lKDXdpQykcPo7B3Gy5949iSkrbA8yWGwpxyndvXdllW7clKYal?=
 =?us-ascii?Q?8eDuAQ0rr+yAok0RXten9M7JN+/8nQXvHT2InRun++O7qyYKewC0xIXxGML7?=
 =?us-ascii?Q?2dbSyyA09TnmC5wPKIN9d263hAAnU+pHY2JinB2k34W242dcFLYXpzLrAWAv?=
 =?us-ascii?Q?IAJMlUUWfr7/fwFE6Q9nZT1o7a1pz2d7gFpLPSduJsNxbNRs0o23739jvUdL?=
 =?us-ascii?Q?lFRAXJT62/yexIqsWirbLsT+x4FkmjSXBYqkWzcCWbjMDkyFmSfOfk4gq2x+?=
 =?us-ascii?Q?fgZun2AF6/zhre1Lud8DyykYtRR+1MlzrMmKEvcuZuJ2NQZsLrTA7sKq5lbC?=
 =?us-ascii?Q?PbqtzxSUYoRCz2KKjJdfDd788m7WMXQOBH5UvYZQh2p5WoV+ByqYgpaoZNvI?=
 =?us-ascii?Q?pqEW7RTCwzMX9HgBROtU9FVTq9qeyboZFJFABjBLa0TfGmyB4wBY4qEtE2c3?=
 =?us-ascii?Q?Gt22RXIovZjr0FH4VBvFsEG2Q3EGhgia?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?zhPLpeiLa8VQ/gkpyT9jhfWjooaLwCJl7Q4DYi5g5FWlKMM5ahfDkvb0AIxv?=
 =?us-ascii?Q?njGHWOJ+LKugHFx/buWyeQ/uE+9GA80jiFt108YyVDFWpLKHRBxV9t8AN1Hv?=
 =?us-ascii?Q?41qgQvaN8RAe5RoLRS+Szs9hp+2n+YS7jytpBsdYr8E71k3XYw+5Vnz596Qv?=
 =?us-ascii?Q?Yv6lOa436iv7Hf37FWgFb2aj0iLzDD+U291UxberHFR17mB10myNwRMm56oP?=
 =?us-ascii?Q?IYP4JFX0AtP0N/8EeCFcYpmkS98GWEsaCfhEN+cE4qjWTqjcvXcUteF2I5gR?=
 =?us-ascii?Q?tKoqAbQBEwR4LWBz6j5h8je8BOM1mXJ9QYhPu3QwbrQaxONenTSaooJl7ctU?=
 =?us-ascii?Q?+VR+gVz7ZLnM+7+HmfORX/y2sLrhDO9eynKsPyffJpMai3wC9mOlEoTHb7eb?=
 =?us-ascii?Q?JR9lgJclIJdR77TaNWgWOuHmyGVIa3Xl+9ARJuabRTtUH0cxI+OKnAYosxK2?=
 =?us-ascii?Q?koIE8eNRCxToGG1Ryak84trJpaHDLto+Zk/sadKiEEOKjDMpPtSN67AXWLNc?=
 =?us-ascii?Q?9GeJtoz1B1hIQvFgCwC2WgnDM1WRYgEhf8TOIA4OxlBB4J9AdJCaTgdqDYSV?=
 =?us-ascii?Q?9MEaw3tvAetb+7+HE0foZcilo4r2CFM8nr9/1v5IcEjroTZ2eoor9kNIdMqV?=
 =?us-ascii?Q?REgjxH9l32DO55BqZZ2JeBzXxNeCuJXbXfeZDsCVwxgHs9BCFmsyQEknK74B?=
 =?us-ascii?Q?7eN2aT6VG3AENQFzKEcOifSAWZNl8ql92BnahgAAmbmuUqcEEuJMOGeXhm9Q?=
 =?us-ascii?Q?Ke0KBBlScUg/eqFEuEg0jNCoFnBdMd46F5o2Sb6j5LXm9hf2snNxiVMs3Mey?=
 =?us-ascii?Q?4u02rDrokol0yrC+hLw0MS5yz0mPTI3mrn5kBDB3Pup1kQmqZgiq8J3Zznm1?=
 =?us-ascii?Q?U6ASn/HjVmAqywpUhPtIjL2abyYKQFn9dYeAV5vrjf62ObB4b2OJor0IlFZh?=
 =?us-ascii?Q?IRDhfA8lHNZ8Wt16X+mUjwyw6xiGIsM3kbyFdrJgOVZTnpKgfPH0RGCBIdhx?=
 =?us-ascii?Q?+rIybHy6kMC8653AoPoNup1k50xF3MyN+3Wehcf3nMIi920nFzBjQb+uO1AK?=
 =?us-ascii?Q?SuIan1M0y3WDem5Auf35bD7mhFdhvjbtoJO1b60d/hpN/Vz+/eovF5ALifDi?=
 =?us-ascii?Q?ePh37jk6KuSF2Q1G0yM1OzMiiQiyMXmVIa0zvEkIu/lqls+bCi6NkuStrQ91?=
 =?us-ascii?Q?IFZ8HvmuOrSdOajOkPsoXmGyGo4zS5KnsRE5HjM8MF5NPn82Yqot4T+GS4uJ?=
 =?us-ascii?Q?3ymaKQs9AUj+Mxrcjd3ctRfW1a13jW+uYBpqkfWY/awX2v0D9dmzWsdNsojX?=
 =?us-ascii?Q?6MKx38sYDttnjZJYCY5pEiE2BeyW8/R/DgL9uZiQ2+bAlHMsSmj/NDBkufZf?=
 =?us-ascii?Q?vxqlSsYxcM/E1vOuFvOL/0ek2lhxCpKTVxKgUQfiwsZtQJARSHJTnLpMqwK4?=
 =?us-ascii?Q?JRUywo4+iSONVV7iDaqkAPulj12ZoDVMCRKZyvyh73nnHzRaCDOtlPGKC+5X?=
 =?us-ascii?Q?yUD0OWXc3Sn2LMxjzBg6xc7lbcMOBiJ0CjE2Fm1mUYyVNO9PASCO5DXb/M9P?=
 =?us-ascii?Q?eycMibbPcnNWaJjpyhdgoHOtSQ5MhPbaYyuU4is6UxZjPyFxIs1KyrHc6JAr?=
 =?us-ascii?Q?Sw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	udGpxaSMs/yFSKaxIkPVc+UoCNulxtkJSUU5upIFr5pasmDJ2QJPyn/GTQ+aC8UYPjWh5GBvTfUevNLAbPTDjqZyBKfzBDBN5malTfVjFOze6FzHK73R1uw+iZ5HSp3ZOTtGhEOcbalN9hvyqXrBAgOoln81tBfUffudaDv1PzKx748tyRnc3d30Qx5zRBZCnEvtU+4Us90miu8jrXVq2qM0zmeGaZihW5BynuQ0sjCG4kefliX6+wA3YLAtp7LyCupmMdMC4ykShhHiVndOvLIw0Ief9tXivlg1/3xvhwikm4y4rSBIstfdM325xqnCtzwgo6kMPrKw7gGnam3IGJzgJ/9KlJXCmaHkFj7BZjERahN/clOsvZuXtFe5dZbEoXriie1PvQszXDI9TiuWacETJWgJPz/RzWYpD692rTwXk3/W5PfWVtfZilDlDM/ZmQ22MlY2w7rw1Zh559HpoB34s+FaDsnOow7GO6YWWZEKSB07gIR8b2N3MPC0BD69r0BDDpEsUdoZPg+mdeJBAWInjj+KORY2JXRyEPaUnHh3ehOrYcKKHl0qvF/fcjlqLxhoz/3j+KDMDFcIHBxknh0Pa6Kr+AgKyh0EgkghsMQ=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 539cba4d-4625-468a-6641-08de0d59d6ef
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Oct 2025 08:47:44.3014
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VBREPX8UY+tms0BWdg2fPfV/QZNbmUTb8RYPgKYNhZqvLuSwDgY+IXqrTz+O0OAa4/bTRtJYTBzAAzAwTlpteerC3DiMx/lrgMrPiYnPl5o=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR10MB6862
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-17_03,2025-10-13_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=0 phishscore=0
 adultscore=0 malwarescore=0 mlxscore=0 mlxlogscore=964 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510020000
 definitions=main-2510170064
X-Proofpoint-GUID: E31_1JmOjkI716YOAsFFulBQeeZ9_sUN
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDExMDAwNyBTYWx0ZWRfX3gEs9OA8LReB
 KJiF1vNF6DVSyV1uhKU2p4J5XyupoS+2KFKuMUQphfJ9oHxTcttmQx9c2xgamsso9dQOJN9vN6w
 o5K0Ycsz2du/09o+BJ9KgJUFSnwetdtPKCO2JPo5+UAiOi9yTnU0otykmuHgiHzmZLRpreNEluL
 zAjeNvSNQyAk6bpWkSBAFIDMLUD91vsRaPndHzjkjUMv6pGBICa66RnNNSH+VD295Yu6O2puIAq
 sVpDmxtnMyKPvVmK3qHPGBoV0LCH2jiN43LKzXteC9efx53OManb6oKMPR/Vr8QP7cCsRNB/Dce
 hf5+XqfaNc4LlaKC3qFbIjeV59PpfujLyVTBjNng6EuvAy9rlson9q4LUBgyv9FQTMoRx7W+l0/
 Yi4Tzt9S0FegD7zp/gay1Fbvs7tySq4nlEJfNHbDPGv/JhRqIsI=
X-Authority-Analysis: v=2.4 cv=OolCCi/t c=1 sm=1 tr=0 ts=68f202b5 b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=x6icFKpwvdMA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=2bQcHDk0PiKJSUG4gMEA:9 a=CjuIK1q_8ugA:10 cc=ntf awl=host:12092
X-Proofpoint-ORIG-GUID: E31_1JmOjkI716YOAsFFulBQeeZ9_sUN
X-Rspam-User: 
X-Stat-Signature: ftbrg4eh4qa35xz9ihfho4jbcaytspzm
X-Rspamd-Queue-Id: DFC9414000D
X-Rspamd-Server: rspam09
X-HE-Tag: 1760690878-28290
X-HE-Meta: U2FsdGVkX1/Aiao65Qo3hR252bpLHrwKYmlu4lbOv3f8GBQTWCs6hs/LLVkREglumKy5DEjeGwqyWldlyvekmnDC2RDfv5Vn7ikfKV/zAR3eaUzr7QSJqMl63U7r+tgWirgzjYch8znqOyhMkjmq/tInNF6a2SAt0Sgm6IZPk76C/4e6mz1tLhaSv6mpzcHQXuKWr3N+denm/CJ9ZPGo1lFNmIxDr2WbjiS/o1lZqhejbdyDUuv/lyO8RDijfymJMg4pw107oDfCKnf8aY51WfxiHgARAVymhklIsz9nr8gpAdNm2JeXHsImYMjsRurG2T54xDDKG7yG7qGM/kQGK6ZMTo5qaDCHDJW7G373CoT91IsNJBpUA+iUYZYtPkHD41WK8JDPZnaHVPHWX8G7P96AbSSdMdZoRLzj5svXyrjomEouUpZxt9oiPghj48+Zbw+SSEZ/OAIv5jrpRLLlZSHagKVZXiT5dt1PtxvnOfAoyUNlsXAPHSev5LExqHy+uZS3FZVT5ox0t2qyc3p+kYvxG1HLm4to4aH5wHgCUOUziiquTKU97ZigJwPyWUGK2vFHDfMUQS4yrboiG+TXrIsEupsjgp7zi2ISCphpLWK9lLNMT9U/bUF0gGpItfHP/nxZ96dFnGyBOB13djE0ytVC/JTZQotAK8jX9AiE7sWeDQg6IdrcxX03fTlpGeiDqQ14ME3mBjsCf9vWPVvry8J+FlhMqkRbX/Oz6ZUkt0H9UBkdM0aYKf1XouOqc8Ae9JKlhqQxdLLnIxIZqfFrgadeNDLuS++i9rHaAsev8Sq/dMCgiht42+tbnFsyhDArToB666sMPotEQYDsE5ilqOjPLauGjm+6YtJS6XFO+jbHl8sVx04g69fkrIvlvxv7oUBaJxShuLvQfgk39RE08S9ugkp+UJhyYhT8MnzKgL75RHY29MZkqumR4nPOYmLmovMwUYNHiSw0o0/qA6v
 MoqRjOPX
 QiESqiCirhkO/bhrVviXFg/ffRoiy3wWstpJ5eL5LqcHk3hj7ld/qhcL/zqG/1iMcCCn87ZD+Ureue6YHDZdiIofBmQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Oct 16, 2025 at 09:07:13AM +0800, Kefeng Wang wrote:
>
>
> On 2025/10/16 1:45, David Hildenbrand wrote:
> > On 15.10.25 17:43, Lorenzo Stoakes wrote:
> > > On Wed, Oct 15, 2025 at 08:35:15PM +0800, Kefeng Wang wrote:
> > > > If the pte_protnone() is true, we could avoid unnecessary struct page
> > > > accessing and reduce cache footprint when scanning page tables for prot
> > > > numa, the performance test of pmbench memory accessing benchmark
> > > > should be benifit, see more commit a818f5363a0e ("autonuma: reduce cache
> > > > footprint when scanning page tables").
> > >
> > > Hm should benefit? But you've not tested it? Seems like rather than
> > > guessing you should actually give data. Otherwise I don't know why we're
> > > referencing a benchmark.
> >
>
> Yes, I don't test it, just find the above commit which does same thing
> before and it shows benefit in a benchmark.

Right, so let's just drop this from the commit message please, otherwise
it's a bit weird - saying that you hope it'll be an improvement without
providing any details is not really useful here.

