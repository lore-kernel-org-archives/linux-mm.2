Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1F93ACD6E79
	for <linux-mm@archiver.kernel.org>; Mon,  8 Jun 2026 20:40:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5CF546B0005; Mon,  8 Jun 2026 16:40:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 580A16B0088; Mon,  8 Jun 2026 16:40:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 447EC6B0092; Mon,  8 Jun 2026 16:40:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3268C6B0005
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 16:40:29 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id AC2158D08A
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 20:40:28 +0000 (UTC)
X-FDA: 84857913336.09.2DCADC3
Received: from PH7PR06CU001.outbound.protection.outlook.com (mail-westus3azon11010017.outbound.protection.outlook.com [52.101.201.17])
	by imf10.hostedemail.com (Postfix) with ESMTP id EB109C0006
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 20:40:25 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=KC+MFJF+;
	spf=pass (imf10.hostedemail.com: domain of ziy@nvidia.com designates 52.101.201.17 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780951226;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qYDHR5HN6OuBZvf6G6BPWv0yzyiyh0hXG1CQEd1+v6k=;
	b=ysUlVvFPm0a48b13USBvTt55hH2sQ9ambxg/WzkomuzVSXczIJCqtvvKpCOwDDmX6xoZN/
	54hsfcXtuoYlhxhrtcfm6McRkd+BCGl+UTlx+hqtr6lvRKOlLkOPaREIR9QTSI2EX0UQMO
	pdydyivanQ5B6xOdsBqjLn7yOP+TqhE=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1780951226;
	b=OnFTAlCHCrMUD11XwzO7ng4oHkZTIehkG7R/wdGJK7deZgO8bD4FGNTd5Ec80yIGQutjlf
	RezRV0f5idb3z4OcNojsK5OoyCHwiiw+Sj7Fa6KyfRU3vY8bXSQE2uXQ/ifxKjbrgMLM+c
	5BC+Op8rb29LE8V8f6c2e7MY4l66n1A=
ARC-Authentication-Results: i=2;
	imf10.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=KC+MFJF+;
	spf=pass (imf10.hostedemail.com: domain of ziy@nvidia.com designates 52.101.201.17 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=U9C3FGFldftH+0myY7Um6EfeJD2kRvLiqRb4pVjTT4cEPCkW0TR9ZClH9HiFjBFTQwus+WqmPk9lmL0ELElQxwigSgaHn5eWq7D9d5cnh+W+2dXhO3Pua/kP8ZXH6eR7na3OzU3g2sT2PUolIrMEpuUrk8gU0gq+ac5/JEQei8ss1FssrFCNb4VdLvZzdIcrYDNdVdVkHA1e9fc3y33Kjh/4Z0OvaCSK3tT97mJIyFUvkqqA4a4fdX6CMaWsW8dml2yKMhQR0yN6uwqxH8w5EqkRS5kkMNsY2ED5vpgu5fVp8UHzw/aFfLNdKSPwrlSP6xhWR2xqyzcOWIkPr7FI1A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qYDHR5HN6OuBZvf6G6BPWv0yzyiyh0hXG1CQEd1+v6k=;
 b=cr4zOQyUHALETTzNjzFbxVLvR++qrQMi+V09BzSn/YGgZA9izg0mwmRSxHKLOQE+SG5iE7tcBNdH23A3Ic0gVHGEmvM3H+A9ywVyjvgxuJ5UzzA5Pr8Qs4eQu14L8QzYwH48pypjn+CrWAKgioCUmQkUDHYLNLjci9SOT8mS/KmG6bOnrD4ZyP2sxBBxUI4bYBeNRvlp1MZMJk+Y4MPDdwQcxykAI42r3ANeTa0mhlzAGqMKeFfYpuikJIiJIkFpQOgbOQkpzWWO849PXsg7xhj4prbmBVV9ofmQJfZqONj0G6Rmhpp5qmvwrEaRHjx+xaQw0e7ZecKcuTRXLNfSrA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qYDHR5HN6OuBZvf6G6BPWv0yzyiyh0hXG1CQEd1+v6k=;
 b=KC+MFJF+/agUrQNFG/ugYqVOnsjG7Imjc/uxXClSGfRG1KSgCPnAbDuo2DPsFbhKZUhHB2mRuQQOEfsBQA9qyuW24Bs+yD+QHZo9ZtMr6oECEw9pf4xY2ZJsPMSnuWX4Uz3aA6OEH8S//GqIlEoXHK6BQ5LAAL57pehozZwSFTjXVBMDSH1JeNbouLsyDBPhCkyQvkSoW4VQzdwDmnLfg6h30VGQu80bcZ+s5ZufXJyJoUpGJe13oZJWxGYJ3BgT3E0HKz0Mrzpi3HVWdr36L4Rtn2lx2UrAeo+JZmcoAWm77zl4YqKThFK1Sn665LG8JOE84HfBsA/xWFNx+RKIGQ==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 PH8PR12MB7325.namprd12.prod.outlook.com (2603:10b6:510:217::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.92.12; Mon, 8 Jun 2026
 20:40:20 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2%5]) with mapi id 15.21.0092.011; Mon, 8 Jun 2026
 20:40:20 +0000
