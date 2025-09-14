Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 785A7CAC582
	for <linux-mm@archiver.kernel.org>; Sun, 14 Sep 2025 08:45:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D6A438E0008; Sun, 14 Sep 2025 04:45:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D5C408E0009; Sun, 14 Sep 2025 04:45:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BAEAC8E0008; Sun, 14 Sep 2025 04:45:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 9CD588E0001
	for <linux-mm@kvack.org>; Sun, 14 Sep 2025 04:45:33 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 3AE6013A678
	for <linux-mm@kvack.org>; Sun, 14 Sep 2025 07:27:03 +0000 (UTC)
X-FDA: 83887024326.19.1670045
Received: from PA4PR04CU001.outbound.protection.outlook.com (mail-francecentralazon11013028.outbound.protection.outlook.com [40.107.162.28])
	by imf15.hostedemail.com (Postfix) with ESMTP id 29728A0003
	for <linux-mm@kvack.org>; Sun, 14 Sep 2025 07:26:58 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=arm.com header.s=selector1 header.b="BIyAP1R/";
	dkim=pass header.d=arm.com header.s=selector1 header.b="BIyAP1R/";
	arc=pass ("microsoft.com:s=arcselector10001:i=2");
	spf=pass (imf15.hostedemail.com: domain of Dev.Jain@arm.com designates 40.107.162.28 as permitted sender) smtp.mailfrom=Dev.Jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=3; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757834819;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JcLtiRiYXnmfLLQP4p1Q6J6pauUr6jW3U0hRUoYjCBk=;
	b=3TBknmAw7w2yvfZ3mR/rlXOWUSlJLz1pOr5/JHneG8KKNoF2XBYZlqFZ9yhoTWktBl90qA
	HofchRqvzNmyAPNqdsf03TZae6l4Buq/3Xt/1NCK4R6rUAqRE6M+sOmBgli5cW92SuhuoR
	4qb32piXbokqBZT7qPWE4xlwC+YWqBs=
ARC-Seal: i=3; s=arc-20220608; d=hostedemail.com; t=1757834819; a=rsa-sha256;
	cv=pass;
	b=IWE2195+4pbZ2cjBZ4/FaEw7q6f3HnTfvj0mzvZluej+01aY1Dbd67CqKikU5C7yArrwr6
	gFXPSiVO1eQCC7xTxEISqH745DFvruMTjDB3gmtBvgjCrWMx71I+nN2aC0apkQaqEM/4Xp
	aCxafPHrIZCmHokC8YfQTH+GgUbQdZQ=
ARC-Authentication-Results: i=3;
	imf15.hostedemail.com;
	dkim=pass header.d=arm.com header.s=selector1 header.b="BIyAP1R/";
	dkim=pass header.d=arm.com header.s=selector1 header.b="BIyAP1R/";
	arc=pass ("microsoft.com:s=arcselector10001:i=2");
	spf=pass (imf15.hostedemail.com: domain of Dev.Jain@arm.com designates 40.107.162.28 as permitted sender) smtp.mailfrom=Dev.Jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=ai15/8w/xnykQxY8/GKk7l/VyRIZ2pn2/Dgu12XZzGjoRirqum1RqnOBbubqsXR8SepNQLUMHbqxeXb8DX6YwBBh261UavGvcgxVlAYPLMyWQNvUV11Qfoj4J01gRZLkQ9aU9pNPprz0PqxUMhkI5VXRpCLMXtBnM3nxy9eQ+WyHW5dXjJqetkUARqCZhpuMQ8Ej0I447HQav7/JtL56M0E5nygBgZTT2uRN3IjdXsDC13lKlafzcIpDp+eRKtu7v0T1mOQin6/L+jOkt5DUYSy8M2akyOYb2FRsBlv8N6uIfdc54JhW1+jm1W+1WdIrB/pB3WV8HSXvCKEGq6wDnA==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JcLtiRiYXnmfLLQP4p1Q6J6pauUr6jW3U0hRUoYjCBk=;
 b=VbgtKNd3hnhV6Du5kvTdDhLFLGJ5kjVWwPw8ZwyLN2ONuAfaVd++uPkfXxmdRlLakl0nBMM8yRSJNVU8yabMHgbD5SEfbalRhIzwU/uemJ8kuoht5Yp1OtXvGGztq41f2eY3evCl0ykMwfO0tHXJOcd10JZm3o7zJVeqHO9nAvVyxBwpiwF9ga6JeEqi4HzISJTPEQjR39Iqm7KuulKPso7Ihr8+VFwUVaPShV1GMoGPJkcKXNxkQu97dK7DYvIiLKEsMk+lgGQMNRKto2A0GBhi1xRWuR3qvTQQiIeVZUfxlRv+ZN8S2QiZH+iuMFnPwgr88rwcZLeKz8ukyCjSGg==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=shutemov.name smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JcLtiRiYXnmfLLQP4p1Q6J6pauUr6jW3U0hRUoYjCBk=;
 b=BIyAP1R/DQzEPrN/Q8RtImRDhN5hMu2sAC0Q+67Gc0o8yU1KXCZT43z+zwUAiqhbE9eNN+nR9/UxyIIOPyJMm604mFe9kbLSOK04i99zn1Vb+iz9DOtM6AU6IsxwMhCLSZv/1pbn+cbGPK0DYo8ijptErXrH64D4bpLROnfKy6M=
