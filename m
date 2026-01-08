Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C4AACD1D483
	for <linux-mm@archiver.kernel.org>; Thu,  8 Jan 2026 17:46:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 335BA6B00B1; Thu,  8 Jan 2026 12:46:26 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2E3556B00B2; Thu,  8 Jan 2026 12:46:26 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1912D6B00B4; Thu,  8 Jan 2026 12:46:26 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 040EB6B00B1
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 12:46:26 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id A11B38A597
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 17:46:25 +0000 (UTC)
X-FDA: 84309525930.23.5BF413F
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf25.hostedemail.com (Postfix) with ESMTP id 2E964A0018
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 17:46:22 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=AGLq6PwE;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=IcOKsVxI;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf25.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1767894382; a=rsa-sha256;
	cv=pass;
	b=VDZVR5sJq9n/SEEkoPJujCgiLdvPY/+vPPvaczQug5KTvGT5N5EgRymuKsOiP9jdcJby+z
	JW1SzG3oD3TGGEkNYfADgtnySlkC0o/5NDwfRJWJHAs5gMLYyEoZAQ+AY2Sh7J1T4l7mva
	UtNZk7q48XOnKPqytR28GuwFIGD96y8=
ARC-Authentication-Results: i=2;
	imf25.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=AGLq6PwE;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=IcOKsVxI;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf25.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767894382;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JGb25wHeJxkaUQQjfI4p5ohKS6yDYxnehmESyGaGClc=;
	b=5JMWsOAc+Y3qI4WLl7iuMD0HizvPqYhRis09NNHlHwmUNJAotJcWU15DWJo72wzv0bHiaJ
	RnSgdQ5mZSWUibFPG+XauYjTAE9vM6qfmL2vxnKpHtwidrSUEQG1FkHTGG6Sw1jAsO5zYa
	FY6/n32M9IzAmoGVS4FsgLtQ80ou+lM=
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 608FstNJ1008999;
	Thu, 8 Jan 2026 17:46:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=JGb25wHeJxkaUQQjfI4p5ohKS6yDYxnehmESyGaGClc=; b=
	AGLq6PwEgKAs3Us9a+dvgyNQMJO6SnjguqWHsSUwDcojUdWvEm4TZCl2PcLgvxCp
	CTeIA3IypCMnUhugM+38IYlrJnSMDDdunb2kv4T+PG0hlO/yvYKTaLohmQGFBNy+
	26WOuegZZcoXvgp08SWKpgHodhBIT+P2CTlP3HyJ+M1r7Bq9FhUtI5176jYqVxYj
	7m9HaMqwlJVZUTAJmcRJpwHSPH/lE+XMmgopb6uzjXP9Ox7ozUewl3y5Z4eMj4nq
	lWmFUeWYsU1MX15vDUCgRD376NMgqyOO3kdV5uOCqxvikVBPTWmb6//LBLMxe4x0
	l+2Wn8P8YRoM30MYlYCEfg==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4bjfn386ss-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 08 Jan 2026 17:46:17 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 608H9Auf020437;
	Thu, 8 Jan 2026 17:46:16 GMT
