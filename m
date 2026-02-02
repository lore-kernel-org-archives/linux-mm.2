Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BDF92E7DEF8
	for <linux-mm@archiver.kernel.org>; Mon,  2 Feb 2026 15:50:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1F5E46B00AD; Mon,  2 Feb 2026 10:50:53 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1A3676B00B5; Mon,  2 Feb 2026 10:50:53 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 077676B00BD; Mon,  2 Feb 2026 10:50:53 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id ED33B6B00AD
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 10:50:52 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 868D8D336A
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 15:50:52 +0000 (UTC)
X-FDA: 84399954744.05.A430BE2
Received: from PH0PR06CU001.outbound.protection.outlook.com (mail-westus3azon11011063.outbound.protection.outlook.com [40.107.208.63])
	by imf10.hostedemail.com (Postfix) with ESMTP id 4CCE0C0006
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 15:50:48 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=asvCcj+5;
	spf=pass (imf10.hostedemail.com: domain of ziy@nvidia.com designates 40.107.208.63 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770047450;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RnNa+ml7ds2uQ5n3uvM/GSFtfssk1kh8tftvNpJrlt4=;
	b=rqRmzLHx2ZDVwI97/j7c27xLv1TbMCJ+enKsVAjZ/lBipB8202q9yxL8bZz0H35BIEcsuH
	/M+xR/1YEVQGZ62IDJYmFdmvpSL8S6gWppqeFkrTl9uW/K/xzLnKVplWXOj9z3E7lvdvMp
	vsyspawbTbGgG2w/5YUY2X9zM8p4aN0=
ARC-Authentication-Results: i=2;
	imf10.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=asvCcj+5;
	spf=pass (imf10.hostedemail.com: domain of ziy@nvidia.com designates 40.107.208.63 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1770047450; a=rsa-sha256;
	cv=pass;
	b=zKn1nbQbghw4tY+UXL9XoM2MY6PiGeKtsYnp505NrwiDiFYxWU/yC+Vy8PMDx5zJyRzK9A
	aNy80G3P5mQWrvnDNm0Jkmy5sir59gp0R+JMIgAPzMCDkcXXf4HaGj010IqTBAxXTaHbqs
	vUPPdrOgA6RmNuL5LMYovFWJ0J+m9ps=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=dH6wGcBVPuFf2auCgpNsqedrUImfnVPHGeh1G9i0zZnReigh1mY5n0yOAQtVu12hd3UTWhOvVTKFWyNj1Kgch6UTexH5NJpjLrz8ik3x9X29wgDMn+7RSd+9qefd66FBQlOUB5LMGNwOYhwviCwoGWMsYbiAEmTtGeCPUhzS3zIuR9Z098Yd+cs65ZWscQHA2rUqgcuEZsZZ3RfqrJOeDLjhVCzC53ylzg1Tx4Gz9Py/BGU5jxhRQrR4Haynpplhx5ADtZuSOMU29FIa/KIsnE1JOM24LIZFkQ1ugEJRJK8rCCTTMZBCIXpv6FdXhv6t1La9/RVljgUF80sjX0ecUQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RnNa+ml7ds2uQ5n3uvM/GSFtfssk1kh8tftvNpJrlt4=;
 b=fhAspREW4jt78hNtDinU6/QHkQNLFHiMRuup9c4FyGh6krgtlmOKPSUThh7YwmVn4ODB2tqTErZpw56FzTTpBqMzNkOr834TuoluWcdM0tpdJuawaM8UazEntte6rvmLmuk0Sw7OBoVEADhwLPtF1vb6sL06fOGCjdFJIH89kIjpB7a3oHZArbG7mUUtBilRHegD72IfM6CW2WwsxVlL7B+Es5Uu9w8pYw0MMPJDZ+q9XLiKU8dAggLB65/U0WiBNRsDlBhy8NbEEMaPRW4isTs+LGYbnCe9VCVYA8+qW3gTxhkji8Lrcj3EJXSwQr0K94dJ44Pe/sU3B+14xmOOnQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RnNa+ml7ds2uQ5n3uvM/GSFtfssk1kh8tftvNpJrlt4=;
 b=asvCcj+58vTTU8A9UTFi98qRPwY54GnnAMiOL40RcnWo+hiILaATLrqXt2Eg6LKQqr96SXIhndUXo1F4eItNrgYcJeYVSLJTrIYw86ADblKj0oA6WaUlmb5aG7E3+SjrVqA66QubChnzhBq3na96XEfbpKA58nLiJ+JurM9o/SuNkg40SjuBLxnJancwXKM5OXmYzyznIUBIu1+ZZJpMLe7wNBa+RVcIHSgNRvebhmVO0Z83is2Gy034/rnSFofC5x4ygux9ijRQ2pshyRwbST5BT13Qdj1U+5qiF1Q15CCMOqS70wvxIRo0qNH6M3vS51Gz3GmHACeDfjhLfcG9sA==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 PH8PR12MB7279.namprd12.prod.outlook.com (2603:10b6:510:221::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9564.16; Mon, 2 Feb
 2026 15:50:41 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2%4]) with mapi id 15.20.9564.016; Mon, 2 Feb 2026
 15:50:41 +0000
From: Zi Yan <ziy@nvidia.com>
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 David Hildenbrand <david@kernel.org>
Cc: Rik van Riel <riel@surriel.com>, Usama Arif <usamaarif642@gmail.com>,
 Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
 hannes@cmpxchg.org, shakeel.butt@linux.dev, kas@kernel.org,
 baohua@kernel.org, dev.jain@arm.com, baolin.wang@linux.alibaba.com,
 npache@redhat.com, Liam.Howlett@oracle.com, ryan.roberts@arm.com,
 vbabka@suse.cz, lance.yang@linux.dev, linux-kernel@vger.kernel.org,
 kernel-team@meta.com, Frank van der Linden <fvdl@google.com>
Subject: Re: [RFC 00/12] mm: PUD (1GB) THP implementation
Date: Mon, 02 Feb 2026 10:50:35 -0500
X-Mailer: MailMate (2.0r6290)
Message-ID: <2B979847-CED0-41AE-AEB1-BEFB267B1E14@nvidia.com>
In-Reply-To: <7d246914-6077-4dc1-bbcf-8dabbe6183e7@lucifer.local>
References: <20260202005451.774496-1-usamaarif642@gmail.com>
 <a0c6c8d86ea05dcf5ff96a9d48d6ec79948c88ee.camel@surriel.com>
 <7d246914-6077-4dc1-bbcf-8dabbe6183e7@lucifer.local>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BY5PR03CA0014.namprd03.prod.outlook.com
 (2603:10b6:a03:1e0::24) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|PH8PR12MB7279:EE_
X-MS-Office365-Filtering-Correlation-Id: 453e262e-8450-4f90-0750-08de6272d172
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|7416014|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?QXFHSVBlRVVISEdzeGdvMWdoaWh2bXhJWUkxcVc3QkhZNHRLZ2RJRWwwbnJH?=
 =?utf-8?B?VVJnMzVkNEFEK09Cd1ZtTm9EeGxIR3RpYXlBT0F0ekhGelNCUmE1K29HSW11?=
 =?utf-8?B?TFp2ZDMvTitQZWtJSFBwUmZESUliR3BnVjRFUnQ4RGZMb0R2MzBzTlk4WVFJ?=
 =?utf-8?B?T3pYUGRDZU5PMjRqL2JadmZVQXNYOXFCSmQ0cTh4TWZYVzBZTFZkWWdNK1dm?=
 =?utf-8?B?M0dWNGtId1JYTDZHeUdhbGRxM0pWRW9xb21PM1pOc0xvV09VRGVVMFg4TVVx?=
 =?utf-8?B?MjZ4L1lld2VmTEJ5L1dMb2Q3ZGYxcFNNZGNXQmQ1RFpjRGRmM2ZlZ0dnTmdT?=
 =?utf-8?B?bmVvcUhnM3FDb1dRb01QT0RuTHptV2RDM0hVaUZPU0NuUGx5dUd1Ymh0ZFkv?=
 =?utf-8?B?aXpSN1IyRTZiMjA2MEwzcEZ1WkJuVU9xeDZ6NDJQYmNWZHVuQzBsbkFtdDFz?=
 =?utf-8?B?NWpTSCtBZFJNbldDY1NTMDdhRW8rTWFjbW1HalJWRzhjSEsvZGN3Q2Z0dVZ1?=
 =?utf-8?B?aDdUU2R2UE1tS0w4QWZzcmFKL3dDWkZxMFdqZUI0SUViQUk5b3Q4WTdwM3Fo?=
 =?utf-8?B?NmJsMkZSdWt0eDIrTzJ2Wm9VYW9tMi9DdWc0OVJhNzZWTW1xci9KeGs2elRR?=
 =?utf-8?B?NTNyOWloUHNleGZVQ0ZXVlVxVG1hNGhQRzhYYjQ0TGIzSWp0QkV6MjYxUU1o?=
 =?utf-8?B?OThZdWI1eFAzcmZwNDFQanl2ejNod2pPMVA5QUR0V1g5TUZxMStvNlFKZXpY?=
 =?utf-8?B?TVlyclVkL1VWWTVZNHorbG9hd29GY2lGNFV4SDMwcUdUN0Y4OUJRNE5JN0Na?=
 =?utf-8?B?RW1nZkV4YWpuQ1F5cXMxSCtSWWdLeGlWcGJCdU9jRWtjdUJqTE5NVFhack81?=
 =?utf-8?B?UWg3TzZVenFxR2owdE1iMU9ZMHlTME9xWGQzSmJWdU1WWXVjSFZxK0FWM3hn?=
 =?utf-8?B?WittTHRyYUd5R2Y5anpySjJQcFFxQURONWRnaW1nQ0VRQkwva2FTQUxGNGp4?=
 =?utf-8?B?L01sQng0UXA2bkxuSStJVHBPcFk3YUV2U1RXenRXMkhPajdvbFRDNzI1T0Zu?=
 =?utf-8?B?REI2VWVDOWVSUlQ4SXBTN1BMOXVhNUFGbHlyYlZaU2FxdkNvYTBnaDV5ZWxz?=
 =?utf-8?B?Uk41TzBhQVA2aHZDdmxjQThvSEFOSTEyeTdzcXVRRkJESVV0MXNDNGozUkho?=
 =?utf-8?B?TVJaTWVoaFVubVJBMnMzTWIzZmJmbEp3L2gwVFljWjBuVnV5eXArUXZpWUlr?=
 =?utf-8?B?SkJBUGd1NWhmdUZkamFVckxsZVNnd1RCNVh3YkhmVWk4VTdURStzcHA1RlM1?=
 =?utf-8?B?YVRCeVN1b2laOU1ZNk5DNVAvWDNXeksreHo5V0N2K1VnNlkzM25nS2dPRHBF?=
 =?utf-8?B?WlRDT1NxVnFrVUQzWDYwcmpxZUZXQzFjQUxhelZnTnpsRzlrbzRtditvTWJn?=
 =?utf-8?B?ZE02NGJtaG5sOXBpaTZac3ZheVNia3pLYUhER0dFaFNtaGgweldzM3JQTUVa?=
 =?utf-8?B?U2JUMXY5Q1lCaVNZSnNzcWRKMEJUSXVZZFNHaUFoZUtXRkJjaFE1RmNmM0g0?=
 =?utf-8?B?QVVEUjl4NHFTWElGdEZieVIzQ2czaDhjSlV4N2tzY3lDaXZuUGhFa1V0aHR4?=
 =?utf-8?B?ekV4aW14ZlA1R1phOWRQS2VxTnlYbjA0V2xjSlAzMkdNdVFWTDZNMVo3bW5j?=
 =?utf-8?B?Ny9aMU9GdFNzSVNmR285c2ZncUZVSzlLbk1zOEFmQ1hkMGVlbXh5WGNKM2Vi?=
 =?utf-8?B?T0pjNjR3UDVEaDVpUkMrYy9SMTIzVnZqUWRKc2hqTUJvbkw4SFNwOVNDU3M0?=
 =?utf-8?B?VW93OVpFVGdxRXNVY1FBYjFMYUZoR2VvMitVNmJYMFRjU1hrNTAwRFQ0b0Zo?=
 =?utf-8?B?MGdVdDc0ejNRcHkzVjR4Skx6cXpkNUF1R3FnME42dk00MUNWbFk4V3l1Ykow?=
 =?utf-8?B?WFVMRVRnQ0xsZjdXNnlTTXJqWWY1UGw2TG1BRGlENlhxNWxqdG1KSWc1WDRI?=
 =?utf-8?B?QXRBN3RiZlFqSzVNTWpRYTU3d0NTOWlFdlFIbFh6T0Mva0dRRWE0YW9VaVdK?=
 =?utf-8?B?RTNFKzExYlR6UURHbkZVSnczME1lNTNiYmNmUHhOMU10NVJTMXFETHk5MEM2?=
 =?utf-8?Q?LZwA=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?MVpwcUswdHp1eWtrbmJNcEhaRFQzSTN0eHpXdWdJa0xsUWROUXBvZFpJSEg1?=
 =?utf-8?B?N2lLdCtNUDhlVk1MZTBpdmZMa0VXTDUvSEh3UXYyNURXUUlIMGdUc0NRWU9T?=
 =?utf-8?B?dWhxa25mUGxwYkkwN1Uxck4yR0w2WGw5OUpHdTlqOEVIS0hoN1VSYU9iOENG?=
 =?utf-8?B?ZlhKRHdNT3pnNmUrdE8xUlVML1o4TXNlbkE4dE0zQlpKRkNVMWU1RVE3aXpK?=
 =?utf-8?B?TkxaVFNXcG0rYlI0dnFYRHFwL3pQTUFERm9nS0ltdU43Qlluc2wvUlVCNUZa?=
 =?utf-8?B?dUNFV1czSnJsNGM3Um5Ucld0aGEwRG16OURmKzVGSWNEYld3MmlrUEM4SURC?=
 =?utf-8?B?aS9GNEdFWStDVGxyRFRuZXRVM0hpUFhKKzRJWTBNYUVWVk9aOTRwQXA5RFIz?=
 =?utf-8?B?RVoxQjZybTlVOWFlNnpqZXk5b2JBZE1sWlFXSVdsOW93SHR6N2xTa21ucmFI?=
 =?utf-8?B?cHpmU2VZSFZHMmhiY09Rb09VU0g3UWxqaHBLY2k5eW5Fc3NBOFlnbUFnQXZH?=
 =?utf-8?B?K3FHeG5HSU5jSG5abUNkNDYxeU1zNFk2N3N6SDVVQ2dZSTRUWjRXWnVJK1N0?=
 =?utf-8?B?QVNOMXJJQkFCb2UwdGFUVGRmRUpuWkNGOWVlak8xMkdScExvQ1Q1Q3BMRlUw?=
 =?utf-8?B?VDF3ZW5idFVkclkzaG5nQ2lYR2VjOVJUUDhjZFBITi9PSUpwY09hcnY5WWE1?=
 =?utf-8?B?TjZXUjBiRmlNM1JETjdCOFR3K3hBSzlsYXJaRjNpY0ovUTYzOWd1R1BHNDhN?=
 =?utf-8?B?ZmlhcHdJcTd4endqWnVrKzZPVlFYUVFuQXZPNndsZHBKRWhSclNlMDZEQXZr?=
 =?utf-8?B?RnlFWGl4REFyL0RPT3FIN2VZYU1naUQydWhkU1pXcUpHc0g4YWRmYnczLzlj?=
 =?utf-8?B?SkdxY25pVDZNZTZUamVFejZWSHZac1VacnozSk5aR1Y2NFJyYWlSanV3bzNJ?=
 =?utf-8?B?Tks2NUV2SDJPczVWc1NKSHJORjlqWDZobE93cnR0ajgwaVZDUG1OaXc5SWtD?=
 =?utf-8?B?RThYMU9wL0VEMVdBRmZidWYwRDdhdDRmNUZBTWhRWFdoL0pHZU0wRWNKREor?=
 =?utf-8?B?K0ZKUFF5T2tuT0p2TzFWb3RYOXlUenBKZStuQWNRczB5UVFFU2lSZzlNUmQ0?=
 =?utf-8?B?ZDRVdFhPemlTeXN2OWcvci9uSXN5THVqNjZYQjVENmlwcWljYjhoNDY1YXBt?=
 =?utf-8?B?ZTY0d1NKb1hhb3VFOU5PbkFNb05CUkkva0tPS1YrMzdtZXVWSk5FdVM3UFky?=
 =?utf-8?B?UUZPTC9HQTUvRDNldWdETS9hWkM0Qjc3ckRROEdMWXpTZWU4RC92OEVmS2J4?=
 =?utf-8?B?L0RhNGxRTHhFdHQ2cUw4c09yQ2ZETGwzYSs4U01oZHdiSXBlOVhzdGJBZ09o?=
 =?utf-8?B?cjd1b1NZTkgrN2l0STY2SWlmRmtNKy9LdXMvVVZ6emZBeWRXT3lGUnNjMTlt?=
 =?utf-8?B?OVNZRUZFOFhjaGNJbWtad0I1Q1d2cHhEV2laNUpsRXpwbFcxRjkxdTI0MVUr?=
 =?utf-8?B?WGY0NFBseGhQQVV0cUxrR21IcXJlK1VlajR1dFo5YUJ3ZTNRMFNVbC9RNEd6?=
 =?utf-8?B?QzlseXRLY3JmWXhacC9pbHhHL1VJMmVXdk0wa2I2UE5UZVZJcEZUMEhwaHY4?=
 =?utf-8?B?dlNMVVRLSTVoaEFDbnpEVTNzTlFaNTE0WHBDVWtQS0IwbTFpcVZScHpoQzRs?=
 =?utf-8?B?dzNQRytobEZhSzltUUJubHFoSUNDZFpFeVhsNG1reWswcEhpYUdCUHZwNnd3?=
 =?utf-8?B?Mkl4L0YzL3dXUEZrTW5XSDlYaGxYS2ZHR05QZ2lpMkM2L1JsWnJqTkJnUldE?=
 =?utf-8?B?SldqS2JuR0RpTWkva3dYeGhGNG12bXJVc0YrTHIyRnhTWXdnS3luQm8zUVRX?=
 =?utf-8?B?cTlQK3ZRaC9ZMElBQTRta1Q0OHl3Tnl3OHhpUk1EKytoVTU0UTFpRjljY05F?=
 =?utf-8?B?UHVLdWRtM0R3emVTUmpjU2Y5cGZ5L25BZ1lrV0t4S2NTZStyWlZBWk95YzBy?=
 =?utf-8?B?dmRWcnVnZzlwWWZEemYrN0JsbDZjcjhqM3Ywd2x0MmV3RUJOeVFuOEo1eTlM?=
 =?utf-8?B?MGNDVHAzM0JpekJiV2laZ3NiY2UwcTFvVktBRVRrOGNaazd1aUN6ZHBFR0da?=
 =?utf-8?B?L01mSVQyczk3RDBXbE1HOXBSK2lNZWxKcUVwL2RkU0FtSnFNdTd5aFRQMXFB?=
 =?utf-8?B?Ym5DVmh3dGVKc2RINi9oWXM5TndtdndFSVZxeXEwNUhvWlN3aGJGRlJlRFFj?=
 =?utf-8?B?YUZRb1ZNMmhta1JZT0hGMzZGdmhiNzBQb1EzeG5hTVRmWExPUkg0RnZvY2to?=
 =?utf-8?Q?zhw6Gu3GTggjjuL0cw?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 453e262e-8450-4f90-0750-08de6272d172
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Feb 2026 15:50:41.4269
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rKyKzVB4Ry//g0SjatnZ3eiuoFvWLu74Qk2EL9K+tMTh01A1ARdgan3xGIk/beS0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB7279
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 4CCE0C0006
X-Stat-Signature: kpu4wop5xen4drhh81xybjsdr176yxie
X-Rspam-User: 
X-HE-Tag: 1770047448-419172
X-HE-Meta: U2FsdGVkX1+HPq6P2iMFmhmKqHJtQLEh64CpM1+28T/ZIsw8oAKsJCBYf8/FosiW9irsi/SXAY5ZYPgYPoDqR2p7ymr4ngt9w1goznSSoHGa0YRv2cEhgmwSRQbb/MLnkA7VM29Pexp4O0VPuNuii0So8Wvt/cAxSpltmnHrxvTxMVtasOEwLEsY3UqAQMSW1x0mDIPSbF8+o+CwMqvGolwlEtyImZCPyuW5VC4PjZvHkPq+5t3yb3YvRm2+YLR3IIp1umxupCIoUroXVghqSVfJU/hfpC4sIpkYmc+uevcbX9Bdj7jbuC8RIAyitbencMeykwVu/ViK7dK1FY6jZUtAwtfORYE8TiNPM5ufQvtxq301TzXHZipDT9MIZTFur669KwoRutfibu1UrnwIIQtfiiGXBfUfLih6Gq8jJej/mPk+D1IVMHHY4ErAG5F1TSIkIbJHw/01McTEIm2aG3zsARUOfxeinsWzrBeK2/iTnTZ140cL9nHIo0svaQLQw8n0bSzHwU0jsgBbKsK7FGorfW6lhRzy5rADPmlwuEbGDJIrNHvtoIq8U1XpzmaeYv7l/ybURc0/za1k/7nj/v7hDTLsu+86ehEAz/VCECD67XGJ9DEZtk2QFAxU2mzMhtDJA4SNL24bOISjzNP25PbE2KyqmpN/jU+OCfkg7KDtFxaGUrGMzG+B6nDSe9Kyu4xkgsDoSVU4Yyrrc/bWED5SIP2tgOW+UQ8TUnoWh5J2FMlxiQ0egW12CswNdg79jEyfqd1YGkbp21XuHCwZytuNqS0EoQYdrVO4V4GGIjkZ1y7/U26d65P90rLFOYiMHU/jZC9JXC28a7Z7W8rSW42LM8aEeSVpCoE82LxyDHZ7kOvKkOIbieV9ty+eYzoNISgTpiGRDoEHN9o3kr6z8g==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2 Feb 2026, at 6:30, Lorenzo Stoakes wrote:

> On Sun, Feb 01, 2026 at 09:44:12PM -0500, Rik van Riel wrote:
>> On Sun, 2026-02-01 at 16:50 -0800, Usama Arif wrote:
>>>
>>> 1. Static Reservation: hugetlbfs requires pre-allocating huge pages
>>> at boot
>>>    or runtime, taking memory away. This requires capacity planning,
>>>    administrative overhead, and makes workload orchastration much
>>> much more
>>>    complex, especially colocating with workloads that don't use
>>> hugetlbfs.
>>>
>> To address the obvious objection "but how could we
>> possibly allocate 1GB huge pages while the workload
>> is running?", I am planning to pick up the CMA balancing
>> patch series (thank you, Frank) and get that in an
>> upstream ready shape soon.
>>
>> https://lkml.org/2025/9/15/1735
>
> That link doesn't work?
>
> Did a quick search for CMA balancing on lore, couldn't find anything, could you
> provide a lore link?

https://lwn.net/Articles/1038263/

>
>>
>> That patch set looks like another case where no
>> amount of internal testing will find every single
>> corner case, and we'll probably just want to
>> merge it upstream, deploy it experimentally, and
>> aggressively deal with anything that might pop up.
>
> I'm not really in favour of this kind of approach. There's plenty of things that
> were considered 'temporary' upstream that became rather permanent :)
>
> Maybe we can't cover all corner-cases, but we need to make sure whatever we do
> send upstream is maintainable, conceptually sensible and doesn't paint us into
> any corners, etc.
>
>>
>> With CMA balancing, it would be possibly to just
>> have half (or even more) of system memory for
>> movable allocations only, which would make it possible
>> to allocate 1GB huge pages dynamically.
>
> Could you expand on that?

I also would like to hear David’s opinion on using CMA for 1GB THP.
He did not like it[1] when I posted my patch back in 2020, but it has
been more than 5 years. :)

The other direction I explored is to get 1GB THP from buddy allocator.
That means we need to:
1. bump MAX_PAGE_ORDER to 18 or make it a runtime variable so that only 1GB
   THP users need to bump it,
2. handle cross memory section PFN merge in buddy allocator,
3. improve anti-fragmentation mechanism for 1GB range compaction.

1 is easier-ish[2]. I have not looked into 2 and 3 much yet.

[1] https://lore.kernel.org/all/52bc2d5d-eb8a-83de-1c93-abd329132d58@redhat.com/
[2] https://lore.kernel.org/all/20210805190253.2795604-1-zi.yan@sent.com/


Best Regards,
Yan, Zi

