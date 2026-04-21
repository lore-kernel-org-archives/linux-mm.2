Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C5BDFEA7184
	for <linux-mm@archiver.kernel.org>; Tue, 21 Apr 2026 04:25:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EB61A6B0088; Tue, 21 Apr 2026 00:25:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E190C6B0089; Tue, 21 Apr 2026 00:25:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CBA796B008A; Tue, 21 Apr 2026 00:25:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id B7A7B6B0088
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 00:25:25 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 258828CF03
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 04:25:25 +0000 (UTC)
X-FDA: 84681273810.08.C79A5BB
Received: from CH5PR02CU005.outbound.protection.outlook.com (mail-northcentralusazon11012061.outbound.protection.outlook.com [40.107.200.61])
	by imf22.hostedemail.com (Postfix) with ESMTP id 299A3C0013
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 04:25:21 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b="V6d/KUrI";
	spf=pass (imf22.hostedemail.com: domain of Hrushikesh.Salunke@amd.com designates 40.107.200.61 as permitted sender) smtp.mailfrom=Hrushikesh.Salunke@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1776745522; a=rsa-sha256;
	cv=pass;
	b=IX5TvvnXteezSbsbE0hMOJgI4lpJWsxWnPSvX+KBU89GZHzO6wrSiib+tjUTJYXYdMrd3G
	uemHl/QbSH36ByvxoFnvi6D27kNJfINYjl/8oZoH6QBAFqUV64sBdcIU0gUdqiHdTi7SyZ
	6hstfkRbqsuO2jmz4rTst6kXqZtlimc=
ARC-Authentication-Results: i=2;
	imf22.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b="V6d/KUrI";
	spf=pass (imf22.hostedemail.com: domain of Hrushikesh.Salunke@amd.com designates 40.107.200.61 as permitted sender) smtp.mailfrom=Hrushikesh.Salunke@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776745522;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=kn9Nb6bGppO0y7ftKbz2SIRH0RqK/G5Rr21hXk07hyE=;
	b=54+G/x5ygIy7HPbNdV0eEzp/p8y8aY1W3PSVXapv6+uHFESDble4HdMkSn+xjb7m6aLEqV
	IOibFdzt5q6tT0kzdpyEgmKBlHPuDNRYkv+yAA8Fw0eGz8+YEAj59HsX32QsUkwcltk4Vm
	rVzop/Y/qHWxrVxhmn+TVHns0uDTlp4=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=xSIhlwQ4w814gVAnIZKMX27q1FRHMG0p53N71xjYfBXTBGflobN+BX89jhIc1AhrpxAundbwFuaeWLDgoO5zpqK63RTTKSUXSNdUkUWCk8r3O/XhJAljd2pDchCGuwBvsUCHVlA/FNFXT026bSGpDLK48e7Z/mKZj0t2gclOlv0nhJJ/NKtSQDAmKYcw22nBgWgyXOfIEE90Rp4OhugaSJks/HLsoSr4efRKrpYmv5JskgdHR4YzJdB+2dNbIe8qInrnlcfhExg7I7oJWYRL6alvFQAQhIeocZBe/I+4+subFfo84Lm9Wjqw6obPWVziwJf2ToWTw0yvhOJMBPjYJg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kn9Nb6bGppO0y7ftKbz2SIRH0RqK/G5Rr21hXk07hyE=;
 b=DhxKga9ouEHg3XeZ48mF4ES/5uBHzqqyDLsc0WRax/VnHQfkIeancEvjMyhIorEy6YQTVWzgIXkJDnIdweJA+9N7TIt0UqB5EGlTO4990tvwukK3aqghLU5iYuQlzeeEPp3sgb0Sy9vrWVqmYinW5xco9iJtqkfMGMa5wGaVwr2eWD41wGMz70ZAS+9ZFZOh3MOZVyWTaP1mFdUao3kb2t/oBYmb6fyDeP/smDyrFBKe7ss1F8NJ4V9JjMiycwIXnrKtW56AQcEGA2q7oIPe9h6XfeXIGdMqSX/EY13+6SM0sj+vSzTiog3IqBkUGN3yQPLS/syzoi69lyLCoHALIQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=linux-foundation.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kn9Nb6bGppO0y7ftKbz2SIRH0RqK/G5Rr21hXk07hyE=;
 b=V6d/KUrIbfsqNWzoTSUxPDNbdHd1jAP83lYM5NKy8PJ17KtxYy2ujegKq14pb6mRPBRS+l1vJS/kBoNNkyg1lh77fCMDEJtEPul9R3pd4kS4yFqLfMo40Ei70uyLPiBZNAN46TJY2jmkKh3qjhtqyEbR2kbdFCsMCJH4CG1P9eA=
