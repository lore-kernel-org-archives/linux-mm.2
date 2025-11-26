Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 277E7D1119B
	for <linux-mm@archiver.kernel.org>; Wed, 26 Nov 2025 21:09:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 854BB6B000D; Wed, 26 Nov 2025 16:09:25 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 82C296B0022; Wed, 26 Nov 2025 16:09:25 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 71B0C6B0029; Wed, 26 Nov 2025 16:09:25 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 60CDB6B000D
	for <linux-mm@kvack.org>; Wed, 26 Nov 2025 16:09:25 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 2E7311607B5
	for <linux-mm@kvack.org>; Wed, 26 Nov 2025 21:09:25 +0000 (UTC)
X-FDA: 84153999090.22.7AC7676
Received: from BL0PR03CU003.outbound.protection.outlook.com (mail-eastusazon11012070.outbound.protection.outlook.com [52.101.53.70])
	by imf04.hostedemail.com (Postfix) with ESMTP id 4F47A40014
	for <linux-mm@kvack.org>; Wed, 26 Nov 2025 21:09:22 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=Il2jdW2b;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf04.hostedemail.com: domain of ziy@nvidia.com designates 52.101.53.70 as permitted sender) smtp.mailfrom=ziy@nvidia.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1764191362; a=rsa-sha256;
	cv=pass;
	b=0WUSL7xbwHd/F4v/H+yLJLa7t0Vn/yTDi6mVyZk8L2nzd5/ReI+TlrvopCE3Ft06XCEZE/
	M2vq3ql/wntIGtC7tju8e0iSI+hvXOF0cz+ijEJJQsjwTo+HRW6bXaOC81Vxx5Zt4Zvg7K
	5c90Shjitq3jfr+yQHGseX2dqLJY7jw=
ARC-Authentication-Results: i=2;
	imf04.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=Il2jdW2b;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf04.hostedemail.com: domain of ziy@nvidia.com designates 52.101.53.70 as permitted sender) smtp.mailfrom=ziy@nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764191362;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YTKg1+bQk3tYAjdwC7wGNU1XeyS3eOeggIK46gauGys=;
	b=TT2r7jGgCbv68KW7EhC73HrIc5kcT9f1c2PAeof33yv7Ww7emqbd8Gu0/J+7ERoU81vmTF
	XmzixCk07z03dJZWW0pWZV/kFaI4VKL8VCyRGzGv+ZLIULIDu1+GAbTqLL3SGFxBxliv/5
	IWgu0laPy81sOxeBtPBPFMFjWysJMrw=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=prjFzoTcCjtpLguDbQDujjjrdJdmNDpZO4YFNzrt3mIwwCeyIbzJjaCl3WxO4a6g+S4Ld6PKNac5aOAWAhVfRjNu0AKP3s0KROVMP8eVY4FQ3ZW7iddYbePro43uhSIHYwWvIqWJ0XBOQ7nRqv84rJDbN3i+PMzlD1SBrU3Epy9EFQ/PnofwrklCR44AfQBb3gUvdTA+DeZWqBmifrsXr+q3VnTLgcfiuy0cVXNxy9G4BZIX1ZABx1ljXS+RPLhAZDkXVqGAEWOabz1rTbpnxg7+2bajxV2LkfiZgFK1KKxJebgaBJFT9l/oZ2uU+m0iGvlMhGl7ZwHvoRMRwMLiPQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YTKg1+bQk3tYAjdwC7wGNU1XeyS3eOeggIK46gauGys=;
 b=grzv9wWxpmwSMKHkVH0vu2zyierVs1JlHj4oIksHJUeG89xd7m4VHltj5/LoG2bnLS1FG1ghqi0JtJ7e24s0ti994BJ7sJQ89wA3npnheVU8XOMImUcyw8oCdeITJMSNZvNv11PQ+2VTCIp8iNAKku01Gk1EV+8rDs6ild08PTuOeWsjfzLKJTh3MTmapV27NmjsfNFv4KIwa7w6zHCkj1REfsoBKmQvxhu3siDKM6AhoR2Wo2oAmmLQ6Hj252YbyHGhYoTpPmpb4rLrF1gVYWcjyLqtsD4LQaC+YQoUrsToTkIHBl3Zj354MG20lUJOcgFhhRDxmzX3RQk65EqleA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YTKg1+bQk3tYAjdwC7wGNU1XeyS3eOeggIK46gauGys=;
 b=Il2jdW2bMCGf1aV+WHp1n+mm335eUrQP25Hh400oXZhmIe9qmffa+rIK7C+XZXSfpqfurFBCffHjh8Rdl+VdpEyN6g8lTw6ogDhtRF64BE8izru4ATqZU3wipkAUWgBCb6htMN9vtXcs0kg9BNsbkL/OCh7e3Tc1xvK/GCyKZVvOvEIYnRWsKx5ayOd3teNuYB7iiMdnLcsJdkBI9Lv7sPRuEP6T8ws7S10sHTVSFyRgiAlcYmjIxEozx6hbMvtNjILg8cjPWJlJT6s7H1Ab1/0o90Xzk6DlYCO+cauKeuVxcFN4lP9nFdlHAQZmHivGHxxM1BWhsECyLsI7gX9uqw==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 PH0PR12MB7010.namprd12.prod.outlook.com (2603:10b6:510:21c::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9343.17; Wed, 26 Nov
 2025 21:06:27 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a%5]) with mapi id 15.20.9366.012; Wed, 26 Nov 2025
 21:06:27 +0000
