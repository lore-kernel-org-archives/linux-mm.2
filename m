Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5E798CC6B1A
	for <linux-mm@archiver.kernel.org>; Wed, 14 Oct 2026 14:58:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5A2906B009E; Wed, 14 Oct 2026 10:58:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 579C06B009F; Wed, 14 Oct 2026 10:58:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 48FDF6B00A0; Wed, 14 Oct 2026 10:58:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 232A36B009E
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 10:58:07 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id A8550C05C5
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 14:58:06 +0000 (UTC)
X-FDA: 85321536972.28.0B6028F
Received: from SN4PR2101CU001.outbound.protection.outlook.com (mail-southcentralusazon11012069.outbound.protection.outlook.com [40.93.195.69])
	by imf25.hostedemail.com (Postfix) with ESMTP id 885ADA0004
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 14:58:03 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=enTbxlqw;
	spf=pass (imf25.hostedemail.com: domain of radhey.shyam.pandey@amd.com designates 40.93.195.69 as permitted sender) smtp.mailfrom=radhey.shyam.pandey@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791989883;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vO6pr8ahLz/VNEk4wNG77+c3v2GVHGGw69LTDQuTlH4=;
	b=7kierZEww/bBrhiGwBIY/FeSwF3j5+oio8927fkZjGowejN/d/2prjetWubvf7v2aXvfvS
	r1Pqm+yXMfh+iJqqRO7PEio8w49nQc+pK9/y4aSZKRUA1WBb9Zj29v+jgg3KkGj8sC4MMy
	3cKTFIaLVorVmQ8Dn4EjLaaGSqa18G0=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1791989883;
	b=pi0Ez3TWv+gxbY27P4FRuODhefPC1X5QHK1/3/VJlyWSd5KjUTU62v5VHHimXHuTSR8FDG
	CPdn2CJ0LyySZJFOCh0VsquCsNhxDwZ8gcq4ZlgeMG9nJNk1lzdJSUv78lbWLIJepHn9it
	rswX6f0s4kFTsE6nzdkP0xosxVg3yws=
ARC-Authentication-Results: i=2;
	imf25.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=enTbxlqw;
	spf=pass (imf25.hostedemail.com: domain of radhey.shyam.pandey@amd.com designates 40.93.195.69 as permitted sender) smtp.mailfrom=radhey.shyam.pandey@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=VWA6ScLGB1XrKIerpF19zm6SFov29im53gQ6/zdYFOwiIMXJidXYhJAkqB0LiMKd472TVYsGCunZbnoj7AUC4bEy22zubuRlZsupuQTisPj1ubZIFGpakFjOh2rhotR4YmjuhZ+JyL34H5c+25N51uDlSAdhvUhMJ8B4B446I96nNjBEYf6SF2dvfi5hESjShswOI1Lq47Lmg8e2j2aUNu7+k/cHbYzjgUKfWq58C732ztunqauxEQ1vJo1OXOvIFN3ZUUIvR23ERt8jC2lN3AglCUor/5hKKNSNhuEe+Ge5o9h+n6hanUW8QYh7kBPINafBYMPVjKpzyjWtwQy2vQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vO6pr8ahLz/VNEk4wNG77+c3v2GVHGGw69LTDQuTlH4=;
 b=JbGqCjFCG7s8K912vqwyKLZ4Hu7xvHm+MgThDnBct2dvRLBpYY+jC1SSqw0OrJ8N3BHXWHT4oHrJrqTcxtVShJRtra85SlMnSXSuUslPBmJaPh0UL7+64sO8AajRDxo4XpPPfdOxIL+IzpLTXRrR364EjXmgviS1D/+U48oJatWBNME6PlRvFBwBEj9AoJ0Ic+u4o0fsan+8Lc/cClPqwidVAr9dBtN3q/MeTSg6jBrUu60pOm2MuRzLOaRkETBUltqqpy81DOlFvr4tiCeVsyvF461oDpttyR1qVUG1XJ2FmsEBBqPjqX7j3OVDEsJ3IwQkqNnXPJz6xhesxLFVRA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=linux-foundation.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vO6pr8ahLz/VNEk4wNG77+c3v2GVHGGw69LTDQuTlH4=;
 b=enTbxlqwwGK1t4jL0VAqV85Zu+89xLX1ae3my1QlyzLbOgQDuDJXbQoF2VOOoL5yPWKnN+HZM3q1D5F3dVhD/G2uMIq/0j3hU7/p8dciUgSzHJvrFcvxTwm7NdZfbD51LnQpZgMt/luq9y4RL1z7m360rdybR6Rd4SDdegNw0HE=
