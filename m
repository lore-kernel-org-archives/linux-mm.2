Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C4F2EC87FCB
	for <linux-mm@archiver.kernel.org>; Wed,  6 Aug 2025 08:54:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3E1CE8E000D; Wed,  6 Aug 2025 04:54:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3B9988E0001; Wed,  6 Aug 2025 04:54:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2812B8E000D; Wed,  6 Aug 2025 04:54:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 13EF18E0001
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 04:54:47 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id B1B511403FD
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 08:54:46 +0000 (UTC)
X-FDA: 83745722172.20.782E196
Received: from DB3PR0202CU003.outbound.protection.outlook.com (mail-northeuropeazon11010021.outbound.protection.outlook.com [52.101.84.21])
	by imf21.hostedemail.com (Postfix) with ESMTP id C9A3E1C0007
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 08:54:42 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=arm.com header.s=selector1 header.b=NoMQYcNp;
	dkim=pass header.d=arm.com header.s=selector1 header.b=NoMQYcNp;
	spf=pass (imf21.hostedemail.com: domain of Dev.Jain@arm.com designates 52.101.84.21 as permitted sender) smtp.mailfrom=Dev.Jain@arm.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=2");
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=3; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754470483;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dx8r21bufv4FNtcDnUI2GbSxAU2Xl5P+14JBQBfOT5Q=;
	b=ttbhMFqU0zzcNURs74lqLplkReWP/8mrGl8keyE5kX3wX9Y0a2kdcoegzfWXoWVpsyrYXY
	uExJXpe4SAHECmmRmKmrwHg2wSYuiQ1TwnNFu3I5FzM3iZoBnYYeYZyBUiTWHjw57BwMMh
	rCKXn4SG/vnrNw8I9QR1cYPsUEPBDmc=
ARC-Seal: i=3; s=arc-20220608; d=hostedemail.com; t=1754470483; a=rsa-sha256;
	cv=pass;
	b=7xNawiFxbh52tP70sJ3xEKLSVO0xjZHUmvRKu1J3RiE4yf3d+36upLGigoLI13Yz019JUg
	kOkwGKUCk9uZX4LTjuWTxGAxpHaHWCuBAU9bPHjiYD3sgBAZ1uVIBSAsg+qHzQCOYEtnlS
	ouWI+ufDtwipETCOAKuDikl9yji3t0Y=
