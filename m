Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B06B36083619
	for <linux-mm@archiver.kernel.org>; Tue,  3 Nov 2026 16:13:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=ljfLG2xK
Received: by kanga.kvack.org (Postfix)
	id 8CC4B6B05B7; Tue,  3 Nov 2026 11:13:05 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8570F6B05B8; Tue,  3 Nov 2026 11:13:05 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6F8A56B05B9; Tue,  3 Nov 2026 11:13:05 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 3D21C6B05B7
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 11:13:05 -0500 (EST)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id ADBBF804CD
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 16:13:04 +0000 (UTC)
X-FDA: 85394301888.14.5C17399
Received: from CY3PR05CU001.outbound.protection.outlook.com (mail-westcentralusazon11013036.outbound.protection.outlook.com [40.93.201.36])
	by imf04.hostedemail.com (Postfix) with ESMTP id CBA6A4000A
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 16:13:01 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=ljfLG2xK;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf04.hostedemail.com: domain of ziy@nvidia.com designates 40.93.201.36 as permitted sender) smtp.mailfrom=ziy@nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793722382;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=brER5E6AiOc41/iMcDOMIPpJ+BAylAFG8gkZPPLfEHE=;
	b=YTYKJBWVa0CHw+oDVNjIdGTGHRQillugLZZAQhAd4yYvVnyOLSBIIPS2CqO+XkxjHnXo0K
	Hk5rApoPVhQALfot91aVRI4F7ksKN9fqH4pOvpWIAc+EE9W6HUbfZZrq5LgDouEP8gDr9B
	JAz0iqV9WimkJSKM77cd341UzN7jcbU=
ARC-Authentication-Results: i=2;
	imf04.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=ljfLG2xK;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf04.hostedemail.com: domain of ziy@nvidia.com designates 40.93.201.36 as permitted sender) smtp.mailfrom=ziy@nvidia.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1793722382;
	b=qd9H1xhTsZem/wVyupjqjPR/ALiqivS099IOP6dqosXDtT3Hvu6yvRIRTMaOIFhX1aRn4N
	ivIf0hF0/Nj96UEvFtzP0tJ+t07EDNYDApnbV4Pi8jirCYeSKbo98qcX/6N6ceCY1po29K
	3h2mETtfABqX27qvcRuZKzdk2tl2lms=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=kR8YtGFM1AlvOdL0hlOiwtgsh8Js+9cqsO0JTEr0J0y/CMtzkTKyq/iwajYVeVUSdti//ftCma6bitoHXFsgu5+uyTryLJOpQ4tvCc36D88O61AOHvuiM026bCDqyO65/RP95YAamNN4jW4kS23vpY5mcF3Z9kdLOxFWtuDObTA0MZG+FI/RlVlRU6xnTguRxyCVrLtSg8gzYJRxrC7oSJCsYThyNwawvG+Mi5jQQqBW0MgwQBJelTJDgwqyGQmdMssmgRNAoSj9rCZVt2L6r+S9oR9c2lSB8EOAwMPqF8NH5V9Cg87Tsgf+52s85mONQwRVexHpXefeLPPK8h3R+A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=brER5E6AiOc41/iMcDOMIPpJ+BAylAFG8gkZPPLfEHE=;
 b=Gt8v4BhYboTr05cLAff62WErua4E6ljFxV7ABrjt3/Ldbmr8A0FCcTDKCg40eC21M/EJ7B3ib+qftoEEvKT/a32TMEI9ehP40wDL105b5ElNIFiMA6nGJV7Nj1d153+royro+Y6jS39KuO3bsleqQ1k5lnmMd2kYTuTCp7BGqw+BlaLbeeseK2Bt+0KKTRnqJ7WDMglCvvwJ2sbsqfM4vLKB+3oAcQfAsUOrWi4jFqfscnvrhepKdl9oyiscS+gZxpZt99eVbVD/fQCj1sdzxv+vKTDtivrldrslfIrYlU7O06ipQNkJXdX5J0gAQu7+QFFqE9oG79yysQZNhFr8+A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=brER5E6AiOc41/iMcDOMIPpJ+BAylAFG8gkZPPLfEHE=;
 b=ljfLG2xKmm8B/0lW0HB/xvYXLGP2FpfQVX5jHXVgw3iffGKonzuulz0GkPrTZPbEzTjCbl3FxQh1h05mdpAkK07FrShAmqtTjSjtWzdHFNrosdWu7soOYZ9vHq69A26HHEwbQ6uBFKOaXNqKc/imz1cgFyjPb0Tb34ZuPntvT7gEdjN91+bfeAk962zc2QrteSadjM49jk68qfknFY5Ih39Z6SZb/2MCbIsV99nLLZwwlf/ETMScaEAMhIBYabzzBeV8ZIkFUNOTTn8tKP3qrtkl5vEfRhb7D8GdI3skvP+PHhFcsvoxWDM7Enm/+kdD4tPg9VL5rKJR+v+dX5Y9fQ==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by DS0PR12MB8478.namprd12.prod.outlook.com (2603:10b6:8:15a::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.592.8; Tue, 3 Nov 2026
 16:12:55 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%6]) with mapi id 15.21.0569.011; Tue, 3 Nov 2026
 16:12:55 +0000
