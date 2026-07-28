Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0E94CC531F9
	for <linux-mm@archiver.kernel.org>; Tue, 28 Jul 2026 09:51:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BF2176B007B; Tue, 28 Jul 2026 05:51:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BA3106B0088; Tue, 28 Jul 2026 05:51:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A91FF6B008A; Tue, 28 Jul 2026 05:51:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 79B4C6B007B
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 05:51:42 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id E10F4A1381
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 09:51:41 +0000 (UTC)
X-FDA: 85037718402.26.C215C17
Received: from PH8PR06CU001.outbound.protection.outlook.com (mail-westus3azon11012000.outbound.protection.outlook.com [40.107.209.0])
	by imf25.hostedemail.com (Postfix) with ESMTP id E03B2A0003
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 09:51:38 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=EUmyqSei;
	spf=pass (imf25.hostedemail.com: domain of balbirs@nvidia.com designates 40.107.209.0 as permitted sender) smtp.mailfrom=balbirs@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785232299;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=H5iPCCtO9GtrjU9qw4i5y3K0f3yNxQGGIh7qGOkUk7U=;
	b=l975+gS5NYws7u/f7SCrFvbOhWiXQZCLr6TH43gIv+I+S/7e+HJI3vpytiqpGqYesfC3fh
	4aGOu9Lca0zXNnGlNQnzsHMR7jE3fga5X1qncrMbcRPwefGd1YtnkMW/Uo1Bzn04CbJILU
	lnzyWiO5D77uemuLEYSJJjEw7xO0V18=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1785232299;
	b=tCZy/2ZVea7RoA744si4U2omXP4KOXcczIdh9WTrXAErP4b7loTPLJuCB0PBV5zg5lFg8K
	CtmKyYkZ9OoR+DkMPJl1LxRPvQ+iEnOgbm8R4Ws3CdUqRfAKpS5+biMLjaHmW6MyT8fuVn
	BuEahD5FSkUpT03iTqBEIYjjNi3goSE=
ARC-Authentication-Results: i=2;
	imf25.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=EUmyqSei;
	spf=pass (imf25.hostedemail.com: domain of balbirs@nvidia.com designates 40.107.209.0 as permitted sender) smtp.mailfrom=balbirs@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Z3IMS9Z/k4z+IgPM4M5WYsNneG0G8IbprBBbBe5dhDhWDj8JNHccniX06NgdBHn+yNkyN94x+t/Rz8jndL6kIBZnxv888MVL2i0UevW3U/dIX+6gol8Ey7JcFXd/4uJ+KA2l6oU4HYtb9Ic3TE8DYVaPlnbctvSpZX9b3JkMtg6GRwKWmTsfrmG01Ih4J7mnqPSy/oTawKq8hZMg0U0RnYFb2k3oZfBY5Y0cpuRmbIgWA0+5OgzzVgPcSpBrVCDUNh7X2sFwrgaNv/bUk4u1SMWSLp8IhtbRIpH7usk1MmlDYclvd0fwHIFbsn4ULHNngImloUhsrQATza/5EHyysg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=H5iPCCtO9GtrjU9qw4i5y3K0f3yNxQGGIh7qGOkUk7U=;
 b=r4YzR3LfB2e9h818nIUuaYKTnTOS2quJHRCXyJy4WgT9yG87SnJB1p2FBFe/5pbmXomJcsGwNme+WCPicQJILQlaeGCHkX27hT+yh3+g6wei4WA6Me3fGUclCz28+hJyn/3+5/TktRLKwj+//meM2JTAOeZ4AhDAwFXCTZHOhbV3CWQlGxijf2J5jkNjL1jW4h/2g1Fgt7s3Utbr0nW/nin4yOgVxeg6Dujy8/KDrZmKHbpquT9Yz63468pG9NovYVCVyNkDDjNS2D/O4gTRwjSyxHH/HwOGB17QCiHk2rVP3VwKFbhEfVzOYzURs6x1uF8vHzUtuNSNwGFmHbdpkw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=H5iPCCtO9GtrjU9qw4i5y3K0f3yNxQGGIh7qGOkUk7U=;
 b=EUmyqSei2dqVesXCm6XpEZIIMOrtkSatCJCsdj/A0iUgVcSGwPqJtSXuuNqJSDXYNnWRF+ElwISh8AZxHB9jR6sk91b+oeeXR/gAyLnNtcohfoarZfz3WKuWEQm9FQbyCtoBgiUWZca6NLQd03ENZMXlDiY4V46fnEi3I9FEvjM2Vr47lvCytMzcQpGjH188prwm4UMgAE2QSmdaza1CGX5GpIGRN6UFilMIsfYp/E2eCw7cEFgg3Hizp9E95KOFnwboJ0/sUkggLkCIl4Na/XoX2DYljU82uRadyuCSievosYDDUybBPwgE9S3dCNYYewEdcFQt3+P4HvlVeqrpOg==
