Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C0807CA1013
	for <linux-mm@archiver.kernel.org>; Thu, 18 Sep 2025 15:50:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0EEBA8E014D; Thu, 18 Sep 2025 11:50:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0238A8E00F6; Thu, 18 Sep 2025 11:50:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E54858E014D; Thu, 18 Sep 2025 11:50:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D3D5B8E00F6
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 11:50:11 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id A71351DBF65
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 15:50:11 +0000 (UTC)
X-FDA: 83902807422.25.932BBB0
Received: from PH7PR06CU001.outbound.protection.outlook.com (mail-westus3azon11020102.outbound.protection.outlook.com [52.101.201.102])
	by imf27.hostedemail.com (Postfix) with ESMTP id C54AC40010
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 15:50:08 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=os.amperecomputing.com header.s=selector2 header.b=lw+2csNx;
	spf=pass (imf27.hostedemail.com: domain of yang@os.amperecomputing.com designates 52.101.201.102 as permitted sender) smtp.mailfrom=yang@os.amperecomputing.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=quarantine) header.from=amperecomputing.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758210608;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6iJgEA0z8IK2eMIQvuiTiZpDwyYYIkVtWtaC66G5RYc=;
	b=Pr+6zQgstiDB4cvYBcffg133ONm13UYycUFVwVLDpdNC3IAQb3stvM03FOeB72fWE/0JDb
	TYaN4/4nYTZirVSUh/tivmh3QO6BpZFcdel/a/gskb9mUVdZoHxt/LMntraO6xETtOczHO
	5WvV52wQrtxaT3K+cwzllGunEUv+SJc=
ARC-Authentication-Results: i=2;
	imf27.hostedemail.com;
	dkim=pass header.d=os.amperecomputing.com header.s=selector2 header.b=lw+2csNx;
	spf=pass (imf27.hostedemail.com: domain of yang@os.amperecomputing.com designates 52.101.201.102 as permitted sender) smtp.mailfrom=yang@os.amperecomputing.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=quarantine) header.from=amperecomputing.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1758210608; a=rsa-sha256;
	cv=pass;
	b=7UCY/H5pB1qSjuctgSQc5uSaHMUI0PhOxazG1xsG+ZO+u8tCPTmrjTDkZpfkbyfTMhHzns
	k3bLPfc+qiOwNOUNeVqGLsVdEdFG4iY8svypG0ihbRplow5zly2eZ3KDharznHzXsUohft
	b9+I1ymKFZtdfwUH5ieZPrBouAg6FcM=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ErieL/+HvJMyZnpnmr29007gVaKx9SwrCBOCzrZCPBV5hUASI/eDKHOHMtP73QbTPdVffA78lo+E2bnv7y25uqZidD77PBGdx/WGvKhKO2YLF2rxSzrcZ9JESlc125AiVhXUI5P12sz1bJwt+g1MeOsilEa3ZGQnwm7X55VmDR+dvUpMuIMXeS4l756fMenVQxyGQr5dUq+9nYhqniQRa+3+pJ/v6Td9w2NmEg/lsEuEAencFtl4SgN7Tyc8p81DOguAim8lSU9mTErRlGTmQ6AMUUNtqJPkiRDtB9o7d8lhRGHdNLe5UzhQarTJBN9BCLP/ZIfjP+euRuaMkg/HWg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6iJgEA0z8IK2eMIQvuiTiZpDwyYYIkVtWtaC66G5RYc=;
 b=gRzuvH1sXRzTb/5+DSXsXZu6ktB44fgzYBMjhj31NBoafs6NMBkGvOUhHSjmnSYoYiRPPp1zdEuaxGl7CoZ/u+0h9a9+G5mH78RBXTmZdj/PYLo9DV7/TkjChtj2CBpIKmWUvEP97PfICx0xCBlSfgTMEj2WqEmfmunJ2b3c+outUhBYVUxjtT09ZfPtbLFVjAePj/KLF2LoXVlkMc3oWLqTE6hYbNWQ048wIFm6L+fL+87C1z2a9bU7odou8ERYdu5rxPEdtxHUXuFclX2OmsDLJkzK2lhr6LbDdqZIsVmg47RZp8KF0qBFdqeeNCebvNRtfCYXr7uySBFXOPIVMw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=os.amperecomputing.com; dmarc=pass action=none
 header.from=os.amperecomputing.com; dkim=pass
 header.d=os.amperecomputing.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=os.amperecomputing.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6iJgEA0z8IK2eMIQvuiTiZpDwyYYIkVtWtaC66G5RYc=;
 b=lw+2csNxYZ1b3fFZ6iIKcYFdmlqGq/ZQZKsB+sldzscydNMTWirDxtkEEX83pV5K2iIB9Zx5nRZMUZGdA/j0vi0K19q9zp2ESoq6/eqtC9bhSbSpFNOXqVt76MQNygm9XzfpO5QsVCJNj1mkqan3KO6ad857dllsU59MAgfMyEM=
