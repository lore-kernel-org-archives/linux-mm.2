Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9BF11FD4F19
	for <linux-mm@archiver.kernel.org>; Tue, 10 Mar 2026 19:15:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 756C56B0088; Tue, 10 Mar 2026 15:15:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 704B76B0089; Tue, 10 Mar 2026 15:15:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5B2566B008A; Tue, 10 Mar 2026 15:15:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 3B7216B0088
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 15:15:40 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id C4B92C17C2
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 19:15:39 +0000 (UTC)
X-FDA: 84531107598.19.AD7B337
Received: from CO1PR03CU002.outbound.protection.outlook.com (mail-westus2azon11010025.outbound.protection.outlook.com [52.101.46.25])
	by imf09.hostedemail.com (Postfix) with ESMTP id BBDC414001A
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 19:15:36 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=OgpYCF3+;
	spf=pass (imf09.hostedemail.com: domain of ziy@nvidia.com designates 52.101.46.25 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773170137;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IUEuUYvVeyn/r4pxeBU6qViM7TFLLDHqfW712/CN0JU=;
	b=toTLIl7k5pGWd3ZIubmCM3WDlFyKxBRJnyP8fQCnM6s9WVpo/TD8y9WCHm5v085U/TJ/FZ
	pBNVke7BaYPaLvl0qGDbi7v9ay8U8AcJklczDa59WsVzR3wkbXaRMsAsTjSJMYZIAvA0KC
	Ph70wp19OumQ7Dg7BmAfoArcBR+scO4=
ARC-Authentication-Results: i=2;
	imf09.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=OgpYCF3+;
	spf=pass (imf09.hostedemail.com: domain of ziy@nvidia.com designates 52.101.46.25 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1773170137; a=rsa-sha256;
	cv=pass;
	b=acRq0eTJDFUfQPS5X5aB2lSXd1cC8QzT8nWehIpPt0yUbFIRoWvwvAGv6TN2nCinCVtD+8
	A+UUU6nbjZ1kQQauVDis5y9n5iJeB/GnDJSVO1XanvyGs/ScOOq8qwaI5z4GZ2moiFtDbj
	LQ1mjrDm/uIg5IwlBumPvkpvUFagIbA=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=VAYZWq3PKCEh4s+3Q+TtID9eZcDPQN+PZ8YU2ZaRZaWkCdWGPDL2fggaRlNW3WBV1IJ9GbFY0PFMgp4RlC5iApsiojARlFbdGsChWJ15UEh+eTnH8NmfkRAWZE+ND8zBxxo0E6kikMWaolNAscOV1kNSaQ1JaGob4TapmCFb0FbByIqM3nl0fkNAirsvF3+QTOn75o7wJR9pxJBot4FuiDE0BjlVtvwPsqnk82lFLyj/aUKjnMPiKDRTX6ajzn9MZOeGHJIkwBlFJuAg8p/kUQZ207naIXrBoqYM0pyTeTXh8tr36tTxw5bRFwOtTW2d0PKtjS36KSOJFa9QmY6j4Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IUEuUYvVeyn/r4pxeBU6qViM7TFLLDHqfW712/CN0JU=;
 b=EPAJVpqsa6XtlMpyIJpQVZDUMlv9iHAcMA0u8YW7zZsy/Yx30x4amQlqoA50LEiGvX+1b3FeV6L4fxHENy08S1A2prarxnWFx3JRo72EpiC1a+eBkxKKR5egkMzRE2B2pNbMSAsJyqmJ0pfikz0sgeRdXZAf9uuTRrrF0NFDyEi/As/klkCDWA2cXt6czdplKOC8BuwDQTS2vxTXkrde3OBJjzWDMI8zXjAvNTz/wP5QWcBUPY+F94wkzCdTB02AQT7tHCVUODsUpxHK7JaAJqVoe7vTk90nGeX0AFfwEme/a9ad2qSScjtySczmcIIGem8ZmrEs6UBvx2NLT4fu1w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IUEuUYvVeyn/r4pxeBU6qViM7TFLLDHqfW712/CN0JU=;
 b=OgpYCF3+4CaMEn/qextvoqL5L7PVA0ls1fWnGUM8XrSG90my244U9zs93XLIkmbmGi8CltGmjQdFoVPlWCjohZme9fdbGOoZEwnNiYlqXUxjbXdG8M5F3/+8/c6aFEWd3aITc4IgP5XcGLg9/ul/okxm1foCf3Pdrsl7fZswaDOHqMKfdlJ2nsZxoNtsFsT1N6wyUWggf74CqTkVgGM5qK6sSwY11y7NYY0VflcW3qpc5dAIVZdW+zlrDObYiPL6lyzT3u2zh+CgFna3Y53cEfRhAzFNMCPBxkG70y2dvUsGmFqdbvNG4cKeCyEisaNnCM6COxQvQD72fPzGPd7J8g==
Received: from BL4PR12MB9478.namprd12.prod.outlook.com (2603:10b6:208:58e::9)
 by IA1PR12MB7520.namprd12.prod.outlook.com (2603:10b6:208:42f::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9700.11; Tue, 10 Mar
 2026 19:15:31 +0000
Received: from BL4PR12MB9478.namprd12.prod.outlook.com
 ([fe80::4d08:451e:a51e:33a1]) by BL4PR12MB9478.namprd12.prod.outlook.com
 ([fe80::4d08:451e:a51e:33a1%6]) with mapi id 15.20.9700.010; Tue, 10 Mar 2026
 19:15:31 +0000
From: Zi Yan <ziy@nvidia.com>
To: Sayali Patil <sayalip@linux.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Shuah Khan <shuah@kernel.org>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-kselftest@vger.kernel.org, Ritesh Harjani <ritesh.list@gmail.com>,
 David Hildenbrand <david@redhat.com>, Michal Hocko <mhocko@kernel.org>,
 Oscar Salvador <osalvador@suse.de>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Dev Jain <dev.jain@arm.com>,
 Muhammad Usama Anjum <usama.anjum@collabora.com>, Liam.Howlett@oracle.com,
 Miaohe Lin <linmiaohe@huawei.com>
Subject: Re: [PATCH 12/13] selftests/mm: move hwpoison setup into run_test()
 and silence modprobe output for memory-failure category
Date: Tue, 10 Mar 2026 15:15:26 -0400
X-Mailer: MailMate (2.0r6290)
Message-ID: <556E284E-9638-4F4E-8CE4-7158DB914AED@nvidia.com>
In-Reply-To: <832afc6c34a784ca433b506622cdc98fe9540f79.1773134177.git.sayalip@linux.ibm.com>
References: <cover.1773134177.git.sayalip@linux.ibm.com>
 <832afc6c34a784ca433b506622cdc98fe9540f79.1773134177.git.sayalip@linux.ibm.com>
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: SJ0PR13CA0095.namprd13.prod.outlook.com
 (2603:10b6:a03:2c5::10) To BL4PR12MB9478.namprd12.prod.outlook.com
 (2603:10b6:208:58e::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL4PR12MB9478:EE_|IA1PR12MB7520:EE_
X-MS-Office365-Filtering-Correlation-Id: cbe96e9d-6862-495d-763f-08de7ed965b0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|7416014|1800799024|376014|18002099003|56012099003|22082099003|7053199007;
X-Microsoft-Antispam-Message-Info:
	vTgFJWbzobP/pNVnNoyYVViSz8t0DV+XH/OEIAlvYgvK7nEKXKooyLsFHuUTPJJXieFvfy+alyuD0x2u83sGVOM7+dsUaLiiQiaPJHFyZfcjaqcjNiqlG8fKqO4iHIZJmcDR3IdJu+OnffnrA3u8ctV5sEkSyHASlDBvHye4jsZ4S8E+ZzlOdAYvPVrzEAbaZ+17F5uh2xKNfEawDPRtoxh/3vJUJQFGeduYCRGr/h2e6Sfz7hd85bqukm6tPY7TkaDgVbiy9m5mEUvom1zxJmaHckFUoVf+GOq5kOtSBbHDDeDAdz5aOeRjl8529fPP2qYImPxkgUip98itoBpq92G+ykBoVNsydxrX2eG0/zAaTKZR9ltj8CS9s+04Q7UuDb+wJpjlNSnOyRH5r2coKsxE8Bu6R5MHy4jPnBY6Z2MyYH/ck5hreLK2AsENo0acVtXDNW36xJse0JDHPp0saT62qdf6tEDKlKdlEfBleubYufyWEN/apY+nN6Cn/1+JPz/jqJ/s6ERAWaW7grCzWDRkV8zz5vwCm/x2JtCnB6G6/Aw/gSOYsHivqDWevFixT3OkYWBml0mgGHWz0gUVXFeLrZXTuQ7+/f2S2aljdmg8I9YAc/iBTv/kIAnC1A5I1Sguv6XAb9yoHQ9HXPsNRyIByHDsYYKglaI8UFw/s2hQKGzXitNM7sY+JGn7cPm6nSSys544KZJC6w8uf69L6Gdf9JQj0laLxBYOcwYDUR4=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL4PR12MB9478.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(1800799024)(376014)(18002099003)(56012099003)(22082099003)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?W9HOd7kjf0mXLuZvzzFkGxGOfAKAO/9a07iDfNzs/o2nzs1u/PMRIwLw9TPv?=
 =?us-ascii?Q?xcUh0rQ486JNgv+XyfM/3WnyEZVDXhRY4XrzcAVj4Zih0rp3a7If95lVkJ3O?=
 =?us-ascii?Q?pTTqR2aKvCPkt/4W7T+otSgqtHOWeufG7pdDfF9WojXV/iNQLTumG0NmD2Cd?=
 =?us-ascii?Q?OpEklyXaDnWsczndInOQPe17Xu2ITTQVDAnEihXpab5btwOZjaHjKC/P4UTG?=
 =?us-ascii?Q?AKyEuzjPqvGom525Hs8qlK2PL+tFgs4f8Lx/QhRB/jntgHdBpI4jTkwCLseV?=
 =?us-ascii?Q?WTOUWeEwbCmVJ2rDasPP9mt034ydv+V0e1K+J6kGkzVilcrgI+aQQOhkZVhR?=
 =?us-ascii?Q?05Atwi9wu+j3pW6P8eP7A+LvkXP6DvWCSq56o8El/kWccke1+GUN6kHEy3Ip?=
 =?us-ascii?Q?1DJj72TmZNOqlPS50kCOJi60hRcWoRn/tI964aMZrDrdbwzjS4QWCT3mPMyE?=
 =?us-ascii?Q?3a0Xb4kKCBU7anXJrLYOZmb5YZrV4wWx5VoPJSSaB4jcQjdstG+cDpbL08sN?=
 =?us-ascii?Q?YcjWw04ZXrnwzDgB1a37UsYlDSeDOIW70CX2Xo6dHXRGQ21bcFUzpP+85z1o?=
 =?us-ascii?Q?expIBl0ybDdWOUVDW5rLxMw72d7+vpzdD9SJYh8/fQaIt/TmpQ2bHxGmz5hS?=
 =?us-ascii?Q?l7Q4oU8AJMt9CLnK/CswAVH54MKYb7JFDvT+0Ezl8oAeK58lg2ORG4NTUTiO?=
 =?us-ascii?Q?6OVtkGVsODf3X780iTxU6zSzaRmCqmHPuQg7uj2YpXXfzcgNLRSeIB4AkCxv?=
 =?us-ascii?Q?mUWqDVcJnQP5ahJVkQ0US/cUO9i7S+Iizj2TcKL4jb93DrbcKrGgyitbTpBF?=
 =?us-ascii?Q?N/Qjn1o91So2N3HJFNKcNdTB8wbpAdlkQQi3/4THbN/MXzXMlGotCU6eiSra?=
 =?us-ascii?Q?uGR8MsyejQH6qIJYA+ARlKnb+iwzT81CgkRwkbiq/Q7NhdGeE77Q6HrV7pxn?=
 =?us-ascii?Q?K/F446ZpRPCqcGjLOXwT6gtLBLmtmU/RWDZG3Rfcg4xRolIdl1KyeWxnADyV?=
 =?us-ascii?Q?EAZf6WiUfmL6DWJ9kC+cjoyPZr/ab2bBMtDf/IE1yU8VxLZAqbelo52mUd5f?=
 =?us-ascii?Q?YQRyGOUs1PEj0G6jGcq1YWm3w22GZ9dq/Dc6GgL4bcjsEr4GjqwkJipgZvIq?=
 =?us-ascii?Q?o2Yvh7W4p98rFhdmcebTYFKGAHHOrXF1jYnw0/58QzP/NvicbbcojdnAzsMb?=
 =?us-ascii?Q?thNf29eA08ja1jNsSfuQrp7GcqJajjvsZ/3TVrzG2gITChAYuR3OHG8l4MQa?=
 =?us-ascii?Q?yc6rmY3XJa1OLopRorWIGodB35/h1zWIXDZRJuC41END2PbKD+V4Fyr5U1GC?=
 =?us-ascii?Q?nOSWswvg722MZ1XNfep54D09rRZyk1liUFGejiDvcwFtFc2up2NIwM/y8zGH?=
 =?us-ascii?Q?3rWbVEzfcqfvhsdOyBrCsrGY7m8Eg11Fk8IWaIPTaqhIgp4g1w3jIf3B5F+L?=
 =?us-ascii?Q?M7hGB51E/AG9D7ncgDxAQ9BrmHKioXB+G7owympbH/2orT01WsD+mO26Bd31?=
 =?us-ascii?Q?bBLxOfI0qurHr5pBqpR57ogwoKII0jt9D/MZm/mYm+DXEZgD8aJN7/zrf53s?=
 =?us-ascii?Q?u1LrjjWlSxKRZ0BOI3x41RTM8VW3KppvDQX9ROb7N30Adb2/hVXJRu2GTNhY?=
 =?us-ascii?Q?tShbrTheH0MhLM6GQGAkT5A+127+R5tQ4nUUSQ9UGPZSSKqztBFRacfqx/ao?=
 =?us-ascii?Q?KCvJxG4v4cxn6z0KyrTqi3IZPkZS/ys/8+gcCbfhKfjFDLx7Yo35tzC0zSPq?=
 =?us-ascii?Q?U6VC+RDkog=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cbe96e9d-6862-495d-763f-08de7ed965b0
X-MS-Exchange-CrossTenant-AuthSource: BL4PR12MB9478.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Mar 2026 19:15:31.4041
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qgVRxbTm7rPgQ3C17CSnqFXRLD/IS9XMO0LxHU9QHmnlIXrAhauUrtg3eN27+zmM
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB7520
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: BBDC414001A
X-Stat-Signature: tpxdwbc878crzqafsk6ikoiqze4zkqqs
X-Rspam-User: 
X-HE-Tag: 1773170136-440735
X-HE-Meta: U2FsdGVkX1//GwmLHvComnUFO+1VEH4V1wso5vSKFIXtUy9tqlVfCASG320LzRuyteOOtj/j3JL9Co1My11GT2m+c/hh+yOYEBW7D8QmRu5w3POo4PP5gt6eaKf1zwxI+jrZYBu6rJSZ7iHgBYsSPAm1bAYcms9tDDWOvp7oB7QONfFP0nWnl8tjRUjZ2KiXP07fOSQQY4wDEU68lIG0UOwBGBEL+rkUajdwfV42dRNJOubyUl/v97Xucmg9RiaqV9B5ozSF5wxQy2uhM65d/a3SWQ1gm5jgqVhjzIczIGpIR8uK0wk7XjfGz+yob3PqFeWJO6nzp6JrRMi+oCCO2daCgQV5gnJdFV//5pZ8TLUEmMxhvNHmltlVRe1qrWH2mFFDYdc5QqtZOFFa9MA4/BC7odnP0pLYnx54CdvaHNjSEGj4IJeYi+lPhK/0Id/96zgJgTTWIiB1pyjQeVtJHXNYD/qas5iTGYxL6M6zoT5/8urnF8ZmLNEpSkVlHB2rBxiE6J5iYGstCr5KoqCYSCdqGLaXV8kOjNCIB6QWamqfCVLntnUSAiPP69nojlInWX1+76Kbsgzy8XIacTGGMrt9hOxscP+9QxndLpcYvS8AHD50sMpFzuc4XhYe5GbrrrbwE28ifzXmO003inNx1ADshbCyIiyKiX7fWM+d+IJ4B11REBChOGkrnnOZlJAmdRC86Dqu0ZK84cVyxf6x739Hxdkj6e3Z5LDRT3SulyfbneYPmUWTEatYwBYPpguUpQkkcd97UOBkh+MD0FmDhkLrxor4GW3PC4DPq7JC5ww15+Tgn+/PeIV7LLCmsbpJj1uLRx7CICGzJc+6VGWu1JdNA/sDdcwc/e9CLElU3CAtIeMg0WvVXNfNWeGXsCymVpxPqRxY/c72Y/7GsFCByaBTh+GYXHrnUGnmrnHZrdx28iSVUPYlptIC++BW12QEAf1uHnkpoWZhNJqVigR
 QC/aVtGD
 ELfCQ6sXoGJJomaz9EPxlio7ZNFg/DoJKjZywsKeTsrJCJ4TFebWax+znytPYVZdKTPZoBRETJa8rnMLLbDjzXeavML3Vxibidm7mGHON6rhU5i9HKYlJ8p5NQiBrjP7LMHirNXGZS7pgeF09cvw0L2cjuXYBqiLtrM7d0C9Yi6Bo+wsxwnUUQYUhB6czahsJx/zuc+3I5f5D/Z4uBrqdhTJVdfQs7TVC8Gwo85cmRGXguAOCt4DSNtPgpzugopzMuF6tFkphBOsIDqlSTIb7PrLnZbfnbvHzrPH7uENeqqxwzsMnW27/T4oU/pSffaeU7ECpv8u6ESejP78Xdcl+U5py+L/NvH9BNY57XzrbVPTUfl3+YqyBZBNNO0Kr8rOUHepIjiprHK7snBN1p/10a/ps7ccXFon3BByDEq49bURUPNcrkA6UG0HVGrkR9iUYLkP5ZQJaOtKmFQoJInUFWtHzVM8mZGtbeP1NOvnKAS7K3FiXruIySXe5afzjiWMq97hz4nBvOexzgx6HjbfEnR+aQw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 10 Mar 2026, at 5:49, Sayali Patil wrote:

> run_vmtests.sh contains special handling to ensure the hwpoison_inject
> module is available for the memory-failure tests. This logic was
> implemented outside of run_test(), making the setup category-specific
> but managed globally.
>
> Move the hwpoison_inject handling into run_test() and restrict it
> to the memory-failure category so that:
> 1. the module is checked and loaded only when memory-failure tests run,=

> 2. the test is skipped if the module or the debugfs interface
> (/sys/kernel/debug/hwpoison/) is not available.
> 3. the module is unloaded after the test if it was loaded by the script=
=2E
>
> This localizes category-specific setup and makes the test flow
> consistent with other per-category preparations.
>
> While updating this logic, fix the module availability check.
> The script previously used:
>
> 	modprobe -R hwpoison_inject
>
> The -R option prints the resolved module name to stdout, causing every
> run to print:
>
> 	hwpoison_inject
>
> in the test output, even when no action is required, introducing
> unnecessary noise.
>
> Replace this with:
>
> 	modprobe -n hwpoison_inject
>
> which verifies that the module is loadable without producing output,
> keeping the selftest logs clean and consistent.
>
> Fixes: ff4ef2fbd101 ("selftests/mm: add memory failure anonymous page t=
est")
> Signed-off-by: Sayali Patil <sayalip@linux.ibm.com>
> ---
>  tools/testing/selftests/mm/run_vmtests.sh | 46 ++++++++++++++---------=

>  1 file changed, 28 insertions(+), 18 deletions(-)
>
> diff --git a/tools/testing/selftests/mm/run_vmtests.sh b/tools/testing/=
selftests/mm/run_vmtests.sh
> index 7273c3e18227..7f3a3027cd9a 100755
> --- a/tools/testing/selftests/mm/run_vmtests.sh
> +++ b/tools/testing/selftests/mm/run_vmtests.sh
> @@ -250,6 +250,27 @@ run_test() {
>  			fi
>  		fi
>
> +		# Ensure hwpoison_inject is available for memory-failure tests
> +		if [ "${CATEGORY}" =3D "memory-failure" ]; then
> +			# Try to load hwpoison_inject if not present.
> +			HWPOISON_DIR=3D/sys/kernel/debug/hwpoison/
> +			if [ ! -d "$HWPOISON_DIR" ]; then
> +				if ! modprobe -n hwpoison_inject > /dev/null 2>&1; then
> +					echo "Module hwpoison_inject not found, skipping..." \
> +						| tap_prefix
> +					skip=3D1
> +				else
> +					modprobe hwpoison_inject > /dev/null 2>&1
> +					LOADED_MOD=3D1
> +				fi
> +			fi
> +
> +			if [ ! -d "$HWPOISON_DIR" ]; then
> +				echo "hwpoison debugfs interface not present" | tap_prefix
> +				skip=3D1
> +			fi
> +		fi
> +
>  		local test=3D$(pretty_name "$*")
>  		local title=3D"running $*"
>  		local sep=3D$(echo -n "$title" | tr "[:graph:][:space:]" -)
> @@ -261,6 +282,12 @@ run_test() {
>  		else
>  			local ret=3D$ksft_skip
>  		fi
> +
> +		# Unload hwpoison_inject if we loaded it
> +		if [ -n "${LOADED_MOD}" ]; then
> +			modprobe -r hwpoison_inject > /dev/null 2>&1
> +		fi
> +
>  		count_total=3D$(( count_total + 1 ))
>  		if [ $ret -eq 0 ]; then
>  			count_pass=3D$(( count_pass + 1 ))
> @@ -540,24 +567,7 @@ CATEGORY=3D"page_frag" run_test ./test_page_frag.s=
h nonaligned
>
>  CATEGORY=3D"rmap" run_test ./rmap
>
> -# Try to load hwpoison_inject if not present.
> -HWPOISON_DIR=3D/sys/kernel/debug/hwpoison/
> -if [ ! -d "$HWPOISON_DIR" ]; then
> -	if ! modprobe -q -R hwpoison_inject; then
> -		echo "Module hwpoison_inject not found, skipping..."
> -	else
> -		modprobe hwpoison_inject > /dev/null 2>&1
> -		LOADED_MOD=3D1
> -	fi
> -fi
> -
> -if [ -d "$HWPOISON_DIR" ]; then
> -	CATEGORY=3D"memory-failure" run_test ./memory-failure
> -fi
> -
> -if [ -n "${LOADED_MOD}" ]; then
> -	modprobe -r hwpoison_inject > /dev/null 2>&1
> -fi
> +CATEGORY=3D"memory-failure" run_test ./memory-failure
>
>  if [ "${HAVE_HUGEPAGES}" =3D 1 ]; then
>  	echo "$orig_nr_hugepgs" > /proc/sys/vm/nr_hugepages
> -- =

> 2.52.0

+Miaohe

LGTM.

Acked-by: Zi Yan <ziy@nvidia.com>

Best Regards,
Yan, Zi

