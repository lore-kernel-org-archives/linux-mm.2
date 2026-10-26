Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3FA53606A334
	for <linux-mm@archiver.kernel.org>; Mon, 26 Oct 2026 10:32:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=amd.com header.i=@amd.com header.a=rsa-sha256 header.s=selector1 header.b=NcTNMk3M
Received: by kanga.kvack.org (Postfix)
	id 59AD86B05B9; Mon, 26 Oct 2026 06:32:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 54BA46B05BA; Mon, 26 Oct 2026 06:32:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3C5236B05BB; Mon, 26 Oct 2026 06:32:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0FB526B05B9
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 06:32:48 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 9A5F2A8193
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 10:32:47 +0000 (UTC)
X-FDA: 85364413974.09.8F285CE
Received: from PH0PR06CU001.outbound.protection.outlook.com (mail-westus3azon11011067.outbound.protection.outlook.com [40.107.208.67])
	by imf29.hostedemail.com (Postfix) with ESMTP id 6FDCE120005
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 10:32:44 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=NcTNMk3M;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf29.hostedemail.com: domain of shivankg@amd.com designates 40.107.208.67 as permitted sender) smtp.mailfrom=shivankg@amd.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793010764;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=C69q8YVfbq6Wnj5phIjJy8NVq8cn1ZrzPW8sluVzesI=;
	b=gjGBI3iNv6fBjlT4UyzlT8klBDKn18tVpPGvo+4nfUSasyqsHc2YqeBt6Mt+a9P4t8aQBU
	CnBjqrGP6gv0+vZn0OFoIeeI7Mt573bjH0Ms8Bn85128ckXIyWMKCXs3H2Gg62ezFgHxmR
	+agVXkoOkM/o3lzIeVoV8hV/ioETeoI=
ARC-Authentication-Results: i=2;
	imf29.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=NcTNMk3M;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf29.hostedemail.com: domain of shivankg@amd.com designates 40.107.208.67 as permitted sender) smtp.mailfrom=shivankg@amd.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1793010764;
	b=f2EWOLXBFmjV4q1qoryGQ9N5jmssAb3d0iCvs+Otg2GlCsCCF4xYA36QC3m6MYGVdfy+Y/
	xD6WdWmwp3D6bpawVyrENSCRWCDgBRd5QIHKtPM6swuoiVaVhCIxfVBSPQJja44Ccm3uc1
	yjX93pEmG24QdGYt4Rlqu9V+1hcsq+Q=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Bp8KxC0s/dX3bLxUPaiuAmGf3y+ztkN63c2rAir0DKn6xpgroyLGAV4YS1FpsBSZ6OeN3K/s52RjzELNIr3GiFMTCvZxTKVfwaq74uXB3F0CcJqSzwrLNrk0T1wsvTJek+9TYsdH8FhAlIEKrhovUOE/yKtw8bPZSvmWXwj1XzL0aNjRP2nqagmjXrjHIy5sGxa0yiDx0r0vondw7ncNhf0PHvqYVC4iG+E+m3L36673O/LugMQWWw7cqVabWoC3VqGALSFn5ikl6olKA+6LijOvSoFxR035xrBBurt9dCMfKGCBkKfjl+F7OWKG2h7u3zcfTMgsnpro8gyo5AqOXQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=C69q8YVfbq6Wnj5phIjJy8NVq8cn1ZrzPW8sluVzesI=;
 b=Yr1cnY/5uUm0UnR9vFTrcta+0OzzLHaMV73d7ov5YTpp9b4AFzQ+mOEWCAbLngCHJMXsz9+et21LkvcBtlsn+sJbZMFJvpeT4MSe2NyLv/TTPKnE60rmbKwAYrmXuuIlwqdllKh472CXJHtf3QthtTQK+nZ7fQaZYOx4sZmQrzCcRLPVlkdaK/3GQcvEK4I+F8UrMxwlP7Qy33E11c/EUGSBSIKihfEyXmF6pXPVl4GRpvGgA5X7+NIJ4g7vS8YKAO0hsu7cm/KxlOCk9AvmLuJ783KpRKNzDFPujbat33GAXWbB1YJJ8X/TXuNFm8wk2NzaOXcK5ebkmJSxFZ6N6w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=infradead.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=C69q8YVfbq6Wnj5phIjJy8NVq8cn1ZrzPW8sluVzesI=;
 b=NcTNMk3MpoZKXq5C30SkCEPBnaj8fbFt8z3yR94iytzk33Z1b0cLJGrcYqWPSxB0Bn0+0zQpsiq6bsonwh7qPIvNLzJfycrPQ3ztsItOZ4TKcKZjESE2d3fVeRSCOW2FKelqbuEsTQiIjALWw79utPWfydHThwY7D7S9gemj63A=
