Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 36BE7CA0EC0
	for <linux-mm@archiver.kernel.org>; Mon, 11 Aug 2025 09:09:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B72A16B00CD; Mon, 11 Aug 2025 05:09:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B4A5B6B00CF; Mon, 11 Aug 2025 05:09:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A12066B00D1; Mon, 11 Aug 2025 05:09:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 8DCD16B00CD
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 05:09:17 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 64DF91A0786
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 09:09:17 +0000 (UTC)
X-FDA: 83763902754.12.B759E42
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2050.outbound.protection.outlook.com [40.107.94.50])
	by imf12.hostedemail.com (Postfix) with ESMTP id 52AE140008
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 09:09:14 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=aVGuLVGJ;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	spf=pass (imf12.hostedemail.com: domain of shivankg@amd.com designates 40.107.94.50 as permitted sender) smtp.mailfrom=shivankg@amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1754903354; a=rsa-sha256;
	cv=pass;
	b=ikdTlec9OC87ZDwa1QaL8sdYmSWCTdiL53rR/j7Ha3j9yj6hchBZZ/H5MHfCtb5Q8WloPp
	aYDo2HBry46jnEUBrGQ4QV/s481LxG4yg12LrJLAYzcCTz8AFul8bgLYmx1nFCKq/2zHUH
	u48JSJmQQiEJXSoyU8dvCkOE1rahSvM=
ARC-Authentication-Results: i=2;
	imf12.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=aVGuLVGJ;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	spf=pass (imf12.hostedemail.com: domain of shivankg@amd.com designates 40.107.94.50 as permitted sender) smtp.mailfrom=shivankg@amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754903354;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XygNWxQssPcyQqF+ephs9lWwCkk5lc0nKDqqpLgyj/U=;
	b=YZMl8uweCJc0bUa/iKGZobAwFL4GAjhm31FrJjH3tbFp+ldZQ2cye5O4q4GQ50HxsId63M
	RsbNt+lQ0ioqpq0uM9GA7eo/Gh8viP6I4W5oMQqG+70afqirhG0Uthtk8+34Wab3VolVGz
	oguHDgnkzVsdZt9qAOdA2u8XBTUkxRU=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=bbdsX4gxtgaemZk92gLE4rBPWWxickDQw2aav7iDfCS5SYBP27y1bnsNieLbaCLuWlXAhd3CNN2nSa6/xwhc9iJ4TvRLObLYWlIunv/AGrmjrQkjEENMU03dy3Il1ZbkAQmDmoUjTMNfN8mKdcvRv9lLS2zGmIsLWp9Nkrp3xokuREZcZcYCISp2N0LyGd8vgk4ZYcMmQDkDEIm9DtwFsKp+bYmfX+3rw5ETFwJfMOvUZAIgmrIsTe8lbVubk6ham0eq0N8Dx4bQ1rU5TOrLBDEjP6Y9hnG2je1oc2OqwJXLP+tCnYXmDR5KjWm2egkkSLxfWv54hsTL4enregz4Tg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XygNWxQssPcyQqF+ephs9lWwCkk5lc0nKDqqpLgyj/U=;
 b=iX14zJXwYiHD2ogmBqXYP/VPe/jd9T4r3D/TmOCLDFZ8MBmTn2yMfhnkl2s2Z+rHrzmbtiC9cAHBfBE4x6T4AeLG8XWNjlFm7pPQBvUMNxyiNAong8RzUSYKB2O5bQRseapqLnTEhjGuVZEC6e25F14EWJpEq7SviCB4eyxuLcV19f73DiOj93Dv1Guj/y6mhhmrUG4qOu26wK5X5lx9y4shWv6zUALvYyzs0gGbMZ7buy5TPHXskRTgvSnWPVi00HZmT2+pnvbklr2Moft445il3Yku0bkMkrEiLn9Xpucsi1WPhOHwti+4oYkiYABQJs1qRk3MZAWy1mOXMrpJvg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=google.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XygNWxQssPcyQqF+ephs9lWwCkk5lc0nKDqqpLgyj/U=;
 b=aVGuLVGJU2i/Y0UkOA2VFLCzOOpd0GsfP5ueNHkE0SFlARMBHKF1eARj8ZPPX6P0xDKnOaSpg1V/yYdPnyDXWnUjQEqVeHZIew5exzKtlpqW7dR+mc02iVPpO4Z+3f8Kt1imq4Oat0d8alBDfI02ZDjdeUs4ACLcMF8kUleHGbE=
