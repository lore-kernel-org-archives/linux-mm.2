Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A4113CA101F
	for <linux-mm@archiver.kernel.org>; Wed, 10 Sep 2025 14:51:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0ED8E6B0011; Wed, 10 Sep 2025 10:51:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 09E2C6B0012; Wed, 10 Sep 2025 10:51:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EA82D8E0022; Wed, 10 Sep 2025 10:51:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id D5F2D6B0011
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 10:51:17 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 91764C0993
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 14:51:17 +0000 (UTC)
X-FDA: 83873628594.06.862A622
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2078.outbound.protection.outlook.com [40.107.95.78])
	by imf04.hostedemail.com (Postfix) with ESMTP id 9BED440006
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 14:51:14 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b="XF4grmu/";
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf04.hostedemail.com: domain of bharata@amd.com designates 40.107.95.78 as permitted sender) smtp.mailfrom=bharata@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757515874;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=knSHZCfhdhbDF6/qJ3gVhvLKAI1MjwZVSMnVS3xXk2M=;
	b=oTFwuF5wgl3YkJZPY/c+ZuMpYQ0msetUBAo41+qVxqRNozL0Q9DgweXmHyDrQSAOyUOlV8
	G16bwEwPtcfqCmDMqx5RzioKzpKBHJyManGkaypkQko8z/7jyFCauwGGuOB4NrNp6VmltF
	wAMDw3W59IPmSiJFnEPLbHr3ELQHgKc=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1757515874; a=rsa-sha256;
	cv=pass;
	b=MwRYwGIe1hx5C9RiEbsVOUSEtwuxDLthBzTavPKZczsYVWIxGXmbhoMVndmCxIvbCzmIuA
	YJGD0votkf+twvIeZrnSj0rbtsPlhag8Pv1r01uSuGb9TI3Lg6MxoSbvZaWS1JV01wGaYA
	EbsYCrJyDDA5YT91tCrN0m/BET0LjqI=
ARC-Authentication-Results: i=2;
	imf04.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b="XF4grmu/";
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf04.hostedemail.com: domain of bharata@amd.com designates 40.107.95.78 as permitted sender) smtp.mailfrom=bharata@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=VYh3T6fxx5v+TGt0x3qOEeZjp32TbLZ3ce3NIt8pjAgOKN0u8r8sQIt+oeevp4kkj1c4/Bxrt6PFty3RWI5kj12tSy04fVZx2CDUSKgbx+A7FoA7Fx0d3QxrhP1/qFFmcadnN3U3r2E6SXWrn4NxJWqvOhieVA0Dz+BHLR0Rv7rUz7BCCd6tZGI/6uCoeSpZFrUNgp4jutcnJ3KrEeCWl03hPl4vOKyX0uMrNfPUK2eD1DC//BS9lNeOo4fGTyf5HpgMJDyiUnEcv2vz9DPpYg4cuPw3T0VeInIZ1hq8OsNVWNSPjaKRFxZnq6fIFiy8ckJr7502cYbaIFUtPGs1OA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=knSHZCfhdhbDF6/qJ3gVhvLKAI1MjwZVSMnVS3xXk2M=;
 b=Rsy3eaL3key1SzHtoZClKI3SPmWrAjFvM8XDvwJ9SBdVau1da4cBblSNNrOAtMCgz6YfhvZQ8oEP6jZ9rE7oEgttfAV1SBe2QIxlJms0Tqnby6JOdgtl3oixDinmjqUf4r42kGIrPCiFLixoLf2tTfNfF+bzVV2TGKFYsVDtd9mFt9qnmOGos4hOs2JDYlltiVZS8UH6Rp7YJDRcRchdQj2HNGHKSBWwnB66vhg0E+bOvpsRwHwhYlfLRGAx4mmzc24Af35cL5lEyQNeudK6Z4nJMk8vqv6A6ZkMIYukBIMa3PnoA+SY+q7bq5C0ysvjKUKVbkdoRE1lH1coD1uw0g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=knSHZCfhdhbDF6/qJ3gVhvLKAI1MjwZVSMnVS3xXk2M=;
 b=XF4grmu/xgr1ZsbVIok6DTWrvpLDUcEyPjJgKGM0/g2FKf2V2v53dGMJr34qhgYflMkaD8fXakN51ZQ8G67RoAj9ZbLpelDom1/x+ksaamHB4ADTqtDrt548AsdyH7wJk2krodAy0BuSmk68DPNPHjG2gAT6utPWGTaauGg7QH4=
