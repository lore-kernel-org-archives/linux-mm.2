Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7790BC43602
	for <linux-mm@archiver.kernel.org>; Tue, 30 Jun 2026 07:29:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2FFD76B00AD; Tue, 30 Jun 2026 03:29:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2D6876B00AE; Tue, 30 Jun 2026 03:29:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1C59C6B00AF; Tue, 30 Jun 2026 03:29:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id BECD16B00AD
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 03:29:11 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id ABD53167E5E
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 07:29:10 +0000 (UTC)
X-FDA: 84935752860.28.7300CBE
Received: from PH7PR06CU001.outbound.protection.outlook.com (mail-westus3azon11010060.outbound.protection.outlook.com [52.101.201.60])
	by imf08.hostedemail.com (Postfix) with ESMTP id 633B716000B
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 07:29:07 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=w5cFQrMV;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf08.hostedemail.com: domain of shivankg@amd.com designates 52.101.201.60 as permitted sender) smtp.mailfrom=shivankg@amd.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1782804547;
	b=fuX5veujo9Td3YYxisGbBx4wCK80MPw8SDZA0Xfry+TQW2oJduqJV7jwXZL/M/PjqYVrQf
	tii7VE21uBp8pmeW98Z5Xhm7AFg9z1wVMLcGCfBXL2yfqnwdLFXF0b8Wk7FEwcHkDAGSHT
	uhNh9JUlwAbb4d9hSTPHMfdqfvOWGcQ=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782804547;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=6Gk/Ilwq2vtgArUQCwnm3ahLsU4Ow3JXQVq1ySpbc6I=;
	b=0mkluLdcvWGPQ1wie8wN0qJy8p5y5HoX+2cqAg1J8DU5OMH+u0wEl3kBIqHiBFzcgZLl+a
	3KcVou2v04px3fhZz9Pbpg1jXK6pGHX06KogltcxzXIw3hFhDR3b74KcfIw/xH4pPJdIGf
	+oSIy72TqUsAH86aBmOuq6vt6Uoz+K4=
ARC-Authentication-Results: i=2;
	imf08.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=w5cFQrMV;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf08.hostedemail.com: domain of shivankg@amd.com designates 52.101.201.60 as permitted sender) smtp.mailfrom=shivankg@amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=fDsYiFv/QZECGjnkqRxgWp1QYcE1qWrb3zSU2vK+Kd9ZJfgE5FzRudyMNWY+prEAaTTr7eqFRJh9uKTCiA2AVRLdqSQU1xR4YNbW7u3iYgsiWHZJuLBBTVBTt53N6TlOm1+ZqIms+FyDraFPVfmwb8xrpylCriIbhMwyRgsH01uMpa7S4bTiIYy72LuWoEhu/FV+WZBXebvX/7C9jQ34iSuR+5lFbYCofzgIFOTK7R6s+U9UAFJC4aShlMkOEHPSGkRUmd5FJRqMn9+6J6KRohIKt4JR0lApBub6Hgcmehg+BhzSCQKb347HHXNPC950z5aetl6ty+aq9ta4i1g3gA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6Gk/Ilwq2vtgArUQCwnm3ahLsU4Ow3JXQVq1ySpbc6I=;
 b=FVwIdZNo0L3GHY1sVlPFp2tsgmL+E2mbsYo4EYCCHY3LbXHoVoPFDvnTWVDF+1fXGwYNKQqFF7ppMd+stUWtrDLOf0f7UjNE1BL7/DK63zZFzNlxE7eWsKecfbUdULLW6kvdU44ioISMk60AmlgGDtYxJ60SeKuSSNWOitdlk4+VvgwiAvECnJRt2OFWVwQw9Thon9LA6JaFnHWGV5gcpED3kiFQyrA8sWjbBR7ferQ7WBaTevIiLG0+XgIVoFqt4Kr73sQCGOv5NStK5K/Zupx3/1RQdSR0IAERjzrd36Oyogf/heVjPFjoHgTGbO0ZJBgPRH5/jUOOm7bArmvb5Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=infradead.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6Gk/Ilwq2vtgArUQCwnm3ahLsU4Ow3JXQVq1ySpbc6I=;
 b=w5cFQrMVK96kh1exeBpNYFjHTPCEqUm/LobZymYvMM4O4l/pLw80GlMeCq8O/+clo4P9LxDWhe8r6cVW7FLAuyAkIFvob/sc0P68ItCT3NyX7R8GYphRfcu7s2z+YwIoyMPXMbO3RtSTaKMCQQU7Q2Qr043K2Z1K1WkrxuNok0A=
