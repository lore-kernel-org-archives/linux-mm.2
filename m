Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 54A4CCD5BD5
	for <linux-mm@archiver.kernel.org>; Thu, 28 May 2026 19:03:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3B4426B0088; Thu, 28 May 2026 15:03:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 38B676B008A; Thu, 28 May 2026 15:03:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 27AE86B008C; Thu, 28 May 2026 15:03:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 18B316B0088
	for <linux-mm@kvack.org>; Thu, 28 May 2026 15:03:50 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id D5216140909
	for <linux-mm@kvack.org>; Thu, 28 May 2026 19:03:49 +0000 (UTC)
X-FDA: 84817752978.17.31758B6
Received: from DM1PR04CU001.outbound.protection.outlook.com (mail-centralusazon11010045.outbound.protection.outlook.com [52.101.61.45])
	by imf27.hostedemail.com (Postfix) with ESMTP id 2914A40008
	for <linux-mm@kvack.org>; Thu, 28 May 2026 19:03:46 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=aiW7EDvU;
	spf=pass (imf27.hostedemail.com: domain of ynorov@nvidia.com designates 52.101.61.45 as permitted sender) smtp.mailfrom=ynorov@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779995027;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=tOS5eSH2FpTBHK47e/QJTZ0HYZ1p0XViboVUySo4mZc=;
	b=RUF52HXBGtqW3C694gEMpdHqSYUYemrTceshyDNp70w6dG35dRUGad81HFAUmXwIsL/czc
	DOT4JPKGmEr5yuaNgXgw5ZBeghLYPZSysgzh3aHMb3qEcZL0jzkqmlqatk1g44HE/G9Roe
	PP6yVsjOuYRc/BgI2PR37jz5qJCIiQ8=
ARC-Authentication-Results: i=2;
	imf27.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=aiW7EDvU;
	spf=pass (imf27.hostedemail.com: domain of ynorov@nvidia.com designates 52.101.61.45 as permitted sender) smtp.mailfrom=ynorov@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1779995027; a=rsa-sha256;
	cv=pass;
	b=13MKyNO2WX8HEhfmHONJ8SwEWqs/wMvF5fKORM5O551s4v6ymkqpHJdg7tx8XR2jNjAbwG
	Ia1PY/C6oEAK5uHJ2W7Pj33x/FgFm/BU2O5SizWtegRyWECyvmtIdBAftgQjIWv9yevPTC
	1sLzuPUPLJm/JuhMq9APYJtvnCW5SL0=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=gZnv/sbdi0dymBDBy61gjfRWmzRDTMBxGMSI2NiTu9FOsqRBQX1OBYXQGFgc97ez/y3IZVojb41Z72UhKq5tIGXD4/3YtrR7wPgwdKVkJqDZbW5IH8tPO4oAL/C7Cvs8zEreaBTPbmozvdd0HGHeNWB1WhOzjB74ysOAPbyzl8XJWq19DsHXKJoPfMFaaySIbZcFanlwoyAarm60ZlIK+8AUXn++X4nhbxzXtZOIzWz+9oY0J7kB1Bld/Tigbg/bEd7LmzPhyI3kMtvN97+/7RQqFnz21hmecvmHUm7Ou+b6ZD2EENBSxE1pwJ7ciugII1YprNnjjSvCKzJOwcbR0A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tOS5eSH2FpTBHK47e/QJTZ0HYZ1p0XViboVUySo4mZc=;
 b=pXDmIT64gX9QqTsWkGDPUvOo7UWTIQ7LgelTZcto3e3w8bvUBmpDIn1crQCgOkWfZ2RnhBvn5R+mfGWlXhZWXqBmVN5FS6uOp1rULd/PW1zmlwKpsqw4XrDt6LO7YzzeH7bgclszx/W695C27IWdCWtO1/LDJmFFn+rXpkV1g/XPMDzctSarKIEKOep3lnMp+ajaq8o3gRjXsX2Ovg7LWc+ux5IF97kn5By6+YZEE4rIvBHB8wd9U1Q8EtAfZ6cQ6QyflCKkXt1EYIzi8D+MwqBPbOquX3ghrW9disQFD1dzdqVRLLQ2NourTr7v5/BLJSEIPscBgrutlhJha26snw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tOS5eSH2FpTBHK47e/QJTZ0HYZ1p0XViboVUySo4mZc=;
 b=aiW7EDvUVUoEl0VMCgcoKWPfF+WiE6IJFAWRfaQArnRmrIH//OBHDk8gzl42ZBz86XY9IkuEipogwlGjPB5yRfY7r2oAum10Q8vhnUoCjycZzQ3rBL7Cp82Nq0apz4tTKkxtPB7v7d5PKmrzUeW0QlgQ5pRS7hlRE7k8En1CvC8Jh3DdrX2rLIMnNyQpO9cdDo1WGLz/Nyl16s3U2U+yGM+TReID9xo2FJ5cloGezGNOEtu1DWVKlKH6z19fnK3rqc3cKn0li9waF0/DLJBCXUWWSwoTb3evpcusymoWInakHTnz2J2A68QnueDEDliGGV0ujv+p77f4BpB+EuKLFw==
