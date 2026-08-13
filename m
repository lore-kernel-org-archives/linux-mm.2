Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 11C71C5AC67
	for <linux-mm@archiver.kernel.org>; Thu, 13 Aug 2026 04:24:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8C41C6B0394; Thu, 13 Aug 2026 00:24:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 89B816B0395; Thu, 13 Aug 2026 00:24:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7B1466B0396; Thu, 13 Aug 2026 00:24:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 53A166B0394
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 00:24:15 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id D2C6B1604E6
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 04:24:14 +0000 (UTC)
X-FDA: 85094954028.27.5A9226C
Received: from SJ2PR03CU001.outbound.protection.outlook.com (mail-westusazon11012036.outbound.protection.outlook.com [52.101.43.36])
	by imf19.hostedemail.com (Postfix) with ESMTP id 8F6BC1A0007
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 04:24:11 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=JvQJhrB+;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf19.hostedemail.com: domain of shivankg@amd.com designates 52.101.43.36 as permitted sender) smtp.mailfrom=shivankg@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786595051;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=Eu9GFJTQwVksG0ljZo5TRaZJVYXxADbehGMutWJQUuI=;
	b=m8xuundV7srcv0JK6pQw9+NSTxleRQjeRe4Oesmn1vKLiVF9E7WrrDfBbirf4db1HhgHAj
	U0esDyLJ4taV7UnOl7RlmN9v2+Je8ksiP8sYtNF+Nz2fnBaSiHYM6mDnfX1Xj3voONqydo
	hxEA5+z+zK8ztvLQoM6CPN6TLxa20uo=
ARC-Authentication-Results: i=2;
	imf19.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=JvQJhrB+;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf19.hostedemail.com: domain of shivankg@amd.com designates 52.101.43.36 as permitted sender) smtp.mailfrom=shivankg@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1786595051;
	b=bcDaAdGL5Dn4u8uB3naDrqts1hk0c+3KoQHXgPTXwFSeKa1wpTQxjE3U19uWrLur9ccewI
	GOHaVFpZHuYABLnxlu3+qlYrcQx454gO0PMzlpuqVzkBPFIdGh+Jnt2Alzn+No6sGhoLUA
	quobziOKLf3qDZQCWfzEl3dzRX0Ib6U=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=HIqFMMtBABNmJzmM5cdl8FJJoKwtFTQZ27+wol8ugYVAEK8WNdh2F0CL15gST9o9iCV5eRIZPYMIBlqpDPaW4ZyWSTTL6tTzQ+6PTWjEOKkEFXklQh6Gyn3kzSfhzaX15hSNpfGzyS+GUkUmssGotgW3K1CIlOOHM4iriNXvxyBqQHLnpFoIhcq2Gn5VdGJfNv787tzgb9zGj1a9ogSLGpoRLDQGaXIFqq60yfeVAhyNtfYDxDpF/gpEnWrm+AzuVdVkhlnLeHvrIMvRCZhjw+JXty8SFIUlJL3L4fmmV7QRz9df2470Mx9+RXAvZ8FHTs2Z3bdY2etrj8euExCY4Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Eu9GFJTQwVksG0ljZo5TRaZJVYXxADbehGMutWJQUuI=;
 b=JcTFbtJbCy9MiZW8T1wsd/wqYISN3eiP4fWWl4Gdgxh7XpLL2Xa2LcA8RwsCpVBp4tokQ4SD4Mn5La9kYFgsEW/WNK7hC5GnLd4utvUcbbW+K+EjEQuU2gZBh/TLasMg79eCzLulIhK772MkUGfIXj8vGwy15YRTwXFkHMGN/+Z7sIoq/JzO1BIlZb1GDP4t7nPFu42kp5CAkf2U7YIdZbVtqxlbqIaG0IxrZyPSHuRFqeIs4VepRFJNJoaQ6VfC9uKsTCUHqs+5cOmsgYwfDeUCsjRrwGnUGlcurPRFJfzuHlCsPibdHBZ/3AV6+NSWRUkQAyyN2T02vjaonhMpVQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=surriel.com smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Eu9GFJTQwVksG0ljZo5TRaZJVYXxADbehGMutWJQUuI=;
 b=JvQJhrB+bWgu2sAatQcsdQ3q1gE67xP+ABiHj77Sv6e5AgU4DWpC9hnl8RyG5ZYqO79JHbdkAXRKN6KZYqnaXfzCk4cjI5TMAHDM/iTt7lotOFWLOx9HQWF+re9I2YH7odtGR4dzHgM1ecZds6MF9j2jPpV3oq1O6Vp/J+JxUX8=
