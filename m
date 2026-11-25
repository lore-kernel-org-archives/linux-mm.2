Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5150F606A31E
	for <linux-mm@archiver.kernel.org>; Wed, 25 Nov 2026 13:33:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=amd.com header.i=@amd.com header.a=rsa-sha256 header.s=selector1 header.b=lAompqCr
Received: by kanga.kvack.org (Postfix)
	id 44C2F6B0A19; Wed, 25 Nov 2026 08:33:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3FC0A6B0A1B; Wed, 25 Nov 2026 08:33:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2C5106B0A1C; Wed, 25 Nov 2026 08:33:56 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E92BF6B0A19
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 08:33:55 -0500 (EST)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 6AEB11C4811
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 13:33:55 +0000 (UTC)
X-FDA: 85473734430.24.294CD2D
Received: from SJ2PR03CU001.outbound.protection.outlook.com (mail-westusazon11012061.outbound.protection.outlook.com [52.101.43.61])
	by imf02.hostedemail.com (Postfix) with ESMTP id 355DF80009
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 13:33:52 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=lAompqCr;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	spf=pass (imf02.hostedemail.com: domain of shivankg@amd.com designates 52.101.43.61 as permitted sender) smtp.mailfrom=shivankg@amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1795613632;
	b=1nm1Pv6F2LlZlCPfksBDCDagWfVM+7YMasXEKaYP5XAfR/XkXyMcK7BCE6mxr8ExkXMpZg
	1JjRmUWn6KNV6tu85i/SxXDfZXo986MdoZKUxBAwmNfyYE9kTg2q5j/0nxlBxJqDdpPbnS
	kTjfKe/8nuz8K0L7zZpOZknGaKWtVgY=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795613632;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PD2+gZ9xbgSXLbEJ7tI7PWfna6B+HuEHpaZoWRjo0k0=;
	b=vuIkOpwakFiH8AgBVUM6IARi7miqUSCdvDQZ3+3W49+okmykJdPwDxDs+zeqaMKux+Qh3K
	7fCNoThenbPPG9N8dzF/W4wO49dmw3A0JgVa/+PqyKU4ZP9b8Fynkhg6eXrD51KiZ4bzW7
	p6YEoPgcN7UXDX+UJ6wYISzHmTDzEnc=
ARC-Authentication-Results: i=2;
	imf02.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=lAompqCr;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	spf=pass (imf02.hostedemail.com: domain of shivankg@amd.com designates 52.101.43.61 as permitted sender) smtp.mailfrom=shivankg@amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=RvDbykgM+RHq3dMk/zB81OrM9pQblTuz8oCQzRB1+7Ag3qE2M61vHQ44Q4M7Vdv/FWzfngnM7WGwfULrznvFsBdfbAqAQuDDMw0aJ1fS2Neqly8WAA40paL/jC72+ZuirFPbtYvuR5MZGy2+6yydq+KZcylsoox6KOPG8dNVGcqjHm2I7hHuuP/LeRIyfVORsHxaZ0BDKH0MkVjzuHn0yh5gasB+ZQcthPhEATdBu0z7TdJt1uVERcx+r6245w6prMyCMXVFNOHU1sX7DEGgzxPwk6CUp31Vb71Q44tsY8JI4Uj+rar1D5mMfuOQ18nkR1nDC3L07dAJgGHz9ha8cA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PD2+gZ9xbgSXLbEJ7tI7PWfna6B+HuEHpaZoWRjo0k0=;
 b=LeCV37axebXn28iazs2ECoSw40wND5K4mCXYNcNVJ3LQWIw8l0UXBqAKmgUpYynsexiolMcGF7VXIKTkM/FCyUCYWJOF7MGcdkU3RRCMc1Mitdbvv9Vv3BE2I7fymX1dsXbSSWiIbORa5MSWoYfA9IOp2/9JUQqSMDUcg6R3/9vJ6G0JS1CAJUqdAFc4Vg2OJJfQD91XW+GLT5JmOJJC0K43pnqUEYHzUvDQGzOQxntitG431Z4DlpVzTdPA0hQOVTX79oipWN1fTRupbKvOImjzRX25CP5kXybEwnpbHNdM7J9fkl7mv54MFKFghx2nyMCPT1p5XIoF6J7zScbjFg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=arm.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PD2+gZ9xbgSXLbEJ7tI7PWfna6B+HuEHpaZoWRjo0k0=;
 b=lAompqCrmxTeFYZC01nU/g8vKD0fMWiS3Zd6wfMFseeRlNcqqmVfRMRpaFCExlVv8E0itkzDi+ifAjcluxAaZkOkBHnPXELiQ27wlSF484l5hbDK8rOI1jt5M2xbu1LpZNSnwfLb4GVHZhJ83sVMmvlKvzai5Wh2AUgRfZv6GJI=
