Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B904FE75448
	for <linux-mm@archiver.kernel.org>; Wed, 24 Dec 2025 11:20:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 07B646B0005; Wed, 24 Dec 2025 06:20:22 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F40FB6B0088; Wed, 24 Dec 2025 06:20:21 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DEAD26B008A; Wed, 24 Dec 2025 06:20:21 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id CA13D6B0005
	for <linux-mm@kvack.org>; Wed, 24 Dec 2025 06:20:21 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 865F5C016D
	for <linux-mm@kvack.org>; Wed, 24 Dec 2025 11:20:21 +0000 (UTC)
X-FDA: 84254121042.08.9F9A117
Received: from DM5PR21CU001.outbound.protection.outlook.com (mail-centralusazon11011065.outbound.protection.outlook.com [52.101.62.65])
	by imf10.hostedemail.com (Postfix) with ESMTP id 9BBD1C000C
	for <linux-mm@kvack.org>; Wed, 24 Dec 2025 11:20:18 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b="C/5sXta2";
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf10.hostedemail.com: domain of shivankg@amd.com designates 52.101.62.65 as permitted sender) smtp.mailfrom=shivankg@amd.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1766575218; a=rsa-sha256;
	cv=pass;
	b=FAQQezz3nXo3YpR/eQLBNX9bPe1jJHu6UmQZY3f44M88Cu8Hr8rNtRT79uILBu39+qfuxA
	pjbmSfOzAdUeEt+o4Uu0POB5AMOhgPFK3c4p/RTx4APk2bM2MZiEcmY7CnT1JYKuuV6DYi
	ZBI7RL2ru5gFYVMMiUALoWD+8a+QkoU=
ARC-Authentication-Results: i=2;
	imf10.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b="C/5sXta2";
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf10.hostedemail.com: domain of shivankg@amd.com designates 52.101.62.65 as permitted sender) smtp.mailfrom=shivankg@amd.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766575218;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HcD1OcYA2MmW7Eytftz0VSG1J++S1TspRHCN6WkoyR4=;
	b=PxPffjMT/Qpw+Gc5QrYdeabAXsO8bfy3UQDw0iYOXI45rjkuaDVcPURRVmlBtsGgV37d1G
	kT/R6GMmP6Yh0wdkHWTkRWuawtngeLV18AxNw2KuYjewGza2MmuIS1x7D/PjmmjFrb2pkv
	PVBxuFH4Yz0dp9MU4opLn12KsRhDjfs=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=HFOXCqr4Lw/tTh8ELrWmobipOHsJ3ZiP1I/VgIqjnuKKoejIs+1PUUHb2NaRPwXiZtt8z4hk5Tm3ZLMASOgfe4eY+EhL1KI6zZVpbxmL4AX4dhE96ZhAOHAyHREOle2QxenqLd642UzwDSMsukUTfJMwBJqch7Qby3wEq1bWfOZUl8seCdGOuoRvFWogoMvKkxxEYpvplQnEJeNDxHruJEdGXsD6aqwMuPUdi+TM8olVUL6KNyik2ckA6xcWFO8vLbqBX/Ej4l+tPhIprjLM0mNrs2a0GSHNfkzisjx2X2G2wsj9wplGyG01q4N5ApJu4m/jv4M/haPAGpH0s19H6Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HcD1OcYA2MmW7Eytftz0VSG1J++S1TspRHCN6WkoyR4=;
 b=HeVuufyEtwtKBgVDpsbZrcc6PPD31zh9f2rdwYyDAx0GS7CdDEC+7u8u1/c9f0zRJeLKv7JxjbdBAN/u+Qj4stJhrtE5sxpHZduyECKZtoax050ZMIMRzrpNXbKGq+8JaTU7D9OZ19Xoj0I1W7toCVA7sWmh7xdRYJn/9nOIYIktvow7/PaUoi4/IBjWTxXM8FTr8tP8mNEBSRy0AETWqfHNq1X14xPxPhhNQRL6JfuqxG/fuksNSjQiMh22EG4jUElbNA+t6jYTh+muCl4rlftqkmKo7qkAOjlWKAQgWbi0KVsXqwrpa8GRjp0vKZinPNBB4/B/Un8Okd6IAtq3YQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=linux-foundation.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HcD1OcYA2MmW7Eytftz0VSG1J++S1TspRHCN6WkoyR4=;
 b=C/5sXta25wNCzlTovdhHVHI+yw0w5qFt16h18w4aREa8jfg6X8bCFovyL1bHKayTB7/fKHCNdTou3mkHqGmeFUFEMb1KGYPwKe5Rc8EOjqk8HBL8e6+23qY3OLFEO/lWlQvJ7DJmLzzsf5uIdJgBm2vt5mR34DqTeYQ8pBwbJLk=
