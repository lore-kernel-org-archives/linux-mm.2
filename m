Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8A35860A2614
	for <linux-mm@archiver.kernel.org>; Wed, 18 Nov 2026 15:25:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=MznG/clC
Received: by kanga.kvack.org (Postfix)
	id AEC8B6B05B1; Wed, 18 Nov 2026 10:25:13 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AC4166B05B3; Wed, 18 Nov 2026 10:25:13 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9B35F6B05B4; Wed, 18 Nov 2026 10:25:13 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 715B06B05B1
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 10:25:13 -0500 (EST)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id E6AB9C0787
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 15:25:12 +0000 (UTC)
X-FDA: 85448613264.05.C17BB90
Received: from CO1PR03CU002.outbound.protection.outlook.com (mail-westus2azon11010021.outbound.protection.outlook.com [52.101.46.21])
	by imf12.hostedemail.com (Postfix) with ESMTP id DF7234000C
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 15:25:09 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b="MznG/clC";
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf12.hostedemail.com: domain of icheng@nvidia.com designates 52.101.46.21 as permitted sender) smtp.mailfrom=icheng@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1795015510;
	b=LCylHgJo0WpfePKByhDZXIRRGFrO0iUhqVo08HzGktgzJXnKV9wRTM8FvmVGs9xZq83N07
	dv/mbZO4YtXVLB6YemGHgery4PyBzLPyzAS/X07hHmKTYD+LsjYtQas8qeR5068cKv430L
	Z36QWKx0FsY4TMyypn2icf+SfsHXlPo=
ARC-Authentication-Results: i=2;
	imf12.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b="MznG/clC";
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf12.hostedemail.com: domain of icheng@nvidia.com designates 52.101.46.21 as permitted sender) smtp.mailfrom=icheng@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795015510;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gxrWTZhS0gugiL8hgXJT+u77bM5ZklTCHbmefQsnV04=;
	b=WnpZlX5DAlJI6Svq2hWUupPAoH8Q4MDckN7INeDuPu6HHDZr1DPTm1XgQnqvMVN8CwvU2R
	raDsw0cjs3NAVogxC0UBOu8PYu4LuP7kzl3nSI516GN7QTGZmPD9gjhNiidW2dH0TZtMNw
	6nSmb8n2K2tT3jPp+7PeQg2a9/FI4mg=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=y+H1DhJphZfFoJYyxnf5hSlXWvXqcNY72+OVdbBXHtMRiBLj0HVfykJdOJFpztZg30QwZZDh8JeZkMd5/Pf+v5Kez4MGXIZ9r6mKyiBlK+s/2RrbyH1y0lnLujmjOxytISfULR1pJEkIijbGiyFBeO6IxODzYEdsgy8IkKdTOBh25q/hQ3/r/nN7Pm6OifjOUZxg6Xweh5tF+tae7ulkfHM/F+p89gfC3DllCdGFb/JlgcIxvFLV6BuJq1kw4toBDSsNsrGzOkU+sTP2aL0q2bo7hQB3OGHfkORP5OKZqrVV3iGHyHedCuPh1f79Z6FbOPIuHiaK5/W9NMuSeMGi/g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gxrWTZhS0gugiL8hgXJT+u77bM5ZklTCHbmefQsnV04=;
 b=ci0fNNlarjTjgexWvdMgaN5nUhl17D0O0P2pXrkSPfFYrUp/pMWbFESTqr7T4uE9jlvLIxoUDDhI2ylEZ4mtZEWVPWQje1Q8ioBp6+IdrkxPzGOTK6ziqcdkJa1r1UKLxJ/AzoN4JtYVZlkHAls/F3HAapWcQiCD2YA4n6pBgm7rqp8vEVcQtcdyIW89k50ms8Agaw7sUxzX4N0I5/K5sJkhFY4GenMZ9iUSxac7ocNGZl7Kv65S4WzmLTrv0TgBi4cWiUv15BSdXfQrFj5xOeUtOpgJ+7CsPnJQ2LyYVdQyN16Pn6vnMwZCvcrh5LL8SfPZym6Cw5UDEjxFZVT6ew==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gxrWTZhS0gugiL8hgXJT+u77bM5ZklTCHbmefQsnV04=;
 b=MznG/clCzQcws/ywTzJFF9GWnyNB+KjoKcVl6nV8PW3q5qCfqmncFMCef2C3YiVrOlHZudH6m5Dj8DinbS7UoNdg8yNKBiVprk+jkZ5VgKYhbR7YcfLYznCifvKIlciDJ0zoMETGb+uLe/n58TD+d5BCkh6DSJge9xuGkoI63eMmHmhn09q3sa6rac1P816wBcrUqYEIET3S9Bb21Y04cSslWt4YMq2dye5BLP0/F3PXdgycXfYFa+1fz8dmnFTyKKgJ0d25QSjv2eO6VW1WOd7J0KUe1Y993kSvK1Rad6XYGjZZg1Cuw7cs6FR/vRJs5h8DMR39i15o5wo12tJGKQ==
