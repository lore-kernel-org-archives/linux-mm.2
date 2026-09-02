Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AAA1BC61DD6
	for <linux-mm@archiver.kernel.org>; Wed,  2 Sep 2026 10:54:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AEB506B00C0; Wed,  2 Sep 2026 06:54:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AC2EE6B00C3; Wed,  2 Sep 2026 06:54:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 962AF6B00C0; Wed,  2 Sep 2026 06:54:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 591C16B00C1
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 06:54:19 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id E3B3BA01A6
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 10:54:18 +0000 (UTC)
X-FDA: 85168512996.21.8EBADE9
Received: from CO1PR03CU002.outbound.protection.outlook.com (mail-westus2azon11010063.outbound.protection.outlook.com [52.101.46.63])
	by imf17.hostedemail.com (Postfix) with ESMTP id 2416440005;
	Wed,  2 Sep 2026 10:54:15 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=XkSr4OIV;
	spf=pass (imf17.hostedemail.com: domain of shivankg@amd.com designates 52.101.46.63 as permitted sender) smtp.mailfrom=shivankg@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788346455;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EUHxLZc87SIo516dLR77xd1rSetSYWKvVm1R29rwnEo=;
	b=6Pp5N5PU5hCzwLa4hl3bICJ4boMBJGxbVWNrGCeTnI2VOrrL3GfxMAuo4FDbx3BZwdaEh4
	BdGrZiARwqw7hZurUnHtMn3P7BZFdNpO+2ArDhhyAiSa6iy1iyu+jHD4mb8ElxtsUx3QHm
	+oNQqVX5gnqlMm2iWoawflD9t4x4lxc=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1788346455;
	b=KKJjnBAXW4hOIxwH7IIkFL3OrOL4gHoJbo2Ph+LLtTi5/smroXJEZlYRV0vC8r6611tp0q
	jWtXwkSGLfSgB0c1VN0QnF6OosB1it8sh/d+cgl+sE4xD66wmtz9/kRgjeCWN3+SA0eOB6
	ASG2R1aISGgtDRCT7avGMNQA25aJ7nE=
ARC-Authentication-Results: i=2;
	imf17.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=XkSr4OIV;
	spf=pass (imf17.hostedemail.com: domain of shivankg@amd.com designates 52.101.46.63 as permitted sender) smtp.mailfrom=shivankg@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=iIaoH0+VMqzW4UnCD/UPupJ3APS7/eh14+pokliPzOyQoNk68yQNASNKuzwAFyKDRzBJRA9WRDtfAqXHvvDJRH68DR+7wZCSs+8NlFr/2hapwcD7y7WiedacDyt3DZf6Unj/aatADOHIoCVs75eXGVHvendXS58XnrhFghQVmOSO3pmEI9cf9ipk5HWvWPJsX8yg7nlLoDXoc9gBDwxOZoglIvOuznCW1kOcMDFfU7eYbzvz881rt0f1GCMrkscf7b3acKLoBSHKIbetu4P4lnR1pP31i4doqLGlEx4DH1dsm1Ur9MM0W+uzuZ6phpT49wJ0Len86uzGVrXBFWf/XA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EUHxLZc87SIo516dLR77xd1rSetSYWKvVm1R29rwnEo=;
 b=DaM5DE60asU/X4fCw0hPREJNYlnf7Yzekpw1pBVAWcAhUwbroSjnETeEf/VMKOBIpqu4EOuOdj1vIlzs2q/o84bGxj0gjShiS5TtWtHcchdVhw0Zo1cs6Lxss6Y0gqYkwNTK9eykZ2WBvjSTxT/+CLDGgtjPMsns1Cn/5xPLcVNAAWFj/MwSB/ByCfNbmUb/+6w5+r4IcluChYYGmXdiup+EnOuGS0mVgq7uXjzIo5nTcjunn37vPkMEDbOYjcLncqP/yW47WbTNJMkR+PymwUN3oxsgO4YBlpFEHOguIKTCxIKGXzWSOw0E/xAeVOWwQx/qxMo72iviGfpmAFxRgw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=sk.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EUHxLZc87SIo516dLR77xd1rSetSYWKvVm1R29rwnEo=;
 b=XkSr4OIVNDkzw4Fd4JubaEBjjaNHFc6KjZoEKeDbEFwTO7+X1RJ1v1dV9PFStwADGlz4J49KS+Cue7/JaLMu3iN7V7uPDAWU8BkG2Th6TkFBVOAlnoehF2BAJMVb7I7ngit0Bhw88FHKWISWpgeN+PeubhoPeuULK0R91JjOPZI=