Received: from CH2PR17CA0019.namprd17.prod.outlook.com (2603:10b6:610:53::29)
 by IA1PR12MB6577.namprd12.prod.outlook.com (2603:10b6:208:3a3::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.451.24; Wed, 14 Oct
 2026 14:57:55 +0000
Received: from CH3PEPF0002457F.namprd04.prod.outlook.com
 (2603:10b6:610:53:cafe::40) by CH2PR17CA0019.outlook.office365.com
 (2603:10b6:610:53::29) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.522.4 via Frontend Transport; Wed, 14
 Oct 2026 14:57:55 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 165.204.84.17) smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb08.amd.com; pr=C
Received: from satlexmb08.amd.com (165.204.84.17) by
 CH3PEPF0002457F.mail.protection.outlook.com (10.167.252.25) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.522.6 via Frontend Transport; Wed, 14 Oct 2026 14:57:54 +0000
Received: from Satlexmb09.amd.com (10.181.42.218) by satlexmb08.amd.com
 (10.181.42.217) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.53; Wed, 14 Oct
 2026 09:57:48 -0500
Received: from satlexmb07.amd.com (10.181.42.216) by satlexmb09.amd.com
 (10.181.42.218) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.53; Wed, 14 Oct
 2026 09:57:48 -0500
Received: from xhdradheys41.xilinx.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server id 15.2.2562.53 via Frontend
 Transport; Wed, 14 Oct 2026 09:57:44 -0500
From: Radhey Shyam Pandey <radhey.shyam.pandey@amd.com>
To: <akpm@linux-foundation.org>, <david@kernel.org>, <ljs@kernel.org>,
	<liam@infradead.org>, <vbabka@kernel.org>, <rppt@kernel.org>,
	<surenb@google.com>, <mhocko@suse.com>, <baoquan.he@linux.dev>,
	<pasha.tatashin@soleen.com>, <pratyush@kernel.org>, <graf@amazon.com>
CC: <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
	<kexec@lists.infradead.org>, Radhey Shyam Pandey
	<radhey.shyam.pandey@amd.com>
