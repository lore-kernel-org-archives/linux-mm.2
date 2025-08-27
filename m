Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D33CCCA0EFF
	for <linux-mm@archiver.kernel.org>; Wed, 27 Aug 2025 17:56:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 327BA6B0011; Wed, 27 Aug 2025 13:56:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2D86D6B0012; Wed, 27 Aug 2025 13:56:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1A01E6B0022; Wed, 27 Aug 2025 13:56:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 037EC6B0011
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 13:56:22 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 9B8E5139B5A
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 17:56:21 +0000 (UTC)
X-FDA: 83823291762.28.07ADCD6
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2073.outbound.protection.outlook.com [40.107.94.73])
	by imf27.hostedemail.com (Postfix) with ESMTP id A4AB74000E
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 17:56:18 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=nelJyJKs;
	spf=pass (imf27.hostedemail.com: domain of shivankg@amd.com designates 40.107.94.73 as permitted sender) smtp.mailfrom=shivankg@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1756317378; a=rsa-sha256;
	cv=pass;
	b=N+LWmSF9r1n0Ji2ljipvXcxCTenUdKY/9jMcFGXypQ6mhAyt7ocdvzME5CGcrJdVVwvETr
	Oyey+VYr0yfCsukNt+v/THrfzMNMSVMcPr/eL9oiD7GDQTgEgjwuWBgJ/JuzvWLrgFAcWe
	eG/tT/gGrF42XfAzssT+7/WpfXTVE2U=
ARC-Authentication-Results: i=2;
	imf27.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=nelJyJKs;
	spf=pass (imf27.hostedemail.com: domain of shivankg@amd.com designates 40.107.94.73 as permitted sender) smtp.mailfrom=shivankg@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756317378;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=y75Q8MqndSRaK4P6oNN37wksFaVUcvm+cXegoSGHPWI=;
	b=ZBwdoUAYX77rjtENbPtlkPOjDiv+6ThrwR7b1P7oijTMYnPatUQhHUzJf2EyBYa8f2w1o8
	U7eqs7/3YPahijYETRZdIjHXZQOZPE1UOM71l+jD7lCiSWjh7fvNDbt0PqmHtpAxiwbXpx
	xf1Rx+BwSAqrHj4sjXxADCEsaZWAgX4=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=xHPg9CeJCZFEGf2ux5NXtPcE1TGbWaKcz6z+jExTNQsaGUKF555a1J53T/ABH9ZHQ+gdBiNcj4dUbTe+JCn2iz0WLDnyMJfRxqRC6nZoIEaeJAOWIqdkuAYxDVR6ewbjQrLOsnJ1zxZrbN4vziei+IOq151EVXYmSjY++3Zd2il6jVO5dRb4xz36O+L24Mem7bykUeIMwLLB12TQcG1jrWD/IIP8JOI+R5CG349dP/Wz1Z1uvEc76Ch5b94dM6RL/50ROI54EQQ7cVTUn4msYuBwcUgfrbboDnDtp6xCbcZOlnfRgMbAzYYcAFET2VqDl5XauK1HgITcDdS5Dh0Y9Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=y75Q8MqndSRaK4P6oNN37wksFaVUcvm+cXegoSGHPWI=;
 b=oHpqjEb2bpx/Y6rB243laenKGpszTVUwsNpOW90W67gh+P8d3+ttPQAaZhiFYXENRu1ZcUPrZnLuR9hZtWkvTnKuTV2WBffSFJcTrrkzjrWIAJAwvsFFDUuOzCpbR8io9vIXLd4j/aZIhWm896X+1p/b/CbLZ7YPxMjNEsFACt2HbMRz3IHCVSYnE40Rk0Zclead6YZeERubBz7+9Gjyxq3+MhiFOH/0DbKVjs30vivw3BQrSONTNP+dVBfgxCSLuMWJbGjcxwY8LbPlEfVE2+hByjI6icSYRp+uFSACtsT5ReiParHHxmIiw9uzEbZi7yQDyVi0o19cPyNxrCVX2Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=infradead.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=y75Q8MqndSRaK4P6oNN37wksFaVUcvm+cXegoSGHPWI=;
 b=nelJyJKsrjv3ul/2fYdQkjcfgyr7qNBSYgYaX9iqxiU0C1IlshpBHHuSxAxhEA1u4u5NR2azbryevOxU3UMP5SOMO//XPQNGqiTVUl34WAan5BOv1JfV8fVWT2VEgQ3DsPsjgOdAz6cbNmKN1Kf67AWSSTKwVj/quMHHFz5gEWs=
