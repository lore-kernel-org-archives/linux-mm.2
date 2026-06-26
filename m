Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DC081C43458
	for <linux-mm@archiver.kernel.org>; Fri, 26 Jun 2026 18:52:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CB3796B013B; Fri, 26 Jun 2026 14:52:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C8B676B013C; Fri, 26 Jun 2026 14:52:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B7B416B013D; Fri, 26 Jun 2026 14:52:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 921AA6B013B
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 14:52:22 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 15FF9120580
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 18:52:22 +0000 (UTC)
X-FDA: 84922959324.24.31B9CE0
Received: from SN4PR2101CU001.outbound.protection.outlook.com (mail-southcentralusazon11012046.outbound.protection.outlook.com [40.93.195.46])
	by imf01.hostedemail.com (Postfix) with ESMTP id 1ABEB40004
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 18:52:18 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=BoKW+fHn;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf01.hostedemail.com: domain of ziy@nvidia.com designates 40.93.195.46 as permitted sender) smtp.mailfrom=ziy@nvidia.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1782499939;
	b=sTSEkq+H3eHau92edATR5dYB/QiQGYyXWolwD/BUGrZomb6+ptENny/bLsHsShFo0qj67F
	Mrcme6L6VPFOLJUFPu9RowhYSvfpY2K7K1sajIjFn5I2Xun7hOW//J5UEmNYLWo4lVVGiF
	6/dv+w5KM05cBrH9uwDBSlXdPshdD+E=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782499939;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=61n7bU/ouwKKfAolivKwoHl2VDxFdJk0H176YRyjfGw=;
	b=f7nR/lIm7YoxMQUZsklF46G9vSpXFg+QSXGnb7rGk7+90YY9yT9Tqpo/1eb7UoBOuGb5l8
	pOn4ZzKo+fD52Rofs7JRANXhy5y8CKuRWpETZn22PpN9ZsBwXHEm+eltTNOG2UHKBF8bKy
	guX0RW0lEwlwmyrU7KsjA2Hfn7xPq+A=
ARC-Authentication-Results: i=2;
	imf01.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=BoKW+fHn;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf01.hostedemail.com: domain of ziy@nvidia.com designates 40.93.195.46 as permitted sender) smtp.mailfrom=ziy@nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=GHtkx/mvuCyuZgoOd/DnPn+pIesyC6nOBXoGIXjAoNv3Tsq6JdUmxjXm7GJQZnEBoG/WQo48lb9Q5U/vH5bQD7kw7RfnQLykgc4+kt1T8SLKiESHe+FlcHuryCeuCjeKNNzt59ZTgk58cB6iBnPjY9mdmol4buU0dawvnn8NBnSGHkdcq1GkjY+DKw2sWptKz3FVv6CLHno0ihPAY5NZY74ZvuCbYrOtfdF4KRlhoXXzXSyabf9hgn0+TwBn8zDu5YU07iUEmvOPPiOflSkkH6dS44tVsmA473mOJv2TwhvhS7tvXICMXZUpSgVVdjk1JNSjPgkPm+Pq+WKaJJVgiw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=61n7bU/ouwKKfAolivKwoHl2VDxFdJk0H176YRyjfGw=;
 b=T8Hx7s10APGlt1kaZJRitCnd86ifrskmj4b0xb7v99iSMsur+QF9OW2UuGjfG5xXTkQLq1jrkQkhw+wPWweCBtSUzEbFsetwE/qRqTZ4sVgrBzqCznYwnU6PaVJSRcinLKEnz1npiqyYJXURrPx6Ibp5l8wao5G46HtpnMqc3Yr6pV2sfqbV/ftb/wq3gmGbvoyjTBI6GfmRE3hoVahC0b7m7t6Sb5mgv4vf4CkSumTRgCZh+NBzxjIjmWVqtmNCydYk/F0HMJphOQK+H1jeILbv4UC9rIP6/SGchF+9y9nq6egHH1DY5Is85YXsTcsmUfFy2N30Xxb+lUreql8YMQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=61n7bU/ouwKKfAolivKwoHl2VDxFdJk0H176YRyjfGw=;
 b=BoKW+fHn/oYLCHC8XaWmGExlWJNVjMNklVDk7c5YiU/It5NDdhMcrrIP47B6hjf4B9AAbD68WG0TIQ2T3mbigZFpy/9l6j+OdI7VqBc5niEfybeFXaW2r6/RFBPyHImmvi46CPttNn0nqWSSRH/aAc/NaKhlSZw22RHpPsyVT4xPGiAYkvKhj53++FIW5Lua2TuuKojANOVNZS2tzixTA2FaS7qBlESXxmVPdDfwNmER9GY63AYRy3EFE+HfCX+KE56CVFJReJYip2mrEyjE5g6zRbH1v7PXhtrla54n5sVWitV3CJtCswa7H6jvBS7w5foqRVYSgpb1aOT/B6o3wA==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by CH3PR12MB7666.namprd12.prod.outlook.com (2603:10b6:610:152::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.159.18; Fri, 26 Jun
 2026 18:52:09 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%5]) with mapi id 15.21.0159.016; Fri, 26 Jun 2026
 18:52:09 +0000
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Fri, 26 Jun 2026 14:52:08 -0400
Message-Id: <DJJ7HMFDHGXY.39KA8I45KM8Z4@nvidia.com>
From: "Zi Yan" <ziy@nvidia.com>
Subject: Re: [PATCH v2 3/6] mm/page_owner: hoist CONFIG_MEMCG to function
 level for print_page_owner_memcg()
