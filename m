Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A2952C5AC67
	for <linux-mm@archiver.kernel.org>; Thu, 13 Aug 2026 04:24:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 67B506B039D; Thu, 13 Aug 2026 00:24:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 652E66B039F; Thu, 13 Aug 2026 00:24:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 51B0D6B03A0; Thu, 13 Aug 2026 00:24:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 315356B039D
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 00:24:49 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id AB8D7804F6
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 04:24:48 +0000 (UTC)
X-FDA: 85094955456.04.13FF2A1
Received: from SN4PR2101CU001.outbound.protection.outlook.com (mail-southcentralusazon11012070.outbound.protection.outlook.com [40.93.195.70])
	by imf14.hostedemail.com (Postfix) with ESMTP id 7C45D100005
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 04:24:45 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=mnqDn7Q0;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf14.hostedemail.com: domain of shivankg@amd.com designates 40.93.195.70 as permitted sender) smtp.mailfrom=shivankg@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786595085;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZRqRWWSb5j6yTTmBTX55vjP5pv3HsdIGpRfv7y0RJsg=;
	b=zWZ0UFT95qMEkqRcovfk+lVZhAS5729nTPH8yLu9CbJ+yQFaGjyUI5R0oE0tgUGMhIrcT8
	+nWdDGO64TR7k3N/4UpuEl/GafvCIgmLuqJqgMC3IOidl3Up7wOLRMnDJyjm3PV/oWqvF0
	BUaUkKH3HNDsHiqDvU4SKIHQL/ynORs=
ARC-Authentication-Results: i=2;
	imf14.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=mnqDn7Q0;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf14.hostedemail.com: domain of shivankg@amd.com designates 40.93.195.70 as permitted sender) smtp.mailfrom=shivankg@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1786595085;
	b=ycQAAYo0BGryMMP1e2aOBujw3xwKhDmQnOHI3jbixocEHdIAdf4ipBtKkxvHlF4ptJ/ino
	XLYjPy/sn/exq3iaWAPQ9dyGVsiBTEurQHweR6I1wXNpqa/j1jEIAIkUqk/l326aszo+aD
	a9DidArW7eUlSA7Z3vZF+WVy6xv4upU=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=moEOJ8v6aUgy+egCipR0DnZFrF6C8mz+yj/IFPim2Eie65lyhK23yQdQHtVMZNfPWsPpfEZRkh+3KAMzPY5x9W+GoGcwgMxTGrhMJa23NHb2hP92h1xPYUJvCjsiun0UYCa2vzNs8fgE3mNvAgLz8V68JPEXoF7Ag1P2YTxmoyjgdxATKQyqKTcbHNnAbAVmKUJ+FK3afZTlVf6zaTlZ3UIAqMrOzlRPTY0hALigcEmdjA5+YGWdLoqgk579sloC2W0Xo1QKOgnWaLsLBkJNOSxI0gZbaS74uF7rgzXj0fkobs0vKeZ56WL4+51OTZtcN4PBaGB7z/XyXTGo+ikQcQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZRqRWWSb5j6yTTmBTX55vjP5pv3HsdIGpRfv7y0RJsg=;
 b=bVqoH3GHKg+6UFN6P1O8xlKnd58jMuqyOMF2U9usiQkboyqctO9+4weaBWWlJPofTaMFGJqLfTzbdT99jZFzPo9DOX6PewHJ6SG9HAaZz9b8MXatHy1xAlojLz2acecTgAJ7fauwfiXeyfnGKRW5qSru3NM7Fh/2zI3nbcYo7tFAMvr6NcTqlkwVpk88ZQDLvoSq6Td6u5nzJn7kQT0mBiyUylV9TY7jceatBbbXiClnkKPl2neSD/vnEqC406bJxAQbDF7Mi1wsZYUNLCBXYOWnkIPD6K9CkOIu7QHr0+UC41oSfpDzwh8hnnHPuKb43fCC/5vtsfzIfcM1/sTUuA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=surriel.com smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZRqRWWSb5j6yTTmBTX55vjP5pv3HsdIGpRfv7y0RJsg=;
 b=mnqDn7Q0sylZgz05kW2C3N9JljzhEuFQQRpapsGlGkz208IRVlTVlYj83P5i5/c4ZQLQ6HiyntlP5yF6KkP9OS+e+WlkG/F2goy4hvH3tJHPm8dj665jGIdWjrrLVM0FSdbWQIo2uq36Xc/xbSUoFSKLrDeJDvYhvY+a0Mxmzcg=
