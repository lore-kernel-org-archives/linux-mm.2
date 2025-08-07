Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C15A7C87FD3
	for <linux-mm@archiver.kernel.org>; Thu,  7 Aug 2025 01:22:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1BCFA6B0092; Wed,  6 Aug 2025 21:22:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 16E2C6B0093; Wed,  6 Aug 2025 21:22:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 00EFA6B0095; Wed,  6 Aug 2025 21:22:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id E4CA96B0092
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 21:22:32 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 67D965B98A
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 01:22:32 +0000 (UTC)
X-FDA: 83748211344.22.322D652
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf14.hostedemail.com (Postfix) with ESMTP id AD912100005
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 01:22:28 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=X1cuyHEr;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=s3sryLUW;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf14.hostedemail.com: domain of jane.chu@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=jane.chu@oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1754529749; a=rsa-sha256;
	cv=pass;
	b=1SrlG3GVhlZvuZhN2YLK7Uc7wRy58gi9lMHDeIJI122WbyBrDQaUYUJ70I2XQeT8lwPEvt
	6ga9kPeOhPYje4W8EH/DSFst0fJ1G91cbcTFH0A5DbwlaEBHIxOr4lqk1n/SvhsMMD6xOF
	fEW22TfTV2l5UT0hzhn88mOgZTFL52w=
ARC-Authentication-Results: i=2;
	imf14.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=X1cuyHEr;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=s3sryLUW;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf14.hostedemail.com: domain of jane.chu@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=jane.chu@oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754529749;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Wca12PK8Elogi6QnsJq+FTu8wYL6t90jGfKG+G5jg04=;
	b=dxk4Bv0B4bal8Z80GgAww5HCo7OAa4mUd/14mgfUtPTM1X4n6LOm6PKlutGBgAPeeJbvxC
	xWvHFUx7eU6hW4dK/EEISH4oHWYvneMS2RShE2ZzvX4lBlrkPDj67dtippGqLvlopQ/72v
	251py+88pVd/BjZ0Vp81VPwh5veVuHU=
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 576KRNe0014232;
	Thu, 7 Aug 2025 01:22:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=Wca12PK8Elogi6QnsJq+FTu8wYL6t90jGfKG+G5jg04=; b=
	X1cuyHErN0JUtN8VdxMTk0/31G9GI8k7uUfpym9yHkvO9eQzE2Vy2Zs1yPXuFzcb
	byRAkBMktMEFODBnY62ShQhiYI6JmmDuTzprf3dxkXVV53G8ef1s0UXW/rpr5oxj
	hSMwQ/MVM2AUzhFjreuFa9QD5EP1GhoMXhIBMu8xwT6KZlMK85M+6IfC+HDDYBHq
	/sNXd1TX7P7tdRmKjB5thu2wVwuZMEw5sWqv/GvUkk6KFMDuEWOkznI08uSKMLww
	XJBPCPmZW5TPklZwOb1AultGTbLALQxjcFMyS3H2033VuopqLeT6vMUIkYeEVGQJ
	E79jvUH9w4pDbtZSyCEBGQ==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48bpve3017-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 07 Aug 2025 01:22:18 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 576Nvu97028548;
	Thu, 7 Aug 2025 01:22:17 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11on2061.outbound.protection.outlook.com [40.107.220.61])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 48bpwn0329-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 07 Aug 2025 01:22:17 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=f2AesjUvrVI0p6jZFZFbl1+AsUVtl7Elx691Pe5cRQqnCsFdugYHJWD/E6ilfZng/ovpkALsEru5Zh9Y3MEAr4jpauJPvt0NWg1HlkWeCukkhojE3rGpCis1X+RCUZUKxm/Du6W5DWj26yJyj+Qbxm7xvZ2D84FNz2CD3c+vg0mk72fTqCtWNhGPQJp3ECPiRmk15Q6GoIUUcL+oHuQAfcnygHuEg1wNZ3w6N2pFJIAUCsQMejsNh8Q+Ou7JHCZIX/iv3qfyQfbOqOLPDhXeFk8kJbwpiWtiS/2aRiT4n9dttHooh1I60jZGgOJGw96UYEwTe16njdI8hr5HnUzcEw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Wca12PK8Elogi6QnsJq+FTu8wYL6t90jGfKG+G5jg04=;
 b=jrWkPKgwoEQaSwGOr0BF66EVJ6rKy+gD6plqoscUChfltk7QEWmxBSZ7zeiwqRHkb4K0GgZixOw6XdG9hmFWxyPfklroumKqrpNPWodZ28vQceRh3T+qsR5izmtXxqO7BY9uhQ2L+YsZR0P2/uCzRTYOUhTe6ZIHSlrRmvSRLm6RU3uorEEDz+GdIY4RBFlVyhph8MOuGDJn1+GT3yCZs6umPePOpTCMzfigXc2dZUU9Bw88Rpxd9+kozP42OuPUMdTASmBJ2Yukyt2ThIwBvlNR9muYoQ6pT+HhgrS0tEVQ7Bm8EflPCCXhZs9fj11gHRyRtBYQs6SzSQBe4Ttweg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Wca12PK8Elogi6QnsJq+FTu8wYL6t90jGfKG+G5jg04=;
 b=s3sryLUWMByjOMSjU+wXXcGVFoPiHd6PGNYPqZKt2+lVEW9mzZjQ1n/KNl3hTIIUt2I/BNIrYqeF+ECEPL3aaGDxJrX78bRR4uTC3d9omgjL06aJ9JJ9nE8LG8wv4qTfiAKPYY1nE9ePuljclyNDnful/RpvZx50loaqccIahJA=
