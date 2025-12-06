Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8E3BAD3B7D2
	for <linux-mm@archiver.kernel.org>; Sat,  6 Dec 2025 10:18:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EB4F66B036D; Sat,  6 Dec 2025 05:18:38 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E8C786B036F; Sat,  6 Dec 2025 05:18:38 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D7ACC6B0370; Sat,  6 Dec 2025 05:18:38 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C0C4A6B036D
	for <linux-mm@kvack.org>; Sat,  6 Dec 2025 05:18:38 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 92D0D1A0420
	for <linux-mm@kvack.org>; Sat,  6 Dec 2025 10:18:38 +0000 (UTC)
X-FDA: 84188647116.07.3F31003
Received: from PH0PR06CU001.outbound.protection.outlook.com (mail-westus3azon11011040.outbound.protection.outlook.com [40.107.208.40])
	by imf13.hostedemail.com (Postfix) with ESMTP id 90A3C20004
	for <linux-mm@kvack.org>; Sat,  6 Dec 2025 10:18:35 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=jEBZIKHp;
	spf=pass (imf13.hostedemail.com: domain of bharata@amd.com designates 40.107.208.40 as permitted sender) smtp.mailfrom=bharata@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765016315;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dLiSU5+sCvBg8/CFOBjIAGnmgoiwNU+w2EWUn8AsjW8=;
	b=VWOSOtMy18EgB3daaDkmzAr/8QbDUPy/JMfzNMHzMqvEhRTmxHYrCRuxfOOvnTReyKZx+s
	hs6WGJl8Yh4rNLt+gDseOzKup4JkQrNzeg3XpOrn1kXF4Se/N7F78CHcVTPxaOX4es2osn
	/b/BUIIiq798b3VohH2WWyp6Kbw5MJc=
ARC-Authentication-Results: i=2;
	imf13.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=jEBZIKHp;
	spf=pass (imf13.hostedemail.com: domain of bharata@amd.com designates 40.107.208.40 as permitted sender) smtp.mailfrom=bharata@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1765016315; a=rsa-sha256;
	cv=pass;
	b=SBjKi6xhE2dNakFWTHmGWT1ktvznbNOtYFOj1lqp7TQJgZrRIibphiwmhudQwLzzqedQpm
	wglMJcrIhxGKHOxo/+5D+A7rTbh9sxKTjRh9+DMfdo16UssH/mnuhtOGGwtXKfQKuNxxuQ
	eTsFpvAsMR2dAO+RHwXZriunP1fenMc=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=FpxFNICYh0f+jqn/Xx3HbV/uapLlKx9dAZPwPFh0aLVnOgyaiCVAChR0HSldtlos74NLuEbs7hDUyfGUNerXtB+YUryecDmQBnFThm6E7uHvVI1xoMM/tHrBvKqe3KsVe/+4s3W76cVqbvDk/8M+Zfzdtj9B8ab0DNJBlFFQEajodMvJGlU5Apb1LrCI0T8zX8w3ATYAhr1UKAPpOm4OzsH3dlQd/V8w5m9ncS+GxrVFQkd2z9ZAKUnuC17ksG51N+xesMxe9q32gEcYE5iEK5IDT7wVZ8A20FZySCguAupbR+ky/2aVqASsrCYWZPu50QiUM1tMqOFt9DruBXHNEw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dLiSU5+sCvBg8/CFOBjIAGnmgoiwNU+w2EWUn8AsjW8=;
 b=CFjan8EHozQH9Li+Hn4MKdwH+QBo7ZXJ4Ftbp4hTGtyO64S19wPdc+HG4GYFhKsHK9hbe5pl0z/a1ce0FCxDUYh8qSdfROqph32DaciNsjCFXyL6Osy8MlmVxxhYsOV1uhUtl5wts/ArRlX+A1L1AMwo7MPYC2fDJlxNBlIcwDC7ZcnlQULt/tMzfAuzS5pddNLA0Hwv2pThtDMdWadCYVwJwy0ncEHSZnqSmhOwGn8/353R6AoA/CWCDF4VQkwZ+xwShutIy3dMfj/DmmfX6aHAw4BGXAC64IEFyTePduW7dMJnK0bYSBXYRoOCPo6avputundQbiMR39zHqHrYbw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dLiSU5+sCvBg8/CFOBjIAGnmgoiwNU+w2EWUn8AsjW8=;
 b=jEBZIKHpCD0Tjg8ZGJtqnoB8+Q1cuA4CsO75aGfUENYOeNw+fk/y0rnKduJ/rTqFG9Gca8Aq3/8Bf5n3tTkZDTooUoeaE+KkPo1LiH7reWt+6KiB7ufsRAS2Kjm6BjvDevrIt/va4rFiKN9EV9G4e30/M2WDRsaCohxlARBVoGs=
Received: from BLAPR03CA0123.namprd03.prod.outlook.com (2603:10b6:208:32e::8)
 by BN7PPF7B4E3DFF8.namprd12.prod.outlook.com (2603:10b6:40f:fc02::6d4) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9388.13; Sat, 6 Dec
 2025 10:18:29 +0000
