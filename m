Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B272BCCD194
	for <linux-mm@archiver.kernel.org>; Wed, 15 Oct 2025 15:43:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D737D8E0011; Wed, 15 Oct 2025 11:43:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D23228E0005; Wed, 15 Oct 2025 11:43:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BC4438E0011; Wed, 15 Oct 2025 11:43:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id A29CB8E0005
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 11:43:52 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 4935E1DCEF1
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 15:43:52 +0000 (UTC)
X-FDA: 84000769104.09.1E8CF1B
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf11.hostedemail.com (Postfix) with ESMTP id E467540009
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 15:43:47 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=IWHBpkYb;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=QgpUNlzW;
	spf=pass (imf11.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760543028;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vR8xOWhdHIlDONhMndew7P/ShTiRMZzqWnAltjbY3fg=;
	b=ajf+1XLKZrGdAetLaBxri4i8wLpQ1icNLWaiX/6DNVptxGYVpvGOWDnFq6bIBNY3G/x3Ok
	e1Be4g1urkcjDUk1351106Da8S6/NttNHlErYDB00xcUWTwngcE2/rh0/9DIfjQplWmthF
	JueiWuouc5nQ63REvGVtemSRGSw5DpM=
ARC-Authentication-Results: i=2;
	imf11.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=IWHBpkYb;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=QgpUNlzW;
	spf=pass (imf11.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1760543028; a=rsa-sha256;
	cv=pass;
	b=dunCvntTfAIB3zJWbMdGtGOsgIuddWTUhtP5jICHmLc9iDCjwyL44BTlL9N4EU1xQbqEqZ
	DQ3xEMwxJQpAaPRiJE2th06qhms70Ub1sjuTvfG24eoPS+lA1FsuredMtO8i+eEPIhLHYU
	xNoakTW9vb7XAJo1+IPjCgtgUyzyiOw=
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 59FEuUKf023143;
	Wed, 15 Oct 2025 15:43:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=vR8xOWhdHIlDONhMnd
	ew7P/ShTiRMZzqWnAltjbY3fg=; b=IWHBpkYbb9r6ckr/Zj6HJQDRpNAvm/It9i
	jKDn0CzPHe0a0vrAF2CWBqqHwN1F5f4nx3J+AB3yZnR19kbDlHzhszZwEdwbrYLw
	hvg2sfmRIbT2f4HaB9OwczvlQgtKQxksSO9VVN1SPdlxgsZ6qrG5Pah670F7erkM
	TGAslW/iGypqN0TpqnxBU6YF4nlgLQVIQvXYO3Nb5bfdDDllyDvXPH4c+n7YKwlQ
	cOhVKkIv2HtPGb6kVuimZrMkmfXjwpNTZAaiZIJ8Si3eJ2M12zGFS4hps0KSk4SN
	AWOIbhYKxC7bka1l024vLyy49jqSa57aCyIJat1pNRyYQyA2XYWw==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 49ra1qe2qr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 15 Oct 2025 15:43:35 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 59FELSnH017150;
	Wed, 15 Oct 2025 15:43:34 GMT
Received: from ph0pr06cu001.outbound.protection.outlook.com (mail-westus3azon11011042.outbound.protection.outlook.com [40.107.208.42])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 49qdpafpaw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 15 Oct 2025 15:43:34 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=cTzNmAKahAazUsT60SiT1YnrMTcDLtLglRKGj97utbBd0gQ+19wyt+xTkTwAt1TA6VUAgtj27jzi5va/8mRcVwazwfkTT7iKp9PRhhXfvncGBIrz6MG3nx7QHYSk9JQUbv5jbhfpHBNy2t7pSqijIJcG//8MfqAIt/NhrN2XqLXMdLfpflamVDwetaCbOwbOksKMOrvQWqTrACWaQW2NHJL61s54ToasC3ZATmQF+3mdWqX+Js1zW5x5mOtCdQ5tREDvNF31xAJgFSH4pQzqv80+eQTi0jD7bdiQuTlQsCOJCd2SNMolORYikysaGnm0Q0Y2RoanijnAXb0i0JSVFQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vR8xOWhdHIlDONhMndew7P/ShTiRMZzqWnAltjbY3fg=;
 b=lFuSvuleIUClAHgRmWkEAjO1c/af1F//aBMP2+80Xq/Cx6hCzNK8IQis5M3qhnXER2BDXlBgGpi1NW/4KLD29dEOMzj5w7Nc48GZaFkxt6tI0tPJ5b9NkDL76dMny3UvjS/JuggMWg/UpHCBqbKIFU1jPlKnJDBrwmtboRWesQnTeR5oASFLytH+A60nzpVVyMalrSmbRH1Ew0zy8ETXbG+5Kl4WkaBg4UHjlFacKIYJ0gZN2ccgVv+R+VhB5k4PuDPXDq+h7i28yS/M7baI8Rlb0uBGxJYVZQis/UikGirsTFIZdq2lCwaqkXg7NjQFfd6vWus0TceaABYg91gG2A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vR8xOWhdHIlDONhMndew7P/ShTiRMZzqWnAltjbY3fg=;
 b=QgpUNlzWiKAKcv5UIzgcfxf/OdkYI3idigjjhDtjTrZK4tqnr00XQyNmt/PTNIbIUzyUnOIWxW8x/SfuypGkg45zAXIa53yvmZdlLuaIMMXW14L2E5AMDFK5eZkUX84lNkLbXZxBhS68/kab31lcoc/Z7GXBka+pLbkOupwOEc4=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by MN2PR10MB4270.namprd10.prod.outlook.com (2603:10b6:208:1d6::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9228.11; Wed, 15 Oct
 2025 15:43:28 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%2]) with mapi id 15.20.9228.010; Wed, 15 Oct 2025
 15:43:28 +0000
Date: Wed, 15 Oct 2025 16:43:25 +0100
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        David Hildenbrand <david@redhat.com>, linux-mm@kvack.org,
        Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
        Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
        Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
        Liam.Howlett@oracle.com, Sidhartha Kumar <sidhartha.kumar@oracle.com>
Subject: Re: [PATCH v3 2/3] mm: mprotect: avoid unnecessary struct page
 accessing if pte_protnone()
Message-ID: <db3fedc0-6ed3-429d-b124-d1e67992d6f8@lucifer.local>
References: <20251015123516.2703660-1-wangkefeng.wang@huawei.com>
 <20251015123516.2703660-3-wangkefeng.wang@huawei.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251015123516.2703660-3-wangkefeng.wang@huawei.com>
X-ClientProxiedBy: LNXP123CA0019.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:d2::31) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|MN2PR10MB4270:EE_
X-MS-Office365-Filtering-Correlation-Id: 272678b8-e8e9-4115-bcec-08de0c0195ec
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|1800799024|366016|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?ahNvIPU1817+zquU0mc7bi4INYkDF+HSvs+Iw7u9ZYJ5L+XR5MQaLSMPYfoe?=
 =?us-ascii?Q?zeg3ncaOKnEpNQ9oOEySsqT0i77jgxXz4HZPMvMQ/W0+6FoCArIbFqaVSfMw?=
 =?us-ascii?Q?mRPuyUm63+ckXXEmAN6ygVlGIAnt51P8qWEuVM0ZYdeaic9CnQCGWfsT9iFG?=
 =?us-ascii?Q?uigacLWih7GxDcE+4A2T1X5vsb0lAUwBn7Q8J/q6I2ISFzdpAkeVLT8Qle2V?=
 =?us-ascii?Q?Vz/+ao6CwIvTrcbCyF7oh1WJzu/oZ9K206JLakFsasm1SsSNRV+CHmSiWlgS?=
 =?us-ascii?Q?fAv71W+AEoXOoIPeWZp9KN8fYBgJhWFdRapGWbLXccZaSxj9ovN9ireE6OFp?=
 =?us-ascii?Q?Kx2IuI40gyUmd1Z7R7j6vc8XLulYmzSUN6eYngUkq8g6GgUnCDSLpBhaFy6+?=
 =?us-ascii?Q?2/TmTb7lFQDbDo3SawP3dSRmEKgNjtCuggi6lpGmz7b66/2uhtvSLwaM33wL?=
 =?us-ascii?Q?yANSuEUOfgajLOOiQpOt6LTdk4C0F4Vs3YcqKQjPrZ3Bi0iYmrn6CO2NzBe/?=
 =?us-ascii?Q?g8J7oqh5K0evNRbjR7pcQo5QGyzFzZk/434V7lhqBEiVF8BD647PZ6yV+nOM?=
 =?us-ascii?Q?gP2I7xKdaowMdG0sEq/aQnGPxKfS16gd0L8MTogacm+6hI6pD5tgD09D0x3D?=
 =?us-ascii?Q?v2/Nm33dtL0kDX231Onr7sdcxa3QkfUYresvZsh7ZUuSVtM9ZBMqq727pXjQ?=
 =?us-ascii?Q?PCY4CMGrRW0YJOITfw2I1K7SQpqHMz1lQcfE19mrJlOlvdEZDdKLr72Wc+cj?=
 =?us-ascii?Q?lVdMtREErxBzEvLSPqAKs8EdbJ2wnoBO25yO2/6+us9LsrH8akE59tg2qfIZ?=
 =?us-ascii?Q?WTDFLZzwYlU8CsMPIP8w7Vhs32C7PBO9E2hWZ9Ye6+LvUmNil+Y7643YEZfr?=
 =?us-ascii?Q?23uCi2cArjvcI3oT4e96XSu/202ULxehstuf+89V++PM1sVduwPrDV2mTiPb?=
 =?us-ascii?Q?W7afy4t4/c4hpfKHyCAn5fLGLoByOCRInM6ij5YfTqOYcFp1j1Gxx8MeZKN7?=
 =?us-ascii?Q?nrLby7mQMzAzZiEUQTk3aQWqkGgkQUiRskX5c6zWUdCBMyXzzDXp8GkGTjuC?=
 =?us-ascii?Q?X2Sn50tdSPy6OwxVBKrWgzATh4cwWtSHK1Uym8G5Y05akrBSUoCsXRXm46E6?=
 =?us-ascii?Q?cT2aPab4VfBwBkGp/Ii6S8E692/E57r5f0K/5agmY1BkfhO7uFEoWKjKIEw8?=
 =?us-ascii?Q?Q3Ly5zcAlwSIo7STTUwzIROXwqY7yFWfZwDwdqAB1qvarlloO9RkGmaU3fWM?=
 =?us-ascii?Q?xkkuyEx8Z7R1ZRPlaO1JoEiJLoJsMv3cjAX9ETj6C/61X7aILJJYH4K12Ujx?=
 =?us-ascii?Q?AlJdFIZWDWzOW6uXNjEUeMKadFNzizzCEz8XOi3oiXgpibjB2nXvVLk/PBXi?=
 =?us-ascii?Q?JGkXNbMOJGYmnVb+PMsMoyx+UUvnzHX5nTyoxWi+brQ8dIYs4KYiqAstjtdI?=
 =?us-ascii?Q?wRytj/iNLeyOyYHOuw5EimtoTr9Wg4jq?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?co2yCqcHaxxUoIA7WzgbAyCI9DIN8eAU2lInrMrxYqNF/gWm7hOQzRhN/6UG?=
 =?us-ascii?Q?RmVa7kdKIsh4kFkhVw5g5cpgRLqNfRCw9u9xNuCcKdIn5YHuT0+r8lhd3CgT?=
 =?us-ascii?Q?L1SiWIU6SDBe8EjZe1oOtJrQi8mwiBZtXJBVoWAykuE2jXdBeLA9Yb6yMKj4?=
 =?us-ascii?Q?t8aFCn1qHXrkcsIqVdE+l4WZ56CBwtEXH5OUGzczJ+C8vdinLYOmM9Nwt7DG?=
 =?us-ascii?Q?WMYdtUhYOVXRu8BIwJ4wrX2VP1A7qW3jEnEbUk4Dz7CMp7unLjPgn2BJLiP/?=
 =?us-ascii?Q?//1CKeLk5WdCKea7bgMH1CmFmF9n9U+TCSDtueTXoTCoWMhOaF7TOJXBMknH?=
 =?us-ascii?Q?Iz9mitSraW8rp02/FyvaBwqRSS078pyb56u7hcNm2HHbLHpL8im09v4nQ61b?=
 =?us-ascii?Q?NDTk1pHKG3cwdychHRnwyTF8yKMOLBg2a6ywvKYTu0Li0mpGUaKI1hHAfq0v?=
 =?us-ascii?Q?1QueB37/Fu8DwOgvuwZfhs69M0mzrVnNNaDRczv/USpkSZocfL0KIpLbkpWw?=
 =?us-ascii?Q?/uoa10TO3dvi5b3G6mPSq7hF/Q5gVR9HMyf+jIx6/bxEuZKqNPj8zGa4xN4s?=
 =?us-ascii?Q?2rDkuAR2lFQZNxMqu1+QjGR0sdXWtFyhJ7pWrxPxSvwP6fTlMX00gZcGZQXF?=
 =?us-ascii?Q?uYGzIgkx659OY+9sZtABbK/EDEuMcihhqF+G6sv9WCd3DvcaUcHEBu1iD5BY?=
 =?us-ascii?Q?JC2GvPreNnSbK+ak75788f/g6yuaJV7Fo+HhIK1TYn4FXsk552LNRjYudVqS?=
 =?us-ascii?Q?ddu8opo3aFwHlUFo4lDt9m4kWz6Vz0OY593yXKwi6WIuxJB4XpfjY2PK+nsY?=
 =?us-ascii?Q?v8hyDJfjO5SHBxmhwTWveAOJklkTv6sT1IxV9qGToBVN1Zp7zn8HJISU3ezE?=
 =?us-ascii?Q?wGlGshRQAhMpe24qRna9520ZPwiJY35srpV7DXR6+cvZM0O2Ndc9BEGLfGg4?=
 =?us-ascii?Q?nNMqHVJGLzEPxcddLSRuxj9FId7fepic3ueThD7bkc2H1bcmySYL9OHobBEv?=
 =?us-ascii?Q?r+jgPSbVh7Uormyu82OiIQjULxZSlHJRV/YiNyERczYq7gwhlg5v5LEnD2A4?=
 =?us-ascii?Q?TCv+DWnrNOR09R0/OBoyk4eYyEuT5Gm+CijUp7C8nAi0ZOcFs14P02qSEX70?=
 =?us-ascii?Q?v1Q3Nb3MWHu0KzOTb9j+uAss7Q8GzQx9/sI0zu/VsnapAZXiNbYvR+jVH7JC?=
 =?us-ascii?Q?NDRKSBke3XGs0FJDNC1VP/UpxEA4V/Kp2P+LEaPaepd3BqStOe/MMdSpnp8o?=
 =?us-ascii?Q?Il74PuxuyreEOA8jNzaKkUhx72YLcreMvM5daH+RweMO9F4fd1Pi3lTQ2bBy?=
 =?us-ascii?Q?3A+RqqoXvSzj09UO3jwcGbI2K0fIBaH5EpBoVhC5+i1zM5NAkJQBe4l/p8iL?=
 =?us-ascii?Q?FWCz0TuzK5AFweAgW9KelFnfWr2/Jde5ooo8Cx/f6QxkGuJKwpAHIwLumT5P?=
 =?us-ascii?Q?Nhzes/lycJ27Zx8HQKcu/DePY4+1En740f0ElN8IUQchklaIjUxv8HJpQbqd?=
 =?us-ascii?Q?TjyH06N87Ao0rje/mokBZ6KEffJHu2iJ6kBuGoXdYHSouZjtXONFhB3jHDnw?=
 =?us-ascii?Q?kn+bcQeHJZZJ+eotYjAe7dyrqwf0gpQ8qa3K9BhyA/zhpTIAfktX3ZfsHgJl?=
 =?us-ascii?Q?sw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	7NcuOlgGFKSE0E2S1Mj+KOIUf8jktiVHaTmhWATS20C/GxqEmnRT56YaqamG7ESq6Mwoqx4SqqTPVwfgcqqbVUaRGkmu2wmOvnqmUgf4oZm8IbK3J7PundUfwAfK3lCd46aibcM1S+q2coq5/7lgJ8cQECzXbqjE19YOvg1h1RE9WKxN6LXrJEn+SqO75v8c6uzMn7hTVzGK/6zf1i7NpXoJ9+lzRukJOACm2EhIZm8kRuntZ9Nt/xmGUBXUYKbYQdmA6gxKYMGy4MdxhncQt+nYjXfxOG3M2bT+9J7YLHQ3Zr0J/L6ZYR68Sx4h5PPsLUWQo+4yPRq3gZm7fqCC6OzoQhb48kT244XK0r8fG+AdpukQrr+B4rYj5EJfYtsP7eq5cYT+U30sypdMqiCARBPoN8b9VhdMXDmdgs58RZjVTysNGIQG7n9+c0VrBFl5fEFMDnb+vgZlkkaE6bw/g9LwoY7DMYbWHLpt7223fDu2/ltxA6isOWZKkNuAsQl71LJJ7IXj407l+KcOToha68pg6DnMyqbH5sYNNwSmrj9Lai1REn3yEZg6J2LLgYuusvjWaNF6bqh1adsj7d5AoYYupwy6+Lp+SNhtu279Cso=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 272678b8-e8e9-4115-bcec-08de0c0195ec
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Oct 2025 15:43:28.3698
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CGlB5shp0Bx8MfCVjedqDNhfRpnqQBYNFEg+aYyu1k53+6UXzcdWSZqeOf1UXbZINEu9TsZujk+8keT0YYWcXSlcpbJFqnWkDxZ2VeEh/qY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR10MB4270
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-15_06,2025-10-13_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0 mlxscore=0
 suspectscore=0 spamscore=0 mlxlogscore=999 malwarescore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510020000
 definitions=main-2510150116
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDEyMDA1MSBTYWx0ZWRfX0ucRhuqM+8gC
 PKMZlxK2IKrysEvu+qCp0aLnDo0GXv+z/Hfz70opO10FOVRuRORGMYXcTObYXy8lva0ui+MfghT
 KE+ne8v2J05n6qFeluaPciW+fjfp0hfjEM+lGLOp6LplZ9N7alWeiGvcwDON8m6e7RV3jq6OA8m
 a7jQmVGhQZwqt6tltsD210mpYk12eou9aRFyBssIBgOdqXFkAieJV6JL16gfxUJ+G5LNVHFFmcB
 FyZrlrs1VsLAdnfBfXpmPn4eHygC6RZ10xpuF8oC/EEuKXrNY7E/87sE6hDDfJe4A0Q128Ii+b6
 2L/NL6LBPGu0tih8h2z34AQRb4pba8jRo0T/YrOG3p0whgkggRdwax+EIujPaDQEUnq3OQz/KNX
 keCaH1++AtSjSITLDgg8bCbpMk8Gjw==
