Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 50B34606A31A
	for <linux-mm@archiver.kernel.org>; Wed, 28 Oct 2026 23:13:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=FyqiRcMv
Received: by kanga.kvack.org (Postfix)
	id 2F9CF6B05B2; Wed, 28 Oct 2026 19:13:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2AD926B05B3; Wed, 28 Oct 2026 19:13:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 174F46B05B4; Wed, 28 Oct 2026 19:13:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id E5BD56B05B2
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 19:13:21 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 6BDE6C0276
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 23:13:21 +0000 (UTC)
X-FDA: 85373588202.17.393C97C
Received: from DM5PR21CU001.outbound.protection.outlook.com (mail-centralusazon11011029.outbound.protection.outlook.com [52.101.62.29])
	by imf13.hostedemail.com (Postfix) with ESMTP id 983CA20006
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 23:13:18 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=FyqiRcMv;
	spf=pass (imf13.hostedemail.com: domain of balbirs@nvidia.com designates 52.101.62.29 as permitted sender) smtp.mailfrom=balbirs@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793229198;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=g5xkFd6sI1uZhxmA+Gp9yYHBGpaJVAJ+fhDw86P+1AI=;
	b=27QmEgWg+lTEqtZpQU2HGmLEwEIWW8nPBKaIKm/e5i3oreR+wYM7RN+2hGOF1EDiK43ZaX
	CZoN+egmEzZBBHBDhdAPl/NQ4iiXLSkp3IcdT7j2gB3+dvApoANp7PLB3EeQhezeM2PvlZ
	GQBQJ2/klR1JPhuTNOBG9kErEA7/BtU=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1793229198;
	b=smpoaRUuboF+VVhXkT/8WT+Af7GjqovoIDqyO0HDEgaj4xDaBR4td5cMcdvcsdFJ8W1pFc
	PaywvHjuoFb1uBzs8+EdLE0D7eGWc3/R1VZSGfX825We/b7QFUgVJwHxNNQ/EJzHl/3sTH
	nMe/1dt1oXAPCwlCJsQR962JF97Tevo=
ARC-Authentication-Results: i=2;
	imf13.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=FyqiRcMv;
	spf=pass (imf13.hostedemail.com: domain of balbirs@nvidia.com designates 52.101.62.29 as permitted sender) smtp.mailfrom=balbirs@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=XVqWQgoGDde2H9KILAInPhoTrCx241JThpFz9a5r9DyolOU0JpdfJ1GySBvGNheN3swqjor2Bgbi79squDwduiMFD1VouO7yHcKgRMpwqRQwqzGBNvQLA8nkKiW9c8YZy+f/yLyreuwPBjTkgvpZvKYrQMtR+Iq4BG7gc5IyaM1ljQqaMspbRDrROoXS21gTk2FLbTL5IIBSxN7jyNAvrVKx/PfNNXp+LThB6eE04KZNtNZgrMN9MszaBZFKkGsJKolrC9XIhUVGm1oN6LXhA1DuNMjkXwcK9Ml4SqxnqDi5ESyAV4n+xPpXcjmz8b/PW/BTXxOaglKlnGr1E6zW4w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=g5xkFd6sI1uZhxmA+Gp9yYHBGpaJVAJ+fhDw86P+1AI=;
 b=dyJonr8dIDHC9xc5UNmOlHJCP7WRdhtjv9snVDb+7CVgSE1SYaDpBDQQ990tT0yixmmRVM5OzUQFVWieNM5XgMAuAUs2a8iwE+dFPTd8Uj36cAda2wgFRug802UnWNMQcyWO1pNV1c4himWrJ8eEvwz3OGay00lpapGIB1SKvsxLB9xWiE/6Zdr4UhPGq0q8vr9/AO52HsjvEQ3Kj+rbcuwf3vpXRJAgJm7k4ReuUtsy9DArOfm798OM/2Is8P4kHV/OdUeQXpO46L41+mUhyjpgCOaQsWCqVRk4SBKrVa6Lod04cKnqwEQ2jpcTUQHeeB0mhFTC8cdBc85DYsCIzA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=g5xkFd6sI1uZhxmA+Gp9yYHBGpaJVAJ+fhDw86P+1AI=;
 b=FyqiRcMvs3oC6xEMLrwSk7xl7lSl5SMX0tGm1vrMXKWCYeDnvA/6liLMVZeGD9MClRDIfZohWrgQfVZuFbTlfsfnfH5EEx9BoewtJFqpM45fbWuXHE26cy+nIUIn9ORVDbA0bcpUoljKQhdcxT3H30zq22wGTc94KmYgc6ZfTYfoQFhhpDp5HLFXvEJYR7RovtBdLyrPiCfA/1RAGiXiFHb+Ibnw/drvKSul6TIdxd5L6u519uuiNCZhiVdQyL+wXKTyQzmsqv/UO5sNJqaSK3nFjXBWnPx2D4sJi9nMxW8HIqvv/CNv0Xy5lVN6lGxtdYF82vPn/kxmmpFeDrn1vw==
