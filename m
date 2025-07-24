Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 15CBCC87FC5
	for <linux-mm@archiver.kernel.org>; Thu, 24 Jul 2025 19:07:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 752558E00B3; Thu, 24 Jul 2025 15:07:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 727828E007C; Thu, 24 Jul 2025 15:07:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5C8398E00B3; Thu, 24 Jul 2025 15:07:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 460DD8E007C
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 15:07:38 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id F1AE91404DA
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 19:07:37 +0000 (UTC)
X-FDA: 83700092154.23.418A244
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf03.hostedemail.com (Postfix) with ESMTP id 7E7D320016
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 19:07:34 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=kS2hXitN;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=MLiDqVmH;
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf03.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753384054;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=U2xrwxhLxv4frlpGHBeDgdgnS8BYgPxkcx6aztfrvKI=;
	b=SIpJ0CYZftSbaPdriU7XVEk8LXDGyul+wjkuhI2X1al+ajO00MOl0qxMtCMFHqOLkVz3SQ
	LL7UW+BWYDmV79Jd/9TMqRTgvUhoQT+/Ibx5nSaGSvHwOZx8N5hJXjAHa2U5clzOOmrJzB
	YwqVwQnYM/yGQ2pOyZCbXz9ibt/Ce1w=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1753384054; a=rsa-sha256;
	cv=pass;
	b=Theoa9oCGjm6AtPAyIVDViWIsoMO5rzBFQndCNcSRjaMmO6ke+KVFaj0TDlSsdSvLvGY/y
	MfaUcMK671EzwCTSJi+4qrjV18rhvjoJL5EJiRrjknyJSX4WpLOO79J6r5i3U42C+Cw8vy
	arHGA29pzQZilhhPm2vWQ3jWrW3tbDY=
ARC-Authentication-Results: i=2;
	imf03.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=kS2hXitN;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=MLiDqVmH;
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf03.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 56OGixZk021700;
	Thu, 24 Jul 2025 19:07:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=U2xrwxhLxv4frlpGHBeDgdgnS8BYgPxkcx6aztfrvKI=; b=
	kS2hXitNsEaOUjxtRHiRCS+ddAVG4G0Pdbq4XYSJ4xHOcN4jZbmfQSP08/Al3YGo
	n0Y92xekdCkzKmeuu/oxegFUm4duX5yN2dFDXE1tEioRTtBUGlEcoxve4nczzj5t
	Xm+1TAI0G/YBbSJl5lbor0WyDmZHBddnq2S0jkWMgfBEJ5IdXVg4GPcm1vvN9vZV
	XRqnaS1oyl9E12JuNKeRsyoM15Z1lk7keEjgdybRdSbbYXJxaGP89f7YQaZV6Ou0
	X4L6765q6vqqYc4J/TCzGm7Tb6bl+YCj04eCQqUoyroXP6s61wCskkw9U0kxWiwo
	dnR6gElCeg3eJoJNo+W1Eg==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 482cwhvrfw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 24 Jul 2025 19:07:28 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 56OHVJOj014366;
	Thu, 24 Jul 2025 19:07:27 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12on2076.outbound.protection.outlook.com [40.107.244.76])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4801tjjd71-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 24 Jul 2025 19:07:27 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Gt78ViufxMJdiLY4fcfhLrmGA+WFDuAdTewZgmnttzDSREkjlccbM9v0a7ZeUgB5JMFlGd+k7mr9oN+0GFZTywWWjAiq1eZN4PoTPZYXhm+yFkLwvtKTfYZvZ/qBFeAybeZSpVs4vFqSukOLQnu5G51hAUuzu0YZrjxQH+wTjZWGppmjFIzS7es+R4At22N1cX4/bRLf0hlCkyOL9VTwTH2ilib+258CWiEZhKAymsWFktJIaMGBj+ojexxgyhS6lk51YD2rPlAFXIqZC03/RqbeGVTb6bANJfynov4K7nl5uoNrZZKEXPj/sn1Z5jJPTiOBf1k7DWC9gzNI9FFLjA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=U2xrwxhLxv4frlpGHBeDgdgnS8BYgPxkcx6aztfrvKI=;
 b=Z6zIeQi12SlGS0SbvM7oOPGQROWBEU8Vh+xiXzbKdOmTHRkFuQwsr068ie8xwKqLOwvwRggK9pocdjiLXieSTYJQ1bbKj3LqJnbpZo41WojRacAgFigVwsqlIstVv0pBAEG5bSnh4MdedJwndZM8IjM23ySfHzqSrt1RQmL3ePIojHePt8slPnE6qj0n/O5MaXr/AcXu3mqKrYZqxtKfLRClntHPGKAUngHk2wL3h9a0Acme9F2Ann6qYgG/IhBlcGeK9cWqiG0O31OV9UvvCDSKPL3LH1wsAdUN8ATuDOBi92YiNiA4hW9jVcOIwil2hEMRN4j7HzTA9XrJrHtx/w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=U2xrwxhLxv4frlpGHBeDgdgnS8BYgPxkcx6aztfrvKI=;
 b=MLiDqVmHsHOiM92KZvBS+KKTcYsaTX8bXTIgKRoSlyZyAZT775BIy4qedLQTGmJNtDqK5cwNk5b+YlqZTYbBe1Q0KU2r+tlB5oAPQkM/NhJDLjAQXIZ0GclPusSNQVhtVXhjVcy71a/jZqWxSCnlpmVnUqshbQIot9NVDHs7uc0=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by CH0PR10MB5162.namprd10.prod.outlook.com (2603:10b6:610:de::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8964.23; Thu, 24 Jul
 2025 19:07:23 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%5]) with mapi id 15.20.8964.019; Thu, 24 Jul 2025
 19:07:23 +0000
