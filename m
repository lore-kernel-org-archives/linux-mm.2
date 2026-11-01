Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D42F7606A32F
	for <linux-mm@archiver.kernel.org>; Sun,  1 Nov 2026 19:53:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=hDXfTaey
Received: by kanga.kvack.org (Postfix)
	id 0B2276B00EF; Sun,  1 Nov 2026 14:53:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0628F6B05B1; Sun,  1 Nov 2026 14:53:07 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E6BAA6B05B2; Sun,  1 Nov 2026 14:53:07 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BD1A56B00EF
	for <linux-mm@kvack.org>; Sun,  1 Nov 2026 14:53:07 -0500 (EST)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 429311406BC
	for <linux-mm@kvack.org>; Sun,  1 Nov 2026 19:53:07 +0000 (UTC)
X-FDA: 85387598814.12.4341494
Received: from CH4PR04CU002.outbound.protection.outlook.com (mail-northcentralusazon11013001.outbound.protection.outlook.com [40.107.201.1])
	by imf25.hostedemail.com (Postfix) with ESMTP id 65550A0005
	for <linux-mm@kvack.org>; Sun,  1 Nov 2026 19:53:04 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=hDXfTaey;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf25.hostedemail.com: domain of ziy@nvidia.com designates 40.107.201.1 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793562784;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/vmI7BEt5P1tEKNOMRkvqGm3BcV7uSXIQFXllmtfNaU=;
	b=A1cFmKaIhDNEmsbqeemBmUWfWGdn/mcaIJ2XRJsv7VF11N+IeWKNlZM355NqKRvseAm8Dw
	6oLWPpbvd7e3MRKkYCA4ZHHGYpVfDmVGjXy/5QvaSZyj6UP01gt5uPcqwqOgfWwOSiBXMT
	0wyEcKANX1H6I3hOTC2lkFp9H0ljlQg=
ARC-Authentication-Results: i=2;
	imf25.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=hDXfTaey;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf25.hostedemail.com: domain of ziy@nvidia.com designates 40.107.201.1 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1793562784;
	b=wz2qJYUEjUmGIsiB6Ahp5qXbnKPZs2f5oB7XW/AphggxOrPISorHGMltxnAjG87wdJEoIP
	OPuL7H+ZdC+RKQSsCachiGOKcSwnXLJ2VVxpDhLsSJeMuBlePmNvxOZdqhlHf2gWzzFuo0
	SNxCMoV+T4RLb0dLJekdWt77kYmQLp0=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=hq3YhXD0f+bzYn/nOGVFa3FQZX/KrsJMNNCEIGRlWuVFT14ZRvfzVQ7OaZJImEi9m+nyduNHYHXOOZqdc7scLUzOxfYxRx7r//14uL92WqODq9EeijiCb+1dRpkuIqkWJWJGSi1zT9j3vrTkSDtb1B/jiJsJ7sh5XVwGzYvftJ/E4NkglAR5D/P4sRxudzQyPSYIL/CiDBc8Q1Y25Hc4XTU/kcOuvcqwpP7b1sunrNN1vCpcJ4EKK4iM/zLbEY7VbCThcDT5d1WURN/F7hnezDncoRWbYi+TYhqhiBaraP//dS6uYpjsdhdVA0tNlJekCzuW2oZ3GAYVaEAXm5g0/g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/vmI7BEt5P1tEKNOMRkvqGm3BcV7uSXIQFXllmtfNaU=;
 b=ZhJkQVUI6v4u5g+n7WI/5v8EQJ4rs7SwJ9PrCENC/tLdzFL1EEEa5Cc+jXFC0wMamGaSZAMtAjAR825MHK/dGK+KSYJgfGhLoFpZufNYLGfbR5aDLo5hvzTXdH/70/LShdbiwTgcgPUEtptkVsnuFH/44TUssHuHvay1WEkMUN5+iX5YdRYzd6XtSz3GXNZnaNkaxV54mzcm+7ajzQcdc3/ZQSWe3yaVs8pvIf8bUVmHNrP7zYah0fuyH2xIvQEWdT8FcKI4Rkl2JDhjfHwjEShiOGEQSVPSa2kGR1TPcnAiCjWeTh6r++2WjiMjOi2dD+BD0C9Dd09cHUyu0uweiA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/vmI7BEt5P1tEKNOMRkvqGm3BcV7uSXIQFXllmtfNaU=;
 b=hDXfTaeyuC6hkoMAo7wWeo6nGJBCw5p3WQUFXVUFSXdxUEzvKBB5aPTX1otUS5Q0elXmZoHQoHIhEHopFEnztMGHBCxiWwGSmT/NkY1fRWudN7ISCH3ymJnZ4OVEPcfSoI07+4U2V9SPS74RTsqmk7Llw91/C26dlSwLLW9GGc7gxUQ00i/iZbtynalHhoeg8NnZElZeVJlWCbAS+08xskPJdGlWnqyAedA/Fqx9WXcHzS8fQeNI622sk++6vqfk5M85c0g9IRpZvEWmQInFGtPmwDT2TLEuqqez1ByfDeAd4Mu1Ze4Urn55r9gjJjIIAg+RTIpwHCePebv5EbL9Bg==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by DS0PR12MB6464.namprd12.prod.outlook.com (2603:10b6:8:c4::5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.569.12; Sun, 1 Nov 2026 19:52:55 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%6]) with mapi id 15.21.0569.011; Sun, 1 Nov 2026
 19:52:55 +0000
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Sun, 01 Nov 2026 14:52:52 -0500
Message-Id: <DMK4XUPI9V56.399OWZ5IHCOO6@nvidia.com>
Subject: Re: [PATCH v5 01/12] mm/page_alloc: reset can_retry_reserves when
 the slowpath restarts
