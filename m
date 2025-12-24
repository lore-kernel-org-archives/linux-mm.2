Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 22A08E776F0
	for <linux-mm@archiver.kernel.org>; Wed, 24 Dec 2025 16:38:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EA1CA6B0088; Wed, 24 Dec 2025 11:37:59 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E4EE06B0089; Wed, 24 Dec 2025 11:37:59 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D069C6B008A; Wed, 24 Dec 2025 11:37:59 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id BE1EE6B0088
	for <linux-mm@kvack.org>; Wed, 24 Dec 2025 11:37:59 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 2F9A4140372
	for <linux-mm@kvack.org>; Wed, 24 Dec 2025 16:37:59 +0000 (UTC)
X-FDA: 84254921478.15.006D5A6
Received: from YT5PR01CU002.outbound.protection.outlook.com (mail-canadacentralazon11021108.outbound.protection.outlook.com [40.107.192.108])
	by imf18.hostedemail.com (Postfix) with ESMTP id 38D491C000A
	for <linux-mm@kvack.org>; Wed, 24 Dec 2025 16:37:56 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=efficios.com header.s=selector1 header.b=GDE8M0Dr;
	dmarc=pass (policy=none) header.from=efficios.com;
	spf=pass (imf18.hostedemail.com: domain of mathieu.desnoyers@efficios.com designates 40.107.192.108 as permitted sender) smtp.mailfrom=mathieu.desnoyers@efficios.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1766594276; a=rsa-sha256;
	cv=pass;
	b=31zc7CDdHP36fOigTf8TVKEKf/xllunKtcF/pvVq2lfXYURrbSWDEAZVKTk0yXSOJ6PnTr
	9MkUYmO1yRgXWzghmT/6SYpfn5vHkY/fJ0oJ2oeRUzEdWy+tcMGADO6415qqnskaert/Rw
	3cxUs5BrFQ2jlKpLaq8v3gtbncBabK8=
ARC-Authentication-Results: i=2;
	imf18.hostedemail.com;
	dkim=pass header.d=efficios.com header.s=selector1 header.b=GDE8M0Dr;
	dmarc=pass (policy=none) header.from=efficios.com;
	spf=pass (imf18.hostedemail.com: domain of mathieu.desnoyers@efficios.com designates 40.107.192.108 as permitted sender) smtp.mailfrom=mathieu.desnoyers@efficios.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766594276;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xiCw9kqQMXav4lGA33X8oKQuBz6qH4iCFrmYc1VzvTE=;
	b=cSTcz3yxxsqkHll+gw4VjshJ7S0X/5Kkc13sQTXqa79Pfv9wV9rLG3kb5bm1seT4biYsMP
	ycdUNEZqj2HpkS4Go4xGk6+ueXucr6eOTDELGFP3BkeHWqm3mC4kc6qrmLMsxUdB2NM453
	e1yFUmG6DcAw5Suc8RRjaClcglrcU7E=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=SBSP8Tahd58rUYEfAJ7v6jr3d+l+l4AQGsjf8b9Zw24lgTt0h+XkiCeXVJnLaNrpHBd+K7IzrIj665yemR+4eUmW+qAAN//Ng8UoGh83HaDYpd2QSd2whu4AdlCZOx8ITmR6RNjuLNn9eJIU5nbFpzqWui1B5drmhZmYZnQtkttkO8PktK3q9T0N4Rx7wcSxQdHDzlJ6GutCgUXioXNvHgnHxw1oRxCpF5ZQ4BFpGsoE3sZpVRVw1vJ/fiwM25juo1StsV1k1ESlXQQyV6Wym2vIoCLKrM56cIrplqIRti1Nl2ylI1l711P3Rx5r9vsycMk5IAqKFzzP6dcdwAbw/g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xiCw9kqQMXav4lGA33X8oKQuBz6qH4iCFrmYc1VzvTE=;
 b=hg1OaQL0U7gECWLF0PP38iQUh/u6O5sVV/Fq/7hb2NbvwOdR9tF16I4bVcJXBu8tEwkNzF7pNQpPvelNfJTEj9gr054Y5LoVf5qZmMG22F8ULvjzPO/ekxsB1QwURZ13ECs3tioP2c6gyUS3ojsBf1+118pYd29RNKPoeenADaXAhN07KLWCwOKDJMy/dU8uRBLxnsrEPgWVjH6o+rybmIjYf1YRIItoqjUOaTUhyUlXwBUBJGZJlrJVUY8pO3vd7FZj3QgZTwvzZzH/YKM5MNys43MxPbfRainGTPB9dsup055/ctAhVD5MIQFWE+JXjhxPKrSwNhXR5RmkBrp6rw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=efficios.com; dmarc=pass action=none header.from=efficios.com;
 dkim=pass header.d=efficios.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xiCw9kqQMXav4lGA33X8oKQuBz6qH4iCFrmYc1VzvTE=;
 b=GDE8M0DrynsoI2zjdbWkP7s4/as4QiuR8uWnYsLJMFTl90OBUBGGqPxa71WxRlo+bCrHp8tQK7qCPsl/9MS41Km7YOWEiEucylCmwOnkeUHKqVXxFlHszS89ahxq0aHlqi8k5IQAcX+IY/JHUSfStlZnX7vV10dTe5llmfKpfS2wLTkeA/Pyl81KWTfd1JPw8LoxFQghH/aNjGWC5UU4ga8GAbBTRRrPRJ/ApYcOhW3va0rFCqDRAjInYJOOUgXyWF7HltqOuRZqommmL6zHhBt9EczZIUe6Vm5e0RyTWORDDEoIWkVsp7c/QJaPqDZtDaWK+DNEGQtbUtL4D5OpwA==
