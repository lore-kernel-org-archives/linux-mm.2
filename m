Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2D568CA0EFF
	for <linux-mm@archiver.kernel.org>; Wed, 27 Aug 2025 17:56:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5E9176B0024; Wed, 27 Aug 2025 13:56:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5714F6B0026; Wed, 27 Aug 2025 13:56:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 439B56B0027; Wed, 27 Aug 2025 13:56:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 2E49F6B0024
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 13:56:44 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id D5C151DDFDC
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 17:56:43 +0000 (UTC)
X-FDA: 83823292686.12.37990D6
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2040.outbound.protection.outlook.com [40.107.94.40])
	by imf13.hostedemail.com (Postfix) with ESMTP id E70D72000C
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 17:56:40 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b="jD0Gdc/X";
	dmarc=pass (policy=quarantine) header.from=amd.com;
	spf=pass (imf13.hostedemail.com: domain of shivankg@amd.com designates 40.107.94.40 as permitted sender) smtp.mailfrom=shivankg@amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1756317401; a=rsa-sha256;
	cv=pass;
	b=EoPEB6n0N+dWU+RMQJceqf7MO/Lx27naW8qrGYVdRwLmlOzCB4ceb0bllGjrZHcVVzv70f
	cstcbJyWrQ73oXmOaDaEmiSiA4ccWi7TsBeDW8w+K9Yr1hWDNyIw9JCkdklhy0MgQdRMJb
	M41QzyRtPC5YikONCXm5gXRk0SsuEvs=
ARC-Authentication-Results: i=2;
	imf13.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b="jD0Gdc/X";
	dmarc=pass (policy=quarantine) header.from=amd.com;
	spf=pass (imf13.hostedemail.com: domain of shivankg@amd.com designates 40.107.94.40 as permitted sender) smtp.mailfrom=shivankg@amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756317401;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lxZI0XnfKEPRmBNAqV7ZPx9xYGIyZsZhBVXBJa35aDI=;
	b=G9dBVwp1hXKTyLdjy9quoKGDOXrU68rYIc8X5rxIViXihgmIRxlOmQXUJQiJ0XI0s08dSN
	wpGYCqAdYfcmsp/X1fExmdVCs0Qu/chTuSZCDcOYjmDtK9rBVVvFIHKpK+v5uB1h+mP5lP
	lrtMWVmgScEChEk/OjPvoGxvB2bSTmU=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=aEC7/5TJXHBZZC3gCYhV7+HH5/SlFdmviSE6GBgTa9q4S4LeifcFhYRBK3E/jtPGDh5faUu1FSlBSk0LF1TyZ+f9ly5URBMD+J5z2Em6gqzXld7rS7YdKaaqwiBQ/ERzI0bincxP63uNA/5cSldvsF6pB9N7DyeM7NJra5hPjgP9xZyBRvVn9WwNpt+omuGW/E0cFS2L4vQynwwfA0WrrOYb71Sei4vF/fKjSd+6N1a464d/DDK0k94fi7TI4PJDVT5fFiA2GxrzDCW6800Ohf7HNbk27mzbKuBrtpfJPbNDlyDXG9nClGyFtwGoAETVp3fNyrv5W1UFp6dgzQhgvA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lxZI0XnfKEPRmBNAqV7ZPx9xYGIyZsZhBVXBJa35aDI=;
 b=PH6AxBlqZ3tU1RZGPE5WLNETD1M7RCDO031JXGYVhy+stdxtUfdD0JySYGHc891PKXSQtGf6sZ+vjv7p5+L8wbRJxDDliQY+qFgYlE31KncMJ7kZwUP5wlWOmMXCiyisz9HLL1zM+hxozl5QkDdDMSHCpLPbv2YeA37ZEqj0k2WQtb1lJJOs46Thr8kklEPIj/uy13Vk5aILzCyKFrR8huJ2ViMrRrEI5KbC0oL/02Hzg0b5eGoF8hbclwhBoOGc8nh3XtWeFA0pZ47bKcIIlXNzkpXGM/rr3jxYIAvs2I9umXqw5+kbcwHTl01k7MZi4niQc22JhjRSV3gzgaBc7A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=infradead.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lxZI0XnfKEPRmBNAqV7ZPx9xYGIyZsZhBVXBJa35aDI=;
 b=jD0Gdc/XPPDF/UCc7T5N0ctccleofEpAn05GYqgKbZXe4aVhMyK/lT193zyFSvsw9KFEzW+H7yFlKN9DAVZ2d60Fp5KwsI0BM6uHcVGDF22KUuhdauMbGDBNM0VQfIbwgD7kQYepMK+oE8KuYWvYVIK9NLYWI+S+e03lxhks3G8=
