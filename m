Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 045B4CAC5A7
	for <linux-mm@archiver.kernel.org>; Tue, 23 Sep 2025 01:46:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EC7D78E0008; Mon, 22 Sep 2025 21:46:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E78578E0001; Mon, 22 Sep 2025 21:46:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D18BF8E0008; Mon, 22 Sep 2025 21:46:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id BB08B8E0001
	for <linux-mm@kvack.org>; Mon, 22 Sep 2025 21:46:29 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 57CA31602CA
	for <linux-mm@kvack.org>; Tue, 23 Sep 2025 01:46:29 +0000 (UTC)
X-FDA: 83918825298.25.0EB2607
Received: from CO1PR03CU002.outbound.protection.outlook.com (mail-westus2azon11010068.outbound.protection.outlook.com [52.101.46.68])
	by imf22.hostedemail.com (Postfix) with ESMTP id 70EFEC000B
	for <linux-mm@kvack.org>; Tue, 23 Sep 2025 01:46:26 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=m3KZsopo;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf22.hostedemail.com: domain of ziy@nvidia.com designates 52.101.46.68 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758591986;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wcmhFjgk5Tcs9M6Q/MDY7vkNgbH+gIaGUSQvhFIFf7Q=;
	b=5p8oVSsLmEZoDZPok/b5fgZyeUxSbVNmCWyN61tKtItNmbIB3NpFjqfrQMwsLklHgbJ1fa
	lwgQj/tQdzyUyy+mAlyoorK/A33KK9+lNRqkLLgVAMTqOxVSdCbVGrJmXyHF2fBEDOhsdF
	kt0GPwVu7eeMPP9hRjA1+qcOnmcF7qQ=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1758591986; a=rsa-sha256;
	cv=pass;
	b=19KY/xjaHdi3QiQi4E6lMPR2GB+d7M/pG+Vmr7Ki8EhvM198e+IMMWZlH8W54HWCxKuxNc
	iZcakUAbpX0yiqmOmrZdumgC2+7JrjV77DdH2xngAC3DaEasDKzTjA0Z3IJLx+sqpLh7Tm
	HcY7uzZ4dYw0qQ4SfFmdy257R3xW3bI=
ARC-Authentication-Results: i=2;
	imf22.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=m3KZsopo;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf22.hostedemail.com: domain of ziy@nvidia.com designates 52.101.46.68 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=H5YHGdiKgculxE3sjoXS/SBFzTEHahcj7UpkK9YHTpIIvpBtuvH00AilUaxm/aMFjbRnDVtl9WogTTPNSDtecWA9QKmuj6uIqcav8PZwhtL8yvHz7ZDTMNQzz9a3mA1gKFon7+dE5jcfCYcFPhxrvp0lQxSjQAb72L7nk8nlrWdfy1F5IaxQExN91+Fjbqb3vAfpu8482Ed+xsrCFQtIkKJLE2jCUaxptlpSolyT1jGeREpklUEWblDXbpmVjaqSuD3dNrChbxqOQfHcqsJSvwXMTMED/PQdhoWSfgVhvlfgZy5Rwq9xpeHidWh5vg/4C2kZNRgP7RTCJYSaTuf6XQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wcmhFjgk5Tcs9M6Q/MDY7vkNgbH+gIaGUSQvhFIFf7Q=;
 b=j+peUVxyiqlH3uPPLqr57dCl9F8R690atGgYBCk/zHilTjXcTTFypqTuWMRngJe6tVsKv+ZD6PhzkXr/QezGEaEwW/ylB/0kz8sxjhlnFUgnrrC5gasBpBbOHyOOJd/UOvPxQe/2oBZt+lpHETrbLbw1o0DXaZRS0rG1pT4bshUjv+MrcO8EDb7kE7tkpeEuDHI6vh+1XT82+dz6bDaoNVBNH+2kUtEF62gpSiPPY0aE3Da1ao6stHId0H5OOFct2CSlzKPCVZIOVoKq/3WHfgtjyOQ9bprzSL/KG3s0+/Ywo9mGKSZ/iGRSXkI/tpSlxSI4HG0SiMbo2+d59wXW3w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wcmhFjgk5Tcs9M6Q/MDY7vkNgbH+gIaGUSQvhFIFf7Q=;
 b=m3KZsopowikKC16tqexX0w8iFqOlJ0xvPtJFxMwA7zPyaSfYQ6er5UaOswz01NidAYWo8N1XT605aaoTYIHGKAucg3tYnwNP8ybl6PJay+Bf27MoBRXxWShcn1Xz3NrrTxUC/TAWg7pVOPCc8VZgyXHdm5y0JUAtimUNnAE+dw6OeZjzCL1SrNziiK1u9hFFSnuIKKJb6NKXiC3Lj5W66JspYkbXxT9skMmgVr1VupESM2Hd57xGm9Ml1Gh9zhpi9ybVPS96qF45HOJJ+ZfM3ZpOJ5kiWQDD4VAuNMMz7401VPzJ7Tnrcc8bCVmdTk/U0SBYr3JT6NCTNN0Ns2wKjA==