Received: from MN0PR04CA0028.namprd04.prod.outlook.com (2603:10b6:208:52d::27)
 by PH7PR12MB6718.namprd12.prod.outlook.com (2603:10b6:510:1b1::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.181.8; Tue, 30 Jun
 2026 07:28:58 +0000
Received: from MN1PEPF0000F0DE.namprd04.prod.outlook.com
 (2603:10b6:208:52d:cafe::67) by MN0PR04CA0028.outlook.office365.com
 (2603:10b6:208:52d::27) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.159.19 via Frontend Transport; Tue,
 30 Jun 2026 07:28:58 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 MN1PEPF0000F0DE.mail.protection.outlook.com (10.167.242.36) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.181.6 via Frontend Transport; Tue, 30 Jun 2026 07:28:57 +0000
Received: from [127.0.1.1] (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.41; Tue, 30 Jun
 2026 02:28:47 -0500
From: Shivank Garg <shivankg@amd.com>
Subject: [PATCH RFC v6 0/5] Accelerate page migration with batch copying
 and hardware offload
Date: Tue, 30 Jun 2026 07:28:36 +0000
Message-ID: <20260630-shivank-batch-migrate-offload-v6-0-da95d7e8b8a2@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-B4-Tracking: v=1; b=H4sIACRwQ2oC/z2NS27DMAxEr2JwXQGy7NCRtwFygG6DLCiKjoXGn
 0qOESDw3avWRZYzQ773giQxSIK2eEGUNaQwjTngRwHc03gTFXzOYLRBjSWq1IeVxi/laOFeDeE
 WaRE1dd19Iq+8EOsDOyE6QGbMUbrw/ONf4PN8guteRvl+ZNfyv7xVbbGLDL7RfBcaH3NS+W1WT
 UOafFVrZmzX8tfhKOWraRjC0hZHd6zFWM/WeMfkyZYVW0fONkiEXYOl07UgXLftB8l+0k/9AAA
 A
X-Change-ID: 20260616-shivank-batch-migrate-offload-deac05cbeaa5
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
	<linux-kernel@vger.kernel.org>, Shivank Garg <shivankg@amd.com>, Mike Day
	<michael.day@amd.com>
X-Mailer: b4 0.15-dev-47d62
X-Developer-Signature: v=1; a=ed25519-sha256; t=1782804526; l=14257;
 i=shivankg@amd.com; s=20260518; h=from:subject:message-id;
 bh=g+ZMfOmlvhk0LrT60ImNi/ptdoQXJZJq3bfDz0HjBp8=;
 b=7PWvJJq8ZAv9gPFA3l8J4EGCOBcuKXUwir9XEEIhcIai1+WDEdv6YAF35uHl44P9GgncPFcOf
 LOQg9IlrJIpAW+V54X/s29PUk5S3t59WywUXUePKfq/ZcE8C9h3u94y
X-Developer-Key: i=shivankg@amd.com; a=ed25519;
 pk=2l2QGTeXuGkZTtfmx0nPQU8iFZfjYmX/ymMojitevx4=
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: satlexmb07.amd.com (10.181.42.216) To satlexmb07.amd.com
 (10.181.42.216)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN1PEPF0000F0DE:EE_|PH7PR12MB6718:EE_
X-MS-Office365-Filtering-Correlation-Id: 426bb014-364e-42ee-9034-08ded6793f80
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|23010399003|7416014|1800799024|82310400026|36860700016|6133799003|921020|3023799007|13003099007|18002099003|11063799006|56012099006;
X-Microsoft-Antispam-Message-Info:
	h0L4+Tl0Woj/gc9+jLUIIoGOWsEnozAEh+Z6o+ICE0woqI68VM2tw3RBNcFOIwVCMRCMd4YXa1KPLUZYyFjyYZquj0Ogb4M55MwNbKfFsQkcKvKbIs9o6RCgk8oBikQbGSuluOGgAwJQCFXYk0gJJmXq784nZo0MHLctDuI9nDWKHIVsNFRuY45q1JD1SDilsC11Ag3ieJkAMgnoTAAPv44P1UvCb/WwxQpzdCUPwZWXcPiKMgT3T38tVnVeE8MdviypcxCNiTq8hhdHLIpfqGHRJ3pcqLcuDtVPH9q+nnXZ+jKwUP8CACdZnRxkahC8aT05dzTFWYrwzOOGh/OxciGpRr5tiCma56LMG0hQbaQ5dzxpE++kXSdKdXub6hvu0NS00Kjef9aCx1KWFoxeIFVPiDJ0oQkKuLZQxFL4ENqqp82Qw3bDEXnyqd8OMrGuWvUQlahEA5lvsXbluz11Pn8jCDYCMpRsIW7L0UkglRpMlFFWTXFsgEDbtYwhp02zkpkvVwKWdWpSBh/JzrIL7SDgsc+l4OMdlpas9bc4dOS/7Je/0IUkpIRzAhPPTdft1mQbaAZrDHTscteUr8wUODzAg3Y8BHzv6OaV7nJZomvOJwicz6iFY0nsVdm30co2e2cCXwC9p378Hm7Sj/iqSOgDC/EvubC2ctBgFy41sJae803Gk2vCiee3P+k/RnFv
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(23010399003)(7416014)(1800799024)(82310400026)(36860700016)(6133799003)(921020)(3023799007)(13003099007)(18002099003)(11063799006)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	QAfDvHCNtMALNtygAFIOc/XESBEws2ylZXrUPcz6vk+E7fT+gUxg6r1bTD0NAN5g5SzigtcBnsSVLGbE8wI9H8/qyklBTfL3RyO5VTmVGZe1QECDeIs8gwIDSYDEyX0v7CfJ3ZYmdLbAtnLEQ5SyyxMPr0k5W9myJqJdZfCIN0hU02ooXX2C9lUiDUmH0L/u4rR+g7MwBG8GurEN5iug778qYolJX1dPaasRL1mzlVt9qkr2OkMMHLP1HjdWPnB3aNJ8p2WTAhztftgxhGzLY24E8dgJvwxvf+FIREHYgjyyuhPCBDqmfOEC1jbQYm3nEWS8ULiFINEiqf4cuOF09Q5jCT/LcUOqL6xMbMwDUoxas+qGdFY6rkwhvwYjvvVbJTlYLfvPtoVAM3lxbCT7jI0D6vgJr/0J6ImGvj1m+CoYMK5d2verkV4oO8sQtcRh
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jun 2026 07:28:57.7518
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 426bb014-364e-42ee-9034-08ded6793f80
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MN1PEPF0000F0DE.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB6718
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 633B716000B
X-Rspam-User: 
X-Stat-Signature: im5ku548dqzj4qdnbodswxhxqa6ifsko
X-HE-Tag: 1782804547-641525
X-HE-Meta: U2FsdGVkX1/ssmi8abhJR7sFCEt1H9RqFy1L96AkyAS+n/3ssY/uV/6rmxP3VuDvmATI6FK1wvg4feeGq9KWzZbKRp0QVH/a1yhGPFZJM1iBhDXwS2SaEXyvUoSNustV/4xnvfGiPnccwDw+LT6ydiUqDRykyw0fDMtbzULSIqKaZjGOzGb+dCwyvbedbpQGc2uh7zf9Y39s9oEf6hArA46rQ1ReftFV3IrvOMCFdjh/JM2YJdck3d1jGxIE0XVyDkOGz1a0aOn+ymkqiiQKyA4d6LeAFWK0ezyaPiiOMa9aDSOecKwp68TrbkrTk//zfalG/w19oaZmLFD0zStOS9bQD5OQzoYCGWYLw2o96gPOGAZwtSfk1hNacF4o0391sR8ewNwcJkhFRIicLxwYOPNF43RkcXOrRKFe+ohrAcxCspsEzzlvGv6+naf/apkiSbbPQ7ZlEZXXko/TsSZCahSNU9esWGQoWXAs2KETbuEQp8G4+3lY1hSjTJ46FNnkgy4/pycyh3j/C8JHnRldD0ROEOAOFgFw4GmXyl/LClkbkpqyavF0Za7MsiyRSNXOruulSb8YqFUWL5U9mJ87LM48/sC9SKsfNBGBdrunmJSp8SK6NvAioEABScQXm2PCTSk6mJnVI6aub64z5Ig3HiAS24msuJ9CIfEsN7G+ko0eNisLYUPNXumcN1yQeUB3IqznQmnAgOfEvCHaoehyCIqQCGFnGj8ZLG5TMtLANos5NWaq9IboLmp5KMWqIVmOjDFTs54xzKnMUbcoTMS1YRiiJ5esBahvb7Fq0HviFSkW3FPHJp4CG2izOxNGwG4/ulTti/2QTnMThk7ZAW+rVdQPYXdWMPaAdWtha1ehzpLad9t/y0kERkiZjyDCbOPfvKN/CAb1JD3K8RHlcSgA2xXK7+UtfFSmqmJQnhZZhc8TNhulYQktgjXUDUbBbH8S2aUIoOKYHK+twA5q9+B
 46jNHJLA
 Ffw3I/bZhYntZMaoZPGUXhNKnwugGBHvygnIJ+aQqjkMKskASM0X7VHRpA5iNUD2xw8B7S89f/WAfD2vEOu6D6Ed++/hCfmSag7ZpqScri2VZ3VAnyGA42Oy7yLy6wLEasCZ72WGmcoo3Gq0tgVyloAVglcsXtsxA8xGYAOif7kKyFn+9OwM1GFg9y2mpDHVptkO5kViFALv8VULANzX1kKgJ6DqxyBtSDx3uC/+rdfonEMryxJE2d9FZEnIWaloe4dvOlaGqDp/9RUZeA1ouXmLuT/bc4lgeoyPkSzhk2cTvIcEmAb4i3sFn4S19BsMWReFGLCdtqdEGIiVaKCUxVGTBgOg2A12T8UbT/HMSf3AfLRpB7sJK1ofq/apdI0hRKLycZ1KHJ44nONuaHO67OT57eKG2wrvlfh5SJlCKobEYULUQX+AadzFTxbZDFPOr5uFreVLzaEUHQzNcqz4jsHsHT4DKSvvi66xRi5O3QCXK0en4QEoQe/iNIr/nCKndaLAIhcTg0fX7z5lwdAA1nf58YGpWKxid32v2qNziUhYBbR79gRRXGCH5L0yX0rQW9J/aeCEYrBxMs4FA2Cs4W5OyLwYtE+2Cqsw3NQ6DlHOcXpJNB6kSfwXN+X4jLPgCyGiI3r0+hFp1IDIwL/O4E03gFW2sWCu4VEew
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This is the sixth RFC of the patchset to enhance page migration by
batching folio-copy operations and enabling acceleration via DMA offload.
I had intended to split the batch-copy path into a non-RFC series this
round. However, given some major changes, it does not hurt to take
one more pass with the RFC tag.

Single-threaded, folio-by-folio copying bottlenecks page migration in
modern systems with deep memory hierarchies, especially for large folios
where copy overhead dominates, leaving significant hardware potential
untapped.

By batching the copy phase, we create an opportunity for hardware
acceleration. This series builds the framework and provides a DMA
offload driver (dcbm) as a reference implementation, targeting bulk
migration workloads where offloading the copy improves throughput
and latency while freeing CPU cycles.

See the RFC V3 cover letter [3] for motivation.

Changelog since V5:
-------------------
1. Few cleanups and preparatory patches have been split out into a separate
   series [12].
2. Rename FOLIO_ALREADY_COPIED to FOLIO_CONTENT_COPIED. (David Hildenbrand)
3. Mark the copy-done state per folio (FOLIO_CONTENT_COPIED) right after
   each successful copy, instead of threading an already_copied bool
   through migrate_folios_move() -> migrate_folio_move() ->
   move_to_new_folio(). This looks clean and lets a partially failed batch
   fall back per folio rather than re-copying the whole
   batch. (David)
4. Moved folios_mc_copy() into mm/migrate.c as migrate_folios_mc_copy()
   to have per-folio copy marker (David). And add cond_resched() (Sashiko)
5. FOLIO_CONTENT_COPIED packs into the unused low bits of the anon_vma
   pointer in migrate_info, but 32-bit cannot guarantee bit-2 is free.
   The flag is BIT(2) on CONFIG_64BIT and 0 otherwise,
   and MIGRATION_COPY_OFFLOAD now depends on 64BIT. (Sashiko, Zi Yan)
6. Move copy-offload interface out of migrate.c into
   migrate_copy_offload.c. Restructure patches (migrate_offload_do_batch) (David)
7. Add MAINTAINERS entry for drivers/migrate_offload (David)
8. Avoid DMA-pinned folios on the batch path to avoid stale data race.
   (Sashiko). So, could not rename folio_can_batch_copy) to
   page-specific name, as it's no longer specific to movable_ops.
9. Add configurable migration reason callback. (David Rientjes)
10. Renamed the dispatch static_call to migrate_offload_batch_copy_fn and
    the hot-path predicate to migrate_should_offload().
11. Fix the DCBM crash when build with =y. Expose DCBM runtime
    knobs as module parameters under  /sys/module/dcbm/parameters instead
    of earlier /sys/kernel.
12. Rebased on v7.2-rc1.

DESIGN:
-------

New migration flow:

[ migrate_pages_batch() ]
    |
    |--> offload = migrate_should_offload(reason)  // core filters by migration reason
    |
    |--> for each folio:
    |      migrate_folio_unmap()	// unmap the folio
    |      +--> (success):
    |           if offload && folio_can_batch_copy():
    |               -> unmap_batch / dst_batch	// batch list for copy offloading
    |           else:
    |               -> unmap_single / dst_single // single list for per-folio CPU copy
    |
    |--> try_to_unmap_flush()                  // single batched TLB flush
    |
    |--> Batch copy (if unmap_batch not empty):
    |    - Migrator is configurable at runtime via module parameters.
    |      static_call(migrate_offload_batch_copy_fn) // Pluggable Migrators
    |              /            |             \
    |             v             v             v
    |     [ default ]  [ DMA (dcbm) ]   [ ... ]
    |      Each copied dst is marked FOLIO_CONTENT_COPIED; folios left
    |      unmarked (driver error / copy failure) fall back to per-folio
    |      CPU copy in the move phase.
    |
    +--> migrate_folios_move()                 // metadata, PTEs, finalize

Offload registration:

    A driver fills struct migrator { .name, .offload_copy, .owner } and
    calls migrate_offload_register(). This:
       - pins the module
       - patches the migrate_offload_batch_copy_fn static_call target
       - enables the migrate_offload_enabled static branch.

    migrate_offload_unregister() disables the branch, reverts the
    static_call, then synchronize_srcu() waits for in-flight migrations
    before module_put().

PERFORMANCE RESULTS:
--------------------

AMD EPYC 7713 (Zen 3), 2 sockets, 32 cores, SMT on, 
1 NUMA node per socket, 256 GB/node, v7.2-rc1, DVFS=Performance, PTDMA
(16 DMA channels).

Benchmark: move_pages() syscall to move pages between two NUMA nodes.

1). Moving different sized folios such that total transfer size is constant
(1GB), with different number of DMA channels. Throughput in GB/s.

