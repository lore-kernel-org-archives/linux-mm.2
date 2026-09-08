Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 01981C79F9E
	for <linux-mm@archiver.kernel.org>; Tue,  8 Sep 2026 15:21:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 077E06B008A; Tue,  8 Sep 2026 11:21:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 04E236B0093; Tue,  8 Sep 2026 11:21:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E803D6B0095; Tue,  8 Sep 2026 11:21:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id BAFD96B008A
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 11:21:36 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 52BAF1206F8
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 15:21:36 +0000 (UTC)
X-FDA: 85190959392.20.7328083
Received: from CH1PR05CU001.outbound.protection.outlook.com (mail-northcentralusazon11010038.outbound.protection.outlook.com [52.101.193.38])
	by imf05.hostedemail.com (Postfix) with ESMTP id 77794100003
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 15:21:33 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=IDc4Ur1Y;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf05.hostedemail.com: domain of ziy@nvidia.com designates 52.101.193.38 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788880893;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=v5uEs50dZsKaS2dMR1DDsG70H6gOu3pUXYnjjV0Sw+A=;
	b=qlfq95BPPf7HBFg/wqqeXesLCo2dr0jIqRDI7RZz0ZFgVO9CcOBHP/aiR9p3lwwomj/bnl
	lfCdMmDpib4p8gHgQ9CYA0zjJ4apNzJ4Jfztjc77sumlltZnRX51MpBhzyvbtWrtUyJTlP
	wzUqEYutqAHlj5xGod2oBn3NwA/a/Gc=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1788880893;
	b=SZdJKXTgFZqVBRebpxEKuXvbCVNKiyJkUyRp6D7yM7C/DI0N3muH0MuRrlrplwX2SFF/hc
	Hl/TM2ZqQZ1eZYyfk3VstnOhGyWL3jRGNP1PHAUHXr/wGiJx1MLC+5J8ZEGSifLklH4gX2
	h2r+8H/lTrZZYBEiwVbXcQVIIaSeah4=
