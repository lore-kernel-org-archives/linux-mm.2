Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 40D26CA0FFD
	for <linux-mm@archiver.kernel.org>; Mon,  1 Sep 2025 08:40:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9A6468E0022; Mon,  1 Sep 2025 04:40:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 955DE8E0018; Mon,  1 Sep 2025 04:40:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7D0478E0022; Mon,  1 Sep 2025 04:40:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 6277D8E0018
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 04:40:15 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 077BD13AE92
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 08:40:15 +0000 (UTC)
X-FDA: 83840034390.24.D1CCA6A
Received: from DB3PR0202CU003.outbound.protection.outlook.com (mail-northeuropeazon11010069.outbound.protection.outlook.com [52.101.84.69])
	by imf13.hostedemail.com (Postfix) with ESMTP id 1808920007
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 08:40:10 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=arm.com header.s=selector1 header.b=IVnYWwQ8;
	dkim=pass header.d=arm.com header.s=selector1 header.b=IVnYWwQ8;
	arc=pass ("microsoft.com:s=arcselector10001:i=2");
	spf=pass (imf13.hostedemail.com: domain of Dev.Jain@arm.com designates 52.101.84.69 as permitted sender) smtp.mailfrom=Dev.Jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=3; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756716011;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DqVzSu17p/EaXSsv5d7NwycIDVlDERjtxBDCDFG8lnI=;
	b=xTONxWE9FRqHzLRI3L+UZs269iPRjZW1ILIdgq2+tx/5d0H1Vi4eeF2o3GIrCPoMcWOkbv
	ghguXdl0ivJqL6358TT3nzv8XOnXaxaXf3PU062F+pjZZ496Cm9c50BEQKDDkYl9oKBYPK
	7NCygjzfunliwPCVXS9I4vbXBFGMTlQ=
