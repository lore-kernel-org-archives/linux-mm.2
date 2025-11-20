Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DEF71CF8548
	for <linux-mm@archiver.kernel.org>; Thu, 20 Nov 2025 06:55:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4AEF36B002C; Thu, 20 Nov 2025 01:55:31 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 45F7A6B002D; Thu, 20 Nov 2025 01:55:31 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 328046B002E; Thu, 20 Nov 2025 01:55:31 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 1EB3C6B002C
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 01:55:31 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 7E9874EA2E
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 06:55:28 +0000 (UTC)
X-FDA: 84130074336.01.EAEC60E
Received: from BYAPR05CU005.outbound.protection.outlook.com (mail-westusazon11010002.outbound.protection.outlook.com [52.101.85.2])
	by imf22.hostedemail.com (Postfix) with ESMTP id 833C4C0006
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 06:55:25 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=xSxTk6hn;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf22.hostedemail.com: domain of shivankg@amd.com designates 52.101.85.2 as permitted sender) smtp.mailfrom=shivankg@amd.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763621725;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HjJa6yIlQxVhZ2jGFBnwxgXVflvyV46tpnOuVKCiGS8=;
	b=pKu9SRks9w6ru6ZwhhVavslrKzKdZ2P8v1WghTIel5/SWm5e5fxbl0cLnHos20L8ns/zU3
	cytjy3g5FET7X6KAkPwH/Vh60nRmx3f5QLdUnONYjGlrLviZvCYbVI+UekdHbZvwsIq76T
	XkCnVwC2sAaTv1rHkCqxs1d1SqAcxxo=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1763621725; a=rsa-sha256;
	cv=pass;
	b=fOQjdtXBioEnhLpwY0cHV22B8Rjos3vfJUlhpy4xaeKTME63fqOYrPTMP3dNe0sPqYXDIX
	5IULwWySoXIZRrCAPUdaKIdwyaTWaIyfHplpaEIJ9HbsHUq80IH7ojtnHc38BRlGRi6Lln
	Sg1aG91EGFQDuw3mJSx5pQRlvrjxhWk=
ARC-Authentication-Results: i=2;
	imf22.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=xSxTk6hn;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf22.hostedemail.com: domain of shivankg@amd.com designates 52.101.85.2 as permitted sender) smtp.mailfrom=shivankg@amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=IITUMXXZ1W3wo2i0LLElyzE71ZJlk9PZnRZWwVef3Z2jwnY8PL4Z0I0WTA26YW3JcM6PfvgIRS+FQF+SlTPLtLXFr4R4R4mJY44Qes1pwLd/lBYyAcKb7aajjC0v0UNViTKBatYWq5EfPnOhllSRFeDrdNbqNUFL56wCkkkse3nY3D2bdQxuukHnGAmf65xJElUIXO7MTlAUSAFHtC1YLxLNgjlmTZP/JbL8SUzD1hh41RiG1N1MOf5aw9hhRxdPpOm2VWgy6g3wUWzUzhz3AY1fHGPNWymWnR3Vcxs2MPOzcL9twHJTXfqD6/BinkwP4hlxUSn6AHMT4GL87NXYPQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HjJa6yIlQxVhZ2jGFBnwxgXVflvyV46tpnOuVKCiGS8=;
 b=SbEV6ieX+OCF86O9AXBEM+JLf+/enCT06ID5EpvnnBY6H5EMttYoNhHgD1HuYkz67w55SGct/MxV+40BfIa2WpfCKVJsUGLEqXeamhOzeAcyw0Wb4QOKNYl/9nHy/3K/CH5vupe/glm6lk4GgIZCYmSkXw1ofP2dtvjWw8X8EZE4I5bq8dzmIAx0tDO65YcTvNPWjP4pV6GtY1ZhYe/uJKcn1wQNg4ybyH/MhKVG9edRe7RI/yFyHA8NCwKiyApZMU9xbmgII3V+JXqTm73V+lPN3F3+LlTiQNa4aCsZ869GL7QhRMCvks7KGZfNqfSikV9t4x3irnJExlHrtmyhTQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=linux-foundation.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HjJa6yIlQxVhZ2jGFBnwxgXVflvyV46tpnOuVKCiGS8=;
 b=xSxTk6hnZT17W3hp6CTvJUJvmB7LTb9rnkb5pQF3Iu8FQSPFeHsodqgHyCAi1EsnBpg/UqdlLQeEGh3719Mq3U0U6e+szGxBpLNgQWB8mqJMm2g/Riz4ZhnhpGlPd96M1b09kT16HPoZ5q3F/dxK0WeIsug7x6PonuQlDtJrOT4=
