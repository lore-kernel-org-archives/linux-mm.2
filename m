Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 768F0C43458
	for <linux-mm@archiver.kernel.org>; Mon, 29 Jun 2026 16:50:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 956DA6B0136; Mon, 29 Jun 2026 12:50:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8D00C6B0138; Mon, 29 Jun 2026 12:50:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6117A6B0139; Mon, 29 Jun 2026 12:50:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 2F9846B0136
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 12:50:16 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id A159EA01F5
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 16:50:15 +0000 (UTC)
X-FDA: 84933537990.12.B54B01C
Received: from BL2PR02CU003.outbound.protection.outlook.com (mail-eastusazon11011044.outbound.protection.outlook.com [52.101.52.44])
	by imf01.hostedemail.com (Postfix) with ESMTP id CDF534000A
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 16:50:12 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=NKsVBnCj;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf01.hostedemail.com: domain of ziy@nvidia.com designates 52.101.52.44 as permitted sender) smtp.mailfrom=ziy@nvidia.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1782751813;
	b=eoNeh5B31zzbbmqc4qvpYj0t58V3Ig+Vg+ZEzUTX4ACdYyy5jAn9zP4k75UzUTHEhFFezZ
	c/C9zj6zDkYyLM/X/DXn3wRJthLaInmluIAzjOTdYyzet4DHr96fK612a2amzeaSTd0+Wo
	9fd1qNXMDmbv/MhABEubuwuglJ8DWzc=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782751813;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qbMApo9wyFK6JvQp5N9dy/+kCeenfVg0MRFUlbt74yA=;
	b=Qw+fdrrHWzR1Wojx6RfOZ6mnA/bjTqs5LtrdauDsmIucKT6NiStUopgCZ7QUFgP1/oiPD3
	Dbr2cu3qOPi/R6p1RP0/X63ZTyb73ytekSKEp61VJzIe7yc6aUBWAI+2jUjVyXllaqzGVx
	+pU/Ac0sUyqbcOkFO0C9HFdTrAbGihA=
ARC-Authentication-Results: i=2;
	imf01.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=NKsVBnCj;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf01.hostedemail.com: domain of ziy@nvidia.com designates 52.101.52.44 as permitted sender) smtp.mailfrom=ziy@nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=PATUgDysF94q5N85bxjjb91UBb10IV/kZhrASccYGFHLZW/yafJrdixXfziiggrfW5nDZjFKDxsz0e8EveNOuMTi1bjrVCjbMAU1jxOvgQIby0icic2pTPcz9RmP0EQcg6K33V/7zMTNdSwKmYY4BCyqo5MtWkRczLus8NNzSGNINHTpn4rweFb61Z0hDhibFbtLwDiOgU5I3MSoWNH93aNrA6D5MBvUWf0KU1QPC8G0i5MOxp20/SyX6WD5dgvQBkPu09DUKkbw1Bzsn2IU0kKrNOPIri5Y1uWzVEVHzBJvxFfISocRcjV3Cc4tkYnew3PcLLm9i9+pmbyk7mJ4Uw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qbMApo9wyFK6JvQp5N9dy/+kCeenfVg0MRFUlbt74yA=;
 b=n+Lbid72EsI5xL2XKsDQX6uhx80K0mcrqq2XKZfEG+9WkVqlqEl6PDU14HNMqXDjnjyIMPwwT4M1JH0xrHJBvregURp7j6U1zAKJtu/lzfrzY1UIRJ0+mrZZ4E1ksr4mARPBLfPUaQsVZDdMfQ0q+gvEIEjpbx5OiHWLMUswrMs3J3YzA6fE3Y2Tr9q3vZixhtwD57s1rV3QTv0t03Ldh2hQavDpwJy9nnzbWK74RugX8yoLbuTKAKXJsNPkXAZ3P4nUbNvVSApCNXVFRRsgIPndw3YaaJ3N8Nd0Lt91G7I+CNhSME/oYdXK6gHjMMVyx7NpMuQHEQl77RFtAN8LDg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qbMApo9wyFK6JvQp5N9dy/+kCeenfVg0MRFUlbt74yA=;
 b=NKsVBnCjPwRrnEnLhGQtfGA8ZK5fElFrx2QYPtE7ZFpGG1yhnVgN7uMrZ4tRiyj8MMk5oKwR7lHC/Ekiqxp/bBQbN+QRF2f3YWbFxqFRx+Sr0QAmuU2+oSEI1RNsIGYQsj4PowBuK8EkMXVpRjcNgz5tGajGoi6lao8xipXPstcR/mdZk6Yr03UBc4iOdcypBJMIG8WFjgWCedwjaW4BxXr62V6XmCgiWogEGqewkNAtUSL1/sJM+r3OMEPP3kntR05P11zrsd5vND0NoMsJxsuRsWZvIB2HPtdBGasN4UHDFYA5grnqwEwYnzuiDLCY59NUUxMqsGNwailR6yclMQ==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by CYXPR12MB9442.namprd12.prod.outlook.com (2603:10b6:930:e3::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.159.19; Mon, 29 Jun
 2026 16:50:06 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%5]) with mapi id 15.21.0159.018; Mon, 29 Jun 2026
 16:50:06 +0000
