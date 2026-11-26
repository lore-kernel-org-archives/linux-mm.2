Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 85E9D606A32A
	for <linux-mm@archiver.kernel.org>; Thu, 26 Nov 2026 09:53:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=amd.com header.i=@amd.com header.a=rsa-sha256 header.s=selector1 header.b=3a3ogroZ
Received: by kanga.kvack.org (Postfix)
	id E20A46B05B3; Thu, 26 Nov 2026 04:53:46 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DAA016B05B9; Thu, 26 Nov 2026 04:53:46 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C4AED6B05BA; Thu, 26 Nov 2026 04:53:46 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 35B506B05B3
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 04:53:45 -0500 (EST)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id C95B814037B
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 09:53:43 +0000 (UTC)
X-FDA: 85476808326.13.132EA91
Received: from SJ2PR03CU001.outbound.protection.outlook.com (mail-westusazon11012027.outbound.protection.outlook.com [52.101.43.27])
	by imf07.hostedemail.com (Postfix) with ESMTP id 7768B40004
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 09:53:40 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=3a3ogroZ;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=quarantine) header.from=amd.com;
	spf=pass (imf07.hostedemail.com: domain of shivankg@amd.com designates 52.101.43.27 as permitted sender) smtp.mailfrom=shivankg@amd.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1795686820;
	b=pqpyGwq8Qt0HAyjLhg7rDPxI41fkzph93JqDBIYpRffTCjFDz9Sj+j9bmti432O9kfKs74
	WG2JbGaW+cCW4/eydNPtmjJN4wSYj9O5CjuUPYhzoxE7EaK8H9nWbjkjiwigFoOi/CSm4a
	sJjw3W1fm0Q8tTvUb5OJONKodlB7Jko=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795686820;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ivxskwGpIUUvWRUAvKGC3t4tlefUNzVuGpyVCMKinfk=;
	b=Paas6wVaQRvugRnP98QuQozEZ/PbIVh1+2Oqs/4+tRHoLzej1XJEUP0PDPVsoBI+jSSfhM
	LwdNLQVmlxKKAyp9lcIhS7ldNuKUcQg95SWYyFSJHBVWI/XxK9m8xQaYgdDeuWyhubZChd
	b0Cj+PZJqK4nQbzAm+qa1N8Rr0fFA28=
ARC-Authentication-Results: i=2;
	imf07.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=3a3ogroZ;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=quarantine) header.from=amd.com;
	spf=pass (imf07.hostedemail.com: domain of shivankg@amd.com designates 52.101.43.27 as permitted sender) smtp.mailfrom=shivankg@amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=zFk75+9Zn35wxtFxO+WZMWedQsFIyMstyTxiDjwqQwo5BnqgYX0ICOgqzbmtOEeZ2HwW7SADF3r+ePN7kqI2XQHUWt8JdbK611GZhkIOm6gNI0pwXDnBuORuu5PS9nKj2xlQ3U33biZUO4c+RbaK9NxC6iEo0nyLhttLgzC4IhI7WA/SkS6iWM9nTvcC7r2+DEapCAeHqwLvuZ2njrww5vOO+XbqnHLt/6GhbtS8Le/D7XQyRwg8dFa5AaoU5c3a11Nhpa4VNfcNERjqtBYO88cC7VeIzazAzSXDjHqj3tL3+CISehBNT3licGKuaCeC609TfP7KEoFFMZB5dJcSnw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ivxskwGpIUUvWRUAvKGC3t4tlefUNzVuGpyVCMKinfk=;
 b=m8vvm7pQc0aCOing21MZlr9PeBn5wv4Yrm2XtoRSHiL/v1nNlgkelhZBuHmeDu4BW9xxw2DvmO0myvfEU07fK/mO1cDuRZrM8eW4IkldEi2y9yux+uUNXauv0MTYzht1SWIaUTd3nptF09Izm4GaeixEqu/pLtJs15EVbF9GKdb2bvio4ZWobZP6sv0KbiJdH18XzjPVCBToRgHSUi6aTQ86vseATkeLajtoWqH+lvpZzgGg+B1K3syodakzhKMinmt2Y7h4dIOyRqXN6cDKwO0zkSTPVjtzR+pkkH5wfWq1WXgxW4vQ2biLrvBw2FKGa36WfJWGSpPnMgQCwY6XxQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=google.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ivxskwGpIUUvWRUAvKGC3t4tlefUNzVuGpyVCMKinfk=;
 b=3a3ogroZ02uzJezJM2pJgLw1oSuNe0kmmp7GW3zd2bCDV8vRv00thppWrSK6WFMrzuh4RdQQe16QbNz6mFKV55IvSw+J506yVZDB3N+9AVLFhJ1l4Hg2ZpiZekiknKbwS5ZmDkoth607trGgf+aSn80cKIV4Td8VFoEvfYmVlb0=
