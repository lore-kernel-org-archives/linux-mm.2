Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CD254C55184
	for <linux-mm@archiver.kernel.org>; Mon,  3 Aug 2026 15:02:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C1AEE6B0088; Mon,  3 Aug 2026 11:02:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BA4586B0092; Mon,  3 Aug 2026 11:02:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A6D1A6B0096; Mon,  3 Aug 2026 11:02:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7B6016B0088
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 11:02:46 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 0DA128072F
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 15:02:46 +0000 (UTC)
X-FDA: 85060275132.19.39A88F5
Received: from BN8PR05CU002.outbound.protection.outlook.com (mail-eastus2azon11011067.outbound.protection.outlook.com [52.101.57.67])
	by imf19.hostedemail.com (Postfix) with ESMTP id 18D881A0002
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 15:02:42 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=q2860WRC;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf19.hostedemail.com: domain of ziy@nvidia.com designates 52.101.57.67 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785769363;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=M63GrzIg+7bRMujSWNFuQqhgmz7+RZPTjZJ4KBPrjug=;
	b=EZJ7QDsq5G7wOGlG2Nh/DxJ5jVQqt9798U6q82Sm1lQyUwuLZhVgFTp/FDRbssY3cNfdid
	NKnJr9mQNSpnqHRbqZVQ+1cLuyFxUNy1gwX9fh2AS3xWMevp9l754EUuVbQooLtCc94pxF
	Skmwa83S9V3lGZqUGWEgBqou4HvcI7Q=
ARC-Authentication-Results: i=2;
	imf19.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=q2860WRC;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf19.hostedemail.com: domain of ziy@nvidia.com designates 52.101.57.67 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1785769363;
	b=bIM8cEBflCeBGH1bLJ5POlXjv+HisyhgvcDZPGITQJfD9uEp8foPNUMRPGq1qDsIGIKPS9
	Pigpj2j0WgmtYjdu0lTSXGgwh/ggpMBcg/ihLQhRofV2C5HpbcFVdawozcIvPZeVW55J1u
	CT9AeGDiSXrDkLe+1iSnR6f3CVfeSJA=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=clMThK8GiU6oCvuU8XEzbtmsB3xUDnWgjUDnayos9kCFkoK9i2mrGwPMgbhlFHZ79bD9YeH2O/epn6/bkH8tySb01DC6Rmd7h+d+0y4lx+k0RQCRYhJzQTMPTS2jS3QL15Qx2OO+YUd0EOB7ER0oVvsOysS+klNXYi7WJWBWp3mPdPAzHBqK/JgLTqwmX5mMhKBO9Cmjit2Fgbgqa1kXTm9PEwHpVVwGRvKrpAGxlOQ+tFj8yTvjqz4gGhEd9wt/2RoDdsHwswB43pBj/npS4V75k7wujXvNWZynqq+tds70KwZcBsdfSlg2gF6y5RysJ8nHrjuAz82NFGpsBOsb2A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=M63GrzIg+7bRMujSWNFuQqhgmz7+RZPTjZJ4KBPrjug=;
 b=hPFi0enTiBaRwYGrgXgz2qiv4RinOpJ8eT9N4ib7Mhnwj2O+hMdX+Wj2XYgz6Ag/JQ7GYIYrg9OKlep19YybffINavoYxVGGMXo4kxS0VRi0qma4CuunscFPdKjGR+FTTvwuucCUxHlDsVs4rqEiDLVpxnAEIqTqxG/FPiIuVcZ9C6o90J3F59GSU07W/NO2DfyX3jNZu70wJn9XF7Ko7djtuDDbx3J6lDwUZufHqjfAQwamsQD1t2lUqELDkH/XVUH9gRCVG9k7BkK0kZyHj/4bKrDDJEgPdYxHR0izfvTb76w8pE1zckU6Q1hZpSMiViSv2LTehZUBsYr9iBNhhQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=M63GrzIg+7bRMujSWNFuQqhgmz7+RZPTjZJ4KBPrjug=;
 b=q2860WRCwMakny9BmOA+q15gglRpSOWbdNU6deO97ZFksMqpItvqoLQ6z+75Ov3kmSyxWWZFrGXiw6SSFrBfIPYpRDpqQ+Z89br9OIUqxV/TUqAltf2Gci3CXXlgx61fzV0+TqaSd8zHrej3yh9p072LrztZuaUJZHBwunlYUhqXdBYx3mWJd5vXE3LewhQxtZi8Uw0lQa3uoPtPXxBKrxxTS9KdkCUB0dEoVOXozITe2sF4hY3GCafBD9ha3Ze8B3/obN9ht7txagHcjOgSxkJjQPcElHg0pwRZKSdFQsJnYbAvBu8HPshzzd544ldAAE4jRWoIG0DTrcq2f2iLXQ==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by CY5PR12MB6298.namprd12.prod.outlook.com (2603:10b6:930:21::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.270.18; Mon, 3 Aug
 2026 15:02:32 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%5]) with mapi id 15.21.0270.017; Mon, 3 Aug 2026
 15:02:32 +0000
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Mon, 03 Aug 2026 11:02:30 -0400
Message-Id: <DKFEEI2EDS4F.1AHGKB1EL6XRG@nvidia.com>
Subject: Re: [PATCH v2 1/2] mm/huge_memory: use folio's memcg inside
 __folio_split()
