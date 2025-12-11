Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7709BD3E79D
	for <linux-mm@archiver.kernel.org>; Thu, 11 Dec 2025 07:06:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D909B6B000A; Thu, 11 Dec 2025 02:06:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D69116B000C; Thu, 11 Dec 2025 02:06:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C2DAF6B000D; Thu, 11 Dec 2025 02:06:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B08EE6B000A
	for <linux-mm@kvack.org>; Thu, 11 Dec 2025 02:06:34 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 712D5160786
	for <linux-mm@kvack.org>; Thu, 11 Dec 2025 07:06:34 +0000 (UTC)
X-FDA: 84206307108.12.E565B6F
Received: from CH4PR04CU002.outbound.protection.outlook.com (mail-northcentralusazon11013023.outbound.protection.outlook.com [40.107.201.23])
	by imf21.hostedemail.com (Postfix) with ESMTP id 8A46E1C000C
	for <linux-mm@kvack.org>; Thu, 11 Dec 2025 07:06:31 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b="cD2Xm5W/";
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf21.hostedemail.com: domain of ankita@nvidia.com designates 40.107.201.23 as permitted sender) smtp.mailfrom=ankita@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765436791;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=P+9X97v8oLGLYonIialThNeDaSCMrIwHdgiUJqYKE3k=;
	b=vpDzFrQ9JBw22T6/xRGMfHCo6jA9PQ0gHfHnFsrDGKl8rfRBo13hThUC4Ng2rvQ5LY8xWq
	L9sItap+NoSG9ENL8q6JnpAEG3E9pwWyKVprCe8ngCc0b2x9b1GTtNbPWMxmK6yv/20kf4
	rXPnhlqyANSCYpMzR4+i7XcpVy7u/K0=
ARC-Authentication-Results: i=2;
	imf21.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b="cD2Xm5W/";
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf21.hostedemail.com: domain of ankita@nvidia.com designates 40.107.201.23 as permitted sender) smtp.mailfrom=ankita@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1765436791; a=rsa-sha256;
	cv=pass;
	b=HduDQlX0MyHgWHgVj5LxcHqf0F8itGIbBWnEpF4+Qus7fviMU4oREWTjI6C14aitX5qqGV
	sqfbgpKgzqCh3xishOMQ7ImdDxgGuB6p5E0bk1LbNUOtL4FInSp8VJbQ5XKC7kQITqK/vh
	In25evez0Dbezrn+0CoYeaC80T26nPk=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=c+pCtEOXzWCNkUHR0QFfMCLBM3RAKLeWsLdoMpuopG0wsp3cd1PwlcvlKYalX70Ad0ZlsFZkn5EB+Sak3gkCQD3krvgG2Yf7S9dDPtb+1jcdTfzx9Aq1ULubgpDcCyV6ovFHvUCzoQFAFTpPxwWQ/sFxjWHc1VxubPS10QsF5U88SqwDN1SXe9GDLhKny52d2WPCYnKzcNCqc/k75GnrGr8AB58Ul5i0yiZmYL1tim4MuDUfpm+c5X7BQ4Rd0szmN9oaur9tppCYvc3r1+uZxddVGdcL3NWKfphM3YsXa40B6q+4nOzu0l0DbqyFvzWmtXpfd2ZtsZOnc3t2W+Xo2g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=P+9X97v8oLGLYonIialThNeDaSCMrIwHdgiUJqYKE3k=;
 b=UFAZMV9zKWb6tuXjvl9aNctJZwef2yKwazCPoQ++y0BnBWLd9BPWb9kjl4LuVR6/GH+b3g4hPrgedYMqAqg6DrbYxfnd7kd/9+UINA2AUJTPezoLVfBiBRp0OMpmVKGBILF4ap11YY1h8FfVFqbMyqLbNIqXQ7jXgbibIisLKup6HiFUQ/iVLSYPzXQTziJvHcYb+lmo3lWjf6n6OsEid47ZVMnbcA4ftT/ewM7LBu8LZjkY/Li/fwn9woebrSHZhRR5xJrAT4jsULkMQEnO074+Fj1LtJU577DI8W22vjeYl5If44eWr9a5kruFaj1USA3TMXoFkFWgwkm+homOyw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=P+9X97v8oLGLYonIialThNeDaSCMrIwHdgiUJqYKE3k=;
 b=cD2Xm5W/mttnPptKyFPUbiKFinviKfH+CnyuimbeQa5SOxpzCRIcZaQcUscnrHek5celwlhP+aDSj092caCNH2a8VSeETqvSJ9j4pm2GBC4zBuIKAdMh4an3r99f/1wFI6LjbSAwbRFYIUm82X43keQ4uejMwr/YMAf0Ub8fgaiVsCyzePh6TImS0GofvoD5fJOu2Elfyp/b/QsqO2SkiY6xvCjhdK0pWufK3ozh0tpcwuxNkzPA7M0vWUmBYBAEUnLjvTOius5rnN7/KM70JKfkhd+eN+dfou0YEVWtlMvcIcQAkHPLoQ71f/Tp8TwGEdsGBhwg7W0CLTX91DB9Hw==
