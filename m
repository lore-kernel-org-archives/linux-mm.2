Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B65B6C54F4C
	for <linux-mm@archiver.kernel.org>; Tue, 28 Jul 2026 05:45:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 917286B009F; Tue, 28 Jul 2026 01:45:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8C7F96B00A1; Tue, 28 Jul 2026 01:45:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 768A86B00A2; Tue, 28 Jul 2026 01:45:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 302266B009F
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 01:45:40 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 8CECA802CB
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 05:45:39 +0000 (UTC)
X-FDA: 85037098398.25.21DFAC6
Received: from BN8PR05CU002.outbound.protection.outlook.com (mail-eastus2azon11011014.outbound.protection.outlook.com [52.101.57.14])
	by imf07.hostedemail.com (Postfix) with ESMTP id 7ACD440003
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 05:45:36 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=0NgYTjus;
	spf=pass (imf07.hostedemail.com: domain of bharata@amd.com designates 52.101.57.14 as permitted sender) smtp.mailfrom=bharata@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785217536;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Yv1klQ+3wlkrorARWsJCxdhCgcws73DnFIzvRv+M71o=;
	b=ZXaMqtvWkjtRW0bwS5ZwQT0DZmejsKJRqGiObt7ZzzfpnvkDmAhJZhoNCjZwFEpddCxLUK
	P5SLvd+Wx3aNvQVI1Ef89FhByKkdYMu3aR8CjM2Bcsmvh8vcMIe43bBswwPX+z1nrJPZyZ
	fJoZM6LvW3qd+puJB0U+ce11RfEyHM4=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1785217536;
	b=SCCFTdMNfXOvpYLV7lBYV5SvJ+myAxIvyu2K83oT3Qa2sc7yo5pdP76Q/wenIP2Gt+Hhe1
	ydyH/pf50k5C7xVe08bRwRwUgAZ7CTYqL8K3k+/uIh4G2j3pbofHjdpfk0gaaT1p+zmQfL
	oqFRjh3ueAAAPuGoOZhqYTdeIgwEEsU=
ARC-Authentication-Results: i=2;
	imf07.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=0NgYTjus;
	spf=pass (imf07.hostedemail.com: domain of bharata@amd.com designates 52.101.57.14 as permitted sender) smtp.mailfrom=bharata@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=xGs/WHFnbZK5CgwnseZtv6dJwhwCs4Y0nckud9D0lYp5Qw37HH4JOTorywqSb/M4DJUIWqzwgOfQOReZs1of0Pgk9DtzFS4Ee9/8eu+f/As+mIrLs8J9a4bmqR/c8DeddqR6Rtfoq4t23Yy1P6qXPHn3m/rkmmNc4BL6s/tMX7i6PnPlWqNPEbl8foWgOB3MPrzjbmc+lkNW4PjLUvrtWhn/fiesEhzBdEriHn+nhjgJbOPpWpUxL1damisFE+1s+XPGtbgCEwvnW509yQAcmrUjBdHacuj+qKBhr6CFI5bKsojyHEKY6FVlux7ujwIsNlgb7+Aou5daa4dbhgFy5w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Yv1klQ+3wlkrorARWsJCxdhCgcws73DnFIzvRv+M71o=;
 b=FRCTi0CVTlPZPxv9325BU9edZ00P+ZjcMNlHHmRd3Zy4JEtOfJ+iB5Gaj2knYVC794kBIK5xvFTsLufJUe2f+4jOZx+gwDqGmwTz8mtSBAEJXnxppqDP28hhF0Bo5zyv14v3a5brXpGsUxgZKaUg8bL4ELn7CP9fECUEMTXytKoHykidAtuMp+FMbU9Ep6cBME3YAjD8b/eXO7KX2hPKKuTRPTzuN6h9Tm1iXerRdc+pUhhBh5TmJflv2BJgEbhSrGF4J2wOWsEGqWyfuy7V+AsKeFyeLJMZX8D7QIxE1yNSKCDT75IKzmN88RE9IjAp9sP5SJ5nlqTBqMlR1IrKIw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Yv1klQ+3wlkrorARWsJCxdhCgcws73DnFIzvRv+M71o=;
 b=0NgYTjus4SR2IC+haiVXscoNTW4Tta1+DFWoxY6wsQf2e9BIca0cCLDA8lxznmw65RA9JaOJKnwPVkSAMCumcIQ1Q0691GWvGtgmWLUn+FOAIQ/+FfNkG0J5Vq4Mi06yT4mshLZ46XHRXKb1dizBPjrJ5HAbjVbTDYZgcAlTevI=
