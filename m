Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2FF5E606A326
	for <linux-mm@archiver.kernel.org>; Fri,  6 Nov 2026 10:34:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=kLzfYvTp
Received: by kanga.kvack.org (Postfix)
	id ED8096B05B0; Fri,  6 Nov 2026 05:34:53 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EB0D36B05B7; Fri,  6 Nov 2026 05:34:53 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DA7766B05B0; Fri,  6 Nov 2026 05:34:53 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 97CAD6B05B0
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 05:34:53 -0500 (EST)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 069D640226
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 10:34:52 +0000 (UTC)
X-FDA: 85404336066.01.5B883AC
Received: from SN4PR0501CU005.outbound.protection.outlook.com (mail-southcentralusazon11011066.outbound.protection.outlook.com [40.93.194.66])
	by imf29.hostedemail.com (Postfix) with ESMTP id 1EB01120005
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 10:34:49 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=kLzfYvTp;
	spf=pass (imf29.hostedemail.com: domain of balbirs@nvidia.com designates 40.93.194.66 as permitted sender) smtp.mailfrom=balbirs@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793961290;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qiLh7vyAApWlZAt5SbIuDxqY+pzzbqOlArB6fWNJDTQ=;
	b=KNucXKcgQnRgmyXaWelG0BWgrTsU5XdAagN6eifH4XQ6qJ3h9m+aWd7tP3AaebOjuvcvje
	3OGvljmxQLeNykKIplVwxaj5LksIcCv1pdz7sbwTbDL9Hbw8c13jZxfwXN6Qx3/8Dqe4Ni
	IXMN8dvS8hb4htst8FoOQraBpQ400pw=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1793961290;
	b=bc2AYwaj8wlXP+HgJrvv6qlrqUpW2ALo+Bqhr+2iSfatEAhksq43nXfFF956Plbl4hIY/I
	44tFBuX9dwvlYzGHSSzuPVnqd77WqQXID4siHLqhToKTJVZYqhC4WptnkRovqLU0aeNs+3
	VikHjCM42jrFW1skJZ6d1h5Q6ltazcs=
ARC-Authentication-Results: i=2;
	imf29.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=kLzfYvTp;
	spf=pass (imf29.hostedemail.com: domain of balbirs@nvidia.com designates 40.93.194.66 as permitted sender) smtp.mailfrom=balbirs@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=sMPcypSmUJ/sfy4YTNsiqoF7tEtelCcSefpYmcYDdSZ9AHOPVkvQtNmKf+gIMFEPye/RxDx0FHkqZQaFNmnUXOEjdKAEjfWVreevYnfd0kLutP86VvY9iTxZGeRQ6LeoJ0WYaQ26cXsAU4sRgWUexlRgusZHAhrFlRLzQUwhehKwaPE+1OkecWnvudOx4k2l6kBIQ+qnvWq6vonAw3ZsTnjV5Mu1XRb+08G8c7NLcJUvtHaGAJeUogJ6tfgArZyg9HTzopa8JPFYdOCG+EFPh0TkbqO5hW1zWz4zJkDQvsaBZL+nBqkeKqugzVZIzitE4YehL9TbHndNG/55wLxTTQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qiLh7vyAApWlZAt5SbIuDxqY+pzzbqOlArB6fWNJDTQ=;
 b=Qf0NxmfhKu+DtO08chEKvmzpSoPmGStMqSkBIG6smVt7OkAMleTtGRT/sTda6o+DnaIr+kIcGSO7+nUSrN4EVmVvzA7cm7rgoB9NCAvZWBL5OtrUBzuoTsHtCIJpL6vX0hA5ZY4P5LjX8stTjA0yE7mxAmG+lllEe1ZcWMelLMLfXSnTNyhS3Lwd5w2IRvk6c3OYwMgptgF4pJ9XVIJFTR/4Zg7VBg44htdd+CHAOsbqgJQ/r7umbuwNh/3GZPRyGIly1swGucl4j+4inKqZQ2tFQr977NAQnnGCgH7QkR6K7wLHPO4nOhqrcORtFJGp2vwZC9ZcfwJ7R6tgIJBx8w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qiLh7vyAApWlZAt5SbIuDxqY+pzzbqOlArB6fWNJDTQ=;
 b=kLzfYvTpt/5tsh7pUJJXWUUkUZwjneyM/p9ckBk5GRYLeXXpwAqmK2QFcr10S4odp6MXX9v/LcgWML1YOEDqDl5ICLWwMc0Y+xny9HaJ6OfAJKbASO/Yc+mkjFVfrYUel43G+YSst97WwM2H53Owm5otkpGhdt2cbwqp7D44+tUEAt3O3x69hfSOaEy+Luv2atvqjnqMCOhgoqbpbBXhLo1gve7/wg57ITf4fFi47ydCqAtVQ4DztSfBQStUPc4/SWngk0zkUI5Ykc8LL3g9O4YIgBCVtgOOHLcgavgJyONeOnIw2yf5I+cq4Z7GUaWXAicIfYCsdu4a7R+UDF6U+w==