Received: from CY5PR03CA0005.namprd03.prod.outlook.com (2603:10b6:930:8::12)
 by SJ5PPF5D591B24D.namprd12.prod.outlook.com (2603:10b6:a0f:fc02::994) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9388.14; Thu, 11 Dec
 2025 07:06:22 +0000
Received: from CY4PEPF0000E9D4.namprd03.prod.outlook.com
 (2603:10b6:930:8:cafe::1) by CY5PR03CA0005.outlook.office365.com
 (2603:10b6:930:8::12) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9388.15 via Frontend Transport; Thu,
 11 Dec 2025 07:06:22 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 CY4PEPF0000E9D4.mail.protection.outlook.com (10.167.241.139) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9388.8 via Frontend Transport; Thu, 11 Dec 2025 07:06:22 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Wed, 10 Dec
 2025 23:06:06 -0800
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail204.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Wed, 10 Dec
 2025 23:06:06 -0800
Received: from localhost.nvidia.com (10.127.8.12) by mail.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20 via Frontend
 Transport; Wed, 10 Dec 2025 23:06:05 -0800
From: <ankita@nvidia.com>
To: <ankita@nvidia.com>, <vsethi@nvidia.com>, <jgg@nvidia.com>,
	<mochs@nvidia.com>, <jgg@ziepe.ca>, <skolothumtho@nvidia.com>,
	<alex@shazbot.org>, <akpm@linux-foundation.org>, <linmiaohe@huawei.com>,
	<nao.horiguchi@gmail.com>
CC: <cjia@nvidia.com>, <zhiw@nvidia.com>, <kjaju@nvidia.com>,
	<yishaih@nvidia.com>, <kevin.tian@intel.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>
