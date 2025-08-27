Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DB4DECA0FED
	for <linux-mm@archiver.kernel.org>; Wed, 27 Aug 2025 17:55:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 19EF28E0002; Wed, 27 Aug 2025 13:55:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 14F998E0001; Wed, 27 Aug 2025 13:55:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 016948E0002; Wed, 27 Aug 2025 13:55:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id D8A518E0001
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 13:55:16 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 8D8CEBB511
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 17:55:16 +0000 (UTC)
X-FDA: 83823289032.24.BB4CF00
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2071.outbound.protection.outlook.com [40.107.93.71])
	by imf28.hostedemail.com (Postfix) with ESMTP id AB739C000B
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 17:55:13 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=g827RGIi;
	spf=pass (imf28.hostedemail.com: domain of shivankg@amd.com designates 40.107.93.71 as permitted sender) smtp.mailfrom=shivankg@amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=quarantine) header.from=amd.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756317313;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=8ftMmDOFMjejJvDjBTrKWY03TXiMqFTDHYCYDhcRj58=;
	b=SdYnnzH6iB01EI2m8UHkb1lUhmhykSl6z9hbv9wFZGqM8LbXprH80lKzdf9XchNcrFn0kH
	chs1ETxH7TMPBynH2TIYQ0jO4tWwx0wJchOKDopg28f1M8i6+MzCU+DVgYx7haXK5niFIp
	jrz4BQRtEeiASLRlgmKZzc1JXr8TmkM=
ARC-Authentication-Results: i=2;
	imf28.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=g827RGIi;
	spf=pass (imf28.hostedemail.com: domain of shivankg@amd.com designates 40.107.93.71 as permitted sender) smtp.mailfrom=shivankg@amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=quarantine) header.from=amd.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1756317313; a=rsa-sha256;
	cv=pass;
	b=YIu79nSxZlWOjhjvtu6PLAo8VW7Eh7OQ/Vp6hYYNJ8pZTMkSEI7eKmKcMDpd0+wYS+H+DP
	LWBEphZ99a4U06Fol17CwTYCCgw5THCkHfGdYNqaoNDMiHbbbQzlELQnMYIgk+vaJ0ka9F
	/GHu8pJph3pa2Jhm2jbW1SVLnoxYvCo=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=RjDSF89s8YNMUj0dWtmynEZbC7gAJ4GCh7UAvOuIigaoEbKpauUhjclW3WZICGQtIDz2rJTe4lQ8WGHKvorya7cQqOhSNRv78ow4WImkw5x2BNl1+JQ6BgyOcZ2Nl0pZoHt6IDuDEc4EvHGlaRKUTDnJCFytxtO3X89ODNk05I3bT73HCcDAh3S3Uq0FlwcL19P/l0WJBzml/eC8ICtgXr/HmrbDIvGGRT5mtkVSQBuuma3OHWUTvQcZ0eZkFeJx1NgJz7yYG3SEvKaMz37vlwQ52om1/Cxz7oLh+2Rm69SHMYMEalhWGSmb+cr4ozKqKVe0i6NAu+D2VZOag34l1w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8ftMmDOFMjejJvDjBTrKWY03TXiMqFTDHYCYDhcRj58=;
 b=vkFEUdIKSdDdIyFT6Pz5rLL+mcJ8Gl9LKoAnDEBM/8DAqsvHJUZyPq/F20b/zmdtT5bjZejSEo+V7jJdzhXjY4tUYRDxZhgYqYeSlFOP50C0KCbmRcrpyBLCam41ztiBs5Bb2umegfDlhxoCx7R4OzQ6wxB4uESLLQdSHU0wjBfV6xmvmP5baz0w3vd63t2i/dStMRSnmjWvaEKTlAPDo5wvlU1ehabNT2tRtIhedpgVBdQnTDNmp9o1xxXvrY3m9tjH0nCaIIZhDEKnhcEwGFJzIxFC+oaTXz69HgJ1+zV8BOc5FjydTt+kad9JWLESuVnGuCqCfo3+ZfBf0fh8Bg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=infradead.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8ftMmDOFMjejJvDjBTrKWY03TXiMqFTDHYCYDhcRj58=;
 b=g827RGIiwqJFVqmLBtC2Ya0/nBa4yymvYeW2hAtnYkEzJRgYVH+ZaPXMXFS/JUrDU40Emsm/zUBoAoM8dZDxKgJJkDsO7v2EaFKT+1PsTSQZHcGK79EiYKZ0n+MQ5NBNBJC8CaOoH0aKdxOAtURjWI79KeiqbEb6syNYmeIN2Fk=
