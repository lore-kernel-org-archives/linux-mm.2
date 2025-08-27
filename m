Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D8B6FCA0EFF
	for <linux-mm@archiver.kernel.org>; Wed, 27 Aug 2025 23:59:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 145046B0088; Wed, 27 Aug 2025 19:59:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0F68E6B0089; Wed, 27 Aug 2025 19:59:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F000B6B008C; Wed, 27 Aug 2025 19:59:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id DF4286B0088
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 19:59:16 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 7E220BBF7B
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 23:59:16 +0000 (UTC)
X-FDA: 83824206312.12.99B81C0
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam02on2079.outbound.protection.outlook.com [40.107.212.79])
	by imf14.hostedemail.com (Postfix) with ESMTP id C2ACC100007
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 23:59:13 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=PLVD1WZA;
	spf=pass (imf14.hostedemail.com: domain of apopple@nvidia.com designates 40.107.212.79 as permitted sender) smtp.mailfrom=apopple@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756339153;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CtENAGBQ709z3JSAVUvTbKOByleUxKaEobXurWDL3kM=;
	b=f7ezoAEKdfxo3vU7WKa1MvL7f36dHeoiLPz0UnWM0ePhDWmENZFl5ROqDyKf06sefHcdnN
	2epfvcpDYijOliA8s/+hRLqT7u2EO4fzZM9hKTbQ2ugSkrmG6mG9iUkuUzs/KYvzIGQAeJ
	vcyP9yZutv7EIVgnTjvpxWmzf9SmJgI=
ARC-Authentication-Results: i=2;
	imf14.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=PLVD1WZA;
	spf=pass (imf14.hostedemail.com: domain of apopple@nvidia.com designates 40.107.212.79 as permitted sender) smtp.mailfrom=apopple@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1756339153; a=rsa-sha256;
	cv=pass;
	b=029oNrqrxYKJFTINglSf8MGkLxcSpcY7CtPwWiBfrBis/wsMq4k6i4bSjyoPPkQE/iPd/J
	n8zmgT1F4Caqf41wXTU1bXLao/V+momOHEEBoMr6cG5ZtLu7bDPL97M/JY5/PcZa6+JhDG
	383QS90xnMu+8kFw28EjykB6bXiV428=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=wMexVBFhwkGlIiW63VOCVdT1R9rIWev8DVeOZ9M35VZd5ojFFL3DxqLf6b8uoik0emSeZANrFQyFg97KGPMIxaGthzz667T5rWnv2WUyMxSssJc8Bmq+bDRjROZq8a2Smm2JYXddzMWxZpHrk3R2CqqVykCdkbNLJtxn6juwSG8ctwjw9eJqnyr9CGVFRYfT2K7V8OKyU9+03iJ3olBfLmQNs6HhCUJ3UdMDVw8O0fpLZbFFv8AZvvXxQ928td1evAC89jZAxuZBHkK3qAdmlVo5wlw5ko0yGmS8TFpaUDXl/lVG+urWpC+wPPAzijfHvZDQsk2FCaZTtGshyr9qaA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CtENAGBQ709z3JSAVUvTbKOByleUxKaEobXurWDL3kM=;
 b=D3gF9V0DLHmC+I4+1jsGn9zw6r9IfQTurGfJN889mhSQCG67NMSZEOZIYxFrIntwpK4o+ce9YkFmdddPJhianCEE3tXxg/X/R2H5NjpaWwKrB0NqyG0RcKmDQ2SKLPJy+BS//YkRsc2rXWH8muTLpuD04EoO+pDV2iwL+UoKcWp0hpwCr5xLaBfLltFDfA48hMZbCVsANbwVi5Ygi4LOk6dXRVrULkx88JFzPrTtZJ16+etDHBB1yGdt2+v0n+6QhxxtpnTuT/YgGb/nXyxeVFlliDa8waabw4ixjsBmz7SnDYQ+Q4Bzv/Pg0WAL8pOR5D1Lyr5/uUj0NMtgNKdOpQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CtENAGBQ709z3JSAVUvTbKOByleUxKaEobXurWDL3kM=;
 b=PLVD1WZAKCgXoms0m5ZsPmWbmsU0jYJJ7ei5keJlLtuW0qY43zT3Mgd834CRGOUd2g572ubuFFc9ho6oW20QgwnrpxxvTdJkxSMR6OVsbvX4OyI2iSMjlmJryHIlPOijuoHiQl7yS6NbE62d1tcYdXTEzDIQQEGamLr0d6bsu6HE2IO4FZbrNcGPlyHLzB8ZtA47DyFn4vw1fjFEJIvkLqFERszR/eESm80X4xL0MQegnmsihgCEKm4iCgf9H7NNf7uDIqLUXWuW5/XtuQj7NCxXnBJUG0Es7862MgaytlefbbSDc429ao18K7QQaFldHTuRgt/NrDI2HQh8AudXOw==
