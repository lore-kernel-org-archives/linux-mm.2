Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B6ED3C55174
	for <linux-mm@archiver.kernel.org>; Wed,  5 Aug 2026 06:42:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D2C686B0093; Wed,  5 Aug 2026 02:41:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D04B96B00A1; Wed,  5 Aug 2026 02:41:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C1AED6B00AB; Wed,  5 Aug 2026 02:41:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A0A266B0093
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 02:41:59 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 28D101C0B23
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 06:41:59 +0000 (UTC)
X-FDA: 85066270758.19.8019CCC
Received: from BN1PR04CU002.outbound.protection.outlook.com (mail-eastus2azon11010058.outbound.protection.outlook.com [52.101.56.58])
	by imf04.hostedemail.com (Postfix) with ESMTP id 0C75D40002
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 06:41:55 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=erOkuVHw;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf04.hostedemail.com: domain of shivankg@amd.com designates 52.101.56.58 as permitted sender) smtp.mailfrom=shivankg@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785912116;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4qFsgzcnV0HezLIHw4Kxk1DEB276/tY/e7dDoGsmaM4=;
	b=CcI+9bODJVl9Tb6jyn1BVvQP5Xlwwm2RgdgbcY9xAxXWEJd5xBPFVu1j3FYSok0RGulm8H
	hIYst3tgp/h7CDq9ekzx1bRSw3+V2TXA08eWC2pr8Ebd5D/poAU8zgIEO7lprTfOH36v+z
	N0XijoC1zGT+yn2sPZTtKXzAeX9859A=
ARC-Authentication-Results: i=2;
	imf04.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=erOkuVHw;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf04.hostedemail.com: domain of shivankg@amd.com designates 52.101.56.58 as permitted sender) smtp.mailfrom=shivankg@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1785912116;
	b=mKr5TM3oyBpDFqANNVp6XebIEuLynsgq9t/9SWrlhB+i9eAHeH8kWHhkWvV1TuvVHrgpfy
	vBpQ42mQOc8QJ2sl0GGp93SXYna4i2pjIVlKqnHCewkCJb96cerMppYHfhtIfGA7zjQIn0
	/ji4Ci4SbsW87Hy2rx8t7Lamo4bA16o=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=v1+4aQYe+5n0LtJXyGMFTZwGph+pxyue62GspVBnTfw5uPwoWx3xv0CFKgR25XaQ691lP5RIAwEJNd7nA6URYgiq1hAo8tm2xgXAjgiDQYbxMqcjRCjBz8kXINNuppz93CarxMhDb1qHnAvgtfp+MUoFlnVDekYeC9w+9ccgLtxqS3QJT3vz/10zaVKR0I2jYjPL0B6RQT0A1EmSYZhRcTHzaU2xWGlPO81jSYqj3/2h1+EVojehVmNFZkgmdLdzdY3vIhyBlRJZJ+mgIM9mIkItNDlWA2JYBzOkYne7iIxT8wzxj+j0bqv+gTCtjqh6z2uvb/sk16WnlMo/MnjZHw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4qFsgzcnV0HezLIHw4Kxk1DEB276/tY/e7dDoGsmaM4=;
 b=mK/FjR6Zeg37eQoDFIN4/tg2AQB/9tmnYucKp0NsBoJ2XcAyQwTLbvIduJLspkwqTo1eABvSCRsg8Up4a6IoMEaEbTAH4TgsPSEwKM/7ftEzeo1uGXCQYBEeRCUP155ioW9YmrV8eu0K9UFOgeQ7Hon3ZOe+lDYlF12AlU+bFeBOgL2pbpSPOmVUABcw4hlNIKpraB8HZMh2AKAcHLxd8YVBLBE2d9lYcv+oDzST7xOYmAcyl8r5v1fgSuvH/tggeuAg5tOdGcrQnq9Eo9Dvf2VsU/Mzjseqcumj55c/Bh6z/wYXb1S5PAR8GRLmRmyXGwrpnHx21gF6b9JrydLWFg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=google.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4qFsgzcnV0HezLIHw4Kxk1DEB276/tY/e7dDoGsmaM4=;
 b=erOkuVHwErnnLFOQ3H7v//hxlNCXcxUer2Kc5UE4TbiqXuuOpKExtlxvO8fKuS05XBZN6L3QuBzTcOH52FSXPMwQDyvLaGOZzjckL8N4A2hnEpTm22SwyHhMD30f8rqnNps+5168+2PblU6eQBCgootuWuK4WWc3/fXlJDdx1/8=
