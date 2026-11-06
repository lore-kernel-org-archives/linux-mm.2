Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 22BDA6082BF1
	for <linux-mm@archiver.kernel.org>; Fri,  6 Nov 2026 16:32:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=virtuozzo.com header.i=@virtuozzo.com header.a=rsa-sha256 header.s=selector2 header.b=d9z/Fea3
Received: by kanga.kvack.org (Postfix)
	id EB1786B05B3; Fri,  6 Nov 2026 11:32:37 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E62B56B05B4; Fri,  6 Nov 2026 11:32:37 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D2DB36B05B5; Fri,  6 Nov 2026 11:32:37 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A16DC6B05B3
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 11:32:37 -0500 (EST)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 0642E160139
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 16:32:37 +0000 (UTC)
X-FDA: 85405237554.29.D95EC46
Received: from AS8PR04CU009.outbound.protection.outlook.com (mail-westeuropeazon11021111.outbound.protection.outlook.com [52.101.70.111])
	by imf19.hostedemail.com (Postfix) with ESMTP id 015F81A0015
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 16:32:33 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=virtuozzo.com header.s=selector2 header.b="d9z/Fea3";
	spf=pass (imf19.hostedemail.com: domain of khorenko@virtuozzo.com designates 52.101.70.111 as permitted sender) smtp.mailfrom=khorenko@virtuozzo.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=quarantine) header.from=virtuozzo.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793982754;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=biJr2KYTEvPDD87JusUHAvdYHriw47D2bmb+1SNLT4o=;
	b=lMaWqn5nkWOgQ5mWRrBTT+rmPRHhggIyQ1cijMYJsxPGWaS9hSqb9qWFyBuz/eUE/IiQKS
	Dxnq+0eKx1uuUkyyVpXlQYxaxpme35H7inu7cHN1XvC0cm6iHrrDUP2YLPPC5vl+NO/fRd
	xR9On9tlLWen7RinokGEup4u9R/bYA0=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1793982754;
	b=0pd3QVX4UnvdLTBakukf6Mx+LFaquust7LZA1Xec7F9x1nKPJ4+oSP8Bt/8nr4yIgVcwyp
	FE1fM8uGd5YuWvQOzCyFSH2jsp2ptcmOCVxjxsQI10cKb98qVEyaQXWTDMP3ysHjoCxI7c
	NAOMyBzbvivfCsoqgoipzwNsft5iu6s=
ARC-Authentication-Results: i=2;
	imf19.hostedemail.com;
	dkim=pass header.d=virtuozzo.com header.s=selector2 header.b="d9z/Fea3";
	spf=pass (imf19.hostedemail.com: domain of khorenko@virtuozzo.com designates 52.101.70.111 as permitted sender) smtp.mailfrom=khorenko@virtuozzo.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=quarantine) header.from=virtuozzo.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=RmZwVp73adQ2pLk4SnamLJ3+3SViBhtx4UYca/OYNHnFTqyFGlSX3cpkjEVaQF9dvrqcR28wd96gOaHi3gsBYMYSU3hqpDHdr99jHAVlmwuy3TAu/4eu/9fGg/UK/g2sBo5riK1czs3lEGy7gwdn7kOFBD/tJtd+YzIvoGuQi83anIdu/8p0qgQEHIVmn13ZZI2LPFGPAYogle6on9ZilVuHGvTBwhXCKScxxC2FbY8llgxVL2gbB4GswO+BGicdkRd2HYxkbMm9MC6tO8BE1D2D6wzA6W7HKfkgxWOg8eYEVfoC4D8VLNsM7xfJTEsxGc++iTCfOlsbaBbMhAjePA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=biJr2KYTEvPDD87JusUHAvdYHriw47D2bmb+1SNLT4o=;
 b=ENSEltiG9YB91xIXoHe4yi8SkBKwHkucZu9t2AzPS/f1x/YCSCC8hDven9NOHyenr9szwNMhTS6cHZ7heNmBRiyLY+XC9S4FV7B3Svj/ExtYA3laFuDIMcMhqDlEavhCMu9H03m0IZPM5W7d4V15+Sa9WR0IkgHVthYb3+ZDkdPQf526GYUcgv9HKjTwpanviBG+nFG6Gb6+HJvJljnS47lqe6sl59IkPtyxOvIEYJQtpWzcQSY3xw9Bjepf0q2p7bHxToJsW2uQHh7tsYcyo77RsY+wn5ITVCeKOBJ0UV0wGqhYrep2tbd4sAWT7wyzA+t4yVc3/K+Afl83NaCSbQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=virtuozzo.com; dmarc=pass action=none
 header.from=virtuozzo.com; dkim=pass header.d=virtuozzo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=virtuozzo.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=biJr2KYTEvPDD87JusUHAvdYHriw47D2bmb+1SNLT4o=;
 b=d9z/Fea375lzxh8CYdI7S708zCg3qa1t6LXNBx5Fnv1rYyHyY9nrscaAsrzo6WsnJsWeh1AQTsJcqkxT4cpaCnNpQAp0cOZkeXlCOL10eHGv88ayDqBk1n2zvuzFsICFdcwJZB129pDAGkF3HW9ce84JF/YljqAlZ8cN+QyHUiTnq6OzZpOnPJPUFE+D55qu3lsT6u7GdR/yV1x766CVEHaAWisysv9UwvKNQAeNmBJWyzcZZKmrllGh21wjeaoVl+93095EEHhDx5zq1aCmxGvBxxptNVT3Y0iWpuHvxyMKee4WeCm0afKFamYJZ+2bFoOL8xM2CMLkhG0XRQ5eIA==
