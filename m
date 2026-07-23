Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 14365C531D0
	for <linux-mm@archiver.kernel.org>; Thu, 23 Jul 2026 19:39:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 99D976B007B; Thu, 23 Jul 2026 15:39:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 94DDF6B0088; Thu, 23 Jul 2026 15:39:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 815FA6B008A; Thu, 23 Jul 2026 15:39:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 498086B007B
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 15:39:41 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id C176A1C006D
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 19:39:40 +0000 (UTC)
X-FDA: 85021056120.19.853A501
Received: from SJ2PR03CU001.outbound.protection.outlook.com (mail-westusazon11012041.outbound.protection.outlook.com [52.101.43.41])
	by imf05.hostedemail.com (Postfix) with ESMTP id DE011100004
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 19:39:37 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=kq2fe0FX;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf05.hostedemail.com: domain of ziy@nvidia.com designates 52.101.43.41 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784835578;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QhlVBWebjsHxbKjRWUVjhPLP/E48OeOUpocEVJqb030=;
	b=J0w2T/RGGBpTUY57OodBrM0gwN2q1ZWX/xfkTkdSmsC1aZ3AwjKEStVUYcw7XJu6GvE6ak
	GGd2Pzqnt0vV/VtGiLiZAIkFavii0JF/ZN3IaLR533XQf36ssUqG8jKt4H8RSV+pcylQHk
	/3/DbSpqsK+cZjQEB0ZLRSuY5S7VM6s=
ARC-Authentication-Results: i=2;
	imf05.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=kq2fe0FX;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf05.hostedemail.com: domain of ziy@nvidia.com designates 52.101.43.41 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1784835578;
	b=NRobeTnCk3blE0zVueI7iYfXdVUH6ld+68rfmptyzwJ1DcNTJiNWM1MBEUT5onKNBd59IY
	E799pQJzQ1mPTsBGFNOrGeedF41k2LVJbJgDdYZ7yja/8iPgmj81/Hlnd3mqM0oU/P7rIx
	WTgZE562DwBaryHrb9dKp83cgkbGaoM=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=gSAKkH+U4ul2qsLGc7ERyicwtvwDuoWJbIhBdCWKUTHQt0rB1UJ9odN4lrRMTv2r4GTTcb9VubuaRQHSroL7ANepXuo5DWThdVHhRdhb2v0uvjaV3c8mzjaWOn6B4KQ6piymUKfHvdGTWACA34hanjyGZhDYwAt4zYrp04RNXfg+T8S85IFNVrHpiOL25uFS1bJcPR3kJbxwfKt+OK2DI+e3e7YLlZ6+eB/DFZV6ZZ8RiSfy/8rSDH2Sfy/8Pz3zuVaiMC2AvFjpiclJi37VrgPUxzQySn+NnJA/LA3V9tWvi1lZHeyyuRJu1Pyjj27M7JbnlUZ0tjHB3B7LDqoTYg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QhlVBWebjsHxbKjRWUVjhPLP/E48OeOUpocEVJqb030=;
 b=QRutxwnw5gBvA8GMQ0CMSL2Yr6KF6C9aFcvMftWX0d8SQ6ICEBPUvBpRou9jWx2nx9D68hhwTNQz3sNOLZSRiPtFLVaHV53yGSK2cC/xOYWD6eaw8HYePy90bJaoishIc1k8IrQXiLjahOkaj+uGxDtxDi4GExiKQ2KqZHLRwbbyFnE0M9fxbrddqqzR28t9181ltGRNNwuJDHAJ4EXpwgRnwKlHOlVkQmSNG1YyE/O/ljBXUa0qvLai+BFW77iZ9BMdM6KRBNMWx+fucwksE1GZPJqsMTeRlLl3mE+K7a/RrnH5qZWgIoHEdvKC+VTjkubcmGKLUnIlgqoxqhBDdA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QhlVBWebjsHxbKjRWUVjhPLP/E48OeOUpocEVJqb030=;
 b=kq2fe0FXnrvd7kNQDPv/fTwiFTnNXUEU9JvFdg49YEwsC0AQA5LwpG2MCFkBZyPFauiqchR9SOeWQ+VOzOo/Q7NLG4TUrdVPtB/VzQVnRzn7w5hMBInRJ3Xnt9NEEFEqsBqghZEhXxfWGksylzH82TgJtWfXE5eqwhjpSNWWxjxrZTfLUb9YWSfcW2+Y42dnI+keycCmDF9DewYTJ4n+AAaoLLNBDRru5PrCkVPjF/AP0NPYBB42unnB33R8KTpIsAvR0BZd1rU4PuaQUCT9w7kU3CCtC3aaj7w1aiKOR7H400iqV0UkkBMrLAWpU7TrokQ4JoO++LZhAGiQe7hwZw==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by IA0PR12MB8088.namprd12.prod.outlook.com (2603:10b6:208:409::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.245.11; Thu, 23 Jul
 2026 19:39:34 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%5]) with mapi id 15.21.0245.009; Thu, 23 Jul 2026
 19:39:34 +0000