Subject: [RFC PATCH 1/2] kexec: do not place the next kernel in a fixed-address CMA area
Date: Wed, 14 Oct 2026 20:27:30 +0530
Message-ID: <20261014145731.3431527-2-radhey.shyam.pandey@amd.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261014145731.3431527-1-radhey.shyam.pandey@amd.com>
References: <20261014145731.3431527-1-radhey.shyam.pandey@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PEPF0002457F:EE_|IA1PR12MB6577:EE_
X-MS-Office365-Filtering-Correlation-Id: bfd4bc44-8211-41f7-5f07-08df2a03871b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700016|376014|1800799024|82310400026|7416014|23010399003|11063799006|10067099003|22082099003|261009223027099003|18002099003|56012099006|921020;
X-Microsoft-Antispam-Message-Info:
	MsweRTPEuNdh6PxPRPaQiJNxz7/Eyrkgxuo2Fm2xnpc9QscSanPKIg4R0xto5aQfdTmTodGUyMzDi6nBmxHNIKhnTb7Mvtte8HW3AdK+b/hZg+2G+NE0dgbiqJ8yqXbQdlCuiwt2b85lvImCETdvcdenSyzXe9Sa3bW8H3aDpptTqbdVbqzogt3AONsN6S5TK+LbKARHtIUvSTQVpqPqo3qZ+1+hSS3tGDMZ9ChpI0NgkuexaTvAtFSlUnUpBzBSeDvc0SF4E8cvEDMpxaeuR0sZ8FWS6BcTN9hz3m4vHnuwqNXuIeaGxUQ79UjCnO76xq1WafhDK+H2miGVkEQzz/QAeGxAbYF3GjJ6IOzXG+NJ4KbjvtmJYwSnMTv7LyJCuVEJO35nMqLK88BMgagVuqcQu9Yk987TIdabGlocew0nA6sTiqAHMKyP5o66EkdlTeTC1TlS4x+lK3WG7T7nlSnbCBeVy1w1Jbe18uPCRCQhVkarbvpOxXHfq7auVENY2GjQUXuDYnnBiGyPloQOzRdqlDzLLmV4DS9l3TCzTdT+Vtp77EMNXpMuPFEST2TOvrv+nBb0itjj6+7wqc6ooIS7WMngFjx7Ve4Bf0iULG4qd5cCX79bePTeuAz7VA2AWOxpqqeHaIWQ7eMxezR1XFryN145TJVqDMAAmzTG2ekw9F3ThATfcz9204Ri8KgrQFQ5ZK6BGg/apjVmxHYDEE1HY2whp6l6/n1iJQuyXkf8OnwSMg+lYULt1B6D+y3n
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb08.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700016)(376014)(1800799024)(82310400026)(7416014)(23010399003)(11063799006)(10067099003)(22082099003)(261009223027099003)(18002099003)(56012099006)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	5r73/df/MSguC31iEfCpcTx2FmC4fW9UwI0kNu3c+oFJBXDiqROjaEloIluazsTblacEthc9scafk2eicfzUPspR0cMU+/yMFKfEiACcjESgkH78YJki3E0zRfPVUrtI2DVhvDveY4CTEAX+l2SU8ERyobz68jqxI4vvZb2oDH7uErv43tUSWJq0YPYKwRoffjPDjGgMZFU4vlJs52VcWY3jt430z8XHr/I/KtSdGakCynpZWtYCXPSjFh+A/Vd0DzYGusp05E66Zp82fyvw6NyjmIob/32b+SA8JWpwhQc7rHsF8y8q2LeteyxXttdYyl0v4xEW5MOIe/ILmtqNaT+CZwQ2an/FqzEuNLXztJMmk65gHagjAZvKrCw++3CIyR34sYDcj9GBRy1kznlbcIKv8LQQ1nOYXpodAyjpZjBS4HjdwVr9f8GTPzvwn03N
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Oct 2026 14:57:54.9340
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: bfd4bc44-8211-41f7-5f07-08df2a03871b
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb08.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH3PEPF0002457F.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB6577
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 885ADA0004
X-Stat-Signature: 4yy58cy3edsx5qeckm9ax5z7m6iidkpb
X-HE-Tag: 1791989883-915110
X-HE-Meta: U2FsdGVkX194Koe0ZywNQi7QBRcDnn7uW6og/tBi5RGr7ziw6zW7pYhIUfMooUUevbAa3jQqk1Rgi5BhFXCh5CzkxTmxRve/PQZBmVKp3JVxLrzGspDJKp5kwtd7PFZFREQkQfteWVHwLedIMBSSC+wKR29t0EJ0vOBz72wuFNMJEpD1VX+7yhhjB5Yntn1ucCN4c7WSQo00TkCDE4NljLRSIJd8Q38pX/gjzvkwj58v9enF7ihbWI1HB+UJfiwBppCLN0K/zB+2MGOxiuiOZQlq0Vw0kbF5m76121bupMXkrQ6OjRIyjgbid5IPjcEvOdE4vzhb305dSA0XvoH7lQSjWpJWN2hrsmruG2tuhrcpUUIbr5L3Cou2pAhXvO3ZqtT9pnv9lrBJCFG0TsixYOTdgxu3xeq9ud7Q0Angsq/nRNqVW6EczrxKkOHxnAsn21rhBmRSO9EgmlEQT7MNfTZ7Frp0ZjI5EZ38iACVaGetntjmOFF4givGYTCrw80hrYX3slFdWTvL3zB1jfI5ofoPrLgKGaX5Xdb6XXXaHD5zRg/LbPcvm8EJLPYZbMPPpm6fLjwt7VYRbqbJuIPB3qQU3DadPto8bhp0b0dw2OJumZAP0FDlAbX70rJOEHj6U0TWkIrhCQAkbcmGGBJXiOMWJMmtEb2mj4bjIzdOmu5EMM35m+zVQN2aGE1dDGb3fSDv7E0rKZTX8qBWXyQg0ibigwW6vVpXXWbDb7v2F6/Ihh+ypYbCigSGviULexqhysBxTXqWxwVdEiCroyDvzBzHij986knNHqdWYwYeRdVeTVEOUjHIStum/rb/iXThXOnO0XMCwyb3/IsgoeQNhRHvW4hw3ug7yNUnKc/UrkTBbDXy1WTZ73ll5f0ikIusw/Clwcf+BC7Hz+anCC0AnwZR+odNjmgibAaiOxDd4/SBhKsf8cm8j+SEHWwdlKYeyZ8DMlDbaWvHJiR90gg
 Gni1znym
 8mJB/XBG02DxgAbmjjLI8ILcl0++Lps2//7QJYnLjnEU7RJgpdA6csrQGbEE+iGMGvcTgQdgNZtLEBGomCdjtYza7jaiuvpbVIe/IxSgz9S0TZ7XNsO9nln9wgE9TjpAhbde493oaK6r3rOhcYR3tNEod4tVxOLGoJtUopMYU8FQiX/yMO1ND3qBuRCTQhtfs+TBz3pbZHIS29yyzH0iE5wfxVS84wAuR5XTZpDLTOy9LiVQEjp1FEw+wEBVnxDXcg0QmvQ/HxEAux/AKFZXfKzPnyaS2QhGrfQsztwVDXntZnEbE5wEkkaM0UiXNYF6RR6j1p48bKpH29ixPUbSCRPQiO5WLEtVhH9tpp7hHjQAgYGF033ao5Dm7BYK371kEFZQMklZQTd1TsMB2yAYTjvUZpbAzGrdLD1g2
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

