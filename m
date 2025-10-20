Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2CCD8CCD193
	for <linux-mm@archiver.kernel.org>; Mon, 20 Oct 2025 14:28:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8F4398E0023; Mon, 20 Oct 2025 10:28:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8D0EE8E0002; Mon, 20 Oct 2025 10:28:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7931A8E0023; Mon, 20 Oct 2025 10:28:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 662878E0002
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 10:28:37 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 20EE7829C0
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 14:28:37 +0000 (UTC)
X-FDA: 84018723474.05.AB60098
Received: from CH4PR04CU002.outbound.protection.outlook.com (mail-northcentralusazon11013063.outbound.protection.outlook.com [40.107.201.63])
	by imf26.hostedemail.com (Postfix) with ESMTP id 36C91140011
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 14:28:33 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=Wq3+dUCF;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf26.hostedemail.com: domain of ziy@nvidia.com designates 40.107.201.63 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1760970514; a=rsa-sha256;
	cv=pass;
	b=hiKXWo5ctSBLzGrDC5II6qBGv3C+JfybCWatXzoo+FD6/fokmZnif6QWitn5t/pCWRykEj
	n5e347J/BTRt1A1vK7uWYT4xfkyf6RAcAkLRaP17uWDylJvQdg/a8+BAb14vtm+TgCWsvh
	U/Z5zhX/1CX8GdeZGsAyrchIUV+CfaY=
ARC-Authentication-Results: i=2;
	imf26.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=Wq3+dUCF;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf26.hostedemail.com: domain of ziy@nvidia.com designates 40.107.201.63 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760970514;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VER59A5DP1swYRyTVnpQjtkydI6Pl6HkAkKv8utGCjc=;
	b=NT9oDrZTFkRz46VUFjv2y280bj6hn17esVVkTQag3Vlxg2556OYpDkAzsgspp6ObjLXYUN
	LC8GOKgkLSshC0bInWWMVnCrGZPHNNpCPhOdGomaucIltnkAj+JOycKT8Yf9BAYhQu+AFE
	Qsb7neO0qIXelExAJaMYIiiQoAWQM9U=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=N7bfl8T8XHO2ngPwLVN4HloSBiXxeS5GN7+w5i+7pmhKVN5dxafSOfuryCFq5/ZCG/KpP2TCNJ16C11MiDbpZUnUM9uu3CFyFBEZjWOUuduyjjuj2Ku0M6qZqq7ZQ5uZvn+jHtUqNkLT6njqnoQBOmJ/blMB3qY8A6iHddukD8FM/Yrv5ruNXcyDGlgyJjz9cdnl0y6L0WMASBUwi3rJoMP5r/wgSu/djwnokt52LIKX1GxWt0k0ZJMZPtVPXaEuuAqLYLZh6DaUDTRnOTf0x6whPNdx6nVH5lzIHVwhL63omzPZpRgqDVjTqivVoCG8ijPE17fMOax30ICriujbqA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VER59A5DP1swYRyTVnpQjtkydI6Pl6HkAkKv8utGCjc=;
 b=GYBAH/TkBVm/ibOAqvTmCIumTJteXWIeTypQS0RUNzy2rkgGzuEdP9EZWtA3cCsDsCLN+oTRTWJakqpvtnA80q0/4Y0fBH84sKa+3GzSCDYIjKhj8Zt+GmIYeObXCaLPMRCqau21sGtHl6pkCLJTQDYfZCSf8YN7ITcpEyi/sAGgR8209g2/cCyuYnxRBh3O6Dkkhm77b4K+as+nNSOnllEJqb6xf9c1BrYMADlhZ++eyNpWR2GfehhQzquUEmEOmKuOaL7odOPWOfWHZ/BnynHX3TKB0az9szkD4uKDGt1/uTTSZnrwRNaIHOsmaEGLMvBymc1+lkf1zvzyOBajoQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VER59A5DP1swYRyTVnpQjtkydI6Pl6HkAkKv8utGCjc=;
 b=Wq3+dUCFWy9FJaKCKoqZcqYBzU4orNTgJRpxbKe/ECIXif7xbHNKpFoB6E/yplPj02Q3B1Zrmni4h0Qdnlud/eoQIfhlGDhjUnW9lPOdqrk/zNXcym2h884UGgGHHqFN6RbB8bwBynndVTjtWNrQVp5MhtWZteEWNAtF4qb3F32eskEVsm3OVo0C96rxw6zgqa+e1EFmmz3A72SsnhVD2X152oJHGuxD2TMmQ63TfpNadyVyUs5vOTzl3Rwr3tqzMz77sg8IjQXBMpmLhgT0kqonu3TAazdrRdl0EgraXFpSNc74dDrs/wALwL4ZSGfC0+nEsxwWTnyFTExwizehrQ==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 MW4PR12MB6827.namprd12.prod.outlook.com (2603:10b6:303:20b::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9228.16; Mon, 20 Oct
 2025 14:28:26 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a%5]) with mapi id 15.20.9228.015; Mon, 20 Oct 2025
 14:28:26 +0000