Received: from MN1PEPF0000F0E3.namprd04.prod.outlook.com
 (2603:10b6:208:32e:cafe::e3) by BLAPR03CA0123.outlook.office365.com
 (2603:10b6:208:32e::8) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9388.9 via Frontend Transport; Sat, 6
 Dec 2025 10:18:28 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 MN1PEPF0000F0E3.mail.protection.outlook.com (10.167.242.41) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9412.4 via Frontend Transport; Sat, 6 Dec 2025 10:18:29 +0000
Received: from BLR-L-BHARARAO.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Sat, 6 Dec
 2025 04:18:21 -0600
From: Bharata B Rao <bharata@amd.com>
To: <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>
CC: <Jonathan.Cameron@huawei.com>, <dave.hansen@intel.com>,
	<gourry@gourry.net>, <mgorman@techsingularity.net>, <mingo@redhat.com>,
	<peterz@infradead.org>, <raghavendra.kt@amd.com>, <riel@surriel.com>,
	<rientjes@google.com>, <sj@kernel.org>, <weixugc@google.com>,
	<willy@infradead.org>, <ying.huang@linux.alibaba.com>, <ziy@nvidia.com>,
	<dave@stgolabs.net>, <nifan.cxl@gmail.com>, <xuezhengchu@huawei.com>,
	<yiannis@zptcorp.com>, <akpm@linux-foundation.org>, <david@redhat.com>,
	<byungchul@sk.com>, <kinseyho@google.com>, <joshua.hahnjy@gmail.com>,
	<yuanchu@google.com>, <balbirs@nvidia.com>, <alok.rathore@samsung.com>,
	<shivankg@amd.com>, Bharata B Rao <bharata@amd.com>
Subject: [RFC PATCH v4 8/9] mm: sched: Move hot page promotion from NUMAB=2 to pghot tracking
Date: Sat, 6 Dec 2025 15:44:22 +0530
Message-ID: <20251206101423.5004-9-bharata@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20251206101423.5004-1-bharata@amd.com>
References: <20251206101423.5004-1-bharata@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: satlexmb08.amd.com (10.181.42.217) To satlexmb07.amd.com
 (10.181.42.216)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN1PEPF0000F0E3:EE_|BN7PPF7B4E3DFF8:EE_
