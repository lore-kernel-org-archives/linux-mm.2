Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 687AAF3C241
	for <linux-mm@archiver.kernel.org>; Mon,  9 Mar 2026 12:11:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D42CC6B0088; Mon,  9 Mar 2026 08:11:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CF7036B0089; Mon,  9 Mar 2026 08:11:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BCF5F6B008A; Mon,  9 Mar 2026 08:11:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id A5B256B0088
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 08:11:48 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 54A5013665C
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 12:11:48 +0000 (UTC)
X-FDA: 84526410696.16.74FDC65
Received: from DM5PR21CU001.outbound.protection.outlook.com (mail-centralusazon11011050.outbound.protection.outlook.com [52.101.62.50])
	by imf08.hostedemail.com (Postfix) with ESMTP id 3A10A16000B
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 12:11:45 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=zfeoRhtg;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf08.hostedemail.com: domain of shivankg@amd.com designates 52.101.62.50 as permitted sender) smtp.mailfrom=shivankg@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773058305;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kOsJznQvzpPNkoFq6ElzZE5tlcE0D+t5P1bqJv1kvJM=;
	b=emN++y3l8jv/qEph0ngC5qFGvmxbhzf14ooWydJ550CpSmX02BupRw4WQ/gaWuXTSk8vqs
	uBe3W2Hu+osYpgeg5ov3M6qbb3nLkNfRj+ft0TWmBJkIcdZh8YS2wQP+WPwxxHGBZljCH4
	XQm4Ps/0h02yEJm2aMjwO69EqBOfsDA=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1773058305; a=rsa-sha256;
	cv=pass;
	b=Ai2zXSXnFJMJ3kTLOxYCqTkMNGazXW8XiEiwTzQq/gHG1Zob91h6FXmC7PGpyBzVsB7O8I
	Ec5H80Yck4VeyzL0vkDicjQVWmRKCENmd+EYZHz91My5sAUMVir/9NX42L+obSTN8jhk1/
	28VG34MvnBdM+y9861WV7V5O3ZGmyVU=
ARC-Authentication-Results: i=2;
	imf08.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=zfeoRhtg;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf08.hostedemail.com: domain of shivankg@amd.com designates 52.101.62.50 as permitted sender) smtp.mailfrom=shivankg@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=S1GoyGaycwwWFwTMdEL6X3UlJ8MDOamluT6IpWHIQJ8IKnFD7fGqoBB5+8U25HBKWj6F6uf+LYgHhT30EQU+7KNpHQ6vYZ5DASuw99Pa8RaK+md1vIf1wQhoQy1nnga2E7Tuj/iYz33fLMpcjwqIGIOIr1uf7KIk2F2P0624bhjGbm3qu9bWwkDFPBYmg4lL/gnZZ70NMakE4X9MMlz3nzQrbB7lWssmkD4SAoiO+AqlOxu9ilpeW+YKNTJiHXyhnYfgw4Dadtf9xsf9XeAKPsSdHM8sOIyO0GvcGLu+z8q9hkjU+6vPdEhuDqet25OJILVNoK24ySOYc3XBHETzhg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kOsJznQvzpPNkoFq6ElzZE5tlcE0D+t5P1bqJv1kvJM=;
 b=dpQR7oFpTPB6RWuxLA7azEP01KaLUX5HIpfdNtrHeFW1KTpfmPiZAhf7/D4rM6r+z/ZNDvZ4gLSJU488SPKtovSd/OG8amv1W3p8YT9OO/SeEfhqeTt5OstfqsKpXnNb4wkYvu8lED7KLfSPkSSkmnKnUrU5xz0hOOz6qLqn5JK8J4b7zgbMic3svalrdMnYd4+nYaOcN1btv958sXjnK0hE11dyQTvidiOZDp1h/Sp3UPMTRP0T/vXvyRNYFpSkRDt8hVQfw9DR70rFys0H0BzJY3csNivUXOxImFW4g95bCny9f7vS9dhpoAW4tq0o/xoxFMCYMFFCp2ekti3mSw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=linux-foundation.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kOsJznQvzpPNkoFq6ElzZE5tlcE0D+t5P1bqJv1kvJM=;
 b=zfeoRhtgtY8SVeG34SK7FkEHLwXyIYx0chsCwh85VSeqCl+jmQlMod/qfiwIacSxPIKt0nIPYGui2ARiUKWU4ZytfbPSD79dUUjPTGin/WrqG6QdKyZx/zXuluZqQxl1X/ThQNb5usZELrgeOLp5AhHP4+IDHekv841lxrv0UBA=