Received: from MW4PR04CA0378.namprd04.prod.outlook.com (2603:10b6:303:81::23)
 by SN7PR12MB6863.namprd12.prod.outlook.com (2603:10b6:806:264::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.245.13; Tue, 28 Jul
 2026 05:45:27 +0000
Received: from MWH0EPF000C6192.namprd02.prod.outlook.com
 (2603:10b6:303:81:cafe::a7) by MW4PR04CA0378.outlook.office365.com
 (2603:10b6:303:81::23) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.245.13 via Frontend Transport; Tue,
 28 Jul 2026 05:45:26 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 MWH0EPF000C6192.mail.protection.outlook.com (10.167.249.102) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.270.5 via Frontend Transport; Tue, 28 Jul 2026 05:45:26 +0000
Received: from BLR-L-BHARARAO.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.41; Tue, 28 Jul
 2026 00:45:18 -0500
From: Bharata B Rao <bharata@amd.com>
To: <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>
CC: <Jonathan.Cameron@huawei.com>, <dave.hansen@intel.com>,
	<gourry@gourry.net>, <mgorman@techsingularity.net>, <mingo@redhat.com>,
	<peterz@infradead.org>, <raghavendra.kt@amd.com>, <riel@surriel.com>,
	<rientjes@google.com>, <sj@kernel.org>, <weixugc@google.com>,
	<willy@infradead.org>, <ying.huang@linux.alibaba.com>, <ziy@nvidia.com>,
	<dave@stgolabs.net>, <nifan.cxl@gmail.com>, <xuezhengchu@huawei.com>,
	<yiannis@zptcorp.com>, <akpm@linux-foundation.org>, <david@kernel.org>,
	<byungchul@sk.com>, <kinseyho@google.com>, <joshua.hahnjy@gmail.com>,
	<yuanchu@google.com>, <balbirs@nvidia.com>, <alok.rathore@samsung.com>,
	<shivankg@amd.com>, <donettom@linux.ibm.com>, Bharata B Rao <bharata@amd.com>
Subject: [PATCH v8 7/8] x86/mm/ibs: In-kernel driver for AMD IBS Memory Profiler
Date: Tue, 28 Jul 2026 11:13:55 +0530
Message-ID: <20260728054356.291998-8-bharata@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260728054356.291998-1-bharata@amd.com>
References: <20260728054356.291998-1-bharata@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: satlexmb07.amd.com (10.181.42.216) To satlexmb07.amd.com
 (10.181.42.216)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWH0EPF000C6192:EE_|SN7PR12MB6863:EE_
X-MS-Office365-Filtering-Correlation-Id: 461dc1e8-d282-4a59-c0d6-08deec6b6cee
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|23010399003|1800799024|376014|36860700016|82310400026|18002099003|56012099006|10067099003|11063799006|22082099003|3023799007;
X-Microsoft-Antispam-Message-Info:
	Q1wsR6dhqxoxIj8XCK6Afj/2LCw4jv0m4wXoEmsl9Qh0BIyvdX+BZZh7W+HUwEGqVGE6IxVJOrHqF1vN7stWWZDiOKIlwpSKi4E8Ugvl/VcQnuraOEQ/2eaxT4zYEJZTQ9eez/81Wfui1e/EY6Dd/lf2O4heXfxN54iZEzLBZ4xnMlb7OQXt4AnbCL9gaZzfFNe+ElAKnEyJVWoo//uVyc3G6jEBxZBdfo+pMjInM7PjJsuBkZJN9cV47YHUmIgozyNKZs61UNFlemCi4XspoGdZc+ujeVOT6tkuPk5Iw7ADTEq8SB/OY2M1B35a2Ssn32Rvb119JjkEqLaNcTNabAiDaG7xRloOgZvKcONOB4UeQ10InOznWl+pjnPdmpRTpS4UjQDbYKkohc9vxd/zP2AmGVQ36iYjstSfaf4Rahnq/GU7vlsBW+Hy3HUlryAZzjNYAcEDagVhkwT+5/FDE3x84Q6awVBPcc2Mltxczw01mRcV7t9t5oPigTgOW/SLQAOzruYKKS2ATKKTdxtxRT4JMqW+WSCdZX/WVyCougTbHCfoNMcZx/gkJ1mRUlNetyLg9WNxEJWJmj6n3SVqg9ZFOCjYOv8KsRxVeadpzFAHw9/hR5DtRLHhTkuI9YSjhrI1CmkG1zbaUu59NhSLj2OSFgGnM3psBWfj83rk6SZHd1CzbUqSCZyjxGADCKeA5FIzWM+MMQpubjcSdxqOuQ==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(7416014)(23010399003)(1800799024)(376014)(36860700016)(82310400026)(18002099003)(56012099006)(10067099003)(11063799006)(22082099003)(3023799007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	7bCb47C0jr6lbXWrw9M/azlFL+ZSzoMoKa5xtHnmKcxjBX1XMzxhXTZ3GxPjsUq6CLxrHvAz9epJ0Q1T6lncRbtubByTALmuHy2HdbFxqRU3ZBAlVl88BOf3vQrK3HDVnYMegAiH7OAE61jacJ533cqXlULmOPH8lNRwEZXojw/Fc2Rbdu9wXNziI9hESMYLAMq/Mlw4jNPMKz8S/SBlCijdAstteYbi9ep35eGQbwVOOXCUXs+9AXn+Wf3rk7hzKB+Cc3A4msFpF0Of80j5h8XGCh4YunOR7Y5FLtVz4zzWx230sUZxA7ddX5GjOtTr2cI3yT0op6kybQsl9lDEsQ38Ck/mgx6WRqNQ9/be2cUFwV0KekYzXc3glXASlKD9rHfsecWKKIo6RTJzE7f0r+iwMbxNdYqxmzjmnxFYZLkFYuvb/zei76AQK12vJoVa
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jul 2026 05:45:26.5635
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 461dc1e8-d282-4a59-c0d6-08deec6b6cee
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MWH0EPF000C6192.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB6863
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 7ACD440003
X-Stat-Signature: i6d5mzpfwrq7xtwge61ujhxnbuz7rfa7
X-Rspam-User: 
X-HE-Tag: 1785217536-293832
X-HE-Meta: U2FsdGVkX1/WBc/FsfQkjMHNJlh6tzTh1Ad8mcsvPaDwAPh88Yqb/KW3GFgDk5WbpWgsCAXHnPxbxr/3ek6r1ydfPiatHvvDoLLY4MOgDnOfgeiu4EPwVp/c7NI1M1pmeZsd2w4/dTpc2aYWLp36yiq8C3ad8qU3AJiIJmSCVsmG+RzdwLZ5al7j3rOIMG1icRORWVNbl2+zNU3/t8emLkvEm9cXzgZUhp2w6DKUBzOMy+mN1g973naeRaGiFQx414+DMn8SspKCA0hQ7pqkcUWlVPYQkg2x4wm13OorRWUFXnrWnVnNGqh7Xr8AnKWNYgnciLNjoP1PseBA6lUZZZI1Dhgc5sP0TVCtUe+HGYd3wJ3y1bS77S3IQrBU641gFoXFkZiOiR4xNpmfetVVNs3W/5zoCXmGLTXsXorbjm51Z97TzvUXWmY4B8fixD80wVo/0hUqFS1q6vB0CnlQRSndjT7dUTzcoQwzm9SQtBMcgaJDzpO3dX04XyOnKplM+RGvYR/VtuX3aZquHW00+LEEsrfkxpEPu4J54kdX3QY4dWxbLZhPI6xcIhfa2z2aNSE6nrPbThrk+wILwvu5ia81gIc86phD2Kxe5EBGY1FwDaB5rbLYsrTDKNISKZdq3xOmVo26UYVM7OWDZ7HKXqcSJGXc/dYIP7KR/4zD8BIYVV7HKy14K5e91ZuNOAkM2DV4DOlS5RO59AfxOPp9t/G+lPsHBqDtRJeLKUBgaydHEAm4HvY5ke+m/zF/awWc04cHFhbhXx4WHglW5Os8dXISGVtyVwdTwIdbq6aiea6XA2svEvYldMSmXfOm2MhGswvo+ZymDHsBpsUqErb9cCeP/rG1cnUBrGbHO4Ja6z7B1sMogbb0zcmo8s+a0bunQjzBT4Q7/X1qg92i3DT6/1Q93UhKaO7HhJuxJm5JbCNN1NPdNqUXTSfuWNxjMtfwQXq4sOohPsLjxCApwgv
 /w05kEX+
 HqXDoykbqhXZxs2LLDJDXjMYnpjsrmUiBd2+Vtvi+TBI3FRdJbsBAUXvFg8UOwzb2XcM/dAsHPIfIDliBBdi5JDy6ubkhGykei1Jyokk/h8nQ38x757dPEAkomB42aGaM5sRExePmS39vL+r2bJ5keFX9qMBAb+S/N+OGmmsXBNbIOlXcUN6/cMwbP3AIf7hqJFeqVWsr9F+iY04HtsJbjIyX6ATPQTPyVgikjiWO1gDZrivZRPbpwnG3Q6ugt7FrH5Uyiif6r4GMmiSkq57zIKbuvYwGdzpiYFl+zIyytHkbrktirioRBDBEYe5N3zSCXUxu1pGek8QtjKYaQ+tTXyN/mpxMyxJUWrvFh5juPwkpsfIwzE4Pj4Mi0EUwWWUto681ZKXLeTu4l6HLYDhW5FUQlHHBpZV+k8gf2nDjMIhWFtYfUHauehSqF0+1AnH64mGc5bb/ccHGTf10ImoT3v71bbzRAuwvEGzKsuZUiIie/Mj0vFX1dIOhva4f7xvHLKxh2gkzBISXaNSBbvhcXQ8TpQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Use IBS (Instruction Based Sampling) Memory Profiler feature
present in AMD Zen6 processors for memory access tracking. The
access information obtained from IBS Memory Profiler is fed to
pghot sub-system for further action using
pghot_record_access(PGHOT_HWHINTS, ...) API.

IBS Memory Profiler as page hotness source is enabled by the
new config option HWMEM_PROFILER and is also gated by the
existing pghot_src_hwhints static key set via sysctl tunable
vm.pghot_enabled_sources.

New system vector 0xea is used for memprofiler interrupt.

This adds the driver infrastructure (interrupt setup, per-CPU
ring, workqueue, cpuhp state, pghot call site etc) but the
profiler isn't armed yet and that is done in the next commit.

More details about IBS Memory Profiler can be obtained from
the AMD document titled "AMD64 Zen6 Instruction Based Sampling (IBS)
Extensions and Features".

Signed-off-by: Bharata B Rao <bharata@amd.com>
---
 Documentation/admin-guide/mm/pghot.rst |  44 ++-
 arch/x86/Kconfig                       |  16 ++
 arch/x86/entry/entry_fred.c            |   1 +
 arch/x86/include/asm/hardirq.h         |   3 +
 arch/x86/include/asm/ibs-caps.h        |   8 +
 arch/x86/include/asm/ibs-mprof.h       |  47 ++++
 arch/x86/include/asm/idtentry.h        |   6 +
 arch/x86/include/asm/irq_vectors.h     |   4 +-
 arch/x86/include/asm/msr-index.h       |   8 +
 arch/x86/kernel/idt.c                  |   3 +
 arch/x86/kernel/irq.c                  |   3 +
 arch/x86/mm/Makefile                   |   1 +
 arch/x86/mm/ibs-mprof.c                | 363 +++++++++++++++++++++++++
 include/linux/cpuhotplug.h             |   1 +
 include/linux/vm_event_item.h          |   7 +
 mm/Kconfig                             |   9 +
 mm/vmstat.c                            |   7 +
 17 files changed, 529 insertions(+), 2 deletions(-)
 create mode 100644 arch/x86/include/asm/ibs-mprof.h
 create mode 100644 arch/x86/mm/ibs-mprof.c

diff --git a/Documentation/admin-guide/mm/pghot.rst b/Documentation/admin-guide/mm/pghot.rst
index accf78d95d02..b802b80e5c24 100644
--- a/Documentation/admin-guide/mm/pghot.rst
+++ b/Documentation/admin-guide/mm/pghot.rst
@@ -87,7 +87,7 @@ Path: /proc/vmstat
 
 2. **pghot_recorded_hintfaults**
    - Number of recorded accesses reported by NUMA Balancing based
-     hotness source.
+     hint faults source.
 
 3. **pghot_recorded_hwhints**
    - Number of recorded accesses reported by hwhints source.
@@ -108,3 +108,45 @@ to promote hot pages. It can be disabled at runtime by clearing that bit:
 
 # echo 0x0 > /proc/sys/vm/pghot_enabled_sources
 
+Hardware Hints Source
+=====================
+pghot can consume memory access samples reported by hardware profilers.
+This "hardware hints" (hwhints) source feeds hardware-observed accesses
+into pghot for hot page detection and promotion.
+
+Generic in-kernel support for such profilers is controlled by the
+HWMEM_PROFILER config option. It is not enabled directly by the user;
+an in-kernel driver that forwards hardware-observed accesses to pghot
+selects it.
+
+The AMD IBS Memory Profiler (config AMD_IBS_MEMPROF, available on Zen6
+and later AMD CPUs) is one such driver. It uses the AMD Instruction
+Based Sampling (IBS) Memory Profiler facility to sample user memory
+accesses and record them with pghot.
+
+This source can be activated at runtime through the hardware
+hints bit (0x2) of **pghot_enabled_sources**.
+
+# echo 0x2 > /proc/sys/vm/pghot_enabled_sources
+
+HWHINTS Vmstat Counters
+=======================
+Following vmstat counters provide some stats about hardware hints source.
+
+Path: /proc/vmstat
+
+1. **hwhint_total_events**
+   - Number of total hwhint events recorded by hwhints source.
+
+2. **hwhint_useful_events**
+   - Number of actionable events from hwhints source.
+
+3. **hwhint_dropped_events**
+   - Number of events that were dropped due to buffer overrun.
+
+4. **hwhint_dram_accesses**
+   - Number of DRAM accesses reported by hwhints source.
+
+5. **hwhint_extmem_accesses**
+   - Number of external memory (like CXL) accesses reported by hwhints source.
+
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index bdad90f210e4..c6c5ed83506a 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -1501,6 +1501,22 @@ config AMD_MEM_ENCRYPT
 	  This requires an AMD processor that supports Secure Memory
 	  Encryption (SME).
 
+config AMD_IBS_MEMPROF
+	bool "AMD IBS Memory Profiler"
+	depends on X86_64 && CPU_SUP_AMD
+	depends on PGHOT
+	select HWMEM_PROFILER
+	help
+	  Use the AMD Instruction Based Sampling (IBS) Memory Profiler
+	  facility (present on Zen6 and later AMD CPUs) to feed
+	  hardware-observed memory accesses into the pghot subsystem
+	  for hot-page detection and promotion.
+
+	  When disabled, no IBS Memory Profiler MSRs are programmed and
+	  the corresponding interrupt handler is not installed.
+
+	  If unsure, say N.
+
 # Common NUMA Features
 config NUMA
 	bool "NUMA Memory Allocation and Scheduler Support"
diff --git a/arch/x86/entry/entry_fred.c b/arch/x86/entry/entry_fred.c
index fb3594ddf731..f52099e3fa85 100644
--- a/arch/x86/entry/entry_fred.c
+++ b/arch/x86/entry/entry_fred.c
@@ -120,6 +120,7 @@ static idtentry_t sysvec_table[NR_SYSTEM_VECTORS] __ro_after_init = {
 	SYSVEC(POSTED_INTR_NESTED_VECTOR,	kvm_posted_intr_nested_ipi),
 
 	SYSVEC(POSTED_MSI_NOTIFICATION_VECTOR,	posted_msi_notification),
+	SYSVEC(IBS_MEMPROF_VECTOR,		ibs_memprof),
 };
 
 static bool fred_setup_done __initdata;
diff --git a/arch/x86/include/asm/hardirq.h b/arch/x86/include/asm/hardirq.h
index dea60d66d976..2da4930ea399 100644
--- a/arch/x86/include/asm/hardirq.h
+++ b/arch/x86/include/asm/hardirq.h
@@ -49,6 +49,9 @@ enum irq_stat_counts {
 #endif
 #ifdef CONFIG_X86_POSTED_MSI
 	IRQ_COUNT_POSTED_MSI_NOTIFICATION,
+#endif
+#ifdef CONFIG_AMD_IBS_MEMPROF
+	IRQ_COUNT_IBS_MEMPROF,
 #endif
 	IRQ_COUNT_PIC_APIC_ERROR,
 #ifdef CONFIG_X86_IO_APIC
diff --git a/arch/x86/include/asm/ibs-caps.h b/arch/x86/include/asm/ibs-caps.h
index ddf6c512c8f9..1f6c4058a0e3 100644
--- a/arch/x86/include/asm/ibs-caps.h
+++ b/arch/x86/include/asm/ibs-caps.h
@@ -29,6 +29,7 @@
 #define IBS_CAPS_FETCHLAT		(1U<<14)
 #define IBS_CAPS_BIT63_FILTER		(1U<<15)
 #define IBS_CAPS_STRMST_RMTSOCKET	(1U<<16)
+#define IBS_CAPS_MEM_PROFILER		(1U<<18)
 #define IBS_CAPS_OPDTLBPGSIZE		(1U<<19)
 
 #define IBS_CAPS_DEFAULT		(IBS_CAPS_AVAIL		\
@@ -42,6 +43,13 @@
 #define IBSCTL_LVT_OFFSET_VALID		(1ULL<<8)
 #define IBSCTL_LVT_OFFSET_MASK		0x0F
 
+/*
+ * IBS Memprofiler setup
+ */
+#define IBSCTL_MPROF_LVT_OFFSET_VALID	(1ULL << 24)
+#define IBSCTL_MPROF_LVT_OFFSET_SHIFT	16
+#define IBSCTL_MPROF_LVT_OFFSET_MASK	(0xFULL << IBSCTL_MPROF_LVT_OFFSET_SHIFT)
+
 /* IBS fetch bits/masks */
 #define IBS_FETCH_L3MISSONLY		      (1ULL << 59)
 #define IBS_FETCH_RAND_EN		      (1ULL << 57)
diff --git a/arch/x86/include/asm/ibs-mprof.h b/arch/x86/include/asm/ibs-mprof.h
new file mode 100644
index 000000000000..3de1880c4126
--- /dev/null
+++ b/arch/x86/include/asm/ibs-mprof.h
@@ -0,0 +1,47 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _ASM_X86_IBS_MPROF_H
+#define _ASM_X86_IBS_MPROF_H
+
+/*
+ * All bits are documented here for clarity even if the current
+ * driver doesn't use all of them.
+ */
+
+/* MSR_AMD64_IBS_MPROF_DATA2 bits */
+#define IBS_MPROF_DATA2_DATASRC_MASK		0x7
+#define IBS_MPROF_DATA2_DATASRC_MASK_HIGH	0xC0
+#define IBS_MPROF_DATA2_DATASRC_MASK_HIGH_SHIFT	0x3
+#define IBS_MPROF_DATA2_DATASRC_LCL_CCX		0x1
+#define IBS_MPROF_DATA2_DATASRC_PEER_CCX_NEAR	0x2
+#define IBS_MPROF_DATA2_DATASRC_DRAM		0x3
+#define IBS_MPROF_DATA2_DATASRC_CCX_FAR		0x5
+#define IBS_MPROF_DATA2_DATASRC_DRAM_FAR	0x7
+#define IBS_MPROF_DATA2_DATASRC_EXT_MEM		0x8
+#define IBS_MPROF_DATA2_RMT_NODE		BIT_ULL(4)
+#define IBS_MPROF_DATA2_RMT_SOCKET		BIT_ULL(9)
+
+/* MSR_AMD64_IBS_MPROF_DATA3 bits */
+#define IBS_MPROF_DATA3_LDOP		BIT_ULL(0)
+#define IBS_MPROF_DATA3_STOP		BIT_ULL(1)
+#define IBS_MPROF_DATA3_DCMISS		BIT_ULL(7)
+#define IBS_MPROF_DATA3_LADDR_VALID	BIT_ULL(17)
+#define IBS_MPROF_DATA3_PADDR_VALID	BIT_ULL(18)
+#define IBS_MPROF_DATA3_L2MISS		BIT_ULL(20)
+#define IBS_MPROF_DATA3_SW_PREFETCH	BIT_ULL(21)
+
+/* MSR_AMD64_IBS_MPROF_CTL bits */
+#define IBS_MPROF_CTL_CNT_CTL		BIT_ULL(19)
+#define IBS_MPROF_CTL_VAL		BIT_ULL(18)
+#define IBS_MPROF_CTL_ENABLE		BIT_ULL(17)
+#define IBS_MPROF_CTL_L3MISSONLY	BIT_ULL(16)
+#define IBS_MPROF_CTL_MAXCNT_MASK	0x0000FFFFULL
+#define IBS_MPROF_CTL_MAXCNT_EXT_MASK	(0x7FULL << 20)	/* separate upper 7 bits */
+
+/* MSR_AMD64_IBS_MPROF_CTL2 bits */
+#define IBS_MPROF_CTL2_DISABLE		BIT_ULL(0)
+#define IBS_MPROF_CTL2_EXCLUDE_USER	BIT_ULL(1)
+#define IBS_MPROF_CTL2_EXCLUDE_KERNEL	BIT_ULL(2)
+
+#define IBS_MPROF_SAMPLE_PERIOD	10000
+
+#endif /* _ASM_X86_IBS_MPROF_H */
diff --git a/arch/x86/include/asm/idtentry.h b/arch/x86/include/asm/idtentry.h
index 20f548702404..4c82e5c6d759 100644
--- a/arch/x86/include/asm/idtentry.h
+++ b/arch/x86/include/asm/idtentry.h
@@ -735,6 +735,12 @@ DECLARE_IDTENTRY_SYSVEC(POSTED_MSI_NOTIFICATION_VECTOR,	sysvec_posted_msi_notifi
 # define fred_sysvec_posted_msi_notification		NULL
 # endif
 
+# ifdef CONFIG_AMD_IBS_MEMPROF
+DECLARE_IDTENTRY_SYSVEC(IBS_MEMPROF_VECTOR,		sysvec_ibs_memprof);
+#else
+# define fred_sysvec_ibs_memprof			NULL
+#endif
+
 #if IS_ENABLED(CONFIG_HYPERV)
 DECLARE_IDTENTRY_SYSVEC(HYPERVISOR_CALLBACK_VECTOR,	sysvec_hyperv_callback);
 DECLARE_IDTENTRY_SYSVEC(HYPERV_REENLIGHTENMENT_VECTOR,	sysvec_hyperv_reenlightenment);
diff --git a/arch/x86/include/asm/irq_vectors.h b/arch/x86/include/asm/irq_vectors.h
index 85253fc8e384..575f880cb147 100644
--- a/arch/x86/include/asm/irq_vectors.h
+++ b/arch/x86/include/asm/irq_vectors.h
@@ -105,10 +105,12 @@
  */
 #define POSTED_MSI_NOTIFICATION_VECTOR	0xeb
 
+#define IBS_MEMPROF_VECTOR		0xea
+
 #define NR_VECTORS			 256
 
 #ifdef CONFIG_X86_LOCAL_APIC
-#define FIRST_SYSTEM_VECTOR		POSTED_MSI_NOTIFICATION_VECTOR
+#define FIRST_SYSTEM_VECTOR		IBS_MEMPROF_VECTOR
 #else
 #define FIRST_SYSTEM_VECTOR		NR_VECTORS
 #endif
diff --git a/arch/x86/include/asm/msr-index.h b/arch/x86/include/asm/msr-index.h
index 18c4be75e927..58d1bd7ebe72 100644
--- a/arch/x86/include/asm/msr-index.h
+++ b/arch/x86/include/asm/msr-index.h
@@ -1317,4 +1317,12 @@
 						* a #GP
 						*/
 
+/* AMD IBS Memory Profiler MSRs */
+#define MSR_AMD64_IBS_MPROF_CTL		0xc0010380
+#define MSR_AMD64_IBS_MPROF_CTL2	0xc0010381
+#define MSR_AMD64_IBS_MPROF_DATA2	0xc0010382
+#define MSR_AMD64_IBS_MPROF_DATA3	0xc0010383
+#define MSR_AMD64_IBS_MPROF_LINADDR	0xc0010384
+#define MSR_AMD64_IBS_MPROF_PHYADDR	0xc0010385
+
 #endif /* _ASM_X86_MSR_INDEX_H */
diff --git a/arch/x86/kernel/idt.c b/arch/x86/kernel/idt.c
index 90a22e24a9eb..50ec5fc82619 100644
--- a/arch/x86/kernel/idt.c
+++ b/arch/x86/kernel/idt.c
@@ -169,6 +169,9 @@ static const __initconst struct idt_data apic_idts[] = {
 # ifdef CONFIG_X86_POSTED_MSI
 	INTG(POSTED_MSI_NOTIFICATION_VECTOR,	asm_sysvec_posted_msi_notification),
 # endif
+#ifdef CONFIG_AMD_IBS_MEMPROF
+	INTG(IBS_MEMPROF_VECTOR,		asm_sysvec_ibs_memprof),
+#endif
 #endif
 };
 
diff --git a/arch/x86/kernel/irq.c b/arch/x86/kernel/irq.c
index 30122f0b3af9..c59a474d9202 100644
--- a/arch/x86/kernel/irq.c
+++ b/arch/x86/kernel/irq.c
@@ -121,6 +121,9 @@ static const struct irq_stat_info irq_stat_info[IRQ_COUNT_MAX] = {
 #endif
 #ifdef CONFIG_X86_POSTED_MSI
 	ISS(POSTED_MSI_NOTIFICATION,	"PMN",	"  Posted MSI notification event\n"),
+#endif
+#ifdef CONFIG_AMD_IBS_MEMPROF
+	ISS(IBS_MEMPROF,		"IMP",	"  IBS Memory Profiler interrupts\n"),
 #endif
 	IDS(PIC_APIC_ERROR,		"ERR",	"  PIC/APIC error interrupts\n"),
 #ifdef CONFIG_X86_IO_APIC
diff --git a/arch/x86/mm/Makefile b/arch/x86/mm/Makefile
index 3a5364853eab..050a7379d9f7 100644
--- a/arch/x86/mm/Makefile
+++ b/arch/x86/mm/Makefile
@@ -59,3 +59,4 @@ obj-$(CONFIG_X86_MEM_ENCRYPT)	+= mem_encrypt.o
 obj-$(CONFIG_AMD_MEM_ENCRYPT)	+= mem_encrypt_amd.o
 
 obj-$(CONFIG_AMD_MEM_ENCRYPT)	+= mem_encrypt_boot.o
+obj-$(CONFIG_AMD_IBS_MEMPROF)	+= ibs-mprof.o
diff --git a/arch/x86/mm/ibs-mprof.c b/arch/x86/mm/ibs-mprof.c
new file mode 100644
index 000000000000..923fb8f99552
--- /dev/null
+++ b/arch/x86/mm/ibs-mprof.c
@@ -0,0 +1,363 @@
+// SPDX-License-Identifier: GPL-2.0
+
+#define pr_fmt(fmt)	"amd_ibs_memprof: " fmt
+
+#include <linux/init.h>
+#include <linux/pghot.h>
+#include <linux/percpu.h>
+#include <linux/workqueue.h>
+#include <linux/mm.h>
+#include <linux/vm_event_item.h>
+#include <linux/vmstat.h>
+#include <linux/cpuhotplug.h>
+
+#include <asm/ibs-mprof.h>
+#include <asm/ibs-caps.h>
+#include <asm/irq_vectors.h>
+#include <asm/idtentry.h>
+#include <asm/apic.h>
+#include <asm/cpuid/api.h>
+
+#define IBS_NR_SAMPLES		150	/* Percpu sample buffer size */
+
+static DEFINE_PER_CPU(bool, mprof_work_pending);
+
+/*
+ * Basic access info captured for each memory access.
+ */
+struct mprof_sample {
+	unsigned long pfn;
+	unsigned long time;	/* jiffies when accessed */
+	int nid;		/* Accessing node ID, if known */
+};
+
+/*
+ * Percpu buffer of access samples. Samples are accumulated here
+ * before pushing them to pghot sub-system for further action.
+ */
+struct mprof_sample_pcpu {
+	struct mprof_sample samples[IBS_NR_SAMPLES];
+	int head, tail;
+};
+
+static struct mprof_sample_pcpu __percpu *mprof_s;
+
+/*
+ * Per-CPU work for pushing the percpu access samples to pghot sub-system.
+ *
+ * @cpu records which CPU's sample ring this work item is responsible for
+ * draining.
+ */
+struct mprof_worker {
+	struct work_struct work;
+	unsigned int cpu;
+};
+static DEFINE_PER_CPU(struct mprof_worker, mprof_work);
+
+/*
+ * Record the IBS-reported access sample in percpu buffer.
+ * Called from IBS interrupt handler.
+ */
+static bool mprof_push_sample(unsigned long pfn, int nid, unsigned long time)
+{
+	struct mprof_sample_pcpu *pcpu = raw_cpu_ptr(mprof_s);
+	int head = READ_ONCE(pcpu->head);
+	int tail = READ_ONCE(pcpu->tail);
+	int next = head + 1;
+
+	if (next >= IBS_NR_SAMPLES)
+		next = 0;
+
+	if (next == tail) {
+		count_vm_event(HWHINT_DROPPED_EVENTS);
+		return false;
+	}
+
+	pcpu->samples[head].pfn = pfn;
+	pcpu->samples[head].time = time;
+	pcpu->samples[head].nid = nid;
+
+	/*
+	 * Publish the sample slot stores before advancing head; pairs
+	 * with the smp_load_acquire() of head in mprof_pop_sample().
+	 */
+	smp_store_release(&pcpu->head, next);
+	return true;
+}
+
+static bool mprof_pop_sample(struct mprof_sample_pcpu *pcpu, struct mprof_sample *s)
+{
+	int tail = READ_ONCE(pcpu->tail);
+	/*
+	 * Pairs with the smp_store_release() of head in mprof_push_sample();
+	 * ensures the sample slot stores are visible before we read the slot.
+	 */
+	int head = smp_load_acquire(&pcpu->head);
+	int next = tail + 1;
+
+	if (head == tail)
+		return false;
+
+	if (next >= IBS_NR_SAMPLES)
+		next = 0;
+
+	*s = pcpu->samples[tail];
+
+	WRITE_ONCE(pcpu->tail, next);
+	return true;
+}
+
+/*
+ * Remove access samples from percpu buffer and send them
+ * to pghot sub-system for further action.
+ */
+static void mprof_work_handler(struct work_struct *work)
+{
+	struct mprof_worker *mw = container_of(work, struct mprof_worker, work);
+	unsigned int cpu = mw->cpu;
+	struct mprof_sample_pcpu *pcpu = per_cpu_ptr(mprof_s, cpu);
+	struct mprof_sample s;
+
+	for (;;) {
+		while (mprof_pop_sample(pcpu, &s))
+			pghot_record_access(s.pfn, s.nid, PGHOT_HWHINTS,
+					    s.time);
+
+		per_cpu(mprof_work_pending, cpu) = false;
+
+		/*
+		 * Publish the cleared pending flag before re-checking the
+		 * ring.
+		 */
+		smp_mb();
+
+		if (READ_ONCE(pcpu->head) == READ_ONCE(pcpu->tail))
+			return;
+
+		/*
+		 * A sample was pushed after we exited the drain loop; the
+		 * producer may have skipped re-queuing because pending was
+		 * still set. Keep draining until the ring is observably empty
+		 * with pending cleared.
+		 */
+	}
+}
+
+/*
+ * Empty a dying CPU's sample ring.
+ *
+ * This is called from hotplug teardown callback and IBS Memory Profiler
+ * has been disabled at this point. There is no concurrent producer or
+ * consumer for this CPU's ring here, hence the plain accesses.
+ */
+static inline void mprof_drain_cpu(unsigned int cpu)
+{
+	struct mprof_sample_pcpu *pcpu = per_cpu_ptr(mprof_s, cpu);
+
+	pcpu->head = 0;
+	pcpu->tail = 0;
+}
+
+/*
+ * L3MissOnly + Exclude kernel RIP
+ */
+static void mprof_enable_profiling(void)
+{
+	u64 mprof_config = IBS_MPROF_CTL_CNT_CTL | IBS_MPROF_CTL_L3MISSONLY;
+	unsigned int period = IBS_MPROF_SAMPLE_PERIOD;
+	u64 ctl, ctl2;
+
+	/*
+	 * Assemble bits 26:20 and 19:4 of periodic op counter in ctl.
+	 * The lower 4 bits are always 0000b.
+	 */
+	ctl = (period >> 4) & IBS_MPROF_CTL_MAXCNT_MASK;
+	ctl |= (period & IBS_MPROF_CTL_MAXCNT_EXT_MASK);
+	ctl |= mprof_config;
+	wrmsrq(MSR_AMD64_IBS_MPROF_CTL, ctl);
+
+	/*
+	 * Exclude samples that have bit 63 of their RIP set.
+	 */
+	ctl2 = IBS_MPROF_CTL2_EXCLUDE_KERNEL;
+	wrmsrq(MSR_AMD64_IBS_MPROF_CTL2, ctl2);
+}
+
+static void mprof_disable_profiling(u64 mem_ctl)
+{
+	mem_ctl &= ~IBS_MPROF_CTL_ENABLE;
+	mem_ctl &= ~IBS_MPROF_CTL_VAL;
+	wrmsrq(MSR_AMD64_IBS_MPROF_CTL, mem_ctl);
+
+	wrmsrq(MSR_AMD64_IBS_MPROF_CTL2, IBS_MPROF_CTL2_DISABLE);
+}
+
+/*
+ * IBS interrupt handler: Process the memory access info reported by IBS.
+ *
+ * Reads the MSRs to collect all the information about the reported
+ * memory access, validates the access, stores the valid sample and
+ * schedules the work on this CPU to further process the sample.
+ */
+static void mprof_overflow_handler(void)
+{
+	u64 mem_ctl, mem_data3, mem_data2, paddr, data_src;
+	struct work_struct *w = &this_cpu_ptr(&mprof_work)->work;
+	unsigned long pfn;
+	struct page *page;
+
+	rdmsrq(MSR_AMD64_IBS_MPROF_CTL, mem_ctl);
+	if (!(mem_ctl & IBS_MPROF_CTL_VAL))
+		return;
+
+	mprof_disable_profiling(mem_ctl);
+	count_vm_event(HWHINT_TOTAL_EVENTS);
+
+	rdmsrq(MSR_AMD64_IBS_MPROF_DATA3, mem_data3);
+	rdmsrq(MSR_AMD64_IBS_MPROF_DATA2, mem_data2);
+
+	data_src = mem_data2 & IBS_MPROF_DATA2_DATASRC_MASK;
+	data_src |= ((mem_data2 & IBS_MPROF_DATA2_DATASRC_MASK_HIGH) >>
+			IBS_MPROF_DATA2_DATASRC_MASK_HIGH_SHIFT);
+
+	switch (data_src) {
+	case IBS_MPROF_DATA2_DATASRC_DRAM:
+		count_vm_event(HWHINT_DRAM_ACCESSES);
+		break;
+	case IBS_MPROF_DATA2_DATASRC_EXT_MEM:
+		count_vm_event(HWHINT_EXTMEM_ACCESSES);
+		break;
+	}
+
+	/* Is linear addr valid? */
+	if (!(mem_data3 & IBS_MPROF_DATA3_LADDR_VALID))
+		goto handled;
+
+	/* Is phys addr valid? */
+	if (!(mem_data3 & IBS_MPROF_DATA3_PADDR_VALID))
+		goto handled;
+	rdmsrq(MSR_AMD64_IBS_MPROF_PHYADDR, paddr);
+
+	pfn = PHYS_PFN(paddr);
+	page = pfn_to_online_page(pfn);
+	if (!page)
+		goto handled;
+
+	/*
+	 * Use the accessing CPU's node as the migration target. On
+	 * topologies where all CPUs reside on toptier nodes (the common
+	 * case), this is the desired behaviour. Topologies that place
+	 * CPUs on lower-tier nodes are rejected later by
+	 * pghot_record_access() via the src_nid == nid early return.
+	 */
+	if (!mprof_push_sample(pfn, numa_node_id(), jiffies))
+		goto handled;
+
+	if (!this_cpu_read(mprof_work_pending)) {
+		this_cpu_write(mprof_work_pending, true);
+		schedule_work_on(smp_processor_id(), w);
+	}
+	count_vm_event(HWHINT_USEFUL_EVENTS);
+
+handled:
+	mprof_enable_profiling();
+}
+
+DEFINE_IDTENTRY_SYSVEC(sysvec_ibs_memprof)
+{
+	inc_irq_stat(IBS_MEMPROF);
+	mprof_overflow_handler();
+	apic_eoi();
+}
+
+static int get_mprof_lvt_offset(void)
+{
+	u64 val;
+
+	rdmsrq(MSR_AMD64_IBSCTL, val);
+	if (!(val & IBSCTL_MPROF_LVT_OFFSET_VALID))
+		return -EINVAL;
+
+	return (val & IBSCTL_MPROF_LVT_OFFSET_MASK) >>
+		IBSCTL_MPROF_LVT_OFFSET_SHIFT;
+}
+
+static int x86_amd_ibs_mprof_startup(unsigned int cpu)
+{
+	int offset = get_mprof_lvt_offset();
+
+	if (offset < 0) {
+		pr_warn("offset not valid on cpu #%d\n", cpu);
+		return 0;
+	}
+
+	if (setup_APIC_eilvt(offset, IBS_MEMPROF_VECTOR, APIC_DELIVERY_MODE_FIXED, 0)) {
+		pr_warn("APIC setup failed on cpu #%d\n", cpu);
+		return 0;
+	}
+
+	mprof_enable_profiling();
+	return 0;
+}
+
+static int x86_amd_ibs_mprof_teardown(unsigned int cpu)
+{
+	int offset = get_mprof_lvt_offset();
+	u64 mem_ctl;
+
+	if (offset >= 0)
+		setup_APIC_eilvt(offset, IBS_MEMPROF_VECTOR, APIC_DELIVERY_MODE_FIXED, 1);
+
+	rdmsrq(MSR_AMD64_IBS_MPROF_CTL, mem_ctl);
+	mprof_disable_profiling(mem_ctl);
+
+	/*
+	 * The producer is now silenced and this CPU's worker is gone. Drop
+	 * any unconsumed samples (see mprof_drain_cpu) and clear the pending
+	 * flag so a subsequent re-online of this CPU starts from a clean
+	 * state.
+	 */
+	mprof_drain_cpu(cpu);
+	per_cpu(mprof_work_pending, cpu) = false;
+
+	return 0;
+}
+
+static int __init mprof_access_profiling_init(void)
+{
+	u32 mprof_caps = cpuid_eax(IBS_CPUID_FEATURES);
+	int cpu, ret;
+
+	if (!(mprof_caps & IBS_CAPS_MEM_PROFILER)) {
+		pr_info("capability is unavailable for access profiling\n");
+		return 0;
+	}
+
+	mprof_s = alloc_percpu_gfp(struct mprof_sample_pcpu, GFP_KERNEL | __GFP_ZERO);
+	if (!mprof_s) {
+		pr_err("alloc_percpu_gfp failed\n");
+		return 0;
+	}
+
+	for_each_possible_cpu(cpu) {
+		struct mprof_worker *mw = per_cpu_ptr(&mprof_work, cpu);
+
+		INIT_WORK(&mw->work, mprof_work_handler);
+		mw->cpu = cpu;
+	}
+
+	ret = cpuhp_setup_state(CPUHP_AP_MM_AMD_IBS_MEMPROF_STARTING,
+				"x86/amd/ibs_mprof:starting",
+				x86_amd_ibs_mprof_startup,
+				x86_amd_ibs_mprof_teardown);
+
+	if (ret) {
+		free_percpu(mprof_s);
+		pr_err("cpuhp_setup_state failed: %d\n", ret);
+	} else {
+		pr_info("IBS Memory Profiler is available for memory access profiling\n");
+	}
+	return 0;
+}
+
+device_initcall(mprof_access_profiling_init);
diff --git a/include/linux/cpuhotplug.h b/include/linux/cpuhotplug.h
index 0fb3a2a62eb0..2cd232b3bfcc 100644
--- a/include/linux/cpuhotplug.h
+++ b/include/linux/cpuhotplug.h
@@ -150,6 +150,7 @@ enum cpuhp_state {
 	CPUHP_AP_PERF_X86_AMD_UNCORE_STARTING,
 	CPUHP_AP_PERF_X86_STARTING,
 	CPUHP_AP_PERF_X86_AMD_IBS_STARTING,
+	CPUHP_AP_MM_AMD_IBS_MEMPROF_STARTING,
 	CPUHP_AP_PERF_XTENSA_STARTING,
 	CPUHP_AP_ARM_VFP_STARTING,
 	CPUHP_AP_ARM64_DEBUG_MONITORS_STARTING,
diff --git a/include/linux/vm_event_item.h b/include/linux/vm_event_item.h
index 58d510711bd4..39409aa95482 100644
--- a/include/linux/vm_event_item.h
+++ b/include/linux/vm_event_item.h
@@ -179,6 +179,13 @@ enum vm_event_item { PGPGIN, PGPGOUT, PSWPIN, PSWPOUT,
 		PGHOT_RECORDED_ACCESSES,
 		PGHOT_RECORDED_HINTFAULTS,
 		PGHOT_RECORDED_HWHINTS,
+#ifdef CONFIG_HWMEM_PROFILER
+		HWHINT_TOTAL_EVENTS,
+		HWHINT_DRAM_ACCESSES,
+		HWHINT_EXTMEM_ACCESSES,
+		HWHINT_USEFUL_EVENTS,
+		HWHINT_DROPPED_EVENTS,
+#endif /* CONFIG_HWMEM_PROFILER */
 #endif /* CONFIG_PGHOT */
 		NR_VM_EVENT_ITEMS
 };
diff --git a/mm/Kconfig b/mm/Kconfig
index 61ab18f4aebb..6a70e81b371e 100644
--- a/mm/Kconfig
+++ b/mm/Kconfig
@@ -1534,6 +1534,15 @@ config PGHOT_PRECISE
 	  4 bytes per page against the default one byte per page. Preferable
 	  to enable this on systems with multiple nodes in toptier.
 
+config HWMEM_PROFILER
+	bool
+	depends on PGHOT
+	help
+	  Umbrella symbol enabled by any in-kernel driver that forwards
+	  hardware-observed memory accesses to the pghot subsystem (for
+	  example AMD_IBS_MEMPROF on x86_64). Drivers select this; users
+	  do not enable it directly.
+
 source "mm/damon/Kconfig"
 
 endmenu
diff --git a/mm/vmstat.c b/mm/vmstat.c
index da668ff05032..0d0ea5e664e3 100644
--- a/mm/vmstat.c
+++ b/mm/vmstat.c
@@ -1493,6 +1493,13 @@ const char * const vmstat_text[] = {
 	[I(PGHOT_RECORDED_ACCESSES)]		= "pghot_recorded_accesses",
 	[I(PGHOT_RECORDED_HINTFAULTS)]		= "pghot_recorded_hintfaults",
 	[I(PGHOT_RECORDED_HWHINTS)]		= "pghot_recorded_hwhints",
+#ifdef CONFIG_HWMEM_PROFILER
+	[I(HWHINT_TOTAL_EVENTS)]		= "hwhint_total_events",
+	[I(HWHINT_DRAM_ACCESSES)]		= "hwhint_dram_accesses",
+	[I(HWHINT_EXTMEM_ACCESSES)]		= "hwhint_extmem_accesses",
+	[I(HWHINT_USEFUL_EVENTS)]		= "hwhint_useful_events",
+	[I(HWHINT_DROPPED_EVENTS)]		= "hwhint_dropped_events",
+#endif /* CONFIG_HWMEM_PROFILER */
 #endif /* CONFIG_PGHOT */
 #undef I
 #endif /* CONFIG_VM_EVENT_COUNTERS */
-- 
2.34.1


