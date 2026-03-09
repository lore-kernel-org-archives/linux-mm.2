Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 53EABF3C240
	for <linux-mm@archiver.kernel.org>; Mon,  9 Mar 2026 12:10:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C11786B009D; Mon,  9 Mar 2026 08:10:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BFC6B6B009F; Mon,  9 Mar 2026 08:10:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AD4EC6B00A1; Mon,  9 Mar 2026 08:10:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 9CFFD6B009D
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 08:10:24 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 3B416138EA8
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 12:10:24 +0000 (UTC)
X-FDA: 84526407168.27.7067258
Received: from CH5PR02CU005.outbound.protection.outlook.com (mail-northcentralusazon11012004.outbound.protection.outlook.com [40.107.200.4])
	by imf13.hostedemail.com (Postfix) with ESMTP id 2C14E20007
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 12:10:21 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=x5R36LK7;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=quarantine) header.from=amd.com;
	spf=pass (imf13.hostedemail.com: domain of shivankg@amd.com designates 40.107.200.4 as permitted sender) smtp.mailfrom=shivankg@amd.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773058221;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TR3oRfxs5cyBuNC4jQBCLsp1UO6m6Qelmv9JfK5I8Dk=;
	b=jrtwvt7Js1VhedlLZC6ZZ84a65TOWXf/+efQp6oZxosGWZdAQ6M3ajDGqD7N1NapZ2oHtj
	g81Z6Ax6dgNGBGa/2dynv/1uMg4O0w4qggxpYoLoA4DxBabyfDt0W3fTGDijSPXEh9VsbJ
	eb5Koc7IEtsNFWHbxPZ0r7aSKehgxm4=
ARC-Authentication-Results: i=2;
	imf13.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=x5R36LK7;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=quarantine) header.from=amd.com;
	spf=pass (imf13.hostedemail.com: domain of shivankg@amd.com designates 40.107.200.4 as permitted sender) smtp.mailfrom=shivankg@amd.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1773058221; a=rsa-sha256;
	cv=pass;
	b=6HGCqKsmb2fDkdDD77oKO7oalMQwlR9Jy5gIga9/IebfsySjAUw5/xb1Ffrz1Xp2wtNyuP
	KEuaDRYNQaT+OQ1S+xGxIpZORgXciXVlT35JwUY/T08qj84nNWJPFDAtK3a7zuhpHaRLit
	ExX8nTwsOaLBK1SGQ1VhUjBowGcMvEM=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=rxE4OXIKp0w8HACHVZtJ57Hm05WLLU1GF1DOYHFOlVDIYCMvKrkMOHit8ileQHJ0wAEx7nr7rZ7ymUsQ2x9G+rNE04FpOR79dtBbxweUlA0MzjRGNRrl9D3LBZLac7NbxiKDGEaslqaBo9vKjvZJyorHGrS+NaBqzmyk9DoIUB48d++xqTrzzJcS51yyC4qasfpA+9UMRZnpluzwwA+P0tR8fT6xnPsUjSwpqZ9res5bkUQroMSmwbef7f+lGu3ljt43Miy1QP8Qs9hC+Mrn7SC+wuQvb3kCUlixrEFnkClRWXDATHjOnqtrQ3gEZ//Q1TFjkLwiLVVLbWa9MP/hQg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TR3oRfxs5cyBuNC4jQBCLsp1UO6m6Qelmv9JfK5I8Dk=;
 b=uJON3VwPuMiIxgZ6yB6MJvcZ+vC+KglGU6tuz2kOY1lownBAshkwgFTmg1djas+K4dc/+m3j3yKQ6PDVzKdmlAdIYTKMMchtud5x/Tp3KHsykT2Ghr0mxuuWc5EXwbbsmh2Y4DnOT1eAsiLksDVGdYHiVlh0W2g0qETYxBybC1lOvd4zUNY1s9weD1qdnffpp/dNshjNjznvRT354auo0JyGwZJ+VA4RMk0Krn0ACJ3GGJ7I/sysbdVMRHXnT/euClURMb/5KCmfa1ni7HnNnHsrYSB+2nucLJfOKof9Wz18J8ZpWRwlsWpJ5QDZClMs9AvtyL74c8xCS0sFboBW+g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=linux-foundation.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TR3oRfxs5cyBuNC4jQBCLsp1UO6m6Qelmv9JfK5I8Dk=;
 b=x5R36LK78B1cCSVIow4sKiR9KWuNl4ExxPSfNLX1Hu4GFHmEK54KodB3re8/03ehIpo3nh2748GSDutYRxgdrZDiwdDTm2ZvjU1nGUT+Tm6i9DP8M9QSswzoK0p22sbkoWFCOvUIl7+IHB2iMT+qd+Lc8S9Fv0hrDCJLRx2hlZ4=