Received: from YT2PR01MB9175.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:be::5)
 by YT2PR01MB10553.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:f7::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9456.11; Wed, 24 Dec
 2025 16:37:52 +0000
Received: from YT2PR01MB9175.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::6004:a862:d45d:90c1]) by YT2PR01MB9175.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::6004:a862:d45d:90c1%5]) with mapi id 15.20.9456.008; Wed, 24 Dec 2025
 16:37:52 +0000
Message-ID: <dd9fa8f0-b39f-4651-825d-a3d52c33d589@efficios.com>
Date: Wed, 24 Dec 2025 11:37:50 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 0/5] MM_CID and HPCC mm_struct static init fixes
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Mark Brown <broonie@kernel.org>,
 linux-mm@kvack.org
References: <20251221232926.450602-1-mathieu.desnoyers@efficios.com>
 <20251222175957.bfc9cf8b25e587f3f5e304bc@linux-foundation.org>
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Content-Language: en-US
In-Reply-To: <20251222175957.bfc9cf8b25e587f3f5e304bc@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: YT4PR01CA0176.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:110::6) To YT2PR01MB9175.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:be::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: YT2PR01MB9175:EE_|YT2PR01MB10553:EE_
X-MS-Office365-Filtering-Correlation-Id: 11ce3fa5-b298-4b27-fd46-08de430ac87a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?VHAwQmpZNDR5TDQrTmptV3EraUpvbFl4WVVFRXlRSXJocXpCQm84ZC9rV3ho?=
 =?utf-8?B?c2dod2t2U2pDS1BiU25RN3l4SmJMK3JQSitsNWhNbDE2MzBBWEJOQmhrck5m?=
 =?utf-8?B?Ti83SkNlNm9HdjNKMURTZGhkTzBadHNuUzI5SVd2S1RLRUxOSG1WQUtRcGdp?=
 =?utf-8?B?UnNoUGFTWUU2ZWMrK21aZkM4N3orOXIyaUpiT3JFbEhjbDRXeGVhRDNOK25R?=
 =?utf-8?B?aktILzg4N0N2YXVGc09sNzY0N0sxNWxmOWo1bjV5c0ZxMGxZTXk5bGpJRk9L?=
 =?utf-8?B?d1VHS1BHSE5CdXZ3NVo5aEJtUm1ncVFtNWJtbHoyVkFNeWIxQXl1L1RrVjZm?=
 =?utf-8?B?dGNwcVdBb1VMM2UzUnQwOXEwZjMzb0dWc0MxZmF3Zkxhd0U3QTljb2ZINVBP?=
 =?utf-8?B?YmNvUU12K3JUdnUyTHArYlREOUlNdkcvdzJYNCtPMVd5QTZzM3IzY2VMU0Nj?=
 =?utf-8?B?UWRyc0p0Z2c0bTBYbHV0Y2xsRitJZjNaUmthMUlzNDRiVURycTNYSzNxTlVs?=
 =?utf-8?B?T3A0bDRYNXUxM0p6UGREMnRvQjRQQXVaNkYvVDdaYTJ0K0hRSUU4K1VJamhr?=
 =?utf-8?B?UjgvL0lmWTNEWGh5UkNMOUpHL1N3OHo3NHUwbFZJNFAvSUsrQkJwcXlJcHU0?=
 =?utf-8?B?SlZCZDZJMVJBMmdKeVJubmhIbExRYTlJZ2xXZ240cEc4Qnp3NGVYL2JSdDgv?=
 =?utf-8?B?K1NPTTJ0QTBpT256SlJ0SzdGOGZId3E5TGhUb21YMTdITnZuL2k5MzhMb2tn?=
 =?utf-8?B?VjZacnNndVl0aVh4MnhsdTFCeUU4NVZ3b1R4bm5zZzhYSzFOd3RXcFhOaEho?=
 =?utf-8?B?K21QV2FPUkNjcjhnU3pHcThFOHV5N1Z3bkZTOFRObVJTQjFGb0VYMG5Jb1Nx?=
 =?utf-8?B?Sm9jYzZRL053bjRXdVV0L0IwTk92ZGxLWkJGQ3pRZGIva2s2VGhwMkZLdDQv?=
 =?utf-8?B?eWtBdkRPQk9NS1E3Sk5Mclh5T0tJanFINFV4TEt2QXFqbEpqOTMvd0RVZzlq?=
 =?utf-8?B?WWdLUUN4d0hWWndTVmdIbTE3VlNBZjRWOTdFVjJ4TEh4NDBURk5oY3p5WVNo?=
 =?utf-8?B?MGZGRm14anBOL0IwaExPbWFnRUtES3NyQk5jeXZtcjlWUFhCbEN2RzMzVUUx?=
 =?utf-8?B?MVlrL0FhdE1XQm1FUUt1SkltTytHcDdIbnBmajFQc0JLQzJsblBBOE5MbmE0?=
 =?utf-8?B?NzJVMkhaWHZlY0ExWXI4T1lYamtPSko4NUVZL1ErM2dYNjRjRU50U2JuYVZ5?=
 =?utf-8?B?Q0tKSXVNVm9oZFEvTjk0alBRSjFVUWxFZUprRCtIN2FCVEZhVkNEMUQ3ZW1L?=
 =?utf-8?B?VG5wK2RqWDBISU5IUjdDVmU0NkJkRVE2TWlhWTU4TmtiZkUrZHVEMW03K2xZ?=
 =?utf-8?B?NDU4QTl5RlFYYlBNZVJRb05td0wzMWdMcmVvemM1dytmUDJIa1UyNEh1bFZ6?=
 =?utf-8?B?K1M2QzJZZktuTC9IOS9TYjh2YzcrU2M4V2d3aldtTHpBSVk5dml4RXRvc2NT?=
 =?utf-8?B?WDdzc0tqTnpGYzhHdm1HcnpUQjZtMXFNMy9taFcySXVWN3ZWa3JOU1QwcGNF?=
 =?utf-8?B?T1M0V0s0TGtWWmVDYWhTY0VXSkhyMlFYQkV1bVAwcGFzUzAreThraW1SNC9D?=
 =?utf-8?B?bGs2RXRYSmhQNkhtWitwMEZvcTZ0Nm92WFkzNVg3WStCVGZPNHp0L1M3Sk5a?=
 =?utf-8?B?T3h2VmJlbFZvVFpLUUdqblpHOGhTUkJLVUhJSmtWS2NydWR6bk5NMzkybnhi?=
 =?utf-8?B?d2FFblN1bXJmbG8vSGJvRXJsRGpIZS9vQnlLTmJiREZXQjZvN2phRnZ0VjYy?=
 =?utf-8?B?dHd6QlVqSFpVMXo5U1VDT3pGc1BhdUlGV1Y3anlleW5qTG5oOGNIQkdSUGlP?=
 =?utf-8?B?RThnNko1UE8yb2V1VjV4ZDJjQ0czWVBkd0FYd1ljWGJrOEE9PQ==?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:YT2PR01MB9175.CANPRD01.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?RGVUTXB4ZVlZOUVrajByZHFFQkhDelU0VGtNck52b1BpZi9HcjdLMndiTnRu?=
 =?utf-8?B?djlKZktFVzMyTnlkdmVQVTRkUk1hbHQ2a2ZwblRXUmFyZDV3MnNTc0NrVDZ0?=
 =?utf-8?B?eUNyOTdSSGZsWVJOU2FxRmkzYTlIL2V3WW5VSHM2SEVFWVhNMlZuSDFSb3pn?=
 =?utf-8?B?bjJMLzIvYXY3TUNLT3NTQzRHUkhWb2ppakg5Q1RQekY2V2p5QnU1VlI5dWNQ?=
 =?utf-8?B?eWxVNFB1dWlOUmlEOXJJUFFOY0JtNDgzWFVsU0RlcUx3UWdDOEhndXBLN1RG?=
 =?utf-8?B?UTErcjdlMTA1czM0N0p3SmRXajdHdVdBVm91ZFBaSUdQcmx2NkRMdGhYQkxo?=
 =?utf-8?B?Rnd3ZHJtT1pqSSs5WVVMUkh1d1Z4SGhSU1JRMTQ2aVRINWtrQnk2R0d5aFJC?=
 =?utf-8?B?QlgxN3ZzTnBqSWhRSFdVbUp4UVoyQUdwTlAwL3RZTUM1dUV0ZlF2UUNmSXpR?=
 =?utf-8?B?SWZKbFptdUJnaEpNbzFWdmp4Tm1YZTkxbmxXeEVRVEJiaVJEVGJFQzVyZDlF?=
 =?utf-8?B?Y1QxWHRxWndiQUpNTTI5RDFrMjR2aCsrSkVYbURhMjEya0NYWHdMajlCQ0lF?=
 =?utf-8?B?azc3ejA4M0E4MCsvVzA1eDlYR1dSc3l5NzV1Y1dEMTNjdG1JQlp4R090NW5D?=
 =?utf-8?B?Rm5SRVI1angzQmlGd1FSbGgveFp1UW4vY2dmM0hoQlk2S1JBZ04yZThsMElh?=
 =?utf-8?B?YjJtKzBzcTRpT0JlMU9WR05sZGlRN1lOL2ppZjI0eTNoMWV0cmVEL2hSaEVN?=
 =?utf-8?B?RHRYT0diYzcrdS9CNXMvNGhLU2VjTzgyQU1YMjU0NkZqV0l2cVJpUnBLbTl4?=
 =?utf-8?B?YTNsUThlVjU0bXVUSEZtRGR3VXdMTXZGaWk5cDR0MHpUYjAyMlkzMnR3a09p?=
 =?utf-8?B?YXhRNmpIbVc1QzFibVp3T1BHZ01FL2d0RzNUY3IvOS9FK2NqM20wTjFINVFT?=
 =?utf-8?B?UnBTV2tpcGVZNFM0TXBCZkVJWkJlbk15ZWZGWUxnN3VQbmZzZUdLQkVENFh2?=
 =?utf-8?B?YUQyVVVPV3JIekw0S3Z3SXZETVVhTmFzMXRnVTVCeVdZN1RxV3dUdmQwY2Qy?=
 =?utf-8?B?TDIrT1VReVUyc2syb0JyOFEzQ1FWQjkycU04bSt6VmZIeVBJemtmRmZ6QVVM?=
 =?utf-8?B?NU41QWxZSWxhYS9vaVM3dkcyWW05ZVpqUkJBN3p4UXB2aWxlNkxqdDhtMmFz?=
 =?utf-8?B?TXJoQ01Cb21kUmRTVEgrbnlWY0M5NHRpN2VYejZFOFV0dW9iN2pPdDM2N0Rr?=
 =?utf-8?B?a21yNnVWcld4d1RESURUMVZWQVo1Y2pua2lxbyt3RmU2b3pOR2ppT093K29y?=
 =?utf-8?B?ekl4blhXdGdxMThxdkx1eVZhV3BsY3hUYkhRMkNDdm1ORGZtTjB0TWdwVWMx?=
 =?utf-8?B?eEtoWVFxSDYxdFQxazl4aEJEZElDU3VQb002ZTZnck1EcE9Db3VGV2FQbXli?=
 =?utf-8?B?dWwralIzczBPWGZ5S2wvMytMbit6aXpJS01oVUtiZkVDR0NnN2Y1aEF5UlhH?=
 =?utf-8?B?Tm4ya0NOM3Vub01xdFM5TFZVWUtoYmI3Zks3b3FTdm9DelZXYkZDSGxVQ3dY?=
 =?utf-8?B?bit6dy81Qzk3MGFoZnc1T0xhVklsc0h2L0FBVXlYdUVIT0Ezd05ob0E5YXFI?=
 =?utf-8?B?ZUk1UW93WXlGNUJqbVE5UE0xQy9yWVZpNDZQbTY3ZnYzOVZRQ01lVzNOOWpo?=
 =?utf-8?B?cVh5OWcycHVTdjVyVU1STG9kTEMvaWtmeUY3dzZqdW9HNzVDUENyNFZtcFU4?=
 =?utf-8?B?NHNtR21HRW1zTjNSSW5FTnYrZm1RajN1eHJyK21TZmNlNy9WZEpUUFNuZ05F?=
 =?utf-8?B?VWJpTEFOc3dITDRza0ZvRHU1cjZsSkxsbzNtQ1FsWnZ1TEZ6VXAzeEhIcGlv?=
 =?utf-8?B?a0lPOWhNa1Q5a0l6Q1M1UnRPU1VISnJ6TGt5a0N0eDBKbmFnQjZWV0ZNeVY2?=
 =?utf-8?B?ejc0OHZ3cHk0YmlQM2pMQXNqcGNQY29WcjRzSVJSbVNWb2ZXeUZFZlVCVnBF?=
 =?utf-8?B?ZytIbWFSNlBvTXhJNS9UbjRiYXZ6THNtY09BRWlZakJxV00zOVpybkpjaVNN?=
 =?utf-8?B?cEJJYnZTSi9JelR1cXZYaXdpSHJTUkthVWtkcXN3bkJISHNTL1AxaXFvcEJE?=
 =?utf-8?B?R3VaUUpKMG9LNDNodC82SW5WZGlSQ0xQWjNmbFpOR1JpK21HYXZyT3d0a2FR?=
 =?utf-8?B?QkZNQ3BORjVJYjF0OW14a2d2V1pRMjFlWXQ5NEVPYXQ1R2NPSzU2UmovZ0hx?=
 =?utf-8?B?eXpuMWExd3hmVEJFTUNaZ0VPUnp1am12NFFTcC9USkRRdXc5bm9RSWplcnRQ?=
 =?utf-8?B?RnBpMi9MNEFSVTlaQnplYTdXdmxyeHpjZFExRnhVSlZlUzcxK21DdjlvamhZ?=
 =?utf-8?Q?PsXYXqqxsfGjBOHM=3D?=
