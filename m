Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9992CCEE343
	for <linux-mm@archiver.kernel.org>; Tue, 18 Nov 2025 18:55:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A1EAD6B0028; Tue, 18 Nov 2025 13:55:27 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9CE9C6B008C; Tue, 18 Nov 2025 13:55:27 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 896976B00A2; Tue, 18 Nov 2025 13:55:27 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 7462A6B0028
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 13:55:27 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 2FA1914014F
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 18:55:27 +0000 (UTC)
X-FDA: 84124631094.05.7AB4304
Received: from DM5PR21CU001.outbound.protection.outlook.com (mail-centralusazon11011062.outbound.protection.outlook.com [52.101.62.62])
	by imf26.hostedemail.com (Postfix) with ESMTP id 7830114000A
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 18:55:24 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=pFXulJ5m;
	spf=pass (imf26.hostedemail.com: domain of ziy@nvidia.com designates 52.101.62.62 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763492124;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hy65ImgrCyxvK1kIBNnjyQXfqiCaTY8SLXhEsUjj+Mw=;
	b=vvTNeJDzqO3KpEZhdQlz5s4SkvzGqkl5F++tnYO17NpR/XfXHz12IB5DslZ44VqCAPs0Uj
	q89S62BeZZh0CNIL1jm9aNmgF7BlOlU1A5YiScHuSZ/ei1+KE760prezd+ZIKZqtNUZfmL
	ndgp81w0z7PwcWJPIx2VctMK+cgHKmY=
ARC-Authentication-Results: i=2;
	imf26.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=pFXulJ5m;
	spf=pass (imf26.hostedemail.com: domain of ziy@nvidia.com designates 52.101.62.62 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1763492124; a=rsa-sha256;
	cv=pass;
	b=RBZq7qKhVaLFkX1B18/rFokA3UnElXqcYl2jd+5jCkvoTfxGPwG29heGTWD1VzJSscEsAb
	L1hnKe2sKukjs6zKisonQvUf+EvqAg73hNVT8yv3WNoYhinLT+RHJddPVjsfgzJnVOUnH7
	w+LR2OBZz24/DQBHIymhfo5G6HyHp30=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Hubri1hr0EkKTUWhPXV4Vj60SahKqaMlAN/cjxeZ3kWLGxeiNyQ8SOdSFrA2UJz2LcVlfq6CDRm4wORhGmnZ+MWNuIbrYzCT/UI//Gcw5WpHuVC1rSA3mWM9++9eG5AdC+KvQ4g1E1eBVRmM0Re48UXTfbEfFcDwESj/wXatAYstg4afCqOQlrqTu/5VfH9Ashab+RCFGb4ZD5iIKssO+HPAfuG7ZsEgtu/y+TqOIYH4ctnCoq/iKxieCHEe3tMrjyyGtvqonHgNVcVmRRR3WCEbHg6beyh5LMCY6EjkcPXV1O/+HeY/idXkgPShUe5KdPw6fgpUUq3p3ANLDhKf4w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hy65ImgrCyxvK1kIBNnjyQXfqiCaTY8SLXhEsUjj+Mw=;
 b=wRO+Rc9Wy4u+y4JeU5dn/T8eH1jT5p+d7kem4+nz+VRsEqfjzVc322H1gDE/AytW8LHQA/ViXkfXMkQQyZzml+xFexrLeJhuQCcYe6agi3MY+/J+kZ7HryfJ0uuH7FNfNNedmFQmMKRMRwbq0/bt9S/Lt75GGSfOm9OFb2yDbTIf5its1S8FAZWUoM0UDPciuTO59kel+69Bu+/5xLg6fqiu7OwlXzhu3sPL6YMpTrh909NGQ82eGrPJjSoMX9faQSGZOEe8A8+37A9IHmf2qZqoz/HuJzXMa3Du1s47lBr49MFZ+jl0ItGdmX+LH4cEhrGaEOJsRtHq1fOuSKa44w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hy65ImgrCyxvK1kIBNnjyQXfqiCaTY8SLXhEsUjj+Mw=;
 b=pFXulJ5mRLs/rU9W3jisUzcORy/kApI5ZrL+q1l0aNVV+v5Jk4jMuS1yeS4Z77pQh1XESipYQjm8TjPUZXZsJ9fEKYiiVLqu71Rn2Y6ctYiou/b1ASA7qmsTbGHxvZcrBLs3NTENvDG4YVEhxfnvPILMQjuhGx9j5GrMuTt86WiUo5T9RimOpjjBBW2et72CfRhjfDONhL8AI6/t5xuzIq9H08PXEq1MtYyD3nwk6R1ZwdH9166fRFtKZvK1WI4QLYZ0++8lXom+SkjHKqagVFn+jjHkWW8RgCi2178dUqT8qPL+BXFcsPPg5VJbfKJzQfw8w4lmtjgwp5Aat+xGMg==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 DM4PR12MB6400.namprd12.prod.outlook.com (2603:10b6:8:b9::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9320.22; Tue, 18 Nov 2025 18:55:18 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a%5]) with mapi id 15.20.9320.021; Tue, 18 Nov 2025
 18:55:18 +0000
From: Zi Yan <ziy@nvidia.com>
To: Andrew Morton <akpm@linux-foundation.org>,
 Wei Yang <richard.weiyang@gmail.com>
Cc: david@kernel.org, lorenzo.stoakes@oracle.com,
 baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com, npache@redhat.com,
 ryan.roberts@arm.com, dev.jain@arm.com, baohua@kernel.org,
 lance.yang@linux.dev, linux-mm@kvack.org
Subject: Re: [Patch v3 2/2] mm/huge_memory: merge uniform_split_supported()
 and non_uniform_split_supported()
Date: Tue, 18 Nov 2025 13:55:15 -0500
X-Mailer: MailMate (2.0r6290)
Message-ID: <2AD36673-231C-41B9-905D-35BAB4CF63D2@nvidia.com>
In-Reply-To: <20251118103220.bd90932096d4e36f754de21b@linux-foundation.org>
References: <20251106034155.21398-1-richard.weiyang@gmail.com>
 <20251106034155.21398-3-richard.weiyang@gmail.com>
 <20251117012239.lqm33uu4vl4y5zqc@master>
 <337CD281-F5B3-47FE-82C3-ECB236450F60@nvidia.com>
 <20251118033339.7rukw7vvjvlbj5jb@master>
 <51358ABE-B0BE-48E1-95E3-C778D1F44622@nvidia.com>
 <20251118103220.bd90932096d4e36f754de21b@linux-foundation.org>
Content-Type: text/plain
X-ClientProxiedBy: MN0P223CA0028.NAMP223.PROD.OUTLOOK.COM
 (2603:10b6:208:52b::17) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|DM4PR12MB6400:EE_
X-MS-Office365-Filtering-Correlation-Id: 1e203982-6e07-4a7b-9420-08de26d40470
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?9L7zvY52G/FfWBTwe+dPkh1AeL03rvJqvI5xV6CuQ9zgB7V1Hxm/n2j6cOvS?=
 =?us-ascii?Q?Hn4+SGC/GmAYkK3bdILwqTjP846AznSXXcHoxYTM9mJ2yqgEO1EnZdGtgCQj?=
 =?us-ascii?Q?QmmaT6DFJFSxNEmcq97R79iBRv1pui08IBxbVTmLV9lOIqUbx8OdVtXycNna?=
 =?us-ascii?Q?8ypIISjcwX00EWnY/2kejkoHWhDtotgtq4MfvELSksgkIFPPSj7AdzyHy35u?=
 =?us-ascii?Q?lPxy98E8npnHTMZQhdAtrKRSiqtxiAo9yTKNUPvn9nXRSDl304UBLXrWKTcZ?=
 =?us-ascii?Q?roZMa8dpOQLwwRaQqZmo8904f3EcYGTKkM9mnKOWwms3Jz3espMleIiVe4jQ?=
 =?us-ascii?Q?sqsz2oqCVxyenH6pAS/VABvLa3r/XKT/2LP+XzODkm8YLlI4MF0hRODFQ5IM?=
 =?us-ascii?Q?ZfP/ai2lnEk/nnSmO/GsyTJBEVnLB3qMREdewxr0uggPA7aGI1FZgaRFmha2?=
 =?us-ascii?Q?62fgb0wQHagEWvUbboTaUNDwmnuZFvO1u9dd+FrnOTtn8O1eEpKnCIZ7LyEC?=
 =?us-ascii?Q?gRzRXmsdZOxXOh/2CKhZsYC0/DnCY0spZjp3ifaRDMkJ1qgHEjKHQ/syMWDj?=
 =?us-ascii?Q?6YjFB+DX43tnBz2m9NnRs+GIgfjJUdlq+dUzmtw1iYYgz06KY5u5aOua8ura?=
 =?us-ascii?Q?9i90gXWU1sPhFQhiGQ5kEl6GtdYjb8reIrrDU4N/Pbw5QhZLJuLk5LS6MTIa?=
 =?us-ascii?Q?Qx823JRBWdURx29mvRwF0mCPK/HgOhewng+1NEkjk54bGNkFp231fk8uiOxL?=
 =?us-ascii?Q?sze0fTrXSukCMA7lDkM9Z1CSXrP/t7KpL7fb7w9foJiSiyTn8CLtEHz6OIF7?=
 =?us-ascii?Q?KEsT5yM+2VOilMj79tlg58xMCYZ5Op+dq3O5nUpXw6Fx2ObDzmEzHvgWl3Jv?=
 =?us-ascii?Q?hrWM8kMN39xdBr+TLKV3qSwffidFxh3VLwxHiSKUdBxNCpXkYoWadHfp3z2q?=
 =?us-ascii?Q?2SaRU04DC8qIniIj2lYVWtREtIq8wgPy+Se9ZLsek/En8bZAopOqiSLMkr2P?=
 =?us-ascii?Q?3zbebHAnuzyxp+DHw8ZwyoD8scOykqvgr2beBiCid1PA0E3UUw9uhSXf2oEX?=
 =?us-ascii?Q?Aj6JI2gbKJxM0PQjFctc+1c2/1FuyfBNX08SIr1az5hjitbRCLqhmom0TCkq?=
 =?us-ascii?Q?Y7XHJNiqcrVwDIAmgBfZ79SuFJQDcWfPIY1sZIi4sj91cFJDZRwIiMt4MqCS?=
 =?us-ascii?Q?N8nKyY7LpaLZFcGyJ7M6l5e0QPJE7cw9MWAy62C9b3JfRqotqmW4010kVtbr?=
 =?us-ascii?Q?sW5bdB56DEJzaY2lLh7BOZ9r4MYl/HP4Ns2qErbgUhEUwLVrx1yZxAqXBWut?=
 =?us-ascii?Q?2CkZZnPpCn9Um3ehrhT2lXMrO2JxexDHFuurCEFaxzUkC16i5VPdEoN84+pZ?=
 =?us-ascii?Q?IuJ66oCUaDFGVIr5+h059tA4ERmZzETQJlRwRvzxg8DXJVs5SuMU8kvmFnk/?=
 =?us-ascii?Q?lFa0BvrW6jsg1CPzUDUkjRW/hmHpbjfS?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?B/S87Y/PAS0JqpAxz0SZrhxIXe40t250ftKVI4cvSj3KaVB5en4yqk0Gemlq?=
 =?us-ascii?Q?ZJ5eKjHVUM9R3ex3rb24pW8tjjarcVUdz7MZ+QFxUG25sKgDtC2mXPzX/g3h?=
 =?us-ascii?Q?D1hAxmHG+dFkQAMGzxrSeuLxQWlQ08pNnDOR1GQ8K7R/bIiH7Aa9Y1GYLtp3?=
 =?us-ascii?Q?vtUGh6ROw1Jnh5kIR1Qb62lC6j9Z/IqX9PbJyMV9/gLhSaY/VN/p+j64Lr3n?=
 =?us-ascii?Q?jfoR1RLwy64fomnU00WqOeBT2jxbYc4SL10aq+vbS4RrbS8IzlS4VldG9Jh1?=
 =?us-ascii?Q?5YV0Y/TR3aXu2x1umOm3RoVV4/tTZp1fdbs/b38AjLornu2Pv9Xc3fgJ6jIe?=
 =?us-ascii?Q?jDHWWeKmG4PHzbQT3kZLmU2PXFEpWFCUfM+3P82WyuBMpw3VbWD2Os+xsAo5?=
 =?us-ascii?Q?FqIGVuNHDvXWf/iQ0EKGa7fX3eactsJBz7vQCeQlbNPacR5ERcbaDYVqQn+C?=
 =?us-ascii?Q?MENSsMcDrzkZVMgpvs/E5SrRDovyHAyoh9qhME41bzwKmANV5vv6MisVZsUT?=
 =?us-ascii?Q?WVMtRmu3OvZVQY07k8tKuzdkwdRZWiN1VAZRX5XcCavcjZ5Njz6/iumOeNW7?=
 =?us-ascii?Q?+T0gsQJjvTsKX8fwGnRgyTqB51R+MLXSEQ9cbyxLOpEx/NvdTYZeFdTV7MP5?=
 =?us-ascii?Q?6R/n+zyc94GgrmQSbcK1mjdgYtn49nlen8SkeoX40gYHTUEEE0TWPQp9gU6x?=
 =?us-ascii?Q?L6YXmC05k0DHNFoso6dkQ7XKh9tQRyV6AWjV818T90sNwWwMLCzX11gJn5rF?=
 =?us-ascii?Q?mLdPSncQdmC1rIhstPewPw7ZKbMZ8C7fzYcMny/xERH0l89fclX+YAnnO56r?=
 =?us-ascii?Q?ExEX2MTy2I7yoAMWxTXcO0MoGBH9o62Qs1EbCim9+9di6HnRmyxqxKGj7QIX?=
 =?us-ascii?Q?OWfpmb8R24MO4Hw9dk7yC91+heiP+EQ2vK/xwqGD0xOQyzyYwBmoYzCpSbkS?=
 =?us-ascii?Q?RAivvnS7dZWMeXzfa9ejSZaJUCEHSG4huPmwL4C6XJR7P82s2BGRu0x9aAmJ?=
 =?us-ascii?Q?oSPzPlwwxgnIXf0NysgDZhZDNuTWqI68Tlwm13ws1uRnZv7BaIm7qAd8ZvlT?=
 =?us-ascii?Q?wIL8b7wZ3T3ELDryLYXHxsdVuXtb3WBhF40WbjZvyxjPQMXdg0YHusTpCsHH?=
 =?us-ascii?Q?S5jS9GAkvNZWPdkQQkqF7jf8UC4kxwCdeC1HGawr/RFQ6Nb4igVVTfvcZLmh?=
 =?us-ascii?Q?cw9zBlttzD4Bxge+xJBBzEI3vVb+5mr+nvEuKTVcR0gHda93NIpWsqt90wgJ?=
 =?us-ascii?Q?Z+ba01s4B3DN35/ZA9vNLEH6XWzyfrYnsGQdOF7dps4IdD6Mx6MVpdI9AF49?=
 =?us-ascii?Q?VLlehdjF0jNjGaHYVSAIyuCeUdGUSpvljAdRnE8cIa9A9rbQ0tgNVq66aK2D?=
 =?us-ascii?Q?cVjauAqmRRtbQXoRnFGCXxD5ffWTA4DlEO0aR57BUNvjU3rdrKVEkhD0KjAx?=
 =?us-ascii?Q?cgJh6c14FiE006VmtSLqvhG9C3gZ5aZ4RV1eZ0QIXvM8NomBaopuXzZxop+a?=
 =?us-ascii?Q?PcOFWAgMSwdZBDTMDqIk9bQJ4GwiJkoqfVh+DWkiIAlW9Xzo6Z2pQbzmqiBS?=
 =?us-ascii?Q?mlT1xuTPd5OD1LnPRgOYls2r24DW6zt+jb16xUlr?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1e203982-6e07-4a7b-9420-08de26d40470
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Nov 2025 18:55:18.4286
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tjfwrqh5kfV31kkhgchiSk/i62kWNcKGPZFa1T1s5gdXNZ5H1ppNqD4IxPmGSWFK
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB6400
X-Rspamd-Queue-Id: 7830114000A
X-Stat-Signature: rs41xbq8y8u7gc53pxtrnnphmabtkugj
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1763492124-4969
X-HE-Meta: U2FsdGVkX1+fItmKK5quCVGftuZGF/ZkBIr4RzH4mJSoLzz4NxYm1RSKYE9MlFCKy+QzmL+bvfkIRNFfDP2Ap0HhE8fwBt/7ed5Di2tIw+/vvfRKynsBbY0L9U4huU9ZEWw/JB/cq/L4kAtvKspAWTwHCI5v6hlqZ3RyM+M7lr7EARXi9LSujZTvyXdejpuhSdOm8bKC3yy+Q2E9/2dDU/UukM9AiQ56My3E/CUazOkQ22PEKla1TDl90f+SMWJOTi3oTc4otgkTmhA4tj7QWrxtrQLU2QAiYB+T5BCOwfbOQ/ibuqu5WyBxbToq6lPBk7rNR49f+PfKO9xDFPQdtCMz49IIxPHHHp6J+4g35y80KyAnfW0DJFbkHWGbuN259vjpASfTLsRuCizd3iCSdBcJMgotYIskAcX9rfgT16ZMaXF8ax5KwJWTvGWzPt6FAPFMiE6PRmM8FKYHGEqxTokn3c2yiG/dIAqre4GluVkqq2oGET5srfwqNGWvtq53O6D/AQ6ujNmzSTDJyHBqTRSkn/Hl4kOuK4rMsHd4EiwWiKv1CJt8BuH/dmZ0jF+9CxfDc2YiFncReHvHMyyr0Pz4p7l/0Q+JPxutYrjjHtJ4pQzM6gH53JWHwqwD/OUTOJ8omzdBqWSCIvraAogOq2S7Vdm9yyHLBLKCcdprMa+1WbSeFXDJOKSgo0mnv1vwotUzGeCHCC5GXworEaIyWP8yRRoLNb+AcaJxUeuzuNb44RzfA0QJMSu0tj75IS1hTSFgqnvW4bMhk6kh2Lel4qUEf7e7zRHRXIG+JNk7zIQ8fw7MJaHHvLuzkQ1+SjBwJ6RmcztNuFVo77HD8gonLdrriwoE4i5uz8WiSiViyk5JnwRfyXhOlIDOnf0o8OwgIERKbzrexs91DuNAZvksVY9BQmLR0zN4xqP5cFFO/p1F3tkWm5gv2U+K+M0om/OfxgzCBOaBSJ0mvaWHmwq
 N+ln4YDE
 T8nznfX+5ilVPiMOAELqbuQ4bKhitint9EwGc4/9ZIZHU9GbQSqGvG3BabFklKbzjZawgsOowFiGuQHeNjt2ODpzg5FIH94fPHi3a4Sr7dDRDB6RS2LxhN58OE78KRaXx7mfdc11k5AF1hWdYBnh78Sm73ieybea4bmXIOKc56jz/HEQe1a2u9K1+PjWNQmHFL/Lnk60d4Bc1QQ+R74/4W2tVeJwKjAhy9PlBE73G9GEoCEvk5WbtcYqX0FBP6XlfJ6XeZsvaWSBZpZs+abJuUE5HXFR8sFQVgYFZBaGeEdCf5Egz+CThbHH9msW4sY70RtP/vyGqn+IDyRj+YfVvfdBV/kg+yPoRcoFp3sldkUnktcA2ac/pQte/IfLkqq7s1zKLlXh2aeKV3fAIyKPkdj0IrIwVyo7oyOwGF0YhuF0VAVKq9JYIEaeh2EQWmAK3A9g1cRsmS34MDObwyoYWHwn05kyQnGLbTFKp3tgFLUPNgTM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 18 Nov 2025, at 13:32, Andrew Morton wrote:

> On Mon, 17 Nov 2025 23:10:26 -0500 Zi Yan <ziy@nvidia.com> wrote:
>
>>> [4] commit 58729c04cf1092b87aeef0bf0998c9e2e4771133 (HEAD -> tmp)
>>>     Author: Zi Yan <ziy@nvidia.com>
>>>     Date:   Fri Mar 7 12:39:57 2025 -0500
>>>
>>>         mm/huge_memory: add buddy allocator like (non-uniform) folio_split()
>>>
>>> So I think the fix tag should be [1], right?
>>
>> I think so.
>>
>>>
>>> And do we need cc stable?
>>
>> Yes, please.
>
> I added:
>
> Fixes: c010d47f107f ("mm: thp: split huge page to any lower order pages")
> Cc: <stable@vger.kernel.org>

Hi Andrew,

This patch does not fix the NULL dereferencing issue yet. Wei is going to
1. send a patch to fix the bug on top of mm-stable,
2. resend this patchset on top of the fix in 1.

This might be easier for back porting the fix. Maybe you can drop this series
for now.

Wei, do you agree?


Best Regards,
Yan, Zi