Received: from BLAPR05CA0007.namprd05.prod.outlook.com (2603:10b6:208:36e::7)
 by CH2PR12MB4136.namprd12.prod.outlook.com (2603:10b6:610:a4::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9700.11; Mon, 9 Mar
 2026 12:10:14 +0000
Received: from BL6PEPF0001AB50.namprd04.prod.outlook.com
 (2603:10b6:208:36e:cafe::e8) by BLAPR05CA0007.outlook.office365.com
 (2603:10b6:208:36e::7) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9678.25 via Frontend Transport; Mon,
 9 Mar 2026 12:10:07 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb08.amd.com; pr=C
Received: from satlexmb08.amd.com (165.204.84.17) by
 BL6PEPF0001AB50.mail.protection.outlook.com (10.167.242.74) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9678.18 via Frontend Transport; Mon, 9 Mar 2026 12:10:13 +0000
Received: from satlexmb10.amd.com (10.181.42.219) by satlexmb08.amd.com
 (10.181.42.217) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Mon, 9 Mar
 2026 07:10:13 -0500
Received: from kaveri.amd.com (10.180.168.240) by satlexmb10.amd.com
 (10.181.42.219) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Mon, 9 Mar
 2026 07:10:02 -0500
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
Subject: [RFC PATCH v4 2/6] mm/migrate: skip data copy for already-copied folios
Date: Mon, 9 Mar 2026 12:07:25 +0000
Message-ID: <20260309120725.308854-8-shivankg@amd.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260309120725.308854-3-shivankg@amd.com>
References: <20260309120725.308854-3-shivankg@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: satlexmb07.amd.com (10.181.42.216) To satlexmb10.amd.com
 (10.181.42.219)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL6PEPF0001AB50:EE_|CH2PR12MB4136:EE_
X-MS-Office365-Filtering-Correlation-Id: ecf1458f-5b25-4e1c-0f9f-08de7dd4d1b9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|36860700016|376014|7416014|82310400026;
X-Microsoft-Antispam-Message-Info:
	yLnFhVs9dH6LCIm3nSEMaCSdYW2/Yyf/LG/TR7Sez/lJ0WQxvrjxG581QYRrVHYbFXibVk2lTtskXysv6lUg/uUEPm0oMcAtX6xkzu8p7n+2nIbeswitTL0/88DYaNmCcTM/qnVO8haHub1VR8Mr+nR1MtZNhPnpKtgzNAMrGrqBeJ9eondJBUBae1Fx5cpvMqp+Z8V6vyBpR0dvLL0GpgquqYFOIF/k77cnvEVV8ZFwmqhGeW8o+0C6c163oK6eLqCBrEBE9NKQ3W0OgFmBCirRUVcedZTRNzVtA3kDwD6H0e0mZF2HknTXNN0khwyC/0GnodBrmk0L1fuBxJ7C5tp7RZes5/Um5d1V86XYJ7Ym2hPyQo9YpFRrm9HQuWLym6lG0+z6k2TWbfQTQrplmhNTTt8H0O1WDXcl7zy2L2zl9Qn7HZz66D2XrvXvQYtUNcL13mMfzifQvdo3Ad/DbqMf/UxZdYGHLMJzbUaE72PIge18eUES/SW4nwldOvV5VjnfgsQ7VlZH3YUV4uDqhj7nH0zaNUKqNEvE2AevGjFCjOcP1/ZWSX0a8M7MM1YIGzBlpG96CfY4UoNo+Tvzt8TbwNdKNbjtfe7xa86vHZ3HCIAu8ZC+/UB4MRdRy0FDvrzDDjNg1YIK4LwNnOb9K6s6a6caUEM3eNUmfR3LhSJ0ALxJaOezd3S3pVuzt+qdjR29n3m36mqhN7eVieMBlX2iopuFKLME77t3idq2pEeKPwGE4dRSpOFSqmXJkymsDK3RaY77XX1timntX5EqzA==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb08.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(36860700016)(376014)(7416014)(82310400026);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	fuPcgAqjrvJtGJok+uuG7eU5FfRbNbo+WfrQuFMMWMJ5Fs8h2tXYn/aFulBzZOjjhZpvLzrU4C33cLIS2bMpp3P0/RF68GmTRhjBiyNF96a/6/ndMn4GWDzvoWziSSZKEqBwdLMOwnBUCtxew7UnD6RJW9PQ94trRbT+jPCvl9LYSOzCZ+qnqngqylO5UJRQQDgK/y3sntX/m5FgIzqRwZ/Se3I+qijSgOxxibsIs7dGCNfQRrKRSOSsB3BMi779dTpMRXIMsOPxHEg3BDdwO272qMSH1sVf87wIrA34GN7bCSn2MvDUZsiEOJLYixcFeYaeTl7TgbwGRSGLDrvGH826FOMqUyhOrq/yCJkdnhAGmNXoicOAyzZh0kwzjBKwRdFqO+9LQkunp2SY2q1rpmk54s/kLj/H9E4r4GY/86OXbFOaSbJfSAtvwX94WoK+
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Mar 2026 12:10:13.7858
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ecf1458f-5b25-4e1c-0f9f-08de7dd4d1b9
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb08.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL6PEPF0001AB50.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4136
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 2C14E20007
X-Stat-Signature: k1euaxg98dyyumrw7tzg8ks6ztn6abh1
X-Rspam-User: 
X-HE-Tag: 1773058221-881893
X-HE-Meta: U2FsdGVkX19T2GRO/E4zMBB/l3qpRGKF2Eco7XY3ME7T1hp5e1XOcOeNhsPHu/X0UsWi2UPVLLi88wE9dh3TPjN5HBg0687Y86K4EdG2qiq+kslpCiinzNoj35WGTVLfKrBL4p0dzVYYlbXeyW0b2zD3UFTfkphYObgn3W2rABxO5YVl35zyi3BYyT8+qk5/WUvItzG0wrwpZHZ4ggc1yEyQ/ASGeXzD/Uhu3TLmyqa/TI395+vygXEXfPtgebmZlvmhtL23/IIAb/8T/JX4yRR9MVfulQYHpAjyrd/EG4JN4jR3HdBV8clSRRzhTt2BzED39nV9TTxjHEsYrLMRN+d7Pepn2d6TYcQjdJFVh8LiTx+EFLIEsEBJXhuu7x2ssxsloOF0PnZekWUYYBI6cyEta8tQguRIsLen099tmDYoea1vUOQYqbYjxfhlQkouAKQYk+lbO1aniRhxNui8RXaBn5BSwj1cNBsWgM0lFoXNiflCxTxj7vncTMfyUm2VDb9Q5eMmBU/V4zPqc+Jz3Zqgu+HnHm9h189OSXpUKz9NGv4Svf9SsFIdu9zt6r03MuGZk2nV3OWcZmyFrnCDdUMmJKaGX8Z1qvaYcd2DgHXVu5W0LCipPKhebHw06KHcBNXb5ae0GYz9WiRhVgJAu0h9Mrg0KisB0VcLIrFNVaHpb59i8dh35wL9gHuA5Tg01Eke5qg9r3lpTgVQcYbfRQd5tOQrtzzjdQ2knxJ0M8dVaKqMq2xz04hpjbP/jaU8pYh/bXV5d9mWMReeSMNgY0GxIf8PllxWiAN+jk8Qz8Z4T7DZU2hQ3n8sHBwkUMV/OphnY3AM7TnMA6MXvX/u/URdmTvYIcBmduA+MLhTyyAh7T55NBKJiyHz1/+OGQA26Db2hBgNdrhUcJ+NsaEjb5v8q/4bR9tSQZI7ybGqTq4Pq0tQkH+w79FCmJZscapsu7lPy6seLebzQVBJIne
 H3I6CYOH
 SyG2BX4kVuAhQvkcUo8xvQv3c7W10RGehVLRSz8B6h+W+WjFAI0iokwnqvvMPGlWyGbSKg/OLETmtOOZ9sqxnbZNE3jl9ReGTN5gkbH22nS9S0imuOKfDDDyLy6Bc8Mv0eOIn+NDeZz3sK1k+DT7p6BJ8cfbWDNXtjQV4e1Tyw41PABfxcQ5JVPh0eQ8qIpmOlm/KqBvybnPdwVZ3U6FI/1QtGkMPssHYxdNl/+qlddk3Y7qTVfLyYpvDpTH+AA5woyOT2MGzkilwYxY3tJOb72ZSU9qZoKr4724hHVwlerDntqK3SIwXFGeoD9+uFRfIQqGyR/O9VLevGi7eAXpTQyLFl6aHFrGBFp19gg4up2eKhMiIrX89HF0oU9mh3SkEFWtGcmezrYQ8npZTzGZAlR1IVetL9T0/TQXCSMk+P5GuAeJGIaxnZwhOAJ/W3hRJY823+qmwhYxf1+mOse0bStAxYyxVLDuLH4f+dLjejkKLvqC7vQJaDoOXoIj8qwEXtOwRU7m1TEwdMy4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add a PAGE_ALREADY_COPIED flag to the dst->private migration state.
When set, __migrate_folio() skips folio_mc_copy() and performs
metadata-only migration. All callers currently pass
already_copied=false. The batch-copy path enables it in a later patch.

Move the dst->private state enum earlier in the file so
__migrate_folio() and move_to_new_folio() can see PAGE_ALREADY_COPIED.

Signed-off-by: Shivank Garg <shivankg@amd.com>
---
 mm/migrate.c | 52 +++++++++++++++++++++++++++++++---------------------
 1 file changed, 31 insertions(+), 21 deletions(-)

diff --git a/mm/migrate.c b/mm/migrate.c
index 1bf2cf8c44dd..1d8c1fb627c9 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -848,6 +848,18 @@ void folio_migrate_flags(struct folio *newfolio, struct folio *folio)
 }
 EXPORT_SYMBOL(folio_migrate_flags);
 
