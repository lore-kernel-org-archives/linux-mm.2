Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AD74BCCD1A5
	for <linux-mm@archiver.kernel.org>; Wed, 22 Oct 2025 03:36:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 136588E0009; Tue, 21 Oct 2025 23:36:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0E73C8E0002; Tue, 21 Oct 2025 23:36:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F17ED8E0009; Tue, 21 Oct 2025 23:36:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id E1FDB8E0002
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 23:36:53 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 8C7EB11ABAD
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 03:36:53 +0000 (UTC)
X-FDA: 84024338706.19.DB54865
Received: from BL0PR03CU003.outbound.protection.outlook.com (mail-eastusazon11012071.outbound.protection.outlook.com [52.101.53.71])
	by imf08.hostedemail.com (Postfix) with ESMTP id AFB8D160008
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 03:36:50 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=I2g3Lxz+;
	spf=pass (imf08.hostedemail.com: domain of ziy@nvidia.com designates 52.101.53.71 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761104210;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=oTwND8+++uvBGRBgelmkoTvpzSSHL/8VaGjK2FOVtL0=;
	b=N1lBe2ebKsXvVCeGIsujtT9TSLGPf9XbtB6ajjSDX4cRrx3hXnPIuHvv2kOwlxTx06j73t
	nwz/1qlRYpShgVBaScAg7571ZOidFbqzISW/kzRTsYOn+bEGa2G9V9W+ENb1VJNzwsRMpL
	7546TI5xZks71bg4F720aUVx94apd3M=
ARC-Authentication-Results: i=2;
	imf08.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=I2g3Lxz+;
	spf=pass (imf08.hostedemail.com: domain of ziy@nvidia.com designates 52.101.53.71 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1761104210; a=rsa-sha256;
	cv=pass;
	b=DGGYLDKs6gAmMzvrrikz5++PSw9hR1lHjVNFibzSFT8DTBlr08B9lYWCozRV46nrGkvvz8
	xu1wHiVWgJcY3BL78KpjEBC121Ci2+cVjRIhTYXcKl+gSBKdBb/7C3GEWPp5NCZlaySMK5
	+efh3WXjxMPpOhoyjpZV2e4JDM0VANk=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=kBBGCC3qv5jexES+keEBrNpivkPZ6WgXCAv/9k5W/Nb4lf4tD5oAsYOR0vtutGDfr4VUX+JCJM+k5SIilpll1+tWBq3e8XbAmezy4DqAlQPehtfdmkL+EJ3doHTvWuRD3cq0rQW9NJUfr5FA6KnKSqG6xKN2EaUZ78o0mwmGSi1w3hRmbynWSTwIuHqAGIjXZhUiVYVb8acEM037geThsZ/cZywtSKqLVcQXIm20tPpi5avtNy4KLT+1u3j1ER4pVloeWGpSwjslGuxn13OMmxlY5jpqo2TvhiO1Mw8xpjCkGrN1w7SRjUuFAYR73JTXG5oOnrYWV7NLofmpyh0uiQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oTwND8+++uvBGRBgelmkoTvpzSSHL/8VaGjK2FOVtL0=;
 b=a7yDrEVTZtx0hNREa1Rnd63X0g04AUVFTTr3UItB0jQl3Vk2d2iO8OdvNrRdlXFhqknqNTVPsi+E7BnttTs4j+DwmnMYDNRCtcdSVYXIlM1C/18C4xzRvvNGyFxRd/oJ5u5xDW4HNrGq0iDUMg1ktI5OSVf5ciittWTbeU/xE0NapBp45ISDbFVWGA3aZzHvu3wiqMRrm5sBSO9fGr51a9H1o9KVTLMMHTmdm0Oozx62JixxE8X0ehh8jL2sB834853HdTi+HsBI5ff4zYvmtuUemZQckKgNHdEqSHBUYXdM5SW0DOSw8BKZxkkvStAHx4KTvKDRyBUDBOoqrMCzyg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oTwND8+++uvBGRBgelmkoTvpzSSHL/8VaGjK2FOVtL0=;
 b=I2g3Lxz+7FS5PObO1qCOcngDF+65lObMKVXhO+CU6olf+B5yRZIXEJXPCtdlE+yW3oSMroYOD1UQX3xLDvPyU+oAMl4WaVIuTmeulF741BHEyiezZXgMxMSHtcVNytq+3gihv8eiCex40Niig1N5T8URGZIuf3GpwTkgH+MAvfwRx2a6We8gCITWwBEEpzMJjOsV1Jxk9RfH30ViYZSJwIW48EoOwW3irN9h5zfW5EfeDCOunxwFVd1CSl5TxHHY4+Dd3QFWD2tJNVm52bjPYPHQfv/cjljw0t1wuUf+mToxKRysJnIvn/gEGRMTjw05VOuE455UNv6jzXCBV4/Xrw==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 SJ1PR12MB6268.namprd12.prod.outlook.com (2603:10b6:a03:455::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9228.16; Wed, 22 Oct
 2025 03:36:46 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a%5]) with mapi id 15.20.9253.011; Wed, 22 Oct 2025
 03:36:46 +0000
From: Zi Yan <ziy@nvidia.com>
To: linmiaohe@huawei.com,
	david@redhat.com,
	jane.chu@oracle.com
Cc: kernel@pankajraghav.com,
	ziy@nvidia.com,
	akpm@linux-foundation.org,
	mcgrof@kernel.org,
	nao.horiguchi@gmail.com,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Nico Pache <npache@redhat.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Wei Yang <richard.weiyang@gmail.com>,
	Yang Shi <shy828301@gmail.com>,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH v3 0/4] Optimize folio split in memory failure
