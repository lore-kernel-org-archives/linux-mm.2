Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 95FC5606A331
	for <linux-mm@archiver.kernel.org>; Thu, 19 Nov 2026 07:12:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=amd.com header.i=@amd.com header.a=rsa-sha256 header.s=selector1 header.b=4CPXmzwt
Received: by kanga.kvack.org (Postfix)
	id 701776B05C2; Thu, 19 Nov 2026 02:12:42 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6D1F36B05C3; Thu, 19 Nov 2026 02:12:42 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 54BC56B05C4; Thu, 19 Nov 2026 02:12:42 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 2DE566B05C2
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 02:12:42 -0500 (EST)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 9E88C160996
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 07:12:41 +0000 (UTC)
X-FDA: 85451000922.15.8BF3358
Received: from BN8PR05CU002.outbound.protection.outlook.com (mail-eastus2azon11011046.outbound.protection.outlook.com [52.101.57.46])
	by imf05.hostedemail.com (Postfix) with ESMTP id 7439D100005
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 07:12:38 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=4CPXmzwt;
	spf=pass (imf05.hostedemail.com: domain of shivankg@amd.com designates 52.101.57.46 as permitted sender) smtp.mailfrom=shivankg@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1795072358;
	b=vB6GiJI/X53j9jIP+NnD+eFtnBovWvS3K4sqAObA/cu9pCLu+dcqY/2kFgWz0W6BC5I+o6
	Jwpo3M8lDbeH0SlOn4TzMgIDJChK6hT72mgYCiijvajYe+WkbDFyWJhQaIw3johcNYzRXw
	2xLtN4PDdHQj+5/EekRjaAHo/ljMswY=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795072358;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mDUR9OlYxpOdR4m6M9fUJWQ/1HFKG0i9lVnT8w6iXRc=;
	b=DSRuE/RcBmZ2PJchLSjMarSHZeelmcTjOIklnmKVOeRLSW9MRwa+hETl8edUKhbc2T4JiN
	h0Tjt6CM/uXgyEAwpMiq11N/CIu1EMqwaYuV2EDPE5GfxI8Qo9T1uuwXWTnTdyc57j3ell
	QbmI/AjtV60Ns3OdWy3nZK04/rQHsbo=
ARC-Authentication-Results: i=2;
	imf05.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=4CPXmzwt;
	spf=pass (imf05.hostedemail.com: domain of shivankg@amd.com designates 52.101.57.46 as permitted sender) smtp.mailfrom=shivankg@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=JjIW04WASzjxwv7CG1Cny606cyrDKall5dJ5MITh193pRCZBpQVpGjk5X7BZIINTv+wxTfdeoOy3WhB3HhAm3RX/xjKrf0jrM9xxvtmmTahmiXLauFqMy3Xf9MMMkHGWon/7pnoJRdHaeVflEak1A7KcnzRs6NGI4MreuP4RItdC2HZ3pV5npGkf6/PfdWgdJhyaapjLawFEekmg+u7tKpHKWq/HPNqJhp27xn6kjyVvZb2ZqsuS0bVGI5KxlZ5Kyk9nnsb2fjETUHTCrr+czYQm33hY/9cj8qWWZd2GLZ035+w+ZU634qwi/PGKrLdYaX1qFczoY4n+Y5LuZxB5/A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mDUR9OlYxpOdR4m6M9fUJWQ/1HFKG0i9lVnT8w6iXRc=;
 b=GdrrMwneqQq8slQCfRchYuO58/qBkytR+63R5shtdN1NrJx+m/sR+iJ+X+gCwuguw8vX7pWCnLx8BvOFO5lgQ9crI7pL/7LQ9+X8NZvor35DENKYkjJHI5i4bab11OhsvPF1CbsLjABF5MHQxVMEaW/5tFtL0LXVZY/HCedKaKhZIYFesA1Lsz202iqLtWvd9LqJVi0pI+ahFDDruz6Iffm/dtwWx0EhaHoflYX82J9bEmJCx1guuDBhhfGegnYRcq4BNXoRkvgQm9+n6+hVNnmoLesTtunW9pEccD9ddYrgGm6vtC6JqHyTJH2ue9XSYfFyzauvajK+8xdgWvikxg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=google.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mDUR9OlYxpOdR4m6M9fUJWQ/1HFKG0i9lVnT8w6iXRc=;
 b=4CPXmzwtBSPUvJfWRjfS7GtoKH9U1+A22/pF2YlS7oInlICO0F698f+gFP9ULoF4ixRDIr88Zz7Sq64kLjFpPQ8f1Z0vN9IOMYZXACi5sdTBdMxmey+19f65QUQuHJygFxF8RDnhKSEab/q2aULhv1QNu6yKIX+LxWFMXXLvzNY=
