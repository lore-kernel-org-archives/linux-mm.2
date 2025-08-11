Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8A8DAC87FD2
	for <linux-mm@archiver.kernel.org>; Mon, 11 Aug 2025 09:07:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C57F48E001A; Mon, 11 Aug 2025 05:07:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C08CA8E000A; Mon, 11 Aug 2025 05:07:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AD02A8E001A; Mon, 11 Aug 2025 05:07:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 934018E000A
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 05:07:05 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id CD901116E11
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 09:07:04 +0000 (UTC)
X-FDA: 83763897168.17.10BFB82
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2086.outbound.protection.outlook.com [40.107.92.86])
	by imf18.hostedemail.com (Postfix) with ESMTP id DC4EA1C0010
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 09:07:01 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=dvvzTMOR;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	spf=pass (imf18.hostedemail.com: domain of shivankg@amd.com designates 40.107.92.86 as permitted sender) smtp.mailfrom=shivankg@amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754903222;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=Uv5+boXBi9GcmLuACnjZmSG/opn/uYE/QrGzAfABB28=;
	b=mIzt2uFhNW5FZCKNtxuFY5OV8Z/gqd0MGvdSm7hpQCMfVeSTZNf5iIC6lzDAERO2qxr9dg
	bdAHr/aQmJVdVVkqm+TCz6MmcvFutqyOICAjZNKd/QUdyo/JvXwt/TXppUdvDqgqJkdzvE
	Q1/XsmeKJlrH++ofoZqmAHhFnfN+nZA=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1754903222; a=rsa-sha256;
	cv=pass;
	b=qI9waqyBD/jMSYAk//gr9lk+2d8R+enUeWVX5W0pTAabZWi5R4dZxPnk9rL47ZVqKtEroW
	O1TF4KaPvZZHLUWpjfZSqvNl7PzX1D8syNOQPv67mSTButwiX+u7ekwWrKhieLc3wgrGsg
	nRw9tDDEI+CbY3l5VbefOUcL0r4I/JQ=
ARC-Authentication-Results: i=2;
	imf18.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=dvvzTMOR;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	spf=pass (imf18.hostedemail.com: domain of shivankg@amd.com designates 40.107.92.86 as permitted sender) smtp.mailfrom=shivankg@amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Zc81q3bx0eFVggDA7MN5eLLMpQ/aFNcVLur6ypMjsY0tl5CeXnPA1qXB97A3LPh0/7ww7xDeroBnrFdAHBWo1qGXdHU1KPb+CYRTHMQbKDXiu/bsp8N9BIerluOjPFiTJKR8OCIpGNoWhTvS0bJPTMNjbkkyVADsR1rJIBpmbpHg1wNDB1YNdIyGu9Y3iGoRz7bI+j4NhJLreBNGgGkMTeEuGUx+qvC9+UyCa4uSXFhf+Dg41a3FKv63+wxy/ieUjAcWm7AX5NZ4qakgtL94F4KIjwLfV2EhLMMPm8HpmlbC7NLI/Lk8/oNskm00XuBJue7iB8QPuUuCoyAInSsYcQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Uv5+boXBi9GcmLuACnjZmSG/opn/uYE/QrGzAfABB28=;
 b=Nq4IOL+rPTlcnSaeIl1cGXNugNHyaVYOWrnr1dnbukcjWDXfHeRrH5F4oJF5iDwdSByB5LWkDa1pBAoEekguKYGbeabgZmWSbd7YwaiUYfyrdVGtT/4nHbbdeyY3qPKjYkA/E4HqaHIlBl9Ey7hGB/d4BegU/BufdJcE13k7wxFlTYaa8cCoX4vMAr8KWyarOTga9QDML9mPDb2D+frOWydbD1s0hqPWdUDP9XmWn7hESX31EhVnjleO+kQU6sT2A38b1iMBXIYD9TlsH7kUG1njs5IWxfC2jKvF2zw98oVI26cRMcFHkgM1mjn/bg6C74enRxwEuu+b5PxhG/Cnkg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=google.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Uv5+boXBi9GcmLuACnjZmSG/opn/uYE/QrGzAfABB28=;
 b=dvvzTMORIAezSz/crwrVqRNaCvSQbq8ZX0wBKtJT2FaaAP+XgJwWNKX166GXsLJ5cTlwX6sii0v0M0VpWl2HuKTrruakO77jmL+ihb8RYRGDR38vPuGNQNfvDvU2U/qBKcRmSbWYBp14LWyWF1rCsbOSrdAsR8HbGRMxpFVZjNw=
