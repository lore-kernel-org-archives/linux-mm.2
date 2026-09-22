Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 22835C982FD
	for <linux-mm@archiver.kernel.org>; Tue, 22 Sep 2026 02:08:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0B1016B0092; Mon, 21 Sep 2026 22:08:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 086A66B009E; Mon, 21 Sep 2026 22:08:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EB9B36B00A6; Mon, 21 Sep 2026 22:08:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id B56A96B0092
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 22:08:33 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 27FD8C034D
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 02:08:33 +0000 (UTC)
X-FDA: 85239764106.27.B0E6C44
Received: from SJ2PR03CU001.outbound.protection.outlook.com (mail-westusazon11012044.outbound.protection.outlook.com [52.101.43.44])
	by imf31.hostedemail.com (Postfix) with ESMTP id 56D5420002
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 02:08:30 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=EcqzZq+m;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf31.hostedemail.com: domain of ziy@nvidia.com designates 52.101.43.44 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Authentication-Results: i=2;
	imf31.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=EcqzZq+m;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf31.hostedemail.com: domain of ziy@nvidia.com designates 52.101.43.44 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1790042910;
	b=2HHjETd3WNg40oNjLQK3VRRS8SyhQWRKjgesCjfQH2yw0Wdf9mDtFEMfVK0duxSBYbcWEX
	Uu9/xCCy6KRV/zuAIwey4X59b+RZPXgdG67bcAvTybWuUw9rS3ShD/UVWrhpOglgQeDFPx
	Nu1A2F8ffzMV5p6W2lf+W2KCdMQzmjE=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790042910;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SZdoIX5Xw+MuxKSEGwIFyg9402wGHsxqV9vsE0ZZIlE=;
	b=PmqfX6eG51CSCySRbmpanYOxRFDUHlmdG5waI6zAVAi9tcDN+YFVmD1RDMFA5/LcVMlE1/
	gGn8ODZny61lrTOQzqS1zpSTzXKyUVIIpkli7xxjrwFYEq+7obT3uYpAQJAan66EmN5yPb
	ZbN8H2sf1c8ZoUzJOBjQTiW+wnbxN+8=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=y9wgs2Ss1mT0b6DP1xAEIbSqNduc18QHkg62f8ApvWk6oqh+9aFESvgS0wzgjOjHv7UZn3EAhi3/yEk/mgI64ua/P5ruRpk/yTNICllivW1X3MF1UKpXkgndZcdWXQileZtJNeIaJj3cwsNtxPqn2U9PGRJ5CD6EcBW++y9820Z3hz3MpN8B2yxs8MgL+r26e33lB4wuRUUFlhFFGPoTBGqZ+MgWBjmQaQ/5CJ9Kwf/YqKUucgp1+nqirB5Z5gnvRiofjx63me8tsViOI0xqpShe1tDH3vsIhf0Tvhx6uYbGT3jjb95YYK3RSaSWHt5TxiYb8RzlqECXEIuhEiORIg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SZdoIX5Xw+MuxKSEGwIFyg9402wGHsxqV9vsE0ZZIlE=;
 b=NMxs6EfH0WBnAOEZtbtrzle5tRZywmRO2QnAV8QpNfmbgAcCHquzbvhDDMk1YpD/we3zfjiVEoROAlVtNRM4adAfTbJ62SVEyu5zhozvtzkTtjMXHq1BCxEBh2vo5RkLpGG2QDdkU1iT4FXTg+4CsNbrjQMEJ8+0DSQ+/c2FzaRsBxuqjAPdIkrVqoclXCDm1/4hJgGt6eMtz4CduYav0xSDNmyhXsBxJFhXcYTD4f13eVmRUJEM1Hzwn0wbdS2yPkz7KbGTJf7PUyRN9c9vHblznsVw7jPw25aYo27SmaXazvGFswI9Cr8PIXTwQ3U/F3lsmGg6oyae4RUXuj2sSA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SZdoIX5Xw+MuxKSEGwIFyg9402wGHsxqV9vsE0ZZIlE=;
 b=EcqzZq+mUl8Vd96GIDAeDS5fvWKxfNBuCGNuMGH1fEsx3iVkHzOlxyMKkPjvGAgNn8paRbX16nmJ3TsZuOYAeWv9mH+uoa4NoXZAwpwgSBvn46ASjoJzBAn+tgfrnb1r0GEindkKhrS37yTOIedixSsl7DNN6WyTNuWogOH+hRF96xevHaskoYXZZ8H28jueii2u6rkPT9qXX6DaksYr7kPFlEyu4BqjvRvCHLUb+tFbLvAwDuz4DdzgWAvSK3ENACbVEjR17NOh0UbLgf0blvLDOL9hXQOaDloXaeknbFfUjqFkME4pf4rDzUb+ehW+PFu6eafMVZNenvIOBqnpfg==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by DS4PR12MB9588.namprd12.prod.outlook.com (2603:10b6:8:282::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.428.16; Tue, 22 Sep
 2026 02:08:20 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%6]) with mapi id 15.21.0428.015; Tue, 22 Sep 2026
 02:08:20 +0000
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Mon, 21 Sep 2026 22:08:19 -0400
Message-Id: <DLLH8ZJAPAID.O0C2M6JKWOW2@nvidia.com>
To: "Luiz Capitulino" <luizcap@redhat.com>, <linux-kernel@vger.kernel.org>,
 <linux-mm@kvack.org>, <david@kernel.org>, <baolin.wang@linux.alibaba.com>,
 <lance.yang@linux.dev>
