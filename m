Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 54DE6EF8FF4
	for <linux-mm@archiver.kernel.org>; Wed,  4 Mar 2026 15:17:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 964036B008C; Wed,  4 Mar 2026 10:17:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 924556B0092; Wed,  4 Mar 2026 10:17:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 806956B0093; Wed,  4 Mar 2026 10:17:30 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 6B9666B008C
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 10:17:30 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 28BC91B847C
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 15:17:30 +0000 (UTC)
X-FDA: 84508734660.29.BC83C59
Received: from SJ2PR03CU001.outbound.protection.outlook.com (mail-westusazon11012019.outbound.protection.outlook.com [52.101.43.19])
	by imf06.hostedemail.com (Postfix) with ESMTP id 48E0D180018
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 15:17:27 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=YydbpbgB;
	spf=pass (imf06.hostedemail.com: domain of ziy@nvidia.com designates 52.101.43.19 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772637447;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hZMn/Gith91smII2Fzr4GImjMU8DCesfNrTsmrh/FjA=;
	b=cBjqGb5dzNSjYB1L188CVXvD+SYhmV2y6f1/y/a8Dn5sKXpEI58ZawA1ur9HYxWqjtPlSA
	+NKgeBoBELH4VyTOnLI2mbIOoJquC6pSDjainjpiW8csto6KKQkfFUL2FBLD6C0xqbGHhO
	k5+Sd6ATPthSPSHxmF9GFIwBz1IAdWA=
ARC-Authentication-Results: i=2;
	imf06.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=YydbpbgB;
	spf=pass (imf06.hostedemail.com: domain of ziy@nvidia.com designates 52.101.43.19 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1772637447; a=rsa-sha256;
	cv=pass;
	b=B6JoPXYo6I1IYWQUHBoi8f7qiW05bUjnnNRnJ6NFnht0I0H6yLKcrtPd27jCRk9ELTtJNk
	DtXBih8bQD28FZ0cokaTVsa+5EAHFugJF3qI5QnC9EfPrxE/LRTxF3IbeCBKGwoTq5R8u3
	BhMLuqH9keZZs22lwGIJ44H/Qqhr0qs=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=tKqee/NM+31wxVws4C4nYia45AmABXUSPvIytTXzDrGZr/awNgx5itUfTX5w33LvXQHyQeCTffbdfAtuC5GZbvvzBvpOiC6LC3StlmZbSNPVF1uiMAPtdaL16230fddpFNMbeCpRPWGuZxiTWu1hZhdNAUcXSnxlEO0Wz2LwqWioRGi9QlsZyypOdSN6TPMAg3S0vV7Ka1ganbkLNS2RWu33V5Z3Xt2+QL3bj85jlZ4mQdY6Lg36JJDRFoOfBu8Ub+theHQSXudzLEZbxWFkc1CTkU1K82i60Q02hsYardbWCfyq3f88bZ/p86hmpyyvA7KsauiAqMXQHvT+XlE++A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hZMn/Gith91smII2Fzr4GImjMU8DCesfNrTsmrh/FjA=;
 b=NtBgMxM/z8XZStg8IqbJ5hzMIZisBZxlbEe5PXqCVHo05TjX8Nq7zrZjosR9rBLuQT1PXc3xNZF03dAVNXY+cl6QkT78m00uFLmC04hagsvqoTgoId/C8LP1OIwI/bD0wdc2xqRRv+MXKJCnklTw7/QmtghK43P5VTFXZaamwgws9mGISbiTa72mpYJFJrOC3zOisaf/hUi3Rep/PNVEJyGyXdW7QlqjOkt8cLhvWL4Pk5DyhH2WiJyCCdbc2rJ8ce5W2f2vBzDwDRAbmb6lxb0lJhKi0Hm69JpKkM9ue+9PXaz04cfDCqDrtdTeKXXkxCx0ipsoFGsIwyaK6qSRdw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hZMn/Gith91smII2Fzr4GImjMU8DCesfNrTsmrh/FjA=;
 b=YydbpbgBacPzPyNK/e+eTzR6Q71y1Wq1imwi9uqjOeePA4mfEhxHQoNcHoNnTW4yVGXGIJHIiNel09ekCgwG5qcFSO++y98lj9jxL2+nX+C8U8i9OsPx1zsgn72J2OWGgUmo9eK0GQhQgAOi5vthb4hBqYLBoQz3bOiomHCSRB6F30YyY0IYuGJrygbBrzwQr2iy6uoLsVn8qVh9eYGSGAJhkgbPo2+1fDMRr6bUoOuropgpUWMXxvp7eqggIwKdfmfbSAM1kUi6hjp/COOf36Y6dCtV5RgL1uo/0rHfexLHIAdAcJlA4w0jes2wjKjL8qyd0ezko2BYAlmC7GjqJg==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 BN7PPFD3499E3E3.namprd12.prod.outlook.com (2603:10b6:40f:fc02::6e3) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9678.18; Wed, 4 Mar
 2026 15:17:23 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2%4]) with mapi id 15.20.9654.020; Wed, 4 Mar 2026
 15:17:22 +0000
