Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E0D9BCDB47F
	for <linux-mm@archiver.kernel.org>; Wed, 24 Jun 2026 11:45:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 81B176B0088; Wed, 24 Jun 2026 07:45:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7F3126B008A; Wed, 24 Jun 2026 07:45:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6E2626B008C; Wed, 24 Jun 2026 07:45:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 40ABE6B0088
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 07:45:28 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id B75401A02E7
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 11:45:27 +0000 (UTC)
X-FDA: 84914625894.20.BDA5574
Received: from MRWPR03CU001.outbound.protection.outlook.com (mail-francesouthazon11021078.outbound.protection.outlook.com [40.107.130.78])
	by imf22.hostedemail.com (Postfix) with ESMTP id BC0D9C000C
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 11:45:24 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=virtuozzo.com header.s=selector2 header.b=ymTENv0v;
	spf=pass (imf22.hostedemail.com: domain of ptikhomirov@virtuozzo.com designates 40.107.130.78 as permitted sender) smtp.mailfrom=ptikhomirov@virtuozzo.com;
	dmarc=pass (policy=quarantine) header.from=virtuozzo.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1782301524;
	b=Eslx1ztmmLkzXgukqHAM5tS8kzGt0e+EfIG6U4C3EcLaA/vIsFgAnR35bWFBynz9cVny9y
	91nlcoJ7D7mCfrp9MSE1ixzKm71bOlGu2Rh4+fsfhXwp+U476v6CWMQTIAThKhkLmGKlM8
	vWq9oyDHPmp9u4Mf9dxjL7jyUkc2HXI=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782301524;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GPECE0WmOEZRyjnvSIc58N/PARLtZnzbEG1CIW7qa5Q=;
	b=nDC0KFhIJzaWUfzikcycQElYu0T9GaGues2/QKesHrpXGbwTOd69izU3sdH9C3Or+8gOLn
	WUVr3vHBFMnNYfNXwjz6KdKfm73Eg2I6KTJClP/4Pysx0v8nFt33NJfv0SVPTdx38k1K68
	cK5DWCZZVYE7S6J8jlCGlB0rfmG0DZE=
ARC-Authentication-Results: i=2;
	imf22.hostedemail.com;
	dkim=pass header.d=virtuozzo.com header.s=selector2 header.b=ymTENv0v;
	spf=pass (imf22.hostedemail.com: domain of ptikhomirov@virtuozzo.com designates 40.107.130.78 as permitted sender) smtp.mailfrom=ptikhomirov@virtuozzo.com;
	dmarc=pass (policy=quarantine) header.from=virtuozzo.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=DUP3CmqBK9u3BXpYCigvGFY/1jcQajLo3FDxv9nNtXaHPF+zS8BuMTqKMH9XfIRKrHkCnhi98ludkSyC8WY24OFFIQwPFm0Dt2DN5WCdTqxtTm4/EkFD9TzTm8FGMkxBLjRGs9NgFI+95MteYBKcrtBwZKHsdPhEqDX7BZdF6bojwSMKsH8t83hY1DTDlMyWgQRagwS44QlXPs8Z3Iho/r98/I9tD88amkF7HgRCckBHlaR/VDcL1dcw1KEky4ZAnOPmxqJZO9HYlAcIOCSFdnIsPFP+tJ4oIa1ljXkvAWVOQ8vY4cEJvpCLMk8+fviCPaMYKs/sStCzzxpHtlJ7QQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GPECE0WmOEZRyjnvSIc58N/PARLtZnzbEG1CIW7qa5Q=;
 b=IFCfg5lhuTgnZJBozv67FUlTLaRa2saMnSu4Ot5QaLJXraUrQJowpOr96zygn3rlMSLjaOvxt/jxVuhem+IFe9gS1I6sC/od0akD24dtbo5Ud8+CJTCbwfw8gK0U3Jy2ZbHH2YHDwfGDyxVBKOP+uupaK431hoLRwRqG5gx8uEAeA30ki4cTeaLZUUxUNV1bpuKLWL/QNZmi68f2tYD51ILmK8P1hatcRxlw0MJ05O2CFB5/e67gzBk4s98mDojMorQgLETeanJ3k4o8KUDzLa3LTthUUk4/Lq+Gx8aaK3PPYO9RLubAx/mWKi5Wt3aFwo08iApNXG0H252aleQ03w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=virtuozzo.com; dmarc=pass action=none
 header.from=virtuozzo.com; dkim=pass header.d=virtuozzo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=virtuozzo.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GPECE0WmOEZRyjnvSIc58N/PARLtZnzbEG1CIW7qa5Q=;
 b=ymTENv0vk3Q9PQgHqi57pw5CExA8ZfH3c3ecpKM1yglIKM5nBb48PNjfRlEblqU98x6U90eScpGfWRdM5V4eaqxz8XcUm/14M/3QouR9jVPVUJwNbNWrFR2tBmMZwIfy1K13sm7EmQ5fjZ9/AN79QPazWdKLYHJfN7mequRVUIsMbt1mpjqU0FndtbHTjHgcfi8faPNK93Yy2bJDEciBrBJmG2oXAyH2rIeTin9Y2h9b92btvp1kVek3XtAlQ9MjkIM+vTiAtb4aOjWCwt2XQFyDiuhEySdmv2xiRFNff8v88uIjLTMzPrjC7TP7edlulX+Tud8c1j5YS30bvXi0vg==
