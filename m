Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3972BCCFA1A
	for <linux-mm@archiver.kernel.org>; Mon, 10 Nov 2025 05:24:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 783318E0006; Mon, 10 Nov 2025 00:24:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 734078E0002; Mon, 10 Nov 2025 00:24:17 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5FB588E0006; Mon, 10 Nov 2025 00:24:17 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 3D1CA8E0002
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 00:24:17 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id B171F13C1F4
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 05:24:16 +0000 (UTC)
X-FDA: 84093556512.26.65B6766
Received: from BL0PR03CU003.outbound.protection.outlook.com (mail-eastusazon11012060.outbound.protection.outlook.com [52.101.53.60])
	by imf30.hostedemail.com (Postfix) with ESMTP id CB1A280008
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 05:24:13 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b="2b/0FO/W";
	spf=pass (imf30.hostedemail.com: domain of bharata@amd.com designates 52.101.53.60 as permitted sender) smtp.mailfrom=bharata@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762752254;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=6f77WuQFVOI3Wy79jpUlifALDd2tBwA/m02GWw+4I24=;
	b=KXIbNKFiz28g0sIOO3YwJqM0qjoYYl9u1/h0CnW38sh2NL8gFgs/WAMLRppWr1cPwdCt0i
	tmgVHLJ6m0kWbiqTTw1FACzTf7ZXkfdI9mbzZ0UL9Xsxcw2zhpzZg91csN2KvEXbRpChyn
	Njh6p0lBoXtDz73tvD2roczlzO6DkmU=
ARC-Authentication-Results: i=2;
	imf30.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b="2b/0FO/W";
	spf=pass (imf30.hostedemail.com: domain of bharata@amd.com designates 52.101.53.60 as permitted sender) smtp.mailfrom=bharata@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1762752254; a=rsa-sha256;
	cv=pass;
	b=3w+fhBzcWrbj5OoiCLs0BNNaOH8Ew6GrZKNZ9MBEKO8WrKVBRfzLtR4ojYeGqlxJxc9ryC
	fHSS9GXRkClemdxLv+q+0fpwOPG3CF77QBDE4uqBGMusZab49RrCEqieGjagKMQdZ5/2GX
	ilpdoYcUzVoXJEe5RPnfJ+UvLgMadAo=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=DM2gFmw+tKhwly320sLG08jy+9vWrQ0bns/f+yZJL96QckCM1csKdcQ4hXFq395FrsaKLAcfHAI2ChNtTLWODmT3vjSFfcfxGquMwuG/IsK1FQRiDs13colj9EwYD40YkIzK2BnpfZSqLO1t7CN/t2Tb35cIUvmL9WocEuVcpCpZNe42YV2h6wogjmm8g9K9esErGlc1iwEdGmgk+do02GapVzkqCzH0k5250qYKGFX/sw4x/+dPypWSXqoRE0EzaWUtJHkfZx7i/YFUFi3Cz4PrXJeBYKm2v5SL9rXljy09OLknCf4XDXHopFkuyTxE6S4w317pam5HM6bkD1BBJQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6f77WuQFVOI3Wy79jpUlifALDd2tBwA/m02GWw+4I24=;
 b=e7dpMJxQY28h5UGddITgsdRtYWkvfuXvfr3JNk6nJzjIeglBM8n3QA231jd2bF5NCUA53aXYC3YtpDb+aLk+WVx3awCJbX1c/aHGkbU8JbevGaVxfbb6BVLTStdaP3iwGra8Wb+ETebuZVlgAXTfOcP2ZCz7lCaJAGk+9pTGMtw3OMLzn1a0AYctWuIXSnp6qBo65tbW+T2gZejjwuqMPSeiPMTBSEUdF8egNLnLDIHrC7FEcMVH753RODPm5sHHwfmEqEqkbWNCHy3PZyL6ZeAHYrIw4P2k8kZT4Otlz+R9NUZ0KxBp1QbaCvoXUEXgICphMcc69PMfNO4AjoKXig==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6f77WuQFVOI3Wy79jpUlifALDd2tBwA/m02GWw+4I24=;
 b=2b/0FO/WTU+bGh6sjGd7ca+sswbDaJMZCoN4Y3/LaoXaNb7YjQXTEGOmmtIexlAzvkl9Rq0CoF6Gpz7mbF/PuXMLFzLzY8l9FVjyldxVwoezPM/a6GGL876QHWhJE9GjPXtm/yWcl7TvnqN+70oAPw+t7XhmmoAVHpqKwu3EwYs=