Received: from DU7P250CA0025.EURP250.PROD.OUTLOOK.COM (2603:10a6:10:54f::14)
 by DU0PR08MB7810.eurprd08.prod.outlook.com (2603:10a6:10:3b6::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9115.19; Sun, 14 Sep
 2025 07:26:54 +0000
Received: from DU6PEPF0000A7E3.eurprd02.prod.outlook.com
 (2603:10a6:10:54f:cafe::32) by DU7P250CA0025.outlook.office365.com
 (2603:10a6:10:54f::14) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9115.19 via Frontend Transport; Sun,
 14 Sep 2025 07:26:54 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DU6PEPF0000A7E3.mail.protection.outlook.com (10.167.8.41) with Microsoft SMTP
 Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9115.13 via
 Frontend Transport; Sun, 14 Sep 2025 07:26:53 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=h67bbC167kCRtSoQ9pWPA4xkIZNBbgRG6l7FF2f9q4hsYPeWioolTPifK4DCdB4fJ+0xxAhHuvFGIWtmFGGBWfsQAKuj6+/0cwWeO+iJPBshsRyHv/MN6qI8l5nMCJqUb5WI8sHl1W15YoeUoeaXLldSfgC/wGVkY58AhrVW1u+A11M/rDOeSWBbHSucNVZFgZL9c8Wln/3nf+IqO707Q3vSp8doUpUdx9zGQbK1bjabSKqHgclqtQ7JgsxQ0oowmvDbGcU21uzMyJkbEgtnHrBr0Q8Qq/uCA3I6OS10e0jDZZ+lemADNYNSo5mU/hHc/551/riJy/9ZjMLcmk/1cA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JcLtiRiYXnmfLLQP4p1Q6J6pauUr6jW3U0hRUoYjCBk=;
 b=yNxwV5yGZ36zqrNFkzqvUopYG/z0dpolGpnacOkyxMzhkrktvSggdz4nO7SgL9DuCGhFyRXdogKAtGN2wCCwUve1FLmzcXX+h7q3neytyiC2Ud6Z/vQnkbP+oimNFcJglYoCG2aeZSduhEKG+G2ttxaQ7zutiOYoQXpThPdGVY74PHLoETSbiQpKJGKPxZOfrqS3q5f9eBAm+UbI3Ed+k6iOsyMBg0rRuwzMNpPpMVG3JO+QbcWsv8bCy3BZf8UUrTFAkHS06RYsZfeDRkI/yzmfP0cIbG6Te/mMs2e4XjvnvDCPS98Nr1vUlTptW/sfofeEyFkF3Z1D8fkEjDsVYw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JcLtiRiYXnmfLLQP4p1Q6J6pauUr6jW3U0hRUoYjCBk=;
 b=BIyAP1R/DQzEPrN/Q8RtImRDhN5hMu2sAC0Q+67Gc0o8yU1KXCZT43z+zwUAiqhbE9eNN+nR9/UxyIIOPyJMm604mFe9kbLSOK04i99zn1Vb+iz9DOtM6AU6IsxwMhCLSZv/1pbn+cbGPK0DYo8ijptErXrH64D4bpLROnfKy6M=
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
Received: from AM9PR08MB7120.eurprd08.prod.outlook.com (2603:10a6:20b:3dc::22)
 by DU2PR08MB7341.eurprd08.prod.outlook.com (2603:10a6:10:2f0::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9115.19; Sun, 14 Sep
 2025 07:26:20 +0000
Received: from AM9PR08MB7120.eurprd08.prod.outlook.com
 ([fe80::2933:29aa:2693:d12e]) by AM9PR08MB7120.eurprd08.prod.outlook.com
 ([fe80::2933:29aa:2693:d12e%5]) with mapi id 15.20.9094.021; Sun, 14 Sep 2025
 07:26:20 +0000
Message-ID: <a3ee891f-a025-4a71-8e7c-af5b52a8484f@arm.com>
Date: Sun, 14 Sep 2025 12:56:13 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/khugepaged: Do not fail collapse_pte_mapped_thp() on
 SCAN_PMD_NULL
To: Kiryl Shutsemau <kirill@shutemov.name>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@redhat.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Barry Song <baohua@kernel.org>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <xhan2av3fyl7qpsl4bhjtds2zeegrl57ehtc5grtkua3c3v3nz@vain5s6gpycl>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <xhan2av3fyl7qpsl4bhjtds2zeegrl57ehtc5grtkua3c3v3nz@vain5s6gpycl>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SG2PR02CA0045.apcprd02.prod.outlook.com
 (2603:1096:3:18::33) To AM9PR08MB7120.eurprd08.prod.outlook.com
 (2603:10a6:20b:3dc::22)
MIME-Version: 1.0
X-MS-TrafficTypeDiagnostic:
	AM9PR08MB7120:EE_|DU2PR08MB7341:EE_|DU6PEPF0000A7E3:EE_|DU0PR08MB7810:EE_
X-MS-Office365-Filtering-Correlation-Id: f1fa6ebb-76be-4ca9-4e16-08ddf3601463
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|7416014|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info-Original:
 =?utf-8?B?cG0xQjJ1S2RWRWZ4L1VXYXJuSHNQYzhSNjhpSm1RcTNxWFBYRllRYVZwWVcr?=
 =?utf-8?B?NEJFZnRhZGdxODNMUnE2TGZxc3Jub2RzTmpRMjVhaDBEYUlobldiekJCN0xF?=
 =?utf-8?B?L1kxeGhDN2l0c2hBOUxrc2ZKalpqaHJFYmZ2UHgwNC9CQWtCS3NBdVVVd1lS?=
 =?utf-8?B?aWdoaGsrekR3Vjc0aXVpbTdGYXg0T3doWUFpQ2xaQVFxeXdnclY3K01QUjFl?=
 =?utf-8?B?N2xCdGJ4MDNLNkFTNVEzd0pkN0oyYlN0cisyYUZZc1o5bnNISms5bVUrVGt3?=
 =?utf-8?B?cUdKUEhsU2FTRzN0RG52T2d5eTBGd2p2ZjVyeXVrQTh5NWtVdEdVRDBJN1NQ?=
 =?utf-8?B?SmtOaWZXTWdCRFkwTUhCTWZVVFNmbC9nbW5jT0dqQjZaVFp6UTNuWHRIbG1l?=
 =?utf-8?B?MTZCSjlPRFFRRFNxdzlHZ05VOFI3Tnlyc3kvNnNpVFc2dkxsa0xYMVl5ZTJ1?=
 =?utf-8?B?dFNycnRONGRBSW42MUZPU2RlVE5QYXVKK0VvcU5kOUk3Z0Y1MTZrK3dBeW41?=
 =?utf-8?B?U2sxK2lsS3VLcTB6VEllSXZIeVR3a0QxZ0tHa2t1TS9tMFF5V1Vrc0NmV3JQ?=
 =?utf-8?B?TkpSc0wwb21KWlFqamE4SUZVcGZNcDJ5bW16K1lQcWhUamVQMUl1UldmcE56?=
 =?utf-8?B?WldJMXppNG5YaVJ5cnRjQW1FbDE2V2o4d1hhUGpCdERJdG1mSUFGZEJkOE5u?=
 =?utf-8?B?Z3VyaXk2N0ZhM1lGMzZVRUcyM28rYzFZczIxSHRFRk5jRGg0UkdEWlJZOUZM?=
 =?utf-8?B?TXJoYzU0Zm1Id0h2Y0hnWGFrS2ZXc0djUDlIVi9jOFF6VWdSVFhMaFJ4NHV0?=
 =?utf-8?B?dGxOamorZ3RwNXRjdkRmWk5WZ1VZdlBzZzFJNG0rZUZTeDZJRFhXWVZIL1cr?=
 =?utf-8?B?Y0c2aWx2Z243Q3lPTEJXMnQ5N2FqczR6dFJVMGFoM1VCOFpXTjlrT0dmSUNp?=
 =?utf-8?B?QzhsZ1VzY25MNDFqTEc2alZhWHRqbmNlSTQ5RU5hSSt5THVSWjRhT3FIWCtR?=
 =?utf-8?B?TmNkZ0tLKzFqRTRWZVorWUpUcFJ1bmkxVGM5MkZPSlZmUUJxYmUvWVFXRmw4?=
 =?utf-8?B?amVKZWZXZmFEVXpyaFJKMis0VVowMC8yN0xJVHFIVzJEYm9QQjJNYU5mVThx?=
 =?utf-8?B?WEU2OEF4M1kvREhwM2szK29kRHBscG4xNGhGdFoyaEpzcWRsdHJwSm9rdzJW?=
 =?utf-8?B?MndJVy9oVkNJbCtCL1hGYzg0NE9Pd0NBZjIyUkdkeEI0SHBBRWVUNHNCaG9h?=
 =?utf-8?B?SzNNcndNQkNWbUZZM1Vla0NPb2N0Y3lrc2dJaCtmbWdJQVFNVkh4SmdjNSsz?=
 =?utf-8?B?YmhuMzZrNEM2Njdhb2MzSmIxSVZienNmWkpKTW02L21EL3Ird016ck1saWt3?=
 =?utf-8?B?TTNZcndZbnArV3YvMEkyMFo1dm5wYlVjR2t1b0x3OGg2VDdlcWFkeTh0V1gv?=
 =?utf-8?B?K3VobFFqSDltZ2V1QWJrYS93YVlpV2JBRTV0WFlFS3JQTHlJYmRJcFVlOXhE?=
 =?utf-8?B?bW9BZG5uZ2I0ZGxvL1hOUGwrUTFPY2dTVmMwS1NIaEM0ZVYzbnBQcEI3UDVi?=
 =?utf-8?B?SXhuamQwT2JPQ3MreUZ0T21va1c0ZzJpT1hvWEtleWtYTzZNWlUweTNzczhN?=
 =?utf-8?B?NjFIT0N3b1pOcG9jbmRmbDZuVWxaL3ZvcnF0RFlaYjFzak1oMUp0RWpRa1hD?=
 =?utf-8?B?ZklYYWYwQm5aQmVtTXdqNHF0ek1vbmdUVTFOUTlDT0JUUlF4b3VoSk5LNy9I?=
 =?utf-8?B?Z1UzTUJpeUtZcC9Ja1lzaUNxSFNWUFZVNTBodWJrbzVtSWNGcGdQM054Zkxm?=
 =?utf-8?B?TFFqSFRtK0wzYzhiT0l0TlNVT2MxaHRTNXNWZG45bTBBdVJjQWpJbWM2MEVE?=
 =?utf-8?B?ZjhWV1dhVFRKYUN0UGdOTnRPRk16SVNEN0NrcE9qN3VWWldnQ0hiWE1hdEl1?=
 =?utf-8?Q?b8t05N8p5GI=3D?=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM9PR08MB7120.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU2PR08MB7341
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DU6PEPF0000A7E3.eurprd02.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	dde04f38-1349-4da5-dba7-08ddf360001a
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|7416014|376014|14060799003|35042699022|1800799024|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?VGdZMG03QXdEUGdhRTlTM0YzdFRPS25JenVZcFVIRXRrQ2didWJvU1RENVhv?=
 =?utf-8?B?dkVac2dSN2h1amhGeWh6UzdHaEhvT3cxamdWeU1YY0IrZk91WEo0S2ZlcHlO?=
 =?utf-8?B?QjZDeE56UldKa3RhSUdZZ1Z1NDJld0t3WFplaXRxbUJnUndjeE45SWxUdUNk?=
 =?utf-8?B?dTZYbVVXckM1MGZua1cwdlFlZUs4ckZZazE2QkJrWWQyQVk2ZDZDZUVRVnV4?=
 =?utf-8?B?UjRMbDEvU1B0OEZkcmE0ZDJ1UFhtNThDZk5COWZmU3p0Yy9Xc0dQcndWNXpQ?=
 =?utf-8?B?RFU3Wm9MalVXYnFpRlBVeEZHNStsNmNrWnJSeWJ6MnhWQkVBdjZGbXowcGR1?=
 =?utf-8?B?TW1LZUtXRW5NemREa2ZRSlUxdFh1MVhGenhNQXFzamwrY0NGL2RNL2FjeHg3?=
 =?utf-8?B?Z0dGMTlHTStwVzdFOFBRQXppSWE0K2IxRUczQkdrdlIyWms1YU1tZ3J5QU03?=
 =?utf-8?B?VmVDQy9mVHpnM2h0a2NldkUwU09yVkt0Z0ZUcEtMZXhXZ0o3SUluK2tpS3Ev?=
 =?utf-8?B?WVk2NGFQa0toWitXbCsyK2tRbWFVYkdWVW1yOU52RWUwTFhZakpoOEJ1QzVp?=
 =?utf-8?B?SzRzQkhsczlRWkJ5cnRWVk1XeTZ6SWZDekY0eW9oS0NEQ2pHazdOQ3Rhd2JY?=
 =?utf-8?B?cXNmUHF5aDRwVGNEcHFWcTJuUkRBYldKTWN1VVUxZkxPaVBsc0FuazJjejQr?=
 =?utf-8?B?RU5vZkFoY21BRHhBQTFpLzl0ZTJkSUpKQUZZYVBPVmtoZVZnK2dhMWh2VnFx?=
 =?utf-8?B?L3oxZzZ2dUlLSEE0SGRRVTF5aWswVkd0MFZXazl0NDJxNTdLM3g3NUlJaFIv?=
 =?utf-8?B?MEQwbkxjc2tvMFFDZzJ4UEplYk9wS2dWM3FPd3dETURMdlMySGlpUXluTDBK?=
 =?utf-8?B?UEZrWk4vSmxRRUg5Qm5YL3BBMk5SVDRxeElDR1VGdGlhZjluNDk5c3pOVkhI?=
 =?utf-8?B?d1pFd3ZFcHhsL3FFd3J6emdoY1JOOTJhV3c0M3FBWDdKdTlOSzhqSVVQN2pQ?=
 =?utf-8?B?b3lJeGZ5ZEtYRGxHK016R1B1RnZCRVQ1TnB5TjBSSENyUEdNSXhPNWZwS21z?=
 =?utf-8?B?TzVVOVN1MWROOTJWNDJaaWZrLzhMdFViODU1c0w4cXVybjJ5U21wWkNTVUMy?=
 =?utf-8?B?VWsrblpEWVpmWlhOdSsxbXEzUTZCNmErSS9EeG1zV2RDd3RTYWdVU2pPSWRD?=
 =?utf-8?B?dGdaSDBIYnFoSlM2WnFTZGZLNjBDTWw2OCtOVHF2YWlNZjd0dFNuMEF4V3Rv?=
 =?utf-8?B?TWxkN1k4Z2FJeW5XSUxkaE1XQWxodEp2VGx4YzM3MGhua2s2c3NTdXNOQUJF?=
 =?utf-8?B?RjhOTDkzTEQyM1IzQ0Fva2ZwMHk3alhpY2Z5c3poNjNzdStoQWJrZ1NCcThV?=
 =?utf-8?B?MDl1ckRkQWJXTVdET0xTR1ZmUTYvU3FIN2Q0Z3pqSWtUbG1Od3p5ZnhZcTkr?=
 =?utf-8?B?bjRIRVVNc0ttOHh6WndlcFUxeEVnUVVSV2kvV3RYUWNsYXF0M0tIUiswc0V4?=
 =?utf-8?B?dGVuV0xvK3JkQ1Y5ZzNwY1kyRml5bjN3ZXVSNTRVSERqOUJMN1pWbVJ2c0I0?=
 =?utf-8?B?dVFQdGJuNmY1OHRXWEZ0U1dNSWJBQkNnQVVEV2IxanhvbDdvb1QyY0ZJU3oy?=
 =?utf-8?B?UGM0dkdjQnVJaGs5NHJUTW80V09ZTXhhZ3BrSnM5TkZjYSs0a1RvUnBhUENX?=
 =?utf-8?B?dkJPQTlnZ2oxWkNxSWZFQlQ1cHRST1BueER4dUtSNzVVVy9md2FROXcwV0JJ?=
 =?utf-8?B?Rm1sc3JjNTE3UzJlcXVrZ1B2VzVKb25RSWdScWRxZ0NVK3BDdkhYSEtvdW16?=
 =?utf-8?B?WjAyYm5MNTJXcGhwb2dEYXpqb3QxdGpEUDMvU1ZzOVV1RUppWkRVZEJzVERZ?=
 =?utf-8?B?RUtxVVZXNU1QbVVrZkg4UUcrdXdlTlUxN0hyOGRCSWk2bDNrVEhEc0RkMVRn?=
 =?utf-8?B?ZG9qWFNOVkNkUFc5NzFCT0ZYRGNvWjg1RXZlZit0dnR0TGFxNjMybXpmNnV1?=
 =?utf-8?B?NkttN1FGMkcxNXhZWm93R0RNd1dqMFZOUkQyK0cyNjhQSnhQY2xSVDhCbVZa?=
 =?utf-8?Q?R9JqOu?=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(7416014)(376014)(14060799003)(35042699022)(1800799024)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Sep 2025 07:26:53.9965
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f1fa6ebb-76be-4ca9-4e16-08ddf3601463
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DU6PEPF0000A7E3.eurprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU0PR08MB7810
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 29728A0003
X-Stat-Signature: 519nagxazdind6u84tqjsd8xadbzcax4
X-Rspam-User: 
X-HE-Tag: 1757834818-895105
X-HE-Meta: U2FsdGVkX19/guW/dvfgFLpPMqFpnM0bj1lRb0bRViAw5ICMfU0oKQRD3YuKhZTFgIUstMUBMReDdGJmPYYuer6OtA0aLVI0a9OZDdvYw0iyIFmWSPWVRHWDi0aL0e4uUZj7cEoTzBri+rIZbuVjnuzSLDwCDcMvT5WWmNXbZZgbAH8Moz1O1ToT6g8ldVBZRiaYzaIsLxBA2jjBisZ/kkZKO6fEUG12w3Duvirzrhwis2iMmIlv/YwaqM0bEHbzu2galymmVYcZ71+NNOtOuEFPbIfspyIYRY6jRbBjHv4qMb/FjkWuuzYdmi8rSaIXEzp0iG91NJFMg06inB1i8YhzI9JF12Q1kQb8siegSS4PYYo2mfIwu5j3XFko6UTQum2e8bfwvqpCeeZyx/X7HL9NxEv7sEnTNOk3l/uEicmLwLBHIEriggT4mzxzrOgYYzlnNmTTLHmHwnMVZg78kalJanXCAL6dm3zPfBnF9R00Ddwo+uC7Qnj813mvUGvtYeNKRWaL4aW/Soe+aPTOzkQAoKwLo5lWM+u7nvZyAUWvkbf1dcW19Jd659/nsEH66BXenB0LJtpFu+tuuXIt5BoSrtNpT/Brtr1BZmeT5bY2jVTPoMdcZIOwp8xS2sRzWfJfvdVvbvrAfK8snBmglNNf7dq1p2gYp8T0Piofc3rZ5qlNfpa4QYSezzOLgPcBms83FmdCnsP9MeMaZSD7Kb4/UjH80W30o0obcTC3iQFUwlUbVtSCihst+mQfFg2BuktNUYfzsS6HbrFUCCsUuZdd9nkg+XnryafL2ZnQfGnh6s3eegx4Yw0NNejDTBJXmCf32V0mIW1G+IKviBSfkw3Tv4g54H15sgtUpAaOgYYQMjc//1UYHdrk0jHC3cM4QdCbmOICZqKMjK+P+6vBMhkF3qqvdrw7f2J3U/wY07d8BqWx3iF8eiW4rl9X7XNdSFbhQPoMZujAlIVrsmx
 YXcusTBZ
 UaOlvqVbZTm1OQh+PFxM00lzV3C17tbilzTUzJ5Lfxw0/YG1J1BCWOU/KI1t8WP8IDAhoO3e7DvJYqW6IAK2TkpoNRDviqexaP64uF6GKxbYmb37UWQDbHHyAt+gN0dHYJ1u6qgA04NDt4mN56o8oZ9H+nwAHlNYAb9Aj26fnvOtkYjdH3dKuHktxADhUlUmP0X3nzOY3eiEc4fgWNEWaUEVOkBQ1H7QJH9xZ/AgrV5C0fC8Qddv58L2Gt1/Il//FfUxf+TLXLEmylYbTn5GQCMdc891DPJKDFRGS2P9FKTLMgVv4sdPkK5wWzvTaP4nZGzLD0qm1IaFwy+M8IqhA4ybor9t1T/FCFq5Sc15NbafaTy6u/xP91IggLrTVYOmtiGuJHecyw4Dp5ZZ1QTeZnOW+2UIdP0/8yK8uKrmkTqfib5z5V4Ygum5keEdeV7WLR+xlJyASqf+RoirbSYPmw5YCLg4DZvR83mWN/+ODqCn8ppgpoQUDnlETe7YKIQd8cgBEYiOQVRgfi5zMRnF2syZjDfk1293ggAkkfkl8L1EdnSGaWLB0dxl5FvKrVpIHG8iHaJ/LCwYEj1armK2cSGSpwKFriN8j6X4Fe6x4V6oj8BmPoTrVWeqY3dUIfMzCSr1u0E47KrEAjvGbgWtDpIPwZQuuv2oxFk6lsVhRimWmri5uSCNlyChrnmBg3okw0OmyInNEBuUibRZ+TcTDHk59T5Iaf0uC2aJy
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 12/09/25 10:28 pm, Kiryl Shutsemau wrote:
> From: Kiryl Shutsemau <kas@kernel.org>
>
> MADV_COLLAPSE on a file mapping behaves inconsistently depending on if
> PMD page table is installed or not.
>
> Consider following example:
>
> 	p = mmap(NULL, 2UL << 20, PROT_READ | PROT_WRITE,
> 		 MAP_SHARED, fd, 0);
> 	err = madvise(p, 2UL << 20, MADV_COLLAPSE);
>
> fd is a populated tmpfs file.
>
> The result depends on the address that the kernel returns on mmap().
> If it is located in an existing PMD table, the madvise() will succeed.
> However, if the table does not exist, it will fail with -EINVAL.
>
> This occurs because find_pmd_or_thp_or_none() returns SCAN_PMD_NULL when
> a page table is missing, which causes collapse_pte_mapped_thp() to fail.
>
> SCAN_PMD_NULL and SCAN_PMD_NONE should be treated the same in
> collapse_pte_mapped_thp(): install the PMD leaf entry and allocate page
> tables as needed.

Thanks.

Besides this patch, the label maybe_install_pmd is misleading -
SCAN_PMD_NONE means that the pmd table exists, just that the pmd
entry is none, so the pmd is already installed. Along with this,
the argument bool install_pmd should likewise be install_huge_pmd.

>
> Signed-off-by: Kiryl Shutsemau <kas@kernel.org>
> ---
>   mm/khugepaged.c | 25 ++++++++++++++++++++++++-
>   1 file changed, 24 insertions(+), 1 deletion(-)
>
> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> index b486c1d19b2d..9e76a4f46df9 100644
> --- a/mm/khugepaged.c
> +++ b/mm/khugepaged.c
> @@ -1488,6 +1488,28 @@ static int set_huge_pmd(struct vm_area_struct *vma, unsigned long addr,
>   	return SCAN_SUCCEED;
>   }
>   
> +static int install_huge_pmd(struct vm_area_struct *vma, unsigned long haddr,
> +			    pmd_t *pmd, struct folio *folio)
> +{
> +	struct mm_struct *mm = vma->vm_mm;
> +	pgd_t *pgd;
> +	p4d_t *p4d;
> +	pud_t *pud;
> +
> +	pgd = pgd_offset(mm, haddr);
> +	p4d = p4d_alloc(mm, pgd, haddr);
> +	if (!p4d)
> +		return SCAN_FAIL;
> +	pud = pud_alloc(mm, p4d, haddr);
> +	if (!pud)
> +		return SCAN_FAIL;
> +	pmd = pmd_alloc(mm, pud, haddr);
> +	if (!pmd)
> +		return SCAN_FAIL;
> +
> +	return set_huge_pmd(vma, haddr, pmd, folio, &folio->page);
> +}
> +

For the SCAN_PMD_NONE case, we are unconditionally traversing the pagetables
now which is not needed. How about, in set_huge_pmd(), we pass a boolean install_pmd,
and at the start of the function, call install_pmd() which will do the traversal
and the pmd_alloc()? That will also make it crystal clear that in the SCAN_PMD_NULL
case, we are first installing the PMD table and then setting it to huge. Right now
the distinction between the two cases is not clear.
  

>   /**
>    * collapse_pte_mapped_thp - Try to collapse a pte-mapped THP for mm at
>    * address haddr.
> @@ -1556,6 +1578,7 @@ int collapse_pte_mapped_thp(struct mm_struct *mm, unsigned long addr,
>   	switch (result) {
>   	case SCAN_SUCCEED:
>   		break;
> +	case SCAN_PMD_NULL:
>   	case SCAN_PMD_NONE:
>   		/*
>   		 * All pte entries have been removed and pmd cleared.
> @@ -1700,7 +1723,7 @@ int collapse_pte_mapped_thp(struct mm_struct *mm, unsigned long addr,
>   maybe_install_pmd:
>   	/* step 5: install pmd entry */
>   	result = install_pmd
> -			? set_huge_pmd(vma, haddr, pmd, folio, &folio->page)
> +			? install_huge_pmd(vma, haddr, pmd, folio)
>   			: SCAN_SUCCEED;
>   	goto drop_folio;
>   abort:

