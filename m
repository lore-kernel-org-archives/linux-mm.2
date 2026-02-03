Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9A404E8784C
	for <linux-mm@archiver.kernel.org>; Tue,  3 Feb 2026 17:50:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E8E106B00AB; Tue,  3 Feb 2026 12:50:04 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E5FB56B00B0; Tue,  3 Feb 2026 12:50:04 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D173E6B00B6; Tue,  3 Feb 2026 12:50:04 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B50526B00AB
	for <linux-mm@kvack.org>; Tue,  3 Feb 2026 12:50:04 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 6BC90B9E28
	for <linux-mm@kvack.org>; Tue,  3 Feb 2026 17:50:04 +0000 (UTC)
X-FDA: 84403883928.15.4664251
Received: from SA9PR02CU001.outbound.protection.outlook.com (mail-southcentralusazon11013065.outbound.protection.outlook.com [40.93.196.65])
	by imf19.hostedemail.com (Postfix) with ESMTP id 523DC1A000A
	for <linux-mm@kvack.org>; Tue,  3 Feb 2026 17:50:01 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=ZW0+WarZ;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	spf=pass (imf19.hostedemail.com: domain of PratikRajesh.Sampat@amd.com designates 40.93.196.65 as permitted sender) smtp.mailfrom=PratikRajesh.Sampat@amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770141001;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=8NymC7Mj9AobvqmWhKZcegXFJMRLFRzlgPumSsWOszY=;
	b=mKqejaU5twFGlSQT7BCKnZ+k3vra8Bg0FP87DYKMcLEkxcUGBXqa8r43iLIXoYNP5jYf05
	shsS/4+LJ13+eATfcedSYm9V9BoiODsZIIbxaZleyE0pup+PiAMR/xG0ZRXgGcBHoxB/JV
	vuiIKuOstmsqpkGyOJhDsP+yPKefc/E=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1770141001; a=rsa-sha256;
	cv=pass;
	b=3gXkSRQwFf8TGCWzkY6akSTftTIcFjJ6ldw3h4qWQnNtysmDiFyrs6/51CaULuVuxBGcxC
	ogL2wKVrtCdxld1GJ5Eg66BQhGWsgLiktRZp3KeYC6nQXGZ8OcxSxJ704QLRXK7ggr+15A
	0Tl1yJFLiw+ZBRL6V6qOvQSzCQ58Mao=
ARC-Authentication-Results: i=2;
	imf19.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=ZW0+WarZ;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	spf=pass (imf19.hostedemail.com: domain of PratikRajesh.Sampat@amd.com designates 40.93.196.65 as permitted sender) smtp.mailfrom=PratikRajesh.Sampat@amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=RmUQYPN3cdAVeSsKCSf9ZN+xttlbM/n0zcl3CkNPTXf5S9flNwROVYBeBTDWZXQWw33j1BsxcG+2TCdOgnpDRQSbqAQq1n0UW51tdjEFndnNMfNVMsGeIbLxON3xPG3h4S6Hljk9u8NdwUWu92MwSjVY098R+ggikDNBtghAmfnU+Ng0Z61SZGcioXi7K2inTRt155JXab2urT/4r4Qgk5Cdu2eRGWMlYaRQAn8gtGcHPxoLkF79sn770b/QThHCRnz/cNND5EDi0YzTTYYqL8P/XpoeLkSNmrLgHLbuKdw9tGAeYcF9E73MRQeYOIt24j5Gz/4Jj0vflP7mZjkhnQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8NymC7Mj9AobvqmWhKZcegXFJMRLFRzlgPumSsWOszY=;
 b=UOYQSn3DSGm/HK37+i31fQ2nNZpu7S9jv6l6gSvD6HtjIDoCMSoHiIFxRgN961pCzPFTi/MSCcUEm1uJerwLe9scWXN6DsJWc5qq3ySAyuT3RGCCNK05bj4MrR1n+5yUvu9gwOut/l5uhQ6/7wbK0FbeaS4yZXtAqkVT9NycBst+czaS7vlXHnio8QHKvPo2VPLaSVWjHOBfGV5rBDaF/4e+69B8WjEv1fTZxlkR62dZiNEFYm4RNEhQ4tBcAV3KN65l2KwVHhjDQzVchrF5ulmmj2SgWsFpND6X1RK3d1kJjv/xZibtTrC8uQrbFCMmmYSLpO22GXy7QwZng4MZdA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kvack.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8NymC7Mj9AobvqmWhKZcegXFJMRLFRzlgPumSsWOszY=;
 b=ZW0+WarZbHFLbbGUrL7/AmDCOref1HMYHhEyrYGxVqqXxB/BqcBm1oCD3w1nLBNUsUMwj3hnoJ+wTOlSDDPVZsnmpQiUsNP4CoOSshyY2IfAUsuk0ddkT6J7gOJHxysUbufr8tm0h+sxw2UNFvHM5WSXrwomwPBF5A4zdYfKk5Y=