Received: from YT3PR01CA0029.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:86::35)
 by BY5PR12MB4162.namprd12.prod.outlook.com (2603:10b6:a03:201::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.546.22; Mon, 26 Oct
 2026 10:32:38 +0000
Received: from BL6PEPF0006C3DD.namprd02.prod.outlook.com
 (2603:10b6:b01:86:cafe::6e) by YT3PR01CA0029.outlook.office365.com
 (2603:10b6:b01:86::35) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.546.22 via Frontend Transport; Mon,
 26 Oct 2026 10:32:37 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 165.204.84.17) smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 BL6PEPF0006C3DD.mail.protection.outlook.com (10.167.249.232) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.569.4 via Frontend Transport; Mon, 26 Oct 2026 10:32:37 +0000
Received: from [127.0.1.1] (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.53; Mon, 26 Oct
 2026 05:32:25 -0500
From: Shivank Garg <shivankg@amd.com>
Date: Mon, 26 Oct 2026 10:30:35 +0000
Subject: [PATCH 7/8] mm/zsmalloc: remove unused zpdesc_lock()
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-ID: <20261026-unused-sym-v1-7-82ca2dceabe1@amd.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1793010663; l=774;
 i=shivankg@amd.com; s=20260518; h=from:subject:message-id;
 bh=pV2CJt/tj69awn4Duh9GB/gFNsS3CYaXfVzki/FvS/w=;
 b=cfJct9dDG3Rb4zakj5xPViULlOXvo8YGBrJPsYr/lIe1RkOegXg5a8F3i3XZyz+fOedVV6alz
 Oos4EYAz7F1DyTt9/HV0FY7mGL8KBTvvUaX6tv6T54iv10eMEIUjaUf
X-Developer-Key: i=shivankg@amd.com; a=ed25519;
 pk=2l2QGTeXuGkZTtfmx0nPQU8iFZfjYmX/ymMojitevx4=
X-ClientProxiedBy: satlexmb07.amd.com (10.181.42.216) To satlexmb07.amd.com
 (10.181.42.216)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL6PEPF0006C3DD:EE_|BY5PR12MB4162:EE_
X-MS-Office365-Filtering-Correlation-Id: 78c1434a-339c-46a3-0826-08df334c747d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700016|23010399003|376014|7416014|82310400026|1800799024|261021123027099003|10067099003|56012099006|22082099003|18002099003|921020|11063799006;
X-Microsoft-Antispam-Message-Info:
	VfIRwhjfUx/TB96SXFH8IUtYbnJkZkZiCyC/aeGisK3Rh3XTJJzfIjsCG9RnotSASRztCJXPNr9qvrb2TNb8UTh7fc0zJ0V6URWJhNYAVtQuhqPfTcWNo3W4mylqiFn14/D3ysggLpX6sPdj+/na7pm4DQnmq69aKdsLOzNir0f1S9+TxENtE++jsSUlFUARRGHr5ugKAIyRIgqbNBi12NxQPLtfBBZpX2bKs4n5Krdgq22RWOVixNjpKPywS3GNsBIXzBi5Qj2eqBxvB4PL7rSmby/2rD5Cx0SIXRhtPPwjuFx/iYqlZ5ccP5GGqCl3aJo1lS8QdrW6GarFX0Ti6BzHbcEyATRIyPh5ricOwmlbul5UQe0WTSVPMVAR4ZQynfYvocelsCKyHHcSkg1sVNtrYEkcQn+mEDseQ5jbFX5e5dE/5ZLrp2DVXfstJpaWNHMzPscwx+u1Z9O7y8vtz79wMNleEN7NhNDTU3dkVgr4KM8fJV2sI9fjhcTK9hArws6dgR9pvMfSL6y1vcr8WUdBTusceHYHzquWqeX+epDnDQuE7EK9dzL5EgoB7yhWLyfY7KeHR/By1Zj8+uBnJHS/S7o1GTr3WuzksXWoRMAQITnUGq4TYI1Jl0oLHEPaYrDDci7tclYfHrgDEqMDb0uthh5muBDGie2qu4lQg7usCTYOy4M1UI7XL1uqHSEk/7+6Iz5i2WfUwwWl+WrjVS5L8t/cTlHWshNeBJIEJnltPd6/Aebn/wUCNQRw1dqf
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700016)(23010399003)(376014)(7416014)(82310400026)(1800799024)(261021123027099003)(10067099003)(56012099006)(22082099003)(18002099003)(921020)(11063799006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	XscwIhuvR9Q5CdmVBAN3VKSqRX5Nbyapr/3n8wlBJbzPHqzfDla3xIC8p1zaQRzi+kKO8cIrhyfslyY0J9XQ4sIeozbkiMu5wuNZ6xKZC3G5MqIOd/WVtSGMcB+uIBvOx2K9nVUHJpVjhi+0HoEDNPVFB+IKhZpZLj5rX67Wsp2VFKNb1oJnsXEcKmNC81ku3IsPiUc8jphyChFQuM8a3i3NE6nCHMjdeYZqMuTNOjfR1dR8/osC6RpByzFz0NqPyfmHD1NYD4GQ6znCv5yCfbV5pft/aWr4fs4ZiOrOKA3l+Viul4VPKG1EhwsFo6VPjd26O8NHt9t8PNu622I6FmHNu0KDSFRqEHS3pybAVcyFW1JOuNYeQT9Wf/44jQM+5Tsm2NqGPRe7UtoaizdNCdZYaZ6pgaGxDgyoDkoSXGAesd1tX5zYel8W+0ToBxZe
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Oct 2026 10:32:37.4343
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 78c1434a-339c-46a3-0826-08df334c747d
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL6PEPF0006C3DD.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4162
X-Rspamd-Queue-Id: 6FDCE120005
X-Stat-Signature: jrznsss4ye8x46pk7rq6ntkkinkg718m
X-Spam-Status: No, score=-19.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1793010764-476206
X-HE-Meta: U2FsdGVkX18L2/8MFB4BHF9A/nySxV6GvP1hhg72FN4SLGt9Z6xT3LwmxHLm5JBK/kQhgTTmrdGjdQRRicrG+XnV+eKNadbCtAuSwKmqXieyCXyqkUqTZafSRjx1ph36tpaF7ZUVOXHyfOnrOxRb2NqE6jJA71yAPJLbYx66cu5xGfNq2p2e9BI/cB+55TH0/p0YbSmQJ00R8jBwkp2FL8mAZC5Oe4Sns+tAgMVqUmxMV14yYB8948B2rxCgHUv4G1b/94RJ2L+V1EyhJPhBbjclixjrhgb+iYmp3OqBOWWa5DVLUreX2+WepCBURmVjPs9H+pC7TFOUbXdtUaBvU5ngXEHF6G0H38DxXgqVmikioBKUvacAoseMXiwtukNnK8wuMIkUoninVUTxo5dEnGAX4dzcF0rEX0wOWR7MQOACs3wZCUEsNwQUb5x43WLH6z/Q64U3mlzd2evU9gSVDEn0mSQ0DZWlhyPxkjoi6XCd+jnkSaZOhoAriniPfqJR6eafVfJ3fj1KDHl1XRzUPjrzdSc1Ey4JU1XS/LBkiOny3mguD67IAwLsmmRCbRdM2L4VNYkAULTC6qUmjwrdF+Zc6Bk+GOoDuKYnWWQ16NveOu/M8fOZ+gYpdNQoPplV1B4RJV6seKNypDWPAK7ngsYXmgEJxFHKR550smXzXkQGsWyWl8UXoKXMK4pLnRNPOMlAPRJ+9XTZ2DKV08ozt5Cijge41zunf/PmKvDxC0Bgxf0tLhu7b9r7LrXqQHOe8efpkp/cmqDj499SG2m7dYTgwXrhVoRVQSo55MoDBkaAkkQHb6BsBpmpC/KJENVBU5QDgi730YzSWKRdzTl6fZm+pfx9YQf8APKjZXgkMeZBs6M9Fkpcs1zNZzZRPMHkRRlYNdVCXevp71zuOfesQhkPZ4DB5JwKpvD1moFCPO4n8U/mYcgFFPadZ0N0mC2hV0l08vF1IIxvuJ/C9SL
 y2qjsi9u
 IjJfqDEnphHe39lLTss2mrOcSkEdgENXrZXKXGuuzOBaOry8H5Snjos9vmuziQOt37s6djAwVoLW6dbYn2JIV3KwQKBP9X+q1bfPh6otNxZLQdLzDx2p0X84ems5005mn6dr2eFNV6YoUbhi3U1bpMfzdR672Bduq7uEOH5QYGg1XVi02doWSB3aSVQisRL4vNlwiJ2Jkxd+Rb79onuQqwQWN07uKvvm3PPXpT7ncWIEB5zioq9tNeK1o4MUvUNnDOffkCfKHK4XA+iyn5U3ZQVcQfN0jGbqqyVjyEKQOmsVkAqemMarRbp/4bXMebUzv1G4SOR44QVZ0z43LijusZgarBlst8BhzTJmN4x0O2R//T5en4Xi9PbeHFF5AUKCEesXCYUOkISQ793hck1fIlQLhrYDu59haUr/ekmfMbEuOcWsAbwgmtmATnRk+Q4RyAOt9Ri00q6NN7D0/EZJe8bDMMibUDXA7dbo4qcNaRDGQMBI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

It was added in commit c1b3bb73d55e ("mm/zsmalloc: use zpdesc in
trylock_zspage()/lock_zspage()") but has never had a caller.

Signed-off-by: Shivank Garg <shivankg@amd.com>
---
 mm/zpdesc.h | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/mm/zpdesc.h b/mm/zpdesc.h
index 4fd81c2e8076..aaab5f1bfb52 100644
--- a/mm/zpdesc.h
+++ b/mm/zpdesc.h
@@ -107,11 +107,6 @@ static_assert(sizeof(struct zpdesc) <= sizeof(struct page));
 	const struct page *:		(const struct zpdesc *)(p),	\
 	struct page *:			(struct zpdesc *)(p)))
 
-static inline void zpdesc_lock(struct zpdesc *zpdesc)
-{
-	folio_lock(zpdesc_folio(zpdesc));
-}
-
 static inline bool zpdesc_trylock(struct zpdesc *zpdesc)
 {
 	return folio_trylock(zpdesc_folio(zpdesc));

-- 
2.53.0