Cc: <linux-trace-kernel@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
 <kernel-team@meta.com>, <akpm@linux-foundation.org>, <david@kernel.org>,
 <ljs@kernel.org>, <liam@infradead.org>, <vbabka@kernel.org>,
 <rppt@kernel.org>, <surenb@google.com>, <mhocko@suse.com>,
 <kasong@tencent.com>, <qi.zheng@linux.dev>, <shakeel.butt@linux.dev>,
 <baohua@kernel.org>, <axelrasmussen@google.com>, <yuanchu@google.com>,
 <weixugc@google.com>, <baoquan.he@linux.dev>,
 <baolin.wang@linux.alibaba.com>, <rientjes@google.com>,
 <rostedt@goodmis.org>, <mhiramat@kernel.org>,
 <mathieu.desnoyers@efficios.com>, <muchun.song@linux.dev>,
 <osalvador@suse.de>, <joshua.hahnjy@gmail.com>, <rakie.kim@sk.com>,
 <ying.huang@linux.alibaba.com>, <brendan.jackman@linux.dev>,
 <hannes@cmpxchg.org>, <bigeasy@linutronix.de>, <clrkwllms@kernel.org>,
 <nathan@kernel.org>, <ndesaulniers@google.com>, <morbo@google.com>,
 <justinstitt@google.com>, <Bessel.Wang@huawei.com>, <jiang.liu@huawei.com>,
 <mgorman@techsingularity.net>, <anshuman.khandual@arm.com>,
 <stable@vger.kernel.org>
To: "Gregory Price (Meta)" <gourry@gourry.net>, <linux-mm@kvack.org>
From: "Zi Yan" <ziy@nvidia.com>
X-Mailer: aerc 0.22.0
References: <20261101021340.2251928-1-gourry@gourry.net>
 <20261101021340.2251928-2-gourry@gourry.net>
In-Reply-To: <20261101021340.2251928-2-gourry@gourry.net>
X-ClientProxiedBy: CH0PR08CA0022.namprd08.prod.outlook.com
 (2603:10b6:610:33::27) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|DS0PR12MB6464:EE_