Received: from CH2PR12MB5001.namprd12.prod.outlook.com (2603:10b6:610:61::18)
 by DS0PR12MB8248.namprd12.prod.outlook.com (2603:10b6:8:f3::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.245.13; Tue, 28 Jul
 2026 09:51:33 +0000
Received: from CH2PR12MB5001.namprd12.prod.outlook.com
 ([fe80::89e3:6df0:de90:8dfe]) by CH2PR12MB5001.namprd12.prod.outlook.com
 ([fe80::89e3:6df0:de90:8dfe%3]) with mapi id 15.21.0270.009; Tue, 28 Jul 2026
 09:51:33 +0000
Message-ID: <c45eb5ca-2811-4896-82f3-bee34383fdec@nvidia.com>
Date: Tue, 28 Jul 2026 19:51:25 +1000
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4] mm/migrate_device: Clear stale mapping after freeing
 swapcache
To: Arvind Yadav <arvind.yadav@intel.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, david@kernel.org, matthew.brost@intel.com,
 joshua.hahnjy@gmail.com, ziy@nvidia.com, rakie.kim@sk.com, byungchul@sk.com,
 gourry@gourry.net, ying.huang@linux.alibaba.com, apopple@nvidia.com
References: <20260728062832.1107127-1-arvind.yadav@intel.com>
Content-Language: en-US
From: Balbir Singh <balbirs@nvidia.com>
In-Reply-To: <20260728062832.1107127-1-arvind.yadav@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MEWPR01CA0222.ausprd01.prod.outlook.com
 (2603:10c6:220:1eb::15) To DM6PR12MB5006.namprd12.prod.outlook.com
 (2603:10b6:5:1b8::23)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH2PR12MB5001:EE_|DS0PR12MB8248:EE_
