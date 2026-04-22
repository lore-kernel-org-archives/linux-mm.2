Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2A6F2F9B60B
	for <linux-mm@archiver.kernel.org>; Wed, 22 Apr 2026 10:28:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 684AC6B009F; Wed, 22 Apr 2026 06:28:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 65C5D6B00A3; Wed, 22 Apr 2026 06:28:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5723D6B00A4; Wed, 22 Apr 2026 06:28:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 453266B00A3
	for <linux-mm@kvack.org>; Wed, 22 Apr 2026 06:28:42 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id D00DACA018
	for <linux-mm@kvack.org>; Wed, 22 Apr 2026 10:28:41 +0000 (UTC)
X-FDA: 84685818042.24.7763846
Received: from SJ2PR03CU001.outbound.protection.outlook.com (mail-westusazon11012008.outbound.protection.outlook.com [52.101.43.8])
	by imf30.hostedemail.com (Postfix) with ESMTP id C695E8000C
	for <linux-mm@kvack.org>; Wed, 22 Apr 2026 10:28:38 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=R94DCCTY;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf30.hostedemail.com: domain of Hrushikesh.Salunke@amd.com designates 52.101.43.8 as permitted sender) smtp.mailfrom=Hrushikesh.Salunke@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776853719;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=I8kVcZBUmmhNj1enoE2dDwI+jR2Ywq/12lCmvMaFYJs=;
	b=fMP3KrhrEYH15b0y3gc7oV3fz7F9b9V9lO3bLJ7wIUZAxGl7wnFCK/2aBuL5osgwrSjnzS
	ltyqzaHEtLunfDhm/qXyhpdxRa6tCojmDnSkPnmJBqa+IooiXMOp/ArdCYIPCz/kONyAtT
	SwXq1XNpmId3XYDGtIXcuLU8Wu9FIi8=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1776853719; a=rsa-sha256;
	cv=pass;
	b=e5+j2XdIf6cw6qHRQPg2KT+3hlC4ZcRXXkHf6QuJHwZ/z4rBtUgvzB3E2y+s4VlumDBBBv
	lIKZiXV9nHW0iJEXH3CK0HecNM1sM4hzPURLr/5N4uKGICtwjH0v3qEvTNYncSb03upIad
	fNGJbeLJowws7osBBn12eQ7Ti+XMRWE=
ARC-Authentication-Results: i=2;
	imf30.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=R94DCCTY;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf30.hostedemail.com: domain of Hrushikesh.Salunke@amd.com designates 52.101.43.8 as permitted sender) smtp.mailfrom=Hrushikesh.Salunke@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=LlgHjLPQ+sWXGlGLys80FitOmirgXBCcehtRA92v9v2dJDkuEx7QDCv2wfNN6eZc8p+XGS/3Z+bGBhI8tHIkBiOwUm0/I/snRFl9XJMRO3iG0EwEy4qfuj/H+gxoI2F2lc+gNgLGAopKMlFM512OD699XkspTFWTzvqrjLl8XAQ8CQn8vuGm3HWSd7aWzdGRjVfa3DQHaDoJwNd+aC/k6jkKNZ5qsjs+DUmXFBHh+PsJuNq7qzr9PxfU+Y1R7uzdgNwtZlLGmfIoQAmh20I5grnZqsyjCVXrgo/IARbtsS6qMA0yzNSvZ4cURm3AGcVjrgezsY6UcuCsXfY0TzjMyQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=I8kVcZBUmmhNj1enoE2dDwI+jR2Ywq/12lCmvMaFYJs=;
 b=HOPOnnS0oYcDHlfgwnoQZ476adocHPXPzAVLeuLnt8ZKzk9kJ8ADajhD6ifpDRCHzq1jj3FXHNQCa4Jxr9J40HKM7nG8EhUQX7evjVnaoXkVJkAKpcGXLRqSmPohyVtcygUnQoewgRiBKo78XzpIIC54O6k5GHl6O2Zx9nr5pXLFFRzazdluQ8W0VutLJRuVBV6XJHr3jkxiNgYlNoJH5OG6KziRvNhDHFRiVTAsXAdmXzjGSOaT6wClsg+dBrR3sy8A1m7GSrDkrBxpRxhcA/5HEt5zop7zTVFrdjd0m8IpOQLRFHO5PSYpAEUoT7CSPCjyAJ4v1oEcorn2mj5X2g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=linux-foundation.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=I8kVcZBUmmhNj1enoE2dDwI+jR2Ywq/12lCmvMaFYJs=;
 b=R94DCCTYWQSLPXI1JfghZP9IqXPXoe0g57ftR11NzvaB7X3KcN+TVNs+K17RVjSAJg7HuxY9FHDHDcEbfeiyGuoxmLdjUJMjaM+K4p3OQGEIwxnHwYb0roYX8pL3hAJR/O3IkCv2O0LZBG+8u8lnhguTaZIdrToSeOylGzTW5YY=
