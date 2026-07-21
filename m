Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 644BDC4452D
	for <linux-mm@archiver.kernel.org>; Tue, 21 Jul 2026 23:21:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6295F6B0099; Tue, 21 Jul 2026 19:21:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5DAA06B009B; Tue, 21 Jul 2026 19:21:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4A1986B009D; Tue, 21 Jul 2026 19:21:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0A3486B0099
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 19:21:05 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 8E8AF14020F
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 23:21:04 +0000 (UTC)
X-FDA: 85014356448.11.57628E2
Received: from BN1PR04CU002.outbound.protection.outlook.com (mail-eastus2azon11020128.outbound.protection.outlook.com [52.101.56.128])
	by imf26.hostedemail.com (Postfix) with ESMTP id 84CEE14000E
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 23:21:01 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=os.amperecomputing.com header.s=selector2 header.b=nIzNJyef;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf26.hostedemail.com: domain of yang@os.amperecomputing.com designates 52.101.56.128 as permitted sender) smtp.mailfrom=yang@os.amperecomputing.com;
	dmarc=pass (policy=quarantine) header.from=amperecomputing.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784676061;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BETFLC9kt11TRFmc3rgqSMmihXgGjx5bDQ/L3CDdY7I=;
	b=FpnGvJsajoOk+kH+BZ3zFnUgmkVkFkI6SwrsjxNUcwbvwIWHqWKI3YlxrvDll0OXRoux88
	UCXrxWlGbXBkiT2w27gxMRxFNSK4HDqYvMaJskZipzL4O7gASCeEWxFTuu/WrrapJchf7g
	Z8pY+u7aFQ7hVbqVhCzHpbz7Fkh7F90=
ARC-Authentication-Results: i=2;
	imf26.hostedemail.com;
	dkim=pass header.d=os.amperecomputing.com header.s=selector2 header.b=nIzNJyef;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf26.hostedemail.com: domain of yang@os.amperecomputing.com designates 52.101.56.128 as permitted sender) smtp.mailfrom=yang@os.amperecomputing.com;
	dmarc=pass (policy=quarantine) header.from=amperecomputing.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1784676061;
	b=ke93/V3cbaqqULfdVP66ha+FWA/+/OmJojOlK80ht1NBwmMgz3Up8aASDjrWtVb/a66B5b
	F8bNebuJgHlME2nVnkw5NbSZSgCKAz++a83fXCZ+sE3NsnddQLsDfBt57SW6mt/Tb2X1OS
	cFrqdq3vNabrxv2u7M6gNgBoZseSwC4=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=u7q3xH0r/weqhcW3VDtIJz1gxhnO4J5h/cxj0FNDpAhoy/w2AsQIkb7aI4lza5yCbdLHJmhElFKTd12E5eh9jhmbQFGGXrVpLryf6e+QXBOPXUkgMyjB8bZBtpJzu7gObujFGf8J5o595274EzLhPtih+pQBpKyJzKIMF1K2x7UqK2MzKhtBnqji5FJn0nLgl+4Cn75+KLVZQuQsGtGOmNKUiZEhHvlfYWpp49E8oGltNy+tMxYnvynWV5xkjj4m6B9qIxERvp/h8LWQsRGUrR4zRfpyN5aOWt835Fp32n49NM7NwkBnJGPnXAogcN1DHO6JAEqNcyPD3VZAFFGu5Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BETFLC9kt11TRFmc3rgqSMmihXgGjx5bDQ/L3CDdY7I=;
 b=GlhYvcCyvfIxjstOvWtjxkZ9kVWBJdDkFrXMcdc1ecJcxukRBV/l/OOSjg+nY/5dBYultK0cBz2AoewK17F7dpV6+5FSGY8OpyE9Kt9gYB0fbljB3ifX56v7o2zc/2gZ1CiPad0Ev6zqkeYfRCWXuJi4vW2qKOEfiDq3ptPVh2C6c6tZfgIwaXox0hSIUR/jjU4wT3ie1XdX36KjyaRhQU+yGlK1GpwOLoVg6+5FyLPw3se25domdelnWyOzSdXTjJUJ5WHk1Xm3SiGI8HLfcUBvHWo2diL1LhkEM+/YMtfrMAP5+H73crYR8MncS/BdtMFI89kyqlUlFs9ASBRo5A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=os.amperecomputing.com; dmarc=pass action=none
 header.from=os.amperecomputing.com; dkim=pass
 header.d=os.amperecomputing.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=os.amperecomputing.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BETFLC9kt11TRFmc3rgqSMmihXgGjx5bDQ/L3CDdY7I=;
 b=nIzNJyefuJTAwYA4O4wK7MxHrJbkTbr5AaXaq8Yxkc1ZAEsjeV5zy4SzVDErYkA3zoaEggx3bwEC1zsYoNRYwTky9L7CG3oucOdTP7t2Mb4NPyJAuv0qyApKQFcTy9RJB2OlGHgwntgrFzwAMouf+WxIxEL445tdf0EUikMOvm4=
