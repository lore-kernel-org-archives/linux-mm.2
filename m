Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CD5FECAC5B0
	for <linux-mm@archiver.kernel.org>; Fri,  3 Oct 2025 17:12:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0312C8E000D; Fri,  3 Oct 2025 13:12:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0024A8E0005; Fri,  3 Oct 2025 13:12:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E0CBA8E000D; Fri,  3 Oct 2025 13:12:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id CBCF68E0005
	for <linux-mm@kvack.org>; Fri,  3 Oct 2025 13:12:10 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id A0E30140858
	for <linux-mm@kvack.org>; Fri,  3 Oct 2025 17:12:10 +0000 (UTC)
X-FDA: 83957446020.28.14C5912
Received: from CH1PR05CU001.outbound.protection.outlook.com (mail-northcentralusazon11010020.outbound.protection.outlook.com [52.101.193.20])
	by imf24.hostedemail.com (Postfix) with ESMTP id 081D2180005
	for <linux-mm@kvack.org>; Fri,  3 Oct 2025 17:12:07 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=bT2Lwqm9;
	spf=pass (imf24.hostedemail.com: domain of ziy@nvidia.com designates 52.101.193.20 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759511528;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Im+8lRf5N/pjTNVBcX8kmjP5KpMj9WjG4I7Jv4zYoKU=;
	b=lfUBATAhbyTsw4rHABmGtrqXOYKqHvOi3ePe+OE8iaihhIK4vf/KHcgzd7F8Wqjc9ShEa4
	NDGJXMlejF4CpQssjfzD+IpVcylpg5icXg8QoVRIaOSQ0u/8ju7SDTRRXw8fChFT2I2h7i
	dDJgW4M7WyxbhiawDpEeiS0JmAE/fG8=
ARC-Authentication-Results: i=2;
	imf24.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=bT2Lwqm9;
	spf=pass (imf24.hostedemail.com: domain of ziy@nvidia.com designates 52.101.193.20 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1759511528; a=rsa-sha256;
	cv=pass;
	b=4K0NkFEtyeShkEEo7KfOtAEAN8IuRxQDjQEIePQLvgywZKB32goJh4uAq6HjXLnd4opKLf
	7D6CAL7dXJwjQFWRZ+HPXHzIH6lNCsAYWGb/9eLwL0XoXNGnfGlDJU8u2cP7PYEO0PrdGL
	gJtl4+cYso6Htta80BQGi4h8DGV9JMg=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=vkbSeV0rt+L7f2F3vh875LPtLmelK3pGeBp2k8x5aNKF2zC0s9pyPCY5vkbTQzX0J9E8YMgZtiURnizz79QraM7vWWwE8n65+xfODCyMctZr4PH4Zd//pkX6roGV9+nxKTtKp844XzXS/MCll5p6DG1/ycteK0p2RIjqv3HguA1OmOMMHqReMdb3RfyHflSfjRCPSTRuAfJ8XrIWQbBFsXdSrl5e92zPcfj5VV94uv7chTlsMTxHqPMievzJF28Uk7hgMSuvNvG4NdajRy78PSR3Awv4PuOOzJc4yO3nkv1TC6DfoiL/7oe4j93sZkg0a2NonOHXiK5snT9xmLfD9A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Im+8lRf5N/pjTNVBcX8kmjP5KpMj9WjG4I7Jv4zYoKU=;
 b=T3Ae81BBOg6mqfwq5QFn/NJah8yI75/nWiiOa29e7vKXxfYkCTJxIN5aZ07Zh+aKOaFBxzNXJnD79IRTVR5b+D6kS/a1bheNnrlfkRo45yChQm3MzdhyxPXw6d67pa+faTNdYiY2By3gbrwOqHKVQmzXhZM2Mi0cwEdqwP+C2QSruUV3lGNbPsJsJ+Wcgwwh6NCahivf2wCn+x/zbuD/l2mhDgjbWUu6xj/6p8c2Y5JYJcx0ZeN0IZzn7Qf/v+p3EMjhWxXjb4zZZSJYg/CO+VV4LE7azsY5PtlmzuBIrcOfDz64ixsOjy0LyKJPO9g7NE4wMUffScIxlcI3rSNJXw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Im+8lRf5N/pjTNVBcX8kmjP5KpMj9WjG4I7Jv4zYoKU=;
 b=bT2Lwqm9Ys59h84E04p4mv5xohEPPy703p0M5sHxFXG0PJPeSRW6loc8XkE/OnaLr6lb1yUT82oejPWdzNtxVd94kOEoXTjLP7THfv7IqMqktbwEY8k60iR8WYGdgrxmRmk5gvQmZGKjZiv6yKZTybIEgL8RTc1D9nuWewpZQtwweieSt4RGvgoWs3Jywcjp7dRakTPzIDd7uZv9n1fe8tdYxVWab/RVU++TpXzIUFZyqQk7qKoHrHMzBfH61kZoK0caKpyRGlScT8UiqGPgD3vUei8u/A87K3n0AaJRXhAOuUXMgiQA50OdCdC9gIXkNNgJYZX2Vx4gn8jxdoSdPQ==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 IA1PR12MB8517.namprd12.prod.outlook.com (2603:10b6:208:449::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9160.18; Fri, 3 Oct 2025 17:12:01 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a%5]) with mapi id 15.20.9160.017; Fri, 3 Oct 2025
 17:12:01 +0000
From: Zi Yan <ziy@nvidia.com>
To: Usama Arif <usamaarif642@gmail.com>
Cc: Lance Yang <lance.yang@linux.dev>, Wei Yang <richard.weiyang@gmail.com>,
 linux-mm@kvack.org, baolin.wang@linux.alibaba.com,
 lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com,
 wangkefeng.wang@huawei.com, stable@vger.kernel.org, ryan.roberts@arm.com,
 dev.jain@arm.com, npache@redhat.com, baohua@kernel.org,
 akpm@linux-foundation.org, david@redhat.com
Subject: Re: [Patch v2] mm/huge_memory: add pmd folio to ds_queue in
 do_huge_zero_wp_pmd()
Date: Fri, 03 Oct 2025 13:11:58 -0400
X-Mailer: MailMate (2.0r6283)
Message-ID: <5C87F8F6-C508-4BE4-A3B4-9563AF48EFE6@nvidia.com>
In-Reply-To: <29ac3e02-fb60-47ed-9834-033604744624@gmail.com>
References: <20251002013825.20448-1-richard.weiyang@gmail.com>
 <d8467e83-aa89-4f98-b035-210c966ef263@linux.dev>
 <1286D3DE-8F53-4B64-840F-A598B130DF13@nvidia.com>
 <29ac3e02-fb60-47ed-9834-033604744624@gmail.com>
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: BN9P221CA0003.NAMP221.PROD.OUTLOOK.COM
 (2603:10b6:408:10a::25) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|IA1PR12MB8517:EE_
X-MS-Office365-Filtering-Correlation-Id: c12422c3-9b6c-4ff2-eff9-08de029ff79c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|7416014|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?E4rl2Woe8L9aX0LaLC1y0aZtcv3bxRNvXz3xRwVTyAbbqUUo6qs7w7iZ/CD7?=
 =?us-ascii?Q?lAFqUqa4f9tXm1rRvSVwD1VhO2NRkIDEc2kkSpNnzfBwX2upRBGxGpZvsb7Z?=
 =?us-ascii?Q?0thAjrRwTt2oaS7fZ059MHPpTIPmxpG+dDw0WNI00aKJCjsKJQJPFSw0kVzF?=
 =?us-ascii?Q?vSlBcG7ZCcEsKGlE1h4V29SoXmZ3/f8Jq3JLueqLWfDm0WW7+7m2JFwgRFpZ?=
 =?us-ascii?Q?RlqktO/RLmmydeSYgBB71ks7MkSo8HMtBi8bgt3NweKnf/n6r9Gj4I9qHrLY?=
 =?us-ascii?Q?/SP8iV8g3nwt45hGgvgxZh7KuATaQRmflfDREOAbkXB/nAiui+tXow4pAYT+?=
 =?us-ascii?Q?gzmMJTwCvckTpxVOiPIVNHs036nh5Jt+pRjAFknwxMzCS3s4hqECDkdpV87O?=
 =?us-ascii?Q?i3nng3JlZ6xEHZGni6c6ZHiDe/Qq6BGhNccW95w6yoqpOYwl6v/9xV+Gn8fS?=
 =?us-ascii?Q?qvrfYFHX/TO4KpuoxoDSbaYTpmE487K6yypAon5StVr02vaj0Zk3adIhYPn9?=
 =?us-ascii?Q?QMZcQ4+QpryrlVTYGh1AglPdTEnPQpx5ytOTLyr4s2GGQKHeEeTkAMWN+ioJ?=
 =?us-ascii?Q?a4PBxetvVbnG05RQVQvwj5KyY+1JCLSIx70L9uAAv3kBdGdMaaa1J0aaPAu7?=
 =?us-ascii?Q?jnfHMSYeC+x7nWLjBK0fz00q7my9+fiUxmLpGtxC5ztIivINa6Cx1osvBK8D?=
 =?us-ascii?Q?QE+WZrrZsEaBeRa24KVLzPfADnI0bKfA+IU81kQRgcgd3rlSlEo2fVs5pXJf?=
 =?us-ascii?Q?HHPbyNuGk1zQQPys0VVH9f99mnSzUu8M/VeD9at3kDJugNYeseWW+l2FcGpZ?=
 =?us-ascii?Q?SjnCrb7jxriweV4mkTq0Dle/1ggqGFH8/noE31DpYYDr5OrzthIeo+gi863x?=
 =?us-ascii?Q?RI0WWoV7IZbS/hNMWvvQIOG4PTmKZvnd66hHy1KuHNgZnV9Id6wtQycdKijl?=
 =?us-ascii?Q?Rkmr745rz/A44KMBFMs4yIYnyMNWhjpVm6BSHtRkgkrnnzqmxuGfQd35svPl?=
 =?us-ascii?Q?mlEbyBnKuSGA8iyeYZvz/uZ3tzZzg47y1F3ZqUG8ZDmHRMvM+LWYL3wI7KEf?=
 =?us-ascii?Q?pEbV0OEP7uXOVKVmh0Hm/RSJ/rSX2A8AynPXs8h1M55lviw23oCF1m24tkbJ?=
 =?us-ascii?Q?9wBkC3Op0vjizVZpgaEJ5EJhH9Q1uPqH20vkOMHV+ivBsESrKO4nVgvb6DyM?=
 =?us-ascii?Q?MoeE1hDEaaK6j5Mnb7r6DWvWOanDVBDKnRTENXZdmQZGDl70fBPrknuPIlw6?=
 =?us-ascii?Q?4HcP7SwTO6YlYS2XZs5A3MYvB4DV3vCAM0eeHeu+d0zHyIg1imZUH0qPV7oF?=
 =?us-ascii?Q?M61+eBR4n3JSnHAKdPibtx5b6SbmxzVpX0Yjwo2aay74XPno381blu+n9KUb?=
 =?us-ascii?Q?Bt4aHvYeQqzPVLQ9IPQJfNbDi3ZzLRih4KVs/mPWPGL50vvRc3vPCgcKwYc1?=
 =?us-ascii?Q?NxfLhzLvXgpGb4L+xEdlPJ8bzgCLA76z?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?8bRF/rUGRAFcr9Fxm7dNaInDm+VsOSIvGRglCw/aORR/Y1UV4b6i/Bxgb/bU?=
 =?us-ascii?Q?CvqJ2qWiWQfkH3s/j5djyI3mc6P4AIAHt0S33T5NzjbRlu6njZObxXtw/O/B?=
 =?us-ascii?Q?eikC3r1VcrB/W4byfbs7elM5LOaPbfSqdFRap81YhrZuIYsLgtUBR8s0I2Mb?=
 =?us-ascii?Q?B976mj9C7hnb5i2Wl81Gx0cj1oVxgIdHz+hu/lmMTp8xH4Jz+FmdnIOBxGuD?=
 =?us-ascii?Q?nKWFkKCwII8ECMsJrnaJ9qoTNn58Lq/4pmPfbadIXYToZXAwe/wA77pIziiT?=
 =?us-ascii?Q?wyofB3xkeyE4vLHkSQVnN5/BPuiv2C0ZZP43CyS2U7IcvSebcAdrqXJNXZ0m?=
 =?us-ascii?Q?bv4WtwM480z2TQq5yEGBYL1d+ePyAmx4GhvqKdFTE+cBBqCYesYihmIdGDgW?=
 =?us-ascii?Q?i6mN/cto0EiPMVWmCqbawvGrpzivdmKIdYByccGDD9QVplJmqDfq8rFvJkDn?=
 =?us-ascii?Q?c+1jz0slcNBiWa21o2dlvRkOiUsl/IpgmuV1xwnVbKF+i9+pPClR1HwHq21Y?=
 =?us-ascii?Q?gltMg5LU4wplUOAJ9ocaG3XLxEXnNcFK3FtoDl/194LPLHrdiH7w0o/6xl9N?=
 =?us-ascii?Q?+nU5DkYSL9ozZW97iI94d4PNJKTLJUGEV0i1xhSmuyZ15ptmmQhSjWNh6pi/?=
 =?us-ascii?Q?CwTXo6x5kgKfV0+7VA5LpUXOIvnxt0874v1MmC+9RaRNr6Res2C50Q2pgHsW?=
 =?us-ascii?Q?1zgmpZpaeJhwgIl+Ync0aPv6B/t/h/Ax9UlVLrjftBa1KiOlU/qFVtd3asCj?=
 =?us-ascii?Q?4XrunguNG6bGWWZN8o2pVKydhHWmoXtY5s3rvD0yM472ZgruMHCuBWIBnz8P?=
 =?us-ascii?Q?K61sMziGLgfoy4JhUajHpYxZzdlpFFcTNN4YZ05BJzgI0kKRbpxLdniRdL7h?=
 =?us-ascii?Q?vAJvS7YlztoznrULuDWFwww8ruhoKKnsNMAj0ERbEJ40jFBK/WJXCgM3n6Ph?=
 =?us-ascii?Q?AMK+EltZy6nBigFYU+imIcEO7cro1bRwlG4BiUuNkOa3IunOPY0mRkD8MbWX?=
 =?us-ascii?Q?QMGWkOfcHEyyiF/vF8DvtsntjUcHeVyBk4ryHtLZ4/7uRZDvRhOTIi7wb+nv?=
 =?us-ascii?Q?SmVXVtK51EqZyRicyCGw3IqQKpsYL/t9IBxcUZSgBUGhzAuhfMyGAzSidFDq?=
 =?us-ascii?Q?x1GMg4JX6EoejMGd9AlmVRSB78AqMsEZ+fC6ZjHwrzs/fpghCWasRj9IHOGC?=
 =?us-ascii?Q?GXkBCPaoulPkPDwXhEt3C9eAIr3ffmVJCImNw3B58S5lgsYyMVmCSHL+6qsS?=
 =?us-ascii?Q?PEE9YgdV3hso98dfnEI2Q6KE4COCCwWsrhdnsJ3Bbi+gR4ybsbfF5Is2a40B?=
 =?us-ascii?Q?Rh5RiAbgl+MI+aqKqVBmjBMzudvWdOQfyby0fjiX6nOWCXc0KtDCBDG+IOXc?=
 =?us-ascii?Q?ixxoGNI2JWS3thmulY67IX7uJBOTeMLPgrnma/bo4pjDqL/GSpF5Akd2uJNy?=
 =?us-ascii?Q?hJi1C+3Ce20sSX4wHxA+uUXJH2COAjnrKUaygBz+WbkSr4UvZRRSSsuhhOrQ?=
 =?us-ascii?Q?i++DxctMM0/mpjhcpmmI0CgZazK+fioFe6sEZSHJAYHm5F3SImgwlSTOHZDE?=
 =?us-ascii?Q?cnB0TuIxdbHMQga/hauTgEVZCevefVFjB+Nk/6YQ?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c12422c3-9b6c-4ff2-eff9-08de029ff79c
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Oct 2025 17:12:01.1839
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Asi1CC/GdzBTuT7cF+4Xd7DijA5scJI3DjFzmLP85WHrWPfohGXBSizTWu0ogkvM
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB8517
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 081D2180005
X-Stat-Signature: tdghxebi8h8wztkc8g8kj3zkcg5gjzdt
X-HE-Tag: 1759511527-287677
X-HE-Meta: U2FsdGVkX1+U7FPZkZIIOOQmT+nH/1fJCeVAp8mp7S/QSPGQNAz4xy1VGjsXf4g23ca5W995iK8uaaRdVVgikCMmVVXANDBEOOYMufjdbdqsZNWz3Eh7gY1EJWbZpT1V6k2hxTRZt82XTndTQ07WihRQVSaok8ZjP7G3i6XHdPTJux6n5MgcXgHq+Ld+lisidb1xlmYe2th3p5ndASlpgV39b3xDbh1/6F6fduWWCT0LOgoDtAj4vSxWUIxd123JuULHMZmhy0M5/WnxU3nb3nBXQa7oxdyAGNN2WHadFEFBL4PQkIYzg+7o0obkQH8c7Ln13TcMjQUBDH1p4dmH9Dh56fx0A/8DsM/AB5HBUw2bMGpiKajavx54RP5r2NpHw+yWodIGDMhX3hG/zor8DwXJhB5Gdcx9xaAG/OYodIOEiNUAPOQQF0Ac+4okT01kCMmcZUVBgyeA9JOtBMYzy9OEXolZfny4CxNNMdhvnjH5iCPZdtci2MlNdzqPOcGWhZKQBfmbE+DlL1fuJfNv30U8k/yNjUDBsWwE5E+leNPx5SOuihcVuQ5F2RXdYUtfHXfT60Tp1vCzaFOsnGVxnTdiwhuV9SiGtWDzICZJ2xDik2REU0iUNPBgJyYFx197CcWa7i1fI/iMZGpqfuOOtDXHoUNSGXm1dpFfllwV5PImh6TS8dr4bzqHW646dNVpi+q4KWep+7Y7ct4ZLMewU+NLOtVddToA2UOqtsdpoIxi+1bTub61yLqfXtUioY+pJA5/S6NNc7nTezoXj/Pk6aeGAEyJGWWeRYu2yW/j6fTXfrpe88C+Q26kVcyZmNEzYyX6ulFX3Y/bRChaKslx1xG3jIY3ZODdCOo7KJzVBHOfeeHK0BZ25Fw0X+b/GlD3xAWNq9S0bqlNPjXNmq3IMRRPHDZ2UH7mhpYwkqCOrsOLuYk6uGo0/kUPsP8qF+eXM6gFf+U373H/pvhdhKA
 iNpcDgbX
 sPqimSW7V/5LXqkvqrP6J01qSJS9CqK33Hw1TniAkdlmck+m4OqgqaCOATu210IzSsqT9JzlFUmnZARaCWhShPGQKUw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3 Oct 2025, at 11:30, Usama Arif wrote:

> On 03/10/2025 15:08, Zi Yan wrote:
>> On 3 Oct 2025, at 9:49, Lance Yang wrote:
>>
>>> Hey Wei,
>>>
>>> On 2025/10/2 09:38, Wei Yang wrote:
>>>> We add pmd folio into ds_queue on the first page fault in
>>>> __do_huge_pmd_anonymous_page(), so that we can split it in case of
>>>> memory pressure. This should be the same for a pmd folio during wp
>>>> page fault.
>>>>
>>>> Commit 1ced09e0331f ("mm: allocate THP on hugezeropage wp-fault") mi=
ss
>>>> to add it to ds_queue, which means system may not reclaim enough mem=
ory
>>>
>>> IIRC, it was commit dafff3f4c850 ("mm: split underused THPs") that
>>> started unconditionally adding all new anon THPs to _deferred_list :)=

