Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E08F6C83F1A
	for <linux-mm@archiver.kernel.org>; Thu, 24 Jul 2025 05:23:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 82E5C6B00D1; Thu, 24 Jul 2025 01:23:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7DED26B00D4; Thu, 24 Jul 2025 01:23:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6A61E6B00DA; Thu, 24 Jul 2025 01:23:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 53EE76B00D1
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 01:23:39 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 2B4E21A028E
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 05:23:39 +0000 (UTC)
X-FDA: 83698015758.23.1F95A7F
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf24.hostedemail.com (Postfix) with ESMTP id B365B18000C
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 05:23:35 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=QrI6TjdD;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=YCX8Gs1q;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf24.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1753334615; a=rsa-sha256;
	cv=pass;
	b=sQlkedokBU1l7oT0LOxo959HyQQWuuHKKn0k3SsHyD7neb8uDgpm1gIdqgHPYL0ddHruli
	3DskqkLeawMYRpq+AL7T8Vkv98kYcFf6EylBZduqlsydebIqYtETA06EzVaBlaQN8wgZM1
	OF6lVBd5OHeZTZQHjT/GNhVahFeVfgE=
ARC-Authentication-Results: i=2;
	imf24.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=QrI6TjdD;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=YCX8Gs1q;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf24.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753334615;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nIROHfRQulTXlvd60z/vEJ1BcNVuinMHdOBpUehdp84=;
	b=ia24o5qSe82+ITg3LqNF3xBvHi9KEdWRDCg+jcM3o36kQjmK9qrbW7ZPz3K6IFukVxw2ey
	S+4LYnAig8LhjaHWvz6C0MwTaOcvkhKFtw93de1pAUzDd0mPGPaP9+no1QA/Sefsgi0DDP
	rKQvUTtLCndwIauveIu2E9TP/RKV3CA=
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 56NLQs86026776;
	Thu, 24 Jul 2025 05:23:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=nIROHfRQulTXlvd60z/vEJ1BcNVuinMHdOBpUehdp84=; b=
	QrI6TjdDky2vmnWGBjPwwreJAUBj1Zl5lWPZiOy2fe2zgHyrW8lEFBJLppY/a8Cf
	fNUb8TFqI24sqFfpx2cXb/b6PK6tW0QHNNQ221EKojyAVqf/8Xp21zlHLqkFKk5W
	jCDtYE34zH1iqqADMsi9aOc/VqESmz85Dyh2pTU+z2vZYJgNBAB0pg1lPuYamCVu
	VmcJC7L9B5SE+lFyQcNGJqFhsYO/d6Qx7oGdCHwbTup2EHALj6NusAyyQ712XfyF
	svkfouEj5bhG/97TTZEsz6gDfBvlzstn0KdRcEGwdWWlzabYLQbgDo/hoXReu/m1
	m5l3N6OtTxFvfy8fp1DKWw==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 482cwhubgw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 24 Jul 2025 05:23:33 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 56O4M63V010263;
	Thu, 24 Jul 2025 05:23:32 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10on2084.outbound.protection.outlook.com [40.107.92.84])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4801tbdyn4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 24 Jul 2025 05:23:32 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=GzK+4fp8VVCBT2aqc7Xr1M+eM5obwQY6rGl/qTsKJDWvyV70w1QJK3eHSOHiKJXw1bmRohO6lNf3FloHYVRClNyn0Lu1XJGbmAoWgul0P8YvDO8Je1nW5+Aq+9WuMgwAPKk2ENpKUJHCBMGR86erIQI6YcgfAK3quol0iFwzv5S65+8J95H30yl1yqVqS1iY+IAAVbs8gdeIdAbMgo1Nh3t4V1LWg66Xldp9GSgXP5r4yI7ZmMS+0iF0qlH/9b+gM+Sm4sZ/yUptVLMm+AT8pLubcYM9DU1kjDNWdk1c8RK3Zz/fV2lP9e9+Qq9Uo3PUetz3nfqC/+6Fv2YG1e4c1Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nIROHfRQulTXlvd60z/vEJ1BcNVuinMHdOBpUehdp84=;
 b=wxIueuUC6cqiAkoFvWlh+ithAe+rRnv7MEQYQ3AGOFA3cjnGJgoJgx63baYXG4JZQgM6eNz9UoPSJZNn84PZagOnBfHk3WjfueetDi0CJbGTzCdY/qGOML7VsglHqBwA4yRWTiRMUJ+ab977XEoLxAqrHFIMDJqwoQ7SUyT93m0VjiJq4fULTiGXu0rwneJxce9LbkEsNJVdNWomsoe4mN8NxhFMJf+JE7S15AtM6Q77Ryin6KfmljEPePrguEt4+Ql1NkrslUaahpweWYObNT6I6QrYWuodDh5KDWNMRzyD7PMAYCmq8rpNtaO+OCH1f6J3aIBl/n6ERRy+0x6Vfw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nIROHfRQulTXlvd60z/vEJ1BcNVuinMHdOBpUehdp84=;
 b=YCX8Gs1qwhaeDXh0cC2I+Fe9ZUjlsiuRnxEp9W/n7sjvEFCsJU+ad/5fmGVDHj+1v2XoC0NVdrDMoT8xW23ACkrk7gIRBfvDM95RC0dYXgGruL4pXDp2qdpHRS19ZF957WW74eImCwxHqrxa8yTePqaWGERxSiNd+xSyVbLSphw=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by CH0PR10MB4908.namprd10.prod.outlook.com (2603:10b6:610:cb::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8964.21; Thu, 24 Jul
 2025 05:23:29 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%5]) with mapi id 15.20.8964.019; Thu, 24 Jul 2025
 05:23:29 +0000
