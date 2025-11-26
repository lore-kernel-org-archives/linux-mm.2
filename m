Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7A29DD111A5
	for <linux-mm@archiver.kernel.org>; Wed, 26 Nov 2025 21:07:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CC01F6B0024; Wed, 26 Nov 2025 16:07:58 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C97926B0026; Wed, 26 Nov 2025 16:07:58 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B865E6B0027; Wed, 26 Nov 2025 16:07:58 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A30816B0024
	for <linux-mm@kvack.org>; Wed, 26 Nov 2025 16:07:58 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 4389D5AB44
	for <linux-mm@kvack.org>; Wed, 26 Nov 2025 21:07:58 +0000 (UTC)
X-FDA: 84153995436.15.CFF2C52
Received: from BYAPR05CU005.outbound.protection.outlook.com (mail-westusazon11010035.outbound.protection.outlook.com [52.101.85.35])
	by imf10.hostedemail.com (Postfix) with ESMTP id 55D42C0012
	for <linux-mm@kvack.org>; Wed, 26 Nov 2025 21:07:55 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=OaSsk1fk;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf10.hostedemail.com: domain of ziy@nvidia.com designates 52.101.85.35 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764191275;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8h2NgxY1el4+lE+4MkN8n9+67HkJr49mkXL3VGCCMPw=;
	b=loIkMuigbR/Pzb3NmgP7Wh/AcDHwxMIn0CImW5u8BWBRWt7g2XL11hsz1x56ZuvEU02E5L
	Wh5hc9ZeOSVjY8AMUntFO3m8ShuHzRvqew9ljtYNJjPH3dRGIvVscNvKYJVH4KH2jbBtgf
	5z30gldGbaRkxzHDClr30ZUraMZvq0k=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1764191275; a=rsa-sha256;
	cv=pass;
	b=OjfBFFUnKN8vvhAXStCJz7k85D9fqaLCfY1GMqQ+HESeZjZzDmx61/CjZVueRurIZxXk2y
	e5YNLVnZM5mNVxjmer029ySYvYGKoH91hEIbSMBEshjc4yF4fit3lc34O2lvh5wiZgwNYm
	x6JAmB/9PpHQ4wg9WDW47x+fhlfbRB4=
ARC-Authentication-Results: i=2;
	imf10.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=OaSsk1fk;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf10.hostedemail.com: domain of ziy@nvidia.com designates 52.101.85.35 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=fzkCknsXRtEH3gbWBleWwafq31J9PFGD9VerULZj8z77ygu2k1h0NClhZk4pLsznmP3mm1mqgI+IZGEmhXm2ImumoEX3ROGRVuGxw4300TuFaTUpzbuiK00FDpGiwXKUAYqNYI8n270dLReUkWeskiGyCwzmGdWG9I8D0YgbdrcEsJlyrv/joieTLa5LwEbUhqN6m+TU4/KD/S3G/0FzKN19w2caBMWm3J/I+SfZUeyCfJVevLI7W58QdwpYriIwvTNANLHEnij8hCNa+lDC1skrBMBgMvAGhjHIKdaAAcV+jGQTAk7NR1vbGxK+Idr/auU2G2Ddpdd5As+qI07LqA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8h2NgxY1el4+lE+4MkN8n9+67HkJr49mkXL3VGCCMPw=;
 b=ogdOFvdKalW3k5EP07bkPZiQCfLwOaHFPxJ7IpHbHqGY977wejQip5ON634+kcdRgyQXZ+cM+P2UjTayR1V4Fhq3I64m9lIcl7prcYhm2wxOum5AiWL690xBm0a2A8dwXJdeqO0/5k3AbmB42SR3OOHs3hg79V/exTNrv/9HNwwldWkpHcTpuwpk6Iufj96aDluBqqcf7DbVArsZVt3GI8KM8zZ5pNFtRsEMayC1vLMCGt8KWAHNNiMnJHgOrLG+R2IXR3fi0gZvgsgVqEP45G285E+RkYMq1NVjhTwI8M3XC5W+ljxDyzc9flPQiswWd0Z9SG+uJDmRMCNY2JmsMw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8h2NgxY1el4+lE+4MkN8n9+67HkJr49mkXL3VGCCMPw=;
 b=OaSsk1fkTuMn8YIbLWy85aZmxttUiYzJUUCig2X3YZ1ndFQzGfCQg75DMq9U0ltWUL4u7L+hDlr+8Au5SJ6ZvP5nUNk9EKT2uVS3vstGaaawGs+uFbPWvvKUQ2RJXfW2N21VOf35HFHZFm6Jl3VMFdeotST4boMmxudAqb9yWTJqGbHe72xAH+pFbMqdiv4adrsp4j+m9CXroyOFGltvxb4NUkqgkYqn87EZoF/1I2XLhf6bGx6BnegNRAvnHuAHmKhDhnYnj17lXWmCIqSmzYhKce566Nuj5ASaTkwggewV/yR0K7LH1mTSrNl4mBKNAPbYXMatVMYt+Ve6dvHsng==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 PH0PR12MB7010.namprd12.prod.outlook.com (2603:10b6:510:21c::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9343.17; Wed, 26 Nov
 2025 21:06:25 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a%5]) with mapi id 15.20.9366.012; Wed, 26 Nov 2025
 21:06:24 +0000
