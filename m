Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 73A3BC5AC7C
	for <linux-mm@archiver.kernel.org>; Fri,  7 Aug 2026 10:57:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 84C896B008A; Fri,  7 Aug 2026 06:57:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 823A36B0092; Fri,  7 Aug 2026 06:57:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7393E6B0093; Fri,  7 Aug 2026 06:57:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4943C6B008A
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 06:57:44 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id DC755160344
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 10:57:43 +0000 (UTC)
X-FDA: 85074172806.02.0AA25A1
Received: from OS8PR02CU002.outbound.protection.outlook.com (mail-japanwestazon11012054.outbound.protection.outlook.com [40.107.75.54])
	by imf05.hostedemail.com (Postfix) with ESMTP id B0833100009
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 10:57:40 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=vivo.com header.s=selector2 header.b=pnOKt+Wy;
	spf=pass (imf05.hostedemail.com: domain of xueyuan.chen@vivo.com designates 40.107.75.54 as permitted sender) smtp.mailfrom=xueyuan.chen@vivo.com;
	dmarc=pass (policy=quarantine) header.from=vivo.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1786100261;
	b=gecaXQ8ZutBnZ3FuAdz9cWEBZ5pS4gxfSUPek9lJEr9VoUAzZsBgBkg68eJfnZSQIgHAVt
	JQ9nryGQNAYCpDyZvMqKjDFe8e7HQ4TmQgpn943Sb5T5jKhHmdfF4hu/7TfxDz8Wgg5yTk
	VM307I1b8Fjg+UpwjiMRDYEJieMmeuM=
ARC-Authentication-Results: i=2;
	imf05.hostedemail.com;
	dkim=pass header.d=vivo.com header.s=selector2 header.b=pnOKt+Wy;
	spf=pass (imf05.hostedemail.com: domain of xueyuan.chen@vivo.com designates 40.107.75.54 as permitted sender) smtp.mailfrom=xueyuan.chen@vivo.com;
	dmarc=pass (policy=quarantine) header.from=vivo.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786100261;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ChWORXfsb+I9yN7CAApoI53TtGApVoUNnpSyV7juhoE=;
	b=S8WIk5deRTftxJni41JSylPYrMCAYwYYyYoutOHlPDHUqgUWk6B1EE/6vFzNNF1x9q0EVv
	M7nO+rLVwuPjkAp8OmzcsOYoLcSJEJUOI/w2vQJ63vwdpSWDf5uJvPd18x9c5YF//5zlx7
	Tp71z9AxwMufSg1HRVqRWrqRdsAEiI0=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=uZOfKiA3cEhl/2kuHIZEgL6d4YyZcPICpG5wpHCb7FwsIgNdb2qLYmJhCmGp8NspFnwUy5+nzZkodc1XEWeoTZIfkosQIYhg+DnHxsi5eoBaqpRD/2q3Pzf+XT98tAo/QMrFuex12mjeyE3dl76cRGFtTRX6bXF3yxq13cOjFbCn5gkVCMCce7Aee2DnpwdB5XMPXEAAGM2x0hUKpt+IiDhjRZS/wjUiIOaFt0QyP2glRej4u7ptOnAmx3+ZrQksX+mgATkPpm2/aCNctpcyEL4P6yROPIYd0gYZRRhrxADYm3Q9YAMKK3NGiIKaEm81vIOYagXSAjSPcZIpzNnO7g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ChWORXfsb+I9yN7CAApoI53TtGApVoUNnpSyV7juhoE=;
 b=QBCPuIiBH2qSdBQRPDml3/FR0o7vN7ojbmOFmZYqtA/0RbGFUsBz2eS/zexyJXEa7Qod4X+WqKldW8kDWgnmPxNtiZ6oNu7lek2Ib3GoKV7DsjKgt/6CBcMuJ9uaidS9LIsVXSxhuAM5iBUA1WeyQBUMNdbBwXSy/9mxQbAq7pbdC/ufDy1k2PVqCSMoE+wpnthedmXklT2klngX7I085mo+/fIkQnuXmDbbvgDJ2nmK3jSRg5Amvv3ujpoFnwaE5LzembIwLvgAqcOhQTzFdjlhHzqHgDRydhfsYQfHkCH3B1/SRWWgCET8ZX96zbEtv4wFT0fFygJa55mK+OI0ZA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vivo.com; dmarc=pass action=none header.from=vivo.com;
 dkim=pass header.d=vivo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vivo.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ChWORXfsb+I9yN7CAApoI53TtGApVoUNnpSyV7juhoE=;
 b=pnOKt+WyxPQeOs6vULOqbwCC+dpQvzVZgc13sDy7Ygl6uWtJ+ZHV6A/xSOiOTZATAkwwpv60GWSedIMb/Zfcw4xyBmy0AfqnQ2AJQdt0VjIK1Qe1wj2gVFO/3U6GIgrDXpY3e8keLjFRzAl9toA1lxWM1oDa6RLVjJUeBCu0ZmiXkICFontf5Bf+GrJqScntJ336IGVHuXYE8+0aMHsf/iQwdAEYxJaEjJZisGyzt2oozqBDvMHQSUeYkk0Ha3iUHTuo5CjN5Hbvdh7tnlBVkaZrgXL1fbHXT0klDE9ZKSRk1S+UH135zzthqkVvV30PEpkKBSIWvicGfBt/bvswnw==