From: Zi Yan <ziy@nvidia.com>
To: David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Nico Pache <npache@redhat.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	Miaohe Lin <linmiaohe@huawei.com>,
	Naoya Horiguchi <nao.horiguchi@gmail.com>,
	Wei Yang <richard.weiyang@gmail.com>,
	Balbir Singh <balbirs@nvidia.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v4 3/4] mm/huge_memory: make min_order_for_split() always return an order
Date: Wed, 26 Nov 2025 16:06:17 -0500
Message-ID: <20251126210618.1971206-4-ziy@nvidia.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251126210618.1971206-1-ziy@nvidia.com>
References: <20251126210618.1971206-1-ziy@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BLAPR03CA0176.namprd03.prod.outlook.com
 (2603:10b6:208:32f::26) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|PH0PR12MB7010:EE_
X-MS-Office365-Filtering-Correlation-Id: af698b90-f809-48e7-f32b-08de2d2faa45
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|7416014|366016|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?OqT1EZJD5r78CiRmM00LDR8TosyAb8zsUJt4pTOUru9tdZ/H9y3utJ1HCq9Y?=
 =?us-ascii?Q?rF961y3dsi79CgEV7Xoh5GbZRPB0tCbKCjxpVf3nD+HQocB41Sd/ICO02FOB?=
 =?us-ascii?Q?WUClXE3rQNnpsFkNj8ZEnn5d+yRT8o5LFlyBKlPnengXI9V7VffkoG4cH2Iy?=
 =?us-ascii?Q?WNb0VwGe12cuXciSdyn6DgzVmGyhBuun6SunMIQE55gwZ4kTjA42Qd8688PC?=
 =?us-ascii?Q?gVZYOFRR9RHaBTbePbakDDm7+ztLuiuAlYCdnJDvKZWbpJ2H7XpeBI7Ctqsy?=
 =?us-ascii?Q?aljYnaLfFAOJY4GEMsl3xmxRNrJD/4tOqceSiwn3YsaCtxgP9n+z91rHkV4y?=
 =?us-ascii?Q?NLxfF6xeboDUokFkXvfmw9qhhy5ZKW3aZt+GKrqtFzJqdAy0F8poJTpCaRgA?=
 =?us-ascii?Q?bdKOhFs2D15mZF9gZ17psSgLflYdOp7QbA8XADbnwLXPZz7qX1euPNUKfy1g?=
 =?us-ascii?Q?fVexeaakM3r2FKXQOt+hii39P1+7/y2B8bBx+33F+mmabS9qcoVd3QSIKYis?=
 =?us-ascii?Q?AsruOb4YuBxiHCdD/x5/LMsq25MCULiC+6euVnagv21UGAahoqVHt4sMnVNX?=
 =?us-ascii?Q?+ylYMU7mJJz2Nb5eYOIuuhOl5G0L9Or8dtT04ykfVF6uPEMbqWYmuH5STS1Z?=
 =?us-ascii?Q?WiEdxnbMmXJI8ge5me8DnPTHL1vGILulBXzW4vCSWVtEul1H8v1kX6w4+/Ii?=
 =?us-ascii?Q?UV6XO+uFZ5dU4sYspEtDbji+1jw21QG5XftWh4NaEZzWYvEXtLFqlm1GLAUN?=
 =?us-ascii?Q?j7f/cvhYhvudiGKDvm7T+rSiPUMh3V0Q5dhZECpsviqt7/guE52vCC31fTVV?=
 =?us-ascii?Q?IGNOQkzrMT39KfPFvpweOPHaHeURbSlk4y0g10HkDolWuRToWlN0CDGr4QnA?=
 =?us-ascii?Q?o3Ie3dbBm+0kLqr+Lq2F6nwg/zJeFKGJN5Ylw5x/VwIfggE+liMm4ZnM/zfY?=
 =?us-ascii?Q?aZJMg3bsuQoROuegOY2BYNilGjHIHsZeLlRQUAS1qH4lh+k89us01UHgikp/?=
 =?us-ascii?Q?kTup4pSiO0s7V7LWUfIHGujX/iRLectneSRdEJMknSkuTgg+HLkh8TAU9sHa?=
 =?us-ascii?Q?9FvnowjsFtoRyK4x111MUJoIkKuewBl+qWz9IbM4q/ODDmzab5poxBcPZkpV?=
 =?us-ascii?Q?F452uIUBk2KqHm4aMpyJQ50igpq8CntivL0MWyNJbsJXrmbATxbLzwbGIgJL?=
 =?us-ascii?Q?Qkc1TKGeqJLINk4r3GlfYWI1PZXgIGqTFQIJX5bm/mEYz9kCQTiyUFxTyjUA?=
 =?us-ascii?Q?Tz4h0Npcfmi0NBCWUBcUbf2DFrhmknXKSCXQRjTt2+AfsB6eSLEC1L366FUm?=
 =?us-ascii?Q?l+7j0gPQYtXYHKWm7dxil5CeCogvWDNDk5q30c0jhUPMJelBKA/2NcOuluS/?=
 =?us-ascii?Q?Jr95QCHf0XhlLyatDoWj/+sF+CY6gY7uq2HJec/qKY2ojOfFTF7HwRNTyC3z?=
 =?us-ascii?Q?YuYWLZ3RX69b9JzpsexJqElnXSocvSeG?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?GUcGKz5M2MN1iSvUUMXVjBhEMpmG0C8r3S1qW/lBgh6y+TgNrFdCuPg+l4SM?=
 =?us-ascii?Q?MNBiw8dZCZXsAxvGlrDz7/izmvU/DvzV0OluseUoPqmS21mN/zIVC3owHe9b?=
 =?us-ascii?Q?0Yu7T4MBJLwOE4WNkQJxyELIus2q/22hrrO1n1VVKUJpm6ZXpys5yuzzaW71?=
 =?us-ascii?Q?JvyjgFDpSQq45zGh/+VlP4KiNkPicnuka9dyKQYgLrV6i4dyqITaaJ94rRGY?=
 =?us-ascii?Q?2/Uuf5O0+DC7tPcZJdNEycPFgI3CUGF8Pm2IgwiHWKTAy5H9C+BQvxpWRxns?=
 =?us-ascii?Q?Zl2EOmAIJlh2O46///RcmZ/vtmn2AzckAlt1WZD7b95wQDwN29SHBoakTIcn?=
 =?us-ascii?Q?JJfvBDdHDIi9NRa57uwiMv1a4CtVsq6QjUcyNeQS3UAL3hSrj2bC0CGr3wNt?=
 =?us-ascii?Q?bNZRzgrZEMWEskm3X7X3SmIF7/BDNprvtUOXQLGOH5+FSog7JKYud6GYvu56?=
 =?us-ascii?Q?8JbIIHODNjL+p53PXSWA9VX7fC44vuq6mRJ0Rck5nrakCeIUtMBSPMHsfL6q?=
 =?us-ascii?Q?hf5JfzcKOGPm9o4T0Wi9ud8Jh24jvB9t1vK46RowgcmLBiC9awAw0qrXtZ51?=
 =?us-ascii?Q?zw70YAR7+23zrSL6dvwyw8uWy4YA9oWQYDIt9Of2okIp/pcw+iDOebh1NBkQ?=
 =?us-ascii?Q?wJhI8mrVygCUcwuCCcqSsK3mf1wCLJn9v0EI6Yzh3JE+MoxraZB8ExrJ7Bwk?=
 =?us-ascii?Q?0haDvjhly91XX74EaqGuZ9qJhlIilCN0I5YLpXRFYhj87mogk9JQ6hdEpAe1?=
 =?us-ascii?Q?GgMQ4p66KvaQ0H5Q7VgvKlC06FuAr3pH2P8xIO3Aol/bzzDadJfkdDVD76/3?=
 =?us-ascii?Q?jeD9eLfl7wrF5I8GXHBho5UT6k3Bnz0BXxnvY3HJdMk/w7HisZCdxZW/IutO?=
 =?us-ascii?Q?EQGVByBUilzk4XHMCjdRPNbcnQZQ9UCXUa+VxVQ7tkN4bEK28e+74CNnw7/b?=
 =?us-ascii?Q?jwA+CEvck5+UiplK7xil4mkATnUfuPugngavIWQaVBgYdRCrtyC+tPc5trQ8?=
 =?us-ascii?Q?vXeDKo5eI1r4f7jiVBlRIbSThxe1mVnCqnWdIN3683lkS5zCJdzk8cXZ5wJ5?=
 =?us-ascii?Q?Adw0aY55AcCBC1Rsxz/iEXW09smJWqH7IO7sAKq6aYX8c1G1Mf2Zv6j4bVv2?=
 =?us-ascii?Q?9MJbv4Q0s4Ygd5yko+9VR8sL5iRYB0iNR/l+FuPJitOtQ+X9mhxx8Iwk1D7y?=
 =?us-ascii?Q?nKoRDiJ11mFjLSfNViMp7vnuKmWw1EMUB/uKzYovO99tCVRaOniZOUqkH4ED?=
 =?us-ascii?Q?vuOg5tslOCqhMm07EUOPX51bGEkJlHzKAJqAdlXeoTZEjblq9gR1wRl4dmMd?=
 =?us-ascii?Q?UgAJHTCGsYdRLQebD3vFFgTg9xC3NtgJL8pRoKx7nfOH3vXyZwyyPLY/Rt4f?=
 =?us-ascii?Q?mBRKmx48+P7ZtXKdpWoY3ASK6adSqJpaqv13E3PuARdzgQSAMMsUb5msnnEK?=
 =?us-ascii?Q?yCyIg/b+TG07jk+B8o/NRGahZNM6UftMq/Jp5aBNwSyzunQg76I6pJR7/xBj?=
 =?us-ascii?Q?shHP/ZFknuf5pPIrjzi3ICDP4cDUXEESMrPFiQixPGKrH5dVlupdlqgEkXYI?=
 =?us-ascii?Q?AFvaZBoBcJLCIx5uWDRVWzL/Pi20pZr/qkEdlx6E?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: af698b90-f809-48e7-f32b-08de2d2faa45
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Nov 2025 21:06:27.7756
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +immZI3PFYakdMY1nEfmArzFG928gCf+63iwVSr9P1DuOYx0w5G29MQ4OJkBzNBf
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB7010
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 4F47A40014
X-Stat-Signature: zaih1w6jrqyfi1uyg3ra54ktcsugmbej
X-Rspam-User: 
X-HE-Tag: 1764191362-894631
X-HE-Meta: U2FsdGVkX19r8NNXG7VWgH8Ujln0yhCxlBC9J45zKsA80j660bTPzlVCuDylplnuoDGOxX+8aBDB7JUYCHuq/iwLx7Pkq3Wr4oF9/MclWvINcTBWOE6vCTdEshWlZtbYife+erHrFhmxsi36dAJ5xyqZp6EzfoGy3CUqveJFQI3+NpeCjKlnCfRixIIN66Hne7Ts4NbXbQ8LjfyIeXjlCVPKbTVi/Si3F6Pk1qXXCBp13iryarERQgQb7L39+5jxU87yQDAXVm13RndxoVeKKNjuOlEWeJa9+E93M0TWvH+Vu322WKgJJard8sWWqBAob0I0NEww/qUqTIaS11BqOCHg/7vQqCch0XTKyP0kkuDwGYhGlE7GYwzKgPwONP01GlPJS6r2QiQ2J8sYG7DWLy99WlrIDeJX/ErrAcx5f99+fbz9/WR89RS+9cH166YxATz+Z0csZ+nkuthtKFlrITsSXTdD8h7hUeSLPRKv1ZnwWsH+uAUGjYdz5CmM0NfgEGr1LvIVaugYGEPN5LTgMoJpqle8JHE2idH9lxD6y20aXmO5J+FfQstiucUMq+4tgPGOLmfqBTI3wauh5zjtGk1fWvr4lUsbdFWsCYBPXfn1da7S1DE6Scn7prcCltbKCKkETMq1hEzhOdouQVXbwsJsGA4or40+u8z8WJVFQFzeFmH8t0p7+LAQxmT2OXXbdzB9C9Gl7VoFvBmqdxUIDzGxjZowehgjlqLW7nJtSRVaq4zKnBvtNoDF/p1B4lhJWyoirA2LrezYzaEgfxvRyTQg+tU0d0wu2jjzVEJFCGj3K6o3PJ4Wu9EnpivSoZELKMax31+lcpsq8i0NSsiTM8W9X4sFaMNUImpv8t1PfYdN/TvsWlwHB/cUdTrngdTS2dU0QFhEKxzIh02I6DU3g4ya5LZeARJP0ON0SDFRhCJzLwZb2CuQwIbBFtATZWpcyT92/qoitxH9pe10itf
 e7O8xvjz
 uEA/wKwHxiZiLErOQppVB16FGO4+iZOzvlIiWpzpEWas2KXobVQe47WBSvDZpRgR4zjNqo4TrOKc4DktoPeUSHx93y5JzA3qE+jlLwcCd6L9Aa5j6jbqC1+0qijim6nhCejG3VsA/HRGq2kTWKiwjTvt1CPp0UJbelayd6BxFMFSFmG0wbhLl8RsTH/4C3WDpxf5lS2e5rjeQD0cz7EsVYq4y2lgfAXvSe61J6npA/kbMJZ9JuFaf+XXXa5qQwPSIMWntnoogZXEW6+AtkAKH+RL9p6FuDxMgdxvPSfetLHCtnnDGl/eqZPKr2svnAksWUZ7YDXe/TW2SgEEhQ+FMqwrEB07ftTEp+B/HIkkeCbJZK4djLbF/j7ZBkEI7JxBGGiT9aYl5fz+VMBX+7X/nHSg3hDfM9dQ33SBEixFgksDwgPwnlX+amE8YxMljcHhMJEO/JLoqOxMBIOmH1KqG5D7NSuY9B7E+597io85b9Vd2gz4kBxIUUx/fZvNlwoelq7C+iVu9xRNyvYymAsby+0+4FVMWFj98n8ng
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