X-MS-Office365-Filtering-Correlation-Id: cc221dd9-3f43-45ad-1e52-08de34b0cd25
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|82310400026|1800799024|36860700013|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?nEOO/HgAyGPCfWhCCxDA9uczZHt1PPmI5ovJaAbh3FKaapvNG9IGCEs8wswX?=
 =?us-ascii?Q?dYs4adfD5y/ZItFvF53Dltkzc668A5BFPCxAVDMvoYJyK+1zETR0pxidA9iM?=
 =?us-ascii?Q?1U9y+XeQaBhk4fHsBbi1TkYU4zEd8I0yhAg7Wg29KTNQgEAfuveHFEWhbXDj?=
 =?us-ascii?Q?a3RbvISqc8C9oBha324jCX1D10FlBsFjtISl+LHOoOtjbInaIncJht/QiJlH?=
 =?us-ascii?Q?+6HpCVh6Mq8TkftaESTvFF8I7f3mBFKksEHIkQMleZGu2pRNylE+GT/byjkS?=
 =?us-ascii?Q?9yyWz+Q/XHPQYPPQscKgtOKyIM3Jwr9H9x3dpIVtoTNSuAeu9ViDJmho1WV7?=
 =?us-ascii?Q?IqrDLMNJRFjPAg7F/AdZPF3rFTy7NIf4oMW4HQGCm+UcX4he9jxYZ45hWnoB?=
 =?us-ascii?Q?BEyMcuGyOf/NpOLXmoUt2H430joAIJiLX92ZsEFrxBc1Qvts+I1LrAtWzsfj?=
 =?us-ascii?Q?Dv8Lc/0CRLT4rBnDHjTubXbINkFOnPF7Nsi7gW7EpJhRhJYZZZBKj5RWwJFN?=
 =?us-ascii?Q?Rg1/oaJhlvvduQN0CEmUHT8D/ZpXGaPXn+1VW2Cm0f2Is7t7ALNE3fpbeBbU?=
 =?us-ascii?Q?CLPnixXroqzrrNwXsTk2RFUAsDaNJXN7pPHgG66+Q98Zhw+zjv9HoQq+nNZZ?=
 =?us-ascii?Q?KXwnge27nv2PdD32AgeBPSxrtC2Tp5rTk//qGtNycRGb2VPi5euhcMiyvQI+?=
 =?us-ascii?Q?yP7pbehFcdkh/FsUi6U02cSofQJkp6dCpXQLoZ5DksH5adWhNuHj14tn23CW?=
 =?us-ascii?Q?rQwypgbNguLh6GfA4kKSRK4esC0kk45hQHH0KivjsTqy4C7t8veLWIhxpMZK?=
 =?us-ascii?Q?pRP+4De55Hc7PpGvoi9/XBBJQP5kvr1lAA3BQnFNmux2Ka4HRRDv8N4R0z/e?=
 =?us-ascii?Q?dObu1Isphw6jM50stZE5sqkCL9oIuSOSp/BsRmxfhvGmjFqqJAEkm2PfPHpi?=
 =?us-ascii?Q?zPBHROMdDFngY0GyyIXjl93ZR9+WbFNiw86yxvwllf4WHFBCidzm7laTOIg1?=
 =?us-ascii?Q?5Hkj6w+aYyQI7IFAP/NvnJ+hDa4X7gZ1eVnJrfSZMZPzlul+gxAIMzzAMhOe?=
 =?us-ascii?Q?GGrvyYxs3W8u77Noc54/OOymYFGfo+sblg6CEAgkcTWgaQI7DU6wZc0mnhH6?=
 =?us-ascii?Q?V4CdJPxJfea/TAeftp2WBsIoUEgI2zE4RVWJiYRqo8tq+igZ/qAFy/x9zThy?=
 =?us-ascii?Q?rpX7Uwu287rzaUl6UQ44tS+6G7PFa1gbI+yPdL3hxr4dL4A60DX2nWfxG8Xq?=
 =?us-ascii?Q?gceRA5Lx0Tp5xS0mWH5ZOcysDWt0Z1D1TzYtYMxx1IYq4+k9T9O2T4lSaMxz?=
 =?us-ascii?Q?oKtNAU5inneshLov8fUxVbcCRWEcCtGSKYO64kxU7BZS6AKZBdJqOCIk6xXS?=
 =?us-ascii?Q?g5Bf9FlNSZGExJT5f1tso1ya9jZVdZVMd/64zAvpBUJF3U7TJmMeWEvOre95?=
 =?us-ascii?Q?dEJGM/9kBnf2htJSmP36luhibAeAv/eneud5hSJWE/RhJB5IoiTACIJwenKW?=
 =?us-ascii?Q?EwgW8lv7KUNEoqVJTY7Kz4xZuuHnhQNoWwBkqpI2KSQWKWmFHO+iZRkFeHoF?=
 =?us-ascii?Q?TTV+7hNE76w/xX0m0SM=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(7416014)(82310400026)(1800799024)(36860700013)(376014);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Dec 2025 10:18:29.3377
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: cc221dd9-3f43-45ad-1e52-08de34b0cd25
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MN1PEPF0000F0E3.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN7PPF7B4E3DFF8
X-Stat-Signature: earbizytyjwjgtekrbuakyrejfkmyc7y
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 90A3C20004
X-HE-Tag: 1765016315-698490
X-HE-Meta: U2FsdGVkX18KrGkiw+In0l3YZn3zP5ZtJ+21zfm/v5MCElFCegyvNT4aAlqUBbEGaTjFw/kuJf//47PWYp6N37E0mUksVJYrDqmZOKyeLD7bT2Oc0X6ecVFoH+8KXNikq4UeoqbtWogFcI5KAWtsXD0gyB8fO9Q62Y/A2Uc++N+Weo6R8BzAQaJjgKmjOHjbpGOGpQqko8eOqEEibNFD3wUQV0T78EcxU3x4tNlBBfDST2rEEqXvOuFhCBHGF3iQP9aRiaPqPtKB+e9RC1cnf/WiG6sJODALk0Cjqx7bq4sIdboCc9hdiYkqyQkpHEBfDWPqlEZBHSe+q4tY9HUB7HLFsMdYBzApP0kuJOBgo8RZhRowUyD4aEB0BaBasnOdH+n7soLY7HdssDr9Rj/eVnqkqB9qq98HL5WI5s+5kZgLtHxhtyabjpdjAGK2xIlYBY/DOCHLA+Qnr7/khZPyCk2Tt/z9Wr10Z/QZS50NlWy7rICgHDibB7MvyZi1lcI9ckR6uZAyqXh/I39HbEUvmGvENDPjLdus+8esddRdhvKGDEsyjSGwS3ArhY19ceJswDTqLKlQP3bLvxXKU4vJMI1wUbzS8naDHw6YdZGT1h8MOlox83i2ifmDqMTeUo8b5GUT3u2RNu30H8GlMYQA6MHvFuSKGtWU+/HKbm+tpAv8OWN6zsrjmX9DXKd+33ijB+WJ6FzWa6vNCAWkN536JDvawuuY5rjfAwcdnMaCeOCfmlzbV9moaBFhdLh8uc4lNyj5WB44cjklYGO6XhqL//JKnvJrDkCG8ed4k8Pz3yzGJ0U2OcKAm9xhxvqdpjXrOQ4EH6RVA9W2ugvvuuVKnXeUMs9p0vzcUO8eh5vpjoFEypj6GzeKfGl3R/F+ypwDN2/G/eHpmivdF8eD5BJc6M8agc2M7nT19JnP1uUEwNZ4qQmXYv9UWkwubwbIrm0iV2UMH1/xxARPzry8oXt
 kL2ihsw2
 0s3blynTR/DDwvMFKaWuWqp8hSKwIJVyzWFaqqexxldUf18DONpuPncla9X1WXQPf+IeWQ356muudeA5vtjeb5QFyCBzmAaLEbvftTis+8kfA5VxVnFfZAW7YmN76X51of4JSRPyW8Snkz21Hl4L/THY+gewYN1DSll9L+53klILFOM42uGdsHtXXO67QCAHUYn+68Czj8CV0hq7aBd9x1Kfop0mxdrHpDcVnUaLCqTMGblAnMOktWGGHHwzbzs+dhtkDRuIc8vdoYRSLPFxHj2kSXKmjUpdjkIxiNWCYoNOqKd4Uh0uD6PoWrBKAA9NXT4ddq9Od89sesEqwvnQHVGXvHsvOFUVS4BTMoWAl9F68JmA1sDNmX70UA/C9mvZi7P9Plmk549bos55YKgQNo8lxzz4i66tQpXfLrbqrgnCfP8hWmGQmSAKa6Rqm7w8dXWLRKIF7LB58MvSgvMKR0eqshT/cKq6mNj9AbCDpPDUBm4wpcZcBOvzYHQ56FluJsjzbpo+Wi7zhuKk=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Currently hot page promotion (NUMA_BALANCING_MEMORY_TIERING
mode of NUMA Balancing) does hot page detection (via hint faults),
hot page classification and eventual promotion, all by itself and
sits within the scheduler.