Received: from CH0PR01MB6873.prod.exchangelabs.com (2603:10b6:610:112::22) by
 PH0PR01MB6699.prod.exchangelabs.com (2603:10b6:510:74::16) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9137.14; Thu, 18 Sep 2025 15:50:05 +0000
Received: from CH0PR01MB6873.prod.exchangelabs.com
 ([fe80::3850:9112:f3bf:6460]) by CH0PR01MB6873.prod.exchangelabs.com
 ([fe80::3850:9112:f3bf:6460%3]) with mapi id 15.20.9137.012; Thu, 18 Sep 2025
 15:50:05 +0000
Message-ID: <2f03eb8f-f343-4243-bd87-9b9c15d00beb@os.amperecomputing.com>
Date: Thu, 18 Sep 2025 08:50:02 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 5/5] arm64: kprobes: call set_memory_rox() for kprobe
 page
To: Ryan Roberts <ryan.roberts@arm.com>,
 Catalin Marinas <catalin.marinas@arm.com>
Cc: will@kernel.org, akpm@linux-foundation.org, david@redhat.com,
 lorenzo.stoakes@oracle.com, ardb@kernel.org, dev.jain@arm.com,
 scott@os.amperecomputing.com, cl@gentwo.org,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org
References: <20250917190323.3828347-1-yang@os.amperecomputing.com>
 <20250917190323.3828347-6-yang@os.amperecomputing.com>
 <aMv_nhEuCSHKp5J6@arm.com>
 <22732cbe-20f8-4d1e-b086-e34d0f9bbb35@os.amperecomputing.com>
 <960fbbba-8018-4e42-b1fd-6ed96c148007@arm.com>
