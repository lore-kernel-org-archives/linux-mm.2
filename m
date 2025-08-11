Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7312ACA0EC0
	for <linux-mm@archiver.kernel.org>; Mon, 11 Aug 2025 09:07:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F3F598E001B; Mon, 11 Aug 2025 05:07:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F16BE8E000A; Mon, 11 Aug 2025 05:07:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DB7D88E001B; Mon, 11 Aug 2025 05:07:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id C88418E000A
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 05:07:40 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 7ECEF160773
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 09:07:40 +0000 (UTC)
X-FDA: 83763898680.03.0B31BC7
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2068.outbound.protection.outlook.com [40.107.237.68])
	by imf24.hostedemail.com (Postfix) with ESMTP id 87EA6180007
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 09:07:37 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=wjgGGC80;
	spf=pass (imf24.hostedemail.com: domain of shivankg@amd.com designates 40.107.237.68 as permitted sender) smtp.mailfrom=shivankg@amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=quarantine) header.from=amd.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754903257;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3X17jLWl9NZlz5hTLZR2DO4sWr968T4USn5/oBTg7DM=;
	b=k2g4kpCELaBg4ijzywImIfCDcNeUk18kuYEP9KpXRSwzyLa4zDqTsSpqC1mq5fKUQHnVSF
	+arN6RH4wYo9uGs+8tqikBz/qaBN85AhNLM5JMwIyr2CJoYbloeSihoQI82ZhH62q8XVSg
	sfTowl7ocEmpXkrPdgkNcC0Tc17YPEs=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1754903257; a=rsa-sha256;
	cv=pass;
	b=IHTzPwhq2Zqd+PzTgFisBnDvq6tkgRJ9Jwd7U8qjG3MhSo8d8gGFxOfNDYRrWEkaY2WkyD
	kBHuN9/ne009krfxcJSci4TY3FQLbgeU7r0KFmq7w5+832S1ImNULAJvaLhKBJOtTs3eSI
	m9zrDZ9K4n34dzj5nSYjODEzO5T1mFM=
ARC-Authentication-Results: i=2;
	imf24.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=wjgGGC80;
	spf=pass (imf24.hostedemail.com: domain of shivankg@amd.com designates 40.107.237.68 as permitted sender) smtp.mailfrom=shivankg@amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=quarantine) header.from=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=DJctWfe6ZX1TnKovy7lQGYsTC6MvpsftXUdIfyi0WBB/+qK8LJuqKvghGS9Qihxs7O9hV/e2XKpuT6FchHs3cLM7BnRlqE6RxrY5iZQ86TLLpTp5uEG66pk4t+iCJwnOhj5PZRRWX4aVluBK4kcl0XEcoZAqTLiiXE6YozA6I8rdUKlQ4MUba9RwmhFW+ZbGzmOxFuDjdwOB3lvc+GqUPjGwxb+i/KorscJnn3QTt2sW58wDnTGbWL3cy02TVF0H7eTS2vU5OxcPdwAKy6RpG0a6cd9s2JmZmoGrlfkxjb6IePXjrZ6hbtDwcffAu4PZyFJcHrPOkqjQKw5rqJRC5g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3X17jLWl9NZlz5hTLZR2DO4sWr968T4USn5/oBTg7DM=;
 b=k1tbGo97dUlLs5sIr7L8K+Mtyb/Tuop+wgeLS/iXmtvcK3F6O0qWONARoxjzsLsUQWEF2TVTj0DU4T2JuFdzxvfIqsQT8GJRNpMiGXUhDAnvN4emqPG0AXF7TiPNacoZiYGYh15yd/6oirJAwoDkh3vNe/j1vcdBsI0wVlkH3Oec9wDadxI3dmUbZneKO+ULsV0EEU9XEpsoURcWgmwag9wHDNli9VWAcOR8hOrXUOXdR8mg0DXIMntaWWchuElbEhORFg8GENYDXKpqzHXQ36bFNjfgMU5mRt/xYcSNeaSef/7cNcm80BK0SBnYn/Tgxq6ol8lU3F+fLZleiBtzhA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=google.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3X17jLWl9NZlz5hTLZR2DO4sWr968T4USn5/oBTg7DM=;
 b=wjgGGC80XsKj5NgoBgrNBcd7li88LshRPXYMPbDPRd6vUgFtyRlBwh4LIGtX7iT6mEkP5k5uqQNxjjAQ65Cb8BGh1VrhN0yQcmsZnnOaEQ3cU3fVhEoMRbvXSn0afr9pXx9qC1pFLJ9IZW6yLIicOuU13LjnuDYHhpvUwOknQp8=