From: Zi Yan <ziy@nvidia.com>
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Wei Yang <richard.weiyang@gmail.com>
Cc: David Hildenbrand <david@redhat.com>, akpm@linux-foundation.org,
 baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com, npache@redhat.com,
 ryan.roberts@arm.com, dev.jain@arm.com, baohua@kernel.org,
 lance.yang@linux.dev, linux-mm@kvack.org
Subject: Re: [Patch v2 2/2] mm/huge_memory: Optimize and simplify
 __split_unmapped_folio() logic
Date: Mon, 20 Oct 2025 10:28:24 -0400
X-Mailer: MailMate (2.0r6272)
Message-ID: <C88825F0-89F7-4BBF-B764-76B681CFC64B@nvidia.com>
In-Reply-To: <8dadd256-175a-4706-84d0-180eda04ce89@lucifer.local>
References: <20251016004613.514-1-richard.weiyang@gmail.com>
 <20251016004613.514-3-richard.weiyang@gmail.com>
 <7ed84d61-0a7b-4961-82eb-fc8d38b77162@lucifer.local>
 <154924ED-0CD0-458E-B760-F9F0A92CDC89@nvidia.com>
 <d0a2c81b-a0e0-4457-b355-2363f30ecfb8@redhat.com>
 <cdd37933-d2e7-4675-82fe-62b7f0ccdd80@lucifer.local>
 <A67D1276-D59B-41E9-8A88-E54E05A0F479@nvidia.com>
 <8dadd256-175a-4706-84d0-180eda04ce89@lucifer.local>
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: BN9PR03CA0403.namprd03.prod.outlook.com
 (2603:10b6:408:111::18) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|MW4PR12MB6827:EE_
