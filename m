Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C8CF1C87FCB
	for <linux-mm@archiver.kernel.org>; Wed,  6 Aug 2025 19:17:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4EFA16B0099; Wed,  6 Aug 2025 15:17:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4C6EE6B009A; Wed,  6 Aug 2025 15:17:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3B5D56B009D; Wed,  6 Aug 2025 15:17:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 2C0176B0099
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 15:17:35 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id B2A3C1DCD63
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 19:17:34 +0000 (UTC)
X-FDA: 83747291628.26.1AA0D3E
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2055.outbound.protection.outlook.com [40.107.92.55])
	by imf11.hostedemail.com (Postfix) with ESMTP id 03FD34000B
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 19:17:31 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=oGYZRSL4;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf11.hostedemail.com: domain of ziy@nvidia.com designates 40.107.92.55 as permitted sender) smtp.mailfrom=ziy@nvidia.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1754507852; a=rsa-sha256;
	cv=pass;
	b=8Kax2QkfoEuhIk1nzecI25ZHxMGBrv0jV0OB0/83wzjBuQvs+QkLYs1GpM7TFsiPIIC2+B
	rh2A6t8LgJaB7Q8zaqIdQbwhJaiTswsaI1l6b4cIXIqEXUiPFNfFzef0pJUwusgA9NWOI7
	HEdL8m3eSD7jFZ/Sh9CsRYpdSANTCaY=
ARC-Authentication-Results: i=2;
	imf11.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=oGYZRSL4;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf11.hostedemail.com: domain of ziy@nvidia.com designates 40.107.92.55 as permitted sender) smtp.mailfrom=ziy@nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754507852;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UINxvMIczABs+wFrpA41zpHbpylxGE4uVP/EztsJFm0=;
	b=jv1jnmu0ac750VIO41Ni6X2OzdZlcmZg2n/eSqw+XhtRig5dCfxCPCENBOngrgNpONFbs5
	9tHhOc3lII3ZDXLryDbLJYYKGxw5HGUjEGr95ZcIeuj3zsf4wukZCfXb/0YaMOSN1ksSTW
	MI4nPmrPws105Q9d51UtBOyKmdqhAXE=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=sAMTXVl3unhSKihBPcGVCLU2PdYQYF/0AEh0/LEZeNG9h6JKMIk3DhfC/6WEwh4WsXHDSLjWjb1qiFsA6b73KLvLlxnGmqjwp4kTdfGTfNpgzn5yKRsGjgC8u0+9QCPcf/ARIC4ScBmQtg09XzsfqKE0zpPTiPyEr3+/JzjEe56MxBbBLaHfhBt7PsOuCNDfaMzwlS0/GQ7muaKntJxgLSYO8vj4SAcgws96e15+RVJRMRNHtOeRv4ptgI0bm0M0np4Ns9pkoqrjI22npgNts8vvZjX/h71E7eoyTgZLPBkMyhIkFKasi//3CJXtDdijvS/N4NYTtMQb1/u6cZn/yQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UINxvMIczABs+wFrpA41zpHbpylxGE4uVP/EztsJFm0=;
 b=ZhbsYB5Lx99pHXjOc3cUIRaPUXCX4AaKw6SzEscYZyDW8AGOB4grxPZvotLjMpbhVrxZpTDFaOJEqbl3EGR90OpCE4Fy24JFIx7GOj5lPhP0wagP8BoLKoBnODLdh7+BLbb/xsAv1ODAnQzoDNVULhZhpDt3z9BeWtesLXchRr7XzXSkLl2rsSL2t4IXdns+FlbSbd+yaySabi++Z3/jNzeBOJA7iT6EDrvXhzwCtOqXxOrvIBjw9GO7RmZpG9b/DdjcvTDU3Rivel9FYvtUANJ1w2DttRBFc1TXHH7JZs3HJMhlLoFdvf0GASQCMu/FS2dbcTxT+kAaMoGeHii7Mg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UINxvMIczABs+wFrpA41zpHbpylxGE4uVP/EztsJFm0=;
 b=oGYZRSL4WvCR48ZlRG61y76rUKqxsjvbncwsTp0Hew4M6vbZCXN0bAdUXEbqJ9AB0MIYfHK62gPb0canKUQACYXbjohXKzTdRpvxHAtDi5pGtCLP3I/VfH7ZXzFoTCy8dMFdKvDFG5JmnrTU2rUtgQheECNeD3MoLUI1am25ZQnRa4wAEmnGPRd4iR4HilSrgUaXX/Nu5O+84MGkv39oHSoKvOM2HOVSJ82TGtiUW5gkQv7qW9OS6zqDYpq/uK2ov8D+LHhU8R0ey0ZyRvffytkVDcVf76akfpS6Vn2p2TW7aXiHMToIBOzTnyx0HdRkgUue65z2iYv1eZBPT/YTSw==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 DM4PR12MB6136.namprd12.prod.outlook.com (2603:10b6:8:a9::14) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9009.13; Wed, 6 Aug 2025 19:17:29 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a%6]) with mapi id 15.20.9009.013; Wed, 6 Aug 2025
 19:17:29 +0000
