Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9CA76CC6B3A
	for <linux-mm@archiver.kernel.org>; Thu, 15 Oct 2026 11:42:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A09D06B009B; Thu, 15 Oct 2026 07:42:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9B31E6B009D; Thu, 15 Oct 2026 07:42:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 87AF96B009E; Thu, 15 Oct 2026 07:42:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 575726B009B
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 07:42:52 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id C82C9140933
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 11:42:51 +0000 (UTC)
X-FDA: 85324673742.15.D0FAAA9
Received: from PA4PR04CU001.outbound.protection.outlook.com (mail-francecentralazon11023093.outbound.protection.outlook.com [40.107.162.93])
	by imf10.hostedemail.com (Postfix) with ESMTP id DB250C0005
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 11:42:48 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=virtuozzo.com header.s=selector2 header.b=UPODPDh6;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf10.hostedemail.com: domain of khorenko@virtuozzo.com designates 40.107.162.93 as permitted sender) smtp.mailfrom=khorenko@virtuozzo.com;
	dmarc=pass (policy=quarantine) header.from=virtuozzo.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792064569;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/T4hyFcGXUMRK8yb0SqCkYfpKnS/MxgxRiSmFAUtN6E=;
	b=XEbZrPGacOIW4+AVVUYAt4Y1mLf5hSeM5CZjFKldaZD7f+s/SV1yPgmrInlzKhazcE08J0
	PkgDoHKonoKCDa+ZC4uGaReWNW41sAEcm6MD+RrjWL3HPFJgTfqBw/agjPBtRaeSuDd9F0
	bq4ydrNSixIUKUqpW73RrNxQPRekXuM=
ARC-Authentication-Results: i=2;
	imf10.hostedemail.com;
	dkim=pass header.d=virtuozzo.com header.s=selector2 header.b=UPODPDh6;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf10.hostedemail.com: domain of khorenko@virtuozzo.com designates 40.107.162.93 as permitted sender) smtp.mailfrom=khorenko@virtuozzo.com;
	dmarc=pass (policy=quarantine) header.from=virtuozzo.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1792064569;
	b=hMPP8k3c6Y6n0haUAIvaGc5708GuN4ccCxu12abg9Yp5U8k8gihAlSqN2LRx5zluiqE7pU
	HtITxv+NBzaVvricR8kKGS/mqAZPPF7bod6Z+eVns18mmuCCTvKGBwhhTaFMMEbicS+DU0
	ain8mrk+MF8xncLPnLe6EDN2GuiVvZQ=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=tTHIFzvBkZhgpBwg3BekgajBKrgzD7K/qb1RRyhrdCTMfoI7dbZ+VIhZkP+uxESiuEQw3uOlESQK6DW3QdQJBft5wntsUpgOqSyeVIdvGpz0lcpdidob3UBPud6ceJQyqOhrbJnYZpg5scfk9OU0G13NLMuc1jdpbE7M9ffbPVR4FnLO9bxzetBAS3wlKtGNiryhWwW788hCcpzreFGGVNMFHb0EKE962HEjcq27BxBmEH9T7WG2aj8UEJFQUTweDn7A6iY6ZYxCEXmrOmVcMkZZOMLp/F5mVdrb4Jw76k/+yZvh1JlMrFFoZUE5KZACn2GfuM3+/1ng/l3Mfo1yuA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/T4hyFcGXUMRK8yb0SqCkYfpKnS/MxgxRiSmFAUtN6E=;
 b=WzIdJa6fSlPEs166kgUXdzLivj8rjBjz0xK/CKk7IIe/P2r23DgO79gzpV2L6eGrzhbxZULc/PwGsDf1I+I7E8KZ7wdQKOeHQtyr4VLU+AJujH9B45v6Ds3LKWnOdqoublWOc/s3HoGEq6gOBVs/F4celLH7uTgXXFWZyMPo/UGbwp4/Xs87NlCfCSS2qDkI+XJnjlXcNvBraQ+fcA/QLwNO2IiAphe86G/6J6UjHebHIduLLG5+L4MH61xGtUUYtkOunMNfK6kqy6L2euMMSQ49Uuo/Ixya9Bh3DyvD0QfK+j/cpPSFV8rTghttls1P098JqKyrka/feuv+LloRug==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=virtuozzo.com; dmarc=pass action=none
 header.from=virtuozzo.com; dkim=pass header.d=virtuozzo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=virtuozzo.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/T4hyFcGXUMRK8yb0SqCkYfpKnS/MxgxRiSmFAUtN6E=;
 b=UPODPDh63zvKx3yCKjn4wSFXfTzdqth0ToXgv0I/RwQmaEGZwXbBABAV7TM8jfxgFgW+L+wG8Z9dOoosCWkob1P7SYtNbWi3LEhbAQCvQBj+ZPSQH652CD/QJdx1reBhlAl3gArORIkWNqH0vcbbYRcAOzTiYwWkPSucGStgprJg6dc9+i2RdL9fspe+txgxCME+WWmE1j4t+nuvwRLsyvGlqxD2aUkFxZtuSg7raLK6O1zJQcu/dID0i3tKerEcVpa81L1M1PAxTj5iifIHjFnbW0/RLv9bApc6I5pkE8F0FyOllY55DvAz9TP1+nt0/KAHbA8c5BTZ2MzxPOzXMA==