From: Zi Yan <ziy@nvidia.com>
To: David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Nico Pache <npache@redhat.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	Miaohe Lin <linmiaohe@huawei.com>,
	Naoya Horiguchi <nao.horiguchi@gmail.com>,
	Wei Yang <richard.weiyang@gmail.com>,
	Balbir Singh <balbirs@nvidia.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v4 1/4] mm/huge_memory: change folio_split_supported() to folio_check_splittable()
Date: Wed, 26 Nov 2025 16:06:15 -0500
Message-ID: <20251126210618.1971206-2-ziy@nvidia.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251126210618.1971206-1-ziy@nvidia.com>
References: <20251126210618.1971206-1-ziy@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN2PR07CA0001.namprd07.prod.outlook.com
 (2603:10b6:208:1a0::11) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|PH0PR12MB7010:EE_
X-MS-Office365-Filtering-Correlation-Id: 9b149225-359e-4a96-23cc-08de2d2fa889
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|7416014|366016|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?9E/mU5eVGKRNzolBO7Gt3fEcbN9ybYfjSt/19OmK2hnd6A1d8Nkl8OmlE6GC?=
 =?us-ascii?Q?1mMZxKlIMvEMyS2Vw8U1OrZXMwr3KuPrbr5HPnS0Q+CFqX9ydv0BnnEhSsFZ?=
 =?us-ascii?Q?GSivhsPQkJ+716rjEg3AHFFmoxFyY4UQZwTSZsEn0/awGAW+2A8Go+SfrfNO?=
 =?us-ascii?Q?v4IIpDqZHH0Er1vJwBd0i/myZNCaOUjMZouCU2o0UGbmZI02PX46lXy9rBDW?=
 =?us-ascii?Q?ZtTeOgVSJrUSHcoV+aZCjM0CEB65zgJTSLhrFy2QUNvMHKQb88jvN1mddGA1?=
 =?us-ascii?Q?SWffPGCTMbb9/mDgZti1FSATzaNVS0xSgsFXhg3poWNU7mE4F3xxnzoIuIQg?=
 =?us-ascii?Q?JVlG/COI/KzBYfOM8Q4zxCUiapgQKrhi8UDx1FOe4fjktlL3iUFG4XxfhuSE?=
 =?us-ascii?Q?mPp1rKnHrkWU/LivabBT3z03bKUA/uCe0qMC7Zz7b/OmAoEIZcJmxgTvDvdp?=
 =?us-ascii?Q?CyvAV3JkoFuuFiB2l/eV3wDuOF7Ba146kpOnlXKTvmcHu9L8tf5OI2HaPIDd?=
 =?us-ascii?Q?hc40KhA+/6f1REGot8jIkRckbh8PmPYqAk/mGxGdX1dAMQyMIe+CZopSVMa5?=
 =?us-ascii?Q?OZne8aqeAXa3wP/UVzi5RyBy9cB9KBYiQNChxP7v3a2eieYKEl4Qu1kgvReN?=
 =?us-ascii?Q?KUZFXveORH16x1TwbKw4ScDLcV+DHVTeyb/agS8WaOz/38JA9W3Vpmh7Y3wG?=
 =?us-ascii?Q?HTI/n2DnmxDSL9blp+qzhaBFSzdEp1G2mF4O2C+Kj+fvx9SzcD93cQNqhUfb?=
 =?us-ascii?Q?7Wpi+TEUXqnA7V0AZAC3fJU9cHMr+1B/64ABgEJydBg8V93cRvKp8q0tQ3sM?=
 =?us-ascii?Q?mPTZzdD04o/dK2bUr+TdWwm3hyeoFNgPMssw7dkPDr4q0kYrzSHhgeB2u4vn?=
 =?us-ascii?Q?zkHpnkrZAUCFR+WRZFgaHXWk+4G+I7VXG75D8BJ59NIkSM+L6okYdtdSq4l8?=
 =?us-ascii?Q?U3/acdkbc5SM/uplojlwU2an7l/ClH2kJDhoo+tdTh4E0/W7DIFDrDba7Xzl?=
 =?us-ascii?Q?CGk2gskuSRXge9QH7yNS1ctkDuQGnN+XyHNnDSS2TBCjls1G8cAQ+yPO42q1?=
 =?us-ascii?Q?qe+ujvwS0fHFJlWL2Sl4mLHC7biHarTOdi73ehQ4N+7vlvj9zZ5rGxrrOG01?=
 =?us-ascii?Q?PbAd+gTCWfd6zewVNz4eQWWlQKEZIaszNfasEo7gPXWX6Qiin+Y0EKWH6VFy?=
 =?us-ascii?Q?nliOP2dhaevVGWzTweCgwnEiHj7JgGd2Ol2I1LXTElZu0/fcvdDCkgkUJbfX?=
 =?us-ascii?Q?Shx0E85mjYr4uUGjk9mORarpnhABI1gKzBbCzPYOQdX/RP+tAOIwY3uCuVyB?=
 =?us-ascii?Q?CLs6ZRcLw+WFY2/1gZe15oJ9xNSs+gG/0BcPhvVNIthF9A6dsPW4mcogZAfB?=
 =?us-ascii?Q?zbCvvIcSxPtDz95am77AEr+LfWYrayXGDFMCDy7pzVN20b+BCGOYOtT+Kkl5?=
 =?us-ascii?Q?vrXS5GEue18ExSEX6LE3wwZxcqmqSMMZ?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?PQyHv4jfcEfGmU6ImzjrgnE2/43bKkaVBlgXOc9+yAE/k1nsaGrtMABRgAQN?=
 =?us-ascii?Q?eyBpdnbUiIoDKutp8jsVOZDJaG9BmXF8qgroKS6rlJrkmWAYhlo4SHn0fzFz?=
 =?us-ascii?Q?vM65nqLHUlu4PI3QlOFGJ6LKXp0udUFzDAqVV1Z/V3Aqdfn6hsc++jOZuubS?=
 =?us-ascii?Q?ftefZu5y6TN9ku6jmYSIueo+wHDJv6C3ckAkdtwn+EjYdZ/1ecLPbW5Crnhr?=
 =?us-ascii?Q?rA4XaCyKoHgDTClkJyI5XMlTXRWcb4fEwP/gRQTg1xApBNH/CGCrWABVj9Rl?=
 =?us-ascii?Q?ItD8srPsOlgI2XlxVGUs4E1FU10Gdok9LUSzhSRSv63wol6XhMyJsrUb6Vi5?=
 =?us-ascii?Q?3V7V7vfyWPwm18SD44OtgXWDzArr8dbDhaAmoasJ54WZU0sVJp1l+l+If6CT?=
 =?us-ascii?Q?oGdzSYuxUZko8rKNIMxX0dKOr4AIZldznCU1PctHQNEPHafVs8RvVak6Kw7p?=
 =?us-ascii?Q?A4WLTNlVr/wvLbTgQie6UZH73bAPQnx+GNVFKJVM7QK74siRx10/saa3lgy4?=
 =?us-ascii?Q?Jm4Tukuu7p/gchwm1PKkMuuTknH11qYYYtrJo9lcjJ2nPdmCj4UWr757/oh0?=
 =?us-ascii?Q?2M3UQYJwS9w4xb8ZfTlg6TaM37mGlqjRR1etBpw2U4VD8zNkJIws5ijQnrd+?=
 =?us-ascii?Q?pbImlgtfH7cDlcbIG7LI6bwYOCpay8Lgibwmgesxl2h7tAk+B96YafS8wu07?=
 =?us-ascii?Q?ZNWZS1JTFyYwDUULRS3TPUyuypTupiwDMTjfaHPPTmwvAlMjpx3D9bOgn0a3?=
 =?us-ascii?Q?LXRE4II1ZuHPDQmJDVFYVi9LfqYKmGDQ6EMSiUPszICmkgJ3lNP5WlviYYFS?=
 =?us-ascii?Q?WU1kh6HBO/QPX+SfXjbAJvWPEMldWlEq3AUWnTKCgzQIuDxuZc5xu4gWFN7r?=
 =?us-ascii?Q?FpmyN3j5z74BlqqfV1Ku4zG8BO2KIWQMA0HlJwcXMHkp+oTybOrhOZqI1Ecn?=
 =?us-ascii?Q?21T28LHKgCvlnFdWW5gul/pVgtfmEzWJ8N9oS0QgCGDwSP80Abx0gT8vHRCt?=
 =?us-ascii?Q?+OZTp1+utKk7j/KP2t1biq3mDgnEcJL9+LZh4Rr8lXJPdajPt3yuo8h5lW57?=
 =?us-ascii?Q?gdKVQQxJN9XrYy7XYFPULjezBxXpM9mrruEltv47HkYhzOmm6COnmy7tzJIh?=
 =?us-ascii?Q?f3rQEiPSlmB01HvhNWCVUZVMfSsmyuT3qJYBlcnyHrYhdiqWoi240KkHFf3s?=
 =?us-ascii?Q?qgIs8YU5X0W7Glkyab6vSPhpKkW3MDopxrT8u1xPIECND1MPWYF6HndAO7va?=
 =?us-ascii?Q?r5BWJGkFCcaKCI6UJfT+WlPNvHoGym0f/93nbZCM8FGiwtrDJZbzJWF2Z7kV?=
 =?us-ascii?Q?k+iOPO7ugjSQonhFQ1Te84HUX/06TvLuyuQLYtqfR2TrOpR2ah3oM6UqKnGY?=
 =?us-ascii?Q?3AAjH4zOSBapxpu7h5Z8V1QZNIx7Zu575v5H0rBgyp8SqcfLC/LdF+pg9RjA?=
 =?us-ascii?Q?XjT8Q9fFYo1JlmkYCXMY3PafCPtxDP5AU9ZayPvzUAliXvte4cj0QEupa5Cg?=
 =?us-ascii?Q?eq9IZTe4unsKYuks3A0hUXcPzaVp+dHVMqDZIr8hvX2qfQj0fHITbQyBftia?=
 =?us-ascii?Q?G6jYhtJRbGIoYrY1W3VLIe5SykMWNKIX0V/anJSs?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9b149225-359e-4a96-23cc-08de2d2fa889
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Nov 2025 21:06:24.8507
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kyZDslfb7c5IamqOCdjjWo/i4a8OvyI2S0pe1KG7BCHthAjvE7l3IfY1SMDstQ+8
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB7010
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 55D42C0012
X-Stat-Signature: nym5wtsuk9j8zkprqg47ocg9x49dozii
X-HE-Tag: 1764191275-962554
X-HE-Meta: U2FsdGVkX182TBm3RQ01iigAQ7g2dT0xKAKG2xuYr51CDJgTd4WgeDS71L2UnenEsLmLeydlPSVVfwygdtTv+Z94tFB+LVy0en0NP7IamC20hJWdpDscZtQdjrEa21BHfRM6+1cgI0yfQsYibIYHZx35qScNItfKUR+a/DdZ3v7Oq0vNI6RkOjqrXn2KraEc8bW4Q647omlsdPhB+nK7uNkC48MP2fctaxfqs/Ff1nsXsNrOeIoGhRremojQJkVVufvay4b7AP9OZnwd1ZElyA0VeDQB/oDhKDovjqzWXuLEo/rhzA2SWcgIE3yI27jGQfKrOwvihvWTRAPZPihkYEhUmIBgtRWXIU+iTcwFj4XpWhr8fMDGigs3wbXRZ3R4qi5csP2dHjr4M+kmyc9HKs0BqAOq45dSPNMnCjGhvFxSGfZpp2Zhw9TOnV5QvWgpFoCmtFgoZZhEijDaKF142QcLH8kdK8kA1sJrtVJ+780onDrFrsSZ2qeI+jrfUwo+mMb8+OGGsgHs4tFKwcOPrwqOZ799AOiExPL9P+KoYoMw+9hnuCzEu9XARDavxdN2s1ldxy19Nxsl1FFtKcq65ponlSV+gP6Fr4/eh402cvEz67RWH1FXNQP3WibgJBXAMzJLF2GGbG61/jQZlxQ8/sSxmxD0Ji5dwtTC50kpITn8AJb37JH83p4VpRr0C78ixxGdNNk2YNztAOmozMyUwvD3g/i9KU06qurBg6rOwfBtvPci6fPRfvKjzvZayLqfV6wbY7RlefdU8lJ6sgMAjFQxq3IM18TY4zxBL1gGbEfv+dRa9gSADLkj1QS/TwnbK+DQ730RuYA4Uc6W2zL2luEzpDOBFtBuaHCfyrTHfqRnk/PO3HRGROFKE8zU1ZW6wxdpHEFrDDwNkF7VnR6E/LbS8LwQZgzaOqkgHQawn8wE1LWSdEXlqG3NNi1DJrNAVQ+lcXY9MNJZJcdXmbD
 7Xz3kxQd
 NneXkiWd5DTk7zFDHcMl7ao9Enii5Rf2kdkoRkzIGMS94MKEGpvsRJ/u+EEqMdkbkugTixRRm/fVQiiMO1dxk21KOPxvlAP4nuBaAOXB14T1g33KKoE7yRevs4HTMrOCN301dvwJgjVo4xbM/6kURq1L9bRtZIdxrlWZF+lQsMtZfJTtKyaOkeHQRIQNRROt4rB06l2mfRR8l0RgA58krnPGGeB3/3qvV3158o9cyo9GauE55mrfqWMWXaUU7qG2x8929W4sEuV0Xwh+/jyhuug+9lAch53+cVC3R0UE1mCnta3UVK9EdjwvmEkegtRxlpxIJ2w6BfE+Cb8hcfRZi/OQOj0godlZ2g7Z5swtXIXIwpwVvU8D0t5COFc24p9W901qox2CZyqKbSPi7ChR0AgjIEFQ747lmxFNErk6VTHhMNFXVGp545p2wTMOeNkzFr86LFPd5f772uSdXXbbDrQpTT4R5YHU2plMGv3ZUyUdV1zUx8XwpdqRbzvU7EgPWFF7625I7jVVXbWigMdvuhAG7OLnrS24kI+VvcCyPpBkaCeM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

