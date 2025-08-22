Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A8644CA0EED
	for <linux-mm@archiver.kernel.org>; Fri, 22 Aug 2025 05:33:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B9A7C28000E; Fri, 22 Aug 2025 01:33:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B2A7F8E0056; Fri, 22 Aug 2025 01:33:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8DF9828000E; Fri, 22 Aug 2025 01:33:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 744458E0056
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 01:33:14 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id C7C9E160529
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 05:33:13 +0000 (UTC)
X-FDA: 83803275066.20.5D7CBC1
Received: from AM0PR02CU008.outbound.protection.outlook.com (mail-westeuropeazon11013027.outbound.protection.outlook.com [52.101.72.27])
	by imf03.hostedemail.com (Postfix) with ESMTP id A22B920002
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 05:33:09 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=arm.com header.s=selector1 header.b=Ctimxups;
	dkim=pass header.d=arm.com header.s=selector1 header.b=Ctimxups;
	dmarc=pass (policy=none) header.from=arm.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=2");
	spf=pass (imf03.hostedemail.com: domain of Dev.Jain@arm.com designates 52.101.72.27 as permitted sender) smtp.mailfrom=Dev.Jain@arm.com
ARC-Seal: i=3; s=arc-20220608; d=hostedemail.com; t=1755840790; a=rsa-sha256;
	cv=pass;
	b=rf8gDD2G/Ozn5MI0cS5Xyp6HzZB04dHFziz8rdx7gfEJiuVm9KLxvxWN1mLRkf4HSMZio4
	ebLArW2CRAafhF9MT88iC2yJ/U0uYDlMEF7Jq2q45UgFAjOA/DX+/rS4Irx2rgHQtskCMW
	0WSn5FDIMS/40KJK6MRpSWl1e0w2ciA=
ARC-Authentication-Results: i=3;
	imf03.hostedemail.com;
	dkim=pass header.d=arm.com header.s=selector1 header.b=Ctimxups;
	dkim=pass header.d=arm.com header.s=selector1 header.b=Ctimxups;
	dmarc=pass (policy=none) header.from=arm.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=2");
	spf=pass (imf03.hostedemail.com: domain of Dev.Jain@arm.com designates 52.101.72.27 as permitted sender) smtp.mailfrom=Dev.Jain@arm.com
