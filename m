Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 04519CA1009
	for <linux-mm@archiver.kernel.org>; Wed,  3 Sep 2025 09:07:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 60D838E0008; Wed,  3 Sep 2025 05:07:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5C5C48E0003; Wed,  3 Sep 2025 05:07:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 45E988E0008; Wed,  3 Sep 2025 05:07:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 2BF548E0003
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 05:07:05 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id EB12811A03A
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 09:07:04 +0000 (UTC)
X-FDA: 83847359568.21.37151DB
Received: from DUZPR83CU001.outbound.protection.outlook.com (mail-northeuropeazon11012063.outbound.protection.outlook.com [52.101.66.63])
	by imf12.hostedemail.com (Postfix) with ESMTP id DFED940002
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 09:07:00 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=arm.com header.s=selector1 header.b="GJwc8/zS";
	dkim=pass header.d=arm.com header.s=selector1 header.b="GJwc8/zS";
	spf=pass (imf12.hostedemail.com: domain of Dev.Jain@arm.com designates 52.101.66.63 as permitted sender) smtp.mailfrom=Dev.Jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=2")
ARC-Message-Signature: i=3; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756890421;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fCQB5OMT6iYqcpFzMZCmyRILwk+DVPKGeWatzLLcUDk=;
	b=Xflu9NfbFzZB+j1q3d5gjO64o33HhMYLLCLE0sBLYBIv+pc/y/Vq1eoc9t1U8wBaapPR+z
	sroF6WSVnJTh4ozRiuh51LujagPVTf1Yzt81mCPJtFONdczJXrcOT+fblMCOatqDzr3V4U
	19PTmevvRWvtWAoTFNOKf+YmxRaTAow=
ARC-Authentication-Results: i=3;
	imf12.hostedemail.com;
	dkim=pass header.d=arm.com header.s=selector1 header.b="GJwc8/zS";
	dkim=pass header.d=arm.com header.s=selector1 header.b="GJwc8/zS";
	spf=pass (imf12.hostedemail.com: domain of Dev.Jain@arm.com designates 52.101.66.63 as permitted sender) smtp.mailfrom=Dev.Jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=2")
