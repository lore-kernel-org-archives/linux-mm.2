Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5CF6ACA0EE4
	for <linux-mm@archiver.kernel.org>; Thu, 14 Aug 2025 15:34:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F1F2190018E; Thu, 14 Aug 2025 11:34:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ECF2C900172; Thu, 14 Aug 2025 11:34:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D970690018E; Thu, 14 Aug 2025 11:34:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id C1838900172
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 11:34:00 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 8CA50160673
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 15:34:00 +0000 (UTC)
X-FDA: 83775758640.08.AA50A84
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2074.outbound.protection.outlook.com [40.107.220.74])
	by imf03.hostedemail.com (Postfix) with ESMTP id 87BF820004
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 15:33:57 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=FU9e0qkk;
	spf=pass (imf03.hostedemail.com: domain of Raghavendra.KodsaraThimmappa@amd.com designates 40.107.220.74 as permitted sender) smtp.mailfrom=Raghavendra.KodsaraThimmappa@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755185637;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IeDzatv8nplj1egVMBXNqacjGynW1A8Evwh8y5ayuBw=;
	b=KWYQNOfhbR0ykSIilq+s5S6RDPq6UHHeR6wvQemosmMr/HA9hd8wIRMpwvOfU12SGJOTwG
	9LjSsBXjsM5PqUYh1ik70sjCcdIGPuG6I7lDFfBAMCsJ5lfVSlk6kU/TAWpJphwYxHtNQt
	8RJSEniRzWgnCLV8L7S6titR5BVywXo=
ARC-Authentication-Results: i=2;
	imf03.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=FU9e0qkk;
	spf=pass (imf03.hostedemail.com: domain of Raghavendra.KodsaraThimmappa@amd.com designates 40.107.220.74 as permitted sender) smtp.mailfrom=Raghavendra.KodsaraThimmappa@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1755185637; a=rsa-sha256;
	cv=pass;
	b=q3R0vHO1ENzN43KPQe56PNC9u5iWPgLTo2tsCGHSWQx/jwSCKO1nW3F9+Lp61T4uiFpI9v
	vdB1Ih3jEfcasiCvuOHNvmNtavDCSx2kNxqL3/Wzg3PJ2EZoiWhR8nPbKe+MpbcD0Q2HnT
	n4/bLO4sRVFaXRvmZF7mVyMqjQ1AVVw=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=CVV+kE2JtHYXWDAPfhxihO8glzcvGvR5Ke0rAb4S+k0hpOIsZjFFmSwfdNxg3bxPfpzkwC4pT3SBUWQ/c/rwZjDSgqSO/7zKHgm/yZAPf0CfDObhCtVz0nvZvWg2atjmSbNoft0vpsItGzVynIKL4g9mprTeRUfLoHbVb/B/vdTrzNv35v1pJDXC9tOxk+NUTbw4RzdmcCthwjsiMHCSr9O/RWszxeiZZrXSWpdaYmxsI9PTp/FFXtCFWCji7PhWnul2tyPFOfGYAnjb7BXozQn14Ce4Btx7F2HpgcupNceOnfNqPRPWPezT/z53nGEp+tUHan4jXDqcLrpW0aAwgQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IeDzatv8nplj1egVMBXNqacjGynW1A8Evwh8y5ayuBw=;
 b=FsSqbVIIUU45kMgt6EXT0OZL5hYWEqImsX7H81w+6Wk77i03MIyFPAqCpK1efAtxk9Eguay+kihZJMvjq2IRg9M4zyjVF8txnS4OfLGFrdnFCy2/YkPHYXfYOg1zPoV/M8F+YnDAGUzlRd7lnLZCKIh0inDR85o3Ac/wAZjuNGl+araumnKLqWQICvrpNvZYcJjGE1FEyphzyrm6iIxZdyNEFw4+GSyXyvQXjuFQV2RDIesPO/ROxcNhqCzD+TVoQw2GfmQ9rG/QMuyn8lxHj8h1SH7m/FKC/rmivk55hl/r46TpE0KIZLT21hpMIf/8MhqvnkH5bfPIbKhjQo4yvQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=arm.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IeDzatv8nplj1egVMBXNqacjGynW1A8Evwh8y5ayuBw=;
 b=FU9e0qkkKeUv+PIykVOz2McPHxRau/cJKEZ0KnctIAOWK5zvG+Gy6jpwjqb0Dde1iXM0Ch5QKcgCytuTItjRxyiMDKQ3nBRGqxjfwVkYY0tM0zdQU9aQNQ6fi5r0T603qTBfVOKd3VSgs8UH7XDO2MhS/i5d08yoxfc+aNrQUt4=