>>>
>>>> in case of memory pressure even the pmd folio is under used.
>>>>
>>>> Move deferred_split_folio() into map_anon_folio_pmd() to make the pm=
d
>>>> folio installation consistent.
>>>>
>>>> Fixes: 1ced09e0331f ("mm: allocate THP on hugezeropage wp-fault")
>>>
>>> Shouldn't this rather be the following?
>>>
>>> Fixes: dafff3f4c850 ("mm: split underused THPs")
>>
>> Yes, I agree. In this case, this patch looks more like an optimization=

>> for split underused THPs.
>>
>> One observation on this change is that right after zero pmd wp, the
>> deferred split queue could be scanned, the newly added pmd folio will
>> split since it is all zero except one subpage. This means we probably
>> should allocate a base folio for zero pmd wp and map the rest to zero
>> page at the beginning if split underused THP is enabled to avoid
>> this long trip. The downside is that user app cannot get a pmd folio
>> if it is intended to write data into the entire folio.
>>
>> Usama might be able to give some insight here.
>>
>
> Thanks for CCing me Zi!
>
> hmm I think the downside of not having PMD folio probably outweights th=
e cost of splitting
> a zer-filled page?

Yeah, I agree.

> ofcourse I dont have any numbers to back that up, but that would be my =
initial guess.
>
> Also:
>
> Acked-by: Usama Arif <usamaarif642@gmail.com>
>
>
>>
>>>
>>> Thanks,
>>> Lance
>>>
>>>> Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
>>>> Cc: David Hildenbrand <david@redhat.com>
>>>> Cc: Lance Yang <lance.yang@linux.dev>
>>>> Cc: Dev Jain <dev.jain@arm.com>
>>>> Cc: <stable@vger.kernel.org>
>>>>
>>>> ---
>>>> v2:
>>>>    * add fix, cc stable and put description about the flow of curren=
t
>>>>      code
>>>>    * move deferred_split_folio() into map_anon_folio_pmd()
>>>> ---
>>>>   mm/huge_memory.c | 2 +-
>>>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>>>
>>>> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
>>>> index 1b81680b4225..f13de93637bf 100644
>>>> --- a/mm/huge_memory.c
>>>> +++ b/mm/huge_memory.c
>>>> @@ -1232,6 +1232,7 @@ static void map_anon_folio_pmd(struct folio *f=
olio, pmd_t *pmd,
>>>>   	count_vm_event(THP_FAULT_ALLOC);
>>>>   	count_mthp_stat(HPAGE_PMD_ORDER, MTHP_STAT_ANON_FAULT_ALLOC);
>>>>   	count_memcg_event_mm(vma->vm_mm, THP_FAULT_ALLOC);
>>>> +	deferred_split_folio(folio, false);
>>>>   }
>>>>    static vm_fault_t __do_huge_pmd_anonymous_page(struct vm_fault *v=
mf)
>>>> @@ -1272,7 +1273,6 @@ static vm_fault_t __do_huge_pmd_anonymous_page=
(struct vm_fault *vmf)
>>>>   		pgtable_trans_huge_deposit(vma->vm_mm, vmf->pmd, pgtable);
>>>>   		map_anon_folio_pmd(folio, vmf->pmd, vma, haddr);
>>>>   		mm_inc_nr_ptes(vma->vm_mm);
>>>> -		deferred_split_folio(folio, false);
>>>>   		spin_unlock(vmf->ptl);
>>>>   	}
>>>>
>>
>>
>> Best Regards,
>> Yan, Zi


Best Regards,
Yan, Zi