ARC-Authentication-Results: i=2;
	imf05.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=IDc4Ur1Y;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf05.hostedemail.com: domain of ziy@nvidia.com designates 52.101.193.38 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=uerbU69Sez6PqCST1MB6SUswa6LpnfJSAbPgQ3uiPchM96kgp1VClW7k2y6YeHlQMHiX8WTCiV92gzIoWOnU6tIh986bX+BV00eLjR7Kxqrbua9J813dRXvUImtu3RsiBZyuj7v0Z4E5gpWrEMQ0ZHOP5wBra3jAauA9/fXdvVg6omEUs7UWCoh+H8QiYh9X9SL+kwtvDgubB2XoGcMyiFDetrweTcbL8gfT35VsgMw6HNEp0lU0ZFnLZVpl1ZHZJRV4SShtcTV/EcNNMRZGlDJEUZrQE00Bg66xsgN+Hlc5Vt5jVOtNRqBXh/uuQNarJwPg9atyYoKh/LO/JxbGmQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=v5uEs50dZsKaS2dMR1DDsG70H6gOu3pUXYnjjV0Sw+A=;
 b=aysw3UqzoN+tXThgW9Z8YK7gX95S1k60C0MvJ4n6leeZP5AH8Ey0HpSxxPZ9fbtU+PGFvIy5KsybobYyztoEjtes1uY7Q/PTjt0Q7p6QSwRpyrJkyri50XzaIM5eilQUMhXisHKqdlLqYdY+i5JxyglET3GGNv6T+GVlpA6JW0ADE/lR6AcBmJ5OltOHs8VaVTDjjZfwnMH+1176wUzod6HxitAOCPByQQOoN+IUnOM1RIbiFB6X6Quu1wjX1bBY6MNkfXxwwqWqP00S0eYR6PrbinuzQsi4YIJVymjctsR9zdfgSm8u5NKzvyxxAPd3BaREKccQ8Oerwpr8ftzXyg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=v5uEs50dZsKaS2dMR1DDsG70H6gOu3pUXYnjjV0Sw+A=;
 b=IDc4Ur1Yc/3W52A8jKlIxRJQYetMGiNXnm41YkdqnG+7Bhw7Eem5gnj4tBEEXK6pTOXAgtv8eWvgaMMxCqe3RUVJufOc7MeDEqC65UEuT9xwJ8h/r6DehSvhZxwGg3gYgO/uMsPr6jBDHptrVh0QGOl4oPLZK2fcSPf3iYq6spHEJvvOXDNk1aJY21z9oWAMGeTyFNZdvquf7UHH8RF3mvdcDwNY/0KUaVkn9P7m+oXBUocSJ8KgpPcRVSgVejDWjk8RxsOkt6octRL8/7mGSl31SOH+NGP3vJcianvrORwHhhwSAL/acuJa45CdmtAUIln7qFKfVioI5ZuU6sqROQ==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by DS0PR12MB8786.namprd12.prod.outlook.com (2603:10b6:8:149::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.382.14; Tue, 8 Sep
 2026 15:21:24 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%5]) with mapi id 15.21.0406.005; Tue, 8 Sep 2026
 15:21:24 +0000
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Tue, 08 Sep 2026 11:21:21 -0400
Message-Id: <DLA1CJU4WHQE.3Q2C0RE1IW97Y@nvidia.com>
Cc: <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>, "Minchan Kim"
 <minchan@kernel.org>, "Sergey Senozhatsky" <senozhatsky@chromium.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>, "Matthew Wilcox (Oracle)"
 <willy@infradead.org>, "Andrew Morton" <akpm@linux-foundation.org>, "Muchun
 Song" <muchun.song@linux.dev>, "Lorenzo Stoakes" <ljs@kernel.org>, "Liam R.
 Howlett" <liam@infradead.org>, "Vlastimil Babka" <vbabka@kernel.org>, "Mike
 Rapoport" <rppt@kernel.org>, "Suren Baghdasaryan" <surenb@google.com>,
 "Michal Hocko" <mhocko@suse.com>, "Baolin Wang"
 <baolin.wang@linux.alibaba.com>, "Nico Pache" <nico.pache@linux.dev>, "Ryan
 Roberts" <ryan.roberts@arm.com>, "Dev Jain" <dev.jain@arm.com>, "Barry
 Song" <baohua@kernel.org>, "Lance Yang" <lance.yang@linux.dev>, "Usama
 Arif" <usama.arif@linux.dev>, "Gregory Price" <gourry@gourry.net>, "Ying
 Huang" <ying.huang@linux.alibaba.com>, "Alistair Popple"
 <apopple@nvidia.com>, "Johannes Weiner" <hannes@cmpxchg.org>, "Qi Zheng"
 <qi.zheng@linux.dev>, "Shakeel Butt" <shakeel.butt@linux.dev>, "Kairui
 Song" <kasong@tencent.com>
From: "Zi Yan" <ziy@nvidia.com>
Subject: Re: [PATCH v3 01/14] mm/zsmalloc: replace PG_private with pointer
 comparison
X-Mailer: aerc 0.22.0
References: <20260907-remove-pg_private-v3-0-6ae22f9d9272@nvidia.com>
 <20260907-remove-pg_private-v3-1-6ae22f9d9272@nvidia.com>
 <60fe39c2-d92f-4bd0-be33-04d702f8f753@kernel.org>
