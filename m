Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D9836606A321
	for <linux-mm@archiver.kernel.org>; Wed, 25 Nov 2026 13:33:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=amd.com header.i=@amd.com header.a=rsa-sha256 header.s=selector1 header.b=kltdk58v
Received: by kanga.kvack.org (Postfix)
	id D4C436B0A17; Wed, 25 Nov 2026 08:33:45 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CFC126B0A19; Wed, 25 Nov 2026 08:33:45 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BC3806B0A1A; Wed, 25 Nov 2026 08:33:45 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 837C66B0A17
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 08:33:45 -0500 (EST)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 0BAFF160E25
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 13:33:45 +0000 (UTC)
X-FDA: 85473734010.14.75CC553
Received: from BN8PR05CU002.outbound.protection.outlook.com (mail-eastus2azon11011047.outbound.protection.outlook.com [52.101.57.47])
	by imf28.hostedemail.com (Postfix) with ESMTP id CE568C0005
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 13:33:41 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=kltdk58v;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=quarantine) header.from=amd.com;
	spf=pass (imf28.hostedemail.com: domain of shivankg@amd.com designates 52.101.57.47 as permitted sender) smtp.mailfrom=shivankg@amd.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1795613622;
	b=v+26jdYiKAC8M7wA8Hhncnh9WMDI1m7luFPb/+4yBu7dGCGL/czwcLhEn8kexZoNLPnnKk
	pApiFwQg4bs6UnVDhqSGnMbGd+069RpeaRyeY88u0cSHsAJZnbmeTG26v1MQsKSb3uFGJ4
	0iKI8NnJiTHiXfbiphDQ6LqBd47MSYM=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795613622;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Di100AUouy8HIbSZxAgQP6OL72RBNDlOcNsx034YQbk=;
	b=r9n/kUPHWfYN5XXOwji7p0/J1GRtrY2ZPzwwhdCczsWMqgvZs7guvZCJihHJILhHdkhzZ3
	9gcGAm/GCRsGbP+iirZfARf1TF8pea8b69yFDP/29spaP2nf83Ada1YsNIrZCZFZsVm1oQ
	AnV8KEDFWFUjPbMBidJLGMLnjW4u9Cs=
ARC-Authentication-Results: i=2;
	imf28.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=kltdk58v;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=quarantine) header.from=amd.com;
	spf=pass (imf28.hostedemail.com: domain of shivankg@amd.com designates 52.101.57.47 as permitted sender) smtp.mailfrom=shivankg@amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=o0VeoFZyqk/HVi9u6klchlwdjVtqc7qOMtpPbFDiXVO65aEvD0jD44QDgW3q/xIP5ywGt2sye5cgmMvMZKKfSw9PE8YMnr95q8NnY3ueBuybgLFSgKG7NxiipCMdElW6fTe+L3RpHcclsvOKEoTHRnXJmjAtIr+TNTdje6pKhe0V/SLZNfhoohW+wTuK8V/63HQnRP/1ScK8bfj3yx7xFibB3FkF7iI6mRguzOX4ifnCu7/sNdVNt5AI6IVbN8D6YSuk5NaP5DCcHDpsXp4kYQLQZPzG2ifGfO+l1xtClm6MrrtBBg91Z+9CBQM1EnUZ/Ul9jKXxuGqbCL1CvgEGMQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Di100AUouy8HIbSZxAgQP6OL72RBNDlOcNsx034YQbk=;
 b=X+KDslsodnzAX1WvDNVT4s1sPZ0vrSGDe7ndZktfQA+coFHy/mGcQEZPSPK6d6+g1ZAoKfCPeaFu9EQTXrCUwVFT8Yfcem+PQ1Sac9WRqej9I+9x8X8jz60Qos3f6ZNiFYoRDU5uDCmLuPkLxutU2i79v4m4s0yNlKz4cGcTPX988veTgs7hbu9Run8wVdqRrY6ThnjyNbd7coq58iklvZ1y3tPslV9DdjkMd6ViN/AQxlYMUyjn3s4KeeEYwS9nuvmCRbUQVPV7dEiz5kHezwDEXqmmnW6f5B8eND9s8slYAEzWmtlSAH3AGJ6s5cwtuLz6gS4wbDMevuaY5vFacQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=arm.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Di100AUouy8HIbSZxAgQP6OL72RBNDlOcNsx034YQbk=;
 b=kltdk58vtDcDFXHa7/z94W8S6Ez4BFMPg6mrVhIe507Odn4dC7MoZVoKOu55Nd5JLkCcEoPwhKPHjpRik3qMMmLMQY7+B8r/eWR/cu6aXR4guGwD0iBXNwPVen/MMWhqHeXShx4HrSoxT7na8KV+atKwZadgrMnoAjFwqOv8IwQ=
