Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 99979CAC587
	for <linux-mm@archiver.kernel.org>; Sun, 14 Sep 2025 14:05:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BC6ED8E0003; Sun, 14 Sep 2025 10:05:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B77DD8E0001; Sun, 14 Sep 2025 10:05:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A17C98E0003; Sun, 14 Sep 2025 10:05:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 880388E0001
	for <linux-mm@kvack.org>; Sun, 14 Sep 2025 10:05:03 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 2896EB6531
	for <linux-mm@kvack.org>; Sun, 14 Sep 2025 14:05:03 +0000 (UTC)
X-FDA: 83888027286.13.5AACFB9
Received: from AM0PR02CU008.outbound.protection.outlook.com (mail-westeuropeazon11013063.outbound.protection.outlook.com [52.101.72.63])
	by imf07.hostedemail.com (Postfix) with ESMTP id 2229C40005
	for <linux-mm@kvack.org>; Sun, 14 Sep 2025 14:04:58 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=arm.com header.s=selector1 header.b=d2MK6lSP;
	dkim=pass header.d=arm.com header.s=selector1 header.b=d2MK6lSP;
	spf=pass (imf07.hostedemail.com: domain of Dev.Jain@arm.com designates 52.101.72.63 as permitted sender) smtp.mailfrom=Dev.Jain@arm.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=2");
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=3; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757858699;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XSxyPK71CS2dOdEBMBqI5It3Vz70D/GjHb5oUM+rPcc=;
	b=XyVFO/rNcE/Ib6+++DPZJzIHlksDhPTi8+PdCzGrKhoAQBU2YVxa4bn7PC+NF9zFfrmcfm
	13uiZbpv6sfoCSykQZsX+CWskvaYeseSgvPFzgLBmeTMNp+YLTA6CEkkTzNH7fELUDcdMq
	h1gxZyOoNanfFrr8W+SvP4EZtPOGJjU=
