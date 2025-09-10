Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CB99DCA101F
	for <linux-mm@archiver.kernel.org>; Wed, 10 Sep 2025 19:23:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A34D78E0002; Wed, 10 Sep 2025 15:23:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9E53C8E0001; Wed, 10 Sep 2025 15:23:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 886168E0002; Wed, 10 Sep 2025 15:23:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 708D18E0001
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 15:23:46 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 370F31601DA
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 19:23:46 +0000 (UTC)
X-FDA: 83874315252.18.7E3D5F8
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf14.hostedemail.com (Postfix) with ESMTP id AC57510000E
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 19:23:42 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=lqx08ZsJ;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=Tfizg0dS;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf14.hostedemail.com: domain of jane.chu@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=jane.chu@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757532222;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=S1+FupJE9b43YElVu5dyzlB/OecbnjbYuivoEDDzEvw=;
	b=qtmaeybA1u6pyqEcmbS7ZaxbuKqaA50tQqMsTuoC6Llmlb0mkmNxVHG5X19IeOF9y5xSAd
	a0Gc3gPcX8EMaBl80aiZWaomeSOKIRpfhNy//kjNAsTHa0pbbkoK7fMq+LhLEGX8JFUZLC
	uZzfbPxdbiTO2Mdloy5mU0wxslLSapI=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1757532222; a=rsa-sha256;
	cv=pass;
	b=C/6dBcHhyzLANHWwtV+WU97GMxbAgKPHKl8CUyyq4sb1zjiYalRWNIIsTURlGbiRONcx1M
	ExxTo5/HsSwEUK1aAbRT/yXtg2Y69NHb/DZCGxtFU0aqEIkSyurx9IwaTGY+TvnZ++ngMc
	vgys80OG/830BzdnG7+aZWxtnXzfVuc=
ARC-Authentication-Results: i=2;
	imf14.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=lqx08ZsJ;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=Tfizg0dS;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf14.hostedemail.com: domain of jane.chu@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=jane.chu@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 58AGfiI7005176;
	Wed, 10 Sep 2025 19:23:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=S1+FupJE9b43YElVu5dyzlB/OecbnjbYuivoEDDzEvw=; b=
	lqx08ZsJwziOoPRx+mc+7MGk3djRe0A+qgQYqVrgxH5ksWfa4VU3tQBHxovpySSt
	BFzldXSfn6JebIx6+hhHTWzFsayPAsNWNR8FGpTa4anyLVuqTrSklGQ4Hw5seWGo
	0h8bYrB4Mk2NUZIOZ9SFptZ5B/jrWWWg0TTX8agqRjKloiFvqI9ywDEiO1MMevNs
	8LXW+P6Ve+X7N7HPfk9R/6+365Qm/BtNWKyyQkTq7yKJlx59KnArT7gvPvcx3XA2
	nSNrSI/ZNmwB/QMXOzGGJ3MF0kZzsOGTU0r1uV7zl3BmFmnw3clabeRDmMmgfjHh
	bajET2+Gxnqp6fDql0Aj6Q==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 49226svvtc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 10 Sep 2025 19:23:33 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 58AIMBvO038972;
	Wed, 10 Sep 2025 19:23:33 GMT
