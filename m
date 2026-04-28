Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E5C31FF8868
	for <linux-mm@archiver.kernel.org>; Tue, 28 Apr 2026 15:55:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3D4456B009D; Tue, 28 Apr 2026 11:55:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3AC016B009E; Tue, 28 Apr 2026 11:55:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2C5586B009F; Tue, 28 Apr 2026 11:55:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 1FF4C6B009D
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 11:55:37 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id B59D487807
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 15:55:36 +0000 (UTC)
X-FDA: 84708414672.09.6DBD145
Received: from DM5PR21CU001.outbound.protection.outlook.com (mail-centralusazon11011020.outbound.protection.outlook.com [52.101.62.20])
	by imf19.hostedemail.com (Postfix) with ESMTP id AC4E91A0014
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 15:55:33 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=3nAXM7Ge;
	spf=pass (imf19.hostedemail.com: domain of shivankg@amd.com designates 52.101.62.20 as permitted sender) smtp.mailfrom=shivankg@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777391733;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aZQWCWPN4P6SLdJrwctFxsaENiyxGoZvFwaflD3cq98=;
	b=npRrTWmzNZFKTv2AfQGU9t2MEpyAM6gHGCLiBDl8HQiXfUOE9wIFUJHnIIGoVfwU3c5V/k
	aYY1Wz2bPDf2VpD1MUmchfp4BAQV4+p86KQRhXcFSWVd7ulGECQnXfIBiUWZdZmpr4XBnN
	G+8ZAN80Vkp14e/WHQT5P6u4zAHFVbM=
ARC-Authentication-Results: i=2;
	imf19.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=3nAXM7Ge;
	spf=pass (imf19.hostedemail.com: domain of shivankg@amd.com designates 52.101.62.20 as permitted sender) smtp.mailfrom=shivankg@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1777391733; a=rsa-sha256;
	cv=pass;
	b=UZ49QH3oxA8woyYvpFpetoVYUixGn/Bjb9iVpKSBC0FEI9H82jDyg4PJcwc+5/4kOrAIiA
	17563A0zp4yPXMo9lYfYAMzql9F4JQIIuYSdJfez9+mycqf4PrLQEzCIqABZmh5eTac1N9
	y2iMvAHXSRTNWsrY8JVyIvGETlf1D2c=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=xScbdTWVHDdGOJpAdZtMPJLq7ZH2W3EUZartltLkc5VtvLOoC1rC1KE6KZ6qV6EmMknc3eeOFeWQCKvCDW3Jz90YILXkkk52z2b9NjN+kBoDtFJGgOwuzbddEXLAef4pIPzklkDOqu1tHMVTYIvnGe3DikoeSm8Ag4oDo+eFa1ptLC1pbmdZN1msH00ibTfYLa9m60VWPnwFpUIStSygkwHalmKwlJxj4BrGme7Y/QY49twmSpBpCQrTya1QdfOL75iCT8SkJneWOQLOsgKCztO5euYfem+Zq1lDJOr50syxYXC4CIgBBeg75Xb2kY+BwlGY4OImN0/6QwBs4Vgyng==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aZQWCWPN4P6SLdJrwctFxsaENiyxGoZvFwaflD3cq98=;
 b=Q7dV3ZWMNGDz8f0PneNYpmzgdYqDoc5vcOFoI0QiDTdJ5qJBSlGNzVWvAsSDIU+ehwnky0msuDfuo1pIxWZy/3E92oQMXfwLFSgFbX884CazIfez2ZfAoawCfE2VZjB5h8sNjKHv//2NKxUZNXKyf0il7L37HQi5LegNfkPkeIsgZwYHsG0+Pj8OfcCWHXFCiYsDBN7tKfzC79/PUGbXWShfibALI1PkOSWZaCW4ah9XF4tLDEB3+rXLKVui9ZFx0Fdn/TIWDUz6fi+AQT2ulQVlMI6xWh5xr8vK7hvWHR29n22lom6qzcBUM7laqx9OU5FIQpUWQhYGG6/G593ekg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=linux-foundation.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aZQWCWPN4P6SLdJrwctFxsaENiyxGoZvFwaflD3cq98=;
 b=3nAXM7GegHcLZT1cItCp8hRau6kRPEudXhPfKKD8Rz6jR8+u5fdchZYWXsr0mquKVd9Es7Lbkvvo02UOgWpNIm6w1Ce3b/ioWzemmweR6lULhb/QkPG3IrZax4zfIuAl+FdbPEWLyDB2LKst0hf+Dub8o89VO7jPCEIWDTj8zt0=
