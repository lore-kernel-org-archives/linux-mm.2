Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1414B1091904
	for <linux-mm@archiver.kernel.org>; Thu, 19 Mar 2026 18:30:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 583DF6B0567; Thu, 19 Mar 2026 14:30:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 55B8B6B057C; Thu, 19 Mar 2026 14:30:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 471516B0585; Thu, 19 Mar 2026 14:30:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 34F2F6B0567
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 14:30:36 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id C20F7C2361
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 18:30:35 +0000 (UTC)
X-FDA: 84563653230.11.6D88D6D
Received: from SN4PR2101CU001.outbound.protection.outlook.com (mail-southcentralusazon11012041.outbound.protection.outlook.com [40.93.195.41])
	by imf25.hostedemail.com (Postfix) with ESMTP id EE9B0A0007
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 18:30:32 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=Fa4v2k6K;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf25.hostedemail.com: domain of ziy@nvidia.com designates 40.93.195.41 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773945033;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8BftjEM239rkKBkWSHcPCeYkKJASjwJCbFna9RUHt+Y=;
	b=OIJqdaEN1Hb47Xz1imaGDwIjO4ZTeIE3zXGR4fU1z76f/bqgeXaNoI1orqFYWh2es4paZ0
	ohAVhYABPIRSbKC3s4yu+N8kswVvMMP+GUDm2ENpFrwj2j1TO8f+n7LEY3j7U8gQpAdNFB
	sWqMccSqUOizBrOTVCmNFbjwasb3HvQ=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1773945033; a=rsa-sha256;
	cv=pass;
	b=ewgFsb0uasQ4XqU1QKac8H3hw23nl7BO/raZpHNzbq/Lb1g9y1qhr4VS3iJAabzwpxr/52
	GHybIsxFCAWiXaXyF7PUMJBfGCY2dW57ANMDt8RJu6zyA7Tqq3fPhmj6ssC7gHUSEiYd0D
	aWASBlFf44pfjHPlYaqc2b0MvimKRoE=
ARC-Authentication-Results: i=2;
	imf25.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=Fa4v2k6K;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf25.hostedemail.com: domain of ziy@nvidia.com designates 40.93.195.41 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ivJh0kIubmBN8IcNSjfAlQwjm459XwTpFWXcEQK94dCAuMf/ducsTi5g206Xt3lNXi6/BITl2NEQytWvkNsLRxRZizkH0J2Ep28CFFqycgc+3M9qQT4Y2SBcHxsVNupCWM3xrj/2T1W4A7IkU489uEBJba7UGfz8dwPPWKMPket+esvdocZ384i3NwZjja0nUTBB8Jg1ISp3ekOoLGHOd/Akv7l7uXGV0lwRnpL1KLq2ruNM91bZoggkmht33ikC5Gz5qn1IOLOIqt+uu4tHmFHVx3ZOygxGXNcwnxh3+wBDdQ2EIkRB77zFk9lrw3E/ITeSxJvpiDIRuAaMlAvkFQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8BftjEM239rkKBkWSHcPCeYkKJASjwJCbFna9RUHt+Y=;
 b=JloLJf+HLiXiAOAG2JzUDmD+zNZGvL+Z3jlIL6E+Gg7JJRSNeX/G1wnqI5pYfYkJZ9mOmZDdrvYUepefqgMxi9opPWiHx8anQM9F2XRaRF/jAPPkn4YDMnSmnCkDSRouzmubQmUVoyIJg7k6Bx1tdC4SdIo0LBC3LfvR4ggNMVrC8wGVqiM3WxsRp0t+JBe3ky0nJayVIiJK7/Y7QYxXJMNMoIfl3+J7Mb8kEwA2S2qUM3pqgxNJt9eSU3zQyVpqjZUdPeQ5+BjxDNE3Dj7xrIE3jCiaUe3VC6mIA6tvLnNrYfI5EK8qGuI/OPCFnb6Vm8Vk1wdamHEBTI/T9VuI6Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8BftjEM239rkKBkWSHcPCeYkKJASjwJCbFna9RUHt+Y=;
 b=Fa4v2k6KW12gMOzI86wIJ2fYRKDkoP4P4V8sOUtCWA1vyptBFcCst/uCijHPJeFLaSArjZavASw7qHJpVwv5QrOVM5WgIbH0Mw3bfb2PTgUCD9qBqPP7LwbrMPDPmLbEKk7eQDXD0+p1ECWwy/Bp1TaFjq5BUo02tZEoq2SQelKs6AH/pAq0lyrGalTaLszLCyjFoah1mEdbhjjxjlwT8tuVoFdoummfDURjJg2Zk3oup9/iF/M7bTrivhlM1TS8hnbffdl/c9LdW5A9FXKm7fZyUt/HL1vZVZC8LelT9eTvK0GakkSnAgRQk8faT6z4Xnf71UDvUB1rwt/LEhuopw==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 SJ5PPFD5E8DE351.namprd12.prod.outlook.com (2603:10b6:a0f:fc02::9a4) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9723.6; Thu, 19 Mar
 2026 18:30:28 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2%4]) with mapi id 15.20.9723.016; Thu, 19 Mar 2026
 18:30:27 +0000
