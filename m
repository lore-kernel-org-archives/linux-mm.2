Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B557ACAC5A5
	for <linux-mm@archiver.kernel.org>; Tue, 23 Sep 2025 17:49:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1C4B88E000D; Tue, 23 Sep 2025 13:49:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 175618E0001; Tue, 23 Sep 2025 13:49:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0162B8E000D; Tue, 23 Sep 2025 13:49:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id DFD378E0001
	for <linux-mm@kvack.org>; Tue, 23 Sep 2025 13:49:04 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 98191BA1FB
	for <linux-mm@kvack.org>; Tue, 23 Sep 2025 17:49:04 +0000 (UTC)
X-FDA: 83921251008.13.6F6AC1A
Received: from BL0PR03CU003.outbound.protection.outlook.com (mail-eastusazon11012004.outbound.protection.outlook.com [52.101.53.4])
	by imf22.hostedemail.com (Postfix) with ESMTP id B3B7DC000F
	for <linux-mm@kvack.org>; Tue, 23 Sep 2025 17:49:01 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=YHC1oHhp;
	spf=pass (imf22.hostedemail.com: domain of shivankg@amd.com designates 52.101.53.4 as permitted sender) smtp.mailfrom=shivankg@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758649741;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=F937NWw09Hcn4DgbpPIs1W5CVMOH4s8rDaCGjvXFz1A=;
	b=Wvygve336fgVcKB33Ez8oERBkipxKilyt38K8nN/UlaOs0F4bTx/LF6BmMcT111uu8iK9k
	KF4Huv2Er/2CVxcmGLgjnlkca1uFQuUskQHr1sAkoDzXK5lHsZ2OyWFRVx4gGTY7iX6Bwj
	oc2XK1/5PmhibGo4rHL2jdZnLwPGRpo=
ARC-Authentication-Results: i=2;
	imf22.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=YHC1oHhp;
	spf=pass (imf22.hostedemail.com: domain of shivankg@amd.com designates 52.101.53.4 as permitted sender) smtp.mailfrom=shivankg@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1758649741; a=rsa-sha256;
	cv=pass;
	b=JXK9cCJdOcFTl+Bm9m/nP4+ZxVXXc4YuEIu/8DAwQjGKtvJhuDLnDhnQJHtD4reDtx/wiK
	Pov5icteZJwo14X3l4KI0W915anD9BzwT/0exfRF5MCJdDP2AVHA+o4V/KREKnmKHddHae
	wATKCpBUO7cMLdh+aaJpYEyfsAiw3YE=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=UPMZMmedeerN61QKWBvGNOI+2+igyItFxuezchOcAe8Gmr4LlUiAVTfKlMq9UPm21OavIjY1RngreEAxZxDdOz/LJnY8YIan+086GoL8JDyGkLLOK7usRTmfbj0I3a+N1Z3GESisRe6/cg8CuYMkA8mOW4Z6umQ91JDkabEMMgN5zeJgDR+nJOa+x8FaIqHfVfOAKWvhxl37DD0D5YS4pQOaTTfq4CtLSBLPCR4CWBt13BpvPp4uQFAwz6TPtviDcEP4OmH6oOUL/azei2/mWByni8SuAr+n9JJqc/m0r6HilTo605qD0ecjKO0i9KNmDSxfkA89G7Lzc0QtqpxG4A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=F937NWw09Hcn4DgbpPIs1W5CVMOH4s8rDaCGjvXFz1A=;
 b=NH1pAB8xTvvcrZwxrB7LSYeBil1QnZerNIFCJql+iKROORY0Fr5Xa+xYyX7xxBmFzem6VQvWECsr8CiOFL4rqyYU9f4wFlf+UAsaRi2ICSCyQr1dxsCdY5oVLHr2abB9OQ3pvD/+pabDNNKRZ04YelKZ3Mzdgqdk0eS+wKVbMMJBuJPEbXmn8NdVuOYCqPHiCrwP2zsMGuejlWZST3TFomoTTVCFJ2/3LZ8Zmfe1MLz7rA8NlIlaUMA/5h6gFEbyaNW54ds/9STXmR8CNr3yc45H+5ThWA1f2bdsRbso6VRfu/tNmtcj/wAqvf/yVs8nlEQixW6mHmrUrhSw2oMiVA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=linux-foundation.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=F937NWw09Hcn4DgbpPIs1W5CVMOH4s8rDaCGjvXFz1A=;
 b=YHC1oHhp/svdLX9TnTbYTE8T4d6a1LPVsRhPh945zz0gjiVwQiPcLibv9J32iMif1gG/VV3Me95z4Lo+foNdah9JKer0MTXP9Q/GlTjjeKxx4meOGNIVeKO3QSPoxo7atIlkkkL5HAz/8fJ/Nk/KpXIlS9Wl8d6JK/0nsL8vYzc=
