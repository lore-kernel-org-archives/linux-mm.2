Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9297B606A32D
	for <linux-mm@archiver.kernel.org>; Fri, 13 Nov 2026 19:49:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=qyJU1gpt
Received: by kanga.kvack.org (Postfix)
	id B35E86B05B7; Fri, 13 Nov 2026 14:49:00 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AE6D36B05BE; Fri, 13 Nov 2026 14:49:00 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9D6316B05C2; Fri, 13 Nov 2026 14:49:00 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 775126B05B7
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 14:49:00 -0500 (EST)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 1C3841201A5
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 19:49:00 +0000 (UTC)
X-FDA: 85431134040.27.75D2145
Received: from MW6PR02CU001.outbound.protection.outlook.com (mail-westus2azon11012046.outbound.protection.outlook.com [52.101.48.46])
	by imf16.hostedemail.com (Postfix) with ESMTP id AAF36180002
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 19:48:55 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=qyJU1gpt;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf16.hostedemail.com: domain of ziy@nvidia.com designates 52.101.48.46 as permitted sender) smtp.mailfrom=ziy@nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794599337;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kL9NY20n5YLEvcBNRY+HMGpKD760/oNOc2lpiP/q+HQ=;
	b=2HiljnaHLyBgWHuc2IntOh+7HWNFAvuoWFmittLM2ziD//KdBA+7EO1kGfIicIAhWk6+lT
	So6qnlAXulgL5/TRUnpUIMmkY3b37rHfpgMSPsRgV/J0P9cVcrcTuqD7wjG0Sjo0D0pILt
	jQX55FdSaNk7OvEsqgjHNb8Fgnr4USI=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1794599337;
	b=BXTvTVYknsbzv2ttk1u4RqAXkpsNqj3fHR8jPEHQA/Mn7naHxLk5GLVAEhDe2Evu6IX2OF
	HDsYpYoCi5dft2YVZ0j0b+tmKNsq1rvllSo5kce3aOID5c+sJZNGkAdV4GKhQobrNFRoRc
	PD2MdjtCYskCWeRNd0rXn6XP7uhqdPc=
ARC-Authentication-Results: i=2;
	imf16.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=qyJU1gpt;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf16.hostedemail.com: domain of ziy@nvidia.com designates 52.101.48.46 as permitted sender) smtp.mailfrom=ziy@nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=e2l8yx+r77qybvm0bwt53M+CAiwxr6eWkfvzxDOM5E8fRgvSweopzSfkc0avB4vwnoLfcTTIG7gZxZ1pyqHVUXkAVpGB7YZ4OCmJTIg9oK202nxyyl8C53hplOldDXUPOZYIFic3KBK0NilZ0cNJYt3yYAbm9IQj0nXoc40aIulQBu8wciM7Pvb+PPIkRKy/D443iNUrgG3BtlqdpPl9zlh8ipaaUbMgl2AVYORCweguMx8QIurqvuQpqr+JIxaU6EE485DXwhTN5hQxqpJCZAKwkP8GIH/QWuGBxhSa1x6lWMAVPc2THvchYQXe7rvj7+Wu4p2RsqnChcNrOMwcqQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kL9NY20n5YLEvcBNRY+HMGpKD760/oNOc2lpiP/q+HQ=;
 b=p0e/uQMF91ZDUB+0BNpNAoYYOM5HGi842Vj3g7EWemTHOLnSrYRGj7Hi7GoIAc9TTsaw7qDKWsuHGFP3v/j7J4SnO6W5083lwFy3e+b4iFTraHkqle2HYFd/xghFYK6umS4E1u6hCS5NQ1Ak/YKgDppMWh1dZD98cWh4zeZpJcD5bhov7Gg9wY47wSf3UbIFs8b8bjl2/GRxzClXPBgd1EKZZEOd1K155t+9ovpiT/ddDjaGfY3tg8eMgT5j5fkx1cZZP4Oq8rmyteAykGvT//yzEh2cfC583Yixy57hsM3UQjqvFNAg4e1hsyhM6Y+dFAqQ0gqo5Ztdr0GrYIQqQQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kL9NY20n5YLEvcBNRY+HMGpKD760/oNOc2lpiP/q+HQ=;
 b=qyJU1gptJTI37h+PYkT81FJp9D4i1wYAjWmiy5ifnPZEJyHiIfzbVI4hiVY5KqrQCT3Qk6z0V6ObeXOMgq7uQxJcNcwJixJPXwRfc/LW2xn+Kcu0xc3FR0KsA+aCNpLusa5HRBxR6AbXVgJOkQlPRgGdde4XVqXFSevGxPP2fCLRqVWsfMMo1FDgZcPZOLXJ0QmvhZqG4XTzVnepiCZnfiOxgnNHePagQaijVQBi1nN1AHfXNdhvFkHh+U94mnJCMIVQzCR05Ipd7uR0Guhhr+5hzbE+8kyXhXyHFSCx8YqRypDBdUuRwwhMG+hJaF0wM0pmNzF08Lv02vYitJkpAg==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by DM6PR12MB4234.namprd12.prod.outlook.com (2603:10b6:5:213::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.10; Fri, 13 Nov
 2026 19:47:14 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%6]) with mapi id 15.21.0615.007; Fri, 13 Nov 2026
 19:47:14 +0000
