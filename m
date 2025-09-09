Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4D152CA1016
	for <linux-mm@archiver.kernel.org>; Tue,  9 Sep 2025 01:49:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9033F8E0002; Mon,  8 Sep 2025 21:49:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8B3038E0001; Mon,  8 Sep 2025 21:49:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 72C808E0002; Mon,  8 Sep 2025 21:49:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 589728E0001
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 21:49:23 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 005E2140362
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 01:49:22 +0000 (UTC)
X-FDA: 83868029406.18.7653442
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf30.hostedemail.com (Postfix) with ESMTP id 7DDB080003
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 01:49:19 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=J36vdr5C;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=hyO9i82w;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf30.hostedemail.com: domain of jane.chu@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=jane.chu@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757382559;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1Brb0mbTtARkdR1wJE7alA+Oj3oZjlndngxOHiHvcZw=;
	b=Aidf/09ZKlV9t4rc+uNnWdT4wKXBaTMmOYfnOLISJFvkoU1LB0Bj5pWzgozPRLrdLNP3AC
	7akNyvqz1ilN6t38AlRHkJ9vKJhj9XiSaMStIf6az/RZmYodKi1ByX71/FthejYSlG5Tca
	WvIme2FvaoWKCIV7/YNDQHlJS6WUkjU=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1757382559; a=rsa-sha256;
	cv=pass;
	b=4PKYG4rrncBlwIY7R5tXsKBxXdF2CBcY7ZLcL+ZkcIGJ0u90XnJTLZfZHycjjI/7UmH2KF
	A1tH1GaFUbVipKqZEfiuHSwZFzGw8355Us5PkbHJ0ka9otp2P3R7L39LUDG4PO5WF06fbR
	j6ydXCbyIVifektMcvQ70LlgK6LXRXo=
ARC-Authentication-Results: i=2;
	imf30.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=J36vdr5C;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=hyO9i82w;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf30.hostedemail.com: domain of jane.chu@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=jane.chu@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 588LBhTm026466;
	Tue, 9 Sep 2025 01:49:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=1Brb0mbTtARkdR1wJE7alA+Oj3oZjlndngxOHiHvcZw=; b=
	J36vdr5CQ2ixgbRA6KIOKdtUPMAfzUIundO02V7MSVwS0gPY4qD1mPFdo07HKnJF
	tkotVdHTZoVfkcPPEO6z+Rigr0Gsui6pHgrwrLbY1+Wte48ov3KCw9dlKrqH33cO
	UZ9UgqSQXkCBMA5JtNMCAPv46pY4MwGiZf30xSeTpX4Dc7N+ARVeuns1xEsIlN/3
	GAQf+JKs+MmshnicbmwQO69vP0AA/BG5Y7/7nRW1kq4srpYeQeXPbgL8XIT3r9dh
	lDxfU+MbK6IaykvYNO1zRW2qWBzc1Ylw75IHTdqc58mld7q3ccM3wnlqbE5v3Pr2
	t0+8WE+xdNGf3+f8znLy0Q==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4922shrr5x-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 09 Sep 2025 01:49:08 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 588Na88L026002;
	Tue, 9 Sep 2025 01:49:07 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11on2078.outbound.protection.outlook.com [40.107.236.78])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 490bd8xuse-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 09 Sep 2025 01:49:07 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=py2FW/l59VzQ4ySY01VflpT/ZRgmX2vUpV8fjQ62MA7u7dntOojumFCT2NjEvUwJZmMNINpamYDObcHyKuaVlbL/6vGxeGLFG9k0DE7T/7d2ZjhH8lmDbBP56IMjJoH8I1e4sEfeKB7gmiJXCcEUMu4cp0meI9u6SF7FWv0H+guNYrkbERXXosfKJ2TfDuCrwdTgIfkmqDGWhnX5zeyo7yao+n9XnOlZL0j9QVW2LqwMjVbUXqJwFb5m0aqzCQnipgDN17ALjv/Qi6aSrNt3qmCnAsQ0V23tRuLaR2NMNVSgJlZRIRa+zMU4hgg1/nPOMeeWh0DMReh1u3hLwmpgpQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1Brb0mbTtARkdR1wJE7alA+Oj3oZjlndngxOHiHvcZw=;
 b=aBnKK9Uz/4lHWsqGTrIl+XNaIKMfHHgnSQK0FnfG4QfalXPNnQ/xTHBiogVsPucUfoce2GJmu38QoRYfqvSzMI97YoNo7wCcBC8xT+lL7nkZZ8iRrySjqiIY730JbRSv7gIWdA3mItU9jrlhkIiybBerz/Omjqjh4/I6KK9SqOv1w0YsyO8eNt4myCUe4jjdb9XhlsiwaR7UZZw8vhuAnOUl5ZhbuJ19eG02wXuw5tOcS/9jNbbF0e7pfsLvynwJxTSeHDF+VAmGxFkkJyEe6oIugW+ZPV/gLS1U7xjhDL0j3OgC7aUPwsn80+v1rXI77wkQFInt2ddEW2+8RLV8AQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1Brb0mbTtARkdR1wJE7alA+Oj3oZjlndngxOHiHvcZw=;
 b=hyO9i82w4weBOrmQRV9WT2Os4fSAKvAG35klXYUFXmB9X4Zbkt2kvciAlfA9VIrcdmkoZU/PrTFWTbYsCHnqumnJMjatmss43KGGgdynU0gXGQ3bXjSsnnJ0Eh3Jo2tGY821MhwDzpSFz95EV7tXM+UwG7FRvloUaUDbGblUBm8=
