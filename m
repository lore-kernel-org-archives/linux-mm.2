Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9825DD1D47D
	for <linux-mm@archiver.kernel.org>; Thu,  8 Jan 2026 15:36:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EE75D6B0088; Thu,  8 Jan 2026 10:36:20 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E94D76B0093; Thu,  8 Jan 2026 10:36:20 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D69356B0095; Thu,  8 Jan 2026 10:36:20 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id C42C16B0088
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 10:36:20 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 8E721160207
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 15:36:20 +0000 (UTC)
X-FDA: 84309198120.04.0433D94
Received: from PH8PR06CU001.outbound.protection.outlook.com (mail-westus3azon11012037.outbound.protection.outlook.com [40.107.209.37])
	by imf26.hostedemail.com (Postfix) with ESMTP id AD8A7140008
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 15:36:17 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=XmdxSfG6;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf26.hostedemail.com: domain of ankita@nvidia.com designates 40.107.209.37 as permitted sender) smtp.mailfrom=ankita@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767886578;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=3NeimiKEaWKBODPAhOJjp9hW8Wh4xaO+QWH7ytv/Kw8=;
	b=AraF8F+94dMYTEbzMTmDEkfQTCjqU42T3mXlNU6SvXNqK3F0t5iOqYRd2qAu1OApmfxgq6
	ipBA4UwnvecRzxJd41G2J08fLM5ZQNqUyAchVzhF7hhHCwhL/q6uXTJVKfU6bbmq166BI5
	0JpnvsKqJk1s+OGNNDQD5d6L1caER58=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1767886578; a=rsa-sha256;
	cv=pass;
	b=E3oghhDc/g5KfZ49ipDcYees4VhJEJU+SmKWiVnTUZkD8fyvcBoTl+pIuIOcDP9oO+fvQh
	LomlnzlYtgOCNEGmzTVK2BQeh/KcKvnplhkwpzTlJBGtVJOrz0tHCQsn/9zZUQuzTTdgL7
	lBibaHfS9M+/GfuYrzpO14Djc3+jnBg=
ARC-Authentication-Results: i=2;
	imf26.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=XmdxSfG6;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf26.hostedemail.com: domain of ankita@nvidia.com designates 40.107.209.37 as permitted sender) smtp.mailfrom=ankita@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=v4z1JF7na9aMkgwb0WWtXh5Ai69J5m85RLFIdNFCeytH1ZK450ZbmAXjtXFg2Ijn2RqwzhsE7lElejSCIF/fiyZTCaIl5/o4MF8Kj2sNUMMvSShntzr0aZTKsQItOBe6AIema/IQCQxB59Fa+E+EqwqzaZvq2X34oCtvSCPuLbwWm+LT8kqN/zbLE2iqxFei2Zjwkv2EOBd6CPm3nOAMlRG2xB13QH/C9e8DGRLn0P8gfirpK3eA+lmogDwazgyfRiD1V8XCg/2dVa1xvFbwOiIVsFbYTbic075/mTNzcG2QYZwN5azCUpCOj+QMnSV4CdHCCEC9UOJr6wwelMKg1A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3NeimiKEaWKBODPAhOJjp9hW8Wh4xaO+QWH7ytv/Kw8=;
 b=FdWx0w9dpy3QKu0MVre8GprQJ0qWCTyugvgVdTnX2P+uY6h4o4snTD+ugjNgq4Meia8rO7dRFcy0O43RSiEzcsRNG0njI1KeodQ5VVc1kXwuJgWxj8Di2rLFCNAo2Jq6fNJl9McQy7ezf0UdzYg95z+ZdcyUBUdHqhfR+JcackIa5NxkWfyPtpIKETqtkmNU77uuNK+kiW7VOyWzNcUmsJBJWwhyrb+EoudESW7AT8m9Licar3OqKqpvxk4XAcKGUInF2O/ccPr5eUKUMa4sj17egZU89e7h4AjANKjpKH4sfzzfcbwPRrFSWNMrVTSGh+RTBS+vfwmV3dwqSMsQig==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3NeimiKEaWKBODPAhOJjp9hW8Wh4xaO+QWH7ytv/Kw8=;
 b=XmdxSfG6aKHZXNaPRhr92IKdBPYsoxCcGA7/0oqWsL5jTmPY3goh/ubj3FF6v/Nlf94DK98qgB2kl2+9HFxTJG0JaBJO7XZJNBxpNLIKPq7Xn65Atm8cNL7RoG6biZA7FbTQsQCSBneFnXCY+AxFm8A4AQNOEX0kClTteJtXhALv4QrUX+9ms0JPBBMa4Csfoq0axkIpLpEj68FkdHgqKZFouYw9dBf20cLi4xdjnAk1D0HWp0/nquQ1sKgYKOIlgRes3DnZmH1VzQviKU+ezUWuwg45J+iI5TUiPOeDOT5YrQBnbRqxfV+/fMPWd3vy07u2ZCDnx0rET7m3AFAAtw==