X-MS-Office365-Filtering-Correlation-Id: 02c171b4-3cfb-442e-7bac-08de0fe4ee4c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?nja+to8m41G3jRcqcbCNL2Q3X9C1WXh79TA8uDuLl3s5hYGUO6S1olsMIiuG?=
 =?us-ascii?Q?0isdDyimAI3kpxGwtU9reM4XbVJLLzLD2YfxWwA5eWGjTq3D5yT4Zt9jnY7t?=
 =?us-ascii?Q?CFxBCMhLD0P3G4JSFgLVxC4i+VAfsQGTBG+yc3qGnL63/wZRjvPK/RVdQOFa?=
 =?us-ascii?Q?1sYMAacMD7Hlz7jcdBZ2bgZpQ5LbT82UnDId4fq8OmCi8IBMpxX27rvxjo2P?=
 =?us-ascii?Q?dCouTqEHppVppqcRR8vyxl0Rpo06RBZqIFnboIMMQhsyy4JdYh5HJ5Vq7+iq?=
 =?us-ascii?Q?1M6F+hI0ZmFcNrOP6gooeqmw823s7ppx9drHZz4zMf/pJvxoF20wwlBmOOmX?=
 =?us-ascii?Q?OPK/oOStW/othPIX0l35JOyavpJRHXrmD8OsrA1kN/R0mD5YbREV2gIJw1rL?=
 =?us-ascii?Q?or9tVzzVFtAmSfHJFziiYzJMaNaPxXNaDK75hbMCZhYRQw2v4C7IkVGc61yy?=
 =?us-ascii?Q?/FIa+GIsDAjF9W0UZKo5+xs05JHePyaG4HZEfi8wBD3qq/JM9kcxEB52G+yf?=
 =?us-ascii?Q?ugMw0d7TG+XC+g706TbJDPQ2r2q8+2wARAfDRXdEw8q4267g66X3GSUDBTu8?=
 =?us-ascii?Q?jBbFu3uyj1IYZTULoihpweT1Q6R/sjjpOaLWJizfZx5aTHgM+necSJVbMffF?=
 =?us-ascii?Q?yP/Qs8V3i/M/48/UVUoLY7Gj4E5WLHDYjC9Yya7oi5fjFWANtuzP09dRtK1g?=
 =?us-ascii?Q?b34wJbJrfuSBpDWrUqQCgI2vVCZQO69mihTGt2U3N8N23kFRPXrYt5AEPudT?=
 =?us-ascii?Q?dr83lPcYlQytQYM7r0gy66Wd6iwKzpO/vkg8ydcMITJZrHHa5gviErBpkIZ/?=
 =?us-ascii?Q?5Ga/K09v1WndPMeJrAbIrGDbefGMXoJpn5kpGuNhrKysgeFrxqCMwWjTk+TC?=
 =?us-ascii?Q?9vZUIPMnklk2QEdgsSzBYV/Wg8g+y4cK604j+KBjGRS4IRRLFfu2omrTIMe1?=
 =?us-ascii?Q?2l22ekxuYc0trz/aSznQCbygsCFzLDqbSRSxvcw7fJ174aFMfGHo+oaXqlMb?=
 =?us-ascii?Q?U5OSYWhuGc4AEXUCGNpfpu5OX9wpxOEQ8OzQR/F4JjDl7M+MXKMej5tmwNug?=
 =?us-ascii?Q?tpYXD1IgdWRZcSqZ8Of193u5BlokCEATI5/mHja2rhnJov4qfJqeDsu0FTyW?=
 =?us-ascii?Q?DLfyDAbuPKhllleNi0DW8CAX/crtU5JMc1+2cpNPog66NKZkWts1vrFuiDSe?=
 =?us-ascii?Q?9I6Ua/pJFD7Pd4LFOLqbkDARPa/vdm9YbUiwg3pjWK9jglc4+xS28Zt3cnw/?=
 =?us-ascii?Q?xT/BVbxGBHMPwhhu1trQEikrX/45BKacwY9xwEw9qVRJHkKpZ0ZZunlkxAm7?=
 =?us-ascii?Q?Nksb92hHZdKYFWHTqZveFRhgJzX3tNJfhYEO7BRtm52kJifyivvvZkc56s+A?=
 =?us-ascii?Q?RjPDpnGoAiSA0CVK3RJl4DgxofHGuzGHFvgu/gBmMy8YSDgggEIcVCY/oISm?=
 =?us-ascii?Q?vbYtVWDQ5M6qOPQZ7+BVZvKd7ZuyoJjzFidlCtS8ye9SNZAp44Nlcg=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?YPqW9yGcOL22HxuoRSEmOhkOfENtkfukDxprIMQlmz3GNIthBsGdHxKp9fLY?=
 =?us-ascii?Q?PkQfMiabguUviM7Nace5p4RkpqlfJr1JP3+7HE9eOyuMdPZAKYsNMuPmdIT8?=
 =?us-ascii?Q?0W6wSRRe3+l4JJzYqHb0mmTgfXwP7LKOvgTUt6HpcSIpRqbO+wMn0vYv0xac?=
 =?us-ascii?Q?iwLzsZFplpKgCBpJm2QKUyiVPt2xv8kuOhF1E9yw6P4s7Kkfb8Hwfqbre1HH?=
 =?us-ascii?Q?Rr/5ULZNYpS0VaPl2pwlQ4Sz0xQpE+/ZhYXrslpbao+EsL0cPlj4QYKJ8B3P?=
 =?us-ascii?Q?CD5OSJ4PHeLq6liRBHy5XalvJ2bIzXcDgYy8VdUskH6CVbGq/6SBu6uTPKg4?=
 =?us-ascii?Q?b/5HvjU5Czg8kPZrBd7rk2Zm70aZVLpVKqTO0sBsXfIjF+4jHmSg+ny0IY4B?=
 =?us-ascii?Q?DhVFWYsawYiPSTaJb1xpDkX83TcWvDWgxmupyPTdbHuYm0Ch3YRlaLUGjpfA?=
 =?us-ascii?Q?ohK3YBvAMo4cgR1PYJjhfgzPVPdWqKvYcWFiTxQqF0kZjExYX4hEnC6lsWK5?=
 =?us-ascii?Q?ZRBWgpz+j7CzJtc9YTrJRUuOLm8ARRMBnAEa0T26Anq8iOhnA0K6BzI61CvH?=
 =?us-ascii?Q?fTU+7IrTqN6GvhMsQ92PPVdVoacdL00f49OYyaUUo2t4o5jF1FvIuDMkFX+C?=
 =?us-ascii?Q?6Ze01XDY3bT34ZCU2KqKcVcio9sPafPNj9MB1ANAnu/NKRsiKBV9C2JV810P?=
 =?us-ascii?Q?2MfhogUeUUa1bcLmG80fGRiTxONrde5zGZxkeOygEL3LuNzRnS290e1OgK/S?=
 =?us-ascii?Q?21wsG+Fxbcov552NkBhWLtzaaYoB3e2mQ9Bm36fmxlfQtRNNFnFtNQf+nXgD?=
 =?us-ascii?Q?TntjmoRn4V4mf0OXilywFIAEVFgTOBHznpbm78OVT3qeWbsLNU3yviQ88+0P?=
 =?us-ascii?Q?QwtTy8GWgXgc7CGO4HDphsSURXZferED/Z5RGuaMPnMkH7S1pWRnAjGUKn7g?=
 =?us-ascii?Q?uWFT2YIHN9CtZvFpzcwMV3A8+QH/eHqtdaxZjDZAJWySO09lzQTqD9q5XjUt?=
 =?us-ascii?Q?mHQQoLSiJt0JWd7qtttVme9CV7IVUb5bU5xtmnqtPSRinwrz6kP7ujAsWgBa?=
 =?us-ascii?Q?hNLQy0VwKnDrnU2tU4vNo/3hbKbXo7gzIbD7/w9cW0jkktIFp6AbQWhaGWMv?=
 =?us-ascii?Q?Fircj43M7BTHsu009FA6d4DbTNyb0mdG/5fhrU2YdCjCijIAfFpTKhCtqZVo?=
 =?us-ascii?Q?zGkmGQtY4gWP0laILr0HOyN5kKoZsctzN6CgYK/RkvoNY4VMIDu3pg1vhwUw?=
 =?us-ascii?Q?qg94Sh9hYIuAnbZn8bChHRqsq1GOAnHLGyi4mLhCh1KyAkq0ycvTX2mhMrLg?=
 =?us-ascii?Q?eXnGGxBb8CBAne+hkA5rqW0WDV9M1nqatGxD2kI3a/C7OE7+x7NgbBEKdHS/?=
 =?us-ascii?Q?dKalV1TJSxw/hDP4HILmvJPSQ2XLP27/CxLghW8BnYSDCDQ77Ytz8jNNL81X?=
 =?us-ascii?Q?itkL1vgFphKoUn3XlERnZDEC45SqanU1tvecQW+YHwE18pe1mRAv6PGbLs0j?=
 =?us-ascii?Q?A4pr4Kgj8/Uo0LrJp6yF++UXfwQ/TkjArCjTK+0MXRlEgALWud7ebqYZkzb5?=
 =?us-ascii?Q?Y2t8YJ0entQTNUGfkoD9h1eEo3OpE3s4ZIn7lHPW?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 02c171b4-3cfb-442e-7bac-08de0fe4ee4c
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Oct 2025 14:28:26.0572
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Fe/Jpn1Ze2a7nSED+vU3Mf385smB2B6L9upOoS1ZLC2wLFGTR/D48FuPAQ1ugdL/
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB6827
X-Rspam-User: 
X-Stat-Signature: wiwbp8i6a9iqjpwawk5hnsnn1tdch75q
X-Rspamd-Queue-Id: 36C91140011
X-Rspamd-Server: rspam09
X-HE-Tag: 1760970513-538560
X-HE-Meta: U2FsdGVkX18izeXsgUmF+5DnBnw3qFJ12zZBBR48cLPYPjebNXbp70AEoY5I+jOKJRY1nBFpTGnXBL7yYmdOW61CoZAaOALYh3mFYFdtbE1KbYuQxoPlkasjvSrFH7VFlFS1bdi0N1XL7cp+nSBGlLkN9znD2Pdo18uSdt3Gl5wk3YcdlM3efSFe26pFoUeXVBHg+v9t2iq8aeDP0ilALtQv4BlQyPhZQfJHr13fMhrXac8Hef3IW1dhV92tMW0rrOBAsdOvmLB0lAraaBEtNu50Eu+ijrQGiZe1ppeicB12KdaECLtx4hvPeYRry6t0m/TCuxoN40TVGdqz3ciyZnAhH7uwKPUBOk4zrJqwOkcDGA7gHpFRo3XVD89rnfIHvd3vLAIr7BKi9SKF4RsYPuGyiabXEJruuaZ9ZWE6cWAVvdyBVw3h4zvKY2c5CbVp7gGL/VG0T3nRnodWfIuba4xn51+XVJtowy/Oszlyl00CzXRkJyZY+Z7LdgUIXAIor51ZoNJXD3VpF3DTIq/uoxCjD7xAE8XMjsKqGOuI8X19c7WPqXkPK/GR1XTNmGQIWWy8gbtqrgm6VzPbsRJJdRyg+nvultonA8omH3hvhZpsYUPl3s3h1dX+BbhhS0W6gG0m7PN6pJ+8LIsodnlBqsuj5dO7ETV13uuEcBZpmdPbR8PpTwwcEd4+5mHYqb1KSP9jRCKxYl7SujXRzoc9I9FUu/VtFxFnKskSEqHmJNMaxva+yf/XO+S7q0NYH10tJ19ilOAURwLouUROb6Q+4oixwZnNwyy2GRpwwwVcVjCXx+a9fo2D3DBrzewkGc2v7wsY+zhm0HgR7ryqkM1MFA69u1gyLcel0rBHfge+8woeZeWLC4Uo304ua/4SwcssV6x+g8mHzJcHiq8LRWDw2CVaepCwO5aarrxLsBJtciDh6N56TCxY3xRc89vkJ2k0+DETsJA2hVA+pX+0iNB
 TbOR9uHH
 a/mnk1YFBFRVgfCymwJJ90TX0jgfBn57FeFZtiKQTeRQ9X+QiuH9F1/LaXjjTizKGNMOzR10jDIIefj7H+6C28LTGYkxE6P4p0fpmAOR/npC3xnPGF4CZjr6OwSZPvlPZjaYlOE67qlWVh9j8HcHfNncwzgFX38QsbeVr08emYt6djo3/vNJCzwlgCxaf6UjyKGp5Smgi/xzOIkKAFpk+qTVD/MsARkpq0NyYFwtqOVML03ESRXZ5iB/zdwOxipYjht0I8DBZwqm2iem8Sn4lm5IWfmV+bWy4uOcgsrdYOI+k3aIwxgvKlrM7bEkUiPpc2DVdaUNkpcvmKd2ZemTCecqPTvl0OxqBFzYKwA1LqmLLyJOdceQoYni+ndc6nQWmDiwKknz48jT9yxEyc1igCUV050xgdboatNl7e680iL42erepEvNeCn1PJr5lRE1mnCQMyRTedf32DTJDvRDNls9W6Q8rG31RKJwpJdSGTL/TkKQ+NJcKFpHLxl9xjJlQkAI4J2xN7CHqANUgmn8REUuG8XoZFJz+11QHSNkWFbhTcbXD8eWNAtHe+vA5Sha+V+LKW/S7XrIJt0hUkVFTO6RK7w==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 20 Oct 2025, at 10:03, Lorenzo Stoakes wrote:

> On Fri, Oct 17, 2025 at 01:24:37PM -0400, Zi Yan wrote:
>> Let me explain the changes in details below, so that we might find a
>> good way of splitting it up for an easy review:
>
> Thanks, much appreciated!
>
> Looking through it seems to me there should be 3 patches:
>
> - Getting rid of the trailing loop
> - Stats fixups
> - Remaining trivial cleanups
>
> Do you agree?

Sounds good to me. Thanks for taking a look. Let's see how Wei feels abou=
t this.

>
> Each can have a commit message that describes in detail what's happenin=
g
> and why it's ok.
>
> This is also useful for bisection purposes.
>
>>
>>> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
>>> index 4b2d5a7e5c8e..68e851f5fcb2 100644
>>> --- a/mm/huge_memory.c
>>> +++ b/mm/huge_memory.c
>>> @@ -3528,15 +3528,9 @@ static int __split_unmapped_folio(struct folio=
 *folio, int new_order,
>>>  		struct address_space *mapping, bool uniform_split)
>>>  {
>>>  	bool is_anon =3D folio_test_anon(folio);
>>> -	int order =3D folio_order(folio);
>>> -	int start_order =3D uniform_split ? new_order : order - 1;
>>> -	bool stop_split =3D false;
>>> -	struct folio *next;
>>> +	int old_order =3D folio_order(folio);
>>> +	int start_order =3D uniform_split ? new_order : old_order - 1;
>>>  	int split_order;
>>> -	int ret =3D 0;
>>
>> These remove unused variables and do a order->old_order rename.
>>
>>> -
>>> -	if (is_anon)
>>> -		mod_mthp_stat(order, MTHP_STAT_NR_ANON, -1);
>>
>> In the original __split_unmapped_folio() implementation, I probably
>> moved the stats in split_huge_page_to_list_to_order() (now __folio_spl=
it())[1]
>> in to __split_unmapped_folio() and needed to handle xas_try_split() fa=
ilures,
>> so left mod_mthp_stat(order, ..., -1) here. It should have been put
>> together with mod_mthp_stat(new_order, ..., 1 << (order - new_order).
>>
>> [1] https://elixir.bootlin.com/linux/v6.13/source/mm/huge_memory.c#L36=
22
>>
>>>
>>>  	folio_clear_has_hwpoisoned(folio);
>>>
>>> @@ -3545,17 +3539,13 @@ static int __split_unmapped_folio(struct foli=
o *folio, int new_order,
>>>  	 * folio is split to new_order directly.
>>>  	 */
>>>  	for (split_order =3D start_order;
>>> -	     split_order >=3D new_order && !stop_split;
>>> +	     split_order >=3D new_order;
>>
>> stop_split was used to handle xas_try_split() failure, since the stats=
 separation
>> I had in the initial code, I needed to add the -1 stats back. Now with=
 Wei's
>> change, subtracting old folio and increment new folios are done togeth=
er,
>> stop_split is no longer needed.
>>
>>>  	     split_order--) {
>>> -		struct folio *end_folio =3D folio_next(folio);
>>> -		int old_order =3D folio_order(folio);
>>> -		struct folio *new_folio;
>>> +		int nr_new_folios =3D 1UL << (old_order - split_order);
>>
>> stats for counting new after-split folios.
>>
>>>
>>>  		/* order-1 anonymous folio is not supported */
>>>  		if (is_anon && split_order =3D=3D 1)
>>>  			continue;
>>> -		if (uniform_split && split_order !=3D new_order)
>>> -			continue;
>>
>> split_order is always new_order when uniform_split is true, so it is u=
seless
>> code.
>>
>>>
>>>  		if (mapping) {
>>>  			/*
>>> @@ -3568,49 +3558,31 @@ static int __split_unmapped_folio(struct foli=
o *folio, int new_order,
>>>  			else {
>>>  				xas_set_order(xas, folio->index, split_order);
>>>  				xas_try_split(xas, folio, old_order);
>>> -				if (xas_error(xas)) {
>>> -					ret =3D xas_error(xas);
>>> -					stop_split =3D true;
>>> -				}
>>> +				if (xas_error(xas))
>>> +					return xas_error(xas);
>>
>> xas_error() was not returned immediately because the -1 for old folio =
needed
>> to be fixed later. Now since the stats is not changed upfront, it can =
simply
>> return.
>>
>>
>>>  			}
>>>  		}
>>>
>>> -		if (!stop_split) {
>>> -			folio_split_memcg_refs(folio, old_order, split_order);
>>> -			split_page_owner(&folio->page, old_order, split_order);
>>> -			pgalloc_tag_split(folio, old_order, split_order);
>>> +		folio_split_memcg_refs(folio, old_order, split_order);
>>> +		split_page_owner(&folio->page, old_order, split_order);
>>> +		pgalloc_tag_split(folio, old_order, split_order);
>>> +		__split_folio_to_order(folio, old_order, split_order);
>>>
>>> -			__split_folio_to_order(folio, old_order, split_order);
>>
>> No more stop_split, so all these are unconditional.
>>
>>> +		if (is_anon) {
>>> +			mod_mthp_stat(old_order, MTHP_STAT_NR_ANON, -1);
>>> +			mod_mthp_stat(split_order, MTHP_STAT_NR_ANON, nr_new_folios);
>>>  		}
>>
>> Update the stats when the actual split is done, much better than
>> the original one, which assumes the split would happen and recovers
>> when it does not.
>>
>>>
>>>  		/*
>>> -		 * Iterate through after-split folios and update folio stats.
>>> -		 * But in buddy allocator like split, the folio
>>> -		 * containing the specified page is skipped until its order
>>> -		 * is new_order, since the folio will be worked on in next
>>> -		 * iteration.
>>> +		 * For uniform split, we have finished the job.
>>> +		 * For non-uniform split, we assign folio to the one the one
>>> +		 * containing @split_at and assign @old_order to @split_order.
>>>  		 */
>>> -		for (new_folio =3D folio; new_folio !=3D end_folio; new_folio =3D =
next) {
>>> -			next =3D folio_next(new_folio);
>>> -			/*
>>> -			 * for buddy allocator like split, new_folio containing
>>> -			 * @split_at page could be split again, thus do not
>>> -			 * change stats yet. Wait until new_folio's order is
>>> -			 * @new_order or stop_split is set to true by the above
>>> -			 * xas_split() failure.
>>> -			 */
>>> -			if (new_folio =3D=3D page_folio(split_at)) {
>>> -				folio =3D new_folio;
>>> -				if (split_order !=3D new_order && !stop_split)
>>> -					continue;
>>> -			}
>>> -			if (is_anon)
>>> -				mod_mthp_stat(folio_order(new_folio),
>>> -					      MTHP_STAT_NR_ANON, 1);
>>> -		}
>>
>> This loop was needed to update after-split folios in the xarray and un=
freeze
>> folios, but since last refactor, neither is here. And the stats update=
 can
>> be done in one shot instead of the originally one by one method. So
>> this hunk can be removed completely.
>
> Which refactor in particular? This is the bit that really needs separat=
ing as
> it's the most confusing and begs the question 'why can we avoid doing t=
his'?
>

Patch 1(https://lore.kernel.org/linux-mm/20250718183720.4054515-2-ziy@nvi=
dia.com/) in the __folio_split() clean up series.

>>
>>> +		folio =3D page_folio(split_at);
>>> +		old_order =3D split_order;
>>
>> These two are for non-uniform split, where the code moves to split nex=
t
>> folio after it splits the current one into half. And the old_order nee=
ds
>> to be updated, since the folio has been split.
>>
>> For uniform split, the for loop is done once, these two effectively do=
es
>> nothing, since the for loop ends.
>>
>>>  	}
>>>
>>> -	return ret;
>>> +	return 0;
>>
>> xas_try_split() failure is handled above, code should always succeed a=
t this
>> point.
>>
>>>  }
>>>
>>>  bool non_uniform_split_supported(struct folio *folio, unsigned int n=
ew_order,
>>
>> --
>> Best Regards,
>> Yan, Zi
>>


--
Best Regards,
Yan, Zi

