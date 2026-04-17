Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D14A4F436B4
	for <linux-mm@archiver.kernel.org>; Fri, 17 Apr 2026 15:58:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3EFAD6B0129; Fri, 17 Apr 2026 11:58:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3A11E6B012B; Fri, 17 Apr 2026 11:58:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 28EF36B012C; Fri, 17 Apr 2026 11:58:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 144536B0129
	for <linux-mm@kvack.org>; Fri, 17 Apr 2026 11:58:24 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 902101401CE
	for <linux-mm@kvack.org>; Fri, 17 Apr 2026 15:58:23 +0000 (UTC)
X-FDA: 84668504886.16.4C43C5E
Received: from BL2PR02CU003.outbound.protection.outlook.com (mail-eastusazon11011025.outbound.protection.outlook.com [52.101.52.25])
	by imf24.hostedemail.com (Postfix) with ESMTP id C8199180003
	for <linux-mm@kvack.org>; Fri, 17 Apr 2026 15:58:20 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=rZeqLYdz;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf24.hostedemail.com: domain of ziy@nvidia.com designates 52.101.52.25 as permitted sender) smtp.mailfrom=ziy@nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776441500;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cmQZLqy/uiItvG6hMKeR2VwUjpnz5XfJpKQjszdUzZk=;
	b=mRHCP9Na1FNbPZ4KpT/v7YJZxYCdXK7KETISWtbpYPtfTCxe6TXCBOwYkuWNlGeNhSsNMF
	FoAu5/QLHQ1UNMsYrwnfxV+xlSqlzoxzBdPcOrV8hgjdtDsPiCf/1dyJW5BmzZsj/vKQN1
	U8iC/8lc26/mQqBo4j+Ri5bQ/9m2dKE=
ARC-Authentication-Results: i=2;
	imf24.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=rZeqLYdz;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf24.hostedemail.com: domain of ziy@nvidia.com designates 52.101.52.25 as permitted sender) smtp.mailfrom=ziy@nvidia.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1776441500; a=rsa-sha256;
	cv=pass;
	b=LsPpOApqRR5lLQmfnuWF0IB0ANe2CYUD8U4C8ifXzI7OlKC+tenAgIYBxwjbJoepenAuEJ
	V19e+7IepJMFyEBJ3RiMsW3470aPCxtIsZ5EgjR0SUG63ubq4Etd31CcuPh13fQE6iqyT7
	vETSXWWbqfWLX0CxTo+0l8a+zOl+tec=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=K3C+VlegcP1f8msURywh7BVGCVb2i5mLLJL9ALIJnX9oau7WZjvLovqQdjcgaucqNVlQIYJp1z0s722V672/zu+UBHNh9/anV4DmvEDs9XGANkVhWu3j/5D6q9zEf3OCq56VTlIfeu9/pa2Dqb/tF5qhN95wk9qaHc60hi6DrnBrPKlSwd5UdBxYsikMr2xSUPdNtmbzsQ76kfNyWFFrGpb8BPRiJBxDeEW/9r3ddpyM4DwMVSOWGZ5nDa04uC/rJ/Hlr5VZjDCkd+qEcL5p9Wam8qFIkknI7bDu4EwmEGnwBMKK7HEfWuxS23w42PgZMjcYIKUZ9cb/0xrZkW8BqA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cmQZLqy/uiItvG6hMKeR2VwUjpnz5XfJpKQjszdUzZk=;
 b=g23h9xU785KfEiEtWMok9v7vvE2XdrOhEXQ0xcZLpAmvqW+Ai03SSnkoHKnYfNMbxJlVcHpX8IQa6iv1rAfVUu92pFi5Bad4fqjAWlfqW/IwVW1a/MnqpFe2UU++nLLFiUZqwyklcCJtToc3ccfg2Lj9RGaCuSrl9HDObzEsanmhxuPRmesnmCZdRfnuvAGFAs1MoHS57FX5jL/1ibCw0tQ/8In9saF2JQM4/wEnafCFu+jANmzwowEByyF82EvQNXRqSsNGoIinH5V0B/yjBFO6fzCbdG7TPjthXizCA0EwYfhxbcY+isDQ4y8XWV2+XLLo/i1lhUl7Tpz527H2oQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cmQZLqy/uiItvG6hMKeR2VwUjpnz5XfJpKQjszdUzZk=;
 b=rZeqLYdzAblWbvBnmHgh+16I4NR1VS2P0xIwNCopqG9Vr7i94eeXNCZNCOZrYY4u/GqEGAzWTqrIsH8E+6UyajGluxPdU/geKAgRDDmYeyPao8UNJ3HujxoIOz/OYjBiVw6Q1eOI2Rzf5gXSwhsyuZJGzp79e+EIFrMSVZ3Sk5ZrVdqdp6SbtE1M4rVe2GvQPyLhgde09Pn6XEtf8C57+kX9jvH680+GJR+26DsCbLgDLY6wv/hQsG4LH/aNH4LYaqSRSBr05V2bJaLLs2LhYp4uoL3cgz8pLS15wPMO7UrOq7tUrRI85CvfI3+zormy5zCQF62el0tAPt34Y+qgaw==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 DS5PPF266051432.namprd12.prod.outlook.com (2603:10b6:f:fc00::648) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9818.20; Fri, 17 Apr
 2026 15:58:14 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2%4]) with mapi id 15.20.9818.017; Fri, 17 Apr 2026
 15:58:13 +0000