Received: from BL0PR12MB2370.namprd12.prod.outlook.com (2603:10b6:207:47::27)
 by PH8PR12MB7280.namprd12.prod.outlook.com (2603:10b6:510:220::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.14; Wed, 18 Nov
 2026 15:25:00 +0000
Received: from BL0PR12MB2370.namprd12.prod.outlook.com
 ([fe80::86cf:c3ec:2cf5:74c8]) by BL0PR12MB2370.namprd12.prod.outlook.com
 ([fe80::86cf:c3ec:2cf5:74c8%5]) with mapi id 15.21.0615.009; Wed, 18 Nov 2026
 15:25:00 +0000
Date: Wed, 18 Nov 2026 23:24:51 +0800
From: Richard Cheng <icheng@nvidia.com>
To: "Gregory Price (Meta)" <gourry@gourry.net>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, kernel-team@meta.com, 
	linux-doc@vger.kernel.org, driver-core@lists.linux.dev, linux-serial@vger.kernel.org, 
	linux-pm@vger.kernel.org, damon@lists.linux.dev, linux-cxl@vger.kernel.org, 
	akpm@linux-foundation.org, david@kernel.org, liam@infradead.org, vbabka@kernel.org, 
	rppt@kernel.org, surenb@google.com, mhocko@suse.com, corbet@lwn.net, 
	skhan@linuxfoundation.org, rdunlap@infradead.org, gregkh@linuxfoundation.org, 
	rafael@kernel.org, dakr@kernel.org, johan@kernel.org, jirislaby@kernel.org, 
	kasong@tencent.com, qi.zheng@linux.dev, shakeel.butt@linux.dev, baohua@kernel.org, 
	axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com, baoquan.he@linux.dev, 
	baolin.wang@linux.alibaba.com, yury.norov@gmail.com, linux@rasmusvillemoes.dk, pavel@kernel.org, 
	lenb@kernel.org, hannes@cmpxchg.org, brendan.jackman@linux.dev, ziy@nvidia.com, 
	sj@kernel.org, muchun.song@linux.dev, osalvador@suse.de, nico.pache@linux.dev, 
	ryan.roberts@arm.com, dev.jain@arm.com, lance.yang@linux.dev, usama.arif@linux.dev, 
	kas@kernel.org, xu.xin@linux.dev, chengming.zhou@linux.dev, 
	joshua.hahnjy@gmail.com, rakie.kim@sk.com, ying.huang@linux.alibaba.com, 
	matthew.brost@intel.com, byungchul@sk.com, apopple@nvidia.com, rientjes@google.com
Subject: Re: [PATCH 03/22] mm: introduce the common-memory node state
Message-ID: <av2_8Z2sdM_9zUEL@MWDK4CY14F>
References: <20261114070959.3490008-1-gourry@gourry.net>
 <20261114070959.3490008-4-gourry@gourry.net>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261114070959.3490008-4-gourry@gourry.net>
X-ClientProxiedBy: SI1PR02CA0049.apcprd02.prod.outlook.com
 (2603:1096:4:1f5::18) To BL0PR12MB2370.namprd12.prod.outlook.com
 (2603:10b6:207:47::27)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL0PR12MB2370:EE_|PH8PR12MB7280:EE_
X-MS-Office365-Filtering-Correlation-Id: b9bd8981-df48-43e0-f9d2-08df45881c34
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|7416014|1800799024|376014|23010399003|6133799003|22082099003|18002099003|261009223027099003|261022075727099003|261022105027099003|261021123027099003|261021121427099003|261026121527099003|261026140227099003|261102123227099003|261028144727099003|5023799004|56012099006|11063799006|10067099003|4143699003;
X-Microsoft-Antispam-Message-Info:
	9FavZkWvXNMWj3VAHVQbhiADiCfjyGvANHTfgOl3M1UsqXVJKZrDevLDgb+uh0mZz7jCsxpbYvzg61r/fUpYGxT95K5x12Vh+3iPndNmXNjltmf7wjcsj5AG6893t7zcTTLt8/0XYpvsOq/0k1r7TSBV1+oUQlpsftOgA/Lvpzgu5t6oANEnHqEMLPCFy8Mc9S1P+/GTOo+P7Y10DHQ6fZ9HkE76fd3GH5oYBb+vYi0jFVHWflxH4l03Ff6rm9+nWGEWSffE5Zi4eg+emgNeE6V/3E7TdS7XKQck26/BkPfOUxBkfohMuLDRKZCTMIroMwWOyVFDfYJSIH0eoZsTkV6MPD9FzxQX3vp9Cnx8R3QqC6AJtkTFP3je8su0qsLTEaGIHT09M+QOr8wPcLGzL3V+tGJvieE7kB57sF9+CYPMOyueTn+oXkQzQsEh2jLpdN2VENIxPuzTGklosAUWzH4NBdkqknZ9ELItaA1fzN6f2L4Kp0jXR/jWX4UP5hc0Cqns11ALbjFq7ksivf+JC+M7SRnV+zCp7x2LxyLQE1263vmTIHwExgXqW4Ug8MqWic39ugmJiIN4XBUCvvpzNEaMUWJzPGa5dNTqDh2uWOsLZucPvimeMEPnQH4MULEfhQy6FO8pC2LIWPCUxUcRbmBUrd/Douxv+I3tDRuoUXA=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB2370.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(1800799024)(376014)(23010399003)(6133799003)(22082099003)(18002099003)(261009223027099003)(261022075727099003)(261022105027099003)(261021123027099003)(261021121427099003)(261026121527099003)(261026140227099003)(261102123227099003)(261028144727099003)(5023799004)(56012099006)(11063799006)(10067099003)(4143699003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?QMtXjjialLkCYlSS47D/gDLH4WfePk1cZ2yyMbmm057zZ2nr5z4Zez9SqULd?=
 =?us-ascii?Q?YWVy2zy5aPzO7YeEGfEoXtytSltWc7Gq+aIJpRjUGFXR3Z53W+1z92QANSAB?=
 =?us-ascii?Q?bYkIOtPcPgaSIf85p+8+9qgT1BD2CyresHYf7B0HWutxXwR4+wcB84F7y/As?=
 =?us-ascii?Q?2GzOdfn54t303IUCQnPJoPNNtpKhVfP4Is8RMloSYRlJKP/dgYwn95ro9vox?=
 =?us-ascii?Q?oKRI72qOmmipJmtLtaAIqyKA2ca1mTh5pdmMOaJOGEigwFxsKqzllQ+Wiqlp?=
 =?us-ascii?Q?aw//Mz7UuSwRViJ71GVThMmbY7sLWbOOwZzJfgzkbnAPirlGubABmGv/gZ3X?=
 =?us-ascii?Q?Qx8opKP6a8E0UQScUG0K4mTk4IXbt+OZeUo0+bzIlekl5e5WZ1JWgnyePfks?=
 =?us-ascii?Q?i4WjU3E1YqnY+LglcNZ90arteJ9D+aQ4XC1Wp12PaVb5Sqy7YeXnO8Fxy21Z?=
 =?us-ascii?Q?x4FJFuHaYlUbGy0vmL4SnRXV/37f0/QQBP5QvroMRVcWOtpSNj+XfMApe2rw?=
 =?us-ascii?Q?ZZ9pUV7QvRrwxdLyzKUW4ZF8DJqKMO0Nbp+rLfjrPvwRpTqDSu1VpsPLSxnV?=
 =?us-ascii?Q?LJi8SpUpnPh89VR91qy0BAk3LUoZox6AGILJlFO0INPMFC7Gz9WhIV5YsJ8L?=
 =?us-ascii?Q?lLEmiyDlH+MnhRCSLZZ3CuiFDfaBLleG4F5V3sA9E/kArq+d9UMrCWEUSC+W?=
 =?us-ascii?Q?L5+DTtE4ZABA1HFV2YXjV0ldjnx6wbz332G6bQ3dEkA5avU7HtottonTpgTd?=
 =?us-ascii?Q?JWMHXdiGr9jRhd/7Ya4yZuB24Ia02ubjSkl/03S4l+iRt6HxJJVQnckTyHEu?=
 =?us-ascii?Q?iaNBM3QDw6h1yzPoWIe+MsR+g6nBQpG5lpKWiZSF/Ghzk4mbHsSo6PyG6d37?=
 =?us-ascii?Q?IjiFfm1zypB3z1o6EnUlxhr33vxgvWJv1SG4a5ZRO8jhRFqA4BTmi7q45B2Q?=
 =?us-ascii?Q?V/cJU0A1Jf1A9CiGWzzEdhAEsYikUKO+bs2/Xk381EeHAM+jEOjv/JCk8GZ2?=
 =?us-ascii?Q?BHtiSAcywMs1GlOnIBTDc1oOND5UGD5cC8bFWNEJdEd5v5SW2Q3arPbHOTK3?=
 =?us-ascii?Q?KPyZ1pNPSGpWV8izCXkBFsPPiASLwibRsghOC/q29aj+e1S83em9mhpiuihp?=
 =?us-ascii?Q?mE/CwVqRygYquT8Rlok4EZL7pCXA7lU/n00D0sV3Qk114AXkdg6tCBvBFptt?=
 =?us-ascii?Q?h3GsqlQKBu0b7BFQGqnXDemPaXqc486ewG9okNQpC+Q4QG8/iEmsW0Vt/gkr?=
 =?us-ascii?Q?P0qccdwiktF8QDYVZKmaCSRHJYg9/ojtweHV7YT931/3ZGFO1cWl9SUvLrBr?=
 =?us-ascii?Q?G0j/7xTLpjKJcMueVDItC+DHkojWJ1850btju9g8dSd4kxxT8oecN6DgVpyO?=
 =?us-ascii?Q?NVZsmeIl7r61e5PG4e/4KFtXqOpLD0F44Z5zrdft6h0gB6XqEtDelNa0TVsI?=
 =?us-ascii?Q?Tlhj1d6VyrOae9bS7cSllSMlEbpiQklJCpjf2e+Bw/qJ6j8FAsrMKfgcUu7y?=
 =?us-ascii?Q?LGyIRdwsunRhlCxosSXV0etVVf4Rjv/mqq93bLUdgGx0CxoJ+oN4mbVv1J63?=
 =?us-ascii?Q?RkrUS6ikVbUmbi4eRLq8KztfIWJZH2faFGh14moZB7frdbrBx4qaAPcD9Ebc?=
 =?us-ascii?Q?gBFvofpJgRsbRSVbcOKb5KmRjcPHXuxNV0EVJ+TZilpRCk13vtMn22s1s9/H?=
 =?us-ascii?Q?0uMQ+u3YZmOAPVT38jr+FZNVwENZdaQOTSgalooYHfYQZU8RZDZAK1MXQDeo?=
 =?us-ascii?Q?TB4pSARYnA=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b9bd8981-df48-43e0-f9d2-08df45881c34
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB2370.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Nov 2026 15:25:00.4892
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cqmWLolkJ/Cn1tlLcC2xChQNBNsKbIZ4OhvGFHSz0sFWxsWHoM+OOvw3yJ3nJBYZ1K+MQJv1ruZ4RUUK6b0QVg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB7280
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: DF7234000C
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: ainnx6tmd6oomedq5wj1yk4hidub1tju
X-Rspam-User: 
X-HE-Tag: 1795015509-394457
X-HE-Meta: U2FsdGVkX18qsW5pgyLedRC6ayEE/mZ6+YtwGfiq2Cd10PKh2Q/jaoxpm5KwitG+YBMqQwdL5uXtfFiDN8mtCQjOalDJgX6dOPiy3XhEmxqoX1N9hEcrxWNzIWyDv3zvqCTcKG/exDb/VjwsHBF4zvRH3J3UogkTPuNxfyEL3i4Qu7yIVlkTbiaHMK+65YSOZplVxSeeLuPVtC+LBS8eOHdKERCyu9p6ctr7ZBV59IC4lQnWl9omJ3SjSIMp2Ng0XOf0I9kKder6goLepVMuZOahA91KsFVfE3kj7Np56Jgp8TTBoXZIi9eCQaQHJ7+UxXBSGJ8KrfBMM8/Zei9RTIuIc3Uxn6+/ss6WSNQau3XK0GDlmEhYD63wLyLMPAMlPJ2SCMciRYJ0yjIUnbfQGXtTCgC4WCWsSb6zsI+6+cwBy7R//c/MynBMMUiwatTgiDpIdxjP/euC0jjkHBFnBBzCQnx8RdiBBb1BIOrf/a9JbM2BkNqcupXBdkqZU1M+OI4o2fd+B8IHFqR16VtI78ACy81TvzhToJJj+QvU5Q8LQbKgRIgL6Xf+p0Ea8xO4oHIt3/KQjw0sxjTtI6PpViDDE8LXb1ovNE33VFWrIkChFfldBCGh7U2BOhOF7eXWQ6UhJlnKnk5MISQx1D++CBs6Ws1pR6XQXQWhssU7N7UCFXGUbATyFkPX/0cIg1eDLXu+woL16l9GmFy2Qt2yMGhD0/bFdzGNAwS/j2PhtcKpeOOoc/fYOyLLKVR+hm/hogGtde+a5zIuswHLzso1gf45SBuIoeKcIN8/dtyeM4SxC6mY9C7hsr5S7slyEwTHZOz2kNaWN3j9AHiK8nVZuW8Wyy+AMe+yECbkRiLb0tKPbuTrygzu4zJirEjWU8yA/0gOvzuwsBmSTFzEoXmBnM1qHyaDx0cewO3Dq5LW3schvOWeTtRKgOjVa74jIS8NDUgEQwpaWnGRwqJAm4D
 JWopCn/w
 7Sux2p5fOrXec7PHGRlMAUp6LsFxT10Fii9sQGE/0PWoy8PNhcqIQYuV28ICFluOnOuKhnXKsE+VQ/agUwyOFdHMspRyW+3MznHW4ljMD6FsbCVhsFmT90canZ8kdXQ9osyAPvyJbb/56zDuI9jtmzHNeY7FAHYz50+uU7MVKbFCo2HY07pSDEC8k23UALmF15a0Wo9FKmeAi3d/fZeXv+X6cF/MTWnjG5Nfrw3R5xsLJ53bcXYF9C9nyz272Apw6LMZOKqOAO0DSZFfh8w6N+aYUKJaneLp6Aj8jkbqeCT+WCtBfEMlT4GKjufIkog6KsKn0cNUk9SB9JXhwGcoP37t6xkhyETkfE2L8dvybfMiZcS4zDntPV5h2/Mer+uLvegsENGpKO1pYd8NQibD9vFSXcxFVekWbJQFs3SnD5zcrrrMliCwxtYNom2hWeiVpsofAjzh2XfDVYXzV19XSB+Sqrm3463a5jJi/6esukfGhJIfh+9LBMTJFAY2K7qKvdG2MW/EQyVvETFaENo+NOOvSSubA6SBk3RZWHgeD3qHHdAv4R8uSvw24bD5JbcLoxiD4XjzxcFBX5aSNt557gVc0YNxJFkTESBwv
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Sat, Nov 14, 2026 at 02:09:40AM +0800, Gregory Price (Meta) wrote:
> N_MEMORY is overloaded with two meanings:
>   1) a node has memory.
>   2) a node's memory is reachable via ordinary allocation or
>      an arbitrary MM service may use that memory.
> 
> Allow N_MEMORY to mean #1, and introduce N_MEMORY_COMMON to mean #2.
> 
> N_MEMORY_COMMON nodes contain "common memory" capable of being managed
> arbitrarily by the kernel MM based solely on zone membership. Following
> commits convert relevant N_MEMORY users to N_MEMORY_COMMON.
> 
> Add folio_is_common_memory() and page_is_common_memory() for MM services
> that walk folios. Following commits convert folio_is_zone_device() and
> page_is_zone_device() callers accordingly.
> 
> Expose the state via `has_common_memory` so userspace can identify
> the memory available to ordinary allocations and common MM services.
> 
> Add has_memory to the docs while we're here.
> 
> Every node with memory is common, so N_MEMORY_COMMON equals N_MEMORY
> and there is no behavioral change.
>

