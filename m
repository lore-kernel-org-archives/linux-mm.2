Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9F71ECD3423
	for <linux-mm@archiver.kernel.org>; Mon,  4 May 2026 06:40:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D53296B0088; Mon,  4 May 2026 02:40:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D03BF6B008A; Mon,  4 May 2026 02:40:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BF2AF6B008C; Mon,  4 May 2026 02:40:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id AE8346B0088
	for <linux-mm@kvack.org>; Mon,  4 May 2026 02:40:09 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 48CB9A09AD
	for <linux-mm@kvack.org>; Mon,  4 May 2026 06:40:09 +0000 (UTC)
X-FDA: 84728787738.10.AB833E7
Received: from CY7PR03CU001.outbound.protection.outlook.com (mail-westcentralusazon11010065.outbound.protection.outlook.com [40.93.198.65])
	by imf01.hostedemail.com (Postfix) with ESMTP id 1633A40006
	for <linux-mm@kvack.org>; Mon,  4 May 2026 06:40:05 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=T8ipwE01;
	spf=pass (imf01.hostedemail.com: domain of Hrushikesh.Salunke@amd.com designates 40.93.198.65 as permitted sender) smtp.mailfrom=Hrushikesh.Salunke@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777876806;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=jH+FSza+ewuGHPxqdh0LXkSie5KRkDFmP2qYoR29xbM=;
	b=vN7LEsgNW/UJoNEyiJYwf9IX8tQlpnW59UJ/ObGpSOXlKmZaKAPXZJytGpJwGSLOkHTipI
	8f0PXoX2uEP8U0bbPxqGtz6flxi7GqeNw65F71vG1v5kEG+whrN6YBdI0s+awEToR5MuBv
	I2G5H8qRqcQNsQGN7eA5PjG3VpYVEEc=
ARC-Authentication-Results: i=2;
	imf01.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=T8ipwE01;
	spf=pass (imf01.hostedemail.com: domain of Hrushikesh.Salunke@amd.com designates 40.93.198.65 as permitted sender) smtp.mailfrom=Hrushikesh.Salunke@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1777876806; a=rsa-sha256;
	cv=pass;
	b=qlg19LdKPe3f5AsP6ib6hjlApWH1th+exewFmk8X4cOHYdqA3QKc0l5n/AF/ALmCTWpgx5
	gyHi9oeH8DLMgDxQFriCQV11RzNNqk3xDlyfmISH7EsubYmkcV1U6lTVYLxGVzJ/EBTY9L
	zEwoVPcIUooK+ICkWasVJ2kt+ei+ZlQ=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=xJTGnYvacfL2ZE+IxDyxhgRKqGfJkFHWADjt1fKEJTBVTcYKti6WMOQYkM6uuVVMQZ12WrUr922i2OUa50UUaUnESwfllX1PwQag8m0/1u74yenkjGrM9Wkj/mxbtDJl716Icx4/w/diTHK8Li8o8ePgVpAJQ4+qU7tgN2nCvM36YKvh2qFZAezxzujKqCsO5LAKww9t5/MKdrbdHpmD3Y1ZvCbEn190iwcYmJmJ3B6Vv7qMJigyD6eAaCzISgpS6QRz2QJtd27OF9B03guMyshQQo+JCzAPH20DWVvbyWg5qQeF0DyQSo5U2O4UP6dbMVZCFzAqn7FrdIFILnBrwg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jH+FSza+ewuGHPxqdh0LXkSie5KRkDFmP2qYoR29xbM=;
 b=kT7+eirOfClNHnAg8eqIPR1dzZULMvTt6sHw1QUDZI/SNudLTMWnfHrYZgFfl4KK5fK4btEoW7vykZUMQdlOemrpV7ZV6aDAJeXWB03b9C80nV+ei7BroruGNEuegeopjY1+UAYY4IePWqBsncyvmbOLtfXemPRg4X4W1qlrAo+SEyPBE2qyGSs231+l62iL/UkYo5DZMHdS9vXlQ6lG+SuUMCq9maoArFhk3F15dSdYMDoXpb452EBogjgnb1nD4oh5/zLVXliCRtP8ZTuk2ou46w5H/aAD9TnRcNM2lt2seLbhF/Tsu3MHeG0sakS9D9w8wvv+FvF8xtU8X2R+cA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=linux-foundation.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jH+FSza+ewuGHPxqdh0LXkSie5KRkDFmP2qYoR29xbM=;
 b=T8ipwE01hE+8VeLOin3GPRaEjlhCwj4gfZ90qNhJJBfS2XWAgbFQE+4jj8ocPo2C+eUwReYF9ZJ3ymt6jqGme4/cS9pZZOvgaTXTzYVkmfHPJWGGRk+F+Fpd+kdCFRCdqy+/6MRbzSP3wOLKdAodCkid55uVIHsrwyXTSXJWr4U=