Content-Language: en-US
From: Yang Shi <yang@os.amperecomputing.com>
In-Reply-To: <960fbbba-8018-4e42-b1fd-6ed96c148007@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BY5PR17CA0020.namprd17.prod.outlook.com
 (2603:10b6:a03:1b8::33) To CH0PR01MB6873.prod.exchangelabs.com
 (2603:10b6:610:112::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR01MB6873:EE_|PH0PR01MB6699:EE_
X-MS-Office365-Filtering-Correlation-Id: dc15db0e-16f5-456a-a653-08ddf6cb0985
X-MS-Exchange-AtpMessageProperties: SA
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?QlhyWE5lK0pFZTJ3V2xwVmhTaG1MT3poNWdab1ArN08rMkNiM0Nyd056TVh5?=
 =?utf-8?B?UHhEa1h0ZlBoRXdpeXBLMmhFUzlRTDBSTjdHOHNQWTUxVGdubmVWMm4yUUp4?=
 =?utf-8?B?TnJ5T0NDTXQ4bDFyWTBwTjhnNWVYcnJNMmVEdUV5aXFQZHpIUW5pK1YvdEkx?=
 =?utf-8?B?elJzR1oxM1o2cTU1TE1MK1hyblNpQlRFMXFVRHF0c3lBQjl1WFVGYURRRjg2?=
 =?utf-8?B?VVAvdC90dzlkVHE1UElqdStHL1U3MjNQdVN2MWJxbEt5eE96cWlUWFB0UnBu?=
 =?utf-8?B?ak9sUTFKOERkc2RGTTNjUjl1eEJtSEo4czMvMGFaa3pYbGlWd0RhdXo1aVpB?=
 =?utf-8?B?YjAvSjJVcVBCVHl4UUZUUmhDTElIbVlOMlZpd3h6YkxPdGZ4OExPdmh5YjRI?=
 =?utf-8?B?Z1NqcVJyeWxKRnlYR01sQmxkKy9pM0dyUGdMbkJob2dhZUV0anJUTUt3cVRp?=
 =?utf-8?B?RVFkc2N2NWc0eVZoMnVMcTRZU2hCSWwzWEJ0blZnMzhHdFFWWGdydHlxSXBZ?=
 =?utf-8?B?cjRYSWk3U0tabzlxUENPUTBuSFVHdnBKL3Z6VkRSMEtHTVBPMXg2TVhnaXJt?=
 =?utf-8?B?eXRXNVQrWXN2cmhPeE4xLzM5KzhVcDNlT1hPRWJoZ1BKOWtGcHVybXBhM2JB?=
 =?utf-8?B?dHd3d1NqNE1ESzZuYkhmMWRpZFNtRXhCc3h3WFlaY1l2SUg2SHBwbDFtemUx?=
 =?utf-8?B?UE5Td1BRak1aQU5WejVRZUI3dkZkdWNYeWdYL0J6V1RCSW9PNk1tbDJuSllO?=
 =?utf-8?B?YTdnU1BpWndXZzZndmo2VXY2eVNyc3NJS1RQMzBTelE0dFQ0UzFlV3pLSmRZ?=
 =?utf-8?B?VjdWZXZNZjZUcDR4eUtsM000eWMxbjEyZmNFUEw0RVJnUWI3VDFBWkNTeE9E?=
 =?utf-8?B?M2ZvTTRXbWpuR0hnSFFRRVhjeng2WmNkRm5CVFhTVDB6TW1qbVZEVDkzbnVD?=
 =?utf-8?B?UlRFaDFvSERzMkZ4YmFRREJvaHRwUWw2aGFVWVo0S3diQzZ4c2JvbmFoZmFz?=
 =?utf-8?B?NDdFSFR0b3J3YnpvWVA1TVVxL1EwWjdEckJRbjlBcUlYbEZKbEZ0eDd5bnpz?=
 =?utf-8?B?eTN4RkxTWGc0RTZBRUpzYkpobENXZVBkV09LbVU1c2RpTmwxQVdNcUQrTWw1?=
 =?utf-8?B?TWI4V1F5c0NkMm0vUnVWUHNrR2xGZlk1ZzhzdTlZS1NOampWNWl0NlJnVkc0?=
 =?utf-8?B?ZnNpeHpXQjhqem9DdVRiT3RjMlY4TGszMFVRTnZKekQvdnpHWTdVWi9XV0Jj?=
 =?utf-8?B?aitJcnNVU3FrRk1kTHYzSG40NVpyMEoyaHRwdks1dERZbEpMeGJibDJZanMw?=
 =?utf-8?B?cElMWVBoN1NhK20vSzY0VkpFL3RIWkhwSHBzamVIQVBBc1JtMzVwSjVDRVdP?=
 =?utf-8?B?Y2JKWWdFeFRPYmNXNU5xaW5OOVV1L0tjdi9sN2ZhQTVyMExlTHI3OVU2OXcv?=
 =?utf-8?B?aUZwcGhVUEpsa09TczhDdWIyVW5ZamRKT2ZrTmF6QW5TdXAwWExGbmt1TzF3?=
 =?utf-8?B?aWY0OS9Dc0hSS1Q1WWxkRW4yVFJack1pZ3pQTkhSVytIZCtuYzNSSVlSeVNP?=
 =?utf-8?B?QVBpQXpnNG1vY3hSVXhoSEtCMGpzRjdibXZPOGM3ekV1RW5pemtCVENndFdj?=
 =?utf-8?B?L0JKYTdUYmVHdXJpeGduZXRVSUxHbXJoaGxuak1vR2xWcFVXL1ljRUIzTFhK?=
 =?utf-8?B?OUU3NU1hSGVSeXNvRkVpNUp3L1VHMDlqKzl2ZGpnejRROHlNbnV5UGtlNHMy?=
 =?utf-8?B?Q1VvMHpUVnZmb2JNRTlEMHp5TjNOQnEyWWdiNmVIWWVObnN6NGJaNGNqbGtp?=
 =?utf-8?B?MDlxR1FDYjA1SDhLZjdiaDJ5RkJvVGRzRmdLb1hmWlB4T1FJbWdSRnJ0cEI0?=
 =?utf-8?B?TWw4dVdSL0VxMCt4cWlLUVZtOFpuaGdGQlNicjZtZitCeGFmbXJKanQ3REkv?=
 =?utf-8?Q?JupioRQ4ig0=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR01MB6873.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?ZFdtK0wxT0xuT25RM0hvZXRQem84N2Fwd05LQmthQmk3T08waUE5MngwQjlR?=
 =?utf-8?B?c1o0b1pzK2dsdFhBenlsNjBmb1VGSHl3akxWVTRXOVN5RlFBU0lOUVRaQUQr?=
 =?utf-8?B?bnVTYVZlZHRZMFJDZndYOGdLa2pSckZXNTV3a0tQZmJYTm93WGhqbWNjZVRM?=
 =?utf-8?B?Nm1oeSt2MUdnYno0L1I0SXpwVk5Pd3Z5RkpGYjErVEVZMUJOR3FGaVh6c3Jr?=
 =?utf-8?B?RzhCM29CaVFmUFJFK29UNGdzYm5RT0k3S3JaNFRHV1JoWElCVkNac1I1cXhy?=
 =?utf-8?B?aDdDczNyZmJ4b2l0cUhxeUhveGpmcElVZ3JvUU9BVSt6MEtVVTBNQ3RSSWc0?=
 =?utf-8?B?YXpCbE9QOEREaDAwQnlYSDcrbFpzZE9DNmU2aVBTNFVrNm95RHBPakdKeCtL?=
 =?utf-8?B?NlgzUTMwZWJJL25YcVlMT2NaRXJXZWRYTDBkdm54ZDdBcmVxMkRsYkt6Vjly?=
 =?utf-8?B?cXhkZ1hrOXRqa1FkU0trb0JqNG41c1FCZ21tZlVYVjBMNlJCemY0M2c2VU9p?=
 =?utf-8?B?Z0pVU2hib2xaR3VGamtLNnRRRmtpS2lERHJ6OGZYU3JweGM3d2ozOWV2Qjl0?=
 =?utf-8?B?VWxPME5CSUl5UTFtM3R3U0F3ZXpqdGZKaS85b0dWaDZkQUpHcTBIVjRYQVJh?=
 =?utf-8?B?NVpZK0tRQnRrODRITXgvcUo1WE1SRlREU1JUZGtLS2VGc0NwbSthbTZ1d1pB?=
 =?utf-8?B?UXZ1dnp3WjZsUmtlODg5SjlOQ0duZUdQdU9sS0xlL3JhekFxWHBKQjhwY0hl?=
 =?utf-8?B?TDdLUzc3ZjdIeUhUQmJjSE9ydnlOWHZHYUVWZEY5Ky80TXJmUWh0STdldFJW?=
 =?utf-8?B?Rll5WmlWc1RraTBIcjRFdkFZeG5pdW9Lc2VHVmw4ODU3UU11NXNIb3NlclR4?=
 =?utf-8?B?NnFVNGd2a2gvbnlJVndwTk5QOHp5eUNtYlVXODAzR3pMSXhhaW5JS0NzSmxi?=
 =?utf-8?B?NmhmWXNzOVJGNFVHOXh0NkFzRm82VmhqRDg3THJJMitVYVZLZUtyMHBCY2ZQ?=
 =?utf-8?B?b1NTYVZmakpBUDZLUHRuU1J6QkVsMHBSYVpYSU9kcThRZjdzSENVUVY0Rjlz?=
 =?utf-8?B?SE0ySDhmVFU4NkxzZHE4U1dITGVaK3RmM25aUVd2dWs4aTR0ZW5zS05TcW9p?=
 =?utf-8?B?d0dlZS9NNUpNUURkOW1sTFBDdkNJK0l6WWhjcFoxNlVweXF1dVBuR0YyU0R3?=
 =?utf-8?B?WU9JaFBtdWN6QmpFMWJ5TE8vRUo3aGxFSGl2OUN3Vm1JOVJVVU1UamlHMnNJ?=
 =?utf-8?B?M1lOYWZWZmF2Z0owcUE3VEl1Y2x1aUxtMHVCbEVaZFlZVWZhTFZETm1ob2FJ?=
 =?utf-8?B?NTIvL1BFa1Q3VkViMDBWUDVCRHRXbkFBUk5LVjUxdTBqSkFoc3JiOGVUc2Np?=
 =?utf-8?B?UHZNa055aERVM1hzZitEcEpuY0ZpVnlERmdBV3RJU2dwMkxvM0dENkU5aEgw?=
 =?utf-8?B?NXlQa3hRRUJBUkZLQzVaN2Z6MkRicjlKdzc2RWtLcjVyYkpSZ0MxMnBnVXdm?=
 =?utf-8?B?Z3p0RUwyeENEU2wwS3BkMU5DRU9nSFZMMUxZUzBhWGFidWZ0QUdqUzJ3Z05n?=
 =?utf-8?B?MFhaZVZEZkdWSmQxdGwrM3dFZ256M2VHTnZWZkVuZ3d4Smo2WnRKRWpGMXJk?=
 =?utf-8?B?d3BLSklEdWlBSEMzcGxiR295bFY4a0hhVEt5Z3J4cFc0cWR2NlFBL0ZaQUxw?=
 =?utf-8?B?MUlRNmdIQzNackNkallkdXNFbXhlNy9tM2Z1T0dBSUFJRDBpUUU0ZkNjOFdF?=
 =?utf-8?B?OGFrVm9yOGNPdnpER1Fzb1BVV0crQ1oxWlIyWGJRRnh2Q0R1WXlSeHZqYkow?=
 =?utf-8?B?Z1NhSkNnNmJ2TW84Tk9QcGliTVYvNE93MEZBRkcwQ0JrVkVEbDFpcmY1VzdG?=
 =?utf-8?B?eVljZzlQNlpOZ1VWMEc1WENlMGxaQ3JEVitCd2lBNzZJTTRtMDRua2ZaU2xO?=
 =?utf-8?B?NytVeDNiM0k5TE5vS3VNTTB4cE5aeGowV1hNd3lLdDByU202TDFhN21JNkZ3?=
 =?utf-8?B?Z3VwSjBMNnkzWjhUbVV2cDVjM3dxbms2dldoUGczYXMxMDdwdWR2dWhIc2Zy?=
 =?utf-8?B?NHU0QjFnUStEMkdNalpoNXFLWUNESFc3d0ZZVmNNT2NoWFZ0ZTJKdzV3VHJB?=
 =?utf-8?B?cm5JdmVmb2hqYTVIUXFLaWk1eVpPZXZpRGhFUm1QeHcyTXhCeFdodXFnN1Bk?=
 =?utf-8?Q?KUIZbj+NgJZro2ifZo3Zd+Q=3D?=
X-OriginatorOrg: os.amperecomputing.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dc15db0e-16f5-456a-a653-08ddf6cb0985
X-MS-Exchange-CrossTenant-AuthSource: CH0PR01MB6873.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Sep 2025 15:50:05.8002
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3bc2b170-fd94-476d-b0ce-4229bdc904a7
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5SxldrxMEZ3HHLO2jBvYds5iJnAu5ClInSZKqr4f9RBV/NnFrvKxZZU4jUNcJmdXPyo8lwhX4ETB1mot7P0eUdLS16bo3tcdZW5HvPsWCDY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR01MB6699
X-Rspamd-Queue-Id: C54AC40010
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: censzbeeeqkuofsnefuxqtqcusxfp6i5
X-HE-Tag: 1758210608-124099
X-HE-Meta: U2FsdGVkX19x3NW+vpXtWEhr1KHz3si06OlHXeoGJsZNbMmJpGu+SAo9JmPz/F3KlM70KC0idUrFi9s6m5ZRk+Qmb3Rg1GaI8qxFPayrN6IzaR3bLXOS7mldLDeDQBTMeFPhrya9apQzkCoFl1c11ftGMfgCfrviEbOLj2tq7U5bvIoV1N/6XLceU0WG4+AQ5Gw9WLKBgv9rteGvxMp//jhntqpjtuMHce+RZQpS1b1xtT9Glpgc2IAvXI0H/EHu5Ul3nsklf8TcfuAIYS2yz+/NHR2EY4qqPoVLJ0u6B8wO44P3VaVDVb30YIfbr20KMb7ESbnbLlf1F30r6yKDecUX96HRR0ptaP83vAqoZpb0SLe0vSNQa3jvnitea4Soh9MwQbw8sGj+K4CADc4pLDwPwaniGwFYAxwS0rAMwNqnTzQ/gpXvBaLVJCfypAsI2NAoqTYo7zZ3ePyBFukQgFuphi5Kh4LRa00b2Jleu7By5bnBq+GCoStOJzGVHbIE7ABr/p1HBe8Y/mQ9Qpquubngv3661Lfy/II59T02nFInHn6oaIoGRuF0Ls2dpgMPalOMUatMsJZgAalMKVjq1BH54ZkFbVqn7zxK7WRkPcrC++Suy8n6NlmXs9C5T7+IpGDY/OAzK/EnltMRO8GaGJ+9YcKjocqe7ATG1nBPqgJI2Sq3pHHe2AQihnea4Ov7RdjqZb7LhlBnLTWPdjknFHygX65ts4YZ69ZmY+n7jtwqfbXrxDpP/Cno6SW++pCOU9w3E4kFeVcoEePAqxmNOlZwTr4/dZwgjzdnKI7Wd+poB9JfjL2EBJLMJ4J+ZaTH7uT4gj2+7TTr3hnI/bBUC93ISFEQX/Crv3iJFpf+t49BILriq0VZnBoDzi58W4rrVEv+GkfxlOZFqR+Lwkh7LodyN9fo1rGGnxl9yhjYkQpn+nupS/9YUCEdVjtnl6KeQsLnxB6EjfmrhCtgVfF
 Auk5B4qg
 AZ6FrDD957pnA9aow53coXAmkODHWvfoXhN0MvexusJDwtKmJQ5Ee94BeJWPQiQpSxDZ7cH7Ybbd+PkEW0krX/AjUa9pkmxb4UtylCxllqffwJaQ9A0TupZfpcRi+T/3ApjZt3p3ODZvWxcH8/mI1F6nsi2XoOc5zdA7uMrwjnvxUZ12QzglhNh03x/FlB2pJs8ORcvpOuE7bg00b+7d6GOML0bIK6DMKLqL7Q6QOVHcayHKHuK3BAhacEBUBPg9Gd7kd1hAl6IhLsgqXgr+V4ZK2dC/kMpVfwYoMtozGlw0aiaMLZz2QZ+E1VROjMutlZu74FxF4vmFbEsi8SWglFjV9iAnjdyViFVKTvZOouqMRV2eaaPer/FOUdo4ukcWt+4Z33DKlrZjUbxED3pG1Mlsmx6wZdIHgTALIcXFKxRs4/Ak581uwP4VwngKRnBaEfT31OiusOY12kaHTgFuPU1qRO/q520SKBTpxtq4NPBRETWNtNrwsuJQUXe6BqF3NUj/vKzOrE+2e89az9hxlhtPfAm9AgROoXD6OX1pCzxBKE6IKrR2sg4tAGGgYC6RvmJmZGoDm0ggsAtI7DJNgOi3ax39yQYhHK/soHK0auXvZZtfrP2xMpRVfUIAckLdJZhPEew9xjJ//4NEmsBwRiSeRMugCl99yR4Ffc1Z5bewZOs1Yra51vfGRfElZl3HGwbYhYqv8Q5mO1jJJ9GY9ax3vCN9e2iHRVVAWjAj9mYKgCNyoysbXHfL/qnOwWSEkPA9P
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 9/18/25 8:30 AM, Ryan Roberts wrote:
> On 18/09/2025 16:05, Yang Shi wrote:
>>
>> On 9/18/25 5:48 AM, Catalin Marinas wrote:
>>> On Wed, Sep 17, 2025 at 12:02:11PM -0700, Yang Shi wrote:
>>>> The kprobe page is allocated by execmem allocator with ROX permission.
>>>> It needs to call set_memory_rox() to set proper permission for the
>>>> direct map too. It was missed.
>>>>
>>>> And the set_memory_rox() guarantees the direct map will be split if it
>>>> needs so that set_direct_map calls in vfree() won't fail.
>>>>
>>>> Fixes: 10d5e97c1bf8 ("arm64: use PAGE_KERNEL_ROX directly in alloc_insn_page")
>>>> Signed-off-by: Yang Shi <yang@os.amperecomputing.com>
>>>> ---
>>>>    arch/arm64/kernel/probes/kprobes.c | 12 ++++++++++++
>>>>    1 file changed, 12 insertions(+)
>>>>
>>>> diff --git a/arch/arm64/kernel/probes/kprobes.c b/arch/arm64/kernel/probes/
>>>> kprobes.c
>>>> index 0c5d408afd95..c4f8c4750f1e 100644
>>>> --- a/arch/arm64/kernel/probes/kprobes.c
>>>> +++ b/arch/arm64/kernel/probes/kprobes.c
>>>> @@ -10,6 +10,7 @@
>>>>      #define pr_fmt(fmt) "kprobes: " fmt
>>>>    +#include <linux/execmem.h>
>>>>    #include <linux/extable.h>
>>>>    #include <linux/kasan.h>
>>>>    #include <linux/kernel.h>
>>>> @@ -41,6 +42,17 @@ DEFINE_PER_CPU(struct kprobe_ctlblk, kprobe_ctlblk);
>>>>    static void __kprobes
>>>>    post_kprobe_handler(struct kprobe *, struct kprobe_ctlblk *, struct pt_regs
>>>> *);
>>>>    +void *alloc_insn_page(void)
>>>> +{
>>>> +    void *page;
>>> Nit: I'd call this 'addr'. 'page' makes me think of a struct page.
>> Sure.
>>
>>>> +
>>>> +    page = execmem_alloc(EXECMEM_KPROBES, PAGE_SIZE);
>>>> +    if (!page)
>>>> +        return NULL;
>>>> +    set_memory_rox((unsigned long)page, 1);
>>> It's unfortunate that we change the attributes of the ROX vmap first to
>>> RO, then to back to ROX so that we get the linear map changed. Maybe
>>> factor out some of the code in change_memory_common() to only change the
>>> linear map.
>> I want to make sure I understand you correctly, you meant set_memory_rox()
>> should do:
>>
>> change linear map to RO (call a new helper, for example, set_direct_map_ro())
>> change vmap to ROX (call change_memory_common())
>>
>> Is it correct?
>>
>> If so set_memory_ro() should do the similar thing.
>>
>> And I think we should have the cleanup patch separate from this bug fix patch
>> because the bug fix patch should be applied to -stable release too. Keeping it
>> simpler makes the backport easier.
>>
>> Shall I squash the cleanup patch into patch #1?
>
> Personally I think we should drop this patch from the series and handle it
> separately.
>
> We worked out that the requirement is to either never call set_memory_*() or to
> call set_memory_*() for the entire vmalloc'ed range prior to optionally calling
> set_memory_*() for a sub-range in order to guarrantee vm_reset_perms() works
> correctly.
>
> Given this is only allocating a single page, it is impossible to call
> set_memory_*() for a sub-range. So the requirement is met.
>
> I agree it looks odd/wrong to have different permissions in the linear map vs
> the vmap but that is an orthogonal bug that can be fixed separately.
>
> What do you think?

Yeah, sounds good to me.

Thanks,
Yang

>
> Thanks,
> Ryan
>
>
>> Thanks,
>> Yang
>>
>>> Otherwise it looks fine.
>>>


