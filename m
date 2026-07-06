Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 25E20C43458
	for <linux-mm@archiver.kernel.org>; Mon,  6 Jul 2026 04:30:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AD9B66B009E; Mon,  6 Jul 2026 00:30:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A8A886B009F; Mon,  6 Jul 2026 00:30:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9796C6B00A0; Mon,  6 Jul 2026 00:30:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 6A1B76B009E
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 00:30:11 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id D99571A02AB
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 04:30:10 +0000 (UTC)
X-FDA: 84957074580.13.C6B020B
Received: from BYAPR05CU005.outbound.protection.outlook.com (mail-westusazon11010068.outbound.protection.outlook.com [52.101.85.68])
	by imf01.hostedemail.com (Postfix) with ESMTP id 1D8D340007
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 04:30:07 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=kQUEFkg8;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf01.hostedemail.com: domain of apopple@nvidia.com designates 52.101.85.68 as permitted sender) smtp.mailfrom=apopple@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783312208;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=smmbt/JJKOiuIzYSXiP0r78cJIGPgw0zkFhphwekzAs=;
	b=e+qqJ+Wfl9HCqcKSuQROT1ea6uok+GYONp3Dx1TIvY+yyirEmInOnu0zkh1SVgRG7eE9XG
	r0k6TYzuwNb4drxtqF4Pkw+CjxSRMIPM7rMcKKv/xQC4ZxyWw6LS7GhVDkKXq+/vPLYmiS
	AWL5h9LpVzRwgEzJ8C27IwBdyZ+Od/Y=
ARC-Authentication-Results: i=2;
	imf01.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=kQUEFkg8;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf01.hostedemail.com: domain of apopple@nvidia.com designates 52.101.85.68 as permitted sender) smtp.mailfrom=apopple@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1783312208;
	b=bKxlbYxjOOw32JSm37fvZJ6b9dmzfGb2jySHQ5hBzD6wU8wv9mB5k95lFslgnzT64Qy0ZQ
	R8Ooh2rTHc1Eu3BS5C7Ush2rNN44SiaHsrZkQ35b5aZ3xpWVQl/r4mr2/Jzg7m+yBq9lTv
	mw1ypQOhF+Knl0uzlE2Vs8vRtah+TXM=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=sTemwmmlP6FNjG3dbL9tvdEb1PWnr1e9cAmJA3sE4EhPzAh12L1LdQliR1XgPxzUvpRzE0GHvNopDTVIpE8bicWma5OODKgZoQW+rINhvAIOAWG9H0tSo/r862lYZiaa75NV3EK9/E0H/OrQ9e3DxLPBqUMcRvb6j4VxZblPApafpDDFirvE9QN9z9le0ddyZp9kk/nKydneIG1GVEIeWkRVPhsZKPS5QPI+L/ck+RbL4QClt59zZvZN9yU5IK8vNSifFSP2o3pwx8VvYo4llAxknqZRv+pVZGIL51bGTO18Tv2UfLwXTUDOV4GZuuQw+As5ejC5iakh4LnSZ3LMtQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=smmbt/JJKOiuIzYSXiP0r78cJIGPgw0zkFhphwekzAs=;
 b=BGNTyRhs2YRLKgsB8n7wVftYrZoQwWn7uwPYXbuTvG8sQk9G3QAE3RpZ6yO7qS0BvRpyXMorJcvojM1AYg/sxvkCSqXEPld5aY0mQu/QbpKV5WXZBe+DIPPd10ooo10lx4vUQvxcMbIJfowl6L6MdxKNnfEHsNS2R8RzhJWTIGk/DYlYxxJstBqY2s8cjeDCGjxFyBeBULgLy+9no5lDqNeE3usKInIOOvwyT3f2vJ7i8rQJMieSBVHH8g8VYdlXVuiTTEhIEBITVyZbshmPN4slryqaqfjNMtOyaLpnCZF18Kfl04kIdw8333YB4liCScrdl7KQqxRq6WJSAtHSQg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=smmbt/JJKOiuIzYSXiP0r78cJIGPgw0zkFhphwekzAs=;
 b=kQUEFkg8wrfPBbYouqWJRm/LPhnPsF/lMnU90AMfdo/cDBlXGvotAh8mS5lsJe+Vi0ywf3/PvOvmP0/MZi5marRcnrg51pSLBMk6eSnChpoX5OYUooHWjZ0yDJxpMH4Sn3n81r7ts/GgVyv9UYJlNGaDZ5IWUtop1Vz0yKWV5hu3IEAjK0rLhW1gjSVPQzdiZHNVxsjNWnURzFJOqBffW2ECkFkNlPrDoirRsjP7n0BwnCifeZKagb5adY5z6Vq5Nkphzj86WjpynDKYoYl/nTo4Jis1xVCwF1KT6jqv17af7oVEKvciYobwwTaLiSC8H4FI8p/IUe1H/JbgesfWPA==
