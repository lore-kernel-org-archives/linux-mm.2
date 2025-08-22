Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 99BA8CA0EEB
	for <linux-mm@archiver.kernel.org>; Fri, 22 Aug 2025 05:50:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C36368E0071; Fri, 22 Aug 2025 01:50:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BE6948E0056; Fri, 22 Aug 2025 01:50:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A87C38E0071; Fri, 22 Aug 2025 01:50:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 923268E0056
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 01:50:34 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 1ABF883C49
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 05:50:34 +0000 (UTC)
X-FDA: 83803318788.03.338EAE0
Received: from OSPPR02CU001.outbound.protection.outlook.com (mail-norwayeastazon11013071.outbound.protection.outlook.com [40.107.159.71])
	by imf17.hostedemail.com (Postfix) with ESMTP id 7CCE74000B
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 05:50:30 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=arm.com header.s=selector1 header.b=fm3qRzgM;
	dkim=pass header.d=arm.com header.s=selector1 header.b=fm3qRzgM;
	dmarc=pass (policy=none) header.from=arm.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=2");
	spf=pass (imf17.hostedemail.com: domain of Dev.Jain@arm.com designates 40.107.159.71 as permitted sender) smtp.mailfrom=Dev.Jain@arm.com
ARC-Seal: i=3; s=arc-20220608; d=hostedemail.com; t=1755841830; a=rsa-sha256;
	cv=pass;
	b=oKVSmm3Lx2GGqAwlnNr9T14UeBF7ZPL2Yma/jYXSWC+OtKGpbCQNzVbdNFSn9b2UKTsDAv
	WGPIWSlhf/HTTNKREKyMKJG0GdkgvELu6YonhY9CVNh4arvWA78K2dOdr0rme9fGHDn4Do
	Olrfb1qANAHTrbF9prfLqZ7OuL3L59E=
ARC-Authentication-Results: i=3;
	imf17.hostedemail.com;
	dkim=pass header.d=arm.com header.s=selector1 header.b=fm3qRzgM;
	dkim=pass header.d=arm.com header.s=selector1 header.b=fm3qRzgM;
	dmarc=pass (policy=none) header.from=arm.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=2");
	spf=pass (imf17.hostedemail.com: domain of Dev.Jain@arm.com designates 40.107.159.71 as permitted sender) smtp.mailfrom=Dev.Jain@arm.com
