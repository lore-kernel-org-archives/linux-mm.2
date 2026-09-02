Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AE2D2C624D3
	for <linux-mm@archiver.kernel.org>; Wed,  2 Sep 2026 14:17:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C8F366B00B6; Wed,  2 Sep 2026 10:17:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C37AD6B00BE; Wed,  2 Sep 2026 10:17:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B4DCE6B00C2; Wed,  2 Sep 2026 10:17:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 8B49B6B00B6
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 10:17:05 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 275BE160226
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 14:17:05 +0000 (UTC)
X-FDA: 85169024010.27.D3F5499
Received: from DM5PR21CU001.outbound.protection.outlook.com (mail-centralusazon11011031.outbound.protection.outlook.com [52.101.62.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id 2F44B4000C
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 14:17:02 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=cUo0FRXg;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf11.hostedemail.com: domain of ziy@nvidia.com designates 52.101.62.31 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1788358622;
	b=4enp3v4EPEavwmXHef4lev3u2UiuYTklm9cvgiWulzbWQCP7uHFQMyXBTeiuxx5ViaDzpG
	UverDaXHElhnUOlkNTyjur4PQ6AzsjIPRNTCZiLtltulV5VOOWI4F92rSQ5xYrYS3qUzCJ
	wZiIdnwqifwMc5po2O4GfDNC5uZNRlI=
ARC-Authentication-Results: i=2;
	imf11.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=cUo0FRXg;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf11.hostedemail.com: domain of ziy@nvidia.com designates 52.101.62.31 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788358622;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2Miuf6NFFGDj/xeqju29xmDwUM2Do9Wc8EizonD2Orw=;
	b=ezCD9/RuPW9610qU8Z7UJpIxHGHhBLz5jW2B7pI/iQCcBUOjX9a4sePQ9gBJGSiSU1E27y
	/v31C/Rt5nw/FSAPCBRij8p3GOlu0VPTavjkg9WQaCwPbfm9B4jRG6yliXde7kfThtoxGy
	ZNhWuSD/LnOqtjzApvMFUaR9N0JcqJQ=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=F6lUbXQgSk2iR5q3TSZC7Kb6VSUUF/SRE6LF+fvpIJ3sZgEOc4hzZg+jQZ314RiLYDHE4i4iZoVhRunupZ+bxxEhpuTNaqM1Y0hGn5RUdBmTVf4JuTedLt4KvdfP0IYD/kM1uqiqT2OzrqXs1dCqLdUTYsAEbMgBfRC+fg2hEl/urie6RfpNZtWmc3zHhJ4rwFuhRV+wHAxfbvOM4UVksBemoo1l4TjDz4MZdNhlbWFAlQims8SEGrHGliEdywkzhsy+bqN8tHFwVbo9LqTZYayFAJEPPEps/T41jjVvcVvPV/FeeB6kW30hRd2/dL3WGcgJYu1vaBoS44jO8gG7lg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2Miuf6NFFGDj/xeqju29xmDwUM2Do9Wc8EizonD2Orw=;
 b=dHooAkDBagZWhKgguf27dfMYuNrDEU+AXBxNGyKzjRRcstLRyTPbCQRQ5F2UKlfXd/36gHXz90N0P7vZrt0p4KOvk27Og7xQ9yCk2TdQeoMVGnKuT8AP/n9+Acxx9Irt/Xd0Qbo5weu+t51WqzOggBweUKpvckLgtaHUIhWVJTW4TNpCbG5mJrkBCiC4jD8nYhs2vXsTwfeaCmE18NqeSKPh+oyQTyN9KmQcdpBpFGdHJiJe6k3QB9HUiip2XX9IpKETpMHyQoST4I7vf4dPFXCNjjRmw57CCp+kjwRMZ4p6u/7PAW9A+Os3SOmZtpdPSEF71srQwFWa4VxIoTGTIw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2Miuf6NFFGDj/xeqju29xmDwUM2Do9Wc8EizonD2Orw=;
 b=cUo0FRXgedvCTuRtNN0zmQ4eMxCdqUsshW5VSD6wsbwv0qv4av0xZW7y/qdxeZwogi6fLDnQW9edwtbvBufuHun1mgZoK0+l5K3+s9pTi/jsZjD7VSIgYRYFA7WAlu6CSDsWddztWmZCYe7jpyQjs+qDkbseVJPU8HNP+7BDQUd4bMLxWtuz+3Y+0GHS/NzT49yO7viAngdQoVN9AXGXsPheakmCbAmtVUvzoMDJ8K26U9YyYrIQKnLI7ut4vbqT5P3AAVtKkOd4f0YJ+DYuZm/bndAMB5ATTKU8trZ/p+tMA/gGCbxzT06WXaDwR/6SSl2Ac6FkXOsO2IoOcVstsQ==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by LV3PR12MB9214.namprd12.prod.outlook.com (2603:10b6:408:1a4::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.382.10; Wed, 2 Sep
 2026 14:16:53 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%5]) with mapi id 15.21.0360.008; Wed, 2 Sep 2026
 14:16:53 +0000
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Wed, 02 Sep 2026 10:16:51 -0400
Message-Id: <DL4W7WD7HX8H.2SFIEJUGT6QCA@nvidia.com>
Cc: <linux-mm@kvack.org>, <linux-kselftest@vger.kernel.org>,
 <linux-kernel@vger.kernel.org>
To: "Yeoreum Yun" <yeoreum.yun@arm.com>, "Andrew Morton"
 <akpm@linux-foundation.org>, "David Hildenbrand" <david@kernel.org>,
 "Lorenzo Stoakes" <ljs@kernel.org>, "Baolin Wang"
 <baolin.wang@linux.alibaba.com>, "Liam R. Howlett" <liam@infradead.org>,
 "Nico Pache" <nico.pache@linux.dev>, "Ryan Roberts" <ryan.roberts@arm.com>,
 "Dev Jain" <dev.jain@arm.com>, "Barry Song" <baohua@kernel.org>, "Lance
 Yang" <lance.yang@linux.dev>, "Usama Arif" <usama.arif@linux.dev>,
 "Vlastimil Babka" <vbabka@kernel.org>, "Mike Rapoport" <rppt@kernel.org>,
 "Suren Baghdasaryan" <surenb@google.com>, "Michal Hocko" <mhocko@suse.com>,
 "Shuah Khan" <shuah@kernel.org>, "Kevin Brodsky" <kevin.brodsky@arm.com>
From: "Zi Yan" <ziy@nvidia.com>
Subject: Re: [PATCH v4 1/3] kselftest: mm: prevent random failure of huge
 page split for khugepaged
X-Mailer: aerc 0.22.0
References: <20260902-fix_split-v4-0-85f03905f7b1@arm.com>
 <20260902-fix_split-v4-1-85f03905f7b1@arm.com>
In-Reply-To: <20260902-fix_split-v4-1-85f03905f7b1@arm.com>
X-ClientProxiedBy: YQBPR0101CA0232.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:66::13) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|LV3PR12MB9214:EE_
X-MS-Office365-Filtering-Correlation-Id: 10be5b8f-29cc-4aab-16ad-08df08fcd677
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|366016|376014|1800799024|7416014|921020|6133799003|11063799006|56012099006|4143699003|10067099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	acnNfCV06qa3MYkaCrFRCWU762rioB+9rer9BxMEpR//IIyhNy1aaAzFjcCRfOYt65oosQwX9OudYBNcmVWp0BMWVegelsSTKxP6Y7oScHb3uWnLOMoABwdz/desta21yBUqT52+YBKoOolFy1KhT2tQSU7uUwzkZ3XEP83p8FL+lMCqQhoB8YCSdVE3B+XgPgqaLQY+00RjwevzLwB2P0Tq723Subq35d5qQDVTW9Ot4qVI/KKJC58WSijmTWND4OfVKjibLjlXM9V2ZS3LyEsePThN6n2gLK5RoX3A2k87MQiyWswABqcp3hUM6PQsMBoExHAMChhNdJlblTyaULtgkIEO5bUP+Qhp1/69ALx11iJ203V8vZJM9G+KRCiRJlRCLvQ/DkGIM3/4BUeqpi56HftUsgsIga9XVkIfZelFj+MylndHZY0Y4KtKMYAzdazaaXhT9w0yr4etb/asgODuIaFbykofOfXKitiJRZWVnNT5rgBFSIfLSR0idXvWaHvtNV/a/+TRofjVSmpZd/K1m9uH5z7WevCO0FIXvPHVT+w3pqY4ZY8V7NJioVkwgwloZCPzyt5KwayFn9eGRd8+LRKUPdQq8cIZejsk0AA5SjYzGnDhE36fFy2ZnUEi3VACeTw5yhvcu9oy5PMRLXbfnQk4tkKFodObRsRwRJabEcawx9xE7MwQ+p/zi4HDlO+lYLQyyB154LBsX3jLsA==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(366016)(376014)(1800799024)(7416014)(921020)(6133799003)(11063799006)(56012099006)(4143699003)(10067099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?UWs3TTRteU1mR1M4MnRRQWcvamtxWVBFSUhhS1ZHaU1pMTRSQWEwaWpEa1Js?=
 =?utf-8?B?ci9OMk9HVEdvNEZwLzVGWkNjd3paM0Mza0xHSWNldEtoV2V1UDUzeDhxNVZR?=
 =?utf-8?B?WGtwZ2NQTldJZE9iNkJoSmNoZmw1d2ROMVBrd1g1c3pNZDZJL05EK1FTR0hi?=
 =?utf-8?B?TzdkWStTZnEyalJJY3djM2plUGk2clNtZ1lXaUtOMy9PL1ZDRjNuRXgzK25h?=
 =?utf-8?B?T1FaUFdPU3h2TjZjcnoxNmt5bEo5NzNUblJRQ25VQWptVWcwY2QrV295blhJ?=
 =?utf-8?B?cHB4Z1BqZWFzM2kyL2dsT3FXdWsySlVqY3RNb21nVFJ5Rzc0U0ZxTll2UlhU?=
 =?utf-8?B?VlUraUhvdHNqNlR1REErZjc3dFRtVmFpV2hicEU5TUIzbXltSU16a1Y1aWVk?=
 =?utf-8?B?cEdsbzhCS0tQNm5Wd1dTbTFZS2o1Mis5S3JFaWg1Y1JpK1JFVUt2S3ZZdGRv?=
 =?utf-8?B?UDlzRThrR3huYVp0YmZTRWRTUjhHY1ExRlBNQmhURGhnYVEzYUZRdkJCaXNr?=
 =?utf-8?B?YThManc2ZGFRalhFTGhvM0Z2UWsxTWhrRVpuTWtxdG9wdXNicTdya2Q2a2dP?=
 =?utf-8?B?TlFXUVBvWTBnQzRiOGRqVGlTUXVDU1dFQUNBNlVEdGxPSEZpczNwMlFxdlBT?=
 =?utf-8?B?U1ZUdkxlcllCZWRnNjk4TElsMEM3NXBoRGhWZzhldCtTN1hxWnk4U0J3K2dI?=
 =?utf-8?B?QzkxT1hYSW1PYW5LMmN6ZnM2NStkc2gybnZURzl5YUFWcXYvWnNTUjRBVkJi?=
 =?utf-8?B?TXVFR3hGOG1TcnY3RE11MVFwN3c1Mk0yV1o2MHBhVzhnaER5QzdoNUhqNjhM?=
 =?utf-8?B?R1AyL2RObzBqdHZ3YVNoWVdaK25NTFYzOVRaamVpUFpoUytmQ2pBRXk3aXl0?=
 =?utf-8?B?eFIrMExEUE1ZT2VDazVnc1I4cVRxc1IrT2QzOU5uNXNtT05PQzdXOGpVTmdZ?=
 =?utf-8?B?amNtOGVialQxS2x5QUhHb2ZkRDhXdStYOW9GWVE3RVdNNHZLVFlwMTFUdGFR?=
 =?utf-8?B?RklKVklsVjZBeVdSb2NVYWM1NnU2dGROZUthRFZlZitTVXFiWWpNNkVhMVFW?=
 =?utf-8?B?b0YxSXVrc21hL2UyRlBJVXg1a0dvakFWTEppaWNDWDZuaitXQ2ZIcUNoR0ti?=
 =?utf-8?B?MFNqckV5Nm1qWDNabzhtKzFyVUo1ZXJod0psQmJGUitzSGYrWlVmNkc1ZSta?=
 =?utf-8?B?TUJqSFZOSjh6eUk3RnpJaDdFcERJanZ6NVVIQ1lJWFZkckpCTitlZWJSd3RH?=
 =?utf-8?B?MjI1TTVQMlBhSG96WUMrazBrWDl5S1QvUk80K1BQS0l1LzVSMVh6czdhT0Zv?=
 =?utf-8?B?SWk1MXpuUjh5OWdrZXhKa1pFUXhUTFNDVWcwL1RLUnVUWEd5MThRcnZWTDY1?=
 =?utf-8?B?OW82SVlyTFhzZGNydisyK28wQXFMdWxDakJLNzUxUUlzWXkvdFpJNnJqTDRC?=
 =?utf-8?B?Ujl5eXFxeUo0YnZjTmoyK2lkb28rUy9uR0ZBWWNtN01sRnRCaE1ZRmRiTHls?=
 =?utf-8?B?Yk1iMHpBdVV3WlcrWHdYdnB2OFBERVlYWGNIZ29LVjVwamk2ekpsS0NUZ1FG?=
 =?utf-8?B?WmFMZ0oyanJ1S0IxN0xaSGpuc2VxNG45UENrWTVTNnYxYlc2SE9PTVpsYkRL?=
 =?utf-8?B?ZjhlR082RTlnbHBXNHNrNExsY0hxcDlBNzRJL201YXpyT2dudUNrL1pMR1R3?=
 =?utf-8?B?VjhzR0xKdDkyMDBvcGRmVmRDRVlISS83SEdST1JQazgvckFOODJIVHc2S2lv?=
 =?utf-8?B?T3Q1MnExaFErMHFMOXFqdTc0ZmtxOWc5QVNRcUZNbjV2akpUT0ZNZmZmUXRi?=
 =?utf-8?B?eWZqeEU4K0RqRGNJMldGc0ZURkJFU3IwbFVnUnV6WGZDV3B6NjR3a3R3OXU5?=
 =?utf-8?B?UytrVWZVODU5ODhOQm53Mzh3amwyUE05R1luTU1Gd1hlYjQ0aCtnQmo0VHl5?=
 =?utf-8?B?OHFMOUpzL1dyc09SNmczU1ozellIZTE1cVpKSUFBV3pBQjlEOVJiM0ZDeWRy?=
 =?utf-8?B?Ym5MZUFSdXJZQnE0VEJvdEllZlNqcE5pUjIzSS9HMWlVaWQ0V3VyczBaMG5W?=
 =?utf-8?B?QXpiTEpFT3psTnBMeGJwMlJhNHh0WjZwRFQzR0VTdG1yN3BrMklFTWE4NnFR?=
 =?utf-8?B?UEpaNUI4NHNnMFVVOUppTUJKUWRQUkRlTHNlWnVVUkgyZWJ5U1YzK3VZWExL?=
 =?utf-8?B?NllCZ1JSODM1bXBmRnRPRlBHcEVSM201UTY1K2dEVlNmTU1TMnB5QUt0VDA3?=
 =?utf-8?B?QVE5MTBqWXNqcVNoWXZDODB5djRabGZwNXFTOUFuNmZ2dmpmZHF4TFpHdzFB?=
 =?utf-8?Q?5/mcW+CtMYkttN9RZS?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 10be5b8f-29cc-4aab-16ad-08df08fcd677
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Sep 2026 14:16:53.4034
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hiwtKtt/Yn96h6Daa0RVykYBAgsSiz3Pm04hpThgo/JewTjOOOgrhE0LyW2Uj4dH
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR12MB9214
X-Rspam-User: 
X-Stat-Signature: tadxouh5xgr4f4r85u1b4dj8aqxp5zqo
X-Rspamd-Queue-Id: 2F44B4000C
X-Rspamd-Server: rspam06
X-HE-Tag: 1788358622-612977
X-HE-Meta: U2FsdGVkX1+My+GWw0A5B765BOyLG1O070mrijKehGNnOMlHGJeTKvbf8goM0ulDf8SPTOyLsj0wZ62/0inSW6yaT5fAH+vX4Z6qrvrS9QFgSV1toB+h87Eh5PoUU2neiaeIa66cSOSAFkA8apENvv2AO7GdMuxjsT+p0KS7zCllCVhXBDCU/jNKTJYV7bNrQ2Jbvfzthd54PQY5n3XHCGG3ZjRz8tFyIrL5lzKZMdF5bW6AvbkE+ZTPL+ygAshWbEVGxUxp2uqGHkWPcDwVwfSz4P84f+HrVHV/U+b7OSBe1o7jpFK/LG43KQ8sKp5ksinzvLH/DaGRFkc4SyM4EMG4V6OwmpW8JMbCKHV/AqNdWQ5M77NLEbm0aUUSnVhjVjexMIy3YfOk2qjX0PNN4wefy+OB2p+Wr2hJl3DKoWcXLfitkkGfbuOX7OaYW9fOp6WQzCgBnDhUhSnuWA4lfR94gHWomfvOOXFm2f3h8Hd8HgdGaWrn4T/4f9/GvOLrqzyCPkadqe+9fM0/wMNjkbS4lI/k7QsoYZ7p5dlHrINTtRdz1z42nmFTkg9oDUybHMIrtr8CrH/sLFZHbRXjpGAX/KnbVVbZER5DApAXgebAEgHMnQI+p7dKRAruiJ820+oLusqwlYQEZzOZoG3A/qeTWDDEYIeUVjQ6fQFztYia4seM+j85nLiLjlG+XSYjsSaiF0MovR10U9EhJ5Y+ZlVBQ1XkNlCVlGo4l3nv5l20tmixQhaqb8uCBK6VSAm4lLLqF6iruAaEzeMUxMBsK57dESHNIMd8OQJGlzNkCO8hM2efeQTofxBZEYqn8AHlpBLzLDzSv02904GT8Ah6OYDrzpGAhWcJCicTGsd7hr3izxx76kcQpeUdz6ggvMMpKFSaYMkZqeIyvKn+q9Y8+P9rZZKjWMbfr2ES5drBawTxi/Cy5omwUdlumIMU8QUpjFEhMEZ0b8UCMNg5Aqj
 wk7K5z42
 cplvIYvdczbGUA0XOc8DRKQJ2oM4CKh9zN0s5AJHtrjTozwBDysztuNKNLHdhEprIc6bMTzp6NmUiI4NsWeOzbEyb7l0lMXKowmrKs+vd5C3ArKU9cFflJ9+g1Rb02ok0qoXgp/fJt3UYe2VsqNi/8eF9nqNuknZpoAs9P1liBlErGk+uBeS8hZQtbULEootInTQwTNAP4Hy0wzMZAfmDMRoEBar/UT6sksmg6cxRUJpNsOWnb0gv6ig5ge4Mb37UsWuAA636Z2wXJBDOxHrC8vsc6T3nJkjoxJZFtaZC2aMdxZ7KIaeZcD7xTiXs/Lhjva2Muy2oCrkcYDIZhZkThDNQz1xQlYubpl/8rAxgu66zq4iRy/76adC7Ol9XAFYKSp09dGzj4iYWOq8aYUSLfvvDkF2NDn6YQYTSdvPyU1Zn6mWqMQxTNHcA726j5n2JJnQIlgVbMjsp4qr8x40QFDHfrq0N59CoMGks
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed Sep 2, 2026 at 8:09 AM EDT, Yeoreum Yun wrote:
> There're some random failure for split_huge_page_test when khugepaged
> collapses pages into pmd again which had split by the test.
>
> Prevent the khugepaged's collapses for split page by setting the
> mapped pmd-huge-page with MADV_NOHUGEPAGE before split.
>
> Suggested-by: Kevin Brodsky <kevin.brodsky@arm.com>
> Suggested-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> Signed-off-by: Yeoreum Yun <yeoreum.yun@arm.com>
> ---
>  tools/testing/selftests/mm/split_huge_page_test.c | 19 +++++++++++++++++=
++
>  1 file changed, 19 insertions(+)
>
LGTM.

Reviewed-by: Zi Yan <ziy@nvidia.com>


--=20
Best Regards,
Yan, Zi