+/*
+ * To record some information during migration, we use unused private
+ * field of struct folio of the newly allocated destination folio.
+ * This is safe because nobody is using it except us.
+ */
+enum {
+	PAGE_WAS_MAPPED = BIT(0),
+	PAGE_WAS_MLOCKED = BIT(1),
+	PAGE_ALREADY_COPIED = BIT(2),
+	PAGE_OLD_STATES = PAGE_WAS_MAPPED | PAGE_WAS_MLOCKED | PAGE_ALREADY_COPIED,
+};
+
 /************************************************************
  *                    Migration functions
  ***********************************************************/
@@ -857,14 +869,20 @@ static int __migrate_folio(struct address_space *mapping, struct folio *dst,
 			   enum migrate_mode mode)
 {
 	int rc, expected_count = folio_expected_ref_count(src) + 1;
+	bool already_copied = ((unsigned long)dst->private & PAGE_ALREADY_COPIED);
+
+	if (already_copied)
+		dst->private = NULL;
 
 	/* Check whether src does not have extra refs before we do more work */
 	if (folio_ref_count(src) != expected_count)
 		return -EAGAIN;
 
-	rc = folio_mc_copy(dst, src);
-	if (unlikely(rc))
-		return rc;
+	if (!already_copied) {
+		rc = folio_mc_copy(dst, src);
+		if (unlikely(rc))
+			return rc;
+	}
 
 	rc = __folio_migrate_mapping(mapping, dst, src, expected_count);
 	if (rc)
@@ -1088,7 +1106,7 @@ static int fallback_migrate_folio(struct address_space *mapping,
  *     0 - success
  */
 static int move_to_new_folio(struct folio *dst, struct folio *src,
-				enum migrate_mode mode)
+		enum migrate_mode mode, bool already_copied)
 {
 	struct address_space *mapping = folio_mapping(src);
 	int rc = -EAGAIN;
@@ -1096,6 +1114,9 @@ static int move_to_new_folio(struct folio *dst, struct folio *src,
 	VM_BUG_ON_FOLIO(!folio_test_locked(src), src);
 	VM_BUG_ON_FOLIO(!folio_test_locked(dst), dst);
 
+	if (already_copied)
+		dst->private = (void *)(unsigned long)PAGE_ALREADY_COPIED;
+
 	if (!mapping)
 		rc = migrate_folio(mapping, dst, src, mode);
 	else if (mapping_inaccessible(mapping))
@@ -1127,17 +1148,6 @@ static int move_to_new_folio(struct folio *dst, struct folio *src,
 	return rc;
 }
 
-/*
- * To record some information during migration, we use unused private
- * field of struct folio of the newly allocated destination folio.
- * This is safe because nobody is using it except us.
- */
-enum {
-	PAGE_WAS_MAPPED = BIT(0),
-	PAGE_WAS_MLOCKED = BIT(1),
-	PAGE_OLD_STATES = PAGE_WAS_MAPPED | PAGE_WAS_MLOCKED,
-};
-
 static void __migrate_folio_record(struct folio *dst,
 				   int old_page_state,
 				   struct anon_vma *anon_vma)
@@ -1353,7 +1363,7 @@ static int migrate_folio_unmap(new_folio_t get_new_folio,
 static int migrate_folio_move(free_folio_t put_new_folio, unsigned long private,
 			      struct folio *src, struct folio *dst,
 			      enum migrate_mode mode, enum migrate_reason reason,
-			      struct list_head *ret)
+			      struct list_head *ret, bool already_copied)
 {
 	int rc;
 	int old_page_state = 0;
@@ -1371,7 +1381,7 @@ static int migrate_folio_move(free_folio_t put_new_folio, unsigned long private,
 		goto out_unlock_both;
 	}
 
-	rc = move_to_new_folio(dst, src, mode);
+	rc = move_to_new_folio(dst, src, mode, already_copied);
 	if (rc)
 		goto out;
 
@@ -1519,7 +1529,7 @@ static int unmap_and_move_huge_page(new_folio_t get_new_folio,
 	}
 
 	if (!folio_mapped(src))
-		rc = move_to_new_folio(dst, src, mode);
+		rc = move_to_new_folio(dst, src, mode, false);
 
 	if (page_was_mapped)
 		remove_migration_ptes(src, !rc ? dst : src, ttu);
@@ -1703,7 +1713,7 @@ static void migrate_folios_move(struct list_head *src_folios,
 		struct list_head *ret_folios,
 		struct migrate_pages_stats *stats,
 		int *retry, int *thp_retry, int *nr_failed,
-		int *nr_retry_pages)
+		int *nr_retry_pages, bool already_copied)
 {
 	struct folio *folio, *folio2, *dst, *dst2;
 	bool is_thp;
@@ -1720,7 +1730,7 @@ static void migrate_folios_move(struct list_head *src_folios,
 
 		rc = migrate_folio_move(put_new_folio, private,
 				folio, dst, mode,
-				reason, ret_folios);
+				reason, ret_folios, already_copied);
 		/*
 		 * The rules are:
 		 *	0: folio will be freed
@@ -1977,7 +1987,7 @@ static int migrate_pages_batch(struct list_head *from,
 		migrate_folios_move(&unmap_folios, &dst_folios,
 				put_new_folio, private, mode, reason,
 				ret_folios, stats, &retry, &thp_retry,
-				&nr_failed, &nr_retry_pages);
+				&nr_failed, &nr_retry_pages, false);
 	}
 	nr_failed += retry;
 	stats->nr_thp_failed += thp_retry;
-- 
2.43.0


