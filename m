Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DF1A2C61DD6
	for <linux-mm@archiver.kernel.org>; Wed,  2 Sep 2026 10:52:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E1CC96B00AB; Wed,  2 Sep 2026 06:52:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DCCB56B00AD; Wed,  2 Sep 2026 06:52:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C94706B00AF; Wed,  2 Sep 2026 06:52:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 9A5B96B00AC
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 06:52:54 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 30F9A1C03A8
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 10:52:54 +0000 (UTC)
X-FDA: 85168509468.16.0B58B74
Received: from CH1PR05CU001.outbound.protection.outlook.com (mail-northcentralusazon11010016.outbound.protection.outlook.com [52.101.193.16])
	by imf22.hostedemail.com (Postfix) with ESMTP id 5EEE7C000B;
	Wed,  2 Sep 2026 10:52:50 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=T9hHbCS8;
	spf=pass (imf22.hostedemail.com: domain of shivankg@amd.com designates 52.101.193.16 as permitted sender) smtp.mailfrom=shivankg@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788346370;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=rdSNa3qRI/UUcKBfvFodPhN1IFVSUG1PSxLc+cwrLYQ=;
	b=YdW5m5yHns35KQhzsv4ATaU/inhPW+C4FJQy1JifwiQlkFWNR7/dz6I3yrNL+fHnjUU53k
	9AFCazmGLX1U+67Ys/R8v6Kqjrg5XigBcm+fUomIOBeFgmZZv1ZeMJW+HhEqCxwrnD9luY
	Au2vDISZNu3tZ6vx9RcHAPMJc9kyCns=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1788346370;
	b=esOciaSDBu4yWnwb0TLoKA1Falg0lclliIUdYVMJ0j3I4LS4UH+ExycTYAZ62H1tykM3xR
	Nq+j5hkq1dZFFq7GcEv69/4BA/DInf5Zsr0+O9JQB0ZaJpCLMZ2e4lEBvArse4LWba6o/2
	yBd/tYAf0MWQWaQ0D8eZhnrOtrDpqqo=
ARC-Authentication-Results: i=2;
	imf22.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=T9hHbCS8;
	spf=pass (imf22.hostedemail.com: domain of shivankg@amd.com designates 52.101.193.16 as permitted sender) smtp.mailfrom=shivankg@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=SM3u6QDPlMEAx/3xRp83f9Wd0Kky//1niIaSkceLnqy5wuIDdNmsltjtH2vRSsfZohfDr4z+G2x5V7gb+3x/Kt0cwK0JfoqudgCcHdYpGBH7gMHNQHWh69CphGhZaF5Aw7dDrTCUzJaJQqxbPpGYoPWjTXFkZezT4deVVmsChQbTgtcm/ixj6AzmnGOqG7/ZOmAvYFTkuVbOt4DdMVoTp9TnRiju7QeLgh3AAkUhwuB32/gTnhXZV/c5d+4OQV/iQesUiwqeGGLqKIwNido9DKFLP6umstIrH5g4YB0hEzKjmeevCalgbaAQyOsUmo9icGRZVBsmWYXlaJQExFlMLg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rdSNa3qRI/UUcKBfvFodPhN1IFVSUG1PSxLc+cwrLYQ=;
 b=dXkY5y4fnSq02SB495vJ2wCtEjBXO+AcLOKTqHUk2e7dm33JC2QO9S4YM63MZsYbDapFJEwWOZeGBe31Qc+XX5jfXf98YGvZCOV9aoOT2G+QD0Z/wdT/GkWzWszNw49tT/XxsJnMz8BTvGDIzGXBP2fJIuDZqSaM6mCOvGsLzxMdbYRzr1LKUrfakICZcXZiSzN7l9XOJVAyyoAP9fdOC/di/2JPuKO6wRK0tcTbtgqZ5gAc1nBLxv33Mt3rFZj7uHWe+gZLa3tZzacbysufw97fDcnCQhH6mtcJhpHqMAGOHJH4Z9JaFcUo3KIFMbrtSWmsLHyDJnyyoh65vm7EnQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=sk.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rdSNa3qRI/UUcKBfvFodPhN1IFVSUG1PSxLc+cwrLYQ=;
 b=T9hHbCS87fNFpo0RkP0VUglohQnSVbCSfoqy7XpuNdlkjE77c4DU+OmKcp8+9CPybZVp2P7U//4ojj9FiaGB0aacuZD1rIPOYh/uEfPZW1YUSd2LVDcBIsPpPrE6oTAeNjQVPmmvHtMvc82mgwce7MKCCbbQFBDNyixVWUR/RKw=