Date: Thu, 24 Jul 2025 20:07:20 +0100
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Jeff Xu <jeffxu@chromium.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        "Liam R . Howlett" <Liam.Howlett@oracle.com>,
        David Hildenbrand <david@redhat.com>, Vlastimil Babka <vbabka@suse.cz>,
        Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Kees Cook <kees@kernel.org>, linux-hardening@vger.kernel.org
Subject: Re: [PATCH v3 2/5] mm/mseal: update madvise() logic
Message-ID: <38ed372a-4b27-498e-bb3b-f95792bbbe27@lucifer.local>
References: <cover.1752687069.git.lorenzo.stoakes@oracle.com>
 <ec480dc1fd4ce04bb11c0acac6c6da78dc6f4156.1752687069.git.lorenzo.stoakes@oracle.com>
 <CABi2SkU75e7tXcpgnLbDhqSJBWVPOvmfMh2uPsU3mUjMUhhYqw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CABi2SkU75e7tXcpgnLbDhqSJBWVPOvmfMh2uPsU3mUjMUhhYqw@mail.gmail.com>
X-ClientProxiedBy: LO6P123CA0002.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:338::6) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|CH0PR10MB5162:EE_
X-MS-Office365-Filtering-Correlation-Id: 68d1b25a-6864-4ca4-31ab-08ddcae55237
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?OUxQQnllZ3NZOGRjbVp3b1pvY2FXSm5lcmNPY3dLdmFEckNVUVhJYUgxeWdk?=
 =?utf-8?B?OFRYVFgvYS82V0lIQWdLZlpoNWR3NzdJelExTWE5TFF4NUZ0b2srTG1xRWoz?=
 =?utf-8?B?NlhTazZHbzNLV0dRbXhESzJVeDhZSTl0VjNVNmVqNEhrSlgvRDFsdGYxQzNX?=
 =?utf-8?B?cUZsamEzenNCek85cDN1M0Fxcmx6MzJRbnhsTWF5VmJlbVIvVzNkRG9zS3NO?=
 =?utf-8?B?cXlwLzBFUmdoVG1laVh0WmtKdGFNeEoyZEM4RFZsVmNZVFlFM2tNVWU3bHZN?=
 =?utf-8?B?WGd0UUVjNWlKNFpSQkVTSG43T0J6bGNlTy9hUUNERTNJdGFhYklhaW9Wd0th?=
 =?utf-8?B?eGY4cU9rbzNBSXNhdTRHbVE5c3JVQU1SU0hTZE81NngrbWxzNjRSejhJU2dS?=
 =?utf-8?B?YlAyYW5qcXkzdXZ1bzcraW9OcWx1ajhWWUk0eFpBZjBZcnNoSlRjK3lRdHZS?=
 =?utf-8?B?WS9zcDhDTnIvOHZDNkFlaUFXMkdlaktndHlVUGphTkZXQXAycHAyQWZLMFZD?=
 =?utf-8?B?N3BiVXI5NWZGbDJ5ZGdoQ3BsY2d5V1dZNkhEanJ3YWx6S3RnMmsrVm9HcnNQ?=
 =?utf-8?B?R1N1TERDbUhvU2JTVlZkK3FzRlZaRU9qTlRZN0RFWUZmSUtVWEtQSWlmQmN4?=
 =?utf-8?B?UlhacXdpVHFVSWNtd012SFl2c2VNenVxOUpsQWJKcU9OUmNldkZ2VVJINEFQ?=
 =?utf-8?B?Ti9LOXd1bjkvdUcrL0U5Y3M4ZE9YMlNqWnlUd2JQZmpRUWUxY0s3b09QY0Fa?=
 =?utf-8?B?WmszSGZHSkxzajJMUjVySXVTblZKakFZUTh6YjczUHlSTVhudktGOTVSTXdW?=
 =?utf-8?B?QTgyNkxJTUNaV1U5TXlUM043ZUQwbDVLYTVaWjNDRENKMWhzdkl2cjhITHV0?=
 =?utf-8?B?VW1USmIraGFrbkJzMytVaXp0RlJhNktXeXl6a3FmRU5Bbmp1TjloRW5veGZy?=
 =?utf-8?B?aGJTMlZhWlhTL3JKODVFTk1XVFpNcmRpQXRFemphcHFjMTdEVzN1aVFUM0E2?=
 =?utf-8?B?eVV5ZEk3YWh3ZTh0K3VlbVh1bm13RmdvLzdDTWZ5WjVvYUN4Ykl2bGdZVlVR?=
 =?utf-8?B?OG8zVXJGRzNXZlQ2ZTFyaStEMGlvZG84QzJnTy9rWmsrdVRxS0M0QVFMSW9Q?=
 =?utf-8?B?dzY0SWVJeWNmV3ZMSGZzYlBwd3p3YUFxdElVdVEvU2h1cW9Zc1hheVJlZkN1?=
 =?utf-8?B?ck93ZU5GZWN5d3FDUTVnRGpabEVycmR5SURINWpYbHB2VDZIT2NBaXZocWtD?=
 =?utf-8?B?eVVReFNLTU1PZThGcXIzdWwrZ0poRi9aOUI4UjhMNnNOc2VkWXRoSWd6MWFO?=
 =?utf-8?B?VUpFT2kwVmdkOWRsZmkyS1IwbUlLU0x0Rkc3RmFNNGpuUFVrWDlaNXdQYnMr?=
 =?utf-8?B?SG5VdEtBbzRlOWsrMERjVThPUFMwelNONldpZ0o3VW1kY1IwbTBhOGp0OXZr?=
 =?utf-8?B?TXo4WWgxbmpXczY4VmhqNDF0cVdraHdMeGJ1a1F3aDdvVEFrQ2h0YUZXVnJh?=
 =?utf-8?B?cDRqcDRqazRRL1FFUjE5SDZ5NStsRG1kNkNHR2xnQTlXaWpTRTMreTNic1Rp?=
 =?utf-8?B?V2Z2SGVldGxxOXdOcHV6R1hpNURYVFNDUm5MTjlXZWVrZzNlMHRwdmpHK1JY?=
 =?utf-8?B?cGdNNGpZVEllckpFdmJaOUdVaEo5UkhaOWRYQ3pXZk53dUlHamxZQ25rMzdn?=
 =?utf-8?B?YlpEZlBBRUhWamk4b2lHVmFMY3lObW82ME9uWDBFUHF4UzNlV1RPdW9nWm9V?=
 =?utf-8?B?VWNZZGpMQ1l5S2Z4amZIUEQ0bmo5bU9zeFM5bkVURG9PVG1qRW5vV2NTZnhT?=
 =?utf-8?B?Z0VkRVBZbGkyRGRybkN5WHI0QTE2WHZyRXcrbkJLQkx5elpmNzh4UDF3Rzcv?=
 =?utf-8?Q?dJLU7YZhopU41?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?QTVSODJDcmlRMFU1RHNrZGQ1YUJtTExzT3gxZTJrbmtFSzJXMXhsVXI2SlhP?=
 =?utf-8?B?SU41YVBYQWFlalJueFlEMEtOM0tHYmo5RStLc2s1aFl6VUErYkpPMUQ4SUJw?=
 =?utf-8?B?K3dyRU1hSXBZYkpJcXlLbFZsNVJCUGVyanIxa0RtNVFkWGhjN2RrOVVLYzVD?=
 =?utf-8?B?SWVOWjlJTkczay91cUhGVzNlMHMvR0Zab1pWakIwRjdmVlBRbFQxZWFHMDRQ?=
 =?utf-8?B?UVF2bmoraklUVnppZStqbk1RaW16Nm8yMm5CZDh2NysranBRRWU2dHpFNDdS?=
 =?utf-8?B?dzREUks2MmE2RnR6VmxGa1hiazVULytCT0RtVEZWbzkybUlPaWxkQThGTFYz?=
 =?utf-8?B?VVQrQk9XZFpqKzZoTVo1SUVTam53V1h3TzVCd1RQdUkrcmErZ0UyL0dtZ3R5?=
 =?utf-8?B?NTRTUjQrYXpBZlMzNlNHZmlwVUhpUlFFUXRnUGlRNDUvc2pUa0huVk1ySzFM?=
 =?utf-8?B?MTBJM0RvRVBmaVV5aVNMRE01Skh0dXV4UmF6K1VIOUNpRDNhakZhc2Rab3RJ?=
 =?utf-8?B?NzR4OEo0Y3dGQWNtM0JFL2UyREpCeDFPS0x1Z3hvV1pZSjBvY2xiam5Zc3JC?=
 =?utf-8?B?NkFpNEFTKzN3eWFYQnVIZzU1aExuYU96aTZ3N2krSGd5MTFGV0RpdEZwZ3hU?=
 =?utf-8?B?Q1JFdDFoYWtOdllreFlYdFprdnZHYWFEeDZIcnNNQkFHTXllamhCTVpEME55?=
 =?utf-8?B?M2hJaVQyZHd2NkRvV3lCYTQxaE9FRmlRb3lnVmRTcGxDcmpPZUV3SWl5Nlkz?=
 =?utf-8?B?VlVieEMxQmR3Zi9Qd213MEhseDRheVRBaUZmdXE2QVAvbTRzRlF6cnZuL3Zo?=
 =?utf-8?B?WkJqQWZsd1o0LzFCSmpsOWJ2RVFNMFp2RGM4ajRacktZVW9RbVYwYmJYSmZx?=
 =?utf-8?B?b1dNa01tY1pLaHRkczc2cC9HcSsreUMyRkNFMVRJbnJpWHlNNEFFMnZ1UUJo?=
 =?utf-8?B?V0xCQ054WVBEc1g4djZHTGNrNy9OUm8wdkcyOXdvYS9HSHNaWmRtdG5nbzJ6?=
 =?utf-8?B?b3hweFN1NFh0RkZGbmFXaVljYVQ2cXRsZURCdWlwUG8wZk4zSlVLL3I2QWxh?=
 =?utf-8?B?L2k5RkJlTDlyenN5VTV2T2NXN1J6R3k5NUdQaHRheXlncHVFSENibEtuckhN?=
 =?utf-8?B?L25QNHpJTXk2cTFydDZxVDVXblFIbGFYZHZ0RnI4bjk3MDFQcXRHUVFicDZQ?=
 =?utf-8?B?MHY2SHlicFczeFVnQUw2cnRXMVpKWFRwUGVBZXFvMk54Nk9Wa0plUHd1dHVO?=
 =?utf-8?B?eEhxWkRBZFVNOVRkT3Vvb20xaFd5ajhkWmFRbnZzYW5iTnptMXhPdEdkUldR?=
 =?utf-8?B?YjhyMnZXSEhiNmpWV2JJYW03ZFlrSlVuVUVxMFlQRzZXNkJ4SUJwV3NPbVF6?=
 =?utf-8?B?Ukt1b3NYWGFUNjg5cWRYeEtvcVZJSThLallXYlF4dUxVSHNDdGt6bHRaY3Nq?=
 =?utf-8?B?QjBqM2hrZWtqWEVGSHlGVnYyUjJnSkdNZ21FMVczdEVVRGkxWjlCcTJ0UHVp?=
 =?utf-8?B?eXloTFJrWENsaUdvUlN0c0I2Z2p6bEFRSkYvd2hUTnhNTVgyaGVlNjV4WDE4?=
 =?utf-8?B?MTVJZ2RONDdEMDJUOVUvVkJMUHpSRzBKbVlua3QyTkRVNWtjcGY5SVZJRUZG?=
 =?utf-8?B?SndJV0NKa0FhWGdwWXZtYk1PcVdBSG9HTnNXWnFQNjByeGhPclZ0eDkzcXdj?=
 =?utf-8?B?MzZJNlVCZUYrQzhJb2cwelh0OUU4WU5nRkNBcmc2OHd6SGwvWVVIWk8zKzJw?=
 =?utf-8?B?cS9RaTM2aGdUQXNHZFh4T2ZnMWpZazJFRksvSDVIOElPbmpuelcyaFBHRm1E?=
 =?utf-8?B?Nmp5TUo0ZzJJY0RhYzRLNVFNMitUdzNaM2xZOFllNmFwbFRHQTBySjJnVkZQ?=
 =?utf-8?B?RVRCTzR5UXlacTRKZ3AzZnJvY0lEdGFvUms3dGp2ZTd4andXYlVUam9CWkh1?=
 =?utf-8?B?VzcyWVcxNjh3RGNoTGhFR1Ewa3pJY2Ftbk9IdjlUeG1BVTZOK0RFRS8vTjIr?=
 =?utf-8?B?eUI1YmxTVVVycE93Tm5BSXlKa3FRSEYrZE91ZVBmdEJHZmNhZUpsMUNqMnBm?=
 =?utf-8?B?UXlodDV4MnoyUGhlQW0zczh6SUNkL3NJMXlpbkFzZWtiWGdoVVZacWU1cGd4?=
 =?utf-8?B?Q1VKU0xwUFNWdlA1dzNRbGFCQ2pnNjdXZ1QzWGZaYnF2T1FSbTNFWnhhMmFy?=
 =?utf-8?B?TVE9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	3EG+pp13b/xYs+CMBrbc2Fa5MDK+Ib97O9rjEvLAw6wLVnJip+8BKQFgew53a2ETG2IYXrddKh4WLrFAj9aCFP1yjOeNzMEp5rcb+dt8cA1gAyrROg/GjEzz6y0xJLgPM3tyF6FZFDuhXb770oxVdLqsg3OoqbBCF1Ue1SXmLYtATV0OVV1ghxZPLu49k3HjP3pxOfDmlWeOVcxJVxrziPAHq372m3HeF8wfBZTP6xs6J0o0ESJcVysVBfhU0UC2TsUp6FAOt3BDUzyqbCegGGHVKSu0AHYTJ6/DAdT2LcvInM1uwprcbPirwyqEyHnw+7yN0Cq0Y/eF/VCjgOcHfGDbY5KJBeBO9cWoJaF6ZVqpc0a/BogMVtW3rpTM8ER/HS7tXb6cAah6SHxBSjby0NIYlzRJJXqIquvZLKDZgTMolEx4p3N6BvxbRorEE2tAQKgTm1j1spqaAbViLAFiOnvxN+8eY8PC1KZFNdtUOd6zAl9mOMZEF0zg7jrsHaMgJkV83fw/7Zxfw9gs6KhpJwckWHEEVUj32iw9GkeS83vd6jcgM8AH9KXFwVsCmMiwzCg1JrD9Nt5CwoXxTWbvlQBUgbayUnaGwf/cafVHo7Y=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 68d1b25a-6864-4ca4-31ab-08ddcae55237
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jul 2025 19:07:23.3856
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CAr0YQadhpjj7YJVNvpDWofZZxyFncDxx5GCzOAhGYZ+mKXkM9bmSC6XHQzT02HW2HBvVbNZhu+rqJnEx5Wn2uMCaGITtq0wFRXcEpPuZjQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB5162
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-07-24_04,2025-07-24_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 adultscore=0 bulkscore=0
 suspectscore=0 mlxscore=0 phishscore=0 mlxlogscore=999 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2505160000
 definitions=main-2507240148
