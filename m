Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AD954606A326
	for <linux-mm@archiver.kernel.org>; Fri, 30 Oct 2026 22:00:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=Hqd700/Q
Received: by kanga.kvack.org (Postfix)
	id A85DD6B00EF; Fri, 30 Oct 2026 18:00:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A5C086B05B3; Fri, 30 Oct 2026 18:00:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 94B726B05B4; Fri, 30 Oct 2026 18:00:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 639196B00EF
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 18:00:43 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id EE16FA8554
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 22:00:42 +0000 (UTC)
X-FDA: 85380662724.11.B79E7BC
Received: from PH0PR06CU001.outbound.protection.outlook.com (mail-westus3azon11011070.outbound.protection.outlook.com [40.107.208.70])
	by imf08.hostedemail.com (Postfix) with ESMTP id E8084160009
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 22:00:39 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b="Hqd700/Q";
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf08.hostedemail.com: domain of ziy@nvidia.com designates 40.107.208.70 as permitted sender) smtp.mailfrom=ziy@nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793397640;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=E5i8kIZGJ/Avq548RjoiZF3Kzi8Ckh3w/jCqT2b+zEU=;
	b=4jfA6B6Dw9JL3YMBElM7TSt3BZZbSddo86ycORU0U+pKu5nMNrSGGzw8dEWGuSa3F4/dry
	rO2o4kXmNsuk5cDlSeXUIDTxJwhQ9PnEdGJfi8JIooLZ/C9scrERv6owPS02sWlLtDcWJ7
	qM3TBAIy6yTocfE+/WXMXbUEb4NwICM=
ARC-Authentication-Results: i=2;
	imf08.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b="Hqd700/Q";
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf08.hostedemail.com: domain of ziy@nvidia.com designates 40.107.208.70 as permitted sender) smtp.mailfrom=ziy@nvidia.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1793397640;
	b=VJssUAe42xPf2LXXx52T6AXrN3XXl/gHm+9LWeSFwk9ynDW+uoPt5TA1EkKOUl9uQeUX0F
	FsAmKYNsWvkVUhfEnzq3yrg6+X30z1RYYuy8kamhv9u4SWTUYxcaO3un7e6QtPggGnNq9v
	aSaljCGgPwcZLhhBqL2JJrzQ0H9zXfk=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=RabELVE4mo41GpuxlCNYrC+muXJVK1bVDRSlyQ17qc+AZyvaPoU+nXXc5vzRw6IsSnTRq2C9aDXUwdJk+ghS/pJLJjahKrauUC3c/CwDkdzzoBRMrG6KaF0xLvAvT4HPLUT1kj/I9Po6570f7CUo3hM1xoK10UMMtzQGs/nfR9nEf0alm4PfwqpYVAHHscokbuMkmBV75iiZZpAVNcJzYaqsjoEyi39OqPaMMizhaXt/zhvgql4FD1gFtOfWddC4KX9rwapFRSdw68IjJrR33XrjXCClEpH7GZU+x4iNDn7Wa7oZMfNWKZTb90Lp2GH6jXAxXurvU9wk7EGpw1VB7A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=E5i8kIZGJ/Avq548RjoiZF3Kzi8Ckh3w/jCqT2b+zEU=;
 b=D+XWmRyb37CRN4Lk94JVybfhBNkso7msDYk4tCXQpaXhULJImRTtvygDHJnu663yFbRyqHJ8EL7Xdf9OofzLLeCEQpW5+bujyUtJwNFxUw+6Yc6FMblOLGVjCg209qjXzS1jF4Z76vAg6hzanf5cpSoJ32KcdD66A/v1lKiAl+IX/XLIzesUurbxftiTGFEj8W30AT5vEDjEzFf9qAFU8MlfkrKrC/jGynNHPgBB2ylPr5b8Gej/FQqmEJhvM04X2mKVH5cFXTYH4ru94nJnLKt31MzF4NgkMYfzSa/INeg9Q7Ix/LsKG0sWrca1o4J15dPfF1l1dOnG/kawDG2pJA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=E5i8kIZGJ/Avq548RjoiZF3Kzi8Ckh3w/jCqT2b+zEU=;
 b=Hqd700/QG+YDM0AopglOlIr26PY7NJRzrCaPAKT9W4H7at3i140ItqMRU0WSZ8kCSa6ZRLZkNwuRt/P1Z3cUdUIU2R8Qn/hvZ3Fa/Lm6b/mjCydI1lS7Q2UZ4VzrIsdjUQJrhlwzhT5plYMkbyOGe8aKAtC1Dmd7wKZrLxAml52kvwOsLBXH/deULDzJ9QPU7k1FDgw0LZeBtGGcTCg2m4axpRx13Kul8qCsnEQr29BUGhUB1aUdWOc/nn+BbFts7pv+Uh3fUSiG89GLynUDJ7HYQM5zt4znvPsKnQ/7gkEOdPkc8H0EufdOYnlQDDLJu5jRF7TrAOAZ+rG+pkCQ7Q==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by LV3PR12MB9236.namprd12.prod.outlook.com (2603:10b6:408:1a5::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.569.10; Fri, 30 Oct
 2026 22:00:30 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%6]) with mapi id 15.21.0569.009; Fri, 30 Oct 2026
 22:00:30 +0000
