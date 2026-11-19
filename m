Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DB50E606A325
	for <linux-mm@archiver.kernel.org>; Thu, 19 Nov 2026 07:13:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=amd.com header.i=@amd.com header.a=rsa-sha256 header.s=selector1 header.b=z/uvv4/I
Received: by kanga.kvack.org (Postfix)
	id 0BAF06B05CB; Thu, 19 Nov 2026 02:13:09 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 091F76B05CC; Thu, 19 Nov 2026 02:13:09 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EE98A6B05CD; Thu, 19 Nov 2026 02:13:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id CD89C6B05CB
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 02:13:08 -0500 (EST)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id E638340969
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 07:13:07 +0000 (UTC)
X-FDA: 85451002014.10.012EAEB
Received: from BN8PR05CU002.outbound.protection.outlook.com (mail-eastus2azon11011011.outbound.protection.outlook.com [52.101.57.11])
	by imf23.hostedemail.com (Postfix) with ESMTP id B3B6F140009
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 07:13:04 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b="z/uvv4/I";
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf23.hostedemail.com: domain of shivankg@amd.com designates 52.101.57.11 as permitted sender) smtp.mailfrom=shivankg@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1795072385;
	b=ENZZVFGdhEoYzQT6lDIje4/F8Uy3R4wCRjg3TtRJjMhOL8VUS0mz6cemgV3ZmvXjv+D+sc
	p/MXl+a/ku6LZfjVnrrSxhAyYm5+/XTxwcjEKyRLFutA8ejgJWrguZSbEZbfeOBA74t8Dk
	w9RVwY6sf+U3h0SHJGSmMuBl1kqLCoc=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795072385;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=a1UwOqvYA1gZirjVD2gdOuXu+acZVX3sbjhJXVslUsc=;
	b=DZXtaGBqAdCzA0dHn8zCooNG/xF8ycAVHlA8EX2zWTMCMdOw+cyBCqUZehN8PkLSs7UmTc
	wlKieT89HUiRGqMNTrVSguNq1fItGsAOzjukUTiZpSutQLcudf8pvXsqO4ISWyVMe2398f
	ViZRPCwNyp41ul9THiEN17Y157qKAqo=
ARC-Authentication-Results: i=2;
	imf23.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b="z/uvv4/I";
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf23.hostedemail.com: domain of shivankg@amd.com designates 52.101.57.11 as permitted sender) smtp.mailfrom=shivankg@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=MtqqnRtZm+rw8oEdeP/IlKgILkuLLZ+VU/FShDkDoqU8jCPBqSbNppYRzSz76MDDMnuTkLcxxbhWbpzCsvvrhW/kOabZl8hnpSfLrtdTKSZ+gMh7aBVw90fgNwCg+qIIW9NcD5Nsw/4Kxf3vZqEpZZMB70O66pBIR+VLfxGg6lpTgWsZjMd3TuVnj5li/nZaHgmL8gnKbIUZkcwr568TaEFuKkIOTWDIWtQzoI2umkKh28JEvvtV9PEvaZ0QOt4kT86cS7v5IudJGN3rCUQKwZZegU3FNIIBLQVpXn4aMzA7wSy8ojiyXXXQCZVb0FxQiQcEMCOmgvcdXiO5gnC7bw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=a1UwOqvYA1gZirjVD2gdOuXu+acZVX3sbjhJXVslUsc=;
 b=v1QQ0NC+rP1NF6FGdchafBfzpHytWSLtrA/5X/bwO2VU5H8yN52I2uzWYn4twhr2qUHm/zE5rOIEX5zHC1d0JpYUV2uS08d4gN36wDz9ZnyNSauIMhf9FSQ/2NVrKA7TznJZyWVi4k4lhXDY3oRqAGbi6V2SnNLMpCI+5g7wrxYrRfWgk/aCq6KjxD/SzXo7U5dfHvox56nmD58VKCtfhnzTnRXGenek2oEgD3z/lbL7niYH7GHZuqw37JMlwd9H6s19FkmrkkrwKHrMEcxgxc6PzYbK1NDLT/uC+5jOp0pP5wL0jrWvMkl7WYMPZ339IR5nNaifZvI9XHHcvf+s5g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=google.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=a1UwOqvYA1gZirjVD2gdOuXu+acZVX3sbjhJXVslUsc=;
 b=z/uvv4/I1vCivc4tIvQ8tuU//3BgnEeysofQCFsjwZrrfoHThL8djk1J4CwOiQEOHFd87oSNpZytqi80IUihHT/J3twYRNNRmXVG241j79yL3QV6sBBYXnD4S0kjCeFJXw8QdQDC6yiK51wcRCifb59xHleTpzz9OVV2TIk5fHY=
