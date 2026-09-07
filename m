Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6DA13C79F9E
	for <linux-mm@archiver.kernel.org>; Mon,  7 Sep 2026 20:40:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D027B6B008A; Mon,  7 Sep 2026 16:40:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CB3116B008C; Mon,  7 Sep 2026 16:40:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B797B6B0092; Mon,  7 Sep 2026 16:40:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 89D8C6B008A
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 16:40:05 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 15E2940282
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 20:40:05 +0000 (UTC)
X-FDA: 85188133170.21.E791B65
Received: from CH5PR02CU005.outbound.protection.outlook.com (mail-northcentralusazon11012059.outbound.protection.outlook.com [40.107.200.59])
	by imf27.hostedemail.com (Postfix) with ESMTP id 3AF454000E
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 20:40:02 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=O5p0wWne;
	spf=pass (imf27.hostedemail.com: domain of ziy@nvidia.com designates 40.107.200.59 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788813602;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DKzlxilrUr4wkycbg3QAT/2kAv9xzMtxsPK7rQZGL7g=;
	b=DLstA2F6FcL8xam6v6i38YpUOjK7Xw1ge14e/6uC7aDtkRbIr96EVKlZUb/A9moYWEoe3x
	QHLkAey5KgiXJnFvpPC9pqHpqz8EVktHnHhgOQ6vqF7sUBfM/hEfseV6YFm2H7rEJsI8Ly
	DltnXKicRDPo/vP+lsZjZUTndjcd/bY=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1788813602;
	b=WhA8q60ilxrLii/2EZDB+4+9QV0VQXkN8QJBixoIEXxg+N4tcXsFb2Yyzm6376hqYAtQov
	A3CKY/Ddk1PZehXwwgNZpXzXfjlnyd2fMqUU/tk9q1ScSDsmYkTvl07u9i2zFo+HYOxU3v
	UIe1UNvaZWlW4mYFMQZXhkedCIQFp1g=
ARC-Authentication-Results: i=2;
	imf27.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=O5p0wWne;
	spf=pass (imf27.hostedemail.com: domain of ziy@nvidia.com designates 40.107.200.59 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=esci+AjyU9ePC1JcIlLlRqQput5ohY470bA1lpMuwnJoDr/6P8Mq/g7lY488GJ8EWrJTj7sWRnMGWLNqmueyU7IWi7gidjy9igatA5YxHoh47MgjPlYZW8Vzp3yiQzlPvm+1khh+4589ukVUFOwGCbe7+kvenUdE4hjrie2lFxxt+ipeDXUrfZmqnHWNq6RD3We8D49ShHVBXjaL9hGoLVDzStxcjo7RzdJkQe7ZpLrxKWdIavr9p1cYN0Q/deVn9Xp1n384Ogz81KEVfycskqhf3Oo2Ux0XUwlBgeRtc3+rUXDja9lHvs2zBuhX1P8vfjd9t//JImb99UaZaV0emA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DKzlxilrUr4wkycbg3QAT/2kAv9xzMtxsPK7rQZGL7g=;
 b=YMQruQaI7ybMnbigOmjVVoBR0qp9qEiuE1CxoL1CrdXi/F33B3ceNc5DrRnNSYa5qSnPml/eP6zm1vGtsreqkCoPwZNELVI0pJG7Kge+e+PBmTBcLoQQ5I8I7hTupV5KHN/tXnHEftfCo48KxrH43UhBHmtjPkWaWFOVR+mB6Y79RkY2Rr29cmrTCdI2HK4RT/o6I9NwC5YhiST/fXx7zYu2P1kviissFxDabCs9dEjW+/gyLA904XuybVMNy1b0QufH9kby3BAXb4j+6fZYfxtrRLnR28raaOv415gKgNbyKgkJIDCGEmZQmt0RCbjIw4ExxiWrGmhMWCKsid5JdQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DKzlxilrUr4wkycbg3QAT/2kAv9xzMtxsPK7rQZGL7g=;
 b=O5p0wWne1IzTcwkHsZk1ZBO8m+VqzYMArZbqwcZJR8Up7GRV1oPQXkAl0ONlQyUFhGobMuONPV1jLCYzodCC4i2JtmtTbl+kHbV6KjS9amlqt/lPeugyyzlAcVc/tbudKW7e/kFGvgUEsMu6RIIvlDVnpQ+6OZu4m1PrNOa02Jqfup/5ktLzp2kI2T87EWTfbRatxyezAK1Y12u4vmm+v+/+tLA+Ers/PJqcxyuQe56lsLscR/uQP93ER0qbCQCilUSdy0MTIBbXis5UxfmJpwYYlUfmC1HLesFVph0R6I0rlZJ6QZXZOQMCwkQvKBQncBzRLmxQkhyUBKRI6/99hw==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by PH0PR12MB8032.namprd12.prod.outlook.com (2603:10b6:510:26f::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.382.13; Mon, 7 Sep
 2026 20:39:56 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%5]) with mapi id 15.21.0382.014; Mon, 7 Sep 2026
 20:39:56 +0000
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Mon, 07 Sep 2026 16:39:55 -0400
Message-Id: <DL9DHWXVU0YR.2LTES896PBMJO@nvidia.com>
Subject: Re: [PATCH v4 12/17] mm/huge_memory: move anon_vma handling into
 the anon split helper
Cc: <linux-kernel@vger.kernel.org>, "Andrew Morton"
 <akpm@linux-foundation.org>, "David Hildenbrand" <david@kernel.org>,
 "Lorenzo Stoakes" <ljs@kernel.org>, "Baolin Wang"
 <baolin.wang@linux.alibaba.com>, "Liam R. Howlett" <liam@infradead.org>,
 "Nico Pache" <nico.pache@linux.dev>, "Ryan Roberts" <ryan.roberts@arm.com>,
 "Dev Jain" <dev.jain@arm.com>, "Lance Yang" <lance.yang@linux.dev>, "Usama
 Arif" <usama.arif@linux.dev>, "Vlastimil Babka" <vbabka@kernel.org>, "Mike
 Rapoport" <rppt@kernel.org>, "Suren Baghdasaryan" <surenb@google.com>,
 "Michal Hocko" <mhocko@suse.com>, "Chris Li" <chrisl@kernel.org>, "Kemeng
 Shi" <shikemeng@huaweicloud.com>, "Nhat Pham" <nphamcs@gmail.com>, "Baoquan
 He" <baoquan.he@linux.dev>, "Barry Song" <baohua@kernel.org>, "Youngjun
 Park" <youngjun.park@lge.com>, "Yeoreum Yun" <yeoreum.yun@arm.com>, "Kiryl
 Shutsemau (Meta)" <kas@kernel.org>, "Shivam Kalra"
 <shivamkalra98@zohomail.in>, "Kairui Song" <ryncsn@gmail.com>
To: <kasong@tencent.com>, <linux-mm@kvack.org>
From: "Zi Yan" <ziy@nvidia.com>
X-Mailer: aerc 0.22.0
References: <20260908-swap-thp-cleanup-v4-0-b532a3f20e71@tencent.com>
 <20260908-swap-thp-cleanup-v4-12-b532a3f20e71@tencent.com>
In-Reply-To: <20260908-swap-thp-cleanup-v4-12-b532a3f20e71@tencent.com>
X-ClientProxiedBy: MN2PR11CA0013.namprd11.prod.outlook.com
 (2603:10b6:208:23b::18) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|PH0PR12MB8032:EE_
X-MS-Office365-Filtering-Correlation-Id: 0fd6697e-8079-4ce4-1729-08df0d202d82
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|7416014|376014|23010399003|6133799003|10067099003|4143699003|5023799004|56012099006|11063799006|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	9lefXbOasN+tNeg5F0gl9ol+FmOv6ncj7WM+AS3uSzP05yevbH5gnbQ774i6ZaM0DAzMNKFS/h7Yfct+STNedkYQ68GAl5Pdh58h6Wa42zIPHzez5dQd32YBRfzdrTnxy8R9itf/wEoHZND6S98e1kCwFI0zl0VSceHp/OabqzRFgaNCnnyAhUMmxh8tKrd9mLowS1jVlV6v3G0yUf6KbUSbXCRGJSzcCjudRE0YjqlYT4d1lX8ptuBYc2R1O3fh3DSYkt2aACT3R6KF8ay97KvaCqBmnqBx54s6IBbrPbw1Ipeh8B0495KicxJslBmLDVAbbaxaRstzGXIkPiEpTlBxh9Ei6PhicWlP77v1uFVAc7UQhHTN0/Ko4W6aQAEdFlz9/LsQ1iliUu355M6FnqcayHbkUR8Ae0/rvJPysyfU4Uuq1zRsKQRS459yIBjJxULDXRWD/GO1Ys0luxHKXgJhX5UcPgq2Nl90SJPYwjvf/YUEQGrIuJILLgdLZuTup1j5Imatl34WVKVP7B7hUjhQLBDR+QDZUWOc2bBaE8LiSKWcLr4qD2v++cKmqtlN+Qs6bsfExf2fewE+lhux1Ysj8ljyBp0cWWECogiuUbdefUvzA9l3DlEqyEyZ1ghV2UkOst+jTMO68i2VEAyjRQ0wHm7KxUe+6MzCehUftWc=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014)(23010399003)(6133799003)(10067099003)(4143699003)(5023799004)(56012099006)(11063799006)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?TEdwQW4zVmN6ekR5ZjF4STdwQ3lGV2ZxNnlRdHZocnJmMXMrOURWeUFmSkpN?=
 =?utf-8?B?MlFVcC9idmJEK2V5YU9EMUtZN1B6ZEw3alY2a2hROUhvbjBUUS9oWm02K0hs?=
 =?utf-8?B?dFFlSUlveTUvQ3dMWkdJSzlzQU5zWkhGWU5tc3lkNnFnVlNTWkgxZHlTdU4y?=
 =?utf-8?B?Q2ovaXRyNExKM2JjVWhxUUJLekUreTZ1ZjRpSmQ5MHpLNzV4UU52dmNQZ2pL?=
 =?utf-8?B?YlhCRHJUY1VTaVVFaGxXSGFPTU4zZWlYOXRJdE9raHVUUktBVXJOMmY3V2RE?=
 =?utf-8?B?bG1IZDRpVjd5aEZxc2JaWlJCQVhaLzhNOW02aUFIbEdMSUQvaHBkMHZ3T0xt?=
 =?utf-8?B?VGlOTUE1dFBnbU4waTBGWnVoMk9POFcvbGJURThNQ2RrdUJ2V0Zzd0tMSFpW?=
 =?utf-8?B?R3pEdU4xK0dUcEI0TG9KblZDN29aVEpjNjc5WGI4YVE2a3N0c2RTamV1L01L?=
 =?utf-8?B?MnRmcDc3QXhYam9Ta0U3VFN6a0tFL3p4LzFUMktxKzREZ2thTCtLMEtnbHUz?=
 =?utf-8?B?ZGpsb0RFK3VRMXFwZmhoQW9MODdFSHF2endqWm5DdkNXWUM2eGpNdTNwYkgw?=
 =?utf-8?B?dWdvUnIrMW11L1NZNkVlRis2TWFBamxFN2J2SXc5ODFYZEJPYVJJcVlsZlRk?=
 =?utf-8?B?bDdKNmRrbDdmRno4dDNkUlMrMXJkSDN4M0RpZHJxTnpLWVZ6Vnh4cWJpVHph?=
 =?utf-8?B?V2hRZ1o5UDRoK3BxRFFWSFBYYjBIdmpBMTEwSnhlaTdKNkd5UzNwVERLcTNj?=
 =?utf-8?B?YTRXVWNtbG1MdzlGLzVjd056Vmc0aDhoWS9zN05NNlpIb3VXYnk1cSt1MjJo?=
 =?utf-8?B?SDczZTMwUm1xNGphSWRTN01ybWhuN3VmTmMzeExzS05FZUNLWUpKN2FZeGc3?=
 =?utf-8?B?RThINVAzYlRoaXluQ0Z4NDhXYjNmK3o0R2ZZSXV4Z2EydnF5bDBkbkRlT0hi?=
 =?utf-8?B?UmNQSGd2NTB3em16L2VwQTR4aENRaXNLQjJIVm1LM3RkckUyV1luSDVVMHBM?=
 =?utf-8?B?UTA0czJxd0lQTzdXNDB2MnFyYkx4dWl2OTAycTA5RU8wSlFtQ0tiTVpJNkRi?=
 =?utf-8?B?a2svNzFCemZudVdJQ1hvTFpGZ1FFUlY4SmVPWnIyWXJEUnN4Z2lMV0VLcmp1?=
 =?utf-8?B?aDAydG12T28vMXVJdHFhNU9EZkgvbHY2S0thU2FIeFFIcFR0NzZSVHRQMEt6?=
 =?utf-8?B?eXMrTisyMTdpL2VjRDFQclc3R01jREFmQWVucGdJSW9XYUVZVFJyQm4wTmhT?=
 =?utf-8?B?T056ZjQwcURNNDlWYWZPM3BENUpjNzdaMnR6U1k5T2dWYVV4REx3TUZsZ2tz?=
 =?utf-8?B?ZWVOSnhGQmpSMDMrWm1wL0pBZ3pxOHZpdEhsZ0tKVTIvZUNoN2FQVkYrSy9I?=
 =?utf-8?B?MDRicGJpTW8vSWp5QzN2UHI4Y0pySk5QY2tSeVNZdm5HazF0cFFIWWQ4R05n?=
 =?utf-8?B?UEJMNlIrOWY2NGg1aUtOTCtFQ0JmQmVheEtYc2s2VHE3dUVzK3pnTForRWRX?=
 =?utf-8?B?MGtrckp3MFpWaFRDdWRQcHNxaXBoRDkrUnZ6T0d5cWZjeGNDM1UwMDlvR1FD?=
 =?utf-8?B?YUwxWW0xMGhNV09MdEhxbFFackRWaStTVXd0RUNzMFdyWFo5Uk9LZFIyb3Fi?=
 =?utf-8?B?MENYbE1SaEQ0dERmNUo5b1M2c1pSeTV2V3k0Vzd4R05PNm56dFpOZ3o0ZDRZ?=
 =?utf-8?B?UFBOditjVHNLd1d3eWk4NmZkTW5udzE0RzFGZnUyaThOSWNuLzdjMk1kNVlq?=
 =?utf-8?B?OFlvSzR3aUhCV3ZrVFk1SWU3c2lUdlBKUitLbTFhVUcwYWUzNjRmSnc0QVdw?=
 =?utf-8?B?K3ozZnBBRDdkRE5LMHhPMXFFREczcEg3WFFZZ29jOW5QQzlOS1A2VE5aWkNU?=
 =?utf-8?B?QXdoS3Q2Y1RwVDVhOWRyaHdJV0FLb3krN0NWNG9ML1hzVDdpbVc3TlROZXkw?=
 =?utf-8?B?U2VtZW8ydjMrWENNcVhJWVBJSEg1T01nUWxsT0RnT0R4bldQQWhqWC83cFZ0?=
 =?utf-8?B?cDF0WWVZV3hIYXVCWENYVmYyL3F4b21DalFxcHZwL3FEV3hvbExlQ3hZT1Vj?=
 =?utf-8?B?d3VlcG5aNWFYcFRVSGpEWkRlc0FIZ1ErU1Q5bjYxeHhJaXp6c1BucHlNb09k?=
 =?utf-8?B?V0QrdU9mUGtGY2VuVm1nVnpvai9FMGZpMXQ3eTVFdGFZZnlGSWNQZElUZDFl?=
 =?utf-8?B?VUZqb1BkdEZDOVE2a01rWnI5Ty90S2RSNnFBT1NmR0ttL2U3RnQvOFZnNTJw?=
 =?utf-8?B?L25SSm0wNHh1ZUhTa0JTdkFlSDF0NXFrb0gzT3E2bEVvQ1l6MEduOUlOZE5q?=
 =?utf-8?Q?csmOXVlZLY3HP/cREG?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0fd6697e-8079-4ce4-1729-08df0d202d82
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Sep 2026 20:39:56.4380
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rbWbgn7xCqJ5xIsoPpbHCS0QiUcr8WmN78jXnbWOxEgxWvbGk4NZqSsc+bTiniR7
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB8032
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 3AF454000E
X-Stat-Signature: rri1cjm9ks56aay59uq6xsj5wpsr65io
X-HE-Tag: 1788813602-412077
X-HE-Meta: U2FsdGVkX1+EI8ogY24lD+3uOm/jApjOn4X2JV/E9uRKhoRP9nfXo4WxGKUjhOgMX/ZFum7HW+Rpa5lSRadIc9FP3SdDeL7DrKZUgTujTOkWyqipzCZGbzkdLV2+n5mH2Qg4t2fhnBoSkFf1PoJJoe3c7+l6wMAyrtNVK4aCBki/azbtcikmwUOtUBbOSINYI60zUBbUAY3qyDPIcC+CMUbJ4b5/yzkBHqO6ckjqUXjNGMN7Mc03tDxyRCO6rwXuvZy5TDVdfeWPqijAwuCdW4RlagU2GBlQ0MAVYv4K/AIHZy0D3VW0BTe3D2OL0qTe3uhc5xHKeQwvqlCu6nI0zLBSue3Klct2CP/CBroAwRNFqGLL4N6Jrvl2RaCPj4xEBqvPoRvu018/k4PoUz3PQyICSqrKTZchsk/1FT0YVIZl+TFhyu8BNBm2MKBfl22VB0d+KQmCfmOmTquz5ju+prUaY4EQHCgcl4zNQfcAUfEvOMgZCMUCz1dbB/eTwavREkKyg2lJCWawD4mXAJKNhIUZC3VNS5+FEZQT/uc+a6Qfn140QUlcHVvs1bjM2aAbA/O8zhLmIJFTA1azWIca3KiPTn4F0mrBBwomFd0axvRVn8xjMRhH309SspHgmJzINImvUkajTvzIRmM9urLjETEFwxGnFx7OQ99apwW3dEucd/H0QqyfOqmMdXdJIAgIJzaiiJ/dsQ5NNkxBDK0F+h/lJyrfdQyRnwEmGVGHi02feq/YX8zbJhLdXeejpgzIlFD907yRx0o6OPylpKKuvhxGlJ/3jula8zbY3cWEW9B4pvbbUrDCwY01hCJHZIvElRjY9hsyuInNrPqcHcRGURzzjbRllEdhIAf2K7G9wsg9SIp9JvwvzbPw3wkuf3UME/9z740zFV7z2t64UtNlIJb2xZlnJ3QEt0/skgZWWG3B+46oNlExK9o0cO5KuiPI0ALl7Sh3n3vfGMbQg51
 T4Wxusoz
 AkUsA/lIMo3ptJQ79bKi5nNmWdSYHVEtSm+3wo7sAJ6FS1nabpgMsVKcR9CcV/5PyXFLCfd284kZKxrZhirkINZJGiIJUjTK46radRGau7jc1/sfAJqkjwC1yjMIeC/XT1KHm64ZbkATWr1xekyK1+o6MPNKB2WiNJRWKpHWlVuv2kXCJtYJ/kfUWYipQI+zrGA7KEQcxawi2Luii+oxGtFIGg0RrCf8tIFrAjsKSF6ASQtZTR7ptMUuTbxlwdg3Dw+ToVIyPnanKAdxsfWgc/W/Qug96IuZwOxpLJVQZUpb+/1jCULLQ+OLk1XPbw1iuQBTipxvpFwGUciCBHAi3wbx9SHME8S1jXpnxnljqna796VNKbHhL5APDp0i2MG5qrfqlNeMT+D5ISIzFcdyky0n7h5j9v7M1R9WFyASiJvRZ0kanPaObfhy2JVgNKOdugGhglzYhzgQ1i6cRM1hO9hnEYA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon Sep 7, 2026 at 2:12 PM EDT, Kairui Song via B4 Relay wrote:
