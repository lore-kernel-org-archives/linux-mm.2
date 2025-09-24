Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0F033CAC59A
	for <linux-mm@archiver.kernel.org>; Wed, 24 Sep 2025 03:22:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4CCFF8E0008; Tue, 23 Sep 2025 23:22:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 47DA48E0001; Tue, 23 Sep 2025 23:22:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 31D868E0008; Tue, 23 Sep 2025 23:22:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 184338E0001
	for <linux-mm@kvack.org>; Tue, 23 Sep 2025 23:22:18 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id CF39311AAFA
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 03:22:17 +0000 (UTC)
X-FDA: 83922695514.09.06FA042
Received: from PH0PR06CU001.outbound.protection.outlook.com (mail-westus3azon11011018.outbound.protection.outlook.com [40.107.208.18])
	by imf25.hostedemail.com (Postfix) with ESMTP id CD261A000A
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 03:22:14 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=YoTyygcv;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf25.hostedemail.com: domain of ziy@nvidia.com designates 40.107.208.18 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758684135;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=j4liMyW9/6BlXbZZ0IatnLJhOlru74vRstilo5Fq7Bo=;
	b=P1Fh/OU+EdDNSgqMIVuZJtPrFqXq3uLiGSu6shLBU+it+vfLZeedW6f5cbkeiubBFrDYiK
	LAJ1HB04wulVV73c01GJo8p9ZxrruBKgj2xEIRwaDSZztY6DHnOBNTDOX4LCqQTwLoCEu3
	eVxfKCUpdtal3yyDqtLKrY4DbuyrKcU=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1758684135; a=rsa-sha256;
	cv=pass;
	b=vSMOG9CNjoNzPH39BOHOJRtuWGQci9tWNsO0XCKZaMs4YAuqIDe+TEX/NbdIg0JblC0NHj
	BHrFz7/JDjmu6cSMsHETZTUfoO8TWMERfBva+A1pHVxH82/JTS/QJGqyeyA2c92fADIwQw
	ueZZz/gAgjqfHiejBoTNlvUxeaywD5Q=
ARC-Authentication-Results: i=2;
	imf25.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=YoTyygcv;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf25.hostedemail.com: domain of ziy@nvidia.com designates 40.107.208.18 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=oc9c2r1m7gZOuqaU/xgXaqPyE2JWpxnKbhb/1KjattqZuppIWHe8FG/L7/zX6cIsZkoV5HIVIHUxbqNUtMtBLuAb4CT3aInl1Zqh/+Ar7wTakw0sxRmaEBKVY0vZB0biHgjvqfFWqe9OYFk2o+EJ1Ce+zyZMg5nHNSr4Aqtf//G6KFfwCAF77XeVc5CcYfYQVfpcD/SRxvxQ6c2TU7qNskktTg+cvuPov+2GUzcg3dx9v31TxCiMGbSBtlvMYXNI/dK0nx0hBup49DBBRZhvtvSTiVc80ipOsHjj4O9rosu2CA0hIX7hXp/Fw6ADQfPwJ64H8utvjemLrEr1aTQChw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=j4liMyW9/6BlXbZZ0IatnLJhOlru74vRstilo5Fq7Bo=;
 b=e1fppn7hpJ4fpvC0Jjbkt5lHwVJs1NXiz5jmyj1y4EO0J8NjoNMB8AX5V9uU/2xKAzrQPiKBFDgVpieFMKRnOiIMY7jc9PIoS7TbZnOR8FRnnK+txizp23NuDrTGZrm9k7ghZQwVEi6qlcjmweB8nA3Jbp9viUWBLfGV8ZYD8Id0q5rkdCFVrMxHclTmleO8M9GQFtgLBnKNhqxQcrYtgOOyvgaHQXNGHkrySLZLg2pR/rPHa8TUCkGt7y+uBHDgDNNRN1K3YOZ4Vm4/1dMlFUENzNUIWdCLOIhEpsBjjB85sSCJqC2k1QvT77Tjei8Auuu3wSkK7LKgKyDv8PXdWw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=j4liMyW9/6BlXbZZ0IatnLJhOlru74vRstilo5Fq7Bo=;
 b=YoTyygcv9RblcNPZHI5xwudjK/XuLdNZaheN7HFAXROsc8MqfLLtvWqNtQtKjUICDM1kWIhVlDqCyVnAShOOrju+w5GBmw6gkC5vs/EkFWyTeNyGcvYU3KI6wdxRPjg75MF083BGCc+SbHJ/qimANwaPbg/RsFufQekmwYz8hwD5M+wbHjBQN2HwsOKGt34nDMoJzGFNeHNMBWGBtwnNzv6j5O9Aa6mfhYOsn24DkDAsa6Upn9kBUx8eLIhY1oQagDOkw82hr4u0MoiAO6TRyWXihoA7f8sCM6KRRtPDgA7XeepJBIyLYGdQkDlQxzsccWg3Vh0Hx5+E0m6fhdyPOA==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 BL1PR12MB5707.namprd12.prod.outlook.com (2603:10b6:208:386::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9137.19; Wed, 24 Sep
 2025 03:22:09 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a%5]) with mapi id 15.20.9137.018; Wed, 24 Sep 2025
 03:22:09 +0000
