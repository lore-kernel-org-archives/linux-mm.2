Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AB2FACD4F26
	for <linux-mm@archiver.kernel.org>; Fri, 26 Jun 2026 09:38:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 92B706B00AB; Fri, 26 Jun 2026 05:38:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 902356B00AE; Fri, 26 Jun 2026 05:38:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7CA136B00B1; Fri, 26 Jun 2026 05:38:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 53B986B00AB
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 05:38:30 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id C4D64A03F6
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 09:38:29 +0000 (UTC)
X-FDA: 84921563538.04.9FDF571
Received: from CY3PR05CU001.outbound.protection.outlook.com (mail-westcentralusazon11013058.outbound.protection.outlook.com [40.93.201.58])
	by imf03.hostedemail.com (Postfix) with ESMTP id AC72620004
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 09:38:26 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=rVcFYVHy;
	spf=pass (imf03.hostedemail.com: domain of shivankg@amd.com designates 40.93.201.58 as permitted sender) smtp.mailfrom=shivankg@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1782466706;
	b=QicNhwad263o9K2Qz5BOssT9/8DN06sKk6kHerP/9BoY4z9nDrvlG9lp00a3UdP4VWR+Ui
	A+KxWgfLjM7i+8UTeWlvTx2EpAxZEwjbg6qFYxF8kz9z5bmJpMicO4bKHtuov3xROxyMZO
	Rz9yrcT2nHUdSIKeqEUXRhpNb5WK7C8=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782466706;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8RkvgKj92Vmi+6506wXzt35MaDaFnCrRBD+B58tB3lA=;
	b=lDYspuIA69F8MBYRXRrnvHYq3uqxgE0pwO0V6sJZdsWYf1v9SZYH+QVA+lfG8s30kjhIW5
	PMbca5r0tejJtqsxEo4v5fSDOzf8ofCw3dkduOGXhd2Cigqkv+68ehrbs13i12G5K1Fuzl
	3WRsqa+vbDB5rljhwDoyzX2J5vvT18c=
ARC-Authentication-Results: i=2;
	imf03.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=rVcFYVHy;
	spf=pass (imf03.hostedemail.com: domain of shivankg@amd.com designates 40.93.201.58 as permitted sender) smtp.mailfrom=shivankg@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=zW4e9pS7EGzQ6nCqScUT/p/Z8Or+2nQHqPy5TS/dzgzZWv4apnLvzDxY8RoZd3efqc7tqQes+XAAevQpe+ExFR3YZ3DU09ScwCyyjvgDAy678IrHVSj+o+t5vTYLspBw1bd5pZGxmMvMBHbIYnngj3Qw6+jRu6jZxxZOAc34g7j3rTOTxd9mBvpyYflVy14pR1/5rqUZm11bGHq0Srpwg0cHInvJ6sfb3vKl35U5NtIC862PiH+VvnWjPnbZkVPWSzwrwJ7ZvluygHRakxKHD1sxpTJzGtmL4DZYGhnlSEhE6m47M9OuCojOKs3qHgqNac6zJFjw4kMcC5hPcB0aCQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8RkvgKj92Vmi+6506wXzt35MaDaFnCrRBD+B58tB3lA=;
 b=AiI0GxenQxK9TRk8FSfpD0PSBahHyliaEZcJxIwP7dc162+ZD0LL1sBzX9RXxXSgjnjnkBdOlD52482Gp+DpWYn7XU+0sg3QHj650VDQ9UgD+uYoNCvOrYjKahTMnQ2dz4UOFpF7QbEkACVkFCImLVpmyTyeSmV+NyRADodylLrR9TuMrvHr8bzoDjGGVhiPBsmJMM0/gLYRxsZ9vzLfI7E78OtMSzpjr21IxOAqeLuxGQb2C+EULFzKOAy9w/d5wNez+NYqcLIl+HT0iBS/cDxYW2bEL5dvSDZ8h5smi9GLUzIwiErZ3upT6eVTgowTKr0/Jn3aAoCWsbPKpfWS3Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=sk.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8RkvgKj92Vmi+6506wXzt35MaDaFnCrRBD+B58tB3lA=;
 b=rVcFYVHyoEYs31ykjD8oPhoit8+Q9j1usisUAQ2a4wyGKT8MBxj/bddBdJaRbis3LmoxwPV0mwBGK2g9h5aUbo7E87lb89pJOKQ9/ryLq9wc5znPrT9AnHoy6Jg7PuaMBjVLLMPFrhidfkSz7RVnnuIrdGUjuMnpH5SstWgb2W8=
