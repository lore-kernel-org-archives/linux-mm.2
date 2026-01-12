Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3DD73CF45CE
	for <linux-mm@archiver.kernel.org>; Mon, 12 Jan 2026 20:23:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 94FE56B0089; Mon, 12 Jan 2026 15:23:38 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8FD466B008C; Mon, 12 Jan 2026 15:23:38 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7FC3E6B0092; Mon, 12 Jan 2026 15:23:38 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 6D6616B0089
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 15:23:38 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 1E528C3FCB
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 20:23:38 +0000 (UTC)
X-FDA: 84324437316.07.1D3C48B
Received: from CY7PR03CU001.outbound.protection.outlook.com (mail-westcentralusazon11010041.outbound.protection.outlook.com [40.93.198.41])
	by imf30.hostedemail.com (Postfix) with ESMTP id 2A73380014
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 20:23:34 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=PgvtUrdw;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf30.hostedemail.com: domain of PratikRajesh.Sampat@amd.com designates 40.93.198.41 as permitted sender) smtp.mailfrom=PratikRajesh.Sampat@amd.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1768249415; a=rsa-sha256;
	cv=pass;
	b=LrvkV5Xd9WxLLFaK1k9ESCdP5H3ZDNzG6NRFARG/ARn3iWIKgeQVVVBQE6TegBEStR/iAu
	x5On/w7sO+3EOVwhZPS7xKjhl9Su4hNaN27EjFM+9mWwsj/1ec8VkifFLa9GesPGdPs03O
	nHvQUFZEn3mTQ9Fw7kb2QkBIbi7E+Zw=
ARC-Authentication-Results: i=2;
	imf30.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=PgvtUrdw;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf30.hostedemail.com: domain of PratikRajesh.Sampat@amd.com designates 40.93.198.41 as permitted sender) smtp.mailfrom=PratikRajesh.Sampat@amd.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768249415;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pGcNiGmFZQBlt9tcJv6pIfBGTcI9ybKafwo6gHidmHQ=;
	b=zc4Dmay55NH+O/QksepvOHkIIKaiMK0kh/mmll8l16683oKd3Yoxz1vk58i7P1zdDDBIg3
	AVQYo5RCU1+iyJg507Y73HrwkfUx9Xt1B+eHNlHjnMhMDzqofc+vUxLxlmGKftQIVTZWav
	YJRhPu9xChl0QYbRowsYEtBXGCRN6bc=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=HAkuYnXFbQa7CXHLM4CRkf0MsTwwWflgmrKe/k7Fq5iKOi93cb7NSq0bRyxhkODUxKecMrKG1pBpzeEitBrKu2F/E1oZ0cpw2patZMjQA4Vgd53qGLAekSqRletCGbxV6S+9h0hsxMz2ADbITOuIaK1asUbe+dWNG0yCtPmjB5TtTrp0MSC+h5KJOt24/nhCNDHpcsGrMHG2UAAbYqRx6DvXd4/lIow5hInPq12SJbx/Djc6R/ptKuxpgTKx5Zor8IhPL/YlJxP3+NMpRR8rZ9aYfha/HaKg+aqlD1C497ceHzFbt4bp6EgXI+c4RSfY1tY/8MCVaS1h3qrXJprRdg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pGcNiGmFZQBlt9tcJv6pIfBGTcI9ybKafwo6gHidmHQ=;
 b=r2nviDjV33F8hZbnL8147mdAaz+GTAgo2S/TkJgvGQzwHe9KPB3/sJyWROYK0ns1NIH3igAqWOhYppzMVXMF/zXNev4KGWCoc+96NfJuJPrZ9ZRQ6/ZI9pRxbgo9T2EZoLD7bQMLpDNkT1xa4MkVIdriRpGURDHRbKLlPJnm5jFnqVu84ZT7pTPvlOaCCvu9fXHoWXFgvdqcOak/crW09qrfQnQ7HXPKzdgCP9g6akLsLCZncVw63HEhGayYgUEdIRq0DzOvjKruDq70cwdzYUnslAkbieaqZMgp35CP8ObDuo4yg640AfCPS6P3SThVmQZWaemq+Du9d6QvIL8aRg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kvack.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pGcNiGmFZQBlt9tcJv6pIfBGTcI9ybKafwo6gHidmHQ=;
 b=PgvtUrdwHvoppjJaVI0BWIsFvUjPzcUNrlRSi5YytbuypWDfmq9w5XnJfcJUnTRqtcfTnuX6UUuvNEXznS4WQ2f+Prmm0Ri20Lp4DiN0SoBpi6GW9zRQkTV1J+JXSIK50t4Wir/rh0bzzX0s9mi9EVK9OMgehpzoJm8qRlkdQqA=