X-Proofpoint-GUID: lK4sVNCD6if3mWJgAabABYb53QrpyPk0
X-Proofpoint-ORIG-GUID: lK4sVNCD6if3mWJgAabABYb53QrpyPk0
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNzI0MDE0OCBTYWx0ZWRfX5eGnbz6v0B57
 tX++oZ1KzG2tJx6VUTz3H+juTuo/m5kBi2IWK8b03SS93rySbbVV/CbqOiuQVzhhNdUJ0gy8Ekc
 h7mZ6NWXVN4a+xV9MtAphYpN3IDtqIOYpXWMkxik6mDMz1DW/Itr7OkDeY453vUlcx/HfX0ZIrC
 Y+J1Cggl0lbCF84EZ0sz1HOV5GvxPq2Y2XOjr//5lWWGaLOqV+Vo/29RSw/vOIuLiKZKW4OfcIo
 cLb271aiF3qAUODxQzEObLrbTMF/okRJ1loEafz1t/35hOfW8a0WTvcgN7KpdGow2mQgaBWHVGz
 DkmJb9dO2nuCjJK9Jz+HvHNvLmbEHh+cpJ6NU3hOhXyjmXRIHalTy5JC6XpC0+nrt0LQziV992F
 XiJFADGpwSMHSuGnCbCle2yQiMv3DOFiIZNqs2tHFe6LIT8gXWGcEZzWneSJH0Q3suIcP/Fu
