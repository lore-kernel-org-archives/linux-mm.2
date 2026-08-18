Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3D1C1C5DF7E
	for <linux-mm@archiver.kernel.org>; Tue, 18 Aug 2026 12:11:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 283DD6B0185; Tue, 18 Aug 2026 08:11:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 20D236B0187; Tue, 18 Aug 2026 08:11:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0AE5F6B0188; Tue, 18 Aug 2026 08:11:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C67C36B0185
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 08:11:19 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 4AF5480BF3
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 12:11:19 +0000 (UTC)
X-FDA: 85114275078.02.7FE9D49
Received: from SEYPR02CU001.outbound.protection.outlook.com (mail-koreacentralazon11013050.outbound.protection.outlook.com [40.107.44.50])
	by imf27.hostedemail.com (Postfix) with ESMTP id EE0DE40010
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 12:11:14 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=vivo.com header.s=selector2 header.b=OzP18j3T;
	spf=pass (imf27.hostedemail.com: domain of xueyuan.chen@vivo.com designates 40.107.44.50 as permitted sender) smtp.mailfrom=xueyuan.chen@vivo.com;
	dmarc=pass (policy=quarantine) header.from=vivo.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787055076;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AI2vgI0nq987M37I+l6OzGTYkyA+zwboAuB5IlKd5rQ=;
	b=ilNkxlQMzvwgdlbBtiuSjJpo+TVUejVSkZsivc+QIdmJitdIv1G3B0TbiDqQssLLCYUfoY
	RelaE0Cel3zd7uL4aJybOHfaYmlkelW9MPxY6tAPHpzBIqibHsdgfilKT3of/MxMJkQdSq
	EK2p/n8WaJ6QO9cWTKZbq2HowbIKiDU=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1787055076;
	b=mhaQYQ+7pZKA0RqECL2BlnuKDBtckFq4htDEPwi0Fb7M84C3Zg72xCSdklprljiO4oFvsv
	ZfJfyGtIuHHwnZQUDnoZ8O+PG/2lL24qvPtfYVMv0OhyGG2yfCnsRF1YnLZ2yLE/DtKNQy
	jWq5jtIPW9qftTkz4GEwtJjPIJ293vc=
ARC-Authentication-Results: i=2;
	imf27.hostedemail.com;
	dkim=pass header.d=vivo.com header.s=selector2 header.b=OzP18j3T;
	spf=pass (imf27.hostedemail.com: domain of xueyuan.chen@vivo.com designates 40.107.44.50 as permitted sender) smtp.mailfrom=xueyuan.chen@vivo.com;
	dmarc=pass (policy=quarantine) header.from=vivo.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=J8jDRLLiwLrPory34vJyf+L4FHlBGA53dZfppXRXP7DZOp5qbbcwVHryAEFFzqofjEPpDC1bGT1OsmLNVMxcnm0XF7zWEtJfP04q8u39SMjOU1bTPfhZi9we+iFJ/ExWYdPvZFDO4navG9KX+71t4GAsBrzQqpWs9YKNUeQKXiT1PYqJpyPCUY4A3m3uKzc6lUnlOU5B+EByGEvWKwEfvUIin7ue8OuXp79T55yFfTVbYY0uvXAgjproT9nnAjKRYSueikUzaLgn6fjfnoFj3R0C1OTmzWL+X8+wU9MfCNkvnB0eYLX/f7BsuwDV6p1uPz76mrCNGkBeGPu6g4JNdQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AI2vgI0nq987M37I+l6OzGTYkyA+zwboAuB5IlKd5rQ=;
 b=UeCytqPIC12yGjPE31qKgTuJrcemevACrEUst3f48O+NDivH4Uyp+MmNATDGiKdlzcrHB3gXFQBmRlOHvyhkAfhGuI3G+YzpV0CC8srmZfa6Ll5CyD4a0GOyKKs3Rzx8Ruj1FHL/JJ9yaiXPNPJQ3G4bckiM4z2Ti36pZ5NjSsvReO2gVMtbyFBnsxrmBlhkSOwj10ady4jxiZz8qA48T3gHVVqkJ1ASE8Pl4ZWhliQFZQDn0xrdtnFqkTz3trBxhdLU4XnHqP2vCxpk25MG0cSVTV6dqoHIUJfuOz5tj2PMrE8y69fLhYwRooRWCKkSh9Jj2mQBZ4mjHQzuJcUY6Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vivo.com; dmarc=pass action=none header.from=vivo.com;
 dkim=pass header.d=vivo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vivo.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AI2vgI0nq987M37I+l6OzGTYkyA+zwboAuB5IlKd5rQ=;
 b=OzP18j3TIEkdNwnA4nJrg2V2zXPbw1x9q5mmItRXWx1+F03m+jc1AzrAyEXJ9oaZFEIn4YtHq8Ww4BdgQ/342nEgJOprCZbhXTl0j5YimHKRQySrwqFcCLHf/g79rRm9GG7RVGdYYigXvzFElEUFtunAO+p42BA1T4OOq/7cRwQWW9n8IjkDLFPuyi+H++e5u5yEsdrATSW0RVz+mk1A1FockNU2DLagl0alAZV8c6e0EkvgrUfetkJI5wiTQtBqHokCAy15/nuNF0Zu1E1wGdjLOhSQiKY0AIV0WQCL5Bh9Yp7oZw8tENw2Od4VTA/Ml9F3KmDd+ZcW0suYTegABg==
