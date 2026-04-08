Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D9BD4105D98D
	for <linux-mm@archiver.kernel.org>; Wed,  8 Apr 2026 09:25:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0C8BF6B0095; Wed,  8 Apr 2026 05:25:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 052556B0096; Wed,  8 Apr 2026 05:25:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E5BF36B0098; Wed,  8 Apr 2026 05:25:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id CE44F6B0095
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 05:25:23 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 76C7413BF35
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 09:25:23 +0000 (UTC)
X-FDA: 84634855326.09.1A117F9
Received: from BL2PR02CU003.outbound.protection.outlook.com (mail-eastusazon11011034.outbound.protection.outlook.com [52.101.52.34])
	by imf16.hostedemail.com (Postfix) with ESMTP id 76BB2180007
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 09:25:20 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=wXAyc9q1;
	spf=pass (imf16.hostedemail.com: domain of Hrushikesh.Salunke@amd.com designates 52.101.52.34 as permitted sender) smtp.mailfrom=Hrushikesh.Salunke@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775640320;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=Qsez6ESYv3ZvzqCi57etiEt10Rnhv9F85nDIl1omQEE=;
	b=mXu+vxxzG1uByWkJ+plSVkKqdtdy4eg2JLGSX0ip/lPYo951+/Qix2achERlm11GzBMcLN
	6zXIJpf62BUKyxgdRkES5en35OX7Nu7Pwrzu5dpjz20t1phd2+9ZOVumAmDI0oPA4TSlz0
	R/yLCEkFOAN64uF6cl9wal0NR4Qg0w4=
ARC-Authentication-Results: i=2;
	imf16.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=wXAyc9q1;
	spf=pass (imf16.hostedemail.com: domain of Hrushikesh.Salunke@amd.com designates 52.101.52.34 as permitted sender) smtp.mailfrom=Hrushikesh.Salunke@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1775640320; a=rsa-sha256;
	cv=pass;
	b=mqAhszQlizMaNQ6fxsumAA2nD5CAVqtoRLk/60HLN79e3YCr67jevy2Ls8C2tuN4gM5GMs
	JIwAZ8Px2+j2GPeY6VhH3eIhYgyy76pBcn9xLaIzfqvnkIKb0NYplbDF3kNIe8lqHbqJ0E
	c6Uxtuoqx0/OI2aXGQ5bLFyFbcOS7WY=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=qLsUHoxLn1oCVUsHkiWnkQheabUxc2Zsp7c0i3zLItLAvT782rdacu8zIIwOgyX0a2jWD96e3qwYgus6ZCISJZ+IbXX0h6g2sOFiCFRHRmTCfbSU0hK2CdBU4WSzjrMYYofLovgdYk9R9SPlrC5Kzzhw4sIj3Uh0gZni0ojZwv1EwhxPtf/IBhfxvK4BDpQYhjr/9TkUblyhmR8UWCBJsReZdr9a0n0PffMpI+et5laTE25ptZHIN2ffi9HWTE/DvbOSjsLnUAwXoadE2BPmpAz2YU0pboglemdH+1EPUmu18lYDvDpsHtHssyrhfNzIh1maGos9BDOLdAAv38jRBg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Qsez6ESYv3ZvzqCi57etiEt10Rnhv9F85nDIl1omQEE=;
 b=KixZgc1oO72J1uQqypxvs0oYn7NMNw25MUDLZcT7VuVPjFLdcYeMD1vTPcslbOBhzz5Uk3QVRVBy9buTS4feUAu49TLhetBVJPoVQGF/AjIrCwAcaT+98ZgcP15ci7eNvDphVTYv+jIBDkYliKcZXYlP1Fr7Q0EYG1n3Jp1vRIAMmoto1rHRN4NDY/eb28KFXbocpbDfJpzusan3n0jNkSFQWH/jDG4QPNDx/zIdnkXNUHxFX2hIPvTZxd6CxgVdpFwEiPXrcmAnt07vnkq0t8dsElEZ+dzLBuax6u7BOKxTx1xHOgpmQqX8T85+klPs2nIC9kUdsCfMkUSclHxdbQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=linux-foundation.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Qsez6ESYv3ZvzqCi57etiEt10Rnhv9F85nDIl1omQEE=;
 b=wXAyc9q13UhJvou2L40dAjLhR/qazbAXTBxpSU4TbxiANm70p6IQ/hCXencc1gipbO0n+cPj7NeL/kKx6utkZCbAJ9F5o5+pDGaLXgVPTQKhCcE7AlfGfa1QjDPV4W2ovqORDE3iKlY1wGCPqkT4CCEygDoN9jYZtLmKWi/ch2Q=