From: Zi Yan <ziy@nvidia.com>
To: Brendan Jackman <jackmanb@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Michal Hocko <mhocko@suse.com>,
 David Rientjes <rientjes@google.com>, Shakeel Butt <shakeel.butt@linux.dev>,
 Vlastimil Babka <vbabka@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Harry Yoo <harry.yoo@oracle.com>,
 Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Uladzislau Rezki <urezki@gmail.com>, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org
Subject: Re: [PATCH 0/5] mm: Switch gfp_t to unsigned long
Date: Thu, 19 Mar 2026 14:30:22 -0400
X-Mailer: MailMate (2.0r6290)
Message-ID: <EC9EADEC-D787-42AC-B108-4AC434CF8E2F@nvidia.com>
In-Reply-To: <20260319-gfp64-v1-0-2c73b8d42b7f@google.com>
References: <20260319-gfp64-v1-0-2c73b8d42b7f@google.com>
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: BY3PR10CA0015.namprd10.prod.outlook.com
 (2603:10b6:a03:255::20) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|SJ5PPFD5E8DE351:EE_
X-MS-Office365-Filtering-Correlation-Id: 4f02a921-1677-4ffe-0dca-08de85e59801
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|7416014|366016|22082099003|18002099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	yNbANy2uC5Z58gB81LEsUm9cnMpbqNjRweZGcOSzkeRyCVA68ISd2t+n4c9tRzYXAsgznz1kYRv7RuKzh8XMeHVVJIGEs8K9vc5xTT/EwF3MJZmwLTKzAYERY+5LNvDuKIdzln5/1UBcPYXfIT4gToRnUA9VpqpSzRQrmGHJOF3pd+t4en/gLsaTQzigzF0qvUPsO281+xpDSPmsBs+LFeFAL3Sho/E0pULNUkih2GLAxDBxkBCibOXPhVsANOoW5V9ECtMRZFku7pBRdw+kkI32Ra5U4cmmWO8YDbVgcG/SayAAs4wbqoQ8DtdVawd4seUDh7QxHNZd9PQb1D+nS5/IFbnUf/JjDEoGjPSEVi+4Xc2gWZs9Nwss8asnR8Jz8HRCghag+wyMiYIQyjvxyfu2Iz7R0JXKZQkOsIA841oY2Iyg8BIny+xCAz0LLn1CxnuDvhDWLCJT7gJ5lpF+/kQpWA7H6qf/jbJGgbDIRIIobPr1KscCP+3gzYLynu63popRj0MHT4TLQcxy0GvQOVUpPdvDqT0aeQOnKTcvW4ujASmWtKD3NlimQtikkqFlWBoWwxp7nEeigTHFkAojspNMMhG93vzfzUOhwiAIL1z0frls83kIKIlbSYxTQr5v3w0kO99/hzjJFjBUF9DohAiIUQJRfYAwWtpMzzZIz8tGkzQSW8porS6L3nXM4H9qO0XhK50sJlXqJPQpMetNA41Qrj24k/rVzVrt5PBBFlA=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016)(22082099003)(18002099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?ey1lAONxbbTy+OrEe7MP0rfyWwgCMgwCf8mU5QyKSlm78EaP0N/e2Riqkc4G?=
 =?us-ascii?Q?3rC7rLV/31bmrxiAe3YQyWdzUbTpRZsfXXs0VOiUZ1DYBgljcjNpUAqV3RF8?=
 =?us-ascii?Q?mT8RDT12w07YJCHQAp+Hr6xFs6uQ/g6RNoAmvuKyQ2W6xZZ22xcRKUMOtSN1?=
 =?us-ascii?Q?rSMwTixpodtwscC8ZS0Bd0ERdjFcKMsxGD5a+qOmuR9xoIA3QJ0fJSwQk/Id?=
 =?us-ascii?Q?LcDhLlhTgwD0FfRuGdpXHetQrRa32PsDfW94G+M8B1uXLloFvan/Qgh5ViaT?=
 =?us-ascii?Q?d7NYIUCFJ/UjbLxUkKqOW8yJ9sVJPpziNa+bBaWQcSmx8J6K6KtlJL/u0wI1?=
 =?us-ascii?Q?hKkHxUo8h4GN5ROXrLFPJ4MQIZtEF+zvUxsaAMVTEP/kkk1n7HszB6Mhn3zb?=
 =?us-ascii?Q?WCarOkdU0v3q4mjaPo35hdgknTHOHebYhHMo3OrpmtAEDlqlMEBDBbpMTn1D?=
 =?us-ascii?Q?26Dwzfs143rwMGS6m2gh2l75w2n7EmI48jcEr1Ra8GDew8tjZ4vR3Xh/HxUq?=
 =?us-ascii?Q?G/7omXRzP3NQ7lpfk8RecBFzg+J8P3UBk/NN6qmDGCtDvnvL8Wi64yEkxCem?=
 =?us-ascii?Q?zKX9vKq03a1sXEI2unM7LSU7TFZimW4DBqbK74LJ3D2VJGHadAek627/lx2b?=
 =?us-ascii?Q?IPysm+nMWBoYntIyV4r+H5NIS+V2TIoxgsfroNZKHJT3qz5zwTvL/km1eS68?=
 =?us-ascii?Q?kFLYCzU0f/Ufstv4aQfHNOXR/CGuP3wGDt8VyyOyiQwjDaSEXiE9IU9QLMK+?=
 =?us-ascii?Q?MZvTEngRpIaV/aWwvqnmrl+G6yFY/lp8bY1PNr0GBHj10qtXXp5FapJ8nvbb?=
 =?us-ascii?Q?hYkar2bBC/FslKv/4y7plt2w7xzCmAFOrhoCuQPSqSyeBJ+rJezsGHeeXjDU?=
 =?us-ascii?Q?QBQ/3XbDt3NJwky0o7IdsE4a/wCDoDh6Lvxv/8FzIolTY9fId5y8Le/p93Mv?=
 =?us-ascii?Q?YvKotErI7c3VoRDiBrxqI9QKUhBviolErKhGu4IJ1bt2IPyHEeiZBhALFB51?=
 =?us-ascii?Q?gTMNcKUVeUN9Z7Kx028OGbrPOKNiOFIzIXFfDJYHf9ndWNCx3tYceOWMSb9O?=
 =?us-ascii?Q?55fFWAyLs3MhacNXkWAj9MED1asFJ1/vkcQs/gcwThPFPU47+R890ad9yydJ?=
 =?us-ascii?Q?LOfFzuhI9+2dKXWEzOMDwiIHbt78MskN1rgClSDJ4sQjxUBAdfIOk7u4OQFS?=
 =?us-ascii?Q?xwRO+6gcbD9gBCJHrV9vEj4re9+h+k7qJOvufw0FiypXxdl1XvqB2+CX+E5s?=
 =?us-ascii?Q?7RDA0kYR7rtRprHTjsb4sb2KQpzmsFBQct+l168MlunBDQcOLIMrGHsI9m5M?=
 =?us-ascii?Q?Xdiw4MG1T1qeXOj30WsBATaNdFCtT+tPNL0tQreE4HB9XO2Pe3NRhonx7f91?=
 =?us-ascii?Q?VBGOHePpAWmKZCw4zs1jhP+ZYbmEfARMvT8I+RQABdh5SHcobWTUTwvhl5fl?=
 =?us-ascii?Q?wUV/Rh10FGR2CSaOquo1yHasW3chh72+lCUTYKoWHSNHyPipVeYEUbna8aPf?=
 =?us-ascii?Q?dSF8+3vm7csXiStXjM2EFAVkqX6c11OncPKpp6KYZiuGchbIKMxBGtnNGqKw?=
 =?us-ascii?Q?o/g//4rOLVIiqNsH6BfBELsZS823UN1uWh2wW7meLwG/AjLqDDntA9hdJec3?=
 =?us-ascii?Q?0vIQyNiPOhg2UkJZmf5a+715wUxN+iaUyx77UIiu9P+e60LO0WSSGRTMgIP1?=
 =?us-ascii?Q?6fN4ZKR0nAD+KH0qmeRGRoa8ec3Fya51K3Mr5DOCU5UsM9w5?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4f02a921-1677-4ffe-0dca-08de85e59801
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Mar 2026 18:30:27.9325
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Mr7uVmS6N6CjpRE2Lu7NrfOs85x+hlbcTK1sUtbwzC9QnqSPpld7XzUgFkROl9TD
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ5PPFD5E8DE351
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: EE9B0A0007
X-Stat-Signature: oh3pd8sk7ti7s78ur67s6u3cdi8t4fcj
X-Rspam-User: 
X-HE-Tag: 1773945032-478806
X-HE-Meta: U2FsdGVkX1+gVdFn8oNmAam2jsUhUBVD5Lx79i7fPCFMJTyovZoxr9RospyS8LZ/qmaAzCtxT0ZjCOxgjWmsfGIJyPbLz9rnV30d4H1NPvIBa5rhxQJ13DkddKGtG6S7E92kcZ+DpZr73JmnGMna0RZ2l4Dk4YQPkw0rk/4btZKCFTXpPuTrQtwnewOifAVtL84ks8HS33Be9DZ8d21O5u2+OQtIrqrUNGC53oiTlWc7wRZHHlsfdGRZdftoR+ic73qyUP7s6Dpmir6Izs/LM3KpbKMO4AwvH3cBgEBQxy/veiz4QWlqcjy7pzRy+cc/4cJSDhpTiQjckcMYVtQMi6inbH1eneaeBd4cicROgrDiTI/+xAP0/6rZugvdXGPQsSAPP26fTTawygBvKio/de0auE+Nj2YFa4HzQBRqX6F27t9GBEv9Gfz3Crs5qkngnWmHNN8PDQWF+bBh8vgsCpxnZFRnjeeNQnSBkv6YEk+TNFUIsc9ZML7w68y28r2LEsKHnxxbnk/CNeo1/AqJQGjA6RZMKj9UKbM6RI3U2iwV8cGxb2b31YIP9EiPM64F9++F16Jdt7WYurXZd2KmExzxrOpEuLWKO+96LYnJIH3l80zRNusZ05OtvbUua3ebmSzODVWo0LThng0fnh1ZnRbhjJFNxzz7SIlFarO4xkfNhs/G+WU5XFXZ8CfJIAMV0jUma0xJcQxNZxNn0zSkQDK3ALyrjJOU4mYowaRgorXX0trBwdrwHTCEWm+pK6WF9umCCTieF6YvAZR8iizewiCZS/y2ai8EhZDijifOfZtTK9ziuJIV0hLLBKNMuiffPIr8lar3wlrauJl6R1sI+tlN4VVSrj+Rtf26rBeLUV6yXA9n2TInzSKmHWFwzYtSlhfvqRPTnBcbHQbZ4PQFQ2qrmyfNTxi4/y60HSL8+klbQf9urMfBS24vEUrcW8IvJRaenJtN98UEZ9JXlxn
 hWxpwW5y
 E99zE2gGmexYYWgjsZ7CCYu/I64CkW8t9m7zJclPBIuCHj3r8FhafCzwNbnYkXc3COUvDrbayphJnxaIelVw73XnvlJQN5AA7wvvZXNauApbMDtrEEZVJDA4ys/DhFoa4WILFOkzK4GTwz4l8RWadvoRyzzYuuHrmcKXSwKtWmptnCHp1d28DTIXBxlya9HG2usSx6sI+hET57U2E85SXNcXhsJgMmYCm4mfDBTRoRViinBenofnrk+olRcRt5phGvVuOxB104X46JCsDgX/5m/MJC8FA4w96tNaUietfIQlnPOi6N2rwgliTfEfRFRfbvW7aiRpWYFuFO9BLB2BrsZlzEUtem9SNiEHp+aGNN0NF3im0L3VeP44zHnF0jko2N7gQr7nZ8mQ7JaPbazU/gQ1OtJW/AVqbB0fNwKWDYu888z02bLvIBc0HpA8Q/pdU0ZSayKMppZ/ZXSFVwX9mz4KVwPn9FgYE19JzIXALfE5640ZBw9//tEMrpJXjh2wE9F/0/ky1Kn8BnzVDrb/h78bAaIRPoU4gvW0mzLASqLUGSXanO4pksfNxcWIrCwaCaeFf+TaG7J0yH6hWNGtBWhxczU1siV4dTEVjaiYc2AcF5ZCxMsFH3SLHu8DBscMOcRZXB/utPRa5rnrqG43CtRwSj7JylLjweAd0dpyE/fn42tFo43qlSxeh7j25Cm00a+Lrf9xfw/f6NCjTIbUD5H5Vumy9oRx4iZihw7RvJ6LRKVAVL3Q2YPurUX/9mFC5eSJx2pVSerRCGNd5up+ig96oSwxnOUn9NW/Xwrjf5dwsnnWmngguWDvg2i16v9hN6iQK
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 19 Mar 2026, at 12:03, Brendan Jackman wrote:

> As pointed out by Vlastimil in [0], my proposal for __GFP_UNMAPPED is
> probably not needed for 32-bit. This offers a way out of the GFP flag
> scarcity so in preparation for this, flip gfp_t to be 64-bit on 64-bit
> machines, while leaving it 32-bit on 32-bit machines.
>
> For mm-internal code that prints raw GFP flags as hex, this just update=
s
> the format specifier to %lx. Presumably developers have a reason for
> wanting to see the whole flags word as a number in the log. For printks=

> outside of mm/, I assume they are only using %x because the authors
> didn't know about %pGg, so they are converted to the latter as prep
> patches.

I think these %lx -> %pGg patches can be merged. They are nice cleanups.
Thank you for doing that.

Feel free to add Reviewed-by: Zi Yan <ziy@nvidia.com> to the first 4 patc=
hes.
(I did not put the tag in a newline, so that b4 will not mistakenly
take it for the whole series)

For patch 5, I will wait until you address the feedback from Vlastimil
and Matthew.

>
> Stuff I've done to try and find issues with this:
>
> - Built x86 allmodconfig and arm64 defconfig. Hopefully the 0-day bot
>   will alert me to the important builds I'm missing (I briefly tried to=

>   build s390 and sparc64 but ran into tooling issues and gave up).
>
> - Ran some selftests on a x86 VM.
>
> - Poked around at stuff that refers to ___GFP_LAST_BIT to see if
>   anything looks wrong.
>
> - Ran this Coccinelle script to look for explicit casts to plain int:
>
> ---
> virtual report
>
> @r@
> gfp_t x;
> position p;
> @@
>
> (
>   (unsigned int)x@p
> |
>   (int)x@p
> )
>
> @script:python depends on report@
> p << r.p;
> @@
> msg =3D "WARNING: Explicit integer cast of gfp_t"
> coccilib.report.print_report(p[0], msg)
> ---
>
> Obviously this series doesn't "do anything" so maybe it doesn't make
> sense to merge it unless it goes in alongside __GFP_UNMAPPED, but it
> does seem to make sense to review it independently so I'm posting it as=