Received: from PA6PR08MB10708.eurprd08.prod.outlook.com
 (2603:10a6:102:3c7::20) by AS1PR08MB7659.eurprd08.prod.outlook.com
 (2603:10a6:20b:47a::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.546.7; Thu, 15 Oct
 2026 11:42:43 +0000
Received: from PA6PR08MB10708.eurprd08.prod.outlook.com
 ([fe80::1999:c6db:dc55:494a]) by PA6PR08MB10708.eurprd08.prod.outlook.com
 ([fe80::1999:c6db:dc55:494a%5]) with mapi id 15.21.0546.006; Thu, 15 Oct 2026
 11:42:43 +0000
Message-ID: <84c9e97b-67c0-4c9b-bb7d-81811af8a16b@virtuozzo.com>
Date: Thu, 15 Oct 2026 13:42:41 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 0/2] mm/shrinker: make per-memcg shrinker units cheaper
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Dave Chinner <david@fromorbit.com>, Qi Zheng <qi.zheng@linux.dev>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Muchun Song <muchun.song@linux.dev>, Johannes Weiner <hannes@cmpxchg.org>,
 Michal Hocko <mhocko@kernel.org>, Shakeel Butt <shakeel.butt@linux.dev>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org
References: <20261014-b4-prep-vstor-144715-size-shrinker_info_unit-to-a-power-of-two-v2-0-51af2aedbe6c@virtuozzo.com>
 <20261014135046.7b13252ce99d918ffcdb1f49@linux-foundation.org>