Received: from TYPPR06MB8235.apcprd06.prod.outlook.com (2603:1096:405:383::20)
 by JH0PR06MB6509.apcprd06.prod.outlook.com (2603:1096:990:32::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.339.8; Tue, 18 Aug
 2026 12:11:06 +0000
Received: from TYPPR06MB8235.apcprd06.prod.outlook.com
 ([fe80::6ef9:8fa6:5ebd:96]) by TYPPR06MB8235.apcprd06.prod.outlook.com
 ([fe80::6ef9:8fa6:5ebd:96%5]) with mapi id 15.21.0315.016; Tue, 18 Aug 2026
 12:11:06 +0000
Message-ID: <e83e26ea-be26-479f-ba59-e8544b6d9897@vivo.com>
Date: Tue, 18 Aug 2026 20:11:04 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 0/2] mm: zsmalloc: make shrinker compaction
 budget-aware
To: Nhat Pham <nphamcs@gmail.com>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>,
 Barry Song <baohua@kernel.org>, Yosry Ahmed <yosry.ahmed@linux.dev>,
 Johannes Weiner <hannes@cmpxchg.org>, Brian Geffon <bgeffon@google.com>,
 Minchan Kim <minchan@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, xueyuan.chen21@gmail.com
References: <cover.1786003779.git.xueyuan.chen@vivo.com>
 <anVWZVOt-xeD0dMH@google.com> <47ed45b5-de67-41aa-aa21-a3ba3479a7cc@vivo.com>
 <anXJ-5_vO7-toSe1@google.com>
 <CAKEwX=Mm2tXcen-quRXHf1Y2qSHYvpEUe4xiw-mHYaJnRUR-EA@mail.gmail.com>
 <7b83c51a-1777-45e3-ba38-89e12dc87b5a@vivo.com>
 <CAKEwX=N0Ocxa3o7A+F+2_iwEPtyvXzunfNXOsq7UaPEKWSB-gA@mail.gmail.com>
