Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E5264CA0EDC
	for <linux-mm@archiver.kernel.org>; Thu, 14 Aug 2025 13:51:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 86DFD90016F; Thu, 14 Aug 2025 09:51:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8455E900023; Thu, 14 Aug 2025 09:51:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7356590016F; Thu, 14 Aug 2025 09:51:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5C093900023
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 09:51:15 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 2263C138638
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 13:51:15 +0000 (UTC)
X-FDA: 83775499710.01.7DC4FF4
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2051.outbound.protection.outlook.com [40.107.92.51])
	by imf24.hostedemail.com (Postfix) with ESMTP id 2FDF1180003
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 13:51:11 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=axxxzRP0;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf24.hostedemail.com: domain of bharata@amd.com designates 40.107.92.51 as permitted sender) smtp.mailfrom=bharata@amd.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755179472;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dXCLP7LS/KfXDafwpQvsPCw+JGNumX2OyTonQaCXLh8=;
	b=VJS0yo/x1NCprm159+/T1ICNTPDZSJWEw53J9Yrk2ffReLs3NaEcYRxzWZBwRhlW6le+yb
	bCqo6Wn467p3P0yvC6LIPRDCA/d8scqv0i8xVw9osHAX8FSjS5flrbwrjqUmUzfLnkuMyE
	mz5pCKH6WW6aG056R/TzBJ98iYz94/c=
ARC-Authentication-Results: i=2;
	imf24.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=axxxzRP0;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf24.hostedemail.com: domain of bharata@amd.com designates 40.107.92.51 as permitted sender) smtp.mailfrom=bharata@amd.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1755179472; a=rsa-sha256;
	cv=pass;
	b=VXnDbJK7ChGP8CgAcrzsqFmUFHuD1vSVDt33zatBiMGyWZq+QOqnmQftpLJDfF38D1v6g4
	smVH5HdOfCpLUATGjHcUIuNQ6VjTmWYu2PLbjWKAGB07vniijwwcOWXDKrfKeqiIAoIImR
	wMzyndDLGCxOzIpVkKyOcfH7hL0Rq58=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=RftCnU5AJF0bKELIElRKCW2bilmxpXhiZ7t1PDhzg/MGJz1EWkAba07Ug+IybL1/8NBwe4Sin2RyZAH9HWJmc4gc09EHCTCofHavM1Q01qXkhCx3tZrygjzchoX0htdW67r8zi1Oku3zxJFKNninV8LSOKaFiv0UNWBjh5KnLpSaGkm3qGXIUSeT2BzkazmCrFz7wTDdz1VDh2HhDZIj05WgwyXHNuh4eDp0Rn7F5zz00TLyt/sow42avRbRkP13X8kJnG2/uJYnAtk3YpWr5vRCsLxAuy33uiIBc3wq+oAUc+0jVkXJb/q/KdRkz3aUKpTP5VFy3NdsxcvRM2m2YA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dXCLP7LS/KfXDafwpQvsPCw+JGNumX2OyTonQaCXLh8=;
 b=wifp1+YiECAg8i2WkdSdi1Rp2OLFHOIJiX93m5SnFVU4/oMuaxFJWWcMtHNbOE0qT+/SMJdGp63j86JXlFPzJKhYmBR3wqSOvmLRBLSw+loY5taxbw7SK+FnC/uuMqRo9I5WCMhuhF3orSpEPdQqG9QpkX+H0erxJKstyAmfUj3O9kYg3rp0CRvcdcNu9lHChUQfBQr/pWSU2nEyIGtuYbioNlgmiB8eDvPsuXGaakTGJSFKxD4FpbAuMe4u6RqkWktR4kYP/pjrhBsE7g9ek3repXLJuDhQW6eTXOLnhU+rTJu6tKEsaB36kaqB3pCAddbBX8gTQCWRHugncM+qZw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dXCLP7LS/KfXDafwpQvsPCw+JGNumX2OyTonQaCXLh8=;
 b=axxxzRP0ceu6wY0QTVLRg3FiE6rxTW7eDfGzEx/ajWbFmTd4b4twKifXbFg0jV81rludK5FlAXJtY4ZMEpdUuYVcDYFH585sVqgMaY/Xo82uv5OXOfYBdfbOqcbRSs+Te0saP+E9I6a09w7oNY8CmMzuziRt9aJDuPZy8G2NctQ=