Received: from BN0PR04CA0097.namprd04.prod.outlook.com (2603:10b6:408:ec::12)
 by DS4PR12MB9610.namprd12.prod.outlook.com (2603:10b6:8:277::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9564.16; Tue, 3 Feb
 2026 17:49:53 +0000
Received: from BN1PEPF00005FFF.namprd05.prod.outlook.com
 (2603:10b6:408:ec:cafe::ed) by BN0PR04CA0097.outlook.office365.com
 (2603:10b6:408:ec::12) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9587.12 via Frontend Transport; Tue,
 3 Feb 2026 17:49:52 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 BN1PEPF00005FFF.mail.protection.outlook.com (10.167.243.231) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9587.10 via Frontend Transport; Tue, 3 Feb 2026 17:49:53 +0000
Received: from ellora.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Tue, 3 Feb
 2026 11:49:52 -0600
From: "Pratik R. Sampat" <prsampat@amd.com>
To: <linux-mm@kvack.org>, <linux-coco@lists.linux.dev>, <x86@kernel.org>,
	<linux-kernel@vger.kernel.org>
CC: <tglx@linutronix.de>, <mingo@redhat.com>, <bp@alien8.de>,
	<dave.hansen@linux.intel.com>, <kas@kernel.org>, <ardb@kernel.org>,
	<akpm@linux-foundation.org>, <david@kernel.org>, <osalvador@suse.de>,
	<thomas.lendacky@amd.com>, <michael.roth@amd.com>, <prsampat@amd.com>
Subject: [PATCH v4 0/2] SEV-SNP Unaccepted Memory Hotplug
Date: Tue, 3 Feb 2026 11:49:44 -0600
Message-ID: <20260203174946.1198053-1-prsampat@amd.com>
X-Mailer: git-send-email 2.52.0
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: satlexmb08.amd.com (10.181.42.217) To satlexmb07.amd.com
 (10.181.42.216)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN1PEPF00005FFF:EE_|DS4PR12MB9610:EE_
X-MS-Office365-Filtering-Correlation-Id: 29e566f9-510c-4b15-0465-08de634ca302
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|82310400026|36860700013|1800799024|13003099007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?n4VsYW15ZgLeBR4aDh7Q4BdI7MQ+PhhMPfC9I0lgUH6ESkYcbCexpH4aFDIg?=
 =?us-ascii?Q?AlUH5pjRN0tCYNK6Yy/UfSvrQdgZNzZBG8U32qB6Hu/MhtJvXshtAZhsCWqY?=
 =?us-ascii?Q?MsvPfG+70RYR8IPyxN56lVI+GWfOAaiuZi1yTC2ZQBvP+rUCLQJZbApEHT4C?=
 =?us-ascii?Q?Ibg0O15YGgSQCxhQM5qDs1LI/QFkrPVbW3hLNa8rg/lyPQalLH1nFu+OZCPd?=
 =?us-ascii?Q?Azjn83ULcvh5v7K1Hi1HuxmzTKoxe6MzCDkGqhItlKtY2WjgbFw19RGezR3Z?=
 =?us-ascii?Q?hYOenb3bauLWGU6woClfaqJFZJ/Wf4atPv2lA05W3FcpBDces6tgTjpKlQqW?=
 =?us-ascii?Q?+l+MLQtRv7PenscEc0XcPUXcjy1ir1fWxG9X3UvJOND/wPi7N2hnNcegmqJI?=
 =?us-ascii?Q?l1XxVAwsc85ARqjxDARniJxxdgQCuYuk0ml4dFjDhNEC1ngB6aFjykf6ijd1?=
 =?us-ascii?Q?O8h9iC/tLvLwlQiM8K8+ZtcwxQ6A0D9ykTUWzuSuDV9L+Q6qLSFh5y2tEsRX?=
 =?us-ascii?Q?2V5N62K5NjKxDQ/chiIKjkDtXVXspnIj8pm/+fW9UWAzBe05DQUa27BqLGGo?=
 =?us-ascii?Q?+Q+PSr661UkaELm36oVMIqnYtShY4sm2E8rMctonRXG4Et1+Co1WpDBiTdgu?=
 =?us-ascii?Q?8SdVVJK1E0q3+4T5rEtOsDXURsi1hMBKpjFE9kKS8YG77GSDRBcRcROkVpS7?=
 =?us-ascii?Q?WIZdW6oYD4j7Fz5pAz7pqOGiC8D4LhnwkM+KgTPnNfc5WSKmpWtc6S9i+3dX?=
 =?us-ascii?Q?XZ2q//h2XkAEmznmpmLAJLS/ZVvpMpCI1PTDKY6CqiFC5nvxr/z2oieG/0V3?=
 =?us-ascii?Q?nqEq1gQmqsxkVYQs0Q0itq4Js5v3cD47tSAZktFx+tme3Q38Y2KUWmAO0iAD?=
 =?us-ascii?Q?iFGW1dPjmAYSJnaa4sCWQCOIyHNSsb/f6ALNxe+FyZYNoOcDM8e7H13DA8kI?=
 =?us-ascii?Q?TcpSA6jeMEHdz3dtoMDy87Uv1KDcZaZPBZpNbnAyB+4Zwa0h23fFyGQn9vJR?=
 =?us-ascii?Q?MwfP02m3Y9vW3iL+q9RcPB6g6ZMAkzP+zAoCp3OOT4BQPkEs6dLs7VSJSIen?=
 =?us-ascii?Q?fx+DBXxKfe26HsKsLJNkRNIlXiBqNWwqiBtF/vwkgz/qGMhJ3HsP6bKjO/mc?=
 =?us-ascii?Q?hdxU/nxP20Vs1pL+rbqYPGfRT+hsOuz5s1IJyEhpb6t7MrRfytrn+NEmymM4?=
 =?us-ascii?Q?gLPfQ4h5MtXA1r9OAtTsHQw1/m5tqog2mfUtaEpj4OTWJTfgFS2gt4PFkSTk?=
 =?us-ascii?Q?hTYi/9Kcgt89tHsgkWjxNas4j4/J8QfAJeZ1HUW8mPWwzXWZwAUX+6jvu1LC?=
 =?us-ascii?Q?STlyX2RqMLOnn3TageP7DJ+OXkrnDBHDouD3UYWmp1v6MKLTeGJ2UeXLmMsA?=
 =?us-ascii?Q?Td4IdM+RoetVR4Mjylowal8Y6rEimtWvlFfGppcOEQuW0bmEcI2IDXeZz1un?=
 =?us-ascii?Q?rUD4urP7xZha//O7p5EX7funJH0QZXhdIbRYA+j/+9O8/YuLLSUEEkGRjNZc?=
 =?us-ascii?Q?Cu0faZHAaPYl7ZSDHeA9qILrXKz/txDAfRFMG1c/42A+na3mfLQOConT8ip5?=
 =?us-ascii?Q?TqtO/Ib7E1XP/a7/gaNn8mo0pFMdcyIs3YFvNFZ2BGouTp8BCj789HqaFWNy?=
 =?us-ascii?Q?7yndruP+n4AZo0BUnWZ8x8HO/m341Y/4P6fggDet/8rPtF/NUZF6Ctyk5dFa?=
 =?us-ascii?Q?Ss0AvHaUlP3m3cR28nk3Hv5l1dk=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(7416014)(376014)(82310400026)(36860700013)(1800799024)(13003099007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	Q8jIHeXisRi1Y2GXUwm8exsdDNKPHdKBeBg8snfoZL03U5WPrjcVZoObzrpgYIDTOGOGFAiIyo9Q+6z/orWhVjvgQ01d2ojs5rkZF9K04/7DHDBnBrhruIjFZe1+uomtq7gb+2+VgJ6eypjr9nF+jDzvM5qOb9FhkT0WjfhSYakHZPhHL2uZMxennFIZR5l6Q3P0JpJKyQo/S9Jbma8tTR+0sFJQbUVTZgqmYMQ57T+UUEWz8GPEAhIplOuBCt+SKaZSHyvvq3KFU9L5bD75iTPB97bjJCE1R5dGswWPO17SKtx5DSv9lZmfNRG21f/u/agYDshyS/Z901bkgCwy3wKzThDlffyMC44sv0ZuQ6np+b0sBRky14ceJjOQ7N4XpN4nnULcRS2W1tJFiv2aFhgSF8U1DLjd+8lutrED8ChUUEj8AfL3Wo+tJpY4V/Ox
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Feb 2026 17:49:53.6251
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 29e566f9-510c-4b15-0465-08de634ca302
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN1PEPF00005FFF.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS4PR12MB9610
X-Rspamd-Queue-Id: 523DC1A000A
X-Stat-Signature: ce7ax3hskork6ufr49zzwjb3ijgct56x
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1770141001-478594
X-HE-Meta: U2FsdGVkX1/fIxKSo5G9B9fVQ6b7L6HMVe5CgYbPYPKns721K+j5oQydu+XGNl+j8QhlMNmvwlY9ZMpn1L+iO4wUNv2cYOqM+QnHDm1ZY9XvTZ3lF7VcBHsg0t4AUyU4Rwe1mqQ4bckG+bz+eGL8L8Z97AbS12FLiVrGv7AGphqGea/4wHkg+t8xA2GEfjbY91d65f3Oy/vnzebnvmL4NCeUbhAXNbdUJ21N3u0WWcXvvQ1r3lYsmaI5Rm306HcqelRGfTllFjjYJPZDOVXJ2nwoWayTqHuqlutf4XfRzm8cwHyMuBbS5B4JTIY+KNcn3aN0S2L2blkoraQQocHWXKTJ1M/+dx4qiTa2ciiZdFnsYIBxDZ7/8GeJty+n+lUfqpl3RXj85BgJtuV9f9kYWApUykdmCm4zJ47oJg7vu3KjP+8NXVURcO6lbgSsLKjqsBEpalUXEKVH0wnSxgkmq1vZZusfGFxMgnPcYlgqIO0hqUx0ALwtFlnzQSY0oki3H0iyZJuuk4Yzo7TXt1wxjuWRCilvWJd69x+v/Jmr5Zj7yjQb3ZtcFQSITc06mpyhxnF15pPHmpzqn7z0pY5sevg/W5pR8gL+YFU9LamWJxSn8quSyVOhSXWR9+17TGGUdF8anhPpkwaw+FRRyjAUgs5hMt3p7MO+vQ9rP0I4rp1kEFgkSAWUqpRnG3qb9hzyr9J5PN1oQlcnfE6JC4LS+Xrmyc7qGWqwBUKbcX3IYQRKDS8omYKthQm6Kmu2T4KAvU8Q3QiNmbAx3iLZRSFPN48OlKsAZO8CA4JyETVMiMmYtegpQDwuZ0TtZvolpm+eShDfGKTBw6skiBd6uRxhDEis9z22Ojjrv/sf0AWPw1XuuhBhRUVKpLnXDfyYGJ70UWaTBJ0HA71EknQoGZCTs26yIr8ZvvSzSdiqFSgYr/3p33Lq2o6FZ+bgQ6C5dZGY4gRebl1w6iVcrkJRGAA
 T3NuN3fA
 NBe8KOnObzm1hzG7aslecjxGngHB4bvQ681B1F72tuaTMXQZaJA2xViqBl6tNw+fU7weUEDQHR3YYQA/+jxuFfzAdKHCBnOGcc5h/Xvpp3xjwPCq4Hgdya2S8BVhFEIQzHaUml4Yxd3QptWqGfnIb1O65TakaqgWnRwnmyetLlx8F8VFtVSr0ffA13EXLW1AcdFMD2oDdJK5tvfayg04jCPN4ogn1g6/OGFbfNhfe9UGlkQxAZxfprF0Fk0AyCjPXwkWBtNmRSIJD8bblTpXRuDOCFaj7EcRZtrFKXt9F7xJRspOMgo7MrcCdtZZmtvVlGfbMnTvgHWhJWbE9X5kEqHsjVC0yhBuXsdGVbG7WZMz2xwwkNtmctsJnhHT18IUJy4izedKplvTU9Br9zUznkR1fVRAsV6quDyHNSLiSHHrePiX/Qc7KqkFCpIa1/g5kC2AP7WM7h3Gg1MzHZFJXgRjY88QZ3z0g8Afctl36iaBFDd+7EhZ356QvwNH9y5TBcaXWQk/b5Bp2OuE4y9sFKJ+1vG6QYawiOxbPQ4U3tpgHxSqw3i9AsyMGBT/hv01Sb1/FK91paV0rjlw=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Guest memory hot-plug/remove via the QEMU monitor is used by virtual
machines to dynamically scale the memory capacity of a system with
virtually zero downtime to the guest. For confidential VMs, memory has
to be first accepted before it can be used. Add support to accept
memory that has been hot-added and revert back it's state for
hypervisors to be able to use the pages during hot-remove.

Usage (for SNP guests)
----------------------
Step1: Spawn a QEMU SNP guest with the additional parameter of slots and
maximum possible memory, along with the initial memory as below:
"-m X,slots=Y,maxmem=Z".

Step2: Once the guest is booted, launch the qemu monitor and hotplug
the memory as follows:
(qemu) object_add memory-backend-memfd,id=mem1,size=1G
(qemu) device_add pc-dimm,id=dimm1,memdev=mem1

Memory is accepted up-front when added to the guest.

If using auto-onlining by either:
    a) echo online > /sys/devices/system/memory/auto_online_blocks, OR
    b) enable CONFIG_MHP_DEFAULT_ONLINE_TYPE_* while compiling kernel
