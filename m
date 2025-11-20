Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 92D7CCF8548
	for <linux-mm@archiver.kernel.org>; Thu, 20 Nov 2025 06:54:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E245A6B0006; Thu, 20 Nov 2025 01:54:44 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DFAD96B002A; Thu, 20 Nov 2025 01:54:44 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D11606B002B; Thu, 20 Nov 2025 01:54:44 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id C00456B0006
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 01:54:44 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 3C175140793
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 06:54:42 +0000 (UTC)
X-FDA: 84130072404.15.0709EFF
Received: from CH5PR02CU005.outbound.protection.outlook.com (mail-northcentralusazon11012058.outbound.protection.outlook.com [40.107.200.58])
	by imf20.hostedemail.com (Postfix) with ESMTP id 431711C000C
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 06:54:39 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=V6dw4Cjn;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf20.hostedemail.com: domain of shivankg@amd.com designates 40.107.200.58 as permitted sender) smtp.mailfrom=shivankg@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763621679;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OHymTYfrXk+/CoN8rpaGFIobupBBkiQ9oDq4UWlZNR0=;
	b=ZJqOelXLpvwTwMt+EpmtQJT7Jhumvt5g4ZdTyMGLbGdo6hTBYF/MoMlwWzh/Bq74VIhwr+
	FFASKmyYQi5VXCerFs4dQ4VS4WRDvASW9NAZWNij2V0S/OxPgRI3l+gIGiBSrpm6Ft1dJY
	usXVM2f/hTaC416Zvsd+ay6IsgflJfU=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1763621679; a=rsa-sha256;
	cv=pass;
	b=GpuJns8AAg/jAMJkQ/Yl3Zm3LcBPacPrJlCWAyqcHoKGq/kGoei3iDAsGbCnLZGQG3jC7v
	Vwn0S+4bgsyQ/N9zjieQ5TZk25cZsUXvIQT4gbUZjsjatJ0Hl43guUh+m+wu4EwbxDXqTc
	JyWKaOJrk6xaw+2XF+uw9ZGBjgaTBQM=
ARC-Authentication-Results: i=2;
	imf20.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=V6dw4Cjn;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf20.hostedemail.com: domain of shivankg@amd.com designates 40.107.200.58 as permitted sender) smtp.mailfrom=shivankg@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=mDAzzVW/3d6yodBb+VL23uFx+qPFIolYpjOzfXYZBCJiW843+Ta1diPW5m6ByCvWHaw6TDc7ZvktWNSB8evF5v4/g1XgyUdwOKhq9xp7ZnYrs8l+sIWgx6F3WRf5LlCagHADaNOADn9QPrKUzCrHfSlJtdUPG/Ao0AaVt1052pfgTrUcFSLW16XC7OO/cH01rOat0eSWVOb4n7F3BivuIon60cpf8WyIiuDUvxKL3HvObkaM+Hp0DrKnyL13HKnAlc5x1CHTzaizv0jTdHsxOY2M+csw3xMUxu+2g0KxJEqg2w87NbAtHdTxfOPzR3IiYv2xzpTzoK+YARkyAyLhEw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OHymTYfrXk+/CoN8rpaGFIobupBBkiQ9oDq4UWlZNR0=;
 b=rhQ1HdF8HxqDvAbG6tcltC5I64oXW96azmNUN2TQWTRN6wuZFhveKdbnLv0wA8CU6b5K0EmaPCplUIwrV2aCBpj7KEpzi63k9uxfbqAiSekicKsbI1KiKelu5V0soJuzxosOPVCIPH5NjDhyhteT0hKUhP1VbxnSfR6Cs3zdC1re6zfiIV2fxtL0fGwzA2M8YdQaD7QRbuPr0k1PZN2R/kPrmuOg0+K52wSqzvIUMqO3mPQhdfVAngYGuE+wcDqU8tu3lHfiqsIfCjdMBWVQ08i7LSXsMFXHqyR3ckgdPucLeJ87g+E8Ro5T0M3vKHfc2R8uBIjUdvfAE26zZrK7+Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=linux-foundation.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OHymTYfrXk+/CoN8rpaGFIobupBBkiQ9oDq4UWlZNR0=;
 b=V6dw4CjnQYabc9ivvmcqKfd1JK6rTgZA67Dxcnfr1n7XGy/Dic/E4f25cgXNcEHQ0fGzdlk9UJ8kSCeIrEKV81fRaVGTg4IEB/gtEDqBdGU+2ujJ9t19Fj+BQdAMw/apWVSbMNRscw4T5vwl48DrjNkt4u1QwbC/V5fSsHqdxm8=
