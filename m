Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8CEF7CDE014
	for <linux-mm@archiver.kernel.org>; Fri, 26 Jun 2026 09:38:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6458A6B00B4; Fri, 26 Jun 2026 05:38:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 61CAC6B00B6; Fri, 26 Jun 2026 05:38:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5320A6B00B7; Fri, 26 Jun 2026 05:38:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 264036B00B4
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 05:38:39 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id BA7BC40407
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 09:38:37 +0000 (UTC)
X-FDA: 84921563874.26.9458389
Received: from PH0PR06CU001.outbound.protection.outlook.com (mail-westus3azon11011037.outbound.protection.outlook.com [40.107.208.37])
	by imf05.hostedemail.com (Postfix) with ESMTP id 85BF0100004
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 09:38:33 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=r9bAPCeR;
	spf=pass (imf05.hostedemail.com: domain of shivankg@amd.com designates 40.107.208.37 as permitted sender) smtp.mailfrom=shivankg@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1782466713;
	b=1KULjTIGwzXqDQ7U77/t4DGRXizu1jPiyMnj2HN+OXpToDNTzOaXEtH5yL1Zz0QXOk25GB
	VGjLinljCELb7tdeH5fuqwvYPm6SthynQNHtioB33JtEgj+JCUL+AJtyfRQxQS5DilPSyS
	wgYijxKv75YnnsIZQE1CAmlrquW7NW0=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782466713;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QuVFZHD/pwtYuPWVU4MCSuRcEIifU50cueE6Fy8QIz4=;
	b=Rlou1kcjGgsGPjfXfYK9xO9Chu4yIPXWAFJr1XK6yXLjhyxz4sUW0/05srkHC/hidw2xdN
	uRe4eS4qXAcaE4VBf37bVw3iLZ9SjWPUPyzrAbkbk6sEcpYssWF/pKJQ27QeQtwJ8s5Esb
	u++1C1dtbfQCGYxWewmpsNiWtwERSAk=
ARC-Authentication-Results: i=2;
	imf05.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=r9bAPCeR;
	spf=pass (imf05.hostedemail.com: domain of shivankg@amd.com designates 40.107.208.37 as permitted sender) smtp.mailfrom=shivankg@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=CFCsr9QXpXSfbSvqGQcppRRCqR7LsULPayxvl7r7oVUm/sLONi055VPZOOIin/hCm6waHekMwQ4xBdFk2Z566BXiSKwN3GxnIQJiFNARgNJtwWJ72SHVYBZRFj6y9C0JztySZafsDkcXEmocxYHQnfezcgcTkPvdqXgqwfgHcKL3TsK3T8mzIHfo7TAMYNggTEN+jTySlq3xaatnbLPqbKMg1derScBsCg9lA4isc6SJ8hJWfklqce3TE3E1ODafBpi3KWmuCI02Nz1+wX1spp0JJUsXPEHl7XJzV4X9qzGfV6CUD15yB16OXbPT/35kuRKwAVpLaKblMoASvMSldA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QuVFZHD/pwtYuPWVU4MCSuRcEIifU50cueE6Fy8QIz4=;
 b=thVKmnIIY7MRQvRCrqIQceVARBw8WubbTU0d2wUHnebkV9jhD5UQ6JWs38FBFbOrw2vHfojOEO/ER7WoauAd3XZO9HGnN6SHoXt2040bU+IhDYMig9ydu6bfkqbO3fn2hoJYpSJTt8w0SLXPy30OfSBix1zq1IMzZdW2UXjsrF0w8hguNDzc1nT+JEWQd3bW6Q8jT9ej85Q9E9HDkao14S/HpbZKGv7QITXiedE+joKxhUmIuVVA3Fx7Ys+4nO/LJQv7BbBrc1ubX63C6fS3aZFaaD+d+gnW6DioiFqEbUbiP1RL7UKpScTT50c4mc+2nkYtHCikGdLaPW/in5NG8w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=sk.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QuVFZHD/pwtYuPWVU4MCSuRcEIifU50cueE6Fy8QIz4=;
 b=r9bAPCeRcUTz+xkpDcpP/ahHHLFR3KqnalrRQn+Z9NgrxGPmHNXJLzMAx91bbtpc16z//hW0oanmqSSXgOx8fimFBHqhnc9rBBOYZujuM9WhHlPGkImeVgJwm5PoHLrVjTPPMPKlwe1StoyEHGvVzZBfvO+N3cxiQs1axiDeY84=