Received: from DM6PR02CA0166.namprd02.prod.outlook.com (2603:10b6:5:332::33)
 by DS0PR12MB7898.namprd12.prod.outlook.com (2603:10b6:8:14c::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9846.14; Tue, 21 Apr
 2026 04:25:18 +0000
Received: from CY4PEPF0000EE39.namprd03.prod.outlook.com
 (2603:10b6:5:332:cafe::e3) by DM6PR02CA0166.outlook.office365.com
 (2603:10b6:5:332::33) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9791.48 via Frontend Transport; Tue,
 21 Apr 2026 04:25:18 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 CY4PEPF0000EE39.mail.protection.outlook.com (10.167.242.11) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9791.48 via Frontend Transport; Tue, 21 Apr 2026 04:25:17 +0000
Received: from kenya-2193host.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Mon, 20 Apr
 2026 23:25:10 -0500
From: Hrushikesh Salunke <hsalunke@amd.com>
To: <akpm@linux-foundation.org>, <david@kernel.org>, <ljs@kernel.org>,
	<Liam.Howlett@oracle.com>, <vbabka@kernel.org>, <rppt@kernel.org>,
	<surenb@google.com>, <mhocko@suse.com>, <jackmanb@google.com>,
	<hannes@cmpxchg.org>, <ziy@nvidia.com>
CC: <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>, <rkodsara@amd.com>,
	<bharata@amd.com>, <ankur.a.arora@oracle.com>, <shivankg@amd.com>,
	<hsalunke@amd.com>
Subject: [PATCH v2] mm/page_alloc: use batch page clearing in kernel_init_pages()
Date: Tue, 21 Apr 2026 04:24:49 +0000
Message-ID: <20260421042451.76918-1-hsalunke@amd.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: satlexmb07.amd.com (10.181.42.216) To satlexmb07.amd.com
 (10.181.42.216)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PEPF0000EE39:EE_|DS0PR12MB7898:EE_
X-MS-Office365-Filtering-Correlation-Id: 89b3da7c-dc86-403a-e0ee-08de9f5dfde2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|36860700016|376014|7416014|82310400026|921020|13003099007|56012099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	lnWFfiAJIaH/bCATqxAFQLaNpz8EN4+OyCLrhXQRmmNjcek2aUSaYMtA13StzqTpXycq90V30Bnb93smoPF/6Aqy7gmcv1i+0CLxPB3GK0XCZ/qnpoE5n1Ek7fkYlnrI1Om3l8QJktH613Um22xPIU/eVR3EQGYJG9EEoVHK/K2TEz9lZ75rfoVz+cIXOiIkcAehytnHWRWmNALODAr0tBL8Ul13Ck6Eksm+Fs7cf2T2wGofTmfZuQC3sqiofYDvEgc2m/1sruy+qMxOaFDT8Vzk36lyCHQuk/jDND9WrInPXrMo5oVf2dwpYEP0iL8cBKuyKECF9Wzb8DvMEAV64HktxtURAxi2arMjW+AcJJjgdYx5Ad0Ny3cwot9EQktppuIJbYZZQi0ONXtLNf55tv1EmUcE3JR9dn1aY24DadBnIXwqhcnhfZhYtpO8O7F9EJfoXrBgKkAauJ/Dk/JkUxWQ3yUd2+6lzPymRekMFxdLzp/v+k4lQV7rj8yfTV38F8jgtFg8rXan+80dUK2QFl2inNGXqM+Hay0tK+S3iOc/eIcxx9lHVxM0Hcx6Kk0bI2Uplk0WI3+qWX/M8lAsjP+Oc92VQOn7yYOejC0JcvNoOniXlyQJ4cHuQnhnQgw6rikvhMo3AmZsGFzIIx3HaUs9bkupoKAulcQaekvusU77lNXRL59zJ09gD8IHmRmGjkYZsgiCpmewBF4mxNZwqGVo18budSpDhj460jI1KyB4OzV4MzDY/g8f0gi6FsR7Sc7gEwIUTw9EQolAj7uULJyRlNnjyLvfaR+yzp5zQLbtwmOBFYjjsBsFdCmTcOoi
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(36860700016)(376014)(7416014)(82310400026)(921020)(13003099007)(56012099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	cXUB9LvueLd1Le9yxNkoPG/MNLf9LZNPUDXsxIFLRISXsp6iocP3RZFP5W/ao71udsWfb71gSntKb/zs+Tam+C/PS7ox0RGr0HFY5WbE3lVXaGtWVUz0Psc+Q3hoSRPUZpYg4Av0fDR3ba8JlmWrW7Yaa/7uASSC8gwxMEaYggTQ2grt6zt8Ovj6KLGDq+RggCHMbKP20BFJV4c1vDdIIc3YRkyO8fEyA7bLz2cbZRPGuv3kHcJ1PlDaXXBK+OVgbRPdUNWKZeLCBDb5hiYzqEwfXWPoSCDZ/D+OfUrCei+aonJLraHtSq/B8KAXgqo4LibBq64BdM5/Ch4gAHKgRksmCrWCJ3DlNLCAVzP+fSO/d29T822gFNEMRYGymhjKVfhrQsYq0E2nsd1CboaxFatgvaqh/TgcSwHWPxK/8rFNpLATOAyFRk/cWzvCA7OZ
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Apr 2026 04:25:17.2500
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 89b3da7c-dc86-403a-e0ee-08de9f5dfde2
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CY4PEPF0000EE39.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB7898
X-Rspamd-Queue-Id: 299A3C0013
X-Stat-Signature: 3t7qfm7tiaww1puqb6g775s9hds39yzt
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1776745521-519634
X-HE-Meta: U2FsdGVkX180u3omFOwmAMBTpwROVjau1N7jFQ5NV7hNwRvi3/85rLgaxe9bCtdcKVE3ZotvQZK1yiVhq+HM6ScU9v3jsZnCIOZe1Svk3syt6WMXi3g2yoPgWIPSdFhlUyqAVQ29lVrOtntV0ONA3NhQ18seEadB5nqMKV2nouHK3w6PBO5rVHFze4C14+YdHL4YWJ0ED0wiQjs/LRvs/pfZR1FQss5fo3j+izWBNHQ/miu3rtTmSETUnGv6h0jz2ujFXUCGlDdq1OPmXwkGDSbf/F35CG4CdjdOuR15Duus3exJPq8cKZsXV5eegnz+OfSD8ZlA+17jskcg6GqoH9Bc5zI9Go2O01p2om14L1MDJF6q+ywZEeemCMlN04BMCXP1Uj0W1vXA55iwS4e3IzSZ/WGZ3Ph2COmB5XlllOKZYR5exToU4igp+eaG3dpBINjbWxLmXvqiKdu88DSRaP7oFJXA6oXbwJ+zEKXJfx9vMCVH/1j6UVLeWHtDz3S19fHhiuCbECCcjC2rj/JolQifiHvcmO4wVilTkm2yYSl0krd1EkM+SI7FXq80ww0FCqA9kmwziJNhh4537b9u2IqG4plL5SP3A0hZhDR0utgLhImKr6wesLEL8k4IKwY8aJ+x4Q8UMLW5iUmMg/WvI/MaLOfym9FFHhvWA+7jOowdTY/dUIRGT8NW3i+g/edCrbuupMYgV9TtfTDmv2ygaeLX95fDNIYtB170R5WR7ygZTe7T71rXFO4ekBE8XulcX4t2DrI+RVgF3NV9LmFOSLfKkvDcwIyAwUtCFDmcPt9wLbrCp4veO9gjOsFkE5Xe5O2R51KgyCeHpUM3qSkWmJvkjnDiAisMdc1hW489aTTz2MSkP0u3428UBKyqTVu/bACnTgfTDik6pnDWndqtLgkpl1p83qukviKTb5xhBozfA8vTV01i3lla8wKPEosz8UDoHOww982edsNgTCh
 l76kUvA1
 OHtZJzSK4qsZKuQySHb0s/48w4WzStdP9+NLC04kEcp8NoHMJe1VOdVEnZfgOfZiPPJ1rIAkhH65MTfrMYqKxG8aI9HRiKIXfWbUl8JK4VbzEbd/tzqCaEMeykk+78lDJqRZ9ZJ0JfI9zJNIf1PjKTG2Uz1WHFXsR3wzvstum5X41x+2SCQY+rpdYVRvElr6zUAihRSlSSiC3b6Gn/N/Ol9gZD58qzuputiBtod6cHoHGwyDXbmkElqPCb0hvweplUKfUY1RLTkZWki1JsbOKNQOkh5jofx32ZEw0cyDQGURV3C2oHgwAz/Msa8nHCCyqF9jIJg0kHgkCSSAq0DQRp++vjapJe+pC+M6PBh2Che2KiyNf/wE4GeJKbEO8B5vT1Ok0N3/6MoBz8FYx6MPt+vm1vG1M3up5NrMb4OpQlq7FAG5jShAuII5yGs+1ScKPvLUMueBpSDZLXdP5o5GTFhzcIUXhhnls0dd4fEcb4i+V1vL6KyBEsoL/YLaxfhAF7UWdSbeXRL4N6kRk9CNFDe1qYJt0wU0VpR3Lp49niBvDbWdNlQn8me/h6uS2ph14Q6BYDeupYmBaxT3NLf9QUodurzUa0rjTyfsArUiON7T/H5sWC7YA8b/UOVLWzOUo9Ht4W1sP7bF/YOR0HUKEYyAWjH2zsp2Q0na+
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When init_on_alloc is enabled, kernel_init_pages() clears every page
one at a time via clear_highpage_kasan_tagged(), which incurs per-page
kmap_local_page()/kunmap_local() overhead and prevents the architecture
clearing primitive from operating on contiguous ranges.

Introduce clear_highpages_kasan_tagged() in highmem.h, a batch
clearing helper that calls clear_pages() for the full contiguous range
on !HIGHMEM systems, bypassing the per-page kmap overhead and allowing
a single invocation of the arch clearing primitive across the entire
allocation. The HIGHMEM path falls back to per-page clearing since
those pages require kmap.

Use it in kernel_init_pages() to replace the per-page loop.

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
base commit: f1541b40cd422d7e22273be9b7e9edfc9ea4f0d7

v1: https://lore.kernel.org/all/20260408092441.435133-1-hsalunke@amd.com/

Changes since v1:
- Dropped cond_resched() and PROCESS_PAGES_NON_PREEMPT_BATCH as
  kernel_init_pages() runs inside the page allocator and can be
  called from atomic context, making cond_resched() unsafe. The 
  original code never had a cond_resched() here, and the 
  performance gain comes from batching, not rescheduling.

- Moved the !HIGHMEM/HIGHMEM branching into a new
  clear_highpages_kasan_tagged() helper in highmem.h, per David's
  suggestion.

 include/linux/highmem.h | 12 ++++++++++++
 mm/page_alloc.c         |  5 +----
 2 files changed, 13 insertions(+), 4 deletions(-)

diff --git a/include/linux/highmem.h b/include/linux/highmem.h
index af03db851a1d..ad0f42d06ce6 100644
--- a/include/linux/highmem.h
+++ b/include/linux/highmem.h
@@ -345,6 +345,18 @@ static inline void clear_highpage_kasan_tagged(struct page *page)
 	kunmap_local(kaddr);
 }
 
+static inline void clear_highpages_kasan_tagged(struct page *page, int numpages)
+{
+	if (!IS_ENABLED(CONFIG_HIGHMEM)) {
+		clear_pages(kasan_reset_tag(page_address(page)), numpages);
+	} else {
+		int i;
+
+		for (i = 0; i < numpages; i++)
+			clear_highpage_kasan_tagged(page + i);
+	}
+}
+
 #ifndef __HAVE_ARCH_TAG_CLEAR_HIGHPAGES
 
 /* Return false to let people know we did not initialize the pages */
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index b1c5430cad4e..1aaf7f839ff4 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -1220,12 +1220,9 @@ static inline bool should_skip_kasan_poison(struct page *page)
 
 static void kernel_init_pages(struct page *page, int numpages)
 {
-	int i;
-
 	/* s390's use of memset() could override KASAN redzones. */
 	kasan_disable_current();
-	for (i = 0; i < numpages; i++)
-		clear_highpage_kasan_tagged(page + i);
+	clear_highpages_kasan_tagged(page, numpages);
 	kasan_enable_current();
 }
 
-- 
2.43.0