Received: from MN2PR20CA0052.namprd20.prod.outlook.com (2603:10b6:208:235::21)
 by SJ0PR12MB7476.namprd12.prod.outlook.com (2603:10b6:a03:48d::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9343.10; Thu, 20 Nov
 2025 06:54:35 +0000
Received: from BL6PEPF0001AB78.namprd02.prod.outlook.com
 (2603:10b6:208:235:cafe::91) by MN2PR20CA0052.outlook.office365.com
 (2603:10b6:208:235::21) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9343.11 via Frontend Transport; Thu,
 20 Nov 2025 06:54:32 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 BL6PEPF0001AB78.mail.protection.outlook.com (10.167.242.171) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9343.9 via Frontend Transport; Thu, 20 Nov 2025 06:54:34 +0000
Received: from kaveri.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Wed, 19 Nov
 2025 22:54:29 -0800
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
	<linux-trace-kernel@vger.kernel.org>, Shivank Garg <shivankg@amd.com>,
	Branden Moore <Branden.Moore@amd.com>
Subject: [PATCH V2 1/2] mm/khugepaged: do synchronous writeback for MADV_COLLAPSE
Date: Thu, 20 Nov 2025 06:50:48 +0000
Message-ID: <20251120065043.41738-8-shivankg@amd.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20251120065043.41738-6-shivankg@amd.com>
References: <20251120065043.41738-6-shivankg@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: satlexmb07.amd.com (10.181.42.216) To satlexmb07.amd.com
 (10.181.42.216)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL6PEPF0001AB78:EE_|SJ0PR12MB7476:EE_
X-MS-Office365-Filtering-Correlation-Id: 4ec15ce0-123d-4380-640a-08de2801a9f4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|1800799024|36860700013|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?sWsJ7xdP/mxdabdrnFW316HL+pieKXLvV6Nxt8oclYB7uN3spTkKMtMRFa+N?=
 =?us-ascii?Q?24god4mmu0Dkhw+WdwTFJS7PeJ/PnNKxS4VtP1M3MNB0tgqF8oyWjE/2Mt+w?=
 =?us-ascii?Q?9I63ok4Zs5G2RQOpbBSFkJP1PNRME6y7P14tGgCW6g6X/HlRXtsXpueCZN4S?=
 =?us-ascii?Q?BdSAQjYfXppfLNdkVCDF7bwJfHcOEGNVUVWDPWVSJnFow5sGiNjVdBDwdsH3?=
 =?us-ascii?Q?wOycHtFKYEs0dbaUY5Y4rDNJQJhAcMmuq5/tbuu7tJJxTLumfbe3qpXjbfgl?=
 =?us-ascii?Q?8/O0ofAEl09lRDehXDCfXe1O3P9a1dL1tEEW0VFUQ+bahe/UBeNuxQY46zVg?=
 =?us-ascii?Q?mSly3nPsN85Vwk2GrJAwh/hWkZkyFV8O34WEzLBA30y/wJ0MN8lTNgpr7fll?=
 =?us-ascii?Q?SM2a5hCcEfVOpkS4xK6LVLO/k/JO/7dfnrta9ilnVQL9tm+e++td6R+pk++g?=
 =?us-ascii?Q?klQ2EbdJIdPTULo4L7eIoYWA5nQETfDx5TCG/42F0P9akDDcgEG1Vto5xr7y?=
 =?us-ascii?Q?wcf0b194jACN1GtGq3r9u2aV0xrehMbsiJw3Qv0exwaxJV7EC7jpmXpLdoDZ?=
 =?us-ascii?Q?H3aDOJDFySN9AjTEeAnKm1ZIgeyPb8Y31h6/KK4+UgjqWHCGI1DmXup4AKhp?=
 =?us-ascii?Q?xbYXsIUduyWcVSX9rkXgflxOSPkvkHJkzu5Xh0E1rhLsPlWpq+uw/HbLfsE0?=
 =?us-ascii?Q?uuWnuyuZpUZdWrCu+poQTQV6zVJ9cvNUtGEIBvE42vxnGYIJuGfcy0eqDJKm?=
 =?us-ascii?Q?WgR1vZJ3FKVO21lL4L+wJGIE8PiHm9mEMq5J/96KQnwW9z4qP4i+vcsGHVzO?=
 =?us-ascii?Q?bxia0Y6tAyc8W5XqFek44PSA4n9zUgtxc3bK1IWlps38+mJ2BjHIlle4HQn1?=
 =?us-ascii?Q?eyI2zpzmqLv4dkv0uD9D7FuB5IUQnxlBpyAUKRWJqYpmAr+TkCCYx6Dhgeng?=
 =?us-ascii?Q?xsR/qg0AIwVelKHw3U33DroFSrytlR/DufaW9yG247SfljlbrOHPa6DP1C0M?=
 =?us-ascii?Q?V3A3E4yitjRnZkRGJPETUY6i5701d6uDKy5nSUjJ9+3Jxm+HRGEs0ua747x0?=
 =?us-ascii?Q?v/K9DiGeprsqEWHqbcXZLa5OgESgdV1TTXkkJK5JKPqmjQkVOiRJp9F+9bjk?=
 =?us-ascii?Q?dLUOr1diVAYtnvXQ5UcTPLLkmGB7fx7fX2XSfNIW0pT6R0xt6+8PDiLnCYU6?=
 =?us-ascii?Q?VXG8VdcIr7iH0R58UHrwUc7Fw++b+ynn/NZn2rrBjvfkPgbvfOUSldR8Tp9L?=
 =?us-ascii?Q?DMUKD8TGdi4Ex43au8j9xib8Gyj/zDJrEltqCIa90MQm0SUD2SYKLNmEUA21?=
 =?us-ascii?Q?568al0RBi/ap/xJtpXRr03ZNQ9UIKynIQciK0qrq1xus0SJuzfio5KgIY5DT?=
 =?us-ascii?Q?k5m03j0aUdOb+BYcRBjkZ3785aWb5lT43PRKWnZjTdx855Ol8lKSl3GKkHti?=
 =?us-ascii?Q?4QazqB3LbUE23lQ7qCLGj1UyKMCbU7f0SVmizlGqW4GU/MS1Pxan7PYaoW+s?=
 =?us-ascii?Q?nz/dmUHlb4IeRxFjalpuHVAv0+eio+YxZ5tt1gf6Oa4QgEQpyIIBlzaszG6c?=
 =?us-ascii?Q?IqHqYOoKSlW4eop8SK+XXsI1TQwGD1pnwaTu31ez?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(1800799024)(36860700013)(376014)(7416014);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Nov 2025 06:54:34.4205
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 4ec15ce0-123d-4380-640a-08de2801a9f4
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL6PEPF0001AB78.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB7476
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 431711C000C
X-Stat-Signature: x179ew6dnp5ptne1697a48tnw1tm4bjf
X-Rspam-User: 
X-HE-Tag: 1763621679-924669
X-HE-Meta: U2FsdGVkX1+dCFAxUtHwJnNYpaKzBDP9E4zllqlmq0FoZUWoCkPE8cBO/Y2tOZ90Nx5PtyEV4sHmrhhY9aYb9yJEZT5cMN4DrTaiw1Df0GazTCpc9UJOJ9nb30Y4HrE/75UVPWgrPaHpNJLCzy9lRvAeAvUm8cFWQbrSCBdkVzn7eNE7ZHVhFVoFq/d0YiVcIO9/bpW3fmIu1y2w3yVEb5nvb0K9jpztBIdWIVZd3Af6W8wP9zmZePIqS+Fcy7xkVmwFgTzcfHRL9itocwynroUqtV0gL/8KFr7ytWCvjqXXJhXTVpiI8gt6I+M+UxrXhJzmbXKSGwVJ2YQaNrsxNKjoTyzYkODsIH1DbocRupD6F1+zlpWZszjpWvLzBAqY2PRIrCbORLZoWvEeA0mm34LsfXzckCPMRRWMkuQQl/cJV49SUs5NBrQr0BvHugu6/xCrfU3OMHQPFO7FskERK2Czg4K5jPC1jg77iXbEnaCibDSl9EOvQkrSk3YN+eyqANX6UKyXFEg3g6g0nL8Lg/ZFHT/rXxHvaluSilwWafbPJ6MA/rzuzyuCPwDW/ifedaTLIhZe8mMrYCmk3AiF8IB6juSCkteprYBztd2gJriRdeh6ij+fhZG9qQQTiR0qWQw9IXb8p6sqJc1jMIZViiUP7VApS4Bqc+f3xYOHBEztQ7HO5aEw6kmHMed0r5NJKw16I9OvTHIRRF/g32c3uv9ldgi5UrZrVp7lEa4n1MJ33dfSf91V7sLKTWUh7cfQVfvkEMtScdYF5LFo3cQhXHaldP4t0ZeQ6SRl+e0+dH6H5rnAqGpftPhQsfElRSmEx7Z5uFM7JVmh8NaimaVx4hcgRO1/8uh6a7lgx6ftQP6yDzbt07MjGzT3uHzN2s4yr7h+iy7NndN0zNXV4o+dtgzEqdho+aSVKpAgQil3cI6aDOoa0eADHUTPUqZWYQIypLe7wQtYXhGdldyu/Fn
 CH7OfcX7
 hzC3uBBjvj5di3c0pbZ9nzBgRcIbva+zBE/7AjFMLYG4meHEFtPb//XARJxPWBSDxR4/5hlXTZI7GvpjlHyeNOSpqcjjo9Cwbria+9TvZ7Cabe8IPTgMVUD3xztBIzIXW4KDeYXQeulVwYfM5wihfQ4lRCvPoQnfVyCyJzPXg3CFZ6mjdb6FoGzNRrZF5PDQdRdzsmqLjaGDoUYBrvkvj0eUS5pL8ozTNjjVOS5BCKSWNnzbyU0gjoXCJ4kn2/V2MUmsInlulKQeiSPYvHEo1wLwcqPWC1KoFwXq0XNDgRIybJoFF83wrUcP/GIEhUNRf5JX3eMqoE4vRngNDFIlJz8L+nWDLHgGTiamorMIWAVWjowgs1yq112+wMaH6BXFAyvg/5OAAE9CA4AL6TZDwDbgmVHzFr6uALzmxnUZ6h7+Idb1lT4pv7wPe/yI+c30jFnJZN/6FAZkc4PAqtaMbgq+VqeAjlUSCPoP5Urx6ah1AoPWl/MPNlZDriSLsFexmRiYsKY4mgmcGAYY6RlI0sx9MRCfey+dAweciGKPJGWgmpsY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When MADV_COLLAPSE is called on file-backed mappings (e.g., executable
text sections), the pages may still be dirty from recent writes and
cause collapse to fail with -EINVAL. This is particularly problematic
for freshly copied executables on filesystems, where page cache folios
remain dirty until background writeback completes.

