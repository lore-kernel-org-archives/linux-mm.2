Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C1C2F606A32F
	for <linux-mm@archiver.kernel.org>; Tue,  3 Nov 2026 16:26:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=amd.com header.i=@amd.com header.a=rsa-sha256 header.s=selector1 header.b=FcKrv1we
Received: by kanga.kvack.org (Postfix)
	id DC7CD6B05D2; Tue,  3 Nov 2026 11:26:18 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D9F1B6B05D3; Tue,  3 Nov 2026 11:26:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C8F256B05D4; Tue,  3 Nov 2026 11:26:18 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A87106B05D2
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 11:26:18 -0500 (EST)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 35EF8A7C5E
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 16:26:18 +0000 (UTC)
X-FDA: 85394335236.27.EC23A05
Received: from CH5PR02CU005.outbound.protection.outlook.com (mail-northcentralusazon11012066.outbound.protection.outlook.com [40.107.200.66])
	by imf27.hostedemail.com (Postfix) with ESMTP id 3BD864000A
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 16:26:15 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=FcKrv1we;
	spf=pass (imf27.hostedemail.com: domain of radhey.shyam.pandey@amd.com designates 40.107.200.66 as permitted sender) smtp.mailfrom=radhey.shyam.pandey@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793723175;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Pjvtisfj0ShIvEUhY1wqdXjIdnKALWvBB/aKcW/zekM=;
	b=CQl/6YUUyF1+qV9UObxJkH/3KneVIsNX/ADa6Sow6GJ402slVqRBCFWECosQxHigDLluMO
	cC/6yTBxh45l1eQScBrhxAMBQMhOjGFkcr+NTQxNT6pWtdVZ1Fs0J/uYL+p51PXPoev9I0
	t6gfYan3KENOjFlQKaCGHY/2BTOCd1s=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1793723175;
	b=4MmhrwiFXt8EhkiG0jnkGJUN4d8p4jNVIL8gWKB6Ulzt86KOJN0BfwvcoiSDi9xgpEYKzt
	mmZpHPX6/36DpURmWQM+x2wGQVku7DYxtbf+LCJl79XTpOFLaQrsfle8DfaaAweYk60mtp
	BN1h2DKG/OV2FmJ/kvoibOQcc0kI4NA=
ARC-Authentication-Results: i=2;
	imf27.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=FcKrv1we;
	spf=pass (imf27.hostedemail.com: domain of radhey.shyam.pandey@amd.com designates 40.107.200.66 as permitted sender) smtp.mailfrom=radhey.shyam.pandey@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=tQCmZpO1w8C+ZgQB2ZiEJIk0ZtEcGOVPzPXn6U86KtZEI9kthOiFUH0Nw3ln4BO5D/zz2DAoGMe9IJviTs2s6SCLb8ye4/75WWs/zYesUGaDnM6dotvRkd/LB8NeCYyvrOKRzpn0VWJSEvbSBE0JW4NBOFEA6errGcarplwbxcxqhAMuZeZE+W4jF/2/nF3edkFuvZyW3reooMBEjK4fgsmJ6WJz+/8cyvGTadwxvqZXC+thhT18RV3p4W17X77yS3NCnJDR2GpJH3WM4macc5821iL1BbamZjvcXc98xSemRgSjcOntJo8Ck0Bc09rDwAtaOPWbgAnUk5QSUY4bnA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Pjvtisfj0ShIvEUhY1wqdXjIdnKALWvBB/aKcW/zekM=;
 b=kDrBI7eCg4iySzmFsUqEoakM4yE+AtS7Wo899pU2dUgf+wc9lAZR/eElF75UABltMNXjEyzKwUf1rFtcZSo0MA1NfupY4oeciG9PLmf1S9K9AlaXMJvuxVUbw5ULaYqMiIAIfxWlBHzOSmsykLlAlPe3ouXH8/eoN9cci6ismee0Uf3G72X75fNGI97tIKH3i9vxmA4SOkSagOxXnoOTE3fVUuXa43Bt79W0dLyOpM6jPqOJSLys0dUyZZ/0UlnorWzF6ypseKremxSVae69U5Tlgo8fwMf46hgOoGM7z7UlSaCuMx08mwv1U+v4FFQqIXEGDt7v1qvUPuoa2Mpy6A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Pjvtisfj0ShIvEUhY1wqdXjIdnKALWvBB/aKcW/zekM=;
 b=FcKrv1weFrU9sJBRNR6566wrUgQUQQXHe2btKi5ykrcnyOMh08jWS9wbhR3daBe/NvaTb1z/7X0JSHkpVkNbUuGuVru6ykkA5AHzuLJyXc2Wwu+mvc3Yif5klwuKYz0G1sgyG8V+azWVKE4TBD+t0/H4E+pow/Emhy8w0a8lSug=