X-Authority-Analysis: v=2.4 cv=IPoCChvG c=1 sm=1 tr=0 ts=68828470 b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19
 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19
 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10 a=Wb1JkmetP80A:10 a=GoEa3M9JfhUA:10
 a=VwQbUJbxAAAA:8 a=pGLkceISAAAA:8 a=cm27Pg_UAAAA:8 a=P-IC7800AAAA:8
 a=yPCof4ZbAAAA:8 a=20KFwNOVAAAA:8 a=OVfS8GUj7Yq4ZkoHXwkA:9 a=3ZKOabzyN94A:10
 a=QEXdDO2ut3YA:10 a=d3PnA9EDa4IxuAV0gXij:22 cc=ntf awl=host:12061
X-Rspamd-Queue-Id: 7E7D320016
X-Stat-Signature: jdshf4yt1gn5sdr4i3nzr9tbmox4f6p8
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1753384054-663233
X-HE-Meta: U2FsdGVkX1/9Cq7dXMkdVQM1cOw4BSDM1+jjqWjrPYRBd6XqUILNHSCo5yBcxfLz7F3A/bMoAbNzaaFIgI1kwSCHe0uyjghSLI75FSCX5nMCB9fe++K/nShbNIOOjXN8WmnbiQaoSc+6LxOASepD4f1Aa3qXmecJVxZtq13mA8JPAk4B2H6nmXJ9SntF/0Cb9+jEt0H/G8VL0njffP7AFUWi5ZbGKBYOvkmV6jKuxbUHW25dke4bMZvw6odPkIQWclzrB2pnVCqI7grHuSZChqLvpQp9bcPlBnPqFVoc52c6xlTbGFxDXQRJcmjL1VyRUlFosOnju6MyaXzHfvO1ZYL6wDbzOhsGG54+lQa0MRxBHliJIGtC9oFluPJGMg3ZMl73j/KgtWbp9siQlHLqxEAGyX8YkghbsQnSsU2F9d8eA5DNTYOIuI84EZ3/I9vi+CuNOIkxGhHg8FRL94WWVV8V7D5GyJ0z3HWVzuP+HP3bxLyJDF4k6p9s3y3gJUstqSBg71prtAbjh7W0XXt7iyGZiyX9HCK/tS46mabWOu4R3x2TgrpXb0gyUYtqpZl3UlC6OfrmoiR0Xcn5A2ytrgrDboKNb3f658txnJC5FnUX2PIPyPEyxjt0iMO4iPIdbgA8oXmvPBI0w43O70BXYemAqRkhyBjzzg+ca2G3zkM4CZw3S7J1ex5Eb0GY7reCwxLbFhxJdOq1lRvr5s6iNxTuhxqasLk5OhLlH/ENPslOiZw7JQVmpInts+ygcwCocKWKow0vDaMAlx1sA7mSot1SFiqtFTh5w7VfuAnlVntqGGmmi0bL7y71uVWdcthnwKxOT+MqdI/vEqbX9Tc24IqZHlqCaaEUkNlM3/0Ny2r9menG9482W/7ZKoKzaT3aYJWjFsUoYIArd73Thn4Z2pk9Zi+L8fj+N+P7U5qfJ7I0N6zgBvodYgMqY2mjWh3PXs0TM6IlJuL7XUsh7jW
 jETFO3O3
 XrS1/6TTJj44Amc0cYpAEUpvoXxuEaV05R6H2WYxpRRkIDbdvRm+VY7bv3huLzUhIsM/4Yhmn2Z8PJN/SChPIbn0wBb+34LVwj91IgeaXLJsUpQf0aKg6ZM0C1lgV4L1IwBaFh7bZdsPdEVlaz5JIYFD5H87x5D43o0qv4rKHAMvrrd1HyMWW5DWLtbqIsj7dCTIbXQYcK30s3ydlGe5gqwyfBXLnfRKhtPWfDfwAc3rcWIMnNgII8KtesjyjkHpGhpvC+LV8ljFTVFzjR6yWlkbrEsaQuqJPno+RIlReOJi1xYGieiPuFUx9LzmHdnjREzjyEd4DIsmnPCQr83n9aX1m33uzu43PXo/13FPdbiUDSsnc2t5mf4AKWettDCtfGkACr/Hd5Ad/ERhVhkuRjQi0V0Z65eS1/3i6EQYQlUiwudk/pgrxWK/v6PgsEcKESdm0Sjrsmbpod+gwgTK8hqgc5Z2n34JKZxbL1JUCrj256+hmzpEYAzQWA8f/eL7zcE3Ommankgr472pSwt7vZDErabvrWiBY1fZAWXMM7SLsJMRKo86YChtIRXPfvd6upsru47IHEHXdvWHo7E7BgxjqIF9wlQP6oywkDEfkotmqmr9PDYYI6BMq+TDqV/ebCxN3ImlfQeUeFNPCuhipPkQ3GQI+kHXJczX33tdDEUKSLVGfrxWL3BoVhcDhaIn53QPj5SGYfNlniB+4oxF0q06dFopwTWPKdiaVpoh2xnnJadSK3r4fNzMtEX+dZXOO8Zv28VOsI1/x0l3PkbbE5rC4rP9tt2fBHgbG3MXC7YfSGmoYx+9Js74oq/Y+PbUz4jzN9BQy00T7m2yNjy+DqrQPqgMzU5LATpoxfk/ICTaiASDRSpaPZEhwSq+sf41Gj1nU
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jul 24, 2025 at 11:39:05AM -0700, Jeff Xu wrote:
> Hi Lorenzo,
>
> This change has two parts: a non-functional refactoring work of moving
> function from mseal.c to madvise.c, and a functional change to the
> behavior of madvise under mseal. Would you consider splitting the
> change into two parts? which seems to be a common practice at
> supplying patches in lkml.