From: Zi Yan <ziy@nvidia.com>
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Brendan Jackman <jackmanb@google.com>, Johannes Weiner <hannes@cmpxchg.org>,
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <liam@infradead.org>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Mike Rapoport <rppt@kernel.org>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/4] mm/page_alloc: remove set_page_private() in
 prep_compound_tail()
Date: Mon, 29 Jun 2026 12:50:04 -0400
X-Mailer: MailMate (2.0r6290)
Message-ID: <C3BD17B2-E081-4F71-BD5E-FCFF46F31FF4@nvidia.com>
In-Reply-To: <8b74962d-8dcd-42c9-bf97-7d6b83b52c84@kernel.org>
References: <20260628-keep-subpage-private-zero-at-free-v1-0-f4ce3930d10f@nvidia.com>
 <20260628-keep-subpage-private-zero-at-free-v1-4-f4ce3930d10f@nvidia.com>
 <8b74962d-8dcd-42c9-bf97-7d6b83b52c84@kernel.org>
Content-Type: text/plain
X-ClientProxiedBy: MN2PR07CA0020.namprd07.prod.outlook.com
 (2603:10b6:208:1a0::30) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|CYXPR12MB9442:EE_
X-MS-Office365-Filtering-Correlation-Id: c18810d1-30bf-4608-0b07-08ded5fe78c6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|7416014|376014|1800799024|366016|4143699003|56012099006|6133799003|11063799006|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	D+BYG+GJMVa0LRRyN57TdW6QOBRBsSHe5BjDs5MWRMpx5T+hBwazv75iiBJRcUh1qXWhOZikpA4nybJjIVHb+oRN9+sXMsF2wv9bn3BfiQRtJubXNKAgwaDf8An45m3K9c7poPn2ScH9+00SR3mNjWqyX6D9MRkECqVqo13T3uIvoNxReNiA6MxvgC/7dqniAAurjBmMG1kZNlkUmEqSp/bYf0UPQBa9dcaeo6ZgVLojWRiIQwob4QDJyYaXiFy65h7t/CeNBgzpcvqjq+m0Z7KyLq1qo6cOGZlqf7H8J6tDQ3/aJFEi4ND1g/GURTs+VD8VhZ4d7FYsro5ioDs6yqrvOMIsiJzmcQ9kN+d3KcNjnpSfSPLlv8Aru5rzxs1YoX3NKXBX44i5mwd9WsZ2w1+gOPfnHVNaR/v/LXGD2Utl8ED+y6A4GfFrQNehHM+m5FmKWM1wfo5Fhw2opycbsLGcuQKtk1NMoNL8MLF2Jhr9Nv8dtAUnwSKV6YASjZQtHg1qWvZcm65zyHP5U+VRwFc3OdYbOhTnxIFIsahkhgw9CFfCJA/QP8/MeLUnaGrIVSDD8JJ53KJoO3yFF3OCNudUCuh+2vE8jpD+F6Dg1tT6pUY9sCpSuFEV2Ul3VVYI43nFQFwL3e8+gRF8WtkpTd+JfDg39ZX46x9HSA6hjtM=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(7416014)(376014)(1800799024)(366016)(4143699003)(56012099006)(6133799003)(11063799006)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?9MMXR+yJr8Cm/PM8Uw5BgEtLSM47CZC+tk+oY9Wb69KMF3laQsmDgoqC3m9Q?=
 =?us-ascii?Q?+shZmuB10tDfmVeq1pTOpkP/p9kBXF5avGnudS3LDfR416XhWxnoaQNnaXhr?=
 =?us-ascii?Q?2VX/4PGElAh3j/ElOcEUXHmqTfXKBIecqZU/0nReiKHvWtwlkqM4gHIHY5eJ?=
 =?us-ascii?Q?vwsYFlxHq8lMHkVTNIwROf2R+K13CdmWuoVWyS4G9v71jyXv5Gq8fyTXT8PJ?=
 =?us-ascii?Q?5002yBSi4Jbca3GMOLP/rBk3bDdE1/2fM0YkRkKUqnulB8OSdq8wIqk39rDi?=
 =?us-ascii?Q?/J9cciiiVhyn8+xGKDBMiHpCButLSztYRRl7Eb0qxKqCidumbr/qXLl2lMwv?=
 =?us-ascii?Q?jlWSjaLx8+0Igc43GC2ZmMvHDj9kSGZEDT/qOkU7xJTZp6TyuHkb22EmJzek?=
 =?us-ascii?Q?HfeOJmj+u7jCigfXJCV2CSd6CkiNPnTerUXmG10MX429Vc/h3DOzIJeYr3ZU?=
 =?us-ascii?Q?1waiuTYnOGVcD75iXNo7FPXBy8IOubhqeVJHdz7N8ozpzihrJ2feQf/4yTFg?=
 =?us-ascii?Q?bSm8oi+Japh1W8AjHlrZyTSEsOp+e0CtXaPAMOYks4nPHQRedraTK/u+IZCh?=
 =?us-ascii?Q?8jH2w4FUhVRcL7+i1HkKfLW+iqSqF7GjQRdhek8ChfpP9fQ0SxCnz8K4IMy7?=
 =?us-ascii?Q?9XozkGAqaklEcqOKQpYxKjeGsETIsemcd4VfOhrOSwHUE4zNF0/qMmPm8gIs?=
 =?us-ascii?Q?N4aGxIIlmXQq5sQ/DqOmQy/ii91kbQ7BrkvkqHjbpvC16E4t/PJObrEIlCr4?=
 =?us-ascii?Q?PJ2ndefjQG9C14L5jEcc+fdaqfQ/nUmBvoEPzDp4qVJ8kzkxpjWIuVOodvZG?=
 =?us-ascii?Q?jGsLXCotdnDt+UH7Ure9LYMfr6gpztU00iCMj2X74MHQW4FlqLCkVTctKUW+?=
 =?us-ascii?Q?/gLX0zTvkdBgv1O/LHhet1Rb++/QnK9SYPhkf6DQ+wz8ieAjmtqfI+xmhlLD?=
 =?us-ascii?Q?LbzEDnwqbxhQUV/K7M6fIPJf03pjGRSgkcxc0Sci4v2rW+GXYoiq+nuCI2xd?=
 =?us-ascii?Q?kR7BM5/xArjugmwY0cF6xlo8vZdfTJ4Jx1IpaERiqxlKZcKBO039mx81mQAP?=
 =?us-ascii?Q?iebMhv3p6wYvpzgbdqXIs2KU2t+bLubOvY06HrnWjXgziAQO0VkKEo92udNB?=
 =?us-ascii?Q?mY0IgIucdxfW+epdDDIBKpo8Cz0m4xdouFt0DQoTVo8hVG3cqgURMndOPPDI?=
 =?us-ascii?Q?/XpbsshpVeLAVvS3o9iTQPZWtCd6v4h/KSAlw1+HxpvdianQgpjcj/K/Kw23?=
 =?us-ascii?Q?Iom4U027msmu1DMOzHxQ9aGV242f3eHS4yV2HOe8QZ+gdn70+GB7wxt7luQk?=
 =?us-ascii?Q?KtaGhVtefTNdCKfuzo0bqPB7O3X0TVJ/nmwGBdXU/QmuOtPLpMuup+2YGCb8?=
 =?us-ascii?Q?Xr4oLaHfo1CrK8JC2lgAm/jtRZDKNdEXpE7jqDfOkfY+fHjoq8hBg+NmARbn?=
 =?us-ascii?Q?J793At6mAAWXy9bWxoCZT9aRRA9zlzVY6EghE7XN5DvR/uZkwmdaJmxCJOhL?=
 =?us-ascii?Q?OwOsiuCeGIOhxHc1g8LYFhnL6QI+SfENMQa1hJqE3mFAY+fvQeACFgllpfyG?=
 =?us-ascii?Q?OfAXf+ufEIOm8K51Pl6tSP149TmR98TJOlyFL/Y2Yd2NKhH83Rsl6mNinf63?=
 =?us-ascii?Q?1XB9+wyCeZos0WeTNQWpy1+KTqGWeIekA63gJcscoCxj8LizJZEqfM5q+FCj?=
 =?us-ascii?Q?5ZqSM7OJv+k/wmv8km3WfL5v4TXvLdTKcMZj7Gqr1RqJla8R?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c18810d1-30bf-4608-0b07-08ded5fe78c6
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jun 2026 16:50:05.9525
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: L9QGdnkc7DCjzDhXn/55N1RiaJFFUSQDLRlpOpx0JspS1wYfAVECwjdlpTtKUsiu
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CYXPR12MB9442
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: CDF534000A
X-Stat-Signature: fi46mbmyjp4h5wak8qx7u4wew5symwmj
X-HE-Tag: 1782751812-355374
X-HE-Meta: U2FsdGVkX1+q5u2ki4QPIU+hHb+0jwL1epOXank5gQQbjaf9MekQ6syRwarJK6JE5qTaQp+o3OFreaDPwl7YZ6xWNGwlH1Thm7s9GaVNjIrkBlZZxlQ5f8xQ7+k6nGeJcQ2VeqPTq2Uiotc31V+Ig6NQFSQs8GBepuLDMsG1N3HgfRLES3evxjY/wHFNZx2j5Z8NjcY4hzn6TH8qrOu7bNf816nNO7L9+v5HW69PFsuZRcLdcoTrspoBQbbLYvJNzsT0jXIpqcfi4D0whkFnpUvgMUiBs61o+DNiUR2NQQEA40Nmg1GuDB+m6Ic2kZ7AnX1P0UlR686Oc2cFnzHCenu4eF/O61/FQ8X8gnjf4Mk78e/PFW7VtxENMg7ceJauxAbz2JW0T1ITE53M/gBSyWrh7N33GGL+Z001ycMXH0HxoknaZigtogoVlSr+9om7uhuRVZ+hKjp5pDdG9sP1e+0k4UiFqPRjT3vIpZXhPWcvVf9KMR1kdkkWhvKdGAq/NmEdiVhZ0oYiIdo38gs1b4uGQZjvTKvo1+5e0BDA76+F/bdG/Gup3gIIwF3MBlqSo2ngpN3ruZJ0HfRcFTxmm/WoTHqHVDtjNI+wFC1LGdMhSgRUI7Evg8woH4yb8r3L4kkHLDvZ7G9S23h20GgtYvW9+BVO2HZIWMf4iJD/2EIhygqc8LDHzha5+fySNBXhfo4nrehUzL6Lt8N6JWwaYpwUySWNF8TM1zIuqtWJ0VAm9gQbMYvFxi9V95wTjotcZrayD2mqrGILXKdW1XRMA+Z4D/fGD6EZovZZ+NwIA8LuTs30h5BqyiQ/ymlcEedWc+r5488/9aMORJdo4oPxajWZcvUwFpY6HCD7FqQmMUJpfBMTCL+jBF6D60aaYGeXQsb7IbtSpxtu79zLI++lA40GQn9g1klZ/YCgZ6wD4ofqOLQrRtrUT3BU7IZwNZGtbk3Xyx6fnRcIIXLHsmH
 GpNzagsD
 p4MhGHO4IC+2gT/zFP5nzKGmdqTodCn107/i/b/oL7+/D322PA8Ap+112uxDMp/of+asCqKrT6RZhT2+BgrULGr1Pbj3LU62xMDG3pKIccKSG4z0aZF+GRJ8LN1ZAkwnhMeKjSLoTDWCJYKMBX2aW4DicFb2gS3P6Th8W5zoVbBZBH1HoJj1/fCMR1Cgi0QdK19Ojll32nlXV/tsPlDb7q2Zuy38AghfcuBT82JRwXSUTRdh8kDon4jH0uk8vi/mCe8vUAEcbvKEPz/vOr0Kd3b/+HkVWLntynwtxOIxVcWV65KGZqBJTxp2QXHacwUXE7xoF3GaDNUzDFNYFm9k26E+8Xdy48vCXqKN11s8shCsSpMnv3uo5dfhwbw83Mu8i3uK6LJ5knnGxBfiNFYR0zTc5knGfyB7Ks0z2zi61hlYZJcUo4BkyMMkuMqUYfHIds8/rpwtmW58Tq7I=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 29 Jun 2026, at 11:45, Vlastimil Babka (SUSE) wrote:

> On 6/29/26 04:56, Zi Yan wrote:
>> With the subpage->private == 0 check added in a prior commit, any allocated
>> compound page should not have nonzero subpage->private. Remove the
>
> (not "subpage")

Will change it to tail_page.

>
> I think the sentence would be more precise if it said that we now expect
> (and optionally check) tail pages to have zero ->private when they are
> freed, so we can rely on that still being true during subsequent reallocation.
>
> (and if the buddy allocator itself sets it to non-zero due to split/merge of
> buddy pages, it will reset it to zero as well as appropriate, but maybe that
> doesn't need spelling out)

Will fix the commit message like you suggested above.

>
>> unnecessary subpage->private initialization code in compound page
>> preparation.
>>
>> Signed-off-by: Zi Yan <ziy@nvidia.com>
>
> Acked-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>

Thanks.

>
>> ---
>>  mm/internal.h | 1 -
>>  1 file changed, 1 deletion(-)
>>
>> diff --git a/mm/internal.h b/mm/internal.h
>> index 181e79f1d6a2..c96421ce9350 100644
>> --- a/mm/internal.h
>> +++ b/mm/internal.h
>> @@ -895,7 +895,6 @@ static inline void prep_compound_tail(struct page *tail,
>>  {
>>  	tail->mapping = TAIL_MAPPING;
>>  	set_compound_head(tail, head, order);
>> -	set_page_private(tail, 0);
>>  }
>>
>>  static inline void init_compound_tail(struct page *tail,
>>


Best Regards,
Yan, Zi