Received: from bl2pr02cu003.outbound.protection.outlook.com (mail-eastusazon11011036.outbound.protection.outlook.com [52.101.52.36])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4besjncq22-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 08 Jan 2026 17:46:16 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Po6fjw8brUFyTK9rjkZNTmy4P2IhtnkL1Tjoh/fwByAucTFTSHRdpHoaMOLWgt5wfXie0+m8lg6yGGa18Vi+Ivz4sVbGBeHrEij3ByJ7vyFAIwko88qpOflXN/Foy0GyCRkGDWJmawzPKlFaAzX4xvHMXlxaCvn5a8VmlEhkwn7cw6X2noh/IBFa+rFeDLzKJ/nA13zFTaF8/5SScO/ZTuPY86lSty3hOlnkqIZB9AvbKypU/A9zQiYac0qWSc9FgwsYucRfIWeBhsbgM5Jypx7DzLd5VMv/5nV9YpW4eec98xpcbppjii5xnIVPG1yzjG3qN1+0v2KGS4Fq8rvJXg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JGb25wHeJxkaUQQjfI4p5ohKS6yDYxnehmESyGaGClc=;
 b=pmFLPIQwXoAVfnEv+C+Sn4UHfr8cRyjg2hDEOk478ABCNS9R/82xhqVLtepFSI+M8OwZ+UcIp8WxXBHbPOw2Z12fBCdWHk1f+2aLdGYXtcWyc1u5mNs9VJp4S7R6o9fUJk6NNslvtbRCf+diBaPrslcWvP8cHI/APtAE+AmhT4bebOqpFjm2NOmuJs74Zn00WnBe9D0S/2flB9MhHxTvC9jmM0wFUJgqCVxlX4AqiISCEv+TomC7l0Q0zGZIKyDeo1H2EHjcgE9kgFf87rZgh7pM8L6qL3LN7buIQRNbmCtd8bMr7hAblAWKUwMw81AK0BFVQ28N0SFv4SriJqwBJQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JGb25wHeJxkaUQQjfI4p5ohKS6yDYxnehmESyGaGClc=;
 b=IcOKsVxIN98AjqLj2iYWBnww91b5svs+Vny7Ej3iSZdQqqc3QMP5T4XFZdZyvGbVl1FUtGuwCyY8YWdKjp0WSpEzie76IDJ8qUMq6uLJbG0gtujVczeG+a/gRHENHGG3FfgVXuQuK4h6z9vgl4s4/HXS3uJ/TwKL5C8Rp1aoMFY=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by SA1PR10MB6637.namprd10.prod.outlook.com (2603:10b6:806:2be::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9499.2; Thu, 8 Jan
 2026 17:46:11 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::f3ea:674e:7f2e:b711]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::f3ea:674e:7f2e:b711%6]) with mapi id 15.20.9499.002; Thu, 8 Jan 2026
 17:46:09 +0000
Date: Thu, 8 Jan 2026 17:46:11 +0000
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Suren Baghdasaryan <surenb@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        "Liam R . Howlett" <Liam.Howlett@oracle.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        Shakeel Butt <shakeel.butt@linux.dev>,
        David Hildenbrand <david@kernel.org>, Rik van Riel <riel@surriel.com>,
        Harry Yoo <harry.yoo@oracle.com>, Jann Horn <jannh@google.com>,
        Mike Rapoport <rppt@kernel.org>, Michal Hocko <mhocko@suse.com>,
        Pedro Falcato <pfalcato@suse.de>, Chris Li <chriscli@google.com>,
        Barry Song <v-songbaohua@oppo.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/8] mm/rmap: remove unnecessary root lock dance in
 anon_vma clone, unmap
Message-ID: <351668f9-dca4-4df8-bcfc-0fa165523edc@lucifer.local>
References: <cover.1765970117.git.lorenzo.stoakes@oracle.com>
 <454c0680d4fdd5504b1e90b2fdaa098bd70d4d2d.1765970117.git.lorenzo.stoakes@oracle.com>
 <CAJuCfpEWwdnNs458wSb__C0eHSEvbvJ9nK3ryQWLTjA3+b3BmQ@mail.gmail.com>
 <2ec5bf63-139e-4e8b-85e2-efb48adc93fb@lucifer.local>
 <CAJuCfpGQQid_VPx9Y1TE4ozXEQM8tWixxLDnS3cvrM3sdT84QQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAJuCfpGQQid_VPx9Y1TE4ozXEQM8tWixxLDnS3cvrM3sdT84QQ@mail.gmail.com>