Received: from CH2PR10CA0025.namprd10.prod.outlook.com (2603:10b6:610:4c::35)
 by IA0PPFFEC453979.namprd12.prod.outlook.com (2603:10b6:20f:fc04::beb) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.159.12; Fri, 26 Jun
 2026 09:38:22 +0000
Received: from CH1PEPF0000AD78.namprd04.prod.outlook.com
 (2603:10b6:610:4c:cafe::47) by CH2PR10CA0025.outlook.office365.com
 (2603:10b6:610:4c::35) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.159.15 via Frontend Transport; Fri,
 26 Jun 2026 09:38:22 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 CH1PEPF0000AD78.mail.protection.outlook.com (10.167.244.56) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.181.6 via Frontend Transport; Fri, 26 Jun 2026 09:38:21 +0000
Received: from [127.0.1.1] (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.41; Fri, 26 Jun
 2026 04:38:16 -0500
From: Shivank Garg <shivankg@amd.com>
Date: Fri, 26 Jun 2026 09:37:49 +0000
Subject: [PATCH 2/3] mm/migrate: fix stale list name in
 migrate_folios_move() comment
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-ID: <20260626-migrate-cleanups-prep-v1-2-a95933af7619@amd.com>
References: <20260626-migrate-cleanups-prep-v1-0-a95933af7619@amd.com>
In-Reply-To: <20260626-migrate-cleanups-prep-v1-0-a95933af7619@amd.com>
To: Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand
	<david@kernel.org>, Zi Yan <ziy@nvidia.com>, Matthew Brost
	<matthew.brost@intel.com>, Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim
	<rakie.kim@sk.com>, Byungchul Park <byungchul@sk.com>, Gregory Price
	<gourry@gourry.net>, Ying Huang <ying.huang@linux.alibaba.com>, "Alistair
 Popple" <apopple@nvidia.com>, Lorenzo Stoakes <ljs@kernel.org>, "Liam R.
 Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, "Mike
 Rapoport" <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, "Michal
 Hocko" <mhocko@suse.com>
CC: <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>, Shivank Garg
	<shivankg@amd.com>
X-Mailer: b4 0.15-dev
X-Developer-Signature: v=1; a=ed25519-sha256; t=1782466686; l=719;
 i=shivankg@amd.com; s=20260518; h=from:subject:message-id;
 bh=6gkWCbAUUwOv2aQ/a2vt2NUaojmIgRUlLK7x1/r5aHg=;
 b=ruFVVWpBi2T2nvOgh5Ewxqx2HOzoTzBlVKMrIwVGkeDEay1ujmHnTg0DRjZ7GZpCjwZU+q2xg
 gszR5AOmbBiB6LTf1SAlP8WKuT98G8LhLncWODDQh1/1xo19G/sHZhf
X-Developer-Key: i=shivankg@amd.com; a=ed25519;
 pk=2l2QGTeXuGkZTtfmx0nPQU8iFZfjYmX/ymMojitevx4=
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: satlexmb08.amd.com (10.181.42.217) To satlexmb07.amd.com
 (10.181.42.216)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH1PEPF0000AD78:EE_|IA0PPFFEC453979:EE_
X-MS-Office365-Filtering-Correlation-Id: ef8f318f-6dba-4ae3-2af5-08ded366a95d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|1800799024|36860700016|23010399003|7416014|376014|11063799006|56012099006|921020|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	WwoiM3MNmQjqzaO/9jqu3dGWIuAygGydD/i7RvzV5C4jgH2sUb2t3JPGtu5FwHyP4dLrNDbAv/HXlRQi6XwSDOxwiG4dVNYzXtIuutwA5pm5fULyc4r7fQWHy8rFLIH6oK/JUyPLwRUpNzDmIou+G3yGaJzOzPqqYA2qwhQriG1a3EVtPP2rdBSkSJrjNp9Ka1hJpFPCEym4/jNeDyf6IqSluDclDqldLTula/4G/Ew3iHF4FiurqZeTRG8dGwio1plsc6EiXZCltkOfDNBDSB61yVvYwWd0ScU3OB05M/D18Ky8cTS+E0aP6+FPApzoE14zkLdArP7nMjsmwRVGBiDKL0zoZBLQjJxFInVfZ6kcpxQIugNAvs2bL6bWJLlXmc5gTucEn6qCvag29ftnauzrA4mbKNKKQXTGBJcYnIaSb9AvR1+Zlkb5eKmFOlEhUXEcymxif9bNmCLO4jKN/1ujf3W612V/PXjGv0HUrciGkD3K9h27pIuuofQf7I6L6Ti2fio3K4UDMFrLRcYN3/5N74fJSLL/IqRcrJZu6+n6bIV+79Utap17NVtiTdA/uOgAcyIPMoPpBKz6xeRskF3uJj2e9KBRkhswvk74mv8eBq21tWLCSRdznwRMayrr8AgXwcL3rCi0rh9pvVsqC3LH90On4WKshpSsq0WuKkOmy1sh2MsWACcWyqpTCOuZk8gXewGyb48iP203Emr5dmdjeIHtNnnFTBN9P4DnZsEqwnAvn3WrYhHM/l7pbCuc
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(1800799024)(36860700016)(23010399003)(7416014)(376014)(11063799006)(56012099006)(921020)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	gYkh8XxVK/3S9E5FFk48x44h0+w3NmhDhem1X6MUb00N7ORX25ha+HbXJvQiKVSxfvZWJACqoUAbMnT756vL4JsfOICwNQpSQqMQWhfYUIAiatlgd6QpJjQYKPDoHZ8JAUE2GFEocj9BTJJO++JkAcy0DOOP42u7NyKZW5MbROFdrhex7MjPiIHqv18byYQh3Dl7IjYr/mcUmZjzgSeMb07AUK3c4CsSU8JpYkOSuGUN5hVCbGM47i3f/K1H3jzA0y7K0ihNX+ppOaEw7qddpL0sVFVzZqkZClZj82Ja2X0aVznajEvyuvdduOYGUF+oId2hCV85UK4mxOUr78zD8gFf25zwmoZJC2RbQUFFNcEfkBlYFmLlgrOlKtajZsdpXQ/pZexQhnBntqX+JcfaYIube3V8vbP+qKJMdiZB2Tt40RtOcTpkTKn+LgauIzn2
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jun 2026 09:38:21.4217
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ef8f318f-6dba-4ae3-2af5-08ded366a95d
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH1PEPF0000AD78.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PPFFEC453979
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: AC72620004
X-Rspam-User: 
X-Stat-Signature: 3bucdxuosgjwx5c3x5npqk8emuwwz67g
X-HE-Tag: 1782466706-351437
X-HE-Meta: U2FsdGVkX1969lbBTy5Xuh1QzbzOM4rGh1SAOLFa6XBkXqpLuvXTYXScZ+iJ+CYsGKe9ioAUsOKZedN1MPAFRaWmPgBPefV1/sGVkjldPu1mzXmsGz9n4B1GItgywzEoEJzsmYS8skc+dMPd4O4Th56HXqHPDgwEukllW+TkDusgdPt7Xh3vB/ChL7z9bsF7h2tNuo7AyJ8EMV6HiaLz+fK9gsErYVsYvjHtgxm4S9oshsxuGeYpTM9nnR7j4D0NQSU/4R/HoNhtzI1605Xx3TAp3Ttkz7CFI6zxhnBnHzdoZ2AkjGEVyqNqKrZftmrO1T3joV2n+M8ouYru6LCbblkeJY3PwCULKNiL/D+BEamDDAt0qSPE7zNyTqOj+KKFfJMctxI+M388qR8nyv4isyk6oBhbW7neiM9peZ7LTczAlMn3yJTCpjyw/w/E4r1hcMTvSwpB/61vnsl7Q13BPWzoXcA4Os6HmUnoTUp7NF96mpJjaR/+OV3uGAp/BNhJbAEYw9qX8qJl5XHwGf1Za00E6CWpzxToYjKBizLWj8m2N+lUlZ3YZ0gN0mH7Q3PHFdVImaEhyZu3fG0TqjDxA6uQg6N6RFE/bBUwQsCB30tzGf8rNbQfbSJieo+hFN9uPWHfJ5eVQP9ZN+rWdncxuptJDDcI8WG8Ul3/gF41U2kR6l3VijSxhK9wsP52G5HGcZfC4NI6xH/O7UORDCNULbKIwsa/mgjln0AyNO0EsAR3Lwt272C+dIG97EJqaDYFveTKYZq/XYHWmwZiakI0ljFhQOQFA2eDOX1ADxm3ESIgNX03GXcwqmB+gORASM6Y9JYeD/6C1aRJshc2fN9f1K02yPb/8tKLg0H3Il1dSLZnFZKMTnhVaKa/uBALrv3/jGclGj4hPCQ7FCFD++kmL90dz8Th7FOr5DShLwRGBVmNjb35p7cK9hAfGs9FSK20lMCpvSloehcnZBIsA17
 l023dB3M
 SMaNhBwsVZYHwDjB0C+8GUy8H+tGTyjmMmn6twJtqYiXIfd9iQ/nrowFfAp70T9QeWmOk6EP58rD8tRW6ZYSsAtSbqT45xD+gCJqPh8cp+2Fk4kntwbU3kkp1ZyAqwuDahwAMcPo4TGY/qGCeeVLjMDLOFQtGW1CyzLDNv7fgHJzkCIkm+89/jTqeEYUD6FQv4mT1AkwAyc0rS2saGE9y7v9AvY5PymhZLeAESugiCm7ot5NUxj6Pgr0O4zIi8rCXOzCsV9msHLL7ztH3g7MveQyVi4Vjg6WvAwWPVHx3O5hCPr+mEJAzbgyMZqkhm5fT2s4pBuw2rlz0E4oCXiLSXQUXMGQmfaJgvgSnRhaRtw96aFN1I2N/1CNHo/+Jx6/96CkUIljU+ZWu89r0JAzV4zh4hUzZFEeS4GXp2EqIBBXwt3V4bSAXrO4v+OgmWr4Vx6ZBt4nf8CyiNn34n5jT43EOXcWuYsGHHJiwQk4ucCppCO8puP8lLrk6KMgguM8VePrUFLJrN76h3tjYD/AN7s1/lyz+8g+2HyUBdJgruXg8d+HwGeUqDhMgyIUe+L8ZjTLMoW7VnGx6Usp8SVahrQjPhQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The return-value description in migrate_folios_move() still refers to
unmap_folios, but that list no longer exists. Update this name to
src_folios.

Signed-off-by: Shivank Garg <shivankg@amd.com>
---
 mm/migrate.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/migrate.c b/mm/migrate.c
index dd7dbd8d84a0..84b4c24f9dac 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -1738,7 +1738,7 @@ static void migrate_folios_move(struct list_head *src_folios,
 		/*
 		 * The rules are:
 		 *	0: folio will be freed
-		 *	-EAGAIN: stay on the unmap_folios list
+		 *	-EAGAIN: stay on the src_folios list
 		 *	Other errno: put on ret_folios list
 		 */
 		switch (rc) {

-- 
2.43.0


