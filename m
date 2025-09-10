Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B3E3ACA101F
	for <linux-mm@archiver.kernel.org>; Wed, 10 Sep 2025 14:49:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 186EE8E0020; Wed, 10 Sep 2025 10:49:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1385D8E0011; Wed, 10 Sep 2025 10:49:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EF30A8E0020; Wed, 10 Sep 2025 10:49:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D2F2D8E0011
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 10:49:44 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id A35541A0947
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 14:49:44 +0000 (UTC)
X-FDA: 83873624688.11.14BDB6B
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2048.outbound.protection.outlook.com [40.107.223.48])
	by imf05.hostedemail.com (Postfix) with ESMTP id AD963100007
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 14:49:41 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=YWmvWxOB;
	spf=pass (imf05.hostedemail.com: domain of bharata@amd.com designates 40.107.223.48 as permitted sender) smtp.mailfrom=bharata@amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=quarantine) header.from=amd.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757515781;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZW8f3mmtasve4jS7nsozPRz6pYKyX6pnI97HF4fqtEs=;
	b=s4f/cLzBl1VkH0szqvg45gW14hLWxz6KKWOnRffj8186rfdeqNIl4jWrBbzB0bePZq/sjB
	5B1Ks+j0+9WGV+zc+WCqOCLQ4PLgQZeWttw1TaefIpcWt6aYuhEnxXMql/TvFjxtigOoQ2
	BB4pSQcH7u/sBDhcWN+lY9tSD9RLjtU=
