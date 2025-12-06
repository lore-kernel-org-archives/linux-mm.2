Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0C828D3B7D1
	for <linux-mm@archiver.kernel.org>; Sat,  6 Dec 2025 10:18:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6C4436B036B; Sat,  6 Dec 2025 05:18:12 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 675376B036D; Sat,  6 Dec 2025 05:18:12 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 563CD6B036E; Sat,  6 Dec 2025 05:18:12 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4260A6B036B
	for <linux-mm@kvack.org>; Sat,  6 Dec 2025 05:18:12 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id E02BF16045D
	for <linux-mm@kvack.org>; Sat,  6 Dec 2025 10:18:11 +0000 (UTC)
X-FDA: 84188645982.17.C69169A
Received: from CH5PR02CU005.outbound.protection.outlook.com (mail-northcentralusazon11012015.outbound.protection.outlook.com [40.107.200.15])
	by imf07.hostedemail.com (Postfix) with ESMTP id 14DE240007
	for <linux-mm@kvack.org>; Sat,  6 Dec 2025 10:18:07 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=IiMoLUBC;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf07.hostedemail.com: domain of bharata@amd.com designates 40.107.200.15 as permitted sender) smtp.mailfrom=bharata@amd.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1765016289; a=rsa-sha256;
	cv=pass;
	b=bAF7oTnvnTl3eRPkJlW7Dr3/zWitPuKwGB902gfoFVfPCsvbMr9wlUPMbU4ryKyXLukKIE
	HmRxTncOY9CLr/jaDvHc7IkriGtcaObrCcTOIAuLDZ8zWQ0WwaLzemEUy/7H44QL5QMM4T
	VWubp5h1LIT/Iga/HgfXWQ9PG83G1mI=
ARC-Authentication-Results: i=2;
	imf07.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=IiMoLUBC;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf07.hostedemail.com: domain of bharata@amd.com designates 40.107.200.15 as permitted sender) smtp.mailfrom=bharata@amd.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765016289;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1mtr/yUK/fFN8x0gOs384tjd1y//9IFDajUEaKF5ZMo=;
	b=v8eiMBZvHnECncLp2OqtxZsxJYmtoriXxloPOZQRywgS+DKUnHfUAZM5TM0mYcGJiCXlVM
	/nEV3Pck+dNqAvCJYzq0R2kyr325hK90lIkXMidKT/t/4G8R2xcRc88kGuj1LwqiUpjXXR
	EgF2jw1nm6BSRyGRrwngrNNlxohS1vI=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=h8sz6ZaMoKAOnWl7IUcH9A9QTdo7JJAlEKm6qNfuueOL3dULbWt+RRECiF/MPkqBjzRE4CtA1mu8+4vgEcMH/TEfCv4HViS/etoiL4ZCJ9F0WpUYo7o1i1Izc/Q9cmPwhYqszAUXjl8skYvtpFKXnuaUBse6qZ4xygn9ci0iQDEujv+nJTu2vSm6YnUIasr/0N3/dlajbB+QyAxLU9WQ3sv+2FCUuF7dhdWgxuPfvWYiPUItlgkaoCodrzyulT9yD+wlsvrM0Q9iuwTM37DFxiufq4eQ31mvBkkD/UwCXTgGtOyX2u8xoRo9kQO/wZtO39pFAbKEdtdiTUR06D7MEQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1mtr/yUK/fFN8x0gOs384tjd1y//9IFDajUEaKF5ZMo=;
 b=RrRo9ip34k/kxXjsBaqlft5yieIsJ8/03DhpQI18TWukTz8obV0MbxDIVTTbX757ib5YjCdE4e25TpAm/+gMhsX3wV9vGkrcc4c0Q93EjK5Nmq7jVMaRuUpHkpsqNBZ6ulduVWGcBHFRiIpBO2jrtQ+nZFIWI1ccZC4aujVmkqDzfbL10KwfXylewyHYunzzZZVi+KVct+vDHSvy6Id2lzIt9Agvi6Xsqmxxs14AIJnMAteSI2IiHmmmKdn+3tLGU0oc2gb8YAz5H/mg8HxsUuY/151uKR3n82vtA+PbLP4Bi+2LtblGhH2yDjCq1haKYuKoySc54Eb1fQcjKOf+Sw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1mtr/yUK/fFN8x0gOs384tjd1y//9IFDajUEaKF5ZMo=;
 b=IiMoLUBCKC86VFyemfWzU5aZ8atfbhHeznTOXATFZ9Zbds3OTK9h+UXYtUBxxTiiT1F7m/DOjrhacy9Z0jzqrsKlUsScbP2KX3Aq1DO15bwP9mGxzHuDeHHA/JFqWoGv4VoR6oHog81eJfj1xfTlcVqJuEU7d1jIUbKAzD/xMSM=