ARC-Authentication-Results: i=3;
	imf21.hostedemail.com;
	dkim=pass header.d=arm.com header.s=selector1 header.b=NoMQYcNp;
	dkim=pass header.d=arm.com header.s=selector1 header.b=NoMQYcNp;
	spf=pass (imf21.hostedemail.com: domain of Dev.Jain@arm.com designates 52.101.84.21 as permitted sender) smtp.mailfrom=Dev.Jain@arm.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=2");
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=RESArMbBOmlXk1jB/sti4zyVStvbi3UmF13Fpv259aMLBRNaJoSLlkvmcfpnwY+OPMzwntAPJyt3jYG2HJi/mNExkbIZKCQ9hxYYFp9vqO/rm/pxPndkjN31utFVkOuCWfy2lKs+8AyyX+rb4UuuTovKhRztwwrgBVc2ZM9Rld0qVKBAbJcv1Yc5gyJiygw8D7+UmCX5Ixeura9LGeXCRzTmbr8SyxXFV7POZfN2j/GJMZXe5WYV7LSBhx2ntWSgRH35xrRBMxH4tYVzDlhmkyUaUzrRq2N91ucpz+qdB2lmpeuLhE2DqCf6/q7Brk2gnN4c2FhdtIBoHlrrtzn+dw==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dx8r21bufv4FNtcDnUI2GbSxAU2Xl5P+14JBQBfOT5Q=;
 b=j6bzJ4a/BG0UCZWg4Bg99XW/BRKVPAaz6hrNvQLw9pfoJahsiFMxz6Mnad3cb6J4gWmanK3lXP/+rYwKilQ7IGpG15xEe61cf7vS6xEsxhqeWphLSIVBwVthHOmzrxnr4npe2FAP+E33M1t/++ug+WbOYkj6DP23fY26oa0e7PTmEhu708IKy7UJGaFOpB+c3RbJzdy49OwNG5DcwPzxKcY5SJb1tqVqAawmnZWHFkEpocyexNMxf/om3k5EaLRpGzRZNf/w+PtWCHOCmQGl4NUu/mmvxMpm5fmjLwBgj/vYRxCOrHwXz6dQCB8BX8s4h7KHSIbAtVCAxYKg15Ifdw==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=redhat.com smtp.mailfrom=arm.com; dmarc=pass
 (p=none sp=none pct=100) action=none header.from=arm.com; dkim=pass
 (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dx8r21bufv4FNtcDnUI2GbSxAU2Xl5P+14JBQBfOT5Q=;
 b=NoMQYcNp9Pn9brB6Uz2Thf7lNeIZP5MVd7udiwUmYGrGVzDWf42/Xvix6Q0uoTV6qIt49LJLcsho1g4rOK0HSX73ZfCsVa7DJDk5podE+fx4VmFvcqCotGscIUeqzDnnpG1jW4Kg7sQryi1FQbRWspukldZE5rz5HSg3EKWIftM=
Received: from AM0PR04CA0138.eurprd04.prod.outlook.com (2603:10a6:208:55::43)
 by AS8PR08MB6086.eurprd08.prod.outlook.com (2603:10a6:20b:29d::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9009.14; Wed, 6 Aug
 2025 08:54:39 +0000
Received: from AM3PEPF0000A79B.eurprd04.prod.outlook.com
 (2603:10a6:208:55:cafe::8e) by AM0PR04CA0138.outlook.office365.com
 (2603:10a6:208:55::43) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9009.13 via Frontend Transport; Wed,
 6 Aug 2025 08:54:39 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AM3PEPF0000A79B.mail.protection.outlook.com (10.167.16.106) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9009.8
 via Frontend Transport; Wed, 6 Aug 2025 08:54:38 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Ls11avupe6em6OhvRqGREHk4JPYtyBZW6oXEaqilaLJAUgx4ObMcraC7i4M7aMALYRcjlk28cr0Z9oxnzrZpAvXIarTW1XCEVEiB3rZUeKVNBvZryg9YaqN+Kdq+fdMLtNcEcYc/DqRyQGM8KZHxwqEaCWTZ71SN7Zjrbir6SL4A/hD9Jjreybhacnv1gY5Ejdeu7eUi8ty67qhylxBnJrVDYQiU8Q/qUOaUwcnLIhO0FpUMGMzaqUOuTKdAvc9v4lrLuN9roPzsqF/Ace+sDiG1OQfTODBJYdl+vhnAHRsfPpE6n6MKZFDE1EdMau47e4Eb8583sczIPWvJ39509g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dx8r21bufv4FNtcDnUI2GbSxAU2Xl5P+14JBQBfOT5Q=;
 b=LpYQ/YSYmhNQWTznLAJ0bxwNi+CiuaHdyRx/rTvLUUfQiWa/brsSx61HoVod3Loiq0g3pMZzgvPiUmETv2MOfw4/g/Qh6KlM1npLAbbD3gxfbjbkd4qTjTfU88eve1mEABljOYpmrcWYwLHq53GlaZfJg/0AwBLD9qxSOgs/2030eVajpgdHWImtXNCHQ/2zVmq37saROajZlGX+iK4CInZbKcdqKTg8GSPFLC0/pPZ061LoCm2eTtEeihPFkAKyP387lDaBrmwi6TAEnhJgPKcfFxp8CGmzW2SwQcUiaevOzDDkcNj8xBIwNNa/XEln0wHrUlzcVsG54UYtC95jNA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dx8r21bufv4FNtcDnUI2GbSxAU2Xl5P+14JBQBfOT5Q=;
 b=NoMQYcNp9Pn9brB6Uz2Thf7lNeIZP5MVd7udiwUmYGrGVzDWf42/Xvix6Q0uoTV6qIt49LJLcsho1g4rOK0HSX73ZfCsVa7DJDk5podE+fx4VmFvcqCotGscIUeqzDnnpG1jW4Kg7sQryi1FQbRWspukldZE5rz5HSg3EKWIftM=
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
Received: from AM9PR08MB7120.eurprd08.prod.outlook.com (2603:10a6:20b:3dc::22)
 by GV2PR08MB9423.eurprd08.prod.outlook.com (2603:10a6:150:df::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9009.13; Wed, 6 Aug
 2025 08:54:04 +0000
Received: from AM9PR08MB7120.eurprd08.prod.outlook.com
 ([fe80::2933:29aa:2693:d12e]) by AM9PR08MB7120.eurprd08.prod.outlook.com
 ([fe80::2933:29aa:2693:d12e%5]) with mapi id 15.20.9009.013; Wed, 6 Aug 2025
 08:54:03 +0000
Message-ID: <a2fdcb87-9223-4091-8bda-9d9316c84cf4@arm.com>
Date: Wed, 6 Aug 2025 14:23:56 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 6/7] mm: Optimize mprotect() by PTE batching
To: David Hildenbrand <david@redhat.com>, akpm@linux-foundation.org
Cc: ryan.roberts@arm.com, willy@infradead.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, catalin.marinas@arm.com, will@kernel.org,
 Liam.Howlett@oracle.com, lorenzo.stoakes@oracle.com, vbabka@suse.cz,
 jannh@google.com, anshuman.khandual@arm.com, peterx@redhat.com,
 joey.gouly@arm.com, ioworker0@gmail.com, baohua@kernel.org,
 kevin.brodsky@arm.com, quic_zhenhuah@quicinc.com,
 christophe.leroy@csgroup.eu, yangyicong@hisilicon.com,
 linux-arm-kernel@lists.infradead.org, hughd@google.com,
 yang@os.amperecomputing.com, ziy@nvidia.com
References: <20250718090244.21092-1-dev.jain@arm.com>
 <20250718090244.21092-7-dev.jain@arm.com>
 <7567c594-7588-49e0-8b09-2a591181b24d@redhat.com>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <7567c594-7588-49e0-8b09-2a591181b24d@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: MAXP287CA0004.INDP287.PROD.OUTLOOK.COM
 (2603:1096:a00:49::14) To AM9PR08MB7120.eurprd08.prod.outlook.com
 (2603:10a6:20b:3dc::22)
MIME-Version: 1.0
X-MS-TrafficTypeDiagnostic:
	AM9PR08MB7120:EE_|GV2PR08MB9423:EE_|AM3PEPF0000A79B:EE_|AS8PR08MB6086:EE_
X-MS-Office365-Filtering-Correlation-Id: 0f250552-31d6-4848-6ffd-08ddd4c6e06f
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|7416014|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info-Original:
 =?utf-8?B?dDdsUWlkMXpKREhXZGd3dGp0bExaTDAwWnNXRkVUS3RQU2NzM1hBd0RmRnZO?=
 =?utf-8?B?NGl3SEd1NUVIQUJuS2ltbHBNMjJ2OU1IR0d0dTN4RXd0Y01EL09BN2VyejRq?=
 =?utf-8?B?ZnF0WHl4TVVxTFhqOENZVWQ2R1kwMzM4ZU12eTFrajNKdnRCMWJQOUl2bmEv?=
 =?utf-8?B?Q3pQYnJtc0lMa0NZNXcyZEhFMW1aVWxBelhSUlQ5VjR6N0Q0VHdBQzhjeGJv?=
 =?utf-8?B?VHFBMW1TTjlxbDNWVnU3V2todTNvUjVXa2gxRENpeG0wSzJEbnhwK2s0TWZ5?=
 =?utf-8?B?QjlkUzRSQjRORGNVNzhnS0dJcU1TbXoyZW9IOGNudXkrQThxeXhCWG1Ma1NW?=
 =?utf-8?B?TUJVeEtmR1BxYjRmRS96d1ZwMTJqTHdZWGlGOVI3cXI4TFkvTitLbTNGTEUz?=
 =?utf-8?B?aVpmL0I0SkpTN01pd3BpSkVxcXlmL3pNc2d6WGZFR3Yxd1lmTFMxTVRCM1pp?=
 =?utf-8?B?NjJLY2NJeENJcHhMWUF3TEIvOUNrRVVtMlZVMnJXemhSclQxSzBnMTR6Szkx?=
 =?utf-8?B?TGo1cmpMdWNvaGZ2ZlZ0WHJzL1ZJb0ZhWFMwL3BPQk5mdE9nVHZ0VW83VXFt?=
 =?utf-8?B?TU0zdzFhTGJIaXBYZ1hpNlhvTjVablI2YWRkVVJ3aVhLSFJZa3RoTlRHbTg0?=
 =?utf-8?B?NmtHcmNGR1cyZ3pCZy9wbGFQYTFVUUpzYWFRdE1tLzlRelk0dUpHV05FdGJF?=
 =?utf-8?B?WmF5SEgwTGZ6aFJ5cm1LSWlxY3pIVUl3aVR6NTAwb256SkVCWVFkeWo2MnhR?=
 =?utf-8?B?Z1ZpclFCMVlUZzJLRFN2Z1RNRUdZdGgrRmdiSGt2cGRocXd6NmY1V2NTckJ6?=
 =?utf-8?B?YjBtMVhOVWlFeVpFRE9lYkJpVnRxbVFUd3ZwYXFQRUt2WGdITWdPS043Rlc2?=
 =?utf-8?B?N0dnWXNLVVBzLzRra2p5K1JSWW5Qbk83WGZ5SXhwMnZjbGNYcGJYdGh1MDJW?=
 =?utf-8?B?amJqejJLM01Icm5CQ3JVUi9VTDdXV1lWSURGUTJGZTdRb1JqVVJJZU9tTGxs?=
 =?utf-8?B?elpyVHl4UXFuTlFHL1NDRWc2cmlUTlBXQkJKTnlxMi9pYkVrZmtkYXVzU0pN?=
 =?utf-8?B?NkJGM21Lb1VhRzZobkJFQVNoZGM0NGpDRWhzZmI4cVVpVkw4Sll1NjVWTm5q?=
 =?utf-8?B?WmtMUVJYNEErR1RIa016WkY5am1ZYUZYOWFQcmNYNCtMbFAyU01vN2ZXckhx?=
 =?utf-8?B?Rkh2QjNrWkFvNDRyT1kwNTZMQ0xWREtMS0IyK1RYNmhRa2dVNHJraTZtblN6?=
 =?utf-8?B?bGY4MGxSWVUydklHcDY5c01icURGaUZrQi9PdEEzMVBwVzNZR2JTbC9oVGNq?=
 =?utf-8?B?QnZqMWp5VW5qRDBEc0hlUzNLbXhwWFJJaVN4cVNuYTROUkZ6MEpPWDlpNVQ1?=
 =?utf-8?B?RC9xajhSV0lJZnZOQVR6VzljaFIvcExJZ0NYNVJkRHREZ3RGeHJTaHlPVld5?=
 =?utf-8?B?d1dUaFk0VzVSUW1MQmlUNnRKaitINE93eDkzeUpidnd6Z1lxZ09OdlBFdXF5?=
 =?utf-8?B?TTN5ZG5nZGMzdWJrU1lYYXNVSDZ0WklybWtNMUFVRWFwNElQM1M4TVdDaER0?=
 =?utf-8?B?SnhqSXdWc2hNM2tpb0NMdHo2L2IvWVdnVjNqUDF3Nno0Wlhrb2VtNFc3VUlO?=
 =?utf-8?B?Y1dxQkpKOHYvRTZOQ1dOcXRxQTgvL2RMLzNHQ1Q5RWtIUFUrR2lQcjczR3Zz?=
 =?utf-8?B?RHhyaXNsdmtvbDZQR09pRVJIREpXSlhQekdVem9Sc0p0NDVjakZXaHhVTmxW?=
 =?utf-8?B?b255K3huMjlhblVxOTAycEhPUnBDdWx0ZlMvQUs3eEkya1ZIcExPdFB2Z2R1?=
 =?utf-8?B?TEV0NUlpV3pXWThXdisrLzVkV21xWXpEY3JDczR4OU9sVHo3Nk5PR2l0VEJ5?=
 =?utf-8?B?YVpXMy95a3VSN1RQUjQ3dGhtTEFFNVlFRWIwamRYNC9jcmVFZUdtNjhYN3BQ?=
 =?utf-8?Q?ZwnWmIjFAME=3D?=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM9PR08MB7120.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GV2PR08MB9423
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AM3PEPF0000A79B.eurprd04.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	86218396-404a-454f-a2de-08ddd4c6cb29
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|14060799003|36860700013|82310400026|35042699022|7416014|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?eHU3ZjRrSTdQQ3JiMUhQK2htQ2haN2NkNkpjbUtYcWVsbWNqODJaZ0dVU0VL?=
 =?utf-8?B?T0ljMk5JbDBMWWYzaXdkZFpvdWYwbFZINktDSjJZM1VPaVZVckk0MTFvb0Z3?=
 =?utf-8?B?RkNmeHBZUVRCZC9TNEMvZVlmL1lGdVRMM25ON29JOGJYNWFzVlB0RGZTVjc0?=
 =?utf-8?B?RTFBam80YjR0eHRYN3dCNk5JMm5IZXdTcVJsOTBsMWxqUnZIejlUakM5Nm41?=
 =?utf-8?B?V05qV1JPdzQveFR5U0ZuOHVrWFh3SjJseWh2V1NieEw1WmNzUmp0bENmWnVF?=
 =?utf-8?B?Q2tTV2FpYWhYUWxLVHRWWjgwZ25VS3p3UU5LYzdOMk0rcGNVaFpjYzRFT3py?=
 =?utf-8?B?VkNCVjl2dG1iUEpEdzF4dHdaZGtVSWZuZnNIbStCVDRYQ2lDZExOYkNLZjlE?=
 =?utf-8?B?YVRDMEpuVWY1ZDRlR3IrV3RtaHJ1YjdQWUUycmRuUndxbUJGYXNUcjYza0Zk?=
 =?utf-8?B?bWdPWkN4VUFPUElyMERkWDBWMlNORnpDaHc3cG5WQUcwd2FPRXgrYUNvWHlQ?=
 =?utf-8?B?KzlmbExmeVR6VVc3NElRRUNOam5TbXlDTUFEZU10OHlOVElSSVhES1FoMmRC?=
 =?utf-8?B?YUFKK3lRVkQzOEFGNDEzdXlIaFpSRTJCOC9NZFZlc0R1c05ITEdaU2czMnNn?=
 =?utf-8?B?VWxSZ0ZFWTVQajlKRWFLOThEM2E3b21XNWVsSjNzN3BCckxaaHVxNlBGYUZY?=
 =?utf-8?B?ZXEwcTVhTEE0d0FtejFLaUttTGdEaUNQWUNuTkVNQmd0WWNHTUUyaHNjTHNs?=
 =?utf-8?B?Sm4yc1lCT04vZjA1UFNXRnBGanh6dkpRY1g2ZWRvK2NtWjZVY2JXOGV2VWVC?=
 =?utf-8?B?UzV1cUVwayswVWVDMEdvRWdjOW05QmxOWUw1VlN1bGxzbU16Nlh2VHNrQktN?=
 =?utf-8?B?NVIyNUNEUkRvSHJiSFowNlJsN0puMVV1MDhCUEx1VHI2WnM0cGJoRzd3aVpG?=
 =?utf-8?B?M0pNNG1GYzBGMnNKSUtJUzcveCsvTUpIR0RYcnF0TVB6NWRkMnAyTkNhaC9E?=
 =?utf-8?B?WEdsREhSb2NUWE85K0JjV3VtbU9vaEtoRFZYa1ZGNFB4cTdwSkk0SGQrVFFW?=
 =?utf-8?B?eFBydjVEVk9lYWhkSjlTQW9zUUN0RnhqeGhSSk1Ma01jcEkrZ0lLdHc0RWgw?=
 =?utf-8?B?RkR4SlJiNEFuVkFEV3RxaGhrVUZ5V0FveHhHM2lXRDE4RVliMXRHdlFoT0tU?=
 =?utf-8?B?NWl4OEE1SEhiczRrNXZUbGdlWjc3R0VkZEw0dm1JZHc4b2p3NWF6NjJ1VDg0?=
 =?utf-8?B?N1Z5ZlA4MW9tM0FsSnhEYndYY2VVaE4zWkl1NDFvUTZ0T1AycjR6aC9MSDlp?=
 =?utf-8?B?UGZ5bFhEZ2Y1bXBsUmwrQi9RUFhjZGorUkxuMVdIc3puVS9lSWthMWh1dXlk?=
 =?utf-8?B?N3c4NUdRbUh4UWJYZFJ2TXBpOVZqOGhrSEwzUGhYVUlNWWFVMThvdFM3L2Y2?=
 =?utf-8?B?VjMzdnl2K2R0YVBqdjhEYUM1RXQ1K2tNRXhvMmZCOGgyNWlzWE1iYms3Y1JW?=
 =?utf-8?B?MzBoYVZ0dW4zRWdOamgzVnZTa3BVcHIxQ25XRXJxVG9waUdTc1RNVWVqeW5h?=
 =?utf-8?B?RURRSlcvYkdROTM0VnIzU2J4UjYyZ1pEeGNSbWxkTlIyaTlPcFpyK3E3Mzlr?=
 =?utf-8?B?Q282S3c3cDlTRG5pMVc5bldvQml3VlpKNjdhank1RUlZeUJvY2dmZ0tVU245?=
 =?utf-8?B?aDRKTnU2VnJKVnZHdG1MSlVhSXMvRGZad2tmaTZ6TEdPNTNtQ1JINldHWUJw?=
 =?utf-8?B?Q0pydWNEZGUycURTTHFzZzRhYXl5a2hqVit0SUh3SkdheUtYWDkyUzRwdHp5?=
 =?utf-8?B?STBsRVppTERsQkl3ZWFwcVQ5RzFoRHFZTjlXWm1HaTZvczY0cHFmRG9qUGU3?=
 =?utf-8?B?R0ZTcXlTcDc5b0ZQZlNxVWpkZ0FRek9HVHFDZExHRlRmRUd1Mm1pbXQ1WEN3?=
 =?utf-8?B?blNCQXhGUjIyTm5UQnJOaklkRDIxTjFXUXIyVHBoYk5QMUFvSm9BU01HNSsw?=
 =?utf-8?B?aTY1MzdSK0dLSmlZZzlPMFBob0E1NmsydFZrWG1xRGRCaVRyckNZdTFib3Jk?=
 =?utf-8?Q?RzPYq7?=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(14060799003)(36860700013)(82310400026)(35042699022)(7416014)(376014)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Aug 2025 08:54:38.9430
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 0f250552-31d6-4848-6ffd-08ddd4c6e06f
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AM3PEPF0000A79B.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR08MB6086
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: C9A3E1C0007
X-Stat-Signature: 4opnbr67d3586btcq8yyrhpttb4q3n9p
X-Rspam-User: 
X-HE-Tag: 1754470482-867302
X-HE-Meta: U2FsdGVkX18LhFFWS0Y62HnKF0A7co67tAavJdUeQ7YvVmWBFldNx6kGhHCOyBP0TysZ3gCCC6sC/8kAtF9AAJOCIcxm+SMnX6ixwPg5o/Sn8d1putoRO4Hd7gGKFSUSVKvnfXDbgZJpnXAfxpah5axGK1B8hKIXf41i5eK70oGj5pIU8WNYbl8MnLLLgUoywom+vECt7S/5xL8EQFrJ71301xTh1GoXhay0dFV1UlT0h9AHJG1xb1SFg+5tk+RqJZ/ng2WhynDv5ecDhS+C90c01/yuHAI1rmNWtsU/WGri7UkiWK9hlgtSg2HMxNeY+HLqouLGix9VEbfF7dhGxszGcyqmj5XUWSNnvEn3NyS0xKadboVK9Xg5Zyq+uGN2amPw/Wjt47Z58c+ot+Ma72BxEet7/L/sYRo5VN4obW8bu+acKBCx8uLjJfz0On8G7WGZcJY+eo8DwsWwlN3cY5egvgNwiI6SvLOHTiCyNBAu3oWv6OGiiCEBvukPDE1tBd4/3CqHIK746/0tRKcR/HVWBKM6zd2EG39m7DlZA599fIDMSd4c7lQCZy41uB251CTEjLq6RyeY+DJ5ibT1FURq7QM5q59J3x9LQAxfa4GtfZiKG5uS1bsWtWtQA9djK5h6K2DGm5XKaHV0j1uym3VNgiK4N7vtiBAGWnFMpzrQtiL0Bl0HTVl0rbzq29eqMRvw/KteHzKGoJkoM8sfd/qpXkq+xUuv4MKW3XoEOITG+i+t6qvMfL6IiL21IgTEHm8j0/5pqTDfgHft9zJKVcRbB5dUa7g8dtu/fO3GK1ZJuyAMcyKxskCQj2SozzShXEsm74E3/GB/EQhBMCZPMGspjdUSTZfb+4ZigxbJDFx1Xbk2O0yFUoTro/N3+jX6BFsUnlSvW2Dh5mr3CM5WongQSBg+YqoQjMRbmHuvyIPml6rQRzqRJ9mky6WfqqqAgWGY4pK20KQ7LoWCKpP
 AM3cCKE3
 qQBbTHu00QMiqgfZRvECHfSyLeVDZ7Bewj2TGG/McoJS60vDvFKfx7K5YZH3KwqvmNWWOakeVn8nO6/T+apREJYYfQLwL5OfZ9GQYAywA8JHuAF/ndjVrOktFMaTduw0q2WFZxBoiHIjC1TIwf3FgPzm2hdeG0Dpp4J6CuhUptefKdoifNlHRY2mED2ZwnogJkjEv5UFgdbuHRkkWC1lmk2FGuQ8+4THkGWF+koQOzZNIFhY79+KSkaBXxvw4+UC8gwgeCsBv0/KFcEFhv+n2venmsfk73h5Vh8e1Khvfnc2CLzF5Ns/h65bNfCYQGjgKFD/TurVtNUL8Bh8jO6QVwTAXKlUYZcg108rMgQeVEKxcx751dKvLQlgFx/0RWr/5xrsejyxYPtj0fY68Bp/x5dwZOH7YV/QSRw7+7NZ58K9z134EZUYKXDGDFGRQFUcHCVRuvzInNv2DPdwR9bGoIZAT8IX292WXxxa6nyCyZov0JfMKQiY8sj/PXI1y4xh6bqoj6l/wNdia7xlf34h4RSR344uZEw8rgbJzeIL2WHTk638eLpkuk0LKV9LhKEyHacQda+pb5qEmcBZcE+NLGlk/OWvJk3jtuhLoxrUW4gvKbP80TRue9tBoOEAjEZCBmg1k
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 06/08/25 1:38 pm, David Hildenbrand wrote:
> On 18.07.25 11:02, Dev Jain wrote:
>> Use folio_pte_batch to batch process a large folio. Note that, PTE
>> batching here will save a few function calls, and this strategy in 
>> certain
>> cases (not this one) batches atomic operations in general, so we have
>> a performance win for all arches. This patch paves the way for patch 7
>> which will help us elide the TLBI per contig block on arm64.
>>
>> The correctness of this patch lies on the correctness of setting the
>> new ptes based upon information only from the first pte of the batch
>> (which may also have accumulated a/d bits via modify_prot_start_ptes()).
>>
>> Observe that the flag combination we pass to mprotect_folio_pte_batch()
>> guarantees that the batch is uniform w.r.t the soft-dirty bit and the
>> writable bit. Therefore, the only bits which may differ are the a/d 
>> bits.
>> So we only need to worry about code which is concerned about the a/d 
>> bits
>> of the PTEs.
>>
>> Setting extra a/d bits on the new ptes where previously they were not 
>> set,
>> is fine - setting access bit when it was not set is not an incorrectness
>> problem but will only possibly delay the reclaim of the page mapped by
>> the pte (which is in fact intended because the kernel just operated 
>> on this
>> region via mprotect()!). Setting dirty bit when it was not set is again
>> not an incorrectness problem but will only possibly force an unnecessary
>> writeback.
>>
>> So now we need to reason whether something can go wrong via
>> can_change_pte_writable(). The pte_protnone, pte_needs_soft_dirty_wp,
>> and userfaultfd_pte_wp cases are solved due to uniformity in the
>> corresponding bits guaranteed by the flag combination. The ptes all
>> belong to the same VMA (since callers guarantee that [start, end) will
>> lie within the VMA) therefore the conditional based on the VMA is also
>> safe to batch around.
>>
>> Since the dirty bit on the PTE really is just an indication that the 
>> folio
>> got written to - even if the PTE is not actually dirty but one of the 
>> PTEs
>> in the batch is, the wp-fault optimization can be made. Therefore, it is
>> safe to batch around pte_dirty() in can_change_shared_pte_writable()
>> (in fact this is better since without batching, it may happen that
>> some ptes aren't changed to writable just because they are not dirty,
>> even though the other ptes mapping the same large folio are dirty).
>>
>> To batch around the PageAnonExclusive case, we must check the 
>> corresponding
>> condition for every single page. Therefore, from the large folio batch,
>> we process sub batches of ptes mapping pages with the same
>> PageAnonExclusive condition, and process that sub batch, then determine
>> and process the next sub batch, and so on. Note that this does not cause
>> any extra overhead; if suppose the size of the folio batch is 512, then
>> the sub batch processing in total will take 512 iterations, which is the
>> same as what we would have done before.
>>
>> For pte_needs_flush():
>>
>> ppc does not care about the a/d bits.
>>
>> For x86, PAGE_SAVED_DIRTY is ignored. We will flush only when a/d bits
>> get cleared; since we can only have extra a/d bits due to batching,
>> we will only have an extra flush, not a case where we elide a flush due
>> to batching when we shouldn't have.
>>
>> Signed-off-by: Dev Jain <dev.jain@arm.com>
>
>
> I wanted to review this, but looks like it's already upstream and I 
> suspect it's buggy (see the upstream report I cc'ed you on)

Thank you for CCing, and quickly spotting the problem!


>
> [...]
>
>> +
>> +/*
>> + * This function is a result of trying our very best to retain the
>> + * "avoid the write-fault handler" optimization. In 
>> can_change_pte_writable(),
>> + * if the vma is a private vma, and we cannot determine whether to 
>> change
>> + * the pte to writable just from the vma and the pte, we then need 
>> to look
>> + * at the actual page pointed to by the pte. Unfortunately, if we 
>> have a
>> + * batch of ptes pointing to consecutive pages of the same anon 
>> large folio,
>> + * the anon-exclusivity (or the negation) of the first page does not 
>> guarantee
>> + * the anon-exclusivity (or the negation) of the other pages 
>> corresponding to
>> + * the pte batch; hence in this case it is incorrect to decide to 
>> change or
>> + * not change the ptes to writable just by using information from 
>> the first
>> + * pte of the batch. Therefore, we must individually check all pages 
>> and
>> + * retrieve sub-batches.
>> + */
>> +static void commit_anon_folio_batch(struct vm_area_struct *vma,
>> +        struct folio *folio, unsigned long addr, pte_t *ptep,
>> +        pte_t oldpte, pte_t ptent, int nr_ptes, struct mmu_gather *tlb)
>> +{
>> +    struct page *first_page = folio_page(folio, 0);
>
> Who says that we have the first page of the folio mapped into the 
> first PTE of the batch?

Oops, I thought I had taken care of this. We make the folio from 
vm_normal_folio(vma, addr, oldpte),

which makes the struct page from the actual pte, but then I missed that 
page_folio() will reset the folio->page

to the head page, I was under the impression it will retain the original 
page. And indeed, if it didn't do that

then the purpose of vm_normal_folio() is nullified, should have thought 
about that :(  Lemme send a fix patch.


>
>> +    bool expected_anon_exclusive;
>> +    int sub_batch_idx = 0;
>> +    int len;
>> +
>> +    while (nr_ptes) {
>> +        expected_anon_exclusive = PageAnonExclusive(first_page + 
>> sub_batch_idx);
>> +        len = page_anon_exclusive_sub_batch(sub_batch_idx, nr_ptes,
>> +                    first_page, expected_anon_exclusive);
>> +        prot_commit_flush_ptes(vma, addr, ptep, oldpte, ptent, len,
>> +                       sub_batch_idx, expected_anon_exclusive, tlb);
>> +        sub_batch_idx += len;
>> +        nr_ptes -= len;
>> +    }
>> +}
>> +
>> +static void set_write_prot_commit_flush_ptes(struct vm_area_struct 
>> *vma,
>> +        struct folio *folio, unsigned long addr, pte_t *ptep,
>> +        pte_t oldpte, pte_t ptent, int nr_ptes, struct mmu_gather *tlb)
>> +{
>> +    bool set_write;
>> +
>> +    if (vma->vm_flags & VM_SHARED) {
>> +        set_write = can_change_shared_pte_writable(vma, ptent);
>> +        prot_commit_flush_ptes(vma, addr, ptep, oldpte, ptent, nr_ptes,
>> +                       /* idx = */ 0, set_write, tlb);
>> +        return;
>> +    }
>> +
>> +    set_write = maybe_change_pte_writable(vma, ptent) &&
>> +            (folio && folio_test_anon(folio));
>> +    if (!set_write) {
>> +        prot_commit_flush_ptes(vma, addr, ptep, oldpte, ptent, nr_ptes,
>> +                       /* idx = */ 0, set_write, tlb);
>> +        return;
>> +    }
>> +    commit_anon_folio_batch(vma, folio, addr, ptep, oldpte, ptent, 
>> nr_ptes, tlb);
>> +}
>> +
>>   static long change_pte_range(struct mmu_gather *tlb,
>>           struct vm_area_struct *vma, pmd_t *pmd, unsigned long addr,
>>           unsigned long end, pgprot_t newprot, unsigned long cp_flags)
>> @@ -206,8 +302,9 @@ static long change_pte_range(struct mmu_gather *tlb,
>>           nr_ptes = 1;
>>           oldpte = ptep_get(pte);
>>           if (pte_present(oldpte)) {
>> +            const fpb_t flags = FPB_RESPECT_SOFT_DIRTY | 
>> FPB_RESPECT_WRITE;
>>               int max_nr_ptes = (end - addr) >> PAGE_SHIFT;
>> -            struct folio *folio;
>> +            struct folio *folio = NULL;
>>               pte_t ptent;
>>                 /*
>> @@ -221,11 +318,16 @@ static long change_pte_range(struct mmu_gather 
>> *tlb,
>>                         /* determine batch to skip */
>>                       nr_ptes = mprotect_folio_pte_batch(folio,
>> -                          pte, oldpte, max_nr_ptes);
>> +                          pte, oldpte, max_nr_ptes, /* flags = */ 0);
>>                       continue;
>>                   }
>>               }
>>   +            if (!folio)
>> +                folio = vm_normal_folio(vma, addr, oldpte);
>> +
>> +            nr_ptes = mprotect_folio_pte_batch(folio, pte, oldpte, 
>> max_nr_ptes, flags);
>> +
>>               oldpte = modify_prot_start_ptes(vma, addr, pte, nr_ptes);
>>               ptent = pte_modify(oldpte, newprot);
>>   @@ -248,14 +350,13 @@ static long change_pte_range(struct 
>> mmu_gather *tlb,
>>                * COW or special handling is required.
>>                */
>>               if ((cp_flags & MM_CP_TRY_CHANGE_WRITABLE) &&
>> -                !pte_write(ptent) &&
>> -                can_change_pte_writable(vma, addr, ptent))
>> -                ptent = pte_mkwrite(ptent, vma);
>> -
>> -            modify_prot_commit_ptes(vma, addr, pte, oldpte, ptent, 
>> nr_ptes);
>> -            if (pte_needs_flush(oldpte, ptent))
>> -                tlb_flush_pte_range(tlb, addr, PAGE_SIZE);
>> -            pages++;
>> +                 !pte_write(ptent))
>> +                set_write_prot_commit_flush_ptes(vma, folio,
>> +                addr, pte, oldpte, ptent, nr_ptes, tlb);
>
> While staring at this:
>
> Very broken indentation.

Indeed, but then in order to fix the indentation if we start positioning

every argument just below the opening bracket then it will take at least 
four lines :)


>
>> +            else
>> +                prot_commit_flush_ptes(vma, addr, pte, oldpte, ptent,
>> +                    nr_ptes, /* idx = */ 0, /* set_write = */ false, 
>> tlb);
>
> Semi-broken intendation.

Yup I can position nr_ptes below vma and set_write below nr_ptes. But this

should probably not be a part of the fix patch.


>
>> +            pages += nr_ptes;
>>           } else if (is_swap_pte(oldpte)) {
>>               swp_entry_t entry = pte_to_swp_entry(oldpte);
>>               pte_t newpte;
>
>

