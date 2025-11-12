Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 63599CD1297
	for <linux-mm@archiver.kernel.org>; Wed, 12 Nov 2025 15:53:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BC76F8E0013; Wed, 12 Nov 2025 10:53:58 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B76F38E0002; Wed, 12 Nov 2025 10:53:58 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A3F2C8E0013; Wed, 12 Nov 2025 10:53:58 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8C8808E0002
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 10:53:58 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 65B60B9ED9
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 15:53:58 +0000 (UTC)
X-FDA: 84102400956.01.851FDC7
Received: from CH5PR02CU005.outbound.protection.outlook.com (mail-northcentralusazon11012042.outbound.protection.outlook.com [40.107.200.42])
	by imf06.hostedemail.com (Postfix) with ESMTP id 7F846180005
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 15:53:53 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=e3RxeN5G;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf06.hostedemail.com: domain of ziy@nvidia.com designates 40.107.200.42 as permitted sender) smtp.mailfrom=ziy@nvidia.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1762962835; a=rsa-sha256;
	cv=pass;
	b=MfHdjK1lxs455949AewoffntJ3+gG30gcFtnmwtu0Y69KVFrGXsAE16qprf/IhFQGF1z5+
	OKgEGas2Pd2jj0ZEjjzPQ17BbYkn+aJLmTqklKtByNnzpYWMdstLfPapkZQrZIRCs+EfHc
	WaE71jsrI2N2sG0zMKWKC1+va8Hz9vc=
ARC-Authentication-Results: i=2;
	imf06.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=e3RxeN5G;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf06.hostedemail.com: domain of ziy@nvidia.com designates 40.107.200.42 as permitted sender) smtp.mailfrom=ziy@nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762962835;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ca3hRu4LaVwRgVw0AHdna1G0KgIaAq41re81qxHvPs4=;
	b=rZJ+TVAcCILODtAQfGHusCu14ovAUv8GUdGShhDbrvv9ik/Zakg9XmgyQkT9Bn3gXBo1tk
	8J3BfKuuPVZ/JqKh+ucN3NJmaTX6Lygbm1OKlLZAybqiGfbV7MVMM+jz+21wxtF2pCNI5K
	Ql1b/czhXr/JQzuTSoDsCCtYywW8Vnk=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=bflZWXhTDetwozmRB/xLDPu/BOfObVfKF8Sz7tC8HlZHu97YAqIrTIq/2CLooOHhxWQMT3woIi+w0MhsKjzB5I25zUvqnHLsu4f41KCBwXy8LZBg50JhzOeqKtjhfro0QuEURkFwYchyHdju3vh03bifR3FdGF7twY3XE5V/wT3RrX/CkcdkjBE6hfZdyxxupN/QwWDCDP1qnXlU6ktCfSN6MkobZjDIwcvC41BKodz3+V+X23Db4Zo/KXT6Vq9fdKbiBuv3Ngwq+nRWe0PDPuffLgm29cu0Yd7j127McKNzdhA2VyeywJb2dYEuWgSgBllkPAnd+2kZ0zrxr+MTCA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ca3hRu4LaVwRgVw0AHdna1G0KgIaAq41re81qxHvPs4=;
 b=KUwKCvq3aHx8RxxHbvXQzugAPR7g61CIIqC8Bzc4EUAgNN4w9eU3K2mXCl21VLWCjEi7Zfh77o/xLVz0RZxZzUyK7J9i/PXVZr93k2yRELUVYu0g85nYkLeTnmtSXb5N+UkNjx5GyPKMURKvzwWxmIR2PHPWBAUgLPiRLlWxVKqdPmUcFqdLwCZbXU4Uuk31vXbMLmzZ5Q7/9EwkktbFAQt+Hb2pP4H3va2WnC6320OOljMQj/E+QisLq7FdW2zm0PrZ8+ZPEUChclGftFMo61/RMHz4MixLfQelkAAseIDkxJ0uPYCqNLUl4YDDU+TvHrdZAILR3hyLi4xt+gwvow==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ca3hRu4LaVwRgVw0AHdna1G0KgIaAq41re81qxHvPs4=;
 b=e3RxeN5GFJAB4yhiHacXbRXqJNGFSYMdrYf7/9eJhTFsnTxATOzroOu68SM3jCgoi+ERYQxjlfJJxYPyrBv2V55bz4E62GE0naFOYrECuHoUu+/GICmcybGYNuyoULyv5aIMjjb2Docsj1Iwlw46JVmNnImrNdzBqJXmKB7VHF/6K+fnuMtZ/CFc3ktMTjXQQvfxdVNWYcU1xLJtPwvrbEtYdE+EpLHoPB/7jGG2SNVbxU85H0hIq1wPQROd7GlVeqYP3MmIXQz8K+ftgPaPQwVEwFlqgwzswQdLZDr4/eZIwA3olyG8KiWw8UgkBbp7C20MDfv4BrCMMiWjbhK0+Q==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 CH3PR12MB9315.namprd12.prod.outlook.com (2603:10b6:610:1cf::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9298.16; Wed, 12 Nov
 2025 15:53:47 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a%5]) with mapi id 15.20.9320.013; Wed, 12 Nov 2025
 15:53:46 +0000
