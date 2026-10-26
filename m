Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CFC07606A31A
	for <linux-mm@archiver.kernel.org>; Mon, 26 Oct 2026 10:35:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=amd.com header.i=@amd.com header.a=rsa-sha256 header.s=selector1 header.b=3wvtLj7H
Received: by kanga.kvack.org (Postfix)
	id EC63D6B05BC; Mon, 26 Oct 2026 06:35:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E50086B05BD; Mon, 26 Oct 2026 06:35:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CF0A76B05BE; Mon, 26 Oct 2026 06:35:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A18006B05BC
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 06:35:28 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 3643A1C4007
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 10:35:28 +0000 (UTC)
X-FDA: 85364420736.09.7FB7718
Received: from DM1PR04CU001.outbound.protection.outlook.com (mail-centralusazon11010056.outbound.protection.outlook.com [52.101.61.56])
	by imf28.hostedemail.com (Postfix) with ESMTP id 2415EC000A
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 10:35:24 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=3wvtLj7H;
	spf=pass (imf28.hostedemail.com: domain of shivankg@amd.com designates 52.101.61.56 as permitted sender) smtp.mailfrom=shivankg@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793010925;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=Re367Wt8LXM2TVLXR5gu1dStH5vIBrxwZf0APW1W3pU=;
	b=E1XkLPs76+bu98bRCdC1G1mm4qqB56/7IKlqCEkgYh2N0rt7GSFb8nZe049KEwab0k6IZJ
	hNHXg+TTZQDjB39UPWg1WSW1RsKxUTtUnls4va+bbRRc1RA5SmHCFmeU6jts3AcTDYbVTt
	LW0RS9Me792hCgSBfGEVltV9tmdXl9U=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1793010925;
	b=sA02g1ihnIkkDyEUf5xstddukoryREG5R/aEBV34ueFRSgTMetqIo5HcSL5CWO/UrWlrlV
	G7y0fTx1shYE4GwypkTELsEWeKtnUCaIVyEFGV/JpSSkxN9FUWRxwoPen5zuZEd5ZN8jQR
	QICXbg8+C8RZBY9396rbjvAWsvDQBnw=
ARC-Authentication-Results: i=2;
	imf28.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=3wvtLj7H;
	spf=pass (imf28.hostedemail.com: domain of shivankg@amd.com designates 52.101.61.56 as permitted sender) smtp.mailfrom=shivankg@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Ah3aCgOrof+NNxbY2Jl/XZqnidt5wOI8JAx9xHyd5HEwVdrrSi2axKQh3946oMZk5edPmiixrQhAtXGeA2uB0bS+1ri4+mpeZwe7UXuaXL0JaKEms7iJIIveTULyIINWKP5ztYjmX6IaObiSVRUXXyWhGXeg82NnFU3LZFEgVpk/+icnufwdXmAmFAl4YwwZmEI8flLFM2RktfxsluKHXmLLxvIl7OpBafT6A0TiZ8dTJPwowqvjnhI1WScK2TSV2Ppo7IHTy4jA6kPgJcABhcRSfHhkIENzK6/Ju2BPD8RxHKThmSMHpsDEgSk/3uO4lWncCNyAwfdbenKvqZAJsg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Re367Wt8LXM2TVLXR5gu1dStH5vIBrxwZf0APW1W3pU=;
 b=hBqj7R0pOVzfcsx+AAqf+2HQmgUXMYNwaFNr4S0+NXB4yftWADaOwaJnFYUyMzdCLmCViS7cyD8KjPligFWviKmHNhRju83Z75Qy9fnEkfWtEwd8wApNyAPVVTLcElylTueJoNV7xnoN17oQLtmJkshJVVK4SKWkelKcZ0B3uqJdLz9asshoeW+8NXmT/+l8ELqHKLVjHRKb/czZdn4jzajQy3zZwc3W9mCvUqC6UsFObkx/hrEXE03T3FwdPSOSOc/eC2ibm0SQE/+dRiJLHSZ7QdD1Nc3gTdBi4iw03hsMssfD4HdMSfqXE2/uBwg7HK1JnO5HhCGyFpWnzAypOA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=infradead.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Re367Wt8LXM2TVLXR5gu1dStH5vIBrxwZf0APW1W3pU=;
 b=3wvtLj7HJOg861+2aNpyhbTY/W+a82NKiV6WSafzsAeVp3r8GvmB9U/XRaY5E2/D8b8h4RP3ZaBdcVLzc/tncwtgfztZNGonHRXrQKGuvJsD2qMf66EMg512CE4ONnfSu8k8Bt2DYMLSsq+lk0efy9R2rH/NNXC+84OCqHWxKdk=
