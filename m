Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EF8C5CA0FFF
	for <linux-mm@archiver.kernel.org>; Mon,  1 Sep 2025 15:26:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 59DC58E0068; Mon,  1 Sep 2025 11:26:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5770E8E0003; Mon,  1 Sep 2025 11:26:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 43CE28E0068; Mon,  1 Sep 2025 11:26:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 312828E0003
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 11:26:52 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id ECE995BC84
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 15:26:51 +0000 (UTC)
X-FDA: 83841059022.24.36338B8
Received: from OSPPR02CU001.outbound.protection.outlook.com (mail-norwayeastazon11013058.outbound.protection.outlook.com [40.107.159.58])
	by imf19.hostedemail.com (Postfix) with ESMTP id C4F8E1A0008
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 15:26:47 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=arm.com header.s=selector1 header.b=EhYTruNG;
	dkim=pass header.d=arm.com header.s=selector1 header.b=EhYTruNG;
	spf=pass (imf19.hostedemail.com: domain of Dev.Jain@arm.com designates 40.107.159.58 as permitted sender) smtp.mailfrom=Dev.Jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=2")
ARC-Message-Signature: i=3; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756740408;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=60IOWGbP82fICTHG+P8XAtnKmDk6oERng8AQ6l6Zw3E=;
	b=d7zle2oWsX88+6sgfQBXH9f5N60TVNfTxphBpuETHkJGi7pWJYqMPWZn02GkI+Sv7sFsNg
	l0GGaatWTxUaP/74pkJCql4OFfIywp2a+t4tcrQJ3EYILsjPVRrE93M1d+GvdFcR8E19x0
	jLMSeBd6MT6ot+52deMXa3vMZ5jMnoQ=
ARC-Authentication-Results: i=3;
	imf19.hostedemail.com;
	dkim=pass header.d=arm.com header.s=selector1 header.b=EhYTruNG;
	dkim=pass header.d=arm.com header.s=selector1 header.b=EhYTruNG;
	spf=pass (imf19.hostedemail.com: domain of Dev.Jain@arm.com designates 40.107.159.58 as permitted sender) smtp.mailfrom=Dev.Jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=2")