ARC-Message-Signature: i=3; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755841830;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8ttqbdPraTexfzW6DXOcVz4T/z36mId2GmuOFGK/x5g=;
	b=u//M9jJp5j6ub2sGBO0WsZQVGA39BTJUiCCjXonyIiQ5rP/aO6zg4ZfHhfqFweumoj6hJn
	upuvjEGzMN685kwNjiDdtSos7RBidaUEIXm7t2l7V9hJsxDtuURhMxhLs0NouEe0MyLMEU
	9z/pewvsvLMyZSFC3AHAznv/OfddidQ=
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=MQDIPeThdp6bp+S87s6EXaR6QhdM5EFKOhYuqNujHwVscbja4Rq5YEZUlpEojUsW6LpmgdNhgwdGRJh3WoCKBtUA7ftFQ4sVRdYiRTNilQSevDXkrbj7OqC83eYsfAiV3n1eeQUXiwfOqIdRZgZQBRcIYbDVSr2pMdNXqxb7KuxWnmrhus1fJEOQWatE9C3/cJH99IlHBj+6z6HRBBJU5HMlVIq3RkxlRnJp2bkSOGqR8mcCiaOQaAxOd71+clhEtDkVBChXF4e63mmoVzm+27OP4qs4WXG6eE2NMuOnS4+q2Qdgbf9x53BmqeprDqWW9u0e68orSDwSc0Sg/iX+Lg==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8ttqbdPraTexfzW6DXOcVz4T/z36mId2GmuOFGK/x5g=;
 b=KkxJ7PYcTGRe4ViMcAQtqYm3s2KrVtB1s1s/FMHkXJZbodubKOVCsUknnyzrG/3K04f9h3q+2sL7Vh2GPPAN2pyL5ZBrtJBksMaZoqHbkjln7zmGzLWhOau6+bTbNM+Aa0ash474PqvVBgyMLjCF6RWgQ6QBc38M3IOp9h6OzKgWFOp7a+y+1YEwCQGgdEPqIvqH2S8W9dHfe+zXI3M0ZQ5PrxfTIaaUG55/wz+1pSdR8AHQZO1TM9PcoIRfF6t6s8/cqr7mC7NGsS5wCLX3MizaTXD6Q6gX4uRZ2TC2cB4kWOTTe4Wf68yn/1SW1tX6FSEPNFWsNLg1mZ/yTZeYtg==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=gmail.com smtp.mailfrom=arm.com; dmarc=pass
 (p=none sp=none pct=100) action=none header.from=arm.com; dkim=pass
 (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8ttqbdPraTexfzW6DXOcVz4T/z36mId2GmuOFGK/x5g=;
 b=fm3qRzgMlWLUK7zmluI2wRvn1dMZnnTGKAHhzuOmW6NJVsl19IVgX41zdVcEqsuFrAzmsRWRfdLtj1zD/V5YNgVVKpURbun78oHwmSdcTchY91g6uug8mG6/wArjVpINYa5YkNVucrm++SRtxbr2/LOvivx9Ede8x+tN0P5Oe6w=
Received: from AS4P189CA0019.EURP189.PROD.OUTLOOK.COM (2603:10a6:20b:5db::10)
 by VI0PR08MB10972.eurprd08.prod.outlook.com (2603:10a6:800:251::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9052.15; Fri, 22 Aug
 2025 05:50:26 +0000
Received: from AMS0EPF00000194.eurprd05.prod.outlook.com
 (2603:10a6:20b:5db:cafe::40) by AS4P189CA0019.outlook.office365.com
 (2603:10a6:20b:5db::10) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9052.18 via Frontend Transport; Fri,
 22 Aug 2025 05:50:26 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AMS0EPF00000194.mail.protection.outlook.com (10.167.16.214) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9052.8
 via Frontend Transport; Fri, 22 Aug 2025 05:50:24 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=MmJX4SXPH3BgJQ00bNKgWmWpygZ8opdiwJQoTmpOWRRSeya34viZctUW5pd1kp9V8Hfa/jaj9BAxVY6tNu2UTdo44AaBqm4zLbMWcd29HHzpfzfO35N6EQ75IkW18PaH9TIZuAwuR7cJ+ldphz+FfXl1rXF9ExM2CPsJkJvkgeyM5ULPnYQyb9cNbcW6Ol4Qun99pnj8UjY73IX6s8QEFXsnS6hpBjAj7QLNf1gjyqF+ZZSIrEyk1ku3xw31IxYnWpGcNdHqTBiZJG03mR4/spFDu4J+L9TMhwR5nBoVMEp1RqJBUexnGF8z1domyWzNFCvCEa1PXk2IolRWUWQc7g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8ttqbdPraTexfzW6DXOcVz4T/z36mId2GmuOFGK/x5g=;
 b=YyS+CyMUb7bElJGWA37/H2Mpyb3vmWKlcpp8RSRw6wvJeB8fNzvCd+QLERPI/Fk2OtguXsfCWNnW9EEaGpyXgannhICdIHEfJVLDtYnfKwmG7H2+zB+F54GaDPvCLlJGqAMtb5I94Nb0EV0+bjbYtw8ziW9UA0qN8CJTf1afpTuc+kchEGL3AwFviEtBdVVAr7Rb98Tjkv8WP9cl2+jiRPAHk6P3lQ2eCSUVPHz3ZIPEgYXMR0J77WmG8Sx5+Xj96IXOG6CNGQTZtbhaXfneY3eIfTAylZb0wO+47jJndej1403FjRrR3V64lZ2QWy/nkS6upFe4/ymTfAxy60xvgg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8ttqbdPraTexfzW6DXOcVz4T/z36mId2GmuOFGK/x5g=;
 b=fm3qRzgMlWLUK7zmluI2wRvn1dMZnnTGKAHhzuOmW6NJVsl19IVgX41zdVcEqsuFrAzmsRWRfdLtj1zD/V5YNgVVKpURbun78oHwmSdcTchY91g6uug8mG6/wArjVpINYa5YkNVucrm++SRtxbr2/LOvivx9Ede8x+tN0P5Oe6w=
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
Received: from AM9PR08MB7120.eurprd08.prod.outlook.com (2603:10a6:20b:3dc::22)
 by PR3PR08MB5660.eurprd08.prod.outlook.com (2603:10a6:102:8d::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9052.16; Fri, 22 Aug
 2025 05:49:52 +0000
Received: from AM9PR08MB7120.eurprd08.prod.outlook.com
 ([fe80::2933:29aa:2693:d12e]) by AM9PR08MB7120.eurprd08.prod.outlook.com
 ([fe80::2933:29aa:2693:d12e%5]) with mapi id 15.20.9052.014; Fri, 22 Aug 2025
 05:49:52 +0000
Message-ID: <fc3aa176-3ddc-4b8e-b870-c7cef64c0a53@arm.com>
Date: Fri, 22 Aug 2025 11:19:46 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/khugepaged: use list_xxx() helper to improve
 readability
To: Wei Yang <richard.weiyang@gmail.com>, akpm@linux-foundation.org,
 david@redhat.com, lorenzo.stoakes@oracle.com, ziy@nvidia.com,
 baolin.wang@linux.alibaba.com, npache@redhat.com, ryan.roberts@arm.com,
 baohua@kernel.org
Cc: linux-mm@kvack.org
References: <20250822025732.9025-1-richard.weiyang@gmail.com>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <20250822025732.9025-1-richard.weiyang@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: MA5PR01CA0020.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a01:177::9) To AM9PR08MB7120.eurprd08.prod.outlook.com
 (2603:10a6:20b:3dc::22)
MIME-Version: 1.0
X-MS-TrafficTypeDiagnostic:
	AM9PR08MB7120:EE_|PR3PR08MB5660:EE_|AMS0EPF00000194:EE_|VI0PR08MB10972:EE_
X-MS-Office365-Filtering-Correlation-Id: 1cd0e0cc-e32b-4fdf-ae52-08dde13fca11
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|1800799024|366016|376014|7053199007;
X-Microsoft-Antispam-Message-Info-Original:
 =?utf-8?B?cHNnelZUcm9kSGhrYUM5dllLeUwzOEI4aUF6YUlLVDVyYisyb0preVlRRCtx?=
 =?utf-8?B?VllYZ2RxSmZqNXJjVU1IRlJFZzh3L2lpUkJpblpCeUtseEF0NUs2MDVRbkVT?=
 =?utf-8?B?WEVVRE1idmEzWFZMWkRicE5FeEdaUVBJc3B6QUZQdGtydGI3d0ViVXc5WDRj?=
 =?utf-8?B?RnpYamFheEtGWFZ2a0F3MC90MlI1dlZObFFxeS9iOWdJOFRVakEwYm8zUlp1?=
 =?utf-8?B?OExwRk5pWlJmWDRKeWtjYXcwMjB1VHhkRHlOZ1dVZkpuRnQ3N1FQekxRUmhR?=
 =?utf-8?B?MlhmYS9wQ1E0cmxlc1JsTG5TZmZIek5pZGsya0tnVlR5U1hMemNya0tmaVQ1?=
 =?utf-8?B?RXp6VHJycUQvRUkzeGdySUhHclpscEUvMnZSaFE2aFdsOUxEU0w5RTN1TFJm?=
 =?utf-8?B?T0xTZERzQTUwWkRFSm1pdnUwWk56MDBUVk9palU2ZGtCaEc2eHRMUVo5dkVK?=
 =?utf-8?B?UkFrUUJoQ1M4dlVrZ1lHd1RucnVNbEo3QzZEYU9KSmc1cGV4NXhBdUh1OGNq?=
 =?utf-8?B?UEFVSTBwQTJZVS9UQitPY3Vod1REanNkTUR5dVhGNXNjVEFWQkJERS93cWUr?=
 =?utf-8?B?MHVzM2x2MUwxSHJtVXlZQkEzeUVqd3Z4ZkhOUElPZWdIcnFnQWJkMkJZVW42?=
 =?utf-8?B?L0J1dGFKWjN1UkFZdGZGcDk0UFEwRUFsRHRQYW5XRnM5K2VDS0RyUzB1Ulpq?=
 =?utf-8?B?WGFYS2x6R0IrOUt3c05USFh2cUlRckc1a2ZsckFsQ1lpRmxXYkU1Mmd0Y0U1?=
 =?utf-8?B?bzZNQk9pbVlWNlh1MUpIc2NoT0xaQWxmVUJMci8wNkRxYU14KzdCcnRPUkZj?=
 =?utf-8?B?WURSaXY0enYyY0t5UzJCdnVtMDlsMHFEamwxSHV0c2Y5MlBiOWh0RWpMZlRi?=
 =?utf-8?B?Yy9leHBpUkI1TjhIK2VIQjZISVhpMGhCWjhWcjdBTTEycnczU3AxUlVBOFNq?=
 =?utf-8?B?YytVdzE1Q0s3aUhqTTdhK1orV0ZwMVh2ZXRITm9DZmFwSVk2Ui9GeVlRSXBx?=
 =?utf-8?B?VUJsekxPdzlzS0UzRzUyTGcvWkgxZmluS3hTUXdqOWEweGZwWE81TlBaL0tZ?=
 =?utf-8?B?MTZnOFQwdkVUcVFDR0t4Zyt6N1pmdGw4V3dNdXFMN1FsRHl5K1JheTFrYWF5?=
 =?utf-8?B?S2ptdGFsWU9DZjFBTGFhK2JzKzNHdTAvcWM4RUllVUZDaWEzS2ZHTXZsWHVY?=
 =?utf-8?B?c3FlNzRRVWNQemZ5UEo1QysvbEZJaFArNmtSWkZzOTMvV010YmhsQ2F1ZCtN?=
 =?utf-8?B?SkM0a29RRUxYMDFMRzBySERneUhMNUZBZFpjQzhCZ1V5a0phbXhFNW1OZWVC?=
 =?utf-8?B?a1E3ZFFVcnpHdG1neWg2d1lheElGUkV6NVR4WEhZSWN6M1d2U1FqdGJWYkVp?=
 =?utf-8?B?UWJNUkd0cmQ1SktDVEY3Wm1Udno1am1QZ09ZOU1GWVJDU2tmajV3M1p2YldG?=
 =?utf-8?B?WnNtMWxxYitQMFhJOGFkaHVjNytUN2g4cUE0WlBwMXRPTUJaMXVkNkdzRVlC?=
 =?utf-8?B?Qk5JelZzeEhxWjNFY2pIa1hJV1QwUzh4dmEwcWhKMlhUTUpjUnY0dHBPeFo1?=
 =?utf-8?B?UlVmMXpmYTZIQVI0TUt3Z0E2aXQwNkJ0RjdNV1FZWlhwUmxrRUp5anEyNFlO?=
 =?utf-8?B?OHNtS3A0eHpFc242UzlmY3VTcXhUcllEMFZQY1N0d2ZDcHU4WFR6OHNOY1Fm?=
 =?utf-8?B?WnkvOGUxbGtxTnNmK0VrdUhFRUhTd0Z4S0dhTXFpdDZ6NlBpVG16YzdDb1Jv?=
 =?utf-8?B?a2ZEVmlwbE91NjF6aGdKWWxTN2JJZlFCWFhuTkVjdkhjd2ZsLzRiMVBta0tE?=
 =?utf-8?B?MXEvUFg1b01YaVMwbnlNUU1PZGVGbWFHTFdhQ05RUUNSQjJTS3NveGMwdlRp?=
 =?utf-8?B?djhqeE5rUHpCQkpPdllwbGE1YlRHcGYvR0wzWWdNTWxvRG4vbmdISFMyMi9H?=
 =?utf-8?Q?21CYlNbm3WM=3D?=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM9PR08MB7120.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PR3PR08MB5660
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AMS0EPF00000194.eurprd05.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	fa7465b4-3441-4d90-5c45-08dde13fb6ad
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|14060799003|376014|82310400026|36860700013|35042699022|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?NVFTUFdFVVR0OEFwbndISWxjS0xOY1ovbWFSNVB2SmlYb2lGUWlWYm1wbmpr?=
 =?utf-8?B?SkVWRzduQk5hb1ZueW8ra0VFc2hzZkdub3RWVkt5UmhtZjN2M1RKTDRxU2pJ?=
 =?utf-8?B?Q1JIRWNDSFFoMmhXd21ZMlZIRGdmYklqWTJDNnRMQ2dmQ0ZaOFpYZXZBZ0lk?=
 =?utf-8?B?NkFhOFkrdlJIZ2lxRmVtci8ySFRObDFuQVN4bEZ2MzlWSjBiM0tRODl5WUQz?=
 =?utf-8?B?ZkVub051L2VmM3g4R2ZEWFh4STBnLzlhcHFETHgrV1FGVE91dnA2TFd3Yjdl?=
 =?utf-8?B?dlFGdmpidHVreEZEL1JyWmlUdmVVSHlEMjFVTjZ3R29NMUkwb3VyMjlkOEs5?=
 =?utf-8?B?K3p5Q082STBwWm5wcVJQdjMzZ2E1bTNXZjlwT1lpQ3hKb2ZQQXVna1B5VGZM?=
 =?utf-8?B?S21QenNlYWtIL3RZaXM1QmFEL1VTeWcvb2pVeEZlN0srRCs3NlFqcVNiWlFT?=
 =?utf-8?B?NXpDVi9MVVFkcWprRkVmKzY1VEFzc256eURuZ01MYTYvZ2lqZjVTQWlyZ2JN?=
 =?utf-8?B?YitFVDA4UUlPNDZPN0tpcWFEdy9uZUtsVWZwQmJOU0xiMDd4NXlWR0taUFRp?=
 =?utf-8?B?NEFxVDYydEptaGVLVlZ2bVM4S0llemc2OWRTbHp4S2Q3NUJWR0EwMnhpUGt1?=
 =?utf-8?B?cWozd0pHWjRMaytETyt1eEc3cTI1RnpaZDBiN3NOSFJBWGVsWFAxRjZNcjdE?=
 =?utf-8?B?emM5cnl0c3hsVi9BS1FPbzBLS0FLV3lCOERCMmsvdVd5V045TmRiTVdWRks3?=
 =?utf-8?B?c1l1MUx0UkxvU1ArWVhzY1lWSkFCeTRWMm5LQWk4dFZobmRtVno1a0puOWpJ?=
 =?utf-8?B?MUdRWGlGWVRTeEk2RmQ4bFN4akZYWW5mL2Vna3RZM0pocE4wU3hNRUZRK1du?=
 =?utf-8?B?QmJyNTdpQThCUWhteE5YUUFxakhSY3QzTTNFZ09NU2FtVVJwc1phNzFoMURj?=
 =?utf-8?B?YXFSQ2xmN2dTYzFibkdyb1lXMmpPdFZtWUNjUlg1UU1NTllKZ0FLNHM5dVFK?=
 =?utf-8?B?OWtidnFuNTZUSVE0WDFFclNDV1Vuendpcm5WNHdLdFFNdHVJeFpNcFdaWXpT?=
 =?utf-8?B?RklNZFpZU1JSU05tSjlVNFpkL2IwRW5MQ3ZUbGQySy8xN0FNeFJGeExZL0lP?=
 =?utf-8?B?bitEc1dkY2xaZjJHcVNjQzR1NjJCRThqQzR3TlFMUjVVWkxwamRKUVVQNE9x?=
 =?utf-8?B?RUdoTnJIbC9GcDJ5NGlZNFFPQlVLSFR5dklSTndjNWp5UjRLcm5hVzBoN3dx?=
 =?utf-8?B?QnRrenAwck9YMWxKV0ltZURSeTllTXlvR0dEaEdQMldKczRVdHBvQVdVUUZj?=
 =?utf-8?B?UGlDRjdFWURnNU9yZUlyRExQWEcwWmV0dVhZWnhrVUhORlJ1TXIvVmw0M2ph?=
 =?utf-8?B?K3p0UTNna2ZOOXp4aGdWbjFxdFBHWXpHRVVWbExTTXlpSjZjRmZsRmRrdmIx?=
 =?utf-8?B?QS9YbFhiTy9xbGEzbGVFTWg2UkkrekN2WnptZWdDYmhNTWhJS3ZHcUFUSmxs?=
 =?utf-8?B?bmFJU2lRb3VGNk9YSXBGTWdFUkFZTkFXYmExanQ0WWRjdHMxeWFlbG52NmFG?=
 =?utf-8?B?cHJ1WHpjU1NiYS9zN05hMWprUlZnZTZWeVRtM3VpdS9CZW5yOE1MSFJhZ3lP?=
 =?utf-8?B?S0d5azh1VTFlQkg1NFBKaE1aK3prVURQTlZZMUJ3UDgzRlhMcUMxcVNZK3BZ?=
 =?utf-8?B?RGlGZXZWT3JJNklIdCtVVnpQTFFJQzBFajFodEJSdHhzZjBwZ2NJb2J2SDky?=
 =?utf-8?B?WDJQaTFJRmdvY0hQTUhkK1FXQTV4WnhIekRiMlRDQllMbjdGVS9GSlBlek9L?=
 =?utf-8?B?UzdFNWRzMDBUREs5VWJSYW9yRzJIR3VONDN6RmxPZ045Y09CZmlBa3dHZGgx?=
 =?utf-8?B?YUp5cDR1MS9mMXpERlp2RmZiYjZGRVFSWEo2bUxyOEppZjZ2bCtNSG92U25J?=
 =?utf-8?B?QU5iUFpqUzhwSEkveFNRSitQYlB1SzlTeXh0cUtmWjNUZzdrbm9jZ0JhT2NZ?=
 =?utf-8?B?bVZaNGV0OXoxdVR6UjVqYml4ZnoxWVdLYnRTMDF6WFhJSUorQXkxaVpURmNH?=
 =?utf-8?Q?fMxX3q?=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(14060799003)(376014)(82310400026)(36860700013)(35042699022)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Aug 2025 05:50:24.4872
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 1cd0e0cc-e32b-4fdf-ae52-08dde13fca11
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AMS0EPF00000194.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI0PR08MB10972
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-Rspamd-Queue-Id: 7CCE74000B
X-Stat-Signature: 13i5n3rtd8bfqnr5fgos1pz8yefsbatx
X-HE-Tag: 1755841830-736181
X-HE-Meta: U2FsdGVkX19bD4rpF2lsfD7ZU66mUunjpJhnOXxK5i16dn/dozcTvlWz94QJmAz+LEaEIRwW5//GRmknfuQzQ91ygXXd7yt9CrfQfrZDHmVMTgcsKSwzmoGHkS/wn1UF3Oj1C/j/ARLy24dS/fklXwByMUIZ+37ybP63Wot+n4qmXWlM5WWdKHQhQrJblhn+PY7+9ER/i4PQ7nvdtU3OdbKga69XwsOoN0OEBiQ762mEkGhtyvs2huBPpkA2tKjSp9fLfamEmtn77fCP0DU23JPdnMwjmWU4Wp5BUu3IV1GuQ3Of+XtxTh84q8hP7xpRivNWviU8Drpn39eEjwRZeFQF2qgCphcieJAHqo6A+/ZteivIq83pdPkU/IWxSvPY6ujLwuuYRIUyPBR01VTgalDV4499MhmVw1L8gNFmGIiFHyvSuWdgWqzTO+Pou+hqDN+iz0OH8hOlBoBJ2kHtznyeJe4USDmPGSOI5K6QSU1dAd8TKdmrMOEtzDoUoNATJgoEKGbXp6qbNoQ7dkOhcH2n7Pz0as8xCNin0NL5ZjY+jr+LuWKgzetSzQyDECjOwEcFxLY49qo10PPEyfsEz+hkrNrWUWtoEJ50jKIZDbiugZnt0nJFu83RumIeVwGgzvv5p442qIfFdK9a3skRkEAUhu6aMQImgCyDw1Y6ENpYV2OeGaULwROhW2YdWTeH5eyup+y7CHgwxqAl5kPuXEiquM51Qju8JN+o9TtQcD8UnseXstwijdd9Sjz4fnyZ55YJGJIrS9bZ0kb21n7zooBA6udQOXZDAeiLnWNaKe6otWm7O+vzBzkAIwYBq/J1SeMHoZSvtmNRWxeO9/Ee7Wbt90bzZ50/tKCJN2VUW+FKKb2DIbTBJdG7Ubqln+1x1SWaGi05ugFXgtiY4c5Zm1cvh7MtkxL6FzPFdiWPtbuD6AHo44ukcOMCtpE07w7tSdsRlImbyqJANfyP1WW
 A4IgFzxJ
 Qdp1AHMyX3kzabgtGf6Kbxhj+mQxl5GdctCBWgTPmqxrRiGnBaNvbSmDRy6QR+frs39zLg7G6WCS1bdljmf2qbDnV4IdVPoTb8e6fHhZvRcNWFc8QbykSUSmbR86OQjutrZLrt8VvX2tHsxyGX1R1O2ozzAf9dUQ4lT8q2blTNWJNqfeLH0pOK1OLuW4PCVTKpgq7asWX9oqiWTGEjcVAa5pravGtCYzlJrzXIQHNDpc7lnrmGdiH0345KzTeIqqomO9fUewni5pfSdpc0EsfjAvndnKxPeHJfs8IsFKH6ZpA+vlzX0P5Ih9IfuR62pllCuhm62hLmeO+l14yAUIKY9lP2UWy9N+HiFramrp85QDZNZ8oa9baPK6bXMaa2LAh4qoPS9eHQfhzQnoazBMGkKHqjWk0l++IIm/vJl3o7SLgCMJalY5aWDLlS9IIrAYXf8YoB5Dai3mW8mUpozZg9z65aAor4GswJAK2nZReqAwVBj3Bj4lKCOaMIFOgYX+GJPrFOaMQgmsdN3pDfYkeYRfeQJMLGfS/Svzh+6rCvmIfAE8SExncAd1Us0y51RHr3LhmscSHDFwq0t9Sv3rfyIFeUNw/IW2vKuRoaCYMKj+GgCiXIdQUKq3eIjWzZ2O3AHdhuLOLhSOE7Kvuzst7rNjCd2g2SURpUdwC18wsBjzpNy9wC5klWWeXUqHpDtKjsXPN/PXWSbWOrB1cgITIJIw6L6Y8EzkmU2bvv9MSZKuj4rATm6tGivupjA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 22/08/25 8:27 am, Wei Yang wrote:
> In general, khugepaged_scan_mm_slot() iterates khugepaged_scan.mm_head li=
st
> to get a mm_struct for collapse memory.
>
> Use list_xxx() helper would be more obvious to the list iteration
> operation.
>
> No functional change.
>
> Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
> ---
>

LGTM

Reviewed-by: Dev Jain <dev.jain@arm.com>

IMPORTANT NOTICE: The contents of this email and any attachments are confid=
ential and may also be privileged. If you are not the intended recipient, p=
lease notify the sender immediately and do not disclose the contents to any=
 other person, use it for any purpose, or store or copy the information in =
any medium. Thank you.