ARC-Authentication-Results: i=3;
	imf13.hostedemail.com;
	dkim=pass header.d=arm.com header.s=selector1 header.b=IVnYWwQ8;
	dkim=pass header.d=arm.com header.s=selector1 header.b=IVnYWwQ8;
	arc=pass ("microsoft.com:s=arcselector10001:i=2");
	spf=pass (imf13.hostedemail.com: domain of Dev.Jain@arm.com designates 52.101.84.69 as permitted sender) smtp.mailfrom=Dev.Jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=3; s=arc-20220608; d=hostedemail.com; t=1756716011; a=rsa-sha256;
	cv=pass;
	b=GJ4CnJthnZFbl8N6BGG2ouTYmiAr3MNvHoVx3WIDI+3E1T4kqVInvlVDIJhfT8XwpuWmvv
	X5VrV4OcXiFXnMNGNKdBCgl9Z0tWTqAMsceHcjpeTsux0NS3traUDgFGJ+jSCcbwcbK/Yl
	yqKvfbS+2ts0o2vXeHDa298Leatx8JQ=
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=mzx1/mX3UbZDNzi0ufONliaC21xjUeWdtPQzJx3oX5He27c4Ala3N1j8DrYZCTdHX1bja5IS/wGZpgYA/MjfU94dcd/1VR9YQv3Pilqsi9JgJ3M2oAgeqvtG/zaJOyYsnB7Dc2/1aRTjFunT4UJcLZCBlGmnuGDv9jEUXF8gcfI1pNfVyIJYXatl6Tl+DCtEer48bmahZNgwTqCWOuLrmw2oNfWZG00DkihD+g4IjjFX33SvrdJ7l9cAWgXIYH25XHfmpTJAYD2QeDNA+qNEKxT4dCLXwtXzv/HOf+GwjgWcCAc+v8njuAHKk/r75gF6AUHn6zKmz3uzkDyyFMksGA==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DqVzSu17p/EaXSsv5d7NwycIDVlDERjtxBDCDFG8lnI=;
 b=VSq6Ka4ZHdQpGYF4S1HhGVw0I3WXkwX1zPp447mYiG3z1EyjQT5Gr0PsuVpy+r2U5zbLEh7gQ5TkxjjeV+4U92RrAB2pjW9wCS8SCsu3YFo9vqEwCcmJSivog/Dy47R74THkFdccg9nxFLH99aP+vcXfMeY7mf97B8sFFkmITrXqlDWT80Dsp4EEiYrshiQbOb+dSCMfhA7Sl2oVX5uwgVVaO2mMsEEgvY91Jmalvb2eQ1R8apwFcqr+48ozMbXERbr6rIP98/TbfSCzp0pymv71NChcoZfwx0mPor7/F/PulOl7gBW2KnC0LtDMX4yGOHuv/zLOLmDmwWNqIeseLQ==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=kernel.org smtp.mailfrom=arm.com; dmarc=pass
 (p=none sp=none pct=100) action=none header.from=arm.com; dkim=pass
 (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DqVzSu17p/EaXSsv5d7NwycIDVlDERjtxBDCDFG8lnI=;
 b=IVnYWwQ8jQgbs38dbXRzfIBhgUVPclS2zzMOG3QHMg55q5Ec9hVdNTtFeTwP7CHv6+kvVxd5w83mRy6KAf/45sxkXU6CGvOIcxmxgsqULkhBj0iBC+b+4QbkN/pIDeUv5bsHeW34E9RFkoBsMElXP8rMDf7qRUyZAtiVnN4DNcA=
Received: from DB7PR03CA0094.eurprd03.prod.outlook.com (2603:10a6:10:72::35)
 by AS4PR08MB7949.eurprd08.prod.outlook.com (2603:10a6:20b:575::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9073.27; Mon, 1 Sep
 2025 08:40:04 +0000
Received: from DU6PEPF00009527.eurprd02.prod.outlook.com
 (2603:10a6:10:72:cafe::b5) by DB7PR03CA0094.outlook.office365.com
 (2603:10a6:10:72::35) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9073.27 via Frontend Transport; Mon,
 1 Sep 2025 08:40:04 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DU6PEPF00009527.mail.protection.outlook.com (10.167.8.8) with Microsoft SMTP
 Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9073.11 via
 Frontend Transport; Mon, 1 Sep 2025 08:40:04 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=pl/lPXprCDzeARNjFZtoxEEOlclMvKtw91mgYeSBKSqyONKpcsKG3gzqoKveanGfOzeMkrGBJYJmpame4/B3Gqol99PrCj57ebIlGfiofXQQoSPraGxnf1G2cf0u4uVLDr3KQyB+qSXH7fq8hrkm8HovAniSrQVPTDBUxFbxd0Mm5Z7I1b7/FnYEcWQkoWwL2Ee5KabsDd7cXBhkZaRTA8jdyNwtOkGlQvj/vg9FVDVLZ1n6I025ZzmyWkPc2ugSGd8AaadyWpkekp4rrQcntmD2Mc8KF8NorA9asieq4LlGZmNiTJ5KV95hn4QgsjVOFJM1wBSU5bZvjvU337JEqw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DqVzSu17p/EaXSsv5d7NwycIDVlDERjtxBDCDFG8lnI=;
 b=MZb9KCP+H+gphLcq5CY1mkX5XzmArU4mt12PjjYNltlWNpXp3hSL9bkAfQKnlfk/A8qAmJdHClr0JQynbsiE7ec84aONERuKcGm9flbm+lDb6pR3bTw8FZi1H5Whc5QznCeUY5BPosPgdVQfiCzv5hYz4ptLTiWT8RcbxuhdO5Ki2g7imH1bqOZzZjbspcxJp5CugMF2VgMMEqtNEFXA9FTd8mOGWpT8M76y3AG1RCHrVdaHXR8xnpzfuT1MIQ5+9O6SSnNB5R/K4XpzcAWHClk8jHxh3Tvjova6dgjxktehDHPeB4seqC8PTbyrKLCQgl2njrO74EZFTobRf4Pedw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DqVzSu17p/EaXSsv5d7NwycIDVlDERjtxBDCDFG8lnI=;
 b=IVnYWwQ8jQgbs38dbXRzfIBhgUVPclS2zzMOG3QHMg55q5Ec9hVdNTtFeTwP7CHv6+kvVxd5w83mRy6KAf/45sxkXU6CGvOIcxmxgsqULkhBj0iBC+b+4QbkN/pIDeUv5bsHeW34E9RFkoBsMElXP8rMDf7qRUyZAtiVnN4DNcA=
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
Received: from AS8PR08MB7111.eurprd08.prod.outlook.com (2603:10a6:20b:402::22)
 by GV1PR08MB11206.eurprd08.prod.outlook.com (2603:10a6:150:1ee::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9073.26; Mon, 1 Sep
 2025 08:39:31 +0000
Received: from AS8PR08MB7111.eurprd08.prod.outlook.com
 ([fe80::4ea7:7e71:7dd3:3b45]) by AS8PR08MB7111.eurprd08.prod.outlook.com
 ([fe80::4ea7:7e71:7dd3:3b45%4]) with mapi id 15.20.9073.026; Mon, 1 Sep 2025
 08:39:31 +0000
Message-ID: <02504821-08a0-409e-a64a-3bb48b02dcd0@arm.com>
Date: Mon, 1 Sep 2025 14:09:25 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH] mm: Enable khugepaged to operate on non-writable VMAs
To: Kiryl Shutsemau <kas@kernel.org>
Cc: akpm@linux-foundation.org, david@redhat.com, willy@infradead.org,
 hughd@google.com, ziy@nvidia.com, baolin.wang@linux.alibaba.com,
 lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, npache@redhat.com,
 ryan.roberts@arm.com, baohua@kernel.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <20250901074817.73012-1-dev.jain@arm.com>
 <7towtl2pjubgdil4csn5rg3usbai5xvzz73wqkwj5b5awh2iim@wfvahykzjrlo>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <7towtl2pjubgdil4csn5rg3usbai5xvzz73wqkwj5b5awh2iim@wfvahykzjrlo>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MAXP287CA0014.INDP287.PROD.OUTLOOK.COM
 (2603:1096:a00:49::25) To AS8PR08MB7111.eurprd08.prod.outlook.com
 (2603:10a6:20b:402::22)
MIME-Version: 1.0
X-MS-TrafficTypeDiagnostic:
	AS8PR08MB7111:EE_|GV1PR08MB11206:EE_|DU6PEPF00009527:EE_|AS4PR08MB7949:EE_
X-MS-Office365-Filtering-Correlation-Id: e297f122-8208-4ec8-2960-08dde93325e1
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|366016|1800799024|376014|7416014;
X-Microsoft-Antispam-Message-Info-Original:
 =?utf-8?B?cmhzTVk1UlN1YjZuUUk1SThNNCs1NjdnaEhMZlZ0TjEweXVMODVsTWMvbmk1?=
 =?utf-8?B?SExQSGJINkJBSzVWWGQ3NGlDeGVHL2ZKeWo5VmtKdXEvUGZIeFZrVFJWT3Qx?=
 =?utf-8?B?VjhKYVI5RmlQU3czbkcvbTkxeWxyN1l3eEpyVWRIRnR1cVlKLzdNWURVWGNV?=
 =?utf-8?B?SmlRenNYeGU1V0NzWXRadTBZd3VSQ0xLTDgzYm9VZ29iT04yRTRTU0Z4UlIr?=
 =?utf-8?B?cjRrNWZ2eUZRb0tSZjRERUNmMzY4ZTY5Vk9wcVZDVmdJdGZQdU1SUi8ycXFs?=
 =?utf-8?B?TDJ4N2hpNnFTOHhmL05UUGh6aGNVaTdGZC9pY2RMQVUzM0J5WWx1Mm1KdWRR?=
 =?utf-8?B?VWZ6SVZCNFgzOGMyekFMeSs3eXNidVFzM3lZNU5WOEgzVG41RHFQZituTi8x?=
 =?utf-8?B?cGZVNXZPamFKLzJiYzFka2tiTW9MYytaSUhBRzYweDk3R1R1RDY5dXJTc2RZ?=
 =?utf-8?B?WllOb1RvSW03bWNhbFBMNkg0YnlBMVZvSmJwWVNLcDhZdmVSWUJ0T0ozN01n?=
 =?utf-8?B?OFB5R2FKbEtMajI1SnRaRGZPTGhUdHlnbGZ1Y1hSdHA0V0JjSUw1Y2VBaGFt?=
 =?utf-8?B?RG5zS3plazhjNHBkOGgzVTFGVnZMelkzM09Zd21tSmMwWW1WWEVpS0tMRDZ5?=
 =?utf-8?B?MUtNb2JveEtDRXZvRDBOVUxxTTFJeDFhRWRycCsrQUhzZi9XK0UrcXhoRUdV?=
 =?utf-8?B?TWR4TDdmajFxSk9EV3hqbG1KZHpvdjlBN1Q4ZEFBSTdXbDNxZzNjZ2JDcUVl?=
 =?utf-8?B?UFZvdHJlQnlHcDQ1UEhoZmhFRWZNQkdINFk2bmJGRzhnQ29pNW5ucHg0eGxH?=
 =?utf-8?B?YTVBczRDbThHcW1qOG5uSU1JVTN2S2E3T0UxWnNlNHR0OEd5YnJMZ044RFFM?=
 =?utf-8?B?a1QzR3ZtQmlmWm5ySDdlQzNsRHFCV1NWNnIvRFQxV0MrSmhDNzhQQVJyZzd0?=
 =?utf-8?B?M1VpSEloUUhmMVhUNHVYNWVSVW9rVXZHYXRRbzM3RGQxeGhUcVZucGVVWUtZ?=
 =?utf-8?B?UjBXL3NLako3UWtaUlcyUWFEaHRYaUtINTR3SHpXc3BrVEVLeVlSN1pVTTU5?=
 =?utf-8?B?YjRteXZPYm9VY2w5aGdaeGpJM1BjMEdPRmF6bnJPNVhralpLMTBFbnlVK0NZ?=
 =?utf-8?B?ZndVTUw4Snh5aktTZlZraHRHNnJsKzhVaGJQYVRSVzMyclIvSDdYMVZacS8x?=
 =?utf-8?B?Q05ISjUwbFNielRaSXRtd0NNcWN3dWd5b1JJQWIvbmNtb2M5aUFLYUQvZ1dl?=
 =?utf-8?B?R1VPRk1XajBrUjNBSzh6M1VQMnlXYTBZN0VPSU0zMkoyN3JJQ2pBUzNWSTZy?=
 =?utf-8?B?ekNyWVd3enhSUEs0STZRM21POEc3Wldsamlmeldwcm1tL1FFU1ExbUYveVVw?=
 =?utf-8?B?YU9SMlVHL0lVL1NrK0xmRGllNjY3bmk4UE9VZ2JoK3lrNkYzdU1IVEhVSW5Z?=
 =?utf-8?B?NUlXMUwrdmEwWDFpd1gyTmhyaTk5RkZBWFkzVjFuR0h4VmV2SU5jY0xEcmZB?=
 =?utf-8?B?SDZNaU1TdExVNmpoL3BQSUNsbzVDNDNmNmFYdEptUWpHS1ZRNkIzRkFmaGFo?=
 =?utf-8?B?YVdEcW92djhPamU4RFU5QXp6RFdTeStHaTduMVJoWHg5K3ZOS1dSdkdmWUQ3?=
 =?utf-8?B?T3NTd2llZ0Q0ZG01Sk5HdDVkYWh2VjJ2QndzQ01ERnZFOHBER3FTUHIxMVJS?=
 =?utf-8?B?STRiNEZuOGFFUFFzcXcyYThDNUZWamR3TVZabXFnVXVBSXovdkNzVlNLS2hY?=
 =?utf-8?B?Rmc0M0c2UUI0OXR0VXhTWnY4VHk2eDJQL01BU1gzZ2pndmpJM2h3UlkzdXhO?=
 =?utf-8?B?SFdhczMrRC9LR0ZRUzRDVitDU2YzdU9ib2lxUWVvZVlWU2R4RlBkVzRVRU1K?=
 =?utf-8?B?SVpUeGZqMkFtMEhNZjJrUmVXY0RseVF3R0gxOGxUTzd0YVk3czZQSm0veVZB?=
 =?utf-8?Q?tPS9iK/9SR4=3D?=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AS8PR08MB7111.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GV1PR08MB11206
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DU6PEPF00009527.eurprd02.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	a39b17f7-42e4-4f4f-3fb4-08dde933118e
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|35042699022|82310400026|1800799024|36860700013|376014|7416014|14060799003;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?ek1RVnFGYXRqamxyRitKbVVFV0ZNZk0yeDNkTWo2b2ZIRUJSTjdyQ3VJOFhR?=
 =?utf-8?B?a2FYcytNdkY1VWlrZnY2bTNjOGw3TmpOWDlBak5jVW0vZ3JqcEhESisyVExD?=
 =?utf-8?B?Y2FMZkZ3blBJakhKK2lybVZacXB6V2lCRmtxRlEwQTRHa3lTWGRENitjdnEv?=
 =?utf-8?B?OEk3MHBkZDhZYjNudWZCWjkrUHpNdDN4TXVVNldRaHhtWkllQzNGTFZtMFQw?=
 =?utf-8?B?VkxxcnBLS1NJdXl0LzVtTE8rNTVmRXJVeE1ZTFJkcU1Gd3M4YmNWSGQveXJD?=
 =?utf-8?B?ZStmNHhCVnM5QzRXMlJBN2lGT0NRaTJBT2dwZG85OWlBalk3T2JsOEVHTUIr?=
 =?utf-8?B?UkZyVGRqRXVWZ1JmNGt2ZlZ1dXFubjZRY2NlOEw3anVsNURzd1FMK0wwdkti?=
 =?utf-8?B?K0hrUEVkWndDMVpLbGxkZ0VRWVJYNVY0aDErbUgvVGRINGkxL3NEVURKWEVp?=
 =?utf-8?B?andsUzk3Z1JKM2U0MVVvaGZvWUtsQm9iV3BLL0xCS0k3aDlBYjcycXVuTnJl?=
 =?utf-8?B?cmtQcnpHS3JyMnNKRjhNUnlmcy9nMnBJZG1McXNESmhQVHIrdzNVUGthQmZS?=
 =?utf-8?B?ZlYvZGgwTzNWSnBBQzEraURadzJTMGVlU000dFBaaDNkak9DdVhyOVBIQjFV?=
 =?utf-8?B?aU55clBCSVdZRTBhQlRQaXlYR2N5VTAzZDNuOHA2emNvanZZWDErRGVmS0xs?=
 =?utf-8?B?RThlUlQ2S2NSWVpHSXRZY1hRL0RmczgxWGd5VnRYaUhQVWgrNlVSdktjcGlW?=
 =?utf-8?B?dXB1cDZMSkV6YWdpVHRkYlo0NWpNSXhyWncyU1hDQmlyVjdqY0JLWlRtakFz?=
 =?utf-8?B?S2tpdC9hbWJ2WDZBV2lKdytpMEt5VURmR0RIMXJLc1B2Z1F5dG9Fa0ppbWhB?=
 =?utf-8?B?YXFXRVh3aFEzRGRnWUNjVFlFbEhXanN2dk5lWHBkbDZ3alZzK3YvdjVFVUtK?=
 =?utf-8?B?Ym9OclVnb3J0cDN0THNxbjBYeTJmQllvVndBQ1RGdUh1d3E3RjE4bURWU0hr?=
 =?utf-8?B?RUQ1dXJMeG5IeU11a1VwUmdJUTE4U2tBWE9uTHFuNnY5a1BPL1dXMHExUDF0?=
 =?utf-8?B?K09pSGV1VE9KNGh3dENSR1JoanBrbDhYa0NKbko3U3RLUGhUYnBBMGFQdE10?=
 =?utf-8?B?akJ3UkxxSGlIb2F1bGRwaHB5Ni9FNC9zYlRxWlc1SkM1a1lWVmdiR2JtUTRz?=
 =?utf-8?B?Z0U2bDZWTkI5eklQL2J1MFRaQW1tZzZnZHBBSUx6VFkwY1VGbWNDMWRpTkZy?=
 =?utf-8?B?dVFEUi9IYXU1TXNzQlluVWN1dlBMaU45K3o1QjJzeWZFdFZNTE8wdmN2aENs?=
 =?utf-8?B?dUpDNlExZFY5TUg0Tmo1V3R2SGdGcXk4bTVDVm5MSnc5R09oRTFwVTZtU3JK?=
 =?utf-8?B?YmJmTkpXa0t0c0tMeVExSXljbjZsV2lsRGl5aTNCQW41M0Z5ek00bFBFREc4?=
 =?utf-8?B?Wi9HZFJJQkkxMUlEcU5hS2Z0TnlrV0ltZEs2YjZPeU1vcTB4amZNYzRqbEdU?=
 =?utf-8?B?UUp2VnJLaWlMc2FRN1lUV0NTTVhNemppSFluYXJrZU56cXRsTTk5S2xQWGNn?=
 =?utf-8?B?U3IwbzZJU01FbElWUzZBZFNMQ25ySnU3MzdSdnQ2TEk1Slo3emJ3dHY1SktT?=
 =?utf-8?B?ZERLak9adHlrTkhvMEVNNVNKTkp2QlZSZHpvNWtpelk3cVN0ZGF5Z0RJRTN1?=
 =?utf-8?B?R1NqLytYMVJKTVBSNmw3RFNGMFJtNWxyNG15K3c3QnA1QkdKSXlRS3gwZkxt?=
 =?utf-8?B?a1ZERjdDS2o4UzQvUnhvZUs3VG9wSy9xVlF4WGFzR0oyRDJYYm9JeFZQYUU5?=
 =?utf-8?B?NkpPWWR0bVpSWW9MUGFmMUFkam5kMWhrY3ZtaHZWbWkzRU9iVFhTeWJEbjV6?=
 =?utf-8?B?cjNyRnRZZG5Cc3RpZ2huUW05YXc1MHJ0TUFhR1R5aXRFYzAxNlA5ODBCU2Za?=
 =?utf-8?B?VXZDbGNxQXFZaU0wZzJrbHpOZzJ2NmpzdFpFMmV0SUNDODgreW8zVlpxZHlt?=
 =?utf-8?B?SmttWFNhenZKVEp2RVZPck9tVFhSajNhOE9LU3N2WkdidGk5K0lvdzd5czNn?=
 =?utf-8?B?aENaNUdGbndVRDViWThPZW1ZQkt5V0VEZDZ3QT09?=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(35042699022)(82310400026)(1800799024)(36860700013)(376014)(7416014)(14060799003);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Sep 2025 08:40:04.3513
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e297f122-8208-4ec8-2960-08dde93325e1
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DU6PEPF00009527.eurprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS4PR08MB7949
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 1808920007
X-Stat-Signature: pisgf4csiraaomweeajbgzhkuhsy5ewt
X-Rspam-User: 
X-HE-Tag: 1756716010-579723
X-HE-Meta: U2FsdGVkX19g9Upuye0iedSi8ppxoDNDzIqMOX8cOl9a6OnrrRhu8QxZbKZBQLUjxGBC9agAPr8RZFsxkI5oJJ99mzxj7UsYMC0jd024Op6jtZ4qMaaADjiXHkhbJzYpLLp4hgoqFBDtGaUzaT8WhVcR7UaX6IcapXlCNX3GUA2xQraTJoHcpLbnnIA0MhEEkl7uHWOJiVeXCsY7hevasE1WxEk089yAzs3qTPc2DpGyfCoBpawgLSrWW9tGDNOOMcjeOwBTUQQgM9inxQU9Z3g5XOYZPcWUJT6Aa29wfjH92uYC8zcNSkQ5qYO4m6tG2PIFU1nZsJ4wN1GkDHdxPsvrKGie3XlzeAT9HaDIpxfsnWVRRTRqpQp2NO45qnce/MiV5WqO68E1aIG7GniaeCzS8rzpSiU/8bHQBcF+2aSWo1YyvPt+hVYzlXEkM8dVuNvqBbv/zahmoTkiURWYnJLp5mzwKUjUdFapafhDaEc2C7SHJUj1FcOPsMXWOGmh61tSV9Yi0TpEc0nQ9W8diQiZ/2dnr8U9SC8MGfQrwsS2swnudisC4LTT1tWkjsq3EIvZbOOd+B2NUfPNCd+zx8FvqtE2AcX5P7wdc5MYaHDAO8tp07RALK5mQu6dcL34KmyGqgBddojTv5qxYiafKB0AYQozhyBSY+n6952rMMtzWHW1G+oDSpSZ5QtYAAlXxhKTHzXd+EoGF43joTn9Acmdid5q3R5eN2zVgoP/j7QHdI5DCwJaC+D8GjxlrY/g6Co2XVmXxAacU7SwZtszp1PRcMrZShXPkaGD/FmCoIYsnOHqnXuadgTTaBktbkiTquABF0MDmzHwfsn5Bd9XubhPWUrsoJc3aF1lHfwqQEfmXB7v9clnZimrZwmVYu6gwt6b6FeWoBFURx+lY1kbJzQTDqSviwqMhCiL6NKg88C1ys68eaH/RhIe9FhA8yrthBfZbDzcm6lbssbCcqy
 s+xb1N9O
 5dHn8I2UU6Jj8AM+1+6PmFsxj6Yq7In4pcaUPxSRcXAohCjhZPnQKAbqtEdtK5dXXyQRmmxV2Yqc1Bxw8lynBs3OpBL1xgQJR3P9ULfh18iw6mEHgwY1583HSMSGVJ/qMag6UnLUtaHmrhUPdXiGKWyHAe/H0zjIIPy/WQnxDVYvVijMeqTVfQhMfJE6lH8xMHHmFvJF08sMh2dlhenYIOLifk3vI7M1G8S+p3Q2pZ4dpWQYq2765yk0WmYuf0XrTBpktd7piheRQn9hew0q3dQgeMpVJlBkRE6RgqKmBzzQIk/U5PbGCbLvXKYyBE8fC8oVVk/YvfA7dAYY0vY4XxKJxrNnEOPrLtwT0uhGmaewn/WsVz0dBXZOtNmGgyHl3Ds2lt/soQ70e6E1Z/8IDeLNkQIagpLDkDEnEH8Vo/KM2cFUvEVsGiQodpaFSlLwFwiQUcSJ6+QLaW5yUA3yIp4GvUltFY2EhmIdtMeA1V5PU1PMIDgOBmfWTq4sSSvTuhZG6kI7tDPwAOioBeDHzkmw/RLHlcFgZ1euOlove8QTRSS6CufG2JIezmY98AHZNaNmt3eRTn3cLwYbpoba/ZxGgrA8oRrIQ/zwF2UN0dHBQ9Ums2A/f5FKoVQv+thWN/OwaxDzd2H/6fSmlbfRqjPTSi4uBnHqH/lXVJb8fXwG5+qVIZgdmC5uppd/XeZ9Md/yHBKn0TNg3S/dy77KC0kgef6XQlfqH0SV4myn7N2sxq7g=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 01/09/25 1:53 pm, Kiryl Shutsemau wrote:
> On Mon, Sep 01, 2025 at 01:18:17PM +0530, Dev Jain wrote:
>> Currently khugepaged does not collapse a region which does not have a
>> single writable page. This is wasteful since, apart from any non-writable
>> memory mapped by the application, there are a lot of non-writable VMAs
>> which will benefit from collapsing - the VMAs of the executable, those
>> of the glibc, vvar and vdso, which won't be unmapped during the lifetime
>> of the process, as opposed to other VMAs which maybe unmapped. Therefore,
>> remove this restriction and allow khugepaged to collapse a VMA with
>> arbitrary protections.
>>
>> Along with this, currently MADV_COLLAPSE does not perform a collapse on a
>> non-writable VMA, and this restriction is nowhere to be found on the
>> manpage - the restriction itself sounds wrong to me since the user knows
>> the protection of the memory it has mapped, so collapsing read-only
>> memory via madvise() should be a choice of the user which shouldn't
>> be overriden by the kernel.
>>
>> I dug into the history of this and couldn't find any concrete reason of
>> the current behaviour - [1] is the v1 of the original khugepaged patch
>> which required all ptes to be writable. [2] is the v1 of the patch which
>> changed this behaviour to require at least one pte to be writable. The
>> closest thing I could find was: in response to [2], Kirill says in [3] -
>> "As a side effect it will effectively allow collapse in PROT_READ vmas,
>> right? I'm not convinced it's a good idea." (Although Kirill realizes in
>> [4] that this was not the intention of the patch).
> Hm. I don't see a justification for only collapsing writable pages.

Glad we are on the same page :)

>
>> I can see performance improvements on mmtests run on an arm64 machine
>> comparing with 6.17-rc2. (I) denotes statistically significant improvement,
>> (R) denotes statistically significant regression (Please ignore the
>> numbers in the middle column):
> Could you give a summary instead of raw data? It is too much for commit
> message. Raw data can be put under "---" for reference.

Okay.

>
> BTW, why did you pick hackbench as a benchmark? Seems random.

I didn't actually run mmtests myself (in fact I have consistently failed to run mmtests - someday
I'll gather the courage to figure it out again :)) - I just start a test pipeline which runs tests
for me and gets me results. The pipeline ran sysbench-cpu, sysbench-mutex, sysbench-thread,
kernbench and hackbench for me. For the others not mentioned in the below table, I didn't get any
statistically significant results.

>
>> +------------------------------------+----------------------------------------------------------+-----------------------+--------------------------+
>> | mmtests/hackbench                  | process-pipes-1 (seconds)                                |                 0.145 |                   -0.06% |
>> |                                    | process-pipes-4 (seconds)                                |                0.4335 |                   -0.27% |
>> |                                    | process-pipes-7 (seconds)                                |                 0.823 |              (I) -12.13% |
>> |                                    | process-pipes-12 (seconds)                               |    1.3538333333333334 |               (I) -5.32% |
>> |                                    | process-pipes-21 (seconds)                               |    1.8971666666666664 |               (I) -2.87% |
>> |                                    | process-pipes-30 (seconds)                               |    2.5023333333333335 |               (I) -3.39% |
>> |                                    | process-pipes-48 (seconds)                               |                3.4305 |               (I) -5.65% |
>> |                                    | process-pipes-79 (seconds)                               |     4.245833333333334 |               (I) -6.74% |
>> |                                    | process-pipes-110 (seconds)                              |     5.114833333333333 |               (I) -6.26% |
>> |                                    | process-pipes-141 (seconds)                              |                6.1885 |               (I) -4.99% |
>> |                                    | process-pipes-172 (seconds)                              |     7.231833333333334 |               (I) -4.45% |
>> |                                    | process-pipes-203 (seconds)                              |     8.393166666666668 |               (I) -3.65% |
>> |                                    | process-pipes-234 (seconds)                              |     9.487499999999999 |               (I) -3.45% |
>> |                                    | process-pipes-256 (seconds)                              |    10.316166666666666 |               (I) -3.47% |
>> |                                    | process-sockets-1 (seconds)                              |                 0.289 |                    2.13% |
>> |                                    | process-sockets-4 (seconds)                              |    0.7596666666666666 |                    1.02% |
>> |                                    | process-sockets-7 (seconds)                              |    1.1663333333333334 |                   -0.26% |
>> |                                    | process-sockets-12 (seconds)                             |    1.8641666666666665 |                   -1.24% |
>> |                                    | process-sockets-21 (seconds)                             |    3.0773333333333333 |                    0.01% |
>> |                                    | process-sockets-30 (seconds)                             |                4.2405 |                   -0.15% |
>> |                                    | process-sockets-48 (seconds)                             |     6.459666666666666 |                    0.15% |
>> |                                    | process-sockets-79 (seconds)                             |    10.156833333333333 |                    1.45% |
>> |                                    | process-sockets-110 (seconds)                            |    14.317833333333333 |                   -1.64% |
>> |                                    | process-sockets-141 (seconds)                            |               20.8735 |               (I) -4.27% |
>> |                                    | process-sockets-172 (seconds)                            |    26.205333333333332 |                    0.30% |
>> |                                    | process-sockets-203 (seconds)                            |    31.298000000000002 |                   -1.71% |
>> |                                    | process-sockets-234 (seconds)                            |    36.104000000000006 |                   -1.94% |
>> |                                    | process-sockets-256 (seconds)                            |     39.44016666666667 |                   -0.71% |
>> |                                    | thread-pipes-1 (seconds)                                 |   0.17550000000000002 |                    0.66% |
>> |                                    | thread-pipes-4 (seconds)                                 |   0.44716666666666666 |                    1.66% |
>> |                                    | thread-pipes-7 (seconds)                                 |                0.7345 |                   -0.17% |
>> |                                    | thread-pipes-12 (seconds)                                |     1.405833333333333 |               (I) -4.12% |
>> |                                    | thread-pipes-21 (seconds)                                |    2.0113333333333334 |               (I) -2.13% |
>> |                                    | thread-pipes-30 (seconds)                                |    2.6648333333333336 |               (I) -3.78% |
>> |                                    | thread-pipes-48 (seconds)                                |    3.6341666666666668 |               (I) -5.77% |
>> |                                    | thread-pipes-79 (seconds)                                |                4.4085 |               (I) -5.31% |
>> |                                    | thread-pipes-110 (seconds)                               |     5.374666666666666 |               (I) -6.12% |
>> |                                    | thread-pipes-141 (seconds)                               |     6.385666666666666 |               (I) -4.00% |
>> |                                    | thread-pipes-172 (seconds)                               |     7.403000000000001 |               (I) -3.01% |
>> |                                    | thread-pipes-203 (seconds)                               |     8.570333333333332 |               (I) -2.62% |
>> |                                    | thread-pipes-234 (seconds)                               |     9.719166666666666 |               (I) -2.00% |
>> |                                    | thread-pipes-256 (seconds)                               |    10.552833333333334 |               (I) -2.30% |
>> |                                    | thread-sockets-1 (seconds)                               |                0.3065 |                (R) 2.39% |
>> +------------------------------------+----------------------------------------------------------+-----------------------+--------------------------+
>>
>> +------------------------------------+----------------------------------------------------------+-----------------------+--------------------------+
>> | mmtests/sysbench-mutex             | sysbenchmutex-1 (usec)                                   |    194.38333333333333 |                   -0.02% |
>> |                                    | sysbenchmutex-4 (usec)                                   |               200.875 |                   -0.02% |
>> |                                    | sysbenchmutex-7 (usec)                                   |    201.23000000000002 |                    0.00% |
>> |                                    | sysbenchmutex-12 (usec)                                  |    201.77666666666664 |                    0.12% |
>> |                                    | sysbenchmutex-21 (usec)                                  |                203.03 |                   -0.40% |
>> |                                    | sysbenchmutex-30 (usec)                                  |               203.285 |                    0.08% |
>> |                                    | sysbenchmutex-48 (usec)                                  |    231.30000000000004 |                    2.59% |
>> |                                    | sysbenchmutex-79 (usec)                                  |               362.075 |                   -0.80% |
>> |                                    | sysbenchmutex-110 (usec)                                 |     516.8233333333334 |                   -3.87% |
>> |                                    | sysbenchmutex-128 (usec)                                 |     593.3533333333334 |               (I) -4.46% |
>> +------------------------------------+----------------------------------------------------------+-----------------------+--------------------------+
>>
>> No regressions were observed with mm-selftests.
>>
>> [1] https://lore.kernel.org/all/679861e2e81b32a0ae08.1264054854@v2.random/
>> [2] https://lore.kernel.org/all/1421999256-3881-1-git-send-email-ebru.akagunduz@gmail.com/
>> [3] https://lore.kernel.org/all/20150123113701.GB5975@node.dhcp.inet.fi/
>> [4] https://lore.kernel.org/all/20150123155802.GA7011@node.dhcp.inet.fi/
>>
>> Signed-off-by: Dev Jain <dev.jain@arm.com>
>> ---
>> Based on mm-new.
>>
>> Not very sure of the tracing parts which this patch changes. I have kept
>> the writable portion for the tracing to maintain backward compat, just
>> dropped it as a collapse condition.
>>
>>   include/trace/events/huge_memory.h |  2 +-
>>   mm/khugepaged.c                    | 11 +++--------
>>   2 files changed, 4 insertions(+), 9 deletions(-)
>>
>> diff --git a/include/trace/events/huge_memory.h b/include/trace/events/huge_memory.h
>> index 2305df6cb485..f2472c1c132a 100644
>> --- a/include/trace/events/huge_memory.h
>> +++ b/include/trace/events/huge_memory.h
>> @@ -19,7 +19,7 @@
>>   	EM( SCAN_PTE_NON_PRESENT,	"pte_non_present")		\
>>   	EM( SCAN_PTE_UFFD_WP,		"pte_uffd_wp")			\
>>   	EM( SCAN_PTE_MAPPED_HUGEPAGE,	"pte_mapped_hugepage")		\
>> -	EM( SCAN_PAGE_RO,		"no_writable_page")		\
>> +	EM( SCAN_PAGE_RO,		"no_writable_page") /* deprecated */	\
> Why not remove SCAN_PAGE_RO?

I was wondering whether any userspace script could fail due to using this metric already?

>
>>   	EM( SCAN_LACK_REFERENCED_PAGE,	"lack_referenced_page")		\
>>   	EM( SCAN_PAGE_NULL,		"page_null")			\
>>   	EM( SCAN_SCAN_ABORT,		"scan_aborted")			\
>> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
>> index 4ec324a4c1fe..5ef8482597a9 100644
>> --- a/mm/khugepaged.c
>> +++ b/mm/khugepaged.c
>> @@ -39,7 +39,7 @@ enum scan_result {
>>   	SCAN_PTE_NON_PRESENT,
>>   	SCAN_PTE_UFFD_WP,
>>   	SCAN_PTE_MAPPED_HUGEPAGE,
>> -	SCAN_PAGE_RO,
>> +	SCAN_PAGE_RO,	/* deprecated */
>>   	SCAN_LACK_REFERENCED_PAGE,
>>   	SCAN_PAGE_NULL,
>>   	SCAN_SCAN_ABORT,
>> @@ -676,9 +676,7 @@ static int __collapse_huge_page_isolate(struct vm_area_struct *vma,
>>   			writable = true;
>>   	}
>>   
>> -	if (unlikely(!writable)) {
>> -		result = SCAN_PAGE_RO;
>> -	} else if (unlikely(cc->is_khugepaged && !referenced)) {
>> +	if (unlikely(cc->is_khugepaged && !referenced)) {
>>   		result = SCAN_LACK_REFERENCED_PAGE;
>>   	} else {
>>   		result = SCAN_SUCCEED;
>> @@ -1421,9 +1419,7 @@ static int hpage_collapse_scan_pmd(struct mm_struct *mm,
>>   		     mmu_notifier_test_young(vma->vm_mm, _address)))
>>   			referenced++;
>>   	}
>> -	if (!writable) {
>> -		result = SCAN_PAGE_RO;
>> -	} else if (cc->is_khugepaged &&
>> +	if (cc->is_khugepaged &&
> The only practical use of the writable is gone. The only other usage is
> tracing which can be dropped to as it is not actionable anymore.
>
> Could you drop writable? Maybe as a separate commit.
>
>>   		   (!referenced ||
>>   		    (unmapped && referenced < HPAGE_PMD_NR / 2))) {
>>   		result = SCAN_LACK_REFERENCED_PAGE;
>> @@ -2830,7 +2826,6 @@ int madvise_collapse(struct vm_area_struct *vma, unsigned long start,
>>   		case SCAN_PMD_NULL:
>>   		case SCAN_PTE_NON_PRESENT:
>>   		case SCAN_PTE_UFFD_WP:
>> -		case SCAN_PAGE_RO:
>>   		case SCAN_LACK_REFERENCED_PAGE:
>>   		case SCAN_PAGE_NULL:
>>   		case SCAN_PAGE_COUNT:
>> -- 
>> 2.30.2
>>