X-ClientProxiedBy: LO3P123CA0022.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:388::12) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|SA1PR10MB6637:EE_
X-MS-Office365-Filtering-Correlation-Id: 6cd6d65b-9792-4e36-e031-08de4eddce56
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?UUhZSnQwRDFuekpsdWdrMTE2OEFleFlLaHEwMVZmS0xNNFZIcVZibHM2YVVq?=
 =?utf-8?B?Kys1UDF0ZDNhSkpZVVpING9aRWwwVnNPd0dGNCtNYi9aUVdaOFpmYTBuUUVH?=
 =?utf-8?B?Zy9ZQ1dZcTRBUDdKdW9FUWJiY2UrTHc2K3hmZEwxdzdDbjlIb0hESlM3Umhy?=
 =?utf-8?B?NlJ0TkxYL0Z1MmN1Q1dzb3hvTGM5U1BPM0NnUEszMWc4M0o2eExwamxnUmxV?=
 =?utf-8?B?SldFdVJwdERiTW9oUkRZYVZ1STBSOHdxZTlkWGVPZndXb2g5cDNPbTVOUVVU?=
 =?utf-8?B?SHB4MlhVV01UektzNDZBU3hVenByQzdUUDU3TmRHUjBNTzd4ZGI5L1hUajFa?=
 =?utf-8?B?QjdCSU9xMHNNVE5SNXl4L1lUdkpMdU5hZWFGbHhHVWthcVlINm5kQmV4Mm5F?=
 =?utf-8?B?NC9ES3p4ejh1ZnhnZTk4N0RaZUowRWpkSzhuY090M3ZaT29yeHU5bnR4NS91?=
 =?utf-8?B?RlpUbHFKZ0p0MlVHYkhIUUN0bkVkaWlrV2tUVDlXdnlOa2ZZdHM5aGd1NjJ5?=
 =?utf-8?B?ckFrSXJINDAwM1ZyWU5RbDBTMjJSL2JhdWhXQjczZHJSSUVraXYveTliR0VB?=
 =?utf-8?B?TGtZaktVZHIvRndLdjhJcWxhL2Z1KzBMekJTZVVlejBBOEVUTGV0VWpqd3lp?=
 =?utf-8?B?aG5jNmxhcmtaR0dhUzJxZVhzWWhjUjdoaXh5WFN1bGhNUE5LNlMxd3lSSmFB?=
 =?utf-8?B?eXRuMldmNW5rNWZ5SkhWMDRCMnRRbmhEM0ZLNlJ5TXRBUmRNVUdTQjdzMmpS?=
 =?utf-8?B?NmhEclA2bXFERE5XY1NlSC9RMG1XOXdoazdVaEN2TVBUVisyaDVqYjhIcDBi?=
 =?utf-8?B?Tzh3RlFoWGxaaVM5Rm9xMThZNUxHZ3l3L2l1VUNTSGtudUoyMGxEUGFhcUdK?=
 =?utf-8?B?TGVYbzBCdWdjQklrZUlFKzUwWFdwelZlRlhyYVhnWmJ5bktFdUovc3hEbmJC?=
 =?utf-8?B?YmdRTS9US0RrV3dOYVU3TVJiSkVab0xWWGpYNVhlVUkvajhpUUhlZUV4Nllm?=
 =?utf-8?B?dU5HSGd3K1NBQWVScDF4eTBESE5Uc0ZPWjhIMEpOb0VvcDBZRkdNQ3ZyN1J0?=
 =?utf-8?B?c3JNQ2kwR0l1MUV0S1puRGRRdndYRWdkYVhrTlg1bkFuS0tkZ1cwT01FR1J3?=
 =?utf-8?B?ejlIbllvMnZzYS9NL1NtdXl6S3kwRW5zQnpsRHdIdTRLQjVLY0JoZU5uR3NY?=
 =?utf-8?B?U1pNN1VQNElNb0lGbktrQkM0M3hxalBRcnNPcEJ2WTUxNnA5eUJ2eHM2TlVx?=
 =?utf-8?B?VEZ4UWo3MDE5ZnVPNUlVQ0tVN0Mrb2pjZUJJcjQ1b3BsMjRsQlNCVDF4VElG?=
 =?utf-8?B?Vm5ZNGhDUlEzOUJHTEdxUDdKaGhDTW5WdDI0R3RjSFpwN0I1Z1gxNnNGU3NN?=
 =?utf-8?B?TUpxUWZUdERZbFhoYUlMVjhNZDF1ckVHWlFZTzlXWnlFRVRTRHYwOHpWWUZN?=
 =?utf-8?B?VlJ3NkFHdjJyblBhZGFZUUpkMWVxTFppcUNPa0Jva05LUnpORDdraFNGeWZL?=
 =?utf-8?B?dEJoN2RtNThiNVdaUUY3WjRiTUFMWmtsTDIvV0c4WFl6NmpZMmlKU1JQT1BG?=
 =?utf-8?B?Tm9nWC9QQ1Y2Q2h3ZDUwVThlSkVsYnlPMFBKVG91RS9aVE9aTk93ak5EdGpJ?=
 =?utf-8?B?SldZcFB0OHpUSzV3WFNvTVkwVkxBd3h3RXR6NDFQWjJtSXVaK3hzUHdHS3c2?=
 =?utf-8?B?NUlTdldRdkRpVlpPdzE4NXJJbjcrS0FHenliZkM1TE50UU5pUTNoYk1CaW4w?=
 =?utf-8?B?RUNsL2J6eFFReDRraVgwY1RQOXBqWVNpdld1cUxnVXJPdzFRNjJhcW1zcXp4?=
 =?utf-8?B?cU5ZWnZBWnhqTmJ4T0lsbFZRYjhqYUVsdXZ6V3Q2TExVaGhId001YVdreGQ4?=
 =?utf-8?B?RmZkanUyVk5maUNjRmRvcDFDdzhUeStHUHZjSmk4UXIrQ2NTNllNaGNlcVAv?=
 =?utf-8?Q?wilaekNwL6n078UaN/vykK8mbB6qYaZ1?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?ajA2ZjBCUFlIUFZQWHFYMVRWaktkdnoxWlpWcEQvbDh2NXhzb1FONHh0SEoz?=
 =?utf-8?B?OGJFTTRqM1A5U2h4REk0QzZ5UkVpMGRLbHVyVVF3NzBhY3RWUFZjUjRDTys0?=
 =?utf-8?B?T3N1MHd6RTVLMnBUTWxsT0FzdEtReDJ0RkpOOHN0eFRmVEdGT3ROS1dVODVo?=
 =?utf-8?B?ZWxXN096TERxcThERlJWbUZHUzExM0phNEZmTlBXSmVNZktKUmJxak5rYmtN?=
 =?utf-8?B?ZGdZQk1yMkwxNG5HQ2RmbUZuZEtRTzMrSjNQNCs4dGhmRFZiRkNtWGVEekJq?=
 =?utf-8?B?dlBBUnpoYVJ4QjdINDVrR215U2xvMisydVI0dkVFOSswcVIwVTJRdjBSdTRM?=
 =?utf-8?B?VnhnenZVUXJRcmxESm8yd0FLS2MyRzhON3kzMlJGcTU1V3paTEhiMWQ2Z09B?=
 =?utf-8?B?Z0tIcnlvcjE0Y0l1cTlDazJ5aWhMS01HOE0yamlLbnpsN3ZrQk50Z2JWSlQ3?=
 =?utf-8?B?YVQ0NzlkdFAvbG9CWjJXN1ZuMTBPemVITzBIcVZsWmVKZlNSMzMybHZTVzVE?=
 =?utf-8?B?Y0JZN2xmc0FVQnFmaDZQeTFUdkxTaE1uZkoxVVNzelJPWWFyTE53NVRheDYy?=
 =?utf-8?B?dHhPeExhdVBwNExudGxML2QyYStJaERRMHBMZ3lNbGdUUE9vR2lxR2o5ZnRs?=
 =?utf-8?B?c0liY1Q3cWxXdFBIOXNodjJwUWJCdFM5OFNvSkVhayt5WHZKK2JJdEx1dUc3?=
 =?utf-8?B?QkJXN1lTZzhoenIzem9lazEwdTJuekY2bEtFdHFVb1ZFRE1xbllKbFA2eEls?=
 =?utf-8?B?WGFka3AxcUMwWDFJL1B6aW1URjN1cEhqM0lDU1pQOHg1MnlacGV3QlphcUFG?=
 =?utf-8?B?Q0FyYlZXMFE3dXZFbVVnQ3BJZWtPdUV6TmNUd1pBZHVOU0ZtUVdUM2lnN1dp?=
 =?utf-8?B?c0xOVHB1OVlTWFA1cnk3NkVZeUVsNVNSVks2U3lJUDBORlF1alA4ekRpYjNO?=
 =?utf-8?B?RkdudGNwTUovL1gzbjhJVXN6TWQ2WDhVMHJqcVhzYVNJU1N5dDhaVnpYdFk3?=
 =?utf-8?B?YVJGODBmTmVVTDhKRmhMQUJaU0NSOVZwb2dSdHNWYlJnSXFqeWZkaWg3d1My?=
 =?utf-8?B?d2xUQVdIM3MwUGNRbzBIaCtOT0lSRUp5UXM4ZzB2SkI0SU5WUUszbGtBd3ph?=
 =?utf-8?B?K0pxOTVRSyt6QTFzamVndFU2YVg5dzRQZmJqcEFQQWhrZDBxOGRsVUwzdlpT?=
 =?utf-8?B?Nkp6OGx0aFk3NUowRTJ6eml1dmdhNzJsUS9IR3ZxanRjYzEwSWY4bU5veTY3?=
 =?utf-8?B?QUV6R01RQ3haNDh5RUd3T3ppd1dkbHV0Wk9US1ZzM3ZhZjFqTm8yMm9lM2pT?=
 =?utf-8?B?Ulo1Qkphb3dTZGNCN09rKzNzRDRUNk9pVjVLSmgyMU1nUHJXQS8rblluWVFr?=
 =?utf-8?B?OTY5UXNrU1lLTE54bjJaVEgrQTQ1a3kveGJNeDd1aWNMQlVHYzhaU2QvRmRp?=
 =?utf-8?B?NitPZ2JSZFRWdHdLODVxbmZSdVRzNGZVdDhsTEE2NXVJMTJCZ21SejM5Q09r?=
 =?utf-8?B?aURmaGQxM2dHNFVFNmt1MXBmaEdGT1hsdndkS2VwY2U1ci9OK0RzQklvNXh2?=
 =?utf-8?B?OXdrakhKVWU1ZTRMSng0ZVRYazdYMXhUeVFWUTE0dThwRS9xRno5L2l6cDE5?=
 =?utf-8?B?LzZUMHI1QVRQZjQ4MnJ0S3RaYzBrbTVuWjdZOFh0TWRIN1A1ejVlLzhwUmx1?=
 =?utf-8?B?eWFhUkFYYWNGdERxeS9vOWdRZldOeFJpZTRwa1N4c3ZtMHZzQUNFYWNTcHM3?=
 =?utf-8?B?clBRZ3doVTRlREhUYk1KVmE3L05kN2JhV1ZPTUNHUjAwNWUwQk1RLzgybjdq?=
 =?utf-8?B?TTFvS09HeU5CYUxtKy9mNDZkT2lzbVNibGdrR3ArNGZYcU5JSVM2bVFsdHht?=
 =?utf-8?B?dUtKQWJ2SFY0OWNvMGw1ZE8yeTNTOVZadUc3QmdZRllzR3FnUXUwWUoyOWp3?=
 =?utf-8?B?YytDajZINmZFZmFIa2dBTnJiZFl1L1l5am51OVU5MU5JZzBPeFJoQUFGWk10?=
 =?utf-8?B?ZmhjOWRlOXhRbjFYRHUycjhaRTZwbDE0V2NMRTViOG9GZ2xrNm5IYjJKZm9r?=
 =?utf-8?B?bEJZL1ZDek5HMmtNeS9UTzJkK1JNRFcrWGQzSEs3TGVHUitCbEJiMmpIODZC?=
 =?utf-8?B?OGc5RmhoOGVIU0txV0JMd3ludXI4eWljbDBBclVlQ3g0bzIyYWpwSk1IbGRB?=
 =?utf-8?B?K1owTGNSNlZwZ2huWUR1RXVEL3FUTEVhc296a1RBeStyaUdyMGRIZStLT1J4?=
 =?utf-8?B?NEs0c2xENy9jQUFLM0x1NmVRdlZ3aGMwTjJpb3plMm1ZZnhzVVhhTW9wbWJh?=
 =?utf-8?B?V2kxcDlkSWxVQ1A1c1ZTaGlkOGZJMVk5YUxiWGUyVWtabWpjM1BXK2o0WlA2?=
 =?utf-8?Q?Xht17R5MpEYNZmj0=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	RuExl5VQ9umU2eB7+qU3eEMtU5huFYykm3/oIIwOA7cfdkMSSpFZeyQC2WCMgnz26/ZKbkc6bBWrW56luvXheSxL1PzEZ7ID1o1w7jTuM9gHba+IaRIMdur96hO8NdpkLZyw6uphv+pl7241GilP2hU+FQBdVdZL63v50Ts85MMJZBbt5T7G4O3Kf9EGXGChz0SQF5byXG9OG5wOJj6ozNgqTHu9icxqTg0KS6ofqa8H9kdrKIrcEoSIe49uHQ/0XiUQLXGYzcX4oUHZ2pIMZoUaI+epmwmEn7EadETJ0Dakw0w322L6+1/MAHthS8vsclwnf9cnpafnRN019DTPg8MROsK2xAB523RkmGd2NoWfSjeSjdZjQmLzMRTVYrnOPKRP2gZFyh/BRqWBBMlc+vDYsT3WpbpkcS+SvWBWimwlF9B+0addq7p7p+FhyS/tFs6MjXafmmmPKZtbjkWa8NpYFN8qoKExjZkDgmfYwMCUkTBMf5zc80uzIvXLu1iaGAj8HnxsKKVND/pxb1ptTmJ0tbdMdqS7SKUL1xqF9esUeshxV4fFeyJlU564bFUnzg4vetXPhEjru1a7Q3KK9kErKWirPCeuxbokF8sjlfU=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6cd6d65b-9792-4e36-e031-08de4eddce56
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jan 2026 17:46:09.1639
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NIX/Gjs1rTGTd4feditV/Y/hyr2zzi26Sw7IfrW5qcnVbtZjHKGhVQsmFv2w7s113hj7Z09RR5aOeS2eLV3L0BBBbPQQzs4Z3S66HCD4lj8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR10MB6637
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2026-01-08_03,2026-01-08_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 bulkscore=0
 suspectscore=0 malwarescore=0 adultscore=0 mlxscore=0 phishscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2512120000 definitions=main-2601080131