Date: Thu, 24 Jul 2025 06:23:26 +0100
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Jann Horn <jannh@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Liam R. Howlett" <Liam.Howlett@oracle.com>,
        Suren Baghdasaryan <surenb@google.com>,
        Pedro Falcato <pfalcato@suse.de>, Linux-MM <linux-mm@kvack.org>,
        kernel list <linux-kernel@vger.kernel.org>
Subject: Re: [BUG] hard-to-hit mm_struct UAF due to insufficiently careful
 vma_refcount_put() wrt SLAB_TYPESAFE_BY_RCU
Message-ID: <ceeb423c-ce98-4ef8-9dbb-24522f88de43@lucifer.local>
References: <CAG48ez0-deFbVH=E3jbkWx=X3uVbd8nWeo6kbJPQ0KoUD+m2tA@mail.gmail.com>
 <16c97e30-19c9-41e8-b73b-c0b3c8eceff3@suse.cz>
 <CAG48ez1qhjQNHC+3572udqVWHTANFpQ0ngxn_4ZDC9F8NCXsFA@mail.gmail.com>
 <c53b22c3-9f7f-4793-9d10-f4df861a3e32@suse.cz>
 <CAG48ez2cGX3e5bqgcw0OEnho29+YhwG2eOrHRgNwGAA_Nb65nw@mail.gmail.com>
 <28e1fc65-995c-4185-b5c2-7eb001312698@lucifer.local>
 <CAG48ez0KE9bfFJ+yAMPUAj=_hcNRfes3=nfQd7Rv95TSnHtUCg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAG48ez0KE9bfFJ+yAMPUAj=_hcNRfes3=nfQd7Rv95TSnHtUCg@mail.gmail.com>
