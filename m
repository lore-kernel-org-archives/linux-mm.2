Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ADAD7EF0715
	for <linux-mm@archiver.kernel.org>; Mon,  9 Feb 2026 06:11:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 173D16B009B; Mon,  9 Feb 2026 01:11:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 14B716B009D; Mon,  9 Feb 2026 01:11:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 023D26B009E; Mon,  9 Feb 2026 01:11:33 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E036D6B009B
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 01:11:33 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id A36F2D62DE
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 06:11:33 +0000 (UTC)
X-FDA: 84423896466.06.E0A29DD
Received: from PH0PR06CU001.outbound.protection.outlook.com (mail-westus3azon11011006.outbound.protection.outlook.com [40.107.208.6])
	by imf12.hostedemail.com (Postfix) with ESMTP id ABC834000D
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 06:11:30 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=T+g6BMCG;
	spf=pass (imf12.hostedemail.com: domain of Honglei1.Huang@amd.com designates 40.107.208.6 as permitted sender) smtp.mailfrom=Honglei1.Huang@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770617490;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Or/g3k8aWypXL2C3Ieox5FHOSnrb6FczpCu51sPvkWk=;
	b=Fb1cp7h08/gtmo83LH3/mVrKjUYg/rS9bqtp12txslt6zulP4TfbQON+ynekRg6SgQvTvh
	K+HCbAVv+OCfDDPPL+k5t2hBkk+z1s+aLdwMqV6P1GzG2o1OOAYp2HppjvPeT+ww8wKeMO
	FZwAWObGquT6RF1dBg5FHQmZbvIsWUU=
ARC-Authentication-Results: i=2;
	imf12.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=T+g6BMCG;
	spf=pass (imf12.hostedemail.com: domain of Honglei1.Huang@amd.com designates 40.107.208.6 as permitted sender) smtp.mailfrom=Honglei1.Huang@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1770617490; a=rsa-sha256;
	cv=pass;
	b=gQEHNUN63w6Zr4kYCOvTlRKF6XTP6Mo7pcYRkIhmdT+6Cq+ars7xvidYUA7HtHv4UYjhMc
	YSNHxVigcsHVdgXu3d0f3MrIIBhZD2z1OmoKk+ULWNYGMue/weLngIXhfQu0RSfQG1+vfJ
	wWYMZXD7I7gZIdFLciFfB/e0Bu87ehk=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=rDDxSMBX8zr2mKG4nbTv7JDSr8gSs2sWJC+fMiEFp409GZqU5mOaebPnQ1L8z5WplHrP4wJejnedPRv6c5E+oUTsRLcFmDcG2of81rdfvcPiFPAzru6DHDhYT9pcuPEh1T2haWuqtuiGvRmPNTv0sUZ07Vc7+4OAKntgEzsgNWAQ9SSpuKpXLv8uEiEk1DyFqRTinAMfJJbP7oFwon8e92ih0CuZ2SMwzezqWTGcLtuUsICYoBOv3zDwOMh3p7WXnGh5iNCSsqI2WoC7yClwPBwxvM45qgxxLS55htPGXVeUh940/rFIygtgArcDpzzmQgF67z82ttj4JznNf2b+0Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Or/g3k8aWypXL2C3Ieox5FHOSnrb6FczpCu51sPvkWk=;
 b=G2HBo7hEbOmXZWp+BTC/jbtWOgZg2i6zYtlqgzkktIK17hi6Byvdyei58rIz3RdHyKBzG31uvewkXty7TAln0SZ9qe/rIgxMBTWLXV3WhdAjxBR51fNXbomAXCPwSqJ+6CD35nDaxwDPf6aJsRypv1TremJA9C0kXJTlTXLf2QdjTj+Bl41hzFUjDbPaVQHekeNcCyBFBRFimBPlwpS4lbGL9B3EXYDf7NfD31hTJMH1Vw/cLtiUR0qZxLjTve1ZDM3p4bVYaUF7jraz1XIiBpgxxfCII/cJdAB9KVHhYsSj6geY/xF+ib58ZTXXOvv6c/MX82FTVrlAiNjgE1XlEQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=collabora.com smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Or/g3k8aWypXL2C3Ieox5FHOSnrb6FczpCu51sPvkWk=;
 b=T+g6BMCGSKZdEJlhGK+jjMhCGQnwT2TzOEgLTWCO83RDBO5Qa2Euj+r+E9smsc0PBORGxI6jMTZFke+JMV+pKgRDm7/V54awnrOw14s2eyV9rG4C3xle3Hk4glgMP9xq+KmpXvsnrArGRfd2lJBmY1bqZLVfsTKeWz4RCpfYDms=
