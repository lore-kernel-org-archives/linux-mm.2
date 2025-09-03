Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 51B1FCA1009
	for <linux-mm@archiver.kernel.org>; Wed,  3 Sep 2025 00:21:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7D49D8E0002; Tue,  2 Sep 2025 20:21:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7AC078E0001; Tue,  2 Sep 2025 20:21:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 64C3F8E0002; Tue,  2 Sep 2025 20:21:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 4C3898E0001
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 20:21:53 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id E434011942B
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 00:21:52 +0000 (UTC)
X-FDA: 83846036064.10.AABB6C9
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2109.outbound.protection.outlook.com [40.107.94.109])
	by imf29.hostedemail.com (Postfix) with ESMTP id C05D1120003
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 00:21:48 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=os.amperecomputing.com header.s=selector2 header.b=rE1eU5XL;
	spf=pass (imf29.hostedemail.com: domain of yang@os.amperecomputing.com designates 40.107.94.109 as permitted sender) smtp.mailfrom=yang@os.amperecomputing.com;
	dmarc=pass (policy=quarantine) header.from=amperecomputing.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756858909;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GfKWuzwUMD6Xp639SHHUcmKfM8anSAMpcVdm3m6xATY=;
	b=H3I76U7B3eOOyFa7TG8zV5FVH1nAYIQR9vxOUegOofXpgISiMLkNhWQhM/Ln16QFcf0vvb
	kPflPTrWDzNPNnKbIB4Zn7lzKqHaIyAUW4a5FcTt/R5ptP2/FgFtfROGuOewzZUXW8kRRY
	QwAC73hgBvlO8z7FxNZ5W8Nl+z+S2k4=
ARC-Authentication-Results: i=2;
	imf29.hostedemail.com;
	dkim=pass header.d=os.amperecomputing.com header.s=selector2 header.b=rE1eU5XL;
	spf=pass (imf29.hostedemail.com: domain of yang@os.amperecomputing.com designates 40.107.94.109 as permitted sender) smtp.mailfrom=yang@os.amperecomputing.com;
	dmarc=pass (policy=quarantine) header.from=amperecomputing.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1756858909; a=rsa-sha256;
	cv=pass;
	b=lnN9UAiHm10jyqUupKZcuwDQ8aGn1xNtMXQqyXJM1YV2c7z3516QEVyWZ3iXJJFwUot6IL
	9gV+L/Qv0sa/+R/8GGhpN31Hn0qUOUUwv3cVYCYhlb0wprEXutIU+H9T5jZFKiuXVuAYoL
	VVl8F4wsuqwDjjz/pjEtJ1Go4+qLf1E=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=XGwsftAtEQp85+cMS5AKukz9FPkhih1zq3oiC6ggDhcIMqQFEyyxkAX/YoHrDu3L8aChj0o38ftDaurCdkNzU0CuT+ZryYA7FQ0163rV8DYp/CoifTKJjmpyB38a8GCH3YtHdZhFgiTVu3at9k6d2MHvSyGnrutf0q0JnXoBvA+0TxU4giWkMq9JwGUB19A8xXjs3R6tFm7WLIV3dywIjLD1aeDDz+sVWtqCLaIvgt7nZQSOWtcLMP7KOazZ0TqcnjtdK7ei2f14YuFFb7fbR9PFDKLVsIahdu6VKgBnrE/JXM+Uecvq48I5KbOMXIESgm1egvF5u9lg3/KlN5S2qg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GfKWuzwUMD6Xp639SHHUcmKfM8anSAMpcVdm3m6xATY=;
 b=c4kW3BUcfJGJfbzS+gb+Jw7O9Lgfm472xPxqVcyyWUILUDrTf9YhpV3L55Du1uVOGyWv3G7rPmEbLj2vSlf9y6gjgtVwiFJgWPVozC+ybjC5TIORIWAaT4BCntBgXFP/jdnhqM1coK0SzE/gcDZ7q9VCBFqb6agx4b5/G4s4XYxsWy+e1603tc272oxzFR2Q6Q/22/AEbS1nqPJNWuiEgvl2g/c4x6VnPA6uljZbQf5W8ZmC/9aBPCuVXnWjjU0O5SFCc5DZOmCGPWgIxcwLhCU9YBw9Xjto/4eM8ogyjCj98NFfdeZrWstuqnFMBmgrgC9QwerNF2jq1r+//uZ3vQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=os.amperecomputing.com; dmarc=pass action=none
 header.from=os.amperecomputing.com; dkim=pass
 header.d=os.amperecomputing.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=os.amperecomputing.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GfKWuzwUMD6Xp639SHHUcmKfM8anSAMpcVdm3m6xATY=;
 b=rE1eU5XLAZ8c++LPBhoFoOy5rGFu4YtX6IphD2wSUCyfva+I6sFrNlbREh9jfD0k5+St7xfvb0dPyPivgSl4BBFYEgtO4L3vVqifQvBlgVWqoyGV++loDzl6VbFOWvv5plIB70ny3B5SOldqYCRHUBIJ7Bu5pYuqy/OTGBbGyF4=
Received: from CH0PR01MB6873.prod.exchangelabs.com (2603:10b6:610:112::22) by
 PH0PR01MB6522.prod.exchangelabs.com (2603:10b6:510:74::13) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9073.25; Wed, 3 Sep 2025 00:21:44 +0000