Received: from BL1PR13CA0362.namprd13.prod.outlook.com (2603:10b6:208:2c0::7)
 by LV2PR12MB5992.namprd12.prod.outlook.com (2603:10b6:408:14e::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9870.17; Tue, 28 Apr
 2026 15:55:29 +0000
Received: from MN1PEPF0000F0E2.namprd04.prod.outlook.com
 (2603:10b6:208:2c0:cafe::21) by BL1PR13CA0362.outlook.office365.com
 (2603:10b6:208:2c0::7) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9846.26 via Frontend Transport; Tue,
 28 Apr 2026 15:55:29 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 MN1PEPF0000F0E2.mail.protection.outlook.com (10.167.242.40) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9846.18 via Frontend Transport; Tue, 28 Apr 2026 15:55:28 +0000
Received: from kaveri.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Tue, 28 Apr
 2026 10:55:17 -0500
From: Shivank Garg <shivankg@amd.com>
To: <akpm@linux-foundation.org>, <david@kernel.org>
CC: <kinseyho@google.com>, <weixugc@google.com>, <ljs@kernel.org>,
	<Liam.Howlett@oracle.com>, <vbabka@kernel.org>, <willy@infradead.org>,
	<rppt@kernel.org>, <surenb@google.com>, <mhocko@suse.com>, <ziy@nvidia.com>,
	<matthew.brost@intel.com>, <joshua.hahnjy@gmail.com>, <rakie.kim@sk.com>,
	<byungchul@sk.com>, <gourry@gourry.net>, <ying.huang@linux.alibaba.com>,
	<apopple@nvidia.com>, <dave@stgolabs.net>, <Jonathan.Cameron@huawei.com>,
	<rkodsara@amd.com>, <vkoul@kernel.org>, <bharata@amd.com>, <sj@kernel.org>,
	<rientjes@google.com>, <xuezhengchu@huawei.com>, <yiannis@zptcorp.com>,
	<dave.hansen@intel.com>, <hannes@cmpxchg.org>, <jhubbard@nvidia.com>,
	<peterx@redhat.com>, <riel@surriel.com>, <shakeel.butt@linux.dev>,
	<stalexan@redhat.com>, <tj@kernel.org>, <nifan.cxl@gmail.com>,
	<jic23@kernel.org>, <aneesh.kumar@kernel.org>, <nathan.lynch@amd.com>,
	<Frank.li@nxp.com>, <djbw@kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-mm@kvack.org>, Shivank Garg <shivankg@amd.com>
Subject: [PATCH 7/7] mm/migrate: adjust NR_MAX_BATCHED_MIGRATION for testing
Date: Tue, 28 Apr 2026 15:50:51 +0000
Message-ID: <20260428155043.39251-16-shivankg@amd.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260428155043.39251-2-shivankg@amd.com>
References: <20260428155043.39251-2-shivankg@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: satlexmb07.amd.com (10.181.42.216) To satlexmb07.amd.com
 (10.181.42.216)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN1PEPF0000F0E2:EE_|LV2PR12MB5992:EE_
X-MS-Office365-Filtering-Correlation-Id: f7e80da6-571d-4c74-1c41-08dea53e9201
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|36860700016|376014|7416014|1800799024|22082099003|18002099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	wckO9DmWPkYv4D7vDFx4QbziyWlkpD1gHiB5R6GuDTi5lG6VOVfTFyJI3AmXUKFQXWo9jcpIT++C4NAtdQvfnfKmZ24kiNvwRg0V5/QEWFMCzf3xKs32QZ8+DVn84lalPJBRNpIk4zWsQJJHyIe3WnKdGDHAQ2mSNDjQk6mL5GFlnpZVm+X5sFHwu3rLdat61EhhXyjWnMJb5mNoRDHdrFimyR7GIZC4QJMjtnv29JFoUYZGycaEXLphguL97fCGVq0tup7NsB27fGxsAUfmjGNzOqZUF6OcEc49j0E2XivN39L5GviBF9ww1ItIiOkKtriPAMGzBTGZpMYaIOrUmNkisCIqjJ6kwUCPJlyBiv4BqeUjk23V/yB2HnQLXdHYPDBrwC4GKjWKxIuHpxeSYtcbRfMI287EnCKlH2LP6jR5F/b2Lst30bqUpZxIKfFylQ5GM6XikvhliiX/4Sz6akyl2fmWF4B4wYs8Y+61QUqjF3u5spFvKrJnjN6SQgxGFrAtLPFSK5q/nUikHOZ7sBKlfYAmpzm9B85WTLPknBt3SzvywDWYn5CrDtKiaZqSd8QnS0Se5xNgHIV5gv6xI4mo5kV0Ko7x89Qdb97vtGtaW2z1a96L3tdh22lVHr0qufnKkin3Xi15Hx0g7HVvCl+qClRbTR4qVjhpgyj8vdjeATmwWUte/5FikjNuKGXqIl5ySaSCYK8i1rkTXboEBEJfcVcjzlQZBAGEYutROhyndGsX9lbREIPc8/QYHrcGca5yH4dJGR7afWHvfo3Xgg==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(36860700016)(376014)(7416014)(1800799024)(22082099003)(18002099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	/eKYAjQselOYYrgSw1Vnp1CtTVZcg4btuLcgIti7GVqC/jQykYQNt/ftwFxpMMMJMkJWmo0Fu+qHikH5Lx7EogXd1xSoyb5TFdF/nk72oGpfY/50PRo0pFlLE9HxNLyDAgFijIILa1NF2voY5mXwfyLpwoqYbEjDZcaSkxXZLOrcjkOPAiZwAds5+5gnRY6guqg/hHrUuoB+af6CLlbVcJHzUFRc0kUUs/Uj1MnJeaXFixwg3rFIEQGdclB4z1a++vF20EtPyGN1PmhO6vvYeWDdPXjSVvhir6exSpb5uYS0Z+AM4QPE30XhxXW0e66uhe+bz9K2pxgYs1GXMJwSUGoMMnuITdoMlkk1OI0UZoso8Hlt2g/Bq19r8/0aW7/Z8ix6s1nXCt2Vzk/DAaN+o9VnjBhZTpnXX1zNCLVHLJK1sinIEaVn0ntRYsH/X0ln
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Apr 2026 15:55:28.7581
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f7e80da6-571d-4c74-1c41-08dea53e9201
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MN1PEPF0000F0E2.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV2PR12MB5992
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: AC4E91A0014
X-Rspam-User: 
X-Stat-Signature: uxyz1f1n3x3j5uxumfqwo9ntpaoaqjnd
X-HE-Tag: 1777391733-964494
X-HE-Meta: U2FsdGVkX18wpE1P7MlC8v8i4MoL0BGzJ5ErmFePNQo2wLhMUAbPiUDQtm/rdKuBnyIR85jDWh5rRXsPjjaz/Tj1MjMEgeQo1OzSl6Eeb+yfF2M2nKvD/agGca9XyYAp6nBi9O1IaWXLN8Bv0gUOZUkhhqrsDLuh7pr3qb0pL2bDovDshZVva9TLlUcSyziMF4wC/Qiz1dGtipe00rQTb7Vy5kGZV9wWBh6wCukcSgRyANDelONY+IWCFqJ3qMFgBrhcJ9oemmuHx9Vw3N3T/COqVsIWj50l+cnRgSpq3NWS/Gqp4U1B5/HhTCASty/aSwI8lD1gHKxwvr2dxh5DG8hHPfuHLqY00Yhk69TwjRnRKxnzZJC+/H7o9o2GE1JZ8IVTSJMDYctST+N0bThmnZXx4SPihKqQKIEcz/CiBULRxcUvcbnS6YuaHpL/S/70vxUj3aEQbvhVxu0VVR2RYeA92nNDXdDWzboU6Z/KF9yA08b2DyPpzW/85FuNrF1c1F22VMa7M3iqgyqLISatUv/bZr4KurutVjNPkIotG2oM6nSHk6JHSqjHcMVNrzxF543p/IvEEDGuADdtTJvqTg6VLKmLkGOfEyFwJLz4EjmAcNzhKPIuOJPsg6p7n82ZQ9+yhb9pJNCep2LQMFBETQo30JtIwu7WBaUXmMngj0xB8/ZXmuzX5uYewfyD/K+VKGIBaRB65z4QiHoT6toy3BpvxwMNfgsVDe1cZ2FJGjXiz1ejJ0GJATxBaHQOX+wOH6VZrRMuUQhcFFUFTeUPRszqTrRHSQGJmXOl5jeC+GQ2KTaQGpEqRQv2A7XeBpbEFguWilcblQBrYl9rEX4Q7FAq9oy2ha7WohxgZtmb5qXJNicbA4321gWkzush1IEoplHnrXUIRXYD3NKOowNDNLNSxYeXfFCYIGBDkfKdGflsLZuoGNRKLpT5wfiEabCenT+YFV43Rvy4hiwNXg7
 zUdDD8Fc
 HguZT4na6Ysj0lGmXJRkv9CIj48ZrdEBjteKOB53fR2J1NPF2ckKfMHbB+EvmxP13TBIvhQ/M26Veek6rK/YxbaCnJU6Si4/EDGgKfq6V9mkKdSq4GCKwcbbvXvwGUKInAsbr1VvIWA/3EDy+dsYl7TclLM68ZHyChwzO3uA1F+53VNjg/EDQUNZoc+KIR8C6RCUGwS6EMgf4z24YDrSfmg2Wj9NVvRb7BNJb5YNRcolvi1RPdSKb7P5xZqVfbj8bRKQ0Tq/l3gM9LEgjQQPC+/7zfBmTxJDVDy7jSLLfeFrEo32Llbr0fvLgDZd77dhbcXKj21YDT9pL8OD6NIuyPXV89Ij9CRxKVraJAOxw8vIxQQ2Vddy87a1Rx7vR7TUVrzZ/Hu+BqLaAqUq9wwVrUw/IB+Bml88iaY3byUWS+RKKW4P2kPf0dDRigVA/zrfJ9SDn1MJ1+HnPQ9+23+m6xlCVYBtEbezVI/SylAqtsf1JzLiSaOdfq/iA8egXJTZiRbBxa9B8oM1peLPHd71qYQB1GKQnW9q0v1dwLiq4YqcjGBVPefoflzDbnbXhfl0ZiLAbBYQynHaIEaZxJo0wxqQlvt0/Zj0Pr3/bMRm5x63LScBGgH//hbI++Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Zi Yan <ziy@nvidia.com>

Change NR_MAX_BATCHED_MIGRATION to HPAGE_PUD_NR to allow batching THP
copies.

These are for testing purpose only.

Signed-off-by: Zi Yan <ziy@nvidia.com>
Signed-off-by: Shivank Garg <shivankg@amd.com>
---
 mm/migrate.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/migrate.c b/mm/migrate.c
index 9af070f9a1f2..a16c009d31d0 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -1658,7 +1658,7 @@ static inline int try_split_folio(struct folio *folio, struct list_head *split_f
 }
 
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
-#define NR_MAX_BATCHED_MIGRATION	HPAGE_PMD_NR
+#define NR_MAX_BATCHED_MIGRATION	HPAGE_PUD_NR
 #else
 #define NR_MAX_BATCHED_MIGRATION	512
 #endif
-- 
2.43.0


