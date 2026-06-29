Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F0EA2C43327
	for <linux-mm@archiver.kernel.org>; Mon, 29 Jun 2026 15:07:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9DD726B00A9; Mon, 29 Jun 2026 11:07:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 98C696B010F; Mon, 29 Jun 2026 11:07:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 854256B0112; Mon, 29 Jun 2026 11:07:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 56EA06B00A9
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 11:07:35 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id D0D3D16696D
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 15:07:34 +0000 (UTC)
X-FDA: 84933279228.25.23BCD7D
Received: from DM1PR04CU001.outbound.protection.outlook.com (mail-centralusazon11010028.outbound.protection.outlook.com [52.101.61.28])
	by imf20.hostedemail.com (Postfix) with ESMTP id BBDFA1C000F
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 15:07:31 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=BNeIVA93;
	spf=pass (imf20.hostedemail.com: domain of ziy@nvidia.com designates 52.101.61.28 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1782745651;
	b=bdGTciI0GKXI63DksQlciS0v6AlXB+PgGDxCwNwTOHHh7AJD1DsohJgqvjs3yiejEzem9F
	Hw5eTV4v0rTvGqPguB8f4q6DSjHKJ2ZVOGYZF/q4qz7jXV5hhXvwwmIJkSo9PpxdGMv0hp
	+NuCBNqRG1BMROO1c+e5EOTn3dO7C4A=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782745651;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8TG/cbxtKDFGteoa9Ik34bVIAZhaxhTkwTHz3Kg9vhA=;
	b=c6E2GuzF3mnY6MhxpgbXDKCHtHrk1W16led3CGeFdU5bOJkckv6tczdmpXjiJ+hYcgDv0K
	HpX+v6yGCg0MK53gdZX0TaQdnwDyJkKkpFAciCPI6kvnphx2JLnMCNubB7dAKXo8B6Vmht
	DqppeaQzvDoO2qTcocqJffB8DK2VQ9g=
ARC-Authentication-Results: i=2;
	imf20.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=BNeIVA93;
	spf=pass (imf20.hostedemail.com: domain of ziy@nvidia.com designates 52.101.61.28 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=TKQXX62YJhsXlII2whlairOlf1H12cL7bMYDcK+Ro6pq8B4QYwAUdLfYwCbWXYWVEGR5UfKVHR05jvymgy/BNAdhr/bgoA7muVS2tAljyrCOEwMGjHmw/XPUxvSX7S0dXueBufmo7t8KjmbrtzpHfz8T/GfcQnltrlxpuzBYAJlamRMcGmDA4VK0IN7IDj/VnC3+nlo322CHVGWZStq3zr599Uc3EII/TEFWbgtSQE3EkSQL29NiuDXNDEt/1MgL/1ot88I3/7fwBb8Ni556qdGOf0qH4ydmZW57750wA4kAUea11xkAADNrssxU3z+QEUH/5G5uOMBDXFR6QZ4roQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8TG/cbxtKDFGteoa9Ik34bVIAZhaxhTkwTHz3Kg9vhA=;
 b=MOeT5wPd9B+iHgfhjAopy4jLLfltfeBEvgDV0JGdsaLMnXDpFicRWsB/D5nVKFMHzZr7EoLx3oAIHeI2TWTcudi2Yl9otPk6hreeZEhj8W5+8U0Ri/rnqJSlRgzg3AHpcbuCgGK6WwI6JeATVfH+4Eo/DAh4zCESjC9ROUabawHCXyxqjKsD6/C5ss7mVpBRtWtTKA/jUclcrt5TZObksa/qfvwZFj+tMnUs1kJKcMssVtKJfZmFvIuf0sPUlDYKCh8PG04yC0PwUkMiRsQRiddHICnc3Cu1onOahDh9tsOVoRYKUsq+EQ2IPXbx/cvfwL2MhtN1UnmxLwTHnP2e7w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8TG/cbxtKDFGteoa9Ik34bVIAZhaxhTkwTHz3Kg9vhA=;
 b=BNeIVA93YwZdgDlIjfPNOGx2edcjKPlUi2fLJbWtomGKkPYQ35si+44UHPw90XErMWMbyU+5Ve/fEkjZp7KRteC5SFhiUztC+zyBEyeKbFHeYefNsbdRfNYGUGfRJ7lDLZ5ookjAU7WSA9lPUbRdtJjnrzOEnTPREbwStlb8Nbhrn6rqCdxtIndBr7ovghMcD8Tm+D0P1YADTU81dEVhdRqjtlhYLzd79mkd3Rx/qEradcnKNkosA8VGcD9IFo8yshZJCJbcUFpmK1nmmX0O4JsTcb7PB+U4AlpwP+MKy++7j3IUAMgLHQu5PuO7E83i9IrXs5W0OeLYVWy5xsOOpw==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by LV2PR12MB5990.namprd12.prod.outlook.com (2603:10b6:408:170::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.159.19; Mon, 29 Jun
 2026 15:07:27 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%5]) with mapi id 15.21.0159.018; Mon, 29 Jun 2026
 15:07:27 +0000
From: Zi Yan <ziy@nvidia.com>
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Brendan Jackman <jackmanb@google.com>, Johannes Weiner <hannes@cmpxchg.org>,
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <liam@infradead.org>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Mike Rapoport <rppt@kernel.org>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/4] mm/page_alloc: make sure subpage->private is zero at
 page free time
