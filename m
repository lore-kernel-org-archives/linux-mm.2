Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6B6CC606A32F
	for <linux-mm@archiver.kernel.org>; Mon, 26 Oct 2026 10:32:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=amd.com header.i=@amd.com header.a=rsa-sha256 header.s=selector1 header.b=a6pl/+90
Received: by kanga.kvack.org (Postfix)
	id 831606B05B6; Mon, 26 Oct 2026 06:32:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7E1FA6B05B7; Mon, 26 Oct 2026 06:32:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6D0A76B05B8; Mon, 26 Oct 2026 06:32:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 3F60F6B05B6
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 06:32:26 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id D5B9F120757
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 10:32:25 +0000 (UTC)
X-FDA: 85364413050.24.79834CC
Received: from SN4PR2101CU001.outbound.protection.outlook.com (mail-southcentralusazon11012043.outbound.protection.outlook.com [40.93.195.43])
	by imf01.hostedemail.com (Postfix) with ESMTP id B30034000B
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 10:32:22 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b="a6pl/+90";
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf01.hostedemail.com: domain of shivankg@amd.com designates 40.93.195.43 as permitted sender) smtp.mailfrom=shivankg@amd.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793010742;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GONDpkblcOJvLVbypKC+BDQYgzFpZgqqFHYTmmwdxyE=;
	b=5ooKjdmjZmbdo+MXZI1M9dBYblfbrDKTnc6sSHT8sjHxi1CbYE0Wdqa+nPvLw306q6XQV7
	r8trRYZkHLI8UsnTHRoKvzBTOPpOUZHclNj2e08rwfVhkl/32fYjW9jrsi2vWrRbu1uIXg
	YgrJNN/DeO2sqyVTK9oSe0KSKmbxWTc=
ARC-Authentication-Results: i=2;
	imf01.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b="a6pl/+90";
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf01.hostedemail.com: domain of shivankg@amd.com designates 40.93.195.43 as permitted sender) smtp.mailfrom=shivankg@amd.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1793010742;
	b=O7Kh4W+vfu/yA86fHGCbdYsNW8NDLIFhtSrW4NdEY+zBB48V9qMyqp7DBe+Bs9d4M3zdHZ
	sOOU5Wu3sQ2r65PfcWkg2Yk73w2cFpaGWIrSp1niTGNPGZGtsNPDRuxHCVb7TNuB7bAr+J
	2gmJu0rZ8ty0o04LM70OIePQ979csWc=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=LK7U8+nRSsr8ivf0NBL7BEFEImWnFNAIM3sz/tG+KD/D1sng9gJtG/14IJFd/YHHakZC9FJD+Wf2rTyLmGeVwa9xZ78Z5D1MODI56LP9jQ3I6ypqw3sn3kOE16LjrIaBBe1ie/fCzwFFdGRYupSm4ua3PoiO8iD8H7RB7k0ExWWZMv2dq9w0niw1FvHhS5JeBt21ClTLxU9W2EKhRE0oorANr+LqzLDbdQGbNOkpTGHG5IR/GhbVteEAJo/XR8GeiruoFJWZ2QCN9x7RN7O3I8I1hkUSaF/ywtM+CD/rdg9BcN2D1glm+Lj8sgffHusfxjzXKJmkD3bU8sgyptmTtw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GONDpkblcOJvLVbypKC+BDQYgzFpZgqqFHYTmmwdxyE=;
 b=n69IuN6oTwLjBVqZtOsxEppfEDBvhLTCg3HdTCE+w/x9oW9DBkU/e6v26bc+TIhtuXrIS8qyToc5bvalryv8bsEEngoL5jh+HbCElnABplwTL7zexjh1AHEoyYx6+Sp/qqiabcaCCSBEAVK3CIkG/Y3OKxwIs7FAcgWGNPkaVio1vbYZLvXZqqOmpGsY7j5gxsWSaG5mmBTzHs09Lu+SBP69YKJBJ1VERdNwB9jDK0BFy93e3Oqc78FKMJT59cWBZpVFgTih4dYp35vZS0doSuqyRQSthU4T3nxCMFPWCgyR3J4vIYzx6JI01lYFtK56VuIg5E0+nBW3IKpcZ2aeLg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=infradead.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GONDpkblcOJvLVbypKC+BDQYgzFpZgqqFHYTmmwdxyE=;
 b=a6pl/+90YflepJn1UsVjrOmdM3ZCUcQr7kV6zGNr3Hy45ACZnMrQLi8BIqXobyVKqkbkn+eR9z0BPVzE95WuGR+0/ooMBCOk3MpjCHANX9w9tek4EVAQPNfx8mr18GFB3cm1kWWNJIUvQzee9+DviUWKFKcsFuypOyV95tvgnpg=
Received: from YT3PR01CA0001.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:86::27)
 by DM6PR12MB4169.namprd12.prod.outlook.com (2603:10b6:5:215::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.546.22; Mon, 26 Oct
 2026 10:32:14 +0000
Received: from BL6PEPF0006C3DD.namprd02.prod.outlook.com
 (2603:10b6:b01:86:cafe::50) by YT3PR01CA0001.outlook.office365.com
 (2603:10b6:b01:86::27) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.546.22 via Frontend Transport; Mon,
 26 Oct 2026 10:32:14 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 165.204.84.17) smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 BL6PEPF0006C3DD.mail.protection.outlook.com (10.167.249.232) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.569.4 via Frontend Transport; Mon, 26 Oct 2026 10:32:14 +0000