a. Baseline (vanilla kernel, single-threaded, serial folio_copy):
================================================================================
4K          | 16K        | 64K        | 256K       | 1M          | 2M          |
================================================================================
3.28±0.14   | 4.98±0.18  | 6.19±0.08  | 6.77±0.08  | 7.02±0.11   | 10.80±0.13  |

b. DMA offload (Patched Kernel, dcbm driver, N DMA channels):
============================================================================================
N channel| 4K        | 16K         | 64K         | 256K        | 1M          | 2M          |
============================================================================================
1      | 2.38±0.17   | 2.77±0.03   | 3.21±0.03   | 5.00±0.02   | 5.09±0.64   | 12.62±0.07  |
2      | 2.87±0.11   | 4.06±0.05   | 5.09±0.04   | 6.97±0.08   | 8.43±0.06   | 14.32±0.10  |
4      | 3.32±0.07   | 5.30±0.06   | 7.21±0.09   | 9.69±0.15   | 11.36±0.13  | 26.98±0.19  |
8      | 3.68±0.09   | 6.28±0.10   | 9.16±0.13   | 12.05±0.16  | 15.33±2.80  | 46.06±0.55  |
12     | 3.83±0.05   | 6.65±0.17   | 10.00±0.16  | 12.98±0.18  | 15.87±0.19  | 61.31±1.28  |
16     | 3.94±0.09   | 6.78±0.10   | 10.48±0.13  | 13.48±0.20  | 16.90±0.24  | 65.06±2.46  |