Received: from BN1PR12CA0024.namprd12.prod.outlook.com (2603:10b6:408:e1::29)
 by DS0PR12MB8070.namprd12.prod.outlook.com (2603:10b6:8:dc::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.315.14; Thu, 13 Aug
 2026 04:24:39 +0000
Received: from BN3PEPF0000B36D.namprd21.prod.outlook.com
 (2603:10b6:408:e1:cafe::76) by BN1PR12CA0024.outlook.office365.com
 (2603:10b6:408:e1::29) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.315.13 via Frontend Transport; Thu,
 13 Aug 2026 04:24:39 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 BN3PEPF0000B36D.mail.protection.outlook.com (10.167.243.164) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.339.0 via Frontend Transport; Thu, 13 Aug 2026 04:24:39 +0000
Received: from [127.0.1.1] (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Wed, 12 Aug
 2026 23:24:31 -0500
From: Shivank Garg <shivankg@amd.com>
Date: Thu, 13 Aug 2026 04:23:16 +0000
Subject: [PATCH v2 5/7] mm/rmap: factor out migration PTE construction
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-ID: <20260813-migrate-rmap-batch-v2-5-3c5424c555c7@amd.com>
References: <20260813-migrate-rmap-batch-v2-0-3c5424c555c7@amd.com>
In-Reply-To: <20260813-migrate-rmap-batch-v2-0-3c5424c555c7@amd.com>
To: Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand
	<david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, Rik van Riel
	<riel@surriel.com>, "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka
	<vbabka@kernel.org>, Harry Yoo <harry@kernel.org>, Jann Horn
	<jannh@google.com>, Lance Yang <lance.yang@linux.dev>, Mike Rapoport
	<rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko
	<mhocko@suse.com>, Zi Yan <ziy@nvidia.com>, Matthew Brost
	<matthew.brost@intel.com>, Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim
	<rakie.kim@sk.com>, Byungchul Park <byungchul@sk.com>, Gregory Price
	<gourry@gourry.net>, Ying Huang <ying.huang@linux.alibaba.com>, "Alistair
 Popple" <apopple@nvidia.com>
CC: Karim Manaouil <kmanaouil.dev@gmail.com>, Frank van der Linden
	<fvdl@google.com>, Kinsey Ho <kinseyho@google.com>, Wei Xu
	<weixugc@google.com>, Bharata B Rao <bharata@amd.com>, David Rientjes
	<rientjes@google.com>, Dev Jain <dev.jain@arm.com>, <linux-mm@kvack.org>,
	<linux-kernel@vger.kernel.org>, Shivank Garg <shivankg@amd.com>
X-Mailer: b4 0.15-dev-47d62
X-Developer-Signature: v=1; a=ed25519-sha256; t=1786595034; l=3397;
 i=shivankg@amd.com; s=20260518; h=from:subject:message-id;
 bh=XPr8YUsucdGRr57yCFjtBHp/S9a5uQAWQYAef73VHRg=;
 b=q81NvIpe7hWML/CjPNB/HNBJcafRJrFxDfh1/7ESLRM1OrkP01YOlvJcanhOI0SgCeFJaQ5zG
 wV37t8RWhQWByM9dW4Z9BKaU3ke+DXV0b8J8CI9CcdVK27+aUmRnW7Y
X-Developer-Key: i=shivankg@amd.com; a=ed25519;
 pk=2l2QGTeXuGkZTtfmx0nPQU8iFZfjYmX/ymMojitevx4=
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: satlexmb08.amd.com (10.181.42.217) To satlexmb07.amd.com
 (10.181.42.216)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN3PEPF0000B36D:EE_|DS0PR12MB8070:EE_
X-MS-Office365-Filtering-Correlation-Id: f70c63a4-5ef5-434e-5573-08def8f2ca6a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|376014|7416014|36860700016|82310400026|1800799024|921020|56012099006|10067099003|11063799006|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	rdubjEIDasCMRV/3tXRrH68mMi4Y+oJgKnPOVInXGXmJm0QajC/P/EgogpeI+GrHZDwfwpVBXzdLAvkzefcgNHRE9Y8/I0+8wTvYLq6JarYafJeo89GUsoV7vXT1QLBeDJ8vTaeGH2A+XjY3G7ONKzzQVQ1RevEPeC0QruqXIJq1Wp9iaEOeGKlst+k/b0IG/aWNlq3YWpbwdD7erUxOhYm37QOt0fk/607V5vT6HkWk9YATnXL97glzvoP1eve7k6ZCTEOsG3qFyeP51j/k23bfzhOlGltYxuPQNMqq8YB7mv9jxDC5UGEsGWZ3ugV3szDcOy2kp0GC7hvaIFVlwtcbxVaeESgCQjyYC8JX5pc+vWrkXENxD6TY8qhRBwUeUlqOO7ephrsCz9NfK86E344h9GQ/dLQdQoclSM79hJ0SDjBvbiElptfqSPV7YBOPthqdZSR5kA72rZPOI8BB4B3U3PVz9bOCiRh57yePEooBj2E84EUOM3jYpVUWSMasIqTvos8mxZs0L82dSGgULLBz5YJ0mVdZPcUm+BKuXFwC142uEcGmSKJeRYkz0Nt3Qwg7WLnLbsIYEgdn+z3xt0bPiAj+w9Z6QbsBtV6tGnWOuxx6yuwr4b3kNeA7q4rbjiQ5bCUcCW+zBvMUl6JKq1FvkUh04duWHwAqAYsKuH69RHV5SIBZ0L6ddUN6WvmubUhb82rB3h+MWVAsNzqUPL/RFfo0aUB/+xpiTZOMw6M=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(23010399003)(376014)(7416014)(36860700016)(82310400026)(1800799024)(921020)(56012099006)(10067099003)(11063799006)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	UAFB79WREz4yPOCC8bYcuNHTIq88dnvbNA6kU4z+lvARH3BeytrQWIgGmSyHfRGi52I2KvRLNMB6/L+v9uq6b081lvCAKe1i/nVtrkm+zHboazck8A1Q1JNZPh7JV7XOQX6tvHC4nOSZnBkrlKn/qYWxmQFRf2UWJ6VE7Zn6AIjcWZS7j2X/meXuOAZ3cxzECRFRNW7vix0DN03oiU+sT/SKj66A5WoHSFiPQJDcpNA3fshbNdPMCeAF20uzTUs92mtjQsk/pYsESoXMXC7HdDa0FwsaC2dd3sqI+MSLJem7UYiHAnFqwUHc8pLo6yQQYpVOyJgtsxQSXqq+GY9V65GcEZ96JE0UGW7+MEYbG2ntfva7xYF2+REFwcXuqarQWK9In8VdEydHqmc62crLt7ZL3OVv6DWNHiltwFeCjmeo3q1EQ8YoorwVqPtpQLvj
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Aug 2026 04:24:39.4515
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f70c63a4-5ef5-434e-5573-08def8f2ca6a
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN3PEPF0000B36D.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB8070
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 7C45D100005
X-Stat-Signature: uf8rteth6emec159edgmfzcmqcdtqazr
X-Rspam-User: 
X-HE-Tag: 1786595085-307035
X-HE-Meta: U2FsdGVkX18CwMdbXgrgPxeOnx+YvLktDaLeB8ExQHov9ulVkcwaH3RuZFc/Z1sAWrXkF+4BQMiT7z76UvW7dSaF+CCirjPsJhVV6c11e7ScfrCltfSR03v5Dxw+j9/BF5KVrvQhRq3dXP6ezIdEsMbyqnoOFRj6OL9h+ctJnrNQUUsbuPSkFhE7JhseneMS5n2Q/u8z6mOe8JyvsAMJ6HUF9i0iEA4AQRuCxPDJ2uwRLM4kWbj3IhM7Xh48IMyOe/vm6j6Xpf2yhF45N7h2TK+S7twSXiFRaABfXAdE3LAg7WlD2quIs8KvoNE7nnPfd38V63+EG0ItjDsgEVU8xL1zv6yJ0nFjD8jDuqgjFABIFOPWFN1fa9poTj/BN8/LpvcDFPt+Vs01DxiEad8jfvA1f9+8NU4ifrtMtc/ofg1E6NGhMgSiLizC2Oqo2fLCnVnyrC8IpE86jrowyG1JpAakilJFSMpu8GIu+0iyV+Nr2WZhkZpgcYCDoAejNuLRGlY/BDqyCz63L+k54VBL0U1MH3qymbl2S3WQuApBiDH9IX1J/J+fnaKKr5xBOE505fosnl6MiRwklVtN043VF27CUhEoTjDQuBhLkeGr7YkbfIDpMoOtiOP9txi0W8E4+2NYfX+Mh7kcjZ8bPeKEn/jmcRaYq8k+bxnoh8sfv2Lb5r3YKtlkhpHjPBU5NSY6QcIXIyp9SZy4yMt1xr42fPV4W1dP0w6SERXfhqIMdr+U3iiao/F68hHWLLFJm0N+nHm50X7BZFuG+q1m1ZsR81thYEU5AUyYrgfZUBIzu2Lq4x598W0NqFCIwzRet9uyCE3CiUDMu1iC3rH8zIVURAih8csnw2p+yJciGfjjLe9maFAks80g8oeyfYs179q3W1+MCxlJskrGPscaFcWR3C2DRf5K0boGHdUZePjoAayTc5EOfCsEN0hvYhZSfnTzGvfi4vcEEtuT9OeLMMU
 o4hzjrDz
 ETMJm7cZKsgKFibQYW+xBFwrqjHGnj+UBlU1R4LZxaYaZbm/YG7tY96xKELUw6HgfoGOlQ2B7AzHcDBg+GLA+s5UxltlfuQFemf83C/js2T21Sobkh5HHgWqNFRtn9AhhUwSPuu07BwYvk5NRwBLjGBoAYxCjAqGCH40e8W2d5kMUqw0OvTsDVvCQYF5BqO0JsEgd83hwGDdfkIgRnUijSkLpOAelu5kK7cwL0Tz4i05xhoLia16qyycA2Az6nH+VMGzRwx1DzzsHjybEs7KYDJJO245xhv1GRST1RXva4PqJ21lVHi6k0nuyibXDmEkDi8RAvi/xFaf7GHEHdo23l72asolSiTeUJUk2IvO/m0LTRsJkeb/vsNBba7yE20TlcTDTiq1wM+nU0HQYuYXp2LxnJaYSmyAixwUUTufEg++WBoVoruFBxCmcy4SLoyswk8VXQvV9ih+4oMACSNxM1wWpPDLqO1BCDnh3wciuySKvpiRKbiv/KmgledprB76GMckEWsOJtIME63KnWMzhtUOH8151jmYpswAx
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

try_to_migrate_one() constructs the migration PTE that replaces a
present PTE or non-present swap PTE.

Factor it into make_migration_pte() which can be shared when the
hugetlb migration path is separated.

No functional change intended.

Signed-off-by: Shivank Garg <shivankg@amd.com>
---
 mm/rmap.c | 65 +++++++++++++++++++++++++++++++++++++--------------------------
 1 file changed, 38 insertions(+), 27 deletions(-)

diff --git a/mm/rmap.c b/mm/rmap.c
index 0a4a0945dc65..8b89e32ae489 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -2507,6 +2507,42 @@ void try_to_unmap(struct folio *folio, enum ttu_flags flags)
 		rmap_walk(folio, &rwc);
 }
 
+/* Build the migration PTE that replaces pteval for a page. */
+static pte_t make_migration_pte(struct page *page, pte_t pteval,
+		bool writable, bool anon_exclusive)
+{
+	swp_entry_t entry;
+	pte_t swp_pte;
+
+	if (writable)
+		entry = make_writable_migration_entry(page_to_pfn(page));
+	else if (anon_exclusive)
+		entry = make_readable_exclusive_migration_entry(
+						page_to_pfn(page));
+	else
+		entry = make_readable_migration_entry(page_to_pfn(page));
+
+	if (likely(pte_present(pteval))) {
+		if (pte_young(pteval))
+			entry = make_migration_entry_young(entry);
+		if (pte_dirty(pteval))
+			entry = make_migration_entry_dirty(entry);
+		swp_pte = swp_entry_to_pte(entry);
+		if (pte_soft_dirty(pteval))
+			swp_pte = pte_swp_mksoft_dirty(swp_pte);
+		if (pte_uffd(pteval))
+			swp_pte = pte_swp_mkuffd(swp_pte);
+	} else {
+		swp_pte = swp_entry_to_pte(entry);
+		if (pte_swp_soft_dirty(pteval))
+			swp_pte = pte_swp_mksoft_dirty(swp_pte);
+		if (pte_swp_uffd(pteval))
+			swp_pte = pte_swp_mkuffd(swp_pte);
+	}
+
+	return swp_pte;
+}
+
 /*
  * @arg: enum ttu_flags will be passed to this argument.
  *
@@ -2737,7 +2773,6 @@ static bool try_to_migrate_one(struct folio *folio, struct vm_area_struct *vma,
 			 */
 			dec_mm_counter(mm, mm_counter(folio));
 		} else {
-			swp_entry_t entry;
 			pte_t swp_pte;
 
 			/*
@@ -2779,32 +2814,8 @@ static bool try_to_migrate_one(struct folio *folio, struct vm_area_struct *vma,
 			 * pte. do_swap_page() will wait until the migration
 			 * pte is removed and then restart fault handling.
 			 */
-			if (writable)
-				entry = make_writable_migration_entry(
-							page_to_pfn(subpage));
-			else if (anon_exclusive)
-				entry = make_readable_exclusive_migration_entry(
-							page_to_pfn(subpage));
-			else
-				entry = make_readable_migration_entry(
-							page_to_pfn(subpage));
-			if (likely(pte_present(pteval))) {
-				if (pte_young(pteval))
-					entry = make_migration_entry_young(entry);
-				if (pte_dirty(pteval))
-					entry = make_migration_entry_dirty(entry);
-				swp_pte = swp_entry_to_pte(entry);
-				if (pte_soft_dirty(pteval))
-					swp_pte = pte_swp_mksoft_dirty(swp_pte);
-				if (pte_uffd(pteval))
-					swp_pte = pte_swp_mkuffd(swp_pte);
-			} else {
-				swp_pte = swp_entry_to_pte(entry);
-				if (pte_swp_soft_dirty(pteval))
-					swp_pte = pte_swp_mksoft_dirty(swp_pte);
-				if (pte_swp_uffd(pteval))
-					swp_pte = pte_swp_mkuffd(swp_pte);
-			}
+			swp_pte = make_migration_pte(subpage, pteval,
+						     writable, anon_exclusive);
 			if (folio_test_hugetlb(folio))
 				set_huge_pte_at(mm, address, pvmw.pte, swp_pte,
 						hsz);

-- 
2.43.0