kexec_alloc_contig() picks the destination of the next kernel out of the
default CMA area, and the next kernel then runs from there in place
instead of being copied out. That is only safe if the area will not exist
at the same address in the kernel being loaded.

For an area whose base came from the device tree, it will. The loaded
kernel parses the same description, declares the range it is executing
from as a shared-dma-pool, and cma_activate_area() releases the pages
holding its own image to the page allocator.

Distinguish the two cases. An area placed by cma_declare_contiguous_nid()
without a fixed base lands wherever this kernel found room, and the next
kernel repeats that search against its own memblock state, so it cannot
collide. Record the difference as CMA_FIXED_BASE and refuse to use such
an area for the payload, which leaves kexec_locate_mem_hole() to fall
back to the memblock hole search as it did before CMA placement existed.

This is what makes the KEXEC_FILE_NO_CMA flag unnecessary on platforms
that describe their CMA pools in the device tree.

Tested on a AMD Versal AI Edge Series Gen 2 VEK385 Evaluation Kit whose
device tree declares three CMA pools, the first of which is
linux,cma-default:

  cma_reserved@800000000     4 GiB at 0x800000000    (default)
  cma_reserved@50000000000   6 GiB at 0x50000000000
  cma_reserved@60000000000   4 GiB at 0x60000000000

All three have a fixed base, so kexec_alloc_contig() declines the default
area and kexec_locate_mem_hole() falls through to the memblock search,
which places the Image segment at 0x9c00000 size 0x1de0000. The kernel
that boots from it reports its image as [0x09c00000-0x0b9e0000] and
14680064K cma-reserved, i.e. all three pools still present and none of
them overlapping the running kernel.

Fixes: 07d24902977e ("kexec: enable CMA based contiguous allocation")
Assisted-by: Claude:claude-opus-5
Signed-off-by: Radhey Shyam Pandey <radhey.shyam.pandey@amd.com>
---
 include/linux/cma.h | 10 ++++++++++
 kernel/kexec_file.c | 12 ++++++++++++
 mm/cma.c            | 16 ++++++++++++++++
 mm/cma.h            |  2 ++
 4 files changed, 40 insertions(+)

diff --git a/include/linux/cma.h b/include/linux/cma.h
index 8555d38a97b1..2fe66377e5d3 100644
--- a/include/linux/cma.h
+++ b/include/linux/cma.h
@@ -61,4 +61,14 @@ extern int cma_for_each_area(int (*it)(struct cma *cma, void *data), void *data)
 extern bool cma_intersects(struct cma *cma, unsigned long start, unsigned long end);
 
 extern void cma_reserve_pages_on_error(struct cma *cma);