From: Zi Yan <ziy@nvidia.com>
To: Shivank Garg <shivankg@amd.com>
Cc: akpm@linux-foundation.org, david@redhat.com, willy@infradead.org,
 matthew.brost@intel.com, joshua.hahnjy@gmail.com, rakie.kim@sk.com,
 byungchul@sk.com, gourry@gourry.net, ying.huang@linux.alibaba.com,
 apopple@nvidia.com, lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com,
 vbabka@suse.cz, rppt@kernel.org, surenb@google.com, mhocko@suse.com,
 vkoul@kernel.org, lucas.demarchi@intel.com, rdunlap@infradead.org,
 jgg@ziepe.ca, kuba@kernel.org, justonli@chromium.org, ivecera@redhat.com,
 dave.jiang@intel.com, Jonathan.Cameron@huawei.com, dan.j.williams@intel.com,
 rientjes@google.com, Raghavendra.KodsaraThimmappa@amd.com, bharata@amd.com,
 alirad.malek@zptcorp.com, yiannis@zptcorp.com, weixugc@google.com,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [RFC V3 0/9] Accelerate page migration with batch copying and
 hardware offload
Date: Tue, 23 Sep 2025 23:22:03 -0400
X-Mailer: MailMate (2.0r6272)
Message-ID: <633F4EFC-13A9-40DF-A27D-DBBDD0AF44F3@nvidia.com>
In-Reply-To: <20250923174752.35701-1-shivankg@amd.com>
References: <20250923174752.35701-1-shivankg@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: BL1PR13CA0362.namprd13.prod.outlook.com
 (2603:10b6:208:2c0::7) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|BL1PR12MB5707:EE_