Received: from SJ0PR03CA0003.namprd03.prod.outlook.com (2603:10b6:a03:33a::8)
 by DS7PR12MB6336.namprd12.prod.outlook.com (2603:10b6:8:93::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.592.8; Tue, 3 Nov 2026 16:25:09 +0000
Received: from MW1PEPF0001888E.namprd03.prod.outlook.com
 (2603:10b6:a03:33a:cafe::36) by SJ0PR03CA0003.outlook.office365.com
 (2603:10b6:a03:33a::8) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.569.12 via Frontend Transport; Tue, 3
 Nov 2026 16:25:09 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 165.204.84.17) smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 MW1PEPF0001888E.mail.protection.outlook.com (10.167.249.165) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.592.5 via Frontend Transport; Tue, 3 Nov 2026 16:25:08 +0000
Received: from satlexmb08.amd.com (10.181.42.217) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.53; Tue, 3 Nov
 2026 10:24:57 -0600
Received: from xhdradheys41.xilinx.com (10.180.168.240) by satlexmb08.amd.com
 (10.181.42.217) with Microsoft SMTP Server id 15.2.2562.53 via Frontend
 Transport; Tue, 3 Nov 2026 10:24:52 -0600
From: Radhey Shyam Pandey <radhey.shyam.pandey@amd.com>
To: <robh@kernel.org>, <saravanak@kernel.org>, <akpm@linux-foundation.org>,
	<david@kernel.org>, <ljs@kernel.org>, <liam@infradead.org>,
	<vbabka@kernel.org>, <rppt@kernel.org>, <surenb@google.com>,
	<mhocko@suse.com>, <m.szyprowski@samsung.com>, <robin.murphy@arm.com>,
	<baoquan.he@linux.dev>, <pasha.tatashin@soleen.com>, <pratyush@kernel.org>
CC: <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-mm@kvack.org>, <iommu@lists.linux.dev>, <kexec@lists.infradead.org>,
	Radhey Shyam Pandey <radhey.shyam.pandey@amd.com>