X-Proofpoint-GUID: ALxZNLF0KAfARCWdeIVi71-wyUhetjlz
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTA4MDEzMiBTYWx0ZWRfX9gGRLhk9IQBK
 oz8BM3w8JittAQ0AXrw3Tt5LIiqXokC8o0dgMwiiiqauPgso0yUKjDdHVwBIAprw+GdNNEy0fyh
 yHLQqrGSPEA90ofDvrBbb3Mlm91vfQh9mOTU4U1wxNesICPZy6cKuPdrpnk+8Tn6/j3eROPmsRA
 ylCs/YbR3isJY8poZuyF5lG1zMkKTUIX2NoyPDvNEQdXuB8LvE+ydmN021xpIiqsWVM7K46Jwz7
 eMsnldl5PmNpAhA5d0bCARBVyXH60/hp/dI41iDWM6MtKIvJyWrzWfeXfBWeWK8geRuxrLxTMnA
 y2IG4ADlT4FX3XYwHMWKJfrRzhM+J4wxkZjMjFufzzCjOPZNVjkSnhuvQ7bBhJJ7EI2IUv79+HQ
 hddwheVOVhIbducpim67VCcrCRsGRsdoA98ZAmjHkucPvTg0maq2YKcspBg3fn1l2C3UHutvMcD
 R0R4OMN49mSBGfytCNGQPpOVS3V0mDnitXPY8+3c=
