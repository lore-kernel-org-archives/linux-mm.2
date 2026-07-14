Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 235EAC43458
	for <linux-mm@archiver.kernel.org>; Tue, 14 Jul 2026 13:10:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2DE076B009D; Tue, 14 Jul 2026 09:10:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2B4516B00A6; Tue, 14 Jul 2026 09:10:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1A4206B00A9; Tue, 14 Jul 2026 09:10:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id DF8EE6B009D
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 09:10:38 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 08901802FF
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 13:10:38 +0000 (UTC)
X-FDA: 84987416556.16.B2BCED0
Received: from BL2PR02CU003.outbound.protection.outlook.com (mail-eastusazon11011020.outbound.protection.outlook.com [52.101.52.20])
	by imf09.hostedemail.com (Postfix) with ESMTP id 1E88214000F
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 13:10:35 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=itHCJeQg;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf09.hostedemail.com: domain of ynorov@nvidia.com designates 52.101.52.20 as permitted sender) smtp.mailfrom=ynorov@nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784034635;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=47JETSfzH+9Qq13yeulDnYn8gIFhTM2mDI0j/LVolSc=;
	b=xJjkyUYlPD9qrYQDCJqCnndFshdtBdbx/SWwV2g4nFL6HZ0zj9158E47Wht9YmpWIO7fgp
	YVQkfNlH1wqtBJ+HZNIakC4w3S9CJiunviEG7THwVzmj9xWYTpWGzkcxpf33CUaBHQvKvG
	eWQK0AOSDndFDWXSdWGfZXeQkSxOupg=
ARC-Authentication-Results: i=2;
	imf09.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=itHCJeQg;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf09.hostedemail.com: domain of ynorov@nvidia.com designates 52.101.52.20 as permitted sender) smtp.mailfrom=ynorov@nvidia.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1784034635;
	b=rNNoXnqEgcLJns05Dznwv6ZDH0eDbzitzuv4rEJNaUhjR3jdvju+Y2SHbueQgsKbUrfZyd
	oOoRNTx49rqX53e28Y22I7n7SA/qrZ433Qh3GbwbiS+3lkWCAHWIdorlSm6d5eotqFRA2V
	wmv6HGrg1t0HkBh/vZwKV6S6hCyj5Z4=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=DkxMiFRs246o15wZ8Eqjo6Dllhc9YXAbKM1yOE6I4t52Xft9c9/TpLRtK3bYPkCnJ7SzPg6lNBWp8DqV4nOm0udqNlqhzOeYq6Sysi90IlIKaizdtq8CUvLa/onZDKVJik1a5EH0xZcO5fnBREI5t64S3diacgjmSpqZE5RBflFH1HhbL7ReZYrvPynKVOHtapA4gx1x/zDty63+g8fJtsMXCshgUeqKAn4dk/Ra2NDyxltNWS4aFXFoEURVMUIWw+zsvI69UotI4SooFkTb3XinB4TNeLAprzfDdOSd1MvRuBm4Kos06BJG2rKYg3X7gnqivFKhldZ3f8nOTQW4vA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=47JETSfzH+9Qq13yeulDnYn8gIFhTM2mDI0j/LVolSc=;
 b=G7L28fYqHRZ/RgpUM9G38d2dQSj7ZYYE+JXC8YRuNbaUqdnb9foeMXlNvxhyt/vtko87CPNrQxm+LFKfXX0dSBkdkY5bT+W1c3VQlNYszZMYQ4XjMyNBqR0UwAVgnuXYuv2sjLeHi24Q+59O46D+rzumxHjKK4abnRrR8FU/XIxTzc3/xMzMPO/uX7/C7W+hjw9B8CjM5rMhNyEITHw69p5WySXxoatJwWUxOn4iirr2xLf1pXIuS24VQqTXGooddq+UBCryeZlRkWjuwTrnfzy3WXUqDpdkyA+pBu9zr0t1IkfME8IEY2XXA2eAgO0uecAEY0sGVBos33oJUlP7/A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=47JETSfzH+9Qq13yeulDnYn8gIFhTM2mDI0j/LVolSc=;
 b=itHCJeQgRcIybnYuUMMvl6NAsB+4sMFgjSP2gEoATD1DpnwpY60qccO0LZr2Lh8oG4OJe1IT7hdygbTalgjyKAqydBWf0iK9LEIWREV5RbqRVMeqQ6eY0bWttaUwu4jrbJyS8naJwxSaOfzKA5LPb8+9imgkLOf+2l5KoAihfmgiSN7Itr0M4rnVyomeVvAuAGf3kcVEf0v3COE9UYZ5tvOt31iU94jMDoH3Tox7FO3M0YGGJ+XruAIXqRzgK7YjcaDHGX7qXHoqH2h46x0hUxdL463PwUs8GY3bAwrLlU3Bz37w5N1RRQTUgfO0EBaB0LZY4ujAtl8RrHhzzTpEFg==