Received: from MN2PR18CA0012.namprd18.prod.outlook.com (2603:10b6:208:23c::17)
 by DM6PR12MB4140.namprd12.prod.outlook.com (2603:10b6:5:221::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.292.19; Wed, 5 Aug
 2026 06:41:46 +0000
Received: from BL02EPF0001A108.namprd05.prod.outlook.com
 (2603:10b6:208:23c:cafe::1) by MN2PR18CA0012.outlook.office365.com
 (2603:10b6:208:23c::17) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.292.15 via Frontend Transport; Wed, 5
 Aug 2026 06:41:46 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 BL02EPF0001A108.mail.protection.outlook.com (10.167.241.138) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.292.8 via Frontend Transport; Wed, 5 Aug 2026 06:41:46 +0000
Received: from [127.0.1.1] (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.41; Wed, 5 Aug
 2026 01:41:34 -0500
From: Shivank Garg <shivankg@amd.com>
Date: Wed, 5 Aug 2026 06:40:32 +0000
Subject: [PATCH v3 3/9] KVM: guest_memfd: implement folio migration for
 non-confidential VMs
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-ID: <20260805-shivank-gmem-migrate-v3-3-00d8bdec4e1d@amd.com>
References: <20260805-shivank-gmem-migrate-v3-0-00d8bdec4e1d@amd.com>
In-Reply-To: <20260805-shivank-gmem-migrate-v3-0-00d8bdec4e1d@amd.com>
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>, Vlastimil Babka
	<vbabka@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko
	<mhocko@suse.com>, Brendan Jackman <jackmanb@google.com>, Johannes Weiner
	<hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, David Hildenbrand
	<david@kernel.org>, Matthew Brost <matthew.brost@intel.com>, Joshua Hahn
	<joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>, Byungchul Park
	<byungchul@sk.com>, Gregory Price <gourry@gourry.net>, Ying Huang
	<ying.huang@linux.alibaba.com>, Alistair Popple <apopple@nvidia.com>, "Paolo
 Bonzini" <pbonzini@redhat.com>, Shuah Khan <shuah@kernel.org>, Chao Peng
	<chao.p.peng@linux.intel.com>, Nikunj A Dadhania <nikunj@amd.com>, "Michael
 Roth" <michael.roth@amd.com>, Pankaj Gupta <pankaj.gupta@amd.com>, "Ackerley
 Tng" <ackerleytng@google.com>, Sean Christopherson <seanjc@google.com>,
	"Vishal Annapurve" <vannapurve@google.com>, Nikita Kalyazin
	<nikita.kalyazin@linux.dev>, Patrick Roy <patrick.roy@linux.dev>, "Pratik
 Sampat" <prsampat@amd.com>, Ashish Kalra <Ashish.Kalra@amd.com>, "Thomas
 Gleixner" <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov
	<bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, <x86@kernel.org>,
	"H. Peter Anvin" <hpa@zytor.com>, Jonathan Corbet <corbet@lwn.net>, "Shuah
 Khan" <skhan@linuxfoundation.org>, Peter Shier <pshier@google.com>, "Jim
 Mattson" <jmattson@google.com>, Ricardo Koller <ricarkol@google.com>, "Ira
 Weiny" <iweiny@kernel.org>, Fuad Tabba <fuad.tabba@linux.dev>
CC: <linux-fsdevel@vger.kernel.org>, <linux-coco@lists.linux.dev>,
	<linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>,
	<linux-kselftest@vger.kernel.org>, <linux-doc@vger.kernel.org>, Shivank Garg
	<shivankg@amd.com>
X-Mailer: b4 0.15-dev-47d62
X-Developer-Signature: v=1; a=ed25519-sha256; t=1785912059; l=2535;
 i=shivankg@amd.com; s=20260518; h=from:subject:message-id;
 bh=UrdSd3QSpWnCKVjuxuM9F79TXeGwovan7hpw6KGq9zk=;
 b=QfzT5bgvAo0dPE2y0d+uYNGu85zH9jrWDJNAuliUXU7sDkiF0sdDA3XfOqSoQP3+Fxsux61Nd
 C530F3lq3CPAFIhUHqYQKg4f4Fg8pc71n1AOkogTzpbqHjw/33PF+5x
X-Developer-Key: i=shivankg@amd.com; a=ed25519;
 pk=2l2QGTeXuGkZTtfmx0nPQU8iFZfjYmX/ymMojitevx4=
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: satlexmb08.amd.com (10.181.42.217) To satlexmb07.amd.com
 (10.181.42.216)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL02EPF0001A108:EE_|DM6PR12MB4140:EE_
X-MS-Office365-Filtering-Correlation-Id: 2658d4c6-14d7-4d1d-8a05-08def2bc9edc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700016|82310400026|23010399003|1800799024|376014|7416014|921020|6133799003|10067099003|18002099003|22082099003|56012099006|11063799006|5023799004;
X-Microsoft-Antispam-Message-Info:
	CZFf6bdHY55uSNEr+tB3krxzR1nY2PA2yTT8atAJE/OJ4pxOLKkzpUluynA7MKggKv/0TzI6IHAbAndMoanZprhHV+h5Ud5Zb2ybKcZjLpP3ChjtrDbGdfKHQe+CKxQ6+RvmGqlerSAiRuuy7V5oVhZb7ZO59Z6ZUiJMdK2FVIFhJPHKoZO3pzGpfuHFkEmbfLqfNbqXibZ4mxWTz+EGXd1d2CCBJZdWVYFwagDmTyzR43vPoZlKVJyr+1kHeNN6EhsNUIR29CPMV1rcJfXiGb+Nxz9qkBuc5704EBbIEVUAkHIcI0s7dCXz6wgKU64j3/AUrN/k+Jq9tt334AJ7pYK7ZkwP62wVRY16tLT9xICfHCKZJgcP0rx8tmpZvqtVTsFKI33zQURLUmPd0N2SYxHaTRncVcExQeeHfk6J7egeUYD9FhzX5hHwaY45py24wMu6ww9zuqhRPsJrlfHq8rUb6EJ7J/7Ql851mN3V4WH5FbW4jOmz3JpSUiN2RyI1NZnlupGB1muQTLeg5RDiUZx0MWFrVD0vATyhoq6j9K7odNs28pPIcL0PMrs2eHC9S3My1K/tibUWt+ZyzjuBS11VYhgUEuuCj3lMtv4YP03JFHIJCbDM7tYRRfK6Vwww2N7PCB3hZt6X5/uPoklJXPbQViFVz+9JKFjaFEVT110q1UKXrrpgeRed3h4ALGCgjTwyc/xzptFFjR1KcHDs1oyr5TXQfreHZe0ox1M/Buxzi3MHfMonIRXO9YzArODr
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700016)(82310400026)(23010399003)(1800799024)(376014)(7416014)(921020)(6133799003)(10067099003)(18002099003)(22082099003)(56012099006)(11063799006)(5023799004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	nEIVylMk39Rn75qV0NS9PLpyWfwyl7UfhaXn4+ZEk1T3Das5892D5CKzhUp8hbnKTgnkfr4np89E35UydCGvrWGEUkvzfVBh6qr+OYf5lEFuf7rIO9Ym8Cq6zlLCHi6NbO3WUZZfpqa1GaFMGO9aklr7FEXIGbKBHe8EH4giLjpi8s9up9Vg3L3EnKPv7T7BL3sbGz5z8v+xuHIomWgs0Srsk4u1YwBRme/xLACk9TLc7ZJYgvwm2X7jjbqAtn12bzA6kQDsmSs7ZMf0Io4vQo4ckQIOfGMVYt85dMO8a5VtY8wQI28PVTLD8uuBVmW3Oxf08vTh3qpzfQLdbFn4mZ+vIUxCBlU/agsVFtTEGCgj+HtvuyPkjuX3bgHXBi5P8LbZ4pJye7h3aGhNfXzX6TBRjKu8HrBMiZQjy1O7zGuYT5LQ31f2ZdVQ4xFRLkU7
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Aug 2026 06:41:46.5855
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 2658d4c6-14d7-4d1d-8a05-08def2bc9edc
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL02EPF0001A108.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4140
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 0C75D40002
X-Stat-Signature: y35qjxmt6oo6nqubrnjzpwipbmzpwnb7
X-HE-Tag: 1785912115-299917
X-HE-Meta: U2FsdGVkX18SvNskqj6YN842Lhq0vBOwZVwe6jcuh0st27+sMk+75B7Q7PNy8g5uo/ESsnEUNVBuD5f2zsDmg9AiIt1nEHl7XZHFCFNWfjeDZ/E5dIh9e3itnIOnHGTO1b9IQBCM2iBC1doU4RxY4NvBEfvxnLg+UQ0Bjo05KgRT3QeC+w9jgknJcZVFoplxaK/kURAinLfqyuD9D80nWw1y2ui1aHiN0XOKh25SMLBF3L/nrsME6HGC300r8qpkUYqe5/mRmaea7IutGtrrGXiWFdotH05TOHHJSbhLm71AfvefUVnWVtp6HJ3dE0RQA1pnqKM3U9wXOh+dWXfknUVcMj6dvVuzrVKu+JYwcRZZ/d8hUW8pPJOxpOw87+G7lJ8PM/AWgP21KEyrLOUtajHPLgdnScPaiDQv2E35Ooy0A/NjewdGNf8oErPL+1/zoJ10zO5NTNgNCpxzuR0wthIqmsHZMfWy/z/wiKpIF8qDBGSgW7u5+tI5heiJ2vAju/dmsWWgCvjnRERxxOWdf+x5gbhMz54wkMrokbNndNtYC0xJf7YrKV1dIuCD9TRR3TGVADpkE0aNP0ef/UbOQpGZ/29IHdt9zECoIKchOmQAXv4F+ceYf7LPmF6ut8aguiWeJN6e1jpmulUQezGCsribPjcJrTcKX9sMcNZHvg1r8AviFYrEW1Iv1ehWZ5NAKsNjIQJSweCvjkHUnveZOW/5n2TvSBD/d1Qre165fpS9xqOXxhF7HChwbuJuHdlpsjX3yjX4B35xovav+ItC771n023c4yCghrKmQbDEJu0/9zluAkj7wD/r8MtzGWtzYYeqREuWmoi1FwbwBn/QQzlefh/wkXs7SSVBNLqsd2owUv4xOtYTxeMerSrxtMHETuMRK/VVlCZWWuIFAis0vx1EN/s4/3tJlZcuy5C8iVaoPe12tSoyYcS49PPc1Vy2bLlvehrHs8blk8PKU5N
 t98hWVes
 bLf/0baAIiWEXoKKwIO78+PLbLfWTHbT1T14hEf6kxthpMakCvdg/DlMAZPq5pFVyyI30nhG7CYXW7AfdkxMSoJs1dliSlc7KfDUhlLmF8IDMM/kzOnq/5tV9Aj22jXITgmrdNBxogVfz67PHtPsQpzfLwlBwtIV5hLgczvBw/4tOiv5p4arBY7ceLvvF/WxJT8zxz5+amYqNzasbUjQ7L/512Mf4SYEbx1zAGgGLIcSSnSjQ1fGmdihJccc6zaKHw0M/nDJPZ2JoM/+QxalUxrLh2dCS0zFoRNuFsVnVEeH1U2ZvqDVgKMftKq+Tu5v9jYpopwphGrF5jcXTMeRVyk4pq/6eFeC1ltX4MCgt5Ykxa6MscUEDp9cAd8Zw+pLDdV1Xvifu9hVzbKM92v9IWtjlUPojRS/Us09ljwB54bWY/Nyh6M2gUS/TI/je1AaMsCiEY8puDu2wTza16rZ28DMX8BUwwKrDD8Ft1m70yxuLFd+/U+Z8ND1trAWTrtVhbcZ+T/qXmpuomXy2Kty9vh7n2QFwDAEc0qVev+t1MR/s2prW/Yc0Breiqw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Implement kvm_gmem_migrate_folio() using filemap_migrate_folio() for
non-confidential VMs but don't enable it yet. guest_memfd mappings
are still marked unmovable, so MM never calls it.

MM invokes ->migrate_folio() callback with folios already locked and
acquires the invalidate lock afterwards. kvm_gmem_punch_hole() takes
the invalidate lock before locking folios during truncation, so
taking invalidate lock in migration callback can cause an ABBA-deadlock
situation. Use filemap_invalidate_trylock_shared() to avoid this.

A subsequent patch adds an opt-in flag to change the mapping to
movable and enable migration. Non-confidential VMs can use
host-side copy via folio_mc_copy(), whereas confidential VMs will
require firmware-assisted copying before they can opt in.

Signed-off-by: Shivank Garg <shivankg@amd.com>
---
 virt/kvm/guest_memfd.c | 36 ++++++++++++++++++++++++++++++++++--
 1 file changed, 34 insertions(+), 2 deletions(-)

diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
index 169f75f95433..583341d593c9 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -488,13 +488,45 @@ static struct file_operations kvm_gmem_fops = {
 	.fallocate	= kvm_gmem_fallocate,
 };
 
+#ifdef CONFIG_MIGRATION
 static int kvm_gmem_migrate_folio(struct address_space *mapping,
 				  struct folio *dst, struct folio *src,
 				  enum migrate_mode mode)
 {
-	WARN_ON_ONCE(1);
-	return -EINVAL;
+	struct inode *inode = mapping->host;
+	pgoff_t start, end;
+	int ret;
+
+	/*
+	 * Migration invokes ->migrate_folio() while holding the folio lock.
+	 * Use a non-blocking trylock to avoid inverting the lock order with
+	 * truncation, which takes the invalidate lock before locking the
+	 * folios.
+	 */
+	if (!filemap_invalidate_trylock_shared(mapping))
+		return -EAGAIN;
+
+	start = src->index;
+	end = start + folio_nr_pages(src);
+
+	kvm_gmem_invalidate_start(inode, start, end);
+
+	/*
+	 * For non-confidential guests the folio is host-readable, so
+	 * filemap_migrate_folio() can copy the contents itself via
+	 * folio_mc_copy().
+	 * For confidential guests, this would need firmware assistance.
+	 */
+	ret = filemap_migrate_folio(mapping, dst, src, mode);
+
+	kvm_gmem_invalidate_end(inode, start, end);
+
+	filemap_invalidate_unlock_shared(mapping);
+	return ret;
 }
+#else
+#define kvm_gmem_migrate_folio NULL
+#endif
 
 static int kvm_gmem_error_folio(struct address_space *mapping, struct folio *folio)
 {

-- 
2.43.0


