Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 56235C624D4
	for <linux-mm@archiver.kernel.org>; Wed,  2 Sep 2026 17:02:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 46DF86B00A4; Wed,  2 Sep 2026 13:02:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4459C6B00A5; Wed,  2 Sep 2026 13:02:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3353E6B00A6; Wed,  2 Sep 2026 13:02:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 00B1E6B00A4
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 13:02:43 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 87C08C02AE
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 17:02:43 +0000 (UTC)
X-FDA: 85169441406.09.C8411FF
Received: from CO1PR03CU002.outbound.protection.outlook.com (mail-westus2azon11010015.outbound.protection.outlook.com [52.101.46.15])
	by imf10.hostedemail.com (Postfix) with ESMTP id C2D1AC0007
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 17:02:38 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=FGW5OAap;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf10.hostedemail.com: domain of ziy@nvidia.com designates 52.101.46.15 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1788368560;
	b=zrpdvSrsYplVJRlRO6vjQaZyPPPvyUUtgdCGEWOmbb5s0tYm248TUzVjHc3R0gRHhGhFq+
	LoSpqRgnjsRa2dkkiBJozUxXD/f2kOkXP4lWueIwq/mp3Zv+LyR7/LCrs+HTSU3Y1yNRU6
	6dYOg5i3W8fWOH+eIeUl/1Xemv9HrUM=
ARC-Authentication-Results: i=2;
	imf10.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=FGW5OAap;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf10.hostedemail.com: domain of ziy@nvidia.com designates 52.101.46.15 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788368560;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ykq+x+bVasKPYf2IiPSl+IrgBFv5mOW2J5YDbo5U/pk=;
	b=WW6fNnHaNQzJNBA8EOHFNTy3nRq63VHYmBRsZYgpWdc6vKkLSl/T05k2qP5Gm5GIhdRg3D
	GIim967UEOHxBOrvrkGDF0DKFqAmJt8QUva+CSS2432mLhgBbxdI1A3+5n4sEVYR7vQZOl
	4qfy2/TOZN2gEObTSuwcRXBa8IuvXM8=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=TKqFIj95N00K1VOFceoHwlolK4mhmL/f+KjzRSrZBbNgksRlOucuRujo78Z+CIVrlQ4P5wJdGLyDDfHwnWAD+1G0yIyahVigigijSEI45DQ+Fwa/GIvg/52rNjeLsR5v+Sd2yvLEChI/6I2RSsjQvyZNJuGPzARjSJx2mi2rLf7V95G68wOfJWUysIDOIII02x7MrHU8rhKV1+tgTO8uu9jdFh7mbA+IKOEyVqLXEA+cXG446Kffn8wFMrK1Je+PCvgE596pfUAKocGPztUTOFZMwqm5ij0rLsYcE8lfbTAyGetwBk8/Dc+56iXPsVdgw6XdSHSngElqDvlODAwbHw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ykq+x+bVasKPYf2IiPSl+IrgBFv5mOW2J5YDbo5U/pk=;
 b=PUnfqmFIDyUgVHNONahA6FaZsC2fTZH3a1dLHnrReSkT1g21OB8kdc7JcesvEy/OalOmcvctcj07/k4UI5VhggF0zOfP9yoIMtwU9q7z7uzOBaxwFzCoSWpYP9JKQXW+oiYfER5K+cgueJKhVb+C0nzXTfHSnK2mTDWSY3ecS8YxFaL4xLL3flX5NNAhwyZUSI2A20bwqPhRhyWi6A+VmYHz2HwLTYMfX3jpUCwqiT6hajC5AwYrXJG+UvZ2E1HQHlNCKonSFI7TVmnSTeW3eF2JfizOrNCBRqBOuKovU3PoVUrmQCLof8wFFL6rR3D4Ei2HXGMl7b+e5FWfdapKVg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ykq+x+bVasKPYf2IiPSl+IrgBFv5mOW2J5YDbo5U/pk=;
 b=FGW5OAapKhsObx7O+8o0asnTKiNcFYYPOJADWeZvNWrALU9LiNM2h5Hx5geNr7ygvA5Yl3mMNE/42h/nNBfVODu2fkLZcyrzTzY4lKVuNZcE+GRJG8QRivhTuKfVe4jylC4ZdYAFpY1AChHyxXSAN5OA2eLi/p2kww2uNgYdU6EG6zhmvb76nUkpri27ypIVh7mvlzqTF0VUQlBrmjpG9N71zvPV9doZMilhISmeifMvjmWJBKLMtxzeXB2TDXKj7a+NJV0/STd1eE8u4pBi7toUv8u663jooyUns9ob6kPD5MWLL+A/1mpYTSPCmzsl+DhDUEJc0o8zyW0nrYZNSQ==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by LVUPR12MB999184.namprd12.prod.outlook.com (2603:10b6:408:3a3::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.360.13; Wed, 2 Sep
 2026 17:02:31 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%5]) with mapi id 15.21.0360.008; Wed, 2 Sep 2026
 17:02:31 +0000