ARC-Message-Signature: i=3; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755840790;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=auIxKRTNj3QaMWkNmW4KvgVb6vD9/wnuBeJRHOmT1mQ=;
	b=4c4XSpcnYYrMY38BE3jkjOyL5gD2bUTW6njORZ3E2OIUhZFYBMw9ft4oAZ9b9WwlG4BIxb
	kJWMKxhdbFMeCjdw2ADvU/NXEAi3pUP3II5wr2M422MS0bHAjYhLmJ/G09+KXLTCZrlxGZ
	VZIGjCWM+L2T8QUVVlow/wpIvg6NcwA=
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=JkrQ3myYePr1e3jwnoQW4TiSIioIu1yOrT7ODPEz/gSYjttvj1NXjKem/jxuvrkcRsgdD+1rrW3b2oTHCLF6rY+RZBuTQb8DN7+V0B21BAJp8CR5QuJz44WE2u7UN5Z6xbaTL7WqHfTFzeTyEr8iv8YOLTL06aUPzpao0He979egEQZlNDDY+SRLXHptDRbGVnF61ESrPLDJs/nBXMSxezK992v0Q2WlUzqrQtU05dl9Eq3qYEdymSUKAzKTcZ73DbxNGsHn4Prfy1ETTTvnm2pKsugWEGVDpoQ0HysxxXgxs0OJ5a4RaL82lGE/lLfDXkr5SnivJwen2E/s7ll8OA==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=auIxKRTNj3QaMWkNmW4KvgVb6vD9/wnuBeJRHOmT1mQ=;
 b=hABHD/2bBPz1J+bDz8uYOwmi1zCQlF3ZQCyLZz5TRxvgTY5/ZkdosA+CPMY5qC2v2g4z82g3T+DWXr6rx9pxowEFEme4FWURtVvGg1P2QqCgcObXvvpEm9dEX2n2XUkB1HO5tsd1Zwd4sNgI/1YXrBDKkwcEutzVEccPIfjDEk7SZCvMu7JCrrxCHImd7Uu1jepwUmNTn7JoBwgTttEYPxmncSARy3P7arThZbsmIF4h7+Vt7ncSSjoRmFSbpWD0eD49SborbIdbpjkjHtNV/knOGbZLeBaTn9xx0bLKVM71PtAIhlvDRi/9jjh0uWNOVc7v8zvy8Xqk47usbqkinA==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=syzkaller.appspotmail.com
 smtp.mailfrom=arm.com; dmarc=pass (p=none sp=none pct=100) action=none
 header.from=arm.com; dkim=pass (signature was verified) header.d=arm.com;
 arc=pass (0 oda=1 ltdi=1 spf=[1,1,smtp.mailfrom=arm.com]
 dkim=[1,1,header.d=arm.com] dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=auIxKRTNj3QaMWkNmW4KvgVb6vD9/wnuBeJRHOmT1mQ=;
 b=Ctimxupsz6oQ4TikRSIimotgSV+VBRR3IqbOxxZTijxj0122Uq/ftdEtG1xQPB0gr+M69S8IMBkMzXAFFGWIesV6R7PoXATsYiXYgnwId6EOn6C9XPJryr3sbZDjtI2y7zw5e3kQlmWLYIQIzU6aujBgs5dTYQqrmpwstLPEcis=
Received: from DU2PR04CA0168.eurprd04.prod.outlook.com (2603:10a6:10:2b0::23)
 by DB9PR08MB6650.eurprd08.prod.outlook.com (2603:10a6:10:26d::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9052.16; Fri, 22 Aug
 2025 05:33:04 +0000
Received: from DB5PEPF00014B8B.eurprd02.prod.outlook.com
 (2603:10a6:10:2b0:cafe::6a) by DU2PR04CA0168.outlook.office365.com
 (2603:10a6:10:2b0::23) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9052.17 via Frontend Transport; Fri,
 22 Aug 2025 05:33:04 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DB5PEPF00014B8B.mail.protection.outlook.com (10.167.8.199) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9052.8
 via Frontend Transport; Fri, 22 Aug 2025 05:33:03 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ISI2D2Sqr9frsj7ozCjh3NBwG0ndf6xuOSmeEqpcIgjg59s5Apw7jZp6TCJw8VBV4+ubEXUgwhceKNUp08NQW06zKIr9UiEjRaSiUnQ6p6xVC7kCLnFTmSXtST5jSg+yoQypbk9AVUOt86Kg8YP08+7j7VjuRhBAGZ0yfvjsB+9MGWJZO77+tSCu1KxeIjgDduXoVMrGMc+fNdiJd7SaSnQKR66VgZ0hAo9orVeUpOTdnIUqBiu59BQPt7weTMIr2uaslv04td7KjUsOsavpx9/4eU3gsrbodWD3uQN3mcU0k187n/52PNl0M9Yiz5YRAJXNwFj5qE1+17NfxUsb6A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=auIxKRTNj3QaMWkNmW4KvgVb6vD9/wnuBeJRHOmT1mQ=;
 b=yF0ZbVbo63h32pYM3PdJLQ9n7dDSBsZPZflKg4hSvtgpbQnepTkKSyA8nZC9e+qzihbclm98AihWVDOf3gDbuO0TuyAAJA5X7yD0dfwmjHLM4ky09zO20b6qiomLKsvM5LZ+X6vY+8qZhSaHrnYccsFJq4WoFUbFA4T9PtxBl8bA2PZOUG8RWBIsFZ7SaKUuB0Tx/lxOAZMYarzIx935wD1bw7cN+qZhvePIzT+N5TzQcyNnKhBlY1wXo6ytVCEWiu5nxjXiLm+stTtqVR2guR6e1dSZOjU+uQFcc8HxhOYqaGHUrtXMaDl+PEUoy/sh2Huoj20vyihuR16ztWI2kw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=auIxKRTNj3QaMWkNmW4KvgVb6vD9/wnuBeJRHOmT1mQ=;
 b=Ctimxupsz6oQ4TikRSIimotgSV+VBRR3IqbOxxZTijxj0122Uq/ftdEtG1xQPB0gr+M69S8IMBkMzXAFFGWIesV6R7PoXATsYiXYgnwId6EOn6C9XPJryr3sbZDjtI2y7zw5e3kQlmWLYIQIzU6aujBgs5dTYQqrmpwstLPEcis=
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
Received: from AM9PR08MB7120.eurprd08.prod.outlook.com (2603:10a6:20b:3dc::22)
 by AS8PR08MB6614.eurprd08.prod.outlook.com (2603:10a6:20b:338::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9052.17; Fri, 22 Aug
 2025 05:32:30 +0000
Received: from AM9PR08MB7120.eurprd08.prod.outlook.com
 ([fe80::2933:29aa:2693:d12e]) by AM9PR08MB7120.eurprd08.prod.outlook.com
 ([fe80::2933:29aa:2693:d12e%5]) with mapi id 15.20.9052.014; Fri, 22 Aug 2025
 05:32:29 +0000
Message-ID: <02587840-3222-4dc5-b039-9084d8a5f37d@arm.com>
Date: Fri, 22 Aug 2025 11:02:24 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [syzbot] [mm?] kernel BUG in page_table_check_set
To: syzbot <syzbot+49a796ed2c9709652f1e@syzkaller.appspotmail.com>,
 akpm@linux-foundation.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 pasha.tatashin@soleen.com, syzkaller-bugs@googlegroups.com
References: <68a7ef20.050a0220.37038e.004d.GAE@google.com>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <68a7ef20.050a0220.37038e.004d.GAE@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MA1PR01CA0175.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a01:d::10) To AM9PR08MB7120.eurprd08.prod.outlook.com
 (2603:10a6:20b:3dc::22)
MIME-Version: 1.0
X-MS-TrafficTypeDiagnostic:
	AM9PR08MB7120:EE_|AS8PR08MB6614:EE_|DB5PEPF00014B8B:EE_|DB9PR08MB6650:EE_
X-MS-Office365-Filtering-Correlation-Id: 1d15f385-a344-4ab6-c364-08dde13d5da0
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|1800799024|366016|376014|7053199007;
X-Microsoft-Antispam-Message-Info-Original:
 =?utf-8?B?ZXpYOGxjWVoxcnVOYVBWSVlvaDFLU1lUbER0YlRiQ1M5UEVnakR5d1NWU0hL?=
 =?utf-8?B?a2FlUGVUNlhIME82MXRRNVQzK0djNTFhWlAzS053TXZJYndkRTcrZStzOUc3?=
 =?utf-8?B?VlhqQWZkcTlRMzdleWl4WHE0bGx6NE5TT0ZEREU0QWw4Qmp0ZWlNMGYxU3FL?=
 =?utf-8?B?MmZHZUQwdGd1Q1NuU0xXNkVvaEg4c3hmUVRhOG5Rb1d3Wk5JVGdvTG5uS3Vm?=
 =?utf-8?B?MjJ3cThnUjVsNFJsL1U3SysrV1R3bGN6NEExckZ1dXdPbU5nUDB1bG9wNlA3?=
 =?utf-8?B?UlZHT3NwbHF0ZGc3akMwK2xSTXFkUW9xQjBvam5VWWhaQ3VrbUkwUWpyNlhr?=
 =?utf-8?B?QmRRcWlkMmgxOWtETkN2VW9aR29MMUR4WkV5ZEVTNTJvWWd4VnFnaVUzNTdV?=
 =?utf-8?B?UVVRdUpoQXhVODk3T0xVaHVnR0RTcGVOSFIwNnhPODlTQlEvRWRrLzE3cE15?=
 =?utf-8?B?OVIyaHc2dkRIS0ZzOWk4dlBVRllaR2p2YnFWazgzNUxwQU80eHQ0dzBEdCtI?=
 =?utf-8?B?Y0ljcVdIais5REJ3SUdFRGZNUmNWVVU0THJQdEN5TWRjd1kydXlTejJCbVJu?=
 =?utf-8?B?UEsvZ1RjTE1lKzNPTjdqK2NGc1BDQ2FueU5ZL2RYVDdGRzg4M1o3S21FUjFV?=
 =?utf-8?B?MmJPS1NoYlhZNEo4SlVCMzdaSXEwa2JsQnFSdy9OR1NXcUE5SzNrSzNEUkMr?=
 =?utf-8?B?M3I2VUhLdURLWTkzSTM1NG15L0IyOEtyaEd2ckh1UXhtdi9vMGZoTG1pUk1r?=
 =?utf-8?B?K2wzeWJUMXhsM0Y5WlpMNThkVWh3VzNhTWMrdWpUVkdOdUxvd2lKdmc3QU04?=
 =?utf-8?B?Qy92bnV3RjViQkhTaUZWb0VOS2hPMFY4ZHYwbnNMdGJLQngxMDZXOVpUeEJC?=
 =?utf-8?B?aWgzUUNUMk5FRlFzWnA2V1ZzaHJPV3VkMVZoYUxaQi9lbnh5dzBlOGFjZWx6?=
 =?utf-8?B?R1NCKzRSb1hwVkIwZ1BXWW4yZW8wZUhsaExuZ1Rsd1E3UFNmQVRXM1JSWE5P?=
 =?utf-8?B?RXUyeWg2S1I4dFFiUUZGdzVjbk5XbXBMU0EvdSs1alpwUVJMWnFJTDVrZURC?=
 =?utf-8?B?eG95MENrTVN3dWdHZHNGdEUxT25hUEFBdkVLbDZkT3dGcVQ4YXdJenNRS2or?=
 =?utf-8?B?WXpvVzE4Sm01Wkh2MWJRRXRmQXcwa29KOGV4bzNpaU0vUksxYm5sWEpkK1E3?=
 =?utf-8?B?TTNJSUt1SXlRRUNwQThUdittTkd1LzVVdjg5Z3pDZlk5MFBQSjBGWmJGeUI3?=
 =?utf-8?B?dVJ1YmR5MFlLdXNNc0FCeDVPS3JlRVZkQ3VDaUtGM3d2TlRGTUNsQkh6Q3pQ?=
 =?utf-8?B?SnYxUU5lcUt0QmVEVEtoZVdBdkdzZU9LdG10RXFCV0ZncUJjOElWUGM3bEhn?=
 =?utf-8?B?RDhXK29XMkNiaXExYzNEWjIwQmlaS3hOVElScFZCS0hkVXNuZWYyNFhQcjh3?=
 =?utf-8?B?WHd2L1ZjdXJXV2luejlYNHQ5NGtQTzJ0YTV4bm5MV0hET0J2WHZWaU0rK2hp?=
 =?utf-8?B?bTQ4bVFuRTluVmhDbWQ3U0lTd01CbmgxMHJHWkpXeTgwUjhHU2pEaWFITlVV?=
 =?utf-8?B?RkxXdUttZkNsSUxoTmNVcXJTQWp4YitBT1A3ZlQ0a0RTazdKN2VYU0RSUkVN?=
 =?utf-8?B?Nk5iTkw4eEl6d3c5NU5yS0kwTGhidG44SEtMWFZDckFyTm5rOXRaVVZ3VHp0?=
 =?utf-8?B?a3kvYTRNbE1nMUVaUExHd2VPZEp2WXkvOFhPV1BITmhMTVlIdWxjUGRycVpq?=
 =?utf-8?B?VXY3YkluRVFPcE9LQUlUUi9icFBhY2EyOXczSFNHd3V3Z0I2NDdzSk9NZmtu?=
 =?utf-8?B?R3hvbzgzNWRPNEJZRGlWbEJHdUYrQ1QyTXlRcmpTWUx2UjJKcGg2ek1zVHlF?=
 =?utf-8?Q?TDo3FmJY7MHLg?=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM9PR08MB7120.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR08MB6614
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DB5PEPF00014B8B.eurprd02.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	da28193f-8e60-4554-ee37-08dde13d4960
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|14060799003|35042699022|376014|36860700013|82310400026|13003099007|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?cytaekRrcUVQRXBaOUdKTlUzMFg3djNYNmJnUVlyU200cUZRY0Z4ZHRTL2Q3?=
 =?utf-8?B?NnY4OVpNcUR3WTgzQWIzMGFjZkt3U004K2ZUQ2J6ZFE1elBUcUl6RGgxckFm?=
 =?utf-8?B?UFkzYlJQcWJoYXdYeHpGdzVKUVpkTVgyVFpEMnNZaU9zMEJ0cmczMktsakN1?=
 =?utf-8?B?OVhrYXNGanpIRVpHelRzRitsenhFcS9WYzFMTmZkRS9VNW5GMHNGM1V3d2NJ?=
 =?utf-8?B?bEtKK3RDaHlWQk1OcXpMcGdlR1huSE5SdjNwQ2RKUE5YSDl6eVBGeDROd0x4?=
 =?utf-8?B?KzM1cks1alpBWnU4MUZoV3pMNVNGbWZXTHZTT2xSNTVoQ2lIQzJCVHg3WFlv?=
 =?utf-8?B?MWpsZ0J4STQxLzNqS3dLcSttSlFjUWQ2OTV4TzdQQXFvYUlKbDUyTVhocEdI?=
 =?utf-8?B?ZXF1b1RIQ0tIQ0Y3eWpENUFtckJYa0UyV3lHaitrbndpOFlNM3k0azZOdVpN?=
 =?utf-8?B?MEpqSWI5RUM2U1A2UWFJU0xqUi9QMGpZUy9UZ1pFcXF1NlV2NWFBYUZGZUhs?=
 =?utf-8?B?d05oeE5iMGJ6cUU4TEVjdHRNUXl3NjZraWQwWVNaZ0Y1MkxtVStUN0tZeVJG?=
 =?utf-8?B?ZGRFMXNJVzYwOEYzNXRyYXRjNVNZSmptMW5oaVI4OElkbVEwRTlRbzg5bnFJ?=
 =?utf-8?B?SGJHZEtwbDhxcjRiRnZnTkhZeVYwMXFFWWwrY2YvNE5TUFB4cnRHd1Z1MVNn?=
 =?utf-8?B?Z0YwWWpZSTBlY0o4MnVKWnZObGRhSGRzYys1NjRyZDVWT2NYSU1DVFNHYlZ5?=
 =?utf-8?B?b2xFS1hDcjI2L0VyeTN2KzREWURYbXlkSm1TK282blpiSUpQRlFHWnZBUUJC?=
 =?utf-8?B?SmpDWnE1N3o5UkpKMGRKYU96ckJFYUVhejRpaElicWZBWXlNTjZUVkE4Tkdt?=
 =?utf-8?B?Z2lIVE9iZlJITjZraVFCNjRZT2NxWXJoNVZrUE10T3l6YVdqUG9YZG5hc05J?=
 =?utf-8?B?bzlsMGhkVFVMNmNCTzhicjVKdC9rR2tKMERpZkdXMHN6ZmU3bGUvRDJJRmhy?=
 =?utf-8?B?Y1hQRG54Y2ppMTFxU1MxNVpIU3VtUFN2QUsrVnRHZTdKWU1lK21VZm5LYnhD?=
 =?utf-8?B?SmRCSkphcVFHVDAwVjgrZjRtZVpIa04zR1pxRHkxdzJNeTkyWklpa29yblJJ?=
 =?utf-8?B?ODk1MHNTZWdGS1VadFFWQXpXZlFTczZ3ZEtvQkoycGptUkUzL3l2aFp5eWd2?=
 =?utf-8?B?bGlzS0dERWVEMFErNU9yUHZrNVRsVUJEOXFMb1VsOWVUVlRIblFDMUwxRzRw?=
 =?utf-8?B?MTZQMDVGUzZndmNWOGNpQitEYjJka0RPRFpJMUloNStiYklWVkJmQ2todzJx?=
 =?utf-8?B?Mll5TlExTEJYTkJEOXZXb0hTVlhmMEpYS0RVaTlsQjBtVmxHOW5ZMkthb1py?=
 =?utf-8?B?ek9YQXFia3R4SHN4bFU0eGNDVDk1RVdicWtOTGd4NURXQmdaby93VnVBNmt1?=
 =?utf-8?B?Q1JsMi92QkxSYm4zN3F0bXFzVlhzWUpqSXhteFVtRHo4WXFQaG9WdXBESDhi?=
 =?utf-8?B?SGdhWnllYi9vcFRLblhGYndzVWZjUlpEbjloZkwvclc5Q3k5R1JwRW5zMnVT?=
 =?utf-8?B?QzNlOVRCMkFCb3ZGSkNpeW50Q3lFOWhRWEdkV1FrSUlWL01uNWdNcmZtekRw?=
 =?utf-8?B?cmFUc2R1QXNvNndOSVdBT25EQnRKNmoxK1NOZHNxOStTZ09QWGd0WGdMYStm?=
 =?utf-8?B?U3JLVzdLRzE0T203OTdwTmJwZVZwUmxuUUZJampCZmp1eVRTSnlYMkt3RlBt?=
 =?utf-8?B?dXlNbW9HZlcrcTV0SHpxNVpJSk5tRlRBN2JvOU1BUWpKdEYyMjF3aXFKV2Fu?=
 =?utf-8?B?SU9uU1p0ODNzWjc0eFA0ZFIrdWlhTkEwQkJXM1lmZHRGaHFCYTlOU2g4RG9F?=
 =?utf-8?B?aU1lVlB1WmdkcnVITXJoUkZua1F2OStwY3FLK00yY1hCVTM4YzQ3ZEhhZGhW?=
 =?utf-8?B?RzdkV1ZYZVg2TFBDRDdsZDN6b3owOXVYRkVtc1FMRUdDVEUzMEFBdXZLdXhn?=
 =?utf-8?B?NGJuQU5xc2pnPT0=?=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(14060799003)(35042699022)(376014)(36860700013)(82310400026)(13003099007)(7053199007);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Aug 2025 05:33:03.5385
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 1d15f385-a344-4ab6-c364-08dde13d5da0
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DB5PEPF00014B8B.eurprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9PR08MB6650
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-Rspamd-Queue-Id: A22B920002
X-Stat-Signature: yonhm1mn76yyrbakjiiamutg6zz8wsx3
X-HE-Tag: 1755840789-591640
X-HE-Meta: U2FsdGVkX18epUu4FKAutmck9gDDDzKZCrQ/wpXlqImBmv/q/Hvboq0qGOAGQJtW+8BzPGvUKO5Bz1SpxpXb+rhYSoxrHymOkOfgrVjVMvccutYufx8r3IwKQvmgmJWhZPtuWT/ZQ/mkFvbxr/Md0Nqlj1pVuq4qrS/55Wl6Io7UUD/mYCwqCqh9t5XhJQrjj9Mm9UdusDZiYtZa3ftnQ3qe+vbIY7mJX7SNpZXQqTiJhJoqwYs3TxpwEYSdj39P5JvKzQiwr/PCmekUlylOBijFokjLZ6zE7mlLQ8kX8ciBArtrMbtSTEse+uz09xP30/VH1Mb4cTnMqRit3BqIJXtVqWZLF+5gLjon35CYdCZyLlHgZDhCymAgs3rOC22gzPV8BLlPTbweUrsUNrkQpC9rFhtPlNbmj9W3Tp5vAAV/p+zntajHu9N4zYWP9a3joJxYw54iUCnhOhDi5PrMHyrCqGnJf6PbMWXVCt9RmiosUhKaVXdlmZYcPxtQ235WH6W20GTqSJKCURA1pQdDW35j9vDOiuGW/3vzoHRA6uwjL8SYsgNytQsn3FLYQJFPwmOAE0uer1Z8dwRTQylT1FsGiw9jHxTP+CUO3D67PX23tKqYjmL96auAHKnuZMs1TNPZ04S88TkBwqbUJZdVNeXPOHH8B0amzjPdyYma/ERSX3Zcww4FOIlnV5HnXIjPhcROTjna2wbC7cnrRllxwSIKiRXBknDg/3YMXMvNl5B0X6xbUKu6Jw3LnxLTf6X/pPwMvvxc80ZhlwcTmBOlzPIuFvfcYiItKdsxFskGAOMzqk6wHTSquJREoG7SWIMqbeQUfKBDDNMEYKpYGHgZcBv2OKEusAJOjZMsfxede639zboJldjfAdC7HwZvcs0H4lwOTPf/TpGHm59vpQAASDgcFJcBiao7xu6vdHWsAtVa4RWg6SJ6pIC7ORfrB1soFZapU8TVAGwd6L58bik
 LEiwN3gH
 aC/VU4IxX9/okXREve7lzKpORHXdjisjE0w/M53DlaLKxIYxHuef2nEFfdxH/eoH76iWwrrAfJ5EZpbObHj8B40NHvMtVAeWkUoctL45CgflGAtIGwpt3xCdI4Eu+9Owr4U48KDHmH1LOIUBBStMEeBxlZ85B6LQ5ffIM4ivu8rnbuGrGlSO72/yKlblLR8TmWMJSCJPH0l6DDoiTq7oLStmzZ4PTgrT6RnPbAN3H1P7tKczkXI34ziCVMKBcX2jv1aFSEcq4C7NscC6/ur0ubUYivJy4jiQ4Yz2LTo1kwePsOTtWTlnVXUsJkk4XqWSZmQALtVWFgEynE3huI5it+AjRyPS1Un2/QoG3KKa0YUZYQJfo5w0Om5ZEqImM4rFUt6AULe5xOrI41l0WckG/imDlS6zDDYuY3HQOzIDtH0sG+Dkam2n8tbcheptRR4T7vXHlmNxTipMYpfEpxy5hXpVdwES8csDjAVPrW7rptjYlHRE0qTakCBzuGqePwWIRV+SBlaU8bX0bd1c7NpMKiunf8ob4j3bXLaHaPC9Va2MT/mvQobQ0UnCw1gAJXm7OTBxFrm3sOHRXdGnr4TySBm5P0wt0ar8fdZIE9vDnXBUmhzQWSv6i2pfJttK4hI7gXmGjyvFzTkEDgMK3xvq9+dK3he8LV28JpKI5rMsWxyrCix8A7HjZbzCpmJbAdwa4qBrqHdrPfbnOC2W9eYULLEGUpER87rtG38uTctS3HGKk5UoDD3SOi6Y8lLg2m8jAzHsq+hwVcC8MxpaVFw9zasThv4ZxhR1VDC0WKzmEN/d8MJGWvwKbflC4rnqQf3k8qLmTe1Rl1uGzl0so7LSluBeYFZsPGGOjI5piz21nX7GCZV6SN95UFL/tTvnuR918kOEkKAQq2+g5hyEh+6VS5WfoHDqsgy35OUPM/3ltJYpybcWcC9Hsn0ugW/0tl74Tj//X+9cADyoO+YnP+/nzjOzPR9zM
 JQAQDvLZ
 mlBrtZUwH11j6i1vm+0B0MZDFlT+tUvYbKPx/5HbZVRD/7O/Rl09CihVK1obDgBfwvjOicvXz+tUmQgyQDczR9UXAPRbGxZ5pacPL4vAg+FUsIuMS8gIYBKt/mT5av9eWYDtDoF4kHJqpS2/R6pfvs9BmE0/SWnlfTsmFs87wTfyTgp75fNwrSXdkLEPaXoNZvbA5QF8jhmrH86xb0/bPO49PlVHF7Bhy1YOlsToOlbXUgTNNTmWsJjnAV77NtmMRO9S9G/uLaY3tIGMAWaPmwppyQgX/GYn3HHns/jgGeCDh3zyNJ5js55fIPYtyhjiWluE18u3sy5pWPjDOsF7aJ3TAFjBT9Ueq0os+NjcNmwb97CJRIODPW9SivHXbtqDEeC1kyF1nX7S8OoTYrhyFaWk+G3jsUm1seMBP3ZEEir0oQWTw/NxUFf1a//c/gJ4
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 22/08/25 9:46 am, syzbot wrote:
> Hello,
>
> syzbot found the following issue on:
>
> HEAD commit:    8f5ae30d69d7 Linux 6.17-rc1
> git tree:       git://git.kernel.org/pub/scm/linux/kernel/git/arm64/linux.git for-kernelci
> console output: https://syzkaller.appspot.com/x/log.txt?x=15f926f0580000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=8c5ac3d8b8abfcb
> dashboard link: https://syzkaller.appspot.com/bug?extid=49a796ed2c9709652f1e
> compiler:       Debian clang version 20.1.7 (++20250616065708+6146a88f6049-1~exp1~20250616065826.132), Debian LLD 20.1.7
> userspace arch: arm64
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=15faa7a2580000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=144143bc580000
>
> Downloadable assets:
> disk image: https://storage.googleapis.com/syzbot-assets/18a2e4bd0c4a/disk-8f5ae30d.raw.xz
> vmlinux: https://storage.googleapis.com/syzbot-assets/3b5395881b25/vmlinux-8f5ae30d.xz
> kernel image: https://storage.googleapis.com/syzbot-assets/e875f4e3b7ff/Image-8f5ae30d.gz.xz
>
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+49a796ed2c9709652f1e@syzkaller.appspotmail.com
>
> ------------[ cut here ]------------
> kernel BUG at mm/page_table_check.c:118!
> Internal error: Oops - BUG: 00000000f2000800 [#1]  SMP
> Modules linked in:
> CPU: 1 UID: 0 PID: 6740 Comm: syz.0.17 Not tainted 6.17.0-rc1-syzkaller-g8f5ae30d69d7 #0 PREEMPT
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 06/30/2025
> pstate: 83400005 (Nzcv daif +PAN -UAO +TCO +DIT -SSBS BTYPE=--)
> pc : page_table_check_set+0x584/0x590 mm/page_table_check.c:118
> lr : page_table_check_set+0x584/0x590 mm/page_table_check.c:118
> sp : ffff80009c9674c0
> x29: ffff80009c9674d0 x28: ffff80008fae0000 x27: 0000000000000002
> x26: ffff0000c079ca80 x25: 0000000000000001 x24: 0000000000000001
> x23: ffff0000c079ca80 x22: 000000000012b950 x21: 0000000000000001
> x20: 0000000000000003 x19: 1ffff00012eb65b0 x18: 0000000000000000
> x17: 0000000000000000 x16: ffff800080528a28 x15: 0000000000000001
> x14: 1fffe000180f3950 x13: 0000000000000000 x12: 0000000000000000
> x11: ffff6000180f3951 x10: 0000000000ff0100 x9 : 0000000000000000
> x8 : ffff0000cdb05b80 x7 : ffff800080d16554 x6 : 0000000000000000
> x5 : 0000000000000000 x4 : 0000000000000000 x3 : ffff800080d15b5c
> x2 : 0000000000000001 x1 : 0000000000000002 x0 : 0000000000000001
> Call trace:
>   page_table_check_set+0x584/0x590 mm/page_table_check.c:118 (P)
>   __page_table_check_ptes_set+0x2a8/0x2e0 mm/page_table_check.c:209
>   page_table_check_ptes_set include/linux/page_table_check.h:76 [inline]
>   __set_ptes_anysz arch/arm64/include/asm/pgtable.h:709 [inline]
>   __set_ptes+0x4a0/0x504 arch/arm64/include/asm/pgtable.h:741
>   contpte_set_ptes+0x120/0x188 arch/arm64/mm/contpte.c:464
>   set_ptes arch/arm64/include/asm/pgtable.h:1794 [inline]
>   modify_prot_commit_ptes+0x4e4/0x694 arch/arm64/mm/mmu.c:1556
>   prot_commit_flush_ptes mm/mprotect.c:197 [inline]
>   commit_anon_folio_batch mm/mprotect.c:246 [inline]
>   set_write_prot_commit_flush_ptes mm/mprotect.c:273 [inline]
>   change_pte_range mm/mprotect.c:354 [inline]
>   change_pmd_range mm/mprotect.c:570 [inline]
>   change_pud_range mm/mprotect.c:633 [inline]
>   change_p4d_range mm/mprotect.c:659 [inline]
>   change_protection_range mm/mprotect.c:687 [inline]
>   change_protection+0x1e84/0x3ff0 mm/mprotect.c:721
>   mprotect_fixup+0x504/0x744 mm/mprotect.c:837
>   do_mprotect_pkey+0x864/0xb30 mm/mprotect.c:993
>   __do_sys_mprotect mm/mprotect.c:1014 [inline]
>   __se_sys_mprotect mm/mprotect.c:1011 [inline]
>   __arm64_sys_mprotect+0x80/0x98 mm/mprotect.c:1011
>   __invoke_syscall arch/arm64/kernel/syscall.c:35 [inline]
>   invoke_syscall+0x98/0x2b8 arch/arm64/kernel/syscall.c:49
>   el0_svc_common+0x130/0x23c arch/arm64/kernel/syscall.c:132
>   do_el0_svc+0x48/0x58 arch/arm64/kernel/syscall.c:151
>   el0_svc+0x58/0x180 arch/arm64/kernel/entry-common.c:879
>   el0t_64_sync_handler+0x84/0x12c arch/arm64/kernel/entry-common.c:898
>   el0t_64_sync+0x198/0x19c arch/arm64/kernel/entry.S:596
> Code: d4210000 97e865fd d4210000 97e865fb (d4210000)
> ---[ end trace 0000000000000000 ]---
>
>
> ---
> This report is generated by a bot. It may contain errors.
> See https://goo.gl/tpsmEJ for more information about syzbot.
> syzbot engineers can be reached at syzkaller@googlegroups.com.
>
> syzbot will keep track of this issue. See:
> https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
>
> If the report is already addressed, let syzbot know by replying with:
> #syz fix: exact-commit-title
>
> If you want syzbot to run the reproducer, reply with:
> #syz test: git://repo/address.git branch-or-commit-hash
> If you attach or paste a git patch, syzbot will apply it before testing.
>
> If you want to overwrite report's subsystems, reply with:
> #syz set subsystems: new-subsystem
> (See the list of subsystem names on the web dashboard)
>
> If the report is a duplicate of another one, reply with:
> #syz dup: exact-subject-of-another-report
>
> If you want to undo deduplication, reply with:
> #syz undup

#syz test: git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git cf1b80dc31a1137b8b4568c138b453bf7453204a

>