Received: from BL6PEPF00013DFD.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:22e:400:0:1001:0:1d) by IA1PR12MB8192.namprd12.prod.outlook.com
 (2603:10b6:208:3f9::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9320.22; Thu, 20 Nov
 2025 06:55:21 +0000
Received: from BL6PEPF0001AB74.namprd02.prod.outlook.com
 (2a01:111:f403:f901::3) by BL6PEPF00013DFD.outlook.office365.com
 (2603:1036:903:4::4) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9343.10 via Frontend Transport; Thu,
 20 Nov 2025 06:55:21 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 BL6PEPF0001AB74.mail.protection.outlook.com (10.167.242.167) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9320.13 via Frontend Transport; Thu, 20 Nov 2025 06:55:21 +0000
Received: from kaveri.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Wed, 19 Nov
 2025 22:55:15 -0800
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
Subject: [PATCH V2 2/2] mm/khugepaged: map dirty/writeback pages failures to EAGAIN
Date: Thu, 20 Nov 2025 06:50:50 +0000
Message-ID: <20251120065043.41738-10-shivankg@amd.com>
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
X-MS-TrafficTypeDiagnostic: BL6PEPF0001AB74:EE_|IA1PR12MB8192:EE_
X-MS-Office365-Filtering-Correlation-Id: c1bffacd-d233-4b20-6f35-08de2801c5e1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|376014|7416014|36860700013|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?6xc3kw69oKGIlYjKBUY+vJ0S1h8c6GUdZofsfUMTDyYtY62MQzmjAvQ8LHyw?=
 =?us-ascii?Q?mBVqrSFNOLQS51ObIePLTOZQfXPYZOXnhZ6sd9IiGopz16/bFsmxD1jHT+j6?=
 =?us-ascii?Q?kgmJXT4VXGVrrGwFcc6xrr1VYWt9RYZps4nh5n3uo8tnE1/7ryN0V2YkSUGk?=
 =?us-ascii?Q?y+VfOHBZLoivsP1CN3xe0FX17ji5P6iFw8oiQ2pIIyOpEnmOgAnTRXZZPuZP?=
 =?us-ascii?Q?L9afT6u2X9eMACxI9dn1k1C6BJZJFG9c7/GhgiyDqMaHynUMQBpT1Q358vH9?=
 =?us-ascii?Q?5eUUutD75wmGkfoxdMUDE7P9azk68Vi3WWBEXQj28Kuw+KnGKbV6M6nzdYCt?=
 =?us-ascii?Q?QM2EwyOideiwPOvh03PtiohDc6UGyFk5OGECKcA0vwNwhPJyDt8BpNJ0tJzd?=
 =?us-ascii?Q?6JB1Kjp4bpJ/wEKAcFH3mGRSnuPwTb0J1ejruAhAsSTwiE7M5s8Q0OeBBlY2?=
 =?us-ascii?Q?b78ZtfXGBni7qUU8m7NHauwGhpRnfwjf9tgYw3irV9B6G1oUXpBkZpshSsjE?=
 =?us-ascii?Q?q6xLjjnm+BDgv7MiO0GOZHu9OqLKM6El6HCGTZqU2nwHxljdGao86vGu+CxM?=
 =?us-ascii?Q?O89ZPJUlW/mVMgHY9o9yI6i8Xw7fc4hSvqBR+3zJlIjmXFkpUcdHKIfDYz9X?=
 =?us-ascii?Q?IzRZPG8JH/JcY1wKetAtC9Gygxecn5LckLkMZiSK2afbCfGL36f0WPW+vNNN?=
 =?us-ascii?Q?EDVrGoV0hET/f4L24S1CHZgmqipEGe3q74b/+Li/mE38j68Q9yPJIirImKUf?=
 =?us-ascii?Q?H0L+c0BMukUm3ApbtfQ387sSc2WyFGwg6i+thj48OI571VPFIjYov8s3vQRJ?=
 =?us-ascii?Q?BNYZ62jMtvrkoLrrXck8Kf3a6ngnX3VCWg4lvKIlqUhvqL39jxIU8Q8aooW2?=
 =?us-ascii?Q?vVqacTDphbdEP1ahs5cvbI+2go8h2P70t34jMjCZDd2WxB8n8V9jkxeflLkp?=
 =?us-ascii?Q?6xxKq8V4xyerWUIqjGmsNNVBD3fnzZ2xXEj2rQjhOoOjRQsLkEKZoPvpBzN8?=
 =?us-ascii?Q?c2LR64Nu9ee9VkZs5ZBy3MV5L/+AbJrTT1KALD4rdtlqFrmR9tiivi0355Ve?=
 =?us-ascii?Q?EYYwpDxMIAFSv1KkYv0FlG4b1Lb/nsdUL5jPMXI6RWgeo3N5ffs1yJOo7359?=
 =?us-ascii?Q?zIDVnemxEXTHss0y16/Je+WJG94maKRPIKZQdnHfZLkXsRJxxkuGnlzxg4O8?=
 =?us-ascii?Q?uvtblaKeHtOjQBs0Z4ZQWX6XUz7D98rS1ZikLWQSZXAq05/cpsEAlGvSElAZ?=
 =?us-ascii?Q?i18An5agp9qY0FZ4kKw+bS78ko/VLynneZW3Fgfx62zsUmBpvNDMgjWpHOqD?=
 =?us-ascii?Q?Nx7Q83YIgxeASs+8CiTi/N4Y7uLGP+if/MiC5FFGDTR+PNF4celfNrgU+YVX?=
 =?us-ascii?Q?SzIcPBNNBeiNxrTLXo8Ul40Ek/DjujYbDARn5RE2gNbGZqSNXAtgKT9NxkaI?=
 =?us-ascii?Q?Rezsha1PDMTJ1KD2omTEVv/3by0jme/AOqPXDNNjQZXTPeoj95vkwhMubR1z?=
 =?us-ascii?Q?3GhkvpT51Gfcu2WY9DAZtSmeMGAN5GgwTm6kt1hKSy/gzg6K+9ctuNf3H2r1?=
 =?us-ascii?Q?m7fuFEHoYh7560CDjNw=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(376014)(7416014)(36860700013)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Nov 2025 06:55:21.2717
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c1bffacd-d233-4b20-6f35-08de2801c5e1
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL6PEPF0001AB74.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB8192
X-Stat-Signature: kzb1nhefmmnmpbu6u1sf489jxg7h3mej
X-Rspam-User: 
X-Rspamd-Queue-Id: 833C4C0006
X-Rspamd-Server: rspam10
X-HE-Tag: 1763621725-340567
X-HE-Meta: U2FsdGVkX18FVbmPp6Lh+Hf+jKUaUIOvE093o4d3M2EZvUEwsEHdu4Mlag3KDc0lp32mCwoZKp77TBibk93WjXXf5MxIwmSkBkFLeXgSyIH3k1aNq6xA7a45zuvlGcPzPE/jdSDJDbSoUuCUFS7p1383TxQM0Xb63HM7pP4TSE4L1dEm9woEOhWBKmVf+psTy66nFiFm8WhHsZDvuru/fR+5XHTZcDnmbGllnVLOMkuNp/iDXKGjRuE2+7brJueW++vWEzMa7UcIckaBNgPDfiAWrEY67pwzPpFh7doXINSiE7felR9PYXkuj3Bd4zxf0ZYv07LzXydxPgBs+g5vdxKTjp9UdhABmT/puqNKXOP3oVsoWzPXkkOk24/d6LOshFbaRheFvHis/jj5iYr9YjiebzXvYsDCwAIVQFWp8prH4zKuJ6X1BqFAKVDF/F6XSUVyltq5kslllJ/sGaWNOQxL2WmVkSJbukitIDOuJ5mkd1jcZK6Ep0dpbpDzmQ52VvVMVX2NI0LV1xEmLN6BhXUXc0tpzRwZCtZBCfk1quFHKA0nmWN17/swRVUmWyfWE8s5mUo5qQnorPcCHttdQFlhCoqg81T4D+Wf4F29UIkUPrcNHwdsUU+arlfWXzUxo3O4z07WsT7XM3BEB99+i6GPn/UOuvWDZCYy9X1JrtokqFLiNZvl2S7viLFFvllGUzsS+O6okdPi0OA+oyyrHHbQvZ07Q+KsAsI/5F2YwnIvvKDeGupzJM6Qm/aeEsUFoXz0sKwlQ4N+jYNnb2w1GV5R9KP+D4Sn8eTYIGMAtNLOymLPdce7An25ebP998u7j4eaa8KJmf1+LPKy7WDAhKUkdADCbV4LJn8704scAt8p2PZ3LsjJddwid/Ps+1BeyHVlg7WgSO4Pw13kg3F6lPyoycNcr5ybzwIE/kxoVROkfaQAUX9UgEmrCjqtNM7OglRxr9CLItcPzdA+aoj
 Z5KFM2YE
 KDfEPUKPTjJ0MTq21LgcExOnYpLR1EvftGNxoAQcqzTAE5NV9YSEq6Lxz3zMA06o1uYQNf7SMp8S304rWPSRno/00MG7IS10pb3kUSXQopDUQp5Ct3aYymCF49kxhV9ErcBf7uEjz+TvwhYhaAPwib6w/hB5owpquLDxPj5jLLYkhPIhQZxj6T8Q4K8D0Bzdk6GIJP14CJvGyTJYJrzcq6qfBwNpDkisyBHPbXigbzEmp3FuxzY1HE1y3KfznyMlHHKh68M1sGczCxujQrtiVqZsSL3lhQcTgSshhFi0D8wdbhqb5nLwAdB3bcT//OaTXGdTFhx+olsI31AvQVG61mAaFHh/oXeL4tobwKkBUEzhdHMkuwiNq12HoUoQ+B2vMLgA+n6fMcnkB1ax9Th4uFTcSSG1cuxUHYbFXcpfMtu2EqFBdSI3wquJAclE2m+Mdg/En/n8Rn4rBV8w=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When collapse_file encounters dirty or writeback pages in file-backed
mappings, it currently SCAN_FAIL which maps to -EINVAL. This is
misleading as EINVAL suggests invalid arguments, whereas dirty/writeback
pages represent transient conditions that may resolve on retry.

Introduce SCAN_PAGE_NOT_CLEAN to cover both dirty and writeback states,
mapping it to -EAGAIN. For MADV_COLLAPSE, this provides userspace with
a clear signal that retry may succeed after writeback completes, making
-EAGAIN semantically correct. For khugepaged, this is harmless as it
will naturally revisit the range during periodic scans after async
writeback completes.

Signed-off-by: Shivank Garg <shivankg@amd.com>
---
 include/trace/events/huge_memory.h | 3 ++-
 mm/khugepaged.c                    | 8 +++++---
 2 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/include/trace/events/huge_memory.h b/include/trace/events/huge_memory.h
index 4cde53b45a85..1caf24b951e1 100644
--- a/include/trace/events/huge_memory.h
+++ b/include/trace/events/huge_memory.h
@@ -37,7 +37,8 @@
 	EM( SCAN_PAGE_HAS_PRIVATE,	"page_has_private")		\
 	EM( SCAN_STORE_FAILED,		"store_failed")			\
 	EM( SCAN_COPY_MC,		"copy_poisoned_page")		\
-	EMe(SCAN_PAGE_FILLED,		"page_filled")
+	EM( SCAN_PAGE_FILLED,		"page_filled")			\
+	EMe(SCAN_PAGE_NOT_CLEAN,	"page_not_clean")
 
 #undef EM
 #undef EMe
diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index 066a332c76ad..282b413d17e8 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -59,6 +59,7 @@ enum scan_result {
 	SCAN_STORE_FAILED,
 	SCAN_COPY_MC,
 	SCAN_PAGE_FILLED,
+	SCAN_PAGE_NOT_CLEAN,
 };
 
 #define CREATE_TRACE_POINTS
@@ -1968,11 +1969,11 @@ static int collapse_file(struct mm_struct *mm, unsigned long addr,
 				 */
 				xas_unlock_irq(&xas);
 				filemap_flush(mapping);
-				result = SCAN_FAIL;
+				result = SCAN_PAGE_NOT_CLEAN;
 				goto xa_unlocked;
 			} else if (folio_test_writeback(folio)) {
 				xas_unlock_irq(&xas);
-				result = SCAN_FAIL;
+				result = SCAN_PAGE_NOT_CLEAN;
 				goto xa_unlocked;
 			} else if (folio_trylock(folio)) {
 				folio_get(folio);
@@ -2019,7 +2020,7 @@ static int collapse_file(struct mm_struct *mm, unsigned long addr,
 			 * folio is dirty because it hasn't been flushed
 			 * since first write.
 			 */
-			result = SCAN_FAIL;
+			result = SCAN_PAGE_NOT_CLEAN;
 			goto out_unlock;
 		}
 
@@ -2748,6 +2749,7 @@ static int madvise_collapse_errno(enum scan_result r)
 	case SCAN_PAGE_LRU:
 	case SCAN_DEL_PAGE_LRU:
 	case SCAN_PAGE_FILLED:
+	case SCAN_PAGE_NOT_CLEAN:
 		return -EAGAIN;
 	/*
 	 * Other: Trying again likely not to succeed / error intrinsic to
-- 
2.43.0