X-OriginatorOrg: efficios.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 11ce3fa5-b298-4b27-fd46-08de430ac87a
X-MS-Exchange-CrossTenant-AuthSource: YT2PR01MB9175.CANPRD01.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Dec 2025 16:37:52.6601
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4f278736-4ab6-415c-957e-1f55336bd31e
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jq6Za3Gi9D2F4GXnTHL+F4q8pt2+fN2d2aeWqNGT4/VNdZyCDV2fG+UfF8woKYQEG/hS5U3uzToEWsbOSqq6CfiDXnKt036ECa8niR0hZXg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: YT2PR01MB10553
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 38D491C000A
X-Stat-Signature: 8tn1zur9cak89uswsugbggg19poksdii
X-Rspam-User: 
X-HE-Tag: 1766594276-410545
X-HE-Meta: U2FsdGVkX19f8z7xOtR68Myg+sYrmnYthT57M6wwv7St+HuDvqb9JGh89snweP5ujfAzkoT6oVCgi2dnt3zQt1au/6cY3qcO1bvRUW2ksr5i8bHjYyJP+YBMESnJDs5wMSuJFWbNJEaAWSk7NtBIxI76pAk34g9wFMXlH8f6xrnAG4kIEaJOrjbADoHIetgTT34KI7QzcYZfIMm+XD3fWp/VuzNk3jmBozXDAygMtarA5LX+wx5PsNezBfWXCy4uvIiEPX3H1534FgLlnmOpUypqd639oG2aRGw5JTtL2Yvz5nKmbWbZyc4119I7QbbA5bspQp9RXa839qpkKN9W/k90JkrGaX9irODfZ2Ft+E+duUYLbpWWjHSCAwmS3EQxHEQsaG/5atRBd2htdkfnhmgQw0SXHRjdPU8z87oZZ5RDcVDs1IqzFjEWxazjV8wOGOsvJaqjXJSR8sdBv1lrCxx0F7AUM85N2y+3KZVYa/eSNxx9jBrkIMhrCla/hn9CWiqM3or2cUn4h1qU2sdhXIB36JrFowmjzZEGppJyWuLHlV925yVJ6uzcgRG+kfPUztLvUf9xy/XdGEWlOc2R/lf5aDhGqjoRKsftlZ0IMOUmUMKd0xf+tll6QaVvxSAfioQqGuPBVS1DMymQF4YktPQjF8wmuQNz7JhHPEnLCnVQq1zZ+Gz1J/qaaMeZxrdGHx3BDy9GdlXkHk/+pTivRhkp/Kde3Fh9eW6/WYpNiHpq97e/s9JP8Gg1lIM7VoFu8KO/3tb79IoFKb34zBnlG8R1bPGUV+qBol3iwFXVEHAUBXZLhi1LCyk9p1kPOR/frW5ifrdKfdTy1pHYovjDSGEJ338AR8GdEUao8wISZjPLeeR06Z5FCoBjM+ZKE6kDfubBa227ZMKin+0V+8Tpt3PzrB8la2y5FeNTWk0t1gGjFlFU+N7BtkZOMWC1QGLrAmrI14pTvXQ07wCtgEz
 wxe+EBEL
 lEQ7qTIPIkeTxnBZM6CU5pNf5pZILGbVesTvE7E8KFP2Eol0S0S2b8tK2+FBYvXmevOUr9iNzwh9lkk1LU7wnrtXt1SS0qZ+qzvMIifWz9RDUZ6cEm/Mr2rvSSqeZYNLntEaYMb96Nak7C7i3bzAI/+ex6Cry8Y1LEtaQbUJ9pOyry9FPqH8bDIdfavN53axFm4fXenfNX0Ud4e5WzAT4uWcoOHKQq69zGZZJ89nnIxShE6+2RQ6PXPsmNBWNqKh5zVSzKLy2usevtj0dpZd+ln4IHc6GGB7bMipy5JKv4usEvbFvfGKpGcYmaEz3aBMJLZjDibYkfxvjXArADmCOhHezXrhypfDTgEj03Mjx40wcNW2KrVrOPi3oVGrUTz/i0IIOvXvBEJRYobeYQ/qGrKt/D4/qsfom7STrv41atinXr9GZTTcXn2nU6ILix8nicalgiGO3S7FyoQ26Ft4ZXDIQKMVtv8BnqcR+7xkjjxbQAefXy87xUdVp9IkawTOLEHJpgZkT19UIi+g=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2025-12-22 20:59, Andrew Morton wrote:
[...]
> Well, simply appending this series to your "mm: Fix OOM killer
> inaccuracy on large many-core systems, v10" will create an annoying
> bisection hole.
> 
> Also, there are some cc:stable fixes in here which depend upon the
> presence of "mm: Fix OOM killer inaccuracy on large many-core systems"
> series, which is all backwards.
> 
> 
> So for now I'll toss this series in there for testing but I'll ask for
> a redo, please.
> 
> - All cc:stable patches prepared in a standalone fashion against
>    latest mainline.
> 
> - Any non-cc:stable patches which fix things in current mm-new come
>    next.  Perhaps view these as preparation for "mm: Fix OOM killer
>    inaccuracy on large many-core systems".
> 
> - Then "mm: Fix OOM killer inaccuracy on large many-core systems,
>    v11" which incorporates anything which didn't make it into the above
>    two categories.
> 
> That could be as many as three patch series. Thanks.

Will do! It may take a few days due to holiday vacations here.

Thanks,

Mathieu

-- 
Mathieu Desnoyers
EfficiOS Inc.
https://www.efficios.com