No I won't do that.

it's a very small change, and it was intentionally bundled so we correct
the oddly implemented version while moving.

>
> On Wed, Jul 16, 2025 at 10:38 AM Lorenzo Stoakes
> <lorenzo.stoakes@oracle.com> wrote:
> >
> > The madvise() logic is inexplicably performed in mm/mseal.c - this ought
> > to be located in mm/madvise.c.
> >
> This is part one of a non-functional refactoring work to move a
> function from mseal.c to madvise.c.
>
> There are two main reasons why I initially wanted to keep all
> mseal-related functions in mseal.c:
>
> 1 Keeping all mseal related logic in mseal.c makes it easier for
> developers to find all the impacted areas of mseal.

That's very silly, sorry but no.

You're putting stuff entirely specific to madvise() away from madvise(),
to bundle things up for no really good reason.

Again, you have a desire to do things that are at odds with how everything
else in mm is done.

> 2 mseal is not supported in 32 bits, and mseal.c is excluded from 32
> bits build (see makefile).This would prevent accidentally using mseal
> in code paths shared between 32-bit and 64-bit architectures. It also
> avoids adding #Ifdef in the .c file, which is recommended by the mm
> coding standard (I received comments about avoiding  #ifdef in .c  in
> the past).

You're doing something strictly worse by putting madvise() stuff to bitrot
in another file.