Received: from DS0PR12MB7726.namprd12.prod.outlook.com (2603:10b6:8:130::6) by
 MW4PR12MB6780.namprd12.prod.outlook.com (2603:10b6:303:20e::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.181.8; Mon, 6 Jul 2026
 04:30:03 +0000
Received: from DS0PR12MB7726.namprd12.prod.outlook.com
 ([fe80::5807:8e24:69b0:f6c0]) by DS0PR12MB7726.namprd12.prod.outlook.com
 ([fe80::5807:8e24:69b0:f6c0%4]) with mapi id 15.21.0181.008; Mon, 6 Jul 2026
 04:30:03 +0000
Date: Mon, 6 Jul 2026 14:29:56 +1000
From: Alistair Popple <apopple@nvidia.com>
To: Stanislav Kinsburskii <skinsburskii@gmail.com>
Cc: akpm@linux-foundation.org, jgg@ziepe.ca, leon@kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH] lib: test_hmm: use device devt for coherent device range
 selection
Message-ID: <aksu7Baw-Pe4WtuT@nvdebian.thelocal>
References: <178277581197.172200.16265155329935822153.stgit@skinsburskii>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <178277581197.172200.16265155329935822153.stgit@skinsburskii>
X-ClientProxiedBy: SY5P282CA0070.AUSP282.PROD.OUTLOOK.COM
 (2603:10c6:10:203::16) To DS0PR12MB7726.namprd12.prod.outlook.com
 (2603:10b6:8:130::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR12MB7726:EE_|MW4PR12MB6780:EE_
X-MS-Office365-Filtering-Correlation-Id: 84c63572-8fdd-4133-6c5a-08dedb173f6d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|23010399003|1800799024|376014|18002099003|22082099003|56012099006|11063799006;
X-Microsoft-Antispam-Message-Info:
	0O+42YQ+mf9tyylIvlPGXmCIAYYmhMpodvdwzt6HJMZK5M71Sq/E2SM80L0+Yect7AY379OoPEBVQno2q1geFd0HStuKrdbRvaoYLX8i0TgOe8fFHGsZlqM78SwEGKPjDJZZSD/WjwrzhivVoSEg+4suGNJXRkxv/qfCtkeu8lt80KD9ZANQ//H+MO7/yjjNhWVjeHKRKIFjhzHEyy8t8NdkgaFVYXjRLlDKWgK/9IaAylr3hLPEXdLyt5QimoebtO6+fTv9EL/avog+S4nx+3xo5NA1ABK09bqOXTlOayRsbHjre37RkWHIKe59EsIbRq2Ib2Z9PsrzPmlAkV7V/cQ18OKzHOtZS+6FAS15oYeQnCLo785UecWRvl6KXAOQt5pXEKJMmWVblSoWZJpWS7jcle+rARltDPTVkEspOJq64p/qJhFQBrcEU+aGkIAIau/rrECA1e58Ix0AKoQ+Z9UrKN7l2iIauyF1XsPRkVNfYAg55pc4igXSYI1D8HKgby3fY6Adj9vQQCbxT5b4RMHfPz6AFIY04y3ohcEulPMVfsZpVKJTAI5m24TOnrkIGa0RNudpDmFTBNWlvJQ6VWVvc3btGVUsymUwgWo7jI/bNGpN1mqqVNmkujZibmaeSsZoo6glU0g4n1Aek6LH5TzaS16orf/5vJXWEtqM478=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR12MB7726.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(23010399003)(1800799024)(376014)(18002099003)(22082099003)(56012099006)(11063799006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?qAi9og+pfm6U99LIGNir2YUS+eRGw7ZvAUmFQBdd35a44DskWPXmqDWCYkpJ?=
 =?us-ascii?Q?mMsqqy2Gjb69dZRbZuoQwoqaKsAPI3qFrHstXgaqHMXymIUFe2GLbqRzuabl?=
 =?us-ascii?Q?MzymVtjm2ugMbOWW5X/EYTn8TnFSdfvnjPLVYLg0GGSDLkiBNp7pbLAo0DCx?=
 =?us-ascii?Q?NOG8BqgLsTAWn5E/bfte8ilRtKjOI3g+VV9n1C5aflVoOZALNraRvUHIoOJ+?=
 =?us-ascii?Q?/429U/EGa7qT9uLbYNm2a42yUlLidaqUUoiY2bfY1hEwfXqqb+DwqZB0eP+W?=
 =?us-ascii?Q?A+lFN420uR3AAW6ZzSeVg1d+Lr8Sa1lIUFRCES0S+SaefH16o9Wb3ePCJSND?=
 =?us-ascii?Q?lc0E3afJ/kD988pdAm/cCQUkKx/WkCwSfZW0DGDvw1k0GZnuWg32Ylz3HQJx?=
 =?us-ascii?Q?MjFCYmDX3N/T+VNebFm/rLoCj05ufqiEod/isd7PqWlXXxmzrCQad7EfDjah?=
 =?us-ascii?Q?ot6274mekgbi7g0no+VGn5I/v2l9BAwrL147vgkh9zFeLqrhC7lgofcgJWwh?=
 =?us-ascii?Q?lmoMFd0ChLv7DKM5jDUN9NMAtJoOJBpoXpAGYzXZn4pNiANlAKNN5sCjuJDP?=
 =?us-ascii?Q?c3hTuNDMgXIZQCfFMOWehwqs2h/NJ1j1ZO3+unPZjxEwH8leeq9KAlHwZWvf?=
 =?us-ascii?Q?8ks2CvbjvZTdm4oSXHYO8e6CPXTQfhkKL2kdJTC0A40Ov2k1N1NnhopZlEGv?=
 =?us-ascii?Q?HRKWn2lFGsW8Ejk73ov6BHyy5J7GtBjbku5cjbgK5v/Bb9DKfQTbscXTzn22?=
 =?us-ascii?Q?CjDl1uV4aVz9cGXxUTVExXJdklqkOlZsR553AJIfV5dExpgixZcXkaahK0Ml?=
 =?us-ascii?Q?U6wvWe2Z9NxxulGaQDYoLJr2S+6sNgnDFKFJy1g9fGHyOD7lwdeWmEJUOU3V?=
 =?us-ascii?Q?01sNFIfzZxCic+0evBeQYEEolQtmgiGvC2nX3jDs70xa+V9l1r7C+dBPWhZQ?=
 =?us-ascii?Q?xXya5IDg+Jv8pwr4+BVd2rbFk1OppdSgqpCCx2Ohw1vCxrxTQ1VkMrHfPXd/?=
 =?us-ascii?Q?gS3/bVXesbVM3Ekoi7s7qjnvcM7KqNqjqR4u1pancFvx3gbpKuqCRRcyhsHx?=
 =?us-ascii?Q?1rxi/rzpRyrMj1wGbynSk7eCACPJMnuJLGkczDJ6fBLRiv22h3rAW13pfRib?=
 =?us-ascii?Q?I2wpGTtx4ni8tUzSZadyN/Rz+z5BzdL1T/fLqfMIN2aFYEJNqWK6p9vmnJS9?=
 =?us-ascii?Q?WEUXS/o0ngK+Lejaci5+o9Qk3N6DkQl1AMPdPPJIvqm98T+cvQ6fIHQ1rxml?=
 =?us-ascii?Q?z8mzf57IPKI3sxfpGc/guaAzZJ8OakLJD/ZLkTtkrm0VlxJ/9okqWEeR/P4o?=
 =?us-ascii?Q?v4coovlVTpmqMGMTqoK5IjuDeN31VrVDteDwzdnqM4SN4ZBVaayxzNGpIOvC?=
 =?us-ascii?Q?AcFgbYx6KAfQ6tJnEhlAaDjof0ggRN+K38EMClB+CAJvvpSCARBJfd8iM+s8?=
 =?us-ascii?Q?D4Mx5pqjapWzasByaiqWITbwBco/XK+MWLpGE/WBK5hJIqIF+B+QvNK+TlS8?=
 =?us-ascii?Q?p1sQLZLUNE54mzOzsH2B2AYkeytLK5BrVnMSH0tJ2NISO2L0EXADZbGYY23F?=
 =?us-ascii?Q?k73rnKfhJ9NbzfXWQQ8sLdcX4xTdxDfJTyQz3R2NJalxhV8RzCZbsvBxNPpX?=
 =?us-ascii?Q?H1Ae0Vhb/c/AUc9t0OkO5YhDH+6qQgxk+5Y+60UeCAAmhkn7tUXzvZyRWXWR?=
 =?us-ascii?Q?iuxYWqTYxKsdt7MNHCsPillvpFBWI/ennqp7j/65lffHEd3L?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 84c63572-8fdd-4133-6c5a-08dedb173f6d
X-MS-Exchange-CrossTenant-AuthSource: DS0PR12MB7726.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jul 2026 04:30:02.9457
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2gloE7A8Tz12a3wn+Hpmq8W69x7A42zsovMDKCMjb5KgF86No/tGekGzaAG/ik0zKxBVKm81ofvEQvKY7TeCPg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB6780
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 1D8D340007
X-Stat-Signature: a68m15ek619tf7ictj7d8p95w949ksr5
X-HE-Tag: 1783312207-561840
X-HE-Meta: U2FsdGVkX1+nqhnt3xxZp/dAbcRYJVt47xQ/u9+FGxHmVyX/YMALfhX/tm1RnBPR73YrEw6gW2kNdJpP6Ue7BJdFLXSBLQz5zZSybrMcvBOLNTIp06D5UVyYl2hR04jFN5/KVbaarq3ecwKSynd5ULWJ+Q/q+2RWBEVk6oaBXzMGMYehM7Y7yBtpdysD0aakV2Y4sirzy1UomuJQ0EjcuRvMRiTmAXE/7jqss4/SWWUb7gEhdbtArEx/iSqFNUNtp0sXh8Y0FGQqIn/H5wDxGC9sHvkClq+HRaIpZuwsT26GYrdhHXHxA8Mr3EeDQ3ewwMQyrMn94DqOJtLYJ4UdPq7eNQEJhOgYRIAGW8vDBJ4DKj6M7sf4MpTo39G0Ye2pnzdPlyyMkKn4EldmHZMXah2bmr0UTci6XaHx9qn/4PwhiAoC4vghFSGqg3QlWaeYRCZqBEodtt4mlFxNz6DvpJzdVLmGkgLG/eDsGTtrT4tX4DQLRMoJom6depjHtj/1xSshpsOxX4eKSee2bycxfDFza/hJAyd6Ws0uZi4/NTklaC86GWY7qJ7FnwN6263v8MqV0smiLZoiUWBxKrllTXukmBOwkClxKisF3YGx56nYviuCVztM/X0ZYv1RSPoYHoHT89sO+Ox5F8Stx+TKgn8CnK0UclQpaK9A3O+WoHlUprTSoDhbU/QCj42abrIX7d4Jvi+L/hNe3X9Wpg4OY3W3Eath7ZwkJjUtiXv8NbU0hjwIZtaVcOb5Mo424xrckfK3viCMKHciuv530Xe8VlfY9sCzNbOqPIsOYiY8Ro5+J1qCgGjaAGsSLLjfVXpZ/XpojM75ocnaYVvAjrYcSJIBlBG2WBpDdeFosJvzch/0+dDHkMIQJrz9LP4B9+gv8ZOygB3LrcNA80Tp2QFDfBjQRHnixMA4sKqWeXrlhuA2LpOAErWaWqv6WSmHbdonaBqg1fDf5LqR5fXNMBm
 cmre4DxP
 OmS3GhzEuk7msk8pA59Gre8IVvuv7Sr0pfb+T0AdzMh5CzxKms141/kU47Upz9is5H5dI1xLJvSYgtLNZshhCzdf/JpZbJNImzzSWNjQAWFNSwBH5v+4WxQprXtDlSSz8tMDZ9FCp7QHzs5RSexAgGs6rqLwZfQ4UeesnPm4Vtf2cEccE466YjAjtCgkomkq9qX/23xE1Imooz/x36H6pzfAYc6nl4VgVJ/EH4uyh9wJC4lM9Jtyw704Cvz/MeHlmjsDCIYMDs16c/McMNLzmb2sgdXo5URnlyT0ns9Q0KfD9i4SkvjFUWm34px2/61GbMCNUaWKg0dUr4Fkw5mFmfJE90ZjuJy5jUzjtwmRCjedFX24gteOOA8lpeGjfpFTEfWyO/l6rNi/8pIo7AKmGNI0RaBeBVnWBdsE9NK2P9lTRUPnlqOmWFjQxftp+gkpjviM81NgErBGpxjI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026-06-30 at 09:30 +1000, Stanislav Kinsburskii <skinsburskii@gmail.com> wrote...
> Commit af69016dab96 ("lib: test_hmm: implement a device release method")
> moved the initial dmirror_allocate_chunk() call before cdev_device_add().
> That means the struct cdev has not been added yet, so cdev_add() has not
> initialized mdevice->cdevice.dev.
> 
> The coherent-device range selection uses the device minor to choose between
> spm_addr_dev0 and spm_addr_dev1. Reading MINOR(mdevice->cdevice.dev) before
> cdev_add() therefore always sees an uninitialized dev_t. As a result, both
> coherent devices select the same physical range, and adding the second
> device fails due to the overlapping dev_pagemap range.
> 
> Use mdevice->device.devt instead. It is initialized in
> dmirror_device_init() before dmirror_allocate_chunk() is called and is the
> same dev_t later passed to cdev_device_add().
> 
> Fixes: af69016dab96 ("lib: test_hmm: implement a device release method")
> Signed-off-by: Stanislav Kinsburskii <skinsburskii@gmail.com>
> ---
>  lib/test_hmm.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/lib/test_hmm.c b/lib/test_hmm.c
> index 9c59d1ceb5b5..c4adbf98fac7 100644
> --- a/lib/test_hmm.c
> +++ b/lib/test_hmm.c
> @@ -581,7 +581,7 @@ static int dmirror_allocate_chunk(struct dmirror_device *mdevice,
>  		devmem->pagemap.type = MEMORY_DEVICE_PRIVATE;
>  		break;
>  	case HMM_DMIRROR_MEMORY_DEVICE_COHERENT:
> -		devmem->pagemap.range.start = (MINOR(mdevice->cdevice.dev) - 2) ?
> +		devmem->pagemap.range.start = (MINOR(mdevice->device.devt) - 2) ?

Makes sense to me. As Andrew mentioned we should cc: stable, but I assume he
will add that so:

Reviewed-by: Alistair Popple <apopple@nvidia.com>

>  							spm_addr_dev0 :
>  							spm_addr_dev1;
>  		devmem->pagemap.range.end = devmem->pagemap.range.start +
> 
> 
> 