Received: from CH2PR07CA0048.namprd07.prod.outlook.com (2603:10b6:610:5b::22)
 by MN2PR12MB4485.namprd12.prod.outlook.com (2603:10b6:208:269::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.662.7; Thu, 26 Nov
 2026 09:53:34 +0000
Received: from CH01EPF000BE94F.namprd02.prod.outlook.com
 (2603:10b6:610:5b:cafe::7d) by CH2PR07CA0048.outlook.office365.com
 (2603:10b6:610:5b::22) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.662.7 via Frontend Transport; Thu, 26
 Nov 2026 09:53:33 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 165.204.84.17) smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 CH01EPF000BE94F.mail.protection.outlook.com (10.167.244.199) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.662.3 via Frontend Transport; Thu, 26 Nov 2026 09:53:33 +0000
Received: from [127.0.1.1] (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.57; Thu, 26 Nov
 2026 03:53:25 -0600
From: Shivank Garg <shivankg@amd.com>
Date: Thu, 26 Nov 2026 09:53:01 +0000
Subject: [PATCH v3 1/3] mm/rmap: factor out migration PTE construction
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-ID: <20261126-migrate-rmap-batch-v3-1-4112998fb472@amd.com>
References: <20261126-migrate-rmap-batch-v3-0-4112998fb472@amd.com>
In-Reply-To: <20261126-migrate-rmap-batch-v3-0-4112998fb472@amd.com>
To: Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand
	<david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, Rik van Riel
	<riel@surriel.com>, "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka
	<vbabka@kernel.org>, Harry Yoo <harry@kernel.org>, Jann Horn
	<jannh@google.com>, Lance Yang <lance.yang@linux.dev>, Mike Rapoport
	<rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko
	<mhocko@suse.com>, Zi Yan <ziy@nvidia.com>, Matthew Brost
	<matthew.brost@intel.com>, Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim
	<rakie.kim@sk.com>, Byungchul Park <byungchul@sk.com>, Gregory Price
	<gourry@gourry.net>, Ying Huang <ying.huang@linux.alibaba.com>, "Alistair
 Popple" <apopple@nvidia.com>, Joanne Koong <joannelkoong@gmail.com>
CC: Karim Manaouil <kmanaouil.dev@gmail.com>, Frank van der Linden
	<fvdl@google.com>, Kinsey Ho <kinseyho@google.com>, Wei Xu
	<weixugc@google.com>, Bharata B Rao <bharata@amd.com>, David Rientjes
	<rientjes@google.com>, Dev Jain <dev.jain@arm.com>, Usama Arif
	<usama.arif@linux.dev>, Miaohe Lin <linmiaohe@huawei.com>,
	<linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>, Shivank Garg
	<shivankg@amd.com>
X-Mailer: b4 0.17-dev
X-Developer-Signature: v=1; a=ed25519-sha256; t=1795686783; l=3397;
 i=shivankg@amd.com; s=20260518; h=from:subject:message-id;
 bh=d5xmsxwRy2+9rbyys7MIo3SJmy8OTWyOXMzoxPJtqAE=;
 b=OwrbxZNuGkFP89x+JKbf4fvwOlQ+z36bwnitfsBJEKU2XIn51ooRGN8h6t0UWbIlz1Lxcaggb
 Wmlymf2NKQhBM87z7MAOyUaE1PYS2Z+zRmAMCo5oNRfSGKZt6ffZFHt
X-Developer-Key: i=shivankg@amd.com; a=ed25519;
 pk=2l2QGTeXuGkZTtfmx0nPQU8iFZfjYmX/ymMojitevx4=
X-ClientProxiedBy: satlexmb07.amd.com (10.181.42.216) To satlexmb07.amd.com
 (10.181.42.216)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH01EPF000BE94F:EE_|MN2PR12MB4485:EE_
X-MS-Office365-Filtering-Correlation-Id: 0924949a-9c1f-4198-f518-08df4ba32260
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|1800799024|7416014|36860700016|376014|23010399003|22082099003|18002099003|921020|11063799006|56012099006|261026121527099003|261026140227099003|261028144727099003|261021121427099003|261022105027099003|261021123027099003|261102123227099003|261009223027099003|10067099003;
X-Microsoft-Antispam-Message-Info:
	WRO58mCosr4vioG7WreJ23XhLn4+sQ/29sLtBFm+1HOUSqQN6vOFrjPirMCNAcITkwcYLalWzaqSL+R2wS0C1UbZyAy/z8ssWi6hBVdZZ0+sutdEPVs/jTO0OSgDs1SDr8ZLu9UOQcMTA+y/8i3UAXjNI9GHiP+3rztCys5jMqywy9A3dOon5uAmuzO6Y/vm4dA0b/5Uidt/6n122VLBphRhqMekwzhyocWshM4ibljcybkLjT0A1sxQpW7+y6XER4nwYbjC4jM1eMqpfQSiXFWm20ibsr7IPcKNdd5vcuFQtbVD/eSwB4I5SDDxRJbWv2HdfElAbhGkrvobVJXvA5i4YlKq51i3PGRF+Cbd82FEIv2zfD8FRyt4ux2La4v4T8IX77HNQak0wa7V/22xt2D3hiHvhJz0QK1b8GHc0cTrFeDgen0uhnwWxkxJfHQutY3EFeA2N2/Y1i4AhWYnT7SzcbLdjAWV6lR8wCJVByJFuPTkjWBKl9RktmXe32nfaccTi0tPrZ1Fw4tMDXxb6UUkr6O97OXmGSTaE3pQEXQcszZeY6ocNQ+zmUc1TOLveSZ8zaZvg556XmpJjJgC+Mp0I98RQT5TjfOYl6RCfKunT62B1NtZsmrZlXrecDfBgLVRK8LuSciqWeLiE/RMrDJIKpIR2lVnRCIJ5WOiN/9JyPH8nYD6BZNVacxTCNb4AWlzvRm/83NH3pNwmGARo9I8WpnaMf3o4yUi3fxh918=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(1800799024)(7416014)(36860700016)(376014)(23010399003)(22082099003)(18002099003)(921020)(11063799006)(56012099006)(261026121527099003)(261026140227099003)(261028144727099003)(261021121427099003)(261022105027099003)(261021123027099003)(261102123227099003)(261009223027099003)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	+gNnDb/PyQ81fuhq5pKHd0i5/do9QK5WeeezRTAA3uab8wCAPV4hKdNQA1ti39h6VzrAgqncXOKVqtMMczdZnO2IhvBxUWzcY3RlfuOAL9ySNM5iDfTDr3F6uFcOn0mxZAzKmEIrHi9vkozDF4c6+8lVTyX793BSbeKuEnOtvzgwi9lu+xgffzvmu8tphdh2wks6R58uMHVakSH17yCZRfVBIUsBIyr0MrbCrIVNUIAIS+CY7sge9T26smB4lqm6bceCkSuOQIX5qxLwk07ulwOxoHMK5kj0mOWq+sgg1JedSppJKi3HCn9pcw7K7t+inPNGE/18S+XaniDNa05ssbvpQjJaAnYCuSHldQcosRGkTEYgsTChuGapgie6R5PfIoc7cR/nfCIZ6a8E06HbFYUWlUlLIhUTHoNYJbtffzuqEjXfqHbLHY9FNKWBK5iG
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Nov 2026 09:53:33.7861
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 0924949a-9c1f-4198-f518-08df4ba32260
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH01EPF000BE94F.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4485
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 7768B40004
X-Rspam-User:
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: pj5wyiiezokn5wc7nn57pft41exozd1r
X-HE-Tag: 1795686820-982084
X-HE-Meta: U2FsdGVkX18CqMHty75hiLv38jYDipSdKt9334uUPYNJopvMvMAaraIbQBo5HqQXYJ4XVolittF1bCPq+6KAujel/IyFO4M+6ajAsUKg+K+XklTSvy2UaDU8QVA+jrdSeLv7G8+kTEf4S9qIKWhNK0mlxnIoNk9o8j+PFV9jr8Ymv+H8J3taoph9iaFN/+5ykhKBcjUbK4na/I4FWX6K1ojLRlSk8ATAh3nnftRKceBzt5GXZZXsN7dGwnNNFwWdCcmFcnnR1lZz5oz87n6Fh8fzHiCuLa5j80Xce0DlDVQcbyJ7xlwkOxMURDD0yHSxpNyOp2KKe4WH37P+4Bqb6xOt++hGAfdgfAT5qTZQJutepHvu8xWy+BOsiqK+Q+8H13r5aIgHSEJnzE9qDXGkKJDMjn+thkDrc62P3Tczr6JkEGT2XT8dy6ORkqUWEIKNoycJOGvIS2nu5s6L7HR1wKLlLPW20ZfKpgsvhjoNiyau3ANE1efy974h7P0yI1zCmETEAM9hxXuNNHS1fv3Jkx2DH1zdu8acyLA9wcvQuNP4t78UDTG8+UMNhmT75mihFUAiu5Sl1mUZ/t524gf+qlyzFrCfmGcI46n1WfGMMv7YnImaeSvqk49IYE1pS4XLkdz5f9Xd3uqgSt3r2wOMh7pOFC64/B8ZxWGrKqjrtHi4MWKJEx3TTvPNWOaVQFTwHMWFeZyn9EySZ4Cxhz/aH3jpskJl08kP3D8RwHDkdPsSM+9Bw8PWm9/9m6Pud3HeFH2DdggJ6SGf0VBxEUyTLQMDcZh0AFLuaTjXqprGdsstR7sweo8WwV7XQmdIp/2Xo1Lo4Pas+RR/MI28C+90CcIgp9bwQtBrMOCivrfqshqTag0gr0279pFckrBjuafU1Gt1HFaxGuInKASsXJIdK1+XhqoS5C5zH2vUlwQvYYVObaQDkb0a1h+2w41maGVQ6oN/7jHABwOHHkOHpMl
 jTt11vRD
 U1LDxeq1CRomm//jaN3v5OYgsSftTDUi2JNBPBHGgHgY8zDYtZp2v0oRFNxebPW7rILYVzWf4A1+g01wGPqJ0MNEmn16Z9oSyy4MImhHuvNkBEb0bNsh0ajnsThASw57T980MfHzZzMuZFoqJupR3xRTJMIJM+yoa7iZaBXydFsFspgTrnco4xmm+ngVFKLfPgwnKkk3Mm5Xvq9Ax/wDmjkgMDp4W/WdiRecvs28S5d0QMgdWIchhUiHr7cbq6OwOTVxhFAaQ2gFAQ8wW4ZMs0xbbPWVcPXIyfM/Vc5UIHpj3g6mq0pwKiUuq6QPquPnERe0z422wQFKJqrg77tz/4XQRuWr0U3q0BbkxSeWyqwmj/YcmtTbzhZtaNtY0Iv3Jlq64wOCjZazfJyziyAbjrjTw5kM99Sl7sMgx9cNQTBVwlgrCHC+eIX58slAa1AOmEU/z+P+hvMLelkV2ZahSoSjdyDSAf3WfhSPYABjdust/lo82uhqqW2gxKBqnaAMeYFHpHRDzTkrEu+CKOLbsmLecz90sw69jKLnFl5AWKGSj2VueXnHLLagsLXfQL6JasN05A2uxDp/uMes4Za79QPcvEeCRhx380x10/h3jgHO6Qx/xC3Ltzvy9A3R3rQT88X2+5AGNbCLaMfnf7Rx2L1ofDfFWsON1B49e17jzJQJxlsXvjoCXQJJkDvZlYa4NmQzNnKeBzL049HAWuoct51Jn3A1VwmR01mD30BmcrLYmu7FUn9CyPppC5LBA1LrAT1hpN95pwqK5RnYV21FG5ly5FJtcgsve3ryqu9QaO/Oq2zJeNDHLx7VkxGmHcvpZYC/506G11NS6Of++kjHrtWr1sqDmvAqp0HpWLPXYjpucwLI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

try_to_migrate_one() constructs the migration PTE that replaces a
present PTE or non-present swap PTE.

Factor it into make_migration_pte() which can be shared when the
hugetlb migration path is separated.

No functional change intended.

Signed-off-by: Shivank Garg <shivankg@amd.com>
---
 mm/rmap.c | 65 +++++++++++++++++++++++++++++++++++++--------------------------
 1 file changed, 38 insertions(+), 27 deletions(-)

diff --git a/mm/rmap.c b/mm/rmap.c
index 61f0813e7f23..304581856d67 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -2517,6 +2517,42 @@ void try_to_unmap(struct folio *folio, enum ttu_flags flags)
 		rmap_walk(folio, &rwc);
 }
 