Received: from BN0PR08CA0022.namprd08.prod.outlook.com (2603:10b6:408:142::7)
 by PH7PR12MB5805.namprd12.prod.outlook.com (2603:10b6:510:1d1::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.360.13; Wed, 2 Sep
 2026 10:54:08 +0000
Received: from BN5PEPF00046987.namprd02.prod.outlook.com
 (2603:10b6:408:142:cafe::78) by BN0PR08CA0022.outlook.office365.com
 (2603:10b6:408:142::7) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.382.10 via Frontend Transport; Wed, 2
 Sep 2026 10:54:07 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 BN5PEPF00046987.mail.protection.outlook.com (10.167.245.36) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.382.8 via Frontend Transport; Wed, 2 Sep 2026 10:54:06 +0000
Received: from [127.0.1.1] (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.46; Wed, 2 Sep
 2026 05:53:52 -0500
From: Shivank Garg <shivankg@amd.com>
Date: Wed, 2 Sep 2026 10:52:20 +0000
Subject: [PATCH RFC 06/11] mm/migrate: rename migrate_pages_batch() to
 migrate_folios_batch()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-ID: <20260902-migrate-refactor-shivank-v1-6-9dcca87669c4@amd.com>
References: <20260902-migrate-refactor-shivank-v1-0-9dcca87669c4@amd.com>
In-Reply-To: <20260902-migrate-refactor-shivank-v1-0-9dcca87669c4@amd.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1788346348; l=4160;
 i=shivankg@amd.com; s=20260518; h=from:subject:message-id;
 bh=Fqi07cuj0t9DVgFdFNJBSPyRAcnfPff5xqiyG0YOAAw=;
 b=VHLvgbIhFwCVKeh3oI8OLZ9ydq0iu/G94dLsgBxliBbC+D46x3iUwPS7POszEmY//eC7P6oMg
 gV+QETr+4YXAqnn+IE+sRMapWHGUQIqQCmMzyFGF194eBrHcUM44WS9
X-Developer-Key: i=shivankg@amd.com; a=ed25519;
 pk=2l2QGTeXuGkZTtfmx0nPQU8iFZfjYmX/ymMojitevx4=
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: satlexmb08.amd.com (10.181.42.217) To satlexmb07.amd.com
 (10.181.42.216)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN5PEPF00046987:EE_|PH7PR12MB5805:EE_
X-MS-Office365-Filtering-Correlation-Id: 1e69fecc-25f3-4590-34a3-08df08e08298
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|23010399003|36860700016|1800799024|7416014|376014|921020|11063799006|56012099006|10067099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	wCiWB8umVAN6134xVLMiVPh1HwKUaAPCTI8G4upmfK1rHsH3dPW+47NrjMXaBHkbxJP0py2uYnXLmWTub5t3bIPD5GQn5PswYtQKA007xX6m3iIdRh+PvedmBXNkFfWw3uk1Zs1n892OyOQCMUyErlgHqzXEHxSv7WQEUUth9G78c2UY171U8hhNaRAuEmXXHmkaNAr6kCQttBt05WD5NbxwWr02nSEC5hyZBDh6UZcC6U34cyg4nHhZZ/NefebEZrbyC56nKd1ikttLU4k7PxZPLxPqZ9L/bGc4MzOqeSumrL5Pf6kOeABSNFg5p26wfM6+fhZBoJeY7CyTyH8ytNkM2tlyZ2sEWuT1z92MBM0a5O8BBT1QcwdxYc6cvcUlOX2A9GwBZajnWuYfH10S1xV1HWTEr2/22JGNPQ5bX7RGWKEYm5Bbmc5kn6eK8SuYWLCqEAlBf8q0rlxoaITygu9B8fgzJJgSk3K76CsmPI4P1zDNaXg/FA6vQqQf3IlvH4i5dkQUkDu9St1Dtq16LSuMVAUbQL8LLdM+xNkdDhY7tGL4yl+ayev7tV2cY019zCRv0sFGy1yjkYHeQmzSSVm8u/VxIJHWG1p6Bei1spQFwfhrpDDFvHx6iLPYFUcs55QC+wYEmzom0x6REQZByfUIAJ3KrJtHFft3qM1hQBBaGxB38HLrutWSYIXyLAkDRcpptrV122T+tAOTCdhLeKVwL8BLrejgSyLKANPrUrfZsN/S0rWMabr84xd+3xAn
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(23010399003)(36860700016)(1800799024)(7416014)(376014)(921020)(11063799006)(56012099006)(10067099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	Vcf/vHEnOgh/JYtjSJnVGWMwa4G08e5YASq1Da20l61TbFQrUh0TfM/Ey4IZLrnoEOh85gSJoY7XmnsLH6NBvpQGpmKulUgKmI3Cey5TUpjZU0eFCPlikBZ7+oqj8PW4EuGHkYMBLZIiineTHxGRDJTOLwkrnHtKHQIWie+PNrhK3xcv9gLtKOvWf/hbK+uWaAHTsaKNszgZkpLbnbQbX2XNrzPDtEJRDWzwn68YTRheZ0vPJg1EEtAVDQjFkBC2zV43XitVIQoh8AyvQ2Qk5L3LW7VozovrkM3uTu9n+aG+EFiuKVQ/ocAW2vFytHVL8nMWZX9jLvXnjCvoNgUCUmWUC8pNmGc8diOSsK52WyxWEGnOy0LuFMCGM76zyY/Z20ehf1BrE5NEIgLv0UlkQOXkmZjQsMIyggkWD7dC9JFsALXTshnFjcHfhLHK3i6q
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Sep 2026 10:54:06.6144
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 1e69fecc-25f3-4590-34a3-08df08e08298
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN5PEPF00046987.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB5805
X-Stat-Signature: 5qp7shobro6duoh6y4kubpa443f5snns
X-Rspamd-Queue-Id: 2416440005
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1788346455-590766
X-HE-Meta: U2FsdGVkX186DTy9YIw8TH9ui4KPJmtjt8NgYtUUBtBEOU1aT7vL1AhwKI+s+l8DdVq3FChRKDOiVwD40efM74ebRonSheQzFX/lHBbb1mEZoIrwSoAB5QqCIvj0Q7NICDcoGT4vfqWdEAn2YrJZN9CdXijsE5zdum/VXJ9yiPCbpJFxA25HhIZ5foMEUyFn55tDJ2HHHf7XgFKzOV5X6iHguRjHUOeBp4I5Fzcb4kcU8xdSIQjv2o18g1x3h0ec4QH0gKiFZwErfeS2wsf/U5Tc6kFAgjcpLJyMAxqOQJZ7ndB8ggjdgUYjrMj3dL7d5sb5QkNni3jFepLp21GdaC+Qwk+76dsTRyT46g8AWLWZjwwbO3HsKrwh0KnP4ugmrDXMux6efcMeRWjv14yneNOdb34ghCbZ9d5PSt0wqX/QMdM/bIvREdjOMz4Z51YKfSyP3mjcCSuJiNNEha5QCHmhwZ8F3kgt7BKzQ8labag6Dy+wgsirwwD9pFCa8HrHo2vLV3pN5yR53vtFjKFA1ZEmRj+A2oEh00EoLTbNNB/LUSc/ZPsQDsa8Fkt3IgXISYpb77uYyGyOdQdHa3d3UIbISq4Ky0ChkT3hELJ7RcCQly+5v3X/x+BroGIoJz0c5rHM4EzKePi9dj65izFZBWZMZezPGbh3k1XV7Xdirfy2WCDTPqks2row7TeEQVBmleO97KHEAhNi/Tk3ob53JkjUO/dhAPjP4z4ms0jk4JYUhpZUnlIS8PXztXrv+ulzTBfxJccFVU6fNrG28elJUSrFQkGWUqaG8SwCobYEjq0VJlJQ45jHwCCbAvkXvHYrBlyMUlL4HqFrGsgdYyuvwnyE0DkegOKT5ackARvZJiC4Os5ivp2fC8MmPDvkc/vOalGyCAkcpn1jrVU3fAX59aJNut1r43SgdcW/agXlal2Qq8QtizzsUcJRHogPDzdwBIaod2fSo9uWUgwh3XG
 Cuw1QkOt
 EysZys4EEwo7mM50wHSXUiVsDLC87zGYPFL68OMpy5qnAjbtecDzXj7Oks5gPiPUaL6c6heLQ1DXlJJ5aJuu+eUP2S60EiUaKctOdM0OoinXJUvTmEFSuUC4mAnEGNMClrz97xNZ1TnEewzdkdrm/B96XOovZdCyB3RHBZ+w0HIHdne96drb9eQOKHKbMEILWN8vstfUqyaFEIpCGZ08Z73H/pml//ni71dQdWDlBgBaGO23/KZX+AeRY7QDKWvs44hiM15fXtOr5eIA7wAMtSCd3NONCNE1os1NZXZTlwiKiL1L7PkuwWpvjBXqE8UDIDgtg6DZ9ISt5X7RkQwvfAnXRpZB7DIlWimb9pdFFThsvu/M58D/SkeQi5nqakUIxPLfawQE671A1+r6dMvbVdN92x52NaBlpS9vtFoVKtRacJM/Nhayg9zJv86/+ZzKvh2cxEQuhOwrgrNsXgcdbfKCgsL+0ybhYN4W+qb0e26LIzPnIyZECiEFpMfeuKCqJeDpIa/ZQ3VZUt+Xxtsu+PjWFaCSSx9Rt7LAFkSuHPYHw/IifBHSu2uhvLYKLTPxvw5Kcbr0Vqw66rn8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

migrate_pages_batch() operates on folios and calls the folio-based unmap,
move and undo helpers. Now that movable_ops-based page migration has been
separated out, rename it to migrate_folios_batch().

No functional changes intended.

Suggested-by: Zi Yan <ziy@nvidia.com>
Signed-off-by: Shivank Garg <shivankg@amd.com>
---
 mm/migrate.c | 22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

diff --git a/mm/migrate.c b/mm/migrate.c
index 55f352efdf2b..163f13344fd2 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -2003,7 +2003,7 @@ static int migrate_folios_unmap(struct list_head *from,
 			 * always reports success when its fromlist is empty.
 			 * stats->nr_thp_failed should be increased too,
 			 * otherwise stats inconsistency will happen when
-			 * migrate_pages_batch is called via migrate_pages()
+			 * migrate_folios_batch is called via migrate_pages()
 			 * with MIGRATE_SYNC and MIGRATE_ASYNC.
 			 *
 			 * Only check it without removing it from the list.
@@ -2135,7 +2135,7 @@ static int migrate_folios_unmap(struct list_head *from,
 }
 
 /*
- * migrate_pages_batch() first unmaps as many folios in the source list as
+ * migrate_folios_batch() first unmaps as many folios in the source list as
  * possible, flushes the TLBs, then moves the unmapped folios.
  *
  * Only MIGRATE_ASYNC may batch multiple folios.  Waiting for a lock or bit
@@ -2143,7 +2143,7 @@ static int migrate_folios_unmap(struct list_head *from,
  * Therefore, if mode != MIGRATE_ASYNC, the source list must contain at most
  * one folio.
  */
-static int migrate_pages_batch(struct list_head *from,
+static int migrate_folios_batch(struct list_head *from,
 		new_folio_t get_new_folio, free_folio_t put_new_folio,
 		unsigned long private, enum migrate_mode mode, enum migrate_reason reason,
 		struct list_head *ret_folios, struct list_head *split_folios,
@@ -2194,9 +2194,9 @@ static int migrate_pages_sync(struct list_head *from, new_folio_t get_new_folio,
 
 	memset(&astats, 0, sizeof(astats));
 	/* Try to migrate in batch with MIGRATE_ASYNC mode firstly */
-	rc = migrate_pages_batch(from, get_new_folio, put_new_folio, private, MIGRATE_ASYNC,
-				 reason, &folios, split_folios, &astats,
-				 NR_MAX_MIGRATE_ASYNC_RETRY);
+	rc = migrate_folios_batch(from, get_new_folio, put_new_folio, private,
+			MIGRATE_ASYNC, reason, &folios, split_folios, &astats,
+			NR_MAX_MIGRATE_ASYNC_RETRY);
 	stats->nr_succeeded += astats.nr_succeeded;
 	stats->nr_thp_succeeded += astats.nr_thp_succeeded;
 	stats->nr_thp_split += astats.nr_thp_split;
@@ -2221,9 +2221,9 @@ static int migrate_pages_sync(struct list_head *from, new_folio_t get_new_folio,
 	list_splice_tail_init(&folios, from);
 	while (!list_empty(from)) {
 		list_move(from->next, &folios);
-		rc = migrate_pages_batch(&folios, get_new_folio, put_new_folio,
-					 private, mode, reason, ret_folios,
-					 split_folios, stats, NR_MAX_MIGRATE_SYNC_RETRY);
+		rc = migrate_folios_batch(&folios, get_new_folio, put_new_folio,
+				private, mode, reason, ret_folios, split_folios,
+				stats, NR_MAX_MIGRATE_SYNC_RETRY);
 		list_splice_tail_init(&folios, ret_folios);
 		if (rc < 0)
 			return rc;
@@ -2301,7 +2301,7 @@ int migrate_pages(struct list_head *from, new_folio_t get_new_folio,
 	else
 		list_splice_init(from, &folios);
 	if (mode == MIGRATE_ASYNC)
-		rc = migrate_pages_batch(&folios, get_new_folio, put_new_folio,
+		rc = migrate_folios_batch(&folios, get_new_folio, put_new_folio,
 				private, mode, reason, &ret_folios,
 				&split_folios, &stats,
 				NR_MAX_MIGRATE_PAGES_RETRY);
@@ -2321,7 +2321,7 @@ int migrate_pages(struct list_head *from, new_folio_t get_new_folio,
 		 * is counted as 1 failure already.  And, we only try to migrate
 		 * with minimal effort, force MIGRATE_ASYNC mode and retry once.
 		 */
-		migrate_pages_batch(&split_folios, get_new_folio,
+		migrate_folios_batch(&split_folios, get_new_folio,
 				put_new_folio, private, MIGRATE_ASYNC, reason,
 				&ret_folios, NULL, &stats, 1);
 		list_splice_tail_init(&split_folios, &ret_folios);

-- 
2.43.0


