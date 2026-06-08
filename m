Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0519ECD6E79
	for <linux-mm@archiver.kernel.org>; Mon,  8 Jun 2026 20:21:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 69D926B008A; Mon,  8 Jun 2026 16:21:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 64E116B008C; Mon,  8 Jun 2026 16:21:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 515B86B0092; Mon,  8 Jun 2026 16:21:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 3E6156B008A
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 16:21:28 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id D7620A02B6
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 20:21:27 +0000 (UTC)
X-FDA: 84857865414.12.CE43723
Received: from BN8PR05CU002.outbound.protection.outlook.com (mail-eastus2azon11011049.outbound.protection.outlook.com [52.101.57.49])
	by imf24.hostedemail.com (Postfix) with ESMTP id 17000180010
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 20:21:24 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=aGrzkPq6;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf24.hostedemail.com: domain of ziy@nvidia.com designates 52.101.57.49 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780950085;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wWMBvZuxQBtv2proaPRd5XJ4Xy0K/zMUKPRr7jrITZY=;
	b=GlatLr1uDQ1MEaNxaWP/sEA4w3rEDefzDTq2+ez1NF10VtGhplnFYk633wZp9Lk1RiIP3V
	qxY6dhhlSMZupFoQUg17rOsIx8wFZXeoTA9v1/Cfv0aHXpa3DVCn8FCYBkTnGW8LncxJMI
	kJyj3zNn7zhhrNIEFIoVEZzZ5JQP3yE=
ARC-Authentication-Results: i=2;
	imf24.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=aGrzkPq6;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf24.hostedemail.com: domain of ziy@nvidia.com designates 52.101.57.49 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1780950085;
	b=g6r+URVqspUmEoYDglZ2xWSrlcMsmqzN3y2p30+RnxfSeyluiRwegrW/aD1UiLeYSjJBTt
	pJCaOFjEx65mM6ulzu5sUxChHTZUu7eh8/JTOr3Wul/I3P1R14ONRqn8cWOeBbcCUThwfO
	VMLXXr5OfHafLDWxSHDEZUlMDep9Zb4=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=YnP8i61QD8MOuHI5ozdI0NziMEy4SEZ/CT5nfOlaq9yH9OEMChaMSD9RRacXfjAocam6KvdNg8+E9ptxa8m8ilFxwYQ0nDgkTG4A274bT9UZWiROZDq6CLp9TjNbGRCO8UOHBw5TI3I4u6VJIlg47DOXvAlyQDwyKpYjgRFoZXKTkhm8ijylHM2/F3DegfDFE2aZvSAxRbKo9IIi6ldf2d4tZw9C3pj39AlJgCD09xbmLT6SZbzPirylQMPisp6zD4lJQG0sAP1qIc+VQQoZuony0noBKD3ekTrUOJqjHIkuJe4/0Y2Dpfi7AO3YL3YvnRa/HGXEXLYgEW7DGCZBxQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wWMBvZuxQBtv2proaPRd5XJ4Xy0K/zMUKPRr7jrITZY=;
 b=FVfbaf4ljms+I9k9DCN9Kd6s0UtuOuHNy6KJNySf/Q0r3ygkQU+ZVYVOOJ7/DOwxS5v1wPEO+8it66eZjBToonwoUW+M1joMJwvFozz4Q6vrUdAjXpBLIXGESaSZ/vrHh7xqQCJsQvDyHf7LuQBF3Lbio8l2dnRiq2TvZlqL3PfydsYDrQBsIqgGTJ9rBnvK96+62p5A8KBjNSmfyccnZilvQzv3uXdba4xHvq6VVXvxE5oHktyRbAH45ZBUzqiGCh8L0dVcOr8Q0jEhx79j+ZdmWd/Xaq6VaxYJQb/2OxR4zywA7nyVXtEfEoSFUkL0xt0L/gMXFFfiTZWrbY2SWg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wWMBvZuxQBtv2proaPRd5XJ4Xy0K/zMUKPRr7jrITZY=;
 b=aGrzkPq6cSQ8SqYlFxzEX9pTxEiHDxi8FLSHggWCw7R07ItG6BRJf+dHKQSMqLydb4s9aZ/MzIB+LoPvq7XCVBvzke0GFAUkSRRZYNfJYEusl00IMh9WxLBVppFa73w1z+8INxuyoSKlBonfZO7Dg14TahN1jm7/EQ99NHDRFZgMNsrBZne24OXQk3wuV8vG3zbEsYHsGs8MiZMA/aA1qFQrjMZ49mBVn3j9BqprLr7rANpzy39GRKLQY/jHNUjTagMmq7SxH87FiMugLWe2LlLtx/cuULnfzotVrCN3G4tkdCxF3Ssz/EWfXNzudX16pMirGui+DQHdHQAGgMPUfw==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 DS0PR12MB9038.namprd12.prod.outlook.com (2603:10b6:8:f2::20) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.92.13; Mon, 8 Jun 2026 20:21:12 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2%5]) with mapi id 15.21.0092.011; Mon, 8 Jun 2026
 20:21:12 +0000
