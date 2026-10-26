Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8BAAA606A32E
	for <linux-mm@archiver.kernel.org>; Mon, 26 Oct 2026 10:31:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=amd.com header.i=@amd.com header.a=rsa-sha256 header.s=selector1 header.b=EPJO9XZA
Received: by kanga.kvack.org (Postfix)
	id 9B6446B05B0; Mon, 26 Oct 2026 06:31:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9673C6B05B1; Mon, 26 Oct 2026 06:31:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 855876B05B2; Mon, 26 Oct 2026 06:31:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5A9C66B05B0
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 06:31:37 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id D905C806D8
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 10:31:36 +0000 (UTC)
X-FDA: 85364410992.10.FEA9EDA
Received: from CO1PR03CU002.outbound.protection.outlook.com (mail-westus2azon11010020.outbound.protection.outlook.com [52.101.46.20])
	by imf18.hostedemail.com (Postfix) with ESMTP id 7DAC01C000A
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 10:31:33 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=EPJO9XZA;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf18.hostedemail.com: domain of shivankg@amd.com designates 52.101.46.20 as permitted sender) smtp.mailfrom=shivankg@amd.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793010693;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fyugMBav7xTQnoOl+Qj+YPtNJnrNVEg3p+9n1nI4itw=;
	b=UQmzVP1+RjniH+2f+MG5nCSJeEBVUs8W7OAFd9aMp6ItRAXbBTkYhYPbSElr8ixlOqr9VY
	lqJ6dSROPx72rlaX9GO6fdYnLigcNDVBwBZXlC/6nuA6w205RpobFfQzzkC3+jJFm125dw
	k5YqAT3QVdH5B7+dZwDvCwpzTFAoAfQ=
ARC-Authentication-Results: i=2;
	imf18.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=EPJO9XZA;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf18.hostedemail.com: domain of shivankg@amd.com designates 52.101.46.20 as permitted sender) smtp.mailfrom=shivankg@amd.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1793010693;
	b=HD62TngGcRcCAMFzfn20jiWpV7kspPXumeJ6usH6p/KOGqlwfjhLQL3DvHlpZq9giWSbzy
	T8L8rI0EW1/miQXf5Nk37DfyNL6eCWL/8yJUvcCznRk9HIB/F1/7q9zZp9g1dXJpmPajl/
	VlZz4Ky458Y+lf3A/9Y4uhlnzeU2MhY=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=KV3GgOu4E7yFivdr5ZR66b0micNIvtQQ+1sx2n5pmgOAHbD+v8IuU74Lk3iFRI6VWEhRCv6ENv21rmBewp/PmwxRgiB7hu7Rub/JTMeDjDsw8gcBjDf/1+h9zmEgioQj/9e1Hr99E1mOiQxC36QD3olgpPF2QJTvubPGEXgtHyLJXjl8j0//vx7Ga4G4zE3NMwjW3dvzQ0MySMtKamRLikjWt3uaNANd8YU393s31BcByWgF4AOvPmkSww6igoUxuHJStoIpCufTn0EncEDDRO0y9lqgw7JVwBuy9h3iSSuDN1Ki8QjJZOL/1oinZqi2kjcoH+lVmgB3TiJlJRgOuQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fyugMBav7xTQnoOl+Qj+YPtNJnrNVEg3p+9n1nI4itw=;
 b=l5g3EFoGYGyimDmOgS6EveQ4gsM64HWjXPIbaaw1bWrlVOsOL2jvvR+I90Xa4ruRrz7ZMovPpBhSkLlq4XfNfNe6DGPdRdE2Mu/iqkvqZAMPJRvMbVcN8UUR5Xv9bQCkn5Hl1KgatEBuSA92n3Fam2qBOQxbjmVwKcyHn0yrqOAxeMqjMTkwm/UVaA2AEXJi9w77VHuofl+dTTeYOikvw47qKxzc9mjZyjzCG8nrz7uILioKtchnS4+tN7XDye2RX7c4fJYEsPL+bvk5gT0klsLrVAzZXNy+DXimUDy3KCBfK0U4Ngi1QoOd7b5X09dTtshvJMzAVlI5PE6Ovod9dQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=infradead.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fyugMBav7xTQnoOl+Qj+YPtNJnrNVEg3p+9n1nI4itw=;
 b=EPJO9XZA0KmUSTE1lQMsf1YrCidS+ucKv8nxCI/JotUMxNW9CXn/99QtV3bMZ7pPb1qN7WXCIc0E8QaTBVcDXn5aRG0iZ9iinVPk9o6vV9fGllYpBuk/uZR46SQmxdZ+vfV4Oc2Qg0/WdVn9RWF8X0s8ryhSAGr8FD+xWaFvh3Q=