Received: from BL6PEPF00016411.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:22e:400:0:1004:0:9) by DS7PR12MB8321.namprd12.prod.outlook.com
 (2603:10b6:8:ec::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9031.14; Thu, 14 Aug
 2025 15:33:53 +0000
Received: from BN3PEPF0000B075.namprd04.prod.outlook.com
 (2a01:111:f403:c803::4) by BL6PEPF00016411.outlook.office365.com
 (2603:1036:903:4::a) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9031.17 via Frontend Transport; Thu,
 14 Aug 2025 15:33:53 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN3PEPF0000B075.mail.protection.outlook.com (10.167.243.120) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.9031.11 via Frontend Transport; Thu, 14 Aug 2025 15:33:53 +0000
Received: from tunga.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Thu, 14 Aug
 2025 10:33:42 -0500
From: Raghavendra K T <raghavendra.kt@amd.com>
To: <raghavendra.kt@amd.com>
CC: <AneeshKumar.KizhakeVeetil@arm.com>, <Michael.Day@amd.com>,
	<akpm@linux-foundation.org>, <bharata@amd.com>, <dave.hansen@intel.com>,
	<david@redhat.com>, <dongjoo.linux.dev@gmail.com>, <feng.tang@intel.com>,
	<gourry@gourry.net>, <hannes@cmpxchg.org>, <honggyu.kim@sk.com>,
	<hughd@google.com>, <jhubbard@nvidia.com>, <jon.grimm@amd.com>,
	<k.shutemov@gmail.com>, <kbusch@meta.com>, <kmanaouil.dev@gmail.com>,
	<leesuyeon0506@gmail.com>, <leillc@google.com>, <liam.howlett@oracle.com>,
	<linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
	<mgorman@techsingularity.net>, <mingo@redhat.com>, <nadav.amit@gmail.com>,
	<nphamcs@gmail.com>, <peterz@infradead.org>, <riel@surriel.com>,
	<rientjes@google.com>, <rppt@kernel.org>, <santosh.shukla@amd.com>,
	<shivankg@amd.com>, <shy828301@gmail.com>, <sj@kernel.org>, <vbabka@suse.cz>,
	<weixugc@google.com>, <willy@infradead.org>, <ying.huang@linux.alibaba.com>,
	<ziy@nvidia.com>, <Jonathan.Cameron@huawei.com>, <dave@stgolabs.net>,
	<yuanchu@google.com>, <kinseyho@google.com>, <hdanton@sina.com>,
	<harry.yoo@oracle.com>
Subject: [RFC PATCH V3 02/17] mm: Maintain mm_struct list in the system
Date: Thu, 14 Aug 2025 15:32:52 +0000
Message-ID: <20250814153307.1553061-3-raghavendra.kt@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250814153307.1553061-1-raghavendra.kt@amd.com>
References: <20250814153307.1553061-1-raghavendra.kt@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN3PEPF0000B075:EE_|DS7PR12MB8321:EE_
X-MS-Office365-Filtering-Correlation-Id: 87876250-7ca4-4c4b-d80f-08dddb47f9b0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|82310400026|36860700013|1800799024|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?kwDzxvcldJrH2kaFkTRZmr6d+ntqAxhZMCWS8d91DK0MsmEfpeHeAoQ6b9Wv?=
 =?us-ascii?Q?gcsyfz2xfhtxPt2UHPmdo//GUNgBp6anq3NUecy6aaeofcvKykR8oAaDdA85?=
 =?us-ascii?Q?0fHD1J2Lzn7M0iYF1k/2Ky/Is8RupQmzVB+1iaggNHoJjYcWTbfk7rRFlK8Z?=
 =?us-ascii?Q?Jcb6X5zEFHn2mPqf8+XpUy5OY0OhdkQsB4F9IDs1U5ef+qGpds0M00YZGO7/?=
 =?us-ascii?Q?42mbcX4Ab3ZGfq3MRXSsnZl/fOcWq5vhKqIuI8pJ9nGgffQ8tMBynd/ZC3wA?=
 =?us-ascii?Q?UG5lWR5UBocOshOaynx+I3bB78QtejW8209ukAsQI8mue/BUOvF5rtCcV0t3?=
 =?us-ascii?Q?3+17Ozy9e+bzYeeIBLdF9u4YSAAHo2x5T2Cd4pBzCReUY4wO6xmhQVPlVnj/?=
 =?us-ascii?Q?o6rAre0s0l00g9JSeSimt7ygO/oVnOk+5/P+BXKwUy41wd4IxQ3IGyQZLdnK?=
 =?us-ascii?Q?bCqRTnsCXzOMSbX33OatMMfZCealLs+it9ArsgFb87wUQV37lm4RnUHMDPiX?=
 =?us-ascii?Q?Db4KjsSlmoCNmenc00hgF26mVDtJZid2zC4xmI0+H7q54AMvCXcqbV96OXaE?=
 =?us-ascii?Q?JLTEkzi3IlRImi0+FzoYP8WMMai9YSo1CujeuiDVtssDKaVsUo82QXzyrpHN?=
 =?us-ascii?Q?3nqkrKOFOdyJHLOaRzreNGSIwMXHWJgf2QmtK4zNel4G8R2CkdLBJzcQxDgb?=
 =?us-ascii?Q?e7O9cRLEuyajIzS9cH8PsiEE4Ko0vknN5dibkG3W/locrV/LgnT7xw/2jP9o?=
 =?us-ascii?Q?3oi1Ym4fqyHjpI7nf8Iyq2RJezTl5EY3wgo+TP00AOw9dimF7WG0QDP6XvIz?=
 =?us-ascii?Q?AldP5kNn7xIz6+rP4QL5uJ/FzFthSF6DcC0PFwAb+HO9NcJ+oajUtQpm6r5N?=
 =?us-ascii?Q?Z51CQ054+3KQpOaCr/bnQo+O9DIwx+IPgpdg0bJ2+ePyQDyun8ORoW/trjgH?=
 =?us-ascii?Q?UKomDxDW0TkqL356CKh1etdwauTlaEDwR1mlhVvcytAq91FhvUKBDitkxahk?=
 =?us-ascii?Q?iohwmHBOJ2bZH3nftxW1UbiPlUmjJiT74ISywcKfm1RedlF7C3YF/fPIFTfw?=
 =?us-ascii?Q?rGvKu6Cf/+7kmvH493dNWPO7jCKJjb2A3TZ8Y2jitf6UMzTggnPPGTSMxXss?=
 =?us-ascii?Q?4u4ZqIAO/qnnbDHkEzZrn2j9Pfk4opy0ioHyOqm/Gf5Ifk/apCW8C7eMiHRE?=
 =?us-ascii?Q?jp6D7aTcQYok/x6jhmd14fIf1LrLpwcL9GkFExrjR2JD0Iw483Y9Axm/IyB0?=
 =?us-ascii?Q?N8hlPXCVEEIGh76ukfecBZF+UlccSaGh2a3J1Ufh7Ld/7FJNMspdrPV79frM?=
 =?us-ascii?Q?BKNXVEXuKY7etn50tqNL3fXQCqfUw3GiDj751xMV78YVOMntR5EdQDjU7Fr1?=
 =?us-ascii?Q?odzNdmcEV2V61GdbeN0693HTL8FZimRsjqyu1u/QnY/3bok8150QX1LrscKm?=
 =?us-ascii?Q?3hChAgT64qkkI7dAQphMXPDKY/Tv6jFi2nuw+sY76bb3uqP/laGbYECvHS3c?=
 =?us-ascii?Q?tSpGbp0UFgng68Zt5iVFZFJeU0CObVT1l0mP?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(82310400026)(36860700013)(1800799024)(7416014);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Aug 2025 15:33:53.4326
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 87876250-7ca4-4c4b-d80f-08dddb47f9b0
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN3PEPF0000B075.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB8321
X-Rspamd-Queue-Id: 87BF820004
X-Rspam-User: 
X-Stat-Signature: r4d3dgt35z1oh3tx8dgx9sh811yze3n1
X-Rspamd-Server: rspam09
X-HE-Tag: 1755185637-669917
X-HE-Meta: U2FsdGVkX1/rzEIRtKq8mpH6fRbbY5czaZEnUFyqIg2rBMUqEcnESLmw+kYeIhR83yumIXjWtEGqvbuJ4jETdTT/t0LcDKnByrGsAThQ5dBGzQqDj2ol+giu6qObYWli3Hc9kQOUKUnMqW+PQJZQOnKlzHsc3ReQ71sj344Nz1wE5kjC+kLDmOIqmJkEiUDC+I25esF4YzvOxEXtdpeboTvKsHs32GtcTdbgKD9YUt1YB27dqDQ2MTPCq4G0WP0hgMk4pRtU+ifTQdfE1DA6zkcKYJheieOErXgRTxuG2b1703eh62jHtMsvNQhrMo+8IqcIsGgr06WT4lJAstM+sapbjdx1tAzqLoXc0z6qZgz/L7L1ZEl27IZBfOgyXAng3eYv0yvB6kwNiNbnKGvDNxqLY55whK5Ygbgok0L1a+v+t61PFVs1pSG1FjCxoOxZmSV88mUkHAt0nYpA7J1h6xtZ+h0PNqpQhBHrYpXMT5zz8JbhOaMiRuE0AO1YtCLl/5uPWKtllYNz2nC+Ti32VKFh06mTCNfRx5ywT6gFprGRoDZW3rEzx6BcLw7PguXIo+9VxNklgRVNjs8VlElxmFIkHavNcujiEwGlXu5xTZU8ehn5FaSYNEXAW2ppAS0gVU4/HvDdA313BCsJGpgWSL2usQg++a/bbZuG0ncdAIZllu9IGG83Y/1o+Qo0ZrzHfVgaHNQNZDfeeYLrNfAKud3wDZvzOFFzKTCxwAm83lcJ080SRhqjaj6pvQNyLUsdPjGJNeA4bFsc7vEbqx4dmlfDFjCHmY2mSKAmcT1D6XfFJUH8kTLZRwASrEMy4PzkjToIBLCHcWCmdwuWf5869pn7WLhXmCXa7la984prsmFyhUmTZgjcSFVBVt1/Pifb4WfDI+hukhqUm7dZXG18nVYPw8cWeXejBjSQjgQyY6l3Nmqcqo91UX/n0garbNtkiF43/sIsptxzZyUCrHm
 XoDF3tfk
 /rGKOXcFu2o601xqwbATb0R3CWqV0fG3Fj0WEk93KBuGl64jOO/SZv/HnehhWMA+HemvyosC8MMFmja4DE8sG0lCLF7lInVs8b8YqY35UMYNT357W1dyMSopWjwmz4nepgQGNiAUXBtixUZSqXW8qYYwNzWCnBFlgOPMgQ52OIV2rY0PlP7XRMmSMbsRlFZ1rQyIkmjwnFiFEQEinctJFmxnRBNQ+uBnrDEhDaqaiQCXC6/0JvqbJndnNAezcehNV/U/6Kj2SZH+Sq5Pdk4vrethYhaE1px4e6cgKTzzE/V2ocX3Aht7ohmpUAadIM17eqjXIlWjybNdLPnoY7xCG46GRuHcoDQPVRjJ94xshIax45OQSNiEBedxMOFDDkXp/Fe4tztRnIAx/mCwILXpiBpHOc3tNypKAxS77w98ZqFDX7QmY+nbSyPTTkQgbFDMx5xe+hNALian0jWDpsfGBCwn1rTtYEDda+s+VjhofBfOFnek9Jmj7PfbKpA75lxG5asYRu79mq6tNreqRjr62n92PDNvUfh7An44JgdzQtL1gSY2B9Xn35DakZdCB+f4mGIwsLAAtEkj5t7tzOPsRS9XEe/vJc/HUivmNQyIkSFGj4Ee61mcjvXaZXJvxh1Qe63ga8Ir0xhw41rulfqS87OZ3AeeI3U5HqiynssTMXoXYTDLOIBXGf3zEcDq+1keuG5Jg5p1wdRqaYYQRGQDW/jY1Ej321L9B3gfiGpUeZhQYYUcamQSltQMhjqJX6jlLMy+tuIgo1aFf2qSdR+hoESLh5PVFiIQU6Sm3/GMwFGyBCFWEgZ8MkUpIfYZPKQ+tPhE50bhjrMIDYLHQdvq9W26Lld9oUL9aFhiZc2kyhEqg0iOefIbWNjAUua5XlZVct/MvNTh1fvuUKj2Ae6bp/cRg26jamoNGBENsnkO3XnHOggsDi7EqTryF3g==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The list is used to iterate over all the mm and do PTE A bit scanning.
mm_slot infrastructure is reused to aid insert and lookup of mm_struct.

CC: linux-fsdevel@vger.kernel.org

Suggested-by: Bharata B Rao <bharata@amd.com>
Signed-off-by: Raghavendra K T <raghavendra.kt@amd.com>
---
 include/linux/kscand.h | 30 +++++++++++++++
 kernel/fork.c          |  2 +
 mm/internal.h          |  1 +
 mm/kscand.c            | 86 ++++++++++++++++++++++++++++++++++++++++++
 mm/mmap.c              |  2 +
 mm/vma_exec.c          |  3 ++
 6 files changed, 124 insertions(+)
 create mode 100644 include/linux/kscand.h

diff --git a/include/linux/kscand.h b/include/linux/kscand.h
new file mode 100644
index 000000000000..ef9947a33ee5
--- /dev/null
+++ b/include/linux/kscand.h
@@ -0,0 +1,30 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _LINUX_KSCAND_H_
+#define _LINUX_KSCAND_H_
+
+#ifdef CONFIG_KSCAND
+extern void __kscand_enter(struct mm_struct *mm);
+extern void __kscand_exit(struct mm_struct *mm);
+
+static inline void kscand_execve(struct mm_struct *mm)
+{
+	__kscand_enter(mm);
+}
+
+static inline void kscand_fork(struct mm_struct *mm, struct mm_struct *oldmm)
+{
+	__kscand_enter(mm);
+}
+
+static inline void kscand_exit(struct mm_struct *mm)
+{
+	__kscand_exit(mm);
+}
+#else /* !CONFIG_KSCAND */
+static inline void __kscand_enter(struct mm_struct *mm) {}
+static inline void __kscand_exit(struct mm_struct *mm) {}
+static inline void kscand_execve(struct mm_struct *mm) {}
+static inline void kscand_fork(struct mm_struct *mm, struct mm_struct *oldmm) {}
+static inline void kscand_exit(struct mm_struct *mm) {}
+#endif
+#endif /* _LINUX_KSCAND_H_ */
diff --git a/kernel/fork.c b/kernel/fork.c
index 1ee8eb11f38b..a13043de91b0 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -85,6 +85,7 @@
 #include <linux/user-return-notifier.h>
 #include <linux/oom.h>
 #include <linux/khugepaged.h>
+#include <linux/kscand.h>
 #include <linux/signalfd.h>
 #include <linux/uprobes.h>
 #include <linux/aio.h>
@@ -1116,6 +1117,7 @@ static inline void __mmput(struct mm_struct *mm)
 
 	uprobe_clear_state(mm);
 	exit_aio(mm);
+	kscand_exit(mm);
 	ksm_exit(mm);
 	khugepaged_exit(mm); /* must run before exit_mmap */
 	exit_mmap(mm);
diff --git a/mm/internal.h b/mm/internal.h
index 6b8ed2017743..dd86efc54885 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -8,6 +8,7 @@
 #define __MM_INTERNAL_H
 
 #include <linux/fs.h>
+#include <linux/kscand.h>
 #include <linux/khugepaged.h>
 #include <linux/mm.h>
 #include <linux/mm_inline.h>
diff --git a/mm/kscand.c b/mm/kscand.c
index f7bbbc70c86a..d5b0d3041b0f 100644
--- a/mm/kscand.c
+++ b/mm/kscand.c
@@ -7,12 +7,14 @@
 #include <linux/swap.h>
 #include <linux/mm_inline.h>
 #include <linux/kthread.h>
+#include <linux/kscand.h>
 #include <linux/string.h>
 #include <linux/delay.h>
 #include <linux/cleanup.h>
 
 #include <asm/pgalloc.h>
 #include "internal.h"
+#include "mm_slot.h"
 
 static struct task_struct *kscand_thread __read_mostly;
 static DEFINE_MUTEX(kscand_mutex);
@@ -29,11 +31,23 @@ static bool need_wakeup;
 
 static unsigned long kscand_sleep_expire;
 
+static DEFINE_SPINLOCK(kscand_mm_lock);
 static DECLARE_WAIT_QUEUE_HEAD(kscand_wait);
 
+#define KSCAND_SLOT_HASH_BITS 10
+static DEFINE_READ_MOSTLY_HASHTABLE(kscand_slots_hash, KSCAND_SLOT_HASH_BITS);
+
+static struct kmem_cache *kscand_slot_cache __read_mostly;
+
+/* Per mm information collected to control VMA scanning */
+struct kscand_mm_slot {
+	struct mm_slot slot;
+};
+
 /* Data structure to keep track of current mm under scan */
 struct kscand_scan {
 	struct list_head mm_head;
+	struct kscand_mm_slot *mm_slot;
 };
 
 struct kscand_scan kscand_scan = {
@@ -69,6 +83,12 @@ static void kscand_wait_work(void)
 	wait_event_timeout(kscand_wait, kscand_should_wakeup(),
 			scan_sleep_jiffies);
 }
+
+static inline int kscand_test_exit(struct mm_struct *mm)
+{
+	return atomic_read(&mm->mm_users) == 0;
+}
+
 static void kscand_do_scan(void)
 {
 	unsigned long iter = 0, mms_to_scan;
@@ -109,6 +129,65 @@ static int kscand(void *none)
 	return 0;
 }
 
+static inline void kscand_destroy(void)
+{
+	kmem_cache_destroy(kscand_slot_cache);
+}
+
+void __kscand_enter(struct mm_struct *mm)
+{
+	struct kscand_mm_slot *kscand_slot;
+	struct mm_slot *slot;
+	int wakeup;
+
+	/* __kscand_exit() must not run from under us */
+	VM_BUG_ON_MM(kscand_test_exit(mm), mm);
+
+	kscand_slot = mm_slot_alloc(kscand_slot_cache);
+
+	if (!kscand_slot)
+		return;
+
+	slot = &kscand_slot->slot;
+
+	spin_lock(&kscand_mm_lock);
+	mm_slot_insert(kscand_slots_hash, mm, slot);
+
+	wakeup = list_empty(&kscand_scan.mm_head);
+	list_add_tail(&slot->mm_node, &kscand_scan.mm_head);
+	spin_unlock(&kscand_mm_lock);
+
+	mmgrab(mm);
+	if (wakeup)
+		wake_up_interruptible(&kscand_wait);
+}
+
+void __kscand_exit(struct mm_struct *mm)
+{
+	struct kscand_mm_slot *mm_slot;
+	struct mm_slot *slot;
+	int free = 0;
+
+	spin_lock(&kscand_mm_lock);
+	slot = mm_slot_lookup(kscand_slots_hash, mm);
+	mm_slot = mm_slot_entry(slot, struct kscand_mm_slot, slot);
+	if (mm_slot && kscand_scan.mm_slot != mm_slot) {
+		hash_del(&slot->hash);
+		list_del(&slot->mm_node);
+		free = 1;
+	}
+
+	spin_unlock(&kscand_mm_lock);
+
+	if (free) {
+		mm_slot_free(kscand_slot_cache, mm_slot);
+		mmdrop(mm);
+	} else if (mm_slot) {
+		mmap_write_lock(mm);
+		mmap_write_unlock(mm);
+	}
+}
+
 static int start_kscand(void)
 {
 	struct task_struct *kthread;
@@ -149,6 +228,12 @@ static int __init kscand_init(void)
 {
 	int err;
 
+	kscand_slot_cache = KMEM_CACHE(kscand_mm_slot, 0);
+
+	if (!kscand_slot_cache) {
+		pr_err("kscand: kmem_cache error");
+		return -ENOMEM;
+	}
 	err = start_kscand();
 	if (err)
 		goto err_kscand;
@@ -157,6 +242,7 @@ static int __init kscand_init(void)
 
 err_kscand:
 	stop_kscand();
+	kscand_destroy();
 
 	return err;
 }
diff --git a/mm/mmap.c b/mm/mmap.c
index 09c563c95112..c9ffe65866de 100644
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -37,6 +37,7 @@
 #include <linux/perf_event.h>
 #include <linux/audit.h>
 #include <linux/khugepaged.h>
+#include <linux/kscand.h>
 #include <linux/uprobes.h>
 #include <linux/notifier.h>
 #include <linux/memory.h>
@@ -1849,6 +1850,7 @@ __latent_entropy int dup_mmap(struct mm_struct *mm, struct mm_struct *oldmm)
 	if (!retval) {
 		mt_set_in_rcu(vmi.mas.tree);
 		ksm_fork(mm, oldmm);
+		kscand_fork(mm, oldmm);
 		khugepaged_fork(mm, oldmm);
 	} else {
 
diff --git a/mm/vma_exec.c b/mm/vma_exec.c
index 2dffb02ed6a2..8576b377f7ad 100644
--- a/mm/vma_exec.c
+++ b/mm/vma_exec.c
@@ -128,6 +128,8 @@ int create_init_stack_vma(struct mm_struct *mm, struct vm_area_struct **vmap,
 	if (err)
 		goto err_ksm;
 
+	kscand_execve(mm);
+
 	/*
 	 * Place the stack at the largest stack address the architecture
 	 * supports. Later, we'll move this to an appropriate place. We don't
@@ -151,6 +153,7 @@ int create_init_stack_vma(struct mm_struct *mm, struct vm_area_struct **vmap,
 	return 0;
 
 err:
+	kscand_exit(mm);
 	ksm_exit(mm);
 err_ksm:
 	mmap_write_unlock(mm);
-- 
2.34.1


