Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C4996C43458
	for <linux-mm@archiver.kernel.org>; Tue, 30 Jun 2026 07:29:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AED8D6B00AE; Tue, 30 Jun 2026 03:29:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AC5906B00AF; Tue, 30 Jun 2026 03:29:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9DBBA6B00B0; Tue, 30 Jun 2026 03:29:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 6FF3C6B00AE
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 03:29:21 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id E95C31A03BC
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 07:29:20 +0000 (UTC)
X-FDA: 84935753280.04.FA911D1
Received: from CY7PR03CU001.outbound.protection.outlook.com (mail-westcentralusazon11010002.outbound.protection.outlook.com [40.93.198.2])
	by imf07.hostedemail.com (Postfix) with ESMTP id DC1FE40002
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 07:29:17 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=OG0nyvf4;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	spf=pass (imf07.hostedemail.com: domain of shivankg@amd.com designates 40.93.198.2 as permitted sender) smtp.mailfrom=shivankg@amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1782804558;
	b=jEm6A2b0cNE0Y95hasYTFmR152AL+enbu0DLe2AmK5iFItJ1hcl/FdWY/C+TcunOJX9tsC
	IJ2HyZFy0dgluW5Ws1p0x63FjIwodzrawEdTUgoviA8z8pU0J9P7POPYbbReHtSjVVySEj
	b4MNor7+vIOnIYLOODYD/Zqd4bvxfdM=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782804558;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HX3jhuNNy4i94tZMziuRlhLEz3C2r+Pm/L1TBQr02do=;
	b=tC1nqeGacpD7nmRqjNYTB5e3VEKMneQZ/yHc/U+0M32zSCM1KWe6XyPReN7XaHTap+YArM
	15F9zG6jQt7rm2+CEnw/H6jzTa6N+5kBsbIhzSeG1mcTggh/oyWDdwwAiNi2dpb/TDBCY9
	qZLg9MlrNIug06F6e8zUBW0L4CgQhng=
ARC-Authentication-Results: i=2;
	imf07.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=OG0nyvf4;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	spf=pass (imf07.hostedemail.com: domain of shivankg@amd.com designates 40.93.198.2 as permitted sender) smtp.mailfrom=shivankg@amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=P6aRy7/UZK7Jgn+QQZLec3FRpQ3s6enn26aAc13K5FX32hOVEytQx01cjU1LyGHWqujabp/l9wuI5JrSovVGV5gSYshm6SF2p/GzsqgknyB4BxDviLjNCOdsYt/dcAiewT4+Cgm80rZCwyPycoyNYDf4Arx1cQ9iknyOUMgGTPhR1x8foS86jDxZzC2MngjUj1nE5jOt+PSeVY9n3Q8RInpihMDve13Myzpq07p5a60Y+dLFfa3ecl59TV1bQTOgW0YIY27FNAc4nAFBfGL27F6l6UMIAXuOq76p6nEzR2UPRGo5Wi0qQo6Qai7rAhpp4N+/c+0jcaxEO87JBwlGUA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HX3jhuNNy4i94tZMziuRlhLEz3C2r+Pm/L1TBQr02do=;
 b=FYMSW9IWsGtRNaTOCWiJ4tpQFPpo0inDTRbuQ+lCbcjBG9BrAlQ8V8DMhZKyPoYQlb9bwv608dhapR9lCxIhEEWoLhIyfCc7yh4s/WkP9Djxh7Mg+BYTc1BU8v5lejY/aXLgI8BhkfvxLmYJfQC2p/AH6TzsPIwisSkFBVSJevjC6+JoLYqYjMAHop7Fi//DiUz64dPMYofLYiCeMqzYOUts7etHQ3oepabtMuAI0I54yb7uqod1m1oiwg3g8f7t0cJrClJBTidOUgX6qG3E/cddus5VHOyadLxetyrI/ZgEmQ0cDOzWTNT+6vhlvFknyoMtN1nLBakTPKqBwQCA/Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=infradead.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HX3jhuNNy4i94tZMziuRlhLEz3C2r+Pm/L1TBQr02do=;
 b=OG0nyvf4RX9RZ69KxsoxqQZBvgNlu4cK5+z7KN4eXpBk02AJQdGXZkXIl/j9rVarHk4DXtRhSQdnxiHZ6RMiYsdYSLgSiVUP2sihfmyAeknQukHWvkBKArrMNEA7QhZzoEN3IYOf39k+zROmPS2PmZLSIP4nJMiwlVE0bOs9zEo=