Received: from GV2PR08MB11819.eurprd08.prod.outlook.com
 (2603:10a6:150:301::23) by AS2PR08MB9342.eurprd08.prod.outlook.com
 (2603:10a6:20b:599::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.159.14; Wed, 24 Jun
 2026 11:45:19 +0000
Received: from GV2PR08MB11819.eurprd08.prod.outlook.com
 ([fe80::cf17:c42a:92:b6e3]) by GV2PR08MB11819.eurprd08.prod.outlook.com
 ([fe80::cf17:c42a:92:b6e3%4]) with mapi id 15.21.0159.007; Wed, 24 Jun 2026
 11:45:19 +0000
Message-ID: <c390081b-7b2e-4b83-9bca-5f93eec6a939@virtuozzo.com>
Date: Wed, 24 Jun 2026 13:45:17 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/3] ovl: support cachestat() syscall on overlayfs files
To: Nhat Pham <nphamcs@gmail.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Amir Goldstein <amir73il@gmail.com>,
 Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Johannes Weiner <hannes@cmpxchg.org>, Shuah Khan <shuah@kernel.org>,
 linux-unionfs@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
 linux-kselftest@vger.kernel.org
References: <20260623111533.2285005-1-ptikhomirov@virtuozzo.com>
 <20260623111533.2285005-3-ptikhomirov@virtuozzo.com>
 <CAKEwX=OaKTfNqzwa=djLxZDeBbR1+DKdqDnxdfPfZFKB-K+ECA@mail.gmail.com>
Content-Language: en-US
From: Pavel Tikhomirov <ptikhomirov@virtuozzo.com>
In-Reply-To: <CAKEwX=OaKTfNqzwa=djLxZDeBbR1+DKdqDnxdfPfZFKB-K+ECA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BE1P281CA0346.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:b10:7d::11) To GV2PR08MB11819.eurprd08.prod.outlook.com
 (2603:10a6:150:301::23)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: GV2PR08MB11819:EE_|AS2PR08MB9342:EE_