From: Zi Yan <ziy@nvidia.com>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Gregory Price <gourry@gourry.net>, Matthew Wilcox <willy@infradead.org>,
 Lorenzo Stoakes <ljs@kernel.org>, linux-kernel@vger.kernel.org,
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
Date: Mon, 08 Jun 2026 16:40:15 -0400
X-Mailer: MailMate (2.0r6290)
Message-ID: <BD0C8760-BC10-4BF0-9EE3-9B0DAF0D977A@nvidia.com>
In-Reply-To: <20260608163257-mutt-send-email-mst@kernel.org>
References: <cover.1780906288.git.mst@redhat.com>
 <50d410b47fe3f45327783e05bd306d5eaab75e65.1780906288.git.mst@redhat.com>
 <aiaUDTeHDA45ZXFS@lucifer> <aiagMc9Ng_AE_adh@lucifer>
 <aia93IzhTgi1vGi6@casper.infradead.org>
 <aicfERTP3H6AndOs@gourry-fedora-PF4VCD3F>
 <D1CF67EF-2CF1-45F8-9265-70A528C1CB01@nvidia.com>
 <20260608163257-mutt-send-email-mst@kernel.org>
Content-Type: text/plain
X-ClientProxiedBy: MN2PR22CA0008.namprd22.prod.outlook.com
 (2603:10b6:208:238::13) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|PH8PR12MB7325:EE_