From: Zi Yan <ziy@nvidia.com>
To: Usama Arif <usama.arif@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Nimrod Oren <noren@nvidia.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <liam@infradead.org>, Nico Pache <nico.pache@linux.dev>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Kiryl Shutsemau <kas@kernel.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Brendan Jackman <brendan.jackman@linux.dev>,
 Hugh Dickins <hughd@google.com>, Nirmoy Das <nirmoyd@nvidia.com>,
 Dragos Tatulea <dtatulea@nvidia.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] mm: remove min_free_kbytes adjustment for THP
Date: Wed, 02 Sep 2026 13:02:29 -0400
X-Mailer: MailMate (3.0r7027)
Message-ID: <A36CC394-0954-437A-B408-359C548DA3E1@nvidia.com>
In-Reply-To: <583c4718-f763-41f0-b757-02b46655c0b5@linux.dev>
References: <20260901190123.3511535-1-noren@nvidia.com>
 <20260901204449.GK3004@cmpxchg.org>
 <C8541A2F-D6A9-41B0-A3FE-52339A6601F0@nvidia.com>
 <20260901220917.GM3004@cmpxchg.org>
 <69C018F5-A1C8-47AD-9567-3497AA6808EC@nvidia.com>
 <20260902160417.GN3004@cmpxchg.org>
 <583c4718-f763-41f0-b757-02b46655c0b5@linux.dev>
Content-Type: text/plain
X-MS-Reactions: disallow
X-ClientProxiedBy: BN9PR03CA0651.namprd03.prod.outlook.com
 (2603:10b6:408:13b::26) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|LVUPR12MB999184:EE_