X-MS-Office365-Filtering-Correlation-Id: 561f7acc-10cd-4f0d-f88c-08ddfb198bcc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|7416014|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?ckNpazF6Vm5TdVRQQ1pqaXZNZ1hzZEJacVB5ZjdTa2NlQTIrbWg5Sm1ISjNY?=
 =?utf-8?B?MzJpS2tDMW95b0lOZFpMSDdFb1FNUWtzWG9lMFltQWRkQXFGMGdkbUNYR2FL?=
 =?utf-8?B?YVV6aEttekVpMlhxWmU1VmdpczhrT3FlZHdURzBoekxYeGFlcDhtODA0ZVl5?=
 =?utf-8?B?MDh0M0dub2FJZFZYcm5hWnFNVk4ybkRKbzBpZUE5SmRZaUFqYlBLcnpxTytw?=
 =?utf-8?B?K01WWVNWempRdFJ4WXdRb0JNeTVJRnlCVGR0eDJCelZuTFZ2ZXdYRjR2T3V4?=
 =?utf-8?B?YngveXRlSXB5QXdvTFBESk9lVm9YZ1JkNmkrbU5iQjhrNGd6SmllTkNKSVpJ?=
 =?utf-8?B?UlhGNjZNdTAwUHBZQndic2tTdnlzb2MzWWtIam01YjRvU3owSmw2TVE1WXkv?=
 =?utf-8?B?Y1RCN29nRVpNNjE4SDdITmlMdmNlZzAzN29OLzhTTU9IMUNiN2VnRjF3RXU5?=
 =?utf-8?B?MUhyN0FPZlZBYWlsSjZVS2MzR2VWd2QvVWRoeXB5WGw2dWFJeU90MlZEWFdI?=
 =?utf-8?B?MS9pWkVYb0dPcEtwd0hDVjgzNE5pZldWcWNZQnpNVVl3YnZ4aXVvbzlDc0px?=
 =?utf-8?B?SFpDVHpzQnBwL2xVZ0gvbGxEM0FQZHBSdUllTitTTFNVY2VGRUxCYkdlYWVi?=
 =?utf-8?B?T0oySEVNcVVPYTd1a1lrY2c3Sy9FcXRmUmdja0oxbW40akQvS0FXeVM4bElu?=
 =?utf-8?B?c1VqNEVFQ0N2bTNRUTAzTXM3RDlCVlgyQSt2TU8xeHdLbU9vVWdIY0w4VnFu?=
 =?utf-8?B?RzBuVkM2cUNFWk1YR1krenhoYmwwazFNQ0dLNFdjV3p6djZnUndNS2ZuOUh1?=
 =?utf-8?B?alBFaCtOSGNPOWFrTnhWbmNDNFAxcGRVZlhSWG1kUGJ0Lzhqb2Vobk5MNzEz?=
 =?utf-8?B?MUxMQmFQeExTeGVyUmNJTFREb296Q01uN3BDL0JUK244WjFVSDBRdERYN09r?=
 =?utf-8?B?Q056SzVlbG5pQUdVZmV0RTZIMnk4QWpRa21WdzZzemtDaGdHb3B6aUI2TTBh?=
 =?utf-8?B?UUpMZ09OSUhud0g1TDRDdm5pVWI3MXdXdS9BSEZwM1IwUTNOWlZHM2lUbVFB?=
 =?utf-8?B?V05vNktHZ1NNR2U5QnJuYkRBdVB5RmtpU2wraGlvNWJJOEN4M1QwOGlyUGFo?=
 =?utf-8?B?MWhwaE12ajA2a0krOFZyV1ZUNXFzeDd4Q3JQaVFEaXZtK2svZ2FCZjU3NEMv?=
 =?utf-8?B?dktHZTBFYStlSUQ2ZEk2bVJyeXkvbnlESmVLSENRTmpudjFDYkRGSjEyUURs?=
 =?utf-8?B?bG9xaWtMdE1teTVWQ0xGOUM0SU5MY0JzdEFWSXhRWVprYjdHc1Z4d0FiMWdi?=
 =?utf-8?B?T0NGNHdyL1lkWDBXMjRpRnBGZ3BOZVFPZzUzYjFiS3pKNmMxN3BjMnBPWjBi?=
 =?utf-8?B?OGpjU2dQNUhIVzNkMmcrNGtlUjc4ZnVPdkFPSHNKUVNJWnZ6YUFrci8wdCtV?=
 =?utf-8?B?U0lCeW01VGlSNVhmdnl6eFNNcXdyMEkrK21tRXVWTDhVVW03ZmxCRis4Rkll?=
 =?utf-8?B?cktTTDI3ek1vRzU3czlrNTk5QjJRNUpXWEw1SWpRSWZBS3dlRnhOR2VVdDVC?=
 =?utf-8?B?cW41bnVkSkVJd3RWU1pMOG1QZjkzQ09weHNoWlpWWkJOOHY4bUFQbEVENk5s?=
 =?utf-8?B?MkhaMVpsRksxcWZ4dlh4TndhZXR0dmdyN1JZNkU3RUxmM0JickhxQkY5Y1Q0?=
 =?utf-8?B?YXJJeVNpUjRWUitVSDRTUGttZXZldC85TU9UYm54L3ZDV2o3dnZkeHFyNUww?=
 =?utf-8?B?WW8vMEF6RnpGM0JKMytOLzA5bmdqVWk0SlZISHRHaVdTL1JHYnp1ZHNzc1Bs?=
 =?utf-8?B?V1JDSU1pTnYrTWhFelVWMjBTdHpFNWllVHRpUm5BRUxValRqTUNUY0FpSTFs?=
 =?utf-8?B?RHNOeU9VWUg5M2lBMUdGeExwbVFnNDVKOHhOQW8zSU92MXNtUitid1A2ZHVy?=
 =?utf-8?Q?tYWbVqYjaxtZvwKoSUcoYSymKe9KovSC?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?MmxKRnM1SjA5ZUd4ZzQ1NEZNNFQrbXdPRTNpQzZ1TUtKdXlWaHdqWk02RDRB?=
 =?utf-8?B?VmoxUDlINzF4MjRLUUFNam5zWGl5R3lTNUtZVkVYT0ZiOWM1TzYza3ppS2p4?=
 =?utf-8?B?TndnTVRNeGZmSHlZanFaR2RwbjN5QW10YVhrWlNxQmhuSFVWSzMyR2l1dXVL?=
 =?utf-8?B?QVVINy9mUnJ1VnNnVWdzWk4xK0Y5cXE3MlJ3QVVHL0VmUjhjRE5jbHRUMlM5?=
 =?utf-8?B?Zm5YVnpCcnZOVHprMkE4dnptNXl6bnI0Wm5Qakl4QW8zRzBzZnZFQUpRSEVs?=
 =?utf-8?B?cWZtUU5CSS95ZjE5Qm94VG44RU1YaGZDVlprSUxjeFpyUHRrOFQrNzFjaWZi?=
 =?utf-8?B?MjE5Sk9kV1NRaGpabHEreDB1dHRhS0ROSzhtVEN3dnlpRHRRMXJxU2lOZVdI?=
 =?utf-8?B?MnFHT0N2ank3QVkvUzhLK0x3Ky9zWGw5enlpcDkvY3ZFK254Zk5yYXh5a0lH?=
 =?utf-8?B?d3NwQ0E5OVJhSHcvMXVMdFQzbWsycm1oUWRrSXlKTW14dDVEYzFDZDZyaS9l?=
 =?utf-8?B?M1lJbVJFNkh6TjNLMHJOaTNLdmFPRCt3b1kyaUROZGJvMDQ1RmZ4cmRCU2tH?=
 =?utf-8?B?SUZTUkNsNFI3cVNWZXdDajUyQ2hxcmFjK093ak1vTmhpWmYzaC80MjJ3Tkxi?=
 =?utf-8?B?OXFWb2tWTklWVzJsbHhOZ2J2TXo1UG9IYi9sZElNeThyYkU3OEdxb2VLZys0?=
 =?utf-8?B?SFFVNG52UWlPak5zZzYxUGVWb0RoVlFycFl4MVh1RWpadmkzdFZYWmxOWW9l?=
 =?utf-8?B?Wm5vdkxyK09sRWJhakV4Uk1wZGZOeVN6ZkpheithTGF1c1A1UWZsdmYyKyt2?=
 =?utf-8?B?S2RabzdQcVpjVEpnTDhrK3hmbDluSDNyekp1eC9aUEhoS1MwSlIxTGhHSnJC?=
 =?utf-8?B?NGhNQzV0R3N5L2pyY0JDeWpxaVVjRDlzTW5VSHF1N1ZsOWV0QWFsczdNSlZC?=
 =?utf-8?B?ZndtNzFkU1lDdmtMc0lkeUNmTjBLVWx4V0x6cW9IZUdOSzdLcVpLdjZoOHU2?=
 =?utf-8?B?SEp5S3RXM3lmTGlqYWtvTE9GeklobWI4TUVMSnQ5anY0QXNBMm5sM0U5TVRz?=
 =?utf-8?B?REdwK1dQL3M3b2dEM2MwNG1OZGdNSk0wdTJadUQveVhheUpkNGVmZnJCODg1?=
 =?utf-8?B?eTJ1SGtuRkt0R1Z1bEk4QUhxaHpsWDJ6SWRYdmpyVm9UbjBVTjN3UmM3enR6?=
 =?utf-8?B?RklSUm5LUWI4T2tQS2thSysrdk51ZG8xRWJzL3BiMmx1SkFMTUhScUNkamZj?=
 =?utf-8?B?Y1I0dXg2cU5IOGYzZTRFWnhiRy8zaU8yK0htZTZKVjVHSThKbVlFelBaaVJz?=
 =?utf-8?B?MFBJTW54RGhNTDd4ajBYb0tXRE1NYmJFb0oxdWovQjJyYVA1eTRsMTVLUWNT?=
 =?utf-8?B?YUtjYkwxVEE4RjdUZ0ZiYk9lKzRZcDVUUldENHZxWXpGell3T3Z2SGQwK05p?=
 =?utf-8?B?UXV5ejFja2xzWUc4RzFzWnZCZU91ZW8xa0hYN3VUdk9teERpdFFhc0gxTUNS?=
 =?utf-8?B?U2JTREFjRWJsbE9DL0oyK1RUMjREeWh5TDZmNGpWZGM2K05JenRsQmtiZzRP?=
 =?utf-8?B?K282bktXcExjQVFobklkUXQxTDdpQUZPK3gwWllaci9uaEdsdjBwK0gzWEFT?=
 =?utf-8?B?NTZJVC9lNHk1b0NaTFBEYmcxZlplREsvdHJHOVBkS2I1OHhCeG1rUXp5cG11?=
 =?utf-8?B?dGRxTmhUTUpXcjJUcE5oNXpPZmpFSjI5eXFCZm1lYVJZTVJIaDhYWWZDdnBL?=
 =?utf-8?B?Vys1TmN6Qy94MjNlYThtRHh0S1JBWHZ4dmpSckp6Vm11NWhpRURNMlpHN0Zu?=
 =?utf-8?B?VFp5cDhQMkRBa0EyZ1VZUnFiOVF4Q0pkbU04aHo2NVNMNCtielVlZDMxMVYw?=
 =?utf-8?B?M290N1ZBcktaN0oyeTkrdnhDOU5PYzViemZQVmZCWjl3RXU1QklQYnFTZmps?=
 =?utf-8?B?RDhTczZCSGNrVzdlZlh2dWUrUmVkTVY5c1MxY0ZkUjR6OXVjODZhUW96TG04?=
 =?utf-8?B?cU5WaW5uNThOTStLUW4rSHJUdisxMnhMWXVnOGZkRXlYV0ltZGtuZHJvTytn?=
 =?utf-8?B?Sml4ckQ4ZnBWN0k1R1NRVGVvMkdDc252S1I2bkd5MXJwU2hneXBISzQ4YmlL?=
 =?utf-8?Q?g6xrtP/DyvIxwNAn9Ca0I72pz?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 561f7acc-10cd-4f0d-f88c-08ddfb198bcc
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Sep 2025 03:22:09.6655
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: aJZa/vK/qZ3r1wGWccNtFbG9/azl3uq6TYRuWpd9VHTUP0KAlnxtqxYY089YFubQ
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5707
X-Stat-Signature: 8oy7s6hiu9bmrmzi5xsjm6fna14oyg8g
X-Rspamd-Queue-Id: CD261A000A
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1758684134-119621
X-HE-Meta: U2FsdGVkX18R4iCDeslWxJ1lRUJTzNT73Wdah/P6z+ZSJSY79nzKnD9D88b58nPrvbPW+3ZOUz0Gsult+ZHnrAOd7qvAY7ZxmEdNqc9yvhvSEpNoauoVj9O8kJpbgQ5g67KoNRBY20Qy1qfLVmH5TCWhzjiRXKGNlcXzx/g5B/ZWvL26HdyUfxRY9NyXNiB59uIAC2xzZmKaa4G5OPcIqVpcKhh0CFKtvDrMoDc5ne0Hy6C9UL/Y0xgZZwaCte9pPJxS9Og2GJzPE3jAUZEFhaJjIuSMJl4iKcygZDlPJacMmSJBx8euNMZOoLk6y9ganZ4g0tKY5B1xDnTa/+p8AE0fDtqM2gbTAAq0zrIfLywLqfyFUMFw8MwBR422gfHI+A04ihtlA4tjF+l28lRiOcU8en96/de+U9yDLn8kO3POV+8kfuz2KyiyanHJSW08GRB9hUVN1sDN4+kpjI0agIxA+JCENpBGHUDE9qlBcBLqUMJAl9yTEb356sGZesSp4sNc70bbW22xpbmXt5S+JIwhgB9a0Keoed59Cyv6Nr/5aUr1vLATzu9QX1iH4ure6Ko9Vx2IMCpEAllPNxd6H4WMxROxrRWTKynB0GAMlYwmuXfvIQH7V6snqK7rzIMuUZ9xMhn5YJRIXPrSW7sNqyTLgm7FkXwFF2U3s6wBdwo89H5rUXszbGj7QCeGTOIsNF8AqGm0a/XEbvs7zo+33Osieo1ggwnVnQ8WOGQUeX3zjAc5TfTERdfpOta0DjUT4vM+8yzUoMpsl/M0yFjGpsd1QGY/Q9Fuk+ojyUMwogYLJD0fUrbgnRfKcpiwpUsWhzJ0DmYnWnMtFgX1CC4OlrV2osLJBujNOpifzxaa1yRXWdFPoT0wnj5a6XhN3QOQZYkO/lEQhQgG0p+bGVFv8Vx59c7KvLf+TegrEcI8J/mvrISd9SJ8CzkaMQtkgBAmK8eMKO3hyNxqgoV7iTq
 acN+COKP
 2SXg286oLcnZuh5QfNNUefhQqayyzzNwwQ/y9mSMSpkJBYROqXGd1CMMuMGglxlAX6EvznDynpSlJQQ/5U8mfAtuMdGzAoFdwSOBw3bsWmj6du86IPTB9BIRlIVWIbvAFNxVu8o0vNGhL0R8e+0xZQWS81Ik/GhjG+1gOHrQtcjvwIX21Z7HNvJ2rLXhBWH/I4dQCzHweCxLeZS4P+lKBYEH+XrAwDGVKtkeK7rcba9DKVVJxgUg8eEQAlpTHYySo1/3v69SwXtVRIhseVza9ULFpCTw3VGTojrRA0UF//lzeYk4QNjIYdmeWNg+z6pr2ky3platPdf158jdzKeZ8exT3sSPZxMpLKpwi6cOVrLtbw79DPCqIQ3e6rMK+QPiOlCTAQmzG3xBqSu5ssgK4rdWQ0OGGgG6H0JkPJjqvGrs0zqcWxPLAc1OS4QX1rCKhKUR2ozrAfy8LZsYB+1p1hX2N3VgXtAb4P1vLmU394PLyzrs2YoCDq2BOLuFM4wEWgk1bg5nbRYkFP1KO137WHfEClJ1R+7hniGF91M4ccs04iRUTxwdUOuNYGDRe7OwWui48beEhmgCtyid+Nf3GeUy5+gq6ns0o6wG1fuJJdT4sIb1MP+qwEqOw4vxjhpWW63qfL/XHFgEXSi1wHjN3yz+4yw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 23 Sep 2025, at 13:47, Shivank Garg wrote:

> This is the third RFC of the patchset to enhance page migration by batchi=
ng
> folio-copy operations and enabling acceleration via multi-threaded CPU or
> DMA offload.
>
> Single-threaded, folio-by-folio copying bottlenecks page migration
> in modern systems with deep memory hierarchies, especially for large
> folios where copy overhead dominates, leaving significant hardware
> potential untapped.
>
> By batching the copy phase, we create an opportunity for significant
> hardware acceleration. This series builds a framework for this accelerati=
on
> and provides two initial offload driver implementations: one using multip=
le
> CPU threads (mtcopy) and another leveraging the DMAEngine subsystem (dcbm=
).
>
> This version incorporates significant feedback to improve correctness,
> robustness, and the efficiency of the DMA offload path.
>
> Changelog since V2:
>
> 1. DMA Engine Rewrite:
>    - Switched from per-folio dma_map_page() to batch dma_map_sgtable()
>    - Single completion interrupt per batch (reduced overhead)
>    - Order of magnitude improvement in setup time for large batches
> 2. Code cleanups and refactoring
> 3. Rebased on latest mainline (6.17-rc6+)

Thanks for working on this.

It is better to rebase on top of Andrew=E2=80=99s mm-new tree.

I have a version at: https://github.com/x-y-z/linux-dev/tree/batched_page_m=
igration_copy_amd_v3-mm-everything-2025-09-23-00-13.