It's always a trade-off.

There's no set 'coding standard', there's what maintainers accept.

>
> Point 2 can go aways if 32 bits mseal support is coming soon, same as
> my other comments for patch 1/5.

But that's not the reason, as commit message states.

>
> Point 1 remains. However, I want to focus on the functional change
> part of this patch, rather than the other aspects.

No point 1 is dimsissed as is point 2.

>
> > Additionally can_modify_vma_madv() is inconsistently named and, in
> > combination with is_ro_anon(), is very confusing logic.
> >
> > Put a static function in mm/madvise.c instead - can_madvise_modify() -
> > that spells out exactly what's happening.  Also explicitly check for an
> > anon VMA.
> >
> > Also add commentary to explain what's going on.
> >
> > Essentially - we disallow discarding of data in mseal()'d mappings in
> > instances where the user couldn't otherwise write to that data.
> >
> > Shared mappings are always backed, so no discard will actually truly
> > discard the data.  Read-only anonymous and MAP_PRIVATE file-backed
> > mappings are the ones we are interested in.
> >
> > We make a change to the logic here to correct a mistake - we must disallow
> > discard of read-only MAP_PRIVATE file-backed mappings, which previously we
> > were not.
> >
> > The justification for this change is to account for the case where:
> >
> > 1. A MAP_PRIVATE R/W file-backed mapping is established.
> > 2. The mapping is written to, which backs it with anonymous memory.
> > 3. The mapping is mprotect()'d read-only.
> > 4. The mapping is mseal()'d.
> >
> > If we were to now allow discard of this data, it would mean mseal() would
> > not prevent the unrecoverable discarding of data and it was thus violate
> > the semantics of sealed VMAs.
> >
> This is the functional change and the most important area that I would
> like to discuss in this patch series.

OK.

>
> Since Jann Horn first highlighted [1] the problematic behavior of
> destructive madvise for anonymous mapping during initial discussions
> of mseal(), the proper solution has been open to discussion and
> exploration. Linus Torvalds has expressed interest [2] in fixing this
> within madvise itself, without requiring mseal, and I copied it here
> for ease of reference:
>
> “Hmm. I actually would be happier if we just made that change in
> general. Maybe even without sealing, but I agree that it *definitely*
> makes sense in general as a sealing thing.”
>
> After mseal was merged, Pedro Falcato raised a valid concern regarding
> file-backed private mappings. The issue is that these mappings can be
> written to, and subsequently changed to read-only, which is precisely
> the problem this patch aims to fix. I attempted to address this in
> [3]. However, that patch was rejected due to the introduction of a new
> vm_flags, which was a valid rejection as it wasn't the ideal solution.
> Nevertheless, it sparked an interesting discussion, with me raising a
> point that userspace might use this feature to free up RAM for
> file-backed private mapping that is never written to,  and input about
> this topic from Vlastimil Babka [4] is about MADV_COLD/MADV_PAGEOUT.

OK not sure what point you're making yet?

>
> A detail about userspace calling those madvise for file-backed private
> mapping. Previously, I added extra logging in the kernel, and observed
> many instances of those calls  during Android phone startup, although
> I haven’t delved into the reason behind why user space calls those,
> e.g. if it is from an individual app or Android platform.

Hang on, sorry, are you saying that you intentionally allowed destruction
of mseal()'d VMAs to serve android?

I hope I'm misunderstanding you here.

Either way I don't know what your point is? Don't mseal them if you want to
perform destructive operations on them?

You have to argue as to why this change is not valid in _upstream_ linux.

>
> Incidentally, recently while I was studying selinux code, particularly
> exemod permission [5] , I learned that selinux utilizes vma->anon_vma
> to identify file-backed mappings that have been written to.  Jann
> pointed out to me that the kernel creates a COW mapping when a private
> file-backed mapping is written. Now I'm wondering if this could be the
> answer to our problem. We could try having destructive madvise check
> vma->anon_vma and reject the call if it's true. I haven't had a chance
> to test this theory yet, though.

Umm what? Why? What are you talking about?

A MAP_PRIVATE mapping will not have VM_SHARED set. This is why I changed
the check to this.

I really don't understand what point you're trying to make here.

The check I've provided works correctly to disallow the previously
_incorrectly allowed_ MAP_PRIVATE mapping of a file-backed mapping.

This was something you missed, and is now corrected.

>
> To summarize all the discussion points so far:
> 1. It's questionable behavior for madvise to allow destructive
> behavior for read-only anonymous mappings, regardless of mseal state.