Received: from MW4PR04CA0033.namprd04.prod.outlook.com (2603:10b6:303:6a::8)
 by LV8PR12MB9263.namprd12.prod.outlook.com (2603:10b6:408:1e6::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9052.19; Wed, 27 Aug
 2025 17:56:11 +0000
Received: from SJ1PEPF000023D0.namprd02.prod.outlook.com
 (2603:10b6:303:6a:cafe::c6) by MW4PR04CA0033.outlook.office365.com
 (2603:10b6:303:6a::8) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9073.14 via Frontend Transport; Wed,
 27 Aug 2025 17:56:11 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SJ1PEPF000023D0.mail.protection.outlook.com (10.167.244.4) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.9052.8 via Frontend Transport; Wed, 27 Aug 2025 17:56:10 +0000
Received: from kaveri.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Wed, 27 Aug
 2025 12:55:46 -0500
From: Shivank Garg <shivankg@amd.com>
To: <willy@infradead.org>, <akpm@linux-foundation.org>, <david@redhat.com>,
	<pbonzini@redhat.com>, <shuah@kernel.org>, <seanjc@google.com>,
	<vbabka@suse.cz>
CC: <brauner@kernel.org>, <viro@zeniv.linux.org.uk>, <dsterba@suse.com>,
	<xiang@kernel.org>, <chao@kernel.org>, <jaegeuk@kernel.org>, <clm@fb.com>,
	<josef@toxicpanda.com>, <kent.overstreet@linux.dev>, <zbestahu@gmail.com>,
	<jefflexu@linux.alibaba.com>, <dhavale@google.com>, <lihongbo22@huawei.com>,
	<lorenzo.stoakes@oracle.com>, <Liam.Howlett@oracle.com>, <rppt@kernel.org>,
	<surenb@google.com>, <mhocko@suse.com>, <ziy@nvidia.com>,
	<matthew.brost@intel.com>, <joshua.hahnjy@gmail.com>, <rakie.kim@sk.com>,
	<byungchul@sk.com>, <gourry@gourry.net>, <ying.huang@linux.alibaba.com>,
	<apopple@nvidia.com>, <tabba@google.com>, <ackerleytng@google.com>,
	<shivankg@amd.com>, <paul@paul-moore.com>, <jmorris@namei.org>,
	<serge@hallyn.com>, <pvorel@suse.cz>, <bfoster@redhat.com>,
	<vannapurve@google.com>, <chao.gao@intel.com>, <bharata@amd.com>,
	<nikunj@amd.com>, <michael.day@amd.com>, <shdhiman@amd.com>,
	<yan.y.zhao@intel.com>, <Neeraj.Upadhyay@amd.com>, <thomas.lendacky@amd.com>,
	<michael.roth@amd.com>, <aik@amd.com>, <jgg@nvidia.com>,
	<kalyazin@amazon.com>, <peterx@redhat.com>, <jack@suse.cz>,
	<hch@infradead.org>, <cgzones@googlemail.com>, <ira.weiny@intel.com>,
	<rientjes@google.com>, <roypat@amazon.co.uk>, <chao.p.peng@intel.com>,
	<amit@infradead.org>, <ddutile@redhat.com>, <dan.j.williams@intel.com>,
	<ashish.kalra@amd.com>, <gshan@redhat.com>, <jgowans@amazon.com>,
	<pankaj.gupta@amd.com>, <papaluri@amd.com>, <yuzhao@google.com>,
	<suzuki.poulose@arm.com>, <quic_eberman@quicinc.com>,
	<linux-bcachefs@vger.kernel.org>, <linux-btrfs@vger.kernel.org>,
	<linux-erofs@lists.ozlabs.org>, <linux-f2fs-devel@lists.sourceforge.net>,
	<linux-fsdevel@vger.kernel.org>, <linux-mm@kvack.org>,
	<linux-kernel@vger.kernel.org>, <linux-security-module@vger.kernel.org>,
	<kvm@vger.kernel.org>, <linux-kselftest@vger.kernel.org>,
	<linux-coco@lists.linux.dev>
Subject: [PATCH kvm-next V11 2/7] mm/filemap: Extend __filemap_get_folio() to support NUMA memory policies
Date: Wed, 27 Aug 2025 17:52:44 +0000
Message-ID: <20250827175247.83322-5-shivankg@amd.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250827175247.83322-2-shivankg@amd.com>
References: <20250827175247.83322-2-shivankg@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PEPF000023D0:EE_|LV8PR12MB9263:EE_
X-MS-Office365-Filtering-Correlation-Id: d6c32d32-2307-4fac-2572-08dde59301b3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|82310400026|36860700013|376014|7416014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?gQtJ/yopJavsi95vnNsK9bwZFc0cgz1KmStctnU4s5B4wSiOvBfGyYGuU8Nz?=
 =?us-ascii?Q?wIsStnZgww4/QHnjNeV6T1+mWHppp21eZsCxaIIeDjQGtGMoCbuFzU+1cUVu?=
 =?us-ascii?Q?thxcurQsojNYnbWMqbvuP0Fix/9vQNtwC8UuCqOonR5alb9KrHz3dObVsqU3?=
 =?us-ascii?Q?eEwDX0VoYPhO6/tpq+R+mVs130C8gRCgrYNvGWNEaJO5y1d39ue0Qd+S1mls?=
 =?us-ascii?Q?Es0eUUihe4JqJaKWvsDyPYMWblvJk5EFePqzppdT7b5lBXDtOXDZagt/yRIG?=
 =?us-ascii?Q?GNIXJNB2NdwVEN90zIVwNHUe9IOeV0LXwfIjwv+Pok0Kq/bsE5AIkSwv0VbL?=
 =?us-ascii?Q?+L1MVx1rjhEvKOjpEiLtcVVMnDK6BJ0/wDny+zATsa0ZeRAGET5yQP8dlslq?=
 =?us-ascii?Q?GRLtUBbttvibenqKUiAciHtGfx7JnTlA/FWrfrMPhgK1kG59vIMON9k7mHLn?=
 =?us-ascii?Q?xQonvr20ZGY6xE/OEcMIBZQUzqimry0ZJnjGj+wqCRsyojZij2lHd2I1tTiD?=
 =?us-ascii?Q?AvhP4kAjOkuTC87wshuAFI+eBNwurNBvRD5F1P1N0F/4pokkmEewnp+flt2I?=
 =?us-ascii?Q?26DTg4Fqj7vB5Xw6ttn2YR/vlk25j0l8BoXxX539/UTtyRADRlMGbnCyBA5K?=
 =?us-ascii?Q?9+fF75RgITRpoSyLYzelVeo5chM20z2hSEo2CtBOowXRbhe7DVGx2jm2fYfU?=
 =?us-ascii?Q?HagwCes7br2TBI8kNQotN1Cu7zKaGCdfx0xIfqtvKYQd1WB88dHZnkbT1i6h?=
 =?us-ascii?Q?BFxzEn22S+gb7niOITOUWIXnktx2j8ACWYKBjg1ItRTJ/CchHjJ/6eS6z50D?=
 =?us-ascii?Q?p/tQC/bYJLEySKo5c/gFk0km10NUK6eWBf/uWrKAK32nla6stVvLAO1cFJsQ?=
 =?us-ascii?Q?571FSPrUH1wPEImn1XktfFh+D3ahG59HGiTjcKUIKS/XDRiFLW7gU3wG4hLZ?=
 =?us-ascii?Q?sWcSff2CZufTDL4W9vnue2+t22b2S+Fj3lBo6LMG8j7AAZhA/YrGspZbe5lo?=
 =?us-ascii?Q?g+5vJ0njm1oZN3uLmCKX8ZJPYssA+0ocdfhjdJiUIpWLpwFysDLIfBEX6tsC?=
 =?us-ascii?Q?3wOZaL2hTh8+7kadqGCui7b6an8JbaIDJ3zBwvEiGHjZO5TEi34J/+TmeJg9?=
 =?us-ascii?Q?Ndc75kXV3i6EeOF3abH7/ydw8eYCV00YvFcJC/Q9komqhUkShVfQxTwdbNcm?=
 =?us-ascii?Q?MWx3GhguR4oWPcOqolZmGeKhUh+7J2zzURpB2k4GO45QB1SoEl3glZNov4gV?=
 =?us-ascii?Q?QE2UlyOvfheV9H2NKWeTgi/V3lt44eI/Gg1Q+xzdRtJXnunh4J9W7f0uNXvq?=
 =?us-ascii?Q?9JS6NdYZfcg/OW32iXMFMZJve0XlgFSHQ1SLoSamzhi7DGDcM8bWb924KlhU?=
 =?us-ascii?Q?IK2TTqP/H/RgR0xWlfXITvhcgK5MTjcYARfforl3GwEHB1qiarPvWb4+k6YE?=
 =?us-ascii?Q?ECV0/Rer7HJS7/3PydTsJ93qqxJ+w5b3vMjF6XXVDqNuIAgcHsbmQnE7E+eG?=
 =?us-ascii?Q?xmehQTDNPD5SmBsksrhAmXfhppV/HekagabT?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(82310400026)(36860700013)(376014)(7416014)(7053199007);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Aug 2025 17:56:10.6595
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d6c32d32-2307-4fac-2572-08dde59301b3
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF000023D0.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV8PR12MB9263
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: A4AB74000E
X-Stat-Signature: 56yzswhkzpp73brn3tekdhz19xtbs33t
X-Rspam-User: 
X-HE-Tag: 1756317378-528316
X-HE-Meta: U2FsdGVkX19oWBCGXfTZIMzZ0iSO4ipIMktN0bHSMIOANqggXEz2izGGHe4Ayhg20PfKFvnquZgM0KcFPEnN7wmMogs4TuW0Kf9w9G9odtTjqho72tD+2W2XyQizcL7TFy3naH/knbu9PjxXBass9DtzmbLFP6llUvnExgORPCyzucOjIC/lpbj2ba6doY/ZXURYtfDfQqKmPPvU6AytwJaaCgSFTgMie1+9Y+PApSvna4yccwdZAOEV9tC0q0cTCyDKDe8gvFNkAufYmTe6P3kofdK1BREmDXE8GfsTthjCw5jPlLwC5yA3E1BS8JT6sHrXL9M7Hs4oDPI6g1T4ZlG47iWL5iTNuhzXj5MSWKxDRe7AfKgqL2L9gUqYxqcSv1pLyx/0yCISxZf3If8Ttp2+KsA6GaHM9XbLVQBQM2WsIC9IK/VJK98TldqfyudxqFtedF2PGFBM9Zvmg/eLiHxeM/IYqpf2q3hKriBm1xL9DnR/yCVdzQkFjx9/dCIheq63yPITIJnRRhQOuQmWmblbNwL0tDv/AIosO0iajaJ7aLyiEVZocv7Oo9YIp/0ZTLEy09yL/wUKhlNHuMXE7L0Qz2ieSOO9JpTWkbsWx1lB8WP54WghYfEGqBbB600FMIYuSHxf/y81RH7lELLPfboPRxwunOGUVzDcpIJF2T0ZS3k4phgyA3HlWS92BGdcn+4f8DBf3gK1GuaDDjOJWmZWJzJHZHT3DR5UdZkvswLjV1A1O4fGLZIJcUKk0z7gsEiZo5R49KFuFgyc80MoAoQux5JGdoYaVbvPI7b1GzG84mNMm8foiYu4TSJSkykGtoFQLjctbSOIB7ff8hwYksSWf9Wpsl1zAnbl4GS6rQOgRXfayuL+2TNwKo6Lsd5xosdmFpn5AD+otzxcTZQtj+6NR+o7qfPtSNYZCf83BpFrSE0x4UPcFp+GQCEoMykAVqVdRC5vTbZf7Hvt4hf
 fuEfCq6Y
 K/ZcdYFDR1B2DzwzxK9FEoVQAMAAPcihNAH47WNiuWtU99txBm3RstH2ncUc8hi1EZYf5XHj1ygrp5Npf8SILmcxQcZryfXxeKgQBTri4PXrnDMA8NzR00gJvyZXYwIDfMMnTtKHtTi4eWVdq71VFkEJF2ysv4yWJaRs5/p+UjpPG56rIm7KHzVHEOhZzfz5DABzW5no1gtVaLDFxCqKhlJ6PTho9RVVh8BrwCfU4XjGt6wrxFYzksL8vn670F+ouvw9zaBItDGNfeSOTlzmT+WFQDwZAqn2EmX3JBJ7LplrjzSgK1WLeMlU3xoy8SlIbBvXOdWm9w8jetMaumURl7rEaCa1YNVvC1AYZuPIjF+Jf2jZO0eoNrYudHTeVHwYHu7ceDU1V+IvHcl39H6j3FiVzoydUcOgpq8nIDf+vSLT3n78q2oKdKIjtQ/HIaNHzeOm7PXCqQKLJEWrkOyNah4rysZPjO6lL6wDku/Goa8qTF64ONP3OewfEnS2s6qT0SFH8nCvM2BrU4p8SksCbk4IV2e9ASxzxJPidzwnuMDPUIzcGAcNV86BCoEqFKAO1/s9qp++hOq6bVZ67t7cUehRXHAx+bqpFBCKLitOfgTjxDrYJjyRLUuCcXvgWQfHRi84xwDmFHGdwoM9hnDVxm2tfTWHF9r7o2iA2iEBV73S7qlJA+66SfoZINcEyiAcjlE6d2BzSiLfqgabqjQ/ZIK42a+8We+kCzpzlJJENjnB8+q1DbvAWLatJ219rLiX562Mc5WMBlxyrSGFioZlal07G0zMwnpwEJXp84KZKdHbZZtg=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Matthew Wilcox (Oracle)" <willy@infradead.org>

Extend __filemap_get_folio() to support NUMA memory policies by
renaming the implementation to __filemap_get_folio_mpol() and adding
a mempolicy parameter. The original function becomes a static inline
wrapper that passes NULL for the mempolicy.

This infrastructure will enable future support for NUMA-aware page cache
allocations in guest_memfd memory backend KVM guests.

Reviewed-by: Pankaj Gupta <pankaj.gupta@amd.com>
Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Shivank Garg <shivankg@amd.com>
---
 include/linux/pagemap.h | 10 ++++++++--
 mm/filemap.c            | 11 ++++++-----
 2 files changed, 14 insertions(+), 7 deletions(-)

diff --git a/include/linux/pagemap.h b/include/linux/pagemap.h
index ce617a35dc35..94d65ced0a1d 100644
--- a/include/linux/pagemap.h
+++ b/include/linux/pagemap.h
@@ -747,11 +747,17 @@ static inline fgf_t fgf_set_order(size_t size)
 }
 
 void *filemap_get_entry(struct address_space *mapping, pgoff_t index);