Received: from CH0PR01MB6873.prod.exchangelabs.com
 ([fe80::3850:9112:f3bf:6460]) by CH0PR01MB6873.prod.exchangelabs.com
 ([fe80::3850:9112:f3bf:6460%2]) with mapi id 15.20.9073.026; Wed, 3 Sep 2025
 00:21:44 +0000
Message-ID: <aeb76956-f980-417f-b4e7-fe0503bb5a2b@os.amperecomputing.com>
Date: Tue, 2 Sep 2025 17:21:39 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 0/6] arm64: support FEAT_BBM level 2 and large block
 mapping when rodata=full
To: Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@redhat.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Ard Biesheuvel <ardb@kernel.org>, scott@os.amperecomputing.com, cl@gentwo.org
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org
References: <20250829115250.2395585-1-ryan.roberts@arm.com>
 <e722e49a-d982-4b58-98f7-6fef3d0a4468@arm.com>
 <dd242f5b-8bbe-48e8-8d5f-be6a835a8841@arm.com>
Content-Language: en-US
From: Yang Shi <yang@os.amperecomputing.com>
In-Reply-To: <dd242f5b-8bbe-48e8-8d5f-be6a835a8841@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: CY5P221CA0027.NAMP221.PROD.OUTLOOK.COM
 (2603:10b6:930:b::37) To CH0PR01MB6873.prod.exchangelabs.com
 (2603:10b6:610:112::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR01MB6873:EE_|PH0PR01MB6522:EE_
X-MS-Office365-Filtering-Correlation-Id: cd932cfa-a8ef-4399-8bea-08ddea7fdcdb
X-MS-Exchange-AtpMessageProperties: SA
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|1800799024|366016|921020;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?UkJ4S3VyVW02MzRNSm84cUVMSlJXY3NHaVVnZ09pT0FlNjRZT0N5VW9EMzhQ?=
 =?utf-8?B?bk90d2NGS0xuMERzZzFGTVZadmpEd2RlUzNINUtKVjZudCtOSlNxWTU2QmZn?=
 =?utf-8?B?eEFvcmRnUEdmdUZEL0IvUC8zZzFCdlJiRTNRT0taS2ZLMHhOMUN3a29ha281?=
 =?utf-8?B?dlJQYU9JRUJtQ1AvYW9icGxXeVZ5cGV5SnltNWpLak1ITGFTa0FybnVMbXNW?=
 =?utf-8?B?SlJUNlYxNlJtd0dpY0VvdnhpMHFYcWY0ait4cWZtOW1STnh0OEh0aHkvSTBP?=
 =?utf-8?B?N1FzNmZndzNyN0h2a1VtRjRPQmFzcXlQL3pBYmFuY0lsZ29KQzFJb0piZWxr?=
 =?utf-8?B?UUE2ekJEMXAvbTEwR1JmVURkek9jYjVVa25NNWFENkVKYTNtRmJGMjc2U0Jr?=
 =?utf-8?B?QVZFZDdKUWFBYlkrRzh4b0c1NGxpYlRteFhid0xudVNGTGhrNWNEdXBDNWNC?=
 =?utf-8?B?WkUrbFVKYlcxYXhLM2E2RUVKNzJXQUk0Z0huL2xoQjdYUVRDQTQ1RS9kSWZH?=
 =?utf-8?B?dnhsSmlTNUlkVEY4Q3BrTUVmVFdtc0t1T05XWXNXV0RSQnhlK3pmUkJRcHF3?=
 =?utf-8?B?QzdwRXRkckc2RVN6UUlEWVVFWTJYWXdXS0szdUpxNFozU2wrMFhQUjVhRGg3?=
 =?utf-8?B?eUdVTXBuSVpYUUxHUDd1MnpqVkVQelJQKys3RmN6NktFeXBIWlJpT2xHeGVx?=
 =?utf-8?B?WlhBeXZCSHNhM1BwSlpzM1k4UnhvNEhxNDQ3M2FZMzdtVkpPNUVnZUNDaklI?=
 =?utf-8?B?NUtpeXRGNnE0cFF0TEliUXBKMXcySlJ1MkY4SFF6SzdZSThQbGM3akErbFpq?=
 =?utf-8?B?ZHZlY0JtdERBRDhERThGbEoxZXVmR1pSZDk4MUs1K203S2tMVlNDZ3dNby9D?=
 =?utf-8?B?OUdFNTdRMlVzYkc1dkFlSGpveFIrNEN2ZzFTNDJUREFqRU5wSmx5aXVneWVL?=
 =?utf-8?B?TEFGMWxPVVFQSk1acUhBdkxKcnRVZ3R0SDFGanpvUGQvNUVCNTRTZ2ZPNUxu?=
 =?utf-8?B?VXBuMGhpVHhaWmVUYUhOQUVwc2lkMS9Rc3dyVis3S2R6TER6NEhEbklaaC9p?=
 =?utf-8?B?VVY0ODBpYSt2T21GdWQ3dW5xUUNmQk84UUZrV25uT2J2QVJrTmdORndzbU04?=
 =?utf-8?B?ZXB4L2ZMMGg4VUowNVBkTko3d1FkeVRJZ0l5WjJTZUpjZnZJWU1PY2JyMTJk?=
 =?utf-8?B?NkJQRHFHREZhTXhxM2tQWVk2NkZxYVhNL051VWhhRVRJbXVCRlBRRjUvcjBZ?=
 =?utf-8?B?QTcyRXN5a09PblZYb3hiTFZUVWg5ZW0wOGN1SjlYRGVCMWRjQmZLZ1BLODEv?=
 =?utf-8?B?YS9aenZMUy9XMTBDT0ZyZWltT3psQktTUFhDbUpLY3laUStyMlN2ckhtM3oz?=
 =?utf-8?B?MU9CRURldEd5aFVvL0ptZlNZcW9DcXRGL0dXTTJHajJ1NHEzRjhQMUFkb3o1?=
 =?utf-8?B?OVpmSnB2V1hJVlY3MjlEZnliR2Yzb3dNQ2dFcGlBbDZFNnViaFplQXQ2NEFq?=
 =?utf-8?B?QWVKbkh0K0FMVEltamhzbGV5NU1aYS9TcVlBdDExa2dyaXRxNFF3ZFIra3gr?=
 =?utf-8?B?N0QvTTlaSjFKUDYwNFkxSDlOQmNVV0x0a3ZVY1BKMWNrYzhEQWtHMHpLTXh6?=
 =?utf-8?B?cjlnKzRLcEdHWkIvdXowL2NrOGRmZWZIRWVLQXg3ck94WFM1dG14NmpBdlBR?=
 =?utf-8?B?b00vZkxUaXJEL3IrY25ybXdyRWlBMWU5YUxyaVgxUkFTaWh0NVkycm81bG9j?=
 =?utf-8?B?OWF6SC8wR3lQc0dESWFkZ1NMUE9DcFdpTmxhM2JBVWtYRnZQT1JGWVhPS3RX?=
 =?utf-8?B?TUxzZWRxcy9ITHRZTEJWQTYzdzJBbDduc0pEM1l6NUlzckZMeGlYbFhyV2ta?=
 =?utf-8?B?ODB0V1hWS0tlWjJCd3VUSXVIckcrL0dZNzRBcWVmR01oMXV3c0Z4QVl1WEMz?=
 =?utf-8?Q?6f6dW598Pak=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR01MB6873.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016)(921020);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?U2g5Uy9CWGRJSUV1REhWemdpVCtRVzl5RWYvRm1qZGVGUUsrTmUwdmVIaGxt?=
 =?utf-8?B?RVVFOHZrNkp2ZXIzOVM1cUhNcnBzWWpJQ3U0VC9JQ0hsT1FWMk82M21WdDhO?=
 =?utf-8?B?R0ZNc2t3dmpuTXBTT1ovdFNaUkkvVC9nZythZUE1T0JXTC9GVWdrblV6Y3VQ?=
 =?utf-8?B?NjR1bTdMdVhhODY1Titsc1Bxa0pVUmVJOXArN2dIVGF0WTNZZHpodXJleUNv?=
 =?utf-8?B?T2IwOTdNd3lPdm1nMnNoeGxGbG10RGM3YThZeXpqam5GdmhBcXNMSGNndkdN?=
 =?utf-8?B?dWpjMGw1ZVdnRkRUVWVjYS8vU0hIWDFtdnRZVXJkVmd2OUVQeHlGVjFxNlJi?=
 =?utf-8?B?T0YvNEFhQ0NaNUFVOXNZTVV4NHRDL21vZjBWQjg3RXVYWnZSdDA0S0J3OU1t?=
 =?utf-8?B?RWZoT295Y3RoUDRGMzhlNkh5aXNBMzd1c2ZCNXNQbWdLOCtsT3F6WXo0UmlX?=
 =?utf-8?B?dWdCK1NUR2dpZVFsUGRBczU1cjFhUlJ0WVdhNXpHUWduSEtoc2FmOFcxOXdl?=
 =?utf-8?B?bTZTTE1aMzRaVWlDUVd4TlV1azAySUc0dXd2M2V0c1MwdlJNNUtlT2Z4MVBW?=
 =?utf-8?B?TEhESkhXNGhmWlFTMXhFeExvcW8zUWR2aENuSks3VGhNU0laRTBoaWZTcDUy?=
 =?utf-8?B?bm5vUDBBSnVlQnJ2TEYvQUFINzhsVTBOUGNIVVpqMkFvZS9hTTBIVDRWU3R3?=
 =?utf-8?B?TnVHbm5mYm04bEVIcS9qZEQyNkt3Vlc4NkhZNk5xSU5WL1FuaGdEWmpSYzc4?=
 =?utf-8?B?QWp2dXBjcTM3MXpmKzdnWmlsNEJEQW9KNkNWelU1WEs2UzgveFpEV2NlVGk1?=
 =?utf-8?B?Rm9tSTNXU0tMRVRrWWI5U2RBMndXQUJrd05pRzFDb1F5L013Z0xIeHEvQ2w2?=
 =?utf-8?B?VXRvTmVqY2ZSeWMwajFyWVpqa0EvbEJCb3F1dzNxOVl1UXZ3d0hUSTN3NHFq?=
 =?utf-8?B?cDRnNWdKZnhxdGNlRXVIbVJOaHVXVVM2dnk5VmtvUGhvMUd3MzAySFhYV2tC?=
 =?utf-8?B?azM5RjVjRzU2NStwNGkxcEJ4M2MzcXY0cThKWmo2UVZreVRCOWNSckY4NTJq?=
 =?utf-8?B?Z2g1V3lsWmtxcjFTVkF4eW5jN0RTUklkY1ZsTG82dDhPOXlTemk1UHZJSnJ6?=
 =?utf-8?B?bEdxUVI2Q1kza0hlclRkOFJSNmVkZU5BeVFjSmRJcThUQ0p1QVNDRVU4NDJs?=
 =?utf-8?B?bzdtREkxRUtpMGtZNUI2OEV3R0x6akVOUUlmNWdoVmJma3lJd2ZORGJFQUNy?=
 =?utf-8?B?N1lVcnZ4MEFvQUtYdTBmQXRFMzNuRWxaQXRhc0RGWjVDZGswOGdzZk16SWdt?=
 =?utf-8?B?ZkpEMVJDVVE3dyswVnFPTWZ5K3VZRGlsdElGc0pUdG9GSUpPdEVqMmw1L1gr?=
 =?utf-8?B?RnYza215dXY3dS9rK25HZzlIT0VWaTd6Ynl2VGNWMjQrckY1c0ltbjdPZEY5?=
 =?utf-8?B?TnRLVlQ2d2xYV0pZQmZaRndHMTBGd1JBL1crajkyVjFnZTFqQks2aEl4REhF?=
 =?utf-8?B?VFBEMEVtbFVsbXQ0bHhpNC9vaklwSXN0UXZFNlpGNDN1VTIyRnViMnhJWE4z?=
 =?utf-8?B?NlZocC92eVFiTDVITHZUZUhsd3VCWjJiVGtselQ3TEV0Qjgya1ZJYVVBREo4?=
 =?utf-8?B?alE1OHpzQ0NzenVPZFJjbGV2RGtkQlJMM3M2aENVOXEzU1VWajhZTUpFS1ZZ?=
 =?utf-8?B?R3B2dlZwWFErUzFGNW8yUjVid09LRkt2aUxHRE1DVVU2Y1dzZHJOTm83WC8x?=
 =?utf-8?B?K3FCQTlwdUJSeWlpeVp2Qkg3eEFMYTNXOGU4SjQzbzFldVorUGszWkM5bXVx?=
 =?utf-8?B?SHFXRjdlZS9EdnA2L1JPa3FWWXlRajFEZmFIMTdyRnlkMDVQamc0ZDhqVTQw?=
 =?utf-8?B?bTRZZVhFcGVTZG9KTDE0N2tsbFFYWExzdmdmTTJIOFdET2F2YzBxUE5mUUEr?=
 =?utf-8?B?MXFYL2VqeldlWHdPekVnOWl2cWJKaFFhQ0JidjJGL2RXdk9sTFVJeUwvcWM2?=
 =?utf-8?B?RmIxbHlFZnhiSVhVa2JRdG44eEpramx5T083YlBrbTNIK2FsQ3IyRW1DSmto?=
 =?utf-8?B?VHZ2ZTVJL0tHVTY2UmxlVXNIUXczNDVaak1VMmNyMlNLWWJCTzFiSGtSYVlz?=
 =?utf-8?B?by85MW5OVHRwOE9NNmc1cVFzR3JEdmVkWm1LcDRWVy9PWFd1MXZiOVhGeUhU?=
 =?utf-8?Q?IZEi2Dx1P4/Iwlvvc8zBitk=3D?=