+/* Build the migration PTE that replaces pteval for a page. */
+static pte_t make_migration_pte(struct page *page, pte_t pteval,
+		bool writable, bool anon_exclusive)
+{
+	swp_entry_t entry;
+	pte_t swp_pte;
+
+	if (writable)
+		entry = make_writable_migration_entry(page_to_pfn(page));
+	else if (anon_exclusive)
+		entry = make_readable_exclusive_migration_entry(
+						page_to_pfn(page));
+	else
+		entry = make_readable_migration_entry(page_to_pfn(page));
+
+	if (likely(pte_present(pteval))) {
+		if (pte_young(pteval))
+			entry = make_migration_entry_young(entry);
+		if (pte_dirty(pteval))
+			entry = make_migration_entry_dirty(entry);
+		swp_pte = swp_entry_to_pte(entry);
+		if (pte_soft_dirty(pteval))
+			swp_pte = pte_swp_mksoft_dirty(swp_pte);
+		if (pte_uffd(pteval))
+			swp_pte = pte_swp_mkuffd(swp_pte);
+	} else {
+		swp_pte = swp_entry_to_pte(entry);
+		if (pte_swp_soft_dirty(pteval))
+			swp_pte = pte_swp_mksoft_dirty(swp_pte);
+		if (pte_swp_uffd(pteval))
+			swp_pte = pte_swp_mkuffd(swp_pte);
+	}
+
+	return swp_pte;
+}
+
 /*
  * @arg: enum ttu_flags will be passed to this argument.
  *
@@ -2747,7 +2783,6 @@ static bool try_to_migrate_one(struct folio *folio, struct vm_area_struct *vma,
 			 */
 			dec_mm_counter(mm, mm_counter(folio));
 		} else {
-			swp_entry_t entry;
 			pte_t swp_pte;
 
 			/*
@@ -2789,32 +2824,8 @@ static bool try_to_migrate_one(struct folio *folio, struct vm_area_struct *vma,
 			 * pte. do_swap_page() will wait until the migration
 			 * pte is removed and then restart fault handling.
 			 */
-			if (writable)
-				entry = make_writable_migration_entry(
-							page_to_pfn(subpage));
-			else if (anon_exclusive)
-				entry = make_readable_exclusive_migration_entry(
-							page_to_pfn(subpage));
-			else
-				entry = make_readable_migration_entry(
-							page_to_pfn(subpage));
-			if (likely(pte_present(pteval))) {
-				if (pte_young(pteval))
-					entry = make_migration_entry_young(entry);
-				if (pte_dirty(pteval))
-					entry = make_migration_entry_dirty(entry);
-				swp_pte = swp_entry_to_pte(entry);
-				if (pte_soft_dirty(pteval))
-					swp_pte = pte_swp_mksoft_dirty(swp_pte);
-				if (pte_uffd(pteval))
-					swp_pte = pte_swp_mkuffd(swp_pte);
-			} else {
-				swp_pte = swp_entry_to_pte(entry);
-				if (pte_swp_soft_dirty(pteval))
-					swp_pte = pte_swp_mksoft_dirty(swp_pte);
-				if (pte_swp_uffd(pteval))
-					swp_pte = pte_swp_mkuffd(swp_pte);
-			}
+			swp_pte = make_migration_pte(subpage, pteval,
+						     writable, anon_exclusive);
 			if (folio_test_hugetlb(folio))
 				set_huge_pte_at(mm, address, pvmw.pte, swp_pte,
 						hsz);

-- 
2.53.0