-struct folio *__filemap_get_folio(struct address_space *mapping, pgoff_t index,
-		fgf_t fgp_flags, gfp_t gfp);
+struct folio *__filemap_get_folio_mpol(struct address_space *mapping,
+		pgoff_t index, fgf_t fgf_flags, gfp_t gfp, struct mempolicy *policy);
 struct page *pagecache_get_page(struct address_space *mapping, pgoff_t index,
 		fgf_t fgp_flags, gfp_t gfp);
 
+static inline struct folio *__filemap_get_folio(struct address_space *mapping,
+		pgoff_t index, fgf_t fgf_flags, gfp_t gfp)
+{
+	return __filemap_get_folio_mpol(mapping, index, fgf_flags, gfp, NULL);
+}
+
 /**
  * write_begin_get_folio - Get folio for write_begin with flags.
  * @iocb: The kiocb passed from write_begin (may be NULL).
diff --git a/mm/filemap.c b/mm/filemap.c
index 495f7f5c3d2e..03f223be575c 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -1897,11 +1897,12 @@ void *filemap_get_entry(struct address_space *mapping, pgoff_t index)
 }
 
 /**
- * __filemap_get_folio - Find and get a reference to a folio.
+ * __filemap_get_folio_mpol - Find and get a reference to a folio.
  * @mapping: The address_space to search.
  * @index: The page index.
  * @fgp_flags: %FGP flags modify how the folio is returned.
  * @gfp: Memory allocation flags to use if %FGP_CREAT is specified.
+ * @policy: NUMA memory allocation policy to follow.
  *
  * Looks up the page cache entry at @mapping & @index.
  *
@@ -1912,8 +1913,8 @@ void *filemap_get_entry(struct address_space *mapping, pgoff_t index)
  *
  * Return: The found folio or an ERR_PTR() otherwise.
  */
