Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 30BF6CD6E57
	for <linux-mm@archiver.kernel.org>; Wed,  3 Jun 2026 14:57:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 62E986B009B; Wed,  3 Jun 2026 10:57:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 606C46B009D; Wed,  3 Jun 2026 10:57:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4F5A56B009E; Wed,  3 Jun 2026 10:57:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 405246B009B
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 10:57:31 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 001391C198C
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 14:57:30 +0000 (UTC)
X-FDA: 84838905060.26.526AF24
Received: from DU2PR03CU002.outbound.protection.outlook.com (mail-northeuropeazon11021105.outbound.protection.outlook.com [52.101.65.105])
	by imf12.hostedemail.com (Postfix) with ESMTP id 028F14000F
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 14:57:27 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=codasip.com header.s=selector1 header.b=zBmB00Uc;
	spf=pass (imf12.hostedemail.com: domain of christian.gellermann@codasip.com designates 52.101.65.105 as permitted sender) smtp.mailfrom=christian.gellermann@codasip.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=quarantine) header.from=codasip.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1780498648;
	b=D0HaA5BkKZ5OuJaErttnpsx10PpR7Q5pVfQg0pEy5AaD6EIMpreNqMSuCbU+lKCeAMFpyd
	6UI6tnbkPJK/onFYYW0Jf3FH76sHcdv53CkyKKlaYRq8qwSl9+pBxOEzCmEaDUJudaTtGa
	yu8R4bOQa+It5Bf03x5f2wFnrqYM0e8=
ARC-Authentication-Results: i=2;
	imf12.hostedemail.com;
	dkim=pass header.d=codasip.com header.s=selector1 header.b=zBmB00Uc;
	spf=pass (imf12.hostedemail.com: domain of christian.gellermann@codasip.com designates 52.101.65.105 as permitted sender) smtp.mailfrom=christian.gellermann@codasip.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=quarantine) header.from=codasip.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780498648;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=I82769B7x7fzuvm87oWOppc6HIdteTppUDVegIxxLVA=;
	b=PErv0DWw4IAEh1NjH/weegR42G1+bc6rtgzksUYwtSm+mS0gkAtu3K2vswYZLq8LO2h/f3
	gC5aQsgeG8tx0EMrQH7tF8hB0ZU1hbsRb0CV30IPWeBtInJogc16yHofaRTX4z3VVZ1y/u
	/NGDf8O1GmlMMo61mIOsoXjB0H1jbpc=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=GZ2wpBZu6HysJLehwyMnzBqsElG80rIV2P86VCX7uzcNMjEN29wfrF8U/FNb1LhKCdpY4ncc6tx7pCIyPVkzhAJXyUZ0gLw0LtANW5p/ArxuKKZIXsz8YPWLsoWC1sTwjKNxKKKbDLaBCD8yoTUzQWSkN4PJExfdOhSEDSNDPXfQYlyrsaBbYompn9qjAdeG/2Mbs5iivQuuRdUJMeMTziLaGPYKYRCsu/jcCcUIG9GPKCelmkve0fBe1xP0axbixX5vtA5IS2weT0UUfGad1V40Bw2UzzQogGeNC1fi8RPY/F+vl0xvJt+31Ep4g/bAlEpz7Nl3LxxHE2wu/G1tTQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=I82769B7x7fzuvm87oWOppc6HIdteTppUDVegIxxLVA=;
 b=Q4k0jI3nw3vk+IBo47bGsvhJ3+p2dZvemCx7LFfmVfAqrisUUpjUOhg3XCjUlzJH7lbQYb/pMPECUmxa0//itzxNsWHZsX8Ah0L2FN8wPZWrDjrb7bdo6t2+pdlE2ZDRV3hZZi8dpfTkn+GS523EP+ZorGwHsTI5eTUe+0P0iE3emuS/7TtSKN9ocjByL8kHnBaJIgLlyMqnILI+oXZYyHMLe0foEKkUD6sLos8Vu1fPb9UT7l28A7TUuNKdHUwISwVuCy2CP1q29NnjXhy1Ni7i4m5djhBCKi8YeJYlwBm+UGtFDpg3Aac9mkJABi6RoFncBgE3fYMskPRz+CRdyQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=codasip.com; dmarc=pass action=none header.from=codasip.com;
 dkim=pass header.d=codasip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=codasip.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=I82769B7x7fzuvm87oWOppc6HIdteTppUDVegIxxLVA=;
 b=zBmB00UcfRnGAmwb5KqT1lb2xjcVmDjpxSieaeGswvLIMh3/CA1u1wvJJnX6Wmm4/9CS2ypxqj6iFLHVz3hHjIS0gjTXjhqLOJrXqNDcMrCBjL8yzo/9zM1OL0uSxdZsQwuVcs++gH92ZhrL5d+TJReoQ6dCmrGBd5yRUVY3MzTyumG+e2OGlzbE+We5cwBKQdkav/GcXSbSANda+ySmGTiZxy0Zvvq8O+/W9zIoK0+hAULuH0QT0pQPwf2MlNOztp9NONRPbt1+5pRogfe6kcNZUg9RNqCqGvLG1OmKE0fxOHc843Z2xvZWrG5C14QeujvrE/O6jr5SXcbV3zWDmQ==
