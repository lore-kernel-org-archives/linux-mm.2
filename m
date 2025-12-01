Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BA472D116F1
	for <linux-mm@archiver.kernel.org>; Mon,  1 Dec 2025 19:03:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 29E096B002C; Mon,  1 Dec 2025 14:03:19 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 24EA46B0032; Mon,  1 Dec 2025 14:03:19 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 116656B0062; Mon,  1 Dec 2025 14:03:19 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id EDD496B002C
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 14:03:18 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 95CD413111D
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 19:03:18 +0000 (UTC)
X-FDA: 84171825276.22.1F44FB1
Received: from PH7PR06CU001.outbound.protection.outlook.com (mail-westus3azon11010015.outbound.protection.outlook.com [52.101.201.15])
	by imf10.hostedemail.com (Postfix) with ESMTP id 78B86C002B
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 19:03:15 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=vzW+1ZLP;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=quarantine) header.from=amd.com;
	spf=pass (imf10.hostedemail.com: domain of shivankg@amd.com designates 52.101.201.15 as permitted sender) smtp.mailfrom=shivankg@amd.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764615795;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4Xc60E67ZdEkD9mQRSvfZoMAEVE+ywsv1Nrw3TWi6dM=;
	b=Wk781i+7L6C29nvN/fEVADAcVFXjCQvuLwZ8hX1KPa4MKYs4NYbmFu79TATAaF+GO1DYKN
	k/a1t58o2NRuaFqEPGUCDvMmQGRoGpqhwG42fs8JE8BYhqixsYvVZj1dKfHO43J5srhI9X
	GCiWoWGy91Kgn3lPwUdsKc9c6rbfbEo=
ARC-Authentication-Results: i=2;
	imf10.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=vzW+1ZLP;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=quarantine) header.from=amd.com;
	spf=pass (imf10.hostedemail.com: domain of shivankg@amd.com designates 52.101.201.15 as permitted sender) smtp.mailfrom=shivankg@amd.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1764615795; a=rsa-sha256;
	cv=pass;
	b=sz01OPHIuDtb4udIXFtMCIEmKaJY+8Mj4lVVYtjBHQwcSGZ97rAYVcgy2vFAQUV30WRW2R
	plmOBg4MS8cZAq4tNUXnFKmUl8aZ4yq9qGRhddhwjVMyRc3gcC6DyKDH+UQf6kaK3Ur93D
	zTXl6VCGFf9rRiqi73dN5AfofJsJ7MA=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=CbbAfTgZKKAcgtBwMVa8698vMBZur+HRh2pilsMqFZuxAFOTmcBGuMoZZFEqr4RRYsZ9hzVB/m4XHawpjdyiZ1TYh0LzlPqKYvy5Y/ScyaDjm6Xl/IkNwgSH1cFWzvqSiN0tGskhWotooxdq8bG44/qZdxj1KJwTV2Nh2E/Wn5k1JcQy6A7YKS9zge4GU98i0Ahlnyvd0WiZmYrA1MfdXy3x6zru7VyPiqXKsMXsx0+Jxs0GQJIRbqHDOYC8y3axPzXG0tla51PNHMWbBv7qUZKG4K0lNo7csov9YADoae3pMhixOPeHwB8Gic6tPQ4KD+CVWNlmPn902X5oEhqpEg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4Xc60E67ZdEkD9mQRSvfZoMAEVE+ywsv1Nrw3TWi6dM=;
 b=ha8us9rCICD+3kVdafOqD6xcu1JrDuM/YarrOlI8GjmOIfTlR58pYI+siAsMo9J/dw7y5bglrBZeHnrwtHCgQIWRnDSPd9olKcHvK+GoslXTzvHbemjkSnOtJM1dSwkN+kbIG6xjgAcrgVinEEA/ZsDOBUqjOfG0XMAOOy/725rQCDEnX3PmFNvWUM0oZQKSGf15hmWXrrGJRHfo7PUM+Q2c8347H5R1pR+ZiNogF7sv8f2e/YNsgnsCO1DPurv0THRebJv3nfUFDCj2wU10HYO/CCStaYhs37Vi9AG1gk9Q6wdwA+TdinTF5m/CKRLLzAWCl4Ajc3eyPuTp7QtDCg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=linux-foundation.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4Xc60E67ZdEkD9mQRSvfZoMAEVE+ywsv1Nrw3TWi6dM=;
 b=vzW+1ZLPw6pB4c1E4opdeZu0XYqsyXn6E9wOXymZAOTHFqrtmxEoGv/oFjZbU91xtyZWOnNMEJxYup6dzDbAHbClKxeKpODo7C4SaeXNXcyGKFfmT5FZJriPND2Rk7fuZ9NZ4sxDa0g8PMCGJ977arh1xa5E2V8X7o/KLa0LC7U=