ARC-Seal: i=3; s=arc-20220608; d=hostedemail.com; t=1756740408; a=rsa-sha256;
	cv=pass;
	b=1OYRUX+YzFQteqHbG7PlJdaFLylogKR+AVlREa7oYMhqXUbQpGc38014ydy8/slf6AVJ2x
	+XB9hjjj3sBm0qm47m3pfpomPBom8oFzqYZoKOqcFAgPk47JEKWQ/LXlpxfFIH++GrA8qf
	mW6NMW4IIWHCs59Q+XM7SlxYh3BgMHc=
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=Nb2xUBqmlRzTZWK2h2iC6aPPGbFf0ZUsuFEeqHQb7sJkpqOSjy6WvDpg684BtAAyeAslzPBtoX+PqDiUjKkqM1mlIzkd8aJa2PvLvGkfa60uzbSS7ZcaU9fudITX9XtC7giDuLcHdouXGtFdLzblSE66IzNgqZjVEWer0FvHt+ci18I7sudVT9JRcI1xwT3UkgXURzKy+ZirmTFO6oUojUWd5XMPOhIOAIPPF+fk1opfQTPWK29tr/VzAIZ4sLUoqEzFI4SX7KB2N5cSTttZEiXVnCC5WnLxtLEJiSyk2QGurEh4ZrYlLURWAPD8O/v3KIbiN7edbTfinjIHRk20Mg==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=60IOWGbP82fICTHG+P8XAtnKmDk6oERng8AQ6l6Zw3E=;
 b=sWRCks8D+mqypN4IXHtszosiVRLSxp2kdsUGsFeqGUdD4PPdwlaNhCHB5b0d73pKqt0/kLUU0ebWIbMGbrLvSgQ1XdWlchHGG5g1MWAOGR3sXG68HTkcmcm/ZbPKL9jlJ6fbWIxCt7rWZ9a/gOPzPZeGYrQc/flw0jx/LoFIW6AGtzzz8fYICd8ZaoE2JJ3xttYaPLT6x8ILGOdegVE0B5DtX0bmSeZO0gi6PJ+R+hif7DRenUI5VLuT8ex46lqkdQZ0LgyvXncmL0bRz3d8M78ebM4i6RXM0pnhAMwDsdALTQqRlmz5fyh8syMcyYNvYeEby+kZBi/W3vNooVDUIg==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=redhat.com smtp.mailfrom=arm.com; dmarc=pass
 (p=none sp=none pct=100) action=none header.from=arm.com; dkim=pass
 (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=60IOWGbP82fICTHG+P8XAtnKmDk6oERng8AQ6l6Zw3E=;
 b=EhYTruNGC5YIC20dbgx9QYeDZA59YoUM6TYzyCspMOOvQyDBlVGJ2qtcm8tel7rJFg7HUo+Vmg5m4jN4jJWf7B40uk8KrJF9itvsjxK2cgT/S3XAcwZdDRg7WR8ySOV9Of5YWncTiHN03DWZKsXXPm4wbFmtvXpJYQo+DPq561I=
Received: from AM6PR10CA0087.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:209:8c::28)
 by VI1PR08MB5373.eurprd08.prod.outlook.com (2603:10a6:803:131::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9073.21; Mon, 1 Sep
 2025 15:26:42 +0000
Received: from AMS0EPF000001AE.eurprd05.prod.outlook.com
 (2603:10a6:209:8c:cafe::78) by AM6PR10CA0087.outlook.office365.com
 (2603:10a6:209:8c::28) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9073.26 via Frontend Transport; Mon,
 1 Sep 2025 15:26:42 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AMS0EPF000001AE.mail.protection.outlook.com (10.167.16.154) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9094.14
 via Frontend Transport; Mon, 1 Sep 2025 15:26:42 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Vrh5F2TgZ5BqmisfxCbdLScVKxXyYuf8Nqayemy0b9gG6B3ivAmRazNHKDeRRwG6UXJiWNRsEbVOfvlj0ivmDfZJst2swF33nW8D1rgRiNyqZtx5NUliAXhGJxwFVlDw0sABOzrMSYG0mR4aGkuuUzAzlQt56xVe2YT8f0b7DlcAqBX4/WpNHxBJYI/Hb546+5XciU4Gs0PwJxEJDLWl+biV/mfLCREVeI/sYdgcP360/+ub/hR+tCDrySnx0u+6RTjpIlTNxPhAOLL6bKGFUzvwFPlVsHzhcZ3njxyBTaQVQovut/u3203hNMV6X0xtNZnsfN8xC4h0R9IkUUIM3Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=60IOWGbP82fICTHG+P8XAtnKmDk6oERng8AQ6l6Zw3E=;
 b=LWH22ox/fwN8Q5+0ZNFNRCODmpHaC3OtfL08pzlivWwEgiKQf5XWZT5/wXf2rCb5NbAwp63BVS9zC5HbkYauCNnZM/h0WaZlOtwlHFUe+LN4/X8n7KyzxEJ0ixjzvuVmZK3PDNKPIo57b2BziIHWmjlWsJSjOAQ7mwKSxdQ6LXy/Fn0MvZfN0XCcdJAHBADxO3/xgoTRwjMAPWYv1F3UTpPi48LVTMb6omgUhwhvzF/MuPr+fZgy8heNdoapT4c70AssTJK+ZBq0gRGs4C7w7ElRXQzA4ZCKD8vAa3eJAD+Tpwoy90DFptNaWPe1topZQU4ab1BGbtZ622M2KFVOvw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=60IOWGbP82fICTHG+P8XAtnKmDk6oERng8AQ6l6Zw3E=;
 b=EhYTruNGC5YIC20dbgx9QYeDZA59YoUM6TYzyCspMOOvQyDBlVGJ2qtcm8tel7rJFg7HUo+Vmg5m4jN4jJWf7B40uk8KrJF9itvsjxK2cgT/S3XAcwZdDRg7WR8ySOV9Of5YWncTiHN03DWZKsXXPm4wbFmtvXpJYQo+DPq561I=
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
Received: from AS8PR08MB7111.eurprd08.prod.outlook.com (2603:10a6:20b:402::22)
 by PA4PR08MB5902.eurprd08.prod.outlook.com (2603:10a6:102:e0::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9073.25; Mon, 1 Sep
 2025 15:26:10 +0000
Received: from AS8PR08MB7111.eurprd08.prod.outlook.com
 ([fe80::4ea7:7e71:7dd3:3b45]) by AS8PR08MB7111.eurprd08.prod.outlook.com
 ([fe80::4ea7:7e71:7dd3:3b45%4]) with mapi id 15.20.9073.026; Mon, 1 Sep 2025
 15:26:10 +0000
Message-ID: <e52cac79-fe1a-401e-9259-747a4d587bd1@arm.com>
Date: Mon, 1 Sep 2025 20:56:04 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH] mm: Enable khugepaged to operate on non-writable VMAs
To: David Hildenbrand <david@redhat.com>, akpm@linux-foundation.org,
 kas@kernel.org, willy@infradead.org, hughd@google.com
Cc: ziy@nvidia.com, baolin.wang@linux.alibaba.com,
 lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, npache@redhat.com,
 ryan.roberts@arm.com, baohua@kernel.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <20250901074817.73012-1-dev.jain@arm.com>
 <620f01b4-8a6c-4dac-bcdd-7c48f5cd87f2@redhat.com>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <620f01b4-8a6c-4dac-bcdd-7c48f5cd87f2@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: MA0PR01CA0103.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a01:af::17) To AS8PR08MB7111.eurprd08.prod.outlook.com
 (2603:10a6:20b:402::22)