Received: from DS0PR10MB7364.namprd10.prod.outlook.com (2603:10b6:8:fe::6) by
 SJ0PR10MB5802.namprd10.prod.outlook.com (2603:10b6:a03:426::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9094.22; Tue, 9 Sep
 2025 01:49:04 +0000
Received: from DS0PR10MB7364.namprd10.prod.outlook.com
 ([fe80::b7d7:9d3f:5bcb:1358]) by DS0PR10MB7364.namprd10.prod.outlook.com
 ([fe80::b7d7:9d3f:5bcb:1358%6]) with mapi id 15.20.9094.021; Tue, 9 Sep 2025
 01:49:03 +0000
Message-ID: <cfaf16a0-00dc-4624-b379-17d6b1b5ad02@oracle.com>
Date: Mon, 8 Sep 2025 18:48:59 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 9/9] mm: hugetlb: allocate frozen pages in
 alloc_gigantic_folio()
To: Kefeng Wang <wangkefeng.wang@huawei.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Hildenbrand <david@redhat.com>,
        Oscar Salvador <osalvador@suse.de>,
        Muchun Song <muchun.song@linux.dev>
Cc: sidhartha.kumar@oracle.com, Zi Yan <ziy@nvidia.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        Brendan Jackman <jackmanb@google.com>,
        Johannes Weiner <hannes@cmpxchg.org>, linux-mm@kvack.org
References: <20250902124820.3081488-1-wangkefeng.wang@huawei.com>
 <20250902124820.3081488-10-wangkefeng.wang@huawei.com>
