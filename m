Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 43376CCF9E3
	for <linux-mm@archiver.kernel.org>; Mon, 10 Nov 2025 05:27:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A4ACA8E0012; Mon, 10 Nov 2025 00:27:49 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9D5868E0002; Mon, 10 Nov 2025 00:27:49 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 84EF68E0012; Mon, 10 Nov 2025 00:27:49 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 67A188E0002
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 00:27:49 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 2861713C1C7
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 05:27:49 +0000 (UTC)
X-FDA: 84093565458.08.808BE22
Received: from SA9PR02CU001.outbound.protection.outlook.com (mail-southcentralusazon11013055.outbound.protection.outlook.com [40.93.196.55])
	by imf28.hostedemail.com (Postfix) with ESMTP id 2928DC0003
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 05:27:45 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=tY9TCMRd;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf28.hostedemail.com: domain of bharata@amd.com designates 40.93.196.55 as permitted sender) smtp.mailfrom=bharata@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762752466;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Me/43MBnMxmie4nZl97bTN6/9j30MpykjLQJok4yuqQ=;
	b=rqmdR0xSb/Wqgjd8SHObQjHEvTSew2ZoaJGM7pyAXk3snFGBlxE5Jz6I1sLGzzGWOz4Cpt
	QZTwdQX/N/HX89H7amj7N40lbkqg0vqtxh36HT2hv0oSOYfOOxICiYvHgq+n3zHp3TVgsa
	sdyl5HnCufXrFkm1M9wclnoMfmiAadA=
ARC-Authentication-Results: i=2;
	imf28.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=tY9TCMRd;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf28.hostedemail.com: domain of bharata@amd.com designates 40.93.196.55 as permitted sender) smtp.mailfrom=bharata@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1762752466; a=rsa-sha256;
	cv=pass;
	b=mpZGSg5SSbseRB8qcRFTILVENlYHRRlMRLA3lhOoLtLrHhhxDTwTYYa13hq0wjq0evg7UG
	NOhTIRMWnrb5hwDqR4LKVyYaNe7cqgmzoWFtHMmTPAw4FSNRqE1cwJVzguy4NOYDIljAWt
	kJdKGYJPwIoKbhwQQwau2ZGEm73n+Wc=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=HdbuI4SE0oLI1Bmz591R2worSMHrWECAMPY+ZSZ0mgPozuUn29+/EH5wZZW0SAzNiwV6GWwPUAHlJT+E2U2lt33gzfC7sz7gADL004tNJFTYEyLtfEcWaB9DCYOZe5Hr2K0a5pkh2W4ZAzkqcAj2fsjk1o4H1D1UVpRf5Gb9tV3bQNoHS+jtC+/xF5JjVvAzhRU/xFwqTMbERH1xspzgEYe+y63W39Ksm75Mbh2yOYE9Xr2Iv+AGX6Z/xk1UA86QB5nX2+pIFnU4qqEtlVWyysilNU7vEwJ4LHSbPLa36AG9jrOX1Bm6vLaAFTdBaGuy28CfH8VruZ6JrK9f4Hazeg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Me/43MBnMxmie4nZl97bTN6/9j30MpykjLQJok4yuqQ=;
 b=uX5poo2T7fuMtD0PWFv1SpqHdsTiDUqITQKK3JKQhbV9yuFBr3gXqLRuicUMNd6UDU9MjbyqI217shknhG3juBZIcReMYLcrcBCJTIkufVsRTjJ9VDv1oiieXsaYhpBuy9S1B/WRGpqlgkw+qZrGh0gcmdd3uYavKzNUJwL92M+h56FzGEth/2vFX/8cI/f/RBVgheEchxEw5BfUrDQ9nTQgGLMfvVBIGXsPwLeG+eKLfZSYMSrAPFmblS1KJ4ZIx2x1YN2CFE+TOUoi00/Fq1eKqHb/GTB0jtTlCDBA6QegYe+tbXvgIgzDW5nASC+wuaIVnnFvgavJpgBXwtrMJg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Me/43MBnMxmie4nZl97bTN6/9j30MpykjLQJok4yuqQ=;
 b=tY9TCMRdTEfL0Alr3kLn80BuT6bDIW1+B6dVIpwfEBFBtaOoyg/FFeHWy/v+Xflq9ec+udAbOBttVoNqn7Rs1Hh0pL2zGJMIhlB4qGyd2NKKYd+OViHe2VxzpJij7fBcFO2JdKtCGUggz+tjhhBnMHCTzo19vLN3WMsUiYFxY4s=
