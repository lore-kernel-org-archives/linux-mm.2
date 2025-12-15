Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6FAC1D59D99
	for <linux-mm@archiver.kernel.org>; Mon, 15 Dec 2025 08:50:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C325B6B0006; Mon, 15 Dec 2025 03:50:38 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BE3266B0007; Mon, 15 Dec 2025 03:50:38 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AD2096B0008; Mon, 15 Dec 2025 03:50:38 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 9CCE46B0006
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 03:50:38 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 33D908B633
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 08:50:38 +0000 (UTC)
X-FDA: 84221084556.16.8E8B69E
Received: from BL0PR03CU003.outbound.protection.outlook.com (mail-eastusazon11012034.outbound.protection.outlook.com [52.101.53.34])
	by imf15.hostedemail.com (Postfix) with ESMTP id 562A9A0003
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 08:50:35 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=EoXkeA0k;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf15.hostedemail.com: domain of shivankg@amd.com designates 52.101.53.34 as permitted sender) smtp.mailfrom=shivankg@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765788635;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=95aXhXK168YJQ3T98bSDL2tnXRBYy0o0eONLNvVAD90=;
	b=uHCTQBofzjSN/6nFMRmueXkelFj0owjGUiF18HuFQgrAoMPqJpdvM7nvItimTnA8WisPsj
	CHRLeOnHJrd+zeP5lzU1iJFVMQ2zsCnFDLawoyL4UldZDD4kC1swDw8O+Zf//LvpLqTdCd
	PJ0GsOXKuM3wekF3pKkC6/AAg8TP9/o=
ARC-Authentication-Results: i=2;
	imf15.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=EoXkeA0k;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf15.hostedemail.com: domain of shivankg@amd.com designates 52.101.53.34 as permitted sender) smtp.mailfrom=shivankg@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1765788635; a=rsa-sha256;
	cv=pass;
	b=v94/RQkXCYz+K/0751xAMXySBPVOPzSlCSAvYLobpzuY5YxUmd6a/gr+KJD5qchOMYwsqu
	mjFPF98k7bg+CgveTRREqLACJBYrqMQuTAVIsYWjHT837sJKIK4xQE6Dnj03ewmK40PCXP
	+3gh2xyDT3qzFSdXiVSeFWo9hlOXos4=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=oSg8NaZTKwyF5QADiVLf4p6p4NwjBfgFRJHcB+Y7fPsThaqn0RPlUA0e880+dxc0BvDj+328qF/Fs0aHRadJi81rr/ric5NA2kgeLzd06VMh7IVOGyZ1bXD2QdjVYBDpLAYOzb9jus4TtMwW3schX0pEcVnmnA0B+ruQ0flay2J6G+M7att9FKSVNHloEsfSeuPRQ13OOc+DUH1NAxs8BG9keVFMRyRlgwEbPGLkctO8EmVmDRmQb22G7tXedTEW06L7Fyj+TcZyGRdFPYYtEmBrIKNA57R5gXfRj30WD0Xyum3proQNPyupbmIL+AsnREXXAcYJMTQ4P61haq/wGg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=95aXhXK168YJQ3T98bSDL2tnXRBYy0o0eONLNvVAD90=;
 b=qx0wqE8d+WcSTQpxynl/3WW+VA+T5PnxCa0h/1EqwIKabZnQc53OTja+A61slOlLpGoYtjZOJ0AkqSbHJ8QapiJXCtUEb9KaYaX/BgV1GJ330/NHLcCiGYT4Jtvh68mF4dUneZ2B4SK9ArKD36MNWaxMqUxdPinhFN/zbXy6obpsIAIYyUDcsV/07ZgnvkZet/oKhIbC5zTBGSFZSPBaGWyRractNkoj0NVuEL3idu/HNdcC1QFq2ywz9sI7lrKj8uAs1JDj3s62qCd0xVli1UgRFx07+QnCrvThZeTDTN6kDRxoncBjwODLGVqpIv1JKnJqzlrAK4hIpGBOAX16gA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=linux-foundation.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=95aXhXK168YJQ3T98bSDL2tnXRBYy0o0eONLNvVAD90=;
 b=EoXkeA0kk1vr3A4e/fPhjEtqtmsHjmlbfokY6knN2rmJ+srb9D3M0Nv0sTq4ZHUzGhETJaJOdkkRwLUL6tAoGYWGFUQkFmxh1IL0Qw64DghzPv1pKyaynve5aBFzyhvAlm4yLFSju9ezI69fbR+mAs9zlswx6uQN/8EuOttmYWo=
