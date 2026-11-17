Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D3362606A338
	for <linux-mm@archiver.kernel.org>; Tue, 17 Nov 2026 07:17:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=amd.com header.i=@amd.com header.a=rsa-sha256 header.s=selector1 header.b=NEKQ/k0H
Received: by kanga.kvack.org (Postfix)
	id F13386B05C1; Tue, 17 Nov 2026 02:17:37 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EC36B6B05C2; Tue, 17 Nov 2026 02:17:37 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DB1D76B05C3; Tue, 17 Nov 2026 02:17:37 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id A60A86B05C1
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 02:17:37 -0500 (EST)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 3AB81C01C4
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 07:17:37 +0000 (UTC)
X-FDA: 85443755754.14.716DD39
Received: from DM5PR21CU001.outbound.protection.outlook.com (mail-centralusazon11011038.outbound.protection.outlook.com [52.101.62.38])
	by imf15.hostedemail.com (Postfix) with ESMTP id 1AB5DA0004
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 07:17:33 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b="NEKQ/k0H";
	spf=pass (imf15.hostedemail.com: domain of shivankg@amd.com designates 52.101.62.38 as permitted sender) smtp.mailfrom=shivankg@amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=quarantine) header.from=amd.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1794899854;
	b=ougohvQye0JKZwCOQwImcuszdDDsGq279wbg8WzBxBUh/aCCNDU5y15Yxe/7tS8R9KwLd3
	IznXUQC7SB6sGXhNi7383Jhckg69Ej2sirnT+zUay0XxiV4CISeafzVFc7nQsXvSTGqJO5
	1RRvh8iHQfa6xKESqMN+KzoH+CKKdZE=
ARC-Authentication-Results: i=2;
	imf15.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b="NEKQ/k0H";
	spf=pass (imf15.hostedemail.com: domain of shivankg@amd.com designates 52.101.62.38 as permitted sender) smtp.mailfrom=shivankg@amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=quarantine) header.from=amd.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794899854;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=C69q8YVfbq6Wnj5phIjJy8NVq8cn1ZrzPW8sluVzesI=;
	b=rJCcM20E2yX5bA1kuiwq/2BwagK/gHbVs2sj7Yilh9zqPtlfatQqZVX7m73kyAHI7f/RBr
	CzvMjdh1coaigE7CXqUkAKM95Dlhohd9UAK3WD0qKEE5ZsxYtUvM+cijLhgYqj+uNO6DM1
	1l7BLY/ywS6GsTRHSBM6SHyaKcy3OaY=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=MfAsnDC5hFo6TqEdYyQVTHKVpyuOih9GqZ4vhJ8OWw6UvF/OgKARe9AFJFbTQ7LQ/OTj0E0zgQg5mCeD0ci+Ra6+S3GXdLSOqtyzLN2b3Q7gatXWs499E6zqlvZuJee8wZ5mVg/b0qAOjBUdcIgZ/El3lJ5hjNLgazhuNQSw5h6fERtlEwPSV39EdEbBQ45tUL6/q+Phk1Gdb4Ppb6et5rB3FKE3amMP/SmlcLqQABAFpaOMrjQhOS0Evd4qW6n/YHhusTbQIvs3ec7c+DpIj3pWdgniGhW/pXyVTMzndYCX/vqEHh9UgA03Ler/fdTFvzaVTahsFi7rWr1OT3q+bw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=C69q8YVfbq6Wnj5phIjJy8NVq8cn1ZrzPW8sluVzesI=;
 b=XSYbO9RfG7omq3kxRGzHw7q4ixqOWm6ihfURT4YYrkUqR+9gZ1dAKFitsmmJ/HrDPTitDxykvO6c3gO7uWJj8Zn8S0Lgj953NTVtpGMM7kF3+xlb6X0tfph+gPR6x3uxeajLwQn+L/ZOkd/G33CdiORLuAiH2YqTz2WYj68MCpP4E1i5CgXApgsBfiyjso70iJR4zeeL3SgJQkL6zJXAyGB9JbjkvsDc65jezGd7wLC0jTc6NQAUzrzAxU+rw47fpwIqiBFf81tr5M8C6VMpPfOvHbcnjnCDZ5qBS4DUZvde61MJ7qA2ZHe8jCbEe/CXUkkBsgAn4Em9nMj2aTQqRg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=linux-foundation.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=C69q8YVfbq6Wnj5phIjJy8NVq8cn1ZrzPW8sluVzesI=;
 b=NEKQ/k0Hhz/HC4tyEP+oMZQuPx0LGUMPfYLix7PUAx/yeE3TCB68HvdJVGuFZqyHpBiPFbcoIG4QVJVCCEQsXGoJYeNqOPQa7scE+3JsmrgdE/O7xWKnxHp3Uf/8S7s6dsyJP0EkSt6/fy4JsAHExcOukaLxXO1gg3NpsNbR0mU=
