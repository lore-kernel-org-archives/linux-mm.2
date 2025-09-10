Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B4EC1CA101F
	for <linux-mm@archiver.kernel.org>; Wed, 10 Sep 2025 14:50:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1D7AF8E0021; Wed, 10 Sep 2025 10:50:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 186918E0011; Wed, 10 Sep 2025 10:50:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 04D888E0021; Wed, 10 Sep 2025 10:50:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E28CD8E0011
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 10:50:18 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 898DC1A0947
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 14:50:18 +0000 (UTC)
X-FDA: 83873626116.04.396B1A8
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2052.outbound.protection.outlook.com [40.107.223.52])
	by imf18.hostedemail.com (Postfix) with ESMTP id A02601C000F
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 14:50:15 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=Z5Gyve79;
	spf=pass (imf18.hostedemail.com: domain of bharata@amd.com designates 40.107.223.52 as permitted sender) smtp.mailfrom=bharata@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757515815;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dXCLP7LS/KfXDafwpQvsPCw+JGNumX2OyTonQaCXLh8=;
	b=wLuq3nSvZYE0Fak5ZHckGJlKvo8oauiOVJDA0INnb/OBXfAn6UUAOhQB1WIzCAqliKo+Uj
	cyWYvsN0/1UEAPjDndcBQqPMzmZEIHaTESwXCw5YEU+p1ktNkrFbAKVLBcGgWhVxQNBE56
	KOjeGYqdNzDPDRwFw1r5qRjaNWHWs4c=
ARC-Authentication-Results: i=2;
	imf18.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=Z5Gyve79;
	spf=pass (imf18.hostedemail.com: domain of bharata@amd.com designates 40.107.223.52 as permitted sender) smtp.mailfrom=bharata@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1757515815; a=rsa-sha256;
	cv=pass;
	b=M1hdCw94jjQkpbHQzrU2Fpl1fwkakc1Bs8a69FwZCpXAbg3C9C5ujoIdhs3GuARzB+W0bZ
	UM4+JBccBzpEFp1omLA2jQKLrjNXvNfALBaWXHmvoShwW7fplNgK4MbE6Gx48I8hCv0UrY
	PZCg9/oqyT2lS3N4Il/hT9ThRuJs9/Q=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=OxNDcJlK+Q5H74QT+JBzR96l1q2uIEv+IWgO04vcYhekIgGclnKC7cu+IVIafFIdTLeDo/UIap0K/oQ//tE2aLNs9jZvzBj9XjQ9/mVY0ZlEz3xvUcNiAwYCcZT3ANzNNBrfDYB9N47tRhfZ4qikf8n4E7v5ywy050o5KNOu5RiUHi22yjloBireLelT+vvhIq76orpCobDmpaBgeYiJsUoOwIuqIr0PGfa6mEdte3BxlF+eAIl2oC8b/duBs4OdVxpsMOCnrfqL6gUtV71muaLFTry98h5yr0lo5Ziwm+CM1gbWhMLS1cMp+lTUC9ewAY/KsJeiW4HVxWtfAiMCvA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dXCLP7LS/KfXDafwpQvsPCw+JGNumX2OyTonQaCXLh8=;
 b=mR5HIgxfSICrEqDkmO9zSDqbVUqq4ZkgANiuNHhxGtvbNoV+3/klBDYZKADROUvb+zxPNB2w7yUdPNI7nizeL6NchGADtYtDLXb1yQwovsCLl6JRoAKGbtXAf+FM7z4oK39X7ZC1eloDYOhSK0lWh9sn0SF0B2ljrYiGuH2yZfkkoCQeOOxRiVd8RUErxA04VUtdsNUAJHWWi4bx4bczJvCVst4SNVZmmUQfzg21Xty86j84iIN6C4JjCdplu7vYuvHYqMJavZS2EmisXiUAOgs59o6Lm5THyDeUJDmTD9iweoYfCz/M6PMPsRLa1FW1yInwmXz/Oczz2vTB32xpAA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dXCLP7LS/KfXDafwpQvsPCw+JGNumX2OyTonQaCXLh8=;
 b=Z5Gyve79DUwkairfmbKDpOrOTWz2hj9D/BnUZVrE20N5c7hpIwEKv3O+fQo1MCTWhXqD/9nmgWy20gfFHjfWwBcDscv1I9d0p8mmGn9UCcIZgWipqi1R03+p5FxsYiNU28yKVmXfI3JxmRZQ1ZFjVFJE+Y9mfBLrEr2OpVjIqKE=
