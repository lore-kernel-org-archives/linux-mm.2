Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DE352CAC587
	for <linux-mm@archiver.kernel.org>; Sun, 14 Sep 2025 16:17:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D16CF8E0005; Sun, 14 Sep 2025 12:17:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CC7808E0001; Sun, 14 Sep 2025 12:17:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B46168E0005; Sun, 14 Sep 2025 12:17:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 999998E0001
	for <linux-mm@kvack.org>; Sun, 14 Sep 2025 12:17:19 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 5CFD9BA29E
	for <linux-mm@kvack.org>; Sun, 14 Sep 2025 16:17:19 +0000 (UTC)
X-FDA: 83888360598.19.F16F437
Received: from DUZPR83CU001.outbound.protection.outlook.com (mail-northeuropeazon11012026.outbound.protection.outlook.com [52.101.66.26])
	by imf30.hostedemail.com (Postfix) with ESMTP id 7E29280003
	for <linux-mm@kvack.org>; Sun, 14 Sep 2025 16:17:15 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=arm.com header.s=selector1 header.b=R6D2Rgv2;
	dkim=pass header.d=arm.com header.s=selector1 header.b=R6D2Rgv2;
	spf=pass (imf30.hostedemail.com: domain of Dev.Jain@arm.com designates 52.101.66.26 as permitted sender) smtp.mailfrom=Dev.Jain@arm.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=2");
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=3; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757866636;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eEcX3EOHm29MDxZcH9EHhUBQpC5KNh9maRZJeM1Y+iM=;
	b=HcVvlCGrQduCnoU0sEd1+XVIkraGcDRt5MY5t+E0NzvWBEwU+CqCw/8pzOalZqvnZjJUuw
	rbWs5pgrj5fBvKVi12ZZauHC36iWblnUL0HnAmTtOG7bFX11MFwwUq8ov026kKevprZLFE
	zUE5ZIBZbHXX02BPrDx9MrHLIsgZVgA=