X-Proofpoint-GUID: UOnRbd0yf4WD2bLO-fOU9BpFWD4ikU_2
X-Proofpoint-ORIG-GUID: UOnRbd0yf4WD2bLO-fOU9BpFWD4ikU_2
X-Authority-Analysis: v=2.4 cv=GL0F0+NK c=1 sm=1 tr=0 ts=68efc127 b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=x6icFKpwvdMA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=yPCof4ZbAAAA:8 a=i0EeH86SAAAA:8 a=y-5wPqBSZSRXclIosRcA:9 a=CjuIK1q_8ugA:10
X-Stat-Signature: nb47ayf7uruocsq3x51bex3e95rzcr11
X-Rspamd-Queue-Id: E467540009
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1760543027-317164
X-HE-Meta: U2FsdGVkX1+wloy6R81WaY/5/bARNiSNvMYG+G9gOf7CKAKhv+r/n7G+qKL7YQNs1JB8r7X5IRcHoijZettw/HIC8qw/+W90x3qXBC09TigiHY8VLeubU40O578qas6WFVFV8CcYajZReFZROpVjwVHVXXUtLhPk/VAzguiXv2KMYiFh69n3MXlmztH1tzzDxXPAF9OWR8AGmeUzUn2QTRbn1AUnVAMKRPEW4tXDa6bcwRm3I1ndZAs6v8X/BE65Q+vSEm/0rYFiPzIqd60ixC8h5GfL61VXgdUo9SlmVih7AHaC5qzl9W937CJFHo0SloXGZxpK38dqbJ2xhQogZZsGy23crPPaxCqRk5d+0A+ZV7jk89wtcKVoOK5MKKfHlZxizOIy0YscgjYBMmJv6Dp22f6DVLQIU6CbD9ur13/CdyRKgfMV2ms8w9PvyqHEpX7Ldr8VduD/Cs2KC25aYlg96q/nVFgrCzbStfeU77KTzLx7JdiA62p9064nS9RVu1bwaVLWSnz19HGkZGV7bRXb0VWvk+C7brIPAyOLHMddZb7noJBW92FTUCyiNzXfL3GIXTXPbVZkegI9WMqKaWjU+t4s99ABbdFhE/Stn07aEfPxotG7si2oimyuFi/eRrNEUBKXM3CdV0Baw1/p5WQBodoOqVhb+Nqrdggfmd1QVxGIGfj8NQwp+9DnowkSTjaeIwQ4P96lBbx9nVDZn8yhquL3y/MaZ0q1NtGe7snZHmBc/59GBXkN21TtaCmhYqbYHSAUboKpPt2OxI29R/qRGlhIi3v6JfYsPzksDVVGaahwaIMteqPNWMy0OhooXe79NWbO+vi8La0ty3a0mU4TenBabKSA3eWe+1SqglOkW/r1rJxeEMo11Utx2MMx+zRhLPpV5tWFSLSLF3ZWck7YfijFZQdTDCwDAmqgHHgcJ1+FoL1FiIwZAyiLWH3KlFSRusUfl1fbZv6U5S5
 M6iw5JOe
 ks6tV8rpuzUR37Z6ZAQTYcoEK6joJWzoF8Wf2IL7RTWGTBpxEQVtH+UyFsZIr2fA/gBBI9n4x+52i2OxaVgyQRgINs4iBw0nI6VYrNIXQQDLvClTGFgTFS7ynpb93GyjFGblX5vLU1jJLi10GwjRGcln8l+u6ph8kaujZ+PnaE4T/aBSX/T9JsXIMB7Cm7A5NuM189CaIj4x3DnbIZAYHfefOpnPswiEShpX4NqOCgsNG+sQ2XG1qyNdxtXac7XQk47pYUWlTn1ogBr7OzTvi6XWOfcEI/95uJCJP46TdocC7XV+OXG0uhxpFf7yqtFqnMtYBvmpyxTeULgCNVYc7gIDqRCUqHnvMY+xY7eKLYGdH7CkNbPZnajMJOzeA8r/9TPLapxM1tSlk/ux016cB+pZCZzwxnuSM8XcwAFkZU8Zod2P6pp6rZ1OY5o0y01fsUKpbacJ43OyFOSfa4Edsoa40s8mFkeApSgZxmnkYmaMSBLtz2WWAAMI56SKiF0uR5JenV8hMNA7TJFPo/kPHLInBTVR28nb+/nK3DVqf0nsUIXVi4a+zXXR+rB7zG6R4Oq/Bc554CopN5KspAP9bDGpoHwvFsbliAyQSdvsLEI9mPid+uT5PNAVzJsPKn4p+vWlLAyIt/gDaCSgZRJQLCq3xzUpvpLB+y6lv69sOGyALhIbnfomhkfjR6gKg6dXVZaxzld5b6lD68I6pW4ZLAWqfxA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Oct 15, 2025 at 08:35:15PM +0800, Kefeng Wang wrote:
> If the pte_protnone() is true, we could avoid unnecessary struct page
> accessing and reduce cache footprint when scanning page tables for prot
> numa, the performance test of pmbench memory accessing benchmark
> should be benifit, see more commit a818f5363a0e ("autonuma: reduce cache
> footprint when scanning page tables").

Hm should benefit? But you've not tested it? Seems like rather than
guessing you should actually give data. Otherwise I don't know why we're
referencing a benchmark.

>
> Reviewed-by: Sidhartha Kumar <sidhartha.kumar@oracle.com>
> Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>

This generally looks good to me but we need to update the commit message.

> ---
>  mm/mprotect.c | 30 +++++++++++++-----------------
>  1 file changed, 13 insertions(+), 17 deletions(-)
>
> diff --git a/mm/mprotect.c b/mm/mprotect.c
> index bb59a42809b8..ed44aadb7aaa 100644
> --- a/mm/mprotect.c
> +++ b/mm/mprotect.c
> @@ -118,18 +118,13 @@ static int mprotect_folio_pte_batch(struct folio *folio, pte_t *ptep,
>  	return folio_pte_batch_flags(folio, NULL, ptep, &pte, max_nr_ptes, flags);
>  }
>
> -static bool prot_numa_skip(struct vm_area_struct *vma, unsigned long addr,
> -			   pte_t oldpte, pte_t *pte, int target_node,
> -			   struct folio *folio)
> +static bool prot_numa_skip(struct vm_area_struct *vma, int target_node,
> +		struct folio *folio)
>  {
>  	bool ret = true;
>  	bool toptier;
>  	int nid;
>
> -	/* Avoid TLB flush if possible */
> -	if (pte_protnone(oldpte))
> -		goto skip;
> -
>  	if (!folio)
>  		goto skip;
>
> @@ -307,23 +302,24 @@ static long change_pte_range(struct mmu_gather *tlb,
>  			struct page *page;
>  			pte_t ptent;
>
> +			/* Already in the desired state. */
> +			if (prot_numa && pte_protnone(oldpte))
> +				continue;
> +
>  			page = vm_normal_page(vma, addr, oldpte);
>  			if (page)
>  				folio = page_folio(page);
> +
>  			/*
>  			 * Avoid trapping faults against the zero or KSM
>  			 * pages. See similar comment in change_huge_pmd.
>  			 */
> -			if (prot_numa) {
> -				int ret = prot_numa_skip(vma, addr, oldpte, pte,
> -							 target_node, folio);
> -				if (ret) {

Yikes this was gross, decl without blank line after, for no reason...

> -
> -					/* determine batch to skip */
> -					nr_ptes = mprotect_folio_pte_batch(folio,
> -						  pte, oldpte, max_nr_ptes, /* flags = */ 0);
> -					continue;
> -				}
> +			if (prot_numa && prot_numa_skip(vma, target_node,
> +							folio)) {
> +				/* determine batch to skip */
> +				nr_ptes = mprotect_folio_pte_batch(folio,
> +					  pte, oldpte, max_nr_ptes, /* flags = */ 0);
> +				continue;
>  			}
>
>  			nr_ptes = mprotect_folio_pte_batch(folio, pte, oldpte, max_nr_ptes, flags);
> --
> 2.27.0
>
>