X-MS-Office365-Filtering-Correlation-Id: 4c8605e7-d8dd-43c2-2a65-08dec59e2807
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|7416014|366016|22082099003|18002099003|56012099006|11063799006|4143699003;
X-Microsoft-Antispam-Message-Info:
	qnYzASL/luNJ7X1n5Sdzfj2hCsWppLwuqRbbXnRkjL9iV9MNlU4kGyg57EWb7C5EFEYsvJEL5FhVvvlRXCsUi80CA08ohRQMFiGETw5jUsqzRLsH2NuwoRTx1RDFne+H8+ISBAE0E7gRbAW/680WbNsthJH/OAoGMuqNQYI+wPXIydSfhoKFiPlO9MQK3r/HHEzfPsr6NCsT6DhF9lpIc7hSeJT4q8zYbd16qmI3uWp3PSyXIzvRhGQzvrXzgYr2etOnJSJPSgFrlxYACf1Pxt4Zx5qWZW+RhY8gvdGKkJBgMmeGkYV/VADkl4MH0ArDKVk6q7lBQXkGEvbjepqX4K02voZav4ES7rigEPbbZ2zOw7Z72Zy3WAwc9OD3O36PnXFkVQnFLMzsHwnDDuFV1qJdJ2Hf4OClCpNx96u7XPlR1gQ0rprJ1uJCuxWlXnbvdNK7+kJUDKBdhDPDZxJ2lHJrfSN00zsuN9nM7O/zRbN8QIuNDVrMtIxZhlLwTg1vkKb//CKHM/0crsMyiYt9D/L2oM5EmhJncELEfPsmRw0Aeet9o/2GXB88KIMnXm7HA9S0qEKdouaKo8E+zKZiw31Ajztby133jMgsXuSCXYJ2Vrop1qIN+FmpF7fCx+1FOqpIF67vncDiuOxOY4SXgSfSfUBoK9+PvTPE8aHCM706kVYtUr1AsFq7lZadtl1q
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016)(22082099003)(18002099003)(56012099006)(11063799006)(4143699003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?qk2y9LXV/OIkGSanfDWSBGGJEu6xN1wm9vSYPpxclJ2/e6esa1r7Jke2FJpV?=
 =?us-ascii?Q?Ak+1z9nQ0AnQxm0EcscGm6GKVviI6mxTTbHz/LuoyS9GG79eQD/yMKgVZ7M/?=
 =?us-ascii?Q?Yl0Pil92jMi5EhPsPiR4p7B+QQwNMNHqJ9QHu9t1Zou98exIa6IRWe0EqOLv?=
 =?us-ascii?Q?r2FOJ76fujGlOiNXQMVKf9PNwRghwNE9PqRSPJOY0pVqaHAw0GrCC0bsPtDo?=
 =?us-ascii?Q?pVIteZcbCgJm9pNQ7mtONm+iq7VibiqgIT9f09mhUuSO7vuVxHeKwbNqOmh+?=
 =?us-ascii?Q?bytlAqhYfVvFtdNrKTYzd51m2femb7LbR2ucnDXnt097AczGWZTjBncGmEyi?=
 =?us-ascii?Q?JzriZOk/7cafpA1a+Kb4eNPhF/ztzcfgyairrCpmKi6KPit+nTijD2TRa6Xi?=
 =?us-ascii?Q?yrN4DuFjaxzDoH1Wwh8IHn6h5o+AyJEy+78jpK3fHHutNdyUCgaM4pOx12l9?=
 =?us-ascii?Q?yueuxKbmO15/o6qN7qDXrw4qLlO8UOiVmx01avE7szcswrE/Rkl+bcFXB4Md?=
 =?us-ascii?Q?F1DjCD9Ok8op2aEPf5/uGgYbuFsZX+WtFwn5rb4UVk/CU2pUxnyuCTDFN4AN?=
 =?us-ascii?Q?Fz+gyNgGGP6HA7X0w9hoRXx2cFrzivU2c+io3/SlmHeIpRphWr61d2kVpVxF?=
 =?us-ascii?Q?olvcoQm4ZzG31+aXsFEYvvzucFGtl2txeFxf0nPstqoOLd4Z93njBKN4EVCC?=
 =?us-ascii?Q?J/l4OXu4HoGTpxfso/qucrmyr4frRjRiechswnkeo/ua79LQY3m6RKcZYzuv?=
 =?us-ascii?Q?Tk0KeBaRE2SC+MwJ1olcVh7cTXGhAOe+eHJ61U4fnZy+XKcsIvFzUi/02WN6?=
 =?us-ascii?Q?8Qk2A6N1i2ZUH0rUf1rac34aQTHiVJdTsjcgDagBzVKvqQYVK91UMj+8YdhB?=
 =?us-ascii?Q?jN0ivyt/xThZzjUiUBW04CaO3SO1OjJ3b/2ajva2Vio5zd8SyDMky7P/9gzL?=
 =?us-ascii?Q?r17zElbr2aV6zXA9PganaVuj+GRQEGU7WmOZfkt0jwitL3fftDy9PWpJMOfj?=
 =?us-ascii?Q?gVwdr4sxXO+PrBJ9/ZBEa7Vxj9AbYL/SQWvaM51oCQ1HtX1xNNpGb7yN1B34?=
 =?us-ascii?Q?0MsQOSTxFZe7sPPZPlcCZUTJ13z8Z9jter+IQyx0Aj1M4sDDbyGANB8/nFWF?=
 =?us-ascii?Q?/hZV/yI0Sv2zqj9GLeHkICDqQbPGMeDUNdTeOuWGfGq4W//B7LvpP2m2jgLS?=
 =?us-ascii?Q?h8vaqATCbxCXFjS52Gz743BVKUFQK9qT5Ju9+P1Ab3zTzksrY0T+/P94sLGb?=
 =?us-ascii?Q?W3OS8TbJbInSCSFbHC7Y1n4qDjDCbc8Do9awwmz3f4CuctVSNIDnQlcMZPej?=
 =?us-ascii?Q?xNFdLOnUQH2YDa7Z33RBh3TUqofQ1v1VlqOwaGnrmlJ14cZIuGt3o70d+6I6?=
 =?us-ascii?Q?lM8P9T+poKMMFU4hhsRBTkTUDe3lNRbwVMDawCl8zZyp+nQxge5w2xmP8B32?=
 =?us-ascii?Q?a9ZDNijWMhuLG/Tb1cdI1i49oCWLZHCdNlmuPuH2iqu3iBU0GVxy3AYY5fr8?=
 =?us-ascii?Q?FcRvZtMduQwpZVJkW/Q7UO49TRonnmKv6iir3k6IJimjLpMBchWgW8pMtsmX?=
 =?us-ascii?Q?2t39bKZpzZ36slITvLkL+qNpWZijsOpCo0ijJbvH2/ZhdNIGEt5MoiOC/c9V?=
 =?us-ascii?Q?Zutv5CHUn/2+Zd+gWmCUmwMErLJnagflEY6Iy/VhEwkgYtnYygPxjO0SVkHY?=
 =?us-ascii?Q?cOmAHXLgaYxQXIah99FDyorzSE1b2SA/DTnlW93HfWJnnfs1?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4c8605e7-d8dd-43c2-2a65-08dec59e2807
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jun 2026 20:40:20.1616
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fUTzWghyaXvizoo/GN0FMpmKS20zrmLcceyrgFohsvCFuvEYSARHzSfOyQu1QAlz
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB7325
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: EB109C0006
X-Stat-Signature: pe49nsgdjo1xtozwnxo1ua7hb3ehbkwo
X-HE-Tag: 1780951225-562052
X-HE-Meta: U2FsdGVkX1/fTcja+RVZ2Rpq6WICO54Mi8uojdS+v3JNJndi28g+k6rJOMrt3tXg/R3FCFau2lV1dLBDsWuAXw6aor2o0MBsOtU3CxcNBrHNiButKo3iQ2m0H9gmAMtD5ijL/ttOAgtFBoHCjWd7gRD1Y02285zQMh5Fb4RXZ1vWiIzcWeYKA9qoRv1sK9yWA0x8OmFzsyJYTdmQFEVFwXN9d6AGUjF8U9s5DZhgs61xOAvMPXzItOVojjAr4AZtyEX59jVy9teWR+r9dfjwxUXLZJUHa0Q8yBgRd3rTMhR6gaQiIyv1yt+//bj68oz2Hmu08OLoMrNQUSi+NsNugTTiSEJOF/xrcytMuX9nnG2FbCfEwAnq+ZRHeOQ6X0/XN+ynGDAZl3HAJaSNFCBDbTKCS/5pRb3mMKHJqo+POtbVnlc1cfi9gN7Q12H4A4yeQnhTC1osRQOe6PEIMiuRnVvGopmFQU1umLOVIjhjt4do8AbVpYTnl60SndF/KgRMLNESyJ27G1cXmp/OY8aQtrhr6MqIOsyNzpLgbPkIFIuGByKxzv39rxDCpM414INSJ7oE9B6WtaaY1QEYHhvHnASZCNNtfB18jlXArY6l/E7eGWJV+FMAlsOUbo9cYR33CEPx1wRFV/mIhR7LS7cZh12KStG0pgW9fOrM2S7Hh7s6I2BTeoGH1AZruRVJvEJmMsBVeBKGPYIA1UH7tTmlNEjEd9H4fyxHPLvUnh0XvQ+KsOTvJVhVfsy2kuNCWL+sIEB4ba2ZS6Xmq8cO7Kekl13aVWto0GWYWF25g1kS7TBHCowRltuUe79UHmsL6+bNQD31QEIMuV6IkHoaMj9vuENXl9rLmOVL/6FdPosMfGncVYj6lUO28w2wRoivAXQceo+7uxbvFJ5m1aUftES7SzF3sXHpebftDCdEC+NZPJP/95MBsCXXB27ouRGhk8EmebTYNTWRN8kpehVMevz
 QLvun7EQ
 rK2f3VPclqLGX0e0ltx3vKQ8K5zeHiZ1EN4Ks/v4vnsKZamxoEDmSW/S0oyxxWaqbFNX8/ZlvVTF4lJV2gqOkPocGHSbWJZkjtCnd2ZFqLYkehv0+UwO/cyv5dahC9KYcIRnRSn0YsP6lb56/K2wtZvSsErOmwn42i4YouOk4crF/QuN29ns9tePZyBTFGolYLjzPU38QG6WLq/vh37xOpxAfzxOdFjNYCua1GX6DgDWvIJydzXxZ9Gdlb4q36TbOF4Gx4DP0iHZjxCV99l6RZ78fQkKsgfvDGEKbWtI9h6K4X3gYXJyNRA0S7zXXfgD8DPuIiEZBGs+IS0O/uwOck0oLcIypx4DdQ6JzSdBP1gWqCXMO8JWg6kbBHYn6YhzxZj93+t4HSw91KBI0U4g0TCeBzgaleaYMd3WVMCh7arJg777g+jbKWfAwxLcDjuCEGxFU3VKfu8D6iavLObMmUFpcaI+Aw4LBkxbEdrVAe6vS4PA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8 Jun 2026, at 16:33, Michael S. Tsirkin wrote:

> On Mon, Jun 08, 2026 at 04:21:08PM -0400, Zi Yan wrote:
>> On 8 Jun 2026, at 15:59, Gregory Price wrote:
>>
>>> On Mon, Jun 08, 2026 at 02:04:28PM +0100, Matthew Wilcox wrote:
>>>> On Mon, Jun 08, 2026 at 12:06:35PM +0100, Lorenzo Stoakes wrote:
>>>>> But instead of overloading user_addr to indicate all kinds of things, instead
>>>>> make life easier by actually breaking things out.
>>>>>
>>>>> Like:
>>>>>
>>>>> enum alloc_context_type {
>>>>> 	KERNEL_ALLOCATION,
>>>>> 	USER_MAPPED_ALLOCATION,
>>>>> 	USER_UNMAPPED_ALLOCATION, // Maybe? Do we ever?
>>>>> 	/* Perhaps some other states we want to encode? */
>>>>> };
>>>>>
>>>>> struct alloc_context {
>>>>> 	...
>>>>>
>>>>> 	enum alloc_context_type type;
>>>>> 	unsigned long user_addr; // Only set if type == USER_ALLOCATION
>>>>>
>>>>> 	// Maybe something suggesting context or whether we init before in some
>>>>> 	// cases?
>>>>> };
>>>>
>>>> Ugh, please, no.  As I suggested last time I commented on this
>>>> trainwreck of a series, lift the zeroing functionality from
>>>> alloc_frozen_pages() into its callers.
>>>
>>> This sort of just implies writing the "alloc_frozen_zeroed_pages()"
>>> wrapper that does the zeroing at the end before return, and then killing
>>> the post hook nonsense associated with it in the first place.
>>
>> This means it is going to be a multi-step optimization. This is probably
>> step 1.
>>
>>>
>>> None of this resolves the user address annoyance which is needed on some
>>> archs for cache flushing.  Whether anyone agrees that the page allocator
>>> should be responsible for this particular operation - open debate.
>>
>> This is probably step 2. But does the virtio use case apply to these
>> archs? Does the performance matter for them? If not, maybe this part can
>> be left as a TODO.
>>
>>
>> Best Regards,
>> Yan, Zi
>
> I doubt it. But I don't get what's proposed, the code that we
> have to modify is arch independent?

Change user_alloc_needs_zeroing() to only check address aliasing even
if that can cause double zeroing for virtio.

Best Regards,
Yan, Zi