min_order_for_split() returns -EBUSY when the folio is truncated and cannot
be split. In commit 77008e1b2ef7 ("mm/huge_memory: do not change
split_huge_page*() target order silently"), memory_failure() does not
handle it and pass -EBUSY to try_to_split_thp_page() directly.
try_to_split_thp_page() returns -EINVAL since -EBUSY becomes 0xfffffff0 as
new_order is unsigned int in __folio_split() and this large new_order is
rejected as an invalid input. The code does not cause a bug.
soft_offline_in_use_page() also uses min_order_for_split() but it always
passes 0 as new_order for split.

Fix it by making min_order_for_split() always return an order. When the
given folio is truncated, namely folio->mapping == NULL, return 0 and let
a subsequent split function handle the situation and return -EBUSY.

Add kernel-doc to min_order_for_split() to clarify its use.

Signed-off-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Wei Yang <richard.weiyang@gmail.com>
Acked-by: David Hildenbrand (Red Hat) <david@kernel.org>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
---
 include/linux/huge_mm.h |  6 +++---
 mm/huge_memory.c        | 25 +++++++++++++++++++------
 2 files changed, 22 insertions(+), 9 deletions(-)

diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
index 8a52e20387b0..21162493a0a0 100644
--- a/include/linux/huge_mm.h
+++ b/include/linux/huge_mm.h
@@ -372,7 +372,7 @@ enum split_type {
 int __split_huge_page_to_list_to_order(struct page *page, struct list_head *list,
 		unsigned int new_order);
 int folio_split_unmapped(struct folio *folio, unsigned int new_order);
-int min_order_for_split(struct folio *folio);
+unsigned int min_order_for_split(struct folio *folio);
 int split_folio_to_list(struct folio *folio, struct list_head *list);
 int folio_check_splittable(struct folio *folio, unsigned int new_order,
 			   enum split_type split_type);
@@ -630,10 +630,10 @@ static inline int split_huge_page(struct page *page)
 	return -EINVAL;
 }
 
-static inline int min_order_for_split(struct folio *folio)
+static inline unsigned int min_order_for_split(struct folio *folio)
 {
 	VM_WARN_ON_ONCE_FOLIO(1, folio);
-	return -EINVAL;
+	return 0;
 }
 
 static inline int split_folio_to_list(struct folio *folio, struct list_head *list)
diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 5ce00d53b19e..1a3273491cc5 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -4219,16 +4219,29 @@ int folio_split(struct folio *folio, unsigned int new_order,
 			     SPLIT_TYPE_NON_UNIFORM);
 }
 
-int min_order_for_split(struct folio *folio)
+/**
+ * min_order_for_split() - get the minimum order @folio can be split to
+ * @folio: folio to split
+ *
+ * min_order_for_split() tells the minimum order @folio can be split to.
+ * If a file-backed folio is truncated, 0 will be returned. Any subsequent
+ * split attempt should get -EBUSY from split checking code.
+ *
+ * Return: @folio's minimum order for split
+ */
+unsigned int min_order_for_split(struct folio *folio)
 {
 	if (folio_test_anon(folio))
 		return 0;
 
-	if (!folio->mapping) {
-		if (folio_test_pmd_mappable(folio))
-			count_vm_event(THP_SPLIT_PAGE_FAILED);
-		return -EBUSY;
-	}
+	/*
+	 * If the folio got truncated, we don't know the previous mapping and
+	 * consequently the old min order. But it doesn't matter, as any split
+	 * attempt will immediately fail with -EBUSY as the folio cannot get
+	 * split until freed.
+	 */
+	if (!folio->mapping)
+		return 0;
 
 	return mapping_min_folio_order(folio->mapping);
 }
-- 
2.51.0


