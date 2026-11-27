Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D7423606A331
	for <linux-mm@archiver.kernel.org>; Fri, 27 Nov 2026 23:01:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=fsZOy3Y+
Received: by kanga.kvack.org (Postfix)
	id BB0CC6B05B3; Fri, 27 Nov 2026 18:01:40 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B88516B05B4; Fri, 27 Nov 2026 18:01:40 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A53866B05B5; Fri, 27 Nov 2026 18:01:40 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 70B986B05B3
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 18:01:40 -0500 (EST)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id D9F8480551
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 23:01:39 +0000 (UTC)
X-FDA: 85482422718.17.F0EA65C
Received: from BN8PR05CU002.outbound.protection.outlook.com (mail-eastus2azon11011044.outbound.protection.outlook.com [52.101.57.44])
	by imf02.hostedemail.com (Postfix) with ESMTP id 1F00F8000F
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 23:01:36 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=nvidia.com header.s=selector2 header.b=fsZOy3Y+;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf02.hostedemail.com: domain of ynorov@nvidia.com designates 52.101.57.44 as permitted sender) smtp.mailfrom=ynorov@nvidia.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1795820497;
	b=pOFhkLzxDxfObD4xr5ftXcWuZu4j+HYJNXjzOpMw3JjbfFze+0fOH+tIKJeecxTLtPpWbh
	2NIvtB1RyZ/rwerNok8ropRZphCS9AqPlWyTCIXipojbD7whsT1/O17Fb8+EPm4VXDAjZD
	ooc9emssH1cVI7BEznH32V3gODrHGt0=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795820497;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=sbZ378tAoi2FUF1xupjieQK7Xhu0KLqLD4MvWDVJOuc=;
	b=rxP8QBx1Rbpwo7pCEpiRW52wfQkJns5cQCMGA9Oo4vJrfZBhAofDAcBebj58AWOrcXuQV3
	Z+0L1WypzLvgxnGqgQuEiGoJDH07nfxnBY7hKNWsnM25QmhT3W+2/yORo8dAFwMRDk5Xdc
	zXzl3aze0X+dbJRC8HgoRX3vwnmx1kE=
ARC-Authentication-Results: i=2;
	imf02.hostedemail.com;
	dkim=pass header.d=nvidia.com header.s=selector2 header.b=fsZOy3Y+;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf02.hostedemail.com: domain of ynorov@nvidia.com designates 52.101.57.44 as permitted sender) smtp.mailfrom=ynorov@nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=TILDMQLQ8uM38Xszyeo6JMzPc06Z/8LkdG4+q+SLVdrgRIO9YR73SWv6EkWKjk7O+FawijRKZEfF5jPD/wUQLzNm7RW/1bHmT1LRRbB60qxRrQlp6YMVX2LDP4X1DIYB5L0FZtDHXMGEhLOUriTC4QUC3rA+CbN5PAPMH8zW9eX5WsTG9yVRb2j5hi9zRGo540V5yXyUmtyAVYXHlXTIlgqTzdGs92d3t0ifC1DKWuepyzrLyDsSwTN2YiQ9+ayGMRzxgNIK6uIpiMCbsx8mPkxY3XEluM797ly6c+aOPgzT/P/eSxCFYx5RMKUikQn05lHOMVZqpHAxYXjT6G7DdQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sbZ378tAoi2FUF1xupjieQK7Xhu0KLqLD4MvWDVJOuc=;
 b=DKl2WfcVcAeiaM4NqKMqIuzXw70CVc6NSzZm1W4eFX1P+6LowYoR1I9nzlCA1iqI1eIe/3nTP1HVXFWwfpNEO7NMVyUY8bQdcgA+j4zpZPE+y8VeBn0WsttO75vy+5YR//aW/Ft2plhkuvZEee4SPY4743ankJAOmMBpH2YN/oaTak3uLDaTToNnUlhF3PeFrQ+2ZNFqrBPLmrDPO2S1Yq6EWlED0qwBOIvzE4REAINvzvM6X1TLXnD8XAjC757Xiitwr7V9TMDYmVV57qCj93DzTFpwrF8YJZVRwQ5kG0bKiq/0BNd5ep9s07YPqXoNjfYuDHN7Ay+yzFc1KUwjfw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sbZ378tAoi2FUF1xupjieQK7Xhu0KLqLD4MvWDVJOuc=;
 b=fsZOy3Y+wavW0IOnIpo2fXdfyY3efpNdZjVYzpDdWqsziY+RgAd9JUrgi1BBC0iPRQnfhAvSuLCYC0zlCmsjZTRpTqIjWpnDE+MjN1/vJ1/aQr7ufCXdUuEGRL/AWBhDR51T9V9T9WOf4hdL3vAhZ8wjYntYI0UIGjAPuwJhsYrNGGAjL1oWzXbCO38E3Dwc/6iEy7UlbI4WT4TAWeLhMhfcfc6g0o8nyX9f4eSpygA0fddV3+YJuOZZi0vULpON/8r3DfHTMxJmL2yEMfTbhPTddtCLHVpDDENPHFQShuh6whBG8rypH+8yEpx3RYj/j9jzOo0J5Vtjt6hHTjwHWg==