From: Zi Yan <ziy@nvidia.com>
To: "Gregory Price (Meta)" <gourry@gourry.net>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, kernel-team@meta.com,
 akpm@linux-foundation.org, david@kernel.org, joshua.hahnjy@gmail.com,
 rakie.kim@sk.com, ying.huang@linux.alibaba.com
Subject: Re: [PATCH] mm/mempolicy: ignore a bind policy whose nodes have no
 memory
Date: Fri, 13 Nov 2026 14:47:12 -0500
X-Mailer: MailMate (3.0r7038)
Message-ID: <D1684A69-FC68-45E4-8349-9D5E5A327053@nvidia.com>
In-Reply-To: <20261113192642.2618878-1-gourry@gourry.net>
References: <20261113192642.2618878-1-gourry@gourry.net>
Content-Type: text/plain
X-MS-Reactions: disallow
X-ClientProxiedBy: BN9PR03CA0394.namprd03.prod.outlook.com
 (2603:10b6:408:111::9) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|DM6PR12MB4234:EE_
X-MS-Office365-Filtering-Correlation-Id: fcbf8d93-81af-41da-9036-08df41beea38
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|23010399003|366016|1800799024|261028144727099003|10067099003|5023799004|11063799006|261026121527099003|56012099006|261026140227099003|261022075727099003|261022105027099003|261021121427099003|261102123227099003|18002099003|22082099003|6133799003;
X-Microsoft-Antispam-Message-Info:
	vA+q/2Hr1ICWxo5tAf1zgOBjKldKWNWvMhuq4NAsgWyWACuMvl99HyAQjWJ87yLRXCkzR8S5NS4D2JakGd0eH/uOpmouBAXK9gqgQ+OSKA1cBKqJstOLV1z4b9lmJpFDPqrZBw8TLAZDvSmMrzJFnQZ0JuDUeLG2AsWp5N/MElHRDxnn/B9fQiziz70BgStFS9nGmXmD4RxMCSC1Z4E6LLVb4VJmMXzE39mkXs8/5sJK37IAT6lxhX7uy7YnvatkGMyu2lcq/y+pu0NLZZVDjMm/xcshr3UZjAuaAsKM+JG8zbnCdrB95aObsinI5jMB0R01tPtFecvzBVyw8uIulrm2Ph9AdcQqf+zjr3M8QAdBwUx67QFUw421qM74cK+uxs8vGKHjP2O01wdjdeMa9PnGsfWhd1zu6C8/gZvrGuJF3gGt6Jl+y/99s7BG0mqyduyYzNtlI8+WwwQP5k8oXEz0VCjlhHbAbAiAWfi6kkHe16rgAKnEuI1H3MSBmagPZBVlz4UVMxqJ+wUEAItzyhK0ApJOJFNi19BhD7yYI8CeHc3/xYK5O92o4DCntaajqQBC/Fi2uBVswgwoXRf7bHTmp0CI8LHbfOLs5rOxEo4AnaeScTZvG0IctolYVb758TcLkaCkWXEaP1ECyGqashcvT5P22dLiYCo6IZICzSo=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(23010399003)(366016)(1800799024)(261028144727099003)(10067099003)(5023799004)(11063799006)(261026121527099003)(56012099006)(261026140227099003)(261022075727099003)(261022105027099003)(261021121427099003)(261102123227099003)(18002099003)(22082099003)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Q+ykvJDtu6G08dX/EBUEe6V5w/mayVHcB6bPeQsQ3YwLQ4fSfaSEUNJD9ttk?=
 =?us-ascii?Q?UematsUf1Ghw/TMUxnsxP2BtsQy9t1ibN5ilKUSDtNEo1UBDXSQUKe6v0qz4?=
 =?us-ascii?Q?NpnEnuRqo0UhZXy4SG5iSVOM33uk3tgSjS/a0xqYdPFLDyE5gp/G093JPvoV?=
 =?us-ascii?Q?BL1GY1rlmpw3LvKl9zVuvLpo82PQMIrPVlJ70gN8C5mIw/96snizxORQfb1x?=
 =?us-ascii?Q?6q4Wep2xwqp6BqLCB499oFyoz7q8Xh3KuOL2ZIkthn54Cr+DhTQeLcO7YIQq?=
 =?us-ascii?Q?TJvykTOgi0rGv+JhpQAG7rtXJohBZTZCefH7balgzdE7kPifkuCzf2JEpjr+?=
 =?us-ascii?Q?gqLFQ8E5UVr50KyBjymuTsBKWcT091mshk2XkgqHohja5UKLbZ90PdmcXkTS?=
 =?us-ascii?Q?o4YBaA6ArILKuKulHLnQeVolCFpEGDWLT/hKwazgCwGOCn80xmB4yKHPXwI+?=
 =?us-ascii?Q?d/ugcNXourBBkvD6ef4vdjJH7uEHLflxlgjeWXQ+GTQeccNLhEGgjVwDpvzT?=
 =?us-ascii?Q?PwJ0qZXPSKAnozqIlLlyBPeNUUvw3Yzn67VDNXCV3YyPyEUn+IaeqOqfQWeH?=
 =?us-ascii?Q?SGh3lq7SGdlSQQ2zBLw75aSzplvk40xf1PSFq7vaYFoCYbW9Vm5HuefQf+5B?=
 =?us-ascii?Q?N8YYcWaaZ3USVrihOkDUaB0uXS5+97K3tEsC64jHKM22d9G43RyeuqF8AmOW?=
 =?us-ascii?Q?bZ5Ga6kxhdVpejOBELlkC4RjS1xm3V97eKhJITZGp+Oh9AtD9wE2USGV9s78?=
 =?us-ascii?Q?NcW69AvCLg11FS/LtuD17UJ2ryWKU2oHyCf7wSCvemQqf+7tCnmBM5IXdHuh?=
 =?us-ascii?Q?mlh16L0pfIVWZFqsBTpJQ22Q+LVY6PZnBXDfbPm8lAsz1o0oTVJj9ucPoRT2?=
 =?us-ascii?Q?JddXocWH6f6ckojfsjOWgjELiFnuTlmEc8LEBebHALfC61vT7FtuL1scetUo?=
 =?us-ascii?Q?uu0ArUm7RaCGfGZRIL7PzkNsoSBRMTUNBvJ9n70BXjk3B01Qlts5kAjOQibC?=
 =?us-ascii?Q?35z1D4P2oR5owwKx2Cns0qS8NoszLIkKPUyY0ftUCt5aXAOHCPo7ychiSfaR?=
 =?us-ascii?Q?agOFL/ygJfp3U1z/Tse/2CbMNfkRADjfIZGqm7mriYvKxWN5affPPssz/gml?=
 =?us-ascii?Q?cZG9LWFN8kgrwqyqdv2MTG7d/7PHDXFqZg8vBwtxlkwzYwDlyaht6c0tyOeD?=
 =?us-ascii?Q?gzL1+18DZPIqUVSZEAgfMbrEjEoIdsYrExN/Z/TSZX9ATbf/MCKW4sCeRJUs?=
 =?us-ascii?Q?hA+oEIq9jCaMxeKLf8Y7XwepQ9p8gH8zxa7sHNCdH0iolCBHvMLyoFGoF49O?=
 =?us-ascii?Q?0msmXxFDV6zGdHntS1RQGSiUi2bkoA9ozQ7WJcw4PwCwupXcgnDZuKoLqnmc?=
 =?us-ascii?Q?vEArCUgTDZiQfNx2nFwbbn7U+fEXReQmbHjDfaZzXM8+6xd1UldIqc2DHGKN?=
 =?us-ascii?Q?JPUHPKYtm87epxbCd9By8MkGaJhIQG+JKHKgW920KvjgoqNqqa0pmShVDTNm?=
 =?us-ascii?Q?ulbXOVGqvjfCO4Q62UKwXepPcvCZr4roL5GeB1P7RgSWp+x228JlxOedOMw+?=
 =?us-ascii?Q?jIN1GD65Vql8MAw7HE1mmKG+KEs2Ed8o5X75+bLb9+hu/aivEVDgH74HgXrz?=
 =?us-ascii?Q?DDTX3wpZ2AaCQrJXH17WLFT0WEExU2JnEIpJsW6U/tsXUwlgNNtNY23SmKmW?=
 =?us-ascii?Q?/LfoIXaEDAA1JjIleSvs0Z2wCnkndtSgnYLMQ9y5g5ekSWqi?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fcbf8d93-81af-41da-9036-08df41beea38
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Nov 2026 19:47:14.0262
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: m8rKi8yJRO7PpLgThwHAsF1Wi9boFSwDKXLYqY2ipSG4H746EUOexxJTSSQsbPWv
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4234
X-Stat-Signature: f8rhrhkux615gku6wh5x5bx7ae3ers5f
X-Rspam-User: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: AAF36180002
X-HE-Tag: 1794599335-986062
X-HE-Meta: U2FsdGVkX1/E8ufOZzxdyPdmknHhuPbXmtINXhj9XiNQPVQcsekulO+epzvW1Dexn1Duhrl7zwmas1s30inx6pFeA5wL3YED+hw95GoxTtXEeQIAJvGzdnoDhJZhnV9ZXID4g88waVjn2u1xgI16grsPbsEiTSXpp8zYAXoGzAMbmpX/0/CNbzq3PiG4O4X6e3+UldmQci1sF9ZOw921Uz+0F47KzjxYd52iC1WFYClR92p/Knk/I7I2r7YMRyM3Hzp/dQwJYwl6vjXEVCoBEFVC7LS1pMZa1ddvtw45qRj8xu9ZaFG53ZlqksNkgYAU1MfOD8yjD38Rg+Q8iU6NSwRH17hKGfegBAwo8CrXuP0ASr+QdxmxWHiAU9SA4J44641fFV0iu3Jo/3NY0kifOuOgBFVn+j9HnF80yG14E5Qm9bgSu7KeV0yjQL7HUaLuVKacSJCJu2EtNVo7+F2VSN8yfZ6xeIQCAdFNw31FaUIpy3WKizC3PrMvfBjSUs2HoR34n1LfM82punkI4K2KU2DOErr2apB1XrWifXNtD4ejmgHyH8sLAriwoveNvSmKGzdWlcz9KBkRDMhnkA1EnizZAFxKs/PmJcGtzFTnOnpRHg/7HvitYyJaqnfTMbfGP4JGO03Hk8vApREY77FUFrP/LYonLbMl2NeyZ8CQqzAO0y/DbQ0424BBtYh+uSGvM7lhMLgE6qyxcgEBOkMy38sVffEVSrDUlPXfAOJsSN5tiezKc188tX0wTbl5txsmFndw7fqD7zz8lwftbaGBgryltR+DJG9RclwjEdmzufm0UHZEe+t0/1rEzY/Tpqm2xUk+hI0KFcCrjx0Sa0tbiW1g30jygrFzjZRZ6oQEIFTSbBv/5U+G3V1eRqw/1PKYZiMVg5KI5Yj4WzAw8YRP9gKA8yubUq32wA38+oyoDutB+Qhp9lszc6Nj/PTogmcCUavy/3YMOZdeizmhkQH
 9wQSkmtk
 Rx7hveLKlpbLGVUxB7q0/loV14UObxdAlyAONn7zU/Y8Z0iUXJM1co6+DxRzpXauuqBgKZ0JC6nVxxsKyrM8IGDEXjJ+dkkpFdAiuifbc/eyiKBGF0JtsWuvF635IRBtpJIXpvFSFlEk26Ui8gaJit7kIY+EZU+PtHLttNJb3oANviMrJkfkIiF8GClc60fnOxj97obpWj+DiUTq/6dUFGc666hhPMpGFUbruSGl03fsakySD7lPfAqOA5M3CyHGJKvbIbSQAbCuNa5qPG9Wnj947CH6qAH3qTxC5PlgTrze2d7AxbngylwSGyKdarSlLZ5hGGKnJSSlYN+Qe1shJN2eUmvlc2yadG2lY1W5Kl3o/MBlkjVOqf5tF6/w0MMJY01n2YflvkrgoTazAuls1Jzt0Ri8UwV4SUdMhMOFsYBF47I3FWxCqJNMuZwLrJFtn2Efaw0VvO2YjgBjNmlUTuvl35yAebpDrVxNvOSaDnshE4L1Zs/KTNp/GbDOLQ39/gKR0EIuYHbFKL2I=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 13 Nov 2026, at 14:26, Gregory Price (Meta) wrote:

> apply_policy_zone() assumes that policy->nodes intersects N_MEMORY, so
> it reads a bind policy with no N_HIGH_MEMORY node as movable-only.
>
> On systems with CONFIG_CPUSETS=n, nothing rebinds policies when memory
> is removed, so offlining all memory on the nodes a bind policy names
> leaves it with none. The policy is then treated as movable-only, and
> movable allocations are restricted to nodes without memory.
>
> This results in allocations failures, a VM_FAULT_OOM leak, and then
> an infinitely retrying fault that hangs the process.
>
>   page allocation failure: order:0, mode:0x140dca ... nodemask=2
>   Huh VM_FAULT_OOM leaked out to the #PF handler. Retrying PF
>
> Ignore a bind policy whose nodes have no memory. policy_nodemask()
> already ignores a bind policy that does not intersect the cpuset.
> This covers hugetlb's policy_mbind_nodemask() as well.
>
> If the nodes regain memory, the policy applies again.
>
> CPUSETS=n with HOTREMOVE=y is unlikely a common configuration, so this
> isn't marked for stable.

Also no Fixes?

>
> Signed-off-by: Gregory Price (Meta) <gourry@gourry.net>
> ---
>  mm/mempolicy.c | 4 ++++
>  1 file changed, 4 insertions(+)
>

LGTM.

Reviewed-by: Zi Yan <ziy@nvidia.com>


Best Regards,
Yan, Zi

