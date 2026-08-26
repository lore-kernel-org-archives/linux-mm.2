Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1DA57C61DB9
	for <linux-mm@archiver.kernel.org>; Wed, 26 Aug 2026 02:02:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C39926B0098; Tue, 25 Aug 2026 22:02:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BEAB56B0099; Tue, 25 Aug 2026 22:02:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AB3256B009B; Tue, 25 Aug 2026 22:02:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 6B0336B0098
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 22:02:42 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id A0A1A1A022A
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 02:02:41 +0000 (UTC)
X-FDA: 85141771722.05.988AA2A
Received: from CH4PR04CU002.outbound.protection.outlook.com (mail-northcentralusazon11013071.outbound.protection.outlook.com [40.107.201.71])
	by imf03.hostedemail.com (Postfix) with ESMTP id CE37F20005
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 02:02:38 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=FF7QfFrO;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf03.hostedemail.com: domain of ziy@nvidia.com designates 40.107.201.71 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1787709758;
	b=X2SAmwrIljwfjz7M8aKlsJLzV0o5rB8QnDt8ACTC8Ooj78KqhJsYo2s2gjwCZlqji8VTeC
	x9/gUDYFqndx9ufvdu0XQfe+XIEhmpZ4rWrlCicfbAkNc9zV8Y4g+KJOI0tgGj/Xtw0TjN
	CxXCzT5tzSjxiqbLc0r7+Y84q1j/OQQ=
ARC-Authentication-Results: i=2;
	imf03.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=FF7QfFrO;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf03.hostedemail.com: domain of ziy@nvidia.com designates 40.107.201.71 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787709758;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DqoqBQavOt/uvPZCaeJSakRO8H1fRk9/+VKJj/P+cug=;
	b=5iQeSw4k1whoKaEEfMwq4NnCnJf9FSx50m57riJXrC8UKMwHoMHLPWs6hvP47QKAI5i++l
	nmS7uy/w5OR1vLtnDk4RT2b6cb9ycZ6DYBoyiicw1nUUTVRb7qDAAwY0ayXG0fN5uWuMXK
	w8AuVTb6sXqKdIa6IFpeNyaCCVeLs2w=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=F1KzY9kRCcXkI4TOkLfavXZtGAIh72d57b9ba+kGZY7Nx3YczVgTMpzD3wDqyeG1mvj2vIXd5jxBSeYJDUs8dOsw3yXVxcXTqnLnR2Mo/0t20X3IylrfOlaKXweYmoHoKbHunIS7Kwj5U5T3fLrUgJ+oeCx7m7oPqUj/FB95ivnbL3xwYb5LagToYMnBhgNJ5AUa9a0xC8HZWHYHlykGSNNoFOjpSTPo9EWu1hrwu8BDOLx58aY0KbG7NUqAar0IV3ADbyp/RUKnlRmvkoxKCyZhIr9iVHuKTHjVwxpRgPQJ4Ka29HmEb6jIjWr6H3UIIYkwmErMvFMgOmK1LEssSQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DqoqBQavOt/uvPZCaeJSakRO8H1fRk9/+VKJj/P+cug=;
 b=Mqhne+Zf7GdZNDM/cksAxiYMs38bpEuCLeqN4sTY9WQMpOQc57C/3dJ6ssBLMvGyTXy2dN4XjiX1BvPmGsClIVWSX79YzXu2wzC2gC/RimTFy/+DYLFJjlNk9J7ayPZRFBLRZCrH4Fc5YJL7xhvJWmf6wbKet/cd2bYi8ZOf2eh/rfubIP7lrhaw30UJvx6Qj9O/A1MCa6PJN3y/o4Iiu583NEZ7/fRuBr/PsMrJyMgn1WLRnChpd99wPFvak+C5BV6V6AAGcW8LTe/y9iNDMh/kpCU3gQcY8lZJd11NNqYTIherxU4eUM2LLopqXb/1W1UKqyb53ilkkIyceiM+aw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DqoqBQavOt/uvPZCaeJSakRO8H1fRk9/+VKJj/P+cug=;
 b=FF7QfFrOn7E8/bBb8xEIjIsRJVeHKLTCbEyotN+6ztE/2Wg5lDrr6si309VHTsJ5/zLKOjV8igH+dSSBsFtfDwInPBalQ7kZDYEey363PzfDknvrpj7oGfm1ClX9FtRvb/d/bhd87tSF3W3xf/tJBqkICLOdA0P8SjSGXXPuWeC4cewn3fKQ5iYGCFnVzVgTebq/CMoaBHhEUaDCBCOmnf/SKgBjBoUC49jXczEa92TdLpwK247N9+HRhBiwTXQu6GyFOsOamAZ9hRq5seOsEWWTGxOlM0OCRqeO5/mKxLqRntWdrUtFjAnTkL3fH1XDAQV06lP5CFuFPF23eEc+MA==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by SJ2PR12MB8064.namprd12.prod.outlook.com (2603:10b6:a03:4cc::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.360.7; Wed, 26 Aug
 2026 02:02:34 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%5]) with mapi id 15.21.0360.006; Wed, 26 Aug 2026
 02:02:34 +0000
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Tue, 25 Aug 2026 22:02:31 -0400
Message-Id: <DKYI7U97KSE1.2S1M7CWBNBYFW@nvidia.com>
Subject: Re: [PATCH v3 16/18] mm/huge_memory: clarify supported split orders
 in comment
