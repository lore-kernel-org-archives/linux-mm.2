Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C2A2ECA5FF5
	for <linux-mm@archiver.kernel.org>; Mon,  5 Oct 2026 20:15:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6BA9E6B0092; Mon,  5 Oct 2026 16:15:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 66B196B0093; Mon,  5 Oct 2026 16:15:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 533826B0095; Mon,  5 Oct 2026 16:15:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 19C0E6B0092
	for <linux-mm@kvack.org>; Mon,  5 Oct 2026 16:15:07 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 5DDB11C31DD
	for <linux-mm@kvack.org>; Mon,  5 Oct 2026 20:15:05 +0000 (UTC)
X-FDA: 85289676570.17.3245DCA
Received: from CH1PR05CU001.outbound.protection.outlook.com (mail-northcentralusazon11010030.outbound.protection.outlook.com [52.101.193.30])
	by imf09.hostedemail.com (Postfix) with ESMTP id 1B6D9140003
	for <linux-mm@kvack.org>; Mon,  5 Oct 2026 20:15:01 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b="ioO6GvY/";
	spf=pass (imf09.hostedemail.com: domain of ziy@nvidia.com designates 52.101.193.30 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791231302;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VwN9Qfw179/rFDvctJi38VMBUgarvSSNm+oH+o44/M8=;
	b=gRSDD5/QUQx6LEDiQqQkQH3G/G++CbE45ehUZmjHm6VS65/bLf87Fl3oA1xOMkwYkeYd25
	dMKOLQJ97EOtN8fR+0gTMc5kacT2PrEciGxoJHHYZ3edNQhiomdrTdUuWvRTGRVffETXUP
	1EKDP3CCL/zfWt1LkRDctWnPeb2gDTc=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1791231302;
	b=frUiYaBoUkOTTGJ+dzRFtjJyuiH/MTlyXAl+wHHpGjzbHYQk9e5nw0OUMrrWWbMGZkOg6y
	CrRwNm49bEnWkK1XZM8KtaaPZh3xsjOJ06tfQ+aHQVumWnCtIs2K6Hquri5Gbe3uuh9i8K
	eDibeoNt3CTKibcmHFurji4/qIZ8d/4=
ARC-Authentication-Results: i=2;
	imf09.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b="ioO6GvY/";
	spf=pass (imf09.hostedemail.com: domain of ziy@nvidia.com designates 52.101.193.30 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=NdzRqvdT/cR5hHgni+TVVqaMaBnMaWpBHGzQ4bwJMYC001kQjfa101nqsvlM0rOVnPnRJI8Mk5DUtIqbwwmIs0MHoiCqybjTB6ooVQF+GU7tpeanFZ3Y4Uw8kgHfErE9mD6OMSOHclKsdJD7Vr6klmlna3KB+E27C/eXFzxC4SxGKiRATlFihhPKOw+Gwh5VXvSHztziGnmlHyqKuX21YoezOkkKRNO+p8gtBCYG7U3G4sBDhd2o4AJmcl/isl7Ecej5YVe7GsJdr8Kf6eMF7gnxphexEc9NClKl+O6afY2caFbbGWUA1ibbtW7IzCZoXTolKjockrZ68oQjzS6uAQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VwN9Qfw179/rFDvctJi38VMBUgarvSSNm+oH+o44/M8=;
 b=gu29ojcNsutcANlpjj0oDuE9BoC9jG1nMRXxCdxyYDM+UiatyklUnGfcjJZJGidelfwGhriuopbB7t+hpWZzU8x0uGzxaExT/dpqB0lZChGkCFa5LBCHDGBbibcpoZBF+4I4YJOF3zpQiHqav3dSBb8ODFWCRe4w5yIDfS1L/4kz0PdCaMmcf9FoNeUhUiuhnlPNArS4a1cFoF9lEQ9A3kWIunn3nfZ0JSwe903Lf+hLmcNA0hsqbSs3BuXAZRvzu9BswoHRiqNlEpoblQdDh4MROv/tMdxM4ImSuXGZHCFxWrPDfZ5yUviQArILI7qnlMbT9wGZHR1HC8FKLZkFIQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VwN9Qfw179/rFDvctJi38VMBUgarvSSNm+oH+o44/M8=;
 b=ioO6GvY/kYPiCG9NkFJ3Rj/LILJP+H4cPMZMgWwbhSHainnFTM1NPbVBg97kIU2nyN8dJ5/Rn45E77CMuZvWsEIhdN4UvC/O3UrYfGak/8TIznxr0PVzSNwsIuQjvhPLU0HNnPZZMhTAD+vQfSogj28mvCzCnacKIxqBA+EVZIPqlIZ6iFqexwKjQ/IUPWTFgGHWOMu2i3ccz+oEaZYAjfYW/bX2etGtd2je0gLSjcwyn6c9aZ2Ydfi58sI8jAvNbG62KZBJxySwX1BHB/ieNq6l+7Jd2BQcxiIgqWiGxBiyncgyubW14oLWUK4XDL6NbY+GC9JDQM3FR1J3EszDJg==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by CY8PR12MB7313.namprd12.prod.outlook.com (2603:10b6:930:53::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.472.15; Mon, 5 Oct
 2026 20:14:54 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%6]) with mapi id 15.21.0472.016; Mon, 5 Oct 2026
 20:14:54 +0000
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Mon, 05 Oct 2026 16:14:52 -0400
Message-Id: <DLX6HZQ71WVN.1AIA7V63XWARY@nvidia.com>
From: "Zi Yan" <ziy@nvidia.com>
Subject: Re: [PATCH v8 07/30] x86: mm: add PMD swap-exclusive helpers
Cc: <ying.huang@linux.alibaba.com>, "Baoquan He" <baoquan.he@linux.dev>,
 <willy@infradead.org>, <youngjun.park@lge.com>, <hannes@cmpxchg.org>,
 <riel@surriel.com>, <shakeel.butt@linux.dev>, <alex@ghiti.fr>,
 <kas@kernel.org>, <baohua@kernel.org>, <dev.jain@arm.com>,
 <baolin.wang@linux.alibaba.com>, "Nico Pache" <nico.pache@linux.dev>, "Liam
 R.Howlett" <liam@infradead.org>, <ryan.roberts@arm.com>, "Vlastimil Babka"
 <vbabka@kernel.org>, <lance.yang@linux.dev>,
 <linux-kernel@vger.kernel.org>, <nphamcs@gmail.com>,
 <shikemeng@huaweicloud.com>, <yosry@kernel.org>, <qi.zheng@linux.dev>,
 <luizcap@redhat.com>, <kernel-team@meta.com>, "Thomas Gleixner"
 <tglx@kernel.org>, "Ingo Molnar" <mingo@redhat.com>, "Borislav Petkov"
 <bp@alien8.de>, "Dave Hansen" <dave.hansen@linux.intel.com>,
 <x86@kernel.org>
To: "Usama Arif" <usama.arif@linux.dev>, "Andrew Morton"
 <akpm@linux-foundation.org>, <david@kernel.org>, <chrisl@kernel.org>,
 <kasong@tencent.com>, <ljs@kernel.org>, <linux-mm@kvack.org>
X-Mailer: aerc 0.22.0
References: <20261002095503.3585565-1-usama.arif@linux.dev>
 <20261002095503.3585565-8-usama.arif@linux.dev>
In-Reply-To: <20261002095503.3585565-8-usama.arif@linux.dev>
X-ClientProxiedBy: BN9PR03CA0481.namprd03.prod.outlook.com
 (2603:10b6:408:130::6) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|CY8PR12MB7313:EE_
X-MS-Office365-Filtering-Correlation-Id: f9e40fa8-7ae1-465a-18cc-08df231d518e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|376014|1800799024|7416014|366016|10067099003|4143699003|56012099006|11063799006|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	EyHFZJKvtvP3mXb7fEqQwihB7sWgVPhwR0ELB3eva6YbC4OrfgimG1XTU7ep3ZAXFOfZIhKP6FukIF0dCvpgTR3nsdjI8y9GZAp73is+zz6kUuuuKW9hHEUc4MewfIC+cFAYhZC/Hujgnsk2SJcuZWrsAjq8OdPQaoOMk4c5qQEEmLhgvSlQjTtAzqaa/pTMbwYD27lzOQUsl6BbXUTLY89NWXuAvlDPkTZ+t0C+9+zTCL9fNqpVejfogMG2suPC7PrYaypbrqyB5dJh65ma/D9g1OGuRik+b9jP7+3Zfg2gzkXDRArycFL2ZphSyx5GD2cfv9iUUyHTF+o9wCqNiT/mdLXf1/+Bc9DgGk9Laz15iPSKDeZcwUiZqI6uPIU6OvsbH9XXbgsFUuNfhbaa+hDMzXt9KEhalmiz+SV10xtsGbok7fMZV3MuEfuRR3H7pQG4+F1aWRYsmYExBZDwZGAvs67gYaBPcTG4XYPxX1Z33jYLh2DXR6Sj7yelDveXdMhYhQ9Pjy+MaJsSQXOHRNwvzkDU8e7hV45ZKd6G3kPHB2r1j3BBV3PhugieiD+6ZTVJP49io7i+GrBNMHrR0NQPvVdXfz2482LU+BpB1f+rFYJvwxvTobvCGWRBr/Ec5JZk8QaaS//JIGm1qMHx7sDm36gETypNfkUyBfYWGqk=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(376014)(1800799024)(7416014)(366016)(10067099003)(4143699003)(56012099006)(11063799006)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?M2dqMnRXMWEwb1JYZ3V2eUcvUWQ5ekhLUlBWZjd6aTZoRElYSmtqbHQzbHZP?=
 =?utf-8?B?ODd2Uzkrd2tqUkNtT3dUTHZ1Wi9ZekgyeEp0V3lrZVZ1YldiL2JxaUZMalNU?=
 =?utf-8?B?R1JIcGxKVHVab0k2WWtqTjV2V2FJL1N4TXJSYlcreWxRYXdPeU5tNVVOZUhi?=
 =?utf-8?B?dGI2QVlkOVRsdzJQTVRNNWdaRjQ0bTlHZnR1SFl4VDIyUXhzV1FQM1JtV3B5?=
 =?utf-8?B?SWJ2bTBtWWViWHVzeTJ1eG5zWEJqc1BoaE9uUG4wd1FFcEVsWGxwM1kvTUxV?=
 =?utf-8?B?cFhzaXpEamRBQ1pRUzFsN2h5emxLR0MzNUVBUzYrQ2MyenpCVHp3U1BRb2Mr?=
 =?utf-8?B?VmlpSE15STFXUHc0RndPVEo5MjJWQUJQM3ErditaZUhEaThRYVNPbkp6b3Bv?=
 =?utf-8?B?Mk5aTFg5VCtNRjI5RktTZ05HMmFkYTBhMStpZ3E0Zi9lN28rakhtRDlzci9n?=
 =?utf-8?B?WVlYTUFYb21QL0F2aTRFbkluQVJOWFRJOHVjSExVVVRvZENEbG85dTBlMGh5?=
 =?utf-8?B?ZXhPS0FxSXZKYWx3SDloOEl4TitiRFowOTh4YW1BM2t3MW50TnRsWlBzVjI5?=
 =?utf-8?B?VXVuQ1lNa1NkMVEwcE9JalhMSk9VNDEvVDFyWW1UVENhd0RuTnhqOHdTRm1w?=
 =?utf-8?B?NU1qTHpUY2pKYUNwR05xaDZEYzZkYnRxQVRTVEtROXlKT3lMa3VOdDRhQjg1?=
 =?utf-8?B?RE5mRDF4T3Nqa0FwOFo1QitxMFBJZzFyOGgvUi9qNG10b1R6aU04TEp6TGJa?=
 =?utf-8?B?SS9McENZZWtVVkRPN0VxYTZtNkhibE8zSTRXWGExSXlJR3l1Y0xBbCtFdHAv?=
 =?utf-8?B?SHhpS1IzaDVYK3ZoSnhLckJyUEVrYWxPKzhmU2REYWp2WndDcVZZOVc3Y0N4?=
 =?utf-8?B?WVRwQUc4UFZRb1huQkVqekdXSlJ0UHJqQlZKdG9ncVpBdFZNT3cySUdMY1Y1?=
 =?utf-8?B?VXluWlB1WFMyODM1THB2dU8zS2E0b3hYQXhjWi8xTDJNVzVrNkFWZlB3RW92?=
 =?utf-8?B?VmNsbDFkVzRZdi9MMGhRcEVoQm5DUkNOYW5hM0VMRWx6Sk0yeElpc3VSVUpJ?=
 =?utf-8?B?elpjakdXZi9hRjFXY1Z0MHNmV1JjVUwwd0I0NkRNSDJpV2E3c1Q5VEhuTzJ1?=
 =?utf-8?B?dXE0TDllRGc1MDB2N1M3ZU1uUVFnVzJPWm81UGtuVjlneVJPSkEwYWFnSEZD?=
 =?utf-8?B?d3RaQmVaTVBrOGxUOGtRK29Yb3QxVk9ubHhRdnM4bE0xaUlCT09LSjlwMGlW?=
 =?utf-8?B?QnlVa0JQdElrTGYzYUdHY3pOb2t1VTVRdVhJTmNjTjdMNjFGZjIzRmpiSjNZ?=
 =?utf-8?B?aW9KVFJGaGlNODVtOWp1eWp5ZXJ3dGFGT3FiemxjT3ZYTzA2YjJuYnVEank3?=
 =?utf-8?B?K3BqNnR1cEQrN2lSbEdEWVNEdVRGWjdUZU0vdVJaanF2N2I5cTFZL1ozSThM?=
 =?utf-8?B?MVVEVmpKVC9pUi92YmZkNy9ybTNMTjI2bzl1eHhQc0szUGYrV0Q1TXN4YXdP?=
 =?utf-8?B?M25vVmNnV3lNL0pnbk1ENkhJdVpUS21WNDVyVE9MV1JhdWdSaW9LM3hCSjBI?=
 =?utf-8?B?eWtzci95cXgraVlIelNoaTJCY0YzWTdURG9qZ1RIOWVXbC95T2oza016TUFO?=
 =?utf-8?B?YStRWWRTVnhWSlVwUVZsRytGU3ljWktlclJzc2trcDlCTVZHeURyQ0FqZVdR?=
 =?utf-8?B?YnFYN0RhVnRxOWo5TDRlelRoMmpqVDlVRWdaZ2VGZmkxdGlwUDJLdE5wSGpm?=
 =?utf-8?B?alNDUkNlS285T0xseEpDZXdKekEyYjhmczlWWXRuUlZSUEd2Vm1Fb3Z3S1l6?=
 =?utf-8?B?R3gwK0FhK2NDTFFqOUw2TitkYVJQSmVhQUhVR2pLVTFuU3BBWUlWNG91U3hh?=
 =?utf-8?B?Y0krMWRWWDFzMVpmTXgzeGdCWDlma3g4dzJiWFRQQVRaSlVYTmZKSEdvRzdh?=
 =?utf-8?B?dnN5Mi94azNkUHJjQmN3KzJKSFVQRm13QlJydHJucmJ5Uk1EdzBmMjRPc1NI?=
 =?utf-8?B?d0lDcm1PSFlPWEJHZUZtOHJOM2s4L2RJS3Evc0YrUExKMWxEb1p6UGE0YnJm?=
 =?utf-8?B?SGo2TzkvbEs5cVJoMjEyQmxEblZnaWY3Y3pJdlZlKytUaWdqYWxnLzgvbUhZ?=
 =?utf-8?B?V1U3NkI5VndkSmV4NFR0TmRjYzh0N1h6MTZjNEs4Q2t5amQ4UHZEVW1RSEhk?=
 =?utf-8?B?UzFIT3R4bUg0dmV1dWtST2RhRmJQa2JFWmNPMmxqeUpNUk83NGRJS3lDUWJQ?=
 =?utf-8?B?QUh3SU5TeWEyZHlNRDRBTTF5dWEzMXYxUysxU1lTb2tHMjMwWFpJZmpHZ3J4?=
 =?utf-8?Q?4BWOKvTuiazIIVFXQD?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f9e40fa8-7ae1-465a-18cc-08df231d518e
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Oct 2026 20:14:54.0759
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: M3glxzRebWa6E0S1b7e00+gfuVsJM42go0dWJggQ9c3jyiuGEdkeT2UWAeW6AhaO
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB7313
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 1B6D9140003
X-Rspam-User: 
X-Stat-Signature: btyh5r6kjwtznra4ir1j3dshu87849ot
X-HE-Tag: 1791231301-600407
X-HE-Meta: U2FsdGVkX19jfzrHR5q1pBY0JrmRJ4hbiaj2Q/WphF3iBhVLUbzyLkBtqERVvMUlmhIbx/CFQiXVezMkB2Ovf2q/Z3dJwm03LvnOhtd6PQsmlIlF8ZROrblxFDyHtef2GmtgeP3XfTYCj/RlXvC70Hsd6oekgUL9eXpSTLn3g433OSfps3nrDeuR1W0BRvgB3FDUuB5R011VMa7f8HOmlZSHlgM4hS+oefoJuFG22/dtL/4XIQ4yDaSOuOU87icOah9IamVUUbC2lry/yjS6stZ/lHLj7ASvMuCrxYCtWf1AGQ+Y/Ln3MOrO+HT1J2Y+a9MMo/BiwEGMjkb5AclmQ41K0g56wL09ErfSZuR0HuUXUcd10jFzLtUFF3zF7G8iYQL6vq8KQeVCYCQQSHPyE/HOKS9XKE61Vu7/2h4ElMmevF4nLVw6kAVCafQ7i1DjCFAv7jd3nLT82NfsDPOl6bHIZUR+HNkrd+q7B+Hd2PP/wtuCNHd2HgSD+SoRm60Us3Pg7I8eeRWcarDc1G954jhdgdXPvmYCCnt7AcLu5fUwGKIiSBUtb0QgIUt/4rqJD75L5Nzch9e+rsH8+2Kgrh1ULmnKm1FaAYpnj7YswvMv3Mliux6G9k4dq4L9JKGGwUL3FRxcfwcwjtTOlAc7t1Lo9shAenpw7vStT1hjWufEtbbC1fggGQnYwOR3AzFRtG6QfART4j9vErqHFB8aAzZFC6AodjjTUbR9BfCeJRbwiNHTw9Ft2YtahJ3R5KPnk3lv8kPY8lYZjOyn4Y+DUmqw1Uu3RfSIcRNE7ZQlRMQwAyL/9VzftsI2DaGeRnuVz9Kg0z9OQzqAvZ7E1s53pyrAqiZNF5QOsaE4tWUid2N1gNH2sfWShl0yL+rOIf5UIW4kfj/Cy1eqYme3PseCUsCYWfPo1eRvHuasxAIrYMB8V6M8I6nJGzGJUIS5kR55Xf7yWjGwYUc695walrc
 F5EuzNl2
 zUWcf5i40WdczhS0enmomgL0POzVJYuQ5qilPvjQaeq7dG+aR51DQgsQH14Fgtqijx+dYLP3m6enbLVVeyLD8lm0bNmKhOWubpPGHNKtIjhk77jy65iPuGp+m20sF39uI10eucgN2RaYPm1vVAJER3cY72CQsB4eunDy/J1TfIOzL43eJXVlx+Wt7s7CzgI6REtk4SyXJEIqKfURLqlZCBPcQCmLnC5j+uCf+Z3kyg1wHpbC8MXaN0DCVKmQqSSkG4WaSaI/OKfzrbwnvdDBnUv0+WudKLipFhFUI43P28Qq0nQXWE5wgXvAq3L293sSGwLs9z44o3sdZ53TYVyZnOEdBLvcywPnmAwR/uaag7q/beKC5dtcyLvHeI8KQU0VaZlmdSteBFCY+5Qu4eNj/djdTATwjsyZp8SXVmUi97BYfpO41nKqZ1Dm1Z6GAKxTuLfWiHHgsF/bbRaq/KEsxmf9nHw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri Oct 2, 2026 at 5:52 AM EDT, Usama Arif wrote:
> Prepare for keeping a PMD-mapped anonymous THP mapped by a PMD across the
> swap round-trip, which makes PG_anon_exclusive have to survive in a swap
> PMD and not just in a swap PTE.
>
> x86-64 encodes a swap PMD exactly like a swap PTE, so the new helpers reu=
se
> _PAGE_SWP_EXCLUSIVE, bit 3, which the swap-entry layout already reserves
> for PG_anon_exclusive. 32-bit x86 aliases that bit to _PAGE_PSE and does
> not select ARCH_HAS_PMD_SOFTLEAVES; assert that, because an exclusive swa=
p
> PMD would otherwise be pmd_present().
>
> Cc: Thomas Gleixner <tglx@kernel.org>
> Cc: Ingo Molnar <mingo@redhat.com>
> Cc: Borislav Petkov <bp@alien8.de>
> Cc: Dave Hansen <dave.hansen@linux.intel.com>
> Cc: x86@kernel.org
> Signed-off-by: Usama Arif <usama.arif@linux.dev>
> Reviewed-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
> Reviewed-by: David Hildenbrand (Arm) <david@kernel.org>
> ---
>  arch/x86/include/asm/pgtable.h | 20 ++++++++++++++++++++
>  1 file changed, 20 insertions(+)
>
> diff --git a/arch/x86/include/asm/pgtable.h b/arch/x86/include/asm/pgtabl=
e.h
> index d551120a7c889..c35dfa6ceda05 100644
> --- a/arch/x86/include/asm/pgtable.h
> +++ b/arch/x86/include/asm/pgtable.h
> @@ -1525,6 +1525,26 @@ static inline pte_t pte_swp_clear_exclusive(pte_t =
pte)
>  	return pte_clear_flags(pte, _PAGE_SWP_EXCLUSIVE);
>  }
> =20
> +#ifdef CONFIG_ARCH_HAS_PMD_SOFTLEAVES
> +/* 32-bit aliases this to _PAGE_PSE, making an exclusive swap PMD presen=
t. */