Received: from DS1PR02CA0028.namprd02.prod.outlook.com (2603:10b6:8:44a::9) by
 CHBPR12MB780315.namprd12.prod.outlook.com (2603:10b6:610:36a::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.14; Tue, 17 Nov
 2026 07:17:30 +0000
Received: from CH7PEPF00000019.namprd21.prod.outlook.com
 (2603:10b6:8:44a:cafe::a2) by DS1PR02CA0028.outlook.office365.com
 (2603:10b6:8:44a::9) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.615.14 via Frontend Transport; Tue,
 17 Nov 2026 07:17:30 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 165.204.84.17) smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 CH7PEPF00000019.mail.protection.outlook.com (10.167.244.168) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.639.0 via Frontend Transport; Tue, 17 Nov 2026 07:17:30 +0000
Received: from [127.0.1.1] (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.57; Tue, 17 Nov
 2026 01:17:24 -0600
From: Shivank Garg <shivankg@amd.com>
Date: Tue, 17 Nov 2026 07:16:51 +0000
Subject: [PATCH mm-new v2 4/5] mm/zsmalloc: remove unused zpdesc_lock()
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-ID: <20261117-unused-sym-mm-v2-4-2f845e94dd50@amd.com>
References: <20261117-unused-sym-mm-v2-0-2f845e94dd50@amd.com>
In-Reply-To: <20261117-unused-sym-mm-v2-0-2f845e94dd50@amd.com>
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>,
	Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>,
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <baoquan.he@linux.dev>, Barry Song
	<baohua@kernel.org>, Youngjun Park <youngjun.park@lge.com>, Minchan Kim
	<minchan@kernel.org>, Sergey Senozhatsky <senozhatsky@chromium.org>, "Liam R.
 Howlett" <liam@infradead.org>, Lorenzo Stoakes <ljs@kernel.org>, "Vlastimil
 Babka" <vbabka@kernel.org>, Jann Horn <jannh@google.com>, Pedro Falcato
	<pfalcato@suse.de>
CC: <linux-fsdevel@vger.kernel.org>, <linux-mm@kvack.org>,
	<linux-kernel@vger.kernel.org>, Shivank Garg <shivankg@amd.com>
X-Mailer: b4 0.15-dev-47d62
X-Developer-Signature: v=1; a=ed25519-sha256; t=1794899821; l=774;
 i=shivankg@amd.com; s=20260518; h=from:subject:message-id;
 bh=pV2CJt/tj69awn4Duh9GB/gFNsS3CYaXfVzki/FvS/w=;
 b=Gk2gq5M0QxfvARTMU7dns2zud9iawP3p+8ErGLADgmWplO6E5/AgvsXMCGv5eO66vd9Me0n4a
 t4I0boVzQaZDOduPMXov9Xyxhn59U0JzRbY8JkNtbTFR9rIHncZW8hH
X-Developer-Key: i=shivankg@amd.com; a=ed25519;
 pk=2l2QGTeXuGkZTtfmx0nPQU8iFZfjYmX/ymMojitevx4=
X-ClientProxiedBy: satlexmb08.amd.com (10.181.42.217) To satlexmb07.amd.com
 (10.181.42.216)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH7PEPF00000019:EE_|CHBPR12MB780315:EE_
X-MS-Office365-Filtering-Correlation-Id: 0d60d2f1-340a-4dc6-424f-08df447ad792
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|1800799024|36860700016|376014|82310400026|7416014|921020|10067099003|11063799006|56012099006|261021123027099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	Wbq7r+a0QEwQR7OOz+P/df6kZkPLuOyAjhbpeCbDqegIvcy1ZEw8/DbRrOfsLhLfg84uqaXul7/Inju1DZBgOwFw53pOp8Yh0fBD6WpIjurA2MoVkMAnlGeFUvfp+gj0rOv5UmaVbDuvEc7F3nI02QcftckKgkkj9+GXqfCRVjTLMFK2q4SLxXeB5k44wjDUVApoeLJqLVLP7JvfI0gfKzBDriu1oChvw6lPgp9CT4px2ynsBYCZuQrKt1wHvgtP5MojR9d/W9+BnwkChvZDLvGpL/KrXgLRhPU2tb5lrWM0n5P06cJOl/jGdMbnGiHFYtfCAHQzymehA54ZfFJPol/fw7PPvDXyUYHN/GJPCx/Nk5mcP1KF/2ulxrLvC3PzFQVAACG+EP0L1wTijxIyV6LQgpLTfMhcK16qL6DkEhQCwe3lpfby4GbTor7fVWPq2rVSZbADpkPbM+eWV4doU844qzcpD2eVNU2m/zlw+ey7musfa5SMzDIvN6ya0/AL7K+gJBM6kRLb9fu84bWQs3smgB4GeEdmcyHj33u09YlZexAjwquPx44VeONLynYXY0Yp75J0aBSalOEDlTKA18mYtl0edcW2LLrkHOVBYV/rv616bluVjbr6oYSgp08gttk2RNRmbdEK3uFMu+Nu0yqyPirEg+ym09kzkWr3Vwmvr8MOmciXGGSH/K3YHwAc5CRPPOUTimRZs4qDwX+9fFJxiU1gka6tu7W7CaLsVF+zssBpOniCMlvedRWLWWiH
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(23010399003)(1800799024)(36860700016)(376014)(82310400026)(7416014)(921020)(10067099003)(11063799006)(56012099006)(261021123027099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	1Ax+9L1EheMleS/ax/nEvPYs+odXNUcw+FpItXvDH10jBWwJum0hUZGEGeDSOqZ2VwzeJ4Sfd1S679XA79IGsKa2R4ywqFTi10c459/MxH8aO82n/J2Yhd6qGjZEwGB/Sz7GFnVE/iEGNzG7sPi77Y0s6eqHlHCdq2ZQU/XxeV+BZ7dLja4BLd8kf/9oghNrR7WD8By0tPEVcL0UWq8vdqISSnwGESiaGvnmFf0Gf8wy525Atnau8X+Iob+y/RV+JntkuMb6vj35S3cuwCTCqO5YDDH61cU+ieNhAOKyIiGn2+4UWO1hLSaEvtJkWZz+zLim/2D8/n9Yu4ZbRka9INBv35lTuENReMjIOMvfM3imqaiBvRAcOIIoHAhRNWpeJBUbIYRPITek7Qg7bV5AQcFouBSR5LI+Hb06ln4eqJ8rPOfrw23A+xlBsvvmy/lC
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Nov 2026 07:17:30.2723
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 0d60d2f1-340a-4dc6-424f-08df447ad792
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH7PEPF00000019.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CHBPR12MB780315
X-Stat-Signature: yixsdtnnez4sq1fdanj3yk8dwfjxgous
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 1AB5DA0004
X-HE-Tag: 1794899853-970654
X-HE-Meta: U2FsdGVkX19swxd/ELxer0qrhawnl1AYCqeCmjevf7LWnq3GgqDbz50qF6RV/a9AsB/acm7yraDLuhf0V8Fh1cs0mzJ8sxYXqlYoU7E0RQVGN77JxMSB2xia/usZV0wRNbePezCdJ7xljk/tXkPg7RZdvJsFOx04ytIrhmkyZnD+6jAaf2Ts7uKc8aeJTu/Hg5XCpe94y8p1JSE2yYrvI7J5eq8T1fA1cE841cM6F295/e7oRiuEFzp6UfnW18Ygwu9LHAs89IZrPsZ52Lnuk5obcF9VzISsmUDsg5mvB36AWOAjUuil6i8fK1oqrdptCbyM3O3QoJA5fuAVhCZC80ZVqwsFrc5qOEO9h+auD60wXLmovwUHaH+jcFX48bxsR9iSGTAuyPpZ1bMjiB6xdXG9knVc6FXyx0XEdndLsv8XYbIY0IcGAc+woRZIrCLTgQfzf6P4cUUGFcTi/eXut5Nn/Iu9oM931jZO5R3UFdgSVAWwqNF4DOnEly8vIZTMS7izZQqlhhjYImgRlP77m7/KpwkwkX8CSvMqniqcCg8nj8hAfh/aFBQ51HVKhHE2INrTU+LLzHliJa7RD8ugv6fTwnubkCCwcCoIPg+ubqfj9JXWswImMHgXIsSNYJQw1tW4okdIe00uIw0buSvdmtuKdk3ccxsBaINE0NVYisnM/kMFxXx2i76EHNhqp9ux1C0Gw6nkIgIQEVBCJz2yu4QdJWVq8RG6OMLJ8iaymFiWHVeb+EvijzMkgCaRV7qevvJpefzWPPX5XMPkaL1IzMrHU8fFSxf505pYuGbUK/D1vtqyjSWN77iwnxNd/4uxsXlxTQVqSgaWy3weBBBWljPbfPSHjL/M69O4LIvfR/UTVQeCrGw5suoU4DXv41Apz5BuM5htg6ZggVgl5fBlj1RWWr+D74zgmZDg8nuC77B1pB6xqAMum1+PnWn8P1zX75WAX5HbtOoBWbC0ody
 40fD/a+a
 ykkg125IT8LJK79yy71nnHR7e+nzwoyUfHgnYyXCh2LA1FOK7SJHwu0zf6lqDPIRZlGbGPHdbW7Dw8J0xHAFKcTgMNaFZwT4pLuyvwtkeVpcIYcV7GRPq+E3+iOnrS/R5GeeaS90VIltXJ+mwyFAUemAKZe5HiduUqzcHrV6rUjSRmAljggZc4MxI54aCsdDOXKf0NCS3+rnBUVLZP0lcZwM5u6A+MRBC8zuU5lfAYGDA7skcLLSs+iM3TQ4jsfs/vq9/lSpxRBYixKvV2KV5t/ZuSFkW9pFLL2QC+8I/Bx5aZVGVARy1+Q+B7zBmKynf6xX7aU+gMm89PIS1tFSITDJeHyt14HWO+BZ7J3vCNFFN0PAC4+rT6hKrjSYSaEIfYhs71MjBl39c0zU/IUUOVjO6+p8N7UX5cdbIDl8R3vGYbn4MjGnY2vqPImSw6DV8D+sVjX/OiAmZV+i+ScouG8187a8upD5fv0D8fu+FpByBb4ALD01OHZ+KeS87h6dYJUyL3kOLwO6NoNQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

It was added in commit c1b3bb73d55e ("mm/zsmalloc: use zpdesc in
trylock_zspage()/lock_zspage()") but has never had a caller.

Signed-off-by: Shivank Garg <shivankg@amd.com>
---
 mm/zpdesc.h | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/mm/zpdesc.h b/mm/zpdesc.h
index 4fd81c2e8076..aaab5f1bfb52 100644
--- a/mm/zpdesc.h
+++ b/mm/zpdesc.h
@@ -107,11 +107,6 @@ static_assert(sizeof(struct zpdesc) <= sizeof(struct page));
 	const struct page *:		(const struct zpdesc *)(p),	\
 	struct page *:			(struct zpdesc *)(p)))
 
-static inline void zpdesc_lock(struct zpdesc *zpdesc)
-{
-	folio_lock(zpdesc_folio(zpdesc));
-}
-
 static inline bool zpdesc_trylock(struct zpdesc *zpdesc)
 {
 	return folio_trylock(zpdesc_folio(zpdesc));

-- 
2.53.0