Received: from SJ0PR13CA0136.namprd13.prod.outlook.com (2603:10b6:a03:2c6::21)
 by PH0PR12MB8008.namprd12.prod.outlook.com (2603:10b6:510:26f::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8989.20; Wed, 27 Aug
 2025 17:56:32 +0000
Received: from SJ1PEPF000023CD.namprd02.prod.outlook.com
 (2603:10b6:a03:2c6:cafe::18) by SJ0PR13CA0136.outlook.office365.com
 (2603:10b6:a03:2c6::21) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9073.12 via Frontend Transport; Wed,
 27 Aug 2025 17:56:32 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SJ1PEPF000023CD.mail.protection.outlook.com (10.167.244.8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.9052.8 via Frontend Transport; Wed, 27 Aug 2025 17:56:32 +0000
Received: from kaveri.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Wed, 27 Aug
 2025 12:56:13 -0500
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
Subject: [PATCH kvm-next V11 3/7] mm/mempolicy: Export memory policy symbols
Date: Wed, 27 Aug 2025 17:52:45 +0000
Message-ID: <20250827175247.83322-6-shivankg@amd.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250827175247.83322-2-shivankg@amd.com>
References: <20250827175247.83322-2-shivankg@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PEPF000023CD:EE_|PH0PR12MB8008:EE_
X-MS-Office365-Filtering-Correlation-Id: ce52832b-9b33-4321-d48f-08dde5930eb9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|7416014|376014|1800799024|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?6D+v3/Nm0j0TRH1xh4733kthLNmgOxH6pMXCiiwUvd4OpnQtP7xe9YF4C6wz?=
 =?us-ascii?Q?Q3nU7X82phmKJ6IU1tk2tO2Soxr2xYfTcZqoTj4brr8bHwxUTEsBXrLtUAOd?=
 =?us-ascii?Q?DzlGWoRxERqSU1HhK9WzqfkHYJcLvwHso0XVhhVa84lDBjLLXXA3U+ZW7XNv?=
 =?us-ascii?Q?irVM7/BxDT4oRZKi7zBVCauoTnYbHmZMt+WT9iiu/fqnK/WrdnXQi+JKrRf+?=
 =?us-ascii?Q?uwIg8WWONGUUOdt4jEmFT3zljKOFG017+MlLgB5RuedqEcU4yHCmBChqeJmB?=
 =?us-ascii?Q?8wk6EJGb4lkjPwqbPUeqnCek0MTW0lUr5UFLu/XNxVSgb/Po0GQtSLGHNq/E?=
 =?us-ascii?Q?f2tj5qfdd4N5fi6OhHKgRnut8Jhs3YGuI1ORg/lYHPCJaF7jpHnHZO0zPuzd?=
 =?us-ascii?Q?sMZkYHXojVRvoC1Tvmz1vthrcyAY7kDl7nXMQrxGqxegnBgnjqrvXPEoIytW?=
 =?us-ascii?Q?7ygf7UowQWk2LPMeLC3a0rAf83ur5tocOAs/lNzhWJrRa1+qv94SpsFPXRrr?=
 =?us-ascii?Q?LWxqhAIQnBMhzM/HlhEwFIyDJBcGxbftofRFL0MLzQF0Ba67VUg/jgw+Xbme?=
 =?us-ascii?Q?zmscYua90/ok9+vyrdYDkEg5oiLhosRSsG6D3dlgK5EP8wBE7zVg5wy6mSjx?=
 =?us-ascii?Q?899GbVu0pDW1F0XSBnOcCGwOht6yKKiRgPa0CJLue1QuVvnI0exDkp0HOPoN?=
 =?us-ascii?Q?5BnYAK5XRIYgEcSKXsex3scOR9LTzkDZN0N4vPMuGDWNpwPQLQL2tt5Zfvod?=
 =?us-ascii?Q?LUnBNljYNbhsGZGrI2DhzWKwE1L3i9/6x3WLmoTUvhs15MqsZUi0WApI6RlB?=
 =?us-ascii?Q?uOEH8Oo5rlx2EaGVWYjXxHfuh+S4bunA0mk2PD71yH8uhIMVF3t3vpJ0k/ND?=
 =?us-ascii?Q?kK2p2oqMOLKsa8b6MKlTDkKwvMLF+WCUbgXDCh+i64FKKjw/k7o15qgIioDF?=
 =?us-ascii?Q?vySVoA8RogK2W2W2DZq0QZZ4Ff84+2WaUIyHwr5UrEbSA5OytEurT4qm85HD?=
 =?us-ascii?Q?RFqmFeEjEwHnQJfyvJdWMCE6y4OnKOSa286llXfoDSQiAb7cVfs6ssAhHdgt?=
 =?us-ascii?Q?V0rOX5/mqNlzBNFjKw8QAV7qcOelT67eSaO9RZokwOu1EsEe+e41QylnRfrB?=
 =?us-ascii?Q?ijfXU7dVeHf2rzXk/p1BKNYIz04nQ7bW8ancfJ9dNWohsU4qqcqiSa0+iOLP?=
 =?us-ascii?Q?jaUbYqtorUkREAD/LWzodQZkmnEiy2mTDzAdaBbpAetI+XEZcgGpcZqdtZ3U?=
 =?us-ascii?Q?OnkGL1RNVGs9WuiYdKt5wuK0yQrilrkVu4a68XmvRnhfe9xTTpw9mS1ub7Qs?=
 =?us-ascii?Q?Idir/X0suU0XgBZtfbPLXFaYVuFEsTKI6bbHQ5lq70dddEV7Dkzn3GrhApqU?=
 =?us-ascii?Q?eOjlGnTK2VbGIEGiWBR36evloSBWfVxzK3mojJJ7aXpxhTp2mD5rrxvwpjg0?=
 =?us-ascii?Q?RbMVxA66U5Co2rbFRICZfhnjJ4wShWSjqT/XmODkpWF1QoNK3mHsBcO1AuQ2?=
 =?us-ascii?Q?mQsMWvdnJ4tJku3Gzuz4AGkCO6sKchFsJjPL?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(7416014)(376014)(1800799024)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Aug 2025 17:56:32.5138
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ce52832b-9b33-4321-d48f-08dde5930eb9
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF000023CD.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB8008
X-Rspamd-Queue-Id: E70D72000C
X-Stat-Signature: e7911nic51peacii6zcwn3xiti8kzij7
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1756317400-332833
X-HE-Meta: U2FsdGVkX18z8s8lFdGfx6IeYm0br2tYB9e68ASWFmTrgXsBJYXcMRoHE2D9UUKGojrNfFUwGRTsflodQu7IFNJEHjAhD4FvQTftwmRO/kny1bHkxDo+Nkbvkx7wDYHhz8iPVrAoaqwO7I54gji3pA+o8n51kJzPqR1nWqUpuFc+LzD/i6Bm3M3Hs9Uat/vzqYkVSX+5E9coGfSbstFMoaEI7TGx8UDpeAAWB/vE1tiBlfpcv0+9+09H+lppU4r9tKJ0DvcwvntNzGJJpESi/8V2AxTJPL4rxETtkBnCDsG4hukeV19hEXHaPxJT3O/ojsV768ISBJhhVZfanbcL4/SX9GomJNTYJ+D2143m9er3+PRdDN5hbkiLEwAhykXQ+lZFrdIzv0agCIlWhjI8q52hVidyFJZO8XerqkRSuM3n79OrOOIXLBd/bAa+R9+ux6Rr7FnMe4TkCVYC4d7hQr11rhJs2II1hroQm6SSiC0/BYEHI9um4igPk8Awl61xOlnR7ZNkWYZwMb/qkmKM6Mwm9wP9+nb86+wLuVf1y3JTVdroeG5/HhGrWmv1cxWP7MQYDJF5C71AReyHa0pC4TIvixGyblgoZxvltpqQdFMi+wB1TJzlJXkUDhplLYUbmpXXa9UGH2nomakjBP45fD+L7DCcitAjgAOlWzTJDmUtsxNn6o2dTTnQ/O6VvO2qBfAm3prjn1O7ow4DMr5jHPxMSyQ9kA7vuhNmN9h1XLNJZDDrXk+lhCQgzjd8UbX84dHoZ6x9M2jgpUsGV6RY8IhAxChqLUJgVktu6kCq8/SnLHqhY5Rhp/fGiqdFdbcDGgNO/0XuM9r/jKkgnytOasmyfpjUbGyJbA37L/rk3YCOGvlHTg4ByXciOswi/DXjHuKdLEW6vo9NMeMuRH47fxMu4nTLHXud8ffPFo1ZKEA2MXWn0E4j3ljmGwbgnzN0Li96CmvNOJPSk8vd14d
 +YR/2ile
 oaqr82+DFzablLskXzbqQB/8zSoAuLDMuUWZvolVzJ9YwWSTcSUbCC/LcrPwSn/S8COkPCiJ4y8fgIPH26jEg7HVe65lyrvi+bkgNTq7jg3gWn36J3nmvxOnzqynJN+9RDiepOWK2PLJitGWEQSHYrYatvKArjFyT4MzoKdUqymy2udxs2Hkk9WzqbcfF+xvleVXNDI6j4B7McjkIn5umdx5EG2iByDknX1VRA2qohXWH8uvZmqwIHsN4lhe1nExy3wQtCWJyUDlHN/NCWdLkF86JgeHaAcziA+V5ifR9Fg9/bMwMyNQIrSbM5XLp4+bIIw23XkhS6QUFY8wLyIC9LCxQrOwM3qbfn8a1E4aEYULrjHfI/tQjEkQxdHTP7towpjQjOo2Q8og0TM7CPOfyrYKVzWeZzSs4jPCA3S+9JcrbA8CCBLuReSR8UUBrdegMKug/FCPUhGqluaZP+4rlS7opu2qQzQ+G6eXpw7EFOjmXFQ6k0akK8p8JPrpGSYD9Vm/zuKHNoudgknkT/qC+CMRueYQvy/REsj64Nc2XUftvoekQE8caKg7WBW3TVTB9PDZLla+tiyIXmQRpXnPNoyuA7yXumih7RWdmdP4KyOGgJ6GLEYwpI3dXdg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

KVM guest_memfd wants to implement support for NUMA policies just like
shmem already does using the shared policy infrastructure. As
guest_memfd currently resides in KVM module code, we have to export the
relevant symbols.

In the future, guest_memfd might be moved to core-mm, at which point the
symbols no longer would have to be exported. When/if that happens is
still unclear.

Acked-by: David Hildenbrand <david@redhat.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Shivank Garg <shivankg@amd.com>
---
 mm/mempolicy.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/mm/mempolicy.c b/mm/mempolicy.c
index eb83cff7db8c..3d797d47a040 100644
--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -354,6 +354,7 @@ struct mempolicy *get_task_policy(struct task_struct *p)
 
 	return &default_policy;
 }
+EXPORT_SYMBOL_FOR_MODULES(get_task_policy, "kvm");
 
 static const struct mempolicy_operations {
 	int (*create)(struct mempolicy *pol, const nodemask_t *nodes);
@@ -487,6 +488,7 @@ void __mpol_put(struct mempolicy *pol)
 		return;
 	kmem_cache_free(policy_cache, pol);
 }
+EXPORT_SYMBOL_FOR_MODULES(__mpol_put, "kvm");
 
 static void mpol_rebind_default(struct mempolicy *pol, const nodemask_t *nodes)
 {
@@ -2885,6 +2887,7 @@ struct mempolicy *mpol_shared_policy_lookup(struct shared_policy *sp,
 	read_unlock(&sp->lock);
 	return pol;
 }
+EXPORT_SYMBOL_FOR_MODULES(mpol_shared_policy_lookup, "kvm");
 
 static void sp_free(struct sp_node *n)
 {
@@ -3170,6 +3173,7 @@ void mpol_shared_policy_init(struct shared_policy *sp, struct mempolicy *mpol)
 		mpol_put(mpol);	/* drop our incoming ref on sb mpol */
 	}
 }
+EXPORT_SYMBOL_FOR_MODULES(mpol_shared_policy_init, "kvm");
 
 int mpol_set_shared_policy(struct shared_policy *sp,
 			struct vm_area_struct *vma, struct mempolicy *pol)
@@ -3188,6 +3192,7 @@ int mpol_set_shared_policy(struct shared_policy *sp,
 		sp_free(new);
 	return err;
 }
+EXPORT_SYMBOL_FOR_MODULES(mpol_set_shared_policy, "kvm");
 
 /* Free a backing policy store on inode delete. */
 void mpol_free_shared_policy(struct shared_policy *sp)
@@ -3206,6 +3211,7 @@ void mpol_free_shared_policy(struct shared_policy *sp)
 	}
 	write_unlock(&sp->lock);
 }
+EXPORT_SYMBOL_FOR_MODULES(mpol_free_shared_policy, "kvm");
 
 #ifdef CONFIG_NUMA_BALANCING
 static int __initdata numabalancing_override;
-- 
2.43.0