> From: Kairui Song <kasong@tencent.com>
>
> Only anon split needs the anon_vma, and it only needs it to unmap and
> remap.  Move the folio_get_anon_vma()/anon_vma_lock_write() pair out of
> __folio_split() into the anon helper next to the folio_mapped()
> check that already gates unmap_folio().
>
> This makes the anon_vma conditional on folio_mapped(), which is a
> behaviour change but should be fine.  folio_get_anon_vma() returns
> NULL whenever !folio_mapped(), so an anon folio with
> folio_mapcount() =3D=3D 0 used to get -EBUSY from split_huge_page() and i=
s
> now split instead.  The realistic case is a THP that has been fully
> swapped out and is still in the swap cache: swap PTEs do not contribute
> mapcount, so it is !folio_mapped() but still alive.
>
> That should be safe and right to have because:
>
> - folio_ref_freeze() below still rejects a folio that picked up any
>   reference, a mapping or a GUP pin, in the meantime.
>
> - A parallel split is excluded by the folio lock.  The anon_vma
>   write lock was added to serialize split in commit 062f1af2170a
>   ("mm: thp: acquire the anon_vma rwsem for write during split"), when
>   split_huge_page() did not hold the folio lock throughout. commit
>   e9b61f19858a ("thp: reintroduce split_huge_page()") later made the
>   folio lock a caller requirement and added the folio_ref_freeze()
>   scheme, so that has been covered ever since.
>
> - Unmapped path is already exercised by folio_split_unmapped(),
>   and the swap cache split already runs well for a partially
>   swapped-out mapped THP.
>
> - folio_get_anon_vma() and folio_lock_anon_vma_read() both bail out