Received: from IA1PR12MB7709.namprd12.prod.outlook.com (2603:10b6:208:423::15)
 by DM4PR12MB6566.namprd12.prod.outlook.com (2603:10b6:8:8d::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9052.20; Wed, 27 Aug
 2025 23:59:10 +0000
Received: from IA1PR12MB7709.namprd12.prod.outlook.com
 ([fe80::5312:ce8b:bdf5:aa31]) by IA1PR12MB7709.namprd12.prod.outlook.com
 ([fe80::5312:ce8b:bdf5:aa31%5]) with mapi id 15.20.8989.018; Wed, 27 Aug 2025
 23:59:10 +0000
Date: Thu, 28 Aug 2025 09:59:06 +1000
From: Alistair Popple <apopple@nvidia.com>
To: Xichao Zhao <zhao.xichao@vivo.com>
Cc: jgg@ziepe.ca, leon@kernel.org, akpm@linux-foundation.org, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] lib/test_hmm: drop redundant conversion to bool
Message-ID: <l3qkai3xh5hwvt2f627i4jhf3upyvzvvftikgbahauutyhyagr@7tsq4upe6hl4>
References: <20250819070457.486348-1-zhao.xichao@vivo.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250819070457.486348-1-zhao.xichao@vivo.com>
X-ClientProxiedBy: SY5PR01CA0122.ausprd01.prod.outlook.com
 (2603:10c6:10:246::19) To IA1PR12MB7709.namprd12.prod.outlook.com
 (2603:10b6:208:423::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA1PR12MB7709:EE_|DM4PR12MB6566:EE_
X-MS-Office365-Filtering-Correlation-Id: 22e7233b-35cb-4d6c-72d3-08dde5c5b773
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?p1Cq1nR04H8IUJ2FqUY2SAlB2mKYWM2mHotjzv5Ix4n8eWALDk1lc9OKpmBx?=
 =?us-ascii?Q?fgANlvsoKDQ1bA6tomVaQTEFZ6YcDwf+wZk24lJ0e/SX5Gv8DlFiE/ZjwevF?=
 =?us-ascii?Q?b4mh/c+NdPo/cRQgBUoaJhRVhG+YH7d6stKnjTQ/A5L0e5xaSAtDGg64/Ffs?=
 =?us-ascii?Q?JcOlzVzC8VZ0DH8QIQszY2TmCSKvHJarlVI+yCurDzc2ugyDjgEGW2XuQO0Q?=
 =?us-ascii?Q?h9Tt90iy4joUoLQVvfsNJH0lqteAiahE1q0WdXVuJ6mRq914estC9aikZC6h?=
 =?us-ascii?Q?4oYYcQnUolFkVWBzyk+bJed3DbpkwrqzzTrFWqOcg8CQjtcVTRo0NMmWdxLe?=
 =?us-ascii?Q?QhvXC/BV09w6S7eiBk7QFY/csYbOKE2hlXNm3h0EFWAFTy0TnT4f6XvO3zbu?=
 =?us-ascii?Q?nuhxozGBtabWX8mbpspBbJiRTwb+XY3EmodhXOWA6eoxObM5cySrDVcqyJE6?=
 =?us-ascii?Q?67AAbTAw47sTKHkWgtlJ7dWOxkl9HUp0vwJ0uX3iXeef79b2FdfvwNt5EufR?=
 =?us-ascii?Q?7lNA4EObhXF0gkoZMnDyOetpD48bJGooivjBrF1qx6nEhd3zN3H65aaLj4TC?=
 =?us-ascii?Q?d1R9np5bFxMucbJrQ4EFltyWtwxn4wDV8/9eioSr+7MakbJSbHDzhcu6nsD2?=
 =?us-ascii?Q?MzfF8yoeZ0tvkykPqtC7YU/I2kKCGZJ7TnxdwLR4T6um/O8MFKp8FJijLo76?=
 =?us-ascii?Q?qpeZnidOV+7YPNBmSkJEQRLl569uwLb5bpBgoa5fWFFQNxAyQTlifTxrJBt1?=
 =?us-ascii?Q?tCYjTXy8i/tfYtvhKfgbX39cu7DuMTjLjLUqpWwokDKv9QsmHUQkvJUVZlSo?=
 =?us-ascii?Q?sU9QawJN64l5kfOJPkMHW3xTDsQpi/iko03ODGEKltRkEWJ++O13p/dEj1iy?=
 =?us-ascii?Q?MDxWubrGvpVBMzWzguG3tl9Jg8cf/XeIFz3B7l4Nj0Nzy7bYy7VJtPVa4aMw?=
 =?us-ascii?Q?lYcG9uZw96Ax4Asp6YIl+eYI++5iLr+AEh2ybHDHuXCfyVuo1afDZNQZs0iF?=
 =?us-ascii?Q?qEaMr13utLKVxYPU34N7poCzYeqjmE7/X8DLNYs2lo+hMKk2HAWJaG+oCs98?=
 =?us-ascii?Q?e15bJ3e9q//ebOnBv2qiVacVsEskXbbABJf+tO+qCuaTroBDbfyKOvPdhG3G?=
 =?us-ascii?Q?5ibDSNjQf1fB/RVNAyMMShzN2+KtCP0+1wsgA1s+811H5YmCdfXaVdMiTfpp?=
 =?us-ascii?Q?x0jcD9kcgRTwNB7h1yBG41YWuTQ4QceWwyqpIZjnNkERfqEmoj9MzFzqQRfp?=
 =?us-ascii?Q?e+R2NgYjgjIUqwy8H8P2y2lieupHJ5YSJQFY2yHThphgU/bcpi52gKIRxKHS?=
 =?us-ascii?Q?MUtE7kUELHwt6G+GNea5L9NZn3KpBlevL4ExEjq4rc8bxO4VV/V582UK7wLv?=
 =?us-ascii?Q?wFVzl0uvu+PpXsUThGtSlWKSM2FTU4KvwVgHwFkAEG0qxBw6UCOIQc0hzmJH?=
 =?us-ascii?Q?wlhP8TIig1k=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA1PR12MB7709.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?HZTbyvad/i+aCO0ibgHLZxtI3Sy4vtsmx94YV1U7wvIJKysb7mToium2bUEo?=
 =?us-ascii?Q?uCrydV3aNdfGY7rqtTlgn+aDIUnAe0KkAm8I6OocSUb8tnbLAYHsazb9WxXY?=
 =?us-ascii?Q?o3wwGIlLJpU94QjGTTF/vJ2Zc3k3+6St1cJviu0uJLR1/RLyfzGNrzgOZMlu?=
 =?us-ascii?Q?HCIh/Zcrah/WvWUI2hprbhRavFTZGlp9DgKjdd57cOsKWDKeysNPWSRjIFeX?=
 =?us-ascii?Q?2Kmp5FLyR3gg/M9cuC0u2rVIxp3lQVkclMyvUtlLPLEd3jBHO8fCvOp5iWOm?=
 =?us-ascii?Q?VfbkS+S3bAPY5geKZ9jOJ7u4gIp9O6oY2zXHGGeWsLMqwtrKcFu80BaevrPU?=
 =?us-ascii?Q?B+MbuWj5RzAsJ1jAHmlAZI+Ekh76xhiigENpvNjZehRoDI0uPYiEXxO7QVfr?=
 =?us-ascii?Q?0guaa092gmjEdfFC+nvC+0v7HGLkAdWGsPoO4+BN41hdLpiMPxRMJQDrx07S?=
 =?us-ascii?Q?vI/sgJ+Pv8VJxFT0Nis4WydnapCctU7ShwozYl4J0ex7Qc5Jpmxj8vVjaM05?=
 =?us-ascii?Q?o58jMHEMzhTWUV6m94mRaNYylz+tf7UYGFq8y6rdemk7/qmsno8RZAofiB2b?=
 =?us-ascii?Q?XQIvcBdliGxueRNq6MBe/mfQ7bcYjC7ttlOQY/mI9s7LNECN7Z/6HsLQiIf1?=
 =?us-ascii?Q?9LdvdcCkfyIULv3U8yPvtMBky0uKqctLt3PJ1tglYwQxtStZJmq5gC1i6eKa?=
 =?us-ascii?Q?MKi2mTKI0VOhDpVt+6xO5Gd/MhE3VuTo17FUXH88F2yDGvoO++i6hmAc4K98?=
 =?us-ascii?Q?Puds+JavThX2bIUsQClFnVMfwlrob21d74xmaW0ymdoXO6x+t6MjAp2IQvb7?=
 =?us-ascii?Q?BQtiafzsL5pTU6+9Ii3u2oaJrUQqtCU5yermVJFKXSJNLs9AUgm6hxnt9qY6?=
 =?us-ascii?Q?5EVBeZ9EPCVk62oXcTMRmuDA3eI0fvdP4Cl73svljvq+Dvd3v++7/l5xNJs8?=
 =?us-ascii?Q?DwR0jfJOkaeJ9qj+ER+ho8vwuiu7Wnbx7zwS6GXj9PqePt356USu61Lmojx1?=
 =?us-ascii?Q?6e0U3/EAL6lOxh/YX2X0bxLL9Ap3TIk8k3VtWImTYIuqQLgHfgWteQaOk1mn?=
 =?us-ascii?Q?0Seu7Y5QKKdgFwj8WZwPQYanIi31e42pF5IvSfkRVX+9iAbN74UQGDGYlIVC?=
 =?us-ascii?Q?x6ENMdUhA81XQDejXK8c3v93BQUrN174r/u9dpLh4EKphP0d15T/We9iizoz?=
 =?us-ascii?Q?bARzCzeeqr4FVKu+fUTkC+GaYgl5ZE2alCa93yCR0NMTO7SVo8yZ+xwOEifb?=
 =?us-ascii?Q?6vJ7crRL+gbeOVkXLPQNia9nJEGQ7mk8dOYISSr7wQZg0zHuqumtRH0jMAlt?=
 =?us-ascii?Q?3NLpanr9UwJ8oIep+rXvfvstHv9GG2vZtEqA86wl/QeV7/x4zz266lp8InAS?=
 =?us-ascii?Q?MAPu8TaYUaRhcr7xkU4UZcFVyLIhT6it5gcTnOagMD0FqStKn1255Q0zxmF+?=
 =?us-ascii?Q?3WhY+CPaAC5RWoNvmO7+rzKVO5TzLf7CRFvm+0U7f6Z12tW0ZsUmfpXrHVzD?=
 =?us-ascii?Q?J4BPxjmzSE8JNmo6WPuS3SjjWgABRl6/FUHNWsWj3YtxS3JM2+ssqBwhUgJD?=
 =?us-ascii?Q?aMkB8J4LUFWiBeBR/Kl197SNtMttxg7Evq62hsq+?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 22e7233b-35cb-4d6c-72d3-08dde5c5b773
X-MS-Exchange-CrossTenant-AuthSource: IA1PR12MB7709.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Aug 2025 23:59:10.7910
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0ipaUMxmXrwjWCxyrb8ZeUJLRmfiW9GFnpOpsMuK3Zu5nDN5KbQ0L3dtqtw7WKYvcmXZoEBwR2CmAiR1B5XxlA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB6566
X-Rspamd-Queue-Id: C2ACC100007
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: eysnekt53o7k81qtii3u5candkspb3q3
X-HE-Tag: 1756339153-411667
X-HE-Meta: U2FsdGVkX19mZtKAHyWNN+EOMjgSrnrO2oCZjlIa0rdvTPUzI5FmJD3/P6GydJWMizxtV4baLOvQpPUQHqolkh25BB/OM0LZ+hfCzcodXcYVzyui2D5M53LlohMk0YwASa8Qwzgi/O+TOS80d62jv69uWGgiYz2QTZM+et9JU0Lb8eN6eJPwH+jI886D5krlDCRdugD21rlWo+Xnflo8zb4181BtvXBH7LtAFntM/NcXShmjSbFQ+sLXxaEU3XKnwE1VLBcy8C7wmOIRizydMsyxmXpWQIwRVEnUVuokFiwEKfFe/5sd6UwWWnJJjbnXaRpMENhGTCR+gFGaDgWoT7aqwnhW0vmEbTIrfcggiplH2X8WME246NX1NebBSQe/aZQ9aaw0RK/1Fxrlcs5UveV+mpJu0qV04Cjqxn1ZZ6o21bg9K9l7jNORG5m8AVGiflmqj2X0tnOAs6kgIk6yDvSXJLuNws1yolVp2UeN5ukgauAavgjbNMk+8ozJlD7Es5isCYEjUjRCvrdXW+RxmYIaU6ZVpe4/MtGFzetre475cIplgUUlQI/P9VMDLeya/rGjesuPyIRvuMZiQaeaB+mX5GQw7cOVdpu1eTD+p04YKy9fPtgpfQPg+TnmuWr3Gs64jM8h32FDbQyjvxBOu2iuT87elU/X+GcRawsk8/qxzpurcn0I5n24Ttm85APB/PmjPRBu3EgZ9fcW7YMRI+NTKPScvOeIhd8WvGwbqKWNHJxKMsfKi5HW2mPijUL21zAlAP2wVg9GB01riqCSwFfGwJX9E/4kk3dMncr4OJK8j/pUBwbPoSyjnzS0nLctZ9ldP9S6cnzbaZJ5V83Vdxk60KiKn7zD8DoMcIQYxuLDrdH9IJMakndVA6VUshePh0KlbmIc6YM34ryojV9SIpaGuY+4JvGkUh8w3zuLnTl5OdC9B7OjOgHZdXbrUzN3LLraePtlHzzMqdAp7au
 wxOyhaIy
 6M+S+81osQ/thTZRc3vTs8z3e//v7hMWdo9DgCimTJYLVFHFbv7j0ZqVtjoBZmqLO+/dbcfFhFSVyQpDPS+C5rD+p7zZozj++oUU2ag1BAkHFbtNm8qoEPanKrLQS9BXCVllSLg7JkG1ekNhiFn1aVf/qE7XEGnZsDRUspW4B2AQl9mhDykZRjZwwOfbBHzqea1tjP4PD4t71/8Va0UvdLjSup5AEkrSzL4pMAxifQBTqSPOfM+p58p6gB2UbBvyc0MMm32WJoKpHueF7Ak98ciTRs0lmmjvO0NrDPFqM5H5ObdTF6OJ1NEuQjDcgQ3BSZgma3PQq/1nVQD70vAn/uZusHVwLY2EmwqtgldeXaBHbQRNbdyoNELlSjdkMIOeNbskxGFAAXpuNRpZeTdh7dy7WWP5i+nwfoIXU8MokZx5SrEEKyDCbbivacfkcGtVCdqd1mbIsI2sVGMbWhvQ1xIvu8hfdm7CKNtfcrZlGKhXW+UCrgyebc4XYv1LpbYxqSZZMiOC94wpqbk11nsnQBlWlX3YTxe0dhqgqA3om2B8ZnVf0kW1v3/GmvKgMqufhfPowJ04Quo8RWpg0JZOUMElRnw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2025-08-19 at 17:04 +1000, Xichao Zhao <zhao.xichao@vivo.com> wrote...
> The result of integer comparison already evaluates to bool. No need for
> explicit conversion.

Seems reasonable.

Reviewed-by: Alistair Popple <apopple@nvidia.com>

> No functional impact.
> 
> Signed-off-by: Xichao Zhao <zhao.xichao@vivo.com>
> ---
>  lib/test_hmm.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/lib/test_hmm.c b/lib/test_hmm.c
> index 761725bc713c..83e3d8208a54 100644
> --- a/lib/test_hmm.c
> +++ b/lib/test_hmm.c
> @@ -140,7 +140,7 @@ static int dmirror_bounce_init(struct dmirror_bounce *bounce,
>  static bool dmirror_is_private_zone(struct dmirror_device *mdevice)
>  {
>  	return (mdevice->zone_device_type ==
> -		HMM_DMIRROR_MEMORY_DEVICE_PRIVATE) ? true : false;
> +		HMM_DMIRROR_MEMORY_DEVICE_PRIVATE);
>  }
>  
>  static enum migrate_vma_direction
> -- 
> 2.34.1
> 
> 

