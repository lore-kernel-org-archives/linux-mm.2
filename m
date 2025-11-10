Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6A5C4CCF9E3
	for <linux-mm@archiver.kernel.org>; Mon, 10 Nov 2025 11:34:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C3F248E001A; Mon, 10 Nov 2025 06:34:53 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BEF248E0002; Mon, 10 Nov 2025 06:34:53 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AB7778E001A; Mon, 10 Nov 2025 06:34:53 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 955618E0002
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 06:34:53 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 47708BE03A
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 11:34:53 +0000 (UTC)
X-FDA: 84094490466.22.343897C
Received: from CY7PR03CU001.outbound.protection.outlook.com (mail-westcentralusazon11010025.outbound.protection.outlook.com [40.93.198.25])
	by imf28.hostedemail.com (Postfix) with ESMTP id 64A2CC000D
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 11:34:50 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=ih0Jnw1P;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf28.hostedemail.com: domain of shivankg@amd.com designates 40.93.198.25 as permitted sender) smtp.mailfrom=shivankg@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762774490;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+dJqsW4oL7zIurwANnFL9gmDdj9ynjRvYH6Tbqbietw=;
	b=K+UOaPteemHvhfxQPhnhIaJ5CpcqPtNPKFdHzrwWSn4K6VE5ExU6fTyTknFQc8M20NjYc5
	NbrjDvzfsvge1IuSaGJ3H/9SnMA8Pvo9AE/QIZ3yoT17DsJt1E3qwy24d104eoRRjdmIIO
	KtoG9H3M0pf52zIsVvIKV41AyEu1BAo=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1762774490; a=rsa-sha256;
	cv=pass;
	b=f9IHMCE231OX84aG9oUWaB3kKFs5iYxRf/cmnan5bG9Lcy624EdXie1qaqiD74l1WbOEPG
	KRwuJ6FgxPmbCdvYodf6vn2WSH8eVCEgq09euDvEb8AH7KMrnA4dHxyLaloEwj0XVLJgt0
	SeKUBmbIGPfsqHswqEsz375bXOJbPGU=
ARC-Authentication-Results: i=2;
	imf28.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=ih0Jnw1P;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf28.hostedemail.com: domain of shivankg@amd.com designates 40.93.198.25 as permitted sender) smtp.mailfrom=shivankg@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=HJs+Nr2JRmFUHr1Yu+zQQwke8qyPEXE7ytAa/jZ1gIjNTLiywKABVvJU6bSf6pdnEC3rEY5QuDqugdvv1oNK+5DVhhncbBJHX49thCGYb3D6YDu28Uqhpg2TpMNi497+j3xDCSVCTZdjHVhYO/IQuTRlYdjYdsT3G5bzxqleCdJMxUzDTLbEuiOdzADKoXdZnX9rIh6NfSw7Ye/qEVgb+Oan5l8Z60i5JjB4WvsF5qmokIkT2CpgqntjqXvy1v8cktSjhe5NouD/bVUs3ru2YVzto3PQIkphykcB2XSnyG6hdpdzcOnj39Tuxmjv/PT2UkS6V21kC2oPHeXp0PMYnw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+dJqsW4oL7zIurwANnFL9gmDdj9ynjRvYH6Tbqbietw=;
 b=mt4btE7YkrDzgUWYAajwbFsvemXv7tjsok91UtvuPJ+iKu7twg0cRIlAv60JOWYPNYGf04E3+4ai/xfsLW3tNfUQA1wsl717ztk+ejpFLq/QagElwxcBucJAl83numsln0nS8FMZJ9I+DBjXe/E5gBbSoN+0HH9uRMyw98R3M93g0Kbegw4r/hg/IUjrIBSWf/YakX2Jce0lrAfoOJhvR1yUBvMlP87iOstN8hM1+hYbGHuDaXiKV7ASlsO/hojgxC0DorDd7L7xtuTnVoBc/mx16iTGf1SFVHRlDd3PgO8H+ym1SDdQ/GBfGnxt+xAjyBjvA6aTbMW7Tpl2cxdjJA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=linux-foundation.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+dJqsW4oL7zIurwANnFL9gmDdj9ynjRvYH6Tbqbietw=;
 b=ih0Jnw1PrGEAYTzRLdTtCq89HZe5W6okXwa9dZbcpGUXP19fIKKg6IITM8NkohM4w+xV3i3hjXuAG7pb6GSFNKiPkC0qxJsYXf61j983lM4KwwOYcQqCRRp3Rg+5QgUbzhhbLkgldUsbNG90n+9i3VdII3G56k+MHpWv6viJHAU=