You mean folio_lock_anon_vma_read() called by others? Since there is no
folio_lock_anon_vma_read() in folio split functions.

>   on !folio_mapped() before taking the anon_vma lock, so there is
>   nothing to lock against.
>
> For mapped folios the anon_vma write lock is now released before
> __folio_split() unlocks the after-split sub-folios, where previously it
> was held across that loop, that window is harmless as the sub-folios
> stay folio-locked and ref pinned.
>
> Signed-off-by: Kairui Song <kasong@tencent.com>
> ---
>  mm/huge_memory.c | 51 ++++++++++++++++++++++++--------------------------=
-
>  1 file changed, 24 insertions(+), 27 deletions(-)
>
> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index c4910c0b6018..53614b875794 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -4005,16 +4005,31 @@ static int __folio_freeze_split_anon(struct folio=
 *folio,
>  	struct swap_cluster_info *ci =3D NULL;
>  	struct folio *new_folio, *next;
>  	int old_order =3D folio_order(folio);
> +	struct anon_vma *anon_vma =3D NULL;
>  	enum ttu_flags ttu_flags =3D 0;
>  	struct lruvec *lruvec;
> -	bool need_remap =3D false;
>  	int ret =3D 0;
> =20
> +	/*
> +	 * Unmap/remap needs the anon_vma. The caller does not necessarily
> +	 * hold an mmap_lock that would prevent the anon_vma from
> +	 * disappearing, so we first take a reference and lock it.
> +	 *
> +	 * An unmapped folio needs none of this: folio_get_anon_vma() and

I guess you mean an unmapped folio does not need a ref or a lock on
anon_vma. It is better to be explicit about them.

> +	 * folio_lock_anon_vma_read() both bail out on !folio_mapped()

Mentioning folio_lock_anon_vma_read() is confusing since folio split
does not call it.

> +	 * before taking the lock, and folio_ref_freeze() below still
> +	 * rejects a folio that picked up a reference meanwhile. Note
> +	 * a swapped-out THP counts as unmapped here as swap PTEs do
> +	 * not contribute mapcount, and they are splittable.
> +	 */
>  	if (folio_mapped(folio)) {
> -		need_remap =3D true;
> +		anon_vma =3D folio_get_anon_vma(folio);
> +		if (!anon_vma)
> +			return -EBUSY;
> +		anon_vma_lock_write(anon_vma);
>  		ret =3D unmap_folio(folio);
>  		if (ret)
> -			return ret;
> +			goto out_unlock;
>  	}
> =20
>  	local_irq_disable();

Otherwise, LGTM. With the comit message and comments addressed, feel
free to add

Reviewed-by: Zi Yan <ziy@nvidia.com>


--=20
Best Regards,
Yan, Zi


