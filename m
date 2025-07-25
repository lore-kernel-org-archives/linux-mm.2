Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AC8DDC87FCC
	for <linux-mm@archiver.kernel.org>; Fri, 25 Jul 2025 01:47:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3624C6B008A; Thu, 24 Jul 2025 21:47:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 33A1B6B008C; Thu, 24 Jul 2025 21:47:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1DB786B0092; Thu, 24 Jul 2025 21:47:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0DA6B6B008A
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 21:47:36 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id AF9DD1A04AE
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 01:47:35 +0000 (UTC)
X-FDA: 83701100070.11.FCF297A
Received: from TYPPR03CU001.outbound.protection.outlook.com (mail-japaneastazon11012037.outbound.protection.outlook.com [52.101.126.37])
	by imf22.hostedemail.com (Postfix) with ESMTP id 57930C0003
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 01:47:32 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=vivo.com header.s=selector2 header.b=VKb7P3AB;
	spf=pass (imf22.hostedemail.com: domain of link@vivo.com designates 52.101.126.37 as permitted sender) smtp.mailfrom=link@vivo.com;
	dmarc=pass (policy=quarantine) header.from=vivo.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753408053;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=B0sL0VMR0mAjpWkBvE4931vVS2N6tcjhf18Fs9i2z68=;
	b=PHlg+BAXDoFrzqkWJBIO7qJHBbWioXTCgHSKMZVVZfLUBMGXffFmniNodlMvV3TvCHnrOJ
	7r23ph3UsZtV4Dt8RH87PTluS1VC5rTLisP7MCQGJO+Qz7Nrc6U6NPnFbgu7OF3qTixbpA
	gpaWANFxGIBvFgWxW3gcZks1ADHMjxE=
ARC-Authentication-Results: i=2;
	imf22.hostedemail.com;
	dkim=pass header.d=vivo.com header.s=selector2 header.b=VKb7P3AB;
	spf=pass (imf22.hostedemail.com: domain of link@vivo.com designates 52.101.126.37 as permitted sender) smtp.mailfrom=link@vivo.com;
	dmarc=pass (policy=quarantine) header.from=vivo.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1753408053; a=rsa-sha256;
	cv=pass;
	b=4VsN5crS90jlWyNKmjquLlBo3qpDOB6e5uZU9yNVgVZkpVXuVQaHgg4cP//t+noCwE7bV1
	GXStMsh39MWXO5WfrJBuskBvWHbWcbk7WStVdOYGRNlf+WiQDM/RYd+0rYE82zt7iLConr
	hLFspG/dO8N0Ry90RM50D96LcszgG3M=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=hG7mxrHFKPSkrM/M5H4YfGkd+mFpspQOA69NvolKV5LHWk+jablQQBrKdTWODf/eRrBKMHhjhZRv9Zw7BO/It1IOE406RGtQkzsOcy0cUkhnfgry0gm3WepxffypDlVo0T2W9xRtZnTwteeh6eaWnimDZ8tBd7YrNd9zq4NF4eyCn7ZXLMbXec18UnNKqV2kxilYZNDXT74sLn/ZOTmoiB0vDT1LkkLpeQQZjQiRbfr0Gze7Ye6UoHpBs50AF3rMFepTdCVsqXmiRdHEBjiZT8iYdYdM7XL0IPJaEWtSNxMqzWJeWUNjGYcLeLYWKXydElLuN2hzWPWow+Hu4Qpt3w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=B0sL0VMR0mAjpWkBvE4931vVS2N6tcjhf18Fs9i2z68=;
 b=QjdtGRBk74XGwXmoKKBpqppZ+tvlyO/Fg0FdLMGJ4pu9Q5sxcSMGz39p/X/1ThIzfvzAB0CzSlSDj/Lscwh5o6QczlwSkxNz/6SgZCm44jQkt6434Df7H5BwJZvI4avDyELLoe05ty3dvG2y57cjhRoUx921sAmRW0iQeF+CDJJvS5c4UvRDIym5mdm2+4JVJ1mO0x048r6Z2RJL0MqCwO6Jx/yvA1GfN3CgrSm4sjV2oU3ecGz/V4rJLVJQzFSQ1z2aCn422+mgaUlGeXmNmgLtXdXrOzasqLQ502Vi+2fOq0RcBaGuE5trlT5IswKxp5EKGVg/XMJZcsMUNdH5Ig==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vivo.com; dmarc=pass action=none header.from=vivo.com;
 dkim=pass header.d=vivo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vivo.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=B0sL0VMR0mAjpWkBvE4931vVS2N6tcjhf18Fs9i2z68=;
 b=VKb7P3ABXIOtIArjakiu0c8wSjuf3D6UAO4g5vsZL8FHqQEGnRtIhAqIY3vJxXJgnq9Sz4fBeQaRgjB9r8zAX7LqJ6dy4Y9pebrVChpsJ/W7xJtppZzPAFLAVUSVm3CuwirOq8UE0Kc6lKzgVoonbZWAY0rEe2VIWVNhDTku1LdsjN6b7uNNmwAWh5hAPmO59mUpc13lmPJcFknbrEOXB5t1uHOn/etp/8kWsHMbpP7+j6cTEld/eeMvj10aQAk51TO1rQUITrFMQ4ea/J9AI65MTYuP4zfsYqaQu8pixkve8RfT2AA879GvrWx1EctlpErM2wdHT6Wy9VYQidlkCw==