Date: Tue, 21 Oct 2025 23:35:26 -0400
Message-ID: <20251022033531.389351-1-ziy@nvidia.com>
X-Mailer: git-send-email 2.51.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN2PR05CA0028.namprd05.prod.outlook.com
 (2603:10b6:208:c0::41) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|SJ1PR12MB6268:EE_
X-MS-Office365-Filtering-Correlation-Id: fbcf07ba-333a-4a5c-cfc9-08de111c39bd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?QqJiWEdXPymiODWtzF0hmRuITrt/pv7M8p2jPGJ18Bc6zVSkC4iBBUashLG0?=
 =?us-ascii?Q?asqTgtFyobCEToQ2+ICXRmbT43Iw5VuMPs+BH4vbhu7y8Qizj5zc4vGjcZEv?=
 =?us-ascii?Q?ez75s2t5hE6kGQdC4bjC0yK7aIWuDIxR32ilHCEPepjE4h25LyG0gxyJnkOE?=
 =?us-ascii?Q?zQBdnb59nhn9kexjqCn7nkKg2sO7E19w/StW92mXjQ3eqLGAeoVB3Epp+6Cg?=
 =?us-ascii?Q?P0jzjqgIn2G3UwgP05CSL+vjBc188KwcFixRPbJWQtnf9DTJzx0TjMuTbVaj?=
 =?us-ascii?Q?es9onvBuXygvhLU7Hj7DwgwykH3b08FXbuOl2cohMsMJNh5CjyHwqpKFT4fu?=
 =?us-ascii?Q?4caQNdcgzi+SDV1TOqrQGYr1nrfpdLVBljtHyt5RIKo6Qy0mLBOpjMEnsip0?=
 =?us-ascii?Q?8L7077vWeKSKO2F43dpLIcbdHEBm45EUY0e3sdMTn4LBopCYseyq3nPYrlg6?=
 =?us-ascii?Q?3og0zU6xCRTMv9hmIhy4smbssdeX9djXTrg2foQQiDHs1iDYnNtFqfRsxdh2?=
 =?us-ascii?Q?HXFOsFFDoWSDdl6wTb6LhHMVJjpG0TipGqHna1WHYm5p44NhoFFjluimc2A6?=
 =?us-ascii?Q?XHTgAAE0k+AtKWqh1Utmo0u8IkJGdHNEoGeYm1LFNlERxtPilbk9luzTQ5x2?=
 =?us-ascii?Q?uumkFVWneWHuClDW0gcUiolsySSaHrVEGf8dLDD2wk5qGPk6Wi4YkxrZhnoo?=
 =?us-ascii?Q?3PLP3cWcqvB6Xo8P2I4RsMgGHdJ3PejPYeKK1EYC/IkLEvr9J0fif6188OGD?=
 =?us-ascii?Q?WaxmnBAO1/bJXCxHNzh4HuK8GJOO1WWwnMLLQNYfN/n9m4RRtVV11egIUaGK?=
 =?us-ascii?Q?fRFR0mrR2zsaCBARRTI3GK8dzaYdR5gINFGG1uCmW+UAoFg16zkAE+DQzlOu?=
 =?us-ascii?Q?HmSI1OSmKkmXuYWlQXiAY5YiusssfZgwu5oKIG1S0ZvgyxubggnQv7SXzZuq?=
 =?us-ascii?Q?xl903WQB7hcu5PAui8LAvKyJZmG8Pn78J35kjca04mgqUP8RDPjT9ZSCUG1Y?=
 =?us-ascii?Q?Jzr1wdrTBOVdqh/JswIuJZcqVBzb00E8M40ZAbMFUMdtOWuaPol816BMRF+C?=
 =?us-ascii?Q?veaQJ3orWaPYqzc6j1fXcP26F+1yNtm8qGZnIJv3M54EVY6UXe0Z3fCXgm97?=
 =?us-ascii?Q?ig/Fbe3OQ9CTldzF+BUQVoCdbxUbX9D8C8+DKPd7/OjW8v1NaWu4TFZCKvdh?=
 =?us-ascii?Q?5uTD1qkNNLCr6yVIdW3Pgz1Spo4ujiE4kFsfAJn38YO6UFAFhwYvZqYsrrlR?=
 =?us-ascii?Q?Y8qD13iNi3jD01XnPaARonfHbMCqxZUOXoLc5R917maCj6wDeATp6LJ6hTqP?=
 =?us-ascii?Q?R3nYGdJ4O/bi1pOMtBP4hHWWNc4d9v1nf3ddnli/55fFxygqOG/ZCpERDJ3i?=
 =?us-ascii?Q?ah72WkNsO2g8pZhhi6XxFTAfNBkS1Q6NlDbEMEtf/Py8U0NtbtR/7LF4+g/A?=
 =?us-ascii?Q?ZDsx87M40AVtUmN5pIBDqhirOpAugkLUyzXQCj9lInupqPzAIvmknw=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?P3ZmFOEEewU5rqHzbqId8LtQxb/fVE77tsaZMn0osnh2YnhspUeq2xA/5YWE?=
 =?us-ascii?Q?IH+exUvBme0dzBzLcaipsbHcaXoXjtln4KVZssNHDkreW0LIuufG+Zqx78yP?=
 =?us-ascii?Q?rdUYWZB3/jMk/XZfdsTmLZD6S1nla6AahLyX/yVTZJ8g+UbbpTYf+qidt0P3?=
 =?us-ascii?Q?1y11dolE4ErDAreQLxUhYK4mlxqbhK3LfQahUJr0R1Lj2TBThwQsa9szvPu6?=
 =?us-ascii?Q?YW7zrqRUUNa4LAZCe70i9xukzqt72HGetaQCtouBh3NPDS7w5oTG2OSjLj5z?=
 =?us-ascii?Q?zvz1x7DWHlWMUSg/jEzHecJGELvQOOBQvq6qkQMp2REeQD88qjzDfKVLPOvV?=
 =?us-ascii?Q?vUeAg0QOaK/i101ETRBDv5grNxbmG+NRhOv6XQtRBnT7M9664xMDtBKlFKu5?=
 =?us-ascii?Q?cEjlG9KnnkweWiVGmydlWRDOsY7J3LQuL6IWjlwnZDOD5zDuHGeVGDZa0+Ke?=
 =?us-ascii?Q?XfNXY/p5vw8+TgUIByTR5AIHdSFJBCR3x+bvp8qDhgLe8q6RPgMmE7AvEPjZ?=
 =?us-ascii?Q?1pTrIDIw+gq3NdmhzUhR0pzC/ZoClpzZP8C+nuF9P0fo0al6z/BuaPyR6VQa?=
 =?us-ascii?Q?PwruPbsQ9G7cjI0sI2mGTisktB3RMbxi/639hqU5QD7rPxhr48RkuvQItkPY?=
 =?us-ascii?Q?Hyvc/CdwEL9aHpUEoKVJwv4uHdNMVf/jWYkliUhJNDQ24FDx9Em5hwCNFwg0?=
 =?us-ascii?Q?wCrxkmVI5kJwg7b0t40d3VBEkFKKCnbOczufVBbZ3u3iS2XVbJcX3C1s61/l?=
 =?us-ascii?Q?+NK4tXFoHh2EEb03ZrsLHkHnf0Fi0hmtZ76w2SyEZ8XJKlC0y48ezAk43JyO?=
 =?us-ascii?Q?1j41bTOsSMxVohJ8+Z1piDy9dqWHbygogD3mtlsAtC3yB2L1Lf9EH9MjsEa+?=
 =?us-ascii?Q?z7ZhV8CtQ7BcpU+lBfM+Yp9m2Y9A3s56HYv29gScIeQCRGKnluRgSt19+Bkw?=
 =?us-ascii?Q?c8s7092KFzRJffysXgWbKZz4NadiamjQYrlof7Oc1BM34Ilwy8RyL0nL/JXv?=
 =?us-ascii?Q?xF0x+OzWVpvtS3jkg/MUsQNFX9ChKo9l+TXQ9yLtunR0P2vh4/yh+o0H96fu?=
 =?us-ascii?Q?qnNbH8WItmikGd7MziDOiuMBDHJ2tygeTmdgz+jyMKeaU8N+daE1CguOYyRk?=
 =?us-ascii?Q?ByQmMBYx4yFL56pLTBeecyJ/YP7UrhD1VzodSA9H1nER+LwuvMEpGojqi37O?=
 =?us-ascii?Q?I90NVPlo8LKlSlLoBZnqxhqfi+In5AiZCBpsHAsHMCUBbJZiHEThnSfnfU0Z?=
 =?us-ascii?Q?8qHWWhyxW2H3qWTwCaOSzgyz4kqIqQbrLJUP2oyHZE2/6V1QC/FyFy91okJd?=
 =?us-ascii?Q?DtxGzoR6odOSAOwvh9m+vAqyLDkBgiBmgyPZJ8ove14OR1daMEoHWLAPamVh?=
 =?us-ascii?Q?6bSL33lLdXX0lg1Xz/bPeAagxQDRsiDgd472xPvx5w9E99RjUXepdF970FwH?=
 =?us-ascii?Q?RqNN6xDtgYOcNrNrAgoVN9T50N8B/vJiESaJXCDcXno/3ZdkUKfYzEt5/szB?=
 =?us-ascii?Q?RfJcHSUmmsYMwu4vQdxnXoTTmf0a2lUEkL5J+MZXzA962gsyIAvdyzsz/Z/E?=
 =?us-ascii?Q?t34Q+UXnitgYsXWeC5/2eOuJ/CHs/15iCzZh+u4l?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fbcf07ba-333a-4a5c-cfc9-08de111c39bd
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Oct 2025 03:36:45.9940
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LyS/8XkxEw7DrG7sjndAyJ5glrae+JPOkIMyRwKRdpfvi70ilEdd3IJf981M/MM2
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ1PR12MB6268
X-Stat-Signature: mgbu37e8zdmgywuctrn1qrwctjixh8ps
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: AFB8D160008
X-HE-Tag: 1761104210-906679
X-HE-Meta: U2FsdGVkX1/Q4eO9+dBdB737ALyDGqSTdLDkN3OqVP7JlaR9kCZ5J2LBGQwcS2Czcq/sDwyQWsrWZoGMdKOyOYVZ+HBTOqn0S2zf+GxrC7CU38ngX/Y2laKwyBxzEI92FzMRqOJaoA2Ksc5FScwmSN9sLlbXuvkgdTsassDaPWjERN3Uo9l+yT9dx43kf94PQFKpNIgMtGk5N22Sf/MRAynBUiUuAJ9JAB4yXzWWc1I7K5rJjEchwmFus7yiggawJ0ose2Rh7ARedvn8cstdIYRYzSikhzPjClleb5u8OnXH6DUpCmBbr2f8dVb30gpwprb+7YtFWYjRByPurjYnzjMPqgMSRrqz5VDI3tUsBmn5o0lebPBbNokfVPw6KJJv8oSOyoyjBrCILKCQNFBNvPEu0cFTOVKeD1pLUSmS5YyPwukCyRS7j1lObvcdYkjLi8lEQVjpN33bzeXv9lfPbN5Ix7flFd3xXU5iyi04vFWyzHe3pYyYHMplmrKIHHS60n6eF6AlS2j+o+MJmr2ON89p8184Zc6OBa0fxT8PR12s2G3+FDYJ6y2YVhG1I1V1tCh3InyTaTdGMU9z78P1vw0hgfpjpiZsBEl+/6VzZHEq66WYd6O638vwheF+1Eqz9xzywhEF6dQXgFZCvi3pNv85VNwhh7PKoMwO4yMxufRrS2NHNNDEb/rbPGQunjztRR4Tcv1z2yjzO+wIg54vlGZRc4BA4LfBBf6GGc+1T4rlJHPDtYZ6fdPTCdtX8+YJAugiTSQKCN8djTXSDvhTCKvFfSK1Wmg4Pb4jCzRV5ZqOJJ+F4WyM/j9akMM5C+kpil0qgjunM66q1pvOompn+Z6DPPBYP+St4f4XCyz3HVyisLsBGrS9Wu9s/o4VJIcWzpbrSDqxJT35KoqtuSf8gotWo9Wck0xhidqj2IMM/sXShWPvuSITRPxuxWSotk4IqOy/qaYFhjMn9mYiMM+
 Ui/ZNtii
 IG+vZKqwnXgtmbNlb5jfmgLjel8HwQwN+IdWe78daUPjPNb6I+YBlkThLWlQQzMEwDdkngJbTP26Jn8pwh8nKawulqVPbWIQS1m3MMQBZb3ohzNqcCSHU+OVpVtKKEO8h6P88ABMYDTPIXGtl5rKlFoXRclGeemOBtdhwbECFujD08vy35TPLHYRzQrlqBzG2leMGtuWdbACLtW/glRhxI+RSf75bXzkxoSraHljscHMn3FOqSr4FzPX2WHdedbPgkEdOU9Ixh43cB9dSERNpg/qozZY8TohrsncSinBmbwOcjUYM70mPt5elnNRrcf8VgNYL4WbjLq28iXBtpAW88nbSd+FVXkcC82VAhJALwxcRD68Z3Dw170GDt9/l9KNLYeQSn8jecmD+4JfXySY1ns0INBz6XdXL7+ljH6mD4xsiTfbmvtuxCM0bqzthFGlaB3DHdO3hz51xUWoWaWkvfTpph4KhSN9dFOdy
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi all,