Received: from BL1PR13CA0189.namprd13.prod.outlook.com (2603:10b6:208:2be::14)
 by SA1PR12MB8967.namprd12.prod.outlook.com (2603:10b6:806:38b::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9160.9; Tue, 23 Sep
 2025 17:48:57 +0000
Received: from MN1PEPF0000F0E0.namprd04.prod.outlook.com
 (2603:10b6:208:2be:cafe::91) by BL1PR13CA0189.outlook.office365.com
 (2603:10b6:208:2be::14) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9137.20 via Frontend Transport; Tue,
 23 Sep 2025 17:48:57 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 MN1PEPF0000F0E0.mail.protection.outlook.com (10.167.242.38) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9137.12 via Frontend Transport; Tue, 23 Sep 2025 17:48:56 +0000
Received: from kaveri.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Tue, 23 Sep
 2025 10:48:47 -0700
From: Shivank Garg <shivankg@amd.com>
To: <akpm@linux-foundation.org>, <david@redhat.com>
CC: <ziy@nvidia.com>, <willy@infradead.org>, <matthew.brost@intel.com>,
	<joshua.hahnjy@gmail.com>, <rakie.kim@sk.com>, <byungchul@sk.com>,
	<gourry@gourry.net>, <ying.huang@linux.alibaba.com>, <apopple@nvidia.com>,
	<lorenzo.stoakes@oracle.com>, <Liam.Howlett@oracle.com>, <vbabka@suse.cz>,
	<rppt@kernel.org>, <surenb@google.com>, <mhocko@suse.com>,
	<vkoul@kernel.org>, <lucas.demarchi@intel.com>, <rdunlap@infradead.org>,
	<jgg@ziepe.ca>, <kuba@kernel.org>, <justonli@chromium.org>,
	<ivecera@redhat.com>, <dave.jiang@intel.com>, <Jonathan.Cameron@huawei.com>,
	<dan.j.williams@intel.com>, <rientjes@google.com>,
	<Raghavendra.KodsaraThimmappa@amd.com>, <bharata@amd.com>,
	<shivankg@amd.com>, <alirad.malek@zptcorp.com>, <yiannis@zptcorp.com>,
	<weixugc@google.com>, <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>
Subject: [RFC V3 3/9] mm: Introduce folios_mc_copy() for batch copying folios
Date: Tue, 23 Sep 2025 17:47:38 +0000
Message-ID: <20250923174752.35701-4-shivankg@amd.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250923174752.35701-1-shivankg@amd.com>
References: <20250923174752.35701-1-shivankg@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: satlexmb07.amd.com (10.181.42.216) To satlexmb07.amd.com
 (10.181.42.216)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN1PEPF0000F0E0:EE_|SA1PR12MB8967:EE_
X-MS-Office365-Filtering-Correlation-Id: c91e2cb6-d07d-45f4-97f1-08ddfac9784b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|82310400026|36860700013|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?BbPDQlXucdIkXrAu8tG+tfxjVJjnxbhr2+iLh1s/eb3aSC7F/EotoIQmRu+r?=
 =?us-ascii?Q?rM6vtVLy+AuLIsKZONDjn+bv1gtI4gHm32c/XnN7l+Ec8xwjiwtLxm61LyzH?=
 =?us-ascii?Q?zQuDYxHyPsI16Mpgt0WtpHc+pSRgBVm+3vKs7XE3TcbmSBeayU5XQ7h3SGBG?=
 =?us-ascii?Q?pEUo4G0TNKAjmj25+z/BAAA6MXCU+DrHSyMOwaAZL6b4PEZYnAZ+O5TZGiq7?=
 =?us-ascii?Q?/si5Lo8B+aC1ZWAK8LPEAPRwZGbQBSAlJDB4VXOkKIuPNyvZjkUpxy04Cp/u?=
 =?us-ascii?Q?JWHJuBZIg1eTlHbYZycuuvOkc7WvSwy7xiL+RYHu7vmJMDfI6XkiM+Lw0Dac?=
 =?us-ascii?Q?zxDQGa1NTGWNpGWRdeWwCa60vr/+LA7iMES29udMLJJO8X/NmfmlYjXJOcf+?=
 =?us-ascii?Q?Kal3UycpvCCeIwwL21/Jikphm32paPFAwHpRFWMc5A80S+Ij29GTBByMdSUT?=
 =?us-ascii?Q?lbC/AC/ozyTvYEOW21mEqVvFY04uKiOUQU4/mDxvczYcifNo/imP2Aa5CQHN?=
 =?us-ascii?Q?re04nH0x7cNydVd4SEJun6HGPNFXykLPn4DlXVfExWRrdKUibkEgcW1Nwier?=
 =?us-ascii?Q?ZDXbuRSvgl1a0oeHOYOt6NUvxtklfPbEJ4C3jMkMQUnZ3kyJ6ZifsIx7dfks?=
 =?us-ascii?Q?Akg1rr8jvjndZ677CMWc65WZ23yo3Hwo5RbjKbtpBdmkuvKw+p51j6JtZfkb?=
 =?us-ascii?Q?KGXJnEyOc4caevp3RVYRBNLgjuYhVN8JCo/pSmrXQ78jSADuv3grbe84ETRv?=
 =?us-ascii?Q?l3L8lZQYzUXesYgx6tKBZa9cRFeQQDyhhd18xWpFji+X8jA3TJgvTkXMq5zK?=
 =?us-ascii?Q?/k1T99XHZ8mFHVdTQi61x0+nngblJ0qFcqvbBdQhyOLkaE7Uv5C3vVBCOYMB?=
 =?us-ascii?Q?P2patumxBgWUEpL4McXj9T0UGcv5pnDqIgEOGPC0Ssmmk/pr8CiYCXwokY4P?=
 =?us-ascii?Q?pQvHzb6061dzyU2IJXsqG06ottDq3rQ0zIhQ7uhl/4I3cBxP+Y0b7tsIQkQV?=
 =?us-ascii?Q?3+SwZQmLiieZxeqTlsVzhjrRpZ2nj4h3oE22IjPmHo/3SaTl1DuEC8wFAbBF?=
 =?us-ascii?Q?kTnPuyaSQktYa4vnipIwqoC2Z69RNuPFkRmBsJdN4DMvOQ5sXTO+5BrJVC67?=
 =?us-ascii?Q?BIrPhSOqiyJ4e9akNMcc7CA1BAGWpWSo4qdfI2ekShxV/hoIOz3nPJzxkq65?=
 =?us-ascii?Q?XK42Mk0WlabyXzveI0+Hie99mbu4/145QO4pkGviq+yqpJLBB8vQZfC0UO5N?=
 =?us-ascii?Q?7tSXNVRV6jh9A7KRUN7KEZxoKpJoDgkyK9n5Ol6zQAzDF/bq8FQD44yTkmc2?=
 =?us-ascii?Q?HxMBXJtxbirtBgLq1kzUPgPe17smw4JGJTIRzsO6OHWtie1Zfbj6Z/3xwBcM?=
 =?us-ascii?Q?9nylGpMEK53agXzVQMLFbswFnvWVhbe67+sZsTn6MbgGMSGqTEsOU7jgwi8z?=
 =?us-ascii?Q?nlYYM+zt904+aUyJI4En2t03C+uqMEHJhHPMUciY5DHH5F2N1nlpneU75rCa?=
 =?us-ascii?Q?6UU0cRtU2bCPcnYg1gnSIUuRgMdfO93l6E0C?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(7416014)(376014)(82310400026)(36860700013)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Sep 2025 17:48:56.9635
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c91e2cb6-d07d-45f4-97f1-08ddfac9784b
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MN1PEPF0000F0E0.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB8967
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: B3B7DC000F
X-Stat-Signature: qnd6acjyuadkfa6kxid1medpo7pnzjbm
X-HE-Tag: 1758649741-720117
X-HE-Meta: U2FsdGVkX19WiR6e5wqtXZAs7HzG/o2Qwslj+crtu/fbAET9wfb8yCUyvqV97xjJI+UFbW+TEJQf/AITW8TgB8JCHA1HLlYvWSaIE5XONYiAM6YbwlCqSLH73hGdfnHIKC/ZJI2uDRBsxeRRjTec9auo+80bGZQKuqHRSSdSmR6Jp9Hf08WG5UwL+/4bIbJ8s+kDWbFdSgwUwyhn9NYuD0ksFhx1F265L1iK/lBUTbI7YJXzLvdTKK97AbKymUDOvnxwBnnSfcaeJPLHe2feXAUKnPMrmu5NZ64MMyqqCN98DNJmrtifhRD0snfrh09dCIutqcwTA+o5xqJqdI23X10RT4CEYoLMrMkxKea6QArSBedAgdpfi2kOTJPXuv2lbZz3QaEQCqUD977SATTmv9SCHAdqOr0WthRovXpsKz9nZhFyp7nxcJ2IOyKLIW2YvJYbGwfXSLJbGqKKz3GezWi+mx4TaMu0cdSgJbk3tqOQbkS3rjM/FbySnFm8cSSmdJ8SjydNancI05o34Q7c3RVxmtnL44GAMu5ZCvglV7LJ/KZ4IUbODk/0NawVH4nYJANOuEyVdOZtl0c++z//9qS0nNVzBjTJij88MF3IJQEXF7T1UDTWXGukKZrym5QffMoBU9FQ7IFDeGLzCvyEjbnz7WKSOHPYxbk1+AKZz6Om9wkD+qsnDa9eN2Q2omB5K+Ws/k6ebYnk71rCU2LUkPHBxWCGBIxQII6ujrGaFx6MNyvZAA9UM8dvwsmu96di+dNnrNoN/4gMcsAjXXobT9DurwszJHaz1YpCI6GboAoBOHJ+Fsp+EK61ThqX/7KnePTw4cCWN2xztKyl7qJDP1mGGrQX+n3hM7fabJoZrMPw0tWEnrpIxGyMAyvH7uyVdPjJzOizrh6LKwc+yQSbPoZeT6dtq3HZANhpxq7nE2CLb9Jv62QvCyenRq7E9H7C+gM39kjuaMUOGYZqc+O
 QPNpL0qc
 9r9rGslO33hEDsginZeYcGCKhObc3fZZJQE3bVAzNrGrMM/wGs27DZg1zwFhDCkN05mWesIvdAOc5+dNKsujlycpEj3eHGB9C76RANtaMi2k/SmtBuagcpI13oykiNesFL8NS69c4qeJjya6giNf1fZyQbRiejUQUQ8yPvQ9wfx6BurXGuoaFuAQqPuhOdnN7EcIwihqF9c3N3g1iIu0lyZVE3LMWh3guUAstxdbSvb8eP3U6tHzh07EPX3VZ9aVOo4xuKzhM+ahwf+sZ/UDzvV46FoDeC9sYm4UUBQVexHMTMkxoG4nA/VfqgNwrXoYg0w08ybM3ZzwU1OZKSAy+pLT1asSo1zTWa+a8UiId2Xm1lpMj4S9Vh0ufDdUS45azI6zGKTq6s2+OqikLXXomP1vrQDaADJA9KfgMp6wvueOvyqEIBUeKs01rnidqFuFqSOcXDu+5aavZVZWiWl37txR2GQYFhuyfz6/l07JmU14AbS1ozHCrfExTYZwgIJ7mQonuYHMKY3uLKxpThkCJ6Z3AqF6u2BJk9RFFEOjqNF8LYeQurGjLElsVrQAU5jqoryc8oY3nrml2PlzkQ7WK4+R3bgjZnlS6apPDSmVbZCGBjsCaTQ9dDhlZnqi9s+Qw61X94L9TTRvQN3UG/dqQSNVvIwR2g+mqttK2c0NUHVj+lkLNLjkVXc7Z4T6oqGN0omcZIXEIE5WkDgC8b43YnY3BI2H+l43U0jcFQWmmY+xdCkIW2qbkwF2c6w==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Introduce the folios_mc_copy() to copy the folio content from the list
of src folios to the list of dst folios.

This is preparatory patch for batch page migration offloading.

Signed-off-by: Shivank Garg <shivankg@amd.com>
---
 include/linux/mm.h |  2 ++
 mm/util.c          | 29 +++++++++++++++++++++++++++++
 2 files changed, 31 insertions(+)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 1ae97a0b8ec7..383702a819ac 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -1187,6 +1187,8 @@ void __folio_put(struct folio *folio);
 void split_page(struct page *page, unsigned int order);
 void folio_copy(struct folio *dst, struct folio *src);
 int folio_mc_copy(struct folio *dst, struct folio *src);
+int folios_mc_copy(struct list_head *dst_list, struct list_head *src_list,
+		 unsigned int __maybe_unused folios_cnt);
 
 unsigned long nr_free_buffer_pages(void);
 
diff --git a/mm/util.c b/mm/util.c
index f814e6a59ab1..2d7758f33fc6 100644
--- a/mm/util.c
+++ b/mm/util.c
@@ -748,6 +748,35 @@ int folio_mc_copy(struct folio *dst, struct folio *src)
 }
 EXPORT_SYMBOL(folio_mc_copy);
 
+/**
+ * folios_mc_copy - Copy the contents of list of folios.
+ * @dst_list: Folios to copy to.
+ * @src_list: Folios to copy from.
+ * @folios_cnt: Number of folios in each list (unused).
+ *
+ * The folio contents are copied from @src_list to @dst_list.
+ * Assume the caller has validated that lists are not empty and both lists
+ * have equal number of folios. This may sleep.
+ */
+int folios_mc_copy(struct list_head *dst_list, struct list_head *src_list,
+		 unsigned int __maybe_unused folios_cnt)
+{
+	struct folio *src, *dst;
+	int ret;
+
+	dst = list_first_entry(dst_list, struct folio, lru);
+	list_for_each_entry(src, src_list, lru) {
+		cond_resched();
+		ret = folio_mc_copy(dst, src);
+		if (ret)
+			return ret;
+		dst = list_next_entry(dst, lru);
+	}
+
+	return 0;
+}
+EXPORT_SYMBOL(folios_mc_copy);
+
 int sysctl_overcommit_memory __read_mostly = OVERCOMMIT_GUESS;
 static int sysctl_overcommit_ratio __read_mostly = 50;
 static unsigned long sysctl_overcommit_kbytes __read_mostly;
-- 
2.43.0


