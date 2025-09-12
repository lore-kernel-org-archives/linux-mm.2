Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 741AECA101F
	for <linux-mm@archiver.kernel.org>; Fri, 12 Sep 2025 09:14:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CBA838E000A; Fri, 12 Sep 2025 05:14:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C6B5B8E0001; Fri, 12 Sep 2025 05:14:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B0B988E000A; Fri, 12 Sep 2025 05:14:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 9AC908E0001
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 05:14:37 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 52C3611AB85
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 09:14:37 +0000 (UTC)
X-FDA: 83880037794.08.AE06FD2
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf08.hostedemail.com (Postfix) with ESMTP id 018BD160005
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 09:14:33 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=nlupOeBE;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=Qg9VpxmS;
	spf=pass (imf08.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757668474;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=naQMQP8IBwPLvyVXBDkwkIvWD4C6GeIEsDdXCNgli48=;
	b=PBx1/H4mo23QuCEYn0J8Bt5ydNTAR0QSKouJICNesWAcafsX7Bw+/98yjQZ9Ws+r7SeKzi
	AnSyPflEFCGSIyCXh39x7Vs9v2RdtCeIcqAtpz1qmzzXwCoov6y1DPX+BnZXgdGBndmYxJ
	gTqjYILwTlX9yiE9zV0CeMH6cWAXf6A=
ARC-Authentication-Results: i=2;
	imf08.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=nlupOeBE;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=Qg9VpxmS;
	spf=pass (imf08.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1757668474; a=rsa-sha256;
	cv=pass;
	b=LkzGs3OSgeBcP3LJmKfviD0c4QinjJtdN2dc8GxZITqS/v+z+Y5LAI0unpM82FBk6TMNH4
	NF8YkG5OTsqTJ+iGLQDXMNb1wUFNfiaAuHKoCWQoPm9lT46wJPlQuk/VJ2DkChcjSwY8Q0
	wHL+2y+JnHhr3ZTP9YuRmYtgWWucPHM=
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 58C1tocn008558;
	Fri, 12 Sep 2025 09:14:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=naQMQP8IBwPLvyVXBD
	kwkIvWD4C6GeIEsDdXCNgli48=; b=nlupOeBEJVTcZD+CXC3fT3H04i4ryX71TB
	O07X5cY4g2U6FD1lRaEWbBMoziO6mnUcX+Oi8ur7Xr96DBVDZtIgp629Gt9D39kQ
	cmSPU5HccUFLgvYXgOM8ns6xZsLpxsjdYmjaK7H3TyYY4tL/2YCr4GWWXxEJ2Nx6
	ZVDcrbY0BrEUz1rdjw44PiXOW1afWs8w5d9Ij53pj3YsPsXuPYijVLSwz4O/l3IU
	77LlOMOhBLHaaT/Z4Vfe0foMzTpjvT9srdtt/pzuJ4CS7vELubbD4zVGTn7filGn
	uofjImQS+muxZQthtUXD1bfsSKavLdMMLKFxsCG1s9cVhjADCRbA==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4921m2yuqs-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 12 Sep 2025 09:14:31 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 58C7R6RK038731;
	Fri, 12 Sep 2025 09:14:31 GMT
Received: from ph8pr06cu001.outbound.protection.outlook.com (mail-westus3azon11012059.outbound.protection.outlook.com [40.107.209.59])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 490bddmd0q-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 12 Sep 2025 09:14:31 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=MRKfwpfchgycOSK126+7WUbX05eQQyGx9L4KBAUPHzaKMGrrruHElLD1haHPqFKpAqhk75fVNHPmJ3z35BABE0+SyRGwAkyYq0ckAlwS1R8k3XbhgiPFlM6HA8+WzN4dcf5URUlDjweLa0aZZzEA6xROSvzXw3vWtvSVPtozZtg0q4y0KiU0HPinF+yYy8y3Ao+8jWv2CDzT7WjB7VeJTp7HbDnyok4MuMxWavntm4oBL9g2tQzdZi3FMKi3IEEVoiiAGoQUkVw/bWhMrJTCOr5LxTK0SF9UydwfwI2vcx4czixhN75rCjmEwSCBiyaiX7AT+bMzhxusDyIlm/+gmw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=naQMQP8IBwPLvyVXBDkwkIvWD4C6GeIEsDdXCNgli48=;
 b=vaOVn8kh00IK/9u6Qq/A9dYGOJFmmg1TPfuPfU+2khd7WHX3U0tWwQivI/+7e5vJpaGVRqqD15jkaGWJW356lZX1m7EB1RN9pj5N4BQ4PlvdgzcsYiK4t1JO48m2zhYpgAw61OvJlhsD3zlpgS60DxrKT/uR4HKpLWK4MsVXeUr8W7sby61iBDTx3AysDKMHHUVoY/jVntF2S2Q4O8WJbJDQfJ1zvwu8jN4HXTJ/KohxSBYhm+BxNrkwtYVxh1S5IVfxNDNHCZYHvef5B3tt/s4Qmm/yN9RwafToaA5aRXUmrc8nit2n+m5lTMbzRoOLDY8MHT7pVlfsYQZQXwM9uQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=naQMQP8IBwPLvyVXBDkwkIvWD4C6GeIEsDdXCNgli48=;
 b=Qg9VpxmS36AyIHJgAzuRP1B6VhE0GhzThwwIHczSZNgb9g/yQCJ72dn6U2FqO6Z1sepafPGeACWsncSHpDaHiemBR6DgZnIMNuYbyv/JtQM5qYloVJUThl3rMnLbBQA8AM/QLQNfTmQCC2IeQqTStSCzZM88aJi6Es+n0V+Z0vE=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by SN4PR10MB5621.namprd10.prod.outlook.com (2603:10b6:806:20f::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9094.22; Fri, 12 Sep
 2025 09:14:28 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%5]) with mapi id 15.20.9094.021; Fri, 12 Sep 2025
 09:14:28 +0000
Date: Fri, 12 Sep 2025 10:14:26 +0100
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: kernel test robot <lkp@intel.com>
Cc: oe-kbuild-all@lists.linux.dev, Andrew Morton <akpm@linux-foundation.org>,
        Linux Memory Management List <linux-mm@kvack.org>
Subject: Re: [akpm-mm:mm-new 422/440]
 arch/sparc/include/asm/pgtable_32.h:423:9: error: implicit declaration of
 function 'remap_pfn_range_prepare'; did you mean
 'io_remap_pfn_range_prepare'?
Message-ID: <7b7bbf4c-e4db-497b-8ee4-eae5b64c712b@lucifer.local>
References: <202509120538.KccGKzFg-lkp@intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <202509120538.KccGKzFg-lkp@intel.com>
X-ClientProxiedBy: LO4P123CA0269.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:194::22) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|SN4PR10MB5621:EE_
X-MS-Office365-Filtering-Correlation-Id: 5b17a267-9723-4689-d80c-08ddf1dcc69e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?fAqbTIu6nzGRQOzS+xAahfMEd4ViONhHDC5tzT7yYljN/OrMfheKzNy/TURJ?=
 =?us-ascii?Q?sFr/u66SdffZtEiwa4MGSCaj4pISg8gOkhTx2cXXi59GtXg7HRKGnaEgLkfF?=
 =?us-ascii?Q?CcMt4j9NRCGbPRz3GbXceI97jCM/n84EHM0B+LF05JXk/ySMTTQZ7HGFFROc?=
 =?us-ascii?Q?8pLVgvovofgSY5814CVtJJdX3uGMUopQxlQynNl6SOuAmSjhglHGYv2zlxAd?=
 =?us-ascii?Q?l4nPjhd0O8ogEmKiMQH0lCaUyENz+Lc2+uLxXKTtD1MHxRpc5cXyYRU5sv5+?=
 =?us-ascii?Q?nE3Ou0VFyma/7FrS+W//IZzX765blw7Kfg2vzJjI5b9FhXxYgNgrsKolwFjN?=
 =?us-ascii?Q?fxI5ZOuwuIKm/QGp4T9Veh1RpDmqS7L6h1C3as+d9kW+yGNmMV2yMSzAaUhB?=
 =?us-ascii?Q?DKE0HTLITBFgzPyATThTSnCF0XT+baOY+3JISX3gYvgsrRzhiuhfF4KGRofE?=
 =?us-ascii?Q?wXtt+gGrIwqXlC5D4IIrVwAAEoFRWhkdet9RUomjlpK+phrW1ecgTX15yUxF?=
 =?us-ascii?Q?s55WbfmOELgbDvbGNI/QILJmEccQDe3d3RDxF9t26v6XfGpMzUh60nVjHvJ4?=
 =?us-ascii?Q?0m+3pF/F5xBazj14BqZMGmIGqzr6yJjBFF3cVgQt6mEEoCYJPImFOeNJxcHx?=
 =?us-ascii?Q?xHlzhMTAVIJkNe1hT3iBt2TZOenbB8bmWwliFmkdGhDVRiehEvYkYXg+Hjk9?=
 =?us-ascii?Q?2OypyTxUkgDxxcO4r3/OWPpvIuoVieUGsnTjAlwqwHYrE6Wxz63FErAon1aq?=
 =?us-ascii?Q?YtLnsavi5CkPP/XNekt5xhs2NCqT1lwnZ+ftbhu4SVyEUh6nzr+uG6M0DsLQ?=
 =?us-ascii?Q?4I4AwM/X+d6ghbY44s50+6tUh8PcbdHFNPkZJ4t1ZXHMzAUJq+2E+Ul8Kq34?=
 =?us-ascii?Q?HC52ZOMsQX8FKGy+zeKnkK+cMLEDvstijjB47fhXpIjnfAySMOcoykCxxPnz?=
 =?us-ascii?Q?vGYsKlMAgaGe6EGD9vAFp+i8QYGPA11tyeJBucebiuxzDEtug5iv/klDw97t?=
 =?us-ascii?Q?aACQ8WjYsBLVWWkCN/dGo+Chuv2lL1R8tKWpEYqZ7pck3UxL+2wkAfqaeEoc?=
 =?us-ascii?Q?+K5w6C6ViZDSJDvvilaaRYVlUt3i4mY5DjL/MD+/3W+f/1nPJ4qluJP7SfSI?=
 =?us-ascii?Q?WQG/zq/R1j4mK0XCUoIdyYNq+M3DUVLJ3bkg6pAsMT/7JAPQOGxMOWgb4tdK?=
 =?us-ascii?Q?rttdm7sY/sEmyY9S4oqohH7ke0HyXgqXXjp+p+tnJjAl6/NGovRJf/xxZuTu?=
 =?us-ascii?Q?64K8SCG7AY7s84Ch3ZpAVFQLdpR21hKdtZQ70AZC9h/p5WFrDe2TpLowHUAC?=
 =?us-ascii?Q?K4TQAVEbYv6y1DRE5YlyhhbOyd0W2J0oBfcujIjMWGK6bzdqJGHzjP034SXG?=
 =?us-ascii?Q?C9Lup1xZ6dNiOMUW38mmtZkJU8w6?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?gtsyUKwWzoKyArjSbn4IMpJZREXp7nGdjIJ+I91utrpce+P81ui+bMhqxGmJ?=
 =?us-ascii?Q?TTYThGVMrzXuZEloZbm4sNdGlWsc8PhNj8YxTiMsYQPZcd5I6BF4Y/q8Upud?=
 =?us-ascii?Q?5F3+U+SK9ndZ26RD6J3d9qa37xpEJLoHJMB+h35J4BXJzLiVvCn7A91OTG64?=
 =?us-ascii?Q?DrUYDXrvD1wrkPOVYPT975vvrsJBDxWrKJ4h4M151R1FZaMay6/MOeleocFI?=
 =?us-ascii?Q?zRoIhvVCHS2ZytGUeZzbp65nr8N6VNsTWqdByehw+JzjBwJP1rBObEbJANd8?=
 =?us-ascii?Q?VOddcEYJFHERvWdng+OlEQan8OWkxlsNtpbAC8Sq7nRAVhebQFOnL0CW8q/V?=
 =?us-ascii?Q?bW0Fiz5A4wIzwPgl9v4bYDCpCXui3TipWe8IYbtAhHGP6Uq1fIirW5EbOX1/?=
 =?us-ascii?Q?PnB5JafZS8HoWeALDcFV6z7ZgsWBJb10HaNiBGGEv23SI6dbuMh3f5l+twmP?=
 =?us-ascii?Q?uE8VI42RTbUVh70rNMQ8Ofzhb3byPXRnTzDx0hmQWchy94SjRz1PuCfpFlJF?=
 =?us-ascii?Q?bpqa0HiEGu9nlJNp00lGrtbGlEweTxWIKgZKH4Z66fOYWT8YYs+B0P3Lr5fX?=
 =?us-ascii?Q?73DaaYCAnYAyR8rjNNdT8KCiDWV39V3Lirhm05EiizQijL5KRb0ytDHG5IwA?=
 =?us-ascii?Q?WoJDrxVOa/V4yji6R21MtbsLEVAJETexMaiLgJZng8YXwV7gEmTJIimpiNxC?=
 =?us-ascii?Q?XWQw3ybFNrHiaA4jMQ2bV5Wjami1r9RerZgYf+/BTf5bZc8JKz0pCM4ib42T?=
 =?us-ascii?Q?COuz+hmzs/It/QzJISh9xb9CuMo4IuzOkOyd1PApcCkaUewZG850eSwVZKoh?=
 =?us-ascii?Q?+vV21gLi7FjEsP9BDlviXkNTM63udfZaWGDVF5T+NC9LMGz3nTHo6Iy3YZul?=
 =?us-ascii?Q?KCfKMOh/tQurTNHmP4O+rck3ZfBIxPAR1IZ6gs8VwYLSQdMcPz1Mhj+QqfyA?=
 =?us-ascii?Q?40Zd8puNkSjUoR7te7IVR7JpZv2Z3FvblulMy+1nWljgFsEVVdut360pjPIq?=
 =?us-ascii?Q?eGinpoCXEIaO2u5wqdQE8Vz0KBScg5dMp8GzQuCUrYvcq/DHQEugnUqPOB0c?=
 =?us-ascii?Q?dawLMwd9My80O6k/hqx3kHrj6PFya8iFgHnG0bgbuVNbQ90JZPEL1LhTiYDG?=
 =?us-ascii?Q?MDKBMuzNL2/M617IqoJiJ8f7oT8XFzvX8PMuNTQaeMvoM1FVVNgqBgE2Y1s2?=
 =?us-ascii?Q?bMNP3a2fOXSB1C4bpiT5LjPL9V+N/2lTuH583slTXs5wdajjNucMX9/9Plp6?=
 =?us-ascii?Q?kW/Npw40Qy57FFAmC4D3WAgrFS/V80Q9Oer3trjv7zCIN8XrPg03UP5rUR6/?=
 =?us-ascii?Q?3SoRIttk/PzQTlTMOIUtGnEodYKjUNnp3I4cVh+55XnqGvpZ/ou4XQcNJ+4v?=
 =?us-ascii?Q?GKNQPhQhSupu/WE6jZcYjXMK/D3cY/aZE22zU4XtSFQm0oEMIs9DaHbNTqsb?=
 =?us-ascii?Q?fP0r7MMrylqzD2YYS9IE8W8HPFxa3pMbaZ0GgVZa48tApiGrn3MICEiQcxwX?=
 =?us-ascii?Q?oZdAjyqkPaqXLeT7lI+xAi41BIcBUIOdsskNn7Q5zyQLowoaCwXTcrRU4c70?=
 =?us-ascii?Q?z7mFvU+rFf7BGTjD2/91Mnwr4VCs4d9vxyrxaqNZrgoDcTg6J7seU4nHCdAu?=
 =?us-ascii?Q?zw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	QktucgQM0mEgZuKQ3j7lce/uxoPxz4G1hYM2eqZGy9fngeumKr0oBrxqou/IBEN8u8g/kBrZy3lZiKpMQTc6nHac0Xp7FAM8HRiATVw03M8hmdFKCMmGPmojyhPplDR1+dI9xm5zZGzL+g0+KIi7stAIAmGQQRB0H89XwyMhhVlebXRDBXUUtd/g4jDEyqhhyG5SENT8+pYcSS4BaKf0yDDysHKfCDgpH51mHN37VFZEYfto5n3Gee1upsH8HSzbWWuhjskHe8/uCZyP9dnIXYuPtdkAU356iz7vd7x9is2woBAtwf6470YFc4bB0WdUGcl5LJaff0CxpDJyoS+xV+ywCIAyNhBlgJhOBFVfPGh7M7nxOk2sraW+yp0695m2aoKXSRpmsXLurl1BkPObvsy7Bwj8+bKYVD4zjqmXW8OeTssmHj3JYO/RIj+GZVvlEnzzixlPbKMok4VRH0I5OYGqouLiYPCL9vPCU4Aq7pzrqxGidtKs+QNglm6hF/TOstKOglFPBLtri3rM0AU6MqHoe8IGhPQwurN+NS/vcRctsSGbdZrTPkA+WqRoDTPkEgEXp+wxtKEeK//pkdcnw9ufapCI/imAwazHkCYoTzY=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5b17a267-9723-4689-d80c-08ddf1dcc69e
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Sep 2025 09:14:28.4494
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: f0QGkcu4733ig5sRw6ZCZ52OXUQXDAL1Mgo5/HVusdPe9michoE1PdpDKVb1t604UDIwp5Q5Om9OMwDNUz+z2mfVLkX1zNYIj42qxiMsHK0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN4PR10MB5621
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-12_03,2025-09-11_02,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 bulkscore=0 suspectscore=0
 mlxlogscore=999 adultscore=0 spamscore=0 phishscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2508110000
 definitions=main-2509120087