X-MS-Office365-Filtering-Correlation-Id: 54132fcd-b8b7-4cf1-da10-08df0913f9ee
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|23010399003|376014|7416014|18002099003|22082099003|56012099006|10067099003|4143699003|11063799006;
X-Microsoft-Antispam-Message-Info:
	TCFaz73f4IXtAl6rHzMxR8nFG/ym5lTSordbGx+Wu0IznVwOKp7LEMLVzjC5tKpKS09CRyRi6yFwQZkM85/pct20v7yP90CaN55DjNP5mX4oL1EtzA28qwbiS8A745HSFExgt7b8PgCxPvfRV9NkRH0zhnMSnjWjEUibFgvxQYSp98fJ/5Fw4mkoF/rdk5U2LFAL/z9PUOgPZMT/rWNmU6Ychicw0+egq5WI3y7S0mpGA8vtLUPYownpxtH6wbyS8O/FNN18CKFdt3JypXZC7Vvah+NWS7hX52S7ocgR3eGAR+OA7nzkNELPtqXoVDpQ85cMYXUJ+bK/7HnUiaR2irpAHqSrvYR/vNwJxlIQfl+NlpI23CeNoougziB/GMEWbKcrXKS5qKDhIE5ZMc/FP17wJ5lYJWiv+qTydIFJ1yQqqvQXIY3dvMFLxET8gLpPE4SycaV5iIvjSrls/jGdmRdMVn3YoMG0tQpWbmKdbJzdPNjx9vr/uzFcHz6PLFdaemr4GqEwngKokuKnJnGOVTtOKUjIg7t+C20KzrO1c9iBcf2Pw4C2WVzf8Etzdr7avjRIHwcgCiPUhz781/pTKPsSv3smOQ+NXpA0GX25e+yg/cJxwkLV57tXtWoWPtRPP8IYrE8YvVi1L3+JzTi+R9SpDQOU/GLI8BrzEY/DdtM=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(23010399003)(376014)(7416014)(18002099003)(22082099003)(56012099006)(10067099003)(4143699003)(11063799006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?ZUlLlE10bSBGjVw3TzpeTT+39Dxw9Td165p1kR1VNbBkXF+Il7vuRzQF4t1C?=
 =?us-ascii?Q?0D0wKGPhA1Ez8HcDQ42o6rbamiuznOEKw/ItNizLIMTcAuvy7PakwZA0BzrY?=
 =?us-ascii?Q?KEAEteMmXvZ+46oF4buaK9tG5z86sfyUj59ZbDY+fHyquVFAkjGwZC+e2pAG?=
 =?us-ascii?Q?8fR+zmifOnZF+BV8HJOGpf9A+XIH7yYsSRFu0Er7jc+gfx6ZrcdGxc1sZXdF?=
 =?us-ascii?Q?XkGcnBR/SHYvBhtBhnxP9+gHk67lmyD1h00C07u7sRChAN0LkGjGdd4O4L+q?=
 =?us-ascii?Q?+7b8OoiPuofbO6QjoG28+XXvdc7nOg++ZS0wEQvNbO4kyvG57NuL/tW4QQDv?=
 =?us-ascii?Q?yw4M9GaeUnysYGCLFqEymLyikGJafR/6x+KBnNrxgSms/t4xv8GHLcf3QVy0?=
 =?us-ascii?Q?3KtuHDtiKtwoDDseE4KsyCpfUycsd2sRZ3cl4qtq5smRmcNdrW9mtpaviKLY?=
 =?us-ascii?Q?EzwvdmOcwXA2ViisKV08GlUIeG0HiWFNfo9VUlfEuWJ/KhUWNlhM3Bowuuyx?=
 =?us-ascii?Q?RCuWIKM6G1Rl7LaVENqO4VOswUJ2Epqn3QB79iPKnJUf2dwxxHMspLrMOPlZ?=
 =?us-ascii?Q?TjnrazrT2jdwZjRGAqz2j9SEHiH0qqjsZG3jlYXy4FfeSmi3TCXm634X9tgN?=
 =?us-ascii?Q?hC1a2bd46+4Nj0/d1fijQztJ8RuAXBDRf7kzyVTkenzgPrekLitlQ6BnSiMs?=
 =?us-ascii?Q?Jit4Xam+J1UCNgxWVxFIkg9iXm9Avk9RMl4RiSGv1rgY2UNeincTBxiUhvXy?=
 =?us-ascii?Q?Fh1pw1EbWdWa6UhKenfJDopXcOr0WaT9jS8z30NePf+mgAutwDxu+khp4Z1F?=
 =?us-ascii?Q?nH6xwTzQTR7b04+3cuB7YnBi50/O1znmxXN1o4fHoN3TPocDqGXaxKRbgTFk?=
 =?us-ascii?Q?Hr64q3ip7qDBPzeMKmZ3rCJa6sgSpIR532wk5eMWh8BHsHC6b7JiK4OO7NIL?=
 =?us-ascii?Q?2kOiJMy9PTh+UPIKEGLhbi/W4LTHWulPllpEzzq7auI5JoN9sT7Je/swDAss?=
 =?us-ascii?Q?kwT7Gz8ZGDAUEe2Esxq+5+YfXjPnxN0vpfTpPoL6ckQuKfchE864XcznjsSB?=
 =?us-ascii?Q?IFGW3iCNHv/4GMQYRceSF6wocEszNzwhzMUva5u2cq9MxprFMvH/svzJ6lyp?=
 =?us-ascii?Q?a7yRl8IH89+pZSlgOjSNl7TLuoQ/uVyCV5tGj7NOkt1LwwqQyiZqo6QGyTbv?=
 =?us-ascii?Q?5Y1N8Jm1+pTKCld09auKnDJyRO7nf3Bcj1VYJorg1EyRz2+XTlOUj0MsOKkb?=
 =?us-ascii?Q?jzgMkRIkrY4havmO6xMfNsfmvu3nC53moHBUNailmb6ihPmfnWF7C/wJf6w+?=
 =?us-ascii?Q?Fveojc7KjFR8/P+rOFQspEG9YS1/TTwJPh4VvQ3UOaTSXdkbQT6jbQ3ar96F?=
 =?us-ascii?Q?ZWu7048IIqJPW/krOx1inMzrVWxDfPiuQa93AVksyWsmw+1s3ZF2Z7Kr9YYY?=
 =?us-ascii?Q?OCsePCEoTzQLLG3Wg20lvhU7memZKHTkVnva08wQqce7kAO5DWsWORpYzw+Y?=
 =?us-ascii?Q?9zuuPefJjZ0QwNQ6+cnTYcM42teL4XnDTG7zztiKaBb5w3enAaRCUB3chjSX?=
 =?us-ascii?Q?3F8GWIvnU0gQTw25smFY1EebFCz7QrMejeIL3dc+rBvFwazD53j/WyXy2q6D?=
 =?us-ascii?Q?5WmIcE3qrlSRvKNjddhne3x8RMgNS5i1fP77RVJR9Y7DGW5bqNsijwijXYAz?=
 =?us-ascii?Q?9Nsd+tuWyJJflabtv2Hm4TvCAT8pywj8jj1Vy1D3rDKfVo/wBX7KhvG6N0f5?=
 =?us-ascii?Q?QfJZ2wb3iA=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 54132fcd-b8b7-4cf1-da10-08df0913f9ee
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Sep 2026 17:02:31.3800
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: J0ekAHIeBHZiRMuoPn6F6YT800XJjCrKeCruOgjJQSbVYIIhGDT1h5Y6odiEmcbF
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LVUPR12MB999184
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: C2D1AC0007
X-Stat-Signature: c81x6ejknbx83utdsnenpjdtzhadst9m
X-Rspam-User: 
X-HE-Tag: 1788368558-971965
X-HE-Meta: U2FsdGVkX1/ZUa+vI0K3qPsvZj4QMBvMB1FYo/ZJ32ewaPRiWCUF+f4iUh7kqa98kP3nD7p9+P+RDoBEWXCDL+7Kg9pYAkrtSTOVVVN3cmLvtIDggAmLsCF7xEjwy/1CZdArAqMBfb+KLrLpDNB3F3ERmeqK4GUG2/M8/SRvEffELtOWSKXixrQDpIaamHhsC3Rbw6WZ6bNBTruqU2cXnwjOvbrKltB3nctdNd+pqEQfUBHhuJaT6b4DUBk2r8whxxoP2RyhJYjtZliYEgRdpeXiVbd1Drf4AAHi5WAJcX/xpo4T+nAcvYML3LHUhq2ojoXFGOVsW1l6z1VvTgGLe2R06l5RuFGzxUWEhKPUnA6tUkp75a/m1v8yx1fXAPX0FKWx1aKfpShf6ZZVao7EWFsUsQgJ6YSTQwLrjrk9kuAqF+sQItJBvui7HvtC5LP5euS7acyN45PIGOxJ8LHa10jV0gQWj9g0ZfDZIPwln3ZasR68FOHPU25b7KsB5kZgwKIGMnGNASkcCfmX2bR9kLHgB1ms/GjAl969p11LrC1SYlt6uE546FVohmpmOWW2pMU+cERoHQ4p4I4882734P1E2YTLEZoSF/v2A0oFbNNQjf25KD0RaMtDMFi5qAT2sCR5b0+W5Tc/Fk9gUNGkpxmkA6/ENdmifaz3hAWrQUYYTpJa5N8zTdPBAkaaP7G7B8kW5bNVx4wAm/LneSPbB0Gb0dShWo6jgDNS/wE0F3eirdyvA0aAYJDLuJVP+t3qXXrr8/2jfjhcdj96k38pE2sRyyDM0YQzfoiAbZg701Pktcb6SzMc1U1lLBGHC8drs45AiIyWYCtwJz8NKIz2hOxJkwHMZJIfe5fsSUoBxynJXZnWLyAIEJzt0m7h5Q4NgiZub3QzoiaNiNxMuRMFUHRKEUcKvxOoEy+0vN7vl5BxKyk5Fi0771Lf+dlDjHGbbIyNMTs+RjG8Hh+5SpE
 FyrdVBkS
 cZPukCKiNZ6E44TTUy4f1QI6KtxYMWNODXpbfOGDwCLGrQ4vrnc0fjgUxTm1z0C5t++fOLlM9tOoYYAZBu/0pKYsbqZP2M20mXWEKEhLOmi04DHGyxK25a9cXyNrEfsxiWd1twkEkxECsIAqFqKyXbTLfqhuQnQS2TBUP3YiPPmgKFPI7BY+97qm1co6J9NRwyI7jPUdZiI4gMWr2DwNwo3yDJSnXlkWwSI+9BevyeqkoK+LsF63Q/YOQ9dzTdYjswLSFtfOhd6PveCf8XeDOuiF4VXjGUT2MrQXtPnEEcKvsQN75Bc+O5VTD/hU87ZPYtUmedrZgJk3DwqAdTzEljzGalB/23EQBSQNiK5FXwZOu7ym7GhUlNtdIy7DX4rsksJqvJ5kk5/2jkH10pqFpUKdZFF0QbJqdS6Nn
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2 Sep 2026, at 12:47, Usama Arif wrote:

> On 02/09/2026 17:04, Johannes Weiner wrote:
>> On Tue, Sep 01, 2026 at 09:49:58PM -0400, Zi Yan wrote:
>>> On 1 Sep 2026, at 18:09, Johannes Weiner wrote:
>>>
>>>> On Tue, Sep 01, 2026 at 05:09:52PM -0400, Zi Yan wrote:
>>>>> On 1 Sep 2026, at 16:44, Johannes Weiner wrote:
>>>>>
>>>>>> On Tue, Sep 01, 2026 at 10:01:23PM +0300, Nimrod Oren wrote:
>>>>>>> When THP is enabled, set_recommended_min_free_kbytes() may raise
>>>>>>> min_free_kbytes using a heuristic that scales with pageblock_nr_pages.
>>>>>>> Commit f000565adb77 ("thp: set recommended min free kbytes") added this
>>>>>>> heuristic to help keep pageblocks free and reduce fragmentation for THP
>>>>>>> allocations.
>>>>>>
>>>>>> We've had problems with compaction before when min_free_kbytes was too
>>>>>> small on large machines. Competing free space scanners do a lot of
>>>>>> work only to fight over a very small set of possible target pages.
>>>>>>
>>>>>> So I'm a bit uneasy that you didn't include any benchmark numbers with
>>>>>> this that prove basic functionality on larger hosts isn't regressed.
>>>>>>
>>>>>>> The recommendation scales poorly with larger base page sizes. With the
>>>>>>> default arm64 pageblock sizes, the contribution per eligible zone
>>>>>>> before applying the existing cap of 5% of low memory is:
>>>>>>>
>>>>>>>   4 KiB pages:   2 MiB pageblock,   22 MiB per zone
>>>>>>>  16 KiB pages:  32 MiB pageblock,  352 MiB per zone
>>>>>>>  64 KiB pages: 512 MiB pageblock,  5.5 GiB per zone
>>>>>>
>>>>>> I question whether pageblocks need to be 512M on those machines to
>>>>>> begin with. After this patch, you're still asking the page allocator
>>>>>> to optimize grouping such that 512M pages can be allocated at
>>>>>> runtime. Only now you took away part of the mechanism to do so.
>>>>>>
>>>>>> If you're using 512M THPs, I would kind of assume it's on machines
>>>>>> with a memory size where 5.5G for defrag purposes isn't devastating.
>>>>>>
>>>>>> And if you're not, it would make more sense to lower the pageblock
>>>>>> size to the mTHP size you're actually using. And that would fix the
>>>>>> "excessive" min_free_kbytes issue as well.
>>>>>
>>>>> But lowering pageblock size requires a kernel compilation. That means
>>>>> maintaining two sets of kernels for different needs.
>>>>
>>>> That depends on whether anyone actually wants 512M pageblocks...
>>>>
>>>>> The ultimate solution is to enable better compaction to generate
>>>>> THPs bigger than a pageblock size, like Rik's super-pageblock
>>>>> proposal.
>>>>
>>>> ...or whether we can say, at that point, use gigablocks/cma+hugetlb.
>>>>
>>>> And then the static pageblock size for the fallback logic etc. can be
>>>> a smaller, saner default for everybody.
>>>>
>>>> Because the point you didn't address: it doesn't make really sense to
>>>> have 512M pageblocks on smaller machines, beyond the min_free_kbytes
>>>> issue: Fragmentation events will poison half a gig at once,
>>>> should_try_claim_block() becomes harder which results in less
>>>> conversions and more allocations falling through to stealing, page
>>>> isolation is more likely to fail, compaction locks and operates on
>>>> oversized chunks which is bad for latency and concurrency...
>>>
>>> I actually wonder why such a big pageblock would still result in a lot
>>> of fallbacks.
>>
>> If you look at try_to_claim_block(), you need half of a block to be
>> free or compatible with the requested migratetype in order to convert
>> it. When memory is full, LRU pages are scattered all over, and
>> compaction is not involved (order-0), this gets more difficult the
>> bigger the block is. You can get into a situation where LRU reclaim
>> will not clear sufficient room for conversion in any given pageblock
>> anymore and you're stuck with the type distribution. A large share of
>> buddy requests then go permanently through the slower fallback path.
>>
>> Usama knows more about this, but we have seen this on GB300 hosts, and
>> have JUST started to deploy kernels with smaller pageblocks (2M).
>
> Yes, just to confirm above, unfortunately, there were too many problems
> we were seeing in Meta production with 512M pageblock size for arm 64K
> base page size and just had to switch to 2M.

Do you mind elaborating on the problems? Johannes has given good arguments.
I would like to hear more from you, since he said you know more about the
issues.

Thanks.


Best Regards,
Yan, Zi