In-Reply-To: <60fe39c2-d92f-4bd0-be33-04d702f8f753@kernel.org>
X-ClientProxiedBy: YQBPR0101CA0303.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:6d::14) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|DS0PR12MB8786:EE_
X-MS-Office365-Filtering-Correlation-Id: c9bb39e1-2503-472a-7751-08df0dbcd809
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|7416014|366016|1800799024|376014|10067099003|22082099003|18002099003|11063799006|56012099006|4143699003|921020;
X-Microsoft-Antispam-Message-Info:
	a4QmlGpzmUI6j/+3i5buErYvr4+JkGUQEeIqIPH/3w945/242MXKHk3pI9tGZyXKfNGO4wBGHhmOru7S2hzfKbv7VxPYaMMhXarb9OmMXTGCkhWBHGd8ERYkJ60Z1sBHzjfHujB/l5lcjQr0t43mZ7VgWbk4EHRw+ewLPNbIro21l9vnX/xTw1u5uMelhSCikPHA2v0iW7vsXFiXdusANcxSb8IaInnOGNCS/hYxjv/xyozyBUUzuTvSs6TZHi2vq1mjXNamA9pQ4eJUiJiv5mydZxyxwNEexNf72CbbopVyazmoOvKIWIUjtmea0l43a8Ub/G4b/uVhnGg0EhM6r/ui2duucf/5y1gA3z9wP78ZIUAfS1RI5R629MqCW7a5dM64w4xPRWy//v62kUKip+FcytSqCwtYDGy5wxfPY80L0+9fnE0op6h0XUTKzylqYS5+oqvuFjnOyVIq9XxG5YoRNRYAlHZIVE/jjgBTV77UiXOtWLQDE1cDJk/tJmvz9R3U3Hl9M0vktZrsRDoE+33SID6peo4dH9WF4rLL9v9pF7n2lV12mtK4ViMOj20IbXiyUZs22epvmfrYS/8bfjpBOeLT6/PdiBj6VqhmWWnykP5g0T5zv0lM0wTVVV6jJlIMVPCS07CSkoX4VVwYnUXmg0+MaYEjjPZZSDbiCfh66NzBQixrUHDawSzLFMU8zAIVFZama+skwEa00risMw==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(7416014)(366016)(1800799024)(376014)(10067099003)(22082099003)(18002099003)(11063799006)(56012099006)(4143699003)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?YlZtbFdXS0FybGFVZnhJc2NMTVNFQ1gwbFA5cWNub2tLZFlraHNyTkhySnIv?=
 =?utf-8?B?cFlqV05TTDltcElWYzBwUkFIV1lCTmNiTHJaeGlxekovdXBJdnNFMUxFVVQz?=
 =?utf-8?B?ejYvRm5hNTB2WnlBUVhzZkZRSndQRXNmL1RSTHBRU2QwVk1KNnNuVjJtTWJj?=
 =?utf-8?B?WkU3ZTF0MkQ0dkNFdHBXRzBGZkpWeU9waHNyN3hqZW9BTTQ2aDJnbmZkTUpw?=
 =?utf-8?B?d205VW85WWdxK3dqNzYxYjVBbXJweW1LR2pzTk5STVJOME1MaFlEaEVVcCth?=
 =?utf-8?B?eWRkQWtZMjVCeU5va3dvdWJhQmo4RjloU3BjMXdoMjFuV09iSERGejE4Y05B?=
 =?utf-8?B?SldDN0gwdXdxK3U4b2xoRlpmWHJuL3JVL1c4aWpVQTV5RGpOajJOb2Q5SERZ?=
 =?utf-8?B?LzdocUhLQU9NbWNNbTAzMlBXTG9Ra1d4MWlFZzI4TzBhbFl1WFJEdW5pc0pY?=
 =?utf-8?B?ZDVHUFFTangwaVFBbEFjMUxUYzgrTGxoOGVaUjEwdDY2T2kxRTF3TFd0NG9P?=
 =?utf-8?B?aG9BR1pZYmdDRUptMWkxSVlEMFh1MlRFU0ZKS2ZJc3B3ZThxZDArajFJWFhC?=
 =?utf-8?B?ZzVyNnpNMHVlYkhzZmVpNmJIZDhIRDNaQks4V3FhUzYyUGIzTE9tc08wQ2tx?=
 =?utf-8?B?ZUlwd1NMa3BBaVRzaUxXZjh4T21rWGdJMUY1SjJwT2FRTWU1ZG1QbXplYWUw?=
 =?utf-8?B?M0ZCZmd3OGNqTU90Uk5rcTZLS0I0dmxzN1J0eTloaU1TNVZkUnB6K3FSOWNL?=
 =?utf-8?B?ODJUempCbG5xeHhoeWhtZXI2dk81NlRjclhxWjdXUk1GNjVRVlNyaWNTM1ZO?=
 =?utf-8?B?TWpTZjJ2TGM5akQrZEhCc3RXc3UxVEJQOU82bG5jRVdDUDNUaThuckl1Qm0x?=
 =?utf-8?B?OUdqRGJ4R2RCVFhQQ0V6OHdVWTRwT1Jmbm4xMm1MaWlDYUZCOU9JSjVyVUps?=
 =?utf-8?B?enJDS3l0ZVNlOEFWRStUOWFicEpjUEFsczUrNjJ3ZWh1SVZwVlhwejhYNGFz?=
 =?utf-8?B?VzVENDNlUFM1bnNEWmtDdytzUHJrQ3R6SXNhYlhJaW9nU2V3RkxkeWx6S0hu?=
 =?utf-8?B?Yk1UOGk5WkJoZmRVL0xtcUNiRVNJUXpOQUkyY2xUVVFkWEdxQVFlbGoxdjhP?=
 =?utf-8?B?UVpiY0JvQmdHbXBBZzRENkg1RFo0RGJiM3lzZGw5QTgyUXdoNU5iclgvUUo2?=
 =?utf-8?B?akx5anRTelhJYUowRkQyeGJHRE0vYitIOE9memFUUFdsT0N0bTMvZENieFl6?=
 =?utf-8?B?RFJ4dUFVNlNVZDByVXRycS9TaTdScUpJWU1ncWRwa3pwRnF2dWV1TlJISkll?=
 =?utf-8?B?RXJNVHVxKzEvYUZGTGE0TjM0a2dCMHhnRm9TR2JGeEMrcXRsY1lEQmgreFJi?=
 =?utf-8?B?TXNoM3lDb1MrdzJETVdab2xsdy9kSnVhcnRLcEJGODB3MFlIbjFPTWo2Q0Rq?=
 =?utf-8?B?UDlucXo2S2d5b0NiOHpHWHRJZHBRM1M1QW94eWtLOE56T2JGTDg5d0IwYVlM?=
 =?utf-8?B?cDBDTW04MXYzVFRJanJoMnJnYy9rWjBVKzRqMnF2dkVGUk1GVlVCWnlMa2hU?=
 =?utf-8?B?bHdDWjliRDNTVmdybkZvR3BxMVNNSGhqazMxSkpiaTAwRGttMDFudzFGOTE1?=
 =?utf-8?B?Q1dOWlJsQ29IajhTKzUrN1daYVorQyttWVRtWlFSOXIzQVBOY1N3U1Y3dVBJ?=
 =?utf-8?B?SkJpNVRSbUw0L1Z5Sk41d1haNWs1WUlRN042WGN5dzBtVUlQV2dZeU5YaXkv?=
 =?utf-8?B?S0w1U0JkWnk5NkRlM3hSVHJ3K0drR1ZXQ1J0UXFVczhTVGhDM2tCWUVMWEdP?=
 =?utf-8?B?bWhNQlhaeDg0dHk2eVBUeDAxNzZxQkE4akFJMVFsd2pER1VxYzh6ZGNYdlQ0?=
 =?utf-8?B?ekVkM0hObnV6ai9DWUtMak9rcHZUTDdDRFp1QnBJY1NQQjJiZHpsVWdzV3ln?=
 =?utf-8?B?SlZtUFhaZU04Q21oT3IrN1lrMmp5TEd5Sk1MZVZNelp6ckR3QTRqM015TmxT?=
 =?utf-8?B?VHdUUEpvcTlxeXJTQkVFbkRlWG1QYlc3Vk8zaklzQ1VJa0FzSC9RemF1TTdS?=
 =?utf-8?B?M202bHN0NzJXcmg0b1NFWGVGUnA0MlFKTDR1QzVvUE5xandRYnA1WWdVVkpG?=
 =?utf-8?B?R0xLenBnbzJLYlJreUh5L0pHQThnaWlTZUdVSTFvakRMdDJCMEg3ZUExMEdC?=
 =?utf-8?B?N0M4S2tsQ0I2cjFXU3NFTUdYRStHbmc1SGw1U0lCNnZDbUJDcFBvaUFOcE1n?=
 =?utf-8?B?TG44UXJ5dW5BVHRUYmdndUJ5bTdZNisvVGxFdm1kQjJDZGZSUmlWQitqTGFt?=
 =?utf-8?Q?tf5slL9rZ6SFXakLev?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c9bb39e1-2503-472a-7751-08df0dbcd809
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Sep 2026 15:21:24.1073
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: S7vnD3lRiBJgbu1JhWbFJNOcmiuVbqMAJgL7Dg0Ws6CjmQ4KyTecHUTiH8qdeL6y
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB8786
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 77794100003
X-Stat-Signature: pnioufrk3ng8qqc1ye5p9e83eynw3mzn
X-HE-Tag: 1788880893-893993
X-HE-Meta: U2FsdGVkX19F8MMrQQtNO5qUjqtKCO+qReqt63d/kKiVs+QZpL/tkmrWSfbcblU0KOIFeTk8W/LPbIMLEefWqxzkqe2yhQ2Wb/5T2krtjMNbFbrGkGhQfb66hdaR9NpioTGYF3oJWujpeS+jwUy2Y+xMOIr4rl/pj3jSLkehFcgh9rTIlNbIE9hKnejK+iFRdgGgD++mM82fk4Y8bQmbiSbpHzg6ywWW+9Xytd100PGru9uxKUlE7p5/265veO1SU6eZ4D1Gkud/HiQmUfee8ESFVp8Q89ibzWqvfDWYoHEL/NXaVik+DXAvCYO6sRVUsx3HnjtMzUwNcGfuKyibYcYxmi+fxhlrP0a5Ay+IbfdzgNnEiXNzWW9noTulXvPqJ8mERVk5a1d+WRc/jpMKzJ57M5Z4fytvj177zfZpgK/J7CjNAsYaTDeio4WX0qbLP0HPMmIYOt1tUzOoAsvrmhpBDW3tP/xc3wFO2gnhqXV7ppj3n2+eWeZrMWMn43nGPoy5WDp7rhCmmignJH2yam1E33zAS1a6MRhrqRA6FeJBlc7vEJ60hBr5HRxjv5eKKD6eU7R4EFDOmV3b7Zb+s3kc7o55b1UtKnWsa/Yf1G3KHGfeiovJUdsuMdoHOzEMLTdAY56cKZAOwp+v6qy3EX4WkHqzFYyIOlZ1XrwWLB57iN+kBEbvXGxG5tHoiq+0tJvsa2Yp72uzAOxFmJ0f0cDnvGOnMAH1oRS38jfgu/Bu8SBY7QTFre06OKiAtUv4HRbPjiffJdZa/xt5SnYY1VXrIoBX/XeEEl5oiW9pWuJDcB/R+t/xb8PmgRBMmGTvLZJK4Ar/yxbW1iKfmfLKnqmq9ZpbQ3polVSIuF8FxMOH9LQaK1SF0hGAQb3FFTwdd8zChADQMJ+VPofbPl+WRAAFr8s6ETt2mgBpL9BYom3w6zPsnLdci1g739PnPfC6h0DDmb3etKNJ6Ur+EG/
 Dd+RJ21d
 2N9/Ziiw0iBiahNvMvH4fHoIjUkE7JKQ0CNoS624DUiIoS3kek+nHiONZx0Y+PQpqhFPPYWxxxBuuNV7EQuFWOkD5mowu5IClBHuPYe/Hk5zb3u+ZfW0+FxUIc+5j9CvsFgCKciJPbY1EO3Qzlmz1tsQOLqUime+dG2oyBvisKYXl4I45WVoTJKBVd2/dbBmWvaiN+mvYYFk+VH78qhG+Opnu7x75RWOni+Flqdgh8QcUJFK+pg/j0aZOOAlu/aqFf5dLdk59Sbo4cAwB8sh+1s0PgUY31iScKq+YZLNTqelCj9hhDd98AscfFcqr/BMzsrpGd0jNjl1wvgFQ0eofZzIedFSE+XnQZQwhFshlptXXaLv8XgaVccn77+0l9MbM4WNkDH3JWTFfbJEq6YoU/fDg4tKE5+mAuyR6tD2pCUB/1Io0VK5FXYyUYgKy586NMPrCaGM/AQDeJpwBNPlyKIqzRAb1+B91e2lPCqXlFnDbYnKXRQVOWzT36HJAWTJKpLHepJ5DZrn6knPBGoD9U1R6LzpEVrmsvAL+6QgXzSANMnffdnXdtl0hjdHHC5yg+uScQQrcUc1I/lZf5A4lrvajgGQxDCOyVvs8wptV0ymQJV3CS/wt5Vd5eHFwNZi0h7vGVS0RlnsOeteJgV+JJRZ817rmuc5E0ySZ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue Sep 8, 2026 at 11:07 AM EDT, David Hildenbrand (Arm) wrote:
> On 9/8/26 04:56, Zi Yan wrote:
>> zsmalloc uses PG_private to indicate first zpdesc in a zspage chain. It =
is
>> equivalent to check zpdesc =3D=3D zspage->first_zpdesc. Replace
>> is_first_zpdesc() with zpdesc =3D=3D zspage->first_zpdesc in obj_allocat=
ed().
>>=20
>> For get_first_zpdesc(), first_zpdesc is from zspage->first_zpdesc, so
>> replace is_first_zpdesc() with first_zpdesc->zspage =3D=3D zspage, the s=
econd
>> requirement of a zspage chain, where all zpdescs point to the same zspag=
e.
>>=20
>> is_first_zpdesc(), is only used in VM_BUG_ON_PAGE(), so performance impa=
ct
>> should be negligible. While at it, change VM_BUG_ON() to
>> VM_WARN_ON_ONCE_PAGE().
>>=20
>> It prepares for a future commit that remove PG_private.
>>=20
>> No functional change intended.
>>=20
>> Assisted-by: Claude:claude-opus-4-8
>> Assisted-by: Codex:gpt-5
>
> Assied-by: LLM :)
>
>> To: Minchan Kim <minchan@kernel.org>
>> To: Sergey Senozhatsky <senozhatsky@chromium.org>
>> To: Andrew Morton <akpm@linux-foundation.org>
>> Cc: linux-mm@kvack.org
>> Cc: linux-kernel@vger.kernel.org
>> Acked-by: Johannes Weiner <hannes@cmpxchg.org>
>> Signed-off-by: Zi Yan <ziy@nvidia.com>
>> ---
>
> Nice cleanup, one comment below.
>
> Acked-by: David Hildenbrand (Arm) <david@kernel.org>