Received: from ch4pr04cu002.outbound.protection.outlook.com (mail-northcentralusazon11013054.outbound.protection.outlook.com [40.107.201.54])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 490bdbewjw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 10 Sep 2025 19:23:33 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ERgyfPjYSTsL5SGEy6meUtNk6vZnMkYDs0sqajnj34rNxw5cAkgz5ojbq7qHTVVDQ7pM1p6s2Wc3meIxMf3GhGLD+aFAj49U1xKjOmnJqkcOr4WD/xH77MLbKLepFCuuL6uQ7a3bTLOcFA7JZhOeISdsxrswjjh2f2ZiGaETNyHaEevSQ1UpEiNSarOkJ6xSi/nnoobsPYfZmxeUjBPFkHqmU4YerFbdW2KE81wn8GCMv7dpBHq66vpg0hhi3u0LO71IO8gZ23qs1IBhkupxKyl9Z6gtkC8Pl+8RKMh6K1j3F6EQYTrH23lqghUeFQsZ3dy63K4Qe1288BhiPlBoIA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=S1+FupJE9b43YElVu5dyzlB/OecbnjbYuivoEDDzEvw=;
 b=BHB9aem9xlZ6NSe3gcKQKO1+vAfSOkpdubNiKJX4m07oaNAAxkYnPgvkCvxpeFr3uYG9xliVvUIZlMjKbLJiMID/2roamBuj4BkkK1d5m+5e6S2/d15Ou+93sOGj2pcyvqY6AGFGqsqIIaAA/JJMxmMRYsK57fo3ZT/7jH/lNTwGyWeHjfFFDF+zytol4j13LLRXw2v+LVrxOor41jVoddbtQ9Ps/gnmx6mYFQwVUJa7uMX2SxXQrz8dMJH+1jj31kIFqJv6aWMZHQGsXS+7I0ipF3DmZMHPK51DAL3A+HTKuMmCJE6ESYusi5qWiql/d+e8Yhj/DdTFe4/6Wx7gxA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=S1+FupJE9b43YElVu5dyzlB/OecbnjbYuivoEDDzEvw=;
 b=Tfizg0dS0Gj4jz3ZKO0D//cdwi6YWAaYF1FI2XbyMFYPcZkGDpK2foA6S8ihGf9Ka8vd58BOxu6Lb60OXykg48GGxfwvfrxNbSUyR4AlXczxyhxoJ1aKUg+sDRCg7g48RiXTfjWC5rxzwYya/9N8OBvR+krfnxVfRBELwbWvazw=
