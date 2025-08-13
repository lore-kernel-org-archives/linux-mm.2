Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EF580C87FCF
	for <linux-mm@archiver.kernel.org>; Wed, 13 Aug 2025 14:02:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7EE83900090; Wed, 13 Aug 2025 10:02:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 75233900088; Wed, 13 Aug 2025 10:02:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5A34D900090; Wed, 13 Aug 2025 10:02:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 44793900088
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 10:02:56 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id ECB15117087
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 14:02:55 +0000 (UTC)
X-FDA: 83771900310.16.DF6EFAC
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf12.hostedemail.com (Postfix) with ESMTP id E08A840009
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 14:02:51 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=MAOKK9ry;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=El7hIuJR;
	spf=pass (imf12.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755093772;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2lovIrpTybTKcxpy2BdDPlwZQdV1pso0C0Wti0ombwU=;
	b=030vwJGQYqMtD8HIDGhEYVqwCodPvDIjHYyCKBm8r9OvMgHh50CA9G419zfbIe6YdN8EpA
	Ykqye+GEqsxDO4EZtcibhCcgNASKL5d4SH89qQ4spGbw2xC1X9ftf+VNqhicNj8mqlnwcA
	+ZjNmvYnaH+i1KmooyN2uHMM3yCcY/E=
ARC-Authentication-Results: i=2;
	imf12.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=MAOKK9ry;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=El7hIuJR;
	spf=pass (imf12.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1755093772; a=rsa-sha256;
	cv=pass;
	b=7zsCj7G3pRhTX01HbtsGhagHrT3rqDkayYTHyUbqTdbiGGWlCvAXQ3ctLQIruY/E+e8xys
	1oRdJjvs8vGLX2XYMhJM8b/DNXTZ2McFKCdHXbbOK3e4AvWc7C04oOPtSDKIaPQuHKlOP6
	yH5k7j/IYfrNAuYmJiSVatDJB5kM7NU=
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 57DDNSjG002146;
	Wed, 13 Aug 2025 14:02:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=2lovIrpTybTKcxpy2B
	dDPlwZQdV1pso0C0Wti0ombwU=; b=MAOKK9ryn9D1sb6bBqE2uM5mk41XlfLzeG
	Zk7HSjfWQ9IHXGXvy85U1e6t4TR1Jk3c8VBzGb4nqz/5KnxerdUBsVTny7sAZLg1
	agAC9B8pslt4sT2lCp9zCr8laM6Dcrd17C7IV0UQWQtKYT2YqOJf/9YvYpZtpJec
	eEzcxZuwPIbasdwqsZeM+VBIgjHavwqNYrpPy7svqzR7uFqpy9OgTduxQ2F9HrVS
	TGp5jZlyvThIifV7ao4/0hlHLU6E0QrXqDQK15X1e29oK8gbTlkF6MM/AM5Dz658
	wCM1Ln8tZh6BaLBeL8LGEQSYLq5qYvM7s7qfl5IDB51XFmnu7I4A==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48dx7dqgja-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 13 Aug 2025 14:02:49 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 57DD2M2s030018;
	Wed, 13 Aug 2025 14:02:47 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11on2089.outbound.protection.outlook.com [40.107.236.89])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 48dvsbeuue-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 13 Aug 2025 14:02:47 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=qPYlJbscXdp0NS9Xbc7870auDbvEGWxzSAzO4AWI533EPQEYWvp5WhSTQ/CH20cWNtuEAtypKfuWkVcfguM2ufHImSe4HEdtSJLrpyP1QMGbHPH9GX0osbGP6oGKMdUdWex0cw+kUe+hJbU+oM5lE0YQWD58XBkZAwaNL69Elpw6u3tTaqFGwN0lu2OMqR3QbXzRO1jSoXxzsOwNe3U5ujLgajrMA2igkxfBA8CpTqmgTbJ/Uy9Rp6dnsmHhJNy6M018/7xRge2nhawaEWEjC9ltmTlclv5B1zpc6uQl2FeB9OZehQsnKznrwAKFDAxhDNqdt8Tf+hiFJwy48UBMJQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2lovIrpTybTKcxpy2BdDPlwZQdV1pso0C0Wti0ombwU=;
 b=Uny55d4GDSK6szhjcihOby+gPnCdZPeV7YnZvQ17+JKpaAM/1/OTeHmGRI+7DaKuEbuRi9BMcUqgOdEBM4eH2thfRu+xI8ELdS68epEfuT+FOmve0MMNiy8zxDfoPoZR3Yy8AyilThukwWCS3KKYTcmrG4qj2WpbzxwyyGqZRR2/U0/JaS2LMY6VWajZX6pdSefAboj7fxHvRCphJoJ+8hipHZOEt+uUbVVr90V7zZLZcFEXCN8+WCKugwOttkf9zAmz8Gru/R2MQ0etBfmoVDbAa4Xr8rZNDhtj5RD6jFchIVcO/OPBEGzPRGAqbRqpdqaOlrF1OCWO9dDwG4fNiw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2lovIrpTybTKcxpy2BdDPlwZQdV1pso0C0Wti0ombwU=;
 b=El7hIuJRdXh8hPMu0MtPu+I2YgRUCny1/kFmo9h5gOXIiJss0mskuogkRAACoWy7kPc6pVNtSKoqq8+FqUbW3cvQdfCgVj3DhjsRAF7A3oeL4xlWEuX70Fkdizc0fdlBr7Raf4VuKT93jWz6ArfHawItb0wP6P3r2s48EQLfiFo=
Received: from PH0PR10MB5777.namprd10.prod.outlook.com (2603:10b6:510:128::16)
 by MN2PR10MB4335.namprd10.prod.outlook.com (2603:10b6:208:19a::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9031.16; Wed, 13 Aug
 2025 14:02:44 +0000
Received: from PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::75a8:21cc:f343:f68c]) by PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::75a8:21cc:f343:f68c%5]) with mapi id 15.20.9031.012; Wed, 13 Aug 2025
 14:02:44 +0000