Received: from DS7PR05CA0089.namprd05.prod.outlook.com (2603:10b6:8:56::6) by
 LV3PR12MB9267.namprd12.prod.outlook.com (2603:10b6:408:211::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9366.17; Mon, 1 Dec 2025 19:02:58 +0000
Received: from DS2PEPF0000343B.namprd02.prod.outlook.com
 (2603:10b6:8:56:cafe::a3) by DS7PR05CA0089.outlook.office365.com
 (2603:10b6:8:56::6) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9388.9 via Frontend Transport; Mon, 1
 Dec 2025 19:02:55 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 DS2PEPF0000343B.mail.protection.outlook.com (10.167.18.38) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9388.8 via Frontend Transport; Mon, 1 Dec 2025 19:02:58 +0000
Received: from kaveri.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Mon, 1 Dec
 2025 13:02:52 -0600
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
	<linux-trace-kernel@vger.kernel.org>, <shivankg@amd.com>, Branden Moore
	<Branden.Moore@amd.com>
Subject: [PATCH V3 1/2] mm/khugepaged: map dirty/writeback pages failures to EAGAIN
Date: Mon, 1 Dec 2025 18:56:09 +0000
Message-ID: <20251201185604.210634-8-shivankg@amd.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20251201185604.210634-6-shivankg@amd.com>
References: <20251201185604.210634-6-shivankg@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: satlexmb08.amd.com (10.181.42.217) To satlexmb07.amd.com
 (10.181.42.216)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS2PEPF0000343B:EE_|LV3PR12MB9267:EE_
X-MS-Office365-Filtering-Correlation-Id: c14d6583-1fbc-499c-53f1-08de310c3e36
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|82310400026|7416014|36860700013|1800799024|13003099007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?ctxtdUA609rcE/ENAHjARG7zeejxfhcL29IWHJpbPM/72efbF7wVa4uY0esa?=
 =?us-ascii?Q?DyZU2mNDc8CdH+3jG8PK3F5qPNRb0wMAxuKC4wKz560barDbF2GIQQDn0NvN?=
 =?us-ascii?Q?DpOmTe5neypQXnV6v4FOfsoY4Yh6KeoY0HCx+4WTbR3STf4dewgemT1+W2bV?=
 =?us-ascii?Q?p+y+UJigB5PhNnX8Zp1hYCFuD7MNOfhpjGD5Znr/eg+X193g6LyCFokKpKus?=
 =?us-ascii?Q?cDmKG/yVxwps/z1e3Lwj2FXigqHd5hbqu4NncF0N11jimCx2lVUc+3+aDMNe?=
 =?us-ascii?Q?OkGAUG6Sxhil9Hvi/aHT7wK/GMLfjGmduJL4u5jC1AdlrhRo0ibZJRGfgGWx?=
 =?us-ascii?Q?vdFUkOd8oBvOoVd3KUJRUQd61L7KZsGbpD0f4thk6+DDVz3EMMEZhfU6BJb8?=
 =?us-ascii?Q?xI/fiD2Ic55JXaH/zMB7tZo1rQFRVxYDGEkuN8C53feL71rov46po1e+GmW4?=
 =?us-ascii?Q?pDPTPuReLIfDm+HL5WCekU9KPFa94ylKKzy6aejLUDL2dyHtabnCt6iAIPt8?=
 =?us-ascii?Q?eno8R/DWoMWJTNJeBZWK+yis5vMsEmbiphmHX32p0VqIqmP+Jybd8HJNhQoZ?=
 =?us-ascii?Q?ZqRLiwYDyUwqEZdw7QV+MA8iKize2sXjryxuRsId9ivKRFzr7N/YVWx2xC2f?=
 =?us-ascii?Q?7CU4OJMwNRqYshKvItW83M644cyZHfwAybm/KaG8tnBb4ZPjPP8A9GlK5P08?=
 =?us-ascii?Q?lzm0OBA7vkLJ8NR+qggmJyV0I9IEujDiatQhggLSj6Ma7ndM7gbnVZ6ftOLo?=
 =?us-ascii?Q?HZeql40MmnQ7W9M9aG+1VxDZ61qZAa+4Mxm9JSmRwNcdWxKHoccZ+AixuPmy?=
 =?us-ascii?Q?w5XZhS0o8ndpYcTcNw+nXLHJEPvi/pUipna/Hh1uKnaStH5g2zk7C+X6312z?=
 =?us-ascii?Q?r0+1AF9K2TU+y5YHl55iLjRpQEhj8nj7rOXa32ZpQRzIyXm36yK5JWOdlkI0?=
 =?us-ascii?Q?pKwz1HyycgcUGcjAomIg5NN9o4qZdE4ALslofdxCWWeOCTIThum+C/LNGzaZ?=
 =?us-ascii?Q?OV0yUF3M6LCh7nT3I/fhVFaCoNqYKG63+dvE8GP8ET13xpuDBasjgw9vz8DM?=
 =?us-ascii?Q?yZgKp9j8gTciwhoeYV0U6HCmQrFbX3HeUxMWpne+kAVsIfRPA6Pu2eCifIY5?=
 =?us-ascii?Q?A7qwNasWU3TMOkeYvw05iDo1GrrDVsCtmgAMTxYct1/aR4WwdRKkDJAmjcuN?=
 =?us-ascii?Q?G9qDghktCFNqFjBo/cP71BPOH/gbMsVIWU7B7Hd0lwqLyy+T+BTWSLeAAl6O?=
 =?us-ascii?Q?Tc1LQiruvi+xxfC/OYSg3GxmFu5+RVQuzqEUFIiPKvHGyz/fP23cxsJmKx3u?=
 =?us-ascii?Q?vvno2ZPKEQlYBTXTOHj7Jl9oVu1XfIk0hrDiDBHUjIFGcO6lTLiw6oGFe7us?=
 =?us-ascii?Q?zmZsP74RJk/uRLfu2j/mnMZeF1E5fZyxY3fAjoYxskpF6bWL6R6aiU37zkGV?=
 =?us-ascii?Q?1ge9avjZo1twz21+UT5a23jCF/EKWnrlRYlohUSVLx/he14erscf+Wm/VdRn?=
 =?us-ascii?Q?w1ULGRQ7ICPFgtKW3ajOYM3/HfQRDDWPGFul?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(82310400026)(7416014)(36860700013)(1800799024)(13003099007);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Dec 2025 19:02:58.5487
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c14d6583-1fbc-499c-53f1-08de310c3e36
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS2PEPF0000343B.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR12MB9267
X-Rspam-User: 
X-Rspamd-Queue-Id: 78B86C002B
X-Rspamd-Server: rspam11
X-Stat-Signature: mxs41s6bffwcz48jw9oge51q6674449w
X-HE-Tag: 1764615795-417028
X-HE-Meta: U2FsdGVkX1/QR7OpTxJheP+PLX9asF5ffXPrSikGwjFApg+sWxhDUM4B4P7mEgnTqLtc6J4jctfkAHOknCmCv9xYGBYGtLRdUVwEPZGRY3G7mj57qobyJ/SR4BNWkKhcIberFziCVH86DWk4cCv7jYdez9cyeJTXOIMuRghhPOLc1/HJbDd/Ok0g9fOTKxmBmNcqbfAkkXiDZir4sHwi2tFpzaj1jsc3bM7SjEbH/DwKXCfHH+M565XeVzYvTnSVLZj7Vz9prv+3EFPYoSIls6keSu0v7XE3U4zBLysvAwlBFpbi30Ksov+xlNWVxj5SVNak34AWXeAoNYCuARuNVM97r/C4B2/7cA6r5oHFvQB4sX4BwL+WIOp9OfqyDgxFMsqDpvN56yCGVuiFWaNl2lbE662CWX4B5yziTctAzKf6SvVvA6V6QcCRlEtyfv+iUDh0bX+IEMq3WiMxpd52n1mjdF44ZRJA4kV1bpIK7zQCI3VGEac9ZKwE4qfkLkcAUXg+l5O+LfgsSksFKNHltI+kh6YOL5x9rGTfZaMz48DsQPADfgFecP7/CQW+d+36aR9golMs16IBqSRJ7k+Nf5cYsYl4uNvQszmiF3AWuPpdrP24v7c8q+f/FeMRhEXgl1UOemnDE9sEt5MOgkBjL5Zva1uU9V7pTeWlBYAA0IPnu0zPMehzZNy5XqYIib5cDAqaNjk0kLkpbdB2RdRw8fgzn/1v5TmQVng6AUYwn0asErzN/BsOJr/Pw+s0e01ucelSH7Kkcu5itxfetftEPbOqELF3kfui6HbHFYW5ORCBboL0xKfQ9vphkXmCLHKUMYIgbbG3/hvJLkS2RvAbT/1JrxnyFrWW13lTXYy9nEHwmT75H6vq9s7q+U5BhFM4zjucSJovv/e/xNDtn++AqOs/gyP1P8c3vk3VCXKH90E26pKtASdD49wO3QAJH2odubggVwZPBiungBqCAvl
 A9MdZwZz
 2TUQY5oi+oqxVfHKmP/TUpMRBo1zdKPbgPUVm0s0I0CYCwAd15Dt0Dcd774cD5erJwqjbnEuWCd1Z9vdqr7VKEqosuubvptIlFSah161PIpXZvIwd2mjx3WcCSiMy/F2wl9pX43WZ5DJx8jrsLaRK05eCq3k5353wOkTDGj5FefhLvASuuuW/66pK7h9PQd7azBk3yblriRYRFRkmCeW9TCPZZihnWuUDU9JlS+3LIGD41AzMHSVNe0EPbGZ5qo6mRpFD9DONOYCoQLMQIel9KBJ4b1pYZlLRCCRfICUpA3t6ybcr1HyboyNm1478gcthdQtaLV+p0kNvGr83zqEMp6dkVRVbCt8Hr5Li5ebsCHY5o8hzQQZDdEydrozsCQKm939Ue9UbiGSCyTE2Z7jfxs/vJwThy+ZE8o/27SJ1Z2GGo2+6MoNC8MztMnaeCUukELPtu0urmodZnKeyORue7a3vGStA+70y9GnKWa7bENg19R88nh31Fddp/Q==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When collapse_file encounters dirty or writeback pages in file-backed
mappings, it currently returns SCAN_FAIL which maps to -EINVAL. This is
misleading as EINVAL suggests invalid arguments, whereas dirty/writeback
pages represent transient conditions that may resolve on retry.

Introduce SCAN_PAGE_DIRTY_OR_WRITEBACK to cover both dirty and writeback
states, mapping it to -EAGAIN. For MADV_COLLAPSE, this provides userspace
with a clear signal that retry may succeed after writeback completes.
For khugepaged, this is harmless as it will naturally revisit the range
during periodic scans after async writeback completes.

Reported-by: Branden Moore <Branden.Moore@amd.com>
Closes: https://lore.kernel.org/all/4e26fe5e-7374-467c-a333-9dd48f85d7cc@amd.com
Fixes: 34488399fa08 ("mm/madvise: add file and shmem support to MADV_COLLAPSE")
Reviewed-by: Dev Jain <dev.jain@arm.com>
Reviewed-by: Lance Yang <lance.yang@linux.dev>
Signed-off-by: Shivank Garg <shivankg@amd.com>
---
 include/trace/events/huge_memory.h | 3 ++-
 mm/khugepaged.c                    | 8 +++++---
 2 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/include/trace/events/huge_memory.h b/include/trace/events/huge_memory.h
index 4cde53b45a85..4e41bff31888 100644
--- a/include/trace/events/huge_memory.h
+++ b/include/trace/events/huge_memory.h
@@ -37,7 +37,8 @@
 	EM( SCAN_PAGE_HAS_PRIVATE,	"page_has_private")		\
 	EM( SCAN_STORE_FAILED,		"store_failed")			\
 	EM( SCAN_COPY_MC,		"copy_poisoned_page")		\
-	EMe(SCAN_PAGE_FILLED,		"page_filled")
+	EM( SCAN_PAGE_FILLED,		"page_filled")			\
+	EMe(SCAN_PAGE_DIRTY_OR_WRITEBACK, "page_dirty_or_writeback")
 
 #undef EM
 #undef EMe
diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index 97d1b2824386..219dfa2e523c 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -58,6 +58,7 @@ enum scan_result {
 	SCAN_STORE_FAILED,
 	SCAN_COPY_MC,
 	SCAN_PAGE_FILLED,
+	SCAN_PAGE_DIRTY_OR_WRITEBACK,
 };
 
 #define CREATE_TRACE_POINTS
@@ -1967,11 +1968,11 @@ static int collapse_file(struct mm_struct *mm, unsigned long addr,
 				 */
 				xas_unlock_irq(&xas);
 				filemap_flush(mapping);
-				result = SCAN_FAIL;
+				result = SCAN_PAGE_DIRTY_OR_WRITEBACK;
 				goto xa_unlocked;
 			} else if (folio_test_writeback(folio)) {
 				xas_unlock_irq(&xas);
-				result = SCAN_FAIL;
+				result = SCAN_PAGE_DIRTY_OR_WRITEBACK;
 				goto xa_unlocked;
 			} else if (folio_trylock(folio)) {
 				folio_get(folio);
@@ -2018,7 +2019,7 @@ static int collapse_file(struct mm_struct *mm, unsigned long addr,
 			 * folio is dirty because it hasn't been flushed
 			 * since first write.
 			 */
-			result = SCAN_FAIL;
+			result = SCAN_PAGE_DIRTY_OR_WRITEBACK;
 			goto out_unlock;
 		}
 
@@ -2747,6 +2748,7 @@ static int madvise_collapse_errno(enum scan_result r)
 	case SCAN_PAGE_LRU:
 	case SCAN_DEL_PAGE_LRU:
 	case SCAN_PAGE_FILLED:
+	case SCAN_PAGE_DIRTY_OR_WRITEBACK:
 		return -EAGAIN;
 	/*
 	 * Other: Trying again likely not to succeed / error intrinsic to
-- 
2.43.0