Received: from MN2PR20CA0015.namprd20.prod.outlook.com (2603:10b6:208:e8::28)
 by DM4PR12MB6544.namprd12.prod.outlook.com (2603:10b6:8:8d::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9009.21; Mon, 11 Aug 2025 09:06:56 +0000
Received: from BL02EPF00021F6C.namprd02.prod.outlook.com
 (2603:10b6:208:e8:cafe::49) by MN2PR20CA0015.outlook.office365.com
 (2603:10b6:208:e8::28) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9009.22 via Frontend Transport; Mon,
 11 Aug 2025 09:06:56 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BL02EPF00021F6C.mail.protection.outlook.com (10.167.249.8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.9031.11 via Frontend Transport; Mon, 11 Aug 2025 09:06:56 +0000
Received: from kaveri.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Mon, 11 Aug
 2025 04:06:40 -0500
From: Shivank Garg <shivankg@amd.com>
To: <seanjc@google.com>, <david@redhat.com>, <vbabka@suse.cz>,
	<willy@infradead.org>, <akpm@linux-foundation.org>, <shuah@kernel.org>,
	<pbonzini@redhat.com>, <brauner@kernel.org>, <viro@zeniv.linux.org.uk>
CC: <ackerleytng@google.com>, <paul@paul-moore.com>, <jmorris@namei.org>,
	<serge@hallyn.com>, <pvorel@suse.cz>, <bfoster@redhat.com>,
	<tabba@google.com>, <vannapurve@google.com>, <chao.gao@intel.com>,
	<bharata@amd.com>, <nikunj@amd.com>, <michael.day@amd.com>,
	<shdhiman@amd.com>, <yan.y.zhao@intel.com>, <Neeraj.Upadhyay@amd.com>,
	<thomas.lendacky@amd.com>, <michael.roth@amd.com>, <aik@amd.com>,
	<jgg@nvidia.com>, <kalyazin@amazon.com>, <peterx@redhat.com>,
	<shivankg@amd.com>, <jack@suse.cz>, <rppt@kernel.org>, <hch@infradead.org>,
	<cgzones@googlemail.com>, <ira.weiny@intel.com>, <rientjes@google.com>,
	<roypat@amazon.co.uk>, <ziy@nvidia.com>, <matthew.brost@intel.com>,
	<joshua.hahnjy@gmail.com>, <rakie.kim@sk.com>, <byungchul@sk.com>,
	<gourry@gourry.net>, <kent.overstreet@linux.dev>,
	<ying.huang@linux.alibaba.com>, <apopple@nvidia.com>,
	<chao.p.peng@intel.com>, <amit@infradead.org>, <ddutile@redhat.com>,
	<dan.j.williams@intel.com>, <ashish.kalra@amd.com>, <gshan@redhat.com>,
	<jgowans@amazon.com>, <pankaj.gupta@amd.com>, <papaluri@amd.com>,
	<yuzhao@google.com>, <suzuki.poulose@arm.com>, <quic_eberman@quicinc.com>,
	<aneeshkumar.kizhakeveetil@arm.com>, <linux-fsdevel@vger.kernel.org>,
	<linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
	<linux-security-module@vger.kernel.org>, <kvm@vger.kernel.org>,
	<linux-kselftest@vger.kernel.org>, <linux-coco@lists.linux.dev>
Subject: [PATCH RFC V10 0/7] Add NUMA mempolicy support for KVM guest-memfd
Date: Mon, 11 Aug 2025 09:05:58 +0000
Message-ID: <20250811090605.16057-2-shivankg@amd.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL02EPF00021F6C:EE_|DM4PR12MB6544:EE_
X-MS-Office365-Filtering-Correlation-Id: 970f4225-81a0-45ab-7eff-08ddd8b66be6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|82310400026|36860700013|376014|7416014|13003099007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?Y1tJRcR7xL/ZLOLjoz8L/8oxdTSX83N0QfI7rYpYQieNilHFQPRxXaIak3jb?=
 =?us-ascii?Q?eW658Y3kuERQtbk9MAmgbDede4LI17gSRq+qef+8KNWGzRGU3ELqg201aRNL?=
 =?us-ascii?Q?aNimS+881jDOzS19SizgeHs4IVQP+nakrRgBkZofCtdsHzZb09u/eVePY35E?=
 =?us-ascii?Q?HZxBUyzIRQDOnmLMGMe147ZBXKu6YPqa8t5z8Iw0DpmFXWl1fPOv7PCPIh9I?=
 =?us-ascii?Q?/Iml5UdvvhJi8neoHY9a/vNzfji6KLULaAJQeqUK9Ewj2oeLtSpCX40UgZ0/?=
 =?us-ascii?Q?xfB6u2HsZyX93ZQczW9pP0UpZF6B5j6+5koKlAWXTGaAb5ldvTKM+F/cjVuR?=
 =?us-ascii?Q?KmjGed0T3aFyq4THkt/ZHJkEA0k2MYKv6H527xJu01RhpQJq+h63mMSOt206?=
 =?us-ascii?Q?kxqHgTyQjMXSkCqKz2zI1SxHQjUP1m30f7p2bPJlQ+b8LddgQlzMK8383CeD?=
 =?us-ascii?Q?DKOwt+/HyQ246liMjflCKJZAx2nI7c3t7+HWZ4u8UKPRJgwMWgH9vNDwmbCl?=
 =?us-ascii?Q?R1pP73imu6Wy4H460m1z/o1FDdVafufMrM5UuITwtmrc3xKHgoI6xVK+5Fpw?=
 =?us-ascii?Q?t6CpZGHeHy49uu0ODWkMfbwvoJjlCoTJ5xK+0iXRv7kj/xPXZtZNEFlxeL/U?=
 =?us-ascii?Q?BmIr4TgLGq3C528EfDW7Kn+RKcUXdbj7oxnAyoulQtqYwDi+fdolBcqtcukF?=
 =?us-ascii?Q?c6OIZMxASysCT+KtL43dZnFUZ6lxeQ7OfHS19wz0kWZNqzHYmcaALaWbcnk4?=
 =?us-ascii?Q?1O1eR1eUKUfQDmjNKL2gMKsrvQ6sgkmvt+ZRzLXvm5QSiQ/Jx4SzIwPve402?=
 =?us-ascii?Q?63mXij4Z6HfdLayskP8lmxef5BFjemYDZLkIkGz4HuQHSn+2/jvUJUd9jACy?=
 =?us-ascii?Q?SA2qzrobXtWAKMq18xJdnRSigoJdPp6pdcwdZSFqEdykRTt8Jii41VbynT3c?=
 =?us-ascii?Q?d1Rqd1ozC4CGzeoiTjrJCVwHtWCMmu1zhvJRa4v8P3eEUET1dqgp+/j7prGW?=
 =?us-ascii?Q?cWUooDlCMZj/t55ksCEw+GQw9bT6fhZR85Tdf6J0es1yKcZert5kVTY0cdv3?=
 =?us-ascii?Q?sewR2WEe6xdjJbXhR/6RpfX54Lqcxlj+m23JFlq/j39Rso8ZXuOdg+yf/gO6?=
 =?us-ascii?Q?heHXPM5UycA+yiYZq6fXt1pUl68TfRi29UD4QSWInKlpkuB1hFuj/YzIhfxJ?=
 =?us-ascii?Q?KlJChMSS+Nwuy2+bkOvZ9+nrqdUt1Vm/ZGwAhNl56XaZIIKE7lGD344JYJzO?=
 =?us-ascii?Q?LE4rQHf3VN/5HMsGNvBGTQaWKJVaH35UiqdVRGM/gzzRQXovLZwda1ohx1oU?=
 =?us-ascii?Q?ytZ88wB2IlqNogtP2gJkwHGxDtTWuyo2zw6pVidRIk9Va2bt50fwptZA8k4e?=
 =?us-ascii?Q?GL/HlP1Xy3Cued+ayvFfsBVGRB2XP88n3opoRfq9QwzA3DfF1bcOMnFYKcR9?=
 =?us-ascii?Q?WDf3JExPHlRSwash90moYbMa8nU75naoOWOyW5P3QJH/05Y9VfMa4g=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(82310400026)(36860700013)(376014)(7416014)(13003099007);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Aug 2025 09:06:56.1951
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 970f4225-81a0-45ab-7eff-08ddd8b66be6
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL02EPF00021F6C.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB6544
X-Rspamd-Queue-Id: DC4EA1C0010
X-Stat-Signature: 66h7qztqh59rp861ypk3aj569jsjsjjk
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1754903221-258999
X-HE-Meta: U2FsdGVkX1/6ZF1tArqyTW7o7qTkNTyo11AhOqpMHt2VjZuPQ45I5IIrJ+MelMc48k9gwWJ4QV4fdmsemqOf+LV+WcWC7M7UjiD2MJuohK3uhYKFaT9wjIkzJatO0oV20bzTtE0sSPGNU6HIPnCeyTm00Cx0DfNXbJ8K15bw5aTEoFmuDxb8XctnpiNKx+DTwbxQB+hUJb9SmKbHaoUjQhxQ303Dp33zUGup0mvy87qHSt/sC6Uwazz7DHLObHsAwM/+bHtKM1cGvOlUPiDyjbfbZpg1+YaN6/0CWbP8gWl46aVSeqZi9jIYtM5TPMj/J0JFmcZeo3F5Z1o3uVf+oeZxGmSF41rDW9All5mVUD8Dmb4Gc0esnFkWOFg7u8b5K/hTQnTAenn1v0amMi1BP/hOGDRUEr2KNbXrDQVksrB8C0G9jOiiSCFHLuL6K+bUgGdtCio9b4omsxjfD4QDFyjw/QAiXIzC9cFQ/z2lHhIgWSuu1/M6AHfjh3Bxsb8el6EbN5XbxpdKkEwpNIE1KzMhQdgBotD924VZQrkgBOPYVeX1A5e71WDRZcgcUcQSL0HCrJPQi6y240DIKTFh9RPJ2flqnQaA5Uj0XNo8wzWldZqX8kxh5OdV2bqETBBts4bfWzLYs076r+bh8chVrBw/W4kTad9qxZSzYhH1ynWnGBBD8Dzp8ldXU1B/TRZSP32ogMTBvjHhwvzoxW6ZBDeYtT/CvC8n4c/J9grZ6GYqxSH+2k+1ukAtarnRdvbV4MZB0T1sVjkWJTLbrrRhF17gj6tWl1/WmNlhuDnL4NoocXODs+43cQZZ5PCCZ69g2zBzBLKnG9EtNbMjmT1zSzpNFc+cpEuyS41XW1Ll3wb/SkCQ45C+P/jVNGw54x1aT4xGXu9PnLokZPXHxC7IR3jsstCKUe+zuHYwPWnegdYjCyk9C2QbIoVu3eByY7fQuoWX05H5iliQDvEwL+E
 /NIhQwUN
 9bRjdkHY2huDdPb3ttlxo/j0h1VXdVkSh+x2hyJJGanO+zsOotRdEhTchZkfv9NljAhDF4ss28sjd5ktMm2kf+n5/L8UAjfABU/mVtjP35oRH4EMB+9A/nkmsJagympwZ5EI7HUrJNe/xtdMFBuGowWGaThUBHf58gYY/1wq+GnuiuZiolyyl6yMPzj1CRj/UPw35CYzUZRYxgRqII7Bq8JooE5ES//94RfhufhG5BW27au4FnSZyyPzYVkS7NwrLdElrUvhR1+cAzoirny99WTQ5f60N8AkO7WVBkspbMFbl24fl6RXApQN916OwuzOjiuCybapyngFnsFYTxs/MaBYk7jd+2A+VsAwDrh2OSVEuaE+VFiyb2W/lVV4k4oqlJLO2/Onj+ZlfyqYph2WW4Zu0nNWB2sTMad19f97uMtQ6ZG99CmXB2cq2XHyUBMeQra31/P921nsIbT2UitYUXTKD3zYKghVDS6Ou8LzUiY8v4mlYS9/+Qc0lZemDkW5bnHSD3Y/lAJFXNFkXLNVEWopQHdHfNaAcP51XhcWlnW5gG4NSL5N4ZngFOv4xoNZtO3PVB0f5EwQy+/wdbiEnJKGCu5tUelYDqK+lyCugxq4uN04TV0Z/xv7Jhf5xIBkZNSwE7NFjKHtX91CSrDztyb0DxCNQzIoCzw6qdWhVdVpzfZYbglXNEQEfN7M9ofvgLCWLIQOkNZCQS9u9cncVlQ8lu5OAwlG269ZivvXCfDoVtOSdSt43d1VnFb9fkixf85FmTDm4mETgLMCMUuopSnvrsb2XAw04JcLd
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This series introduces NUMA-aware memory placement support for KVM guests
with guest_memfd memory backends. It builds upon Fuad Tabba's work (V17)
that enabled host-mapping for guest_memfd memory [1].

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
Phased approach as per David's guest_memfd extension overview [2] and
community calls [3]:

Phase 1 (this series):
1. Focuses on shared guest_memfd support (non-CoCo VMs).
2. Builds on Fuad's host-mapping work.

Phase2 (future work):
1. NUMA support for private guest_memfd (CoCo VMs).
2. Depends on SNP in-place conversion support [4].

This series provides a clean integration path for NUMA-aware memory
management for guest_memfd and lays the groundwork for future confidential
computing NUMA capabilities.

Please review and provide feedback!

Thanks,
Shivank

== Changelog ==

- v1,v2: Extended the KVM_CREATE_GUEST_MEMFD IOCTL to pass mempolicy.
- v3: Introduced fbind() syscall for VMM memory-placement configuration.
- v4-v6: Current approach using shared_policy support and vm_ops (based on
         suggestions from David [5] and guest_memfd bi-weekly upstream
         call discussion [6]).
- v7: Use inodes to store NUMA policy instead of file [7].
- v8: Rebase on top of Fuad's V12: Host mmaping for guest_memfd memory.
- v9: Rebase on top of Fuad's V13 and incorporate review comments
- V10: Rebase on top of Fuad's V17. Use latest guest_memfd inode patch
       from Ackerley (with David's review comments). Use newer kmem_cache_create()
       API variant with arg parameter (Vlastimil)

[1] https://lore.kernel.org/all/20250729225455.670324-1-seanjc@google.com
[2] https://lore.kernel.org/all/c1c9591d-218a-495c-957b-ba356c8f8e09@redhat.com
[3] https://docs.google.com/document/d/1M6766BzdY1Lhk7LiR5IqVR8B8mG3cr-cxTxOrAosPOk/edit?tab=t.0#heading=h.svcbod20b5ur
[4] https://lore.kernel.org/all/20250613005400.3694904-1-michael.roth@amd.com
[5] https://lore.kernel.org/all/6fbef654-36e2-4be5-906e-2a648a845278@redhat.com
[6] https://lore.kernel.org/all/2b77e055-98ac-43a1-a7ad-9f9065d7f38f@amd.com
[7] https://lore.kernel.org/all/diqzbjumm167.fsf@ackerleytng-ctop.c.googlers.com

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
 virt/kvm/guest_memfd.c                        | 260 ++++++++++++++++--
 virt/kvm/kvm_main.c                           |   7 +-
 virt/kvm/kvm_mm.h                             |   9 +-
 15 files changed, 410 insertions(+), 50 deletions(-)

-- 
2.43.0