From: "Zi Yan" <ziy@nvidia.com>
Subject: Re: [PATCH v8 04/14] drivers: dax: use pgtable_has_pmd_leaves()
Cc: <corbet@lwn.net>, <tsbogend@alpha.franken.de>, <maddy@linux.ibm.com>,
 <mpe@ellerman.id.au>, <agordeev@linux.ibm.com>,
 <gerald.schaefer@linux.ibm.com>, <hca@linux.ibm.com>, <gor@linux.ibm.com>,
 <x86@kernel.org>, <tglx@kernel.org>, <mingo@redhat.com>, <bp@alien8.de>,
 <hughd@google.com>, <dave.hansen@linux.intel.com>, <djbw@kernel.org>,
 <vishal.l.verma@intel.com>, <dave.jiang@intel.com>,
 <akpm@linux-foundation.org>, <yintirui@huawei.com>, <dev.jain@arm.com>,
 <usama.arif@linux.dev>
X-Mailer: aerc 0.22.0
References: <cover.1789695931.git.luizcap@redhat.com>
 <700b622814a2b294083f9066631f655cf61c3070.1789695931.git.luizcap@redhat.com>
In-Reply-To: <700b622814a2b294083f9066631f655cf61c3070.1789695931.git.luizcap@redhat.com>
X-ClientProxiedBy: BLAP220CA0015.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:208:32c::20) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|DS4PR12MB9588:EE_
X-MS-Office365-Filtering-Correlation-Id: 270e60ac-d7e1-4a8c-953f-08df184e5fb8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|7416014|23010399003|366016|10067099003|56012099006|11063799006|4143699003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	DUP6TBONU0kErFbuYr/mbhBXVjwYvIAhXCFXuIQGLYLYCBrxD8z940jJvwlaOxVrMHk4ogN29P6KIqmzRzjaf6AVx2yYYQ/tU2YXMS4ZCSROPhpDCbj/9jE+7gkoncqSMXq1fWTlfoiIhnjUnVAkCQYjer0qai+vmFKbzsNKkl58GdU+3+QovWNMg2dYOt18sTjIuyzESxYpVMx4nowVhJk/KwMD2eCM7i8ySRYEO53B6fNNEH22BV31VUUzifF4ywoHJIjhfVlRxdtrkSPa75on9xqKtOkNpRYPrtHrgLbVb02pnsQHDcakaWLEBOQQ8IzLJaNNphEKCt82iSA1fG/Rl6jyUEaapXANl9cf+7X/9ddCd3Zw00wr7TgWF1OzqCH2QRmxY8TxHR2TYJTxHof9lhfqv1QTIBTQ/NwRd+CUA67KtCd9ayPr5hY+xiI5aPQTQw5aHfOmuj3eIf41HawF81F22C2eFD2In/E5U1cGD97+fls3LKkjzinTEBYtcScqPeY51PQ5WlSv/hMxGiNZXApuplzkYI6VFzRTNZcGSDmjjYMEzJ8uvM2w0glb0jY3orJqCXGvtUlLaPUdpGBeVetQCdNpiY4BZyJMQaewIjK3spesvQ2gcgMy9VJ/Ck6L9atE0ivMl7fzFpZZvV8zL959iEh1rk6ynls+9tk=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(23010399003)(366016)(10067099003)(56012099006)(11063799006)(4143699003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?YzlkdGR0TW9HblhtYWZPeVVsNjJzQzZxV3lRTktyenRxdG5MOFZEMUg1VlZj?=
 =?utf-8?B?NTFBVktEaVkvSEtSR1ZsZWVXci9tYUt1VDM4TkdCUnd1MHlJTE10aVRCdUh3?=
 =?utf-8?B?VU1nVnBwbFBCWE1XbEFzUHh2T0gzRHA5c0tPNVJoRVlYSlVOeTcwNGJVOXNu?=
 =?utf-8?B?TC9HMW90TWFLY05WbTU4RUtObjFKRWtlUUFVazUxcFpycEEvamVDczZuNVpG?=
 =?utf-8?B?T3BjY2dRWldBWmpONUlsci9LRkx4SmtJa25LQVpSVzY5K1pVRTRlcTRNR05Z?=
 =?utf-8?B?b1gxaE9VaGJPUmg2QmJRaXZVNFBNYWhVTytqeXZuSmJtZ1RBYlN0cHNIazkx?=
 =?utf-8?B?ZHBMN0NsN1psRVh0UWs4c1YrMUkwbTJvS1phTFVYQkp1aVV6Qm1SeGRRZHJr?=
 =?utf-8?B?UDRENFpMcFNtdGhmaFdONE9USWJDV3hPRmcrbi9FYncyNTYwMGgwc2FWMFgw?=
 =?utf-8?B?YUYyQVprd1RHbFE0bGxyVUdNYTZFeVEyRDdSOXlaTkNQejdhNFc5eFNodlBR?=
 =?utf-8?B?SDM0dEVqWDhWdEp3Mm1GWkpJVzRhZEJQM3c4M25YVEN3ckFMOVRxODJmY0d0?=
 =?utf-8?B?c0pqOTB2ZHdGUXRqcVpMaXhYYjdrNlJZUjF2dWJRTGw2d1RxTkdFaXA3NU1Q?=
 =?utf-8?B?TFJ1alFoM1phZHh3WkhLeUlNbUFxMWQvM3B4MTJzRWJCU0RZY0hrMkw5VGhu?=
 =?utf-8?B?VDAvdjE4aDRmcC90SnQweTBvbVowbmJ4WU1jTUw0YW9xbGRiOE1ya0Q4WGpi?=
 =?utf-8?B?dHZFTUd0eFdkdEQybEdkaTQ5N1hXcVVVQTd5WE9ISGp6TnVBWE9HTW5acFlz?=
 =?utf-8?B?NVdYTEtNSUZOUEhIUzZaaXpqYWV2VHVDZGlUQnFRMUQ5bDM0VVYwQWU2M28r?=
 =?utf-8?B?UzZnZDVxYlBvL1BOMmxzTCtQYzIvV1M2UnVrbW5rNm1qdTN0cXlxaDJ5bHdH?=
 =?utf-8?B?TWw3bzgvNDhydzJQTDV4dXFHaXVCaFBkajVaaXVqODBXUm5lNUFXb3Q1STVM?=
 =?utf-8?B?UkFhRW56TWF4WTkrVElwWDg2S090dTFhZHdWazl3MnRkR3pXdzZNWnhua2hj?=
 =?utf-8?B?RWl3MDE4ZU9sNlFwWCtrQVBla3UzSVpoeWdRalowR1FXYmdCeU8xVlJaeXg1?=
 =?utf-8?B?SXZCZHRpWDBldEVlbEpPdklyNWRVdXIwR25TMXhNbG5aWlhrUXNWZDlwRTdR?=
 =?utf-8?B?TGM4bjIyWnZ2YStHT0UwWXdMcUdCRzFVbU5EV0U1QnFzWE91MzR5cE80NEdh?=
 =?utf-8?B?QTVXUkRseFJucmQ3cUlSUndjdTlOOGtheFM3dDBXWDEva254MzJhWXJrY2xp?=
 =?utf-8?B?UnU5azVhL3FPUUNSdDNlUFlNU1VVSTVOcHJ5ams1Ymw2d3RXd3ZVbXVHcFBL?=
 =?utf-8?B?T3pFcGUyMnBpSHJJVUN4U3Mvdm8xaTlXUUlOU3pLbklUQ3BoWkhLQ3o1UndN?=
 =?utf-8?B?Wk5qWWtiZGZxdDIwVW10eGhxTDkxNmt1dEs5aW03TTNZUXd4MVFiR2N4bk1s?=
 =?utf-8?B?cTRqdyt3SVM3bE9Ia2VzUjMwRUt1T09DNCtNKzVBUmNYdUZmbnJYRTRLa2tD?=
 =?utf-8?B?VXY4cGhyQXVFR0p2blY4Zm5EVVJ6dUpxRVkxU211Q3pQM1loc0prdVVua1Rk?=
 =?utf-8?B?VTErRmpYd2E2MGtMUkZLeDU0ems5REExU1JvUXpVUTR6T1FsdHVDNlF5a1pL?=
 =?utf-8?B?bGZjdzFpL2sxK1YrRHRzV1N0YWJWdjVhN2FPcXFLd3VNT0QyeEZYbVh6aURT?=
 =?utf-8?B?dHJEVGtKNnBGZCtiSnNrbmswMnhWOFFhVUtNTDlUVEgyRzM4Rk41YmdwWkgz?=
 =?utf-8?B?dmNXOWhSQ082RDR2ZkFvY0hRb2kwUkliUitSQ0UzM2xNK05pQlh0VzRnYlR2?=
 =?utf-8?B?TkM5Z3lqMktOcXZ3YVI2a3FEUzhjYitiT2laeHY4dWllZGYwYWNuYWlQcjdO?=
 =?utf-8?B?V3ViUkc2RG9wTHFtVURZZTdJYXJxSEQ3bnFtZnA1bGREcUZHWmw2YVByOUsx?=
 =?utf-8?B?MU1qdEhjVFZCT0JoOWI4N1dFREJVRWlUS0hUeFV0bWQ2b0ltd3RQVm9CSzRB?=
 =?utf-8?B?Vm5GYmE2ZnNERC9sWXNtMG9WV3VFY0RlTzd4Z0pGM3RWejl6bnhOSEhTVzRx?=
 =?utf-8?B?UXlrZ21SUDBOVmF1NnBFZGZRWVc4bnRZZktRR1pRSW1HdkZPU3JxeDBaY002?=
 =?utf-8?B?bkt5SlRBZllwb2RleUZaTVZGbmUyckpQMTNpTHRmUldEVi93aWIvMkhZOUVL?=
 =?utf-8?B?VWFXcFlpSy9TTlJtdTB5K0VCNFQvNllMaDBiN1ZVa05CcUV5VGxiNDNOUHlC?=
 =?utf-8?Q?j6R3VKjD70EOPvHT2g?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 270e60ac-d7e1-4a8c-953f-08df184e5fb8
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Sep 2026 02:08:20.3550
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bb9hFdTtmOYbaT7fa/2qOg4h1n+SEn/EOM7bjiNDiJEHPaPxKfMIAPR7lfr6e/D4
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS4PR12MB9588
X-Rspam-User: 
X-Rspamd-Queue-Id: 56D5420002
X-Stat-Signature: hu794enfd7jkfsbb7mmiwbjgk6pp1p6h
X-Rspamd-Server: rspam01
X-HE-Tag: 1790042910-903841
X-HE-Meta: U2FsdGVkX1+ZJQxbpj+ucJWrDmOUMzwadsICRdOOcCARbWcFbQu8z6F/HI73RrJ6FxNfYL8YN57tTM9Yg944ENfqAOHpQ4VVmSl2h4koJoXouH5Rl162WvbyP0DCWvoBsGT4qharghKqa2zT3hRJQGnsaUJeWpxk7SKRPifISMb7fsHtmu2GVWJKspPRwkDtOK/kKY0+rMf3FKM2/3KAX8YvfcTxbSY0nPzd1O0/KJu3N8YlHPcokulXs+5NaGB2l7Tnx2erDww0t6cgTEocUlI+dKKnbneU28PANQCUOSuYHBcwrP8Dp3EOPoZ72iworAcz2FB+BB0K8DLfm4QipeHiOJZ+vBXvt4I4zgZb+pWCQkwQ9zDuttKIC2NPPx9WbIKPcMf6scOIfu0Q24Pr+UXxDl9Y5kRT7Aoi2pvCaKVDYMKLmO0KvuZcDr5IQMl7EmDvG1NB/zZyvw8zQvUFwAHfiVS3wz/kysOqMoriV3fxTZuyhywxyNSvL5c+40lo+RS6lyo1rJ8ny09DE0p1mIU0KNjUj12AkPgRJuLW9nmgrMTto8Jte073U43lEX2l+MdhV37ti98s2TaEVbePwzcrwVZT0FINQKkHk/XrNpXpZ3GlLzxK6xCfPxtXGIAHM7rrCiUIA9iZqQmTcwgjUd9PuigMV2J6SxrZ5O0RCaZMC6t0xFMmnzseJi+3pOPXtCkx+QoYMM6C6LAB/gGXmkIO7kPJoMn7PNpKWi9VgZCul3W3N8L62UFfQs+UoAibQJcM7xSaUCQl/8gcT3Ib6znV+NbjYlZIqHSIG0XDHDE4XSeyLMQzFdI2HORYWqLtTqumWzGWAiDaVTyB1SCQ3wGmLY/tTQVfJ411Xkt5JczHCwKGiDd6iVpKIRMRhVp5o3ty4NEpVlQ1fUOgOTxAn/J3Om736TRD3w9shBIQV/CLFOoWGqZG7NltK1U/dr+xipP4xx1cdo7LOq+mb20
 M6+CkgiG
 KxFOUCIJFoV8gpgRhjniYabCT6k1ExhlYIFl7Pbb2OuJidu0bcpBteH6tBS4tjj7m3liMfBqnHF6kQjBBaj8zcXZgdnZi6tc6XG+Lo2CnYbNOt8r8RyR1lzbZ6YGuMKyQj/SjZ1n9NZSraRbsCjjJ2N+ioumUsVTM/ZasCAF+/r9U4ggyrtr+UrWAB785xgOB5XqAWWsdCAv9O7ARttUmcIludydvefYANP+yuC3m3Kz9w2LocSybq1HrXrcxqatXOLLanPudBb4dBS/vrd2z+/TR4JNORkqFVp3mweHtl7fPF7pjz2gdwhV2egjjE+Q/3iIoZ8TVegsp9rKtBjLioXy35fG7oG7XePWd6yckOe3H0201m7LeFeCZQUvcNH+IYfQnPlHp6AnJSsO8RJ8W0col09HZUKoMxo0YI6sGRC7kMeITcebtq4oMXfAnXfA6qyHuOYbrbTs7aKlHZ05uNc3t4CE94R2IBjWJGVe1beHHu60=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu Sep 17, 2026 at 9:45 PM EDT, Luiz Capitulino wrote:
> dax_align_valid() uses has_transparent_hugepage() to check if PMD-sized
> pages are supported, use pgtable_has_pmd_leaves() instead.
>
> Acked-by: David Hildenbrand (Red Hat) <david@kernel.org>
> Signed-off-by: Luiz Capitulino <luizcap@redhat.com>
> ---
>  drivers/dax/dax-private.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>

LGTM.

Acked-by: Zi Yan <ziy@nvidia.com>



--=20
Best Regards,
Yan, Zi


