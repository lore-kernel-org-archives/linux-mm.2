Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0E20A606EE81
	for <linux-mm@archiver.kernel.org>; Tue,  3 Nov 2026 16:25:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=amd.com header.i=@amd.com header.a=rsa-sha256 header.s=selector1 header.b=oSQtlEHv
Received: by kanga.kvack.org (Postfix)
	id 11BE36B05BE; Tue,  3 Nov 2026 11:25:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0FB656B05C6; Tue,  3 Nov 2026 11:25:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0098E6B05CC; Tue,  3 Nov 2026 11:25:29 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id D1E7A6B05BE
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 11:25:29 -0500 (EST)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 67382A04A9
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 16:25:29 +0000 (UTC)
X-FDA: 85394333178.08.1EA4DC5
Received: from CH4PR04CU002.outbound.protection.outlook.com (mail-northcentralusazon11013009.outbound.protection.outlook.com [40.107.201.9])
	by imf23.hostedemail.com (Postfix) with ESMTP id 64B4E140005
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 16:25:26 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=oSQtlEHv;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf23.hostedemail.com: domain of radhey.shyam.pandey@amd.com designates 40.107.201.9 as permitted sender) smtp.mailfrom=radhey.shyam.pandey@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1793723126;
	b=4LnEbStA2tK+knu8Nb+GRK5Y5MaFZm00JZ8P8fseaZCcyIXwftDO2nbaGJ7vVXV13ouVIl
	kufvICuSCR+SO79W1RfT4BcrX0nhJSBpoN7sWF9R27iqoMjT/9JN3bZpG4cfS7tbvZp1wC
	FiKFtPrkGVXowOEHOXuY/L49wiqEk9A=
ARC-Authentication-Results: i=2;
	imf23.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=oSQtlEHv;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf23.hostedemail.com: domain of radhey.shyam.pandey@amd.com designates 40.107.201.9 as permitted sender) smtp.mailfrom=radhey.shyam.pandey@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793723126;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3im34LmcRYA+cSiE+sBGk7UdCBE4SoKxb7+/feltjdY=;
	b=iH3O4YeW8On9SypeX/vQZALjibpMwvYlfrraS6Y0AMwUWIQ3CMeP95W9iOaLd1b0nab1pH
	zP2fQdT+gnaNKHmz6/5aU+07wxg9mxXzg+UUhrokDufT+bzmXKpwyh0CkiSQ4M+1CtlihI
	uvnVGIiPl2v3IHs4dA5SqLMIMGN+/pE=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=iZ/CP4lF1yI/NWFk8EF6P4c9PHdgiz+tCW7wiRCgCL/ZapCGKfTBBgiKESCMVZV0rhNoctZ9rLvi2gWQoghhMhN4AsIKAwNPkWpnUACZDXmhkJZVzoNnuLjYtiIl4/SYx4lbDd8YA+wK8lJYVYBKgZCuQJNP5nBpvXPCk/7itbPikceVlgf6Xz9MWdKrzehAoD96LVNDdNZaDP9Rsiae05/XIOwlV3bfWzC0lNba1EV9rOX3Y7Hvawq+dFlRlB+f1oLWU5MgY9Yf2Z4rT7Q/yMJAwxzUCr7T1H+XLuYjt5/5f8kwtlVcnjdOBiL2MKt8HEE0/op+3WTRiW1+KWORMQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3im34LmcRYA+cSiE+sBGk7UdCBE4SoKxb7+/feltjdY=;
 b=vjInhPqiHu37AFiPgGAWMJF3Lnpn9GqtFMtwpHt2rMSSTJ2nyzPZ5rJJ1ZTHIV/yOS9wf46Ru9xiEU6iWnkQEn8/CRCdT85y8L0fMgAg0Zza/KvZPWluYzsFbJZXqbjmZKcNYxfTiW6eKJ89gK3XntCUsWiFQPxsng+S4tuEiY/Yo/N0wIabB8KSD9gBusYagekdTe1F3v5zXoMIMvP3MS57TQ73EIQeQqRCLsLR854UKg6IxhgHFQPxDyTFcdHFCLa/nOth8zOzvgPvD1EqjR+/878nsS8s+kba3UKqa23CX7Q9cvNzhN89hEG1+s5SwIBrrt/LP7Wx6O1zvc5/KA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3im34LmcRYA+cSiE+sBGk7UdCBE4SoKxb7+/feltjdY=;
 b=oSQtlEHvSDAkssEUG0mB1C7bPYGWQy6IHpAsL07JYnQ4B+RfCTLPpm6LBq68+xztF8E6BNN4Tcdkr579kWjAJxb7Bc9ofiPjg+4UPIvLV6vOBAXn28io6sHjxf+p7a1E1y3fgOTwl6kFUz9dsvUqm5zjHPAjKKq8UfTAlPZuKgU=