Received: from SA1PR02CA0004.namprd02.prod.outlook.com (2603:10b6:806:2cf::8)
 by BL4PR12MB9508.namprd12.prod.outlook.com (2603:10b6:208:58e::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9094.22; Wed, 10 Sep
 2025 14:51:12 +0000
Received: from SA2PEPF0000150B.namprd04.prod.outlook.com
 (2603:10b6:806:2cf:cafe::22) by SA1PR02CA0004.outlook.office365.com
 (2603:10b6:806:2cf::8) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9115.15 via Frontend Transport; Wed,
 10 Sep 2025 14:51:11 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 SA2PEPF0000150B.mail.protection.outlook.com (10.167.242.43) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9115.13 via Frontend Transport; Wed, 10 Sep 2025 14:51:11 +0000
Received: from BLR-L-BHARARAO.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Wed, 10 Sep
 2025 07:50:58 -0700
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
	<alok.rathore@samsung.com>, Bharata B Rao <bharata@amd.com>
Subject: [RFC PATCH v2 7/8] mm: klruscand: use mglru scanning for page promotion
Date: Wed, 10 Sep 2025 20:16:52 +0530
Message-ID: <20250910144653.212066-8-bharata@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250910144653.212066-1-bharata@amd.com>
References: <20250910144653.212066-1-bharata@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: satlexmb07.amd.com (10.181.42.216) To satlexmb07.amd.com
 (10.181.42.216)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA2PEPF0000150B:EE_|BL4PR12MB9508:EE_
X-MS-Office365-Filtering-Correlation-Id: 2cfb6722-07cb-4bb4-6db6-08ddf0797bf8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|376014|7416014|1800799024|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?6qZKHOcMTVS6sOGB7TscvKQB9dkGMI+/4ZEo4mIqX1bm0jRkdbbLUpDh6eaq?=
 =?us-ascii?Q?SfklVTkos//orU8rGXAgJrf4Lx9T93vJ7W3ToEI9LdX6Lu8UMQDD7sOKPH5P?=
 =?us-ascii?Q?0/4CJDtfCjO1RWIs4R3FnARtwdXeS1qrfWT8Nck+EI8p5Oyh7cYJEQT5J26P?=
 =?us-ascii?Q?e362HYkbZIRU2KH4EcMyn/VYessndxc1k1E1S3vSSO/Yel0Lgbu3q62roavx?=
 =?us-ascii?Q?EhceuQROCVhgMzdRhNeQt/WLD9VJktHS+GKXHKCIRz1hIDqsv0+h/ayaMzNk?=
 =?us-ascii?Q?JXRj8rlE8LZJTXN7l0yhj+F6poxuj+/NHVJhoYX80ZmjMtNECelfmnR1eqld?=
 =?us-ascii?Q?zlKlWwS6PsNiVHy+fP2lnaU6xzc8Y047f70et5GYYlRH1cv1caSYpRPn4xw/?=
 =?us-ascii?Q?CyTJNGcpabT+b75x+haLYV6b1l8GLYcXVe7FfFgX0nJk8KQrcYcdR5Dcfi3o?=
 =?us-ascii?Q?Y7HYaXpQukYUpsaAVUPJQFCkbfJIZ72V2vOxNhUrHhD0hJSpGsuCw8byfcmH?=
 =?us-ascii?Q?+eQuTPwVNyhbdKd30a9kUlzgFwpkBUTfKPLP6G3I0MvEc/6Xw2+DMVeMUzFL?=
 =?us-ascii?Q?yv/Arg4JOM2lEBopMaKBiPm96LN+xQ/cnwVJDa10pSD3WXFd9On0JnAE0BPb?=
 =?us-ascii?Q?vx+N/uKLlz/BwyOa33+dtIvRbcXSuEb8i7phxk6X01OAcduVgU77VKeVipLY?=
 =?us-ascii?Q?G8HPOlnlA/PL+6fKFfls/JbczuiCrGIZmk2g+OUQyrkdRkyYgwUWTR6Ir5rr?=
 =?us-ascii?Q?CqesfHzJliM77uqENztXPi1WRB07cqP6FmrjW9YzrGQjLC+68pCzzG05UCTX?=
 =?us-ascii?Q?u4S82OU46C0d6ge8op6Q8BbKaqrfl/OEVgsjU3kLICaHLWqdis9wcOz5yqaG?=
 =?us-ascii?Q?K0wj1/ii9gVW/vxFdw+CvyjNMT1UGNclZIXCpnpl0sbQF+drX2hTe9rqH/CJ?=
 =?us-ascii?Q?eQZfYyt66DnePeYvksqDpdAFG/kj1mzY7kvdCF4CrwVaZs2iDRLsi7adDQ5H?=
 =?us-ascii?Q?6Rx7kAmcT3BE3UxQziycofGpaUPpms9nLJc1OWjt9/YU/QvAxPVSqrZpdbu2?=
 =?us-ascii?Q?Kcy2SgjW95WPUkYJMMvtSyykAE18s5qRbcsamfsTTqBqUpcwfPCelhNgM1PM?=
 =?us-ascii?Q?Q3gCYuVk9vOhB/ahiZr47uxf/KZ99ftBTnnYubRts0DRZwIG2caG3FhEOf1U?=
 =?us-ascii?Q?5KjURi3Y/WfeUoJoANNnbfYxizIN2Cy28/GLXbjnhqTSCRmKv13krTJRwGJw?=
 =?us-ascii?Q?U4VxRvU3nLjqej7KKvLQd1TGsmUju/C2lWtAhqQ/ZHt/kaxP0S9MZfHV4Lfl?=
 =?us-ascii?Q?DcmDZYNbjZ/mC6nynzcAqakv91k866/P7QmR1yj+4YlRYA5fe5oXC+66taKt?=
 =?us-ascii?Q?6C5eqN1Qfh+5b+1dzq8jATLQ9vNUpBDPfSqyCO68bqxdDzlamq+AZ7ie95z2?=
 =?us-ascii?Q?QR1MUblvdktTwpl+K1Ffayd2lxHXmQONJJnVOdfwruV9NTJEErU9KA/vCIC3?=
 =?us-ascii?Q?Pt65sFJlEorLKgRCRb9tyNJMpA/SlbjYD6SR?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(376014)(7416014)(1800799024)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Sep 2025 14:51:11.7401
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 2cfb6722-07cb-4bb4-6db6-08ddf0797bf8
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SA2PEPF0000150B.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL4PR12MB9508
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 9BED440006
X-Stat-Signature: k9qcomzxqykpukbjq6k1i86tnsbr4qaj
X-Rspam-User: 
X-HE-Tag: 1757515874-513452
X-HE-Meta: U2FsdGVkX1/KdnpFNo2pXiIvu84iXTYz4aS44p4CH7y9/zJqTb71i9GEcroSRDBvvkBSiYOWR0UgPlYugy9Yld0gCx1+Aize/dLwwbQlWNgbUx/4303D5sqUwN6fASC888SWFWYaSZHNQ33/S/epqs2d92qCB07eD/tDs+wlyiM1XypJC3iL4/Sljdz//5UgAiAyS14RBBH8KVNgdEIJQNll+S1WOxZeWp2vYicFAOzVClwkfCj1CEWwoRvLNZL9gxfR5AjPn0Kl7P0Aebc6BAfZs0ROEUd43xsDlR2n9Bh937NANjeu/mbsHrkjU0AWU36a7pm5p1D41Kv0iT1mg4vV+rUmO84gpTF7g8l370O6MI8qU9hI50Es+tNhk/fsge8Cievt2hb4Pv8loUUpiaUZtG+tknalx959kdtjRkiFFHnUgvR06iptsnStlfAO0CKamPkB2aNSy0dOFKRvJtvy5P65ptMmfkpi/aeYG5e9gmSRMqsxB0ih698D5G/ZAawNdIjwzZCV4uKcUuF+XZEMHYnMCi/DZwOdsV/M5ylUvP3Tj7+9a2sVEeVHukzjpGI8BbLf/+WQJEO19iFqb4ktfuYoCCptgM2PZzXE36ygVTPw9UmIHOkarmxiTHNBrsKBLXD4OKRzq5qdeyb2DbwAjwBAGRV2VCJY6rfPgVi4kCzrcRYe2iEU3CbkC+9RTXLt8aEPqP5ewW6HMkFycCsFnyQ4X0VdSUByYJVUTq9COaP0bOohSlQScHLP1O+5FyFy6SG9Z5Q2cthvRpK/vEdc4LftqYc2FjHvhQIeJIwXymTmZOvi5R1z4iNpHjeAfKgU33YzrGLL6OzFClmWFBmwqxLtXDKJxg7Hp45qDacymwPgaztUwC5f2f01XJPE6ZYX0PBEgaY2O6rNjkAcR1ekNCWLv57ZEncZM28/6XE7+kgv4tYuQJ32hbWZkXu0A3qlC21xiYcJhDBbYAM
 ByJn8NGE
 ee34yRdu4wkcLNjf9O1/lzYQjk/AA2WsKLrYbCCC/cLKUvkvxozOWfSwccB7RXG5zrbFvEcDBRFhUCk24NyQ2QNG+XYxkTpCpcGUIM2R/DApy3KnEiMV1DHCbeX3r3ik+fBwCLa1y60MJ29+d8sKP1XIZvZMnI15XuENZM22EcLFb9KobXdgozwN8kbmaadtQC6V5WPGVnthLTUzb0yPtdQ0eOI7N47gh1Tn//dSpcgt7pJS6/mWLmn2xeR86EyLSYq+Hr9GTcaGo1tbZmgCqWevL5J+oG99WSRyLPaU0qRGKP9jtSTulGTGR29hLzlU0xbkzTUYtMbHhEFkVMzEIl5sBduDM+OVb2hb1S4i9oGvIcxGZT+7BjmtwkjqiUlpc6g1MwZSgpMpiSZNk8i+8yvTlMBABdwKlArQEvbNSul/15NatPtIWJRCt2us4F7kDEjYxKVGkeHKG5HvGk+vC9pWH32fISSrIeSNjVAM6c9PWNAL4X6C464Lx0D/l4gNwzMzJnVN91yuT/vnrHMLW/NP5jJFRUKA+Ijy52Fv0UWmP+GIUX0DoyhW3WSgbzOjErv87LS39KkOlgrH3qkAGsyzHCgvPUrIu6tguHi/rsE/UsWciPcBvG6oTAGSgmGFP6EdNwSHWsOIqM46akKqkWZ34leZmbNnjK5oau/NYVvoJGQpKWAKj8ycfjEpfjS3/LZVPB4ogDtaDre4j4MyVa4R4Ng==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kinsey Ho <kinseyho@google.com>

Introduce a new kernel daemon, klruscand, that periodically invokes the
MGLRU page table walk. It leverages the new callbacks to gather access
information and forwards it to the pghot hot page tracking sub-system
for promotion decisions.

This benefits from reusing the existing MGLRU page table walk
infrastructure, which is optimized with features such as hierarchical
scanning and bloom filters to reduce CPU overhead.

As an additional optimization to be added in the future, we can tune
the scan intervals for each memcg.

Signed-off-by: Kinsey Ho <kinseyho@google.com>
Signed-off-by: Yuanchu Xie <yuanchu@google.com>
Signed-off-by: Bharata B Rao <bharata@amd.com>
	[Reduced the scan interval to 100ms, pfn_t to unsigned long]
---
 mm/Kconfig     |   8 ++++
 mm/Makefile    |   1 +
 mm/klruscand.c | 118 +++++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 127 insertions(+)
 create mode 100644 mm/klruscand.c

diff --git a/mm/Kconfig b/mm/Kconfig
index 8b236eb874cf..6d53c1208729 100644
--- a/mm/Kconfig
+++ b/mm/Kconfig
@@ -1393,6 +1393,14 @@ config PGHOT
 	  by various sources. Asynchronous promotion is done by per-node
 	  kernel threads.
 
+config KLRUSCAND
+	bool "Kernel lower tier access scan daemon"
+	default y
+	depends on PGHOT && LRU_GEN_WALKS_MMU
+	help
+	  Scan for accesses from lower tiers by invoking MGLRU to perform
+	  page table walks.
+
 source "mm/damon/Kconfig"
 
 endmenu
diff --git a/mm/Makefile b/mm/Makefile
index ecdd5241bea8..05a96ec35aa3 100644
--- a/mm/Makefile
+++ b/mm/Makefile
@@ -148,3 +148,4 @@ obj-$(CONFIG_EXECMEM) += execmem.o
 obj-$(CONFIG_TMPFS_QUOTA) += shmem_quota.o
 obj-$(CONFIG_PT_RECLAIM) += pt_reclaim.o
 obj-$(CONFIG_PGHOT) += pghot.o
+obj-$(CONFIG_KLRUSCAND) += klruscand.o
diff --git a/mm/klruscand.c b/mm/klruscand.c
new file mode 100644
index 000000000000..1a51aab29bd9
--- /dev/null
+++ b/mm/klruscand.c
@@ -0,0 +1,118 @@
+// SPDX-License-Identifier: GPL-2.0-only
+#include <linux/memcontrol.h>
+#include <linux/kthread.h>
+#include <linux/module.h>
+#include <linux/vmalloc.h>
+#include <linux/random.h>
+#include <linux/migrate.h>
+#include <linux/mm_inline.h>
+#include <linux/slab.h>
+#include <linux/sched/clock.h>
+#include <linux/memory-tiers.h>
+#include <linux/sched/mm.h>
+#include <linux/sched.h>
+#include <linux/pghot.h>
+
+#include "internal.h"
+
+#define KLRUSCAND_INTERVAL_MS 100
+#define BATCH_SIZE (2 << 16)
+
+static struct task_struct *scan_thread;
+static unsigned long pfn_batch[BATCH_SIZE];
+static int batch_index;
+
+static void flush_cb(void)
+{
+	int i = 0;
+
+	for (; i < batch_index; i++) {
+		u64 pfn = pfn_batch[i];
+
+		pghot_record_access((unsigned long)pfn, NUMA_NO_NODE,
+					PGHOT_PGTABLE_SCAN, jiffies);
+
+		if (i % 16 == 0)
+			cond_resched();
+	}
+	batch_index = 0;
+}
+
+static int accessed_cb(unsigned long pfn)
+{
+	if (batch_index >= BATCH_SIZE)
+		return -EAGAIN;
+
+	pfn_batch[batch_index++] = pfn;
+	return 0;
+}
+
+static int klruscand_run(void *unused)
+{
+	struct lru_gen_mm_walk *walk;
+
+	walk = kzalloc(sizeof(*walk),
+		       __GFP_HIGH | __GFP_NOMEMALLOC | __GFP_NOWARN);
+	if (!walk)
+		return -ENOMEM;
+
+	while (!kthread_should_stop()) {
+		unsigned long next_wake_time;
+		long sleep_time;
+		struct mem_cgroup *memcg;
+		int flags;
+		int nid;
+
+		next_wake_time = jiffies + msecs_to_jiffies(KLRUSCAND_INTERVAL_MS);
+
+		for_each_node_state(nid, N_MEMORY) {
+			pg_data_t *pgdat = NODE_DATA(nid);
+			struct reclaim_state rs = { 0 };
+
+			if (node_is_toptier(nid))
+				continue;
+
+			rs.mm_walk = walk;
+			set_task_reclaim_state(current, &rs);
+			flags = memalloc_noreclaim_save();
+
+			memcg = mem_cgroup_iter(NULL, NULL, NULL);
+			do {
+				struct lruvec *lruvec =
+					mem_cgroup_lruvec(memcg, pgdat);
+				unsigned long max_seq =
+					READ_ONCE((lruvec)->lrugen.max_seq);
+
+				lru_gen_scan_lruvec(lruvec, max_seq,
+						    accessed_cb, flush_cb);
+				cond_resched();
+			} while ((memcg = mem_cgroup_iter(NULL, memcg, NULL)));
+
+			memalloc_noreclaim_restore(flags);
+			set_task_reclaim_state(current, NULL);
+			memset(walk, 0, sizeof(*walk));
+		}
+
+		sleep_time = next_wake_time - jiffies;
+		if (sleep_time > 0 && sleep_time != MAX_SCHEDULE_TIMEOUT)
+			schedule_timeout_idle(sleep_time);
+	}
+	kfree(walk);
+	return 0;
+}
+
+static int __init klruscand_init(void)
+{
+	struct task_struct *task;
+
+	task = kthread_run(klruscand_run, NULL, "klruscand");
+
+	if (IS_ERR(task)) {
+		pr_err("Failed to create klruscand kthread\n");
+		return PTR_ERR(task);
+	}
+
+	scan_thread = task;
+	return 0;
+}
+module_init(klruscand_init);
-- 
2.34.1