> a separate series.
>
> [0] https://lore.kernel.org/all/6206d021-e6c2-4899-b426-cacd71ebd5ef@ke=
rnel.org/
>
> To: Andrew Morton <akpm@linux-foundation.org>
> To: Michal Hocko <mhocko@suse.com>
> To: David Rientjes <rientjes@google.com>
> To: Shakeel Butt <shakeel.butt@linux.dev>
> To: Vlastimil Babka <vbabka@kernel.org>
> To: Suren Baghdasaryan <surenb@google.com>
> To: Brendan Jackman <jackmanb@google.com>
> To: Johannes Weiner <hannes@cmpxchg.org>
> To: Zi Yan <ziy@nvidia.com>
> To: Harry Yoo <harry.yoo@oracle.com>
> To: Hao Li <hao.li@linux.dev>
> To: Christoph Lameter <cl@gentwo.org>
> To: Roman Gushchin <roman.gushchin@linux.dev>
> To: Uladzislau Rezki <urezki@gmail.com>
> Cc: linux-kernel@vger.kernel.org
> Cc: linux-mm@kvack.org
>
> Signed-off-by: Brendan Jackman <jackmanb@google.com>
>
> ---
> Brendan Jackman (5):
>       drm/managed: Use special gfp_t format specifier
>       iwlegacy: 3945-mac: Use special gfp_t format specifier
>       mm/kfence: Use special gfp_t format specifier
>       net/rds: Use special gfp_t format specifier
>       mm: Change gfp_t to unsigned long
>
>  drivers/gpu/drm/drm_managed.c                  | 4 ++--
>  drivers/net/wireless/intel/iwlegacy/3945-mac.c | 4 ++--
>  include/linux/types.h                          | 2 +-
>  lib/test_lockup.c                              | 2 +-
>  mm/kfence/kfence_test.c                        | 2 +-
>  mm/oom_kill.c                                  | 2 +-
>  mm/page_alloc.c                                | 5 ++++-
>  mm/page_owner.c                                | 4 ++--
>  mm/slab_common.c                               | 2 +-
>  mm/slub.c                                      | 2 +-
>  mm/vmalloc.c                                   | 2 +-
>  net/rds/tcp_recv.c                             | 2 +-
>  12 files changed, 18 insertions(+), 15 deletions(-)
> ---
> base-commit: 8a30aeb0d1b4e4aaf7f7bae72f20f2ae75385ccb
> change-id: 20260319-gfp64-7a970a80ba4e
>
> Best regards,
> -- =

> Brendan Jackman <jackmanb@google.com>


Best Regards,
Yan, Zi