Received: from AS2PR08MB9075.eurprd08.prod.outlook.com (2603:10a6:20b:5ff::9)
 by VI0PR08MB10920.eurprd08.prod.outlook.com (2603:10a6:800:250::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.592.10; Fri, 6 Nov
 2026 16:32:28 +0000
Received: from AS2PR08MB9075.eurprd08.prod.outlook.com
 ([fe80::3f57:9ced:7a37:1bd8]) by AS2PR08MB9075.eurprd08.prod.outlook.com
 ([fe80::3f57:9ced:7a37:1bd8%4]) with mapi id 15.21.0592.009; Fri, 6 Nov 2026
 16:32:28 +0000
Message-ID: <a514a8d4-b9f1-4741-86f2-4671fad24ab8@virtuozzo.com>
Date: Fri, 6 Nov 2026 17:32:26 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/2] mm/huge_memory: take a reference on a folio PUD
 copied by fork
To: "David Hildenbrand (Arm)" <david@kernel.org>, Zi Yan <ziy@nvidia.com>,
 Andrew Morton <akpm@linux-foundation.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Alistair Popple <apopple@nvidia.com>, Dan Williams <djbw@kernel.org>
Cc: linux-mm@kvack.org, nvdimm@lists.linux.dev,
 linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org,
 stable@vger.kernel.org
References: <20261105-vstor-150143-copy_huge_pud-folio-refcount-v2-0-2828fe5a51ed@virtuozzo.com>
 <20261105-vstor-150143-copy_huge_pud-folio-refcount-v2-1-2828fe5a51ed@virtuozzo.com>
 <DMNK05HCXYUJ.578OO1NG15LZ@nvidia.com>
 <6f035f97-8b55-47ad-bd52-833b86b8ae8f@kernel.org>
Content-Language: en-US, ru, sr
From: Konstantin Khorenko <khorenko@virtuozzo.com>
In-Reply-To: <6f035f97-8b55-47ad-bd52-833b86b8ae8f@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: VIVP296CA0021.AUTP296.PROD.OUTLOOK.COM
 (2603:10a6:800:354::9) To AS2PR08MB9075.eurprd08.prod.outlook.com
 (2603:10a6:20b:5ff::9)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AS2PR08MB9075:EE_|VI0PR08MB10920:EE_