Received: from PUZPR06MB5676.apcprd06.prod.outlook.com (2603:1096:301:f8::10)
 by PUZPR06MB5537.apcprd06.prod.outlook.com (2603:1096:301:ed::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8964.22; Fri, 25 Jul
 2025 01:47:24 +0000
Received: from PUZPR06MB5676.apcprd06.prod.outlook.com
 ([fe80::a00b:f422:ac44:636f]) by PUZPR06MB5676.apcprd06.prod.outlook.com
 ([fe80::a00b:f422:ac44:636f%4]) with mapi id 15.20.8943.029; Fri, 25 Jul 2025
 01:47:23 +0000
Message-ID: <9a0eade4-8981-4379-8260-e673a1803d56@vivo.com>
Date: Fri, 25 Jul 2025 09:47:16 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 0/9] introduce PGTY_mgt_entry page_type
To: "Huang, Ying" <ying.huang@linux.alibaba.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@redhat.com>, Rik van Riel <riel@surriel.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka
 <vbabka@suse.cz>, Harry Yoo <harry.yoo@oracle.com>,
 Xu Xin <xu.xin16@zte.com.cn>, Chengming Zhou <chengming.zhou@linux.dev>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Zi Yan <ziy@nvidia.com>,
 Matthew Brost <matthew.brost@intel.com>,
 Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
 Byungchul Park <byungchul@sk.com>, Gregory Price <gourry@gourry.net>,
 Alistair Popple <apopple@nvidia.com>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 Christian Brauner <brauner@kernel.org>, Usama Arif <usamaarif642@gmail.com>,
 Yu Zhao <yuzhao@google.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20250724084441.380404-1-link@vivo.com>
 <764c48ad-8869-4f69-898e-0a1c58684f7d@lucifer.local>
 <40cb7d64-0b90-4561-8e10-06a808a2766a@vivo.com>
 <87bjp93vb6.fsf@DESKTOP-5N7EMDA>