X-ClientProxiedBy: LO4P123CA0316.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:197::15) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|CH0PR10MB4908:EE_
X-MS-Office365-Filtering-Correlation-Id: 3356f49f-a2c3-44bc-56e6-08ddca72396a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?WE9PRXkwSlF2QitzaHZwRzIwNU0wZ0FqZjd2WjRkMTgzRGU5V1pTcWxEMHhR?=
 =?utf-8?B?T1E0VldOVS9NMExmSlFLTUNaQVlTZU1zQzVzeFVzYmViNXR6NkhLWXNDQWV2?=
 =?utf-8?B?WVI1Vzk3MWlrWkpvb0VMWUNxRmFQTGI5RkYvOXhVdjRlcmVhS3VKRjlvQllK?=
 =?utf-8?B?ZW5xS3ZNb3p0dFJjM0k3NW5DKzJQWHpnc1NsWk9YcEcvQmQ2Sml4TnlLb01S?=
 =?utf-8?B?eklaL0J4WkNENkNhK0p5REpBRVdsd0FPMjRRU2oxQlMyM0hnWjJ0aTRhdk1l?=
 =?utf-8?B?UUFnL0tJSXllZHJLQ3FUV3gxblJuL0hoV0pTREUvTjMzZk9xb1RtVENnN0hk?=
 =?utf-8?B?MmtocGhEak5NSVVub2lXTnBZdzJCN3VqMU5taU9zM2l0YnFZaXdwK0hSRlB4?=
 =?utf-8?B?dEExRFlacTMyOEsrb2djSWV3ekMveUdOZW0zTnRkTG5Hdk5ZdE1NNS9LK21I?=
 =?utf-8?B?QmdLRkJ2cFBGR0p1dzVWYmJMdllNbXVvemRDcmdUa3FaRmpoaXJlbEhJcFAx?=
 =?utf-8?B?VFk0RTY4MmppRlpvT25RRWo0aCtOWjVURWlMQ3l2YnZGd3FSOTlQU01XL24z?=
 =?utf-8?B?WkZJcFI4a1RHZDBBcmJKeTl3dWl0aHFERytTK1VaL2lmZDI5UHlKR3pGWmN1?=
 =?utf-8?B?cnRSWjZnb3NCMTFXamc2cTdERE82K3dEUjdHdDdodUtHNnVRRElIZHNpVVRi?=
 =?utf-8?B?SGozUEQwTG9SOWJpYTlZQ01YNnJoYUZWcVM0Y1lWTHBGMm1HMmpyWWpNZ2Vh?=
 =?utf-8?B?N0dzUmRocGxKY2RBRjdKVm94RWdWK21sLzRQOWg1Ri96SWFITVlPeDc2ZVE1?=
 =?utf-8?B?TFN0TXpqQXFhTXhsRFBTSG9ZNmt1aUVSTXhINUJ4ZCtPV3NXeTlpSkVrRVNY?=
 =?utf-8?B?bDVtT3NKQUFmTDVvQjlWL2pTSFowOHZGcjE4R3pnYncxQ0hjQnpCd0pieGdm?=
 =?utf-8?B?aEFVZ1lxdi9hRWhpZ1A2UlI3dFQ5Q3hBeWFtdW9OVm83Skg0YUdUWGtNOVRt?=
 =?utf-8?B?MHhuNEdSc1hUUkt0VzZYT0lmSkFQWG9SMk13L2tOL0t5S0hhNVJlYVllTkpp?=
 =?utf-8?B?MGRjTTlSYlhFcjh5RWZmNDdWakNwRS9yZnp3YXdXc1ArV0dINnZyVU11UTJE?=
 =?utf-8?B?c3hqWDErNEVqOGZENFdSSXNwSG82R1hPSVRNZTFpdjNpVDZlanI2MFFjQVFo?=
 =?utf-8?B?VlV0d2kvbVJscU1JWWpqWHhMbkd6cHloV2VVc04zYmxsOVBsK2N4NGxGTjdr?=
 =?utf-8?B?Ky9oQ3lMRW5URzlwL3VjRkZoVmhCTTlXQ2ZEMWd4bG1WK1Y0M1BiRjl6amkx?=
 =?utf-8?B?anJiQWxNTHdIV3BITzZCeE55di9NU3NVVmtZMTF3WDA5Rjd3ZTBCU255ZC95?=
 =?utf-8?B?UEhKcnFPd09KeDU4MGdtNm5Ic0ZZTzBJM1E0bzJTd3RKRnpYL1FIUnN3MTNC?=
 =?utf-8?B?dlZYN0w0YTdHcXhCRTl4Z05MTEF4bTBvQVlyNGdGRWdiRXJ3UlNndmxkbmpH?=
 =?utf-8?B?MUZGRmEvenAzenV1YlBidnNVYnU1THM3VXRra1VpYXF5SzdBWVZhUTZncC92?=
 =?utf-8?B?UVE5cC9HdGtsVDhFTU1CL0tibDkxQzFQUnFsMzJUdlc0dFBFY09NZWFSQ0x3?=
 =?utf-8?B?cGJrU01yZnVldmozbmJrRDRROG5KQ1dGUnl6R0liZ1FFUldkYzhtVVp0YVpj?=
 =?utf-8?B?RzBZb251d2Vhblc1UlhrZXltdksrcmVRbHN6clpueS9tZ0wzWmJwaUd6Z1lD?=
 =?utf-8?B?NTJPQm80djdNcEYxSEdJRzBMdGxsVHp1TzZoTXo4L1l6WjRaNnlES2Q0b3VY?=
 =?utf-8?B?SldFZTI3MXoyelBidTc5UDVSM3V5ejlFYXR6TU82WjZ2M0xlbjdRZGpGOVVo?=
 =?utf-8?B?TkdrL3ZpWWZVWFlvY2lvTjJqOVdEOCszL2tvSi9wYnRWakR5VThrZ2dPZzVj?=
 =?utf-8?Q?TChy1CS7WWo=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?aEZrQWR4dTVyUFRDUjNSWC9YMlhQYnZnclhhWjFyb3p6dmp4bkhzTGdSQi80?=
 =?utf-8?B?WFkvMXVpRGtDdkY4eFRuMEFWV0lERk95TzNHK2xoaHhLbC9yeXE3ZEpXM1JK?=
 =?utf-8?B?MnBGWDg5ZjNHTXAzQzU3WTAyeCtFOVJQZiszTzVJMWt3ak1BbzhjNjFGSlF5?=
 =?utf-8?B?RjMvMkdUakJHckgxb1JkZ1V4ZS9lTHY4QUVyUVFzUlFSMVF4a2oxamQ4ZWpo?=
 =?utf-8?B?VVZpRTU5eG03OG5NUlhVTDNTMTZGdVNid0czMGNyWjd1c2YzdjViQzlQUjBI?=
 =?utf-8?B?MmRybmhMVmVQSTVLaEFYWlNwc2ZHMWlXWGd4Y2FaMXd4Vk55NGdwcllFYVA5?=
 =?utf-8?B?cXpSeHc3bExBMmVKRVNNQUdSUk4rQmV3VmMrQVRMbE0yWUZLdmNlTjdwblNF?=
 =?utf-8?B?QXRzN0F2MHBSL1pRTjZpWjJ1UXF5YlZkNDFpNTh1OFVPK0JoNWhvY1ZlY3dQ?=
 =?utf-8?B?bklaN2gxc0dhYUhrZjBXK0hZWjFXUVh1WkVpQSs4ZVBwQ3laSkdiK1lpVkVi?=
 =?utf-8?B?QVYwVDF6WDF2QXIxS3BpLzcwMkEzZHd4c3FDUGJobWI3T1dUL3pYVnpUY0hT?=
 =?utf-8?B?L2xaOU5GWHBRNy94U0Fwc1VQQmRydDRvSThmQ3pJTFkyZTZBWTFoUDB3VnlU?=
 =?utf-8?B?VTRUOW1vUGhXMkVJenRxbnZ5VGVVcENyajBXUE1HajlrMkMwREZ2L1U4VGlM?=
 =?utf-8?B?MTJ1UGtlcnl2aVNSZ2hrSmNXNFM3YytpNUtySXpPN2VXRC9zNHVyQlNnUDQ2?=
 =?utf-8?B?N0dmRVNnS2V5Skw5YTJDb0haazQ4SzZBQkJPbkdtRk9QU3dUcGhNOHYrMzBB?=
 =?utf-8?B?Mi95VlU5TWxKbnliaWZ3dmJEN2Z3b2VIM25QZHBHZHBUNlIzZlhialZhSGtq?=
 =?utf-8?B?RWNpcmpnVlNwSmZ0VXdXdlR1WDltRmY5Z3h6WnN1SWpLWVBoeCs2VDNVZVo5?=
 =?utf-8?B?NFROYlZoa1Q5VlpoNUNySFRlWWxBWnRQQ21pRlBHZU83a3JvSFFEb0I2Qnk2?=
 =?utf-8?B?cG44Y0hqdWxsNkxPZE8zanJMTFRDSytvNU4rRzA3Ly8rVTJFZFhZakdCTFNP?=
 =?utf-8?B?Y2RQbWViRTNOcFlFeW1FWG8rUk1EbEFwZmt3emVOaUtmakJ5V0xKWklQVWhw?=
 =?utf-8?B?SFBTZUtPYmlPT2lFYXo3YlhTRktsRzNYWUVVM3Q1ODBuVXdDNGFnclBidzlx?=
 =?utf-8?B?ZUc5eHJVUG5hcW5mNFh1VWlwNmc0UEovcGUvSUEweHI4YzNaTFNpRnZrdjd4?=
 =?utf-8?B?ZkM4UG5KQjVhOHoycGxYMkFkcmpCMW5EbWQwZGdkeVlvcEN6T0dERllvdlhB?=
 =?utf-8?B?ZXBhSmJyVzBjU0Z3K01IVWd1UU1VM1YrQ3dnOVRiYm82Mm93UnlnZm5YbVA4?=
 =?utf-8?B?MmZqbDYzTTBJTzRtRUV6UjhUc2Q3MTBjQkZTMzlML2VIdWw3YVpPL2tCVE5q?=
 =?utf-8?B?VHNGY2Q0bGx0MGh0b2o4eHZKZjF3bEhPZnIxeVRONVVqK2NrSWQzSk40dWZy?=
 =?utf-8?B?U2dTZjNtaGpsdFc5WEZjWmN5Vzl2ejNFL3FqNTMwRFhDVUJyWktaL2xXSUdk?=
 =?utf-8?B?OTdJTzZqZktLSHlscm0zeDNXOWdwTzEwbWg0aC9NME94Rm5XYWVNZGZGWDEx?=
 =?utf-8?B?cm1tR3lkbXQ0MEN5NzQra21NYnVDQ0VleStMTWRDRTFzOFlxbFduNlZlQ3FV?=
 =?utf-8?B?UUc4ZytnVlBlTUdGemlReWxJdlM1L2Nxb3Fia0dUWDlLZnlwbTdnZ2hHNm50?=
 =?utf-8?B?Q3NOLzJEUVV1WGhmMENvU0dPVVhEblNsVmZLR2l6alBRdzNPWmtQRnRJdnVW?=
 =?utf-8?B?NlZSclljbi82cVEvWC9haTUxUUQ3cDBMaEtqS1BXZi8yeWhHY29BbzZDWDFm?=
 =?utf-8?B?SkxLUlhTZENqbzNKaFV5TUIvTXQvV1BJdjcrM0dYemYwbGpnc2Z3cGJEKzMz?=
 =?utf-8?B?Lzg1ditlM3cwQ0RvTy9RK3hMM0R3d3hkNTh2SFFwWWVldEVHeUp6elZNTys3?=
 =?utf-8?B?MVYxNjcyeXpkRWJEOTVXZHowU2gvOE93YTJncUYvTjRFdXQrTDRqNFNnbFdU?=
 =?utf-8?B?aVVWM0tDeUUza21OZ1lka2hhZzhpbjVZdnhQaFhhNDJMZ1phK2hZVllYd2RE?=
 =?utf-8?B?ekxRSkYvcEFyZWEydjVEVVp2VmQwV1hEZ29rNHg3b3dOQ2VoVTlZV3BjNUNk?=
 =?utf-8?B?VFE9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	etVuYQDK+FnTUN6BfVM2ybuMF5bfwkVGeAdbgWjWqqIE5SE1Tc0WhEOnkVaE5P8BUSc+3bDos1Vaot1eTbvpBXkMXTMIUks3YvQ6n4NkZQKiyBD+WkKoz1j9hPhCHN+C6kSq3B3nc1IpipdCKARYT27QAl4LM8NaJAxLCLmyWY2cSE4wlht+DUAD2T3oCfITB0bieHgcojAMO6DfMqXC7qX5meu0kqOnke5AiC2iWNjUYkOrLLeVuk0im+ANv342/8a1+nal+XsNjg3nIPSjzEKFvTmDDWwPRjRxqdDZjtkCN1+6yLoCKhsSGft9Iu3HC8ANf1jEfTL6dl2zLAVM7LKJfhFqZJwBeMrRosVmtgI7HUj9fe5U2AzzBaRytCbc23SprXY5uBoiGboaYSF0Fr7nZU7UG2QmSQV9XbderWPyLJ2DvyL/J7Hbf+g5QXtQiGy3gQm/eObM2kpZ0Ikz+E9D6wrRlfrKdZ4qQ+dNRz2WvJwi0+baasRbOrrSnwyIxNHmX2SY76sV+Dbi/VFF+UAvI5DH227nz5ryhS87aIM9TPOtPkO3th3s0eawX+k9HohsNGe6aBOZT/5UFDzQV1pu1RS1nzRqh8RCrX0U1DQ=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3356f49f-a2c3-44bc-56e6-08ddca72396a
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jul 2025 05:23:29.5767
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +lDpkBQPJQ9cWbZ8LorQFCJpdIjh+EqcrVSmpa90TQ+kdrE694FuwCB/tnlUn2kzoWuMRb6h2SkkaF+CxS3iVFu/DBZwgjpN1hS/nc34/k4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB4908
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-07-23_03,2025-07-23_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 spamscore=0 phishscore=0
 mlxscore=0 bulkscore=0 mlxlogscore=999 suspectscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2505160000
 definitions=main-2507240033