Received: from SJ2PR07CA0008.namprd07.prod.outlook.com (2603:10b6:a03:505::8)
 by DM4PR12MB6349.namprd12.prod.outlook.com (2603:10b6:8:a4::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9052.24; Wed, 27 Aug 2025 17:55:10 +0000
Received: from SJ1PEPF000023CE.namprd02.prod.outlook.com
 (2603:10b6:a03:505:cafe::78) by SJ2PR07CA0008.outlook.office365.com
 (2603:10b6:a03:505::8) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9073.16 via Frontend Transport; Wed,
 27 Aug 2025 17:55:10 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SJ1PEPF000023CE.mail.protection.outlook.com (10.167.244.10) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.9052.8 via Frontend Transport; Wed, 27 Aug 2025 17:55:10 +0000
Received: from kaveri.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Wed, 27 Aug
 2025 12:54:45 -0500
From: Shivank Garg <shivankg@amd.com>
To: <willy@infradead.org>, <akpm@linux-foundation.org>, <david@redhat.com>,
	<pbonzini@redhat.com>, <shuah@kernel.org>, <seanjc@google.com>,
	<vbabka@suse.cz>
CC: <brauner@kernel.org>, <viro@zeniv.linux.org.uk>, <dsterba@suse.com>,
	<xiang@kernel.org>, <chao@kernel.org>, <jaegeuk@kernel.org>, <clm@fb.com>,
	<josef@toxicpanda.com>, <kent.overstreet@linux.dev>, <zbestahu@gmail.com>,
	<jefflexu@linux.alibaba.com>, <dhavale@google.com>, <lihongbo22@huawei.com>,
	<lorenzo.stoakes@oracle.com>, <Liam.Howlett@oracle.com>, <rppt@kernel.org>,
	<surenb@google.com>, <mhocko@suse.com>, <ziy@nvidia.com>,
	<matthew.brost@intel.com>, <joshua.hahnjy@gmail.com>, <rakie.kim@sk.com>,
	<byungchul@sk.com>, <gourry@gourry.net>, <ying.huang@linux.alibaba.com>,
	<apopple@nvidia.com>, <tabba@google.com>, <ackerleytng@google.com>,
	<shivankg@amd.com>, <paul@paul-moore.com>, <jmorris@namei.org>,
	<serge@hallyn.com>, <pvorel@suse.cz>, <bfoster@redhat.com>,
	<vannapurve@google.com>, <chao.gao@intel.com>, <bharata@amd.com>,
	<nikunj@amd.com>, <michael.day@amd.com>, <shdhiman@amd.com>,
	<yan.y.zhao@intel.com>, <Neeraj.Upadhyay@amd.com>, <thomas.lendacky@amd.com>,
	<michael.roth@amd.com>, <aik@amd.com>, <jgg@nvidia.com>,
	<kalyazin@amazon.com>, <peterx@redhat.com>, <jack@suse.cz>,
	<hch@infradead.org>, <cgzones@googlemail.com>, <ira.weiny@intel.com>,
	<rientjes@google.com>, <roypat@amazon.co.uk>, <chao.p.peng@intel.com>,
	<amit@infradead.org>, <ddutile@redhat.com>, <dan.j.williams@intel.com>,
	<ashish.kalra@amd.com>, <gshan@redhat.com>, <jgowans@amazon.com>,
	<pankaj.gupta@amd.com>, <papaluri@amd.com>, <yuzhao@google.com>,
	<suzuki.poulose@arm.com>, <quic_eberman@quicinc.com>,
	<linux-bcachefs@vger.kernel.org>, <linux-btrfs@vger.kernel.org>,
	<linux-erofs@lists.ozlabs.org>, <linux-f2fs-devel@lists.sourceforge.net>,
	<linux-fsdevel@vger.kernel.org>, <linux-mm@kvack.org>,
	<linux-kernel@vger.kernel.org>, <linux-security-module@vger.kernel.org>,
	<kvm@vger.kernel.org>, <linux-kselftest@vger.kernel.org>,
	<linux-coco@lists.linux.dev>
Subject: [PATCH kvm-next V11 0/7] Add NUMA mempolicy support for KVM guest-memfd
Date: Wed, 27 Aug 2025 17:52:41 +0000
Message-ID: <20250827175247.83322-2-shivankg@amd.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PEPF000023CE:EE_|DM4PR12MB6349:EE_
X-MS-Office365-Filtering-Correlation-Id: be4b3d7d-3382-48fd-86b0-08dde592dd8d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|1800799024|7416014|376014|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?ykdI7UKSSiagd9uFHC0kt0JYKIN8kp69uR7ogMpa28ypxL1LcJ8UT7kDEFvE?=
 =?us-ascii?Q?4CqyEKW8jlNCszRA12tXqJQAtDx/mQpv1zzWZgkVJcupiry9MZpPOmeSqNRC?=
 =?us-ascii?Q?JOiQvBQxzgKK04lgeMjYNZV0/HWzh54V26F/DViE1AEBHQ2Yc/N4S2EM7oM0?=
 =?us-ascii?Q?kCuh/4ZQ5BssUiHo0vsGeC90vcje9zcHaAtrgFQGLGrKCuM9tNSRPh1kIwlE?=
 =?us-ascii?Q?MhJ3PDE8mvCw9rp26Dhi8vz1jtI04jsqDfNPlm6y6f7XkdQhz/lPWZieMbvQ?=
 =?us-ascii?Q?rQXK1alrrDKHnT9yfSZ73rN/LO37W+DtnhIDMH4OApUP92KXskB9FIy60X63?=
 =?us-ascii?Q?+LlKRPwrHiArH/ZdcEiXBy17PDlTnj1IVXZ8btkSGHUXbg3QjiclIGc4tNC7?=
 =?us-ascii?Q?B26OEtotJxXZ3LLO4o6P1OKokagrGJBhNg7vXYeb8ZaVrvvJzX5KDlYvttiL?=
 =?us-ascii?Q?zBAJH7jxJUC1NiieYpMhXgSgzyD0BP5zSwMF9WdB6qAbMQWImGJedhu1+06F?=
 =?us-ascii?Q?sAFcXBuYHnTXuWp0pkyOCtq1t1jA9gw+oVduO43TdKAo3SEZ/A+wsjmhAeui?=
 =?us-ascii?Q?DLCPsLhh1pSjCJ7yapwPF/hPaKi1Io3CFbfsXFXYsMZJug6MdB1aaBRYj8GS?=
 =?us-ascii?Q?jko0K0NQWyXpP1g0jkEqNWa5Flp74tCvHQQ+m9gPiE/7yT4DF3sGU9H+Q/AU?=
 =?us-ascii?Q?Fy4T1Vyp4RYY4r9kZklgeHTvLnNCUCcuhAfMAg2bH6Sn7ZUhhlfk6DhBEVaN?=
 =?us-ascii?Q?Zwft3VzPCzLccZA2j9w85WImgklTyDCiGJh9FvWEQ6/7dqSIyYBdejxFMCG6?=
 =?us-ascii?Q?ZrwWrGbjNr0lVwUG7TtQs8mBTR9/ISAFahzmKbfdBFvzh715WYk6QL9FRYNv?=
 =?us-ascii?Q?hvBOjpk4Y4va4tE/okXT9rR3Hzu0YRRar4WYdB11b5RPx8cF0YI+udop0TlX?=
 =?us-ascii?Q?fGcJyLkqSSOl0mYAMAaCCzD83BoMH+ppm2BoJaGe8DAzSyFno0ZQNY4CWOdD?=
 =?us-ascii?Q?cjhvUd/NlzdMJ25r3Kc0UlowwLxosN4xl7uPxAstWg3AAEu7ZJTgEdOH/W0W?=
 =?us-ascii?Q?F5VLYaYbQ2aQWY3aF/g8Mgsk05n3WmThc4LQsHSoxm+UFUGQOE93s+JtZczp?=
 =?us-ascii?Q?SgaUzt7b5t+RCrEQv3g8kUxq0uyc1rg+6LMi2slQId9nJxXOghuutWPOe5ej?=
 =?us-ascii?Q?SqD1+Ztzu/BkwTbQHjLTqUB6agWL5a1knyyzcmTxBf/ONOuBcDCxD3iPMG05?=
 =?us-ascii?Q?Er1xrQG6J4TDXFvIZjyo5CkSQypOhxooVWGPW19NLvEcUZ9hCvExUr8gP6Dj?=
 =?us-ascii?Q?Oghqrm70i3HBXVgShnhKWGCYc7omzF+mB5OWdzmtr9KC8sy1mAm9HDfnEToA?=
 =?us-ascii?Q?OIpDjBBDqFBFLC469nmTMH26ShLmjqYEL3+ko6stnFB90hwMSIMy9gQmF6bU?=
 =?us-ascii?Q?lCUbpehJHJcU5NQXadXJY95ni2+Co3LzMzlolhfOHHOG+vcZoKggAw=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(1800799024)(7416014)(376014)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Aug 2025 17:55:10.0405
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: be4b3d7d-3382-48fd-86b0-08dde592dd8d
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF000023CE.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB6349
X-Stat-Signature: wcqnkoscuz6muj9g8bpkm71ydmcc5uhf
X-Rspam-User: 
X-Rspamd-Queue-Id: AB739C000B
X-Rspamd-Server: rspam05
X-HE-Tag: 1756317313-903030
X-HE-Meta: U2FsdGVkX1+1zhTUeTpQ9YhppyYtlpsPuCEMG23e2NWT9r0ZwYbPp4y1Dn1Ke3cGghKPY+EQpuP+Izy0gSXSMZe+yGSVtfjK386TNkN2o9Z/jbA46+oZ02fCLCxycttKkOkbO3YIWTi0lvb7WF8ljAZRV+5ZVK/YGGpKCx/lDwtTM8aiF3hH/XiBLYkjW9vTnh1J+imaXsB6bIl3i/JexqQCrguOYeopmNsA6i/8CCmTDAheY6edSmWONVbteH2fgM0ZnYTTWceOcDivZgDTsZKJnKnAdsE8wjOiqw7EJKzjSkh/9/gLhv4AAJibCSMeXkZXeigs6l5n4YhcRnqpEGbfwKWFi9W95soj81C5FhURQTEJchAoKgQ6i4ed3d7Rm9JJNjqMFeUC8C7GfPbzjwrXfKLwXL/HYSawFu/0OlS9bWWuZi/uXQHOQt0w0mDncK0zvmqy2vRKwOwe+/9BP28t4SCm/EXP0TR1O0KNMjdNYvT+d0RGiMPzJVmfD9eRXJN62RT9x5CEsJ12ct4ACm9KmS9f0JbmrlSq7KMgp2MN36E6LrIJfSa/J1FmrFqi0O9okXo4yHjXcyzsj01ceUwUOCudztlSBarwqYZaWWEDWbJ1lQfS/HOsWc3hbbOTaeRF2hnTtAx1iH13u/OFHjHur+nNSfWSevS9FVTlMgwOvfQ0YfmVPez2z8F5kEo2YFdYJwMRcD2ZvQMDR9y+u3rUuPWU3N7mEdxCZfPkhnaq05EdcFC1LnVVs2GfLApk0xUU6I/HdMoHbV0vxE6t+M/dJekshi66sd++EdhSYITEDI3GTSvA2eu3k/s++/C7FbrPP7TnjyPdtlPoobgYV4Rt4CSCy5jvrOpjV6s8e1pXOzpUhz22OvsCYKx/8oNj0ayK/aRnW9XdNp6flNILAJz2dqKI6pHGKGxCv48u3C02owZcNcPDiOYMMioBZA0o/5Q1Xd8JNbcSaaOlFvp
 G52QoNkD
 ++JFjLx/3/IZCF7mcLb8I1B1COEK8FY8XMhq/0l3rzkSzXoeoZFzWEacvJJTq7pEWB2K2Hz1sO7rklh8wSUT992HU9+P9oAcFy4vZsN8DZF1whRqrkP+LXVoAXlM2MLWwCAA8GJnLltiBfdm9+uMIi1K9kQE1gAdXHzQFzPhCxPT0/pVQ8mYuUwOenQPbyPl3ESn99stAk4sAg3Q4cFnf476JcY7pB9A3NyF8JIcKtttihUpjkPYE3UmGHdUnl6ooU4FyaNfjldDNxTqkth0NJmGLceUZelwbsFJvE3cH4aVfxywY9uuwNJxpbT0mlyWGW3x1ByRcwTV7NE925pe2GhXMPNfw1Z6Kfxwu9VRzVhLvJOv3aj36nXonRMfmeNpzkMOEsnTVk5+eSICWXe4XhKE7MRS7W35woPcFXkOFnB9YmQTZof6WInXhcLdbRXKAiqBGH+02LLE55hrK5Omf29WHuEdcJbtnpv1jcveH8iFx5HDWy39pTdks35CpwOivOgx5ZFiHT94tSQ717HfHb259EeCNekFQnzKzLWVvEdVwT+d5VNa3h3WUZF6ZIFBX9BlVpRCiZwYpIH3+Glg9nDeUdogGQafFX7EfrxO48XE9ja2fFAtXiAYNwd5kwXTQHZTgw7DKXd+kjYIOV+cxjmxcNhGF9zYyUjHXqwJJ9q8AXt9cr5Jack+gQq8KOufMVOaL38zojsdDh7UKJXcDQTIY7wKJdLbXlAjIgdMzvUzH6QEk0S5q0DZtrmdw/NicSH2HnIzzCH39YdDlghXnI87CxZrgvqH1ucOj
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This series introduces NUMA-aware memory placement support for KVM guests
with guest_memfd memory backends. It builds upon Fuad Tabba's work (V17)
that enabled host-mapping for guest_memfd memory [1] and can be applied
directly applied on KVM tree [2] (branch kvm-next, base commit: a6ad5413,
Merge branch 'guest-memfd-mmap' into HEAD)

== Background == 
KVM's guest-memfd memory backend currently lacks support for NUMA policy
enforcement, causing guest memory allocations to be distributed across host
nodes  according to kernel's default behavior, irrespective of any policy
specified by the VMM. This limitation arises because conventional userspace
NUMA control mechanisms like mbind(2) don't work since the memory isn't
directly mapped to userspace when allocations occur.
Fuad's work [1] provides the necessary mmap capability, and this series
leverages it to enable mbind(2).

== Implementation ==
This series implements proper NUMA policy support for guest-memfd by:

1. Adding mempolicy-aware allocation APIs to the filemap layer.
2. Introducing custom inodes (via a dedicated slab-allocated inode cache,
   kvm_gmem_inode_info) to store NUMA policy and metadata for guest memory.
3. Implementing get/set_policy vm_ops in guest_memfd to support NUMA
   policy.

With these changes, VMMs can now control guest memory placement by mapping
guest_memfd file descriptor and using mbind(2) to specify:
- Policy modes: default, bind, interleave, or preferred
- Host NUMA nodes: List of target nodes for memory allocation

These Policies affect only future allocations and do not migrate existing
memory. This matches mbind(2)'s default behavior which affects only new
allocations unless overridden with MPOL_MF_MOVE/MPOL_MF_MOVE_ALL flags (Not
supported for guest_memfd as it is unmovable by design).

== Upstream Plan ==
Phased approach as per David's guest_memfd extension overview [3] and
community calls [4]:

Phase 1 (this series):
1. Focuses on shared guest_memfd support (non-CoCo VMs).
2. Builds on Fuad's host-mapping work [1].

Phase2 (future work):
1. NUMA support for private guest_memfd (CoCo VMs).
2. Depends on SNP in-place conversion support [5].

This series provides a clean integration path for NUMA-aware memory
management for guest_memfd and lays the groundwork for future confidential
computing NUMA capabilities.

Thanks,
Shivank

== Changelog ==

- v1,v2: Extended the KVM_CREATE_GUEST_MEMFD IOCTL to pass mempolicy.
- v3: Introduced fbind() syscall for VMM memory-placement configuration.
- v4-v6: Current approach using shared_policy support and vm_ops (based on
         suggestions from David [6] and guest_memfd bi-weekly upstream
         call discussion [7]).
- v7: Use inodes to store NUMA policy instead of file [8].
- v8: Rebase on top of Fuad's V12: Host mmaping for guest_memfd memory.
- v9: Rebase on top of Fuad's V13 and incorporate review comments
- V10: Rebase on top of Fuad's V17. Use latest guest_memfd inode patch
       from Ackerley (with David's review comments). Use newer kmem_cache_create()
       API variant with arg parameter (Vlastimil)
- V11: Rebase on kvm-next, remove RFC tag, use Ackerley's latest patch
       and fix a rcu race bug during kvm module unload.

[1] https://lore.kernel.org/all/20250729225455.670324-1-seanjc@google.com
[2] https://git.kernel.org/pub/scm/virt/kvm/kvm.git/log/?h=next 
[3] https://lore.kernel.org/all/c1c9591d-218a-495c-957b-ba356c8f8e09@redhat.com
[4] https://docs.google.com/document/d/1M6766BzdY1Lhk7LiR5IqVR8B8mG3cr-cxTxOrAosPOk/edit?tab=t.0#heading=h.svcbod20b5ur
[5] https://lore.kernel.org/all/20250613005400.3694904-1-michael.roth@amd.com
[6] https://lore.kernel.org/all/6fbef654-36e2-4be5-906e-2a648a845278@redhat.com
[7] https://lore.kernel.org/all/2b77e055-98ac-43a1-a7ad-9f9065d7f38f@amd.com
[8] https://lore.kernel.org/all/diqzbjumm167.fsf@ackerleytng-ctop.c.googlers.com

Ackerley Tng (1):
  KVM: guest_memfd: Use guest mem inodes instead of anonymous inodes

Matthew Wilcox (Oracle) (2):
  mm/filemap: Add NUMA mempolicy support to filemap_alloc_folio()
  mm/filemap: Extend __filemap_get_folio() to support NUMA memory
    policies

Shivank Garg (4):
  mm/mempolicy: Export memory policy symbols
  KVM: guest_memfd: Add slab-allocated inode cache
  KVM: guest_memfd: Enforce NUMA mempolicy using shared policy
  KVM: guest_memfd: selftests: Add tests for mmap and NUMA policy
    support

 fs/bcachefs/fs-io-buffered.c                  |   2 +-
 fs/btrfs/compression.c                        |   4 +-
 fs/btrfs/verity.c                             |   2 +-
 fs/erofs/zdata.c                              |   2 +-
 fs/f2fs/compress.c                            |   2 +-
 include/linux/pagemap.h                       |  18 +-
 include/uapi/linux/magic.h                    |   1 +
 mm/filemap.c                                  |  23 +-
 mm/mempolicy.c                                |   6 +
 mm/readahead.c                                |   2 +-
 tools/testing/selftests/kvm/Makefile.kvm      |   1 +
 .../testing/selftests/kvm/guest_memfd_test.c  | 121 ++++++++
 virt/kvm/guest_memfd.c                        | 262 ++++++++++++++++--
 virt/kvm/kvm_main.c                           |   7 +-
 virt/kvm/kvm_mm.h                             |   9 +-
 15 files changed, 412 insertions(+), 50 deletions(-)

-- 
2.43.0

---
== Earlier Postings ==
v10: https://lore.kernel.org/all/20250811090605.16057-2-shivankg@amd.com  
v9: https://lore.kernel.org/all/20250713174339.13981-2-shivankg@amd.com
v8: https://lore.kernel.org/all/20250618112935.7629-1-shivankg@amd.com
v7: https://lore.kernel.org/all/20250408112402.181574-1-shivankg@amd.com
v6: https://lore.kernel.org/all/20250226082549.6034-1-shivankg@amd.com
v5: https://lore.kernel.org/all/20250219101559.414878-1-shivankg@amd.com
v4: https://lore.kernel.org/all/20250210063227.41125-1-shivankg@amd.com
v3: https://lore.kernel.org/all/20241105164549.154700-1-shivankg@amd.com
v2: https://lore.kernel.org/all/20240919094438.10987-1-shivankg@amd.com
v1: https://lore.kernel.org/all/20240916165743.201087-1-shivankg@amd.com