Received: from BL1PR13CA0368.namprd13.prod.outlook.com (2603:10b6:208:2c0::13)
 by SA1PR12MB7223.namprd12.prod.outlook.com (2603:10b6:806:2bc::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.662.6; Wed, 25 Nov
 2026 13:33:37 +0000
Received: from IA0PEPF00000045.namprd04.prod.outlook.com
 (2603:10b6:208:2c0:cafe::11) by BL1PR13CA0368.outlook.office365.com
 (2603:10b6:208:2c0::13) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.688.4 via Frontend Transport; Wed, 25
 Nov 2026 13:33:36 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 165.204.84.17) smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 IA0PEPF00000045.mail.protection.outlook.com (10.167.249.169) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.662.3 via Frontend Transport; Wed, 25 Nov 2026 13:33:36 +0000
Received: from [127.0.1.1] (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.57; Wed, 25 Nov
 2026 07:33:29 -0600
From: Shivank Garg <shivankg@amd.com>
Date: Wed, 25 Nov 2026 13:32:29 +0000
Subject: [PATCH 3/3] selftests/mm: soft-dirty: check that mprotect() keeps
 PTE-mapped THPs clean
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-ID: <20261125-b4-mm-soft-dirty-fixes-v1-3-538e3cdb618c@amd.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1795613581; l=2900;
 i=shivankg@amd.com; s=20260518; h=from:subject:message-id;
 bh=ysJtdznB006XPCFLKnSInZtgqTdAL0R8zaiatSvHshQ=;
 b=sftYeLk03VXHJ5y2JgHDStJJeb0pD1CgWZsJIWWt2Efwq2p2IbkTEg29OQa4v3QI+3R61H4+L
 XoycZIfytqtC90IvMaqYy/F2hNhYc+mL/PiRw5kkoLQRIymGVaeMkMK
X-Developer-Key: i=shivankg@amd.com; a=ed25519;
 pk=2l2QGTeXuGkZTtfmx0nPQU8iFZfjYmX/ymMojitevx4=
X-ClientProxiedBy: satlexmb08.amd.com (10.181.42.217) To satlexmb07.amd.com
 (10.181.42.216)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PEPF00000045:EE_|SA1PR12MB7223:EE_
X-MS-Office365-Filtering-Correlation-Id: 05b5ef3b-871a-4f64-2d7d-08df4af8b57e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|36860700016|7416014|376014|23010399003|82310400026|921020|10067099003|11063799006|56012099006|261021121427099003|261021123027099003|261009223027099003|261102123227099003|261022105027099003|261028144727099003|261026121527099003|261026140227099003|22082099003|18002099003|6133799003;
X-Microsoft-Antispam-Message-Info:
	bRlFROlxqb5gvsWGo3sIIRo9eOCFN8RLj7gYbeS0AelD0kTkMvas+K5gpsfvXqJB+GYkCktuWh4dbpx407c1sA11Q2/JSx4+G3H+EZaQmBthK/KCy7RnWeXRWkov2fIPL1qW9uwFoyfHHL7vUEdNsag9lNwkEvey3R6fCyRRGYXaVwqMFBYwKmRXJ+NXMILlLrpXKtHuE0fFM+S8tx/c1zefJTfGYGCu7Wgixq8HIcGbyM6WpxTi27M8TsCa9QMpsH9v0IF4OmIR+Y6LLPERJHMJvLvLfttLqq4mfJ7S+pEQ0gVNx+H2AuwSqSgspmpf/wwbKvSuxaZ5rrCXPPvT3LqgCZ4Yv7vKhIRlcQjk3TV5iUdS4/bjujO9S63jmwDy+PF044ojHu2b8xKWRklV87Wk9m25mdPWQEds8Rnpip5TedDyMowXblMK1XizNkCwlhMpBy5FhNMZUdimxG+gxbwpyATKlKJcI0T81b9S9UPFcDUjMzfLo9ppaLT7YRVCcEcIgE1BBP4t7TyYCpyqYNx/FAijNJm3J6lVSWtUFssCNIjEB9tRgcUrEkOd0+DhUn/RHzzBKHWIY8OtmM4XwU2kHvMDSSa7wDAnWsE7lcwF2Q/2p7zT682jB2rnBBtLrFDhhzTeMyJvJTqYyR98vGJRiVwQKQ0gbFhVOtE1+823npfdPystAy1FUuz3yY5xq16320mf8XnFxayEboK+c+G7uSmfTU/ki0iqYhiVWIYiTu6mILBheauUJ9TCMP2W
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(36860700016)(7416014)(376014)(23010399003)(82310400026)(921020)(10067099003)(11063799006)(56012099006)(261021121427099003)(261021123027099003)(261009223027099003)(261102123227099003)(261022105027099003)(261028144727099003)(261026121527099003)(261026140227099003)(22082099003)(18002099003)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	M+U5tuMHO/PoUK230RtyyR2C3N45pf6Hd0uhz8SPmEa2zihzNiD1VkHsnqN/BwtSjHg7RNCzm9eGa/0WcIzwSuuuFmUj3PRkP4n2yeqfhXPCMZWB5WtDsw/9bdT1/dW73LIt0dZRqZirzqPBl56d5a+yiM+OWvm9JchsGj+LmqmY0QAB4wqpEUam0asXTlfsF83+8FfKnyVRRRVR9k+1V7Q4s2uHxNOR6pFzo9o3G8LfyWFt83RE4kHbTq3fmuc55Te6PZlJiHUhc/X15jAs3xqpvRZAPW6QVEAXj0AYpFmifDtTtV0lgx6pRrU4ruNU4G9N5GjMv3jcStGPWte0R98tk9yGvcWjlUXrbW1F/cpmrTDG25ZOexrfnxflNrgCBJQL6QgQetT4z8O9/lr4kry7YNMoPrRo4kYq4e0OPJn9o8TmW/bMChmiO6boJTqY
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Nov 2026 13:33:36.6767
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 05b5ef3b-871a-4f64-2d7d-08df4af8b57e
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	IA0PEPF00000045.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB7223
X-Rspamd-Server: rspam04
X-Rspam-User:
X-Rspamd-Queue-Id: 355DF80009
X-Stat-Signature: br8aexehpqt3xeftfrnpb9dmy6ghu7qg
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795613632-84977
X-HE-Meta: U2FsdGVkX1+t8G8htMXVWzBKqH+B+SHz/dCV8aqvfokmMUtnutwN3Ytgu7s/rTr4oH48GABWg5kIHAS2exaAsnPU4q+RqST2mwVIDQaCpVFxwTqTqEDYIE8dPDK5k3yxwjs3Cwm56SESoX8tciNCkiYhGUb2p27TJJjbjlFtZRJokhktc30lTmGWzJt0xPQaltkshNDpsavUHw+sQDyhXqQtpBwG8FUaGd42wWueMJD2x1txlCIcC/8LnJopGkseUbQrgJZw3orwne7oBrBOMO976Aatt7FHtGu3Zu6lqdUeqg3lE42wPlisamNemo0lM8kNXIHsNhEKWLPvYczuFRfl/3wWka4rOInFF7gYBgYdHfQxw61Bt8VuDnPZUSVmHVP1N2DRvwdE+t4hN0svjP9eKiHt3dVvjFKD5siBW3MPW6TUchPwaAbs7+Mx1zs5FbglWjmJtmeSbqPVhtPlSZXEFBH0gLfskP3WOzhwW4A5bkCS9wHSzxJ+zD5hbKkFa5NlazsDe7LMMlySFa14oFRZbNh2S+epSDNz0UkHn6IY4nfGizWGJ4xy/zGhcVPledmQEyMJfWQY5nUruYMkBS0UbpXEqqRM4e9jULL+bGzog5WG3carSSPIKnlhs/xOpZNV4fMqsQVSBRZjAKxy8cJ19tN8pPjdgb5WTK/ri16mCA095IDkBq9uXXNIeFhgWklCgBecGcDCuRF39O8v5KQf7NjG252BZozSBEPhTEwgXl2K7ip1dkrU2A0N/JRWsELgju6FfMnvONgvWrv/bpcq343BZDxWoFJ0E/aerPeiUf+RxKpk3V5GhF9zAKBRvtTVzLuYFnvGV42w8y+MMeLIMHlo+RM8gOatZE7o+IqVwkrZFgy0ZAUyLu4F/GQaaPxq1IvR4m6sQG9mAYdBnM+0+AyeJMpC7M4JUPFcdnuLb5pQNcnL3bk3q51DWkp7qmg2RFYHj/jTjUSt6xb
 8HxINIs7
 tmkhHY6pdQUNMc+2XZG+I1fDzHG9B6gRlJry/0KjpJEoSw0CMqLO5KDgaz0XO6oUXEZ1cW0G8pm+jxfX9kJ2pwitrB2rATu49S+QKU4IDUUNS3OpE1wMjEoYq8ZeuBHYhp7yKT9Wfbja1Pn3/EZ+HdAcCAm1cP8wFbg0kn8N9roMExl8evDRP0+J8CefUSvNIMXwotqxzOkjncqGnwoqy1R4hXEGWcoIg9kIX6eAUM2qukaSrgYrgEUH95oBnRGprWYNvjyhkMghBEmB9kYukioSMQAX5SwtcaaO4bPwrVPvmPROdgq6fBjMcqgDo0mb4vFUUJHVbpVGb4fn2Nb0Snzgoplzae3n8JXgieUkkKn2SQt4V0Jim97oOvUQaw3kWboLtdW0WhotxM03MNOVu8OnypT8C845/ZJ7XCO26CyNaeh+z+O8pk/2VOMPKpz47qTiTMcZCfA3y0U0mUjuCpOJ9iOniU3MdcenaOAOl8w1xpm2VFfdbmWYaQ7UbStpDTYLdiGokJmY6lme9eDaeD2+fOOJJg3XKTcFewcB8u4V3kRe9LUCceGgjVzGrz05AGIu2lUJ/ILoaGLCisw+ilsDvcjpqYWzn4swn4U4wKLd9eel5tJ53GMfrelzJcB6NtqFQi3EOqtP9MjoKiNd0IDKMSe+eBBeGDaWFV0s1qLLdyA2a+7umQNSsgIOi3x5ddh8LcaKiazJLHoSMTIxZ8kgOynSI/rc9p4K9AtIrTLNwuTbs2mR1p1j6epKXU2Y4kvwRQ4gGwHJnJBcKrq/ZE8aygaYvtlF8ilfs
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Add a test that clears the soft-dirty bits of a dirty, PTE-mapped THP,
mprotect()s it without writing to it, and checks that pagemap reports no
page as soft-dirty.  mprotect() batches the PTEs of the large folio, so
this covers modify_prot_start_ptes().

On x86-64, the test fails without the previous patch.  It is skipped
without THP.

Signed-off-by: Shivank Garg <shivankg@amd.com>
---
 tools/testing/selftests/mm/soft-dirty.c | 48 ++++++++++++++++++++++++++++++++-
 1 file changed, 47 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/mm/soft-dirty.c b/tools/testing/selftests/mm/soft-dirty.c
index 7f649b673355..1764e285f125 100644
--- a/tools/testing/selftests/mm/soft-dirty.c
+++ b/tools/testing/selftests/mm/soft-dirty.c
@@ -310,6 +310,51 @@ static void test_merge(int pagemap_fd, int pagesize)
 	munmap(map, 2 * pagesize);
 }
 