X-OriginatorOrg: os.amperecomputing.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cd932cfa-a8ef-4399-8bea-08ddea7fdcdb
X-MS-Exchange-CrossTenant-AuthSource: CH0PR01MB6873.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Sep 2025 00:21:44.5675
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3bc2b170-fd94-476d-b0ce-4229bdc904a7
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4nW4Fk+1nBfYQlp3I8yi/GoZB45+7DjPeAz8FWQMF2C4jfLs0WMyb2MdCfdJqFN5pO3siU+sq1Dl/R2KP2fadqP0WR29iqiVbNPoQVRZwP4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR01MB6522
X-Rspamd-Queue-Id: C05D1120003
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: 9hj91tncgdwwe135e3njrsf87euif5gp
X-HE-Tag: 1756858908-750707
X-HE-Meta: U2FsdGVkX1/wlQ/4z6mwM0Gmz/gJmTeXf7MyJfu499Ifa1kB7oZe347zp2oQnDXWWUMdX5ajTBgR2m+CFIK8R2K6V1lHZ9CwyQHB5xN2KWNicAuC7glYNdWYlr67lKrJ6Fg7sRyizOSVecUJNKkzfiWop/GU1T4rkLBSTR+fhzmtgz3JDeHlTTaccZlOdwlc1ak+QKevMVYDpXquGpCdXo22cSBpQrVMO3K+f0AvOMaod/EomziveSrQFFO9Hj+WnyJUc96y2P5KuWHcmsQeKo14zAFdweSKw6KwAz0OW04HQKg+5BdRVS5tIoTGYcQkLkNEFz+4nlmNpOQHUTbh8oOdlMoHUN9GURt+qXgHBdQS0mtf3N+4HPqCDaxS78R0JDDKDbvRSIHSJulWyEXKo/+0FEt2ZXhBOZXeZVKAncCt20g/+4hD1JpaghwC9c7RdI/qJG7vkHp1TYmqTrbNgZ2bwJU0UJDtsyTvtU3l0FpZyPtRjudecvbLv2ve3jHZHQld2VOnNyYKVebC536Q8hR3VqOkGjacFdusaXXt3RzNRFEz8cduqk1T2ZfIuqmAz72FgN25Banuq0tCkgmGSQ1ljeOlFa0oVwKILvrXMtXzNJ9WuGlYYrLpxUB919F90ktmETY1Azey8JCtYzwvSf2shKLQqxbySa/ZwzhsHqlkeocsT2l6GEpUUSc2gScMWL3S8CKREG+aLfMfR8tcejrWT1eYOJ38uJiQV0cgrmBX5fc8eHmobPxL3AlMb7H7heGAkH8Y68el3ldeiI5h5ffB6YNi21fU0MRbFyGXfvaGYgCMN9c1OStlFmlwYafnBYmT6x36GZmsjumAp3HVx5Mvx25N2ksA4z5IikX2uwc+0gynlraIn36rwrFedTUmDV6wa6NAWVd7GTDV8nGyHXldtw9LiyeV0hJ6lNau81ldmp+RIHIeCReizdyHeCfErjJOtjnslkhZtXv6SqA
 cpL/C0r7
 jETk8LV8tWfLLoM6BIvx2r9YT9wGT1zLyJJi15LNGNZye1wu3Wx9iZ+rpP+MERqDkdcIo
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 9/1/25 1:03 AM, Ryan Roberts wrote:
> On 01/09/2025 06:04, Dev Jain wrote:
>> On 29/08/25 5:22 pm, Ryan Roberts wrote:
>>> Hi All,
>>>
>>> This is a new version following on from the v6 RFC at [1] which itself is based
>>> on Yang Shi's work. On systems with BBML2_NOABORT support, it causes the linear
>>> map to be mapped with large blocks, even when rodata=full, and leads to some
>>> nice performance improvements.
>>>
>>> I've tested this on an AmpereOne system (a VM with 12G RAM) in all 3 possible
>>> modes by hacking the BBML2 feature detection code:
>>>
>>>     - mode 1: All CPUs support BBML2 so the linear map uses large mappings
>>>     - mode 2: Boot CPU does not support BBML2 so linear map uses pte mappings
>>>     - mode 3: Boot CPU supports BBML2 but secondaries do not so linear map
>>>       initially uses large mappings but is then repainted to use pte mappings
>>>
>>> In all cases, mm selftests run and no regressions are observed. In all cases,
>>> ptdump of linear map is as expected:
>>>
>>> Mode 1:
>>> =======
>>> ---[ Linear Mapping start ]---
>>> 0xffff000000000000-0xffff000000200000           2M PMD       RW NX SHD
>>> AF        BLK UXN    MEM/NORMAL-TAGGED
>>> 0xffff000000200000-0xffff000000210000          64K PTE       RW NX SHD AF
>>> CON     UXN    MEM/NORMAL-TAGGED
>>> 0xffff000000210000-0xffff000000400000        1984K PTE       ro NX SHD
>>> AF            UXN    MEM/NORMAL
>>> 0xffff000000400000-0xffff000002400000          32M PMD       ro NX SHD
>>> AF        BLK UXN    MEM/NORMAL
>>> 0xffff000002400000-0xffff000002550000        1344K PTE       ro NX SHD
>>> AF            UXN    MEM/NORMAL
>>> 0xffff000002550000-0xffff000002600000         704K PTE       RW NX SHD AF
>>> CON     UXN    MEM/NORMAL-TAGGED
>>> 0xffff000002600000-0xffff000004000000          26M PMD       RW NX SHD
>>> AF        BLK UXN    MEM/NORMAL-TAGGED
>>> 0xffff000004000000-0xffff000040000000         960M PMD       RW NX SHD AF
>>> CON BLK UXN    MEM/NORMAL-TAGGED
>>> 0xffff000040000000-0xffff000140000000           4G PUD       RW NX SHD
>>> AF        BLK UXN    MEM/NORMAL-TAGGED
>>> 0xffff000140000000-0xffff000142000000          32M PMD       RW NX SHD AF
>>> CON BLK UXN    MEM/NORMAL-TAGGED
>>> 0xffff000142000000-0xffff000142120000        1152K PTE       RW NX SHD AF
>>> CON     UXN    MEM/NORMAL-TAGGED
>>> 0xffff000142120000-0xffff000142128000          32K PTE       RW NX SHD
>>> AF            UXN    MEM/NORMAL-TAGGED
>>> 0xffff000142128000-0xffff000142159000         196K PTE       ro NX SHD
>>> AF            UXN    MEM/NORMAL-TAGGED
>>> 0xffff000142159000-0xffff000142160000          28K PTE       RW NX SHD
>>> AF            UXN    MEM/NORMAL-TAGGED
>>> 0xffff000142160000-0xffff000142240000         896K PTE       RW NX SHD AF
>>> CON     UXN    MEM/NORMAL-TAGGED
>>> 0xffff000142240000-0xffff00014224e000          56K PTE       RW NX SHD
>>> AF            UXN    MEM/NORMAL-TAGGED
>>> 0xffff00014224e000-0xffff000142250000           8K PTE       ro NX SHD
>>> AF            UXN    MEM/NORMAL-TAGGED
>>> 0xffff000142250000-0xffff000142260000          64K PTE       RW NX SHD
>>> AF            UXN    MEM/NORMAL-TAGGED
>>> 0xffff000142260000-0xffff000142280000         128K PTE       RW NX SHD AF
>>> CON     UXN    MEM/NORMAL-TAGGED
>>> 0xffff000142280000-0xffff000142288000          32K PTE       RW NX SHD
>>> AF            UXN    MEM/NORMAL-TAGGED
>>> 0xffff000142288000-0xffff000142290000          32K PTE       ro NX SHD
>>> AF            UXN    MEM/NORMAL-TAGGED
>>> 0xffff000142290000-0xffff0001422a0000          64K PTE       RW NX SHD
>>> AF            UXN    MEM/NORMAL-TAGGED
>>> 0xffff0001422a0000-0xffff000142465000        1812K PTE       ro NX SHD
>>> AF            UXN    MEM/NORMAL-TAGGED
>>> 0xffff000142465000-0xffff000142470000          44K PTE       RW NX SHD
>>> AF            UXN    MEM/NORMAL-TAGGED
>>> 0xffff000142470000-0xffff000142600000        1600K PTE       RW NX SHD AF
>>> CON     UXN    MEM/NORMAL-TAGGED
>>> 0xffff000142600000-0xffff000144000000          26M PMD       RW NX SHD
>>> AF        BLK UXN    MEM/NORMAL-TAGGED
>>> 0xffff000144000000-0xffff000180000000         960M PMD       RW NX SHD AF
>>> CON BLK UXN    MEM/NORMAL-TAGGED
>>> 0xffff000180000000-0xffff000181a00000          26M PMD       RW NX SHD
>>> AF        BLK UXN    MEM/NORMAL-TAGGED
>>> 0xffff000181a00000-0xffff000181b90000        1600K PTE       RW NX SHD AF
>>> CON     UXN    MEM/NORMAL-TAGGED
>>> 0xffff000181b90000-0xffff000181b9d000          52K PTE       RW NX SHD
>>> AF            UXN    MEM/NORMAL-TAGGED
>>> 0xffff000181b9d000-0xffff000181c80000         908K PTE       ro NX SHD
>>> AF            UXN    MEM/NORMAL-TAGGED
>>> 0xffff000181c80000-0xffff000181c90000          64K PTE       RW NX SHD
>>> AF            UXN    MEM/NORMAL-TAGGED
>>> 0xffff000181c90000-0xffff000181ca0000          64K PTE       RW NX SHD AF
>>> CON     UXN    MEM/NORMAL-TAGGED
>>> 0xffff000181ca0000-0xffff000181dbd000        1140K PTE       ro NX SHD
>>> AF            UXN    MEM/NORMAL-TAGGED
>>> 0xffff000181dbd000-0xffff000181dc0000          12K PTE       RW NX SHD
>>> AF            UXN    MEM/NORMAL-TAGGED
>>> 0xffff000181dc0000-0xffff000181e00000         256K PTE       RW NX SHD AF
>>> CON     UXN    MEM/NORMAL-TAGGED
>>> 0xffff000181e00000-0xffff000182000000           2M PMD       RW NX SHD
>>> AF        BLK UXN    MEM/NORMAL-TAGGED
>>> 0xffff000182000000-0xffff0001c0000000         992M PMD       RW NX SHD AF
>>> CON BLK UXN    MEM/NORMAL-TAGGED
>>> 0xffff0001c0000000-0xffff000300000000           5G PUD       RW NX SHD
>>> AF        BLK UXN    MEM/NORMAL-TAGGED
>>> 0xffff000300000000-0xffff008000000000         500G PUD
>>> 0xffff008000000000-0xffff800000000000      130560G PGD
>>> ---[ Linear Mapping end ]---
>>>
>>> Mode 3:
>>> =======
>>> ---[ Linear Mapping start ]---
>>> 0xffff000000000000-0xffff000000210000        2112K PTE       RW NX SHD
>>> AF            UXN    MEM/NORMAL-TAGGED
>>> 0xffff000000210000-0xffff000000400000        1984K PTE       ro NX SHD
>>> AF            UXN    MEM/NORMAL
>>> 0xffff000000400000-0xffff000002400000          32M PMD       ro NX SHD
>>> AF        BLK UXN    MEM/NORMAL
>>> 0xffff000002400000-0xffff000002550000        1344K PTE       ro NX SHD
>>> AF            UXN    MEM/NORMAL
>>> 0xffff000002550000-0xffff000143a61000     5264452K PTE       RW NX SHD
>>> AF            UXN    MEM/NORMAL-TAGGED
>>> 0xffff000143a61000-0xffff000143c61000           2M PTE       ro NX SHD
>>> AF            UXN    MEM/NORMAL-TAGGED
>>> 0xffff000143c61000-0xffff000181b9a000     1015012K PTE       RW NX SHD
>>> AF            UXN    MEM/NORMAL-TAGGED
>>> 0xffff000181b9a000-0xffff000181d9a000           2M PTE       ro NX SHD
>>> AF            UXN    MEM/NORMAL-TAGGED
>>> 0xffff000181d9a000-0xffff000300000000     6261144K PTE       RW NX SHD
>>> AF            UXN    MEM/NORMAL-TAGGED
>>> 0xffff000300000000-0xffff008000000000         500G PUD
>>> 0xffff008000000000-0xffff800000000000      130560G PGD
>>> ---[ Linear Mapping end ]---
>>>
>>>
>>> Performance Testing
>>> ===================
>>>
>>> Yang Shi has gathered some compelling results which are detailed in the commit
>>> log for patch #3. Additionally I have run this through a random selection of
>>> benchmarks on AmpereOne. None show any regressions, and various benchmarks show
>>> statistically significant improvement. I'm just showing those improvements here:
>>>
>>> +----------------------
>>> +----------------------------------------------------------
>>> +-------------------------+
>>> | Benchmark            | Result
>>> Class                                             | Improvement vs 6.17-rc1 |
>>> +======================+==========================================================+=========================+
>>> | micromm/vmalloc      | full_fit_alloc_test: p:1, h:0, l:500000
>>> (usec)           |              (I) -9.00% |
>>> |                      | kvfree_rcu_1_arg_vmalloc_test: p:1, h:0, l:500000
>>> (usec) |              (I) -6.93% |
>>> |                      | kvfree_rcu_2_arg_vmalloc_test: p:1, h:0, l:500000
>>> (usec) |              (I) -6.77% |
>>> |                      | pcpu_alloc_test: p:1, h:0, l:500000
>>> (usec)               |              (I) -4.63% |
>>> +----------------------
>>> +----------------------------------------------------------
>>> +-------------------------+
>>> | mmtests/hackbench    | process-sockets-30
>>> (seconds)                             |              (I) -2.96% |
>>> +----------------------
>>> +----------------------------------------------------------
>>> +-------------------------+
>>> | mmtests/kernbench    | syst-192
>>> (seconds)                                       |             (I) -12.77% |
>>> +----------------------
>>> +----------------------------------------------------------
>>> +-------------------------+
>>> | pts/perl-benchmark   | Test: Interpreter
>>> (Seconds)                              |              (I) -4.86% |
>>> +----------------------
>>> +----------------------------------------------------------
>>> +-------------------------+
>>> | pts/pgbench          | Scale: 1 Clients: 1 Read Write
>>> (TPS)                     |               (I) 5.07% |
>>> |                      | Scale: 1 Clients: 1 Read Write - Latency
>>> (ms)            |              (I) -4.72% |
>>> |                      | Scale: 100 Clients: 1000 Read Write
>>> (TPS)                |               (I) 2.58% |
>>> |                      | Scale: 100 Clients: 1000 Read Write - Latency
>>> (ms)       |              (I) -2.52% |
>>> +----------------------
>>> +----------------------------------------------------------
>>> +-------------------------+
>>> | pts/sqlite-speedtest | Timed Time - Size 1,000
>>> (Seconds)                        |              (I) -2.68% |
>>> +----------------------
>>> +----------------------------------------------------------
>>> +-------------------------+
>>>
>>>
>>> Changes since v6 [1]
>>> ====================
>>>
>>> - Patch 1: Minor refactor to implement walk_kernel_page_table_range() in terms
>>>     of walk_kernel_page_table_range_lockless(). Also lead to adding *pmd argument
>>>     to the lockless variant for consistency (per Catalin).
>>> - Misc function/variable renames to improve clarity and consistency.
>>> - Share same syncrhonization flag between idmap_kpti_install_ng_mappings and
>>>     wait_linear_map_split_to_ptes, which allows removal of bbml2_ptes[] to save
>>>     ~20K from kernel image.
>>> - Only take pgtable_split_lock and enter lazy mmu mode once for both splits.
>>> - Only walk the pgtable once for the common "split single page" case.
>>> - Bypass split to contpmd and contpte when spllitting linear map to ptes.
>>>
>>>
>>> Applies on v6.17-rc3.
>>>
>>>
>>> [1] https://lore.kernel.org/linux-arm-kernel/20250805081350.3854670-1-
>>> ryan.roberts@arm.com/
>>>
>>> Thanks,
>>> Ryan
>>>
>>> Dev Jain (1):
>>>     arm64: Enable permission change on arm64 kernel block mappings
>>>
>>> Ryan Roberts (3):
>>>     arm64: mm: Optimize split_kernel_leaf_mapping()
>>>     arm64: mm: split linear mapping if BBML2 unsupported on secondary CPUs
>>>     arm64: mm: Optimize linear_map_split_to_ptes()
>>>
>>> Yang Shi (2):
>>>     arm64: cpufeature: add AmpereOne to BBML2 allow list
>>>     arm64: mm: support large block mapping when rodata=full
>>>
>>>    arch/arm64/include/asm/cpufeature.h |   2 +
>>>    arch/arm64/include/asm/mmu.h        |   3 +
>>>    arch/arm64/include/asm/pgtable.h    |   5 +
>>>    arch/arm64/kernel/cpufeature.c      |  12 +-
>>>    arch/arm64/mm/mmu.c                 | 418 +++++++++++++++++++++++++++-
>>>    arch/arm64/mm/pageattr.c            | 157 ++++++++---
>>>    arch/arm64/mm/proc.S                |  27 +-
>>>    include/linux/pagewalk.h            |   3 +
>>>    mm/pagewalk.c                       |  36 ++-
>>>    9 files changed, 599 insertions(+), 64 deletions(-)
>>>
>>> -- 
>>> 2.43.0
>>>
>> Hi Yang and Ryan,
>>
>> I observe there are various callsites which will ultimately use
>> update_range_prot() (from patch 1),
>> that they do not check the return value. I am listing the ones I could find:
> So your concern is that prior to patch #3 in this series, any error returned by
> __change_memory_common() would be due to programming error only. But patch #3
> introduces the possibility of dynamic error (-ENOMEM) due to the need to
> allocate pgtable memory to split a mapping?
>
> There is a WARN_ON_ONCE(ret) for the return code of split_kernel_leaf_mapping()
> which will at least make the error visible, but I agree it's not a great solution.
>
>> set_memory_ro() in bpf_jit_comp.c

