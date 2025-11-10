Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 78AEECCFA13
	for <linux-mm@archiver.kernel.org>; Mon, 10 Nov 2025 11:33:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CD8E38E000B; Mon, 10 Nov 2025 06:33:49 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C89EB8E0002; Mon, 10 Nov 2025 06:33:49 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B9F828E000B; Mon, 10 Nov 2025 06:33:49 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 9FC0E8E0002
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 06:33:49 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 31E2D1A0D31
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 11:33:49 +0000 (UTC)
X-FDA: 84094487778.19.2BC3A47
Received: from CH1PR05CU001.outbound.protection.outlook.com (mail-northcentralusazon11010044.outbound.protection.outlook.com [52.101.193.44])
	by imf23.hostedemail.com (Postfix) with ESMTP id 68A54140005
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 11:33:46 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=SHLSqNUz;
	spf=pass (imf23.hostedemail.com: domain of shivankg@amd.com designates 52.101.193.44 as permitted sender) smtp.mailfrom=shivankg@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762774426;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=t5w/ANerXOQHdNYV2b4/3czO7wHX1+QlP5USmGpuqec=;
	b=36YHbn4HZ2VsuN1n4x0jsHA/bJKOwDInWUAI0wWECYwxAeyPxT397NxwJ5XFuo5f6kpIXj
	M1qlYZcGpXLe+au49fMAH5SwAb3/76czhXStP1/75QzQcXRV0sRidQDdUnSH7HBkA4jR4o
	uO1ldMAKelr23MszO+m/IN9+ZWmSkKE=
ARC-Authentication-Results: i=2;
	imf23.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=SHLSqNUz;
	spf=pass (imf23.hostedemail.com: domain of shivankg@amd.com designates 52.101.193.44 as permitted sender) smtp.mailfrom=shivankg@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1762774426; a=rsa-sha256;
	cv=pass;
	b=yeVlkVqiQQU6BLk/EWWDwa7z23X++hk+zNyEsDMPQpVcAIrzxv4lsCJwSdwpzQjiYSWtjO
	UtA9757rsSC2JSPO7NR18IN5IAvyVcuwDkc6qW45hIxD1zXFX30sfIqgb/4tJx6k0CKB+b
	McgVUJrxImR34v9LN7ELddf4onKUpGg=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=nZ+dzPa0fdcQfzlxPHKi0NzsBDRfdOSauRdV9MB8VEaPqkxbZQsLEG9BcRH3I0ouYNNUEhIClllnrCLF0xbeJNG1ccT9eMW7YyuJPHDkmm2FfZrZn5oJ39WfXzMczH2qnPAQm1euaN9rP+eDQOT4yMhwvP5AkuEKedCCQT2e9OETiMvZvrV3MhDijsPb2RIFArYvZ0qRilzY6IOHrY5t5DiOXt5Kx13M5PCaHPpAZsn8FdfrQaSEbZfuN3GyTXvasO6Va2CqMg3nZwipXu+3AQrXBxdHVxEP0oVRh3YxGE34FV8+7EXAfFMR5Kraf/VBiG23VX4Ab1CHsAWK9Bz3mA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=t5w/ANerXOQHdNYV2b4/3czO7wHX1+QlP5USmGpuqec=;
 b=XZPQxF8T8iedS0VM9RTsJyAvHUTl0L4jd4lKfiY7M7EOC+YIAdoA93jKS7ztbKXXPcwx2AIO87Tk6ReapnLpnMNusJ1KnrvQ2VNl+qd9HqSbLsCX0wWa+zj6jqsaInOnk0/km9AgN0+nJAq/BcPzlMph9di66wQ2dVMXxsrEsJZLDVsVpuvxPRMj4hAS8oCl5VnI59nFAlUi+W4NgK6O0ivkWXMtLcB1HbN9b78/52JaxgmvRnUfHw1/hSLZfUCLzqyKoxH8ZURpkewtvL96Sup44AzWMzpmkOTTayicL5GFmH0WMoR+syjsygsOfE3y7bMZxIxMD8+dEPMzadc5sg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=linux-foundation.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=t5w/ANerXOQHdNYV2b4/3czO7wHX1+QlP5USmGpuqec=;
 b=SHLSqNUzgliyhDjbJvMr7cPbGsjrY8g7ny+zl/WISDHL8Uo2Xl+uxLP0FhlxMSzRVsVCZoFQBzmbwKnUqhtxs32zuytbilBOt1IHzXWYaxD0ziGy1SMNqp3WJTYkt+oOiUITksPShtJqFbSHQqxNNjxtl1+W3N0tBac2kGz9pwk=
