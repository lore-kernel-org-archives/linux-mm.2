Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3F0E0C44539
	for <linux-mm@archiver.kernel.org>; Wed, 22 Jul 2026 15:04:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 174656B00AE; Wed, 22 Jul 2026 11:04:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 124D56B00B0; Wed, 22 Jul 2026 11:04:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F07516B00B1; Wed, 22 Jul 2026 11:04:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B0FC76B00AE
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 11:04:49 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 389A48011A
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 15:04:49 +0000 (UTC)
X-FDA: 85016734698.19.24971F8
Received: from BN1PR04CU002.outbound.protection.outlook.com (mail-eastus2azon11010011.outbound.protection.outlook.com [52.101.56.11])
	by imf05.hostedemail.com (Postfix) with ESMTP id 5EBFE100006
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 15:04:46 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=fail ("body hash did not verify") header.d=Nvidia.com header.s=selector2 header.b=dNe4yngK;
	spf=pass (imf05.hostedemail.com: domain of ynorov@nvidia.com designates 52.101.56.11 as permitted sender) smtp.mailfrom=ynorov@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784732686;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yoxR66QcJZXkhXlaJ3eTwCAeJK0GJOapKOg6tBVXAZo=;
	b=uNP7XKTCr7uzgb/nTasZSoK4pCeyyexDMAXIHn40GpZ0v2a6vTO3jNfjqn+YWNpiD5XfLA
	uQ+oyXfMs9WP6bQRN/d/we79PFXbm4v61t41qN5ww0IKZ9yvAv7tBVxPoeCdP9sFWiOvLH
	MhaiTgho9hcx8vNDJvZsFXIzFgzkQ/c=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=fail;
	t=1784732686;
	b=vCgm4v3K5Aws1lDnZiddkaL2bmKyLQAAYk+iRAfMe5T/ya9PhBS8K4bDQKIm+Ab35rvTK9
	D6e+SvUNPeAnYfKzaBOcdpitf1P5e6ZUT+1o8F/wwbBZR0xZAmdzzgL5OxYh214c5OfjkK
	k6anDuvAYl2PvYr7ZP6+ZQTIaRBYSxw=
ARC-Authentication-Results: i=2;
	imf05.hostedemail.com;
	dkim=fail ("body hash did not verify") header.d=Nvidia.com header.s=selector2 header.b=dNe4yngK;
	spf=pass (imf05.hostedemail.com: domain of ynorov@nvidia.com designates 52.101.56.11 as permitted sender) smtp.mailfrom=ynorov@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=VFu48Iiwq5PBUpXRQNVr+ex++YbumjckWWNQHbx2SKyxkPllCR2gwsErBgT5slpDDEfzAG4k6wivihrZHOXwxuaAQ7pvNRaMSKym/XfTonSOJHCl9umer4R3CJYnZxEk75eO+paGu8rKZHP29Pi6400pwQI0MABT2Luez7GNzSceF4yB29jsT8TF1Pc7nBkBtaw+U9VV/16h1lzxZ6LdBZVnlE8si4LsUoIs7L6z7ZsS6gcEpw1JQNiz5+fkptF38cSKR4/UUGQEf495UykJzu3OQ1MCQMIbk/OntvLKh96gFDMsGmpVNEgoje6jW63SjKbX/z3jbjOwL3KmdI8kXw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6/5L/lrBrzrpS837jSiELg7MBT6yzSqnwlWt08w08AA=;
 b=qakS+MMxjfs6ywaIGhXbedTTDVUDiMOeJYdvfxMN2W8+s/A0im6TX0wvpdfdrpH2qvvGv3tWCUDCNfizHjr9/KslO+A8CJkkpKpmOgW4rYYDi9UAU+hriBPjozcWKlopczZx4bXC3wnuT6761Whhd0u6LRZfycRauuaiJi+arbm0wNujjHaATJy7fQ6+LxqsaByBrSfoWhYMpqAk2g8jBJVPxU1SOTV1iQ5ZZ4RG1CAOCXf1bA1N17BcApTgVMQNx6Br93/BDeYl+sonDOYATbk9J8h0/zk2g5gXurPcJB0781OXyK/vSBFVCjmXu5wOAHm/8Mf415SUVKPIgt9bDA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6/5L/lrBrzrpS837jSiELg7MBT6yzSqnwlWt08w08AA=;
 b=dNe4yngKXYgSE7uO+QxLSShhyH2kAdiNNq1oPjMYTA8g3DrzbFx2zneSDUAbEuRu6v5+20mj3MfMz0n2tOH8e0qw6yKcvJjFgCzeOP7QK6KJFqnncf3V2wYYKz9AkF7RnMJoVsnun7yCUFbIDu/HqBb9OYx1+AyU7p5D0T971m+S9bIn0wSmgidM/t8PwNChyvb3TPhiwwPbN3e7h3K1bvjfHR4Ja7KNuy8se8I98HehPtlbzv9uFu37yZlPWRnDlgAOuqRvg+ko4K7GIA0dqhJHswo/1GN00acdLsuquzD9Azhvogp5mp7oW2MU7qH83BMijCtiN68b97/YeDswig==