Received: from CH3PR12MB9730.namprd12.prod.outlook.com (2603:10b6:610:253::9)
 by SJ2PR12MB7848.namprd12.prod.outlook.com (2603:10b6:a03:4ca::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.569.8; Wed, 28 Oct
 2026 23:10:18 +0000
Received: from CH3PR12MB9730.namprd12.prod.outlook.com
 ([fe80::843d:c1f0:b2ed:4128]) by CH3PR12MB9730.namprd12.prod.outlook.com
 ([fe80::843d:c1f0:b2ed:4128%4]) with mapi id 15.21.0569.007; Wed, 28 Oct 2026
 23:10:18 +0000
Date: Thu, 29 Oct 2026 10:10:13 +1100
From: Balbir Singh <balbirs@nvidia.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Gregory Price <gourry@gourry.net>, Zi Yan <ziy@nvidia.com>,
	Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Vladimir Davydov <vdavydov.dev@gmail.com>,
	Michal Hocko <mhocko@suse.com>, Hugh Dickins <hughd@google.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Lukas Czerner <lczerner@redhat.com>,
	Carlos Maiolino <cmaiolino@redhat.com>,
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
	Daniel Verkamp <dverkamp@chromium.org>, Jeff Xu <jeffxu@google.com>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	David Stevens <stevensd@chromium.org>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	William Kucharski <william.kucharski@oracle.com>,
	Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>,
	Nhat Pham <nphamcs@gmail.com>, Miaohe Lin <linmiaohe@huawei.com>,
	Naoya Horiguchi <nao.horiguchi@gmail.com>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, Chris Mason <mason@kernel.org>,
	stable@vger.kernel.org
Subject: Re: [PATCH v3 07/15] mm/shmem: stop retrying folios that cannot be
 split
Message-ID: <auKA1a0uYXfpOjFi@parvat>
References: <20261028-fixes_shmem-v3-0-4ce3baf2db4b@kernel.org>
 <20261028-fixes_shmem-v3-7-4ce3baf2db4b@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261028-fixes_shmem-v3-7-4ce3baf2db4b@kernel.org>
X-ClientProxiedBy: MEVPR01CA0005.ausprd01.prod.outlook.com
 (2603:10c6:220:204::14) To CH3PR12MB9730.namprd12.prod.outlook.com
 (2603:10b6:610:253::9)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB9730:EE_|SJ2PR12MB7848:EE_
X-MS-Office365-Filtering-Correlation-Id: 164170a9-e714-4524-cebb-08df3548a1d4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|23010399003|7416014|376014|261028144727099003|4143699003|11063799006|56012099006|261009223027099003|261022105027099003|261021121427099003|261026140227099003|10067099003|261026121527099003|18002099003|22082099003|6133799003;
X-Microsoft-Antispam-Message-Info:
	Y5Tsh81ZCFKPtVv5o5Tbq8rAU53TeR4EYJj2QK+b51OmmV7mRucCVgCeGEkHtyQ4QTYYNu45NTV71VysDqjf2HCglFnFfNMBSItFhIhNtQor2HyLw5MpV0OxR++rzTANh1hjIOQ6l878/I/H5zQCrLmrsmFUY1hqAiNWbEbJd2EAMQ4HXIElXLr/9Lj9jsPiTia60yhKibeN66KWUm+Gs+UngOJBsAjeTP/2eR+UYoFQ/HZR4Hmam6NEKo1axjiPFHUXCRHYacfkUxgzhfKpgKAhBCWC983HcodkTmNdHSQNm0x4TBzHwsyASBF1WBdnRbgVgEKAIUAUg8gGP4a0uz5g4jnUVBWkHdtTUnHaqwxNlOuIHODINwLQKkZI+/zcO6Ql5PXnKyQ/ckwupiFnKL8bOIFRDIa6Po0hLJcWkyTW+ZQe7Aobm8w/YKwCfGl+V6WFAKkFBk2VdouRsHBxSIoO7TXkVVgaxaiYkePybycJJMUzuO7cpdCVeJLCwdLNL90UuEbl0GYjE8p5HnaA9/8ju/xaFlRDmG5IGltrE06ymI8zWqPhPUCF3Xs+9ufk5/Wxs1sXnN1UM3fXjsnhpX70RTcyNGt9NiWrmFN3eWrNRAeLtH+Aj996s18EVVyBOyPbW9V/acgaybaJ2dnIjf5c7ZQ7OZWL6AVXQZ2T22k=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB9730.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(23010399003)(7416014)(376014)(261028144727099003)(4143699003)(11063799006)(56012099006)(261009223027099003)(261022105027099003)(261021121427099003)(261026140227099003)(10067099003)(261026121527099003)(18002099003)(22082099003)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Yfq3k2VxQNxnY+D5aMOtcSDk7GgCLVViSdSEdvKKnEhWbDlgDJQeJddUFf78?=
 =?us-ascii?Q?vs20+oETtGBa4S0p2GeHDxJOc/LotN3RNm1CjYQcnvcZ+6WI2jx+cDT7WiF2?=
 =?us-ascii?Q?VRnlaxu1H68T/NsoZ7/nLmpb7R+5Wu2n8Qs3SNt5jL1GGEFshXSnKhwrspsC?=
 =?us-ascii?Q?36MKNmLu5IFziqHMWEjJPZoW/raSp+bUne5JvhNGdq6H9UTEageRMvXa9yi0?=
 =?us-ascii?Q?M3FEjoJyUZHgcitqk0lgey89Cdcil4QiR/g+rFgR1IQclKHYzpHdy1gFwpm3?=
 =?us-ascii?Q?tfB9yU6+dYEH3gL+Ckq5fRA8hydITHjyUeg53Q59bbG+jyKFunBL9U3jLiL8?=
 =?us-ascii?Q?APCbHthwqJEEX71AizxQoyOVV+UG6/tk8oVT2V+Kocrh+FtCNMbD5rGzG88w?=
 =?us-ascii?Q?twp/kTmsGzgX822978LK+ZEpe5UwtHBIj6XmBopTce897CbeitiJfF5MzWWu?=
 =?us-ascii?Q?0wYHPIFO9l2kgEnSOCq/NRNupxxhaGGliEmR/dLiKIcAbfn+mysjCF1gNZo0?=
 =?us-ascii?Q?kApnLuoQy/0Gc9RYNjks/qwJNw1ofg6ds4Y6mPgeO+zL6CfgEJWTNCbmo9JB?=
 =?us-ascii?Q?OBAtz0hN2g+QMgDogvpgC+7V2oFy2hnnh3/dpRM4GiMmJg8pELHiKhzuxmnM?=
 =?us-ascii?Q?C8l/+In2Ew3QT1Ef7r5hYyOFwa+ojdOCACkuRQYd/Ou67YrgxLuTMZhRuWfZ?=
 =?us-ascii?Q?XHGE99jQkgOR+/PEKtg72CrbvKsKsyE4I7/rfHe57O7l9hgyrVpBEixyYnYb?=
 =?us-ascii?Q?8bjY5OdGUK0t9RHNP0moD/q54oHm2Ck+DodwPUET41h5a+NKe75gzWQocpEh?=
 =?us-ascii?Q?6cZtOGvFlyWonK4eN9eLnyZ/Of0bRF7Mvs1NfKF4MLeD57/4P1Pln+X9HFSM?=
 =?us-ascii?Q?4/V9iTkw+JcSfvIxu1NV4uD81I+EexQaJ9tUpkU12Ad2P1tCHFV7Tb8Vt5a7?=
 =?us-ascii?Q?Sru+nn3Po6lR75tvsI4aHsR/rMyfffZyPOTA5cV5wO0whk/I8Ry3oQmJtUyH?=
 =?us-ascii?Q?JBRZInl2QnGteAKzkC2gZRgKpZyYqdBh33l7qQ0Av1I0eXrhQXEeiW8L6CHK?=
 =?us-ascii?Q?D2Hf6k4Oe8+Y9JPNC014gt+YvAOV/CPDPtqGYoHz4VYa7ZQcY7qOU9fKw7Mi?=
 =?us-ascii?Q?rL+dYqYNAKKTYJAfLS5ErsfyNA4lebn4FeWTkfcbvZQy48p3f5udEovoQ7pN?=
 =?us-ascii?Q?2yma+Em+1boeG22bFx/rp2Xvv0W2X5lK9AaRLBL3mw+qrfyYPa4BigS6mxa/?=
 =?us-ascii?Q?N2rPoKg6dMFfXvYdrLH0A7oCvoMEGpsVRd4NIi5gBgWxQf9OC7rfpsd9Zvy+?=
 =?us-ascii?Q?nT23ubTqjZUZtWNaid9Rzp0XFmcPYCzWJbYK4NUqBxavzPdoWQ0lXZqfR4qc?=
 =?us-ascii?Q?bwv2sF6TChTfEh9vEkjWnVgv0Fh+BydNLWcmGiwV9mX1JzurXMMkH9gC3MQL?=
 =?us-ascii?Q?ptBzbP8Dp7iO7nasmTiJneLlE4SJzbzld/q3kFEf/CoWf/HWLHzYFJgjTqvm?=
 =?us-ascii?Q?eUnDR5GhedE6XX+psNDuXN9aUxka7+tX88k3dhzmz9AJm5ADe56K0KSNb1BU?=
 =?us-ascii?Q?TQZX89aGyvUnomHBFOPHVVa4U0eiiI1MY6aeEZAsK9k/omOGXHqgCK6UzsGd?=
 =?us-ascii?Q?7BJWYamh7rsYwWOHmeBFjMUQ0HN7SomlMaT0KXbb5C0n70Duy/8qeQIvia2O?=
 =?us-ascii?Q?iU5o0wfw/M+ZhS37EDlE4OWm3wpOUZ1Shlkoto6qM2w8G0+KhC3l7aPuXoWs?=
 =?us-ascii?Q?rN2RhDH8XQ=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 164170a9-e714-4524-cebb-08df3548a1d4
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB9730.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Oct 2026 23:10:18.1668
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 713BIuzGXGGlzYsZkm2XilAt3232gSz2v98WGU+5c55j/xArngnaobZFCfRDOYxteOmO5wzUeYxXQq2KOWoFOw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB7848
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 983CA20006
X-Stat-Signature: 8wq3zwuhyo36cuunyewpm9yrgkcccoux
X-Rspam-User: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793229198-380995
X-HE-Meta: U2FsdGVkX19Ic4cgsfg0ZLaCPSFmA/et0lyE00//OB8YG0PSbK4KwDWSSpjIzhvV5UQwB49b7sSVzXGraep6uBL6c6Xf4NekebxyKYnZh9eGuS8t1jKRosi4n6OkzWL3OHlwIxgMWGw/mOWQKcBBxqQ9SyCu0nomVKbg1garUp17u6638DnKxbS85d0WNv54qaXhOxaFWnWz5sTmHM+0idLBNzZwUKo8A9KHLQJWHoQm8qPjAWHwms5cZHNsMzjCcq29Fx7sUEmcnQeF0SCYrxk8uKNkqy/18NlPznRS2ea1e5CsqhxFrWfITcwdryMbyOnn8G+wnNIQNRNu5xZ+g+BWy6KZ3wA0bJffE7O0VfjMsi/IxpbsssuJqZ3Kd9kwGHFUpmCHi1KRT/Mvh62GSY7Mm+/5HEiS6C2lqjeV/Qqz4UsISDfrp8BaMbBT5vsTkGWneW9hzWWJmAXIQbSC2hDYMPi9O8y6eyrJq6nUvBwAarLPTYGSreczSNaL9fw0p8NQznxNP5m7c4UsmY2/QHOm5pDh6zudpFuWQqEIHO5vj2w4izJAZDq0n6XLHZz0risO5Ih/hO72rfjB/VrSYupzlwJZoTKVxGrRLyJFas5LiR1yTnbcrhVr6ozGCt8M59AgP2L0PBuhSKvyB7FfJFKPIYCC9wjVGMlussQJ/4ZgatnX0WQmRtZtkXOs+19rDPDJ2ZKnObXGM7YzmjPhaV9o3pPAqm8UVSOGSqGm/d2t5ShEPZomxll/G+kwTmGgYmx8wG6Yoh0JjVoY3c4cLleYTf8ls3rzOY+sunQqM/TMQHzUsqWGuyjJBb68PLdqhQyynp//1sbVfbvIW+fMz4/loSlRxCLpEuPQIQFLNm8FKkv6leDQtdlr1nw4dz973eyjKFHa23vBIX+eTAiLU7QatJSX9sM6pc98d+/2mlGbgyebdry21/KXypsUxEr6VmBiZAZ0ZmOzLUn1cen
 rcXG67Pt
 +iFuMm0B19RC5sjJ61V1gf6+beKYBC5bURjgYAIT42RfCI5ydGGZ9XbfNjesoDRCo5qnDsH5ENnogg8zrgCnwwKpIXFV3URP5c4adBwRDR2/HIdASmpQgW10cY28+9eO0yfqFWtHSJD6j/0p7rBpLcwHNuMPnqh1QnOIrksU65Xm3Ry4Q92A5TL4+yxInPnvnyFOfltdjEjBkZWf44sJIV3kIeVXFv9hOrgRuP8C0vnz7A87C/yIRJ6jcimZZRUUyR51B/PZCi5RrgO1kSzZbn9Ij65Gw/Tng5be2T/1O3SJE9hDh9JY7hhP/t5asoLSuw8whBgX+uBrV0I9vYG6ar61tO/xTXIGJ77u5fD4IL//iFYECopvrwzbxYJm0rNzeYnZ7g0BDcaZf3Xu+4QZaxxQNV+uYpUBncCaH6ACjZtau/CE3tRrQb75S2cg36X/Dk0PWvEW2agpVsLsZTQSxp2BrIuLQktMOI/UMS2MHqQy0MqLEk451fhOYwzwvzqt/JFRFU7DmkmhsuXNQ3gPgIy2I+xakleFF/bggdooMYYrqhAdaLvJpiuGf6n6AVvyjhOPm63/gr4a63dg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, Oct 28, 2026 at 10:55:05AM +0100, David Hildenbrand (Arm) wrote:
> From: Chris Mason <mason@kernel.org>
> 
> A fault or collapse can insert a large folio crossing EOF after
> shmem_undo_range() has handled the boundary folios. If splitting that
> folio fails, truncate_inode_partial_folio() retains it when it is dirty.
> The final scan then repeatedly finds it because it restarts from an
> unchanged start.
> 
> Truncation keeps the inode lock and ignores fatal signals while looping.
> A concurrent unlink() can then block other directory operations while
> holding the directory lock and waiting for the file's lock.
> 
> Advance start past the retained folio, whose truncated part has already
> been zeroed. Do not move start backwards if the failed split has shrunk
> the folio.
> 
> Fix generated by an LLM and sent by Chris Mason in private.
> 
> Fixes: 55ac8bbe358b ("mm/shmem: fix race in shmem_undo_range w/THP")
> Cc: stable@vger.kernel.org
> Signed-off-by: Chris Mason <mason@kernel.org>
> Tested-by: Gregory Price (Meta) <gourry@gourry.net>
> [ david: split fixes, simplify descriptions, adjust comments ]
> Reviewed-by: Zi Yan <ziy@nvidia.com>
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
> ---
>  mm/shmem.c | 9 +++++++++
>  1 file changed, 9 insertions(+)
> 
> diff --git a/mm/shmem.c b/mm/shmem.c
> index eddd5870be07..50d526edc2d4 100644
> --- a/mm/shmem.c
> +++ b/mm/shmem.c
> @@ -1481,6 +1481,15 @@ static void shmem_undo_range(struct inode *inode, loff_t lstart, uoff_t lend,
>  						index = start;
>  						break;
>  					}
> +				} else if (folio->mapping) {
> +					/*
> +					 * Splitting failed, but the part in the
> +					 * range is already zeroed. The folio
> +					 * was not dropped, so skip it when
> +					 * restarting the scan to avoid retrying
> +					 * it forever.
> +					 */
> +					start = max(start, folio_next_index(folio));
>  				}
>  			}
>  			folio_unlock(folio);
> 


Reviewed-by: Balbir Singh <balbirs@nvidia.com>


