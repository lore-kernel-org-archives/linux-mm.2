Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 96B6C606A32E
	for <linux-mm@archiver.kernel.org>; Tue,  3 Nov 2026 16:25:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=amd.com header.i=@amd.com header.a=rsa-sha256 header.s=selector1 header.b=GmZ7NBHh
Received: by kanga.kvack.org (Postfix)
	id B07016B05B2; Tue,  3 Nov 2026 11:25:22 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ADEF36B05BD; Tue,  3 Nov 2026 11:25:22 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9F4296B05BE; Tue,  3 Nov 2026 11:25:22 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 797156B05B2
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 11:25:22 -0500 (EST)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 174E41604B1
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 16:25:22 +0000 (UTC)
X-FDA: 85394332884.06.DD41C45
Received: from BN8PR05CU002.outbound.protection.outlook.com (mail-eastus2azon11011020.outbound.protection.outlook.com [52.101.57.20])
	by imf17.hostedemail.com (Postfix) with ESMTP id E52C340005
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 16:25:18 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=GmZ7NBHh;
	spf=pass (imf17.hostedemail.com: domain of radhey.shyam.pandey@amd.com designates 52.101.57.20 as permitted sender) smtp.mailfrom=radhey.shyam.pandey@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793723119;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2/zq8nI54thIjHywswAXZQZjDPR3ylqQd0E9IUHe/2Q=;
	b=uWTpIrdO+zCC9vzYMc0VZ4UsuqvQsfj2EFm5AGbnozVgratR0a6Yl0a9W/dfCIKCVamogy
	YCM931D54gT/gDYA8ZxCn0oGT9HcIImiN/aCC++rQ9lwD1nT1WG3s9L309/SaCzZqE/SWd
	ktTfW4DXm88OvxE8NkWnWkh5m31iFLg=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1793723119;
	b=Iq71dZM3McvltgY3Nzu7XDChCJ3ZWBZzetOpJBVaTtypwC0nGDJqCeh3pdsQwUfWs3ym3A
	ID88kZIpijt3UmlXO/93R1J3YxCbr6r8ijqI95HCRc+JYELBUEa/iauzTFcbGJ7UVL5KWU
	Q7rFb9WScgP1RTrBzPCYY6cMUhxOEVs=
ARC-Authentication-Results: i=2;
	imf17.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=GmZ7NBHh;
	spf=pass (imf17.hostedemail.com: domain of radhey.shyam.pandey@amd.com designates 52.101.57.20 as permitted sender) smtp.mailfrom=radhey.shyam.pandey@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ndYS55akVlGbGtlPhYdP0cnL4kh9L6uXiYdxhFKWoKehtjJIP/VJvTqHt0uOXJtka2xQeUCqKDlNCCRnE3GM3yi2B2NTl3L+JDhY36EgXI6XniSDNKf+3gmo9IbIyKZBF7ReL3WL/yMV/2dnjhlCRJsKUaghtzSTQ3eg3hBkw+3im8yHz707wv6hfUpcrx/dQe6AWatez+dHiYdpVG3EnLRULBuSL9D24/E4uXrbQ+qkoQQu1PPpY4b5A2zLt9Ml43CLyAMk+GvqA4QjzMR7TQl0rwwxse9lMFkKCwqVbgS0m6uYoS3a1MHpIN9HlnobsQcBhRdrHLkKEeD3l3gKcQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2/zq8nI54thIjHywswAXZQZjDPR3ylqQd0E9IUHe/2Q=;
 b=vwiz8eYIPxUmxsicaLNzzF87z9tf/y1jvOfBKOOAeZeuDsJe5B9CxZKqckJwk1Nu4OHgcywXlpppty7AhGxTBaVKDA4LpWOKk3Jsg2bY8mbofgssEJBUnvM0nzJgW4s0tfUNsoUib97eIktz7fm/te2Esi6v8P7IqUQ43QLJmcLo/ICXAo7/IK2yGSc6c1ZRk8QxK5KHcybtlS6gLMTVhb0gCPuNfR0zKociUQHsuzD1PCIigVEyvH4JujGrlgAYoBJzgPLwiHr8/azmj5uWqKtGBL6bGEXBCFMRNatbcjguOHsAg0XioSI0W5V+qLHizQhEm183ufNP1d35kEHvrg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2/zq8nI54thIjHywswAXZQZjDPR3ylqQd0E9IUHe/2Q=;
 b=GmZ7NBHhZPAPr6rbrBKhtzM3LWVxuj3B0wnE9GIXAEPHhf0nvdutiGSKS5wgUQoMc9DEG948EIYAqQQuMfS4UEoQHuZWSctw9cY7z+AAyrSeHUkd4NbHwadj6p0AwB2HvhByXMJEqC5wNW3nX/WiHhnt7lSwH37dsJT3d8pP0v0=