Cc: "Andrew Morton" <akpm@linux-foundation.org>, "Matthew Wilcox"
 <willy@infradead.org>, "William Kucharski" <william.kucharski@oracle.com>,
 "David Hildenbrand" <david@kernel.org>, "Baolin Wang"
 <baolin.wang@linux.alibaba.com>, "Liam R. Howlett" <liam@infradead.org>,
 "Nico Pache" <nico.pache@linux.dev>, "Ryan Roberts" <ryan.roberts@arm.com>,
 "Dev Jain" <dev.jain@arm.com>, "Barry Song" <baohua@kernel.org>, "Lance
 Yang" <lance.yang@linux.dev>, "Usama Arif" <usama.arif@linux.dev>,
 <linux-kernel@vger.kernel.org>, <linux-fsdevel@vger.kernel.org>,
 <linux-mm@kvack.org>
To: "Johannes Weiner" <hannes@cmpxchg.org>, "Lorenzo Stoakes (ARM)"
 <ljs@kernel.org>
From: "Zi Yan" <ziy@nvidia.com>
X-Mailer: aerc 0.21.0
References: <20260730-add-gfp_account-to-xas_split_alloc-v2-0-5a56c2361d85@nvidia.com> <20260730-add-gfp_account-to-xas_split_alloc-v2-1-5a56c2361d85@nvidia.com> <am28pV2PEfHsi4p-@lucifer>
In-Reply-To: <am28pV2PEfHsi4p-@lucifer>
X-ClientProxiedBy: CH0PR07CA0011.namprd07.prod.outlook.com
 (2603:10b6:610:32::16) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|CY5PR12MB6298:EE_
