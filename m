Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3FB77F3C241
	for <linux-mm@archiver.kernel.org>; Mon,  9 Mar 2026 12:08:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5BED46B0096; Mon,  9 Mar 2026 08:08:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 576056B0098; Mon,  9 Mar 2026 08:08:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 474536B0099; Mon,  9 Mar 2026 08:08:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 324D96B0096
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 08:08:47 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id BDFB21BD0E
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 12:08:46 +0000 (UTC)
X-FDA: 84526403052.12.4D72179
Received: from CH5PR02CU005.outbound.protection.outlook.com (mail-northcentralusazon11012025.outbound.protection.outlook.com [40.107.200.25])
	by imf23.hostedemail.com (Postfix) with ESMTP id 9F9DC140009
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 12:08:43 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=HdL3klMH;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=quarantine) header.from=amd.com;
	spf=pass (imf23.hostedemail.com: domain of shivankg@amd.com designates 40.107.200.25 as permitted sender) smtp.mailfrom=shivankg@amd.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773058123;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=ETMZ5NoK2WiSlN6paRvMaoqyz9O26OG06Og+sPAr524=;
	b=8LGz9S3W7GsP9cBPIJ8G7rqBC6kZZ4WL+OZpCB7auSNs5OjKCKEDxHWrOYKAoMsVX5RUB1
	5WX3+5Gsm6QBzBrQyTC/yChpxTTxl7GGrmSxWk58A7F5TA4mbLkJgy5c687OpC1UuRr1mb
	WX4LdzilmJVkAs9DZpZZZFDAZStA/LQ=
ARC-Authentication-Results: i=2;
	imf23.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=HdL3klMH;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=quarantine) header.from=amd.com;
	spf=pass (imf23.hostedemail.com: domain of shivankg@amd.com designates 40.107.200.25 as permitted sender) smtp.mailfrom=shivankg@amd.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1773058123; a=rsa-sha256;
	cv=pass;
	b=hvImS4/6j41Q/kT047bN0fpJjCFanALo+74H5Cg6K+Xk0Iq4hV9G6YfN4PJ8Cqpr9nfscS
	9XhONZWcRmRzBUive9tAnfeAeG1g/mA1HQywrKh4bCJ5sVGBNu1ert7uSeBWX3V+c3YHv4
	c4fVqRMlDFCspynhdEeAKD9/arUxXJQ=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=yLiWs50alCYAtA2V3eRQRP7S0Vex4XMwQzXpv6B0TgxEEA5A4ikr1XkB5l2erp1xKnlh/Vy3lvt/h2cAlmyN55eIlbe5lafRgLsXajRgj2m/CYdhQ6PgvZelrd2bX9YRgxAuqY6eaDIdaA0qyPGAWQbOySDdObrdDJO5WvHrDarAh6t2LgOdQFI7Kc+jYhJy9yFL69EC1gLviLbEjnfHtn4q1XiYIGiJfDBSgSlNeuy76XtduKU3oLWesVMo7qziSddiBHXRSiGbmZ4/wBKiezF5FXLCWSR080E4VnLQWYCV9IFis8JcQD/gmC31CJQV2hzxMdEPhM8JqHCEfHGdDA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ETMZ5NoK2WiSlN6paRvMaoqyz9O26OG06Og+sPAr524=;
 b=Q83U3LgLGAr/DMG2rJyibXUZxmjdbGfQi1D259YS0ETxmOA5lCHNEuCz3BY+6ez2lXOltLHhvQ/Kn6SvznCPPPSpYC2g2viT0I/Mrjm1wHa6azXEh9dU/Pq+InLpneyKF2z9p/7LRALZBw7g60Y1Nlez3zUA5blJbUhQYSvO553pE5XCCOeWNZTC+QzCnlOWCaDqjZynCU6a8GBecO3ltjNcFAKQzoXdNwFuKfGr8v6sicYCF8yOjhRXFg2ydnvbstE4a5GJX17tU3XPFoO1s9woDg3aYLzNkAvan7lD4cZD7Uu0EUb/RBcq3tC5wTSpetXmw4tDnXRxFo0WoN8+XQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=linux-foundation.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ETMZ5NoK2WiSlN6paRvMaoqyz9O26OG06Og+sPAr524=;
 b=HdL3klMHxiYQOIc3ImEgtNxJV7uKvpsQ92A9ktSn+K8n1ewRbaILju725akjYy8h64pFKLcI+r8wXxYp8WtYv1O4kHKFj9xjdc3v0YTfBTqcbQ8KkDmHcFOplNCRMUvMiKuqpOtjrcKDWdqpeWzWhfTFYaLXXWAPX98ZyXnoJaM=