Received: from CH0PR01MB6873.prod.exchangelabs.com (2603:10b6:610:112::22) by
 MW6PR01MB8224.prod.exchangelabs.com (2603:10b6:303:246::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.223.18; Tue, 21 Jul 2026 23:20:55 +0000
Received: from CH0PR01MB6873.prod.exchangelabs.com
 ([fe80::46eb:64a3:667c:c1a0]) by CH0PR01MB6873.prod.exchangelabs.com
 ([fe80::46eb:64a3:667c:c1a0%3]) with mapi id 15.21.0245.009; Tue, 21 Jul 2026
 23:20:54 +0000
Message-ID: <fc21c840-1584-4844-963f-80cea7f2e674@os.amperecomputing.com>
Date: Tue, 21 Jul 2026 16:20:50 -0700
User-Agent: Mozilla Thunderbird
From: Yang Shi <yang@os.amperecomputing.com>
Subject: Re: [RFC v2 PATCH 0/16] Optimize this_cpu_*() ops for non-x86 (ARM64
 for this series)
To: Ryan Roberts <ryan.roberts@arm.com>, cl@gentwo.org, dennis@kernel.org,
 tj@kernel.org, urezki@gmail.com, catalin.marinas@arm.com, will@kernel.org,
 david@kernel.org, akpm@linux-foundation.org, hca@linux.ibm.com,
 gor@linux.ibm.com, agordeev@linux.ibm.com
Cc: linux-mm@kvack.org, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org
References: <20260715180455.515692-1-yang@os.amperecomputing.com>
 <0344c559-1959-4531-9265-d5a5180eb7cd@arm.com>
Content-Language: en-US
In-Reply-To: <0344c559-1959-4531-9265-d5a5180eb7cd@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: CY5PR14CA0011.namprd14.prod.outlook.com
 (2603:10b6:930:2::20) To CH0PR01MB6873.prod.exchangelabs.com
 (2603:10b6:610:112::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR01MB6873:EE_|MW6PR01MB8224:EE_
X-MS-Office365-Filtering-Correlation-Id: 217a0389-00af-4ff5-a347-08dee77eb615
X-MS-Exchange-AtpMessageProperties: SA
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|23010399003|7416014|376014|22082099003|55112099003|18002099003|4143699003|3023799007|56012099006|10067099003|11063799006|5023799004|921020|6133799003;
X-Microsoft-Antispam-Message-Info:
	9ajTGfqTT+k3ZmmLVuqjUOv53UOTMxit+Pt6/r1knsfHK3PmLa6kRHNVnhMefOq23qRAwCvpezRD/7gew7z9BYbdwHJNXVcyt3i+EAFomwwx4/oZqssV3x0QtCGffbGV+f4fMZpNcUgsmOAH7Bsntvd1WC+LC9uh/VAOlBF2XMMFtxrJYiL9JVaUImJVeklKwFL7F52aii1e6cweZquQxc0fdVw2b9/kZd7b51CQPZ2naInwg7uWYzbSh+lGhnl0Pk7s/NuZ1NjJHkkob4eki8F5ASL6VIuB41iriNNHUA/pSpBkY/seXjD9GW7Yz+TRYZH/ak9hWdoZUKUYOuli7iTnwadvBrhvOiEI2xNKvJ15pIaPm3T01pSqAiqcI/ewIYZ5MiidVjuwKTAEiDsF+zjzfgxzbVjk0AwhYr2zuCi1TIZFy8cbo6r0Po4unSwIlLzVhq0V2p0QPP0wZVr/EhZuLo7QxRXWH3ICQzq0sWN11Pt0KlsqpZnhl495rj7yQBpmDkpBzITm6QoDDuNI0PwEaTwQ7u4Ku0+z424Ncog5xdPmGRudIC9BwWj6kpsoOa74VLWitkVcV3hjwaG3NU/K2LfG6luZfrx8rp3ZzMDZLjBEZFukv0d/ATKtbZMoC6FfT5IPofrPbFtQGeaKQrKJ5h72bZhZ+5F/hEnGigQS8C0zgXwVgGOevIEjsH/lCDaJQ+XR9x3eaMRMZi7zxw==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR01MB6873.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(23010399003)(7416014)(376014)(22082099003)(55112099003)(18002099003)(4143699003)(3023799007)(56012099006)(10067099003)(11063799006)(5023799004)(921020)(6133799003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?UkErNlRBbEZtRktib1laMWZ4WHdwQWlRMWJlT2ZNN3VTcXdOU05jSUdYZlox?=
 =?utf-8?B?eTJTMEZBY2w2UGcvSmdoR2llY09UazhuakM1anZnRUxNbTJuR0FxdGFoNGZy?=
 =?utf-8?B?bURPVnQ4SzQyWlpDbHpXOUVVbUFQaDZmZ0M1TEI4amozQUFKaVRIZEhtQVEv?=
 =?utf-8?B?ZDVyYXJETVl2L2c1M09PQUZmM1loSE0xWTZyTUhSak95dGpyQVlONUp6cFY3?=
 =?utf-8?B?cVY0Q0xkYlNuVU9EWG16NWxtOW00b1ZIWGdjdDEya3JVd21ZNHA2SVVicHEw?=
 =?utf-8?B?QU16cjl2OXErRitCVkxxN1NOZEd3VmNzc2xNSExodDJzdGtXbWM5MjR3emY1?=
 =?utf-8?B?bTNZa0xmeGxFSEJCVnJROGJvZjlNelFvYVN4bkl6V3VtV3dWbU1NYWQwWUp2?=
 =?utf-8?B?dUkvbzdmV3BXZzFVWndBN3I0cUNXZWV2aFJaNWV4dG5yYUUwa1Y5eDV0cXdD?=
 =?utf-8?B?RkFRSnVpZkpiSkpyT1ZhczE2MC8rdmRxcG02WHNQaTh4L1J0RTFsNGZ3NWNH?=
 =?utf-8?B?WGZ6WjZjTDN6UDJ1bUJQTDRoTTRsbFpwYlZVTllIY2NUeVkrbTBXbGU5UDNQ?=
 =?utf-8?B?ZUl4cmFSNTVoenY5VkVyWW9kc1l5TXBsKytWNlFLZjE5T2QyK2pBM1k1elR3?=
 =?utf-8?B?UmtkUnlDQUlvZnJTRVFYQWIwUU1mM2dmb3RCYlJ6eVNTVnUyMm1tUG9aNzJN?=
 =?utf-8?B?UUZLRFp4cGhYMDUvNGF1TGNKT0VYQm5iWXVYSEZnZXdMNG9lSlh2bDZUUXpC?=
 =?utf-8?B?UHpGRTNSck9EUk50b1haQjlxWTdmek04bGl4eDNnWXFyNTB1K2IvWVpDVEc1?=
 =?utf-8?B?T2QzUUZZNy8wb25Kc0FWZmlGOE84YzlybEdUcjl1azhQVjVjTkpyeTkzMU1Q?=
 =?utf-8?B?ajdvdmVQdHB5a2NBeUMxSjBLdGlLSUhLSE9Ub2tCTkQ2TFN3d1N5RU9QZENM?=
 =?utf-8?B?aVBKbDJXdS9EMXdxbFlhQ3kxdVQxOS9LaFU2Y0svdE1rOE5mQWF2dkZKeUQ3?=
 =?utf-8?B?SkhDejJTVVl0VDArRlRpYmpxc0syWjlTTEZLYlA5MVpqdEx4T3NFK2MvTWVW?=
 =?utf-8?B?NU1zb1lOak43WWxnZDd1cmVTN2F2eDAyUWR2RWZWTGE1cjgybGpNemNIWWN6?=
 =?utf-8?B?d0JEdm5CN1d0RXd4eDJOcXRwVDRUZktLMmxxekFvTlhBY3gxNndvSVZQK2NN?=
 =?utf-8?B?TTNnaURhUFUvNlo4dDhjYjdtNTgxK2Z4TG5zM0VUUW9HbjhWK0p2ZGp2ejd1?=
 =?utf-8?B?WmdBQWU5V1A2Ni9aUFR3NHNWaUNOMkc1ZUZuTHAzOXVtbXFueStWSGdaUDg3?=
 =?utf-8?B?VUZWOHUxamFKUENGRllIOTROeXROamVKSm9IMHQvbXp6cTcrRFVCM1NpbEtB?=
 =?utf-8?B?WCtOa2gxWWt4VkZTVk9UWmRnbXQ5RkoydnN4Smw5d3paMFRsV1c5dUs1cmFB?=
 =?utf-8?B?V2h1LytBZjE4TnZZQmNFUTBCbDlYOHc4blNyRnZaL2J0VXkwdnpaRFhGQ1ZE?=
 =?utf-8?B?c0Z0TUVRMEIvZkZDa1dhTlZjRE16dHlHeVd0eTYwWkNoZHUxaUhlVndBVlpX?=
 =?utf-8?B?Z01TSXp0M2h5K0s2R3BadFVoclFSdGZRUG85eU9UbzdvNjE0ZWl6L3F5bWlr?=
 =?utf-8?B?MjlHeUFMaWQ4dEZ6UERzQjdSWUJmMHMwVlY3SmNCT0JRRHRJMVRVczVXMTBK?=
 =?utf-8?B?TE1SS1RPaytBeUNsMVI4S2lTbjlMb2dtdXZKYlFnZFFndHhuODU5YzhCbnk1?=
 =?utf-8?B?V2UvY0dYTnNrcmgxTmNRTit1OVNQUU5rTWE4N0F6OUZkNndlZUhNN2JSeWlq?=
 =?utf-8?B?Rm9OdXcrUzkrZEtoZG9mSmpLdGY1eTB6NDloYlhEOEs4ZWtiYUtyNER0Q3Bt?=
 =?utf-8?B?VUsrSi8vSFljVkd5UjlURTA5WWYwalJneXJ3SjN3MXZpakxJbWxEdzdiQ1lB?=
 =?utf-8?B?bGsvRmNnMVlwN0JWemd5MW1BMHBNTEkrQStPZm93ZGJVVXBabEowejlocnFa?=
 =?utf-8?B?eXk2bTF6Z2l0dk45aDVQank4czBTM3haRUdpeFRSMGYxWXFMaTZYWG5CUHoz?=
 =?utf-8?B?dHFZeUUwQ2djY2I2VDZWWlUvNFQreFlKNk81YUhvZHZ3d2FoWC9ZNFNBbHlS?=
 =?utf-8?B?M2YwQ2tkZVczU0tIRjNJV0wwNlFwRjFMTXhuTWJSSGZTRkQrN2VEaVZJdTVs?=
 =?utf-8?B?dUlWMjVuaFR2czB3UG1Hdk92eFUyNEJQR0VabFI4WGpoY01iMkNFeW9zVjdZ?=
 =?utf-8?B?OG9wc21sdHJSUDBkcHkwdmE0VEIzeUt3c2M1R1ZtRUpubExYdDQ5TzRFekZH?=
 =?utf-8?B?UUxiQXNuVHd5N0t5NDVrUWFnUHhCZDdHaFVlMjNZOEZ5Y2dUakJIaXgzSjNZ?=
 =?utf-8?Q?AWC5ObG5HlU/XHZQ=3D?=
X-OriginatorOrg: os.amperecomputing.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 217a0389-00af-4ff5-a347-08dee77eb615
X-MS-Exchange-CrossTenant-AuthSource: CH0PR01MB6873.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jul 2026 23:20:54.2226
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3bc2b170-fd94-476d-b0ce-4229bdc904a7
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: eENTWJ2/gI38lA039Rpl8csT7tQdAuUhkrog1IE2E60Yb2cAjk0BDrneIO4lzxlCkIGU8whdDPi/dKO5sFZ36ggGONjcsBV5mXS/EBwO3zs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW6PR01MB8224
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 84CEE14000E
X-Stat-Signature: q5ixsa9ctsh16xkgx5nqg5zkesqz5ru6
X-HE-Tag: 1784676061-10890
X-HE-Meta: U2FsdGVkX18kKDYBdYEuMRegJKz6akSEr1KP2WuHhe57FY5qCHiH33yA+luS1CP4uaLxzeCB6oVTKmr7BX4wzNGcWYeTwarlT/ikxTBfPnijHexaf405TEvwhJfhWiD9YFALg1ne9H4nTnJv8WaMOX+NMtg7bDyuYbG9/c85aONHZ/F/mQY09CkMJMzmFUubNYkr7UE0QudBOCMAHbi0W1ZGyMIivpEWBFoHgVRQ3CbD/ed7/AWWAztJD1Os4uZiDm3esO+XhqO7JrrZlMblfYc/DNbKGGNHzMaGfSvr5LL9fDfvGUissuWhwuhqxTlANP6mFCGwQ0Zd0VqfNuUBxqufGWLuLZSvN2AJV8byjn4HLDo4DHFLwwh6/iEF442EpVbv00sxDCz332+QHuqNfVUrpD6SMnk+hYiOPdaCx1+n2NzMAQ8zuWUT37ECmn9L0en0GwiclJEDXE6+zNg8l+pw2zMs9OiW+YIOMOIYtnZORvYA0jhuVIxbFcFo95sR5LgHqG2YJSHNDZAgachIShugDZ6AeuxQuN/cZXhwfgcdNey5SmM4r3pHpqXmQ6sXW6mczV1eKCcuUrb/uRFTwODE9XKK7eOE6ydaB7HtQAtWLKo1rNgpDiogNWzel2vUTb53bKN0PqNMd1tnpF0vKZr217YMmoZqeALjZ5JwVXvNEa2LOIT2/A9BpZH6jORhjDkekhejHiqvOqIakeNYIDPV77u41xlt5E1inP+ve24xUE+U6w9fFz/pjTlv6jkk8L7UywkQ1TFghsX/plugZK+MO2rHEmGJM94THrWT8sai3YEuZPlsFW4GwTKIi8u5PlQqCAtKDmoWmVtr8mQxckSJXcVP6ay+a39TgzVE090A8Lnh3nPREtBSNDU0JIZna98K9mkRsWwUVwpmISqkIiyhxF6THkfljaCUHb6De4OXoa5dFXFUK91yyrbi7xzUqKCs/5blM3IAanPKuWJ
 NgThmHsn
 Ytl26FA6ojMLXsIt0ichztHWN+MeSWasSYVF2lZOmMqQDRFWdrCACe1yNXJIvgJOoMqyQkDzcbeFmN0pgSAHnI/wA75491Vzj7m/R9oeJXWHObJ/xFSLxt66EtxFHwljue2uzTvVHF1XSyFAn9Cme/okMUBAIvrKocbKbTlB4ME5h2sgW9XAq7vHF8VudD/3RVat5L2+Gr8nWr32CxpG3HBmftungIS7pxO5tlLXUZ+DgXmcZzsD2XcfxdjRjX7Y6Q3MIr+EIDj1M/Np+JLNfxRbYZ5KmRQGzsOUnleFzLNjY9oAEqHyEMneT1tZUbUGVeNG8vphFZbEmG/FGNPPQRoPpqc52zqceefjGETp3VzMDQMpczsgci6iEgU7/7miKGf8AelpT5Qzk7nP2hFc2VL3643m0Yv2VpSgr1NcS7ULeDmqcyNzW2f05AIjob0+y+I0BqxPcy5MFZDr+kArfeDCRN5K0sLWp5ZaLe1oacjYVaoR8H9Npy/qyci6t/gSlQ/HW6NmPHbQMRKjB3deXZEz1C3JMLdmPeU7Rw4W6DA+rRA20YWLJaqQsFistYUe4lU4+LuHnwrImR4cRSypio7fzEEw4L8UHkHNsvz1ZmhiPxydsX4AdPtgB0oNTaOpLJK47qj1IAMsFVBTFZ6gSAuNuyEZoQpf7nHJD40C1AmSFbE7CCd+ZrY40RInVdjZstpynybS9ZrxqwbCZejCqozurPmDxR4KNxkFPr3iH/stSDMUBj/QepxfvbK/bq/bN9+f9LCgGVrI1Pa/ZTmE8pjZpsx3zmBGSq3KX
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 7/16/26 6:23 AM, Ryan Roberts wrote:
> On 15/07/2026 19:04, Yang Shi wrote:
>> Hi,
>>
>> This is v2 RFC. In v2 a lot problems found out by Sashiko were fixed and more
>> feature gaps were closed (please see the below changelog for the details).
>> Although there are still some open issues, for example, it just can support
>> 48 bits VA (for 4K and 64K) and 47 bits VA (for 16K), KPTI support has not
>> been solved yet, etc, but I think the delta should be big enough and worth
>> a new RFC to gather comments in order to make sure I'm on the right track.
>>
>> Some more benchmarks were done, for example, some latency related benchmarks
>> that I mentioned at LSFMM because I thought responsiveness should be improved
>> due to the removal of preempt_disable. Collected more PMU counters as well.
>> Please refer to the benchmark section for more details.
> Hi Yang,
>
> When we spoke about this at LSFMM, I said I would take the series for a spin on
> other hardware to see if the performance gains generalise. I did make a start on
> that but the kernel wouldn't even boot and I never found time to debug. Sorry
> that I didn't let you know sooner.

No worries. There are some known issues, for example, KPTI doesn't work 
yet so I need to disable CONFIG_UNMAP_KERNEL_AT_EL0 in order to make it 
boot on Altra/AltraMax or any others which need KPTI, and 16K/64K page 
sizes didn't work in v1, but they are fixed in this spin.

> But I think that there are other issues with this concept that likely block it
> from being accepted upstream; see below...
>
>> Look forward to comments.
>>
>>
>> Changelog
>> v2: * Added 3-level and 2-level page table support.
>>      * Tested with 16K and 64K page size. But we just support 48 bits VA (4K
>>        and 64K) and 47 bits VA with 16K for now.  Please refer to the below
>>        "known issue" section for the detail reason.
>>      * Added support for memory hotplug.
>>      * Added support for KASAN (generic).
>>      * Treated percpu and local percpu area address as vmalloc address.
>>      * Fixed build failure for x86.
>>      * Fixed build failure for !CONFIG_NUMA.
>>      * Added KASAN support for local percpu area.
>>      * Some other misc bug fixes found out by Sashiko.
>>      * More code refactor and cleanup.
>>      * Regorganized the patches.
>>      * More benchmarks, refer to benchmark section for more details.
>>      * Rebased to v7.2-rc1.
>>
>>
>> Introduction
>> ============
>> This patch series implemented the LSFMM 2026 proposal for optimizing
>> this_cpu_*() ops on ARM64. For the details of the proposal, Please refer to:
>> https://lore.kernel.org/linux-mm/CAHbLzkpcN-T8MH6=W3jCxcFj1gVZp8fRqe231yzZT-rV_E_org@mail.gmail.com/
>> I didn't repeat it in the cover letter because there is no change to the
>> proposal.
>>
>> The series is based on 7.1-rc1. It is basically minimum viable patches.
>> There are still a few hacks in this series and it may break something,
>> for example, KPTI, SMT machines which shared TLB, etc. But it shoule be
>> good enough for now to demonstrate the core idea. The main purpose of the
>> RFC is to gather feedback, figure out missing parts and risks, and make sure
>> we are on the right track, as well as hopefully it can help the discussion
>> for the upcoming LSFMM.
>>
>> I broke the patches down to arch-dependent and arch-independent parts so that
>> hopefully the interested persons can do experiments on other architectures,
>> for example, S390, easier.
>>
>> A new kernel config is introduced, HAVE_LOCAL_PER_CPU_MAP. The architectures
>> which can support this feature will select it. Allocating and freeing percpu
>> local mapping is protected by this config so that others won't pay the cost.
> I think this approach is a bit of a sledge hammer to crack a nut. If the problem
> is the cost this_cpu_* ops on arm64 due to the need to disable/enable
> preemption, I think we can solve that much more simply with [1], which
> introduces in-kernel restartable sequences. Using this, the operation no longer
> needs to disable preemption but can instead just detect when it is preempted and
> retry.
>
> [1]
> https://lore.kernel.org/all/20260223163843.GR1282955@noisy.programming.kicks-ass.net/
>
> We have observed a few performance regressions recently, for which the root
> cause is increased use of this_cpu_*. We have somebody at Arm about to start an
> investigation into whether in-kernel rseq can solve the problem.

It is good to know someone is exploring the alternative path. But I 
doubt restart sequence can really boost the performance. It needs check 
whether preemption (or cpu migration) happens in the middle of percpu 
operations then manipulate the ip to restart the operation. It sounds 
like it just moved the cost from one place to the other place and it 
also seems hacky TBH. It may reduce the preempt_disable/preempt_enable 
cost somehow for some less contended cases, but it may be worse for high 
contended cases. The percpu page table can work well for both.

S390 implemented restart sequence. Heiko didn't share too much benchmark 
data, just confirmed there is no regression and I had a lengthy 
discussion with him 
(https://lore.kernel.org/lkml/20260520092243.264847-1-hca@linux.ibm.com/).

Improving this_cpu performance is just one of the usecase of percpu page 
table. The other potential usecase is kernel text replication I 
mentioned at LSFMM. The idea is not new, someone else has explored it, 
see 
https://lore.kernel.org/linux-arm-kernel/ZMKNYEkM7YnrDtOt@shell.armlinux.org.uk/. 
Percpu page table can make kernel support it more naturally.

>>   
>> Known Issues
>> ============
>> 1. KPTI
>> -------
>> We need determine what CPU we are on, then switch to the right page table.
>> Currently arm64 kernel fetches tramp_pg_dir via swapper_pg_dir - fixed_offset,
>> and fetches swapper_pg_dir from ttbr1. But ttbr1 may not hold swapper_pg_dir
>> anymore except CPU #0. So we need to figure out the other way to handle it.
>> Switching to tramp_pg_dir should be easy, but the reverse seems harder because
>> tramp_pg_dir just maps the trampoline vectors.
>> Maybe we can do two steps switch. Switch to swapper_pg_dir at the first step,
>> then switch to per cpu page table (for entry) or tramp page table (for exit).
>> Nobody should call this_cpu_*() at either userspace -> kernel entry stage or
>> kernel -> userspace exit stage.
>>
>> 2. SW PAN
>> ---------
>> Has the similar issue as KPTI. It installs reserved_pg_dir to TTBR0 when running
>> in kernel space, but fetching reserved_pg_dir via swapper_pg_dir - fixed_offset.
>> Maybe we can save the physical address of swapper_pg_dir in a variable, then load
>> it from that variable instead of ttbr1.
>>
>> 3. Shared TLB machines
>> ----------------------
>> Some machines may share TLB between CPUs, for example, SMT machines may share
>> TLB between the two hardware threads in one core.
>> The per cpu page table just can't work with it. Maybe we need a new
>> cpufeature to indicate whether per cpu page table is allowed or not. Then
>> just enable it for not-shared-TLB machines.
> The architectural feature you're referring to here is FEAT_TTCNP (common not
> private). There are many CPUs out there that use this feature (not just those
> that support SMT).
>
> FEAT_TTCNP is mandatory from Armv8.2 and the presence of the feature only tells
> you whether you can legally set the CnP bit - it doesn't actually tell you if
> the HW does any sharing - there is no way to detect this. So making per-cpu
> pgtables mutually exclusive with CNP is a non-starter as all CPUs from v8.2
> onwards advertise CNP.
>
> Even ignoring the CNP problem, you'll end up installing the per-cpu TLB entries
> tagged with whatever user ASID happens to be installed at the time. Which means
> you could end up with lots of duplicated TLB entries all differing only by ASID.
> It's probably not the end of the world, but it seems... inefficient.

Really? I thought ASID will be ignored if nG == 0.

> The only way I can see to make this work fully is to rely on FEAT_ASID2, which
> allows specifying separate ASIDs for TTBR0 and TTBR1. Then each CPU can have
> it's own (permanently installed) ASID for local mappings in TTBR1. That would
> solve the CNP issue. FEAT_ASID2 is optional from v9.4 and mandatory from v9.5.

I agree it is safer to handle CNP problem by depending on FEAT_ASID2.

>> 4. Don't support all VA bits
>> ----------------------------
>> We just support 48 bits VA (4K and 64K) and 47 bits VA (16K) for now. For 4K
>> and 64K, supporting other VA bits is not hard, we just need to determine the
>> size for percpu and local percpu area.
>> But it is harder for supporting 48 bits VA + 16K page size. We just have two
>> top level kernel page table entries with this configuration, but we assume we
>> just need to sync up kernel page table at the top level for now. We need to
>> sync up kernel page table at the second level in order to support it. I'm not
>> sure whether it is worth it or not.
> If your proposal is to only support per-cpu pgtables for certain VA
> combinations, I don't think that will fly. We'd have too much of a test burden
> for these different configs.

OK, I can try to add support for other VA combinations. That should 
require sync'ing up percpu page tables at both the top level and the 
second level.

Thanks,
Yang

>> Benchmark
>> =========
>> The benchmarks are done on 160 core AmpereOne machine. The baseline is
>> v7.2-rc1 kernel.
>>
>> 1. Reduction of kernel text size
>> --------------------------------
>> The patchset can reduce at least 11 instructions for this_cpu_*() ops. Both
>> preempt_disable() and preempt_enable() need 4 instructions to manipulate
>> the preempt count, and preempt_enable() needs more instructions (compare +
>> READ + compare) to determine whether reschedule is needed or not.
>> Because this_cpu_*() ops are inlined and called in a lot of places so we
>> can save a lot of instructions.
>>
>> The size of kernel text is reduced by ~184KB with default Fedora kernel
>> config. This also helps reduce kernel icache miss rate and stalled frontend
>> cycles as kernel build benchmark result showed.
>>
>> 2. Kernel Build
>> ---------------
>> Run kernel build (make -j160) with the default Fedora kernel config in a
>> memcg.
>> 13% - 18% sys time improvment
>> 3% - 7% wall time improvement
>>
>> 5% fewer kernel icache miss, 5% fewer executed kernel instructions and
>> 15% fewer stalled frontend cycles for kernel.
>>
>> 3. stress-ng vm ops
>> -------------------
>> stress-ng --vm 160 --vm-bytes 128M --vm-ops 100000000
>> 8.5% improvement
>>
>> 4. stress-ng vm ops + fork
>> --------------------------
>> stress-ng --mmapfork 160 --mmapfork-bytes 128M --mmapfork-ops 500
>> 15% improvement
>>
>> 5. Specjbb
>> ----------
>> The specjbb test latency curves showed the patched kernel has consistently
>> lower p99 latency (the lower the better) than the baseline.
>>
>> 2.5% improvement on max-jOPS and 4% - 5% improvement on critical-jOPS.
>> The specjbb benchmark is quite sensitive to latency and responsiveness,
>> particularly critical-jOPS result. The patches are supposed to improve the
>> responsiveness due to the reduction of preempt-disabled critical sections.
>>
>> 6. MySQL
>> --------
>> 1% - 2% gains on read-only test, 2% - 4% gains on write-only test. Also see
>> 15% decrease on frontend cache stall.
> These gains all look great but I expect we will see similar gains using the rseq
> approach, which is simpler and can be applied universally.
>
> Thanks,
> Ryan
>
>> Regression test
>> ===============
>> 1. memcg creation
>> -----------------
>> Create 10K memcgs. Each memcg creation needs to allocate multiple percpu
>> variables, for example, percpu refcnt, rstat and objcg percpu refcnt.
>>
>> Consumed 2112K more virtual memory for percpu “local mapping” and a few
>> more mega bytes consumed by per cpu page tables.
>> No noticeable regression was found for elapsed time.
>>
>> 2. fork test
>> ------------
>> stress-ng --fork 160 --fork-ops 10000000
>> fork() needs to allocate multiple percpu variables, for example, rss
>> counters and mm_cid_cpu.
>>
>> Roughly 1% regression was found. However stress-ng fork test has quites
>> small address space, the real life workloads typically have much larger
>> address space and do more complicated works. The stress-ng mmapfork
>> benchmark saw 15% improvement.
>>
>>
>> The organization of patches
>> ===========================
>> The refactor and prepatory patches (patch 1 - patch 4)
>> Percpu page table support patches (patch 5 - patch 8)
>> Local percpu area support patches (patch 7 - patch 15)
>> Use local percpu area for this_cpu ops (patch 16)
>>
>>
>> Yang Shi (16):
>>        drivers: arch_numa: move percpu set up code to arch
>>        arm64: kconfig: make percpu related configs not depend on NUMA
>>        mm: pgalloc: introduce {pud|pmd}_populate_sync()
>>        vmalloc: pass in pgd pointer for vmap{__vunmap}_range_noflush()
>>        arm64: mm: enable percpu kernel page table
>>        arm64: mm: defined {pud|pmd}_populate_sync()
>>        arm64: mm: sync percpu page table for memory hotplug/unplug
>>        arm64: kasan: sync up kasan shadow area page table
>>        arm64: mm: define percpu virtual space area
>>        mm: percpu: prepare to use dedicated percpu area
>>        arm64: mm: map local percpu first chunk
>>        mm: percpu: set up first chunk and reserve chunk
>>        arm64: mm: introduce __per_cpu_local_off
>>        mm: percpu: allocate and free local percpu vm area
>>        arm64: kconfig: select HAVE_LOCAL_PER_CPU_MAP
>>        arm64: percpu: use local percpu for this_cpu_*() APIs
>>
>>   arch/arm64/Kconfig                   |  12 +++++++---
>>   arch/arm64/include/asm/mmu.h         |   5 ++++
>>   arch/arm64/include/asm/mmu_context.h |   9 +++++++-
>>   arch/arm64/include/asm/percpu.h      |  37 ++++++++++++++++++++++++++++-
>>   arch/arm64/include/asm/pgalloc.h     |  24 +++++++++++++++++++
>>   arch/arm64/include/asm/pgtable.h     |  37 ++++++++++++++++++++++++++---
>>   arch/arm64/kernel/setup.c            |   3 +++
>>   arch/arm64/kernel/smp.c              |  44 +++++++++++++++++++++++++++++++++++
>>   arch/arm64/mm/kasan_init.c           |  47 +++++++++++++++++++++++--------------
>>   arch/arm64/mm/mmu.c                  | 165 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++----------------------
>>   arch/arm64/mm/ptdump.c               |   4 ++++
>>   arch/riscv/kernel/smp.c              |  51 ++++++++++++++++++++++++++++++++++++++++
>>   drivers/base/arch_numa.c             |  51 +---------------------------------------
>>   include/linux/mm.h                   |  11 +++++++++
>>   include/linux/percpu.h               |   4 +++-
>>   include/linux/pgalloc.h              |  13 +++++++++++
>>   include/linux/vmalloc.h              |   3 +++
>>   mm/Kconfig                           |   9 ++++++++
>>   mm/internal.h                        |   5 +++-
>>   mm/kmsan/hooks.c                     |  14 +++++------
>>   mm/percpu-internal.h                 |  14 +++++++++++
>>   mm/percpu-vm.c                       |  94 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
>>   mm/percpu.c                          |  58 +++++++++++++++++++++++++++++++++++++---------
>>   mm/sparse-vmemmap.c                  |   4 ++--
>>   mm/vmalloc.c                         | 138 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++---------------
>>   25 files changed, 712 insertions(+), 144 deletions(-)
>>
>>
>> Thanks,
>> Yang
>>


