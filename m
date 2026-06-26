Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 716B4CDE002
	for <linux-mm@archiver.kernel.org>; Fri, 26 Jun 2026 00:08:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5ABFC6B00D9; Thu, 25 Jun 2026 20:08:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 583B06B00DA; Thu, 25 Jun 2026 20:08:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 44BE16B00DB; Thu, 25 Jun 2026 20:08:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 13E736B00D9
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 20:08:31 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 9C23A4032E
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 00:08:30 +0000 (UTC)
X-FDA: 84920127180.14.9EC8B9C
Received: from BN1PR04CU002.outbound.protection.outlook.com (mail-eastus2azon11010032.outbound.protection.outlook.com [52.101.56.32])
	by imf19.hostedemail.com (Postfix) with ESMTP id A5E6F1A000B
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 00:08:27 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=C9G88KP9;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf19.hostedemail.com: domain of balbirs@nvidia.com designates 52.101.56.32 as permitted sender) smtp.mailfrom=balbirs@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1782432507;
	b=lEXCXYYfEE6ibkLaTff6/fyvqK+EKJ2Bd807xiMZS7djK6X969jthX6JPcmJPl9axLt8dl
	q0nyj0uH9Ed8fNvtaCnBFs92J2DsjyHLGonqoHKN5PNo3AB282XwaVX1BbUSeocvhrXCTx
	zTYgaF90jWW+Kt7BstkrdyPmN91IvAY=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782432507;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XwD0tfajSsLPSed7WN/n7UmidHs2jHFFrj7GZ7uFg8I=;
	b=ldy3BLy2Pr9URcIFCOQxCG/sHbatCntZ1eZN5T8405y5yWgoUNXFvmza2wOf06dnn4qiGj
	9+FrKQLDG6IcvkyTXoHzuKqkWQxrquFgIHdzmJ2RxzSpa523eUjgDirzudAYa7Ioia7QFA
	FZtclGXVFc61TkQl0Dz0yy7xRggkrjA=
ARC-Authentication-Results: i=2;
	imf19.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=C9G88KP9;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf19.hostedemail.com: domain of balbirs@nvidia.com designates 52.101.56.32 as permitted sender) smtp.mailfrom=balbirs@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=H5orqPTnownDwAvG5f9ttu81lrrshyLSo8x/LZtSyIZ2xcy4xtJJb/nR/0SIjv9jrfTlPc5hE9cchXEnnTo2WBLqWJqpvTqYAPDoNjjnlJ06/QccwwpS8Qx8906dBTen3W1CPLniNQPj3AuFfSab8vd6MHKF4coGHgYJ19hSnmJXtLin+Cf8NUvgtKqHqidxLuqOmZHvB6e2IpGOXbrKvXU/alSQGUlc9RsYiLctni8Zlsd4jSfGXjwjsHMa1lTr4tlBMheM5adL9xkHIHULNNp5rEkRv9l0eqFG7q7zYVY49HoYhSGoHquoZXqHvN2uL00lj4mg4U4HnqTCYP5z3Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XwD0tfajSsLPSed7WN/n7UmidHs2jHFFrj7GZ7uFg8I=;
 b=RkDNvTya12nE7bhgjxr5Jbphm3r+SOb66vicYyYU0BM3601Dshr1n9seDL7QORIGJvfn3bf+YGkGH3lfB2xb/G25bMpqZVMa0jirfXaDL7w0LsZsSu4CfylUMmZQAFB/Mo7tXLWrLele6oQW4bWjWuKsvGw5j8pSK5LcAnnocYaecy5LEjPb1+gj+OZMgRdL0MkvUfB4lBsKxUsCcPVFDGrl9XW8zoL1U7JgbBeBkfdN92wRrlvoDQrn2DbsV3gaDx6lyOsHChXkF1XFY1sA3RCtA5KK/RjMvnhkNbQMO916+tooWJXAttsEs4i6G724CT7/XxdE63inv4MXZZkOxg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XwD0tfajSsLPSed7WN/n7UmidHs2jHFFrj7GZ7uFg8I=;
 b=C9G88KP9M6NCdrbur9wSUwBFNlLV3CFXhdjXms5IavRu/XF9pNuDNnFlSLhHgBrhxnNU5hewVXwUmGfoa7WTlZrEKuCtpyYuqd0kGicNoYYk9ntFDLwn91LTsAzchZtmj4BqVZh6PPqzCgIPU9eXldAT6O+BF6RURINLYlMXR3stRdtTGF2jHJcFGYqE8KYYKw/Rrt1v32UG3MxkvZcyzXx2eKnOHhdv8WWrt6amffhjYyZvhmTSv/aVRjLlOs8R/6U1gjvQzx5sCNbkTJSpxrbMnEVjNIi1opVXu+CyFt+siD7BMHoUQuoZEpRSC5IqVNCQqipIFuV2zMsHwo/Wgw==