Do you mean arch/arm64/net/bpf_jit_comp.c? If so I think you can just 
check the return value then return -EFAULT just like what the above 
set_memory_rw() does.

> There is a set_memory_rw() for the same region of memory directly above this,
> which will return -EFAULT on failure. If that one succeeded, then the pgtable
> must already be appropriately split for set_memory_ro() so that should never
> fail in practice. I agree with improving the robustness of the code by returning
> -EFAULT (or just propagate the error?) as you suggest though.

Yeah, I agree. This one should be easy to resolve.

>
>> set_memory_valid() in kernel_map_pages() in pageattr.c
> This is used by CONFIG_DEBUG_PAGEALLOC to make pages in the linear map invalid
> while they are not in use to catch programming errors. So if making a page
> invalid during freeing fails would not technically lead to a huge issue, it just
> reduces our capability of catching an errant access to that free memory.
>
> In principle, if we were able to make the memory invalid, we should therefore be
> able to make it valid again, because the mappings should be sufficiently split
> already. But that doesn't actually work, because we might be allocating a
> smaller order than was freed so we might not have split at free-time to the
> granularity is required at allocation-time.
>
> But as you say, for CONFIG_DEBUG_PAGEALLOC we disable this whole path anyway, so
> no issue here.

Yes, agreed.