Received: from PH5P222CA0007.NAMP222.PROD.OUTLOOK.COM (2603:10b6:510:34b::13)
 by MN2PR12MB4255.namprd12.prod.outlook.com (2603:10b6:208:198::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9587.18; Mon, 9 Feb
 2026 06:11:24 +0000
Received: from SN1PEPF000397B3.namprd05.prod.outlook.com
 (2603:10b6:510:34b:cafe::ca) by PH5P222CA0007.outlook.office365.com
 (2603:10b6:510:34b::13) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9587.19 via Frontend Transport; Mon,
 9 Feb 2026 06:11:21 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 SN1PEPF000397B3.mail.protection.outlook.com (10.167.248.57) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9587.10 via Frontend Transport; Mon, 9 Feb 2026 06:11:24 +0000
Received: from honglei-remote.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Mon, 9 Feb
 2026 00:11:20 -0600
From: Honglei Huang <honglei1.huang@amd.com>
To: <Felix.Kuehling@amd.com>, <alexander.deucher@amd.com>,
	<christian.koenig@amd.com>, <Philip.Yang@amd.com>, <Ray.Huang@amd.com>
CC: <dmitry.osipenko@collabora.com>, <airlied@gmail.com>, <daniel@ffwll.ch>,
	<amd-gfx@lists.freedesktop.org>, <dri-devel@lists.freedesktop.org>,
	<linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
	<akpm@linux-foundation.org>, <honghuan@amd.com>
Subject: [PATCH v4 6/8] drm/amdkfd: Add batch allocation function and export API
Date: Mon, 9 Feb 2026 14:10:45 +0800
Message-ID: <20260209061047.3881808-7-honglei1.huang@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260209061047.3881808-1-honglei1.huang@amd.com>
References: <20260209061047.3881808-1-honglei1.huang@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: satlexmb07.amd.com (10.181.42.216) To satlexmb07.amd.com
 (10.181.42.216)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN1PEPF000397B3:EE_|MN2PR12MB4255:EE_
X-MS-Office365-Filtering-Correlation-Id: c96018b7-766c-4585-066d-08de67a20d70
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|82310400026|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?Wixs8bF02poqAGs/4c3Riwqho/k8bguEG7CV+hVslfUKFO8bAuk8IsX/TClP?=
 =?us-ascii?Q?nmHy8x4GfwsFIK+dG4fW1Y9Zs++3L7xGLM/nL/Mzsldhmglnhpn49zBJVnN9?=
 =?us-ascii?Q?0ofQIl9RFmtaXDFhBK5W4XRKjRAtU1/iyVfxI4qMuFDdlTKCyZn+rUfw9SqN?=
 =?us-ascii?Q?5dGOKfshubqG42GWT1c97OSXCZPxEDOu8e3NHKKcfNyE52712/S7VE7FBoDW?=
 =?us-ascii?Q?BIEScy6e48lvvtQ1mRisuGoJOKYvV9S57idNmCklOtjErvqfEYqMGEItGvB5?=
 =?us-ascii?Q?G7HVWrboyeN1UrW6+Z7w59HMklhoBDHPDWDX22iejM4a9OnDjklAClBN8T+c?=
 =?us-ascii?Q?87F7y+FRu+L3F9hMOU1m01cVU5yMLHemIahycvXmD7yAH66zGTf6YNsZKs3A?=
 =?us-ascii?Q?p/7YY4O+tpF78gn1l+J7bhKCrPTEKVo10ncOi28aQAvNC+3UqopQUypOQDGz?=
 =?us-ascii?Q?QJMJGzAafn83FFyItUfS5pc292X3k1IusHdCdneHxSgvnL0wVIvSoJ4EI0zz?=
 =?us-ascii?Q?/iTWVUx50/dFckXL6GziuKVTKxbGPdFcHAi0gP9wVLISVTAqUfORSRVIrl/4?=
 =?us-ascii?Q?49Wm/l3mSP6u6DhrZ+Av5y+Yo7qVX4SpWbdexnJTJhxI/Jl96iR6eggKm7WX?=
 =?us-ascii?Q?CTAd6BZD9HDQ8rW+qA8EEZf9EUZCOVsNS5Wy/VbUnxtJ4/h4KWX3udhkwYbM?=
 =?us-ascii?Q?JVh+bno6klyrNVDyW+Sm94H5Xbcypdigg1/IssbzlxxxJWkGkXbwnBtaQS0l?=
 =?us-ascii?Q?Fz4k717pL9Tzi8k+hwhHBqNVKM6i/lJoKff7Om/ZBMora0RRvjaS7ibjX7ou?=
 =?us-ascii?Q?9CpRJoprHCegQzNYc3Z7XBEnqIAdIjRYVO0N9fLbBPwz9jASyW8c+KHVZoK9?=
 =?us-ascii?Q?VNa6tvTlXsbtRjZoY0B7HzqlzukY2brewik7yy/OGdmKT0LKclI//AYj6SO1?=
 =?us-ascii?Q?hobwpTEyChpGtj1JrHljelBL1Y/rR0TmYx48jmCWaMw8F1bqN3UY088qAC/y?=
 =?us-ascii?Q?kUwqVjeFpRce8P6fq29Nvz4MQOYVxYn+pWP9GTtTytl3g5GIjKDyLJGhVVkz?=
 =?us-ascii?Q?zlqfAQh6Fpxdsv4cPCHonkHEYOJh/XpO6g7Wtnr7uJTBpe5ku9VY3hnU4qjr?=
 =?us-ascii?Q?VewHbhbrile4OOPWvThxsU/TKwNcQ79mpHa7o5XrAs/vThnZYkFA2bs31Sev?=
 =?us-ascii?Q?SHs07pZZ/PtXOnOxghMaAve6HrffZiwqLd4NITCJHMCaFmUGIvQck5Nne4XO?=
 =?us-ascii?Q?y6BdbPNkcyLzTXXLK9yw6bNS68SXi8QBU1tHEVw3+dGEW5JCeCcH8m+MJxLV?=
 =?us-ascii?Q?Am7w0H6PPMJxzT8zEZC59CC5lbFEJtXbKytONotCMF0XIIwrMRqSLApGaHwk?=
 =?us-ascii?Q?7TN/ZUynKXI8CpgRDV1Ja1C6lZ1W0BaPJaZ4QU5nf+vdSIr4uC/7NnU6pQzp?=
 =?us-ascii?Q?FUld1NAtoY++hlEM8z4EOPMHxEEdxjdI6A1qDct4GDdcd8ZA+46F20X7Ylio?=
 =?us-ascii?Q?TKSp5v3DbFQgl45zt8br9zk9F141BpfMHbcb9z8anwCM2bXISUH6cJS5GOoG?=
 =?us-ascii?Q?Levf1VhfWPgBMWWOL+Sc3IXfvdlWOY+KhxKEcOiDOJXpO8ptFMCZWMhQkufu?=
 =?us-ascii?Q?LlByRwwvIuawuT0ET1S3Fn23wQmNghRQUv9Ns0LE5VQGIMZF9RpDXmuf5wRE?=
 =?us-ascii?Q?ONd3HA=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(376014)(82310400026)(36860700013);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	ezTXioitw4moKYVE1einpPlyPWtptlEQtE4q8qbEryaRcseoZm4lnM00onm20xuAdqifXtmSCskCETav0qkrQ3rs0TfMutPtdVbafd3DFbfE8kx2CEgB1HSPa0x85C83gef6RsLd2RdnZG9HX4yyTA5ay7rgLJdO7vHyXlPFuzwmtpB/GDbCZJvvj6bAUxFeGr1SHlhnt8q/OIG83MNmMjvcH9PBNyIWNTU4xar8T//F3l5y97BAmSk0KXK7LuObnonCTs7a/TpHTEb1Tj5ncDD1/iz7hCZ/skOArSB8trnVpDRhy87dIt4C59PL7k783c22CWPjIQSzg7yn1pb3wF0I3SKPIQqTnnqLu4osN9P4WVufkTPVwqBQ/2G4q27FdOO93GAt62Ti/ELC+lgiiSJ06dGt5B+XDuClYgzPApgY98gr+EyiK2RhkTMgdgBk
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Feb 2026 06:11:24.0370
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c96018b7-766c-4585-066d-08de67a20d70
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SN1PEPF000397B3.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4255
X-Stat-Signature: pexjwdjf9sbia3488y48twz395udqtr9
X-Rspamd-Queue-Id: ABC834000D
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1770617490-789129
X-HE-Meta: U2FsdGVkX18OSWXz/5OdQaAOvoJjhqSQliTca7jAvjsEPgGVkfdWlBq0eTk53GilHyiC6ktrq2ICUmKXhUSSCXFrQzAlhGI07XyGbTS46LPAHTa8RcTOuMYfco4Cx1Wx/bh+iu5YR29IueT3K/MpditoFWf8Xz6eD35BfVmWAOQmoebp6osTHVd0/FknJNeig+1tGpI0Km6JCzGtEBvNAjzAi65ZUEmENwbRLF+8g0XMUqWQBo6YgJH5h0jmZT2n4EhOLVfaZTtKa9mp6aJ5NwXb7QHTE/rOto8UP0/gjOik81yC7dhmDiPEOMXeKMHMVT2RCm45/sprQG98WyROohqQWChI0kOf9UUWGqSAIjJ3SykfobGaIGMUeCZhJMECd6TokfAiyTfP/csi3gqNPqDC0uiC0XDBZx4tGNDWfod/mHBn3gCbRRKaubz/DDyXoH4d3tnl245oJxiNyChhVNT4HHuP7SNrcaX3Uo17Pf5mWK66oXXn/4k+IdgqD2YSDKic2PsCtMV/lBAhkoKltzctmIupPyLlBBoGRUom8dpeRNSxMbHNRz+bx355PSSPJFxI0Nc11isTsSpSDSjuNWlbpqdW7/lhZusp87c1fa8gDNHfSyu+bNWgaJ4pa+jXAN/aHkWQjjoPd+wD0RNtKaXY/X2gEckVgn/KVrneNGA0VJq+aK0Sdg2dP5d4pY/pTs2JhCr3Gfk/4awRR+D9mAmyWrifwbUfZnDbIPazxWbg3/chIuXNZ06tMBEre4u07fHvZ+tpu/6FRQGhMIOlyAsH9MP0+ZrXNffRK8DeaHriM8dGC1WfYyLx3zFUujt8OTL+xup/3kNjL5Uer2mej7I+N0Tc53dZX9ScVQ44P2ovJnnkZWa2KBCrr1JawKvJWv+7zGtNq2b/ZPp9xK+yjuFxQYiUcVfTCmT8hubOHSUnsMFR3n7vaalSL2HttP7PoMaBNV5nK0roejwt7LY
 BVpW7vIX
 NCNjqcuDzxpGIEZ+vzZ5gvZOWGggnt5yPIt4L
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Honglei Huang <honghuan@amd.com>

Implement the main batch userptr allocation function and export it
through the AMDKFD API.

This adds:
- init_user_pages_batch(): initializes batch allocation by setting
  up interval tree, registering single MMU notifier, and getting
  pages for all ranges
- amdgpu_amdkfd_gpuvm_alloc_memory_of_gpu_batch(): main entry point
  for batch userptr allocation
- Function export in amdgpu_amdkfd.h

Signed-off-by: Honglei Huang <honghuan@amd.com>
---
 .../gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c  | 276 ++++++++++++++++++
 1 file changed, 276 insertions(+)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c
index 5f10a4514..c2fc31964 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c
@@ -1247,6 +1247,163 @@ static int set_user_pages_batch(struct ttm_tt *ttm,
 	return 0;
 }
 
+static int init_user_pages_batch(struct kgd_mem *mem,
+				 struct kfd_ioctl_userptr_range *ranges,
+				 uint32_t num_ranges, bool criu_resume,
+				 uint64_t user_addr, uint32_t size)
+{
+	struct amdkfd_process_info *process_info = mem->process_info;
+	struct amdgpu_bo *bo = mem->bo;
+	struct ttm_operation_ctx ctx = { true, false };
+	struct hmm_range *range;
+	uint64_t va_min = ULLONG_MAX, va_max = 0;
+	int ret = 0;
+	uint32_t i;
+
+	if (!num_ranges || !ranges)
+		return -EINVAL;
+
+	mutex_lock(&process_info->lock);
+
+	mem->user_ranges = kvcalloc(num_ranges, sizeof(struct user_range_info), 
+				    GFP_KERNEL);
+
+	if (!mem->user_ranges) {
+		ret = -ENOMEM;
+		goto out;
+	}
+	mem->num_user_ranges = num_ranges;
+
+	mem->user_ranges_itree = RB_ROOT_CACHED;
+
+	ret = amdgpu_ttm_tt_set_userptr(&bo->tbo, user_addr, 0);
+	if (ret) {
+		pr_err("%s: Failed to set userptr: %d\n", __func__, ret);
+		goto out;
+	}
+
+	for (i = 0; i < num_ranges; i++) {
+		uint64_t range_end;
+
+		mem->user_ranges[i].start = ranges[i].start;
+		mem->user_ranges[i].size = ranges[i].size;
+		mem->user_ranges[i].range = NULL;
+		mem->user_ranges[i].valid = false;
+
+		range_end = ranges[i].start + ranges[i].size;
+
+		mem->user_ranges[i].it_node.start = ranges[i].start;
+		mem->user_ranges[i].it_node.last = range_end - 1;
+		interval_tree_insert(&mem->user_ranges[i].it_node, &mem->user_ranges_itree);
+
+		if (ranges[i].start < va_min)
+			va_min = ranges[i].start;
+		if (range_end > va_max)
+			va_max = range_end;
+
+		pr_debug("Initializing userptr range %u: addr=0x%llx size=0x%llx\n",
+			 i, mem->user_ranges[i].start, mem->user_ranges[i].size);
+	}
+
+	mem->batch_va_min = va_min;
+	mem->batch_va_max = va_max;
+
+	pr_debug("Batch userptr: registering single notifier for span [0x%llx - 0x%llx)\n",
+		 va_min, va_max);
+
+	ret = mmu_interval_notifier_insert(&mem->batch_notifier,
+					   current->mm, va_min, va_max - va_min,
+					   &amdgpu_amdkfd_hsa_batch_ops);
+	if (ret) {
+		pr_err("%s: Failed to register batch MMU notifier: %d\n",
+		       __func__, ret);
+		goto err_cleanup_ranges;
+	}
+
+	if (criu_resume) {
+		mutex_lock(&process_info->notifier_lock);
+		mem->invalid++;
+		mutex_unlock(&process_info->notifier_lock);
+		mutex_unlock(&process_info->lock);
+		return 0;
+	}
+
+	if (!mmget_not_zero(current->mm)) {
+		ret = -ESRCH;
+		goto err_unregister;
+	}
+
+	mmap_read_lock(current->mm);
+	for (i = 0; i < num_ranges; i++) {
+		ret = get_user_pages_batch_locked(
+			current->mm, mem, &mem->user_ranges[i], &range,
+			amdgpu_ttm_tt_is_readonly(bo->tbo.ttm));
+		if (ret) {
+			if (ret == -EAGAIN)
+				pr_debug("Failed to get user pages for range %u, try again\n", i);
+			else
+				pr_err("%s: Failed to get user pages for range %u: %d\n",
+				       __func__, i, ret);
+			mmap_read_unlock(current->mm);
+			mmput(current->mm);
+			goto err_unregister;
+		}
+
+		mem->user_ranges[i].range = range;
+		mem->user_ranges[i].valid = true;
+	}
+	mmap_read_unlock(current->mm);
+	mmput(current->mm);
+
+	ret = amdgpu_bo_reserve(bo, true);
+	if (ret) {
+		pr_err("%s: Failed to reserve BO\n", __func__);
+		goto release_pages;
+	}
+
+	if (bo->tbo.ttm->pages) {
+		set_user_pages_batch(bo->tbo.ttm,
+						     mem->user_ranges,
+						     num_ranges);
+	} else {
+		pr_err("%s: TTM pages array is NULL\n", __func__);
+		ret = -EINVAL;
+		amdgpu_bo_unreserve(bo);
+		goto release_pages;
+	}
+
+	amdgpu_bo_placement_from_domain(bo, mem->domain);
+	ret = ttm_bo_validate(&bo->tbo, &bo->placement, &ctx);
+	if (ret)
+		pr_err("%s: failed to validate BO\n", __func__);
+	
+	amdgpu_bo_unreserve(bo);
+
+release_pages:
+	for (i = 0; i < num_ranges; i++) {
+		if (mem->user_ranges[i].range) {
+			amdgpu_ttm_tt_get_user_pages_done(bo->tbo.ttm, 
+							  mem->user_ranges[i].range);
+		}
+	}
+
+err_unregister:
+	if (ret && mem->batch_notifier.mm) {
+		mmu_interval_notifier_remove(&mem->batch_notifier);
+		mem->batch_notifier.mm = NULL;
+	}
+err_cleanup_ranges:
+	if (ret) {
+		for (i = 0; i < num_ranges; i++) {
+			mem->user_ranges[i].range = NULL;
+		}
+	}
+
+out:
+	mutex_unlock(&process_info->lock);
+	return ret;
+}
+
 /* Reserving a BO and its page table BOs must happen atomically to
  * avoid deadlocks. Some operations update multiple VMs at once. Track
  * all the reservation info in a context structure. Optionally a sync
@@ -2005,6 +2162,125 @@ int amdgpu_amdkfd_gpuvm_alloc_memory_of_gpu(
 	return ret;
 }
 
+int amdgpu_amdkfd_gpuvm_alloc_memory_of_gpu_batch(
+	struct amdgpu_device *adev, uint64_t va, uint64_t size, void *drm_priv,
+	struct kgd_mem **mem, uint64_t *offset,
+	struct kfd_ioctl_userptr_range *ranges, uint32_t num_ranges,
+	uint32_t flags, bool criu_resume)
+{
+	struct amdgpu_vm *avm = drm_priv_to_vm(drm_priv);
+	struct amdgpu_bo *bo;
+	struct drm_gem_object *gobj = NULL;
+	u32 domain, alloc_domain;
+	uint64_t aligned_size;
+	int8_t xcp_id = -1;
+	u64 alloc_flags;
+	int ret;
+
+	if (!(flags & KFD_IOC_ALLOC_MEM_FLAGS_USERPTR)) {
+		pr_err("Batch allocation requires USERPTR flag\n");
+		return -EINVAL;
+	}
+
+	if (flags & KFD_IOC_ALLOC_MEM_FLAGS_AQL_QUEUE_MEM) {
+		pr_err("Batch userptr does not support AQL queue\n");
+		return -EINVAL;
+	}
+
+	domain = AMDGPU_GEM_DOMAIN_GTT;
+	alloc_domain = AMDGPU_GEM_DOMAIN_CPU;
+	alloc_flags = AMDGPU_GEM_CREATE_PREEMPTIBLE;
+
+	if (flags & KFD_IOC_ALLOC_MEM_FLAGS_COHERENT)
+		alloc_flags |= AMDGPU_GEM_CREATE_COHERENT;
+	if (flags & KFD_IOC_ALLOC_MEM_FLAGS_EXT_COHERENT)
+		alloc_flags |= AMDGPU_GEM_CREATE_EXT_COHERENT;
+	if (flags & KFD_IOC_ALLOC_MEM_FLAGS_UNCACHED)
+		alloc_flags |= AMDGPU_GEM_CREATE_UNCACHED;
+
+	*mem = kzalloc(sizeof(struct kgd_mem), GFP_KERNEL);
+	if (!*mem) {
+		ret = -ENOMEM;
+		goto err;
+	}
+	INIT_LIST_HEAD(&(*mem)->attachments);
+	mutex_init(&(*mem)->lock);
+	(*mem)->aql_queue = false;
+
+	aligned_size = PAGE_ALIGN(size);
+
+	(*mem)->alloc_flags = flags;
+
+	amdgpu_sync_create(&(*mem)->sync);
+
+	ret = amdgpu_amdkfd_reserve_mem_limit(adev, aligned_size, flags,
+					      xcp_id);
+	if (ret) {
+		pr_debug("Insufficient memory\n");
+		goto err_reserve_limit;
+	}
+
+	pr_debug("\tcreate BO VA 0x%llx size 0x%llx for batch userptr (ranges=%u)\n",
+		 va, size, num_ranges);
+
+	ret = amdgpu_gem_object_create(adev, aligned_size, 1, alloc_domain, alloc_flags,
+				       ttm_bo_type_device, NULL, &gobj, xcp_id + 1);
+	if (ret) {
+		pr_debug("Failed to create BO on domain %s. ret %d\n",
+			 domain_string(alloc_domain), ret);
+		goto err_bo_create;
+	}
+
+	ret = drm_vma_node_allow(&gobj->vma_node, drm_priv);
+	if (ret) {
+		pr_debug("Failed to allow vma node access. ret %d\n", ret);
+		goto err_node_allow;
+	}
+
+	ret = drm_gem_handle_create(adev->kfd.client.file, gobj, &(*mem)->gem_handle);
+	if (ret)
+		goto err_gem_handle_create;
+
+	bo = gem_to_amdgpu_bo(gobj);
+	bo->kfd_bo = *mem;
+	bo->flags |= AMDGPU_AMDKFD_CREATE_USERPTR_BO;
+
+	(*mem)->bo = bo;
+	(*mem)->va = va;
+	(*mem)->domain = domain;
+	(*mem)->mapped_to_gpu_memory = 0;
+	(*mem)->process_info = avm->process_info;
+
+	add_kgd_mem_to_kfd_bo_list(*mem, avm->process_info, ranges[0].start);
+
+	ret = init_user_pages_batch(*mem, ranges, num_ranges, criu_resume, va, aligned_size);
+	if (ret) {
+		pr_err("Failed to initialize batch user pages: %d\n", ret);
+		goto allocate_init_user_pages_failed;
+	}
+
+	return 0;
+
+allocate_init_user_pages_failed:
+	remove_kgd_mem_from_kfd_bo_list(*mem, avm->process_info);
+	drm_gem_handle_delete(adev->kfd.client.file, (*mem)->gem_handle);
+err_gem_handle_create:
+	drm_vma_node_revoke(&gobj->vma_node, drm_priv);
+err_node_allow:
+	goto err_reserve_limit;
+err_bo_create:
+	amdgpu_amdkfd_unreserve_mem_limit(adev, aligned_size, flags, xcp_id);
+err_reserve_limit:
+	amdgpu_sync_free(&(*mem)->sync);
+	mutex_destroy(&(*mem)->lock);
+	if (gobj)
+		drm_gem_object_put(gobj);
+	else
+		kfree(*mem);
+err:
+	return ret;
+}
+
 int amdgpu_amdkfd_gpuvm_free_memory_of_gpu(
 		struct amdgpu_device *adev, struct kgd_mem *mem, void *drm_priv,
 		uint64_t *size)
-- 
2.34.1