Umm, ok. Well maybe, but it's essentially uAPI at this point. This feels
irrelevant to this series.

> 2. We could potentially fix point 1 within madvise itself, without
> involving mseal, as Linus desires.

No, we will not do that.

> 3. Android userspace uses destructive madvise to free up RAM, but I
> need to take a closer look at the patterns and usage to understand why
> they do that.

OK so what?

> 4. We could ask applications to switch to non-destructive madvise,
> like MADV_COLD or MADV_PAGEOUT. Or, another option is that we could
> switch the kernel to use non-destructive madvise implicitly for
> destructive madvise in suitable situations.

Umm what? I don't understand your point.

> 5. We could investigate more based on vma->anon_vma

I have no idea what you mean by this. I am an rmap maintainer and have
worked extensively with anon_vma, what's the point exactly?

>
> Link: https://lore.kernel.org/lkml/CAG48ez3ShUYey+ZAFsU2i1RpQn0a5eOs2hzQ426FkcgnfUGLvA@mail.gmail.com/
> [1]
> Link: https://lore.kernel.org/lkml/CAHk-=wiVhHmnXviy1xqStLRozC4ziSugTk=1JOc8ORWd2_0h7g@mail.gmail.com/
> [2]
> Link: https://lore.kernel.org/all/20241017005105.3047458-2-jeffxu@chromium.org/
> [3]
> Link: https://lore.kernel.org/all/8f68ad82-2f60-49f8-b150-0cf183c9cc71@suse.cz/
> [4]
> Link: https://elixir.bootlin.com/linux/v6.15.7/source/security/selinux/hooks.c#L3878
> [5]
>
> > Finally, update the mseal tests, which were asserting previously that a
> > read-only MAP_PRIVATE file-backed mapping could be discarded.
> >
> The test you are updating is not intended for the scenario this patch
> is aimed to fix: i.e. the scenario:
> 1. A MAP_PRIVATE R/W file-backed mapping is established.
> 2. The mapping is written to, which backs it with anonymous memory.
> 3. The mapping is mprotect()'d read-only.
> 4. The mapping is mseal()'d.
>
> The test case doesn't include steps 1, 2, and 3, is it possible to
> keep the existing one and create a new test case? But I don't think
> that's the main discussion point. We can revisit test cases once we've
> fully discussed the design.

I do not know why you put this here. Can you please put review along side
the code you're reviewing.

You're making my life unnecessarily hard here.

But yes, you're right, I messed up the test here, I'll send a fix-patch.

Incidentally, it seems like the test _explicitly_ asserted that this
behaviour was the opposite of what it should be which makes me think again
this might be intentional... Concerning.