This sentense kind of blurred me, you state that N_MEMORY_COMMON is meant
to isolate the concept of #2 from N_MEMORY, I expect something
making clear distinction between common memory and private memory ?

 
> Signed-off-by: Gregory Price (Meta) <gourry@gourry.net>
> ---
>  Documentation/ABI/stable/sysfs-devices-node | 16 ++++++++++++++++
>  Documentation/mm/physical_memory.rst        |  8 +++++++-
>  drivers/base/node.c                         |  2 ++
>  include/linux/nodemask.h                    |  9 ++++++++-
>  mm/internal.h                               | 15 +++++++++++++++
>  mm/page_alloc.c                             |  3 +++
>  6 files changed, 51 insertions(+), 2 deletions(-)
> 
> diff --git a/Documentation/ABI/stable/sysfs-devices-node b/Documentation/ABI/stable/sysfs-devices-node
> index 2d0e023f22a71..a93de328f8fe8 100644
> --- a/Documentation/ABI/stable/sysfs-devices-node
> +++ b/Documentation/ABI/stable/sysfs-devices-node
> @@ -10,6 +10,15 @@ Contact:	Linux Memory Management list <linux-mm@kvack.org>
>  Description:
>  		Nodes that are online.
>  
> +What:		/sys/devices/system/node/has_memory
> +Date:		December 2012
> +Contact:	Linux Memory Management list <linux-mm@kvack.org>
> +Description:
> +		Nodes that have memory.
> +
> +		This memory may or may not be reachable via standard
> +		allocations, see has_common_memory for details.
> +
>  What:		/sys/devices/system/node/has_normal_memory
>  Date:		October 2002
>  Contact:	Linux Memory Management list <linux-mm@kvack.org>
> @@ -29,6 +38,13 @@ Description:
>  		Nodes that have regular or high memory.
>  		Depends on CONFIG_HIGHMEM.
>  
> +What:		/sys/devices/system/node/has_common_memory
> +Date:		November 2026
> +Contact:	Linux Memory Management list <linux-mm@kvack.org>
> +Description:
> +		Nodes whose memory ordinary allocations may use without
> +		requesting the node explicitly.
> +
>  What:		/sys/devices/system/node/nodeX
>  Date:		October 2002
>  Contact:	Linux Memory Management list <linux-mm@kvack.org>
> diff --git a/Documentation/mm/physical_memory.rst b/Documentation/mm/physical_memory.rst
> index 2e67e8b23a994..fd5c5d136180f 100644
> --- a/Documentation/mm/physical_memory.rst
> +++ b/Documentation/mm/physical_memory.rst
> @@ -168,7 +168,12 @@ nodes with particular properties as defined by ``enum node_states``:
>    The node has regular or high memory. When ``CONFIG_HIGHMEM`` is disabled
>    aliased to ``N_NORMAL_MEMORY``.
>  ``N_MEMORY``
> -  The node has memory(regular, high, movable)
> +  The node has online memory (regular, high, movable).  This is a topology and
> +  accounting state. Presence in this mask does not mean ordinary allocations
> +  can use the node's memory; see ``N_MEMORY_COMMON``.
> +``N_MEMORY_COMMON``
> +  The node is on the page allocator's fallback zonelists, so an allocation
> +  that named no node can be satisfied from it.
>  ``N_CPU``
>    The node has one or more CPUs
>  ``N_GENERIC_INITIATOR``
> @@ -184,6 +189,7 @@ For example, for node 2 with normal memory and CPUs, bit 2 will be set in ::
>    node_states[N_NORMAL_MEMORY]
>    node_states[N_HIGH_MEMORY]
>    node_states[N_MEMORY]
> +  node_states[N_MEMORY_COMMON]
>    node_states[N_CPU]
>  
>  For various operations possible with nodemasks please refer to
> diff --git a/drivers/base/node.c b/drivers/base/node.c
> index dcdc8626627a8..cc6696d1390f3 100644
> --- a/drivers/base/node.c
> +++ b/drivers/base/node.c
> @@ -965,6 +965,7 @@ static struct node_attr node_state_attr[] = {
>  	[N_HIGH_MEMORY] = _NODE_ATTR(has_high_memory, N_HIGH_MEMORY),
>  #endif
>  	[N_MEMORY] = _NODE_ATTR(has_memory, N_MEMORY),
> +	[N_MEMORY_COMMON] = _NODE_ATTR(has_common_memory, N_MEMORY_COMMON),
>  	[N_CPU] = _NODE_ATTR(has_cpu, N_CPU),
>  	[N_GENERIC_INITIATOR] = _NODE_ATTR(has_generic_initiator,
>  					   N_GENERIC_INITIATOR),
> @@ -978,6 +979,7 @@ static struct attribute *node_state_attrs[] = {
>  	&node_state_attr[N_HIGH_MEMORY].attr.attr,
>  #endif
>  	&node_state_attr[N_MEMORY].attr.attr,
> +	&node_state_attr[N_MEMORY_COMMON].attr.attr,
>  	&node_state_attr[N_CPU].attr.attr,
>  	&node_state_attr[N_GENERIC_INITIATOR].attr.attr,
>  	NULL
> diff --git a/include/linux/nodemask.h b/include/linux/nodemask.h
> index 28a456c3f5964..7ace610bdd654 100644
> --- a/include/linux/nodemask.h
> +++ b/include/linux/nodemask.h
> @@ -402,7 +402,14 @@ enum node_states {
>  #else
>  	N_HIGH_MEMORY = N_NORMAL_MEMORY,
>  #endif
> -	N_MEMORY,		/* The node has memory(regular, high, movable) */
> +	/*
> +	 * N_MEMORY indicates online memory exists on the node - it is used
> +	 * to manage per-node meta-data and topology decisions.
> +	 * N_MEMORY_COMMON indicates whether the node can satisfy arbitrary
> +	 * allocations and whether a service should manage that node's folios.
> +	 */
> +	N_MEMORY,		/* the node has memory */
> +	N_MEMORY_COMMON,	/* common pool (fallback zonelist) */
>  	N_CPU,		/* The node has one or more cpus */
>  	N_GENERIC_INITIATOR,	/* The node has one or more Generic Initiators */
>  	NR_NODE_STATES
> diff --git a/mm/internal.h b/mm/internal.h
> index 608a83c34c224..af6fc27a9fc98 100644
> --- a/mm/internal.h
> +++ b/mm/internal.h
> @@ -65,6 +65,21 @@ void folio_mark_lazyfree(struct folio *folio);
>  void node_set_memory_state(int nid, bool high, bool normal);
>  void node_clear_memory_state(int nid);
>  
> +/*
> + * Common memory is available to generic MM services. ZONE_DEVICE folios do
> + * not qualify even when their NUMA node is common.
> + */
> +static inline bool folio_is_common_memory(struct folio *folio)
> +{
> +	return !folio_is_zone_device(folio) &&
> +	       node_state(folio_nid(folio), N_MEMORY_COMMON);
> +}
> +
> +static inline bool page_is_common_memory(struct page *page)
> +{
> +	return folio_is_common_memory(page_folio(page));
> +}
> +
>  /* mm/vmscan.c */
>  unsigned long zone_reclaimable_pages(struct zone *zone);
>  unsigned long try_to_free_pages(struct zonelist *zonelist, int order,
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index 834d199ff8429..6ffa972811462 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -203,6 +203,7 @@ nodemask_t node_states[NR_NODE_STATES] __read_mostly = {
>  	[N_HIGH_MEMORY] = { { [0] = 1UL } },
>  #endif
>  	[N_MEMORY] = { { [0] = 1UL } },
> +	[N_MEMORY_COMMON] = { { [0] = 1UL } },
>  	[N_CPU] = { { [0] = 1UL } },
>  #endif	/* NUMA */
>  };
> @@ -215,10 +216,12 @@ void __meminit node_set_memory_state(int nid, bool high, bool normal)
>  		node_set_state(nid, N_HIGH_MEMORY);
>  	if (normal)
>  		node_set_state(nid, N_NORMAL_MEMORY);
> +	node_set_state(nid, N_MEMORY_COMMON);
>  }
>  
>  void __meminit node_clear_memory_state(int nid)
>  {
> +	node_clear_state(nid, N_MEMORY_COMMON);
>  	node_clear_state(nid, N_NORMAL_MEMORY);
>  	node_clear_state(nid, N_MEMORY);
>  }
> -- 
> 2.53.1-Meta
> 
> 