Cc: "Suren Baghdasaryan" <surenb@google.com>, "Michal Hocko"
 <mhocko@suse.com>, "Brendan Jackman" <jackmanb@google.com>, "Johannes
 Weiner" <hannes@cmpxchg.org>, <linux-mm@kvack.org>,
 <linux-kernel@vger.kernel.org>
To: "Ye Liu" <ye.liu@linux.dev>, "Andrew Morton"
 <akpm@linux-foundation.org>, "Vlastimil Babka" <vbabka@kernel.org>
X-Mailer: aerc 0.21.0
References: <20260626024550.25677-1-ye.liu@linux.dev>
 <20260626024550.25677-4-ye.liu@linux.dev>
In-Reply-To: <20260626024550.25677-4-ye.liu@linux.dev>
X-ClientProxiedBy: BLAPR03CA0097.namprd03.prod.outlook.com
 (2603:10b6:208:32a::12) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|CH3PR12MB7666:EE_
X-MS-Office365-Filtering-Correlation-Id: ed4007ed-9976-4c6c-6e12-08ded3b40661
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|366016|1800799024|23010399003|22082099003|18002099003|4143699003|11063799006|56012099006;
X-Microsoft-Antispam-Message-Info:
	MlzEZeQRBXWRHw1djNJNqlKgTc8ffTt4Mk72OfJsAsNnYzDKCm6PDp2PeZ194yEcoZJGrPMVDj/eD2IBbkPHuqtVbI9tfyj/dvOUb6nYh6UvoX8p5ffTWg281hmp0zBSxKs4yRei1MtYy/4JzE3y2YuSgFhI/R5txk/8c4PZjqxTw2QWnagap2D35clK7cFmvQ9PBoP2RVLXfqamI3Ag2QJI0Ygwx1rRtiWmplJtwr8Xe7llRz7z6W7pE7owOGK9+LMJj2E1sQ0vckOLch2Aomou/HGRJdIsehB3cxxcl13AvT1pAH2cU/hlmEju5AgtodJqnFZEprsy2+XioFqpvlO6r11+OFLhMC9GvvW888O06iKitByd0Oej3x7282/+WcEbNump/rooIgi2iFl9fSqzUq9INewx2u7KMKXROE9LDmGAprAI3U4LqO4NUfS301ECaqZ+p8bz2lNkk87T4yuEVQ6vt4ds9SJnkdx2elKmq73btLMW/WxeqVS34Iq5tQA4Tk4XD9AocCoCrQfLQGOD/s6hi4iZe1QPT3ToS//0+aj3k4pqwMUZVohpN5KIttLTGPpWQuPZr2TZtkbg30dMpUDnircHEMwV6epH+gwkuw1nN1FWwnU/Hfni4J9uLIE8X130ZvV+CL0ELYcd6uYRdZqqJR8LEdPQo/6iIQM=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(23010399003)(22082099003)(18002099003)(4143699003)(11063799006)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?TFZiR0Z3Q09YZlptSHg4TWdZNFNteDBKWlA3NUJlSFhsS2FkVFpmV1dUa1V4?=
 =?utf-8?B?ZjFBOSs5REVNSFpGa0ZkNXk3QjV4dmFoWjhVTmovcHMrT0NVQndCT2o1Ykti?=
 =?utf-8?B?MTNQNXpIVkxzNXdyT1lUUEROMzU3NlhRRGFxUkFuYkZTdEo1cXZUelNreVFK?=
 =?utf-8?B?dkQwOE5GdGsxWFRZNmRsRU9OWmlHblRDWTlYVkU0MU11UG56eFpEb0M3UmNn?=
 =?utf-8?B?NGRxZGRNVmtXN0NNTlhWNVEvUzgyMzNzQU1OUm4ySTM2RXVuYVh6OHdvT3NR?=
 =?utf-8?B?QUtBZ2o3Zk9nTkRhRnlybFdLUlRLcGs3enNHQVlmdjNSSndoRjU2VTJtY3NU?=
 =?utf-8?B?bjR3M2QrVzNkYjJLSGxYV0pWbGdta3BreHo5bnI2SjZSM0QzYXl4Qy9EUmpJ?=
 =?utf-8?B?QmRhbGpFelM2SjM2eFNzb1hZYk9HVktubXhjL2xic0xZdU5tbkk0SGhRNHFR?=
 =?utf-8?B?ZFl0OUlZRmtxRkp1YXlRTFFpSm1acTkwYlYvVHhpMVQ1M2NUWUE0YXN3bkln?=
 =?utf-8?B?eUNnbE9xTFFhemZhNXNWTGROSGRkd3ZtMi9tNTdZNWxaNXREdFF5SWdVQUxF?=
 =?utf-8?B?SXlWMVgrNlExazZKOXdlb044eWlrcWNVKzc5T3ppM2NMRDZNSVNMTGthTHdH?=
 =?utf-8?B?TWRvT2JhTjFSZXJMOFVrTCtnY2ZURDlEcVBEazFDSU45RVdqOGVVeTZBZnh2?=
 =?utf-8?B?UnFPQ00yM3M0Z05rRENkSDVaY2xaMGlQL1FoNHF4eUdrMjdTc3pjQ3I2WUsr?=
 =?utf-8?B?ZTUzaXIySmUxckwyWWJ2R2FNNW9CNmg3OGVOMVllK2hHWUV5eDRTRlRPcEEy?=
 =?utf-8?B?blhtRzQrcjJjMnNXeTd4M2N2cE9VYlNOcXhyaWYzMXFHKzdFR1lKUU55bTRF?=
 =?utf-8?B?NUJyNWx3WWtBSWdWamw1Wm05TkNqdlRDNEUwc0h6UkgvM0xIdEpSYzRCeThT?=
 =?utf-8?B?a2xrcUlnazRGK2hvbmZaMnVxVC9ZYmU4Ym00ckgzN2YvdUUrSnFmQ2RrMzZ5?=
 =?utf-8?B?Y1FwVFczY3pwaTVVZGJJMjNUOUdCbElXQXJnY3J2T0lHQWt1TlJDdnNmNHRo?=
 =?utf-8?B?L0pLOG1Tcm91QXhZS3YyRVlyRmpkSWlXeXZqdHJieEpqTS9zdDgrQ2hNK0sz?=
 =?utf-8?B?eng2UkhPYjdHbWhhdU1LY0cra3p5L0huT1RXN1VNNHhwMXNnSTF2Tmh1QitO?=
 =?utf-8?B?Z1VRbm5kZTlKd3VwUWtiOXFzUm5QZVJ4anNxbHZ2dGJhdytyZ2hENG13ampi?=
 =?utf-8?B?Vk5mZFpFR2ZnSVpRcFFNenNuZ01NUkZ5Ni9XUC8wKytLb082NWdBYXQ5SURL?=
 =?utf-8?B?Q3pyMTdZRmJ6T1FoZ2FyQ2pIYkhscGhyM0pyUENnd214R0NOaWYzN0RNL3N0?=
 =?utf-8?B?TDZ4UDBVVlVZOWVTODY0NTNSK3NCZUNGcVlOWWh0WVl2WmZjTGt5SmtTNnMv?=
 =?utf-8?B?UStydmZ2NWhMZEJGVkxCdm80MVlYYVJNQURvUlZYYmtaV0E4Rm9RcmZpaFkw?=
 =?utf-8?B?WDdTcHdTcHp2WnJ6ZFh0YXBLeFF3cHJOUUJCSlI5QWFNOUtmNjlwMXFScFY0?=
 =?utf-8?B?VzljUUl5UEt5cExRWjFXaWk3Tk9Sb252bGkyM3dobVQ3MkdrRkc2NEpFQ3Fw?=
 =?utf-8?B?TTMwRjd6TGFEQkVhMUtiTmxhSWdiODh3YXJQV3pjczV5TFc5SUVZL1VCc1Uw?=
 =?utf-8?B?Z0ZZNHU2eDRaUThhdkIzcTIxYTIzY1FtUWRtQTVVYXBBcjR5VlVVNWVkWGQ0?=
 =?utf-8?B?UWwyVUZNQnFaaVJIUGhEenZ0ejY1V2FaNHdsQU1uZnFpTEhXQnB0YkRGU2Q4?=
 =?utf-8?B?TWVqZWRBZWZ6RWxqbFd5akt2U1VuYndFMFkwL1ZtZnFxRDhjb2VCZnJBMDAr?=
 =?utf-8?B?OE5zdTB1aUFoYUpXVFhvUUI4bmk1Q01ta1JlczRud2VENzZ3L1pEcUZRV3JR?=
 =?utf-8?B?cXRtNlBFL1RrSHhIR2ZRRWlWRlRjUUowZW1JZEVISVdxYXFhMENNZWx5T09Q?=
 =?utf-8?B?bWM0b3poOWs3TVE0OThrT2NlQkVVYnZrZ2g2VnU5OHZzSkR3RUhSbXgrbWRq?=
 =?utf-8?B?Um5hc0xZODRMS3d6eGs1U015OCtpRmtXTitCVitLWVcrQkNRd0lEZU9YT0JC?=
 =?utf-8?B?RHdjQ2I0NzVtTjlqYWh1NTdDSCtTRmVlZnR0ZXZvN1ZyNzNReUFTT0N2YnBZ?=
 =?utf-8?B?MmtDWjlCT2FzMDJYbXhQV3dVVk1HaGw2T2J2WGN5M0hIQ3ZIbERnVFNCemVQ?=
 =?utf-8?B?WkdoK21udnllT3FTMnQ5bk9zREZpYVBablc0NmJPQWRJRXlzbW9WYnJqaFlB?=
 =?utf-8?Q?rrYu7vHyyBxexH3+uu?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ed4007ed-9976-4c6c-6e12-08ded3b40661
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jun 2026 18:52:08.9546
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nw6TUzCsS/TsFUjladMZvZMuNbIZ3cw7cxGGT4z4SgeUu/l6wpSA1CPng8IEndlV
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB7666
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 1ABEB40004
X-Rspam-User: 
X-Stat-Signature: h1ocissz1wnaqdaqfwgjy5w6dpzgygx1
X-HE-Tag: 1782499938-170965
X-HE-Meta: U2FsdGVkX1/A13Y8D+Ysreqvpi2Be6cu7svaJ14Pd/O4r2IJwWLfEZWZqEC3UESaWyCVpuUaftnZDxgTm2ZSDHndkwK67MRiGJvpnkkX+ttEHd77GhubGpK3E5X5+BbcjAhnuwuxb1B7LOa+FE76rsU3vkG8pEp79TJbl21SMcEAEHuPi5CaA1+I7b1h6+VC+pkDFkMj5eNxio89A7xHExueG0BjScG18z9jL52eF4yutY7W9PnSTKhLHIv5sat67re9ZQeXboRh035kYyOq//Co4MIVEWN1He4qHVzTJgSp2rXT6OwL9dI77LZCl7F4lh0x5/71g32R7KTpctKacuNEw564NgTv6BAiJr75/PYq5dz3VEWG6NxYiVkAfMpTv1jKDD0FACTqRVpuiRDO009bVzjj4rMMxO4ehh/Y0Y5HYk1zRwtDUC8dYzaWKgXqcc6H4iZEA55YTAWdDeypdXJL9/9gyhD4+mGUFbldAkCU/6aaOA/a3UX7StWJxtQAYjz63hKiw+SFKEO71d4Cb+yBmUET8maLlnmGavcpBY1xiImL9vGvQP+0BJKcfuHi4AQkxum+uqIvclLrDLGas3ARnMU7OJ74zNUThrxgoiUnrCzAckwgxDrm1rHDGEV0gkrWljtlBLsx7JJ4eT4JyyV4N/v5jeQ2PN30AQW26g5Nwwhw36/jdFXeNh7JfEbGOERhKVSJkTNjvjejibMlGQGXn3vHd6TdyV4evLMPHJfbxj6kY8IKDrNQ6laciL569z04KFjUoaHRpOQj10o2KLCAN8amHzfqHrbk6nrJaf1TDDt9L/5v6Kqnr1/g5A0S45bg2OCQ2Vzm76/ttFF9Ys3EkOqSRMDpXTN/rXDy5D4+y69fsZzKcEceswDPkbY1E5H+eanSv0WNeomzy8kVp2qgoIe6Y/cFfInerey3tgizq9MdcUOMXk2Gif6vI801Hon4gjbpKbd3Mi6OJeR
 gdpGSiOa
 mjcDAM/1wfAP6PvyGpZXBOtpgdBQXDGNSvvKBmoF+40owHbqpyQqnbHafsQGc+CFMicxEmSl54V98D2zJzoW4EgQILKr8Du/RSW4qoHQRgZxux134YJ8Y6M/ed/ChjeHyC6kn9n/N8zR6wxQ7meC1n9PIFI/Xq45DpWAJtJD9dl4rB01zIvSlOeX4X7cBFEygbGIoe4B7JjkupQlkvDLcCKfGacbtnT5js9ykUcsANr9X8eRJ+1SUQGjPCPBlUL1ZZme3fA2246X2+Mb/IBMIdZhz4qKj8wxz4R9Hh8aRC1/14YsVA2Ig5W6sbiqWswuGiPXEIIGRnxyBz7Z7sRgWsYhZ6H9cImz7Zch0zLLHwlsP4qqvERaE7A2sfUcyFbr3n19hpbdDJkEgqaolmh5jWeXCkD/Ukl4ElnDGw4a8nCDdyLlqMH2xcfSQoxc+fzKFJ0Io
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu Jun 25, 2026 at 10:45 PM EDT, Ye Liu wrote:
> The print_page_owner_memcg() function has CONFIG_MEMCG guarding its
> entire body via #ifdef inside the function, which leaves a no-op

no-op might not be accurate, since the purpose is not to change
scnprintf() return values from prior invocations. Maybe just remove
"no-op" in the commit message to avoid confusion.

> { return ret; } when the config is disabled.  Hoist the #ifdef to the
> top level so the real implementation and the empty stub are two clearly
> separated definitions.
>
> No functional change.
>
> Signed-off-by: Ye Liu <ye.liu@linux.dev>
> ---
>  mm/page_owner.c | 10 ++++++++--
>  1 file changed, 8 insertions(+), 2 deletions(-)
>

<snip>

> +#else
> +static inline int print_page_owner_memcg(char *kbuf, size_t count, int r=
et,
> +					 struct page *page)
> +{
> +	return ret;

It is not obvious why we need to return ret here, until I find that ret
cumulates scnprintf() return values.

> +}
> +#endif
> =20
>  static ssize_t
>  print_page_owner(char __user *buf, size_t count, unsigned long pfn,

LGTM.

Reviewed-by: Zi Yan <ziy@nvidia.com>


--=20
Best Regards,
Yan, Zi