+
+#ifdef CONFIG_CMA
+bool cma_has_fixed_base(const struct cma *cma);
+#else
+static inline bool cma_has_fixed_base(const struct cma *cma)
+{
+	return false;
+}
+#endif
+
 #endif
diff --git a/kernel/kexec_file.c b/kernel/kexec_file.c
index b668ce8d68ee..10e770bcee0b 100644
--- a/kernel/kexec_file.c
+++ b/kernel/kexec_file.c
@@ -28,6 +28,7 @@
 #include <linux/vmalloc.h>
 #include <linux/dma-map-ops.h>
 #include <linux/kexec_handover.h>
+#include <linux/cma.h>
 #include "kexec_internal.h"
 
 #ifdef CONFIG_KEXEC_SIG
@@ -691,6 +692,7 @@ static int kexec_walk_resources(struct kexec_buf *kbuf,
 static int kexec_alloc_contig(struct kexec_buf *kbuf)
 {
 	size_t nr_pages = kbuf->memsz >> PAGE_SHIFT;
+	struct cma *cma;
 	unsigned long mem;
 	struct page *p;
 
@@ -702,6 +704,16 @@ static int kexec_alloc_contig(struct kexec_buf *kbuf)
 	if (kbuf->image->type == KEXEC_TYPE_CRASH)
 		return -EPERM;
 
+	/*
+	 * The next kernel runs from here rather than being copied out, so it
+	 * would declare this area again from the same description and release
+	 * the pages holding its own image to the page allocator. Only an area
+	 * this kernel placed itself is safe to use.
+	 */
+	cma = dev_get_cma_area(NULL);
+	if (!cma || cma_has_fixed_base(cma))
+		return -EOPNOTSUPP;
+
 	p = dma_alloc_from_contiguous(NULL, nr_pages, get_order(kbuf->buf_align), true);
 	if (!p)
 		return -ENOMEM;
diff --git a/mm/cma.c b/mm/cma.c
index a10ea37a261d..1f4d3d48a3bb 100644
--- a/mm/cma.c
+++ b/mm/cma.c
@@ -55,6 +55,19 @@ const char *cma_get_name(const struct cma *cma)
 }
 EXPORT_SYMBOL_GPL(cma_get_name);
 
+/**
+ * cma_has_fixed_base() - was the area placed at an address it did not choose?
+ * @cma: Contiguous memory region
+ *
+ * Such an area is described outside the kernel, typically by a device tree
+ * reserved-memory node, and so lands at the same address in every kernel
+ * booted with that description.
+ */
+bool cma_has_fixed_base(const struct cma *cma)
+{
+	return test_bit(CMA_FIXED_BASE, &cma->flags);
+}
+
 static unsigned long cma_bitmap_aligned_mask(const struct cma *cma,
 					     unsigned int align_order)
 {
@@ -304,6 +317,7 @@ int __init cma_init_reserved_mem(phys_addr_t base, phys_addr_t size,
 	cma->ranges[0].count = cma->count;
 	cma->nranges = 1;
 	cma->nid = NUMA_NO_NODE;
+	set_bit(CMA_FIXED_BASE, &cma->flags);
 
 	*res_cma = cma;
 
@@ -517,6 +531,8 @@ static int __init __cma_declare_contiguous_nid(phys_addr_t *basep,
 	}
 
 	(*res_cma)->nid = nid;
+	if (!fixed)
+		clear_bit(CMA_FIXED_BASE, &(*res_cma)->flags);
 	*basep = base;
 
 	return 0;
diff --git a/mm/cma.h b/mm/cma.h
index 68e574b0f951..1bab24033284 100644
--- a/mm/cma.h
+++ b/mm/cma.h
@@ -80,6 +80,8 @@ enum cma_flags {
 	CMA_ZONES_VALID,
 	CMA_ZONES_INVALID,
 	CMA_ACTIVATED,
+	/* Base address was dictated by the caller, not picked by CMA. */
+	CMA_FIXED_BASE,
 };
 
 extern struct cma cma_areas[MAX_CMA_AREAS];
-- 
2.43.0


