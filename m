Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1BEB8606A324
	for <linux-mm@archiver.kernel.org>; Thu, 19 Nov 2026 07:12:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=amd.com header.i=@amd.com header.a=rsa-sha256 header.s=selector1 header.b=dbAOzBsD
Received: by kanga.kvack.org (Postfix)
	id 23F816B05B5; Thu, 19 Nov 2026 02:12:26 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1EFCA6B05B8; Thu, 19 Nov 2026 02:12:26 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0DF586B05B9; Thu, 19 Nov 2026 02:12:26 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id D38B16B05B5
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 02:12:25 -0500 (EST)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 278EBC0959
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 07:12:25 +0000 (UTC)
X-FDA: 85451000250.06.7E8DEA1
Received: from CO1PR03CU002.outbound.protection.outlook.com (mail-westus2azon11010011.outbound.protection.outlook.com [52.101.46.11])
	by imf27.hostedemail.com (Postfix) with ESMTP id CA43A40006
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 07:12:21 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=dbAOzBsD;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	spf=pass (imf27.hostedemail.com: domain of shivankg@amd.com designates 52.101.46.11 as permitted sender) smtp.mailfrom=shivankg@amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795072342;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Mv64KZunL96lzq10Z/F9fA/mAbkXKDZvahBkWukXgJo=;
	b=eL8g8fYkxu+dyfwdYvyzm4fjo+4ez2Als8am61PYZCEHoz6sNxFTLDPlKbVL3YW8IAqMD+
	po6J/8j0IGPRfsbALQ1otDM31pY2aTwIvyuvN7KLQbMZZlfGCKDBryaDGrDInsYvyGvqJ7
	UqZvZUyVjcXXMXynh9OVlGkgcEmz1NM=
ARC-Authentication-Results: i=2;
	imf27.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=dbAOzBsD;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	spf=pass (imf27.hostedemail.com: domain of shivankg@amd.com designates 52.101.46.11 as permitted sender) smtp.mailfrom=shivankg@amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1795072342;
	b=CUfFZRXwK0DNWi/eHpzJmWSZZDw+E2im2BX20UHKVavc29HTQTIoQCgXKBFXNFdL93VWAV
	Pj96kw+vORzOBOvDCXv5nlVZ3bktMfMXmVvscoKgWmX0snSWREKKI+TmVmXiCKH3lcu1LM
	SW4sMz4S+KsosskZtpVC2VUDKYY+cjw=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=fw60/vxLG+bZ8NWyyWsK0lud1AcW7b8rkMHTEdGzTZCm02GbjdLvZKN/MhqVOYhBZYzbjdamciTHlOA9LH9oe4dUETs7pWT5ZZiIi54HghSATKgH7VYHbUrCSym3sA0VHQKNgFwrmWOndlS8ref4kcSH2lc3GyGPwtYHkqE6BmkWvNzMS3YGKRHmhD6/14QA9e4b80/8x8EwaejhWC0i1lMgQcKgPS7Z7VJfVrFjX+Doz/lGfhS5No8g62ZSJKcuexHGG8jojaOaVbdhNz0eynUa40rbcaPfEo9jfCPHZcl02+QaYMUpGQ0WxriGz+3PVGvT+hjHV7ibycVAQ8sEeg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Mv64KZunL96lzq10Z/F9fA/mAbkXKDZvahBkWukXgJo=;
 b=mLmiB9psFz7NT3XAWqSiPD445+jXt6isuytZFEZgnaWo2Uhoyl5zHEJ9/lS+QThai2yP+SEn8zq1K7jUOr2QrdScN3rRyzrhW+yjAInyTX6/ucIrQhGRaZwSlwLnXR3+D483/wgOOZHqhnGtbej2i+WUrjrv7V+NqQoUnUB/vCNqx3hQXREMO4Maplo4IZJN5GCZm1Z5gV9Td3pj7hignMFL3IxWQXwmOaqhj6Mlz1zGJx2KXybTwudlSwZNYqC0FEFJHgeuM4hyTBR3x6BoCEIzQedTEhWtvnJ2d7xety7LyjmfE2PoKsz2J6Ldr1GUpelolDmzCqzp4iJ7ZUq5jg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=google.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Mv64KZunL96lzq10Z/F9fA/mAbkXKDZvahBkWukXgJo=;
 b=dbAOzBsDXpRZ4LOF/b2LY5FOGnyt0eEgbFOM25BtD9Mc3ksHQEUEiFu4QUvq/plpsaYDnExr8raBpDFcNiFfZrNAjo+bTfvvWCHiskGYcB1WI/HqZuRaoqh4zOuADb+Rjgl02i3R33P79HzcBoK6yZb4Qpz3w0+aEBFhJgZi7yg=