2). First-folio latency: custom tracepoints (in migrate_pages_batch enter/exit,
    migrate_folio_done) measure latency per migrate_pages_batch() call.

    Throughput (GB/s) and first-folio latency (us), median of 10 runs.

a. Vanilla Kernel:

NR_MAX_BATCHED_MIGRATION upstream default value is 512.
--- Order 0 (4K folios) ---       --- Order 9 (2M folios) ---
     n      vanilla/cpu                n      vanilla/cpu
(folios)    GB/s | first(us)      (folios)    GB/s | first(us)
--------------------------        --------------------------
     1       0.03 |     24             1       6.86 |    204
     4       0.13 |     30             4       8.68 |    191
     8       0.27 |     27             8       7.92 |    207
    16       0.43 |     34            16       6.77 |    234
    64       1.12 |     51            64      10.44 |    179
   256       1.67 |    166           256      10.43 |    181
   512       1.98 |    255           512      10.55 |    179
  2048       2.38 |    233
  4096       2.42 |    168
 16384       2.72 |    167
 65536       3.00 |    156
262144       3.10 |    151

b. Patched kernel:
N = NR_MAX_BATCHED_MIGRATION (in pages), Total migrated data fixed at
1 GB. Change N with knob (just for testing) to measure impact of
different max batched size.

