Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 607F1CCD1AB
	for <linux-mm@archiver.kernel.org>; Wed, 22 Oct 2025 02:59:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8D2608E0006; Tue, 21 Oct 2025 22:59:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8A95A8E0002; Tue, 21 Oct 2025 22:59:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 770DB8E0006; Tue, 21 Oct 2025 22:59:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 62E718E0002
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 22:59:41 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 0C325160702
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 02:59:41 +0000 (UTC)
X-FDA: 84024244962.27.3C6EB98
Received: from SN4PR0501CU005.outbound.protection.outlook.com (mail-southcentralusazon11011014.outbound.protection.outlook.com [40.93.194.14])
	by imf02.hostedemail.com (Postfix) with ESMTP id 1928080002
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 02:59:37 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=VwD9PNM0;
	spf=pass (imf02.hostedemail.com: domain of ziy@nvidia.com designates 40.93.194.14 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761101978;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sS+yFnA0r5ZMDATdUIqJMHILjurXJFBo0Ua0OVW3ZIc=;
	b=fRrkPRBZ/S37F/0xDhOcJO7LgwN/mgwc5lHN2I9g4BFGTAhcsB7HkRRRRfEXk+iAWxVbVW
	Rkn7T1kr956mGPikSm9t9U7bfnewkESixYj2J0KG1MW1MYdtlwVM431jrVjob0mS189ifW
	jZgtUZozWQsf6BnOPrFOObR3zmq/wgE=
ARC-Authentication-Results: i=2;
	imf02.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=VwD9PNM0;
	spf=pass (imf02.hostedemail.com: domain of ziy@nvidia.com designates 40.93.194.14 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1761101978; a=rsa-sha256;
	cv=pass;
	b=YMByJOJP1bb1Ra37S8KxyK2EpK68CjKHIVl5XqQBIOUyynv3dfCRAJuildyoVCk+pbSdAJ
	VZOfvrJealUOIQ+7ahCrwOL4/ZC/pFDgbUGgOXhuM5uDWd7akFcsVJ/dvNcUUyF8obg767
	qvW2q/fW1HpIhoO6EI8oaPXCVnT0Zwg=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=iyhZ1cVmUK45wpk7ZAajE2n5Is4pc6KBeTI5fNrLAWTJdD0ksCGU8DAuRrFHvPy1FFYW73j5OiUouKhNtexlmPj4XltLVZviUYgUKOqR8E1uGVFgMHFzMHJC6WRKO6dfLFpTEDDgsDgFT0ffOsFzMJ6zCF5H3bAdtuJxQD688u++lCKRof/iw1i6CBfsZ3pqG3WfMPBha8WziXC987N4K6EthLBbGQi3u4VE9QiXypYiYcQkgIqdF2Wf7Sbrrr9T0+aNR1DxfRGEfu+M0HTuYxVZwKGL2+Z4SMM7vTNyA0f9egwJKbsfHjM8WZLJgt0Lma7fKHcoGYn+LGVxg8tG7g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sS+yFnA0r5ZMDATdUIqJMHILjurXJFBo0Ua0OVW3ZIc=;
 b=EVdtDkiRWeTZXvfgC33kJf/lQ8XwgeEMM2Q9dPD6d0YJSkuPWJAmyfU1Kl+wNTOGZ8Mg7CaZhFPLv6Lwi6ZD6Q7o7CerwNFu9eQLwiwcQqq3ov+B9PBGMbMYtyEwfRUerCtAbLJ3dzcNkdI4b+x1PfHeR+tMQc4hsdzyoPW9xgHy7ZXInFPKOLcn6yHZpx+okErjuix7mEc4UfsmMZHWt2Ef93TqlPeZqN1bvyQjQDkBzn8vpnZ2uqBbrKAL0j0M0mrWi4N+Yg5oNjJdnPxNeUr4aPARJLunRprmIaRlhxzAB1AsnMRhIQDbalGTnLLG7vpUmZIV4hBmd/fxc12e+Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sS+yFnA0r5ZMDATdUIqJMHILjurXJFBo0Ua0OVW3ZIc=;
 b=VwD9PNM0eX9XoYAPBx83h8r/ESBKGJCN7z3QCk5CcHJjlsSpapikCQZ10GDCSAjvj9rhyoAIkdtY7Sd68ih2vVgiCGXfz3uA3NOrP1zZNizdkz4L6j4lKZgM4kfn31Y0TtLB9cKrjqwbc20+2Dphr11vN1nchKLoUgsSm7/iJUz0ROo5vh9y1H05/moOhroDB0TW+AKB5P3dyMl/VSKwwUDy0Ld0T2RypxUjrxUqqDEKa8CA6VzwzHcFcjWS5Y3w9rmTfCKjsRieQpl4jO3FruwRwVEAXJ3mQwJpQLjrtsw9NT4NslEuve8GLFeBQ8jiTljvCltTLTCoRWf4c73LXQ==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 DS0PR12MB7827.namprd12.prod.outlook.com (2603:10b6:8:146::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9253.12; Wed, 22 Oct 2025 02:59:32 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a%5]) with mapi id 15.20.9253.011; Wed, 22 Oct 2025
 02:59:32 +0000
From: Zi Yan <ziy@nvidia.com>
To: Balbir Singh <balbirs@nvidia.com>
Cc: Wei Yang <richard.weiyang@gmail.com>, linux-kernel@vger.kernel.org,
 dri-devel@lists.freedesktop.org, linux-mm@kvack.org,
 akpm@linux-foundation.org, David Hildenbrand <david@redhat.com>,
 Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
 Byungchul Park <byungchul@sk.com>, Gregory Price <gourry@gourry.net>,
 Ying Huang <ying.huang@linux.alibaba.com>,
 Alistair Popple <apopple@nvidia.com>, Oscar Salvador <osalvador@suse.de>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lyude Paul <lyude@redhat.com>,
 Danilo Krummrich <dakr@kernel.org>, David Airlie <airlied@gmail.com>,
 Simona Vetter <simona@ffwll.ch>, Ralph Campbell <rcampbell@nvidia.com>,
 =?utf-8?q?Mika_Penttil=C3=A4?= <mpenttil@redhat.com>,
 Matthew Brost <matthew.brost@intel.com>,
 Francois Dugast <francois.dugast@intel.com>
Subject: Re: [v7 11/16] mm/migrate_device: add THP splitting during migration
Date: Tue, 21 Oct 2025 22:59:29 -0400
X-Mailer: MailMate (2.0r6272)
Message-ID: <D00196E8-E812-41CF-A2F8-A38251161ACA@nvidia.com>
In-Reply-To: <debc988e-45cc-481d-b688-a5764647f3e5@nvidia.com>
References: <20251001065707.920170-1-balbirs@nvidia.com>
 <20251001065707.920170-12-balbirs@nvidia.com>
 <20251019081954.luz3mp5ghdhii3vr@master>
 <62073ca1-5bb6-49e8-b8d4-447c5e0e582e@nvidia.com>
 <97796DEE-E828-4B12-B919-FCA2C86756DE@nvidia.com>
 <debc988e-45cc-481d-b688-a5764647f3e5@nvidia.com>
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: BLAPR03CA0091.namprd03.prod.outlook.com
 (2603:10b6:208:32a::6) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|DS0PR12MB7827:EE_
X-MS-Office365-Filtering-Correlation-Id: 2feb80b4-6234-49fd-f6cd-08de11170638
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?670HepFklGDwbpRPItYjOBQI4uCQjiPDHbUan/LS9YLvH/UjOK51Qlvtb4ou?=
 =?us-ascii?Q?lATGaXfe7k4P0tnkPUNry3Wi/XIVWgRGwezScJo1qzG7H8Dw62rYF+zjTTFN?=
 =?us-ascii?Q?7bhFeuL3slnF4J5pEk/gmllZjMYMn48eVbwMNBvLo/IaNe339+mZHxlcp6Me?=
 =?us-ascii?Q?ECeGsZngwvxqmqVX0DBr65Eb0ZZdVezKy03F4qyshbeMc9IRLxomKnkLpwLU?=
 =?us-ascii?Q?wcX9bek51vefaEovETRfDMJKo+254W81lgxDxQyy+s5D8TqFzFpG0YqHm74O?=
 =?us-ascii?Q?2s8W8tmcAS8FqIMVHoex87K8GaKDfrLGVS8PQI/VqR2t0Jthhc5ENAvSn03b?=
 =?us-ascii?Q?ud6NkSViwciEnNT3HYDK4BbR8RYCWV0HU+m5z2shIwwINS+wkKlA1vamonJJ?=
 =?us-ascii?Q?Cyycp4vTJxVMdTaD19qXiLOnVm6Su/JW9NeLubTSKkXfjgFpdr/BSzPTNdzw?=
 =?us-ascii?Q?x7Y9YWV4cPZBHjT7rA6JKMp8Zlcv6f+gEgUW/QrHA1bB86zLmgCaABi/xDgp?=
 =?us-ascii?Q?otkqDb4Bju9kJ2fN0SNS28cXxFAGsHDheGoLi9iqplTUpdsgqn53zLxDt+Ku?=
 =?us-ascii?Q?nU3uiDOR0B/Sk9NYSoZF2TqNobqWd8hL8zWlXnX2pykm/RgOulh92c7xIkJM?=
 =?us-ascii?Q?VZN4Rq0bACb4fxo8iZeMG4VZu5bTo6AheQQBz2OVQt31PE8ktKNFAiJpYF67?=
 =?us-ascii?Q?zHE61tZp3g3Y4PRaTGrfjxvOflunJSCTvx2XeON7e2XzfPW2QoJMwCKSG5t4?=
 =?us-ascii?Q?jSyFTrypv2i2R7/SCYDimmmpEl6J3PkAz0xPVtdw3jq8GBvM5Xviuw4R2dgh?=
 =?us-ascii?Q?9dsLbJkO3mDg5pagDreAP99MIrGtIZEupwapWzdV8d9vJ/TtkIpHDjlAO+QY?=
 =?us-ascii?Q?jp3q6myHIa6lNOHHiu9azBePaQTeGRbFfcy4+hAZt09SndhzA+p+qTUHZXsC?=
 =?us-ascii?Q?8H+tOkcwkXbx0PWQpcN/QG5jPf/fxdjRsOOulpHZV+W1nq5GVoGCiRi4Li/a?=
 =?us-ascii?Q?uGYB8Vgh44ZH8vhSYdXxcw+a3yxG2FkX6w1udg1X4WpN5hX8qHMOB37+TyxC?=
 =?us-ascii?Q?IOtDJuSZI0tOuKV8EPpzg2ePPAaXqPyK8Wi59c9MTAxccx+Rky/KLSft8Ohm?=
 =?us-ascii?Q?i3ilpgxI/ypJq2RnUs9ROstdiFLwryBAkSg40LqQO7mFve8g+kUsD84/5577?=
 =?us-ascii?Q?lCs3C2oB/cIqX2ZOyCGxRaVbTyXnyPz6Pc0/ygFhH7HXW77HDz1Vjyg8ciKW?=
 =?us-ascii?Q?JDezrO77RIuWwKvrunqJS/WGiJjOYrnpA2srzKbXSQdjZYtQ/GSKi1zcQGLa?=
 =?us-ascii?Q?UdxryMTY1G50MRuWR0VvE645Fa5+a93d1KBI6Mtd2In3o7zsGbkIwqzi4uPL?=
 =?us-ascii?Q?VnXD/vbFEeMgNg4cEahCG522tVZaD7XzWAfwnyk+ha88lejn3U/O542wvApA?=
 =?us-ascii?Q?BYrBz0Vhc75bl3iEmycbxnhP1R63svcF?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?jTEKS+eS0FbQJcXSs3Fezt79l4WUKFPaiwTNIWnnXe9zc6B4jWfFiLgP+zj8?=
 =?us-ascii?Q?Nlurn++VU3z2rFdMJYw8rM05jR37BwBeWZtxcODDLWxYsm16BxziI+/Urhvs?=
 =?us-ascii?Q?GplarxIeO7dt3GgmsJx5QGIjJVv5LwvMPXqNmdmk4eGhqWIlo3y92oZ92+jW?=
 =?us-ascii?Q?jUoQpCWSpuYtE6BMlJGM83z4kEELNLpKmJDZprQ78SjIXiHVE1zL73ogkL7L?=
 =?us-ascii?Q?cZPxRSQVTrsiqwWGGups75NRTzD7Vh/lhZDxgivjvB1XZdnX7wnSmzw71yzS?=
 =?us-ascii?Q?VTBUoGw8HYWHfLFHqMSjLjLqVEfymtgFcosUSaQyCkriDlI7NX5i08AGtRst?=
 =?us-ascii?Q?g9Kcub/MiIYMY6BPIAcxFwAQ15+gWdde5gCC6JKe/DNsHuxKSBeMRgL2XjWO?=
 =?us-ascii?Q?TUIAScdeWk2CZMWo/BYtSJTyfmmHlsZLI50hSlB2Ano5R+T3m29Jr/kr1V5j?=
 =?us-ascii?Q?RwC8U1a6iMZw8YucZ1lEYHDYkdYvSO52eyFmvC8ussCUkk0hyPju+YeCsHP1?=
 =?us-ascii?Q?f435yjnAdVQtUiAVPEMO6eqmHQNolXz0cc1Y5BmIkyembM9sGk9hYYgf8H5/?=
 =?us-ascii?Q?AcaW2Te7xwgnl2VIUAn2uKI1I/+oKvDmI4ciPd4nVbVnFvOoxjSHMtW91Goj?=
 =?us-ascii?Q?PEYbmsHPPriIH08m4WmjtAZ4shl58mmVMSKUIXeJA35+QxtyrdIzTQ4PDPfo?=
 =?us-ascii?Q?+fanFxnFV6oRhJikajGSZXXGu3JF50u8piZKQDp44AghfbmIWLa/Z9InGbyZ?=
 =?us-ascii?Q?J2KgX22nhPf+T7XUcVSU4ZGFNPHLmPjG8aePVE/rQCkIcZdQY3S0Z7wu8cVL?=
 =?us-ascii?Q?C4eNSaV0p0apgHatQagDpMRnAtIn70H8+lmweN6mrdP4HKyGqKzP7sPl1wiq?=
 =?us-ascii?Q?moWv2MfKppd0cQAK4e/uvIOe2B4UqnNAtjnyHNVuagmc4nHjN4mgTaUcYMyR?=
 =?us-ascii?Q?AuPYk43JnXyWXclu6t7yzqfzVP0lZhR4fIRqDh2N0J/LgDVbwMOCVAkAiVW2?=
 =?us-ascii?Q?4S+bKc4qqqE92u+IFNw6IV/kh0PIZADE9DhZMulLh+2V4/IyZUNAEcqCvN4O?=
 =?us-ascii?Q?RMLCw9BWTfxY+0NMdQdcGyPaOUnSt02lGmLfcl8040S9+HiCmhfEFXoTlYrL?=
 =?us-ascii?Q?J3Ec/a9L/XVK/5730KxO7spfhvhDNMXSlS0/YnFI0O2nFqFT5NUMA3wf4T/5?=
 =?us-ascii?Q?ZAZwV/TVd90fvnHyiXOhMbcDUKcAVkTqfaTL8rB9dSdSIpSZSho3U6kx0lre?=
 =?us-ascii?Q?rSHVdO+WlB1UPNPcAk1fDgU9wPEOx/C5Luv7g/zA4FuecQ6L5TwNt9xaEDy7?=
 =?us-ascii?Q?wBXYDxMLmzzvItIg6RyhQfK7/IUiackuw7XkwaPkvcV6ZcpNaNE0uFG6jKn6?=
 =?us-ascii?Q?4vNsae/L0IsrY4gsuOs0EdZ34P5AeMfyyq1ZFH+Ybab1JcuOfQw9eevIFFp/?=
 =?us-ascii?Q?uULaUf2FZOwO2kgRUzJ8Xsu1jpiBa52IX/bqr0nlLpFRA8eask/J5OCym123?=
 =?us-ascii?Q?5Lo2x6WmCmBY9SVbj/aNKHyHYQ9HZIms2VJj8UoYxvRRyrEwxtaCZB8tAwIM?=
 =?us-ascii?Q?JC2fZ1m8DQwDikccGAMukrf0zhnxyVK+S4kNFqkk?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2feb80b4-6234-49fd-f6cd-08de11170638
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Oct 2025 02:59:32.1294
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: z79gzoPhCoUpWLALKrff0b04ux8IvsIwYrwvHJ99uDNSRd+gE7X1uN9UbcMcBGNf
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB7827
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 1928080002
X-Stat-Signature: 5mdw954sikyk3pb3p5431xq3oxi8ozrg
X-Rspam-User: 
X-HE-Tag: 1761101977-450900
X-HE-Meta: U2FsdGVkX1/Zjq+USFdII5RyyKHq0FwKVG1HyeBNyEp4bGMv7Wt5ellv+RG3SA4dwSKrHWLwxKikPZEdK0twrZ0MWu4qFoQRCqgNk0COCSYgNwNi8S15mFkyG4PyhFUFlvWG1V0DrlsHPg8tXJjKTYJqiEYhGBwEVzBcPciKbt3GpkjzXDGIJdVn7erePJZQjd3ib7Y27vBzNOnPpHiHAtGsiOALw4BybmOngZ1eMJYZ0uEuTkwdwepkEk+S2n8S1XEcDCbyjg/qgkx+nHmna7FTsmFnOVHUNoy8DXfbu9ccM5oyQ8isOWt6RYBoLXvYK1wdqGTlqgxr3NNvo9Tbk2sth5RrRx6+mx41w43WaZrsQcMx7V0bM31YvLQa+xT1dDWHktAKR3dQnWb9sDADB2kVDHaZVrw1np63KvoLi+orsY/5ldZBI2HAAf/yCEbeoxmUGjVzmhNwOmr0keWsOX4tr+NPCTYxnUh0LfJQeAQyNVUoNPv0mNBNgPGjXw87xHnjA9UNrVnod4o28zljeoJPcnNR9R4bAyUFs4k1YtIqUZEVNJ8ST7Zb38yPV/MaYY/NlKVDym6uLBx0MeJnlTMQ6clHnEskC1Slx/QD8ky71BEzugWY69p4dzRrArUXD9+ZQG2oE5igbxForqkPJ5ck5Nu4ds5/ibvo+thZJjTwWRN9qPlIUa+hu+VOt1gq52XzCi9OT4jmfmu/X1drUpgz6zqfAuPNahv7O/YAZVSWmX6ZOMouanIrsaQTnfZ8n6tpJ7YurqnKdd5CF8I2rJRjW9h+Ar1uPZ39njloRR2KBjcdlqJkddbZRWPxzwtuxsMD3ZsppZRQH7KZNSHh0JyFM0bG6eJsZ2pcsjXyTDzt70ifzFlDbz+oMRZAgYzNlSa9n1Q/e8pPhtFT8ox4wiGZyZCAWkEfz4q/kqBXCFogImESYs2itzTyeIy1Dy/pHiWnkxGsRaXjSdNo+et
 BNEtnR+B
 EguRCITPJjhvh9HRp1CrlymYGOOURH8XnUHRS4iyz9IzWFPeuxrHTEBlzeLrQ7FTQpxBNdB/yGE40Nk81l2AydHfYM7/12vbVJdgmeTyQEDts2Qd5prnTT09qOKE7I7DTztJDVidP9f7QwDzScpLSGWU7zaLVAHX9AqKzyugXHCH9/YXVp+WYPfPJw6sjxWemHIMiozoZXp3V/dol8wBPeXLPqa3zYPrDh/0hC32VTAB7T1W/dQsJwPmnL4YJm83FZsWXe8N/S8VqeNXALG6W1LxUer23ppGO0U+r9Cn+5gaVMQFMXy/DkQksjB3j99APQ/WbCb6UKwnzrgb2lVow6QvOXcx9LQOTPBAmXeqKMp9VIvaIlkg0/7hY9iPlPEJhtYw7TLYX+wzB+KdtMoorDNE8r7OoBOeJWUcuYrTLA5YtpblqjwVk1TDyW7UUIREpJEeRgmWhZbGnG+TpmQE0cR/hfANiXi8Y4ujO
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 21 Oct 2025, at 17:34, Balbir Singh wrote:

> On 10/20/25 09:59, Zi Yan wrote:
>> On 19 Oct 2025, at 18:49, Balbir Singh wrote:
>>
>>> On 10/19/25 19:19, Wei Yang wrote:
>>>> On Wed, Oct 01, 2025 at 04:57:02PM +1000, Balbir Singh wrote:
>>>> [...]
>>>>> static int __folio_split(struct folio *folio, unsigned int new_orde=
r,
>>>>> 		struct page *split_at, struct page *lock_at,
>>>>> -		struct list_head *list, bool uniform_split)
>>>>> +		struct list_head *list, bool uniform_split, bool unmapped)
>>>>> {
>>>>> 	struct deferred_split *ds_queue =3D get_deferred_split_queue(folio=
);
>>>>> 	XA_STATE(xas, &folio->mapping->i_pages, folio->index);
>>>>> @@ -3765,13 +3757,15 @@ static int __folio_split(struct folio *foli=
o, unsigned int new_order,
>>>>> 		 * is taken to serialise against parallel split or collapse
>>>>> 		 * operations.
>>>>> 		 */
>>>>> -		anon_vma =3D folio_get_anon_vma(folio);
>>>>> -		if (!anon_vma) {
>>>>> -			ret =3D -EBUSY;
>>>>> -			goto out;
>>>>> +		if (!unmapped) {
>>>>> +			anon_vma =3D folio_get_anon_vma(folio);
>>>>> +			if (!anon_vma) {
>>>>> +				ret =3D -EBUSY;
>>>>> +				goto out;
>>>>> +			}
>>>>> +			anon_vma_lock_write(anon_vma);
>>>>> 		}
>>>>> 		mapping =3D NULL;
>>>>> -		anon_vma_lock_write(anon_vma);
>>>>> 	} else {
>>>>> 		unsigned int min_order;
>>>>> 		gfp_t gfp;
>>>>> @@ -3838,7 +3832,8 @@ static int __folio_split(struct folio *folio,=
 unsigned int new_order,
>>>>> 		goto out_unlock;
>>>>> 	}
>>>>>
>>>>> -	unmap_folio(folio);
>>>>> +	if (!unmapped)
>>>>> +		unmap_folio(folio);
>>>>>
>>>>> 	/* block interrupt reentry in xa_lock and spinlock */
>>>>> 	local_irq_disable();
>>>>> @@ -3925,10 +3920,13 @@ static int __folio_split(struct folio *foli=
o, unsigned int new_order,
>>>>>
>>>>> 			next =3D folio_next(new_folio);
>>>>>
>>>>> +			zone_device_private_split_cb(folio, new_folio);
>>>>> +
>>>>> 			expected_refs =3D folio_expected_ref_count(new_folio) + 1;
>>>>> 			folio_ref_unfreeze(new_folio, expected_refs);
>>>>>
>>>>> -			lru_add_split_folio(folio, new_folio, lruvec, list);
>>>>> +			if (!unmapped)
>>>>> +				lru_add_split_folio(folio, new_folio, lruvec, list);
>>>>>
>>>>> 			/*
>>>>> 			 * Anonymous folio with swap cache.
>>>>> @@ -3959,6 +3957,8 @@ static int __folio_split(struct folio *folio,=
 unsigned int new_order,
>>>>> 			__filemap_remove_folio(new_folio, NULL);
>>>>> 			folio_put_refs(new_folio, nr_pages);
>>>>> 		}
>>>>> +
>>>>> +		zone_device_private_split_cb(folio, NULL);
>>>>> 		/*
>>>>> 		 * Unfreeze @folio only after all page cache entries, which
>>>>> 		 * used to point to it, have been updated with new folios.
>>>>> @@ -3982,6 +3982,9 @@ static int __folio_split(struct folio *folio,=
 unsigned int new_order,
>>>>>
>>>>> 	local_irq_enable();
>>>>>
>>>>> +	if (unmapped)
>>>>> +		return ret;
>>>>
>>>> As the comment of __folio_split() and __split_huge_page_to_list_to_o=
rder()
>>>> mentioned:
>>>>
>>>>   * The large folio must be locked
>>>>   * After splitting, the after-split folio containing @lock_at remai=
ns locked
>>>>
>>>> But here we seems to change the prerequisites.
>>>>
>>>> Hmm.. I am not sure this is correct.
>>>>
>>>
>>> The code is correct, but you are right in that the documentation need=
s to be updated.
>>> When "unmapped", we do want to leave the folios locked after the spli=
t.
>>
>> Sigh, this "unmapped" code needs so many special branches and a differ=
ent locking
>> requirement. It should be a separate function to avoid confusions.
>>
>
> Yep, I have a patch for it, I am also waiting on Matthew's feedback, FY=
I, here is
> a WIP patch that can be applied on top of the series

Nice cleanup! Thanks.

>
> ---
>  include/linux/huge_mm.h |   5 +-
>  mm/huge_memory.c        | 137 ++++++++++++++++++++++++++++++++++------=

>  mm/migrate_device.c     |   3 +-
>  3 files changed, 120 insertions(+), 25 deletions(-)
>
> diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
> index c4a811958cda..86e1cefaf391 100644
> --- a/include/linux/huge_mm.h
> +++ b/include/linux/huge_mm.h
> @@ -366,7 +366,8 @@ unsigned long thp_get_unmapped_area_vmflags(struct =
file *filp, unsigned long add
>
>  bool can_split_folio(struct folio *folio, int caller_pins, int *pextra=
_pins);
>  int __split_huge_page_to_list_to_order(struct page *page, struct list_=
head *list,
> -		unsigned int new_order, bool unmapped);
> +		unsigned int new_order);
> +int split_unmapped_folio_to_order(struct folio *folio, unsigned int ne=
w_order);
>  int min_order_for_split(struct folio *folio);
>  int split_folio_to_list(struct folio *folio, struct list_head *list);
>  bool uniform_split_supported(struct folio *folio, unsigned int new_ord=
er,
> @@ -379,7 +380,7 @@ int folio_split(struct folio *folio, unsigned int n=
ew_order, struct page *page,
>  static inline int split_huge_page_to_list_to_order(struct page *page, =
struct list_head *list,
>  		unsigned int new_order)
>  {
> -	return __split_huge_page_to_list_to_order(page, list, new_order, fals=
e);
> +	return __split_huge_page_to_list_to_order(page, list, new_order);
>  }
>
>  /*
> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index 8c82a0ac6e69..e20cbf68d037 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -3711,7 +3711,6 @@ bool uniform_split_supported(struct folio *folio,=
 unsigned int new_order,
>   * @lock_at: a page within @folio to be left locked to caller
>   * @list: after-split folios will be put on it if non NULL
>   * @uniform_split: perform uniform split or not (non-uniform split)
> - * @unmapped: The pages are already unmapped, they are migration entri=
es.
>   *
>   * It calls __split_unmapped_folio() to perform uniform and non-unifor=
m split.
>   * It is in charge of checking whether the split is supported or not a=
nd
> @@ -3727,7 +3726,7 @@ bool uniform_split_supported(struct folio *folio,=
 unsigned int new_order,
>   */
>  static int __folio_split(struct folio *folio, unsigned int new_order,
>  		struct page *split_at, struct page *lock_at,
> -		struct list_head *list, bool uniform_split, bool unmapped)
> +		struct list_head *list, bool uniform_split)
>  {
>  	struct deferred_split *ds_queue;
>  	XA_STATE(xas, &folio->mapping->i_pages, folio->index);
> @@ -3777,14 +3776,12 @@ static int __folio_split(struct folio *folio, u=
nsigned int new_order,
>  		 * is taken to serialise against parallel split or collapse
>  		 * operations.
>  		 */
> -		if (!unmapped) {
> -			anon_vma =3D folio_get_anon_vma(folio);
> -			if (!anon_vma) {
> -				ret =3D -EBUSY;
> -				goto out;
> -			}
> -			anon_vma_lock_write(anon_vma);
> +		anon_vma =3D folio_get_anon_vma(folio);
> +		if (!anon_vma) {
> +			ret =3D -EBUSY;
> +			goto out;
>  		}
> +		anon_vma_lock_write(anon_vma);
>  		mapping =3D NULL;
>  	} else {
>  		unsigned int min_order;
> @@ -3852,8 +3849,7 @@ static int __folio_split(struct folio *folio, uns=
igned int new_order,
>  		goto out_unlock;
>  	}
>
> -	if (!unmapped)
> -		unmap_folio(folio);
> +	unmap_folio(folio);
>
>  	/* block interrupt reentry in xa_lock and spinlock */
>  	local_irq_disable();
> @@ -3954,8 +3950,7 @@ static int __folio_split(struct folio *folio, uns=
igned int new_order,
>  			expected_refs =3D folio_expected_ref_count(new_folio) + 1;
>  			folio_ref_unfreeze(new_folio, expected_refs);
>
> -			if (!unmapped)
> -				lru_add_split_folio(folio, new_folio, lruvec, list);
> +			lru_add_split_folio(folio, new_folio, lruvec, list);
>
>  			/*
>  			 * Anonymous folio with swap cache.
> @@ -4011,9 +4006,6 @@ static int __folio_split(struct folio *folio, uns=
igned int new_order,
>
>  	local_irq_enable();
>
> -	if (unmapped)
> -		return ret;
> -
>  	if (nr_shmem_dropped)
>  		shmem_uncharge(mapping->host, nr_shmem_dropped);
>
> @@ -4057,6 +4049,111 @@ static int __folio_split(struct folio *folio, u=
nsigned int new_order,
>  	return ret;
>  }
>
> +/*
> + * This function is a helper for splitting folios that have already be=
en unmapped.
> + * The use case is that the device or the CPU can refuse to migrate TH=
P pages in
> + * the middle of migration, due to allocation issues on either side
> + *
> + * The high level code is copied from __folio_split, since the pages a=
re anonymous
> + * and are already isolated from the LRU, the code has been simplified=
 to not
> + * burden __folio_split with unmapped sprinkled into the code.

I wonder if it makes sense to remove CPU side folio from both deferred_sp=
lit queue
and swap cache before migration to further simplify split_unmapped_folio_=
to_order().
Basically require that device private folios cannot be on deferred_split =
queue nor
swap cache.

> + *
> + * None of the split folios are unlocked
> + */
> +int split_unmapped_folio_to_order(struct folio *folio, unsigned int ne=
w_order)
> +{
> +	int extra_pins;
> +	int ret =3D 0;
> +	struct folio *new_folio, *next;
> +	struct folio *end_folio =3D folio_next(folio);
> +	struct deferred_split *ds_queue;
> +	int old_order =3D folio_order(folio);
> +
> +	VM_WARN_ON_FOLIO(folio_mapped(folio), folio);
> +	VM_WARN_ON_ONCE_FOLIO(!folio_test_locked(folio), folio);
> +	VM_WARN_ON_ONCE_FOLIO(!folio_test_large(folio), folio);
> +
> +	if (!can_split_folio(folio, 1, &extra_pins)) {
> +		ret =3D -EAGAIN;
> +		goto err;
> +	}
> +
> +	local_irq_disable();
> +	/* Prevent deferred_split_scan() touching ->_refcount */
> +	ds_queue =3D folio_split_queue_lock(folio);
> +	if (folio_ref_freeze(folio, 1 + extra_pins)) {
> +		int expected_refs;
> +		struct swap_cluster_info *ci =3D NULL;
> +
> +		if (old_order > 1) {
> +			if (!list_empty(&folio->_deferred_list)) {
> +				ds_queue->split_queue_len--;
> +				/*
> +				 * Reinitialize page_deferred_list after
> +				 * removing the page from the split_queue,
> +				 * otherwise a subsequent split will see list
> +				 * corruption when checking the
> +				 * page_deferred_list.
> +				 */
> +				list_del_init(&folio->_deferred_list);
> +			}
> +			if (folio_test_partially_mapped(folio)) {
> +				folio_clear_partially_mapped(folio);
> +				mod_mthp_stat(old_order,
> +					MTHP_STAT_NR_ANON_PARTIALLY_MAPPED, -1);
> +			}
> +			/*
> +			 * Reinitialize page_deferred_list after removing the
> +			 * page from the split_queue, otherwise a subsequent
> +			 * split will see list corruption when checking the
> +			 * page_deferred_list.
> +			 */
> +			list_del_init(&folio->_deferred_list);
> +		}
> +		split_queue_unlock(ds_queue);
> +
> +		if (folio_test_swapcache(folio))
> +			ci =3D swap_cluster_get_and_lock(folio);
> +
> +		ret =3D __split_unmapped_folio(folio, new_order, &folio->page,
> +					     NULL, NULL, true);
> +
> +		/*
> +		 * Unfreeze after-split folios
> +		 */
> +		for (new_folio =3D folio_next(folio); new_folio !=3D end_folio;
> +		     new_folio =3D next) {
> +			next =3D folio_next(new_folio);
> +
> +			zone_device_private_split_cb(folio, new_folio);
> +
> +			expected_refs =3D folio_expected_ref_count(new_folio) + 1;
> +			folio_ref_unfreeze(new_folio, expected_refs);
> +			if (ci)
> +				__swap_cache_replace_folio(ci, folio, new_folio);
> +		}
> +
> +		zone_device_private_split_cb(folio, NULL);
> +		/*
> +		 * Unfreeze @folio only after all page cache entries, which
> +		 * used to point to it, have been updated with new folios.
> +		 * Otherwise, a parallel folio_try_get() can grab @folio
> +		 * and its caller can see stale page cache entries.
> +		 */
> +		expected_refs =3D folio_expected_ref_count(folio) + 1;
> +		folio_ref_unfreeze(folio, expected_refs);
> +
> +		if (ci)
> +			swap_cluster_unlock(ci);
> +	} else {
> +		split_queue_unlock(ds_queue);
> +		ret =3D -EAGAIN;
> +	}
> +	local_irq_enable();
> +err:
> +	return ret;
> +}
> +
>  /*
>   * This function splits a large folio into smaller folios of order @ne=
w_order.
>   * @page can point to any page of the large folio to split. The split =
operation
> @@ -4105,12 +4202,11 @@ static int __folio_split(struct folio *folio, u=
nsigned int new_order,
>   * with the folio. Splitting to order 0 is compatible with all folios.=

>   */
>  int __split_huge_page_to_list_to_order(struct page *page, struct list_=
head *list,
> -				     unsigned int new_order, bool unmapped)
> +				     unsigned int new_order)
>  {
>  	struct folio *folio =3D page_folio(page);
>
> -	return __folio_split(folio, new_order, &folio->page, page, list, true=
,
> -				unmapped);
> +	return __folio_split(folio, new_order, &folio->page, page, list, true=
);
>  }
>
>  /*
> @@ -4138,8 +4234,7 @@ int __split_huge_page_to_list_to_order(struct pag=
e *page, struct list_head *list
>  int folio_split(struct folio *folio, unsigned int new_order,
>  		struct page *split_at, struct list_head *list)
>  {
> -	return __folio_split(folio, new_order, split_at, &folio->page, list,
> -			false, false);
> +	return __folio_split(folio, new_order, split_at, &folio->page, list, =
false);
>  }
>
>  int min_order_for_split(struct folio *folio)
> diff --git a/mm/migrate_device.c b/mm/migrate_device.c
> index c869b272e85a..23515f3ffc35 100644
> --- a/mm/migrate_device.c
> +++ b/mm/migrate_device.c
> @@ -918,8 +918,7 @@ static int migrate_vma_split_unmapped_folio(struct =
migrate_vma *migrate,
>
>  	folio_get(folio);
>  	split_huge_pmd_address(migrate->vma, addr, true);
> -	ret =3D __split_huge_page_to_list_to_order(folio_page(folio, 0), NULL=
,
> -							0, true);
> +	ret =3D split_unmapped_folio_to_order(folio, 0);
>  	if (ret)
>  		return ret;
>  	migrate->src[idx] &=3D ~MIGRATE_PFN_COMPOUND;
> -- =

> 2.51.0


--
Best Regards,
Yan, Zi