Content-Language: en-US, ru, sr
From: Konstantin Khorenko <khorenko@virtuozzo.com>
In-Reply-To: <20261014135046.7b13252ce99d918ffcdb1f49@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AS4P190CA0024.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:20b:5d0::15) To PA6PR08MB10708.eurprd08.prod.outlook.com
 (2603:10a6:102:3c7::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PA6PR08MB10708:EE_|AS1PR08MB7659:EE_
X-MS-Office365-Filtering-Correlation-Id: a7b7afdb-2fea-4451-2e21-08df2ab16ce5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|376014|7416014|23010399003|22082099003|18002099003|10067099003|4143699003|56012099006;
X-Microsoft-Antispam-Message-Info:
	VsrSJCRwYQ5mLnaBihJvOzz0AdXZj3Z/j3p+V/9+urEZfolibwKa6pjv5dtumAAFGSo2gJusf3kJQKBBSd/9GZ+Nc0OxSIIYBWKz3QDWJ44ipRoRQcj080eMXeN3eLQ1sPDn+Y46A4iThIzjLgNSlCLn/jUY+2t8gkuPXP2l2Awjc3OPbmB1A0/frPhx7O7et/2A4SAK8232jvY0HY8OTqZyQpYGIMVL74YnDVwfUXXyKH5OjbYH7cgWXp1KLd+aliNTh9KlPQ1sYGjuJ9gJIrMJ8IO/qZ1g1NlUtTIY+pK5RhhqMQqujYe7nbj4Gem2HoxLVaZJuE2o2PgasPyo58e7ABHr6BGxu0UzSwvZH0Av8P9SUgRZvfxGg6cmoR4dVZItBJv2oj2jMQnzqJSEX3BPkxz8tHuEttnPxas9yaMCVnI69JUwS6kCzKiD+eEgL2O5BUdKi5FRNp76NFn58bZOhfb7FURVd7mIO3a60UVSZV0OktmAuuz3lToLVgwuOH+a0D5/9ZPK6ZGnGgydCZEWBsYIq1immTq9y0/z2O2qePZW0otOyneLJg17P89J57ikKl5Zf19lXyOQnkf5CugnwkrYcmGOS6pMwCmkqxQam+ztT1HaaouyY6om9JmXZ2P5GAQXbfH7JNbYxb/oPJAxZC2YREa4IxhMIWulpLs=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PA6PR08MB10708.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014)(23010399003)(22082099003)(18002099003)(10067099003)(4143699003)(56012099006);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?SUd1cGZicFhkTVMzNTlkdDhuY3pHU0pXV2lDSzhQbHJsUzV3RFBNWjlMVkRI?=
 =?utf-8?B?RkxGNCtUOGhldUdocTdEeEJPeTgzZ0R2YTNzYmRTcVJUaGxDRmdqcnVxVzJS?=
 =?utf-8?B?amRMNDdLWmF6by9hNE9ocE9ZWWJQY2h3eWh6OVMvVmhFdFhDc3Y0ckRLU1Z5?=
 =?utf-8?B?UkljL2s3N014VGdWVE1LNTRZRFJYcXAxZjBuamlLTXJCZHhQbWRPMkhLY0tz?=
 =?utf-8?B?ajVzVkhvSWFuN1JYN09rNkdhbDFuSk9GQXNYaGQzUGFhNjg3ZmZtQ25HNjBm?=
 =?utf-8?B?bGlNS1JWSG1xRlRYWUljUEN1bUJkNmFJaFE3RThJS2s0Y0wyVHljSmZuRWhH?=
 =?utf-8?B?bWpBeDBhNjZUU1BWNW1qdVZKYkk1bll3cENyVlI2bUVBZU9UWENZYWlYb0dY?=
 =?utf-8?B?MVNRUjhVQ1JDaTBNRld6Q1NoLzJ5Sk12WDVRTjFPb3cvbkR1alQwWGxRQzZQ?=
 =?utf-8?B?WEhrbHFTcWx5eTFGbStWNjhvNjQ3VzFuTUszVWNRMG0wcG5OL2pXVjBTVlBr?=
 =?utf-8?B?djFzTDJIWTFrNVVsb09LWjRBdC96djkxNmJ0ZllOT2FTbjZYYUVTWjFPd0M2?=
 =?utf-8?B?UTluNlVlUVVtMW9icmRiOXpZV1Q0WmlJTEVWaWJuOWxFeXJkVXRaUGZGSTBI?=
 =?utf-8?B?NkRZaWcrSDJGOC92dlg5eHJDR3N2Q09MMWd3cEdoT2djZE9ISkdjNXlaQ0U0?=
 =?utf-8?B?dTM1N3p5b3ZZRGNKNnBWcFdXWFREb25tYTlOZGNobkFRVFJuc2xzaXI1cGwz?=
 =?utf-8?B?bThNU3Arb1dhNGpxL3F2OVYxbXdZVm9PRlprNEpSMXFEN3ZwZGdiZi9YKzIr?=
 =?utf-8?B?L3B0dTUvcGZzL1dCcWJBODg2emp2bFVPSDg2eDRiRXVMbEVrT3g5Y3NQQmI0?=
 =?utf-8?B?WFphKzA1TnZEZnFIdm1QVVEvUG5GZ2ErUkdqT1NTSkIwaUNENmJFOEpveFZ2?=
 =?utf-8?B?ZWxvSGt4R0lSTjBrS2dEdVFrQThNNHQ5WDkzZWpibS9rcW1lcEFQRHRFOEZM?=
 =?utf-8?B?TG10eVlYd3Nhb2crV0NlOCt2ZnY4OFRsbGVQZmV3N2JNaUxwZXQ3TzMzSEF4?=
 =?utf-8?B?ZHJKZ0lnd2xFSHdXYitMQ2tNODQ2d2Nwanplci9rVWc0cDlkNjFubDFmVTN0?=
 =?utf-8?B?b3lTK2JKem53RndFbnJIMS9wMGVBeTJkWnd1YW9LaHpramRvaW83blVGSFYy?=
 =?utf-8?B?dXFvNlhWanM5N3NJZ1ZVd1dyQ0FWbExhYXN1THFISUN4aDlUSXNKYjdpckVq?=
 =?utf-8?B?RXNBVkNieDdMR1czTmFURUZoZVlNSFRpb3RPUXJkcEExQ0tlaFZOSFIwZDEy?=
 =?utf-8?B?ZUpHQzd5L0RJTm9NTHRvR2w5TVI5aVRlZ2diUHVaNE52L3FRWHMvSmZQWlh5?=
 =?utf-8?B?Y2hSaU44WTI2emJQMGl5YTA4TElqRkl2dGhzMXgzZEJYanhtLy9pdjhKanZC?=
 =?utf-8?B?THdvb0YwU1pQSFJoOUIycEZXZm1TdnRyNGJubWVQTURVZm55aXhNOWR3L2Jp?=
 =?utf-8?B?eHRBVFFSU21ka2kzb215dlFsM0RaNkY3S01DR3YzcVZ4YmJMNlJRYXlmMDRs?=
 =?utf-8?B?U09MRExIMkRMZEMrMUpSamlBUnpQZlk2cVdtN0x6VGtsUnAvQS9jVit2eUZW?=
 =?utf-8?B?eXBRcHE3MEtjQXlKVFBGT0xqSmpPdzA4aXNhamtuVTF5ejFIRHNyc3ZqczJp?=
 =?utf-8?B?eGhXbXh1MW82YjZKSjJTQzdvclBGS3ptMXVaQ2hJZWxrQnVoamo0dUZiVXpO?=
 =?utf-8?B?MS9MWE1leVVPNmlqeFF2S3lXV2RoN0huSnVYTit5VEF4c2NUU1QzQnZrRnhO?=
 =?utf-8?B?UGZRM1dhUEVBSFpBbENKdVUrMG5XMFdiZDNKYzhNL0tsNFVVQmVwY1N0cFJ0?=
 =?utf-8?B?d2VSSkFTeU5idnczZktNOHpKcmZvVEFPUTVqQ2V2Q3NPWFhmTmVwRFhMZU9y?=
 =?utf-8?B?em1zTTZDTjBSbGVFYzVTTUpBK0cvMnZGSkJZZlMwVnZNd1pDeVZrSGltUEZi?=
 =?utf-8?B?TUUzRnhiS0xjVXpVZ3RLMTBqb0lOSmN5ekIwTGNEaUJOSWl5TzF5RmlwKzBN?=
 =?utf-8?B?aHVxaDNYenErT050Wm5pUnppK05xTG9WeGpnSmpkb3hXdC9DRmRvdmp5a0ZH?=
 =?utf-8?B?V1FLMGVKNEdXcnBreXg4cUFla1BlcW1ZUDZ5bXNhN1MzQlNQNVJTOHVrRG9T?=
 =?utf-8?B?MCtIMk1BeUxtQjBjNU4zZWV1SUdFZUMrWXhDK25uRnRzRlBWdnI1cmJTUVdU?=
 =?utf-8?B?NjBVQXJQMHpsRFJJVVJtRjVZS1A4cVJlbWxXNlRKd1ZvdFpieFF0cTkzYUlP?=
 =?utf-8?B?N1hFTmNxeHA3NG1RQTBpUXNxa25UN3I3Ri8wM2hhWmZqR1NiSkVDQT09?=