Received: from LV3PR12MB9356.namprd12.prod.outlook.com (2603:10b6:408:20c::21)
 by SJ2PR12MB9191.namprd12.prod.outlook.com (2603:10b6:a03:55a::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.159.17; Tue, 14 Jul
 2026 13:10:31 +0000
Received: from LV3PR12MB9356.namprd12.prod.outlook.com
 ([fe80::1c36:31b4:c420:6286]) by LV3PR12MB9356.namprd12.prod.outlook.com
 ([fe80::1c36:31b4:c420:6286%5]) with mapi id 15.21.0202.014; Tue, 14 Jul 2026
 13:10:31 +0000
Date: Tue, 14 Jul 2026 09:10:30 -0400
From: Yury Norov <ynorov@nvidia.com>
To: lirongqing <lirongqing@baidu.com>
Cc: Yury Norov <yury.norov@gmail.com>,
	Rasmus Villemoes <linux@rasmusvillemoes.dk>,
	linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org
Subject: Re: [PATCH v2] nodemask: reduce bitmap width to nr_node_ids in
 __nodemask_pr_numnodes()
Message-ID: <alY1Rm7n8DmEzqAd@yury>
References: <20260713075104.2196-1-lirongqing@baidu.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260713075104.2196-1-lirongqing@baidu.com>
X-ClientProxiedBy: BN1PR14CA0002.namprd14.prod.outlook.com
 (2603:10b6:408:e3::7) To LV3PR12MB9356.namprd12.prod.outlook.com
 (2603:10b6:408:20c::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV3PR12MB9356:EE_|SJ2PR12MB9191:EE_
X-MS-Office365-Filtering-Correlation-Id: 8b46ec02-082a-483d-feb6-08dee1a94886
X-LD-Processed: 43083d15-7273-40c1-b7db-39efd9ccc17a,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|376014|23010399003|56012099006|22082099003|18002099003|3023799007|11063799006;
X-Microsoft-Antispam-Message-Info:
	r0ZDIfWNIkIcbo8HDmq6c0WNWr4ltLb9W8hgXWZopAxBT12tcAV6D3SmuUcvh7+UESUtUemhDjpjqz3kyPwfVU40bgVuEjkOcT/ur3lG93d+usfZGnnZpuPGTXH7guJpL0W67H+7XVzH8V7NITHV7oNzcRuezmKL7lJWZGEDQ4F7ZRPxv7R16qGTDxjVWNAYHMQ2IKhaFTSQSuRP8tXk2sFku9CjYO4iVZQj7AvjzMsrSIenbeI1sJW6FJ1Emj35UWjoYQm41YEqfWH9RcCPQH9VdWPCcuPRD6IjSdQoY14jJa3Pqpq80FMlsluE0VIdRJgw6w8hsrHGdCTHD7QgtAT3Rv1as25bYlOCN18vJZmzZPbYgtScsnbT0b3rJ8QJpA9wqGlP1FIaYjOaSKQhiEk9NyQ4s95XU9d0SR9OGbVptvarrr2khYrD7puEVS8VaJAfl3f/JrjpU47ylKDgsrT463cB58Q6X6CPN5j0yrS/LPS5PXp9ASBANJOhP9Tu0shn4SrCFnqRGxaBvN7J12XzdAezJFgSzLcKBlWrPB9K15HWiJXgAq7Ocbyrrfd/Gv9kJhsYR091sCeRtm5yPl5d8G78xmUktlW6a096ob+TkOTcRDfoznZHOkRgt4DV2tmtUpQinfN3scyKEZ4BzuW+4HGe2y6DLmRqp3RmLvc=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV3PR12MB9356.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(23010399003)(56012099006)(22082099003)(18002099003)(3023799007)(11063799006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?weyVp3sD21n1vNE74CiQr1IwAQazGAaQjTvhuAvGQQkUAvmbJgfP5Zwykn5a?=
 =?us-ascii?Q?b50nCLnSQfncijcCHGXQQmRX99GiWDdQsXd6i/kRLmYE7xe34qMbNsJ3E51z?=
 =?us-ascii?Q?IF3fp7GxI9RekwmRDNDtrCiFeNC/9p7FainCs5Xxe1BRqqEa0i00/E9sVb/T?=
 =?us-ascii?Q?2W5N+Jbm4CVFcd/vStaA/dKnr6cAbgrIE270yLleFljKahCtsN/sPo/nASKR?=
 =?us-ascii?Q?AVyO+00I0QZ9lq8AL5eCfPffhOIHGvlseana/J7IgJl7Sa7m4fNv5p3VPGWG?=
 =?us-ascii?Q?fGN+dDqZHAor01ndBB8R76fiXm7CYfYMNg0eG1pmG6Dw6Li2KOIgVYtSaQw1?=
 =?us-ascii?Q?m4+Fa9jvDmXA9esSi+DZgo7OP32y8xazxgWCMGyeWA4Jxn7YnzLqo7JsB9XX?=
 =?us-ascii?Q?7R6Hjaov3t92EDm1t5K3p6cFRBbkYOXxDsfgOUrBqNPkgVfG642cmjfo5VRr?=
 =?us-ascii?Q?l5TXI1+xVxReUpHsa8y8c/wRs/upPo/Aveeo2QB/G5GULqKK6VCe1/3JwJUd?=
 =?us-ascii?Q?u61rLM6McO//JpOL6fc2NFSOUqbz7EqOJ2xaX4WEbSj24RrSWCgsbHLW0IJY?=
 =?us-ascii?Q?TYOhQacDTiRt19HqhcgG9b/J/80ndScrqZfM3f2Bgi1PHKlBitLSlLjA6poe?=
 =?us-ascii?Q?67gYH+n5EV1DJ5EF1E26VAP8iuBkExn2aPZeFeZj1vh+lWJ2qrlnpDAo7B4X?=
 =?us-ascii?Q?HRuiB+5Q5spq98kULBwpkG4+UcWE2ZUEJubRfFQXrCyEy2doCtuqoI8AkePM?=
 =?us-ascii?Q?mbJH9hXaglylON3bAr/0eiuEsEFN5eHHmt7y0nwV0JYSZeUkMa3BToP6SNBC?=
 =?us-ascii?Q?E0Y8OOTb+52lv2v43wgSEgeQp869P/PWHUnTAXrRpTq5R8Bmq5pv7ImFvIwd?=
 =?us-ascii?Q?SRblnsBNMZMuZkC0dzKprZ5S5oTFL/ilndS0mOD4Yrxj0lnbKkhBLSn0fbW7?=
 =?us-ascii?Q?c+eZHpVWk3rpWw8yWSEaeE3Blz9GJtmR/NJFPNHVuoZ1kGxeAd7K8qexIHAS?=
 =?us-ascii?Q?pjFUQWMlHq8oJJ49+L//idOXtZhXVUZMhZfmPjiJHo82SXfm1U09lLX5Eq4n?=
 =?us-ascii?Q?XnPq6/zgWJxSFAKwbDslqdLYp6AH0Vw0Pk0jHJ0t0aDMcIEGPrHYgGn9E8Z4?=
 =?us-ascii?Q?Mv0ppvgVFc/j7DWIeVwUEfhQx+XHkV5UQwq46Ez9sU9OmKfLvkktilREuKFG?=
 =?us-ascii?Q?KdY0bwbf6p9BN+1BSzhH+cCgLft6I3CQcQf8nNOBY295Ev2MX0woyqQxMaqY?=
 =?us-ascii?Q?GMPq1KzU1K/NR1eJZbFm3rQts/i3nea+2d4JJQPWxKeHwPJNCpiu7DavJNFC?=
 =?us-ascii?Q?s+Ey0eWUVIkfA7ZkwcGHfaolYz/Hb9f3Kr9MXdTrYlvCFiuHmkTtfxWn+eDp?=
 =?us-ascii?Q?h2RhKAtR26lMCNL6Qyzz0yFHkIirj3Q0pk3Lu705Ib2ZALpRkrxtDQAZ/CUN?=
 =?us-ascii?Q?pwbmnm2+xbvFy0NhuA5uowfwvdNxChcGLPF32WpvexawNpZJQOLi5FejV7gj?=
 =?us-ascii?Q?WMcY/sDSR+wy8WDvz4n7QkHSwJaLWYkPOZgHuVkLpLax1NIAYNrRRFJi5o6e?=
 =?us-ascii?Q?ANEH2hY0850HaqnLrcCSFImTFW9Glaemj6AF/b/xyQ5EuX/8n3J7gWgOmRPf?=
 =?us-ascii?Q?96yqWG7D8fQ/TewO5gKD50M0R7YjJuiwWp6GwW62/wsnV9iX3AWpoq5APkOd?=
 =?us-ascii?Q?n+zUmKJG+W5DJyjRLEpnh3WmSvTVCZ0YhvKuTLXlm1T720QZKqnSNaOk08+y?=
 =?us-ascii?Q?gdlrN1bNRw=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8b46ec02-082a-483d-feb6-08dee1a94886
X-MS-Exchange-CrossTenant-AuthSource: LV3PR12MB9356.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jul 2026 13:10:31.7910
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 96IY5EKju0YkRW9TrwvVgxUyM4wSp6XaKkswtey70qxgtdDUbmmPrnFx6mKW1UI/+0FXfxwFlZZdf3GtkKsK9Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB9191
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 1E88214000F
X-Stat-Signature: ffoqcook435937i9e9f4n45hafjrxwgi
X-Rspam-User: 
X-HE-Tag: 1784034635-238102
X-HE-Meta: U2FsdGVkX1+c5Anp4p+QYs31CJV8qtsK9RVa0m7Dh1iSUfPDUshheExcT8PpgeH4/+IEqTrLzLLJXIggqPXN9neT2YZ0fvpimn5fJw2qIGNK9V2BmglUi8kj385RbWyNlAu+HOwOtPe0grNsfzlBegCQr3fJH2hg2rF8TGazqNcbUWdw+ztLnQsuthFU3TwDraiQ4XhNdJ16/FLHCsnxiO8bF2snmWeaV0rBYFu1pu6+WV3+DfnHXYfM8bLaEzDnQVkyFwIvRQu0u3Mk2d1/ohxIi9yVMbMMgrls0xS/Xo8uAZMeMR2njjU2q42y7gvaeFrvHUBfGhjSpu9OstogJlyXKkkAJR4WQ+f3knmhDdKWaggF3hF9CAsavCkMqoS4EQqxOhIcmdfkxH2b/mvJp41K5G9uw4VLYAh2HvMQRhJhebsHbxWD/kmTVZbz8C5vUcm30GBRYmJu7ISPAyBqmlBt0R/CoYQTVtZW9jAhlotzXHHewOs06P1F/cuE6f7C84948LXfHbsG1XahHfdKnou6Ye9I8qO0tYajSGB26YU9KQjVj+B3npWC+3QehFl2ETZQy8w0AslpTD+cRlWdBxgCsNrG1W7m7dtikAaq1ggS6tX1pfFIUPzsVO1/HB8x09EjGqx+kA9hnMA3yUcM96+wQ6bmhvsRcX1gjzHLDmx7ywKKhCXr119HHWGTCroi9/1ctX4TSHhTWUkQxC9Jpz/rhso5oJJLiLKusP3fuFqKndOFS5HtVXSFFlB/6xpUOKPmXEIc6sE82SJmQvL2ebKsqMjWj+PeAaNdkzq8/ZfNRosl4WoqkhmdrFh5A7wgqMmdEiFTx9uke+D3JExDgRU5/U6bLF7KyxkUkGV+Z6qhVwJdQiHlCWwVwzSjclXBJyNyaL1CtEkn/j7d92GtuSjH36sZhNPFBuyCWCUniQ2ne9DaTfK7m4VluGCsAvwqdI57sK6uF6U6Q38sydS
 rlEjikJq
 ExW60M5904QxP79RMyOfN0yo1maQg0df1CEu67108YTbMzMwvdxau6I8ne4xsKzO/S/SVM0kbmmqrXC/QU39+PblL+C5Xw856vCeW4+CXpTRe5HWipYYxvLbDfQYykUN24cbwqxx5vGS2HZsF4rG7bKKmc4B8Sb1Pm9YQTDQeD1c+moRxE61pqOpZvPY60fwCYJgfPqbt2emaQ10orIodkrb1BRE4hdfcWwAChG24VybktpGZ+2h2FwuFhG4Nwv/PcfUhE5yj3WvGN5D4T2KoroJRAZeyVpqD3iBRjOdbjYIg+6nSp6ECrwNMm88JUlBb6vPP4OXaddIC8a2VMU50MhEUYZd8tNlfV+ZGUmq9cxNSF18g0zVc+zn5ih4bq3NNA+6mpzHV/6u5HaYkbBT1YIqzDbNB/sxwXEePGMawc0NAe2R1Jn06066C/CHm6IMmq4AOJ8M36mgwnqllWY82UdCzr3DEvMYfXofUl3MHSP1wmBnv/d/LIXe2thwlPKlPUxDX4dvHrz0v2ajQGQJMeQpr09LOFRBL8O5k+avcq9vyc19Ctl50p2aGC89MRjTxY96dtXsY8qYPtbJpaI7sRQhOMo+I4nks5vuuAuqGH6KBenn/gfJ/n4PqQDoMY3RtfAXSJ8xy6mk/WAW1s/eSqzBnAhjbergJWEeojGO43nWlGxtLDKZpim26jg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jul 13, 2026 at 03:51:04PM +0800, lirongqing wrote:
> From: Li RongQing <lirongqing@baidu.com>
> 
> __nodemask_pr_numnodes() currently returns MAX_NUMNODES as the field
> width for '%*pb[l]' nodemask printing. MAX_NUMNODES is a compile-time
> upper bound and can be much larger than the runtime node id range,
> resulting in excessive zero padding in bitmap-form output.
> 
> For example, /proc/<pid>/status prints Mems_allowed with '%*pb' using
> the nodemask_pr_args() helper. On systems built with MAX_NUMNODES=1024
> but booted with a much smaller possible-node range, this produces:
> 
>   Mems_allowed: 00000000,00000000,...,00000003
> 
> Switch to nr_node_ids, matching the behavior of cpumask_pr_args() which
> uses nr_cpu_ids. This reduces the output width from MAX_NUMNODES bits
> to the runtime node id range:
> 
>   Mems_allowed: 3
> 
> Visible impact on in-tree users:
> - Bitmap format ('%*pb') users:
>   * /proc/<pid>/status Mems_allowed (format changes as shown above)

OK, let me take it for testing. If no complains from users, it's a
nice cleanup.
 
> - List format ('%*pbl') users, output is unchanged, as list formatter
>   only prints set bit ranges:
>   * /sys/devices/system/node/{possible,online,has_normal_memory, ...}
>   * NVMe multipath sysfs numa_nodes
>   * memory tier sysfs nodelist
>   * cpuset cgroup mems and effective_mems files
>   * /proc/<pid>/status Mems_allowed_list
>   * mempolicy strings in /proc/<pid>/numa_maps
>   * SLUB debugfs output
>   * Kernel log messages printing nodemasks
> 
> Move nr_node_ids and nr_online_nodes declarations earlier in the file
> to allow __nodemask_pr_numnodes() to use nr_node_ids.
> 
> Cc: Yury Norov <yury.norov@gmail.com>
> Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: linux-mm@kvack.org
> Signed-off-by: Li RongQing <lirongqing@baidu.com>
> ---
> Changes from v1:
> - List the unaffected '%*pbl' users explicitly, noting that their
>   visible output is unchanged since the list formatter only prints
>   set bit ranges regardless of field width.
> - Move the nr_node_ids and nr_online_nodes declarations earlier 
> 
> include/linux/nodemask.h | 15 +++++++++------
>  1 file changed, 9 insertions(+), 6 deletions(-)
> 
> diff --git a/include/linux/nodemask.h b/include/linux/nodemask.h
> index b842aa5..607373b 100644
> --- a/include/linux/nodemask.h
> +++ b/include/linux/nodemask.h
> @@ -95,6 +95,14 @@
>  
>  extern nodemask_t _unused_nodemask_arg_;
>  
> +#if MAX_NUMNODES > 1
> +extern unsigned int nr_node_ids;
> +extern unsigned int nr_online_nodes;
> +#else
> +#define nr_node_ids		1U
> +#define nr_online_nodes		1U
> +#endif
> +
>  /**
>   * nodemask_pr_args - printf args to output a nodemask
>   * @maskp: nodemask to be printed
> @@ -105,7 +113,7 @@ extern nodemask_t _unused_nodemask_arg_;
>  				__nodemask_pr_bits(maskp)
>  static __always_inline unsigned int __nodemask_pr_numnodes(const nodemask_t *m)
>  {
> -	return m ? MAX_NUMNODES : 0;
> +	return m ? nr_node_ids : 0;
>  }
>  static __always_inline const unsigned long *__nodemask_pr_bits(const nodemask_t *m)
>  {
> @@ -438,9 +446,6 @@ static __always_inline unsigned int next_memory_node(int nid)
>  	return next_node(nid, node_states[N_MEMORY]);
>  }
>  
> -extern unsigned int nr_node_ids;
> -extern unsigned int nr_online_nodes;
> -
>  static __always_inline void node_set_online(int nid)
>  {
>  	node_set_state(nid, N_ONLINE);
> @@ -480,8 +485,6 @@ static __always_inline int num_node_state(enum node_states state)
>  #define first_memory_node	0
>  #define next_online_node(nid)	(MAX_NUMNODES)
>  #define next_memory_node(nid)	(MAX_NUMNODES)
> -#define nr_node_ids		1U
> -#define nr_online_nodes		1U
>  
>  #define node_set_online(node)	   node_set_state((node), N_ONLINE)
>  #define node_set_offline(node)	   node_clear_state((node), N_ONLINE)
> -- 
> 2.9.4

