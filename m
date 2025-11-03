Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5CE65CCFA04
	for <linux-mm@archiver.kernel.org>; Mon,  3 Nov 2025 10:08:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 54F348E004F; Mon,  3 Nov 2025 05:08:03 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5276C8E002A; Mon,  3 Nov 2025 05:08:03 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3EE7A8E004F; Mon,  3 Nov 2025 05:08:03 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 2A3188E002A
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 05:08:03 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id A3CB14AF30
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 10:08:02 +0000 (UTC)
X-FDA: 84068870004.29.96419A6
Received: from DB3PR0202CU003.outbound.protection.outlook.com (mail-northeuropeazon11010059.outbound.protection.outlook.com [52.101.84.59])
	by imf05.hostedemail.com (Postfix) with ESMTP id A4D29100009
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 10:07:58 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=arm.com header.s=selector1 header.b=ijkJu0vC;
	dkim=pass header.d=arm.com header.s=selector1 header.b=ijkJu0vC;
	spf=pass (imf05.hostedemail.com: domain of Ryan.Roberts@arm.com designates 52.101.84.59 as permitted sender) smtp.mailfrom=Ryan.Roberts@arm.com;
	dmarc=pass (policy=none) header.from=arm.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=2")
ARC-Message-Signature: i=3; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762164479;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IBLVrFb2rad9CrbPD4dhOKvd6Z1jPlHjPNIYyJxww3c=;
	b=sMFZ8LhbZfSQsZrI8CsQ0OCC3zLxb549wuxiVc/pq0qnj2VRZNNi5G3rHH8AUKxEOFJDAZ
	92pAVaw7ghdhhECaImcfNlAkuX3JBX4iYZAndb3vNJcQHai2XZft1jpLRyOjJ9REHTz7a1
	68HezHIUb58+/X05a1s8f5MrMBfQzTA=
ARC-Authentication-Results: i=3;
	imf05.hostedemail.com;
	dkim=pass header.d=arm.com header.s=selector1 header.b=ijkJu0vC;
	dkim=pass header.d=arm.com header.s=selector1 header.b=ijkJu0vC;
	spf=pass (imf05.hostedemail.com: domain of Ryan.Roberts@arm.com designates 52.101.84.59 as permitted sender) smtp.mailfrom=Ryan.Roberts@arm.com;
	dmarc=pass (policy=none) header.from=arm.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=2")
ARC-Seal: i=3; s=arc-20220608; d=hostedemail.com; t=1762164479; a=rsa-sha256;
	cv=pass;
	b=i66orZgR5DvJBKwxtdZpGeMUeBUaKtySNiLgFYnFWfJUqxj1dLZmZL+qTR280ZwwNaqbJk
	B6RCYbI3V5CHp7pGARHP3NCYFSzt0Elw54VX0aUFswowKjDSynh9TKV2YtcxBVmQWsJrTe
	AyNnxN9XY+nq5Ww4EiqawDRNh0cGL9Q=
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=bhHOfCXrbZ6hNbFD+4WbnKsHKJQUjmEl8cpmURRCOFMEBGwtdpSbKRyexS6KSdCXrWgKCwXztIUv1+0KY4OjsNsbty04imy9/h4Ptc2vXVdELCTM1lB2IVLHHttoblfIctgvVX0TELNBUq1cuLwJyHTeLmIGYE62JrSOlAPr3LG/RrqOkMDUXTUuxF6fDPr/X+QKRLYgqamSI/XPQn1fzc9vo5ml9P9fAH0O+gN8EIs27eE9vAYwAKEY/yQIAQp/8rcHkMWiVkMthW8XvGkwbcvh9I0XibtWxQeK6xsC95/0egwtedN4iUnIjuprMd9TsPHG079nplaEBEGEJNqlIg==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IBLVrFb2rad9CrbPD4dhOKvd6Z1jPlHjPNIYyJxww3c=;
 b=xZQt4vL+rEtYOfWzJHbKP7Wc4woyKanlOC1ec97ctoKmx4eshmBl+yc3qml2hUGerCbsltC9OWTEzAijdrRBlUnAEo2EoHFZYGiR6MPimevbtjImap6OorQUpazJMuQNeF5HZhXoe/l+8SF6K3lXf1ULesvwIIivzx7EaVmDTrHvpkMxuNceeC+XT7hjS8iTQ044lTIXGFB7zQsvW01XN9SIIVB7Qm4E1zhVw8W2s2U+vQfXo98+B9Q8VMT5+Qn8T+Vv3W+7Vnl+YNHHGn4C2C+ehs0ECbgjXP9AoxQaW4Bj/PxTcjdwcj9Wm3BMqyGCVy5Z9TAo9MkYLVSBp04QnA==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=os.amperecomputing.com smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IBLVrFb2rad9CrbPD4dhOKvd6Z1jPlHjPNIYyJxww3c=;
 b=ijkJu0vCjRqkmMXM8lHbQg6Xq+bxIUOKkIfwNVe8PSvr79Kd0JrhEuy0Nj04ybQozxEaha6vLvwZdFpWKWEbbi3iC1yQ4K2JL3Bh7fdIXnb5Ed+clH5budFxWN28wBINXtTXSVrE7iTVKHJ7a+8em2SUS6CFsjtDVzRnYof8WNs=