With the new hot page tracking and promotion mechanism being
available, NUMA Balancing can limit itself to detection of
hot pages (via hint faults) and off-load rest of the
functionality to the common hot page tracking system.

pghot_record_access(PGHOT_HINT_FAULT) API is used to feed the
hot page info. In addition, the migration rate limiting and
dynamic threshold logic are moved to kmigrated so that the same
can be used for hot pages reported by other sources too.

Signed-off-by: Bharata B Rao <bharata@amd.com>
---
 include/linux/pghot.h |   3 +
 kernel/sched/debug.c  |   1 -
 kernel/sched/fair.c   | 152 ++----------------------------------------
 mm/huge_memory.c      |  26 ++------
 mm/memory.c           |  31 ++-------
 mm/pghot.c            | 129 ++++++++++++++++++++++++++++++++++-
 6 files changed, 147 insertions(+), 195 deletions(-)

diff --git a/include/linux/pghot.h b/include/linux/pghot.h
index 00f450f79c86..615009a39348 100644
--- a/include/linux/pghot.h
+++ b/include/linux/pghot.h
@@ -71,6 +71,9 @@ enum pghot_src_enabed {
 #define PGHOT_SECTION_HOT_BIT	BIT(0)
 #define PGHOT_SECTION_HOT_MASK	GENMASK(PGHOT_SECTION_HOT_BIT - 1, 0)
 
+#define KMIGRATED_MIGRATION_ADJUST_STEPS	16
+#define KMIGRATED_PROMOTION_THRESHOLD_WINDOW	60000
+
 int pghot_record_access(unsigned long pfn, int nid, int src, unsigned long now);
 #else
 static inline int pghot_record_access(unsigned long pfn, int nid, int src, unsigned long now)
diff --git a/kernel/sched/debug.c b/kernel/sched/debug.c
index 02e16b70a790..10dc3c996806 100644
--- a/kernel/sched/debug.c
+++ b/kernel/sched/debug.c
@@ -520,7 +520,6 @@ static __init int sched_init_debug(void)
 	debugfs_create_u32("scan_period_min_ms", 0644, numa, &sysctl_numa_balancing_scan_period_min);
 	debugfs_create_u32("scan_period_max_ms", 0644, numa, &sysctl_numa_balancing_scan_period_max);
 	debugfs_create_u32("scan_size_mb", 0644, numa, &sysctl_numa_balancing_scan_size);
-	debugfs_create_u32("hot_threshold_ms", 0644, numa, &sysctl_numa_balancing_hot_threshold);
 #endif /* CONFIG_NUMA_BALANCING */
 
 	debugfs_create_file("debug", 0444, debugfs_sched, NULL, &sched_debug_fops);
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 5b752324270b..32f0de52ecd2 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -125,11 +125,6 @@ int __weak arch_asym_cpu_priority(int cpu)
 static unsigned int sysctl_sched_cfs_bandwidth_slice		= 5000UL;
 #endif
 
-#ifdef CONFIG_NUMA_BALANCING
-/* Restrict the NUMA promotion throughput (MB/s) for each target node. */
-static unsigned int sysctl_numa_balancing_promote_rate_limit = 65536;
-#endif
-
 #ifdef CONFIG_SYSCTL
 static const struct ctl_table sched_fair_sysctls[] = {
 #ifdef CONFIG_CFS_BANDWIDTH
@@ -142,16 +137,6 @@ static const struct ctl_table sched_fair_sysctls[] = {
 		.extra1         = SYSCTL_ONE,
 	},
 #endif
-#ifdef CONFIG_NUMA_BALANCING
-	{
-		.procname	= "numa_balancing_promote_rate_limit_MBps",
-		.data		= &sysctl_numa_balancing_promote_rate_limit,
-		.maxlen		= sizeof(unsigned int),
-		.mode		= 0644,
-		.proc_handler	= proc_dointvec_minmax,
-		.extra1		= SYSCTL_ZERO,
-	},
-#endif /* CONFIG_NUMA_BALANCING */
 };
 
 static int __init sched_fair_sysctl_init(void)
@@ -1443,9 +1428,6 @@ unsigned int sysctl_numa_balancing_scan_size = 256;
 /* Scan @scan_size MB every @scan_period after an initial @scan_delay in ms */
 unsigned int sysctl_numa_balancing_scan_delay = 1000;
 
-/* The page with hint page fault latency < threshold in ms is considered hot */
-unsigned int sysctl_numa_balancing_hot_threshold = MSEC_PER_SEC;
-
 struct numa_group {
 	refcount_t refcount;
 
@@ -1800,108 +1782,6 @@ static inline bool cpupid_valid(int cpupid)
 	return cpupid_to_cpu(cpupid) < nr_cpu_ids;
 }
 
-/*
- * For memory tiering mode, if there are enough free pages (more than
- * enough watermark defined here) in fast memory node, to take full
- * advantage of fast memory capacity, all recently accessed slow
- * memory pages will be migrated to fast memory node without
- * considering hot threshold.
- */
-static bool pgdat_free_space_enough(struct pglist_data *pgdat)
-{
-	int z;
-	unsigned long enough_wmark;
-
-	enough_wmark = max(1UL * 1024 * 1024 * 1024 >> PAGE_SHIFT,
-			   pgdat->node_present_pages >> 4);
-	for (z = pgdat->nr_zones - 1; z >= 0; z--) {
-		struct zone *zone = pgdat->node_zones + z;
-
-		if (!populated_zone(zone))
-			continue;
-
-		if (zone_watermark_ok(zone, 0,
-				      promo_wmark_pages(zone) + enough_wmark,
-				      ZONE_MOVABLE, 0))
-			return true;
-	}
-	return false;
-}
-
-/*
- * For memory tiering mode, when page tables are scanned, the scan
- * time will be recorded in struct page in addition to make page
- * PROT_NONE for slow memory page.  So when the page is accessed, in
- * hint page fault handler, the hint page fault latency is calculated
- * via,
- *
- *	hint page fault latency = hint page fault time - scan time
- *
- * The smaller the hint page fault latency, the higher the possibility
- * for the page to be hot.
- */
-static int numa_hint_fault_latency(struct folio *folio)
-{
-	int last_time, time;
-
-	time = jiffies_to_msecs(jiffies);
-	last_time = folio_xchg_access_time(folio, time);
-
-	return (time - last_time) & PAGE_ACCESS_TIME_MASK;
-}
-
-/*
- * For memory tiering mode, too high promotion/demotion throughput may
- * hurt application latency.  So we provide a mechanism to rate limit
- * the number of pages that are tried to be promoted.
- */
-static bool numa_promotion_rate_limit(struct pglist_data *pgdat,
-				      unsigned long rate_limit, int nr)
-{
-	unsigned long nr_cand;
-	unsigned int now, start;
-
-	now = jiffies_to_msecs(jiffies);
-	mod_node_page_state(pgdat, PGPROMOTE_CANDIDATE, nr);
-	nr_cand = node_page_state(pgdat, PGPROMOTE_CANDIDATE);
-	start = pgdat->nbp_rl_start;
-	if (now - start > MSEC_PER_SEC &&
-	    cmpxchg(&pgdat->nbp_rl_start, start, now) == start)
-		pgdat->nbp_rl_nr_cand = nr_cand;
-	if (nr_cand - pgdat->nbp_rl_nr_cand >= rate_limit)
-		return true;
-	return false;
-}
-
-#define NUMA_MIGRATION_ADJUST_STEPS	16
-
-static void numa_promotion_adjust_threshold(struct pglist_data *pgdat,
-					    unsigned long rate_limit,
-					    unsigned int ref_th)
-{
-	unsigned int now, start, th_period, unit_th, th;
-	unsigned long nr_cand, ref_cand, diff_cand;
-
-	now = jiffies_to_msecs(jiffies);
-	th_period = sysctl_numa_balancing_scan_period_max;
-	start = pgdat->nbp_th_start;
-	if (now - start > th_period &&
-	    cmpxchg(&pgdat->nbp_th_start, start, now) == start) {
-		ref_cand = rate_limit *
-			sysctl_numa_balancing_scan_period_max / MSEC_PER_SEC;
-		nr_cand = node_page_state(pgdat, PGPROMOTE_CANDIDATE);
-		diff_cand = nr_cand - pgdat->nbp_th_nr_cand;
-		unit_th = ref_th * 2 / NUMA_MIGRATION_ADJUST_STEPS;
-		th = pgdat->nbp_threshold ? : ref_th;
-		if (diff_cand > ref_cand * 11 / 10)
-			th = max(th - unit_th, unit_th);
-		else if (diff_cand < ref_cand * 9 / 10)
-			th = min(th + unit_th, ref_th * 2);
-		pgdat->nbp_th_nr_cand = nr_cand;
-		pgdat->nbp_threshold = th;
-	}
-}
-
 bool should_numa_migrate_memory(struct task_struct *p, struct folio *folio,
 				int src_nid, int dst_cpu)
 {
@@ -1917,33 +1797,11 @@ bool should_numa_migrate_memory(struct task_struct *p, struct folio *folio,
 
 	/*
 	 * The pages in slow memory node should be migrated according
-	 * to hot/cold instead of private/shared.
-	 */
-	if (folio_use_access_time(folio)) {
-		struct pglist_data *pgdat;
-		unsigned long rate_limit;
-		unsigned int latency, th, def_th;
-		long nr = folio_nr_pages(folio);
-
-		pgdat = NODE_DATA(dst_nid);
-		if (pgdat_free_space_enough(pgdat)) {
-			/* workload changed, reset hot threshold */
-			pgdat->nbp_threshold = 0;
-			mod_node_page_state(pgdat, PGPROMOTE_CANDIDATE_NRL, nr);
-			return true;
-		}
-
-		def_th = sysctl_numa_balancing_hot_threshold;
-		rate_limit = MB_TO_PAGES(sysctl_numa_balancing_promote_rate_limit);
-		numa_promotion_adjust_threshold(pgdat, rate_limit, def_th);
-
-		th = pgdat->nbp_threshold ? : def_th;
-		latency = numa_hint_fault_latency(folio);
-		if (latency >= th)
-			return false;
-
-		return !numa_promotion_rate_limit(pgdat, rate_limit, nr);
-	}
+	 * to hot/cold instead of private/shared. Also the migration
+	 * of such pages are handled by kmigrated.
+	 */
+	if (folio_use_access_time(folio))
+		return true;
 
 	this_cpupid = cpu_pid_to_cpupid(dst_cpu, current->pid);
 	last_cpupid = folio_xchg_last_cpupid(folio, this_cpupid);
diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 6cba1cb14b23..314395e67685 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -39,6 +39,7 @@
 #include <linux/compat.h>
 #include <linux/pgalloc_tag.h>
 #include <linux/pagewalk.h>
+#include <linux/pghot.h>
 
 #include <asm/tlb.h>
 #include <asm/pgalloc.h>
@@ -2051,29 +2052,12 @@ vm_fault_t do_huge_pmd_numa_page(struct vm_fault *vmf)
 
 	target_nid = numa_migrate_check(folio, vmf, haddr, &flags, writable,
 					&last_cpupid);
+	nid = target_nid;
 	if (target_nid == NUMA_NO_NODE)
 		goto out_map;
-	if (migrate_misplaced_folio_prepare(folio, vma, target_nid)) {
-		flags |= TNF_MIGRATE_FAIL;
-		goto out_map;
-	}
-	/* The folio is isolated and isolation code holds a folio reference. */
-	spin_unlock(vmf->ptl);
-	writable = false;
 
-	if (!migrate_misplaced_folio(folio, target_nid)) {
-		flags |= TNF_MIGRATED;
-		nid = target_nid;
-		task_numa_fault(last_cpupid, nid, HPAGE_PMD_NR, flags);
-		return 0;
-	}
+	writable = false;
 
-	flags |= TNF_MIGRATE_FAIL;
-	vmf->ptl = pmd_lock(vma->vm_mm, vmf->pmd);
-	if (unlikely(!pmd_same(pmdp_get(vmf->pmd), vmf->orig_pmd))) {
-		spin_unlock(vmf->ptl);
-		return 0;
-	}
 out_map:
 	/* Restore the PMD */
 	pmd = pmd_modify(pmdp_get(vmf->pmd), vma->vm_page_prot);
@@ -2084,8 +2068,10 @@ vm_fault_t do_huge_pmd_numa_page(struct vm_fault *vmf)
 	update_mmu_cache_pmd(vma, vmf->address, vmf->pmd);
 	spin_unlock(vmf->ptl);
 
-	if (nid != NUMA_NO_NODE)
+	if (nid != NUMA_NO_NODE) {
+		pghot_record_access(folio_pfn(folio), nid, PGHOT_HINT_FAULT, jiffies);
 		task_numa_fault(last_cpupid, nid, HPAGE_PMD_NR, flags);
+	}
 	return 0;
 }
 
diff --git a/mm/memory.c b/mm/memory.c
index b59ae7ce42eb..ff3d75f7360c 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -75,6 +75,7 @@
 #include <linux/perf_event.h>
 #include <linux/ptrace.h>
 #include <linux/vmalloc.h>
+#include <linux/pghot.h>
 #include <linux/sched/sysctl.h>
 
 #include <trace/events/kmem.h>
@@ -6007,34 +6008,12 @@ static vm_fault_t do_numa_page(struct vm_fault *vmf)
 
 	target_nid = numa_migrate_check(folio, vmf, vmf->address, &flags,
 					writable, &last_cpupid);
+	nid = target_nid;
 	if (target_nid == NUMA_NO_NODE)
 		goto out_map;
-	if (migrate_misplaced_folio_prepare(folio, vma, target_nid)) {
-		flags |= TNF_MIGRATE_FAIL;
-		goto out_map;
-	}
-	/* The folio is isolated and isolation code holds a folio reference. */
-	pte_unmap_unlock(vmf->pte, vmf->ptl);
+
 	writable = false;
 	ignore_writable = true;
-
-	/* Migrate to the requested node */
-	if (!migrate_misplaced_folio(folio, target_nid)) {
-		nid = target_nid;
-		flags |= TNF_MIGRATED;
-		task_numa_fault(last_cpupid, nid, nr_pages, flags);
-		return 0;
-	}
-
-	flags |= TNF_MIGRATE_FAIL;
-	vmf->pte = pte_offset_map_lock(vma->vm_mm, vmf->pmd,
-				       vmf->address, &vmf->ptl);
-	if (unlikely(!vmf->pte))
-		return 0;
-	if (unlikely(!pte_same(ptep_get(vmf->pte), vmf->orig_pte))) {
-		pte_unmap_unlock(vmf->pte, vmf->ptl);
-		return 0;
-	}
 out_map:
 	/*
 	 * Make it present again, depending on how arch implements
@@ -6048,8 +6027,10 @@ static vm_fault_t do_numa_page(struct vm_fault *vmf)
 					    writable);
 	pte_unmap_unlock(vmf->pte, vmf->ptl);
 
-	if (nid != NUMA_NO_NODE)
+	if (nid != NUMA_NO_NODE) {
+		pghot_record_access(folio_pfn(folio), nid, PGHOT_HINT_FAULT, jiffies);
 		task_numa_fault(last_cpupid, nid, nr_pages, flags);
+	}
 	return 0;
 }
 
diff --git a/mm/pghot.c b/mm/pghot.c
index a3f52d4e8750..b28d11bf4c9f 100644
--- a/mm/pghot.c
+++ b/mm/pghot.c
@@ -12,6 +12,9 @@
  * the hot pages. kmigrated runs for each lower tier node. It iterates
  * over the node's PFNs and  migrates pages marked for migration into
  * their targeted nodes.
+ *
+ * Migration rate-limiting and dynamic threshold logic implementations
+ * were moved from NUMA Balancing mode 2.
  */
 #include <linux/mm.h>
 #include <linux/migrate.h>
@@ -25,6 +28,8 @@ static unsigned int pghot_freq_threshold = PGHOT_DEFAULT_FREQ_THRESHOLD;
 static unsigned int kmigrated_sleep_ms = KMIGRATED_DEFAULT_SLEEP_MS;
 static unsigned int kmigrated_batch_nr = KMIGRATED_DEFAULT_BATCH_NR;
 
+/* Restrict the NUMA promotion throughput (MB/s) for each target node. */
+static unsigned int sysctl_pghot_promote_rate_limit = 65536;
 static unsigned int sysctl_pghot_freq_window = PGHOT_DEFAULT_FREQ_WINDOW;
 
 static DEFINE_STATIC_KEY_FALSE(pghot_src_hwhints);
@@ -43,6 +48,14 @@ static const struct ctl_table pghot_sysctls[] = {
 		.proc_handler   = proc_dointvec_minmax,
 		.extra1         = SYSCTL_ZERO,
 	},
+	{
+		.procname	= "pghot_promote_rate_limit_MBps",
+		.data		= &sysctl_pghot_promote_rate_limit,
+		.maxlen		= sizeof(unsigned int),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec_minmax,
+		.extra1		= SYSCTL_ZERO,
+	},
 };
 #endif
 
@@ -137,8 +150,13 @@ int pghot_record_access(unsigned long pfn, int nid, int src, unsigned long now)
 		old_freq = (hotness >> PGHOT_FREQ_SHIFT) & PGHOT_FREQ_MASK;
 		old_time = (hotness >> PGHOT_TIME_SHIFT) & PGHOT_TIME_MASK;
 
-		if (((time - old_time) > msecs_to_jiffies(sysctl_pghot_freq_window))
-		    || (nid != NUMA_NO_NODE && old_nid != nid))
+		/*
+		 * Bypass the new window logic for NUMA hint fault source
+		 * as it is too slow in reporting accesses.
+		 * TODO: Fix this.
+		 */
+		if ((((time - old_time) > msecs_to_jiffies(sysctl_pghot_freq_window))
+		    && (src != PGHOT_HINT_FAULT)) || (nid != NUMA_NO_NODE && old_nid != nid))
 			new_window = true;
 
 		if (new_window)
@@ -166,6 +184,110 @@ int pghot_record_access(unsigned long pfn, int nid, int src, unsigned long now)
 	return 0;
 }
 
