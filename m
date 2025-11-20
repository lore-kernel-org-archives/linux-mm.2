Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E5886CF8549
	for <linux-mm@archiver.kernel.org>; Thu, 20 Nov 2025 06:54:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2B0DD6B000D; Thu, 20 Nov 2025 01:54:15 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 287AD6B0012; Thu, 20 Nov 2025 01:54:15 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 19D7F6B0026; Thu, 20 Nov 2025 01:54:15 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 06AAB6B000D
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 01:54:15 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 263A013BA7A
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 06:54:11 +0000 (UTC)
X-FDA: 84130071102.28.6B7197A
Received: from SJ2PR03CU001.outbound.protection.outlook.com (mail-westusazon11012043.outbound.protection.outlook.com [52.101.43.43])
	by imf08.hostedemail.com (Postfix) with ESMTP id 257C916000B
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 06:54:07 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=M5fc9QDM;
	spf=pass (imf08.hostedemail.com: domain of shivankg@amd.com designates 52.101.43.43 as permitted sender) smtp.mailfrom=shivankg@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763621648;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=7o7n1yAl0zHW1xXqIGXgdJhbcp7VODoyEhqvVbEN0qg=;
	b=QPVbaj4RnyeXVKisVGMl6DNafU1bEIhSjn4fSqHvUo9+Im3py0Kg4SEe8Jl0J/8D0NsYED
	q+HN69fitPLCgeWcRyehX7fxZYjaHPukOvSREui7+3iFvWgGy9S80HFpYu2JvO0Vf5MvBD
	/w+Ew1Ruf8RiriGYSaPk8KkQ8fiCY9s=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1763621648; a=rsa-sha256;
	cv=pass;
	b=YCcqY1NU+MW0MTn2Il5avTC/KOWzrl1iXGMBvwt8aRee+p/EPQQLNiwLVVvkeWZOYtuvUr
	v4xijWA98uDl7e4cCZWmyXaLeUYeUww9/8rkbgaaeb9fBfKkdGHKUoNMzLOwBMjWI85PR/
	fO/P17Lh+ifDxgBC3kws3cVaftpXnFE=
ARC-Authentication-Results: i=2;
	imf08.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=M5fc9QDM;
	spf=pass (imf08.hostedemail.com: domain of shivankg@amd.com designates 52.101.43.43 as permitted sender) smtp.mailfrom=shivankg@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=auL4HvJ26Y4KKLaOqKM5dEhaoqwF9vkaXdf1ozDbeLWSkZ3S1I+dB6EpIZym/eDNE3j4enOKjzCXQmsmHOrX9fUmzObR2iMJMybm6uFqlIq2WosIur/BM+7eerkBAuttInaD6OBWi0EY3GLMHvQ43jauKBleuxHhNaLrcC6Z6eNgEX0JtUq/91fKV+IjwuUS+p1hfyaaF6XDmN5qIPWmWoE15FduNaXs+SzcjTFHw29suuq1HvSvk4b+f6zFVqguNs95QExwoQFPxuPkCpcpvwCEhRw0Sr2MWgvgAeoLbGalnOXFdKYn8w2b+zl+gvGAaMfZwI+bjYnYvPokcg4KWQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7o7n1yAl0zHW1xXqIGXgdJhbcp7VODoyEhqvVbEN0qg=;
 b=YPSnZ+JCiWDeT8+woakSxpIQTbwVbuy8KRVxtzn/rmBLuE1JUx8N1GXNxO8Z3lNFD3plDT/cSEKMlfbtIogYSH+5D5SasdpSuNOoOaILURs0pYx20h+4UkcAO9GeGAx+d2lCJmzX1eLSt5Sjdf9i1zoiwBFT5lysSnuy8WXN+6GLFf/VfASjWmgz5uJpTylKKYLG7jv9uxWeCQVdS/7j/2Y2Cc/ev6Dc6sSJEm07q8pK/zgk9AQX/qEhrkqppMr8zk6FTB7owMSrh66kC9NOmZdOQEvpE2htTwtwkWCeRPFMMEzavU/UbUsxXe1OJXX7yzKdpau7ETEvSg8Aj5MSAQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=linux-foundation.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7o7n1yAl0zHW1xXqIGXgdJhbcp7VODoyEhqvVbEN0qg=;
 b=M5fc9QDMbtaiMT++vmgYRZBwhvezu4KlXjg6J4BJLtAlVuqLodmGJlvqkFefqasBDojApjeF2MNnyi9LKcM2IF2lBusFvRICqBfE/JsGvFljxXhqMgyeUjr3ZP6M4Qrks8EkgbKL+THp81TteOYN8Ls0+iB7AgAxXlPqLTdYSAU=