Thanks.
>
>>  mm/zpdesc.h   |  2 +-
>>  mm/zsmalloc.c | 24 ++++++------------------
>>  2 files changed, 7 insertions(+), 19 deletions(-)
>>=20
>> diff --git a/mm/zpdesc.h b/mm/zpdesc.h
>> index b8258dc78548d..4fd81c2e80769 100644
>> --- a/mm/zpdesc.h
>> +++ b/mm/zpdesc.h
>> @@ -26,8 +26,8 @@
>>   * with memcg_data.
>>   *
>>   * Page flags used:
>> - * * PG_private identifies the first component page.
>>   * * PG_locked is used by page migration code.
>> + * The first component page has zpdesc->zspage->first_zpdesc =3D=3D zpd=
esc
>>   */
>>  struct zpdesc {
>>  	unsigned long flags;
>> diff --git a/mm/zsmalloc.c b/mm/zsmalloc.c
>> index 825022a7a328f..24526185fd31f 100644
>> --- a/mm/zsmalloc.c
>> +++ b/mm/zsmalloc.c
>> @@ -290,11 +290,6 @@ struct zs_pool {
>>  	atomic_t compaction_in_progress;
>>  };
>> =20
>> -static inline void zpdesc_set_first(struct zpdesc *zpdesc)
>> -{
>> -	SetPagePrivate(zpdesc_page(zpdesc));
>> -}
>> -
>>  static inline void zpdesc_inc_zone_page_state(struct zpdesc *zpdesc)
>>  {
>>  	inc_zone_page_state(zpdesc_page(zpdesc), NR_ZSPAGES);
>> @@ -476,11 +471,6 @@ static void record_obj(unsigned long handle, unsign=
ed long obj)
>>  	WRITE_ONCE(*(unsigned long *)handle, obj);
>>  }
>> =20
>> -static inline bool __maybe_unused is_first_zpdesc(struct zpdesc *zpdesc=
)
>> -{
>> -	return PagePrivate(zpdesc_page(zpdesc));
>> -}
>
> I would keep this helper, reworking it and moving all comments regarding =
*how*
> first detection works in there
>
> -static inline bool __maybe_unused is_first_zpdesc(struct zpdesc *zpdesc)
> +static inline bool __maybe_unused is_first_zpdesc(const struct zpdesc *z=
pdesc)
>  {
> -       return PagePrivate(zpdesc_page(zpdesc));
> +       /* Only the first zpdesc has its zspage->first_zpdesc set to itse=
lf. */
> +       return zpdesc =3D=3D zpdesc->zspage->first_zpdesc;
>  }

That is the version I had in RFC[1]. But how it works is not only
1) "Only the first zpdesc has its zspage->first_zpdesc set to itself.", but=
 also
2) all zpdescs point to the same zspage.

obj_allocated() checks for 1, since zspage comes from zspage and
the requirment 2 is tautology.

get_first_zpdesc() checks for 2, since first_zpdesc comes from zspage's
first_zpdesc, another tautology.

I also had a version to spell out both[2], but Johannes did not lik it,
because it[2] is a "super predicates", making the required checks unclear.


[1] https://lore.kernel.org/all/20260731-remove-pg_private-v1-1-142c97ba356=
2@nvidia.com/
[2] https://lore.kernel.org/all/DKFF32LRYH32.16JIXI4LUS5E9@nvidia.com/


--=20
Best Regards,
Yan, Zi