+/*
+ * Clear the soft-dirty bits of a dirty PTE-mapped THP, then mprotect() it
+ * without writing to it. mprotect() batches the PTEs of the large folio
+ * and must not mark them soft-dirty.
+ */
+static void test_thp_mprotect(int pagemap_fd, int pagesize)
+{
+	size_t hpage_len = read_pmd_pagesize();
+	size_t len = hpage_len - pagesize;
+	unsigned long nr = 0;
+	size_t offs;
+	char *map;
+
+	if (!thp_is_enabled() || !hpage_len) {
+		ksft_test_result_skip("Test %s no THP\n", __func__);
+		return;
+	}
+
+	map = memalign(hpage_len, hpage_len);
+	if (!map)
+		ksft_exit_fail_msg("memalign failed\n");
+	if (madvise(map, hpage_len, MADV_HUGEPAGE))
+		ksft_exit_fail_msg("madvise failed\n");
+	memset(map, 1, hpage_len);
+
+	if (!check_huge_anon(map, hpage_len, 1, hpage_len)) {
+		ksft_test_result_skip("Test %s no THP\n", __func__);
+		goto out;
+	}
+
+	/* Zapping the last page PTE-maps the rest of the THP. */
+	madvise(map + len, pagesize, MADV_DONTNEED);
+	clear_softdirty();
+	mprotect(map, len, PROT_READ);
+
+	for (offs = 0; offs < len; offs += pagesize)
+		nr += pagemap_is_softdirty(pagemap_fd, map + offs);
+	ksft_test_result(!nr, "Test %s soft-dirty clear after mprotect\n",
+			 __func__);
+
+	mprotect(map, len, PROT_READ | PROT_WRITE);
+out:
+	free(map);
+}
+
 static void test_mprotect_anon(int pagemap_fd, int pagesize)
 {
 	test_mprotect(pagemap_fd, pagesize, true);
@@ -330,7 +375,7 @@ int main(int argc, char **argv)
 	if (!softdirty_supported())
 		ksft_exit_skip("soft-dirty is not support\n");
 
-	ksft_set_plan(19);
+	ksft_set_plan(20);
 	pagemap_fd = open(PAGEMAP_FILE_PATH, O_RDONLY);
 	if (pagemap_fd < 0)
 		ksft_exit_fail_msg("Failed to open %s\n", PAGEMAP_FILE_PATH);
@@ -343,6 +388,7 @@ int main(int argc, char **argv)
 	test_mprotect_anon(pagemap_fd, pagesize);
 	test_mprotect_file(pagemap_fd, pagesize);
 	test_merge(pagemap_fd, pagesize);
+	test_thp_mprotect(pagemap_fd, pagesize);
 
 	close(pagemap_fd);
 

-- 
2.53.0


