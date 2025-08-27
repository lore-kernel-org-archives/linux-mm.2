Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CA0EDCA0FED
	for <linux-mm@archiver.kernel.org>; Wed, 27 Aug 2025 17:57:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 23EC96B0028; Wed, 27 Aug 2025 13:57:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1EF846B002A; Wed, 27 Aug 2025 13:57:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 08FE46B002B; Wed, 27 Aug 2025 13:57:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E45C76B0028
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 13:56:59 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 9EFBA1A07A1
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 17:56:59 +0000 (UTC)
X-FDA: 83823293358.10.28D1046
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2058.outbound.protection.outlook.com [40.107.223.58])
	by imf08.hostedemail.com (Postfix) with ESMTP id AAE1C16000F
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 17:56:56 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=oDdokA9v;
	spf=pass (imf08.hostedemail.com: domain of shivankg@amd.com designates 40.107.223.58 as permitted sender) smtp.mailfrom=shivankg@amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=quarantine) header.from=amd.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756317416;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=A0nnKIa3fB80RQGX3kJyww6wM0HfvupvypZK8/xUXow=;
	b=3bPxCHy5FFv0Xa16VbqgrC/3Ha7gbo5bZvU52hyTjZdyrdZtjqxlsZgPPO3C5tVetRnbcP
	zZvzoNyV2pJjvAHshq8ywt1r7xy45v7zFdLPbc6zbVNsZNh4SkGY/knoVPWcJLeyp+HcRm
	7/t5/mfDMIAGatyrflpeBddZTjJaBGM=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1756317416; a=rsa-sha256;
	cv=pass;
	b=wvh2dvTTboVHFY6ziNP19ZTYPA+LXJNvlfxUU+lgVWXOlScL/HLxoarGHGh3lUW5Wd9B3k
	7TMMLfEMKnxTeIwBIPZG7dHaoS6NPZ0vIM0NeRBxPVFWp5P/SBuZhfbEuLGKQjrkF5ICEa
	Ovh9hH+rCPpxBXb4h8DvHXKn2aZFU0U=
ARC-Authentication-Results: i=2;
	imf08.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=oDdokA9v;
	spf=pass (imf08.hostedemail.com: domain of shivankg@amd.com designates 40.107.223.58 as permitted sender) smtp.mailfrom=shivankg@amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=quarantine) header.from=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=UXnTPHKyv1nDXQJWMhwrKz/nt0iolhGyAvEbYXVEZKyV+/0jyqwdK+jWU6zxpOOZg0idn4dAnlQ+NuX4mUQKaYyTdBnFpgHHJcgUZSJVC2P7UoFnUsQaCYFezIfhk0Cuc4WHd6ykUo+7Stms7f0H3fGeX2jdvnxvqw9kd0VNsEK7be79jpUmWWvJK6lcswrQmYrJYD8ZqqYbn3vM+p3oGWvfTkoBLpc6iFkPV/xi3FAJSysXPnwWaqcwaUrCAnjLCo5Nk9T4w97rwAWmhaLk8E0oxWuHXCNOjfuj6mgnaDdVbFVcFgASWMbmWYVMWksUW+72Irq5EdX5WAEZk+v8yg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=A0nnKIa3fB80RQGX3kJyww6wM0HfvupvypZK8/xUXow=;
 b=PEIk1eLLtCTBadu41JU7RySTbFXBaJ4YINdFMpczQyu18k7SuqHe5jOtcmsdRe9x6UHWOrmdHRJbJCZWu5PHq592IiO46oP7Wz25iuB1yDET7uThyT6yB2qtv2rLOx66t0qx/6nnPcmvRoVRj+pAVCmOvoOKVPyZoKvNGL2dbW4SKXuiS+j8wgbxmF0sGef6hWl3bsoUR6K+p5zWZBtv+uLxI7AN5vQ5LI5gybdFAj+ClQwcT/NQd5UnVfKmzgiz0VJI41bMVJQH5ThJYoiODbwoV3QISKNYkr58fGppV93f895aEJcwByk39Dm8i50GINnLiUbq7z9+/2MEpD3WDQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=infradead.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=A0nnKIa3fB80RQGX3kJyww6wM0HfvupvypZK8/xUXow=;
 b=oDdokA9vj1qBq0EWgL/ag7syWpLz0scUptC18KROxSdRSpMvkwdjYk7zMEg1vlfWt/MqibgJ3Wk4rA6kT9DLrJMFcM4cSxswApW94Gtzv8Z4oDYeEuKT3Yf38SeqIu+X95eR/al+KrlfqMCCeNtryFk5iczBzUPGmU9cMwMBC6w=