X-Proofpoint-GUID: faIPrwO-tRKKLngnZF3yZvb72C18k15B
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTA4MDE1MSBTYWx0ZWRfX1VaLMWz30l2K
 0FCrV0E0skZxeOtv55KkVccthkt9W7xgtAJBm2+eQzO8DH9Q8HPGd46SHANcUetFQKjlOlO4L6+
 YzYRYvrZfwWr309fBxllQdapsANomGgRev/R3riV+kUT1zdjBwsE/26vOmA+9MKSsnWuVUBHQJA
 z3k6YBuraJHwv78dpi8vdLy2KgeWJCzRVW40Ni7eo3euJwjatfado2RgtqTENqBuFbKeHyfElKT
 9v27ESueFxBr3YTUQMRAqBfbZXkTAk25nUfaeYLRNgm9emz3E0vb5LFrVKicBFQzJQW/aVy8lAO
 d+9oMwffAwQnPj/xuc+6BEkO7Vx+i5bAMLArtn5yHsfW3olF7bITW21/6vM+gSDvvRafPPOJjPz
 L4xOY8h4X9SKMoueuVs+wqL1CENLmA==
X-Authority-Analysis: v=2.4 cv=Dp5W+H/+ c=1 sm=1 tr=0 ts=68c3e477 b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=yJojWOMRYYMA:10 a=GoEa3M9JfhUA:10 a=VwQbUJbxAAAA:8 a=i3X5FwGiAAAA:8
 a=QyXUC8HyAAAA:8 a=NEAV23lmAAAA:8 a=wEGDaNKjCBC1BL7HHsgA:9 a=CjuIK1q_8ugA:10
 a=mmqRlSCDY2ywfjPLJ4af:22 cc=ntf awl=host:12083