Cc: <linux-kernel@vger.kernel.org>, "Andrew Morton"
 <akpm@linux-foundation.org>, "David Hildenbrand" <david@kernel.org>,
 "Lorenzo Stoakes" <ljs@kernel.org>, "Baolin Wang"
 <baolin.wang@linux.alibaba.com>, "Liam R. Howlett" <liam@infradead.org>,
 "Nico Pache" <nico.pache@linux.dev>, "Ryan Roberts" <ryan.roberts@arm.com>,
 "Dev Jain" <dev.jain@arm.com>, "Lance Yang" <lance.yang@linux.dev>, "Usama
 Arif" <usama.arif@linux.dev>, "Vlastimil Babka" <vbabka@kernel.org>, "Mike
 Rapoport" <rppt@kernel.org>, "Suren Baghdasaryan" <surenb@google.com>,
 "Michal Hocko" <mhocko@suse.com>, "Chris Li" <chrisl@kernel.org>, "Kemeng
 Shi" <shikemeng@huaweicloud.com>, "Nhat Pham" <nphamcs@gmail.com>, "Baoquan
 He" <baoquan.he@linux.dev>, "Barry Song" <baohua@kernel.org>, "Youngjun
 Park" <youngjun.park@lge.com>, "Shivam Kalra" <shivamkalra98@zohomail.in>,
 "Kairui Song" <ryncsn@gmail.com>
To: <kasong@tencent.com>, <linux-mm@kvack.org>
From: "Zi Yan" <ziy@nvidia.com>
X-Mailer: aerc 0.22.0
References: <20260821-swap-thp-cleanup-v3-0-9b43f5163238@tencent.com>
 <20260821-swap-thp-cleanup-v3-16-9b43f5163238@tencent.com>
