Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 163F1E88D78
	for <linux-mm@archiver.kernel.org>; Sat,  4 Apr 2026 02:27:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 043B86B0005; Fri,  3 Apr 2026 22:27:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F36D36B0089; Fri,  3 Apr 2026 22:27:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E250F6B008A; Fri,  3 Apr 2026 22:27:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id D57966B0005
	for <linux-mm@kvack.org>; Fri,  3 Apr 2026 22:27:45 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 43DAD13B8D5
	for <linux-mm@kvack.org>; Sat,  4 Apr 2026 02:27:45 +0000 (UTC)
X-FDA: 84619287690.10.267E0CB
Received: from BN8PR05CU002.outbound.protection.outlook.com (mail-eastus2azon11011040.outbound.protection.outlook.com [52.101.57.40])
	by imf14.hostedemail.com (Postfix) with ESMTP id 6C78A100008
	for <linux-mm@kvack.org>; Sat,  4 Apr 2026 02:27:42 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=R86prNZP;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf14.hostedemail.com: domain of ziy@nvidia.com designates 52.101.57.40 as permitted sender) smtp.mailfrom=ziy@nvidia.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1775269662; a=rsa-sha256;
	cv=pass;
	b=XSpBIt+UbZICYBJ3q7W/0pkM1b/e46CND84av9Z11mORUcA2iUla593N2tQxMZvBWFeJtc
	cOttor4FFBJy7+MFLzlo1q/ZixV3zRBysD/U3fL7InynLkIOFvuYZnnCbtkn/5u982N0my
	8N4JVCuJd4Ot3Mnp54ttiUnltCkQxWk=
ARC-Authentication-Results: i=2;
	imf14.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=R86prNZP;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf14.hostedemail.com: domain of ziy@nvidia.com designates 52.101.57.40 as permitted sender) smtp.mailfrom=ziy@nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775269662;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QtDgZU1uIholvoX19J4hCihswxZ5oVlWYT4Hm1kd3xc=;
	b=eul8arqmrJgur7gpfDMDUgGJuTvSdRO0yRynkt0HqtEXoXLV7xHg/S4ohEGY6TdWzF83rF
	J3osvAfjCDZB9+VdOQaujYBrH+eiFP0ju6JeIIN9mgPpLI7QfturNlNYxB8JjmLs0u5SKN
	V+89iheHHnzYhM9a0eSTnMXbMzovy9c=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=UFHlJ4kyITGTYcNbyNjMnCYcSZI65LzIekEqz4qjB2GMWUe6zq3PEtMV32Nvu3c3o8r/WFKrC9LgrJ17ziCD3OBVh718OnvbSLgzVhoxy3ksCWPKNuGhc3RfRciBWksubSb5qlNjDBK6u+6w3/nTDy0H/EtWjRXjYj1khwp9WALm8p6276EIRT4AGHyd+OYvqFvmI2P6RUIp62QK1xUPMTq/E+JcCb+8DuL0rKrpO/ESUxby0gFdcewamPghFHsQ4Y0bzcIsAPO9BVJ7oWClNRHIcOeZeL8uHuCk7hqqUNzd3om4YDtvk40Kk0OewERnVJqMNDAmmyKL0as8rpzaXg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QtDgZU1uIholvoX19J4hCihswxZ5oVlWYT4Hm1kd3xc=;
 b=kYs6T6qQ6QRsJo381QuknGiEna3tUmtAHIPKZ6VMsA6C4kuckgNoZU781zD0HF0hg6nmUjX9HqHcvrs8bCby2R5hHaHsk/ZnWaLDa9OlDHtT1KBzrq9EklBOj6c35Lpua3HqUy4ZW0zVVOPhe61yucrLGxdH7odA4l7aUtw9rc4lpQxA1KMOFu1WpdjBftVgDAlOCAUE9TYoUerhWs3BoGyAIYXLOQjxa2ek6w3x2BuhHkUHUZIBwm4DhSmlDHyaZDOPJTy1OQiI3ux5b0Ml/yjFbgKuWmIU9BiGvaJdSiakUyTpbxmmU/gXlafprfNPr1Ky6VA9JbEDoRVSjdJsAg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QtDgZU1uIholvoX19J4hCihswxZ5oVlWYT4Hm1kd3xc=;
 b=R86prNZPRF+85RJdDq4Sgor1Zm5nyNd+cA2x1N6tO52Jf4Js6uyZKTPN+3lRuDbga4FQYM21VZ+XglENdmakV0zD4P72pXzFxFEHTN2hVL5X/ytVJyaJazR1Hi5GafJZ5I+r0o/X9yx4Dfu8KnDqZsx50P+8go7n3mBarV5urpFMA3Em6BtCsWCmRceA36IKgAy8ArGJv0MGWSvpnAHbIBnIdlGzKMhJXPrzeDFMDpoL9mZelAwsksi24gZfxnRF3ZHtYgbLHd1JRaM1fi4PYrIUMwGAAFrux1SPuaq+jY6o0FotG4pBxoT5kMkscuGfsx/GCD6MxLDpOHzclGlZ0Q==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 CYXPR12MB9319.namprd12.prod.outlook.com (2603:10b6:930:e8::11) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9769.20; Sat, 4 Apr 2026 02:27:38 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2%4]) with mapi id 15.20.9769.014; Sat, 4 Apr 2026
 02:27:38 +0000
