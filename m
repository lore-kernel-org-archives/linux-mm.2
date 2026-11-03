Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 99501606A32F
	for <linux-mm@archiver.kernel.org>; Tue,  3 Nov 2026 02:54:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=IwSt+z27
Received: by kanga.kvack.org (Postfix)
	id A503F6B00EF; Mon,  2 Nov 2026 21:54:25 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A02026B05B3; Mon,  2 Nov 2026 21:54:25 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8CABB6B05B4; Mon,  2 Nov 2026 21:54:25 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 5DF5D6B00EF
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 21:54:25 -0500 (EST)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id F0D231A0304
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 02:54:24 +0000 (UTC)
X-FDA: 85392289248.25.3A0333F
Received: from MW6PR02CU001.outbound.protection.outlook.com (mail-westus2azon11012060.outbound.protection.outlook.com [52.101.48.60])
	by imf21.hostedemail.com (Postfix) with ESMTP id 11DF91C0007
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 02:54:21 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=IwSt+z27;
	spf=pass (imf21.hostedemail.com: domain of ziy@nvidia.com designates 52.101.48.60 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793674462;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2BkKPsxBZLwkkoHHcJ4YPviW5JNVNLlhaR1jgDKQ7aQ=;
	b=R7VnBYFe1J+pGIbkm4nD1SEqUtdp++H/9bpsFEG8MFzemoOpsGHhhQTa6w2jU49lqI9Py0
	k26/gq+Q7HcIjkJWAgxcW2JVCezW8yQsZ2wO+nBSMfK/o8NyUL+PPuhdAJ/oMMmTrYRLUa
	O0wFvKzHhwMKYTeE9TQt0B43STqshaQ=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1793674462;
	b=zKxt2Mt6vGVEukjeyLwZrET3Ja+1ASRjMWTW4eTK1orKni68CWAlx8yQsQo7hOlLddY0Ve
	v2kQEDJmg6h/040HyHn6LhM4b2qa1CXw0pvFK8bGguWlZKNpTA6hK5AYGlI+RMQ/buT8+7
	fp/YgsmGhHhFf/EiWmYuj9nkrwGwQEg=
ARC-Authentication-Results: i=2;
	imf21.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=IwSt+z27;
	spf=pass (imf21.hostedemail.com: domain of ziy@nvidia.com designates 52.101.48.60 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=bAxVSUl2NC1uoHHrVQ/jx5/L18YpX72Y9oEH8ZKz28wH9Cc8iZKlKP/Oxiu4YmKNuRWqE0uw0WsqT4JWZ6hfx4kIRBWBRHoQn047cHI8YcJ308jXjADA0yTzcEeWP5jf+57y07Z+Mc2+9j0jEKoLskN1UkwEBQjC7rXRGZCkIqxEOPCvO0RyLp+9FWlsDwYssvO46HkMIN3iDYsN6dPEKkPf+zsWV2VLOoQXwu/Mo03SpifUXK2mgvZfjgW/M4y8Okf5mN6huZh0NvLg5WPtyaxl6BiHQRHTIQNqz8JP8Wp+GZkKb+3jXhZahTp3e40um3rMRJV46p86Ohx4rC9kBA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2BkKPsxBZLwkkoHHcJ4YPviW5JNVNLlhaR1jgDKQ7aQ=;
 b=eCDbRRvsKK3kWtM+ckJ+4A2geZmzkXhNRPT+t4lmeF2lP5eWPyF0rrOEr5POh1wnxCfN60ydsvJx/4Hpm/8rRSlmJg/AWnarcOWrf+2EKgfIRX4WDJMzCqta1Zy18fVzJhBdQT7jnLUxio9Uj7qNmFta6M39NhhIQlCnCILydwbHU7FtwhMgKJ6X1wdpRUvX+Jwu/bCEKy5iBvBi6SVTNiJ1pBAqBvIG/6h471+jxaAPjUmkOWzgayWePYZIkaOUrnlU4zz2ZJTw5l5kPqPiLIjfJb/Wcn4TXMrmY3xQR+8cG9O0PXP0vV2xT9SiR0+Gw3ReRE+t/RS6cubu4bLkew==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2BkKPsxBZLwkkoHHcJ4YPviW5JNVNLlhaR1jgDKQ7aQ=;
 b=IwSt+z27LPiAroTfPQuDsYJkwjip7M6OVEhsondvJEA2LdcZSW5Gk1+rtdiswfNGcSmfhowkyh4EwhxKn5oQ4eVCeCwm6X8sD+r3uTMTezNg2OW4wf3vRAWjEXuObUPDoxacsaMdF7SSUWbZ/wT6EFELG3SxwsPFpiOzOgw6otgVRpC0e7LONSklMFtoccWJiRLqI/I4wY9nQ0juvtpuxhetXgWd5GJzaGCyLO/aYslwMwbZr4i+8QTKOFKfdOQPGWoEZrER033siPxJ1PewUADgnfaeew9DLMls0jvp1v0uwpZc7IquvgW9qy2jCdWK8xNuNr41m+s+gc3fxYssWQ==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by IA0PR12MB7531.namprd12.prod.outlook.com (2603:10b6:208:43f::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.569.12; Tue, 3 Nov
 2026 02:54:16 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%6]) with mapi id 15.21.0569.011; Tue, 3 Nov 2026
 02:54:16 +0000
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Mon, 02 Nov 2026 21:54:13 -0500
Message-Id: <DML8J0KXM6R5.1QH88IJGA8EU5@nvidia.com>
Subject: Re: [PATCH v5 05/12] mm/mmzone: read the zoneref slot once in
 zonelist_zone()
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
 <20261101021340.2251928-6-gourry@gourry.net>
In-Reply-To: <20261101021340.2251928-6-gourry@gourry.net>
X-ClientProxiedBy: YQBPR0101CA0277.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:68::14) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|IA0PR12MB7531:EE_
X-MS-Office365-Filtering-Correlation-Id: 016ca277-4996-48e2-d73a-08df3955bfbf
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|366016|1800799024|376014|23010399003|22082099003|18002099003|56012099006|261102123227099003|10067099003|261022105027099003|261021121427099003|261021123027099003|4143699003|11063799006|261028144727099003|261026140227099003;
X-Microsoft-Antispam-Message-Info:
	trLg0gRUHWjWjPyyhYdqnLxJTs9AaP7kIB5XuhPWxKuJUTX5rWVR0o5D0vMvr3FbGxp3EUm4MB/jfiIBnsnV9Cs6odPmXL7DEIzAfohCuxixGKR6GBJj9ncOwDy6t5ufsUJQ6HK6w0ZLi/KbzC37o7sS5QunW8/Mpq6fjkxghK21EZ5tDFBGIxgb5vV3a4Bo6b2wfywlW9rsm6e1ZHGLxgF/Fpk5JhCF3e6W7MIIj3lVn2U+eyFbkpiSILd/Voscr8c5Br3jmtKz/Ed3O0DVy4NzX2Uf/XfMKt/A0vQhQA545VazFbK1+g38HEdf3ci25drsBl17Ux3nBBKvwVUyB3lzhavNIuLOnDMbjNPbsgQWVQlS1lHL4acJKLXRRW1APSsFip0xzjQOwvu02VAMSHC57MkMBmv2Kyp9CDIJWHucFoEre1FGJT9Gw/zFI/IqkZwvQ6SvRdGpCsdnCmWrJMKI6t5wvc9RiU29REA49yzULTv9gfN9WOuQo4ngJ6OpeIv5bvKqJgPCUo4AXe6HVNTWZbJmglAxtQDcW9i/V+yAhW3P73HXCKUOpobqwjN53Rcb3fkqsHYcd7F8Ma/MoFYXOrxFnpJYxZ2sF5lfqTE27qy+tC/irplmeXZwhBN/mDepzYUd5T3H7uDHRVA4JRguSCXV+MKJ2/x61dFBp6w=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(366016)(1800799024)(376014)(23010399003)(22082099003)(18002099003)(56012099006)(261102123227099003)(10067099003)(261022105027099003)(261021121427099003)(261021123027099003)(4143699003)(11063799006)(261028144727099003)(261026140227099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?WUZScHZ4UUVmQmxWNlBPRTZraGVtdXo0bEFMRzRBamMyNE1tNUtDd25FTEdH?=
 =?utf-8?B?MXlYbXhqRnd1cm5JNU9wekE2bUdLVjI1SDFlTlZjcmpxRVRNR1RYY0RDR3hQ?=
 =?utf-8?B?RkNmSjFVS0E0RVNoZndwNlBOVGpzVHdyN0pEYTk2V1JZOEowRmdqZXAzaGhO?=
 =?utf-8?B?U2RXRE51aWJEWlByakFQdTFyT3l4Q2REU0JURUJDRUZ0NDQwRS9kSzRUNW9T?=
 =?utf-8?B?a0ExUXJWbjFlZnFaYSs1dkhENjQ2MTFYWmJEdjZITHJVWklTVURZNjJ6MWhU?=
 =?utf-8?B?dFRoZWthZWdCUEg4OUpZd1pZVUYwL0ZlMS85LytjMEFIZWd6NFdQSlU4VXpa?=
 =?utf-8?B?OXhXYnY3Qm5iTDBsOGhsdTluekxTR0EzZFYya2tlU2dvcHBBNitYN1owdDMv?=
 =?utf-8?B?NnIzWnNZN2pMVjh6akxsdDRzNFVQeS80aEJtbHpYeWZCTnNMeDR5d0VHN2pG?=
 =?utf-8?B?UTFKRDhUMWF3TWtHVDB1cnNvRmhZZG9WWVM4bTN4Sm12VVdqN3A3ellSSjRz?=
 =?utf-8?B?bWY0WGxxa2w5bmJuK05kdnlDUWE2bkVNQ1grazRpQVlMRW1ONDJtbVdGYVUv?=
 =?utf-8?B?aE5rS3VncTYrT1lObUg1NlI0M1ZtcHByaXpiYmt6ajlhUmpYSnEyenVIaFdj?=
 =?utf-8?B?V3NZaExnWk9GdFhWZTRGUVlsYUpINEEwR05HZjV3aERNb2F5VVNGYWtLZmN5?=
 =?utf-8?B?VitsdUpJbTNxWlV4ei8wYzhjMGtMdExPSU80NXV1TE1OZzlQYW10aFQ2Ymgz?=
 =?utf-8?B?NXl3MWlYYnczUUlyK1F1VE1LdEkyQnFzdnZXb3I4LzZsS3h6REdiM2xQK3VR?=
 =?utf-8?B?UGpISEZxNXd0MHJuMityTDkrekZRNmN0VnZiMmkrOWJZZU5pMTRjdEpUNys0?=
 =?utf-8?B?OGxvTVE0RHM3azlDTUVsOXRFRWZRZ3hWc3IvdktSVHR1aEFlRit4V3RNbDUr?=
 =?utf-8?B?eFl0OCtpdnlTbnRJYURjdTFkWUh0bnVldS9adlBKSmRKQTE4SjYra2JtMll2?=
 =?utf-8?B?ZGpWM2RNbUtReGVkWlQ1R0NNNFExa2pPUGJQcks0ZkMrNUc3a3VRNmYveXlO?=
 =?utf-8?B?a0Q1d1RiZGU5UXY3dFk5MmdaeTlNQVVxM2xrT2QyWFdnYVhBYmQ4VmNsT1lK?=
 =?utf-8?B?Vy92N0w4d1hXdTZTNmxYemoyVGloR1dGUG8wdzFuWWhsY0Rack1lRS9qZVNl?=
 =?utf-8?B?a3VyU2orWjllNnphYlhpWC9IZGZVeDM5eHR5YTVEdVk1SnV0djM5dkNwbzZ3?=
 =?utf-8?B?eThOSEtmcENxU2RvV2lMNFFHMC9TSXRKWEZNdlN6MW1lR0pMYXlqT0graU5J?=
 =?utf-8?B?dlpyNHNhZEM3UFdJRUVOOHhiUXRiQkxNNldQSGJTdTVXYU5aVm1uL29JTloz?=
 =?utf-8?B?NW9KQzBEcVZVSWR2T0NEeG9VV3pSSENFWld3eGFTOHhHYWdkVjEyaVFPc21T?=
 =?utf-8?B?dHg5K1hjaTRRMHRMSlE0L3M5ZzQ1MU4ybkZacmM4dHJqRlcyNThnR0owMy9j?=
 =?utf-8?B?ODZPOGhKZW5jWTBjcmJUeEpDWFovQzJaN2szaG15c3lvMGk0bHVPdXdHeHAx?=
 =?utf-8?B?WlRZRTM4NklOYi94UGcxYUZyOEhzTmEwQXhMMm11M0pmSzE0Wk1GMmlpOHRN?=
 =?utf-8?B?TmpZeVJEUm9PZTVnYnMzSGtXVlNGZ3A2Y3dPVVMrMDFMR1RjQ3g1Z3QwODRx?=
 =?utf-8?B?VWtUUHNrNGN6ZXNsQ2ZjaDVlN1lDM1E1VWtRbCtPSkdlNFRnb3BrL3NmSVB1?=
 =?utf-8?B?WXBxZWNRZG9NNGl6alJoNGc2VE1CU2lKeWEweVE1anU3ZDNaWDlSZ3doN3h4?=
 =?utf-8?B?QS9BbGlsOUl0dzhQWE5qMERwOTJxRU0yZkVRUzRQVExlR01STEszMGRnZDdY?=
 =?utf-8?B?ejA1TG1McVkzRExETVNDNGdWcnV2SysvUWdxR1BpQmw1YkRxcVB0R01SMXJz?=
 =?utf-8?B?dTkzcklNcmhpY0R1Z0ZhaWl3UVFSc1BqMExJeFJGc055V1haQXJVaE4xVEM1?=
 =?utf-8?B?d0N1WVc0eFpvaTM2dzBHdjlMQ0t3aFNCU0pONnNyS0ZLZWxZcWFFM3dNVE1v?=
 =?utf-8?B?WmN2NmV0TjJKcGJ0L3RNS1hmZUNEbkZSVjJkdnNPOU1jSGpTMmNMRGhwTVJ6?=
 =?utf-8?B?RDRKK0Q3cVRFaEJZUUd5c1dCZWpWS200V2Q3c0FwMFhFaFJRV1A5dTRjZ2xk?=
 =?utf-8?B?VG1haGdoNFpOc01PdzMxQ3JBbjl5cUdJV2p0QkJoNFUxUk0wZ1ltYWVvVFlG?=
 =?utf-8?B?anJxeG44Z1NZNDlscGxBV3RRYkRhcDNCOWQwcEJVL0hzczN3VDNJQUFrUDlB?=
 =?utf-8?Q?0DQtjrxfhVhGY6zODP?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 016ca277-4996-48e2-d73a-08df3955bfbf
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Nov 2026 02:54:16.3245
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 20SvAPjdF5M2AqeYGVyu5VXSAW1ZU7/wDMrHa1caVgLo8F30HD09S+MFEl/i3WAn
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR12MB7531
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 11DF91C0007
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: g5k8dbez79pscedrf8uzgb6yrga1j9fy
X-Rspam-User: 
X-HE-Tag: 1793674461-327233
X-HE-Meta: U2FsdGVkX18yBOI1umh/+bmvrctfrqaEFUvIEtMUtZkPOFNKzl8N0OedhQWF8w0LN6MQKBVd/L1YxI8W8oirchyEloJX1YsRTaxjUX8cMqjjgAMnxoWBAcmRS4WDEszc2BlLVTmPzASfhcMj4DHuZZz/tMUEvecQh5TArYge8bzyfPTu/EcPDmkUifyE2wbf+tcCm9kCP9/rETuYkSsgCflJxlWBa/l7eHUK5XuTtCcftA3x3HHhJa60Oc1e3h4RUyAAVnvGhPdRURFZYTokpT3UqIMOZxD8QKiMEoUHDmBQw/8Y4vbIs7IqmNy+O08TPpyn/Rfug4S7GaDxqBQUCCOzH1wp/L2vMSwPwJ1Uf7FhpOnOWoVBa+AaofS4OhnibSSgflF1XP/Oh//nXNBQQ4hgdmz7R8g0taJkpZXMKLe2BYphbspxsFSTG5BqFO1paSgD3drSPgiQgwZVoXnYq07yN8ZBPJnQoEAHiKz84Jz3yigceWeZrgYpbXLdM7CTercHKShhWLGVW5XLu/hfLJnLlq2vOPJQe9ShAm2e0bToXU6JHH6RYib1AH5ZRZZ2eIqwaToMk2F7F7v4zT50vBmH9Sn4IH0yBPzUJNdjKz6kTksEGzQDcPx9jq77//OPBnHLttN1IJSB9UMn3lpwDQwqY7kzSx4nP+um7/gwwWhf4wcibA8L8f6h6mOgsnnhHjtY4ku9chLvAv4RiGmmoKC9ha4oKppLSRwsIkMRrA14bWpMr9mn8/VVxDWiR+sBrqPXT1GA4FF+VFI/0NBvI82MDOpyJ4NBVlR+Q/xRh5UJ72NtHBxeZEVdg5Ua6diiKIZOQzDt1DWW0Bf1+NKR4ShfCdS3Rle0z7NMLtzLpLEFShug+V5QAhpHcKN1unM9t9vR6YkSBWOFAZ3NB6D79WtFFHJkh7qHyt5z+eUjIQbJsf+FwQ+i7YREsiEcJfiq234fcQSBx63I4QOF2ip
 M2f5a8HR
 6ChLczPh0gy0/CcnFTtUHvl6rXmt5ThSxK8uBoXHX6qAeYMVY2HFdW0R+ApCidHgSn3lSa8y+IBmyDHmoHQ5JtCi+UrcBWNimThDS74+KAd8Su2RfxYGcTcX7LEbtt9Cs8DeXRofdBNtSwbP1w6e90MguQ2P9u0SOYz7VU7GVMj1/oJ+iSmmZWt/b8CWaeNNJMCMskD0n6F5a78uNG3Ibn9PYP94VcEts26acoWnWItC8KAmwpS4ePapFnAGTtDCFV3opD/7W8TT23ZjxpS2/5XR+rvxi54Zv6uJme5hIM/e7EwqHAZdcCH9gNrcFdD3WXY5jojwBfH6lglvzLpxEnWlBn/u/uCygSdsRjS0398V1IHw8NG8NUyE7c8j6JJxINESaogsl9E5W96G7ugd5LeuXV89GJ9V83i8nPZXRO/JEoDNgsOpfNGGVVad0xOG5TSxvf8uhPN9QBtXjjLe15ZhF1MEevqvZaCYwOxRTYB9RrysdzaO5xVZMqknIxOY1eSg4LNdrhV5Bp6x8sD6p5HLvjcr+jkLzJ6PG+oP7zOv7eyXMChKxYvoZMGRxJWzIMUeYsq/FORM/nPDMcm1D2dGCDWh1sspfSLr1C7RjjrmVgACswKdWH5qH6g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Sat Oct 31, 2026 at 10:13 PM EDT, Gregory Price (Meta) wrote:
> Memory hotplug rebuilds zonelists in place while allocations walk them,
> so a zoneref slot can change between two loads of it.
>
> zonelist_zone() loads the slot with a plain access.  The compiler may
> load it again later instead of keeping the zone it already read, so a
> caller can check one zone and then use another, or the NULL terminator.
>
> Use READ_ONCE().  Callers that take a zone from a slot and keep using
> it, such as get_page_from_freelist() with ac->preferred_zoneref, need
> that single load.
>
> Fixes: 11cd8638c37f ("mm, page_alloc: remove stop_machine from build_all_=
zonelists")
> Cc: stable@vger.kernel.org
> Signed-off-by: Gregory Price (Meta) <gourry@gourry.net>
> ---
>  include/linux/mmzone.h | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>

LGTM.

Acked-by: Zi Yan <ziy@nvidia.com>

--=20
Best Regards,
Yan, Zi