The current code in collapse_file() triggers async writeback via
filemap_flush() and expects khugepaged to revisit the page later.
However, MADV_COLLAPSE is a synchronous operation where userspace
expects immediate results.

Perform synchronous writeback in madvise_collapse() before attempting
collapse to avoid failing on first attempt.

Reported-by: Branden Moore <Branden.Moore@amd.com>
Closes: https://lore.kernel.org/all/4e26fe5e-7374-467c-a333-9dd48f85d7cc@amd.com
Fixes: 34488399fa08 ("mm/madvise: add file and shmem support to MADV_COLLAPSE")
Suggested-by: David Hildenbrand <david@kernel.org>
Signed-off-by: Shivank Garg <shivankg@amd.com>
---
 mm/khugepaged.c | 26 ++++++++++++++++++++++++++
 1 file changed, 26 insertions(+)

diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index 97d1b2824386..066a332c76ad 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -22,6 +22,7 @@
 #include <linux/dax.h>
 #include <linux/ksm.h>
 #include <linux/pgalloc.h>
+#include <linux/backing-dev.h>
 
 #include <asm/tlb.h>
 #include "internal.h"
@@ -2784,6 +2785,31 @@ int madvise_collapse(struct vm_area_struct *vma, unsigned long start,
 	hstart = (start + ~HPAGE_PMD_MASK) & HPAGE_PMD_MASK;
 	hend = end & HPAGE_PMD_MASK;
 
+	/*
+	 * For file-backed VMAs, perform synchronous writeback to ensure
+	 * dirty folios are flushed before attempting collapse. This avoids
+	 * failing on the first attempt when freshly-written executable text
+	 * is still dirty in the page cache.
+	 */
+	if (!vma_is_anonymous(vma) && vma->vm_file) {
+		struct address_space *mapping = vma->vm_file->f_mapping;
+
+		if (mapping_can_writeback(mapping)) {
+			pgoff_t pgoff_start = linear_page_index(vma, hstart);
+			pgoff_t pgoff_end = linear_page_index(vma, hend);
+			loff_t lstart = (loff_t)pgoff_start << PAGE_SHIFT;
+			loff_t lend = ((loff_t)pgoff_end << PAGE_SHIFT) - 1;
+
+			mmap_read_unlock(mm);
+			mmap_locked = false;
+
+			if (filemap_write_and_wait_range(mapping, lstart, lend)) {
+				last_fail = SCAN_FAIL;
+				goto out_maybelock;
+			}
+		}
+	}
+
 	for (addr = hstart; addr < hend; addr += HPAGE_PMD_SIZE) {
 		int result = SCAN_FAIL;
 
-- 
2.43.0