From: Zi Yan <ziy@nvidia.com>
To: Gregory Price <gourry@gourry.net>
Cc: Matthew Wilcox <willy@infradead.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Michael S. Tsirkin" <mst@redhat.com>, linux-kernel@vger.kernel.org,
 "David Hildenbrand (Arm)" <david@kernel.org>,
 Jason Wang <jasowang@redhat.com>, Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
 =?utf-8?q?Eugenio_P=C3=A9rez?= <eperezma@redhat.com>,
 Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>,
 Andrew Morton <akpm@linux-foundation.org>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Brendan Jackman <jackmanb@google.com>,
 Johannes Weiner <hannes@cmpxchg.org>,
 Baolin Wang <baolin.wang@linux.alibaba.com>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Hugh Dickins <hughd@google.com>, Matthew Brost <matthew.brost@intel.com>,
 Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
 Byungchul Park <byungchul@sk.com>, Ying Huang <ying.huang@linux.alibaba.com>,
 Alistair Popple <apopple@nvidia.com>, Christoph Lameter <cl@gentwo.org>,
 David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>, Harry Yoo <harry.yoo@oracle.com>,
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>,
 Wei Xu <weixugc@google.com>, Chris Li <chrisl@kernel.org>,
 Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>,
 Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>,
 virtualization@lists.linux.dev, linux-mm@kvack.org,
 Andrea Arcangeli <aarcange@redhat.com>
Subject: Re: [PATCH v10 07/37] mm: thread user_addr through page allocator for
 cache-friendly zeroing
Date: Mon, 08 Jun 2026 16:21:08 -0400
X-Mailer: MailMate (2.0r6290)
Message-ID: <D1CF67EF-2CF1-45F8-9265-70A528C1CB01@nvidia.com>
In-Reply-To: <aicfERTP3H6AndOs@gourry-fedora-PF4VCD3F>
References: <cover.1780906288.git.mst@redhat.com>
 <50d410b47fe3f45327783e05bd306d5eaab75e65.1780906288.git.mst@redhat.com>
 <aiaUDTeHDA45ZXFS@lucifer> <aiagMc9Ng_AE_adh@lucifer>
 <aia93IzhTgi1vGi6@casper.infradead.org>
 <aicfERTP3H6AndOs@gourry-fedora-PF4VCD3F>
Content-Type: text/plain
X-ClientProxiedBy: BL1P223CA0010.NAMP223.PROD.OUTLOOK.COM
 (2603:10b6:208:2c4::15) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|DS0PR12MB9038:EE_