Received: from CH0PR13CA0004.namprd13.prod.outlook.com (2603:10b6:610:b1::9)
 by IA0PPFDC28CEE69.namprd12.prod.outlook.com (2603:10b6:20f:fc04::be8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.546.22; Mon, 26 Oct
 2026 10:31:27 +0000
Received: from BL6PEPF0006C3E1.namprd02.prod.outlook.com
 (2603:10b6:610:b1:cafe::46) by CH0PR13CA0004.outlook.office365.com
 (2603:10b6:610:b1::9) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.569.6 via Frontend Transport; Mon, 26
 Oct 2026 10:31:27 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 165.204.84.17) smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 BL6PEPF0006C3E1.mail.protection.outlook.com (10.167.249.231) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.569.4 via Frontend Transport; Mon, 26 Oct 2026 10:31:27 +0000
Received: from [127.0.1.1] (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.53; Mon, 26 Oct
 2026 05:31:15 -0500
From: Shivank Garg <shivankg@amd.com>
Date: Mon, 26 Oct 2026 10:30:29 +0000
Subject: [PATCH 1/8] mm/vmstat: remove unused folio stat helpers
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-ID: <20261026-unused-sym-v1-1-82ca2dceabe1@amd.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1793010663; l=2287;
 i=shivankg@amd.com; s=20260518; h=from:subject:message-id;
 bh=DefGTvUpFwbcZk2mR+oumYqwMkGhYq6r8/H27DOF33U=;
 b=5SHt7jFCvyZydEFn9weQyboLS4iJFN6a6gfc7BMbkzBMcSAN/pOdacCAOpCNKkg6GnprW/l2L
 s3llS9gLRtQBEKXCuU6bcifhtw68M4tBLjYjfKXJQU00jZolIykib55
X-Developer-Key: i=shivankg@amd.com; a=ed25519;
 pk=2l2QGTeXuGkZTtfmx0nPQU8iFZfjYmX/ymMojitevx4=
X-ClientProxiedBy: satlexmb07.amd.com (10.181.42.216) To satlexmb07.amd.com
 (10.181.42.216)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL6PEPF0006C3E1:EE_|IA0PPFDC28CEE69:EE_
X-MS-Office365-Filtering-Correlation-Id: 4be09906-4d54-4935-4eaf-08df334c4abb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|23010399003|376014|1800799024|82310400026|36860700016|261009223027099003|261021123027099003|10067099003|56012099006|18002099003|22082099003|921020|11063799006;
X-Microsoft-Antispam-Message-Info:
	ti1omnjRJ0zSIt/15hBauuogN+6Le3iFhyOVirAr3zM4BuvI5ju614fvRv6gptsy6EocuHHcmFrY0PtVWFef92d61tlpcT5owG1XAQVCPmEmFnDtX2XuQjYb2m8s+X9k0YBsMxpmt1B3FQv2vTyPciNPG8r5k3Lz0lOvF6Lt5Z8icJhVbJd/O6QyqVwH8OVDTKDsSfZf6qIoRBZmO0nSgMn7iVFOVGcaCuRBbLrvZiSdhHClBURlgKFcL2rTESQ34fA/vH37gOYlLSoBT99p7r8MEjupfXQWYV6I8Zf1HhlzMa0jrPl3ODI0DydnYB4kwUgziPL+p6mdNeHdiZmdauQRjtSSBy0MvcMetJ047kKnyB27d+wzNaFqxnNjRQYeIZwUUbN00LBh8GS4J6llQJ7E+O5qt1mphYNvMXLmwaT6JESjXiQfJEFyvMDH80/FH4Yg5iRKJpGzbFJq7ih+UerqDEHd/Jv5KFRGsCT48Xr0qQxeMhnsriZU9hUFvMFBDL+x00/CTZmCB7bEefjF5JMPWWvGhGws91/2qvIp4naT/lxCSBh6vyE8xBJAyKiDpaLiB4jxtytHEJxdrdD6SvJ25kqyxw9boAS3Rap4YjEF/8HTjA3yziBV5T5+T50v/d2CjsLIz8SauTdWflEuEdEJtlLXo6C9K7YOoKV/+O29k/W/LQxaoj43OjYNqguw1Pp6vt7s0jGn9wRq4hsKxzC+RGaSgJHfib7Myxg+Dq8B7sPTQxyPhI0s3UaFas7e
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(7416014)(23010399003)(376014)(1800799024)(82310400026)(36860700016)(261009223027099003)(261021123027099003)(10067099003)(56012099006)(18002099003)(22082099003)(921020)(11063799006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	WyRlMVee1i0Yc2z+ZFugOkxhAS9bSSjGqlRk5drM2cMmDO9gxCEfmhp7tSaJV3fNNxKHFwmE80rKRUKBe+RIWzHLMcTmekW+cV/mGcuzMs4gjd2ADtXyqkXZx+ZSoulwmVWyNUKCua1lQkA5PgpAE59UU4RKSZHnEi+h+zBR2vgmfzoWAp7cAkEamG3AgtgLEksAvxcBoqY/cDcKkc1gJRhqzW89JOIgxL1JQyTUtLFWv3Gcwl5rbGbV/ozgkceC9TypcPyJdvAVwdryHs+JfhKhQqD0IC5x+krsOrPcgZlvGpyGlrvG7UzwhUOpFz50vlU0+S0XkzHizKBW8J5W4YvFPJSRcdfenYITpTNR5U3Sl/wk1ZiKqFl6pa0qPffpEWinpo8T8xxxZFlITvEZB9ThCJCxIW1AlKARzRkNZetn0UW8AIoWDqpbvsrwjHjK
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Oct 2026 10:31:27.3797
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 4be09906-4d54-4935-4eaf-08df334c4abb
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL6PEPF0006C3E1.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PPFDC28CEE69
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 7DAC01C000A
X-Stat-Signature: cq19wa51f4z1eapsh578osroqqw43zjt
X-Spam-Status: No, score=-19.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793010693-886040
X-HE-Meta: U2FsdGVkX1/qIhF5gf1Tl3aPFQSMw7qvLbLTLqWgq71ArQsdvfsqwPxqkhpeD0PlXZWlg3GAq3xqGzaETD7vqeOvPfkAflFD71c95TFSJi+VqXkjK6viatVAFnoO8hPLxCw/YY6M/nSnsJvWRZ/WKt3x4ZlM2g0yx4PQ2qxSzppSsYGeUlSL92lWd9Y/pFfY8klFWnqkAV6TgCHgC4LLwudOdIh5VPLvvBwq4spaTTVxDDq3yFIleM4NZ3h0hp/zYdOPIyzZIrwHJTWxSher0MtP5AHGA/BTukBYict41LpSTHSe+j0F4BPewh5/XJnwwcELm93OrvS2rFc1CJPMTFr4Cutv6va4A446DcaBjfOc/p8E4Q/2OP/GQPqD1FFBBuuYwkQltl/uSP8On6Ft9QG6o/SSbbaCEzszLFOyTTGNK0p7/TDshzymjl9sze+mLK4Q6O0KpxS4E1Yfx8LXtFR1MByLTGstJs3BOXrRmGqkHnXQINnXBMyN9uGdyrVZM2c/xYEl6fjiHcD9ZLNZOxT7A0rqicbWx88cO8CvSVw2B8XG+t/o6rXobJgPu51E8jGPVp40FHt5IxCRGmEkXW8rA3HBH+v8t/jfmul6iZC/KlOOxOtzr6QFPzYYblGSKUreblY0ZyOaE4EVKIYRuNl1127V/tPx5mjzXXtMifmnUOO0x68ileZNqsKvggv/363rLlj4/imw7tbKaVu4RhtRIzew5fS/jMalvySMwhIx41AYBBG7peXiAE/9LXwP0/MqHwvCaktBhLFQtZBqKe5OvL8aUG6TzsB8RRN1dPQ+u2Px2yTxknflJ2DCRsLVdKx1erlZ36MbhUym6/spQ5P0Yvqad/ChDpxhO/2byyTHZriCZs8yKi6hKvcaAJzpesLn55eZejTGEaZOydtTnZBmULVqQJ9rHcg7RBVJ0yjzqLkMmswyRk/nMYxxBPaMvgfYzrAGfcaeG4YTpYw
 SerbQQez
 iDTGLLQALqyorZt8DPTKb6SbSp4acTUVrADpzT53MwSBA3XcZdzeWpgPlFW5l25IeoOiDtUZWB0s8MaCvFR835hYSIVFejIXEMF4JGFzW7EotonGu1hHcu2puyVjPRnB5Hd07VhZBBQGpkIYzS2H6OCqXh4KY5rOrKETwJvBn9XpESHxgOY0GV2+ebPW/zFNAt5+Xu/Qfnowo6uM/oERANlRmmeTPvGxsPyI0mPYEXZNg9vtVXZzca3PA5c9u2k7lcwyvEvdQAXli0CP0u0+40VKW3IEno/6ynq48hB4wVrPFXfSztncN23cJ0H+hV1eV8VfcnnevPBxiqsU/Xox2FeWTjLjFDBzUOX/7mBlMJ51Kx7i3PT53DrKQfIDHLTTL93hjGHEMG/0mad3LBZ6uWqD6LNT4mfqNL2jd8D4On6kSVkjAv1nZsfTH2g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

__zone_stat_add_folio(), __zone_stat_sub_folio(), zone_stat_add_folio(),
zone_stat_sub_folio(), __node_stat_add_folio() and __node_stat_sub_folio()
have no callers.  The last zone_stat_sub_folio() user was removed in
commit f1ee018baee9 ("mm: use __page_cache_release() in folios_put()").

Signed-off-by: Shivank Garg <shivankg@amd.com>
---
 include/linux/vmstat.h | 36 ------------------------------------
 1 file changed, 36 deletions(-)

diff --git a/include/linux/vmstat.h b/include/linux/vmstat.h
index 5b31d8e7ae40..953d8ef65400 100644
--- a/include/linux/vmstat.h
+++ b/include/linux/vmstat.h
@@ -425,54 +425,18 @@ static inline void __zone_stat_mod_folio(struct folio *folio,
 	__mod_zone_page_state(folio_zone(folio), item, nr);
 }
 
-static inline void __zone_stat_add_folio(struct folio *folio,
-		enum zone_stat_item item)
-{
-	__mod_zone_page_state(folio_zone(folio), item, folio_nr_pages(folio));
-}
-
-static inline void __zone_stat_sub_folio(struct folio *folio,
-		enum zone_stat_item item)
-{
-	__mod_zone_page_state(folio_zone(folio), item, -folio_nr_pages(folio));
-}
-
 static inline void zone_stat_mod_folio(struct folio *folio,
 		enum zone_stat_item item, long nr)
 {
 	mod_zone_page_state(folio_zone(folio), item, nr);
 }
 
-static inline void zone_stat_add_folio(struct folio *folio,
-		enum zone_stat_item item)
-{
-	mod_zone_page_state(folio_zone(folio), item, folio_nr_pages(folio));
-}
-
-static inline void zone_stat_sub_folio(struct folio *folio,
-		enum zone_stat_item item)
-{
-	mod_zone_page_state(folio_zone(folio), item, -folio_nr_pages(folio));
-}
-
 static inline void __node_stat_mod_folio(struct folio *folio,
 		enum node_stat_item item, long nr)
 {
 	__mod_node_page_state(folio_pgdat(folio), item, nr);
 }
 
-static inline void __node_stat_add_folio(struct folio *folio,
-		enum node_stat_item item)
-{
-	__mod_node_page_state(folio_pgdat(folio), item, folio_nr_pages(folio));
-}
-
-static inline void __node_stat_sub_folio(struct folio *folio,
-		enum node_stat_item item)
-{
-	__mod_node_page_state(folio_pgdat(folio), item, -folio_nr_pages(folio));
-}
-
 static inline void node_stat_mod_folio(struct folio *folio,
 		enum node_stat_item item, long nr)
 {

-- 
2.53.0