Content-Language: en-US
From: jane.chu@oracle.com
In-Reply-To: <20250902124820.3081488-10-wangkefeng.wang@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR05CA0096.namprd05.prod.outlook.com
 (2603:10b6:a03:334::11) To DS0PR10MB7364.namprd10.prod.outlook.com
 (2603:10b6:8:fe::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR10MB7364:EE_|SJ0PR10MB5802:EE_
X-MS-Office365-Filtering-Correlation-Id: 02f4247e-eaab-4fe8-3be9-08ddef430dba
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|7416014|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?bWYzdEhkOG1Bdk50TVZEcC92VlBDZXd5SVpNdTgrNXJNeFFKOVRUeFVMTHRt?=
 =?utf-8?B?b2lTaVZxOGNBT1FzSG9sOURWQVc4NFFqczZidm1lY2dScUl6UnlSWVY3bWsw?=
 =?utf-8?B?Y0Zjc0dqdUN1aGV0SVBua1hIMHhFZDRKSFdPMFB3aUJsT1lsVzNBUzMrbFVz?=
 =?utf-8?B?bERrVDZoTmdNVm5POEtyMGxvQzZxQWhKZ2FDSTRocXpHUFROYXZ5QkpiRjlJ?=
 =?utf-8?B?d2JDdm4wTWJSRGY5TXY0dzhCZThXb2lTc3RiMVZNcGtVa2IvdHhodUcwU2tB?=
 =?utf-8?B?RVlKSzA1MU43VHAweE9xQ2Y3V2tEeHA2QllLaDlLdS85Y2dBWVFxWk9rOXZZ?=
 =?utf-8?B?Z2ZEL2ZkNXpoSTN2RE40dGd2TGhsd3llZUs5R0lyenMyT09iWnNFM2JneUZW?=
 =?utf-8?B?RTRQZzRLY1ZXcWE5T3F0a254OHVEai9USU5sNDVjS0NHS2hjeEVGZUEyNDBP?=
 =?utf-8?B?OU9hb3VJMnZjYWhpd3pBdVZwN2sxNVhad0N1ZE9IVE5TU25JQUlTR3UvOVgr?=
 =?utf-8?B?Q3R3VmJrQmk5TFZXcm1NS0U5RFlyYkNuSFlzMmRQak1qR1ZOanBvM2ovWkpD?=
 =?utf-8?B?SUJscGE2WXpRUDZjbDZYNjRZdytVRWlyNHFxUGVnVDUvQ1djWWt4VXVBaEdq?=
 =?utf-8?B?dmpRV25oek5Jcm5oeGQ1K09QV2kxcmVqTURRSEo1b2g3aFFyeVhMQmg2Q0p1?=
 =?utf-8?B?L2xtWHk4aXJWUzFXUGt1aVducjJUYVRjTzBoMGRoSU9Hc1VoWVFWeWVqWG14?=
 =?utf-8?B?MCt4TzRNUWNvelNWSGs1a1hGNWs1eW9ERm1uMVZSeUpLSFdybFhmblhmVXFx?=
 =?utf-8?B?OW5zMTc0bGptamZ0SS8xdVk3a3Ayd3oxUkdLcXJ5Q21kcHVjbFlRK2gwRHlJ?=
 =?utf-8?B?alFFL2NFY1YzS2xNVHg4czhtaUtNT2pHcUJOVDR5NElNTFNFTUp2elVwR1RW?=
 =?utf-8?B?T2NLVU1ZWFZHVldUelJwc1ZYVHM1U1ZzVWNXakxydDlaVitRMmRxT3U1RVNB?=
 =?utf-8?B?MmNMblFxWno2QWNLVUlsZzVQbG1YRHhJeVBGRDFlWnhRaEZVV3ArTi9GOWpB?=
 =?utf-8?B?NVkrRmZhaVJwMjJVWGxHc3Y5bHhCNXVuQWdGaEJnd1JOaDZaalJTL0ZsNGMw?=
 =?utf-8?B?eUdrSlFhWkRHaUlPWHFzcW44YWRjcnRwYUlTSnlpbm5wV21BUWhHOVozK2ZC?=
 =?utf-8?B?ajJQUHZHTTZXSjVueU1yVFRhb1loZ1JEUE5CeTQyWm54bk1IUHVqaEtCcnMr?=
 =?utf-8?B?cnpueEpJdWFoZzZ5c3cwM0ZaSEJvaE5iTHczY3RvYmxRb1pLSC9rUG9HUzJp?=
 =?utf-8?B?RHFsRTA0NE1YSC9CZitKN0N1VEZGejM1MkpUNGZRYTlrVEhzcm5vRElHMVla?=
 =?utf-8?B?b3JtZy9UOXVpNGRpc3hJZU11M1lTd25ZQUk3L2RHaXZkNC93NllOUkorVTBS?=
 =?utf-8?B?YWQwcnpxQVl4bHl3WDI0Q0ErV3RvbmxSTFhIUkIwNXUrTmVzYUVLOWNOUzBE?=
 =?utf-8?B?L0FLYkt3cWQxWTdWOGpsZ25tQVdKS0daVE42N2lHQjFpVmNtam9DUlpRbmt6?=
 =?utf-8?B?cHM4d2Jvc2dxeHg1MGUxb0pxdEIrN1BYWWlGeHFmeE54VzRIbmFZYjJEWjBT?=
 =?utf-8?B?NmVEOG5DMDFnTkVUTjVhVlJCb2wzWmpkY0ZlQ1VWemkrUHh5L05kM3g2b1VJ?=
 =?utf-8?B?LzFoZXNWNkhKQTBzQUZhR2RzYmh6SXQ4SWFiOHVNakxEY3c1MTAwSHpwNFht?=
 =?utf-8?B?MHJvbXg2YUFzN1BhRENhc0xNSXVrQVpCamFSNEc4WExaamVkRkw1bXNZR3h0?=
 =?utf-8?B?WnRVSTZxRGx0OEhQdzVzK3JBaitianVLU0xEUjQ2amsrVmtNRFN3RmtjRFl4?=
 =?utf-8?B?d2o3b2xqcWdnUElxSGFiMmxXbEVSSHJSWDF6TTU1MFpMOHhEaUY5VndUbWcz?=
 =?utf-8?Q?l/8TC66yvsM=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR10MB7364.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?d2tkeTlZeGR4cDdmcFJacmpjT1FZbzZud2dRR0tpbUJmNm83dWVQSzRMZVJF?=
 =?utf-8?B?dlJReHpnR0ZnMDBhK01zSitNZTNvamdVaTVZNG5xcjNHZGJyeEZwRU9OMHpW?=
 =?utf-8?B?TUhKRWtWSGR3TkR6V2o1L0liOHVCZ3ZTb3dlRzA2WEozVXlYNXFJZDNqdnpZ?=
 =?utf-8?B?a1BxK21wMGdtR1ArcXJpanBaRElUZnUzOHBPOWdtMmo1UFFnVmJqb2xKT2VJ?=
 =?utf-8?B?ZWdOWnhidEdtbWFjZ1ZpOVg5SlltSVlXem9sUjR1L3FwRjJKcHphNVhpUDlJ?=
 =?utf-8?B?TTR5ckhWZWMrdVZUamNYQncrTDl0YThBR29WMVIxaHZ1b294T0pvTkFGdWJa?=
 =?utf-8?B?K0Vlb1kzVS9oVmlzKzcxQ1dyc1VPZ0dYaksvdzFKRWZkTlA4MWc5RlQ2WFRZ?=
 =?utf-8?B?RlBDMW55ZFY2b1o5SE5aa3NsRHhpS0M0YlR6Rk9hRnVYUEViaGtPRVB3N3oy?=
 =?utf-8?B?U3Y3c2VxOGdFcDZZejBMSmFUMHVIbnZxMlNnT2kyRHBNbERya1JBdUt3ZE04?=
 =?utf-8?B?VW9iNjNQRGJwbTVVWkt3eDdCeWxqT0I1cFh5azRDSk1tR0FIbjNPdTRGU1cv?=
 =?utf-8?B?alI3d2p3ZkVzMG9sdVpPTGdrYWMyR090YnZhNGZqaUtVaHc0N0dvQmMxSG41?=
 =?utf-8?B?OGt4SUNBcHJIeEVMMEtlK0hoZnhxRk5XY2FTTEtzb09VeDRLTmh5Z0krcitC?=
 =?utf-8?B?cWNNK2xFUXZxRDU1MzJKWmZTWDZVZ0NEdUZFYktXalM1ZExRd0JjVjJYR0Fw?=
 =?utf-8?B?K1hLcExoOExDcEhrS0hnT25ZZ1NyNmRVK3Zha1JPUXdDZUtmY2NKbXVYUG1y?=
 =?utf-8?B?eTIzYW9sOTVYV1hoL0FxZ3RVTGpuYkRMaWMzM2dUUWlPOHhpR2JVR0ZsSVdL?=
 =?utf-8?B?Z2tNVVNNRVVUdXcwUTRXV0VQT0FTaEdjTC9lejhFT2FPNmhDSy9JTG9RSkIz?=
 =?utf-8?B?L3JIeXNwNC9xUjlXYjI4elRGTlZlRDRINmJUNnF5SGNpQnlKU1V6VWVmY2JH?=
 =?utf-8?B?WkpVNHoyRlFwOVVNVEM3T3I1ZjZZL0ZRRUR1VkNuQ3QxMzJWSkZrMk94Z1ZW?=
 =?utf-8?B?VVBPME9VSTJ3K3M0MGFnZFRDZWgvRGJIRTJFclB4RU9SOVJKbUxMUGo2ai94?=
 =?utf-8?B?S3pTQkdLM3pTdjhhZ3BwNDdKZGNGZWRIL3JBTVQzZTVURThvcnpTSDdFZnZ3?=
 =?utf-8?B?YW5xTEF6eWhsRWJxWEl0dFEvNDJmVTlqSVlBMGlLQkg2eWlkVXFoL1ljOTVP?=
 =?utf-8?B?ejdNaXFnaDFQdHNhbS9oak1Sc09IUmdNVUhmejRHYmVOTE15RjM4ZjRScjIy?=
 =?utf-8?B?MWFZTDFpUlhFTUdEWWtaTkJjZUNTUHdzQXJSMTc4OVB3cmpVUnF6bzlZN2Ew?=
 =?utf-8?B?RFBidVMyeG9vSERUSVVpazRiTjNIUDJ1WElrNDdRcm94czRVOHE2NEcveGdW?=
 =?utf-8?B?WjJDd1FXQ2hMalJHSXgrUExUTGpkZHF2dXVZb29XWjJwa1RVeGJSMmk4NmMy?=
 =?utf-8?B?RWw2V081eldoN28rWkRwMGV5a3JtTXVmbXpmOVl0MlNqaXp4b0hpTzg2VFg3?=
 =?utf-8?B?NWpvb1hnTmtvVzBRelRZVFQ2R3Z2blR4eDk1aC94ZSs4MkE3ZGwwZklRNjE1?=
 =?utf-8?B?VElzUTFwTUpIWWRvSGtCbUUwOVBkaG8yVkRLcEdnZG4rUUtwTkpXOW1JZ3kz?=
 =?utf-8?B?eFNGbnBkUm1jSHFNTkR4SE1CSXRlMmJrcXE4QXhWamM5aHpETlVENWNEKzVJ?=
 =?utf-8?B?a0ZvaVo4aTBWTUxOeHlPd211WnVOUzArNGY5RHFLZzF6ekNaUFp0UU9XYTJT?=
 =?utf-8?B?Z0praTNpY2ZseE1QWll0dWtJL29FQzZMT3RIZWlNNWJXRGhZNk4yLzQ4bDl6?=
 =?utf-8?B?dnZuYk9FNzF6anl4TUYwY1p2RkVHTEk4Z2kweThiQk1UeXZLdWtVRmFJcmtm?=
 =?utf-8?B?RStOTXJEcmZlK0FGRldxTEVYODVMRGFrRDJ1cllub3ZQYWZlN1IyOEUvUDJQ?=
 =?utf-8?B?NGpwOU92SEUrcTlOSjNsaDJxZFZGK0N0c3Rnd1YvYUF4MWhacllUYW1yL0ZO?=
 =?utf-8?B?Z0swZ2Y5YTkyTWthTE1qQ3pzeHVSN2F5NksvMDMyS0hSa055dXU0MVh4aU9T?=
 =?utf-8?Q?E6eKA+ZRDjCMpiiJtlz/P4gYV?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	gHl09GTKRU5NXqnRWiOuhwzAmA8sMHkFwZAcUwr5NbGjgRtefpPOcThlFYaOlxxvsZcgaYpQm3vPm5egZCJah36Sv5+7OPlWn/w9SytRPf+QE0jTF2DtUAnhWQwGujT/RQrwH/0ej8PD9ftWXKAlFJJ218dww5GXE12YdaHTkqEMhDwFYilciZ6SV5droNXu5/zzk4KifGxoLRWW7Ea9UWZFIlRwuqXLHl4Z7pOV1MZeiMzNHR5sYGgoO43oPHODywmuPz6Idrnbk6NyO/x4OzKOE4BYdkmXUA5tAYpHJGIePp1LDNwTItQyt8AQZVPYPb1v0GuxQ/fb1Z0WLWYzN6hBmw+CWheJ3E0D64VzTrRpEE9UfVqLNtb2qyCPztWctD1lcfny44huhDEEQ/GRVsts06aJnHyH2kZJJPMnqAS26zTT8elQmGzUzSxVcauMQlqvTecUfty0WKaELJnfQw0bN219V4bqfQDIJh4Z3eowfEAkG9HpQKeuYOygTG987twTtBlsDg0QXgrJ2OqdWMluu0CrNr0YhM15hWB7AbB+DNGCdj1GwkHmEapTEhR4lgxKpAKJyJ3V3ciyyNX0CUYrhnbyJ3eBcibZ22iOLhc=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 02f4247e-eaab-4fe8-3be9-08ddef430dba
X-MS-Exchange-CrossTenant-AuthSource: DS0PR10MB7364.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Sep 2025 01:49:03.0939
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ldG3LmereWKqqtqBt77K1+tZFKpDMceygBZz9BoqOIA+wlaabCsZL8+Di3aYuvMpod0/2swxVMti7T//PBDSNA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB5802
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-08_06,2025-09-08_02,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 suspectscore=0
 mlxscore=0 adultscore=0 bulkscore=0 malwarescore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2508110000
 definitions=main-2509090016
X-Authority-Analysis: v=2.4 cv=esTfzppX c=1 sm=1 tr=0 ts=68bf8794 b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=yJojWOMRYYMA:10 a=GoEa3M9JfhUA:10 a=aQOE4EQ31JAa7rfHiR0A:9
 a=QEXdDO2ut3YA:10 cc=ntf awl=host:13614
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTA4MDE2NSBTYWx0ZWRfX32D0LUqV7X6q
 sRaouzhYDaiASJR+R5FL1v3y/yBUjrjF3iKgo1KMcBiqJYy7w/84T4ukGUPjLBIGZIBO8twmBsd
 q39KaAW7TZH3cXK5egGUTgmZYqLu2E+NtTDZOio7is7DmjDOht3bGJP5VJut23EA/VWDXxzksLd
 DhKNIFgUcZxuyJzsBsnw4vm8rll0UkJeGqa7CmnK7/v+HPXHtlQPxi26EOeojE9y2cxQPTOpmPu
 qmQ+JdeXM6A8oHZdlUiB49gxAfwow1ub12hOwLs7/xzKCyFT2L1OhiezwveER8wzbvbUu0uB9Rv
 lyVzKQav/ryMVryO2ADnxeH3tc7/+wXnotRNSVVAZICp1zcG9Ioyhh+r4F9og9H8ANIIAJxN4zo
 Z9jf1feWUBbeEDPGBd2VEgLfnsg1tg==
X-Proofpoint-GUID: fgXcE7-lgFHVsmTVx8AV0x207Djhxy7X
X-Proofpoint-ORIG-GUID: fgXcE7-lgFHVsmTVx8AV0x207Djhxy7X
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 7DDB080003
X-Stat-Signature: uf8h87k5zzfzhqm8g9msx3pf4pix7d7n
X-Rspam-User: 
X-HE-Tag: 1757382559-368336
X-HE-Meta: U2FsdGVkX1/Yq3cf/UPvNu3SGjij5Mg7Z6P+XGTNpItBIFjjWjW1HYnkjOVOKPJcS+Gz5L5bgc7QA2ltjok0qJGhnIfuSZgn9wCWckI7Yjh1an5XJDjwPIMSF4Vi7txQnyQH0f8hmKsTGKeoUcPRaxwGyVDSERlfgAGvJzo5M9E3TAQEJ7uyyKXsy5rtF5Ne8j1JNKVSKwAaDMjw/Oden9ei7V7v8Ul1cXZdDPeMIGcTCzvBor51X5yxTHfAdkEQY6lPX5lDEqCXhS7Km8xUp5K088cL7zqdjXz/WF8ZINoSWu6rwYZe5y65BlGdYVx4sqNZmiZFmxn9jVHc+TYb8ZalvhjdS94OQY5i8We+ugQ1j5ORsx3n5+wCOTv+HRDbwROYrFD128JgCWEOFE2s2FKMs/xQLqwAIEc9ROzJ99SGq9t57VqfNBYVDOF2ZALalbKf8UJ2xmmPM402DG8+SPJfEwXaizZ0mWKB5CAg72YarfoIheXIKfs2SgHQr3LErAlkZ9QVWnYbKOkit7d+RAqww1V2kyV+bX0GLQoQZc9IBo373u6VAO/NhZZlxNrqT8sxdUKVE+K+wZ5HhP98yCTJlTKL8zG90sQOvFhRsXIk8ETZi2bqfShjUB92ALRw9htNDYIu1rIXnhJIg7hS5Aw3wCE9IwnrkU0Mne5d5jYPnpAEqSyC+lt4iy3tUK6HKspbk+Y0Iv2nD9K/j2A5es+8AlKOe7v8ucy18YkLWUy2IIO8hYLGliJ7Bqm0ZWObjbhvq0/rjN3MsLbv7tY4E8Ck5W6srW/b+pKQwF/5Msua90hQ6tFRTLhO3mRMZHtwp+4CLBauQSYeMYl8o3oNk6cveR/GdpFiU9JBEXsKqVUr3H2oRSeRZJHEdMJbQzukUTSscB7QnCWGKZ3gcpDtds1DH0ARpPuYNgtwZmHOkzkIDEgMzdhb1/R6VHsHNlUBRIfCkJgYI+sMxdpn7V+
 np63v3RJ
 Ua6iLbbA96jAjpgSTFpUo8fdaXltX8Xsohlx0hhp//pU9lgT2anG+eWl9gcuhL+P5BBPLe42ajkn0lP+2JEEm2jEh4ccNenA80cCT8Mrz4t+6H2TRyXfUoGKK5yRpnHlxO11YoW/9pjo+3Cwbz7zx43Kkqttx8g4Spw3O7cRbAwSq6AWg7g/xJXxVqTe9VC1k0G0kJv3/yYcdcIeYn2GXoojlcY/7j1DGNYvIyzk9c7Nq5BGC8WJGfDN90zkP53CkxSYkdr+GoUvMkUSpq4opO7wL2L78CObcAw4lNvL9lgx/HEWXZfpX8Vqi9fG5sc7I0m/9zRjOpwcFqdVk/cjS769nP/8ORZx02D5sHR+QJM6OpplEt6uRJoH4btFYzg+nB+gMkW/f8ra/kRqXxravQ/dyDmKftHjMveLIO8hOAypRcgIUZJFNoenk0LYZwSHTHoEh86IwH/AHOMqqpOchDDUiebCB4/vLX0k+JZiTMcDI3B+OOWh2obrbMsW0Umpq/dLxLFj888jKciFAi/wqsiOjUWxs7W58/qFNarOmYWz/xXyV5gD8T0CR9Kja3ynKUHJD6MqZlOfpL1+OWyk2HoLQLgL8d1ygnjAQq9zodo4EAk75qUQ4NJ+USdv2lQvSuaiS1A/LGfz3jtcLUTu8OXNL/pi8Trx3xtKYNLxNIag35Iti9rCRkakqBDHgwIlB9H6qx2qT1la+0mV/vE859fWYV7qkkoLuQC0yCMnNbouQ+WazpNCdJexpuAhqEotEWfj9U5RiUkrsmWj0paAItBSGJ6Q1vaLzsx5HgVc/78O4ehUiQ0cOLbKv5g==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 9/2/2025 5:48 AM, Kefeng Wang wrote:
[..]
> -
>   static inline bool subpool_is_free(struct hugepage_subpool *spool)
>   {
>   	if (spool->count)
> @@ -1472,43 +1462,20 @@ static int hstate_next_node_to_free(struct hstate *h, nodemask_t *nodes_allowed)
>   		nr_nodes--)
>   
>   #ifdef CONFIG_ARCH_HAS_GIGANTIC_PAGE
> -#ifdef CONFIG_CONTIG_ALLOC

Why do you remove the CONTIG_ALLOC config switch?
If it's not selected on x86, gigantic_pages_init() won't be invoked.

>   static struct folio *alloc_gigantic_folio(int order, gfp_t gfp_mask,
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
> -}
> +	if (hugetlb_cma_exclusive_alloc())
> +		return NULL;
>   
> -#else /* !CONFIG_CONTIG_ALLOC */
> -static struct folio *alloc_gigantic_folio(int order, gfp_t gfp_mask, int nid,
> -					  nodemask_t *nodemask)
> -{
> -	return NULL;
> +	return folio_alloc_frozen_gigantic(order, gfp_mask, nid, nodemask);
>   }
> -#endif /* CONFIG_CONTIG_ALLOC */
>   
>   #else /* !CONFIG_ARCH_HAS_GIGANTIC_PAGE */
The rest look okay.

thanks,
-jane