X-MS-Office365-Filtering-Correlation-Id: 922daf37-feac-4a8a-f142-08deec8dce36
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|23010399003|7416014|376014|11063799006|56012099006|10067099003|6133799003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	3YUn/dez3CWbgKNY7vj+oNltWYo4NTar1/mq4OpPZ7otdvJf4YOR7xKGbOjufp61QAZPd60E+HfX41sLXnv5qtb3YXplY94907DtyJUhVZe5UkqNqE/XjzIwFuxO2sd4v1dz1lf5ShTK4oSrEhLWoCxebbp+xTCcd5hz/BbxmCy4qIbBdwulJaBRDAQYrrgDUCRTmQSzYz45QR+MxpfxEwoUkvB7IRSuifsJI3SYQ4dQnsLLcKwTUV0yOiCFRDz9VNPOujYvehxNHW2x2c/ws7VPcidq9wGw9Mioozv3ToAwiDYuhYZfiYeqGwMFKMmiB/TFweo5ZKxWeB/C6MmgksSE6UT+8Ze4vmlPvA7TWq764zs1KrW85ZRYN0m7oW+GzeEeiSrprxCJfTVX77w2G+PUEHkX2nkfv8pCaOJytEPt4C6xC+bD7EECm+zbbC979z7I0Iy6llmgixbxJrny3KL6UBNmS1Htj0dOLsjrUTTKaceHPCWM9+31bt248tYuRNmXS9yk5sJZFS5dZ0vGIObmlWKTgJvH6R0bJa7TO8WwcC0Yh1RrbxcBHG0Q5opeEcSwAawqrp0AdXQAMiAWX5zEFY6cxXQSKAw44Wmm2eMS9t3WP+PFE5xN9uWGCz1IoucTOtXLGWCtmaEdLFTLkM9xTlLu0oUGboxWhxx+oeI=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH2PR12MB5001.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(23010399003)(7416014)(376014)(11063799006)(56012099006)(10067099003)(6133799003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?aWlkL2E5Y1hsQi9RT3hIL2RsbVpER2gwY0M4Ti9rR0VLT0JXalpPcjlaOEdn?=
 =?utf-8?B?Ky8vTkNrbTRVOElKekRjOVlmendZVi9oM21ZaHNRZ1I4NndwTjRJNUxsTEFy?=
 =?utf-8?B?dkpDTzFpTU5RVmx4SjZIZ2pZZng0STl5cjJCT2t2ZldlNW5yeGQ0QzQva0JE?=
 =?utf-8?B?ODg2UUQvZ1VQMGtROExTWjBZM3R1QUFJeGRRQTJMUEo0OWEwdk1KNmtTeURR?=
 =?utf-8?B?N2ZHUlJDcGdkWXRLU3gwRVdPSHdsTytaWVVrMG1YWWxTNHdlckt4aEZ1Rjhz?=
 =?utf-8?B?R0d6MW9kQzZTUTIydk5VWjd3VDZkRFFEU1g0SU00dW1OQ2JTdG04VUJDVEhw?=
 =?utf-8?B?UHk0a25CZUgybmpOZHk4SlE2aU15V2p2Z0lUd0V5elByL2w4dEVRUGJvQm9x?=
 =?utf-8?B?OTM1NGE2RHBnQU5xdjZvR1lrZnBpSUNieWovZndNdXZaZCtia0NwWHZLOVpr?=
 =?utf-8?B?TGdjT2t4WC9WWlI5SGJpcm04UVlPYUJ5elJEeXVUOFRBdUplb3MxTnI5YWtL?=
 =?utf-8?B?OWtrK2RGVFhvV1pKWHVWU0hsNHNsWUVmYmIwcUs3ZzlvL1N0c0x5OEo4Rlp4?=
 =?utf-8?B?NERLUEJIK2hDb3hmTzdZazJkR1RJNm4vU1habTBXYlNhU0duY0pEOWRrL3Vl?=
 =?utf-8?B?Mzl1Rm81Y2FHaENld3dWTVkwVFBwNjJheVhHV3l5bk9sRENzZDkvMmorbnhY?=
 =?utf-8?B?czJ0NndkV2xtN2p0bE9qelNnanUwSmxOZUd4Wm5NMzRwcDhlNFZQTkY0TjlT?=
 =?utf-8?B?SUpScnlSQnN1NC9iTUlwU1RFMkJtbG1ldmJKWXgrK3dPYVFrdnlwSk9XQjNn?=
 =?utf-8?B?bnkvRFJaQ2U3RU50TTNDUkE4OXN0WTZLYkxPTlBCUVlaR25HV01pbnIxS2Ni?=
 =?utf-8?B?cWY2dEpQN3Q3dzVMcUNINTNtZE1KV1BTdlhuaWZqeEZlWkhxTXlpVkJtSnFU?=
 =?utf-8?B?eVhRbEc4YlhmZlpRdkU1czhibi96WXlqMDR2RVJGWVZsNHM4bUQ5dUhZWm4x?=
 =?utf-8?B?NzRFMGJPT0hPWmZOakIvZm1WdkhiazhUT0d0TmRPek55cVM5ckZjdGhMOEFz?=
 =?utf-8?B?Z1picUlBcXJSQm5pSlRsVmtPWVV3Z25aT3ZDazZaMjJteGdtT0lMakFXOWJy?=
 =?utf-8?B?NkNjaEM4cDh0Q1N2allBT1dEWERJRFYrZmFySW5Rd3lnZHVzM3FZb0ZRK0g4?=
 =?utf-8?B?a3hwbWQvdXV3MENvTHVCZU43VnUramVjUS96WHZ1c1BmZGxjUXJua0d6Qmtn?=
 =?utf-8?B?aW5LQ3FJaWhVSi9iKzBBMkQ2cS9pcW9TWFpuOGo1TjhnYUtUWnVnVWpaV1FV?=
 =?utf-8?B?N0NmUjZlT0QzU3JkUlUxZnRJRTZCUFFoVTgrRFlmOVUzanhzWE12eFMvcnBC?=
 =?utf-8?B?cnVENE1RcnJ1WEtjSko5Q2x3dE5NcjBkMzZJTXk1eDc5TWpKREt1SVJGcE5j?=
 =?utf-8?B?QjVQbXVYWXFHOEVYQzNjTTFlMlVTa24vUnk1R2tFNVZ3bW9tNFY2ODk4Mm1i?=
 =?utf-8?B?ZEZWUFh1dTI2ZFAyK1dRRVV4WUxBMUhXUmlmUlZwOTAwYm4zOEVGdm1kYitD?=
 =?utf-8?B?TEFpZ21hMEZkVTByZDRBenZoREtHR2RScGYybFBZaTJxS01IeFZxTHk0TjVJ?=
 =?utf-8?B?U0RMWldYekozQk55bUNzaU1yaGwzYWFZTVhSWWFqN0VUSURaWXdxbFY1ZlpY?=
 =?utf-8?B?SkFwVG1sSzRteUhoRUM0YWdzdDE2OU1NMkh2NC8xUXgzQ1pFMlZLNENlYVNK?=
 =?utf-8?B?VDFuYzhVb2tnTytZVG0vRlI2MnE0RFRKNTdsY3cwTmcxejVJaTMzTWdtZXlr?=
 =?utf-8?B?Q1g4RVVoeXNxeW5JR3RoR01neVVkaSttMTRCTGtxMFZUdnRlSTFWTHFVbnpK?=
 =?utf-8?B?UlVoSFJ0TW5TNnFDd1FIVnVzNmVoODRaWTRWenp6WWE1a1BJdUNOeEN0VHoy?=
 =?utf-8?B?WGhaUnNXb3ZvRzVKZXVMZWRzU3FwWllwcCtvcmd4cUdyMGxOc0hiUU83Tkl5?=
 =?utf-8?B?Vi9tam9LdTVTYnF1WmhsT3A5aWd0Z2hlcXRHVUJ6TktqQndYckhrQWYxTHNy?=
 =?utf-8?B?a2tqaXVJTThvd2l6bmJ5cmhIMWpQSTdtaDIvNzhhZUUzUWgzWHQ5SDZkK2x2?=
 =?utf-8?B?OUE3THB6d0tya1RDb05mUWxlNXAyc3NlZkRZc3pLb2tqU0xZbC83MFlMZ1NK?=
 =?utf-8?B?MlNuVzNZQ2RMZzNjNmN6TXFyRlJMUmxUK0JaQzZJTnVSYzF3VHliODV5aWtZ?=
 =?utf-8?B?SEw1WUlDdmppWFNkTVpwREF2N09uZlpZVElWMGhTdUZrNDgrNGlhYTJiNXg1?=
 =?utf-8?B?T1V5RDFYQTI1OElCVjNzYlBjZXNPMnNKWDJ4THpldkRqQ3d0LzhCUT09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 922daf37-feac-4a8a-f142-08deec8dce36
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB5006.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jul 2026 09:51:33.4751
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Uz99fcrlWlHmXYuestrTXlJ2ulk8vWENrvh5TSiEBZjK8HPD9EiYiD38yZ90wHPjAbWbykaH2SpcFKwVejusMg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB8248
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: E03B2A0003
X-Stat-Signature: ekbgibemxm793o5bt7uqychk6m88n6oe
X-HE-Tag: 1785232298-4851
X-HE-Meta: U2FsdGVkX1/oFfcyJTfjPt2TKo1WqQOWtrwoSul6+p1+q8sLVRbiEGhY9loVL/bcgW2P5yNSk2xRhOigZNNdLccIjXol7t1k/2nqmn0Zh8ajw+QRbNPfS208rFFj1TF0gSIkMbgNWnmYA9jhGZcLBNsxX4J4dKV45+Hq37xmuvRKNy/SJ8uS4LXetIc5Y0pDhCx+vNHfe5gpiHyCBjUS1oiZ5UktAzVv27avVmrszMTh+u6+zQQpdGi1gdeVHx9dq817MG6Fgu+PRAIrtxDMNdBo74Yl106yC61nhVhPHS1GyqEfS53nwNQYSAZN432Or6Mp3uGjeEXOO1B2Exc27ou4RnH+52KrXY/cxosheQpCggLVSB/0pLtYZ6pzSXdxC9/ioBgaHAXZHcoyRJC1rJcWrgzebWl8Et1JA2roH/qG5LCp9xH0CDaFTU27Pe7lW79ARH2vYy3jHXfWk4oAEAP57ZUtU9RceN2quiz2zCn3yeH4TmZ0sjPbF+s9vqD8f7ud2YPaC/tYYhVv92YiTm8MSL9FLLqaWUhgz8GuT5LLQ68ME2iJwrfzwwoSiJfmqZEKIidQ8DOiJEFAPdwQIZeKcg9QlVAurXxr01ASm81kAtSndUf7wwFbs8glDjzuSb6BAxqI9Z21G2If23PCGxhLs0gTKhL70U0zU7NAhsa+g98loVpHoGNUk26NBwol/wpQ5Q4krJZeKblVXXbWhkoUz25f/Xf+KUaM5BQkP2Q5b/F+d2gdupaj0StGC3/IZJ5tpRDKTFzRurWUwEh+Wr0XOb6zoNIfscUHubJC1tIqIJCmwWtoFII1cgVd/pt887KF6cn1VPblcEo/WDMWXQJQ5wIadboQmKFX1i6VEpGfkj7FzV6WzeocnFzRFPHZFuJ0asS2w84W/LUBLed/dPzDqiDTAfhspoRjt9uldtQC6sdUMeOFNCH9kREHyZ99Jud/7YEg+OpSFyy4tlG
 zqmuBqBD
 59P7976dfPO9EQKY3ybs/gTAhdefeGdMSoFgfCn+jUg7V8hAVcGKM5eFRWN+ZRtpymfAvBTWVvNBFfYkNk5Yt3U7bC+ejrqQdTZu87VrLEdPvfZnU/uZiUEnsCnI9lwY+e45LaN+QN/izWW2mvmJjZwqV83i8Lp6F/MmvnDmj87HOKj7KLowkwJEZHJccxvPF2bxU8g3yQDdmbMRj0aM0RyJ40oHN53xbM++GDfTfxi6Oxtvbxy5p82BLSsG+xjJk7sdKcvOcp7JajS+8sR9PYPOGbmncxG+pqACU4CbkvKf442rgghH4SDhBrYI1Ew3RBF7Ng6jSa5iDt5bGHdNOFED0yEdUKoBZsxLsojhDUpW1hgz3dJ9kcY6L2jvgHWJGnUxOX0cuNGRxoGudUtSv4RxV1CWOSCnvcoievrdPb1XDeUJyQwlbXAwpORIvc8srciKBYeMJVDh8P48/YNUFG0PG/mLWr02XHYK3DQFnK85AuTHrw1x1yXq92MG3snAO4p/qbViW2DlhHacI2+qfQyGLPIVaRT13P87srmLHH1YnVEAuJNRKAjw0UWu7/Eg3YDSQ38IPyWfNLatd6iGXPmSUqKFSmlsI8YYWY0BaVtmxYOFaI0bp52VhjJYx15c/smeMNBSc3TQVuDqZKVUsvxSPg7yQTBNej8o7kNyDINCRQR5Z9XqAB5KINPJrGTG7D0gmFXH5GNJzBrDEZdahFN2E4BFGHcJZc/LXWrKPI5Ad+CHRxkKlpZlzBFuhzkqnY/OyI+IVqHykj0AthVXhYWmcW4xf0fy6MPkjczplvQlcNCUTZ1EaYMYtJ5PBn6seFdjX34D5sJAzMe8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/28/26 4:28 PM, Arvind Yadav wrote:
> __migrate_device_pages() reads the folio mapping before calling
> folio_free_swap(). When folio_free_swap() succeeds, the folio is removed
> from the swap cache, but the saved mapping still points to swap_space.
> 
> Passing the stale mapping to folio_migrate_mapping() makes it use the
> mapped-folio path for a folio that is no longer in swapcache. It can
> then operate on swap_space.i_pages with invalid reference accounting,
> eventually triggering a folio reference count BUG.
> 
> After a successful split, nr still contains the number of pages in the
> original large folio, although each resulting page is now a separate
> order-0 folio. Reset nr to 1 so each split folio is processed separately,
> including its own swapcache removal and mapping lookup.
> 
> Refresh the saved mapping after folio_free_swap() so the current folio
> state is used during migration.
> 
> v2:
> - Refresh the mapping using folio_mapping(), as suggested by Zi Yan.
> 
> v3:
> - Reset nr to 1 after a successful split so each resulting folio is
>   processed independently, as suggested by Zi Yan.
> 
> v4:
> - Re-read each source folio's mapping immediately before
>   folio_migrate_mapping(), as suggested by Balbir Singh.
> - Add a warning to validate the post-split order-0 invariant,
>   as suggested by Balbir Singh.
> 
> Fixes: df263d9a7dff ("mm/migrate_device: try to handle swapcache pages")
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: David Hildenbrand <david@kernel.org>
> Cc: Matthew Brost <matthew.brost@intel.com>
> Cc: Joshua Hahn <joshua.hahnjy@gmail.com>
> Cc: Rakie Kim <rakie.kim@sk.com>
> Cc: Byungchul Park <byungchul@sk.com>
> Cc: Gregory Price <gourry@gourry.net>
> Cc: Ying Huang <ying.huang@linux.alibaba.com>
> Cc: Alistair Popple <apopple@nvidia.com>
> Reviewed-by: Zi Yan <ziy@nvidia.com>
> Reviewed-by: Balbir Singh <balbirs@nvidia.com>
> Signed-off-by: Arvind Yadav <arvind.yadav@intel.com>
> ---
>  mm/migrate_device.c | 13 +++++++++++++
>  1 file changed, 13 insertions(+)
> 
Reviewed-by: Balbir Singh <balbirs@nvidia.com>