From: Zi Yan <ziy@nvidia.com>
To: Usama Arif <usamaarif642@gmail.com>, Balbir Singh <balbirs@nvidia.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, npache@redhat.com,
 david@kernel.org, linux-mm@kvack.org, matthew.brost@intel.com,
 joshua.hahnjy@gmail.com, hannes@cmpxchg.org, rakie.kim@sk.com,
 byungchul@sk.com, gourry@gourry.net, ying.huang@linux.alibaba.com,
 apopple@nvidia.com, riel@surriel.com, shakeel.butt@linux.dev, kas@kernel.org,
 linux-kernel@vger.kernel.org, kernel-team@meta.com,
 Usama Arif <usama.arif@linux.dev>
Subject: Re: [PATCH] mm/migrate_device: fix folio refcount leak on
 folio_split_unmapped failure
Date: Wed, 04 Mar 2026 10:17:17 -0500
X-Mailer: MailMate (2.0r6290)
Message-ID: <E4B81DFE-5D45-40F2-9C90-EF386D89B06F@nvidia.com>
In-Reply-To: <20260304120132.3973445-1-usamaarif642@gmail.com>
References: <20260304120132.3973445-1-usamaarif642@gmail.com>
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: BYAPR06CA0063.namprd06.prod.outlook.com
 (2603:10b6:a03:14b::40) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|BN7PPFD3499E3E3:EE_