Received: from DS7P220CA0070.NAMP220.PROD.OUTLOOK.COM (2603:10b6:8:224::33) by
 CH3PR12MB8725.namprd12.prod.outlook.com (2603:10b6:610:170::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9031.16; Thu, 14 Aug
 2025 13:51:09 +0000
Received: from DS1PEPF00017090.namprd03.prod.outlook.com
 (2603:10b6:8:224:cafe::dd) by DS7P220CA0070.outlook.office365.com
 (2603:10b6:8:224::33) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9031.17 via Frontend Transport; Thu,
 14 Aug 2025 13:51:09 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DS1PEPF00017090.mail.protection.outlook.com (10.167.17.132) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.9031.11 via Frontend Transport; Thu, 14 Aug 2025 13:51:09 +0000
Received: from BLR-L-BHARARAO.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Thu, 14 Aug
 2025 08:50:59 -0500
From: Bharata B Rao <bharata@amd.com>
To: <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>
CC: <Jonathan.Cameron@huawei.com>, <dave.hansen@intel.com>,
	<gourry@gourry.net>, <hannes@cmpxchg.org>, <mgorman@techsingularity.net>,
	<mingo@redhat.com>, <peterz@infradead.org>, <raghavendra.kt@amd.com>,
	<riel@surriel.com>, <rientjes@google.com>, <sj@kernel.org>,
	<weixugc@google.com>, <willy@infradead.org>, <ying.huang@linux.alibaba.com>,
	<ziy@nvidia.com>, <dave@stgolabs.net>, <nifan.cxl@gmail.com>,
	<xuezhengchu@huawei.com>, <yiannis@zptcorp.com>, <akpm@linux-foundation.org>,
	<david@redhat.com>, <byungchul@sk.com>, <kinseyho@google.com>,
	<joshua.hahnjy@gmail.com>, <yuanchu@google.com>, <balbirs@nvidia.com>,
	Bharata B Rao <bharata@amd.com>
Subject: [RFC PATCH v1 5/7] x86: ibs: Enable IBS profiling for memory accesses
Date: Thu, 14 Aug 2025 19:18:24 +0530
Message-ID: <20250814134826.154003-6-bharata@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250814134826.154003-1-bharata@amd.com>
References: <20250814134826.154003-1-bharata@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS1PEPF00017090:EE_|CH3PR12MB8725:EE_
X-MS-Office365-Filtering-Correlation-Id: 9a12639f-65e5-4aa8-03b6-08dddb399f88
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|82310400026|1800799024|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?QMt5ImjQG6NIgul4tzJALc98C76PL+a7Xz+ICq74vKRxTPL55FP482eeY0Xb?=
 =?us-ascii?Q?JpLVX+oChGxHGcPkg3uILqWi1eicJ6P4N28X1bgyzdSohvAmmcQXGrBWw839?=
 =?us-ascii?Q?atjFWJAZsQuac7Dslg7+h+jv+Gv665y5TVsX86wKeEdRBzT+heqC+3J3sEnL?=
 =?us-ascii?Q?ZKVMrAUz6cJZ32nMX918t8PH/j7fvKlv4tB/vk+5oI6LHt10HCBzvt35FjJw?=
 =?us-ascii?Q?NnBQlg2EHj29zCEXtviR8M1H83Cq2glzBOzOmjYXgvLERS6OLPGVIFhYxQFT?=
 =?us-ascii?Q?IsNdCyyYLY/+Kkt/OOceTD29d53uMlyqA7+TcfD7/B9jlwSDQ4hq81YJlq+5?=
 =?us-ascii?Q?iTbqD9X5asPtms9tUk2dyx0gGheM0XlNHfyS+UiemE4uq+JjE+cjrKHYf9co?=
 =?us-ascii?Q?mwetWaL74209eGajM9lOelxzUl/3F1l6PVPAsDVpMgDqaBR03jlaTPce4Wu9?=
 =?us-ascii?Q?5Y237oy7Eny+83WuRDJJveQC/BH9z8vaojr7eP72RWkDK2GSZbOOmsJ/zdXL?=
 =?us-ascii?Q?pQ0mCUoK3pquDUzjovuHHL4J3gz/okpRhWiJQEByvUzeaa/On6/RE5pL4HkQ?=
 =?us-ascii?Q?SD23Ng+HFkxIdR0A2yWN2ymCAyRAJJ3QANlWwXVoVL9lNeYF6pTlDFZaMjlq?=
 =?us-ascii?Q?NEYkCtJyWXGcQFA2K37Rn9gmMgwZD8e9vAgFr3/UEa2pBCwibPFgG62Fabwf?=
 =?us-ascii?Q?q1e+Z7jGX2O/aeZwQ2ABJJofALRCMH9DT6yyjoXEAXdAIzlF3Tgk4N0KTYOd?=
 =?us-ascii?Q?fLOHbanzym8xNAxuykH3ZSdnkgno16UkrqFeJ9UpCspDHBgjcKAnq4+BpPU1?=
 =?us-ascii?Q?3t6tCNFR0pSvoLxKiT4g1FEyoC9wKqunG1sYVf9uXfMouhFHNKdSZR0dvK0Z?=
 =?us-ascii?Q?RVtrXPiScj4dwlHoDYyav/Rwk5OZ+N5qVJFmM8UTTZxz12Xg7i1oPU0bnMie?=
 =?us-ascii?Q?XoZN97T5HYPzLoYauKzqkVA/GAl3cOUxyhntk1TeyO2ijPOI+tlDR0v7/ikm?=
 =?us-ascii?Q?h2a9XZ+3M0JKYIWzqEPLvBeoaOjAgyxPKWQXMDCKZHuUzy+H7UU4vsqgrIh0?=
 =?us-ascii?Q?bxrjWqsq8CIJaLHx+04GUn/DXtMg1BFO+Ki97EnBUnvcElSjMxqiI17/fPzb?=
 =?us-ascii?Q?PKNJLKl8RBcHviIzPFLuzSefQTLrdVGc8NbdaWnQSVSMMuwGEavZdarE2EfP?=
 =?us-ascii?Q?UCKv5v1JqYkN1wa0B5uUHSRd1HlwgePRX8p4M5gAtfucWrvvSqJqmAgLghf4?=
 =?us-ascii?Q?ddEbCC4aj1O/hKEeaoKf4EtmL/lH3KNRTnqANvrKCa4T9PvuqS6Zcmukn0Il?=
 =?us-ascii?Q?pCg7Et1UQgdMVFUYuUKJuSsjPA6E0+qhJ+eVU6EP1bUKDpG4S7pSVSKwE2tW?=
 =?us-ascii?Q?cvCiGGErh6+bwgCY+Whbv0KXAXYLvUjX2nmaLw8t0OrFNWgZGeEb7E4fpwlL?=
 =?us-ascii?Q?63cdovPNlypcLcrVes8xT0t8FQEgRWJfnyXUNnbaRIvAQpHJNJQB5AgNQZ+d?=
 =?us-ascii?Q?pNy5O3JDPdm0GcXcRiKSohTcLwoBKk9Fe3sH?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(7416014)(376014)(82310400026)(1800799024)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Aug 2025 13:51:09.1784
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 9a12639f-65e5-4aa8-03b6-08dddb399f88
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS1PEPF00017090.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB8725
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 2FDF1180003
X-Stat-Signature: f5m8iem5k1nyn8kakh54p9fbg51qa97x
X-Rspam-User: 
X-HE-Tag: 1755179471-784402
X-HE-Meta: U2FsdGVkX1/2DcnMr+NlRUILGx+4BcqX7aDhCVQtvpbTO87y94RdDjdcRTLnw/yR94PAtqIp7t1Mjs2qEFWnKpei29vGdGOZb2Q/XkTvcomCTkchndAz9pLjT5H7deMmBMibr4rTumCdCkVxazMmwR9Vi9HjSpvvP3ZnoPyeq1Knv/eNkxU/i+7AS+gYyNWyEWtdAdCmDGlxdAJofSmwmjwLgQBR619e4uZ/J+qo2DKsFDBxPyew656j72anUY1isMoadAK8UIbX+3mrI0Dkc7VyY3S4msztcRkxnrChNoR93GzNzFCvAjeFLH+ZlGNwoi5ZbwmrlmIuPLyy3yyA8pFA8OnfngntmHD92G7YiiW3608s7OQuJEofN8fJZAKWu3rFRDrnRLyTPkR3/3/JJrhv2mOeou9WChAIRGJQ5Vmh9R35Dz8vYEK+CrGpq8UVGh1uUI6vZ64zvOGKSIyjhEAmiV613GoP0Io/C6UrZ8DZU92kaFy0DgRNbTbyQTr1QPl81AJX9lSJFKbCO6efprDGAHSTOOmziRR+gNtUR3H9KZ09fsRhrOuyJoYCTIxUOGLkH7z35xSoQdd/HLtcU54UMQl7F93w94RHhQbRUxeSTvo70ipYbWd/YFHhxSEZzu6Ek1E4wxXkTEa6Kuq0iYCcTwDtUC92s+qts8Tk1aysdUGZuLLvLGZL4w40vfrifa7VqkOBwecY4z+fZo0V8CH4SVZVGepk+mfz9T25q9pUe5t5e5MTyY+b6lCuLTJFsye9c6zjBbHDj3VWyMt53EnYvSK0jvEV1uNTmAq/uALIBn4wOXWSys39HHh87MHhSsA1Ey1dufe6yBIjwAokTdj7s186zAIpNju/lDwsPgRMXHmzdVigNQYsP7UyYKcixuM1fIVRM+c4p/boDhtU5egMtOjliDY2FFaw+McpwOWtsE05ORQvAhGs54TWj34PF1Ff+VCAASwbM4c/JSL
 tNMNcBhp
 moymriYFr6+gR8y2lEr1rnipVZzsyu16+Zjx7KYMonDXpCFgxAYCHgZktB4AOZ8jhgm2QByIkqVWjLEEfTtQoMtlJXCp+kyhY7+4aXR7NYm7PZNZIsqkOmB8fhcigCEvty6ombtaodI7j0nEVNZU6ZZEHKC6o8E7V10W3my6T56SeybsvnUHpNALn3eplRbEIz35gCR0xXXzFqSVRnD2zKGLjcVWAhT32QS+bMNowpdJYJB5Znwx515NUWkDiCAdjJ0qsOxotKxcjPB0HCJIcNB+/vAIuJ9V2YAPos5mYeL844wBPnQzKth9M9Kn4Z7AIqZl8eAPy3L5szCdDIAe5uy5Y0VFdDLZLKSbDqO2p8GTVEuh+rxzseDJIxZ17v5upqGFKt2FvdQZ3FpN2BXpVxxqNEr/I9+bTsmfmJFqZFt1S8IbCBCq5hn5NzvE1Z2783CrYKxG+1R6zJHwmwgXNSQzRXmX7auiHHOzCldB1y2ioD1i0utBPJQJ/NSkHVCksdZBRrHWyA4LO51fMgFoNPsmokNn1ilrYBjvmEGr3gnrFTUHu6a9BnZ7RIjkmpX6PNYl/biAPKGWZ85iGMO5Ai48Fn8p2jDPkqa1g3RNoVoV0LZRfZKvXNwqL9dwq9sTLdoF6FbdLjY3xu7GAB9En92PmYGIU5SeLUvXO
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Enable IBS memory access data collection for user memory
accesses by programming the required MSRs. The profiling
is turned ON only for user mode execution and turned OFF
for kernel mode execution. Profiling is explicitly disabled
for NMI handler too.

TODOs:

- IBS sampling rate is kept fixed for now.
- Arch/vendor separation/isolation of the code needs relook.

Signed-off-by: Bharata B Rao <bharata@amd.com>
---
 arch/x86/include/asm/entry-common.h |  3 +++
 arch/x86/include/asm/hardirq.h      |  2 ++
 arch/x86/include/asm/ibs.h          |  2 ++
 arch/x86/mm/ibs.c                   | 32 +++++++++++++++++++++++++++++
 4 files changed, 39 insertions(+)

diff --git a/arch/x86/include/asm/entry-common.h b/arch/x86/include/asm/entry-common.h
index d535a97c7284..7144b57d209b 100644
--- a/arch/x86/include/asm/entry-common.h
+++ b/arch/x86/include/asm/entry-common.h
@@ -9,10 +9,12 @@
 #include <asm/io_bitmap.h>
 #include <asm/fpu/api.h>
 #include <asm/fred.h>
+#include <asm/ibs.h>
 
 /* Check that the stack and regs on entry from user mode are sane. */
 static __always_inline void arch_enter_from_user_mode(struct pt_regs *regs)
 {
+	hw_access_profiling_stop();
 	if (IS_ENABLED(CONFIG_DEBUG_ENTRY)) {
 		/*
 		 * Make sure that the entry code gave us a sensible EFLAGS
@@ -99,6 +101,7 @@ static inline void arch_exit_to_user_mode_prepare(struct pt_regs *regs,
 static __always_inline void arch_exit_to_user_mode(void)
 {
 	amd_clear_divider();
+	hw_access_profiling_start();
 }
 #define arch_exit_to_user_mode arch_exit_to_user_mode
 
diff --git a/arch/x86/include/asm/hardirq.h b/arch/x86/include/asm/hardirq.h
index f00c09ffe6a9..0752cb6ebd7a 100644
--- a/arch/x86/include/asm/hardirq.h
+++ b/arch/x86/include/asm/hardirq.h
@@ -91,4 +91,6 @@ static __always_inline bool kvm_get_cpu_l1tf_flush_l1d(void)
 static __always_inline void kvm_set_cpu_l1tf_flush_l1d(void) { }
 #endif /* IS_ENABLED(CONFIG_KVM_INTEL) */
 
+#define arch_nmi_enter()	hw_access_profiling_stop()
+#define arch_nmi_exit()		hw_access_profiling_start()
 #endif /* _ASM_X86_HARDIRQ_H */
diff --git a/arch/x86/include/asm/ibs.h b/arch/x86/include/asm/ibs.h
index b5a4f2ca6330..6b480958534e 100644
--- a/arch/x86/include/asm/ibs.h
+++ b/arch/x86/include/asm/ibs.h
@@ -2,6 +2,8 @@
 #ifndef _ASM_X86_IBS_H
 #define _ASM_X86_IBS_H
 
+void hw_access_profiling_start(void);
+void hw_access_profiling_stop(void);
 extern bool arch_hw_access_profiling;
 
 #endif /* _ASM_X86_IBS_H */
diff --git a/arch/x86/mm/ibs.c b/arch/x86/mm/ibs.c
index 6669710dd35b..3128e8fa5f39 100644
--- a/arch/x86/mm/ibs.c
+++ b/arch/x86/mm/ibs.c
@@ -16,6 +16,7 @@ static u64 ibs_config __read_mostly;
 static u32 ibs_caps;
 
 #define IBS_NR_SAMPLES	150
+#define IBS_SAMPLE_PERIOD      10000
 
 /*
  * Basic access info captured for each memory access.
@@ -98,6 +99,36 @@ static void ibs_irq_handler(struct irq_work *i)
 	schedule_work_on(smp_processor_id(), &ibs_work);
 }
 
+void hw_access_profiling_stop(void)
+{
+	u64 ops_ctl;
+
+	if (!arch_hw_access_profiling)
+		return;
+
+	rdmsrl(MSR_AMD64_IBSOPCTL, ops_ctl);
+	wrmsrl(MSR_AMD64_IBSOPCTL, ops_ctl & ~IBS_OP_ENABLE);
+}
+
+void hw_access_profiling_start(void)
+{
+	u64 config = 0;
+	unsigned int period = IBS_SAMPLE_PERIOD;
+
+	if (!arch_hw_access_profiling)
+		return;
+
+	/* Disable IBS for kernel thread */
+	if (!current->mm)
+		goto out;
+
+	config = (period >> 4)  & IBS_OP_MAX_CNT;
+	config |= (period & IBS_OP_MAX_CNT_EXT_MASK);
+	config |= ibs_config;
+out:
+	wrmsrl(MSR_AMD64_IBSOPCTL, config);
+}
+
 /*
  * IBS NMI handler: Process the memory access info reported by IBS.
  *
@@ -304,6 +335,7 @@ static int __init ibs_access_profiling_init(void)
 			  x86_amd_ibs_access_profile_startup,
 			  x86_amd_ibs_access_profile_teardown);
 
+	arch_hw_access_profiling = true;
 	pr_info("IBS setup for memory access profiling\n");
 	return 0;
 }
-- 
2.34.1