X-Proofpoint-ORIG-GUID: faIPrwO-tRKKLngnZF3yZvb72C18k15B
X-Stat-Signature: t1yhqj81t9quay7ax7sbpnutdkbs1w4g
X-Rspam-User: 
X-Rspamd-Queue-Id: 018BD160005
X-Rspamd-Server: rspam04
X-HE-Tag: 1757668473-298946
X-HE-Meta: U2FsdGVkX1/zPW3w5pIipzeZ077/0SfUQsYjGdr1zSaE9DxwX7PurLYv/9jUF4Z2kUY4Ni03aTorEUC28jvSXc9YALJ2MWmbxqj/BjR3ZR0GRi2BzrvMk5OEG8BeXL1xfHe9la3q2j/nSxoeJy+pEJZ4fyPjpP2y11VWixCZ1f8dV4fU/AgANHxIrca3XGJrGAvCbHHkhcScDT/c2qz6mXxDC5H/yOiubnRzZYkoc0ZoM23ZeTt7AmjFci5MpbN3zRlsoQph1QVhWjKwio9ym6kBMclfJxBeptr+2gqXpY4yJEBoY/L++iu6c/y1KfSI5cBpibqrDWPFXDbXEk1ZIchXCokn6Uj/8Gau93jhn1nsQ9IZYPbejvZpQbdBC7VNFqvkz+M864fJSgD8eE13MJ+7REAm7SkMZpX+Q2nu+LiSytoBLu7a/9IE739ZrNtX1g4kPt1HxExfXA68K3hZ+uJQC31Csa4NMWK7lg+TQVmJ07FSzcBvjDGhKMFDrFEzq6UTAwZg/kF7LyZGx7e95hEFvhEk+Nf/8INIaU3x6i4H/saqtJOYvqij3voyZ/JneM4+PA2TlnvQQq2rwIJJMT1T8zbRL+5ksIyAjcUhASUVYT+3J3HhwMwOnQOASbnvMrYKwaPFMtvDZ88Lzyfw3Z6gNQBQ7xP88R9xa8ScqTg/gwYKpyeKrIwpZgAk7/vfWz19L85HFszs3cLs187LtrnAkAAue0zKEqf/uCDoCnnZfERC8/OumXCEQexjTFiE2Je2+VJHkXOwcOQnDXG+6I+k2YkOo9hwR5hFV4WXaeuuMVKIWTJAfi9HRgwLVzCfeSxFZB8anORGJcecGe3iI/tPrHM5sGireJNWEb8by/w0rMsmsg0hasSvbH+eDa/utYmtohaBcJzirbdIypuHRxwO8393iwBL97tBhwtDdZKceZJOKJgUm/+VfetmomKaMXzVQSLdtPtrCMMS2SX
 ZQlnI2Af
 gOWBG6w2xTi4yldjX28cZKvO3vc8+UjovvykMLw4qADauj2OyC/iCDodFa0FJ8b5TJLA13lqDGafOEDox0V9G5LBS9BlvpNrmhFBdRcEqpdSDtkqKUB+WzkfAsEOVKbtTdWOQ18Ol8F38uYVR716RWlAtxpUiqm4MuJbLL1BtPrEEdrx3hrpztM3vj9hY1k7N9I4qwH04nO1zrRRynX2vJi4U1flptI34+qQP+FfeBeGdtLhIjI26YdWKsvMoUTe1/nFGb0aVARrwHOEYVhg27ffHqlsc/oaj2kwaAl6A9E6MUUBK+NGDV0l22WN9/7CMwf37fk/mIvTPJ5huqUdZ6OoA3PVkRrOiAW2xvqttktCG+ITkLwkVRilosGRuWYkQL5OgG4jxK139ERAU72WezIWObGW1634Vmw2P1fPWc+KGlcoNxjBLFHbx1CIpf+NtUCuuCrXL8AiEJwr9vCBXNoVyNfguBloloSCY+AeOaRfsxyDrTkSu3tBVZnYXwMXCZd9pwic2/5qKDdOdfso+x5u7/yeDbN0W/dw1Bk75MDUz5j8rbCKe5z7N8HhCkCNaj2HQTUeWE3LTsU+XS5FZaFIL+ncrig567KTD477YwEaC2vUf4szJciLWQUt5RcR7aSMGq1zE9ynaZ4SOUKnsHb1FzlC8uoYZtxORyKyf/wZTg1bzPJBbXB4pJFO9glrvKgFrqIcRvS0Akdxa8cQeWjYKnpu/hUvpCsb0vwU7ThldGQYL22CiNb767VebId/TTbotAqDFFh59tJvPS1p7jnlUVByOVfJMGiwvNxRjEZ4LZ7DuVOsnBcT7fud9/dais9FIZSB+O3ODSu/SDftq0Zwm10SbcSlveBj064Y/Y44uypEOgclInpTTRu4Hp7sc+TcdYu5XnIR9mqzYTLgsEE2xtMLI5Dcn2Dv0oqbjO8LpQnPzMOUXcFuBXirwedLUxdKYWQ4oTTtXWyfhZEpbihYjTgA/
 WCJojSZY
 ZiRvt4Wl4o+iWUt3E7eKsQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Sep 12, 2025 at 06:04:19AM +0800, kernel test robot wrote:
> tree:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-new
> head:   31690ac95cb30fd036eeda36844c6e2820685e7c
> commit: 04ff8d62985b8be5f5fc8547a828fbb051c2f927 [422/440] mm: introduce io_remap_pfn_range_[prepare, complete]()
> config: sparc-allnoconfig (https://download.01.org/0day-ci/archive/20250912/202509120538.KccGKzFg-lkp@intel.com/config)
> compiler: sparc-linux-gcc (GCC) 15.1.0
> reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20250912/202509120538.KccGKzFg-lkp@intel.com/reproduce)
>
> If you fix the issue in a separate patch/commit (i.e. not just a new version of
> the same patch/commit), kindly add following tags
> | Reported-by: kernel test robot <lkp@intel.com>
> | Closes: https://lore.kernel.org/oe-kbuild-all/202509120538.KccGKzFg-lkp@intel.com/
>
> All errors (new ones prefixed by >>):
>
>    In file included from arch/sparc/include/asm/pgtable.h:7,
>                     from arch/sparc/include/asm/viking.h:13,
>                     from arch/sparc/include/asm/mbus.h:12,
>                     from arch/sparc/include/asm/elf_32.h:94,
>                     from arch/sparc/include/asm/elf.h:7,
>                     from include/linux/elf.h:6,
>                     from include/linux/module.h:20,
>                     from init/main.c:18:
>    arch/sparc/include/asm/pgtable_32.h: In function 'io_remap_pfn_range_prepare':
> >> arch/sparc/include/asm/pgtable_32.h:423:9: error: implicit declaration of function 'remap_pfn_range_prepare'; did you mean 'io_remap_pfn_range_prepare'? [-Wimplicit-function-declaration]
>      423 |         remap_pfn_range_prepare(desc, calc_io_remap_pfn(pfn));
>          |         ^~~~~~~~~~~~~~~~~~~~~~~