X-Authority-Analysis: v=2.4 cv=LsyfC3dc c=1 sm=1 tr=0 ts=695fed69 b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=vUbySO9Y5rIA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=yPCof4ZbAAAA:8 a=1E7LCmFR4ZN1NHapb1UA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
 cc=ntf awl=host:12109
X-Proofpoint-ORIG-GUID: ALxZNLF0KAfARCWdeIVi71-wyUhetjlz
X-Rspamd-Queue-Id: 2E964A0018
X-Rspamd-Server: rspam06
X-Stat-Signature: 1ey5z9obafotbtuknpoont5463c96u1y
X-Rspam-User: 
X-HE-Tag: 1767894382-896477
X-HE-Meta: U2FsdGVkX19M6PuQsjOhFPltF1LbgVL45m2u57+202vVJOJdhvKxtbo5j2vD62ZjHnGff83hR8wq5zETtwMxki8fetIK3Etm6kQ7xGlQk31N+o4fIWOkLk0//CPIFNnsEs3kJIqs+9g8VAOliVaGzJOw+j4gwGnvSr5W03UfhrhqAgAaV4JF7pXYeotLEcA3N4yizBRj7FUgRuZwO/2yHo/nwRhf9ZFLsLZnZ/+BfRVcimE57jB+5LfMDALSCu+TDL+ez564gqIHXhVFNEGUHTiO5V7yopUIziNFoRcyoGHZHZI7N1eki59XPg5XHVDGrBnFXY16XZmHE+bJ4K65rwK0mDAkxhcQZJWYoq1mPRNYZzJ2YCKcV7mUrDTJB/RszwSHpv1Mtaj2Va7hYM4cWz7cp5/csLKu+8yHTQxZwVdtddoL+LIWdLzWXgCBMPOOz+zA/W/+SkBPSWUwe5YUL63pGLrfdVFklRUOIUWk4mf+G4u/fxY5pS3oUmRpd5rcAQ5hZi7Pu0g9+0z+NB+g/gGbsgoKq7auDaQ3dtmic3Ggk39v0O8yF1oOTHhIxEACYRNDY1RItU100gqF5Guhwl9wus8guo3wqhg35FkoPCFpRRFoZNphVXsp3UGciDdtq/mlStdl6XI4rA6sJaam3VuHQCI6PB8oSYvZ8qOTO6wbhPMerhvDjz6gYSZ5ZEdZq3cFJISB3zqmeZDr+ARXJr7AjGVnCknz1ph3n+ge7hq59TOvueJTzg7GrUJI6nkCWGCABZj7nLoz7lMUMRk0OI2F6u+5acklS577g34UeJOT1fhUEvxqpml/FynZodjLFqF4zLOlPu0oBnLx5Uhnzeo34zb9XFBL3nI3I1U6uy4Zm8LEiV5S7sxgiR7qFp36Dta1PHFXh5Js7PFnSDYSwKFSVK2GAR0Wb2RiXMPutc9ouX9xEhKe0C8Rr1fGtZwmgW/UUs2HXL10bkbpZ91
 zHaeaYsU
 7shgu6SOG4KJwz8nGunWgNSaLk3NIPgCCkdkO9SWVpdsOg6JiTSpA+72wQm6uwn1OH3ZgyCLvVz7oHYTZXJe38DDV0PX3gtyFGxLB8tpW923Ld0aESvLA2F8T8GVTDFjA/+9Psb5ORYRziR2cdztDN2aIOsLyAARLf3YAuAV9BJUAxxn1LuEZWZb7knOIXG/nfjXj3iXTNyAdPAaVrP02KLAQcTkHtEuvv0WvG/mdAiDV8q/d5qL8scWMmWfuZJOW1RmgLiuwkp+4itVbRF4DHlCUeEs9z4znPhVoY/RBrR3j0lcSAI2UFyU5IUqQvMB4hRJo9KnaNBtxGjUTRbdywfajZqzCDeEbjy10l2puNU/EruSXY5lYBGTSJb+VB/T8bkfidUrNs1K51FBWjyDAQqPT/fQkFFgcxYqMc2O3whDnrkrHxhNq1tmfWLJ9rAEbc6j9KmZzFYeVKIDMcZCuefvJCMcOEcmb4gq2uIbZk6Zv4VCI0mmL+ccSh6IyXehFCCRD/rZf/SQTzdRu7Kojnfw5/fZftume3L98w1w9/0xTfQ/ehjteR9yyLRT+RO8BMT6I0ABnnSuQwaoTW4OPvjTzTKrA5FDUxJXsQesLUuPQ38MWlTjbbuge10rXmXy51V+9glKIXKtz53E1wUWXjYXA6HibnXHXd/l/LUUl7NMBPd5wJJjBZTqozGMlzh5oZLUX/gFJKa82fzQR98mwfHOE1A==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jan 06, 2026 at 12:58:46PM -0800, Suren Baghdasaryan wrote:
> On Tue, Jan 6, 2026 at 5:58 AM Lorenzo Stoakes
> <lorenzo.stoakes@oracle.com> wrote:
> >
> > On Mon, Dec 29, 2025 at 02:17:53PM -0800, Suren Baghdasaryan wrote:
> > > On Wed, Dec 17, 2025 at 4:27 AM Lorenzo Stoakes
> > > <lorenzo.stoakes@oracle.com> wrote:
> > > >
> > > > The root anon_vma of all anon_vma's linked to a VMA must by definition be
> > > > the same - a VMA and all of its descendants/ancestors must exist in the
> > > > same CoW chain.
> > > >
> > > > Commit bb4aa39676f7 ("mm: avoid repeated anon_vma lock/unlock sequences in
> > > > anon_vma_clone()") introduced paranoid checking of the root anon_vma
> > > > remaining the same throughout all AVC's in 2011.
> > > >
> > > > I think 15 years later we can safely assume that this is always the case.
> > > >
> > > > Additionally, since unfaulted VMAs being cloned from or unlinked are
> > > > no-op's, we can simply lock the anon_vma's associated with this rather than
> > > > doing any specific dance around this.
> > > >
> > > > This removes unnecessary checks and makes it clear that the root anon_vma
> > > > is shared between all anon_vma's in a given VMA's anon_vma_chain.
> > > >
> > > > Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> > > > ---
> > > >  mm/rmap.c | 48 ++++++++++++------------------------------------
> > > >  1 file changed, 12 insertions(+), 36 deletions(-)
> > > >
> > > > diff --git a/mm/rmap.c b/mm/rmap.c
> > > > index 9332d1cbc643..60134a566073 100644
> > > > --- a/mm/rmap.c
> > > > +++ b/mm/rmap.c
> > > > @@ -231,32 +231,6 @@ int __anon_vma_prepare(struct vm_area_struct *vma)
> > > >         return -ENOMEM;
> > > >  }
> > > >
> > > > -/*
> > > > - * This is a useful helper function for locking the anon_vma root as
> > > > - * we traverse the vma->anon_vma_chain, looping over anon_vma's that
> > > > - * have the same vma.
> > > > - *
> > > > - * Such anon_vma's should have the same root, so you'd expect to see
> > > > - * just a single mutex_lock for the whole traversal.
> > > > - */
> > > > -static inline struct anon_vma *lock_anon_vma_root(struct anon_vma *root, struct anon_vma *anon_vma)
> > > > -{
> > > > -       struct anon_vma *new_root = anon_vma->root;
> > > > -       if (new_root != root) {
> > > > -               if (WARN_ON_ONCE(root))
> > > > -                       up_write(&root->rwsem);
> > > > -               root = new_root;
> > > > -               down_write(&root->rwsem);
> > > > -       }
> > > > -       return root;
> > > > -}
> > > > -
> > > > -static inline void unlock_anon_vma_root(struct anon_vma *root)
> > > > -{
> > > > -       if (root)
> > > > -               up_write(&root->rwsem);
> > > > -}
> > > > -
> > > >  static void check_anon_vma_clone(struct vm_area_struct *dst,
> > > >                                  struct vm_area_struct *src)
> > > >  {
> > > > @@ -307,26 +281,25 @@ static void check_anon_vma_clone(struct vm_area_struct *dst,
> > > >  int anon_vma_clone(struct vm_area_struct *dst, struct vm_area_struct *src)
> > > >  {
> > > >         struct anon_vma_chain *avc, *pavc;
> > > > -       struct anon_vma *root = NULL;
> > > >
> > > >         if (!src->anon_vma)
> > > >                 return 0;
> > > >
> > > >         check_anon_vma_clone(dst, src);
> > > >
> > > > +       anon_vma_lock_write(src->anon_vma);
> > > >         list_for_each_entry_reverse(pavc, &src->anon_vma_chain, same_vma) {
> > > >                 struct anon_vma *anon_vma;
> > > >
> > > >                 avc = anon_vma_chain_alloc(GFP_NOWAIT);
> > > >                 if (unlikely(!avc)) {
> > > > -                       unlock_anon_vma_root(root);
> > > > -                       root = NULL;
> > > > +                       anon_vma_unlock_write(src->anon_vma);
> > > >                         avc = anon_vma_chain_alloc(GFP_KERNEL);
> > > >                         if (!avc)
> > > >                                 goto enomem_failure;
> > > > +                       anon_vma_lock_write(src->anon_vma);
> > >
> > > So, we drop and then reacquire src->anon_vma->root->rwsem, expecting
> > > src->anon_vma and src->anon_vma->root to be the same. And IIUC
> >
> > I mean did you read the commit message? :)
> >
> > We're not expecting that, they _have_ to be the same. It simply makes no sense
> > for them _not_ to be the same.
>
> Sorry, maybe I chose my words badly to explain my concern. I meant
> that we expect those fields to still be valid between the time when we
> drop and re-ackquire the lock. The comment next to anon_vma.rwsem
> definition says "W: modification, R: walking the list". Here we are
> walking the list with the lock but are dropping the lock in the
> process. I think there needs to be an explanation why this is safe.

This already happened though? And yes it's sketchy.

I don't think this is necessary as later I change this anyway, so we'd just be
adding an explanation I'd have to delete later.

I already provide explanation as to the locking when I go ahead and change the
scope of the anon_vma rmap lock elsewhere so this general 'explaining lock
scope' pattern is happening in the final result of the series.

>
>
> >
> > This is kind of the entire point of the patch.
> >
> > > src->vm_mm's mmap lock is what guarantees all this. If so, could you
> > > please add a clarifying comment here?
> >
> > No that's not what guarantees it? I don't understand what you mean?
> >
> > I mean in a sense, if you had a totally broken situation where you didn't take
> > exclusive locks and could do some horribly broken racing here, then sure you
> > might end up with something broken, but I think it's super confusing to say 'oh
> > this lock guarantees it', well no it guarantees that you aren't completely
> > broken, what guarantees the shared root is how anon_vma_fork() works, which is
> > to:
> >
> > - Clone.
> > - If not reused an anon_vma (which by recursion would also have same root)
> >   allocate new anon_vma.
> > - If allocated new, set root to source VMA's anon_vma, which by definition also
> >   has to be in its anon_vma_chain and have the same root (itself, if we're
> >   cloning from the ultimate parent).
> >
> > But I don't think it'd be helpful to document all this, or we get into _adding_
> > confusion by putting _too much_ in a comment.
> >
> > So I guess I'll just say,a s I do in the newly introduced
> > clenaup_partial_anon_vmas():
> >
> >         /* All anon_vma's share the same root. */
>
> Yeah, my concern was not the root being different but that the list
> itself is stable after we drop the lock.

Again, I'm going to end up deleting any explanation that I add in a later
patch where I extensively change this, which seems like it'd not be a
useful thing to do in the series.

So I think we should leave it as-is.

Thanks, Lorenzo