X-MS-Office365-Filtering-Correlation-Id: d98695c6-f239-4d6f-1c57-08df3c238c2a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|23010399003|7416014|366016|1800799024|10067099003|18002099003|22082099003|261028144727099003|261026140227099003|56012099006|261026121527099003|4143699003|261009223027099003|261022105027099003|261022075727099003;
X-Microsoft-Antispam-Message-Info:
	Omy2+eM7JIZx9zaYXJdjF5w0IWhQHUZSRw9q9HRpR8eR75NAbU8+0ne30wGF0olmp3uHWGgW8nOQXuZXWz1evq+iIESk9neSp5qfSjPuSRPaa/HtpxwcR6IRuuCPWuI6Qn5Jywo5t4QfHJWP2G9Z/JeCNEUWmq3FXMXsa8KTVuDTjmBIs5mgHLVtoakxYCalnsPPHJSbwdGups0VREkL9YvhvQYLMYenWAz8ZAEiJZtT5TT/idddeeWNrmmfP1dc/uQVJRujymzgO6xWiPCYNHmykL0LdmX0O7deAX8yzPSGPPvNkeOA9dFBavejh1HLsIFno1mjcgr8fnawYf0sSlBD1ZEtvWKc0dskysWXEC3EsAkyyAHLx+MYo1wdu/tjONkbTVZY0egwz3+uiFVs+derQgJgGrYyahh4SeIMFzi1DCHTvDhK4RYnk4PllnkYd3xDZKnXY5QRlm+QZ3xiGzhffbAz65/8Jk2ECxuGxL9f+xdJozRbtxA5dKiFAeF2veDSbzx4w17qY7j6sE02/hv37y7I43uvj3X9ny7NK96Eagos7p95R4AIrJtKBsRxASivj1gDi5No/WTukgTUqBUwe9C0stWG4oIrcCxujdRyE/KI0NG/X1mF3Uw82huo
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AS2PR08MB9075.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(23010399003)(7416014)(366016)(1800799024)(10067099003)(18002099003)(22082099003)(261028144727099003)(261026140227099003)(56012099006)(261026121527099003)(4143699003)(261009223027099003)(261022105027099003)(261022075727099003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?c0VoNkFqSDdUaGZsaUtvaFowdjlDeW5uMmtOb2gxWHNYRCtWckppeVBnamZL?=
 =?utf-8?B?TU5WcDE2M3pGcEZHb0RhRXRjTzZBdE9VN0U5NE9GOEg2NEp4YzFXRjA1VGZT?=
 =?utf-8?B?alg1T1JTTjZDc2xkaWxOaU5PUmVjWVkrS3l4dTc0RFJKSnErZmVHem0vRmlW?=
 =?utf-8?B?T2xOd2dEZk0yb3VwZ0JmWVprOXBnZklzb1R5QVRuOUJhcHhvaE9URTF4RUd0?=
 =?utf-8?B?MjVOYUd5bUpaQWJocmdZREorKzJRSFpqTjhiWFVRMUdmaDdpVDU4UkxvSUE5?=
 =?utf-8?B?WENIaWQ0dW5XcHBWOWQvVUIxMmJCbUdGVW42L3ZJYlk1dG0xNit3cUJ3NnJI?=
 =?utf-8?B?RjVDQlFHdWJ4NTd0U2g5MUUrZFAwZDJDMmJtY2cxRWlJSjgxZElBV0Y2TjJI?=
 =?utf-8?B?enFjaXhDSWFNbEtqV2F2WjhGSlVzSTBTazFHYmV3RHBodldhRHJiRkJWUWl5?=
 =?utf-8?B?WHFDWmVYbzcvWHpQSG5KZlRFTmFRVk9STVNiUFdWcWx5bFl3R1BPMEM0STBt?=
 =?utf-8?B?amZtVHhTK2JMWThZdC81c29vcUZlUDFvU2s0bWtEcEcvOHBuaVFURk85cTZX?=
 =?utf-8?B?Y3UxUzN3MEUwT3lmVUxGa29ydmJPL0NYREFaYjJjMUJKVVNMNzloeXNnNHlw?=
 =?utf-8?B?WmpFNFhyRnNEZFgxRW00UVJsdlVZaG51MEt1RHFlM0dyY2xucFI3anJyejdp?=
 =?utf-8?B?bzRRamt0RDdFdHdTSHBIcFVhQlV3amR0djZMaGJQeUErbmFMK2owYmVsQWJU?=
 =?utf-8?B?clVFV0VpTVZrdERONFhRWHBselNwVEhpK2Yrb0VkR24wczhkTjhhdXRoMkJ5?=
 =?utf-8?B?RzBxOWRneE5ERlloSmVLa3JEYzdXYkpNWEllM2FYblo2VnJzbWhHRVQ2WDA3?=
 =?utf-8?B?UGd3ZDd6VGgraUFLdDV6V0hpQVROTnVhWjBTaVhZNjlablZUR1hQdGtJcW9Q?=
 =?utf-8?B?SEFWaW51RWpuL0ZNRldqOUZJekl0eFFFMitmbUUxaXlncEpEaW95bXplZXcy?=
 =?utf-8?B?R3JXUlU1Q2czY2xlTnlmTDRiSXVNSHdCWTNmclNSSXpwZHp4R0t0RFdwbTN5?=
 =?utf-8?B?VzA4bXpRTnFBc0RiclZhZVZOeDZsWEpGelVmenJKNmZsNGp3aFgrZ2JQQUo4?=
 =?utf-8?B?cTNRVTNsNlhlVitaSW1ramJFNWhka2JCSnFxby81NW1YMTIrNnVtbjZQOElR?=
 =?utf-8?B?U0dzbEovcVlZRk14N1p4aFhHNGU4WUs1UWFzUmtHVDlNemN5TWRPWkIzVmkw?=
 =?utf-8?B?Z3JHQU50Z2ZoM3ovMWQzZ21rSVcyT3daVStoNjdTN3h6alRCdlpKbCs5S2lS?=
 =?utf-8?B?SThOd082WUNKcGRWTTcrMDMvbERjMkdZb1J6S1FaZkpHUW9pQnUrcWQ2b0NI?=
 =?utf-8?B?R3VtV2ROT0xEZDhuRDMwcWtESDR4RWVyMjBhZ09LcDdRaW5QelRndzdWdUJQ?=
 =?utf-8?B?bDJwdW5wZDVvbUtaMGJkbWNnQ3BkQWJtdjQrSEsyQXJud0ZFSkFJRUpwS0FD?=
 =?utf-8?B?Y3lqN0IvNlBPREw4a2Q3a2svQ3RaZjlRRHRaVXA0RFQ0RHdBUXh0TWxBMEh2?=
 =?utf-8?B?eUM1aXpaN3RLNHlDY2d0UmUzeTdlY1crSVlUdnhsRmhFUlFIWEFkR1p4YlQ0?=
 =?utf-8?B?c0tqVEhnWmg5Uzc0S2czbStJZGRSV0RPSkFjY1FPbmNFeU1WQkRYZnR2d0tx?=
 =?utf-8?B?ZHRtRzZrSWZqNC8xaVZXcnpmQU5tZlJwTVMxSVE2VmU0aW5ndzBPMlErTnli?=
 =?utf-8?B?OXY4UzMyOG9jbXQvN3pYVHE5Vkw0UzcrY2VHOXlQYUMyUlI1ekpSTDUyOGNW?=
 =?utf-8?B?MVE1YXllRlhCcU1nYWVXZlVGVXJRS3RHMXZrSmRPRVJsdUQzUTlyK3F1dzF3?=
 =?utf-8?B?ZmRqbzBRUXJBQTJ5bGtheEN0OURacnBHRnJLT1ZKQUhWNEFlM1Fmek10QWZ4?=
 =?utf-8?B?N1NybjVDTFJpTlRmNzlQT3UxTVhoTEdhSXpYTEhiV2tDQXkxVnduYmNiSkxy?=
 =?utf-8?B?UGtSbHRyV1oybEI3dW0vU3VzZFBMR1VrVktkbHJPQ2xNNGZESUZYS25pWnls?=
 =?utf-8?B?TEdQaEZuR0N4WWp6dXRJS2Z2dDZwaW5pclY4VGgvcFdPV3EwSjFXWllqMmxQ?=
 =?utf-8?B?VVZZclB4Y2JyaEhtQUJVMzJVZ2NwMzRMZldvVWcwWHFaN0RrVjFReWV5Zlo0?=
 =?utf-8?B?UWxRS3lJbzUzeVA2T3dlQzRDV1p5cVlwa3czUGprczlUSW5NeEJUZnhyQXQ4?=
 =?utf-8?B?N24wSWE1RXNtbEZqQ0dQMVdSWFBDWWVoNFcvMVdJQ0pNMGNiRnoxcVg4NFk3?=
 =?utf-8?B?VWN5RjhkN05GZ295MG9KQ2czN3dwdi9ZODVXdTFkK3lnK1JxYTBwQT09?=
X-OriginatorOrg: virtuozzo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d98695c6-f239-4d6f-1c57-08df3c238c2a
X-MS-Exchange-CrossTenant-AuthSource: AS2PR08MB9075.eurprd08.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Nov 2026 16:32:28.3912
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 0bc7f26d-0264-416e-a6fc-8352af79c58f
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Bl2YdeEE55sXp6NpRV1gV+c9fEYS9O9bIv21eGeXRJwkt7ZWz2eNXy5VARxIh3C1oTGQg3yADB1Pqa7IP/C7oA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI0PR08MB10920
X-Stat-Signature: ytkx9mwfkiusre553fjpiqpxbcijboty
X-Rspamd-Queue-Id: 015F81A0015
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=4.0.1
X-HE-Tag: 1793982753-253096
X-HE-Meta: U2FsdGVkX1/eiGKiv55nGewxI5AHUFCcK2vWVU7dTeDIzSmtW+f/swmSx5hTfVUNQdGirxoZ74T2a/UhmdU2f0e6EzMwMieKJdgg7V02e3xhQQupUo5QNSGttx/y//cw8eu5oJldPGqzZ+0KVBF/nPQ8dltN+h5Z87ZExu+nmUNFVwx/TCg0kAkO9/RntbpBMArxI/aPx5oPz5gNxWA0Ud2s35wm6QH6BW3ADjgCWaZTrchVEaDGQKRPraJUq4Qc293hkqYBhqZ5PhCuxmos08vOkWV6WZF6M8r3PiWoEw2ev4s7NsBNtb9JfDBp+WAbTgrg9ynsR/nis6nPbrWJc9H2KUMHN0IIC2MPU8AGThl1S0FNWR0VhomZNb/gs/K8l6vEdbiBWY5lyoldtLvR4/uXI3xKr5CywRk2T4lCqP5ginaLA1Xj101Nv4D/hlqOkisRPBrblX4nmObGLpJbUMG/IXQ62LaRYIrgjMnw4D+GpHpN2NdF2io4DaTfdU7s6MKMdaIodriVKURB3SivIJ2ffM2ptmoCWbjFAN8958yvjdr3l5xbB79/UrzKBPI0Vod2PC+yYhh9tjxV8y7O3KCKS7TrwXmHCq+QL2y2G5TEce9Bgh9tFUA/tRlxE7Yv8gQPQnkOVdRfwJmJ/pcZEqZqj/NGG920HtHRCz9phLWOGNmVdaV0GUPj1FAPvIxb3txrYUxQ0DyS+JZlSoMqjHtUX6J1Z3FZjjRbn3G29ho09kRMcHER/Qn/cfAyqj8+ngBeqAYiHUP27w97Off3zDcd0v7LLeipXVZBq6P+sm6I53qg488lyLk2G6QTe8gJYYGe3/xOsY9qPwvEuznc+ynMMS0Wrqfh0n7uHtFta/co0ByimZwqqDLjvm4hJQemp8ZSlTgnBJdYSojFjzz3oQryPJDggmwrW4bo15SE+4+xF7j0CilIDC63TCWsaAGokHdE/HU9F4sTErEx9+e
 F38amST+
 tU5RDz+aTTZb/X5T+B5xs8Tvw5REqXw3PRcpt9kvuADyMYFkNAA0ryAFE+CMUR85nvS+CW21ztC5XmI2HVyZQHwMx/olf1+9/ZOPHGjOaB3mw0ce2abROJM+RBD7OGfDCBZAFm1yEGYPUCjfLScwZFluWsmoAHX3b5OXUrlmqkM7NiVyNbfdSHehoKPD4DBtVJGeJCObEd+EE+gssXB4HLde1gMsxZ03HZ+FdjVE8rRa3cTNmiKOewI1cfOA3T3VIF290f6gY6Kdjr9tDpz0QcbGQBf1R1/CH9jJixfmeLEb2BzEtTtbcvdzkeK2C/3FopGsJSauIa6ph4+nk4g+cyWCV/k3s40unj8a5KgNfoxc8M85LARqKyR+bZgS5kcCA3ZTb4Gg/47e+7Lev/PuntF2WeNe8pZMAZUzGfJUUlUrz/etuStU6Lsx2AKOSIacGjRjBijpEjdZrKdBwL+XP/FEQwSLwnJDAAfT5QW9R68DpsSfdu+ZSqbdQiQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/5/26 21:31, David Hildenbrand (Arm) wrote:
> On 11/5/26 21:19, Zi Yan wrote:
...
>> I assume this supersedes David's version[1], which uses
>> folio_add_file_rmap_pud().
>>
>> [1] https://lore.kernel.org/all/20261031-fixes_core-v3-11-d6437171ecc3@kernel.org/
> 
> Ugh, I thought I dropped it to wait for this one here. But turns out the flood
> of patches confused me :( (hoping I didn't drop another one by mistake)
> 
> It's already part of the fixes PULL request:
> 
> https://lore.kernel.org/linux-mm/20261105084704.5703-1-david@kernel.org/
> 
> Konstantin, sorry! Can you send a follow up to introduce+use the dup variant?

No problem, will do the follow-up on top of thp-7.5.misc in the mm/core tree.

-- 
Cheers,
Konstantin.