Received: from MN0P223CA0029.NAMP223.PROD.OUTLOOK.COM (2603:10b6:208:52b::18)
 by EAYPR12MB999155.namprd12.prod.outlook.com (2603:10b6:303:2be::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9700.11; Mon, 9 Mar
 2026 12:11:37 +0000
Received: from BL6PEPF0001AB51.namprd04.prod.outlook.com
 (2603:10b6:208:52b:cafe::b2) by MN0P223CA0029.outlook.office365.com
 (2603:10b6:208:52b::18) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9678.25 via Frontend Transport; Mon,
 9 Mar 2026 12:11:29 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb08.amd.com; pr=C
Received: from satlexmb08.amd.com (165.204.84.17) by
 BL6PEPF0001AB51.mail.protection.outlook.com (10.167.242.75) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9678.18 via Frontend Transport; Mon, 9 Mar 2026 12:11:36 +0000
Received: from satlexmb10.amd.com (10.181.42.219) by satlexmb08.amd.com
 (10.181.42.217) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Mon, 9 Mar
 2026 07:11:36 -0500
Received: from kaveri.amd.com (10.180.168.240) by satlexmb10.amd.com
 (10.181.42.219) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Mon, 9 Mar
 2026 07:11:25 -0500
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
	<linux-mm@kvack.org>, Shivank Garg <shivankg@amd.com>, Mike Day
	<michael.day@amd.com>
Subject: [RFC PATCH v4 4/6] mm/migrate: add copy offload registration infrastructure
Date: Mon, 9 Mar 2026 12:07:29 +0000
Message-ID: <20260309120725.308854-12-shivankg@amd.com>
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
X-MS-TrafficTypeDiagnostic: BL6PEPF0001AB51:EE_|EAYPR12MB999155:EE_
X-MS-Office365-Filtering-Correlation-Id: a6f34e71-09ed-426b-6691-08de7dd5033b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|7416014|376014|82310400026|36860700016;
X-Microsoft-Antispam-Message-Info:
	R1uQwdUPokr4PltjlEmsMxyYP/NHWwpN+ME7k7Zyy+R6AJ/fQR2Jpda6fdESb8LV2ddRGA1jIdE3YJ84xfmJOrjLuAXSe8ce+YD8IqhLm/po/shpQTL6yVgzqtqNQcg3bNAt2AINLvGPE0r5SQaAoi/+48W52bQE7zFO/4bbgc8nE2GZZPp6pX2X2vmvnoGQId9A9QSohial0Vmw01jelVZhw3NojyBzuua9x9ipDrFGsTFs/Bhc35mHQiky0GYLcNJZ1bwUE9/hIfvF0L1JjYBGqXeOFUJNde5SWNNbVUVD8lox8kHlYcuATc6uJJmZQ4FstdkcWGYwtm+UY7oxUSQKM+X+0WjNxSpxKPcLOExTbcJmIEnKfEGja07AmO9zK6hq1sQ8+bmA9bh/yxONQZbiSkOi5YYjNU/gwJE3/ikO/XsBFiHuivPLCTcnzymJDVwoFosiVnH3zJx0pEenaenwCjhmMJdTdHdywbntrLW+xR26K0X2MLBUiWQ6OaotmD0SMS/XVUheh8K0yotS13RjOW9V2RkUJtFtW0zOnPF4f8hFlpc/K4UcAIccuJQe3zaIuVoWrLW1/P4yYZVZ9thQe8PfSHcIjmIkjhs2gdS9cmt5E8lxaO5Gb+j0BRxrhY0s38rZS8tQyAbLdVVo366NJwywON6v1TcTVA+w39IRtaoFCMDZGcLJ8N5gWDWCCHnWhRFC4Zf4woSC6tI9KggXTlw+SFQyyrgD9vPXsLZualo8g1cVMqxgfL70aY5utZdYc3lq5kiT3MSs2nwYKg==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb08.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(82310400026)(36860700016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	IoZNU/j4gAQ5fquyp+lUJ2b16A4D0RmN7FWF8l8JajLPL7e8OYCGKaHSPcyyhNMqzaMWmNVReczyTvH9rgOqAVt6MuiJFLUZJ9L4gZDF3qekpHzFTcmDMU4gVyVMKefsRIc8ARTjonHKWliAkcdSqGxmh/o539mfeBYwXYZPVKN+CV4nfCFeO3CO/2lFAC7q16uaPxakZft1Dgv0mlNp6QDdNete5opkUH0Sbub9WhVcz/Uen8hncVB9K9Hnvp1B9y84RWXB1Kkk/ppwwKP4FoNXvp4R6T8k26VT/Q0Z6X2xsD15dOBA+0BBpSHOsMhbgKsbYT4ME7jA9gbqlSBIMk4V7XmhwzSLCSDfhQ9qilKy+uYNgdwgZrG+02b0rLTrS8wgs0Eg1XRcznnZhUVAnKRWW4hERtmbnfWVmV85XCHLPCxr6M+/vnRj69IyD+WC
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Mar 2026 12:11:36.8487
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a6f34e71-09ed-426b-6691-08de7dd5033b
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb08.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL6PEPF0001AB51.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: EAYPR12MB999155
X-Rspam-User: 
X-Stat-Signature: 7e48n4birr4mceqoq8jui541sd6gf7sy
X-Rspamd-Queue-Id: 3A10A16000B
X-Rspamd-Server: rspam03
X-HE-Tag: 1773058305-6430
X-HE-Meta: U2FsdGVkX18HerQWXMEwgo66xyS6zKbzNN7e7lwVJs7mTi5xu1qIA5lBU3cC9QcHy0fKk2yNr/MC1TOmU8fL9wn6rre+JrHu04LU6fpL1VvnKMj+quA9yd7t/Y1BF97aObzaMZNOU/1FjGf1sIhs7cJXcvcMEtgiB9tBVOHHVnNptFabwIkScCTGM2rcMKFYprcaJcVbm2e336C4ZTEeUXvePu7nQ8p/nCcqRmBEDD3i5uT2KLpA2gMMnHrbp+hYv268WVyOlQQPwcVjvnfjMwgrT26/BbUH9Za40cqo4F0u3K+Q6gfwijI7sMu6BhSlpVg9l/3ZqqVtlfP8aEKI42PvCMuHm8Gt0YndiHQ+ZWKOYSXBO7XNGZK55geLkSxvXRHvleDOy8wJv2Q97FDjrDE5f8Eb2B369JgWxIf7+sznuCFzGWwh8DEJZ3DkgScBqyXKH1Y65EPiSS4ypK3TEhqlO1XRuLsJD1hN/IGCd/IdloqBx8pR2cqZCMYBYojP211LOqmfaOu55RWj+JSKs2/bQ19JpMrmyYeQtuX2pgINVljv+MMm8hE2F9GLCT8aOsuBkk7gW8Fwc77/oge8yTvb4e8Zw6nbNkx2HYYv7LoRQMm/bScGAm3Vv38OqLPIQn1MVQ8Co0EqnzOcPOHYiP9J8zxhyFR141RZth5ac0LJoVFQrxu5gYmICIr107MvclbY6HpXQnSwyLpZKelmdyYYDd2qmlFhZtSxxstRL92cViwy3bGrNOClsrZL+tbFvEvAaOJlGL2aSAJia0DTjcsp8pJwbfig00G+q7corD9PjiBv9dgKA+uON/kY8trsu1Tfj2QIi0Tphtp2JYGulK9Ds6f/btzA2qLLAdoEWD2he+hm4MGgpHY4eq0TztJCDrhHShq9tYk2OemwQHjmW5O0n7Y0K8VSjWJqYwVnP9mEdFS6whOdtIPg88K2LMUPYR/GfHdc0Nj57e8ahT+
 x+QbO5g0
 YljFaTn+aamT01CgaSiDa+Q5Vgwvv3V5kr7rXUSjWHiaJS/n1zcB9I/PCM98QW9KxzGL4dlt5oGtRGx09JJUWHtt0Hbmr8G7EPVqsROjKsVGrASWSsSq5uCN3WhoN22bZmCLH5F8STDDczxkHhj3+5vi4zoTxHOUQxQC1DdMwIv/nVuKk5epKhTYynnbL4jZzC3C6usKfg5a7IJP2/MlWkMja1ner4GbfxI3YaVSZdiT9XHlfWFOvwWQFF5EpxMJeF7QVd/O2reaG85P1l0SAVcEVJLu5Jp+6cUWkIUOeaERGOOWynUisMkNQ3V/11SiAgmMwzWHvP2kVyBxGH03acagNmfOX3/UksemFoCztgV7n4I4UUA6k8DNpM/50e2Hvo3nxPS23YaS1Dl++9dgsleJrPJ3K3iRArI4jRDgdiMQYHe67zv0xRuUzyAGY+c6X2WmsBl5EwkdRw5rCL+7IxFNzpW8qhmH75rV/7T2quxgyk63cZXvX3PxGeGXmVGbXmuQQLQEzPIQk26M=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Introduce CONFIG_MIGRATION_COPY_OFFLOAD, which lets offload driver
(DMA, multi-threaded CPU copy, etc) take over the batch folio copy in
migrate_pages_batch().

Offload driver fill in a struct migrator with their offload_copy() and
should_batch() implementation and call migrate_offload_start(), which
patches the migrate_offload_copy() static_call and flips the
migrate_offload_enabled static branch. The migrate_offload_stop() call
reverts both.

Only one migrator can be active a time. A second registration returns
-EBUSY, and only the active migrator can stop itself. The static_call
dispatch is under SRCU so synchronize_srcu() in stop path guarantees
no in-flight copy before the module reference is dropped.

Co-developed-by: Mike Day <michael.day@amd.com>
Signed-off-by: Mike Day <michael.day@amd.com>
Signed-off-by: Shivank Garg <shivankg@amd.com>
---
 include/linux/migrate_copy_offload.h | 34 ++++++++++
 mm/Kconfig                           |  9 +++
 mm/Makefile                          |  1 +
 mm/migrate.c                         | 30 ++++++++-
 mm/migrate_copy_offload.c            | 99 ++++++++++++++++++++++++++++
 5 files changed, 171 insertions(+), 2 deletions(-)
 create mode 100644 include/linux/migrate_copy_offload.h
 create mode 100644 mm/migrate_copy_offload.c

diff --git a/include/linux/migrate_copy_offload.h b/include/linux/migrate_copy_offload.h
new file mode 100644
index 000000000000..ee112826ebdf
--- /dev/null
+++ b/include/linux/migrate_copy_offload.h
@@ -0,0 +1,34 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _LINUX_MIGRATE_COPY_OFFLOAD_H
+#define _LINUX_MIGRATE_COPY_OFFLOAD_H
+
+#include <linux/jump_label.h>
+#include <linux/srcu.h>
+#include <linux/types.h>
+
+struct list_head;
+struct module;
+
+#define MIGRATOR_NAME_LEN 32
+
+struct migrator {
+	char name[MIGRATOR_NAME_LEN];
+	int (*offload_copy)(struct list_head *dst_list,
+			    struct list_head *src_list,
+			    unsigned int folio_cnt);
+	bool (*should_batch)(int reason);
+	struct module *owner;
+};
+
+#ifdef CONFIG_MIGRATION_COPY_OFFLOAD
+extern struct static_key_false migrate_offload_enabled;
+extern struct srcu_struct migrate_offload_srcu;
+bool migrate_should_batch_default(int reason);
+int migrate_offload_start(struct migrator *m);
+int migrate_offload_stop(struct migrator *m);
+#else
+static inline int migrate_offload_start(struct migrator *m) { return 0; }
+static inline int migrate_offload_stop(struct migrator *m) { return 0; }
+#endif /* CONFIG_MIGRATION_COPY_OFFLOAD */
+
+#endif /* _LINUX_MIGRATE_COPY_OFFLOAD_H */
diff --git a/mm/Kconfig b/mm/Kconfig
index ebd8ea353687..faf0cae9991b 100644
--- a/mm/Kconfig
+++ b/mm/Kconfig
@@ -648,6 +648,15 @@ config MIGRATION
 config DEVICE_MIGRATION
 	def_bool MIGRATION && ZONE_DEVICE
 
+config MIGRATION_COPY_OFFLOAD
+	bool "Page migration copy offload"
+	depends on MIGRATION
+	help
+	  Adds migration copy offload infrastructure which allow
+	  offload engines (DMA, multi-threaded CPU copy, etc.) to
+	  register as the batch-copy provider for page migration
+	  via migrate_offload_start()/migrate_offload_stop().
+
 config ARCH_ENABLE_HUGEPAGE_MIGRATION
 	bool
 
diff --git a/mm/Makefile b/mm/Makefile
index 8ad2ab08244e..db1ac8097089 100644
--- a/mm/Makefile
+++ b/mm/Makefile
@@ -96,6 +96,7 @@ obj-$(CONFIG_FAILSLAB) += failslab.o
 obj-$(CONFIG_FAIL_PAGE_ALLOC) += fail_page_alloc.o
 obj-$(CONFIG_MEMTEST)		+= memtest.o
 obj-$(CONFIG_MIGRATION) += migrate.o
+obj-$(CONFIG_MIGRATION_COPY_OFFLOAD) += migrate_copy_offload.o
 obj-$(CONFIG_NUMA) += memory-tiers.o
 obj-$(CONFIG_DEVICE_MIGRATION) += migrate_device.o
 obj-$(CONFIG_TRANSPARENT_HUGEPAGE) += huge_memory.o khugepaged.o
diff --git a/mm/migrate.c b/mm/migrate.c
index 69daa16f9cf3..acaaa9cc0d4f 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -44,6 +44,8 @@
 #include <linux/memory-tiers.h>
 #include <linux/pagewalk.h>
 #include <linux/jump_label.h>
+#include <linux/static_call.h>
+#include <linux/migrate_copy_offload.h>
 
 #include <asm/tlbflush.h>
 
@@ -54,6 +56,17 @@
 
 DEFINE_STATIC_KEY_FALSE(migrate_offload_enabled);
 
+#ifdef CONFIG_MIGRATION_COPY_OFFLOAD
+DEFINE_SRCU(migrate_offload_srcu);
+DEFINE_STATIC_CALL(migrate_offload_copy, folios_mc_copy);
+
+bool migrate_should_batch_default(int reason)
+{
+	return false;
+}
+DEFINE_STATIC_CALL(migrate_should_batch, migrate_should_batch_default);
+#endif
+
 static const struct movable_operations *offline_movable_ops;
 static const struct movable_operations *zsmalloc_movable_ops;
 
@@ -1820,11 +1833,18 @@ static int migrate_pages_batch(struct list_head *from,
 	LIST_HEAD(dst_batch);
 	LIST_HEAD(src_std);
 	LIST_HEAD(dst_std);
+	bool do_batch = false;
 	bool nosplit = (reason == MR_NUMA_MISPLACED);
 
 	VM_WARN_ON_ONCE(mode != MIGRATE_ASYNC &&
 			!list_empty(from) && !list_is_singular(from));
 
+#ifdef CONFIG_MIGRATION_COPY_OFFLOAD
+	/* Check if the offload driver wants to batch for this reason */
+	if (static_branch_unlikely(&migrate_offload_enabled))
+		do_batch = static_call(migrate_should_batch)(reason);
+#endif
+
 	for (pass = 0; pass < nr_pass && retry; pass++) {
 		retry = 0;
 		thp_retry = 0;
@@ -1967,7 +1987,7 @@ static int migrate_pages_batch(struct list_head *from,
 				break;
 			case 0:
 				if (static_branch_unlikely(&migrate_offload_enabled) &&
-				    folio_supports_batch_copy(folio)) {
+				    do_batch && folio_supports_batch_copy(folio)) {
 					list_move_tail(&folio->lru, &src_batch);
 					list_add_tail(&dst->lru, &dst_batch);
 					nr_batch++;
@@ -1997,11 +2017,17 @@ static int migrate_pages_batch(struct list_head *from,
 	/* Flush TLBs for all unmapped folios */
 	try_to_unmap_flush();
 
+#ifdef CONFIG_MIGRATION_COPY_OFFLOAD
 	/* Batch-copy eligible folios before the move phase */
 	if (!list_empty(&src_batch)) {
-		rc = folios_mc_copy(&dst_batch, &src_batch, nr_batch);
+		int idx = srcu_read_lock(&migrate_offload_srcu);
+
+		rc = static_call(migrate_offload_copy)(&dst_batch,
+				&src_batch, nr_batch);
+		srcu_read_unlock(&migrate_offload_srcu, idx);
 		batch_copied = (rc == 0);
 	}
+#endif
 
 	retry = 1;
 	for (pass = 0; pass < nr_pass && retry; pass++) {
diff --git a/mm/migrate_copy_offload.c b/mm/migrate_copy_offload.c
new file mode 100644
index 000000000000..c22068fe09a0
--- /dev/null
+++ b/mm/migrate_copy_offload.c
@@ -0,0 +1,99 @@
+// SPDX-License-Identifier: GPL-2.0
+#include <linux/jump_label.h>
+#include <linux/module.h>
+#include <linux/srcu.h>
+#include <linux/migrate.h>
+#include <linux/migrate_copy_offload.h>
+#include <linux/static_call.h>
+
+static DEFINE_MUTEX(migrator_mutex);
+static struct migrator *active_migrator;
+
+DECLARE_STATIC_CALL(migrate_offload_copy, folios_mc_copy);
+DECLARE_STATIC_CALL(migrate_should_batch, migrate_should_batch_default);
+
+/**
+ * migrate_offload_start - register a batch-copy provider for page migration.
+ * @m: migrator to install.
+ *
+ * Only one provider can be active at a time, returns -EBUSY if another migrator
+ * is already registered.
+ *
+ * Return: 0 on success, negative errno on failure.
+ */
+int migrate_offload_start(struct migrator *m)
+{
+	int ret = 0;
+
+	if (!m || !m->offload_copy)
+		return -EINVAL;
+
+	mutex_lock(&migrator_mutex);
+	if (active_migrator) {
+		ret = -EBUSY;
+		goto unlock;
+	}
+
+	if (m->owner && !try_module_get(m->owner)) {
+		ret = -ENODEV;
+		goto unlock;
+	}
+
+	static_call_update(migrate_offload_copy, m->offload_copy);
+	static_call_update(migrate_should_batch,
+		m->should_batch ? m->should_batch : migrate_should_batch_default);
+	active_migrator = m;
+	static_branch_enable(&migrate_offload_enabled);
+
+unlock:
+	mutex_unlock(&migrator_mutex);
+
+	if (ret)
+		pr_err("migrate_offload: %s: failed to register (%d)\n",
+		       m->name, ret);
+	else
+		pr_info("migrate_offload: enabled by %s\n", m->name);
+	return ret;
+}
+EXPORT_SYMBOL_GPL(migrate_offload_start);
+
+/**
+ * migrate_offload_stop - unregister the active batch-copy provider.
+ * @m: migrator to remove (must be the currently active one).
+ *
+ * Reverts static_call targets and waits for SRCU grace period so that
+ * no in-flight migration is still calling the driver functions before
+ * releasing the module.
+ *
+ * Return: 0 on success, negative errno on failure.
+ */
+int migrate_offload_stop(struct migrator *m)
+{
+	struct module *owner;
+
+	mutex_lock(&migrator_mutex);
+	if (active_migrator != m) {
+		mutex_unlock(&migrator_mutex);
+		return -EINVAL;
+	}
+
+	/*
+	 * Disable the static branch first so new migrate_pages_batch calls
+	 * won't enter the batch copy path.
+	 */
+	static_branch_disable(&migrate_offload_enabled);
+	static_call_update(migrate_offload_copy, folios_mc_copy);
+	static_call_update(migrate_should_batch, migrate_should_batch_default);
+	owner = active_migrator->owner;
+	active_migrator = NULL;
+	mutex_unlock(&migrator_mutex);
+
+	/* Wait for all in-flight callers to finish before module_put(). */
+	synchronize_srcu(&migrate_offload_srcu);
+	if (owner)
+		module_put(owner);
+
+	pr_info("migrate_offload: disabled by %s\n", m->name);
+	return 0;
+}
+EXPORT_SYMBOL_GPL(migrate_offload_stop);
-- 
2.43.0