Memory should show up automatically.

Otherwise, memory can also be onlined by echoing 1 to the newly added
blocks in: /sys/devices/system/memory/memoryXX/online

Step3: memory can be hot-removed via the qemu monitor using:
(qemu) device_remove dimm1
(qemu) object_remove mem1

Tip: Enable the kvm_convert_memory event in QEMU to observe memory
conversions between private and shared during hotplug/remove.

The series is based on
        git.kernel.org/pub/scm/virt/kvm/kvm.git next

Comments and feedback appreciated!

Changelog Patch v3..v4:
-----------------------
https://lore.kernel.org/all/20260128204105.508855-1-prsampat@amd.com/
1. Unconditionally accept all hotplug pages and set bitmap for the ones
   that are in the bit range (Kiryl)
2. Fix implementation similarly for unacceptance and merge
   unaccept_memory() implementation within unaccept_hotplug_memory()
3. Use max()/min() when clamping memory ranges to operate in the
   bitmap (Andrew)
4. Fall through arch_unaccept_memory() for TDX platforms (Kiryl).
   However, retain the panic() similar to arch_accept_memory() since
   it is a can't-happen scenario for other archs.

Changelog Patch v2..v3:
-----------------------
https://lore.kernel.org/all/20260112202300.43546-1-prsampat@amd.com/
1. Account for cold-plugged memory at boot and introduce proper handling
   of the unaccepted bitmap during both hotplug and remove. (Kiryl)