Received: from BL1PR13CA0083.namprd13.prod.outlook.com (2603:10b6:208:2b8::28)
 by DS0PR12MB6557.namprd12.prod.outlook.com (2603:10b6:8:d3::5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.662.5; Wed, 25 Nov 2026 13:33:32 +0000
Received: from IA0PEPF00000044.namprd04.prod.outlook.com
 (2603:10b6:208:2b8:cafe::8d) by BL1PR13CA0083.outlook.office365.com
 (2603:10b6:208:2b8::28) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.688.4 via Frontend Transport; Wed, 25
 Nov 2026 13:33:31 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 165.204.84.17) smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 IA0PEPF00000044.mail.protection.outlook.com (10.167.249.167) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.662.3 via Frontend Transport; Wed, 25 Nov 2026 13:33:31 +0000
Received: from [127.0.1.1] (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.57; Wed, 25 Nov
 2026 07:33:21 -0600
From: Shivank Garg <shivankg@amd.com>
Date: Wed, 25 Nov 2026 13:32:28 +0000
Subject: [PATCH 2/3] mm: don't let modify_prot_start_ptes() set soft-dirty
 on clean PTEs
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-ID: <20261125-b4-mm-soft-dirty-fixes-v1-2-538e3cdb618c@amd.com>
References: <20261125-b4-mm-soft-dirty-fixes-v1-0-538e3cdb618c@amd.com>
In-Reply-To: <20261125-b4-mm-soft-dirty-fixes-v1-0-538e3cdb618c@amd.com>
To: Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand
	<david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett"
	<liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport
	<rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko
	<mhocko@suse.com>, Dev Jain <dev.jain@arm.com>, Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>, Nico Pache
	<nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>, Barry Song
	<baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, Usama Arif
	<usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>, Peter Xu
	<peterx@redhat.com>, Shuah Khan <shuah@kernel.org>,
	=?utf-8?q?Micha=C5=82_Miros=C5=82aw?= <emmir@google.com>, Andrei Vagin
	<avagin@gmail.com>, Paul Gofman <pgofman@codeweavers.com>, Bharata B Rao
	<bharata@amd.com>, Daniel Wade <danjwade95@gmail.com>, Yin Tirui
	<yintirui@gmail.com>, Muhammad Usama Anjum <usama.anjum@arm.com>
CC: <linux-mm@kvack.org>, <linux-kselftest@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, Shivank Garg <shivankg@amd.com>
X-Mailer: b4 0.17-dev
X-Developer-Signature: v=1; a=ed25519-sha256; t=1795613581; l=2296;
 i=shivankg@amd.com; s=20260518; h=from:subject:message-id;
 bh=YWU8MPhvJEjhyWBDvj3iukyNbxAp387REOo5ckgWbUI=;
 b=PI31QhAdql4qLhm8nTxuazRJeNOQn+mcLhkbodk1TA0OHTFfAmwDStcHbD/ZMasGyDrIvJ7yl
 pdkPZZkJdjQDaSEAlhB571SgAEc3kyp2vIu9V+ZW48qoAWaVYduwsts
X-Developer-Key: i=shivankg@amd.com; a=ed25519;
 pk=2l2QGTeXuGkZTtfmx0nPQU8iFZfjYmX/ymMojitevx4=
X-ClientProxiedBy: satlexmb08.amd.com (10.181.42.217) To satlexmb07.amd.com
 (10.181.42.216)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PEPF00000044:EE_|DS0PR12MB6557:EE_
X-MS-Office365-Filtering-Correlation-Id: a795b51f-1121-4632-17ab-08df4af8b282
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|82310400026|23010399003|36860700016|7416014|376014|261022105027099003|261026121527099003|10067099003|261026140227099003|261022075727099003|261028144727099003|261021123027099003|261102123227099003|261021121427099003|6133799003|921020|18002099003|22082099003|56012099006|11063799006;
X-Microsoft-Antispam-Message-Info:
	hJ5Cjb+AivGrWtQQ54vJR7gm0D5zs9HYpNmOvxtm/vj70sXEy383LdcrMhuCoJ3FY6k+K5Fi0TEpnqPassz3PfBOWIpbvgQFP7jQhT50zFRm+EUzEnZeESxvETi6dlDHTUaijxYzw+KFSDCTXhCO8G7kkcyN4SMQU1mSopq5VeqAgEoc8+gKcfZ/ouRQEWaY7KUCf8U/APtb9y8fX+CNSnMjYUjht3TDBmE8ijKOXVe3AlOQHH3b8pbANozkwpN5/hWV+j4sWCijiR8mmCplvyfRZDmRApvPCDfM1rjN/RNwv3eI5dUJbRkSxnMkPNy0ZxaonFZ9vuW7wuCQWhcR4jK6pAeueY0WnoQDoQ5HZFdu+hSbHxcxPU/jeIwLHiDLfiWfhgxBAQXmvLgHXGrEhpi72S0iCwOVWqONcdnLRUD4ucYBtM8AwJBfn3gYEGCoqI6Y2Aj70QDY0HLx1QpW0YX2D6gS4sGcBZuTDYjqYBuyC1viPFm2K6sUnr2mZ/BGL5qN0Eq8rJRo4mySqsKNaJ4bZjVA5Aqbyi+C1uzrO0G4RrE+jEDbFSllJ7+kyluy3u616f9wWjzcD/B4OjrWSQRgDIqmfvpFth7Oy1EIO8VrZfjV5DWCruteKlI97VCviDZxq1BSXpZzGf+15Lia/815gmov5LtFo1qj5zf59cAOpPQf7PP9o6y00oYi/wUFkDsXriCGsWaExMFwY+mtldsCVNbHXAPCpV5IUCq/gvQ=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(82310400026)(23010399003)(36860700016)(7416014)(376014)(261022105027099003)(261026121527099003)(10067099003)(261026140227099003)(261022075727099003)(261028144727099003)(261021123027099003)(261102123227099003)(261021121427099003)(6133799003)(921020)(18002099003)(22082099003)(56012099006)(11063799006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	yQbd2As2Q4pSIFFJn6Zkbl0CBU6kmYosMYCqXFjUdYKBLzQ6+y6RgJyAIG8sw+C3ol4X8LUlDhhYyGgJufnKJp0c9VK8AcRFiwjl/1sJduHmR/2skme4W/maPasTi8gMoMgxr9uGaN4iy2/GIzvbOJDQtbjYBKlaei++yBZp/hg1Y5EVsAxIA8bci2Qq7VTJPTXGUsVj9s7V0NgWBGEreIgjqFLEgHQXB9q7+NMWdg/YLSyS6ia3m4CtuzeG2FXx4SUVNrztz86dnozev+sWLYja4GnWockBFvaPqU9ixEur3ibZuKE50s3B1vWT5XngCcNsXG0Wlsk6+TnO/aH6yxHWKEtrurT5fZ6UyJsCEqYSTZIa3vmMu5gGx+pZ3vAb3nsum83JvDtKDQcf4Iii+zAyXQFr6SA7lPV4GGD2dfCuUjjPLnlGlmYktKgxf/6u
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Nov 2026 13:33:31.6680
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a795b51f-1121-4632-17ab-08df4af8b282
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	IA0PEPF00000044.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB6557
X-Stat-Signature: 8rwqiq11wecbxk9dqnanxas8ezgbeo9r
X-Rspam-User:
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: CE568C0005
X-Rspamd-Server: rspam03
X-HE-Tag: 1795613621-661701
X-HE-Meta: U2FsdGVkX1+EjuEO1mGV670a/ND/Y1aIZggLPoXZPLPdrFN25NBV5vNDBcpxUYRaMmFzMp9zzROqtg5pSersbLcyzYqLQQ8nRz/yK8FImdN1lyH97x7+/jCbkmN1dbqCfrILMhRvDsIXQQkvTXUpv6L+1MQTnXR4r8qoJxYtyn4VZRjLgg/Pl2I6LoVx7TPSnWSMpPERE4LrGQs4iDKkdjgBrf4QUc0U9FNjJJYVhHcvQXlxgsqthnNEcBbgmsDqZQSxnGy1/VhA6w8zCKeF+xYADXjM4ot/tY+DN1BYQKyWzep6P85igYsE80kNsHlMiYBuCmBDYY4a8UjKSjdnnLdx//frAwF2N4pvi6vUgtiksF2AEM4afS91EXwA01cTzvN6waRjIDYTJb1ILeJ5ijF8cH4Y5wkBQiCCjMX0DLKcnMglwkGqmOzmX2SHh93KOg7Hc+oekMXDIDt3bkq7O0wvLMyshhY62RiCkbR5DQKEKiOjUNGi5FlPCe5hXgz9K7+PGyy5x4bUnkBWbJkyhq+HW7TNsx8q146IfsX68VfOEJp/hreD1muFWgLYxOcqz7aDkHBynOgRGXwKxZ1ke4g09/qbRAnzHqHXCrDQ9c0PYYtzktkazjkCVVqOfOGSrtFMyT6QFQaM55sUgPGQWlmkpa8+ATti/rnecSTUsgzZw87WjDLdEmx9tnu+newoOAJKmkQTmugDuN10lm2oA6dey0BS6l7ZbIvm2mJMq96kOvUmKpb5ST8114INr92FUAHyLhMbOig0hxNUKg/RNBYzL4qGPBWLEltk5Th9IU6NrhWTQizClChpA6aQVOxZhGZc2pthLFpe7duisSC4k06zZUOkaIHVZimcmJv3su4ulGYbV6NmtrwapJP+6eoLd2TA0MFMb1Jl18SDZW41ILTtqJJ3txQhNTMScawl1C2QHNvamLvUYIg2dRGGgcfyfO94I9cko6UEpWYdsmm
 ilidQvNh
 VQuhB87Frt+FzfxAWgQC6unPQNhJArwTdmr/NuAB1tKNw1bfwbj5GOxAZCC+4aCb0fTrWZ3JN67jltsa3kYoDKNys+Yq6WQnRqO1ax5z7aPnlmF3nzrov2BcaVFI7jcfVnKrwMH5PoOpElVbfgVZkht21CX77dsDCmYDe07UQ5UVP/fslSMRlqMygKbvg1QxEhK/1zPBSTurxvNTN8ca7qHpZV7ET8cH4H7KsToPDE4m9Fhu3PoVfujZcsM9rEtw8nXa0xa4FK8IqaGMgEpPBqXu//n2oaDXLj0+MVDxnYbj5m+GKiFuhx9TS4fFoCePgA6wiLN46PQnR0k/X1/oK6DAnhhMC4kpnXR0PNCLp8VdvytrreSd3/98Q1AWMb5KEDkevhUN0+lLTW9VXmIY4Q6IWo9EJ97V2ckx2GUXGTrwrZ2zjTEX3ec3lX3la2XzCFyDeTLNAx3wZY0yD6hC9joOYjqAxZMOpoexy3ovA93oU0XjYxKP2D5aKyGonCfTk91+z/wPqTcn9SvV90pSJQYFcBMM4oXte+1TxSIvlpBZHEXp+Myst4GJ0SaHoPbbvcy9qw9b1rOL7zj5iEdGtWxMcvDefDzzni7Dlw7L8Nxphp6VLhDJv6Co77ImsYhptWOp6/Hq++HqtsUxtNvtMNk7JlKKefdTC3Dd2cKmjgyH0nMhPt95Y26sDcxykXho2T2f3y0HIPPbZtgsmeCs6xCIPAnprO8qE2GKo4NJatrH+nBMRX7IyGbINot/dzc17skfjtwOuzB8tQ1aM37H8GTWu10SkNILoxa5yS2tzP46h0c0/EpPqBe6tJNoqLJ4UpVXPzNkZ0ZiLk0c=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Since commit cac1db8c3aad ("mm: optimize mprotect() by PTE batching"),
mprotect() of large folios marks pages soft-dirty that were not written
since the soft-dirty bits were cleared.

modify_prot_start_ptes() folds the dirty bits of a batch into the
returned PTE with pte_mkdirty(), which also sets the soft-dirty bit on
architectures that support it.  If any PTE of the batch is hardware
dirty, change_pte_range() then marks the whole batch soft-dirty.
clear_refs keeps the hardware dirty bit, so after clear_refs, mprotect()
makes nearly every page of a populated region look written, which can
mislead tools like CRIU into copying it again.

Reproducer, with 64K mTHP enabled:

 1. mmap() a 64K-aligned 1MiB anonymous region and populate it
 2. write "4" to /proc/self/clear_refs
 3. write to the first page of each 64K folio
 4. mprotect(PROT_READ) the region
 5. read bit 55 of /proc/self/pagemap for each page

Only the 16 written pages should be soft-dirty, but on x86-64 all 256
are.

Instead, mark the returned PTE soft-dirty if any PTE of the batch is
soft-dirty, and clear the bit otherwise, undoing the soft-dirty bit
that pte_mkdirty() set.

Fixes: cac1db8c3aad ("mm: optimize mprotect() by PTE batching")
Signed-off-by: Shivank Garg <shivankg@amd.com>
---
 include/linux/pgtable.h | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/include/linux/pgtable.h b/include/linux/pgtable.h
index b1db7aec5362..bbba2cc71096 100644
--- a/include/linux/pgtable.h
+++ b/include/linux/pgtable.h
@@ -1785,8 +1785,10 @@ static inline pte_t modify_prot_start_ptes(struct vm_area_struct *vma,
 		unsigned long addr, pte_t *ptep, unsigned int nr)
 {
 	pte_t pte, tmp_pte;
+	bool soft_dirty;
 
 	pte = ptep_modify_prot_start(vma, addr, ptep);
+	soft_dirty = pte_soft_dirty(pte);
 	while (--nr) {
 		ptep++;
 		addr += PAGE_SIZE;
@@ -1795,8 +1797,10 @@ static inline pte_t modify_prot_start_ptes(struct vm_area_struct *vma,
 			pte = pte_mkdirty(pte);
 		if (pte_young(tmp_pte))
 			pte = pte_mkyoung(pte);
+		soft_dirty |= pte_soft_dirty(tmp_pte);
 	}
-	return pte;
+	/* pte_mkdirty() also sets the soft-dirty bit. */
+	return soft_dirty ? pte_mksoft_dirty(pte) : pte_clear_soft_dirty(pte);
 }
 #endif
 

-- 
2.53.0


