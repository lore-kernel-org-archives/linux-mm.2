Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9DA6ED6101A
	for <linux-mm@archiver.kernel.org>; Thu, 29 Jan 2026 14:45:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 11AC26B0099; Thu, 29 Jan 2026 09:45:24 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0D22C6B009B; Thu, 29 Jan 2026 09:45:24 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ED5966B009D; Thu, 29 Jan 2026 09:45:23 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id D99D36B0099
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 09:45:23 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id A4DEDB6B7F
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 14:45:23 +0000 (UTC)
X-FDA: 84385274526.02.0C10B73
Received: from BYAPR05CU005.outbound.protection.outlook.com (mail-westusazon11010038.outbound.protection.outlook.com [52.101.85.38])
	by imf18.hostedemail.com (Postfix) with ESMTP id 714CB1C000E
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 14:45:20 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=pmlVn5a6;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf18.hostedemail.com: domain of bharata@amd.com designates 52.101.85.38 as permitted sender) smtp.mailfrom=bharata@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769697920;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tfWfQ+Cg7ulJHmxxSIdfga9GQAvS7WeD3OfOHuo0yI8=;
	b=Ui5YBHWIG+cgBV8kRnCY4q6vFzpGJuM2EpQNOFpnbHbcI+1HTUBuCkA/mzDH3TlxyqMD84
	kluDyNZKGlSr1EoW6XJMRLQLB+Z2/9gDlLUUQQ8ux4AOT7J3n1yRfCwT+AZnM+5JjW+T4S
	chflbgocDV25z7sSbDutObr2lcwntZY=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1769697920; a=rsa-sha256;
	cv=pass;
	b=ZnGqz/puqJhK17MYYE9zLHsNLhKRt58nGsn9ZfSq+L+giM/UmxP2cCLdpHv4uGbFrzGAH7
	zA3anjRTMHCMiDmhoyFeESXRjwNsvqz/WCAU8uWIG4I8S6ptzEbzpSz1eraBAgCWbM5hdz
	3+v/pqy/Xlu61J0lZy2r5owxJou+waM=
ARC-Authentication-Results: i=2;
	imf18.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=pmlVn5a6;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf18.hostedemail.com: domain of bharata@amd.com designates 52.101.85.38 as permitted sender) smtp.mailfrom=bharata@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Ggd8glBSghQcDWgQDMlSh6SNhrskmlAwKHGm7+opvlMGMwC3pdgUaBvISPnvXL8YKeu02zCICNU2DhA7GAXfZI9GraTvaBpx7aKxBsAHHTXAaCaFhHjAXWmi96YmIxC/PzYEJiQ+dsCwKSc9hnB4EPS55ImbPw6cfO5rS8zHK1wUjAHYmgDFJfYi8+41rC1vBu6xLZYCvwA3SiJXNp945UfVMNfO9THFPYvJc7lAYXsGJoiq7LAdCOQeGkabsgewdblT7m6turC/YyAJ35PVBMBCpIWSFurqp2o+OMifdSE960RCI9TIzIf3cEBKw7FozuholznZ4mRyKPIaBq8x7A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tfWfQ+Cg7ulJHmxxSIdfga9GQAvS7WeD3OfOHuo0yI8=;
 b=kY+LuengKpUj1fOIDnzLZ9cuhQKHP7cud3IRZYlGAV/F8lm+lTX1x+th+BggCZTuNLilpyI2n4RFZdghvKB1+tCUmwmPKt8gzOFCHNuZOYRtDc9n61i3mR9SEHZgHjonvtlUcWgAAkU0QRy3GMv0S2c+xy5u12WbRD2QKUG4Q7aPQ5gKFm/6s05QBFiSPqC+aJpccHW0WC2V8VPmp405FjjpJBfkR7BgX9pGAtKmm5I70seuaqe2Z0rTBJFK2u4ZuqeZ9OXF/ljpHWf1FQXRHEerMxjphvVYJTsK0IcgznqiioARK1vPujB0fAEfalR8g4k5J3xHUDUaGts5H+ecEw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tfWfQ+Cg7ulJHmxxSIdfga9GQAvS7WeD3OfOHuo0yI8=;
 b=pmlVn5a6TKIydhB6MbEPbPUEr1V+x3SI3UYXKPFr60x/PG7/A2gl8aPDV0ikNxATqCX0U+l4lkwb32ei9GQSR4mlTr3JByCcq7uiFHoXdAu7t6gsoeW8TvSCgVXdhVSj+/mBqHxJhuWWr3XpUpSMnzF7/mRCZlWzaGs9l2NQkds=
