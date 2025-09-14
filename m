Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EE9A7CAC58F
	for <linux-mm@archiver.kernel.org>; Sun, 14 Sep 2025 08:09:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DAAC98E0002; Sun, 14 Sep 2025 04:09:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D7FE38E0001; Sun, 14 Sep 2025 04:09:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C213E8E0002; Sun, 14 Sep 2025 04:09:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 9946C8E0001
	for <linux-mm@kvack.org>; Sun, 14 Sep 2025 04:09:28 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 9B09F140271
	for <linux-mm@kvack.org>; Sun, 14 Sep 2025 07:30:25 +0000 (UTC)
X-FDA: 83887032810.18.13A4C10
Received: from DB3PR0202CU003.outbound.protection.outlook.com (mail-northeuropeazon11010062.outbound.protection.outlook.com [52.101.84.62])
	by imf01.hostedemail.com (Postfix) with ESMTP id B75F740008
	for <linux-mm@kvack.org>; Sun, 14 Sep 2025 07:30:21 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=arm.com header.s=selector1 header.b=X7uwrUGo;
	dkim=pass header.d=arm.com header.s=selector1 header.b=X7uwrUGo;
	arc=pass ("microsoft.com:s=arcselector10001:i=2");
	spf=pass (imf01.hostedemail.com: domain of Dev.Jain@arm.com designates 52.101.84.62 as permitted sender) smtp.mailfrom=Dev.Jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=3; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757835021;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FS4CQGZOhqvr7+mF17pDsRT4RC+ZmAoksmbt0b8EeC8=;
	b=oT+PIAihDXXJMmXfBzGtohahnRk11DJE/bzaXHFHxOmzfvDcb1gdc2Hxix3DcR4YMN5GEV
	CCq+mOLePE68Tx7GZxGiq7UAkoQ3Kbm/O2MIHSe7nDo9T1P2asAZX57vDQyZfpsz4W5Ntm
	zBNRMvu95OJZgcy/TYexT9gDNIZA2xU=
ARC-Seal: i=3; s=arc-20220608; d=hostedemail.com; t=1757835021; a=rsa-sha256;
	cv=pass;
	b=4i2gDJCgh4qacp/uGcmoqsibZSi6vxobFUa5bwAdTJ//6epKQC1mv7YQM4+/L0LLLDBl3U
	CidEUgQo4s+ddw0v27LuE0gVaCI7E0kZIVzFAeog/GMYP5LVyv9zvQmABUZZ4gcBlkzTTz
	FQ3iaXmCohiTZfpP1auP2gVLumweAUI=