Received: from AS4P192CA0001.EURP192.PROD.OUTLOOK.COM (2603:10a6:20b:5da::15)
 by VE1PR08MB5872.eurprd08.prod.outlook.com (2603:10a6:800:1aa::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9275.16; Mon, 3 Nov
 2025 10:07:54 +0000
Received: from AM3PEPF00009B9D.eurprd04.prod.outlook.com
 (2603:10a6:20b:5da:cafe::60) by AS4P192CA0001.outlook.office365.com
 (2603:10a6:20b:5da::15) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9275.16 via Frontend Transport; Mon,
 3 Nov 2025 10:07:56 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AM3PEPF00009B9D.mail.protection.outlook.com (10.167.16.22) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9298.6
 via Frontend Transport; Mon, 3 Nov 2025 10:07:52 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=T7/SJmvKHblW/u8ibUz42UxNUPujfR6Vagwy5r+b9ULOFGXqT75Bx0aIs5iPo1B4I7YjQVgQi0NB5G53NAJF0RyaH9W4n/GLJ5S4iVLHVOqoi/zuS+wRUaTgAq0/1QxnZT+pzgoj5YY72flnl7xItU6MLVyqrldCwkupQeIEbSTBXXoATn5/9rJXps3jySq9BFdAGNDD9cyd5+NBz5chZtEkQwXZws/XYXmAedawTUXzWfu/aQVhEImfdyaY85+TVPymCrMtLS1BpLTZE9Z56QVPhnSQg8m2L40PooJNhTFPVUNLdAxb5zZ1tlEDqnkeSVKbP1JRjOYNebWJM8d4mA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IBLVrFb2rad9CrbPD4dhOKvd6Z1jPlHjPNIYyJxww3c=;
 b=m/2TnusH8dLgwXiRx9R4oukuzlGQACCxFVN3n20TA+BntF1ovKZ9YDyv88vLXf1PtC+rpj3l1KlAAqJCMjQgeaJTRFt3FzGQKQ7YMCxDxZ+sDVODhIfjMZ5B0Huk/2xJCaR/LNy76LULS9d4vD3Ow+XCXpFCG0TX8ilF4IElm925juVuf8BMekYdAlhiReFg7HvKMb1Mk4GeJube+Ah87e7O4nh26PnyypzyWNq0+6RiSPyolS3HHIA0YwKOb5OyOwJqeXiFT/QPRYKa3thK0a/AV0mOscFxPUycOXiJyb1XStEt+hMqBrxQjKrOUfQWCEq2fVa5vwlsmd/VLwkqHQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IBLVrFb2rad9CrbPD4dhOKvd6Z1jPlHjPNIYyJxww3c=;
 b=ijkJu0vCjRqkmMXM8lHbQg6Xq+bxIUOKkIfwNVe8PSvr79Kd0JrhEuy0Nj04ybQozxEaha6vLvwZdFpWKWEbbi3iC1yQ4K2JL3Bh7fdIXnb5Ed+clH5budFxWN28wBINXtTXSVrE7iTVKHJ7a+8em2SUS6CFsjtDVzRnYof8WNs=
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
Received: from GVXPR08MB11445.eurprd08.prod.outlook.com
 (2603:10a6:150:2c0::19) by GV1PR08MB8011.eurprd08.prod.outlook.com
 (2603:10a6:150:99::10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9275.15; Mon, 3 Nov
 2025 10:07:15 +0000
Received: from GVXPR08MB11445.eurprd08.prod.outlook.com
 ([fe80::fa0f:733c:3b98:b13b]) by GVXPR08MB11445.eurprd08.prod.outlook.com
 ([fe80::fa0f:733c:3b98:b13b%7]) with mapi id 15.20.9275.013; Mon, 3 Nov 2025
 10:07:14 +0000
Message-ID: <cbabb814-3ca5-4213-9346-a7de28aac474@arm.com>
Date: Mon, 3 Nov 2025 10:07:12 +0000
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 3/5] arm64: mm: support large block mapping when
 rodata=full
Content-Language: en-GB
To: Yang Shi <yang@os.amperecomputing.com>, Guenter Roeck <linux@roeck-us.net>
Cc: catalin.marinas@arm.com, will@kernel.org, akpm@linux-foundation.org,
 david@redhat.com, lorenzo.stoakes@oracle.com, ardb@kernel.org,
 dev.jain@arm.com, scott@os.amperecomputing.com, cl@gentwo.org,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, nd@arm.com
References: <20250917190323.3828347-1-yang@os.amperecomputing.com>
 <20250917190323.3828347-4-yang@os.amperecomputing.com>
 <f24b9032-0ec9-47b1-8b95-c0eeac7a31c5@roeck-us.net>
 <933a2eff-1e06-451e-9994-757d66f4b985@arm.com>
 <bee6b93d-aa2e-4335-9801-89f02eb3eccc@arm.com>
 <85e50475-7d2c-49df-924e-90e0b915a4d3@os.amperecomputing.com>
From: Ryan Roberts <ryan.roberts@arm.com>
In-Reply-To: <85e50475-7d2c-49df-924e-90e0b915a4d3@os.amperecomputing.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: LO4P123CA0311.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:197::10) To GVXPR08MB11445.eurprd08.prod.outlook.com
 (2603:10a6:150:2c0::19)
MIME-Version: 1.0
X-MS-TrafficTypeDiagnostic:
	GVXPR08MB11445:EE_|GV1PR08MB8011:EE_|AM3PEPF00009B9D:EE_|VE1PR08MB5872:EE_
