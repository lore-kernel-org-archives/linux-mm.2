Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2F99ED715D6
	for <linux-mm@archiver.kernel.org>; Sat, 24 Jan 2026 09:02:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 72C096B0599; Sat, 24 Jan 2026 04:02:44 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 703F26B059A; Sat, 24 Jan 2026 04:02:44 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5BB8C6B059B; Sat, 24 Jan 2026 04:02:44 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 47CD06B0599
	for <linux-mm@kvack.org>; Sat, 24 Jan 2026 04:02:44 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id C1284160259
	for <linux-mm@kvack.org>; Sat, 24 Jan 2026 09:02:43 +0000 (UTC)
X-FDA: 84366267006.10.0FCBB6B
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf24.hostedemail.com (Postfix) with ESMTP id 45CB418000A
	for <linux-mm@kvack.org>; Sat, 24 Jan 2026 09:02:40 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=Og2j6bTp;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=OPSZZ+4W;
	spf=pass (imf24.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769245360;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vO3vmzx/5pp0fZEp0/7pPBS7QemOCJBoSxOAgp33p/c=;
	b=T3D91oqSYjD7xQ4Vol//pVoMoapT0whMPkJq+VQGl/wlXZP1cSsfn1US6DAPzZurWPofqt
	GrSJMHJIpiXEPhqPGGGN7TW6PDFjM68C1SaAYN0doe0iKYjzEQyUMzKhybMmeVzBx2qVwj
	Ua6Cg4FRusOk4Ahf0WVyJ64so4bzFB8=
ARC-Authentication-Results: i=2;
	imf24.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=Og2j6bTp;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=OPSZZ+4W;
	spf=pass (imf24.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1769245360; a=rsa-sha256;
	cv=pass;
	b=thdAyX1OU5DL3jpKIqgR72RPKj+/b1+Xt/z3iGH0PGfoCfGU5ShsvYTq4rOm24hPsoupUQ
	A8NbeivKxWB6Wbvs1+7MrUUkOVXoK1vibxlLbTtf6X9IfbboRTIKT+jiNBZcs6iVsfb2k5
	hl4gF0uvEzNfNyU6Brztce+V/+j/yMQ=
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60O7k0uw642424;
	Sat, 24 Jan 2026 09:02:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=vO3vmzx/5pp0fZEp0/
	7pPBS7QemOCJBoSxOAgp33p/c=; b=Og2j6bTpi+YcGIO+TlIk2PaApzQiV8JsSY
	DALH+n5j/qqjJ41EQnS6o3muj1x3Nm7ySMKgCk1IYjd0FvYtDWcLsQmAk3TCEppk
	fHesfuxqRaBvCA8Cftl5PQVXvXkaRSjsSDmuJ0q7SgBZkMoOobXVMbYNdNSAt//A
	eQYY3azeyHmU7BwNRX0LyhBTi7QbykeqdPl5clcuylxGe+ibCPsulj7Fv0N1EUwZ
	+qm9xGPfajmGAsp+ea61n7rmuN98fpdpGabx7ZztJgxewXZuIXeI+L1kwgHgggei
	70okqeQAW3mEh9MHJlC2uwl5kyD4x9yj44pGVRLWO0rZ3a6qgKLw==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4bvny6r44c-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 24 Jan 2026 09:02:31 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 60O7VQht010011;
	Sat, 24 Jan 2026 09:02:31 GMT
Received: from ch4pr04cu002.outbound.protection.outlook.com (mail-northcentralusazon11013041.outbound.protection.outlook.com [40.107.201.41])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4bvmh69whk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 24 Jan 2026 09:02:31 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=twBIr3yR1AxEQ1l/haWhJ0UMGPiBExD9dJv6g3zOxC3wAdM9dPh5yQzL96SG13MHpEUY6oFybbRIbe+9wUPr524XDYHkuUUj7+qoo78fNGXcR68uT49xPUkERDeu6tNgfs57U4NhjJbvAzWpwcWMUthwXnqw9gvvpy+VSekLzHtU3sQ/lSdtaXqEKIW/nMovBepnR7hlrnhHM3fusKVTGpuZSU/TdfeJweoWpf+3tPJMUX08k2kCSrCHRRkiNTKKIG7RvjNUnJKf31WA0crd/cZTKQjR+emBwBG6RUtBpo5IdlHoVkcVgO6axM2sxeLGuqHcdRinXGxE9rN9LYgiuw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vO3vmzx/5pp0fZEp0/7pPBS7QemOCJBoSxOAgp33p/c=;
 b=xTcXGsOyIJYCQ9YtWmNRHEWO2GJAMo067r1JTbk6FyBSyYthDY8S3SWHFU4JGqEpcO16M0CCM/yN9+9Ff9eIPlLmphskn+/Wt5ZrJjl3nXGRjL18RkS+qs0jDDpcl6oKnvtI/5GNlto0RziCjM0se8wuF+qSQFDBuGdxZbC+Xm841NEZgPB6Pw2mIHMxK81CfimbE8QRPVrcvmJDCiNu4Tv5fNKkJwLxsr5iTaCg57ITGP6Qon2HGhIUoMHN0P5mZp1aSSzeiq5BqhybeeYT2vjF+vbWE87FsJiPmp2tr/YKe/uwjoTRWO5zryPMUxMzZnmn8j99l8V7ZqDDJFGetg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vO3vmzx/5pp0fZEp0/7pPBS7QemOCJBoSxOAgp33p/c=;
 b=OPSZZ+4W+9GCBPcghcC9SlUe+atEnwGPUknNRqBOTHhpIgpG6FJ0Y8/581FheDjRaPryLrPmubS2hHxKZ6MFRvcHmkOh58FVCoVcIdqZCeWwDWh6C+FKo8sLcaVNWWe2RKDGw9E+JROhuZpnPdtAdVyzLWzvZka2ISc6mOQu5wk=
Received: from BL4PR10MB8229.namprd10.prod.outlook.com (2603:10b6:208:4e6::14)
 by DS7PR10MB5973.namprd10.prod.outlook.com (2603:10b6:8:9f::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9542.12; Sat, 24 Jan
 2026 09:02:23 +0000
Received: from BL4PR10MB8229.namprd10.prod.outlook.com
 ([fe80::552b:16d2:af:c582]) by BL4PR10MB8229.namprd10.prod.outlook.com
 ([fe80::552b:16d2:af:c582%6]) with mapi id 15.20.9520.005; Sat, 24 Jan 2026
 09:02:22 +0000
Date: Sat, 24 Jan 2026 09:02:25 +0000
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Garg, Shivank" <shivankg@amd.com>, Dev Jain <dev.jain@arm.com>,
        David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>,
        Baolin Wang <baolin.wang@linux.alibaba.com>,
        "Liam R . Howlett" <Liam.Howlett@oracle.com>,
        Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
        Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Wei Yang <richard.weiyang@gmail.com>,
        Anshuman Khandual <anshuman.khandual@arm.com>
Subject: Re: [PATCH V3 5/5] mm/khugepaged: make khugepaged_collapse_control
 static
Message-ID: <373226ad-b0bd-44f6-82c7-08d2fe36e398@lucifer.local>
References: <20260118192253.9263-4-shivankg@amd.com>
 <20260118192253.9263-14-shivankg@amd.com>
 <6486c6dd-2702-4a4d-9662-09639532ce6f@arm.com>
 <afc56f8f-0c22-4bac-a99b-b46df346334d@arm.com>
 <ba4502f7-0c35-460e-a42c-d32dea9ab9eb@amd.com>
 <20260123172142.4bcdee865bc768d5c70b6a50@linux-foundation.org>
 <20260123190213.7f90fcbc6706d9ad57d2c974@linux-foundation.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260123190213.7f90fcbc6706d9ad57d2c974@linux-foundation.org>
X-ClientProxiedBy: LO2P265CA0197.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:9e::17) To BL4PR10MB8229.namprd10.prod.outlook.com
 (2603:10b6:208:4e6::14)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL4PR10MB8229:EE_|DS7PR10MB5973:EE_
X-MS-Office365-Filtering-Correlation-Id: 99cdcf89-94f6-44b8-b08a-08de5b274966
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|7416014|366016|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?6xsjRWCJEMLfxKKR1Dp41vcxGH6AUhIhL4XooIbn0qOga9+fUOocsNllcnmU?=
 =?us-ascii?Q?bKlNlEuBf+Lv/AIzqo4TfN+FqDeFlXd8CkAaHIdQcJRT1PAzHcMtR7wtofz2?=
 =?us-ascii?Q?e35FOfcvRTVeZetyxjMMrLDZN7cq0AtLYST6s9kyNYe6i2sIAKfyvhp9sq/g?=
 =?us-ascii?Q?MsrFAPzg439bEfFsK33B7FKTUrcjYhs63AM3k/+StgM/H6qlkuwYJz7xsT8F?=
 =?us-ascii?Q?KYQeGsBYK3WRYeXVPjwdgWQOr5egODRfQ2NqjDHfBK/QdBJh1UUaCI0M2gqr?=
 =?us-ascii?Q?4FmdtoJNQn8RJY+FUtj+XRjioOqBegF8ZqkElrx8x6M6TqzgrR2lBNqt6Wb4?=
 =?us-ascii?Q?df9UUevpWS5pv2gxXpfM5l5/sh0+ZZLQS2zIYLp9JguKBZHUQuvl3Y3o59FI?=
 =?us-ascii?Q?cUnKrePKFAySwan8rtkOdvW0hcu+aGcecpzQCct+2K4rtGIm4RPtkZsdMaJ1?=
 =?us-ascii?Q?pDHr0XSdjQGFugYg0M8wRw61WrbWm05a9Q1fteciOas3k+IIUdE16CRyj1xe?=
 =?us-ascii?Q?0k79VY4ks6t0JspZatBmIUeLq1KKt6Y9yWFaS44U9RgBvuPZ4phA6uSlB/VB?=
 =?us-ascii?Q?YbW6N6dDOUo7lZrgx1CG+Lb4HAZI73rIdmhcdaxLMj052DPsdJyqe4TZ1+al?=
 =?us-ascii?Q?xlnIv9eSkNnaeH58XKgNGxblPI+826OQvw2Tm2eLX+Aspgl7EHVh7jVjxVSI?=
 =?us-ascii?Q?dbgmf/3w6u0+DzeiFTVAKqg/FIxgZl4WNhqgDlZitjFyJH6kNhFPUS9ttAdr?=
 =?us-ascii?Q?xEpUQUNvBnZa2m7P/Fhbgn2megjXxJnkuA/qvJz2nEVEZdum8jh7rUddZISg?=
 =?us-ascii?Q?iHI7GCDogo3yvxANhqfVrn0KI90oYNzAfoOYUnyzgtGq5mEgtraO0HQ6Zdjj?=
 =?us-ascii?Q?rG5bGXwTKZR6TyEOpN+ubNmzEs+LaPUYWTzyqGJlD00PC8MsS9lDVf6NQYa+?=
 =?us-ascii?Q?TPQHGFGQ21/rfAAQEWfzOxtGFXlCQn0WMNGxHXkSbtct7GME4b5R3CEc+tTO?=
 =?us-ascii?Q?2XLn+a2gGoLaBlx25/BsnNHoqXzZDvnKQI7T52gGMKGd/v8DqZnLDgjGrzJg?=
 =?us-ascii?Q?VRgnIScv9xLU0sqU35zk8Yy+Q/p42kfQJLEbVCDLFlKyjGCc9vkWXoF+vUEc?=
 =?us-ascii?Q?3E/voxHPTCz9BjGyiltLj1NQq85cbZM8ur5nItLHCWT16EVpnr4y6MRImEwZ?=
 =?us-ascii?Q?ahCsWY5FhOHPeYhEL0MBkiqsgreum9i785OlZMmXZfLSaFTTPXYHhtEWy5K3?=
 =?us-ascii?Q?hOlPZjNgQ5e3ct9lrkGjy8e+yfaDfwZ771huXwgJCK01nGeEsi6fnYSurWQW?=
 =?us-ascii?Q?GG4pR9z4woEVAAYDNBO1GaN7HX6vhb2o0m2RjKTl1llhSCzLwFaHx5jZuT0Q?=
 =?us-ascii?Q?o5p8PVhHbcoaMLLxot/1av8Crh9BYTbE0jqs6y7ZuSrxjzLW/kiWgZuRuA/P?=
 =?us-ascii?Q?bTebIK+Qw1iK0q9Sb3B849gny5HCFitXjOLZu3ff8t7kBsgGltkFWbGvi9oZ?=
 =?us-ascii?Q?WqJJPvIiE8KCIpsc06SPj6eEPgx126/mN0AMh8qOFlHqp9L+ko6rV0fNeRSd?=
 =?us-ascii?Q?1TTep3wyLQ9u3CuC8ds=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL4PR10MB8229.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?KIDsPQ8s/Y59rrKLv4wEWvOc5N/OeXBh7Oh5xuNyTTd7DLwq1btz3YzGuFv8?=
 =?us-ascii?Q?dAA5GYjryrlcNkfsVNTa1HWaJ4nSLKxc+isYL7eaaMgeVVPnKfGbHQQN38VB?=
 =?us-ascii?Q?UNhpll0aB+/I2RiYHPGIlHFN1hw8eMv+SV1+0JHfWIQI0XSkreSTOrBPf1Zd?=
 =?us-ascii?Q?2ccabWIL7+pghN5e4otjmBNfcGQuGZVVOToP02NxTYzjC/ceBfg68o8KIONX?=
 =?us-ascii?Q?hjzG/GKWHLte4k/hJ/xj0BdxzAR33Wyq/THmwQNZHnfovVeGuHL6vn+YByuU?=
 =?us-ascii?Q?xvi1VFv86bRq0Sne3me2txPkapJ0nMXYTTwUxeobWCcFVISPrAvvlJH0WKzX?=
 =?us-ascii?Q?3MplD9otMM6JgYttYvDRQjJTm2w6+fqX/EN2vB5D85URS/MSOpXynUwAgyhr?=
 =?us-ascii?Q?e856plfFa5S+lCkz1aIk/w6bveq86mEVWDtu8n2pz4gBVV71usIb9PJ4foL2?=
 =?us-ascii?Q?ua6vqi2qNZtl2Q0YH8UuRS1bREi5RryTTfdl6E6UG5oxLn7hUl3UU62IkBdr?=
 =?us-ascii?Q?Ne+bAUH0dTomkjoahFvskq3294uyH5MMtkqkMlTqN1R/ArI0bJr+BERdQlKJ?=
 =?us-ascii?Q?kx117DIythWaAoqzqm4C3ufpvraU0anAJGcJP7QzpwjzMEITO1ilDZUhdp8A?=
 =?us-ascii?Q?ENUAb2IPT5qm4Yi9SbD8CZvnHdvOt7ezwTxCTTukb0LLoXbJnlXodoLm89CU?=
 =?us-ascii?Q?w+kK0Wp5bwIlS5nvduDdcnpJVxcAV8VaGiP3kF+ne4E0NRE5zkb/GNKVZbt9?=
 =?us-ascii?Q?LiHm7Y83Tp9BNDuP0KxtxvL9/Tgz9xyGm2bfcsXjkhYnK6sSHQMMKgPdgZtJ?=
 =?us-ascii?Q?XGi3dax3aYzjPEPsF7Ak2WF8nTQ1gB79gb/pBuTaGsVYweLMi/oteRbGP8U7?=
 =?us-ascii?Q?9dm+XOFDlkVxU7IoMtWt3LP6DFiJOiWZhIumdJJbdKaZ5tGDdyjsYMSwGANd?=
 =?us-ascii?Q?DjDuouyWbXeLzA+sM1ryVlPMoq6O2jHHchlGqXDWcIfTNwZYunvVgZb/6TOW?=
 =?us-ascii?Q?DF0CUU33Aywcna1uhHp/iDkpwW46Tb1kI6THXOJ9+8GXcTc7PVoGTnhMs1hO?=
 =?us-ascii?Q?VW7Z5ub6HreaBkZvLJuM6YhxiqzJkBcng/pdfKojzyWtt4maabMg0zYkdeMe?=
 =?us-ascii?Q?G29LjnLsuflqCJ3x8+N4553UYykgNpbmuabIuuH5pZ1rNhBAk8xkhnXerPP/?=
 =?us-ascii?Q?dnj2i/2mWaifbrwL4Cr2qOS3lbLVLvhs8BmYPAV9GMBkoZvV5X8OsiOTwjqB?=
 =?us-ascii?Q?Jxtx5UflfJvZGOnuS+FyA+aryRsqZbyjuH6D5EQitMzozWarB5ooD0w6x9Yp?=
 =?us-ascii?Q?eOyvMmCmHLwq+BbWGJ9dhvgwo509TxGHbqJCOQ6G7c9Ilb6Zjn+IWu0DOwFm?=
 =?us-ascii?Q?bJMM5FOAnHwJYebndkGoojKjSbuCBd9IbltbUrwA9vkpJz2J3n5YIJHNTmpu?=
 =?us-ascii?Q?3KIGyRwb/5QxhBqsnA6mERDILdLj0i2vKSCM2Z2N5Rg7QhHkwqABvmuV1/PK?=
 =?us-ascii?Q?7oGKx0x6kAAX6LaNwJPDlDHvGKY+gRvushiWBWnVTzfu63ZlzXNTSV3rpSNq?=
 =?us-ascii?Q?EAYqqoAPsUSlbogJDFXGWwfVPNckVossiX/gEZl5Hd1GZMFAQUcD6EXWPjy0?=
 =?us-ascii?Q?FDHB855RENnP1RMjCbvlefMu/zdKjtlodqwOyIimisD+V/yd2qFvUAcBuYeA?=
 =?us-ascii?Q?hPFLhiiftLiIHf4F1yxb1uvMj9Z+LGsPMbY17eHs5mz26ZHMM5j9tTu1sxM6?=
 =?us-ascii?Q?ZbXFSh5hJPBsSb7fCxvDIDb/8ld3v3M=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	epmEueX9CGStfBJoYKyo/gR6a0OkSTo+v7TOj54dT7P787GZXta/+LO91JWXu7DxX9e7RdL6DmQaxLkCwrdJSsyUJwq0tmOjOBLmscSralJ8itVRTsv4WWDHS0JgCeQhyonDxE2zII17ccSiFdcK/d/R4s013SdDmmUGSQO+7zHlWWUP+wJoKe13fJc1RhQyA4p9myCEu8GzpAWEvi5NEAR9BTF/Jg8/1718R3V7ROSQ7lOz71GjeD5h+fH4RPNltx/9sL2Z6Y0O5HN9Y8oVuvls9VTAWUw/S118grlsV6GneJ9Yq0NTj44oDI+DOOf8w8IUeOJ/Sgl8gRYsyYiVXABck+Vefdrep4M+p9fLLSdCX1VBkbqWt5zwtmsNfe8FfTMO4wQgnMaT1Z77p5F70DgxxGI4ssajhA0zzdL5vM0u/pAt5Sg6U4i8D/V6PRknQoYh7N6Z80FjsJniYgwg531d1G1pPiWE691BO8diFg4nna05aCTgpv7kZEw4Qzej1iKl7ekXhPQCD/8Wc+aepx1V9pODYCDiPvtIeqPVdATflEJvFl8C3YqlC+DirIX2bCvsuJt7whvnLqPshxLDurJM3NdHazCjjG10KoS+wY8=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 99cdcf89-94f6-44b8-b08a-08de5b274966
X-MS-Exchange-CrossTenant-AuthSource: BL4PR10MB8229.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jan 2026 09:02:22.7300
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: h7DESQLOrXp53Rpqw3JmrXbCMUfCr0Jm66Jw/g0S2SeXjOWY9ogf+QeWxZ2lTeiSmv70vbF3eSQdB/0Kz6R3DQloWWKWHD/y0xyWo8hj/+U=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB5973
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.20,FMLib:17.12.100.49
 definitions=2026-01-24_02,2026-01-22_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxlogscore=679
 bulkscore=0 mlxscore=0 spamscore=0 phishscore=0 adultscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2601150000 definitions=main-2601240070
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTI0MDA3MCBTYWx0ZWRfXyBfCcFSoDKhF
 e/rJiZmv4KBlj577uJjpwepL0wnaX5DPqnISlsfgeKxrVZUqGPJnb30Wr0QMX6G/Ir3B+oxtidu
 2p6REzXMstOTWbIdLsniZ61wloRs0M2RwEYMF5DrkiDQO1obkjCRNuWthe6gNEeTlXsLBaOPKJ4
 CCpWHA4sdEixUxH6O2kyq0UBF60RzLV0dLNQmd1CLtS0vvTKhE1V9+FgsaAhnFqU+oKQEwqV4A/
 EgocsE+eSpDn4x068WaH7OkFHz3+HnawPu7dNzjA2jfJGh3yoHSFSjVB7vFXK4cVTabFP6ILcqb
 N0/uwCr20gGoJiw3gAtxVKfRs8UlO0ONE8VLQX9rqcBYNTBU/ZkT2Pg5W6iWGdo8k303uHhhUnT
 PTejznpMbeu7TglQd3eR7M0mXB/LgsXfGrMYmlerr2xKYv3hadaCyatl16gznmyvj5n/XOp4JRs
 Uy1CjKtBEXnEGvDX7jg==
X-Authority-Analysis: v=2.4 cv=C+XkCAP+ c=1 sm=1 tr=0 ts=69748aa8 cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=vUbySO9Y5rIA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=Z4Rwk6OoAAAA:8 a=S6iIS8DQnDKhuzroGP8A:9 a=CjuIK1q_8ugA:10
 a=HkZW87K1Qel5hWWM3VKY:22
X-Proofpoint-GUID: UoMow-oNwx9ApiesQ__UHWjoYxfoqS7H
X-Proofpoint-ORIG-GUID: UoMow-oNwx9ApiesQ__UHWjoYxfoqS7H
X-Rspam-User: 
X-Rspamd-Queue-Id: 45CB418000A
X-Rspamd-Server: rspam07
X-Stat-Signature: fwmrh43azdtboezsspwsk4z185pww5b5
X-HE-Tag: 1769245360-522601
X-HE-Meta: U2FsdGVkX1+7/ttxc/XL2bRIs1y9eEVHa5gvAGqp0oq46T6cOf8+y6S11fTd+zfWzlSDWWjVTHifMyLOuDYJDLHrBRkSXkuO38bnFrr7devQP0aVP/K8YxMll96hZUgFX3t/N9ni9FAOGJw/a1vPzXgEroU7NOT08nxcLjpaf6lh0n1S4U5en1A9GWpAr+7equHCCNysgYLl6O2hG1HfazaSJsZjHfJB9aACeaqKHFr3UydO1hnNg2yDBdG4MjNR0BKCFDd5HImtF9U4F09wKqc1lN5ZxZDvPFAsiJMub6VUSKsM48/g3fX2BHRKBh46D6E41bYv02PCAeztH0ZHCvBtUlPBbcOonCn5F3HUAB8xBs8GZQ6sdkbkgAYq3n503TbDSndAb7TBbmNIDFrb4nxkUu7xouVuMCUOzcI2lW3Z/vsJcT7JbV4TcyHtQG6u/Z6s7hM0hA1dITQsMFx6rMERVzjiTnIPjyTY81OjEGXkVL7LVP2eHyzuLN6OvStB8QtBG7rsfJ7k3KLbhRas9TOBdZcxw+eudCrrZZ+gybDKQmtxtTZUxzZ2L0p5yMUfpWs0AZSJc5otwgizSdmJ+Kru2HaLMT6/B7t8W2FNAvcB3C+aiM03nlWk8xq6UkEzdbs//7lbraJf+T6kYExoB9OWhSCpqJa1q+6nDMat0yIQb4cAICNyOk+T+U6vWOYIdnCq3A6qT/Mtvv9efLn2+/MEN5h59LT7ETbpkNsScwDGzrU/90/WLOPEwbkz9eXU3QH6Wo2z+fh36IlyADAfU7jnfPLgdj4pMQDnkqLeSXk9p+0Tq6Olq/zxnPuWB3K1VHYYlpzM+i1XLj21ECeWPDTVYIXmWQO2xkA7PFpMQnYvfDZT0YBYO4lA2Z2ZtFJQyBLx1Ulch74SeyNS33votEl9HNc1eOV2cKiX1BmRhL0M1o+IZT1LtpIi+ZUUIu8ck6dqDYT8PmWLyGGKAXe
 arz9jO4F
 LsTbXJwlZZ8QHGScnDweozrbJY7Spa7wWFi9/5EOFv0RYvk50fvn0HOZzwsF+It8Zr52o8cvgIY5EIgF4ZBB+vRIHS/nkUSzgoDEiExwl6HrEWZ0Zcxd293ewQH33LQn/cOaJAWydsVTdxsAVQNqYD0PDGD825aKihucCA/gYZcGMzJFcHt7963hPmWc4alKBjwxIV8bO9zTANjB0obi7yrzh9Xv+GdfQ3Pm2wko59KTW0YBv+P4FI8946BwuZ7wIxcc49uiTTEHt2UcNRKKbb+gv4rRFLZIe/8He5RYq+HZiAyuxLGE3dQvdf3zIlfk9b75wX4vQGPRzjuwBzOyNBiTZcl3xlRhjVMGFkJ7hSaN1iSwbi7DrFHH446YTlPKmppUiOCWPhKYBcPJmQCvvyGI7thXrZga/iHHp2+xIE3CjdLBAFk13ESXb27AnmtXCR4Rssn7rdu9gl8CNxUdIZCbR9E+dIUoDjHduzoxa4wx9SKuBGPPrHs0jHSUb65zswmJ84gWPBQ5c2WIAbYBP9ZEEW6Bc8YYPOxSGgS2BtlVII83FlL9cy12P8oTD73DruJVsGz78FvRDLtJ04KKEN26uXqpDDIcdR12kag1E8QBbgv9P1rsfH76kuVgxj1YRkh5oMCXBFPvTEbnGmey/6Ad8Ck+slY/dnzWloLooe8RGUevrfVeYggj97YG2Sf6JEO1xwGAxd+/v81QbDieYIEk2ccNCprtK8rC00kFVQdlMIqvBVK0wFCDgsAUSxyXgyVMy/Zn5aW/uiZU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jan 23, 2026 at 07:02:13PM -0800, Andrew Morton wrote:
> On Fri, 23 Jan 2026 17:21:42 -0800 Andrew Morton <akpm@linux-foundation.org> wrote:
>
> >
> > lol, OK, I droppped $Subject and did this:
> >
> > --- a/mm/khugepaged.c~mm-khugepaged-make-khugepaged_collapse_control-a-local
> > +++ a/mm/khugepaged.c
> > @@ -827,10 +827,6 @@ static void khugepaged_alloc_sleep(void)
> >  	remove_wait_queue(&khugepaged_wait, &wait);
> >  }
> >
> > -struct collapse_control khugepaged_collapse_control = {
> > -	.is_khugepaged = true,
> > -};
> > -
> >  static bool hpage_collapse_scan_abort(int nid, struct collapse_control *cc)
> >  {
> >  	int i;
> > @@ -2618,13 +2614,16 @@ static void khugepaged_wait_work(void)
> >
> >  static int khugepaged(void *none)
> >  {
> > +	struct collapse_control cc = {
> > +		.is_khugepaged = true,
> > +	};
>
> nope, that thing's really big!
>
> mm/khugepaged.c: In function 'khugepaged':
> mm/khugepaged.c:2637:1: error: the frame size of 4696 bytes is larger than 2048

Yup, thanks Andrew, this change is completely crazy.

>
> We could kzalloc() it but I think I'll just restore the make-it-static
> patch.  Someone please add to the todo list?

And no to kzalloc(), let's just keep this static for now. It works fine as it is!

Thanks, Lorenzo