--- ORDER 0 (4K folios) ---

     N         offload/dma1          offload/dma4          offload/dma16
               GB/s | first(us)      GB/s | first(us)      GB/s | first(us)
------------------------------------------------------------------------
   512         2.21 |    628         3.29 |    275         3.25 |    245
  1024         2.06 |   1271         3.21 |    601         3.36 |    518
  2048         2.02 |   2646         3.00 |   1388         3.20 |   1110
  4096         2.08 |   4832         3.17 |   2514         3.41 |   2175
  8192         2.16 |   9253         3.14 |   4839         3.62 |   3592
 16384         2.24 |  17543         3.23 |   9680         3.58 |   7144
 32768         2.22 |  36408         3.26 |  19301         3.67 |  14524
 65536         2.12 |  82572         3.24 |  38091         3.62 |  29835
131072         2.08 | 153669         3.17 |  79744         3.48 |  62157
262144         2.05 | 332297         2.97 | 175315         3.33 | 134774

--- ORDER 9 (2M folios) ---

     N         offload/dma1          offload/dma4          offload/dma16
               GB/s | first(us)      GB/s | first(us)      GB/s | first(us)
------------------------------------------------------------------------
   512        11.74 |    160        11.71 |    160        11.75 |    159
  1024        12.18 |    310        13.82 |    274        13.76 |    275
  2048        12.39 |    612        25.55 |    290        25.69 |    289
  4096        12.54 |   1211        26.25 |    564        42.36 |    334
  8192        12.54 |   2421        26.82 |   1111        51.85 |    485
 16384        12.61 |   4824        26.91 |   2209        54.26 |    925
 32768        12.62 |   9652        27.04 |   4404        54.72 |   1942
 65536        12.64 |  19287        26.95 |   8835        57.30 |   3535