From: Zi Yan <ziy@nvidia.com>
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: "Gregory Price (Meta)" <gourry@gourry.net>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, linux-cxl@vger.kernel.org,
 kernel-team@meta.com, akpm@linux-foundation.org, surenb@google.com,
 mhocko@suse.com, brendan.jackman@linux.dev, hannes@cmpxchg.org,
 linmiaohe@huawei.com, nao.horiguchi@gmail.com, david@kernel.org,
 ljs@kernel.org, liam@infradead.org, rppt@kernel.org, osalvador@suse.de,
 muchun.song@linux.dev, iamjoonsoo.kim@lge.com, anshuman.khandual@arm.com,
 stable@vger.kernel.org
Subject: Re: [PATCH 4/6] mm/page_alloc: don't undo another isolation in
 alloc_contig_range
Date: Tue, 03 Nov 2026 11:12:52 -0500
X-Mailer: MailMate (3.0r7038)
Message-ID: <CEC81354-7239-4F7F-B46F-935BFEB8930D@nvidia.com>
In-Reply-To: <6091a4d5-ded8-423e-a806-2c4b11f21e09@kernel.org>
References: <20261027042204.3741307-1-gourry@gourry.net>
 <20261027042204.3741307-5-gourry@gourry.net>
 <6091a4d5-ded8-423e-a806-2c4b11f21e09@kernel.org>
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable
X-MS-Reactions: disallow
X-ClientProxiedBy: BN9PR03CA0069.namprd03.prod.outlook.com
 (2603:10b6:408:fc::14) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|DS0PR12MB8478:EE_