From: Zi Yan <ziy@nvidia.com>
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org
Subject: Re: [PATCH 06/11] slab: Use memdesc_nid()
Date: Wed, 06 Aug 2025 15:17:27 -0400
X-Mailer: MailMate (2.0r6272)
Message-ID: <2AF03C90-80B8-4751-9C46-D8BC0FEF6311@nvidia.com>
In-Reply-To: <20250805172307.1302730-7-willy@infradead.org>
References: <20250805172307.1302730-1-willy@infradead.org>
 <20250805172307.1302730-7-willy@infradead.org>
Content-Type: text/plain
X-ClientProxiedBy: BL1PR13CA0225.namprd13.prod.outlook.com
 (2603:10b6:208:2bf::20) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|DM4PR12MB6136:EE_
X-MS-Office365-Filtering-Correlation-Id: 4a7755e5-2ed0-42d6-33db-08ddd51de299
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?4ovd8qjsqsO5hmm/588/3dcGZpzBGegjrCQ3LS9SZdg74IsguMz2jpacNC4N?=
 =?us-ascii?Q?hM10MXSPUc1ewGXbRKCqP/oW0s0zMY5bkD8JtGH1VWEm0oZB5j7pMQMZXKGC?=
 =?us-ascii?Q?BUvGS0cZ9CZtQ3Yv4Ztj1RIssg4vQYDvsE0m/dYVuiLa+WJp+KtD2FCH8d6P?=
 =?us-ascii?Q?zr9OzcbyzlkzKcu4AMiWe0DdV5z/z8rAwIxEyJwMvSFo/2NZOEyfeT3XRfxU?=
 =?us-ascii?Q?QNCsuMIoGUa+jFcdwkHHbDVjMdw2jcL2JC6w7mJj35u1IHYXVmSCDW7qM3wd?=
 =?us-ascii?Q?KI0nnMYoNTAxmBkiny3kkj4nlZEqH0/UI/BSh7fvMiDXAe0OzPMpjIkApT8E?=
 =?us-ascii?Q?qm179C9FwRfBbZ+oPhTzaIwwO8N1KZSZoxzNsajMPJsDDQH0RgPgPeCK63IZ?=
 =?us-ascii?Q?uMAUIp9aWcSz44W/6VB22/nWTDajxXqso0hRuD/aKOSg+fZ/g6JZb7bXMl1i?=
 =?us-ascii?Q?3MUiAK+T10r7D9aazH5gJmoI5N5zWpwbP20moPJSQYbXi2rT+p2tDYydPgDo?=
 =?us-ascii?Q?TM19MZ191G+2Ypo45NbZwmvOZSvbHlHwzIPk2KqGkRip6n9n8yqS6IQQX8AQ?=
 =?us-ascii?Q?o/L+MvP1Lg0r5u7+dxyf7bqM55sBbcrvEnlsjK0Ud79Wny7+toSJBrqMmDX1?=
 =?us-ascii?Q?jZy5wN5Rb5UVYJBTbY4Qvu6glHw/eq54Mfe49pF50xx6NOWMXH3PKoo3MZ9D?=
 =?us-ascii?Q?gfD51iL7mrps0PglBTd/1UHK828USgk004UioTLqJz1K9A6BnYAedNysNltd?=
 =?us-ascii?Q?Y2lAg22lSR63y+/YyTRV7edt9GOkgFEH98DwJgTrp27a2xcBmLlI+v2mmj0k?=
 =?us-ascii?Q?uyIMlIN2FpzYHEzb99h8TZnJq188ez9bYeBZRyVi/WWzLWnmyUeAx/XSIjdV?=
 =?us-ascii?Q?dUO1RHtr2fbOxWn4kkV1zA+qCWL2FBGp9sVqF5T1nPm9FFsbB79k9HoUEDWL?=
 =?us-ascii?Q?wIQa0h/SeGW2Br5FhWWU4vkeJRpfOZud1OUJzMRfMhu+I7314mGAh0cXokJ1?=
 =?us-ascii?Q?TUgQJ7WFYCprlf6nnX+MbrlOW9vkPKWA8jxyGnc8ySzNQMbUKt7immaGWHJB?=
 =?us-ascii?Q?4Ft3O3W9jh67U3UucKSxlWaw0AiRMmkjdyAccHkdpwtPGFNtjxxKE+SX+PJV?=
 =?us-ascii?Q?DOL1huOjQ0iJe/JkQLrtcsVea/fMaG5LV5nAy4w6e+MFRToHWCqpdzBK3JE4?=
 =?us-ascii?Q?OL6UE1y9si7IaPGai+MyJArxcsR8G3chZ8QcLe3/GrLdzEEzI3wBrecML41k?=
 =?us-ascii?Q?8q/JF6hTWACP59BHYGQYgTCkbRi94bO2e0T6Rd7DMqho3mib4OuvynxSP+re?=
 =?us-ascii?Q?koFueTYehCklR+JBLh/JR4mTiGdlnbUUus1wA/jrCh3BQC5K+81fhJjAevBJ?=
 =?us-ascii?Q?OYEFSQjIlMJx2bCS058qh+FjFXYG2cD0aLbYYSYVNmorAMMjZIlOaNONJnrT?=
 =?us-ascii?Q?fk5ajtA5zmE=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?wm5iGl21T/0meHkiGarC497r3Q2tQW5V3gksg+Z99NgvZ+93bZX68RMZDZkX?=
 =?us-ascii?Q?UekYvWpfWI94sOotNIdR2bwZJv9FKTS8xdaQ00JMNwlw2jOo94kgCyT/4BVy?=
 =?us-ascii?Q?rzbvaHUpSSWuOpTDt6TGdIxDaUqI/279BH5534NyQiF8trXXcI0mOlmKa1nv?=
 =?us-ascii?Q?B70Sc5ooQjYEFTHlr3aC80AdWmzKGb+6z8J7M6KzVKi85JsZLDrPAre5RVf9?=
 =?us-ascii?Q?rZ7H+pXkB6ef8Scclvj8m2KUlxm3EQfutujeu3wslyR4CVTjBwULMl9z/k4W?=
 =?us-ascii?Q?AYkrhh+1Um4ygHRSruQMHF86NC5lRXGDN2UhsLZe7QywNLZlcjVkj4qVJRfe?=
 =?us-ascii?Q?JIyTxMMSBaSop9OAUjFJaNOVqFYUHkjPWZ9nCR6mopzX/6UK4/5JFxL7uZI4?=
 =?us-ascii?Q?M7KulOlfwtweDZbtQsdtK+c41r+vpVXtsMHQosa7di7egohuOguoO4MM8WHx?=
 =?us-ascii?Q?ujEcs3w5+oIWLL5eqGlntfFSm16b36QTaaOOwUuoA3k9ZF5FAJqV5hCTr6mt?=
 =?us-ascii?Q?LurCOFrhqO+GMIXMA7Ve8CSmPPkSvcLvP7cta7FTKl9QZ/S429SGGvrHZ3xP?=
 =?us-ascii?Q?chVkDOGsMBzw9twR4Hm4kJghfclTzY8vSGSa12q95mkq4kMqjxmxdJFJ4K4r?=
 =?us-ascii?Q?rWhGpArAK1RoylbCqlMSao348nmFdoWMZEhH1FM4zgcsy8ZeyqwV9PeG/6m3?=
 =?us-ascii?Q?1nkx2FJyT5xKdjHzG5LAFpEzTVQaU0NFp75bWqyAv7tB8q+QU/8aw5dGNwkZ?=
 =?us-ascii?Q?u3f4SjrH8SKVuV80DL57v9Y5e2FC4QvMff7Tex7Ms7Ikfo42faDl6dXpKawJ?=
 =?us-ascii?Q?GPJ6hkfqT3OyBw5Uhlvj+g6ObALkUiuMChNirVgcjkU030IATuoUtmV6mE0N?=
 =?us-ascii?Q?CqB4sBlBwc0xVyLMrB2rl/oC4MfOGMWqi48WAFXsEwDOlR/YMPjIWXRtMX3k?=
 =?us-ascii?Q?BOGU+LWntWw3E48PtNUfsz5CLVKdJwbbW3p7XjFunElk5Q0DjOTVluj5qqNg?=
 =?us-ascii?Q?Y0dTm8EeymrOcvoJFnmq8RKaLWjydz6wi17U/An+XcjHNP8uocqlY1+dxV6z?=
 =?us-ascii?Q?/7L1sLrSFtvrHifi39K8CljgMZD4LQVDQohOZU5AwgPnrQoafy3RDkVjhNzE?=
 =?us-ascii?Q?rI0i1pZ9hP6inepMkOrIqTpCZoXfotTCUhAY5s9LxGtul+N6mv4XRkD2s6Hj?=
 =?us-ascii?Q?zo0ycvGRGWTENMGkLRpHgfy1+9/W1NGVl5LQOyRMLt52ksmt+wxYnfwg5Ymv?=
 =?us-ascii?Q?B6JtyM7RTPG9a/MrZn1NFyVOaDHqe0OsZccZRXNs3XddRdOvME5hjiw9jQnw?=
 =?us-ascii?Q?pUkmHrLoo4p5AKjmU+uCVjBMwd7SlQFTDDNT0IEqWPn/WjulylH+Vbfj5Y2i?=
 =?us-ascii?Q?u9KBHUtTeai2CMf7JQaQdrjL+/3fs1fjVQrpr60EHm9IKEnNpY+W6iV63HHd?=
 =?us-ascii?Q?3XRsJG7ayrdHVfbEkc26pj66LRDm2f7AeIdq6SagwPmKB1qiLH8ZFJMzkHwQ?=
 =?us-ascii?Q?tzexDEXp83Bs2XOAoxTnhn/giqA9a3CqFvCuOHbMF27hQtBejrwaRQRLGN+E?=
 =?us-ascii?Q?Ahe+/DSW24T6DU+tESVGVD/sFXSBZsrZ4qLwfmfC?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4a7755e5-2ed0-42d6-33db-08ddd51de299
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Aug 2025 19:17:28.9882
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wJTDPMir5Jo8SKAPCZpS6tEieUEs+qPxX8wQiBQ1itkg3LL/QDTtrkCQ5TH/Sl2z
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB6136
X-Stat-Signature: obhkcyqxjkz56y776johfnpndh7mbgaj
X-Rspam-User: 
X-Rspamd-Queue-Id: 03FD34000B
X-Rspamd-Server: rspam02
X-HE-Tag: 1754507851-241334
X-HE-Meta: U2FsdGVkX1+7pwipOfXx49HvPSz0akT0/qoGQ7pdt/a0GExcacE6nqcdhQEoZyq41ZwWTeorsuB/1hQucJ5KrhCYlA8I9RtB5ii/CkBuBxDLOwMmyCNvE5bWlFZ3H2LGprCtIqm6U01PTPlJzrbpXqcpertaSSTRDac+iWg+neCpfeP99zI3wGinpz3nfPt9kU32793heoTBpMifxHYoOzFqdXfyBDO7CRQSKsDhup8ZvAwdZZX1rtv4+R2OEEJftCTt6pm1z2vyDLUqmnzK2wg0EKjnoodSTZ3TP8QAmrsf/WIMxDq8skdBCmsID+9mgBH4SgYTTxWUVSGaroU+bFcm0SzIVEn9wgJrIKgfmZopSBPcmvE5n8cOTztxdNf9M8VVBcRdYtba/sj89l2GHk9LDx/8Lkl3SKA5jzYOkIq+WNKD0JABglPLxGxhcbAyOaLTCTMsw70V1tYJzOO5uvZmvmI4Npvun/Zqy1mPOi5xutHskOW6fPvPkIZwAdt1Eno6huBrH3dXrjJnao0Mb/TDLGdfLR9+C/S+16MebxwhBAla8VTlRaWZw881Z4qfFTfLXths76LwJsKC3iISNe0SFmSBPZbolBxd+5xmRMT91PE/2KaPqTbrgi7ftMop8S+BIAAVniuknrC3t0yiISagsGueAYVknGS3OKdnt9MlyAnK7z9OX9aeZCGIfg2TVcylUaAADNWbifWdfIl1nv7mKu6s1um1jK73Yfz07NjZeH7230vD9fHLchJlFYIuMeJqnc+wuYKBod2FS+7/3BFfkhcAxQiyM/I0AuGqGiCk0ejElOOde3Gcx+a1fp+ggURTsFBrffMryqHkGiS/kCyHJplwtX+81F8+crprbLKAIy9ivg8uGpZ5bRKb8gNT4B+H9YvKlT6NVnJ8dlFBA3oZzoA4YBDrPyyooP7nzrc8tBWB9Ma3Gwc2Mk8/JDt+gsdNu0+VhJu0jmOMKMf
 n1tvgSFO
 0GhLFYBulFb69sbfNmC/Xqu0sVwTDl68dZhrFpLNy06bKNnXnVA2xaswRjTEu+kyZ11I59zxbgynak/5q403f6zOr6N0W74tjUfWObgudojvqnGu2pdk/WZJ1ngJ/4J+2s9oWl/4subefxLl+af3tFcpNUH2jwS9OE/3Fc6h1arqj6oaryv3E1QEfnno8YR/IYIjQ75Fy6gpq2BGCS5wOUx7ia2yvOJrO8xeE6r896hX304vBW3PkGUXUEeRLnaYed4hUJ4OHIS4S2E6CByW9cjEC18hZd4FDABq6ebimImQKHZpBEkyFuJIh7dyOcorFje5EVX30U51T24cLPe8jPO0mpd1GOhL0uQNVbZoTXMJcvTd+F+J5Wa7hqMmaSmYgq6nKxXaFpO+XwndBWZF1egq9ANPMzx0xasoAr/CcUWe8JfZfXAF6OcY1MlxdV1rbBKYRCtu1w8dhKJyrsKUvlRnA8YhdLJ86IREzddXtc3MTNlQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 5 Aug 2025, at 13:22, Matthew Wilcox (Oracle) wrote:

> We no longer need to convert from slab to folio to get the nid, we can
> ask memdesc_nid() for the nid directly.
> ---
>  mm/slab.h | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>

Great cleanup. Reviewed-by: Zi Yan <ziy@nvidia.com>

--
Best Regards,
Yan, Zi