X-MS-Office365-Filtering-Correlation-Id: e06e1b9a-c092-4966-a8be-08de7a012293
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	Z+rfRtQR/bTUop5B2lgWpgJwqoGnYDjUOxRSVnBi3wYPGeuQYdukXGGkULGP5GBaQQgRquUhvZWUkJAUp8yIKGbyMSJ0rfy9pByS3UdcIeeYSqJtuFs66JiTe0wBwXNukUUtY/cqdxamD6UNGq/+XcQ24UiTSDrIYUbNXY6irAfFEI+tnLE81FifrVwM5JfnFlKpV0dN5EGgkYr+bZojFyJfiAAh5Z+34BTz4eP5BUqUC9avWR4deqIkVZuYBN1x6SMEnENY3nAyksXuXm1iqU0A1av2gmSl5jZSqisUWOAD19htQokR/I6e12K2DsT2hfWMgGhA5UW8Is2qs5KPrrGabl9IFWASG2/ZxrnOvtY+IRnutFw1r2bnCbmfrWbQ61YmQe6OyqiAYi1fn01dmptR9wRLWh3k1FwOIkMm4RUE8xFcNggfmSu2Ka+JLWk2oYn6Ssw/SKYUjKqdUDEsBtHZPqr/bPH8vo8H+PDakGcpoJ7Uc4hVRiO7KY412t8ZEEWLYHe0W0yupG66yLvRwnX8Tu4hEYa+JE82vulQ/tv7dLmAdD9JxIg2MJXpt+RJQtH2ttNr1WzcPr09P8JPyde2q7/qwwPPivxOieFaKC7RC1u5BcMfeWqdCPcoqO6Rq3lyvcxcGw95qWfzvigFzodzphoZUrBImxZWSxFFxpAQ+sah42xbAIxTzVq65zELu9zf5WekZZFsdPkOHhvboGG3vvINULyWnkd5dMY275k=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?li7AtYqQNEs0rsWdsmegzTpIGJMMdDTer4o7i8cjFuNbrQXShceQ8heAsW2E?=
 =?us-ascii?Q?hwb+29Ij7JvM1tZasRJR9daLKC2y1wkou1Fr0IwkVAFAJwIMqbQc0ivFWtsb?=
 =?us-ascii?Q?lokVTpAn0DDI8FiBsGpHRn+LQAzZSfZx8/Y5sujLUa2QSVW/0cXtRulyackQ?=
 =?us-ascii?Q?VCWje6t/qanuHezQQeAv0jpsNNSNNrJGQ0Ph1VMMX1rJ8xgwIEIQmjw6PXAg?=
 =?us-ascii?Q?8uWZEqO/62z41sVUWN8JSi2i9i3EOdoI+CXQ90v3EYNcscb3rWNt3SeSJ0IA?=
 =?us-ascii?Q?Ty3hwlGhdHj6wyRKOvtb7LVezPFFJh5ikin4ZM3nQFb6inR7ALDnkSMImBo7?=
 =?us-ascii?Q?bTOEY9pJoJxhreNZdbYqUAZdug2DXK8QB03twNET4Anb64qMqvawbLXnHncC?=
 =?us-ascii?Q?/5d4+efcv/oOGkDDrrPU4HMu9oyIJ0OWeeC7ywPiHRQ2HOniAoMDhPcQXFBs?=
 =?us-ascii?Q?zvoj121+j7npeAjIS7HAYLq10zB7+UEtWhmbE2m7KpyLpcpwSUpuOml8Bd/A?=
 =?us-ascii?Q?L7jJ2laXga1QZxBNroNmZyy7aRVjJNAMikUQECsx3AcMcz7bgBsJsUSCZWrL?=
 =?us-ascii?Q?8opDF/NlFQO8RIKA95Nm+XkMom02+GxYs6JMLki5h2L/oXjBch3rQKjhWrnl?=
 =?us-ascii?Q?4AQJ5jK+8wGcqYy63P6zMgk74XLxoJFjcYMj6b4x5MC4Yrc8GnEKvoukGliR?=
 =?us-ascii?Q?Adpv9DP5kdX8jZWhvTLnZe0yaeGrt3q0M+tuFj294VFM+ECaUfs6avV4SWCf?=
 =?us-ascii?Q?weXMSlXPktpWTIwiKK65SPwovVXhLHwbUmxJ7Uf9a/qpWR6507TRAJyIVI6/?=
 =?us-ascii?Q?k1VYwNTOZl7ExnmQf3dubaYyq3AJvQO3Z/lGbxONstV7ukYE859+rcnw0yzN?=
 =?us-ascii?Q?Fx7ggmDQHlhgSQDoedzryTnWhHunS5aHZFnIIh3V521Ffgahi1+jkqys7q5I?=
 =?us-ascii?Q?gfE/BiHEUhGW+gIztY+hdsFw+IubMf4PYlXeMnjzJ3CCx2CtPT8Qr3heZeUE?=
 =?us-ascii?Q?D16ymAl0aPwSuJrFmtG52K7sET3Jqz+KmBazqijJYsWie2ykj/zsh8rAphPR?=
 =?us-ascii?Q?cDOubS/NQDSDmEz/8XW3p7010ZuIu4r/IuFuBPFNJ5oM6Tu6HmsHoMuzdz0J?=
 =?us-ascii?Q?00lZEIDj/MFHN0HhAWSVvbaVoczNGNJz00TcobV1e9Y+PYMi7401EXA6pKKN?=
 =?us-ascii?Q?jBdiuN/2I3N7sYahxtQka7xodwOOnlIQPajH0t4E5wESOW4gSzMcZ5tl3XjJ?=
 =?us-ascii?Q?lNCJSXFvdOk2F4aeTBuNJC3AixtmC4XoyPv7MzWnasv13ffGm4kx12TLzw/w?=
 =?us-ascii?Q?VKY3irnF0mzTRdTghgyoOF2QR/WcCMgZT7LY6fsazTxCwE0m3jWYODa/pTVf?=
 =?us-ascii?Q?jJATye6nUjIKNXw877tfvZM7UkIW7UdlHGXUjEaFPzzEJDvM3E75D2kXaCfs?=
 =?us-ascii?Q?04ZQLFVrkQ39g1rdVcskYEp9IJmj5LJEzDtJHOZkwnQ6lDnYebH9Ju0AxXnk?=
 =?us-ascii?Q?8elN3OX+W5Q/wVt2QX22AaGAy2Hnd1+iKsZw47q5+TBAbo4eL2BwXudwnvV1?=
 =?us-ascii?Q?GYyltRh8jBFrd5ipZSw1QQmK2F2WN5sxVGEbHHS49SlDXHiw7DpF4ttNenR1?=
 =?us-ascii?Q?KCHH7VDj9J/fubGa2tySt591eygHLyn3ypcQsJYksEF16LEP//oLEQYNF+Y1?=
 =?us-ascii?Q?LkKl6O/QtrNFQGatV+jWY8TnkOdT+X/4GfdKsXwBKUWKub8fO7hHCurOMRLY?=
 =?us-ascii?Q?fg1aCeOUSQ=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e06e1b9a-c092-4966-a8be-08de7a012293
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Mar 2026 15:17:22.8574
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6TVAMdBAmQQqa1A8D9YCrF///QPR/FBVJb8bjWvCegRNc7ieysN0hejnmbvj9Z8K
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN7PPFD3499E3E3
X-Rspamd-Queue-Id: 48E0D180018
X-Stat-Signature: 9s8scqo3yd1fyda5wqsu9b55mgggo3j8
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1772637447-193754
X-HE-Meta: U2FsdGVkX180ag4c/1j5h8QzA8hZx40aSZjVCWf3xAEPd0JRNanv6Hqbp2kIydbe3fTjv4qed7AMumUV8iPyf1hEy/JHt7ORWFqMEN9zqyDIm4qcL5cpjlCSgsW5Gm5sm0pVR5aYgcbV6RPBdfclFxcjLYkNyLa3OofHpzQScuvKyHvJxMdhDQOnLKFLy6GvRoAwnp95dqSWT5eO8MCkNu5nT67ukuyQ1QSxaJ14EH2WXgdrOGDE0sj+jWcur4f7FaZt1CXNWFmzvdLk9K73Npr0Qqsizkz1xilDTWT5W94gmswb58rL0vtroF36WrG642x3s428wXMrPanzlOGtyoV0roWm6PfoVS8ggNg3Wgtneyo38WyLpoH3wGwq1RJbV/ReAgo9cOWY2nB8oD0NL/eV+QOmE1ucZHe8AuRysVU9s6dxj7KwtkiRkRRxjv+ABskuGWlo+NtwKoklYIdsim3f75PohbOOBjUTuje6AK+rytbxZiqUqGBEXbCeNevS9TgQzTgDl91FEdlodXfvy3TKrBneVmsStccEbscN1w8fY+3HyTVmDOaaZUZ6cTh0BKlTCZxkdP6qbC6w3ENReO4StcFwEc7wLZQBFlGhpWou7PPCvBb+HLI2ufthIy4S59dOh630IzU/7w++vDKafBHqfhG1nn05L4qQpDNsdh0OLqOAt/Q3c8kKL/JOKd8eXmJDff08YsG29xZLl2G1Z3mVLLhBoQYQUNqpuRMIa44HYEPfQqti9CqRkean/awRUWbeLoS6b8GR4t4NHBOyqzMhLwfMJE4WGWXNSAvB7r0CmNYujCgwU4VPGXs+/FpbBWsLETAB/v4TuyWd3ONDZuhncKanDNyGXcLZCRn6+Hc0ygPuuETtpb9OpE01wte5PRUTz8gH0N+r1GJDYO4fUrw1rvNyZBLcRMEsK0L268xviLfr8O3hz+cOV5I7Vadg6iwkTzvN2VMEYc5B58i
 1s402FIA
 ovCqIe4EeQosYKMzdpWVhUYrIPVPNXny/R9Xc4vXTlt809H4tjjbh1GLCmmNiG36cCBlPQRE45whqAWbkbqQ9F2fSs467+XHlxB0Trnlb22CZ8DCwpmqAbt/A6pSMPYgtLdJd2qj4vo9LJy20PYR92vDHyA3Rw0kbzWnX64ktp/YTb+pq0CPx9rWSQI3TppbCW5WBaSM/qwwLhb1MS1dPqp2rzLB0U98NCVKxAoNWFqJWqFOJEfIjz5rfWf+OhdBnMOMiCt3MFYpER1xwTMoIgDvNEH9Oyt5YGUJEA727/bGqBPAr3kDpZGYM9fcPTwf24urKvgih/TCDtq8vQVu5lS9vffDvw/fBznJvqXXbcYfBxZI5wOu0kmajmzYyRsAIJlVAFaBPLYgTVI/YcdXTZjqW1u+hqc5rDp+t5d3bB7DyfnNW0NKTb/uy11iLqYTCrvcWz5rFj7MfBgudi/x5xk3DjVIc4M/6c/MEjCBDH4pNXZ9s3qSj6TbPopROm+I5OeklCT6e6st9gZHgeNc5+TtZkFITcMSbOTpP/WFWwo7ytQc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4 Mar 2026, at 7:01, Usama Arif wrote:

> From: Usama Arif <usama.arif@linux.dev>
>
> migrate_vma_split_unmapped_folio() takes an extra reference via
> folio_get() before calling folio_split_unmapped().  On success, the
> split consumes this reference: __folio_freeze_and_split_unmapped()
> expects the +1 in its folio_ref_freeze() check, and distributes it
> across the resulting sub-folios via folio_ref_unfreeze(...+1), which
> are later balanced by folio_put() calls in __migrate_device_finalize().=

>
> If folio_split_unmapped() fails (e.g., unexpected pinning returns
> -EAGAIN), the function returns without calling folio_put().  The extra
> reference is never released.
>
> Add the missing folio_put() on the error path.
>
> Fixes: 4265d67e405a4 ("mm/migrate_device: add THP splitting during migr=
ation")
> Closes: https://lore.kernel.org/all/CAA1CXcDyqPPwf_-W7B+PFQtL8HdoJGCEqV=
sVxq7DhOUB=3DL4PQA@mail.gmail.com/
> Reported-by: Nico Pache <npache@redhat.com>
> Signed-off-by: Usama Arif <usama.arif@linux.dev>
> ---
>  mm/migrate_device.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
>
> diff --git a/mm/migrate_device.c b/mm/migrate_device.c
> index 0a8b31939640f..351ecd9065d13 100644
> --- a/mm/migrate_device.c
> +++ b/mm/migrate_device.c
> @@ -917,8 +917,10 @@ static int migrate_vma_split_unmapped_folio(struct=
 migrate_vma *migrate,
>  	folio_get(folio);
>  	split_huge_pmd_address(migrate->vma, addr, true);
>  	ret =3D folio_split_unmapped(folio, 0);
> -	if (ret)
> +	if (ret) {
> +		folio_put(folio);
>  		return ret;
> +	}
>  	migrate->src[idx] &=3D ~MIGRATE_PFN_COMPOUND;
>  	flags =3D migrate->src[idx] & ((1UL << MIGRATE_PFN_SHIFT) - 1);
>  	pfn =3D migrate->src[idx] >> MIGRATE_PFN_SHIFT;
> -- =

> 2.47.3

Add Balbir, who wrote the code, to comment on this.

Best Regards,
Yan, Zi