X-MS-Office365-Filtering-Correlation-Id: 3cc5eb81-50a4-45f9-b694-08de1ac0d9f4
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|376014|7416014|366016|1800799024;
X-Microsoft-Antispam-Message-Info-Original:
 =?utf-8?B?YWV6YXl3WTVKVUVNTWxpQnFsaW93bmIvOTh2bzRDV1ZEOTRoR3R1aGdPc2dK?=
 =?utf-8?B?MkJqOFpwemRYbXp5Z212djE5OE90OWdIRVhIVEM2WVQ0TTQvSzlCNDRYc3Bi?=
 =?utf-8?B?ZXMrRjhCMHBVa0N1bVh1WWhEcVRZWk0zRkxVZ2dhQU9ib1FBVEJKRXM4cUV6?=
 =?utf-8?B?ZFV6R0xjajR0dnR5cUhnUW9pdkJuYXl0K1JSczJ3RTE2R0ZrTGVwOWJDQlF1?=
 =?utf-8?B?OGhFTmZoMXpHK1I1UGJESnBEdEQ5UW9pS1I4aGowelhVT2Y2Mlo5Q2pzY0lz?=
 =?utf-8?B?ZWhhQ0J2RGdiSDRiaUlMUllVRUdjTFQ3bnJCNGdvcmZOTGJ4NER1dkRNUzlj?=
 =?utf-8?B?c2tqT21LeXlWTkUyd3VHZEJEWE15TVo2M29tclVPZDB4TWhIem5Fd0lXTE1w?=
 =?utf-8?B?TDFFSjZLTVRpU1hyQk9iVW5peE5sUENEbTd3MGpNbmhuTWYxTFBlTXk2bFRU?=
 =?utf-8?B?L3BmeFJUTTBxSUFVS0hWZlZXMnJiL2pWSFdUMGZUVXJJSWpUVWVWOHN5UWsr?=
 =?utf-8?B?NFFUR0lHWjVFeTFaY2NSK0JpR0MyWG5YM0V0SjluSmFoMUN3OGR2VERGNWp1?=
 =?utf-8?B?T0pDaDVwNEZuM3RJZ0Q1NlBmaDlaR2JkSERKWVVTSHF5eUVveVJoNDBkcUhq?=
 =?utf-8?B?N2VMNUViMzdZVXloMWdxcGZ0MnhZUnk3NnFyM1RRWFJJSVpaTHVraHI0YWUy?=
 =?utf-8?B?UTllclJ4TlVaeC9RSEgxYjRLTFFhQ0psNDB2cWJWTlJuVWRtVlFSczR4MXVZ?=
 =?utf-8?B?Nmg0RGNzbEc3Y0Y0aGJXNVQxZENydmRZci9Fa2RFR3QzSE03WGRteDd0Y3dw?=
 =?utf-8?B?NkxBYnN1Y1p4QXZxYnl4RVBFVE1IYzE3VS9jM3RIVGM4K3I2WUZrNWhiN05S?=
 =?utf-8?B?UHE1cWFLVFBGdDVVem5vcVJ3T2lESk41aGtJaCtMUTd4b29WZklqaXZLaGNK?=
 =?utf-8?B?VysraGp4aElHeG9lNUdYcnEwbkFhQlpITUhDTmJOS3ZaUDM0VFYxaHhlSEg2?=
 =?utf-8?B?aVN3ZWtwWU9HbHdKRG5jazJMUU1oN0t1WXQxRk13YzhBOXdXOEhjQ1Y4Q0tS?=
 =?utf-8?B?RU9MS0tkcktpSmNwMVhzZGFDVnl2UnJrRm9VUS9DN2ZLK0pLdTJiTVZGd0o2?=
 =?utf-8?B?TXpaZzExenNBd0FsMFpBTWFMUGVDSkxFbHpLTDE4d1JYaS9EZUhyam5MWkV5?=
 =?utf-8?B?UWtKT0hudjhwcVRsa0JYaXg1eEw2dGFSc2s4VUJrSyt0T0lNekJlQ24ybUdY?=
 =?utf-8?B?Nzl4WkFLSlpGaEZOcG01eU16dlhycTBXOTRTMHN0NjJ5L0RPSWVMUVdRa3lM?=
 =?utf-8?B?amwzTDlaK1gva1BUMWF1R254UWtDM0kzVEJ2cG1EVmc0L2xrRHRPWUtVMytP?=
 =?utf-8?B?ZjI1MkJPQURvWE9HMHBUd1c2cjVDRkxKVW12eVBjMG1aL243clg0Z25XMTYy?=
 =?utf-8?B?SGdwQVdsNW5LbkVhaC9lV0o5aVZ1NDFKV3h6L0pWdG1rY256VFgvZGhha2xS?=
 =?utf-8?B?cncwdjY2alpkN29penRnTE5JWmtZTWp0T2tpdElaK3kwVEFIaXVxTjlwR0Yr?=
 =?utf-8?B?UkQrUUxYaFdKUGZwUG05QXBNSFR2eTRab29RK01hRVJuakt0NDlSancrbTVS?=
 =?utf-8?B?NHZ3VGpvQlhZR2s3R2xaN2xNcjlqK0dOYS9uMlJKZFpoMWFlT2gzRnJjaXpH?=
 =?utf-8?B?K0JCVERNTWx5ZkhVSEtsOVQ4NWgrOUhlUHdPajhpVzJyQzZyendEZGZmZFpX?=
 =?utf-8?B?Y0pZcEJFT2krRm5GdnVhcEc4cGh1NjBocjd2OFkraUZUS2dPb2wzT1ZPQWx1?=
 =?utf-8?B?S3oveE5vK1A5V2d4bHlReWxQWEtxYWZia2JKQlFSVHp4QlI3N081MFRpL1ZP?=
 =?utf-8?B?WklIVTVyOXVnNkZLZnhNK2dUbmN2N3JoSFVGekl2L0tjbVE9PQ==?=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GVXPR08MB11445.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GV1PR08MB8011
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AM3PEPF00009B9D.eurprd04.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	1039f839-8125-4d27-33fc-08de1ac0c2f1
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|1800799024|35042699022|14060799003|7416014|82310400026|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?SWtNNzlKMDhmWGVKZDdaMGc0bjNmOTRnWU95TUUwK2RaN1dwc2prSDVkTFU5?=
 =?utf-8?B?ZFh1MXFseW9RNk1DcFA3c2czQ1RLWnorQXRXeTV6bTU0Ulp6RHJhR2F2WTNi?=
 =?utf-8?B?QTYzQXpna3JCaGpoZElVdDFrWXZxUC9neWx0dTFBdjlGK0JUMHFXWk11L3Vi?=
 =?utf-8?B?LzRUMnNQV2ora00rREkydVJGZDZZYWpIaldUN2ErM1lYYXE2c1d5WUhNNjBN?=
 =?utf-8?B?dUhjSnZ1QUlzM0dQS0gxM3BlYUhldlU5c0lSM3IyU1JnbzB0eDJzNWV4NjBM?=
 =?utf-8?B?Mnc2ZmQySVlOUXVQQ2N1Q3NGL08zbjJ5TWkwRXVJVlltOVJMK2cyZFpvN25C?=
 =?utf-8?B?VmRhckxjekd2aTY0b25qOVJ1MHppNkhVM3ovZGhMaTBhTUpzOERTak1Bb3M5?=
 =?utf-8?B?ZnF6aVgwZ3lNd0J2U2FFNXZ1Qk9RVVRhTkZtN0RpZloxc1pqckx5enBDQ1p5?=
 =?utf-8?B?QmVtYmlFWnhSaytwN0NjTUx3OW16dHAyVjZrR1Mwano5S3hvc1B2YndZenJz?=
 =?utf-8?B?NHZnd05taDgyNGpoMHVIbWF5TDgzSkt1aHJ5bG1nREVBNEd5a21jSVJ5ZjJW?=
 =?utf-8?B?UVhQenBSSnZPVnJMVjc3VGRxMXZMOWpzekNKcEVXSUxKb01OcGVCT3NYV3VU?=
 =?utf-8?B?dTdmMVNtUW9XUkI5Q3hqMC9RMDVvL1JnNTc2YU4zSmJ5ZEFvZ2ZveGozMTNU?=
 =?utf-8?B?ei92MGNsVkRUbDhuWWRyYTY1alFSWUpoMU9KbFZ3U0xUVFFvcXFPTHAzK3hs?=
 =?utf-8?B?YjBVRjdCZXZDUmozUmtLNmNJNjNOK3RQUWRZV1hJVXl2aTVVVndGTWw4ZEJn?=
 =?utf-8?B?OEtNRDJGNGZ3ZThvbWNNOC9JWUVCT2xoaHQvaElvNTFJemdaVWg5ZlNlYlda?=
 =?utf-8?B?N2p2ZklpalRKMzBLMDF2cGt3RFNIa0x2Ni93cGQrMjFBV0JaYTVsalpQVlRv?=
 =?utf-8?B?NVpYWGJpTDIyOXVxTDRJTWdFRWJhWXpHNjNDVUIxUkJmU1JZeXp4aDA5Y2V1?=
 =?utf-8?B?YWhLcURGTEg3ZWxqUUdlWWpEOHNwOUYzRXpsb3BQNFVRYzhnbFdBRTBWSFVR?=
 =?utf-8?B?MmhnbzFuRHZiRmNZbUtYbnRocHhlekV3WkxSZDRGMWFOWUlLRFVBUUJPKzh3?=
 =?utf-8?B?TGtlWGRuN01SZWJlNHNCZk0rWDN2QmNUUHdGb25YS0tGeG04U2xDNWM0V0gr?=
 =?utf-8?B?VmpleXVMU1RzUkI2cWxOdjlvSVc3d2JOQyszdWp4RzJRODZ3VEVEMWF4U2Nv?=
 =?utf-8?B?WXptdEcwN0hadldHZ3AvejlPd3g4azVuYy9vSVhEcUdlYjNkbHRNdjFsblZp?=
 =?utf-8?B?ODN0Q205aUZrc0VQWkVwWEllaDIzQ0NyRGJMeXVBYndxc1BzdlNZdG10YVdq?=
 =?utf-8?B?VGlkS3p4NnUvVkRXUXN1RlRyTWduVEY2d29KbVhPQ3hocGwwRlMvWGQ4eldq?=
 =?utf-8?B?bVd6U3lyUVhWUFhzRm1vdmExV2pPdDN2azc2NXlVMDlvZU1PcTdmdzhET2Nw?=
 =?utf-8?B?aUJZcUdrVlZSS3BrZUlHRk9tZU5MU1hVZGxlQ3U5QkVRczVVRmdhVWVTL1Ni?=
 =?utf-8?B?ZHo5YlZjWTBOZnV5MVJsWGJqYU1UOVBTZm1Pb3R0WUpRWnhURkpUVnVQY3hJ?=
 =?utf-8?B?UjNmT2x4NlhhRW5ZRDlpNzlXS3kzTmxRRzRNVTgxVklLdm5Nb29ia1B5d3N0?=
 =?utf-8?B?alliWG94SVpxUE03V0J1T2g0TFNiZ01NcU4rTTZUZ0pHUUh5YWw4RVl6RVh6?=
 =?utf-8?B?a2wzVm9JTHUrbHg1N0JnbjMzMkFXV0lWKzhNdGNicm0wWUkvSkVwS0cvOHo1?=
 =?utf-8?B?N0tEandCcDk5UURPQ3drRGVaR2F6VDdaanZzK2hpOFdRNVlsRUFoc2VGUVZC?=
 =?utf-8?B?eVVjaUxpaXY2UDRWMXgxU1l6dVpibFZUZnkraE9LRkdWeUF1T3M3Q1BtSkh5?=
 =?utf-8?B?d1l6amc0aS8wWUwwQkVaeVlSbE9xOTV1cUtLc21YSmluWWhOSUwvenltQkFO?=
 =?utf-8?B?aWRvT2w2T1lkOWlnb2FpQW1maEtoRmpvc1B3VnM4VFBzWTZldVZDc1RieW5T?=
 =?utf-8?Q?prDf7n?=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(1800799024)(35042699022)(14060799003)(7416014)(82310400026)(376014);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Nov 2025 10:07:52.4854
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 3cc5eb81-50a4-45f9-b694-08de1ac0d9f4
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AM3PEPF00009B9D.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR08MB5872
X-Rspamd-Queue-Id: A4D29100009
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: osffs5iu88yhgwfei48tzmar95ogtn69
X-HE-Tag: 1762164478-67646
X-HE-Meta: U2FsdGVkX19Dp7NLWA97l//s6pPD8EyfQ5HWktKvafurIp/N0GhJS+ZzW6JTF4GI0uE40wyHpl9mcc/HoB/FEFVYyGOQILSAzWzW+Z6jMJIcr8fqOFIY+8lYuWitFvYlYrmHjby1JDKNSS1fdyoZPs0K9jKhAOnhiDb5bQZXP9eapCUcW+k8lbXBx27kbsxxZ6KjYxbZTY08KcwChWuZckDy+Q0N+z5f+eJCB8LqloWjNR+XJAAskyDnp3dMt6JehJTFgK9BQKUCRI5Gid5kJejLVsiAoK2k3wF1CKXHj3KnKFK5t31c8706yqmrcqoZ4zKjYM/fm5Ub7H0Sz+PycBH6OiaKN1RT2gK+CieHtYvGY+5dBtyRvtQigtuWQuwhVb3PwGZqusuOuTb54StaGM9fDDSSYRa77XkfFNiWypqYnJyX/ONcWfxKZ0y+Cjz3HcC7FTsgUDAbtO/1SMRlf1u8t1ZMAUCi0DtgPOCqU6kXOWyG0hIQKWJ04bSipjXbjkhg+LAhpiKF4iKNvHE5cNjWHIhvJoUVuZ9JMroBBERMWPI/+8sxSPcH7gPMnT48qkf22m2cOF2amMfe+tGvOuU1kW866koJT9ZVvwdx0y69G5Nu3KhR3FVTqIop5EOoJ6dzCdsOze0w24Z7ydRkvxqVyHLCT9F3YEmkDWsdwoa3NJLoChIWj3J4Dh7HzpMo3WNWusj/NQert5ciCiY1zENrllB4CUi3Zpvns24fbU71fvDSLryeIsrZkl9OubTg+2NX/lKjkN5/eQAVI0Jsp9yzyHp+tmfeiMVLMyEb23u+Woc4P5x/XwDCZD2aW+ovNa2ZYU3w0CfiSaNfFnHVeARPu8/pe3gmUh1Be0RJ02QknwEkeMaH7jLensWRfWYxIxpde7/6tmZuIcj4DFof+dDGijmCZnhXVYvZ3lBJVFO+Wc886j6yVpYzpCQhc9R+bwc9QdA0mtVUULG7O6W
 /S6+QPpF
 Tt7JyMzj7rTdJlWw7Ym26Dsoqf41tnXs9NrceiAOcY8sab45ptbdANwr4c6RFa+rInN5sLvypYj8kFTE1YfQAe8oOpcstmbsxXh9TJg0CiEYkR62q3bOAqF79LTifrpYO5YKHgmhnInJICDpuFKYUHKQuVBkVNdGnmbLuLGawJlvfffH69T/Zn/2vuYMx1+5p44OJEQ9TBiNK61L61Tb+4AktGECn36kHgnJamWRNYz3C+3cc6HWsB9viglk6pkFZ3TQSx1hVAvRfd8C9FG+0hI/2nDKQRp97b3FRFIh+ULLrujVkhnvAA1VLPi2mK7S7mcbiWXfOpUj8dAOy4F3APSgc52frt/+9eEKG2+6u0ep9n79a87nQSiMnjvI2b2h90reJWFDB+OqDWbMK8V9vtp9+u+kcmD1UnaU8RJup9CX4Oc8K9quu24QSzavEe/2DNLg9mce0BCU1sUm5zm1my80OraeaiIJFfJYsboYkWLFRfrSvJ34vQo6ex1qOm9rKTUeLguGwaQrVC54br9yHkWh2Xa3qlaD0BenKVTVbcf0HnnauR5EEZO9DCvXsHM8tVVUNIydv6IMFkQEodY571IelWCNKwrscKuJo2/biuvd4qmOod43Jx/SywFdxLU1vszHLjXYZfUvgtCmjGeSk1x9xDHTRZaAvsEV4uY1pKPmk1L6mZ/HhPqbpSA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 03/11/2025 00:47, Yang Shi wrote:
> 
> 

[...]

>> @@ -723,6 +733,16 @@ int split_kernel_leaf_mapping(unsigned long start,
>> unsigned long end)
>>       if (!system_supports_bbml2_noabort())
>>           return 0;
>>   +    /*
>> +     * If the region is within a pte-mapped area, there is no need to try to
>> +     * split. Additionally, CONFIG_DEBUG_ALLOC and CONFIG_KFENCE may change
>> +     * permissions from softirq context so for those cases (which are always
>> +     * pte-mapped), we must not go any further because taking the mutex
>> +     * below may sleep.
>> +     */
>> +    if (force_pte_mapping() || is_kfence_address((void *)start))
> 
> IIUC this may break kfence late init? The kfence_late_init() allocates pages
> from buddy allocator, then protects them (setting them to invalid). But the
> protection requires split page table, this check will prevent kernel from
> splitting page table because __kfence_pool is initialized before doing
> protection. So there is kind of circular dependency.

I hadn't considered late init. But I guess the requirement is that the kfence
pool needs to be pte mapped whenever kfence is enabled.

For early init; that requirement is clearly met since we pte map it in the arch
code. For late init, as far as I can tell, the memory is initially block mapped,
is allocarted from the buddy then every other page is protected via
kfence_init_pool() from kfence_init_pool(). This will have the effect of
splitting every page in the pool to pte mappings (as long as your suggested fix
below is applied).