Received: from BL1PR13CA0372.namprd13.prod.outlook.com (2603:10b6:208:2c0::17)
 by CH3PR12MB9342.namprd12.prod.outlook.com (2603:10b6:610:1cb::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9564.7; Thu, 29 Jan
 2026 14:45:09 +0000
Received: from BN2PEPF000055DC.namprd21.prod.outlook.com
 (2603:10b6:208:2c0:cafe::8c) by BL1PR13CA0372.outlook.office365.com
 (2603:10b6:208:2c0::17) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9564.7 via Frontend Transport; Thu,
 29 Jan 2026 14:45:09 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 BN2PEPF000055DC.mail.protection.outlook.com (10.167.245.6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9587.0 via Frontend Transport; Thu, 29 Jan 2026 14:45:09 +0000
Received: from BLR-L-BHARARAO.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Thu, 29 Jan
 2026 08:44:57 -0600
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
Subject: [RFC PATCH v5 08/10] mm: mglru: generalize page table walk
Date: Thu, 29 Jan 2026 20:10:41 +0530
Message-ID: <20260129144043.231636-9-bharata@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260129144043.231636-1-bharata@amd.com>
References: <20260129144043.231636-1-bharata@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: satlexmb08.amd.com (10.181.42.217) To satlexmb07.amd.com
 (10.181.42.216)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN2PEPF000055DC:EE_|CH3PR12MB9342:EE_
X-MS-Office365-Filtering-Correlation-Id: 54ea41f1-1236-48bd-6db2-08de5f45001e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|1800799024|82310400026|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?Xz5Z18ig68zuOGcOfRkK1+TTYPEeIllv6L0ScjI3S94SDJjoP3/lOLGrHFMI?=
 =?us-ascii?Q?W9z1LKgAt/qDQv/AkxjbvdzZ8XCXlxZw2L+PWNvfzEjY7dQLkphCEXkXx2Tv?=
 =?us-ascii?Q?gjepXpagP4ROif6v5HqiujfVBG98erYzOngL6/SXyeGoBAIZrCBuLzB8Oj7z?=
 =?us-ascii?Q?XuKiO+3bpzml4S9oh4qKd1xBNTDVRC8do+S/Xob5dgkiMWg7RpcWGaC6ijdt?=
 =?us-ascii?Q?oy6mN9qQkifUbAiE68y+eYtpf1w/uHrMzNePN38LWtUCQfALSPQietm+BM+h?=
 =?us-ascii?Q?HgawoaazqZOpqndPxwhWipxdenGp2/5KcO49uR27nu0XEfvUxu9d7yo6wov+?=
 =?us-ascii?Q?+b2Ql+skZF6GGpzQpY5cKj675jUcpRd5xPDHCvSuX33QcMRR7wSHdQAVta98?=
 =?us-ascii?Q?LCXYp036LmdHxsXTzfUssmjQCWDw/cVkGi1f9UUUf7bHl7HOksgz/b6St66/?=
 =?us-ascii?Q?eFL9Fw9DUGs5T4QJ/nM/z9z0It5wXxs73mXn1E6tJGXy88+Lyt+1sIi/AuIC?=
 =?us-ascii?Q?VLxT5ED921lc+kc9cZsnsW1NxaJ4ClvxsxUXYKGDuuHJn8aY5t7neUL0DqFf?=
 =?us-ascii?Q?tLTdSJ4TJuEddA7JHpL65lG34KWo/wixiYn471pM1kyf7KDk+ZQ5yMReXEgq?=
 =?us-ascii?Q?sgF8yX7Bngdqj89tGWGbvJ2y5Wuh4kgixD219EXnZwJWhzzbR+fenETVezzR?=
 =?us-ascii?Q?gN5eMgv7wfFAFuzrtWketCiMUsp53bkGeOUvoh1ncdc/rAMM0rVkz2DZZg5+?=
 =?us-ascii?Q?mQsOJ69bWeeSIl6E0F22iCELRuPcyr04Zm81/Xr0dPBQTRIKW7u4ZlvxzDX7?=
 =?us-ascii?Q?zlMK9LbJckcFGKjNbjnPU4hHrWSmckqladX4uAfsr+icKMHtM34t+fBd38hS?=
 =?us-ascii?Q?ODDY0WNKowUSwI6W5j27JHeuVijAqN75ySDIdVdXhVNu1QBUtRJAtfIGgR58?=
 =?us-ascii?Q?f5PyWC6oFWE9aj8pRbe4j+8a0vI0se7Ut6P9DcvbMigwIHY4V+hbz/w17LLp?=
 =?us-ascii?Q?T+gM72vYjHgOMx3UXQ42NFHB4v3XD85HYvSAMQAQfO0mSFcLhgc4hQnYqMta?=
 =?us-ascii?Q?/rqgGCSQ0F4XcNP89RqeFVIrWYSf8HD00MFAAoODt1w0SWSljnBjExYvXtMY?=
 =?us-ascii?Q?mNRG/YXJP2szdXqTif5y0N/GuZCk3UBA/DkjTzViZ+E8CTfIJR5uc8PFNlzk?=
 =?us-ascii?Q?SRznOArIMc1q4FZqV0WngJcrQ9lElkk5dA1jRAOBXsQULZ+bVCR806cgPtPw?=
 =?us-ascii?Q?WnV2Wn0Aq85u/nQ+p3rkuI+DdVRmpFxRszX7smXcR02nAN4QxdUws9oD+iLc?=
 =?us-ascii?Q?/AEgUXryrc36xCs2Twi74MbDYFrAFPh6k4N2YN0HwKmmG6oH8poTTTebxYZp?=
 =?us-ascii?Q?xEvM+wr9+opn2JyGZWiR9RTkpVqGcTTrcyGlsk6MHlzQtbQirDpxTLNcytii?=
 =?us-ascii?Q?gLjvwBnKqQAKxhGIIG+SURj1KqZUcThACsF22Y3P+MFaLC9B/VG6M9WjQ9qh?=
 =?us-ascii?Q?0SX5zUZIlAiUMmse2oe04TH688/pJPtEcxQQNsXp3uYA6DKDA/0OBDF8Aq1R?=
 =?us-ascii?Q?k64dqOzRTv8KFxzG3CXFpZlaB4ZR/sIqfpiDxm8Ibm9+/fnc/+KIkhiB2Q1i?=
 =?us-ascii?Q?B+b+LgwLSA+GhFSocCrzCO7Sdjb3giX0J4a1KjYR9BX6WonV1bakn3CWU1JR?=
 =?us-ascii?Q?/GYh6A=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(82310400026)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jan 2026 14:45:09.2149
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 54ea41f1-1236-48bd-6db2-08de5f45001e
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN2PEPF000055DC.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB9342
X-Rspamd-Queue-Id: 714CB1C000E
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: 973n9sirzkhmbmzh8r4waciqrihjyu48
X-HE-Tag: 1769697920-342809
X-HE-Meta: U2FsdGVkX19OrzLQ8G9telR7xJKo9XAD0IDB1S+QqDKuSL5ZqAgZyl+nnFWfS13belsTFDrtbMhrkoHtOYNg9yR8BcxJgrA9lppUg2cRlGfqJdM8OLV5LgJq39opneout25kQdZXOHeNe4j4yVkmuKV2TE2KNSCXHJJ/alQ/AKSmb3OGsCjNqkgA5A+nDKgneRQF8HMsw6/NlTfjnjCBabVvgyLecZDqHLIyOj0twqOrc/KJrg4anDMTC2gmHUTcBQWP5zfgSEYxkGeXr0TFBFzwcQzaCHngJIAyZv4qBxtTZRJwXd52xdOOVEOOJhzVddKdQYJYklc9kJut9FnsHsIiyrR8UDm7q0ouO7RwRW7QfoWv5+wbBL/q3KrdiNSZhzB6vVJd74EdSnzbmGBeqhZrUxn35Df/dyF3/vnFbIDJO7CYjFc7cXip5wxQz44UII46krxFrmp4BQTuctzN9h17g+XiKtaXb6+t7ZlAa+ImS3eQFEai+TkLvdZgQqLiFGJmIVdUqTnuDOkTf7/+P3fc5ggXKWPL9xS8lDgvKcxRv0tROTFz07ZiNuxSAJ282Pbvmra+QpslVWbu1aN7Rv2y+U1vvCOgBN5UDswBboUkultl1FVGAzuEegFASMAnKP/bnIPJCGbGuU0xwe32t+pv5wJuGL5c5k9eTQVs6WiEZOEVYCLaMRjBHuvR9bUK6Qhi1UI5/m3VuZM/tJFcy4lpEHAYo1dD04rQK1f0/dEEZsrIPezfmofhv16B4lQ1F7zstf6+EVN9qcCRI6DcWgsmCibNZY3WZ8Q3exo2mfYoTyj9FcGaadM87rn+qma8tb/s5+YpWQ3I/Vn4IHZYP6Hue6cMgXw0YvzOoPZ2htb3B5tpIB3aBSdM7RLqArIpIhyeFxuxHyf84MCMxUeeRJoRa1opzUBVSXntjV5dmbVvst2epjthq7q+jTjuY3z17pCcPOXVaQg1Ydj4G1z
 ma9Yt/5O
 8jCXXxw9Iol1KkjkkgRzBUEcxlOivIyzSWAqQ+r7VGxcXNgLy/ZVV+0gOHKJMfg0HErCnFEotUFrBwvwvxnzXdmyEFQ4tOwGXkMfAdOhGeLDhlVx1BUaX8zPGRQGeTCM2b+TOBBTzN6Es7Bg9y2ayZjrIMWWgBxmzoKFv7zJVtI8QkQme903C9sls/7cAjSVI5nGBdPV8EWHR2uQW6nruJmPWlTpyyNG9AF/OQCgX/ntcwzZYHoNfsNpRKyRACR00Bj3HppqlM4vCCCeOMQ5riGy/yaye6u1gAHIQiNcnzjKXPIeALNGdBNCvIWV5xVDQKMkUYk+uPImmzLmoUl5qngxiMKsSHWJEVaJkuTeaX+ixwk1CyNgbJ40fM68CSsIpdLVPmzSUqI1i7adnehgKVXsASbKeShP9EtU+uoQMJ2+1lYiiMnOk21DrQJDLzo3rOplEi6fi8eLG5e1+eMhHnpSU8D4D+4a+613iiHT1mwl2hS5aN/8JQKZqAGr5P8Ny6wsZNQln8i/t4PvgpI+rY5CXteqCTcXjVDHgcI6vtyrtqj8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kinsey Ho <kinseyho@google.com>

Refactor the existing MGLRU page table walking logic to make it
resumable.

Additionally, introduce two hooks into the MGLRU page table walk:
accessed callback and flush callback. The accessed callback is called
for each accessed page detected via the scanned accessed bit. The flush
callback is called when the accessed callback reports that a flush is
required. This allows for processing pages in batches for efficiency.

With a generalised page table walk, introduce a new scan function which
repeatedly scans on the same young generation and does not add a new
young generation.

Signed-off-by: Kinsey Ho <kinseyho@google.com>
Signed-off-by: Yuanchu Xie <yuanchu@google.com>
Signed-off-by: Bharata B Rao <bharata@amd.com>
---
 include/linux/mmzone.h |   5 ++
 mm/internal.h          |   4 +
 mm/vmscan.c            | 181 +++++++++++++++++++++++++++++++----------
 3 files changed, 145 insertions(+), 45 deletions(-)

diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index 49c374064fc2..26350a4951ff 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -548,6 +548,8 @@ struct lru_gen_mm_walk {
 	unsigned long seq;
 	/* the next address within an mm to scan */
 	unsigned long next_addr;
+	/* called for each accessed pte/pmd */
+	bool (*accessed_cb)(unsigned long pfn);
 	/* to batch promoted pages */
 	int nr_pages[MAX_NR_GENS][ANON_AND_FILE][MAX_NR_ZONES];
 	/* to batch the mm stats */
@@ -555,6 +557,9 @@ struct lru_gen_mm_walk {
 	/* total batched items */
 	int batched;
 	int swappiness;
+	/* for the pmd under scanning */
+	int nr_young_pte;
+	int nr_total_pte;
 	bool force_scan;
 };
 
diff --git a/mm/internal.h b/mm/internal.h
index e430da900430..426db1ae286f 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -538,6 +538,10 @@ extern unsigned long highest_memmap_pfn;
 bool folio_isolate_lru(struct folio *folio);
 void folio_putback_lru(struct folio *folio);
 extern void reclaim_throttle(pg_data_t *pgdat, enum vmscan_throttle_state reason);
+void set_task_reclaim_state(struct task_struct *task,
+				   struct reclaim_state *rs);
+void lru_gen_scan_lruvec(struct lruvec *lruvec, unsigned long seq,
+			 bool (*accessed_cb)(unsigned long), void (*flush_cb)(void));
 #ifdef CONFIG_NUMA
 int user_proactive_reclaim(char *buf,
 			   struct mem_cgroup *memcg, pg_data_t *pgdat);
diff --git a/mm/vmscan.c b/mm/vmscan.c
index 670fe9fae5ba..02f3dd128638 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -289,7 +289,7 @@ static int sc_swappiness(struct scan_control *sc, struct mem_cgroup *memcg)
 			continue;				\
 		else
 
-static void set_task_reclaim_state(struct task_struct *task,
+void set_task_reclaim_state(struct task_struct *task,
 				   struct reclaim_state *rs)
 {
 	/* Check for an overwrite */
@@ -3058,7 +3058,7 @@ static bool iterate_mm_list(struct lru_gen_mm_walk *walk, struct mm_struct **ite
 
 	VM_WARN_ON_ONCE(mm_state->seq + 1 < walk->seq);
 
-	if (walk->seq <= mm_state->seq)
+	if (!walk->accessed_cb && walk->seq <= mm_state->seq)
 		goto done;
 
 	if (!mm_state->head)
@@ -3484,16 +3484,14 @@ static void walk_update_folio(struct lru_gen_mm_walk *walk, struct folio *folio,
 	}
 }
 
-static bool walk_pte_range(pmd_t *pmd, unsigned long start, unsigned long end,
-			   struct mm_walk *args)
+static int walk_pte_range(pmd_t *pmd, unsigned long start, unsigned long end,
+			   struct mm_walk *args, bool *suitable)
 {
 	int i;
 	bool dirty;
 	pte_t *pte;
 	spinlock_t *ptl;
 	unsigned long addr;
-	int total = 0;
-	int young = 0;
 	struct folio *last = NULL;
 	struct lru_gen_mm_walk *walk = args->private;
 	struct mem_cgroup *memcg = lruvec_memcg(walk->lruvec);
@@ -3501,19 +3499,24 @@ static bool walk_pte_range(pmd_t *pmd, unsigned long start, unsigned long end,
 	DEFINE_MAX_SEQ(walk->lruvec);
 	int gen = lru_gen_from_seq(max_seq);
 	pmd_t pmdval;
+	int err = 0;
 
 	pte = pte_offset_map_rw_nolock(args->mm, pmd, start & PMD_MASK, &pmdval, &ptl);
-	if (!pte)
-		return false;
+	if (!pte) {
+		*suitable = false;
+		return err;
+	}
 
 	if (!spin_trylock(ptl)) {
 		pte_unmap(pte);
-		return true;
+		*suitable = true;
+		return err;
 	}
 
 	if (unlikely(!pmd_same(pmdval, pmdp_get_lockless(pmd)))) {
 		pte_unmap_unlock(pte, ptl);
-		return false;
+		*suitable = false;
+		return err;
 	}
 
 	arch_enter_lazy_mmu_mode();
@@ -3522,8 +3525,9 @@ static bool walk_pte_range(pmd_t *pmd, unsigned long start, unsigned long end,
 		unsigned long pfn;
 		struct folio *folio;
 		pte_t ptent = ptep_get(pte + i);
+		bool do_flush;
 
-		total++;
+		walk->nr_total_pte++;
 		walk->mm_stats[MM_LEAF_TOTAL]++;
 
 		pfn = get_pte_pfn(ptent, args->vma, addr, pgdat);
@@ -3547,23 +3551,36 @@ static bool walk_pte_range(pmd_t *pmd, unsigned long start, unsigned long end,
 		if (pte_dirty(ptent))
 			dirty = true;
 
-		young++;
+		walk->nr_young_pte++;
 		walk->mm_stats[MM_LEAF_YOUNG]++;
+
+		if (!walk->accessed_cb)
+			continue;
+
+		do_flush = walk->accessed_cb(pfn);
+		if (do_flush) {
+			walk->next_addr = addr + PAGE_SIZE;
+
+			err = -EAGAIN;
+			break;
+		}
 	}
 
 	walk_update_folio(walk, last, gen, dirty);
 	last = NULL;
 
-	if (i < PTRS_PER_PTE && get_next_vma(PMD_MASK, PAGE_SIZE, args, &start, &end))
+	if (!err && i < PTRS_PER_PTE &&
+	    get_next_vma(PMD_MASK, PAGE_SIZE, args, &start, &end))
 		goto restart;
 
 	arch_leave_lazy_mmu_mode();
 	pte_unmap_unlock(pte, ptl);
 
-	return suitable_to_scan(total, young);
+	*suitable = suitable_to_scan(walk->nr_total_pte, walk->nr_young_pte);
+	return err;
 }
 
-static void walk_pmd_range_locked(pud_t *pud, unsigned long addr, struct vm_area_struct *vma,
+static int walk_pmd_range_locked(pud_t *pud, unsigned long addr, struct vm_area_struct *vma,
 				  struct mm_walk *args, unsigned long *bitmap, unsigned long *first)
 {
 	int i;
@@ -3576,6 +3593,7 @@ static void walk_pmd_range_locked(pud_t *pud, unsigned long addr, struct vm_area
 	struct pglist_data *pgdat = lruvec_pgdat(walk->lruvec);
 	DEFINE_MAX_SEQ(walk->lruvec);
 	int gen = lru_gen_from_seq(max_seq);
+	int err = 0;
 
 	VM_WARN_ON_ONCE(pud_leaf(*pud));
 
@@ -3583,13 +3601,13 @@ static void walk_pmd_range_locked(pud_t *pud, unsigned long addr, struct vm_area
 	if (*first == -1) {
 		*first = addr;
 		bitmap_zero(bitmap, MIN_LRU_BATCH);
-		return;
+		return err;
 	}
 
 	i = addr == -1 ? 0 : pmd_index(addr) - pmd_index(*first);
 	if (i && i <= MIN_LRU_BATCH) {
 		__set_bit(i - 1, bitmap);
-		return;
+		return err;
 	}
 
 	pmd = pmd_offset(pud, *first);
@@ -3603,6 +3621,7 @@ static void walk_pmd_range_locked(pud_t *pud, unsigned long addr, struct vm_area
 	do {
 		unsigned long pfn;
 		struct folio *folio;
+		bool do_flush;
 
 		/* don't round down the first address */
 		addr = i ? (*first & PMD_MASK) + i * PMD_SIZE : *first;
@@ -3639,6 +3658,17 @@ static void walk_pmd_range_locked(pud_t *pud, unsigned long addr, struct vm_area
 			dirty = true;
 
 		walk->mm_stats[MM_LEAF_YOUNG]++;
+		if (!walk->accessed_cb)
+			goto next;
+
+		do_flush = walk->accessed_cb(pfn);
+		if (do_flush) {
+			i = find_next_bit(bitmap, MIN_LRU_BATCH, i) + 1;
+
+			walk->next_addr = (*first & PMD_MASK) + i * PMD_SIZE;
+			err = -EAGAIN;
+			break;
+		}
 next:
 		i = i > MIN_LRU_BATCH ? 0 : find_next_bit(bitmap, MIN_LRU_BATCH, i) + 1;
 	} while (i <= MIN_LRU_BATCH);
@@ -3649,9 +3679,10 @@ static void walk_pmd_range_locked(pud_t *pud, unsigned long addr, struct vm_area
 	spin_unlock(ptl);
 done:
 	*first = -1;
+	return err;
 }
 
-static void walk_pmd_range(pud_t *pud, unsigned long start, unsigned long end,
+static int walk_pmd_range(pud_t *pud, unsigned long start, unsigned long end,
 			   struct mm_walk *args)
 {
 	int i;
@@ -3663,6 +3694,7 @@ static void walk_pmd_range(pud_t *pud, unsigned long start, unsigned long end,
 	unsigned long first = -1;
 	struct lru_gen_mm_walk *walk = args->private;
 	struct lru_gen_mm_state *mm_state = get_mm_state(walk->lruvec);
+	int err = 0;
 
 	VM_WARN_ON_ONCE(pud_leaf(*pud));
 
@@ -3676,6 +3708,7 @@ static void walk_pmd_range(pud_t *pud, unsigned long start, unsigned long end,
 	/* walk_pte_range() may call get_next_vma() */
 	vma = args->vma;
 	for (i = pmd_index(start), addr = start; addr != end; i++, addr = next) {
+		bool suitable;
 		pmd_t val = pmdp_get_lockless(pmd + i);
 
 		next = pmd_addr_end(addr, end);
@@ -3692,7 +3725,10 @@ static void walk_pmd_range(pud_t *pud, unsigned long start, unsigned long end,
 			walk->mm_stats[MM_LEAF_TOTAL]++;
 
 			if (pfn != -1)
-				walk_pmd_range_locked(pud, addr, vma, args, bitmap, &first);
+				err = walk_pmd_range_locked(pud, addr, vma, args,
+						bitmap, &first);
+			if (err)
+				return err;
 			continue;
 		}
 
@@ -3701,33 +3737,51 @@ static void walk_pmd_range(pud_t *pud, unsigned long start, unsigned long end,
 			if (!pmd_young(val))
 				continue;
 
-			walk_pmd_range_locked(pud, addr, vma, args, bitmap, &first);
+			err = walk_pmd_range_locked(pud, addr, vma, args,
+						bitmap, &first);
+			if (err)
+				return err;
 		}
 
 		if (!walk->force_scan && !test_bloom_filter(mm_state, walk->seq, pmd + i))
 			continue;
 
+		err = walk_pte_range(&val, addr, next, args, &suitable);
+		if (err && walk->next_addr < next && first == -1)
+			return err;
+
+		walk->nr_total_pte = 0;
+		walk->nr_young_pte = 0;
+
 		walk->mm_stats[MM_NONLEAF_FOUND]++;
 
-		if (!walk_pte_range(&val, addr, next, args))
-			continue;
+		if (!suitable)
+			goto next;
 
 		walk->mm_stats[MM_NONLEAF_ADDED]++;
 
 		/* carry over to the next generation */
 		update_bloom_filter(mm_state, walk->seq + 1, pmd + i);
+next:
+		if (err) {
+			walk->next_addr = first;
+			return err;
+		}
 	}
 
-	walk_pmd_range_locked(pud, -1, vma, args, bitmap, &first);
+	err = walk_pmd_range_locked(pud, -1, vma, args, bitmap, &first);
 
-	if (i < PTRS_PER_PMD && get_next_vma(PUD_MASK, PMD_SIZE, args, &start, &end))
+	if (!err && i < PTRS_PER_PMD &&
+	    get_next_vma(PUD_MASK, PMD_SIZE, args, &start, &end))
 		goto restart;
+
+	return err;
 }
 
 static int walk_pud_range(p4d_t *p4d, unsigned long start, unsigned long end,
 			  struct mm_walk *args)
 {
-	int i;
+	int i, err;
 	pud_t *pud;
 	unsigned long addr;
 	unsigned long next;
@@ -3745,7 +3799,9 @@ static int walk_pud_range(p4d_t *p4d, unsigned long start, unsigned long end,
 		if (!pud_present(val) || WARN_ON_ONCE(pud_leaf(val)))
 			continue;
 
-		walk_pmd_range(&val, addr, next, args);
+		err = walk_pmd_range(&val, addr, next, args);
+		if (err)
+			return err;
 
 		if (need_resched() || walk->batched >= MAX_LRU_BATCH) {
 			end = (addr | ~PUD_MASK) + 1;
@@ -3766,40 +3822,48 @@ static int walk_pud_range(p4d_t *p4d, unsigned long start, unsigned long end,
 	return -EAGAIN;
 }
 
-static void walk_mm(struct mm_struct *mm, struct lru_gen_mm_walk *walk)
+static int try_walk_mm(struct mm_struct *mm, struct lru_gen_mm_walk *walk)
 {
+	int err;
 	static const struct mm_walk_ops mm_walk_ops = {
 		.test_walk = should_skip_vma,
 		.p4d_entry = walk_pud_range,
 		.walk_lock = PGWALK_RDLOCK,
 	};
-	int err;
 	struct lruvec *lruvec = walk->lruvec;
 
-	walk->next_addr = FIRST_USER_ADDRESS;
+	DEFINE_MAX_SEQ(lruvec);
 
-	do {
-		DEFINE_MAX_SEQ(lruvec);
+	err = -EBUSY;
 
-		err = -EBUSY;
+	/* another thread might have called inc_max_seq() */
+	if (walk->seq != max_seq)
+		return err;
 
-		/* another thread might have called inc_max_seq() */
-		if (walk->seq != max_seq)
-			break;
+	/* the caller might be holding the lock for write */
+	if (mmap_read_trylock(mm)) {
+		err = walk_page_range(mm, walk->next_addr, ULONG_MAX,
+				      &mm_walk_ops, walk);
 
-		/* the caller might be holding the lock for write */
-		if (mmap_read_trylock(mm)) {
-			err = walk_page_range(mm, walk->next_addr, ULONG_MAX, &mm_walk_ops, walk);
+		mmap_read_unlock(mm);
+	}
 
-			mmap_read_unlock(mm);
-		}
+	if (walk->batched) {
+		spin_lock_irq(&lruvec->lru_lock);
+		reset_batch_size(walk);
+		spin_unlock_irq(&lruvec->lru_lock);
+	}
 
-		if (walk->batched) {
-			spin_lock_irq(&lruvec->lru_lock);
-			reset_batch_size(walk);
-			spin_unlock_irq(&lruvec->lru_lock);
-		}
+	return err;
+}
+
+static void walk_mm(struct mm_struct *mm, struct lru_gen_mm_walk *walk)
+{
+	int err;
 
+	walk->next_addr = FIRST_USER_ADDRESS;
+	do {
+		err = try_walk_mm(mm, walk);
 		cond_resched();
 	} while (err == -EAGAIN);
 }
@@ -4011,6 +4075,33 @@ static bool inc_max_seq(struct lruvec *lruvec, unsigned long seq, int swappiness
 	return success;
 }
 
+void lru_gen_scan_lruvec(struct lruvec *lruvec, unsigned long seq,
+			 bool (*accessed_cb)(unsigned long), void (*flush_cb)(void))
+{
+	struct lru_gen_mm_walk *walk = current->reclaim_state->mm_walk;
+	struct mm_struct *mm = NULL;
+
+	walk->lruvec = lruvec;
+	walk->seq = seq;
+	walk->accessed_cb = accessed_cb;
+	walk->swappiness = MAX_SWAPPINESS;
+
+	do {
+		int err = -EBUSY;
+
+		iterate_mm_list(walk, &mm);
+		if (!mm)
+			break;
+
+		walk->next_addr = FIRST_USER_ADDRESS;
+		do {
+			err = try_walk_mm(mm, walk);
+			cond_resched();
+			flush_cb();
+		} while (err == -EAGAIN);
+	} while (mm);
+}
+
 static bool try_to_inc_max_seq(struct lruvec *lruvec, unsigned long seq,
 			       int swappiness, bool force_scan)
 {
-- 
2.34.1