From: Zi Yan <ziy@nvidia.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Alistair Popple <apopple@nvidia.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 Baoquan He <baoquan.he@linux.dev>, Barry Song <baohua@kernel.org>,
 Brendan Jackman <brendan.jackman@linux.dev>,
 Byungchul Park <byungchul@sk.com>, Chengming Zhou <chengming.zhou@linux.dev>,
 Chris Li <chrisl@kernel.org>, Christoph Lameter <cl@gentwo.org>,
 Dave Chinner <david@fromorbit.com>, David Rientjes <rientjes@google.com>,
 Dennis Zhou <dennis@kernel.org>, Dev Jain <dev.jain@arm.com>,
 Gregory Price <gourry@gourry.net>, Hao Li <hao.li@linux.dev>,
 Harry Yoo <harry@kernel.org>, Hugh Dickins <hughd@google.com>,
 Jann Horn <jannh@google.com>, Johannes Weiner <hannes@cmpxchg.org>,
 John Hubbard <jhubbard@nvidia.com>, Joshua Hahn <joshua.hahnjy@gmail.com>,
 Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>,
 Kiryl Shutsemau <kas@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 "Liam R. Howlett" <liam@infradead.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Matthew Brost <matthew.brost@intel.com>, Miaohe Lin <linmiaohe@huawei.com>,
 Michal Hocko <mhocko@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Muchun Song <muchun.song@linux.dev>,
 Naoya Horiguchi <nao.horiguchi@gmail.com>, Nhat Pham <nphamcs@gmail.com>,
 Nick Piggin <npiggin@gmail.com>, Nico Pache <nico.pache@linux.dev>,
 Oscar Salvador <osalvador@suse.de>, Pedro Falcato <pfalcato@suse.de>,
 Peter Xu <peterx@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
 Qi Zheng <qi.zheng@linux.dev>, Rakie Kim <rakie.kim@sk.com>,
 Rik van Riel <riel@surriel.com>, Roman Gushchin <roman.gushchin@linux.dev>,
 Ryan Roberts <ryan.roberts@arm.com>, Shakeel Butt <shakeel.butt@linux.dev>,
 Suren Baghdasaryan <surenb@google.com>, Tejun Heo <tj@kernel.org>,
 Uladzislau Rezki <urezki@gmail.com>, Usama Arif <usama.arif@linux.dev>,
 Vlastimil Babka <vbabka@kernel.org>, Will Deacon <will@kernel.org>,
 Xu Xin <xu.xin@linux.dev>, Ying Huang <ying.huang@linux.alibaba.com>,
 Youngjun Park <youngjun.park@lge.com>, Jason Gunthorpe <jgg@ziepe.ca>,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 3/7] MAINTAINERS: add Zi Yan as co-maintainer for MEMORY
 MANAGEMENT - THP
Date: Fri, 30 Oct 2026 18:00:27 -0400
X-Mailer: MailMate (3.0r7038)
Message-ID: <E401AE0A-07CE-4F34-A2E1-CDEE75D9E6B0@nvidia.com>
In-Reply-To: <20261030-maintainers-v1-3-97278f8a5f54@kernel.org>
References: <20261030-maintainers-v1-0-97278f8a5f54@kernel.org>
 <20261030-maintainers-v1-3-97278f8a5f54@kernel.org>
Content-Type: text/plain
X-MS-Reactions: disallow
X-ClientProxiedBy: MN2PR11CA0025.namprd11.prod.outlook.com
 (2603:10b6:208:23b::30) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|LV3PR12MB9236:EE_
