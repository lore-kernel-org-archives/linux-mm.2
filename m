Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 19DEB606A699
	for <linux-mm@archiver.kernel.org>; Fri, 27 Nov 2026 23:02:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=kyEDwYbO
Received: by kanga.kvack.org (Postfix)
	id 60CAF6B05C4; Fri, 27 Nov 2026 18:02:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5E1B56B05C6; Fri, 27 Nov 2026 18:02:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3E8A26B05C7; Fri, 27 Nov 2026 18:02:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9995D6B05C4
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 18:02:09 -0500 (EST)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id E9D55140521
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 23:02:08 +0000 (UTC)
X-FDA: 85482423936.19.37D6F95
Received: from BN8PR05CU002.outbound.protection.outlook.com (mail-eastus2azon11011044.outbound.protection.outlook.com [52.101.57.44])
	by imf02.hostedemail.com (Postfix) with ESMTP id 0EF0680004
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 23:02:05 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=nvidia.com header.s=selector2 header.b=kyEDwYbO;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf02.hostedemail.com: domain of ynorov@nvidia.com designates 52.101.57.44 as permitted sender) smtp.mailfrom=ynorov@nvidia.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1795820526;
	b=Be60iO+UkG5Dxfz9kVWGTESckT3BHCx7gWmykdQ1Z5VI/il1HPX2TGAPBLb9DXhptijwRR
	Ahssq4JnBsSL8HdlAdY4ILicJI0o1Rzjglo9VjipFrG3Z1eE9C+o5vwMNuJx7lGM94hbUG
	wvJzQitnoYZQI4WU7wxPaPNQhaIo71k=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795820526;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZIE4iGENsrGg2GNp7iqSA5q8ihAT0ZByPRKYcBLYetU=;
	b=s+8fLMoq5hYbC5bQYGW0vxN8gcPzVNDHp4yKuorOOry/Ak56MvPyUWL0kxCISeXvWM/QAs
	ufTCAQG8vYaC6s0F0Qmgp4dqEu97lN8eVE4ngBmVQNjQuhaqDMxATF6UY15AxPS9Ro7C/t
	oTnshsIcdBwH25PJkoWU8CbKmxGiPK0=
ARC-Authentication-Results: i=2;
	imf02.hostedemail.com;
	dkim=pass header.d=nvidia.com header.s=selector2 header.b=kyEDwYbO;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf02.hostedemail.com: domain of ynorov@nvidia.com designates 52.101.57.44 as permitted sender) smtp.mailfrom=ynorov@nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=MKmzDqvO+p7IbaNru2LC/9dYu6DAzClt+DqrSlQvYta7YkwoJLYJP75bDoGmWJ7d6yo0qCVJV+ZOQhm55aioidSHvpgCTc9rBtq5gBRYXJZQchne74VVPl5TWWi+4qAUTvxgxUnCH4eWGesWKK8527OQbukohgHfeiqGtLaS6w4rfcnaeWgJ2h1LnxduzKMwe4n4LW1TQ3F/VyjO2vpi8fitaP3bHt5v6s2/P/x1Y1kovFyskQVaC2sT9TG2Wz+ZHSTVNbUhHmBf3svfsgA9cMFE3DahXXGLXOa5GVvU3RAyY7nwPmb6/zZgIXRf4H4Xk/MGmxJXAtdcwKG6kTJHlQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZIE4iGENsrGg2GNp7iqSA5q8ihAT0ZByPRKYcBLYetU=;
 b=U/fNBhncK34D+2+B4Muai0fkGL4thPMwy90OB7UcfJIeLDnk2kou316DG1DIziDsBgI9B7JElgQ3eV9rCkXZEtHwtpx3jSSYlYiaE2fFRxfPKQVj0tdavLskJumq/UupKn+i7ctRQjZEmVRmMnOkYSd32Ha1cJqqqw0ajMSDE65K+WogL9zpliwfjv2uS26B8sMKFfsaHrxk7YKeUgyuQ0y5NXIcF9VTV+9hUJjZuNk0goP7yJBbhyszIqoiYZ+X8cEPn3gTPxfaJrO39c4YCOxAId8HjpZ3zwQM0F+5HCpnCZCYUtwueWcXrmNXhjJ3RAPl2NU+nj0ZHEmQbj2HRQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZIE4iGENsrGg2GNp7iqSA5q8ihAT0ZByPRKYcBLYetU=;
 b=kyEDwYbO2msGAIueRnmpuZMtjPX4nB2y7RA5UUiftYn8i2MIjzUeCkzkm9NLKIlLRfuzDEwIASq/6lhtRCNT1/HeP3YiMgeAgpcNByoyni7EYKv4feAqppihFDUwhrgG0TFb/GB4+cUgtdL7m+X0lBtgULlWnSqNzhudNYClhhqcQbC3okO5Y/KO4/16eXx5VWBW8pICO07Cv/ty3iKm4HLKWLUvq1eTx8lwZu1NXvEZvaFhZvMSYljFLBfX8QuQXOR1m6JCJtWulb4jLbelPSwdos5cBQWx/t2X6rl93Hn//WZMGIobYC/6KjN8Q99JkI/gg2hs9Qz+PwgsZ4H8lQ==