Received: from DS7PR03CA0013.namprd03.prod.outlook.com (2603:10b6:5:3b8::18)
 by CH2PR12MB4085.namprd12.prod.outlook.com (2603:10b6:610:79::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9298.16; Mon, 10 Nov
 2025 11:34:46 +0000
Received: from DS1PEPF0001709C.namprd05.prod.outlook.com
 (2603:10b6:5:3b8:cafe::58) by DS7PR03CA0013.outlook.office365.com
 (2603:10b6:5:3b8::18) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9298.15 via Frontend Transport; Mon,
 10 Nov 2025 11:34:45 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 DS1PEPF0001709C.mail.protection.outlook.com (10.167.18.106) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9320.13 via Frontend Transport; Mon, 10 Nov 2025 11:34:45 +0000
Received: from kaveri.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Mon, 10 Nov
 2025 03:34:40 -0800
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
	<linux-trace-kernel@vger.kernel.org>, <shivankg@amd.com>
Subject: [PATCH 2/2] mm/khugepaged: return EAGAIN for transient dirty pages in MADV_COLLAPSE
Date: Mon, 10 Nov 2025 11:32:55 +0000
Message-ID: <20251110113254.77822-3-shivankg@amd.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20251110113254.77822-1-shivankg@amd.com>
References: <20251110113254.77822-1-shivankg@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: satlexmb07.amd.com (10.181.42.216) To satlexmb07.amd.com
 (10.181.42.216)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS1PEPF0001709C:EE_|CH2PR12MB4085:EE_
X-MS-Office365-Filtering-Correlation-Id: 04c7e635-b7ae-4fb6-8dbd-08de204d2638
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|36860700013|7416014|376014|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?ahbb49LFFpEfRAzUEx/AOVHlRQuHwOcxeYBCZVIUMNmPGD1dMzmkIGYh0yf8?=
 =?us-ascii?Q?g/1z1TuC2+7I1RzZ3EUOEct9zXaPavD3WvaEWNl7fmoBZ85xiRPTrWel2sa/?=
 =?us-ascii?Q?RaAmLbcafOCA9pfy5IJPUfOGCCstBVhHiU08oYCxn5KwuPsSTDreXOkxCysj?=
 =?us-ascii?Q?7XMjQ/r056t4LnqRXQRxnfw4l2YqajUcy2g+i34FeKyMMHFQvihq/3wYhT5o?=
 =?us-ascii?Q?r02/GSU/xgso+lhJKlOspum7ikL9WWq/2SW6UcOxjFcTf9YwbHcwXb8pA0E2?=
 =?us-ascii?Q?Ty08ENkpKUkWef423HLCDHkXwkIQ87d5cyPNXt+TNO43h55H2vVa7ukgH1jb?=
 =?us-ascii?Q?GDPmkxnGm6PkT6fdUjihu9cvqony6QTE2AjuEqxpZFlbbhkpinfIETPSGWnW?=
 =?us-ascii?Q?KuvqVdLRHxBsuygjRU8wJ/pDtBXwMlq80tjHvHo3lAS3qI3paU8YigyYcE1v?=
 =?us-ascii?Q?INTiJ/V4rhQEb18niGJ43ni6dgQJ/QIDQro87cJF9a2lwgLOQR6WQtv6H6Zs?=
 =?us-ascii?Q?ljVgNtbkOGY7Nt4gaCgql3q9c6fx3cLwa6vreMgwlmRVGqiX6DXga1kGN87b?=
 =?us-ascii?Q?AU4NrRL541WJRlvJCjpVWOpuaqjpcaZxr7oPJQoKSIptzRxwWSSwsn1ryXgE?=
 =?us-ascii?Q?8cHi5IIqHxuM7tNzWx/dAmEBa+S9nCjMAh7Yk8BELqavtHuy9KfAKAuujNOd?=
 =?us-ascii?Q?i60RjpWbVNxRYZHiicAzyJ2lwM2qsrgyt6u37vb12hvt9S9IaMIUkZirhhkT?=
 =?us-ascii?Q?s45f9TllRJ4SnnTo+398BjPJlQPBj843xmqalYc/io0V79qMWCjSU6nkBpXg?=
 =?us-ascii?Q?+USKRCluu5I2NLs+YJQDu99kGMG8G4ZlAwiip6aSVBglKwiD/ad5bBJEdAsF?=
 =?us-ascii?Q?NSfg43winks60HdU2ueH4Adp3vwXusJ+bXH5RdPVWXXOoEdNQdEmUwv4fIBO?=
 =?us-ascii?Q?rj2WEeKlDqOBUHVeT0+BB6YH25hO9NSTUVWC3u6UKCBNGAKE6RAOcZBILWKP?=
 =?us-ascii?Q?XGPrafa79PqoOXhvhjS6IJbFyVzL36fBLSAPtmvd2NV6OSnuVOckJoTmmxIt?=
 =?us-ascii?Q?//SKX5dUDEsx4Y4lX5QBlKDIsK34L3EXJAAfjG1jCVPCSwUQfpHTZYM+Sg9w?=
 =?us-ascii?Q?ypv18d0aL23uk6tzRA2MN7uO9aoHUcQkZ5znYuWAo4VEV5LnCwvpbjWxL878?=
 =?us-ascii?Q?MEMwCycqJsyQdJJiBT+ZmbkAbmsvPDJmms/IbgisOUNOInR9zmhan5C4huZB?=
 =?us-ascii?Q?OC0IadjXUFXCeex1QIzmS2ZmilVF/ce74RooLXjekmkbS1l5fbTNp7XzN7jG?=
 =?us-ascii?Q?69QxYlx14+a/GVff2j/bWK+u8VN8KUAyek7ePXwkQ7y+GqPo99TKom7nAwVB?=
 =?us-ascii?Q?4ZkgEMrjeQP1OhoaDOTG2odewINRaRorhA98rV8VRPzaKzVg7n/clqxHWLiN?=
 =?us-ascii?Q?aDda6K0GQy03CapOEZODTWCmhbrT7SuS62KGORfl5es9G7n+tcTPR5vTDQiF?=
 =?us-ascii?Q?qhyw8H6Mdp4VOdDNHuIb2pcinbFkMxbF9HYjuYXIznVFlEM7UrHUd1Zliacy?=
 =?us-ascii?Q?ILq5tLXE+MnJUnUomtI=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(36860700013)(7416014)(376014)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Nov 2025 11:34:45.8194
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 04c7e635-b7ae-4fb6-8dbd-08de204d2638
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS1PEPF0001709C.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4085
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 64A2CC000D
X-Stat-Signature: w7f3uhu8rh3hkbbnqk6ocpe1ics7u6xo
X-Rspam-User: 
X-HE-Tag: 1762774490-208499
X-HE-Meta: U2FsdGVkX1/uijjtrvTbVyKnKZBg9XJgWzn6EK9X8L11OKPsjt/AMbINgHGDqgB3DGOk2iTTsmrOOa6LT8YhK6o4yylKcQlxW3c1/oDVE/ODtn6vdLWS1B0rmKsfjYmi+ln8ZJu7o18k3yFxw8wSiaABnzMtthWMV2uE1sXAdOBvdi3SZ5leQw2OC6Rz2X/yjwAxASShXYxP0pT3EJOoK5Be8yB/FmaywFhzybpIFjB9qGmEjYf5Q9/6AGT020KOKXbfeYDQx2NuAkdexL7Qt2pwTLhFOsJy5FIM7VHNA1q3ARUiLbTiVGKDO4thlkW44dlhgnX2PG2ruaCqFqzaNXKI9ntIndmsPFinSAvp+4IqxykyBkUFWt18yjQ2DLdUsBrE96sVQuLnI8LB6HnqyQaHZ5fgeVo+znwpFw00qOKyMiH/BS3x20dIwjvEAJPt+xGMzl83aldbHNoo3JnDN/6TFsqShrxEzVd2ZhN4IBSbdjkwL61o3sNu7wPpFTCMVk855bxOoX3+Pdq96dP6ciTO4MNEXUkydRLJFYTAmZBon5ke833p8UyewC7vMXnvnYjRUaJCcgJDpJAQ3jBdPXNxKgESpdl5Zoi192QugPKUst1QaxxKF6MoZ0IbFmdH7oqsLHKGT/m85QqVeoxioGSVF3mHsTc3wFzU2m1ojjhNfoAhnVXeOkpR0DjZIIYEwtGE/ThT7dC8wR8QtomFruETf4Gd/MXi4VLFwRKM3BSveZzyWumt8qVISGiyS/8XmU1001b7GCoQku0YPkEWP5GC6mhyBQHkIlj4czcOPXUmiTkD5pTA7EJ/8vOWHJ/Vlx2Io0BCgrge4QzgllLeCMnm4ZU/36HawssdMcTfE1DtroPc5ADKKlBI8FHCQKzHkxznWOtmtHMYzaGdDgZGVh4b5daV9ub0ADOUzBfkSoIEtwQKZF5+6gJZFsa4cd0y+84TWUoakyvcipjy1kg
 6rL+XIar
 lJ6ccCu9WacAKz7A+zTC0GT/4S7xlLn5GjglrPOGLhJN7K80t0WyL9QqC97q1SvCW6t5BK0U75VKXImcxjyE+QkKvLU0fZtCHC8+4Pr0G5lxYY6hD979cSN7h4OSL05gcQydtdh9iQcgSiI1D+RNkXV83MXt0WreE67ZBSiL2Fd/ZtHDLMH8IAp/O2XM2gqT8xwtBdsd+ybgsrb63d2YRbI3SpAGlRm12jgsryWw217tSv9tQceiksc2xeo37CyJCrGp8TnUekDkEyzS48mddqvwXtHvviLqvuqs9RXfuhl/A/CRu7vaI43qLJ5qJKYEJl6qOuq6MDklhBjsxhakr5EhQp4IE+zMQMp45aGRAV+ZeW5g6yDDm/R0NeUZz06JMECu/6Fg6OmnjRg/BAHDWgX5GxMfEDqFyL23btVtZZ24EWbapGOhLOdBAn7di/p2/CqH3T29+T+ZgMMg=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When MADV_COLLAPSE encounters dirty file-backed pages, it currently
returns -EINVAL, this is misleading as EINVAL suggests invalid arguments,
whereas dirty pages are a transient condition that may resolve on retry.

Introduce SCAN_PAGE_DIRTY and map it to -EAGAIN. For khugepaged, this
is harmless as it will revisit the range after async writeback completes.

Signed-off-by: Shivank Garg <shivankg@amd.com>
---
 include/trace/events/huge_memory.h | 3 ++-
 mm/khugepaged.c                    | 4 +++-
 2 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/include/trace/events/huge_memory.h b/include/trace/events/huge_memory.h
index dd94d14a2427..9014a9bbe64c 100644
--- a/include/trace/events/huge_memory.h
+++ b/include/trace/events/huge_memory.h
@@ -38,7 +38,8 @@
 	EM( SCAN_PAGE_HAS_PRIVATE,	"page_has_private")		\
 	EM( SCAN_STORE_FAILED,		"store_failed")			\
 	EM( SCAN_COPY_MC,		"copy_poisoned_page")		\
-	EMe(SCAN_PAGE_FILLED,		"page_filled")
+	EM(SCAN_PAGE_FILLED,		"page_filled")			\
+	EMe(SCAN_PAGE_DIRTY,		"page_dirty")
 
 #undef EM
 #undef EMe
diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index d08ed6eb9ce1..7df329c9c87d 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -60,6 +60,7 @@ enum scan_result {
 	SCAN_STORE_FAILED,
 	SCAN_COPY_MC,
 	SCAN_PAGE_FILLED,
+	SCAN_PAGE_DIRTY,
 };
 
 #define CREATE_TRACE_POINTS
@@ -1967,7 +1968,7 @@ static int collapse_file(struct mm_struct *mm, unsigned long addr,
 				 */
 				xas_unlock_irq(&xas);
 				filemap_flush(mapping);
-				result = SCAN_FAIL;
+				result = SCAN_PAGE_DIRTY;
 				goto xa_unlocked;
 			} else if (folio_test_writeback(folio)) {
 				xas_unlock_irq(&xas);
@@ -2747,6 +2748,7 @@ static int madvise_collapse_errno(enum scan_result r)
 	case SCAN_PAGE_LRU:
 	case SCAN_DEL_PAGE_LRU:
 	case SCAN_PAGE_FILLED:
+	case SCAN_PAGE_DIRTY:
 		return -EAGAIN;
 	/*
 	 * Other: Trying again likely not to succeed / error intrinsic to
-- 
2.43.0