131072        12.64 |  38824        26.95 |  17900        58.58 |   7747
262144        12.66 |  77610        26.95 |  35743        66.31 |  13801

OPEN QUESTION:
--------------

The best batch size depends on the hardware, and bigger isn't always better.
NR_MAX_BATCHED_MIGRATION decides how many pages we move at once.
Higher batch size can help amortize the setup cost of migrator but
increases the first-folio latency (the folio is inaccessible for this
window).

Goals could be workload dependent, e.g. higher throughput versus
same throughput under a bounded latency.

Should this be tunable to accommodate different hardware and goals?

FOLLOW-UPS:
-----------
1. dmaengine_prep_dma_memcpy_sg() in DCBM (Vinod Koul); needs the ptdma/sdxi
   SG hook - device_prep_dma_memcpy_sg [10]. will post separately. This will
   address two concerns:
   - IOMMU SG merging in DCBM: dma_map_sgtable() may merge PFNs
   unevenly so src.nents != dst.nents. (Gregory)
   - Descriptor Chaining: out-of-order completion of DMA descriptors on some
   dma engine eg. Intel DSA can yield incorrect results. (Karim Manaouil)
2. SDXI as a second migrator [11]. SDXI is a generic memcpy engine
   without DMA_PRIVATE, so channel acquisition uses dma_find_channel()
   rather than dma_request_chan_by_mask(); I have a local DCBM variant
   working and will post once SDXI settles.