Received: from KUZPR06MB8238.apcprd06.prod.outlook.com (2603:1096:d10:56::7)
 by JH0PR06MB7325.apcprd06.prod.outlook.com (2603:1096:990:a1::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.292.21; Fri, 7 Aug
 2026 10:57:36 +0000
Received: from KUZPR06MB8238.apcprd06.prod.outlook.com
 ([fe80::db45:6e04:e787:3d3]) by KUZPR06MB8238.apcprd06.prod.outlook.com
 ([fe80::db45:6e04:e787:3d3%4]) with mapi id 15.21.0292.018; Fri, 7 Aug 2026
 10:57:35 +0000
Message-ID: <47ed45b5-de67-41aa-aa21-a3ba3479a7cc@vivo.com>
Date: Fri, 7 Aug 2026 18:57:32 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 0/2] mm: zsmalloc: make shrinker compaction
 budget-aware
To: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Minchan Kim <minchan@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, xueyuan.chen21@gmail.com
References: <cover.1786003779.git.xueyuan.chen@vivo.com>
 <anVWZVOt-xeD0dMH@google.com>
From: Xueyuan Chen <xueyuan.chen@vivo.com>
In-Reply-To: <anVWZVOt-xeD0dMH@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SI2P153CA0007.APCP153.PROD.OUTLOOK.COM (2603:1096:4:140::8)
 To KUZPR06MB8238.apcprd06.prod.outlook.com (2603:1096:d10:56::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: KUZPR06MB8238:EE_|JH0PR06MB7325:EE_
X-MS-Office365-Filtering-Correlation-Id: 04a76486-099d-4ffe-b980-08def472afca
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|23010399003|376014|1800799024|56012099006|11063799006|10067099003|4143699003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	Gy9LGfIfuRV89PRKlJ15hhLmLU4pouEQDZaGkWJe1axkbcAe1OnETGt3Wgnl2haIL3u4yjsWgygFBuPXqSNiN1UXyMGgNtv4dMtA7UDwIf1rRzIDTGSr0KOrHx/wBNPbIIMEY5xPtmylO1aHaxo26wbS5ZsjU5il75H806egErars9QHZWzywaJeN4x5d9utvcB3rBa+XRMlPlPY+FBt2vq+YWkBuyNBvshgd++0nt/L129trP4RI9FTyJp/AWPGvx3QTT2B+cufBsSvPmVH0FpVyKWy5nztfb568EkVvruSSx+88YmOiKxP4+VRewwXzRhooXb0eQ3ux4CsbU4VzILqiNqoaX5eKsk1v08DQDeYpTXWABujjUPSNKstrZXqMahVZSG1ssiBeqDt1yqGgN+YYvZE+44oNav3ho/lEfgX7DCga8RsHZmj0nqJFJ28tJx5qVtw7bvB/hKkOWCZpoj4rnLbnG3mQf3PzU1PdBtnKI/LMk7SpNVNNH5pEbYwyDv4767MiMBTlF6kFVsC8Z4f5CKjHhGeBJBTXve3fNGlxcWq4klOLntmKDaY2+Q6RqnqtHyred4ojaKoc5c5rkaK532bIWFvaplgC/Y+zp2Nybm9TBrHEb7ImMDaX7UM+xfofvMikZaLDLwjPJ/3+EDkkdT/th6vIur4hy9izgY=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:KUZPR06MB8238.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(23010399003)(376014)(1800799024)(56012099006)(11063799006)(10067099003)(4143699003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?TnR2dFR5bHhsQnA3RVhLQlBUeXdVTlg2WVZ6dUJiYXo5VkVqUWFFam9Zd2FF?=
 =?utf-8?B?dXZwZkQvZmdYZW9haXpTRmUydWNHM2kzdlV5c3NYRUxSdmc1cjVDTkg1NUdw?=
 =?utf-8?B?UUpob3h6bjZzNVZnZmw3bGNMN2t4RjBJa2crSHJqME14VXVIMWF4RmRxMlVa?=
 =?utf-8?B?ZGtNMnVPQ2U0TzEvcDgwcFVIdkdVaGdpZ2htYmVvelJnVW8ydDBEQUV3WXBr?=
 =?utf-8?B?d0pMUS9IdkdpY2RYM0R1bDUzRk84Um5hendFd1paTThhSUNWYTBhQ21yRzda?=
 =?utf-8?B?ekZYUERmUnFsUnliMUxhTFdWWkRzN0ozcnlPU2JZUkRITzNFY0M0c1V5dXFT?=
 =?utf-8?B?YnpybkNZemMrMUZubUFaWGhOamJRT1R3TEpWVndBUUhVdEd1QzhWVXJvK3Bk?=
 =?utf-8?B?Mml6QlFrSTVWMXc2YzJ1VTkzK2E0U2lMdU0rbzV0SWpwOTgydW9yaERVajRo?=
 =?utf-8?B?ZXhRS2lSNXhPdU1WVVF5OCtOUjlpZWZHSVhkT0tid2FEQ2YzRTh4dXZHYllL?=
 =?utf-8?B?Q1hPMnZzVXR3OFpKMVhmMmpTYWJ1NmpoeDVQTmFPakw5ZGdTUjA2NnZhcU1w?=
 =?utf-8?B?SlMzcDNReVZZQ1NOWDgvdExNWWZBOE4yRFpydkY2K1FTRzAzU2ZnM3JHd0hL?=
 =?utf-8?B?eERJSDRLNDE5bm92WjlhbUNwNXEydVBWUzExaDBGbEtRdGNnQ1BaUmVBaDBN?=
 =?utf-8?B?U1lZRTBZcjduWDhmWVBuTmNsUWtyVHZnWnRNeHdBUXR6bUdvVVBFQ1hTbDBZ?=
 =?utf-8?B?QTBEYzlkOTBZcmpPSWE2Z1pMa3RWbUFiSFJ3ZEpuUzZiRlMyazNNSy8yQWxu?=
 =?utf-8?B?czJ0TEozNmhJdEhjTlMrRjg3VktIQlA4UFZJWk0vS1d0cE1UQzVGaWdvUXE5?=
 =?utf-8?B?Zjk4RkVWSkQ2cGFLa3BCajRzWU1Ua3BqT1lvV0JrL1dRZGxqSjJ2ZlIzN1B2?=
 =?utf-8?B?L2NRbHZGOHNPelJEY1hqZ2tGVjV0VFR1a3RST1Nub2l1SU5xaUlpNHBqOXRY?=
 =?utf-8?B?SE5aK0VoOWxRRHhFRVRvSERxbHRjOXVkTDU5Q2VRcXhnWTRXR3ljVGFvUlB0?=
 =?utf-8?B?Q2xabXZMT1BlUnBwenVtZit5U0ZSRERQWDI0NTNMOFY5RStUc3FjS3Z6YUFG?=
 =?utf-8?B?RmVZUEMrK3hLSjhteW5iT3dTVmRkRzRmeGNSMnlFTFVXenhvTXozeUZzcDYy?=
 =?utf-8?B?SXVESkR5ckVHbGNsNzFYQmkvWmJVaVBBTlNZcFJtd1dOazl5SjZVbkdnS3RT?=
 =?utf-8?B?Sm8rbjlJZ3JUUUlVeHhHTmQzR0pldWlLMzJleHVTWlZzWjEyaTRUNzNFYW5I?=
 =?utf-8?B?U0IyRGNOZW1ZMmdGRnpMUkI3RGl3ZjYydXd1Z1FQK2pseVdnajBSQTNIY25P?=
 =?utf-8?B?Q29ZVE45NTltV2RtNTUwSGxSclNTaU44VFBDWElZd051a2QyZm5xMEhCT3R6?=
 =?utf-8?B?WDU3azRZRjBJYXNOTWhSS2pNY1lETEExS0EwM0REbWNIeTVuTzJOVStuc1ZC?=
 =?utf-8?B?Q3BCK0dORlRSVE91SFl4UjNMQng4QjNmMjl0Nk1OV1pjQ2t5TUx5ZjZuamo2?=
 =?utf-8?B?b2xLbmIwcDJGcDJ6b1hhM1ZJdFp2aVQyNUFHMlR1aVoxR2V6anlBTFk4Q21Q?=
 =?utf-8?B?NE5FU0pxL2FzU3lCZm5sNkV5Tzl5aVR1MmFTZVNjVWlzczdMUmkvK1hXZnp1?=
 =?utf-8?B?Zm94TUsrOG81aDFRMk5HY0VBWGkvQ29TNjVOOW5xSVRCSTdpNXhZWjVScUlC?=
 =?utf-8?B?S05lTm9rNHB5TDE0SDZoQjgrYWpQcWRVUXdORWpta1R5dVJhMUYvdVoyYUM3?=
 =?utf-8?B?cEk5WTViNDRzckJZUUN2cGxxQ09sVjRka05nSWFNK2g5MElqNjRTMngxM3Z0?=
 =?utf-8?B?MHd0NFdSWDZ2aDJEd3draDNTV1NtNkNGL2kyKytmb1V1TXAyMFZ5R3NLS1Zt?=
 =?utf-8?B?MEFwM0pzQ1lsWGJvSFB4eWZzNEl5eTZHZ09KTnJMNThFd3NUT2xTRmhiZ2Er?=
 =?utf-8?B?cG1wdzY3dVdvekU5NjkyOFM0eWltSmptaFd4eU1iOGcvaTZvSFprSVJPMnJT?=
 =?utf-8?B?WmlwRGRuNHBjVGYyeGF1eGhSNVdQWjZJUHBPMG9OQURlUzg5bmNQTGhINC80?=
 =?utf-8?B?YW95K3hJYXpEYWwwSTZxT2IvN1RSeU5nc3JNalVBbVdxMUFxNFhmdTFvNDZh?=
 =?utf-8?B?MEdJTkIwRHYxZVdJLzEyY2JsRTgvZ1JvclVpVUpnejQ4U1NLLzhnZHVSeUtU?=
 =?utf-8?B?R0pYdy9wRFYvSzdkVkVZSmFIREZJTnoyYUtYTW5aTG81WFRqVW5CVUV6aTlF?=
 =?utf-8?B?bWdvYUhMMzA0S25BOUdEdmtqYWpBN0NkRUJjbnRDbE5UNFNIYlZqZz09?=
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 04a76486-099d-4ffe-b980-08def472afca
X-MS-Exchange-CrossTenant-AuthSource: KUZPR06MB8238.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Aug 2026 10:57:35.0562
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: d/gJZVfj8979WvwiPKluu17Kd7+HW4Vhvq5hHQmJa9vPBNG/9vhnJTR01Xeg8o1Rk7fV8qSrpFAHgu9ZzvlQkg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: JH0PR06MB7325
X-Rspamd-Queue-Id: B0833100009
X-Stat-Signature: sesjc63kxmzc6fkka9afffcx6ugo58zk
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1786100260-44532
X-HE-Meta: U2FsdGVkX1/jbDfRZ3QpErWHb/xzhPKd/6TnEEUevO2gtpxhs/mVEQbozrYdaKPyI1lhDTpg+tX6Si+YDxKYQrwlMu9YXKgjxGTpkHYnYC+3f3sCQ9zFS7nvHx9WkFHyqbSVqRfH1DzP3oZcijtCcYONIMTtEBwAmF4hHS1OWDFs+9JLWeYLpcmtI2gTjQ1/FBY+/t7T5bwiKRe1VBr0RR7KoPYtuzc5JTXTt4lniGSRKRj3+rt1ReLDsyBdyYPvvjYM8LeT3PeDiHxWUdC4fYNymnLhOARUXGOkEubmHy7Kv7JxVAX7y8/kV3vxyOQU46qZItQGpsJMCKCjFNzriVjcytz/cxNSB+0adlmMmT4e8j76WfObB0ju+korFzjIsRkSt13wvuRw/h2Uli3uYX3tL816pbDaqz8zRnXws5AhXQao3QMgj/9fsVWt5Z/cDyfRFeD3bHLvvHZdTAE1P71VMh9nr/ZJELoNeIHASYu8QYDhibU8dDr8IdQ2+91K4NOgoUVFf0ZlGwhj/ke6Wdn4/IhcqP5WHNgyjGBlmVe2qjNhP9182LCpgoP1Bn1WgHlS1f824+R1oa9m8XgSADbGPKt9c5RpLjKqiq/akaunTAf9MoZiBsn/pmUisab0yLXVPjFXVKwFniAW0cjAH7rbduOd6L12x43U3hrt5ogYdExn7I8T0F9cWcQ95eKfHD3tdZnLegr7Aydah1/5I7IGhYNJNVCKOaIihehBlD5tlkyoU9wsbwcPSATuhVKSb4Rpe5mWWiHSmfE+zOKk+woyJVZGmZIkAo02k2eqeJt1mOqKNVHF42d49k1CJlbWXsMTpVhNwGh7e+0V5WnAHAtyIkGckbG502nuXQLO/HTSS/bqDVTNkSUOHMZagZbLq3OusvU3LYRFQ3yV/jJRb7v6OG5Tl02jauVbcoCwIBFeaThHa1XD7a6surxED/uw9+t8IGbQBJjncE323Uv
 Kbq/+LTt
 sH9y67BCsUjkz5ws+C8fO+RmXJ3hqIw4t3+4q9S2LQdqmaygj/cbwc5M77AXFMALWDH9ZQl5aRxPDi96IJfi8e+W1P+wQFOyj4rDrxVffLsTl2wBMLqBfZ4RZnUTijAwKZ2dbL7s5P4HIvkHRUgkV1XKTNSiaq7loZ+hTTZnZfnvnsTgh825sJV9TRz1aJYJ0h0wUTdavcrYZsNeX1WytxsfphZKFTjozm6RuTjbCxQJEplkE5m9CYleoIkLBiu5qLEVojmfKBN5i3Oah185CC56Jho+H24jvcB2Pvy0n4BsomnzAYBrmFyR41AfP5ptuUQjmdTeu5xtMVLmR0uBCyNlZhqM3IbxbjkMxWAx99r4fx1QWtZ76NI6h8RCqKpLqfdf38F+kRPBHvZ4j/0jEz7XQLw2fzmSaI0fiAzVCyi1YaWXt17TohAYsbpyEMJDd8tNVNiQWa3omf6yRclDJeVZwgNvwdb5lP+J7S/xgJRZw88z/YXdAx9i1BwB4E3rjz22ckCikrfwRreQ67f5c0lEwAQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Sergey,

Here is some additional data:

I used the following definitions:
   compactable ratio = freeable_pages / total_pages
   memory reclaimed  = pages_freed * PAGE_SIZE

freeable_pages is the estimate before compaction, based on the same
calculation as zs_shrinker_count(), while pages_freed is the actual
number of backing pages released.

There were 264 callbacks in the trace:
   callback elapsed time:
     median:    5.77 ms
     p95:      55.82 ms
     maximum: 271.36 ms

   compactable ratio before compaction:
     median:   0.32%
     p95:      2.86%
     maximum:  8.33%

   memory reclaimed per callback:
     median:    3.80 MiB
     p95:      30.45 MiB
     maximum:  92.73 MiB

The longest callback took 271.36 ms. Its compactable ratio was 3.25%,
and it released 7,650 pages, or about 29.88 MiB.

There was also a 241.91 ms callback (with 30 schedule-outs) with a
compactable ratio of 0.44%. It released 1,019 pages, or about
3.98 MiB.

Based on this data, it seems better to remove the shrinker.

Would you prefer that I change v2 to remove the zsmalloc shrinker
callbacks directly?

Thanks,
Xueyuan


On 8/7/2026 11:56 AM, Sergey Senozhatsky wrote:
> On (26/08/06 16:27), xueyuan.chen@vivo.com wrote:
>> On an Android device with 12 GB of RAM, observed zsmalloc compaction
>> durations had a p95 of 38.86 ms and a maximum of 269.68 ms, motivating a
>> per-scan reclaim goal.
> Would it be possible to give a little more data?  What was the
> fragmentation ratio, how much memory was saved during that
> auto-compaction, etc.  If possible.
>
> Somewhere in the back of my mind I was thinking about, maybe,
> disabling (removing) zsmalloc shrinker callbacks, in other words
> disabling auto-compaction.  We have a sysfs knob for pool compaction
> for system that still want to run compaction.  So I'm leaning towards
> removal of shrinker callbacks from zsmalloc.