Received: from SA1P222CA0198.NAMP222.PROD.OUTLOOK.COM (2603:10b6:806:3c4::22)
 by SJ2PR12MB8133.namprd12.prod.outlook.com (2603:10b6:a03:4af::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9298.16; Mon, 10 Nov
 2025 05:27:40 +0000
Received: from SA2PEPF000015C8.namprd03.prod.outlook.com
 (2603:10b6:806:3c4:cafe::6d) by SA1P222CA0198.outlook.office365.com
 (2603:10b6:806:3c4::22) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9298.16 via Frontend Transport; Mon,
 10 Nov 2025 05:27:33 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 SA2PEPF000015C8.mail.protection.outlook.com (10.167.241.198) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9320.13 via Frontend Transport; Mon, 10 Nov 2025 05:27:39 +0000
Received: from BLR-L-BHARARAO.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Sun, 9 Nov
 2025 21:27:31 -0800
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
Subject: [RFC PATCH v3 8/8] mm: sched: Move hot page promotion from NUMAB=2 to pghot tracking
Date: Mon, 10 Nov 2025 10:53:43 +0530
Message-ID: <20251110052343.208768-9-bharata@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20251110052343.208768-1-bharata@amd.com>
References: <20251110052343.208768-1-bharata@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: satlexmb08.amd.com (10.181.42.217) To satlexmb07.amd.com
 (10.181.42.216)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA2PEPF000015C8:EE_|SJ2PR12MB8133:EE_
X-MS-Office365-Filtering-Correlation-Id: 078c44a6-755f-4a20-6b40-08de2019dd9f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|1800799024|376014|7416014|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?e0suwLw1tLb0mGom1J4tXGEpgVTYFrPKrHm4nwGtuh+BlAyqvW8ZcM4huGsj?=
 =?us-ascii?Q?oKH/tp5RFW48ZbqrzmHGGBCemwZ8FSTN6juJc9yPc5Djwlm0kwnn2A6GWSuK?=
 =?us-ascii?Q?MjtdOT8Vdhmnfto6lV+QlJAgcj3xU7fGKmy8FMz7BXGixf8NjRV7odMFBjYi?=
 =?us-ascii?Q?zoUq6ARZd7JfXjU+yRxOnsOqKxkMQTim7DSeEpVp6uVynArZ/Ld+9Twcgzq5?=
 =?us-ascii?Q?37l35FW8CBhxp//htMsNNsXH8u5hifbfFi1GwdBQWMZ3lqVnXFEFKQ19HqMp?=
 =?us-ascii?Q?RzTOVzPEIvJYs7jHL8NTrpHuDJJ7IbU1AWMXlD7l5sqhjf5QRkS9CnDChY3x?=
 =?us-ascii?Q?yJboUCGk4JWLchWfOX5KuRpX4iSCapdAiUExqMNALOYSBTlwNv+7AqcTCgkv?=
 =?us-ascii?Q?gTk3b2Fqz2oeYRhE4Em6VuP68w1ZEQYjcThcEb1zWiU+a01CCq9uI9e2VDyZ?=
 =?us-ascii?Q?oL8/xPUxlpIN+DTtJcK0ogZUt8wkP4aCes3PHXk0tmsxRDL1EPhkaWUXq/BF?=
 =?us-ascii?Q?g+0kmG2+hYkj2yRVgwv+KbCsCNhr9M9w2j8PL6z8u9Qp9inzk12ju0stU2RN?=
 =?us-ascii?Q?8griT9+GkIxU1cQEOsyZz7jIUubWkDDiZ2HSbBBFT6aA8Gi66ZBIdeME6MY+?=
 =?us-ascii?Q?QI6yrOyzCF9fuoRFtVXE0tIgx0wTBebKW2CwoFuYRM/FCMoAbtcA5C+e/muZ?=
 =?us-ascii?Q?4rBMKjw/DxwAzh2gqr3jF7J7VFAh86zKBBWiKoRZzB/eEjgWYdm00HAdvMPo?=
 =?us-ascii?Q?AkfUwuNyFDucLCqDiQTXicfg4I8Og/Z0KsYMT1TTA0aJHfBLo9z7HwLI254q?=
 =?us-ascii?Q?3BCwzQSUZPOJR+f9LylR75aaYJ8V9ogtR5LTG2VYRhZbxsYEZVs9/9iQlRZt?=
 =?us-ascii?Q?XTohqTQb5YD4o/k1rWyHwtxxVb4fnxdfFwAm6N6Rir6Jpr7jYcM2AtRI+6I3?=
 =?us-ascii?Q?9Q5Ep3HVxyR9bLmU8wpcZEzGUZKiuhhSrvHGWXfxfnBXvklNA0I3Z8coD1QB?=
 =?us-ascii?Q?FxgrR+XdVLH48mLDN2GZZjqmo7k4EyZHmOCxJzYbe4sRefcDUA94I3dYV0Xt?=
 =?us-ascii?Q?D3VvLI43VYdkT+cc/3MCYfug8m5HfxqnUPHOQcFHJBXBOpmiStIFolQULwDB?=
 =?us-ascii?Q?3yMlw9Myuw7f4Y3h2lsZfS9korrG9yM0BSoA3gRGvcqvUloVYZkqAy2GTTEj?=
 =?us-ascii?Q?GTdLMK5oFNOg4k9cz4/DPN6w6NwIRcXg6bpC4fQxXoGhNeMWPAPD1L65rPZ8?=
 =?us-ascii?Q?zAuVLkmS7+dmy0EQeUZ1bQdbFBtPH8tcTAaX9koPk2HUxfdV6qyXnERN9LhM?=
 =?us-ascii?Q?dh2A5YFFt1cSJ7yp05uKRr9A4o/zGch7Tz5EbTeF/NBsJYVkh6AW4C/WrisX?=
 =?us-ascii?Q?EwSTQbPyVLq1HtOlOh31Me1Dh3w11QFV2j38ORbbrHd4Lz7sOyIeQ3XWp8cZ?=
 =?us-ascii?Q?sjPqcbCA8K6BpOtCsTxNw66xurJp4UxtDrtQHPsavZAzSW12bGqHOEdsQNM3?=
 =?us-ascii?Q?AFZCn9Z3ezbbaH4Ul0AJI3Y4zx9u9HgUYXiqVDiumqTSifHxSeogY59NnBZp?=
 =?us-ascii?Q?Qmvh8LprgE5LoBcR+U0=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(1800799024)(376014)(7416014)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Nov 2025 05:27:39.7045
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 078c44a6-755f-4a20-6b40-08de2019dd9f
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SA2PEPF000015C8.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB8133
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 2928DC0003
X-Stat-Signature: yydi3zsousmxpdkp19cy5oj39o515soj
X-Rspam-User: 
X-HE-Tag: 1762752465-542696
X-HE-Meta: U2FsdGVkX195djsF8Y7uEcoJqJMBjfHZ87kZpvPdXj5GSo+Oas+mW1u+ACaHcW57dCj33XLkvDzqP1sVKm5GN11IF+7EFSto/4HocQXqL+CAu7izIhIzoniuBVVmqKzeb7m35FfQK7JZ8V7b9AWSFWC4kpineZv6IgI87xUSr/EdVELdWOJ/FtFZbYJsbxDJQfQ7iTlT/bpkwFzgaiRNq6OP7OmX4ohgn+ntu2tw4Q2uQjSfTfCbU7duR1tIeCic1Yz/2xxFJ+kAKc0tXGeEyzgcsW1ozJ2oS+n+/2KZG8Hnm6uSeOh55XoWnNmqPB+NRLGRHUMgD7dmZpy2anjT7AxwNrf9sjNqbYhamIacLtn7WvSWA1L8jR3t8opKMXEL/RDPsWauKxNr2UDS8DFsj+hry+MK0MkmSeY6MLel4mUoi3qKK45ej7GNq+NcdvGE17k45QJiElepqohr5DiNfPUsH5MFIdxtS1mz3O1E4ASnA6T7LjjwYviI9Ez0MZaHX8HCD7zUq51ndzMjcge5TRz2Tmcq4RQgMJNYKt4PMlDbZP4LFLDCIPGc+VXpUG/u51h8OJb1As40tbIGwrEMukquor7NdSguQj/2nDb+j9GDz87BJvUg3xKTFRMsqjdf63hTycLKaKmKg3aFNqNm+yaz2K42aGigmtrkrMqflfjq9djEFcEd6FdgIKSdiIOkIJwv2HCnkt4ZpwNpLiy3GCqiWA/XXrjlw29SvL2qEum9ki+cPGg4ab88QRHMSuoV2uZ3DR8yN+O2BMJSE7xjfmCSj4DIMlXRJTFeZ7IdlF8LUSET3i70vgGD07WOHWzzAT2ZNk8F5l4RDt8sb0KeNobvMlNqCwQDcGhju3mGGw0rXH6tQWVYGAZm6piNU7jtrUOzZbUGlDWFOl9PPMpUFCflzGYIQ1xhda6cqSM/pb3p3ivy2JudIcziPBq6VzKnHBJcXreV5/S+eQ2PJMj
 eX8vOU1n
 GJb1uV4iBoklg1fTqB0KTr23JSxYwTEdy49Ch6A3Z6Cl/pKo5FR544mMEpHL+qZZuG0i+mxoQBP0zi756Vbw58q8RONQOe5qc6u/qt18WHgreuJqg77Q8rircmXge7nkxy6y5dZjelpLb00tSf5CAm5JHDgwYidS5JavHvHqq6AokwQyzGUjy1KGV1VPn6fs6I7M6bb5sUvuUc2K5P55WO2+IAcJhc4j+M/s5C9/EdoFcgbRDYhVmskBXErYIEfYzyaTOm0xt9+L+BU2TR0FbCB1l3wLaiHxNkrX7wYJQVpPEkniRCWP1XPHvq7z+8kAXfb3vEz3/AYGDiwia31UXN0K5P/DQt2+Yhfd00sxIp4c2tliSKbgxjbzfFkCM39i2lb/Tp37VnGPwnGXK13hZG7o+8hWqM/bE7Vz3liSlAuS7MSBYCVgstZgxmIPwcFS3IWSdVJm12MjwGOlVIM7kg+zkQA4HaC5WtO3dUWaWjvpo10UnfTk1IQ84Ql2vyTNlJpDaAufnnscl0d8=
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
index 7238ddf18a35..f42b21b61461 100644
--- a/include/linux/pghot.h
+++ b/include/linux/pghot.h
@@ -42,6 +42,9 @@ enum pghot_src {
 #define PGHOT_FREQ_MAX		(1 << PGHOT_FREQ_WIDTH)
 #define PGHOT_TIME_MAX		(1 << PGHOT_TIME_WIDTH)
 
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
index 25970dbbb279..31ab33e85cd1 100644
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
index 1d1b74950332..4a0b7fb195e5 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -39,6 +39,7 @@
 #include <linux/compat.h>
 #include <linux/pgalloc_tag.h>
 #include <linux/pagewalk.h>
+#include <linux/pghot.h>
 
 #include <asm/tlb.h>
 #include <asm/pgalloc.h>
@@ -2050,29 +2051,12 @@ vm_fault_t do_huge_pmd_numa_page(struct vm_fault *vmf)
 
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
@@ -2083,8 +2067,10 @@ vm_fault_t do_huge_pmd_numa_page(struct vm_fault *vmf)
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
index 74b45e258323..435fde53c993 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -74,6 +74,7 @@
 #include <linux/perf_event.h>
 #include <linux/ptrace.h>
 #include <linux/vmalloc.h>
+#include <linux/pghot.h>
 #include <linux/sched/sysctl.h>
 
 #include <trace/events/kmem.h>
@@ -5989,34 +5990,12 @@ static vm_fault_t do_numa_page(struct vm_fault *vmf)
 
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
@@ -6030,8 +6009,10 @@ static vm_fault_t do_numa_page(struct vm_fault *vmf)
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
index 7c1a32f8a7ba..07bf987ca6f9 100644
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
@@ -19,6 +22,8 @@
 #include <linux/cpuhotplug.h>
 #include <linux/pghot.h>
 
+/* Restrict the NUMA promotion throughput (MB/s) for each target node. */
+static unsigned int sysctl_pghot_promote_rate_limit = 65536;
 static unsigned int sysctl_pghot_freq_window = PGHOT_FREQ_WINDOW;
 
 /*
@@ -100,6 +105,14 @@ static const struct ctl_table pghot_sysctls[] = {
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
 
@@ -193,8 +206,13 @@ int pghot_record_access(unsigned long pfn, int nid, int src, unsigned long now)
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
@@ -220,6 +238,110 @@ int pghot_record_access(unsigned long pfn, int nid, int src, unsigned long now)
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
@@ -287,6 +409,9 @@ static void kmigrated_walk_zone(unsigned long start_pfn, unsigned long end_pfn,
 		if (folio_nid(folio) == nid)
 			goto out_next;
 
+		if (!kmigrated_should_migrate_memory(nr, nid, time))
+			goto out_next;
+
 		if (migrate_misplaced_folio_prepare(folio, NULL, nid))
 			goto out_next;
 
-- 
2.34.1