Received: from CH2PR08CA0027.namprd08.prod.outlook.com (2603:10b6:610:5a::37)
 by LV8PR12MB9668.namprd12.prod.outlook.com (2603:10b6:408:295::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9870.25; Mon, 4 May
 2026 06:40:00 +0000
Received: from CH2PEPF0000009E.namprd02.prod.outlook.com
 (2603:10b6:610:5a:cafe::46) by CH2PR08CA0027.outlook.office365.com
 (2603:10b6:610:5a::37) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9723.25 via Frontend Transport; Mon,
 4 May 2026 06:40:00 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 CH2PEPF0000009E.mail.protection.outlook.com (10.167.244.27) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9891.9 via Frontend Transport; Mon, 4 May 2026 06:39:59 +0000
Received: from kenya-2193host.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Mon, 4 May
 2026 01:39:55 -0500
From: Hrushikesh Salunke <hsalunke@amd.com>
To: <akpm@linux-foundation.org>, <david@kernel.org>, <ljs@kernel.org>,
	<Liam.Howlett@oracle.com>, <vbabka@kernel.org>, <rppt@kernel.org>,
	<surenb@google.com>, <mhocko@suse.com>, <jackmanb@google.com>,
	<hannes@cmpxchg.org>, <ziy@nvidia.com>
CC: <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>, <rkodsara@amd.com>,
	<bharata@amd.com>, <ankur.a.arora@oracle.com>, <shivankg@amd.com>,
	<hsalunke@amd.com>
Subject: [PATCH v4] mm/page_alloc: replace kernel_init_pages() with batch page clearing
Date: Mon, 4 May 2026 06:39:19 +0000
Message-ID: <20260504063942.553438-1-hsalunke@amd.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: satlexmb08.amd.com (10.181.42.217) To satlexmb07.amd.com
 (10.181.42.216)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH2PEPF0000009E:EE_|LV8PR12MB9668:EE_
X-MS-Office365-Filtering-Correlation-Id: fa908fbf-ef49-4359-72ec-08dea9a7f6e3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|1800799024|7416014|376014|36860700016|13003099007|921020|18002099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	dCg0N9VEooz9L0WYXP1jvm+fPgnSWoTQGgTJo8i8RjDaLoaxZjEAVCr8ZiPN4ZB1b50wkPFMAoKT6nvdBou/UBnKx5WWXop2dnkLM9yRlbIaqU/LILuWVaQJ5M6Di/qVwp+E2MCATTpmds4TmVF+Exp84FBWQI6TokAQIVD+l7wrhSnM5KIUsoFYe/OSufs8RuQBcsNVZVHh3mIXumaD9A5830vcoqHOA04DrZPxA/Li7PYDWO13WMVUi2FCvzbdCCLrydcP4ioDbvnp9QGI01jkgU25RRrsB85SHt9rWgY+KMkXTRPIajAqlSGLw+zgNSvDsB6P/seEXMLNSXtGgth9/fug3uBp6DFN7yJVOawXDSE5APuqqXKrdQ/scZw8NoimQoAcJ8830eavN7EPY3DPwJSYI2l2eC13kKvixNFO5e1qD0vtSBsAeGNK5Zj1nT+xyAefVNeum+O7bM9UD8t2XQr5Fzik7IxepWWUWq+K95RigGPGizW9V8QFTtgNJmLj7XMYxD9k5qWpjpugzjdR7cKFqgSukRO8VG/p3o24C2wCi6/u4bt2srqQehUvdcldexY42ZUFsI+odWyB21ieassaExbKhD3bWc2vmBfjtQZqwrQ/dKojmG64229TKilcRRHMMopS40EhxS8LY7bARjJZc21NkwZ96U8ZCMDfmLdgNYrSjdNBnO0mxRlfynbbA52weMlMzootkBRqOO4+k4vwJeYtE4HcWRHkGC/qZyOOQ/YttZjGLUcdxQRbkphtNP9VfCSMcTYDxk9aH5BpHLF8R0cxV7UfVhsYLaY=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(1800799024)(7416014)(376014)(36860700016)(13003099007)(921020)(18002099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	sOCXRvZ7Pvf9HAeLWSf6YPyaW50RDF3iN8uSBTLoYAwXxyvNfug+COOH/Aq/eVMpjXlafV5JpYZfD+sw6HitwHn4zDN9IlFLZd2UZl/YQBAA0xCjQXp9pwtdGMVBdtUr7tbARRQ1PGCa22I4WEAVMpYrVnUUuJMXxvYcM7oMmT3y8qPGpqZngXS1F1BRJXAQhPEcM95qWrwTTDWCadYLLZGuFP7rJ+GMJczSP7MES+4nVg5viWNU1Vo436eZ0cR99S9NHZ1uxQFBx+nzjvHV9CUoutUOmFgHOwkaBT6rQVNBwiky/upulb5jsb5httfhqDdf5OFrYLusuJnPi730ADMxdyeFh17rXwQvjrymCOeXJ/LRJwj0ztxbOFbrjOEDC6ar8lTqwLwR5eU7PflxyOrZeV6plBOcZc80hdya8jQ0hiTIXovKUcKESElq7vEM
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 May 2026 06:39:59.9358
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: fa908fbf-ef49-4359-72ec-08dea9a7f6e3
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH2PEPF0000009E.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV8PR12MB9668
X-Stat-Signature: sc9st1d4m1iwbzbwugbn85uo84bijujt
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 1633A40006
X-Rspam-User: 
X-HE-Tag: 1777876805-837063
X-HE-Meta: U2FsdGVkX1+I/5SGgIWWDfxHt/bSnAfN3JEFe9tr8Iqcxbbmwc2v6OnLGi4zUO2AVFEU7OGbled2yJCMyAuyPMeH0fsMIaYDhrbModhdTX5vivXFoEyErxGcZqDwo33D5LZJ48iAQ06PFEXUcHM5A5ZwOxq3whmHFhPPi/275ytt9DaBcpQAwusvJ0ELB5ww8UnCET0mf/D8rd83cDkDRx+z63swG+48RgUOZdMa42omoX0XZrz1qGdS8iEsjhWNevNujCBBx5Gs+g6YhJ+dKtJSQ/Zwe6DmY6yuygYGCTdqaoN0WWXa0KJ+BXyRGZpe0e9c0wGKGIZ57aqaMIRMIKsug4Ja6b4YHqISHeHjJ+PAuAnms4VgHjpat8enjV27rNqyuYl3XzgQedyfMOXPouDMaPFlJd/qvVUWNkSUsiF8JrFDTcH5JM164+blkRun4HiajKOWb//iMKQxlk10JutN3UakxMg8bkJ6vbluKAO1Hrxy2zkLPr/04YeCNBoDIyC9SJC0KRSPmxvoIEri7EoXJD7xdhvy/rVxWZqWW3NRbp4DxrILXhUQNliOHWufWqo0faLy/uvdQbBlq+62ZCOdWmcrh+6hk58WiPaqHR+LdXgn0XU9QHWJzmC+T5FFF6+6R3MSuIFTkq4t5TAsqChpO+eyfMKQylDAD9aIvpQgrJdRHMz38hWIUJX18veT2wJTwQ6LlmGkNz4lE4BqlcLbDH4gOsW8W/9pZ4/w/WyAfvnzfmDuc3L2AsdrSYGw4OwnEdIfEG0paTlUqmFEoJ1HH20apuOiHBZxM8EOigOUe19QjyRn+/TVTxx70VSelfXuuF0MuWcYhJoqynOVfFa/ytYaTcTELIHrguN2XEdh3aRx5oBTwMIyzFB2/WtvQ1ziog+dJwgkuhPs1dDD0ai8u8PYA03jHV7zfWKhD6I6eesKFBAwA6PKl683R74WD4M8R8AmrKm11YptEVe
 a+p3fcmf
 4rK3cPyTLQbqlRbG/5AUORL1CejJGMYjn+uPdkMGkg6ycmYszka1+XpwM1GJC48Kia7bG5NlkR7laOzrinu3jbXEygzYBSg3zQcqPlRKYx4gV7KWdaaFOY2tH84W+t1hyFsm6rMuOwzC6GA8UA5Q1phinTAXUQa1ZtSExefNUii/GXM/Zy/flptFCVPtIaYHaHTyeZ6aBexk5N+Jfq5rFWsgfaVUzEOZW7wmQzHTHDnisBKnp+D6QcpzvE3DKBhNaJujfig1yuOEii6hNx23EI1/F+x6dBoBKlYBZ0VLHeqT5Y4H6aMkZ88o/I5CGxVPkkLRMwkeyPZBn6NrIaVvYSLqnkZmMt7yiLCIlhmzv/oPVmeAkaUyDnBXPLY5Z5vHLAn45ouSCJ37hUMTKRdPrLliiD7YvKEFkSJMrPbnuPJ2Z37oZpw+iqi8DsBSChRkN4RMxYA5DBTG+uhGtfYf1bxs9s04a+0c1eJimRwo+Y51HhGUV+Mtw6/umVJ87Py0wJu3/oX519SeTFCQ2YrlIoIQjqDV82wapHAluDkSv0TDWNokgJkyJv16GcySEeiw8lO6UkOH8/V51cikT5CO40g0T8EkBs8m790+gAXqTPWrrU1ldt4KOS5KMVK4YCvuFLSYub8KYlZkpWr7nAp2Q72xnDchAWogpjpi5LCCQIf1Jb6Q+BE/nKuJ17w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When init_on_alloc is enabled, kernel_init_pages() clears every page
one at a time via clear_highpage_kasan_tagged(), which incurs per-page
kmap_local_page()/kunmap_local() overhead and prevents the architecture
clearing primitive from operating on contiguous ranges.

Introduce clear_highpages_kasan_tagged() as a static batch clearing
helper in page_alloc.c that calls clear_pages() for the full contiguous
range on !HIGHMEM systems, bypassing the per-page kmap overhead and
allowing a single invocation of the arch clearing primitive across the
entire allocation. The HIGHMEM path falls back to per-page clearing
since those pages require kmap.

Replace kernel_init_pages() with direct calls to the new helper, as it
becomes a trivial wrapper.

Allocating 8192 x 2MB HugeTLB pages (16GB) with init_on_alloc=1:

  Before: 0.445s
  After:  0.166s  (-62.7%, 2.68x faster)

Kernel time (sys) reduction per workload with init_on_alloc=1:

  Workload            Before       After       Change
  Graph500 64C128T    30m 41.8s    15m 14.8s   -50.3%
  Graph500 16C32T     15m 56.7s     9m 43.7s   -39.0%
  Pagerank 32T         1m 58.5s     1m 12.8s   -38.5%
  Pagerank 128T        2m 36.3s     1m 40.4s   -35.7%

Signed-off-by: Hrushikesh Salunke <hsalunke@amd.com>
Acked-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Acked-by: Zi Yan <ziy@nvidia.com>
Acked-by: Pankaj Gupta <pankaj.gupta@amd.com>
---
Hi Andrew,

This is v4 of the batch page clearing patch. v3 is already in
mm-unstable, please replace it with this one.
The only change is moving clear_highpages_kasan_tagged() from
include/linux/highmem.h to mm/page_alloc.c as a static function,
addressing the code size concern you raised on ARM allmodconfig.

Thanks,
Hrushikesh

base commit: 2bcc13c29c711381d815c1ba5d5b25737400c71a

v3: https://lore.kernel.org/all/20260422102729.166599-1-hsalunke@amd.com/
v2: https://lore.kernel.org/all/20260421042451.76918-1-hsalunke@amd.com/
v1: https://lore.kernel.org/all/20260408092441.435133-1-hsalunke@amd.com/

Changes since v3:
- Moved clear_highpages_kasan_tagged() from include/linux/highmem.h to
  mm/page_alloc.c as a static function to avoid code size increase. As
  the function is only used within page_alloc.c.

Changes since v2:
- Moved kasan_disable_current()/kasan_enable_current() into
  clear_highpages_kasan_tagged(), per David and Zi Yan's suggestion.
- Removed kernel_init_pages() and replaced its two call sites with
  direct calls to the helper.

Changes since v1:
- Dropped cond_resched() and PROCESS_PAGES_NON_PREEMPT_BATCH as
  kernel_init_pages() runs inside the page allocator and can be
  called from atomic context, making cond_resched() unsafe. The
  original code never had a cond_resched() here, and the
  performance gain comes from batching, not rescheduling.

- Moved the !HIGHMEM/HIGHMEM branching into a new
  clear_highpages_kasan_tagged() helper in highmem.h, per David's
  suggestion.

 mm/page_alloc.c | 18 +++++++++++-------
 1 file changed, 11 insertions(+), 7 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 65e205111553..3a59577f58a5 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -1208,14 +1208,18 @@ static inline bool should_skip_kasan_poison(struct page *page)
 	return page_kasan_tag(page) == KASAN_TAG_KERNEL;
 }
 
-static void kernel_init_pages(struct page *page, int numpages)
+static void clear_highpages_kasan_tagged(struct page *page, int numpages)
 {
-	int i;
-
 	/* s390's use of memset() could override KASAN redzones. */
 	kasan_disable_current();
-	for (i = 0; i < numpages; i++)
-		clear_highpage_kasan_tagged(page + i);
+	if (!IS_ENABLED(CONFIG_HIGHMEM)) {
+		clear_pages(kasan_reset_tag(page_address(page)), numpages);
+	} else {
+		int i;
+
+		for (i = 0; i < numpages; i++)
+			clear_highpage_kasan_tagged(page + i);
+	}
 	kasan_enable_current();
 }
 
@@ -1428,7 +1432,7 @@ __always_inline bool __free_pages_prepare(struct page *page,
 			init = false;
 	}
 	if (init)
-		kernel_init_pages(page, 1 << order);
+		clear_highpages_kasan_tagged(page, 1 << order);
 
 	/*
 	 * arch_free_page() can make the page's contents inaccessible.  s390
@@ -1853,7 +1857,7 @@ inline void post_alloc_hook(struct page *page, unsigned int order,
 	}
 	/* If memory is still not initialized, initialize it now. */
 	if (init)
-		kernel_init_pages(page, 1 << order);
+		clear_highpages_kasan_tagged(page, 1 << order);
 
 	set_page_owner(page, order, gfp_flags);
 	page_table_check_alloc(page, order);
-- 
2.43.0