X-MS-Office365-Filtering-Correlation-Id: 032dcb69-f3b9-4caa-4adc-08df36d13652
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|23010399003|1800799024|366016|18002099003|22082099003|11063799006|4143699003|56012099006|261026121527099003|261021121427099003|261026140227099003|261022105027099003|261028144727099003|261021135927099003|261021123027099003|10067099003;
X-Microsoft-Antispam-Message-Info:
	d4ah5y0+1P6NaiJgg1DN9jN8AKta5etRJbFddbcQZxUuh9usQv0IZtNJZ2x4XYv8QXOUawzOIP32C551cN7e7sNu1wEdHAeYNbJnrN2UzAhklSThmpg5Q2Uj0dy0hPfMvZ1gkNbKCEK8oSdH1JXqG9/NgEuwekenHtXLCusarBmHaxONE7geAhCSd7GW6li76l8CrnVb/C1ab7AmYlR/GTTB3Ih4SGlviux5BY+8Ra6ZYqsCt3Ltgz7vpCRxBDIlBOTkRyUjAxTvgOvR1I4ps9qxXMdVwzwkjrLKRSywVs5j2ZQ55LRN9gCwqkl/kT1ilzx5Rc70vxDGIxNd4kapWKkUiGMiygvLIep8Bo029ZoBD7xx+EJqZeIvKC9G8sJEBLTgWgHqN4uykdbHDYYL+HhS+o63STcgohZ9Zv67pBxJtL6i8/qbj1qNnyAvC5wpqXFkLjdq2n+3FxWdZEB2hd0pMe+El2RBc4OW3xp3lSUmphlZABZWoHegWAdIIy9QSiLiBcFiaf7LTW1dnGaxpOVjlfZU5xpCYVojk9eqGl4iSbggj1EVKL/lgHLb6pprVulKySwHwk0gdzj+EyvzyORD3qAsglDWc6BXRrSt2R+mwfC5MXgdBueWM5Ee+WWNKYHwesSiGHszceioCRGOV8Kj4CW0fk/eieoz47mBQH0=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(23010399003)(1800799024)(366016)(18002099003)(22082099003)(11063799006)(4143699003)(56012099006)(261026121527099003)(261021121427099003)(261026140227099003)(261022105027099003)(261028144727099003)(261021135927099003)(261021123027099003)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?WlP3FgoCFEXWf4IZRWsNKJ46qMAD9LdddMrIZDw9ge5X3ET+U78K28CgtvvE?=
 =?us-ascii?Q?VyNpz+WzfZWuAm4KEaHTzH8JAfuqQJYZ/hb2xDIQLf93KxtljONLAzzQkqRK?=
 =?us-ascii?Q?COqTN8JYOEk0K5ZYiqpkBg/s/fHoFkrANNhNAKUbGJVxs8ATTEbTl9NwLNdj?=
 =?us-ascii?Q?YcAN1qoLzJt5C2zo9rAlZGZI4V2/ESeF1c1G7UDGViwZP8xyxs+yMV86zu10?=
 =?us-ascii?Q?DBylSXSnJTVmjRba7onJnKWZqcUiBIa6v7kc4Af4yhkUKMqcek4pr+4VTe2l?=
 =?us-ascii?Q?tC9ysYwH0MX2IP2zSDCXJcx9zLmA4WrvFVJqK0tqWlukCPPbAqx1iX6dT8C2?=
 =?us-ascii?Q?dGQzO/HPu7GBOUpxO+PkSjUooTHZC4/7ul0Jq6PKGfnhOERlzuoBdnG4J293?=
 =?us-ascii?Q?5VIpnyMDy3yHtdCaiV4xLXYTaKzSA9y9XxQPPJ+CnO01mVK4l2Mm1Zs7F/5C?=
 =?us-ascii?Q?P12/64y6SgfeAmrRj5nj13bN4l075C4cAeIlrk1UOptzKmSlSnPimOAIlo4s?=
 =?us-ascii?Q?JAXME7xpKeAmeB2Q5ETgDBIhEUAnbUO9mZbDv77q+hMI8mWyul+O9BYCEFDu?=
 =?us-ascii?Q?XqHsG3Xtcq67KjLNGDPiUYha5g5i3wTEgFRGn1RfqaN+DzQGdc8QCewBBcnV?=
 =?us-ascii?Q?pDd5cL67UqRZd1LTMGj9pkwfV7KNeT9aKdcLjqDxzNn+YNKWombF9XtH+712?=
 =?us-ascii?Q?TnCUBTdGBGPeifcQhcUAAnLj9NebO/F7uNyfkwEtFS0x68uI6DAiiRSDk43V?=
 =?us-ascii?Q?wYba39VNzIW7Fl/1/++VvHr0uM2kLyvtuG3nrN44BIXfSweTo1cg86uEVmil?=
 =?us-ascii?Q?DE62PXO0Aj1AUDsUPMxmEc1Z6Y/WGeLAq+przDOKff6RZ2b04GYZfkl5CRrt?=
 =?us-ascii?Q?O6Y961eMm47DX6ezEyMw6QxVESsMzqWPvGK+6Uc6c1uxTE7ROcdTbvABxeZ9?=
 =?us-ascii?Q?wF0aZSFcbBuRP09ncW9hPH/Mu691Jn3g+IxTF7c9xnEyfwkXaz9ncmva5022?=
 =?us-ascii?Q?stgG1tqI37q9UihHoh5PuTPGmWZJIrNVnJUciRWV0r9UGOxsrU572oWIIGwg?=
 =?us-ascii?Q?dL+4JfYzZx5RAM7twBjZtgAToOTpwg5tkA3+0KPMFVX57hUA/qLVJ34b0/bn?=
 =?us-ascii?Q?JkHCUIxaJ2ucV3J0H7mwA1i39/qeGMy1gY7u/aqjzu7R9bIm9SxMAUsrckKK?=
 =?us-ascii?Q?xjQjg7Q4JrJyekfdsMG728mUAZVlsYv3dh94LI6yr5ZCGYtAKzFRgMDiuV3e?=
 =?us-ascii?Q?3nQYE72DeRq/vR9YKCFYhKQSVifo4QEWxLBjjN7wAYDevlLYa/VFQXXPfl5G?=
 =?us-ascii?Q?JZohtA8NcaFpspXmZJYn8wm5/DGGYmYztm/Lk8YdQUPeWRyqdf7+J4S7zPCW?=
 =?us-ascii?Q?/2UeSEHKAoxZsIjI7XhkKQLXf3DjKcKqOC1NqVo53uB+Ekc35LGu+41LwT0r?=
 =?us-ascii?Q?+dhzZuSkc0T1mIy/l+pC9VQYv1MxxfSDrktQDNRpvpfbSZpooyGikFsWCUxX?=
 =?us-ascii?Q?JT7DyQ+zWT/9m2mNKSeQKXhLftv6qPQhEMJENdkmRd6l6iUXkIEtTDhzsS5J?=
 =?us-ascii?Q?sCAdwFvWPOPfiMr+KkvjwZDD+EZ3AleIQO712i3m/c4VoLR7eou+y8uZ2ahQ?=
 =?us-ascii?Q?AYFj362J7A21n7yahkXA0UNzYpCSXHXYP6amEyO9gJwZa5X1Nei2u9AfJzbT?=
 =?us-ascii?Q?8+WrnePLGUxHkGSXjRg1Z1/UXKbgObbBohsRd6J2CjS9kZM9?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 032dcb69-f3b9-4caa-4adc-08df36d13652
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Oct 2026 22:00:29.8919
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: t2nOcr5pMy0tQcBuVgXPA7BoMw6YmTVcRT545prU15ECK9giNEbdn8WWwGGHRpDd
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR12MB9236
X-Rspamd-Queue-Id: E8084160009
X-Stat-Signature: yks6tngmxaf6gqesywmmg5fy1f3weuwp
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1793397639-342853
X-HE-Meta: U2FsdGVkX18+GcjPKgfHvo+yPP/cM9JcM3PXpdSUz/ymkBEp6mVm23TUvzD5PmBG4+XGcGFbR2227c/VrIvMUq4sx4ND2rh0n5v9NG4lH2iqzSfz3C5Nwn3mFR1u14tqtWJs2wu0al2jNUMW2r4AaGi8RUTQgRdSKObuf8Kik+r0bFb4wSq77VHsHmTKU7bCUo7CTAa96FfGCg47WQoLoMmlhvoEzAHyF4BgO0eELI6rhqkHhn9FfIzAqJbPAHyiy/eGPSVOiRBBbgIkctocdJikA0vF34WuZML69XsJH3o8QoOxwDuHjMzly3TSlRXjZIBlb8tSHJEnZ7mZCBTY5YpgQckSaddS406RkorV+1E7yblZL7NBkfIdJADIsoZzzTwCiC3KL/xbS1r67ORxynznXAKS1i27poKIXx25sO9jaJU/SW2t5dLVirXCxU7MiF3V9EdvZrk0lC1Mf8IJPAjaMvj/6JdSAaD6mpYMC0Lt0l8JZTJQqDV6m1L5blMpbykmcrwB0dCZoBeJ8XMxI1NstdYoRl5S7wWZLrfjW7542GmHEpntBLsLNOx8LlujfiqtamZaESfyep9VoGanBNE3OBk0amkzV6Ey5zPIQK/t7XeZxfKb7okWRnEMdKLpQ+BJQecmWpTbeVq5g3tfPJrhZD75KpjP6LDiX8oBXvn9NXEoWv7xXUqgthaRcU0qLt3mfsczwiPU7iPiDFkvmoDVqrFcxKUtehnnXwpDQjqpEAgRpB1thD/o158a+sOrhvggCLw9/8GdUcWg9YaDUYNhDU6Jqn15MifCtlxWobJRoe3XkUgwjBGEjKEpeRzgNg1HTQ2JiWnEubRG6RPYu3xuW/B25+vIHY6F66Ts94HRa0/LmJ1welVpTnHBTSfrtVbBJ4RLprCOhLnfu4h41IfxEVlyHaMawEJN27IHYo02qbK3rc1Hhi80polPKNz5vng+keUcD/LM03B8xoe
 DniZ0rjB
 AHurr5B5tR4iNm4nvdzUuC66T9wbW1lEz41nNeHFKtkFLyiMwU0qH9ffYWneQ04Bd3lcyNhpU4Zgien8N91yzzxTv8mf6GCsGhuzMt1lZAg7bzawBB0r7bVuAmJJc4h0m4/VaF1KbVfzq+5idW18ymeAVIy09VC1xv1yTfhmVULKiDrNiJBmSfu+INFDGafdqGI8VjC5nNldqpBmp8J11y8yohlOn33QRMBiXrV/jTqQ9aCVnyia71dMbpqu4W5Miar2jsa5IWKG1qZaOCzEmI16oAIBgbuE6Dy4dhQM/nxikyJ7fDTXvhXtlzF6OnTPzZG34rjrPheLayZMaw2DRxPKuhGgXKzX2fOObzs/Hl5RGs6KQ9tpkITZDd80vzgzVU2oj4KcH+OiQAdH36KUmSwHVXCxJlRj6WJwJzNuTwTqg6XiSelCslOaqccm8MLQYTdvAgJ8XeR4OoYFcigEmvWuiZglXnR0PGbUy79j38o6GJNt0+AOcDpCEC35vcJaT+7knqW7SEo257ETf56C1luEY2OB7Oz+aRNaUTsylUNWvnI7NpA8vqQFG5yEPnYD2RPXcSYkEzfN6Ept8ScmQjjiN1PLEZb89qgCFA/tX0teQlnVPDEe7mUX6Bw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 30 Oct 2026, at 17:34, David Hildenbrand (Arm) wrote:

> Zi has been contributing to THP consistently and reliably over many
> years and is considered one of our most valuable THP experts. As THP is
> an especially active area lately, having a single dedicated THP maintainer
> is not sustainable.

Thanks.

>
> Fortunately, Zi volunteered to take on more responsibility by stepping
> up as a THP co-maintainer. So let's do exactly that.
>
> His placement in the MAINTAINERS entry is very convenient to perform
> this change :)
>
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
> ---
>  MAINTAINERS | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 0baeb37b0dcdc..02b5b542f81ee 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -17817,7 +17817,7 @@ F:	mm/swapfile.c
>  MEMORY MANAGEMENT - THP (TRANSPARENT HUGE PAGE)
>  M:	Andrew Morton <akpm@linux-foundation.org>
>  M:	David Hildenbrand <david@kernel.org>
> -R:	Zi Yan <ziy@nvidia.com>
> +M:	Zi Yan <ziy@nvidia.com>
>  R:	Baolin Wang <baolin.wang@linux.alibaba.com>
>  R:	Liam R. Howlett <liam@infradead.org>
>  R:	Nico Pache <nico.pache@linux.dev>
>
> -- 
> 2.43.0

I am more than happy to help with the code maintenance and development.
Looking forward to working with everyone. :)

Acked-by: Zi Yan <ziy@nvidia.com>

Best Regards,
Yan, Zi