From: Zi Yan <ziy@nvidia.com>
To: Huang Ying <ying.huang@linux.alibaba.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
 Barry Song <baohua@kernel.org>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Vlastimil Babka <vbabka@suse.cz>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 Yang Shi <yang@os.amperecomputing.com>,
 "Christoph Lameter (Ampere)" <cl@gentwo.org>, Dev Jain <dev.jain@arm.com>,
 Anshuman Khandual <anshuman.khandual@arm.com>,
 Kefeng Wang <wangkefeng.wang@huawei.com>,
 Kevin Brodsky <kevin.brodsky@arm.com>,
 Yin Fengwei <fengwei_yin@linux.alibaba.com>,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org
Subject: Re: [PATCH -v5 2/2] arm64, tlbflush: don't TLBI broadcast if page
 reused in write fault
Date: Wed, 12 Nov 2025 10:53:44 -0500
X-Mailer: MailMate (2.0r6283)
Message-ID: <6B091BFD-FAF1-4A41-91B9-7C55CD2FDFD6@nvidia.com>
In-Reply-To: <20251112013822.54334-3-ying.huang@linux.alibaba.com>
References: <20251112013822.54334-1-ying.huang@linux.alibaba.com>
 <20251112013822.54334-3-ying.huang@linux.alibaba.com>
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: BL1PR13CA0191.namprd13.prod.outlook.com
 (2603:10b6:208:2be::16) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|CH3PR12MB9315:EE_