Received: from BN9PR03CA0600.namprd03.prod.outlook.com (2603:10b6:408:10d::35)
 by SN7PR12MB8817.namprd12.prod.outlook.com (2603:10b6:806:347::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.360.7; Wed, 2 Sep 2026
 10:52:43 +0000
Received: from BN1PEPF00004683.namprd03.prod.outlook.com
 (2603:10b6:408:10d:cafe::37) by BN9PR03CA0600.outlook.office365.com
 (2603:10b6:408:10d::35) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.382.11 via Frontend Transport; Wed, 2
 Sep 2026 10:52:42 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 BN1PEPF00004683.mail.protection.outlook.com (10.167.243.89) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.382.8 via Frontend Transport; Wed, 2 Sep 2026 10:52:42 +0000
Received: from [127.0.1.1] (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.46; Wed, 2 Sep
 2026 05:52:28 -0500
From: Shivank Garg <shivankg@amd.com>
Subject: [PATCH RFC 00/11] mm/migrate: separate migration paths and carry
 migration policy
Date: Wed, 2 Sep 2026 10:52:14 +0000
Message-ID: <20260902-migrate-refactor-shivank-v1-0-9dcca87669c4@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAN//l2oC/x2MwQpAQBBAf0VzNsXahKvyAa5yWGswydKspOTfb
 Y6v3nsPeBImD1X0gNDFnncXII0jsItxMyGPgUElKk8KpXHjWcxJKDQZe+6CfuHLuBU1UVbqcrK
 jHSDkRzD4/tcdtE0N/ft+mFMrJ28AAAA=
X-Change-ID: 20260824-migrate-refactor-shivank-4ee3949fcdcb
To: Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand
	<david@kernel.org>, Zi Yan <ziy@nvidia.com>, Matthew Brost
	<matthew.brost@intel.com>, Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim
	<rakie.kim@sk.com>, Byungchul Park <byungchul@sk.com>, Gregory Price
	<gourry@gourry.net>, Ying Huang <ying.huang@linux.alibaba.com>, "Alistair
 Popple" <apopple@nvidia.com>, Vlastimil Babka <vbabka@kernel.org>, "Suren
 Baghdasaryan" <surenb@google.com>, Michal Hocko <mhocko@suse.com>, "Brendan
 Jackman" <brendan.jackman@linux.dev>, Johannes Weiner <hannes@cmpxchg.org>,
	"SJ Park" <sj@kernel.org>, Jason Gunthorpe <jgg@ziepe.ca>, John Hubbard
	<jhubbard@nvidia.com>, Peter Xu <peterx@redhat.com>, Miaohe Lin
	<linmiaohe@huawei.com>, Naoya Horiguchi <nao.horiguchi@gmail.com>, "Oscar
 Salvador" <osalvador@suse.de>, Kairui Song <kasong@tencent.com>, Qi Zheng
	<qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, Barry Song
	<baohua@kernel.org>, Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie
	<yuanchu@google.com>, Wei Xu <weixugc@google.com>, Lorenzo Stoakes
	<ljs@kernel.org>, "Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara
	<jack@suse.cz>, Jonathan Corbet <corbet@lwn.net>, Shuah Khan
	<skhan@linuxfoundation.org>, Randy Dunlap <rdunlap@infradead.org>, "Alexander
 Viro" <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>,
	Benjamin LaHaise <bcrl@kvack.org>, Chris Mason <clm@fb.com>, David Sterba
	<dsterba@suse.com>, Muchun Song <muchun.song@linux.dev>, Dave Kleikamp
	<shaggy@kernel.org>, Trond Myklebust <trondmy@kernel.org>, Anna Schumaker
	<anna@kernel.org>, Mike Rapoport <rppt@kernel.org>, Sean Christopherson
	<seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, Bharata B Rao
	<bharata@amd.com>, David Rientjes <rientjes@google.com>, "Yiannis
 Nikolakopoulos" <yiannis@zptcorp.com>
CC: <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
	<damon@lists.linux.dev>, <linux-cxl@vger.kernel.org>,
	<linux-fsdevel@vger.kernel.org>, <linux-doc@vger.kernel.org>,
	<linux-aio@kvack.org>, <linux-btrfs@vger.kernel.org>,
	<jfs-discussion@lists.sourceforge.net>, <linux-nfs@vger.kernel.org>,
	<kvm@vger.kernel.org>, Shivank Garg <shivankg@amd.com>
X-Mailer: b4 0.15-dev-47d62
X-Developer-Signature: v=1; a=ed25519-sha256; t=1788346348; l=7312;
 i=shivankg@amd.com; s=20260518; h=from:subject:message-id;
 bh=Mu+TgUSXajmjBg2+WPbNk2V8+vggDvRasZKUX+O5vXA=;
 b=pKzNUrNsQcUH5z2V4LTXZuGoIw3KiYvNiznMLhPp5FE8keBeSIEGyXQ8Jw/+v1GPzgnggP3DX
 4CjbAsJnHq3Dvw+Jl5mAq1EE39USFEZuwnMD4HmbBQHJM7J0BggxsSf
X-Developer-Key: i=shivankg@amd.com; a=ed25519;
 pk=2l2QGTeXuGkZTtfmx0nPQU8iFZfjYmX/ymMojitevx4=
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: satlexmb08.amd.com (10.181.42.217) To satlexmb07.amd.com
 (10.181.42.216)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN1PEPF00004683:EE_|SN7PR12MB8817:EE_
X-MS-Office365-Filtering-Correlation-Id: 6c233c01-8b81-44f4-a03f-08df08e05062
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|82310400026|36860700016|1800799024|23010399003|376014|13003099007|921020|10067099003|6133799003|56012099006|18002099003|11063799006|5023799004;
X-Microsoft-Antispam-Message-Info:
	CjtcWHC6mMi7eBnyjzj+KlogDEs98f+Tjj+6Zi25/Ci595orlqlTRVGR6leyXf35TbQSOBX34GQ96RLC+60MSw0+o8eoRbIFUBE0/GqZTKva/3DW03sLEjbfE8YcgeZMheHBDq/HdOR6gQkcV6U4tU4/neU4APSNTyb3UJSS+1IKIoRHm/lLCspUhNYXBrLgzo5lNTlUMRWl2J3Gzz7RCD/SiPLescCuvbSBum/j+YgUQn+ZVv6jy33liK3bxfsbRXsnnPV25o+9cEEAAfG5rAR9enPRj4PIuQR3b6I9f9OtDCrPWHurWmp6IlJQIpcSdD0BXf5eGppFoAUQ8x6G851uEMOhccerURXMBVBKAt2hw/VBUWD1WO6xwLz9oNKmMC7n6DvXY85Z2yesB9YteGPjZPD4PX51qsMiM7w/Vgdbd/1vnhudifOM8zfain27iJSbv/G+p3h/EQ9uvvcifBqf51Zy6tKiE9Li+bOi1o2eT38HL2Z+se6xtIzdOdI/ivv/+I7NOk3VpCmvPU8unIgzsHQYt0/tXFmjgHgxIcRCToxeWDkY/I6XxZBJLsoUMxPBhtFz26giuZu/FRP1u1VUpYvcCBNpQk8DRw1TeoK2ub6tlgZU7XP4wootp89pbEGuBVDnr6mUYs5YCvPx6h96YGioeaeascH0hA+GVqmqa/Ctqg5xopXvD7Sh1/Vrhz7PWPbemsNmCy+vRPszzzea9EtDvmEzQTVvmpDEzPJYWDk7ayI5z0VrP2Ok/w+Q
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(7416014)(82310400026)(36860700016)(1800799024)(23010399003)(376014)(13003099007)(921020)(10067099003)(6133799003)(56012099006)(18002099003)(11063799006)(5023799004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	ggcarO+tyWKR8O6EsFWh0RBFqmpKPOL9XJGtBZhDrYozYever7JNK9scbsPVd17/mznrfVZvd+4oPhcjEK2WcaYR2S/jup0TE1hvnYJtQlupnLGtrjqR/73/YMdXk5C1otwzuUUwu/xC/YJip6BKXRAwK2g8fYzEVdHcJfFdtqDxsKUo13HE7TSTBG81YzKMcUTdrovTWP79Yvp+z31w45bXh24SaCQAVRxHXzvaa+i4uE3/1Y6TuvOTJhtj8Q7E7sw8dPVtbHFz4yePKfOpbEAUr+K/etTEtxFVWWOTuAkFOMtI34ix9lOZVBAJphRGUnbsCFkfaeplUH+ZKhtKDlODpXKEWrkps/NzhOJyoeKO/l99pwPao09lE9AM5uChyWK9kLWKV323qVOn9s1OFdqK3ZeZ2liCDe3jRBejH9QGkBQuvUN7siBD+7N0skkO
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Sep 2026 10:52:42.3795
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 6c233c01-8b81-44f4-a03f-08df08e05062
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN1PEPF00004683.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB8817
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 5EEE7C000B
X-Stat-Signature: yxau9i667tg13j87taq5jfmafsc6eqqt
X-HE-Tag: 1788346370-868849
X-HE-Meta: U2FsdGVkX19A8N17x/Rj3VuEb9PE1ATH15L8NJF52qCkPuzAw5HGUqquQiaySx12PcILHvrm4sncrOEry6ptuoSxzEhCrqP6EXE5NKqz8eugMlFj8/NCes/sU7g4iKZ49CMDQouMXch2UVi3ApuqmsZE/Kj/wIWYUE4xuwtOuwDlmtcfH/KsYzLRKvzY6nnO+n/niXoXwH4TbTcBryUjyyQ7Z23e5cwnLPJR5Qt07ct+uugr8gavRgiWAyiQ53EaGS8vjpS8EPRbcWrZ84BuMNqK/7r5rc+s+ffEI1b3YscJuPBoo5E8Yrqmkm86gVpdxPvAW4gyqwVUamG8AP6Cv1hfN1Kn7GFHIEgYMLG+f01R/y5iOpksSbWzQoVB9oW8NM4gQ8P3WBp0+2ZFPmn2w2ehOnIuFBi53EFwTbHloCQrfdwNdvxHzbfOT0Pr+ZAc1FIJmRpwkmLe7TWdnnPK3ayy+zowqaAC6AnwfrdUqILsvL3YHqHCw9Mt/Rm2UabzbKXmM3a5+JSUBhJoYNSMU6gr5m50MHOqemJoYMV0zVbcXrh+H0rgMQWyrjxE8xGLIOOSKRL3Er96msROC6pW4PFQoJCzTavXFNErLQfzmHlgTnQZiU67rTmTOwCkdtnkYVeFH2659m43jI3Bq4k0cKQk53h1XE114UasVGhXpzV37V0bbRRumrWvwDlZC6M+lkEIFXsQP1YBsRcvCoaQqBg8DHOYTck7u/COx2x/f4LzPgw2fKJqctaRowh0LSE7w6d88kdI1noNbvV3V0p993GFNwAuhOx/buzUGpiqZaIHOI18gU3ABxgW7hyEoh57xPMx5k9XGXACW6g80wfkWZrTzwbX3R1D5UBfuF0L2SxfBD/Jcq+PQR608w8SpYg+JTTIY8zDWLijVxcSYUXVg8bkdZcyGbd458/XNN18nZvHO8MUtNvEDi/JeYOC6yBxsrZVmtjwTcSjWr2Fw1L
 oQAS87H1
 fkAUxhkzk1U+3E2wdC25DRSAtdeyO6yndusA/2wgNaSBlX/RaXbJO5urppN8qbR9k0KAIZ5Hdv+loi1c3X+iXq/aEvLtGwWaqFBOkgvNLjrrjQ9WqNeJ2jn6qzNA91LkwU5H2O+cRyhazHj9wlr46DbdvFlqwiTaLw4OgXJdKLzuCpleVd5iyVMCfoEldcCCTHgCUPGQ1tfPTKqmyF6GwQRlyoiwBcQusRgJhNhjqCgVkb+mI8EQxPFSvIIxmUy+xgKnnDh0BRyg8kfkufTaSA8cK5niwMCDvmrY4XCImIUDoybky+zTYGfJ9PEjg2nWaT/xbb88z/NJy6GzSF1zCtZQTpgGgYMkNeYM5XYQyp0VdgOZweYMPtZplcvr45QbjC/MmgNENZeqBhJdb6bjOvgaqyAOYGUJGRj4tQiwBN9ZK1zFI1jLV76TsI9dADS18XTme+EkjgevEkqBLJ4sXwmfp7mTCWA/cOMvCti+YKtaF9DTpGpauH1hMJ5cFiyzJp5QKSbYchrKef72dXoOjXkQ7jjZx3zoHH+RTolloVkkjYrkPv+m39AMGXRq1/wVKy3B70RbLknd16/R91/nKgC/g97/UUm7ketzJarFsiqyNPuK+tqnLEvWDtg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

migrate_pages() handles hugetlb folios, movable_ops pages and LRU folios,
although their locking, mapping and retry requirements differ. It already
dispatches hugetlb folios to a dedicated engine but movable_ops 
pages still pass through the regular folio unmap and move machinery.

Migration policy has a separate interface problem. migrate_mode describes
blocking discipline, but it is passed independently from migrate_reason
through the core, and only migrate_mode reaches
address_space_operations->migrate_folio(). Adding another policy dimension
therefore requires more positional arguments, an overloaded mode or side
state. [3] 

This series separates the migration paths (classes) for movable_ops pages
and LRU folios, moves LRU policy into the LRU engine, and carries mode and
reason through struct migrate_control.

Thanks to Zi Yan and David Hildenbrand for the discussions and suggestions
that helped shape this series. I also used AI tools (Opus 5, GPT-5.6 Sol)
to refine my ideas, identify the edge-cases/bugs.

Old flow
========

migrate_pages(mode, reason)
  |
  +-- migrate_hugetlbs()
  |     `-- scan the mixed source list (from) on each retry
  |
  `-- split the remaining list into batches
        |
        +-- MIGRATE_ASYNC
        |     `-- migrate_pages_batch()
        |           inline unmap/retry -> flush -> move/retry
        |
        `-- MIGRATE_SYNC[_LIGHT]
              `-- migrate_pages_sync()
                   +-- try async batch pre-pass
                   `-- retry failures one at a time through
                       migrate_pages_batch()

movable_ops pages are identified by branches inside the batch unmap and
move paths.

New flow
========

migrate_pages(ctl)
  |
  +-- migrate_hugetlbs()
  |     `-- collect and retry hugetlb folios
  |
  +-- migrate_movable_ops_pages()
  |     `-- allocate, lock, invoke the movable_ops callback and retry
  |
  `-- migrate_lru_folios()
        `-- form bounded LRU batches
              `-- __migrate_lru_folios()
                    +-- async: migrate_folios_batch()
                    `-- sync:
                        +-- async batch pre-pass
                        `-- retry failures one at a time

migrate_folios_batch()
  |
  +-- migrate_folios_unmap()
  +-- try_to_unmap_flush()
  +-- migrate_folios_move()
  `-- migrate_folios_undo()

migrate_pages() now only dispatches classes. Each entry owns its lists and
retries; the LRU entry also owns batching and synchronous fallback.

Motivation
==========

This refactor makes the migration control flow easier to follow and gives
new optimizations clear boundaries and insertion points.

Separating movable_ops also prepares for memdescs, where these pages are
expected to lose their folio representation and folio->lru handoff. The
current list interface remains, but its folio dependencies are now isolated.

struct migrate_control is caller-owned, stack allocated and passed as const.
It carries mode and reason through migrate_pages() and ->migrate_folio(),
and provide place for future extension to policy. This is one-time pain of
updating callers, but doing it once avoids repeating that churn whenever
a new use case or optimization need additional policy.

Follow-on 
=========

This series establishes the class, phase and policy boundaries without
adding copy implementation. Possible follow-on use looks like:

Yiannis and Alirad's RFC adds an asynchronous non-temporal mode and updates
existing asynchronous-mode checks. [1] A separate policy field would keep
cache behavior independent of blocking discipline.

  /* migrate_pages() caller: demote_folio_list() */
  ctl.reason = MR_DEMOTION;   /* migration reason - already exists */
  ctl.mode = MIGRATE_ASYNC;   /* blocking discipline - already exists */
  ctl.cache_hint = MIGRATE_COPY_NT; /* caching intent- new policy */

  __migrate_folio(..., ctl);       /* NT/offload based on caller's hint*/
     `-> folio_mc_copy() or folio_mc_copy_nt() or ...

My batch-copy/offload series [2] can extend migrate_control to take caller's
preference of copy engines (like DMA offload, multi-threaded copy, etc.) or
batch size. Some of this may remain wishful thinking but that is what the
RFC is for :)

Behavior Changes
================

No functional change is intended for the LRU and hugetlb migration paths.

The movable_ops pass has three intentional differences:

  - movable_ops pages are attempted before LRU folios;
  - movable_ops pages no longer use the LRU asynchronous pre-pass.
    synchronous callers use their requested mode from the first attempt.
  - movable_ops callback returning -EAGAIN releases the destination, so
    retry allocates a new one.

Unmigrated pages are still returned through the original source list.

[1] https://lore.kernel.org/r/20260730-rfc-nt-demote-v2-0-452dbe3b5073@zptcorp.com
[2] https://lore.kernel.org/r/20260630-shivank-batch-migrate-offload-v6-0-da95d7e8b8a2@amd.com 
[3] https://lore.kernel.org/r/cae6ab98-3441-38bd-1e07-4586a85cdc74@google.com

---
Shivank Garg (11):
      mm/migrate: extract folio unmap phase
      mm/migrate: handle retries in migrate_folios_move()
      mm/migrate: factor out folio splitting on allocation failure
      mm/migrate: use a dedicated list for hugetlb folios
      mm/migrate: add a dedicated movable_ops migration pass
      mm/migrate: rename migrate_pages_batch() to migrate_folios_batch()
      mm/migrate: add migrate_lru_folios() entry point
      mm/migrate: move LRU batching into migrate_lru_folios()
      mm/migrate: thread migration policy through a control struct
      mm/migrate: pass migrate_control to migrate_pages()
      mm/migrate: pass migrate_control to migrate_folio()

 Documentation/filesystems/locking.rst |   2 +-
 Documentation/filesystems/vfs.rst     |   7 +-
 fs/aio.c                              |   2 +-
 fs/btrfs/disk-io.c                    |   5 +-
 fs/btrfs/inode.c                      |   6 +-
 fs/hugetlbfs/inode.c                  |   4 +-
 fs/jfs/jfs_metapage.c                 |  14 +-
 fs/nfs/internal.h                     |   2 +-
 fs/nfs/write.c                        |   8 +-
 include/linux/buffer_head.h           |   6 +-
 include/linux/fs.h                    |   6 +-
 include/linux/migrate.h               |   7 +-
 include/linux/migrate_mode.h          |  14 +
 include/linux/pagemap.h               |   2 +-
 mm/compaction.c                       |   8 +-
 mm/damon/ops-common.c                 |   7 +-
 mm/gup.c                              |   7 +-
 mm/memory-failure.c                   |   6 +-
 mm/memory_hotplug.c                   |   6 +-
 mm/mempolicy.c                        |  13 +-
 mm/migrate.c                          | 717 ++++++++++++++++++++++------------
 mm/page_alloc.c                       |   6 +-
 mm/secretmem.c                        |   3 +-
 mm/vmscan.c                           |   7 +-
 virt/kvm/guest_memfd.c                |   2 +-
 25 files changed, 563 insertions(+), 304 deletions(-)
---
base-commit: cee9395acd8043be0644b25c34bfa86623f2b935
change-id: 20260824-migrate-refactor-shivank-4ee3949fcdcb

Best regards,
-- 
Shivank Garg <shivankg@amd.com>