Received: from LV3PR12MB9356.namprd12.prod.outlook.com (2603:10b6:408:20c::21)
 by IA1PR12MB6042.namprd12.prod.outlook.com (2603:10b6:208:3d6::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.71.12; Thu, 28 May
 2026 19:03:42 +0000
Received: from LV3PR12MB9356.namprd12.prod.outlook.com
 ([fe80::1c36:31b4:c420:6286]) by LV3PR12MB9356.namprd12.prod.outlook.com
 ([fe80::1c36:31b4:c420:6286%5]) with mapi id 15.21.0071.011; Thu, 28 May 2026
 19:03:41 +0000
From: Yury Norov <ynorov@nvidia.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Zi Yan <ziy@nvidia.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Joshua Hahn <joshua.hahnjy@gmail.com>,
	Rakie Kim <rakie.kim@sk.com>,
	Byungchul Park <byungchul@sk.com>,
	Gregory Price <gourry@gourry.net>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	Alistair Popple <apopple@nvidia.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Cc: Yury Norov <ynorov@nvidia.com>,
	Farhad Alemi <farhad.alemi@berkeley.edu>,
	Waiman Long <longman@redhat.com>,
	Rasmus Villemoes <linux@rasmusvillemoes.dk>,
	cgroups@vger.kernel.org
Subject: [PATCH] mm: don't allow empty relative nodemask in mpol_relative_nodemask()
Date: Thu, 28 May 2026 15:03:37 -0400
Message-ID: <20260528190337.878027-1-ynorov@nvidia.com>
X-Mailer: git-send-email 2.51.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR05CA0001.namprd05.prod.outlook.com
 (2603:10b6:a03:33b::6) To LV3PR12MB9356.namprd12.prod.outlook.com
 (2603:10b6:408:20c::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV3PR12MB9356:EE_|IA1PR12MB6042:EE_
X-MS-Office365-Filtering-Correlation-Id: 25da8389-a36b-4840-67f5-08debcebd539
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|10070799003|7416014|376014|1800799024|56012099006|11063799006|6133799003|18002099003|921020;
X-Microsoft-Antispam-Message-Info:
	3KgGPN73WIqvP8fq5U//WLoQWu7iC5mC8bRx1+tY020SKYsGrvAJPzonjxqsEzu/WeOTHmz7Ys0oQ42DYOzrqMMRVLWpxsBieH644raWR9H4vgTKcxbZQwYdx83q+CNwar+ZSRQ6vKA7axjnAymmxoxdxZ2MGjFaTBCo+oxqww0xlmWi1wa1HFZAnlJWnuFMgHp8D+Ew27bab7bvVfQpyXPaOhOLPcGxNh+3/k6gON5bgu6QNlG1BpiiiYjYC2MJtPwdkynu1NEy9g4Yg3mFJavN3ahJDDZIOXL9IFQkcIM9ab8TFUhi8KwqZeeVpNXxx8af05FZuoMx4Ypz1Rj9189SNTwN9bsnnS9ekBO5PCBC5T/iEdwt2BqnbJPF1rrEvRi36SVLJPm83fHF4pAeLfnctgSl472vXqR3lQ3rnx+4F/u7+6Spj/qcOlj1CoAbAQP1BiAkRbT5TetoeXoqZyGuw4iz4otzmU5vQvFdIR3k8ZgQVbD6mws3V2VZdEIVrdzDIXymwYbXMbvHBy7wEAF89LgSmL2khi3TANTZ4E8WbUVneNOdPi88WmB9Mj/n+hcnVYsQ2baOECV3WQf4l0LbLBAa5HRyqzB3+syG1tkO4RUWWvYjgfByba6Vy5ghE7UDyQfPC91STnr/belLvCHl+QURw510DSQ6AF/+c0mD1D3CWaOhAETZkrVoVugEamLkkwEN9tgSneoriOn64MS2KzyEVR2Xpjhzjck1KSD5Gn7PonVxW4tQvEFNJ94D
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV3PR12MB9356.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(10070799003)(7416014)(376014)(1800799024)(56012099006)(11063799006)(6133799003)(18002099003)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?kHE95x2H5q0npis+kY9R+U8aBytDc+AFJmNu84DaIWQSH3JTc6/OVweoLMfq?=
 =?us-ascii?Q?RL/u9iWPWzchs0gRwtT5V9Wt++ZM+swqeY6qfw3l9zMgsLiSBORrb55ZdUjq?=
 =?us-ascii?Q?1AbTueHG7cpCFuZodUtvKFTs9tmwM+asYwwHkmX5/asxKxyhW/Uocw2AsbPF?=
 =?us-ascii?Q?Eo+8tzmDXQ1zpPG8YETqr7t1Zy+upiMLGw5pU2rh9cmaNe29tQ6UtbFmeTpf?=
 =?us-ascii?Q?l2UVoWhWxpLbWqC6O6Ugi0BUoJgCGTl9oE72Nr9np3V8zkoEdc7Xs2CR2gEX?=
 =?us-ascii?Q?ofgUMF6Ot1slI7/I4AynImxMszQzuoPS9UcuHtpC7rRqcFHEKtkNXQOX3j6M?=
 =?us-ascii?Q?VyDgBV7E1HzzcN7Dw8STId2ty++28wSXkwY0zBjHts0WmTZW7jPR92sWGNNQ?=
 =?us-ascii?Q?x4YOZIcBSB5iqHj3/W9UgTSVOWHXDxyt3eDZCntK0x/GP6J27M7oPHJVb5pW?=
 =?us-ascii?Q?kaYCCAtYE8ZTGPenpxPHIwjbrw0wxornp9DKq4D2UdtR5K4IVtr30h/ydumo?=
 =?us-ascii?Q?F477vp2OR0riEqPmbzhUlqOmeVdSQC9MYA2JBsacDd4sT8z/jQEygMaAhFL8?=
 =?us-ascii?Q?pk9SHAwCfIeXMBSjpV/crd8ipGVj9MWYs0c1hJnYm7/qWMPp4Os0RXNEpXSf?=
 =?us-ascii?Q?Qa85YVORkQI9lMy40elSd1M6Zje+im/HOkZc7CwsSIB3COM3p1qNJllHxtfy?=
 =?us-ascii?Q?11voj2oENKYack57Z3jYTHHHRCsBIlrIuY6Wk+3ZUpII2xrwyfmq71BUATbI?=
 =?us-ascii?Q?AoLj4AORGfzqScgUSdWoxmnH9BdpLVZ64foi3lHwBFUNhWKcajvvA3gaVw3R?=
 =?us-ascii?Q?OdlmmqzSdxdVMWnggc3BYtp2e2CQKK2pg8M6nz5CeqJdDBe9evxd6VYyxilP?=
 =?us-ascii?Q?jv2FxCLqm+PHmO01VjBqVoxwHysliomlfMlhe6wvVQKqvSZn/PRZLd1ImIpZ?=
 =?us-ascii?Q?DMu5ztdYS+mpDXx0aKZvSpE7i/iER8qbGn3BRNHD/Yngr7cUKSwlH19JOKBN?=
 =?us-ascii?Q?8Muf2aNMEVawCX6haLeZW0+9k5G9vonQxuZcry+e2G7aMiHkvIqgoJPh7+UG?=
 =?us-ascii?Q?DnYRU0IS7V0e4jM1Nva13FUc92XB0qe9nzXO+sbVAisU7Thr+Iq8494lhzV4?=
 =?us-ascii?Q?gCXbAsAt3k+DwBYj/icEUf8wVIGOyz++QIJl6V7t7z3NdW719r+FyipTd+8j?=
 =?us-ascii?Q?ZZLB10pcXWu6CT+S7GO2kZNOAQ2uCIWfl79TjrXUsudSQRcRnT26YDihc5HE?=
 =?us-ascii?Q?ZsON7q8+uiaTXJ24dG+9dTv8RDI85cDIrJgjpAFtRuix+aGe63jUPICzaVca?=
 =?us-ascii?Q?n4O5qR1iUkfI3OVAsJG2RuZDyeG85ouJWr8PFWClSIKwIPCgDhLx4B3D3i7V?=
 =?us-ascii?Q?GA4YM/VV5dB2i0OnzS9nhqtw4dww5MgX+WC2Jl7tVcZsC8lCK4Exn4/whRnx?=
 =?us-ascii?Q?jA/oNlW7dsqIqlf5vj4Q7bIEuWHCY7yQw1sQn9G0+zHyPVFOU7uoZEdpOBJx?=
 =?us-ascii?Q?OwUelDOQuLu/h9bUj3LlJ8PXXY3ipxEh+PA2NYfyr4xPdAe/o12VMzTC3zvr?=
 =?us-ascii?Q?PNnv1rf99IJhsSAp1l2zA+4jwaQ0Ihf2fYXHh3e81VDbeiYrTdc72VVg3/B9?=
 =?us-ascii?Q?cXeu4UOoJD8bdiAuTbptAd0tIwPFd8MQWFduUlkvpawahwYIozvRVZ+5dGdu?=
 =?us-ascii?Q?ZVPdQOxBc3jriAtN3rLw6pDO33jnop+7jqH9XwCOmX5vn5md6gwzEjRxY9xH?=
 =?us-ascii?Q?XoB1jNTtAzCb/7bZi0XiAoUXYcCSUnLW4ylNid2ipLJRhXPKaRrD?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 25da8389-a36b-4840-67f5-08debcebd539
X-MS-Exchange-CrossTenant-AuthSource: LV3PR12MB9356.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 May 2026 19:03:41.5686
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SXnw3N0umrM9RsoPS+sbc/RNaBQuWaVzYtL49phd+gHiVPJr9H5KYE2pKYLdhM2EkqiZy+9osRfeTdosgnNhQA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB6042
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 2914A40008
X-Stat-Signature: 9rp7fw3tur46jqjejywgi6icdursiocs
X-HE-Tag: 1779995026-87876
X-HE-Meta: U2FsdGVkX18T+eXVcRGi8vVCO/p52X+N9celklRQcGnLAiChHorWxLXHZ3XVtrw3AjtiMzYZtb3bd8K+wWX9SwTS2H40U1vaqGlA3gw2IsU8iTuiL5IMzO94clogevE3kKgp1THlVv6NHExwSpCPFGs5fuu66Bfu5P0cLAvE8DwPXeV1xXz7M42p1ECRwNKVl5Lg8AhyouBfUosZ+ByW7yYS+9C2EOzkZvwz++ypUAIugeWXAh2WZIhcwwiYJ0YjOgE/dE8r7S6Q/i4kTpa7jHMwl1r33gwpjdcUhJ2+YB3Q/QGLf6NGAfDH1tavi1boBbQyd7vTNka/fkq0nIK1cztbzlPjmrY3/WyuCPiGY9VXOjxaTWmg1FZw5G6Yd5IT1xUIrbbRv0A0IMZTGhLaTDfPm7BZo7m6mlqBAah9GaYvXhAe85qyiW2BhnIUXpW3VYzxpNhguWqijna9X9l7JHxrxqDJFDXBY/mk40VqGEP2v/3i4lhkA8Uj7itLT3U0PrKpA5IJgMgvYeYgzA/6fMYVLctIoN81gLCrexY3ybd7fUP2WWNDxhga0t9WTm3MGJbW1/Hisv//98FP8ub1PU30NcUncu/pzxnWxzPgVZKyPw5m03tXz1Au+VjhkrLnRwVIR70U5FHfEaA4G2ibsTaCR5kRBADMMAp8gwGk9KSWd6G1d8enpeVUwhTlN93s7I4QmHGhLLp4Ao2gHfJl/Luo+Vi2F52xFRbbjWeIV6mAcaBEhb7k4aibOxGyVZwZ3YUN00ZQX4/KfVTLw7aJkwsCj6NPFBf8eMGGJLg5P1CB2Dk8WsSZfKaOoQqiOmEsJLSA2zvs6XdvPupBu5bAVxPkD2jJBGjgowyl9yv68VCbnwUytzc4iA4tJLj8tT1oEEMC1/sVrpsCgXm/XTaKOM8OIW4P0e5cH6lCKo4d2ak/M92u6BcJlTaAe6ghTTBrn4WKLobuVE+KVM33slO
 RPuavkzt
 4j7fYQhd9VsE6AQYuG7jfVWj8FogQfjy/cH56l4cpaF+9aEWYW4aUoKUEdeavKUQXXN2SuuKXh8Sj0rRG/WZOPZlDnWXLOTBVrD/Mr7WxTX+rJDQ1nvvo9tBkiV6b0XO9P2nn4u9KRSw7FHRjK+VlH1eUpcGoHjnu/Q+tuv3Kp3s0JafNfh1aOHDZBZlKjn1MtfgLrA2mbCAwZEbL5xYA/FXRpR4ZlUcz9ri62TenyiEggH13Xh/F/iVLeLVa7SEeRh+d1G+seII9RM1DTcIwmbcnAnzFpThrG2J+86lFEHPRAU2f6f/3RlhHO+3mNmvCHkABzBnRcsmobeLZYRVjXKSTlCxqgexTTjL010YGdDJMWZK2g+NUzGuRJhFr1Cqz4egyRQSt1PPMMwHSysC3QIaKQaKqeTUAPsjPWI0zwic3dqRgiQYDWEKJNZ32zu0sjBhzlefrLr81WLM4PyDnbKmgK35ZtPZ3GDgEQgiDtorzkqkF2n3bimqWq0ftzf60ZYMKrJujxoMSCXAUqKkDelnsjObLCOEa9bjY7G9r3gZx0Ys=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Reassigning nodes relative an empty user-provided nodemask is useless,
and triggers divide-by-zero in the function.

Reported-by: Farhad Alemi <farhad.alemi@berkeley.edu>
Link: https://lore.kernel.org/all/CA+0ovCgxbZkXa+OU8w3s84R3KNPNxxRfmsNR-udh+afQBbGNmw@mail.gmail.com/
Signed-off-by: Yury Norov <ynorov@nvidia.com>
---
 mm/mempolicy.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/mm/mempolicy.c b/mm/mempolicy.c
index 4e4421b22b59..cd961fa1eb33 100644
--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -370,8 +370,13 @@ static inline int mpol_store_user_nodemask(const struct mempolicy *pol)
 static void mpol_relative_nodemask(nodemask_t *ret, const nodemask_t *orig,
 				   const nodemask_t *rel)
 {
+	unsigned int w = nodes_weight(*rel);
 	nodemask_t tmp;
-	nodes_fold(tmp, *orig, nodes_weight(*rel));
+
+	if (w == 0)
+		return -EINVAL;
+
+	nodes_fold(tmp, *orig, w);
 	nodes_onto(*ret, tmp, *rel);
 }
 
-- 
2.51.0