Received: from CH2PR12MB5001.namprd12.prod.outlook.com (2603:10b6:610:61::18)
 by DS2PR12MB9589.namprd12.prod.outlook.com (2603:10b6:8:279::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.159.14; Fri, 26 Jun
 2026 00:08:17 +0000
Received: from CH2PR12MB5001.namprd12.prod.outlook.com
 ([fe80::89e3:6df0:de90:8dfe]) by CH2PR12MB5001.namprd12.prod.outlook.com
 ([fe80::89e3:6df0:de90:8dfe%5]) with mapi id 15.21.0159.016; Fri, 26 Jun 2026
 00:08:17 +0000
Message-ID: <0ed9b9ea-6294-44e4-896a-36a1541ebd47@nvidia.com>
Date: Fri, 26 Jun 2026 10:08:10 +1000
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/page_vma_mapped: guard check_pmd() with
 CONFIG_TRANSPARENT_HUGEPAGE
To: Wei Yang <richard.weiyang@gmail.com>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: david@kernel.org, ljs@kernel.org, riel@surriel.com, liam@infradead.org,
 vbabka@kernel.org, harry@kernel.org, jannh@google.com, willy@infradead.org,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, lance.yang@linux.dev
References: <20260624082359.2869-1-richard.weiyang@gmail.com>
 <20260624131457.ac81fbac373f78aa80a516e3@linux-foundation.org>
 <20260625034629.nmgdwl2c4luwod77@master>
 <20260624215943.332f1bdcc99a3b85b7df0822@linux-foundation.org>
 <20260625064102.tcmvrctcqibl54yr@master>
Content-Language: en-US
From: Balbir Singh <balbirs@nvidia.com>
In-Reply-To: <20260625064102.tcmvrctcqibl54yr@master>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BY1P220CA0045.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:a03:59e::14) To CH2PR12MB5001.namprd12.prod.outlook.com
 (2603:10b6:610:61::18)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH2PR12MB5001:EE_|DS2PR12MB9589:EE_