MIME-Version: 1.0
X-MS-TrafficTypeDiagnostic:
	AS8PR08MB7111:EE_|PA4PR08MB5902:EE_|AMS0EPF000001AE:EE_|VI1PR08MB5373:EE_
X-MS-Office365-Filtering-Correlation-Id: 1936e873-fe9b-4dfe-81e4-08dde96bf411
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|7416014|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info-Original:
 =?utf-8?B?TzRJbDJMYkdOeXl3MjEvd3FyNnV4KzdHeEhDNHRkY3ozeTE0cFRCcDI2WFN4?=
 =?utf-8?B?anorM1VuNWRlT3RFc1QwTW1nalp3ZFh0dmJ2dGxpVURPZ3UrcXoydFA1YWFk?=
 =?utf-8?B?U3ZKaW1EM25jQkxqYnFDdFlEbVVZQTZmc085ZXNkNEJqb25sSVZxTVAwRlY3?=
 =?utf-8?B?MEhHbk00NzFoNXFJVlhzUWwzaXNhQnY0aWcxeGNvS0F0YmJqUUpTSUFOUUE4?=
 =?utf-8?B?YUVzNDZaeG5XTWVkbnFROVNjWlpDdkk5TzdRZWk3M2ZVbXNnSWF6UDQxOElR?=
 =?utf-8?B?RWZZK0ZFazVuV0tTWWRXdVE3L0loUTVuQUplakcvbnc3QmZEU1ZocE90RDhN?=
 =?utf-8?B?ckpEeWg5UDlpYkwrbHhDeXhTWVArSFJWc1FjVzVvcWNITjN0TnNac3llS2Rw?=
 =?utf-8?B?WElYYnhVNW9ySU1mWm91ckZ0U00vcWdwUHVxRWdmMGNXTlJhTjNZaklBczVE?=
 =?utf-8?B?cWdJWUNnRlJBTG55YklQZllqMzRYWHBUTGxlODRUWmF3SDg1NVZhYklLTTJl?=
 =?utf-8?B?Z1dDZ21ESDU1U3B3aFFPbU5oL3hYbzJOMXg2K0diVTlMRDd1ems2Yjdsa1NJ?=
 =?utf-8?B?RGVRODR2VHZaVDZwR01XZ3k0NHdzS2tQTmw5NmVTODRITHU1SEhKZGZXK2x4?=
 =?utf-8?B?NWhnQWw3VWFycmkvMmtmcDRFUmFaTWdOUmJNMHFlRmpjZnhjamdpZ3FZQmlv?=
 =?utf-8?B?MEdMdUdJRE1sWTdXTStyTWVBSXViRFVpd2VGODk2UVpMMTJZOUZySHFORm1L?=
 =?utf-8?B?UFMxejhtWUdWTHorQ3oycHVVNFBVYlkvMEpUODl2dE5KR29kVzYxa0ltZ3RK?=
 =?utf-8?B?dW9YVDgwSlA0QVRwdXhVby9OczRTNTdqb2pLZC9NcTlUc2toN0piQ0c5Y0NL?=
 =?utf-8?B?VmF4bzhJUmZjdkd6N2lqM0w2a0wwVGN0TU1HY2ZKVzJUdE00QWx1VEo2ais2?=
 =?utf-8?B?N2xSRzZBSHhQOGttT0R2cFBGYjdHcGpEc0Jya24vekowY1l0U3p1eEgzeldm?=
 =?utf-8?B?SlJFWUZMeCtnWXp4R0JmWmd0dDA5Vmx4K0RRVmFhelBuWERnWjhEUkhYSGNn?=
 =?utf-8?B?ZGpiTlZxVHZ1ZHZ4RXNGWllES2tBbUNKSFRrSUtqZFMrR3pTeXhDSmpVVmxs?=
 =?utf-8?B?dXNjWVVFSVBKUE1PK0FGVVdmSS85WERza1lKZVIrZFRkbzhmRlkyNU9Balo3?=
 =?utf-8?B?WTREUVNqa1dkTWtXcWNMTTF1ZE51ekhxOGFGekxDcXg4N0R6VXlqRW1JRnAx?=
 =?utf-8?B?d3V3WXh3YS83dW9VZm1TbThNUUpQQVltR0VFVlFIMWNCZDV6ME1QT2l2UkxQ?=
 =?utf-8?B?V1hSdGoyZFRrd0NMZmFndGRZMkdKQTc4SGZoMnhieThoN29kVlZmOTFRUUR5?=
 =?utf-8?B?ZGRQTCtyYUlnNlhySEIxRk5MUEIxTEFGcDZGKzhjNVNuU1Z1ZjhhZmtmR25F?=
 =?utf-8?B?c3VIMFNFOWJlZjJUb00zTXFXaE9rRVg5eU0rMGU0dFZJbWtMQllFZDF3cGc5?=
 =?utf-8?B?cHEzVC96UWJ3S2xyVjNHMFlGTXYwaHdEQUxtZmErRFpzVHRKZDFJM1hPeXQ0?=
 =?utf-8?B?U1JEVm5MWlRxOCtISmY0bjZLeVA1ZU5WMlVuYVdIaytVaGxvNnltYzBNRWdM?=
 =?utf-8?B?ajlmbHphU0VWVXdlZDRaSUYzYU5UdWF5UFdPSTBiOWtkelVJSzdZMXhxZ3dk?=
 =?utf-8?B?bDVKbDN5RXdNVkRvY21NQ2p0cUhQNFVJOHJvZlJjZ1ZXWDIzUkQ1c0Jsak1Y?=
 =?utf-8?B?U05TaFlWSzUxK0lPNlNqTVViajY2SWZRbndpeGZyVEZJeUdXWFlmSkM0eE1x?=
 =?utf-8?B?NjZHRDdpeDl4Y2dPN1NmNW0yU3c0UHNwK3pDSE1zSzNFSU44RFlLSXpLQ3dG?=
 =?utf-8?B?M1VvTWRnN1RhelYrcGhhQTkxWHE0NHF6UkVuQTVsZk0rQWF4YTZzcWNqYjMr?=
 =?utf-8?Q?HSxlOHTpicE=3D?=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AS8PR08MB7111.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PA4PR08MB5902
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AMS0EPF000001AE.eurprd05.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	a3d75f15-6b51-42c1-5abe-08dde96be0b9
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|35042699022|82310400026|36860700013|7416014|376014|14060799003|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?aEpqS0hSWDVXZjZQb2ZOSkdCb1FnZmtIWXFFeHpEZGVJY01BdWlMd1Vzd1h2?=
 =?utf-8?B?Nk5MNkpYTEdTTjJiZHI1MGVxQjdaRHRJNUwwOXUwTzFzZUw1cEJUWXljY2Jw?=
 =?utf-8?B?SWJHVlZ1VFA3YVBZTU1MbnkrdEJiN0ZISkdRSlQ4MnJnQ3RoUHVOR05QSEVE?=
 =?utf-8?B?TmpQNUJSL0NFbGdwWm1ncnNNb09ZYTF2NzY1Z0VaT3l2ZjhHNmpZSkxocFFN?=
 =?utf-8?B?enpvMmE4cEhuWWQyR0JpZ0lBYmpLMmYvVktCdXNQUzBudVcvNTdBUmhtaW05?=
 =?utf-8?B?cXYrZGtaUS9oRnVtVFdTRCtYOFNUV0pmc2dUd3I0N0pQMFMwVzFKai9PeUVL?=
 =?utf-8?B?YjBLY1VzeEVLTjBLS1hSOFF6bGt0MDR6dUI4YStYV0tuVS9sWWVDbE9BMnpK?=
 =?utf-8?B?a2pEUzIzdHhyVFNMZzFoN0JxZFRUb09rVklrSGpYWGlNVnFGK3VJUjJxc3JN?=
 =?utf-8?B?Q1BoMUM4L1ZHMzFBQjg2RWNmMFhWTVFaVjNWc1h0ZWdEVVBMS0FaY25oWFp2?=
 =?utf-8?B?Y2pEcDByYzBRS3JacmVJM3U3Qy9Md3AraHI0QXZUVUdySkNGNVczYzh2czJz?=
 =?utf-8?B?dmxZMnpLN2QrRDI3U3VRcVZNTFcwd2lDL2ZOK3N2Rm5lcEpwbDByd1RRRFQw?=
 =?utf-8?B?Rlp4eW5LV0pPd2RtZWo1elRQdG1CQmQ0Z0l5cjRkdWRlUWhSczlmNW9kdXRI?=
 =?utf-8?B?cXBhMm1KMkhrU01TUWN4bWpPckVubkhnRFZMVVYvWHNSNWZRWmVZMmZISWhD?=
 =?utf-8?B?anhtRE9td2M5clRHQmhsMnAxeE5aWGZJQi90Z0NTQ0FKQlN0TDhnb0krd1JM?=
 =?utf-8?B?S1I1eHZBRjJzcjZ4dW9iUDNqWGZqMGRoYjdybmorTlRqQ3B0blp2aGh0UTlF?=
 =?utf-8?B?dHNlYXd6UnJ6UklLemd5alBiZG9JRTcrUUs0SlFPOTZPNTFYR3kycUkvS1ds?=
 =?utf-8?B?V0NlVUIyazg0UEdaa0UyZXE2VHNNUWs0VjRHRzgva0trcUhVRU9wZFJkeW00?=
 =?utf-8?B?R2txMzNMOU5zZmUzOTExVkhlZCtFM01jckxDV3VzdEM3VFA2NnpjWGNIQUtQ?=
 =?utf-8?B?ZHgyVjdwbUdncEtHYXlQTlY5MHY2b1JHajZ6aTFlK2loM2dacUoxbGVweG04?=
 =?utf-8?B?K3k3Z2FSN2tDY2g3OCtjUXZCUDM4MzRabjB2VE04WSt3eUdJRkhHdzUwZWR6?=
 =?utf-8?B?bXBxZ1RybW5TSlo1ZExWRzd1VituSEdJT1ZFWHpNSC9MQW9EUHRoRXpubzg3?=
 =?utf-8?B?TmdUQmVFYkMvWG12eE9YWFBDV2RXS3VGaFMyeEpkd1pqaVJIRmFKU2dLaWZv?=
 =?utf-8?B?ZmlZNDhxcWVBL1ZGYXhYZ2RVNFBSUE9ZS05mRHNIUDNBUGw3c2tPRjE1OVFx?=
 =?utf-8?B?N3F2YVdZTVVUMzFiV0ZSelhWRmJMS2MwQ1QxVndJZlJKb01PaGtrQkdtWE9N?=
 =?utf-8?B?c2p4REVFc0NBVWVZUGNZb1hsaWxrc1JRcjdWTXVnVGs5OXJIaHRaRzRsZnN3?=
 =?utf-8?B?RUN2cSs3NEdwZ1YxMWlKMFp0TE0zMVVuQ0l6eWZudjhGOW1JSHRyTWdaQ0p2?=
 =?utf-8?B?dkthQU4vUFlFcE52TjlWa3YxVThJd292ZzdGZHgybXB4SkV0NVphempobUt0?=
 =?utf-8?B?UGE0ZGgva00zcjZiMWJjVC9kWm43UDJRUi9jRHVwMkN0Mzd2OTJvb0t0aXJl?=
 =?utf-8?B?T1hWRzMwNWk1VDlKNXFFamdPVUQ4K0dXZ0l6cDdmZHpmcmJHZndRVkkvS0hE?=
 =?utf-8?B?OVBHNmE3bWp0eXc5eGo2bmo2clBzSTdqUndOd2xISjBiNVl0ZEVUN29NZFcy?=
 =?utf-8?B?TzZxT3c2NUpCbFU4UytJTWd0dXhqR0wxOFhtaU81TmZ2Nms1RTFtSktPdnIw?=
 =?utf-8?B?RmxpS2FxZ0lUS2NIenE4Z1JrUktJcEF1NnA1WngrMUNZT0p2TklGZ29sNEtv?=
 =?utf-8?B?VjRDa0U3UVdxVjcwSGVVWkkxK0N1bFdrU3VGS0NEQWl3TjVKQlBUNllEcFJ3?=
 =?utf-8?B?MityU3BtTUZxQnpTQ1VsQ2xOOEEycS9MZE9XdDc3OTQ5MXFscXZaU1UzQnZQ?=
 =?utf-8?Q?gaVB77?=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(35042699022)(82310400026)(36860700013)(7416014)(376014)(14060799003)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Sep 2025 15:26:42.1102
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 1936e873-fe9b-4dfe-81e4-08dde96bf411
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AMS0EPF000001AE.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR08MB5373
X-Stat-Signature: z5fnqms3cwjdrceiicujc6px38dpwt53
X-Rspam-User: 
X-Rspamd-Queue-Id: C4F8E1A0008
X-Rspamd-Server: rspam01
X-HE-Tag: 1756740407-586127
X-HE-Meta: U2FsdGVkX1/kBIZiByhHTr0JZXEdoJSwKeP4WUnoKDlOJzBODmhqmdNfEy+5q3baMQ7k8D5GKBi2XMhobnbXPAaoDdSTth/aJ7EgvCVTOLB8db041RDukZAhMuc0LS/h6PhkHeJekVCC5PCuGp1EZgFumMcgfzGX2zrZUq4X0jhOwYRZXnKK97M4GDiViSC+xzb7UAdklpu3jFSmMtxOlKBL4sBWx/izpQap3dDZD9lDt+nzy9SDvNKC1G3YuPgzlasWllBwfVvC/OxSgAgMyahJu+/3Wwic2oojgxLT/ZYnmSIHG8A2wMFvcee3rJCAABDbgClEXCo8MnuM9z5utieqjfhZ0muhPGLP20K1sv2d9P4WW24CvuI9LgdQx/1MAcUzBvDLPiGUpki55wURfR4AgFzQXjPq7vNKEgeQnqXzUJTvFeVKg053KUWn9W18BgoLWRZ2oRn2N7KjfgO5e2RQX+/AKg76D5tm/EhHp2TE+U6wsKpBjKY6ZRMB5c/I1G6KRlJWTcpmelyxLwB9MVEWFPD8CTi5+z1ncIY8lWv5d7DDrlNDaal55LcipPNiaC4Mkz2SfHuJCWQnVU06TptSemVjb42nhMqcCGQKukdDrItJmLHLUaPRKaGaCIjfUnGB4Q9BaAYqqpWwMVTQ1etjegGRtt7OBAwkBK2RgL7a6tFXx5x5sHny/Fv0gUP2zNfHfAhdZ8iva2nTxFYurhLVKIm8I5KPX70pBGn5pTmCvtNCstkdb3d6xrSAIdPGyfzYRzwCsnKJdrnSj57KXD0HFBGEQvRd6Lval6PNKdyVviSvp64BhxUexTWd6pAt2XZst0JrUQ69Jp8HZ9GlSocTuUBS6k/q0K8wdsblLDluEmQ6ZbSF262iK23J3oaoC04Ij2QzKX3ehbjG5x2vl2YW4pZEKUID0+DwJEFKCjruh/2MBCisSkq9NytwU+ZdhQBFso2KpuHZgEkADbs
 ZmBZFTxC
 8CCp+W7CHekZDxYAI3vsF40aH22pB3wiZJtaO85fyFpo5mI9/fXvCM9+cJhNHyRm/QBSuM6u8QpjoiZYX8Ow4g2bZ11EDqjKmqI/l4oGD7JQUgsjCstDDTPE7acCudascsi/gzOI6UYhAg8U7A0rtY8iwpbapvsGkaOxBwyKm+oYFOKPP9/j+xR3pgz2lXe5XYIv8Rs/pb64J2vrDswsh59Se9viwA2Tf9pMRLmjRdz4+JVdw+yVk2jx/DHctBVmheBiLs5Un1tgaGzH4GhMSuY2NXRG6htK9UMqkdSaRmjlOLrTN8nC/7fZdmpvGmnGVnj/koI3KTT8qL6Pxdm7YLe+qnF3o7Beb9bXPJ6SbtqVXUHKSJaydHJ7Q3Syv2+cmBVrGaHIg1dLRD1Y82Y5xIYEqdlvg9z96GxIFUfbm++yB/qKDvPAg6PyXphBmvFmkzmKtz7WK4iqEfpWolXCKgapUqA6raOd59KwG4UxaDXfKsLA60JxOfda9Q+S9gY3BO+W0s5FZzzhIcPLmyMlcVTj4f24stVhb3o9voZ08QEclpCpCWy4uMKcBgabggWUh1GYz
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000006, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 01/09/25 2:02 pm, David Hildenbrand wrote:
> On 01.09.25 09:48, Dev Jain wrote:
>>
>> @@ -19,7 +19,7 @@
>>       EM( SCAN_PTE_NON_PRESENT,    "pte_non_present")        \
>>       EM( SCAN_PTE_UFFD_WP,        "pte_uffd_wp")            \
>>       EM( SCAN_PTE_MAPPED_HUGEPAGE, "pte_mapped_hugepage")        \
>> -    EM( SCAN_PAGE_RO,        "no_writable_page")        \
>> +    EM( SCAN_PAGE_RO,        "no_writable_page") /* deprecated */    \
>>       EM( SCAN_LACK_REFERENCED_PAGE, "lack_referenced_page")        \
>>       EM( SCAN_PAGE_NULL,        "page_null")            \
>>       EM( SCAN_SCAN_ABORT,        "scan_aborted")            \
>> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
>> index 4ec324a4c1fe..5ef8482597a9 100644
>> --- a/mm/khugepaged.c
>> +++ b/mm/khugepaged.c
>> @@ -39,7 +39,7 @@ enum scan_result {
>>       SCAN_PTE_NON_PRESENT,
>>       SCAN_PTE_UFFD_WP,
>>       SCAN_PTE_MAPPED_HUGEPAGE,
>> -    SCAN_PAGE_RO,
>> +    SCAN_PAGE_RO,    /* deprecated */
>
> Why can't we remove that completely.

(I raised this query in the other mail but due to not snipping stuff in 
between,

it may have been glossed over)

I was wondering whether a userspace script could break which assumes 
scan_page_ro

metric is there? I played with tracing long time back so I don't remember.


>
>