Received: from DS0PR10MB7364.namprd10.prod.outlook.com (2603:10b6:8:fe::6) by
 MW4PR10MB6464.namprd10.prod.outlook.com (2603:10b6:303:222::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9009.13; Thu, 7 Aug 2025 01:22:14 +0000
Received: from DS0PR10MB7364.namprd10.prod.outlook.com
 ([fe80::b7d7:9d3f:5bcb:1358]) by DS0PR10MB7364.namprd10.prod.outlook.com
 ([fe80::b7d7:9d3f:5bcb:1358%6]) with mapi id 15.20.8989.015; Thu, 7 Aug 2025
 01:22:14 +0000
Message-ID: <0d416f66-6444-4f1d-8e94-9e0a1ed315c7@oracle.com>
Date: Wed, 6 Aug 2025 18:22:11 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 7/7] mm: hugetlb: allocate frozen pages in
 alloc_gigantic_folio()
To: Kefeng Wang <wangkefeng.wang@huawei.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Muchun Song <muchun.song@linux.dev>,
        Oscar Salvador <osalvador@suse.de>,
        David Hildenbrand <david@redhat.com>
Cc: linux-mm@kvack.org
References: <20250802073107.2787975-1-wangkefeng.wang@huawei.com>
 <20250802073107.2787975-8-wangkefeng.wang@huawei.com>
