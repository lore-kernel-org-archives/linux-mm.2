Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6417FE81A48
	for <linux-mm@archiver.kernel.org>; Mon, 16 Feb 2026 16:59:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B05696B0088; Mon, 16 Feb 2026 11:59:00 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AB2AC6B0089; Mon, 16 Feb 2026 11:59:00 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 95DAA6B008A; Mon, 16 Feb 2026 11:59:00 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 83E246B0088
	for <linux-mm@kvack.org>; Mon, 16 Feb 2026 11:59:00 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 162AABD64C
	for <linux-mm@kvack.org>; Mon, 16 Feb 2026 16:59:00 +0000 (UTC)
X-FDA: 84450929640.06.F24991B
Received: from SN4PR2101CU001.outbound.protection.outlook.com (mail-southcentralusazon11012039.outbound.protection.outlook.com [40.93.195.39])
	by imf04.hostedemail.com (Postfix) with ESMTP id 2D63D4000A
	for <linux-mm@kvack.org>; Mon, 16 Feb 2026 16:58:56 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=lN8YDX8E;
	spf=pass (imf04.hostedemail.com: domain of ziy@nvidia.com designates 40.93.195.39 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771261137;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DA3wk/6nUQUGH2VPQIJ+PXugiZ0vwZ57koJvEo5Up8A=;
	b=elALpmcnCQrblWVaOhFU65TSMMXTvGcRZcke/Bs6ZFdT+8k3V4jjxfS8sLCY2SN+voW2h2
	wAw7mUYdW867ioXpcxDHnYUaEy1KlSK5aW1KB86hMLOr2OGIZy1pXKOxSHPWMEg6zFnkWf
	xGkrpnrzydgft/4oRhnZVyiAqFnsFTI=
ARC-Authentication-Results: i=2;
	imf04.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=lN8YDX8E;
	spf=pass (imf04.hostedemail.com: domain of ziy@nvidia.com designates 40.93.195.39 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1771261137; a=rsa-sha256;
	cv=pass;
	b=DtuCLJztPOYMRw6Pu4ye+zwSswKHEX22d4ZlKlmO6nNk9+TbXAUtH/IIUFZZqKGxYW7RDF
	BP17eu/17NYypUVL9sLNomFNWHp8RmLQDEgrope1QwUICEOKyZ+Rua7+h0h7duOyOf/ZP8
	HtOoiAwXn1fC0rvMfknRX0hM98pj9FA=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=IKQdjp3/OdimdwjRNiJUT+WjNYBMSlc2Tm7C1zCuTKH5+KnMpCq+slGnYunaYcfj1smSbMnjZ5AdY/tyW1uUTmi0Y3P5zlRZy4pg0od6h+c7iYYKX1VSkqDw2u98EUstUezBQxWcJOGKbAiA1YLvBVCnUWxVpdzJcjB5Y0qwfzZ1ZB4JiAjGSyzus9MG1XvX1TYlKC/49NeSwUW3/cN3ihStHwCQLOMBFr7D2kSknvASDffnXwk0ug19HdzCl1tKfoQSiNbt0fJ6qmfrFoeDxXv1pKpMWNC8hg6wPF2zm+cis3BSMeXG6fRcDeyTmAdb5hWzyEVh4W5wlca1vyGpSg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DA3wk/6nUQUGH2VPQIJ+PXugiZ0vwZ57koJvEo5Up8A=;
 b=Rq7kKdzl5PivJs6CjIKxopeEvQKbm39OG1UNobT09lQp0MYDWEbeBJi/RCultgTn+WeDPWiGhrZ31f4U837TwsLW80PvhS2U2a+MOM4uqsqzkAJDu1YqSv3vV6rH3y9eMh4hquWGgWSdJFF58NVIIKmgYw/m8Rm3m2bHC/WTAlKOll5qYE3IiLoe0Z1wBl5lgFPFiJgK8nza28+/b/BQZ+MFn9qD54smX7DUZVudqZHgQ1Wrz6NSdX6xZeypW0KLMH8sicRUqHOYNjUj/GLINnEJuZiFQDMyRrKdZKGwToOMdE5pItMRb1oJARxtTK3/NmfrtZXySpbOb2kfSfku8Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DA3wk/6nUQUGH2VPQIJ+PXugiZ0vwZ57koJvEo5Up8A=;
 b=lN8YDX8EIW38BPaoYQBiyfWVvDlfN68MQ00vEanX3adHXN8EzSyxnb8FESZ/5WNYSLN7g4bG+sEaflDnlXPfT+QQW061BE/74HGr80lfmqNaLCGVw5g8TnXc6+QM+cNVypY6L35GPsOw/2FZuVUdjjBNCzmZgsIeMmaxtPAV4A8tKXADOam7nzRXo5Q13GX1+p8S6sFXdHsTQyJejBaIGspRzcA1yscIdT64N1eIGeuaqbC/kEp6pDEPsMHEnlMUE5cji2C0m+eAtNimhhgdR3EPr1E28ee/CtPXIvTKLtu+KqPpZp0y2jk/0jHjQOHgngeexF6a7ga4Lys6IuZxYQ==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 CH3PR12MB8880.namprd12.prod.outlook.com (2603:10b6:610:17b::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9611.16; Mon, 16 Feb
 2026 16:58:49 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2%4]) with mapi id 15.20.9611.013; Mon, 16 Feb 2026
 16:58:49 +0000
From: Zi Yan <ziy@nvidia.com>
To: Arnd Bergmann <arnd@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Vlastimil Babka <vbabka@suse.cz>,
 Arnd Bergmann <arnd@arndb.de>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Brendan Jackman <jackmanb@google.com>, Johannes Weiner <hannes@cmpxchg.org>,
 Alexei Starovoitov <ast@kernel.org>, Shakeel Butt <shakeel.butt@linux.dev>,
 Kefeng Wang <wangkefeng.wang@huawei.com>,
 Joshua Hahn <joshua.hahnjy@gmail.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: change vma_alloc_folio_noprof() macro to inline
 function
Date: Mon, 16 Feb 2026 11:58:47 -0500
X-Mailer: MailMate (2.0r6290)
Message-ID: <15272AAE-6C14-4A80-AF70-4A46D1047B61@nvidia.com>
In-Reply-To: <20260216121751.2378374-1-arnd@kernel.org>
References: <20260216121751.2378374-1-arnd@kernel.org>
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: BL1PR13CA0317.namprd13.prod.outlook.com
 (2603:10b6:208:2c1::22) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|CH3PR12MB8880:EE_
X-MS-Office365-Filtering-Correlation-Id: f3ae44f1-d130-4a74-8a07-08de6d7ca7d0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?YLbP6DuK+O922p/NnuQYlezKoKaBssTenmPBZ97rgTyu0DB0STU8ewBeyhJB?=
 =?us-ascii?Q?5xDxGlf70HYaLKtA/h6C2/cHcZ1sAhBJah7qjMPR4tJabGsHPmtlcxZtCSib?=
 =?us-ascii?Q?kAGSJ9U/YOo5rZpwyl3cjZGJbV9c4RXv1ZKS8y1WgMDBBGu5M/ZAc73jYVEw?=
 =?us-ascii?Q?m84RX6xems3f22hsZFskXOn6hSpUVmEoLuSHwKhQh18bHaprGTqjVekaKM06?=
 =?us-ascii?Q?6tgqusdp3oNuqZfVVssQZ/NzV28nU1c3JEdfk1eFoAwsZ0YaGHedwhIwFypl?=
 =?us-ascii?Q?2CxhDLUO0CU6i+OuO0/u9pwlKTl4tjePEAxn9aKZnAM1ICdyuqs9AI0shgM9?=
 =?us-ascii?Q?utFGMox1oY5Ptyi2TqN2Tofag/lYbv4Ry5jfBuEOBBBMCMD/k+zBATMgNLbs?=
 =?us-ascii?Q?EbqhbhgZi6EKDZ6op7imqzHwW80Rs4MgEzj2xQSjBcHaaszma6IHyk0A9GBu?=
 =?us-ascii?Q?mYlWGn/Zw6Otao0PAzDl8yWF7oc3okF1h/lPkTnb1sPApoexYbchYU/g2kMW?=
 =?us-ascii?Q?+Cu76W6wypIBiOXqwaTosNii0G1oyPFrSiDCPSn95Sa1QAPSlxerwO0eH0Rs?=
 =?us-ascii?Q?1gQ+1/byMhUH91qx/XEvj3IGYCU2SoaCz8hOMqlWUnPjpM74eNheZ9fMfEPG?=
 =?us-ascii?Q?7cOvLkQY5ydqkTVIDLKM08zZ0HSNib6MMhU0stUr+9/vWZi+rKD26giMm7RD?=
 =?us-ascii?Q?y/0xKyasET4mPUDIRdw4IrdiOx6VI11+igcw8VhgYKsdUA5uSFEHlNQSzNGB?=
 =?us-ascii?Q?L1toQR3XdAbcThgyF5V7+KJOWi3vwfxMkSbIsNfk9zJmQlG2NLRPAha+UHdb?=
 =?us-ascii?Q?U1gpdp7guPGjIan4XtpDFH8FeSrAY8UlpGRLIL1YLnJglqIB7xn+bhidT3cN?=
 =?us-ascii?Q?EAAeAqrAvGIhTl6u8dmnuN+7Xg5bptT4eqvSjKLmtZXibbi8N3adHIVev+lZ?=
 =?us-ascii?Q?Z3+r9jhu+YzO2NXB7WacWSN9vaOMNWKLKbEaE2Vgx7IuV3ZvTrDcIHrO6CZZ?=
 =?us-ascii?Q?ChG8e8Ed7+LfOi7Nsg/l1B4Q6oZIF542Up28FQP20gYg1ts52HCGL5ctEqde?=
 =?us-ascii?Q?3aN0aZsPa+Fj1xhJ7JHcSOjKsnYkKiniKn9UjDbtaM++OJSw11yImsW1v3iZ?=
 =?us-ascii?Q?Te8qJpb6GbOLV5FslsMjO3ZUQFVhqidzmKUjDugDJCiwkKkQNzo+cyeML+pO?=
 =?us-ascii?Q?CeTuyG6Ydf4aBH/rslUtYWsA0AXN05zUD97YFYhx2yykqkltTOa4btsGX4j/?=
 =?us-ascii?Q?B12sFwg7e1HJJIJ+e6qCoL6rVNGtdn3NV1UDCbgn1zefJDKgG8PZyHjJzlEZ?=
 =?us-ascii?Q?g1md6qd9IvIXoipYvo7Tfgixh6mgL/iltBOWUyUT4XwCaDI8nUdle4uYOLV+?=
 =?us-ascii?Q?Y2W0vI+t3LeZefDSWJbGdqMa2vfZkd+3Kn/UiOXUTBzOsjnewZ6k8zbNrdwf?=
 =?us-ascii?Q?HZPsMfx8ErGoCjgjiaBGK2m8YWkzFDujx1CvJC47XgGEocb1NqF30HVbwsaO?=
 =?us-ascii?Q?ppNIyNLMTV4UrLlfmufGvIouov6mT7dZTfR6oF4+OMj1jpDBT2emkvwhZPsb?=
 =?us-ascii?Q?5ITgYPGu0Y7NNFt68XM=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?5QkwAMxnbRt8u69AUwGKIslDv6kRwlVi8FDlBlB8vONBhJbIQAocmPcEJ0h+?=
 =?us-ascii?Q?I7QdvloEfGVrW1GCkjF36pu3dI5nElcjTu1yKtq02ahCLGAwrnPMtMcY31li?=
 =?us-ascii?Q?kNtpeER0YsZ3xyO7HIBo47WlgGpN+Xs6oWFqZac4Qu5owwrxd3+/zeC0NvUm?=
 =?us-ascii?Q?hMzdMTFmK8aW3ieiluPV6cbJnyw8bzYuhWicy6cih2D5X8uR/i2cs78xiCvC?=
 =?us-ascii?Q?TVLUHtVrGJv4TMMKNOoo8neGumf1IueO0IyXemMkndJQk7Gah4h5bHd954TM?=
 =?us-ascii?Q?oZkrB1DFRsTjUAWKerIuCutY1awirXDS5mpYwgIhYmcnFT0eQZVqWjG1cmRc?=
 =?us-ascii?Q?nSPubVOqDyCC57TWacjcHNCQSLVDmTD+2OpqqH8/M1ugj7COUh/oi3PN7G1i?=
 =?us-ascii?Q?Stz8/FdInKkWLmUL/9vnww95zd95N1GlFUvoMmM/QRvLf6DOPnUbcc1K6eFH?=
 =?us-ascii?Q?D4XTTjzhaadwIi9hmTXzBeWBy1xm4B4AMI3j/tRj7ZGNOqzliCxWTxsIrW+l?=
 =?us-ascii?Q?RGaS68PUT3BkbFKyqmNytn3p8ISFem8B2M2qe+gcCD9p8AErTMYwmsOtCPdI?=
 =?us-ascii?Q?OrZsn4taGiA1k6riuZXEGKAAKDpuKXh6Tjej9CNDOWW9xCir53QaOflH4cPV?=
 =?us-ascii?Q?gsfgTq4mUoQeIKka0dcbPtnLHisvte70dEXjqB+GgFgI3IHR1pEE+JWSpWud?=
 =?us-ascii?Q?9oKj0LLBDcsZOM6xXJ2E/xj03m2oUMoI4r5dFSHe6Eqqdh+EeEnHBS3l36sI?=
 =?us-ascii?Q?eVGwehSvUwYfqaArhY0smkhZftDs8m3ueAWtV7bvO/+YJ/RZmTRWsVsGjt7B?=
 =?us-ascii?Q?qPPtYwy5tgyGaIEClQTni3fz2sX777/gKqkeB3mQjIXn6OfZ0xzwj9friFpp?=
 =?us-ascii?Q?0bLwdhXTzGiouMUxl5gVqRLFFdm0VRIuFArXeHYHrilen9iZAk4INOv9eX9m?=
 =?us-ascii?Q?LvsKmdtHYDO3ndC3YvZIQc0FcB42o4tZ0SS/Gh4h/PvdJhbPBZNGCBz1jsnN?=
 =?us-ascii?Q?LHcWFmE6suAn32WxxjRx0GBa5clLUyyIRj6BK3pUW6SFr6PfmKk+nw1jLMxg?=
 =?us-ascii?Q?xNeRLTt6vsjJJpktltVmZH+hZlSiWB2DFPyPOzuFWnQeHx2LrIVnBIPtSz6O?=
 =?us-ascii?Q?iaFC5wrWlr14Xz7Eu3OJ022HypC03blkqMGL9KLQkZHpTlDrNOvMBfZNeKrP?=
 =?us-ascii?Q?YmNEcHQTP54JAY0pNe6y9BtvCocSWZD0QaiYuxStgKITOn0ytizLOkwUXQo8?=
 =?us-ascii?Q?48kqcPJT/e6oN1KlnGdCNxYO/tPevEJ7DOZrm7irME6NNT8wjEdxsFLAidIM?=
 =?us-ascii?Q?z5i/wGsDlcZvD2Qr/bXWul928GQBbAxnx9Uzs3SlSGJuGWVusJzMuOG6jGFp?=
 =?us-ascii?Q?T1Hyyf19nZ2dyDAM7wJjUjT7sP+K6gCdVNdDhG4HUWMNE5IqzStmOrIuEZ6a?=
 =?us-ascii?Q?45fMS84eMwng1fpMPv2zEwxSClFC1a7MEavFSh1gKOPqtX54JSUKraPBV42C?=
 =?us-ascii?Q?gXmHiQGy1PyGjB/Sb2WnR511n/HEzg/xNmHzuwVt5G+bPmLHq7r8zL+jpTtE?=
 =?us-ascii?Q?r3XZDQE0WE6RTlxlQKPzf415ATgpCuKH1kEuOv3Io+RdqzJsyiCliwKCDc+H?=
 =?us-ascii?Q?AByvPw0+ZdrfAMyyWgxqGvq7hx3AFW5nTjjA1p8Nn59y83Lsgt8ilz34eiUE?=
 =?us-ascii?Q?oZkkqvvzkF4HAWKb0Ofi050QfCyqTAlzIxl9/K4D8fWjUGeM?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f3ae44f1-d130-4a74-8a07-08de6d7ca7d0
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Feb 2026 16:58:49.4121
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: V8c1l+tfSP1fjUYGDq4+5Zi76FnSha9nBRpd98HyY7mbOZzJICxWqgDqHz11irFi
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB8880
X-Stat-Signature: uh4iri8u7whb7bh1d3rf5q16n5ouys56
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 2D63D4000A
X-HE-Tag: 1771261136-972171
X-HE-Meta: U2FsdGVkX18QPAxQ5keYQNsdtFgXtXPCt07nsHcrvB+Cfl0dYSe73ImmmOermVkm1jbjMxR8+ZCQNVctdZFr/FXJ43HDmJTIa0tHgSH/jZYlr0XaFLQzqJopocKIH6tGjmIdzS9oObxVMyXeHiFhq/dsmaeRc3ScZX4oOS0UAw4Drt1pLn07RQ6LBkBcVi8a7oGFLmOzDfBUAUkKpKJNUNVJUMMBKC3/O7aBNiIMhOOsry8rsN+6vR0W+RtbOBG6hdPVy9gT9+XbTB11Rh1/I4ihwENBDwIofhQergU8tl+owZlq88q3dF9zOFi9+YBW5rQquS1Y79FIDHvrQhniunuRNZJPMWXG/mQK99viASXy9GG8tu1jXtkwT2deeR4xaXIl8jHgF7O9rABI9jXQeCpzJN3WrbKHP7WRrJHr9j3od84peIoQQo2ZgOWtaWZ3/h5sJnySNZIpCiHy0TLgSvqfKU6I7q5FA5ANHism/PEyo4pyEHP315avnKYYc01H842ONzQsXAUTxkkSoOMZ12TYAa5cg2QZg7BYy5Ui44SwwSLwbNcQohGUBJeQ+kakq5kDZcZhVNXaRMvtVY62VoOLFtAKof93+vGkzAby+0no8fikKhrLdpdzQUAIN6uTdJZxt2FXwfTL+P+RqmKMyZWyxvF/asnMCQ+mYjD7BfqkF98mA22d6C2XCKlhYg+lV9pqLtK/Nb26/aGhi6mR/uHU7DN3ElJej9gHjug1T5/5JdXtGAzJB0b1RIZlL9ZLnk4FMecUu2f3N5iMyZDrIE/FG1Ru8FoJIfFGyNo5K5PoK1jrZeUatFwmVWNfs4sec+1rpZr+FVJx4Z3asmDNlCm5wUbBNUy9kANDqd28D7BZk/XgAsnr7tNOjTqOjWp7YMj1NxEb0PJ7+nQ/hCMBfX1LZPatu3E5aaLN/CB5AGR4xSMbEhMlz2Op2cRejnHCm/CtcG1CC5ZngVTWfOW
 6BatPaoU
 edcHI+bEjD7LPwO7ZEFR3rpJVNbvOmZ5zallKSw64nZkmN34QiVMWkDIweWjHdFBnFHvqOhpM0jrBIyy4KQJcQc23fHvUGcKuKpFte3LzsvHDviQ6xnrnfD9e1M8+Tr8iDWBJ0S5azpKSJ0TFOmrm9cPeVB37oYUgOMErhtc9Av1RoC7B4ZR+umu0W2cKmyxAsRyGJgnEAMEZ33qfBFul+JLJSCwUG6bzlt+bRAEG4sfqR1Jc1S931j/b8TpBOUgM9aiXYveVs3hVJRrWXWtaO4NNEATrwRB4CBJvsm9AwUsXxQ8BiVWmkYWDcoKOGKFhY375Pn9ORPt8l54z+E57jAZEq9y511eQjyVP05ba0DVNxf5sQi0+l4TeuBof76IG1zHCNo2BAXvuRCHJUgSIipC37+v7GN7fxGYn9ahrrloEkJGBAu7Yxm5HfUic4ISJ5ZxIQGqq0Duu6PGLQIp7zECfjiVYWMC8wgeGY0aKCksMGsnIpBDA37GfGScKyUIWKzb/Sn9/xU6ivQ+StUHRK3DCFg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 16 Feb 2026, at 7:17, Arnd Bergmann wrote:

> From: Arnd Bergmann <arnd@arndb.de>
>
> In a few rare configurations with extra warnings eanbled, the new

s/eanbled/enabled

> drm_pagemap_migrate_populate_ram_pfn() calls vma_alloc_folio_noprof()
> but that does not use all the arguments, leading to a harmless warning:=

>
> drivers/gpu/drm/drm_pagemap.c: In function 'drm_pagemap_migrate_populat=
e_ram_pfn':
> drivers/gpu/drm/drm_pagemap.c:701:63: error: parameter 'addr' set but n=
ot used [-Werror=3Dunused-but-set-parameter=3D]
>   701 |                                                 unsigned long a=
ddr)
>       |                                                 ~~~~~~~~~~~~~~^=
~~~
>

