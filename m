Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 83E3CC2A06C
	for <linux-mm@archiver.kernel.org>; Sun,  4 Jan 2026 07:22:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 67C4B6B0096; Sun,  4 Jan 2026 02:22:33 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 63C726B0098; Sun,  4 Jan 2026 02:22:33 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4754B6B0099; Sun,  4 Jan 2026 02:22:33 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2E0176B0096
	for <linux-mm@kvack.org>; Sun,  4 Jan 2026 02:22:33 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 01A111A8A3E
	for <linux-mm@kvack.org>; Sun,  4 Jan 2026 07:22:32 +0000 (UTC)
X-FDA: 84293438586.15.0E4BF9A
Received: from BN1PR04CU002.outbound.protection.outlook.com (mail-eastus2azon11010070.outbound.protection.outlook.com [52.101.56.70])
	by imf11.hostedemail.com (Postfix) with ESMTP id 1AFEE40005
	for <linux-mm@kvack.org>; Sun,  4 Jan 2026 07:22:29 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=TedDEedr;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	spf=pass (imf11.hostedemail.com: domain of Honglei1.Huang@amd.com designates 52.101.56.70 as permitted sender) smtp.mailfrom=Honglei1.Huang@amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1767511350; a=rsa-sha256;
	cv=pass;
	b=y4xzeDOwCmopKFNZn0Hm7G28Q3BO1gXT9RJBZmL+fYcgGO87o9pmUBheVOPN7mu9lxQoqN
	K79jRApa7UJ774EA38YJnW2eQf14HD53jNli3ZvP3TzvBme96y27Sq1tKVib/nAAzATZbn
	zwdXn9jR9FkR6ua0KdWkmk3QJFBqypA=
ARC-Authentication-Results: i=2;
	imf11.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=TedDEedr;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	spf=pass (imf11.hostedemail.com: domain of Honglei1.Huang@amd.com designates 52.101.56.70 as permitted sender) smtp.mailfrom=Honglei1.Huang@amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767511350;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pEhcRp08TrkcMs/mdXjvglLWujQx6Wl/vt6RKxcaw2Y=;
	b=A75mXQcstSW4ZlZw40YnME/pHcjAWAjVlJj08DH6LwPKuuhZXXDL5A4HnNX/yCWpaMfZxI
	9ZHcDyYBAnHVAd7cvAwDNt6/QU50NCjFpYG8ub/ldZ3SVacUjCRLQz1/Pf8biTx55onEts
	zk6QuC+AKN7yhTgcyM5DHetKlUwD7wc=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=qFtGNhGbac6r2EfKMcrHtwh1WjhZgag2jfFBenYnckH6Ch4etPgcCNeEDTITLY7CovU1qBK3iSSYnz8TMKdT7EM35MDc+h9kuE49u3PeWo39Iz6uqSku5nWUj8wFPzsexWTUIqSnCaLKKyUw4OSSON0o3jtqsjWSv0Gi/zeR5UVN6Fn0gZZTdnBoS6fB5mgb4I7PrOHXajlBMofXKsCDvE2ax83adDVU/Xkjy33L4sA87/hZoCO9b/rrdeBHMRS2uXqkK851AvvTZ1rE5rGTbwoenWV+zdgmwbxNgmNhY+/wEuAeXJF2D0wDEfQhgl4gRJ4QZ7SBHty9JOBFkCBfUg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pEhcRp08TrkcMs/mdXjvglLWujQx6Wl/vt6RKxcaw2Y=;
 b=vzGc13YiDV8x6vAOIrvlQEqpDT3kFRnL//wKt2sNUsjRYEesFIJ2QJ5ZFad+NrT3IrCtyCg3tea/d8e5ksDq5cXW7brz4AzsdgllTpZaO4FBzeH5b370TEJh5jgELSCOjUnbyYS/qZn0dwrhj/vX01fetMwk/t6gikxZYU3NXnmNPH+4sQghAhNE5V9RnE+DKLV8FJgJebQqd31K0MxpwBkVW2qacmKoCdlQ/S7WnAMINeM6hoAxG/0FaPz9X5TEE3Kybc0LpgBysKRcNm2+gHIyF9HZD/iMnOju17qAmMNQZ43oh4N5gLodlpWtLT7ysEn0H0h/lViKKeJ9TNDDqQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=collabora.com smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pEhcRp08TrkcMs/mdXjvglLWujQx6Wl/vt6RKxcaw2Y=;
 b=TedDEedr09sybNf5o2aXRpe8asiwnISnWfVEFr3IVeBqz5WCPRsQnhAo1+a+zH6vYrR5AFVtUg6nK6ADHeDQ5tqD0C1FT/VIu+ramgGaLDqdHT5N6ev2yz+cOyn3A+L+qWUsD3d+9pSjc2WEFRan16ZgjqlpSibZM+peen/R5T4=