It all feels a bit accidental though.

> 
> The below fix may work?
> 
> if (force_pte_mapping() || (READ_ONCE(kfence_enabled) && is_kfence_address((void
> *)start)))
> 
> The kfence_enabled won't be set until protection is done. So if it is set, we
> know kfence address must be mapped by PTE.

I think it will work, but it feels a bit hacky, and kfence_enabled is currently
static in core.c.

I wonder if it would be preferable to explicitly do the pte mapping in
arch_kfence_init_pool()? It looks like that's how x86 does it...

> 
> Thanks,
> Yang
> 
> 
> 
> 
> 
>> +        return 0;
>> +
>>       /*
>>        * Ensure start and end are at least page-aligned since this is the
>>        * finest granularity we can split to.
>> @@ -1009,16 +1029,6 @@ static inline void arm64_kfence_map_pool(phys_addr_t
>> kfence_pool, pgd_t *pgdp) {
>>     #endif /* CONFIG_KFENCE */
>>   -static inline bool force_pte_mapping(void)
>> -{
>> -    bool bbml2 = system_capabilities_finalized() ?
>> -        system_supports_bbml2_noabort() : cpu_supports_bbml2_noabort();
>> -
>> -    return (!bbml2 && (rodata_full || arm64_kfence_can_set_direct_map() ||
>> -               is_realm_world())) ||
>> -        debug_pagealloc_enabled();
>> -}
>> -
>>   static void __init map_mem(pgd_t *pgdp)
>>   {
>>       static const u64 direct_map_end = _PAGE_END(VA_BITS_MIN);
>> ---8<---
>>
>> Thanks,
>> Ryan
>>
>>> Yang Shi, Do you have any additional thoughts?
>>>
>>> Thanks,
>>> Ryan
>>>
>>>> Thanks,
>>>> Guenter
>>>>
>>>> ---
>>>> Example log:
>>>>
>>>> [    0.537499] BUG: sleeping function called from invalid context at kernel/
>>>> locking/mutex.c:580
>>>> [    0.537501] in_atomic(): 1, irqs_disabled(): 0, non_block: 0, pid: 1,
>>>> name: swapper/0
>>>> [    0.537502] preempt_count: 1, expected: 0
>>>> [    0.537504] 2 locks held by swapper/0/1:
>>>> [    0.537505]  #0: ffffb60b01211960 (sched_domains_mutex){+.+.}-{4:4}, at:
>>>> sched_domains_mutex_lock+0x24/0x38
>>>> [    0.537510]  #1: ffffb60b01595838 (rcu_read_lock){....}-{1:3}, at:
>>>> rcu_lock_acquire+0x0/0x40
>>>> [    0.537516] CPU: 0 UID: 0 PID: 1 Comm: swapper/0 Not tainted 6.18.0-dbg-
>>>> DEV #1 NONE
>>>> [    0.537517] Call trace:
>>>> [    0.537518]  show_stack+0x20/0x38 (C)
>>>> [    0.537520]  __dump_stack+0x28/0x38
>>>> [    0.537522]  dump_stack_lvl+0xac/0xf0
>>>> [    0.537525]  dump_stack+0x18/0x3c
>>>> [    0.537527]  __might_resched+0x248/0x2a0
>>>> [    0.537529]  __might_sleep+0x40/0x90
>>>> [    0.537531]  __mutex_lock_common+0x70/0x1818
>>>> [    0.537533]  mutex_lock_nested+0x34/0x48
>>>> [    0.537534]  split_kernel_leaf_mapping+0x74/0x1a0
>>>> [    0.537536]  update_range_prot+0x40/0x150
>>>> [    0.537537]  __change_memory_common+0x30/0x148
>>>> [    0.537538]  __kernel_map_pages+0x70/0x88
>>>> [    0.537540]  __free_frozen_pages+0x6e4/0x7b8
>>>> [    0.537542]  free_frozen_pages+0x1c/0x30
>>>> [    0.537544]  __free_slab+0xf0/0x168
>>>> [    0.537547]  free_slab+0x2c/0xf8
>>>> [    0.537549]  free_to_partial_list+0x4e0/0x620
>>>> [    0.537551]  __slab_free+0x228/0x250
>>>> [    0.537553]  kfree+0x3c4/0x4c0
>>>> [    0.537555]  destroy_sched_domain+0xf8/0x140
>>>> [    0.537557]  cpu_attach_domain+0x17c/0x610
>>>> [    0.537558]  build_sched_domains+0x15a4/0x1718
>>>> [    0.537560]  sched_init_domains+0xbc/0xf8
>>>> [    0.537561]  sched_init_smp+0x30/0x98
>>>> [    0.537562]  kernel_init_freeable+0x148/0x230
>>>> [    0.537564]  kernel_init+0x28/0x148
>>>> [    0.537566]  ret_from_fork+0x10/0x20
>>>> [    0.537569] =============================
>>>> [    0.537569] [ BUG: Invalid wait context ]
>>>> [    0.537571] 6.18.0-dbg-DEV #1 Tainted: G        W
>>>> [    0.537572] -----------------------------
>>>> [    0.537572] swapper/0/1 is trying to lock:
>>>> [    0.537573] ffffb60b011f3830 (pgtable_split_lock){+.+.}-{4:4}, at:
>>>> split_kernel_leaf_mapping+0x74/0x1a0
>>>> [    0.537576] other info that might help us debug this:
>>>> [    0.537577] context-{5:5}
>>>> [    0.537578] 2 locks held by swapper/0/1:
>>>> [    0.537579]  #0: ffffb60b01211960 (sched_domains_mutex){+.+.}-{4:4}, at:
>>>> sched_domains_mutex_lock+0x24/0x38
>>>> [    0.537582]  #1: ffffb60b01595838 (rcu_read_lock){....}-{1:3}, at:
>>>> rcu_lock_acquire+0x0/0x40
>>>> [    0.537585] stack backtrace:
>>>> [    0.537585] CPU: 0 UID: 0 PID: 1 Comm: swapper/0 Tainted: G       
>>>> W           6.18.0-dbg-DEV #1 NONE
>>>> [    0.537587] Tainted: [W]=WARN
>>>> [    0.537588] Call trace:
>>>> [    0.537589]  show_stack+0x20/0x38 (C)
>>>> [    0.537591]  __dump_stack+0x28/0x38
>>>> [    0.537593]  dump_stack_lvl+0xac/0xf0
>>>> [    0.537596]  dump_stack+0x18/0x3c
>>>> [    0.537598]  __lock_acquire+0x980/0x2a20
>>>> [    0.537600]  lock_acquire+0x124/0x2b8
>>>> [    0.537602]  __mutex_lock_common+0xd8/0x1818
>>>> [    0.537604]  mutex_lock_nested+0x34/0x48
>>>> [    0.537605]  split_kernel_leaf_mapping+0x74/0x1a0
>>>> [    0.537607]  update_range_prot+0x40/0x150
>>>> [    0.537608]  __change_memory_common+0x30/0x148
>>>> [    0.537609]  __kernel_map_pages+0x70/0x88
>>>> [    0.537610]  __free_frozen_pages+0x6e4/0x7b8
>>>> [    0.537613]  free_frozen_pages+0x1c/0x30
>>>> [    0.537615]  __free_slab+0xf0/0x168
>>>> [    0.537617]  free_slab+0x2c/0xf8
>>>> [    0.537619]  free_to_partial_list+0x4e0/0x620
>>>> [    0.537621]  __slab_free+0x228/0x250
>>>> [    0.537623]  kfree+0x3c4/0x4c0
>>>> [    0.537625]  destroy_sched_domain+0xf8/0x140
>>>> [    0.537627]  cpu_attach_domain+0x17c/0x610
>>>> [    0.537628]  build_sched_domains+0x15a4/0x1718
>>>> [    0.537630]  sched_init_domains+0xbc/0xf8
>>>> [    0.537631]  sched_init_smp+0x30/0x98
>>>> [    0.537632]  kernel_init_freeable+0x148/0x230
>>>> [    0.537633]  kernel_init+0x28/0x148
>>>> [    0.537635]  ret_from_fork+0x10/0x20
>>>>
>>>> ---
>>>> bisect:
>>>>
>>>> # bad: [3a8660878839faadb4f1a6dd72c3179c1df56787] Linux 6.18-rc1
>>>> # good: [e5f0a698b34ed76002dc5cff3804a61c80233a7a] Linux 6.17
>>>> git bisect start 'v6.18-rc1' 'v6.17'
>>>> # bad: [58809f614e0e3f4e12b489bddf680bfeb31c0a20] Merge tag 'drm-
>>>> next-2025-10-01' of https://gitlab.freedesktop.org/drm/kernel
>>>> git bisect bad 58809f614e0e3f4e12b489bddf680bfeb31c0a20
>>>> # bad: [a8253f807760e9c80eada9e5354e1240ccf325f9] Merge tag 'soc-
>>>> newsoc-6.18' of git://git.kernel.org/pub/scm/linux/kernel/git/soc/soc
>>>> git bisect bad a8253f807760e9c80eada9e5354e1240ccf325f9
>>>> # bad: [4b81e2eb9e4db8f6094c077d0c8b27c264901c1b] Merge tag 'timers-
>>>> vdso-2025-09-29' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip
>>>> git bisect bad 4b81e2eb9e4db8f6094c077d0c8b27c264901c1b
>>>> # bad: [f1004b2f19d7e9add9d707f64d9fcbc50f67921b] Merge tag 'm68k-for-v6.18-
>>>> tag1' of git://git.kernel.org/pub/scm/linux/kernel/git/geert/linux-m68k
>>>> git bisect bad f1004b2f19d7e9add9d707f64d9fcbc50f67921b
>>>> # good: [a9401710a5f5681abd2a6f21f9e76bc9f2e81891] Merge tag 'v6.18-rc-
>>>> part1-smb3-common' of git://git.samba.org/ksmbd
>>>> git bisect good a9401710a5f5681abd2a6f21f9e76bc9f2e81891
>>>> # good: [fe68bb2861808ed5c48d399bd7e670ab76829d55] Merge tag 'microblaze-
>>>> v6.18' of git://git.monstr.eu/linux-2.6-microblaze
>>>> git bisect good fe68bb2861808ed5c48d399bd7e670ab76829d55
>>>> # bad: [f2d64a22faeeecff385b4c91fab5fe036ab00162] Merge branch 'for-next/
>>>> perf' into for-next/core
>>>> git bisect bad f2d64a22faeeecff385b4c91fab5fe036ab00162
>>>> # good: [30f9386820cddbba59b48ae0670c3a1646dd440e] Merge branch 'for-next/
>>>> misc' into for-next/core
>>>> git bisect good 30f9386820cddbba59b48ae0670c3a1646dd440e
>>>> # good: [43de0ac332b815cf56dbdce63687de9acfd35d49] drivers/perf: hisi: Relax
>>>> the event ID check in the framework
>>>> git bisect good 43de0ac332b815cf56dbdce63687de9acfd35d49
>>>> # good: [5973a62efa34c80c9a4e5eac1fca6f6209b902af] arm64: map [_text,
>>>> _stext) virtual address range non-executable+read-only
>>>> git bisect good 5973a62efa34c80c9a4e5eac1fca6f6209b902af
>>>> # good: [b3abb08d6f628a76c36bf7da9508e1a67bf186a0] drivers/perf: hisi:
>>>> Refactor the event configuration of L3C PMU
>>>> git bisect good b3abb08d6f628a76c36bf7da9508e1a67bf186a0
>>>> # good: [6d2f913fda5683fbd4c3580262e10386c1263dfb] Documentation: hisi-pmu:
>>>> Add introduction to HiSilicon V3 PMU
>>>> git bisect good 6d2f913fda5683fbd4c3580262e10386c1263dfb
>>>> # good: [2084660ad288c998b6f0c885e266deb364f65fba] perf/dwc_pcie: Fix use of
>>>> uninitialized variable
>>>> git bisect good 2084660ad288c998b6f0c885e266deb364f65fba
>>>> # bad: [77dfca70baefcb988318a72fe69eb99f6dabbbb1] Merge branch 'for-next/mm'
>>>> into for-next/core
>>>> git bisect bad 77dfca70baefcb988318a72fe69eb99f6dabbbb1
>>>> # first bad commit: [77dfca70baefcb988318a72fe69eb99f6dabbbb1] Merge branch
>>>> 'for-next/mm' into for-next/core
>>>>
>>>> ---
>>>> bisect into branch:
>>>>
>>>> - git checkout -b testing 77dfca70baefcb988318a72fe69eb99f6dabbbb1
>>>> - git rebase 77dfca70baefcb988318a72fe69eb99f6dabbbb1~1
>>>>    [ fix minor conflict similar to the conflict resolution in 77dfca70baefc]
>>>> - git diff 77dfca70baefcb988318a72fe69eb99f6dabbbb1
>>>>    [ confirmed that there are no differences ]
>>>> - confirm that the problem is still seen at the tip of the rebase
>>>> - git bisect start HEAD 77dfca70baefcb988318a72fe69eb99f6dabbbb1~1
>>>> - run bisect
>>>>
>>>> Results:
>>>>
>>>> # bad: [47fc25df1ae3ae8412f1b812fb586c714d04a5e6] arm64: map [_text, _stext)
>>>> virtual address range non-executable+read-only
>>>> # good: [30f9386820cddbba59b48ae0670c3a1646dd440e] Merge branch 'for-next/
>>>> misc' into for-next/core
>>>> git bisect start 'HEAD' '77dfca70baefcb988318a72fe69eb99f6dabbbb1~1'
>>>> # good: [805491d19fc21271b5c27f4602f8f66b625c110f] arm64/Kconfig: Remove
>>>> CONFIG_RODATA_FULL_DEFAULT_ENABLED
>>>> git bisect good 805491d19fc21271b5c27f4602f8f66b625c110f
>>>> # bad: [13c7d7426232cc4489df7cd2e1f646a22d3f6172] arm64: mm: support large
>>>> block mapping when rodata=full
>>>> git bisect bad 13c7d7426232cc4489df7cd2e1f646a22d3f6172
>>>> # good: [a4d9c67e503f2b73c2d89d8e8209dfd241bdc8d8] arm64: Enable permission
>>>> change on arm64 kernel block mappings
>>>> git bisect good a4d9c67e503f2b73c2d89d8e8209dfd241bdc8d8
>>>> # first bad commit: [13c7d7426232cc4489df7cd2e1f646a22d3f6172] arm64: mm:
>>>> support large block mapping when rodata=full
> 