Received: from MN2PR06CA0023.namprd06.prod.outlook.com (2603:10b6:208:23d::28)
 by MW4PR12MB7335.namprd12.prod.outlook.com (2603:10b6:303:22b::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9499.7; Mon, 12 Jan
 2026 20:23:29 +0000
Received: from BL6PEPF0001AB51.namprd04.prod.outlook.com
 (2603:10b6:208:23d:cafe::a9) by MN2PR06CA0023.outlook.office365.com
 (2603:10b6:208:23d::28) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9499.7 via Frontend Transport; Mon,
 12 Jan 2026 20:23:16 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 BL6PEPF0001AB51.mail.protection.outlook.com (10.167.242.75) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9520.1 via Frontend Transport; Mon, 12 Jan 2026 20:23:29 +0000
Received: from ellora.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Mon, 12 Jan
 2026 14:23:28 -0600
From: "Pratik R. Sampat" <prsampat@amd.com>
To: <linux-mm@kvack.org>, <linux-coco@lists.linux.dev>, <x86@kernel.org>,
	<linux-kernel@vger.kernel.org>
CC: <tglx@linutronix.de>, <mingo@redhat.com>, <bp@alien8.de>,
	<dave.hansen@linux.intel.com>, <kas@kernel.org>, <ardb@kernel.org>,
	<akpm@linux-foundation.org>, <david@kernel.org>, <osalvador@suse.de>,
	<thomas.lendacky@amd.com>, <michael.roth@amd.com>, <prsampat@amd.com>
Subject: [PATCH v2 2/2] mm/memory_hotplug: Add support to unaccept memory after hot-remove
Date: Mon, 12 Jan 2026 14:23:00 -0600
Message-ID: <20260112202300.43546-3-prsampat@amd.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260112202300.43546-1-prsampat@amd.com>
References: <20260112202300.43546-1-prsampat@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: satlexmb07.amd.com (10.181.42.216) To satlexmb07.amd.com
 (10.181.42.216)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL6PEPF0001AB51:EE_|MW4PR12MB7335:EE_
X-MS-Office365-Filtering-Correlation-Id: 0df17122-aa16-4908-5c39-08de52187324
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|82310400026|36860700013|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?XoAImIZiVyJWBUARIxQ52LngzoKK62KwJ4xccsG2cUBXdYRqAArjnIVEU2eQ?=
 =?us-ascii?Q?hjD/zDYmRYDhM3KK4ZthJ6hVCNff7Y7HJQ5KZHLltwHO81EEK4vAMEO70Idh?=
 =?us-ascii?Q?X+RkClsU4nPlvbFXSjeKmK5p+wr5+2JjGKs7yg8ca5vLK7/znD/c4Li3uCGe?=
 =?us-ascii?Q?ZkN7Yl3TwRu+8RRCojRjR7uR4fDkuPj2DK0wGWN2PFOTWfFczDvEaZazk5yf?=
 =?us-ascii?Q?aQO6uneRukREadPMym3JYoZDP3u1Nub4uxFAmAwJ4vsWYReIUPq0M1Okse2r?=
 =?us-ascii?Q?aAtCaIYcXGBC2kKwXNiAtd+sRiWpO8piNYaDpD4RvyRQKX3If0GuTh3OvSod?=
 =?us-ascii?Q?+YiztD+I6vtF6hAyK3klFgrC97HS1m/J87ql+wkdQjLaGMwYFqXhbxXpTy1v?=
 =?us-ascii?Q?n77jDwpH7YXrt+489knyKcj8pii1OgBqxZlSFRBS68WpfsHBfDMjUU1OCKJb?=
 =?us-ascii?Q?u/h8goSU+Dn7WyW3eDtbqNG3nlUBFeggbgD9q/qeMZtqofKky+c4hm7L8JUs?=
 =?us-ascii?Q?Dj0nF7F1vojZbThH/OI5TGmKfTHzJ7C++52vt64Dybpodf8OGv07mZJ0tRF6?=
 =?us-ascii?Q?rrK9udvbkya8ooIHbdCxcwEUbfNCHDzlS57eNMySFwkn71tuDkyLhimVBB4l?=
 =?us-ascii?Q?7Pl2vWzkbo/grCiBm6eiMVpKo+dgi/S2fsdzNsVGjacPv6a47Ox0OuPbp+I+?=
 =?us-ascii?Q?8RDUF/vkdSbUKnP5wzPKzznTgHu8uphIl4SvyJ7FF3abqtN4qRx12ToK5Ven?=
 =?us-ascii?Q?uIxM3Y7kEaxRIuwvcwqmEY7P/qGWnRRUxKWNqqFhgmIc8zI+G/1fZW+OL/eC?=
 =?us-ascii?Q?MhUZmdNdrbmcYGKUP9FyAbBT3z/m24aojWdzx6Jx3hFeLXsUnb/XCrQy9GQh?=
 =?us-ascii?Q?+KF+A2TMqXBSA9HOWXfYywFw9Pc3FHv0PW1EfIwtbY26A21j7wwJkQCjxQPm?=
 =?us-ascii?Q?o4D+P/aF4V2kfjOrQaiLIvEcYDyP8uW4InTQvD99S2wpwa0ijf7Eh44TN/H6?=
 =?us-ascii?Q?U8vQDsjLzJ6joA3ZREwGuogjyteYRYvXv5P52OMMewd+0jZvk4xWmqtHhQmD?=
 =?us-ascii?Q?+STnZzfTmzU07mop8qRjup+tQWztA4s22HgvLMX8LUBQUIiIRxZfyVjNBp+L?=
 =?us-ascii?Q?lPyC1YIXZe4IDrY0B9XCxouKxCMGCa3AxzaZ4gpTx3Mm8VdiXbK/5tqwXXUx?=
 =?us-ascii?Q?m611Yn/0BMZ7XmjwwZ4RJZm8HFoRhPLcGH8zC4nnybuPlXLOCFl8Xcq1sFBs?=
 =?us-ascii?Q?WA9L6UAvw9aITOZqZtFFdY8c2h85Ekeja9AaEYvpovmoaewUbXPZvdaCqT/R?=
 =?us-ascii?Q?Avs9te29uG8nJ1nyATYQFsVvaP+d3b7TtDWZxNyxkCCRg3OOEhC+64B470BB?=
 =?us-ascii?Q?/nqAtGBK3dPs0WQgyIu6/GpBc2CKnUfx4UqVU8XigyGr8Ru6U+Ue6Fnp9eKs?=
 =?us-ascii?Q?yowrbRhlpl/s36g4sTA3ozSIQdnzLQmB/pchOLbLQ5PTy4tNL5xG1aowRWjb?=
 =?us-ascii?Q?mWJZvm+knbABnOuik/jTARYgxwUBHe0wycM55bi5xHrknQ5b5zYet460t+Pr?=
 =?us-ascii?Q?pQeDSAku+uJVyi/Mqa4=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(82310400026)(36860700013)(7416014)(376014);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jan 2026 20:23:29.7204
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 0df17122-aa16-4908-5c39-08de52187324
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL6PEPF0001AB51.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB7335
X-Rspamd-Queue-Id: 2A73380014
X-Rspamd-Server: rspam06
X-Stat-Signature: 3hk4gk1raju3owa8c6cypdr85384d38s
X-Rspam-User: 
X-HE-Tag: 1768249414-189241
X-HE-Meta: U2FsdGVkX1+2EhTLS+5ybiNskRthEhiJ6bEOzWjfDhGRAjfp5cVqO/b54GOAFRh/EOnLsedR+uPgm1XUSmzyKlD+yLM42FxaxMijUTs3/7w1IHddDPKbLLsqQiCTR6TPa3RSWTOcKwd7XKSzVTod4TTKxuVz8woBHBNd0+FKgS8Zx/D3ma7kjZk5grffrzJw2XRDM7bAGnE40vwDE1uQS39yRrzqysVuoD8JZ+kd82JOFTM6xTpC9D9hQAwmAAGIgSfvr4jIdqNeMXF3R53FXJyVZQPn8A3ZJlWZif1DHWGE0FbNhUwth+yAvgnTU+HyJs3Ie9Y9U4Js5gTmmVH3/3VKWKjinpYRSHKlQF3JH3N6JtCTimoPIfRHEclwswFvskYv55A/EHcPhAJABS/6hlkqRSrq7T94vArXvu1xdNcZ9UR5wFb4LIcFU+wLPmoZAmQ0EEJvCxvyF3CaE3/FGQUeU4dmJ2Tgwm3F5HfaDthlK0XTq0qHi3L1huxJs3lEogK6ITiQsdijxBEoScKN5nh8WfpcWUqgOogzAILrARqPZ2ZodPItaCs1icxwQK9oLSdkQ/K0Dkq1ZreX+Ts3xwE2HN85aVrlwjAJPOZeTcmXI1u7okbtV8ZSjGpsD7vuw3zkr5ZzjcizRzdESUOwK44z1JDk4LIRDdumvIqeReVGg7qszZNnnTqCmcZtyErNRj0S/93p1Gh9YisC9lDGiCyAc3o4sAgGjz0V7p57FVaOa6sJTazKNpIFCz/JGIsq+pUOnWKVM0J/tc+o+MJ64v7EYy57AWremCUlrbPgPhnfSZrDbt7gUjYGaC2roS/8/kZXHWhhDnd0i4iGvahs0raNszUQ1DDTtCtmKq4TrIkd0DFlg8RUwmcmQtQpsM0J5pqNVaG4mRuLtXXlTsYRXvwuP/p2W1N2p2HoC0m6CcUa0T/S7bDJw8imbEIyB9idwpxxPnDjidsuQ3p5jFx
 S0Nizsr9
 gqaZj+X08KuZpdeBrvBDCFFbCSbdGxs5ls6OVCBMji3RHn1C8NyWBnbXb4sb1+92YLUc4QN/mCVnOVnVd6C6l1Yj3wlSPUGjKgIxk4aXEk+t47re+D9KTHlHZRCigM/RMPyMkwQ20NcKUFPw0w0nuY+jp0axVPoYIEBvm2T6aztha7w2eOn3DVk4chYkU41Iips2edv3p4FD3Vx+eawI19tvOhs+MSVA0Jtcd11vr3QKRyQCG6UFgst3sjKFIBD6OGBSL9UB/kQeJeUr5vgwJ1tF0eztfjPC2mysIQZC5Lh+wPZSs3UlsM46Vh6HCqj/xVyOU8uAQYmI4OWQEfWqFt6NYU3XE/uZoyxKqGJLyXPbCStc7Nw/4NlO/LQHPUIDn5Ugcv09jT55JO26uf2zydJsLGK6tJ/8d/OQYLepPlsM2snXiSzDab/LmHMufFx9AmLP72c9X8Ltrcin8PMQoVbkdcwHL1d/V6Z/DLCJc+oV8NwJeBBai6PXE63wlXVutRzmq8tzThstmycaT5J45m9a7e5RPoeb5X1CknBMEMTVZF5ycAUUIQzVpqhbLaJ9rGk6ARE7DRFnMIcEFPaDWWAmwDUYRU1ErHGvrRLtHLW5IWw4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Transition memory to the shared state during a hot-remove operation so
that it can be re-used by the hypervisor. This also applies when memory
is intended to be hotplugged back in later, as those pages will need to
be re-accepted after crossing the trust boundary.

Signed-off-by: Pratik R. Sampat <prsampat@amd.com>
---
 arch/x86/coco/sev/core.c                 | 13 +++++++++++++
 arch/x86/include/asm/sev.h               |  2 ++
 arch/x86/include/asm/unaccepted_memory.h |  9 +++++++++
 mm/memory_hotplug.c                      |  3 +++
 4 files changed, 27 insertions(+)

diff --git a/arch/x86/coco/sev/core.c b/arch/x86/coco/sev/core.c
index 9ae3b11754e6..63d8f44b76eb 100644
--- a/arch/x86/coco/sev/core.c
+++ b/arch/x86/coco/sev/core.c
@@ -703,6 +703,19 @@ void snp_accept_memory(phys_addr_t start, phys_addr_t end)
 	set_pages_state(vaddr, npages, SNP_PAGE_STATE_PRIVATE);
 }
 