Received: from IA1P220CA0001.NAMP220.PROD.OUTLOOK.COM (2603:10b6:208:461::15)
 by BY5PR12MB4257.namprd12.prod.outlook.com (2603:10b6:a03:20f::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9818.21; Wed, 22 Apr
 2026 10:28:33 +0000
Received: from BL02EPF0001A100.namprd03.prod.outlook.com
 (2603:10b6:208:461:cafe::78) by IA1P220CA0001.outlook.office365.com
 (2603:10b6:208:461::15) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9791.48 via Frontend Transport; Wed,
 22 Apr 2026 10:28:33 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 BL02EPF0001A100.mail.protection.outlook.com (10.167.242.107) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9846.18 via Frontend Transport; Wed, 22 Apr 2026 10:28:32 +0000
Received: from kenya-2193host.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Wed, 22 Apr
 2026 05:28:28 -0500
From: Hrushikesh Salunke <hsalunke@amd.com>
To: <akpm@linux-foundation.org>, <david@kernel.org>, <ljs@kernel.org>,
	<Liam.Howlett@oracle.com>, <vbabka@kernel.org>, <rppt@kernel.org>,
	<surenb@google.com>, <mhocko@suse.com>, <jackmanb@google.com>,
	<hannes@cmpxchg.org>, <ziy@nvidia.com>
CC: <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>, <rkodsara@amd.com>,
	<bharata@amd.com>, <ankur.a.arora@oracle.com>, <shivankg@amd.com>,
	<hsalunke@amd.com>
Subject: [PATCH v3] mm/page_alloc: replace kernel_init_pages() with batch page clearing
Date: Wed, 22 Apr 2026 10:26:58 +0000
Message-ID: <20260422102729.166599-1-hsalunke@amd.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: satlexmb07.amd.com (10.181.42.216) To satlexmb07.amd.com
 (10.181.42.216)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL02EPF0001A100:EE_|BY5PR12MB4257:EE_
X-MS-Office365-Filtering-Correlation-Id: 998ca2bc-9135-4d3d-2b14-08dea059e776
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700016|376014|7416014|82310400026|1800799024|56012099003|18002099003|13003099007|921020;
X-Microsoft-Antispam-Message-Info:
	jQ5n5EipiBjIUudh3RWRoWZWqlx+1qgN3QTQNqQwZVM6EdOKLMPP1dlaqPH0wWF9Oh6fT80RETM8QfP8LWyZnCN13AMBEvo6d5zeOSSd1IPvCfIe5g3WhN81FVuzKyg3kOhx7EVeMBxcOif//tuQT2cclZMjPy7WJ/sf/Gu1bb2TLtsrC5J7RmS1FXjClrRW0c9WD4/+vC+XK0IjAzUtf4LrN9n/qH3Wom9ig7/ugZzdwtm7HZ7aG3aX4yysg0+v4JFC5AQDQZW6ZZxDAo7YB/FdVtHQ+6OKFN/2cGofNTDt2uLnkil7Cb2CPvjrw8DK/nUmFEd+vzpAv0FAW9V9PvUtV9sR8/wxGKh3LjU4kI/SpefrZUhB9FOXm4fUraK5mXqOAe8QLMtuCm0nUcW1T5eUtXAAKHdwiw2lnorvhEvsWfEaUAWVdimffQbF9qZqZh8QmnJHov2zd0pS/FbPpimQDq1xop9fh6u7P4LdXNwW6Fy0KwuJKUn0fbFmZrC75nPwNE4nyfqaVJpddcu/X0NI4HG1IN437o/ipA+vHCnJDvuBYgaUEWNjtHj2+TW8UmklV//jhYnXWo7dahaX+xavUu/a/mctKaoYZAzKLWItw4xoN/2kn74LEiByEWxRL/V5Cc0fOi8WmnrCmAfGahAp9pRTZdeWib/Yerd5pjAdroQVi+rQD2rl5+8MpeCeBS3d4l0/FN9GB/vAISh6ZpqQCizXDKov7uVRdOv87QnhbxOjzhTc78G7CNKCC69kNN+WsSbHZrVTI5djk4Fz5To8Mp/F8wO8ng/sxmKAjWFaDv+mzM6tP+gIym0sFsz21UKowESZV5VfwUkX8G+FPQ==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700016)(376014)(7416014)(82310400026)(1800799024)(56012099003)(18002099003)(13003099007)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	h+51q+l5OUNfGcLc7HuGG8WaUr3ewecer/mwCv/yQLcuE5TIoEe33Ro6L5yHgJFCnyaCiMpJ2Ft3risgFuRuc+PB1sLYexhDId/+h1CrpNVYf299xQ8/fxzKUVuedTAXXaQ7Sa28hukqhS+rxCOh+rBMRBE2ylrW5CDhDkaW0cxYfysEtRvUZR1FJgsN3S+D/I8PgffDup82Iq3JwhRSh8Mzh+zlXcBO3waXnJxdqnXAzj83jsOkfLgXFkjME71cw6oLM7/YHj5EQDXJX0cDWFrpf4+jIu8RtRhl9OPyvLmDjAGyrZpBGW3VNW8iXbpgdgJ4TSsdDLt4cXD95bbEJ4n/WbUj/rTIKTAA5nrz8j9x2x+BOFoVkclIdx+m5VqzLrcXYIXcz3aE9JhdM3C23cfRnUGFE1JWXDBsbnLQxMaiaP5Aj06VxNgTnVTdwT9r
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Apr 2026 10:28:32.8571
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 998ca2bc-9135-4d3d-2b14-08dea059e776
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL02EPF0001A100.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4257
X-Stat-Signature: aqxj9fsfdiq3opy8xdz9f9uuxd8591ar
X-Rspam-User: 
X-Rspamd-Queue-Id: C695E8000C
X-Rspamd-Server: rspam05
X-HE-Tag: 1776853718-186885
X-HE-Meta: U2FsdGVkX1/p4KjWM3sWCIJh756DS/ru2RCc0KPXyebCG4vePBXQZRg9ishZeZptTxJbzIEhbSlzwtNkVejyAEsVWMi7jv/SHU/IHkurFOA56fuKF+cMnXYZ80myymRbvRk9O7lvigxEbvswS7DMf9clW7shhInbu0oiS4z8EKIHyQuKrpDT7kV3nOUL6AqtRHYvySvBFhrwz5jIKU1djPU1fe70jpjd/BDoimGuFIWq2FVyZW4RI5rmrt/FJdakf3FfpEm976h+IlF29u55P0+lK5P1ATRaV8C/vDLaJ6VZi9b7J5EJu/bJumVWnArR7bFb49f5YzF74ShT3YTLB36+T2dq1/KtK04itj632fUPbLXAXGIpMxLaPFP8mScrmBNFnzkXm+1YLaEtJZ81ake/sjOGxJeUWMpg3Aoq+W+3y2mSBQa6gmelpS0IpbNpub5Gv0tINBw8NRmjlzNDbvBFQRRyWVlFqx6LreTKiypsLF2OVjxtNJDSenvDRLyVPOuk9WhYYcdyqlOckP0JnsMJrr04fUsOUWXO7FV0qwFyqj6RiMd+0LsMuQeehjFD2kLKGLMME49QH1c7cxplSTKk9GLs/SpfKaSR3v1crdXzCfTewcgwsRC+uFzvPXjSo69AGhey3oJE+OQBjfM0+Dyff/5qC/War9r9mGAOTVPp5tTMUEtspJhFNOCxELwWTN1+g7hbRqvPD0LU52GxLpQz5Rmu2lapfgB3z+jlnOqgVea1PgOfG5T+z4yXcbiOtRxhhzoDTFdkty9vjkAqnP7NRPtqHGYpaD8EPImRsxavbd639YBtWaSqdFA6nJBqKJ+bC/gUVWDipaA2iiKAT0DUICa57UUEVJfgCh17Buq/P72p0fk6ORlvuSF8Op4LpIkN0uNY2E9qkEApa2MuVMTdBZzMUTJN+JyKxlnrjblR1KHQhIOJfn/+zMpGZ5bdWXXv4q1n2aztVGrOaNG
 d8O188QS
 RCF0Ia4QuwAZCZ9BOQApWnGrIuEu027yC2ZxlYdXrBzCtZnyoZGxUpZIITEGfa7lFn3HDJlH3WlVyLJswBnG8FRR1YSGqWL0ixSodQ731vSqhY6dfNvmeHGsQuEF1xl0rOBojj7p+twKNz2wDqVfrEHads4osqpVhNvgcKYZtjvBsLf/9N3FQqbxrQdagzZoXLpzbNaDKtwIGvmJo5ZPLXmcO0DjG1GglK4mZQJZNC9Zbtw6uJYUNHOmi06itRtRMeEstovf2TSk/5l/K5DReeoMAyzuCmZRHQkhIqpomApdGqaWZ8blr/uMSFr1Fj7nhnNCnRC5UjOzRJzr2V6yL1/GVC7K6wH9k5Ag6LONZoJb6fuIq4OWAT2JTKmVrX/4gz5CPoch2RpOKeuu/mKolbq/4e2FeaPNXCkomq9R9Riy8EQi49Lgzdga9/4tr1W6grrlpw1eCe8rn49vyMWxD9TQ3hV1vFjc784PUWIZuNPGnG3cF+9rnjVCqPvNm+F9TDR6FX5axU6viN8iAIiEZyq9RrqR0MkNSXYBSuq11KdbSPjsrWzeYIH2joK883hnxQ+cokb5kQC/QUGEGJCC4RwcGJraRIlaFEB01zI0s6qwVdQiPXuSHTwqQxO77iiZavZq+S8FsdTd/JEGR31dZSTWI3znpdBoifsBQvk2wQkSDAKGvIT80P2n+6t8XtOzLp7Sy
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

Introduce clear_highpages_kasan_tagged() in highmem.h, a batch
clearing helper that calls clear_pages() for the full contiguous range
on !HIGHMEM systems, bypassing the per-page kmap overhead and allowing
a single invocation of the arch clearing primitive across the entire
allocation. The HIGHMEM path falls back to per-page clearing since
those pages require kmap.

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
base commit: 2bcc13c29c711381d815c1ba5d5b25737400c71a

v2: https://lore.kernel.org/all/20260421042451.76918-1-hsalunke@amd.com/
v1: https://lore.kernel.org/all/20260408092441.435133-1-hsalunke@amd.com/

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

 include/linux/highmem.h | 15 +++++++++++++++
 mm/page_alloc.c         | 15 ++-------------
 2 files changed, 17 insertions(+), 13 deletions(-)

diff --git a/include/linux/highmem.h b/include/linux/highmem.h
index af03db851a1d..1178b786b5b0 100644
--- a/include/linux/highmem.h
+++ b/include/linux/highmem.h
@@ -345,6 +345,21 @@ static inline void clear_highpage_kasan_tagged(struct page *page)
 	kunmap_local(kaddr);
 }
 