In-Reply-To: <20260821-swap-thp-cleanup-v3-16-9b43f5163238@tencent.com>
X-ClientProxiedBy: YQBPR0101CA0315.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:6c::16) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|SJ2PR12MB8064:EE_
X-MS-Office365-Filtering-Correlation-Id: f1d8c982-4378-424e-ef77-08df031617ff
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|376014|7416014|1800799024|366016|18002099003|22082099003|11063799006|56012099006|6133799003|4143699003|10067099003;
X-Microsoft-Antispam-Message-Info:
	bMBPq6GBg3UYuSWMK9wEZ14KezBktme6UUKYhXdp2piaCgMEigQvzmTltmAWN6/UHWK7coSCuHtrcwdCrSZ6IOInvlUt402yBOyl+z3BlFO6ylfRusTRcFTnpmrF4D3GwdlaxyB1moIQUo/NZFejuqtMpD5IHAuixX2ZJ3O8tjN/MptifzXpJTdGbC8HkASRWGsP7ubLTZ5cPturH5pFVRQy2jAPJwg9VkTtcnvysbbEmWljavd1WwnEb6Z/ju9r8n6xlLz+zLuq8cZ+6qn1+59Yr0KhBFZkvbjGw3Gn2xLn9dcuJpE8U/z2TejcFQO24qAG6MfwwFCRSYBcd7KIR6hINuTEzOAl5NWWAzpeMWP3F76vCKi3Oyq5M7c/XmrDJQK5wIuzEEujOXN3ZVS3WorwLA4oN6kKbeqTu7XCewu+mZxHnWJEhp2S7vnpYcrd4jPaXNz8MRJ8HulF6Zk8NrfE0QtjqZu3teoKvkkisS/OJbbXZsG5CGDGsjUU0OkkmRjkWWS2NKkLjC5Ik/jyKXAqFs7h6lcMN8+ifXnTjOJiGJ0moWM7EPtwiSNj87jNRjaSOzat2WK0tMg/qdxUrYB3QXOwTtJQLXYrmqAXqRNLAxUZxpZLYSCPR5Til5r7GZrR/xmHJd1Yn3n4yNFZBwn3jke+dqXMD0idw1AjiGs=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(376014)(7416014)(1800799024)(366016)(18002099003)(22082099003)(11063799006)(56012099006)(6133799003)(4143699003)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?RjF2R2p0WHpGMzJ3ZitXbjBsYmtTZ1RBWFBqVzJmU051SUc1WkVTZ0d2TDIy?=
 =?utf-8?B?RlkzUTcycUtwVnRncmwrWlFtckpxL1pnbmd0Q0phTlgrZURVeWNUdXRVaVE0?=
 =?utf-8?B?ZGU0YmJzd29TaGk1Q09UVkYvL1B6V1FpWG9USEdZZ2JzL1JqbHBoMkwxbEVw?=
 =?utf-8?B?V0U2eUlWT0xBelViWFU3cjlVVXFVK1d4anVmNnQvcndQN25CdWVndkdZWG9T?=
 =?utf-8?B?QjJhbFZlYzVtOWZwYzlYZ1VNSmtkU0JHc2NBdU55NFV1SEVrNjFQS1lKVWd5?=
 =?utf-8?B?TFI5SzFhV2oxNU13eW1ZazBwdm4yeGlKRGt4clE1OThwQVJhMDZMdTBaTW4w?=
 =?utf-8?B?bTlTK05GcHdiUmt5dUFwRFo4YTk2aXV6emNGc3VZQ3ZGUE1rbERNLyt4OHdw?=
 =?utf-8?B?Wm5USnJBV2hiY0VIb2tIMDd5N3FGQXArTVBLS2JIZWJBQnlRM3N4cWloZ0pE?=
 =?utf-8?B?ajhZSWFQOERrWlFwcFRsTGxlWmxCQmJ0N00vNEZsT2JjS3UwbVc0SlhEV1Ny?=
 =?utf-8?B?TzhYVXQyRzJiQndjNjJSNlM3TmdSYzNiNzQ3bjZta1c0U0VOUHRXOUNPV2tP?=
 =?utf-8?B?K0xKQXBIRFZoSFFtb1VzWWt2cmVMWUhqRlFPVnJuWkxRbjNxTmxQdUdlTktL?=
 =?utf-8?B?V0lmOHdibHF4UDdKSFExdGdsTlduV2NYMnRuZm1iVEVlV1JKbmVVNlh6Zkpo?=
 =?utf-8?B?MW9GbkZXaHUxWGNTWkl6aHlNcUZ1MEJnSXc1MXJYU1crUTF2RHBWTEhpR21X?=
 =?utf-8?B?bWF2YmlQbXlmOUFKNHd4OWhiSGhZZm5PNkt1Nk1pVW5ORXZveHFWV3dteTBw?=
 =?utf-8?B?TW42dzRkcWd1RHRKY1N4RHpqOERSaldwOGJJenNRV1cyVnR1dTJYd2p0OFZB?=
 =?utf-8?B?VEdIVTM3Qmc0elo4YVdmemZKNjhtbG5CTnhCZzg1WFBXTERmZHIraVJWeGhh?=
 =?utf-8?B?YzhETUtoODY0bGNWQVA2cjBLLysyZmFLUk9uKzVERjBTSmtwenZFOEJWRVRi?=
 =?utf-8?B?bmpiN1F5ZU5oVDJsY3pFVWJqa1VLc29ROXowa05HTWVzcVkyN051YTZGZEVZ?=
 =?utf-8?B?bzZrTXRVRUkyVVFaVHlwNG1ZTGJzQ3NTNnNNZkFVVExpcGhQdjBQT0l0bU02?=
 =?utf-8?B?R3cwUVNPNW03VDFOTnpyNmd3bjBnZG1obzd2ZUJMR2xBRVQ0R0FlM2lscTFy?=
 =?utf-8?B?aHRUWU1Fdm16K3NJUUZwTm1YQjRjSjFHMzdrdmc0M1NWZTFVTE5PRHZIQlJH?=
 =?utf-8?B?L28venVKU29xNzNlM3EvTWtmRFovSFdWKzFCNEFhSTU5dEFJeUdqVlhFZ29L?=
 =?utf-8?B?V3lybEREUi9kM2JsVnBMaVVQTXZ0eVVQdkZJYStMYzJEcXMvbm0vVDBCMGtz?=
 =?utf-8?B?VDZaTUoyd05ITThsa1lRb0dRV1ZYVVllN1RrK0E2bWNOcFBucHNPUEMwQ2lG?=
 =?utf-8?B?MlkxeWVLU2Q1WEthMHZpVUxQRU5GaUZSQzR0akRRbXZSbzRkMmVUYmp2SDRj?=
 =?utf-8?B?S0o5ZHE1OVdpQjhOb3VWNmNVY0xqUFErUUhSN1FWdFMrUmEyY2JPSjhZcHlz?=
 =?utf-8?B?NEcrbk1HV0JlelVoUkZuWWxQWG1BWERkdVJBR0RjalZOanBRajVkS3RZWUZi?=
 =?utf-8?B?bCtTcjJ6TWJONjQ0bEpKL1J2OEkyWWpheEI0QzkzMlpseXZVTnpyV2xFdDNy?=
 =?utf-8?B?VzNZYzlDNXc2b2tLelB6WU9uVnhScyttak9MODJNaVVDNzJHaG5Zc09NSVdP?=
 =?utf-8?B?ZlFCQThmRXdOdE1yanh0QlkycktZUWRjQWwySW1pWHpCS0JyZ3BFaFJWNk0z?=
 =?utf-8?B?MlZPRXF4Wk1FQnp3eWRSYkZmRlQreXlpcXl6RFg5bkx1N241ZXNZeVFwMXpn?=
 =?utf-8?B?bS84MmhJOGVrNWtoUGErVjdTa2tmVEdpZm93bWMrcHNTZ08wTkh6RlhlSXA3?=
 =?utf-8?B?KzBsNlZDVnMrSGxTRVBOaEY1UExjUXV1Y2xCMTFkd2VkQ1VFSjQ2SGdGOUFB?=
 =?utf-8?B?dDRiLzVydDhqazdjbEUxK0pmTUF3c3F3L0tVRkZWcU90Q2FxY2ZrL3RTT1Vi?=
 =?utf-8?B?Y3JPOEtZR0p6eXRxKzZwSS82SzZCSUdYSisrcGliVG5zeWdTakJjd3JHQ2RV?=
 =?utf-8?B?WmV2djREZlBnOFNlUHhMbmtrUG9hSFB4VkFmeXU3a1pXdDFIVzlHZlBXZDVP?=
 =?utf-8?B?ckpSY1ZFN0V1VmlzemNIelpBMHlqSUVjb2Z2a1JQOHI0RElNRWFuMldKazhW?=
 =?utf-8?B?NXRSU000OHpVcVN2d1ZQbjZuSGFPUm1xTU52NnFQYkdrbFBtbkJTbzhwNHVR?=
 =?utf-8?Q?r/o1x/OAWJ61S4H5vs?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f1d8c982-4378-424e-ef77-08df031617ff
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Aug 2026 02:02:33.9720
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: B1k/yCFAS7Z6nAw9DvE1aSxfIxAUl6y+nPLZPT8rNQulQPWFDvU85NC7jZS5Qe8A
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB8064
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: CE37F20005
X-Stat-Signature: io7o8m65ry43qyu6eh4jfo91c1s3cqyk
X-Rspam-User: 
X-HE-Tag: 1787709758-527017
X-HE-Meta: U2FsdGVkX18+kYbX+SyzEBCZ0eK491tl1T+rA1vJ2053zkB1gNKp4q7dTrOHPCHOtQYS/z6/km+n5M1npjAbIIirkInhDsAeC0G4zQx6ORv9hf1HdXEkz9LSBrvuE9E+pDtOsNy+2JXQJRLsGmjhmYXUJrmTpr8JljXYMWgqlIU1kxn2K5KLkvzFC6RTvcOXyhtLiVF6dxJL7qmQDNEnrkU470AYZWQVEAMuZo5WaRAhHJVkJYf2sAub9TZb840vhFijCAGDzkWUQqiqhrT5xZbcMObPFpoIbnI57qOK7xlOhC4F6VSsDPm6CnfAw0LvQ+m/uxy584RgXkuwr+8SK0lacFrNJx6wO6TWxyL6NaIaQ3IVdO85eHAVyQiO+d1ZuJD0NX6Bw0WZ7Dc9yqUofojCcN6iLevDLvrwWu2fDXc9Noudx5M89PT81AML3Hsf4+PcqWWVgyaWsWOuj9BJ0zHmIWR9ARft/YtkZhe8r1acJT+VFDsi73/EFhm5oOPx4n50mDjrKgwa23Iz8sdsTrctzfXlUaxWJBsMfyNdZsNA2HpIcAAWmLW6GeSI1t5MVkrl596oR7T4rxFEFPoH5x+HjIqEpHsfAPZSW25KhNHwEhQbHBqHRrMitjM5ODFdNY9QIwz/UgIeAlEdU0ywCHaeQS4Tv1jKosgK9sn5Tqcy5F0o+8jaRK8X9S7DouiE34/2jwTDuw6x2FqTc5wzIAClABwAEibs0iwy7xXyJUQuQuu81er2ud6NCOjxjZh1RndVCoDonW8t2fuBNg/YdC1z6r9ov0joaMYZbM3219UZj4lf+SrxyV3ztSTJ2pGA3ZpEJCYG3DIQClded+T1GzkCyB3eBWXs/cJbvfhGSKMl+A4EKrFGzhWyMYrDrs4w01GcKN3sNPq+9Tkw2bGLbxWyO1u0T4X0AlQDq5jdH3PwKW566fKW/0KRL/xGMT9WBIIzSYK1SA0+IzIrJIW
 kHs605AI
 4QXlT3rrvpUPRu/QUIXdr0paqx9AqfN/kw7qGn3jeO+ypFmnOjMlgU3NbUXHATRJleFKIOe5ST+KFBQjss+q5tNZARydEU+n8EKiMtlPOi/QUjIGP/9U8fqUQlKMU5f+rGbTEewiZZ/+UVwrzze/44knz8u3iHoh1v2+t5OwkWLazcfNgovtvru2nrgyQH2rKfe+L75L3uKGwuyoQ5LHhNXNTmwcLyohyQWCCULxwysHzEto/VDKymMNLOuVXrh0Z1u38Vf5lbRU+H71gzbveogrRLd/M5ndjepDfbU4xzVAbgCQKPQxXZHk8qV0vB4TTI3SAubaozFCWRxMuNeq0NoYiRb5W6idSc/d5izvebZRQUJPHsre/w8lgS4+huNF90Np54pDJd0Zy+oWhzN/o3Mgv4qz8gfOKhLx7SSkJvOGmt0ydZgfGgxUr/njUuoZNieUILiCiCkQmkA6k+8UxEXMcMg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu Aug 20, 2026 at 2:55 PM EDT, Kairui Song via B4 Relay wrote:
> From: Kairui Song <kasong@tencent.com>
>
> The doc comment for __split_huge_page_to_list_to_order() needs an
> update: only order 1 is rejected for anon and swapcache folios,
> matching the new_order =3D=3D 1 check in folio_check_splittable().
>
> Also realign the continuation line of the function signature while at
> it.
>
> Signed-off-by: Kairui Song <kasong@tencent.com>
> ---
>  mm/huge_memory.c | 11 +++++------
>  1 file changed, 5 insertions(+), 6 deletions(-)
>
> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index 06f353f937d1..0a971ca48151 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -4400,11 +4400,10 @@ int folio_split_unmapped(struct folio *folio, uns=
igned int new_order)
>   *    GUP pins, will result in the folio not getting split; instead, the=
 caller
>   *    will receive an -EAGAIN.
>   *
> - * 4) @new_order > 1, usually. Order-1 is not supported for anon or swap=
cache
> - *    folios: anon folios need subpage 2 for _deferred_list, which order=
-1
> - *    folios lack, and a swapcache folio may become anon once faulted in=
.
> - *    File-backed order-1 folios are supported, since they do not use
> - *    _deferred_list.
> + * 4) @new_order !=3D 1 for anon or swapcache. Anon folios need subpage =
2 for

We use head page + tail pages instead of subpages, so the sentence could
be

Anon folios stores _deferred_list in second tail page, which order-1
folios lack, ...

> + *    _deferred_list, which order-1 folios lack, and a swapcache folio m=
ay
> + *    become anon once faulted in. File-backed order-1 folios are suppor=
ted,
> + *    since they do not use _deferred_list.
>   *
>   * After splitting, the caller's folio reference will be transferred to =
@page,
>   * resulting in a raised refcount of @page after this call. The other pa=
ges may
> @@ -4432,7 +4431,7 @@ int folio_split_unmapped(struct folio *folio, unsig=
ned int new_order)
>   * with the folio. Splitting to order 0 is compatible with all folios.
>   */
>  int __split_huge_page_to_list_to_order(struct page *page, struct list_he=
ad *list,
> -				     unsigned int new_order)
> +				       unsigned int new_order)
>  {
>  	struct folio *folio =3D page_folio(page);
> =20

Otherwise, LGTM.

Reviewed-by: Zi Yan <ziy@nvidia.com>



--=20
Best Regards,
Yan, Zi