Received: from BY3PR05CA0045.namprd05.prod.outlook.com (2603:10b6:a03:39b::20)
 by DS7PR12MB6189.namprd12.prod.outlook.com (2603:10b6:8:9a::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.569.12; Tue, 3 Nov
 2026 16:25:19 +0000
Received: from MW1PEPF00018894.namprd03.prod.outlook.com
 (2603:10b6:a03:39b:cafe::34) by BY3PR05CA0045.outlook.office365.com
 (2603:10b6:a03:39b::20) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.592.8 via Frontend Transport; Tue, 3
 Nov 2026 16:25:19 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 165.204.84.17) smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 MW1PEPF00018894.mail.protection.outlook.com (10.167.249.171) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.592.5 via Frontend Transport; Tue, 3 Nov 2026 16:25:19 +0000
Received: from satlexmb08.amd.com (10.181.42.217) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.53; Tue, 3 Nov
 2026 10:25:08 -0600
Received: from xhdradheys41.xilinx.com (10.180.168.240) by satlexmb08.amd.com
 (10.181.42.217) with Microsoft SMTP Server id 15.2.2562.53 via Frontend
 Transport; Tue, 3 Nov 2026 10:25:03 -0600
From: Radhey Shyam Pandey <radhey.shyam.pandey@amd.com>
To: <robh@kernel.org>, <saravanak@kernel.org>, <akpm@linux-foundation.org>,
	<david@kernel.org>, <ljs@kernel.org>, <liam@infradead.org>,
	<vbabka@kernel.org>, <rppt@kernel.org>, <surenb@google.com>,
	<mhocko@suse.com>, <m.szyprowski@samsung.com>, <robin.murphy@arm.com>,
	<baoquan.he@linux.dev>, <pasha.tatashin@soleen.com>, <pratyush@kernel.org>
CC: <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-mm@kvack.org>, <iommu@lists.linux.dev>, <kexec@lists.infradead.org>,
	Radhey Shyam Pandey <radhey.shyam.pandey@amd.com>