>
>> set_direct_map_invalid_noflush() in vm_reset_perms() in vmalloc.c
>> set_direct_map_default_noflush() in vm_reset_perms() in vmalloc.c, and in
>> secretmem.c
>> (the secretmem.c ones should be safe as explained in the commments therein)
> Agreed for secretmem. vmalloc looks like a problem though...
>
> If vmalloc was only setting the linear map back to default permissions, I guess
> this wouldn't be an issue because we must have split the linear map sucessfully
> when changing away from default permissions in the first place. But the fact

Yes, agreed.

> that it is unconditionally setting the linear map pages to invalid then back to
> default causes issues; I guess even without the risk of -ENOMEM, this will cause
> the linear map to be split to PTEs over time as vmalloc allocs and frees?

It is possible. However, vm_reset_perms() is not called that often. 
Theoretically there are plenty of other operations, for example, 
loading/unloading modules, can cause the linear mapping to be split over 
time. So this one is not that special IMHO.

>
> We probably need to think through how we can solve this. It's not clear to me
> why vm_reset_perms wants to unconditionally transiently set to invalid?

It seems like vm_reset_perms() is just called when VM_FLUSH_RESET_PERMS 
flag is passed. It is just passed in for secretmem and hyperv. It sounds 
like some preventive security measurement to me.