ARC-Authentication-Results: i=3;
	imf30.hostedemail.com;
	dkim=pass header.d=arm.com header.s=selector1 header.b=R6D2Rgv2;
	dkim=pass header.d=arm.com header.s=selector1 header.b=R6D2Rgv2;
	spf=pass (imf30.hostedemail.com: domain of Dev.Jain@arm.com designates 52.101.66.26 as permitted sender) smtp.mailfrom=Dev.Jain@arm.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=2");
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=3; s=arc-20220608; d=hostedemail.com; t=1757866636; a=rsa-sha256;
	cv=pass;
	b=KSEZQZ6lj7NZ1kOdZXK0o1EIFS1miBNXSzc4S0cgADOILlfZGUL6sHpeQIIqMiVDRbpabL
	NtcYZcQxs6t/VLColtQOoZI22b7x24xZWhwZyR2LzWSvIAvZd/cs6DDoSn/FCy/JhTCKW3
	XjgCkJX0aBgyha1GkeLz+mY1pt9VYpo=
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=AiLQdNTbwfbvGzbfkYd3AnMl1KnM3q+MthCRJDOMWULTmOSe41Ktez/A2l2SULgm820HgPLHdFjW6CvtI0GW2FQgNRjy7mdJWl7G0frdztq+wkJNY846Mv/29iPzrS0xv5GR38xP0D26W0vfbxEbeAxqXeCuAEVS7j6f3dHt/O08pJ8ux9ZlmOVrEusqa8xF7D7DfFtDKYra6/A35DoZ0z1tdMpVXwwnJ2SjKbHvalYEnny6RjY/fyAQ916lsbZNjvpZphhK4KaW9dBrAug+8BwOYDCK2jnE7Thzu5mL5MOR3mNDat3S3nk27MpCdKdYgFzQRTP4Cl5jH0Gi62hITA==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eEcX3EOHm29MDxZcH9EHhUBQpC5KNh9maRZJeM1Y+iM=;
 b=Gc3xBmEyIfJKbg85F+Sgj8NTodB1OY5rEXq7I0ZwHZHWIEmnS7EciCUMwtm+709pt6ohKlXXz5xDpVs0AtJDg7FDkqP9rJo8pyKMCLIafGPhvSro/OS5LhRnd/e8cZetl+B5qcb+cQGM1Nd4UqDisrrKacqbPc/5qAzgCDQpZRkZSFq0WqLlPTBvcqhNiw4X0FRyBnVva7CZeGKXIrR1lGG2qLyK2wZiZeZ2XyLIlwPHzWgT2VXyYdkxJhXF0sk1vOtcgKicUfSxeA56WmZfLNuiTU6KL38hJUKDHjcnOOa0ka1oXOgJmJDZ+5XFuHX/3r32m/9tInQ0BYZf3BqvnA==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=linux.dev smtp.mailfrom=arm.com; dmarc=pass
 (p=none sp=none pct=100) action=none header.from=arm.com; dkim=pass
 (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eEcX3EOHm29MDxZcH9EHhUBQpC5KNh9maRZJeM1Y+iM=;
 b=R6D2Rgv2i8BumhrPLinQIJWicI7WBTuhKx7f8VT8Xj4bEKjDJqzHkq9ROpblX1KFSNONlB9NsHA2tUBiPVY4N0Z32zKqi1lpUswwpKDI+rdJkapA+GZgxjAYbHCpmSaZQjXyeZinC4U1tDdI3unovnqmD7ZYiJRa2dWm8b/77ts=
Received: from DUZPR01CA0011.eurprd01.prod.exchangelabs.com
 (2603:10a6:10:3c3::19) by VI1PR08MB5405.eurprd08.prod.outlook.com
 (2603:10a6:803:12f::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9115.21; Sun, 14 Sep
 2025 16:17:07 +0000
Received: from DB5PEPF00014B90.eurprd02.prod.outlook.com
 (2603:10a6:10:3c3:cafe::a0) by DUZPR01CA0011.outlook.office365.com
 (2603:10a6:10:3c3::19) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9115.21 via Frontend Transport; Sun,
 14 Sep 2025 16:17:24 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DB5PEPF00014B90.mail.protection.outlook.com (10.167.8.228) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9115.13
 via Frontend Transport; Sun, 14 Sep 2025 16:17:06 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=pEceh9Y/26DERRhvCvBES+k7F2bSQa4lnMeLKOMlAaIc5A+wPzRcLQG/PHP3OEcibPGqzixDOZ806Nkps8tLu2/+SN1vTJBYSCY4pw4L0MektVwigSYQsJtTuHynDvM/AigKMK7s+zYOZNplhCW0RBdKSClPvbD6J0Xjs9r1m4dlp7FFOulKg9GEBMJpXopaYU738f64dz9haInjsaexyMRCl//DzzAAbLnweF8X/TB2SUWtIVv5QIQQkvosm34Kdv64/QAdn/k53gZIzrZ3+F62aLhS4GnZTRVJfFbmh/T7xSTW8L2nlMsIsz1whOuVihFPBh215iVU5NC43peYDA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eEcX3EOHm29MDxZcH9EHhUBQpC5KNh9maRZJeM1Y+iM=;
 b=JgqbtpTIJ6cWlz+NUF2EkWgufyioehcBrQ5ltFnNID/G8GkK1OdylxyWkPhMza3PiNP9TtU0esmy0pwsYSIwHNZ5F5h9A9Ss6zxymJWNX4cWeMcOWJCArOk37Xn7RKiedxODUKvLrZCtSBMKdFgVcq1X1/lBVD++kvijrjNYVfM+baTL+tJFAgVXClltmKp+feStbQETFX9P84uqsADn4FHlOlWxgeI9u+MZDMEkvn2VDRu2YCm3Pjj3wPdECEMHQgY2V+6QlqRqpraGHVwsr+xc4OQysXqdag6Yi/2IyXBIPTagIpQVXplc+VVOduWHBJOZD1xMAOKJ9sxI63GHGg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eEcX3EOHm29MDxZcH9EHhUBQpC5KNh9maRZJeM1Y+iM=;
 b=R6D2Rgv2i8BumhrPLinQIJWicI7WBTuhKx7f8VT8Xj4bEKjDJqzHkq9ROpblX1KFSNONlB9NsHA2tUBiPVY4N0Z32zKqi1lpUswwpKDI+rdJkapA+GZgxjAYbHCpmSaZQjXyeZinC4U1tDdI3unovnqmD7ZYiJRa2dWm8b/77ts=
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
Received: from AM9PR08MB7120.eurprd08.prod.outlook.com (2603:10a6:20b:3dc::22)
 by PAVPR08MB8847.eurprd08.prod.outlook.com (2603:10a6:102:2fd::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9115.19; Sun, 14 Sep
 2025 16:16:33 +0000
Received: from AM9PR08MB7120.eurprd08.prod.outlook.com
 ([fe80::2933:29aa:2693:d12e]) by AM9PR08MB7120.eurprd08.prod.outlook.com
 ([fe80::2933:29aa:2693:d12e%5]) with mapi id 15.20.9094.021; Sun, 14 Sep 2025
 16:16:33 +0000
Message-ID: <a62b7461-3faf-494c-bd00-0206de184a5a@arm.com>
Date: Sun, 14 Sep 2025 21:46:26 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH mm-new 1/3] mm/khugepaged: skip unsuitable VMAs earlier in
 khugepaged_scan_mm_slot()
To: Lance Yang <lance.yang@linux.dev>, akpm@linux-foundation.org,
 david@redhat.com, lorenzo.stoakes@oracle.com
Cc: ziy@nvidia.com, baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com,
 npache@redhat.com, ryan.roberts@arm.com, baohua@kernel.org,
 ioworker0@gmail.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org
References: <20250914143547.27687-1-lance.yang@linux.dev>
 <20250914143547.27687-2-lance.yang@linux.dev>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <20250914143547.27687-2-lance.yang@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SGXP274CA0012.SGPP274.PROD.OUTLOOK.COM (2603:1096:4:b8::24)
 To AM9PR08MB7120.eurprd08.prod.outlook.com (2603:10a6:20b:3dc::22)
MIME-Version: 1.0
X-MS-TrafficTypeDiagnostic:
	AM9PR08MB7120:EE_|PAVPR08MB8847:EE_|DB5PEPF00014B90:EE_|VI1PR08MB5405:EE_
X-MS-Office365-Filtering-Correlation-Id: 989e2143-ffc7-46a9-2a34-08ddf3aa25fc
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|366016|1800799024|7416014|376014|7053199007;
X-Microsoft-Antispam-Message-Info-Original:
 =?utf-8?B?bE5KRDNBUmNzbzBmZTNYeWZjSFI2YmNNNWJOSmdEQkl4MjFZeXV6OThQa2JG?=
 =?utf-8?B?RjF2ZzFrT0hRamt3OVJudEovUE8wcXpXNUJQclNvekNDTXhtNCtkdWRMSm1o?=
 =?utf-8?B?Sjcxb2gvdTdiNlh6bExWM0ZWWVBhcWhtVmFCQXpqWHgxMDBFTlk3NEdmaE1Z?=
 =?utf-8?B?RkRFRzFTZUNuRTBucjh0cCtWWkMvdG5GNUgrTzNKQTU0UVJZbFVuVEllTDU0?=
 =?utf-8?B?dTBTdHRjb3hubVZVdUhSTFY2MlVXVVplYWlTTlI1SkRZRHJDQ0RENjF4cXJF?=
 =?utf-8?B?NjhRdDdaNUZPalJDSWpzaHdSZFh2Wll5TnRHU2haRnQ1OUFOZ1VlVnNGa1hN?=
 =?utf-8?B?VUdHYlRBdDlwT0hiWkZGOHdSREFYNXU5L1ViclhQejBWaWFXRitDYUV0VERK?=
 =?utf-8?B?MnpUeUZGRnV2V3p4SzNFSDJuTUVKNEVIODl1Sm1YdWNKSnVVTkhtdHlEeDBN?=
 =?utf-8?B?d3BUWWswM3lBUGQwTW0wYnRVVmZDMmlHL1dZWkNzclV1RkVLM3UrWFZrREJo?=
 =?utf-8?B?WmI3MkY3bFFEODhUYTVEdVpMbVhYNThSbnRiNVFVUHpPbld5U0U4S0JFdEk0?=
 =?utf-8?B?MFgyRUIraS9UdU1PT1N5cnowTGxFZXpxelJuQmlhcnhtMWpOSDlUM3dBMkRr?=
 =?utf-8?B?R3ZKd2gweVlESmNkUjlRUDNvOHBhbFVPLzRVVkxWeHZBNmQ2Z0xNRVZJY2c1?=
 =?utf-8?B?elFPWDk2YitpNE8ydFkzZjZGbm55bDBnaklIMHkyejhSVFN6d1g5eUFhZ1RO?=
 =?utf-8?B?SXVvUmRGZDF3bENJQkJjbnlITHZRbVY2WlIyR2g4TlFyK3l3TWR5bHdoOVFK?=
 =?utf-8?B?bkZGS2lEQkhvN1htNys1Y242aldkRnpsc2tvWkFGVVpPdWtkK2lyTUJ6NGZP?=
 =?utf-8?B?L2RzaXdhQUhkSVZiMzJaU29MbGdlOXJ1QXh5Z2RidUlJUHAyQWFpNUNCMG1x?=
 =?utf-8?B?M1ZVdlp5RTZpNzdBazZJWUJWMEFrMndYWEJYbVgxRUdPNms0TnNKbEk3dVdr?=
 =?utf-8?B?V0RJL2ZaQ3ZPTUZEMC9KUkh5SFNpZ1ZieUthNmNiOGNQSEdiUmR1YWt1dkZP?=
 =?utf-8?B?WXdtNmNhQjljc3JxWE5tR2hkTnlIa09hZm5Vak12WXVJQWtpdDZVNFp1K3hW?=
 =?utf-8?B?dmw3WFVsbE5nTTd0L2p2VTd5UlhTOGZmNXVzNmlCekVlaXM3SjE1ZW00dTU0?=
 =?utf-8?B?cHhSODhjakNrNDJJM2E1K3pkUXJCU2Q4c3BKSXpaOFdxZzdjcjZRanJ2MzJw?=
 =?utf-8?B?VHFRY05VeHNlT0hYeE5Rb1pRalFZSzVaMTdBUWc2eVRJYnFKUXVnUllyM1NZ?=
 =?utf-8?B?cDl0R05VV2JkWjdKdWp6eFdzWkhSQ2luejVoUEhpVEJUY04wL2d6bk0zbUMz?=
 =?utf-8?B?Uzd1aDNIbUZOYXYxQWg3UGRGZkJDUTZyRjNKSnVmZHVGSWpXTGhwVU5IS2Na?=
 =?utf-8?B?WXpjVmUvaXNzdmJ3cjBocEpjajM3U2NQUTRyZ0owVDBkUWxXbUxYMGE2SFRt?=
 =?utf-8?B?bU4wazdsaHlnRURmcVlyS2dCajNLRHlSeCtXeEdUTUxCT2FoenV2QjdwWlhF?=
 =?utf-8?B?LzRYM2hxSlkrMDMwaUFFOVQ2RmNvSGVwVTJDSjJxKzE1Q29FTHp1a1A0eklo?=
 =?utf-8?B?OVdUcVNEZTkvb3duZHkyMDVlNjM3UnRIWTRFN1QyQUtoVXNnYWk3R2dVbkVw?=
 =?utf-8?B?cSttekdRM2lKUGNDR2pVWnNFZXRwdlpIZjNPRFJPRU9iRXRLRGJXNnRmU0Ez?=
 =?utf-8?B?cXVTZ2RNeGc2bGJTMy9OZ201WDNpWkVCb2M5bmFTUWp1V1hIVEJKRHBMY3R1?=
 =?utf-8?B?cW5LeElPSEZtWGdrMm4xWEwvQXRkckw4S2xMUW14VXdpV1Y2THpObFdFbmV2?=
 =?utf-8?B?Vks5clBoY0REY2c4WWltSU9TaVRFTnlvSktqekhXSGVWRURRSHFOeTVKQlJo?=
 =?utf-8?Q?+4/Dg1KJj+8=3D?=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM9PR08MB7120.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAVPR08MB8847
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DB5PEPF00014B90.eurprd02.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	abd68510-0e30-41d2-0813-08ddf3aa121f
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|35042699022|14060799003|1800799024|36860700013|376014|7416014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?OFg4cDdWUU54aWIvQ2dVM2V2WFd2RXZ4cmQ5cW1pOWRXMXRiMGw4d1UyL25w?=
 =?utf-8?B?emxWZWpNN2FjY2Q1bSsrbXIvMExiamxYUHFOWEp3TmFEN2EvQUtzd3NMOEh0?=
 =?utf-8?B?Y3VERVZHTU1DOE0yN2J1MENqcEFBSkVTUDE5OHhJZGZ0Ti9EOXVRcmg5VzRM?=
 =?utf-8?B?eWNWeTdSbitmcUdsWlAvN29JNmRyaWFteTFyKzR5SmFCTzlwSWdDYnFLMmVD?=
 =?utf-8?B?a1VZQ3lUc1Z3US8zSE5MTzNVVjhEZHJ4dmc5bmVtOCszdVdCS1pjQzRHY0t3?=
 =?utf-8?B?cXBxNFgwdzI0ZTdzQ2wxdUZ2Ly9TMCtqaDU0aUtkVnZNN1E1OW5tbHRpS1pY?=
 =?utf-8?B?QzdJUk9KTllrWDJ4ODd4TGRSeEZOYmJIU1FNSVpzem1FenFrNUlxdEdBTlRS?=
 =?utf-8?B?MEN5a01aOXUzVmJoaXNoQ0QyOXpTM09SOElJbU9NME1Qd0FLM3N0UVBFMFJY?=
 =?utf-8?B?V2tWelRnZDV3VTNwcU9ONG50WHVPQzZ6OWtPUURQSTQ4YVVyajFpR1h1ZjZL?=
 =?utf-8?B?UkZLRjJ3akxrNDJvSlh4ZWNxVHhpM3VONFU1Tk41dWF1cUlJb3h0dmR2ZjRr?=
 =?utf-8?B?SGZDSW1VYmp5MllvYng0ZWRyaXRFTk8wcTBZeWpmM3hJcHg2LzMzNWpFKzMy?=
 =?utf-8?B?ZWF6a1lwK0ZET2hVUi9sU2xzbndlUUZmM040UjVlb1ROaW9KNTVpV0tnMUJS?=
 =?utf-8?B?SDZTNVNtZ3VtSzE0VjlrelZJS2xyTnM3bWpHb2Vya0ZUbHV4bzNQNGh1a25O?=
 =?utf-8?B?UjF3c1VVVGVwSFA2NGpxdzFtTGxRVk13Q1Nhb1hJcWVOQVZnUXFzV045VXc1?=
 =?utf-8?B?WFdnRTl2cEFWV0VNZ01tQVg3c3l3WWg5ZzA0SjVRYUpTVmhmTjRDWE4rUlVM?=
 =?utf-8?B?NUlUem9ENC9UdjlDTmtlUkFucVFsNysvL3MxNmR6cXpDWnFPaFBMSEh5WkpE?=
 =?utf-8?B?SXVGTzIzU0YxR294NXB3c1pzVjFZZ2lKYzdPZDNiZlg4ckZXd1laNmVieTNV?=
 =?utf-8?B?L1FpUTNkeGdpbVgwTklKU1pVdUx2M2JpbFI0czJKSzM2UFZLTHlxRUdWMGpH?=
 =?utf-8?B?dGpyV2FBa1BMUjE4d3Z5N3VGSmorWUVhZUgvaStQaXVuSkdVSVd1UU92cDVK?=
 =?utf-8?B?S3JlT3JReC8zNDB3TEtVSGlxeURpV3BiYWNObDVra0F1OG5kWGtGRjVvTWlO?=
 =?utf-8?B?SUdCWWd0T081UkNMbXRlTWhQYnZYSVJDa0dEaGlMTUd0clMwSWZTVzdKdE1m?=
 =?utf-8?B?Umxvdi9FUFZBZXdHTkRjNmNHQUtoSGlrRUhDTldOeXMxVXZveUJRb0YxR3Zp?=
 =?utf-8?B?Y0pKTFVOOTBOWm9QbHdaWWdoL2JSY0tRUlFnWUpRNGZxb2xlVmlDR0Fac0pn?=
 =?utf-8?B?c09vK20rOVBIZE9vOGxoOTV0Vkpzb3k1SEhYdEhYVDdUbWFiWGpIa2dJekRr?=
 =?utf-8?B?bmdqT0k3a1ZqVjg1WDNxMkRzdWRNeExPcnNiSHNTQXRVNzNHamd5elo5aVBT?=
 =?utf-8?B?cUF3ZTF2SEVzZ1BINzJWdTUvY04rcVdwM2hQaldUMXgrNFZpV2thQ0cyY1RB?=
 =?utf-8?B?djc5TFpHeHl3SC9DM3pGVHNtRm5wZndaOXUrUno0NnJmQ0J1Q0hQSjBiRkIw?=
 =?utf-8?B?aG91eS9jY2VuaDdvc1RDOHVDeTB6UEcrQi9QdnBZVlVTd3ZRRDEvamlPV2pB?=
 =?utf-8?B?OGM1NWttSVpHWTBPbFVHMXE2djlSL2ZHMElPMWxKWGh6LzBlY3hNOHZYZ3BI?=
 =?utf-8?B?RVpPK29laVFkOENPOU9DTkw5ZFlabUNOSDhlR211alg0M1dEeFV0bENjODlB?=
 =?utf-8?B?cjZFVDhaUUhhRkdSd1BqeUZnbFdxb09sR1Y4UCtUN1N4SmtqenplWklSYk0z?=
 =?utf-8?B?TkRiUkVLb09jdmVqOE5lK3RDQmFHYlhYWnFuODBGU05wQis4SU1sZkU2Mk9n?=
 =?utf-8?B?dXBVSDhvVDRVVmhaQnYrbTlpajVKZzlTbkE5cEU1OHJ2NVQ2cUFnbldPdmhC?=
 =?utf-8?B?dGtwQTBBUW83ZVpCM0oyVmpUTlI5N3ZWUnNlUXBSOUFzOTArWW5qQW9UWXdj?=
 =?utf-8?Q?TtSPzc?=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(35042699022)(14060799003)(1800799024)(36860700013)(376014)(7416014)(7053199007);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Sep 2025 16:17:06.2765
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 989e2143-ffc7-46a9-2a34-08ddf3aa25fc
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DB5PEPF00014B90.eurprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR08MB5405
X-Rspamd-Queue-Id: 7E29280003
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: c84o6ud4ydzt6grqp8rcyndgzgkj51iz
X-HE-Tag: 1757866635-374488
X-HE-Meta: U2FsdGVkX1/i74mns7swQYiRUJwRNp0v1mWnwDxLj5L5PJUz5krGeyucamAyXPieE+vP731zCfn4KyC+rdFLUXyD1D/soatCBaNs9oZSnhjA3poD6OVQ/varsIpTWL3nksQQ/MYhlfoKSDHgaQoxI8vrhT/eQhNBbLECy2ypNRJLY+iy6G/c3CZjJAtqJWz2xy++VkzmJE0g60/VD6HekwkXNYr/KeyB4JWF4NkClT629gntSKkSK4w4Tq7gzHUBYFUS/yyvJNMih7mt/yMLF8VZ4prbHeMxuPANLsCxMhPSbA3tLDop+O7mEoByg51efC5AO0GTT5XM7M/LiYCb7j9J6BfOU7FEBKtuYUSXgKbRjSx+SzldMFrx/ke8sdrffNAdH659xTTZP97gnJ3OMnA6q2ItX5i3R12rMKr9XLBmLhSys8DUbVXjr7z7hUG1OtOmnhkP73yAxLPGMa8ADV00+2IPJISTLOhglIhjhRzE2181XGcXCNg9CKbcMp+TMEmAXcZyDdgw5TTuDUzGh31dZZbkyLSs24PcH3c/RCHQomB39AR90n4Dyy83Ffl9nPkj/9LHQB1D7LTRkfa8UXkm5zVWh4qyeU2F9//sSYm7LrqGbd9aCYP5rLKHHS+PHsdfXe6GhaD0DmNmBtDrR5cOYS4FmJrR8gsfye8m2jmiSEO2VOioASh+HG+BVGSa8lNFR+wzKIwzyOfBqQSc7z87jQQhoC+uNCoWdr1AAKTtBFHFMBRdkFAQ4TCjjSP7iymQAARxqIqBg8iktplUchxo8/dPHUCd9jlDwGN4WD4IB7+arZjk+g6S052kQ0pOEYprCDxaLVqZy9OtoaLFcd4LX4lbtj7uTccWLDodN9i2Vl+xYQKuidvPGcWIMp9vUNkSrh1ArYJB+UgjuWmEYClNoP68sb2iWmNwGpFJFS+2uRRxb5L5KYLgiuY18/5/jDscvtrb6rlNu34J5KM
 Ye6HHdLo
 fQ+YdSZy8NFImJm7MeTU+9lN+w9x43lbmcQ9G
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 14/09/25 8:05 pm, Lance Yang wrote:
> From: Lance Yang <lance.yang@linux.dev>
>
> Let's skip unsuitable VMAs early in the khugepaged scan; specifically,
> mlocked VMAs should not be touched.
>
> Note that the only other user of the VM_NO_KHUGEPAGED mask is
>   __thp_vma_allowable_orders(), which is also used by the MADV_COLLAPSE
> path. Since MADV_COLLAPSE has different rules (e.g., for mlocked VMAs), we
> cannot simply make the shared mask stricter as that would break it.
>
> So, we also introduce a new VM_NO_THP_COLLAPSE mask for that helper,
> leaving the stricter checks to be applied only within the khugepaged path
> itself.
>
> Signed-off-by: Lance Yang <lance.yang@linux.dev>
> ---
>   include/linux/mm.h |  6 +++++-
>   mm/huge_memory.c   |  2 +-
>   mm/khugepaged.c    | 14 +++++++++++++-
>   3 files changed, 19 insertions(+), 3 deletions(-)
>
> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index be3e6fb4d0db..cb54d94b2343 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -505,7 +505,11 @@ extern unsigned int kobjsize(const void *objp);
>   #define VM_REMAP_FLAGS (VM_IO | VM_PFNMAP | VM_DONTEXPAND | VM_DONTDUMP)
>   
>   /* This mask prevents VMA from being scanned with khugepaged */
> -#define VM_NO_KHUGEPAGED (VM_SPECIAL | VM_HUGETLB)
> +#define VM_NO_KHUGEPAGED \
> +	(VM_SPECIAL | VM_HUGETLB | VM_LOCKED_MASK | VM_NOHUGEPAGE)
> +
> +/* This mask prevents VMA from being collapsed by any THP path */
> +#define VM_NO_THP_COLLAPSE	(VM_SPECIAL | VM_HUGETLB)

VM_NO_KHUGEPAGED should then be defined as VM_NO_THP_COLLAPSE | VM_LOCKED_MASK | VM_NOHUGEPAGE.
But...

I believe that the eligibility checking for khugepaged collapse is the business of
thp_vma_allowable_order(). This functionality should be put there, we literally
have a TVA_KHUGEPAGED flag :)

>   
>   /* This mask defines which mm->def_flags a process can inherit its parent */
>   #define VM_INIT_DEF_MASK	VM_NOHUGEPAGE
> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index d6fc669e11c1..2e91526a037f 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -134,7 +134,7 @@ unsigned long __thp_vma_allowable_orders(struct vm_area_struct *vma,
>   	 * Must be checked after dax since some dax mappings may have
>   	 * VM_MIXEDMAP set.
>   	 */
> -	if (!in_pf && !smaps && (vm_flags & VM_NO_KHUGEPAGED))
> +	if (!in_pf && !smaps && (vm_flags & VM_NO_THP_COLLAPSE))
>   		return 0;
>   
>   	/*
> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> index 7c5ff1b23e93..e54f99bb0b57 100644
> --- a/mm/khugepaged.c
> +++ b/mm/khugepaged.c
> @@ -345,6 +345,17 @@ struct attribute_group khugepaged_attr_group = {
>   };
>   #endif /* CONFIG_SYSFS */
>   
> +/**
> + * khugepaged_should_scan_vma - check if a VMA is a candidate for collapse
> + * @vm_flags: The flags of the VMA to check.
> + *
> + * Returns: true if the VMA should be scanned by khugepaged, false otherwise.
> + */
> +static inline bool khugepaged_should_scan_vma(vm_flags_t vm_flags)
> +{
> +	return !(vm_flags & VM_NO_KHUGEPAGED);
> +}
> +
>   int hugepage_madvise(struct vm_area_struct *vma,
>   		     vm_flags_t *vm_flags, int advice)
>   {
> @@ -2443,7 +2454,8 @@ static unsigned int khugepaged_scan_mm_slot(unsigned int pages, int *result,
>   			progress++;
>   			break;
>   		}
> -		if (!thp_vma_allowable_order(vma, vma->vm_flags, TVA_KHUGEPAGED, PMD_ORDER)) {
> +		if (!khugepaged_should_scan_vma(vma->vm_flags) ||
> +		    !thp_vma_allowable_order(vma, vma->vm_flags, TVA_KHUGEPAGED, PMD_ORDER)) {
>   skip:
>   			progress++;
>   			continue;