X-MS-Office365-Filtering-Correlation-Id: bd29bdfc-58f4-48fb-0965-08dec59b7c0d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|7416014|376014|22082099003|18002099003|11063799006|4143699003|56012099006;
X-Microsoft-Antispam-Message-Info:
	DwEz16XQkSlY70BCniRmfHv2UI0jQdRtuKezI3Fb3aOqISot2KlDiv7HeZdI7xprJpnfakq+5tdlVN121Jixx+5mA9vCQ+TYEgiJxBgaDGr6/RztFQ/BZZ30OQ8JO7aBg3xF+zpZkb2vw6qrbBbltSnBYAGe3LJW/KaIydjKKSWXOhNfWxXhP3b4Svon8ds8oVGe6Elam1t3P+QY/UQJDBqsvz0rVgi7fhle+X2y0n5kOHILh5Ynn4jeBXJcIxW751g0eU+IRdO8hsFeVX2ecWbaHfCbLvJVNIq2XngQvep1Wk3npG9vMn+iTdW3CUY7HbO3cOzr5Kx/kzVq4LY/3+cvKKVhifD9BSlt6nvLQqinbFspj7zK+mEkSjfB7yLAs5t7uIq3tbm59LgbriEA4CxC/ZoA9Hb5GNAf6BabUAmrCrYM0aYn6/qPew8LDfRq3M0omwa8nZYs7QBVtYzW0sHHDpKSrmOv87QClDju2isBH1Nk7pJPNkuc89+AKBRfE2JSk1mgoyzwMs3AWgRHLUirHeyGOALNDY+ZjlJvk9sdR0ZC1zmQihq0Vh652r0i96PgFPEub0D2utgy6xgQHICZiFE4DrLkdK7uroARYtx8tfHCfacERy/1x/IyERBhLmrVNekZxZoVq1x+JoipGU55JKocDqXuMy3NevmhaIe7nxHoMZWMz1UilvS7JOJw
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014)(22082099003)(18002099003)(11063799006)(4143699003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?egEIUD5fJUrVUaSr/Tw6z0lctVbMmrDrDP6caDJOTKd1zJ7NWckuf+rfjUBa?=
 =?us-ascii?Q?ZNAzcDZUnkCbw+pg/XkLukU4YSqMUG/vzPfMSaZKVsIFVg4o77CiFi3h+YPN?=
 =?us-ascii?Q?+0O3Kce2EsuU8SlrPWQLjFG40P666KMjnaHasUa1bLHnAC4cXzvcdXGSc6qH?=
 =?us-ascii?Q?5+UgTBzfeyyIVeVr2uzqDCDAZDVli5oZYqGlad14YaBeboQP5SvUc+T3EWcB?=
 =?us-ascii?Q?8nh6gmNSDq9UYgIpRRU6hb0gokPt7s2KHF0t2+wy0Z59F+peig+RLVM7cE3d?=
 =?us-ascii?Q?nOlkk5nBQFa09ze6syCos3m7g1OCb68ZbX+hk3Y5Kkk/aeFhOI3Np21QOc9c?=
 =?us-ascii?Q?YcQw9UNHS+apy0dA4ekoMjC49awUj8ibg89BczneW8fVDqIDlBp2uoahAvtT?=
 =?us-ascii?Q?iYeojHbylz5/k5Fq6NoJ/angd59iPrs2psHss4F0YbfUS7SqquQYkpFRBfnQ?=
 =?us-ascii?Q?N5JuloVhuLE5SG1QxaMhkA6fLZbFgpPDmMIiOtNbQ4uQUjXu7p9GG22V9oo9?=
 =?us-ascii?Q?+Ae/tZt3H6tXxUtjyJigF1B4FVwblwFc6u8UAGSn5yzxHz9eW3GdrGnfCbpg?=
 =?us-ascii?Q?qVW5SeDdLHltA2t0YUBjGVlppGADJGDYV6eq9xkPH/H1BlZ7LpnbROSete9o?=
 =?us-ascii?Q?0nsak0OoYwKjyF6a/O1ZjS03q0I3rOogkT5Bzw/e+XbTNs0WdJ2zyCtEr/v7?=
 =?us-ascii?Q?VOsp8iPZ1HBWo12dAS5gQYMxYX1E2Iitz7KT509vzp+noIdO9QJpY58wQmqv?=
 =?us-ascii?Q?lDaJGMNNwjep8vI/9CPyb+DNCD1TSGQPshLFM0B3Tu/gFTvN5Og/+kB/YusQ?=
 =?us-ascii?Q?Z/+dRJzGoVjKUJnEAgGE5tPLo2bX/rUibADZ6lSonkcHYbdyBEd1Tjcftw9a?=
 =?us-ascii?Q?A3MkKAw8bKytx+96uSsofL+t006shg2YNpGU/2gwPSVUjHJSnB8rdLSHq/Vs?=
 =?us-ascii?Q?3DdKP4tcXIgDRvOaXqjq2//v0izQvGwlGwYPfe6Bc1td2MPkxZTCV42yGISz?=
 =?us-ascii?Q?JeEHpM5onp6cMpiJe9By8NZMdR3YPi2smsyeNwgf22G6+flXFEgrq+oHrtcv?=
 =?us-ascii?Q?xsN8Pqe1HiqjCtwHf60QjqZCPKjcueys615Y3ly2SvwrmnpRgQ2Ld6dl4CLz?=
 =?us-ascii?Q?JEPCU/xHkkFvHzqvFT6WUnWTmVUl/3tiWQXvuFB5ME1eLrFj+SBml4V990tB?=
 =?us-ascii?Q?V/9oxGqf0XD/p/Q6by0voLSLDisv8yY76CME1GH3EC7FoK6ArymTavecuJJ+?=
 =?us-ascii?Q?ob/7xJMe6sbUX8oe+u9ZtBsjcFuc10mN4z4HdaupqWeLWJL3wzK9P5ypDs/v?=
 =?us-ascii?Q?qqNe2LA9JdOUMV62Z/7rS70DJAy4YlysYCGcrYOLEbWbvSn4AK3BHnVx+tr1?=
 =?us-ascii?Q?8FXlddysKIONglPEPkzlPQO8feNFPVuW2La+bwd8gp3sfep1M+WdS3sbBXe0?=
 =?us-ascii?Q?tqyqF2M574J6KRq7cIht1ltNjGHhyXTQqKm7SdL1D5/JlR31Iaf+cmh0vk5h?=
 =?us-ascii?Q?/6ZUTqIEFlcH67FcasqCvznuM+mg9vA7H2K/8h12SZovmKTldbn+HH/hyECk?=
 =?us-ascii?Q?QWaLmZ2pNd3+JDPI2b3dxBGBsdss5LawFG4VrfMrVqahbIveY15hW/sKFrGY?=
 =?us-ascii?Q?ka6OJMcoiP6t5QQIEQdkD/LGNjU09JMYIBE9Y8biQx/qXwSIddsYGBFx2NFW?=
 =?us-ascii?Q?Vc6yo1126XE6j1BUvMrP6jT1DeU7its+YtkTxupwVI4JP/wT?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bd29bdfc-58f4-48fb-0965-08dec59b7c0d
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jun 2026 20:21:12.5860
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: skzx7HpvNZPX4vzIgMdB0RVDlIgE7F2srz2WwTDoIjP8grjysgh5Z/80jf9tiRou
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB9038
X-Rspamd-Queue-Id: 17000180010
X-Rspam-User: 
X-Stat-Signature: e7byp11ihnp63t8ytdbsxxs4n7j8ab9c
X-Rspamd-Server: rspam09
X-HE-Tag: 1780950084-959648
X-HE-Meta: U2FsdGVkX1+LyYKW7fubExJbwwBvseVEDpPO+uDAHKOJyVQwyvJv4uIt0gBEUO+UJkezxVJDqf6YfZ2JMEy/UpCJyG0ddmS/OTn/9G/GEjuTJ8EnoakjE3Bo1eSeVq8yio7lHVV7PWW5HhZV7TpAGEySqBPIn/nkdNKmxY6P1c4Szg4aYalbH1iCY8jOV3mMy3TqUpwjhQTUON/LhHRq8F1I9glIif6v5PUcJKV5JoXy3KQRsleFMhT+DZrsi195qh2h/cZ7lBZ80qRaE6JJVMBDKtgwYxmXhXis5pAKkedVvyqbODaOF4q59iYF2BqdmL9Sjk2DGukoerIpwkWCI7tbTFe+xsciIbzlOI5SWzqsuu9l2azKO1mFzOjOJNyKG7Tfu/fd+kHUHQIt8Tn09cy4r/lEQtyZ+KmXeRPLJomSPd4jqyhSD281PE2aLg0qTZUtuM2e90j2y1D+9PaVawKOYsV0VueQx3M2ahltZo6lVaTMH8Fy2H0hIkrySuaxBV1Sfbxnxhslk++EZVJBH7vvbtgiqPwEIl1T4Ax/VoYPIuO0xegWU9Ldg+uKcZtOv6jU7YD2tHiWy+VhuoegV+Gz/bdb3aSXTVhXSXoQLUUR4Q9bGRaN+Dr/nvv387+2QOg444jtgBj4PXLHOEvQaJFDT85Vo4RwdrsB3Rl1NfX4+xeWyq+nQ0pcenoIXexAkucHOZ2PCSI7DAOETlrWekwpy4XqgbKKrYpzxQr2z2COrwOGJXUSbnt8OP1mtU6A9hVoJ210j3yKV35uLxh9Ubtj5F7B9vAS6mXehFyNOJAUDbHUX8Yp8W7V3AGOQOQfl68ymZuwE6yrT6aHnU2xBYgDF4D894abtF35bM6+37gK0qblfcPg9yUFcc63FbYsm3qZXIf34ZAtC+T+8quMfp7BpbIH0cBHzo7vdarXK5uAARwMg5jZVgL0mJwZ+QJiOIPtD4Ch3rhvEBBZs9D
 BhwQIXNg
 0GmFY89AjY7bMECguZYse38hFPxGfHaiNx76qpNHKZXLWXjKfSV6hOL6Nc5X2OXhc8DDFf27FFfhuD2PvmZv6xJUdz+WFHTMz7VEHY1gvqvCjHkh2T2Y3/PYiy2ZM4GBOcMoBimCuwHvH8awKHN3Go5Ix69GY+Qq/XVKzgnt7qmOj3oBgOwkqE6fMddNHWc6zFWSTNO52o8tAcfeWZcm+hC+RUESzR36MZKUpKtMTXn4R6inzDIObmzpFhGQUJhXdpCS9xHkmrl4Oy/ukcqehyYbpy1I9T3DPdI1J2lst/ydENtDuLqqQpkNZu/WaoPXOR477haKXYD4u0WJb0fVfwC5cQXqKMIDvF1G90WmjIwxFUiGbdGAA56mj8lDMNIDIHKUIUGFbRDxGafUgjZlQTPVns8UfHERY+L6FTYSfiEQwmXtK4F1MXxS8m3T1D/Pjmn9RlmOhHkrrBAqVQhiQw2MfSFLFWw72aRmojAKfv+wZuPs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8 Jun 2026, at 15:59, Gregory Price wrote:

> On Mon, Jun 08, 2026 at 02:04:28PM +0100, Matthew Wilcox wrote:
>> On Mon, Jun 08, 2026 at 12:06:35PM +0100, Lorenzo Stoakes wrote:
>>> But instead of overloading user_addr to indicate all kinds of things, instead
>>> make life easier by actually breaking things out.
>>>
>>> Like:
>>>
>>> enum alloc_context_type {
>>> 	KERNEL_ALLOCATION,
>>> 	USER_MAPPED_ALLOCATION,
>>> 	USER_UNMAPPED_ALLOCATION, // Maybe? Do we ever?
>>> 	/* Perhaps some other states we want to encode? */
>>> };
>>>
>>> struct alloc_context {
>>> 	...
>>>
>>> 	enum alloc_context_type type;
>>> 	unsigned long user_addr; // Only set if type == USER_ALLOCATION
>>>
>>> 	// Maybe something suggesting context or whether we init before in some
>>> 	// cases?
>>> };
>>
>> Ugh, please, no.  As I suggested last time I commented on this
>> trainwreck of a series, lift the zeroing functionality from
>> alloc_frozen_pages() into its callers.
>
> This sort of just implies writing the "alloc_frozen_zeroed_pages()"
> wrapper that does the zeroing at the end before return, and then killing
> the post hook nonsense associated with it in the first place.

This means it is going to be a multi-step optimization. This is probably
step 1.

>
> None of this resolves the user address annoyance which is needed on some
> archs for cache flushing.  Whether anyone agrees that the page allocator
> should be responsible for this particular operation - open debate.

This is probably step 2. But does the virtio use case apply to these
archs? Does the performance matter for them? If not, maybe this part can
be left as a TODO.


Best Regards,
Yan, Zi