folio_split_supported() used in try_folio_split_to_order() requires
folio->mapping to be non NULL, but current try_folio_split_to_order() does
not check it. There is no issue in the current code, since
try_folio_split_to_order() is only used in truncate_inode_partial_folio(),
where folio->mapping is not NULL.

To prevent future misuse, move folio->mapping NULL check (i.e., folio is
truncated) into folio_split_supported(). Since folio->mapping NULL check
returns -EBUSY and folio_split_supported() == false means -EINVAL, change
folio_split_supported() return type from bool to int and return error
numbers accordingly. Rename folio_split_supported() to
folio_check_splittable() to match the return type change.

While at it, move is_huge_zero_folio() check and folio_test_writeback()
check into folio_check_splittable() and add kernel-doc.

Remove all warnings inside folio_check_splittable() and give warnings
in __folio_split() instead, so that bool warns parameter can be removed.

Signed-off-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Wei Yang <richard.weiyang@gmail.com>
Acked-by: Balbir Singh <balbirs@nvidia.com>
Acked-by: David Hildenbrand (Red Hat) <david@kernel.org>
---
 include/linux/huge_mm.h |  6 ++--
 mm/huge_memory.c        | 76 +++++++++++++++++++++++------------------
 2 files changed, 46 insertions(+), 36 deletions(-)

diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
index 1d439de1ca2c..66105a90b4c3 100644
--- a/include/linux/huge_mm.h
+++ b/include/linux/huge_mm.h
@@ -375,8 +375,8 @@ int __split_huge_page_to_list_to_order(struct page *page, struct list_head *list
 int folio_split_unmapped(struct folio *folio, unsigned int new_order);
 int min_order_for_split(struct folio *folio);
 int split_folio_to_list(struct folio *folio, struct list_head *list);
-bool folio_split_supported(struct folio *folio, unsigned int new_order,
-		enum split_type split_type, bool warns);
+int folio_check_splittable(struct folio *folio, unsigned int new_order,
+			   enum split_type split_type);
 int folio_split(struct folio *folio, unsigned int new_order, struct page *page,
 		struct list_head *list);
 
@@ -407,7 +407,7 @@ static inline int split_huge_page_to_order(struct page *page, unsigned int new_o
 static inline int try_folio_split_to_order(struct folio *folio,
 		struct page *page, unsigned int new_order)
 {
-	if (!folio_split_supported(folio, new_order, SPLIT_TYPE_NON_UNIFORM, /* warns= */ false))
+	if (folio_check_splittable(folio, new_order, SPLIT_TYPE_NON_UNIFORM))
 		return split_huge_page_to_order(&folio->page, new_order);
 	return folio_split(folio, new_order, page, NULL);
 }
diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 041b554c7115..8c2516ac9ce7 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -3688,15 +3688,40 @@ static int __split_unmapped_folio(struct folio *folio, int new_order,
 	return 0;
 }
 
-bool folio_split_supported(struct folio *folio, unsigned int new_order,
-		enum split_type split_type, bool warns)
+/**
+ * folio_check_splittable() - check if a folio can be split to a given order
+ * @folio: folio to be split
+ * @new_order: the smallest order of the after split folios (since buddy
+ *             allocator like split generates folios with orders from @folio's
+ *             order - 1 to new_order).
+ * @split_type: uniform or non-uniform split
+ *
+ * folio_check_splittable() checks if @folio can be split to @new_order using
+ * @split_type method. The truncated folio check must come first.
+ *
+ * Context: folio must be locked.
+ *
+ * Return: 0 - @folio can be split to @new_order, otherwise an error number is
+ * returned.
+ */
+int folio_check_splittable(struct folio *folio, unsigned int new_order,
+			   enum split_type split_type)
 {
+	VM_WARN_ON_FOLIO(!folio_test_locked(folio), folio);
+	/*
+	 * Folios that just got truncated cannot get split. Signal to the
+	 * caller that there was a race.
+	 *
+	 * TODO: this will also currently refuse folios without a mapping in the
+	 * swapcache (shmem or to-be-anon folios).
+	 */
+	if (!folio->mapping && !folio_test_anon(folio))
+		return -EBUSY;
+
 	if (folio_test_anon(folio)) {
 		/* order-1 is not supported for anonymous THP. */
-		VM_WARN_ONCE(warns && new_order == 1,
-				"Cannot split to order-1 folio");
 		if (new_order == 1)
-			return false;
+			return -EINVAL;
 	} else if (split_type == SPLIT_TYPE_NON_UNIFORM || new_order) {
 		if (IS_ENABLED(CONFIG_READ_ONLY_THP_FOR_FS) &&
 		    !mapping_large_folio_support(folio->mapping)) {
@@ -3717,9 +3742,7 @@ bool folio_split_supported(struct folio *folio, unsigned int new_order,
 			 * case, the mapping does not actually support large
 			 * folios properly.
 			 */
-			VM_WARN_ONCE(warns,
-				"Cannot split file folio to non-0 order");
-			return false;
+			return -EINVAL;
 		}
 	}
 
@@ -3732,12 +3755,16 @@ bool folio_split_supported(struct folio *folio, unsigned int new_order,
 	 * here.
 	 */
 	if ((split_type == SPLIT_TYPE_NON_UNIFORM || new_order) && folio_test_swapcache(folio)) {
-		VM_WARN_ONCE(warns,
-			"Cannot split swapcache folio to non-0 order");
-		return false;
+		return -EINVAL;
 	}
 
-	return true;
+	if (is_huge_zero_folio(folio))
+		return -EINVAL;
+
+	if (folio_test_writeback(folio))
+		return -EBUSY;
+
+	return 0;
 }
 
 static int __folio_freeze_and_split_unmapped(struct folio *folio, unsigned int new_order,
@@ -3922,7 +3949,6 @@ static int __folio_split(struct folio *folio, unsigned int new_order,
 	int remap_flags = 0;
 	int extra_pins, ret;
 	pgoff_t end = 0;
-	bool is_hzp;
 
 	VM_WARN_ON_ONCE_FOLIO(!folio_test_locked(folio), folio);
 	VM_WARN_ON_ONCE_FOLIO(!folio_test_large(folio), folio);
@@ -3930,31 +3956,15 @@ static int __folio_split(struct folio *folio, unsigned int new_order,
 	if (folio != page_folio(split_at) || folio != page_folio(lock_at))
 		return -EINVAL;
 
-	/*
-	 * Folios that just got truncated cannot get split. Signal to the
-	 * caller that there was a race.
-	 *
-	 * TODO: this will also currently refuse shmem folios that are in the
-	 * swapcache.
-	 */
-	if (!is_anon && !folio->mapping)
-		return -EBUSY;
-
 	if (new_order >= old_order)
 		return -EINVAL;
 
-	if (!folio_split_supported(folio, new_order, split_type, /* warn = */ true))
-		return -EINVAL;
-
-	is_hzp = is_huge_zero_folio(folio);
-	if (is_hzp) {
-		pr_warn_ratelimited("Called split_huge_page for huge zero page\n");
-		return -EBUSY;
+	ret = folio_check_splittable(folio, new_order, split_type);
+	if (ret) {
+		VM_WARN_ONCE(ret == -EINVAL, "Tried to split an unsplittable folio");
+		return ret;
 	}
 
-	if (folio_test_writeback(folio))
-		return -EBUSY;
-
 	if (is_anon) {
 		/*
 		 * The caller does not necessarily hold an mmap_lock that would
-- 
2.51.0