X-Proofpoint-GUID: sG0mvT07AXZY6mnqB4t8tqSIATHP24vq
X-Proofpoint-ORIG-GUID: sG0mvT07AXZY6mnqB4t8tqSIATHP24vq
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNzI0MDAzMyBTYWx0ZWRfXy7YzUt7P7TAE
 5pF1/VYHqjchQg8ax7UuxbmVzd6pMjFdxnz+XeLGbYTuvLaXlL5oaukfNiOMaF17RJHGYa9QKq0
 dBO+0wq9CHzHiJG8Wij+F75l+YYAcV5fjGR47QBh2zc7x41rQb0iNc/aQkWiDIlhYQPGgs5tq/w
 JvdBnFW2zhinjaqoko/u0fJleaRBPqQCnD4NkenmLw51gJ0M3hXSSvuV6VXx4gqAzWJ2XuG8+yX
 fyse56fdRHFjSPDvcR1AZuJkgheJtnaulgDIS2kMq+SoirXHVLU+ZBfhlvOp5NjIHq7EK0bkW8h
 uhPleMyGDyvNyHyXsNSIKw6QKJ7hbGajm4PCkhEWBxycMd4nX/lnOhua9OBbKyKS1OL3zO6IdW2
 6+yzaeBmKKtSiEMZcXy3l/k67kSp3+j3g1Ij7tlr67/ZRjTlPuuHO9YhphIRoVZZ8J7hNwTu
