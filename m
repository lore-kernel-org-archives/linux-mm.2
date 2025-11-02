Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1537BCCF9E3
	for <linux-mm@archiver.kernel.org>; Sun,  2 Nov 2025 18:45:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 689488E0006; Sun,  2 Nov 2025 13:45:01 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 639D88E0002; Sun,  2 Nov 2025 13:45:01 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 528FD8E0006; Sun,  2 Nov 2025 13:45:01 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 412738E0002
	for <linux-mm@kvack.org>; Sun,  2 Nov 2025 13:45:01 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id C9D911608EF
	for <linux-mm@kvack.org>; Sun,  2 Nov 2025 18:45:00 +0000 (UTC)
X-FDA: 84066543960.24.F86E1CB
Received: from SJ2PR03CU001.outbound.protection.outlook.com (mail-westusazon11012040.outbound.protection.outlook.com [52.101.43.40])
	by imf16.hostedemail.com (Postfix) with ESMTP id E516C180002
	for <linux-mm@kvack.org>; Sun,  2 Nov 2025 18:44:57 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=YGKM+xao;
	spf=pass (imf16.hostedemail.com: domain of ankita@nvidia.com designates 52.101.43.40 as permitted sender) smtp.mailfrom=ankita@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762109098;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=+5mod4mxn76zK1A2rVV4hGb8xdoHo6pCM0dFY826oqw=;
	b=0kdkJL8sgg/chhQGJ1q6onG4AS5FsOiGUbqA4agcOikuzpsE3ME2bpxWqMfcC2GkjLaLGt
	w3AVf0DY4oMPVdTMslQdbLhRcHh4o7Jci+QiHO1W6EiYe3lehWWFyHnWOo8BGbVz6uCBT1
	c44SGJlifKlaOkG9W1WxfBd+etrQlnk=
ARC-Authentication-Results: i=2;
	imf16.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=YGKM+xao;
	spf=pass (imf16.hostedemail.com: domain of ankita@nvidia.com designates 52.101.43.40 as permitted sender) smtp.mailfrom=ankita@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1762109098; a=rsa-sha256;
	cv=pass;
	b=EHHdhns9pI5halqG8uxSQT2zANqwFJOX7RE5oKG5RtNKLhKguU0YPObqoUBdlrHFdw8GeN
	zN/79IN0LccL3xSFQNzBpY0a4/Lzq9FfLGQ/efVqWEQvq3T86rK1H8at4HWZkmfTarOAbf
	CVB57HGrnPaeZUwqK/CDeVorbFzas9U=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=SUnkN+dHyQPGqJ4lnDLcEQoX+BNi6QIpUWrOJIUl6XcfmJRkPU4rUHYksx9SlzyZ05C2A3uAKsmH1FnCwH45cgBlWLoVj+FTOVJxx4ZHzyJ5a9XA4Fp1qOjCG8iYVweGRmyt/aeCFBISOn0mxyrU2s3oSN0sVZ7JnWYuH+iBLpSk3cwr5w0Nja+24FSSJZuyGF7To7e51HUoBsaU+KK44GE1PQlTK24d0/oPy359Rrc0wUOA48aQitAusrmpYmmPE5Wq5vKhzCaZ+AEE/nLaWRfrQpTVugGAjSjIBcvK7ROFKIF+W06/4Sx+S7m/sjoNvzvPIiZzGocWM1EZziW76A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+5mod4mxn76zK1A2rVV4hGb8xdoHo6pCM0dFY826oqw=;
 b=usAq0K80W1/jyyDDPy+kwDWszBt2+nGhp8vPfqoRQjblHmJ3Wm/zB4qBpCtmgntAuRZWcbSF9/mjsBxvtBTC5EtaophGguxvzLh+Ob4FBj3qWFbbLtkExCQNPT+TbABmY/nDbGzS352mpwrrcZwXYUPooWzQG0n7GMhLGI+TqhS8hSDozZVqm90Pahj1BWN1XWEeitXRSZvyCQLcHZUHct1ao6iJDRGz1UJrLe1wnkpceM8SCMAJxT1Zh/oT2Hwmwh1+qNENZfxqxtrS48c3L9bfY0F3eNSRakIKU0bDR+69Mj7jCDX3AGiYpSZ0MvFJWsLbjEj4Cdkmd34+eUWssg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=intel.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+5mod4mxn76zK1A2rVV4hGb8xdoHo6pCM0dFY826oqw=;
 b=YGKM+xaoZYP4ENlifwBia0E0VFo1qBO9J+unuj5OPAkhzEVKjSQ28XH5cnzP4veCxTQlNDWxL9fWUDYjyytQltmK+14vkSUe6+E49fvhS1oVXHrb5EOsPPv+FC5iQb3blRg5CLCgd05ePIb4FGEM8t8CkuIth2Hqylpbix9Y36luTeHVlKL/34MJCFFyDwRgh3PPWjgBoLOvhJEbDVH2aubi0HGONaZVZp7iUlmcFZsbLNNMoemjNCXcwWWK7b3X/o0mIppCEiVPQLh9DJ8sG/mlab4gHSniUAiz+3fXk6qZ1Z5tDwGw/gKjxYxIlXzDjooQnDb3fT6G7j92PedRFA==
