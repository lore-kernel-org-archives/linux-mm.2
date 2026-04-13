Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C670EF531CE
	for <linux-mm@archiver.kernel.org>; Mon, 13 Apr 2026 20:42:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 157896B00B6; Mon, 13 Apr 2026 16:42:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1081C6B00B8; Mon, 13 Apr 2026 16:42:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F12606B00B9; Mon, 13 Apr 2026 16:42:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id E1B346B00B6
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 16:42:51 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 87EAC85C9F
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 20:42:51 +0000 (UTC)
X-FDA: 84654706542.23.1AD7E92
Received: from SN4PR2101CU001.outbound.protection.outlook.com (mail-southcentralusazon11012043.outbound.protection.outlook.com [40.93.195.43])
	by imf24.hostedemail.com (Postfix) with ESMTP id 96E3F180005
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 20:42:48 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b="nAzi/8Sx";
	spf=pass (imf24.hostedemail.com: domain of ziy@nvidia.com designates 40.93.195.43 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776112968;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fcIIFMOCklLrkVEfByb5lM5cc5C1Di7q7PPaM8L8TSo=;
	b=d2lBqYomtIHjGlh6ebOWJV9on8vtwmB6awbI5IytATdICVBAum7dXv3PrDwVQKgIBt4cI4
	m7ooHWhptDWTyhHGZROHrIJQr/05bHuduWPh+c+p0Jtovv8GhtVwxpqncx5MLnIkBR2b1V
	aLS31mJDnylFXQTJjG1UIWNc4GfbdiE=
ARC-Authentication-Results: i=2;
	imf24.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b="nAzi/8Sx";
	spf=pass (imf24.hostedemail.com: domain of ziy@nvidia.com designates 40.93.195.43 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1776112968; a=rsa-sha256;
	cv=pass;
	b=ZpDBlBIetrdzG2IA33FwCe24y1vYiYMuPo85wiGNOfJKAAvylZQe/SKj6opxG/6K3RcqQY
	7npSfWdD6MsAlY8ylSXxD3BHIQZse+8bRQzRG865mn8xwXZsZyrIw4aiWC0RN3bE9fdKZO
	WhPexTbWLeQRoJrf9iXO28rz6uSgY1c=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=kFfE5MYiTmBlS2LQJGgP+QV4dPztSWxaRjRw6hrlDJAjUeAmv0YA9mjQbdX63d0LD7e/cn4mI8EybS7Y6XbZ+dOKe55S/WDzuksUA5CKnc9YpBL0/r48zlcezbNqZ2pls6JO++sBqhGzNq/Js0EsCI+MkX7rScXwO2Ry8LHo4cr4nsE2EqxylcKdJhFoRhtO7DDGXbDF8G+EBEdM+WxPhT/cIP/1UF6CEfGBhOR1Kz/iYXoCYkILPnPqTcCppRFealcS6Wyzf0c3oba60jrBCEd57Za3nY9fdynlCoUi+Z2OsMKH3+hBke8Qk1qHryrvbarw01s8dYlcWcy441mdvQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fcIIFMOCklLrkVEfByb5lM5cc5C1Di7q7PPaM8L8TSo=;
 b=TwwKsTVfcqKcnx5eWeeRpVaxY31yOgEmnNkBgSqoYdDXSzyPDBC+dweLVUDYK+MK5zaoEM5Gs3yTkJeUaUQQrHLH7Yngc/zzg82A0ofmUIX7f9YG2Sn7oO4rqYMh2yyO3E6xRpSOVxNdYg4KdIHhb9xFhmV6ZSjoZLXpgVBWw5GnyHy/TkqD+6ULcC6oUWARONhS6NKLIWW1g9VjLCj6zfes3+mX5rfIZJSQo58oXZJk5humpRoHZ+iWPNd+zdc7/vkfiK4iP/8GIGU8Th+XJUXYv1KKI/jBQwxYieRRMhEQ5qhPlXMEKX+8wD4TK373kCivzVktsX6zFUQOS4BlQA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fcIIFMOCklLrkVEfByb5lM5cc5C1Di7q7PPaM8L8TSo=;
 b=nAzi/8SxPV2AqLyigXCl3GTMAD6hTnZolHG+eOGZAsuzpagC1g43/CzWTAi08gESXy7fRiajTotacmyHHftrf7s5QgH5Tk35Kf4HmrJwBgo5c4+QSRN+vQRyyWGw9CixiKhmref2ImalwPQLWp/d47fwOrhl/Y8sgIJqXXkiDJFqX0tutPFwJ5DWiH8OhAxh7jgS2tu7OstPTtkb/oMhneT1Rvv2im/MiestV5UlBAsS40x1Y3Rmm8jbEVikX0DXKI27eMfnU72uJ1NmAbLyKPF6Su9v+tIVorkJpO9gJ6oa7AO0kphEvVB1mElfQXGWritKvAODf0Pb4V6hBNbZlw==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 CH3PR12MB8727.namprd12.prod.outlook.com (2603:10b6:610:173::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9818.20; Mon, 13 Apr
 2026 20:42:41 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2%4]) with mapi id 15.20.9769.046; Mon, 13 Apr 2026
 20:42:41 +0000
From: Zi Yan <ziy@nvidia.com>
To: Matthew Wilcox <willy@infradead.org>
Cc: Song Liu <songliubraving@fb.com>, Chris Mason <clm@fb.com>,
 David Sterba <dsterba@suse.com>, Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Shuah Khan <shuah@kernel.org>, linux-btrfs@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 linux-mm@kvack.org, linux-kselftest@vger.kernel.org
Subject: Re: [PATCH 7.2 v2 05/12] mm/khugepaged: remove READ_ONLY_THP_FOR_FS
 check in hugepage_pmd_enabled()
Date: Mon, 13 Apr 2026 16:42:37 -0400
X-Mailer: MailMate (2.0r6290)
Message-ID: <05F00072-7E06-47C9-BC26-FE3736F557FC@nvidia.com>
In-Reply-To: <ad1TMjF1L3usYIC5@casper.infradead.org>
References: <20260413192030.3275825-1-ziy@nvidia.com>
 <20260413192030.3275825-6-ziy@nvidia.com>
 <ad1TMjF1L3usYIC5@casper.infradead.org>
Content-Type: text/plain
X-ClientProxiedBy: MN0P220CA0002.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:208:52e::31) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|CH3PR12MB8727:EE_
X-MS-Office365-Filtering-Correlation-Id: a21175ec-86d2-45eb-ecb4-08de999d3503
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|7416014|376014|22082099003|56012099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	U42cSImbYGquwBqbELKAWZzx+2BDjCXzKhUeYCd9ol4xAEG2S0CII+Z02FzsM+4+EbHqMocy9sq+X1yPgWp0FNPJ6l3B7Y5TqKe9SrxtsSvw63M0lqBPmSQTiwfiUkEgDmhS2tw+vtvrJIn/67CBs29ym4caFr56hlYBfrdUvDnXrvrXbCFYuy8FTmLK9UgLpsGe1pzXvVenHtqMkMUGbmFZ08PwHRa846I2aX+19dRkWfW/QWDdPWNqOGCDLBsIf0sL01llFtJQ0ihUVXvLPDDbOmgqrOYvU6x5QmD48wqgvJZ+glnp9yWJ4AK98C6eNfpmYrHX1dPKUk8GeNmSeenDPxFmX2f18VNY99GIzFPwALeas18kf+UGDKv4PHSkTttDEsHOVwP4ujYeRwFOiwZsF56BDNquhcAhzXv+282HXkQeKIz4U+ExxPxCAn6Mj18NCYtD/jP8JdUt6XPjf7oyptFceKXJ3Cu9u/9otxXruS3ECBcLGk3hThGnCl84Ggsb5CuoFz1RghsH62TUlxLlSz9KBHvxHALdBGT3ZH1X52Mf5+/LY9zlCVnvGO0tvG//sGzbk+fnjWsz4GPuBMkMLRspS24r4EiJqWOs1xJ3/vKXKWih4goV3vKXWAiQg9bxlVhrj6G2rpUOt/MpHlafLm51KU9MeREx89S7Ezj5jthSmMJkNwh7qqVn7TtCyRZhlt1kClfh3YEyJmDNrQpVhy3cwiLWvuxchN4/4+M=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014)(22082099003)(56012099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?FpW1Wf2Ajty79E/OFmmU4cFneeqNTSr+upBCEAeGW49c36eqSYGHBL9qfOw6?=
 =?us-ascii?Q?2InDIfzrkztRhzUW9DdW0wtqLUdyLWj8YBBNIlUESp1njMtiSMds1HC7SJRE?=
 =?us-ascii?Q?oUZvx96u8cCNPirvbdVg7tfav6uHFQVxH2gwq1zQRPTHXPyH7izGfk6Iv4hg?=
 =?us-ascii?Q?17c9FYigDdz4jZttZ5fHO6Gz7KGL9sYSmvMSOregTeaiOjkJlnrbMWsa0kpx?=
 =?us-ascii?Q?Ixq45XsjEvuUqdEVQnyVIWi5716/2+Sx4zv176CV0ouwLyf8fspaDsMYm5vS?=
 =?us-ascii?Q?Um0ke6qgruQjKKHSBVp1bCu6QgfiP27EKQzUuW4Sut9HvOpZizyihjxdKe9S?=
 =?us-ascii?Q?8XwkrxtP6hKvpC1e+2iLO+b81jOKOEqrYn1KtIbnB0JkfxRLLZuiJuibWYES?=
 =?us-ascii?Q?CwbeSF1ZuJ43r5dJxWjR3np29+OY4B8SneTzmmSXU8NIfE/bTrEG99x/rGi4?=
 =?us-ascii?Q?2TRYbrdAo7VxlyKx/hNrJw1Mn8TvvB5mqwfLHgkPirHKD6SqlqvUBl7tyMdR?=
 =?us-ascii?Q?hShMV/qSCRq65N817/g2sJRBtfkZjAW/o/sNwlfNmicf8e4rw4OQXsek3vwT?=
 =?us-ascii?Q?YSbMdf1JJKswkY1+53P2rPxdqaZspOQyjr21s/H/ss/F/kwJS28Jn93URpl/?=
 =?us-ascii?Q?JziBHiQ84dOQcNkTU104rLhGn9JVfrYocy1mqZtS5lJg0IfxplvVyKwBox5Z?=
 =?us-ascii?Q?PzTlq+/n2uWwtwOneCJ45rjvc8GHUIiRfNnDrjWk9Zecz7FdpgfWZnuBPKUM?=
 =?us-ascii?Q?YpJ88YIJwECmXNiUmeui2R7Pl5wY92mZSL1QTq6JE5dk3dzcqlzqxhb+O/rT?=
 =?us-ascii?Q?iShQX61Ne5fnQ1d0nkRRiZoHyUHKHsLXVUSTM7VP708ehX4ege/MGEElKOoD?=
 =?us-ascii?Q?hb59lED7R81CCGDEyK3svGKednepZhWkZfs/ggib8PxPzIu4NEJlUAkSuhz1?=
 =?us-ascii?Q?UPIHm/Gc7E4QAgws+EnYaUwMlv9gKrgKD2gSedkx7SB+bDu1vNJki94oK/kw?=
 =?us-ascii?Q?bszf+4uLIe9CsRoPVFoS6VE07yOEvBrqoYlsL8mipkrHNJaSKmzeJ4jbkQ2i?=
 =?us-ascii?Q?pQJs+HTtJdlOVyfU9REQhBYlM50Ym21H8vyzIrr7PGE0QwU3XZNzLyabZjK0?=
 =?us-ascii?Q?q18DjRVc6b1nMJl3YanZyXZ7N5+VfNdJqbYTpx5PJCZof+3+nTyiIZbRV/5B?=
 =?us-ascii?Q?UfFwiqJfgUwtB06vQe+sGe6GRt7HV8nUoYLzGSzPKEzcyU8JswoiTqECRvrW?=
 =?us-ascii?Q?Gq6ONKI+qQ+y1uwA045SumsTB3K9zweUqayYJ0v0HceQXeuaWpDGgDAtmgT6?=
 =?us-ascii?Q?rkxl5oe2m2kTSn/bmjOhOrsYVi7m97RLHMHHX/Vkn8AXATb6ZhGThMCAJluU?=
 =?us-ascii?Q?ri8UUinlDDMGGPwVUgPVU5Ei3K+7YeQk4ANOVTfHc3cdGQCnpidW1wxtsajv?=
 =?us-ascii?Q?CgDC024M2UxQszv8i2C/hQix2mzyc4Ljo0MjsLlDiSo8PUEPCidxLc3QVBM3?=
 =?us-ascii?Q?NRim9m2tI10oV103drZZAG20hbr8Vt44lnDEICBWxMIuyZQlZqQQW6cifnoa?=
 =?us-ascii?Q?4m2rSMcxbA9bys+fxBrzXAXlFaYPGFG2c2t7/s5SIdLv8I4gyFLyhun9Y4B7?=
 =?us-ascii?Q?vbgqKfka+eTVgN6+Al0PSWzV3nlKPduEAw0VjNwTgAABW2wFF7BjJLaoFeV/?=
 =?us-ascii?Q?2IqnlOevyRHuNVN78H0InHPCD2Q5qsNgrMOsx7RJ/gTvm4U+Utoxe5NrijDZ?=
 =?us-ascii?Q?FeK62cGUbQ=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a21175ec-86d2-45eb-ecb4-08de999d3503
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Apr 2026 20:42:41.2466
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ICc2eUsNxA8nXHqFy7a4AyZcTQeluNkksDkFbtP/4KoSybkSoA4+ZDjrpOxoae6w
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB8727
X-Rspam-User: 
X-Stat-Signature: zparonht6s37tey9hzeh3drd1ozbe9ei
X-Rspamd-Queue-Id: 96E3F180005
X-Rspamd-Server: rspam09
X-HE-Tag: 1776112968-974144
X-HE-Meta: U2FsdGVkX18A4AAggEOX2Ou4e7DXvJJGbESsC0LlT6Ry8jf5KbfJkj4p6wu8BELqPUHfBPg597ueSldU/nXToQQIfUEPheoSWET5z+5NQodXSS+MQLUMB2EZZ6jDfFQEVnOXNnHzCNW7ERKX5Twbpv+STgKQWRxQ47XyZpYRngDr4L6tZZSiaiLCYB+Zjs0r62+p5UlBKHwVNA7vN47qP1pvrj8PB48d86F1dVja3IYeT8BLzAHez6pneVKURq1HgzGJTpwqLwuOch5e94KqdJObBtjmwQtZH2a0hzIPzbUANidW0kQMliZ/P93psKHU+Qh1qT4jePy13uPowpoZvIx9X4KnEeRcIjGt2xj7qk+7dnUGi8RnupduD/1wwXePiyfCva172ZGKllBwBLeOKUGjdAF/Da/ocDm4pksmRx16osOr/TUAHRpqZpdll3SEKnDhJStmtVHNddtdiVXDqFVhfzBJeIWSaEcyOhYX6y7oeY290DJvnyOHO2vxpJVXw8dTVDDDTVs3WM7wbRVbxFZRvdgW8O3Z9BJRK4BzbFD6HtrP5kBWrm2I9cUit7/hFKDz7vNj4jjIjoOS7PyAuQEGrzaUiSrrZmLyUW1f7M88EgZUSU4OnVFbY1efvJ86gIrEyvlvoZWtRiLbaOT22igQPPb2UTWAIANtEmyvL7vm9uhtxh5WP3h6opRmPxWhDv+EDBZ55LO2zQyhqs4nRS6RFu4PdWqsmR4BlEIqZZVk2glc/IuoG5L+4+Qj511gLIjz7fFjYr9nP0IS0FBmwXNBbuFkU1z8rqpOG3dh/OZXV4KNBzM7i+HBfpZOfEXPVu/8ZYoAUZNDugJ2LpYFE3rTKAPPaxmXG2mF4XIbzD5YdUfCY3vJ8gPWCDhzHQlsETIPufBD7ruVaQc0OaYH0zqAg7jqKONOZrBtOD80TKRJUWRxSAkaNwkB4CzV23xibKbm9ECNNv2ja5Ddx9K
 E4sI+oIS
 xKxxCeX3Jme0/G2xGFawxvEztEE5aFKctaeXw5vxSwpwF4dGqXoIaSP3Ex+IwYvIKAMWXYto73LmNJtWmBC8hzLwur+UK/CDy9mxbfxzggx4y6+HQBhgvNJAIEShiNSX2lDCcsw+r58Tez1ozw8RMz34KJ2lcIIwOqSOtCdle3xLKAkLo+fF/PuZC1DswLnSv2+F3IUiOzR0ZPjYiK2Zqwz6CL3VqJP5DagiDzn8Q6ehBsShs3uZ0ZnKnjWWhzOJSkw3+NQBGxLng0xXptPzAtK6q1ocNyqOKeDMx54Mbt9V93nPmmpPBnfEhEo+E452x1bLqqG7yrid1x2+T+ZQ0mZDwaWk5/PlLdIgTIxoxXepybLAmb2n4ias6fw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 13 Apr 2026, at 16:33, Matthew Wilcox wrote:

> On Mon, Apr 13, 2026 at 03:20:23PM -0400, Zi Yan wrote:
>> After READ_ONLY_THP_FOR_FS Kconfig is removed, this check becomes dead
>> code.
>>
>> This changes hugepage_pmd_enabled() semantics. Previously, with
>> READ_ONLY_THP_FOR_FS enabled, hugepage_pmd_enabled() returned true whenever
>> /sys/kernel/mm/transparent_hugepage/enabled was set to "always" or
>> "madvise".
>>
>> After this change, hugepage_pmd_enabled() is governed only by the anon and
>> shmem PMD THP controls. As a result, khugepaged collapse for file-backed
>> folios no longer runs unconditionally under the top-level THP setting, and
>> now depends on the anon/shmem PMD configuration.
>
> This seems like it'll turn off khugepaged too easily.  I would have
> thought we'd want:
>
> -	if (IS_ENABLED(CONFIG_READ_ONLY_THP_FOR_FS) &&
> -	    hugepage_global_enabled())
> +	if (hugepage_global_enabled())
>  		return true;

I thought about this, but it means khugepaged is turned on regardless of
anon and shmem configs. I tend to think the original code was a bug,
since enabling CONFIG_READ_ONLY_THP_FOR_FS would enable khugepaged all
the time.

>
> ... or maybe this whole thing could be simplified?

Alternatives could be:
1. to add a file-backed khhugepaged config, but another sysfs?
2. to replace hugepage_pmd_enabled() with hugepage_global_enabled()
   and let thp_vma_allowable_order() in collapse_scan_mm_slot()
   skip not qualified VMAs, but that would waste extra CPU cycles
   for scanning. Maybe not too much waste.



Best Regards,
Yan, Zi