Received: from MN2PR20CA0010.namprd20.prod.outlook.com (2603:10b6:208:e8::23)
 by DM6PR12MB4123.namprd12.prod.outlook.com (2603:10b6:5:21f::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9388.9; Sat, 6 Dec
 2025 10:18:04 +0000
Received: from MN1PEPF0000F0DE.namprd04.prod.outlook.com
 (2603:10b6:208:e8:cafe::11) by MN2PR20CA0010.outlook.office365.com
 (2603:10b6:208:e8::23) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9388.12 via Frontend Transport; Sat,
 6 Dec 2025 10:18:04 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 MN1PEPF0000F0DE.mail.protection.outlook.com (10.167.242.36) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9412.4 via Frontend Transport; Sat, 6 Dec 2025 10:18:04 +0000
Received: from BLR-L-BHARARAO.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Sat, 6 Dec
 2025 04:17:57 -0600
From: Bharata B Rao <bharata@amd.com>
To: <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>
CC: <Jonathan.Cameron@huawei.com>, <dave.hansen@intel.com>,
	<gourry@gourry.net>, <mgorman@techsingularity.net>, <mingo@redhat.com>,
	<peterz@infradead.org>, <raghavendra.kt@amd.com>, <riel@surriel.com>,
	<rientjes@google.com>, <sj@kernel.org>, <weixugc@google.com>,
	<willy@infradead.org>, <ying.huang@linux.alibaba.com>, <ziy@nvidia.com>,
	<dave@stgolabs.net>, <nifan.cxl@gmail.com>, <xuezhengchu@huawei.com>,
	<yiannis@zptcorp.com>, <akpm@linux-foundation.org>, <david@redhat.com>,
	<byungchul@sk.com>, <kinseyho@google.com>, <joshua.hahnjy@gmail.com>,
	<yuanchu@google.com>, <balbirs@nvidia.com>, <alok.rathore@samsung.com>,
	<shivankg@amd.com>, Bharata B Rao <bharata@amd.com>
Subject: [RFC PATCH v4 7/9] mm: klruscand: use mglru scanning for page promotion
Date: Sat, 6 Dec 2025 15:44:21 +0530
Message-ID: <20251206101423.5004-8-bharata@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20251206101423.5004-1-bharata@amd.com>
References: <20251206101423.5004-1-bharata@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: satlexmb08.amd.com (10.181.42.217) To satlexmb07.amd.com
 (10.181.42.216)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN1PEPF0000F0DE:EE_|DM6PR12MB4123:EE_
X-MS-Office365-Filtering-Correlation-Id: ce9f85ea-b85f-456b-b5ca-08de34b0be65
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|1800799024|82310400026|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?0/e/Qga7mE/sQ24p0r1+KdNnCvn2GEX9JTPbB7sGs/P4dtqGz0srEwqC2NfC?=
 =?us-ascii?Q?Y4N+u8o4d/faOAJwbpd9d6YV+cCvlhjAF3d+sQgxmAnRFusUcIe1O5AwDoNe?=
 =?us-ascii?Q?ZmhWVrtGOR4ovc8gXsquxsQUtM6ro8eI9GqzY3cFSyFUaFCy6a5NzrvuPMi3?=
 =?us-ascii?Q?F5/HvTV7I5V54sDGkYWqr7Sv+hCNTYhXAe+5JGE8yHHeWDdy1GNxzL0Bcba0?=
 =?us-ascii?Q?a8WidSfmAif0vXWuqHXqHAQLFV+aJATOIPjyUjlOmfRcWlhp3sOvpnZG06QC?=
 =?us-ascii?Q?/8F5bf64kWMw6Rjr6iPZL8r/L7QvX8mr27hi9JVgrEz0J9gnAZqgYhUrmNvM?=
 =?us-ascii?Q?uJTlv1XqVQZEpDVxAgWBz1a9jxppTIdaqlMbxNry7wmWJw0/kWW/RyDsMO0v?=
 =?us-ascii?Q?IVrVluCASF8cGFmX09OhDoUS85NWEaC1R2kkjHpuwgLswYwSqUJNsIn5hhPs?=
 =?us-ascii?Q?SnME4rCRBBMjv7/sLFCg1lrxpXPGjWOAvZBUCK/Y0QY3W4itxvmfv9EGts7n?=
 =?us-ascii?Q?/qM9ktYHZbiiwQlJNgQjWfCl/mRaepAa8A1dQ7cm0otC/VnIZIdKkaxSLCsM?=
 =?us-ascii?Q?V4mkJfuJvkE6hHu9DusBZBrwo6eTllAIVXbWHqGXiyhFfJJPdvR51nAtnwSO?=
 =?us-ascii?Q?extz/w08MmjLScCUAn6UpIvUUXwBpXCNwp5p7eo23N/B32+WOaoyqQ/rA9TG?=
 =?us-ascii?Q?1sQJiQ65iZhXOzf8DaU4YUu5LjCUCBTCrCpu+KxqgtMWm8yLYjfY6whPEedG?=
 =?us-ascii?Q?nNMXVFhy7UeFD8wRJLGJVdo8F+AW9xdYxHQLyj5bDa+W91jYKJ0urkp+KTlr?=
 =?us-ascii?Q?j1m3x7LxdHler++iX/+tCbRQ0MLAeFzRXNDmdOiPDgQyKRmwxuu+/6C4o6xt?=
 =?us-ascii?Q?VNTKISmDfXdMnJUksFpobHcmP14gO3zX9yMxQ3Q0Xj8t4nxzy79oC4tVI8Fv?=
 =?us-ascii?Q?8XCCUEQqH4hV3AfLbr8PP3Usyn6eDGAuS6i5480THLs5D3X0WWMlYCGxsVyw?=
 =?us-ascii?Q?UAvteuJX0pomOsbww7Fq61+PT6ZJ/8YAiZi66qfPGV5CRYG93q4vzD9b2zKW?=
 =?us-ascii?Q?haNvmK79lV/seZ1+WRBNFuzQMYpKirgB8g7vg7pGdNgtNbUiyOFILzSKAoCu?=
 =?us-ascii?Q?iqfWn/A1K/FKVfBeMrnZYfoFZ6z7X6Xjq1ZkPHb8ZcNhAyNJ2LfxjVbXJqco?=
 =?us-ascii?Q?9o4vM/tf5c470i8xXsvkqfYPHejACgtcyXbpL0qDtLQw6nja3ln6u+58oEJm?=
 =?us-ascii?Q?+TxvD19Q9VQNBh6kz5yhXWmyKCTdDd4Dw/JkWHXBKrU2VLnK+/rSp1X254Kn?=
 =?us-ascii?Q?byVHu7pMbgkSIGn/7R4oAW/sKY9DTbmAeFVWxQmBXw/C5e8lAIKdlB1E2HZO?=
 =?us-ascii?Q?6CgxB8jplIsGYQBtLkYyAA17KIJ1J98lF9MHhd5o6/JBvAtTKxwPhypybpD/?=
 =?us-ascii?Q?GEZaDXTgmCBjXi/DkqVqrH+AylqfYgkuvZ2QwEo/XYJ31jKsWxSXkL+96hWM?=
 =?us-ascii?Q?roahMDc5V0/pCXRuqEythNwBGnY50wuBQohbj0w7e3Hlqwvy7BAsTQGjZnWU?=
 =?us-ascii?Q?IJ+qrbkeYdskokUf1Ao=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(1800799024)(82310400026)(376014)(7416014);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Dec 2025 10:18:04.6054
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ce9f85ea-b85f-456b-b5ca-08de34b0be65
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MN1PEPF0000F0DE.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4123
X-Stat-Signature: nh1ztghsburi73wcuu5dkybtuezg6yo6
X-Rspam-User: 
X-Rspamd-Queue-Id: 14DE240007
X-Rspamd-Server: rspam01
X-HE-Tag: 1765016287-181724
X-HE-Meta: U2FsdGVkX18ZDL+5W3gPX6tZpmuUBQ6tx7lHw7L8NUIquANYhkLpp/Xt3LZmwaSLf5QgUTITvdg0MouEC6Z0dt0MuchApumkGVHwRvMsWwCs6PnorqzJDpkK1Y7Ldj6Hx1/2CXWwQFqlLEXScYoqSStUvoqmNO8Snx/vCgV30hWIvOofOf7G7wmZehKTDORpm30qRiBIwgk05U/BdPONglzuP0E5kINT+YhhjC5YA2Q1ydHqGBk60WdW42ntr/q7dd3Fumfp8zVJ6hmFwKS9y/bXL8CdCgeKl8h5LJX+Azb/kd5xCkW6Itr7s0aZRjzq6BFIsfeQpmUDsSZycRlAhsQA8+NE0T5bEyngJjoUARFK2KyhnA4sRN5Im8Aysqlo9kus7kjuYD/oRbpBme/9Vu7aLMqO3IjWZYXDx9paO7cgBOGYc4xVgCyIDOHJ6z98DIiDa6EE1vSOh4ctzHPFr3YXo7HvPmYTvnu7XkR3bBvm7AD+TVzxkubkVtx87LZF567qtkul8TaKnDlHlhdrNDSgy0i9ydoPW0LSrPRyizaedTbgoB7c2MT6mx83fwORP36ZatEDObJ8rId1A+HnUdnVgJnJDKKYI2adlWfko2fmK3lH9jX1xi1I3e5VfnwibGjqFd4MDPi0xkx4TBRddZw6j/YuTmyZpn3ZH10//sPNSeSrvQtAZ9bX8NFSn27qByd0y59mnP0cf14ojT6J8Vd06KnQTxbjanzFsrO6iCFYTsUAl6kVkG8UW5ySyEyfIoGUYdAdOWYf6KeTScuGvF05I8lNyO+exQGQbWJZXCg89XA/7BnAvEWbCuNJGM9m4pRbBfQwxz/+YJHZkI44sW5gkRFR3tB16wwN9psrrMgJ8KazI9bYfsue696PzxJZmG45GtxS7dy/oNFYFhbOHsnmFiosN2mWzH5zrC9rj7veK7HsuxljoNt9cplHcToNteXSRulPsZMMWoP3ILZ
 TXL3B+yn
 UXYDTAZSeiHzaZnjjORn9VF1H3wJQv3+E67VhOYX+j5fGb1EiOkrMHOab5IikxcUu1jDt/pVbZDMO53LKquAEME2tbyCkHUnxp5n4L7sJQVphgk3641sU/9PGRZp1xSaVejCYc1UUBXbooFNsFpXpaDr7e+zowXp2X7dw2CEMYKCbflWOKueBN+LhqzEB8dzSkmgvbTVIE8K5r47JnQxaOb4spJuMsnQZbbkAPQHJ8M1M1nFZ0M7UgdkQ8+AnHiR4NwR5sJxWWxk9M8hS9qD3sc+jhUGFUWmcb7aIt9KWr0Buem2RTTcH3DoSL6wIcNdUQDeCRGMLu8Q4BLSCq5NvaamX7TmCj/Kk8tbqi+Alw0OHnm0fkClyCOuk3k4zwomacfFrPjVCXivqpDAi27C5JfomDNg8IL3soSDLg+iba/3TRroj3oojr6PvHsqAb3wGNtcIloXz+3BWkxQF7U9XGGbyZaQSjkRKNzvC0bs3HoWEwZS9cv2YLT6yYj2exz4dIyNqKiLstDNENKvPIQCFP6QRmqZgvvloa2ecVQAlh3WxVmD9DWmOs3jM7Xj99Mp5TqK8qIqufh56Ay0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kinsey Ho <kinseyho@google.com>

Introduce a new kernel daemon, klruscand, that periodically invokes the
MGLRU page table walk. It leverages the new callbacks to gather access
information and forwards it to pghot sub-system for promotion decisions.

This benefits from reusing the existing MGLRU page table walk
infrastructure, which is optimized with features such as hierarchical
scanning and bloom filters to reduce CPU overhead.

As an additional optimization to be added in the future, we can tune
the scan intervals for each memcg.

Signed-off-by: Kinsey Ho <kinseyho@google.com>
Signed-off-by: Yuanchu Xie <yuanchu@google.com>
[Reduced the scan interval to 500ms, KLRUSCAND to default n in config]
Signed-off-by: Bharata B Rao <bharata@amd.com>
---
 mm/Kconfig     |   8 ++++
 mm/Makefile    |   1 +
 mm/klruscand.c | 110 +++++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 119 insertions(+)
 create mode 100644 mm/klruscand.c

diff --git a/mm/Kconfig b/mm/Kconfig
index 6057c96b9cd3..80221594413d 100644
--- a/mm/Kconfig
+++ b/mm/Kconfig
@@ -1403,6 +1403,14 @@ config HWMEM_PROFILER
 	  rolled up to PGHOT sub-system for further action like hot page
 	  promotion or NUMA Balancing
 
+config KLRUSCAND
+	bool "Kernel lower tier access scan daemon"
+	default n
+	depends on PGHOT && LRU_GEN_WALKS_MMU
+	help
+	  Scan for accesses from lower tiers by invoking MGLRU to perform
+	  page table walks.
+
 source "mm/damon/Kconfig"
 
 endmenu
diff --git a/mm/Makefile b/mm/Makefile
index a6fac171c36e..1c0c79fec106 100644
--- a/mm/Makefile
+++ b/mm/Makefile
@@ -147,3 +147,4 @@ obj-$(CONFIG_EXECMEM) += execmem.o
 obj-$(CONFIG_TMPFS_QUOTA) += shmem_quota.o
 obj-$(CONFIG_PT_RECLAIM) += pt_reclaim.o
 obj-$(CONFIG_PGHOT) += pghot.o
+obj-$(CONFIG_KLRUSCAND) += klruscand.o
diff --git a/mm/klruscand.c b/mm/klruscand.c
new file mode 100644
index 000000000000..13a41b38d67d
--- /dev/null
+++ b/mm/klruscand.c
@@ -0,0 +1,110 @@
+// SPDX-License-Identifier: GPL-2.0-only
+#include <linux/memcontrol.h>
+#include <linux/kthread.h>
+#include <linux/module.h>
+#include <linux/vmalloc.h>
+#include <linux/memory-tiers.h>
+#include <linux/pghot.h>
+
+#include "internal.h"
+
+#define KLRUSCAND_INTERVAL 500
+#define BATCH_SIZE (2 << 16)
+
+static struct task_struct *scan_thread;
+static unsigned long pfn_batch[BATCH_SIZE];
+static int batch_index;
+
+static void flush_cb(void)
+{
+	int i;
+
+	for (i = 0; i < batch_index; i++) {
+		unsigned long pfn = pfn_batch[i];
+
+		pghot_record_access(pfn, NUMA_NO_NODE, PGHOT_PGTABLE_SCAN, jiffies);
+
+		if (i % 16 == 0)
+			cond_resched();
+	}
+	batch_index = 0;
+}
+
+static bool accessed_cb(unsigned long pfn)
+{
+	WARN_ON_ONCE(batch_index == BATCH_SIZE);
+
+	if (batch_index < BATCH_SIZE)
+		pfn_batch[batch_index++] = pfn;
+
+	return batch_index == BATCH_SIZE;
+}
+
+static int klruscand_run(void *unused)
+{
+	struct lru_gen_mm_walk *walk;
+
+	walk = kzalloc(sizeof(*walk),
+		       __GFP_HIGH | __GFP_NOMEMALLOC | __GFP_NOWARN);
+	if (!walk)
+		return -ENOMEM;
+
+	while (!kthread_should_stop()) {
+		unsigned long next_wake_time;
+		long sleep_time;
+		struct mem_cgroup *memcg;
+		int flags;
+		int nid;
+
+		next_wake_time = jiffies + msecs_to_jiffies(KLRUSCAND_INTERVAL);
+
+		for_each_node_state(nid, N_MEMORY) {
+			pg_data_t *pgdat = NODE_DATA(nid);
+			struct reclaim_state rs = { 0 };
+
+			if (node_is_toptier(nid))
+				continue;
+
+			rs.mm_walk = walk;
+			set_task_reclaim_state(current, &rs);
+			flags = memalloc_noreclaim_save();
+
+			memcg = mem_cgroup_iter(NULL, NULL, NULL);
+			do {
+				struct lruvec *lruvec =
+					mem_cgroup_lruvec(memcg, pgdat);
+				unsigned long max_seq =
+					READ_ONCE((lruvec)->lrugen.max_seq);
+
+				lru_gen_scan_lruvec(lruvec, max_seq, accessed_cb, flush_cb);
+				cond_resched();
+			} while ((memcg = mem_cgroup_iter(NULL, memcg, NULL)));
+
+			memalloc_noreclaim_restore(flags);
+			set_task_reclaim_state(current, NULL);
+			memset(walk, 0, sizeof(*walk));
+		}
+
+		sleep_time = next_wake_time - jiffies;
+		if (sleep_time > 0 && sleep_time != MAX_SCHEDULE_TIMEOUT)
+			schedule_timeout_idle(sleep_time);
+	}
+	kfree(walk);
+	return 0;
+}
+
+static int __init klruscand_init(void)
+{
+	struct task_struct *task;
+
+	task = kthread_run(klruscand_run, NULL, "klruscand");
+
+	if (IS_ERR(task)) {
+		pr_err("Failed to create klruscand kthread\n");
+		return PTR_ERR(task);
+	}
+
+	scan_thread = task;
+	return 0;
+}
+module_init(klruscand_init);
-- 
2.34.1