Date: Mon, 29 Jun 2026 11:07:25 -0400
X-Mailer: MailMate (2.0r6290)
Message-ID: <847C58ED-0870-4D11-A10E-E51F631D818D@nvidia.com>
In-Reply-To: <43b67098-b9b3-448f-aa7a-43b7ef678e1c@kernel.org>
References: <20260628-keep-subpage-private-zero-at-free-v1-0-f4ce3930d10f@nvidia.com>
 <20260628-keep-subpage-private-zero-at-free-v1-3-f4ce3930d10f@nvidia.com>
 <43b67098-b9b3-448f-aa7a-43b7ef678e1c@kernel.org>
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: BL1PR13CA0216.namprd13.prod.outlook.com
 (2603:10b6:208:2bf::11) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|LV2PR12MB5990:EE_
X-MS-Office365-Filtering-Correlation-Id: 615e4c80-b249-4ff9-a8ed-08ded5f021d0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|23010399003|1800799024|366016|18002099003|22082099003|11063799006|56012099006|4143699003;
X-Microsoft-Antispam-Message-Info:
	0InXTInXTVxQM3JtOgzJtztQyZxyzs2D06RFWnOevtwm/lXX5NZGHDJdUmpxExhhtRoc5aR2K0gP8UfBPTGCLWti6gl63dK/rT1uFCC5WlVAhAF8z8164BBKBl/FaWbgx9xne3uZThUR57myMbBgucLRYpUt0oDHVJiENdk5d/rNOF+8J2IkcWju4gl0aN2Pm7Ai+Nhua3myIDaoBzN3GZ53f/hOb5hY+BLsRmxst3BK0C98ElKXiW7Fu7ky57RYFvplcdmJC4C9vPU7VzNezcI2b03UdK4M8RYIgPnLwGtgWCSvDHU+BWKvahN7bx4CLDwtn/gRXgUd6z4jGnhYknCOFkU3WB7sIahy+rvYyyw83a/sXhvas4PBzWRg1Lf/0l64KFXPxsWptLY5oNi/aY1sdBls1E6mwCMAxElWcj/oDMakpjSxWHh9Hg10fm1BDRfEL7s8qCElh377k5GgF/384GNqom739l1CmWcG3Uez9gh+NVcCwzgzuiww4Z3L7Bb1rcemDC5M9940gv7F2AJ15s3viqd0IttKrp5KxTfXeNZUElUVIZNCK4yGHtys1js7oDgxBVrJzVJ+mP4cH5+5hqf4BywcojA1WhT7d3EZZ8tHdRw7Gctkvybkr5Ajz7vPl3iFMO1ov1pUeEnH2S4Tu//ihCA6gtU92dsjUCA=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(23010399003)(1800799024)(366016)(18002099003)(22082099003)(11063799006)(56012099006)(4143699003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?5QHr7aeZODXBeC7Uwg7Ub5OAzBpuzSTtJbmSnA5a9BCoqJwthHfsWIV3TTdy?=
 =?us-ascii?Q?Uq0JpCl6GWnF75ChoiCVV30PReutnq8MAvEhhnB3lWRCgxHCJOX+JiXPPk7q?=
 =?us-ascii?Q?ANKzkFwSN+B7iqLt8a27zEVsESNIv0iTS+2wiRFtS3rxIY7r1NWr+EOgiEAt?=
 =?us-ascii?Q?16grRFhiaMXOm4s+bdKg9x4y5P5LrEmVmi8fgQRm9mPLnAFA+tm+i1bcBWwE?=
 =?us-ascii?Q?4ueWdRKcBB7xedBHIJ06E3+YFKEPlAIFMUQcN1KjM2e82/HThikA6+B4Fj4L?=
 =?us-ascii?Q?LKZ4DGP2no2MyZNpuffYPspbg3MExX1pP9KEQHsSIdjnn00lqA9wHNEv1kv2?=
 =?us-ascii?Q?cBcHHCDBRIylDUZfkSgAqyQnnnQNbhNFBHUjbtX9EhOckBXxA1gVFlo5d1zl?=
 =?us-ascii?Q?Lc2YJfBAPh0d+oSnN+HVtmczHlelUWER9mkk8H6E4g6BfegIVn/b2Js9DqkW?=
 =?us-ascii?Q?py9kCutMVrshS4qAvmxN5jIlgfnmZt0a5Nx50q5SyJtqT1XygAyhEkyN0ow4?=
 =?us-ascii?Q?QuxeGONa9dIuCE2Rxm72//euoePjsqT+a0d4XukOMsukysPXR6LpEuSbAJgQ?=
 =?us-ascii?Q?aS8SY67/cK1RuCRZasft6a3lxS5Mbg+bew/WrbgtkknghzSo8NNG6rf2rh1G?=
 =?us-ascii?Q?LI83rsFrShCnk/fsOgctVW4BWwtzCEVfdHRjg/1oH9hP/ZY3LQayBFSHKUCe?=
 =?us-ascii?Q?jnret5IV9lvqGrcdUtdPm95ZEO4ihnh0Zw1ZLVQYStuSA0Sf6ljELF8Izfzl?=
 =?us-ascii?Q?HH1b1f5UvRtypwuJUmQVQjWj/iCLlXMzXCdccCDJpOGMbGbnHUFcBVJ/ushG?=
 =?us-ascii?Q?LVs21DJyqeF5hpXgSh2HMHDxPBMklRB6gyxeeydJnZhJ1FFN0ElpbMneEiTA?=
 =?us-ascii?Q?gMfCPo/c2esyKjjz8bJPcuoFVJGM6A9FGxCTMsukyPQBa65SbAqUwO/97PvY?=
 =?us-ascii?Q?JQvrq3c7g1cFZkAf025JaMs78zW21Ure1MxzNvWPePM2iKto7kCkrUDlxoXZ?=
 =?us-ascii?Q?rluSP7WEDJmsBnz2/KetUln0tfMgQMeD9rG1JtBNy+w+uGuACmsyulsd5AAY?=
 =?us-ascii?Q?4g++ZlfnhTSlaL5uU21ayQRZk2I7xQCAASUqQEI/Zw+vhIapoISspvuTXkZa?=
 =?us-ascii?Q?Bs7KrqXGw7nOki+S/fzHo8/vn5ZUPeqTWIFd72XbW1JGWxvDHq5q4bOc/rVV?=
 =?us-ascii?Q?UkOpq1ordpGG7h8N69eJ5FkFWduzJNgRzUzI5RugCh1dpwAlDJYSmGR6KvSS?=
 =?us-ascii?Q?VuwNvrI8udI/lTFaHKV8QeGpgmAo3oDsOcwJsL/ZA7UmGzrgCgqxXd+tg9sQ?=
 =?us-ascii?Q?6px6nERv6vEDi2zWdpA4YRxMmiDo1Grfy/rC/2JBPQtxkysw0IsYiQFfcee0?=
 =?us-ascii?Q?pctQb5zF8FfeZCySX/bTMS5310dFDPnaADoBBvJSQC+IlpBSj7faCRoCRPuB?=
 =?us-ascii?Q?lXEOX+j1VRHiuCZO/OwjauRtSE0KySRVIVG8cVKenOzXUrKu3GzrNXRFqGzh?=
 =?us-ascii?Q?D2BNBgMg5kWe875H4dnjJ6QhPQgzDKBLYCTA75EQ8wsasaPUN73GG23xJROX?=
 =?us-ascii?Q?zPWBvbUHFeIZKgdm5kxWd29xr+ksa+6Ha8fG6cqmu6Qjzj0fAaZ59gqU8Odw?=
 =?us-ascii?Q?9/EmIorn7A5ke2KYHPUKD+7qIbV4MSmoA4ia/DG/iP+TgnUFVZ1r75wp3ii4?=
 =?us-ascii?Q?QsRfewK+OaRCV66aV9A+CJ/+eezmRvbDgSH13pXSb61Rb3Ve?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 615e4c80-b249-4ff9-a8ed-08ded5f021d0
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jun 2026 15:07:27.0574
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: K8V3ynSsDLx56h2VOLgmsYrxyJslyvINU93xTc3Q9KoN7JnjIcaZsELYPSHDwuq3
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV2PR12MB5990
X-Rspamd-Queue-Id: BBDFA1C000F
X-Stat-Signature: 636ffuqqyac1qee1ergpoic1x1fdd63f
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1782745651-815188
X-HE-Meta: U2FsdGVkX1/WGegpJnwii9jQWyWfIfnXL0wh8USz6S8UWH50qIbduJMsjCXPhBwJ0I1FadyelpNLT8m7g+2QVQ+zyN4zi4jI27wKZYZYUsx/KzCITHxWxhC8cqstlK1nn7KFUmNxyztVRUt+Rt+TRcjvjcfuotiAbxRm0oL/EM/LMl3M6AwDvtClk2yBSt4H3s17vE591pvMFtZfyGTrmlz3tfT5pB9KRIGHcCK3tq1f7LSBl2MmoBLVdI44EYuHFclPKoCaii3Y1pcDikwczfVs4ab6h9T39MJW4ZQcqYneX55CzeBb03Nv8b1eM92iIELYOSg4F5nbw5k6l5PGt9B7wI9V0Avjtqog21xCz2Q0hww9PBtvzOMn/GGRGDt2cIixAbIEFyiVKFR8C1rtKTUSHJiuBXvcipdYbUpH/XcU5djVcbQ76X1SjliwnHUhftGR9yvuOEHfp7eN0hRCLnvij98v6IhsZAy1ovljufxFDKZjmKmHctMf5bmXIsSfxgg1T4XCtaLVtHiUgXKsMlkPxh7nZfh7vs51ol2RZ3C+lo61wgzBLJ0qGmC0yxDNlcB3d4OzlWu5T2emssdIjWNUmrbZmWPbRz5dk8G7hEnGXwFaSxFN7PCfv6gopbW+DzVZ9lHwDrE3cDF8E/bo1ovcu1UA9HM1p3fPq5c2gPVbUHIZl3F/4Xj8gf73hLhbR9saojoXbu7kuDMtYRRpefi3K6eFSgAUQFTgd/0JByE5IIyFER9c6R8hp65d17w09hI08NNSXs0fvAedGjNoGAk8AqOYuxGkVqweDS0epovU0vtgWhQ8pzzJgbX0v3XkEf5mWRZeimkhtfCDlrucUtgat2xlXGy6H5UpMjka4YS7XOI0zawBfNt2ElcvvCK457k6fELU9gpqcP6qKx0YenXaLAAmyeesbGucqNQb7PhzPnFMvbPG2SOImSmd6bhRR75QuVnqt+ngbN5n9t+
 yulmawhu
 R5W45LD+3FYCCrpHeWkNxPSi92DjU9N10YFjQkI0tqA5AAbvuLSQB/kZzmjIQ/G04/yK5U7YIfr7W3SfgdFc4RJlVulxUq5tUCAZn6Q0tadiy3q0UeNKoweERSqHSPhaDHHUEVQR6eWfm0GIT6lcOkL0Onjrm/Zib60dt31NvtMrLq3g2FyzLxR02I/7eIqb40fU5eencEOpKR6Bq3xf0lj7RonIdavmQBs7B7XKP/20c9bljQSWDCmpoAWZY14EQikhNmVHob4+w363bfTaSUpcZ4C+FC5ZTrwBC1bru3RdREoH4EfYOWxFHVbOqWCeDfB9ImKA8w6kKW6RzKu5xfL1oznZhmnx/fwiV47+moSpU1vhWenGN6auEUXmqxXq+Myx2/b/I3hq2iMUq9kmRwC0IdPKPtXbZsE4lJkokBI9stt4t+UHr2VpGHc/4JZ5gipxuPp9C1tRH7waTGH2YYBJ8CE1KWxThiwarKmGapUysIcnI6mHNCYLeB9vPQoajIrs8s0UmalqGwMk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 29 Jun 2026, at 10:53, Vlastimil Babka (SUSE) wrote:

> On 6/29/26 04:56, Zi Yan wrote:
>> Any code using subpage->private of a folio, a compound page or a high-=
order
>> page is supposed to reset it after use, otherwise ->private data can l=
eak
>> to new page user and cause unexpected issues. Add a bad_page() check a=
t
>> page free path for it.
>>
>> Assisted-by: Codex:gpt-5 # add the missing "return false" after bad_pa=
ge()
>> Signed-off-by: Zi Yan <ziy@nvidia.com>
>
> I noticed the word 'subpage' is now frowned upon ;)
> See https://lore.kernel.org/all/20260623125723.2503832-1-dev.jain@arm.c=
om/
>
> since this is about tail pages, just call them as such?

I will change to tail pages.

>
>> ---
>>  mm/page_alloc.c | 12 +++++++++---
>>  1 file changed, 9 insertions(+), 3 deletions(-)
>>
>> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
>> index ee902a468c2f..13c2655e24fb 100644
>> --- a/mm/page_alloc.c
>> +++ b/mm/page_alloc.c
>> @@ -1374,15 +1374,21 @@ static __always_inline bool __free_pages_prepa=
re(struct page *page,
>>  #endif
>>  		}
>>  		for (i =3D 1; i < (1 << order); i++) {
>
> i starts at 1
>
>> +			struct page *subpage =3D page + i;
>
> so "tail_page" is accurate?

Right. Will rename it.

>
>> +
>>  			if (compound)
>> -				bad +=3D free_tail_page_prepare(page, page + i);
>> +				bad +=3D free_tail_page_prepare(page, subpage);
>>  			if (is_check_pages_enabled()) {
>> -				if (free_page_is_bad(page + i)) {
>> +				if (free_page_is_bad(subpage)) {
>>  					bad++;
>>  					continue;
>>  				}
>>  			}
>> -			(page + i)->flags.f &=3D ~PAGE_FLAGS_CHECK_AT_PREP;
>> +			subpage->flags.f &=3D ~PAGE_FLAGS_CHECK_AT_PREP;
>> +			if (subpage->private) {
>> +				bad_page(subpage, "nonzero private");
>> +				return false;
>> +			}
>
> Also why not put this check into the is_check_pages_enabled() block and=

> handle it the same way?
>

Will do. And Sashiko also pointed this out.

>>  		}
>>  	}
>>  	if (folio_test_anon(folio)) {
>>


Best Regards,
Yan, Zi