Received: from SJ0PR13CA0019.namprd13.prod.outlook.com (2603:10b6:a03:2c0::24)
 by DM4PR12MB7597.namprd12.prod.outlook.com (2603:10b6:8:10b::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9456.11; Wed, 24 Dec
 2025 11:20:13 +0000
Received: from SJ1PEPF0000231A.namprd03.prod.outlook.com
 (2603:10b6:a03:2c0:cafe::d4) by SJ0PR13CA0019.outlook.office365.com
 (2603:10b6:a03:2c0::24) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9478.2 via Frontend Transport; Wed,
 24 Dec 2025 11:20:13 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 SJ1PEPF0000231A.mail.protection.outlook.com (10.167.242.231) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9456.9 via Frontend Transport; Wed, 24 Dec 2025 11:20:13 +0000
Received: from kaveri.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Wed, 24 Dec
 2025 05:20:05 -0600
From: Shivank Garg <shivankg@amd.com>
To: Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand
	<david@kernel.org>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
CC: Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>,
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song
	<baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, <linux-mm@kvack.org>,
	<linux-kernel@vger.kernel.org>, <shivankg@amd.com>
Subject: [PATCH V2 3/5] mm/khugepaged: change collapse_pte_mapped_thp() to return void
Date: Wed, 24 Dec 2025 11:13:55 +0000
Message-ID: <20251224111351.41042-10-shivankg@amd.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20251224111351.41042-4-shivankg@amd.com>
References: <20251224111351.41042-4-shivankg@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: satlexmb08.amd.com (10.181.42.217) To satlexmb07.amd.com
 (10.181.42.216)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PEPF0000231A:EE_|DM4PR12MB7597:EE_
X-MS-Office365-Filtering-Correlation-Id: ba72d208-6b71-45f9-e83c-08de42de685e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|36860700013|1800799024|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?DT2AsonanOT5uRMr+D5TumWFzavYaRDuq3W2/7RLm5SSNySERGKL80IilOuk?=
 =?us-ascii?Q?ZNvNhWrAN+kC9TAexrPskNsFmoPkcBnizy4A4UownOhQYe+YxeS/f2WtHJJG?=
 =?us-ascii?Q?c3qwW/jlWKLPRDjQFcmNApBkmiNV4eOnz9iVtbByoz5j3afRaj0G7fhw/D3U?=
 =?us-ascii?Q?plkxR40VUeyuHbn5A0hDn9eit3lyAbKR1xOPpGOPe6PyDkxNn4j+jYXHe6uR?=
 =?us-ascii?Q?tMDSwJ2cQ5gns6kZRFhMjZ+DMgfrv1nnhx9cO+TlKPKNm2rrKY5lIAKuhrty?=
 =?us-ascii?Q?ZMI3kRvmOiz94iHJumO+ajrKlSg/87ErXdkExr90YlLtuyGZcFJ1Z//PpeuE?=
 =?us-ascii?Q?mOrl6DDqTfKiy7yOfcRD/TyOLtqQxVls9+kZJL9blxSUeepodlNDeJ9qxQMH?=
 =?us-ascii?Q?PNQcwbdcixvgFA79xWjnpmz9+kwlYFqEC5MbV8lvYdsp4VgoV6J04K5YFsPq?=
 =?us-ascii?Q?JMc/09tgm0WR3DGTeLfBNcV/TyOdvabmWOvGBcdh/hfAkVnugL5qdhgkYj0/?=
 =?us-ascii?Q?x0jwV+sHJUoobFAnuYfucwew4leyf0WOwJvpnO9RvUfOhwouUG1WTxmmzysG?=
 =?us-ascii?Q?GXbN2Z62oYVcMXYALN82DlZ/OUD3VM8ZnfrhcaB6g0q5fGABksVymAiJcS89?=
 =?us-ascii?Q?1jQ8C2VxpqRAr1zOWuIdRIhnn92+1I0y0H/yg96fhkHhaRb1ko4VfUhabd8G?=
 =?us-ascii?Q?ZkdsmLHY3/PSPKT9ZpLG9z8EQtEQf16lUqVqx0AuXPA+bH74Gl6xxF16QUvG?=
 =?us-ascii?Q?YWPDF08hJ4JXpAHoubVjJqVLpiWiyAkvsiYdvcXsMP2tfSrKBtsS6Sn4OQav?=
 =?us-ascii?Q?bsMpksiEnULGzRxxAL7Lbqm9XJB+nsjMZGvp4gTeM+3dwdO6QWvgKrEUa/6M?=
 =?us-ascii?Q?euOzGYlnfiBfONRExn6M6Nk27hS98MVFH0Q+ErmQN0Ped7v4uxWUDw872dL9?=
 =?us-ascii?Q?spRepbHB18eEAj3RDYxDFWXG4KU8uceAaXACQT51WqAjLXrkLe7b8GGXvn56?=
 =?us-ascii?Q?GYDFZRBCc58OuwjUdolRRwunuC2+/mZxaEh3NR+PIrBBna40JJoIjr0b1KhF?=
 =?us-ascii?Q?ITRpIGeFvBPMlSLh/wppXf55pChPC7YRB6ZexaYk04VGNICKheGNvwsgWxuE?=
 =?us-ascii?Q?IpFtJj36GbU0Xe3nRHN/L1BmsAwsChREI19mxXz1vo+NCXB2FGznxuHm9aa1?=
 =?us-ascii?Q?2vzRMmMRb32pdVzJTiMSsmLpAg3bI1gONSMV2Ny4oS2QC6x+7Tmc3eesnrZ+?=
 =?us-ascii?Q?OOQEnJWrTWO9+/DQUKJMN9CV6igEsrIZXw1ZFpI47pm7zvWY+tjDxwQJrawU?=
 =?us-ascii?Q?nOBpUZBEYyIMDF73ioLRok9KOBVuNAEjmdNJsAwEk2c0hCy+nGn6bW9xO2y5?=
 =?us-ascii?Q?y3gclCnHnu+ZIo/JBtorrVhyvJjNlQTDSFQDjOoTlugsRWYGPekKjO6xhA1n?=
 =?us-ascii?Q?Dcv+d0D5SB21KXP+Xy9P075sVqo3JPQntnNB2YFISdM/BtRKhGuLCzvv4ucy?=
 =?us-ascii?Q?ZcQ37XRsXL53gU74lXqk4jjRGiG3mSQYMoo58OmNHPGsrHIGXd53pAYzpQ?=
 =?us-ascii?Q?=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(7416014)(376014)(36860700013)(1800799024)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Dec 2025 11:20:13.3067
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ba72d208-6b71-45f9-e83c-08de42de685e
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF0000231A.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB7597
X-Rspamd-Queue-Id: 9BBD1C000C
X-Rspamd-Server: rspam03
X-Stat-Signature: 8aw3tn9bkotxj91mfswx8spdjwd953wa
X-Rspam-User: 
X-HE-Tag: 1766575218-977490
X-HE-Meta: U2FsdGVkX1+RymPLQqtXo3t4xOgS6tr/OE33OfkNx+6KoKgJ6GQ+i6mFigsQszecKJdLKjtQ+OmC/w4EErqYDhtaeKGwJGK2qs4sQSINkiNKJ/aUQGa1FpAxBGR6cqWEpCWJIqh/MfK5au7C7MMWGUIBYceUg6xOAZuCFb+L4Vf8ArN9oUxDDyk26IXYER1htwf5UmvzIPhrtQSZel2k1NxNuN2DwGYvGwZLDHQ74CUIhz0RUEYZyNtxB6el+mSWmZf2LzL8m79ajvh+wz5dx5WoC6WgO2uKid9qmWu2xWbKEbT2MrtlIkXRuKuRbpOOG+bRZmMt+kNJyR4xgGWfAsc5YFPNt/xidtCScnTq1OAqi4tVCIBczvJI/gxRb9NWQv4uonsG2mSHZp+0KNjcS6qR2aZaUsJCETgf46sIsNC546ImaS5n7o6BMpOcwUh60adHRzL7CN8apxXeWnEqHHRuHgxIIwOad2ESc6HrvfaVMXozTgHFHbt2rnOsmoEhfFzrlcj04MWIWDopVkgDTGGddi0niTB++yd2p3asJ0Ezi2LI/0WlaAXMKL40B+7NGtpuRI7I7uYQJKR+ZI469FU9SUsqmSwZm6/zUxZznmLXqPupACH7oSBMkOUsqUpCG7N6pInhnXazZrAsYmAn16eiPhCGLWd9ahxl2LDvV+IZL3UJz+GpFM3h/pjC1QjMo+FiMf2+tB4jUgI86wsjcK8xs0g3oO7e3YSaRwuZq4v2x8tFtUQzcRZx0b3a9KF61uMEcvgzCkashXJa9ahWcP8SsQGt1RO6YeRtj2Swg5GEc2ZyOhZuFHjHNPAfmZd0b5mnwGPHZ/f1hXfHqC0eBNpoIQTTFy9VOHhTE/hJS3iMBBDQRbbDsYXYPHi7K8FzmR8+HOijQ3O84GqxVqlVpXUpwoObmuVNbATQ7RlAVZYOrXrPmTMxNaUDXF4QMIN0+o1QGrzm+sdUsHA3i14
 t+n6Yqwg
 EFtPYAVD9pCnuef2E40GTw0xUtRigXYfEiMnJyBFadVIDb0fWgRyQeTCq/b0O3NZq/FwDOVMBTrKnapN8BR7owTV77Gev3AQ2eF048ZH7BKK61ZswIVNHNl8YYgJ764h51cm2l/NgUMl9NrmszmMRarl0a7Ar46WWM9di9PfEFl/Qkvzl7/IDp9X3u8slSBx0WRLuthCvuh7jSmoCuASNR6P7KiOS4OzzHFm4Bihyi5hvPo910V3DcAkdDRo8Zymd7FjJoZbKjbFA515Ddkg3j6rzRM0osOxZesFDKb5wU4UJpVU/RA8NjPl2B/KSlJz5gGdZ3sj3J0CFtiohDs6amcRbKoIWflU+L5WwOuXotIVsi45i9448g/gXcXOWWZ8wKd722YPcnnX4fnoD/T5yDpVbr6vo+d4L1x1tshKUXcM318Nx/ns55rate0fhhMc9Kx6fRhLxNpXR2CxMrp3N0vQF3ybrYVgNcBZ/g/5Js+Z2XgQr2PWyfbjN5JPmymEbuBHCAlqTmiOGDeERhUrICs+GJH3GZH8Q07w7FI70XG50uNBO/YN64wQ09A==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The only external caller of collapse_pte_mapped_thp() is uprobe, which
ignores the return value. Change the external API to return void to
simplify the interface.

Introduce try_collapse_pte_mapped_thp() for internal use that preserves
the return value. This prepares for future patch that will convert
the return type to use enum scan_result.

Suggested-by: David Hildenbrand (Red Hat) <david@kernel.org>
Signed-off-by: Shivank Garg <shivankg@amd.com>
---
 include/linux/khugepaged.h |  9 ++++-----
 mm/khugepaged.c            | 40 ++++++++++++++++++++++----------------
 2 files changed, 27 insertions(+), 22 deletions(-)

diff --git a/include/linux/khugepaged.h b/include/linux/khugepaged.h
index eb1946a70cff..37b992b22bba 100644
--- a/include/linux/khugepaged.h
+++ b/include/linux/khugepaged.h
@@ -17,8 +17,8 @@ extern void khugepaged_enter_vma(struct vm_area_struct *vma,
 				 vm_flags_t vm_flags);
 extern void khugepaged_min_free_kbytes_update(void);
 extern bool current_is_khugepaged(void);
-extern int collapse_pte_mapped_thp(struct mm_struct *mm, unsigned long addr,
-				   bool install_pmd);
+extern void collapse_pte_mapped_thp(struct mm_struct *mm, unsigned long addr,
+				    bool install_pmd);
 
 static inline void khugepaged_fork(struct mm_struct *mm, struct mm_struct *oldmm)
 {
@@ -42,10 +42,9 @@ static inline void khugepaged_enter_vma(struct vm_area_struct *vma,
 					vm_flags_t vm_flags)
 {
 }
-static inline int collapse_pte_mapped_thp(struct mm_struct *mm,
-					  unsigned long addr, bool install_pmd)
+static inline void collapse_pte_mapped_thp(struct mm_struct *mm,
+					   unsigned long addr, bool install_pmd)
 {
-	return 0;
 }
 
 static inline void khugepaged_min_free_kbytes_update(void)
diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index 0b549c3250f9..04ff0730c9a1 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -1477,20 +1477,8 @@ static int set_huge_pmd(struct vm_area_struct *vma, unsigned long addr,
 	return SCAN_SUCCEED;
 }
 
-/**
- * collapse_pte_mapped_thp - Try to collapse a pte-mapped THP for mm at
- * address haddr.
- *
- * @mm: process address space where collapse happens
- * @addr: THP collapse address
- * @install_pmd: If a huge PMD should be installed
- *
- * This function checks whether all the PTEs in the PMD are pointing to the
- * right THP. If so, retract the page table so the THP can refault in with
- * as pmd-mapped. Possibly install a huge PMD mapping the THP.
- */
-int collapse_pte_mapped_thp(struct mm_struct *mm, unsigned long addr,
-			    bool install_pmd)
+static int try_collapse_pte_mapped_thp(struct mm_struct *mm, unsigned long addr,
+				       bool install_pmd)
 {
 	int nr_mapped_ptes = 0, result = SCAN_FAIL;
 	unsigned int nr_batch_ptes;
@@ -1711,6 +1699,24 @@ int collapse_pte_mapped_thp(struct mm_struct *mm, unsigned long addr,
 	return result;
 }
 
+/**
+ * collapse_pte_mapped_thp - Try to collapse a pte-mapped THP for mm at
+ * address haddr.
+ *
+ * @mm: process address space where collapse happens
+ * @addr: THP collapse address
+ * @install_pmd: If a huge PMD should be installed
+ *
+ * This function checks whether all the PTEs in the PMD are pointing to the
+ * right THP. If so, retract the page table so the THP can refault in with
+ * as pmd-mapped. Possibly install a huge PMD mapping the THP.
+ */
+void collapse_pte_mapped_thp(struct mm_struct *mm, unsigned long addr,
+			     bool install_pmd)
+{
+	try_collapse_pte_mapped_thp(mm, addr, install_pmd);
+}
+
 /* Can we retract page tables for this file-backed VMA? */
 static bool file_backed_vma_is_retractable(struct vm_area_struct *vma)
 {
@@ -2227,7 +2233,7 @@ static int collapse_file(struct mm_struct *mm, unsigned long addr,
 
 	/*
 	 * Remove pte page tables, so we can re-fault the page as huge.
-	 * If MADV_COLLAPSE, adjust result to call collapse_pte_mapped_thp().
+	 * If MADV_COLLAPSE, adjust result to call try_collapse_pte_mapped_thp().
 	 */
 	retract_page_tables(mapping, start);
 	if (cc && !cc->is_khugepaged)
@@ -2479,7 +2485,7 @@ static unsigned int khugepaged_scan_mm_slot(unsigned int pages, int *result,
 					mmap_read_lock(mm);
 					if (hpage_collapse_test_exit_or_disable(mm))
 						goto breakouterloop;
-					*result = collapse_pte_mapped_thp(mm,
+					*result = try_collapse_pte_mapped_thp(mm,
 						khugepaged_scan.address, false);
 					if (*result == SCAN_PMD_MAPPED)
 						*result = SCAN_SUCCEED;
@@ -2869,7 +2875,7 @@ int madvise_collapse(struct vm_area_struct *vma, unsigned long start,
 		case SCAN_PTE_MAPPED_HUGEPAGE:
 			BUG_ON(mmap_locked);
 			mmap_read_lock(mm);
-			result = collapse_pte_mapped_thp(mm, addr, true);
+			result = try_collapse_pte_mapped_thp(mm, addr, true);
 			mmap_read_unlock(mm);
 			goto handle_result;
 		/* Whitelisted set of results where continuing OK */
-- 
2.43.0