Content-Language: en-US
From: jane.chu@oracle.com
In-Reply-To: <20250802073107.2787975-8-wangkefeng.wang@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR05CA0050.namprd05.prod.outlook.com
 (2603:10b6:a03:74::27) To DS0PR10MB7364.namprd10.prod.outlook.com
 (2603:10b6:8:fe::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR10MB7364:EE_|MW4PR10MB6464:EE_
X-MS-Office365-Filtering-Correlation-Id: 3efd8895-dce8-4e6b-8509-08ddd550d763
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?WW5ZR3lpQlkrNk9FMGc4bnFxYmZySnFKckNOR09mbUs4MlhobUJDaThYdEx0?=
 =?utf-8?B?VDBZTjJVdk1RRjFQcGFLSVhMdEtqN0F5ODB4TzNTTzAwVU9vcVpSbFkrLzkr?=
 =?utf-8?B?ckxUeVhuRlZXclBCYjBDT3p2Yk00Z281b01xYlAwRkMwTmJNSUYxYlJCM0hw?=
 =?utf-8?B?UURBbWV3dXRmOC9ObElsMnQrYjZtdmtGYjB4RmswRUZaUVlYQ0hUR0ZjT3RV?=
 =?utf-8?B?V09Gd2pEWGJSU3I4empjMVhqVU04V3BjRldUck5FY1hwM0dtYVJJcDBXY2ZL?=
 =?utf-8?B?Z0RDL21uM2FWNUlhSm8xOWpIWkdVYlYrKzl1K0VORDhIL290RTh1SjZwaVZ1?=
 =?utf-8?B?N3RQWVZuTndJNk5BUXZoMFAvL01kSlR1aFd0b1JMV2tNN21maVJWaEZpZXN3?=
 =?utf-8?B?eWNZS3ZJN3pWTVh1RGtHRVVrbWhTdndhckRFeGFWbm9EcWU0YWlSNkVqY1Jj?=
 =?utf-8?B?VGFBcnRtQVdxR2VtUDl0YXhGMS9oa25EdUFXTWNUbCtPdTdmVy9zZ05Uc3FX?=
 =?utf-8?B?NzRmRkc1V3BnTUplZEdRMnFtbk9iOWtPQ2tBd2lWa3pObHZIWm15bkRpcWZi?=
 =?utf-8?B?YkJlRHNTUktCMkpuOTVxc3Q4dlRBTXF5Z042SlZ5ZGxQMnZ1M0I1OXhWSlBK?=
 =?utf-8?B?ck5HM0orcm1FUWE3aC92ZjF6eXUwbjZScXk0cWcrMjRlN05NbUN2K0hUbGlX?=
 =?utf-8?B?M08wbytLNCsyeGZiUk0valVtbkNLMDk5YkgxQ2p2Rk12SEtZVlM0N001YlJM?=
 =?utf-8?B?QXpDN2hJZjJDWGQxSmNsK3hWS2I5cHViczFKUDVmVlB4U01VVVptWlc3UGw1?=
 =?utf-8?B?a05HKzBpOUNUZFE2SjJmYm1Bekh4S3gySFl4UFVlSldGMnFPVXdwdkRIR3NT?=
 =?utf-8?B?THlOQkFUSDBlL1N2ZVh4V3JnTkVXajg0T0kySE45eDlyYlJKcUVQQTR6dTNs?=
 =?utf-8?B?SkZYc1pvOTZ2MlZzQncva2Y1QW5BQWc4aUVjaU1ad1RXSG1YNlA2RW5TdENB?=
 =?utf-8?B?ZDhMKzJKMXlyWWxDZnNuRXNXcUR6NnFuZU1tMnR6TFY2UTBXdGpxS2hjcG9N?=
 =?utf-8?B?NFVFV0Y2OExBVm1rVWwzWjNFOG02di9iOGNjVG00MTlBdkVwYllNUGpRd1pX?=
 =?utf-8?B?eXByTUd2QmJzQXpEelJPQlZ2djhIY3JTZWV2cHNWOEI5Q0U5SjRvRW9zVXg1?=
 =?utf-8?B?YnJ4Sjh1bmpxUlRMdVovck1LZmdNNlg0VkV6RmFaS0RQRXE4MytXQTkzenBi?=
 =?utf-8?B?RGVpVHNGcTlGcW9wMnpaNCtxc1p4YkZWSEt0M3QzN0lZQ0lHa1FYTm5xb1o2?=
 =?utf-8?B?OXJKMVk0TVdrV3pUd2pNZE9qbFhBM2xlYnJQUk43OTFaTVVZSktUdlk4NGpZ?=
 =?utf-8?B?TGozRGQ1ZFZuaVVuVkI4T2dRSEJxK0tJTkJGU21HZW8rNWF0T3FpOTA5Ni9l?=
 =?utf-8?B?b1crRGZoRmFCNnVSTlJ4UDJIS2dsUGttK3pWZ1JIYTZOcG9GenIwdjczK0Zl?=
 =?utf-8?B?amMxZjdBVGhFVklSclpJWlJNMjUwU2tldW1jTHF3Ukg1U1U2SG8wbDV3b2hn?=
 =?utf-8?B?RHBBaFJ4S0FMR1BTRnQwU0hFd2tZeFBmQU9hbUlBM1VqRzV2a1pYZ2JKYkdL?=
 =?utf-8?B?SmZ0NXo3dFgyYnEwekZSWittMDVDRms3UWtIZ0grUmFNL1VjQXhxRW80eGl2?=
 =?utf-8?B?clJZQm1ZRVBSdjV0Z1RUWFh5WU9SMG9uWktmcEdvY1o0UURsc20xU3dKQ3p2?=
 =?utf-8?B?WXIrMkF3T1Z3TlBxUnpGdEtqYjAvYlZ2U1hoeWlMTVhmZ1hoQmFBZjlZTEht?=
 =?utf-8?B?UUUzOC8waW5oK3BkWG9QemlBMjRDckJvVkNRMGtxWjdNaDF6ekZudnJTalA3?=
 =?utf-8?B?QURLTTcwbzNpVDFSWnYvVXRhVnFZOUczY3JOY0xrQVljeFpTV0N5Q1J2TTM1?=
 =?utf-8?Q?BLQ7Fj+jEGk=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR10MB7364.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?TlRUMUlKR0JqcGdLMC9ERXA4QTlPSTRyaTJjSVJZVTYrc2NHZ2JGYnVYTVBH?=
 =?utf-8?B?Y0hvN0xIcGUwbThuempWZEhvZGpXYlNiLzhzb3FIYWxmaE9GL0FUUTlLbHJl?=
 =?utf-8?B?ZkZZdXdKQTBYS3NhWFZuZE4rQW1IV0k5L0lmTjdFSDZ5aW4rZ05uZjJxRnpI?=
 =?utf-8?B?YkhHRTdwV2RtZ1krNUhrVGhPZC9KOEJtMVp3bEZEbEpJSXJyWGNCcjIya0U1?=
 =?utf-8?B?MDNxc3p5T0FLSGM1RkhVbE9Xd3NTcHNPZjltTmJYaWd2Tjk3QkpCNythNG1m?=
 =?utf-8?B?TVRqUWdvMjdzalNBN0FnYWFGV25ZU2txaXQycmR6QjdSOS85TTMzQ1lGNE1M?=
 =?utf-8?B?RlRUMk1TT1RDSjlWNUlnRk9LUC9PNldoM3l4ZFBpZTFrWmhJRUhWSlYzaXdY?=
 =?utf-8?B?d2YxNXRYTWczSmxHT1dsVDNIRkI4YlM1U2NBRG1sQ3pwTWlDZm81M1o3bXZx?=
 =?utf-8?B?U0ZmNVNGbjIzVlFVS2NyTUZSdlNVSVNLUzJxUysyMDVYb2g3SjdRTnFZVUZN?=
 =?utf-8?B?MHVvbGQ0SkR4WDQ4U1ludjByRUx3aHdFMHY5bkxkcG0vYjBhNWpYdWtJUFVZ?=
 =?utf-8?B?b0wvQ1pJY1hRSGlZNTc4ZEw2eUx3WThNK1FhSHhJN09MSDdaT3QzZGJCenNs?=
 =?utf-8?B?endPS2R5bzRLRFJmbnY4OXdrVEpkemI3ZTRMakZNMG1NTCtQaEFwMHhPZ3c5?=
 =?utf-8?B?dmdVaDJwQjR1SmVIbGJ6SHp6UThDRUJoV2M4eGFGTmhHZk5DKzNYNGZQZHdu?=
 =?utf-8?B?a3Bwb0lHVVhSQ1hEdjU2MDNJQTRoclM2SUlNcWpaZzREWkZLMnlGSlpvQ2JJ?=
 =?utf-8?B?UTVnalFYNkp6Q0JhY0hCUEF1cWZteU9veWtNUmhZelNBdkdPeGdhaVJYb0Yy?=
 =?utf-8?B?SnY4dkN3Z1pSTUJZajJtR09jR0E2YWVVL2h6UjdhT3pwSkJDVWgrQzk3elQr?=
 =?utf-8?B?OXVnQ2lFb0lKdkgvVGNxSHRnVHNIb2hHWWNQQ2w3K1FkNjFJbi85MjN6bnk1?=
 =?utf-8?B?cEF0TUFYckhKOVpsN2FrMFczT2dIYkdmL3VCdFAvTTFhaUd0QTlKdUgvRXhv?=
 =?utf-8?B?azhmYlJBS1JlTmFURUovbFg1YjNzNHdoNjcwWThkODdsVkg0b3BGT0JrVVhU?=
 =?utf-8?B?eUNnUWdqenA5dGlLRVdITU53bUdqOE8yMWhJcUJaZEg0Nk9neml3M0E3T2tZ?=
 =?utf-8?B?ZVVzZUlpcytjMVNtM3ZCdmlsKzlmTjZlb2xXMkdyUFRMT1FOOUJwQmdwbU12?=
 =?utf-8?B?UjJyNXYwQWt5QTBYNWVlTVZKVVAyUmoyWWhIS1FtUXhZMk92NDU3Yzl5SUtN?=
 =?utf-8?B?ZU9yYmd0WjhBOVJWOXhabFEzZkgvNi9NSEwxdWpFaUV0U0ZoV012SlRicThU?=
 =?utf-8?B?MDNHcXFyMjgrU2tXZ3QwVUZrcWN2ajFkeENhZGlJMnp0SC9MK3UvMFZ4dklL?=
 =?utf-8?B?ZngwMkZ1czkvMTFFcXlnN25OUDJ0ZmVsU045VjJzODF1N1RmdTBaWDY1eFZB?=
 =?utf-8?B?SGtkUXg5am1rZTkwRXFMMWtxWUtOd1gxejliSUh2eXVCYkp6RWJwZmhvYko2?=
 =?utf-8?B?dTN4QlhQdy9CYUw1SUlQWUp5bWZnVWl0NXowWXdic1dhZnVrRStlek9ZaWVq?=
 =?utf-8?B?b29UNC9jdFJxQXljZmJIU2ozSkF6RlpXOHpvU3pCNVFQQ2lwZ1NGMmlFb214?=
 =?utf-8?B?K2lBMFpGRmE0LzJVdjRVb1NFNzdSRE8wbm5xVjRxU3Y4RHpUTnZpTE1XbDRG?=
 =?utf-8?B?ODR5ekd0a2xZQTdDWWUyM3NDdVhha3RaMi9wUmVna1VYaEZqT1RacENzV0JZ?=
 =?utf-8?B?MkIxSm5raGlxRnp5NlExMHV3Ym9QL2ptbWdFZXZHeFhoNzRTUHB4VlM4OW51?=
 =?utf-8?B?VVVTVVFVbUxLVmk4RUhZRWRQOTRPS0RQdWVoeCtXQ3BpOWZ6dXRHMnNMekdz?=
 =?utf-8?B?aG5wcFM4NHN1ZlJsVyt3TnRXNHEyUXk2RVpFWDVONlRCcUJzNXY5WTY5MS9y?=
 =?utf-8?B?Z0tJdisxTGx4dloxTGdjMGlHWWtvdm5Oa0lVcmFHbXpVbk44REo4K2p6eTh5?=
 =?utf-8?B?M2hwQ1hVanZVc3dReG1HVVNuV1dZZGpKcmxId1JsVHBTTE1PWFUvY2hZWU5Z?=
 =?utf-8?Q?OA19w6BsplLjqNPBzjPgt6SDO?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	FtkSUDgcO621a7gnXelhS1UNwL+Ft3oDo3SGB58l8zGpvLuFH4LqUJr5GgLTid2nYqnwsX8Rc/SJdYliLo0+d+4lD91cS02E3Pykj1I1XlSmxb/YmD3X6pUeEKmHSRsqOQNgThnzkGy4ov5W9ajjGFbX7aer+QlY2vJwLQ+DLSV4Z8IfXrVI2FlFBR1NB7V/3Tf3LzeZRpMHHBOCSDlrWk/uJ+4uCu9/GYkvHTi/xSgJ1HlmdmlA7dCkkR6PKuv3jiDQ6slv9Dg2CJcSi9qbbyuo2F7ADMG/mUhVYpyqPZ6OcMhsPC+VqhFDp9dHtqoEDl1YJnYiz3F2wjH0/B17KjtkOGZ8n7zxcfekVQ0Rfhjb4Dm4dZotbwcDjbxCk+dkWjjxDmig1OrcZ4bj3U4owweAWWTfVXjpPdn8USApdIsXOQpEJoQI9KHcB7WK1K6sFJMhMZH90uFXEQBeBgRdqHvrJjXJk3iXlZOaO4oR0BsXqAohY57PCEqZyf+1JRWWLKYuvU6CKLf6RHt2W1YITpNYEZze6yVPdiXr+dLQRHFmEZY6LdgZjODfJXBx9OAWLhxSHFDVKjgHC5NeA7oQI2Rl7APkKZ6DwruTJ5tPvkQ=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3efd8895-dce8-4e6b-8509-08ddd550d763
X-MS-Exchange-CrossTenant-AuthSource: DS0PR10MB7364.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Aug 2025 01:22:14.5896
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NmM/nxIDPh2/JRhiERYzzqrogttv9vK4uPT60QzhctmNAJgCcVkR833B0UavoLY5HoLSCtXybCgUNteBPM5nhQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR10MB6464
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-06_05,2025-08-06_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 mlxlogscore=999
 malwarescore=0 spamscore=0 bulkscore=0 suspectscore=0 adultscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2507300000 definitions=main-2508070007
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODA3MDAwOCBTYWx0ZWRfX4O6Q4vg5DPCU
 ErL/AgKIJpLC5hvhnRCQDEstMM+bJCvecHaZDziCEp9x4L+yeNqrtBQai1yc7qCHlSL1Ga5aF6A
 JwDC2T6J3SR1FYbUI+G7C0ar88l5frH3i2ML0cuK1+izqDQ+660AEegLhDuiPiOBbpJ+JoqHMwa
 Tam3YQ+CRhK3VLKyxzrU1AZ0Fg3ISBokNtG4mkDLsdbQ+JtVoYj0mFo+7h/yIQmPzPUS+gVszXT
 aDwWbG5H7+wltwKg5OFKB8wyNvIQtLeHyxHtn3pkHdcFUHdJygmdNZI2AvqkJWVIr/21dXbyayo
 We4erpvPIfZWn4cIvf3/81/8hde795Uzd9Q3cU8wHdAqPuBa2d496K92Ndf8BIZMlm45qupQsCG
 EZWDBPZDejju3UWlrjuSBhoM2g+51Smw6eXsT6s8lUTRs/S8EqNktLuwRXz0w6WCPqb9PTRi
X-Authority-Analysis: v=2.4 cv=ApPu3P9P c=1 sm=1 tr=0 ts=6893ffca b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=2OwXVqhp2XgA:10 a=GoEa3M9JfhUA:10 a=i0EeH86SAAAA:8 a=Fy-5dL15qF7pESzkTnsA:9
 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: EbzOcjVaDRqXWLTciyUM75-O5Bm8KJFb
X-Proofpoint-GUID: EbzOcjVaDRqXWLTciyUM75-O5Bm8KJFb
X-Rspamd-Queue-Id: AD912100005
X-Stat-Signature: yxhscprpt69eq3hpb5fuosuhzuwyrhet
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1754529748-456771
X-HE-Meta: U2FsdGVkX18qkmfOEiNwbNz+O9nmvqTKokd637kT5d+RSAnbo6WSg5ncyqtw7tQH+BoCMtQauTM//aAhMSBLCht+zucsxk0wrl8BQy5JXzysYREHtrN6soY7zaJt7E+lDyxFv/biJoojeb0XZ3FxoaSDUFc65Ov+0r2BoF7xgCNo/0x3E3lHwVzd7TlGsI6x2P/kMXftoKSv+3HaGSYk/4wAVY49XU6/EhkORMRqNryl4uGS13LTi8Nn1AQJdoKtXSKrx68DbZSW2YnS0UVj+IM/2ncd97JGS1Ky7mN+W9Q1celLfdEtjQi5YKREjdszQkS60rPss44DaXxVcmv9Zij28Cuh+VzqukDTR4nX16SNF+8cMW4ZN+TmsdCNIxUL2zrbKgX7GIP9CKUFvI7yDWNztJJLpbeqYA6ptubs3nKonCD4r4vsIkFP39ao1FCqr8PJaTqYx4/LmopILvJQn17q679B3Oumq4G1XTNineVUtx90gxYdLqt5P93PuXJkM6UfmHojh2X/MAmotfdv82bhJvXLhp3vC6M0mm5m49HKXxnkiX+E8OvCPFuxNDbbIdiNS3QFAuLpm12YpsR84vCjsRWYDiYMLNK9Z5iDoMhoXNruTriC0VfcY/c5IlHGgwn+G2f/C6FwE2/4oRhdPBiDbHhC/79wvvRtYkRbsPDlGRxRj9Ue3R/rr8cjDII4yoZqA0icOf4qJP7NwxdrB2PQsVK3Ty9Bx9RHCUePk4CW8Lrzh1KT8pkFKvaTWrl65OlzkbgIJeqVokbIuT5cSiD/gSInKUwHYghTB4OPgb881cGtolI/qjJ0kbEsxMlsC0HDkpW/dMcD5xOgMAxkpy7m4Xz+eSBv9/1rhVQe24QR0ztnDqsHZ2l27ccGGM4tXTK/U7kPEYvpDsw8nSA8WM8pz0lpn0MbYe4T/ZlJlUPHyy7ovrepzCeahQ7thl20XL+ND3yz2myEPsajlNZ
 HRK5QwX3
 DEGwonWx3523M7d2x7/IJIITpWNDTkb0CSVccri26ejoV3J/clFC/fjUW4m+Yq5du1zaYfjSlLlY9qdqEdsR9C09MQDco7ZHHVy15RWwyprqFN7TJ5nBIKQwCIJ/6rcfPGxnHp1ohV9MJSyPyRBit97KY4lMbmCoP6q3uk83eCks2jaoenIYyjbQfGVcPYm4+Stib4tLON3PcCvLbvnaGQFJmOeKXuXY/y2dxzcHeVdKQAJKVpGiQEirhcPEdDAN14L1uDnbQX9qFyJ9uL1YjlUHbf07Fw2kqABsNZg+hm6sK2jIrjdLTfHU+PcCDqeZsd8r5wEJCyGjjjj5+wrg3DsJpms9CkdoFxsydyHKqGt7AmnZk495Pg3u3hi/i/lmxjuVnaxVUkZjt/LGnOyMF6hjduM+UUfkoJ6Qe9JamK6NH9iIo5jEK8dUrDdMsNdzh/WxhrHTe2RgXlpNu7QYgVy9Q9/uVWGmTEVnd+8iq/CowRK9H3qVVEEnd3GOfwuslA3zKJjv8HQBmHFcRy+AJY3NSW7XveN4uNn7U0hX4Ec9zzicYYrYKey8nJ8bAopBodgJqWCBRecPz0CpiIqTe4v7kZtRqPU4u4gs+0ctEZwkqCeIm9BhfNuT+7gGtdaOK62IsVoaIch5YRUXEyE30zR71iqt+Zxm2IoeMxyYKM5vHaJaUXBdMt7D9WqZWvKC3Q1Hj7+JyGJ6E6JzLoyWrzNNVwvZbU+iVKuph7CUgo3epz8xNg2WEn30YVRdQVn+E1iSdyNJ4i/xnjWm9i6cDSAcTR/Y0m2kaxxNOdqBxb/C1vSdTGJK7EeCE/VI3PCDtmFTcOh6t9dDw2zoFJNXWsxD+AQ0KUw1k4te0
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 8/2/2025 12:31 AM, Kefeng Wang wrote:
> The alloc_gigantic_folio() will allocate a folio by alloc_contig_range()
> with refcount increated and then freeze it, convert to allocate a frozen
> folio directly to remove the atomic operation about folio refcount and
> cleanup alloc_gigantic_folio() a bit.
> 
> Also move folio_alloc_frozen_gigantic(), cma_alloc/free_frozen_folio() and
> cma_validate_zones() into mm/internal.h since only hugetlb use it.
> 
> Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
> ---
>   include/linux/cma.h | 20 --------------------
>   include/linux/gfp.h | 23 -----------------------
>   mm/cma.c            |  4 ++--
>   mm/hugetlb.c        | 43 +++++++++++--------------------------------
>   mm/hugetlb_cma.c    | 12 ++++++------
>   mm/hugetlb_cma.h    | 10 +++++-----
>   mm/internal.h       | 37 +++++++++++++++++++++++++++++++++++++
>   mm/page_alloc.c     |  8 +++++---
>   8 files changed, 66 insertions(+), 91 deletions(-)
> 
> diff --git a/include/linux/cma.h b/include/linux/cma.h
> index 62d9c1cf6326..f116e23629ee 100644
> --- a/include/linux/cma.h
> +++ b/include/linux/cma.h
> @@ -57,24 +57,4 @@ extern bool cma_intersects(struct cma *cma, unsigned long start, unsigned long e
>   
>   extern void cma_reserve_pages_on_error(struct cma *cma);
>   
> -#ifdef CONFIG_CMA
> -struct folio *cma_alloc_folio(struct cma *cma, int order, gfp_t gfp);
> -bool cma_free_folio(struct cma *cma, const struct folio *folio);
> -bool cma_validate_zones(struct cma *cma);
> -#else
> -static inline struct folio *cma_alloc_folio(struct cma *cma, int order, gfp_t gfp)
> -{
> -	return NULL;
> -}
> -
> -static inline bool cma_free_folio(struct cma *cma, const struct folio *folio)
> -{
> -	return false;
> -}
> -static inline bool cma_validate_zones(struct cma *cma)
> -{
> -	return false;
> -}
> -#endif
> -
>   #endif
> diff --git a/include/linux/gfp.h b/include/linux/gfp.h
> index 5ebf26fcdcfa..5ad78c296344 100644
> --- a/include/linux/gfp.h
> +++ b/include/linux/gfp.h
> @@ -440,27 +440,4 @@ extern struct page *alloc_contig_pages_noprof(unsigned long nr_pages, gfp_t gfp_
>   #endif
>   void free_contig_range(unsigned long pfn, unsigned long nr_pages);
>   
> -#ifdef CONFIG_CONTIG_ALLOC
> -static inline struct folio *folio_alloc_gigantic_noprof(int order, gfp_t gfp,
> -							int nid, nodemask_t *node)
> -{
> -	struct page *page;
> -
> -	if (WARN_ON(!order || !(gfp & __GFP_COMP)))
> -		return NULL;
> -
> -	page = alloc_contig_pages_noprof(1 << order, gfp, nid, node);
> -
> -	return page ? page_folio(page) : NULL;
> -}
> -#else
> -static inline struct folio *folio_alloc_gigantic_noprof(int order, gfp_t gfp,
> -							int nid, nodemask_t *node)
> -{
> -	return NULL;
> -}
> -#endif
> -/* This should be paired with folio_put() rather than free_contig_range(). */
> -#define folio_alloc_gigantic(...) alloc_hooks(folio_alloc_gigantic_noprof(__VA_ARGS__))
> -
>   #endif /* __LINUX_GFP_H */
> diff --git a/mm/cma.c b/mm/cma.c
> index 2ffa4befb99a..9539fd5700b6 100644
> --- a/mm/cma.c
> +++ b/mm/cma.c
> @@ -921,7 +921,7 @@ struct page *cma_alloc(struct cma *cma, unsigned long count,
>   	return __cma_alloc(cma, count, align, GFP_KERNEL | (no_warn ? __GFP_NOWARN : 0));
>   }
>   
> -struct folio *cma_alloc_folio(struct cma *cma, int order, gfp_t gfp)
> +struct folio *cma_alloc_frozen_folio(struct cma *cma, int order, gfp_t gfp)
>   {
>   	struct page *page;
>   
> @@ -1008,7 +1008,7 @@ bool cma_release(struct cma *cma, const struct page *pages,
>   	return true;
>   }
>   
> -bool cma_free_folio(struct cma *cma, const struct folio *folio)
> +bool cma_free_frozen_folio(struct cma *cma, const struct folio *folio)
>   {
>   	if (WARN_ON(!folio_test_large(folio)))
>   		return false;
> diff --git a/mm/hugetlb.c b/mm/hugetlb.c
> index 4f73b74a2cff..eea9dc782007 100644
> --- a/mm/hugetlb.c
> +++ b/mm/hugetlb.c
> @@ -125,16 +125,6 @@ static void hugetlb_unshare_pmds(struct vm_area_struct *vma,
>   		unsigned long start, unsigned long end, bool take_locks);
>   static struct resv_map *vma_resv_map(struct vm_area_struct *vma);
>   
> -static void hugetlb_free_folio(struct folio *folio)
> -{
> -	if (folio_test_hugetlb_cma(folio)) {
> -		hugetlb_cma_free_folio(folio);
> -		return;
> -	}
> -
> -	folio_put(folio);
> -}
> -
>   static inline bool subpool_is_free(struct hugepage_subpool *spool)
>   {
>   	if (spool->count)
> @@ -1477,29 +1467,15 @@ static struct folio *alloc_gigantic_folio(int order, gfp_t gfp_mask,
>   		int nid, nodemask_t *nodemask)
>   {
>   	struct folio *folio;
> -	bool retried = false;
> -
> -retry:
> -	folio = hugetlb_cma_alloc_folio(order, gfp_mask, nid, nodemask);
> -	if (!folio) {
> -		if (hugetlb_cma_exclusive_alloc())
> -			return NULL;
> -
> -		folio = folio_alloc_gigantic(order, gfp_mask, nid, nodemask);
> -		if (!folio)
> -			return NULL;
> -	}
>   
> -	if (folio_ref_freeze(folio, 1))
> +	folio = hugetlb_cma_alloc_frozen_folio(order, gfp_mask, nid, nodemask);
> +	if (folio)
>   		return folio;
>   
> -	pr_warn("HugeTLB: unexpected refcount on PFN %lu\n", folio_pfn(folio));
> -	hugetlb_free_folio(folio);
> -	if (!retried) {
> -		retried = true;
> -		goto retry;
> -	}
> -	return NULL;
> +	if (hugetlb_cma_exclusive_alloc())
> +		return NULL;
> +
> +	return folio_alloc_frozen_gigantic(order, gfp_mask, nid, nodemask);
>   }
>   
>   #else /* !CONFIG_CONTIG_ALLOC */
> @@ -1641,9 +1617,12 @@ static void __update_and_free_hugetlb_folio(struct hstate *h,
>   	if (unlikely(folio_test_hwpoison(folio)))
>   		folio_clear_hugetlb_hwpoison(folio);
>   
> -	folio_ref_unfreeze(folio, 1);
> +	VM_BUG_ON_FOLIO(folio_ref_count(folio), folio);
>   
> -	hugetlb_free_folio(folio);
> +	if (folio_test_hugetlb_cma(folio))
> +		hugetlb_cma_free_frozen_folio(folio);
> +	else
> +		free_frozen_pages(&folio->page, folio_order(folio));
>   }
>   
>   /*
> diff --git a/mm/hugetlb_cma.c b/mm/hugetlb_cma.c
> index e8e4dc7182d5..337776786ecf 100644
> --- a/mm/hugetlb_cma.c
> +++ b/mm/hugetlb_cma.c
> @@ -18,29 +18,29 @@ static unsigned long hugetlb_cma_size_in_node[MAX_NUMNODES] __initdata;
>   static bool hugetlb_cma_only;
>   static unsigned long hugetlb_cma_size __initdata;
>   
> -void hugetlb_cma_free_folio(struct folio *folio)
> +void hugetlb_cma_free_frozen_folio(struct folio *folio)
>   {
>   	int nid = folio_nid(folio);
>   
> -	WARN_ON_ONCE(!cma_free_folio(hugetlb_cma[nid], folio));
> +	WARN_ON_ONCE(!cma_free_frozen_folio(hugetlb_cma[nid], folio));
>   }
>   
> -
> -struct folio *hugetlb_cma_alloc_folio(int order, gfp_t gfp_mask,
> +struct folio *hugetlb_cma_alloc_frozen_folio(int order, gfp_t gfp_mask,
>   				      int nid, nodemask_t *nodemask)
>   {
>   	int node;
>   	struct folio *folio = NULL;
>   
>   	if (hugetlb_cma[nid])
> -		folio = cma_alloc_folio(hugetlb_cma[nid], order, gfp_mask);
> +		folio = cma_alloc_frozen_folio(hugetlb_cma[nid], order, gfp_mask);
>   
>   	if (!folio && !(gfp_mask & __GFP_THISNODE)) {
>   		for_each_node_mask(node, *nodemask) {
>   			if (node == nid || !hugetlb_cma[node])
>   				continue;
>   
> -			folio = cma_alloc_folio(hugetlb_cma[node], order, gfp_mask);
> +			folio = cma_alloc_frozen_folio(hugetlb_cma[node],
> +						       order, gfp_mask);
>   			if (folio)
>   				break;
>   		}
> diff --git a/mm/hugetlb_cma.h b/mm/hugetlb_cma.h
> index 2c2ec8a7e134..71db3544816e 100644
> --- a/mm/hugetlb_cma.h
> +++ b/mm/hugetlb_cma.h
> @@ -3,8 +3,8 @@
>   #define _LINUX_HUGETLB_CMA_H
>   
>   #ifdef CONFIG_CMA
> -void hugetlb_cma_free_folio(struct folio *folio);
> -struct folio *hugetlb_cma_alloc_folio(int order, gfp_t gfp_mask,
> +void hugetlb_cma_free_frozen_folio(struct folio *folio);
> +struct folio *hugetlb_cma_alloc_frozen_folio(int order, gfp_t gfp_mask,
>   				      int nid, nodemask_t *nodemask);
>   struct huge_bootmem_page *hugetlb_cma_alloc_bootmem(struct hstate *h, int *nid,
>   						    bool node_exact);
> @@ -14,12 +14,12 @@ unsigned long hugetlb_cma_total_size(void);
>   void hugetlb_cma_validate_params(void);
>   bool hugetlb_early_cma(struct hstate *h);
>   #else
> -static inline void hugetlb_cma_free_folio(struct folio *folio)
> +static inline void hugetlb_cma_free_frozen_folio(struct folio *folio)
>   {
>   }
>   
> -static inline struct folio *hugetlb_cma_alloc_folio(int order, gfp_t gfp_mask,
> -		int nid, nodemask_t *nodemask)
> +static inline struct folio *hugetlb_cma_alloc_frozen_folio(int order,
> +		gfp_t gfp_mask, int nid, nodemask_t *nodemask)
>   {
>   	return NULL;
>   }
> diff --git a/mm/internal.h b/mm/internal.h
> index 1da16d550a45..b12cd23e88c4 100644
> --- a/mm/internal.h
> +++ b/mm/internal.h
> @@ -933,6 +933,9 @@ struct cma;
>   #ifdef CONFIG_CMA
>   void *cma_reserve_early(struct cma *cma, unsigned long size);
>   void init_cma_pageblock(struct page *page);
> +struct folio *cma_alloc_frozen_folio(struct cma *cma, int order, gfp_t gfp);
> +bool cma_free_frozen_folio(struct cma *cma, const struct folio *folio);
> +bool cma_validate_zones(struct cma *cma);
>   #else
>   static inline void *cma_reserve_early(struct cma *cma, unsigned long size)
>   {
> @@ -941,8 +944,42 @@ static inline void *cma_reserve_early(struct cma *cma, unsigned long size)
>   static inline void init_cma_pageblock(struct page *page)
>   {
>   }
> +static inline struct folio *cma_alloc_frozen_folio(struct cma *cma, int order, gfp_t gfp)
> +{
> +	return NULL;
> +}
> +static inline bool cma_free_frozen_folio(struct cma *cma, const struct folio *folio)
> +{
> +	return false;
> +}
> +static inline bool cma_validate_zones(struct cma *cma)
> +{
> +	return false;
> +}
>   #endif
>   
> +#ifdef CONFIG_CONTIG_ALLOC
> +static inline struct folio *folio_alloc_frozen_gigantic_noprof(int order,
> +		gfp_t gfp, int nid, nodemask_t *node)
> +{
> +	struct page *page;
> +
> +	if (WARN_ON(!order || !(gfp & __GFP_COMP)))
> +		return NULL;
> +
> +	page = alloc_contig_pages_noprof(1 << order, gfp, nid, node);
> +
> +	return page ? page_folio(page) : NULL;
> +}
> +#else
> +static inline struct folio *folio_alloc_frozen_gigantic_noprof(int order,
> +		gfp_t gfp, int nid, nodemask_t *node)
> +{
> +	return NULL;
> +}
> +#endif
> +/* This should be paired with free_frozen_pages() rather than free_contig_range(). */
> +#define folio_alloc_frozen_gigantic(...) alloc_hooks(folio_alloc_frozen_gigantic_noprof(__VA_ARGS__))
>   
>   int find_suitable_fallback(struct free_area *area, unsigned int order,
>   			   int migratetype, bool claimable);
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index d1d037f97c5f..c542ababb8dc 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -6822,6 +6822,8 @@ static int __alloc_contig_verify_gfp_mask(gfp_t gfp_mask, gfp_t *gfp_cc_mask)
>    * @gfp_mask:	GFP mask. Node/zone/placement hints are ignored; only some
>    *		action and reclaim modifiers are supported. Reclaim modifiers
>    *		control allocation behavior during compaction/migration/reclaim.
> + *		If gfp_mask contains __GFP_COMP, the refcount of compound page
> + *		will be not increased.
>    *
>    * The PFN range does not have to be pageblock aligned. The PFN range must
>    * belong to a single zone.
> @@ -6955,7 +6957,6 @@ int alloc_contig_range_noprof(unsigned long start, unsigned long end,
>   
>   		check_new_pages(head, order);
>   		prep_new_page(head, order, gfp_mask, 0);
> -		set_page_refcounted(head);
>   	} else {
>   		ret = -EINVAL;
>   		WARN(true, "PFN range: requested [%lu, %lu), allocated [%lu, %lu)\n",
> @@ -7074,10 +7075,11 @@ void free_contig_range(unsigned long pfn, unsigned long nr_pages)
>   	struct folio *folio = pfn_folio(pfn);
>   
>   	if (folio_test_large(folio)) {
> -		int expected = folio_nr_pages(folio);
> +		int order = folio_order(folio);
> +		int expected = 1 << order;
>   
>   		if (nr_pages == expected)
> -			folio_put(folio);
> +			free_frozen_pages(&folio->page, order);
>   		else
>   			WARN(true, "PFN %lu: nr_pages %lu != expected %d\n",
>   			     pfn, nr_pages, expected);

Is this patch solely for the purpose of saving a few back-and-forth 
setting refcount calls?

It seems to me that altering the behavior of alloc_contig_range_noprof() 
to the contrary of its comtemporaries, such as __alloc_pages_noprof(), 
alloc_pages_bulk_noprof() in mm/page_alloc.c, might be a source of 
confusion to unaware callers.  E.g.virtio_mem_fake_offline() calls 
alloc_contig_range(), for now, without setting __GFP_COMP, but if it 
does in future, it could be tripped.

I guess it's helpful to keep the existing convention such that, these 
alloc_()s from page_alloc.c behave the similar way, in that, head page 
is returned refcounted.

thanks,
-jane