The difference is that I changed Patch 6 to use padata_do_multithreaded()
instead of my own implementation, since padata is a nice framework
for doing multithreaded jobs. The downside is that your patch 9
no longer applies and you will need to hack kernel/padata.c to
achieve the same thing.

I also tried to attribute back page copy kthread time to the initiating
thread so that page copy time does not disappear when it is parallelized
using CPU threads. It is currently a hack in the last patch from
the above repo. With the patch, I can see system time of a page migration
process with multithreaded page copy looks almost the same as without it,
while wall clock time is smaller. But I have not found time to ask
scheduler people about a proper implementation yet.


>
> MOTIVATION:
> -----------
>
> Current Migration Flow:
> [ move_pages(), Compaction, Tiering, etc. ]
>               |
>               v
>      [ migrate_pages() ] // Common entry point
>               |
>               v
>     [ migrate_pages_batch() ] // NR_MAX_BATCHED_MIGRATION (512) folios at=
 a time
>       |
>       |--> [ migrate_folio_unmap() ]
>       |
>       |--> [ try_to_unmap_flush() ] // Perform a single, batched TLB flus=
h
>       |
>       |--> [ migrate_folios_move() ] // Bottleneck: Interleaved copy
>            - For each folio:
>              - Metadata prep: Copy flags, mappings, etc.
>              - folio_copy()  <-- Single-threaded, serial data copy.
>              - Update PTEs & finalize for that single folio.
>
> Understanding overheads in page migration (move_pages() syscall):
>
> Total move_pages() overheads =3D folio_copy() + Other overheads
> 1. folio_copy() is the core copy operation that interests us.
> 2. The remaining operations are user/kernel transitions, page table walks=
,
> locking, folio unmap, dst folio alloc, TLB flush, copying flags, updating
> mappings and PTEs etc. that contribute to the remaining overheads.
>
> Percentage of folio_copy() overheads in move_pages(N pages) syscall time:
> Number of pages being migrated and folio size:
>             4KB     2MB
> 1 page     <1%     ~66%
> 512 page   ~35%    ~97%
>
> Based on Amdahl's Law, optimizing folio_copy() for large pages offers a
> substantial performance opportunity.
>
> move_pages() syscall speedup =3D 1 / ((1 - F) + (F / S))
> Where F is the fraction of time spent in folio_copy() and S is the speedu=
p of
> folio_copy().
>
> For 4KB folios, folio copy overheads are significantly small in single-pa=
ge
> migrations to impact overall speedup, even for 512 pages, maximum theoret=
ical
> speedup is limited to ~1.54x with infinite folio_copy() speedup.
>
> For 2MB THPs, folio copy overheads are significant even in single page
> migrations, with a theoretical speedup of ~3x with infinite folio_copy()
> speedup and up to ~33x for 512 pages.
>
> A realistic value of S (speedup of folio_copy()) is 7.5x for DMA offload
> based on my measurements for copying 512 2MB pages.
> This gives move_pages(), a practical speedup of 6.3x for 512 2MB page (al=
so
> observed in the experiments below).
>
> DESIGN: A Pluggable Migrator Framework
> ---------------------------------------
>
> Introduce migrate_folios_batch_move():
>
> [ migrate_pages_batch() ]
>     |
>     |--> migrate_folio_unmap()
>     |
>     |--> try_to_unmap_flush()
>     |
>     +--> [ migrate_folios_batch_move() ] // new batched design
>             |
>             |--> Metadata migration
>             |    - Metadata prep: Copy flags, mappings, etc.
>             |    - Use MIGRATE_NO_COPY to skip the actual data copy.
>             |
>             |--> Batch copy folio data
>             |    - Migrator is configurable at runtime via sysfs.
>             |
>             |          static_call(_folios_copy) // Pluggable migrators
>             |          /          |            \
>             |         v           v             v
>             | [ Default ]  [ MT CPU copy ]  [ DMA Offload ]
>             |
>             +--> Update PTEs to point to dst folios and complete migratio=
n.
>
>
> User Control of Migrator:
>
> # echo 1 > /sys/kernel/dcbm/offloading
>    |
>    +--> Driver's sysfs handler
>         |
>         +--> calls start_offloading(&cpu_migrator)
>               |
>               +--> calls offc_update_migrator()
>                     |
>                     +--> static_call_update(_folios_copy, mig->migrate_of=
fc)
>
> Later, During Migration ...
> migrate_folios_batch_move()
>     |
>     +--> static_call(_folios_copy) // Now dispatches to the selected migr=
ator
>           |
>           +-> [ mtcopy | dcbm | kernel_default ]
>
>
> PERFORMANCE RESULTS:
> --------------------
>
> System Info: AMD Zen 3 EPYC server (2-sockets, 32 cores, SMT Enabled),
> 1 NUMA node per socket, Linux Kernel 6.16.0-rc6, DVFS set to Performance,
> PTDMA hardware.
>
> Benchmark: Use move_pages() syscall to move pages between two NUMA nodes.
>
> 1. Moving different sized folios (4KB, 16KB,..., 2MB) such that total tra=
nsfer size is constant
> (1GB), with different number of parallel threads/channels.
> Metric: Throughput is reported in GB/s.
>
> a. Baseline (Vanilla kernel, single-threaded, folio-by-folio migration):
>
> Folio size|4K       | 16K       | 64K        | 128K       | 256K       | =
512K       | 1M         | 2M         |
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> Tput(GB/s)|3.73=C2=B10.33| 5.53=C2=B10.36 | 5.90=C2=B10.56  | 6.34=C2=B10=
.08  | 6.50=C2=B10.05  | 6.86=C2=B10.61  | 6.92=C2=B10.71  | 10.67=C2=B10.3=
6 |
>
> b. Multi-threaded CPU copy offload (mtcopy driver, use N Parallel Threads=
=3D1,2,4,8,12,16):
>
> Thread | 4K         | 16K       | 64K        | 128K       | 256K       | =
512K       | 1M         | 2M         |
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> 1      | 3.84=C2=B10.10  | 5.23=C2=B10.31 | 6.01=C2=B10.55  | 6.34=C2=B10=
.60  | 7.16=C2=B11.00  | 7.12=C2=B10.78  | 7.10=C2=B10.86  | 10.94=C2=B10.1=
3 |
> 2      | 4.04=C2=B10.19  | 6.72=C2=B10.38 | 7.68=C2=B10.12  | 8.15=C2=B10=
.06  | 8.45=C2=B10.09  | 9.29=C2=B10.17  | 9.87=C2=B11.01  | 17.80=C2=B10.1=
2 |
> 4      | 4.72=C2=B10.21  | 8.41=C2=B10.70 | 10.08=C2=B11.67 | 11.44=C2=B1=
2.42 | 10.45=C2=B10.17 | 12.60=C2=B11.97 | 12.38=C2=B11.73 | 31.41=C2=B11.1=
4 |
> 8      | 4.91=C2=B10.28  | 8.62=C2=B10.13 | 10.40=C2=B10.20 | 13.94=C2=B1=
3.75 | 11.03=C2=B10.61 | 14.96=C2=B13.29 | 12.84=C2=B10.63 | 33.50=C2=B13.2=
9 |
> 12     | 4.84=C2=B10.24  | 8.75=C2=B10.08 | 10.16=C2=B10.26 | 10.92=C2=B1=
0.22 | 11.72=C2=B10.14 | 14.02=C2=B12.51 | 14.09=C2=B12.65 | 34.70=C2=B12.3=
8 |
> 16     | 4.77=C2=B10.22  | 8.95=C2=B10.69 | 10.36=C2=B10.26 | 11.03=C2=B1=
0.22 | 11.58=C2=B10.30 | 13.88=C2=B12.71 | 13.00=C2=B10.75 | 35.89=C2=B12.0=
7 |
>
> c. DMA offload (dcbm driver, use N DMA Channels=3D1,2,4,8,12,16):
>
> Chan Cnt| 4K        | 16K       | 64K        | 128K       | 256K       | =
512K       | 1M         | 2M         |
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> 1      | 2.75=C2=B10.19  | 2.86=C2=B10.13 | 3.28=C2=B10.20  | 4.57=C2=B10=
.72  | 5.03=C2=B10.62  | 4.69=C2=B10.25  | 4.78=C2=B10.34  | 12.50=C2=B10.2=
4 |
> 2      | 3.35=C2=B10.19  | 4.57=C2=B10.19 | 5.35=C2=B10.55  | 6.71=C2=B10=
.71  | 7.40=C2=B11.07  | 7.38=C2=B10.61  | 7.21=C2=B10.73  | 14.23=C2=B10.3=
4 |
> 4      | 4.01=C2=B10.17  | 6.36=C2=B10.26 | 7.71=C2=B10.89  | 9.40=C2=B11=
.35  | 10.27=C2=B11.96 | 10.60=C2=B11.42 | 12.35=C2=B12.64 | 26.84=C2=B10.9=
1 |
> 8      | 4.46=C2=B10.16  | 7.74=C2=B10.13 | 9.72=C2=B11.29  | 10.88=C2=B1=
0.16 | 12.12=C2=B12.54 | 15.62=C2=B13.96 | 13.29=C2=B12.65 | 45.27=C2=B12.6=
0 |
> 12     | 4.60=C2=B10.22  | 8.90=C2=B10.84 | 11.26=C2=B12.19 | 16.00=C2=B1=
4.41 | 14.90=C2=B14.38 | 14.57=C2=B12.84 | 13.79=C2=B13.18 | 59.94=C2=B14.1=
9 |
> 16     | 4.61=C2=B10.25  | 9.08=C2=B10.79 | 11.14=C2=B11.75 | 13.95=C2=B1=
3.85 | 13.69=C2=B13.39 | 15.47=C2=B13.44 | 15.44=C2=B14.65 | 63.69=C2=B15.0=
1 |
>
> - Throughput increases with folio size. Larger folios benefit more from D=
MA.
> - Scaling shows diminishing returns beyond 8-12 threads/channels.
> - Multi-threading and DMA offloading both provide significant gains - up =
to 3.4x and 6x respectively.
>
> 2. Varying total move size: (folio count =3D 1,8,..8192) for a fixed foli=
o size of 2MB
>    using only single thread/channel
>
> folio_cnt | Baseline    | MTCPU      | DMA
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D
> 1         | 7.96=C2=B12.22   | 6.43=C2=B10.66  | 6.52=C2=B10.45   |
> 8         | 8.20=C2=B10.75   | 8.82=C2=B11.10  | 8.88=C2=B10.54   |
> 16        | 7.54=C2=B10.61   | 9.06=C2=B10.95  | 9.03=C2=B10.62   |
> 32        | 8.68=C2=B10.77   | 10.11=C2=B10.42 | 10.17=C2=B10.50  |
> 64        | 9.08=C2=B11.03   | 10.12=C2=B10.44 | 11.21=C2=B10.24  |
> 256       | 10.53=C2=B10.39  | 10.77=C2=B10.28 | 12.43=C2=B10.12  |
> 512       | 10.59=C2=B10.29  | 10.81=C2=B10.19 | 12.61=C2=B10.07  |
> 2048      | 10.86=C2=B10.26  | 11.05=C2=B10.05 | 12.75=C2=B10.03  |
> 8192      | 10.84=C2=B10.18  | 11.12=C2=B10.05 | 12.81=C2=B10.02  |
>
> - Throughput increases with folios count but plateaus after a threshold.
>   (The migrate_pages function uses a folio batch size of 512)
>
> Performance Analysis (V2 vs V3):
>
> The new SG-based DMA driver dramatically reduces software overhead. By
> switching from per-folio dma_map_page() to batch dma_map_sgtable(), setup
> time improves by an order of magnitude for large batches.
> This is most visible with 4KB folios, making DMA viable even for smaller
> page sizes. For 2MB THP migrations, where hardware transfer time is more
> dominant, the gains are more modest.
>
> OPEN QUESTIONS:
> ---------------
>
> User-Interface:
>
> 1. Control Interface Design:
> The current interface creates separate sysfs files
> for each driver, which can be confusing. Should we implement a unified in=
terface
> (/sys/kernel/mm/migration/offload_migrator), which accepts the name of th=
e desired migrator
> ("kernel", "mtcopy", "dcbm"). This would ensure only one migrator is acti=
ve at a time.
> Is this the right approach?
>
> 2. Dynamic Migrator Selection:
> Currently, active migrator is a global state, and only one can be active =
a time.
> A more flexible approach might be for the caller of migrate_pages() to sp=
ecify/hint which
> offload mechanism to use, if any. This would allow a CXL driver to explic=
itly request DMA while a GPU driver might prefer
> multi-threaded CPU copy.
>
> 3. Tuning Parameters: Expose parameters like number of threads/channels, =
batch size,
> and thresholds for using migrators. Who should own these parameters?
>
> 4. Resources Accounting[3]:
> a. CPU cgroups accounting and fairness
> b. Migration cost attribution
>
> FUTURE WORK:
> ------------
>
> 1. Enhance DMA drivers for bulk copying (e.g., SDXi Engine).
> 2. Enhance multi-threaded CPU copying for platform-specific scheduling of=
 worker threads to optimize bandwidth utilization. Explore sched-ext for th=