X-MS-Office365-Filtering-Correlation-Id: edec41f6-1d18-4b1b-3af8-08de2203aa04
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?vvTX598hnY6JV4qP9iVYfccq55+R1JUhP2zbKRLq8h5VycK3MOZBnIjEvujw?=
 =?us-ascii?Q?IT3xK6h8GkjN7CxzmL4tq9lsm7Quk+51UI9WAYHENDAYJh/0Evivjj/l4PT0?=
 =?us-ascii?Q?ApoCZPB6Xcg/aI+Z8a89Y8Cr+ElT6QdaIg/rMMXB8ldO987z40kZficUGF+K?=
 =?us-ascii?Q?1WC/PlCxXwaSaQWAZ+UsyNmguOR0Mkzx3CjshyjDjORF59xADZSOdJOLGcIO?=
 =?us-ascii?Q?jmLKH/CGgIZk1MO9+kBZgI5E2jKGOdtfmtuAuvjOGCpRNnLCuL0gB3hE4OHQ?=
 =?us-ascii?Q?6vHrafglCgLuSf3mEWBgJEs6JK4GHor2PqI2tZ0Us1nU3fyqdVyIZlYfn8A4?=
 =?us-ascii?Q?waLsumAz5DRsq8dY67O4YBGN05vKrHI4+uVMAwFg7UhYEwMpjrycxmLtPpLu?=
 =?us-ascii?Q?iT+L0DVY6Y/nfe4UPXM2TQCF7sLVM49P2y7fn/0+UPm98PzgthnCiVVJCDE0?=
 =?us-ascii?Q?q21wByrgjit6klRcYk99nyFkueA2UwUucLoVXHOFSY+s0dP1eSNuj3WRqFlv?=
 =?us-ascii?Q?FpLAkrmFtOGFNDbOqkAMWwDJMn5sTCR4Vain2DuCuhWHidI2gW3EQ2AuigLa?=
 =?us-ascii?Q?6Z3hidaezboOd2Wx9OgUvo6dXNurpAIYk4wodPf3QIDREwd1UWgNa1CS7VhU?=
 =?us-ascii?Q?5c/pnkgmecEKIKSoff+OM26W2P5dbuVg1DaRv5/qd/IhPwgjPB3qQW1e/UjO?=
 =?us-ascii?Q?5709qAvRUR4fe4C+1ctccl3Oh7zb3xmOJsYZaGrKnNIbFpkukqYpaXR+WZIF?=
 =?us-ascii?Q?CQ+a/OL6KApSojlNmuYjmnoOTFp7zDzqbAVvxhQVrqkFw527swb08q/Aaisy?=
 =?us-ascii?Q?COB/Qlnc565OOJKTyht3tXV8EiUg5FfxC06/+y3Quk4SH6eLDjYC32Ce+flA?=
 =?us-ascii?Q?v7u6kG0T36PzmAvdgVqWrVKhlHUfH5MY+aJkrEJYFYaYScD3fzYK21jzOfrg?=
 =?us-ascii?Q?YCGLVuUR0PkZNln96kjuk0iRWqQdw2zPy08ueq7SJIhIJl1zLf6O70S13AQz?=
 =?us-ascii?Q?IgqEhrZd0PJ393uboROk5CU0pc/I9Yg4AA7y+tkFOL2DhT+/h38s9cPqK9K/?=
 =?us-ascii?Q?DmZM9lXmqmnY53tjXPEIVt7KYFzaGj9g0UcOpxdrtuxKsr19LhbLApwOdk1g?=
 =?us-ascii?Q?j89ZW9QW0HHHmDQ2GZ3axPmRrkFbhm9l3KhxqJXt5FAJaRvw5lgUY+GSSnq9?=
 =?us-ascii?Q?4xo+R7d4dxmmBIRR/i99WaVICKNqbo0N2XpIjhPEVGOt4V72RFS1uqPTYqbp?=
 =?us-ascii?Q?413QMKXZhYP/x9sx34n8pOCeDGnE+rdPIkiu4rEbwIfSVzfwQngNEdvTh68n?=
 =?us-ascii?Q?a8PFXJmkqnEpsdPRt60sjBPmYwWUn/AVvA77HVWkAZ9rohLP2cWcRSZB9FPz?=
 =?us-ascii?Q?rEhNlOlYjT9Wn0sRtfb5yVYe//9Wzoqfg4RFFKlO+w7KcBD9epi7E4vwupTD?=
 =?us-ascii?Q?rLvVHZQNeYTfidw0La+OB2UR3V3QoURsgn7RRKYOuItH0bqw7+UyUg=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?mxCTvU74FA+qVlQCwyVWDJag12EUFxYjZIHlO5BKnbgoDfpp5ke5v6xda3Sy?=
 =?us-ascii?Q?B1oa24uY7UTd8KaAfyaVod1GesZ7fHXk+SRJdNHYd5yONiRU9z4NHP6e1HjF?=
 =?us-ascii?Q?YsWv4DNzVqXJNT7PE3gxhp3jSDbCfOaHvZsJ56mCW0SLilDguiETn+6S7tfM?=
 =?us-ascii?Q?/E1rfBXc/3QS3/08T0e3VWd0/SqGo16qCzaF1FlGaYB+TglELKbbb7I31xaY?=
 =?us-ascii?Q?YINkmecqCo8wHdBxv2raNTQSKbFWdN6OVLkQcLXl8Z1MoIWv2YVo+Xs+nIZk?=
 =?us-ascii?Q?S919mETN79X2EpuOyTnCNzsr5La2Hz0tlDgrh8wICZSpX7t5LMqijPxfryGB?=
 =?us-ascii?Q?gZpPM9+QFotf8czaHlbobj1dmQultQDbcD3kZuzQFm58HMg+BN4cj4zLfw7r?=
 =?us-ascii?Q?PRjU0m9ibHJ0UxW/fKxhzR/fWBrPbHWdjRvqGSxdHBlalYk4puXF4ZqbLHx7?=
 =?us-ascii?Q?FdrH8W+CoWbX8jJMhbnbYSMHanAGV76JhAtUxhmUJx7o4wuFmU4jqlUInIVD?=
 =?us-ascii?Q?SN+whb+gKvCxwp+ZkbAB6a3nzMiQP/FTDAoJ0C7SL20cbJY861L1z3ZekHxo?=
 =?us-ascii?Q?BZ/eDeBFBPf4eMQ5M3vtQks/AgC5P5K8JK/s55aLq+0Djvi3jswoIZmtEAAp?=
 =?us-ascii?Q?SN+HCmc/465kD822dfxFFJ7XORbk+09kLh2DiAn8AzeSuvRPaGqhEg3H2SGi?=
 =?us-ascii?Q?ltHeKueM4M2PooCI8F4OXxt2re1lByMYGHNZyqyRZYUICAq1RZtthBz3/FXD?=
 =?us-ascii?Q?FReVliJsmu384OMBGqPIZ98r505UvYd8e8GzkJdn7WBFdr2xIsRokmC5lq1I?=
 =?us-ascii?Q?qJ+ZrI0KyOLOafhu0y+kZ5kKeOkbC9ZERqM1zfahgzKLYXAjaKkyv8ITa5Wh?=
 =?us-ascii?Q?elkOqpv4S20vP6EOaMlnckw2BmptDrCQgaecHS85ZBWsQnGapIzk8W/bE5az?=
 =?us-ascii?Q?cvXfHg7iQAFhOGaBOpsViZKQMrKtf+bu+mtktx+WnMFQxPLvQkOlp4zWUBiM?=
 =?us-ascii?Q?S5l9SphRgblpyk4kK7v7ov7I5nBT67ZI6XkQUZTIWzgCi4g1OXRov980Qt+v?=
 =?us-ascii?Q?uC7yMDzV6KI4+GPYSYYZdDRoWvSKza4EHSRVRpDSBNWK34rwecNP/GNmGFC/?=
 =?us-ascii?Q?r+Y2iRWn90dQ7oOdIO53VmRwSktCvNV7Eb635gW4OvBrVbIgepRlo4xL5w+z?=
 =?us-ascii?Q?ijiSFfekz9EF49XL3I2PEWtBU2lzk8kvRjK24F55y/1+vWLwAhBxVeI9YABQ?=
 =?us-ascii?Q?yvJG9zAncNlEPmly3YrIMz/KOIe/k8OZpgUzIDbVtByO8X5FHsulByUN+zJX?=
 =?us-ascii?Q?jeEeW4dwA0hIuW85NSEnuj8WGvnbX1Zr280ePJ1ly3UFJjBJ1zzFjvpZjG/N?=
 =?us-ascii?Q?6HIR1/GEGxlpSPOP5FmNK+Nql4534qUJpzZYhZH7cdFKyAGdInQ6nrnJ99Hr?=
 =?us-ascii?Q?xo+JvpVH2v58UN/JFL5LfWwNEyGUT6WCO4+D7z35+OgUvp0QuNUASP19HTRF?=
 =?us-ascii?Q?1NbDOnqjitV0TvTFz/T0VwpbgPcC4Tku57MVPEMcfHY4auEpufapaqYK4lSw?=
 =?us-ascii?Q?ztzOXp9pgFkO9QkJ+LYy0gOAVBb8AIL25icSXq5E?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: edec41f6-1d18-4b1b-3af8-08de2203aa04
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Nov 2025 15:53:46.8557
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: IpuaghQPpGNVkPKFCz9vNZFjDlcUEW7uyTaHSYEBWUjVucKvNXbi3+if7MM6a1RW
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB9315
X-Rspamd-Queue-Id: 7F846180005
X-Rspamd-Server: rspam07
X-Stat-Signature: wspehs6oxgaypqamj53gqwimoa4dy4u5
X-Rspam-User: 
X-HE-Tag: 1762962833-400403
X-HE-Meta: U2FsdGVkX1/aVtCOSEErd/UC4/skIM39eU2IL08TkiUjqfI8AXXhq8I6lYZYnYAivK4NUHJ8k+fBXtP6q2WY1bJxZyC1C9IGVkIqjUt4FqQWnZhujzgnQqkq9rhe2v4TW4slKSUdipWSCxss26IUF3iZ85iAGj+9cC/t0Qg7/KJWCGJ/u7flzpofEJQYd/RN8Dbq4UY4Zykq6dQD0EA9iyUT06WluQMPXEf8tW1upgvKATlXaOvQXBZE2RbkO+t1aAlGISu8WNygIbY42Kv6I9gBi3dGuxBVaOmmA4DQAn7DFfn0NA2kjXJt7INQTjc2/+rl3clzhTGwb8RQH1W1w5b17Wpkl9GvNWmttI6MN7pB14xs/JdEvI/QchPFh8of8cooPFzuIc4+2G0lU94r/zJwIuA8ZUTlt1WTp1oux0vJ1lwrvgrL6uSAmJ/O29PgV6OuTrnm650vW8Lu+qErlv2Yeg9uJqsZjP6kWzqHJ3EJH8hgoTJjbJQMQUYSZlOLxFoO18cSGz8tPHPivi4KfbLtaCakhdAuI0qhXb8wHD7Gmm6b8vaH0FtN+lLK8HONI+tOGNWnaDSm5XTPNdi2CTEuE6LXqbzqoHWcqpxu1SrIXpwB8miax6VIuE28B0KKSKciUaOHPWlnkfs1iIzhuSz4Np1rhzhlSQikRbBuzesfHEGvClGfY4wMfDd4+3wao5NVjGMpu144BXKVWA9AQcPVUBgj2y84Ty03scJ6Al0DrLDfp3s7GypDsrfhAAx7vngJ0mALoNGl8bd59Y/6zvLVSe5PLLXUDzV/x+iAyYLTPKkhX7i/IqzorYbKnqs88bvNDY8jEBVHFQwCsHGxpXdlaePwDhvubnkxAUNjTx38kNsIeqB8xjcOznm0Aug7/DtH8oR3cQ+zvGPFk08R9nuYYvUsn9ClGFPzHw1WXLQSVSobTm0xROog4u/Y3kDgFHzlHDYTlji+4d1N+6r
 C3qGHIuM
 Kp3j641EG1qfDf2BDUq5CdVs8B0jHgbDleP4GaqsPaIo9cF4b+q7vz1R5VMQH8hH7Ub86z3RW2YxGSovaT6jbRJzbKYGu3bAjxikh9ihk59KsYS6SmvQUVRRRzqu6dy2I7Oojvz4nN9kx7r1rRCdZTvIjiTpHq4k7hkVh7KeEmlw0C6aTSd+cE2iAhOpA/1LTUwWTUrXNzitD1S6LcERzDME8a2+/vqG5eIwqLOy5OiOf7QUp//fLIWJth8xyoIqu9fd5xD51vkKVj7uaefznPvnXOgTlXcWOKcGHtNp2mxD93oBblmiSqlpCNaoZmg90wvWqpl8xWSykbPQRgAxth5fMl8VP6G1QNyj2FE8oEg0FaCkeCsHUk0LV7v44xgneeye4Gs2USKGv7TF3uxG9fIQHquNtA5WE0IwFEZA9EG0nZvCNNl2+aFsexh5Yda0teMSmFgQJg5RU/vP0gcHLgc00sktqLqdBnJgPQkyZL0SamnVLnj6/R8CkSlVglycb5DW7rouPSSKm2NtgabSgN+eWVnUDqF60zznRIWcqLlVFAE18RiN5gG6eEs9NDlay4UBTJ58LCasiGIOsdOKhXS0ByxDfsX8gXPplAwouKbAH0myK5NT0Px+7avD16a9mg4TUJQJryULKgjTWvSvwncO7wZ14TiqYwG/y6h0ZgegpyKX9qqAhAE0s2Z/CKtqhUownp3KAiB3SuEW/Y2rAM0Omvg05+3F1XfSLZVvQtvoXGvVZnVJTwzLCFwExf63TA66wOTQe15D3xiiegobPXMWgBBATEIhfTVLmRQtWuaPl5xDeh4BjjvSDiv0QysDldWaIPL80J+swi+hHD4K3vMANlRgKEyhaCb6uGUGirsI+91o=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 11 Nov 2025, at 20:38, Huang Ying wrote:

> A multi-thread customer workload with large memory footprint uses
> fork()/exec() to run some external programs every tens seconds.  When
> running the workload on an arm64 server machine, it's observed that
> quite some CPU cycles are spent in the TLB flushing functions.  While
> running the workload on the x86_64 server machine, it's not.  This
> causes the performance on arm64 to be much worse than that on x86_64.
>
> During the workload running, after fork()/exec() write-protects all
> pages in the parent process, memory writing in the parent process
> will cause a write protection fault.  Then the page fault handler
> will make the PTE/PDE writable if the page can be reused, which is
> almost always true in the workload.  On arm64, to avoid the write
> protection fault on other CPUs, the page fault handler flushes the TLB
> globally with TLBI broadcast after changing the PTE/PDE.  However, this=

> isn't always necessary.  Firstly, it's safe to leave some stale
> read-only TLB entries as long as they will be flushed finally.
> Secondly, it's quite possible that the original read-only PTE/PDEs
> aren't cached in remote TLB at all if the memory footprint is large.
> In fact, on x86_64, the page fault handler doesn't flush the remote
> TLB in this situation, which benefits the performance a lot.
>
> To improve the performance on arm64, make the write protection fault
> handler flush the TLB locally instead of globally via TLBI broadcast
> after making the PTE/PDE writable.  If there are stale read-only TLB
> entries in the remote CPUs, the page fault handler on these CPUs will
> regard the page fault as spurious and flush the stale TLB entries.
>
> To test the patchset, make the usemem.c from
> vm-scalability (https://git.kernel.org/pub/scm/linux/kernel/git/wfg/vm-=
scalability.git).
> support calling fork()/exec() periodically.  To mimic the behavior of
> the customer workload, run usemem with 4 threads, access 100GB memory,
> and call fork()/exec() every 40 seconds.  Test results show that with
> the patchset the score of usemem improves ~40.6%.  The cycles% of TLB
> flush functions reduces from ~50.5% to ~0.3% in perf profile.
>
> Signed-off-by: Huang Ying <ying.huang@linux.alibaba.com>
> Reviewed-by: Ryan Roberts <ryan.roberts@arm.com>
> Reviewed-by: Barry Song <baohua@kernel.org>
> Cc: Catalin Marinas <catalin.marinas@arm.com>
> Cc: Will Deacon <will@kernel.org>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: David Hildenbrand <david@redhat.com>
> Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> Cc: Vlastimil Babka <vbabka@suse.cz>
> Cc: Zi Yan <ziy@nvidia.com>
> Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
> Cc: Yang Shi <yang@os.amperecomputing.com>
> Cc: "Christoph Lameter (Ampere)" <cl@gentwo.org>
> Cc: Dev Jain <dev.jain@arm.com>
> Cc: Anshuman Khandual <anshuman.khandual@arm.com>
> Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
> Cc: Kevin Brodsky <kevin.brodsky@arm.com>
> Cc: Yin Fengwei <fengwei_yin@linux.alibaba.com>
> Cc: linux-arm-kernel@lists.infradead.org
> Cc: linux-kernel@vger.kernel.org
> Cc: linux-mm@kvack.org
> ---
>  arch/arm64/include/asm/pgtable.h  | 14 +++++---
>  arch/arm64/include/asm/tlbflush.h | 56 +++++++++++++++++++++++++++++++=

>  arch/arm64/mm/contpte.c           |  3 +-
>  arch/arm64/mm/fault.c             |  8 +++--
>  4 files changed, 72 insertions(+), 9 deletions(-)
>

LGTM. Acked-by: Zi Yan <ziy@nvidia.com>

Best Regards,
Yan, Zi