Received: from BN9PR03CA0361.namprd03.prod.outlook.com (2603:10b6:408:f7::6)
 by SJ2PR12MB8980.namprd12.prod.outlook.com (2603:10b6:a03:542::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9009.21; Mon, 11 Aug
 2025 09:07:31 +0000
Received: from BL02EPF00021F69.namprd02.prod.outlook.com
 (2603:10b6:408:f7:cafe::8d) by BN9PR03CA0361.outlook.office365.com
 (2603:10b6:408:f7::6) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9009.22 via Frontend Transport; Mon,
 11 Aug 2025 09:07:31 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BL02EPF00021F69.mail.protection.outlook.com (10.167.249.5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.9031.11 via Frontend Transport; Mon, 11 Aug 2025 09:07:31 +0000
Received: from kaveri.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Mon, 11 Aug
 2025 04:07:14 -0500
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
Subject: [PATCH RFC V10 1/7] mm/filemap: Add NUMA mempolicy support to filemap_alloc_folio()
Date: Mon, 11 Aug 2025 09:06:00 +0000
Message-ID: <20250811090605.16057-4-shivankg@amd.com>
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
X-MS-TrafficTypeDiagnostic: BL02EPF00021F69:EE_|SJ2PR12MB8980:EE_
X-MS-Office365-Filtering-Correlation-Id: 7a8f5065-38a4-4380-e403-08ddd8b680e8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|1800799024|7416014|36860700013|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?/7hdfl6bDhdJ29RqZVHWtNWbN6RvjrRjFB3wN25wIzxbARFjsn17RycWQ6j+?=
 =?us-ascii?Q?xIE6n1OKyh34y8HLwoQ6s6kwrQ+HQNKWEWHS441YEBVF3x8edSxs2ZGQ09sd?=
 =?us-ascii?Q?6hb1n1eLOi/UEg/LGcfTvkGiDKjineGT+ihNX/WqGL66RMSsWKpfeTtTA6vf?=
 =?us-ascii?Q?HERmAIsxibNd1zHTFsEihhnY16B5CSQuCGCulfWm1/vr/9zEVoneNSROFdk8?=
 =?us-ascii?Q?yrWf5grw63gsd/A9X0059lPPn3Ozf/nDaZCMwhWg1o5dT711IS9S38hbvWTw?=
 =?us-ascii?Q?j9F0DRGsb98wpxClrCETVWBTeg0a2pb8aR9yCjth78ssmwO7hfdUonfjTwdG?=
 =?us-ascii?Q?pDWqO/zm96h2BAtLeNLMCsHOr4vAoh9UlRG4uNmlyDqp+/ERoMCznwUrduTN?=
 =?us-ascii?Q?tfdd+2qTFPfNfOlP75QKzlX7ndyEEXPIrcF1lTti+XGo7rL9UgqOBEVF6ot3?=
 =?us-ascii?Q?gepJSffDZ7RemWsmF7pNhoBVL6BMQZzeafmcKPu6sa47sYR4tqA6f9qqgRcz?=
 =?us-ascii?Q?0bFVqnzLmyFmlShMx85a9JRxA1Goqz2rF2OsVe1Yn13xVYqlrRDcXucMbV3Q?=
 =?us-ascii?Q?taDxgWhi4/cLDWtiJlBrBBwVJ4BdOCx+0p7zbgl5dTTKwnHq5cQTqFBYEGup?=
 =?us-ascii?Q?3YooE0LFD6Vh+L0rUsA3DNvREv70OTGIbJXg74WnPn5Fjck/+AwTOFLBKFv4?=
 =?us-ascii?Q?5ehasO5zzsIUA7MpRrPfLJbM8IlukhUpzv4IgJpkLAQg8GjBW6gKzzaC65R4?=
 =?us-ascii?Q?maUcZRLMN2CBAzwbNOLP8tM3T87Vca1vmqwdr1U6PDOm2zIUMC4upORIs8c/?=
 =?us-ascii?Q?R48gIKFZZ6XVizXIE2pCXGKMcJVb7NlweFtoty2EvRrRJGHggYX+fBLvZDaO?=
 =?us-ascii?Q?skqemQG7mfIQKfZQxYKBTfOHZr5MqId9fRFHlZ/vZ7iobV6/s0zZjnQdUGmY?=
 =?us-ascii?Q?IiZQiXhb3x4SghzqxQlTYzztcTAZ6japJ9roP5z1kqVgaac7XmvZOJDOkoO7?=
 =?us-ascii?Q?+GR+yuf5vSdprm+diZZm2z9Tc/R9QIfSJ/RPSScmQHp0lj78aFk+sb60P+d0?=
 =?us-ascii?Q?SXq0WmRcpBGjjWcO/26RWypp7umrl5XnF+7Ik0bodcYgwjSKzXTZDl3tNc2d?=
 =?us-ascii?Q?kqZyB9QniWbxyF7JDNYsE7qrn77Lkn3Ap6RubKfR+Doi2opYkQFkZ3lGOwfi?=
 =?us-ascii?Q?rxDqoNCnFj74l01jPQ/Ds2hgpZZ/cvQVkcdMtMnm45e1ryrwRAsnb8ouPyF7?=
 =?us-ascii?Q?pGCsfOH1MixWqZTRI7rVal3fPV2FhW9CLmn9dp+0gUcJWmiiZhDL60bXySfd?=
 =?us-ascii?Q?m56i1/mBQrWc5Zm8WCzOPE/VCS+xQxuNIA4ERcJGlxP8xbyFMRbB9DSQi4Zk?=
 =?us-ascii?Q?lxML513N7E4CEYftIgxIhQDQnVYBovN2mZyEgB6nrRbQk1lJciDjbMDkYk/X?=
 =?us-ascii?Q?szHcUDlir+1upzsFXBtNPKbhzM+v9+iyGNxk+vv7h+aSsTloX1Y/xTDEJ4Ma?=
 =?us-ascii?Q?kCkWpBZKt6+FDULcMh6QFf4jbjEuEuk6FlDf?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(1800799024)(7416014)(36860700013)(376014);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Aug 2025 09:07:31.4441
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 7a8f5065-38a4-4380-e403-08ddd8b680e8
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL02EPF00021F69.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB8980
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 87EA6180007
X-Stat-Signature: rn7y671ri5yfrmq7bgeifrd8e4gjonfg
X-Rspam-User: 
X-HE-Tag: 1754903257-658040
X-HE-Meta: U2FsdGVkX19OydSlk/aGuhzo8BqcKTBTRrMQhbKVKGtqUnIkNMDFt0qWe2HUe6BaTp8W2XHJTqJXhyO5gDDaxJ6kd65rGRloEFNPfQeQUAV54OvuvqiXGGCg1R3gT7mbksaMCE8Z+O7XyjyOgzHOQ1xbBMHgCzB1U26QY9HRVLi0ak616EQwl+VrtMmv15KkIq7Lbf9d7uId46pvJ7qFr8w2iFkQ2VAwBN5Qi4BxskNwQslfAXEtX65XKPAiqySRuirZl1/gxNfsPnDFLH5oQKCU5Y3aFxjxfU4GaARP71+wSQiODmL6PWQyK0TkOh4dvLRn9taXxLOoxFKy1iY4x75KVBj4E0I7I4C2MPhAeQuWXsJxm5RPM4A4HaqL26nxlNfh5+RiH4ZsVFZYOt5y+o8GXDpEyz/EJmv5MRVtqy7zH070ZWg2/Kv7Ae6DqhYAHghodOol8FCpyj3ED2e4cD6NUCgwxfem152O+sQm9nZBxA2QwBNxIMZ09EHwdsRuFx2vKufagzjFXjwWjctGEMH5+K6C3anmxZEw0BtYLAwc0UKcjOUI2TVIZKXChpD4qmom1n/b2GN1sntuppsmYw922Ek3B6jUKF1i7IOJn4L7hyG3JlwQa87rxy2FY6d7sr1WtSuYaFSR+DORjVGY/fNyYSkIJqNehO1+9svDDUXruUthJ0EE1t13fDwqJgtK5cWYWxUIGlvhmkuo9C+eEQzuPYt7hc7iqp+25EDmKDBzW2uaFwbKjjc88h0IHnBHQ0kRJ9ddii1y0/1BrljjOp25eaVwGYL6YIPbyiIkPiKY5sivVZD5inCeGUc9368QdXpU+5iRMHZp3/QXc3fGeyI7mgOUOvrhX4e3+3d+rLHCjTMPHyM2J3DNBegDBqDk1LWK+Tc4x0Tb99zQsBx9ISNra26vTEmNUiV4xftIJ/UAUBGI7lFzIy+CDQp0aBykX90oWjooDZeYUD+g2M3
 ZUr0BZo5
 hUGLVZo0U0NoWyURQNDW2PtFK5TFPqV4r7yPFIGm9QbJ5DyEibTGeyKaHwZiPCK2F6AwUcqBaZ0TD+SNEnQKoncB0Ti2mCIf9IINf8TziXKMUHfNeHoMcEcn5gsQKwjRjbcKHygd/rogQhwZJ/MHFZly61lPeFLCUxrC4+WKThSR/pBlrx13ryBHMlySJ63a23PNUToOHGVyOAxiNF00y8HwFEdQbbT0EYYZv6nxCUnclVUPiyHJ7Q44q6hWfNuq1aaAm1Skbn319I5Ah+x77SI+D0PMnERqUVpQ9Ze/Rs0G0qaajCvRktuZ2KYsnNZgz/8VKTaUwKRUsVfm24ByA1vjYf0MC7I1ilr7li5eBJF2SSHedng9hj2lgzFWeW4vT8/dEpbibNXzLy4zU2/iJxbibj1fPu3g7t1M8n1yvvjYEI4WPa+NwF2gMgxScxJeg01fJRh8pbOvr1cWuz71q7cTAqom0oChRZZHo6vFJSIeIOp9Plx4Ly2FjpyiakUFZubwHUEP+CPhpy41RigOrQMr1hu/TLY68JgiegHLWYW0QgDNE7ZAMwu6X2c/lfumaTVQLEkoaXPBLetHFd3PKCzajXZMxkNDqXb3heoHZ2EJ//3uckQJhkj1gchflfF69hdTHWE7ReAT6XPMnZTCCJBfoRM46eDaSrG8eYQ/G7KWEPQ/Rya+BDGAyLqBiQAWm+JmYi3OfCLSA8O2YBCCoZE+Ijei9wNajVHZxbTk6vs6YFkr9mXmBNxD5Yf5Xe6yhdF21LBUxQF9HD9kFJ7w97YTwM2/vzsQjIaWaxiSIHW7AFtc=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Matthew Wilcox (Oracle)" <willy@infradead.org>

Add a mempolicy parameter to filemap_alloc_folio() to enable NUMA-aware
page cache allocations. This will be used by upcoming changes to
support NUMA policies in guest-memfd, where guest_memory need to be
allocated NUMA policy specified by VMM.

All existing users pass NULL maintaining current behavior.

Reviewed-by: Pankaj Gupta <pankaj.gupta@amd.com>
Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Shivank Garg <shivankg@amd.com>
---
 fs/bcachefs/fs-io-buffered.c |  2 +-
 fs/btrfs/compression.c       |  4 ++--
 fs/btrfs/verity.c            |  2 +-
 fs/erofs/zdata.c             |  2 +-
 fs/f2fs/compress.c           |  2 +-
 include/linux/pagemap.h      |  8 +++++---
 mm/filemap.c                 | 14 +++++++++-----
 mm/readahead.c               |  2 +-
 8 files changed, 21 insertions(+), 15 deletions(-)

diff --git a/fs/bcachefs/fs-io-buffered.c b/fs/bcachefs/fs-io-buffered.c
index 1c54b9b5bd69..3af2eabb7ed3 100644
--- a/fs/bcachefs/fs-io-buffered.c
+++ b/fs/bcachefs/fs-io-buffered.c
@@ -124,7 +124,7 @@ static int readpage_bio_extend(struct btree_trans *trans,
 			if (folio && !xa_is_value(folio))
 				break;
 
-			folio = filemap_alloc_folio(readahead_gfp_mask(iter->mapping), order);
+			folio = filemap_alloc_folio(readahead_gfp_mask(iter->mapping), order, NULL);
 			if (!folio)
 				break;
 
diff --git a/fs/btrfs/compression.c b/fs/btrfs/compression.c
index d09d622016ef..139f9609e737 100644
--- a/fs/btrfs/compression.c
+++ b/fs/btrfs/compression.c
@@ -474,8 +474,8 @@ static noinline int add_ra_bio_pages(struct inode *inode,
 			continue;
 		}
 
-		folio = filemap_alloc_folio(mapping_gfp_constraint(mapping,
-								   ~__GFP_FS), 0);
+		folio = filemap_alloc_folio(mapping_gfp_constraint(mapping, ~__GFP_FS),
+					    0, NULL);
 		if (!folio)
 			break;
 
diff --git a/fs/btrfs/verity.c b/fs/btrfs/verity.c
index b7a96a005487..c43a789ba6d2 100644
--- a/fs/btrfs/verity.c
+++ b/fs/btrfs/verity.c
@@ -742,7 +742,7 @@ static struct page *btrfs_read_merkle_tree_page(struct inode *inode,
 	}
 
 	folio = filemap_alloc_folio(mapping_gfp_constraint(inode->i_mapping, ~__GFP_FS),
-				    0);
+				    0, NULL);
 	if (!folio)
 		return ERR_PTR(-ENOMEM);
 
diff --git a/fs/erofs/zdata.c b/fs/erofs/zdata.c
index 792f20888a8f..09e2ed2ae0d1 100644
--- a/fs/erofs/zdata.c
+++ b/fs/erofs/zdata.c
@@ -562,7 +562,7 @@ static void z_erofs_bind_cache(struct z_erofs_frontend *fe)
 			 * Allocate a managed folio for cached I/O, or it may be
 			 * then filled with a file-backed folio for in-place I/O
 			 */
-			newfolio = filemap_alloc_folio(gfp, 0);
+			newfolio = filemap_alloc_folio(gfp, 0, NULL);
 			if (!newfolio)
 				continue;
 			newfolio->private = Z_EROFS_PREALLOCATED_FOLIO;
diff --git a/fs/f2fs/compress.c b/fs/f2fs/compress.c
index 5c1f47e45dab..56a51c9ba4f1 100644
--- a/fs/f2fs/compress.c
+++ b/fs/f2fs/compress.c
@@ -1942,7 +1942,7 @@ static void f2fs_cache_compressed_page(struct f2fs_sb_info *sbi,
 		return;
 	}
 
-	cfolio = filemap_alloc_folio(__GFP_NOWARN | __GFP_IO, 0);
+	cfolio = filemap_alloc_folio(__GFP_NOWARN | __GFP_IO, 0, NULL);
 	if (!cfolio)
 		return;
 
diff --git a/include/linux/pagemap.h b/include/linux/pagemap.h
index 12a12dae727d..ce617a35dc35 100644
--- a/include/linux/pagemap.h
+++ b/include/linux/pagemap.h
@@ -646,9 +646,11 @@ static inline void *detach_page_private(struct page *page)
 }
 
 #ifdef CONFIG_NUMA
-struct folio *filemap_alloc_folio_noprof(gfp_t gfp, unsigned int order);
+struct folio *filemap_alloc_folio_noprof(gfp_t gfp, unsigned int order,
+		struct mempolicy *policy);
 #else
-static inline struct folio *filemap_alloc_folio_noprof(gfp_t gfp, unsigned int order)
+static inline struct folio *filemap_alloc_folio_noprof(gfp_t gfp, unsigned int order,
+		struct mempolicy *policy)
 {
 	return folio_alloc_noprof(gfp, order);
 }
@@ -659,7 +661,7 @@ static inline struct folio *filemap_alloc_folio_noprof(gfp_t gfp, unsigned int o
 
 static inline struct page *__page_cache_alloc(gfp_t gfp)
 {
-	return &filemap_alloc_folio(gfp, 0)->page;
+	return &filemap_alloc_folio(gfp, 0, NULL)->page;
 }
 
 static inline gfp_t readahead_gfp_mask(struct address_space *x)
diff --git a/mm/filemap.c b/mm/filemap.c
index 751838ef05e5..495f7f5c3d2e 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -989,11 +989,16 @@ int filemap_add_folio(struct address_space *mapping, struct folio *folio,
 EXPORT_SYMBOL_GPL(filemap_add_folio);
 
 #ifdef CONFIG_NUMA
-struct folio *filemap_alloc_folio_noprof(gfp_t gfp, unsigned int order)
+struct folio *filemap_alloc_folio_noprof(gfp_t gfp, unsigned int order,
+		struct mempolicy *policy)
 {
 	int n;
 	struct folio *folio;
 
+	if (policy)
+		return folio_alloc_mpol_noprof(gfp, order, policy,
+				NO_INTERLEAVE_INDEX, numa_node_id());
+
 	if (cpuset_do_page_mem_spread()) {
 		unsigned int cpuset_mems_cookie;
 		do {
@@ -1978,7 +1983,7 @@ struct folio *__filemap_get_folio(struct address_space *mapping, pgoff_t index,
 			err = -ENOMEM;
 			if (order > min_order)
 				alloc_gfp |= __GFP_NORETRY | __GFP_NOWARN;
-			folio = filemap_alloc_folio(alloc_gfp, order);
+			folio = filemap_alloc_folio(alloc_gfp, order, NULL);
 			if (!folio)
 				continue;
 
@@ -2517,7 +2522,7 @@ static int filemap_create_folio(struct kiocb *iocb, struct folio_batch *fbatch)
 	if (iocb->ki_flags & (IOCB_NOWAIT | IOCB_WAITQ))
 		return -EAGAIN;
 
-	folio = filemap_alloc_folio(mapping_gfp_mask(mapping), min_order);
+	folio = filemap_alloc_folio(mapping_gfp_mask(mapping), min_order, NULL);
 	if (!folio)
 		return -ENOMEM;
 	if (iocb->ki_flags & IOCB_DONTCACHE)
@@ -3916,8 +3921,7 @@ static struct folio *do_read_cache_folio(struct address_space *mapping,
 repeat:
 	folio = filemap_get_folio(mapping, index);
 	if (IS_ERR(folio)) {
-		folio = filemap_alloc_folio(gfp,
-					    mapping_min_folio_order(mapping));
+		folio = filemap_alloc_folio(gfp, mapping_min_folio_order(mapping), NULL);
 		if (!folio)
 			return ERR_PTR(-ENOMEM);
 		index = mapping_align_index(mapping, index);
diff --git a/mm/readahead.c b/mm/readahead.c
index 406756d34309..a4dfa837dfbd 100644
--- a/mm/readahead.c
+++ b/mm/readahead.c
@@ -183,7 +183,7 @@ static struct folio *ractl_alloc_folio(struct readahead_control *ractl,
 {
 	struct folio *folio;
 
-	folio = filemap_alloc_folio(gfp_mask, order);
+	folio = filemap_alloc_folio(gfp_mask, order, NULL);
 	if (folio && ractl->dropbehind)
 		__folio_set_dropbehind(folio);
 
-- 
2.43.0


