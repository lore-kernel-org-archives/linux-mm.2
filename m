Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A6D39CA0EDC
	for <linux-mm@archiver.kernel.org>; Thu, 14 Aug 2025 13:49:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4995990016B; Thu, 14 Aug 2025 09:49:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 47228900023; Thu, 14 Aug 2025 09:49:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3602790016B; Thu, 14 Aug 2025 09:49:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 22DD2900023
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 09:49:34 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id C00C68311B
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 13:49:33 +0000 (UTC)
X-FDA: 83775495426.17.247971D
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2058.outbound.protection.outlook.com [40.107.244.58])
	by imf24.hostedemail.com (Postfix) with ESMTP id 9309118000D
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 13:49:30 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=SpqgDs2b;
	spf=pass (imf24.hostedemail.com: domain of bharata@amd.com designates 40.107.244.58 as permitted sender) smtp.mailfrom=bharata@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755179370;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VkiW7fONMc9c0vXFrI/z6XSVU9crPq1YeLdZf5pAqUA=;
	b=sTaUTtcs8c8KgJN1hojR4djHyuIN89atVEiicyzt6qupVGSNgiOCGoO0x0ANYJhpdqurCq
	LUAMmypdQdgXc0gVRfP8SNW5Z2lMXi2c577LQas8IEP8SUSyt02Fd7Gz0V7kEnYSV1njM8
	rOMUH4i0VsG0b5sdWRG1YxF4mY1ypsM=
ARC-Authentication-Results: i=2;
	imf24.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=SpqgDs2b;
	spf=pass (imf24.hostedemail.com: domain of bharata@amd.com designates 40.107.244.58 as permitted sender) smtp.mailfrom=bharata@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1755179370; a=rsa-sha256;
	cv=pass;
	b=QcoDH0JAE2TxnYWWsDLuF/dNmHXEfsw2OCwLXkrHCIafxsWLADIBxE0T38pveA0goQwC7v
	LnFMKHK1dWuk50L2eG1ps/0pn3s/imgzeOa8QZgXvD5Zk1IKsmz8MCYf3DsHELg6+LcEiN
	WwQ7OjQxZNHXQgz1HW5IXlxZqnyDz68=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=APA+EtQBEqf+0xEVM+K5SfV80x68kWrv5r78yFXmRhxKsTlP/p4avHA3TIbXBq8SpJTpjW3TM1NnmObu6rqAxHr1COScm1b+LttHi2AAGLy3mcxkQt2975bFbpG07N28sDrwi+mBUqj7GgkZ9S+fdPjfStKLXtKGjd39QOPiVOxA4djifz/+KIeVUXWu8xXa8fpGiWLtBVriWr+un9NUKAOGfPCmx+7u63Oqa3GbMNh5XN13zwy206j9rYMUusA/ChOarNz0/X7phesKBubUPn9ybN8nZpW6Hxj4npJ9Z0zljPhQOmfl4IXKc48+Yb5RtBE13qIPiWkimh+nt4Lqaw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VkiW7fONMc9c0vXFrI/z6XSVU9crPq1YeLdZf5pAqUA=;
 b=YR0FHtsJDSOX7UIw1sXKZ+jDHaq3XssCGuPlr2yqbo6CVVVcJDWAlV+MrqfciJR0+Fi+79cs0YC+0VKNeeithES8bvIt4YkgnEKHZiT0XGdh2weuNqsUXBWXvJXiFKS8bTtjexpHVZY7vXOYRDkR5QzHqn6lG1/YN0uoInkxf9tQi4raiCQjN6NMWEMnLMzJ9X/E2BqiWy4h2VdFu2fXK0O1tuiIgyIPUK3BIDfsP/5k956hiIa9SppvSsQOv8AomOq7R1yx3r2p+gFK5aJhbMD4QyKsC+Op6JTFi28Yg9257ZQLMqG7tHvp9FLQC18ZEvbgUOEZncGfijs0arFI4Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VkiW7fONMc9c0vXFrI/z6XSVU9crPq1YeLdZf5pAqUA=;
 b=SpqgDs2bmX9ZM+6CjOTEt9neBjtewckkFZ3EKrd+bFCDo56LekifWDLCxIWoOhgB979lsrIOWfX5whHJYOd1edZ684gYafnpajzLhntoe2r72dDERY7F2TYcQ0Wmrm3PTvQYt9KC4gReOQTbAGwEf7F2rnspj0NJHU32jqxKG2o=