Subject: [PATCH v1 2/3] mm: add stubs for PFNMAP memory failure registration functions
Date: Thu, 11 Dec 2025 07:06:02 +0000
Message-ID: <20251211070603.338701-3-ankita@nvidia.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20251211070603.338701-1-ankita@nvidia.com>
References: <20251211070603.338701-1-ankita@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PEPF0000E9D4:EE_|SJ5PPF5D591B24D:EE_
X-MS-Office365-Filtering-Correlation-Id: 7f14862f-775c-4041-c210-08de3883ca99
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|36860700013|1800799024|82310400026|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?40+rQgZWodE/c2vkadDygEokaM4Guw0keMLKCgTwEhbQjjrHBKFIpwnrpwVr?=
 =?us-ascii?Q?EWYDafaLBAZi9Kyfq42e6TdBNGTnPXKwzYBhagQzwFbbK0ZXVCD2VOUWyJgo?=
 =?us-ascii?Q?bR2eoPkFqrlSnnfZ4FHjQDmzPSHfPMLH2jrwg7A/djtLA2ESqiZ9FsK0kXiS?=
 =?us-ascii?Q?uZhQ5F5sVEfQhkXD8rZ3C59ybHjJZ+C0K1y2MQ9GWkcxPMtR0/AJwyMCao/7?=
 =?us-ascii?Q?8IFPu1j1SkQ8aaWUSsstc3S/TL79vmbfOuH+L85dOcZIaWn3rv2OxMY85A45?=
 =?us-ascii?Q?n6RN55E3HBnM1XZMdWrh8H7C7PJkSU6KHmbUxn+t4VKoZffPNURpm4qfIoZi?=
 =?us-ascii?Q?WySi+N8cOaPiduUN3zs3FUtd8kGDhg29CX5SjeBdyVKXDdfiyQCkuLUaGQLK?=
 =?us-ascii?Q?Mqv/p8bgluzKyP6Qt8Q/KBnHq5vpq5PMByYWQ5HjZZu5gn3JRIe2v6I4DTIQ?=
 =?us-ascii?Q?n1Qes5yMP+YpnYI/fPuQtubYLHPUOE7z0Ln1G44Y5/w5DfJciP1Zcsl/lFVN?=
 =?us-ascii?Q?0nk1Pdky3Qs8yzUk5ULhSJSxeQ155VkqhaLPpIjPGeUeJ8nDe9n0wUBrfbn/?=
 =?us-ascii?Q?s2NSNuFZneGrW4t8LtigXJlwXrbbihT7+8i3qvbnR5n9cZ9Pb0y7TZUO8YjU?=
 =?us-ascii?Q?6ZNbnn4OfBV+Wujis4nn6d2DwaEb/EdTUkTCdoybz0WmG3VaalxyYUvViyf3?=
 =?us-ascii?Q?l6X5Y4oNiT/uQnklqYu5pAsQtTw4sJyhCVPGIwZAvvVi/qW88LqLoLzTezWE?=
 =?us-ascii?Q?e8DbKz7j0m/+QuBJdSYvDAxdRjTyn8Mh7pjoywkk97QWrgfgteoNCCvoQ7yl?=
 =?us-ascii?Q?CeukBS4F/JVO+9FBRC6JrZ76B9p2rfSvzXv9lTH0Oof2x5N5UbfGqu5qZQgu?=
 =?us-ascii?Q?D0Jhlp2IEbhltFN0oEpCkBrXosYH824SIuQow0wLAC5aR2phJWhG4DV1nds1?=
 =?us-ascii?Q?ATDhQg0I/w3GNKFFC3pnQQLdN1Scq1ibcEYH7t7A6Z1zms7I+2pmcyzf7GOQ?=
 =?us-ascii?Q?3VAoVUQVZsOUKT+vyS+AVcBykl9TfjhjsS2ypHVaSIme3djt3uP0fEZuAn4z?=
 =?us-ascii?Q?lCtYLmTz6Ax3Rsb4Wi7xbN2mSTTuU0JxbQPRIvV9H48ThyvzrR7MDmrwEUGo?=
 =?us-ascii?Q?6LC28AGUiXrtbIzab/rAgJOiCBCerO6pz/umGHCHe8mLhzW7ey0VxkSZq59n?=
 =?us-ascii?Q?ku7qW1gElMrkZ7mN0vjhUiqGaig6SMINhwOaIKCMj64FFDZNQ3+TXZeOkKkX?=
 =?us-ascii?Q?rtOPJN57ZAX/0DlnvfWDOUQwZwUuN0MIw9pJy9+B5rns349YZjwkQ9avBwIc?=
 =?us-ascii?Q?ACUBzariHbcax4ZMdfBqyphFznCEDabYT8eP6cbBOCNyef+XiIoUdIvUrAqH?=
 =?us-ascii?Q?A8KiXnP+hKAzYwIUbpAVnhRYNwJOLkYqqvmWBy6uDb+qt6Zy6BdGkjY/ajz3?=
 =?us-ascii?Q?+M0slF8oozdzcfYNa4ZA81XqU6oKDYLgfMcbpcTY1e+e/FcQUv7RD2fvqz5s?=
 =?us-ascii?Q?ARjXmQJbtwPQ55nFbEKjcYqY+5uJqNOOBD2PIUVWVANxsdROq//LDR6uBLi2?=
 =?us-ascii?Q?q2L3lpYBr6yyfaX3+IX3Jm4sNwSbm+yBj6C9Q6kl?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(376014)(36860700013)(1800799024)(82310400026)(921020);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Dec 2025 07:06:22.2968
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 7f14862f-775c-4041-c210-08de3883ca99
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CY4PEPF0000E9D4.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ5PPF5D591B24D
X-Rspam-User: 
X-Stat-Signature: dyuk4n79w41ftth7ba17zooj8our7t1p
X-Rspamd-Queue-Id: 8A46E1C000C
X-Rspamd-Server: rspam06
X-HE-Tag: 1765436791-171270
X-HE-Meta: U2FsdGVkX191GBwx0fWcMctvs11/S9s5m6fEUtjGqGfMY5y8IcH+88ElzM4KYMx+RUSCG5l/fvr3trtryBMnApUondu3AoJ2d83wPTbiPNwgz0fKztN+/YXg8FLGMRWDC/7wCMlXB0LyW3Nry+qvu77/o/qZIKynpOS8CZADjdLF3Igg3ctWBsB4ry4MhG3UDfNMVd850yGUPeYV5x9hotbm+B0bop+SknOCwmzSx0UAeCPHUYJwREs9MrnxBM47fE83HTA5ROxcldHBNEuxeKLZ+Uhs6RjJdfuxTGPrvb/MppvmqTLRFjLkzBw5LXrgk9VZ5wj05Qu7Z6kWlGnkInlhaYL1XrbVH8fK3osY5Uzw//Iym6LdS6BU6hGEw6KaFQRhHMhcOUwj+zi0l06+SpIio7r4StLijE0fmqDW4y1zdTBRBscFEbK4XbpPfXqKr916Gj1BjMjarYgzbwuaQGuD/F13qAY3Idod6tnrkoaewXJota3OSACTczWJey+5VfXTijZeooi3LJaJ/6+eFEI5ablud7PUzdJBAyH2RB6oS7bn1ods0f7veyv7F3tHXFsOynjB7gFs16kwXmlxDIhy4ujr9Epr097iQDAV5aJy4dVi6CzI1hnrC7Ol8LgRyZ7vjTIqYypanmPTu9D0l2pO1ir/h1dyE/jYwQEGlqGVU5D1lQrKnsY0BFk1163teN6Zn3Gm05OPITv85uHG7rV+TqpLUuptbgm19sAvvlv+mukoaPlllEVNVZuj3A6hm73Z/KIee+M9bQetYlWnahVO9Cqf+uOywjRKdU7BbBDLHXHL+G6K4yjTmKoBZi3DbqH5taXnxCs06tn2aW9X2n7mpW+vW6wu0Hos1eBqwYd0dw78wXhL8/8HQgqFkD8qpb+bRbTaHIf6bJ81ESRph6RcEGYXj4LVtmwPaIHQimDONcVB0V+SjLf3kBp4TIPpCC9tLRJkeQzUtmbBYcd
 4IexPO38
 FBV6YtbC2ucT397A42Px+3K58wNL1gVCnJad1s55mGSkvpwxvEnchwpHjs7FarPCNo5UKLcVRpZqUHW05GhjQ+Z2O/iFin7sl6b3XnuNyD8jmvIxmsDfMa18anD2udvwAf2glwcKhXu5Jdwe6swdfDc5CYfW3wrJmDGzHV14hWEwb959vxg43JF2UUq4lzOrcpI6ZZJw8nfFQTQ+VYeWsRQbQ471w4hqL68kR3BNCZmBUUYGVt34OVBNVVVrNN9W3v/YNFGtpCqb1riHZRH1lM37k05ynnZmsLtH9//QU/59zL0rtI/qouD1Kh0O28EIItZQ6NKcCWmuCAtDRWRa2WK+ogrd/Mi2WJNmBkhVAk3pft9epnxn3ud+OmaGbLtBSpq3GC+VkUvpiulanFcTAOvUXWCLsSvZ+xCfUV2v/qFJIlAxkb7R2Q1TeTXFWDT6OW8d06qKJcsDrvBRk7Ip58ECMcQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Ankit Agrawal <ankita@nvidia.com>

