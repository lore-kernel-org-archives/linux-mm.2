Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 69046606A330
	for <linux-mm@archiver.kernel.org>; Fri, 13 Nov 2026 20:17:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=AowXNYq4
Received: by kanga.kvack.org (Postfix)
	id 9935B6B05B2; Fri, 13 Nov 2026 15:17:25 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 96AFF6B05B4; Fri, 13 Nov 2026 15:17:25 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 85A9B6B05B5; Fri, 13 Nov 2026 15:17:25 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 5F52B6B05B2
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 15:17:25 -0500 (EST)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id D1CD4C0164
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 20:17:24 +0000 (UTC)
X-FDA: 85431205608.03.5FE5BEA
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2089.outbound.protection.outlook.com [40.107.243.89])
	by imf10.hostedemail.com (Postfix) with ESMTP id 0CF10C0007
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 20:17:21 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=AowXNYq4;
	spf=pass (imf10.hostedemail.com: domain of ziy@nvidia.com designates 40.107.243.89 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794601042;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=G6AjPPaW1Uh1b+/RaVrkgkTQoJfdkf9vgkA2hrqyGCk=;
	b=HUTW2DOBd1zsUwR0eY6e+6a5ClWuOOswD59AlPZfrkCzr9/hfdv7A+joTAao5YGQ+iWCL6
	Z6pQb/rslpX0n+t2ICeBWGFXJuqEvfr+2ddOm8yDxQcO/DtSSnL60/l1t5PB2rOt128yfi
	3/fTMUEq9oS0QGOzPIduHlE8w5AVSZo=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1794601042;
	b=Zn8qh6ajLwTC+8LQpVAThfMKsryUec7ssarxmvLI4dsP2nP2Jr0Vx0XIR2Wy4dVooi5CDq
	wtRrdSLc9BE2Zpv8yQ8lFn5ZUngMUKhInl7O3xt3vy9p6r/enXY85kT0XG40lTGW7iS2/A
	Y4GMhveqh5XV6Ri8pc8VfDzCqD6bKL0=
ARC-Authentication-Results: i=2;
	imf10.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=AowXNYq4;
	spf=pass (imf10.hostedemail.com: domain of ziy@nvidia.com designates 40.107.243.89 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ZRmMWkfGk0PeKI6/z/wHTwaWXMmw4pCwn6Fe3TC+M9KqGc87Vp6+GdEIEkcAIvV7EyHv66FLKDnn1jZJhg07ErYL0ARqrcrIQz2/M+Zh1aM88wtpNqkTRfTRNFeTSleo/1QooJ60NFmjHvNdVC7yYaD92x5yTKHbGjFsAwXPBeK1eskPclZMFFdMzNjZsF07Tqfc2FwyUy6bqXJk2tjZcwtXaa+jRbR7QRTq9xySWcgjgDDJZuiYWbEdNhE8eIX99KUjEpI1d5j6A19tPtJG8L+usMoWP9izePiO5UkWHkyXUrR5Tqig8Z2hEPNggpRh+5J/ttsazv3zGRPEpwlL6g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=G6AjPPaW1Uh1b+/RaVrkgkTQoJfdkf9vgkA2hrqyGCk=;
 b=R4a4fSlMx9m2vq09z/+CtQMso6p8b0x2OG/wJMaZrCMcKQOrOXvvlEuLoILqOoMpTk60KEAKneQ5JJvxIFvjAn0MYQtk+D53VPNAaqtb9U3qUh9USOuSfKVmW91uxar04sVoZYJuaMJNlFFv3jSmL2U9lwM1VQaxLmpZBJaXz1Q1QOHWLaouTkpxAmJIdBKVGxUOwBdcWTqDcp1iWJkMRhYhEZkY7l2stjWF8LeAiE+Dst751W2EFcPuW76jombrc9wMxi/m5CeMaghAHPX6aQaKMrh9MEnfzm4X+hJuTKFJQBddGied+JsY4/HukAMzf4SflTLJwZFbB2lj1EgchA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=G6AjPPaW1Uh1b+/RaVrkgkTQoJfdkf9vgkA2hrqyGCk=;
 b=AowXNYq4dd2pSujVFrGRVlPLbREZMdW5eYrShZc4+BdQerfGe8lrnKOyQ6cBS3gPHxFPmtLKE8zpLSE+P4zBTC7GUUTToVJlFOIIBbWeefCIhGhFy5UqarOdcSjyzL6cODErgiM9h1wecBzWwvS6fWao34paJA3S1zXsonORCOnn6qV8/mesyS4hl78JNemOfugLXMTezexKiwidTt90AyyIb56A1uxSry9Sc7Z7GCbP8zyS+CFrb9KhBXC8ulDs5/DReJBvvu4FuvVMDCvPQ8tCaCRgmBMfWuFWla2AHn1N/pB81QPaMPMZqPTVBGKPmLHcpUwPYPaKIlyvs5C7kg==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by SA1PR12MB7410.namprd12.prod.outlook.com (2603:10b6:806:2b4::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.8; Fri, 13 Nov
 2026 20:16:36 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%6]) with mapi id 15.21.0615.007; Fri, 13 Nov 2026
 20:16:36 +0000
From: Zi Yan <ziy@nvidia.com>
To: "Gregory Price (Meta)" <gourry@gourry.net>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, kernel-team@meta.com,
 akpm@linux-foundation.org, david@kernel.org, joshua.hahnjy@gmail.com,
 rakie.kim@sk.com, ying.huang@linux.alibaba.com
Subject: Re: [PATCH] mm/mempolicy: ignore a bind policy whose nodes have no
 memory
Date: Fri, 13 Nov 2026 15:16:34 -0500
X-Mailer: MailMate (3.0r7038)
Message-ID: <3A1D94AE-CAAA-4DB9-86BD-CF11012B276A@nvidia.com>
In-Reply-To: <179460086396.482102.9206100238305098014.b4-reply@b4>
References: <20261113192642.2618878-1-gourry@gourry.net>
 <D1684A69-FC68-45E4-8349-9D5E5A327053@nvidia.com>
 <179460086396.482102.9206100238305098014.b4-reply@b4>
Content-Type: text/plain
X-MS-Reactions: disallow
X-ClientProxiedBy: BN9PR03CA0772.namprd03.prod.outlook.com
 (2603:10b6:408:13a::27) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|SA1PR12MB7410:EE_
X-MS-Office365-Filtering-Correlation-Id: e567ee50-32da-49d6-bb6e-08df41c30472
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|366016|23010399003|6133799003|10067099003|261022105027099003|261022115727099003|261026140227099003|261021121427099003|261028144727099003|261022075727099003|261026121527099003|261102123227099003|56012099006|11063799006|5023799004|4143699003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	Z3rzyiXhc2l9BsjS4Udv1E32OLgW9dhdqJqZKgoAl66RMDmn0GSk62v+y9xkpvTAJYtaNQt2rxBqem6LMNQMWuOBD0h7pBDMLZWo37GviM1nL3LAmVrYOkvkXW+Iq4q3EOJ9g6Lm1+5rfe3gNdWy59in9CfMmHQ6m9UDSqVX7Ed2Fis7y2SINFhzPJkxqNF8YbgzKVkw1cp0XPGfI2EF2rnjlwo+unX3rhBw+b/fmLRuq9d5MGFc14k57hLp7dM58EgcuvsYqtTXKVTOJkvSIjHeEjsZhSKGavZm84arBT7QFHHFaJpSYngEkiWKniaPUb5qcuajWAEKKWgbUNtjtBVEYQnzpYW2WmYEIBXSXV9X4rk9Bj9gj9Hv+1Tow/3leMeBxWSbLmtTqcg0umAQyWMe+0hUrEh30tGFYAwzeFCxML7A7uF8ja07jKLwPLQNcA2HZspA5LA0bCMIjKL0/ypYK0fZKunmbqHxiVHlTA+6FOh2NbWELyF8iNWFSfoU0QZwMZGhoJv7g679lVUNkv9qveDj5dfWWqIMTGxGoZ/ZTz3yuzBYSL4t1XKaxU3TDIVxxTs+M4oaktG9pZhbyzYSPjDR6DOXCjoklDJdXpGmHts3wnJSI8izIW6mRLtAERU+qMsvJHCFVLl91GaVfFlZaj6x2Rxw/yiGo3dwVPQ=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(23010399003)(6133799003)(10067099003)(261022105027099003)(261022115727099003)(261026140227099003)(261021121427099003)(261028144727099003)(261022075727099003)(261026121527099003)(261102123227099003)(56012099006)(11063799006)(5023799004)(4143699003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?di+miQg/toAlOwaoeQZjKwZrHHQnNsNmozMN8IBliX2m9a4ituI97D65gt4N?=
 =?us-ascii?Q?eODrzg/tD/8UIcwiM67lsTpeWxtFC2tB/z5eQDv5ZrwTPtgx9n103BMYqIHT?=
 =?us-ascii?Q?b9mrplwQSUe/Iu2K+W/Ut5C3p4dwK1aDoLM4DeZS0qjY4oGgrNbh0pJbCM3x?=
 =?us-ascii?Q?/1ya76sZCHNS/AoghDBvhmSijFH044B20ujkWhb8kFKqNMpX07+CS+mwwdly?=
 =?us-ascii?Q?9e7efuJ9/ZRTShAuZ1CkxgShe3PawZppvnEFpSBWiRRfMVn//3Nt+jxb0tQJ?=
 =?us-ascii?Q?A33yA/Fpcv6DwhcVH0XZKBn+CwjDkqTDbuknpy5aY3L7957zFUhwylOWhhbT?=
 =?us-ascii?Q?oXpHseHnVG1Vi/Owf23ZOXtwueruFMqvS6dfMvkaJbVb/Vd1EekNNqPKupLX?=
 =?us-ascii?Q?hEifAOCiOp+pSmD9gd7gkijI/iTmZEj/OGSzRgrahUTBeFRUhZzumbeSjm8F?=
 =?us-ascii?Q?W6D/uaZOSxBvReEA+SmZz4Y4Y/0wupLQn2M3cTyEVDfQk0rJSzypL0tMISUV?=
 =?us-ascii?Q?P4F6q1pwAC//K06d8AjxVuO9/sEZLTrYKzCssN4hdYAkr/23MGBJaiVGLxGN?=
 =?us-ascii?Q?wBaYT15QplzUU7Fq0W3oAPnEUVxW9as4MxWT3UVGormWqlkYDADqrPyEtPsh?=
 =?us-ascii?Q?YuhBVH0ayKJonJBm1rdXvPR5QdwHoqfX9Mv7aQjpCu/2Dst0utwoeH8rXktL?=
 =?us-ascii?Q?6NhYv8817xoe9YQVPo3MZoVNVrfjKwBRBWE9bigo9UOdKHNd7yNeLro+iejv?=
 =?us-ascii?Q?FegZPo7hBwTvUC2ucDDGnOJA6yipMCTvxERdcOV6wH9zfmsmmOojuqlc7Kl6?=
 =?us-ascii?Q?4HwBzBPojbkjroFwjv6oxedH+mqKaVBaFa1e3nZxjG2SY6Zu//1R55rY0iPZ?=
 =?us-ascii?Q?uCbSlJIiefO9i3q0YtFbJJNgYD0gaR2en+fRBh9UvEso3dWyQFzw4iJ8wBDE?=
 =?us-ascii?Q?7a5AWLN982m1XnYEzCgQWDMzYZPMvSjPottMm9pZ9Bgij9+g7dzTZqlCn9aZ?=
 =?us-ascii?Q?ajlYH/vBy/H6ojjNeHkVZEoNrl1M5Qhd5ssalSZijC1olxKq+U0etSlsmM8l?=
 =?us-ascii?Q?jadxBzqPeKYANnX+i5U8eoOmbR5hIbHnyuvv0JCR27u2VXMWsI7Y+hhhx43R?=
 =?us-ascii?Q?QTluhMflD1z28g4llxYsFHHS5ZxEMe2PepFyTtV8k5WFH2vXm9K+n1J1DJ4k?=
 =?us-ascii?Q?zJI7iuvKNy9r2LZeXLA9YgCKkcRTRcyHMPveuPAblZC2qbSZxeeDyL0GXg8/?=
 =?us-ascii?Q?v4L1dQGsWWQRp9bvRXBUeXzQgRKrc6VIUL1boRWSa43C96W0sKz1zq2C3OTl?=
 =?us-ascii?Q?gcX3AE2ppErxy6BvCO9u9Y0KQq8tPXNEFlhwIUbYOUGMxkGK7hUNkPE0e2LC?=
 =?us-ascii?Q?6QyRkQC+8xz1CV7gZKz4kZgUarrerOd4MnTYNxWuP8yjeVVtlUoPoQhW8ipF?=
 =?us-ascii?Q?06GhTXnLAKWQ3/ofZMl4UH50dD1buHjDLm+JgZx2ESFzY2aueGTQIfdLRJuV?=
 =?us-ascii?Q?TcvRna1bJp8l6WgWtWIN9klLNZhs9StAhhsWNK9jZLWqvDHPB1a3jPJNgotz?=
 =?us-ascii?Q?+XNzJGHJlrSTQovBHuZUzi6gQ6uGfuljsBWojFVKyxsA+kCsMGu1Re4Nt/B9?=
 =?us-ascii?Q?CTywm5V7h7YMVm7F8wKmg7u3a3t3A2BviLOt306B4NKg9tpe92HP0G3obSKY?=
 =?us-ascii?Q?fgTyIrdJ31IjkaKH7CEqYro2NgdXmO0THjKlFQ+2ZyIvO+Fm?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e567ee50-32da-49d6-bb6e-08df41c30472
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Nov 2026 20:16:36.1016
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QlLy+TNbAdoNNQc05ZAJErlhAInXI5QUqZDMxqVyCPah2VAB+OU4P6xQjXm+9+VY
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB7410
X-Stat-Signature: tynf1whfuer7zzw7wfrj8py7wi7yxxq8
X-Rspamd-Queue-Id: 0CF10C0007
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794601041-402439
X-HE-Meta: U2FsdGVkX19HNoog8fBZCsvAD2BZEC1XpR5WwE+dIPyYLJSj4UXCaJkfw9l0QghhZsg3EN5ErQWkZuVhoA4PURBuiiuWtMwkxAa6qZsLa86+y97rWZMa4XhszaC0mp21d9jbwJCIF1Mkt/8iZ2fcXaWyS7ENcuZKl6GiL2aK0I7XM4OfFEXyPB+W37J/uRYFrT2EwxM1C0TkBMNO4N3sVGWihvbL8nBnzsKDsVgUbdajZyK08H033UdiBxu44ej/1HnnRfPiNBZLduL1U4ygwZIJxrafr9yxuZyE1ElvYG6yLKqdTUlveHdvQb1+igxCn1jpqGLb2yxzuZC0n8yDIL555kPwRfEk6t0UXiPTyiPiymTDuXjvlWYGxGw0+dV9PNo6beMiTVEdj8wDkfQ87+5tl5uXIOQRGBZKFjoTyFd5zlohuZXRRQTC52A2a2UmIXBIOy5mu7SOxB8pOV2GVNDTMRISjwKTkFhe221JSXqs1yLXAute3pHrWkM6xaZIM4eOHKO+5PlxsWnLg/mtASVqLhQj9jNFibsNrtPAsSA+3sSxpZQxqHyAAt50EKZsBLyPOMyl/rkKnC+KAjU2XrqU1SunK16qXS5UlQuyWek7/zCzevYVidk5il+DhBtOnun7D12AHjGwaGD2lKcMz9nkbAxRnBpIWnGKnh8Xd2lx+XmDC11L+B0clNq+E7uIdQQKZKX3F4G6c4iBXbxquPURlmBz0DWa89cmtB9/jo3ngrJdhi5Ab/LJgq4MVkukIw6jYKZhkqTx4iqQ0zjFMcYUFlxP8eDMSuj1KqGld5VR7HyjPQEVEjVHdTBOJVbxydQ27JGkGBp+j/WpJiffpr+eOgUL4ir2jcdL+Qp3QcjxYvkJQu/iLvpzEN+bCW4wO0lHPq9M5sILUZqewb+CrMyL8/0OeKmyHb/Tn2eFTgV+u+PaQOpbQ0gFeievIIb/igriHE32kJBz2iLHAmT
 HnKKvLQ3
 4MyRF5+aYA50USswCoWVbngRBoJ3XsNuTOFB+oLOmi+inBVeoFAPXUXjgEAclYGREk5l+zLYhT9R+PiBPLbmoLF6d691dzkV4PxKCGd4lgZ2Is92SJEW/8z2LB4ryFhu+8lwJwSzrlkxf9ez6RVnytWCA1gKI7WXsEMEjWsE4Jew8bjGmJqFvr1ShZjdYhcT3wt8wB13OV+5OleVYcmnTt9wpNjzsQgFd1N36+6nsVdQ+GjhDZcgROYJ8P/io8vlzx08c/2u9CYKKpCUTShfs08zlDQi3djcUKiP8STw3zIBFNyFq9SyRhCqtFZkjp6X9DrwTOKxEgJdzUfPnmj/hCic6lkb+ouOy6pNUgIWfrLCH77otb4+vuUntUry/iVsOQZnjGCoYG/KtAM7S7KFaCp7pJ2UrDQsEXwWSY0FuPjbwxVyri8zpqtBqEA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 13 Nov 2026, at 15:14, Gregory Price (Meta) wrote:

> On 2026-11-13 14:47 -0500, Zi Yan wrote:
>> On 13 Nov 2026, at 14:26, Gregory Price (Meta) wrote:
>>
>>> apply_policy_zone() assumes that policy->nodes intersects N_MEMORY, so
>>> it reads a bind policy with no N_HIGH_MEMORY node as movable-only.
>>>
>>> On systems with CONFIG_CPUSETS=n, nothing rebinds policies when memory
>>> is removed, so offlining all memory on the nodes a bind policy names
>>> leaves it with none. The policy is then treated as movable-only, and
>>> movable allocations are restricted to nodes without memory.
>>>
>>> This results in allocations failures, a VM_FAULT_OOM leak, and then
>>> an infinitely retrying fault that hangs the process.
>>>
>>>   page allocation failure: order:0, mode:0x140dca ... nodemask=2
>>>   Huh VM_FAULT_OOM leaked out to the #PF handler. Retrying PF
>>>
>>> Ignore a bind policy whose nodes have no memory. policy_nodemask()
>>> already ignores a bind policy that does not intersect the cpuset.
>>> This covers hugetlb's policy_mbind_nodemask() as well.
>>>
>>> If the nodes regain memory, the policy applies again.
>>>
>>> CPUSETS=n with HOTREMOVE=y is unlikely a common configuration, so this
>>> isn't marked for stable.
>>
>> Also no Fixes?
>>
>
> It wasn't quite obvious what to tag exactly.  Since I don't think it's
> worth backporting, wasn't sure I should bother spending time on the
> Fixes tag.

I can imagine that. We probably can blame mbind or hotremove, but the
commit might be too old to be meaningful. It is all good now.

Best Regards,
Yan, Zi