Received: from LV3PR12MB9356.namprd12.prod.outlook.com (2603:10b6:408:20c::21)
 by MN0PR12MB6126.namprd12.prod.outlook.com (2603:10b6:208:3c6::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.223.18; Wed, 22 Jul
 2026 15:04:37 +0000
Received: from LV3PR12MB9356.namprd12.prod.outlook.com
 ([fe80::1c36:31b4:c420:6286]) by LV3PR12MB9356.namprd12.prod.outlook.com
 ([fe80::1c36:31b4:c420:6286%5]) with mapi id 15.21.0245.009; Wed, 22 Jul 2026
 15:04:37 +0000
Date: Wed, 22 Jul 2026 11:04:36 -0400
From: Yury Norov <ynorov@nvidia.com>
To: Eliot Courtney <ecourtney@nvidia.com>,
	Greg KH <gregkh@linuxfoundation.org>, Burak Emir <bqe@google.com>,
	John Hubbard <jhubbard@nvidia.com>,
	Alice Ryhl <aliceryhl@google.com>,
	"Liam R . Howlett" <liam@infradead.org>,
	Andrew Ballance <andrewjballance@gmail.com>,
	Matthew Wilcox <willy@infradead.org>, Gary Guo <gary@garyguo.net>,
	Onur =?iso-8859-1?Q?=D6zkan?= <work@onurozkan.dev>,
	Pedro Falcato <pfalcato@suse.de>
Cc: Alexandre Courbot <acourbot@nvidia.com>,
	Alistair Popple <apopple@nvidia.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Andreas Hindborg <a.hindborg@kernel.org>,
	Benno Lossin <lossin@kernel.org>,
	=?iso-8859-1?Q?Bj=F6rn?= Roy Baron <bjorn3_gh@protonmail.com>,
	Boqun Feng <boqun@kernel.org>,
	Daniel Almeida <daniel.almeida@collabora.com>,
	Danilo Krummrich <dakr@kernel.org>,
	David Airlie <airlied@gmail.com>, Miguel Ojeda <ojeda@kernel.org>,
	Rasmus Villemoes <linux@rasmusvillemoes.dk>,
	Simona Vetter <simona@ffwll.ch>,
	Tamir Duberstein <tamird@kernel.org>, Timur Tabi <ttabi@nvidia.com>,
	Trevor Gross <tmgross@umich.edu>, Yury Norov <yury.norov@gmail.com>,
	Zhi Wang <zhiw@nvidia.com>, maple-tree@lists.infradead.org,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	linux-fsdevel@vger.kernel.org, nova-gpu@lists.linux.dev,
	dri-devel@lists.freedesktop.org, rust-for-linux@vger.kernel.org
Subject: Re: [PATCH v3] lib: test bitmap vs IDA vs Maple Tree performance for
 region allocations
Message-ID: <amDcBOmcxxz0bCOF@yury>
References: <20260717053241.916441-1-ynorov@nvidia.com>
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260717053241.916441-1-ynorov@nvidia.com>
X-ClientProxiedBy: LV3P220CA0023.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:408:234::24) To LV3PR12MB9356.namprd12.prod.outlook.com
 (2603:10b6:408:20c::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV3PR12MB9356:EE_|MN0PR12MB6126:EE_
X-MS-Office365-Filtering-Correlation-Id: 2bbf1fc2-8f6e-48b9-1932-08dee8028c37
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|7416014|376014|1800799024|366016|921020|6133799003|56012099006|10067099003|11063799006|18002099003|22082099003|3023799007;
X-Microsoft-Antispam-Message-Info:
	Z4HSotPgxvLoA6nVTiZjtVRO5G2V7dIL+DXbMYBfzmTCYFUjjWxlgDj4GFikPMtuZ9lluteOfZevkguRP5a6+MEOHjxSjs4wQqz3yRZWtQgr+Ju02/5m3lEQvRdjjx3487Q0xDzoRcSwPRWPPYpkQ8TZTVeyJYk2hQE1A9PVWQfHvQci16h3UDIHO/VTZS+9obuODHrz3ZOHhpcwI0f67Px583OQ0fMaHHFkxkaZS+I8j1gCpMPDlt//8zvxPYwPW9nI+mm2qV5hf65+Nqa33bZXHqWy6TFSGEX4ejQGTSXjsqhBQrdBWSPE7SPCmJyqvXx320BAhQX9EykvACI3KotBX+UYrqvwY0JGIJAZykAzbWny/2Azpp/NYL2qaq0JrI8CRW0J4pAGPXRFODzeaR8sRSDcW0PeYp74ZcjrC3vXPnhRTxEVpr5R3gD8bUrzMG/VAl3/3Be1KaV8q6muZIHugaPKBS2FVvSf/ekvqlhw1cYinZUAb/9wrGOMfTIR1Y7j/WZK6EECvaD6G63/MkZjWoK+2JBNPtzB+t1SIv9dNiy1HR7WfWmjlM1KpGm3ednOgXCB5ZBDHbPRaBszFs1yHlHJd3YMIMYvxuRhkWfk8IvuviVdq/eW8QUHDal+cFbZWwMah5N5Mfe406/Tv/Tk8a7oOM0chSaDH1TM38NRsybGeliSeKhzonid6AYO0nEIulGQcnRn3dSjraZyzA==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV3PR12MB9356.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(7416014)(376014)(1800799024)(366016)(921020)(6133799003)(56012099006)(10067099003)(11063799006)(18002099003)(22082099003)(3023799007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?iso-8859-1?Q?br+YPNsrWpNdIQSSC6ZhzkeIijcZsSbZxCTL2rZjXbXamnVBwKKIoQEBzI?=
 =?iso-8859-1?Q?uw/NBjcLZTS2cizfqmcFx432e56UW4QtC5kz+JOYUa276cIU1iTHPuW1DF?=
 =?iso-8859-1?Q?sq/SQo0bngW77UEs0MDJuQTB40w83zWbtjmPvmHk/1ISjFJXWmQoHo+2w4?=
 =?iso-8859-1?Q?KxxlFeB9lYi2FpSfYOUNKv+Lzxq/wbTSQlVjuDvMXv5PQvS3qMAWQG6Lql?=
 =?iso-8859-1?Q?9PsjMBUpgq/+7+6I3jutJVEqn+Y7ILtzB7yncYvAFf3xnbMxRU1KPWkecX?=
 =?iso-8859-1?Q?Ui5ogg1cGYXMH0EFQGNNMN1gFs5Qx3Af5FqvNTfni24E3W41UU8oZRxUc6?=
 =?iso-8859-1?Q?lwm+6/iLfy2K5qZL2xIcrbwZS2aimds9//SGiVC6ktPWOf3IejUnuY3vVP?=
 =?iso-8859-1?Q?531hN4c2Z8z93oreH9b+LSNkGNNgjA01ZmPl/v/iXN7Fii7BbDvv1eZ5X7?=
 =?iso-8859-1?Q?jVmVtUbe7m33jEIi0B5eU2x20i1qhbrhjBhwUc/6GAnYGTl7vxHFfPq5Gm?=
 =?iso-8859-1?Q?AV+hq6WE1cwkjeCMkabIbYwdESWmmNvhiNIHdbHjzINUpLCSB80lk8I7EJ?=
 =?iso-8859-1?Q?v8YF/s1KIQky0edQqXRN6HAkpHENv1O8hqv/RNCorWqtKIO9nmzKX+6c+N?=
 =?iso-8859-1?Q?JdNtXfyOgZRZ2LyN5ZrpLkLfuqMUJGjJPhmjVGLWO8MNP1CRzwaEzP4cno?=
 =?iso-8859-1?Q?/fGG1BSQItgtUX+nLc/RNEmiGGXzlQQYBi8QUSE+YlvT8YJ2daCkW8znC5?=
 =?iso-8859-1?Q?sQxbnKcw/g7KifE59Mfn5iuq9LYDXN92eY/FnFs715/xaSQEvrzhM4Fwon?=
 =?iso-8859-1?Q?7YG4vaxX93OljB07kBuLaM7T2jYkw7uQGdnhM4ttdOZB8gYQ5rCKSDZdGq?=
 =?iso-8859-1?Q?wb3ohClZiWue8ahFuNZ+zCRYzU+IM71KlqXsTPBhucO+eWFEcno9+GcxdY?=
 =?iso-8859-1?Q?wGJ+TVqYBU9rk2zZEiVlHMNiUkAhtNi5Mq9qhjV1Y3xrhjdgSzv4Gj7OA0?=
 =?iso-8859-1?Q?h2akCF8GWfWG4D8/jJWxI3/1PQmxqDJ33q+HrUNb2mihHfqTjfRy1XKXEU?=
 =?iso-8859-1?Q?slGJa2sye7tTlsYmt7Q5Zp700SA5rkzRefrOMHRwVl7SaSbmqOmqRu1h6r?=
 =?iso-8859-1?Q?M/EuBkqfhm77+g3eBO/X57Daqf1vuhnzwa8oDMApBpCDBnD2iNoiXlMMbF?=
 =?iso-8859-1?Q?8rn+5Sl3bS14UXqlIsS2VZh+sIbxYFwQ4z5LiJJNL8USAmML7GfMfk6q1W?=
 =?iso-8859-1?Q?osXphfG/BbQWZ5ENcrwVoHitYk/cjVbcoqFRFobKesRi9L5cJShk1CoBVN?=
 =?iso-8859-1?Q?b8CLN7Nzmw0etZFwj3aWHaCuUCISZ0dEyBSAmdvkDms2IyKopDv+pSwejb?=
 =?iso-8859-1?Q?49CRLiwLQMZOdc+WaTvPPhUrNq8bOg1CYZx5guy/hHbNbJHpmBE/jFZ2Ff?=
 =?iso-8859-1?Q?KJ4hgKOw9iPcYWAIJhzDUIhftUKNXW2semgy0D9bWMf8EizdtXG0XRhiyG?=
 =?iso-8859-1?Q?Z5S3aFMILBsY3N04e48uS8UVzochBaDv4cdorVLrah/kZGU+pfQ5ISMSkb?=
 =?iso-8859-1?Q?pKz+hjC4pySZMg7ZPI69ivEo8GKDd0zM7RJWC05WJJB68nV+ByTXOFpFNn?=
 =?iso-8859-1?Q?FBtyETzA9Y/n6Wzq8GfqnOZovFRJRBz/SebFS5xw0TPhxC1u07KoICGtj7?=
 =?iso-8859-1?Q?qRkLXx/ipQ8ILECBJYx7ARsSwzhVOKUPxL+0bnC6XGMbu1IhsCHYJe8DLa?=
 =?iso-8859-1?Q?BUctadn5bbwPnDMkoZOeKzG40AP5WYbzaGCaoKWOLCUbrt?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2bbf1fc2-8f6e-48b9-1932-08dee8028c37
X-MS-Exchange-CrossTenant-AuthSource: LV3PR12MB9356.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jul 2026 15:04:37.6486
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BtObzB6rXM4dtlnML2wtXI521AKMfAx0AUCQM6a+o6IJVfy43uyrxVQ3Muaism6Zd0YVvLlI2PcMTRYMMm5upA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB6126
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 5EBFE100006
X-Stat-Signature: i9pdrbderosi9to5we9zbbxz7ff3djr9
X-HE-Tag: 1784732686-188109
X-HE-Meta: U2FsdGVkX19ckV55f4laPG/l7e4YcEKFoaN/tfB1ARcW9k3l0QehzrEyP/P0bgFO4iL+zNNkzcgv+IjdsttUHIr/o+pkNqsqVsLAr/LcGQO6q5E1uoDn20Fuev2u2rpOVe2lAFyP/gh1pqKxJrj/HYRaHQoSX8ttvZNL2STjK2SKvfWbhLdH1aHnrZ0+4yclV818Zpw4cJDkwH6LW+wEIIuByHMeAbMMUEWoQR/nqvNppVQrBnI9RrSyvo7xA8Dm1c3rDOLBSU4sV6b7t0DBm/8zqpLy+6Wwu9++liAWIjMCsyCWxzugsH3uYMI7WNkhQNIeB8QzOLDrG1z7K3nHKfgElYevqOz1rHITJHqv8L4oWTYLri2jQgVccLjFfSz3+FrAdUPxY1vtpLBV/lkcUdXEju6EehsU9NRVsMpvywhMFykidYO22WOaA3RLlPj1Cl6lkiPxo36lPxIVho6dAT+/5Qwa3BqbvYY7llkOHR2IT7sfw/cR/rdMPNfzu+cfes/ERwsJPhYD32z/LRp1NyGaD35hrZ4o0Hi0whSMwoV7kV5S1ubfRvk7yW073jJFnZCh9ANon+jsIQ/EiEdsmlDnC/ZZClcclerwqZwHpR7wAljTiBNjj99J/sBvcpSKJH60AkmD2DPwFKMY41r8J8CHotKnp2BDRVmWqQclNtIJ3S+swb4NEGHlQXM6s770x7MY1o0q/RQMncXD8qwOaqF03nLM1aZInPIGpT1DbEBXBIgjdNVsY9Pw6nI39X1XY3013Y8FfTe9xY1LQbLQvWoPWSK/qzxOFYi7LPiATL9sLksSpOdfrjwsQkF75n8n0AMnEuuilcSTe7opdhzLD4McaUcZpRfJ4X6QMS6zVPLy8LwUWUZobV0LLmVcnvw2KOq4O4UL+kurgsfEbNe+IS06gGMwyLPozz3qMdN0j+yOYa8A1Ecgw7PXA1DT9hSrhqFpScvRBymmhxUt89P
 3fMDsVgy
 F5eV4O1/K4d3m5huFmW6tBSaPc2nnAr0oAJZf9ScZjxKz1CAbrK9it6hBKGcT+r85h8PUeCoygOXcLI3T5uCBChIeeG1QJ6RedQ++Ep2s5nr7yARNkn3Knr4XudNPHYIONy44/vmd3RYhjHbF0XIZAf5j28BOtMOk8wIeBHacVJGOuEBiJvGNOAUcmqIHdjo1dKoA0wOAe+/+G5DA3Jvu8HP2wkGx1GMNF+7EhMOz+KdB2OlmkZtmZhWEB/PhKBN8GpvpKUxhdh76esHNL9sSWe8PW3aLHhjQPoybHYnD733LOKgfJP+6XBlgm7rmwfz2zjIQKc0lApmtLGAhpmljdoUYlqewafFnub185JRE/u8+HSmALfrGA0pdlETB/mgqR/+V+qDfh4pOruJ7ANc4uPUWwu/ANvjdPGT9bBqKAX2vLpxPWX4PxUMRNZ5UT3bI//apAdhoidrmEvDVea9IPd1qBNSn4yQ49h1ramQfVFwg+UpdasuFWbuMOZuHZ1FniZ2DV7e4RVOzLQqVbmYwkbr9eUjXqb1+1lEofibicz/huxrD1cFP+xHCqJOVoIQjmPgx3AOmvskXWFT4lXQHcF+s04fR2FJAMka7581soFXdSgSG+7IKzBCcT5zhMF2CgAd7gGSC8Zk9KHU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Guys, please send your comments / tags!

If no objections, I'll move it in bitmap-for-next before the end of week.

Thanks,
Yury

On Fri, Jul 17, 2026 at 01:32:40AM -0400, Yury Norov wrote:
> Compare the cost of allocating and freeing variable-sized regions using
> a bitmap, IDA and a Maple Tree. All implementations process the same
> randomly generated sequence of regions containing up to 32 entries, until
> the configured capacity is exhausted.
> 
> The benchmark exercises monotonic allocation into an initially empty pool,
> followed by reverse-order freeing. It does not model fragmentation or
> interleaved allocation and freeing, nor does it isolate locking or RCU
> overhead. Allocation time includes the terminal failed request that detects
> exhaustion.
> 
> Run the benchmark at several capacities to show how the approaches scale.
> Report allocation and free times separately because bitmap, IDA and Maple
> Tree removal have substantially different costs.
> 
> On x86/kvm, the output example is:
> 
> Start testing bitmap vs IDA vs Maple Tree region allocation
> memory: bitmap is exact; IDA and Maple Tree are lower bounds
> Type      alloc (ns)     free (ns)   regions  capacity  memory (B)
> Bitmap      93457345        176151     60644   1000000      125000
> Maple       11758660      12870146     60644   1000000     1552656
> IDA         31066416      20870824     60644   1000000      134864
> Bitmap        919119         17679      6032    100000       12504
> Maple        1158193       1187140      6032    100000      154640
> IDA          2759670       2116004      6032    100000       14288
> Bitmap         17120          2043       613     10000        1256
> Maple         116350        117537       613     10000       15888
> IDA           243396        202654       613     10000        1872
> Bitmap          1220           262        55      1000         128
> Maple          12076         10106        55      1000        1552
> IDA            25730         20875        55      1000         144
> Bitmap           593           124        18       100          16
> Maple           3599          4782        18       100         528
> IDA             3266          1960        18       100         144
> Bitmap           414           129        10        10           8
> Maple           2143          1385        10        10         272
> IDA              892           648        10        10          16
> Region allocation benchmark complete
> 
> Reported IDA and Maple Tree memory figures exclude slab overhead
> and transient allocations. The Maple Tree figure is additionally
> a lower-bound estimate that assumes fully occupied leaf nodes and
> excludes internal nodes.
> 
> IDA has no region-allocation API, so each region is implemented as
> a sequence of single-ID allocations. The IDs remain contiguous
> because this benchmark fills an initially empty IDA monotonically.
> 
> The benchmark is motivated by the discussion linked below about choosing
> the best data structure for the channel ID pool with the capacity of 2048
> IDs for the nova GPU driver.
> 
> Specifically for 2048 IDs the result is:
> 
> Bitmap          5112           615       121      2048         256
> Maple          78526         59592       121      2048        3344
> IDA           165274        117761       121      2048         848
> 
> The benchmark accepts a list of up to 64 nonzero capacities to test.
> For example:
> 
>   insmod region_alloc_benchmark.ko capacities=1024,2048,4096,65536
> 
> The list may contain duplicate capacities. Each occurrence generates a new
> region-size sequence, which is useful for collecting statistical
> characteristics of the benchmark results.
> 
> Link: https://lore.kernel.org/all/20260710-chid-maple-v1-1-4ee869055268@nvidia.com/
> Signed-off-by: Yury Norov <ynorov@nvidia.com>
> ---
> v3:
> - allow capacities to be configured through the module parameter (Yury Norov)
> - document default and custom-capacity usage in Kconfig (Yury Norov)
> - store and generate only the region sizes required by each run (Yury Norov)
> - clarify the workload, timing semantics and memory estimates (Pedro Falcato, Onur Özkan)
> - report region count and capacity while retaining raw timings (Gary Guo)
> - add post-free integrity checks (Yury Norov)
> - add default capacities of 10 and 100 IDs (Matthew Wilcox)
> - bound generated region sizes appropriately for small capacities (Matthew Wilcox)
> - report successful completion and return -EAGAIN for repeat runs (Yury Norov)
> v2: https://lore.kernel.org/all/20260711063602.426311-1-ynorov@nvidia.com/
> v1: https://lore.kernel.org/all/20260711013910.349586-1-ynorov@nvidia.com/
> 
>  MAINTAINERS                  |   3 +
>  lib/Kconfig.debug            |  13 +++
>  lib/Makefile                 |   1 +
>  lib/region_alloc_benchmark.c | 217 +++++++++++++++++++++++++++++++++++
>  4 files changed, 234 insertions(+)
>  create mode 100644 lib/region_alloc_benchmark.c
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 7cc4bca5a2c5..9e487a94aba4 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -4615,6 +4615,7 @@ F:	lib/bitmap.c
>  F:	lib/cpumask.c
>  F:	lib/find_bit.c
>  F:	lib/find_bit_benchmark.c
> +F:	lib/region_alloc_benchmark.c
>  F:	lib/test_bitmap.c
>  F:	lib/tests/cpumask_kunit.c
>  F:	tools/include/linux/bitfield.h
> @@ -15581,6 +15582,7 @@ F:	Documentation/core-api/maple_tree.rst
>  F:	include/linux/maple_tree.h
>  F:	include/trace/events/maple_tree.h
>  F:	lib/maple_tree.c
> +F:	lib/region_alloc_benchmark.c
>  F:	lib/test_maple_tree.c
>  F:	rust/helpers/maple_tree.c
>  F:	rust/kernel/maple_tree.rs
> @@ -29323,6 +29325,7 @@ F:	Documentation/core-api/xarray.rst
>  F:	include/linux/idr.h
>  F:	include/linux/xarray.h
>  F:	lib/idr.c
> +F:	lib/region_alloc_benchmark.c
>  F:	lib/test_xarray.c
>  F:	lib/xarray.c
>  F:	tools/testing/radix-tree
> diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
> index 1244dcac2294..0451dfca7098 100644
> --- a/lib/Kconfig.debug
> +++ b/lib/Kconfig.debug
> @@ -2683,6 +2683,19 @@ config FIND_BIT_BENCHMARK
>  
>  	  If unsure, say N.
>  
> +config REGION_ALLOC_BENCHMARK
> +	tristate "Benchmark bitmap, IDA and Maple Tree region allocation"
> +	help
> +	  This builds a microbenchmark comparing variable-sized region
> +	  allocation using bitmaps, IDA and Maple Tree. The benchmark
> +	  runs at initialization time.
> +
> +	  Usage:
> +	    insmod region_alloc_benchmark.ko
> +	    insmod region_alloc_benchmark.ko capacities=1024,2048,4096,65536
> +
> +	  If unsure, say N.
> +
>  config FIND_BIT_BENCHMARK_RUST
>  	tristate "Test find_bit functions in Rust"
>  	depends on RUST
> diff --git a/lib/Makefile b/lib/Makefile
> index 7f75cc6edf94..adb18810e3f7 100644
> --- a/lib/Makefile
> +++ b/lib/Makefile
> @@ -64,6 +64,7 @@ obj-y += hexdump.o
>  obj-$(CONFIG_TEST_HEXDUMP) += test_hexdump.o
>  obj-y += kstrtox.o
>  obj-$(CONFIG_FIND_BIT_BENCHMARK) += find_bit_benchmark.o
> +obj-$(CONFIG_REGION_ALLOC_BENCHMARK) += region_alloc_benchmark.o
>  obj-$(CONFIG_FIND_BIT_BENCHMARK_RUST) += find_bit_benchmark_rust.o
>  obj-$(CONFIG_TEST_BPF) += test_bpf.o
>  test_dhry-objs := dhry_1.o dhry_2.o dhry_run.o
> diff --git a/lib/region_alloc_benchmark.c b/lib/region_alloc_benchmark.c
> new file mode 100644
> index 000000000000..e88b4cf55c62
> --- /dev/null
> +++ b/lib/region_alloc_benchmark.c
> @@ -0,0 +1,217 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +/* Benchmark bitmap, IDA and Maple Tree allocation of variable-sized regions. */
> +
> +#include <linux/bitmap.h>
> +#include <linux/idr.h>
> +#include <linux/kernel.h>
> +#include <linux/maple_tree.h>
> +#include <linux/module.h>
> +#include <linux/printk.h>
> +#include <linux/random.h>
> +#include <linux/slab.h>
> +#include <linux/xarray.h>
> +
> +#define REGION_MAX_SIZE	32
> +
> +static unsigned long *bitmap __initdata;
> +/* One more request guarantees that even an all-ones trace reaches ENOSPC. */
> +static u8 *reg_sz __initdata;
> +static unsigned long *reg_idx __initdata;
> +static unsigned long capacities[64] = { 1000000, 100000, 10000, 1000, 100, 10 };
> +static unsigned int cap_cnt = 6;
> +
> +module_param_array(capacities, ulong, &cap_cnt, 0400);
> +MODULE_PARM_DESC(capacities, "Region capacities to benchmark");
> +
> +static unsigned long __init benchmark_bitmap(unsigned long cap)
> +{
> +	unsigned long cnt, idx;
> +	ktime_t alloc_time, free_time;
> +	size_t sz;
> +
> +	bitmap_zero(bitmap, cap);
> +	alloc_time = ktime_get();
> +	for (cnt = 0; cnt <= cap; cnt++) {
> +		idx = bitmap_find_next_zero_area(bitmap, cap, 0, reg_sz[cnt], 0);
> +		if (idx >= cap)
> +			break;
> +
> +		reg_idx[cnt] = idx;
> +		bitmap_set(bitmap, idx, reg_sz[cnt]);
> +	}
> +	alloc_time = ktime_get() - alloc_time;
> +
> +	idx = cnt;
> +
> +	free_time = ktime_get();
> +	while (idx--)
> +		bitmap_clear(bitmap, reg_idx[idx], reg_sz[idx]);
> +	free_time = ktime_get() - free_time;
> +
> +	WARN_ON(!bitmap_empty(bitmap, cap));
> +
> +	sz = BITS_TO_LONGS(cap) * sizeof(unsigned long);
> +	pr_err("Bitmap  %12llu  %12llu  %8lu  %8lu  %10zu\n",
> +	       alloc_time, free_time, cnt, cap, sz);
> +
> +	return cnt;
> +}
> +
> +static size_t __init ida_size(unsigned long nr_ids)
> +{
> +	unsigned long entries = DIV_ROUND_UP(nr_ids, IDA_BITMAP_BITS);
> +	unsigned long bitmaps = nr_ids / IDA_BITMAP_BITS;
> +	unsigned long nodes = 0;
> +
> +	if (nr_ids % IDA_BITMAP_BITS > BITS_PER_XA_VALUE)
> +		bitmaps++;
> +
> +	while (entries > 1) {
> +		entries = DIV_ROUND_UP(entries, XA_CHUNK_SIZE);
> +		nodes += entries;
> +	}
> +
> +	return sizeof(struct ida) +
> +		bitmaps * sizeof(struct ida_bitmap) +
> +		nodes   * sizeof(struct xa_node);
> +}
> +
> +static unsigned long __init benchmark_ida(unsigned long cap)
> +{
> +	struct ida ida = IDA_INIT(ida);
> +	unsigned long cnt, idx, off, nr_ids = 0;
> +	ktime_t alloc_time, free_time;
> +	int id = -ENOSPC;
> +
> +	alloc_time = ktime_get();
> +	for (cnt = 0; cnt <= cap; cnt++) {
> +		for (off = 0; off < reg_sz[cnt]; off++) {
> +			id = ida_alloc_max(&ida, cap - 1, GFP_KERNEL);
> +			if (id < 0)
> +				break;
> +
> +			if (!off)
> +				reg_idx[cnt] = id;
> +		}
> +		if (id < 0) {
> +			while (off--)
> +				ida_free(&ida, reg_idx[cnt] + off);
> +			break;
> +		}
> +		WARN_ON(id != reg_idx[cnt] + reg_sz[cnt] - 1);
> +		nr_ids += reg_sz[cnt];
> +	}
> +	alloc_time = ktime_get() - alloc_time;
> +
> +	WARN_ON(id != -ENOSPC);
> +
> +	idx = cnt;
> +
> +	free_time = ktime_get();
> +	while (idx--) {
> +		for (off = 0; off < reg_sz[idx]; off++)
> +			ida_free(&ida, reg_idx[idx] + off);
> +	}
> +	free_time = ktime_get() - free_time;
> +
> +	WARN_ON(!ida_is_empty(&ida));
> +
> +	pr_err("IDA     %12llu  %12llu  %8lu  %8lu  %10zu\n",
> +	       alloc_time, free_time, cnt, cap, ida_size(nr_ids));
> +
> +	ida_destroy(&ida);
> +	return cnt;
> +}
> +
> +static unsigned long __init benchmark_maple_tree(unsigned long cap)
> +{
> +	struct maple_tree mt = MTREE_INIT(mt, MT_FLAGS_ALLOC_RANGE);
> +	unsigned long cnt, idx;
> +	ktime_t alloc_time, free_time;
> +	size_t sz;
> +	int ret;
> +
> +	alloc_time = ktime_get();
> +	for (cnt = 0; cnt <= cap; cnt++) {
> +		ret = mtree_alloc_range(&mt, &idx, xa_mk_value(cnt + 1),
> +					reg_sz[cnt], 0, cap - 1, GFP_KERNEL);
> +		if (ret)
> +			break;
> +
> +		reg_idx[cnt] = idx;
> +	}
> +	alloc_time = ktime_get() - alloc_time;
> +
> +	WARN_ON(ret != -EBUSY);
> +
> +	idx = cnt;
> +
> +	free_time = ktime_get();
> +	while (idx--)
> +		mtree_erase(&mt, reg_idx[idx]);
> +	free_time = ktime_get() - free_time;
> +
> +	WARN_ON(!mtree_empty(&mt));
> +
> +	/* Minimum storage assuming fully occupied allocation-range leaf nodes. */
> +	sz = sizeof(mt) + DIV_ROUND_UP(cnt, MAPLE_ARANGE64_SLOTS) * sizeof(struct maple_node);
> +	pr_err("Maple   %12llu  %12llu  %8lu  %8lu  %10zu\n",
> +	       alloc_time, free_time, cnt, cap, sz);
> +
> +	mtree_destroy(&mt);
> +	return cnt;
> +}
> +
> +static int __init region_alloc_benchmark(void)
> +{
> +	unsigned long bitmap_count, ida_count, maple_count;
> +	unsigned long i, max_cap = 0;
> +	int ret = -ENOMEM;
> +
> +	for (i = 0; i < cap_cnt; i++) {
> +		if (capacities[i] == 0) {
> +			pr_err("capacity must be nonzero\n");
> +			return -EINVAL;
> +		}
> +		max_cap = max(max_cap, capacities[i]);
> +	}
> +
> +	bitmap = kvmalloc_array(BITS_TO_LONGS(max_cap), sizeof(*bitmap), GFP_KERNEL);
> +	reg_sz = kvmalloc_array(max_cap + 1, sizeof(*reg_sz), GFP_KERNEL);
> +	reg_idx = kvmalloc_array(max_cap, sizeof(*reg_idx), GFP_KERNEL);
> +	if (!bitmap || !reg_sz || !reg_idx)
> +		goto out;
> +
> +	pr_err("\nStart testing bitmap vs IDA vs Maple Tree region allocation\n");
> +	pr_err("memory: bitmap is exact; IDA and Maple Tree are lower bounds\n");
> +	pr_err("Type      alloc (ns)     free (ns)   regions  capacity  memory (B)\n");
> +
> +	for (i = 0; i < cap_cnt; i++) {
> +		unsigned long idx, max_size;
> +
> +		max_size = min(REGION_MAX_SIZE, capacities[i] / 10) ? : 1;
> +		for (idx = 0; idx <= capacities[i]; idx++)
> +			reg_sz[idx] = get_random_u32_below(max_size) + 1;
> +
> +		bitmap_count = benchmark_bitmap(capacities[i]);
> +		maple_count  = benchmark_maple_tree(capacities[i]);
> +		ida_count    = benchmark_ida(capacities[i]);
> +
> +		WARN_ON(bitmap_count != ida_count);
> +		WARN_ON(bitmap_count != maple_count);
> +	}
> +
> +	/* Return an error so the benchmark can run repeatedly without rmmod. */
> +	pr_info("Region allocation benchmark complete\n");
> +	ret = -EAGAIN;
> +out:
> +	kvfree(reg_idx);
> +	kvfree(reg_sz);
> +	kvfree(bitmap);
> +	return ret;
> +}
> +module_init(region_alloc_benchmark);
> +
> +MODULE_AUTHOR("Yury Norov <ynorov@nvidia.com>");
> +MODULE_DESCRIPTION("Benchmark bitmap, IDA and Maple Tree region allocation");
> +MODULE_LICENSE("GPL");
> -- 
> 2.53.0