Received: from MN2PR16CA0066.namprd16.prod.outlook.com (2603:10b6:208:234::35)
 by SA5PPFE3F7EF2AE.namprd12.prod.outlook.com (2603:10b6:80f:fc04::8e6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9478.4; Sun, 4 Jan
 2026 07:22:26 +0000
Received: from BN3PEPF0000B36D.namprd21.prod.outlook.com
 (2603:10b6:208:234:cafe::94) by MN2PR16CA0066.outlook.office365.com
 (2603:10b6:208:234::35) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9478.4 via Frontend Transport; Sun, 4
 Jan 2026 07:22:26 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 BN3PEPF0000B36D.mail.protection.outlook.com (10.167.243.164) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9520.0 via Frontend Transport; Sun, 4 Jan 2026 07:22:26 +0000
Received: from honglei-remote.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Sun, 4 Jan
 2026 01:22:22 -0600
From: Honglei Huang <honglei1.huang@amd.com>
To: <Felix.Kuehling@amd.com>, <alexander.deucher@amd.com>,
	<christian.koenig@amd.com>, <Ray.Huang@amd.com>
CC: <dmitry.osipenko@collabora.com>, <Xinhui.Pan@amd.com>,
	<airlied@gmail.com>, <daniel@ffwll.ch>, <amd-gfx@lists.freedesktop.org>,
	<dri-devel@lists.freedesktop.org>, <linux-kernel@vger.kernel.org>,
	<linux-mm@kvack.org>, <akpm@linux-foundation.org>, <honghuan@amd.com>
Subject: [PATCH v2 4/4] drm/amdkfd: Wire up batch userptr ioctl handler
Date: Sun, 4 Jan 2026 15:21:22 +0800
Message-ID: <20260104072122.3045656-5-honglei1.huang@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260104072122.3045656-1-honglei1.huang@amd.com>
References: <20260104072122.3045656-1-honglei1.huang@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: satlexmb07.amd.com (10.181.42.216) To satlexmb07.amd.com
 (10.181.42.216)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN3PEPF0000B36D:EE_|SA5PPFE3F7EF2AE:EE_
X-MS-Office365-Filtering-Correlation-Id: 3ca9623a-cf97-417c-4f5f-08de4b6202f4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|36860700013|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?K8UiKKWLwt0cyKOgJzLHQNxbtWPP4XOKIwzwQyS3gVuvKNQqsjzEaptTkVhb?=
 =?us-ascii?Q?HH9RDZ2g+Tsnv2OE0CqSlV1LD8enGaPiPAtj8diGED7qWn//h9vJUZ9kceng?=
 =?us-ascii?Q?8wPDTNZr8zfUFxp1hKNepgfu2rKP+ee9x028t5C0M4gjHMaoyjHoTOihaYJ9?=
 =?us-ascii?Q?tQYQU/wKQ3SiPPNi0/EIdrEQnYLNH53qV8YNQxwEueRjcFDL95vHA1Yvxovx?=
 =?us-ascii?Q?nOcioQzq1ki3pUNq3ug7I6hVYAI4avMrcpsoE+QgLdd0HCEqgS6OqNntgZ3S?=
 =?us-ascii?Q?QJJim35iQ/N0KQaJoIlQIzwZxDcaGVXssGunLb+T6YQB4XEA3CWiLPYITURn?=
 =?us-ascii?Q?sd0ZVMAe2u1bHBtdAAksRyimFO/Zn6ewW7tMbd8OY2mPOrH9k48FJh7l/PRP?=
 =?us-ascii?Q?k0cJ2WfogKMgDhnrUZEGHtirQmVmRmljbNXQRjHHiPICTwHw5v4yanX0iyBD?=
 =?us-ascii?Q?882o1XPJUrD5rwckk5GZX4RFRjwyYN8yJrv1AUsdGO2I0W/07aEWVtGIxu2m?=
 =?us-ascii?Q?0RIprY2TblIHKK6EkaacjBNTZ684oyk9sDq9jUStr/5ba7qyiHD6gohOWey9?=
 =?us-ascii?Q?IwhcvnaU5D5nn+7L0KOCJ1yMhjX3lm/OaUXsoyUW3iPcs3xHePC7HtqrsYQ/?=
 =?us-ascii?Q?4eDZ+K6ELoCGH3onweUDO08vT0YvNL6qy51XEySHACGx6TfnDsEfBTYM2K2B?=
 =?us-ascii?Q?Nr+myMmhgN76DJWWakf0ACWxz76kuhgB7dYq15pNy79e9jzyxqMF5Un3uADy?=
 =?us-ascii?Q?QdD8zCL3GDUeieZAcemQMeGjb9XXGnQsNbAU2im3yusySIMIMfcLb3M6VC9N?=
 =?us-ascii?Q?P4HnPfj0KzXejhEfDtHo8qXl+ev4ha+CPf5N4QQbwUldN9BLqINzE4IrvsTC?=
 =?us-ascii?Q?qfd2dhlu/GJcF1VaoSSvv/A8T6CLODS3PBwUFZgi07nfWOzx7xOhYZpfJS9K?=
 =?us-ascii?Q?O8oh3iNocLtrF6w3G1MuDNxoV5Cxhpq6jVLecLwhGYF4iT1GkkPU+73NkdhT?=
 =?us-ascii?Q?WfCivN0WrWIwAy1kU09F+m+ecJMlG3JegvvIP5WREmOQv3imo552AMEiHjjm?=
 =?us-ascii?Q?S2oajjcJNLAGtZwaGo4yhQXvnKc9tFnbjl2ZSGFp7tOQjN6D1DlmJKn4ANX4?=
 =?us-ascii?Q?uBWic1OAq+L5tS0/HEsUgmYK3CoUGPS5oECGvc5uXaK3aCgDVQvKCPeu/hgc?=
 =?us-ascii?Q?yGUVAOzHPy7dJw+2jXvvE28GFdfJMJby0YBy9G3AJt5PVVjDx2yJpppDZCnj?=
 =?us-ascii?Q?UIyLrO6K7OAafOAl7jj6qv99g6n8vVJN7dEFH+Zi7W5YRE7927LGzxTxjyQx?=
 =?us-ascii?Q?5oKK23IWA53f0FKoSjcL4o4EQJ0ktrfOFBBChix9sOWmzHw3h8r/sOsLsp4A?=
 =?us-ascii?Q?Z6V4+ERDOXHS/ppBREf+E4YuEyoSCKvsHVm78LjaLf63lHY5dGp4FKpk6bmh?=
 =?us-ascii?Q?DehvPAiN553BBrSypRJjAwqlfw7WGdzJmmyXtwEEKdEbIelM5wvlr0v407Sw?=
 =?us-ascii?Q?RDC7oNljsuNk4hLrAuRzbX7nkgMVj9oBcv+Di/w0apastAqIjt5WQYNd79w7?=
 =?us-ascii?Q?m7R/nn2J2qkoaZ7ylck=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(36860700013)(376014)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Jan 2026 07:22:26.1198
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 3ca9623a-cf97-417c-4f5f-08de4b6202f4
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN3PEPF0000B36D.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA5PPFE3F7EF2AE
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 1AFEE40005
X-Stat-Signature: mefytdcjbjbed3fbxgxh69ntudtx3o84
X-Rspam-User: 
X-HE-Tag: 1767511349-931433
X-HE-Meta: U2FsdGVkX1//DJ7ULBnWoi3tBWJthV6T3ikGQGrimhz4EvgvS5X5dUeszJHonDm8E7l24BrTS5MZ0ItqKNSH9SdJt57lkraqb51kudfPpqjRjaM9BfVJOChA1VoDTrRk7bX65WebXJS4cr5GB/Ts6Q1k6ARmZOV/m6w3kbsF/N3JNwZfTGXVjEE2Hgahc8SCyn1h1y58RVriQxnfPm0NQVy+NNdlxB0y+rFah+gT4lV5Ewtegf61RPPKqgMeO5GvTtbYnkKATjfwzJ+NAs6tSyoQ2D4cYiaEk83itS02Sa5yG/nM/DmlF1KGfmHPc9CzDBIf7nH+7ibieVMcoJLXaew4tA6+4eQFPA9l4M3afawfz+POJEu1WurgDuYXmJxXD+MmJS/5QrsBbRhO/OUDLqyouaTXMPJ2o/zW8SfI+V7uPTeOzGXiRGnixA2TfVO5MkzERI+GDKVKrZCZp+TD3y7xK28pCDdLL1vRmcPw3GGfeDsF8qM35zcU7WrY9ORJ2JdkdSV9nIn8/xO5oJgAwyfOJAabKc+VVfsc5uL805cQIVJi4BFnoNP4/kBk1XL9XvTjBxYAn0aQusRLZEVVu2QkttkbKUBDdRjfBAkgZQLHHXO6tP+QBKhJHirfIkjjFcG9u5jOpTVR9ek9wZkfatoVn4k/Pd4qX5bkdVG/FF/XJ3xJRMjj1YB3KP5blsrYUEqni2uSEioTdGt9VBC05K8B6kuSEPZMEEx2s/qYYCZUYzO5rf7jEeF7iYjxsHOSdzA0sqKsSBEHIJA5LOzF4mJMfo5DmgoWNv6Cx642v381oN4XW1yKDzO3hcRiEkueblhklWAgPG0YMwhDYHgpy0lt3aVVB4UdqZH7W0BmXO0Y0RfP9OWUPQlbe0OVLCkTOh2wXIvYf+nsjX26nxxjL1koGDRNyQ8lZKft0RIvCJO+Gw0d2H3TZ69rix+OpisSokC/TCvCq1pzjT22Qbu
 c+mnVif3
 SdbEF5zrCRMZGUr+P1wy2qAQkJJKgtB7hy0fX8JThrExGYUmrU2r/LvJoOLEDOsQ/l2sYQctAxZM5melhmvgUzAcwJpuPfPLVJ+s7CNBl3SMse9nTnzFqpnvqc+mvbknHSQos9FX8Pu43TKcXcyAaohKUTpHPuDSBzFvvtq9kxSmt9bxBVfaO1r6QPpHh/7l3zesjq2RjhN83XwjK1VXOUCgq1cIZXIe4DNzrTQgJ5rGHLsPUh4rS3N5emIX/Q9U2AMq5r7/fDB1+rMOEuxB/5tLbGI9t/1/TYPtbHFxQYbtd8zw5vF6hpzUgd5XWLgLaenh8VRVMpEFr6J3jxNSVxruLshv4PKrGCjMUYoVw3NygTPna0pjjiGZDrsf0u4IlrxUKFETy27hkOgn7XyFpbOuW7JWvujHQj/wnKpiLNgcjI7HLRC2R05jpQynSrS7BRnvmVbArcQjK266AdJBctV6M+wtisjAqtqmapz/Cu0KfT0g=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Honglei Huang <honghuan@amd.com>

Add the ioctl handler for AMDKFD_IOC_ALLOC_MEMORY_OF_GPU_BATCH that
processes userspace requests for batch userptr allocation.

The handler performs validation of input parameters including:
- Checking all ranges are page-aligned and non-zero
- Verifying total size matches sum of range sizes
- Ensuring no conflicts with existing SVM allocations
- Validating that USERPTR flag is set

This completes the batch userptr feature by connecting the UAPI
to the implementation.

Signed-off-by: Honglei Huang <honghuan@amd.com>
---
 drivers/gpu/drm/amd/amdkfd/kfd_chardev.c | 159 +++++++++++++++++++++++
 1 file changed, 159 insertions(+)

diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_chardev.c b/drivers/gpu/drm/amd/amdkfd/kfd_chardev.c
index a72cc980a..d8cfd8697 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_chardev.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_chardev.c
@@ -1196,6 +1196,162 @@ static int kfd_ioctl_alloc_memory_of_gpu(struct file *filep,
 	return err;
 }
 
+static int kfd_ioctl_alloc_memory_of_gpu_batch(struct file *filep,
+					       struct kfd_process *p, void *data)
+{
+	struct kfd_ioctl_alloc_memory_of_gpu_batch_args *args = data;
+	struct kfd_ioctl_userptr_range *ranges = NULL;
+	struct kfd_process_device *pdd;
+	void *mem;
+	struct kfd_node *dev;
+	int idr_handle;
+	long err;
+	uint32_t flags = args->flags;
+	uint32_t i;
+	uint64_t total_size = 0;
+
+	if (args->total_size == 0) {
+		pr_err("Batch allocation: total size cannot be zero\n");
+		return -EINVAL;
+	}
+
+	if (args->num_ranges == 0) {
+		pr_err("Batch allocation: invalid number of ranges %u\n",
+		       args->num_ranges);
+		return -EINVAL;
+	}
+
+	if (!args->ranges_ptr) {
+		pr_err("Batch allocation: ranges pointer is NULL\n");
+		return -EINVAL;
+	}
+
+	if (!(flags & KFD_IOC_ALLOC_MEM_FLAGS_USERPTR)) {
+		pr_err("Batch allocation requires USERPTR flag\n");
+		return -EOPNOTSUPP;
+	}
+
+	if (p->context_id != KFD_CONTEXT_ID_PRIMARY) {
+		pr_debug("Batch USERPTR is not supported on non-primary kfd_process\n");
+		return -EOPNOTSUPP;
+	}
+
+	ranges = kvmalloc_array(args->num_ranges, sizeof(*ranges), GFP_KERNEL);
+	if (!ranges) {
+		err = -ENOMEM;
+		goto err_alloc_ranges;
+	}
+
+	if (copy_from_user(ranges, (void __user *)args->ranges_ptr,
+			   args->num_ranges * sizeof(*ranges))) {
+		pr_err("Failed to copy ranges from user space\n");
+		err = -EFAULT;
+		goto err_copy_ranges;
+	}
+
+	for (i = 0; i < args->num_ranges; i++) {
+		if (!ranges[i].start || !ranges[i].size ||
+		    (ranges[i].start & ~PAGE_MASK) ||
+		    (ranges[i].size & ~PAGE_MASK)) {
+			pr_err("Invalid range %u: start=0x%llx size=0x%llx\n",
+			       i, ranges[i].start, ranges[i].size);
+			err = -EINVAL;
+			goto err_copy_ranges;
+		}
+		total_size += ranges[i].size;
+	}
+
+	if (total_size != args->total_size) {
+		pr_err("Size mismatch: provided %llu != calculated %llu\n",
+		       args->total_size, total_size);
+		err = -EINVAL;
+		goto err_copy_ranges;
+	}
+
+#if IS_ENABLED(CONFIG_HSA_AMD_SVM)
+	/* Check for conflicts with SVM */
+	svm_range_list_lock_and_flush_work(&p->svms, current->mm);
+	mutex_lock(&p->svms.lock);
+	mmap_write_unlock(current->mm);
+
+	/* Check GPU VA for SVM conflicts */
+	if (args->va_addr &&
+	    interval_tree_iter_first(&p->svms.objects,
+				     args->va_addr >> PAGE_SHIFT,
+				     (args->va_addr + args->total_size - 1) >> PAGE_SHIFT)) {
+		pr_err("GPU VA 0x%llx already allocated by SVM\n", args->va_addr);
+		mutex_unlock(&p->svms.lock);
+		err = -EADDRINUSE;
+		goto err_copy_ranges;
+	}
+
+	/* Check each userptr range for SVM conflicts */
+	for (i = 0; i < args->num_ranges; i++) {
+		if (interval_tree_iter_first(&p->svms.objects,
+					     ranges[i].start >> PAGE_SHIFT,
+					     (ranges[i].start + ranges[i].size - 1) >> PAGE_SHIFT)) {
+			pr_err("Userptr range %u (0x%llx) already allocated by SVM\n",
+			       i, ranges[i].start);
+			mutex_unlock(&p->svms.lock);
+			err = -EADDRINUSE;
+			goto err_copy_ranges;
+		}
+	}
+
+	mutex_unlock(&p->svms.lock);
+#endif
+
+	mutex_lock(&p->mutex);
+	pdd = kfd_process_device_data_by_id(p, args->gpu_id);
+	if (!pdd) {
+		err = -EINVAL;
+		goto err_pdd;
+	}
+
+	dev = pdd->dev;
+
+	pdd = kfd_bind_process_to_device(dev, p);
+	if (IS_ERR(pdd)) {
+		err = PTR_ERR(pdd);
+		goto err_unlock;
+	}
+
+	err = amdgpu_amdkfd_gpuvm_alloc_memory_of_gpu_batch(
+		dev->adev, args->va_addr, args->total_size, pdd->drm_priv,
+		(struct kgd_mem **)&mem, NULL, ranges, args->num_ranges,
+		flags, false);
+
+	if (err)
+		goto err_unlock;
+
+	idr_handle = kfd_process_device_create_obj_handle(pdd, mem);
+	if (idr_handle < 0) {
+		err = -EFAULT;
+		goto err_free;
+	}
+
+	args->handle = MAKE_HANDLE(args->gpu_id, idr_handle);
+
+	mutex_unlock(&p->mutex);
+	kvfree(ranges);
+
+	pr_debug("Batch userptr allocated: va=0x%llx size=0x%llx ranges=%u handle=0x%llx\n",
+		 args->va_addr, args->total_size, args->num_ranges, args->handle);
+
+	return 0;
+
+err_free:
+	amdgpu_amdkfd_gpuvm_free_memory_of_gpu(dev->adev, (struct kgd_mem *)mem,
+					       pdd->drm_priv, NULL);
+err_unlock:
+err_pdd:
+	mutex_unlock(&p->mutex);
+err_copy_ranges:
+	kvfree(ranges);
+err_alloc_ranges:
+	return err;
+}
+
 static int kfd_ioctl_free_memory_of_gpu(struct file *filep,
 					struct kfd_process *p, void *data)
 {
@@ -3309,6 +3465,9 @@ static const struct amdkfd_ioctl_desc amdkfd_ioctls[] = {
 
 	AMDKFD_IOCTL_DEF(AMDKFD_IOC_CREATE_PROCESS,
 			kfd_ioctl_create_process, 0),
+
+	AMDKFD_IOCTL_DEF(AMDKFD_IOC_ALLOC_MEMORY_OF_GPU_BATCH,
+			kfd_ioctl_alloc_memory_of_gpu_batch, 0),
 };
 
 #define AMDKFD_CORE_IOCTL_COUNT	ARRAY_SIZE(amdkfd_ioctls)
-- 
2.34.1