From: Huan Yang <link@vivo.com>
In-Reply-To: <87bjp93vb6.fsf@DESKTOP-5N7EMDA>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: TY4P286CA0091.JPNP286.PROD.OUTLOOK.COM
 (2603:1096:405:369::10) To PUZPR06MB5676.apcprd06.prod.outlook.com
 (2603:1096:301:f8::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PUZPR06MB5676:EE_|PUZPR06MB5537:EE_
X-MS-Office365-Filtering-Correlation-Id: 6ff11499-329d-4dec-1edb-08ddcb1d3386
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|52116014|366016|1800799024|38350700014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?bEp1NzZXQ1hmdldyMGovM25oOU1Oemg4NlpsUVJYa3BjTS9nTTdZUG9iSk9r?=
 =?utf-8?B?MVFtdHNIajRyeDkvVzR5aDF0UFh1R3NqYldzckdVOHJSNEwvbElKUG1FRWZC?=
 =?utf-8?B?dHQ4eUNSOVhseWFqOU4zVUhCWlNNSm1VaU0wTjBqQ3Z6K3ZpOVQ0eG1tTTY1?=
 =?utf-8?B?cFY2ZWttQzFMZkF4ZklHS2ZLN0k0Unltd3ZHK0YxcVhGQVpOWTVFb01oL2J6?=
 =?utf-8?B?REozeFp1QWlzM3pYbWNIdkR0WmE1N1JWVUQwd29CeUE2SDhEZ09KUGxGcEVO?=
 =?utf-8?B?VDI5K0xlaTU2Sk9saVRHMU5SY3FDdDZBbkd4aURVbHIwNFA2OUFSTk56Ujc3?=
 =?utf-8?B?dElldk9WMEVZczl5V0RjNzhnSitpNlpRaEFUSFlVR2R2MU5FTy84MDM0aHo0?=
 =?utf-8?B?RmEyeHZ4WjBuMDJpNk1Oc2gxL2p5YzNQV1Z0dTFORmpPYWhHM1lZSUpNTDB1?=
 =?utf-8?B?ajUzanhMYVdUUE1GVEk1aE11UWdYaFdobUNYWnBETjRIUUZPQmpBbVVKRWM4?=
 =?utf-8?B?SkVFcTlYZndUK3BRVzlHcE5PSGNYOEtIMkxpS2FubmNNTmkwcS9zOUhacGZp?=
 =?utf-8?B?eDNTczN0Q2JZMWoxMkVvV0NXZVJUUU1DdFRXVllJTFk4TjVvemwyTk9yYmhF?=
 =?utf-8?B?V1Bxd1R5MW05WTkycVFCOWxFdlRzTXBuOGxZZjl5QW9BSW1sUlpoZklDUktF?=
 =?utf-8?B?aVdCb0IyZnZiSHM1enRqd3B3WnF3Qm1yUlBmandTbEFpTnBZRTRSa216SHQ0?=
 =?utf-8?B?TTVNdmFTeGZCVVhkbHc0WWlYQUJMd3dCeW9jYXdiMzFpRzZlOVhYR0NVNm9S?=
 =?utf-8?B?eTZqS1A5MUVKU2d4L284QkhuQ3J3Y2dDTkVhaUhueUJIK3RJUkhlaEg2ckJu?=
 =?utf-8?B?NGtNSnAvblY5OVlhaG5xQ29tSFN0RTV0cXlUQ3N2c3REK2FxMGVuT0NWK1FP?=
 =?utf-8?B?TDZoRDlhN0w1dkFLb2dyZDNhLzRUMUI1dG5qU1d4RXhxVGJtM01mM1FTbDAv?=
 =?utf-8?B?c0VZT29YcytPTitBUURZcndXa1Y5dmIwbnRoRnM1Ty9meVJJSG1EaFdobDRL?=
 =?utf-8?B?MHpzWXVCL3k2ZTlMamk0OFVsalBlaS83NGRKUHlwMGZ4T2tkZGNveW1rdmQ0?=
 =?utf-8?B?eFNTQXNXSnVOY3liaDNUbU5yUjFUcUlMcFJKYXFydi9KZFgzMy83aENnWmdV?=
 =?utf-8?B?ZjhwZ0x2cXMvZS9yOG0vZ281OEdDMDVRc0lpK3h3bjhITG90SEhSZWlibW9Z?=
 =?utf-8?B?MzQ5RktMZWhhZXJUVmVKWWcwYXA3bEV3aFhpVi9UZHFIZzZ2NXB6QXJtcTBS?=
 =?utf-8?B?OStpZTZJdEtsSjhBUlkrVjlBRlhQdnZ5YmUySVY5cVBCbVZUNDFHamROS0px?=
 =?utf-8?B?YVNzTFlhWkZ1REVOZmRVR3R4UGNHbjFuODdWci9xK3NFaWxXUC9zaDlKanl0?=
 =?utf-8?B?aVpVdm5uSHJjZ1M5cGlwTEFUd1hkTmpYZElXVG9BaXpJRFlHaU5KYjRFSXIw?=
 =?utf-8?B?cHd3SWszL1RhM05nR09VbUh4ZGN3aDBNTFlNWE9mWDNGUXBtd1Q2Mk5TaFVm?=
 =?utf-8?B?ZmtRb0VuajNLZGdTdzJ5bEUrZFp4T3VnVktZMnJPZGtBNVREYVhDRDIxVkoy?=
 =?utf-8?B?dmh1N2JmQzFJSlZPZ0xFTWJvUXY4Ni9WWitqTG1xcDdGbGhmb2NtbWQ0WHBU?=
 =?utf-8?B?YloxRmRzdk5oK3RDdW9OcG9QWUFVcmVrQmJOOGJpQjVoYmJQU2lKN01SNldt?=
 =?utf-8?B?RWtDdnMyUDBTbzA5UU1vQlJuNnFxNmdUQ3NWUWtpRG0xUWM4c3hIUXR2ekZa?=
 =?utf-8?B?ek9KUmJWRTRFNk5kd0JYWXVCT1dSL3dRNWVMaTFyRWk1VnppbU0rY0RLbS8w?=
 =?utf-8?B?UzdiWmdSdWFBVURqWmtuQzZaSVNZbEhzL2sxR0RSa0NrNm9lemJsMG5OL0xJ?=
 =?utf-8?B?K1dETWh2ZHp2MkhUYWFGdzJyb0hSUTFPTzVVVUt3TXRxYTN1YlA5eTRrYXJI?=
 =?utf-8?B?OUFiRG9vQ3RRPT0=?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PUZPR06MB5676.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(52116014)(366016)(1800799024)(38350700014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?SHN4S0RzMXQySjRSYVg3emhYc2hvbFdMaCs1MzB4MVF3MlNDRlBJc3hpTVZi?=
 =?utf-8?B?TzlNbUEzOHJCck9maEYrN3IrWkNhalkwSVpuMUNOcDNQdGU2OUdFSVFkTHlm?=
 =?utf-8?B?UnF1ZHJ6aStRN0EwL29yZXV6NjVMNVNQSm1vNWlLa0xMb2E3REdFRTY5OXBz?=
 =?utf-8?B?QjdnVDBZWlJsclpUY2xGRW4ySFhzQnBwQ2NOL2x2ajMxazMwekNuclIxZ3RT?=
 =?utf-8?B?bkRITzAvbEdlaDR3NUxqRC95TzZJNWJOUE5KZjRLR2NoZFVNeVVOK2UvbVVy?=
 =?utf-8?B?TldIbS95bTdzeUcvanBVdnRKRXB5cnlaN2FyQkRvdkRjK0U4d3o0Nnl6TXRo?=
 =?utf-8?B?bFg1bXh5UElvVGNYTFd5MCthLzlETEtSOUE0Q1NSbU54b2dpRmpFcDZjUlNT?=
 =?utf-8?B?RDlLdmZlVmd1bEFDRitHbXc1ckJZWEh4TGtYODVpNWlXZDR0d1RPYW5lQ3VR?=
 =?utf-8?B?UDBlNDdjU0NkbzRoYUFDUEEzRVJScWc5MlE1SzNXS29GTjlzSkRwNFNjWjR0?=
 =?utf-8?B?d3hCV1JMc1JJdHM3YzYxa3ArZjVXRERDMkIyU0x0Z2RqSmtybXZsWVYraVRq?=
 =?utf-8?B?NmhzeEFQY1hqQVAyYnY1RVBzaGYzbGIxaTArNnZqUytBbXNmK1Izd1U4OFNG?=
 =?utf-8?B?dVlsSjVDbld3RjBqdGFMSW5JVExSUC9EVklvZXZDbUI1dTJ0eHk2NHVPYjBr?=
 =?utf-8?B?V0tpM0QyZ1pPL0ZEWm40eldaZ1hNV1FyTzkzSmUzd0lUeTdUelBIbVp3K0lv?=
 =?utf-8?B?cHVGeFhJbkQzS0lpTUZlK1dFUi9wYUFreXM5SWdXRlN5U3lVZDExTExQNFRT?=
 =?utf-8?B?ejJwZW9QQ2d1UFlVZWgwSmZtWkU0N05jcG1GWW8xb1p0YVR0TnhwSXM4QnFP?=
 =?utf-8?B?bE0waGhqQzJaOU96eTB3VmErNDZ2ZGJDWlNxbzVkT09KNXEvUkNXaFY2MUpN?=
 =?utf-8?B?bjNGL21iclhKNFdDejBzeEpncUJkTVdyUGNrYWdPMVNLRmduR3Zwai9CUEQr?=
 =?utf-8?B?OE5CVWN0ZzRiQWdkTkgrT0x1ZGZ2SVlQWmk3V2RxZmloaVZkNk9JUXdXVkpR?=
 =?utf-8?B?MTFXdzBTdXAwL1Q0c0lnT3VMVDBBQnBwclhGcEt3ZXYrbjFrRTJGRDJjSFhI?=
 =?utf-8?B?UWExcnRBb1hzaWhzbzc3eWNuZCtuUUtpaTNmcm0vMzVwOVhwNk5SZzR0UVd1?=
 =?utf-8?B?eHArdURxcmhjdzNWZHY2d1cwNXh2ckFnWFQ3MXI1RXZQSkd1aVhQcmdKYUJB?=
 =?utf-8?B?OUZrVGdTWWlSNXluQlNlSDExbkVCb0lEOTVrak9oek5Cd0w0eVpnVlRPQ3lp?=
 =?utf-8?B?WHIvMjNtZXVQU3VUNEFaR1pESzI4TnM5bVNDRWpOS3JmRngvOWovVkYyaHNW?=
 =?utf-8?B?R0wvbXczdjNYMld4ZEh2NU9zZnExVWJGL3BISHgxOUQ5c2xjVlN5bUNuRzda?=
 =?utf-8?B?a2FPR01DaklJbzVEU1haNTdTV3Mya0ZWSFQyZEhZQkhyR2lYMjJBTmNINldV?=
 =?utf-8?B?M0pqZW1CQjVGQk1GbTdaU1BxNlFobVM0S0NCakNFRmtMd0FWMEN3ZHp0TFVn?=
 =?utf-8?B?TVJoWUVUaVlyeFp4d1F2T2ZQWS95QjEvNlZOekZnL1pxak1TSXJpMzhWVUF3?=
 =?utf-8?B?MUdpei9ydTZ5VkJhbGlkYmxtSmM3R1VoL1lsUXV3WFM3b1hVVi82TXBFeFgx?=
 =?utf-8?B?T3p6MVBHT2dCTEdrckpoZkFGK1NUcU80L2h4K1JIakcrV3IwVklWL0trVElh?=
 =?utf-8?B?WDZ5ZHNxV3F6M1k2LzRLcnVBREFwNVgxdmJGNUZPa1Fxc3M4ZjFXQlY4VDhi?=
 =?utf-8?B?SWZkU1JEVDlSaFREVHFFbVNVdjNKU1BxOVpLdWtCNzN2WVhsUCtKekZuSWxH?=
 =?utf-8?B?M3RZeUs0anN1R0c0SjR3RVZaWC9LNW4xUzBOM3FaZnpadjlrNzNUdjd3SFdi?=
 =?utf-8?B?NkFDWjJya1RCRXJBN01uTFJUN2ZlMEZIL1VXdUd0NEJicUpMLzcxem9iUEdM?=
 =?utf-8?B?YlhhTm5iV29vL0lHYmpZWG0rWXhNMDRwWUNCTXhLOE95cU9WQjFUTU40RDBa?=
 =?utf-8?B?b0FtZmo4MmRqdm1OdTFGOWcxR2Z3OVF6akhHczNuaWtRNDJCNUxzN2RGbWg4?=
 =?utf-8?Q?Dtng61sjTsk8LEI0sr3/rYsLN?=
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6ff11499-329d-4dec-1edb-08ddcb1d3386
X-MS-Exchange-CrossTenant-AuthSource: PUZPR06MB5676.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Jul 2025 01:47:23.8218
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: M8zMY93cLMdcz5mKYRh2kVKjM5k8WwmxzwwRsZndj6etZ628pVAQMjhrWRlmCNLRfZebj1wDVs/nH2KU6jp5rA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PUZPR06MB5537
X-Rspam-User: 
X-Rspamd-Queue-Id: 57930C0003
X-Rspamd-Server: rspam06
X-Stat-Signature: aj8j48xgs6d3c1xas5cxwmj5ur3qthxx
X-HE-Tag: 1753408052-891105
X-HE-Meta: U2FsdGVkX1+M9ysp4Naz7Zbz9pNX/rVDx2yGGyuEUj48evQPlUGlt7yHKgQ6Sk+IqbqOnlQWep138vYXjY4UN0ypximYdAeo5baZEXq8Jhw0PxVXtiIAblopIuusFZYyg70JYX2p22jBKvIjjNGcFfVH5drTRQqObaqk4XLDlcpnN3dz0PTDO9cbqDFErdoaGzXCxE95tNbBUTMcFisKxuFTrdKY/Lh4WLEXMyl3o24XRgPnaFrp9cLJGxxJzBqgbpNfVgBTVFZDG8JarF+YfM1U3MOU3r+MA+bzMUIZ1xRAXIfDUJJQZ4PEgDrPcc8ms6OCBhu2no19U3Z+LeJp63AYiAgu1IWKX1trZSjggprxNid5vl3Sfj2SzC368mzGf9dl4PbXb9YFVnWCWeHv3LiufFI6B1IOVcWqQs841M7EvPa5r6jogzNchRswkSJeLEM7djB48AUfk42pq1xjpmi+VHfGtun4TYOvToeGSBSe75rWJywyqvkrtBCEhBEaMxCX9yRbzijLPZO5I9YVTWot8iGKzzcxA7CWcOPtaGGJW6SsLQHzx/tY2jf1GoEu1tgBnDp69woaspm73H6nv3/A/YynVHyXarNC116A4FAJUGwoIOkq9bkqKZ//r0022yzObVUUomg08JRe3wk0b5O3DJZaWkC5EhR3VgRAqKP0RTNMSFlTUQe99wnulE9VJhCzu4zdOI7AhNppSO3CQCEi2WzZFFgmfO/NLvsm6fRXKbymH6p3y4k48z58xAU3a+BqFPHH9REruYQbLWD/yLBUGOBwEK7Gc1zn3zafr+mEjW3NLhr/DpuqdQes1DA0TeKWXd6DdAvc98/4VwXYbnjLejF0AgarD0btm9eNUhNy2gSqPoLVP/9j4e+RME6Eslgs4oiXHoxyWyvgLpEZa1G+A4N3jvdvmuAamTwJ0d2h4YOUMYHntfP/UbcVYa15nplRBU5DvqBgKgfTEuz
 w7SbkRTs
 d6FLjboq/Vb6+4D0D2y+t+EWMUCgUnxxY55SciT26TfzzjVc2cCl6XPjXBo8qe7QDbOsBNMujLVZPvy5omcFOMmVPeRk6N9Ixsuxfy5uyy25uVnzCyJPMGr/6osRc97Njhnakrl81liupCATMG1dygBAlchT+E3jxed7i5VykLK+EYe/vpnvdoNyNDMY0dtovG7XAgIlcRONoju1qHyOv5sT13vhM4VGMnzX4v/TKh8aOwe64H7zWkWWZ42OvP5NYE7ZSaCTVA4Ceh5gARRqVgNuseL57NszqblDlP2K7YmdlJ8Oa/EvwqUyHBiQbIJB0ngsDcX1fgaoSKUTVpo+Hpr4ajX7D9XITB3Sa38pre51EgVhcyuwuGmpqhO2ig5YZrX7RY+YDVUipM3h9O5COeJE+gaBuUWCKQ1yUoUjUSFRqbZWUr3MBzY6xSttqh2hS7d/vKDjCsNkto+5ige9tjAtaY1oQPt31LJ8kUabWlCCWKksUowgR1ldu0KTsOurXmrUF3VOy5kkNYwH5a2tYZDQ98zoZTBrsRa65MXzENMPJnnPGL+yrV1a6P+S/qEAhQ0cOxviTxz1tccsp0uhDwFj8patUdVLX1Mmk1aVhMPt0oTZSc8bYHkrZTTygg4SJn/jji7BNG2aR3ewOJ2BNU5BF06I/6GMOrCoEsi41/EszjZJDZaEmAr0CHQoBZ0BBe0+278p6wGwamlBDpaRohSLa2xgCBjIIzoNew+0Y68sgHEw=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


在 2025/7/25 09:37, Huang, Ying 写道:
> Huan Yang <link@vivo.com> writes:
>
>> 在 2025/7/24 17:15, Lorenzo Stoakes 写道:
> [snip]
>
>>> On Thu, Jul 24, 2025 at 04:44:28PM +0800, Huan Yang wrote:
>>>> Summary
>>>> ==
>>>> This patchset reuses page_type to store migrate entry count during the
>>>> period from migrate entry setup to removal, enabling accelerated VMA
>>>> traversal when removing migrate entries, following a similar principle to
>>>> early termination when folio is unmapped in try_to_migrate.
>>>>
>>>> In my self-constructed test scenario, the migration time can be reduced
>>>> from over 150+ms to around 30+ms, achieving nearly a 70% performance
>>>> improvement. Additionally, the flame graph shows that the proportion of
>>>> remove_migration_ptes can be reduced from 80%+ to 60%+.
>>> This sounds completely contrived. I don't even know if you have a use case
>>> here.
>> The test case I provided does have an amplified effect, but the
>> optimization it demonstrates is real. It's just that when scaled up to
>> the system level, the effect becomes difficult to observe.
>>
> It's more important to sell your problems than selling your code :-)
I'll remember it. Thanks. :)
>
> If you cannot prove that the optimization has some practical effect,
> it's hard to persuade others for increased complexity.

To be honest, this patch stems from an issue I noticed during code review.

When this patchset was completed, I did put in some effort to find its 
benefits, and it was only

under such an exaggeratedly constructed test scenario that the effect 
could be demonstrated. :(

The actual problem I'm facing has been described in other replies.

It's actually about some anonymous pages and fully COW-ed pages, but 
their avcs haven't been

removed from the anon_vma's RB tree, resulting in inefficient traversal.

Lorenzo has mentioned that he has some bold ideas regarding this, let's 
look forward it. :)

Thanks.

>
> ---
> Best Regards,
> Huang, Ying