From: Zi Yan <ziy@nvidia.com>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: linux-mm@kvack.org, Vlastimil Babka <vbabka@suse.cz>,
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Rik van Riel <riel@surriel.com>,
 linux-kernel@vger.kernel.org
Subject: Re: [RFC 0/2] mm: page_alloc: pcp buddy allocator
Date: Fri, 03 Apr 2026 22:27:36 -0400
X-Mailer: MailMate (2.0r6290)
Message-ID: <1C961B84-522F-43AB-ADCB-014B3A4ACD21@nvidia.com>
In-Reply-To: <20260403194526.477775-1-hannes@cmpxchg.org>
References: <20260403194526.477775-1-hannes@cmpxchg.org>
Content-Type: text/plain
X-ClientProxiedBy: MN2PR20CA0044.namprd20.prod.outlook.com
 (2603:10b6:208:235::13) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|CYXPR12MB9319:EE_
X-MS-Office365-Filtering-Correlation-Id: afb74d2a-b548-4185-a9e4-08de91f1bd7c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|376014|22082099003|18002099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	kwE8LBqJi/fE627F7Ml/pFN8t7tZ6LZT3074duphgw2VdJte63iUzk09yXqxFED4rB24IfBeTLQ81aZSGudEBp3g5GiDQ6cPGuO2BsfIGJxBCjVdsN8Qdek+XV9vc6KnCc/P8+vlYnXTYo4lY+NLy7YTxv0DHaAM6Xfw80VQcXlASGDP93LhVL4o6GsZxIOIP+Vibb9jDOIf58Taqg16TNf8sCaDx5/q5RXdM+0lVtNktKEAzQDeckAerRBpq2ZD7PkaBdqGlflRHUrw62GV6WL5XFPzZmloOIZSJwkx6avgczRjvs/Lu4UiXL5YuL8CIjabbHXuRetx42h6oMDmI2KfBA9c0z+em7KvfMgK/flmGPfND09pc3swxUljOzLHlMIwOlLZM7jJKn11zDaN7RwEMoWUhLlrp8u+tj/JijwZmqxAv7S+QdO1EeAZC0yg6TA7FC5K9LOkpUIp/+WvOQEonfJRMW9/gn2xnxwdL9m+H4OEcBjDIFnGIZhGKwhng5l5YFZST3RCxZV+JnqHJ+0lV3W90ej720V+TFReuiSNl7cSZd0urve4GzLOSVOmqDf9Gyk4sUZ3HsXuRywfIQ/zXSGusBnhnew8syc+tfbXTZtelbTD0v6NarHenegfh1CWqYCZ0/K6gitqT3TnpCyAZDRvGYJStvo1l28dxc0Sq2DVexsBJF+1gJ0uqS2vJ6Z3kj/c8hlI6aZNiH3mQy32NK1o3xE2XdXD5ra6Mtw=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(22082099003)(18002099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Awp2Z3wVrhmIvBNeiVKYR7enRgeyAONXlFHxB4udwGFq+ONo17ebzq+aiwrj?=
 =?us-ascii?Q?aNOZrvrJFMSq07wZz39rdv55ZVBJ5Xppng97FLDLRi2dR2d/vMOx4x666NVo?=
 =?us-ascii?Q?6BpiCAz040dDiMyHGvHZteSlqkgzA09EcTj3WSlYITuv6lGENUjkcSPU/GW/?=
 =?us-ascii?Q?6efwxGwPXmtQEVeUYm4jXtNkMQcO5oghPP/vKZ3psYuYnr3DQPW6GQ8PR3pp?=
 =?us-ascii?Q?U9Jy92Z61JBiPBi6hs+w083z910jnamZZUH+71fzn3zbQ91kSKaaCdcyUZc2?=
 =?us-ascii?Q?j7ci7Bd4rt09FOSbbZYJDJdyAkT6JxNh9KcQ0NqZeIInkbNQ5fYLwUeXcmAL?=
 =?us-ascii?Q?iZ3csj2WSjPabKWg3MX0ptoFRSZVY/xe4TRwMJeU8W3pZ8/46dKh3DXk0kTw?=
 =?us-ascii?Q?tiziXmWZxRCWwPbhKLc2qFpM1M8O+XMfayDg4LvJHKkBrxx0LSvKHc9C9qxO?=
 =?us-ascii?Q?I6Z6HpDC0FfnOaqPrLGDp/YGNwk6NS5YAKx8gVIerxlv5jIg1K9qj/vDkfKx?=
 =?us-ascii?Q?Z5I7hZ6jszU3ohYCe3OJG7kF0KUtCWeuP4HyotBlgqqpxn+wra8Cxb+jGwT2?=
 =?us-ascii?Q?sqa6g507hb28jCViZgUdi1AcNSvlJBiUu1Qb+p+2MLOL1KtGusJtZCpO8w7r?=
 =?us-ascii?Q?LaShrK6QZeWF40rD3YzlvitCFFdvvkw9CbcK8FlC4FnQv+egOxAJ9MZgKiej?=
 =?us-ascii?Q?X/1roQTY3AzKNVeKbELo2t40fYmC+J4j32BT/GaJxJeee62w7Hf372R27jRA?=
 =?us-ascii?Q?ATpvKYIHYy5kQT1ZdTDT+p459gz6UZLUsxi6g07U+sxWayWh7mlTtS8L2Tah?=
 =?us-ascii?Q?2Gt8sXIS++9jOWz8XQf3o3CNO5V9mtmmiX9XogZ5ams0bi6tvbzHMz6uKBZr?=
 =?us-ascii?Q?dvW6Xq5k79aYgfUErIIYkaEk2m3POf7B7NtG9Ed0m9/m9bEB6ajlfdN2nz6r?=
 =?us-ascii?Q?goT4FesL7d28+1Rfq1m98VntdtjU6G7BTxwRXrI8M1KAszE60MAShmMTSIZn?=
 =?us-ascii?Q?XJmdnVUq/jEDfDCad8yw/E94uN1UiOVMjVc0s5IyVFBXjtWo3XkptMjcG6wc?=
 =?us-ascii?Q?zm/zbmMCZVYoZfKYevLRXXbJp0DZiuIyTXd24XRK8FS7lx7TUCsa/Ck9tkVf?=
 =?us-ascii?Q?jLoXB/MRFhZJqckGkyo7sOEnlM56/y8JGBYl6PmzsmleY8GsrYEvFj/ZzBlx?=
 =?us-ascii?Q?OyXeIZ+448PVdRbtOopPxPMqoUyY51KA1DbojvbX09LKAsAsFzBsB7dgCRMz?=
 =?us-ascii?Q?UC3wVqcNL7YChzNVp2gAYT3i1Rh9aiIG4w/H3+mm5LfMT9IBrrYSxE1LhSvx?=
 =?us-ascii?Q?fqMhKMEFPc13O/O0oyoJ825lFyy/kqrsWChGgpeEXjBjfWiEl0DmhcTIUVOA?=
 =?us-ascii?Q?QDnriGaHSoQc7UNsdM48u6m5HUHy6A1mI36ozfCuFZKRV0hSuALNVWNHOnhs?=
 =?us-ascii?Q?XM6pYcFZOLwqPx5uptotijQ5yVj9ILQGDtaBA2DwwtSp+Re2UZHlVnVyElXt?=
 =?us-ascii?Q?ou+JNJEQKNGgFlAeKmISrTTAfOZXLVORL99msq2Sp+9KWLFVvpkRPB79XAFi?=
 =?us-ascii?Q?mhpGAc1i3gdnntQc9o954XWGPbiSLYx4DQT1ht6lMXGu1vawfVGBdrxIzvZA?=
 =?us-ascii?Q?8P88Yl1yYY9zmvTM5iiNQ68B2wGOjsM5cXWFzVYs0ozDbYVwE/cIZRpEbeDW?=
 =?us-ascii?Q?lDlhEl37/FkiKCuj26UtUv2S/Kdj+xUwEY4Ppu3BeQSWEXul?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: afb74d2a-b548-4185-a9e4-08de91f1bd7c
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Apr 2026 02:27:38.7200
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: N/7NCLzuEEYf2ED3yN0/9mOIVjGmx/lo27xpDSZo1jmGK9KHOao+iR2GyyMD5hFZ
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CYXPR12MB9319
X-Stat-Signature: xey5jdh5wz4k773zprwmgq4kta79pxpj
X-Rspamd-Queue-Id: 6C78A100008
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1775269662-470341
X-HE-Meta: U2FsdGVkX19xjlXiij4gZsOduTfWFU8s8s9nvqIX8stXqoW2fvRvW+3vv8l2cWadbkdGUmfaOteUicjpGXDLf74t6qYlKVAwptpnojvIBQh14zLNrmG28J8boroWl4g7G42cwHsvGbgZzOKZsuo+D+iINy7gfsoQQlLoro7oJlPVLtPEP8RlXYi1VXh5/pm3NmzhCZZVTBMacfiuqOJ1TLQs+O0Hi7ZWgL2h3VhB+//ki92TdstfGjEcZa7x23gg6ItHl1SeJqPI67kN00LDVfyamcXWbEgTMtCYbG2Rhas6W4nBleqUxkYVsYoQDasplYhPdGSJ63CcQw0jCBeYDuk8t5uXxqh6K3VJx58FdDqOhVnwtXePG8hltQd/VqKidCkM1P5eOv04zbS7Ws/EIznxVaOWnNN922aF0gBp0zYCwg4uIFTOv/S12qbvsT3Fb6ks+UhuGa68D4KQHtY9D7TkZUq5TKI547TdvUzbDpRY9Di3D2zmz70fK8JZvF8qqphpcDtY9RCY0qsVa1FDLIuM1BIwvBKlGtOXQwWp6Yjb1PE6UPhDckYxxM0nt3Y5ZxYszvF+l/yAvsKvd8hH2UlhsFsS0ODi6vuNY+Wnzg8llMb79cwJOj8V0l2WNIWvf0o6oi/RugtK0LLcFsf4+P0Ryhgkuqpwy/H7Y0Wym7aWcUa9SfBiQjr1qt6XLdzXWPSEefQ6OY4jpGgJxsMLceF4rTwkzeDq89SKH/SKb17ZBKZ157Z4ihzNy3WNQw+DAnrX4yz5bM5zJYPhD3jFQliH9jO5+ZsNAy3rO6cxZjRBt3MnUFhIYtrUnvf6ztL8e29FcaVZ6Rcgg+nCf49XxeM7s8xI+h4kOOxIeMiIkDVcIuGtv2Ye7P5SPD8VBJ1a6e8vMy/ctp3My3w2LX8agVN+ec9iCp6BJciACfB/gjZtMPW/CPy101h0QvvKAXfoZjU78DJ/1cRoqCkgVFy
 YxayiWwB
 UA7ACn7yjjDi7S+XGOdFEq2MrdjcWoO5JwQH0CrRySk5CXjjUanWsZaUiF0NgBrWmS6dGtFCYtYJXBrOwKEWBNJqIMlhdUOCTuBmMOy8MDh3ltGXkRQvqjDuZefbdOnWS9HmWaq9GPlWaKTtYcE9uHNSzsH/r8MIWgxC8ONUaXTXslobhWfogDcr6hXIPmvFcfPN+qQ1503yb8PtoEMSh9P8JToWlgflrg52QBp2grLM7bu8hYZt9P3bzGfnhO8Kefh/SP2nRerr9K3gLlwm3OUaWgXO8clnf5e+IPLLquwpJLdY9hhpumk9BSouG8+sERfRIeGOXlIIp1+dhTqzEhVlfbGMRFWcDNDbZUSns6TaEhZk4X1yjQTuTWA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3 Apr 2026, at 15:40, Johannes Weiner wrote:

> Hi,
>
> this is an RFC for making the page allocator scale better with higher
> thread counts and larger memory quantities.
>
> In Meta production, we're seeing increasing zone->lock contention that
> was traced back to a few different paths. A prominent one is the
> userspace allocator, jemalloc. Allocations happen from page faults on
> all CPUs running the workload. Frees are cached for reuse, but the
> caches are periodically purged back to the kernel from a handful of
> purger threads. This breaks affinity between allocations and frees:
> Both sides use their own PCPs - one side depletes them, the other one
> overfills them. Both sides routinely hit the zone->locked slowpath.
>
> My understanding is that tcmalloc has a similar architecture.
>
> Another contributor to contention is process exits, where large
> numbers of pages are freed at once. The current PCP can only reduce
> lock time when pages are reused. Reuse is unlikely because it's an
> avalanche of free pages on a CPU busy walking page tables. Every time
> the PCP overflows, the drain acquires the zone->lock and frees pages
> one by one, trying to merge buddies together.

IIUC, zone->lock held time is mostly spent on free page merging.
Have you tried to let PCP do the free page merging before holding
zone->lock and returning free pages to buddy? That is a much smaller
change than what you proposed. This method might not work if
physically contiguous free pages are allocated by separate CPUs,
so that PCP merging cannot be done. But this might be rare?

>
> The idea proposed here is this: instead of single pages, make the PCP
> grab entire pageblocks, split them outside the zone->lock. That CPU
> then takes ownership of the block, and all frees route back to that
> PCP instead of the freeing CPU's local one.

This is basically distributed buddy allocators, right? Instead of
relying on a single zone->lock, PCP locks are used. The worst case
it can face is that physically contiguous free pages are allocated
across all CPUs, so that all CPUs are competing a single PCP lock.
It seems that you have not hit this. So I wonder if what I proposed
above might work as a simpler approach. Let me know if I miss anything.

I wonder how this distributed buddy allocators would work if anyone
wants to allocate >pageblock free pages, like alloc_contig_range().
Multiple PCP locks need to be taken one by one. Maybe it is better
than taking and dropping zone->lock repeatedly. Have you benchmarked
alloc_contig_range(), like hugetlb allocation?

>
> This has several benefits:
>
> 1. It's right away coarser/fewer allocations transactions under the
>    zone->lock.
>
> 1a. Even if no full free blocks are available (memory pressure or
>     small zone), with splitting available at the PCP level means the
>     PCP can still grab chunks larger than the requested order from the
>     zone->lock freelists, and dole them out on its own time.
>
> 2. The pages free back to where the allocations happen, increasing the
>    odds of reuse and reducing the chances of zone->lock slowpaths.
>
> 3. The page buddies come back into one place, allowing upfront merging
>    under the local pcp->lock. This makes coarser/fewer freeing
>    transactions under the zone->lock.

I wonder if we could go more radical by moving buddy allocator out of
zone->lock completely to PCP lock. If one PCP runs out of free pages,
it can steal another PCP's whole pageblock. I probably should do some
literature investigation on this. Some research must have been done
on this.

>
> The big concern is fragmentation. Movable allocations tend to be a mix
> of short-lived anon and long-lived file cache pages. By the time the
> PCP needs to drain due to thresholds or pressure, the blocks might not
> be fully re-assembled yet. To prevent gobbling up and fragmenting ever
> more blocks, partial blocks are remembered on drain and their pages
> queued last on the zone freelist. When a PCP refills, it first tries
> to recover any such fragment blocks.
>
> On small or pressured machines, the PCP degrades to its previous
> behavior. If a whole block doesn't fit the pcp->high limit, or a whole
> block isn't available, the refill grabs smaller chunks that aren't
> marked for ownership. The free side will use the local PCP as before.
>
> I still need to run broader benchmarks, but I've been consistently
> seeing a 3-4% reduction in %sys time for simple kernel builds on my
> 32-way, 32G RAM test machine.
>
> A synthetic test on the same machine that allocates on many CPUs and
> frees on just a few sees a consistent 1% increase in throughput.
>
> I would expect those numbers to increase with higher concurrency and
> larger memory volumes, but verifying that is TBD.
>
> Sending an RFC to get an early gauge on direction.

Thank you for sending this out. :)

>
> Based on 0257f64bdac7fdca30fa3cae0df8b9ecbec7733a.
>
>  include/linux/mmzone.h     |  38 ++-
>  include/linux/page-flags.h |   9 +
>  mm/debug.c                 |   1 +
>  mm/internal.h              |  17 +
>  mm/mm_init.c               |  25 +-
>  mm/page_alloc.c            | 784 +++++++++++++++++++++++++++++++------------
>  mm/sparse.c                |   3 +-
>  7 files changed, 622 insertions(+), 255 deletions(-)


--
Best Regards,
Yan, Zi