Received: from LV3P220CA0014.NAMP220.PROD.OUTLOOK.COM (2603:10b6:408:234::14)
 by PH8PR12MB7205.namprd12.prod.outlook.com (2603:10b6:510:227::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.315.11; Thu, 13 Aug
 2026 04:24:03 +0000
Received: from BN3PEPF0000B373.namprd21.prod.outlook.com
 (2603:10b6:408:234:cafe::3e) by LV3P220CA0014.outlook.office365.com
 (2603:10b6:408:234::14) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.315.14 via Frontend Transport; Thu,
 13 Aug 2026 04:24:03 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 BN3PEPF0000B373.mail.protection.outlook.com (10.167.243.170) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.339.0 via Frontend Transport; Thu, 13 Aug 2026 04:24:02 +0000
Received: from [127.0.1.1] (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Wed, 12 Aug
 2026 23:23:54 -0500
From: Shivank Garg <shivankg@amd.com>
Subject: [PATCH v2 0/7] mm: batch rmap walks during large folio migration
Date: Thu, 13 Aug 2026 04:23:11 +0000
Message-ID: <20260813-migrate-rmap-batch-v2-0-3c5424c555c7@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-B4-Tracking: v=1; b=H4sIALBGfWoC/22PQXLCMAxFr5LxukptJRBgxT06LIStErejJLVNg
 GFyd4yz7U5fM/896akiB89RHaqnCjz76MchB/yolO1puDB4l7NCjVvdaQPiL4ESQxCa4EzJ9rB
 ja3Xr2Oz1RuXiFPjb3wv067TmwH/XzE7rUgnHSIWdVYWMTabnft20iNhtwYDjuf4hPxwpSG1He
 aPPFBnyLD4dKvqdBEQ+RWDgm3qreh/TGB7lndkU18o3+N/lswENuw6pa9q2Mc4cSVxxnZZleQE
 zr3MfHQEAAA==
X-Change-ID: 20260701-migrate-rmap-batch-8ecc04de1905
To: Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand
	<david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, Rik van Riel
	<riel@surriel.com>, "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka
	<vbabka@kernel.org>, Harry Yoo <harry@kernel.org>, Jann Horn
	<jannh@google.com>, Lance Yang <lance.yang@linux.dev>, Mike Rapoport
	<rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko
	<mhocko@suse.com>, Zi Yan <ziy@nvidia.com>, Matthew Brost
	<matthew.brost@intel.com>, Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim
	<rakie.kim@sk.com>, Byungchul Park <byungchul@sk.com>, Gregory Price
	<gourry@gourry.net>, Ying Huang <ying.huang@linux.alibaba.com>, "Alistair
 Popple" <apopple@nvidia.com>
CC: Karim Manaouil <kmanaouil.dev@gmail.com>, Frank van der Linden
	<fvdl@google.com>, Kinsey Ho <kinseyho@google.com>, Wei Xu
	<weixugc@google.com>, Bharata B Rao <bharata@amd.com>, David Rientjes
	<rientjes@google.com>, Dev Jain <dev.jain@arm.com>, <linux-mm@kvack.org>,
	<linux-kernel@vger.kernel.org>, Shivank Garg <shivankg@amd.com>
X-Mailer: b4 0.15-dev-47d62
X-Developer-Signature: v=1; a=ed25519-sha256; t=1786595034; l=5059;
 i=shivankg@amd.com; s=20260518; h=from:subject:message-id;
 bh=xe4BZIjXZM9ZhoVG0Eqce2EArkF6gFItyVhSAUWvPhc=;
 b=xQO2vyhrB4clraVC7Y/TJnDwQX3ykIpqN9KBxyp3HX+1N6AEfPFkkrH0XLfveTVXZVqKWjI8f
 tD6uZccbbupCswo++MsH/I9KxaEM2qLW5UIHlldDw/SaqO8FnpCBStm
X-Developer-Key: i=shivankg@amd.com; a=ed25519;
 pk=2l2QGTeXuGkZTtfmx0nPQU8iFZfjYmX/ymMojitevx4=
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: satlexmb08.amd.com (10.181.42.217) To satlexmb07.amd.com
 (10.181.42.216)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN3PEPF0000B373:EE_|PH8PR12MB7205:EE_
X-MS-Office365-Filtering-Correlation-Id: 108731c7-ac0f-4775-948b-08def8f2b49c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|1800799024|7416014|376014|36860700016|82310400026|13003099007|921020|10067099003|11063799006|18002099003|56012099006;
X-Microsoft-Antispam-Message-Info:
	PsycChmP3FSW5DEsI0AMaMCTSRDOhx2D5c5KfF4GMKetKOJVM9eK4sE/toL2E+Fl0MNY72VKonMHbGfgl0WCcNNHEZVTwWFXEu0QjW2ldMWxY9f1XA74UPgYZTJlaZPILVQ1K39X5WzMd1I4/f86/1pskc0RKzKcOwQigIDxsQXN/AvbU3VdKU5nLZ5WYNevhMXVOC5t+hOSZlZz08tfh0NgZwVK2iDV66z6eTEO8Hb2YBmYdElkOXkNAFHU5uaiQvAnUSgJAZgFzXG9hIKIj86fyc2pOvLpGJhtlh9BEJXzuF0gtYyP6j3dbzs0IbWDnSGch9p56R/FSuNC7/44kbW0ZPP+fMSe96kfxWUzi6bLjYx0v6XGVmo2JdrgGbzXujkrR0NKC2c6tJHX4bFoTO+c3zVMYZoHUgoUNGJ0BPUZIZOb5C50OhvaSMy4CMp9Y/7qlJTDBPweMuKzbjz3gigtkwAHcjSVrUb46B0HsQYg+/Pe4/Gi+LsoGVqc+yKXcQlQgvIQus5whDtYk5+JkNfCrEdc9MWOA6LRqgbAQV9H6RLQ7p8QPpl08EkToDNHCbaArv8QGXZ1e9aPuICXyhyiBNGrqMCXvkxQFxTFJ2N/cEZuy4Ty+FmazU58IiAZYmhFTpdlTYMtH01k9EGg6qXyTZW0C6dhI5OBWWyWVz+wnr0S7nC5ou+xb/VZWiuk6HwUENxxRfyLAeCzpJkQvD7BL8CDcINjLEN8iYJTuchJA8GD4sEOFkDtlFiwzIZZ
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(23010399003)(1800799024)(7416014)(376014)(36860700016)(82310400026)(13003099007)(921020)(10067099003)(11063799006)(18002099003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	6xESeZUaesSXqvEynUXbpGgo/au0UzpfJsVo22bJS1i9zh7RkutOfCR+bDHjkwLew2g8uy1709uTjJ74E8zbVdINk9X5rB3btEoEN5ITaof8ufXhV+EtxbfYhK0LTPo56t8bRsAaSjA5jUIhaG8ZJYO/gceJp59k15D57e9/yUjCWgzFk4H2tqLSH2ncr938LtWejIEkZprSeoxTpJugi5HGB+O3Qw+KYBlXZJQeCbKwAU0KwwzYEphQewTf+42NCri5FfumXl1JX0To0Y8jrdfauEKUrbO7qBWMm4j6O342gryJseETzACOGljAETLYi2X8gxBjouIb8rXIRVjowsNwphnWGMu45PxWKlGGKDL2Nldr23HDe210Oc64q+6BKStzpzQh+D4owAXwjz3ABEn6pVbhkhLtLKpQ0VMYpigA5PxcpfY7CNLOBnp40I7H
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Aug 2026 04:24:02.8738
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 108731c7-ac0f-4775-948b-08def8f2b49c
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN3PEPF0000B373.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB7205
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 8F6BC1A0007
X-Stat-Signature: 7dpnasqw66e5rnug5xhd87k3bkb9na4s
X-Rspam-User: 
X-HE-Tag: 1786595051-865327
X-HE-Meta: U2FsdGVkX194ORrkD0Y3nExnYTdLzZ+YLS+C2BZrD45q4v83TL+tQT1e8wRG6wDqBp4/pPQDxmgeA5vuSydqXZJIsRGhaT81ZYjkT05/AtSqoeM19pyqtCi8om6l4jztCgLGfhS3hFnG+7k+thj11/nOiODnamp18+26F9s+gclA7H0YEOE+y5/t1TRPJQyUDFTBM4s0kbd/CMKbRU7mw+7EenxojXmixMErsMwMqJvw+ZxzvuDTZWfTiVB9UI6X2NBYYViOHALh5YTL0m6CMDJcgUQAF5FzUobpYrMhLbYc6+1X0+cbxWuDPz54UvlLvKk9OP3qv7wAcdpDjIFWcqjT32+DISK7KjmdeXgE9VV3ZwBoyxjFwhLjhNjfYgno52oHuDytFao6t1WDQvtuY75CNuJMgRhrOIdy0vTiPAF9PVl26kyfFH1A+SJUnlWlufUsQy4KMVWXa4hQ31SbzzBuhhqwCPQS7Oq6VUSTN2CAsegPy02pjivSjbKQyJVTZT68xWAJbRiWwkaDTEtHOtIUvPRS2z/SCINechOISDhqkZTer87eSwdxvrc0YaPqQjCVmLvY1rZDPx0SyRJ8btrBF16nvO1sPhZnPhC/YFIEwErpgBqXR13OqTiOE5sSuqqvVjx28jJBORbAkUrll9nFRLw1+ieqrHFXIwKo4rAykJXHZApJCaU869ib2N1OykWBtPGWRQe1zrmsTqXpIoUVC04k4mOP9SePwVsffoW1y5L8C5SYbD53L5WiK54q3JnaxPDkrSV9FM+l372M56G7FbPi6I+xeBG4KZdeQUFaOzbYsH15e51LQRfioq9zzG3wJVslkJVO+xFFx+tkqxE6uA/4Ys0PPXzsOe05GpHC7LW2mu7uJOeQHK5nQfAf0fzCCZLa3U3+113Pa2BNYxL0YMqI6Kf2ftcmPOZQJ9VImI1bX4U2ZZwTcphViCatpCUqZCLjCdKY4dwKxnZ
 eshWcYWK
 zoeG1UqKTKfI7NXZ/Rlhhk1Rjp21rU11xJ6GPahRlSnjjBUXlby0GLfvbZSNyUCnbyFlUKktRUi8VqHVKq/PiH/tvL6NKB7tifStPYwF9nYANP/fRXcnISeTzeDKWPhGLH4uyEqFEdjLHYV1hOKXSwW1feaknJhjnRX1vwDpYeejFElWjHl51P+nKFROvOdR1ZaTkoK7avyurXpbsl775yeEoCGA6XjSzKVEP6D+ibnfYOFQFrUANlDsaDRi9OxEOILPRs1pOA6ORgLAPdi+rHIIsBMhxPBt5qwh/EMkYNOFxdbPUiGGH/DfbkK8qRi8/cK5gQ0bT9gjvKS5V2bGzgwAZ9IXlepo16HfbA+iaBy2xsm2e/PPlO099T2a4zJ6O3CaVJCVvtHgv9dBP3OT+znZBekpCztqEvgLs2A/wH90D+OTHTyMrA5v4TeCFDh8KUlL+VpQfw36ZC90FQkm1rjyXCfQmf2ktVcnSsbe8yz0DXRDK5nJlkEhy055NDtEsQyzQR+2tQhEGa9SUaQDVLcXnIUEsGxRr8jPeAWH3m0vkSF2VV/wGlCq8gltAMWQaeztu2BoQFwSh5x9hSpkZXyDuTQRVUi2Z3aEP94U+6ofkk6AZc9AR0oAL3bS0M8rGSRqnqDPmauqcrYk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Migrating a PTE-mapped large folio currently walks the folio's rmap
one page at a time. It does so twice per migration:
1. try_to_migrate_one(): Replace present PTEs with migration entries
2. remove_migration_pte(): Restore migration entries to working PTEs.

For a folio with N contiguous PTEs, each walk repeats page_vma_mapped_walk()
and the associated operation per subpage of the folio. (256 iterations
for 1M folio).

This series enables both walks to process a batch of consecutive PTEs
that map the same large folio and do some refactoring and clean up on
the way.

Performance:

AMD EPYC ZEN 3, 2-socket system (1 node per socket).
move_pages() migrating 1 GB from node 0 -> node 1, throughput
in GB/s:
                       batch-         batch-restore
folio     vanilla       restore-only   + unmap         restore%   restore+unmap%
4K        2.96±0.15     3.02±0.14      2.99±0.17         +2.2%    +1.0%
64K       5.99±0.10     6.12±0.08      7.65±0.16         +2.2%   +27.7%
256K      6.48±0.09     6.67±0.08      9.23±0.14         +2.9%   +42.4%
1M        6.76±0.10     6.98±0.10      9.74±0.19         +3.1%   +44.0%
2M       10.50±0.20    10.44±0.16     10.67±0.21         -0.5%    +1.6%

In plain migration, the folio copy itself dominates the cost, so these rmap walk
savings are only partly visible end-to-end.

When the folio copy is batched-copy and offloaded to DMA engine [1], the copy is
no longer the bottleneck and rmap-walk batching translates into much larger gains:

This series + [1], DMA Offload on PTDMA (DCBM), 16 channels:

		    batch-copy                      dcbm+restore
folio    vanilla    -offload(dcbm)  dcbm+restore    +unmap          (rmap batch impact)
4K       3.05±0.13   2.76±0.11       2.77±0.12        2.74±0.09
64K      5.85±0.11  10.66±0.27      11.56±1.45       17.55±0.56
256K     6.26±0.08  13.64±2.73      13.68±0.16       34.76±0.57       (2.54x)
1M       6.58±0.08  14.25±0.07      15.27±0.77       44.28±0.27       (3.11x)
2M      10.61±0.24  65.26±0.96      65.25±1.65       65.66±0.87

Applies cleanly on mm-new+[2].

[1] https://lore.kernel.org/linux-mm/20260630-shivank-batch-migrate-offload-v6-0-da95d7e8b8a2@amd.com
[2] https://lore.kernel.org/linux-mm/20260723070905.3422276-1-dev.jain@arm.com

Signed-off-by: Shivank Garg <shivankg@amd.com>
---
Changes in v2:

- Rebase onto mm-new, drop the borrowed folio_try_share_anon_rmap_ptes() patch
  and add it as dependency on Dev's series and adapt to recent migrate/rmap changes.
- Switch to recently added batched helpers - finish_folio_unmap, set_softleaf_ptes,
  and page_anon_exclusive_batch.
- Rename migration_softleaf_entry_to_pte() to migration_entry_to_pte(). (David)
- Split PTE construction from hugetlb handling into separate patch. (David)
  Mirror the split in mm/rmap.c patch as well.
- Rename make_migration_swp_pte() to make_migration_pte().
- Early exit the single-entry hugetlb page_vma_mapped_walk() paths - removes
  unnecessary nesting.
- Add the missing page_vma_mapped_walk_done() in remove_migration_pte_hugetlb(),
  which leaked the huge-PTE lock. (syzbot ci, Sashiko)
- Fix handling of hwpoisoned subpages in the batched unmap. Read PageHWPoison()
  once and skip batching when mapped page is poisoned, and use same result for
  hwpoison handling. (Sashiko)
- Remove the pte_unused(pteval) handling from try_to_migrate_hugetlb_one() (Sashiko).
- Link to v1: https://lore.kernel.org/r/20260712-migrate-rmap-batch-v1-0-872a734431d1@amd.com

---
Shivank Garg (7):
      mm: factor out generic PTE batch detection from swap_pte_batch()
      mm/migrate: factor out migration PTE construction
      mm/migrate: split remove_migration_pte_hugetlb() out of remove_migration_pte()
      mm/migrate: batch the restore-side migration rmap walk
      mm/rmap: factor out migration PTE construction
      mm/rmap: split try_to_migrate_hugetlb_one() out of try_to_migrate_one()
      mm/rmap: batch the unmap of large folios in try_to_migrate_one()

 mm/internal.h |  36 ++---
 mm/migrate.c  | 191 ++++++++++++++++++--------
 mm/rmap.c     | 419 ++++++++++++++++++++++++++++++++++++----------------------
 3 files changed, 416 insertions(+), 230 deletions(-)
---
base-commit: 480a31230b426efb005b6e71a14ef80f405f18b6
change-id: 20260701-migrate-rmap-batch-8ecc04de1905
prerequisite-message-id: 20260723070905.3422276-1-dev.jain@arm.com
prerequisite-patch-id: 5fdb03c3ea4a037f66fbd1c9b5d04e24e86406eb
prerequisite-patch-id: 033980575a1ef89d70e43a67c5530e2cf6cf97aa
prerequisite-patch-id: 6f7508334fc2bfc0df104ac50d36ed88072487e4
prerequisite-patch-id: 3f1aaae36e02d8b9343f7e719f732f10c1767572
prerequisite-patch-id: 98bc99c6bc274594946d022b3998f5f1dc70012f
prerequisite-patch-id: dd35ec00b82bf235f2e41e286d16eab6a3fd1e9e
prerequisite-patch-id: 552ee939dc6a7b3cce51373f4e75fa01a9d2b979
prerequisite-patch-id: 485cdbbe4e65b13494dc5104d4b8b7d0d23911a4

Best regards,
-- 
Shivank Garg <shivankg@amd.com>