X-Authority-Analysis: v=2.4 cv=IPoCChvG c=1 sm=1 tr=0 ts=6881c355 cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19
 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19
 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10 a=Wb1JkmetP80A:10 a=GoEa3M9JfhUA:10
 a=yPCof4ZbAAAA:8 a=x6WcSezCFkcEtlJfkooA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
X-Rspamd-Queue-Id: B365B18000C
X-Stat-Signature: tkg4y7q3x6d99ebpj8ko63zcontgwny9
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1753334615-452356
X-HE-Meta: U2FsdGVkX18/uPaGn0Us8bf5zvYGlDwl/x5/m4RKd1J0uT5t67wEXhDUzzKJGM4DGjmTpQRPoksAwWxl33kEuj3k4XC3vxMoyW/XrNYTaS2ejXRBRNI9nEPekgwnSGF9q2AwTGm3dpE2iN3yj7D5Tucqz754C/ymdFD6DPW2oVKVL76at++qL/vvKQLwR00NzKUwToiTpWGbHT8kp8CaGAUf5xx6ide6zEzvhdb3tvN2PTGFmzIP4PJbkt408/Uw1HH6V+maCbKWAyWOlNrah70xgH7H4Rjwqk+s1QXTWH7B9LuO/+Da22ZlDJspQWqthJ+Yk6PYDR9/tBhvF7w3YeyQ1qRODr7lQfJjUvTc127LCpDlyndTbI8+W9CrNh7Ql+AKurXTrTmROFCP5Zyb7aMYuvFQjCOmpUJRw5JJucwwIV6aIfiMTOn55P5YIr+zzQYuSTrIyzpZ+ih0JZ9WXs33l5kHwCMvUB2KwrzIjYMLABMpdyaMXht1vwF2cMUUZaQSlZPJ+guGtZ/X/xd7lZUqLwcOYA/24cuofd/uYnIM2j99i8eN1qSRKVQkdetklL5y1fMZi3PKkZ9n1ITg5JXkXPgAs1zxJVNKFCNrivxKPlLXZfwPKu0clKF7Pota1jIu0gydYy4hZmf/q2fLoT8rT4F1Msp8cGW2WEpMiIRN6CTetGuObU39ypXtojfG2+oLi24LrxprLo4g49j/xz+nHp/+QSfIKFgbvV2VEPUciu9h/uL6xOrYCVtA1y6UsttG7c3GfO65D6EsNY/W75VkpT7gjAnmBGFTxWFQi31kHpH474QWX3KnSZVatpfzw3sly3qdAyO/8RIIVQxaWqzblaldDnxxdQ4BF5KEMuugxnY0rEPMSh/Tefcxn/Rdw1h4XWziJZgPLU2u280kjfInam0cZ+TIg+l5r7PKiIq2Tp0csHxiz5wqEakHQJ5eeOBe2JR3fG6/q9JhWON
 xx2O78ZE
 gdgSCBsw4r5eSUywSGwWZh/qzirX6Sy1VksS6VF0PTxnlcby/mwO+dSD9xHEehbvBKaeP0OUPjOzY3VVxdM+KrKNIJBR89ZjsqwayvSxEXgDdrAKdpQPfQuDnY+R3ea0yMVXTihc2IJ4e5LEDSiN+8NKR+UjYQNpg+kKa/wC3ILadvYoQTKR9DeXpzGmmPdTHJt3TGXQDGFi8n4+2fNl86NM2U+MKsv7v03pLmpojEEVDsZN41wZJ5Ex9OA/2Jsd5uCgaoJv3fPkXew8Lwa43o/pAgyde9ji/OuhxEt05Yi3MyzqW7/pqaDy/GJBXaITuD3jSNz8NsAROhZks3jItyqipCY6ND+YYbWKYZ9pH7BaM6NWPlGGTmfHOEKZ17URz4iOKxsenkiY0fpIzV9AavlN33cvFH1FwfzYKiDtQm0BgOEufXJyqc0xWW3r3ujzkAnlKPTV2daQiJjdS63NGobFZtdCG4cUaN/cucZSeSUDRgpskLO+c7xs37WZO11Ti9Kb2FXhw68Qi1mju2rofbaV3HD4xQxvs3Q34QxaS/4uWScQDgpHx8RRgIWG6Wo3aWgyWjb3ewbDsLONFFassi8iv5gVBc9bX/Xo8SGKhyxl2TIBPKM89UAEkA6e11JWAzYzRrn5ZaBMMrAh+dfY7K3V/u82K+9WuVRVvHjNqPY+w2AbPn0gX/TaU+vwaDfitR/5x3tNV/qO2/5EoAWxhg6Y8qJHDlU1YXLY4
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jul 23, 2025 at 09:52:41PM +0200, Jann Horn wrote:
> On Wed, Jul 23, 2025 at 8:39 PM Lorenzo Stoakes
> <lorenzo.stoakes@oracle.com> wrote:
> > On Wed, Jul 23, 2025 at 08:19:09PM +0200, Jann Horn wrote:
> > > On Wed, Jul 23, 2025 at 8:10 PM Vlastimil Babka <vbabka@suse.cz> wrote:
> > > > On 7/23/25 19:49, Jann Horn wrote:
> > > > > On Wed, Jul 23, 2025 at 7:32 PM Vlastimil Babka <vbabka@suse.cz> wrote:
> > > > >> On 7/23/25 18:26, Jann Horn wrote:
> > > > >> > There's a racy UAF in `vma_refcount_put()` when called on the
> > > > >> > `lock_vma_under_rcu()` path because `SLAB_TYPESAFE_BY_RCU` is used
> > > > >> > without sufficient protection against concurrent object reuse:
> > > > >>
> > > > >> Oof.
> > > > >>
> > > > >> > I'm not sure what the right fix is; I guess one approach would be to
> > > > >> > have a special version of vma_refcount_put() for cases where the VMA
> > > > >> > has been recycled by another MM that grabs an extra reference to the
> > > > >> > MM? But then dropping a reference to the MM afterwards might be a bit
> > > > >> > annoying and might require something like mmdrop_async()...
> > > > >>
> > > > >> Would we need mmdrop_async()? Isn't this the case for mmget_not_zero() and
> > > > >> mmput_async()?
> > > > >
> > > > > Now I'm not sure anymore if either of those approaches would work,
> > > > > because they rely on the task that's removing the VMA to wait until we
> > > > > do __refcount_dec_and_test() before deleting the MM... but I don't
> > > > > think we have any such guarantee...
> > > >
> > > > I think it would be waiting in exit_mmap->vma_mark_detached(), but then
> > > > AFAIU you're right and we'd really need to work with mmgrab/mmdrop because
> > > > at that point the  mmget_not_zero() would already be failing...
> > >
> > > Ah, I see! vma_mark_detached() drops its reference, then does
> > > __vma_enter_locked() to bump the refcount by VMA_LOCK_OFFSET again
> > > (after which the reader path can't acquire it anymore), then waits
> > > until the refcount drops to VMA_LOCK_OFFSET, and then decrements it
> > > down to 0 from there. Makes sense.
> >
> > Sorry, this is really my fault because I didn't closely follow the
> > reimplementation of the VMA locks closely enough and so am a little behind
> > here (I'll fix this, probably by documenting them fully in the relevant doc
> > page).
> >
> > So forgive me if I"m asking stupid questions.
> >
> > What exactly is the issue with the waiter not being triggered?
> >
> > I see in vma_mark_detached():
> >
> >         /*
> >          * We are the only writer, so no need to use vma_refcount_put().
> >          * The condition below is unlikely because the vma has been already
> >          * write-locked and readers can increment vm_refcnt only temporarily
> >          * before they check vm_lock_seq, realize the vma is locked and drop
> >          * back the vm_refcnt. That is a narrow window for observing a raised
> >          * vm_refcnt.
> >          */
> >
> > So, if this is happening at the point of the unmap, and we're unlucky enough to
> > have some readers have spuriously incremented the refcnt before they check
> > vm_lock_seq, we trigger __vma_enter_locked() and wait on other VMAs to
> > vma_refcount_put() to wake it up vai rcuwait_wake_up() if the refcount is still
> > raised (which it should be right?)
>
> I'm not sure if I'm understanding you correctly; but yes,
> __vma_enter_locked() waits for all the waiters to drop their
> "refcounts". (It's not really a refcount, you can also think of it as
> a sleepable read-write lock where the low bits are the number of
> readers.)

Yes I understand this bit.

>
> > So actually are we going to be left with readers sat around waiting forever? If
> > the scenario mentioned happens?
>
> I'm not sure I understand the question. Readers don't wait, they bail
> out if they hit contention and retry with the mmap lock. As far as VMA
> locks are concerned, readers basically always trylock, only writers
> can wait.

No I understand that bit, I'm not putting this clearly. I meant to say
__vma_enter_locked() rcuwait_wait_event()'s until:

refcount_read(&vma->vm_refcnt) == tgt_refcnt

But it won't be the reader will it... it'll be the writer, waiting for any
readers that obtained a spurious refcount to drop it.

>
> > If we make the rando mm we are now referencing stick around, aren't we just
> > spuriously triggering this thing while potentially leaving actual waiters
> > waiting?
>
> In that case, the thing we've read-locked is not part of the MM we
> were trying to operate on, it is part of the rando other VM, so the
> writers we've blocked are also part of the rando other VM, and so the
> rando other VM is where we have to do a wakeup.

I am glad you perpetuated my use of 'rando' :P

And yes this is the crux of what I found confusing as mentioned in other thread,
so it's this rando other mm we need to keep around...