ARC-Authentication-Results: i=2;
	imf05.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=YWmvWxOB;
	spf=pass (imf05.hostedemail.com: domain of bharata@amd.com designates 40.107.223.48 as permitted sender) smtp.mailfrom=bharata@amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=quarantine) header.from=amd.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1757515781; a=rsa-sha256;
	cv=pass;
	b=W+nHVmFJerodLhuKnmf40l+PYEdMuxR0LvOHn12Tik2JUoZ40rUbhVBCo6Ge/Sc3e3v3g7
	FNp9E7gEnCmnn7WG/qBKzG4u7qKZ6jJsfQZgLnbvjW5/Vtku6Zm8ptYc23zZij/m+XL+cf
	fdNGDB0cua/vRlsp9YNIqRKILrF/vQk=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ymNk5KjOPEvJ4q5FMdo7/udAUTG1CoIlFXpz3TSiV1QGmdi3NxH57+2u8lgpmJ9YnV/YNNpnPu4Rwjr/3CYVaxOXpqih3neuBJvd/x4KHjE9n2m2NiatvbBRRBNwHqg9pN2i+RdtBl7yC83qrD7/ekzpdjQ5IynkX3lc118BxH/Hrhl244RI18gn9JaX8i4g8thx1DEEb4Ak6ZqhK53bkDQ2edXz7wmHR35oGznWs73+e4R//86TM4vgyiniijyER8PsGGnqQeufIcV4zjBB1xO4/Et3BHPfENQhG5/VOOvRQdWnVyiRu6Au7UTTRtTwTZEe7C0bMUM2DMkf/3NBiQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZW8f3mmtasve4jS7nsozPRz6pYKyX6pnI97HF4fqtEs=;
 b=LXjWRJ6OaOrDKoKSBiBOALSUr0uQtd7HfWXo3ChsG7zrHW2ou1+AOr1JO6KDNE76eTXlVuRjmo9uHMewi6/QJ3c0bz4UTjAHSd0hLgXinBbGIPub2QC+fkOPQNzVhBbYINhQzJ3qWiJUdXQAXMrmmO5KiCPY4EtX8TSJrb+r1r5fOv02J308d1XP6ZszaIBHXJzA5f9OsTFPDPPC1Dvz/nF6qAXpvuG1lBouehhn0jC+wnB6+XQ3x8q1NbfRsjrR96KdAXFqdgxpbxNeurffN22HUV3XDgztYK0wZ45ZkrGgZDTviZE8lruKOX1oZr4re4z+5bXmikm6YWUr2z7kMQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=temperror (sender ip
 is 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=temperror action=none header.from=amd.com; dkim=none (message not
 signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZW8f3mmtasve4jS7nsozPRz6pYKyX6pnI97HF4fqtEs=;
 b=YWmvWxOB97N+FWIsoN/r3jx9Vl1KND4wSRdi6RIHFZKCBSiYT4NVxO4EF2Y8RL5tMNul/GPTY2ljrtwKx/x+IosWEyslcnoKhddSjRDF3ZTF1iOX4DJLuAaYqw6QUpR1/kgdU4XNVutnr86X4E36leElXNwIPCZfDfq0WMOmdBc=
Received: from SN7PR04CA0225.namprd04.prod.outlook.com (2603:10b6:806:127::20)
 by LV3PR12MB9168.namprd12.prod.outlook.com (2603:10b6:408:19a::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9094.22; Wed, 10 Sep
 2025 14:49:38 +0000
Received: from SA2PEPF00001505.namprd04.prod.outlook.com
 (2603:10b6:806:127:cafe::42) by SN7PR04CA0225.outlook.office365.com
 (2603:10b6:806:127::20) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9115.15 via Frontend Transport; Wed,
 10 Sep 2025 14:49:37 +0000
X-MS-Exchange-Authentication-Results: spf=temperror (sender IP is
 165.204.84.17) smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=temperror action=none header.from=amd.com;
Received-SPF: TempError (protection.outlook.com: error in processing during
 lookup of amd.com: DNS Timeout)
Received: from satlexmb07.amd.com (165.204.84.17) by
 SA2PEPF00001505.mail.protection.outlook.com (10.167.242.37) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9115.13 via Frontend Transport; Wed, 10 Sep 2025 14:49:36 +0000
Received: from BLR-L-BHARARAO.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Wed, 10 Sep
 2025 07:49:26 -0700
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
Subject: [RFC PATCH v2 4/8] x86: ibs: In-kernel IBS driver for memory access profiling
Date: Wed, 10 Sep 2025 20:16:49 +0530
Message-ID: <20250910144653.212066-5-bharata@amd.com>
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
X-MS-TrafficTypeDiagnostic: SA2PEPF00001505:EE_|LV3PR12MB9168:EE_
X-MS-Office365-Filtering-Correlation-Id: 320418d7-c0e4-4f1d-1c29-08ddf079434a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|7416014|36860700013|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?swmZ85A6zBhwxqrxZ02QBSOTq2Aq6quidWtLH9QG5pkTlum6SSsmpq2WyB1g?=
 =?us-ascii?Q?1zZiNrxNnZPfpNOjCe69KYoUadR4Z24I7Yh5uSEBQ1UhMKIHC+F87I0R4P4W?=
 =?us-ascii?Q?KuZPCrYKwtsITZp7KXqAKHjKdw2CLaZgXOrRUnpz0hlx9PrXh5twVo8MDOEX?=
 =?us-ascii?Q?eZArTxem6cw8f4oWeNblvfF+3s2XWnCaWbL0VkQCIGb+9jMDyqzcoxgXmBAT?=
 =?us-ascii?Q?u0M81P+tJzubRZy2cH2Tg6LJ8lQaR5wpvct7/sKIlZa3I3u2qUzdogVdSAPK?=
 =?us-ascii?Q?SHnHTVqMT0evSrW1g0twdUXHednhO9Ggph0rbAtl7tQivX4daCV2HQpudBB0?=
 =?us-ascii?Q?oINYaDGQDZIi0OtD5Ld1SD/3ysdb2/mn1ubUWNFEpuGHOOVKzSUb8mdraTVZ?=
 =?us-ascii?Q?D1I0TfyvS7mUbhXBln1wcJQ8pzwaP0S57Z5e9ogzdF3NNRANGZP1d0eABNwB?=
 =?us-ascii?Q?MFArQ7Tw6Epu6Xsj6PI+Ip+R18PZv+vEvrrLnceLX+0/5Bd6uuzjgQHSZZWM?=
 =?us-ascii?Q?wtBMSIepYNrq9O4UNh04gWLDYrg/jGVC9u9NIsenX0oZDVfDFVhKghHYThas?=
 =?us-ascii?Q?RZ5FH96QhTHe2J+gpbplMAv3DgUfkOG9rXYfnFx1UYl5E0KpyNYF5dQ3n2nJ?=
 =?us-ascii?Q?lYZ/YzrTxyiHo6YeIAQCHGjXTf/uJU3FcjJxUZiw5GC3Km2TS/RK7hYomMn2?=
 =?us-ascii?Q?CKS0ZZTeGtFgTcCpIO/WxPnFBLhiRd/TT5cBnFNACH3iovcgW/An/hjxr8JS?=
 =?us-ascii?Q?hDw2t35dQdUkEwADnWihjvrBBrXcXBYPLwBpOnjAKyOe/owt6mPDnu7noYUR?=
 =?us-ascii?Q?jKSkLL3aefjd9lZw17t6YemCEAL7Xp8P/yWVkth1FETtqoAFuvdSYTSDJLqx?=
 =?us-ascii?Q?/n8y5qIGIo2/HhO171Us7EssiFGMhOkT2tsj0I67Q/MwyvNdY3+GAOy3ZEyj?=
 =?us-ascii?Q?w2bMzSXfUDCnzLAOun68uslof8Rzwq4OZKlf7BYQKPkxF7H47gs5/+jhgekD?=
 =?us-ascii?Q?RxxYb6n3W3lRevXIBYVLdxTzk3qIC18niPwqPmCL3eg3frnXNwchf0SzDZke?=
 =?us-ascii?Q?PBN/xJtb2C6clVndJ5mMcXyY0QGeQbejmawkxE5r1yqpSA68BzcPZTvaQx6g?=
 =?us-ascii?Q?D6+FOOxX9wlgoj7qdEp4TkSfYR7abfbsIxPdT89VfxNG1erI84ZZg6h3ivYZ?=
 =?us-ascii?Q?A1TeO4TLNKkgI1wZyhy7uZhJCY4lYqPaadUa7WzxSzTVX1o2L/Kb2TtyTVVJ?=
 =?us-ascii?Q?8xjqf0aK7uTumXrHz4SI7QycIfdbJfG8sInTsQrgW4sB1rLaV3EpszafAA/S?=
 =?us-ascii?Q?Kk4YVqKYkzC6nt5/qKBDUu0QxyJZiyeQSALJeLsLVilocOuTZkii98ZnZ9Yo?=
 =?us-ascii?Q?h09uv6QsHOFdh6XKATPXRA8BKolQmrtVuPIGm2/3wr9Fk+0XV6NFsDlF/joL?=
 =?us-ascii?Q?7zAdHdDJo1nWM0KCxh42dvxB3hnnlQP8ENnoFI4UkSUFI6gwqYKc4A=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(36860700013)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Sep 2025 14:49:36.6507
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 320418d7-c0e4-4f1d-1c29-08ddf079434a
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SA2PEPF00001505.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR12MB9168
X-Rspamd-Queue-Id: AD963100007
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: ytxu9g8exz9pxrqgj9b19sc1nsaf9a9z
X-HE-Tag: 1757515781-425041
X-HE-Meta: U2FsdGVkX19naw9TyE9uw6FNkV8Cj+JNeotiVmd7KCP7DL2rGU8J4EPf04G5CO+AxwQwdUFPHVbjYivm/FTYdHVLiHROd8VKFfj9FSRO6TlwQOT5D4LklkYQqWapfd8hFcU5Jv9r+B5qIHmD3Fze6ByM2crd4iND9kjUdaPAFEPzDOoEKDeGbixjZm0N7fH1e/ysLA8xWnT7gHlLlQLfGp4uhU73bneg61Xwx5usgzdEt5DdI12HWl2m/M/fbN5qHNurFLm7+xxsfDQXI1raicf/Tilst4idvSoXC5O7d6bH87KEvdmTnC4B+teI1xerU887yrh/SXOqbd1vI5Z1a+5Gb8a83JhVGgvtoE0RgxSNWYjK9DeeWRZizf8P8mqMVux0Ywe5wdMPsyRe+DDvW7FII2G9/C9lr74eyLiaMqch+KbvhMO8Y3aZUw6c241JAcNsMPMIv81OALSzfldobiUkya/fknpuguUQKfQFdcd64QXbbRtaDCrS3Xaw1M0aeVA498QQ18APsgokZPAS9ZmaLBI51bt78RF8gRrzvR8Fh/W5QVKYvZe96D66IckdtR6YWmkNWt8XmRP4vmWaCMYEw9UKlugwF8hnpNwc8iBnlWAALu2S+B9CeQyhjyksoeLOzFHgrg4maLLWyX4DtLNPHXXn1ZTRASZtZyAjz/e2AJpfELAih9BDOkCFeOsGL2Y+42BdCkloMCgMHHo2K5Uh7Ez2nEjruJmHD4B+bUzZHRKVoITV3tGv4bJgua0C58q8ko1lr0i+cAaVMu93I3KZM6J6ZMzAmkOYwGkcrv91ngA/boeG1UiX3cFbBINVTdyNofJyDwv6rOEPq/mHLOVk2V019LfV/5ufuhkFggcnI5ozLkSTVuBajoXhFoYybkU4BYSqgxBhOpRyhx28FyiA7CV2/5pBtSlvQ/9mnmJhhsmHzXafjiOrkvdhF8Big99N2WXJMHdf4HffT+u
 ZKIKKk6Y
 OB5Tpse2DgaxykAOnw8VxbGx/XaIVux6yZE6vRD+PZwQH02FF9AOSdwHp7b1yTQbat9DO7Hq8Gr8VZGIRU2Km0DRLQNNuwFj9kwbL3XjUbHQUcn3u6NodQqHJ0204y4YYTEV/6RHJU4CyqNbhSjD/VD79li4ZJ8WMM+3lIjGG4VVt9TMZWuIBbzV3PO0uWV5YqsiC86myTn9H7QIOVEKgVMD4X8yCfNqlSVYd+c9cO5rPUsztZlEuPRVgYYkOoXGYmoI8SitxIHx3Bbz/l4kInjnbs6m/xe5HILpU2FTZZsfCD08N9yaijbv9NmfxkYdxPgiWEDT8Qv/kgYCJ0qix9H8/3l1aKXpfkf94Y5uPtd4TaYXqwOjJFMSi/1UjNqH/eDvU/uiL2n3bQrCHjeKiRPm+cdYb84EqD7J14WuKsf4lCnMJUvr1JmwsggoI+8OZIUunjDP5u7BngrfnFxhff0+NiZtqPw32PT08ZO+Q9jumZFKJqallfDx/OopTmXKP0YOzBIupbJ3bp2/09848iIEa6N9l14Jnpwo3axa2dPPQcaZG73FUYr+X6WnbFecjbQYLVp6FkQMTfEp/uQ42mbi5bGI4BG2AVRHAXlivhkepbiEtTr7mgGQdi4dZ1/U2iD+GXbwCsEMsYftTye+4nAijpUzNdn+8qwg8GMELczjSGc152+VA7UwLNw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Use IBS (Instruction Based Sampling) feature present
in AMD processors for memory access tracking. The access
information obtained from IBS via NMI is fed to kpromoted
daemon for futher action.

In addition to many other information related to the memory
access, IBS provides physical (and virtual) address of the access
and indicates if the access came from slower tier. Only memory
accesses originating from slower tiers are further acted upon
by this driver.

The samples are initially accumulated in percpu buffers which
are flushed to pghot hot page tracking mechanism using irq_work.

TODO: Many counters are added to vmstat just as debugging aid
for now.

About IBS
---------
IBS can be programmed to provide data about instruction
execution periodically. This is done by programming a desired
sample count (number of ops) in a control register. When the
programmed number of ops are dispatched, a micro-op gets tagged,
various information about the tagged micro-op's execution is
populated in IBS execution MSRs and an interrupt is raised.
While IBS provides a lot of data for each sample, for the
purpose of  memory access profiling, we are interested in
linear and physical address of the memory access that reached
DRAM. Recent AMD processors provide further filtering where
it is possible to limit the sampling to those ops that had
an L3 miss which greately reduces the non-useful samples.

While IBS provides capability to sample instruction fetch
and execution, only IBS execution sampling is used here
to collect data about memory accesses that occur during
the instruction execution.

More information about IBS is available in Sec 13.3 of
AMD64 Architecture Programmer's Manual, Volume 2:System
Programming which is present at:
https://bugzilla.kernel.org/attachment.cgi?id=288923

Information about MSRs used for programming IBS can be
found in Sec 2.1.14.4 of PPR Vol 1 for AMD Family 19h
Model 11h B1 which is currently present at:
https://www.amd.com/system/files/TechDocs/55901_0.25.zip

Signed-off-by: Bharata B Rao <bharata@amd.com>
---
 arch/x86/events/amd/ibs.c        |  11 ++
 arch/x86/include/asm/ibs.h       |   7 +
 arch/x86/include/asm/msr-index.h |  16 ++
 arch/x86/mm/Makefile             |   3 +-
 arch/x86/mm/ibs.c                | 311 +++++++++++++++++++++++++++++++
 include/linux/vm_event_item.h    |  17 ++
 mm/vmstat.c                      |  17 ++
 7 files changed, 381 insertions(+), 1 deletion(-)
 create mode 100644 arch/x86/include/asm/ibs.h
 create mode 100644 arch/x86/mm/ibs.c

diff --git a/arch/x86/events/amd/ibs.c b/arch/x86/events/amd/ibs.c
index 112f43b23ebf..1498dc9caeb2 100644
--- a/arch/x86/events/amd/ibs.c
+++ b/arch/x86/events/amd/ibs.c
@@ -13,9 +13,11 @@
 #include <linux/ptrace.h>
 #include <linux/syscore_ops.h>
 #include <linux/sched/clock.h>
+#include <linux/pghot.h>
 
 #include <asm/apic.h>
 #include <asm/msr.h>
+#include <asm/ibs.h>
 
 #include "../perf_event.h"
 
@@ -1756,6 +1758,15 @@ static __init int amd_ibs_init(void)
 {
 	u32 caps;
 
+	/*
+	 * TODO: Find a clean way to disable perf IBS so that IBS
+	 * can be used for memory access profiling.
+	 */
+	if (arch_hw_access_profiling) {
+		pr_info("IBS isn't available for perf use\n");
+		return 0;
+	}
+
 	caps = __get_ibs_caps();
 	if (!caps)
 		return -ENODEV;	/* ibs not supported by the cpu */
diff --git a/arch/x86/include/asm/ibs.h b/arch/x86/include/asm/ibs.h
new file mode 100644
index 000000000000..b5a4f2ca6330
--- /dev/null
+++ b/arch/x86/include/asm/ibs.h
@@ -0,0 +1,7 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _ASM_X86_IBS_H
+#define _ASM_X86_IBS_H
+
+extern bool arch_hw_access_profiling;
+
+#endif /* _ASM_X86_IBS_H */
diff --git a/arch/x86/include/asm/msr-index.h b/arch/x86/include/asm/msr-index.h
index b65c3ba5fa14..55d26380550c 100644
--- a/arch/x86/include/asm/msr-index.h
+++ b/arch/x86/include/asm/msr-index.h
@@ -742,6 +742,22 @@
 /* AMD Last Branch Record MSRs */
 #define MSR_AMD64_LBR_SELECT			0xc000010e
 
+/* AMD IBS MSR bits */
+#define MSR_AMD64_IBSOPDATA2_DATASRC			0x7
+#define MSR_AMD64_IBSOPDATA2_DATASRC_LCL_CACHE		0x1
+#define MSR_AMD64_IBSOPDATA2_DATASRC_PEER_CACHE_NEAR	0x2
+#define MSR_AMD64_IBSOPDATA2_DATASRC_DRAM		0x3
+#define MSR_AMD64_IBSOPDATA2_DATASRC_FAR_CCX_CACHE	0x5
+#define MSR_AMD64_IBSOPDATA2_DATASRC_EXT_MEM		0x8
+#define	MSR_AMD64_IBSOPDATA2_RMTNODE			0x10
+
+#define MSR_AMD64_IBSOPDATA3_LDOP		BIT_ULL(0)
+#define MSR_AMD64_IBSOPDATA3_STOP		BIT_ULL(1)
+#define MSR_AMD64_IBSOPDATA3_DCMISS		BIT_ULL(7)
+#define MSR_AMD64_IBSOPDATA3_LADDR_VALID	BIT_ULL(17)
+#define MSR_AMD64_IBSOPDATA3_PADDR_VALID	BIT_ULL(18)
+#define MSR_AMD64_IBSOPDATA3_L2MISS		BIT_ULL(20)
+
 /* Zen4 */
 #define MSR_ZEN4_BP_CFG                 0xc001102e
 #define MSR_ZEN4_BP_CFG_BP_SPEC_REDUCE_BIT 4
diff --git a/arch/x86/mm/Makefile b/arch/x86/mm/Makefile
index 5b9908f13dcf..967e5af9eba9 100644
--- a/arch/x86/mm/Makefile
+++ b/arch/x86/mm/Makefile
@@ -22,7 +22,8 @@ CFLAGS_REMOVE_pgprot.o			= -pg
 endif
 
 obj-y				:=  init.o init_$(BITS).o fault.o ioremap.o extable.o mmap.o \
-				    pgtable.o physaddr.o tlb.o cpu_entry_area.o maccess.o pgprot.o
+				    pgtable.o physaddr.o tlb.o cpu_entry_area.o maccess.o pgprot.o \
+				    ibs.o
 
 obj-y				+= pat/
 
diff --git a/arch/x86/mm/ibs.c b/arch/x86/mm/ibs.c
new file mode 100644
index 000000000000..6669710dd35b
--- /dev/null
+++ b/arch/x86/mm/ibs.c
@@ -0,0 +1,311 @@
+// SPDX-License-Identifier: GPL-2.0
+
+#include <linux/init.h>
+#include <linux/pghot.h>
+#include <linux/percpu.h>
+#include <linux/workqueue.h>
+#include <linux/irq_work.h>
+
+#include <asm/nmi.h>
+#include <asm/perf_event.h> /* TODO: Move defns like IBS_OP_ENABLE into non-perf header */
+#include <asm/apic.h>
+#include <asm/ibs.h>
+
+bool arch_hw_access_profiling;
+static u64 ibs_config __read_mostly;
+static u32 ibs_caps;
+
+#define IBS_NR_SAMPLES	150
+
+/*
+ * Basic access info captured for each memory access.
+ */
+struct ibs_sample {
+	unsigned long pfn;
+	unsigned long time;	/* jiffies when accessed */
+	int nid;		/* Accessing node ID, if known */
+};
+
+/*
+ * Percpu buffer of access samples. Samples are accumulated here
+ * before pushing them to kpromoted for further action.
+ */
+struct ibs_sample_pcpu {
+	struct ibs_sample samples[IBS_NR_SAMPLES];
+	int head, tail;
+};
+
+struct ibs_sample_pcpu __percpu *ibs_s;
+
+/*
+ * The workqueue for pushing the percpu access samples to kpromoted.
+ */
+static struct work_struct ibs_work;
+static struct irq_work ibs_irq_work;
+
+/*
+ * Record the IBS-reported access sample in percpu buffer.
+ * Called from IBS NMI handler.
+ */
+static int ibs_push_sample(unsigned long pfn, int nid, unsigned long time)
+{
+	struct ibs_sample_pcpu *ibs_pcpu = raw_cpu_ptr(ibs_s);
+	int next = ibs_pcpu->head + 1;
+
+	if (next >= IBS_NR_SAMPLES)
+		next = 0;
+
+	if (next == ibs_pcpu->tail)
+		return 0;
+
+	ibs_pcpu->samples[ibs_pcpu->head].pfn = pfn;
+	ibs_pcpu->samples[ibs_pcpu->head].time = time;
+	ibs_pcpu->head = next;
+	return 1;
+}
+
+static int ibs_pop_sample(struct ibs_sample *s)
+{
+	struct ibs_sample_pcpu *ibs_pcpu = raw_cpu_ptr(ibs_s);
+
+	int next = ibs_pcpu->tail + 1;
+
+	if (ibs_pcpu->head == ibs_pcpu->tail)
+		return 0;
+
+	if (next >= IBS_NR_SAMPLES)
+		next = 0;
+
+	*s = ibs_pcpu->samples[ibs_pcpu->tail];
+	ibs_pcpu->tail = next;
+	return 1;
+}
+
+/*
+ * Remove access samples from percpu buffer and send them
+ * to kpromoted for further action.
+ */
+static void ibs_work_handler(struct work_struct *work)
+{
+	struct ibs_sample s;
+
+	while (ibs_pop_sample(&s))
+		pghot_record_access(s.pfn, s.nid, PGHOT_HW_HINTS, s.time);
+}
+
+static void ibs_irq_handler(struct irq_work *i)
+{
+	schedule_work_on(smp_processor_id(), &ibs_work);
+}
+
+/*
+ * IBS NMI handler: Process the memory access info reported by IBS.
+ *
+ * Reads the MSRs to collect all the information about the reported
+ * memory access, validates the access, stores the valid sample and
+ * schedules the work on this CPU to further process the sample.
+ */
+static int ibs_overflow_handler(unsigned int cmd, struct pt_regs *regs)
+{
+	struct mm_struct *mm = current->mm;
+	u64 ops_ctl, ops_data3, ops_data2;
+	u64 laddr = -1, paddr = -1;
+	u64 data_src, rmt_node;
+	struct page *page;
+	unsigned long pfn;
+
+	rdmsrl(MSR_AMD64_IBSOPCTL, ops_ctl);
+
+	/*
+	 * When IBS sampling period is reprogrammed via read-modify-update
+	 * of MSR_AMD64_IBSOPCTL, overflow NMIs could be generated with
+	 * IBS_OP_ENABLE not set. For such cases, return as HANDLED.
+	 *
+	 * With this, the handler will say "handled" for all NMIs that
+	 * aren't related to this NMI.  This stems from the limitation of
+	 * having both status and control bits in one MSR.
+	 */
+	if (!(ops_ctl & IBS_OP_VAL))
+		goto handled;
+
+	wrmsrl(MSR_AMD64_IBSOPCTL, ops_ctl & ~IBS_OP_VAL);
+
+	count_vm_event(HWHINT_NR_EVENTS);
+
+	if (!user_mode(regs)) {
+		count_vm_event(HWHINT_KERNEL);
+		goto handled;
+	}
+
+	if (!mm) {
+		count_vm_event(HWHINT_KTHREAD);
+		goto handled;
+	}
+
+	rdmsrl(MSR_AMD64_IBSOPDATA3, ops_data3);
+
+	/* Load/Store ops only */
+	/* TODO: DataSrc isn't valid for stores, so filter out stores? */
+	if (!(ops_data3 & (MSR_AMD64_IBSOPDATA3_LDOP |
+			   MSR_AMD64_IBSOPDATA3_STOP))) {
+		count_vm_event(HWHINT_NON_LOAD_STORES);
+		goto handled;
+	}
+
+	/* Discard the sample if it was L1 or L2 hit */
+	if (!(ops_data3 & (MSR_AMD64_IBSOPDATA3_DCMISS |
+			   MSR_AMD64_IBSOPDATA3_L2MISS))) {
+		count_vm_event(HWHINT_DC_L2_HITS);
+		goto handled;
+	}
+
+	rdmsrl(MSR_AMD64_IBSOPDATA2, ops_data2);
+	data_src = ops_data2 & MSR_AMD64_IBSOPDATA2_DATASRC;
+	if (ibs_caps & IBS_CAPS_ZEN4)
+		data_src |= ((ops_data2 & 0xC0) >> 3);
+
+	switch (data_src) {
+	case MSR_AMD64_IBSOPDATA2_DATASRC_LCL_CACHE:
+		count_vm_event(HWHINT_LOCAL_L3L1L2);
+		break;
+	case MSR_AMD64_IBSOPDATA2_DATASRC_PEER_CACHE_NEAR:
+		count_vm_event(HWHINT_LOCAL_PEER_CACHE_NEAR);
+		break;
+	case MSR_AMD64_IBSOPDATA2_DATASRC_DRAM:
+		count_vm_event(HWHINT_DRAM_ACCESSES);
+		break;
+	case MSR_AMD64_IBSOPDATA2_DATASRC_EXT_MEM:
+		count_vm_event(HWHINT_CXL_ACCESSES);
+		break;
+	case MSR_AMD64_IBSOPDATA2_DATASRC_FAR_CCX_CACHE:
+		count_vm_event(HWHINT_FAR_CACHE_HITS);
+		break;
+	}
+
+	rmt_node = ops_data2 & MSR_AMD64_IBSOPDATA2_RMTNODE;
+	if (rmt_node)
+		count_vm_event(HWHINT_REMOTE_NODE);
+
+	/* Is linear addr valid? */
+	if (ops_data3 & MSR_AMD64_IBSOPDATA3_LADDR_VALID)
+		rdmsrl(MSR_AMD64_IBSDCLINAD, laddr);
+	else {
+		count_vm_event(HWHINT_LADDR_INVALID);
+		goto handled;
+	}
+
+	/* Discard kernel address accesses */
+	if (laddr & (1UL << 63)) {
+		count_vm_event(HWHINT_KERNEL_ADDR);
+		goto handled;
+	}
+
+	/* Is phys addr valid? */
+	if (ops_data3 & MSR_AMD64_IBSOPDATA3_PADDR_VALID)
+		rdmsrl(MSR_AMD64_IBSDCPHYSAD, paddr);
+	else {
+		count_vm_event(HWHINT_PADDR_INVALID);
+		goto handled;
+	}
+
+	pfn = PHYS_PFN(paddr);
+	page = pfn_to_online_page(pfn);
+	if (!page)
+		goto handled;
+
+	if (!PageLRU(page)) {
+		count_vm_event(HWHINT_NON_LRU);
+		goto handled;
+	}
+
+	if (!ibs_push_sample(pfn, numa_node_id(), jiffies)) {
+		count_vm_event(HWHINT_BUFFER_FULL);
+		goto handled;
+	}
+
+	irq_work_queue(&ibs_irq_work);
+	count_vm_event(HWHINT_USEFUL_SAMPLES);
+
+handled:
+	return NMI_HANDLED;
+}
+
+static inline int get_ibs_lvt_offset(void)
+{
+	u64 val;
+
+	rdmsrl(MSR_AMD64_IBSCTL, val);
+	if (!(val & IBSCTL_LVT_OFFSET_VALID))
+		return -EINVAL;
+
+	return val & IBSCTL_LVT_OFFSET_MASK;
+}
+
+static void setup_APIC_ibs(void)
+{
+	int offset;
+
+	offset = get_ibs_lvt_offset();
+	if (offset < 0)
+		goto failed;
+
+	if (!setup_APIC_eilvt(offset, 0, APIC_EILVT_MSG_NMI, 0))
+		return;
+failed:
+	pr_warn("IBS APIC setup failed on cpu #%d\n",
+		smp_processor_id());
+}
+
+static void clear_APIC_ibs(void)
+{
+	int offset;
+
+	offset = get_ibs_lvt_offset();
+	if (offset >= 0)
+		setup_APIC_eilvt(offset, 0, APIC_EILVT_MSG_FIX, 1);
+}
+
+static int x86_amd_ibs_access_profile_startup(unsigned int cpu)
+{
+	setup_APIC_ibs();
+	return 0;
+}
+
+static int x86_amd_ibs_access_profile_teardown(unsigned int cpu)
+{
+	clear_APIC_ibs();
+	return 0;
+}
+
+static int __init ibs_access_profiling_init(void)
+{
+	if (!boot_cpu_has(X86_FEATURE_IBS)) {
+		pr_info("IBS capability is unavailable for access profiling\n");
+		return 0;
+	}
+
+	ibs_s = alloc_percpu_gfp(struct ibs_sample_pcpu, GFP_KERNEL | __GFP_ZERO);
+	if (!ibs_s)
+		return 0;
+
+	INIT_WORK(&ibs_work, ibs_work_handler);
+	init_irq_work(&ibs_irq_work, ibs_irq_handler);
+
+	/* Uses IBS Op sampling */
+	ibs_config = IBS_OP_CNT_CTL | IBS_OP_ENABLE;
+	ibs_caps = cpuid_eax(IBS_CPUID_FEATURES);
+	if (ibs_caps & IBS_CAPS_ZEN4)
+		ibs_config |= IBS_OP_L3MISSONLY;
+
+	register_nmi_handler(NMI_LOCAL, ibs_overflow_handler, 0, "ibs");
+
+	cpuhp_setup_state(CPUHP_AP_PERF_X86_AMD_IBS_STARTING,
+			  "x86/amd/ibs_access_profile:starting",
+			  x86_amd_ibs_access_profile_startup,
+			  x86_amd_ibs_access_profile_teardown);
+
+	pr_info("IBS setup for memory access profiling\n");
+	return 0;
+}
+
+arch_initcall(ibs_access_profiling_init);
diff --git a/include/linux/vm_event_item.h b/include/linux/vm_event_item.h
index a996fa9df785..bca57b05766d 100644
--- a/include/linux/vm_event_item.h
+++ b/include/linux/vm_event_item.h
@@ -195,6 +195,23 @@ enum vm_event_item { PGPGIN, PGPGOUT, PSWPIN, PSWPOUT,
 		KPROMOTED_RIGHT_NODE,
 		KPROMOTED_NON_LRU,
 		KPROMOTED_DROPPED,
+		HWHINT_NR_EVENTS,
+		HWHINT_KERNEL,
+		HWHINT_KTHREAD,
+		HWHINT_NON_LOAD_STORES,
+		HWHINT_DC_L2_HITS,
+		HWHINT_LOCAL_L3L1L2,
+		HWHINT_LOCAL_PEER_CACHE_NEAR,
+		HWHINT_FAR_CACHE_HITS,
+		HWHINT_DRAM_ACCESSES,
+		HWHINT_CXL_ACCESSES,
+		HWHINT_REMOTE_NODE,
+		HWHINT_LADDR_INVALID,
+		HWHINT_KERNEL_ADDR,
+		HWHINT_PADDR_INVALID,
+		HWHINT_NON_LRU,
+		HWHINT_BUFFER_FULL,
+		HWHINT_USEFUL_SAMPLES,
 		NR_VM_EVENT_ITEMS
 };
 
diff --git a/mm/vmstat.c b/mm/vmstat.c
index ee122c2cd137..aa743708c79b 100644
--- a/mm/vmstat.c
+++ b/mm/vmstat.c
@@ -1503,6 +1503,23 @@ const char * const vmstat_text[] = {
 	[I(KPROMOTED_RIGHT_NODE)]		= "kpromoted_right_node",
 	[I(KPROMOTED_NON_LRU)]			= "kpromoted_non_lru",
 	[I(KPROMOTED_DROPPED)]			= "kpromoted_dropped",
+	[I(HWHINT_NR_EVENTS)]			= "hwhint_nr_events",
+	[I(HWHINT_KERNEL)]			= "hwhint_kernel",
+	[I(HWHINT_KTHREAD)]			= "hwhint_kthread",
+	[I(HWHINT_NON_LOAD_STORES)]		= "hwhint_non_load_stores",
+	[I(HWHINT_DC_L2_HITS)]			= "hwhint_dc_l2_hits",
+	[I(HWHINT_LOCAL_L3L1L2)]		= "hwhint_local_l3l1l2",
+	[I(HWHINT_LOCAL_PEER_CACHE_NEAR)]	= "hwhint_local_peer_cache_near",
+	[I(HWHINT_FAR_CACHE_HITS)]		= "hwhint_far_cache_hits",
+	[I(HWHINT_DRAM_ACCESSES)]		= "hwhint_dram_accesses",
+	[I(HWHINT_CXL_ACCESSES)]		= "hwhint_cxl_accesses",
+	[I(HWHINT_REMOTE_NODE)]			= "hwhint_remote_node",
+	[I(HWHINT_LADDR_INVALID)]		= "hwhint_invalid_laddr",
+	[I(HWHINT_KERNEL_ADDR)]			= "hwhint_kernel_addr",
+	[I(HWHINT_PADDR_INVALID)]		= "hwhint_invalid_paddr",
+	[I(HWHINT_NON_LRU)]			= "hwhint_non_lru",
+	[I(HWHINT_BUFFER_FULL)]			= "hwhint_buffer_full",
+	[I(HWHINT_USEFUL_SAMPLES)]		= "hwhint_useful_samples",
 #undef I
 #endif /* CONFIG_VM_EVENT_COUNTERS */
 };
-- 
2.34.1