Received: from SN6PR12MB2814.namprd12.prod.outlook.com (2603:10b6:805:72::33)
 by IA0PR12MB7505.namprd12.prod.outlook.com (2603:10b6:208:443::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.662.11; Fri, 27 Nov
 2026 23:01:52 +0000
Received: from SN6PR12MB2814.namprd12.prod.outlook.com
 ([fe80::9a18:413c:9702:8f59]) by SN6PR12MB2814.namprd12.prod.outlook.com
 ([fe80::9a18:413c:9702:8f59%6]) with mapi id 15.21.0662.004; Fri, 27 Nov 2026
 23:01:52 +0000
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
Subject: [PATCH 10/11] sched/numa: bound cpuset trace masks by nr_node_ids
Date: Fri, 27 Nov 2026 18:01:27 -0500
Message-ID: <20261127230128.111933-11-ynorov@nvidia.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261127230128.111933-1-ynorov@nvidia.com>
References: <20261127230128.111933-1-ynorov@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BN0PR02CA0033.namprd02.prod.outlook.com
 (2603:10b6:408:e5::8) To SN6PR12MB2814.namprd12.prod.outlook.com
 (2603:10b6:805:72::33)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN6PR12MB2814:EE_|IA0PR12MB7505:EE_
X-MS-Office365-Filtering-Correlation-Id: a5a8823c-e45f-4dc0-9e52-08df4cda6d0f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|10070799003|366016|23010399003|1800799024|376014|7416014|921020|10067099003|56012099006|261026135527099003|261026140227099003|261026121527099003|261026130827099003|261028144727099003|261021135927099003|261021133027099003|261022115727099003|261021130227099003|261021121427099003|261022075727099003|261022105027099003|261022113327099003|261021123027099003|261102123227099003|261009223027099003|18002099003|22082099003|11063799006|6133799003;
X-Microsoft-Antispam-Message-Info:
	PIOaLrDmejSFMwfdTY1m+LQhkgiwV7tHLfyUGf9JNFYRWsZMQ43XKxa2f9uWljWMeM5krc/Wyb39LEwqHw8BT3i+UvennbByNrOZ6AFgmABV1qth0D0mra0usWGLCZwb8vSTQTSdwwkVQf71n8/IlTREb+PCLsiEvUJNFU7uU+PtF2sCjnCDIlduS0caFOTQeFlrTJ7tLMFGQaQuxPIRJPVx+1r55JaTC+rCket3ok7yw8O/9jdYZg24McPo3h7l4bcfUx5BxFIhkHYxjkGOi03HXh9IhAGT6fasayYozCCQJw6aUOxOSVbO0O6q2KyvoicFnUVLlRCvtEli2X6/RRBe2dUPns4AWuCm9diId6X5yCqqprTeMZgLxgZoLiAmgWjpaAnWE6kibszW+N7iFltvXFvagrH3Nrd+I39lq+iv+ChcXCw1zw91Ak7wLUrMRLjfQHad5wlk1zlPBXmtjDGJ5BmO3PcDHVIbYE+6CT8K94THD5jEv3iaPfaIH2j6o2dDKrJD+l0wGWiZv2yAEoi16TMdiY3m9XzSs4Jh1ckwuXmL0h7cP1rJdArNiawX3CbY9suEn2zdpHU0brepTGVuQZ/58/GWKfWaewFITZHTat5aTy8K+iKc0bazafiLG5DFmuuQZYScYk04Ba54kJGBA4LVGHN8U7Qk4L4gfHfKMYnUMtPuLCWQRyrJuRNjULoxTYhDT13aBys+qjECLA==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2814.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(10070799003)(366016)(23010399003)(1800799024)(376014)(7416014)(921020)(10067099003)(56012099006)(261026135527099003)(261026140227099003)(261026121527099003)(261026130827099003)(261028144727099003)(261021135927099003)(261021133027099003)(261022115727099003)(261021130227099003)(261021121427099003)(261022075727099003)(261022105027099003)(261022113327099003)(261021123027099003)(261102123227099003)(261009223027099003)(18002099003)(22082099003)(11063799006)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?WTyt9H5i1XcvSRVx6sRQSoviJcqKgxGY3HohdIZQW0oWZfDKELspqchBAEYe?=
 =?us-ascii?Q?g15w/zYjyPAc2kER170uNZDvA7jzoo/1v+nhUvks1j62mKWrVu+ef1dQZOuu?=
 =?us-ascii?Q?TuZoZk68f2SYVXk7VT55g1mMVaO5AvV4uBKjvAs+ZEZoxR1EWlnovELrKmpf?=
 =?us-ascii?Q?sk8tj6+//2hbCZ6z70za24ujF0CLGCU85kXXEHFMAAbb42f08tFvAwZybL5h?=
 =?us-ascii?Q?ohN6EAW+stYD3s4PLNtQ1J3UMhKSTi27PCyR4SP+HGWtUkqWP418lxms2CzV?=
 =?us-ascii?Q?9BGKXO6cTn6pKZrpUjm1iaLxV8bM6A4TsstPUHCj6g4bxVWCfKEZ787A00JV?=
 =?us-ascii?Q?m8pSnRpuf8Ml3KN+U8WIteArnEFITOcFCLCSeo7SVzSolpcXqHLPI3lbFEH4?=
 =?us-ascii?Q?gfNhKbZAmuqdsmwpuGdf/oUJPb9Vyjyi5kTRubNlEJKRNHUeIJjj/vlW+vWv?=
 =?us-ascii?Q?PF4TQ7iaEVcvfslYFItRghLqSm8wAupB8ruG0T9FSt5RSB41NfT8rwWB6LIk?=
 =?us-ascii?Q?v6v5yMl+gb/8wCewIV2+X1X1FLLIJlbh9wn7cupLxiAff8iPK7/ZizA9nPUk?=
 =?us-ascii?Q?0vKnESrsKJ4LNCQQycJVT+zZN9TK34WUlrzguGHBrHDew7/+afDW29vTrSPw?=
 =?us-ascii?Q?K2YKAJSO3jPpjneRKzhnZGVYEAh3YspUlVLmQ6mZ+ZRezu0IGyaD6hRL43mn?=
 =?us-ascii?Q?BnXqeVI6MmmYUVVKlJk+4fbPVR4So+IaKfmUvijibB9cRb4nlUQPbZSGy5k4?=
 =?us-ascii?Q?EkrRHL3QMIK/fCmDVn4oPoTlU0E3QfQgKpE7NkSYVa4DKI+GGiShfp+NWWdf?=
 =?us-ascii?Q?YBlWtgQF2e/210taGAn+k1CDl0LDN+kk68hAmywfOD3UcGk2IjtjNQHoh57a?=
 =?us-ascii?Q?DMEN0htO4U2ffLW3kU9GrlBWJWv8hlngrBpVURF0wNsxvNVil6A+Fd9agsGN?=
 =?us-ascii?Q?i6ceod4RI8Zlo4F+EHNPIepKcoOPweNE2mdUfzad/HvFrLRjVL2pDYHj9rqI?=
 =?us-ascii?Q?RtP4Xwh/7lnS39778xGEz9qjbmqkhuWrTeLRIivG0+cXhBgueA3z5iTlKLkx?=
 =?us-ascii?Q?sYnFztDh6LDGBYrKk3ca1pIZMGCMPOi3mi0WH2UFycQ0QuNgT7xHPsSqQ7vK?=
 =?us-ascii?Q?e2IpZ9W2QjM+j58fT2AgrlTkM38clN3ohnZyXCp7zIP+jhVT6dDyLu96quSH?=
 =?us-ascii?Q?Y567Kd2qNrWnBxhRG3GIQvbARAKyAkGrzHh9j2FAmznMjqhsxbk5w6Fl4TWN?=
 =?us-ascii?Q?VLMFUK0VG5zQkZmxG5hWC2om1FDleTLa4zl4ZN4ClppmApDgBPsp735GAFc0?=
 =?us-ascii?Q?jWGS4FelgqndVgymK90JcerxF2E6OEWiSLs3mU+HBbpjCdxcLiex5L45g1jk?=
 =?us-ascii?Q?5+KGCccTX/DKnKv+G06u/MGhlHTCGJiwNfS3FtKgwrekt5+KYyobuI3fWRcV?=
 =?us-ascii?Q?0lQ0M2rkHPPFj7ll+KWV1Y25FN7mxN1+XpolET1G4sEDdHK2onSCadiBEx4s?=
 =?us-ascii?Q?hDD5BxTzPjkpuuVD0dn/y+nKLm81vQIeBGcDaKQPBdb84VPIJfjGAG8e6F43?=
 =?us-ascii?Q?XzehFXlNR7Qk8kqJOeFo44zeL342ApAE9YhOXAijYLkvUurB7OOJJT9Vjbb+?=
 =?us-ascii?Q?s+2DwXv9qFumCYbV177ZP/QbR8WElNl9+2+diqeLY2nb4Wu8Btp6UYTaRzEc?=
 =?us-ascii?Q?1SlZWbqeL2iJ5FtuLU8tfc9yBXTEUAFa8izyroxDNeI2VzlvJJYu/cWZgqMK?=
 =?us-ascii?Q?h8kraINAwdxTRHdYOoFhuWltDL3btYpDTGumXuzR7SUQAyV765Tl?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a5a8823c-e45f-4dc0-9e52-08df4cda6d0f
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2814.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Nov 2026 23:01:52.8093
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Meivwbm+2xGsYPJ07oOznisJys2SDus3hRrn449fxM48JVaDNkB9gmBJGHCmKwDqBIXQxb+gwGR/nvVbRIwrNw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR12MB7505
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 0EF0680004
X-Rspam-User:
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: tmtq9y6uxb834khj6c8ehzchfj63ch39
X-HE-Tag: 1795820525-191361
X-HE-Meta: U2FsdGVkX1+oFtFDRFo2gL2A5Tp+Dg9DDsDGgsTOoXwovlmEZP30veA+W9IUSzvokyiomHKFnrwy1u3DC+pv4vM5dvmSvmTfjZYZ3tA/ezJGgEHeTWK6qnrGzynx9LPoUoyiy8QFbCtgFmZae5/zHaWA+UeO6oUGpKV6kgwdyOdhmiKy75lKiXBtoZqGiFuTrlmQ6LWq6wYE3ZBSGTtQ5h5L+zI2j4OSgtfszOI8Ny9kHo/w0RBLvnyxw6aKeky00gNuTK+YHhWZxUf3HiO7EQrCh6H9M2yy/+LFYzZ7fBd8dAbCnR2YDg8cUQhNVy2lPCQXlA6tB8Yx6RQf14Dr22uDgRU0Rzg5BoljkS4N+R8i16clWX/Ki9K47LoispUAqrbF34w/oacrPync0SsVfpaPQlFdhYE5BLoOFd+SSIeLgCQ4doHm7FObPs7+UI1VLdsEGi5ci9LELzsU0zuI0gQ4TaN2aE6JC3g2lwhTyaanoqDS9kE+ga05cpCtUejy1paXkVxjB1Ag8snWtIt3AGbP5/ZP9SW10dMvJvA6MyX8LKlJVSG7JUBG9y/TrSR05vmNOZUMLeIdfDrvjS5Kxc5HDrAis6q88wshOEIhkbkYg/gyCUX3rX/kzzaRDbMbpC4EjFxyY4zDSXuX6REwsFIsanlS4I585OJ7uuu4mzUj3iGPm1h7+J4pzPHMtAV2uZpwuXIWRrUw7MnTxi2sZDpuF++iUWfzgInd8zJEsPhZs6id3s2cwkAOdnngc7wRe2cxAaJi3TQ8FyvlFYffHyPRPRa47zU0rAw3gz9wstThxcAB+3yXX9wbDsAJZ4Hown5aOgZDAvke26y9i/JzzlvzxRRVns0CeHhT3+K3YZLx7FCzQD08O65jR4hCyP/ORaQxY6yKcnwQcQLBydgipANiVxdLN0jqCvzhYk3Gwj2MU0CTWqs0Z8sJyzzsenSXMErMQrXrsOBWF3U8FkB
 wa527a4/
 Wd9woQWecHmu4mAWPDpSk+zyITT4oicyZ92E32VAxQ38A1SnecXyjSyMXkD2w123+0iLFw+uJYe0k0XksXKET9EugWhknvcKG+rG+7C9u0rOiR3gdYxxxrQAQcX2MQ2jPI85pf3yNlIbX0pYNnmiqUTFiT6sG9DG7e0mTQIXU9EUfFoiPIQmwntlT8DjJRnmZ+sW6iXGLvaH36FPdKGFoHuPGov9TP6FZ5n0m9N15BNkLR0Rb8WCUseWrHrxLEDaCbCfAaE4vfK1vt4td5CT6iTTBhUKYFYCl9kzkx395k2IMhCHwyCh/RWtyJ866MhWPvxGd0cCswb1bquM/B04rGh7CHeaM1PI6yVPRU8faAd+IcwNBruYCYMav2lWFOa4tUOVcW3EQ7iCXynFIn/ly5iyQSosVWB4kH/LW952ai9AlslrOOTNRANkkS4D7x+5UUF9zN/7y7goBO7/jOenWIkiouqGQBOEL75qJtq+yFzo7rLF1HNzqgdnQ47vMgEWxJ/vmxl/ckNvpyttQAvSfk646zFPAjSRyINZB+Uzel0XBIIe15cIHPSQEDPSb8X9HLyyNK85BzwyHp5LX+JJb7T7u+q/uq1RBXBOGsQRwt1DYaMeUI6h3TGBo2JjP5CUU8H+0cTEGjC4wz1jpb8m1FJWKb92aQggPVj1e1AMDv+h42NAZq6SWaotL5ddNPu8CE7nmS0fWOWsrgM6cJHI16U59bP4Ryo2esD4PC12Zp2XjkzwKzUOXCdMko2cFDJ6MMGrd+uUSkmsumIUayht2gY14qbYBtZvo6um+3MjtNPctOs4+zKxLZfv6tiDgBIElqnLXbq+x5C8y2jo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

With switching nodemask API to runtime nr_node_ids, bits beyond this
boundary till MAX_NUMNODES may be in undefined state. Those bits may
show up in the raw trace record.

Keep the fixed-size trace record and use nodes_copy_and_extend() to copy
the runtime range and clear every remaining bit, including padding in
the last copied word.

Print only the runtime range.

Signed-off-by: Yury Norov <ynorov@nvidia.com>
---
 include/trace/events/sched.h | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/include/trace/events/sched.h b/include/trace/events/sched.h
index 535860581f15..38a2a10cba42 100644
--- a/include/trace/events/sched.h
+++ b/include/trace/events/sched.h
@@ -793,8 +793,9 @@ TRACE_EVENT(sched_skip_cpuset_numa,
 		__entry->ngid		 = task_numa_group_id(tsk);
 		BUILD_BUG_ON(sizeof(nodemask_t) != \
 			     BITS_TO_LONGS(MAX_NUMNODES) * sizeof(long));
-		memcpy(__entry->mem_allowed, mem_allowed_ptr->bits,
-		       sizeof(__entry->mem_allowed));
+		/* Clear unused bits in the fixed-size trace field. */
+		nodes_copy_and_extend(*(nodemask_t *)__entry->mem_allowed,
+				      *mem_allowed_ptr);
 	),
 
 	TP_printk("comm=%s pid=%d tgid=%d ngid=%d mem_nodes_allowed=%*pbl",
@@ -802,7 +803,7 @@ TRACE_EVENT(sched_skip_cpuset_numa,
 		  __entry->pid,
 		  __entry->tgid,
 		  __entry->ngid,
-		  MAX_NUMNODES, __entry->mem_allowed)
+		  nr_node_ids, __entry->mem_allowed)
 );
 #endif /* CONFIG_NUMA_BALANCING */
 
-- 
2.53.0