Received: from CH2PR18CA0035.namprd18.prod.outlook.com (2603:10b6:610:55::15)
 by CY3PR12MB9654.namprd12.prod.outlook.com (2603:10b6:930:ff::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9275.14; Sun, 2 Nov
 2025 18:44:51 +0000
Received: from CH1PEPF0000AD80.namprd04.prod.outlook.com
 (2603:10b6:610:55:cafe::7c) by CH2PR18CA0035.outlook.office365.com
 (2603:10b6:610:55::15) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9275.16 via Frontend Transport; Sun,
 2 Nov 2025 18:44:45 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 CH1PEPF0000AD80.mail.protection.outlook.com (10.167.244.90) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9298.6 via Frontend Transport; Sun, 2 Nov 2025 18:44:51 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Sun, 2 Nov
 2025 10:44:41 -0800
Received: from rnnvmail202.nvidia.com (10.129.68.7) by rnnvmail203.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Sun, 2 Nov
 2025 10:44:36 -0800
Received: from localhost.nvidia.com (10.127.8.12) by mail.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20 via Frontend
 Transport; Sun, 2 Nov 2025 10:44:36 -0800
From: <ankita@nvidia.com>
To: <ankita@nvidia.com>, <aniketa@nvidia.com>, <vsethi@nvidia.com>,
	<jgg@nvidia.com>, <mochs@nvidia.com>, <skolothumtho@nvidia.com>,
	<linmiaohe@huawei.com>, <nao.horiguchi@gmail.com>,
	<akpm@linux-foundation.org>, <david@redhat.com>,
	<lorenzo.stoakes@oracle.com>, <Liam.Howlett@oracle.com>, <vbabka@suse.cz>,
	<rppt@kernel.org>, <surenb@google.com>, <mhocko@suse.com>,
	<tony.luck@intel.com>, <bp@alien8.de>, <rafael@kernel.org>,
	<guohanjun@huawei.com>, <mchehab@kernel.org>, <lenb@kernel.org>,
	<kevin.tian@intel.com>, <alex@shazbot.org>
CC: <cjia@nvidia.com>, <kwankhede@nvidia.com>, <targupta@nvidia.com>,
	<zhiw@nvidia.com>, <dnigam@nvidia.com>, <kjaju@nvidia.com>,
	<linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
	<linux-edac@vger.kernel.org>, <Jonathan.Cameron@huawei.com>,
	<ira.weiny@intel.com>, <Smita.KoralahalliChannabasappa@amd.com>,
	<u.kleine-koenig@baylibre.com>, <peterz@infradead.org>,
	<linux-acpi@vger.kernel.org>, <kvm@vger.kernel.org>
Subject: [PATCH v5 0/3] mm: Implement ECC handling for pfn with no struct page
Date: Sun, 2 Nov 2025 18:44:31 +0000
Message-ID: <20251102184434.2406-1-ankita@nvidia.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH1PEPF0000AD80:EE_|CY3PR12MB9654:EE_
X-MS-Office365-Filtering-Correlation-Id: 3ab94818-134d-4f46-5e3d-08de1a3fe855
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|376014|7416014|1800799024|36860700013|13003099007|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?T/ukPz/B7b0N5PJ+dogl+ApB+YFM3idxqeV70b9e8lG7Xfbvt/urQw6uFi1N?=
 =?us-ascii?Q?BSnqOgUMwyOYwHOf4xyzScN8vfZR6UpHZz2bwFCwngBt9Y2/k2RJnnO0cpNH?=
 =?us-ascii?Q?k6pWrb4TKHotMM6GgKRWi6CzwDcHg0thr87Xd4Ier3d32dmC+wdTWkkuR4tb?=
 =?us-ascii?Q?ngwkofiw49Dr+gFsXe1QMxcJoKv3EL9PJaoLA5AckQvUThVZpLEoR1QLBRbW?=
 =?us-ascii?Q?3W7gqNeagKcprOkRZFhQucuiwOww7+HCBkvq1+LLO1TL7s9mVZfsA9OOg7Sn?=
 =?us-ascii?Q?7fGDFcCKBPvC0797E7l5UXgQitBc19LBOZINa0W5DnRhvTY0Ju0VRnfDNKLC?=
 =?us-ascii?Q?skr3LcvwxMKB7fed11gb+GDzujWVmDGJ+41PCfGFTy7SV4cCAW9pEXUqVPEo?=
 =?us-ascii?Q?tF4LKmK2Xlm1u6lJ1mm2RugJGhjN77G5tCcMP1mRs0nei1Wy1Gi7uWx92ONg?=
 =?us-ascii?Q?itfRRhqMZfHfXC/4ly7Fy+9ohLumpO24KLCJxt3oiUGMdD9UrLe1/MEDxXI4?=
 =?us-ascii?Q?aEtNNOYDVurhoTC3IoZlh4xBQz/HiOhI8iFHgB7ARSlR9S7u3F5exFOG3zHQ?=
 =?us-ascii?Q?LGoDli40BYl4NOg1Q0Sr8cHS3INmcJ5qYydhvRYZ1AL259LsaX89rpejJkGU?=
 =?us-ascii?Q?88Ytt3Ssjt5ukwWYoyDFxO1R4Jj2O92MTt2omwL7DChk0uswlg7BhAa4xvot?=
 =?us-ascii?Q?VPTBnRqg7Zhs3bQ9Cl2uGmGKCW0cECCghRTfQjM71MF+4TOlVZBy9JfNTuGR?=
 =?us-ascii?Q?RmMv+8n2Nqezf3Nb7xd2zmalfbdPzvMQWo53m0cbbpYanUq6P+s06csm49ft?=
 =?us-ascii?Q?gvp8jchtaQcMZnNtpnTH219obvSyYYDFDINA3NJk15wZKUnMtkF9VJ+RoOAt?=
 =?us-ascii?Q?eGk9DO5O/AH+bxgKefQ4z1uiSMYS/pQjDl62CyBEa8kkvMyvbULZEbkwS9Vx?=
 =?us-ascii?Q?ELYaPkNZo4/fZwck/rQ0b6KNXGci9TtsVXkTz9fuR8A0c+xOeEgQLXNXAuZs?=
 =?us-ascii?Q?JlS7gJcv+GF54wRYk8Oc3h5aYs1YcMtygOKJ5Gi7rd+VDOGJxXk3yiO2WV5v?=
 =?us-ascii?Q?0BxuCcHezIt0N87zaBM5gpjXIAf5eHoV6tEwHB9di/6wM+7g1JenvjZhQJ2k?=
 =?us-ascii?Q?WMCmoK2ANwd2VvgodqGKKixGD4GLnI0jns3FTLEbRrCdJuitnbFDLtmOsaUl?=
 =?us-ascii?Q?/tTngfw7AuRcJe6FNjqk7YGWaybj7myNIyS8SRTL2YNXGgSGRA6M74AMir3W?=
 =?us-ascii?Q?IGGbDkzZ0BUNFqa/CRx5x/atZ5cZfvJmsQTUIWLzuyxF8sJC/KLe9fy9QS6V?=
 =?us-ascii?Q?2AHv9JZbkQtOZxQWK+oEw4sGFPKeWxRvPbTzrVODn4AOFigI/e57KNM2+s2H?=
 =?us-ascii?Q?4yePNh3AeN7ZA3o3PEy2N5gGbmBpANP0FJCyUHtUZR/6fNilzYW8Y1dxuGHr?=
 =?us-ascii?Q?fFTvBaBjzqgyZl5//Mqr9fNogBBcr3G/gY8HvtnBcv6OWRNJXteS+iWAxtvI?=
 =?us-ascii?Q?xNvSR0Z5D8ln/hkEFK/BlczN+RJcFV3CvP3UOyv8gare9GwSM/dzkeLXpwCW?=
 =?us-ascii?Q?uUOTGCJNSvGKtyBvXHfMHt2n0/8yIav9y1VptJIWJ1A2UW45MWScZRjYOFYt?=
 =?us-ascii?Q?xA=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(82310400026)(376014)(7416014)(1800799024)(36860700013)(13003099007)(921020);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Nov 2025 18:44:51.5676
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 3ab94818-134d-4f46-5e3d-08de1a3fe855
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH1PEPF0000AD80.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY3PR12MB9654
X-Stat-Signature: 5rag7i81e5ofdka4e9wr9ci413yukrmk
X-Rspamd-Queue-Id: E516C180002
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1762109097-985309
X-HE-Meta: U2FsdGVkX18YWH0AIKkmSzTHyUnBZoWOeBkZyllxFsji6bEEchFLvwA3HDnbpLF3AgxI02zQSOou54QSUMHyHl2i+Vt8WhbgLuHad+Gn/b3n+a+PvqJJrOeL0yzPfy0k+hoLnlAz1uIVw/AQmKVlaOu1hQ9SAQew4B8T5zo637yndQqvzQmNSfMjCFVuSXsZ98ju52+IhoU9UyeW0y0Isx9XhHgbZmTsXRvrYFQCkq6GnzgXDue+hRvcKgb3VA2XvR7bfzdoXpcIcZOXAd0XZFeZtpfvq9Vht2PLyv1PSWcyGohHanbBorw4yVqxE9unmH0/V8H9UUOMEFutd5wBsSc+7QEkeqYQ1/fwExio6sjnlZt+4ZDJNIJJMO7pzWrBqvPSCGtxBjyXrLqxsl0ZGu68YTUEX3gIyIelxMcqEJxEuoyP2wCgq7VuwUB7RU8RR+bBd9lnHlfd4ddAFMms836MpC/vtmND9lMFiCI9FH7gHwU78d/Pkn+Nt9BfB/rccBI+ppxOsREI/VP9VlkhnCPrcGNvhzX3+juiMVN5pGpkCIrAhMCx0kG6teefAi0n3Z1oAC5ayTJWXlgdWZbwPItyoTmrG+f5NWMs7nQZAxot4yttTLTurr68flDtcj5zsvsIn1oQM3WVsaFgDHw2W/0jXnLAUd4IqpkzmWaEmUvK3LvZc6BaG96CI2xbsSFfKdDXt6HsXgP/4UGQGGvg9yUxb7jvwwXUoHbqE/EFSm8Oekhp8XwI4ZfNAKQaywAcfaTaQ0s0IjugogXT5KDWUTa+ApZ2FmfbENLIzAKDeyF9uSD+AiqsINhDgnrbn1mkkFCKM4pJnvXJoS9fk6y4dhxVRLc15A9ldcsMjHPBP/dF2CrLrQza5QJPpL390/iOQilXp6WODVIpyDO/SI9V6TyeGewXPwUVRGY6ZEw2aVZbVJRRD9xzKjvMxWDTJOnEOxuuUwWc8F02HJQ4IKx
 mMqMUrGf
 g8kBPEaEUAi3BG4XhSrFoe/GGcRVmZGlVWgFYJMNJ/NbmOSpFEIPLU5uXd1/QqVsfhqkYoq7oDsPdKk+GwpJF3WPOd9WYvdYkz8imDLoT0TPYgEw6QijWT6aVmnNBNssrWrdCxWtk5KKuTBlF9dtC273AeToLJjpKS60Heg90ohJgH0HZ1H2/6/e44TCfOhabskkaBQ2RK7k2LwVQ50MC+ZSrKZVrQ6Gn4CTZL52cpllIKR7Kr37LjXsT7/yHjHcebMviAY9u4wrLAleji4MsmJ0p7RC/j7sRWPTVpp2Y4UT1RWz+ILsY/vqLobuHt1ATF7u1gnWG4xjqqwjWVfPPIququbnZpGGSAkwcjS21tklnzElkxpNdLeivNL9Lc6RmNozjUS79qFBpUvvoynxV5W14Gu8crE9t/ZVWdqHYtYXZO+PR48kL1QrbkPnYXSr36nUGKNNldbN6qkw=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Ankit Agrawal <ankita@nvidia.com>

Poison (or ECC) errors can be very common on a large size cluster.
The kernel MM currently handles ECC errors / poison only on memory page
backed by struct page. The handling is currently missing for the PFNMAP
memory that does not have struct pages. The series adds such support.

Implement a new ECC handling for memory without struct pages. Kernel MM
expose registration APIs to allow modules that are managing the device
to register its device memory region. MM then tracks such regions using
interval tree.

The mechanism is largely similar to that of ECC on pfn with struct pages.
If there is an ECC error on a pfn, all the mapping to it are identified
and a SIGBUS is sent to the user space processes owning those mappings.
Note that there is one primary difference versus the handling of the
poison on struct pages, which is to skip unmapping to the faulty PFN.
This is done to handle the huge PFNMAP support added recently [1] that
enables VM_PFNMAP vmas to map at PMD or PUD level. A poison to a PFN
mapped in such as way would need breaking the PMD/PUD mapping into PTEs
that will get mirrored into the S2. This can greatly increase the cost
of table walks and have a major performance impact.

nvgrace-gpu-vfio-pci module maps the device memory to user VA (Qemu) using
remap_pfn_range without being added to the kernel [2]. These device memory
PFNs are not backed by struct page. So make nvgrace-gpu-vfio-pci module
make use of the mechanism to get poison handling support on the device
memory.

Patch rebased to v6.17-rc7.

Signed-off-by: Ankit Agrawal <ankita@nvidia.com>
---

Link: https://lore.kernel.org/all/20251026141919.2261-1-ankita@nvidia.com/ [v4]

v4 -> v5
- Removed pfn_space NULL checks. Instead a wrong parameter would cause
a panic. (Thanks Andrew Morton for suggestion)
- Log message to mention kmalloc allocation error and the failure to
kill a process. (Thanks Andrew Morton)
- Comments with 80 chars.

v3 -> v4
- Added guards in memory_failure_pfn, register, unregister function to
simplify code. (Thanks Ira Weiny for suggestion).
- Collected reviewed-by from Shuai Xue (Thanks!) on the mm GHES patch. Also
moved it to the front of the series.
- Added check for interval_tree_iter_first before removing the device
memory region. (Thanks Jiaqi Yan for suggestion)
- If pfn doesn't belong to any address space mapping, returning
MF_IGNORED (Thanks Miaohe Lin for suggestion).
- Updated patch commit to add more details on the perf impact on
HUGE PFNMAP (Thanks Jason Gunthorpe, Tony Luck for suggestion).

v2 -> v3
- Rebased to v6.17-rc7.
- Skipped the unmapping of PFNMAP during reception of poison. Suggested by
Jason Gunthorpe, Jiaqi Yan, Vikram Sethi (Thanks!)
- Updated the check to prevent multiple registration to the same PFN
range using interval_tree_iter_first. Thanks Shameer Kolothum for the
suggestion.
- Removed the callback function in the nvgrace-gpu requiring tracking of
poisoned PFN as it isn't required anymore.
- Introduced seperate collect_procs_pfn function to collect the list of
processes mapping to the poisoned PFN.

v1 -> v2
- Change poisoned page tracking from bitmap to hashtable.
- Addressed miscellaneous comments in v1.

Link: https://lore.kernel.org/all/20240826204353.2228736-1-peterx@redhat.com/ [1]
Link: https://lore.kernel.org/all/20240220115055.23546-1-ankita@nvidia.com/ [2]

Ankit Agrawal (3):
  mm: Change ghes code to allow poison of non-struct pfn
  mm: handle poisoning of pfn without struct pages
  vfio/nvgrace-gpu: register device memory for poison handling

 MAINTAINERS                         |   1 +
 drivers/acpi/apei/ghes.c            |   6 --
 drivers/vfio/pci/nvgrace-gpu/main.c |  45 ++++++++-
 include/linux/memory-failure.h      |  17 ++++
 include/linux/mm.h                  |   1 +
 include/ras/ras_event.h             |   1 +
 mm/Kconfig                          |   1 +
 mm/memory-failure.c                 | 145 +++++++++++++++++++++++++++-
 8 files changed, 209 insertions(+), 8 deletions(-)
 create mode 100644 include/linux/memory-failure.h

-- 
2.34.1