Received: from BLAPR03CA0061.namprd03.prod.outlook.com (2603:10b6:208:329::6)
 by MN0PR12MB6029.namprd12.prod.outlook.com (2603:10b6:208:3cf::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9343.10; Thu, 20 Nov
 2025 06:54:01 +0000
Received: from BL6PEPF0001AB73.namprd02.prod.outlook.com
 (2603:10b6:208:329:cafe::fe) by BLAPR03CA0061.outlook.office365.com
 (2603:10b6:208:329::6) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9343.10 via Frontend Transport; Thu,
 20 Nov 2025 06:54:01 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 BL6PEPF0001AB73.mail.protection.outlook.com (10.167.242.166) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9343.9 via Frontend Transport; Thu, 20 Nov 2025 06:54:01 +0000
Received: from kaveri.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Wed, 19 Nov
 2025 22:53:55 -0800
From: Shivank Garg <shivankg@amd.com>
To: Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand
	<david@kernel.org>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
CC: Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>,
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song
	<baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, Steven Rostedt
	<rostedt@goodmis.org>, Masami Hiramatsu <mhiramat@kernel.org>, "Mathieu
 Desnoyers" <mathieu.desnoyers@efficios.com>, Zach O'Keefe
	<zokeefe@google.com>, <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
	<linux-trace-kernel@vger.kernel.org>, Shivank Garg <shivankg@amd.com>
Subject: [PATCH V2 0/2] mm/khugepaged: fix dirty page handling for MADV_COLLAPSE
Date: Thu, 20 Nov 2025 06:50:46 +0000
Message-ID: <20251120065043.41738-6-shivankg@amd.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: satlexmb07.amd.com (10.181.42.216) To satlexmb07.amd.com
 (10.181.42.216)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL6PEPF0001AB73:EE_|MN0PR12MB6029:EE_
X-MS-Office365-Filtering-Correlation-Id: c3bf0f5e-c159-4e91-64fb-08de2801965a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|82310400026|1800799024|36860700013|13003099007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?OHi/0DV8dS1mi/gvLZv9FRgH6LQbcY1BgZxakL84+lIO3z0BH2schVdjSX/3?=
 =?us-ascii?Q?CeHeAsesmcmYueUxwq0QoXFmNhDZ70+rQqV90jTlAFhTpvLxYV10ifRszhEU?=
 =?us-ascii?Q?dg+8XF5Tcpf6McPUGhnynkzRUTpLz6gx1mzj2OJG6eRnavGmTWEr/P1mcxnW?=
 =?us-ascii?Q?GeJzkWkycOsY2DzGNvVK9AcLpS3rDNSaNFvzothm+AhALgLQWiU3PaZA1hn+?=
 =?us-ascii?Q?lvdcfI+yNmsTrCnfjShD0oIJssEIBqESzkVwz1d6VgGX5wuQjw9mVTXLpmC6?=
 =?us-ascii?Q?QWiRfyfrOBWCdHTZ3RqvV7aHqTrunBQbYphpDKMg86MGc4/030u6+azTVYCC?=
 =?us-ascii?Q?1unkw1XztX1CPcULyGjR48IaIwbFEYMSEqQVuMO/5lq7bBVuTc9yjaUST4t4?=
 =?us-ascii?Q?ROe/r7zRTnw0Iia9SDca3+8YcFrcPa/VgG+QCiYEEtm1SSMSCHqGY0Bamt8Z?=
 =?us-ascii?Q?VeZ6TPXpCHmSLaSs+3i9nk6Twx8J62rAvdILNbtAVbeWRH/t6ukmlmPdeUmW?=
 =?us-ascii?Q?9LV7ybme7h5Y0zB7ZrHoekaMrbmRsFLK48U7k+JlZQ6oY8YiwejRmcI6cVdR?=
 =?us-ascii?Q?uQSJnrTWvRCD1/1rEGFxaskg2P4DSTnmkIK4yimHJNyBINCkUpVZqjeQO2Gz?=
 =?us-ascii?Q?MgipK2nSG6TnVBUAcgFdLrdXS69HfR/WS0YtS1aCLY/606AQsCLKzMB870YI?=
 =?us-ascii?Q?DELdf5tH30T48IwEnzSYtvLcXfUnIG5deSBaUEcpnYHKOiUZ6cG/xUuEEOlA?=
 =?us-ascii?Q?yawvZBpNlkknLZKd8Lct33uW9ZF9eu3btOZsVxl24PCVJmJmQQUgDClzOBvg?=
 =?us-ascii?Q?4MlegqXlCfxCF8zgyOaB/uXQJrRXEioPXjTy5AZRL+Kx1nfP+vJKxswPsqoD?=
 =?us-ascii?Q?Z5aSg7+zc0OZ8DRKq9vPmxzMSDyv+lXFgycCLmRMbAR0k0j7gTybizFmosZm?=
 =?us-ascii?Q?1cd3OF9mS4BrvfHu0WAXMSDVfW9480wQjMmoqu7kXPnPX9N5TjsJsukh4XUi?=
 =?us-ascii?Q?DqMFuLlI+1nODMDR8iI5N5LYkRPYId78RUNbt7TRUa0o1mc5OyzjH9IJ9mNa?=
 =?us-ascii?Q?6mD0e8loucVb0/TQWpPHGtQRDGaUbZWtExefG3j07bXyDXoqeh1T86acWSJJ?=
 =?us-ascii?Q?AgN2fjb0tIwo6wFOHUcRFdRvfLCJ/IzpHJufqdr85HkG8CjClJ/mooL7P0U2?=
 =?us-ascii?Q?DyrQIdJY3Sjs5MvBgqaph5ZddpGLs8fz8xmi9i2e4SLM6hNkDCN5lL0zRzFr?=
 =?us-ascii?Q?+ARSNvXtQiUwOwwSqFv7H8j7w29ttnrMYSLuI5OjSFT1mLpl2/24ZUW7uAcG?=
 =?us-ascii?Q?ZBzebubdJ57bJrTDiRF6f3Ng+RoWz6M5us6nfQKKD4fvbqEPPo9XwHz4rf7f?=
 =?us-ascii?Q?+jb6jo6/rTTG1OM+6ljPKrH/oc9WmFlLODptvrPujHsfZH8F3nfkrUCQ72wx?=
 =?us-ascii?Q?CX3UY2O8rWOvaHvSbIAxdlVIosXO+EBR4Uiqw3B+EiD/cxKrfGdKDHOK0KEe?=
 =?us-ascii?Q?yCmyPwzCoHF6QCRRQj03L9nQqDy6sWyR0L9Mg9kIQTaakcbQe7YBJ8vLwfp7?=
 =?us-ascii?Q?SB2dL6Jf2yYA7oi6ggnIyIhV28izqtcGOVwFN0RZ?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(7416014)(376014)(82310400026)(1800799024)(36860700013)(13003099007);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Nov 2025 06:54:01.5349
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c3bf0f5e-c159-4e91-64fb-08de2801965a
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL6PEPF0001AB73.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB6029
X-Stat-Signature: 6drdmux3sokksfdnq13bobubea6ajz3e
X-Rspam-User: 
X-Rspamd-Queue-Id: 257C916000B
X-Rspamd-Server: rspam01
X-HE-Tag: 1763621647-16870
X-HE-Meta: U2FsdGVkX1+rn4KTxmu0Y9tnh7LDvRaoazaEM+QRCGkNpG4j/2yXRF+DjnAPKYtmXeAdQRiDuzqLHVnXRk27wUode2yelZTUiixJS4WJ4onw+69265tsH4taNX6ltTobTnqZ46RyNKAARFx5w++myGW9BECAa2bjoLdNT6exgZnH2+nxnfT0/OiHpNWjcZQKAKJ9nh6JnUfB/NRyUPO5HsLjv2vtlYZQLDxe2/52MBLT2sOLsNfBu4FLL1or9zztBQh71juwqhnEUNXpeG9XThkumhA7iVwreAG7x9wK2YrDO0970MwL2Es6RbfKiaZPdiD8EsJHog21CyxLkqKe6tVsD7FVaMmvYyHEfEFjkVA10lGxk76yobJ6PHfEctkPrK3LahfGp4uzb1b9RBGP0rK8UYDgKdBJHd/4u5AfFqURP7wxwZKp5TGDyzNkwTvgnG4AoL5nCAv+GesEOlimsIFBkSoVtwHSziIMDIbX+q6udhiHhzqNi0y6h1z98d6KAYhJZ+bMQnAqCPrT3IVTuEl4wZqTonBjtcRCdlRia/UOiyuYfY9w5kDZjLJr76TuKyXbCM+ex4H2vYV91AJavWDWSPImr8P0ZHi5z+ucCTfqgRm6Trq4fI43qHBymJNmPBwjp+N7kjrmlaiZx0mMJGFJX6EFl8dGr/Wa4huStc5/lbPZH1eV7bS6lnbeG+mv3XusdLY4XwlAGSNDHUh/aJzB7gMTYna6FCk9SR0Pa4bjNt5nkeirLCvEwFbyqnHs302rcuRK7t29VIYnR0N1F4/qFF0MTNHJW5n9x7YeNcNl6Om/7WmGBwvtTavW04BxjmmpU+RQwn7Ss4hQQwWi1KaNEGjpw5a0/+NIvh4u/JlfF/gfqqtisNYQedFsBQyOrMQe/EUWCF5KAkk/6UOfUqQ1l2d3hCfV5u6BMsgjFHBpnJoPhRMValeOCcIz891Tnb7IZtPgKdgO/7uVLx+
 Q2cWRDX4
 JtPxKb5JqwSFvCGKBSeuyu5JyxFQdh/qpuEIYD9DYYYgbBe1ME/AdPNFTYtzyAG4gxlH45wmjO9+ZBr8QlwOv9UnSww7bHwxMjIw55U4X61OwQTfPYDZ1FjrKSQXOZM5+hOjWBiaAJHJhxKjuCO1HB0ZTmycdwoI6ChSD/RAtZWQXGEI8d3KHrzRzVY0m2ZeDKb/yE58PlPAzDf9DyV0GwT89FJmsEBMISRHKt2iqTSaz3K1PDbipC6hfvoZyhVZcFboR7N9dsgb2chsXaI8QEMxAsNydkyUme2f56WJ91qJnIKmH1LQqCt/L5RCw4NER/BIpEBdmJSnunOQVIdhRN3c4YvFU5E/SN2aUIedny6sRw6Pox2EO2pE4/G2+w+lveYQ3R8Y1O2GyMMJme4lpkEOsOs0s00palhMAQwikW1z3E2AZhyRTodYhw/b8B8lrDBM7wwedtRZLUOavcXBjruAWoWOc9TOMQs5cauCpeiLMezVokd1+YjeRKd+2Ah/w+SdRjejMz5H2XRo=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

MADV_COLLAPSE on file-backed mappings fails with -EINVAL when TEXT pages
are dirty. This may affect real scenarios: package/container updates,
executing binaries immediately after writing them, etc.

The issue is that collapse_file() triggers async writeback and returns
SCAN_FAIL (maps to -EINVAL), expecting khugepaged to revisit later. But
MADV_COLLAPSE is synchronous and userspace expects immediate success or a
clear retry signal.

Reproduction:
 - Copy 2MB-aligned executable to freshly mounted XFS/ext4
 - Call MADV_COLLAPSE on .text section
 - First call fails with -EINVAL (text pages dirty from copy)
 - Second call succeeds (async writeback completed)

Issue Report:
https://lore.kernel.org/all/4e26fe5e-7374-467c-a333-9dd48f85d7cc@amd.com

v2:
- Move writeback to madvise_collapse() (better abstraction, proper
  mmap_lock handling and does VMA revalidation after I/O) (Lorenzo)
- Rename to SCAN_PAGE_DIRTY to SCAN_PAGE_NOT_CLEAN and extend its use
  for all dirty/writeback folio cases that previously returned incorrect
  results (Dev) 

v1: https://lore.kernel.org/all/20251110113254.77822-1-shivankg@amd.com

Shivank Garg (2):
  mm/khugepaged: do synchronous writeback for MADV_COLLAPSE
  mm/khugepaged: map dirty/writeback pages failures to EAGAIN

 include/trace/events/huge_memory.h |  3 ++-
 mm/khugepaged.c                    | 34 +++++++++++++++++++++++++++---
 2 files changed, 33 insertions(+), 4 deletions(-)


base-commit: 4a3f8fc3adb7046e44bd1feb2f5c5fe95296894f
-- 
2.43.0