Received: from BN0PR03CA0052.namprd03.prod.outlook.com (2603:10b6:408:e7::27)
 by SJ2PR12MB8954.namprd12.prod.outlook.com (2603:10b6:a03:541::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.14; Thu, 19 Nov
 2026 07:12:59 +0000
Received: from BN3PEPF00022BD0.namprd03.prod.outlook.com
 (2603:10b6:408:e7:cafe::5a) by BN0PR03CA0052.outlook.office365.com
 (2603:10b6:408:e7::27) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.615.10 via Frontend Transport; Thu,
 19 Nov 2026 07:12:59 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 165.204.84.17) smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 BN3PEPF00022BD0.mail.protection.outlook.com (10.167.248.166) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.639.5 via Frontend Transport; Thu, 19 Nov 2026 07:12:59 +0000
Received: from [127.0.1.1] (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.57; Thu, 19 Nov
 2026 01:12:50 -0600
From: Shivank Garg <shivankg@amd.com>
Date: Thu, 19 Nov 2026 07:12:03 +0000
Subject: [PATCH v2 8/8] mm/migrate: add migrate_lru_folios() entry point
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-ID: <20261119-migrate-refactor-shivank-v2-8-f4535bd0bc52@amd.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1795072323; l=3471;
 i=shivankg@amd.com; s=20260518; h=from:subject:message-id;
 bh=OIGFTNNDdU0GiYRn6uObs+iE7uduxqzNz9flsm0Bt0U=;
 b=Fi0eHe7qHXbEFZ88HvTTWfKiFO7vo5pdp/l8/Brb7h5ZnyYJEXRLM1ezFPP/fYA1ddlILFxao
 gUcJoeevIZtBnDewQim2lksGQ5gwi8xG7G+yuLyjtsUnpZr30NtSOCy
X-Developer-Key: i=shivankg@amd.com; a=ed25519;
 pk=2l2QGTeXuGkZTtfmx0nPQU8iFZfjYmX/ymMojitevx4=
X-ClientProxiedBy: satlexmb08.amd.com (10.181.42.217) To satlexmb07.amd.com
 (10.181.42.216)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN3PEPF00022BD0:EE_|SJ2PR12MB8954:EE_
X-MS-Office365-Filtering-Correlation-Id: 4cb72cde-c76b-40ad-7cdc-08df460c8acc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|36860700016|23010399003|7416014|1800799024|376014|18002099003|22082099003|261009223027099003|11063799006|56012099006|921020|261102123227099003|261028144727099003|261026140227099003|261021121427099003|261022105027099003|261021123027099003|10067099003;
X-Microsoft-Antispam-Message-Info:
	o5vKV2wC89gad71BPxO4008adhE8i9c73BsDDpcWEqqXiVyt+7t13sbO6oJ9QZDiX/vzW4uwBvtN8QLLvw97BiC808p0SgL/fe+4dJ508RELTUFYyksMsGoLGnlqOnO1cCDdSUhRSkSLPSwuo3T0jwejcwtYA5C8OgXmM1c3uXXRMQo8F8kDhs83sHVp0rFBmS+keGtU/jkQG2hbkrCRHaLbpGrPpxXM2/Uix156ReSXuhx7lpfyMkPOWb7C8tgABlZP/ixyTomCPbVBQWCB8bnN5QyN6tAX6bR6X9wfWvatJPnTCns52kT8YPAoRmhSfTA3c5/n6Pyf+svck/uWOCnc2pMQf/dd7ykbEmzjBlgVXzqJuTh5gYujaYY03sYMq5NbT0/8Yki49srohGfx6Pp/9PbWQnqXi5dUankTt6nltF9KbJNLHhKWVi3AjFKjx9JiCSEXabGiBKSEui03b0JgDih9MxGM7HYHeKh5RvlojeTs4rQCjlF0fbrpf+rtt+RWsquGlEKBXBywpCR0/7WJQosTQqwuJo8bXpd1pkUxAbK3s8p55XGW7q5Sa2AGcI7HocICj5iysSiZFRqsMNuWnJBTy1A9IWnycT5ERobn40yJ8NEH0e7VhhM2SZHtlEXB7b1N4sTgmT0Hb7i1OOOIsBiHVsRWHLPqxRRZAgrfgCkRPYRommrCNxla3I+W1gsCLYLBLBbNBbfv25GR2Llc5vbKiL4Qz4dGfGbMR/hJ50LSIUegOZjS9cYvjDgG
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(36860700016)(23010399003)(7416014)(1800799024)(376014)(18002099003)(22082099003)(261009223027099003)(11063799006)(56012099006)(921020)(261102123227099003)(261028144727099003)(261026140227099003)(261021121427099003)(261022105027099003)(261021123027099003)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	V9pHelQAxWBO5FI+FkvEsQ2gAIrrdQ7tJ7T4XtSCxgH3gcAIFdQDv6VnYb/GEMx2aNsCvACEnBbRcvLDiSlKMIgSjbC7QgczoC8aca/d14D0cPI03izVSuqifZkU/RO+84zS3ZJwQ9v79lVrfRQGpSNax6VOnGk4zaIlNQEa2WkBa3ec4Jt7x0qZ0yXl93K5+IfF/SX2clcotO6GsO6Oz74BCLknAsd9/B2f1RtaaDIIlCUrFbLsQUQQoK8FrjNEsN+HiWVQ61gt9r6EDQwbGrAVCr4A7moehIT89NOppHeQn5a85sZ7DT/xaipC4TFyfg3JysD75IID+zGRJtHH7YuDYy2FC53o31XF+GFauwrL3txhPVhc/W4L/rS8OfQoQZ4omQSzxUYEJuGsToyUXZ4JYz3aJlaLzGSlG/87YjtyVqZFA147ZSZAFBySfyra
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Nov 2026 07:12:59.1435
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 4cb72cde-c76b-40ad-7cdc-08df460c8acc
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN3PEPF00022BD0.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB8954
X-Stat-Signature: 6o4d71hmzmafm9hxqd33h96twbg1hgrh
X-Rspamd-Queue-Id: B3B6F140009
X-Rspamd-Server: rspam12
X-Rspam-User:
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795072384-594764
X-HE-Meta: U2FsdGVkX1906/83Csze1Yk1tn3u6/wQZTrd7O/bbzzaXjuOBO3bBkKHJEs46DR9lYqYXhu3RcyF3tdFkHIAa1Muu33nHnUKyZLExpSaxPAUuRnDzqkuNfavw8qNebNmTWjlI98a4/TrkjUvWfnSIf+YLrX4HORgajK1/AhWvMtmj2G1lAuCQOW4pnkBPuENaqUZ+yvn7KVGply0qjRfJMAXG7MrsfuOKHFIM5wm+vE/HnT/oxZ9tW1uLBbNG21ehCC51r2H+7KmXa86+L0YBSHQofJ96cqx8hFt3UXEFyeHM48u9G8XAGchXBy7mmdXRrxMcSA72Mb2a5Ot/ss5wj0c/6CBrePNrOy+VSqw8jhZv/hNwnQowrDr9B8k/2kgCBzAqQ9Q0r/6g/ZXAVTSqtWC0C8Jlo75X432vjwppcVQDZ8l1ubytVRnSbP2glRQFi4PLJcdKT6hM87wcdFNb+vdLjJ99akjbJMrjVYP5MeNAOcm8EVWuf7LyZywUxxg0N4Pg79Zbj/k/gFzxpqNl38qojZVNAmEKZdVdFD9+br25xp4RHa/G/6/kzuYrE8fekD5B0FHrbCE7XHH5s8mN+wdbk3p4MQ03pYZtQlIRLhx4dKCBzIdb8j+gAphMDBKOTkrmBqfylxBqUMxwHtISr8aXSJ/9wrO46wkiQXSxC5DxS89pq1SN0P5T0M5v7soGASZeetZgTIMxhCujUliv1WWJCEzr26txeGWKkqGY9F1dMHOgMPrqb2kW20V6AaxtVUMO9yY7HeGEZvSVIwIHIp7oZX1QKAhVrf45WsQgGd41KhfL7zh5yHmpBaloZzuzD7pKs1ayCvpPrKtUhXBtEQZrTixn/i1DQgdjtKa9+MqIfwyE89/qjib0shlM+KfTx0d0Ar5fXhIs2jRDkQOdZQW/r8Zoa/i+mN1JuIyqHyqPtF1SwZnYUgrSnCutM+wcMGPVlk79qSnLafL1fx
 niuaRjNR
 Jnk+6Bb4ttMfwBuWCT4m0RYLL/1TdovG9AIYOYE/aTAzWkn1H7qmHrNE5x7oXSOW4RO/gylkzD9t5nE+Kbpm6Lxn/ax6m0/HXTmR5QwhcfcnbrLdT7RW26xGAvnZpc1PXSwwaUywgS/HTibTPjsjk7xdo5PzeYFyqqk0WJni8N+XUyMXQghEnqpIVTFuTzHS8pQlKgQNCTlDlznYdT+0DsSxkGFPLnGHgiFreDhXXcYh6XNQ/yrSauUHz3WNJrQgKcTsBuPzd1GpBp9SHGZf6ReyPF+gzwfe/ZZggLvZamct/7Zt3sODqF4KDmFWqw51+tR5W/fpRPSIUw/3qVyUwsHtvUA4lOLNJovJ/e9lBkC+WXggB4UuuUeDq4JTKA4RmIgGVKNsgeg9mo13J65IvPg273Fs2p9gTj3cUXgBPRyWBdp2SzpMOLgfZrvJQ/7Iti9eUrXV0sQx2hhw3ED6g3foH1l/yGgbGO2Oelyl8jEu8O6W0LZoD6DGrag4Xi8vAYLkIkGMfCWf22G0uNiQ8aJHnv8Oqfw8A5USpCkhWgBMK3D9fzX/GsWsODWDjW/sA7fDLDOXyMxwDoOXRccFtUf6kQ839MkGjfg2tusIi95NiBJQfTuFM4gH8z7XbXZ+G4wxrFEeawog2tf4mISbhIpkEQRUyFSIrzB49/rKCyUugrDjk2UJ/PKe1ZICMkExmiV8O0EE8fcYGN64zqjmWurpwkscaKFjfAtKysCJDlMqf+s/LwGUHGSWojvh533V8syvaAEzK//QVEaAtAr84rdJAD593j+57CzL0p3pX7n0QJkgQA87Tw/IMSIEuZDZkVDOQwOisu5pQOfI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

The NR_MAX_BATCHED_MIGRATION limit is specific to LRU folio migration,
where the batch engine can keep multiple folios locked at once.

Move the batching loop out of migrate_pages() into a new
migrate_lru_folios(), which feeds __migrate_lru_folios() one batch at a
time. This leaves migrate_pages() responsible only for sorting folios by
migration class and dispatching each class to its entry point.

No functional change intended.

Signed-off-by: Shivank Garg <shivankg@amd.com>
---
 mm/migrate.c | 57 ++++++++++++++++++++++++++++++++++++++++-----------------
 1 file changed, 40 insertions(+), 17 deletions(-)

diff --git a/mm/migrate.c b/mm/migrate.c
index bad69e1e2ac4..9a39468797d1 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -2281,6 +2281,45 @@ static int __migrate_lru_folios(struct list_head *from, new_folio_t get_new_foli
 	return rc;
 }
 
+/*
+ * Migrate LRU folios.  The batch engine keeps every folio of a batch locked
+ * at once, so feed it at most NR_MAX_BATCHED_MIGRATION pages at a time
+ * rather than however many the caller supplied.
+ */
+static int migrate_lru_folios(struct list_head *from, new_folio_t get_new_folio,
+		free_folio_t put_new_folio, unsigned long private,
+		enum migrate_mode mode, enum migrate_reason reason,
+		struct list_head *ret_folios,
+		struct migrate_pages_stats *stats)
+{
+	struct folio *folio, *folio2;
+	int rc, nr_failed = 0;
+	int nr_pages;
+	LIST_HEAD(folios);
+
+	while (!list_empty(from)) {
+		nr_pages = 0;
+		list_for_each_entry_safe(folio, folio2, from, lru) {
+			nr_pages += folio_nr_pages(folio);
+			if (nr_pages >= NR_MAX_BATCHED_MIGRATION)
+				break;
+		}
+		if (nr_pages >= NR_MAX_BATCHED_MIGRATION)
+			list_cut_before(&folios, from, &folio2->lru);
+		else
+			list_splice_init(from, &folios);
+
+		rc = __migrate_lru_folios(&folios, get_new_folio, put_new_folio,
+				private, mode, reason, ret_folios, stats);
+		list_splice_tail_init(&folios, ret_folios);
+		if (rc < 0)
+			return rc;
+		nr_failed += rc;
+	}
+
+	return nr_failed;
+}
+
 /*
  * migrate_pages - migrate the folios specified in a list, to the free folios
  *		   supplied as the target for the page migration
@@ -2312,9 +2351,7 @@ int migrate_pages(struct list_head *from, new_folio_t get_new_folio,
 		enum migrate_mode mode, enum migrate_reason reason, unsigned int *ret_succeeded)
 {
 	int rc, rc_gather;
-	int nr_pages;
 	struct folio *folio, *folio2;
-	LIST_HEAD(folios);
 	LIST_HEAD(hugetlb_folios);
 	LIST_HEAD(movable_ops_pages);
 	LIST_HEAD(ret_folios);
@@ -2346,27 +2383,13 @@ int migrate_pages(struct list_head *from, new_folio_t get_new_folio,
 	}
 	rc_gather += rc;
 
-again:
-	nr_pages = 0;
-	list_for_each_entry_safe(folio, folio2, from, lru) {
-		nr_pages += folio_nr_pages(folio);
-		if (nr_pages >= NR_MAX_BATCHED_MIGRATION)
-			break;
-	}
-	if (nr_pages >= NR_MAX_BATCHED_MIGRATION)
-		list_cut_before(&folios, from, &folio2->lru);
-	else
-		list_splice_init(from, &folios);
-	rc = __migrate_lru_folios(&folios, get_new_folio, put_new_folio,
+	rc = migrate_lru_folios(from, get_new_folio, put_new_folio,
 			private, mode, reason, &ret_folios, &stats);
-	list_splice_tail_init(&folios, &ret_folios);
 	if (rc < 0) {
 		rc_gather = rc;
 		goto out;
 	}
 	rc_gather += rc;
-	if (!list_empty(from))
-		goto again;
 out:
 	/*
 	 * Put the permanent failure folio back to migration list, they

-- 
2.53.0