>
>> The first one I think can be handled easily by returning -EFAULT.

It may be not that simple. set_direct_map_invalid_noflush() is called on 
page basis, so does update_range_prot(). If the split requires allocate 
multiple page table pages, we may have some of the pages permission 
changed (page table page allocation succeed), but the remaining is 
skipped due to page table page allocation failure. The vfree() needs to 
handle such case by setting pages permission back before returning any 
errno.

Anyway it sounds like a general problem rather than ARM specific.

>>
>> For the second, we are already returning in case of !can_set_direct_map, which
>> renders DEBUG_PAGEALLOC useless. So maybe it is
>> safe to ignore the ret from set_memory_valid?
>>
>> For the third, the call chain is a sequence of must-succeed void functions.
>> Notably, when using vfree(), we may have to allocate a single
>> pagetable page for splitting.
>>
>> I am wondering whether we can just have a warn_on_once or something for the case
>> when we fail to allocate a pagetable page. Or, Ryan had
>> suggested in an off-the-list conversation that we can maintain a cache of PTE
>> tables for every PMD block mapping, which will give us
>> the same memory consumption as we do today, but not sure if this is worth it.
>> x86 can already handle splitting but due to the callchains
>> I have described above, it has the same problem, and the code has been working
>> for years :)
> I think it's preferable to avoid having to keep a cache of pgtable memory if we
> can...

Yes, I agree. We simply don't know how many pages we need to cache, and 
it still can't guarantee 100% allocation success.

Thanks,
Yang

>
> Thanks,
> Ryan
>
>