X-MS-Office365-Filtering-Correlation-Id: 68dd19a5-aedd-4aef-4856-08ded1e6110d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|23010399003|376014|366016|10070799003|7416014|56012099006|22082099003|18002099003|4143699003;
X-Microsoft-Antispam-Message-Info:
	GciMzBxu9LUvGgTmuQA+NSK7eZdRTgqni8RnzZVF9k9zRfZ2CqeFn0Hi8APlzArKLEHMHjZL7jlFWUQvZ34nd+2TY//XyfxknDMMxdbzo4c+7pq3PMK9AOyIcPhGlrQXkfu7TLZsq4tqvr6psJiQwTfbHRnqCcb8iaVf7GldFhoDkdVONzU3W1Kmri9H1wZU1bNqO/BLefbm4nGBFH0JtETpQwAJ7WF8NzhoR0FRmqx3zcTeAEn+5Ta3G+oDG7eJsOJW75TyoYCvCH42DhyjBZpQ/fAZfJf9Ec5oGs8hQIM7jf427RelI23uR+AbU4RB3ZyjPQAkfBxi7QizFDt3ppXI+gt+qgqBscrO8UqKqe9InnRfA9nAZJAMK+jNMZ7Wp4jjVbdaGkkfgmVuPFQi05hYVEZQRDqM/cMq3SBBCq+l0DGmy2CmD2DIFSIds2hLb4eO2nA/7oh7GMbxM7nPx0l7krPUdLDP1mql33zKXfKGaTFgopn50i+zyBAW2naZOQSJHj1pOwTrBmJUFNpNVocrslw/L5HwtVQvcMoTFntAgtzG/DDzTgGlOZ+bUGSGveNMF28x+k8YqwL2NjAYf/zyW+s5OawB7z8XBtCcUQIUnLd2i4hpg4SwBbtqX3ihZru4NsqGTVoqS39Gfw8ZMC/tMNHrYtOSbjEHZ9DoFag=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV2PR08MB11819.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(23010399003)(376014)(366016)(10070799003)(7416014)(56012099006)(22082099003)(18002099003)(4143699003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?ZC9YUmNicUpabzZIbzhCTXVnKzEweXE4cHVITWFVeU5YQTJyaTlzb2FFbmNm?=
 =?utf-8?B?cEtRVmU0NUVNTWVxSm83aUs0empDMnZncmJNM28vQ3BkSHhSQ3NwNy9HL1lz?=
 =?utf-8?B?R2JCbWgyWnB2K3dOR3VEUlR4aFIrc0R1UGhRcHMxMHdsN2FrQlNxSkwydXVs?=
 =?utf-8?B?aHJuQ0ZIMUE3VGYycElhZWNYYkRiQ1lxcjJJWnZxOEZQMTFFMklQT1lvSmRN?=
 =?utf-8?B?eTNNNDZFbFc2NlJIWDAyWmxObE5DNFZCdHArekMxUmYybmp5RnA0bEtSZDl6?=
 =?utf-8?B?REZqZzdZZVhJTGQ3RkV4SEY2Rjh1SVg0SFpRVEZYa2R3b2lwQTVERk53OTIr?=
 =?utf-8?B?Nit3RDFGNlhXMVExejJqSHZoU2RQOGd0K3Y1VkhTUE0rM1BuSFliSldEdkVk?=
 =?utf-8?B?cEk4QTMvZFduRS9wVHpKSU5kbmFuVXFOVXAwTzZ0akxjbEk3Y1plM0IzSUJV?=
 =?utf-8?B?STFJRkxlVi91Z09CMytwZm5EMEJnLzlRNXNjbVZqNGdoVTkxZjhaMnRkb0Fm?=
 =?utf-8?B?czlScHptK3ZsRWRQOFBFTlVqNWs0bklGUU5vQ05nb3huSWJRT1N0cjNJWXlk?=
 =?utf-8?B?YTB5cmVjNDhzZVVzaFR5b2RzYXlkaTgvUlFFcDBoaEdWaWVNNGVZZkVMQ1VQ?=
 =?utf-8?B?aHQ3eUJTNUx3WEtuMXNWWHRTUHRESi95czljMnZZcmJMWC9zVWYyZWlScXhQ?=
 =?utf-8?B?UXNQdHdvc0UrbHUyNndRdnNmSVhVZTR2T1RJVk0rQVVSKzZNaFNiQ2tGcmpv?=
 =?utf-8?B?M2ZvcWpYL001YnpwQnJyOEtGOFhJdFFKVHlxeUhmRktFbVJWT0VvNlJ4YXgz?=
 =?utf-8?B?d1QrYXBYSXUrbjY1Sk5PUEFucXJjc1NrUXZoaG5wWU1IaUhmeUdVbFptRnd0?=
 =?utf-8?B?WFNjYVFtMTRubm1aU3J4WU8xL0pIb3FFbThOMnE3STUzd1FmTDgxbjN5VkJ1?=
 =?utf-8?B?Smw2SzZzMzlYSTY3SndPWHNCVTVXZHl0WDFIMXd6Qk1vRllTMlZhTnY5blRk?=
 =?utf-8?B?d2FYRTFkZExOeVd5SFplK2tvWnpaZFVWSHJHVzV3NDBwRTNtWUNCNFB5bzVu?=
 =?utf-8?B?LzMrS2ZvTnViTjdwc3dMMzJ6Yms5d0J6MUxqOFRWSjgzRFFyMTJvOVcxalBW?=
 =?utf-8?B?dW9qUTEyOUxjYjg2bkhOdlBNZ0phM0RqcW9JTDlFZlJsUVdQcE1pZGorN3lq?=
 =?utf-8?B?UThaR0VWMjRleWZzOCt6Z291QjhiclBBZm5ucnRUckdQVTRyMks4VmFpektm?=
 =?utf-8?B?TjMzMk43TUJnNTNOOVE2V2JVNFR5eUFjTFlWRXBPU1NCRkRTcjV3OTZoS3Rp?=
 =?utf-8?B?VUlOUFV4TWpUWDlZNmE4QTl1YmhZWjBubXhSQUY4cExNcHZOdTlEUHpBUjRx?=
 =?utf-8?B?bnFUUy93bmMwMDF6eFNXY21nZytwVTJEMWY3ZTRpeXlWZVpjd25LZ3VvMXJk?=
 =?utf-8?B?U2J2eFE4b2l3TGhDMWZmN1BkbUVyaE9URkJjbnNLTDZ4aldMVHJXM1ErYUd6?=
 =?utf-8?B?bmZlNU5LT2tTNnZEN3NHdmdOMWxHMERTbGRtWmZKQW5QL2dZK1BETWlCV2x1?=
 =?utf-8?B?b3FLSzJRL0xDL0pPMzB5NHIrb3dZQkVJeFkrbmNGYUMzRTFXaGY0YW41dnJl?=
 =?utf-8?B?QnF5Q3VGd3IzajV2L1I5aUMyLzgyNzVtcGwraU1IekYwUmFrdHpBNCs5RWlw?=
 =?utf-8?B?bWh0anZEOE5WTnNuSk8yVUlLK1BjL0pydWFzZm9zM3FINHBVbE1ZSU5SWjZa?=
 =?utf-8?B?WmJjeFZ2aFJqQVBlQ0lYYzcrWmtKNWxPVzJhUEJTNEZKNFV4WUMvOVEvNFhY?=
 =?utf-8?B?Q2dHQTlnaXdmQ1lIbmtXMCsranJkZEd2S1UzWWVqTXhyRE5TVDVVYk9ITVJI?=
 =?utf-8?B?V2xjM24rb3BsMytOTUV5UDJDSkdqeGxRQ0d5ZS9wM1cvL1pzN3JXUUF6c3No?=
 =?utf-8?B?WlZwS1J0cDdBK1dIeTBHN1BPT0lqVExXQ3BuR1J5VVFKb3lsb3lJMkRlNkth?=
 =?utf-8?B?YjdSM1NjMlNmYTl2RWZCSHllQ0lYVFJ0Sy9IN1ZiTjBpR0JOYW5WRllLQ2ZS?=
 =?utf-8?B?dElud011OWNHb3NNRnhSeExOQlBHNmtoVkNGVVNBeHhjVVFCYlkwQ2d5a2RE?=
 =?utf-8?B?cThTSGdyRzB5QW02WDBCYkt0bUEvQUtXQnhmZi9TRkN0VkhoVWxLNzk5bVJP?=
 =?utf-8?B?M1RaZHJzYmdsT0QrdEVpUlZKTWpVVGU4MGhuVHYrT0hiemUxSUVPMjlqNFly?=
 =?utf-8?B?UjZxOGlVczB0TXBJNVorZ0luUWRvcXM1UTZydUN1Q2dmWXBseFp3dzAwL1F5?=
 =?utf-8?B?RG5Rd2FBWElHWDl5MGtoQ0FiY2gxRWQ0NnFKOCt1a1JseHFVRkpQVm01cTBR?=
 =?utf-8?Q?3uqk7tOLaFauK729ESmpIL0+rWiHFls170O1c/zU2zv7j?=