Received: from BL4PR12MB9478.namprd12.prod.outlook.com (2603:10b6:208:58e::9)
 by CYXPR12MB9277.namprd12.prod.outlook.com (2603:10b6:930:d8::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9137.19; Tue, 23 Sep
 2025 01:46:23 +0000
Received: from BL4PR12MB9478.namprd12.prod.outlook.com
 ([fe80::b90:212f:996:6eb9]) by BL4PR12MB9478.namprd12.prod.outlook.com
 ([fe80::b90:212f:996:6eb9%4]) with mapi id 15.20.9137.018; Tue, 23 Sep 2025
 01:46:23 +0000
From: Zi Yan <ziy@nvidia.com>
To: Wei Yang <richard.weiyang@gmail.com>
Cc: akpm@linux-foundation.org, vbabka@suse.cz, surenb@google.com,
 mhocko@suse.com, jackmanb@google.com, hannes@cmpxchg.org, david@redhat.com,
 anshuman.khandual@arm.com, linux-mm@kvack.org,
 Oscar Salvador <osalvador@suse.de>
Subject: Re: [PATCH] mm/page_alloc: fix alignment for
 alloc_contig_pages_noprof()
Date: Mon, 22 Sep 2025 21:46:20 -0400
X-Mailer: MailMate (2.0r6272)
Message-ID: <3BF1389C-4B8E-4F50-AB0B-F0D96833D387@nvidia.com>
In-Reply-To: <20250923001943.2479-1-richard.weiyang@gmail.com>
References: <20250923001943.2479-1-richard.weiyang@gmail.com>
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: BL6PEPF00013DFC.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:22e:400:0:1001:0:21) To BL4PR12MB9478.namprd12.prod.outlook.com
 (2603:10b6:208:58e::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL4PR12MB9478:EE_|CYXPR12MB9277:EE_
X-MS-Office365-Filtering-Correlation-Id: 32145cfe-030f-47f2-634d-08ddfa430026
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|366016|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?GZ+yoXb5W2m934+xU8whSPesOv2xuKiqsThfkgwKW67AbTNiHXjoDeaGVOT5?=
 =?us-ascii?Q?3pWqgXR5uRqOB1+j51Bm906Tvrrn+SYQqrR6o9UrFg0qAGqKYvevdpYXZQ8/?=
 =?us-ascii?Q?Vj6Rj+qyz2GDx9IpR1O0rJ7XqGf4sd96DjrYMLlAaXazznaxb4z7f6krx5HC?=
 =?us-ascii?Q?jEDF6kGyvlUUtkwo+XZCIxy0vV7Y+rv7CQ7NQGH4ok7aUNppExa1O4UDWMRQ?=
 =?us-ascii?Q?jKhotmXAwLG8HV85uHBo0Q66RkhINFSK8KN720eVFbWqtGxntZXjo8bVCs6F?=
 =?us-ascii?Q?joyf8qt31Jwxggd4Wgd3Drs8BiQ/HwzkG8SJo1CNonQACVeL1/74kwNWKTeu?=
 =?us-ascii?Q?7lX7V6ZPgTF9Cs53+xtoQTBYCCdkQs5QxKOL+F6u2qrl2jl40PeCxdw0UpTi?=
 =?us-ascii?Q?Sb0yDlOjO77n3SMiDjCe7qB4QuP4QnV77j1N9x2ZH0wbxTNPUjvfCYYLOAPC?=
 =?us-ascii?Q?loTblTTTsUh/PoV+UgCUpfNFmvXA3iOIPsiK6DpnDtJ9uKk6Xk3b0zUZiD7x?=
 =?us-ascii?Q?F8dYYWiZWAWJUposYEmNdjMQ0PP6lEbTG8Mf1cs5UHtwnsUzZYSFfHLcBafl?=
 =?us-ascii?Q?dnOWpHj9RDOHPQOx4L8zkSvZ0hOcJI6s1n0ojbFg1N/9ag0GvXSkM6FoFlHn?=
 =?us-ascii?Q?FvVdIM5+WUxSOsrlTHmsLYiuUtuPkbDynA7ZAxShqTGH36NvYmKQFtanJWjZ?=
 =?us-ascii?Q?BGRQRoTj2PnwHtdd5dHJH3eXmJ/M4kfNOKxZhwJxChRjEjL1rD34lyyXpWe1?=
 =?us-ascii?Q?9nFkHGU7KQB05vqsGy+oniOu/cESLQDIlsKAgpn/cJcBYbevB8i8j2aOwzOM?=
 =?us-ascii?Q?s6H73ckrDLRduqbXUrlejw8qdGEYlX1OaX5IthY0plUO1mqTkPd7rn7M38uv?=
 =?us-ascii?Q?P0F9lC1t9QbdmmyJXdPP7KC5fruWES6AobnOApPO93grNKTu09cOBa2k60R3?=
 =?us-ascii?Q?oSBnt00r52eixuWJ4M3T68ecQbjioh2G2qFnRGzTN4d/nfz7wA/mAB2+vIYZ?=
 =?us-ascii?Q?1IGANwvv1TBVgiDMumKKWGHbXk//IrKJ6l1jj6eNO8rQBgKZHmxaEc1UTeCn?=
 =?us-ascii?Q?g4BBgl06tkSCLkbhtICWqdA2fMWGN5f4C68uTqKvMZvCkbOewOxQLZpQZwtk?=
 =?us-ascii?Q?gyjRsJbES24vaftUb269rZuSt5LL19W22O1lkohn30Ad/Ls/YIXadz6q4nQ8?=
 =?us-ascii?Q?Iml7wwBs8zaJ/YFtm0wCs2jyw3ZzibMIvHqDzkSoi6SFFCapMBQMmbdFYKPq?=
 =?us-ascii?Q?GhG+0C2AW44rmDlm9T3tsCBe0JXi94MUz4X/sZRaI8GOc+rV5uH3IOXIW4uy?=
 =?us-ascii?Q?RlzR4jE7kPfr6F5cXGyQD99u6+7Eqj9z955IW9iZvQwbQrswvOr9dxDsF1wT?=
 =?us-ascii?Q?W0fFuA+/gO4Dm5iMk9Pvrc3lsp3rnxtfNRjxJGFcrrkY10tEVLs8DsMaz5I8?=
 =?us-ascii?Q?9TybVNHll8U=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL4PR12MB9478.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?eNLQ6pKV2XslT48drNSi+J+c0dyZ94yhchAxWa4uboGR+uLQ0TAO4s4ApJpe?=
 =?us-ascii?Q?JS29ETVLbzgGgXX5ToJr7t1SSUhNvyKlrB8LlYqiO3TDW7jbKpdsbqLhYwBz?=
 =?us-ascii?Q?lpmNn6aHlb7AkhN+EajR4RhFPc7v4XYPnlUYzh7604zj2qRJ7hTEqIOmu/5j?=
 =?us-ascii?Q?/urirTl7vk9w0FMQvn8my0cYhlfalN6agRJQoaLbOB8Uh8GQpVfTVSY9D0Nk?=
 =?us-ascii?Q?syjZdW01F25dT/wypWjVqigrmhHVEPhYmZ1GUADp6Z40SqhYTycMMK7Omzmv?=
 =?us-ascii?Q?SNCSpCiZ2+1b2caaLDiXOr5o8OS3/2QtnvEBI1sKTaWCoz5sJm4uZh8c/GPa?=
 =?us-ascii?Q?5q7NIgxKBZTjiZzQNp3pjp3cFC5hH42TgM0t9YEErpFhq3Dhx7z02y352nw/?=
 =?us-ascii?Q?REWQfyjQsu9tdU9Od33oXLbXOYcM3DHJXbd9t1UDUQ6aqNNfgwrhGV4YicjX?=
 =?us-ascii?Q?y6/ZHyY22peCDH7hGk7B1+GKaTdlMzV73nW/5MdyAR3FP9r99YZ8lNo/cFuJ?=
 =?us-ascii?Q?WIfZafe/kYhR58t5iYtQhkMr8I3gVGTuPI6KGx2Rsk2oBU1xKYzZ9+nvWx9c?=
 =?us-ascii?Q?KRW8HTzTyuO18n9kHIUDuX6zkXBqXXbdPDRS1oSq5Ixe/DmtffZxEOmCJZAN?=
 =?us-ascii?Q?m4i+CwW3mXBg60hGyC0wfPsf960x7GBXAbeKWP1Mu9uXK9fahwhIZo7Azvtd?=
 =?us-ascii?Q?lX2kln7HCfGnksF6w63izS9ggPg577PKaNIDbdbJGVO9TT8k8bX4E0MPeb8t?=
 =?us-ascii?Q?olWPPOf19BJSafYGgLBFFX4e8TFQWZqe2YwhtMjA1laOi2ZESosYi99jabgZ?=
 =?us-ascii?Q?NRzuMY7Z/YWGWGAhbr89tHAeaUcRip4uc+S/HgRw0hWZq5ijBkqSSU1Ull+K?=
 =?us-ascii?Q?sgKbHDNccwPFWHZYBDZQBJBg44U6q6zvZB9TU0aKx7O8YqRYRpfiR1qY02OQ?=
 =?us-ascii?Q?MIvGklRsFq8aFChe9L/xMTqZuxO5Fk6S+IU6UeDP9Y4uoUBMdMluF9pX/0C/?=
 =?us-ascii?Q?KYDH9dbKps6xoubGCX5W0QAT491LNP8GqamDplCHXvknBHu48u6A42cIdhRE?=
 =?us-ascii?Q?POLjYJSySBzIw/1z1xOnbwi4ty9yjgLEf4QBI+L26NMpSOdDm9LoJBvhGA1D?=
 =?us-ascii?Q?b/xr8Iy+1c+gtElTqNyuP11/aQNd6R1vRqjzE8HD/mV8xv+opH3l/DS6b79a?=
 =?us-ascii?Q?ubU+qvGzMEv/9y4SD9Gn+C52LC6q7RovPaT5LsXv+MA9dgk6YiSSPJKjtQKS?=
 =?us-ascii?Q?6th1nWvIBBou//ge/YFhXzqQi8wTI1OjKZgkKRgeUDVymtEUwdHQ5L8ZYsqn?=
 =?us-ascii?Q?xSPLls0liDNgWqoavIbLKxW/MnpcgQlxdoD49xipG8u9n6iPC2FM3yDDMgvV?=
 =?us-ascii?Q?tXrvAZwZh13jtfnNrFMQdnEQKKdtB23J0V6CGXwjENY/rH3LuTYLaHnuK4E2?=
 =?us-ascii?Q?QhJxnv3pZtwLMLq0PTdyde+06k90BUzlGa84fec59RzSEIFtskzhD1vqEAQd?=
 =?us-ascii?Q?xewaslYhNw6aTMTHe5M2uS0twyhZKMCpxJqsXzqlwLvK8nsNnUPdMKB+E6MP?=
 =?us-ascii?Q?IG3RzfrfX91Wip79ywudOY0A/OGoW23l7E30JSOY?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 32145cfe-030f-47f2-634d-08ddfa430026
X-MS-Exchange-CrossTenant-AuthSource: BL4PR12MB9478.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Sep 2025 01:46:23.0200
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6u+SKGQOg1zINaXyqSJgGHNW5H7pazjX9WIu1KNbyqc3KsgzT4bSbx/thhKT7dVn
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CYXPR12MB9277
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 70EFEC000B
X-Stat-Signature: 3845mtw1rrnj9iog3shwepmmb73kf374
X-Rspam-User: 
X-HE-Tag: 1758591986-409066
X-HE-Meta: U2FsdGVkX1/NwmMYu6iZrfLGW6zwLGo9rWXWTOqOb46AH+eRhfOl00TPFedAqyObRTZ6QFV4ifAKK39/sL7qQCmL7Kolz91kJOV3qAd99j27EFAsmoi5hwB1dQ5XcB2kIMbZRlghtbZI2mnbnC1pgdivUBSo0Lm4LfOEjRUBr9e1FmgcN1FiPQWUSlmrBN6/dnimlRXoQEw4VwONTSm3Iiq2vHvdQ5SbGkry03qAq9o7zI/lHKm15nEsjDgp0bia7FH5rwtE3AYdmilFN+rOvefdRL5a3IxhEXLlN4m8ohf9sFB6Mne0ElZXiXE9PkkMSTXLKqO4UcnK9HaBetikLNGJATyBFlTwD4uM/xyRwg9h4FUNottPTpijpKfC4cKSkuPrnuplJcNEJzdccqEmHjDmUv+9V8KSi9LZRwC1ph9foaPR2TFJqlWM/Zqzzi4Bv6joamphugXRlCw9wLWjSXySK1jPUDsrAfk5I0EWYys+kSZo3lLAVCa33M7OsJRIlqt0WSZ68hxLPMil+xGLq7KQim3Tgt96rOFY0MfTOigaICro0MY2uNiuvSvWBwiCNBGdKx2uzPJph2eguEpT470cNDC1aPvSwIka3TYp7/3WdpKJd9tnhmEmPglKt9iJmekobLn6gbTWdY2OGRGFK1ehOiRNZtgsizfcNnbM47MFv4ber5yhkYJ1wP5liI+IiR1b/cro0x/NFM4vsWp1Plz5Df74iwj4U+P41b9ZOJR4m50eCtasp2n0ORv2tC8Ct7fWuE8axt5O0Gpj8irJVrUwzkcJIUMuKJhEajwUFNH0HiQWxYKbMeRD0MJaWANYbEpNEO0OBx+5dgfTgw8cPGvGT7ipnO2qJvznS5JwM26H+U2TSRds3CSdrdALoBteg2MORiXY6ca5Gag6gK8XolYTgPg86aYxJ9tWYCGlU633Fh+yiTGB+cK2WZpEPWtOLm2fbzaboWBcbt8RLFR
 Z9WNz9IP
 CrVxT1/choMFZukJyZ5sxWQ6UQPj3WB+Qn9WGWtztTDWuovqzjH5yEjaF5Zlnbd0aqK/8407KTfT+d/fNv5s24+6f6+p8ccFHJQMAyMr5FWUJvPeknmWPeMTn64vGOVYc9cUxo8NaVyDYx/14vFDgWxVjWZ7p6b98GczIrOqv8CMKtiNiKk1E6FwDuntQIoyKjzlxk/8UotHSfSb7dft3NIIZJQjSM1An+BSaR8V7creGOuNiO5Sm8GwrNUpfuK1NV2P2w6wvwkF/E5XRCMAoxvCql4d0mTpzcYwsrsBKh7J74CGue4AKf7LsKFxU81YGuiP5Ese/eo4P/bVPKhWuLNuLzDLZAGhG1e375JWZIiPrPrK4kypFylIFBHrn6H/OwKhk2NeQx03LGKel8kcX8fdtklq7St5nMQr0tDb8eOiuoMeUXd6KGqfHTvVj7/3iDXX4pBUxijDU9vtQ05kOzDcfRPoW+WiWyQr10PZzG9wQ6Gi8TTMyINetp2LRrEcfeMs4mFiWW3M+AK6K/DOmIZkkAgpbxBhWWIebuGIGyk5gB9ok60+CauBMBOBAIvuVIG0aGWQfjJsB5ZDMEzm0WnAup5OTbIZ5xv/MrGglU9lQvgvf1ogdWusNBSM6vMnlEQnzCb+nT7JPdvbbDImcnAJBCkiE7uWVCoCWHVOU+O+gwl1lOq/mBOLCgQBQ4fBIsDw7weyY3eq50ppqdoBgqCc8MrJih33RzKwu509vl6jjtMGTd+4KGfgTIFSLH9JPLMbguZoTV/E/3YkliA24XgT5Pgiw4G3yACAnBvTgV7zfUD1ShWVeTVjLFwXrJ2jhs9Vt
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 22 Sep 2025, at 20:19, Wei Yang wrote:

> Commit 5e27a2df03b8 ("mm/page_alloc: add alloc_contig_pages()")
> introduced generic method for alloc_contig_pages(). But the alignment
> calculation seems wrong.
>
> Since ALIGN() only accept power of two value, while nr_pages could be
> any positive one, the result is not defined.

The result would not be any value lower than zone->zone_start_pfn,
so the worst case is getting an unaligned PFN range. I guess
most of the time nr_pages would be power of 2.

>
> Use roundup() to calculate the correct alignment.
>
> Fixes: 5e27a2df03b8 ("mm/page_alloc: add alloc_contig_pages()")
> Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
> Cc: Anshuman Khandual <anshuman.khandual@arm.com>
> Cc: Oscar Salvador <osalvador@suse.de>
> Cc: Brendan Jackman <jackmanb@google.com>
> Cc: Johannes Weiner <hannes@cmpxchg.org>
> Cc: Michal Hocko <mhocko@suse.com>
> Cc: Suren Baghdasaryan <surenb@google.com>
> Cc: Vlastimil Babka <vbabka@suse.cz>
> Cc: Wei Yang <richard.weiyang@gmail.com>
> Cc: Zi Yan <ziy@nvidia.com>
> ---
>  mm/page_alloc.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index a1bcc1e003c7..a17a6014e3db 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -7095,7 +7095,7 @@ struct page *alloc_contig_pages_noprof(unsigned l=
ong nr_pages, gfp_t gfp_mask,
>  					gfp_zone(gfp_mask), nodemask) {
>  		spin_lock_irqsave(&zone->lock, flags);
>
> -		pfn =3D ALIGN(zone->zone_start_pfn, nr_pages);
> +		pfn =3D roundup(zone->zone_start_pfn, nr_pages);
>  		while (zone_spans_last_pfn(zone, pfn, nr_pages)) {
>  			if (pfn_range_valid_contig(pfn, nr_pages)) {
>  				/*
> -- =

> 2.34.1

LGTM. Reviewed-by: Zi Yan <ziy@nvidia.com>

Best Regards,
Yan, Zi

