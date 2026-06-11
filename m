Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7E7A1CD98C6
	for <linux-mm@archiver.kernel.org>; Thu, 11 Jun 2026 01:49:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8C9206B0005; Wed, 10 Jun 2026 21:49:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 852966B0088; Wed, 10 Jun 2026 21:49:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6CBA96B008C; Wed, 10 Jun 2026 21:49:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 541A26B0005
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 21:49:34 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id EBC1140443
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 01:49:33 +0000 (UTC)
X-FDA: 84865949826.15.01F55B5
Received: from CH4PR04CU002.outbound.protection.outlook.com (mail-northcentralusazon11013062.outbound.protection.outlook.com [40.107.201.62])
	by imf06.hostedemail.com (Postfix) with ESMTP id 0652118000A
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 01:49:30 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=e3PTViMj;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf06.hostedemail.com: domain of ziy@nvidia.com designates 40.107.201.62 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781142571;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jm4PR3so/bNRSuxVVewp6sed5e89IjimRxHFCVa042E=;
	b=QAnix9h9RJpEbzB29rH5GoPT4/Z93OC/Yq9uddMbkB+3fZyzf2vnUbCAV/9yxaTwnaoMzu
	J40V0X1sBo2yPuQhAfKREGYHzDFjIv7ukSXH2fJeEwDdrWuMXGNTI0HCLGqpBWxFIi2AZS
	IJLVStk4V+lyDrubMVfcZW+s91nJ1xY=
ARC-Authentication-Results: i=2;
	imf06.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=e3PTViMj;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf06.hostedemail.com: domain of ziy@nvidia.com designates 40.107.201.62 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1781142571;
	b=k2ofuCRpOge5uckxPQjUwZLZ+yWA3YxCkzNs6jJNvuZjv8bBco2LCUecKZLF/mdE5jFFxC
	irdHdyPbl5qcfiU939fNZDu/J/D5GrNieAWyFIfVtkUOZ3cevIQr/yFXCBveDw99nCsqXr
	DvIakRzRRUD88ERsaVJsm5oxQuWIyAg=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=jWd3Ca3NofCD5vfK5nu6YlIQiryUBZMcO27FU0lNT5kqglkctjHvAoad0/JntgWRhWa7InrJK2CFsZSuISRRpbolfvOyB5Q7tI4FtpvaBXaFdpy9XkwzfRNwRv+6A1lkexY+NCpa+FED0o81ZpoZw6lJaGsYnIKm76enbJrwysLaQ6vdCM/jkUFC3ttaC4CcSj+4gXcoaJV+NUWcrx7lnx7MOW8fNvWYOydJ6cltmqvLt8S9TBKYgai3K3hQSOgCfL88XUBXhvD7/XQsWmEmCAx+q5mp4DicvAYgOvRj6wSvPmB+zu6y5NiR2xRDmz9kQW2pVyXA1gA3qws0h+BTbQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jm4PR3so/bNRSuxVVewp6sed5e89IjimRxHFCVa042E=;
 b=yKWHFDeXUqI45i7T0YWRQwG1OaKxmOySS9CbXqnCM+hFfFS5pVUbYf6CtRSrNRJm/weZ16xCLfLDqnSe7ZbxFZxnQUTXgTdOiAS6nPlIb3/VLxPfr5OeC4L8vPrsRFnF1LlDiRkSEGzYZtj3Wo9qBXetGZBJET+JZYzMiexHQvV+LvmPj3t42/4Xg9EKj7Vo06Q705rzmyBt7qLKMl+Q0LfSH00hXcR80AKcG74Go3wgz3QAZ1OCho6BROzsytfQyM1Q/moDq2RE3e/GuOhZXewyKuJjy7Q4Kcng87QMfM4dbGPS2hAacrOEfO7S9hX3eVHezYdHHuFwa2ijzhr47g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jm4PR3so/bNRSuxVVewp6sed5e89IjimRxHFCVa042E=;
 b=e3PTViMjI3OP/XOHeP//JYonlZ1vE9RBKns85L1uUkAaw8aNPkpoYlWdPtClN/PjppYwONqc5E1zxIuwQEBKoNVLo6LlIwvT3O+1P1KgsEi/7SMTOhwP8aJG/1tQ1qhBegv0rMaKNaxG5rkHxh1Cj7A7wXsSzZB1R7o18gBQM9XnKpMisA5m4D8NO2Vgi0yVZhsy6fSwWaq9aS9hqrMJ0Hpwp70Fj3J8ZGZW2+xTRTC5ucNjD+lT9fh9frDcEV8e7C2BvukyNOECEtZQPYG4kaLznEP+h9xX5+YMyx4tAVDqX5NpHwJKXSD4FWUDOEnAblXGjkwvDdar2vBkixN81A==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 CY5PR12MB6057.namprd12.prod.outlook.com (2603:10b6:930:2e::17) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.113.13; Thu, 11 Jun 2026 01:49:25 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2%5]) with mapi id 15.21.0092.011; Thu, 11 Jun 2026
 01:49:25 +0000