Received: from SJ0PR05CA0054.namprd05.prod.outlook.com (2603:10b6:a03:33f::29)
 by IA0PR12MB8905.namprd12.prod.outlook.com (2603:10b6:208:484::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9478.4; Thu, 8 Jan
 2026 15:36:10 +0000
Received: from SJ1PEPF00001CE8.namprd03.prod.outlook.com
 (2603:10b6:a03:33f:cafe::4c) by SJ0PR05CA0054.outlook.office365.com
 (2603:10b6:a03:33f::29) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9499.1 via Frontend Transport; Thu, 8
 Jan 2026 15:36:09 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 SJ1PEPF00001CE8.mail.protection.outlook.com (10.167.242.24) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9520.1 via Frontend Transport; Thu, 8 Jan 2026 15:36:09 +0000
Received: from rnnvmail205.nvidia.com (10.129.68.10) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Thu, 8 Jan
 2026 07:35:49 -0800
Received: from rnnvmail203.nvidia.com (10.129.68.9) by rnnvmail205.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Thu, 8 Jan
 2026 07:35:49 -0800
Received: from localhost.nvidia.com (10.127.8.12) by mail.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20 via Frontend
 Transport; Thu, 8 Jan 2026 07:35:49 -0800
From: <ankita@nvidia.com>
To: <ankita@nvidia.com>, <vsethi@nvidia.com>, <jgg@nvidia.com>,
	<mochs@nvidia.com>, <jgg@ziepe.ca>, <skolothumtho@nvidia.com>,
	<alex@shazbot.org>, <linmiaohe@huawei.com>, <nao.horiguchi@gmail.com>
CC: <cjia@nvidia.com>, <zhiw@nvidia.com>, <kjaju@nvidia.com>,
	<yishaih@nvidia.com>, <kevin.tian@intel.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>
Subject: [PATCH v1 0/2] Register device memory for poison handling
Date: Thu, 8 Jan 2026 15:35:46 +0000
Message-ID: <20260108153548.7386-1-ankita@nvidia.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PEPF00001CE8:EE_|IA0PR12MB8905:EE_
X-MS-Office365-Filtering-Correlation-Id: 490cb19a-a7e5-4ec3-4434-08de4ecba5c3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|376014|82310400026|1800799024|13003099007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?VYFLA3+MugzL0fFErz/U5ONDrx4HGzyXWpjncMQ9OYgkBU6NfTGRazbtEEzD?=
 =?us-ascii?Q?JgU6wlFBf0b4drr2jW1O9NfLlgTKF9vfXVQcEOobwlpYITgAC7s7lZCh/edc?=
 =?us-ascii?Q?mwjIdjMnblD+XhPnt4I3t/4FzD2alwcj1sT8iXK1y4tO1cjtLhTV9DPMCII2?=
 =?us-ascii?Q?pZD+oWv+zxfww8V/NtgLK3Og/G1mc9yivgSa+hfUIcKgg2R8Y5CINwRDz0wr?=
 =?us-ascii?Q?NDogx86mnQNvgbrMgk7DWZCGi6lrrVpv8ga0R8pr4lez5CsLHvln9w1qETi4?=
 =?us-ascii?Q?TTkdmuK9Iac1/U0w+QDLchuUKJYmlHaOut4wFI1A5CGKv2nn7Nup19ASmaDj?=
 =?us-ascii?Q?Mm7e2XOAZR+MKic3k4cHyekDGSblZd5pdDzo51QGHI0TNRNlgchowgmM4gU0?=
 =?us-ascii?Q?I2Th7scjbXFyPDFmgI5qAR4C5+r+tjjo49CZVntcjtPKgAgn8ESbXL2dNCpV?=
 =?us-ascii?Q?nWNchJsra+cCPUSYD+A5syg8/31QxQahCpMbQNwOGBQcTkmQB1CBofLjvr+E?=
 =?us-ascii?Q?oFgTVLtc/hEY5forB85iI/N12dQWhgmKgrwwBOWJe0mzafJLM8pTN384UqIx?=
 =?us-ascii?Q?VTQ0ZzAS6IUiClUkkibJfZCKde/sPXDfLApdr7NsCjQskPkIRXR4Y8gMYohN?=
 =?us-ascii?Q?UkCs8xTY2PK51SpoXVEH+cZPFmR3aqbE3qyVP7HcR3i8gX0Be/wVF43PbMrb?=
 =?us-ascii?Q?TquzfgHQZYJjGV9fuPPgGpLL+nbV3x8O9BzkwuApNivsyWqyjX9rl5xxkbMm?=
 =?us-ascii?Q?/tp55Egm0FhYW1aK4IVF+A/bDScfFpIovQnJCyMmCYLr2wYh7XrscoCtFb+1?=
 =?us-ascii?Q?eOltc3thaQXWr57PbNbWp5KBnAjpj8aW3G9Qb6oV+72ON7U5xPs2N/3fMyu4?=
 =?us-ascii?Q?NLGfv8D0FV14yGaZJj81Ll3nSQF/WTt+xzrynpmzXjw8TKo6z+G8qVAL2oSt?=
 =?us-ascii?Q?lMqZKGBOojrx3bvbBCGUqebqAbldOHDfC85fLQt/6MYeFDwQtD/p4yyj+zla?=
 =?us-ascii?Q?5isAGGlxa7qaUazOKrWqRKTHhNqhO+oUJCpqsL5OuNjlzcIiB6PKb0Zez7qn?=
 =?us-ascii?Q?BCL+Bt6Ia+F1R8UnwPkfN3LCngrD7NPm3NiKfEz8a6v8rnUYF4Il+hEJF7og?=
 =?us-ascii?Q?pkvv+c9hYoTz4Lewb8p747bC5uRnt3OTtRNtH2ocqNWfQULrnC5i/+waAxK0?=
 =?us-ascii?Q?ZnsHt9W7dpNAZ3Z19NFJsfV+ytfyITX9XrXcHa/wr7WIoiL9vvrHVA6ZWTut?=
 =?us-ascii?Q?OE7yNUMzou9aO1hUzLeXgLUytZJb36RS6j5u936yDjxRgi3drT88YKCCD+eG?=
 =?us-ascii?Q?F4m0a7bHj3vlYD7Zk9Rj91h6NFe0zfVTVZZsUMzqqjyo++uqXntTcCj9Gw4X?=
 =?us-ascii?Q?Y4YWnsJA99212XMFFhrmRaotkIJwtTW+AeB2EB7aDGTo/85Af8lNzfTM69bO?=
 =?us-ascii?Q?r+e5Zdj3Yhlf6G38nKdnWy8/WjztAdK3ari2MZwUMMS+Lw16H4zh31zDIRxe?=
 =?us-ascii?Q?ubeeRNuRtD24MurQq0aAy5kLaPCJme8nP0RgSf5revXNTfeyNucvlJzu/fjG?=
 =?us-ascii?Q?CW5NxpK7k9DRPrWPEhM=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(36860700013)(376014)(82310400026)(1800799024)(13003099007);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jan 2026 15:36:09.9110
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 490cb19a-a7e5-4ec3-4434-08de4ecba5c3
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF00001CE8.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR12MB8905
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: AD8A7140008
X-Stat-Signature: apddur73pqc7e851fhjctwx557bxt4g7
X-HE-Tag: 1767886577-825280
X-HE-Meta: U2FsdGVkX18fK++aeTXZXJicoCWl3vtQVO5umN6JlvC0Adjwps3JG3/wRpp6KYKeTVuoSNFkVgx4ieBQlp+xvqbF5v4ctavutV2uRdNHujWlCgjNo+NukhGTeCKH4ieqTaHYyIh7fTbRSYaHas3xkqNhmnIzkUkjKc/49dEQDsTg9ZBmcIv6FjWT/W2gkEcxUYTpOUJhQiD3CvRIYqC9xdZjVeU/KehVOjdEOQ7Z4wy/XJ7/SGlrAsQ6ItWM+O+vE9cZ5vd2C8NmIAu9sucOQn0KJDZ0Q5t/9fR8Uw6ADf9dvYmJ1oDhEEnDW9Ovy34/T3pxp4W8NNuZ8XnWCQ+duNCLJyuf8a8SpomnI+HIL4vp9Jk/VwRhu622ugwea/NXcXDZpQtKP/XG9byZ03dvKJvb+dgpCCMXdoYP9gKWlwwF321+ryKuxbMW8z/Y+O1Hl7V6ZSy9oY1GvgrIJNmhLDrFBihIdlpWF3zQ95PWnyi5I+AEJEG4G7TgAqCvpnXZv0ngzxmxdcYRuRYtVh1VzNlcAyltycGKCSaNIzP5hjNZHXQOaMdtyv+Anfl1Wg/Kjt9Yk/AFf+02J+JUbJlASDxOTsSEtUvDtohvU1KUATz7oVyL10JWMJx59395YkP1yE/eSJvqsz0GjB0WEFDMP++4DX28zXQtOT7xlwv+MpFfkf2Z1WZfVlx8M7twocx/DDxomi0tcpCRen3K6meXLXu3DpKb/PYfpUD/vAr2opny0Q4OwhpAU6DtqfbuDkUpywVFcpn/xLLbn3ApxHMsLRXYB9ivFjfMI45/neIXxK9hbYA/L7RhV4XyDZ0b8Tj9jvXaWSLjBfuwMWyRVY+Xlo86wnwtci4dE8YUFHYuNV5OlSSTJPYbpxa/+lDEKFmJ6oluAfq+SerBzABhWlpdS2JCb8beVzEV+EucR9x6u0Cjiy0pJxxCAuU9XMKm8BBFABtccXWYdSboJJEZJIO
 r0elNuta
 FSoklZmATLKCIEwJC9vvH4hhfqbuUPiFgW6oH
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Ankit Agrawal <ankita@nvidia.com>

Linux MM provides interfaces to allow a driver to [un]register device
memory not backed by struct page for poison handling through
memory_failure.

The device memory on NVIDIA Grace based systems are not added to the
kernel and are not backed by struct pages. So nvgrace-gpu module
which manages the device memory can make use of these interfaces to
get the benefit of poison handling. Make nvgrace-gpu register the device
memory with the MM on open.

Moreover, the stubs are added to accommodate for CONFIG_MEMORY_FAILURE
being disabled.

Patch 1/2 introduces stubs for CONFIG_MEMORY_FAILURE disabled.
Patch 2/2 registers the device memory at the time of open instead of mmap.

Note that this is a reposting of an earlier series [1] which is partly
(patch 1/3) merged to v6.19-rc4. This one addresses the leftover patching.
Many thanks to Jason Gunthorpe (jgg@nvidia.com) and Alex Williamson
(alex@shazbot.org) for valuable suggestions.

Link: https://lore.kernel.org/all/20251213044708.3610-1-ankita@nvidia.com/ [1]

Ankit Agrawal (2):
  mm: add stubs for PFNMAP memory failure registration functions
  vfio/nvgrace-gpu: register device memory for poison handling

 drivers/vfio/pci/nvgrace-gpu/main.c | 116 +++++++++++++++++++++++++++-
 include/linux/memory-failure.h      |  13 +++-
 2 files changed, 123 insertions(+), 6 deletions(-)

-- 
2.34.1