Received: from SN7P220CA0027.NAMP220.PROD.OUTLOOK.COM (2603:10b6:806:123::32)
 by CH3PR12MB8969.namprd12.prod.outlook.com (2603:10b6:610:17c::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9094.22; Wed, 10 Sep
 2025 14:50:12 +0000
Received: from SA2PEPF00001509.namprd04.prod.outlook.com
 (2603:10b6:806:123:cafe::a8) by SN7P220CA0027.outlook.office365.com
 (2603:10b6:806:123::32) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9094.22 via Frontend Transport; Wed,
 10 Sep 2025 14:50:12 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 SA2PEPF00001509.mail.protection.outlook.com (10.167.242.41) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9115.13 via Frontend Transport; Wed, 10 Sep 2025 14:50:12 +0000
Received: from BLR-L-BHARARAO.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Wed, 10 Sep
 2025 07:49:54 -0700
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
Subject: [RFC PATCH v2 5/8] x86: ibs: Enable IBS profiling for memory accesses
Date: Wed, 10 Sep 2025 20:16:50 +0530
Message-ID: <20250910144653.212066-6-bharata@amd.com>
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
X-MS-TrafficTypeDiagnostic: SA2PEPF00001509:EE_|CH3PR12MB8969:EE_
X-MS-Office365-Filtering-Correlation-Id: 1c1c57dc-5724-4217-f6b0-08ddf0795886
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|7416014|376014|36860700013|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?fF5GkmoqLg4OZU3k2Vh7EB8u/tq0rhPsgSMa3KqnzChwemSzBkpZWBBBL/br?=
 =?us-ascii?Q?T2hQcnlTFmZONvYsAzMH220J3nv8kN85QQM157euBTSCFINZcWNQSnVF8CWT?=
 =?us-ascii?Q?gIZKJX5FLDPx8jDKpkeeei96EDXiUHpvXjBH75vNZNtLpQfvx/qJrETRYYRw?=
 =?us-ascii?Q?V/LhQHfWRAwMSbEf75K9+CJ7YYNROBvi2A7BXUJfLrQlgwMsUzb7hoQMwDF7?=
 =?us-ascii?Q?v4N504j6zsO0d2RJofdwD6jqMMbUx0z5pJ4dIEqmwZkYmfeZpl+oCRLhGUpT?=
 =?us-ascii?Q?wPThMvzVbJ1TNEHO/wGT/9ma+Pm/xRZiXVBwuuUdg+312336bv+4zxh+9sBZ?=
 =?us-ascii?Q?3+15iJYygtH3sg324w7ar5xSr1mhmfhuadFsF/EDta7mUjgIr3lLdTkEiVLJ?=
 =?us-ascii?Q?4Ty2idFfXfdQX2el9SnsoTDCUQg3TAiDzNcFjGXNKyopXt8OzBnjPpdvtTb/?=
 =?us-ascii?Q?yqlk8YR2g1Kpd/QwiLiMcPMePOs09BfjfU7awTSITWDDsPusclESWfi3Y6yp?=
 =?us-ascii?Q?zZQTBjo5xklti9zTDaZfEBhkaZJ2Hnfo/d5dEEm4/di1Etlpic/myYrbY92D?=
 =?us-ascii?Q?JpAnulh1+huSE8PIuq/YL12On4JHwfuVh6DxEliK9r/UdXFjtr0JAlyKxeEr?=
 =?us-ascii?Q?POxQKKtuX0um6F+gFwIOhL+iA6VUAczEaE6/Pon4TsnO/1CpW0IZFNdgxPFP?=
 =?us-ascii?Q?Nn8/ck/4e91QR33R+mcBzlJJOPKK/z0TkWQRA6G4aRlYY2L3CixW7nAR9gmz?=
 =?us-ascii?Q?4JcPViPfR0RE4FYUIFTAMaSEfVXWoiOZHccvE4xXWQjH0MV23qAdD1HJ0Crc?=
 =?us-ascii?Q?maZbmBrWgkf62lMbPQgANf0MO5NXk27nypSIEMxyIAgxvMIyre7rpR0S5kvz?=
 =?us-ascii?Q?TDtVzil4g9fZqIoRwUxv2zr02FP7lKdJ0PKubCUQjR/CCQq6csAkh/Xdfhj1?=
 =?us-ascii?Q?afqhq2h6hwKFZ6m8SlD9kcToGbm/vuGV19Fm8A4+bjJuCllRbxpB7UgIvnWY?=
 =?us-ascii?Q?JJJP2MLOALZS1in15RbAwG3t6BRd9bBW9zEc35l6swjF9MLqqBNi817i53ne?=
 =?us-ascii?Q?Ryh+Hy5Yc3aqZospk2vxcwRuIpC8eK29QiEfFfHNlF6RCABWScNh4zmjXzQL?=
 =?us-ascii?Q?4Oc7C6ry35r2fmD77J5doQO1AqGAL6WFVXyUQ3ZtZHUkZUBL1mNKq80Y6ude?=
 =?us-ascii?Q?ctsXbkvvZyr6CqeupLYYkCv/YEQqSDqGsDS+uJeZ83vH49Sxbc/Tz62/Kkq7?=
 =?us-ascii?Q?VQZDttcDRKMVCVmokIZpBQW3RYI2EZ9MuImLKi6rmb36HU9JWlCJDbkL92ev?=
 =?us-ascii?Q?QgD28lPdA5SPU86gHkwkP4oh4b5PRPOmFOWPs9QJl24FqEaL+G/KKVGXOv30?=
 =?us-ascii?Q?/+54q5SDq54gyJ0iVDef31u9VH91gxUiYlsTkIgg9FqdQXKtIO4gjfrx9JlP?=
 =?us-ascii?Q?0CEKK4IzN2UjzHvhSACfrRlAOwjOPWVUvt5BvCaR0ufGgw4m3c3tf+Bo2h1I?=
 =?us-ascii?Q?y9qybfUbgB+k+2jcnoX8v10s5lPdal0x6i71?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(36860700013)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Sep 2025 14:50:12.2724
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 1c1c57dc-5724-4217-f6b0-08ddf0795886
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SA2PEPF00001509.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB8969
X-Stat-Signature: y9rmx9ahzazpr48kpyu4ifbr8qdo7b8o
X-Rspam-User: 
X-Rspamd-Queue-Id: A02601C000F
X-Rspamd-Server: rspam04
X-HE-Tag: 1757515815-503584
X-HE-Meta: U2FsdGVkX1/1pwgsAfqhLk/kOX0Sk9lacYNF4ih/WTvPdLH+Sa9JhtgWPUPYd2ZDXhM/Pku77tuRZrDu1QNH7c2FA3sBlijqypVyJDJdvBKp7XIg+EDNl7LVyUnIRkYNtwCzepK8tHXbIZ3Ta+CAosu1IV23bwZiwhFTkFeXvB70uQKB6N5q20BcfxJzCm+9SVLBndT27lPh8+XzDFFgRExoITzQ2cgS8NMh4NQn2BM8pu+tGDC5509pElSSQtnmoUV72x/kH6MfYWqJpjpDbqkqNGy0iHDSMQpk1avImTWU14tZXn7yoDPhgEIzSkp9YHWpmGyIb5M3oK0pFlzmyx5Br+dwUUiGmDMF1V0qsWFl9+onb0KNcXsJIES/VMq6D1impmTMmmfcVyVYLk5QdRgCX8+pM8b/MWlMtERA38Az2p700wVzxCXOLB0lttuGtV4W+lOqFpPclQe+f5D3z51Rr9mur2gCdckBrIuVAsUlg+uMauRY87E9KnDwROG4SQ/mgNcY08JFkCO3qgrULDfNzmpRHuP/HpglP4aGN10Qo9U/GwTb7NR9sQGOoDcIfoyQ8PGONTkGq/1vzvVwLBihZoeZnzvcnMhcL1Uf7uZZ0hMlIzUKTarANXEy8ATZj6Z3vrUH5SwMIm5zR/6YEo5ni1xNes0tkLUAjYC8QM6kdQSJKV5fWP81f7IRXqgT1dqWQWeha+gqUOAy3Moi1g9ON5ZKZaGs68FRGD3D4g8RwGuJLzM1gd9Gbko/Zz+18N48mUSOOYXZpCVO9QWabHJ5gemWY89nI3aeuHLOGA+MaJ8w94/QsX8zIo+jT1s7r0YBvK2AxO3asugjgJCEe99ZaeaOlwuHP7sKDSbm3Ec1w24lgLs6nLRnL9MsZPpvBZlheEJ0mmKUnHP1PHICntTD4tiTP+T9DsdQXUFAOCAREDtdIAWwZu5fMn+aJjzkzU0dn9HqINGjfA/4x8O
 +Hjl21Ap
 v4dbZxKG/y20/TxmAL3Et69X9kkhCL8dtBALeJQ9wIYAKS3VAxUYLron4iJ3cHC93Xs8kE2tq5WOHWRbWRQI10E32RBEV2IvsQjT60lHVl8d759A7O7n3DthTh3040fi4+ofM4xlloj9maol58OP0V0WxECpbTyifG7JBrl/Y3P9+BhTKKdbD3Y8jHAjsDg1njfQ30uHwVGkBaft//soVJNbJ38ZRjW7AOMuy1bj68TvNbJKtzbVwvrVogNjXP76uV3WXcVqDvzm067SJiJLdu3eFuec7g9Gdrbi3JkIn7OMITui9/1mntnuyZJc8vvuaHknPRUg5a3tT2pTu9KGHGtNJhFMntcsJvjWG/ZLD8RIx7Ge+tIkezlgubXQP09FIwPA4mzOKfa6BNswjvh2oAngK3wojjWoKRXjNk0eETIN7KK3vlI2Qnbtb5/+6BG+bUX1w+Wc+9qqDFaAvXRhbgS7OmaietKQyBlDZxiMeg/SLYP9C3TGdUvP9XQ5u8OXSLJM2o4qknWlXzItnZ9TBLroIM6kloKcWGSyTg9yXAsHwvBRHXOdy4JM11BWPUxdM9IoAD1EI6DyEwo6Fi/eJTcaUpEGpTG64iHNRNrmkK49qgIwTomzAtr1ESgT1Gr9Pynp2UtU6eP7f1AahtP1noHKB27ypaZJ6sxNh
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