Received: from BY5PR13CA0029.namprd13.prod.outlook.com (2603:10b6:a03:180::42)
 by IA0PR12MB7555.namprd12.prod.outlook.com (2603:10b6:208:43d::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9769.20; Wed, 8 Apr
 2026 09:25:15 +0000
Received: from SJ1PEPF000023CB.namprd02.prod.outlook.com
 (2603:10b6:a03:180:cafe::44) by BY5PR13CA0029.outlook.office365.com
 (2603:10b6:a03:180::42) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9769.33 via Frontend Transport; Wed,
 8 Apr 2026 09:25:15 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 SJ1PEPF000023CB.mail.protection.outlook.com (10.167.244.5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9769.17 via Frontend Transport; Wed, 8 Apr 2026 09:25:15 +0000
Received: from kenya-2193host.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Wed, 8 Apr
 2026 04:25:11 -0500
From: Hrushikesh Salunke <hsalunke@amd.com>
To: <akpm@linux-foundation.org>, <vbabka@kernel.org>, <surenb@google.com>,
	<mhocko@suse.com>, <jackmanb@google.com>, <hannes@cmpxchg.org>,
	<ziy@nvidia.com>
CC: <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>, <rkodsara@amd.com>,
	<bharata@amd.com>, <ankur.a.arora@oracle.com>, <shivankg@amd.com>,
	<hsalunke@amd.com>
Subject: [PATCH] mm/page_alloc: use batch page clearing in kernel_init_pages()
Date: Wed, 8 Apr 2026 09:24:26 +0000
Message-ID: <20260408092441.435133-1-hsalunke@amd.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: satlexmb08.amd.com (10.181.42.217) To satlexmb07.amd.com
 (10.181.42.216)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PEPF000023CB:EE_|IA0PR12MB7555:EE_
X-MS-Office365-Filtering-Correlation-Id: 5eefa875-d820-40f0-6016-08de9550be18
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|1800799024|36860700016|376014|7416014|56012099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	m/kjz0J0olInsUNyxvj4iUhDPaCU8nqumpa0mXj6dyQG34+DxNNfHpVSe13gCGUsmnrgF0YJ8Bte1qkrQ1hIX0qNvxOpqB3lvQP44LKfL/XQgvPARzXVXQGHUbCqb8sIvThpfQkfUKjac20Ud0GziJBLNrcbknUwV+nCj/eBbU905fFjdMSbNex0QxW/OYz7iYE/l2BMVoXYrslL5qmL/X+rvrivf+kyLxN6S0pE0xZxHV+hRiPP8h8DFGLBrDsPOQiGaDLq/vRbxpB6izaPL8OTHJv3J5+w2ihF71yA4+hCuiQb6Yv5jQ3zrfOErB9GQVdjR4+pn7trxY0qGekkDGL2Zk0nAanWArEM0p1XBN8wQGURnrFacD/Ec3x6qUUvHMWC3GqB5J6h0mApKuBpanlzwBH9cTTgZVwFiBpqMbLhPjL89jAlN8AB8Gml+Oi3u94t2+Km7Zcr7jAHg6VSm+WzsxbYCuGD9oT1+DnSZaUk5mo/GluQkDtQNgDkCTXF0wuyYhCAht6YIYy1cJxWtu1Uh1MpGb8+mTv7D6lGZsTeJ4daUfcWTPAxd37yT+t0HnG2+rWraC1Y+xrbUzaM1J7qThzPEE0vbIwtNiI24/lmOjlCDsgUxrcN3RZWB853kDfoBe9cFoJKoV2XfGlAfGfCwlWQ9AsCvsXEwWzmLGpsEWueOZzq107grGX+35Vi3XebPdEU7aRRuGDROoGAXeybgGCdua+t74VGMNvojB4zszqucg+f7F0uMCYh3DkQaLYPjWdkSWaeGPTXK/xb7A==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(1800799024)(36860700016)(376014)(7416014)(56012099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	ABO7OIEkjkw4k2iotk+YjWByhr7V8dPk3FPy9e5vagFMIgYA67MnIQWmQgBO06srY8Uc5MZ+yxYP493V5iJuoqN1NdgCI0Y0J7rL/zI/j/FL+tV5ouI40CjHf25EWUPP7KNOeIcdK7TzALRgnvf/U1WngLpMyGvD0opjALVqdMG00YPBKJjlvVOUC7KuqdX3fq6PI8kk70APNiYcm0jWriLvyG8B4u7NhxzW7toUXJOxhNLIJzAdJfy7lh7/IF0Krf8TS2Z7kr7+YqK3Y3v+jxtQioypmwpRGRvtQnxsVy6O4vsQb/aWRuJCOFx5R1jSi+gwB3JrxWUPrkPOlHQGGue/lo3CdPaMeyg3Npy8WZtPYWWh6UnUsCZA4CoSBnSI3Fz5tiRuAnv8Q0DKpH1a5K8+sdv/nNQhGFDYBJGGft2ox/2+mVyJ+BqLkH8dPpa/
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Apr 2026 09:25:15.1036
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 5eefa875-d820-40f0-6016-08de9550be18
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF000023CB.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR12MB7555
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 76BB2180007
X-Stat-Signature: d3wenpaqh1z4eizfjbjfxns1rbjuftj9
X-Rspam-User: 
X-HE-Tag: 1775640320-939056
X-HE-Meta: U2FsdGVkX19fPnr1mK3levQwwYSkfLtk2xaGoxoxnkGBi5+oofQbfJpFkvXzeWQ3kDcPzsxpGbbff/XuDP3zZYW0gExd1JqvOr2xd1z/3NDNKVt5rrRD5s9i/6P7iG5+33VvkrJHtbbxoZDI26trLlGS+OhljSTGJhaa86H4jOhXZhH9T9+GNA3OgKerCWHHJ1scD7XZ/yoR/AF4N7AiEqbbm+Pe0ph2WMbgQcc0DpnlvvQDge8/DvqcOhPX4vqBNCaHvvucFo1HdnhMXU02sbFqvgkauDFzr/iLFWH2hIueUc7Z0S/qmUx/2v4GWnhM+rThzrvov8E7lk1ZsYpHkVJecz3IYSwtGxObvr2i81izDX/3P2Wbi5Z7LZ63NDHCG3Yc+veFBELlFDOQ30Fo4FhW4Dd8C4fjxLs4oYBa43NK8GKp1dTw4Sotjn4kQYWyH4x9ZSJSaoFg603rbSsZOptCq7t2LnF1Ki7HmyYHtgzIr9eXDWw548lSn9O8/aeMNJWIT0czelBol/oYsmEwI86fkvc2R/0901Ba3OPQX6PMq2q2fzES9NJ532CSyDMzJxhMgL+/veqBgFvooIU16U0WuhB3x+Rfyj+B650L/VTYp38wFhQEvt20SJocMbmYVm9YjIbPOFcZZYEuVZmggXBYCZP1XizdsZFQXs1fDdCjaZOhPUulIXkamh6nqiwKUrvpQbMH4y1pMKqOEYZADrPgEGwTwl64g/zB8sj/q5tZ4A1KM21Mm6+M5lkQLNQOLY7jo1c0UGs9xbDaRoqOkat175P/uYm6cg7x3Ic4AOqPgTWL96fjpUZ4XZO/e8Oyc9cDwU0EYZawSM9tJMC9qpDkw2bucsFBK6F7dynZL99j9jo2MOdjj7BpAms9omnaHNVKx0wxUmTo6cpvDSz5o1o3EHYrd+wGDWJl3RRim+6H03s0EMD9wrKq8aSmeapT6Z3vHCrOKy/y/WV3Dzk
 xVd3XEPa
 tea6+C49rL+CjzAmkEdxguAF+gK2ecoESGnEsOdYUVZnAk1KRBry9+7Yv74FDVazQhmkF3nCL72km7FKLK5UYCXCeKV9FqmtmCmPC09ke75XCaIbC6NPQtPeaZMh75en5tqhNomfYQC0ZvKVDy96oxLjtlIdCkF3FalcHoCnZBY9Gp9e5VdWci4A5SfNXER3jvHRmbo4QGzpHxq2QYGQDzADy5RLn2c7ntepu2ypj5GSxRoafxgAzubVr7e8HcYBwV4yfeeYMqjGGHbZ2Kgcucm1Sa6jxXvck+iDtJGDAnuMLJrfI4GR1vsqBXhAW9909csd2VzSCfoeE0DX4HWqJrmVCQ+v9x0f14GAhzUEW1PtZQvMKWmnLrgbiw8h54EVDkApGEgji0pi8BaJ/eVGF3gN6NqpKCgU00UAm///qgu+2GehoMagor+eM9rgIVKKykmfG9D/cwD9THaioZREB9qhEh34L8+rJpdt0Ry9z2a3OoJLDfwpGkVhayhPOjuCOThR89mGZNaFlHWEarmv4DzH/2uRlV2AZb0EnY23jOO/NlU+dWvk7XbLmMMU8ZETPpdRY80jtm1ZMx62Lgpbe0WiP43C2f3kk6AFYX19iCV7Lrq1kVJUShWa82sLUzSH+wBVtJwEilqS+BFw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When init_on_alloc is enabled, kernel_init_pages() clears every page
one at a time, calling clear_page() per page.  This is unnecessarily
slow for large contiguous allocations (mTHPs, HugeTLB) that dominate
real workloads.

On 64-bit (!HIGHMEM) systems, switch to clearing pages in batch via
clear_pages(), bypassing the per-page kmap_local_page()/kunmap_local()
overhead and allowing the arch clearing primitive to operate on the full
contiguous range in a single invocation.  The batch size is the full
allocation when the preempt model is preemptible (preemption points are
implicit), or PROCESS_PAGES_NON_PREEMPT_BATCH otherwise, with
cond_resched() between batches to limit scheduling latency under
cooperative preemption.

The HIGHMEM path is kept as-is since those pages require kmap.

Allocating 8192 x 2MB HugeTLB pages (16GB) with init_on_alloc=1:

  Before: 0.445s
  After:  0.166s  (-62.7%, 2.68x faster)

Kernel time (sys) reduction per workload with init_on_alloc=1:

  Workload            Before       After       Change
  Graph500 64C128T    30m 41.8s    15m 14.8s   -50.3%
  Graph500 16C32T     15m 56.7s     9m 43.7s   -39.0%
  Pagerank 32T         1m 58.5s     1m 12.8s   -38.5%
  Pagerank 128T        2m 36.3s     1m 40.4s   -35.7%

Signed-off-by: Hrushikesh Salunke <hsalunke@amd.com>
---
base commit: 1a2fbbe3653f0ebb24af9b306a8a968287344a35

 mm/page_alloc.c | 19 +++++++++++++++++--
 1 file changed, 17 insertions(+), 2 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index b1c5430cad4e..178cbebadd50 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -1224,8 +1224,23 @@ static void kernel_init_pages(struct page *page, int numpages)
 
 	/* s390's use of memset() could override KASAN redzones. */
 	kasan_disable_current();
-	for (i = 0; i < numpages; i++)
-		clear_highpage_kasan_tagged(page + i);
+
+	if (!IS_ENABLED(CONFIG_HIGHMEM)) {
+		void *addr = kasan_reset_tag(page_address(page));
+		unsigned int unit = preempt_model_preemptible() ?
+					numpages : PROCESS_PAGES_NON_PREEMPT_BATCH;
+		int count;
+
+		for (i = 0; i < numpages; i += count) {
+			cond_resched();
+			count = min_t(int, unit, numpages - i);
+			clear_pages(addr + (i << PAGE_SHIFT), count);
+		}
+	} else {
+		for (i = 0; i < numpages; i++)
+			clear_highpage_kasan_tagged(page + i);
+	}
+
 	kasan_enable_current();
 }
 
-- 
2.43.0