Received: from BYAPR05CA0088.namprd05.prod.outlook.com (2603:10b6:a03:e0::29)
 by DS0PR12MB999103.namprd12.prod.outlook.com (2603:10b6:8:2fe::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9412.13; Mon, 15 Dec
 2025 08:50:32 +0000
Received: from SJ5PEPF000001D3.namprd05.prod.outlook.com
 (2603:10b6:a03:e0:cafe::4f) by BYAPR05CA0088.outlook.office365.com
 (2603:10b6:a03:e0::29) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9434.6 via Frontend Transport; Mon,
 15 Dec 2025 08:50:29 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 SJ5PEPF000001D3.mail.protection.outlook.com (10.167.242.55) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9434.6 via Frontend Transport; Mon, 15 Dec 2025 08:50:32 +0000
Received: from kaveri.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Mon, 15 Dec
 2025 02:50:26 -0600
From: Shivank Garg <shivankg@amd.com>
To: Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand
	<david@kernel.org>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
CC: Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>,
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song
	<baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, Steven Rostedt
	<rostedt@goodmis.org>, Masami Hiramatsu <mhiramat@kernel.org>, "Mathieu
 Desnoyers" <mathieu.desnoyers@efficios.com>, Zach O'Keefe
	<zokeefe@google.com>, <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
	<linux-trace-kernel@vger.kernel.org>, <shivankg@amd.com>, Branden Moore
	<Branden.Moore@amd.com>
Subject: [PATCH V4 2/2] mm/khugepaged: retry with sync writeback for MADV_COLLAPSE
Date: Mon, 15 Dec 2025 08:46:19 +0000
Message-ID: <20251215084615.5283-7-shivankg@amd.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20251215084615.5283-3-shivankg@amd.com>
References: <20251215084615.5283-3-shivankg@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: satlexmb08.amd.com (10.181.42.217) To satlexmb07.amd.com
 (10.181.42.216)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ5PEPF000001D3:EE_|DS0PR12MB999103:EE_
X-MS-Office365-Filtering-Correlation-Id: 8b92a53c-75ee-448a-1db5-08de3bb70168
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|7416014|82310400026|376014|1800799024|13003099007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?IXEfMqsK9SY62b7mjGlrIpHLHuY0YlhMULvm1BHtpq8wgy2b8k+oL0ZXdv5P?=
 =?us-ascii?Q?c9lPe2o8S4GVhlfsyZnk+YVo3Uo9ILRONH6LoyiJXup8DFhPPQ+sDgpm3+yt?=
 =?us-ascii?Q?HjUzxsOcH7kNSKfwu0Y07l6BWAdptbr4/OqYiDn5kj8KgFZ+HDgLVDb3ymHa?=
 =?us-ascii?Q?v7/5ETpOad+bNi2n84afC2I6m4icSt+R5GvQA7jozEMkpMUtJgxSO0vHbp0Y?=
 =?us-ascii?Q?G0NSeVrhX+Fu3/ugB/tan8uBb6OCVb1Th5KH16EAZY2u8MKkSKOkUygzy9q4?=
 =?us-ascii?Q?R0ADEXKxRnftEIfqstmU2aJtKjWupEfJ+SGOYtUa2gMU0pDPtDMCwihyBFT2?=
 =?us-ascii?Q?qlMsaiivEhmCtpsPmJTVSR4/2OBtxG6a5DPKeqwmqDE7n5yTDVo3oFFumql1?=
 =?us-ascii?Q?pTLQxd/IZftGA9SaIcNVC5W9dW4+JNbkWE4BOQv7tjXJUS0t+B8r26YX5zrB?=
 =?us-ascii?Q?ONmdbBOYfkOwC9IUlwpvLhrdYnAR8l26xnMt+I3mJ0uqFY/+OvJzNTiQocPH?=
 =?us-ascii?Q?skrXBExVLMeFXJp9wUiUKXzAJ2R4GYm1po7mhUp3CQgSHU10LImioIxPHAOt?=
 =?us-ascii?Q?j8ksXpzbEuPzXhYXuknLUgJsYMskOz24etkAzEc+d9pEKGFo3OcW8P9pCqYT?=
 =?us-ascii?Q?fZAuVB0MnqrfVm03ZwVKvyxc24FOzl3DW4IPuhGYdlLIACm+EXhj9ba7OO9O?=
 =?us-ascii?Q?IrHnYqREi1DhuahJdIcFcKNESeRFp0OjTqCMRJ0IBIL+KRrDIK8vNqB7CG+p?=
 =?us-ascii?Q?2SbrehmhWMfWVjPNFJKD+Fo3giiHbblQjw8GnO8bBuStxymU8BlFbLoSs2Kr?=
 =?us-ascii?Q?NkJWhNYOE8yCnvq3jX509DWhr8TfjNkMO5sPb4i2H6LBtC2jW3a96ARzS0eW?=
 =?us-ascii?Q?4L9qaU3QTh4HLKhJqb9Wl4hPxWvf9UjxbeVywcAuESb9pzFfQMQG/3HzsThF?=
 =?us-ascii?Q?hm9NBW6ARLbVN5Ps/sZ5YsOjwyq+MQYyclXD5XWhygaanfk6Cokr7OisCCBL?=
 =?us-ascii?Q?M6V3DMVfoRwEHnExK2Htx/nogcX2OWbg3kQ3EosG3WcBWAtc4aaZegJtxNYj?=
 =?us-ascii?Q?KJ2PkCCFH+NjJ3U+ewu47U/ldtMmT9UegyXkyB686hBBWYU1fgDg9kQDnk44?=
 =?us-ascii?Q?sBJpN+5rUBEk5cVguvZcvVWL1/PHfzcQYQWUP7/MuRNdz3zgfcf75U7YQtEU?=
 =?us-ascii?Q?X9l4Kd0eM8KM8t3ZHTlJn6vOtBe/gp+zbBysG0SKswgYscCl0eEwOpVUIqWR?=
 =?us-ascii?Q?6sHN++GkelKrOnX922ASELJFpt2z8L5PuSqukjFnwPgz/XY7uFqbvr07gSFN?=
 =?us-ascii?Q?OUl8PBoeDmkCWEIB+AbG3ZcHatkt8CcZQL8Vn6yJrVPYCAIu6XF2DZyqycxF?=
 =?us-ascii?Q?asYxLoUyPc7HGRd6D/QdviF9LoFGdQjeZtDvZn6KTa7wbqRRlpqHw7emulWX?=
 =?us-ascii?Q?8PV+8R2NnRpdepf8MPOG7PWDXCWOf1EP2s2uP1gawkKTvLSRjzorCz79GWK4?=
 =?us-ascii?Q?4E+OWmelh4insfd92EaBAXr2l2Li5BDoJ0nYIlfmTuit8X1+zgsUMRX6RGv8?=
 =?us-ascii?Q?pa9YtYu+UD/tDT6ccp0=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(7416014)(82310400026)(376014)(1800799024)(13003099007);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Dec 2025 08:50:32.0482
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 8b92a53c-75ee-448a-1db5-08de3bb70168
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ5PEPF000001D3.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB999103
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 562A9A0003
X-Stat-Signature: ahyoozi5b8q3wqxpmz65d3zbttpdt7ca
X-Rspam-User: 
X-HE-Tag: 1765788635-109792
X-HE-Meta: U2FsdGVkX19t7hSKFZWw9muVXImfUVcCNMI8P5CKz52XVKvxrLsoS8WX+1WDpl6RVVU1DDlnEXS4JOlz2xXEDMOJEvIqxYVH3E46gYfc2kYVj+WeMbKKIN6TfHF2G9MEw7rXp+aXfSfRZk6pUaY55i/vREv1gNUxsFFyV8DiO/8JlicllR4ywBd4us5WDAuKDfu1iyGHX3bhoaQFT4xAQLYqZINB1n5Uo1DqzjtJZvNPHsbpfyJqZr17JRH9M22KvPZv8nPjJAErs0mAv2LukL+aT4TyWhjvBOD3+O5cokxqiaKd7lGQ4vm4h9gzM4jzUYljesAavOuNoTeObYVx2/GawXsHlCKBgqFqfEvPOhgm0aYtpdCOkrsgGlsAwXAWEI/JlKHY+q/8tnePdZA84H6Jtd7qUSICT5RSka/n7JkxFXR41i+fMWz14LIABYwg0puPdFS1W3gjAh/BEMI60EvCPXYulMSW098Y4/G1jjCQiApwMgWL4Gna7ySiNRIJb1QcGRgkmkHOj1nO87/GznTLpk3RZowb4o0JD04/JUyubkDK+OpyU6NNKOva3efTuns1ZHWgcciwqriNQcJGuTOONTi9AJyVFjVkyk5mhjirt+gD1xJrFyy8tRlhp+N78Xm6bS6nbOKb8dk76sAf672hxlzR/q4OxByzFyRk+38IVKNgeW9fXbb2erxY7mN4ZJ+/qDJG/LhAkZU0031nS6kdwMzjTyaCJukni4GBna5elItnx/WZAz+QgT+WPLsyR99DHPEWeMekXVvj9s20FPAVGqTu2V01Q2YxlBD7p0QHQsEtDCrn77UZKop9VTO6FjlZLL0idOL/lTmqWOHKvk1x1HJU6vFLlu2X+4zEdP6MYJB5DLq1bmNUsrZKI01zgPslZNllbhp155DPWni9oGKfLQs/yu6E9vNs+YLDtyCtv1TFiKHsFgMGa4MoA3uaH0dBoRvvlyLvluGOVJR
 FH9suGVm
 nmu86JdniSldKLrxWRneDQXfOrONBPTXbv7AvXFghp0IDk56E8J5bRkDLKUVuFxQYgxdQKnvrkOacB59oO280tsflmeLa77sNN6r75Qsjok5+aO+IOxkb4mNPXUxFQoyahH/RTfsz8OUYFTi4PfVzun86KE0pjepkNy2fRf0c/3Mv3mKYYXO35Fv4RhC/gkab1Kq6SpjSSGukWio19Ia14N9zGfix2xdMCpekdF3MqG1abguke2dOCXIygZPbjiox+4l+0NwCDan2G4MNKab9BjF6n+Jd/wlSB/dMZ5VqplZQRzmeKWTEiY5oG4EBQjcc5ReOU9xtoFY8mX5A5/xjL06JE8Fvmr2lgJcNvqE3GCo+7zv3KiT98LDQ/NJFPJKyBpsgmIuqXe/G8IP0r4RapSpkwy8E7zerKcyEg4pvjse94qGk2pr2q83rOFWWyCaLYAgs/I+q6KId6F1KvGRAqlP7WFkkiIhK1MHkFhzqn5GJFGt3T/1PFOQAoAhUXeolXvvclfTZX8sNw4A1tdCtuKmOyxXCdnbad9d6ypx9OXFAgII=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When MADV_COLLAPSE is called on file-backed mappings (e.g., executable
text sections), the pages may still be dirty from recent writes.
collapse_file() will trigger async writeback and fail with
SCAN_PAGE_DIRTY_OR_WRITEBACK (-EAGAIN).

MADV_COLLAPSE is a synchronous operation where userspace expects
immediate results. If the collapse fails due to dirty pages, perform
synchronous writeback on the specific range and retry once.

This avoids spurious failures for freshly written executables while
avoiding unnecessary synchronous I/O for mappings that are already clean.

Reported-by: Branden Moore <Branden.Moore@amd.com>
Closes: https://lore.kernel.org/all/4e26fe5e-7374-467c-a333-9dd48f85d7cc@amd.com
Fixes: 34488399fa08 ("mm/madvise: add file and shmem support to MADV_COLLAPSE")
Suggested-by: David Hildenbrand <david@kernel.org>
Tested-by: Lance Yang <lance.yang@linux.dev>
Signed-off-by: Shivank Garg <shivankg@amd.com>
---
 mm/khugepaged.c | 40 ++++++++++++++++++++++++++++++++++++++++
 1 file changed, 40 insertions(+)

diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index 219dfa2e523c..6c8c35d3e0c9 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -22,6 +22,7 @@
 #include <linux/dax.h>
 #include <linux/ksm.h>
 #include <linux/pgalloc.h>
+#include <linux/backing-dev.h>
 
 #include <asm/tlb.h>
 #include "internal.h"
@@ -2787,9 +2788,11 @@ int madvise_collapse(struct vm_area_struct *vma, unsigned long start,
 	hend = end & HPAGE_PMD_MASK;
 
 	for (addr = hstart; addr < hend; addr += HPAGE_PMD_SIZE) {
+		bool retried = false;
 		int result = SCAN_FAIL;
 
 		if (!mmap_locked) {
+retry:
 			cond_resched();
 			mmap_read_lock(mm);
 			mmap_locked = true;
@@ -2819,6 +2822,43 @@ int madvise_collapse(struct vm_area_struct *vma, unsigned long start,
 		if (!mmap_locked)
 			*lock_dropped = true;
 
+		/*
+		 * If the file-backed VMA has dirty pages, the scan triggers
+		 * async writeback and returns SCAN_PAGE_DIRTY_OR_WRITEBACK.
+		 * Since MADV_COLLAPSE is sync, we force sync writeback and
+		 * retry once.
+		 */
+		if (result == SCAN_PAGE_DIRTY_OR_WRITEBACK && !retried) {
+			/*
+			 * File scan drops the lock. We must re-acquire it to
+			 * safely inspect the VMA and hold the file reference.
+			 */
+			if (!mmap_locked) {
+				cond_resched();
+				mmap_read_lock(mm);
+				mmap_locked = true;
+				result = hugepage_vma_revalidate(mm, addr, false, &vma, cc);
+				if (result != SCAN_SUCCEED)
+					goto handle_result;
+			}
+
+			if (!vma_is_anonymous(vma) && vma->vm_file &&
+			    mapping_can_writeback(vma->vm_file->f_mapping)) {
+				struct file *file = get_file(vma->vm_file);
+				pgoff_t pgoff = linear_page_index(vma, addr);
+				loff_t lstart = (loff_t)pgoff << PAGE_SHIFT;
+				loff_t lend = lstart + HPAGE_PMD_SIZE - 1;
+
+				mmap_read_unlock(mm);
+				mmap_locked = false;
+				*lock_dropped = true;
+				filemap_write_and_wait_range(file->f_mapping, lstart, lend);
+				fput(file);
+				retried = true;
+				goto retry;
+			}
+		}
+
 handle_result:
 		switch (result) {
 		case SCAN_SUCCEED:
-- 
2.43.0