X-MS-Office365-Filtering-Correlation-Id: 793edabf-9974-45c1-4996-08df3851b894
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|1800799024|366016|376014|7416014|261021123027099003|261021121427099003|261022105027099003|261026140227099003|261028144727099003|4143699003|11063799006|10067099003|56012099006|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	RdBZglotUtsKzxZi7KZg3UD/aw86G6z9A/kpPqTXaZ1QTc2YcLfQiKSH+fkj7DlXDapF4jlQQE7wDwGQB6TGlHGdci+mXQ6fVkSrNUac6q+Uj4Mc/PAVxlSm64CP+Sb9U9W64XPLdwCOfFQGSuILXy/vIhP7RVIqqLbL+3Q23Lbrtxvw6l4fKJWzG3B0TZY4A/U1hhxExaIHjwnCFyMJ44sgFeYVulKIIVW38UY8eGjqpKgZTqLchaXnxhF8X2ANFYDqTwDsOqvVbKVe+DA2lWpriJPzWjzCxZkMcuQDZwmHCOlN7IV9oYTOCkF6mcpsUpKrV1KCxXQroMS9fyf7UR66pOuJZXfMA+kAdIcHrZ4KCMHtD2Ar0YxvpcdZ+C/ThAPRqmPCkw1KocA3pZ8WhQ4pO2dzm2uUgQyQXL8TZye8d2vrJDABVfC5oLy2oHqjFS4oW9zTlL4sAAEzIzmyOolRUpZAfGcXvxCUAOM6xAdo7nzo6xuH+NnOXzbkke6HJOkjMO/m4wZS2/0zRlZ+zW3kfG2ZMWRc9Rn2Gp76BSkQ6xTLUwCnP7B09sasaJs4Yanv0cxsaR5Z3PUenFCMvAT7g5JXP4U0c9uZ+HoHTHAhbgwLSuYCvxnqE/2cZdNAgfozaCSU7KYNQztSk7+CwQUkT6Fy2LOhZzfMUkgC+ys=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(1800799024)(366016)(376014)(7416014)(261021123027099003)(261021121427099003)(261022105027099003)(261026140227099003)(261028144727099003)(4143699003)(11063799006)(10067099003)(56012099006)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?R0Y4d3JFMnoxeDlZWXkySlFQYzdOMnZWMjFReVpWT0luYkZ5d2VyMUdrdXhF?=
 =?utf-8?B?Y25oMWRPQlpjWGoyWlY5QXdnalZZbForcEl1YXIvVVpxcmpMTU1TbW5SMmFG?=
 =?utf-8?B?ejdhT040Z3NGaXhDL09RSjRaa0o4SXk1NTBROE0vY2xMV1FHUnBLNDFWSFpl?=
 =?utf-8?B?TjRDNnRMdzdxMVBPaHpGT3JrSmNXSFdTOU5WMlZRQ216WlNHZHpobWFJWWxv?=
 =?utf-8?B?T2Vva3dmaktTSi9zcysvbktqRENCSW5OTlZOM1VIdFUrUjB1NG5UeWV2TVFQ?=
 =?utf-8?B?TFgyR3FFSEpIUFpZbG12YkxPOXhhbVNPenY5SDV0NmlBdTF0d1B6SGx6Tm9j?=
 =?utf-8?B?WndGOEhtMEEwb0RvS0srY1pEcEVsOElwcUpNUldEM3JWQ01vRmxtUnBibTFj?=
 =?utf-8?B?b2RxK2hRNjNBU3lKZytmQ05YZ1BXOHc3dlJ5c3g0NnRPL2s5aTVqUWt5aTYz?=
 =?utf-8?B?VlJLT2hBZUIwWEtxNVR5NmQwTzNRbStDNDZWSU1OOTVhSGwyRTZHVUtMTHp1?=
 =?utf-8?B?MG94Vk41ZTg5cEd0V1Q1SEpRckUrM0t3Nys1U25DdHlYdGhnekpvQmNHSHg0?=
 =?utf-8?B?WU9zLzF0ckNOUmNQQjhzSGUzUDhmUkFSV1hPT1ZxMU91dGVzQkU0S08zdmJp?=
 =?utf-8?B?SmF3SDk1ZTZCOHFHU05ZQVlBNVd6QmNEOUhvT2s4SFQ2aXg2c1p6WXQ3NDdW?=
 =?utf-8?B?Y05jcExkWXU1OUt0U2o3N0RLVzBZNHh5cHNxbVgralIyd1VaTGtIZ2VsUDB0?=
 =?utf-8?B?MlBTcmVVUnVQRm0zN1g0T1ZaY0dwTW5pUXY3dUo5NlJTYmJsZStNQ0xxNlNO?=
 =?utf-8?B?NlhBTTZjRjVLRjBoUXpjRjVRT21nMDVmNWVkWFBwWWVRZE1TM0R6bVZzUHpS?=
 =?utf-8?B?VTFYam5OWEI5SmUveUoyRC90RWhENDNCUldwMmtrTm1pS2VMcVlMYlhmRzln?=
 =?utf-8?B?WTNxTmI3c2tqUkkvU3QzSnFlbjhydVdGd1lvZDNGL3UzR3k5b2VWNDNuNXUr?=
 =?utf-8?B?VlZjQzMzZ2VSTUt2c3YyNTdGZ1U1UU5nNGtubCs2VzYzZVlwQ1ZxajJwMzF4?=
 =?utf-8?B?M1BKRWtmSTBXaHZEWmR0eGxqMVpmbHBTQzBHNmVGbUJ4YzZ4b21BWlhVc3Bw?=
 =?utf-8?B?ZC9wYkdVN3hiN01XdmtlZDVIZExGaHlUY1hIaU9WcndnWjRGck1BcmVUL3ZQ?=
 =?utf-8?B?QlhLSkt2ZDJSbU5iYkJ5YVdLV2I4RGR4a21lQlM2QXJRR1F6anZCdi85N3dj?=
 =?utf-8?B?dzg2ME5GR28wZXA5SWFid0c3QVRrUkZpdjk4eXh6NUZjTkFaczFzRWQxVHEr?=
 =?utf-8?B?bFpZeW1xeVFTeHdOcFRlZzRGeVdNYzJJY05RblpvWXRHaDdhWlFQUlZ2M1Ju?=
 =?utf-8?B?Qkk1UGdnMUliVStEcENqcWVNelZ5b3U2WnRVbHRKSnpJdEYvME9MT1dKRTJB?=
 =?utf-8?B?eHZqSkt5WkJLbjFiUkRGRHVVbG1WZVp3TEIrZ1JMTWNNaFd1ZVBoaVE1citF?=
 =?utf-8?B?T0xJNzVIWEN5MCtvSUFuNWhUajlKS2s0T1JGRmg2YzFFUS93TGhnbGVpNVZ0?=
 =?utf-8?B?SFVjaG1hL01hNldpTGlHV1NXTTB5MU5KcUpmODZEd0tveExHSDVodG4rNmlw?=
 =?utf-8?B?bXlNd2Q2RzZGVGhyOHAxQ0hSaExoMlNMSkVSMTJ6dE1hMTk4bjdRY3YrNEUv?=
 =?utf-8?B?MjRGaytSbjBadjgvRHZILzZjT3VwU3poaWQ5VFdtR2kxRXcrTFRZSWtvRlhJ?=
 =?utf-8?B?RUxaVVVSemhrMGIyc1pCQ2J2LzhtbGthVlFpY2RNaXQ1VnN2TldBT2tEOGVw?=
 =?utf-8?B?eUZDUnp2K0dhaTVOZGNwOGhRRE84c1FnanpTNjA3VWZoY2wrd3o4ZUdFM2sx?=
 =?utf-8?B?SG44N25JaW8zdkxiMm4rKzdLbExYOGgrOE9PelpSZ0g2RkljRFBHTjlsS3Ev?=
 =?utf-8?B?RW5FZEdNYm8rTU0rWkYrN0pYdWErVUN4cndDcWd6blMyeTdsNXVBeXkvMXBU?=
 =?utf-8?B?L1AydVJ5aDM1dStsSWNSTmZhK2Nwa1h2ZUtybzFIQVlueVUzU2VucU1YQ2Ra?=
 =?utf-8?B?dnRGODVLR3BaSm9iazYzREdQQXNGRm03WWhoSUl4OVRSRGdncGtZR25CWnZ1?=
 =?utf-8?B?L2NzK0ExbzNieHJXRkdMTGFuQnBOdjRjQnZLa0RUd1VVWjhHN0hMNE03azhi?=
 =?utf-8?B?aVBKWGNTbVNFbXRQZnBqbzZIOUxwSkZBdDllcEV1aU1ac3V2alpob3dKbWNa?=
 =?utf-8?B?WWVKQmR1M2NhaWp3REluQVUzSjg5Q081dnZ0MUdvODRvR2lPQzZQYVhyTUtk?=
 =?utf-8?Q?5sbuUqf72wMSr9ZLaP?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 793edabf-9974-45c1-4996-08df3851b894
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Nov 2026 19:52:55.1001
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XA9VNAIuvQqe0jhjCyq2gB+Y4LpyevNBJZrvsQHILNCkqqzsPeCgwOAVGBMxFHJO
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB6464
X-Rspamd-Queue-Id: 65550A0005
X-Stat-Signature: 6e45i3e6y5ych1ibmd1zesmmcdgy8dfy
X-Rspamd-Server: rspam06
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793562784-235459
X-HE-Meta: U2FsdGVkX1+W67Muxt7qFTlGkQJ2VYpKXOWNOGKjwxu4h9zBnpWKLKCSTVWrR9FV9r1AG3VxubS022MPrCJT2iymZdiyKhjaIiefQnkFjDunK9genX3zRq1FwNOMr0JoFJyke0nLzsSci0IczzvwUxMsCw0fUOlLrG6vOWkIP1CjuMp+6v/F/PcdXroF991yNYsojJzL71tq9XRl3psY4FBnPuQuL1O6/BFbDdGrBru1o50HWDoc8izvOAWJm3HM77Vj5HJi/snQqK7DQpjsBsMya/UXWLO3SF1mCk0sKnTF79ILsJBA66slrVCwVEiR/7Fd8clsETuLSYpMkeY3Pe+qz7pPo5S9v3tlbJtkLVk2BW/AHWxks4euwcbusFkCQq65Vw+MKZOztliJIcLkjFoNoFNfIPNhgNpWfSHeNLFzSDjjwWu+EK3MPDxw2Q0zjA0bvqK5hKLuZjLbpYMRvtQ2mXOVWxRa65Td3Ft6A4gmJ70iepjwt4tI5KzPP9ZQ6l2mCLVS0Q6bDSX4+61uYEovlmLdX/bFazMoKRbhzWcGu6k+wsFTVqqbT2gDoaOanZEEb29Dc0MsrhoLSfbzI8pNT+M4QYvU+8lGiMdEWdQV/lhsCqLpBpe9pEoR/L3iOBqKrUWcUNwk+o1louDtzaoHRJ2AoICirf8WCtE1B/DZS7QUKX/rkl0v4yQmIYqbWS/t/8nJnk3R4C2wofwMC8NJ1oFikrkzBBHj+iS9+IC4krNFAzdJw35uCx3jW2RzQYmLNVr8ZJ5h9J5NKgob1t7lbqN0w6K1JF0BqFkZsjVOm3NjWCgvlUzAhJYyHGRxGqkLJJDUjQI/NDBHQjqCd59j9Zlch+kh28R+Q7/6Bez2aarH7ptUEf4fFMCzXcSumR7yxsq1a4tWHoGLGOv8mIAMnL3g/yXr+gWm6oH89y97XP5+rD+DAN/yEfCcv+1Hl4uRBd1NdiuI5n551pS
 +LmQp3Ca
 uIYj7q5+NLm3EHKtj9rbNhFLNPohhGArY5CL2cqcMsCTJhOIQ60AA4rlrxF46q8SRB8GlkJEuoK8EuWqfS4OM/U+4LC0eTcNIiY0NJAFh5b9V/o8tQW+o6W/wzC1lQdGnJdfX0GcLKwF4CfkCjMlJJoCLFql3FvBRmmMMzTyqSIwozGip1G58xbaVdd592jJEMempxiG13ElxJXL5XTQbwEgbskIEVAKH9k8xSi/8IwY2eeFZKLuh8shoRgfhuFc6KA+CNodMPEqHe+vVYbtSNpcFIv2/uZNkC2PDqDEFj8GqazCg0e+VaZCEOOt3hyqpoKypa/by6RGZgDUKxKf1VR1Ey1Bb9RM57DnlqYCSLXVNuRy4up4sRUNE7V5FO+KtUg7LY9CAKgN0ZurH7gaY0ffTh0aL6Vr+gl/jUMQ4ign0iRyiQFZs6YdNS0tVUJMpfS2yV+bjMOhgDFJud4oa441bNi1mJ0JMAXbmJabXQOo8wK+1AmtXJ/MzSiji8M8dYXJMYsSoJsQwx+qGiSCPXOdJLL7bdyXziJxhMoQFhX+kZS8AwF+Np75OZPwyoCMIskTGUGkCvvtMq2vkaUd1XK0pcf97M4tNNfKm
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Sat Oct 31, 2026 at 10:13 PM EDT, Gregory Price (Meta) wrote:
> Commit 2c4c3e29897d ("mm/page_alloc: simplify __alloc_pages_slowpath()
> flow") retries an allocation once with reserve_flags when the caller
> becomes eligible for reserves, guarded by can_retry_reserves.
>
> A restart after a cpuset update or a zonelist rebuild retries with
> can_retry_reserves already set to false, so a caller that cannot
> reclaim (GFP_NOWAIT | __GFP_MEMALLOC), fails without trying reserves.
>
> Reset can_retry_reserves on restart. Only a cpuset or zonelist change
> restarts the slowpath, so the retry still runs at most once per change.
>
> With a kprobe helping to make the race deterministic, an allocation
> can be made to return NULL. With this patch the allocation will succeed.
>
> Fixes: 2c4c3e29897d ("mm/page_alloc: simplify __alloc_pages_slowpath() fl=
ow")
> Cc: stable@vger.kernel.org
> Signed-off-by: Gregory Price (Meta) <gourry@gourry.net>
> ---
>  mm/page_alloc.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>

LGTM.

Acked-by: Zi Yan <ziy@nvidia.com>

--=20
Best Regards,
Yan, Zi