Received: from PH8P221CA0013.NAMP221.PROD.OUTLOOK.COM (2603:10b6:510:2d8::24)
 by DS0PR12MB8785.namprd12.prod.outlook.com (2603:10b6:8:14c::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.639.10; Thu, 19 Nov
 2026 07:12:15 +0000
Received: from SJ5PEPF000001EB.namprd05.prod.outlook.com
 (2603:10b6:510:2d8:cafe::5c) by PH8P221CA0013.outlook.office365.com
 (2603:10b6:510:2d8::24) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.615.10 via Frontend Transport; Thu,
 19 Nov 2026 07:12:15 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 165.204.84.17) smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 SJ5PEPF000001EB.mail.protection.outlook.com (10.167.242.199) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.615.4 via Frontend Transport; Thu, 19 Nov 2026 07:12:15 +0000
Received: from [127.0.1.1] (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.57; Thu, 19 Nov
 2026 01:12:09 -0600
From: Shivank Garg <shivankg@amd.com>
Date: Thu, 19 Nov 2026 07:11:56 +0000
Subject: [PATCH v2 1/8] mm/migrate: extract folio unmap phase
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-ID: <20261119-migrate-refactor-shivank-v2-1-f4535bd0bc52@amd.com>
References: <20261119-migrate-refactor-shivank-v2-0-f4535bd0bc52@amd.com>
In-Reply-To: <20261119-migrate-refactor-shivank-v2-0-f4535bd0bc52@amd.com>
To: Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand
	<david@kernel.org>, Zi Yan <ziy@nvidia.com>, Matthew Brost
	<matthew.brost@intel.com>, Joshua Hahn <joshua.hahnjy@gmail.com>, "Byungchul
 Park" <byungchul@sk.com>, Gregory Price <gourry@gourry.net>, Ying Huang
	<ying.huang@linux.alibaba.com>, Alistair Popple <apopple@nvidia.com>,
	"Lorenzo Stoakes" <ljs@kernel.org>, Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>, Yiannis Nikolakopoulos
	<yiannis@zptcorp.com>, "Bharata B Rao" <bharata@amd.com>, David Rientjes
	<rientjes@google.com>, Huan Nguyen <nhuhuan@google.com>, Baolin Wang
	<baolin.wang@linux.alibaba.com>, "Matthew Wilcox" <willy@infradead.org>, Hugh
 Dickins <hughd@google.com>, "Vlastimil Babka" <vbabka@kernel.org>
CC: <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>, Shivank Garg
	<shivankg@amd.com>
X-Mailer: b4 0.15-dev-47d62
X-Developer-Signature: v=1; a=ed25519-sha256; t=1795072323; l=6549;
 i=shivankg@amd.com; s=20260518; h=from:subject:message-id;
 bh=HUIObmJo7+++lyn2OQgP9ejFV4vyinab62efxNLXiL4=;
 b=glzkbprt2wsvR7GXZEq2pJKxAyUsg/8ReoPP5DgZH/5k2mBhY8k2ozXfQjOrY7pmPhkVHmCoV
 4NEgW9QzmcbD6k9TshHNQZlqV/VG70q8qrQ50/ooD3Q22yEWNP9czTu
X-Developer-Key: i=shivankg@amd.com; a=ed25519;
 pk=2l2QGTeXuGkZTtfmx0nPQU8iFZfjYmX/ymMojitevx4=
X-ClientProxiedBy: satlexmb08.amd.com (10.181.42.217) To satlexmb07.amd.com
 (10.181.42.216)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ5PEPF000001EB:EE_|DS0PR12MB8785:EE_
X-MS-Office365-Filtering-Correlation-Id: ef75916c-8815-4d7f-47b6-08df460c70cf
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|7416014|23010399003|82310400026|36860700016|921020|10067099003|11063799006|260925022911599003|260925021911599003|260925021311599003|56012099006|261026121527099003|261026140227099003|261028144727099003|261022105027099003|261022075727099003|261021123027099003|261021121427099003|261102123227099003|261009223027099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	7cpzYwdgg1TT7SmVTWavcLHRj5Gvo3CtSkyelKJZu+V+6FU8xsYyfR6siQ+fMjWqRDgfFPnAZrsajw4KZHHW+F6xbG07QGSgDO2CDCjlccKzAUFTWoRRud4oMySrGzQzqXrtoHNNwDkjeIoC6mot9ngSzCNLWAvukz87ERPSxEUQfNCXSiceJkuQrWjDhR6uIfAY31tFKNRWdY9RSuztmH92Y0tDi2PPb8snw7tYNwwYu48jc0O3R0VYfWcHDs5JoGtpV3mYpTsKq6NEjI4t0/P1SDyaCVg7YArHa1BXL2AA17nYgcnoxT9Gxkjpev4+6TajhlvbGhICSK9w01OxGINAp9xlYRzOq3wVZjW64BHpOppDCDDicd68wz+4WEU5tF9bTxQ94Er68Bg2MkPty+gELN1US0WTwazkGlWN5RXqxhdp6U1DAGwbeSrJG8ZWOLCMWrODo0fsNJZJ4EeGTTUpkcA2jyyDMW9KU9tgd94s56Ol/i0nXBme7rVMFVZTVXk8Ds6FLPBzLGVbwhtCtKQOsBRxtz4W5EZGWHU3ovx38Ub2Rqo9YhHmokIWxL37N1Fz5y3JAyRqMGFQh92xbocie8GHxFxJd+7WoXVczyC0rXe1nfB47cSfAqTz07U7VXwJlTMc4GNUsqPvflB77M9WlnC5+5+HgH67ynHBdJLOmaf1pMB6obrdyacmV/4PHkfEP4IHRpOTDJixaAdH59FuA/xM50eXn18nGyjzmJqWyl+wsX4wU+Qsi0mPD6ZS
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(23010399003)(82310400026)(36860700016)(921020)(10067099003)(11063799006)(260925022911599003)(260925021911599003)(260925021311599003)(56012099006)(261026121527099003)(261026140227099003)(261028144727099003)(261022105027099003)(261022075727099003)(261021123027099003)(261021121427099003)(261102123227099003)(261009223027099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	Ihcl/C60iiGBn6KWSF7Ig4qYuuX7cLLx6L1IVCaJFGr7uTKx4xV57hIS4dN2QO0629xcNj9GSJGN33ESkUK285dD6Kx97YtQmjlLDmt8QdKz/roUWAi+1nmZguSRGUspscBIpAgXl7BOSn2ni8m84OZYMZsLuMKgyqNuhqcBBSJ+9Oc/leXVhTutdOGuQenqGQ4MdlvOzFpoPorS+215j7XAx/SKkeBcLVv1MZBKKyI4Arp0r6BtkJpwZySzUlQDVBAcNP3CYaQMt6SJnmHrKxsgteut7600wdKYQNoA56p2TSatKsqCHc5mWiz+vEoNTAZCyT82a7OUchCcC1SR82hjmJax4QFZLxsUnUMhV0s7AxKxsTOu1TMHVJb/DIugY0RSojOYA3BFkFB2GiXeJXtjzbrP4IMhZv5SLDbBTGz8luQhc3e7ml8pldhpZaFh
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Nov 2026 07:12:15.4720
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ef75916c-8815-4d7f-47b6-08df460c70cf
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ5PEPF000001EB.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB8785
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: CA43A40006
X-Stat-Signature: ck7emsc1wo4j83ahsytt95axqmnacfpm
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795072341-571743
X-HE-Meta: U2FsdGVkX19lCLX5O4vUrNazn7IIy+ApYVNT0I6ELMA3GuceKyliuHwjy0TkaTIQBozSBT3TI8iiX7HQEeH3XuVSY+vF3VHJyq3pTwEGGfonduSykQRSgWJK+b5n9ZahH7/gz7vjTzgQ9eqjQrTvhpuJPn6WFIr1+LVSN/P9FhXWJGrPYq+GBWibwsvygRCgYk4ZynAVj2d/Za+44WOsIycZuCXmOOkdc29Cvuy76iAUbKATYZinBC8t/ncnfX1pRwG8uU/8H22NpJFaviCg3gQJCq4IqA8VVAn2xIuP0oyiOeEYOwGHBrccPU3MilL6FOb+W1zjVOX5dfzQesdIVNln+QWY6vjaSeLgRNQAoxwFwN9R5MtdgXwosyajmh0eWDZV6/Ht5HQGjP2RWnczD5Uk0RWpkwfcOIQLxiuEEfmCdgUz7Oq2IIZPnyzQoBQlIXuRmSP6PN0hOZP3YLQqEUPZFh38r/HIZvWOFQomQ+4xPhxuLM7h4iQLorLGSF5+MkIPuCRR7po713hBTLvHuvGX6jqx9eAFuKHHujcpzzFTb9n8GU7udd3Bi31PLHfAM8Oef7tf69EmpTmEuswBW2qDjM4bNG7GQQ+m9JUDad960ClsAoE256ypy/aYl5gB3HifH0ztmz7XJOjowFXrfhqqg0duopsGitmlipbMyBN81ujDrBWi1XI9DxpYmZNz5hKsf4IZNss5YCWD09GwHS7OOSuUX9JjaDqwXSua3EFAVDqbmDZ1X+uDdDHr1GJK8B0GB+WMVzm6tIGIezswqMyKh0eLfxd2J7uUph1kT6O3riWxVy5/N7+6jlzVYXQqIMWsg7i2ofsFVln6JoXwGmSySvrQ7ZmPJe0R4rnnz6zRpoMgscN3ZVt02MDu0QfSSFGMAFzw5mRkZibGtcfMRG4EM17Tu9j1mxjrv1n5xNGl5l7pWFHNyBW7Ok+UBsOnqllz7QkOLBxYj3/pKZA
 imiThihe
 Oan4gsiD0AY/W+na3umMStJjZHkjAUY7dGEfItxIzPnEOMxUjzXFlV1X24zYXHCJkS9w7sN9HNHqXIHoptVWjRReKf8a9M94lmJf+F+vPxXPCkqKFiTNFQwc2SDkHv4WorWI26T1/KosqZDtog0JsEZA0juJSbOR4dJ5fjYmiKyXS/Rvb+Zi3jSwfNRoiOHycGOVEzOFU1i0tWeB8E8fRcCrNsVEPV5zJvhjqi1OeQ4ldRLHVZufe6NYWEg4A3ywimosJ/3FimHwqa16AEGhHD8B8MANCTYA7chWYcn01m/ldA2BRw+EUDvFrgEE4yLrKe3B9ThNkW2dqmII7gOMF8T/9wTZ87Kbk/sU1nmYH5F4pQdPppHp+YY5ToNXPmCy8UO8NhEm35TuXPRklqE0LYzjgBtJWQULzl6yFmFMBoVITBgyxA9YaQC+pNtcWzNYRle9HwrItLKrBkwjIXTrge0LkkV2IR43NbshKeCZ19vVSuHzSETsk5VhUyhS3L3KkGQMfS7zJ3o6wQTx55dKaAUQW/1g7dhXEdAy2KLOIGYrZVRWuxd/yTku99g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

migrate_pages_batch() was hard to follow with the unmap retry handling
inline alongside TLB flush, move, and cleanup. Extract the unmap phase
into migrate_folios_unmap(), which fills @unmap_folios and @dst_folios
for the steps that follow. This makes the unmap phase boundaries clear
and the code more readable.

No functional change intended.

Suggested-by: Zi Yan <ziy@nvidia.com>
Signed-off-by: Shivank Garg <shivankg@amd.com>
---
 mm/migrate.c | 88 ++++++++++++++++++++++++++++++++++++++++--------------------
 1 file changed, 59 insertions(+), 29 deletions(-)

diff --git a/mm/migrate.c b/mm/migrate.c
index a7c94c5fdfd2..3f1639516623 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -1833,36 +1833,31 @@ static void migrate_folios_undo(struct list_head *src_folios,
 }
 
 /*
- * migrate_pages_batch() first unmaps folios in the from list as many as
- * possible, then move the unmapped folios.
+ * Unmap the folios in @from, queuing successfully unmapped sources on
+ * @unmap_folios and their destinations on @dst_folios.  Increment @nr_failed
+ * for each failure.
  *
- * We only batch migration if mode == MIGRATE_ASYNC to avoid to wait a
- * lock or bit when we have locked more than one folio.  Which may cause
- * deadlock (e.g., for loop device).  So, if mode != MIGRATE_ASYNC, the
- * length of the from list must be <= 1.
+ * Return: -ENOMEM if a destination allocation failure stopped the unmap
+ * phase, otherwise 0.  Folios already unmapped remain queued for the move
+ * phase.
  */
-static int migrate_pages_batch(struct list_head *from,
+static int migrate_folios_unmap(struct list_head *from,
 		new_folio_t get_new_folio, free_folio_t put_new_folio,
 		unsigned long private, enum migrate_mode mode, enum migrate_reason reason,
 		struct list_head *ret_folios, struct list_head *split_folios,
-		struct migrate_pages_stats *stats, int nr_pass)
+		struct list_head *unmap_folios, struct list_head *dst_folios,
+		struct migrate_pages_stats *stats, int nr_pass, int *nr_failed)
 {
 	int retry = 1;
 	int thp_retry = 1;
-	int nr_failed = 0;
 	int nr_retry_pages = 0;
 	int pass = 0;
 	bool is_thp = false;
 	bool is_large = false;
 	struct folio *folio, *folio2, *dst = NULL;
-	int rc, rc_saved = 0, nr_pages;
-	LIST_HEAD(unmap_folios);
-	LIST_HEAD(dst_folios);
+	int rc, nr_pages;
 	bool nosplit = (reason == MR_NUMA_MISPLACED);
 
-	VM_WARN_ON_ONCE(mode != MIGRATE_ASYNC &&
-			!list_empty(from) && !list_is_singular(from));
-
 	for (pass = 0; pass < nr_pass && retry; pass++) {
 		retry = 0;
 		thp_retry = 0;
@@ -1902,7 +1897,7 @@ static int migrate_pages_batch(struct list_head *from,
 			   !list_empty(&folio->_deferred_list) &&
 			   folio_test_partially_mapped(folio)) {
 				if (!try_split_folio(folio, split_folios, mode)) {
-					nr_failed++;
+					*nr_failed += 1;
 					stats->nr_thp_failed += is_thp;
 					stats->nr_thp_split += is_thp;
 					stats->nr_split++;
@@ -1921,7 +1916,7 @@ static int migrate_pages_batch(struct list_head *from,
 			 * list is processed.
 			 */
 			if (!thp_migration_supported() && is_thp) {
-				nr_failed++;
+				*nr_failed += 1;
 				stats->nr_thp_failed++;
 				if (!try_split_folio(folio, split_folios, mode)) {
 					stats->nr_thp_split++;
@@ -1964,7 +1959,7 @@ static int migrate_pages_batch(struct list_head *from,
 				 * When memory is low, don't bother to try to migrate
 				 * other folios, move unmapped folios, then exit.
 				 */
-				nr_failed++;
+				*nr_failed += 1;
 				stats->nr_thp_failed += is_thp;
 				/* Large folio NUMA faulting doesn't split to retry. */
 				if (is_large && !nosplit) {
@@ -1984,7 +1979,7 @@ static int migrate_pages_batch(struct list_head *from,
 						thp_retry += is_thp;
 						nr_retry_pages += nr_pages;
 						/* Undo duplicated failure counting. */
-						nr_failed--;
+						*nr_failed -= 1;
 						stats->nr_thp_failed -= is_thp;
 						break;
 					}
@@ -1993,19 +1988,15 @@ static int migrate_pages_batch(struct list_head *from,
 				stats->nr_failed_pages += nr_pages + nr_retry_pages;
 				/* nr_failed isn't updated for not used */
 				stats->nr_thp_failed += thp_retry;
-				rc_saved = rc;
-				if (list_empty(&unmap_folios))
-					goto out;
-				else
-					goto move;
+				return -ENOMEM;
 			case -EAGAIN:
 				retry++;
 				thp_retry += is_thp;
 				nr_retry_pages += nr_pages;
 				break;
 			case 0:
-				list_move_tail(&folio->lru, &unmap_folios);
-				list_add_tail(&dst->lru, &dst_folios);
+				list_move_tail(&folio->lru, unmap_folios);
+				list_add_tail(&dst->lru, dst_folios);
 				break;
 			default:
 				/*
@@ -2014,17 +2005,56 @@ static int migrate_pages_batch(struct list_head *from,
 				 * removed from migration folio list and not
 				 * retried in the next outer loop.
 				 */
-				nr_failed++;
+				*nr_failed += 1;
 				stats->nr_thp_failed += is_thp;
 				stats->nr_failed_pages += nr_pages;
 				break;
 			}
 		}
 	}
-	nr_failed += retry;
+	*nr_failed += retry;
 	stats->nr_thp_failed += thp_retry;
 	stats->nr_failed_pages += nr_retry_pages;
-move:
+
+	return 0;
+}
+
+/*
+ * migrate_pages_batch() first unmaps as many folios in the source list as
+ * possible, flushes the TLBs, then moves the unmapped folios.
+ *
+ * Only MIGRATE_ASYNC may batch multiple folios.  Waiting for a lock or bit
+ * while multiple folios are locked may deadlock (e.g. with a loop device).
+ * Therefore, if mode != MIGRATE_ASYNC, the source list must contain at most
+ * one folio.
+ */
+static int migrate_pages_batch(struct list_head *from,
+		new_folio_t get_new_folio, free_folio_t put_new_folio,
+		unsigned long private, enum migrate_mode mode, enum migrate_reason reason,
+		struct list_head *ret_folios, struct list_head *split_folios,
+		struct migrate_pages_stats *stats, int nr_pass)
+{
+	int retry = 1;
+	int thp_retry = 1;
+	int nr_failed = 0;
+	int nr_retry_pages = 0;
+	int pass = 0;
+	int rc, rc_saved;
+	LIST_HEAD(unmap_folios);
+	LIST_HEAD(dst_folios);
+
+	VM_WARN_ON_ONCE(mode != MIGRATE_ASYNC &&
+			!list_empty(from) && !list_is_singular(from));
+
+	rc_saved = migrate_folios_unmap(from, get_new_folio, put_new_folio,
+			private, mode, reason, ret_folios, split_folios,
+			&unmap_folios, &dst_folios, stats, nr_pass,
+			&nr_failed);
+	if (rc_saved && list_empty(&unmap_folios)) {
+		rc = rc_saved;
+		goto out;
+	}
+
 	/* Flush TLBs for all unmapped folios */
 	try_to_unmap_flush();
 

-- 
2.53.0