2. #include<asm/unaccepted_memory.h> within memory_hotplug caused build
   failures on non-x86 archs (Andrew). Instead of introducing
   #if-deffery to have arch agnostic fall throughs, create hotplug
   specific helper functions since we now also need to take care of
   managing the bitmaps due to 1. as well.

Changelog RFC..Patch v2:
------------------------
https://lore.kernel.org/all/20251125175753.1428857-1-prsampat@amd.com/
Based on feedback from the RFC, reworked the series to accept memory
upfront on hotplug. This is done for two reasons:
1. Avoids modifying the unaccepted bitmap. Extending the bitmap would
   require either:
   * Dynamically allocating the bitmap, which would need changes to EFI
     struct definitions, or
   * Pre-allocating a larger bitmap to accommodate hotpluggable memory.
     This poses challenges since e820 is parsed before SRAT, which
     contains the actual memory ranges information.
2. There are currently no known use-cases that would benefit from lazy
   acceptance of hotplugged ranges which warrants this additional
   complexity.

Pratik R. Sampat (2):
  mm/memory_hotplug: Add support to accept memory during hot-add
  x86/sev: Add support to unaccept memory after hot-remove

 arch/x86/coco/sev/core.c                 |  13 +++
 arch/x86/include/asm/sev.h               |   2 +
 arch/x86/include/asm/unaccepted_memory.h |  15 ++++
 drivers/firmware/efi/unaccepted_memory.c | 106 +++++++++++++++++++++++
 include/linux/mm.h                       |   9 ++
 mm/memory_hotplug.c                      |   4 +
 6 files changed, 149 insertions(+)

-- 
2.52.0