-struct folio *__filemap_get_folio(struct address_space *mapping, pgoff_t index,
-		fgf_t fgp_flags, gfp_t gfp)
+struct folio *__filemap_get_folio_mpol(struct address_space *mapping,
+		pgoff_t index, fgf_t fgp_flags, gfp_t gfp, struct mempolicy *policy)
 {
 	struct folio *folio;
 
@@ -1983,7 +1984,7 @@ struct folio *__filemap_get_folio(struct address_space *mapping, pgoff_t index,
 			err = -ENOMEM;
 			if (order > min_order)
 				alloc_gfp |= __GFP_NORETRY | __GFP_NOWARN;
-			folio = filemap_alloc_folio(alloc_gfp, order, NULL);
+			folio = filemap_alloc_folio(alloc_gfp, order, policy);
 			if (!folio)
 				continue;
 
@@ -2030,7 +2031,7 @@ struct folio *__filemap_get_folio(struct address_space *mapping, pgoff_t index,
 		folio_clear_dropbehind(folio);
 	return folio;
 }
-EXPORT_SYMBOL(__filemap_get_folio);
+EXPORT_SYMBOL(__filemap_get_folio_mpol);
 
 static inline struct folio *find_get_entry(struct xa_state *xas, pgoff_t max,
 		xa_mark_t mark)
-- 
2.43.0