From: Zi Yan <ziy@nvidia.com>
To: Arvind Yadav <arvind.yadav@intel.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 akpm@linux-foundation.org, david@kernel.org, matthew.brost@intel.com,
 joshua.hahnjy@gmail.com, rakie.kim@sk.com, byungchul@sk.com,
 gourry@gourry.net, ying.huang@linux.alibaba.com, apopple@nvidia.com
Subject: Re: [PATCH] mm/migrate_device: Clear stale mapping after freeing
 swapcache
Date: Thu, 23 Jul 2026 15:39:31 -0400
X-Mailer: MailMate (3.0r7024)
Message-ID: <70D21F4A-3BB9-45C7-B445-9414C0DC6FC9@nvidia.com>
In-Reply-To: <20260723100846.1880865-1-arvind.yadav@intel.com>
References: <20260723100846.1880865-1-arvind.yadav@intel.com>
Content-Type: text/plain
X-MS-Reactions: disallow
X-ClientProxiedBy: BL1PR13CA0281.namprd13.prod.outlook.com
 (2603:10b6:208:2bc::16) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|IA0PR12MB8088:EE_
X-MS-Office365-Filtering-Correlation-Id: 33e5c1cd-eb64-423b-6553-08dee8f21f4a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|7416014|376014|23010399003|1800799024|22082099003|18002099003|11063799006|56012099006|10067099003;
X-Microsoft-Antispam-Message-Info:
	Q5KvukysfUUoIU46xu0Q1E37IPvRNKjm7D+VZo6iMiiVo7TBCu+7SVUqnmp1ejfqLDVmAwpQZagKHJFXL3tE0/rDEoR4OluGlTiF6t2ST6BjYNOZ98MeWeUxEBUNGXHHWiqDJLs31PXsq080oofMN5kXuKXPc8PrBovniiPZtPdxvvb86cojEGE/+I7tXMQlD4vf8k21J1GUXDG7vD7y3sTlPI7HJBCD3qodqRQDbo9H+CuZtJr179XO+Xjh82c12FsME/gmSmkWJ0Zgolv+f8NakwpuPKZzjtBhlkClK4relNNFGR8RTL55fEGvsna/pSPvPpYMlT4Sy8M14DCxtWpWtlC7sOApsGF6VNI82zJpIZpDgavE9vAXJWw+yeN1XEBOzA0DCEtcTXTkY82MbT3prEzk/ZK7uhYdwfwbfiZwuetQtZdmH00LgYQ+LQElxCpt0Ql46f/oAVNeKMG/KDa8gs2PKNuXchJW7Zb6yZ3p/wpe5BsESnvzJsr+qemJBOb75Cl/HAAdEWFSputqXVT859phT+DwgEZ5i3d5h7xppVkNe76CbZzArOMPamuEYlThNwA7QG6bPzuKnO2/qhGBp0njpg+4WGQmknqJCHfGEzxPc9JGElSSDhI39y9WnaycvLylWRtbgGsogR2Ul3TohgtzlQb8nHOIC5UzJ8Y=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(23010399003)(1800799024)(22082099003)(18002099003)(11063799006)(56012099006)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?P5dPJ3oQ8viKX+bpFbSQc/QkZnbls39PeEGjEWIOFIjqkjrRLogrgNC+xIiF?=
 =?us-ascii?Q?Qlb4Lm7Xhx/+4Mk+2B1L8VPfpiwOeNqKaHVd21c5JjHS77nokUzFY7GrIjRO?=
 =?us-ascii?Q?tBBu48Lc/wtRe8lCj2NRWMgv51CgJtOEjJz1UYgbv6HW/y7jGdjknkvx77sk?=
 =?us-ascii?Q?SWXWYIMsE75hU8XJKbz5HUsjSioaPf89etM/7dEXc40zpQGD3LY+KlKKx8Bd?=
 =?us-ascii?Q?xQMp+ZG0d07gr/lSUUfLt6GspXAQCc9+8JR/a1ItZA770cDe8sCbxyO7GIXD?=
 =?us-ascii?Q?khn05YWknVHk8o/CSsvWFVXTw1Y2cdDE9Nxw7wbwwB9d/ZKlEPQiGlgOM7Hd?=
 =?us-ascii?Q?CgC9fYUaW9mC841rreIMBZ87quc+uV/MXUceZN9nC9ST9GIyCjXHWMWkB3dZ?=
 =?us-ascii?Q?LjGizogOijTqs4gyRceIdB6+WaPgUY49UbMYUppG9L4PF8I1kuEFw35qtE4c?=
 =?us-ascii?Q?oG1KxZfbJTfIZZ3DhNnytHIDAAHcdR3810oQX2lKmHYnrvz5XdQ9dzhJA0uE?=
 =?us-ascii?Q?vw/PzmrpU5/UK7awTWg77I1rbmUIPtu/8ZSDgrRL4X1iyTN2nvp//Rl95m5N?=
 =?us-ascii?Q?lMGJSAOvqWuwti4tZD2UqF7getWx7TYBfYxnATVCK4pgFtVxMgZou/DqmA5U?=
 =?us-ascii?Q?qmn5BqFEMJHVrfgdh3Yog8b3KaDt9wx1P3ge6hd080pak4kfVUitqzFuPoan?=
 =?us-ascii?Q?6GxNelhurLZuAGjolGHD8oFH0R0jq93dLRyA99VTZfdlolrBizh7LQFY1Do7?=
 =?us-ascii?Q?0OoyZP3DKWnrWstQ4VJTmGsNUdpao8Aq3trm6eMZRfJ5MvUCNbmhZ4N2RGTl?=
 =?us-ascii?Q?CaUIwSbac9iMgNrn3VBZSHiAHDRIHyrukTOrC6esi/s2fJDwbX8mpApyYb8L?=
 =?us-ascii?Q?4+AaB+OuQiBDF+BfgfJFHZN2NkmME4W2Yd3TQ4Fv4BFCm2lJ8Syii4MB8s+R?=
 =?us-ascii?Q?YJi13rYcAihmRIoLINN1DvkEYSVnIl/I9W/SB7t5Dc1E9EfT6rzZN2kOv64E?=
 =?us-ascii?Q?2hnwnzCJGjGEVsy7LY0yNGoyFG2uvy9hhvlvEzvZgl0awhHkV5selOFqJAYO?=
 =?us-ascii?Q?A1NyEP7U01AD0L7swlhFn1A2mt71ZxKUYRk/j59FFaBME0sLWLLw8rAeyrfu?=
 =?us-ascii?Q?QqJb11DLXPVllZdah+rnW+01NfqEgtMVeNMvP7JkgpLMTbCBIUulkRpBT/rg?=
 =?us-ascii?Q?zg/o16j18typALqNIR/+i0rqir49u/KJsUkixngI2wTLsav4eYJcZuakw1G8?=
 =?us-ascii?Q?3JmgRX33whC/XeeZArtlhReDqPuro3Ihx+ufdIZ5K3eUvw2uS8ZWnwAHD+n+?=
 =?us-ascii?Q?h/uWjylrwcliZnAtO+MSlwnxdJBo4RgjOXBWyAein+5iRnFB0iefG4DZH0Lv?=
 =?us-ascii?Q?5mxY7pJX2+RF8vxFWSFyux8DentG+hvRMCJ6b5lyH0MzSKu4m99udEob9/s+?=
 =?us-ascii?Q?9D3VFRgKu9gm8He4jEk2rrv9Iu4nIXBZCv5zTCc5XxB22/oYtgYeiTVul2uI?=
 =?us-ascii?Q?5AODbu1lxBPHho1ReytEbojpOcdu0ZOCDbFdu1d8Halu+pEzdy3Nu2mBLGvD?=
 =?us-ascii?Q?fqVclo8pEOQlseUNewsOXIem2UFHCZNjTdIZgHZZhWMIb1rdjvXTSaRJBUPJ?=
 =?us-ascii?Q?51WL85pBOIH/+wLnvN6f0fzqQMInjD6Ofr8kA66rksUGE2+NtN69R1j/wcpL?=
 =?us-ascii?Q?MENJ5hFxTimJeOLG4qUdsSX1M2g3lWQK04uF6qATQs0AyfIp?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 33e5c1cd-eb64-423b-6553-08dee8f21f4a
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jul 2026 19:39:34.0043
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: aKWpnJ8LeW8+qfgtsRc5+hy+r3Pd8qN088ql8TmCdA0qX+kij5S3HpRx6R0ADMuN
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR12MB8088
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: DE011100004
X-Stat-Signature: o8d6t85m4crqwx7u4q5zbkdythj1e5oi
X-HE-Tag: 1784835577-457529
X-HE-Meta: U2FsdGVkX198D27t92thwnyKo0sCuaiukhKn0d3ainr108Ktl3bF1OiclGhxRT+tqTSZV+YNUPRRc+k9SlULLux6Rocc5/bG5YFCOKWyq1wq/KWw7/Ybv0waIc0qQk6NMbyWuvX1T5w9fXJ6bMmSa7faYSMhazhwHEJro3d26sRh0loUaEyxqpdqy0k/HjgYtVrE64oAdzKcw7hrAZXcg4+yOGBOZ1RWjV0eiX7YZLYScic5xPQczqzW/VFM2QkP+qUqTC98p3nfNm4UvUUHo0VK8e4qV7YwujsT0L8WQLSrZwvdiGM4Rlt6jOTvoPy2yM+SRj7pCImNDbbFNsFM9PXfriri7EHD389q+2EcnM4h8ATI64qlffYALO1SnBTG5g6lXbpK+hFwYAAyFTF9SLUf6qroW+2347YgIyu/uNaVoZDSWIP5I1ENORZLELT7qfI+ohEBfVQzo+ySjnsdItHLNKYtdIr0iDdT13HC/br/5DAtmKqiiSUci7SwXTpThG9CJ/avPxxZ4OwaOkE2YcDhdE4pK64VcBOE4V8RWms5bATniGHKs+QJ7ePAYjYNK++vBGrhPLQ1gI785kZhwBCSmEgWBvAkoui3Awy63c1OoXwshHTe0407/NEWl6L+EDX3RGhwopFlQlzTIO71dyYTQyVM+anL70G6/YPcOUPQ1KiPu1sWuUPVNq2i0mj6xIA4J6ZuenttZCo8dt4uDyPjZHqDqoAYxoYwF0G8cfB8ZL3mimr2eX0E9cbPckKxdsbUgQDkYhR/nga4MMPlvCqcYx+BGzmgcTM2Vl6uZ01DAQcoxGBTgBw+pm3KK4cukzf6ahPeXnJRYdYqKvpshf/rdqTCcw4w/mMi3SLX5YXKrt1VZ02Vrv++AMnyYeJxNbEGejTId89TxdeflCZhjQdeNmUVg0g+ZBBu08+0Z4HqlLEjXIQSJsItVCZBUOLU1+g9oMUJSSWEsfIx7vg
 xwaStzYd
 /rQpXjc2DUVXixKd4ha9Wr4xSxI16UWtiAtthI7d6msFwSdOakSSBUOP8VTrhfihYj3XG1GVA3ix31nKPDD10gvV8T1VCD63iRvdWbZHyPh1LUxXgouvvoXBQ3IoHLP4XubE97kjvgiHoKmiFcwiDD6UfCIW0JS5j56oR7A2cmQLyuvLekWe6RY20DBnjs6cw14WN0KXPwM4W5al5iUsnyFEV+K2KtuEXFs05zVM4iHQCW4ifYoS9eUPAAxj0sUbdu2KDzZnBZ/dY71c2fjYPZFTj2drX8B7YL5Qp5RIZbCI8yELcELb/owikvhW2p9QtspfsuUJLtf0Oeic9qVMffdYVgeVMTsbK7RAKcailATtUDUkqbRzvc4FxVR9JcmMqHVcxEozsBwzxscUghESTs95NZ4WKaK03TIxv7ZVXRhoN/5ATvCOl4S9RXbvkb382eJZt1+go836zDl3BrL8ra+p21l/MD5dHs0Jy/g/5Eey176uxK8Eq7y6LtpW2fJsXKq9jhNeHIlf1SIpvg5fRFCMu8WVjKDzoEa8XVZ6M5AD/edeJ2gvuaAoHEMppSO2fHV8CUouQiulz05O75VUjSvTUOntVuY8kFOAdtu2GW3p3ZR3GpMXig1hmCIk8AqKoAIFAW4dP0guGvSc5CnNqnlGzJXUMveA0WtnoVKYpNKNCZIl62tWZKaQp8iv48RPEGnQKbZYlGZdyW8cXg21FmxEONNdiIKRJNqwSGI5VuRCxrYOkv6Emdb2YL/5hjqrtUDAR5aE/KlAd+Zo75e79i/5vDA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 23 Jul 2026, at 6:08, Arvind Yadav wrote:

> __migrate_device_pages() reads the folio mapping before calling
> folio_free_swap(). When folio_free_swap() succeeds, the folio is removed
> from the swap cache, but the saved mapping still points to swap_space.
>
> Passing the stale mapping to folio_migrate_mapping() makes it take the
> mapped-folio path after the swapcache reference has been dropped. This can
> cause an invalid swap_space lock access followed by a folio reference
> count BUG.
>
> Clear the saved mapping so the source is migrated as a mappingless
> anonymous folio.

Why not use folio_mapping(folio) in the call to folio_migrate_mapping()?
Or do mapping = folio_mapping(folio) instead of a hard-coded mapping = NULL?

>
> Fixes: df263d9a7dff ("mm/migrate_device: try to handle swapcache pages")
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: David Hildenbrand <david@kernel.org>
> Cc: Matthew Brost <matthew.brost@intel.com>
> Cc: Joshua Hahn <joshua.hahnjy@gmail.com>
> Cc: Zi Yan <ziy@nvidia.com>
> Cc: Rakie Kim <rakie.kim@sk.com>
> Cc: Byungchul Park <byungchul@sk.com>
> Cc: Gregory Price <gourry@gourry.net>
> Cc: Ying Huang <ying.huang@linux.alibaba.com>
> Cc: Alistair Popple <apopple@nvidia.com>
> Signed-off-by: Arvind Yadav <arvind.yadav@intel.com>
> ---
>  mm/migrate_device.c | 6 ++++++
>  1 file changed, 6 insertions(+)
>
> diff --git a/mm/migrate_device.c b/mm/migrate_device.c
> index 554754eb26ff..fa7fbacac514 100644
> --- a/mm/migrate_device.c
> +++ b/mm/migrate_device.c
> @@ -1204,6 +1204,12 @@ static void __migrate_device_pages(unsigned long *src_pfns,
>  					src_pfns[i] &= ~MIGRATE_PFN_MIGRATE;
>  					goto next;
>  				}
> +
> +				/*
> +				 * folio_free_swap() removed the folio from the swap
> +				 * cache. Migrate it as a mappingless anonymous folio.
> +				 */
> +				mapping = NULL;
>  			}
>  		} else if (folio_is_zone_device(newfolio)) {
>  			/*
> -- 
> 2.43.0


Best Regards,
Yan, Zi