Received: from MN2PR01CA0066.prod.exchangelabs.com (2603:10b6:208:23f::35) by
 BY5PR12MB4258.namprd12.prod.outlook.com (2603:10b6:a03:20d::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8989.20; Mon, 11 Aug
 2025 09:09:08 +0000
Received: from BL02EPF00021F6B.namprd02.prod.outlook.com
 (2603:10b6:208:23f:cafe::74) by MN2PR01CA0066.outlook.office365.com
 (2603:10b6:208:23f::35) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9009.21 via Frontend Transport; Mon,
 11 Aug 2025 09:09:57 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BL02EPF00021F6B.mail.protection.outlook.com (10.167.249.7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.9031.11 via Frontend Transport; Mon, 11 Aug 2025 09:09:07 +0000
Received: from kaveri.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Mon, 11 Aug
 2025 04:08:52 -0500
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
Subject: [PATCH RFC V10 4/7] KVM: guest_memfd: Use guest mem inodes instead of anonymous inodes
Date: Mon, 11 Aug 2025 09:06:06 +0000
Message-ID: <20250811090605.16057-10-shivankg@amd.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250811090605.16057-2-shivankg@amd.com>
References: <20250811090605.16057-2-shivankg@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL02EPF00021F6B:EE_|BY5PR12MB4258:EE_
X-MS-Office365-Filtering-Correlation-Id: d9fc065d-e716-4e54-eb49-08ddd8b6ba69
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|82310400026|1800799024|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?xnNPA1ASZJVpNSygaviBOaPyrknxWSv2BGUdmt3gV4iEeJSGCn2qOyOv/L8h?=
 =?us-ascii?Q?flaPtcEpLR/V2b/cp/1/e3sNQgKkaEZKORtemseRn5cpZGc24UdehfQUEBS7?=
 =?us-ascii?Q?SbLxwlU6Q8iSCfV+fZtAvySKKvnvci5L9GV2pUQ+aSlTQapWbq0Cbk87opYc?=
 =?us-ascii?Q?FoDkGyChupn+XmGg0z1kqN4SQvydtN+coP3hrckmG9H5/i5sAcHCJPi2cV4n?=
 =?us-ascii?Q?zJ+7hoCJntETtc8Z17NqqkvqlzHb6jRyW89WQlUYUYRPtlflaU7pxVndt4s0?=
 =?us-ascii?Q?ccxX36/SKv84s0uzpK2uIQclTQatDHaEVKkDZvjnCgpyc0j+osk/uTOdSIyt?=
 =?us-ascii?Q?Cslt+bTSnipWzRbZbd15YLAcSjdUFZwdjds/eFMdts35GnqO0FUJKuDIG2/G?=
 =?us-ascii?Q?tAaL2qZtC9b9BXfFTKrt9HsN3RfjOKvdw0HFqYZaA7Dw3QUmvE5yTH98UfiQ?=
 =?us-ascii?Q?BGmlcgQn7gzzvGpGOYBl45/tCv/LoHgy7tFn0WYOs65zMbsoiRtOcxT7Diq7?=
 =?us-ascii?Q?NXOQDZHk4qR8UAnAhQOQdn2e+tcuvPs8cOc8LYg/X/G5WT7gTOUKnOF4Eeoz?=
 =?us-ascii?Q?E4We5YNO/st8n+JVrg2JK6URz1/tDmXmZ9sIbiidBiFrZGSHfeMwBhtaEQcL?=
 =?us-ascii?Q?vFQ9jg2Px2UNMR/fv7wQdbv+GDoaEozN0ULQipkedu4syEf39DOYsJnwOffE?=
 =?us-ascii?Q?mxq/vFbklD4Eq/GwFUg4RFAZjydQZFwGiVHuqU1Hs2L/iFUN9UBF/rEj5/kg?=
 =?us-ascii?Q?97hIrWMZIOuBIbMQZILht6HZiwzVUkG8ALkCGEYOdSdzyJ6v71FROLXCOnAU?=
 =?us-ascii?Q?TcjoxJFwX6LnXjjtYu321s6j73pwbmGk0gRkqaoDZmZC7tUzvf74mDTSejLN?=
 =?us-ascii?Q?O8v0GeYT89YGeFVCDcGU9tqz7IpGKNpZluYx9S0FP+MFtA/aHUy+xcwh9vJm?=
 =?us-ascii?Q?vo93Fffd5zvjB3CCElT//8kNPa7jlAAdlKAPI0KaM9EhXhcswq3olFWcokYZ?=
 =?us-ascii?Q?Yx6jw37LUu/vy5S8S9oU2GdjjDyq0Xfx9PjoemD0uDrjvaisctE/7w3+bpSI?=
 =?us-ascii?Q?K8JVQa/lq5inyv5sj+qZiHUv0EceEl9INKmGkm8Hc9o/sQ36Y04BnEThxN9K?=
 =?us-ascii?Q?QTkj0oeozsb4mI+cj31wBm+Arwar0dQk+sGJSujG+gG6rVuItqcMHEr/Fekv?=
 =?us-ascii?Q?fulBIU1DyVUJ/LF8P0MAI0NhPfOVDQ4yH5OQb1I4fnfvHiY8Rk5ux+NP07/x?=
 =?us-ascii?Q?II4ZzhG0KAymwKKP/UeISvi9/2Tq8GA0XMHol8ffxNV+HVSnGfo9n7BMJtn1?=
 =?us-ascii?Q?06jIXQN95L8sky6y49kHD+2dtpY/sIHb6yfMZJazaHM94dKJg35u/Gbckcvv?=
 =?us-ascii?Q?vjdeHV1A/C1eZdrWLeilzJyxKVzCtOC0nntOuCtnTqvSLqKcNH7alunbEYqK?=
 =?us-ascii?Q?x98Vx+Ys6UAOGPiDlViINQScsB0r1YK3FGkPesE8DjWoAVKKMw3zfCkghc53?=
 =?us-ascii?Q?e0JyHiY6w6wM8Lr7ncAU0xaXkr6arE+O+6oC?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(82310400026)(1800799024)(376014)(7416014);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Aug 2025 09:09:07.9190
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d9fc065d-e716-4e54-eb49-08ddd8b6ba69
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL02EPF00021F6B.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4258
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 52AE140008
X-Stat-Signature: tghdwe5jbe5m31pd1gggpbq3caf6rz4c
X-Rspam-User: 
X-HE-Tag: 1754903354-594103
X-HE-Meta: U2FsdGVkX1+eRJrm0XQjedJEgUIz8Q5LhS74v/xnT9qcWl2mPSXzO75JlXuW1J5T8UnQjdfcwwZmweLEORDXWTdx/KR4cUlvS+alZbf36zw2pwpu7+2DsITYNCuyHWWqP+WpVAkGOS5/I17DpyXpynYv1aFWHzWkhZYr0Zo+YmVjcM1smsUZ1l0zsslplDP1uE5mZk7DIPnSpdfT5H/5cHABv/yRRVYNIf4KuAtX+DkXa27R9tI0A6y4xyYY9dJASPMU+gzXzeF/8c2B7N080WalalfY5d49YW+yyllumAMmR5PaYxn1AD0tk1m62X8UrX1z6gkuBjmYP3EzNGXulfUu7/rT3jT+pAkutJZK54v1QJTzWp/kLonKoFvgsu7k5gGtOGcbTa5LdIv0gmvL4JRi0XpoGpE1aHAtf4IcF1Yak9YJaovPAz5vWVOjD0CV6GWoeeWZbKMY/3P9RgXBTSn4MymacF8kZlO+YKb49M6PKCufvH1LY0cgDJCOxuQfigNBDLVfpdyUMtsN/hMr0Gm9Ir86+9ySqV9gWkEKqOXWN2ugVp+KZwQzkbghhpEjua8g2XRwdKCMUN/7/QjwK/wgUChX629nD4mzHKL3GkUKgE/KszXIlMpEiW4JNHV7Fq0bDLucZuq+8vvuNCQxETbcXvuRFJj1joSby04d8P7A5W7SnQbnmaPf0s6KsSsqCGgeIU63JON0oLRgMqXM9ZivJ4PYP9/lw4BAJ5OreZT/3sDeOQgDvuKmu0jJ9XLQ1uBhSSSHH1ppha+tM94CDzBrnYv5T2adMTju1GCXC9JxBJd9Jey0Irvn8dE1ulazaHiNZaFSGYvchRBDop3QTk15K1S3hfGg0IO3lhfPK66HZl4z7KhbC8VLYvFXZOh7z/Wt4upGtOrgtUuC0lbscciAtAObxBrDfzRNwKa4eb2evsjx3xjCJUOOoccOUchlQteimodYa1kJ2960ALl
 hX0iPKwm
 TQUenH2nfupbQHS7FB9eEqchl7JQTtOULH6BSjkJoTvT4FuJOEtaz9ERKBCIDjsyK7Qe6rILOqBUd3baRKdQLaz6Hn1yybgupDqDUhcbt+eXw/fr1ZUf2bQWePDGCSU8fY1CE78Y2maOj2xffRO9HJKQk9ror1ekodQCBw2hwdlYFvbrTfqhlKNYoO6ExIAnSjhqXbRm1esMw1sa7XIh+5WP3/KZdYpofPFkRfKR3xjhFTQm90i0X1crN5oe3AKq5CiEyeUqDzLW/cw7ivKKDv2OMNbtWjy8JN6Rk8Rv0ALocTvyoXU6ENjtG9iJJ8+EFex1305/DzvMJ0Sq1dYnjspRe6JIa/vpsTnUHEXsln2L5Q8m+FgyvM76vMXV520aibd6QtjHtCoOKld2zzb/ulErRQR+P3RQlep0Q8BQ1xKz9nnSb0OWlpjMy3LYjqzFDEwS2G/fuF7dk3jOY1wnoaKGUmeyN/BalKJ5nhUl+kF7noiMkveqRZlxDkmvQoC2LhTt1iq7qb27S1s0/BCohvgJifQbxtnXN6aj8wBzqTvEMXyE7dXUgynNSK3hciEYEEqWryG0DH0Q72mfg2OssDCzt6EWfqF554o2NJrjTKkEmh+1mtFm4WNKKPiDcE1HErc1xzFsUm4EyR5+iB7j3/NZtKlNehZ+srCWLgtuoDxEKbXJH4CR2f5SPeunIfH6MrSs/cwqhpM0BZBYHcTX1tSMk7GBsmFuDaYQrbH43JRk66fo=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Ackerley Tng <ackerleytng@google.com>

guest_memfd's inode represents memory the guest_memfd is
providing. guest_memfd's file represents a struct kvm's view of that
memory.

Using a custom inode allows customization of the inode teardown
process via callbacks. For example, ->evict_inode() allows
customization of the truncation process on file close, and
->destroy_inode() and ->free_inode() allow customization of the inode
freeing process.

Customizing the truncation process allows flexibility in management of
guest_memfd memory and customization of the inode freeing process
allows proper cleanup of memory metadata stored on the inode.

Memory metadata is more appropriately stored on the inode (as opposed
to the file), since the metadata is for the memory and is not unique
to a specific binding and struct kvm.

Co-developed-by: Fuad Tabba <tabba@google.com>
Signed-off-by: Fuad Tabba <tabba@google.com>
Signed-off-by: Ackerley Tng <ackerleytng@google.com>
Signed-off-by: Shivank Garg <shivankg@amd.com>
---
 include/uapi/linux/magic.h |   1 +
 virt/kvm/guest_memfd.c     | 128 ++++++++++++++++++++++++++++++-------
 virt/kvm/kvm_main.c        |   7 +-
 virt/kvm/kvm_mm.h          |   9 +--
 4 files changed, 118 insertions(+), 27 deletions(-)

diff --git a/include/uapi/linux/magic.h b/include/uapi/linux/magic.h
index bb575f3ab45e..638ca21b7a90 100644
--- a/include/uapi/linux/magic.h
+++ b/include/uapi/linux/magic.h
@@ -103,5 +103,6 @@
 #define DEVMEM_MAGIC		0x454d444d	/* "DMEM" */
 #define SECRETMEM_MAGIC		0x5345434d	/* "SECM" */
 #define PID_FS_MAGIC		0x50494446	/* "PIDF" */
+#define GUEST_MEMFD_MAGIC	0x474d454d	/* "GMEM" */
 
 #endif /* __LINUX_MAGIC_H__ */
diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
index 08a6bc7d25b6..0e93323fc839 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -1,12 +1,16 @@
 // SPDX-License-Identifier: GPL-2.0
+#include <linux/anon_inodes.h>
 #include <linux/backing-dev.h>
 #include <linux/falloc.h>
+#include <linux/fs.h>
 #include <linux/kvm_host.h>
+#include <linux/pseudo_fs.h>
 #include <linux/pagemap.h>
-#include <linux/anon_inodes.h>
 
 #include "kvm_mm.h"
 
+static struct vfsmount *kvm_gmem_mnt;
+
 struct kvm_gmem {
 	struct kvm *kvm;
 	struct xarray bindings;
@@ -385,9 +389,45 @@ static struct file_operations kvm_gmem_fops = {
 	.fallocate	= kvm_gmem_fallocate,
 };
 
-void kvm_gmem_init(struct module *module)
+static int kvm_gmem_init_fs_context(struct fs_context *fc)
+{
+	if (!init_pseudo(fc, GUEST_MEMFD_MAGIC))
+		return -ENOMEM;
+
+	fc->s_iflags |= SB_I_NOEXEC;
+	fc->s_iflags |= SB_I_NODEV;
+
+	return 0;
+}
+
+static struct file_system_type kvm_gmem_fs = {
+	.name		 = "guest_memfd",
+	.init_fs_context = kvm_gmem_init_fs_context,
+	.kill_sb	 = kill_anon_super,
+};
+
+static int kvm_gmem_init_mount(void)
+{
+	kvm_gmem_mnt = kern_mount(&kvm_gmem_fs);
+
+	if (IS_ERR(kvm_gmem_mnt))
+		return PTR_ERR(kvm_gmem_mnt);
+
+	kvm_gmem_mnt->mnt_flags |= MNT_NOEXEC;
+	return 0;
+}
+
+int kvm_gmem_init(struct module *module)
 {
 	kvm_gmem_fops.owner = module;
+
+	return kvm_gmem_init_mount();
+}
+
+void kvm_gmem_exit(void)
+{
+	kern_unmount(kvm_gmem_mnt);
+	kvm_gmem_mnt = NULL;
 }
 
 static int kvm_gmem_migrate_folio(struct address_space *mapping,
@@ -463,11 +503,71 @@ bool __weak kvm_arch_supports_gmem_mmap(struct kvm *kvm)
 	return true;
 }
 
+static struct inode *kvm_gmem_inode_make_secure_inode(const char *name,
+						      loff_t size, u64 flags)
+{
+	struct inode *inode;
+
+	inode = anon_inode_make_secure_inode(kvm_gmem_mnt->mnt_sb, name, NULL);
+	if (IS_ERR(inode))
+		return inode;
+
+	inode->i_private = (void *)(unsigned long)flags;
+	inode->i_op = &kvm_gmem_iops;
+	inode->i_mapping->a_ops = &kvm_gmem_aops;
+	inode->i_mode |= S_IFREG;
+	inode->i_size = size;
+	mapping_set_gfp_mask(inode->i_mapping, GFP_HIGHUSER);
+	mapping_set_inaccessible(inode->i_mapping);
+	/* Unmovable mappings are supposed to be marked unevictable as well. */
+	WARN_ON_ONCE(!mapping_unevictable(inode->i_mapping));
+
+	return inode;
+}
+
+static struct file *kvm_gmem_inode_create_getfile(void *priv, loff_t size,
+						  u64 flags)
+{
+	static const char *name = "[kvm-gmem]";
+	struct inode *inode;
+	struct file *file;
+	int err;
+
+	err = -ENOENT;
+	if (!try_module_get(kvm_gmem_fops.owner))
+		goto err;
+
+	inode = kvm_gmem_inode_make_secure_inode(name, size, flags);
+	if (IS_ERR(inode)) {
+		err = PTR_ERR(inode);
+		goto err_put_module;
+	}
+
+	file = alloc_file_pseudo(inode, kvm_gmem_mnt, name, O_RDWR,
+				 &kvm_gmem_fops);
+	if (IS_ERR(file)) {
+		err = PTR_ERR(file);
+		goto err_put_inode;
+	}
+
+	file->f_flags |= O_LARGEFILE;
+	file->private_data = priv;
+
+out:
+	return file;
+
+err_put_inode:
+	iput(inode);
+err_put_module:
+	module_put(kvm_gmem_fops.owner);
+err:
+	file = ERR_PTR(err);
+	goto out;
+}
+
 static int __kvm_gmem_create(struct kvm *kvm, loff_t size, u64 flags)
 {
-	const char *anon_name = "[kvm-gmem]";
 	struct kvm_gmem *gmem;
-	struct inode *inode;
 	struct file *file;
 	int fd, err;
 
@@ -481,32 +581,16 @@ static int __kvm_gmem_create(struct kvm *kvm, loff_t size, u64 flags)
 		goto err_fd;
 	}
 
-	file = anon_inode_create_getfile(anon_name, &kvm_gmem_fops, gmem,
-					 O_RDWR, NULL);
+	file = kvm_gmem_inode_create_getfile(gmem, size, flags);
 	if (IS_ERR(file)) {
 		err = PTR_ERR(file);
 		goto err_gmem;
 	}
 
-	file->f_flags |= O_LARGEFILE;
-
-	inode = file->f_inode;
-	WARN_ON(file->f_mapping != inode->i_mapping);
-
-	inode->i_private = (void *)(unsigned long)flags;
-	inode->i_op = &kvm_gmem_iops;
-	inode->i_mapping->a_ops = &kvm_gmem_aops;
-	inode->i_mode |= S_IFREG;
-	inode->i_size = size;
-	mapping_set_gfp_mask(inode->i_mapping, GFP_HIGHUSER);
-	mapping_set_inaccessible(inode->i_mapping);
-	/* Unmovable mappings are supposed to be marked unevictable as well. */
-	WARN_ON_ONCE(!mapping_unevictable(inode->i_mapping));
-
 	kvm_get_kvm(kvm);
 	gmem->kvm = kvm;
 	xa_init(&gmem->bindings);
-	list_add(&gmem->entry, &inode->i_mapping->i_private_list);
+	list_add(&gmem->entry, &file_inode(file)->i_mapping->i_private_list);
 
 	fd_install(fd, file);
 	return fd;
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 18f29ef93543..301d48d6e00d 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -6489,7 +6489,9 @@ int kvm_init(unsigned vcpu_size, unsigned vcpu_align, struct module *module)
 	if (WARN_ON_ONCE(r))
 		goto err_vfio;
 
-	kvm_gmem_init(module);
+	r = kvm_gmem_init(module);
+	if (r)
+		goto err_gmem;
 
 	r = kvm_init_virtualization();
 	if (r)
@@ -6510,6 +6512,8 @@ int kvm_init(unsigned vcpu_size, unsigned vcpu_align, struct module *module)
 err_register:
 	kvm_uninit_virtualization();
 err_virt:
+	kvm_gmem_exit();
+err_gmem:
 	kvm_vfio_ops_exit();
 err_vfio:
 	kvm_async_pf_deinit();
@@ -6541,6 +6545,7 @@ void kvm_exit(void)
 	for_each_possible_cpu(cpu)
 		free_cpumask_var(per_cpu(cpu_kick_mask, cpu));
 	kmem_cache_destroy(kvm_vcpu_cache);
+	kvm_gmem_exit();
 	kvm_vfio_ops_exit();
 	kvm_async_pf_deinit();
 	kvm_irqfd_exit();
diff --git a/virt/kvm/kvm_mm.h b/virt/kvm/kvm_mm.h
index 31defb08ccba..9fcc5d5b7f8d 100644
--- a/virt/kvm/kvm_mm.h
+++ b/virt/kvm/kvm_mm.h
@@ -68,17 +68,18 @@ static inline void gfn_to_pfn_cache_invalidate_start(struct kvm *kvm,
 #endif /* HAVE_KVM_PFNCACHE */
 
 #ifdef CONFIG_KVM_GUEST_MEMFD
-void kvm_gmem_init(struct module *module);
+int kvm_gmem_init(struct module *module);
+void kvm_gmem_exit(void);
 int kvm_gmem_create(struct kvm *kvm, struct kvm_create_guest_memfd *args);
 int kvm_gmem_bind(struct kvm *kvm, struct kvm_memory_slot *slot,
 		  unsigned int fd, loff_t offset);
 void kvm_gmem_unbind(struct kvm_memory_slot *slot);
 #else
-static inline void kvm_gmem_init(struct module *module)
+static inline int kvm_gmem_init(struct module *module)
 {
-
+	return 0;
 }
-
+static inline void kvm_gmem_exit(void) {};
 static inline int kvm_gmem_bind(struct kvm *kvm,
 					 struct kvm_memory_slot *slot,
 					 unsigned int fd, loff_t offset)
-- 
2.43.0