Received: from SJ0PR03CA0376.namprd03.prod.outlook.com (2603:10b6:a03:3a1::21)
 by PH8PR12MB6987.namprd12.prod.outlook.com (2603:10b6:510:1be::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9031.15; Thu, 14 Aug
 2025 13:49:26 +0000
Received: from SN1PEPF00036F3E.namprd05.prod.outlook.com
 (2603:10b6:a03:3a1:cafe::14) by SJ0PR03CA0376.outlook.office365.com
 (2603:10b6:a03:3a1::21) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9031.18 via Frontend Transport; Thu,
 14 Aug 2025 13:49:26 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SN1PEPF00036F3E.mail.protection.outlook.com (10.167.248.22) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.9031.11 via Frontend Transport; Thu, 14 Aug 2025 13:49:25 +0000
Received: from BLR-L-BHARARAO.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Thu, 14 Aug
 2025 08:49:17 -0500
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
	Bharata B Rao <bharata@amd.com>
Subject: [RFC PATCH v1 1/7] mm: migrate: Allow misplaced migration without VMA too
Date: Thu, 14 Aug 2025 19:18:20 +0530
Message-ID: <20250814134826.154003-2-bharata@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250814134826.154003-1-bharata@amd.com>
References: <20250814134826.154003-1-bharata@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN1PEPF00036F3E:EE_|PH8PR12MB6987:EE_
X-MS-Office365-Filtering-Correlation-Id: f2c0c6cb-3ef9-4434-fb59-08dddb3961c8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|7416014|376014|36860700013|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?fLEZctdN0lPs25jh8fqo5HTqWef76t3jWBM1UThnVPadydZYudsLxPHeYoiI?=
 =?us-ascii?Q?KqUQyZMqKcD9V38sAzJIcsJIopwbjRpZQSGm5IbJP82elh0krSw/NmDE5Sau?=
 =?us-ascii?Q?akw4/nemFavUkeKx1XAtvo4wdEM2FnbOReV/e6aWhynSfxufuBZ4oQoWMFUh?=
 =?us-ascii?Q?KCQ7yBKgR29t4TM2vUxwI9OAI6wQXcw+3sB04NKNWvEaWjk6wte45OTwRuix?=
 =?us-ascii?Q?t1V10auBuMBrHWCsEH710eIp5CNNaMDEdmi9QnqLfelsBK5amIeuyGTI3XWe?=
 =?us-ascii?Q?wj0ylZ6lnzxiucyEJ0OAS+GrdW/p3TcSf8WzRUnpJ3LPrjZvcLnZmgLH2G6V?=
 =?us-ascii?Q?t5RbDUZGpRtz4QbjQPIwrkeKqFcLLAIjgqAm8V/2Vtbc7IUgOKyKC0Mt5Qgx?=
 =?us-ascii?Q?OKpnDUw4veeLEOFwrqlkaCG/Uq58qhOOqD9f5aZi+qw/GnlgGDZfVVrujHc/?=
 =?us-ascii?Q?p+7aQ0LdpG3dxLGTq5NPXCAJRMDv/WY2hOfuH4rPplWGyZIRz2I7BQeLpQ+5?=
 =?us-ascii?Q?/BklA1LNh7/QfZ7gS9HmgeulZywb7PNpBjddcjFhyrKeA7Bg7SYC6+cNnl9i?=
 =?us-ascii?Q?7afirE4ojF2+o4pcaPRuM+BWlF1HwT1jBiqY5bBwHLw6YLpOpWz3oHzTqR0L?=
 =?us-ascii?Q?uRaJL2QthedmGVG+sBcJ00Ifm2XZcf6juXJnq0FCyICEDVjBP1cC6cGkVll5?=
 =?us-ascii?Q?EGZZRDC4wpx6SDL1g0ylnJfCTcUGN4ed76eEg3DvveAehvO2usMRFgbjTqXS?=
 =?us-ascii?Q?6W3huPRUfFRCmBTOiUohCvyrV8PU+0MUEVvGhHYLiiLHhFkt+IGo3/ZvSVqJ?=
 =?us-ascii?Q?LsE6GXxdbnKKZdfcsNCwWU6E3TgkKbaDQWlSFl7ln+sYKOLyYggprC0TxaYv?=
 =?us-ascii?Q?ICzgXwfK0Wqj5IMSUK08PKAZPAXu1ZzXrELdBOTdZ5gcap9nUz/8NHl+oJp/?=
 =?us-ascii?Q?KwKz34tpxVxmGiXJu4LAzjYswRuVxC7fXxqkUAWLtfHfqEujxjfq5bCf1FLV?=
 =?us-ascii?Q?RYjrrHiTNvLfISq0/DwajU48EfbpQtsCptxJabIEra8ZmSwCTetkKwpoO1rP?=
 =?us-ascii?Q?7OEobB1XAV9f9beGkf+hf3kGr8ip3HQskR5oIG/EEhtdKkmfbUd7Qa4sIIJw?=
 =?us-ascii?Q?axEH2osDTpjEje5XdaIW1dDtMbhGeFdUrkbU1nCmYaMyamn6zwRhj+rfQfhI?=
 =?us-ascii?Q?YNZdlyY9EDA3vi8M0f3W2AViopEKjddKJ7XIltufudGECXHtdN2L6MacAj3l?=
 =?us-ascii?Q?iUStdyNSEdC695tNRMuyGoYOxxfgQhHqlKES1hAZXkd4rasuYdFmpAo70FNJ?=
 =?us-ascii?Q?wmy3huuhHT4Qc1QG7S0dn8yONIWBbxijcrUa5ZDvM76SjuAsCpIBZSjAU4Z8?=
 =?us-ascii?Q?RJdZqgV8MDZgnu2yieP0F/IqR30hMCuEyV8v9P6P9L9lnRuohK29x7/v/fRY?=
 =?us-ascii?Q?PQdrmcN8QcFND+CabNxrY5scFIn67Vg0nqH0byDmtqrA5MKxo6pK//J6O2bw?=
 =?us-ascii?Q?e7tiS0FCLYbFv/Z9BgBGNDOgDn1ui9w52xrZ?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(36860700013)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Aug 2025 13:49:25.5915
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f2c0c6cb-3ef9-4434-fb59-08dddb3961c8
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SN1PEPF00036F3E.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB6987
X-Rspamd-Queue-Id: 9309118000D
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: dgxzt1d47wqf74b5oppoinjp7rknsnar
X-HE-Tag: 1755179370-268510
X-HE-Meta: U2FsdGVkX19xHaDgV0xRQuFeNsWpN3VrZxg/I711YtVnbkNnQAeFh/LB9wMUYU2DRyp85oOERjpiOEbuUI70y/B40Pzb+jWZeVc7x60UWw5diA0FFEG+vUx3m0mdec74pDpXnCBDENet57NY6rfPIFldm0q9S4ffavlOHfhT8TEnmy7zmhnIszGvb3KjfTY8km5BTqUjfa8EHIOMuM5C8SgbzexK/eMWGCWZRr00lH/hL5aJILfj4DmL9+pxFB89cpo4GJnXaUjF0tJdwBzjwQTnV93CN14E1N18f1jMEvI4JjzMwiEW/8yN/pfSi0cu8O0J+sPsO+mFsbmMWQkvSai05YE0IkXn8alTULEnk6Xg4pJnZDs2Jwvc7XuCuMa3UaRjYAwmdPaJ66J0uhPJcA8ataUxBB0W9DYrK0YIdb/yVqR7IqXPFMA1mlhnSYN8JUXTScyZ4Mko/RPxwBRdhVVMuNujGH8bgQ82QWbhpFb/xCx77AHKLC44/2SVYLaIYf7D0AAhDSRr+kViKsVIq8dMxBg51yAX8h1C1y4GrNpLiCGZ7/y4TKy84Vn5vH362mDmhZuwf9turIHMjlvCZQPi9O15rEYVMREmYc1oMUfwwC5WfwEFmHzmVN+X3MrKP9CPImDG0iiv2J231Tnd1aP2lGP93URZD+8+uUWS7dlBZbBINT588xpsv0MzY0Gu+D/UgaxrzPsvdwAhfCKj1oeY3DrPxZNduRH/CaVauEpR4Xee38+dOY02qQwll+QGmULE60mjhq5+FSPq0qSS2zM3lDJrXwxBF5EmDLknKVvsE6pPbIiqSQEkHb3sIN8aY5h6aBRPdUL+ebInX/kaFPL/VlaTH0SUSVFobDfFySekwB2AnPdMHVetkbpcfsoq14862s0FRwcwmvq+4VNmNevVz3KovU/Me6DvfEoLRjzmxHs41xsQXjMEMacE/WZQZ4zxifB6tjBlu4zcLVW
 BN9UxwPW
 0pSC+TZ1yrbeC3PdnkjiETjKW54Q3NBD05RIBV1m7RRgF6JV66bMuuPmwiSIn+vz3lk6d2OhtcVZApayJjaTr4bZJIrvPQz7x0iq8qhxDsGrcZOPcJuHRT4DXDvWvVErVs/Lh88JPU2wPIfqJ26AlYkPMCJL27piZBYupbc6QnH0Jz89m3XgIgz6UHF3bT1SAmmeEURBhPvzObmuv1h+WKDzfwvm/0pfoDLLEBDttxMM9sxqixVL7n2xPqFsFRLAg+5pFgmirn2z/ECVp6dHtyezFf/61sCKPBnlAAHZHJpIJAnO2IKtdkqF4cRjql+TOnBZJ/n+9t1KOzpgZk3CmyU4uXzcP5/bo1jA9p8Q85ylz8H8bs3YyGt/ADXXatgTTl3Y7T3FSshGKVset88WwkTqxc6Y08b4Kb0/xMDSIGYc8nvkWKvvyhdCwwM1hpvT58slxPhrMcybUmb/VQyGHyi7T/r5GmaRgAfO74AXKhj8iS8riTzRcVR8E5N/w21ler8rXjdufjgG09Uy/nF1CJ+DJHCkgFewW5OGDX42/GFH09o7V0ptza1zgaWHspEV9zce7nST75X7auE3DpUjVitdagw/sB+zT28zfp0nwbXoipWqPXOdGOb7up5kTUx9+iUJW6PLbBpL6bMjkX9Yi1S/NJwCiwRG9xdpB
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

We want isolation of misplaced folios to work in contexts
where VMA isn't available. In order to prepare for that
allow migrate_misplaced_folio_prepare() to be called with
a NULL VMA.

Signed-off-by: Bharata B Rao <bharata@amd.com>
---
 mm/migrate.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/mm/migrate.c b/mm/migrate.c
index 425401b2d4e1..7e356c0b1b5a 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -2619,7 +2619,8 @@ static struct folio *alloc_misplaced_dst_folio(struct folio *src,
 
 /*
  * Prepare for calling migrate_misplaced_folio() by isolating the folio if
- * permitted. Must be called with the PTL still held.
+ * permitted. Must be called with the PTL still held if called with a non-NULL
+ * vma.
  */
 int migrate_misplaced_folio_prepare(struct folio *folio,
 		struct vm_area_struct *vma, int node)
@@ -2636,7 +2637,7 @@ int migrate_misplaced_folio_prepare(struct folio *folio,
 		 * See folio_maybe_mapped_shared() on possible imprecision
 		 * when we cannot easily detect if a folio is shared.
 		 */
-		if ((vma->vm_flags & VM_EXEC) && folio_maybe_mapped_shared(folio))
+		if (vma && (vma->vm_flags & VM_EXEC) && folio_maybe_mapped_shared(folio))
 			return -EACCES;
 
 		/*
-- 
2.34.1