X-MS-Exchange-AntiSpam-MessageData-1: 6rAcb02anUjL+Xs/7uK7gZ2evsrfC9qgkcA=
X-OriginatorOrg: virtuozzo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 68dd19a5-aedd-4aef-4856-08ded1e6110d
X-MS-Exchange-CrossTenant-AuthSource: GV2PR08MB11819.eurprd08.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jun 2026 11:45:19.3158
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 0bc7f26d-0264-416e-a6fc-8352af79c58f
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /qG+HW/8edF0NToYVVu+7S5584uoFVPa7Omd6TXzdma0bW6zocid/zpvRolSdXoXp7jC8mcd/HQNxDUcfPQ3lKVJp5McOIvttixLbud6evo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS2PR08MB9342
X-Rspam-User: 
X-Stat-Signature: nnzcg8pqd9pa1xygnw7uugmo4cn9eq1z
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: BC0D9C000C
X-HE-Tag: 1782301524-942372
X-HE-Meta: U2FsdGVkX1/UNGfORkIKVQViidL9TqDCwLUnfLaVD7jMXhs6Dt/JhSFwq451goyJI6mHcnSn3Nu9Z3uQHYNOTsjQx4UAip2sJOdFAQnLZCqG82iM8ogcJzI0HKJwQmhBRH463+EBLEOoPSC1vNsBuPggZUNyB/Y5mDLVDf5ShQkznSRSFSoVKZelzd8FmYEHGUYdcTEgqccXrAuZV1kZMs0DGIqCOSCaxvIvoEsdeOt446AV4iLemhMh1yhLM1HLJ0Ynp6zc8WnZYWIN2Htldsk++vV8cDVx209RonuiqPbkDPMpFqgoztmFRPQ5pRKpoeD10jUuBQz0EZ2qs2psaEj/GTLfyk8quZNYuvGS7gbOPPAb1c+rGOuo1pTsXuvnFlvax9tc6U+og3X46pdnFIksxe8ckGu9NyF9I+5debyLWREd1SO4jfalja6STivJIOGN5JBdmTrEWc5wb7GA/X5flDr/DSi+nw0W0jgWihhAWu5/djmJJvvtHJXjMbI7LRgSGKBOP5I2RYRXKh6IML/JDI1QmQ6koq+GUQG9nXfMdI6An4YnTeIfJOEA0HrdPJj+YbkeTyw6/01mWaftU4RyrY6GF6urrwLLDsZ4rVvBB1h6SL55w0likFK16Mh30sRi2njZVlnvKQoKkzwSyArsbYi5w3y5HHxMG23e0jZO/nkGEVspYu5bbtVnWAPcpr/j0DroytibndRbaMZlKZvwt/cW2U7a7JEa6C3Y0bcW6nlEbPygD7RVk5Vuz6EvuKxi5bJzLQtzxq1BPVB5wvg9jvui/AzCKAakYhfWgFceyb8fbg47uBSRQdGx+mucHITaghOf+y2sNtbQA88dGeliSRcWxZtYPe3PnzcGIfMoCJt94b/bS0jpYz6XY4PPM+8q4feLD4vRNHre1Zd8C4dx6aMaSFgRwGs0a4nPartJo9nCOHp1H9LiPzlI9gz/O7bEUQTnGH6ymPyugvp
 MHuvccbl
 nojJIMLKMLFiAQCHXH0Msk+sPkLnc1fmfRR/sIjnQHRHdB6RVeeqswLFuozh4g/GcPI0sgR3cnbuQsHJ/H2w+y7ygdwNg358Ah/nnSvJ9GsxQ/l2XE7S04OQTd79VMhSM7Ng996AL+CUAUgvwA6q46rLOtypvLIXlap4De/nFrSllCmbw/ZcmZCrD/PFD7dQ5ZDy9r2tUzLbQSj0mBbFkiQhhLn9QsN3f0mRw6AHO4elXoJwD8qJxLgYx00r3ti+JIFuupq3kG1ZPMOVRZOxodGXtzXoCyBjXt3ly5lIAREXpkwZLgxb1rszuGCUxw0CZ+a7ZHsRmuQ/yLoOqwyYrQuX/NNeI1UpihpCuSpBAGmIA7PjOAxHlp+ImVysuNjjPAh9gifRQf+Ri06Sm9y1OWw5luoZdefSoUVZ/ZxSIyay0cZdcoiZwF+BRs4THSF9oePn0Hfsy7ZzJXV5l/Rvld+qEpgNVutp0D3533VB+WOhAjkUxRR+aC2STcolLgh0OTfweJg0RvBkD+84=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 6/23/26 19:12, Nhat Pham wrote:
> On Tue, Jun 23, 2026 at 4:15 AM Pavel Tikhomirov
> <ptikhomirov@virtuozzo.com> wrote:
>>
>> Overlayfs forwards data I/O to the real (upper/lower) file, so the page
>> cache lives in the real inode's mapping and cachestat() on an overlay
>> fd returned all zeroes.
>>
>> Implement the ->cachestat() file operation by forwarding to the real
>> file via vfs_cachestat(), the same way ovl_fadvise() forwards
>> for fadvise.
>>
>> Signed-off-by: Pavel Tikhomirov <ptikhomirov@virtuozzo.com>
>> ---
>>  fs/overlayfs/file.c | 18 ++++++++++++++++++
>>  1 file changed, 18 insertions(+)
>>
>> diff --git a/fs/overlayfs/file.c b/fs/overlayfs/file.c
>> index 27cc07738f33b..a7e252a91ea43 100644
>> --- a/fs/overlayfs/file.c
>> +++ b/fs/overlayfs/file.c
>> @@ -518,6 +518,21 @@ static int ovl_fadvise(struct file *file, loff_t offset, loff_t len, int advice)
>>                 return vfs_fadvise(realfile, offset, len, advice);
>>  }
>>
>> +#ifdef CONFIG_CACHESTAT_SYSCALL
>> +static int ovl_cachestat(struct file *file, struct cachestat_range *csr,
>> +                        struct cachestat *cs)
>> +{
>> +       struct file *realfile;
>> +
>> +       realfile = ovl_real_file(file);
>> +       if (IS_ERR(realfile))
>> +               return PTR_ERR(realfile);
> 
> We're propagating the error of ovl_real_file() all the way to
> userspace right? I think we need to handle this.
> 
> For example, we might get -EIO here, which is unexpected and
> undocumented from cachestat's POV.
> 
> Maybe handle it and just return -EBADF or sth like that (with some
> updated documentations, etc.)
> 
> The rest LGTM, but I'll let overlayfs maintainers check the
> overlayfs-specific bits :)

Yeh, we probably can use EBADF here instead of propagating:

Man cachestat(2) says:

  EBADF  Invalid file descriptor.

not really a bad fd here, but probably close enough not to rewrite man.

I'm a bit hesitant though, since in other overlayfs operations we already
propagate, maybe that was by design?

> 
>> +
>> +       with_ovl_creds(file_inode(file)->i_sb)
>> +               return vfs_cachestat(realfile, csr, cs);
>> +}

-- 
Best regards, Pavel Tikhomirov
Senior Software Developer, Virtuozzo.