But addr is used at line 739 or line 741:
https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git/tree/=
drivers/gpu/drm/drm_pagemap.c#n739

I wonder why compiler reported the error.

> Replace the macro with an inline function so the compiler can see
> how the argument would be used, but is still able to optimize out
> the assignments.
>
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
>  include/linux/gfp.h | 7 +++++--
>  1 file changed, 5 insertions(+), 2 deletions(-)
>
> diff --git a/include/linux/gfp.h b/include/linux/gfp.h
> index 6ecf6dda93e0..23240208a91f 100644
> --- a/include/linux/gfp.h
> +++ b/include/linux/gfp.h
> @@ -335,8 +335,11 @@ static inline struct folio *folio_alloc_mpol_nopro=
f(gfp_t gfp, unsigned int orde
>  {
>  	return folio_alloc_noprof(gfp, order);
>  }
> -#define vma_alloc_folio_noprof(gfp, order, vma, addr)		\
> -	folio_alloc_noprof(gfp, order)
> +static inline struct folio *vma_alloc_folio_noprof(gfp_t gfp, int orde=
r,
> +		struct vm_area_struct *vma, unsigned long addr)
> +{
> +	return folio_alloc_noprof(gfp, order);
> +}
>  #endif
>
>  #define alloc_pages(...)			alloc_hooks(alloc_pages_noprof(__VA_ARGS__)=
)
> -- =

> 2.39.5

The changes look good to me.

Acked-by: Zi Yan <ziy@nvidia.com>

--
Best Regards,
Yan, Zi

