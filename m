Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 10C9FCCD1BE
	for <linux-mm@archiver.kernel.org>; Wed, 22 Oct 2025 20:33:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6F24C8E0018; Wed, 22 Oct 2025 16:33:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6A1958E0002; Wed, 22 Oct 2025 16:33:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 569478E0018; Wed, 22 Oct 2025 16:33:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 445CF8E0002
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 16:33:26 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 1AF27160948
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 20:33:26 +0000 (UTC)
X-FDA: 84026900412.14.4E06087
Received: from BN1PR04CU002.outbound.protection.outlook.com (mail-eastus2azon11010047.outbound.protection.outlook.com [52.101.56.47])
	by imf19.hostedemail.com (Postfix) with ESMTP id 3C5ED1A001A
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 20:33:22 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=Vv3AVaq4;
	spf=pass (imf19.hostedemail.com: domain of ziy@nvidia.com designates 52.101.56.47 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761165203;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5uiAn2Nj3hkYCpm5roLv4RUChIAe17obrig+Bplr9XY=;
	b=e4W2+uEIO/cVKJQ3wMB3pAL6hU7aCteY2NN868fYDhnXFCmKOgidPDbkApMB0zofINhND0
	51+uMDD7pxGHbGp35ZBypmhq6O57qqqSLaJDP8GX04JEjQbY6Zd+6o10CkvA6hnWymXyrA
	PfEAuCvBZ73KNPrFhSspFR1VYsINT7M=
ARC-Authentication-Results: i=2;
	imf19.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=Vv3AVaq4;
	spf=pass (imf19.hostedemail.com: domain of ziy@nvidia.com designates 52.101.56.47 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1761165203; a=rsa-sha256;
	cv=pass;
	b=fucwId2tEgm2rYf7lBPEajJn2o6DBn4I07LKF7Jn8p2y2wmUPZDFQNSL6FnUf08rxjo9pv
	kkFBDdJpPBnyHSc4TI/5J2nBUQtS/oEj96OT4GfDrdtQOzvc14i07mMjF2AUOhc/Qb1aqo
	zMe34N4KG3Mb0gRirNmXhsfaX5p8wCE=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=hyEipfZfwiQMR2+5b0EpFPPF8B/s32abjyCB82HGwyE4L7xiuzkDfeqbBUdLyWdfKEbT6llmKDHYbSsd+Zy2BTgYWzGr2cCxFMC3oINxjCiYejoTLcee8DPaPRLN9+jFh/S/osXuITAcOlwElQ/BKXi9IDmzDlYSwkoGccCXSMsipwhfT+Zt9i93dVCYXoXVUA6r54Jx26SS9ErwYye+PztzJLBA1sEgLpasvY8PUOYZfsPTcV1Z2QtwTDSEiH61Ex8sDOYmcy9aBQlhEKNsQ2jU/EXncVC51EyvY32FEDHsaGSiTtyWKThYK54V3FvwoLpK9jCD9OYn3nhqLj26bA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5uiAn2Nj3hkYCpm5roLv4RUChIAe17obrig+Bplr9XY=;
 b=H+zA6MtyVfJ5fmAD1bQs500OrmpSc/6zqF3p8I7Gs++sE+wrQzFPodBVz7bD3/MVfUEbwqrJKcNSLT9s2Xc0Oz7juhQx9yZl27c1zqp2uGfgzpp7BZiAarCYvW8ekgWQ5qFvO4Zh9Hzd2Ee4ZLHQWIX8kTWTOKzAhvaGlaHOQNrOp0tG4sBtzUasSIAI1lMxCXTqf41uVGZr7NoQdWL85DtsHk+YiOh8a0a1ie6hgvMYCgm7hGv4GbyJqgJpkMrZF1aTXvsj9dzlguP+IiS6eSbXHhAONtb+n6eVqDFRc1vSYsO9US4ZTSn3i7H92rqhrPd83NVHq3ZRgQ+qgw+ynA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5uiAn2Nj3hkYCpm5roLv4RUChIAe17obrig+Bplr9XY=;
 b=Vv3AVaq4TdUMhjaNx9cIGbOPREsbUr6yCy2xPpO4shRXPWkC/rXPV5pZgRNdvYf/1M4wL0yXLtAIN5C9D3MecGW9rypbDK5/44G8ZTw8rB604EhuFPWY/DPrcXThLjPbsvHpZdfG0E7NeyOMCq55+3PkdrzosbU/B2dx2nkaXYXql7FCWmKwnxMmFwk6l1HmJEz7XXX3aqkUft9NnwSIFc8A2oVa6PZT3iZp5wcumAH3yC82iiM3luVE1qwU80LEKrka+x4nZSOCc3tif6grvLj7ehIEgrR7Itbr7yZPbPByMZJAXu3gzd775mf+Q6PsdIPhdKVXm5lNkbH9do5tmw==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 IA4PR12MB9764.namprd12.prod.outlook.com (2603:10b6:208:5d0::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9253.12; Wed, 22 Oct 2025 20:33:20 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a%5]) with mapi id 15.20.9253.011; Wed, 22 Oct 2025
 20:33:20 +0000
From: Zi Yan <ziy@nvidia.com>
To: Wei Yang <richard.weiyang@gmail.com>
Cc: akpm@linux-foundation.org, david@redhat.com, lorenzo.stoakes@oracle.com,
 baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com, npache@redhat.com,
 ryan.roberts@arm.com, dev.jain@arm.com, baohua@kernel.org,
 lance.yang@linux.dev, linux-mm@kvack.org, wang lian <lianux.mm@gmail.com>
Subject: Re: [Patch v3 4/4] mm/huge_memory: optimize old_order derivation
 during folio splitting
Date: Wed, 22 Oct 2025 16:33:18 -0400
X-Mailer: MailMate (2.0r6272)
Message-ID: <E1945CA9-F719-4487-849E-909B094F7A1B@nvidia.com>
In-Reply-To: <20251021212142.25766-5-richard.weiyang@gmail.com>
References: <20251021212142.25766-1-richard.weiyang@gmail.com>
 <20251021212142.25766-5-richard.weiyang@gmail.com>
Content-Type: text/plain
X-ClientProxiedBy: MN2PR05CA0047.namprd05.prod.outlook.com
 (2603:10b6:208:236::16) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|IA4PR12MB9764:EE_
X-MS-Office365-Filtering-Correlation-Id: 9d0c13e4-02de-4e69-6693-08de11aa3d6e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|376014|7416014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?tvq+9RKUau3LuWbqadTTAf/5nr/VSoybMQVXbv4lDOrFM/ogYfCt1D2nhNfy?=
 =?us-ascii?Q?fLv7uszmxETQ/dHzA7YPR3L8nmq0BRd9PFgqFmINVA7bXzSj2KBm0snX9VZb?=
 =?us-ascii?Q?KU7gpNFbvql/TC+q91Adu7CD0DvBT58C0VHawlzCtGPoumi+zYC55LVZcN7s?=
 =?us-ascii?Q?mnECYFThHNt3jnN1vH1t8sF/Q+bJHwWFsA7TlV7yxavJZb+l+nK8SyUrHGzY?=
 =?us-ascii?Q?1ygZ+5RWVTyHxsC4Wa6iL492Q7nVSN9e3OibV31Vi7CU9Lb50kLQIxmGRPRW?=
 =?us-ascii?Q?O5ctFULMlR/qk3vnKxaWPa0e1ny1IRAFQ4Ss+9TouxeUJncjeVhKnIRrVwW0?=
 =?us-ascii?Q?Z0JNuFhopJ4GUysyI5XyFs/7WtQuUMFNNGXJWN2sZFLwtAfNiMMoxJKe6lh4?=
 =?us-ascii?Q?HcXHSS1+dsIzQuDeDZOOJ4tggnwHd7csrFLuaSlgIe1rm3YB8K9agf9r3eX+?=
 =?us-ascii?Q?a8cgiejeJ5swTAuRhMV3BggdoXXzWWVJNAf9qjLtvHLrn2Kt2KsvnEoH1wGV?=
 =?us-ascii?Q?SmmoeV7l94qI9mRbSwXE/xhjYC6NAbef2cXW0mshQiNRlzWodvTjpAE+i5Ob?=
 =?us-ascii?Q?w59uasAdOQnDAZJASiXCAyCehQKVHcp44n/tUwKqtvt+m5R6RmrSP76SCOkh?=
 =?us-ascii?Q?/H7nzuNNjgIwueXxl1iF/zo/EkuFwdNvcg05WAFhRKbSujHyfkMLIpbaKFs+?=
 =?us-ascii?Q?7kdsb9k0lOYJK3LfIg/IFQGFs7aSYchpb6INm+M1KCa0sMwG6PqJ7vdmWZcN?=
 =?us-ascii?Q?7SGQBdLvgpHj9WlmaRHLsd8knI/zuOhU7ZjWTF/VGBUnGUTM5XKzlHow34fE?=
 =?us-ascii?Q?Kjcz1XkC2IhKCy6+ydwqNSTfQw1JDy6qkBWQPcRLMlI4xVlwrV+OyPxU2NWH?=
 =?us-ascii?Q?sX5b50PR6aqiisc0Mn8V3+38xf+ouEjM9Ejry3+6rTfQzEDCNBBBiFpMi/BH?=
 =?us-ascii?Q?XheG7AaUHAtEKbOkggzjbFnbIlrdlonVZhNQ2QYBzC3y6tSVZVGmr4J72jJV?=
 =?us-ascii?Q?vMlH837esZApbSQaY1vPV5izeJQmh1BDSFIXaAxPcgeGRR2RjZs6AFpHjh9Z?=
 =?us-ascii?Q?48aSY1wz0VxZpaR9OUINL0hsH9gJPWp4/icoLcvYqE4sjWiAX93QaRuOPIE/?=
 =?us-ascii?Q?woBKaoJam+JLd8XOidyyEfFZY0ZL9KmDn5ZRCq2GBvA19cDH3pO3WBMp3jvh?=
 =?us-ascii?Q?5q1/DBxlULpwCiqzmV0LTu49GzwQpb7MggI9S3iMawUKEwkl/SVhXQow8iWi?=
 =?us-ascii?Q?wXLt2WwI94vHodxTXm5Jt8dLlkhoUF6aCugwapuYwmL7lUVaFjraB2h2hmi9?=
 =?us-ascii?Q?0QImioCfSkr4BzCfqG4jW7HJHh09hyhOvfHWviCraAG0tk6OLmghknMxo3ph?=
 =?us-ascii?Q?M4UKpMXvPDn3BWkK0xyNfi0mUda7VGuFDe6Yr8U2HdlGo3pQs2esdDTV13a1?=
 =?us-ascii?Q?PZLMBzWLRgDdBe3yIZNQYUzOcPe+wMdo?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?zvCAG8OBEZ/aL9NMAes22Jqri0uNXyDEmcAwRIhOcu60hmmLLGkoWok+Mx4S?=
 =?us-ascii?Q?UM5B4RDE0XQLonkHGJVraBGFllLV42UhGwf0l7MncMCdJrrJjpOf1JXIJjk5?=
 =?us-ascii?Q?xitHv7CVwYEmhgnnf8D8v2GSq9R3t5eg0P4Iw4IS3At+oaSMthJDeWy9zL5V?=
 =?us-ascii?Q?y8tEVe7QOeGeRv4l+x7xiWUpLfcnlWZIv+8qAoM+J6eTPd14myegAOEY5VNC?=
 =?us-ascii?Q?oD+BfVrkkX3/MoNPq82A4D+b3txqsD3h0oPx88Oc1LuMPfT5UQoKi91Jq+Ms?=
 =?us-ascii?Q?LUAn9UkYmdEPwxnCW+KyAq0GQb9EMWMAVQP2d71+no0pAnxOd7ws9yqpLOlm?=
 =?us-ascii?Q?AwpdpA4LATDdg9MV+xwU/53tB6BKPiyHYjPfSZB+uHLoPHlGEiS+ucO8Qayp?=
 =?us-ascii?Q?IcTT2GS+yVkqnCJJwqxV+iGAL9vlyklqF1Z/aAz/KRpJqXhcRuMhnQST8U8M?=
 =?us-ascii?Q?aCBdzBU9MgvWleBsyboWR1spQC0piLy+7MT81n6m4t2il8T8SIQPJtZDP3VQ?=
 =?us-ascii?Q?oKRqrNj06M9PZr3viet3A5xf0z9WPzDt/mgFSzThLtGITOiPlTY0ViNwDC+Z?=
 =?us-ascii?Q?Toc1NZkNhcbnDy+v5f+41Y4WDvPtC3bGD0tEOCMDFCoE3sa2j12gtgLzsv9d?=
 =?us-ascii?Q?c9ripVuTyUch4ibGMrLCMBE69hYCY8FjVmqWGNC3CSfA+FPNwNkfWoUVhlE2?=
 =?us-ascii?Q?wrPXD48FqerK/J8PplKk8bBWA7vXVerpjOmAAM7s4USawvFFUP6bXNy01qn+?=
 =?us-ascii?Q?RRq8jujaVLMhKcPNh1mUsgCDM2CsuR0GRHnuo63DXGAFN783bD8bskudBDyJ?=
 =?us-ascii?Q?kzqvMCg4D1XrLEC0iBekPrDQM75ZFqzLwTjBf9wt40PqsqE+XUypofKDU3Cn?=
 =?us-ascii?Q?tM9j9V/5pdiuHKKAdhtMu7C8n8ja6WupGCuOZZHKYyCXYK5CUPsMQqdnFvac?=
 =?us-ascii?Q?E9dLfktZzyOcIFLTYAwUlQ8WzyYosUANEPg+w0S/Rkl840bLWiBvQbgS3Aug?=
 =?us-ascii?Q?/F1Ag9wL5CQw8oB/iiQdsNoZIuYFin9jv8olVYT6sC9kiExOy+reVXBCLeoA?=
 =?us-ascii?Q?Ixu3dgsBLuZAkyQYvTioC3KAGc14SLgLwRnmRuZpMhq2AFEXUGlw3WxInogD?=
 =?us-ascii?Q?w2xMdfBaolv2PKk/vRQtntPoi2D0Qkb0xWL5ce7a6Ncg1jcKTiQfYx3Q1Zp2?=
 =?us-ascii?Q?9x7N5Tqt3HFDKZnDTJ0smEfdcBLHSjzuF5N5uMqJ6yq/wsTJ2kibHhbutJQF?=
 =?us-ascii?Q?cy3vr/3K5rSOVMPJRSdMSMXq9VyICWVF0VA+g6HGKk80WKHL7BUcpFaCZOTA?=
 =?us-ascii?Q?luq5k3avoh8mSDHYMKe6qdkwA/l3NohynyN3NRTxDzWL26h1EpVCDkZ+tKKq?=
 =?us-ascii?Q?8YOrHMwsoU0H+qxl/iiBMq8QghR/h9wV4AVjQleBL0cMC18QuZ0nYfDArWG2?=
 =?us-ascii?Q?Gv+x4Xrwu8rUs44Fo/JO3COHiyvagtZIXlgIUQUR2+PfbmeZhgNehOsilgnu?=
 =?us-ascii?Q?w0R4DhdPlvJ7QJVNAg1Oz1+9PtZpaoS3KbVPOtx9db2QyYPIrK5+kdk+byDc?=
 =?us-ascii?Q?1YmAw9xyvPDSvR1RNeAZMxmNiwZNZKqzyPmbZb9Q?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9d0c13e4-02de-4e69-6693-08de11aa3d6e
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Oct 2025 20:33:20.7501
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +ePrLfhYbs5+elRrdwUTwwxlMYzWF6xB+Eft0ETpsxydaeIJMuYzfNWwEt66HewG
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA4PR12MB9764
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 3C5ED1A001A
X-Stat-Signature: jq9exhyimbwtd9fw45n516apypuajd89
X-Rspam-User: 
X-HE-Tag: 1761165202-743287
X-HE-Meta: U2FsdGVkX1904y/i0ARVZGWebl2OzE8KONYiuZsDDk6yAMqwytsmwwrv0e1VhyQdw+8ln0+AEdchBiSlk2gOTQtGrewVsfVt2wJhECttcs2l929WDYpuDIAn9/SAVOe0jUxtdIdX43vzG1zb2d57UwpAN4TvQ1yjRhJOPPPdmxTY+OBVcTacRga6EPOrlFcNkpUmH11YiHWgG7UxGCSKKXq5MDF4NwRXmAnU5Q5rQlX93dyap61koiab7k1Ezl8Z/ILX1ardjEalShYvD1cXT10WHYGlxBkYtxdwE+k0sqnCq81keUS6vjJHYJORVlH7l8c9nVyO8bmmrVptKYrJuAunILAhz25NVAPEN9/FVAJwzh3Sk4/jSyCXHdO/Ezq13oC2UwznEqcLucFGHmPKofGVZlycBfiCkm5VSWvfvtVj4EjzciaLZLNO+YsEkVroQFAwC0MabW8swWLAykB2k/618OfgcdLxJSFtAFWuAcQlgFUMNUCU90CF4/2MWWreFFcJl30RUwXl6YGRS4LMewqOkpWbtSOItMQJ8k5M4ajxy4+GKK9mKmy0QLt7pWr0HMppLjicx1HY6b+5Qk+FdvkAUJ1REnWlV6iXxRmkg/RV4OBQfkF+TbddrP/DSWmbpUZjpxK6Cin7ZsaJ+MN9lyirOccPaef4VngXoORwmTUGgCed1LglLs+Ba2Esn8zPCptYjpGVUTeCoy6mxDIE7CDjJmOJs/lxxIsB8hQ2CNe57WHZcPmUxYAlA4r6NaUaYNzRl+TjUWhwfMDQ4AjlNJK3xsvjNCzwQNgeUD34KsNwC7jvJs2dluZ0bPZ/83VHUY8xhxL4U93Wjozqtej90xSmGwsj0DNsk2rLLYeB3tyCrAVEReyZB5/BAVX6oA+OxmDX68sfZU/OKmRZZI6Hy6l+2vzvbVt4rK3D7YzWxGDQZ+5SbInlyY/nWSluuyIiI+cvuVBuY4Xmpuwfnjh
 KgNeQldm
 bSy8gYy2O2h9iUpQOTDFJ8K5TZLvbpg1xrK9NQNw3zwL1iLlNz+EJF6x+xyRL2RoZ0sc63qSkrAlsd3fc97ybIJObKY1aVIKhs2ar+HZ4RIrChxyLVXUWOxu/r48QV/R6p1BynmaRsTLtY3qrjgTIsIPr2rJ71OockekNrVpaCgkF0ur1o1jrT7KPLWmcQr2bk8WqMP1la21sZxwYCv49X3Mn1k2Wh2L48EVHSvjtRKJhhHvIPsxT0DVhlap1jmNuJfxqNni7uBP3MGgki/o2YyqeXdTuSOa1Z7qJEJLBRJEZfuEG6drz6yZ48X+YXl1V0XL1iAEpXPcas4ts23XMk/4d1tRp3ka04OlIaSUbpkORyPwlWFh15pfKPTGVMb7yy0E3rU6uSPxCGDnY3Ia6c6pr4lMyHoPbY47SHGlANLAdMGYT+ChCrQl0sP6BS73iar4mUeTHN5BsKAR3LVMOi7pUeR1PYzCSX48UVTwQIvkMxZk=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 21 Oct 2025, at 17:21, Wei Yang wrote:

> Folio splitting requires both the folio's original order (@old_order)
> and the new target order (@split_order).
>
> In the current implementation, @old_order is repeatedly retrieved using
> folio_order().
>
> However, for every iteration after the first, the folio being split is
> the result of the previous split, meaning its order is already known to
> be equal to the previous iteration's @split_order.
>
> This commit optimizes the logic:
>
>   * Instead of calling folio_order(), we now set @old_order directly to
>     the value of @split_order from the previous iteration.
>
> This change avoids unnecessary function calls and simplifies the loop
> setup.
>
> Also it removes a check for non-existent case, since for uniform
> splitting we only do split when @split_order == @new_order.
>
> Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
> Cc: Zi Yan <ziy@nvidia.com>
> Cc: wang lian <lianux.mm@gmail.com>
> ---
>  mm/huge_memory.c | 13 ++++++++-----
>  1 file changed, 8 insertions(+), 5 deletions(-)
>
LGTM. Thanks. Reviewed-by: Zi Yan <ziy@nvidia.com>

--
Best Regards,
Yan, Zi

