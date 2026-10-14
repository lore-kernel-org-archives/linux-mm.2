Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5144DCC6B1D
	for <linux-mm@archiver.kernel.org>; Wed, 14 Oct 2026 15:19:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 667E96B0096; Wed, 14 Oct 2026 11:19:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 619486B0098; Wed, 14 Oct 2026 11:19:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4DFE66B0099; Wed, 14 Oct 2026 11:19:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 24FCD6B0096
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 11:19:32 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id B8CAC1A05FC
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 15:19:31 +0000 (UTC)
X-FDA: 85321590942.16.9870BD9
Received: from CO1PR03CU002.outbound.protection.outlook.com (mail-westus2azon11010009.outbound.protection.outlook.com [52.101.46.9])
	by imf03.hostedemail.com (Postfix) with ESMTP id D914120002
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 15:19:28 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=YmsJi9YC;
	spf=pass (imf03.hostedemail.com: domain of ziy@nvidia.com designates 52.101.46.9 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791991169;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aA72n2GJNBMrnu+Sp3peTq+zyhEsFPOIvT+H8n5i3C0=;
	b=feFRi/gRVNViZNqWzR1biOtRW4aIZawFobkLqfJLSFYQI3V8ThFqTvL3GeNITHMbZNNL1C
	EqlxcOHEb+GmXcTvvpJMnB+ujZGX8YHa9CxIBwOaTog2wAiLhlOiKkkPDSKOWkuIqSLE8w
	oTZZeBEUdqGb+4eQ/0YA7zdSbakLk0w=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1791991169;
	b=UQQeFU0BFXhlr3+29Wxc4b+s5j/TOLWmOpEZAh65Ay1gksLyPsJsBARP1n6iJAMGdK88Y9
	5u89AkXuV+/WzrNK0lJ89Dw/fxo7UGDeuSammR6quQcjStSRR3G420RHm2O5nxBVAdyzRy
	rV2TEUY542vb32dsyzA9tLeumgJE328=
ARC-Authentication-Results: i=2;
	imf03.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=YmsJi9YC;
	spf=pass (imf03.hostedemail.com: domain of ziy@nvidia.com designates 52.101.46.9 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=iUEvUnUp2Ac4lCLnzlmAaphzQwlV9lNeBTMrEr+4IcWxY+awuvrK1UDD6CbqSFJBDL9DkmGtcOpBdq980thcAvKT5e243mGjkv9L1mol/UAbsnZnQCyil3sWyFRi8q6h5ALlzI5+iund4YY0xqfHn3m2xFd5ST9Z0o0Syj6XU5NFB5ijdNBp2IkIIlvC7Pa1Sy51bzWjFOrW8JNxibnvf/XgIZeEWbaHpnWbRXP/fS5C2UISn9Yc06wXZcO/Y7aJSuCV/5G96ZLX2KMTAfqc9UYVWPQUeCQiXutJ73pMrSWZPSwhl0HgXqD349epqBcFG0G6mPI9OEOOVvkn9lsHNg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aA72n2GJNBMrnu+Sp3peTq+zyhEsFPOIvT+H8n5i3C0=;
 b=qurByE4uvjD3azSCRY4voYpzpU9oglP1vMk5+wN5w3RdZFhvJwpRY4qtNxAinTWKz5ne61A18Y+pd7A97XqRUG5R+xhNz3i2GG4fLRVOz9lv8c/9boTXG+8a0iCQPf+luEGstCKmE3Hu5sbjkw1AccDCpPPfTXL37NObDUc3nCOuS+QmQLVekV62o3TbToxVtXeyJCgVnsw+ZIYCgJonE6LZYBgpkshJZtKDR6fouZwfVGNyjqciR05WNjmy0QrVpQskvlKDB6qlKoK7bBQO8dDrxrhD8uATVq+8kQEVINQLpkex8gN7hT62/zFe8wqi987Ccrk1rCWDZS46z0t3vw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aA72n2GJNBMrnu+Sp3peTq+zyhEsFPOIvT+H8n5i3C0=;
 b=YmsJi9YC74CG3ZKQoRWqSZlCjgruGtHQsnOZuifDT0VCw/qB+DWguJnVljPgDd5B48TlRl3n0yJXVsUl0D9+vwlzosj0lFAFj/qMC7811u/2YmQkjOIK/BILMvnaL52i0liXa6f/pqdW8f5DGEzUh7A7U3HlrO1p0N3JNOXdvDO+iA2qy5YETYQY3SavpNC/h7W96HOXBhZoo9VfYzG3Uh9chpyNi1q49v4ZpgQiPEmdaXaKPHrxrhbC/vMPxpsj6JlMkI1xo16vvGszpIW6Lrhip6gE3OubSp3WQtgcUSW04hzXdvi/8vllBsI0jJCS0k1InntEpyTFq2H6+eaZ0w==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by DS4PR12MB999100.namprd12.prod.outlook.com (2603:10b6:8:2f9::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.522.12; Wed, 14 Oct
 2026 15:19:22 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%6]) with mapi id 15.21.0472.016; Wed, 14 Oct 2026
 15:19:22 +0000
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Wed, 14 Oct 2026 11:19:19 -0400
Message-Id: <DM4NUM0FARW1.HEAD2WRLWGI9@nvidia.com>
Subject: Re: [PATCH] mm/madvise: atomically clear the young bit on THP
 MADV_COLD
Cc: "Vlastimil Babka" <vbabka@kernel.org>, "Jann Horn" <jannh@google.com>,
 "Minchan Kim" <minchan@kernel.org>, "Michal Hocko" <mhocko@suse.com>,
 "Johannes Weiner" <hannes@cmpxchg.org>, <linux-mm@kvack.org>,
 <stable@vger.kernel.org>, "Samarth Narang" <samarth.colleges@gmail.com>
To: "Pedro Falcato" <pfalcato@suse.de>, "Andrew Morton"
 <akpm@linux-foundation.org>, "Liam R. Howlett" <liam@infradead.org>,
 "Lorenzo Stoakes" <ljs@kernel.org>, "David Hildenbrand" <david@kernel.org>
From: "Zi Yan" <ziy@nvidia.com>
X-Mailer: aerc 0.22.0
References: <20261013191719.95502-1-pfalcato@suse.de>
In-Reply-To: <20261013191719.95502-1-pfalcato@suse.de>
X-ClientProxiedBy: CH0PR03CA0068.namprd03.prod.outlook.com
 (2603:10b6:610:cc::13) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|DS4PR12MB999100:EE_
X-MS-Office365-Filtering-Correlation-Id: 44211642-29aa-4951-0c3f-08df2a0685ec
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|1800799024|376014|7416014|366016|261009223027099003|11063799006|56012099006|18002099003|22082099003|10067099003|3023799007;
X-Microsoft-Antispam-Message-Info:
	zzNVHzMDL9uctjcOurr52edyViN3Z6Wtz21s31uPdgMRODGrsn3pyPOM/eYpgfm7xFU0XcnGBm2jgzaUCmld7BQvo0Qz7GBimOVUKuez6vX+Guxn4zRDrdfBff9wzMI6AsrP8B39Odt6WbEdVxJj75by1DHSooLjDzoquZ2p94UfNEcptZ/ThzwyiMxj0uvGB6fOjefY3dzshTKE9YE2IgQrjDwS08DzxaW0JsWnGdN98w4fpLDCAoBhmZkV7wVw7JGWgyVBcQjbWvO79aNJ7OZjH3ldo/3vBGfUbNtt8FMiQDSx1ISWAFqp8tgu3kwOdcjk0T0mrWzLHwfm6vzBpueb4gWd/D3wH1MJLbkrcmxCtXOlriRWuf1lfJLSLbeNvkAf6y3kX+buiIWKHnMoWzc07/RBOFiZDMbkcLmMjd4g3p2BWH5WYmD8sKSIKQiJ2hp7jgq3Ejw+uIEx+G8ni+Efc2tusVFrIIShXkEbbZ9uogJFCjeKuN1Z+KKPw57IMJRnmNpNprlM6pufzt74Y5soM44tnlJGp2BkT0a39Y7wHgdMouRTHr9LU6g7zcgbArhd6+9jK/d5W0OyU2+zuapzinSS98vD2ifZJ6KpxJXyZJnlSn+AHjN+BXaW5SJmWajHHFD3vK67iVZ5gkflp5RFuPOErLNEbsg1NYESWvE=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(1800799024)(376014)(7416014)(366016)(261009223027099003)(11063799006)(56012099006)(18002099003)(22082099003)(10067099003)(3023799007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?R0ttMDN4ZFFnckE5U2FqdFJBc0pFdXROZ3EzeTMrN3hXOXhFdWtBZ1Z0UGpC?=
 =?utf-8?B?eTkzam5NOHhnUWdHdkJka0praVZDc00xbUU4ZFVNSVpFbmxpcmQweGROZWIx?=
 =?utf-8?B?UFpuSVdhUHVQYXFuNUxLRUZlRUtoRDAvTmJsYitmV2JITU51eTJPbFNqdkV3?=
 =?utf-8?B?NjhqQnZYZnVvZkxLaTgvQi9nV3VhOHBDNmUyZ3pVMi9keTlZN1poMVJidm85?=
 =?utf-8?B?bTJvZkdmRWFKT2lXaWp3SytCTCtvZ21lR0hrZVJrR3hTZ0VSdTBabXFmSFB2?=
 =?utf-8?B?ZnV4RVVqeVRmakVjVEtkQnJORFlkZW9Lb0FUVUhmUmE4Kys2SStnYzdwSHFJ?=
 =?utf-8?B?OFkvaDhiNkpqZElQakx0bVZzMGhxUUpKTkdoeWpLQU5xelhwbGtRZlJ6SC8w?=
 =?utf-8?B?U2hRS1pNNExPWFJ4eTFaL3BWZUNTdndZekliQis1Y2lPUE5TSERxNzRzYmpO?=
 =?utf-8?B?M1plSTQ2ZzRLa2xwWC9CdFZvUkFBYUR4ekxHK2pEOFY1bHU2Yi9OSkswSTNV?=
 =?utf-8?B?YnhtalJxUHRMbmNZRXRVNXk4N0UvVUUzOVRqNDRyZTF0L09yTng0Z0hGeVJt?=
 =?utf-8?B?WnBpYlhFc0c3d2pLRXdoRXFTaWgzd0J2ZVB4MU8wT1EyS2hmcTBxOTB1UVJY?=
 =?utf-8?B?NmhUWHlYZFBXMzR4SDQ4K0F2Vk5WaGZxL0VDNlhvcVdLazZFTGtKem4rV0tO?=
 =?utf-8?B?SHBCbTVRdFBGT1FmbmFydmlzb3VDN3ppaDFLNU1SNU0zUG5NYkRnR0RDSWIz?=
 =?utf-8?B?bXRlMFZiYzR0TzlwQm1CRlNvM1QwVkZuaHFMN3pPOFlEdENTNUM1alErZEpL?=
 =?utf-8?B?NGh6YS9URGk0Yjc3Q0ppWmNqUmwxTFJ2MU54MktwSDVnYkI3bHdHWURuMjBl?=
 =?utf-8?B?TVpuNFNZQllwSUhnVThFUVVKNDFiS285bmUxL2ZhTHovRVpFc2xCTFhwYTFq?=
 =?utf-8?B?SXBzRHZCR2ZjTEtvenBFOTlDYWlxY2hOd0xES2RNVTZFQStJSFRUamIyTG1l?=
 =?utf-8?B?bmVlUEtrQ2NaRUNxdzd4RnZoUWZQeVVCc1ZYUm9UTlFBYlNLUS93WFY4bFF3?=
 =?utf-8?B?VjF0SHN4RmhMbkZLbEkwSGsvZWxWcUJlWE5IVCthcy82MXZKcWcxUm9YNTI1?=
 =?utf-8?B?TERXVGRGZWpvWFZ6NlMrNTNReG92UU9jazgwRDZkWWQ3RFptbnZiMGtoWldi?=
 =?utf-8?B?bGpRRnY0MnlOd3pjTUdSbmVEcy9XK3lmamtXRFdTdys0b0MrTDJjRDdGaTVL?=
 =?utf-8?B?YVJ0RTlINXJteWF2WTBCV0NXNTg1THpiMTNvS1lqbWJWVnA0OUp5bnZCSU4y?=
 =?utf-8?B?T1k0bmJ1STZGV0dBNXN3TWdhZ1VyUFlLRGRHUmx6UmZmZkpsbERnRVFjNGVy?=
 =?utf-8?B?N1RiMnVCODZuMzlibTQ5M2JSY2h6dzYrL0hEU0FWY3JZK0hnUE5uOXlsTDlX?=
 =?utf-8?B?TkMwV1phaGRJS3RNN1ljNjl0Z2hrVE14WjBoRWRveUt3Z2Q0M0x3ZjlDcFNr?=
 =?utf-8?B?Nk41K3dsZWh4Yy8yd1drcUwvZ25vTUZDWGY1WUtJUG5Cb1RzdWNlMStnVDZx?=
 =?utf-8?B?R3hXQXdkNkJWcU1kWk9KMGEwMVdkRVp0THpZcXcyamx5OCtkdEN3WGRWTVE1?=
 =?utf-8?B?MmV5WGhQTGlRWm90RktBd3hxSVNTUlNRZjB3dkpsSlFvdG5kUXROWkVBQVdD?=
 =?utf-8?B?cjhlSHp5R25ScVdPaXNkdFBMNmFTRm4yS3FLRVlxSGhPMDl4UUgwV1FHMFVJ?=
 =?utf-8?B?M0hkak4yQ01wUFFhZldpTEFPRVV1YTZyV0I4L2cyOXRKYmozS1U0TElVQTIy?=
 =?utf-8?B?cDJoMmJhRWpOOG9WYW5UcHloSXJqVW1EQmRlVjFyWjNFalV4NXpiY1hQSlZK?=
 =?utf-8?B?L1hnVmR0Mi9HTFJjcGNLbS9rVjZmNkdHUnRuRTlZWlNBRHR5WWM5cjRhVGsy?=
 =?utf-8?B?ME1ucElSSDY4NWUvTVBCZURyVm1MTjcyQ2hyYm1IaWlCSnNmcnlDR2JTdExH?=
 =?utf-8?B?NXdFSnp5ZVlLS09pOVplOUZvY0xva2d3TVBqSTRuREZsT01jK1ZTTm5qU2hk?=
 =?utf-8?B?K3NJclF0TFdVdmRHaHpabjdLK3JOaDEzV2h4UkVMVnE2UzAzTGU2WVhzVmNP?=
 =?utf-8?B?RlRzeWdLekhTaVRrakxoMHJ2TXV2NXg3RTduZEZGMUlyWlJJSkVjZzlSY09m?=
 =?utf-8?B?WVVxd1duU0xONC9WdXM5ZS9lYlVwNjZDMjRqS1NZQmFwQkZsSjY3K0Vrb3JJ?=
 =?utf-8?B?TzlmbXBtV3RCa2N0dUpTY2p3OVVRQnBGR2JqaGFiajBnbkVnTHZLV0tHR3Qx?=
 =?utf-8?Q?W/8lYu9UriK75bc6kk?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 44211642-29aa-4951-0c3f-08df2a0685ec
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Oct 2026 15:19:21.9472
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: J2rBdPbi1zhgwQ/85ICF/dc3WlLEYBRn4nJQdIg3CZbR1/uqruAfiP1+d0AmDcPY
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS4PR12MB999100
X-Rspamd-Queue-Id: D914120002
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: z4x5nhq9nnztq1fcjien4y5omemhx7rf
X-HE-Tag: 1791991168-901347
X-HE-Meta: U2FsdGVkX18/yqK7+w1BzWNeLf7xhXFyZ1n/OCw8jYzU/aiqW5BlAgHditP99PhcP05G9sIGOe/Es+dcxUtNpiH6mIihqJCqgyEWQ9fcdnTy/Eq2lJv6sGIxRA1YotOLk4dBhrq/hJJbr1En6tCwHbbsbWKCNCzFTnQk5ZK84b8YWDRhlSI0eBElFO+xntTU65KIzQfvRdRjcTCmC6gtHZTaAD7tc4IlToLNnN9j/tiXbyZZzqOORjG01SYMbHHpn+wIFN+NbmDWrbpfg9uPtcU75Ro5jSdynSyQyqD90WST2DNZ7BlBbZP6eN0Tg9bDdOSZjDWilZXBnaQsopmN4bm8HZuCkTGrJLS5DeXwMgozTFl/1AMfbU1fQjRN6vjyUEzMpOKKlNFUYxcMAZSmrLMu0WIgPZWJ9NY9HxQxoWxBOMPidmwQWl5Gm2kTAZB6wWebeHTfksvu8hvrxzr2hQekDk/iI+rtUInLzM70K8bJSJDYVBlCjggB8SlgtE3Aazqhvqd236mNvLn1FLJzL81c3AolwWRCPiiCEXQ0yNC64nrQe0MBUh0ckvRdttxELQduEzTNpGZCfUw5NFwG6yS7izryNu5WUJojfH/gDqhLPEER/K/Bl19L/sXDcaWJXrseV+RS5p2xkCTWEnwZwkqUPU75ocOakPeLMtOTjKaCuJczGv7WBU68tPBLnBd2Xh0RfYov8Pee7fSv1YS/ZaEtkTZbtLAZYUPF2Rx+8v2SI/yfz8BIBwtbJcdjWYoqai9y3WuJzbvOJxL00FNkRE+Xl7ZB6EN2cwl/gWU1V5z2u1NSUH6effuqF0jEa2qlHS3lnWq2gKIAaQXSB/wZexLJWTzZxkm8ULWKpcdvhTINLM1rX3PAt6Wl6CWkjVRJW4k1clXqVMd+XeKYBGtwLH3C7LcXKUI9+cUQDZA2miwdml8r9hX/cRGkr1hKRBU6adVLqENA5QWHN2tgH44
 pzROefOr
 5bsqSfGQXOceiCas0Y5QQvP6TaI5fwvJ05W28dS/SmFbS6+688j1Npqcvbc+iMyg0P+cvqFftueWfXuRD/lxoaYsMIuYlq8Vzel3B5J+3vAqfBLJAMGQC0+NwEkm05God9aI36qwhRJRavEVbvwe2YXQMCrN6mfldRg2ztpOIc88qkEQ2jtb2V1S+xUNn17AmN3LAHKcRURx4fPV4JGK4UZamOLeK+5t+99QAs2zapsKZWUbUQVqwBiAVRpT87AKVN/nnzSeyCI3NTFKL3Q1ZdfGPM/kwNDoV5pE7UaJ34sDafz66oBNVELmL2Grr5DBosPklIRhW63VBE9FT9BXp5dtx4msNqX5z5LWrI0vUcGlx0WhwTLiLRJG5klW1eGXdCFjBnf0sabuXEvVBte1RO6ZD99FOGNRMpMh3XIGOFI3PGw6iojdCStSpbdJaodDo83lvDCjhx4xCcAa0IdKJcLoiAFfigOBL+Mu5VRXcYRClmNE1OHckaLPruBfLSXLi+04skK9aaQJ4pC/QbNoX5720IIuXT5vnJYqbS5xtynZMrgjUqQVLvRkbIq6qqx0bHYTf
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue Oct 13, 2026 at 3:17 PM EDT, Pedro Falcato wrote:
> As-is, madvise_cold_or_pageout_pte_range() discards the hardware young
> bit by invalidating the PMD, doing pmd_mkold() and subsequently writing
> to the pmd again. However, it does so in a racy manner, looking at a
> possibly-stale snapshot. It's entirely possible that a write elsewhere
> set the hardware D bit, which this logic now loses.
>
> Fix it by using pmdp_test_and_clear_young(). This is an atomic
> modification of the PMD entry, and thus safe against any possible racing
> writes. As a (nice) side-effect, this elides one non-required TLB flush
> in pmdp_invalidate().
>
> This bug can interact with the swapping system in complicated ways, leadi=
ng
> to data loss. For instance, if a folio is marked lazyfree, but was later
> read from, and then MADV_COLD'd while racing a write to that same THP,
> dropping the dirty bit may lead to data loss as reclaim/MADV_PAGEOUT drop=
s
> the "clean" anon folio:
>
> T0                                T1
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> MADV_FREE(thp)			|
>   folio marked lazyfree		|
> read(thp)			|
>   PMD marked young by hardware	|
> 				| MADV_COLD(thp)
> write(thp)			|   if (pmd_young(pmd)) {
>   PMD marked dirty by hardware	|     set(pmdp, pmd_mkold(pmd));
> MADV_PAGEOUT/reclaim		|
>   dirty bit may or may not be   |
>   set				|
>     reclaim/pageout may drop    |
>     the folio			|
>
> Fixes: 9c276cc65a58 ("mm: introduce MADV_COLD")
> Cc: stable@vger.kernel.org
> Reported-by: Samarth Narang <samarth.colleges@gmail.com>
> Closes: https://lore.kernel.org/linux-mm/20261011132227.413217-1-samarth.=
colleges@gmail.com/
> Signed-off-by: Pedro Falcato <pfalcato@suse.de>
> ---
>  mm/madvise.c | 5 +----
>  1 file changed, 1 insertion(+), 4 deletions(-)
>

LGTM.

Acked-by: Zi Yan <ziy@nvidia.com>



--=20
Best Regards,
Yan, Zi