Received: from DS7PR05CA0077.namprd05.prod.outlook.com (2603:10b6:8:57::17) by
 CH1PR12MB9694.namprd12.prod.outlook.com (2603:10b6:610:2af::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9298.16; Mon, 10 Nov
 2025 11:33:41 +0000
Received: from DS1PEPF00017099.namprd05.prod.outlook.com
 (2603:10b6:8:57:cafe::28) by DS7PR05CA0077.outlook.office365.com
 (2603:10b6:8:57::17) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9320.15 via Frontend Transport; Mon,
 10 Nov 2025 11:33:41 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 DS1PEPF00017099.mail.protection.outlook.com (10.167.18.103) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9320.13 via Frontend Transport; Mon, 10 Nov 2025 11:33:41 +0000
Received: from kaveri.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Mon, 10 Nov
 2025 03:33:36 -0800
From: Shivank Garg <shivankg@amd.com>
To: Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand
	<david@redhat.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
CC: Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>,
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song
	<baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, Steven Rostedt
	<rostedt@goodmis.org>, Masami Hiramatsu <mhiramat@kernel.org>, "Mathieu
 Desnoyers" <mathieu.desnoyers@efficios.com>, Zach O'Keefe
	<zokeefe@google.com>, <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
	<linux-trace-kernel@vger.kernel.org>, <shivankg@amd.com>, Branden Moore
	<Branden.Moore@amd.com>
Subject: [PATCH 1/2] mm/khugepaged: do synchronous writeback for MADV_COLLAPSE
Date: Mon, 10 Nov 2025 11:32:53 +0000
Message-ID: <20251110113254.77822-1-shivankg@amd.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: satlexmb07.amd.com (10.181.42.216) To satlexmb07.amd.com
 (10.181.42.216)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS1PEPF00017099:EE_|CH1PR12MB9694:EE_
X-MS-Office365-Filtering-Correlation-Id: d5ab4f9c-8ce5-4f92-f5cb-08de204cfffc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|36860700013|1800799024|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?neWzWBjfL8GJbIKWGr1RmKTM5ELFFTwtsGF5MEkO7QKz/K6NA3UMllZ8zKXf?=
 =?us-ascii?Q?UZ64RXRkDUf9CCmKC6mpfTfkYFOzLn8sv3aJnb4+wcH5lk87SO5F1+8WVnMO?=
 =?us-ascii?Q?ZHLavHiKwYZl4NocDuSko9xrpbVF+s1BHpO+vlkDxilRAmgnSsPQqKa7Ix5o?=
 =?us-ascii?Q?H7ENYnA8bNPsH6cA47zfnnlgdzkRV0NAeS4qFw/9SRTFEOpUQxjQTAsyiqj4?=
 =?us-ascii?Q?LyJprAOkG36oEa8RC3IbBqwtxTps0X70hl98I+2aKOOlW97ayAAux3jItnQf?=
 =?us-ascii?Q?SOt8E4dVgwdoslfqYbtqxGAUa7Vlf2VP615RWK8WdVONhOcg/bGTE04R9tv8?=
 =?us-ascii?Q?FBbnwYd9rU9fWyxIE23M1BgS1I85XInHwaIyvF/pvkaVfQPCpps67h2m7T9O?=
 =?us-ascii?Q?+2tSkuI7xPkzWUr3MwW5nHP4Bjv++kpVyE0GWm1Db6pnNy98gpYgXhWAYjgc?=
 =?us-ascii?Q?KL/ZVRhGhf8dXSonBKOII/5eljXoON9JNzcAKhrT8VeNRGuyPGSr6iFvU0R3?=
 =?us-ascii?Q?KTo3U4Balxik4j0cgTawe/hq/T9yGnttGL7S5l23ZgPsbsX/tTLTQovpzmTy?=
 =?us-ascii?Q?hi9YBtDJ7KaHjijkgjctCEUoG47ZMM97/TM5IOgFv23QPNbcQ8fbxHDy0Pkf?=
 =?us-ascii?Q?B4QEtOhkarnKElicJ12Qh/rwW/GFMIZQAvgdp5tASQlBbkp4GuEqWmo8qBCt?=
 =?us-ascii?Q?virc+jCzmeKWhIPKIs0mQZM3oLs2Vbge8W3HWitRXTAbyliM+oa+TPVvDDX5?=
 =?us-ascii?Q?h0/AhRReojANLEFGc6f8DHfhXdaUNGmIoLc66Q1dGQhvIt+dKEj4cJwFvDF6?=
 =?us-ascii?Q?NgA+CoRQSSM6rReZJX+/lYZnotmG3+Tt3kh82WRN4RUjj+w9tayK28Q01u0W?=
 =?us-ascii?Q?BXvXeshe4KP7viIxeU9j/mXvtoWrt5SlSYC40uQAsuDTwIguug0jfjihsZVH?=
 =?us-ascii?Q?ku5Ko8PPWpEWXHQ1azxIw72Mk4c0foJ40WoeTGGLREVfpE0bNeiVFsCAZ0JM?=
 =?us-ascii?Q?sAnMeuLzVaLkaT/VRYI0BYt30LsOfphocBI92+LOrldtePi/PjS2fvmGnoAp?=
 =?us-ascii?Q?KP3qkzL7Ocfr46txs1HEujYpMJZdN778R4eaObbdNejzRNMV4MsJmeWhhaVf?=
 =?us-ascii?Q?e5kuoPAIi9ewGPSJW10zTrYcRdjiuEmpqU8jcq+edpweiP9VJcxuGieXDBLl?=
 =?us-ascii?Q?KXNJjb7oUaeDTuNTZC0XiehBd/yKzNO+qn07HcqNGjbOy02J/5O2OiL6e3i1?=
 =?us-ascii?Q?zvI65rfX5YgtRiekL4kxrGN/4q9mUKBomYdGUOCZBb/5ApRNVccf77ZHnxzs?=
 =?us-ascii?Q?qb5pGilWZmR12vtg0KvueWdzxfn0SPyjUYmhMfkkcA7MYjn7WBmYrhGq9YVg?=
 =?us-ascii?Q?XVCSDRAj8gCVu36UK3GYKMG/Yz+drONbXpVJKvwusGI7zje+5AOnbKRtWnZC?=
 =?us-ascii?Q?yTArrugp8WKsZT1P/8VwkAWvjlkQT2GfzzFo8Q4KND/CKVKW0dZNwq6eiGRT?=
 =?us-ascii?Q?/BN6fF0qlBqhANt1JtxmSSdoN+uoXFeaKBrZ8T+X6W6lPtQi+dBC8MkUjmxS?=
 =?us-ascii?Q?8OiknDySiHS/O2yrDNkY+NrebiylT9FwTysAf/Un?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(7416014)(36860700013)(1800799024)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Nov 2025 11:33:41.6773
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d5ab4f9c-8ce5-4f92-f5cb-08de204cfffc
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS1PEPF00017099.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH1PR12MB9694
X-Rspamd-Queue-Id: 68A54140005
X-Stat-Signature: ffqptak33iqgwnotg9tmju8enun6yge8
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1762774426-897138
X-HE-Meta: U2FsdGVkX193hb38jtX9tRqdvmCKxKXz1VdvoahyghFsuG+B9e/xWNlGPlu4HumMWUEGfJhh1/i8ohi06wDs7wp2h3y/FV1nqLIZVkFZOpcU08XvF+oEf+whnEIHZwS+fyvcuFyadu6ejVmL/UOmF+ndtiJqywFXoCDUcC+CGSSQkhwDHjANSnrSr8Kf2BL4lzdXWeo8VUbmbRlw2YOivEQwEXKvnus0MFHO5z4Jnx8xOAQPskxMHPy2hQ2xgHNl36T6WBJIAiOPUdS+0y/QfcIQXKMdHRXW82mp1h6zbmyU3waihV407qFHlsKT/8KZAsfISybKXG6yRO5DsyBia9PLV7QLfjnDyaWhQMVg5WqqgNpPHuIYNFx1ghGtmIUCKicIlIeAMEThS0Ahr1/6RP+iADQwP2N4DZFczKKVZjwuxUtLlCRljElpm87iUx1UpnDCdLjbegH28A1ZI8SJwJA9OVp86qE2VZ6TXBE0Keq1wpvDKzF8cVwOJrFudw/CkJldUJAKK0g6yOGx89pIrmQDNeWtvZfx3eJVdMyrayE6N0UEiVPBUVVuKvEYt9ph/AIZ7+D5FEvbtX2NnmsO5UOxwlndksIGZq7vqSvLrYE0J85CdH7cBYBCJXrR4Xzn5CaRYcMdsCp6JVO+xQQtnZbq4Zq/jQuTWzZU9WjULjhjRey/Zqaexm9hBCGn7xcKjyVu1lg4+Glje0sgZCBg8CHlmwL1Vv5hb1gyLG9173W8bNRoYYTiYOc5oZPJVzHRu3njJqCNcOPdHAwihmoiN1E5/gcA7FhGzi1g3j6HEUVK/y5OX0OsgcGJDHhuVIwzQBM/kLja3WKNxvwHCOhn2iYDWa++Old9Cl0NXTa1O6l0X2SoPKPoxtb8n9C77YV8IhvFKstIXX4g2PwA4Sazs0dHP/Yq8IEgB4+lh+YjGKkUx+ec69lOJbA1FISt+oAda+LFZ71GrV7VhCfvOtc
 a3F9/zFn
 Ot75B7Q4/IpnbIm9dGue3xhOQtx8oaDadx3TZzgq5zIzD9maLz9ozkvUo9n5iMUQLs21+bryvkObM2JktusbGgj7NTrdSsm12pDN8+htHn3yaTc01HYMI80PrL8jqDweKxL3/Q0txDwGYfj7fp05Jn1ydsjxYmvCF2A6MtJn1ci0wmo0nIB1CpIEutg800I2YNrtBjcsxQ3/Ad4ndrJR5sKnhQpbgWYXhpLE/7NVEDLxE+y2K2Q5Bj0ZeqSz9M4/LJTk/HtFGxTfftgq92Jkih74mWuuRorPqLbE9LCGjJFcfJw6fySA+Vd02/gEGhcUH4fkjDRD1G2o32u5YGZ78FnA8wTxXIvwCMHfbnjRAj+9eJJyaaiPhIFGD85lgLxXM4YMjw6v5R55/u+UOGlEZRPpABhGP+D38PmMJI1c2O3bJKPa1go+CYc/0NiCwbBaunP2sH4kFhTEFeyap1YM/fjbcELYhc3upgonMZv6rTkn5S3nX0qCU7AU2cgo08o0e41QYTG+aC+AIKejp4upP8qJKx4BtBpdc+P2IRx16LCGIqsH6zyvHTaSV6RbEgSZOKlZ0eihpHzUwm2I=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When MADV_COLLAPSE is called on file-backed mappings (e.g., executable
text sections), the pages may still be dirty from recent writes. The
current code triggers an async flush via filemap_flush() and returns
SCAN_FAIL, requiring userspace to retry the operation.

This is problematic for userspace that wants to collapse text pages into
THPs to reduce ITLB pressure. The first madvise() call always fails with
EINVAL, and only subsequent calls succeed after writeback completes.

For direct MADV_COLLAPSE calls (!cc->is_khugepaged), perform a synchronous
writeback using filemap_write_and_wait_range() before scanning the folios.
This ensures that folios are clean on the first attempt.

Reported-by: Branden Moore <Branden.Moore@amd.com>
Closes: https://lore.kernel.org/all/4e26fe5e-7374-467c-a333-9dd48f85d7cc@amd.com
Fixes: 34488399fa08 ("mm/madvise: add file and shmem support to MADV_COLLAPSE")
Suggested-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Shivank Garg <shivankg@amd.com>
---
Applies cleanly on:
6.18-rc5
mm-stable:e9a6fb0bc


 mm/khugepaged.c | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index abe54f0043c7..d08ed6eb9ce1 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -21,6 +21,7 @@
 #include <linux/shmem_fs.h>
 #include <linux/dax.h>
 #include <linux/ksm.h>
+#include <linux/backing-dev.h>
 
 #include <asm/tlb.h>
 #include <asm/pgalloc.h>
@@ -1845,6 +1846,7 @@ static int collapse_file(struct mm_struct *mm, unsigned long addr,
 	struct page *dst;
 	struct folio *folio, *tmp, *new_folio;
 	pgoff_t index = 0, end = start + HPAGE_PMD_NR;
+	loff_t range_start, range_end;
 	LIST_HEAD(pagelist);
 	XA_STATE_ORDER(xas, &mapping->i_pages, start, HPAGE_PMD_ORDER);
 	int nr_none = 0, result = SCAN_SUCCEED;
@@ -1853,6 +1855,21 @@ static int collapse_file(struct mm_struct *mm, unsigned long addr,
 	VM_BUG_ON(!IS_ENABLED(CONFIG_READ_ONLY_THP_FOR_FS) && !is_shmem);
 	VM_BUG_ON(start & (HPAGE_PMD_NR - 1));
 
+	/*
+	 * For MADV_COLLAPSE on regular files, do a synchronous writeback
+	 * to ensure dirty folios are flushed before we attempt collapse.
+	 * This is a best-effort approach to avoid failing on the first
+	 * attempt when freshly-written executable text is still dirty.
+	 */
+	if (!is_shmem && cc && !cc->is_khugepaged && mapping_can_writeback(mapping)) {
+		range_start = (loff_t)start << PAGE_SHIFT;
+		range_end = ((loff_t)end << PAGE_SHIFT) - 1;
+		if (filemap_write_and_wait_range(mapping, range_start, range_end)) {
+			result = SCAN_FAIL;
+			goto out;
+		}
+	}
+
 	result = alloc_charge_folio(&new_folio, mm, cc);
 	if (result != SCAN_SUCCEED)
 		goto out;

base-commit: e9a6fb0bcdd7609be6969112f3fbfcce3b1d4a7c
-- 
2.43.0