ARC-Authentication-Results: i=3;
	imf07.hostedemail.com;
	dkim=pass header.d=arm.com header.s=selector1 header.b=d2MK6lSP;
	dkim=pass header.d=arm.com header.s=selector1 header.b=d2MK6lSP;
	spf=pass (imf07.hostedemail.com: domain of Dev.Jain@arm.com designates 52.101.72.63 as permitted sender) smtp.mailfrom=Dev.Jain@arm.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=2");
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=3; s=arc-20220608; d=hostedemail.com; t=1757858699; a=rsa-sha256;
	cv=pass;
	b=D3lnkxxgL7zMXpMowx/YmF2dUuU6mEKp8PapFgydXtY42TVGmrXy3eMzpK0ehy9Kpnd1IO
	TlCS7WTPUCerhiNjvbLjQfD16SYaD6fDGxrv7uyt9x+0qcrDGct/KqqCx/hU2sGTcXCf45
	ZuxZTAsHCqjzfzgSetvqeRy7V5R8NRU=
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=tgjxFqj8YseSjEzH7DJO1gzzUAv/JAcpZkIjVS5TdQ1VkSj72yXa5Qbt1r06fThiM+oQqR+ZztK0ZsV4s/SI/qwc+ntin3jMKyj/7Zg9NHWoAlTnVURyuF7BAhdF2HXr/BhS5XmxecWGGU/QFhdNB7yCsO+g6IPXkgY835coS/n57T9SN8QYuFNzjW7E3EhN8nWaqTE/Vs0Qy7YU8qur0IIh0RlHR0jI2dbrKLRPMJG5pdjBtPMkwHC300KM0LGk12pQBcE9szRaJgUtO6Umewwhe8T/zxfQFhU3p2VH7jrWJhXaStX7lNKbgdkJaQ6eLC0VRMuWFDllA6k/IckIWw==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XSxyPK71CS2dOdEBMBqI5It3Vz70D/GjHb5oUM+rPcc=;
 b=umrBYmzs700Ij0DWblqgPg2iy11EtviD6kRi7jHlXQbJSI1zjImehUCOV3SjC9mR+4HxQh2j3RuKPKc0m1br1gO5MnBHFK1MDqgrPAyEXKpyfKxHDObIZ8cTXz0SVbIOou/IM2uEWBJuLHEFGl6FvHTFOFh8n7Q4GpkB2p8u/SX3aBme722BEFz0CH0/feYIFmquBDYdZgqHbFzrV8eM3rn1ivLH722IgzZizzMZvOPG8u9OoMaKwLBbKXjRtAtPmMqxXEg7f/p/XI/XAb11EIL8OE4NJvPW0Cs7qsnzTGkbIhU9dLh+rDJxMejO8L2QBLXehrcLVP8qbAPu6B+3Kw==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=gmail.com smtp.mailfrom=arm.com; dmarc=pass
 (p=none sp=none pct=100) action=none header.from=arm.com; dkim=pass
 (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XSxyPK71CS2dOdEBMBqI5It3Vz70D/GjHb5oUM+rPcc=;
 b=d2MK6lSPeXM6HDFiz8xRp9AVITHYN/xcDvvsQwbMkscZgqA4b5Z0AZmIiaaLXM9+B4luLItA/DmY53vTNMyvLMXszpvqBfd1vhRPtDZqAVmp5lHkdMJtkkzPZrZjxsdrJmM9yDjhI50VxhUmhKu355AFODZ31YwyZkbcPa1oN9Q=
Received: from AM0PR10CA0109.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:208:e6::26)
 by DBBPR08MB5915.eurprd08.prod.outlook.com (2603:10a6:10:20d::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9115.19; Sun, 14 Sep
 2025 14:04:53 +0000
Received: from AM4PEPF00027A64.eurprd04.prod.outlook.com
 (2603:10a6:208:e6:cafe::29) by AM0PR10CA0109.outlook.office365.com
 (2603:10a6:208:e6::26) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9115.21 via Frontend Transport; Sun,
 14 Sep 2025 14:04:51 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AM4PEPF00027A64.mail.protection.outlook.com (10.167.16.75) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9115.13
 via Frontend Transport; Sun, 14 Sep 2025 14:04:53 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=FQ+U1R7Waw7HGfWEJbRVsMdazhz8ji6qKlXyAhewQe9Lz7lBIgxpbL0vBTu4+racWPPLw1P1qpk/HA9P8lDAzAjWWMReSXbQULGToiCpgproL3i0c7MBGHWBtl/KfZ06wRH3A9Za2fu1S0L26DF7zW137alzUZcxnOroU/Wgiljykii9hHJrfdJcm6H7RHe37WZ8VO9NzrmGf5xuloG6k/EWOXklw5dKfLTaHdfbfPlAMkyI8fkofoEi0YE2R4ZR4MCfCbFsppmp1Betpug3vNNnhG1RU4cvJ5nZvCq5XVtg5X4fmt2DTyaY+EILR9Vv08JpeBc7iyopzi36eQ7L5w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XSxyPK71CS2dOdEBMBqI5It3Vz70D/GjHb5oUM+rPcc=;
 b=mc95PeQwX0JKYu90Uux5a10PE/lDrA4/g35MKUxWCisVCBwRTubXWk5+kjrk8AzWHuiy7zPbxsP3ofPnOpDdzDDblRs6SyjCYpWMN1A8r6sOZxBQ7UAe1WxCL07xHS0x4iEwhx22oVKnLSd5ELtjvst4tb9/bZ4v4+PLjUKw1zxGsgv9vZA9l9L0UtmVCOQ9JldaXU6+8uF96rqDLAo2B1xKqmh4Yo3JHzw92mt5CXB5gXkU50Rfs8f0YdU+dyfHKeMstQY68tml+/oAwJUFKTHevNgOUjnoCLbdFYoDIsWKf24B+F+h2f9LkFYNrQ8DN0OFaHDUf9pVw1Mx8vWKLQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XSxyPK71CS2dOdEBMBqI5It3Vz70D/GjHb5oUM+rPcc=;
 b=d2MK6lSPeXM6HDFiz8xRp9AVITHYN/xcDvvsQwbMkscZgqA4b5Z0AZmIiaaLXM9+B4luLItA/DmY53vTNMyvLMXszpvqBfd1vhRPtDZqAVmp5lHkdMJtkkzPZrZjxsdrJmM9yDjhI50VxhUmhKu355AFODZ31YwyZkbcPa1oN9Q=
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
Received: from AM9PR08MB7120.eurprd08.prod.outlook.com (2603:10a6:20b:3dc::22)
 by AS8PR08MB6648.eurprd08.prod.outlook.com (2603:10a6:20b:39f::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9115.19; Sun, 14 Sep
 2025 14:04:20 +0000
Received: from AM9PR08MB7120.eurprd08.prod.outlook.com
 ([fe80::2933:29aa:2693:d12e]) by AM9PR08MB7120.eurprd08.prod.outlook.com
 ([fe80::2933:29aa:2693:d12e%5]) with mapi id 15.20.9094.021; Sun, 14 Sep 2025
 14:04:20 +0000
Message-ID: <20e7f812-c1e7-455f-a523-08fc99024adb@arm.com>
Date: Sun, 14 Sep 2025 19:34:13 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1] mm/huge_memory: fix shrinking of all-zero THPs with
 max_ptes_none default
To: Usama Arif <usamaarif642@gmail.com>, David Hildenbrand
 <david@redhat.com>, linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Zi Yan <ziy@nvidia.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Barry Song <baohua@kernel.org>
References: <20250905141137.3529867-1-david@redhat.com>
 <06874db5-80f2-41a0-98f1-35177f758670@gmail.com>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <06874db5-80f2-41a0-98f1-35177f758670@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SI2PR02CA0015.apcprd02.prod.outlook.com
 (2603:1096:4:194::16) To AM9PR08MB7120.eurprd08.prod.outlook.com
 (2603:10a6:20b:3dc::22)
MIME-Version: 1.0
X-MS-TrafficTypeDiagnostic:
	AM9PR08MB7120:EE_|AS8PR08MB6648:EE_|AM4PEPF00027A64:EE_|DBBPR08MB5915:EE_
X-MS-Office365-Filtering-Correlation-Id: 29665885-24b2-4bbf-3c51-08ddf397ad7b
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|366016|376014|1800799024|7416014;
X-Microsoft-Antispam-Message-Info-Original:
 =?utf-8?B?UjNPcTRpTlAzZGYzYXF6ajVTZUtkZGoyZHpwSEI3ejJ0djZIYUhSK2MxK2ts?=
 =?utf-8?B?NTluSFVCRGJHeXAzbFZDRkRWOWJRb01JZkhQcml3MFhUbFNvdEJDZFNsZ2Vx?=
 =?utf-8?B?U3VyQ0l4eFVEaS9qTzB2dVE2REF6SjAvREFVNHN6ZkJveHhTY2VWMitDUU0w?=
 =?utf-8?B?NVkwY2lsdjdZWGRaWDlyV01kTmd0Zm0yb1VSbmxpK1RyNlRnR3VaeTV0bDZ6?=
 =?utf-8?B?ZmVpN2VDaC9JTnY5aWJXQjdHTkRhaGNnOEp5dWN0STcvS1d6dHhoenUvT05h?=
 =?utf-8?B?NVl0RkFVT0YxY2hjdFBmZnRmRVlkcGZONTJJdGpPenJObFBjVG5DNzIwdzJn?=
 =?utf-8?B?T01zb0ZqaDJEZGpGZ2xnZHk2OXlKcmZLR0FWYzlGQ1g5MndDcWNLVE9XakF1?=
 =?utf-8?B?d0VuejhPL2hFYkxuQXhJRU1oeU5rWnQ3VXNmSHdCZWlXRFBxRXE1eGdaUFhj?=
 =?utf-8?B?QWZ2MFdEa3cyNWg3eHZwWWZJS0pzOE0xbGhFQjljNXgvTjhwZURSdEZ5Smxm?=
 =?utf-8?B?RDhmVmI4cDYyeVVrRVRKYWN4Tkh6MVFLdW9NeVh6eHdXOVpFYU96Mk82Qll4?=
 =?utf-8?B?S1FuQTNMK0ZVOFF3WEg5UndxWDA0R251VzZYOWdSVmFod0ltQy9UZGo4YmFI?=
 =?utf-8?B?OXFiaWYrUmw2RndFNVVLRHZOSWxwd3BkZTNFSk9tamVkWjBwbUlJOURqeVdu?=
 =?utf-8?B?dFZQWkwxaXBjSFVzVUlwRXRoeDRBbVJvS3NWS3Y2cWo0R2dCbUVLMC9jM1Vr?=
 =?utf-8?B?TzFncXZxdUJLdkd0VTFmUDE1TEJ5NzRsWTJTVitsS3hJZmpGT0xBUVBNd1lN?=
 =?utf-8?B?d2sxc1RqOW9pZkxEdzhrYWlEWS9zeVVmb1lVdnl3aFlsS2RPTy92ZXZoQSty?=
 =?utf-8?B?Yi9pb3QxcEFGTVRZS21HYVI2RjRBS0hZOTN1YU00ZkcwZW40YlM1bTBxWHhC?=
 =?utf-8?B?Mjh2elVkUmh4WkJFOEdwUnV0ZUtXTEYxMGVCTENmclFpNzlybnZYS1MrVHMz?=
 =?utf-8?B?Y0t4OGRoTDFRY21WWHVlclZ2Y3VlMXNoYms1b09WR25semhhcmlub3JLTm12?=
 =?utf-8?B?Y2kreUtnaVNkSmZCaTR6S253R0xGWlo3ellJM0c4QU9kMWp5dTBSSGdJU0dF?=
 =?utf-8?B?MnFLZG4rZENES2VvZ2d2Rm5NZ3libWRmWnJWRjA0ZkM2UWNKN2hYTVRKVXd6?=
 =?utf-8?B?S0E4U0doajN4dUlNc3lkTE92cWI2YzY1aWllUzJFMzhPY1hidkhhUVFtKzVp?=
 =?utf-8?B?OHJXTS80Wkk3VDVOYXJVQTJCa2l5STdVcU84RXE4VGwyOFFEZURHODM4R2Fq?=
 =?utf-8?B?Ynd6VGJVMkpvYWlTa2QyTEE1YnRXVlFvUGRocGhSaUsyc2ZxVDUzeFBQV2xI?=
 =?utf-8?B?Mk5kN1p5V2t3enByNDlJRGFhODh3UktaamN5dlJ4UlZweEpKa051MUxNajFM?=
 =?utf-8?B?cFErdWM3bDZqeGRQR1VER1NBbGQzeXRxdmJwNUdjZGo5ZFFTb3JQcFZ4eC8r?=
 =?utf-8?B?L0YzQlJNZ1JuMVliTkVYUURXbUFoVWh6RmF0VVZIOFlFazROV016S0w5WVRE?=
 =?utf-8?B?NFhoZkMrdXhQQjFnMjI4SFhIVm9xbS90QnYxTGxGeW5WOVl1aFg1MUpRV3gr?=
 =?utf-8?B?UVBtbjUvMjA0ZnM3OExTUEtCbDFVYWpYVHVDNjN6NTloT2VVREVwSUF0eVpF?=
 =?utf-8?B?WDJRVkJTdlhvcXRPT3IxQU1zYjdHVEs3OEhGWTIzb1Q5Y05CMVRVNkpEK04z?=
 =?utf-8?B?bWhPMjlzK2NLYU5VRFUzSk5EQkRtTmhRY0F5ay9wbXErV29lNU1ueW9LUlhG?=
 =?utf-8?B?cHVWNElLZ0txaEdyZGR5VVRURXVmUkJ2QVFISDh2b01FQ1hUWVk1alg3MUM1?=
 =?utf-8?B?VEpsNnh3NWRPZUJRVTVzTktXQmJONVVaQzB2YWdCT3VkQnc9PQ==?=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM9PR08MB7120.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR08MB6648
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AM4PEPF00027A64.eurprd04.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	998e3448-e889-4b73-1c8d-08ddf39799b7
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|1800799024|7416014|376014|35042699022|82310400026|14060799003;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?N1NZalVXazhzMDhqMUgvUWxFV3plcHFSMjcweWpYeGpSVEJMSlRGMGp6YnlD?=
 =?utf-8?B?aHhaN2xaVXlPTFhTYUs5UStLZlc1bXg2TnBUR1ZkSFR6MFprekoyeklMWmF5?=
 =?utf-8?B?K3YyLzk0aWRiRFlzTFhaMGVmZXZENDVaSUtnWDlST3E0VTJBUW12OFpHNUw2?=
 =?utf-8?B?N2JxRlp2blBKSnhYRlV6eitVZ3A2aDRFNzVZajdhQ0JTaitDV08yRWFpV0x6?=
 =?utf-8?B?VDByUmp3VzlQUWl6ZkpsOXY0VXZVYVZBcFhWamJwQitURDNZbHpybEtXNXYr?=
 =?utf-8?B?NHFEOWJRR2VxaDJORVZyR2dOVlVzQ0NYRXhHVENTd21hUXorZTFCZG1FdmN5?=
 =?utf-8?B?VHhRY0Y2Z0VtQ0NiZU9JWldVREppN0U3bFptVVJ5SFFhVm5TRkJIZTcycWdo?=
 =?utf-8?B?Qk9iMUVJV0ZiTjgrN2ZVWERtRFNGeUlpWmhUWXNoa0VDZ3ZJQ2J5Uy82RzRD?=
 =?utf-8?B?UUdCNlp3RDl0NWhUMzhjdTBkWCtnNWdmMlF6L2ZnNnhldDZ2NmtaT3Fnb0R4?=
 =?utf-8?B?NkRrdTB3T2NWQzMzVVhCR21VVUY1OHI2NVJrUlRLa1llTStJWmtxQzBxTkN5?=
 =?utf-8?B?TmRFUVRobk1ZZmdTYTdmbFhwV0VNTHlhTHRqcDFCa1FWbnhWTERHTzczTll6?=
 =?utf-8?B?TkU3Y0IrdUp0Yno0RHNCUVRXbTlLREg1ZUxCSXEwcWxFYStNbFFzVXRQMlBV?=
 =?utf-8?B?amNyaWIzSGVYbTBwZnlGc2lSMDlFbzVhNHJDbHh2bzFmeDYxRExPaFFUdGFN?=
 =?utf-8?B?YUhUWlVqWEVRdE1tVmNzY2lrbVJCUHZHTlY3Smhrd3JabGVZSG5UVmRQMmRD?=
 =?utf-8?B?ZmJEOXN5bndEZzRKZXZBQWg3RVUwZmlSWnZ5VVRBQXdQaG9DTitVNWZlSUtu?=
 =?utf-8?B?d3MvYjY1WlBFSURnNHdoVCsyOGpOR1hVVWo3cmxWa0FZNnkyUmNuUmNvN2hI?=
 =?utf-8?B?QkFKRTQ0VmYyakoxbGJUWjBWaS80OVRsK1FqKytLNGdzNjIxNVN3eklVVVBR?=
 =?utf-8?B?Z3YwbThvYk5vOXlOdzF5dnpRMVNGTUdNbWc2YWNabHllWUp5YjMza3hwb0lz?=
 =?utf-8?B?d0V0cDhDb3hOUElNRW1xVno5SFd5TzZ4K3FnczVhM25rOWFWRWEya01aQ014?=
 =?utf-8?B?TEFoYUREVm1PdC9vNUxPRmdUcXdLZEUzRWNuUTRUUm5pTHVxdjM1VG5LMmVQ?=
 =?utf-8?B?OWRxdHFZY0I2bU9JYURscnZ5ZWt6U1plb2ViKzdTZ0N3RFhQVkU3Q203cTNq?=
 =?utf-8?B?YnNRVWZ4aWpubnJsMlZUM1BoM3BhQVhVV2UzVklUMHZldmdNV2ZZUk9kMVFX?=
 =?utf-8?B?Z2FlYkp2K21yd2ZPWnZMS0pDMjVkb2lLZ0krK3pCMjRSUG53eGV4OE1JeTZp?=
 =?utf-8?B?d1pBam5HYURMNHRtYWN3S0xMakxsYnhsalhWZXc1Mnk1ZEFyVGhkS2VXOXAw?=
 =?utf-8?B?QzlNOU5ZNlM4LzZOa2hKMUZUOUVxb0RrRWJDRHNWekdsc3F3RTd1Q05nZ2dp?=
 =?utf-8?B?N1R6d013aGNMdFR0Qm9JbDFsQmFwQlpXd0JnanBTQkQyWDVsWVlRRmJ3WFlm?=
 =?utf-8?B?R1hqczVJaW4yNUZjTXI5UEFISGdyZi9QSVY3dE9jdk96eGpXWTZNZERNUHV3?=
 =?utf-8?B?V21xSldidnJZSGgzT3dkblN2bmtiT28zSG5HcVJkQzBmMVV4L2xCWjErSWpj?=
 =?utf-8?B?TloxaHk2LzZmc3ZRN2NwY2o1ZXdSNHdrNFFTZnljeCtwWElhdU9RRS9SRmpK?=
 =?utf-8?B?dTk2dkFmc042Zm5TMDNOUUxueVpGbUt5ZnVZQXg5akkzVlFPckZNUTkyK2RO?=
 =?utf-8?B?eTBWRHFLYnZsUTc2VTlTbEhmTC91RUJkQlpvNGJYVERxcHIyYXJQRWZqUWZJ?=
 =?utf-8?B?RmZ2Qkg2UFpIWFI0Y0Y5VGo4Y1RXRnZHdWZtMjd4R0FXYWtraU04N0V2VGEz?=
 =?utf-8?B?eFp0d2tMMThlbjRoa3E1L3p2NW9HN1E1NUlkdTU5L2tEY1k5SDBLekRSZGFE?=
 =?utf-8?B?K2p4dTFzcmV1T3hYTnZsaC9ZVzZoZ3ROb0IreUkySmhSL0lOZ0NJNEVqQzRw?=
 =?utf-8?Q?xAvH1A?=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(1800799024)(7416014)(376014)(35042699022)(82310400026)(14060799003);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Sep 2025 14:04:53.1736
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 29665885-24b2-4bbf-3c51-08ddf397ad7b
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AM4PEPF00027A64.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBBPR08MB5915
X-Rspamd-Queue-Id: 2229C40005
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: dnjcwb1fr9njkq6b6qeyfae369adwnop
X-HE-Tag: 1757858698-120817
X-HE-Meta: U2FsdGVkX1940UhKj1slxXyldGVpPhtcp2stwcf9LqFIt4OeBjMacGf2de4TC4L+bA+gEM2o+C8xdlWPn7bsj40hg2h1ZjfjHV9kEQrowWtgS5BgFYFGSIEBLxbc/8VKivvVcn7E0Q5IFVLgnN8jQbv6YPFDSHzJhucpnjdTJZJ6CyxuUR1416XFT3YNGCk0fNuK80U7YGSk3jASOmFwr4cV/UsWIsv3CMOps3x/L9AYD//UpR3ZtJLuPrFUteWVGqhh/pLaL00RuyDwbLYsRCL8YaYf2Oijg23JDGBCHsODkfYBysCNSbZAdNo7VYopiEB19S6Ac68K92BDHmcsQ3+M1sRcXZSiYpmy9UnMINPOsQL27mnnk+VWdnfJsDDJoR5pegp0oUgAoKFlxlrOrETFr3NHM5qBOlyuw86roBvYq4F5odPHFXfB0TDFU47QfeHdPvs3DLViL83UtiL0ztNR280UHyUCG6YlNZn/QkbgvlPN+enqJcvaFISaCfzXA/q58R/RTv0hqArsuBQ6KsHBv/53rgr0Y9eETJ8KqXnmettab4RmPevOdNYuuJT5Sj6JrCma/XHpoDx8bK5oys3XNsO50AbuaZek8csfq6G8oNXsdnodfMpbWrWGUd4QJfaRNA72Avoh4R/03ccfQz+5wHPmgJMAZqKzSGli9meMI+pEUCwWP+RvxH4H0l9d6NpttFfbgmFk42CWhq7luDi4Old8auHPlMWSNEyLLlMjKJxpFphzX7rf4ctzoncYgn4AQZc/LzV7/UZJiJOnjdFMkHz+DPCWqRXb2Q8uuZekDBkiMNCs+RawdNKtczzzwaUXkw9cdDMpQbiX+cuLQ3EpS8IEoqHvV7lJqo3EhC5dkTyh0L7f6EwII8AkF1B+aH3dvF25Yyg0y+KmXeeQKF8xPM0lPGsvHi341DZTeKB2P2z6xre01ljV3aG8k4PjLkqTkFtmAd0c1KCFOUW
 1mVqwM2u
 9+Jdn
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

>> ---
>>   mm/huge_memory.c | 3 ---
>>   1 file changed, 3 deletions(-)
>>
>> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
>> index 26cedfcd74189..aa3ed7a86435b 100644
>> --- a/mm/huge_memory.c
>> +++ b/mm/huge_memory.c
>> @@ -4110,9 +4110,6 @@ static bool thp_underused(struct folio *folio)
>>   	void *kaddr;
>>   	int i;
>>   
>> -	if (khugepaged_max_ptes_none == HPAGE_PMD_NR - 1)
>> -		return false;
>> -
> I do agree with your usecase, but I am really worried about the amount of
> work and cpu time the THP shrinker will consume when max_ptes_none is 511
> (I dont have any numbers to back up my worry :)), and its less likely that
> we will have these completely zeroed out THPs (again no numbers to back up
> this statement). We have the huge_zero_folio as well which is installed on read.

How about just doing a memcmp() between huge_zero_folio and folio? We know
exactly how this folio looks like, in case of max_ptes_none == 511, if it
is to be eligible for shrinking.

>
>>   	for (i = 0; i < folio_nr_pages(folio); i++) {
>>   		kaddr = kmap_local_folio(folio, i * PAGE_SIZE);
>>   		if (!memchr_inv(kaddr, 0, PAGE_SIZE)) {