Received: from IA4P220CA0005.NAMP220.PROD.OUTLOOK.COM (2603:10b6:208:558::9)
 by CH3PR12MB8260.namprd12.prod.outlook.com (2603:10b6:610:12a::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9298.16; Mon, 10 Nov
 2025 05:24:09 +0000
Received: from BN2PEPF000044AB.namprd04.prod.outlook.com
 (2603:10b6:208:558:cafe::c7) by IA4P220CA0005.outlook.office365.com
 (2603:10b6:208:558::9) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9298.16 via Frontend Transport; Mon,
 10 Nov 2025 05:24:20 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 BN2PEPF000044AB.mail.protection.outlook.com (10.167.243.106) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9320.13 via Frontend Transport; Mon, 10 Nov 2025 05:24:08 +0000
Received: from BLR-L-BHARARAO.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Sun, 9 Nov
 2025 21:23:59 -0800
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
Subject: [RFC PATCH v3 0/8] mm: Hot page tracking and promotion infrastructure
Date: Mon, 10 Nov 2025 10:53:35 +0530
Message-ID: <20251110052343.208768-1-bharata@amd.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: satlexmb08.amd.com (10.181.42.217) To satlexmb07.amd.com
 (10.181.42.216)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN2PEPF000044AB:EE_|CH3PR12MB8260:EE_
X-MS-Office365-Filtering-Correlation-Id: 4e135adc-b43e-4dfa-92f3-08de20195ff0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|1800799024|376014|7416014|36860700013|13003099007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?tuuflDwNDKAZsSGvRv2ggnnchnUF5WfokbjN4ZSwbb1/ve+myUVDbZt28ZPR?=
 =?us-ascii?Q?889Qjutdg19WhZAlDNm/wnOTk4CsA0lwehXOmvUqNBSUQvDZ3/+2jQ85bCJi?=
 =?us-ascii?Q?+ahRki8AlVnHeIbQwZct+Nw1Ytn4LP7ffkAC86E6N6FOz1WVc6gQ4FuAnQ2w?=
 =?us-ascii?Q?BUG/ukr9fnQQdYbWX7qzQ9c/0aR1URskY4GGffEmiYCILMlX4FIfDQlhDDpr?=
 =?us-ascii?Q?aU1oOPXqPM9jCIpIbwrPEAwj9i+01MrpTK7B1zS/Yi7bP11MELg1391GzXKP?=
 =?us-ascii?Q?LKIgxqWlifkGf64rrkfkKxVAWuIQ2dUvqNrBg6GTf8OYwP7ylfIVeKJ2163Z?=
 =?us-ascii?Q?smtC93W+VvPEIc00XxwZ8GNO+7Q21tAoKqRTYJ+jtVlPt12xO1TTS2yLAZYE?=
 =?us-ascii?Q?OxgoBuGuwLRYpxb1XG4qv5ZB6vIAo9fuw3Z/lSsOkuD71Vd9yqXyWOQzdSOl?=
 =?us-ascii?Q?NUyiGRC/al6opnH6MePF29+tk1f3YZzUB/gms66QwWGi9H2BGvkawvc6Oqju?=
 =?us-ascii?Q?/07ZYcNy2Lg68u3lQdP94XfTrSpZVaL0MtrxCP8k2secIOgJxm5d8mKhm9nS?=
 =?us-ascii?Q?EYR4CPZ5CQry1F7yV7FIVlvm+nMhEmvJki6aQhYk7IlB6bNx5hZq8V8tff/g?=
 =?us-ascii?Q?LYAQusgWJhD3GXc1cLlj9hCCRpRvxxEQWy2yKc7aq1NJ/TIChfcbPfYSPKJ7?=
 =?us-ascii?Q?uzk3duosdwq3vA6pQwRFnFi6u1jluTiHm5jihDPJDL/0EWyb6PYHOkURq5s1?=
 =?us-ascii?Q?GeaOXhgrs02If4tH0JktQfZOZIqheZ5HGayTn5C64uVzAz92zZxKMzB2B7fV?=
 =?us-ascii?Q?nTnLWdnqaEOVm6dATVjsWI46iy4gH5NGTRkpA/MIyhWOnJH21ICC6bEs9MA3?=
 =?us-ascii?Q?pEDqaze14SNnNs0xvYaoR6IRwi2vuKEAXlbqIib9FQGwRlaZdoBnHALRO1rM?=
 =?us-ascii?Q?oNQnmhBquI1XmVUEF1qpP9oTF2sZQWMA1K3gzYy15mQi3rw3QzCO7htpRx7P?=
 =?us-ascii?Q?pLNRENVq7u/R1oE3TEWmYXsyhXEXQsuGliI306gTwX5QtFtxhUIi0r/aIjIo?=
 =?us-ascii?Q?9ZSz6F/6gMLJFMOmb5tMAyJiD+7+otk4Y4AJkSE78lkOOAJjXdcr74kX6VwL?=
 =?us-ascii?Q?UNk6jHtUyGOfQHBeAR/2c42uteXV+gYYyW4CDp0i3hy5YddK9dusr/4JiW0I?=
 =?us-ascii?Q?VZmYvxk9RlWc/6nCEjfwQDpCFWV3yiABxDpVv7fa7kBscrM4+Tqo0HacFHFb?=
 =?us-ascii?Q?WaaE8nVJ8xpF4aQHwxgWMiX7TImJM19Pwvt6Ma1ouoA14TvO7htzb3n1zTDU?=
 =?us-ascii?Q?XAUwd52cIc0eE7heDuz8s17Jx6IOMSCQabZa2pu0FDqCv14N7std/pi8c8DC?=
 =?us-ascii?Q?QJ/OighFTzTxRNXHRrSBMwZIYdilV0eTZpwzYMp5r0/kGh8tH56ge9Zb0OHu?=
 =?us-ascii?Q?Tnwzct4zVqE6FiODvaedpAsxP5qZyT6iQ6lHn08Uzc34MHv+zt474dmIKaQ1?=
 =?us-ascii?Q?UckZYxv1NvcT6kAWswc7EvNxmlMDgQfn6vggR0pOmbdt5ZK8vqz5QFT/Wlwn?=
 =?us-ascii?Q?m5haQPsdIuvCIKfc/F8qCd7TVXvzaWjk/NsXtMPA?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(1800799024)(376014)(7416014)(36860700013)(13003099007);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Nov 2025 05:24:08.8644
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 4e135adc-b43e-4dfa-92f3-08de20195ff0
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN2PEPF000044AB.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB8260
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: CB1A280008
X-Stat-Signature: ncrgcwg4yx74aabh57ke5jq1edxwjmcm
X-Rspam-User: 
X-HE-Tag: 1762752253-172334
X-HE-Meta: U2FsdGVkX19nnrlBFjOqERJxcNCvIyx0c+sU/E1TThOX4Jph82Hq7AsjYWSPnt0aGbbyZSLPB0at9XCa2oIoGxs//d5MrZOx8xOCbfXw0+/Ayjx3WfAmG2qKT/uLX7W4WtVLquCtTinR0Kq8ZO0XV1/YenEcYc1ntotCXREH/dhWEye7lgHMor/RV3JFf94n51rFhPmGdXVTrZ5UZtQhpZTZYXeCTuhEAq/Ka0+J5PCFjTiS3OlGyRU/ZFYmwyYYMmv6KxHyEFyHkRGZFs8vHN/Gzr3mqtkDgFQAE3rycT4PMl4aF+wSBEQ0r1ucl7WfDcwuomKjnNg8VQ//UWoWJljp71Oz0o28kzwjWjlbUrg3IP8DeUP9t2wdxIrR0DBMV8H8ZMLe4vFfFZFrUxj6LdJlQnXOc/L2zTpTtsLmK301VB8YI1U9tk63K/zeqOabDUxFSo6hr131fiL7ZvTIj6b1TylOvXIbB+pW/aAQc292tbsdi2DszsM88uPK3H40mKWJP/6gg0kUVltBIg5AqxoyFMUQm4QFozkjyMRHuHArkGs4DJOgU8an4FKzt/nzRKa5GiRxwVRXaJGAcwRbthPRx8GswSJRV6Y49vyK2XszrfSWE3ozEGr29ZZ7E8F7QQeHwGsPVYyWfobny+uuAb2YcWKCfgsXkgsaa1tKd3ewPirj3eaNNKH426wAAa/aaM1jGiXTulmY9KQDnLATcJb36SDZTqFDUXVYpFr8cLqRLx3lyU9D9eDbXtDx0WQ/cTOL2lzM37IVecHEs+dpuioQUUADW9+i6/keApcd6ue3VzUU0dxrUezxpymWugL7VgeHFZDsCF8DhLnaEavEym7mhNIq2JnLdgeNvcCORZ7IaNxq9lWZ8rnx/avj+3Au//FTRuZv8SR/jjn/D5x/G6nAl5ro5nsCQZ6zmQY1JCQOcp8HLDJ3P08JplwCPnwI9M2Xtxjp1XdWIPJgyAB
 5bxR2OvC
 K+Ox/C0LCtVTUeuas5c7VnRuz21f2OAFjt+QFv8AmgqWvRiZfYM9XMf3eP7yN58vQu4hpbhOd5BkMhas07dtq9Ukv51Z+G3VKIr5SRzUrQD6CXR/ey2WQBDdoKnaf26/yJMCm8GSD272I5Kn4gJSYdINhYgg5FC9Ysw4lLF9ZcHnoDtp0RM+6pv30gOyYK/oRo7dpttTWouZLIqwrX1zydrFbN9jGFBGZCMhhhbr0Zmewq4CPb95qIVvYafF6kdo+zx1sIIxuYb7+U0i/q4JC6DOBJ+3Ik/OBfryXZaThwrSdp2SMPjFWvRVsBOlJfn+66L1D5MxoJKc6BPk4B7riEQntm33otE2KTFNlqo8wBcq0fBDh1ptcq0YTJoFtlsZ9iMRQkWSPr/8huk9wxGuwfxWpiKs3PD7SNxkpCgdbUzkCoshZCBl1PueD1f2z5iiX9qzy5y1DixdJdpym1dj5E95+oh7W0/e8Oo5hOwF3y4JudZZAsdXnifuEcWlxQfoubhduAw5h9ulZlUa2j/dhbeowwx8IyhGqk5ylP7pAJXrDZ335eZ6dC8Eo+S7DC6Mtx0r3
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

[If someone wants to be off the CC-list, pls drop me a note. Will remove from
the next iteration]

Hi,

This patchset introduces a new subsystem for hot page tracking and
promotion (pghot) with the following goals:

- Unify hot page detection from multiple sources like hint faults, page table
  scans, hardware hints (IBS).
- Decouple detection from migration.
- Centralize promotion logic via per-lowertier-node kernel thread.
- Move migration rate limiting and associated logic in NUMAB=2 (current NUMA
  Balancing based hot page promotion) from scheduler to pghot sub-system to
  enable broader reuse.
  
Currently, multiple kernel subsystems detect page accesses independently.
This patchset consolidates accesses from these mechanisms by providing:

- A common API for reporting page accesses
- Shared infrastructure for tracking hotness at PFN granularity
- Per-lowertier-node kernel threads for promoting pages.

Here is a brief summary of how this subsystem works:

- Tracks frequency, last access time and accessing node for each recorded
  access.
- These hotness parameters are maintained on a per-PFN in an unsigned long
  variable within the existing mem_section data structure.
  Bits 0-31 are used to store nid, frequency and time.
  Bits 32-62 are unused now.
  Bit 63 is used to indicate the page is ready for migration.
- Classifies pages as hot based on configurable thresholds.
- Pages classified as hot are marked as ready for migration using the ready bit.
- Per-lowertier-node kmigrated threads periodically scan the PFNs of lower tier
  nodes, checking for the migration-ready bit to perform batched migrations.

Three page hotness sources have been integrated with pghot subsystem on
experimental basis:

1. IBS
2. klruscand (based on MGLRU page table walks)
3. NUMA Balancing (mode 2).

Major change in v3
==================
The major design change in this version is to move away from the hash and heap
based hot page records management and instead use statically allocated
per-PFN unsigned long variable for storing hotness parameters. This was the
approach that I had used in what was called the kmigrated patchset [1]. While
earlier I had used extended page flags, here mem_section data structure is used
to store per-PFN hotness information for PFNs spanning the section.

Advantages of this approach:

- Eliminates the need for dynamic allocation and deallocation of hot page
  records. Also, no more atomic context allocations.
- Removes the requirement for special data structures (like hash lists and heap)
  to manage hot page records.
- Considerable space savings per hot page record (Just an unsigned long now
  instead of 40 bytes per record in the earlier approach)
- Fixed complexity for looking up the hot page record of a PFN.
- No locking complexity but just atomic updates to per-PFN record.

Downsides:

- Not easily possible to obtain top N hot pages list but a kernel thread will
  periodically scan the hotness records of its corresponding lower tier to
  obtain the hot pages for promotion.
- A page may become cold by the time kmigrated gets to act on it.

Space overhead:

- One pointer overhead for each memory section to store hotness array pointer.
  With a section size of 128MB resulting in 8192 sections per TB of node memory,
  there will be 64KB of memory used per TB. Currently I am using mem_section to
  store the hotness array pointer instead of creating a parallel data structure.
  If the latter method is preferred, then hotness array pointers are required
  only for the lower tier nodes.
- With 4K PFNs, there can be 32768 PFNs in a section and hence with 8 bytes
  (unsigned long) per PFN, hotness array will consume 2GB per TB of node memory.
  This will be for lower tier nodes only.

Other changes in v3
===================
- Migration thread is renamed to kmigrated (earlier called kpromoted).
- Most code cleanups as suggested by Jonathan Cameron.
- NUMAB mode 2 is now fully enabled as hotness source to pghot sub-system with
  off-loading of large pages migration to kmigrated.
- Sysctl knobs to enable access recording from different sources independently.

Results
=======
System details
--------------
3 node AMD Zen5 system with 2 regular NUMA nodes (0, 1) and a CXL node (2)

$ numactl -H
available: 3 nodes (0-2)
node 0 cpus: 0-95,192-287
node 0 size: 128460 MB
node 1 cpus: 96-191,288-383
node 1 size: 128893 MB
node 2 cpus:
node 2 size: 257993 MB
node distances:
node   0   1   2 
  0:  10  32  50 
  1:  32  10  60 
  2:  255  255  10

Microbenchmark details
----------------------
Multi-threaded application with 64 threads that access memory at 4K granularity
repetitively and randomly. The number of accesses per thread and the randomness
pattern for each thread are fixed beforehand. The accesses are divided into stores
and loads.

Benchmark threads run on Node 0, while memory is initially provisioned on
CXL node 2 before the accesses start. There are three modes in which the
benchmark is run:

Mode 1: Regular 4K page accesses. The memory is provisioned on CXL node using
mmap(MAP_POPULATE). 50% loads and 50% stores.

Mode 2: mmapped file 4K accesses. The memory is provisioned on CXL node using
mmap(fd, MAP_POPULATE|MAP_SHARED). 100% loads.

Mode 3: 2M THP page accesses. The memory is provisioned on CXL node using mmap,
madvise(MADV_HUGEPAGE) and move_pages(to cxl node). 50% loads and 50% stores.

Repetitive accesses results in lowertier pages becoming hot and kmigrated
detecting and migrating them. The benchmark score is the time taken to finish
the accesses in microseconds. The sooner it finishes the better it is. All the
numbers shown below are average of 3 runs.

Hotness sources
---------------
NUMAB0 - Without NUMA Balancing in base case and with no source enabled
	 in the patched case. No migrations occur.
NUMAB2 - Existing hot page promotion for the base case and
	 use of hint faults as source in the patched case.
pgtscan - Klruscand (MGLRU based PTE A bit scanning) source
hwhints - IBS as source

Results summary
---------------
Performance Impact:
- NUMAB2: 4.5% regression in Mode 1 and 19.8% regression in Mode 2.
- Hardware hints (IBS): Shows close to original NUMAB2 performance.
- Page table scanning: Good performance, comprehensive migration.

Migration Effectiveness:
- NUMAB2 and pgtscan achieve similar migration counts to baseline.
- THP migration significantly improved with new sources.
- Hardware hints show some sampling limitations.

Mode 1 - Time taken (microseconds, lower is better)
------------------------------------------------------
Source		Base		Patched		Change
------------------------------------------------------
NUMAB0		115,668,771	117,775,032	+1.8%
NUMAB2		102,894,589	107,576,615	+4.5%
pgtscan		NA		111,399,698	NA
hwhints		NA		103,232,152	NA
------------------------------------------------------

Mode 1 - Pages migrated (pgpromote_success)
------------------------------------------------------
Source		Base		Patched		Change
------------------------------------------------------
NUMAB0		0		0		0%
NUMAB2		2097144		2097152		+0.0%
pgtscan		NA		2097152		NA
hwhints		NA		1269467		NA
------------------------------------------------------

Mode 2 - Time taken (microseconds, lower is better)
------------------------------------------------------
Source		Base		Patched		Change
------------------------------------------------------
NUMAB0		110,273,416	113,801,899	+3.2%
NUMAB2		71,859,123	86,098,560	+19.8%
pgtscan		NA		71,545,031	NA
hwhints		NA		71,857,476	NA
------------------------------------------------------

Mode 2 - Pages migrated (pgpromote_success)
------------------------------------------------------
Source		Base		Patched		Change
------------------------------------------------------
NUMAB0		0		0		0%
NUMAB2		2097152		2080128		-0.8%
pgtscan		NA		2097152		NA
hwhints		NA		2097115		NA
------------------------------------------------------

Mode 3 - Time taken (microseconds, lower is better)
------------------------------------------------------
Source		Base		Patched		Change
------------------------------------------------------
NUMAB0		30,944,794	30,537,137	-1.3%
NUMAB2		29,773,930	31,184,442	+4.7%
pgtscan		NA		28,580,878	NA
hwhints		NA		28,732,128	NA
------------------------------------------------------

Mode 3 - Pages migrated (thp_migration_success)
------------------------------------------------------
Source		Base		Patched		Change
------------------------------------------------------
NUMAB0		0		0		0
NUMAB2		3754		1278		-65.9%
pgtscan		NA		33032		NA
hwhints		NA		32768		NA
------------------------------------------------------

Results Analysis TODO
---------------------
- Regression in NUMAB2 needs further analysis. The overhead of pghot path and
  effect of batched migration needs to be identified. It is seen that
  migrations get kicked off a bit later in kmigrated-NUMAB2 case compared to
  base-NUMAB2 case. This also needs further investigation.

This v3 patchset applies on top of upstream commit e53642b87a4f and
can be fetched from:

https://github.com/AMDESE/linux-mm/tree/bharata/pghot-rfcv3

v2: https://lore.kernel.org/linux-mm/20250910144653.212066-1-bharata@amd.com/
v1: https://lore.kernel.org/linux-mm/20250814134826.154003-1-bharata@amd.com/
v0: https://lore.kernel.org/linux-mm/20250306054532.221138-1-bharata@amd.com/

TODOs
=====
- Check if the page is still within the hotness time window when
  kmigrated gets to it.
- Per-zone or per-section indicators to walk only zones or sections that
  have hot PFNs instead of kmigrated walking all the PFNs of the lower
  tier node.
- Bulk access reporting may be desirable for sources like IBS.
- Take care of memory hotplug for allocation/freeing of mem_section->hot_map.
- Currently I am defaulting to node 0 if target NID isn't specified by the
  source. The best fallback target node may have to determined dynamically.
- Provide compatibility alias for the sysctls moved from sched to pghot.
- Wider testing and benchmark coverage.
- Address Ying Huang's comment about merging migrate_misplaced_folio()
  and migrate_misplaced_folios_batch() and correctly handling memcg
  stats counting properly in the latter.

[1] kmigrated approach: https://lore.kernel.org/linux-mm/20250616133931.206626-1-bharata@amd.com/

Bharata B Rao (5):
  mm: migrate: Allow misplaced migration without VMA too
  mm: Hot page tracking and promotion
  x86: ibs: In-kernel IBS driver for memory access profiling
  x86: ibs: Enable IBS profiling for memory accesses
  mm: sched: Move hot page promotion from NUMAB=2 to pghot tracking

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
 arch/x86/mm/ibs.c                   | 343 +++++++++++++++++
 include/linux/migrate.h             |   6 +
 include/linux/mmzone.h              |  19 +
 include/linux/pghot.h               |  55 +++
 include/linux/vm_event_item.h       |  21 +
 kernel/sched/debug.c                |   1 -
 kernel/sched/fair.c                 | 152 +-------
 mm/Kconfig                          |  19 +
 mm/Makefile                         |   2 +
 mm/huge_memory.c                    |  26 +-
 mm/internal.h                       |   4 +
 mm/klruscand.c                      | 110 ++++++
 mm/memory.c                         |  31 +-
 mm/migrate.c                        |  41 +-
 mm/mm_init.c                        |  10 +
 mm/page_ext.c                       |  11 +
 mm/pghot.c                          | 571 ++++++++++++++++++++++++++++
 mm/vmscan.c                         | 181 ++++++---
 mm/vmstat.c                         |  21 +
 25 files changed, 1427 insertions(+), 241 deletions(-)
 create mode 100644 arch/x86/include/asm/ibs.h
 create mode 100644 arch/x86/mm/ibs.c
 create mode 100644 include/linux/pghot.h
 create mode 100644 mm/klruscand.c
 create mode 100644 mm/pghot.c

-- 
2.34.1