+static inline void clear_highpages_kasan_tagged(struct page *page, int numpages)
+{
+	/* s390's use of memset() could override KASAN redzones. */
+	kasan_disable_current();
+	if (!IS_ENABLED(CONFIG_HIGHMEM)) {
+		clear_pages(kasan_reset_tag(page_address(page)), numpages);
+	} else {
+		int i;
+
+		for (i = 0; i < numpages; i++)
+			clear_highpage_kasan_tagged(page + i);
+	}
+	kasan_enable_current();
+}
+
 #ifndef __HAVE_ARCH_TAG_CLEAR_HIGHPAGES
 
 /* Return false to let people know we did not initialize the pages */
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 65e205111553..2908d24dd3e2 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -1208,17 +1208,6 @@ static inline bool should_skip_kasan_poison(struct page *page)
 	return page_kasan_tag(page) == KASAN_TAG_KERNEL;
 }
 
-static void kernel_init_pages(struct page *page, int numpages)
-{
-	int i;
-
-	/* s390's use of memset() could override KASAN redzones. */
-	kasan_disable_current();
-	for (i = 0; i < numpages; i++)
-		clear_highpage_kasan_tagged(page + i);
-	kasan_enable_current();
-}
-
 #ifdef CONFIG_MEM_ALLOC_PROFILING
 
 /* Should be called only if mem_alloc_profiling_enabled() */
@@ -1428,7 +1417,7 @@ __always_inline bool __free_pages_prepare(struct page *page,
 			init = false;
 	}
 	if (init)
-		kernel_init_pages(page, 1 << order);
+		clear_highpages_kasan_tagged(page, 1 << order);
 
 	/*
 	 * arch_free_page() can make the page's contents inaccessible.  s390
@@ -1853,7 +1842,7 @@ inline void post_alloc_hook(struct page *page, unsigned int order,
 	}
 	/* If memory is still not initialized, initialize it now. */
 	if (init)
-		kernel_init_pages(page, 1 << order);
+		clear_highpages_kasan_tagged(page, 1 << order);
 
 	set_page_owner(page, order, gfp_flags);
 	page_table_check_alloc(page, order);
-- 
2.43.0