Received: from CH3PR12MB9730.namprd12.prod.outlook.com (2603:10b6:610:253::9)
 by IA4PR12MB429550.namprd12.prod.outlook.com (2603:10b6:207:128::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.592.11; Fri, 6 Nov
 2026 10:34:46 +0000
Received: from CH3PR12MB9730.namprd12.prod.outlook.com
 ([fe80::843d:c1f0:b2ed:4128]) by CH3PR12MB9730.namprd12.prod.outlook.com
 ([fe80::843d:c1f0:b2ed:4128%4]) with mapi id 15.21.0592.010; Fri, 6 Nov 2026
 10:34:46 +0000
Date: Fri, 6 Nov 2026 21:34:41 +1100
From: Balbir Singh <balbirs@nvidia.com>
To: Li Zhe <lizhe.67@bytedance.com>
Cc: muchun.song@linux.dev, osalvador@suse.de, david@kernel.org,
	akpm@linux-foundation.org, rppt@kernel.org, apopple@nvidia.com,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] mm/mm_init: factor out
 memmap_init_page_from_template()
Message-ID: <au2tQaaMBg3umthq@parvat>
References: <20261105120615.16817-1-lizhe.67@bytedance.com>
 <20261105120615.16817-2-lizhe.67@bytedance.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261105120615.16817-2-lizhe.67@bytedance.com>
X-ClientProxiedBy: MEVP282CA0049.AUSP282.PROD.OUTLOOK.COM
 (2603:10c6:220:203::9) To CH3PR12MB9730.namprd12.prod.outlook.com
 (2603:10b6:610:253::9)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB9730:EE_|IA4PR12MB429550:EE_