+void snp_unaccept_memory(phys_addr_t start, phys_addr_t end)
+{
+	unsigned long vaddr, npages;
+
+	if (!cc_platform_has(CC_ATTR_GUEST_SEV_SNP))
+		return;
+
+	vaddr = (unsigned long)__va(start);
+	npages = (end - start) >> PAGE_SHIFT;
+
+	set_pages_state(vaddr, npages, SNP_PAGE_STATE_SHARED);
+}
+
 static int vmgexit_ap_control(u64 event, struct sev_es_save_area *vmsa, u32 apic_id)
 {
 	bool create = event != SVM_VMGEXIT_AP_DESTROY;
diff --git a/arch/x86/include/asm/sev.h b/arch/x86/include/asm/sev.h
index 0e6c0940100f..3327de663793 100644
--- a/arch/x86/include/asm/sev.h
+++ b/arch/x86/include/asm/sev.h
@@ -514,6 +514,7 @@ bool snp_init(struct boot_params *bp);
 void snp_dmi_setup(void);
 int snp_issue_svsm_attest_req(u64 call_id, struct svsm_call *call, struct svsm_attest_call *input);
 void snp_accept_memory(phys_addr_t start, phys_addr_t end);
+void snp_unaccept_memory(phys_addr_t start, phys_addr_t end);
 u64 snp_get_unsupported_features(u64 status);
 u64 sev_get_status(void);
 void sev_show_status(void);
@@ -623,6 +624,7 @@ static inline int snp_issue_svsm_attest_req(u64 call_id, struct svsm_call *call,
 	return -ENOTTY;
 }
 static inline void snp_accept_memory(phys_addr_t start, phys_addr_t end) { }
+static inline void snp_unaccept_memory(phys_addr_t start, phys_addr_t end) { }
 static inline u64 snp_get_unsupported_features(u64 status) { return 0; }
 static inline u64 sev_get_status(void) { return 0; }
 static inline void sev_show_status(void) { }
diff --git a/arch/x86/include/asm/unaccepted_memory.h b/arch/x86/include/asm/unaccepted_memory.h
index f5937e9866ac..8715be843e65 100644
--- a/arch/x86/include/asm/unaccepted_memory.h
+++ b/arch/x86/include/asm/unaccepted_memory.h
@@ -18,6 +18,15 @@ static inline void arch_accept_memory(phys_addr_t start, phys_addr_t end)
 	}
 }
 
+static inline void arch_unaccept_memory(phys_addr_t start, phys_addr_t end)
+{
+	if (cc_platform_has(CC_ATTR_GUEST_SEV_SNP)) {
+		snp_unaccept_memory(start, end);
+	} else {
+		panic("Cannot unaccept memory: unknown platform\n");
+	}
+}
+
 static inline struct efi_unaccepted_memory *efi_get_unaccepted_table(void)
 {
 	if (efi.unaccepted == EFI_INVALID_TABLE_ADDR)
diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
index 8cfbf0541430..718f729cf687 100644
--- a/mm/memory_hotplug.c
+++ b/mm/memory_hotplug.c
@@ -2242,6 +2242,9 @@ static int try_remove_memory(u64 start, u64 size)
 
 	mem_hotplug_begin();
 
+	if (IS_ENABLED(CONFIG_UNACCEPTED_MEMORY))
+		arch_unaccept_memory(start, start + size);
+
 	rc = memory_blocks_have_altmaps(start, size);
 	if (rc < 0) {
 		mem_hotplug_done();
-- 
2.52.0