3. Revisit Multi-threaded CPU copy migrator once the infra is settled or
   follow it separately as it brings other discussion, like whom to
   charge? [13]. 
4. Batching the migration rmap walks: try_to_migrate_one() and
   remove_migration_pte() overheads dominate for PTE-mapped large
   folios. I have this working locally, and will post it separately.

EARLIER POSTINGS:
-----------------
[1] RFC V5: https://lore.kernel.org/all/20260428155043.39251-2-shivankg@amd.com
[2] RFC V4: https://lore.kernel.org/all/20260309120725.308854-3-shivankg@amd.com
[3] RFC V3: https://lore.kernel.org/all/20250923174752.35701-1-shivankg@amd.com
[4] RFC V2: https://lore.kernel.org/all/20250319192211.10092-1-shivankg@amd.com
[5] RFC V1: https://lore.kernel.org/all/20240614221525.19170-1-shivankg@amd.com
[6] RFC from Zi Yan: https://lore.kernel.org/all/20250103172419.4148674-1-ziy@nvidia.com

RELATED DISCUSSIONS:
--------------------
[7] MM-alignment Session [Nov 12, 2025]:
    https://lore.kernel.org/linux-mm/bd6a3c75-b9f0-cbcf-f7c4-1ef5dff06d24@google.com
[8] Linux Memory Hotness and Promotion call [Nov 6, 2025]:
    https://lore.kernel.org/linux-mm/8ff2fd10-c9ac-4912-cf56-7ecd4afd2770@google.com
[9] LSFMM 2025:
    https://lore.kernel.org/all/cf6fc05d-c0b0-4de3-985e-5403977aa3aa@amd.com
[10] DMA_MEMCPY_SG comparison:
     https://lore.kernel.org/linux-mm/3e73addb-ac01-4a05-bc75-c6c1c56072df@amd.com
[11] SDXI V3:
     https://lore.kernel.org/all/20260605-sdxi-base-v3-0-4d38ca2bdffe@amd.com
[12] migrate cleanups/prep:
     https://lore.kernel.org/all/20260626-migrate-cleanups-prep-v1-0-a95933af7619@amd.com
[13] Charge calling thread for multi-threaded copy:
     https://lore.kernel.org/all/633F4EFC-13A9-40DF-A27D-DBBDD0AF44F3@nvidia.com/
[14] OSS India:
     https://ossindia2025.sched.com/event/23Jk1
   
Thanks to everyone who reviewed, tested, or participated in discussions
around this series.

Signed-off-by: Shivank Garg <shivankg@amd.com>
---
Shivank Garg (4):
      mm/migrate: skip data copy for already-copied folios
      mm/migrate: add batch-copy path in migrate_pages_batch
      mm/migrate: add copy offload registration infrastructure
      drivers/migrate_offload: add DMA batch copy driver (dcbm)

Zi Yan (1):
      mm/migrate: adjust NR_MAX_BATCHED_MIGRATION for testing

 MAINTAINERS                           |   2 +
 drivers/Kconfig                       |   2 +
 drivers/Makefile                      |   2 +
 drivers/migrate_offload/Kconfig       |   9 +
 drivers/migrate_offload/Makefile      |   1 +
 drivers/migrate_offload/dcbm/Makefile |   1 +
 drivers/migrate_offload/dcbm/dcbm.c   | 481 ++++++++++++++++++++++++++++++++++
 include/linux/migrate.h               |  28 ++
 include/linux/migrate_copy_offload.h  |  69 +++++
 mm/Kconfig                            |   6 +
 mm/Makefile                           |   1 +
 mm/migrate.c                          | 133 +++++++---
 mm/migrate_copy_offload.c             | 249 ++++++++++++++++++
 13 files changed, 954 insertions(+), 30 deletions(-)
---
base-commit: 8b84e29dc92dbcada913c9bab976aa6f761b04e6
change-id: 20260616-shivank-batch-migrate-offload-deac05cbeaa5
prerequisite-change-id: 20260626-migrate-cleanups-prep-77a0ad340cc6:v1
prerequisite-patch-id: 816a6f6957cc9c0f3903db7b7f462a4ade2a7519
prerequisite-patch-id: d8521dbc801fb6e7cbaa5be8cecad491f7e2f809
prerequisite-patch-id: 3fcedadd87cd30b3fe8833e0ed33890f15c0e950

Best regards,
-- 
Shivank Garg <shivankg@amd.com>