Received: from AM7P192MB0787.EURP192.PROD.OUTLOOK.COM (2603:10a6:20b:17c::14)
 by GV1P192MB1665.EURP192.PROD.OUTLOOK.COM (2603:10a6:150:5d::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.92.7; Wed, 3 Jun 2026
 14:57:18 +0000
Received: from AM7P192MB0787.EURP192.PROD.OUTLOOK.COM
 ([fe80::c1d1:f20d:9fb5:72d3]) by AM7P192MB0787.EURP192.PROD.OUTLOOK.COM
 ([fe80::c1d1:f20d:9fb5:72d3%6]) with mapi id 15.21.0071.011; Wed, 3 Jun 2026
 14:57:18 +0000
From: Chris Gellermann <christian.gellermann@codasip.com>
To: ljs@kernel.org
Cc: akpm@linux-foundation.org,
	brauner@kernel.org,
	christian.gellermann@codasip.com,
	david@kernel.org,
	liam@infradead.org,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org,
	mhocko@suse.com,
	rppt@kernel.org,
	shuah@kernel.org,
	stable@vger.kernel.org,
	surenb@google.com,
	vbabka@kernel.org
Subject: Re: Re: [PATCH v2 1/2] selftests/clone3: Fix wild pointer access of getline due to missing init
Date: Wed,  3 Jun 2026 16:57:15 +0200
Message-ID: <20260603145715.1376288-1-christian.gellermann@codasip.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <aiAYQVaVGRLfmpAK@lucifer>
References: <aiAYQVaVGRLfmpAK@lucifer>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI6PEPF000001F9.AUTP296.PROD.OUTLOOK.COM
 (2603:10a6:808:1::907) To AM7P192MB0787.EURP192.PROD.OUTLOOK.COM
 (2603:10a6:20b:17c::14)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM7P192MB0787:EE_|GV1P192MB1665:EE_
X-MS-Office365-Filtering-Correlation-Id: 8879eaf1-c719-4a9a-152b-08dec180684a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|7416014|366016|56012099006|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	WTCtaWJ1e4pLJ9xMAo7J1cknQ+L53J4BnYZkOVcWBPrP61RmJSzwNOxi00A9USyeCW7Er2Exl8xPzPTaIxbWZNgR8jxNrxkE1RchkMbcKhxvGjTKCm/xetG/I4KzXHNPSWpLdPepORNu1VR53gTKdzi3PBnWpPWlcq8FUCWYPZXvAWj65kKORO4PMaKmU5c7Lc+UApCP5FfA2aBqcekPpgm7XZGjPnHuGt7SixjW7HVwPQ2PgurK1CkarRlgBUNZaH5jzpYAITjKDti1sbBtv5skQjnSJF56AOjlQN8p+/z3XNxQSeoXBiHdIcIuVy1b9UDN4JH6r72n+vRjNm1ud92sZwzEm+KGhE69VMLTRYxbXePinRL8AHcAFM/vbpBBbz24ZQYm4Ed1jMuB6mAGPsP196O/ZYREMYYG5solmsmG20Iv1nz34WvvbL9z2tVylfHnaxf8PHqTbZ2VrCqta5KKPl9zNq8cEKX+nlfm46gxE/JSmG/+rnct5hDuYbrpXkWnpaJzwtjtkXIeRBqcNIsAPeuTZARlLv/bs2X3pFbUdyqSaao1dCh7hApi2Ym8i9LqKPCkM1S/TYuTPu+Nq8/8cGsAHHnMmq/YRNa6WJlVUc9ZufGvv3p5ZionH7t1GCbqjEOm8vQFwSLgKkIe6kk10aGQgHF/hWJRG1X4+J5VpFu946XlTmwoDWnBogI6
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM7P192MB0787.EURP192.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016)(56012099006)(18002099003)(22082099003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?N2nh7nZRPUb80eV/n80a3NMdjMJ6fnqVeV9gc2RbcQ2jyT9LwMCFrpKPS8Gx?=
 =?us-ascii?Q?WcaWYo9LfodctFvKjj7LlF17hc1WSTbDAAK2ySv0/CG8ruH+4Zbzs1ySPTHK?=
 =?us-ascii?Q?Twa/4UkRgj11sDyoBLBGvR68CRxRcGARb4Hnr2kARucGR+whousoc4wo+iFN?=
 =?us-ascii?Q?6DFS289nO1QD+4saOcF1KgjHsawmAQx4U8rZ/uwjf3k/EMbvRPwyu12klu//?=
 =?us-ascii?Q?LbN/5T2oGVKygq6rP7fi5+Xwi6s7hdupZvGQ9jKUuLZMBmYtwAEZktgoQrfu?=
 =?us-ascii?Q?JIN2fySvZxJ1Fcn7IppI3rCiTxQAW7k21Rk6CBcOdfRXDm6QFu7UJXzzJs8O?=
 =?us-ascii?Q?Rn7L/d4Dop9q1JBrbcRCZyCr7fc16pO0fgXfX4BIpAdqEP6keC/kNzspeaRF?=
 =?us-ascii?Q?+nrIzB2c2i2JVQkmDS4ecmlo5z1vdKMOb6rRARt2CR9tpcU933A/jXt/YaMk?=
 =?us-ascii?Q?90xippkCNao1/+1JklsU90NIo3hTZOhKl0bedpJuNrIc2Ml1tb/cgbmY2dhk?=
 =?us-ascii?Q?ZaSLZM/tYdLp/DIc06nNfYUfNB8JSYdNpY8U/a6FMAcmLku8G+4ytKytjMxk?=
 =?us-ascii?Q?ETB3RrFVX5UKDJvM15tufdAOmv5cnmWgLo91VD5e83Xxmy2AwW6d5R7JG0i9?=
 =?us-ascii?Q?JD4mH0MTwjeXLZ/1ck2wMur+JeMBc5jMVL5Sus6n1FfI5/WzcbvZRpzhwoxy?=
 =?us-ascii?Q?MLs9XUB4+UKOduA7KPpX8YjO+FSVirQPJ/VfgQGOSHm/Cj3ueU5lctV3h4dV?=
 =?us-ascii?Q?ro3LbIgcmOqdcas4VS+FL5DMRxHHznqGh7zF6utMfe56Nt34KCp0TFbVCUFc?=
 =?us-ascii?Q?xoW6D0+q8HUe1L31/d8N703P0ph+jblaP4ZnPdX5ncqwkIa3ND950NaW9ZRg?=
 =?us-ascii?Q?toWmuTNalRA6vgURK4P/KRpsBWNKKNOiNQpnuERFuHHSgfLi1H2hkVJO8ro5?=
 =?us-ascii?Q?b4SmMi3I55hnrZptCSUdqdKiGm5XpkmGUQ910Z+kNs2lKMe1Z5t0SzJwBHOA?=
 =?us-ascii?Q?ClGkg9ubsYuOxf1SE1pPsUQDEjUqGU36Xa+uFFO/+a01V/6weCTBAO8lAohn?=
 =?us-ascii?Q?1IyWsz0DVzSNA8GF1oyx0lduD7FS+vwPzCw0KXBaoCCFj+JB+0lzv+NFYx34?=
 =?us-ascii?Q?nx4WTBK4P2+s6Zd1SkjBMFBdfnb6W4uDuX9sVLNwn4NVpK4JAb5AE0Y3BwzT?=
 =?us-ascii?Q?FgyI5/hOjQ7sZKuxCjEs5PUrsOypOm8KA56i4YHs70GYbk2L+kSqGaeCMwze?=
 =?us-ascii?Q?HUfh/uT5poXjpgblMiyhtawrW0D1qcpxB+aDwm82klWm1Iq87P+TnclAMcZs?=
 =?us-ascii?Q?UZ913Qd+uflv9p1UfJcPLCZ0y6+2PEcOheLVqOVKfD7e5dINrbdrD3Bd9dRd?=
 =?us-ascii?Q?+xfN/AdsCeiP4mnYWjtY54PkA6J+VQfqk5MT6zVfRTPg55hO3YXETUQ/2RTw?=
 =?us-ascii?Q?qURvSPJuSXsNTZIdK2MJqrXTl/m/Jz+Xp0AS7Vp88IK6G/fODY22ARjcDgJa?=
 =?us-ascii?Q?R2XmLo4RaPoAxPzAMvK4xggxUvT4LhKzL/+4Vy+zzY/BskLWkxMsZtMpwahV?=
 =?us-ascii?Q?xbBN5INy8SlDEoS8qSfAYLKQBwcdTDNyHwBwuH0zyiw8rIvhFSmXugdq4ejv?=
 =?us-ascii?Q?/Cth9u5TPGHKDkzuo7ppw60R3EEY3w0A9EIcBaRhrnK4rBPwRaJyDF5PXS22?=
 =?us-ascii?Q?/cFVaKwCYwqocPjNA9zbsv5qK/E0bwEmgMEdvo2niVDQloonVIqWMyNY3MgT?=
 =?us-ascii?Q?5rB5czBZqQmYgAxVdYHlryTvJstP4HM1FYNl0F131Z2aa+Pd1HsN?=
X-OriginatorOrg: codasip.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8879eaf1-c719-4a9a-152b-08dec180684a
X-MS-Exchange-CrossTenant-AuthSource: AM7P192MB0787.EURP192.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Jun 2026 14:57:18.4496
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 0d91ffef-bb81-4cbd-b9b8-552583685f20
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Jx4Zt+wNnAYcxMBd/9prEUijl/MC7IiRBS+r0AzGegEbRvrGWuQHIg2rZGYc3lsrn6i4VRHH8HiYr0J5MtTZDUDHMgajkGfTsYkRfKrXwzUEJFtnkwQvKsHD7iT66nz+
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GV1P192MB1665
X-Rspamd-Queue-Id: 028F14000F
X-Stat-Signature: xfms1hn46fbbph7tfbnuxp435zw3fzsp
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1780498647-936401
X-HE-Meta: U2FsdGVkX1+MBNLf0tpg8aHDdPxLWVEljEe+dkWZuPtAgwtV1TKx0UD7rPuxU2a7eQ26+fqNubc1P77SO0SikgS0F6S5uR6KUSdXNJ2ZNbGkFVbUb/GAQTtJ1CRok8OxIVbKmEXqkbEDG8Cw8E0Ppc+Jep774/NGuYHGxnjVxTrHQ70ynWIoDVIJGDiEG9fPnrJpvVvQvwAad/r2vqypmiOwd6KoPeeAR+qP/KYel5TRSROnpVuHrOygH/E6bQe9NTX1uEZOYGgORUKbgQIt2iHrTIk5Q/Tuathd4iTcgdi/VHfVpiPwU2w0ogmik0JjhVatbnHTUJ9YbD6zzqHKKRsfZK+6vwet4c6sI6pw+yhVHlliQVElgUYSvXxHNEAEfpvXOUmTNrXO3lTfQvXH+CWpH2Ggr5p6TpiBOe/xKQ2zLppqqftQYGswiJddjCS21xpXQYU6WjDuqtC2Suhi1moKESzEKBIEf1MENBofzW5DxIB8gEsglbsljDrv4N8jIz904+vASuyAkRVcgjp2fVUFi1BXsxbxH+dFvNyo7taO6f6daRhb4H0M3TJbWoDaEBCERGHuWM2qtwVMeT/3Pe6Kvkt7JXlZ/LCAtiiRQP5dMZ/MR8El0NnFo6xqnxHn9ZR3s2mXeeUW/B+TizH3jBafNQ9X8pgUuZzJkHL62yxIDtnnj95Pn939vDMFCUCaeKyn/v5BquDgnNuwTmdZ1++4sXB2gBZg32cr8Ox6p7+NEJ83FriQYwQLq+mZfZzQ7wtiIV+P27pTOuClFi7WyIrzOM4XkELIgSuMnl4RXN5jLN6kOGUo8A1+BD/6nlyoPsgPvTFhAmy3pP8D3z/5TTS2CJQyiel5+w102Pcq/MZyQYecpsFlNHqB8zkZ2O2XHyzg8aYZ5Yq0OjS7qjA822VCf151R9Gt+9kpuquQP6ehO9qoJmPihPVHKR9SRGaPFVsN3HZGRcsOiZUW070
 Yuu/ZUNi
 ySzYYDZ9r4KxK0RmvpCI5854NJwTQLoL8IFKuFYeKHmQeN5fxUtfLHxTPJzXo6T8ZgcEbtmb2vdnC0CoKeQ5QBvQebTtJMuwLosGVrmFNgCaGz5UwZXi/6KoRBfwz8BPgUXpS+ML/az8/zJslHEz5IvdU2szxd7QQRhZj5FIIdnIU+HiLE5FcX969/VHWmMYVRnu6ASkK8dG5B94tzfdOPqF34CLZkoc4QVz4Tl5YIaV8RqnspR75nbB9XZi/0wpl22oC6zmxjGGVXqhW5bF+cR5Z56fBvxeDY5ZxXQSq8xWaQFhoy/wSj8IyeTYFH8K/fSTCxIn3IKDNnwBbgYgshY+MXbuRRpTicn1Gw5OxCAj1LcZ7QLNhwmwKbF/w6O+ni/q2gq5myD5x/l/BNZ5bv8m+uPZyrcPWbJf/kOnoIJ3uvg4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Sorry about the mess. It's my first time upstreaming something.

> Just for future, please send series independent of each other not in reply to
> other series, and if there's more than 1 patch, send a cover letter and have all
> the patches reply to that!

Sure, will do that.

Best,
Chris