>
> Thanks and regards,
> -Jeff
> > Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> > Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>
> > Reviewed-by: Pedro Falcato <pfalcato@suse.de>
> > Acked-by: David Hildenbrand <david@redhat.com>
> > ---
> >  mm/madvise.c                            | 63 ++++++++++++++++++++++++-
> >  mm/mseal.c                              | 49 -------------------
> >  mm/vma.h                                |  7 ---
> >  tools/testing/selftests/mm/mseal_test.c |  3 +-
> >  4 files changed, 63 insertions(+), 59 deletions(-)
> >
> > diff --git a/mm/madvise.c b/mm/madvise.c
> > index 2bf80989d5b6..dc3d8497b0f4 100644
> > --- a/mm/madvise.c
> > +++ b/mm/madvise.c
> > @@ -19,6 +19,7 @@
> >  #include <linux/sched.h>
> >  #include <linux/sched/mm.h>
> >  #include <linux/mm_inline.h>
> > +#include <linux/mmu_context.h>
> >  #include <linux/string.h>
> >  #include <linux/uio.h>
> >  #include <linux/ksm.h>
> > @@ -1255,6 +1256,66 @@ static long madvise_guard_remove(struct madvise_behavior *madv_behavior)
> >                                &guard_remove_walk_ops, NULL);
> >  }
> >
> > +#ifdef CONFIG_64BIT
> > +/* Does the madvise operation result in discarding of mapped data? */
> > +static bool is_discard(int behavior)
> > +{
> > +       switch (behavior) {
> > +       case MADV_FREE:
> > +       case MADV_DONTNEED:
> > +       case MADV_DONTNEED_LOCKED:
> > +       case MADV_REMOVE:
> > +       case MADV_DONTFORK:
> > +       case MADV_WIPEONFORK:
> > +       case MADV_GUARD_INSTALL:
> > +               return true;
> > +       }
> > +
> > +       return false;
> > +}
> > +
> > +/*
> > + * We are restricted from madvise()'ing mseal()'d VMAs only in very particular
> > + * circumstances - discarding of data from read-only anonymous SEALED mappings.
> > + *
> > + * This is because users cannot trivally discard data from these VMAs, and may
> > + * only do so via an appropriate madvise() call.
> > + */
> > +static bool can_madvise_modify(struct madvise_behavior *madv_behavior)
> > +{
> > +       struct vm_area_struct *vma = madv_behavior->vma;
> > +
> > +       /* If the VMA isn't sealed we're good. */
> > +       if (can_modify_vma(vma))
> > +               return true;
> > +
> > +       /* For a sealed VMA, we only care about discard operations. */
> > +       if (!is_discard(madv_behavior->behavior))
> > +               return true;
> > +
> > +       /*
> > +        * But shared mappings are fine, as dirty pages will be written to a
> > +        * backing store regardless of discard.
> > +        */
> > +       if (vma->vm_flags & VM_SHARED)
> > +               return true;
> > +
> > +       /* If the user could write to the mapping anyway, then this is fine. */
> > +       if ((vma->vm_flags & VM_WRITE) &&
> > +           arch_vma_access_permitted(vma, /* write= */ true,
> > +                       /* execute= */ false, /* foreign= */ false))
> > +               return true;
> > +
> > +       /* Otherwise, we are not permitted to perform this operation. */
> > +       return false;
> > +}
> > +#else
> > +static bool can_madvise_modify(struct madvise_behavior *madv_behavior)
> > +{
> > +       return true;
> > +}
> > +#endif
> > +
> >  /*
> >   * Apply an madvise behavior to a region of a vma.  madvise_update_vma
> >   * will handle splitting a vm area into separate areas, each area with its own
> > @@ -1268,7 +1329,7 @@ static int madvise_vma_behavior(struct madvise_behavior *madv_behavior)
> >         struct madvise_behavior_range *range = &madv_behavior->range;
> >         int error;
> >
> > -       if (unlikely(!can_modify_vma_madv(madv_behavior->vma, behavior)))
> > +       if (unlikely(!can_madvise_modify(madv_behavior)))
> >                 return -EPERM;
> >
> >         switch (behavior) {
> > diff --git a/mm/mseal.c b/mm/mseal.c
> > index c27197ac04e8..1308e88ab184 100644
> > --- a/mm/mseal.c
> > +++ b/mm/mseal.c
> > @@ -11,7 +11,6 @@
> >  #include <linux/mman.h>
> >  #include <linux/mm.h>
> >  #include <linux/mm_inline.h>
> > -#include <linux/mmu_context.h>
> >  #include <linux/syscalls.h>
> >  #include <linux/sched.h>
> >  #include "internal.h"
> > @@ -21,54 +20,6 @@ static inline void set_vma_sealed(struct vm_area_struct *vma)
> >         vm_flags_set(vma, VM_SEALED);
> >  }
> >
> > -static bool is_madv_discard(int behavior)
> > -{
> > -       switch (behavior) {
> > -       case MADV_FREE:
> > -       case MADV_DONTNEED:
> > -       case MADV_DONTNEED_LOCKED:
> > -       case MADV_REMOVE:
> > -       case MADV_DONTFORK:
> > -       case MADV_WIPEONFORK:
> > -       case MADV_GUARD_INSTALL:
> > -               return true;
> > -       }
> > -
> > -       return false;
> > -}
> > -
> > -static bool is_ro_anon(struct vm_area_struct *vma)
> > -{
> > -       /* check anonymous mapping. */
> > -       if (vma->vm_file || vma->vm_flags & VM_SHARED)
> > -               return false;
> > -
> > -       /*
> > -        * check for non-writable:
> > -        * PROT=RO or PKRU is not writeable.
> > -        */
> > -       if (!(vma->vm_flags & VM_WRITE) ||
> > -               !arch_vma_access_permitted(vma, true, false, false))
> > -               return true;
> > -
> > -       return false;
> > -}
> > -
> > -/*
> > - * Check if a vma is allowed to be modified by madvise.
> > - */
> > -bool can_modify_vma_madv(struct vm_area_struct *vma, int behavior)
> > -{
> > -       if (!is_madv_discard(behavior))
> > -               return true;
> > -
> > -       if (unlikely(!can_modify_vma(vma) && is_ro_anon(vma)))
> > -               return false;
> > -
> > -       /* Allow by default. */
> > -       return true;
> > -}
> > -
> >  static int mseal_fixup(struct vma_iterator *vmi, struct vm_area_struct *vma,
> >                 struct vm_area_struct **prev, unsigned long start,
> >                 unsigned long end, vm_flags_t newflags)
> > diff --git a/mm/vma.h b/mm/vma.h
> > index acdcc515c459..85db5e880fcc 100644
> > --- a/mm/vma.h
> > +++ b/mm/vma.h
> > @@ -577,8 +577,6 @@ static inline bool can_modify_vma(struct vm_area_struct *vma)
> >         return true;
> >  }
> >
> > -bool can_modify_vma_madv(struct vm_area_struct *vma, int behavior);
> > -
> >  #else
> >
> >  static inline bool can_modify_vma(struct vm_area_struct *vma)
> > @@ -586,11 +584,6 @@ static inline bool can_modify_vma(struct vm_area_struct *vma)
> >         return true;
> >  }
> >
> > -static inline bool can_modify_vma_madv(struct vm_area_struct *vma, int behavior)
> > -{
> > -       return true;
> > -}
> > -
> >  #endif
> >
> >  #if defined(CONFIG_STACK_GROWSUP)
> > diff --git a/tools/testing/selftests/mm/mseal_test.c b/tools/testing/selftests/mm/mseal_test.c
> > index 005f29c86484..34c042da4de2 100644
> > --- a/tools/testing/selftests/mm/mseal_test.c
> > +++ b/tools/testing/selftests/mm/mseal_test.c
> > @@ -1712,7 +1712,6 @@ static void test_seal_discard_ro_anon_on_filebacked(bool seal)
> >         unsigned long size = 4 * page_size;
> >         int ret;
> >         int fd;
> > -       unsigned long mapflags = MAP_PRIVATE;
> >
> >         fd = memfd_create("test", 0);
> >         FAIL_TEST_IF_FALSE(fd > 0);
> > @@ -1720,7 +1719,7 @@ static void test_seal_discard_ro_anon_on_filebacked(bool seal)
> >         ret = fallocate(fd, 0, 0, size);
> >         FAIL_TEST_IF_FALSE(!ret);
> >
> > -       ptr = mmap(NULL, size, PROT_READ, mapflags, fd, 0);
> > +       ptr = mmap(NULL, size, PROT_READ, MAP_SHARED, fd, 0);
> >         FAIL_TEST_IF_FALSE(ptr != MAP_FAILED);
> >
> >         if (seal) {
> > --
> > 2.50.1
> >