Received: from SA1P222CA0177.NAMP222.PROD.OUTLOOK.COM (2603:10b6:806:3c4::25)
 by DS2PR12MB9567.namprd12.prod.outlook.com (2603:10b6:8:27c::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9700.10; Mon, 9 Mar
 2026 12:08:38 +0000
Received: from SA2PEPF0000150B.namprd04.prod.outlook.com
 (2603:10b6:806:3c4:cafe::4d) by SA1P222CA0177.outlook.office365.com
 (2603:10b6:806:3c4::25) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9678.25 via Frontend Transport; Mon,
 9 Mar 2026 12:08:33 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 SA2PEPF0000150B.mail.protection.outlook.com (10.167.242.43) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9678.18 via Frontend Transport; Mon, 9 Mar 2026 12:08:37 +0000
Received: from satlexmb10.amd.com (10.181.42.219) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Mon, 9 Mar
 2026 07:08:37 -0500
Received: from kaveri.amd.com (10.180.168.240) by satlexmb10.amd.com
 (10.181.42.219) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Mon, 9 Mar
 2026 07:08:26 -0500
From: Shivank Garg <shivankg@amd.com>
To: <akpm@linux-foundation.org>, <david@kernel.org>
CC: <lorenzo.stoakes@oracle.com>, <Liam.Howlett@oracle.com>,
	<vbabka@kernel.org>, <willy@infradead.org>, <rppt@kernel.org>,
	<surenb@google.com>, <mhocko@suse.com>, <ziy@nvidia.com>,
	<matthew.brost@intel.com>, <joshua.hahnjy@gmail.com>, <rakie.kim@sk.com>,
	<byungchul@sk.com>, <gourry@gourry.net>, <ying.huang@linux.alibaba.com>,
	<apopple@nvidia.com>, <dave@stgolabs.net>, <Jonathan.Cameron@huawei.com>,
	<rkodsara@amd.com>, <vkoul@kernel.org>, <bharata@amd.com>, <sj@kernel.org>,
	<weixugc@google.com>, <dan.j.williams@intel.com>, <rientjes@google.com>,
	<xuezhengchu@huawei.com>, <yiannis@zptcorp.com>, <dave.hansen@intel.com>,
	<hannes@cmpxchg.org>, <jhubbard@nvidia.com>, <peterx@redhat.com>,
	<riel@surriel.com>, <shakeel.butt@linux.dev>, <stalexan@redhat.com>,
	<tj@kernel.org>, <nifan.cxl@gmail.com>, <linux-kernel@vger.kernel.org>,
	<linux-mm@kvack.org>, Shivank Garg <shivankg@amd.com>
Subject: [RFC PATCH v4 0/6] Accelerate page migration with batch copying and hardware offload
Date: Mon, 9 Mar 2026 12:07:20 +0000
Message-ID: <20260309120725.308854-3-shivankg@amd.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: satlexmb07.amd.com (10.181.42.216) To satlexmb10.amd.com
 (10.181.42.219)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA2PEPF0000150B:EE_|DS2PR12MB9567:EE_
X-MS-Office365-Filtering-Correlation-Id: 8803a4ec-ddac-4949-d6d8-08de7dd49875
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|82310400026|36860700016|1800799024|13003099007;
X-Microsoft-Antispam-Message-Info:
	3a6q06snTWX3fVbX08uPX87kNa+YGEn7ncPBIgrBCVgkyiCcO+vIt+sp8TGYs0OdZWugage18pW2gVMyQk4BrOPEQfYbq6TakOzCD0yURUdQqxr1hJgTaT6h8Gh5rdGsPpR03RtPOEZtmAYHZGDL/BLs0+UFU37VLYpPJYOC56gMGCY6jkKFg7JxrCFd5w0iH+9IBnwWNu7pnBywdm13XbomANHHT6TQkgKtcYz1uNbcD/ycrz5p1dNB1yILddNvDsOYzJYAyMwaSsZFca846juZcOBAgvkmL4qlK3nyFcrg14/OXWJsC3fxsd76gV54N75KM28uBJw6UWFN5e4tRm9iIvcvEsF6erpsw7kSdudsylVbfcm+yj+Ht8ZhmI3kADVjr4jlY++8Dwyldcg3mpw6SQR83YHc0Rg/gXMkEDbrGP8Yuxvtb+TrmQCQNuAuRpySWeMe02buKOD+QSdTKlWMifdyTREoa8yJjzdyx262HWHInymctNAt2GGweHGCLrj9AgcEiCsMlu3lpN5vJLQ69qdtBS6hFiEKsDcIcKxA9g46GdDnb2hM+hrRIaXQZFKRXY+MG1lNsuOARakPOqstUa349Ar4u5zvdBeoZJ5Rs11A/0cic5MwhnjO8icTr94LHd73GpaUi7PpwgwhH3lPBE64bTsfEb/WKgXvMaeA40laRULQYc6dXLgWJtH2EXrHvi1UFYlc8w/9/O74Ab8wWFhndVoNzM5gnRyQ+p8=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(7416014)(82310400026)(36860700016)(1800799024)(13003099007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	16mVyh/09iOcZPfDxiyAt9qOXmKYdJ9N+qhfSloHrn9Vx2WY0PJ06FTaINGJheXJyF8yTwUd0shm1eKCkzEtVB/umfkYS19LyCq4h27/2ZIL9jkLLrbivs9L3BM2uG4g/le+sbgaiGpel46jwtK9inFgmamK2ehwz4Vi0DgWQeTwxyUPevehBqpF/HGxNTLJTgsSx6wYAcJCnuz2BgG7WEQ5pV2E74HGdjTAP869KOvXYH8vr8fgDSWxWADWV9naljuvGQNuXv3NCssomnlmtm6VwRn2PHdBvuxi4tuhp+jjp3YvQOHZJ5iEUq8bInKog8cpxD+e7FbcZBHu+yL5QTM3jTRvgQTqrOsE7odDGDia8LLRLWG41Z9D/6w4QndxGt5OZwNOk1MHOYgRECnMQzb3yQLbQHg5DQstyB8+UprBLcdI5RJtqHZ1I9Kz7Q/j
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Mar 2026 12:08:37.6910
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 8803a4ec-ddac-4949-d6d8-08de7dd49875
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SA2PEPF0000150B.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS2PR12MB9567
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 9F9DC140009
X-Stat-Signature: 7a8yhp8669rtny1ucxibzxe1t9s48ear
X-Rspam-User: 
X-HE-Tag: 1773058123-380552
X-HE-Meta: U2FsdGVkX187RgUXH9/MLEZrrFnweXs5Sul9va9JP64mtuzP7BNO0ENGzb2yZBmhNTI/3dqmysHKclJa/xNsvDpYUlTeK37Y4zJpHfQ/WATocjAlvkiI/e7U8VJoE1Q05UCDyaqlmgppB3t2YisD9zEFOWsvvNLr5m5ITL4W8bcRd9rba3/b+g8pX5CGjWX2frZmuo9DYYzENYmiP86dR7LmO6WSlTr9W9FKmYdEnRJVkmUZJN2XbUDlw9B+nqevlYUiSPfHrDmcCni/Ya5av+ZfH2pMhoudCknLmHU+CjUSueyahxZN26NPuCPoowj57kYrFBu0p/v3aK/GN1CAiiK3vxE5T5JCJSit0kErAOPFEHV0peiA+d4h987oX5fU2jlmv458sAFfv7mqPVCQraSIfV1zCWcKIQaQ9zs+WZq5MvguI7VELhlT118EY6CJuGa0cjZsv6O8T2lzqYLHRnxKdfgHHHLVuvkFUiyREIMLJksAqv9wW5/8PgExgPwvLqaEXkO4+05iDnjyyLCxB/X8/cfCOk9uOVBAivif90jmFrl5ykcGVOKKQNxTv0B7NGVzgmOu2V/uf5EWyfSrjrMklS2IDN/jKsefKQEaXOW1rLLUA7kUFCCvB+xf+quopxBjrrJ8JvMWb8uiRa2wQ6jZm1pzTD0wZSf/OLYHBpd7/KA+Tbr/LcJ9fX8b01h+xLhUoqAWT8x2SWwo7CD7mC0iWUdoa+svtWaZWekx0wzGq04fPPwLDMP3in6TwSkmWWs/2MX+QbOH1q43bRBjVpUQy/ivqFIStNcG6eGU5LniXSAvS2LyRo7W/iNngEo2gPaW4CexFAQvwcOD0VIT4zurnSaokMXOiR4h2XClCQxyW/y0lOYuynpeeE5W9Y6A2K0leydR2CjArkRA7LjS9yt0mJELT7n3Kbim+zS+98xCwKZzFTvOEI8UyEJlLwgZkO3uLdM214aHoNFY+AC
 ClB5AGpW
 qwwj1rXXFoS7bUfAUZwu3GqLNt5jKbMJUPQR7L+jZhYqBGIHrEzrj9W/L+moRL6zRkw4jw37HrvB904tRaGDnVpf7AZRi19DPihqqXQjBDSDAcy7vYSSWQkYVdC84tpen5TIqph78Ug4MgpDtfj/CcOJ7EBphCB24g2PAfX6VAFnxkYP6pnCea6BA3wU9naThvFPrrpkrF8ZhXvZqNcuNEF6phLi6lxQlVnP27vJbIMiwiox3hBHhNrSvO4C23akBjdgvjLSUfRozDPKtFpGzWNteMGYjZRHXBvm1VgtovCbKerNT/v7AZSG+Vm+x3y7Cf06KAnSJg4Loq0I+m+PX1qBoAIxXaRZ21E15M4EteCn+m+sBU+N+Qil3nb0qlh4o4r4hsocP0wdlAhMx0E32V6z4clS+0wNipbYVWwDes/xxbLBx8m7w9UO8rM/QXWaGUCnALK/nTdpRyPEtbQVjCOyn8V9aXlrqmLkxDQbrBs3n2SRoDowDRuPCdMAkiovPl1ZezNGGTvMDk3vMqzu49vst1mInA+enryRQIp08eMNQ0QZZqRnkY82FLB+oNxFwhevdTXGueooidjGdcjHg9jT5q5qGgzCfoI/0hNeG6W8nGOPTW85PN7Mr0rc2SHv6k5lpr68dtQphBdZ3h9Jpz6oCnUKhtolP9L23o2JKPr1N6Fj0xrPmgbAlmphwLPAt+gfdsUdDBYdr6Lg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This is the fourth RFC of the patchset to enhance page migration by
batching folio-copy operations and enabling acceleration via DMA offload.

Single-threaded, folio-by-folio copying bottlenecks page migration in
modern systems with deep memory hierarchies, especially for large folios
where copy overhead dominates, leaving significant hardware potential
untapped.

By batching the copy phase, we create an opportunity for hardware
acceleration. This series builds the framework and provides a DMA
offload driver (dcbm) as a reference implementation, targeting bulk
migration workloads where offloading the copy improves throughput
and latency while freeing the CPU cycles.

See the RFC V3 cover letter [1] for motivation.


Changelog since V3:
-------------------

1. Redesigned batch migration flow: pre-copy the batch before the move
   phase instead of interleaving copy with metadata updates.
   Simpler design, avoids redundancy with existing migrate_folios_move()
   path.

2. Rewrote offload registration infrastructure: Simplified the migrate
   copy offload infrastructure design, fixed the srcu_read_lock()
   placement and other minor bugs.

3. Added should_batch() callback to struct migrator so offload drivers can
   filter which migration reasons are eligible for offload.

4. Renamed for clarity:
   - CONFIG_OFFC_MIGRATION     -> CONFIG_MIGRATION_COPY_OFFLOAD
   - migrate_offc.[ch]         -> migrate_copy_offload.[ch]
   - drivers/migoffcopy/       -> drivers/migrate_offload/
   - start_offloading/stop_offloading -> migrate_offload_start/stop

5. Dropped mtcopy driver to keep focus on core infrastructure and DMA
   offload (for testing and reference). Multi-threaded CPU copy can
   follow separately.

6. Rebased on v7.0-rc2.


DESIGN:
-------

New Migration Flow:

[ migrate_pages_batch() ]
    |
    |--> do_batch = should_batch(reason) // driver filters by migration reason (e.g. allow
    |                                    // NUMA balancing, skip other), Once per batch
    |
    |--> for each folio:
    |      migrate_folio_unmap()        // unmap the folio
    |      |
    |      +--> (success):
    |           if migrate_offload_enabled && do_batch && folio_supports_batch_copy():
    |               -> src_batch / dst_batch    // batch list for copy offloading
    |           else:
    |               -> src_std / dst_std        // standard lists for per-folio CPU copy
    |
    |--> try_to_unmap_flush()                   // single batched TLB flush 
    |
    |--> Batch copy (if src_batch not empty):
    |    - Migrator is configurable at runtime via sysfs.
    |
    |      static_call(migrate_offload_copy)    // Pluggable Migrators
    |              /          |            \
    |             v           v             v
    |     [ Default ]  [ DMA Offload ]  [ ... ]
    |
    |      On failure, folios fall back to per-folio CPU copy.
    |
    +--> migrate_folios_move()      // metadata, update PTEs, finalize
         (batch list with already_copied=true, std list with false)

Offload Registration:

    Driver fills struct migrator { .name, .offload_copy, .should_batch, .owner }
    and calls migrate_offload_start().  This:
      - Pins the module via try_module_get()
      - Patches static_call targets for offload_copy and should_batch
      - Enables the migrate_offload_enabled static branch

    migrate_offload_stop() disables the static branch and reverts both
    static_calls, then synchronize_srcu() waits for in-flight
    migrations before module_put().


PERFORMANCE RESULTS:
--------------------

System Info: AMD Zen 3 EPYC server (2-sockets, 32 cores, SMT Enabled),
1 NUMA node per socket, v7.0-rc2, DVFS set to Performance, PTDMA hardware.

Benchmark: move_pages() syscall to move pages between two NUMA nodes.

1. Moving different sized folios such that total transfer size is constant
(1GB), with different number of DMA channels. Throughput in GB/s.

a. Baseline (vanilla kernel: v7.0-rc2, single-threaded, serial folio_copy):

============================================================================================
       | 4K          | 16K         | 64K         | 256K        | 1M           | 2M         |
============================================================================================
       |3.55±0.19    | 5.66±0.30   | 6.16±0.09   | 7.12±0.83   | 6.93±0.09   | 10.88±0.19  |

b. DMA offload (Patched Kernel, dcbm driver, N DMA channels):

============================================================================================
Channel Cnt| 4K      | 16K         | 64K         | 256K        | 1M          | 2M          |
============================================================================================
1      | 2.63±0.26   | 2.92±0.09   |  3.16±0.13  |  4.75±0.70  |  7.38±0.18  | 12.64±0.07  |
2      | 3.20±0.12   | 4.68±0.17   |  5.16±0.36  |  7.42±1.00  |  8.05±0.05  | 14.40±0.10  |
4      | 3.78±0.16   | 6.45±0.06   |  7.36±0.18  |  9.70±0.11  | 11.68±2.37  | 27.16±0.20  |
8      | 4.32±0.24   | 8.20±0.45   |  9.45±0.26  | 12.99±2.87  | 13.18±0.08  | 46.17±0.67  |
12     | 4.35±0.16   | 8.80±0.09   | 11.65±2.71  | 15.46±4.95  | 14.69±4.10  | 60.89±0.68  |
16     | 4.40±0.19   | 9.25±0.13   | 11.02±0.26  | 13.56±0.15  | 18.04±7.11  | 66.86±0.81  |

- DMA offload with 16 channels achieves ~6x speedup for 2MB folios.
- Larger folios benefit more; small folios are DMA-setup bound.

2. Varying total move size (folio count) for fixed 2MB folio size,
   single DMA channel. Throughput (GB/s):

2MB Folios | Baseline    | DMA
=================================
1          |  7.34       |  6.17
8          |  8.27       |  8.85
16         |  7.56       |  9.12
32         |  8.39       | 11.73
64         |  9.37       | 12.18
256        | 10.58       | 12.50
512        | 10.78       | 12.68
1024       | 10.77       | 12.76
2048       | 10.87       | 12.81
8192       | 10.84       | 12.82

- Throughput increases with batch size but plateaus after ~64 pages.
- Even a single DMA channel outperforms baseline for batch-size >= 8 pages.

EARLIER POSTINGS:
-----------------
[1] RFC V3: https://lore.kernel.org/all/20250923174752.35701-1-shivankg@amd.com
[2] RFC V2: https://lore.kernel.org/all/20250319192211.10092-1-shivankg@amd.com
[3] RFC V1: https://lore.kernel.org/all/20240614221525.19170-1-shivankg@amd.com
[4] RFC from Zi Yan: https://lore.kernel.org/all/20250103172419.4148674-1-ziy@nvidia.com

RELATED DISCUSSIONS:
-------------------
[5] MM-alignment Session [Nov 12, 2025]:
    https://lore.kernel.org/linux-mm/bd6a3c75-b9f0-cbcf-f7c4-1ef5dff06d24@google.com/
[6] Linux Memory Hotness and Promotion call [Nov 6, 2025]:
    https://lore.kernel.org/linux-mm/8ff2fd10-c9ac-4912-cf56-7ecd4afd2770@google.com/
[7] LSFMM 2025:
    https://lore.kernel.org/all/cf6fc05d-c0b0-4de3-985e-5403977aa3aa@amd.com
[8] OSS India:
    https://ossindia2025.sched.com/event/23Jk1

Git Tree: https://github.com/shivankgarg98/linux/commits/shivank/V4_migrate_pages_optimization_precopy

Thanks to everyone who reviewed, tested or participated in discussions
around this series. Your feedback helped me throughout the development
process.

Best Regards,
Shivank


Shivank Garg (5):
  mm: introduce folios_mc_copy() for batch folio copying
  mm/migrate: skip data copy for already-copied folios
  mm/migrate: add batch-copy path in migrate_pages_batch
  mm/migrate: add copy offload registration infrastructure
  drivers/migrate_offload: add DMA batch copy driver (dcbm)

Zi Yan (1):
  mm/migrate: adjust NR_MAX_BATCHED_MIGRATION for testing

 drivers/Kconfig                       |   2 +
 drivers/Makefile                      |   2 +
 drivers/migrate_offload/Kconfig       |   8 +
 drivers/migrate_offload/Makefile      |   1 +
 drivers/migrate_offload/dcbm/Makefile |   1 +
 drivers/migrate_offload/dcbm/dcbm.c   | 457 ++++++++++++++++++++++++++
 include/linux/migrate_copy_offload.h  |  34 ++
 include/linux/mm.h                    |   2 +
 mm/Kconfig                            |   9 +
 mm/Makefile                           |   1 +
 mm/migrate.c                          | 133 ++++++--
 mm/migrate_copy_offload.c             |  99 ++++++
 mm/util.c                             |  31 ++
 13 files changed, 748 insertions(+), 32 deletions(-)
 create mode 100644 drivers/migrate_offload/Kconfig
 create mode 100644 drivers/migrate_offload/Makefile
 create mode 100644 drivers/migrate_offload/dcbm/Makefile
 create mode 100644 drivers/migrate_offload/dcbm/dcbm.c
 create mode 100644 include/linux/migrate_copy_offload.h
 create mode 100644 mm/migrate_copy_offload.c

-- 
2.43.0


