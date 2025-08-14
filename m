Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 563DECA0EE4
	for <linux-mm@archiver.kernel.org>; Thu, 14 Aug 2025 13:49:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D71A4900169; Thu, 14 Aug 2025 09:49:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D22DB900023; Thu, 14 Aug 2025 09:49:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BEB05900169; Thu, 14 Aug 2025 09:49:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id AA293900023
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 09:49:05 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id A8EC61DCDD7
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 13:49:04 +0000 (UTC)
X-FDA: 83775494208.19.3C8FF9F
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2045.outbound.protection.outlook.com [40.107.94.45])
	by imf22.hostedemail.com (Postfix) with ESMTP id C3FA7C0004
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 13:49:01 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=3lsvFmnn;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf22.hostedemail.com: domain of bharata@amd.com designates 40.107.94.45 as permitted sender) smtp.mailfrom=bharata@amd.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755179341;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=2y+ej3IBFomyuby1AfuDvl/ss35A5/PG/qzlYZMlZ5I=;
	b=tXcGK5ppf5Gjhs7rq4J5x36aRZviRrQn7+lAWhoIlpPn64PVH5h7/uEOTo//2ELnpmpY47
	IL0QIxRdji+kkXxCsowgAycD5t9XQN9MIcz+/iONKCiFuHtQHupApyja205Elz9li9rk+P
	aGqf5G0xhF6CA5vF5H0M2zTQ6Ri4Ugo=
ARC-Authentication-Results: i=2;
	imf22.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=3lsvFmnn;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf22.hostedemail.com: domain of bharata@amd.com designates 40.107.94.45 as permitted sender) smtp.mailfrom=bharata@amd.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1755179341; a=rsa-sha256;
	cv=pass;
	b=jYsPu3e0Ghp2Cdc7dOPsR7jQflWAeROB+MO3lrd9pbPSup0lHsrUeo9HJhd51h0CPjdTKT
	gnAbaVIb27HteP8x9FfsLwZVN7GhcZa31Or8smQj5r2HLnx+XLkmEsqxXdFC3ghec84LCj
	pl3DFdu8muRyxaGcNUX+Xi33gV9PcUI=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=T1bSukaxSLdCmmDpzKdFRJsgwEVtJPDuhPXh/Mn6XGni/yB3ekh8vXxrAiwXEV9LwmLL/xBSR5tMUGpVGMkcd1uIB1VKOIOe1TUQEkHqDb/zvVQ4dj1vKsOsz18a+FivC9U5vwWMcPpIjIv+v5MqjoDlkXcmKyvXcHmbo7P/nmm8BYNCsNiwHgl76itQuhfx0BYWdBJ1emnvumiKinWWqjNdlddUNgKwk7YjaKHcnLajs/caxRaxd/vhWqzf14UwYZsloEjNL0IAwHT7owqsQDtSMy568qIlPt41NTi8s3BfggzJEQ6hGJ1nwA2NbU2r8WEI00Oy0J5hwOyNH824eg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2y+ej3IBFomyuby1AfuDvl/ss35A5/PG/qzlYZMlZ5I=;
 b=QXlsRtw7VOjuRTHmpiJ289PPT2dJTFzsrlAcwZdamQNErY1nBQP0yAX46cx4I67edbmQ9DSi22LTRkr/be5QTS8TVTOnwjTbam0rWIQfGJnN81qilLoWYkxPEPrV50IjkU8/w7PRvDf8SbsLAw9qDqbVcilTeVji37NbrcXdhy1k2iO2QzwMfWba96GUm65uKktv1IuQFOfLIWF/Aq+9bjuwBQcRSZyIT7Z9uAapTG+CeY8NAy/31DdLy8rDLxagG9LZLWGC8jgC7oSM3VAUI+0pYe71j1yr5YDFekT+7EB9T7gsvjn6w5uCwu+BifjsySWZoo5K7YTml1D5+oitPg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2y+ej3IBFomyuby1AfuDvl/ss35A5/PG/qzlYZMlZ5I=;
 b=3lsvFmnnUnOnXx1VUiKCP6BhkQM18l6r/fF2Lb3x5Fi8ADfTigLQS1JzwG8YTsho/uHGqjTyNPl/n1Tei5qS63Zt+akPq0iG21gjvskBkW5DHe6u8rD6tLeKKX55/jzHMn06XSQpv0XbV8iLk1AdFYbxJm67292llh8ed8xiDvw=