+/*
+ * For memory tiering mode, if there are enough free pages (more than
+ * enough watermark defined here) in fast memory node, to take full
+ * advantage of fast memory capacity, all recently accessed slow
+ * memory pages will be migrated to fast memory node without
+ * considering hot threshold.
+ */
+static bool pgdat_free_space_enough(struct pglist_data *pgdat)
+{
+	int z;
+	unsigned long enough_wmark;
+
+	enough_wmark = max(1UL * 1024 * 1024 * 1024 >> PAGE_SHIFT,
+			   pgdat->node_present_pages >> 4);
+	for (z = pgdat->nr_zones - 1; z >= 0; z--) {
+		struct zone *zone = pgdat->node_zones + z;
+
+		if (!populated_zone(zone))
+			continue;
+
+		if (zone_watermark_ok(zone, 0,
+				      promo_wmark_pages(zone) + enough_wmark,
+				      ZONE_MOVABLE, 0))
+			return true;
+	}
+	return false;
+}
+
+/*
+ * For memory tiering mode, too high promotion/demotion throughput may
+ * hurt application latency.  So we provide a mechanism to rate limit
+ * the number of pages that are tried to be promoted.
+ */
+static bool kmigrated_promotion_rate_limit(struct pglist_data *pgdat, unsigned long rate_limit,
+					   int nr, unsigned long now_ms)
+{
+	unsigned long nr_cand;
+	unsigned int start;
+
+	mod_node_page_state(pgdat, PGPROMOTE_CANDIDATE, nr);
+	nr_cand = node_page_state(pgdat, PGPROMOTE_CANDIDATE);
+	start = pgdat->nbp_rl_start;
+	if (now_ms - start > MSEC_PER_SEC &&
+	    cmpxchg(&pgdat->nbp_rl_start, start, now_ms) == start)
+		pgdat->nbp_rl_nr_cand = nr_cand;
+	if (nr_cand - pgdat->nbp_rl_nr_cand >= rate_limit)
+		return true;
+	return false;
+}
+
+static void kmigrated_promotion_adjust_threshold(struct pglist_data *pgdat,
+						 unsigned long rate_limit, unsigned int ref_th,
+						 unsigned long now_ms)
+{
+	unsigned int start, th_period, unit_th, th;
+	unsigned long nr_cand, ref_cand, diff_cand;
+
+	th_period = KMIGRATED_PROMOTION_THRESHOLD_WINDOW;
+	start = pgdat->nbp_th_start;
+	if (now_ms - start > th_period &&
+	    cmpxchg(&pgdat->nbp_th_start, start, now_ms) == start) {
+		ref_cand = rate_limit *
+			KMIGRATED_PROMOTION_THRESHOLD_WINDOW / MSEC_PER_SEC;
+		nr_cand = node_page_state(pgdat, PGPROMOTE_CANDIDATE);
+		diff_cand = nr_cand - pgdat->nbp_th_nr_cand;
+		unit_th = ref_th * 2 / KMIGRATED_MIGRATION_ADJUST_STEPS;
+		th = pgdat->nbp_threshold ? : ref_th;
+		if (diff_cand > ref_cand * 11 / 10)
+			th = max(th - unit_th, unit_th);
+		else if (diff_cand < ref_cand * 9 / 10)
+			th = min(th + unit_th, ref_th * 2);
+		pgdat->nbp_th_nr_cand = nr_cand;
+		pgdat->nbp_threshold = th;
+	}
+}
+
+static bool kmigrated_should_migrate_memory(unsigned long nr_pages, unsigned long nid,
+					    unsigned long time)
+{
+	struct pglist_data *pgdat;
+	unsigned long rate_limit;
+	unsigned int th, def_th;
+	unsigned long now = jiffies;
+	unsigned long now_ms = jiffies_to_msecs(now);
+
+	pgdat = NODE_DATA(nid);
+	if (pgdat_free_space_enough(pgdat)) {
+		/* workload changed, reset hot threshold */
+		pgdat->nbp_threshold = 0;
+		mod_node_page_state(pgdat, PGPROMOTE_CANDIDATE_NRL, nr_pages);
+		return true;
+	}
+
+	def_th = sysctl_pghot_freq_window;
+	rate_limit = MB_TO_PAGES(sysctl_pghot_promote_rate_limit);
+	kmigrated_promotion_adjust_threshold(pgdat, rate_limit, def_th, now_ms);
+
+	th = pgdat->nbp_threshold ? : def_th;
+	if (jiffies_to_msecs(now - time) >= th)
+		return false;
+
+	return !kmigrated_promotion_rate_limit(pgdat, rate_limit, nr_pages, now_ms);
+}
+
 static int pghot_get_hotness(unsigned long pfn, unsigned long *nid, unsigned long *freq,
 				    unsigned long *time)
 {
@@ -233,6 +355,9 @@ static void kmigrated_walk_zone(unsigned long start_pfn, unsigned long end_pfn,
 		if (folio_nid(folio) == nid)
 			goto out_next;
 
+		if (!kmigrated_should_migrate_memory(nr, nid, time))
+			goto out_next;
+
 		if (migrate_misplaced_folio_prepare(folio, NULL, nid))
 			goto out_next;
 
-- 
2.34.1