Subject: [PATCH 4/4] mm/cma: drop the duplicate alignment check in rmem_cma_setup()
Date: Tue, 3 Nov 2026 21:54:29 +0530
Message-ID: <20261103162429.2053989-5-radhey.shyam.pandey@amd.com>
X-Mailer: git-send-email 2.44.4
In-Reply-To: <20261103162429.2053989-1-radhey.shyam.pandey@amd.com>
References: <20261103162429.2053989-1-radhey.shyam.pandey@amd.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MW1PEPF00018894:EE_|DS7PR12MB6189:EE_
X-MS-Office365-Filtering-Correlation-Id: c1fe01bd-8512-4efa-6e98-08df39c70d3c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|82310400026|7416014|376014|1800799024|36860700016|261022105027099003|261021121427099003|261021123027099003|921020|261026140227099003|261028144727099003|11063799006|56012099006|22082099003|261102123227099003|10067099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	epst9tIK9Nw6Flg9AL8MdPpXv18W7619t7mIdXDosX4vle939uBUjZQPbpfv6Frp+qD+7BSO0ddR+F5qjuMn5R6HqbNlydD1v5IyaZCJgu+OHE/CX9jTVYZ3jxuDQRsahnnI92oLV8Aq66ap7qtbyvnd8Zh6TgxcxDyxTtAte2UvOHfPKYMI6Gnrmd7rwWCn64nUsEfmseAUR8KMuZhfS6pjmlXVGodMGpXGjNS8ziVobmtH+p7z5QcSXauP/7b0QsjgEM8bIPJgXAzALFdN/Qh3nAdqQ6p+ksR12wJy1qFMDnuEdLAoHTYYzx05r+HI+aXwJPOoIItvwal79OmUkyZ8bFjc5Go330jXyh7auRShYZquN6WgDvAsU1ioBcauV+P8vEI+2P+NN13xKhfAhqrGsXs9VBfdw/AzmxyGSTuJH751ZUaVgAkfsEUgXZGvjrNZlt5qEH5CNU19+SG2Wyn7quM/9k/VH2WV69P+CiiElwvO9JvGz/29yf2K4JX4N71EqWfJjdw8RlCSSt1Ur5m/8MxPj7O5ktKe/CAqPzEUjUpXrJ6J2flVinnvIBIZ013Xs55GwMsxqZ4Jn0FgABKYPKAmKcjipsJgo3d4jGi27hgf9ZuWm4sxN7ZensiCIeFhQ+RlWnkNZlipqie9QzLNVGceVzf/dp1VWY/6bJsapXSybpSSPfuE+x19aaPZYII0JSSIKdeUpNwXuv5cmG4W+VZRVc3HxOtyv0f25CSEbSbeyLjlim6GbUZGP4pa
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(23010399003)(82310400026)(7416014)(376014)(1800799024)(36860700016)(261022105027099003)(261021121427099003)(261021123027099003)(921020)(261026140227099003)(261028144727099003)(11063799006)(56012099006)(22082099003)(261102123227099003)(10067099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	zDh0DEnEi7HvHxB5stq29M/5hR5i/o7prngSgh/2Y2vfy90PFxmh88zHzoepdI2Wf/ARuFGww7eKgAXs9pfM+mr+3kpzgdg8uEgqPOljg5MND0DVfhmLkSosCHj1SHtW2yfyp1774g9Nre5GS34XVJ8dK6x3mI+CFz4gkXGaqOtZP6wN/gPCxJ86BhnPcokwS/sG1GjKHXO9g/IUEPWCGYwuRvhz7i20S3E4O25aezr1QQAYjoaiY3Vhs8d+OW6Znrgshw9sBKhWD0p7B+1kK7zBpGknG1ZWOxtI1wp+mkDv1mmc6jij4pqxEuUzmN2ZS3DBRFJF5jvytu6ayRiOKnr7m6a74gwNHkXImHrMdqqcRFNiWwMx1g+LL3E++SPCTrKuAjM1F4olu5CHzo93UvX3Wdp8JcWKUfFt2DO9UstktkBF0eP+m5ztEx0M3bYd
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Nov 2026 16:25:19.2118
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c1fe01bd-8512-4efa-6e98-08df39c70d3c
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MW1PEPF00018894.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB6189
X-Stat-Signature: zs6aif45es1usne65wkpjmfjru4c1eei
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 64B4E140005
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-HE-Tag: 1793723126-960194
X-HE-Meta: U2FsdGVkX18cBPIUzqZUDEbrJfNvZLIfEy/AEX/wN4WWkrXVWY3VVWoNIFevgye7DHzbH4Z8Zxw0ketwEDzFPpK1sFH7lZRiAK0LcZA6DS8dEAgGT9hbYlfq9H9K8R3BqWa4WboCjkvpte6PJY0iuhcY3BTPV3T8qV2ddtz0UWdJbPqZ5MFn77Y7bQYgPTiWrP4HXArYbhANIXp2YukRdD0kmTqTLJPvG1UJS1/1xuCJzw+hR9O8jc4raBsxvM0lNbOOHC2o/AVAMj7TAv0XjCzBTXjMhk5QHIgHIjzWOfGVdlBvKk1ou2HvK0VO3jd87eVLD9JuzvqIjx/GtFwptBDJkTBzjdO++YLtV6vhkuol78IyEGQnHRHLFT2O6susrUyf+7Dtt8Wa1imw3mXcLSPcIdO7jhyowLOQhqesEPx4h29e9ecqSoDS5HUKnPOLRr1zpl2XstuXqWQvbYbVtHDCTqzdkhWJ3+O1BgGiotFtJnvAEqmAE0HovtrsA5tpKY6WmOlRyaIBepod/Ylg/SFbjEzTl9GdgVf9s2SZjZ4C/IStsWc/KnZhCu6qXIVyoH7Qkn4hhy0ZbTXJ+ukB9NFlsFBuHPfqrZyQi8ud+xeRMGCVHWSUOG3Mk94bdteI0JVJUcz+LUsVIw7oAdnXml6fF90YJYZgwllUJ3Fp5NdezpvGqHhoxqudhj6SQt5s3J9OZlbmtbI+prhItMtAn4gZBGpjDLVF6q9PuTo6hI18gLNP2xs8NsvRCWnX8KyWD+o51oKhF02q+isUbZKVdHH1dDJGsGoXO9q3QlLxCrc16ZaNcsK5jZGBoKvsgsddqN4zAqMHI8Kl1cai7+pNs2t9T/ca2JYw6NY/SKhvBT7jht1CGQA6eMfYDLr+ulj3+lUrrV5Mn8ZyjRGUhXqDp1wi5gfwuvA7FkQuKbt25/1mOmrkEDc3ylt/UQ1xhzRKMkOAYcRq2lwq2zyH50c
 P1mj0/rG
 BcdgNAlcPs0SrFKJG0R1GUAGqj/MT6cRuqzeQ/OWaKOpDsK7M/gEvfDKEGP2K3SQA0lAigXbDEV+bfkcWX6QdeonVl4yIWcALKeEwMnMvY8u05uytCw3E7Urj6WRHGZAvyCyWQCN5c4nbcYPKF0DKchzITbmQlWiXDRIPSyLleR6V3JrLoX5NGjkks34K9AM6LelRpsot0LyAQH9Px7AvRY0/eHqakyzLfLbphKfT+LJm8OWGtV0cxwXZ21QujG1klQnpVdQ8HQqNwThR8lpd/ejqv1S3ClSIlJyKX8mC/jCFNi/fvFGAnM0X45X2CkTrOYhQHDATnwH4+gzx6IG6mCbfO0mM/bCLIbSPt34bdwtYuGV4t27vZeDYUxQ2a5MMhJb5xDM09rbrjNuMGFyv6KJs1Zs9Ns4xsRyvHMoG/dCEV5o=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

cma_init_reserved_mem() already refuses a base or size that is not aligned
to CMA_MIN_ALIGNMENT_BYTES, so the identical test in rmem_cma_setup() only
repeats it one call earlier. Remove it and report the failure from
cma_init_reserved_mem() instead, where the area name is available: the
message now says which pool is misaligned, and every caller gets the
diagnostic rather than just the device-tree path.

Suggested-by: Mike Rapoport <rppt@kernel.org>
Signed-off-by: Radhey Shyam Pandey <radhey.shyam.pandey@amd.com>
---
Changes since RFC:
- New patch
---
 kernel/dma/contiguous.c | 5 -----
 mm/cma.c                | 6 +++++-
 2 files changed, 5 insertions(+), 6 deletions(-)

diff --git a/kernel/dma/contiguous.c b/kernel/dma/contiguous.c
index 90937dc7c627..14450cf0f832 100644
--- a/kernel/dma/contiguous.c
+++ b/kernel/dma/contiguous.c
@@ -552,11 +552,6 @@ static int __init rmem_cma_setup(unsigned long node, struct reserved_mem *rmem)
 	if (ret)
 		return ret;
 
-	if (!IS_ALIGNED(rmem->base | rmem->size, CMA_MIN_ALIGNMENT_BYTES)) {
-		pr_err("Reserved memory: incorrect alignment of CMA region\n");
-		return -EINVAL;
-	}
-
 	ret = cma_init_reserved_mem(rmem->base, rmem->size, 0, rmem->name, &cma);
 	if (ret) {
 		pr_err("Reserved memory: unable to setup CMA region\n");
diff --git a/mm/cma.c b/mm/cma.c
index 3231a53161cd..68dea7070d69 100644
--- a/mm/cma.c
+++ b/mm/cma.c
@@ -326,8 +326,12 @@ int __init cma_init_reserved_mem(phys_addr_t base, phys_addr_t size,
 	}
 
 	/* ensure minimal alignment required by mm core */
-	if (!IS_ALIGNED(base | size, CMA_MIN_ALIGNMENT_BYTES))
+	if (!IS_ALIGNED(base | size, CMA_MIN_ALIGNMENT_BYTES)) {
+		pr_err("area %s (%pa, size %pa) is not aligned to %lu bytes\n",
+		       name ?: "(unnamed)", &base, &size,
+		       (unsigned long)CMA_MIN_ALIGNMENT_BYTES);
 		return -EINVAL;
+	}
 
 	ret = cma_new_area(name, size, order_per_bit, &cma);
 	if (ret != 0)
-- 
2.44.4