Received: from DS7PR03CA0157.namprd03.prod.outlook.com (2603:10b6:5:3b2::12)
 by DS5PR12MB238689.namprd12.prod.outlook.com (2603:10b6:8:47e::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.592.8; Tue, 3 Nov 2026
 16:25:15 +0000
Received: from BL2PEPF000352D6.namprd02.prod.outlook.com
 (2603:10b6:5:3b2:cafe::82) by DS7PR03CA0157.outlook.office365.com
 (2603:10b6:5:3b2::12) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.592.8 via Frontend Transport; Tue, 3
 Nov 2026 16:25:15 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 165.204.84.17) smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb08.amd.com; pr=C
Received: from satlexmb08.amd.com (165.204.84.17) by
 BL2PEPF000352D6.mail.protection.outlook.com (10.167.254.6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.592.5 via Frontend Transport; Tue, 3 Nov 2026 16:25:15 +0000
Received: from Satlexmb09.amd.com (10.181.42.218) by satlexmb08.amd.com
 (10.181.42.217) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.53; Tue, 3 Nov
 2026 10:25:03 -0600
Received: from satlexmb08.amd.com (10.181.42.217) by satlexmb09.amd.com
 (10.181.42.218) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.53; Tue, 3 Nov
 2026 10:25:03 -0600
Received: from xhdradheys41.xilinx.com (10.180.168.240) by satlexmb08.amd.com
 (10.181.42.217) with Microsoft SMTP Server id 15.2.2562.53 via Frontend
 Transport; Tue, 3 Nov 2026 10:24:57 -0600
From: Radhey Shyam Pandey <radhey.shyam.pandey@amd.com>
To: <robh@kernel.org>, <saravanak@kernel.org>, <akpm@linux-foundation.org>,
	<david@kernel.org>, <ljs@kernel.org>, <liam@infradead.org>,
	<vbabka@kernel.org>, <rppt@kernel.org>, <surenb@google.com>,
	<mhocko@suse.com>, <m.szyprowski@samsung.com>, <robin.murphy@arm.com>,
	<baoquan.he@linux.dev>, <pasha.tatashin@soleen.com>, <pratyush@kernel.org>
CC: <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-mm@kvack.org>, <iommu@lists.linux.dev>, <kexec@lists.infradead.org>,
	Radhey Shyam Pandey <radhey.shyam.pandey@amd.com>
Subject: [PATCH 3/4] mm/cma: reject CMA areas that overlap the kernel image
Date: Tue, 3 Nov 2026 21:54:28 +0530
Message-ID: <20261103162429.2053989-4-radhey.shyam.pandey@amd.com>
X-Mailer: git-send-email 2.44.4
In-Reply-To: <20261103162429.2053989-1-radhey.shyam.pandey@amd.com>
References: <20261103162429.2053989-1-radhey.shyam.pandey@amd.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL2PEPF000352D6:EE_|DS5PR12MB238689:EE_
X-MS-Office365-Filtering-Correlation-Id: 1c2ebe28-7cf7-45d7-8a45-08df39c70ade
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|36860700016|7416014|376014|23010399003|1800799024|10067099003|22082099003|18002099003|921020|56012099006|11063799006|261022075727099003|261021121427099003|261022115727099003|261102123227099003|261009223027099003;
X-Microsoft-Antispam-Message-Info:
	KqPQi62F6cg5CHqtNwHl7ZDubPkM5oJnriYQ1Y5nx//8QS3LkZ9Z1zCOP8YW4vUnvVwPLSbcAs8V5elFtF8OtAVHzkwc6DpUALKoBXpc6fIyCnWUkzTr3j3hF0mibV2ZR71nds+y+5vTJxyiTBxVS3BfFxfw8bOn6L43eWAS+KoEO5YTbixTx52+nkdnrKif4MVKRIwks+oY3oGTbSk/gWGqB/eUZaCPWHRMRWyWHSJl/mJBtxnHH1GzexeW66WkBwFev4RJtUc2CL/phO/wxt1ImllvLBFsspqRl1ZsBzWnZohiwaPIl9pIBJQ2Q+nOJHhSJHYxHv7anYouhmOpwjlbV/y/kl0j6Fn271yzoWFfeta3Q8HjpSe+LA6LA9iNuBEMGpfCeVYJRXJkorpIepvdjBRstIi5zvGs9RTqM/w+SxK8X2A/MWYLDw0SvG8jL2xzBa+h+59LKFUyjuyKr3mEGoN/PC40hviPl40eQf/FZ7WGAPqCkhcHqx0nbzFVjMsZA4ByUol7Mk7I5Z8poADDuvFCmIEBgJXVj0qw3bYGGeMCcm9Q3KtWzj8CGc8Uaa00oUYcb40HrKmLsB7JYk3H9pHBpwmOT+ZyQmzS7EM7k3yzDbP4X8M9DmYN6G4LaoNlG7XZ9qnty6KAPN6xtYfdKWG121RowewQRSyKEAiVpc1nBHlo//mEhcWMuP0eCW+uNqm2nyeSN2eViYdOg2PYo0GDXikuZOuG4gkiaVsDaAz++2jMfPUA56+oZpuS
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb08.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(36860700016)(7416014)(376014)(23010399003)(1800799024)(10067099003)(22082099003)(18002099003)(921020)(56012099006)(11063799006)(261022075727099003)(261021121427099003)(261022115727099003)(261102123227099003)(261009223027099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	Y08yYOoCWs19fuyoPFv9dureeY+xsdyM3gkI56KYEgqzjUjcWoXdOjpqPOeQRknLWCwdHQTtHGTIA4GvJJlyy/vXP3If9ym6ZQ00FgBS1dpFJLjKvwNX63cJEQ034fee89rWFCuZHRxiVViyUGG7ouUD4yyLg3S0BmGpM8ofpzTcKrQmoL6bAZ9Fowjrysbkqi+Oa9RyudDbaIfvwew4FDHZ2LGFKAOqBpKXRyF846zHaky54a5sNzw+ko+HOHhzV/7o4ZGdDsLywSt5qvXsy3vUq9C5X55lSHTo+sCq79P+VtYoY9xlbmxaAb36+8KA0lqVx/mWqQGl7CbrRcmqZG+majukTfNb6oX/un4FbQtmmnpih02PxbnCIj7tlpbuEQDTdeqQpOldE1E8iNLauXtxwsGZwVJXcM2rTO1d9JPb/XtdntfAA9oKauiD5eR1
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Nov 2026 16:25:15.3088
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 1c2ebe28-7cf7-45d7-8a45-08df39c70ade
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb08.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL2PEPF000352D6.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS5PR12MB238689
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: E52C340005
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: orp3gwwqpj1geeaz8ucccxjmx65swafc
X-Rspam-User: 
X-HE-Tag: 1793723118-883007
X-HE-Meta: U2FsdGVkX1/H3PJ/Y1Mq/ieozlp2FtEfaqd+Mvh9X7gTUmtQpPejZl8K+U7ukSmc9ns9V1sp35NmhY4PW70HhjItZZwGI85MCn3x9TQLZpGkCccSu+BF1boRBoIhAKaZgfoDQGwC53uYUTbGMJxTq5kidPzJ8ujqVXWpfgOHtMrBuxadpivABjgkgnInlEP93qYOY5EFgBwLKP0u7vZVxR4BBoE+9759Cu+3r0soBGOe+ZfOZS2aMKbk2/dPs8AZCY7oz93NKkgno9vBCSgZ7qItLXlQjPd0ueIC0M5geAZCukMdRDYIv5IwAL1ysiAoqYf1lUu0rsA0gejkbKld7QEPg9eodh2zS8UdaJ4am88kp244r/ABEw9rdyXW1/R3Pq6xibgPjRzwAUVxhnNrAYgP6+0dslbWxdYIGbGkIGuUuit99z5jKe21hJX4vbAmM6SalYcQ88YfOfVy++sKAZ7rAiwSCRIuwkMEYrnNQ3SWa4qRBX4U+pStSmzqOX9yai4J9CiVTWA6vu6BdnJucVKr9QZ3P/uFT5UsZa2u2I3hudU/TLXhnDlVbREJvdA4KvcCuED8S41Ayc8i0n37OWfPd3WQ8+ZK2rkXnW2L2sqRClEOJ+DfWa1hVf1aQ7zc7sEVKSF390QXKW5+qReqKygxE1YmAPdK0gXMaCiF/+5dzE7dXTumpXbOGdpCz9n3wWTKV0+9HfANoVYCElDrWwHf0mrOVJ3m5NS3reM0mYCSjyyjNr16lZDUn09yFV8jE5CykAsqsPBhDB6ATLuQ8OGnetpdYtlNuGOBcIwXcGBNZIwQ+IVFtkBTFAV9MUvMSlMQp8mtfVDUCX+gJ5YMNpXkHWknpryR+5KdrkCmWYZksFQIKETcVlGLk6fiEJOMb9v76VktjGAoxj8TRLRuk1GzY2QAGqRNPOLbmUphawS5uh7eEfOFybTAriv8bRfiVxvgUkwKUKy1wjl8KZu
 OZiuRlli
 Oq+brFpNkLV0HsFkKzMwUiiCsbN8iDy4CXO5C3jzLGpuUis5Gy5VmQwwEfEknRmABV3zsqPkHdNMSB/pW9oif00ncAOE1Y/OsaSmakS0O1Y+sA+J/aDey3gkb90u1HxIMIQHOMJFXHOiU5NeOLmLx9oD98VD87PmHKC6V2Fj4K2wykrRNfhF9KD+oA9m5y2Jv7JB9jw2vB6oKcoPY1gmx+xtvzJarLXIi7TIM14lqGDwVCfLQsKmznuGQ+e2OW3uILATR2Nt1VrRmU0hT3sdj0hoAXUiTep8lJ3UPXJM3TgFmAIlz07sUOb4xRWCg2D3tGR14UdCSRM3kF72C/klAaT4etBpcqa/m7KRg
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

cma_init_reserved_mem() takes a base chosen by its caller and only requires
that the range already be reserved, so an overlap with the kernel image is
indistinguishable from the normal case. cma_activate_area() then clears
PageReserved on those pages and frees them into MIGRATE_CMA, overriding the
memblock_reserve() of [_text, _end), so live kernel text reaches userspace.
kexec reached this until the fix this series builds on; a device tree
placing a shared-dma-pool over where the bootloader loaded the kernel still
can. Reject the overlap rather than let such a caller corrupt the kernel.

Signed-off-by: Radhey Shyam Pandey <radhey.shyam.pandey@amd.com>
---
Changes since RFC:
- Drop Pratyush reviewed-by tag as there were few changes.
- Trim the commit description.
- Drop the redundant comment as suggested by Mike.
- cma_overlaps_kernel_image() is kept as helpers in asm-generic/sections.h
  are virtual-address helpers.
---
 mm/cma.c | 21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

diff --git a/mm/cma.c b/mm/cma.c
index 9c53b2b70dc8..3231a53161cd 100644
--- a/mm/cma.c
+++ b/mm/cma.c
@@ -31,6 +31,8 @@
 #include <linux/kmemleak.h>
 #include <trace/events/cma.h>
 
+#include <asm/sections.h>
+
 #include "internal.h"
 #include "cma.h"
 #include "mm_init.h"
@@ -68,6 +70,16 @@ bool cma_has_dynamic_base(const struct cma *cma)
 	return test_bit(CMA_DYNAMIC_BASE, &cma->flags);
 }
 
+static bool cma_overlaps_kernel_image(phys_addr_t base, phys_addr_t size)
+{
+	phys_addr_t end;
+
+	if (check_add_overflow(base, size, &end))
+		return true;
+
+	return base < __pa_symbol(_end) && __pa_symbol(_text) < end;
+}
+
 static unsigned long cma_bitmap_aligned_mask(const struct cma *cma,
 					     unsigned int align_order)
 {
@@ -295,6 +307,15 @@ int __init cma_init_reserved_mem(phys_addr_t base, phys_addr_t size,
 	if (!size || !memblock_is_region_reserved(base, size))
 		return -EINVAL;
 
+	if (cma_overlaps_kernel_image(base, size)) {
+		phys_addr_t text = __pa_symbol(_text);
+		phys_addr_t end = __pa_symbol(_end);
+
+		pr_err("area %s (%pa, size %pa) overlaps kernel image [%pa-%pa]\n",
+		       name ?: "(unnamed)", &base, &size, &text, &end);
+		return -EBUSY;
+	}
+
 	/*
 	 * CMA uses CMA_MIN_ALIGNMENT_BYTES as alignment requirement which
 	 * needs pageblock_order to be initialized. Let's enforce it.
-- 
2.44.4