Received: from CY5PR17CA0055.namprd17.prod.outlook.com (2603:10b6:930:12::26)
 by DS0PR12MB7777.namprd12.prod.outlook.com (2603:10b6:8:153::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.139.20; Fri, 26 Jun
 2026 09:38:26 +0000
Received: from CH1PEPF0000AD77.namprd04.prod.outlook.com
 (2603:10b6:930:12:cafe::28) by CY5PR17CA0055.outlook.office365.com
 (2603:10b6:930:12::26) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.159.16 via Frontend Transport; Fri,
 26 Jun 2026 09:38:26 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 CH1PEPF0000AD77.mail.protection.outlook.com (10.167.244.55) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.181.6 via Frontend Transport; Fri, 26 Jun 2026 09:38:26 +0000
Received: from [127.0.1.1] (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.41; Fri, 26 Jun
 2026 04:38:21 -0500
From: Shivank Garg <shivankg@amd.com>
Date: Fri, 26 Jun 2026 09:37:50 +0000
Subject: [PATCH 3/3] mm/migrate: use migrate_info field instead of private
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-ID: <20260626-migrate-cleanups-prep-v1-3-a95933af7619@amd.com>
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
	<shivankg@amd.com>, Jonathan Cameron <jic23@kernel.org>
X-Mailer: b4 0.15-dev
X-Developer-Signature: v=1; a=ed25519-sha256; t=1782466686; l=2592;
 i=shivankg@amd.com; s=20260518; h=from:subject:message-id;
 bh=8ROrisaQr0TjSzp5EJz4ADIq7GRDepnincdomD8ZVd8=;
 b=e8NrjdwAOdHT7CKKZ7LXWNoyt0VERPWgoUHI6Dq5suJAXJ17hioYJNTl8boRHfdngbQ4RjJ1A
 EMfXyY4uf9TAl4ML7gG21H2saynKmHW3f+k6ojvQIoRKUNsdOvJc5nD
X-Developer-Key: i=shivankg@amd.com; a=ed25519;
 pk=2l2QGTeXuGkZTtfmx0nPQU8iFZfjYmX/ymMojitevx4=
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: satlexmb08.amd.com (10.181.42.217) To satlexmb07.amd.com
 (10.181.42.216)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH1PEPF0000AD77:EE_|DS0PR12MB7777:EE_
X-MS-Office365-Filtering-Correlation-Id: 6d811c94-793b-469f-d7b2-08ded366ac61
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|36860700016|7416014|23010399003|82310400026|376014|11063799006|56012099006|22082099003|18002099003|921020;
X-Microsoft-Antispam-Message-Info:
	baRPJdsaXYXh03p/Q6x4HPiMfW97rpp5a97svLesyB2bKyUoCXQZ/mVnQ0LEIoUh1egYbPlRYdj4cnvxD5kEvurZh90YgpI8huJIBUAC5fl36o9DOS7d+vbmJlAB7tjuAy8mEohNSCRGfy8ffTDz8lf67W+JxxCpJUG9L9dSiNUkxpHKBr2T4Z4doVDDQaLTKmjNzvn7QpXzKX4VkmlkPsqQTN/2lL1eRk+xiG9rmaHmYXcY3UOmHZ2ofmRijlpqCAO1e3pI07GRr/DYMvTbx5NEWj7M6fwOFtEw/pqkBBXV0hyhbS0wzKNvl3izxveympt8ZyWSPIBs6BTi89I2izVtN/9LpDoFI2YngZfkKJoSMMEZRSP615yQgmq/AC7b+wpOYtdO6bpUlhQOE0UUuQhUNyin3anABzMcUXGzfoGxCdogYPF1XZ/QK81Vv6zB2mppgITw/swTvWJR7/PfHMqvupV7z/DrA00k+LBB9WxiY5Cnj6ea5KXkuvfNhKVWorftzSFsDNTclegwM5miLw5VgB8/dEl8VlyyAsMR2Kiv9d5KWp9SN4E1aZExPo8xgvpXJxvSJMWxQ2hRpd5gvPd6dLXXQm32yQ9r5GCdpdyiC57yOXD9FXxAXgR3pC18f/h6WRzu0aZGWZCBbFyerIfxqUYYm1/z5zFyF9RxTtmX+Fu8cKgASN9Ob6ZjqKOp7d8VnNxiypV/6M1P9vgo14OlE+rpY3LaMsBr0icJHhGpIh7QDaNXVytBPA+vWRFR
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(36860700016)(7416014)(23010399003)(82310400026)(376014)(11063799006)(56012099006)(22082099003)(18002099003)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	YGyc/6QRh6Sokl8QMmxqpwn5ob4/iJJETa2fXBrUHRs2p6abb695A4HO2Td50NUbMYIzWr82m50yKuKGFrQ/SlvIn0jH9p4EelavWVj5atrDMlMvGfsgpYLtGHPscn4zjWxb6LtdHeVrRxKscJiPUC+LRr7Jh4p2qEByM9La55x/zILjCTSi+WwC/TvHQHwzLo644RXLr2VS5CGn2iYbtCKaQMBGv3rfhwob3kwMlgFC9kFcpy2TYXVbqhrkGavLLFOHtihAKWWSv4EuNXCbhEOm7zutTcceQwInA5g4JzF+cdt+XG8DBkyfHCAlsx9/0H9lw8Ww9I/ySDz3Nc4WDWaFgwj7928Z6q8J8mXMO+BG4gFtoj54sQTmKjnaI+snyctG+z5NCT41aACj/nDcrwTx8g+9t5hr/eJYJWRaCdRPiL+CNRuRSW9Xh+wp10h+
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jun 2026 09:38:26.4854
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 6d811c94-793b-469f-d7b2-08ded366ac61
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH1PEPF0000AD77.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB7777
X-Stat-Signature: cbyomd6ogbgr3wgsiwwutbxtmkuyhs3c
X-Rspam-User: 
X-Rspamd-Queue-Id: 85BF0100004
X-Rspamd-Server: rspam02
X-HE-Tag: 1782466713-615422
X-HE-Meta: U2FsdGVkX1+Wf/7L8/akkrTCYR/h2OZ9WqqBZ/RJciJQ+RjUyW1nSvleoAHWX+Dg/jG/TDgiLWRgAbwchK3XA1XYiSvzPxflrttya5v488qY0BM0cGrL2fXRZH5XOTRiP0isJ2OGbU0mNTOWiPKT3DpNIDjv/2xD8q7voZy+ZNiqssT7p481eMUcbbsRzAnbIAOnl8GBevW+EnRtG0YmgPiIeRsV55vWJ/1m4iq9Gq8w5vzotygeGybpt0zxcRlVpGgxqb7tnguxsMrBzfvsN8+YucZlRedBljAEDujvF5cuCoP/TKsJ6NYDeRgefLJD+4dsk0F+mkva4W8YvLPcuabnXZ2XScxc9Z87fyPTDqXZzYxAFrA/CciU+sIBK5a5PPpeu0aVMTHhpZUGAsluhZr9V4Z3LEdID/RHxZKDS1khu/KoBZYRWFisEyKW246dnrFK1zE4BItRtFlJOzbQuazvtExI+GDYdPK7wbDH4iJUQkw9p+vCRWf6eU/4h0xJmcPnXxuAkatvmLxq+8mXF4q14j2i+HPkqjkZ7LTUp4OWtrCSqEKsDKssnH6kLC499FeB0bu3AHMA52gw5tL2wq/DXQ+VtNUD4Vjl4+lkzm4i1jT9nvr47+vvbdvmo/NuZOoLidOHKcZzPf0AGQ47/ZP91HrFJJazdHiNe16Lyc7lSXAQY5qWJJAk20BJJvbRcEmEGSrozOtojdlEbhYKPMA/Sqy25eOEICBMaNtTKaNdcfB0/Ukjo7fErnbkzT6prUX3hk0STn8uHqgr8d3kSsHCMp5TnuPsqpfHrpZG1IwrXwc9hANpQCyPgYCRrVA1Slyrenl2rzcM4tUERSTjDOZFuUZtcQ+B8CEW1MACFGpZ50uA1vFm/xWBZktAHrHUK1YwGXHd5ySmE5DOksH8JlMz+ISzesZINkYH7XZRKgY5Ovp/xMEc2kJsve9TFtKCC73+fXPkFK6QQvbJBd+
 VE484b93
 gjERH2841nBmq9kbINomWSErCULuxCt7uApEvd2DyUINSTBPnPzOmOCN9RbXZ8ofK60rY1h3jlRfwJpTq2ejdVJEC5AXNlmzO3/MV0wnZzxPEXzm0//HgEC9JGaf+06CEBeKtFtfJdckkEHHAC8DWMJGnfH7AzUuc2Syyv+CUsmuxLW4EnRsxfgnoWeJVt2XgLZIAcmzKguzzlmUE+SBchNAqoCOw2OOirSYwAgcJQX3WwVJgZJ12S6EzC1dh5J0b/T+dVaVP1agYQtVQjOoDXXaJOWUsfQLBB8C8MQ+k4GY2Uad8Jbjk2w7VRbYsnYce1ZlyCI3EQbs/so/XtBILI+6FKQdNtQE9/v6xPEpebpv1V5uAArgjaW8ZrPM4Fimkt7w0tut11w6kJkbLeRFKqSNTgvMAMcdSIJMOf6JsQDG0Ue38+1Z13tBNal6w2XDNT4SttTBzhxVGqojfiXQX6c41UcKp+oQry81GmmUvd2DCPsLkQvBJ5rIRMlpoLtfFBwLju9ZCkQ5yirLLXPNvGKx7hACcNKnQj7i+lqhE3ZVPCFEbhFni5CTNx5NULVHISSJJ73wOzFcccNuY+r2jkpzl3I6+61mQ+IY8zgx9lgZCNyb/DqyadqG5bXBJAOzN++sS
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add an unsigned long migrate_info member to the struct folio union and
use it to store migration state (anon_vma pointer and FOLIO_WAS_*
markers) instead of using folio->private. While at it, switch to bitwise
OR.

No functional change.

Suggested-by: David Hildenbrand <david@kernel.org>
Reviewed-by: Jonathan Cameron <jic23@kernel.org>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Huang Ying <ying.huang@linux.alibaba.com>
Signed-off-by: Shivank Garg <shivankg@amd.com>
---
 include/linux/mm_types.h |  1 +
 mm/migrate.c             | 14 +++++++-------
 2 files changed, 8 insertions(+), 7 deletions(-)

diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
index b18c2b2e7d2c..ae9bca4eda5c 100644
--- a/include/linux/mm_types.h
+++ b/include/linux/mm_types.h
@@ -427,6 +427,7 @@ struct folio {
 			union {
 				void *private;
 				swp_entry_t swap;
+				unsigned long migrate_info;
 			};
 			atomic_t _mapcount;
 			atomic_t _refcount;
diff --git a/mm/migrate.c b/mm/migrate.c
index 84b4c24f9dac..7a83032a14b5 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -1130,7 +1130,7 @@ static int move_to_new_folio(struct folio *dst, struct folio *src,
 }
 
 /*
- * To record some information during migration, we use unused private
+ * To record some information during migration, we use the migrate_info
  * field of struct folio of the newly allocated destination folio.
  * This is safe because nobody is using it except us.
  */
@@ -1143,17 +1143,17 @@ enum {
 static void __migrate_folio_record(struct folio *dst,
 		int old_folio_state, struct anon_vma *anon_vma)
 {
-	dst->private = (void *)anon_vma + old_folio_state;
+	dst->migrate_info = (unsigned long)anon_vma | old_folio_state;
 }
 
 static void __migrate_folio_extract(struct folio *dst,
 		int *old_folio_state, struct anon_vma **anon_vmap)
 {
-	unsigned long private = (unsigned long)dst->private;
+	unsigned long info = dst->migrate_info;
 
-	*anon_vmap = (struct anon_vma *)(private & ~FOLIO_OLD_STATES);
-	*old_folio_state = private & FOLIO_OLD_STATES;
-	dst->private = NULL;
+	*anon_vmap = (struct anon_vma *)(info & ~FOLIO_OLD_STATES);
+	*old_folio_state = info & FOLIO_OLD_STATES;
+	dst->migrate_info = 0;
 }
 
 /* Restore the source folio to the original state upon failure */
@@ -1214,7 +1214,7 @@ static int migrate_folio_unmap(new_folio_t get_new_folio,
 		return -ENOMEM;
 	*dstp = dst;
 
-	dst->private = NULL;
+	dst->migrate_info = 0;
 
 	if (!folio_trylock(src)) {
 		if (mode == MIGRATE_ASYNC)

-- 
2.43.0