X-MS-Office365-Filtering-Correlation-Id: 7658462e-f471-4851-eb35-08df3bf19385
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|376014|10070799003|23010399003|18002099003|22082099003|6133799003|10067099003|4143699003|11063799006|261026121527099003|261026135527099003|261102123227099003|261026130827099003|261028144727099003|261026140227099003|261022115727099003|261022113327099003|261021130227099003|261021123027099003|261021121427099003|261021133027099003|261021135927099003|261022105027099003|261022075727099003|56012099006|261009223027099003;
X-Microsoft-Antispam-Message-Info:
	wHXKjUgosXL+NgW8E/PvJsRmW+c0C2OqqgkR15bb1xrp6u2ytLRi2/n5eDKmSFJ12Tb1pahnCxiuKwpQFDfTlFLxEB6cH48AcxbXJAGYAhjVAY6k9o3qLbeIgVio/xXevkQFpV3iSd30zbW80/CchRNNRsE90cicB5wrxqJIdTmkL28rSSfvbP8SwZns6Yu378LVlQnqxpfkVd/VQoyBvJpws0Fd8Kmba1Ayk3+YOYjCNi+lVKTMpNtBPy19FxJprQj6gdagqrh/BQnY64LgIzgJSw4GNlEyC/E6GwjnaInBtOZi6ZWUCigPn0CtNNwnH3ezDML93gc0VcDMbHjgNcF2fvzqqlky1AwlZU4rtT3rja+U1giXXSbw6ZemFM2mJExXZLitgN1v8YWfd4s2MWxBWwW0+xCnRTvIlOW99M2x3qyFm95jsp1AhVATUj4YQLKTIlGTUzGtle9kMdw9t6KyO0x22tupvAtasDHr8BsZ9s9f3MSwckkrWu5UgSvD/SxhVo7s6Fy5q+8Mthy1Lk9uulqOiWkh7GnjXCWxP7ivpcICbj9xV3wFsh9PTy2zCRIV9Ver83H8pvS8uIgrbqzunFGVbbB+okPZImrGTwGy0T6UFpkEaNLbENv2vRxOVLJ2+wX2TmA5OY2BpASSMrGtjn0Ltl/cN1JDhJpFnIs=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB9730.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(10070799003)(23010399003)(18002099003)(22082099003)(6133799003)(10067099003)(4143699003)(11063799006)(261026121527099003)(261026135527099003)(261102123227099003)(261026130827099003)(261028144727099003)(261026140227099003)(261022115727099003)(261022113327099003)(261021130227099003)(261021123027099003)(261021121427099003)(261021133027099003)(261021135927099003)(261022105027099003)(261022075727099003)(56012099006)(261009223027099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?yan07RzzhW768jhkGQctbs/3yiXaSHVEmaW1YEjyrPitbY6XQdq1+mu/Aja1?=
 =?us-ascii?Q?AWcPLmFthZfILOpV00JffarYHiGgTUUjx+Zp5bQAF3K/DFkzMkSyuhIn2qOp?=
 =?us-ascii?Q?o28I6wO/fP/h/lwWJqbsGdOX0BIg6ywAsF7Sk+ESCI2Mg5jk1gKL+NtBIGu1?=
 =?us-ascii?Q?1tugjaFsuSqqOMU2TpfaCnqSTQbXIRo+EgvyAaNitxKsJFtfc/hm5rF1wbOq?=
 =?us-ascii?Q?PEWcYfPLV/JNC59gxFawENV23AV8uR4Zn1a8n0vtV1imnRw03el1F8sybyBu?=
 =?us-ascii?Q?4WvbVNPF18MBsooveroSMklgUjHd0sQSLgRXMojgiCm8USjykDsCQkk2cYrM?=
 =?us-ascii?Q?60qTTqDe+CvY93B5q4piHJpunU6PJMcjbMOdcweRazopP+Jxrq97XMGdMjj0?=
 =?us-ascii?Q?z522YrP1B5SINTD5eqNnJ2XSWidKLjDs6WnSFhgEzdMzOokPCGEnfHHBjgRW?=
 =?us-ascii?Q?DcvHUw18CqmiNAz8O39mrtOp95HrMA3rQIiEn9hqCGTo2inI9/6ajUJok0Iy?=
 =?us-ascii?Q?+vyEKd0m0sMiY7Y9DTBDFZ/egz8YxxvEbeoTbGiK1P98djtTc5+hXO+OXQRd?=
 =?us-ascii?Q?9WVPEAPi0Tv2ulF8PyjQPO9k3cD5j9nyTbhgHlYzXj0IGN7TjPQwerPuNYtE?=
 =?us-ascii?Q?jydotzAdhVMUQT/0na6Gff/EEkqxrwQLc/dt9n0qLQ/EeeBB9W9uBuHo7ITZ?=
 =?us-ascii?Q?sVOG7hdmit0oAt4IOzzXl2Ks2fi/kO1g4pqGP7LFIi1ZMasmCKplczrGAATO?=
 =?us-ascii?Q?LQCCDsUlRBztLG30smVrm8MfoYqGmlqzlGRfuaeRKuPJrPAq/JVJPF9mJRwO?=
 =?us-ascii?Q?dhgJOQ7whhk3lM4VxIikpgowF3wdaD2U4iRrMz67l0e3cm0RwyQ6RI+ZPs/g?=
 =?us-ascii?Q?0vXz8ymi19sPidAxZ3WONOXOWmTQjrzTuVItDUXDgxD2qsh01sA1I0i1dX36?=
 =?us-ascii?Q?1yR7DvQMD+CO3xZY2knFkF5Lo4DniBrW64mdfsavPNFi+M9Yeb2LMt0Eh8fN?=
 =?us-ascii?Q?uC1juDST323s1kPNoF2d8ifJVVzHHgPN6Cy2RX1cFugBiQPLVdAg0x6Hh/cG?=
 =?us-ascii?Q?bXiqlefR1lZag6L8YyNfS75gRZkPb4Mqy6J6Q11dRn9ars/DscpK2ekBB/SR?=
 =?us-ascii?Q?AWjejVQSEVh99T9oA7LbIDBbEQMjw767lp6E6zrVA0wgbiwvLZ/9T6x69i9B?=
 =?us-ascii?Q?U+QymGmeP+jWQPE8SgiJjWq9C9rMFHX6nLc1JbCrVVHpsIlnYDbAn/bxwUGU?=
 =?us-ascii?Q?lFuL3dctM0SJHeZfUTD3ilRGz78NvkoNKLt4jrfSgk4yoWLGDEJBDn++o9M+?=
 =?us-ascii?Q?VL5/KI0Y8bGeG9HqvMnbr131zMV/Ia2d71wLaeNbmGeek4eLNTST79EXo4W0?=
 =?us-ascii?Q?Hq6f5FQ1MVQCBFzbXlSDAe81NpneNGcIzInnhlY5F/8iU8Ao4vYbSiaAKEzB?=
 =?us-ascii?Q?x8Lyu4KUjQMlRMlVPyXUczwTcmfQ+ENmsNydx4apgbkxidqeG+XCxfoj284T?=
 =?us-ascii?Q?Gpj+djnjJj9fn37rfLoyi9qFJFlnoFm2LSzI237URc1fx/HBLHskuX0GLJzF?=
 =?us-ascii?Q?YY+NM2cUM+Not1SxcsA15FlIUuTZxki7zUUsJ0J/v4+m0yDDNDTv7kRmQCtA?=
 =?us-ascii?Q?Uuzck1YR0Q5c2FYl8gV5cYQlvUnxa2CXk6/gQh+HLCfCzzkCQZKXap8wX9ch?=
 =?us-ascii?Q?SZMDYJQ0ZTB6xlhyZzAkYSsX8uzIA5j6zYjCYAjEM0dfbp1Y9fDHCFhUmc4c?=
 =?us-ascii?Q?dRw1HrpvCpdW/hncxpzEMNXlxQuQei8EhZcsRgmB+qWk92HtXG6xTvb7R8AF?=
X-MS-Exchange-AntiSpam-MessageData-1: ttDGyItME1q2rg==
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7658462e-f471-4851-eb35-08df3bf19385
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB9730.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Nov 2026 10:34:45.9050
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1lAaDOPFErNitcr3KFWusauYfVvffFJqvNEru/ZeEPazwYTPVWLlQ+gg0yLQfVXy6jYQ4tDmWssgvfVcdleumQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA4PR12MB429550
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam09
X-Stat-Signature: sjw41srsmmdpsb6u4ic146ng4nrbeets
X-Rspamd-Queue-Id: 1EB01120005
X-Rspam-User: 
X-HE-Tag: 1793961289-211221
X-HE-Meta: U2FsdGVkX18NZZaDtWQmdIob4QdDz/vCDISvnbYF517Prn2ZnsZ+CeBzsSpr6EuYWnKb17RBYByLBUdJVTPv21AUvseLQiSEeuYLKHebLPLbUwlnt50Y5G0g/lfTnW5SmTk5f+58yI+scNMgumuY8idpuXJ1o9vAgqH1jt7cv13LmD8qfjel6PkdAnWa3183nXrXfzEGy8BdGNt/TJviof4xzksMR9wkvLGnsM+aX+wJBxaDlvFwId6LDBwprQgDmZGThQyjJSdqVKORS8UxYTdegjVoNW0eUylotEhsxNukmndRC3tmzvxqJYffLt68mm1batDwa3dD+ar4gTTwL29VE6DSxw65lsyLvQj5Mc5aQGnHbW6Pszkn67phExUlQkYn4FcNI8Yrj5CidJfF+raqaJ/4SpSPcjzmJp3LeCqFNOpnkixOb5/6o3acLPdmLdnigLuqMTzl8hKaooEpl+Zgxnb1rmaNxdwUnkEJMYLfShfKlrOkgCkXiGjfqiJo3dU5xfwN1yI2UJMhQxOqSKH6FzqvP2t1l2fSwwdNvjKT8qbthO17AADc9cRgJExVKrafNmiMPtc/scdj+5z504HUh1+INNdbrek5MXzoQyS1Hnllc8J8AnncqKIbWMq+B3RllDZVQLOIQMfx63QAccajNMQbGcw0zc6e29dyORiwgayjbdzgHbdq+74nMWufb7J4v0Yui2cz4m32Pc87Le0B6J3OnGX82rC/l46m1EY97tqBpt+kdz9orOJwhvUgZ/ipxx/Cgy09OVdn5NXSMDR0iXG52KtPcmdygYC92QAAUZ8SGrBitYnXu0zxBdWe72cND3AoWr8Kix2im3LEeQDM3dyofvX0ma/5eoHOcW/HY++98x7c+30YnjaHiBitgX2D8ULu5TO1tDoJAn+rsvSbMZMTxHDrdx1xJUCg4j1qMAYaXZLbiSepCQZl8WfbvbN8pVw3hVAkygqrG7s
 u+5X9pfj
 GE5TjcwOsvediChX1F/GlkrO0OivKD++cyHafA05QUefRBmvwisZEvWFFx5e9oeZYC3WOy7wbZ0Fm48m25EN31oHMt9JjRIgkNW3RyG8gLfaOezMTAUHidu71PT8XfKbVQyjqfrRuLnaJ4SaAFsfy0qIjIONjrMr7wn22oYP3XeTYbhdSpHhyNSc6tQCL77lvaKcJIOYkOhbHwcK+AmLmFl4woDvLbGGuNHbGKCNkHmHJiMgSfK9BQJvJcxwmGRhe+xMGur2lPPsNQDY6nwk7VZNcuh588yAI27z5FQWsmZZ8tdpFj4QPSVopBOuZ/4urqmvDKSocgbOPzyroncavmnBAWlsqJwgsLW+KR924wL36PI2F7AKO0SbwrzqzlfqNqbBBai1f1Cism6hINyFKSrOnuQEdi/eVPu3eWvg1l3qt3kYOzDWJbvL8ufsFtJ/x4Fo4xNLyk+s4tBV0pirmYZeX5jkOk6QhGYiX
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, Nov 05, 2026 at 08:06:14PM +0800, Li Zhe wrote:
> ZONE_DEVICE memmap initialization already uses a reusable struct page
> template when initializing compound tail pages.  The template mostly
> contains invariant state, but a few fields still depend on the target
> PFN and must be refreshed before copying the template into each
> destination struct page.
> 
> Factor that operation into memmap_init_page_from_template() so other
> boot-time memmap initialization paths can reuse the same helper.
> 
> No functional change intended.
> 
> Signed-off-by: Li Zhe <lizhe.67@bytedance.com>
> ---
>  mm/mm_init.c | 29 +++++++++++++++--------------
>  mm/mm_init.h |  2 ++
>  2 files changed, 17 insertions(+), 14 deletions(-)
> 
> diff --git a/mm/mm_init.c b/mm/mm_init.c
> index 2a0e782a151d..495e20fbdec0 100644
> --- a/mm/mm_init.c
> +++ b/mm/mm_init.c
> @@ -625,6 +625,17 @@ void __meminit __init_single_page(struct page *page, unsigned long pfn,
>  	vmemmap_optimization_verify_zone(page);
>  }
>  
> +void __meminit memmap_init_page_from_template(struct page *page,
> +		unsigned long pfn, unsigned long zone, struct page *template)
> +{
> +	set_page_section_from_pfn(template, pfn);
> +#ifdef WANT_PAGE_VIRTUAL
> +	if (!is_highmem_idx(zone))
> +		set_page_address(template, __va(pfn << PAGE_SHIFT));
> +#endif
> +	memcpy_nontemporal(page, template, sizeof(*page));
> +}
> +

Can we make the template a const? Why can't we do

void __meminit memmap_init_page_from_template(struct page *page,
		unsigned long pfn, unsigned long zone,
		const struct page *template)
{
	memcpy_nontemporal(page, template, sizeof(*page));

	set_page_section_from_pfn(page, pfn);
#ifdef WANT_PAGE_VIRTUAL
	if (!is_highmem_idx(zone))
		set_page_address(page, __va(pfn << PAGE_SHIFT));
#endif

That way we don't update template once it is set, if template is r/o,
then we don't need both first page and template in the caller to
be different.


>  #ifdef CONFIG_NUMA
>  /*
>   * During memory init memblocks map pfns to nids. The search is expensive and
> @@ -1073,17 +1084,6 @@ static void __ref __init_zone_device_page(struct page *page, unsigned long pfn,
>  	}
>  }
>  
> -static void zone_device_page_init_from_template(struct page *page,
> -		unsigned long pfn, struct page *template)
> -{
> -	set_page_section_from_pfn(template, pfn);
> -#ifdef WANT_PAGE_VIRTUAL
> -	if (!is_highmem_idx(ZONE_DEVICE))
> -		set_page_address(template, __va(pfn << PAGE_SHIFT));
> -#endif
> -	memcpy_nontemporal(page, template, sizeof(*page));
> -}
> -
>  /*
>   * With compound page geometry and when struct pages are stored in ram most
>   * tail pages are reused. Consequently, the amount of unique struct pages to
> @@ -1136,8 +1136,8 @@ static void __ref memmap_init_compound(struct page *head,
>  
>  	/* Initialize the remaining tail pages from template. */
>  	for (pfn = head_pfn + 2; pfn < end_pfn; pfn++)
> -		zone_device_page_init_from_template(pfn_to_page(pfn), pfn,
> -						    &template);
> +		memmap_init_page_from_template(pfn_to_page(pfn), pfn,
> +					       ZONE_DEVICE, &template);
>  	prep_compound_head(head, order);
>  }
>  
> @@ -1192,7 +1192,8 @@ void __ref memmap_init_zone_device(struct zone *zone,
>  	for (; pfn < end_pfn; pfn += pfns_per_compound) {
>  		page = pfn_to_page(pfn);
>  
> -		zone_device_page_init_from_template(page, pfn, &template);
> +		memmap_init_page_from_template(page, pfn, ZONE_DEVICE,
> +					       &template);
>  
>  		if (IS_ALIGNED(pfn, PAGES_PER_SECTION))
>  			cond_resched();
> diff --git a/mm/mm_init.h b/mm/mm_init.h
> index 0034e37dbabd..22c465122b47 100644
> --- a/mm/mm_init.h
> +++ b/mm/mm_init.h
> @@ -111,5 +111,7 @@ void memblock_free_all(void);
>  
>  void __meminit __init_single_page(struct page *page, unsigned long pfn,
>  				unsigned long zone, int nid);
> +void __meminit memmap_init_page_from_template(struct page *page,
> +		unsigned long pfn, unsigned long zone, struct page *template);
>  
>  #endif /* __MM_MM_INIT_H */
> -- 


Balbir