Received: from SN6PR12MB2814.namprd12.prod.outlook.com (2603:10b6:805:72::33)
 by IA0PR12MB7505.namprd12.prod.outlook.com (2603:10b6:208:443::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.662.11; Fri, 27 Nov
 2026 23:01:32 +0000
Received: from SN6PR12MB2814.namprd12.prod.outlook.com
 ([fe80::9a18:413c:9702:8f59]) by SN6PR12MB2814.namprd12.prod.outlook.com
 ([fe80::9a18:413c:9702:8f59%6]) with mapi id 15.21.0662.004; Fri, 27 Nov 2026
 23:01:31 +0000
From: Yury Norov <ynorov@nvidia.com>
To: linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-mm@kvack.org,
	Rasmus Villemoes <linux@rasmusvillemoes.dk>,
	David Hildenbrand <david@kernel.org>,
	Gregory Price <gourry@gourry.net>,
	Zi Yan <ziy@nvidia.com>,
	Joshua Hahn <joshua.hahnjy@gmail.com>,
	Rakie Kim <rakie.kim@sk.com>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Kairui Song <kasong@tencent.com>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	"Rafael J. Wysocki" <rafael@kernel.org>,
	Len Brown <lenb@kernel.org>,
	Jens Axboe <axboe@kernel.dk>,
	Peter Zijlstra <peterz@infradead.org>,
	Mel Gorman <mgorman@suse.de>,
	Steven Rostedt <rostedt@goodmis.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	linux-mips@vger.kernel.org,
	linux-acpi@vger.kernel.org,
	linux-block@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org
Cc: Yury Norov <ynorov@nvidia.com>,
	"Liam R. Howlett" <liam@infradead.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Baoquan He <baoquan.he@linux.dev>,
	Barry Song <baohua@kernel.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Qi Zheng <qi.zheng@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Wei Xu <weixugc@google.com>,
	Yuanchu Xie <yuanchu@google.com>,
	Yury Norov <yury.norov@gmail.com>
Subject: [PATCH 00/11] nodemask: switch to runtime nr_node_ids
Date: Fri, 27 Nov 2026 18:01:17 -0500
Message-ID: <20261127230128.111933-1-ynorov@nvidia.com>
X-Mailer: git-send-email 2.53.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BN9PR03CA0605.namprd03.prod.outlook.com
 (2603:10b6:408:106::10) To SN6PR12MB2814.namprd12.prod.outlook.com
 (2603:10b6:805:72::33)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN6PR12MB2814:EE_|IA0PR12MB7505:EE_
X-MS-Office365-Filtering-Correlation-Id: 3aacc3fa-e796-4fbe-29c6-08df4cda601e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|10070799003|366016|23010399003|1800799024|376014|7416014|921020|10067099003|56012099006|261021121427099003|261022075727099003|261021123027099003|261102123227099003|261009223027099003|18002099003|11063799006|6133799003;
X-Microsoft-Antispam-Message-Info:
	viNvRmmBNyRbFaxrjDEGZ+mmwXnOMtKmPNTWubRlAJkk79qJ5o1DwJcBH82lvw3s7WUonCFyjHI1YPyh/DxzO+eBcIgy6tVIi7Czv5wojWRqMBuwJKKI/fwgdOpeINKZ6At1UxomZE6z8+skBxX7y+yNTHNVFjrNSUCYL+2jk/SWqpFTIifxashdWuEP27Y2skmv/WB7NYbk8V/lrBdYf4OcaAa5CR5T58VgEAMWqG/Q3RO9YN8DAca9FuDjJt8i63fwq1geo7UEvmp8RNpcoTE4ZMn74tnVPgQCUcFsRMpHErZAtHuW0i4phFeriR0gnKBZ6AmrqIRm3rSRovNB/uRIeKdLgTYnoWcA5Mw7YN9WbytVMagaK94bgZ/ypgpgHwG3HR02sAMqQFOVmu+xMhL54gc3uxa1SGpPUliRZktDnE5tnxhuynn9t2Ms80BCKV/ye9P2LRVda12FM0WAUFM9wsQy6m0m5aP7DZn72U7C6VISkCETLCMBsJZpeK1BG/9Hnk7KlACB3uAnVQEwnl8k1VAK6HFhrxZh/wHZeBy7q4rR/dgCZC8tuZWhNitXtY7IJWWWBr8WisOYG2dW8OdHd2D5OUEXbF2w7v4iYcWK0Sup3Tz+CPvql4k2zmXy7cknhgAZVN2Q7WZeZq1Lsz2o6ok6XbZen8Lk+LdygUpVn79YxYQnDNlnJcU7+y3xYMvZZI5Ym6tnDocURhofqQ==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2814.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(10070799003)(366016)(23010399003)(1800799024)(376014)(7416014)(921020)(10067099003)(56012099006)(261021121427099003)(261022075727099003)(261021123027099003)(261102123227099003)(261009223027099003)(18002099003)(11063799006)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?JG6uxaQO/BYOx0yqEclkqPBz5Rjtq57sxlhlf3+mVThpapC8j88igUxCceSM?=
 =?us-ascii?Q?/iOonaQWQ3wYGSih8oFCk/ZKJ2rzFVI7SmkMTp94lWSO7JpEQLILqvRHT/d/?=
 =?us-ascii?Q?mPE1h4AAw10DRK7tzyd5WzvY4va4RKka32dYo/jFmQ3adjZWi2nCna+muPuW?=
 =?us-ascii?Q?ta0VEQfbK4NM2nofFz2r6j+o80H+XAGWpv3VkYo3uNoJtv20NlQHzUgD/1Ri?=
 =?us-ascii?Q?8HpK86qZ4+aU1+/pSGWYsYQIFyNfzDAYMYfRFNyeswTIwcbU/4kHckDEABA8?=
 =?us-ascii?Q?kVs23EHoETajMeSqSZbDuOeVNafdNOqJazJya+fB/gZkS5ll8FsTEcVQRHvw?=
 =?us-ascii?Q?cOdaUdX0u6Sr0jFDOr8M1evZvWZDRstUp96utXQYOUMZFUABcldWGVQq0KzF?=
 =?us-ascii?Q?aXHTKvdHtYhxMBVN+bkf9YBux6PMa7xiN60kEufjbOnT3bqFpgBMsqP+EHJN?=
 =?us-ascii?Q?yxLl21/iDoRFculfUfDNChRKOUNPqxgZZwF6f5wooOyWImsJS/iUR1xoNKwf?=
 =?us-ascii?Q?TapsDcoG9aTN0fvRWPdHDscPW1whKuDH9ojyzJiiEo0FprvCH+g/tVOXfbSu?=
 =?us-ascii?Q?A9qdfKf8pqn9dIhzZiYB26MjXozXBhhcdcl0jy4SrItIwdmetp1LOKLyi2e2?=
 =?us-ascii?Q?S2hDqs/Awlm2hlwkEQrNITeXKHPj+2dINHk04mQnSY3l/QLWKchdwtG9BHD4?=
 =?us-ascii?Q?VgzRvBorv7f3707aFSHp+loo5m4JDuYda8mS+LcVCf8dmRTsBEhgJp9in7jf?=
 =?us-ascii?Q?D6MfzDt0utxvKfgS8AnHgm1F3hkf2z0ybBJRIOE1r/8yFLXWKq2r/rL+DKxT?=
 =?us-ascii?Q?LlZOImoJ82CMvnwSgb2+SSweeAAXmwheAYHN8KuujulX+dsp4gxVlaDlsfUo?=
 =?us-ascii?Q?teXUHZxwiESs+IZHQdO06uAgG+oEnhIjw6il9m9JBnxWHgr7wFo3kH8yfTsf?=
 =?us-ascii?Q?IxemFafvRUg3Ypc63hXtaESzE0KJ+mLsSFHSNdvDdQym5aMyhnI3w2Jxc4nR?=
 =?us-ascii?Q?04ceCffFsdXg5uWfQB1a0D9tOmxJNc7TeH0TcASZGSrt2HcZgtU0X1//J+p6?=
 =?us-ascii?Q?F+sWW0FVC82+q/4P+UP4haiVngHnikRnEeGjxtxzNhLp56TSfaNtUDLJGR1P?=
 =?us-ascii?Q?tmzb734sXjpi9oPCgIUcv34CcXLVsGX+uMRGziPwtu/8PoFM+iiS2dY4JEWW?=
 =?us-ascii?Q?Hd2w0N5mz5sOvnWLvApRXAQ1dhggISR5F8u6dSMurd4iiP+Pt8eIiZ0Ln8xW?=
 =?us-ascii?Q?rfvA2vIBKD/LqINMJs3SSQ3cPgcBhkusddYBjnfmfmfJ6HHyYWYkQtL7D2ly?=
 =?us-ascii?Q?9w08meY2GWiqaZIcvGZ5H7i33Dh8GNnsZAv1GiDV1TXu4N4XtbuAl3I64v5X?=
 =?us-ascii?Q?pXWUlVMZA23+mBGUf0H3b4FGBmhURevNp2ycsgDLYMajouy9i2KFesAkTjQF?=
 =?us-ascii?Q?lwJWCpBoZc2ijWBPSM8CMYpIQXhfYMwmq2S5Y/wIM/sjNg9AP1aAH9jqwl5e?=
 =?us-ascii?Q?DRM6WCbexfie2eSaCUIWWzYvDJtxewRXCzoX4fhvsC7JbF2K9ZZQzzUFYhhB?=
 =?us-ascii?Q?IVKsDOwt27lu6guki0QN5BopbYpf8p0lAFV0BBjHEYYUOh+wzmPIiCQn0+38?=
 =?us-ascii?Q?HhnSRIjYwoUxXgoG55dEwA/dCxclDTovSxJEg6RA13c+BLncBBA0ETLtMYHJ?=
 =?us-ascii?Q?oai+LPNoyRZtJ/merxTxNwM2n86ohjYpIZpEcHGcdhDqoL4sFV/P5mrGXCXs?=
 =?us-ascii?Q?ugvu7NdMumZSgI1iLvGfYFVmj0n14nFmuukRsEAUEqVDTm7Nfnr3?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3aacc3fa-e796-4fbe-29c6-08df4cda601e
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2814.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Nov 2026 23:01:31.6724
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BhDbCocEeFRvnnBtIaykbsQhxfZpkXz/s61vy+0owoz/4ZeSpAG39cHvmM9YrMN/WiBnoThg6sPAxx8oEb5S8w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR12MB7505
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 1F00F8000F
X-Rspam-User:
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: bd6eoyaf6ejfj9gh4tab9gf85kknxzp3
X-HE-Tag: 1795820496-738232
X-HE-Meta: U2FsdGVkX18P0QL4yyE0/AuGvnL2/Pw9G8lJpK1L0/PTCOSPg+By1Z8NvphmLe9TXacs86SK2F9CGmShEOWT5zQlP23QEwSV4eb4fYG5iq0xmBRsLPjiX1l9TcgJfd4/l6tOnCoYgQuflPEMG5Q5MuZud2pZytk7wl5M3DPvFeRrPHmDGt3w1JNAiI+47c30pL8YoeHurvvTFVlowUWam6by17rurnun/upZv45gj+5q6EeKW0kLt8TcaJgrhdUI6cksPs1sdYpld4hEZQVxqc7VizC1InVUqIQYoVJVYHNumfzdBwjP/ITEY/bXFnI4lXITCbMr6CZfyPvJHVfbcB40M2dCAIHpAQhR0l6eKCg/Vvu6zxtp/y+hQPdbWLT49L8j3jlfqZ92I5zaX4j6GnSSquSMXoWLcRYjXWBP+faCzKrfdVUEUFn7H+ZXCYQ1v27fCqMLEuI/Zn+w+ycMblXWI/aoI78SlXyyT4ImAkakIxgvu3+z73Fe2w7vFLJLqku6Y8hPU+UJGZs8t4C5HgWTUF64xcUdGVsJ6odv44Fd3umKVsrk/CAzltYu/wU4mJsC7sIRR9/jY0zBBqzRgDolStUcISqXiaNbZPJHblWkfb/sWdGHCT0HYuqkboh6Ckk2WEz9zkgDl4CR1zsewJgyoPdYKI/TPMFIZ4mtWhJ9zXN/PgfWhDHllCxsMEYEcej6sO2Wn5QwGXLsnxG14QzeAQWiBRm73m0/rXnA3W3fmb+DCkvtHUTa5Sm2COy4hgvFmUmGBoPpPugkMTLBPNMqeLd5DqQQV1JpP5nfxV4571e/ZyIwkiGAExXAuKokEnELX4YRJunoeGBkHfLBzcZFyRNL1wJk/gU1lHcYj/yrFxaiB4fnOVZGUQEKVBjmicFAemtWiFjMR9bYE5ttq/BNM9OFdS2gqPmz+rv1KdWHUnrQyJJyH0j/Fk+XdkJoKiYRQ5r8LDwp9KoBznV
 R4HDUDvr
 eDCMINOto42crWOqR9uofbTaf2L/Z/Z+QQYYWo5n3/Y8CoGrfQJzUPAxsG+ED0mj8uK3JdA4vOhbXuWYhQO4ql0RlzsUx7bxaqO1XffR+GFbaiOEWCtrhU1U17B+Ng6ZCK/j/vYptnDLVi2R7HfJpcXMCz1pEazdceq6zYLNjXI6Z95Q1pQmvmcGJ7AEgenbR52t9eNP9YBflUlP7V90NtRm1A+h54IdSgvojq7RbQg61+265CIn6nL9hBZyEGB6JmYmZ+P/kVJq/XbLjyRPW6ufanmuvZc2tLez8VVfC+YB8iwBF49uVqJrXM4spWd12g673r2b2UNaagJQDURRiziaPbAv2h8xxVyxpd3JdbD1v9nBTi1s3rjvzuLvnc/Xtnre02eK3lF6jGj8RIGa44PuP6PIjH6q49oeYGoh+QZIjtLBg0Mw2Z/hFlVfVW36YFe3qZRmVckoXK8Xpw/MYc+kjNahCL+MKxSglg2IzPJC/90d4FVj9x1GA81ynh1xFP5y/weN+8+N8G8tIoqIGcOH1s0wj6V7vSw2+XfE0bwlsLPegVGu96UUo7INl3gbQFLYf8Qnt7lJSVg262+i3ZbvzcuZQqJV8vB6OajDSxKs5gRSYBHvtzT1kLKRTuhDYz98vH6jeAzbgMIS8gJHMD74u8KXcsSV/3bn0mLrOBoiPV8Wb13C7tqNgZtCIFJ5TCehwUQknkNfkltVNW+d1x+eC14DPDhkO9C2LdI6urd8ZLnAcGVLhNeJ74Enhll4K9cdY8UWwBk6peeBjqHoDIJESj2HRXMPSbPBDSEO64e6+Jz1WlQZQdzl7Gw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Nodemasks have a compile-time capacity of MAX_NUMNODES, and
nr_node_ids describes the runtime node ID usage.

Modern distros, like my Ubuntu, default MAX_NUMNODES to 1024, while the
actual number of nodes is typically smaller. All nodemask functions
currently refer to the MAX_NUMNODES, which adds a substantial overhead
on every traversing operation.

This series switches the kernel to runtime length of nodemasks, which
also saves up to 8K of .text for minimal config, and accelerates basic
nodemask operations ~4x if MAX_NUMNODES == 1024 and nr_node_ids == 2.

Yury Norov (11):
  nodemask: add 'small' and 'large' compile-time sizes
  nodemask: pass nodemask length to node search functions
  mm/mempolicy: reject migrate_pages source IDs beyond nr_node_ids
  mm/mempolicy: preserve full-width userspace nodemasks
  mm: switch to runtime nodemask length
  MIPS: IP27: switch nmi_dump to runtime nodemask length
  ACPI: NUMA: switch acpi_map_pxm_to_node to runtime nodemask length
  mtip32xx: switch next_online_node() to runtime nodemask length
  nodemask: add nodes_copy_and_extend()
  sched/numa: bound cpuset trace masks by nr_node_ids
  nodemask: add cpumask-style operation size bounds

 arch/mips/sgi-ip27/ip27-nmi.c     |   2 +-
 drivers/acpi/numa/srat.c          |   2 +-
 drivers/block/mtip32xx/mtip32xx.c |   2 +-
 include/linux/nodemask.h          | 122 +++++++++++++++++++-----------
 include/trace/events/sched.h      |   7 +-
 mm/hugetlb_internal.h             |   2 +-
 mm/mempolicy.c                    |  55 +++++++++-----
 mm/mmzone.c                       |   2 +-
 mm/vmscan.c                       |   2 +-
 9 files changed, 123 insertions(+), 73 deletions(-)

-- 
2.53.0