Is it better to say? Since the above comment sounds like 32-bit
specific, but the actual constraint is about not being _PAGE_PSE.

_PAGE_SWP_EXCLUSIVE cannot be _PAGE_PSE, otherwise making an exclusive
swap PMD present.

> +static_assert(_PAGE_SWP_EXCLUSIVE !=3D _PAGE_PSE);
> +
> +static inline pmd_t pmd_swp_mkexclusive(pmd_t pmd)
> +{
> +	return pmd_set_flags(pmd, _PAGE_SWP_EXCLUSIVE);
> +}
> +
> +static inline bool pmd_swp_exclusive(pmd_t pmd)
> +{
> +	return pmd_flags(pmd) & _PAGE_SWP_EXCLUSIVE;
> +}
> +
> +static inline pmd_t pmd_swp_clear_exclusive(pmd_t pmd)
> +{
> +	return pmd_clear_flags(pmd, _PAGE_SWP_EXCLUSIVE);
> +}
> +#endif
> +
>  #ifdef CONFIG_HAVE_ARCH_SOFT_DIRTY
>  static inline pte_t pte_swp_mksoft_dirty(pte_t pte)
>  {

Otherwise, LGTM.

Reviewed-by: Zi Yan <ziy@nvidia.com>]


--=20
Best Regards,
Yan, Zi