Received: from DS0PR10MB7364.namprd10.prod.outlook.com (2603:10b6:8:fe::6) by
 BLAPR10MB5010.namprd10.prod.outlook.com (2603:10b6:208:30d::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9094.22; Wed, 10 Sep
 2025 19:23:13 +0000
Received: from DS0PR10MB7364.namprd10.prod.outlook.com
 ([fe80::b7d7:9d3f:5bcb:1358]) by DS0PR10MB7364.namprd10.prod.outlook.com
 ([fe80::b7d7:9d3f:5bcb:1358%6]) with mapi id 15.20.9094.021; Wed, 10 Sep 2025
 19:23:13 +0000
Message-ID: <353473d2-c96c-4e17-9f0d-15b7fbbeb43c@oracle.com>
Date: Wed, 10 Sep 2025 12:23:08 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/hugetlb: fix copy_hugetlb_page_range() to use
 ->pt_share_count
To: Harry Yoo <harry.yoo@oracle.com>
Cc: osalvador@suse.de, liushixin2@huawei.com, muchun.song@linux.dev,
        david@redhat.com, akpm@linux-foundation.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, jannh@google.com
References: <20250909184357.569259-1-jane.chu@oracle.com>
 <aMDRAr1UP1Ix6zaY@hyeyoo>
Content-Language: en-US
From: jane.chu@oracle.com
In-Reply-To: <aMDRAr1UP1Ix6zaY@hyeyoo>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BN1PR12CA0030.namprd12.prod.outlook.com
 (2603:10b6:408:e1::35) To DS0PR10MB7364.namprd10.prod.outlook.com
 (2603:10b6:8:fe::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR10MB7364:EE_|BLAPR10MB5010:EE_
X-MS-Office365-Filtering-Correlation-Id: 73055010-4484-4bb5-5e35-08ddf09f7c07
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?VGFPZFdyb1ZwN1NTdWZDTEZxWmJrRzJCSG5wR0J1blIwK1VLRTFNVEszMkVx?=
 =?utf-8?B?S1ZKMlIxemJMcXBxaDNsQUpScnJMYWs5aTdsbEJ6VEEyaWRZMERudDdQNlhZ?=
 =?utf-8?B?cVVDSUxybTd3V21YdUovTXR1aWJnOTFlMnpQWVVkVEx0YjFyQWluR1RLSUhu?=
 =?utf-8?B?TDhmenI0c3I2aUdEejFHb05aZ2EyRTZRV0Z2QjZrcUN6MDdlNm5vdDh4ZjBK?=
 =?utf-8?B?MXhKbXpRY1FoRWhGMWZveFZRRkJqRDZtSmJqeERFZmRKWWRublJVNXRiSnI4?=
 =?utf-8?B?M253cGJnbnVZd2FJSnA5b244SDdBV01VdDVadkc0aFRmZmZHdUxvSGU3MnFP?=
 =?utf-8?B?eHpzbmNSTGpDMVlpVjRXb1pka21pS2ovdTVlSkNzWWFCM1BnMWo1cEl4TmFu?=
 =?utf-8?B?SWQ4RWdnK2ZvcEIxNHk2Um9pQndGdEgwbCsxUy9XWjFwRTJrSW1Ia25mWUU5?=
 =?utf-8?B?akZoVkN5WTZTb1BabnVHdE84NUZzUDRvblA5amYzVk5tUENOVmlHVkNOWlZK?=
 =?utf-8?B?TjA2RHBnTE9PVnQrcW1qN2ZsVzFsUmJ3Z0ZDajVKb2x6UW1jdm56ZXZoNDB5?=
 =?utf-8?B?TWdEQzY3S0xGL2dIeDZOQ3crcXhsa2ZCNmhLeXRERlNERXhVZnB2cm04b2p5?=
 =?utf-8?B?dFllNjkrU3R2c1lwRjNKRWdpc3NST3NEYXBzM29FWTh5SEd2a3FLbmJiVEtB?=
 =?utf-8?B?NE5kV1V3TndMcDd6UDBGNUg3eVRmZUJDS1c1UlNEN3JEb1JObWJVQmQydXJS?=
 =?utf-8?B?YUo0d0hOemg0T2dSMVphcnkybDBXOXoySlNkemtRMXg1alVrWndLQXJISVlC?=
 =?utf-8?B?cEdONUlzVzZLNlNBczlBRit6cHd2UGpBdmVVRnNidEJGZ2VSeW9PYnp6TVF2?=
 =?utf-8?B?aU5TcHFFT3c4SHEyLzNXb2ZMTm1HQmVVbTlLVVVlV3hDZFRsT0l0ZkJkTWVD?=
 =?utf-8?B?eDlkWll6RWJYWjg5MUJ5YnloeTVweC9GM1NGZkVyNWhWdWVkQXhHOTR6cXdu?=
 =?utf-8?B?WGdLa2dOUGdaMWR1bXloRHR2Q2hsbmJHUVpyb2pldjhoK0xLeFZidGtHMGRH?=
 =?utf-8?B?MWRiYThoSjA1bktPa25VMlJsYzEwU1B0RGZkajg0R2VjbFhyQkFyOXBvb1ln?=
 =?utf-8?B?ZXB2TzR0VG5RdllzR2F1bFM1Nm1YV2VQVVpYRVdtbkorbTYwUGlOLy93NG1G?=
 =?utf-8?B?WVdQV2s5ZkNVeHVHd0l1c1U1WG10YUErMXhjOC9ieFpRVldXTkVvVVYrTEt4?=
 =?utf-8?B?ZVJXOTFSdk44MUMxVzZSQVdXYnBFaU9pOTBjdnV5OEdacGN5aHBad3lGUmVr?=
 =?utf-8?B?dWIyOVoyRzd0NFpOQ3laQUlSRW5rc1lZYVFXUkNsWW96T1RCUTBrQmh1VE51?=
 =?utf-8?B?M2UyaHB3ZWVNRi90NHpqcS9tazhFZGJIYnJta3JJN3UwbmhYVTIvRzFJZGVs?=
 =?utf-8?B?VStHSTNuZjN4SmtQektXeFgvNXREem9vMHdjZWtIMGUzbm52SGRtZUJqNURB?=
 =?utf-8?B?RUkrM2RIZVNISENJZnp4a0RwRmhUbENSdTd5QmFSK0d6N2ovdmFXN01CQkpy?=
 =?utf-8?B?NE51SmFVQ1dHZ0JSR0NXSTU3SnNsbk5qTTNTQ3RqV1RRL0hPY3Rmc08xSlBE?=
 =?utf-8?B?VkVlZG1CczF6SStCMndZTitSb1ZKVHI4YkVUV3lybThycDByNGJyaGdlU0RW?=
 =?utf-8?B?Yzd6N1I1clJlTWl2c0hvcnlXN3I1aHVEZFZrbWxhYlVIa0Z3bXFpWmtnWnVO?=
 =?utf-8?B?VTRkMDhGOUVlMXNSUk5hbDFNU3hQTkI0azI4Rmg1clFFU3B4bUR2NWpoSTM3?=
 =?utf-8?B?bkFPQjNDb21KRXNtQkNXU2RrRGtjNFcraE0wOTgva0l6eHBOK3hFN1h1QTRl?=
 =?utf-8?B?M21MMU55RUZ2NDFxbjUzM2RsdnVqcEhySnZkL0RWOHljY2VndEw4aVhJN3pN?=
 =?utf-8?Q?ihMTpav0o3E=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR10MB7364.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?TUg5MmpRd1ZMWXdZaDhMTkpXdWtZTlQ2SXR1bEtQbHBEb1RzdllDQUthY284?=
 =?utf-8?B?OWpEdzRBYXEwTEpTK210cXViaGRKTjArYTlTanpEU2JPeTdUSDJJZ0czWHV1?=
 =?utf-8?B?WklNRzg1eUplY2ozdjN2bkdTeEhGc2hRK0hPQkNZL1NJOFZoNEdRVVI5KzVr?=
 =?utf-8?B?VWd3Y1NSQXNNVTRReWZIVlFoa2krL0VrcVc3V0Y2RElHeUlHZlc1MFQzTW5Y?=
 =?utf-8?B?bHZiNGZVMk9Qa0NpQ0xXNU1jbkwrNWR6RDRNTGg5YWN3TlIxNVUyOXlkVUJB?=
 =?utf-8?B?Tk9mN09wamd6bW1tQU15YUpTREpwSGNNSHBjRlhmYk4ydEtRdFhUeG5aMkps?=
 =?utf-8?B?WVo4ZFJJaVFlUURmOVgwL21xZzNWUlhtL2pWZk8zVjlSQm9iemVpRnQ3NFZm?=
 =?utf-8?B?QS8wVWp3VjVLL2o5MWE0VlJwUEVMVmZ4SHU3YWhOcmpRSXYzb0NjaHdoaC9j?=
 =?utf-8?B?YUZJV0t6L2xlMFlBeFpGRUpsTXhVVVlRbVdsY2NzL2M1d1QzRDU2S3R1ODR3?=
 =?utf-8?B?WHdCTXd0UFR0M0JIRzNpYTBFSTYvS001VnFhMEs2TlpLSU0vcHd1d1d6Q1Zu?=
 =?utf-8?B?S3lLZ0cyVmJBY3lKT3FEMUdlMUFXb3VkR1pVcHdNYVMwQ0poeXpuVkphTVV1?=
 =?utf-8?B?ODFtUnkybFoyZTZycEZWd2hYT09XVTZvdnpENVpKNTBtVVhRSHpCQnUrc3lK?=
 =?utf-8?B?UzZaN0hMTXJnL0V2R1FjdHp3TDgyVzZCcDlxNVAvNmZ2dUY4UzZKZ09DOWlv?=
 =?utf-8?B?OTZKQS91Tms1ZzZRV3RldnVHRkVwYzZOZVRtdHhZRlJ4VHdzMHI5cHRBS0VP?=
 =?utf-8?B?MCs0R3gzbEU5TzdLaE9YMUlldktyZ2oxaWwxcU1kcjc4ZUtIMjhjUFhFOFZu?=
 =?utf-8?B?MnU4Um1sREtjZ1J1OW5VM2pFaUhRYm1kclVjMzVIVnFFSjdyaUpvWkNtYnVv?=
 =?utf-8?B?cU54L0k5eERxZEtPT0xyR3pWbkpmRkJNVTlTNUorL0J6a29uWXFuRnFtRVkv?=
 =?utf-8?B?MGZUNGp4M0NIb09pS1FhTldXUFprMU5qaDk4S3VlVzZRS01LYnVLNi9TWk1w?=
 =?utf-8?B?UE1PcHZBemJRak5jcUFUUDEvWUJWaE13R3NFQ3NBOHNPUUJaSWdCMTAyL3Bi?=
 =?utf-8?B?amo1UVdWbHZOT1JsMEk3V2NTL3VsaERLTmVEakRrRTRxYmRrUFhDMmdzQWh5?=
 =?utf-8?B?VkJ2c3lFdG5aSENrTWQ2NnRGb1hmMzYxYnQrWHl1WmtNRWJCYlRhL1ZrNDFp?=
 =?utf-8?B?MUcyMTQ4ZWJKWEdsdUpnM0F5bmtQQi95RTYrSngwNjRWK0grNmlpR25SN25P?=
 =?utf-8?B?Zm9wL0dqYlduUTFWb09GSFQrQkY3SDBXQnk1dFVnUzZSUVhrQm1sekw4VlNm?=
 =?utf-8?B?WkYzdmtkenl0UXR3WUt0RjloZXR4SmJ4YWF3eS9LbjlWL3RJcmovUmpwWDlB?=
 =?utf-8?B?RE9NRHRzZ2JKaEVhNytOeWZwMnMrTWVCNHVEajZDTlZVZVFDRzFkOUxwcm1t?=
 =?utf-8?B?T3owOElTd1Fid2toOHN5dVh1aEpWczRaUnlKU3NsNm5VNEYxOHAyNzRMeW5j?=
 =?utf-8?B?bnhGSWNhVkluSDNCRDFmVEc1M2FQUUpOQjFSRjBIZTRyczk1ZGtaRnl2eWE5?=
 =?utf-8?B?QmdnTGJZaVJyaStaWEpJRDhaZXpSTjZTOGxkcnN2NVQzcUNDZU9ONGdxUzVr?=
 =?utf-8?B?U2w5b0pncDdWbWF3N25nbFFSS0JTcDUwMTVIZXduRGVpQmJwaTlqT3pzcFVS?=
 =?utf-8?B?U1crNE5zcGZrTjNrWHFEUTVBbUkvRkN0NWYzbjZsMGpVdzNPNkQ4SGpxNitl?=
 =?utf-8?B?Z2VWSnlUUmdDeFE5dlJYR05UbmtmY3RNN0RUSlkzYVAwUTJiNEFGY0FwdWJ2?=
 =?utf-8?B?S3FGeWltOW1hUTBST29EOVE2SlFRR0VRUUxNL2M1OE9KVFZCNTl1TjlHRENG?=
 =?utf-8?B?VnczUkUxMTlKUXJodktRVlFuc1RxNXQ2cU5Bd3JVNmVTTlhWNjFRcS8yclZM?=
 =?utf-8?B?Q1R1VDcvOWQrZndjdHZjbVBOcDBrQS82b3kwU1lDa2E2TzQzNWVGRWwzcnpj?=
 =?utf-8?B?dDMyRVpKUVozVjFMeDNWQll5MnhyZGZUaXZ6M0dNT05PSTVBNmUzbG81ZDJk?=
 =?utf-8?Q?ikS8wOD2YGVAjDCAWZRyCcK0E?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	hCBqoxl58xSw/BWzWO3NoZzNVpgIUZRah3UqoC35COsnqqj9DFlxe1W6yudfU05bc2ulqhrdZk7X+MIsr38JYkfZtXKq3XbWv3o+YIolFmJM5Weuax69N80MKZa+j279/+e22ZfhImAw493+D6xd04n1IAiFNEfIDSTDT3Bs+PBdKZXT3OUHyCYlZocazrcdJlwv9LkcjpdhsKvBf2xAUl0G/UMzTwf0BKY5RgP2oqRj4cmcr+lbI3i/0aw1GR+S/PPUM5D6vhzvUdMj3XEz4M1cxFn2ZJsZaSLSoguHpjua6arz6X7PrSvVpsc2FFNHReumkeneHHZVbhZcF2RabccopeLPAmO63Qpi8VPr9IJG0cuO18tbWG/1lk6K7XnPB7pt0r/L9mFbwpw8lPtMOftryL7lOnCcXncUtgQvZjsxf3q4kQB3v+/MgdEhgykbOBU2HbQzEZ6iGj5y1vn1lUfBc0XpC1c2VMOTh9s4OBdRAmFHx6fJR5cU9jHOnI2VvkciOKwnlEPw40aotMa2KoV5tbs3Gp8eCm+RONWOJ3O91m+HrbZ6rrKPGTqQbvWd7MGBNxhwRXFIKPK6Om0d5tqoLTeU5oMY7vrDIeHbXNo=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 73055010-4484-4bb5-5e35-08ddf09f7c07
X-MS-Exchange-CrossTenant-AuthSource: DS0PR10MB7364.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Sep 2025 19:23:12.9913
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /IIVjK4g6x74kOKPDGqvbuWQhcS3CmuwlzOvpW6UxloziiW7ODtcjafDmi9vGegiXrIQjos/9RdrKu+cGXP1EQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR10MB5010
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-10_04,2025-09-10_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 bulkscore=0 suspectscore=0
 mlxlogscore=999 adultscore=0 spamscore=0 phishscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2508110000
 definitions=main-2509100180
X-Authority-Analysis: v=2.4 cv=QeRmvtbv c=1 sm=1 tr=0 ts=68c1d036 b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=yJojWOMRYYMA:10 a=GoEa3M9JfhUA:10 a=yPCof4ZbAAAA:8 a=LDUv4jrXOagNp60WwwIA:9
 a=QEXdDO2ut3YA:10 cc=ntf awl=host:12083
X-Proofpoint-ORIG-GUID: PlEbVReHJ-82ALq-mY9efg5Rar6QxUiJ
X-Proofpoint-GUID: PlEbVReHJ-82ALq-mY9efg5Rar6QxUiJ
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTA4MDE1OCBTYWx0ZWRfX1jVFjQub3Us2
 SWMaUn4r58j0D3BNZWDDZcTGIHeGMkrzB13LbQq16NZhQ2yaWbiGGNANLD2i4hiEm9qZuNFoE+7
 +5qys9aR7t6QhJ2z8+HNofcbHH6RR5he7y0GQl7zb++Bl+MxyHXTN+oLwZPS0Av+FZAzm7nQFnh
 xK0f6EqJfSzP6nrXT1aIjTKEvQz/pSNwDIBDTav5cwxAdQpJZxU1F5YOCPGiv2yy9KF7TptN5vU
 xDwj5/HtGABF8QIcWC/RmHiXgjzdXihiJ7v3q0rGQk4DQtAbc5Sg+aCMJr00DnYBFG8HRmp9gEN
 WkkUtEXLKRo2ueNoYrKwpTDHFXCTyQGOs0UCYkXNwkprtqt+05NAIevZocsd/p2oMq6eGp7wdCx
 wI9BNLNDXAZMTJKaq8lFA/AePpG+vw==
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: AC57510000E
X-Stat-Signature: 9a53nfeeth737pnsamzeg7tryd8odm3x
X-Rspam-User: 
X-HE-Tag: 1757532222-14507
X-HE-Meta: U2FsdGVkX18J9AESwhaxqiOb9W0AchLfhJCibOokbOB7d38/1f4TiEHKR4gDcWbhCzUFXyqe6F5s+66pGiOvIt1kdpsJzpV2ez1C0ULQepBmZfjFdLgXkGoy7vDZ3pAG0KlZYPZe0YXHSd/BR0YuyPsGx2/iQFWRAGZH0TycvaEJHSTCrJ3nfHTsJUOs57Y5iR+7lOANSACva/qljQ710gp8/XsBON3xnjfCgQmrVfATz9LW3+WOrE0rD3/bSdJ+NQ20kr9/M8AwClVlqCtpjG91qRqfp8xvqnbTYiQgSvjchpuo67MYkerF7QFEZbMzzBB0RweWlE/gLg7Oan5hUfG8v3DdIvz9SSku2DVoUCnb9eT5WgokxR4OEj/FArejNOFYfDsWYGlqbsfeKwAGzYaDcjl35Q1jvuxhFwLBXBjQLPr7fpEPYbaAzJgf4MjipIsPWKGFDeNlhUgPirZrzPAqikShfn26CeoDdO0AaygY4veqOF74Fi4Nz57TtMy1xfMWKkYlcdoqvy5TdUfy2vkGnDkyyb4J4pl93/dThJKqwVDBac77jNKXMpKGt6j5loBG8yYNUcgZ6LKsMHiZ2/GnqaH/dalUGWFQ1xmPzUtRXxlOXzDK+6ndVFcs5RcppxyLcyeNcSaVOF0MIOi4E+o80l3gE6ghtVH4yrtSqwL/LCPU8EHk4tXOb+zvRfTQAxwr0cM//boFGSpnbQQKl1N5S3OkYWpU8vjLBB3t27J5jfhYEUdgzkq+5+zA6oB5tkpacFbyhU1883azvii7PhxTrLPBO/Q+tYuxHwIGAsA59l6+X96v8A8QWO8OibX/unOZx61bKiqWb8e876qSIaUyy0UXLfsuV2wLkWU0fDM9HoI1ggEtNESy0EPtSvm665bw40WELvYJPLN4k+FEpniqCfFZCIEJmh8O87s9QSZZOFG6bPD1SGckjUcWMqqXucZCOgM05/uPIbTPt3f
 zULRvPTv
 CQeOMoDxlQfn4Y0JcBwKbca3iBpyEjrARQD8J5gKzDIlHk+orSv5xTJEZYdl1gaz5hkhUzk+koMrXlzSeotHX3IPt7jtIlxIKoC0feSnhBpV/oOAthar7U3NtC3uPmushjAyC3e/MP6jFae76iIYUkioIw+iH+Gz2pVSmSal7PvUc2yerCjHpBoOoP0H37f3f22+plVMN8IH65T4YGwcCEd5afnIjE0I+5j2plV9zRTb2X4vxVCSx05zg0Rkp65ORioKHgsgRlSLcFOag5w9m5N9IhjCM3H/0GS5NFPUV6vdcAEUXVHruS8YRfNBaUnhLHU8rAKoWC0XQOUG14A2HrL5vlnQJ6sYsZXxItcl2xxS5nlKOdl3Bi16Leit4Ohyn4GCddxL9timdGsxd1TzMBgdDv8s2t66XfvwFRuk+UcvCm38qr/mD8AgHL8+rXFF0AUa+MwOt41QgkB6Q1tU9VlEg/m4BvgpfleYdqAMon8KFjKFCf7iizUqXa29eBUnFLhyDacIA1lxBvSKiczD9IvdWH6T+oVXIXGiNR0tUJ+lvub3eFDsM/vTyvNnVZGv0/2R+5lVGn8pb+0TQkmKdEB//+w2t1/FMMnABEUCUbZVQt97p2CNBrhrygybDyQ9o7aBunAHfRUdZR8Dwx69iunJRtEArXw9pU5u5BRCo3C1IxF3hXGBuMmOlJBBJcNQl+E4U72AC2x43yfUqAfNV49RiUyaJoEycVwpUNNFgBm/PwEunSAjV0/Ced+j1HSuqjylurDkAX71j535WHsVMUSACNt12eVwt0lt2jjOmnWpX1gjgTAbGokFuO+M0pLiSmi+a+UuF6pqJY2U=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 9/9/2025 6:14 PM, Harry Yoo wrote:
> On Tue, Sep 09, 2025 at 12:43:57PM -0600, Jane Chu wrote:
>> commit 59d9094df3d79 introduced ->pt_share_count dedicated to
> 
> nit: the format should be:
>    commit <sha1> ("summary")
> ?
> 
>> hugetlb PMD share count tracking, but omitted fixing
>> copy_hugetlb_page_range(), leaving the function relying on
>> page_count() for tracking that no longer works.
>>
>> When lazy page table copy for hugetlb is disabled (commit bcd51a3c679d),
> 
> same here.
> 
>> fork()'ing with hugetlb PMD sharing quickly lockup -
>>
>> [  239.446559] watchdog: BUG: soft lockup - CPU#75 stuck for 27s!
>> [  239.446611] RIP: 0010:native_queued_spin_lock_slowpath+0x7e/0x2e0
>> [  239.446631] Call Trace:
>> [  239.446633]  <TASK>
>> [  239.446636]  _raw_spin_lock+0x3f/0x60
>> [  239.446639]  copy_hugetlb_page_range+0x258/0xb50
>> [  239.446645]  copy_page_range+0x22b/0x2c0
>> [  239.446651]  dup_mmap+0x3e2/0x770
>> [  239.446654]  dup_mm.constprop.0+0x5e/0x230
>> [  239.446657]  copy_process+0xd17/0x1760
>> [  239.446660]  kernel_clone+0xc0/0x3e0
>> [  239.446661]  __do_sys_clone+0x65/0xa0
>> [  239.446664]  do_syscall_64+0x82/0x930
>> [  239.446668]  ? count_memcg_events+0xd2/0x190
>> [  239.446671]  ? syscall_trace_enter+0x14e/0x1f0
>> [  239.446676]  ? syscall_exit_work+0x118/0x150
>> [  239.446677]  ? arch_exit_to_user_mode_prepare.constprop.0+0x9/0xb0
>> [  239.446681]  ? clear_bhb_loop+0x30/0x80
>> [  239.446684]  ? clear_bhb_loop+0x30/0x80
>> [  239.446686]  entry_SYSCALL_64_after_hwframe+0x76/0x7e
>>
>> There are two options to resolve the potential latent issue:
>>    1. remove the PMD sharing awareness from copy_hugetlb_page_range(),
>>    2. fix it.
>> This patch opts for the second option.
>>
>> Fixes: 59d9094df3d79 ("mm: hugetlb: independent PMD page table shared
>> count")
> 
> nit: we don't add newline even when Fixes: tag is line is over 75 characters?
>   
>> Signed-off-by: Jane Chu <jane.chu@oracle.com>
>> ---
> 
> The change in general looks good to me,
> Reviewed-by: Harry Yoo <harry.yoo@oracle.com>
> 
> +Cc Jann Horn who backported the commit 59d9094df3d79.

Thanks Harry!  Will fix the commit message and send v2.>
> Elaborating a little bit why it doesn't need to be backported:
> TL;DR: One needs to backport commit 3aa4ed8040e15 to pre-v6.0 kernels,
> or revert commit bcd51a3c679d to trigger this.
> 
> commit 59d9094df3d79 ("mm: hugetlb: independent PMD page table shared count")
> is introduced in 6.13 and backported to 5.10.y, 5.15.y, 6.1.y, 6.6.y, 6.12.y.
> 
> As lazy page table copy is enabled in v6.0 by commit bcd51a3c679d
> ("hugetlb: lazy page table copies in fork()"), the bug is not triggered
> because shared hugetlb VMAs go through lazy page table copy logic
> (vma_needs_copy() returns false) or they can't share page tables
> (uffd_disable_huge_pmd_share() returns false).
> 
> They shouldn't have anon_vma, VM_PFNMAP, VM_MIXEDMAP and UFFD-WP VMA
> cannot share page tables - so either vma_needs_copy() return false, or
> page tables cannot be shared.
> 
> And before commit 3aa4ed8040e15 ("mm/hugetlb: make detecting shared pte
> more reliable") introduced in v6.1, copy_hugetlb_page_range() doesn't check
> refcount to determine whether the page table is shared.

Yes, it's the combination of
   v6.1: 3aa4ed8040e15 mm/hugetlb: make detecting shared pte more reliable
   v6.13: 59d9094df3d79 mm: hugetlb: independent PMD page table shared count
without
   v6.0: bcd51a3c679d hugetlb: lazy page table copies in fork()
that is problematic.

Since the problematic combination doesn't exist in any upstream release,
no need to backport.  The patch is for a potential latent bug.

thanks,
-jane
   >
>>   mm/hugetlb.c | 13 ++++---------
>>   1 file changed, 4 insertions(+), 9 deletions(-)
>>
>> diff --git a/mm/hugetlb.c b/mm/hugetlb.c
>> index 753f99b4c718..8ca5b4f7805f 100644
>> --- a/mm/hugetlb.c
>> +++ b/mm/hugetlb.c
>> @@ -5594,18 +5594,13 @@ int copy_hugetlb_page_range(struct mm_struct *dst, struct mm_struct *src,
>>   			break;
>>   		}
>>   
>> -		/*
>> -		 * If the pagetables are shared don't copy or take references.
>> -		 *
>> -		 * dst_pte == src_pte is the common case of src/dest sharing.
>> -		 * However, src could have 'unshared' and dst shares with
>> -		 * another vma. So page_count of ptep page is checked instead
>> -		 * to reliably determine whether pte is shared.
>> -		 */
>> -		if (page_count(virt_to_page(dst_pte)) > 1) {
>> +#ifdef CONFIG_HUGETLB_PMD_PAGE_TABLE_SHARING
>> +		/* If the pagetables are shared don't copy or take references. */
>> +		if (ptdesc_pmd_pts_count(virt_to_ptdesc(dst_pte)) > 0) {
>>   			addr |= last_addr_mask;
>>   			continue;
>>   		}
>> +#endif
>>   
>>   		dst_ptl = huge_pte_lock(h, dst, dst_pte);
>>   		src_ptl = huge_pte_lockptr(h, src, src_pte);
>> -- 
>> 2.43.5
>>
> 