X-MS-Office365-Filtering-Correlation-Id: a6a955c0-fe86-4cd1-e05b-08ded31705a3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|1800799024|376014|7416014|366016|56012099006|22082099003|4143699003|18002099003|11063799006;
X-Microsoft-Antispam-Message-Info:
	1PAM2pVEWDB9xoFhHbR5/1rJ2sqqiFg8FfGew9UpAZembfsYn7bksyKtN1xIB5rJQbDR+NywOp5rdLT8lG+mynxNn8QT5oPXmR9pNQdZWb/NniosGmFTG06azx3/BHmv6IihKtfCXkEjziaqQPHiP14dAgSVqL2YFuM3BRIVwcXtDbduDhkGSj6usntKizbYxViZYMIQyEGA5DlbrW3ZY5gltEhi56CQCOonbsesuOcBcE13I3ewjcOFxfnAvwlB51/chAWG+7h1Xxz1ls08lr9mzHSQmY2g5EhaTv9MuApGGTa/gE1JqUUkN8NWW2/xBt+DTa5UCMImcn0PhnPAHlWnjZdUXLzPorrF8LdaCPxO62uWAIN22rrSTwK47uzKhowiasQApkS/GKLQHz8j8dV6Vas6XsVAujSannP9jVVF97tNk4TMRXugdMEZ5bTJdY765vOlImRfqdyv2jpnVAiAsaavx86vuVJM2CTL9D2G7jzm5h1askt9nty6L8ptLlNTnWM3+KeNUB/NrCDhUER+iP2H6wjCSxNKKxw//FoOY4jCmtyMV9FfWsdAc3I/XDSWp8AO4xg6ptiUDMZfMEMJ5hu3NMh7xkKnGR+pKDsSIrQ5RIK+lEoSf9aA3CleBHkDvzIOzU+uPQrWduox2GGgk+J713DRXD/1ueapFLg=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH2PR12MB5001.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(1800799024)(376014)(7416014)(366016)(56012099006)(22082099003)(4143699003)(18002099003)(11063799006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?YU93NnIxNDdnMlVDOGErL0R5TzlSRmFGTVJtQlBCS0lYbjdPT25oLzBJWnhh?=
 =?utf-8?B?MVZFVVRuanBvTXo0OGhZRlp1M0xoVnVxQVBkZHBmcHB3UlNsd1VVa3hVTWE4?=
 =?utf-8?B?bUtwK1JCZlBRd1hIRjBwYzMxNlVNc3pMYWJ3eERxdGhOSTAwbkZ1ZDYrcWdt?=
 =?utf-8?B?dHNMa25qelJxY0NqVUhnZGFIWnVmMStQdGtoVzVmYmI2WVliditpM3lhRHJE?=
 =?utf-8?B?OXhuQ2VTVlRKdW8rL1YxUHdNMnNYZENSZ0RTZ0xXbUs5anNIYmd5Q0NHZ3Ez?=
 =?utf-8?B?c0RFenJsSlcwRllkOTBZcWhhYWNRZkg5TmhHTHBiQ1QvNWRjcGY4aUxEZ01o?=
 =?utf-8?B?WVZFTjhmQUI0R0RyWkduazZvYXRDK1RDS2xWU0Q1THZKREs0dkFCU3JpVEJn?=
 =?utf-8?B?M0crL0FDTDJrd2svWXEwTE1JZW5LRHVuZUlyMm5HR0hWSnBTbVdORHZoV3JR?=
 =?utf-8?B?RXNzV25tQU1QdTUxV3VaZUdoZVZnUGR6UzlRR2Y3Z2RaZ3VzU2lLTEVScU1Z?=
 =?utf-8?B?aGo2c3IwS1IrUjkvRC9kZm9xOGMyUWZoMytzSFJ2cytIZ09pUVdBN29WU25m?=
 =?utf-8?B?ZWxJYnlQQ2gxMHdBN1UyWnowd2pwdzhyZE9jNUhRTGlyRTlCZW13dkhYRm4x?=
 =?utf-8?B?ZkJob3psMWZTNW5MWllnN1Zkai9YRktzL2wySjdNZHg4TGVjVU4rWUMyc3RL?=
 =?utf-8?B?ell4em9oTW9QMGlCYm5OODB1TG0vbW1NbzlIYUNURHI3QTFyRzZqWEdPUlVk?=
 =?utf-8?B?N3g1ck5OdmdJYnFRL05UYnJodjE3cEx3RHRLU0grMU9ncDlsT2xGSFRQeGFU?=
 =?utf-8?B?OWZFTE5id01UUFNLbDlscWRqeUs3bCtUelFwRUR2WkRJSzJkNm4wdlhRcENT?=
 =?utf-8?B?a1JPOFQxR3BnVk9hanNDVXowZ1lWZlAvY3NlVFA0ZlFFZFhKT1pBNUJrd3dw?=
 =?utf-8?B?OUs5bnV0QVRvQ21WYmQwaHJtTjI5NlBINkJHcXJaUENlSmhkZkhIamoxY0ky?=
 =?utf-8?B?TFQzdXUrV1JwaUljT3VuRndDU2QzZ0s4UzQzVkQ5N0l1cXRwNHdpTHZndW0r?=
 =?utf-8?B?Qno5REQyUTZBb2RoUWVTdlh2VklvSFN0d005ZnptbEtOZUVuMzV1N0laOXdW?=
 =?utf-8?B?OXNNZmQ5a05TaGhZcnY4NUhGRzlxMTEyMjJOUWV4S2hyZ2ZuNkh0aTBNVURF?=
 =?utf-8?B?U1Z5NVhaUTFMREV6L01KaEVyVXo4N1lpU2lnUFQvYW5ZL3k4ZTB5TGI2cjMx?=
 =?utf-8?B?bEJWdzhhdjREVXYrZFdtd1lBZzl3SHBwUGpqUjVKSnF6SmlEWFlnRUtDSW1W?=
 =?utf-8?B?MWI0U094L2ZKV2s1OTN2SWtpL1lNOUdudU91Z243UDB4TTVvVzhad0JTVm5t?=
 =?utf-8?B?elhCbjRnbVgxQnlEQ3MxWnFUQ0Q1Q2VnaGYzMnRYZVltUHJqd1NybVErbDgr?=
 =?utf-8?B?U1N1SUVwTkVvamUvM1lTMkNaWlprYUg3UVJvRjJpZ0VvV1R5L3RTcXRCWVhX?=
 =?utf-8?B?R3psYitqSmJYS2crQUs0YlJEQStHOVIxQ3FRMkQ4ellITXpoRXpQVTlRREF6?=
 =?utf-8?B?UDUrdjNqeFUvL0RDUzRZbEtSOWU2UUp4QjhsbVJyZzMxcUhLbmlnbnhncHpx?=
 =?utf-8?B?MWd2VVJIVlA3QzZnbkZjb1Y0WXlGMGJnQ0kvWERZdTZSNzJOUHRxeFRIVkFa?=
 =?utf-8?B?TTU4NkF3a0laT1pKOGxuWUJLZHJrY1ZGaWZydmNzT2tkdzB6cU1XOFpsR05m?=
 =?utf-8?B?dkJGZXRZWWR6Q05WcndvNmZCd0dPM0cybjRMZ2p5OUgzSjFJUXUwWDd1Rjg4?=
 =?utf-8?B?YW9aNFJsZmZJYnR2endTOVd1bSttL05laDhUenlJWVZ4S3hzN05qRUF4Q0oy?=
 =?utf-8?B?aDVKc1htaDRWWmRLWUEwQTlnMDIxbDRtam1yWHRWSDhBSUwrNUJocWZTRWpw?=
 =?utf-8?B?dzNUbVpQaWpwNkd6L3UycGUzbTNSeEdwWUF4OFRpNVYybTY4SWRUVVZOVlNZ?=
 =?utf-8?B?bEUwSEl4ODlkK0VhcmVpeFF4bHZseUFsOHZMTUtxVTNseW9FaEd4SjkxKzlC?=
 =?utf-8?B?K0xCU3kxUnBsdmgyYmJBMVhNWFpoTEhpd2JPNmJQdVVBMmJQNTZZUTc4MGhH?=
 =?utf-8?B?VFlzZ0pvN2lHSUVUdnlOdDl2MFJlL3J2OEs5dEh1VlJ5VWtRRVFrQnl2Uko4?=
 =?utf-8?B?cnFsanYzVHBGdGFoVTZPQkk1cUl2aFBHb2RzTmlHMUUwY2ZSdlllK3p3Qmx4?=
 =?utf-8?B?VHhRRk1EallWd0g0UDEzbG5jQmRqZUwvQjJBVVdnVDlHaWdNcDAyREkyYk5V?=
 =?utf-8?B?VmlUK3pHaU51N3l3RDVIUmZRMW5NV0FIYlJnaC9XMENEM0ZEalpJZz09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a6a955c0-fe86-4cd1-e05b-08ded31705a3