ARC-Seal: i=3; s=arc-20220608; d=hostedemail.com; t=1756890421; a=rsa-sha256;
	cv=pass;
	b=WW+QKTHFTPrz9iUQTdU1lgm4HoauBqqjcsZC5GmJMEgYWJeZ2Ew6h1R2MIqc5wMkg2mVdu
	mkhOAWVOlobeYLkyY6nmGYkza1v/zXQZ+4Ykg1eDZ/BBlC1h3SOA6iO9ikyaOkKHG5ZWNe
	Yje+/6c+8UawWb9ggUQqXIXkvYmOnzw=
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=GxqJ5dukpCjTfmpKbUcRJee4fok3MvOJvAOx0si8xHJ1YDYU93zimAt3l82Ep2OHlj4LZukuB8BHAmZHsQ0lOWKQpTE3n1tBa0MwMEz5L+PNxXswX1riUN7mS8//lqYNYueEeHU/Uoa2S2d1bKbEN0stLUtRvXSEY1atgda1QkKBKhW5hh5dKZLk4qZUc9lVpoVtFgYLSUgrXh/dVVC0fs9iTxzlTH1+uXbrP86lBrA3ETtLujoB4TfaRkWTbti4cfhsknUtE2xQmG3vlaa1Pfbku0ptDDaMQM0Dinp3Htk8kCwb7/ce3e+1LHFqX69K4P74UJYk372euSt3+bV9Qw==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fCQB5OMT6iYqcpFzMZCmyRILwk+DVPKGeWatzLLcUDk=;
 b=imFlLAk8xTFtktNVyBdQ7rwdrMy/fl89nxv7l4Re4kdJIKfG4il4iP2FiIeJ9X6PymHHnv2rm+JP/OUAkQgWLnb8LxhWIoT4hjs4HmwRWQ9CWQm2MsZ6g7KZ6IaXolkCtQ8nUG/ggy8rTF2T803ssMuwX3+C0sx1mR7XgsMc8siw2BDC9BnIVyZ1yU9Jnev8BAkEItRyDeuMO3/YiQeLwbB62MMfSgc6OA+BDGx0YEfEfsznjXYnKisK0mC1UA6xf2DCBG8dZf83TpfOJuyi0gXVSm5g710kZPcMZm4fNONm/akxzbI7I6RxwAQAmX7yTXBgTZJGWJTLP6UNh/K3EA==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=gmail.com smtp.mailfrom=arm.com; dmarc=pass
 (p=none sp=none pct=100) action=none header.from=arm.com; dkim=pass
 (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fCQB5OMT6iYqcpFzMZCmyRILwk+DVPKGeWatzLLcUDk=;
 b=GJwc8/zSe2nXI5plNrXaY2gkLwat9tG9RjYwV0zIUeHsqKSoZS6gUVQeFizi7H1VAEE8ZV/fYnr5TChbNFpSVWNZLzX7BOLRxwpz5olHSUXzP7cRuqWlOgMfjxBDw2KkHZsGvEc8mb2R5Xf8pAcWScJENom2mxLPtv+/48maaAQ=
Received: from AM6P193CA0077.EURP193.PROD.OUTLOOK.COM (2603:10a6:209:88::18)
 by DU5PR08MB10513.eurprd08.prod.outlook.com (2603:10a6:10:516::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9073.27; Wed, 3 Sep
 2025 09:06:57 +0000
Received: from AM3PEPF00009B9D.eurprd04.prod.outlook.com
 (2603:10a6:209:88:cafe::3b) by AM6P193CA0077.outlook.office365.com
 (2603:10a6:209:88::18) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9094.17 via Frontend Transport; Wed,
 3 Sep 2025 09:06:56 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AM3PEPF00009B9D.mail.protection.outlook.com (10.167.16.22) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9094.14
 via Frontend Transport; Wed, 3 Sep 2025 09:06:54 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=b4ZQDQTECZMvrVBooL6Rp7uDyJuuCx1yqG/ao0iPXDZJVZUImTltv8nJ1hTIo1m/bBKh5QPN2TbM7Km2GacdMywU10qlNkdx+TY3uGuE3iH/2wswngKnjz5kspPy9i8zcHSZYbWIGEZ1cHBi/9pUB2g8wlDhbvKMr8kEHTE+0y3NIwaI8Cro8N0loEtSdnDNg7i9YBB02Qjb24n44wadak4tPAp5pVWFr0h9jCKfINQP0t3hIutHLBYe7ZKshIGCt1+di/M0hca/ycp0JTBXdnALHt122aI9Un6GM/Ntev6LdQJWzcE2lgeid2isjaorIaeSe2xvnFCSkiWdm4T/aA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fCQB5OMT6iYqcpFzMZCmyRILwk+DVPKGeWatzLLcUDk=;
 b=GE3/9mm2z3ybcuT3unAZZkNqH/IHyr2LPAv16yVR1a4BmsOZl3hEXVzLmOX0UoImWcDzesQBd1JvhNKINhjp6xYvkYy11FVCjC1zHG8PJUWZZnMUNn8b3gZonP9p5OAESb4GQn+vM5GBmvZdvGww8ZksO2OjngsWnqf8CZWnRdR96oNyDbi9otqlwwjSqBBchlrTD1hC7fmXRdT18sp4Azb9QM9eH9xax4wE+bmnZjb3P/QH8BuoNCOSm9Mee1kiQt6ZEky2ssZhN3r8hIKIbi3C2CCmKxiEg8y6N9GIGgqH+Yn0cwoaNBYqwGJTeiyPodJct9DcokJz1y/f6P/kvA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fCQB5OMT6iYqcpFzMZCmyRILwk+DVPKGeWatzLLcUDk=;
 b=GJwc8/zSe2nXI5plNrXaY2gkLwat9tG9RjYwV0zIUeHsqKSoZS6gUVQeFizi7H1VAEE8ZV/fYnr5TChbNFpSVWNZLzX7BOLRxwpz5olHSUXzP7cRuqWlOgMfjxBDw2KkHZsGvEc8mb2R5Xf8pAcWScJENom2mxLPtv+/48maaAQ=
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
Received: from AM9PR08MB7120.eurprd08.prod.outlook.com (2603:10a6:20b:3dc::22)
 by DB9PR08MB9610.eurprd08.prod.outlook.com (2603:10a6:10:454::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9073.27; Wed, 3 Sep
 2025 09:06:16 +0000
Received: from AM9PR08MB7120.eurprd08.prod.outlook.com
 ([fe80::2933:29aa:2693:d12e]) by AM9PR08MB7120.eurprd08.prod.outlook.com
 ([fe80::2933:29aa:2693:d12e%5]) with mapi id 15.20.9073.026; Wed, 3 Sep 2025
 09:06:16 +0000
Message-ID: <052c867a-963c-4a5e-88f8-0b2d87d40f14@arm.com>
Date: Wed, 3 Sep 2025 14:36:11 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] mm: Enable khugepaged to operate on non-writable VMAs
To: Wei Yang <richard.weiyang@gmail.com>
Cc: akpm@linux-foundation.org, david@redhat.com, kas@kernel.org,
 willy@infradead.org, hughd@google.com, ziy@nvidia.com,
 baolin.wang@linux.alibaba.com, lorenzo.stoakes@oracle.com,
 Liam.Howlett@oracle.com, npache@redhat.com, ryan.roberts@arm.com,
 baohua@kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20250903054635.19949-1-dev.jain@arm.com>
 <20250903080839.wuivg2u7smyuxo5e@master>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <20250903080839.wuivg2u7smyuxo5e@master>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MA0PR01CA0044.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a01:81::17) To AM9PR08MB7120.eurprd08.prod.outlook.com
 (2603:10a6:20b:3dc::22)
MIME-Version: 1.0
X-MS-TrafficTypeDiagnostic:
	AM9PR08MB7120:EE_|DB9PR08MB9610:EE_|AM3PEPF00009B9D:EE_|DU5PR08MB10513:EE_
X-MS-Office365-Filtering-Correlation-Id: fba99a95-9c0b-4899-f88a-08ddeac93a6a
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|1800799024|7416014|376014|366016;
X-Microsoft-Antispam-Message-Info-Original:
 =?utf-8?B?UkpNV0oxajFQNVE1alIwcEoyWGRkOUdISDhpblk3Zjd0ZFBWVUFqRVlnWTRM?=
 =?utf-8?B?VUVNTi9McUIra08xL1J4WEVBcDdkajI3bFFOeFZlVGF1VjBseHErVHhGdDF2?=
 =?utf-8?B?WlhWSU01TURJb0wyQjlkdTFLcU1Md2IzUnJnS3dYNUlSUjM4cEdpcklLdjh2?=
 =?utf-8?B?dWlnNUh2VmU1elZwWkUzSVU5N1QrY2VjNURkNXhRTm15VUJOSlZPZkhabXpS?=
 =?utf-8?B?N3o2WHR3UnltOWx1akJEQzNPYUlndGRuNVdXUE1JV2JvMlNkRlRSc1UyUGxs?=
 =?utf-8?B?UHd3a0tIR2VXL0psTjg2UlZHcTUyUmErbU1Ka291Z3ZwdGdncVl5MEpKSEFN?=
 =?utf-8?B?ZmRrVDRBZlA0V1FNblFLZDMxSHhEbEdMWlk3aXcvc2J5dzh2YjB2d1JiY1pM?=
 =?utf-8?B?OC9vMVVJZ0tucXRQK0tEOEN4K3NiQVc1RTJPR1U2N2hNbHQrQS9qNG42TFhs?=
 =?utf-8?B?VEtjbVh3UUJkQVRwNzMyWnFNa3lZQ1hVMk1NVE5PUS80KzE4WTNpY2NVbkxw?=
 =?utf-8?B?dTNGelhsOVJZUW44R0lWMTZ1NnJISExsYVZrNU9wMlgxeUJQL3pBd2srRkJm?=
 =?utf-8?B?SEVjb0ZhK0IyTjRrWUVSRzZCRkIvR0Ryc3psZ3Y1OTBFcy9Ec3FzaGFQajRa?=
 =?utf-8?B?TEpnU1B4c3N2WGs2cnV4SldsWlhIa0Ric25hWGgzbUpvS0VHcnA0dDhQdGI1?=
 =?utf-8?B?a1VaMWVTRWR6OWIvMWhGYlBjNHAzbUVTall5Vm11UG5PdFdMYUN3N2ZaRWsx?=
 =?utf-8?B?K2piejNJZjlnWVRZendNZ2JzUGdMVyt2RHgveG9rSXorZUlxTUIrUWJLSVlH?=
 =?utf-8?B?a2I3alBLVXV6NnkxaUYzUFBqdVhiOWo4aHczY2ROM0ZiakVCclg4bUxsem5z?=
 =?utf-8?B?cXpyQUM4RGJwaEQzclhzR0VLVHhvUnNPQzhYd1A4eWltVFJua1B2Tk5RdGN3?=
 =?utf-8?B?aFVWVnBYL1ZtMW8yM3B0aTExT0FkOUZib28zbjNDdk04TzZpdG05WldoVVJT?=
 =?utf-8?B?NmowSFRQaS8vQ29PNExIek5qSFZsR0piNlN4dUtJK3lXZWFxSDdJQ28rOElV?=
 =?utf-8?B?WDNzY2t2OUl4aS9vcXgvY0MyRUtVTmE5UWRZbndkYUJLOFIyWmRscTJjbEJY?=
 =?utf-8?B?cmJGaVN0aUpCSVM3VkVqSVBkaFBZVll6dVVqNkFOeGt4enBKMERzbGNuS0tS?=
 =?utf-8?B?RFpsbjh0RUVYOW5VbkRBVlFsOW5BalBPSnJTTk1YdmMvR0o4V21jS0lsSHFG?=
 =?utf-8?B?VHRDNk9MNTFLZi9yUE9aaUVuNmpHQ2pKMktLVDlxeXM2VkhHL1RSdXVpSUU3?=
 =?utf-8?B?UVBLUzFhVmN5dU4rU1hnWVNKMkRBUlNXdUZpcGt6TjRtU0lIZXpreFRrUUsv?=
 =?utf-8?B?aDIxSWhpTGVDUnl0Yk9hNlNJZ09pQXBBN2twU3pJa0UzeTdLY2EwZ3FiOXRT?=
 =?utf-8?B?NHlwYXBnVmVLYU9kZ05rNS9aT2h1TlljWGJjQ2EySDBZUWpjZWM0b0FGc00r?=
 =?utf-8?B?RERRNi9iekx2eWxnWk1BTXErc25PalFIRVB4T2xaTUlqRVJTanRhYWJjbG12?=
 =?utf-8?B?T3hFQ3c2ejZPNmFuMm9wTHlEZXhvQ1FqSEJUKzc3T25mZlA5NXQxZk9FcmtW?=
 =?utf-8?B?VUJrb2hVd2hIaVV0aDc4N3FqWFAyOURBeElmeUVDZlpNQnVCMDcwRlh1RkhO?=
 =?utf-8?B?UlM0VWxHOGhlOTFpZGlUTlR3RHNWNFVpazByNUxoV2pQSnNUSGdaV0JDV0Zm?=
 =?utf-8?B?cjBOL1Q3QnVBQVFJM0tsTWtDZ1FnWEs3NWpvODBjeWlxcVBqcSsvU0xMUVh3?=
 =?utf-8?B?WGZmc29tS1RGaFhFNHR6dnlzMzNKVFZTMTF3M1Q1NG5LOEVHUVhuWGlnYVky?=
 =?utf-8?B?U1FLWUUrcHJGZVA0aHhmTEJwOHR4dUpDd3AwWDUyUUw5WVZCdTFsemZzSDQw?=
 =?utf-8?Q?sT5qi6Xgp4U=3D?=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM9PR08MB7120.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9PR08MB9610
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AM3PEPF00009B9D.eurprd04.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	4504d372-6d26-4686-b1cd-08ddeac923b5
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|35042699022|82310400026|14060799003|1800799024|7416014|376014|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?WkE4U1NaT0U3Z3poakJkVzlwV0VuMkoyejRjczN0WjFSTThzUzI5OWdKejZL?=
 =?utf-8?B?eVoyOFNhdXBLdGJPVVU1NUtGU2piWHBhMmxPdXF2ZlJTVTMwRVBQbytZN09s?=
 =?utf-8?B?bDNCVDhlUU81TUVwWEpwa3BMWlZ3UEgxMnJRMjlTdkdDd1R2dmdKV1QrTjkz?=
 =?utf-8?B?RFh6QWFVUlZJTlgzYWxINTBHS0JJRW9QSW92QStTQ2xST1piVEs2eU9YSzE0?=
 =?utf-8?B?WTBYektESUNaNWV6SEdRbU55N2lhYXBtQ2pWdFF5M0ZTY2t3RDlreHplSllu?=
 =?utf-8?B?dXcrRGFHdzlMdllvMmk0SkNXNko1elJadHRBREwvVDVJY1pjMlB6WUtZK2th?=
 =?utf-8?B?L0REY0ZpQlkydWtvWHpxbTFXK2Rhd3lCSE9tcjVSeTg5ZS91MFVZbjBTeUhC?=
 =?utf-8?B?c2EwN044dHpIeVNjODNXeVJhTUJMam0zNFhvQUJHaE5mRE5ZK0R6bjYvV0dV?=
 =?utf-8?B?am1LVW9MelpRcUZucFhpV2E1dWFvNUpkWmd2NmJZL3hKNDZBaUx1UUp6ekxQ?=
 =?utf-8?B?Tjl2OUhZWjhUaWZTenZ1NWloblBsS0F2Nlduazd4UDkwR1lYMDJBcmdCSnov?=
 =?utf-8?B?dC9HK1o5OHBRQWR2SnUwK0FhWk02ekp6a0FMQlRoM3ZWbGlMNUozTnE2MUpv?=
 =?utf-8?B?Z2lWSTEzZm1zRmNPdlNkNExmZDdobnNtbTZ0UFRBdlhKazdOWHd6Vk5nKzA1?=
 =?utf-8?B?Wm5VR3k3NDQ2YlB0Z1ZnNkxHdWVYYjlnOXc5RkpVdzdVbTJ6b0RJOTJUOS9O?=
 =?utf-8?B?VnZMNjlsWjdvKzNsWW8wL200ZExMSThMelJ4NkNLYy9KUmJSVWovOXVyNkQy?=
 =?utf-8?B?OHhXYnljdDNKbDh3TzNTSEdNcmtYTG1rTTZjMlk5cy8wcEdWdGdMRXdEYmVZ?=
 =?utf-8?B?U010c2ovaHh0VnMrOWRaVGYzbmRweVR5RlhQTit0cUY1RnU5MXM1YVJDRnBC?=
 =?utf-8?B?NERTVEM4WmtnNG8yNGRZV0tvWmd0WVl4RldPWk1zVFRjdXVvaUFrc1I5b0Mw?=
 =?utf-8?B?WGFweUFVWE8wU1FKeHg2elBrOGJjVDdzaUUxQnVmUG9jMHgyWjcrR0xFbHRO?=
 =?utf-8?B?M0ZURHpSRGZDWlVJTU5XejUrdit1YkIxOVZWUVh2emU5YXYwVTUrOUFGZHB0?=
 =?utf-8?B?aHp5MmJiaVRyNTh0TUEwMlJlbDUwMzhSWjVCME5XVnFWZ3pmcmlxWTM3ajdI?=
 =?utf-8?B?aVpnT0llSWdIZ3pQY1M1SE1rYnBrSyttU3B4SjFPSWxmRGpGelo4ZXA2cVZQ?=
 =?utf-8?B?b0p4bStzeE1ma2NLT2NOeGlzL256ckNBZ1hsalFzRi93bE5KZENhbjViVDB0?=
 =?utf-8?B?bWdwa1JJWlFuNlpaR0VObjJyNmFWVzlROEJLWXZaMmx1UTNqTVFKV0NNbEI1?=
 =?utf-8?B?TXlGMTdhMUc4YUhlT2FRRURrY0VYMzd5QWRJSFYyRnd1d1J4eGhldm9CN0tk?=
 =?utf-8?B?UzZpRUdUeXZnc0p0K1I0NHhmSkw3M1cvZmJTYWNwUWpVZzlKa2ovUzJxYWtx?=
 =?utf-8?B?RmMyeVkxSG9zdW50VHl6RUkrOGZtOUhVK1o2MGJZR0VjNG9XMjdSQVQxYTAw?=
 =?utf-8?B?c21QWDBzdkh5WUllVmhZZ0M1amljNldNUDFhV29WWm5mSkZTWGZEdmE3YjZQ?=
 =?utf-8?B?dXhZTkdWRDVLYkxsNE9lWmpod05BMFpMeS9oZjI3Q3BXcFY4K3I1dmgrMkpS?=
 =?utf-8?B?L0JDbkhaSzd3U0FmbnI3cFNXanZIdXNYbFRYWUtDbXk4TDlmTlMxLzBpVU1B?=
 =?utf-8?B?a3YwSlBycC9laVB1cDJ3OXVQQytqRERNbGxCbFdVckhTV3BlWkhEcXdMd3lD?=
 =?utf-8?B?WEliWUZlODNkREZBKzYxUGlxZ2JwTFI4UEN3TERDdEdORUFlVWkvbUJ3S0xG?=
 =?utf-8?B?UEozY0JnQ2ZwL0tma2JVZ2ZVK1F1T1BpTVI2NEJNNmpzZ2lDZnNvRk5NaUhm?=
 =?utf-8?B?aDRlamdvZ1dCZDhDN25pdXVaM0tvaEJWcWtSWTIvOUpkUStNdUlYK0VablJV?=
 =?utf-8?B?Tk13ckkzSnRsS1FxV2YwTkttc1YxbFJTKytuaytDOEl5bjloNVVOQXJnWGZF?=
 =?utf-8?Q?D7V98Y?=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(35042699022)(82310400026)(14060799003)(1800799024)(7416014)(376014)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Sep 2025 09:06:54.4950
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: fba99a95-9c0b-4899-f88a-08ddeac93a6a
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AM3PEPF00009B9D.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU5PR08MB10513
X-Stat-Signature: c5uhdbqnngc7g7g5thzg7ycdinpm4mjh
X-Rspam-User: 
X-Rspamd-Queue-Id: DFED940002
X-Rspamd-Server: rspam01
X-HE-Tag: 1756890420-649222
X-HE-Meta: U2FsdGVkX19INFWnIUeCriI52FdWSFujyaFDo5/yJ09RxttwLqGAA6WNQ/ATYkMWRUl5eyRRM8bWVzkPO6Wcnd2M6ymOYPznLQnIYxR3j+I587pWoPh73fCODLEnAdMY1mKJwURfNV4vfY8kIozggOjUT9056pShqzyjTrvc6hwBluxoKsHAPLePl3mmkGUcnq4Oj9TgYPgWAColemGafJRTp4VuF/3OzAnVz0fenMtkFmsZ2sLDeGmr0rooJ6bMdlk72+cx+IE4zsoaW7kaA7aajEYZ9pQWdhl1PMreJV/sJVO56FxbFi6Ei4ElhfSuW6Y5ccG3+fe52zXlnv1Uwd+7IW94wX13KZzepT8rjgnATfkf1rnc6WcoyYWjLfjuZJVoNeN/9kYlAaoeciCPifm9U3QAf0tSNig+j9g9d+fp5gGldV0/W4WtGs4SM1DSxIsIyId8UoGbOs127zm85QaHEJkfJUMzwu6GMe6QxzxqkcOLRMEi80rnaIq97b9u0avFz3u5f8yfyWm8XNJ1F5xdc07q7DUVVHjqie8g9fZu8rWbup7yGDNexmBC0MorWY2uN5c+D3B56vfroTuyj+SRUDIpga6v+TcH7wLnOt6NqWgV1W10P5kgtll8xsOdGMVqyaPpPHZBxPkCtXvfAZ6cBF9qu11ll1KGA/gxJjTc9bj566703Z6NzOeYsAVqrbeJy1bl1yHAxdAZ3+UEIqqkpoYCKPkG77cIs14tbrOaL39eEeNV97EEBq7y9hDIExHhfwEPQCM8SDDdRyh0A7UaafTA6THxb7GPRvLvwkCYvZWCPOv9rrZ1cTiYs1/bR+zCShEXUgu9dpE3KPXErN6PxImcNAoGXimUlgaKfyEYCO//OBSz2TDIIeEu0FjFb3DBuJ08RMIxZ/cMURFfzzrgs3uM9/k09Wtx15Qutr1gtKtMyToONOvu8hfsj1mDdk0u5juU3uS4P3tdcOa
 41d9fE3t
 kcOTlIBp6upuRdkfLFhv37YPYzmXIirjPv4aN4I8FP2TffdNIvl1C72nAb4h6oqj62+j2Wl5p3f464rxqfWeSFr5fLAJI5AhkGQRc7acHEpGw4+SR2HHN/Pg5RG3wNN3UoTVKdS+pRKz7E/dzo3/Q7jYsAEWlqZ8oB3BGLEjH0RDXhOrQEQEJSCovCHq/dmbCFM9gI6fWW9BdMpIv5GyT8dNBQBxtXDvQCK8dFHR0zrPRh9E38wcVwWaeAEJ9hpBT58EpLSYqQIx5vn27QhE8YtDqsOd58qJ6YFOUFvYGT80sb02IXJt0UJySP7XbmHVZa64TvduFuilZSEdIpawu4RytqD6UuN3y032hZIuepgFOl2e/pE0GmCzhGPyRI8jkTYSJA3i1pdfQxq71eRV6LnkS27UX0AMz4RxLnT8lkZx6wwaEky5UDPwV+7pannneNBqljebfAHBhKc65iZq9+TBqoGfgAppOHzHmXQfbgqlg20TFF9WTwdF2zVRu1h84j7yb1icJcQYlLeaEo3lb3Q4mD6BHxvWAzOZhpaSeOtrsAziGeMXYeMY4WJTcLZH41WGwKPglZEK2hdYWNLHjB0Zv+77JfImIfNKHLxC5nH/iJr0VdaLIg+z/Q9+Zu7/SiULLhEuGLHcWwbdLtiixopHRmBpWsKxak988QHCfD7gzreA=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 03/09/25 1:38 pm, Wei Yang wrote:
> On Wed, Sep 03, 2025 at 11:16:34AM +0530, Dev Jain wrote:
>> Currently khugepaged does not collapse a region which does not have a
>> single writable page. This is wasteful since non-writable VMAs mapped by
>> the application won't benefit from THP collapse. Therefore, remove this
>> restriction and allow khugepaged to collapse a VMA with arbitrary
>> protections.
>>
>> Along with this, currently MADV_COLLAPSE does not perform a collapse on a
>> non-writable VMA, and this restriction is nowhere to be found on the
>> manpage - the restriction itself sounds wrong to me since the user knows
>> the protection of the memory it has mapped, so collapsing read-only
>> memory via madvise() should be a choice of the user which shouldn't
>> be overriden by the kernel.
>>
>> On an arm64 machine, an average of 5% improvement is seen on some mmtests
>> benchmarks, particularly hackbench, with a maximum improvement of 12%.
>>
>> Signed-off-by: Dev Jain <dev.jain@arm.com>
>> ---
> [...]
>> mm/khugepaged.c | 9 ++-------
>> 1 file changed, 2 insertions(+), 7 deletions(-)
>>
>> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
>> index 4ec324a4c1fe..a0f1df2a7ae6 100644
>> --- a/mm/khugepaged.c
>> +++ b/mm/khugepaged.c
>> @@ -676,9 +676,7 @@ static int __collapse_huge_page_isolate(struct vm_area_struct *vma,
>> 			writable = true;
>> 	}
>>
>> -	if (unlikely(!writable)) {
>> -		result = SCAN_PAGE_RO;
>> -	} else if (unlikely(cc->is_khugepaged && !referenced)) {
> Would this cause more memory usage in system?
>
> For example, one application would fork itself many times. It executable area
> is read only, so all of them share one copy in memory.
>
> Now we may collapse the range and create one copy for each process.

I forgot to add "anonymous VMAs" in the patch description - for the case you
describe, the VMA will be shmem or file VMA and this patch doesn't concern that.

Andrew, could you please change the first line of the patch description from
"Currently khugepaged does not collapse a region" to "Currently khugepaged does not collapse an anonymous region"?
Thanks.

>
> Ok, we have max_ptes_shared, while if some ptes are none, could it still do
> collapse?
>
> Maybe this is not realistic, just curious.
>
>> +	if (unlikely(cc->is_khugepaged && !referenced)) {
>> 		result = SCAN_LACK_REFERENCED_PAGE;
>> 	} else {
>> 		result = SCAN_SUCCEED;
>> @@ -1421,9 +1419,7 @@ static int hpage_collapse_scan_pmd(struct mm_struct *mm,
>> 		     mmu_notifier_test_young(vma->vm_mm, _address)))
>> 			referenced++;
>> 	}
>> -	if (!writable) {
>> -		result = SCAN_PAGE_RO;
>> -	} else if (cc->is_khugepaged &&
>> +	if (cc->is_khugepaged &&
>> 		   (!referenced ||
>> 		    (unmapped && referenced < HPAGE_PMD_NR / 2))) {
>> 		result = SCAN_LACK_REFERENCED_PAGE;
>> @@ -2830,7 +2826,6 @@ int madvise_collapse(struct vm_area_struct *vma, unsigned long start,
>> 		case SCAN_PMD_NULL:
>> 		case SCAN_PTE_NON_PRESENT:
>> 		case SCAN_PTE_UFFD_WP:
>> -		case SCAN_PAGE_RO:
>> 		case SCAN_LACK_REFERENCED_PAGE:
>> 		case SCAN_PAGE_NULL:
>> 		case SCAN_PAGE_COUNT:
>> -- 
>> 2.30.2
>>