Received: from SJ2P220CA0002.NAMP220.PROD.OUTLOOK.COM (2603:10b6:a03:5da::10)
 by DS0PR12MB8247.namprd12.prod.outlook.com (2603:10b6:8:f5::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.14; Thu, 19 Nov
 2026 07:12:33 +0000
Received: from SJ5PEPF000001EE.namprd05.prod.outlook.com
 (2603:10b6:a03:5da:cafe::2f) by SJ2P220CA0002.outlook.office365.com
 (2603:10b6:a03:5da::10) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.615.14 via Frontend Transport; Thu,
 19 Nov 2026 07:12:33 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 165.204.84.17) smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 SJ5PEPF000001EE.mail.protection.outlook.com (10.167.242.202) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.639.5 via Frontend Transport; Thu, 19 Nov 2026 07:12:33 +0000
Received: from [127.0.1.1] (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.57; Thu, 19 Nov
 2026 01:12:27 -0600
From: Shivank Garg <shivankg@amd.com>
Date: Thu, 19 Nov 2026 07:11:59 +0000
Subject: [PATCH v2 4/8] mm/migrate: use a dedicated list for hugetlb folios
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-ID: <20261119-migrate-refactor-shivank-v2-4-f4535bd0bc52@amd.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1795072323; l=3642;
 i=shivankg@amd.com; s=20260518; h=from:subject:message-id;
 bh=7JSM8mX8+Z+5w4ShySRyVFTzDCmbEfC2r6YNZLpywhk=;
 b=j3jvQYuryr86dx44y9T7xYdSeTNb5Pox3cpaREO8CotU/24NRhNu/C6evrc1lj/D8wanU1kBc
 cDefHseoFmlCNg5i4YpZSNs+eezDVoktnitBSh67MyZG3UsxcDW6bRd
X-Developer-Key: i=shivankg@amd.com; a=ed25519;
 pk=2l2QGTeXuGkZTtfmx0nPQU8iFZfjYmX/ymMojitevx4=
X-ClientProxiedBy: satlexmb08.amd.com (10.181.42.217) To satlexmb07.amd.com
 (10.181.42.216)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ5PEPF000001EE:EE_|DS0PR12MB8247:EE_
X-MS-Office365-Filtering-Correlation-Id: f1df79d0-877d-4d00-7fad-08df460c7b39
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|36860700016|82310400026|7416014|376014|1800799024|18002099003|22082099003|261009223027099003|921020|56012099006|11063799006|261021123027099003|10067099003|261026140227099003|261102123227099003|261028144727099003|261022105027099003|261021121427099003;
X-Microsoft-Antispam-Message-Info:
	9Gr9UC5MNtTdB/PxicjFM/mFWM+JMgyd067cwA9W9lOrg6A9O6Yndkb+cG54f3dcWH0vfAgVba+GHOvZdWKkU7s2uVOcNpPbLCSrtxW1YitsuiPzLGpIqbZtBodKzABIti4POfqz/6iJnbHt9M63qJMMWAAz1iLRusOS640iNhCRaRJs5BLNXeEHcXFDOr97paEesaNo5MFNgr5qD6NNnTCJ9p39fZONg4xYWVf6uUgIb5WpFEZ6k5ZtYyHTEqzWR5+4kmLyGb8b4EhV5IM+/zzV5eyHVIzZLYg++Itdp5ql4StMG7M8AJYJQfwYoyyGAjAfuJfHOdMwufLxfxL5BlIQftXWyB45+ULIBZWKr8xQ/NNZiL26ErmNwvYUS2ufbcb/Q1Wrm+X/gP1gI/rJ7kbyo4wRmCcjmr1Bw7ci8rax1VJDFlKhFVFMPCg6zG/3nqhS7oeBz8cLBNl/CuzxGYmT7lgpuEkjOvt8+aheuApu6vOvnN8YLMedLJN0g61iG6myniMW99dnoLnvPDUW61H+oFUOu5g6An/jTwkRG6GdbD9BsSq2cyrZrWVdHoimxyV7VtN+4Qnm9QSmcfGxkF/Ft8AYleYqTNaMivtimLTt+dS3frfLSqKvfGz/0fIWwbEv5JKdks5q48tRavrDfs+ihX/CESkCvHHdFNVS2oxod/WGEJ9QQT40aJNZevf+kbjJbHzU1hvY1XzO8g6mnGp9mM5WvlgNlDJknT7zi5rUxT1L/Nfyfxwo3i7cgdI7
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(23010399003)(36860700016)(82310400026)(7416014)(376014)(1800799024)(18002099003)(22082099003)(261009223027099003)(921020)(56012099006)(11063799006)(261021123027099003)(10067099003)(261026140227099003)(261102123227099003)(261028144727099003)(261022105027099003)(261021121427099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	kJ28PAr33ZKw9pB1ivEftQaSkhM0FKIN5kjvo4HcMJzshYpcrhRTrtKhLHM0xxp5g2pr0F8OFm8Sif5snrSO+8gEp8q5iT9pIlt+x+kI3z13E6HiVexY/mm5wVcCP1h0Fle5ASeKTioHWwT2pTQJCDuHal2/OCH1w48uNSTlCP9jVZoMWtoYpzGFov6N4hW/zzNq+6D5v5UMnVpB0Evw/hAP68Ua1SSdXCwDnqNpFaGLi+k3ZbK1kb3R/HnP3ezhD7EF5WzWu1fIfGnQEWIoFCWX2zOeD/2Zz98HHUGCLgZMtLVvOSmSGWoRSuuN3kTujXW1TIwVW9PRLDFpoJI1cTJqlnSszdKiTdaNb48PQq8OGvgt3y3ngwk4XnfEjPI7I3iYQEqzIP/I3hGvkrqzvWX6iLscp5ONjWGJlMHWRnhbAHt9z7AwFiOrWbTAjUtz
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Nov 2026 07:12:33.0048
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f1df79d0-877d-4d00-7fad-08df460c7b39
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ5PEPF000001EE.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB8247
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 7439D100005
X-Rspam-User:
X-Stat-Signature: u89azendbqsiim4nrw8fbyaezinitnns
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795072358-249361
X-HE-Meta: U2FsdGVkX1+fUhlw8/cNvk0cM7ZVjdB0r1Eo1zFexMFyavWP7mo70mmpacf4dKdh6WIkXP8pUgu7UzI19qOYiqBL0LoLaZbQZ4ix32SO+Yvoc6DkxdXGAQ5+7ao5ZkGnFNZS25Qka+kNmReNCfjogNSo55siIvg3OkelsfeYC4Yrpc3JFL9CdF4//SI2RuJQelT97ZJlkGmpuvtZAwL2MSU6cU5ABsLduT2Z7YtUBFzIALawM+J4P+yTH0gIdn60Nnm8sVMwY6ceSv/w0c0l9HqhNnw0D6Ra4LkyVsPIt7Adz9mrKRCzr5OkYhktvK8+2OqtM9+6zFCNX/9SmPy+qVPYfbb0YUP/E9dqSIt7aLfQ0VgZqskecHDWBIOC320v64qqkiUr/fZ+w3UZFN0j0JsePh0Zap4I/KvD15i7iy3QXCu0MAwNykVRvuRBbSfcvBXIJQbVBjj0oNBaR62Wr/jcull4phrMjf45079qQmawtF6Mkh8KZFbQGvFqxXKcVtlOPWiNd3jdqsaQROqrcCk4x65hLte22+r9JCECQmwRJ9a6Ubhq3ydCb60mIk223pu+TPWH9/8sZLmVR2ruFRxcpPtP3k2obOucm7d4AILzE2h/PwSA2PXS4usiHMIVa0o8/KK6qRYOMdPaC4q16xx++tm2ouWFNWZ7WZKFCnJkPL1o2uJ/DkxgqKPonWOFeslhmx6q4NQ48CzBHE6OYbFwKHr5ODu5sfqtz44IKjQQeQt7ZF5iL6Wm9PVfuBIwP/4Fx8VPSH/0fE6vSvmZyQ00DpptOR10ZEnvVP3GAt6jbxcNJQSvA0GS+kEQhgXzqFBQyq2ZyJfqJzTshJaxhbPI7mYQ9HogmSX4C4jg/Y/ee0uOsO7zTuKO0DjaC6uofsKX7GfPPlFe5xOIRxCTa0zaC1e/SavhlZtWdaJXcFanpfy6WfvMbvcMsUNHyXSNASQYIRcompGEIu2sMMh
 1StVUYu0
 YXNBwKpvtw7kPRd0TZooopR7Kw4SX4iLjs6NIrd1ttyJUj+km5Inw9Qz5C2pbkFY9rEqSGImYWWwnQhHjLRaC7opoJlpVmeEa50lob5AKLuxrjEBs7ugc0gBJinKHNK/gndd5NKjialZiFfVBNjKG+eGxATUQjWTJAlXw0wZjx89M2dcryOHCfJBGBN96sUf+eETogglj/r7PVAvHD9e08hu188XXeat+3ER0wf7MuIH4bxM9GhcLlCzcwQoHGsM1NbzMjqhWB7diqdm4cTyePmVTBNQuStRrT1v+zCAiJQWpbM0pgaO7gT9DWXtFcdPQX+U169pR6zsVacNv78t8ypmT+f+DM3LBDUw6A2lUaG2KlgsrJjRzPDoSE8bc5BIq5vRCCb8aLNekMh/AGdXWqjki9gjhgaHm5XqxIAPcaUBCtLzaHeoDt1EkuAy/zQQpBtrtyNe1XhEvuEoJU5/qW+QhZF5kYdjm5Ml+IcpivDgP73aK3pXYThuTT/04hs+DZ+ngFmXKZb3EBXfI+f40LG4LRZrXA8DiJSxLs5TorPgHT9QO2HYoZ1N8XwedEDb9YrV4c834CyH9VYybrMLFFrQaoVsxzmbGKN6mumpdpx5IvkaBsd3Q83iovc2kpY4UdVw6D4+BDkb9oC/L1+82Ggn76w3XsyyBDN0CVcs4wR9B7HPPUgjH8h9y6VuLcXE0riHs4MGTGmCt0o/6ilDsWjI0H/f8M9TukfT02NPCMN4nc647AM4KuC+BM/cSWZCTbqvmhJIKs8Ml9Ds6xt/APDDdTePQNdoUNNdgyzHtQdi68tYiTxysixsONfJJJTKSsHaV
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

migrate_hugetlbs() scans the full source list on every retry pass, even
though it only handles hugetlb folios, and migrate_pages() then scans the
list again to set aside hugetlb folios that exhausted their retries.

Move hugetlb folios to a local list in migrate_pages() before migration
and let migrate_hugetlbs() work on that list alone. Whatever was not
migrated is put back through @ret_folios on the way out, which removes the
later hugetlb check from the batching loop.

While at it, fix the function comment which was copied from migrate_pages()
and drop what is migrate_pages()'s contract with outside callers.

No functional change intended.

Signed-off-by: Shivank Garg <shivankg@amd.com>
---
 mm/migrate.c | 30 ++++++++++++++----------------
 1 file changed, 14 insertions(+), 16 deletions(-)

diff --git a/mm/migrate.c b/mm/migrate.c
index e4e3d1683d1e..3dfdf46681e3 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -1662,11 +1662,11 @@ struct migrate_pages_stats {
 };
 
 /*
- * Returns the number of hugetlb folios that were not migrated, or an error code
- * after NR_MAX_MIGRATE_PAGES_RETRY attempts or if no hugetlb folios are movable
- * any more because the list has become empty or no retryable hugetlb folios
- * exist any more. It is caller's responsibility to call putback_movable_pages()
- * only if ret != 0.
+ * Migrate the hugetlb folios on @from, trying each folio up to
+ * NR_MAX_MIGRATE_PAGES_RETRY times.  Permanent failures are moved to
+ * @ret_folios; any other folio that was not migrated stays on @from.
+ *
+ * Return the number of failed folios, or a negative errno.
  */
 static int migrate_hugetlbs(struct list_head *from, new_folio_t get_new_folio,
 			    free_folio_t put_new_folio, unsigned long private,
@@ -1686,9 +1686,6 @@ static int migrate_hugetlbs(struct list_head *from, new_folio_t get_new_folio,
 		nr_retry_pages = 0;
 
 		list_for_each_entry_safe(folio, folio2, from, lru) {
-			if (!folio_test_hugetlb(folio))
-				continue;
-
 			nr_pages = folio_nr_pages(folio);
 
 			cond_resched();
@@ -2184,6 +2181,7 @@ int migrate_pages(struct list_head *from, new_folio_t get_new_folio,
 	int nr_pages;
 	struct folio *folio, *folio2;
 	LIST_HEAD(folios);
+	LIST_HEAD(hugetlb_folios);
 	LIST_HEAD(ret_folios);
 	LIST_HEAD(split_folios);
 	struct migrate_pages_stats stats;
@@ -2192,20 +2190,19 @@ int migrate_pages(struct list_head *from, new_folio_t get_new_folio,
 
 	memset(&stats, 0, sizeof(stats));
 
-	rc_gather = migrate_hugetlbs(from, get_new_folio, put_new_folio, private,
-				     mode, reason, &stats, &ret_folios);
+	list_for_each_entry_safe(folio, folio2, from, lru)
+		if (folio_test_hugetlb(folio))
+			list_move_tail(&folio->lru, &hugetlb_folios);
+
+	rc_gather = migrate_hugetlbs(&hugetlb_folios, get_new_folio,
+				     put_new_folio, private, mode, reason,
+				     &stats, &ret_folios);
 	if (rc_gather < 0)
 		goto out;
 
 again:
 	nr_pages = 0;
 	list_for_each_entry_safe(folio, folio2, from, lru) {
-		/* Retried hugetlb folios will be kept in list  */
-		if (folio_test_hugetlb(folio)) {
-			list_move_tail(&folio->lru, &ret_folios);
-			continue;
-		}
-
 		nr_pages += folio_nr_pages(folio);
 		if (nr_pages >= NR_MAX_BATCHED_MIGRATION)
 			break;
@@ -2248,6 +2245,7 @@ int migrate_pages(struct list_head *from, new_folio_t get_new_folio,
 	 * Put the permanent failure folio back to migration list, they
 	 * will be put back to the right list by the caller.
 	 */
+	list_splice_tail(&hugetlb_folios, &ret_folios);
 	list_splice(&ret_folios, from);
 
 	/*

-- 
2.53.0