From: Zi Yan <ziy@nvidia.com>
To: Zhaoyang Huang <huangzhaoyang@gmail.com>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>,
 "zhaoyang.huang" <zhaoyang.huang@unisoc.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Barry Song <baohua@kernel.org>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 Lance Yang <lance.yang@linux.dev>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, steve.kang@unisoc.com,
 xiuhong.wang@unisoc.com, hao_hao.wang@unisoc.com
Subject: Re: [RFC PATCH] mm/huge_memory: do not add dropped split tail folios
 to LRU
Date: Wed, 10 Jun 2026 21:49:22 -0400
X-Mailer: MailMate (2.0r6290)
Message-ID: <C606D56E-9133-42BB-9118-054E3F623978@nvidia.com>
In-Reply-To: <CAGWkznFfRnPg_FC9mjHKSUOJaj4Gjm5VQkMQ2tgY7fZ8Xuju9Q@mail.gmail.com>
References: <20260610120535.2370844-1-zhaoyang.huang@unisoc.com>
 <b5393993-e75d-4e67-8dc2-85c9659ad27e@kernel.org>
 <4348A64F-30F9-4497-A839-A80BCFFCFFE0@nvidia.com>
 <12FE92F3-B8C3-4D4E-B86A-CC2034734466@nvidia.com>
 <F21E44A9-0FB7-47F8-86CC-6D38FD2CD24B@nvidia.com>
 <CAGWkznFfRnPg_FC9mjHKSUOJaj4Gjm5VQkMQ2tgY7fZ8Xuju9Q@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: YQBPR0101CA0238.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:66::18) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|CY5PR12MB6057:EE_