Received: from BY3PR05CA0022.namprd05.prod.outlook.com (2603:10b6:a03:254::27)
 by SN7PR12MB7883.namprd12.prod.outlook.com (2603:10b6:806:32b::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9009.16; Thu, 14 Aug
 2025 13:48:59 +0000
Received: from SN1PEPF00036F3F.namprd05.prod.outlook.com
 (2603:10b6:a03:254:cafe::a) by BY3PR05CA0022.outlook.office365.com
 (2603:10b6:a03:254::27) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9052.5 via Frontend Transport; Thu,
 14 Aug 2025 13:48:58 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SN1PEPF00036F3F.mail.protection.outlook.com (10.167.248.23) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.9031.11 via Frontend Transport; Thu, 14 Aug 2025 13:48:58 +0000
Received: from BLR-L-BHARARAO.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Thu, 14 Aug
 2025 08:48:50 -0500
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
Subject: [RFC PATCH v1 0/7] A subsystem for hot page detection and promotion
Date: Thu, 14 Aug 2025 19:18:19 +0530
Message-ID: <20250814134826.154003-1-bharata@amd.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN1PEPF00036F3F:EE_|SN7PR12MB7883:EE_
X-MS-Office365-Filtering-Correlation-Id: 2445c812-e6ec-4b81-4e20-08dddb3951bf
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|7416014|376014|36860700013|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?JiuJB6w+bk9yL1NOymCra9E2B7O3hsIT9CafZdsSXDJ/ob67hd/2WFcGoWG6?=
 =?us-ascii?Q?dxWe7ay2PLYaEMwGzNqS/ooOcYFMnaBi0gNd6jaUAH9IUyC/QJI7KC7l+riF?=
 =?us-ascii?Q?Ihdh5EcUv1Pz4KsYhvNlnP21uYAh0qFK1qNWj295Uz/gZCUwHVwPFfbCTjsD?=
 =?us-ascii?Q?0kGnEl9DGQHSLgLc1krQEAXR2XPAJ1+oNPxnIQ+kb8XHmZ743lGuCHuKT9/H?=
 =?us-ascii?Q?e59oyw4AsJRPHoz+gl0uYLufBv8cTPWKg5HbDQAEHDpZ3ShzmvBtJ6HZeobx?=
 =?us-ascii?Q?ElBMjm7fas8XwQ3nJdVi/EnnQdiuhoKlvQ8iVYdX0hh4gsCLWVs3P29JVOfR?=
 =?us-ascii?Q?bFA+KXHnl3OuqXnZiK0yjnHYlbLnpnDu8IBR3AKlfIpnsuDAaNH0xxPzu4Kh?=
 =?us-ascii?Q?vswUCTElIVvkEAKqh8BOGm8IZ1dG5rZjX1BPXyRiuJruyqZ0OAMMANXZnGhm?=
 =?us-ascii?Q?aWGHZVlkBZTWBotauq7ZUBlcubORdQVzEEW6v2Ibw1slUOD3E2CtBIh8d9TR?=
 =?us-ascii?Q?GkUXTE1Fyo+KjoeoAvzg6tdlVxp287Hm3vDeYZxxNdgFMTUycH2iw10CHcgZ?=
 =?us-ascii?Q?5rUHVGklkCix54q75m28F9a5CAZlWKeBQpWJK4zO6Xqu2+eYivOGcoFPFauZ?=
 =?us-ascii?Q?JOPpMJz+6JYM6yPRj0LYwDKfHE1/FEBymT1j6umVFC5MbJFQmuub395Zc1aQ?=
 =?us-ascii?Q?qPBUgqFlWabVFzCn4UIXZKK+l6oO3xeUXb1HUnprNqQe4173pbBCZgPRvW9x?=
 =?us-ascii?Q?vSzM9/83uRLYyR7hs+4jCEHLiTrgHnsHMmT8hAB8pG57vHpkg34UjItjq7Mm?=
 =?us-ascii?Q?EDe4avZ4B7z2c5fd29/KFjw1fmko5o08pleM9onLfD1+Z6rEiVCXUBD6NJfO?=
 =?us-ascii?Q?bpTJoPZ8ozPlAjHyvpCYTmBCJKiGXCUui4ZLl6iAhUt2Ku4YBQ6Vc91nv0Fx?=
 =?us-ascii?Q?GA3Vw4412u5EhhqEHpkcUCIvpwsY27CGRKGMHSP57khhRk2iUbKoSbjtgeL4?=
 =?us-ascii?Q?tjrBr9oCaGJTw/Y2gIGaOviX/aqjYOY0QH3R+XU9cVm8b/D3k1GB+KpZM9BE?=
 =?us-ascii?Q?dW1NV4aMIN7TExuQ/aOofnKKeAPdR5JrkrJd0lPKlsWGqvgWZJN2+2wa2eQg?=
 =?us-ascii?Q?8cQWJQ2OhNkz1dwKog2qedUiuVqWkZQt7L/F1qqFWv1Hqhjeqb3qtok7SfjZ?=
 =?us-ascii?Q?X0lPz8e8qWp9T99C/EoaWfCr65pMPZGKosv9SryBaz0gKpRTTKVrXTUNy9AP?=
 =?us-ascii?Q?E5sYNrU9aqX/aXwCd6Pi5Dis59JkXOyuaPTUaY79mqjh4bqsqWHqFzJt7QIa?=
 =?us-ascii?Q?yvtQcbNehNykFT1W7PKR2F9mFrpqDriVScDYIPmpQ58mFC5UhaCvH+zV8tEG?=
 =?us-ascii?Q?SnrBsoggvewdAGeB4OLW3OGuzzuac4s2yq+MoU4wGPOmZSCulc6Zx+gTHF++?=
 =?us-ascii?Q?WWJ+RVcK7zJS/Lz8RWoRqQ2RiGgJPJJbMh3Mn7bx6MpztMfmL7ciy6QVlg1t?=
 =?us-ascii?Q?03a/ZEfP+wGujd0Ql2EndYfg8/uDtvvyi/63nvmhdLlaUWy2K4kXl2gb5A?=
 =?us-ascii?Q?=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(36860700013)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Aug 2025 13:48:58.6842
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 2445c812-e6ec-4b81-4e20-08dddb3951bf
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SN1PEPF00036F3F.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB7883
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: C3FA7C0004
X-Stat-Signature: g9jr74ibu5m5uxzbeyxh1chreyxndthk
X-Rspam-User: 
X-HE-Tag: 1755179341-45391
X-HE-Meta: U2FsdGVkX1+tLmseHcoJ4NXMy9sCOEQFO6QO6VJ3HABsY6ixqsmCILLKbByrIR1WvM7M/cMG1FXtSy9XKWja4cHfhPDb1aSOV90+euiBgRcRGZb0GiwhImr+Wz/48e7uawtvXh9FYSGbYQuYR/SWO/wxdzxze0L69khcHxBJrB+gtCUxXxqjA8bmJ9g+QfieauOx3YjwFTfNbZ9qum1G6CEZaZ6hzQP5q9EWZnKD1cjMj7iEzq/ybyrVBaRNm4x+w/Oj9GT4+Bf9yYQr30BdjpN75vD6D2hRrOhQcrSCEJdEzbt7h3wAaj5nxUnQKYrISMIQ8rhee3KsHyRYODxloUTlnk8KnpJocKVUuW6JusfXMPxyNwH8epAuGOU6jxtE+XebKLaoSXtaEkZHXwzPJYAhcFmAIVyEODOvImuA+7Pp+1GhnKHMVn7Qo7HmGFiGT4t2rmtKc2y9FmwvVKrNaz7jrQiy8fVMSgBdBjT2Qq7FMNPc3Fr/LksjUnThZIHBOkPjSqq3fbe0WWJWcZgGegtYZlWY3PJk57nJHvGQudwhWQ3AxpEUSooDBKsVRS6S+3/K/Rkwhr9qi5Qz79I5d4oEa7C0L/3mSDEKDeyNl7liZWZQY70j6ImRBr9L+jBv8CNJw7OPp0C9IKR0O5qhHXrSuUvRH7lO79cm1A0AoVF038o8lQKoDHnxBewcjecAU+xE92uh5ARLDHgFYMPwdLdOJeKuOP6FogyWEDT84rMLdxgRcVM/7g6R59pAxmmjctmkNNLwh/Jk1cvXbUnd09OZVqDhiwpZJdkUxHGlURp1IJmigi7f2fPc4grjvcJRh9mbaiNNCPi2b10LOlHqHs4BFVLsXEgfNRdMqPDIUI0rW3P40GHaqtfD4L8GP60sbA/P5O2uMlLZSdPvOSjML9GC8cPSaC3ghEKb8au2L47gCTPy14wpQWrrtahR5QEwVLvvEkSADSJbuavTnOj
 r8exkhEy
 mqCThxBoZ1OY7aAKPwgcDvNDlcGglMM5h3rD4t492TfNBB3JuRJZKP3mfZCjvBlVxHljDqkgRegrcfoyfkzXDYo7T1nmuDLtOVc/Qg8gIsBC7pXqeUkabtN6+C07EWkCmMSLxT2uNi2za5U8xIuaQcFUyjLtJwmlFh93oXcdPAlg+RsGyvSH8wcEq12HFNMLOj3BF2Icmlk8idWyOYLG33FiyEBlaj76V1WK1oJPf/rUAcEzU7JEuZBxx97KuPM8+dtXHKzBt5CVyR3ZvEqETPm7rhuAUNdRp3V49fvwtLB80CUDV7xpg94gii1Y4zanr6XN1jEQlOKgxRKBxn0vRlRsptOFalpjBEteZ9mgWs2K11XvsW9IVL6YPPaZM6084orQwe07QICt8vJ3o2yPG3JNFQeWOelDQhqMgnso87U6P5WqAaJyGp/IztTpsFi+Rh0w/0RFCmUU6Er9nDS/Rj/Ma0i3YUIIi1j1y6TzsqPoNiXspIHx8OkWxRMvXGJTBo9VFy+8G1m5T6Sm2JYUFb9SI2e1Kc/1WGWkEyzAcEKxW5hsgKRno+0zMcw+pMifG+N93d7jmV9Y9dInCDDYvw1oQyezJmPlBI06Y4EI27vGESVVKSKyFDtoHp664Qmw8kgORY9RV/jvZzuNpZbm5dFekHJ7cn8ReEuTaFtl0qJtg40NoSYYGly3cQ9iRJF3K3YkxcwlULXHyxtMjMwIxDCh+EQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi,

This patchset is about adding a dedicated sub-system for maintaining
hot pages information from the lower tiers and promoting the hot pages
to the top tiers. It exposes an API that other sub-systems which detect
accesses, can use to report the accesses for further processing. Further
processing includes system-wide accumulation of memory access info at
PFN granularity, classification the PFNs as hot and promotion of hot
pages using per-node kernel threads. This is a continuation of the
earlier kpromoted work [1] that I posted a while back.

Kernel thread based async batch migration [2] was an off-shoot of
this effort that attempted to batch the migrations from NUMA
balancing by creating a separate kernel thread for migration.
Per-page hotness information was stored as part of extended page
flags. The kernel thread then scanned the entire PFN space to pick
the PFNs that are classified as hot.

The observed challenges from the previous approaches were these:

1. Too many PFNs need to be scanned to identify the hot PFNs in
   approach [2].
2. Hot page records stored in hash lists become unwieldy for
   extracting the required hot pages in approach [1].
3. Dynamic allocation vs static availability of space to store
   per-page hotness information.

This series tries to address challenges 1 and 2 by maintaining
the hot page records in hash lists for quick lookup and maintaining
a separate per-target-node max heap for storing ready-to-migrate
hot page records. The records in heap are priority-ordered based
on "hotness" of the page.

The API for reporting the page access remains unchanged from [1].
When the page access gets recorded, the hotness data of the page
is updated and if it crosses a threshold, it gets tracked in the
heap as well. These heaps are per-target-node and corresponding
migrate threads will periodically extract the top records from
them and do batch migration. 

In the current series, two page temperature sources are included
as examples.

1. IBS based memory access profiler.
2. PTE-A bit based access profiler for MGLRU. (from Kinsey Ho)

TODOs:

- Currently only access frequency is used to calculate the hotness.
  We could have a scalar hotness indicator based on both frequency
  of access and time of access.
- There could be millions of allocation and freeing of records
  and from atomic contexts too. Need to understand how problematic
  this could be. Approach [2] mitigated this by having pre-allocated
  hotness records for each page as part of extended page flags.
- The amount of data needed for tracking hotness is also a concern.
  There is scope for packing the three parameters (nid, time, frequency)
  in a more compact manner which I will attempt in next iterations.
- Migration rate-limiting needs to be added.
- Very very lightly tested atm as the current focus is to get the
  hot data arragement right.

Regards,
Bharata.

[1] Kpromoted - https://lore.kernel.org/linux-mm/20250306054532.221138-1-bharata@amd.com/
[2] Kmigrated - https://lore.kernel.org/linux-mm/20250616133931.206626-1-bharata@amd.com/

Bharata B Rao (4):
  mm: migrate: Allow misplaced migration without VMA too
  mm: Hot page tracking and promotion
  x86: ibs: In-kernel IBS driver for memory access profiling
  x86: ibs: Enable IBS profiling for memory accesses

Gregory Price (1):
  migrate: implement migrate_misplaced_folios_batch

Kinsey Ho (2):
  mm: mglru: generalize page table walk
  mm: klruscand: use mglru scanning for page promotion

 arch/x86/events/amd/ibs.c           |  11 +
 arch/x86/include/asm/entry-common.h |   3 +
 arch/x86/include/asm/hardirq.h      |   2 +
 arch/x86/include/asm/ibs.h          |   9 +
 arch/x86/include/asm/msr-index.h    |  16 +
 arch/x86/mm/Makefile                |   3 +-
 arch/x86/mm/ibs.c                   | 343 +++++++++++++++++++
 include/linux/migrate.h             |   6 +
 include/linux/mmzone.h              |  16 +
 include/linux/pghot.h               |  87 +++++
 include/linux/vm_event_item.h       |  26 ++
 mm/Kconfig                          |  19 ++
 mm/Makefile                         |   2 +
 mm/internal.h                       |   4 +
 mm/klruscand.c                      | 118 +++++++
 mm/migrate.c                        |  36 +-
 mm/mm_init.c                        |  10 +
 mm/pghot.c                          | 501 ++++++++++++++++++++++++++++
 mm/vmscan.c                         | 176 +++++++---
 mm/vmstat.c                         |  26 ++
 20 files changed, 1365 insertions(+), 49 deletions(-)
 create mode 100644 arch/x86/include/asm/ibs.h
 create mode 100644 arch/x86/mm/ibs.c
 create mode 100644 include/linux/pghot.h
 create mode 100644 mm/klruscand.c
 create mode 100644 mm/pghot.c

-- 
2.34.1