This patchset is a follow-up of "[PATCH v3] mm/huge_memory: do not change
split_huge_page*() target order silently."[1]. It improves how memory
failure code handles large block size(LBS) folios with
min_order_for_split() > 0. By splitting a large folio containing HW
poisoned pages to min_order_for_split(), the after-split folios without
HW poisoned pages could be freed for reuse. To achieve this, folio split
code needs to set has_hwpoisoned on after-split folios containing HW
poisoned pages.

This patchset includes:
1. A patch sets has_hwpoisoned on the right after-split folios after
   scanning all pages in the folios,
2. A patch adds split_huge_page_to_order(),
3. Patch 2 and Patch 3 of "[PATCH v2 0/3] Do not change split folio target
   order"[2],

This patchset is based on mm-new.

Changelog
===
From V2[2]:
1. Patch 1 is sent separately as a hotfix[1].
2. set has_hwpoisoned on after-split folios if any contains HW poisoned
   pages.
3. added split_huge_page_to_order().
4. added a missing newline after variable decalaration.
5. added /* release= */ to try_to_split_thp_page().
6. restructured try_to_split_thp_page() in memory_failure().
7. fixed a typo.
8. clarified the comment in soft_offline_in_use_page().


Link: https://lore.kernel.org/all/20251017013630.139907-1-ziy@nvidia.com/ [1]
Link: https://lore.kernel.org/all/20251016033452.125479-1-ziy@nvidia.com/ [2]

Zi Yan (4):
  mm/huge_memory: preserve PG_has_hwpoisoned if a folio is split to >0
    order
  mm/huge_memory: add split_huge_page_to_order()
  mm/memory-failure: improve large block size folio handling.
  mm/huge_memory: fix kernel-doc comments for folio_split() and related.

 include/linux/huge_mm.h | 22 ++++++++++++-----
 mm/huge_memory.c        | 55 ++++++++++++++++++++++++++++++-----------
 mm/memory-failure.c     | 30 +++++++++++++++++++---
 3 files changed, 82 insertions(+), 25 deletions(-)

-- 
2.51.0