Subject: [PATCH 2/4] of: reserved_mem: keep the reservation when node_init returns -EBUSY
Date: Tue, 3 Nov 2026 21:54:27 +0530
Message-ID: <20261103162429.2053989-3-radhey.shyam.pandey@amd.com>
X-Mailer: git-send-email 2.44.4
In-Reply-To: <20261103162429.2053989-1-radhey.shyam.pandey@amd.com>
References: <20261103162429.2053989-1-radhey.shyam.pandey@amd.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MW1PEPF0001888E:EE_|DS7PR12MB6336:EE_
X-MS-Office365-Filtering-Correlation-Id: 1e1ee63c-3c51-45d5-0de9-08df39c70717
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|23010399003|1800799024|82310400026|36860700016|921020|11063799006|5023799004|56012099006|261009223027099003|261028144727099003|261022105027099003|261022075727099003|261022115727099003|261102123227099003|261021121427099003|261026140227099003|261026121527099003|10067099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	P9wd7HB4gYRUgbfcn7PlGa9tGGWjmu7k7sHcL6iaBoH3vU1jYT1tEkabULr3w+zmntT1hm368I7v8oIC7k6tvnI7YbdirRhy/S8sr9+Z3f8XUGAeznnEVvxajZaRSAaAUzCgkgP1ybjyegY0WC4KFKkpHZcBMyIFVAnCqUVcZZ9BBDREtFiesmEa/Im8QSFPVGegj0szTsgsGit1h4QxmgsOJ6xdyGWAq7HI+Q8tb+vEoxKSZBGg8TrSA7p0Q5toeq47U03BN9TL5B7SZtuG+udgDZz3yv+RNE67YpT9oh9MQVNKDKMJatyqIfMleXnjgh/YzAzdYRvdKbjc47Khj4HCRXjChP/l5a9DtC/xEWHW8gQuE6oeiAUpwTeNjxh8z9unzRwIQDTJ0NTB2OnnyahQzEZ3pFk74NwWj08SrmO+rQDUSv6N9/f5sVUQ2pT02DDF8gZsS6EcIwQRlT95IkZGsitHlhCL82XdjVLcQ9T+BKPsgPSWAQ1tISnQtFmcckO/+cqXxEXKsU4lobgnJpUbHnm+E5gsfxOOHrOnUAoWCyDNkCi8HoUkARXhnbNsXCsm3h5OmDbXImtaaB/meJ60DV7SX5gAWjZ6/fJtSkul0oMQ/uWtbAKjHyMp5BgOJ5se0kebrqJX/dD53U5w2RiIHaQ+hSpy7Vq2IIxCgGBrDcchWJydaGSy/UX3nNfEUkVLdH5OVjACHjLYiWfr1jBQwLZeb0XO6eXRWZeYCSeh3t9sbxRDfOa2ljl9NboA
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(7416014)(376014)(23010399003)(1800799024)(82310400026)(36860700016)(921020)(11063799006)(5023799004)(56012099006)(261009223027099003)(261028144727099003)(261022105027099003)(261022075727099003)(261022115727099003)(261102123227099003)(261021121427099003)(261026140227099003)(261026121527099003)(10067099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	epOc018vOFBmUnxxl2d/BTdrKnAy7mD01BGD4uZ8zb7VmxcOdmQ/Q9mxTSb/mKs7+qjAbZ7Wal+MTRP79qjtbiZcenSNbXVR71Z2jk84piNQWRumdx5ZMxdz5yZ7BNxNfAOnkB3XaWUuf9BvM0/ecIMAK4jL9R9zu8dzX5JhWDHQV/iXmRmXVKi6KCQpa4sudSb8cu/jmHz3Q7F641SelpGsvjowba1C/9UPrJALtCVBHdn+3hXJtaAOTVr3g1lgjPeiA34+4dDKWdu7DVEqps4qIePzAs3QNNhhvPAIpBJpjoI4obIMDENOsCC8ERDfM6KULaKylae/CvfE4aZorRs+EeYlhn2+OXhC1QibwBVxLs4SuF0oxlVYkq06z7a3TbsoxFEMqMYomvYRWr4JHXv5QPq+kSducKD0t1xQBcnzLzlaZdhcZe8FmCitDmUi
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Nov 2026 16:25:08.9295
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 1e1ee63c-3c51-45d5-0de9-08df39c70717
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MW1PEPF0001888E.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB6336
X-Rspamd-Server: rspam06
X-Stat-Signature: emhh95qyyweye6ezw3hmftmmmi6y4ajw
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Rspamd-Queue-Id: 3BD864000A
X-Rspam-User: 
X-HE-Tag: 1793723175-883745
X-HE-Meta: U2FsdGVkX19k/QSVdt5kQWuG2YlhMGV4drNUUziwzfGonTWFRuuh2teYOQ2NmVJYt4ekD93ssgJbDgDi5pAypNX76DRwfJAYomCdJhBFR7hy2+SbDr7/WeDqRPSOkCLVDYJWt82Qe15MyMFLDSdG+dfZPUHqD2UZ5ca7WhHGsJnAeKIs3I2IIR32euMb0X4qdBEm3mB+zJvKMkSvXhNKFXgsvLU6VnTSQAZMOGg7W6a0jSRkTB3ITjVWJ10LS7gZ0Q/Lm9XEY4PsKHIyAc6h1T+DbrPNN1BBVcc5WtsretPq6smi/r8NynzQ5HHmEVOm7JKC1h+zfdOgdH9xSKobS5W1fze5oiqIEerfDVe5pmj/RtbU/pHAA7Sf+goHF0sstjf8U3mG9Ydp94f5CcezNyaQtEg2JHsbLAXcO8TirlfpiwAoGPQQ9Cs1rYpRWsHRu7vfgwuagbZduJ/2/AOEsjL2fg432k0CStJ6AFUgqvBvW1TbCbbIt8ZzgGzFwtaba2DavlYdv9k2z77UXO44cUWdOInUb4ZkGfGP2vPSQlVCVxbAh23ZEMpYbxMjf+HAJzKr6dsByswp4OGxbeFEzhmUB71C2rNd+TfowJN6cLUIynQnnTchFysZIxNt78CNwT0/viH4RE5jp+OWURyMqpWwcQqW2UTz/B/CJ+NxZ8ipCCHjOIUdvNB0HSbXCqWuizYITIPi8gl1uiCkNUkVnSL6KVzrtEJWLXe7nXo86j0ncIW0d1UQp2a+GXfeNZyoqNVE607GCfN8EeSxIJHGxxOjAwl8RT5EHpJGxYTF5gs13kL9D8hQ54Wzsu3OxnRgsj4uy7B/g/Soh7OyGGxTGplADQi11baRXWU620C9JSwTsEuUg2WX/10rpyAOoluSBLhptk4Wp5f1fISuvhfZiGtdWRwwokInuKEiGd0JZ43XH1QwJS1orRJNp0ygq0JMUwStUmpmK0bv3lTGgKV
 DKE6LZvP
 BnODgWnlE7F4n567dFhYsYvo514RPj8jsdL1JeB7NnCBg+IWZKpzjk6UbgdiUpZ/hU/Ity+f/RZhoLGKoRgekxunjgQ9RGBJDAAvukA9IH8NH3CXZGNAZjix8mJl1Zes8/hKS/a0Uec4wM0QBAx9iWXX1E71DGG2T8nunT/OnhZ9sJEpAQawwoqKe2b0ldIZfRlbk4S/n4BJx0UwyHpttdIs8M4X9uXRFKUSi3lJ7KkPcBqoOyRP2gZcB0Xxhnn3KMvfSi27At2BXZ9R9jo8wljQ5ZFkQ/AJb8Lh0ttcYGTGSuIqb65E+py6xHyfaSIJ58h2US21tH65J0LwnMq8M5Hb5H1jbYy+cgPonGWQ4NhLWcfXp43A/AmyFccpoDC73630NIe8jhCfkhD1gQcGHautKbyyVOXRJiC8zg4RdcSzqKJM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

fdt_init_reserved_mem_node() treats any error from a region's init function
as "this node is unusable" and calls memblock_phys_free() on the whole
range, although the range was reserved earlier during the FDT scan by code
unrelated to that init function. Give -EBUSY the meaning "cannot be used as
described, but must stay reserved" and skip the release for it. Nothing
returns -EBUSY from node_init today. The next patch does, to refuse a CMA
pool overlapping the kernel image, which without this would free
[_text, _end) rather than protect it.

Suggested-by: Pratyush Yadav (Google) <pratyush@kernel.org>
Signed-off-by: Radhey Shyam Pandey <radhey.shyam.pandey@amd.com>
---
Changes since RFC:
- New patch
---
 drivers/of/of_reserved_mem.c    | 14 ++++++++++++++
 include/linux/of_reserved_mem.h |  5 +++++
 2 files changed, 19 insertions(+)

diff --git a/drivers/of/of_reserved_mem.c b/drivers/of/of_reserved_mem.c
index 0fd1683cba01..d67a2b3a4d44 100644
--- a/drivers/of/of_reserved_mem.c
+++ b/drivers/of/of_reserved_mem.c
@@ -621,6 +621,20 @@ static void __init fdt_init_reserved_mem_node(unsigned long node, const char *un
 
 	err = __reserved_mem_init_node(rmem, node);
 	if (err != 0 && err != -ENODEV) {
+		/*
+		 * The region was reserved before its init function ran, so it
+		 * is not ours to release. -EBUSY says the init function is
+		 * declining it for a reason that outlives this node; freeing
+		 * it would hand the range to the page allocator even though
+		 * something else still owns it.
+		 */
+		if (err == -EBUSY) {
+			pr_info("node %s init failed, keeping reservation\n",
+				rmem->name);
+			rmem->name = NULL;
+			return;
+		}
+
 		pr_info("node %s compatible matching fail\n", rmem->name);
 		rmem->name = NULL;
 
diff --git a/include/linux/of_reserved_mem.h b/include/linux/of_reserved_mem.h
index 49da515859f2..4bf32f80785c 100644
--- a/include/linux/of_reserved_mem.h
+++ b/include/linux/of_reserved_mem.h
@@ -21,6 +21,11 @@ struct reserved_mem_ops {
 	int	(*node_validate)(unsigned long fdt_node, phys_addr_t *align);
 	int	(*node_fixup)(unsigned long fdt_node, phys_addr_t base,
 			      phys_addr_t size);
+	/*
+	 * Returns 0 on success, -ENODEV if the node is not handled by these
+	 * ops, or -EBUSY if the region cannot be used but must stay reserved.
+	 * Any other error releases the region.
+	 */
 	int	(*node_init)(unsigned long fdt_node, struct reserved_mem *rmem);
 	int	(*device_init)(struct reserved_mem *rmem,
 			       struct device *dev);
-- 
2.44.4