Received: from SJ0PR05CA0176.namprd05.prod.outlook.com (2603:10b6:a03:339::31)
 by IA1PR12MB7638.namprd12.prod.outlook.com (2603:10b6:208:426::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9052.20; Wed, 27 Aug
 2025 17:56:52 +0000
Received: from SJ1PEPF000023D1.namprd02.prod.outlook.com
 (2603:10b6:a03:339:cafe::f0) by SJ0PR05CA0176.outlook.office365.com
 (2603:10b6:a03:339::31) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9073.12 via Frontend Transport; Wed,
 27 Aug 2025 17:56:51 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SJ1PEPF000023D1.mail.protection.outlook.com (10.167.244.7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.9052.8 via Frontend Transport; Wed, 27 Aug 2025 17:56:51 +0000
Received: from kaveri.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Wed, 27 Aug
 2025 12:56:32 -0500
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
Subject: [PATCH kvm-next V11 4/7] KVM: guest_memfd: Use guest mem inodes instead of anonymous inodes
Date: Wed, 27 Aug 2025 17:52:46 +0000
Message-ID: <20250827175247.83322-7-shivankg@amd.com>
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
X-MS-TrafficTypeDiagnostic: SJ1PEPF000023D1:EE_|IA1PR12MB7638:EE_
X-MS-Office365-Filtering-Correlation-Id: 95a29057-cc32-4698-c021-08dde5931a1a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|36860700013|1800799024|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?i3KQ0j7McdOxYOFPFL0m8TPaMCgp8xeFB6O+KjyWPp9F6MD001Up1p0cDH4Q?=
 =?us-ascii?Q?RT0W5PyI7le/R/yJkINzgwvud+MlyoTwEaNohEdqS53rfvQGmAPIcxMZ6jHX?=
 =?us-ascii?Q?uxKbc1x8FKN9obvIEFa/Tm2I1Sr3KDay9KzMEAJVsDZVEnoD5pnkv+hbiJ+j?=
 =?us-ascii?Q?1H/VdB/1NJxR5FwsE1RKJ9A9IGO91zrlIXea0uHhr1IvNotJGs9AH/XdH8or?=
 =?us-ascii?Q?Q4znvbYGoZUYFd6bMXu5TML8lDL2fM0PeIwniRMfv2e1glQmIlrpHQ4uUUvk?=
 =?us-ascii?Q?M8opoyXxaK9gLfFgkKsyVClmFb8kdwu9gsp7kllR7JyLYwV1Yn1R4VLZEHPA?=
 =?us-ascii?Q?8yPJxSGjsszAqzaJh55XUnrVgVtkqRuVGfyzGz1XE5WSZkrbAiu5XmTJeT94?=
 =?us-ascii?Q?GMKSTpJZTAufEb+LmjhpFxLCouihhtT/BmNDs+1NG9+zj4mN9yGbYxr841EC?=
 =?us-ascii?Q?FdsDbihUXd/fwJybhmBqdsNosKishcE71erYYOkhMGRNOYdrQtXii0jSoX3s?=
 =?us-ascii?Q?Kk4LJi8lRnkiqlr4vJDvKxWR+MV+UwTDczN68Shcobc2vS/RPBKEUk4BU4ot?=
 =?us-ascii?Q?hkLsrt7kjYbJ6ZXz9tXzA4ojul8+oF8ftmVrzcoJpnwcPl8kpN2AcbXuiBh+?=
 =?us-ascii?Q?ihZPBD38jIZUmlxkcpMUQLDe70te3YLsCuYjkSxO/2EN6I2CDwAHmpxFc2L5?=
 =?us-ascii?Q?JCxHMGU3Xga2K8JobPG+A1UAQ4g91vZxYeJET+7E64QOkCEW0rgI3QBt4rtF?=
 =?us-ascii?Q?Ok1Fo+06vqqUY9lzJdHMGxtwHFXeVciOAzxqTpbWEvgquOIAv1dC4naUwmu4?=
 =?us-ascii?Q?5/2vf4KK0Z61FS0zQM3ywhGaPtXEJWszzWjpka58z+QY6CPI4+ICf0pmGLL4?=
 =?us-ascii?Q?AVtL2MvX9pqVBwbP2ftJqzzreFVaMyAjh1IbQfnxlNYG8TmmDHR0YO2LO2ZB?=
 =?us-ascii?Q?CxdWeL55q+C9hrOSU+QmZEqmcAGDis7XDHROlISJpBgimvl93hYWfLXNn6+k?=
 =?us-ascii?Q?nHBcAFDsupl5gJozNEl3XrL6lf1VqFvgLHZRGiNMp/BUFULjML/4bDV1WSkU?=
 =?us-ascii?Q?UokBon3QtoMjPF7j6f1WSjN/se17UByr/rglClycZ1HguQCVov+xmIJxebC/?=
 =?us-ascii?Q?kaxiYpqsRbNnsRz8SLCWYyHTQpCDX3H3zzhFDC4h+dvXvyrc69LCf6lJpKas?=
 =?us-ascii?Q?x/Y2jFmYIsejbAFY8KoKfB8UhHZMO+O2jd35wdFLY27Q+13BsByhynbmuMoJ?=
 =?us-ascii?Q?JjiBSw78k4nVk/YSBkmqK4hskiZ0xcj5is32WKEus56cvfZU3J0Am9WN/kya?=
 =?us-ascii?Q?98bIN1Bch/spIXt8R54G3irZElzOutaJRY58ScildLHF8iD44CW3lm5jHODd?=
 =?us-ascii?Q?qS8FgVn/aTVoqK0jmp31M0zJU2svmtk1ZoaFJYxrawU0DNSICKLjlua1GaJh?=
 =?us-ascii?Q?anLGy1GozUzHFiY6fwjN3NWaelPlTz8SJs+4pdd+1SBF3jN2i9u3Qhj9zNZv?=
 =?us-ascii?Q?xHB46yWP81j/qLt2vJlcRu+NEOEObScWCPgp?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(36860700013)(1800799024)(7416014)(376014);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Aug 2025 17:56:51.6050
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 95a29057-cc32-4698-c021-08dde5931a1a
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF000023D1.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB7638
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: AAE1C16000F
X-Stat-Signature: g9hri6mz5ojrnfabc3s9i5pex14ok95t
X-HE-Tag: 1756317416-69494
X-HE-Meta: U2FsdGVkX19Q6awMsGc8EA8mEnYMLim2k+DmZDidvIGpQc3BmhT/y6w+OoWGwJaHfWTTiy7omlS62C+XzE/K43xqsF+wu8WyZuJLmriXsIcnh09zbIBZTMCYX38dZCyZH06X5utNvKVzjoIq0zorPxc+MbmPlvRmqHEgP5+VgRTyPWS8tdC/35+j5mJkRC/rj56Z2mCuAMtnPv5mB0fGRQdXbqiPjKVkDckq3yukaijj4ARRwwNEnP8/45wU3GF0bFQKRb61pwMFHSrTso01k15TJCYMCsbZOHu8KeM/+mlLdEkseqObeN88Gn1dfydSd6Ee8Jhvwdz0R6B6ByzDcUeEfDfhbyewprvwoBn9/G5qSWkT0KcZ8EXaUkVxhVWXDTv08Hu80yZ4JXHX72YdVhwwBPzNIiNglRy6woPj3t9c5gFGR/Dj1gZXGWpaHbD4Sj5VwvXngduRXJxdrcK6qaeEkjPHxlSwIH6A6QXYvNOK1L61qO9kvM5wOV8JmEZeMnZX2Uqb6maYO7F74xeffvuuhPFuxjDSdG2btWWJhabgG9SUhcGOnlD+zLdyeZp7KqzJA9EeNO0a8PS9XKAkz2mV2fzSUMiTJAK8ThpknGf7FrCVchnrULmOWjDScEYR9jdmRknYkrovdOGSpjr40aEc7yrIS4KWXO9mOuaWYs3SbpXSwJG0tMpnuPWeFqH1xFSEA0eVkQHKhQvk0Bp+oY7cafHpFHpby1jU8Yuhz0gZFz09Di+CCkOZwsQ/UsJOQ4PYkYvj2LQz0F1iI6zmqdv2JlJMgPluJEAc4mehvNbzIH2wJ1PaqH7XTGs9jXc813IoZsYDnqGhBJgRgcNldRfYIBiRtQgPVpPRWBnDW+etfE9EXTcCPoKBHMkvDkBSCJgjwJenBM0URZvy5S0kghxp67qd9xueOOhfJ7ik4HP5rkAsy1TEVRzBzgoP1zdxBF1whKw6Q9Ms3dt0t0a
 8Du64Sjp
 4AQRDfAQTvrf0hdhVzD6gazhGm6sy6bqst0Nc5/+iYtX56j2YrTyXDfuFZYKHOo60p6nBc6Ic9A+nKQAFFo7aSW05DAi4ZYTlL7F5UuPP3jyZqowrWSDABD5iQU2sWYdFusU91uomtBaW6YqWt592TaZ8GRGxLlexkjSRkz3l6lK4XK6ufNCcFzZrwkeTJ+vU1ObrdUm1F6JIDPe6+KvL7dMWC7sDQ8jJH8s1+IxKhXa+Gf9pIYvaSJB86GAZroFeWSBfrQry6uPDZl5BfWH0X8Rckfviuw7kRPP/n8fnnhLbA1mL/Y0V6sS+YtlHFSrZ2oYbmiBL52gae1R8I5qHWqouN0HWFKysw5d58HoybV0Z2OlgAyc8YjKr0YyOcRNdnhwgQsJxFp5YPPFj5/u8tzoSz/HT1YfQCGrEpgSe8oVtqgTFjUVlH/+RxHs/I53zyXfWiKxcmU3JqGvBbkmVzg9vUl/JfEwYLXuHtyuCB66BWfSmEwjNbps4Q3ishsicAla1Ux2RJIl47EqzU4HlWbw/i4XTIUqRM/jjfmhLiORMPQsvmDbJEzNJyd2xCgB5FaTJBM0ysSrTo5uBlz1O2j1cosff+2prhXWLr934FdslFkG7kEQw3SBmheJ3QKPBeVyrGhy+3fgnM0yOxYlvPV0C/bli40jsGNUwY4UypGxVscrkKlYDreU3Qt30vmD8CVu67twYVpRsZkqeGQyhYwJuEIJsQvcPkRyqWdT7aHkouNkqfao3pvcX/+ZLILKeNYKLIGz1ThrP19A=
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

Acked-by: David Hildenbrand <david@redhat.com>
Co-developed-by: Fuad Tabba <tabba@google.com>
Signed-off-by: Fuad Tabba <tabba@google.com>
Signed-off-by: Ackerley Tng <ackerleytng@google.com>
Signed-off-by: Shivank Garg <shivankg@amd.com>
---
 include/uapi/linux/magic.h |   1 +
 virt/kvm/guest_memfd.c     | 129 ++++++++++++++++++++++++++++++-------
 virt/kvm/kvm_main.c        |   7 +-
 virt/kvm/kvm_mm.h          |   9 +--
 4 files changed, 119 insertions(+), 27 deletions(-)

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
index 08a6bc7d25b6..6c66a0974055 100644
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
@@ -463,11 +503,72 @@ bool __weak kvm_arch_supports_gmem_mmap(struct kvm *kvm)
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
+	/* __fput() will take care of fops_put(). */
+	if (!fops_get(&kvm_gmem_fops))
+		goto err;
+
+	inode = kvm_gmem_inode_make_secure_inode(name, size, flags);
+	if (IS_ERR(inode)) {
+		err = PTR_ERR(inode);
+		goto err_fops_put;
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
+err_fops_put:
+	fops_put(&kvm_gmem_fops);
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
 
@@ -481,32 +582,16 @@ static int __kvm_gmem_create(struct kvm *kvm, loff_t size, u64 flags)
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