Received: from [127.0.1.1] (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.53; Mon, 26 Oct
 2026 05:32:02 -0500
From: Shivank Garg <shivankg@amd.com>
Date: Mon, 26 Oct 2026 10:30:33 +0000
Subject: [PATCH 5/8] mm/swapops: remove unused make_guard_swp_entry()
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-ID: <20261026-unused-sym-v1-5-82ca2dceabe1@amd.com>
References: <20261026-unused-sym-v1-0-82ca2dceabe1@amd.com>
In-Reply-To: <20261026-unused-sym-v1-0-82ca2dceabe1@amd.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1793010663; l=678;
 i=shivankg@amd.com; s=20260518; h=from:subject:message-id;
 bh=cbqqr7piF4YSkr6W1BfNjAnWbO0ioXEHfqpBufV9mOE=;
 b=QJvobCeLFronhnFleMj5Vdib9VjdF2oXJAogwctt8eZC2g6t7ph0Ajwk4YiDzHkekXq7lPtTF
 o2bIrOcAvFwANJ7Opc4LG/Bbqve/SbQ24sTqaHiWsnGl8jzIr7QJgG2
X-Developer-Key: i=shivankg@amd.com; a=ed25519;
 pk=2l2QGTeXuGkZTtfmx0nPQU8iFZfjYmX/ymMojitevx4=
X-ClientProxiedBy: satlexmb07.amd.com (10.181.42.216) To satlexmb07.amd.com
 (10.181.42.216)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL6PEPF0006C3DD:EE_|DM6PR12MB4169:EE_
X-MS-Office365-Filtering-Correlation-Id: 9cbad245-ea35-4699-f4e7-08df334c66ac
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700016|23010399003|376014|7416014|82310400026|1800799024|261009223027099003|261021123027099003|10067099003|56012099006|22082099003|18002099003|921020|11063799006;
X-Microsoft-Antispam-Message-Info:
	xPEsw6g3BuGX9WrkJd6w3uWVYMmVbxW4xQNM1Ri0C+4/JgSZrzG1v1x+i9pLuTtcmK+3Evn87yq/Mrr1sf03NbKHoG/gZYTI2EJXTIQSdsj8Q0eokcFDXBe640t4Td7+mb6jQrpj7uLFGkaqFMKVqVw1XPJqbA2K6iHJkz0ZkExVtRqGG0BF2Sbq88kAqum4fV8zadJYuhhrkGUjBttLxXYdFtihtXfXjCWNDre3Bj70AJyMnudWnASseQKtAETeyaMkWv5yVd3m6d5Iv3VArw26rgpku1pfdcIC9jOGHA7m5QfVNplaH38wCoFPXMa67ZczdRM8dO3pQ5OjQcyGMogRbcwGbePPnFzKC4VUYhbX1WKSRgOTFGNsTM5wAiVhktWnXrdc2iprn7SH12vQ+nRppSbmdMX+eTPQyCJfQg3PMc6hphJ88Tyc/o4gxXwIJbVUGySMXmI8AB2HvPUIu+sQ4YB0O2t7Eh/iP/0mpC37P3NUhVy8X/WhOg9FxySwpTft7yqXMqBHKHITeyQ3EKkyCkJFTQXcnaa1h+DWSq0/rvnWDJBgONfwB3obHDJ8xXIsCo/Q7xtPf5QmPc0pr9ci2cWBVj1KP/upQh+Z8elQi5LPe5rWL+q6KEapTWBOy/lrLIaUYRjQ7gjrgf5lEUeM/FSyXB8dbLFEMinUwB4i/NElnEFGvXS7DgCJgAMCGqAPTnuf/Q9oH1XfRkockjAQw6muYG5CrwQqevWUzo4Z2AhMfmXfpBuq0tS1k9Bu
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700016)(23010399003)(376014)(7416014)(82310400026)(1800799024)(261009223027099003)(261021123027099003)(10067099003)(56012099006)(22082099003)(18002099003)(921020)(11063799006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	/2RjZkBpHMIp3R7qmJsOTuY7VbvoQxdRsnA28/+/tpy7V9PAU2a4PfjWXpqKN6SohoUNjHJ5NbEIStLlpSCMv0csvNCyPIbmB8qnr2sLeOunlhgIGdPMd7DegRZ5gQ71lTlLcxuU28FclMZCNXN93Pcz7XaxUfmPnWop3DVo/fRW5wLtZA/8PsrwR/CGPyNPR9zZtpbCyCpr+amjebR/k+WXxp8InzyNBtRe0Z5t8f/QjNBR0z73ee9CdF4pohZOfm6K8IcqLAUcxyuUdn4KgkyvyAS37SiCeypVTiGxxy6b4LwrCeO17iehkrzys8CPWyHPiaB180mTtVwyDXt1DuLO+tbrTorA3xpIfM/SVd+lcp0RPoU3OGf7kDl9m627N7+gSsGqKxAqN+fGJxc+SvxgHabgH6Z5+a4fUoaE/tjqtQxqY2rf3XTcrzL0VmTJ
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Oct 2026 10:32:14.2619
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 9cbad245-ea35-4699-f4e7-08df334c66ac
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL6PEPF0006C3DD.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4169
X-Rspamd-Queue-Id: B30034000B
X-Rspam-User: 
X-Stat-Signature: pjo8e8bqpfbmikuz3bhob8knti36rnt9
X-Spam-Status: No, score=-19.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam03
X-HE-Tag: 1793010742-145849
X-HE-Meta: U2FsdGVkX19ivtdTEj9wgw2sJCGiulb789mjf36vjgZWLwdf4alhUgDZcsEm+Mq0Bw9yhYcV2o+lsXeTrLgErp1VTD+9oUG2vtsDhl6TRMHpUEOY9bKhrYoibgDz4O86HnGwHXlak7q8ULz6uUDj7WtPCsB838QETzcWi8/1tiN1G3Z2pjrDyJQEVjhRKMKPm/qeNsPlpiemdrBDmgQp6/0cRG47I9rKyutuPIDaFGTtrx+cCC5QPHRjR1Dtco1YqakW00kt0SFFG8eJcbyFq8x2vnbRHxtyvVLfu/RklYf9x6xdeHpTIWap66UuYpowuKCtfFruheC4WF/jYDqtDbuUG/5xhx+B1TjehPR/2maxMNwQOfQa4jkw6Pzt7nhVI4YniiAr6tQnd0OF8HDrzlVwUtWBKsnOT1JJ5ZGQnbSlng0AuFai37HarrEGt+ntG2f06nv5TcTkXESchLw57ehvZ5eN65TIdqj+IN535AnYGhM/aS8vcm1P8J+WpM83LVO6yXxDHfwBYzU7/AUfqkVa/OWaE2da+4Sh7nBEXZ8H9JydknOeZSEX/lBu5K/Bfbl6d9Jo7OjMY7yXADuJDvOy0GuOLUf0bzA1aJgAqP9CVDGovuo+cb0p5Md4S6063NpkEN22RYSaWHjXGC5Rih38AvECwhwzk30H/nDwsF4ivPUZq8ibfzg9oS/Z7+/yPfNuqsM5H+x5T1CbqRX8Q9R1ruGyyjD5WfxCkJ+tUdBo8l0kdRNRrUi7e5PrLAt72suzIwzrnv12PaT/bw/dvbcbL2I3rqWvTDelT0U407cT1ij4illDoijnd5CoZG558a52qYexb4ahwOk9QZWPeRrM/D3C7giyRYTlphsT6pVRUsfLKgWa5BJWsgowYRoxPtZSRWYXwWydwWSTNZuDKnEWP5yHzoVupYYeFIChjL4t6UTikAUnvyxX0XuFIOEZoM2aLd2fIxZRiWqGsLS
 ho6UZfEi
 cv5btEGoYvyg5OSo3/k/0OG0N2kctg4HbeQ+SoKxczwcMGCJBjZubfdM5DemXbZe/1uqiaonJwNHG3BfGqDVOnyMpDPrpauXV3SPBoJx63yD2Rl1gxgif+6etlzGW+Sets1pTWVObQ9oPaHZA4OvlkclE+hbZ3/HcLGcMkWWiLrQT/8jsiAtcfaOliNSGraHaOeSdR4thXiQ0AmEYJjbmVQxsxAR2Z+bAM6nidP7pNjKwI/AsUnlp7ljirfm+Z8Jbzv+uLghb+TW6bapXSsWMXhiRPqFgM9No2OY8XBBtCeXas6vut2OFYy0vu2TZQDlu6aRFbAlAR58D3NGTZbde9pDHw04gbzQ64QTMRZymc0sOVFp3J44VQDMqdJMHEJ1YOK+pQp2umSrybwxDr0xhReG8cpHW2FDmcSskKqkNdRs2TNzCNYVyd/5bo6WCJagjirI1sDuwwrfX/Qsd7N5OvqLr1HuGLeGjPbhda1QwfnpUfX0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

make_guard_swp_entry() has no callers.

Signed-off-by: Shivank Garg <shivankg@amd.com>
---
 include/linux/swapops.h | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/include/linux/swapops.h b/include/linux/swapops.h
index 603f9e3f909c..6f62fc3c8cfa 100644
--- a/include/linux/swapops.h
+++ b/include/linux/swapops.h
@@ -306,11 +306,6 @@ static inline swp_entry_t make_poisoned_swp_entry(void)
 	return make_pte_marker_entry(PTE_MARKER_POISONED);
 }
 
-static inline swp_entry_t make_guard_swp_entry(void)
-{
-	return make_pte_marker_entry(PTE_MARKER_GUARD);
-}
-
 struct page_vma_mapped_walk;
 
 #ifdef CONFIG_ARCH_HAS_PMD_SOFTLEAVES

-- 
2.53.0