X-MS-Office365-Filtering-Correlation-Id: 4656f0a4-0907-4233-4cb5-08df39c55158
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|23010399003|7416014|1800799024|366016|4143699003|11063799006|56012099006|261009223027099003|261022105027099003|261102123227099003|261021121427099003|261028144727099003|261026140227099003|261026121527099003|10067099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	2Q/Q6OTyUnRzQE+Wc+vK90DL4wlQPZg8t5y48ZTS+F4od05U8+HlWNa/j12dG03n6hbdCxB4yj4ktBUCgEFtAgz6I6IdNZEPtT27mdc4CYkqWK0KNe6vnOYetDT1gUBwF5ErNdwrvR7oQTlfDPEA5dAjSoTZzznDJCFgY4t68rvIcaehtb3UcoKHrfmMKKw8AIfux/epl+yR2VQl1wLcUyoZyblS9PiNuMCNCjLsK/a0278hrhEjqKZ+RftpwXyKNhxvLgfz2BqpHLGEzdIcO61oKmEAAdf0ZRjnkrLfIQXYwfB9M+hNzYqg5TwH4vTrgSoA6XPRKIbbocAAn2Gk0rPsn+SeSJPsUKQsboBMexPuYV4+Q7pyJLv/AaXH/8Vkn5kdX7l6T1USNLv6zffNLhvSV9m2p9oPGeop3+R68cORHaNJOK0b8ZjFy4dHiFV1tl0Ct44s1NsdbNT2JUIwapxqhVyc7SyMwfaztF2vtSO4bd5PgHlvcqZkHdd/Ig96p8mT2VeekyWmAOlDyUI0WRj2tOfXY3c9WpYoQp/pXWlfC3PcEDWZ7cpd7y0vT/9XkBXpjBGEXJoS5gDDlNnh6+GujF4/XO9oKyVWyjGxXWElxjpPt7qhE7DTSOjuqG6HzokuK5/x1m5CGM15bUQ3FkTqbqVtx3iQ4Tv34kZisI4=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(23010399003)(7416014)(1800799024)(366016)(4143699003)(11063799006)(56012099006)(261009223027099003)(261022105027099003)(261102123227099003)(261021121427099003)(261028144727099003)(261026140227099003)(261026121527099003)(10067099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?bRDdnvkIm3P9iRNO2GcLAcWuFayHfgmYtI9V9ThTUTaJay8A4NNDKp69yeLM?=
 =?us-ascii?Q?VMrbNFxENH7Y4LYKmSXyOZBLGIFHqtpOVwuUu9MscSzhESKkVSqHstgekl89?=
 =?us-ascii?Q?9h80Uzk1jmx0Q0upbTqmGN+a+LWN8xesflIeGifPDSIS5a228WceiEiZikC1?=
 =?us-ascii?Q?hgQuR2anUHhgDr1EkR8xDDzLLUrj8OgbMVO8OaD7Mh1Z8Jvbq5XZkTgOLcmp?=
 =?us-ascii?Q?wv53Uiw/aspjouuzqf/4x0Z7aMIc/vXKk+NQOcgP5m6tbhMbL446gXVSqLyi?=
 =?us-ascii?Q?GAX0p00iAoO1k2j42wHhoUuPVUJHN4IIMVa8u2vLkwnMqAM6W5kYFvDcwhtK?=
 =?us-ascii?Q?kwiPP1HjUBNrEMAJdlTc4ByToqKtjSa2DsdjTueC5976bkKAGHOspRCMKmra?=
 =?us-ascii?Q?Y6zRiEZfpjzni/GEoVMXk2WPGhYBhNPc8FDeGi8xmtjf6SN5vak6wGVXIRhk?=
 =?us-ascii?Q?+EzqkKWvFJHwnXWBFg6lkrtwxU+vnFha8o7jueAx4sIkDbyezhMYUJZmk6eS?=
 =?us-ascii?Q?p44UEMU2ADJuIwFOT/BcRu7yuKx8uJglU6cLzGO7LDCEBi/pHE2wf2eU6GXC?=
 =?us-ascii?Q?iDAIKQCgpqIMghwUfYFXB2nr9yKjTtm0qStg7nFCAIWgktHQhDhfOzSdoPVl?=
 =?us-ascii?Q?SOYxCD5TxkYrbL8oJ5CpjLlsiOL2m1yJL5Yv3RnIbYZMkCSl18eXMQHSzeHB?=
 =?us-ascii?Q?5jC5NIeCbX6wYJNZFwqndlW0AAbsTopO6KvdMrLie0HqOG1STo2A9edsriNn?=
 =?us-ascii?Q?o1dIQGnQHebunYy2v2r7CBAXAtRqbqXPdA9eY4v7iEAsl79xeJVlyCpWmGdI?=
 =?us-ascii?Q?OQQOmWcJXl0FnrsjWPkuvLrhcWD8Rht1PtGd4hm0BwWSl6zVam37mmvlgiGh?=
 =?us-ascii?Q?7kgMvCHN6hxiJWFYu6gtpmHSTeQqlkeeEGkHCYJLu6ig/sVoAwlnn0Qwgwfq?=
 =?us-ascii?Q?TR2fyY59BTfftceEzGy5JcXcc2UtJh0sUJxrdaxSW4q+tmebEPNjJaORj4M5?=
 =?us-ascii?Q?5WFz7kptU2KqI/7uoKnFSoPEoYowsMV3JAwV9Q0vkJo9HgGp/6avZQW1o4EK?=
 =?us-ascii?Q?f+8Mq+QK9SGplEn5W1/dcqWBGe1VShRN8PqNSBr/mXJ0QPp+fWxJlSecQLk4?=
 =?us-ascii?Q?31l0a2FaGOm1XijZRw0LgCONboNE2hJPVC433vnE1R69NQhN/J5uY6Hh4qIb?=
 =?us-ascii?Q?nbt8JgSx6Huxf9T9BW4UeFC/owfqUf/ZfanwkBO2OaTtR+Z2GLs9JuU5ReGG?=
 =?us-ascii?Q?cYjz6KWGkEdJPSupNqY0zwDM5B/LPNW+ZpvBxRCPlREkIyHoOsYevfErSpHH?=
 =?us-ascii?Q?IP/pB5zkgXhBj9aupgcw34Flhjbt2C2kVZ0HaQGgFPSyp7V+p9CWnfLk86hA?=
 =?us-ascii?Q?bdoj1DtYHxqfBEsoWXYO0ngTdcVPSgqRjLLXzy+U/bv1B8hdvlJF7UC4Npy3?=
 =?us-ascii?Q?3nWhCnT5IYDx9pE/AhZxAFtoMGDHuSv/O0gysSDkwL51BRUwszXriKaSdvY0?=
 =?us-ascii?Q?hiWaCofXWF5wK+pdQvoKiZVVnukq2ocbQ74y3Yxfd2EZj2oLmbpuSZWZYco0?=
 =?us-ascii?Q?FHxo2sr9KyXx4j/zGhjBCCfnlNpOogevPr9KQKmIBh5mCmcBqD68Ton1b8RF?=
 =?us-ascii?Q?KPb9kTUbhbF0SxQaG75j0yK2w8CaXBK8gz/P+D7i0wQzQ2Sf0ZiIJVnTRXyd?=
 =?us-ascii?Q?/1s7935IkiorZnu2dJ5m7up8rYoU2gVwzct36dSZL2R10WWr?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4656f0a4-0907-4233-4cb5-08df39c55158
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Nov 2026 16:12:54.8050
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: AuZ8oyWeWDYNkq05fnUFwrpDEuvDc1YRaPCNFNxfN9fJsz6OSAmzxAxCPCcaRfO9
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB8478
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: CBA6A4000A
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: 443bheumyhhea4td9c745ai3arqu9xh4
X-HE-Tag: 1793722381-639021
X-HE-Meta: U2FsdGVkX18oZZaXq3CsP3CcBrdiijRk+zDeK7wn5NuRyWE6QPybpUlEP7FL8ttz44Xt/qTnS1bVRwSj3O0roZgOkru91q5I4JM44yOl7aQ42/bRJ6T07XvAGoX9Fek9tH9czAn0eK3QRoMgvrOTu82JBYdH2DG53xuQUIZkbpws3x4Jf8dxekf1mOgkUZsQxRsgswcif0brRosO0II++gAoivWVutPoWohI2D4N17VZR1nApKFP7YwHaeKa4TZchv5Ih5EMbzHtKR/9XJolbH2Mz5NZhJYrVqwSKlD343pTvefLKM9O86o7CU3TAJUcxrpZSR84wQ9JPqG2mDefrbKyKeYI+II0ARu2go1+DAHs1IEFp6I545CF2vfbbiuiDfmfpQ6ttd6lFWN4wPEykEQPoEn062bfFrlrsyy2dha4YG0oCp0ANEJmavY/R9n1USXGZvAyJvhBZGCWakryjeeiiQPBSvdVr4U8A6w9fa4WH7lBKqNwRRS8mCTfAQNLzKdPY+XIfr+888DzKA+RtHuibpJmWdrgzqD5J5TSCenpbKfGOtoVUXiPjQSjk+VcjFlgMA4Nrs0LUKRIHV4v+xoyhj7nj0ct2wJCkr0VKCdmCemAclegRi79qc4rK4xeFU6WCtJmf5nKO5FhxK47AHkAMpJ7YsaU6LaMGc6QOWMqgxxX3wj8dfMgvRstSjovQn1LtB3uiIGLA7ej07VKzAZyaEJoVSwCjFo9MxtV3XWSnvcAIi7uibBIbLgQ7sqeezWNmecEehVyuaxuzKXDmvj9pr04rIFxk9XFV+S9/JDJD1AQ1dp3hGCFbTD/Ia+winLGnWleTm4LTdKjtRV7bu38Q0fm/A58OUu+tdwaHyyPnDIOKBn2ORK2jOSxPlzcY4oLisYMGeMRe3qnUIsdt8L0ZsKxLoFyHKdt+h3wmmR/6U3ZbajUjPzEPoctJvbHHDmsvYFhVRDEl1vj2sh
 xpkIukXa
 8J2qdR94ZrKTub9tQbGrR7y4+EyEymkzl02foE/VyoCGleNUkzOdZGGZixtv8LRHM2oP5NXZ1UDGQzJxuMiucgueo30ApYzUeXjZ3+hQTnTJKr/Wzp4ZVe/HPZC66m+y+kIhizbq66E3qfa5cjta53UK92pi71KmJYf5eJGumj5B+L7ZPpFslEq3MBUhfvq0rtat/YXBerDrFGrgMCaLUs9f5oc6ZXpk6ECVIqsPN8s58wLQAqD9uhQmga69t77RJCSgsJiLBpGNSE4HmODyd9z8/AJjKCGfN7vZB138sauQ+o6Nr/2nc0Xxpr02FQ9+uL2ZHdwzYFLlLB/jPNfQdZ83e/b/88f258T8txKXRimUsLrODv5YBNifB9mRM0IwnzEntwOBuC6gU+RrRVYA+CHIvIainjY0WHdP9BGYvi4OPpMC3+rJZRcQ4Avn+aR0oV665SbfhvYYW7S8E2bGRyxIaIQotM0RgJdq9kWunPtqB6XPRml/KsxRAZAbN9ycA5PGXEpUuy5KzIViYRnd5lE/69dzURCfbcrtnn2hkd/N7rnWFo+DvkIt69wGaIO0qBnnI
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 3 Nov 2026, at 10:12, Vlastimil Babka (SUSE) wrote:

> On 10/27/26 05:22, Gregory Price (Meta) wrote:
>> An alloc_contig_range() that overlaps a block going offline can leave
>> the offline spinning until it gets a signal, holding the device hotplu=
g
>> lock.  When isolation fails, alloc_contig_frozen_range() undoes it ove=
r
>> the whole range, clearing the offline's MIGRATE_ISOLATE too:
>>
>>   CPU 1 (offline_pages)               CPU 2 (alloc_contig_range)
>>   start_isolate_page_range()
>>     blocks are MIGRATE_ISOLATE
>>                                       start_isolate_page_range()
>>                                         -EBUSY on CPU 1's blocks
>>                                       undo_isolate_page_range()
>>                                         blocks are MIGRATE_MOVABLE
>>   test_pages_isolated()
>>     never succeeds again
>>
>> start_isolate_page_range() fails only on a block someone else isolated=
,
>> after undoing its own, so this undo only ever clears another caller's.=

>> Return directly, as before alloc_contig_range() went pageblock granula=
r.
>>
>> With offline_pages() parked after isolating a DIMM block and a 1G
>> hugetlb allocation made over it, the offline on base still loops 30s
>> later in 4 of 4 runs:
>>
>>   offline_pages+0x5b2/0x1570
>>   memory_subsys_offline+0x17e/0x470
>>   device_offline+0x250/0x340
>>   state_store+0x88/0x110
>>
>> With this patch the allocation still fails, and the offline completes =
in
>> 3 of 3 runs.
>>
>> Fixes: b2c9e2fbba32 ("mm: make alloc_contig_range work at pageblock gr=
anularity")
>> Cc: stable@vger.kernel.org
>> Signed-off-by: Gregory Price (Meta) <gourry@gourry.net>
>
> I've applied this single patch to page_alloc/for-next-fixes and will dr=
op
> the version from Josef [1]. Also transferred Zi's R-b since it's the sa=
me
> code change (plus comment).
>
> [1]
> https://lore.kernel.org/all/20261027-pgalloc-ai-hotfixes-v1-1-9c7d1aca8=
01e@kernel.org/

Thanks.

Best Regards,
Yan, Zi