X-MS-Exchange-CrossTenant-AuthSource: CH2PR12MB5001.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jun 2026 00:08:16.9999
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: IYcgpzVH2cpBSdmO8QoqV2CvQvgPKzE5bgDbwG+ibJrDXPvKiUpsjWEaGb2hsrBSTyHo7fBuqDUc/4W1hnEJaQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS2PR12MB9589
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: A5E6F1A000B
X-Stat-Signature: ap7m9qucmqq6o4p3iokamufmpmn8ky8b
X-HE-Tag: 1782432507-603388
X-HE-Meta: U2FsdGVkX18ttHra8dUWr7yM8p4FMg4U8m44yMr2Pt3uebktBkV89jmGoqjEVVGezbakf+YtMElxIPMSJQV4E3iG+Wmxblv3vlnhAktNDNk4eR9myEmvi7itULWREIjlOBf0/0npvc36EbsIciPVKT+Ug8AOvI7MJAHMNZKTU6lyyAz2eHstWVq7Rw752ETaUX5O3Fx1DWkqatR5TPdgXXrAtZjHh9oQbEswe1VhoXuP5jMAMpLuOu57aH4C8wr4FCE+Dcu6QONBSsb8557/ND0TGioS+GIZ+uYt0hO0AmPClpb1eRN3c8LeS/YZsSmTG1gR8sNEehORMdS75C60WNx1jQ9zUwvLRe0fqDMWIyhPO6SvEsKyossoEw0n7Pqhqcksqypf5Ytws9PLCxupEjwlxmAhIQnNU0O7BdTax19TJ8cQc1YTE1R7qhB5jgKr7AwwkW9oE4arHiz7QxODIA+BXXi2pj2Rxih+A1fGjN4BsMvzJyRaHV5XTupCo9nMQ8QndwiL2L+Um03TENb3quQ4OF9zXWopchrnSDSAlW83TRpy1yZSdi0b9EJDazw2QBx1PIehV5n8N4g5fc4/Q5rEOUPMDvUNK3WzUYKjDqav2G4jnkIdig+FsCD+DWVTzjE+rjLfZaykofsMGJR33RIYdcwKRfWMMyJmlvyX4yFau9g0jQFY9J4d3EbvMpSMTEHBNUWGfYpvuP2aAaT0yKTD6YX0Ky1qEl/AFWUQU4CIuQrekAhPMZlNpScOqzylM0rTKOpZ63tDHQq2Wl2ptaNwckkk4Je2fEXz9CEG8MlBZ8QtyGzZ7yMG/j9Bsp4FEjTpEIi9CzfTQ7KDGSHSBULFHMvt5y5G9BNIrUS7aVjLm7Xtcc+L13OyQSwe270/6fCpOx7II14LMtNwDbF/AHYzLQbUG8Y4dkzbfyJXo0booZFFL9TmOI3l8hcwOMrv6Tqdi6oyntatlJVxATj
 JrOdhUmh
 vbJYZh2fnjc5vYCRhVGlEk0CCoazQXozuodyjRJpwLR9LdfJFfAbKDUXVJPOqFBeFDV80F3qg9OjUjXaJ8L+xECDIHzthnxuC3k2Myk2SKAfbkOn0nsyZzLnuNkW5M6XoQL5zU5h28bqtwlSkvcU70NrVkd1qUb4ICdFUHsDRnnu75rOFvp209rjzkzc6LCypTMv/BIm+hgA+nb+qL8frt1/Tcn9P4P0WtbcmYHBmz4joFmcsP1aBhBx2+Tq5SJloDIqJmvR8u16ghRpSXjNMaqwsQb9wwggEHLGyUDkLDMQMxZ3AdpttHUYHgaEQQghmI086T2KXoQLKi+J+cV9uH7vSSRVGqzJ6oa9Qcua9vdynabwLM/PR1RA4TKo15WXg3o4FqUp/VuZyOs8lAawk6L3WETViWq6bwLxjCGveGxWflaBxHpVSFu9E01tPorFw/kelZNNSrioWe+WiaudyRXIqad7OHZu2PyIK6ycQyiCxltjGEWLhqoVVdSL4WcY7RmWNC7HrTyRIKTWTYR49AoyDaWF29xMb9rt73eGF3BZ0yugN2iywJ0IaiEzUSErvnd8nNRD0ksIMK4w3qiWuaS0oulEheumsHD+ZAsqW5u6Ks4Wb0Ig9FvlwS3kc/JM4nWA56U8ZjkaoCng0v+keb8kSUNZI1e2vgD0d
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/25/26 16:41, Wei Yang wrote:
> +cc Balbir
> 
> On Wed, Jun 24, 2026 at 09:59:43PM -0700, Andrew Morton wrote:
>> On Thu, 25 Jun 2026 03:46:29 +0000 Wei Yang <richard.weiyang@gmail.com> wrote:
>>
>>>> Sashiko had an off-topic complaint about the surrounding code:
>>>> 	https://lore.kernel.org/oe-kbuild-all/202606240042.ffPsEXVc-lkp@intel.com/
>>>
>>> I see this robot reply, but not see the Sashiko comment.
>>>
>>> How can I view Sashiko's commnet?
>>
>> oop sorry.
>>
>> You can go to https://sashiko.dev/ and search for the email subject. 
>>
>> Or append your Message-ID to "https://sashiko.dev/#/patchset":
>>
>> 	https://sashiko.dev/#/patchset/20260624082359.2869-1-richard.weiyang@gmail.com
>>
> 
> Got it, thansk
> 
> This one mentioned two things:
> 
>   a. page_vma_mapped_walk() return without check
>   b. whether __split_huge_pmd_locked() would split device-private pmd
> 
> For a., it is being fixing at [1].
> 
> For b., to be honest I am not 100% for sure. If a device-private pmd could be
> file backed, then this looks like a bug.
> 
> Balbir,
> 
> Would you mind taking a look at the second comment raised by Sashiko?
> 
> [1]: https://lore.kernel.org/linux-mm/20260624065353.1622-1-richard.weiyang@gmail.com/
> 

device-private pmd's are not file backed

Balbir