OK I guess it makes sense it'd need to declare this _before_ mm, and mm declares
remap_pfn_page_prepare().

seems we deal with this by putting the decl in the header for remap_pfn_rage(0,
so will do the same for remap_pfn_range_prepare().

>          |         io_remap_pfn_range_prepare
>    arch/sparc/include/asm/pgtable_32.h: In function 'io_remap_pfn_range_complete':
> >> arch/sparc/include/asm/pgtable_32.h:431:16: error: implicit declaration of function 'remap_pfn_range_complete'; did you mean 'io_remap_pfn_range_complete'? [-Wimplicit-function-declaration]
>      431 |         return remap_pfn_range_complete(vma, addr, calc_io_remap_pfn(pfn),
>          |                ^~~~~~~~~~~~~~~~~~~~~~~~
>          |                io_remap_pfn_range_complete
>    In file included from include/linux/ring_buffer.h:5,
>                     from include/linux/trace_events.h:6,
>                     from include/trace/syscall.h:7,
>                     from include/linux/syscalls.h:95,
>                     from init/main.c:22:
>    include/linux/mm.h: At top level:
>    include/linux/mm.h:3643:6: warning: conflicting types for 'remap_pfn_range_prepare'; have 'void(struct vm_area_desc *, long unsigned int)'
>     3643 | void remap_pfn_range_prepare(struct vm_area_desc *desc, unsigned long pfn);
>          |      ^~~~~~~~~~~~~~~~~~~~~~~
>    arch/sparc/include/asm/pgtable_32.h:423:9: note: previous implicit declaration of 'remap_pfn_range_prepare' with type 'void(struct vm_area_desc *, long unsigned int)'
>      423 |         remap_pfn_range_prepare(desc, calc_io_remap_pfn(pfn));
>          |         ^~~~~~~~~~~~~~~~~~~~~~~
>
>
> vim +423 arch/sparc/include/asm/pgtable_32.h
>
>    419
>    420	static inline void io_remap_pfn_range_prepare(struct vm_area_desc *desc, unsigned long pfn,
>    421			unsigned long size)
>    422	{
>  > 423		remap_pfn_range_prepare(desc, calc_io_remap_pfn(pfn));
>    424	}
>    425	#define io_remap_pfn_range_prepare io_remap_pfn_range_prepare
>    426
>    427	static inline int io_remap_pfn_range_complete(struct vm_area_struct *vma,
>    428			unsigned long addr, unsigned long pfn, unsigned long size,
>    429			pgprot_t prot)
>    430	{
>  > 431		return remap_pfn_range_complete(vma, addr, calc_io_remap_pfn(pfn),
>    432				size, prot);
>    433	}
>    434	#define io_remap_pfn_range_complete io_remap_pfn_range_complete
>    435
>
> --
> 0-DAY CI Kernel Test Service
> https://github.com/intel/lkp-tests/wiki

Cheers, Lorenzo