Received: from CH0PR03CA0035.namprd03.prod.outlook.com (2603:10b6:610:b3::10)
 by SA3PR12MB8762.namprd12.prod.outlook.com (2603:10b6:806:31f::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.546.22; Mon, 26 Oct
 2026 10:31:16 +0000
Received: from BL6PEPF0006C3E0.namprd02.prod.outlook.com
 (2603:10b6:610:b3:cafe::89) by CH0PR03CA0035.outlook.office365.com
 (2603:10b6:610:b3::10) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.546.16 via Frontend Transport; Mon,
 26 Oct 2026 10:31:16 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 165.204.84.17) smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 BL6PEPF0006C3E0.mail.protection.outlook.com (10.167.249.235) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.569.4 via Frontend Transport; Mon, 26 Oct 2026 10:31:15 +0000
Received: from [127.0.1.1] (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.53; Mon, 26 Oct
 2026 05:31:03 -0500
From: Shivank Garg <shivankg@amd.com>
Subject: [PATCH 0/8] mm: remove unused functions
Date: Mon, 26 Oct 2026 10:30:28 +0000
Message-ID: <20261026-unused-sym-v1-0-82ca2dceabe1@amd.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/6tWKk4tykwtVrJSqFYqSi3LLM7MzwNyDHUUlJIzE
 vPSU3UzU4B8JSMDIzNDAyMT3dK80uLUFN3iylzdNFNz80TTJAtzk7RkJaCGgqLUtMwKsGHRsbW
 1ABqjz1lcAAAA
X-Change-ID: 20261024-unused-sym-f577a5b874fc
To: Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand
	<david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett"
	<liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport
	<rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko
	<mhocko@suse.com>, Kairui Song <kasong@tencent.com>, Qi Zheng
	<qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, Barry Song
	<baohua@kernel.org>, Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie
	<yuanchu@google.com>, Wei Xu <weixugc@google.com>, Baoquan He
	<baoquan.he@linux.dev>, Baolin Wang <baolin.wang@linux.alibaba.com>, "Matthew
 Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>, Hugh Dickins
	<hughd@google.com>, Rik van Riel <riel@surriel.com>, Harry Yoo
	<harry@kernel.org>, Jann Horn <jannh@google.com>, Lance Yang
	<lance.yang@linux.dev>, Chris Li <chrisl@kernel.org>, Kemeng Shi
	<shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, Youngjun Park
	<youngjun.park@lge.com>, Jonathan Corbet <corbet@lwn.net>, Shuah Khan
	<skhan@linuxfoundation.org>, Johannes Weiner <hannes@cmpxchg.org>, "Michal
 Hocko" <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>,
	"Muchun Song" <muchun.song@linux.dev>, Uladzislau Rezki <urezki@gmail.com>,
	SJ Park <sj@kernel.org>, Minchan Kim <minchan@kernel.org>, Sergey Senozhatsky
	<senozhatsky@chromium.org>, Alexander Potapenko <glider@google.com>, "Marco
 Elver" <elver@google.com>, Dmitry Vyukov <dvyukov@google.com>, Pedro Falcato
	<pfalcato@suse.de>, Bharata B Rao <bharata@amd.com>
CC: <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
	<linux-fsdevel@vger.kernel.org>, <cgroups@vger.kernel.org>,
	<bpf@vger.kernel.org>, <damon@lists.linux.dev>, <kasan-dev@googlegroups.com>,
	Shivank Garg <shivankg@amd.com>
X-Mailer: b4 0.15-dev-47d62
X-Developer-Signature: v=1; a=ed25519-sha256; t=1793010663; l=4991;
 i=shivankg@amd.com; s=20260518; h=from:subject:message-id;
 bh=HfPcxskqyJdwsRoR+BYJC2/1riiJVVu2W7JK9eq6WgA=;
 b=x84fMUS12Xc/VmQpWc2ywiAy0sAd1AKLKnnN+lltJxaPknJ1FxsXoFSih/0sSxTjd+ikoCJn4
 FwqgIhkhSKWABmvfaqkqzZIiRycVvRj5j17hFmu8i20AtxAKU+6LHi8
X-Developer-Key: i=shivankg@amd.com; a=ed25519;
 pk=2l2QGTeXuGkZTtfmx0nPQU8iFZfjYmX/ymMojitevx4=
X-ClientProxiedBy: satlexmb07.amd.com (10.181.42.216) To satlexmb07.amd.com
 (10.181.42.216)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL6PEPF0006C3E0:EE_|SA3PR12MB8762:EE_
X-MS-Office365-Filtering-Correlation-Id: bf96e645-1134-4547-766c-08df334c43d4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700016|82310400026|1800799024|376014|7416014|23010399003|6133799003|10067099003|18002099003|13003099007|921020|56012099006|11063799006|261021123027099003|261009223027099003|261021133027099003|261022105027099003|261021135927099003|261021130227099003|261022115727099003|261022113327099003|261022075727099003|261021121427099003|260925022911599003|260925021911599003|260925021311599003;
X-Microsoft-Antispam-Message-Info:
	PsWXVfFUwpuYaVrqRVoakBAHcQuLSxm5f+CAOdvbgXurFkPLxA9GJxy0OsoMui/olN8HDMYiEt5XbvMdp5jC5bbQuG45VD3NUpM9PMkfp1j+xkYUIVT8puhv7N/VyAFDPwmHZbpXamIoqecUW33tqBX0sRTGQYcFrdOSq3dV5zTUrhywtRKxzsjNUU+mkXCoHHovsokrDIMb45v1mdvG8C9ES7agK6QgdX5O8mkksVOHY7ma6a5hwrK8+rkYeurBduPn7KZsfYn/M7yJOKF1TuusMZZrXW2QsS6CxiXzfc4O2WJyTOExZoqKnnAZ7VnbAvgwqrNkFO78FqBvhoku5xu6LOJcxSQMSXORaadQkPvi8jL8nbbuttuqn2UmHUs2x8louXKOf7vM8a+hhuCyxeDe2gVRQtKfnMOmAp+mWt0Vff/wTQdQ+mQibmJ5rv69UQ9qUSikSP4OmZyMGhQY0SwCKAKRxMo9z5otEaBZya3VP21xOtPM/Mdsx7J7uy7bWTIgdkqX2oB1pvP1inSM49rsHkczoav7oGeZeiPcM3kcLKyv3Qt7nigBm7b/tx2XWT8bADu/u49Cxp7x+BwACPHo8C+SGpEPwGuaOYsVavQYV1R25a9xcnq7Z8o6rvE4INezaau3BorKFDFuvnFBTYUsv/3zEYJhWxGpjtG+Z2fxWw/qucqJ7MSkJ6iTpZ882LIuHadR6J9IdBLlRh1iCw==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700016)(82310400026)(1800799024)(376014)(7416014)(23010399003)(6133799003)(10067099003)(18002099003)(13003099007)(921020)(56012099006)(11063799006)(261021123027099003)(261009223027099003)(261021133027099003)(261022105027099003)(261021135927099003)(261021130227099003)(261022115727099003)(261022113327099003)(261022075727099003)(261021121427099003)(260925022911599003)(260925021911599003)(260925021311599003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	BN1rQs0OraG302mtvTkuDW3GPLZS5He7EzrG6naWaX7D+Idl9gjbIxGlf5oUmUe9QOX5xOpbMbOiF8ODO9nd3cwEuvFlOgZOOgOTtGzYSn6KXeSv4QUOfIacsG9y66NYeoUt9boKchtopfj0YV5aZbdijI4KTaimiqE/xngG0vizwwxbgDpFDQI1llG+hxqq3/+IlqMD1j803UhYyOiiDNoUzhOaHIB6gImVXqbV5g0bYRO9XJEG87GrE0Tvn81QwkXPbejdZaOAOlolMRtRF5gAFw+Q2w6YsOC9SEGtTWapJCU9xi3ry1FHIbcUZAOgnK8evCvLVSFG9GJA1o8p5v8ebMvQUFR7bz0Fc3jBa+UITb/1txItVubyMl/tVI/Mb8E9pFQhvfo3zjxGHL98WOt9qn9l2TpD1vjQEHw442FsrLqVXsf9LCaq9pq+qcTD
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Oct 2026 10:31:15.7997
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: bf96e645-1134-4547-766c-08df334c43d4
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL6PEPF0006C3E0.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR12MB8762
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 2415EC000A
X-Stat-Signature: fzg7f15zwz3qhgkrg3rajwcwimayft6u
X-Rspam-User: 
X-Spam-Status: No, score=-24.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793010924-194383
X-HE-Meta: U2FsdGVkX1/8NrB3GJMZX0iaUGG6jLhLN3kyLI3XBTNfR8DngDIqh6lJGO/u/s8HeZ4EmDokWcshtiNRLbgx+AnGhfvxJ4JWUMCvN53OrPIoXxLwRsoaMv548gAJfTdalHqTbAQBxo6FHmq7pyZzYfVthyqtQMbvRJEo01gyL/qj4kRDgz72TwkMN08HLi8f3UjCx3e1zjm4L9u5qZAQDEmnY00WGn8r+NMCD9IZUWjiGLsMVooPmHh3GUxj1wY58+fvsK05pR1gQFFV9LR+2qFw3LmMZLKXG3OP1Q+flnkn1R3KBOaxoxkmSeNIU/OsYCrHbtVvJYEHxjI9Zo8YLx/Fq5QVfNtWc4aIu9J9d9tWDazBeHUFY/W/Y6VHu7lKxKgepMhZpgIahIVkmDSZ8Uv68bmTzi8slea4k/AoiH7W7mizVKaoqO0WVgIclCP5HksfQ6t8P40caonby+J2GnrUHMSO+Rq6YWkDm36fnXJFprDUN83YkB3V3besr2V9/o8S481FJw4/+hIVC2ebqVE4Sx+70MmtQtqiXkyU6kGbmvt4qATJsyn+F5FjLKG3+jR7BTcyf0OFPu/HSk46tLE5RReluVpuvO/827q+hT1KaxgTHiuC7y1EnLdP4ugLdcmb26ezGfaL/lyrsVZOkPpM4qwcBOjbWkUuw0nsLBe/yFYxIgSU7O/GtAqnK4zWAKofA7ZVwu9K/43MF/lydoxK5fSaH4SoklESvbJEiGPEkrUlIfs+3rdlqOADJQm9i9pIT/smqsE/OdIR9qlfZz9tSN4vf+SWPnl1/RTU5TSebT2qT4wdxzWXffEuLbmTLni3UKA24t0caXcAF515GIJgGkNl5dLhDCpypZF2mU8LszqO2SsWaTs9bWigI7DBnU8Bf9J9MFR4G1M1A0tCCAdo6dud/7FUSr68CZfLYIyh85llmR8Ns4eFQf+D+7UfKn/c+aXyWqpb8+5TMNI
 z+INF70E
 6A4SJwL1WXUkhAdrdViyx0NX+z2UdNqQY+tVuAs4S7zNlPvvHQUNr3AQPh9zzqYD25L2t4cR2zlcCQctSrPJYXg05sj/11rztjoR8+8mDthPK45m+K/rP08j/89qxgiwKKTydRHO45/ef4WNFQyQe9dPrHe3zMGL7Tq7jsCfmkpKdn9W6phXJfuGdPYqIyp07ZqswyXgGgOwGFgWgN2XpCRySQdxcxAeiLUfFFPpjkhl4WGl9QE04Y0cGkxMgSVinO/ZEVjCancyKO30iGtCBrD8w6zIjhqaXqVoudOJyXpVjlOyORQskwob1anwESWEYEsmTczYWOyavyWLjijQ994eWm4qrrLbT7t5lcifAnevykRT/UfmDk0Ro1ocrUjBjwvCa2wgKrz4WF0Q27L6kVZM5O63vFQPxUt+EW+3rWA4yyqzM8YkbudmY7KqoyCGsbKw7UTuhtoV6rLKP0NMZ/FNBsNxjgKm9LamxT2gav8PMczc/iSU6+lOBI9J+S597i7trzD20oviKyRw8j2LFm5+4zgg8gRstl8cLtjFZdKMwcibhCIV2s4DFxf732m81AEwX2E8hsqZ7dsaeHGoEiW0k1j0V3lKM+VkXC+mwBwGmLMUG59TxUvIdFDeNNbiGS/3NCrkeMb6Yu1J8VOPsli2jUmv41R+NaEcMABUJCks7rjiJv76eYKB7e5SYiSKSmVpyyoCDyuHMvbFNGAFpatymqYGy3HcTdpYKhM3pEBZuaol9LWUwx5yQ3w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

This series removes 16 functions and one variable in mm that have no
users left anywhere in the tree. The functions are all static inline
helpers in headers, which no compiler warns about: GCC never reports
unused static inline functions, and Clang only reports them in .c
files, and only with W=2. The variable is heap_stack_gap in
mm/nommu.c, unused since the start of git history. Each patch covers
one file or subsystem, so they can be picked or dropped independently.

How they were found:

I wrote some Python scripts, with the help of an LLM, that scan the
whole tree for every config and architecture at once. They look for
static inline functions without callers, and for non-static functions
named nowhere but in their own definition, declarations, stubs and
EXPORT_SYMBOL(). Where a ## macro could paste together one of the
names, they read every call of that macro to see whether one does.
The candidates were then cross-checked with a real build: a scratch
tree marks each one __deprecated, an x86_64 allmodconfig build is run,
and any candidate that triggers even one deprecation warning is
dropped. The final report labels a symbol "Sure" only when that build
confirms it unused, and "Unsure" when the build doesn't compile it or
the scripts can't rule out a use. 

Before posting, I searched lore with semcode MCP for removals that
others had already posted, to avoid duplicates. Each patch was also
build-tested on its own.

The scripts and a generated HTML report are here [1], if anyone wants
to play with them:

[1] https://github.com/AMDESE/linux-mm/tree/shivank/kunused

Left out on purpose:
- mmap_action_map_kernel_pages() and mmap_action_map_kernel_pages_full()
  are unused but documented in Documentation/filesystems/mmap_prepare.rst.
- zone_span_writelock() and zone_span_writeunlock() are unused, which
  means span_seqlock is never written while page_alloc.c still reads
  it. That deserves its own patch.
- cpupid_cpu_unset() and kmsan_poison_memory() are unused, but each is
  one half of a pair whose other half has users: cpupid_pid_unset() and
  kmsan_unpoison_memory(). I left them out to avoid breaking the
  pairing, but I'm happy to include them if that's okay.

Already posted by others, or about to get a caller, so not in this
series:
- __mm_flags_set_mask_bits_word(), by Kevin Brodsky:
  https://lore.kernel.org/r/20260714-remove_pgtable_cdtor-v1-1-44be8a7685d7@arm.com
- pfn_in_present_section(), by David Hildenbrand. His series also
  reworks the code around valid_section_nr(), so that one can wait until
  it has landed:
  https://lore.kernel.org/r/20260921-b4-sparsemem_cleanups-v2-7-54d81d65e125@kernel.org
- page_memcg_check() and mod_memcg_page_state(), by Sang-Heon Jeon and
  by Tal Zussman:
  https://lore.kernel.org/r/20260918165601.1014666-2-ekffu200098@gmail.com
  https://lore.kernel.org/r/20261014-memcg-unused-page-helpers-v1-0-240b37c53831@columbia.edu
- vmf_insert_mixed_mkwrite(), by Sang-Heon Jeon:
  https://lore.kernel.org/r/20261002160535.661399-1-ekffu200098@gmail.com
- folio_dup_file_rmap_pmd() has no caller today, but Konstantin
  Khorenko's fork rework fixes it and adds one:
  https://lore.kernel.org/r/20261021-b4-prep-vstor-149847-copy_huge_pmd-recheck-special-pmd-v4-0-66f00b7a564c@virtuozzo.com
- read_cache_page_gfp(), by Qu Wenruo, as the last patch of a btrfs
  series in January. It hasn't been applied yet, so I've left it to
  that series:
  https://lore.kernel.org/r/a5ffadf18dca846d6f8086b29366288e794a24b6.1768017091.git.wqu@suse.com
- folio_is_pfmemalloc() has no caller today, but Ameer Hamza's SUNRPC
  page recycling patch adds one:
  https://lore.kernel.org/r/20260817210811.3984663-3-ameer.hamza@truenas.com

I'm starting with mm. Across the whole tree the scripts currently find
about ~4000 symbols, and of which 3000 pass build checks, so there's plenty of
fun left for other subsystems :)

Signed-off-by: Shivank Garg <shivankg@amd.com>
---
Shivank Garg (8):
      mm/vmstat: remove unused folio stat helpers
      mm: remove unused folio refcount helpers
      mm/page_ext: remove unused page_ext_iter_get()
      mm: remove unused helpers from pagemap.h
      mm/swapops: remove unused make_guard_swp_entry()
      mm/swap: remove unused folio_to_swp_tb()
      mm/zsmalloc: remove unused zpdesc_lock()
      mm: nommu: remove unused heap_stack_gap

 include/linux/page_ext.h | 11 -----------
 include/linux/page_ref.h | 24 ------------------------
 include/linux/pagemap.h  | 11 -----------
 include/linux/swapops.h  |  5 -----
 include/linux/vmstat.h   | 36 ------------------------------------
 mm/nommu.c               |  1 -
 mm/swap_table.h          |  5 -----
 mm/zpdesc.h              |  5 -----
 8 files changed, 98 deletions(-)
---
base-commit: 6b4b543fa18757297ac756a6fe6e64f506b7844a
change-id: 20261024-unused-sym-f577a5b874fc

Best regards,
-- 
Shivank Garg <shivankg@amd.com>