From: Zi Yan <ziy@nvidia.com>
To: Zhen Ni <zhen.ni@easystack.cn>
Cc: akpm@linux-foundation.org, vbabka@kernel.org, surenb@google.com,
 mhocko@suse.com, jackmanb@google.com, hannes@cmpxchg.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] mm/page_owner: add NUMA node filter
Date: Fri, 17 Apr 2026 11:58:10 -0400
X-Mailer: MailMate (2.0r6290)
Message-ID: <EA267977-8282-4A65-8BDB-A6A370B75F7C@nvidia.com>
In-Reply-To: <20260417154638.22370-4-zhen.ni@easystack.cn>
References: <20260417154638.22370-1-zhen.ni@easystack.cn>
 <20260417154638.22370-4-zhen.ni@easystack.cn>
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: BL1PR13CA0097.namprd13.prod.outlook.com
 (2603:10b6:208:2b9::12) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|DS5PPF266051432:EE_
X-MS-Office365-Filtering-Correlation-Id: 3b760ccc-1131-4172-fa5f-08de9c9a2178
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|376014|56012099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	UHYvAY//DqSRjk4PZN4D2wLM6aTdo7H40FH9D/6VZ8JJ+k+MDBNGylsjVNAAKbwydq0yI1ADPd9ivS8hz2X7PknryPQpCwmgFLjyQCtY6P+D/T0c1Kc7a9AGeLThYTYonBwQjteT9A0lZbJtSAZrljrcIRQoYDu5nC8RbiVwI52H6tCx2eWJq7L4jI7sSfGeqhLcJHwmXnJqrbb4JpEhhDd/owB272fkIKIHA6tAOJ5AKoMCI2DPZlok/6uMrfcHwoRf0ZSNfng/tKUubur86OAmos1xE0/C5afedSghvur0c4O32N71cXwL+FeyVs+WyzIthP1hL2bkq/AcIwh0Q15zZrhV438wOIMDsNnlWX9RE8N5RDLGfgMJF316TVQCtB+hpPaLm2OJa48bLR2WikFzrEolzQgGZVw4EauhgAFbJhuTrmUcuvm5ODjbCdCsqm4LhWWCqrzSX6p5Yxh95lk5l9p0L3SJeSZptaIl67082iN5r1mlq8SRZ+iFi5k/bfeGhXIUgdkWmCvsdgpRpZgeVq9NZTkGfjnHzCNdn6vWomhfsX5gZopzsxCyxUrhX/GX7FDVGybWvQ51/1r4JHrm9zWKRfEvFogm2Vd1dJz4/tewrm4siy0qJL/5Rwx3k3tD4/+/POGGnhjtSwYVcJ/Dp3a6KbPhAhmPLSPVKvaGDLeafmbv7cirvnW4WSMwdv2ORtAgMYMZ4GJ7Tq1TbAQAvpfGGKYYyRNuE64s2DE=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(56012099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?2TXhAsWtV1yQkIx8W4Evfz0Gd+YHp2Sh+zLc8cWRfHOcyHaKFz9lT75So535?=
 =?us-ascii?Q?jim2VdsVg+YGFB0xIriOG8CeqEGgd65uP+9I5/7iDBikKmrnRx8InM7IN7ut?=
 =?us-ascii?Q?k3L0wxYh6EK8Fa7IjcbYoUYUz+kfwsMA403q4Sv8bpg6HHhoQvqatVemAOAp?=
 =?us-ascii?Q?WnwZfQF+RAtyJ79IOLsTBLC0+P0JPFe4SXBrtccb0xzND3QMHWrZSF223DZL?=
 =?us-ascii?Q?lZ7LlU4h0Rpl4OgOBax92FCRq+m5vRhhOkDZbnHxvDV9X8IMJu8oI2WrZdC5?=
 =?us-ascii?Q?PbOgHUT38nqvUM9yLmBU937fmKqZowNjfZ8vijLGUyE67Ek7FOsw5DDmVQCu?=
 =?us-ascii?Q?jWFPb6jLCAAo/S4faAgAlkicjZ3VTqOuBANrJ3N86mRdknG/jMFiOUtg87np?=
 =?us-ascii?Q?WY7IQUR60TYUmIOdaBD5lu8XwKauBElJWR3YZuoCE7zMQAtCrh3IBL32X97Q?=
 =?us-ascii?Q?ETne3SBy3eT5mw7vGCgpGzPIt3xHdCtcLU/6KixxryprHSdbY5OmJx+74M9+?=
 =?us-ascii?Q?24PyXPCO2FeyNXy05U/l8sSiF+mmMB10e5khVyd6qolGHZpJ5SCUj/BEw217?=
 =?us-ascii?Q?Y9bDHnOsbY4xjI0184zDh8Ya1S9YPY5kjPI1czKir7fQWX5Rc+5caJF8ZUDQ?=
 =?us-ascii?Q?CMhmwiTDunO8dO1dRoJL0FBrP61ODykS5VohTVcn6LfVaYHb9PhR4lANDv4K?=
 =?us-ascii?Q?NGvWrLFcbpeo7i1dmOBuJyn9ia0FyhcRfnsPoygQwZ05TAwqofQ4PrvZaUkk?=
 =?us-ascii?Q?mIQ1Im9Td1MYsZDg+m+q2DJy3YXJkJ6Fm76o7ucaM5cs+iv6uNjmt5YiOW0w?=
 =?us-ascii?Q?+wQxAtiLejzm6m3P6encTUwoWiNWzrskXEJSqZGisfaNVtn4rf9Dr2EaR5ND?=
 =?us-ascii?Q?waoAMWZzsb8uMxj7DkVa3elCoUjwSzHh36zPXHzWHWLOSZoqF5e8c/XPmdmY?=
 =?us-ascii?Q?38BrMblu3nLpRSjfO94c0JthmVWQSDs+dlbjo0TV9fq9Xp7FabIM0iIhcTIs?=
 =?us-ascii?Q?EHbOKXyms51bKyMlWwH1Hy4nDzyuQgEGneH9iHG2IqeFC6sAiweOJK+BR1OJ?=
 =?us-ascii?Q?DBJ+LWzGNyQF2tTpc139djPZ2tGtHzoCwizlxuyy4R+qJM3GEkUk48Ovajmp?=
 =?us-ascii?Q?izva6vUwYNvTaAVxkOpDwV0Fxlpt0AKWZW1wsAQubCsOX4MVR+FxNKqLmQhx?=
 =?us-ascii?Q?7h0Smsj4YGl/83VtgVxvcKfsU6jZr6bFbJ0Y0JA4rUStQeHX+VqvTbsO22g+?=
 =?us-ascii?Q?a21iGFXKYf/+tdo61Y/OMajJ6dGMhzCDQZYQXAEyOSguAkGYaVfs52KEG4np?=
 =?us-ascii?Q?PRi70lnHBIMApjobY1R2dBdK0RnvZjejRkJlYoNYkK+w5dMs0lI0flhi9UDc?=
 =?us-ascii?Q?F4xWLd6+/+mu5XgVdf0vAk74VoTzw17vrYMQljVA7j5zujPSYRNk55L2JywJ?=
 =?us-ascii?Q?xi4OZyjWZYGFb0ybddHYGRClndPL2nrCS5txbQIin+kXRuoVzyFQLfrUhs6C?=
 =?us-ascii?Q?WBhFObCsyQJonj1bll9WPQuDsuFZjLbzIOUcFNe4t4KjPHHYM1+BrWt6uw+l?=
 =?us-ascii?Q?f2SvRNo0UspP1svsuEgWiev4QmU/4CAlVANenKOaLGePoyqwYGDb+nsgbv+q?=
 =?us-ascii?Q?coIjKpp7oN92JV9vy3sZFhLeFwjql+pQhnDsHww+5w5nSYUrsO+vFh2so1Bc?=
 =?us-ascii?Q?sL0k49RLfWv7Z37/5O1JKqjoNu+aZJhS8/sFHH3R6svv0nVBN3uYR612pYaK?=
 =?us-ascii?Q?irg1euIpWA=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3b760ccc-1131-4172-fa5f-08de9c9a2178
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Apr 2026 15:58:13.4759
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: t6qyWvR9wNeIeHmuNQbsGwNG1VptrsAW6fwjem9AdS4HlrVRUQkFjqOAdn3C25CX
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS5PPF266051432
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: C8199180003
X-Stat-Signature: czodde97aphmpatfoup4e7wfidtrg17y
X-HE-Tag: 1776441500-919025
X-HE-Meta: U2FsdGVkX18V0eebPu4p3HmX6g82dLvR4P/+VqA3E/AN/T7BRHjuxOppeJFLgRNizsc1qhIvD6qcz8ZjEp9bLMSezU4BwI7rVYrFhSqUkCmfFrYNrZ05x+mHC9k5DppPG0V3IRhAdlkGb8h6cExNeit8/J4nkC4eOGi319UiYwwKb0YzH38Nm0yvpynkioH848teF0qYKNk17kda8aqbNXaslmSh4N+pQ3iP7ErpRNIMuhtQSAstkcXTddzftD3Tv+/4+bgRad+UygrLAB5SuMbq8QS/Tg52Mu6Lkawbo+SFCWLw0jM8xmPGiUbcJA6LmUS5tFyGg9hLecHoC1MZ/AI+dBikgyzkkchf1hUE4M1IV4g4qIhdSYDkLHgvjFHA7SnQMmEuVCxjIhTygnc4eCy+/AH6jYa2UhXXBDsi9wf0cUZasKirIHoapRjHb//eLXN4f95v8LzJjvj3XUe4e/JYaihzok0mxTlPLfKd1gLGZJSJe7iy05/l5EkyknWO04ZQdiETwJnN3gcX2emP3uGTPXhIXD4FjzBWLaa9SMQBlNPQj7GDKyxTIWb0EbKTAHxaDfrPPKDFG+gkE7AFWjBWFKuoTYr8loxi4u9ODBZtvqPs0CVnyaeEY1APLsQixO8cDYKZsNQjSSWvAVFfGBc3Q1FsSoo475G0Fp/sWAoVYSozq93mrY8GySWLAjL5EX2AQK4kLaxwSYo/8mkt2Se3numYSmkpK/MDogdjKufUs10vs3hmySBqMJc1llQbGzT4HRo/k1mu/vN7YjUXc8aSHGGGEdJhql/HX/rsntCcW4ipFGA1NDkP1BKaFtyVBuOeDjpkiwdLIN/+ZggFAJSz8ZQ6aHNtBSo/gFyBgvKHGLUJFYyqdN+MhHFcUzduICxmco1Y5wILHz0/R3LeAIzSWI7VmHlGG1XYUZ1H+Jxq1SHD8YFNicrVmcinVuRCisJAsyVoy38PA+qUBAh
 LAWDiyPl
 nXH9bBWKM02dmNcRHZNf/7gkm17Oq6v9uSzL+ysZ7f8mINkxugCh0a4u8fmRvr5QMgBweFbWlP3YYe4c6VpMpZYvldqChULvK8jgGExd63/daW0SjnoVo5e+/N98yOQ0OgYO6VpSnJEsbbDAZCfTVO2LpHepeUS9Bto68+N5zIRIue95V3wfj6VjaamtRtwO4rzFHCPLvpSmu3LJX/DbG/vZgIwNsk166NJFQRrhLFVpK7H5/hk6HrR0gp5mCwM4YDIzwdYNZz2igdVgrc7GXNRJWz6T6Hg8KCeAocGO2+N92wzfQ3QLBeyg96dUOORuvmKCjDzuktH+DIZoWSRI4Crr2ZevSfj4k/hiiFHpAiDGto1kI/f18BB5d6zUxGglIEG3Y96l68qn5jIu6WiUcki7mUCx52Ibf9cNe
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 17 Apr 2026, at 11:46, Zhen Ni wrote:

> Add NUMA node filtering functionality to page_owner to allow
> filtering pages by specific NUMA node.

Would a NUMA node bitmask be more generally applicable?
For sysfs, input and output can be a list of NUMA nodes that will be prin=
ted.

>
> The filter allows users to focus on pages from a specific NUMA node,
> which is useful for NUMA-aware memory allocation analysis and debugging=
=2E
> Setting nid to -1 disables filtering (default behavior).
>
> Signed-off-by: Zhen Ni <zhen.ni@easystack.cn>
> ---
>  mm/page_owner.c | 27 +++++++++++++++++++++++++++
>  1 file changed, 27 insertions(+)
>
> diff --git a/mm/page_owner.c b/mm/page_owner.c
> index 214b58eef3d8..ebc29f3f516d 100644
> --- a/mm/page_owner.c
> +++ b/mm/page_owner.c
> @@ -726,6 +726,13 @@ read_page_owner(struct file *file, char __user *bu=
f, size_t count, loff_t *ppos)
>  		if (unlikely(!page_ext))
>  			continue;
>
> +		if (READ_ONCE(owner_filter.nid) >=3D 0) {
> +			int nid =3D page_to_nid(page);
> +
> +			if (nid !=3D READ_ONCE(owner_filter.nid))
> +				goto ext_put_continue;
> +		}
> +
>  		/*
>  		 * Some pages could be missed by concurrent allocation or free,
>  		 * because we don't hold the zone lock.
> @@ -987,6 +994,24 @@ static int page_owner_threshold_set(void *data, u6=
4 val)
>  DEFINE_SIMPLE_ATTRIBUTE(page_owner_threshold_fops, &page_owner_thresho=
ld_get,
>  			&page_owner_threshold_set, "%llu");
>
> +static int page_owner_nid_filter_get(void *data, u64 *val)
> +{
> +	*val =3D READ_ONCE(owner_filter.nid);
> +	return 0;
> +}
> +
> +static int page_owner_nid_filter_set(void *data, u64 val)
> +{
> +	if (val >=3D MAX_NUMNODES && val !=3D (u64)-1)
> +		return -EINVAL;
> +	WRITE_ONCE(owner_filter.nid, val);
> +	return 0;
> +}
> +
> +DEFINE_SIMPLE_ATTRIBUTE(page_owner_nid_filter_fops,
> +			&page_owner_nid_filter_get,
> +			&page_owner_nid_filter_set, "%lld");
> +
>  static int page_owner_compact_get(void *data, u64 *val)
>  {
>  	*val =3D READ_ONCE(owner_filter.compact);
> @@ -1018,6 +1043,8 @@ static int __init pageowner_init(void)
>  	debugfs_create_file("page_owner", 0400, NULL, NULL, &page_owner_fops)=
;
>
>  	filter_dir =3D debugfs_create_dir("page_owner_filter", NULL);
> +	debugfs_create_file("nid", 0600, filter_dir, NULL,
> +			    &page_owner_nid_filter_fops);
>  	debugfs_create_file("compact", 0600, filter_dir, NULL,
>  			    &page_owner_compact_fops);
>
> -- =

> 2.20.1


Best Regards,
Yan, Zi