X-MS-Office365-Filtering-Correlation-Id: 55d73992-3e95-4ed2-d39c-08def1703e4f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|23010399003|1800799024|7416014|376014|56012099006|10067099003|11063799006|5023799004|4143699003|6133799003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	eiwLvlMFIBRLQdyYqDNtRe55Ae+obUClM2GyndalAaItKbXgMYyESI8WdOMTThJzWEVYrdSu2BIlPArBS5rSXaZPWwhvPZT2Uulk2HKKjn6M9bN3m5mqumbkKBf9S/Wvckp14ZhBVey8dncPijjpG4BoN44bFe76YsO0hoEj9Ex3d2w4k2++T1H7tPfq1sMWsD8hUfsy+WYBT60wof2mE1L9Q2I37Yt36AkOe0Fe22KDbosURD9JFKqJHWvgEb3hT9tetRREn3ciWhnOvzaOJrLs5BTo90Is0gpNSFoCLf6vxHj+HTjX8pD6VSUwRj9pyyQU0tPjwUbA3v91XqQx09uHrVkRRM4L4J2r0os8dzSRARFunDDeEKid3IGcB+S4luhi3rt3t4udWmjcxVWxIz9XQGuwL/GIn/3escADHwYZzSUy3N9kyQ13nRYkA8eBzptwWoe2XFjufvXG6PaAZZwCrJ6wLuwhu4jCMXiWcp1lubKlKZv0Rxcyqms195wC7jqQCCxT5g1WEcP86Fnb55X0xl4ECmzfLpeH5HeNUbMI08ALNx5g1v2BLIr5nSslHLDAtIo7gikgbE+Jk7Ovhk+MxNPRgjCvozG06KtCptw9x7495yhjSdfk0jovo1T+yaWf2IHFxwiFAQcJS5GSVXpOBelMoziWo6wNwASgCgQ=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(23010399003)(1800799024)(7416014)(376014)(56012099006)(10067099003)(11063799006)(5023799004)(4143699003)(6133799003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?WjgrNU10SmZmT1RMMzJGVWVPa1lOdFhuMXh6OTluekNMU2VFa0FLT092V2Nl?=
 =?utf-8?B?VmZtNkxjdHErUHFRKzM4OGhtdU9FOEtsQWFVUHE5TnFLa3RDMnVDbkRYbVFt?=
 =?utf-8?B?MS9QaHRyU1A4ZGVNT2FLa1FKUjlVWndFc0E1R2wvdm9QUlltRWhaY3kxTkNo?=
 =?utf-8?B?d2hjdU83dUxlQ3I1YXB1ZTJZTXprK093ZUpNK3ZjaHpFWUhZNkZJcFY0TzFY?=
 =?utf-8?B?eSs5TEhQWjFZRkUwWkNtenZxNk9NaXpVT1BQR1hyWFM5MmdORzdSTTczeFhm?=
 =?utf-8?B?d3FtTk1reitpOUswK0x1allsYURwMlExQWlXaUpiNjN4cTNFYmhDZnplMTcx?=
 =?utf-8?B?OUdGek9SMDdYVVBKcGE5ZWZ0U1Vkd3BXc25OaW9ua1FUWG5mcnZlbjhIc0sw?=
 =?utf-8?B?WG5BQW9qc1QyRWVmeXZ2Q2pnWlZHNTc1QjU0QmVWUmUxR1JSTzZrZ0wyOGxV?=
 =?utf-8?B?REV6MlpuRHRqRjY2blYwblN0Z2FJS2tJL3B5bVJSYktCeGd6S3lHdHQ3cXBm?=
 =?utf-8?B?NjIweERJOUZsejV2QVZ2VkhQZW52anNhYWlDM0lKVVFhWU1OeDZjeld0SU4v?=
 =?utf-8?B?TWZJQjh1aS9HbzlkWnJuckFabzV4ekhEYnVVRkdiMldla0J2TmtmbDk2azBn?=
 =?utf-8?B?YXY5MExYbHRzUWZ4SWxLajFCamp0c2NJalNTMmdTdCtkYy90MmhvdElSNTVP?=
 =?utf-8?B?bGpMRjZLSFdRVzBLMXRUVW51RXBjYUtrdlRXcDBuaUt2Nlc0ZnNkWjhHSjJy?=
 =?utf-8?B?WmtBQ3pLT0NPSE1WeG9ZeTVZdmtIcWFQN0VFNG1WdWwxTGh4TG5rZnpqWW5W?=
 =?utf-8?B?WVNZazRrOE9RRWVvSlBwMG52MmV6Wmh5cUs0S0VyV1JFdzFLTDVnbXRYdEE2?=
 =?utf-8?B?dEx3MDJ3enZKL0lYbldXQ0UvVVJ1eUxvajlWL2pkY29Ec0xSUHl4dDg3eEZN?=
 =?utf-8?B?TExvV2VaalFHMHJ6M2JyTjA1dGxReFJJMVJJSGVMdEpwdmxrekRIYnpQMFY3?=
 =?utf-8?B?MU1QOS85QlU1MlJUR1hFb2VKVDhBOTN2bTBCK0p0OWYrTE5nQlIycHVPODJO?=
 =?utf-8?B?Q0NqMzdvYmJRVTNicW1Qd3VtN1V5MmFQSzl1N1NMcUdabFlwKzkxaDFNdlFF?=
 =?utf-8?B?OWFNZDJlMWU0dG14MCtZYm4yZWdtZVYzdGZxRDM0QUgwS1JlSGJROHFkY0xx?=
 =?utf-8?B?dGtDaGVjNHd0c3VYYjgvWVZaZmNhY3J6c0JrNXk1cHpseWgxQ0UwVmllK2JE?=
 =?utf-8?B?TjV2R0J2b2p4OVNrWUpiTGtsaVJ3NjBLNzFoYjdiNDkwcjBWMFdSRFVxYVRy?=
 =?utf-8?B?Sk5jeUlKb2FvY3dXN0Y0U2RLeTNDTHAxTlBFbDBZNzNuSVhVVlc3YWI0Y2Zz?=
 =?utf-8?B?QytJdUptY3RFTm9sTk5pZHV4czRIVWRrN1BVNmNKRlFEL2Jkbko5VTBOeHNp?=
 =?utf-8?B?TFd1STE4M3Vpei83cUZ3SkhPcExRTE5hd1g5bVdkM3pyejRBM2JvY3BaNHk1?=
 =?utf-8?B?ZG9KRHdaTXB3ZUpDSWNZNWFHd2xMaUk2SjdET1VuelRCb3owTXgzeUVZMUk0?=
 =?utf-8?B?a1pVUGYwcTUzYWVKK3ozQSt2Q1JkOXRjMjBhWmhVS0NUS2RmODlvVFFIQ2lm?=
 =?utf-8?B?N0V1aU1Wa2VyeUI2ZEVScjN3Qk4rSmNvUGFZeGhlQTVJSC9wQzBUbWlRUW40?=
 =?utf-8?B?MnFVUXlzK3J1cG51R2pJRHQ5QTNIMlhPRjAvU2lCYUxnN2VhSitWamZ3VEpo?=
 =?utf-8?B?NjhXYkRSU2diVEkvRkdYcWU4UXlHQjlkRUdCRlF3dGJTR2VIM1BuZXR1cnVJ?=
 =?utf-8?B?VWtCcWRDRlA5RG5JU3dvOGZmTTBkOFlOdDNickFHOHNxVmNSZC9yd2VGSVJz?=
 =?utf-8?B?ckR3N2tad00yalZtZzFZZENRL0VBaUFpY2FRakp6dW5HeitZcnhmV3oxZ3RJ?=
 =?utf-8?B?Z3QwMmtlUGlmSVAvSXpzYU5XbjBpWSttNFFSY3FvM3c5eFJRU3N0eFc5TUo3?=
 =?utf-8?B?YzVWOXAzNDVVZVVpYytScGtmU3FnNVArQ2UzWm9CQ21jWlVRWWl2OHBqajBC?=
 =?utf-8?B?UjJaNnJkc2dnRU9sWDc4Rkp5dmpVYUs0QTQzZVgvd0FvQWphcHFQRkRaYUpo?=
 =?utf-8?B?U1lSVzd3NHlqVnRqZFFGejFQMUVUWGJmc21MM0pVaVhNWTNNNzZMa1c5UjNT?=
 =?utf-8?B?bVVESExRTXlEUUxyUkVyYWdPbU9FRmhFZ0FYZmNnTkZONUJiOVJ2LzkvRDJ5?=
 =?utf-8?B?SXhhbVR1TkRBRWlRelFEVVh1Wmt2K3BwOTcyZTloai95L3FhLzcrbkV0NDAz?=
 =?utf-8?Q?sjnWr15ZnY9tb5Mlsj?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 55d73992-3e95-4ed2-d39c-08def1703e4f
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Aug 2026 15:02:31.9611
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0RIc8vSKNvRBV7wZ/RBOtbV+pxVYP7cfP+dLZogz7olPYYLcI+t9f9/260yhZWJG
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB6298
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 18D881A0002
X-Stat-Signature: j1otadiuq5nogph8b9fwn5zt76xgici3
X-HE-Tag: 1785769362-976816
X-HE-Meta: U2FsdGVkX18oapDjngNrIl1MqUAogdYfiHuBvYYTlKZdq86iJAfPFyrsUs3Gf9yQKR7q6v2JdkMobSawMPDgVzlsFKDXPg9WoetljOs/GPIWCQ/34YelqzYT6pX9WIYtdnwdtEHV3WSctFqGFhxRvtOSHepd3NZA1ghOU17xRdwOLYoWAhhT1fsuZPhYqOfUPIymCdZwpqW0FmqNnNeOtBEBMM1IXu0S5KNxlAc4D3cnB0QaxnU60/SSTnyHeOGrPO+J66jz/IYBVw5kNYRTnXPIh6MDF+jrf1F146ShX6mopgk5Fq931YFD2LGgqc3xR+fCB6vSLnMQJOOYocLLxmhVhrZI3oaOo7uN5dQ5u7p+bwx0uV7l9+JWofvQ6OXF4wcK4kBRjvz3erJy5tzuhlEDbmdOhwYywJBq+UpQSX5VvtYYZ6yhamfg3QRDZFvkzQR1Isou2ghluG4U4wTsB71raFQLxMy+FCQroh7bVARil6WKNjHSVO+vMDQBDvZDtGrIjtB5YbIFQOHUCX6KgAuSmE851FVWWnEzsO82ipddBDtr7stZvgOvUBkUgNjjamncx6iCiyiAoFrvF22AnzXT0hMeLilJ+nXc/KZevPYMZG+xKQkqbhiDBwHaEHJSEifXEPnPVeigfy2rWFT+je3Zf0pCKU/lBcc3y277bVRg/0Xu5231VjuZlD3jQlAqsrGJ1GxdAtLuT5TN37F2BQXbz8MdEA8+ygdTRHhjPt1g93EOWzPnW6sfef24f2gaS3sgmmg5sL518yWfD1Rj8zLRc2ltAv8I2IhuCvUE99ZMDSuzazmR0BnGVY7LE5Tse5duPbqwETkHxLo1oLCIQUPED8w1XJuhAhh5+N16FmwJh525Fo0HOzk2xBWyJEW+CAkihmxFpM+8Lk6DvB98CqnM4oIB7Iu5cvJokaMMfBNxJNvN/biNiHy3fZeTxB3JYA7BTWBN64QRA6stR2y
 MbXILX8m
 dmb5oQMwqPfuwJrNytN/NvagECOePPmVb4G0Qf9KszCu4/4ZIFQKqeEUxR3MnTwJwyS/CTRFLwhX+TGfCKyvR68YUDYnxbPK5oXt2bSxYqxX7FIC2n7jlcQVm1PVMsqOkbPsu18/a3p234hmYi0628nSfxvcNukU7SK+NTD6klOZ2/orepGMRf00jWN2P9au5GNr7hyIQRXu9n2v/owjriS3gWzlOzqDBrQNnuabmMq8ZTTCbfOKRgSIEMrvH7DC80+hygZuYhJBotkffuU8y3ZLCEks25gdSOMykmrefC4xyICG4vxTQD8+VoUTzOt5UgLda3VPIUMm9da4NCaYWH2DihI/HtGzYVNI8w3LFGNerbezcf8TUp+28XW1daZ4kLoxtt7PgT78FhTIgK+kfdUnqMy/GI64LPyfiOAvHnHoU/BqLznKB+xb3P+Jqg81vmN/lTxaOI34rqQ5dTbrBYc/d4d2hr8e/T5UVNzjE7j8Nl6zjD5ZlUDHLL7795+n478BKA5bAcGwnWoVocmmSauCryw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat Aug 1, 2026 at 5:36 AM EDT, Lorenzo Stoakes (ARM) wrote:
> On Thu, Jul 30, 2026 at 10:18:00PM -0400, Zi Yan wrote:
>> During a pagecache folio split, an xarray node allocation can happen and
>> needs to charge at folio's memcg instead of folio split invoker's memcg,
>> because for example folio split can happen during reclaim and reclaim's
>> active memcg might not be folio's memcg. Switch to folio's memcg at the
>> beginning and switch back afterwards.
>
> I assume this is the only allocation? I guess in general it makes sense t=
o have
> the folio's memcg be active here regardless.
>
>>
>> Suggested-by: Johannes Weiner <hannes@cmpxchg.org>
>> Fixes: 6b24ca4a1a8d4 ("mm: Use multi-index entries in the page cache")
>
> Cc: stable?

Like you said above, only xas_split_alloc() is affected. And we have not
seen related workingset regression report (like what Johannes reported
in commit 7b785645e8f13 ("mm: fix page cache convergence regression")).
It might be OK to not backport.

Johannes, what is your take on this?

>
>> Signed-off-by: Zi Yan <ziy@nvidia.com>
>
> Change seems reasonable overall.
>
> Acked-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
>
>> ---
>>  mm/huge_memory.c | 20 ++++++++++++++++----
>>  1 file changed, 16 insertions(+), 4 deletions(-)
>>
>> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
>> index 04e8a6b553435..b9c2d8908e564 100644
>> --- a/mm/huge_memory.c
>> +++ b/mm/huge_memory.c
>> @@ -4063,34 +4063,42 @@ static int __folio_split(struct folio *folio, un=
signed int new_order,
>>  	XA_STATE(xas, &folio->mapping->i_pages, folio->index);
>>  	struct folio *end_folio =3D folio_next(folio);
>>  	bool is_anon =3D folio_test_anon(folio);
>> +	struct mem_cgroup *memcg, *old_memcg;
>>  	struct address_space *mapping =3D NULL;
>>  	struct anon_vma *anon_vma =3D NULL;
>>  	int old_order =3D folio_order(folio);
>>  	struct folio *new_folio, *next;
>>  	int nr_shmem_dropped =3D 0;
>>  	enum ttu_flags ttu_flags =3D 0;
>> -	int ret;
>>  	pgoff_t end =3D 0;
>> +	int ret;
>>
>>  	VM_WARN_ON_ONCE_FOLIO(!folio_test_locked(folio), folio);
>>  	VM_WARN_ON_ONCE_FOLIO(!folio_test_large(folio), folio);
>>
>>  	if (folio !=3D page_folio(split_at) || folio !=3D page_folio(lock_at))=
 {
>>  		ret =3D -EINVAL;
>> -		goto out;
>> +		goto out_no_memcg;
>>  	}
>>
>>  	if (new_order >=3D old_order) {
>>  		ret =3D -EINVAL;
>> -		goto out;
>> +		goto out_no_memcg;
>>  	}
>>
>>  	ret =3D folio_check_splittable(folio, new_order, split_type);
>>  	if (ret) {
>>  		VM_WARN_ONCE(ret =3D=3D -EINVAL, "Tried to split an unsplittable foli=
o");
>> -		goto out;
>> +		goto out_no_memcg;
>
> This function really badly needs splitting up and probably some cleanup.h=
 work :)

You mean folio_check_splittable()? You want to move -EINVAL checks a
separate one?

--=20
Best Regards,
Yan, Zi