X-MS-Office365-Filtering-Correlation-Id: 9afc9e94-d3d8-41ca-2c53-08dec75baac0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|10070799003|1800799024|366016|376014|7416014|23010399003|22082099003|18002099003|56012099006|5023799004|11063799006|4143699003|6133799003;
X-Microsoft-Antispam-Message-Info:
	BLeWyrs5MOyzp2Y/LUAbM+j1ksiCdBWRy1SCYY7SAd2x3gp3KGbMeQLLQ7jW8xeLXm6EQ3DPzP44U2JtnAaGmQjPhUJ4yBQ8NSB+mvT7E9bu0q7d+58g0eskn06EfAFcWQCSG5/HjQ4FBuuMJM5yJtTV+piUbftIl5O1hlqG775pIi05skW/kJnPZtnl+Hm+/X3KbW17UqzvDeLGoy04DlyotZuF8ucroVmFVHqrUygvcfD94jTJqJI2pzzCCdHblAIbSFstueaD4hbl6PhpPbDpEhlHpyM/VJd2xT7xDMGM47SHqfAf0IPXgGjv1EvaVxbUKqo8IPK/jyD83bc2uTpd/hpqdqih68P/YefKe3eP/tBkR/kzDy5v4c5ohUYQvkmdJnKedHVN+4zVuVh5etNOmnIxaG4gcBeL375CvRqrMFfqAvZNOhVlYs3WvcpP0UrIW/aBZ3dd71c6IH9HGq/97r+5RAcraNAVq8PulBAYgkNmvKhcLVF1i9dCHlqfFBOveDAZCruHp/Q+5H0vgVjUKOqdntDKR+2/bWr9FrYxNQ15ovg46DKfQiIox5K2IZ7maKade6HDEq8KfI+iGt00uWuRGYAlDxDT/cCjisi5p2OsyV1dlfLtzZUsEVo6a91ZTz4xiw9sjLVQDlJnBNYxiCls4DFzXUL5HjH3YZSqJYenj/Dodqx9q1u5FiRM
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(10070799003)(1800799024)(366016)(376014)(7416014)(23010399003)(22082099003)(18002099003)(56012099006)(5023799004)(11063799006)(4143699003)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?LytsMzdidE9LUDRjM3g2NkZYTE12MmpreFAyM09VZm9YV3U2N21oY05OK3p2?=
 =?utf-8?B?OStpcHNWbFJ6c25tTUxPZUlmbUN5cHE3YU1mckF1R0h1ZkhJUXNUSzFnNzkx?=
 =?utf-8?B?QkZWVDE3eHlPbXlCWEdlOWJqRHVtczNiZTZRdE0yVmQ5VGFIdnFWR0RRQzJ3?=
 =?utf-8?B?V2xVOE05QktVR2U0M25EUVN5bDhIK3ZRNEZpZ1FQMUdHanhZUlRvNEovc0d5?=
 =?utf-8?B?NmtzWE11ZFJPcU53WkUycjh6Lys0OThndjE3SC9Ea2paUVVSM2xNRkV4MkF2?=
 =?utf-8?B?MnR3SW5ydWpiZHdOSXpYZXhYRDZLT2xPbDhxQkVlcVVKa3VDYkxvb0dkS054?=
 =?utf-8?B?R3BGYmh3THM0cHNIbWN5Q1BxU3pwU2c1TlVoVVdUeDliUlZkY0xadXEvUDV4?=
 =?utf-8?B?dmIzS0o3T3prMFJBMUhSMUdUOEJPaXdaQkp2UnJJMklEYno2ZjI2R0V3QWlN?=
 =?utf-8?B?aDQxd3FsY3BLR01XQW9wcGFiRUc5MnZ2OHZMQ3VXQjdQRDd0NWZFNXNtNFJF?=
 =?utf-8?B?S21USUVjSW9QZXpncmFBM3krZ2NZNmpRR00wTWVSTElWeHlUakl0cW9OSkdP?=
 =?utf-8?B?OXlNNnl6K29ORThaL2pjSkdoNjZBd0NIMXZROEMybUNVZG1qZU1YaHIwOGt0?=
 =?utf-8?B?RUN5RjJyMldFclBLSkQ5OVVkUlhpSlJ4UkZvcVppZDI3bjFSclZnZ2JDbW5U?=
 =?utf-8?B?WVgwdUowMEtUdU9CRWhuSXl5ek9EM2lFbVZ1eVBLeXhTRjRJU1gvc29hdTIx?=
 =?utf-8?B?bEd0SEJ1S3dyV1VGODBRTm9NWXZ6aFpCMVkycndpWWVldTJHSUtjTUNVQXVQ?=
 =?utf-8?B?K0pOQWJCWHJsQjhoVFZ1RTZjTWg5K3NmR1dweEl4RDJrYXpZUlJRYWpYb0JV?=
 =?utf-8?B?eEM2UEVnd2Raa25XNUlURVp6bUErTitkYUxMRHpMY1R6N1Z2d1JQZ1VINVB2?=
 =?utf-8?B?dklublV3WFh6OENBVHozOHcwRmRmd3J6bWtxTWpIWnZWSUpJM004c0tYWkYx?=
 =?utf-8?B?OUxqRkZxWWNKR0xhT2FhNlNsbjBNZU5vVERnalVucm5uVFFIVm9QLzJTWWZY?=
 =?utf-8?B?NVNUUFJpd2xxc1hBNnpldUdSTDgreXBGM0lPemdVQU90dnFidWtoYTZMZmNQ?=
 =?utf-8?B?anpWamErNzVWNlpVdHlvcGpNMEhTUk1rRFZyY1RnOXdrQkROSFFEUmpZWndu?=
 =?utf-8?B?d1V6SWoyaEhZejZtZjliL1RHQ1dUdDE3Z1hYUFNyVzhINWN1UzVpSHpIMkJK?=
 =?utf-8?B?eGovTlp3WmFrWlFxYUR0aThZNWJlams5ZmQyRUpYdUxkcXp0ZnJobzFMRFo4?=
 =?utf-8?B?YnJkWmhZV0pUOUUwSjgwRFllNDFvaXo5RlNlMnFCbG5ucGRMQllreWxLMXBs?=
 =?utf-8?B?cXR1dW05V3FLbG96UVQ1L3NwSUpoWU8wZkR2Q09ZWVd0KzRuVEhMbGdLVVlW?=
 =?utf-8?B?QXR5MExVcTk1TVczY1dGaldvRHVHR01QdHhVdGU2NVJJMzkwRkNPaW5DU3kr?=
 =?utf-8?B?UWxSc2Q1NGVqbjdOd1o3Tks0dUwvODZRUlpEaGJtNU51SGtXWUZkZ1paZ3dJ?=
 =?utf-8?B?NE5hNmgvdTh2bjRCLzFVeSthclNkU3NvcFpqQ0prR2RDR2d3WEp3eWlsQVJY?=
 =?utf-8?B?R083NUk5TWZYRG51Nm50WFJuc1U0d3h4UDNqcWJCTHFjTy9MZzF6WmZjOTVU?=
 =?utf-8?B?aWZlMFdaWk9zQkluNW5IT2lhbk5GSFhMWDhkWkZsaS9URGx2a0IvT2lBY0U1?=
 =?utf-8?B?WG1YNkNEbWtRNm1Ua2Yzd2NHWUxEMUszdVprSk8zOFlFT21PT1FRazRoZk4w?=
 =?utf-8?B?L0hIQTQybUhCczE5dG11Ujg2enF3MThXUUJlRVEwSWNTY3padXU1UzREVVpu?=
 =?utf-8?B?Z2ppckNEMnh4eDNWSGozTXJDclhzdXcrcTh0elRpRXltUUhYakkvZnFEazdS?=
 =?utf-8?B?ZldHcFlmQTFmRE93Nys0NUh1THU2dWVwa0RzWGgwVHp2b3NubmJxTTlEdkpU?=
 =?utf-8?B?Wlpaai82VmJFQnNoSG5XNFV1bFZ6Wlk5OGs1SWNIZDQwd0pnWDBSMjJCZmN4?=
 =?utf-8?B?RDNmdnFOWnBpU2NwbWluQjVYekhXTGxQd2lUblBoYWxXc3llLzBSQkhLU0or?=
 =?utf-8?B?TWdBLzRTRnRmcFpZL1J4R0ZOcmJ4RE9sZDM0STEvejNPcklJV0o3citvcHV2?=
 =?utf-8?B?WStMUGFlWVNPM1NMYnZWaXZxdE5LdHRyV1Q0eVMreXdCb25HSjY1enFTSlFy?=
 =?utf-8?B?akU5VDRDS2Z4NFdLbnQyUDUxSm0xUVhQLzNkM3Q3RnNFRlMvMDA5eE9teGtV?=
 =?utf-8?B?U3k0Nkpicm9CZ2kvU1NTeDB3emM0ek5qSG5TR1lhWHNYYWRDQ0w1QTgrTnVM?=
 =?utf-8?Q?SFdX+70JE8PZRpSm7mKvK1+AOQwTu2kKDKkxz?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9afc9e94-d3d8-41ca-2c53-08dec75baac0
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jun 2026 01:49:25.5115
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9j7iT+7dtw+sQ2SIn41jsSPL0sMyNJhJslMsWx7FS5Xst2tXyrG2BM6fdiUgTSL/
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB6057
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 0652118000A
X-Stat-Signature: q4biue8x8ouj37ip9ziqfh8usubxdnh7
X-Rspam-User: 
X-HE-Tag: 1781142570-956870
X-HE-Meta: U2FsdGVkX181Uo+azWnbJL5FY/EF87a+M7fifP2v66Jyy+T4LmdKh1wB6RGG6V9fExFQw9YG929ha0ivR0OZqSz2KEKPZfeRIWoHI856XYBUY7ea6rypHOTSRVoMQduQI++L3ZL0gitd0Ge35VvP0+hwKH6/U7qEJE0Qa0p2+rGlK2R67qvIT5Y7FGl87m2TC90aP9fwA14E35b5OhTcyAKrvcKatkv1XhwvoYlAmzVuCg7X9d2HPgjT4PAq61hh/9fumDHBW9MTNQZy8Ie9CkBsC7qw+fUcQY/QXZH5CLOJjn4T7CuUiL4hwANSZid9AKgrRKEETa4c3MdXXjEWwUGDxfQLOj1YxNIvz7V2AAe7Un0GMuBfma4asrpDJbPoqq/8JpCLJfNtF3AJ6jLYOgxvEKT9HbdqGx5Vk/jmrUAxqvVdW54cannQScMbALycu9ujstvgrKTnzosHErADl5vcYt84s5RIxQOsyLmeen5M1ITVlkgG1j1BbDvv5X3r/EXaEJN3KXJ0HBhUSdpr3HGP6IvzjFnMyap1jLMvWERJ/f18VDkituAUVZGVlRrKTWtfcW7YbWJWtPcbPGjesRa6460r/iJwwmyJ49dfxzCfhjRUPiF+KKITguPz5M17paU2FL1BfdWIB6WbyIs8kjHOfv2O3LxLEvUVTfsrlryXafLWS0/Iz7NfYftibbfPXIsL07iadVDHX/N5OQXDaU6XP2GzkqR6mXrLTpUrIMNBEWiOeDRaBdq3PYHTtaQq0oFlsn74TDxqt/kQEeYINpIbF/29w6u0ZxXXsOMCHerSEvYRkx/RInGHtQh+OZXFqHu9hZV2rJNS2FQO7raT0vyUcYKbPojYeEBYNceO+sHO5mvwVkJZCsiZchGxs+izU5tS1cpPDIlEpDkIh+ss7rxdz7VjGX+TifmVn+uZzuHBy+JnzZJfW6AsUShcdN573xZ7VxOjLVwHSfcYdFQ
 QX8kyaf+
 2HCHHdtGScWKkxfziwgWHSMUIeLx7XuPvlxE3QD4yE0A3FiNLaz+fZY0SkL5DNOFXN+/i/8zKr3+7xRClBcBdhZ8uUEiPzO0TFIWrV0h/jub/FkvOxrjDjmIBwCv63lrk5W3pJnHHczvR3BkPY4btuOGU5PznbM9r4et8JGvHyi4BSURjMsCy/9UzxSYl/5qt4ZxM8eV2udh9Ikzo8iRij5wZ2eTOpm6T5mJrPJ914V7HNAjBVB1IRY6EK6+ggsdLGBV0eqqWRK6GwTYY4XR2KymO8pgSF9ZdaoYvjSdYgXBT2xwt6NLoqgjf8LmzGnvvQjgBh36E01MvOqbMdQ7Zf9DMUOgcHWFetAoHL3zTxAVOmjd06P1w+J2bncC47HWtM+FxOno1BvtKKjuPcziuhKaBuOgHISZr6nFqXna9ZYZE8iy4/0bUksEhxo7q+8bhloty7cWXDd8xYVGvqBd54zbuQAakrpKI/tvh9o5BBEbjbAeWo424U6id+e8n2BAxBe69
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 10 Jun 2026, at 21:19, Zhaoyang Huang wrote:

> On Thu, Jun 11, 2026 at 2:44=E2=80=AFAM Zi Yan <ziy@nvidia.com> wrote:
>>
>> On 10 Jun 2026, at 13:25, Zi Yan wrote:
>>
>>> On 10 Jun 2026, at 10:38, Zi Yan wrote:
>>>
>>>> On 10 Jun 2026, at 8:50, David Hildenbrand (Arm) wrote:
>>>>
>>>>> On 6/10/26 14:05, zhaoyang.huang wrote:
>>>>>> From: Zhaoyang Huang <zhaoyang.huang@unisoc.com>
>>>>>>
>>>>>> The kernel panics are keeping to be reported especially when the f2f=
s
>>>>>> partition get almost full. By investigation, we find that the reason=
 is
>>>>>> one f2fs page got freed to buddy without being deleted from LRU and =
the
>>>>>> root cause is the race happened in [2] which is enrolled by this com=
mit.
>>>>>> We solve this issue by reverting a f2fs commit 9609dd704725 ("f2fs: =
remove
>>>>>> non-uptodate folio from the page cache in move_data_block").
>>>>>
>>>>> But I assume, that other FSes can trigger this as well? Any insights?
>>>>>
>>>>>>
>>>>>> There are 3 race processes in this scenario, please find below for t=
heir
>>>>>> main activities. However, by further investigation over the code, I
>>>>>> think there is a common race window for the truncated folios between
>>>>>> split_folio_to_order and folio_isolate_lru, where the folios lost th=
e
>>>>>> refcount on page cache and remains the transient one of the split
>>>>>> caller, under which the folio could enter free path and compete with=
 the
>>>>>> isolation process. This commit would like to suggest to have the fol=
ios
>>>>>> beyond EOF stay out of LRU.
>>>>>>
>>>>>> Truncate:
>>>>>> The changed code in move_data_block() lets the GC path evict the tai=
l-end
>>>>>> folio from the page cache through folio_end_dropbehind().  Once
>>>>>> folio_unmap_invalidate() removes the folio from mapping->i_pages, th=
e
>>>>>> page-cache references for all pages in the folio are dropped.  The f=
olio
>>>>>> is then kept alive only by temporary external references, which allo=
ws a
>>>>>> later split to operate on a folio whose subpages are no longer prote=
cted
>>>>>> by page-cache references.
>>>>>>
>>>>>> Split:
>>>>>> After the page-cache references are gone, split_folio_to_order() can
>>>>>> split the big folio into individual pages and put the resulting subp=
ages
>>>>>> back on the LRU.  For tail pages beyond EOF, split removes them from=
 the
>>>>>> page cache and drops their page-cache references.  A tail page can t=
hen
>>>>>> remain on the LRU with PG_lru set while holding only the split calle=
r's
>>>>>> temporary reference.  When free_folio_and_swap_cache() drops that fi=
nal
>>>>>> reference, the page enters the final folio_put() release path.
>>>>>>
>>>>>> Isolate:
>>>>>> In parallel, folio_isolate_lru() can observe the same tail page with=
 a
>>>>>> non-zero refcount and PG_lru set.  It clears PG_lru before taking it=
s own
>>>>>> reference.  If this races with the final folio_put() from the split =
path,
>>>>>> __folio_put() sees PG_lru already cleared and skips lruvec_del_folio=
().
>>>>>> The page is then freed back to the allocator while its lru links are
>>>>>> still present in the LRU list.  A later LRU operation on a neighbori=
ng
>>>>>> page detects the stale link and reports list corruption.
>>
>> Something is wrong here with the caller of folio_isolate_lru(), since
>> folio_isolate_lru() requires the caller to take an elevated refcount.
>> This means when entering folio_isolate_lru(), the EOF folio should have
>> at least refcount =3D=3D 2, 1 from folio_split(), 1 from the caller of
>> folio_isolate_lru(). This should prevent the EOF folio being freed
>> by the parallel __folio_put().
> This is one of the key points for this issue. Could the isolate caller
> grab the refcount(by folio_get but not folio_try_get) after the
> spliter's folio_put->folio_put_testzero? If it may, then the panic
> happens
>
>                     CPU1 (split_folio_to_order)          CPU2
> (folio_isolate_lru)
>
>                             split_folio_to_order(F)
>                               folio_ref_freeze(F, 1)
>                               ...
>                               lru_add_split_folio(T)
>                                 list_add_tail(&T->lru, &F->lru)
>                                 folio_set_lru(T)
>                               __filemap_remove_folio(T)
>                               folio_put_refs(T, 1)
>                               /* T refcount =3D=3D 1, PageLRU set */
>                             free_folio_and_swap_cache(T)
>                               folio_put(T)
>                                 /* refcount: 1 -> 0 */
>
> //caller grab the refcount here?

Which caller calls folio_get() instead of folio_try_get()?
Claude does not find any caller doing folio_get() + folio_isolate_lru(),
except migrate_device_unmap(), which holds a page table
lock to make sure the folio has a mapping and non-zero ref.

Even with folio_get(), it has
VM_BUG_ON_FOLIO(folio_ref_zero_or_close_to_overflow(folio), folio),
which prevents caller from elevating 0-refcounted folios,
unless your runs did not have DEBUG_VM enabled.

>
> folio_isolate_lru(T)
>
> folio_test_clear_lru(T)
>                                 __folio_put(T)
>                                   __page_cache_release(T)
>                                     folio_test_lru(T) =3D=3D false
>                                     /* skip lruvec_del_folio(T) */
>                                   free_frozen_pages(T)
>                                                                   folio_g=
et(T)
>
> lruvec_del_folio(T)
>>
>> Hi Zhaoyang, can you elaborate on the folio_isolate_lru() caller?
> Sorry, no. Split and isolate thing are merely assumption by the phenomeno=
ns.
>>
>> In addition (with the help of Claude), the race trace[2] below
>> looks invalid. It says split happens after folio_end_dropbehind(),
>> which sets folio->mapping to NULL, but __folio_split() returns -EBUSY
>> when folio->mapping is NULL in filemap_release_folio() check.
>> So the split cannot happen.
> Could the folio_needs_release return false?

Wait, if folio->mapping is NULL and folio is not anonymous,
folio_check_splittable() returns false at the beginning of
__folio_split(). So the split cannot happen.

>
> if (!folio_needs_release(folio))
> return true;
>
>>
>> Now I am not sure if the bug report is valid or not. At least for
>> folio_split() and folio_isolate_lru(), the race should not exist.
>> But let me know if I miss anything.
>>
>>>>>
>>>>> Complicated mess :(
>>>>>
>>>>> So, folio_isolate_lru() really only requires the caller to hold a fol=
io
>>>>> reference, which can happen given that we did the folio_ref_unfreeze(=
). It can,
>>>>> for example, be triggered by memory offlining or page migration.
>>>>>
>>>>> So we really want to not allow folio_isolate_lru() while we are still=
 processing
>>>>> the folio.
>>>>
>>>> Or we should defer adding split folios to LRU after unfreeze.
>>>>
>>>>>
>>>>> What your patch does is, simply not add folios that we will drop from=
 the page
>>>>> cache to the LRU?
>>>>>
>>>>>
>>>>> You should describe here how you are fixing it: "Let's fix it by..."
>>>>>
>>>>>>
>>>>>> [1]
>>>>>> [   22.486082] list_del corruption. next->prev should be fffffffec10=
e0ac8, but was dead000000000122. (next=3Dfffffffec10e0a88)
>>>>>> [   22.486130] ------------[ cut here ]------------
>>>>>> [   22.486134] kernel BUG at lib/list_debug.c:67!
>>>>>> [   22.486141] Internal error: Oops - BUG: 00000000f2000800 [#1]  SM=
P
>>>>>> [   22.488502] Tainted: [W]=3DWARN, [O]=3DOOT_MODULE
>>>>>> [   22.488506] Hardware name: Spreadtrum UMS9230 1H10 SoC (DT)
>>>>>> [   22.488511] pstate: 604000c5 (nZCv daIF +PAN -UAO -TCO -DIT -SSBS=
 BTYPE=3D--)
>>>>>> [   22.488517] pc : __list_del_entry_valid_or_report+0x14c/0x154
>>>>>> [   22.488531] lr : __list_del_entry_valid_or_report+0x14c/0x154
>>>>>> [   22.488539] sp : ffffffc08006b830
>>>>>> [   22.488542] x29: ffffffc08006b868 x28: 0000000000003020 x27: 0000=
000000000000
>>>>>> [   22.488553] x26: 0000000000000000 x25: 0000000000000004 x24: ffff=
fffec10e0ac0
>>>>>> [   22.488564] x23: 00000000000000e8 x22: 0000000000000024 x21: dead=
000000000122
>>>>>> [   22.488574] x20: fffffffec10e0a88 x19: fffffffec10e0ac8 x18: ffff=
ffc080061060
>>>>>> [   22.488585] x17: 20747562202c3863 x16: 6130653031636566 x15: 0000=
000000000058
>>>>>> [   22.488595] x14: 0000000000000004 x13: ffffff80f91e0000 x12: 0000=
000000000003
>>>>>> [   22.488605] x11: 0000000000000003 x10: 0000000000000001 x9 : ffe8=
5721f0e25f00
>>>>>> [   22.488615] x8 : ffe85721f0e25f00 x7 : 0000000000000000 x6 : 6c65=
645f7473696c
>>>>>> [   22.488625] x5 : ffffffed39b23026 x4 : 0000000000000000 x3 : 0000=
000000000010
>>>>>> [   22.488636] x2 : 0000000000000000 x1 : 0000000000000000 x0 : 0000=
00000000006d
>>>>>> [   22.488647] Call trace:
>>>>>> [   22.488651]  __list_del_entry_valid_or_report+0x14c/0x154 (P)
>>>>>> [   22.488661]  __folio_put+0x2bc/0x434
>>>>>> [   22.488670]  folio_put+0x28/0x58
>>>>>> [   22.488678]  do_garbage_collect+0x1a34/0x2584
>>>>>> [   22.488689]  f2fs_gc+0x230/0x9b4
>>>>>> [   22.488697]  f2fs_fallocate+0xb90/0xdf4
>>>>>> [   22.488706]  vfs_fallocate+0x1b4/0x2bc
>>>>>> [   22.488716]  __arm64_sys_fallocate+0x44/0x78
>>>>>> [   22.488725]  invoke_syscall+0x58/0xe4
>>>>>> [   22.488732]  do_el0_svc+0x48/0xdc
>>>>>> [   22.488739]  el0_svc+0x3c/0x98
>>>>>> [   22.488747]  el0t_64_sync_handler+0x20/0x130
>>>>>> [   22.488754]  el0t_64_sync+0x1c4/0x1c8
>>>>>>
>>>>>> [2]
>>>>>> CPU0 (f2fs GC)              CPU1 (split_folio_to_order)          CPU=
2 (folio_isolate_lru)
>>>>>>
>>>>>> F: pagecache refs =3D n
>>>>>> F: extra refs =3D GC + split
>>>>>> F: PG_lru set
>>>>>> move_data_block()
>>>>>> folio =3D f2fs_grab_cache_folio(F)
>>>>>> ...
>>>>>> __folio_set_dropbehind(F)
>>>>>> folio_unlock(F)
>>>>>> folio_end_dropbehind(F)
>>>>>>   folio_unmap_invalidate(F)
>>>>>>     __filemap_remove_folio(F)
>>>>>>     folio_put_refs(F, n)
>>>>>> folio_put(F)
>>>>>>                             split_folio_to_order(F)
>>>>>>                               folio_ref_freeze(F, 1)
>>>>>>                               ...
>>>>>>                               lru_add_split_folio(T)
>>>>>>                                 list_add_tail(&T->lru, &F->lru)
>>>>>>                                 folio_set_lru(T)
>>>>>>                               __filemap_remove_folio(T)
>>>>>>                               folio_put_refs(T, 1)
>>>>>>                               /* T refcount =3D=3D 1, PageLRU set */
>>>>>>                             free_folio_and_swap_cache(T)
>>>>>>                               folio_put(T)
>>>>>>                                 /* refcount: 1 -> 0 */
>>>>>>                                                                   fo=
lio_isolate_lru(T)
>>>>
>>>> If refcount is 0 at this point, VM_BUG_ON_FOLIO(!folio_ref_count(folio=
), folio) in
>>>> folio_isolate_lru() would be triggered. Maybe we could just return fal=
se in that case.
>>>>
>>>>>>                                                                     =
folio_test_clear_lru(T)
>>>>>>                                 __folio_put(T)
>>>>>>                                   __page_cache_release(T)
>>>>>>                                     folio_test_lru(T) =3D=3D false
>>>>>>                                     /* skip lruvec_del_folio(T) */
>>>>>>                                   free_frozen_pages(T)
>>>>>>                                                                   fo=
lio_get(T)
>>>>>>                                                                   lr=
uvec_del_folio(T)
>>>>
>>>> But in CPU2 (folio_isolate_lru), lruvec_del_folio(T) should remove T f=
rom LRU list.
>>>>
>>>>>> later:
>>>>>>   list_del(adjacent->lru)
>>>>>>     next =3D=3D &T->lru
>>>>>>     next->prev =3D=3D LIST_POISON / PCP freelist
>>>>>>     BUG
>>>>>>
>>>>
>>>> Why does CPU0 still see the stale link from adjacent?
>>>>
>>>>>> Assisted-by: Cursor:claude-opus-4-8
>>>>>> Signed-off-by: Zhaoyang Huang <zhaoyang.huang@unisoc.com>
>>>>>
>>>>> I'm wondering if this has been broken the whole time, or if some rewo=
rk allowed
>>>>> this to trigger.
>>>>>
>>>>> I assume the issue can be triggered for other FSes, and we want Fixes=
: + CC: stable?
>>>>>
>>>>> Looking into the history, I think we always unconditionally did the
>>>>> lru_add_split_folio()/lru_add_page_tail().
>>>>>
>>>>>> ---
>>>>>>  mm/huge_memory.c | 2 +-
>>>>>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>>>>>
>>>>>> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
>>>>>> index 970e077019b7..7465525a94a8 100644
>>>>>> --- a/mm/huge_memory.c
>>>>>> +++ b/mm/huge_memory.c
>>>>>> @@ -3966,7 +3966,7 @@ static int __folio_freeze_and_split_unmapped(s=
truct folio *folio, unsigned int n
>>>>>>                    folio_ref_unfreeze(new_folio,
>>>>>>                                       folio_cache_ref_count(new_foli=
o) + 1);
>>>>>>
>>>>>> -                  if (do_lru)
>>>>>> +                  if (do_lru && !(mapping && new_folio->index >=3D =
end))
>>>>>
>>>>> It might be clearer to write this as
>>>>>
>>>>>     do_lru && (!mapping || new_folio->index < end)
>>>>>
>>>>> To match the page-cache check further below
>>>>>
>>>>>     if (!mapping)
>>>>>             continue
>>>>>
>>>>>     ...
>>>>>     if (new_folio->index < end)
>>>>>             ...
>>>>>
>>>>>>                            lru_add_split_folio(folio, new_folio, lru=
vec, list);
>>>
>>> Talked to Claude and find an accounting issue with this. Without puttin=
g
>>> EOF after-split folios back to LRU, they are not going through lruvec_d=
el_folio(),
>>> which decreases NR_*_LRU counter along with removing the folio from LRU
>>> and it causes NR_*_LRU accounting errors. Note that the original folio
>>> is on LRU all the time and LRU counters are not modified and after the =
split
>>> the original folio size is decreased and the after-split folios need to
>>> be added back to LRU to keep the LRU counters right. We will need to ad=
just
>>> LRU accounting for (!mapping || new_folio->index < end) if we decide to
>>> not add them back to LRU.
>>>
>>>
>>> Best Regards,
>>> Yan, Zi
>>
>>
>> Best Regards,
>> Yan, Zi


--
Best Regards,
Yan, Zi