X-OriginatorOrg: virtuozzo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a7b7afdb-2fea-4451-2e21-08df2ab16ce5
X-MS-Exchange-CrossTenant-AuthSource: PA6PR08MB10708.eurprd08.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Oct 2026 11:42:43.6219
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 0bc7f26d-0264-416e-a6fc-8352af79c58f
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: EGRj4cRm3Cok5vl/qOJ/OTofUQdt+1axLmeP4f7LHo6jjbBPi3N9KLGorpxe6oOpyOQLN+TqAYxoow+d0vUpVg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS1PR08MB7659
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: DB250C0005
X-Rspam-User: 
X-Stat-Signature: z4x6h5rw95ocmt8wo46gq3sbnr7tp1ic
X-HE-Tag: 1792064568-619072
X-HE-Meta: U2FsdGVkX18RE/VhQumZONQ29UL3YJITCrLEVRxBuLWC46T7FPWkY7U2z3bWwvsmv5++mm2DbTiqmwJTjLnVyk/zMOUZSlyz6KkTmc1Yir9ycMoRu+SGpbt6rsYvWMS1jc0MDStdodnKGBubZs8RRpZnJrplulhvgCTCJ/YkbE03RpPoo7aCaEj/7msw0uF7C7vO1AWVe6Hk2XAQ94BwFibL+UfW6JR2sxP3fnzSdSmZ0xK0kpW+/jNjm3jUgwNjxJZvK5IKEUHE3OZKvzvTCKyLiz/ggmOzFI/T87MF8CFFZmLfx9adm3eiN+mHGL5O3q4W9/wW+GDsi1JPBNWSUnPpLQ8sAYWdOor/80UzgAsaBH4lVDH2aWHpyeYuGSeJY3uB99iiIDAOoTbFKiiYSIgzntLjkZzqvOpx4gY2j0NcL18elVX8drtq3os3haRIjTKA5/d0/9lLF2ybyt9QTnHc7ipE91bMuBM4wgX19Axhcn7fK/yGvx2PgDIhoUj0os6JECECBqBew/ptt9/FYtQyi2OXbtBn4XwW7SVkByzc2AsDWyQHYf45uGAmByyQvwSy0jswI5ztMdkW9eqhjI++DZ48arzJi93nArS5VGrkcZ8gUdkfvWriatbh7IWCUNPiW2J42dSdko26H1WCntRdFjAifx5jnbrXxgHU7sLIYxf1kdKsd0fCe4TEvRrnFbNm407xqEcATOAldYRUr8QtM+jQP5BMUEjgWDDg1drEX/fpMhzRegB3EKkHb/m1v4du2r8zOzUWlNLfLn/4gRsvSESYA5lPcgXyPNtwLsoKy4hq/Mk07kO3e8y46Zfh2tdgHmp4zYMBsUXOmWuPd/kO/Gy38/5gNTgQed5+NmE5GQY/NZbRSXmudbipKcmrwjJMax65YDyiVsijjCYZaKEUyIDSfdiQcpq+CxtHMMh2VDBvDEej4/ViqgHJiv7YSwS+IMAPLzp/es7UQ8p
 h8a9L/su
 tIWhg/igxkwPyCvgh70AWvRJJ9b7ePT6x2Yw7nuM5mDmVWK1AcBNZOwHfmDNzc5eZqZ95G1Yr/h4XpDTaYWEM+HviIvlxF6TVytKl/bOgoyX4C9jTZ+st33JWrr34CDCncXR9PmAlnTvl6TKAqsoEBoC5oKtdQebVkt+B7XdbEL+MF3GT3nyXNTqL7R6Ac6lx6Kl50CiQsDhT7Qpp45EG6oVOHZKYghW+N48Cp9FMVKuOc5bdYEJVoir2RGpKPkWEMTkikljPRqTYfxxUX+sA9HLZjpKiFcO1vja9HNw+INRKeLOV7fMCVnW+2EQDzLmAJxul1Vm2c05qI5Fst7i2DiDXtsPmmGbbJqt3JNFtbyhyIsfd5yUz7FatdYx7j4WyrzotiJP2XL5XHiXeaVdo39XW2jgV6TTO88VgBuZyQx35QtuyFAFKErIwAJ/opT7R/yGkimWElHDtM+qtb933wzIWVM29/65N7XZtPJgpcQRtUHU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 10/14/26 22:50, Andrew Morton wrote:
> On Wed, 14 Oct 2026 16:54:36 +0200 Konstantin Khorenko <khorenko@virtuozzo.com> wrote:
> 
>> Every memory cgroup allocates, per NUMA node, one shrinker_info_unit
>> per 64 memcg-aware shrinker ids up to shrinker_nr_max, whether or not it
>> ever charges an object to those shrinkers. Every superblock registers
>> such a shrinker, so the cost is
>>
>>   memory cgroups x NUMA nodes x shrinker_nr_max / 64 x 1 KiB
>>
>> because the unit is 520 bytes and comes from kmalloc-1k.
> 
> So we could almost halve this just by using a dedicated kmem_cache?

Yeap, a dedicated cache gets approximately the same cost per shrinker id.
On a 48-CPU box SLUB puts 31 units in an order-2 slab, about 528 bytes each:

                                      ids/unit  bytes/unit  bytes/id
    today, kmalloc-1k                    64        1024        16
    patch 1, kmalloc-512                 63         512       ~8.1
    dedicated cache                      64        ~528       ~8.3
    dedicated cache, HWCACHE_ALIGN       64         576        9

So the two are ~equal on memory, and the choice is about the code.

I went with 63 ids per unit because the unit then simply fills the
kmalloc slot it already comes from.

The price is an odd SHRINKER_UNIT_BITS and roundup() instead of round_up(),
plus the static_assert.

If you prefer the cache, I'm happy to redo patch 1 that way.
Patch 2 does not care about the unit size.

--
Best regards,
Konstantin