Received: from BL1PR13CA0366.namprd13.prod.outlook.com (2603:10b6:208:2c0::11)
 by SN7PR12MB7882.namprd12.prod.outlook.com (2603:10b6:806:348::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.159.19; Tue, 30 Jun
 2026 07:29:08 +0000
Received: from MN1PEPF0000F0E0.namprd04.prod.outlook.com
 (2603:10b6:208:2c0:cafe::2d) by BL1PR13CA0366.outlook.office365.com
 (2603:10b6:208:2c0::11) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.181.8 via Frontend Transport; Tue, 30
 Jun 2026 07:29:08 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 MN1PEPF0000F0E0.mail.protection.outlook.com (10.167.242.38) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.181.6 via Frontend Transport; Tue, 30 Jun 2026 07:29:07 +0000
Received: from [127.0.1.1] (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.41; Tue, 30 Jun
 2026 02:28:57 -0500
From: Shivank Garg <shivankg@amd.com>
Date: Tue, 30 Jun 2026 07:28:37 +0000
Subject: [PATCH RFC v6 1/5] mm/migrate: skip data copy for already-copied
 folios
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-ID: <20260630-shivank-batch-migrate-offload-v6-1-da95d7e8b8a2@amd.com>
References: <20260630-shivank-batch-migrate-offload-v6-0-da95d7e8b8a2@amd.com>
In-Reply-To: <20260630-shivank-batch-migrate-offload-v6-0-da95d7e8b8a2@amd.com>
To: Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand
	<david@kernel.org>, Zi Yan <ziy@nvidia.com>, Matthew Brost
	<matthew.brost@intel.com>, Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim
	<rakie.kim@sk.com>, Byungchul Park <byungchul@sk.com>, Gregory Price
	<gourry@gourry.net>, Ying Huang <ying.huang@linux.alibaba.com>, "Alistair
 Popple" <apopple@nvidia.com>, Lorenzo Stoakes <ljs@kernel.org>, "Liam R.
 Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, "Mike
 Rapoport" <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, "Michal
 Hocko" <mhocko@suse.com>
CC: Karim Manaouil <kmanaouil.dev@gmail.com>, Frank van der Linden
	<fvdl@google.com>, Teja Vojjala <tejavojjala@google.com>, Pravin Tamkhane
	<pravintamkhane@google.com>, Kinsey Ho <kinseyho@google.com>, Wei Xu
	<weixugc@google.com>, Matthew Wilcox <willy@infradead.org>, Davidlohr Bueso
	<dave@stgolabs.net>, Vinod Koul <vkoul@kernel.org>, Bharata B Rao
	<bharata@amd.com>, SeongJae Park <sj@kernel.org>, David Rientjes
	<rientjes@google.com>, Xuezheng Chu <xuezhengchu@huawei.com>, "Yiannis
 Nikolakopoulos" <yiannis@zptcorp.com>, Dave Hansen <dave.hansen@intel.com>,
	Johannes Weiner <hannes@cmpxchg.org>, John Hubbard <jhubbard@nvidia.com>,
	Peter Xu <peterx@redhat.com>, Rik van Riel <riel@surriel.com>, Shakeel Butt
	<shakeel.butt@linux.dev>, Tejun Heo <tj@kernel.org>, Fan Ni
	<nifan.cxl@gmail.com>, Jonathan Cameron <jic23@kernel.org>, Aneesh Kumar K.V
	<aneesh.kumar@kernel.org>, Nathan Lynch <nathan.lynch@amd.com>, Frank Li
	<Frank.li@nxp.com>, Dan Williams <djbw@kernel.org>, <linux-mm@kvack.org>,
	<linux-kernel@vger.kernel.org>, Shivank Garg <shivankg@amd.com>
X-Mailer: b4 0.15-dev-47d62
X-Developer-Signature: v=1; a=ed25519-sha256; t=1782804526; l=4281;
 i=shivankg@amd.com; s=20260518; h=from:subject:message-id;
 bh=1Kn4lFOmGuKFQBugICRVZHnjWPKJ+aEEJ9AyyNX9T1M=;
 b=0efkU7z0y7I+aroe5np4YuomuMXS0bdZ3szPiheII6t3tuPF14kU6JOuNgxp/8HTt4dN/09mn
 NnseAf5B2sxA7xG6IEGz0niXKmrQ1TxReYfpPctwQW5N/MuvynDP+gO
X-Developer-Key: i=shivankg@amd.com; a=ed25519;
 pk=2l2QGTeXuGkZTtfmx0nPQU8iFZfjYmX/ymMojitevx4=
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: satlexmb07.amd.com (10.181.42.216) To satlexmb07.amd.com
 (10.181.42.216)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN1PEPF0000F0E0:EE_|SN7PR12MB7882:EE_
X-MS-Office365-Filtering-Correlation-Id: c3e15687-8c82-492c-fbd1-08ded6794597
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|23010399003|36860700016|376014|7416014|1800799024|921020|22082099003|18002099003|3023799007|56012099006|11063799006;
X-Microsoft-Antispam-Message-Info:
	PAx2dlGKEi5VDTfulhDUifGzgtXjxkulaInRDeYoqRw2+KjAaI9MfG+VrMvvtG6pnDS+q54YCr43mqXU0ol098lCHot6Lhoul3dmGE97LyvrD3jBHy2Xny3yhTapT/ZfM7BzfwiT05s4uN63l39MHFcOvJeaqv3UqEBukwESU4/biAxxhJeKQriXlC3IYKTEyXsWXxRQBww3NsDdr+abKAsZcSGt//KNRdRswhPfdulefF/wPOIfr6FmkE9sVHwAJsA0fVEfLGnJW1qynjNzXSoX4xYbUgfR2uZDvfPIB3Frcz6sRqdx2axN140oWZKQPZMxkBzrzy/cOoiw0M8N2v88VaP2sQ05OBgytKu9kFqDPRPkm4tBZzoS4d1rKx6O/9vNCoiyIVHj22S8Bdui0lFgGlOHbPcv16HQmgeabC2oCpFfhe7pLnSnfnQc7jJtM+FDGAlzVLPS7C578+1EyfJ19ZnV/6hrkDnB3ABXGQukNaiQK7VChThHDhdX3zqqEBdPfhEVPXmiYEqlwiOGrk+YiwFAwmJoKIXpvSKckyojm1p6Pqbbj6hsHSlxx0zEdsOObzF7qB5EF3iz7ZddzKOHRFrio8wUkHr7EeFrC3GkO88YTC5QzZi0DkjDXiOq/ibUcverNTOqyHvwfeqWai0NtLN5AeoGHdtN9W+2BF9TPC+KdwrPdhg8JhINqrm/YWqQU3K32lnyqeLfEyB73ODfpiy2ZfegKLoocBO+NCIlnIP6Uoun4Qo8FiSSBzn/
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(23010399003)(36860700016)(376014)(7416014)(1800799024)(921020)(22082099003)(18002099003)(3023799007)(56012099006)(11063799006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	wWaL0SEWUpsJR7VqUIH+w4fyzxNkyvCPhMlWEVYP2KSSL1KOcFU29izSPcXcXYKJ934n0iIAGe7I8Fgd1ZJQ1/o22SWfp9dAevODuD5DOVlWbTD3OHqMJI4nhs9nlDaY3lFcJTkZTa1tYUc1J7jYaGQ60chNQCJ2RGkGblZ76wzO3yr0jq/7+fqXNMFtUMn5GAFzLTPPAiR9tBvH7NCcF/adNfe9JB05jUE3XQB5NhFJk8Jg3BGBPtNzqYPm3an3AbKpjynFRV9aQTQeIeJ+mAbp2Ythb/wgy/bB0L+c/tpW42rECKq7ws3mWMkCgJkZkWTeESK27tbzJy5BVZDWTQLpz7CYE2gaGXs1I9tT3StsNf8/W+4P82S+PfI5xcu7dU6aHzXtgnJV2VcxIxpFZPiU3PLuJ0tMHMgk/ydkm16KO7O5YDO1x4DTzPLQ6WlH
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jun 2026 07:29:07.9730
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c3e15687-8c82-492c-fbd1-08ded6794597
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MN1PEPF0000F0E0.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB7882
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: DC1FE40002
X-Rspam-User: 
X-Stat-Signature: sswwpxkyt17rc11pi48nagd1a4bcg8w1
X-HE-Tag: 1782804557-907197
X-HE-Meta: U2FsdGVkX181B4dNgzukbJiC7Tb+4+A1RGjLjjPwBcNL4q8LoH9bf8Bh2WFdoE5Boamgw2eKfgsbwacbJaJUwNxmSMs1Z651QpLlQdEUmuw1N/J8q72scfqdFrbQE2aOEuwIFuIRbibL15ejhApOADFE8/GpdlG+Mf377E9qG0Ay7G+44Pfk6BBEK8SeCSJZYy847lb2SRy3klfWdJcu6IlES7t7yXVXBKRjAPqVi+n6+fHK/WN6Nr4Ta2nJKE59zHXvJ2nOim0Tm6KQPR6D2BJFB7EncRv1hhBc88l09slDY7YbGU2QJy57Dse6ilNZdizSP08Infqz4UXtpcYiubdC0Nuq/w+jV8oSsHx417q+bpsP5A6Rt8Rcbfyezllm2Z2SfaNKHil+a4l4t5vtTbjYo37Ji3ZA+5bTZlMNt9GgcQDusfesHKWZDPj40JHE3LWGdqdCHVLYAU5DvNm+3yb5V4Tz36azvoGQDjLSiirJVlgi+cZFS7HHtcz1GjNmRMus7MDm2CadzFYSMW/dCg18eZn29faH5IYyzb0xRPGd2PLKatByuOwO5IjtXSurLPAFwDDGL9xbLd8Axbe7/tIW3mUMkxnKeBzPB7JrwZYLENkACPMF2qY670A8gf+lWZI0KwDRo2qvlJVcCo2tP+oMz/H3oiIEsZYscVKhImDso/OwiqT7k0BSr0YM1nJ9uTmE08JV90mqk9rfMkx6+xNmkdhnQ9QvNffH1JvQlOnMlKS+lMCdz/tdBL35whLC0kyBRbqsrGkabWT1m88N0RPqOmcxl23MGELDSt8/4oRaaAjZDWH7aAb/Xwq1NY2awyYqt46O/rjp6WIYWCQaTZLN/uKb8j7hp6/VyBEuVhI0z775sWkhcV3EWIYT2uB4XwSVSISFaOi/CdnOFjP45MrI9Iwrav7FDhuegPFaPP25fPxrxE2xqWtYx1U1aFA9lpTqEq1LFZTiwYrMSQk
 1AInGT8e
 LXmBh4D/IWW7gRqOPoLMboB5ccd0IR9vS9YANXMewMp+BvOhgaENpXNViEoRLzKIZTSdr16rpi7wKq6kNV6rpNxNcXWSaQgBIbHvf9hi+Hz2eUZmetB9Lgsv9gVlG1Y9rWIdpFU3MlKDi2amYD6RioIsDIwfPQcJE4BtyieHUGpvFpvcNLgQJmkUs9jWQRbnNgvQEp27n+dQgG4Ag0DDoGfIAF05kGGVBj6eG4eeRu3ahKPtk9jZwRnQpSfbG0wVGIApIhxoe+iDFD4zMDpo3XG0GNwHyU01XKVinuFoYvHTOOZFyAkBY4HfnHhV+eGpeph2qD6NxbSwNS9qwNwpXvVb8/HmlJVFzyR9d4zGfrRmwch37WAxZXgqtXHQAxwXCHrjo0wOp4kI6d3hYzkUVTxDt6V2J9Ek0KO5ffYBqT6JB2A0ne/dO9rEZ88gTzwA9BCLTqWVIxeBzFSHr4NczAAdpWGVbIj3iZ+FAXBhSxqYgKBfqZBuBZ+C4Ap4vLXsUUBIstp382XGp8jE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add FOLIO_CONTENT_COPIED marker to the dst->migrate_info migration
state. When set, it tells __migrate_folio() to skip folio_mc_copy()
and perform metadata-only migration. This bit is not set yet, the
batch-copy path enables it later in a subsequent patch.

Update __migrate_folio_extract() to preserve FOLIO_CONTENT_COPIED
while it consumes old states of src folio.

Move the dst->migrate_info state enum to migrate.h header file so
offload drivers can see FOLIO_CONTENT_COPIED.

On 32Bit, we do not have spare bit to store FOLIO_CONTENT_COPIED
info, migration copy offload is disabled for them.

Signed-off-by: Shivank Garg <shivankg@amd.com>
---
 include/linux/migrate.h | 25 +++++++++++++++++++++++++
 mm/migrate.c            | 29 +++++++++++++----------------
 2 files changed, 38 insertions(+), 16 deletions(-)

diff --git a/include/linux/migrate.h b/include/linux/migrate.h
index d5af2b7f577b..876035df2fdc 100644
--- a/include/linux/migrate.h
+++ b/include/linux/migrate.h
@@ -72,6 +72,31 @@ int folio_migrate_mapping(struct address_space *mapping,
 		struct folio *newfolio, struct folio *folio, int extra_count);
 int set_movable_ops(const struct movable_operations *ops, enum pagetype type);
 
+/*
+ * To record some information during migration, we use the migrate_info
+ * field of struct folio of the newly allocated destination folio,
+ * together with the anon_vma pointer. The state is encoded in the
+ * unused low bits of the pointer.
+ * This is safe because nobody is using it except us.
+ *
+ * FOLIO_WAS_MAPPED and FOLIO_WAS_MLOCKED record the src folios's state
+ * at unmap time and are consumed during the move/undo phase.
+ * FOLIO_CONTENT_COPIED tells __migrate_folio() that the folio contents
+ * have already been copied, so the per-folio copy can be skipped. A
+ * driver must set this bit on each dst folio it copied.
+ */
+enum {
+	FOLIO_WAS_MAPPED	= BIT(0),
+	FOLIO_WAS_MLOCKED	= BIT(1),
+	FOLIO_OLD_STATES	= FOLIO_WAS_MAPPED | FOLIO_WAS_MLOCKED,
+#ifdef CONFIG_64BIT
+	FOLIO_CONTENT_COPIED	= BIT(2),
+#else
+	/* On 32bit we do not have a spare bit, migration-copy offload is disabled. */
+	FOLIO_CONTENT_COPIED	= 0,
+#endif
+};
+
 #else
 
 static inline void putback_movable_pages(struct list_head *l) {}
diff --git a/mm/migrate.c b/mm/migrate.c
index 7a83032a14b5..b3f632575c82 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -859,14 +859,21 @@ static int __migrate_folio(struct address_space *mapping, struct folio *dst,
 			   enum migrate_mode mode)
 {
 	int rc, expected_count = folio_expected_ref_count(src) + 1;
+	const bool already_copied = dst->migrate_info & FOLIO_CONTENT_COPIED;
+
+	/* Consume the content copied marker */
+	if (already_copied)
+		dst->migrate_info &= ~FOLIO_CONTENT_COPIED;
 
 	/* Check whether src does not have extra refs before we do more work */
 	if (folio_ref_count(src) != expected_count)
 		return -EAGAIN;
 
-	rc = folio_mc_copy(dst, src);
-	if (unlikely(rc))
-		return rc;
+	if (!already_copied) {
+		rc = folio_mc_copy(dst, src);
+		if (unlikely(rc))
+			return rc;
+	}
 
 	rc = __folio_migrate_mapping(mapping, dst, src, expected_count);
 	if (rc)
@@ -1129,17 +1136,6 @@ static int move_to_new_folio(struct folio *dst, struct folio *src,
 	return rc;
 }
 
-/*
- * To record some information during migration, we use the migrate_info
- * field of struct folio of the newly allocated destination folio.
- * This is safe because nobody is using it except us.
- */
-enum {
-	FOLIO_WAS_MAPPED = BIT(0),
-	FOLIO_WAS_MLOCKED = BIT(1),
-	FOLIO_OLD_STATES = FOLIO_WAS_MAPPED | FOLIO_WAS_MLOCKED,
-};
-
 static void __migrate_folio_record(struct folio *dst,
 		int old_folio_state, struct anon_vma *anon_vma)
 {
@@ -1151,9 +1147,10 @@ static void __migrate_folio_extract(struct folio *dst,
 {
 	unsigned long info = dst->migrate_info;
 
-	*anon_vmap = (struct anon_vma *)(info & ~FOLIO_OLD_STATES);
+	*anon_vmap = (struct anon_vma *)(info & ~(FOLIO_OLD_STATES |
+						  FOLIO_CONTENT_COPIED));
 	*old_folio_state = info & FOLIO_OLD_STATES;
-	dst->migrate_info = 0;
+	dst->migrate_info &= FOLIO_CONTENT_COPIED;
 }
 
 /* Restore the source folio to the original state upon failure */

-- 
2.43.0