From: Xueyuan Chen <xueyuan.chen@vivo.com>
In-Reply-To: <CAKEwX=N0Ocxa3o7A+F+2_iwEPtyvXzunfNXOsq7UaPEKWSB-gA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: TYCP286CA0024.JPNP286.PROD.OUTLOOK.COM
 (2603:1096:400:263::14) To TYPPR06MB8235.apcprd06.prod.outlook.com
 (2603:1096:405:383::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: TYPPR06MB8235:EE_|JH0PR06MB6509:EE_
X-MS-Office365-Filtering-Correlation-Id: 54766830-cf13-40a8-4f3e-08defd21c7e3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|23010399003|366016|376014|7416014|11063799006|10067099003|4143699003|56012099006|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	U4MttQUWn97g8bAkxFQWO5NdH1GSEiJSaoYoZOhRo1PX2pMvMD7LyeZ17RsHoOKc1XDk/LEmB8KOkVb1rP5upcTBavmtlFEg9NQ/RsoVOqJo80vyGA+VIxRaS06HB7hbAiqCPGLJp6CxVt4DjH9zeozRiMm0VMD4cJn/1ibF1uHXZGR78FiT8oF9NZdyrK8KODbrGl6E02vFWcnNNWPYxbjHt8DdPL/wx5cLFhl4s6ufngP6NUwwSPq062BEydnanMqgWeou3NppFnMep0m0sYsLBNnsU4TdKdUgci6IBsWBpOjHBTGjYUQXvLRK8z6h1RYtBn8P/W8SlNB+4WWdWvsAhS3wF8TRaKZLmlTjIyCWWZKywp6ZOsRICnC+SmqVetKnrPM9kYtx/lgZ0uzgQ2TUVdiFOcGDiMxOia84c4niZBaML9k/x6t/tr1d7bY2n3STyPFnAQ9yJRRgrky5mVx6zNO5UcxoNykk8VJyyIImwhRfvsPtDR7z5UQjP1GOzKLuz1nbN4gtWpz+r1ionP8vndJybJsxlJgTO1vVvMmzCgPpcXzZfOUSCe6rYU9fDjoergEmwj/YVB5kTi7PfOWirs5rqvcNSRuf6ne1045Zstg5j7jdZiAMpTHGcWxpQoHWuPhSprw5/Lxh4Dy+9qRMXPKCIURL2uhKOlh2i4A=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:TYPPR06MB8235.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(23010399003)(366016)(376014)(7416014)(11063799006)(10067099003)(4143699003)(56012099006)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?b3ViQXFpdHVBOWprZ1lFVk5zSUIzekJyT3VuMFFUc2tvL0NBdUFjdW0za1Y0?=
 =?utf-8?B?S1hTaFpyNDdkT2xDZTdBYmRQTENaa05WeGdmQWNCRkVrbWZOVWpnTld3dXNT?=
 =?utf-8?B?MjdJYzBhTFZOVzNyYk9xSCtOeHZ1eUxDclNZcTVHRjBueWNYVUZYNENscjA5?=
 =?utf-8?B?TE0wT29rTEkrdnErMFVqNDhLSkMwL1pwNitPaUhiUWt5THhQNVNrU0QzMWZI?=
 =?utf-8?B?YTNLZXJUdFh5ZGtRQkZ6c3I3MUMyeTk2ZTA3Z3RTS1Uzek1uanJuMmNHcHVQ?=
 =?utf-8?B?L01BRElOeVlYSU1kTkxPUDNsQmFPRmYzcG1RSVpqS0tHSlBGbW5lRkVOd0E5?=
 =?utf-8?B?T0RyZ0tGcEZrQ2kvYlhxOHF1ZUl6YkJxdDlGQlM4R0ZXYWlINU53SERiZC9t?=
 =?utf-8?B?MkltbHQ0UngycnA2azlXa3ZFOUdqbkswZ21TV3daKzZwbGZtOVFEMnp5cmVS?=
 =?utf-8?B?SE45NXJzWHQ2M0JWUjFhcndUTElUMDB0dnpHRFkrSXd6bmIycnZvTTNURjVw?=
 =?utf-8?B?VExnVHRUS1Q0ZFNOT2pheERvQTIzQWVqM3R1UitBc0k0NVU2cVJGVkRiWVlG?=
 =?utf-8?B?Q05LR0RGZ05PSzdJb0lKUUgwMGpkdXFXVWx0V1NTUmlNa09COEU0V2tXbEQ4?=
 =?utf-8?B?SmR0L21BdWxiZnpUTFRreUdVTzBaOHdOV1ZkeFp3TGdPRmRoVXNHcDJEYkVE?=
 =?utf-8?B?aTFqS2RDNnc4djVoWEFrRFJmRHVXY2c1NVlmMGhiMlVTVjVVeXFOK2FSbGJU?=
 =?utf-8?B?QWt5eHliNGJGWWFmL3Q1VGs1SHE2SzRPVFV2d3RCN2tyY1NBVVVEYUI1cmNi?=
 =?utf-8?B?d081bHRKK2lBa2RnSW13UVRSUzNvbzhuSE9iN3hiZUlia2dBc1cyVVpCUmRr?=
 =?utf-8?B?MlhBZUl1eDF3UHdUR21WaEp1SWg5Zmx2U2xyL2xpYXh4Ky9QN2FMS0lsakNY?=
 =?utf-8?B?MklpbVA1UGpsMlFSeXlhM3h1NlhraDJyTmpPSFBrRm5tWHF2Sk9kb1UwNXRj?=
 =?utf-8?B?dERWY240VmJTbzJrckR6UmhoZHh2QTZLNHB3cnVZZVlwenl6YUJFa2t1aTl6?=
 =?utf-8?B?bjNJV2VHUDhtb0ZxSlIzK3pUUXpiZFkvcE5FM0x1YmllWHMvRCs1Nksvbm55?=
 =?utf-8?B?OUhINVozWG5YUXB2dDJMcWhTaklJYk54TWhuK1c2cFd1cUpSaDRrc0FzVzhT?=
 =?utf-8?B?ZzBma0gwT3dFYTE0SmY0RHF3SFU2Z1hQWG5QUlVqY3lUWXJHd1ppRFQwOE9F?=
 =?utf-8?B?UFdkbHJPNnVwcHkzaExmSS9nenNMeGREbThnUXh2cTExRGtDQm4ySmFXa1Fs?=
 =?utf-8?B?YkRwOEdUenpINjFrZUsrNnpuWEZFRzBmeDIrNFdoNnhsUlhHTTVyWmlDRmZt?=
 =?utf-8?B?U3hpY0Zpa0VaS3YwL0NoTjJEZ2MxRGFTeFZZZmRlbnY0WHV3ZmtCRXdMbjZm?=
 =?utf-8?B?N3JSOXJZTmd1RVVhQW1nMkpZeFRQQ0RvUXJIWEpNNkdQWVBBSGFzMEhSYnVz?=
 =?utf-8?B?aVlaZXRQcmpickViclhnblRPeXF2bDk3TGpYUDJ3NmE4Mkh6OVdRSktuUVpv?=
 =?utf-8?B?MEZCNVVveUJwenROT2ZYRVp5d3kxUURaNTRMNWpMbS9iTWNCMUJkTUltRFh0?=
 =?utf-8?B?dC9VeE1tb1VxaWZGbTMrSkRhTWVYM0x3ODd2WTl0R043QVpOMTZVQkZrcHN4?=
 =?utf-8?B?QXg1Zjk2WUJlV2lNeG0zWXFMOWxzVzN4OHIrRmRWajE0OWtDTzNxRnhsLzNT?=
 =?utf-8?B?Y254MmxZbnhzcG93dEo5MTVWcGk0eUMxVTdWWWlVVG1tSVozUkZadkY2dzBz?=
 =?utf-8?B?RU1HMGs3NEVydlAwU0t3VnJILzU2SXJ5eGdKcGhHa2JUd2EyVEJ3YWUwOFNL?=
 =?utf-8?B?cUE5REN5cURsQkhGWEtzUFFtM1oxVG1CY0sraU9VZkpVdFFjMVhwdDc2bThz?=
 =?utf-8?B?RXRvTTcrK3IrNG1UUWE1V1pEVTlTcUVvSHpCMzg0UlFGUU1kSC8wZHlKZFdD?=
 =?utf-8?B?N016ZmJmc1VrZnFCWCtvNkdhWUd5OExZQkFuTys1V1JVM1hpam9QRk92OWlD?=
 =?utf-8?B?MzRBbndYWGZkdzZ3am1jc1luWm9ScC9vQ0JRSjA4Uk4zT1k5TkMyOVRuTzk3?=
 =?utf-8?B?OFZhdE94cDhTSUd5c2M2SkUvYVlwbzJWZ29QaTJuT3ZPZ3ZyL1d0eGRNSU1V?=
 =?utf-8?B?Mmo0b0cyWEpTSTZyS0JoZC9lWVhNQmM3VjRHNjhpc3hEYW54a2hXV2tRMS9u?=
 =?utf-8?B?elJNTEk2citEL0toVkZva25jVlVMMWRjSm1LaklYQnB4a1JibE5zVi9BTXh4?=
 =?utf-8?B?QXlKWlRaRmhENHdWRU1IVzByY0RXaDJJOGd3OHM3OWlsMHdVaDdFQT09?=
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 54766830-cf13-40a8-4f3e-08defd21c7e3
X-MS-Exchange-CrossTenant-AuthSource: TYPPR06MB8235.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Aug 2026 12:11:06.4905
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Wxy97XrYeXdaT0jR/EjySguxJgK9+4j4yI8P2gqNvr4JOEJGAKh+x7pZ+ADrusodSBj0pAZ/kEXHT2OippAH1A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: JH0PR06MB6509
X-Rspam-User: 
X-Stat-Signature: w3mr6dyi1gpjg8mu8agdzxadfix7kcu6
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: EE0DE40010
X-HE-Tag: 1787055074-606795
X-HE-Meta: U2FsdGVkX1/z2Q+8GsocqvSCifixi6+//IuZB6jbSH41hEO/8QxBbBBpszDgL3FiJUwSpSJ0P3qw5nckDZgF0bDPCYz1lY04QZyGnrD5h6qGSPpiCsz9+e2w6OeScywpHq45RW5Cohs1a0UK7/yicj9ANIFKcxCS7eHn45T734b1qSM7k8lqWPTor97ZjNS9eEOrnI/5r9cosBBELB3WRkqntXzmixr174MAPZbNS3h64mnTKVHsCBdBlBffgmfrh95pGzjvfFk2gPcbpNFnHURNRLn0v408EVf0ka2h5JYWEeVfTWJCPpEkkvgx5WUlACAaCHmISxUhdeg9zKMUnDa3cf9VZlx/mmj5Kpux4Kfuanlm6ayTz88zdFNAfR0t38haGt1gUN857YFDPPMytFlg8WfPf0/HU/njQzwrTYZITZALFdVqx5p8EUfdt69L8nLXTMgAsXm8CwWopvcNj0JcmN/JqXRbQNaPRXpo+rM7qPXzmst7L0A7uxwS3qRKy8FdkRCIUKTO1/ddqS8ey6CW/NHhYDBJFaGrhOUS1k4VOdIYP7LJ8ddNjjrUwELpxFxpdtfFewm8TfoXCamJAAxaqiLWymUhROUxan9GNgvD9cxhM4PQhBkO78wxxxig07TLkq/yAuKDYTE2HXBFOhluHcnHq4gIFNFHNmEIqvT39sR0tQyi4bv2XCwnVEv2CpJNwGsIuvzHAV0k/HHca7jc9yafiZeecsh8zY3ZrmI9a+oJvqi3JtdV4fjGIQ4CFfYUfywSjFT+fSycx7xVX5AgYANox6witkK1zI+4NxShhaJqrJYj3mdmEHrET4RlP2gKV7aCb9eslzFEnXrrIuqyRii4eIHfIFoaytCVQ9q/xtuLIlmcmDmRcxxImAWV0rM8y0igWs8ZSCcXlIOLsde6+en9kDZqPdvOY0pV+8K2dCcM47LAdCV7zjkPcdMSKWjhsZrjxvKW9RoHA6i
 ehPJjp47
 RmA2ejq5jBCwuabariNP41tqU4mDgU3csRZPKux0IiDbBhSv1ZrGSZIpFu99vHcrgtOJey7YeFLmRCHsGEqYCmKE6VZrYsqid0WZc6xMvg8MNrcbyVNgPVKAvzwaOGEZc81HsG8jVwKg99LVBY+YXyBiyA5ynP5+E4MHe3kilu11HlMKB/acrJXCsgd9t4kNgyUeTiYkrpPmT3bwAd5lvd+99aVmfco7omQ9dvVDkg9A+04f/tQewmMwslmnP9THfxXhbdug0a/T7sisnud9Ce1f/pdKMLadwnocqI/VlvnEJRYipaIWwkhIgdHTjGG05MTsfNaDss6VyhX1mImJ3GWL7BArm9xCsn2Rdbqnu+0kRPmHGHi1kRIoi5/M9i94WH0Uk6zNHn27nrBXtOa+6Ck3jwETwA4Aw54L9QCDewNGtQtblD1UxHp9gdcmyydThXn7joXjOMzltZTzbmGqALfYGbEtztx/TTQ2CRksTMp0XhSVpXPOEmA2S1wlctrMfWtg4EVEiiWNXU42+hwun4vtvR895IW/96KYbM7LBi8h/2LgfMUrZc2yFDA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 8/12/2026 12:25 AM, Nhat Pham wrote:
> On Tue, Aug 11, 2026 at 2:04 AM Xueyuan Chen <xueyuan.chen@vivo.com> wrote:
>>
>> On 8/8/2026 12:25 AM, Nhat Pham wrote:
>>> On Fri, Aug 7, 2026 at 5:12 AM Sergey Senozhatsky
>>> <senozhatsky@chromium.org> wrote:
>>>> On (26/08/07 18:57), Xueyuan Chen wrote:
>>>>> Hi Sergey,
>>>>>
>>>>> Here is some additional data:
>>>>>
>>>>> I used the following definitions:
>>>>>     compactable ratio = freeable_pages / total_pages
>>>>>     memory reclaimed  = pages_freed * PAGE_SIZE
>>>>>
>>>>> freeable_pages is the estimate before compaction, based on the same
>>>>> calculation as zs_shrinker_count(), while pages_freed is the actual
>>>>> number of backing pages released.
>>>>>
>>>>> There were 264 callbacks in the trace:
>>>>>     callback elapsed time:
>>>>>       median:    5.77 ms
>>>>>       p95:      55.82 ms
>>>>>       maximum: 271.36 ms
>>>>>
>>>>>     compactable ratio before compaction:
>>>>>       median:   0.32%
>>>>>       p95:      2.86%
>>>>>       maximum:  8.33%
>>>>>
>>>>>     memory reclaimed per callback:
>>>>>       median:    3.80 MiB
>>>>>       p95:      30.45 MiB
>>>>>       maximum:  92.73 MiB
>>>>>
>>>>> The longest callback took 271.36 ms. Its compactable ratio was 3.25%,
>>>>> and it released 7,650 pages, or about 29.88 MiB.
>>>>>
>>>>> There was also a 241.91 ms callback (with 30 schedule-outs) with a
>>>>> compactable ratio of 0.44%. It released 1,019 pages, or about
>>>>> 3.98 MiB.
>>>>>
>>>>> Based on this data, it seems better to remove the shrinker.
>>>>>
>>>>> Would you prefer that I change v2 to remove the zsmalloc shrinker
>>>>> callbacks directly?
>>>> Let's bring in heavy artillery to this discussion, in addition to Andrew
>>>> and Minchan, adding Nhat, Yosry, Barry, Johannes, Brian (random order).
>>>>
>>>> Folks, I'm bullish on removal of zsmalloc shrinker callbacks.
>>>> I don't think those buy us much apart from memcpy-s and lock
>>>> contention.  Systems that want to compact zsmalloc have a sysfs
>>>> knob (and API) to do so (based on zram mm_stat numbers).
>>> Hmm we'd need to collect more data in our workloads to determine, but
>>> if we can compute compactable ratio (freeable_pages / total_pages) on
>>> a per size class basis, can we just skip the size class whose ratio is
>>> too bad? Would that at least cut down on the vast majority of
>>> fruitless memcpys and lock acquisitions etc?
>>>
>>> I'm always a bit hesitant to over-rely on userspace, especially when
>>> kernel has information to do something smart about it. It might not
>>> react in time, and many proactive reclaiming schemes back off under
>>> heavy memory pressure.
>> Hi Nhat,
>>
>> I collected per size-class data. 53.7% of size classes have freeable==0,
>> so skipping them saves some time. However, 94.7% of zs_compact() time is
>> spent on classes where freeable > 0 — meaning the cost is dominated by
>> the actual compaction work, not by scanning empty classes.
> What's the distribution of these? Say if I were to skip all size class
> with compactable ratio below 20%, or those where we can free at least
> one full zspage? (IIUC, we only free any memory at all if a zspage got
> freed up from our internal compaction, correct?).
Hi Nhat,

Across 106 zram0 compaction callbacks, there were 6,246 per-class
events with freeable > 0, covering 118 size classes.

The data by object size was:

   | object size (bytes) | classes | events | total pages | freeable pages |
   | [0, 256)            |   14    |   570  |    182297   | 6728      |
   | [256, 512)          |   16    |   748  |    480127   |  14526      |
   | [512, 1024)         |   30    |  1586  |   2677075   |  71934      |
   | [1024, 2048)        |   36    |  2180  |  11990170   | 294133      |
   | [2048, 3072)        |   15    |   821  |   5089301   | 106204      |
   | [3072, 4096]        |    7    |   341  |   1170843   |  20012      |

The compactable-ratio distribution at class-compaction entry was:

   p25:       0.75%
   median:    1.65%
   p90:       6.76%
   p95:       9.42%
   p99:      14.52%
   maximum:  30.99%

Only 12 out of 6,246 events had a ratio of 20% or higher, so a 20%
threshold would skip nearly all of them.

           | freeable pages | total pages | compactable ratio |
   class A |       10       |      20     |        50%        |
   class B |       20       |      50     |        40%        |

In this example, class B has more freeable pages even though its ratio
is lower. So I don't think the ratio alone is enough to decide whether
to compact a class.

Thanks,
Xueyuan