is. [2]
> 3. Enable kpromoted [4] to use the migration offload infrastructure.
>
> EARLIER POSTINGS:
> -----------------
>
> - RFC V2: https://lore.kernel.org/all/20250319192211.10092-1-shivankg@amd=
.com
> - RFC V1: https://lore.kernel.org/all/20240614221525.19170-1-shivankg@amd=
.com
>
> REFERENCES:
> -----------
>
> [1] RFC from Zi Yan: https://lore.kernel.org/all/20250103172419.4148674-1=
-ziy@nvidia.com
> [2] LSFMM: https://lore.kernel.org/all/cf6fc05d-c0b0-4de3-985e-5403977aa3=
aa@amd.com
> [3] https://lore.kernel.org/all/CAHbLzkpoKP0fVZP5b10wdzAMDLWysDy7oH0qaUss=
iUXj80R6bw@mail.gmail.com
> [4] https://lore.kernel.org/all/20250910144653.212066-1-bharata@amd.com
>
> Mike Day (1):
>   mm: add support for copy offload for folio Migration
>
> Shivank Garg (4):
>   mm: Introduce folios_mc_copy() for batch copying folios
>   mm/migrate: add migrate_folios_batch_move to  batch the folio move
>     operations
>   dcbm: add dma core batch migrator for batch page offloading
>   mtcopy: spread threads across die for testing
>
> Zi Yan (4):
>   mm/migrate: factor out code in move_to_new_folio() and
>     migrate_folio_move()
>   mm/migrate: revive MIGRATE_NO_COPY in migrate_mode
>   mtcopy: introduce multi-threaded page copy routine
>   adjust NR_MAX_BATCHED_MIGRATION for testing
>
>  drivers/Kconfig                        |   2 +
>  drivers/Makefile                       |   3 +
>  drivers/migoffcopy/Kconfig             |  17 +
>  drivers/migoffcopy/Makefile            |   2 +
>  drivers/migoffcopy/dcbm/Makefile       |   1 +
>  drivers/migoffcopy/dcbm/dcbm.c         | 415 +++++++++++++++++++++++++
>  drivers/migoffcopy/mtcopy/Makefile     |   1 +
>  drivers/migoffcopy/mtcopy/copy_pages.c | 397 +++++++++++++++++++++++
>  include/linux/migrate_mode.h           |   2 +
>  include/linux/migrate_offc.h           |  34 ++
>  include/linux/mm.h                     |   2 +
>  mm/Kconfig                             |   8 +
>  mm/Makefile                            |   1 +
>  mm/migrate.c                           | 358 ++++++++++++++++++---
>  mm/migrate_offc.c                      |  58 ++++
>  mm/util.c                              |  29 ++
>  16 files changed, 1284 insertions(+), 46 deletions(-)
>  create mode 100644 drivers/migoffcopy/Kconfig
>  create mode 100644 drivers/migoffcopy/Makefile
>  create mode 100644 drivers/migoffcopy/dcbm/Makefile
>  create mode 100644 drivers/migoffcopy/dcbm/dcbm.c
>  create mode 100644 drivers/migoffcopy/mtcopy/Makefile
>  create mode 100644 drivers/migoffcopy/mtcopy/copy_pages.c
>  create mode 100644 include/linux/migrate_offc.h
>  create mode 100644 mm/migrate_offc.c
>
> --=20
> 2.43.0


Best Regards,
Yan, Zi