Add stubs to address CONFIG_MEMORY_FAILURE disabled.

Suggested-by: Alex Williamson <alex@shazbot.org>
Signed-off-by: Ankit Agrawal <ankita@nvidia.com>
---
 include/linux/memory-failure.h | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/include/linux/memory-failure.h b/include/linux/memory-failure.h
index 7b5e11cf905f..d333dcdbeae7 100644
--- a/include/linux/memory-failure.h
+++ b/include/linux/memory-failure.h
@@ -4,8 +4,6 @@
 
 #include <linux/interval_tree.h>
 
-struct pfn_address_space;
-
 struct pfn_address_space {
 	struct interval_tree_node node;
 	struct address_space *mapping;
@@ -13,7 +11,18 @@ struct pfn_address_space {
 				unsigned long pfn, pgoff_t *pgoff);
 };
 
+#ifdef CONFIG_MEMORY_FAILURE
 int register_pfn_address_space(struct pfn_address_space *pfn_space);
 void unregister_pfn_address_space(struct pfn_address_space *pfn_space);
+#else
+static inline int register_pfn_address_space(struct pfn_address_space *pfn_space)
+{
+	return -EOPNOTSUPP;
+}
+
+static inline void unregister_pfn_address_space(struct pfn_address_space *pfn_space)
+{
+}
+#endif /* CONFIG_MEMORY_FAILURE */
 
 #endif /* _LINUX_MEMORY_FAILURE_H */
-- 
2.34.1