Date: Wed, 13 Aug 2025 10:02:41 -0400
From: "Liam R. Howlett" <Liam.Howlett@oracle.com>
To: Liao Yuanhong <liaoyuanhong@vivo.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        "open list:LIBRARY CODE" <linux-kernel@vger.kernel.org>,
        "open list:MAPLE TREE" <maple-tree@lists.infradead.org>,
        "open list:MAPLE TREE" <linux-mm@kvack.org>
Subject: Re: [PATCH] maple_tree: Remove redundant semicolons
Message-ID: <qlw2pok75g3wx2kic5tn2wtb4xjz67po2m56epcx3mjhev6y4h@m2hmlrt7xtv2>
Mail-Followup-To: "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Liao Yuanhong <liaoyuanhong@vivo.com>, Andrew Morton <akpm@linux-foundation.org>, 
	"open list:LIBRARY CODE" <linux-kernel@vger.kernel.org>, "open list:MAPLE TREE" <maple-tree@lists.infradead.org>, 
	"open list:MAPLE TREE" <linux-mm@kvack.org>
References: <20250813094543.555906-1-liaoyuanhong@vivo.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250813094543.555906-1-liaoyuanhong@vivo.com>
User-Agent: NeoMutt/20250510
X-ClientProxiedBy: YQBPR0101CA0297.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:6d::16) To PH0PR10MB5777.namprd10.prod.outlook.com
 (2603:10b6:510:128::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB5777:EE_|MN2PR10MB4335:EE_
X-MS-Office365-Filtering-Correlation-Id: 8a987f7c-dae7-4af0-f4e1-08ddda721331
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?U99Ni4C+QKnG/HqYJ4fRvP8HyUlBRgfYO5ybMJRbajm41HCGqMfbQyI0o2ms?=
 =?us-ascii?Q?7W6gcuZdKeSSBUqljTQpYGA+so0T0lomv3Itgzp0aPvIuCxxI/YrI0pIlgrn?=
 =?us-ascii?Q?cMURyLR0cdjMeZoKuHyf8J3wjypKwJSHitwTvtQrCzMPgTsqae9tc6r42uuQ?=
 =?us-ascii?Q?By7adxr7g1Wg0MhDvWAwQ5vUI4ezh/4MRsci++7oJGCWkRzV2pnRSPkyTqt4?=
 =?us-ascii?Q?1NW5UhbOckyylGlBg5scNB9eiwfumh9i6ykWY0jUi5asnM99mJ/5gS1kzCjd?=
 =?us-ascii?Q?SWRWFQ4VL6xKQnU3/Nk35BgdBUmleq7ZrqUmDC5mhs1arfxn3ukOZzW8y7fV?=
 =?us-ascii?Q?Lm0fHfTAKEkhlHIRecozYUVGkAL4KSwb7c/b8zvnHNlaQd6EjTktqtdAfPlE?=
 =?us-ascii?Q?Ha2XCNehAlprmeaTozNeJzeYW/f/SJqy0EloGmmtAm1dh2pKyCJTjFBjlbsr?=
 =?us-ascii?Q?x3788WzA8T1g3iftBCuF+lhGYSy8wM6U92t9wbQmQAH4gJZQpj0WQ3FWTe+W?=
 =?us-ascii?Q?6AGt/OP2QpqrgibOqGzl+HXSsJHNtUPQGU84AKk4ncIxSD276wcFBeOwHNvU?=
 =?us-ascii?Q?CpkUEL1mpIFGRND3U7/cxchHCPbPzDSfi4EejZBufvR6IjBkdk/ITUQFJBdk?=
 =?us-ascii?Q?kwLnLw0wMKeMRDq/0tfE7L5drHqCyIfdKTM4qGYTrGhOaVuTR+8TIwSkqd8H?=
 =?us-ascii?Q?hbd/Q69K06QgFAGeDTnZnElbdnAJVAyD+d0KuSORxlmEITwnljl6XGlPqGdd?=
 =?us-ascii?Q?IKlBnhnOHVvyvflE/u4GsPSmCZkqSoIDzRGrMG3/5dZq8/bULgkMPOyGaQ0R?=
 =?us-ascii?Q?GKYSD1bghmDp+oLVKiTP+GP6ok0I0S/CkoL50PZ0MA2kPVMTDaQ3Dc+9L7LW?=
 =?us-ascii?Q?LaGimssRBj7b4Om5lrH3MrTQw8pyLSmmE2AufLmXJcxTzcnoMfGM5Fh5bTTP?=
 =?us-ascii?Q?xSwI35Mibfed4ovEzFiMu+187D4KN8sibW9Iukld06OmttAKJdl5eI089Zma?=
 =?us-ascii?Q?TdxD0XNUv7JDbQScVTOgj0ZScW+F2zyWlmVIj3O1yfIbvh7PRdJNwOBj4RuJ?=
 =?us-ascii?Q?nyVVXCSZZfd35Cyx9vb/zrLObYUikmf3iU5ZrkcWeIUMDgolDigFgTXi/vWr?=
 =?us-ascii?Q?JutWcpZz7wZx4XC5pQzoOGslKsuMi6HznEieprwGQlgvI6xjbDUZuX4ynz8d?=
 =?us-ascii?Q?GzZP6Hz3Ibx+aOEs60mE+dkYV4qlVkxkiLj7NLRBQHzmsy3gUHT02G2WYxnp?=
 =?us-ascii?Q?eNh9d4pr68LWsDTNo4A4Tr+ZJAzZYyiA3ByB8uBTs7CzMNs/i0/4cMtqWKSd?=
 =?us-ascii?Q?keP5GxhSUHdpMMdTdE0jOLX0yWzp1F/dVXQoxHC710PGpMWuuhTq2lUiTReS?=
 =?us-ascii?Q?FgOs9frRx0cAupC01dYUN2p7KkJCu8cETD5ehc92y+rgDgF1c+LShHIIuyjm?=
 =?us-ascii?Q?6BWePl40lYs=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5777.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Az1RZEgqYMZoGr3y8nZeLAmQL1VhtW9h34O3WxPisvW3crvx5WTDoE6BLZDL?=
 =?us-ascii?Q?YJdZkjiEfGH9hvm8B+R5BcPxyEtb0tv0u5ABWLJ7sEPAHNdUJM8BNdYMbHFV?=
 =?us-ascii?Q?itxz/YXG8ezA57RBVIJRE0Ks9q03p5I/AqQlPtmloNdB0ocrFcN7aDyIfiWD?=
 =?us-ascii?Q?4LUOpOpPR8cUvWsp35BgBtx7BzGpY7IgDLoC7boIw24b94UlWUKa6M0rSs+n?=
 =?us-ascii?Q?VWoxZLVHu2VNSx2S/v4zf9TDAUzDi1fhTYxzsnYNopK46BQWvbIWtjZEo8yt?=
 =?us-ascii?Q?hV4HkDrM8x5QUTokK6Mihr/L+fWn4+/8iJGMlBdafMfPoikJSFZtuouSh71K?=
 =?us-ascii?Q?Cj/OQyVpLZ/0kZCgzmxcVhJZv4QtrjKtgtBxMPFjgIAkZALY4CFyaG1NNGJl?=
 =?us-ascii?Q?lQKS8yd8w3FkJ3RXcxKrzPT0dehXYiB3yy5QN0MD3ZJmiwsIozZ8AGP3SF/i?=
 =?us-ascii?Q?JRd8IGqMzXj+aLRf1MEAlMTizC7QmUl9SO46Sz0MKfceSEimmP6XQXyENBZQ?=
 =?us-ascii?Q?HsVqHpZoOBZFd+b/+//VqXfMdoNEFkV/KPK10Cwd7scGk0VoQainNZen2PnA?=
 =?us-ascii?Q?IoRCY5a2E5jHHQywd2NYpNUr7SwGPq7Dir+PBrYgo4pU8Mj/6wzLGc1i/AtQ?=
 =?us-ascii?Q?OWjn7IABCXbjGtCvaMOFg0/F9K+lxO1jiB+6F8MDkV3/ZWBO1Vjj/bNDFVdu?=
 =?us-ascii?Q?Gicsda9pD1IyMnJsPmHMr7P6aVDiFcEsgXZuJFh9mHJtYQ2HApGgbMH1nv6J?=
 =?us-ascii?Q?W42zJEvUW/LjTcNJakiOx2yFx0srPr/CVULjHxpbgI75NIPixXShYoCvscbN?=
 =?us-ascii?Q?6K7ytA/B6QA2BvAPxfV1iBAOPJRp7TMSgpmoxJiSazXRBI9684AKY/HngO2D?=
 =?us-ascii?Q?iTKsKfwmMaLBQYYJ1iIn7RkClWqpoZenTWu8FoOy7KhINWJtlWc7NeyHd8NY?=
 =?us-ascii?Q?WHPdNSURphlayuIDIA7iBQW+UHAEtiqOwfwAaweZYquQ/ppcV8RaMUHL7zis?=
 =?us-ascii?Q?KMc7U8EnXVMEKPbHIQPTDoZGcYq93f5sxMNzJf7XFyHu+oZyU7Z85WMMu24/?=
 =?us-ascii?Q?C/yyCTuFRdX/60R3DigSIXuKh0K4c6SUnJvqxnvVSvQ8N+TLopOXzvec/pbE?=
 =?us-ascii?Q?+JX4fc2x/2W6oHI4O6MtZH/NQTFWGXUGcfG6pqcoKOqy6QDRNzkdQVbFXAZL?=
 =?us-ascii?Q?aqKT5osabf18yopgGTAAjUEdenx0NTLmx1by02ZvQKBfdIS9EUEFehXdF05a?=
 =?us-ascii?Q?/lsRXwHx+nqMxmuLa9RR8FUT9hfPatyu8DWZbjMm166mX6ue8UqH08v6UeR7?=
 =?us-ascii?Q?021u4T+uI9GvKI5zb6hfh457XtHQJraEjwE67t8ml5q1LT1eKwyGGhWe4YIP?=
 =?us-ascii?Q?rcsHGvqF7P4q5tBkXd+tF5wEEFfX54g4MgPmdRRMw3fNjlpBh7HFunxc14fN?=
 =?us-ascii?Q?aqraQMRPen3eRkzanTXDiWImWcKxgVEOEJl83+vPHkPvuhsdYAZySRYfV429?=
 =?us-ascii?Q?PST7HqbmT7pXX9KuW7iCK2FEsTfjpXGcvaBvvH3tqKtSTZ/NS2GNydRIShv+?=
 =?us-ascii?Q?QQVq9C95zTOgnHwC4ErCVvEMkBTvEXr5iByvsfJp89U0RrR5Hv4I81qcTIMp?=
 =?us-ascii?Q?Bg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	64NRZlfOtOCaaz+DTvjm1csdqiwUf+e2uWqJwPqE1xnzY5ONmoe6OvhSmbs2n+jGass6WzBtEQe+CcGXNsLP8rOksEGClCeSGtEL6iSVHYiBrGDC8goImv4RO7z/lAjFK6Q6bGxMumwmuQg4lJc6oGqCBE7tfY1l36p4Vl3uRihxNPIhckjvy2C1Ry7h5EYhe/9M1P45+JIITPq/TDKXswC14so2CZyM13zCUEckqU4RJi3Nev9q4k1X9ns+sn9n8mQBF2C+zFbK967LwEeRAzhxyyEwyZa35yqMopQ/QaYcEzZrzxbDG0AH9V9MKvl/atzcpS24W+LAa6yyv+JVudM9JV9cOjOEXS1yboJINV2oY0cZC2B3EjZ6jbXwFMpUFYjzsUbiIXdp9YH9bE5hsfvimXrSzWJVwwUxRSlE960tmfjJFp7RsbIp3UpgbwZn4vmUVAnXt8j4w4q5U3ajAzlOOPVVMvHyOwnZi3WoDEVhjFi029mM2K92hbqnulNzJECphqvxgVOmnHRdIjqeV2GMsr5c4m78hPywIdqVabe/QQjAQfJqa34+fVdgIN1K8D4vzmPUw9uN1ItDMfpE083no/wPNS1sw49NOr0dd7s=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8a987f7c-dae7-4af0-f4e1-08ddda721331
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5777.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Aug 2025 14:02:44.1743
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: UjVeSVgfDDcvmw5/1xgBilO8TLhvr3kIj5coIMyxWew0TwGnMOS25jJj3+JsL0mBzNcWQRnMfDHG5v6Gqtkeew==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR10MB4335
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-13_01,2025-08-11_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 adultscore=0
 malwarescore=0 spamscore=0 bulkscore=0 mlxlogscore=999 mlxscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2507300000 definitions=main-2508130132
X-Proofpoint-ORIG-GUID: 8tvRl_ttEKusiBa-7dd_80p6khSb4ad9
X-Authority-Analysis: v=2.4 cv=WecMa1hX c=1 sm=1 tr=0 ts=689c9b09 cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=2OwXVqhp2XgA:10 a=GoEa3M9JfhUA:10 a=1WtWmnkvAAAA:8 a=yPCof4ZbAAAA:8
 a=iZfw_hwLpUH7yu-2NFAA:9 a=CjuIK1q_8ugA:10
X-Proofpoint-GUID: 8tvRl_ttEKusiBa-7dd_80p6khSb4ad9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODEzMDEzMiBTYWx0ZWRfX96scBxbQcnA1
 EFIgHOEC+7W29UdUIkEMIKKZw3QLzSrfsRlf6pTV42uxeZhLrbSJR/lvllb825m0xA3b341QL+N
 lNM794y3AUsuG+MfD3YnOS+Q9tEF+wacdQj0Lafe5i4gb5KoG+Scj0pwEN+jWifU43aBDuyiJnt
 x9fDFcG480WRBEEaP3hL2Yq4urypmZpKJR9y7XYrqVOVmg8hJkr9Oz8G/ncd/wMk9CQL1g1+Ewn
 Q51yLFgc7K1cPgG1nlTkdZSOMYow6CxG7m4QGXnI7q+YUrXoyL67vy67kv1e7Am2VaBcnklpG9R
 HIsCTStmj4oYq/YwppSSRy27ySMrPBpQduECtkLwt+fYD7cIRYdxQlVwTCnT+sJT/d4CcdZd1/u
 Mt52UWCX13SFYJx4mF+HSSV4IT0PGeQpajCc4XB+yvPDqECQij8UB9/DZ2K/M4WiTTk7pCmH
X-Rspamd-Queue-Id: E08A840009
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: 4bo1fjxw41pkttmzkiytotpi78aq3otq
X-HE-Tag: 1755093771-196670
X-HE-Meta: U2FsdGVkX18O30598yH5iOGjl2P7Z0YdbbVyewFnWHKP0kgNkNKXoHv0pBRP+bMOIyMMlWcpTrJisqeHY2f0n2fPxjeyWfBHmd8TqGcWJ5MY7qEAHfguaD/723oU610t0R2nUMtrATg/e57Grz8tG5NmR1t0pSpJvdf0Bphp+ngOnwIXeTCFfPAIyGF8+za3aXq0sqwxTzPXjjYs/UtEENukbEyz+i2knA9hDu1uacKSSQBGOt92QxogKyMFE61TQrM8GkpeD+yBss3+Z+w+A9P9V18UXQFvWcRuDm7Be9wh42SKsY1Mgn/phQBD/XXoH+8I6Ov7R9unqcBi1zxt36wZVpjIODAn03HTTNU9WcupPR7iDh3szLleRlS9woat+MRnScDbj1/cgi7K02ZdgBOIhhOy5tApxhv4gd/t35UHDa2h8Y/dKSHLr3OJaJdYZm1kzYOFVWZeN/sh/JtUcn6pGxJE3TC3TpN0Y4W0XqD9lirfNEdN3aEJ6B5DT5mrGhRtuzFQRZjyhGnbGIxoJkuLLGpTHTZCzYslQ26BoUaLqnOy4i5a+1B01nW2PaCWojy10T51Q3D2NqdZNKTw8Fzl++scgMQufa4zPkF7I/MfIpxiqJikFc7zd9JhV9HiFMIdr0u0m0zlY8tMCLJMgk5ZyubMAdAwVJvmcUE9wsPYSKx6pKLhoy2KgolKeJXiWAfCxZT/kG0M8OEd0jIUx7qUOI8obzUPBfX1EoNyujYNGMHHjKT6XDCGEY9ZdyLYWnTqyd1quCDXOeSa2T9uHEcyTEAcb1rg+DLk7nI3LI5fOzJsyk6WhRSmfaQIbUMVnnsYjIXjK0pJBHRjHqnJXL246jhYQoFrPzmEb9kLZxlSw9Sl/srL+b9xng7AstNqjnZq5yvr5XFM6YMJv7/fkPj2wAD+TRGA3+ahGrA9tY4UzP37PkoUhz7cEydtdADXHiflw/2dLX/nRyzd9CZ
 gU9YZXFA
 n/LmwxE7iEY5UiEL/WfDGm0nhyWU43t9gonhB2xkxB9sxqhvm8bk/1rtz268Wqc7pvec4/yahXosS1yfuuPbLKLrP8a34sNyqvK9Vm85sw9xGEaN0WaUBhGpcikKIab0vF6yUyhRm06FeXjtHuJtURfr2vFtQk+sjq37amBEX0+YJ3bseFbPuYnumCEpzn81jsIv/IQheRKQ8/qsZjhyrNJhlLA9bPuKlu0agRYZoJ2seIKf0WA9ss0Pr6fT4lTx/vN/2/N+WgH8RrMjF1cewM+aiAC4F1wCMr5wF0WdEa7Z/Ua4SPr1IYsA8YriNcOL3EFnwHquDL2S2TkvkssqLq3FpSdk3gedYYpoLReVl/MfVE+SzRj2165t+D82/Cc7p6y4iuWUDbVf+JBOxat8ORPmapic4h6CqYjVFbJXIJZ6PDoAkCnMm6iXliS0/s4HoVaGt9n/UpqPgvk+gUQ2X+15jW3Skx9AYxFP+zNaMVyH+8j29XQXKX8waVYqNI/9XgY4ciRZU1j4j/7yTQYF/cwv/de+PG3ijPTvfpHXFdwg8/gNEehhsyOfGN/UmQjRQNGta5Afw7V24NwwwdkBxUzN59P5RACNJYPbou8GHH2DwGSUkM6ewHokb6ppfG4tL3LV3tQTU7yzCl6fgMmNC3XPsbZvOd2ryJ6h1WhLgBOLfB2Rem2nf2P5yL7hPHqStWUalgVehxI4Ndpftjw4MuXI+UflaP/Ru4dBHa8huLK0Lz570lTJiD/BFazsqT+dgFTZtbL7Fj9eXSLE=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

* Liao Yuanhong <liaoyuanhong@vivo.com> [250813 05:46]:
> Remove unnecessary semicolons.

Thanks!

One nit, it would have been good to state that this is a test code
change in the subject.  Usually I use "test_maple_tree:" or something
like "maple_tree: Remove redundant semicolon from test code".

Please mention test in the subject next time.

> 
> Signed-off-by: Liao Yuanhong <liaoyuanhong@vivo.com>

Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>

> ---
>  lib/test_maple_tree.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/lib/test_maple_tree.c b/lib/test_maple_tree.c
> index cb3936595b0d..1433ecc854cb 100644
> --- a/lib/test_maple_tree.c
> +++ b/lib/test_maple_tree.c
> @@ -3562,7 +3562,7 @@ static noinline void __init check_state_handling(struct maple_tree *mt)
>  	MT_BUG_ON(mt, mas.last != 0x1500);
>  	MT_BUG_ON(mt, !mas_is_active(&mas));
>  
> -	/* find: start ->active on value */;
> +	/* find: start ->active on value */
>  	mas_set(&mas, 1200);
>  	entry = mas_find(&mas, ULONG_MAX);
>  	MT_BUG_ON(mt, entry != ptr);
> -- 
> 2.34.1
> 