ARC-Authentication-Results: i=3;
	imf01.hostedemail.com;
	dkim=pass header.d=arm.com header.s=selector1 header.b=X7uwrUGo;
	dkim=pass header.d=arm.com header.s=selector1 header.b=X7uwrUGo;
	arc=pass ("microsoft.com:s=arcselector10001:i=2");
	spf=pass (imf01.hostedemail.com: domain of Dev.Jain@arm.com designates 52.101.84.62 as permitted sender) smtp.mailfrom=Dev.Jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=WwS+/m38E7X6dHJVfU0WwfT5MEJ/XhRdMe5A9ZRmjetuhSp2tB4YZVVWKwDZDhKgrLKFGarmVSgx7Q/zkgOXaDctvQEnv+b6kRiTqT+i9JP7uucPAQYrh0GAwv2hKo0t4x6Qx8/1rsyhcXT4O86iaDHU+yPoBZQH9aE+iVqqu2CWBZaR8VNsdSBGp+S5CEqjHVwcHYv3ZUDeoM81BJ9TTMNm1CN5YKHTrk1tbvCzmZrdQYZKznQSqXOTdO/vo7XO+X/0jeyv3iWhzJuIE6BZxdD0KRjdenhmIi0QTGDCAZzyIMNh0ZCHBYRlgyHTF2/tFGnbjlFDgQwBiyVxaF6ITw==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FS4CQGZOhqvr7+mF17pDsRT4RC+ZmAoksmbt0b8EeC8=;
 b=p96alnaPnhvdZJIWO7tTkdnymF8s282I5qerOYP+8H+JPavx8zNQI1T3S+st8AQ4TrM6xHvo6syNFbqdA3AMu/jaEESbFEcb0pzK5YN+OT0MJguryZAXsN9SrYxsCGuEHWJUjV0SV0M5aBhOUReTcx7BBFP4abkf8wj5IqJWCxUNAkeDyqKbHM2zXNVCQ3SiWb8pKVCZOVct1VMYFPnQVdDt+aBY4rWC1mgUMOs3C6LdUUzrxhT2now6Z+fpFbC6ak5NpvFQ+O1xBlwJh+WDligfqzqlJROcAmQSMiy+VROH2QqV4jg4YTWd4UKEEDBuLqHtxwUMaUCRm24KU0JsqQ==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=linux.dev smtp.mailfrom=arm.com; dmarc=pass
 (p=none sp=none pct=100) action=none header.from=arm.com; dkim=pass
 (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FS4CQGZOhqvr7+mF17pDsRT4RC+ZmAoksmbt0b8EeC8=;
 b=X7uwrUGoy6TI/yh/D2LO4qynyiKy8FK5szGVONssfPUxPsvwsBEJLDthQOLxYP8GhbubsxJcU/di81ncL7AKHiqXXwueNRSWMArY9tdoQhRxe8JkJ5DvqcVB+l1aoHRblX0/uLAeZUCTF4ni61No/4BbTKIMpTZmZxBg6qP7l14=
Received: from DU2PR04CA0200.eurprd04.prod.outlook.com (2603:10a6:10:28d::25)
 by AS4PR08MB7531.eurprd08.prod.outlook.com (2603:10a6:20b:4fa::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9094.22; Sun, 14 Sep
 2025 07:30:15 +0000
Received: from DB1PEPF000509EC.eurprd03.prod.outlook.com
 (2603:10a6:10:28d:cafe::dc) by DU2PR04CA0200.outlook.office365.com
 (2603:10a6:10:28d::25) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9115.21 via Frontend Transport; Sun,
 14 Sep 2025 07:30:15 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DB1PEPF000509EC.mail.protection.outlook.com (10.167.242.70) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9115.13
 via Frontend Transport; Sun, 14 Sep 2025 07:30:13 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=g6P2hdVDivPCNahWhEOI29omtFi6PyJKLRHILrMHnrJ2PqnMq7p9WWWlfctCVy9BGzD7Gts62aUtWuxcAD64Uxqey2QEB64RnmPdc77eeXUXqtJa8I5UAI997IZdzR+mZ7fwFQ1QCkX4tmaEhOjW12C+sioOXCBRhdm09kWRTsLs2+NYdylHe/k/hNPAvPTuQmGhZBY3HnPVgY/wD95JP4/MhXLMVXt5J7LornEm56PitHBQnFBWLOCO9XWKc/GjOWHAXMTDIIgrCPx2aYo48BKpL6kEAcpDT/VodvbWT95fgN8DAxv5AhQRvHrM/D/AUGHvrPq/S/3tbld2M8xY9g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FS4CQGZOhqvr7+mF17pDsRT4RC+ZmAoksmbt0b8EeC8=;
 b=eWGDGnRkMS9bnaJorOqQQ/mv3al2vOXB/iNSa+MxZ4j13Cjd8IcELGrZo+XvsHIZIdk41yOGvZOVsNAvrXkLspXaBOPDc9mWDPKRVdO2vKBlc2qQnduZgHgR67tduJEqPQMIxBywQnVtxM5TNujILWoXauK92bbL+nuA9Bexg1UPdUi1uHUOHw8anyAip6xUa8TQa9TkV6Bw/ENId4Cq5K9zS+h75oIHACSAOoWT7ZY5eLbbbZ6VEYM/q+5+rQEjLkmITw7K18hhQmDJ76e08+BICCvg0CQzTIm4bQ7YcYIKrob/G/vfii2t/P9cMKehrJH6VypEdNuwoqM9Qot1Sw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FS4CQGZOhqvr7+mF17pDsRT4RC+ZmAoksmbt0b8EeC8=;
 b=X7uwrUGoy6TI/yh/D2LO4qynyiKy8FK5szGVONssfPUxPsvwsBEJLDthQOLxYP8GhbubsxJcU/di81ncL7AKHiqXXwueNRSWMArY9tdoQhRxe8JkJ5DvqcVB+l1aoHRblX0/uLAeZUCTF4ni61No/4BbTKIMpTZmZxBg6qP7l14=
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
Received: from AM9PR08MB7120.eurprd08.prod.outlook.com (2603:10a6:20b:3dc::22)
 by DU2PR08MB7341.eurprd08.prod.outlook.com (2603:10a6:10:2f0::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9115.19; Sun, 14 Sep
 2025 07:29:41 +0000
Received: from AM9PR08MB7120.eurprd08.prod.outlook.com
 ([fe80::2933:29aa:2693:d12e]) by AM9PR08MB7120.eurprd08.prod.outlook.com
 ([fe80::2933:29aa:2693:d12e%5]) with mapi id 15.20.9094.021; Sun, 14 Sep 2025
 07:29:41 +0000
Message-ID: <463716f5-be12-4d78-9432-779e3f11460c@arm.com>
Date: Sun, 14 Sep 2025 12:59:33 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/mm_slot: make sure slot is the first element of its
 wrapper structure
To: Lance Yang <lance.yang@linux.dev>, Wei Yang <richard.weiyang@gmail.com>
Cc: linux-mm@kvack.org, lorenzo.stoakes@oracle.com,
 akpm@linux-foundation.org, chengming.zhou@linux.dev, npache@redhat.com,
 ryan.roberts@arm.com, xu.xin16@zte.com.cn, baohua@kernel.org,
 Liam.Howlett@oracle.com, david@redhat.com, ziy@nvidia.com,
 baolin.wang@linux.alibaba.com
References: <20250914000026.17986-1-richard.weiyang@gmail.com>
 <ae30fc02-c573-46bc-a5f6-935f256149e2@arm.com>
 <cf5d6ff7-faa4-469e-9e32-b90c75b8194f@linux.dev>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <cf5d6ff7-faa4-469e-9e32-b90c75b8194f@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: SG2PR04CA0197.apcprd04.prod.outlook.com
 (2603:1096:4:14::35) To AM9PR08MB7120.eurprd08.prod.outlook.com
 (2603:10a6:20b:3dc::22)
MIME-Version: 1.0
X-MS-TrafficTypeDiagnostic:
	AM9PR08MB7120:EE_|DU2PR08MB7341:EE_|DB1PEPF000509EC:EE_|AS4PR08MB7531:EE_
X-MS-Office365-Filtering-Correlation-Id: 358cf462-7c15-44e4-989f-08ddf3608b8a
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|7416014|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info-Original:
 =?utf-8?B?UlBZcVlTZEZoUkhFei91UFBycEdDK29WbXJOS25nbmVKcFl0amxhcGxNelo5?=
 =?utf-8?B?bWRPTDczZFVxVGNJZ0Zidnk2OGU5alpjMlM3b3ZSTklHVzJsOEpWUmQzYUJu?=
 =?utf-8?B?N25PREE4NFZkdzVkcFIvdFlZbC9TcGN3K0pNbTh5WHdjOC93QUtIek5yU3Y4?=
 =?utf-8?B?Q0FsTkkrWDNTTHdTQ3hqeXdFb0JLQzJpanFDTEdkeTJIVk5ZUE1ldXRxelFi?=
 =?utf-8?B?QnNJV0VTMzkvcG9Ca2RIS0NoaWRWUzFHWmhYRi9OdDBvZDFqNE9Ud21MeUVU?=
 =?utf-8?B?eW5RNlN5dkQvQTZ0TEdDbGxySXJMZ01sNVVDY09JVGVRQlJaUWJobGFQWXUw?=
 =?utf-8?B?eW5MQkxTb1JTRmc5bUtveWJ1bkdKZlNtZEFIeWwvVlZiRHZhc0hCZVYxa0pK?=
 =?utf-8?B?eFNtT2dmSlMzVDFZYlRZeDlDMng4K29hVW1zRVF0b1pPTTUwbzNEWGdDN002?=
 =?utf-8?B?WkpsVmdDaXZaYkhSV3dJbXpDS0JYZkpJa3BraEpTM253dGR1YllTdTdqNVNx?=
 =?utf-8?B?OW9NNmNyU2R6eExENGg3eFgramdyMjVieThHVk5DZlJKUUladms3Q0tzNlRu?=
 =?utf-8?B?RDBPaVAycWptN1BOVlFBM1dIMU1lbE1nRnRJcjlLbWprY2tOU0pxQmlIRkVF?=
 =?utf-8?B?dXdoeXZZMzc4Q295czZUVXdXdGhUOWpFaFl6OG16eTFvUDdmUEtJWlBUMVhI?=
 =?utf-8?B?M1ZlN3VwNkVEOUJJUTNUd29oMXZjeFBzc043QXlrU3NGck5NMTF4Qk1BbStJ?=
 =?utf-8?B?RFI3YlpYRVdwNWppUENxbndwOEhyWXlacmdRRW1RNXc4VkJoelcxVzlZOEo4?=
 =?utf-8?B?aThQWVBaNEtML01CUERaVkZRTktiV3RhTXNTUWc2eHRPQ1l2bk01RHZ2MTVj?=
 =?utf-8?B?czhxSktvL2V0cnhwUnNOV3RVMnMxcURGZGx0RzlxNGRrVERrZktjc3pnQjJW?=
 =?utf-8?B?Y0hTcUR2ZU52Q1Q1MTYycStmeXpFR2ZIeHVGSVhBZEZ3OGN0Um5HWlJmWld3?=
 =?utf-8?B?cEVRME56OVY5WlpWdk5KTHYwcFNMVXR6TXQ3ajNhVjlrNVFRQ05rUVhIYko5?=
 =?utf-8?B?L3BvMWRXZytvVGtvQmk3QVhKK3BRYVgzT2FxbGoxODUxclNYUEV0bVpzc0N0?=
 =?utf-8?B?ZUV2cm54RS9nRjI0WE9XV3plWWE4dkJwZnZXUjhpSmtjT2oyQVVkK1VLWjk3?=
 =?utf-8?B?L3pIM1AzK2ppZldMS0YzM09lOEZGUU4xUFRkU0JpWG93dGExSDJ1WVlSOGFk?=
 =?utf-8?B?ZG5vZWg2aVBKRVE5a21NaUc1S1NZN1grV1k2Tm9LZGtqaEpDR0JUWW02cmxN?=
 =?utf-8?B?UVVDVlNqRURaTXpyOFdFcmZOT0pDcmsxN1p2RHpxdEdlbzhTTU9DK1RCY29h?=
 =?utf-8?B?d1p2TFZNSjREU29DWDlMbkVhbzVuOWZDcWNJMTJyd2RCbmpkTDdSK3pJSW9j?=
 =?utf-8?B?V1hia1h1b1A2aDQyRmZZK0ZGaDVpc3dXcFlSV3Zpc0xRSHhyWWxBMUgvTi9u?=
 =?utf-8?B?R0NBS2hJeUQxMjBzWFNZRGJKN2Y2OHNXVUZBZWhmT0lrNHdMWmdUY3ZPQmhi?=
 =?utf-8?B?ZXQ3VEJ2b2FjVnB2K2srZUNLNkhMdmQ2YitFOUN0eHVSam83VFVrUldpMTFI?=
 =?utf-8?B?TXF0NnIvWDg3eFh2MVRoTENTczlvb3FFeVJjL0VFM3FMWU9MNzM2VlRQY0pq?=
 =?utf-8?B?a3FDQWs5YzV2a1VieHFnN3hwK2Z2N3VVUEo2aGVlOTBBQzdxSklrczNTZmxY?=
 =?utf-8?B?dTJUODFUWFdBWE00VnpmbS9pRWpodWZiYnR5VnJjcW9iL01QQVl3V1pkSTVN?=
 =?utf-8?B?VDQ0RFlnQnRRbHJFdld2Yis1Vkd3b1phdFBvRW5WQ1Rka0Jkcm1VYnpTM3BF?=
 =?utf-8?B?YWZiWkk4TUY4MklBVW02WEFHL09KUVQ5aXZJcFBCeS9XZHdFVU9JTmQrb3Rr?=
 =?utf-8?Q?mlJuV/1tCCw=3D?=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM9PR08MB7120.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU2PR08MB7341
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DB1PEPF000509EC.eurprd03.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	21fa0263-c60b-412e-8cde-08ddf36077e2
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|376014|7416014|14060799003|82310400026|35042699022|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?cDBuN0grQUNjaWRNZExBV055cDF4c01EbDJ6WVk4ejJoQUdFc2UvajdtYkNO?=
 =?utf-8?B?TmdDWHFnWTQ5U3k2aWpVc05HaHRNT1NoSG5KdFcxdUlMUXVRRDQrOFFyOUZ4?=
 =?utf-8?B?OTUvSEhiS09CMXVBNjIvbWxsaURmRzhaeUtRdFlJNlJEZSs0UFgyRTlZbVRs?=
 =?utf-8?B?VVJUTU9OQnBlMWlrdU8wQVQ0YnVIbWhSYmg1aGplQ1Z4cTNaMTZ0WWd3dFZ3?=
 =?utf-8?B?R3pOUjdReHVIZ3VqWVFFMGNEUlJoS2I2NXJmZU1YZVp0NVpBK0V6YkNtU3pU?=
 =?utf-8?B?Rkh0YU5lY3YyWVQ2OHFhUjU2Ym1MWjF0dHNUUVBtUlJ1dEtTQlJ1WXhNbFRt?=
 =?utf-8?B?dEttekUyUFR6eFJydUxaOVBCekw3RVFrQVVyMHlnakE0NE9NaldjTWJGSHRK?=
 =?utf-8?B?ZFlsSnVsWlZ4MDFCOXZCa3Y1MzZhWFR1NmJGOWpJNEtWR2ViWWt1NktUQ3Q0?=
 =?utf-8?B?eUhhRUlsVDJadFFuNVNuTkF1K0UxRGpGRXNiT3dnWVhqaERYSEJBTnA4TFlO?=
 =?utf-8?B?Szh4OFN4UzFlN25jTTVnT05sWVpDQ0M1aGhxL05qZ1U1RUt2aUtkaUIrZGh3?=
 =?utf-8?B?c21IWXVHMHhIeFFhTTEvNm1jbWtMNTk3VlRVYUdhN0VPZUVVR3JZTEM3TnNo?=
 =?utf-8?B?MFFGSm54NGpRMnFoaWVkdCs0ZGh2R3JLZkxhVUFUM0FKVWNhTXVLSlA0T0Rs?=
 =?utf-8?B?S2VMNE1TT3hjZWY2dmo2N0xBUkNqUHJEcGRrWEdORnVpdlFHQlIza2lHR2lR?=
 =?utf-8?B?cm80WUROM1dybnlxdER2OE5QNGhXQlRKdzhtL2NrTzV4YjZ3N0IwWi9Dd3Bo?=
 =?utf-8?B?VzRzOGl6Qnp6UThILzdIb2VPTmVEMlhxZ2RCckgrME8yeXdqRmxLa3k0NVZJ?=
 =?utf-8?B?NFNOVXpPcXRvcFZYT2dFdVIzdTNCUzgvT2RiK2hIMDc4Q3J6OXNFaEpUVXFW?=
 =?utf-8?B?WU54bm56aXA0NERLMkMwb3ZOaTVvT1JrK1Z4QmpmdzN5UnhKbmtNWEdVWitk?=
 =?utf-8?B?QXR1OHpNMTRwVVNUeXlQRTF0dVp3Ym8vYmN2THRrdUR3eWNJQUZpRmloVy9x?=
 =?utf-8?B?UmZZSU1scE4rb2U1dzZXajJtUmNWSU56R2svNTIvUVozSHFJN1UzZW5CWktB?=
 =?utf-8?B?K3QvUGpSWDNBZXgrU1hLN2lpRjlyUklOcllKTFRLVDNUNjN2RWVyQWFjSE1m?=
 =?utf-8?B?dGdoWXFuczJPWGM0aFJoeVNLRjFGUGpsSmI2OXN6end5S1VUMkE3ZU95MklF?=
 =?utf-8?B?MXpQV1lUUmNtaEwzbWJoQlE4QS81S0ZyaWszbVhWVDFSM29kTFExbW1sT1J1?=
 =?utf-8?B?RWxtR01iTWNzaFV0UnBvc0ZjZ3V1T3dEdnh0RU9aa1JZamlJd2Q2VUg3SFIv?=
 =?utf-8?B?UGhyQXJZZWlhV2lsUTVERTVSTlN1Nnd0dTFlMDRZOFhOcnYvUXVqQnc1LzVP?=
 =?utf-8?B?VlYzQ1NXOHhGWDZXMkt4YkptRW9LTWhhUmxKTjlzYzlsd3E0bkxwS0lBd0FJ?=
 =?utf-8?B?M1k4bHQzM0VIVUVLTk9XNHVvR0xmS1RUVGRKVFpDQjBPOFF5YVdhdndFTElZ?=
 =?utf-8?B?UldDWFFGbEttWHFuYi9acjB2THFPM2RhdkIvT0V6U1JvbURlUnZZTys1L04w?=
 =?utf-8?B?RGxHN2l5Q3VmRVIrVThha2haZm9LOEVQK1pBOUtCMWgvWmFvNlNnTHJGbXRX?=
 =?utf-8?B?REUrdElmRmZzRUZkK2dPRmNiZDRaS1phbnE5UmtqdzlCSHlrN1Axd3Izc0U2?=
 =?utf-8?B?OW1nK2RINGNxSzVyamhOQWVmU1hjV2tWWFM0UU1OOXZ3STZMOERUWlFtL1dN?=
 =?utf-8?B?NUxpYlBRcFJRcnptQzVEbTF3amJqL0dsbHZ3SnpiSkV5VkhjaXJIRCtJUWds?=
 =?utf-8?B?cWh2YVdFQllLenNFdmppVnhsNGxtV296Unl3N2ZIQWRkR3ArVk5NZUlhVTNz?=
 =?utf-8?B?T3pvZlJoclorVys3L1RMbTk4L2tIRno2aDNJMzQ4UnZ5K2kxL3lYNmtQaDFk?=
 =?utf-8?B?cVI2emcxTkwwcXZ1S0w0VzBPWWk0QWYzR0JrUVF6MjJwVHFYTUg3d09JaTY5?=
 =?utf-8?Q?AfKaTW?=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(376014)(7416014)(14060799003)(82310400026)(35042699022)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Sep 2025 07:30:13.8929
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 358cf462-7c15-44e4-989f-08ddf3608b8a
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DB1PEPF000509EC.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS4PR08MB7531
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: B75F740008
X-Stat-Signature: shdiq35743wpqdgyaz1w5fxctx9hoju3
X-Rspam-User: 
X-HE-Tag: 1757835021-506795
X-HE-Meta: U2FsdGVkX18Ig+SnZK/Nmj7KxcnId8gALXNwc7SI8ivEos0bmtRkjs/2ViXpEEiPbm0emqRBwZPAFIVPGFdoZB/vLz88fM32dtYnGJ0ku0bXOuoBQWImVq+SUyH2TUS3zXTPsmJvgaRxK1ln7O3cKcP1+iT52whRnwwGm6qfFlW/FzfZ+P54AC1DiwPi/5rDvPHicSWGeBWr8Ex0Oqlcru5GBu4DcDqGhGQ0RKtGKxmJJiUaMhBtm53KCAYGFMNCaqPrGZkEJpm4zENIf1kAFA7PIIqbVR5KSmXKeHb3+pXoom9XZsyFv7XbYTKzc6EXUS5onCJgsrwWBGLG2wTr+YlUu7uppCetJ9N1jrMPqE7QlM/O4gBg0MXfVn21/0Bl7Z2IQJ33DCJBXo2P/ZrT3oBDxvF/N5Mw2QV6iscLWvnKdUG5Mp9B4eGT69g8lmu95DR4fOM+btoz1hAM87Wkmt2HNodqJWOi7x5E27RnwQhgLrGUTBMckgjHSg1g7I6aY4J32YpLAA5QfAVEfc4ZZahqMxSqCZjiUKAzswA9aLp55CfovpOeBJEWR6kcaot3WDju5llrx5JMaq/ZOMVF3A3AImTrNXoEgn8KZl81lqqZcQSoHa9hVETyFjWeP8mKDiV/LpW3ag7pArO/IBO/WdpeSlLOyW9mNrdlPO6/rPxFq/6zsqLLKM2eqhG1yX6YrYP3Kn8bKXdD1MndbI/c7ffe8HRH6/i4F21Uvp5gBEI2+0qHMPHRZ51WbqJ6vd8AWCub+hlMmXaWwRhHmFdN3f9TtNQBg8Fw0+6DN/c5L2farRezST+Pjhhs+ptJooKfFyye/5SBeSDVqLPA4mcOcPfG0edmuAYhsy7cZUmMbMoz+fJ2XehqNnvX141Asm/KywlKQIP9gpqRbhqgl2VeL+mFgItvH/FGjW/TQ+z2YUQzJKyfeRCVSimjLnfpZl5YcDhSgRE2Qk+ZTXroN9y
 hLsnA20D
 lWH2vhIxXNOU+Ty6WFqNTejHwFMblqGPRh2Wlnyfc7rNIpYoygjfr0TztnJ0JmSrM2f1s5camvD4DnSanNqzJzGuJba4pUVBpRiCS5t0ApoqavxyoXyOLoI0tRKquorX6vDmx7jTud6HmPjNWcft3Q+1uDfNgy9e3D6e0wZ3g8fEgFckp9cUHAq+ZX715nZ4cWgBqJrBYKDg4g/54FclBIqJuyBw4ypye0O4J+x5aJMjrsW0x4/UAcBdgSY/vk29uVB3H2I8BL2zK1VFZTZXuHD5rxKZppHYUMejKfNYccpOeXj5yW2RMUej2jATpRDcoHWsn6uH7IODZFpQRGSWTJyfgMtzaXoakbt3GamWwgrpXa8cpVYRLODhAweuvYK/E6gKSK04T8bJLuBR12ss/5JTiCFziimfBme30kNXAkPLV77/px7pmx2rSAd0DuxETh/fHn0AtjoSWEXTlmdN8fU3VDFVIEdhcEQqW3TK7n7ezzqnGpnPQoHk33lyfeLiFCGQx2HUIrlHpGuDWIL2AUFIIWZ2+qHUMC37VFYaCQSLDvPo+bJEKs2nK/DLtubr3ccJwuDtOeedDl9EdMCifQEYb1QA41CwIVHN1spwrKLMNA/rbLuDFCJOM0fGv2U45hq8Lpw62xPOq3FvCRWpj1bnApXYxGwH2fhFS6uPPNAUaJCsRcfsqHLIGq6DqSTHBE3GZs/SqjTpJ/wM7wWZ16KQ6sjU1/wtID1wluodOnAVk8xdIBPxSX3he2g==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 14/09/25 12:33 pm, Lance Yang wrote:
>
>
> On 2025/9/14 14:21, Dev Jain wrote:
>>
>> On 14/09/25 5:30 am, Wei Yang wrote:
>>> When using mm_slot in ksm/khugepaged, there is code snip like:
>>>
>>>       slot =3D mm_slot_lookup(mm_slots_hash, mm);
>>>       mm_slot =3D mm_slot_entry(slot, struct ksm_mm_slot, slot);
>>>       if (mm_slot && ..) {
>>>       }
>>>
>>> This is only valid when mm_slot is the first element of its wrapper
>>> structure, otherwise a NULL slot would converted to a mm_slot with
>>> negative value. And current code thinks it is valid and continue.
>>
>> Shouldn't you fix the code for the case when you can't find the slot
>> in the hashtable, i.e slot =3D=3D NULL? Like, if (!slot) return.
>
> Right. For khugepaged specifically, the slot =3D=3D NULL case in
> __khugepaged_exit() (only user of mm_slot_lookup) should probably
> be treated as a kernel BUG for new.
>
> But I'm not sure if the same logic applies to KSM ;)

I haven't seen the KSM analogue, but restricting the position of an element

in a struct to make the code work should imply that the code is wrong in

the first place :)


>
>> What you are currently doing is just ensuring that if slot =3D=3D NULL, =
then
>> we get a legal value of mm_slot, and since the code then operates on
>> the basis of mm_slot, everything will work fine. I really think this
>> is a workaround to the real issue that you got slot =3D=3D NULL :)
>
> Anyway, an actual fix like "if (!slot) return" for khugepaged would
> be better than this workaround, as Dev mentioned.
>
> Cheers,
> Lance
>
>>
>>>
>>> Current code works since mm_slot is the first element, but make sure it
>>> won't be disturbed.
>>>
>>> Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
>>> ---
>>>   mm/khugepaged.c | 5 ++++-
>>>   mm/ksm.c        | 5 ++++-
>>>   2 files changed, 8 insertions(+), 2 deletions(-)
>>>
>>> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
>>> index af5f5c80fe4e..668e74ad33b7 100644
>>> --- a/mm/khugepaged.c
>>> +++ b/mm/khugepaged.c
>>> @@ -108,7 +108,7 @@ struct collapse_control {
>>>    * @slot: hash lookup from mm to mm_slot
>>>    */
>>>   struct khugepaged_mm_slot {
>>> -     struct mm_slot slot;
>>> +     struct mm_slot slot;    /* keep it the first element */
>>>   };
>>>
>>>   /**
>>> @@ -2382,6 +2382,9 @@ static unsigned int
>>> khugepaged_scan_mm_slot(unsigned int pages, int *result,
>>>       struct vm_area_struct *vma;
>>>       int progress =3D 0;
>>>
>>> +     BUILD_BUG_ON_MSG(mm_slot_entry(NULL, struct
>>> khugepaged_mm_slot, slot),
>>> +                     "slot should be the first element");
>>> +
>>>       VM_BUG_ON(!pages);
>>>       lockdep_assert_held(&khugepaged_mm_lock);
>>>       *result =3D SCAN_FAIL;
>>> diff --git a/mm/ksm.c b/mm/ksm.c
>>> index 2ef29802a49b..0d486dbdf7d3 100644
>>> --- a/mm/ksm.c
>>> +++ b/mm/ksm.c
>>> @@ -124,7 +124,7 @@ typedef u8 rmap_age_t;
>>>    * @rmap_list: head for this mm_slot's singly-linked list of
>>> rmap_items
>>>    */
>>>   struct ksm_mm_slot {
>>> -     struct mm_slot slot;
>>> +     struct mm_slot slot;    /* keep it the first element */
>>>       struct ksm_rmap_item *rmap_list;
>>>   };
>>>
>>> @@ -3842,6 +3842,9 @@ static int __init ksm_init(void)
>>>       struct task_struct *ksm_thread;
>>>       int err;
>>>
>>> +     BUILD_BUG_ON_MSG(mm_slot_entry(NULL, struct ksm_mm_slot, slot),
>>> +                     "slot should be the first element");
>>> +
>>>       /* The correct value depends on page size and endianness */
>>>       zero_checksum =3D calc_checksum(ZERO_PAGE(0));
>>>       /* Default to false for backwards compatibility */
>> IMPORTANT NOTICE: The contents of this email and any attachments are
>> confidential and may also be privileged. If you are not the intended
>> recipient, please notify the sender immediately and do not disclose
>> the contents to any other person, use it for any purpose, or store or
>> copy the information in any medium. Thank you.
>
IMPORTANT NOTICE: The contents of this email and any attachments are confid=
ential and may also be privileged. If you are not the intended recipient, p=
lease notify the sender immediately and do not disclose the contents to any=
 other person, use it for any purpose, or store or copy the information in =
any medium. Thank you.

