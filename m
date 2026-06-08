Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C20A7CD8CA7
	for <linux-mm@archiver.kernel.org>; Mon,  8 Jun 2026 21:16:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EDF016B008A; Mon,  8 Jun 2026 17:16:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E8FAB6B008C; Mon,  8 Jun 2026 17:16:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D570B6B0092; Mon,  8 Jun 2026 17:16:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C44E36B008A
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 17:16:50 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 623268D13C
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 21:16:50 +0000 (UTC)
X-FDA: 84858004980.01.5E464D6
Received: from CH5PR02CU005.outbound.protection.outlook.com (mail-northcentralusazon11012008.outbound.protection.outlook.com [40.107.200.8])
	by imf13.hostedemail.com (Postfix) with ESMTP id AA83120002
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 21:16:47 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=Kv8Np7Z3;
	spf=pass (imf13.hostedemail.com: domain of ziy@nvidia.com designates 40.107.200.8 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1780953407;
	b=fLwUHTfmEZjgrRXxHpw4OdDTNEqexSNL/YtX3RUpGhSz33u3qIY2ty0+hNIpdcZtJPKL0I
	0FjOh/NtuFnKw69mZNSTnTnnVZcV1KedhxHzWll/JpBGMPozeDttcNTfLjpNOnonJtgzzp
	lVE7R4OrHPHYk0zcCNl9jLASoqFe8K4=
ARC-Authentication-Results: i=2;
	imf13.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=Kv8Np7Z3;
	spf=pass (imf13.hostedemail.com: domain of ziy@nvidia.com designates 40.107.200.8 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780953407;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UdVIvNJTRLgGKZIz2PpQ7CDioW1m7oTMB3irCc8ztso=;
	b=5OiFUr1JaAKW6kxyN+xriNNXDJYgTVvURIZv2JrZgp51YQmuO2jtjpX0fteAqvmp44GnM5
	4jhaPqt74hUj8GExslV+g05gJSEV9HAlNinmCzO3oBe0Y83VOmgCLpZMgxPn0+9+4eULZH
	/1C406gzx6vGvpkwhLdLN8P+3JRLLFo=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=M7UIBKdgti+gu162q2xC0CtWqZxGoieUpmtyKALJ81wc4pwNPDMnjpmlgmnAzbOOXxs2vKjRnC7xy8GArVJNGaxuLr+PiFGvR6TOvlrvmDYBlgdJH88J2sJdL+1w1DCOw4uRIBye2YRSLw0AquIOFkMcP9N7EIXEliqaYTgcssMUqCiZI6OVclcIyYRGiAvIzzZlrBHWdlMI+VOksJQTptdWZ+Jx3QgMrj76FuoX6uUDDHRIGXar7WgLjbce73J/hQNKVLe20/mCbV64jurmVYe44d4fXwfViNIlWxd0/K772sHa99ZRvytTRIxbUUbugjym+ABYlunawrN7zQGYag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UdVIvNJTRLgGKZIz2PpQ7CDioW1m7oTMB3irCc8ztso=;
 b=BUW0waeXQ21m2aniicVtDfhF0yT17iaXbp8r1zcp+h7CYzs4H1TL8L4xbBxPQBws7Ro+cQb9ZBDpq+YFmszeejEPMGNWj/cHpjgNulaDdRWd+0J62ixosfxW6iXjyuh+F4KRsEdLb2uYJ6WcSkI6Gms2aODsu0fMrAgNNSA/u/D31KuQECRUpgNEbb1tSksljX7Vls2j6Ou0oVi5RVlx1Sb3zHThOoDX4TNaBxDP9V8vAzSfl2m8tuGlqpuV1cq7vT4hV8NkmD3SW3Z8gCBy4FHGMRHoL6wr9xIncwhf93frVgsGh9mksGB8rcWqcoLh+sF4aeDKbGbueK+7Wg9WDw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UdVIvNJTRLgGKZIz2PpQ7CDioW1m7oTMB3irCc8ztso=;
 b=Kv8Np7Z3B6KE1cySivfitTRjG6ZOyul68EPtVWCHTg7TEC5cvjex8TMefIHALGDD6t5yfWQDuu2MfPZNnC8Ive+Th3WF430JOrHrpuRvyap+az1FafbliNmIZXoc4eN2sdychGgOfqkaHveNG2ZXiDXgDAm8VjDcUk3Akn80JY7Nj/BdQjykEeLsoa06mqcYpWus1JbMKKY9w80Z0vlBcL0XPsvsVC1PSHODC3SZqDeR/H//I5Ek6Vh78vi6mBAPv411EfGlbmvx3lb6b7Rxgt/fe+ZDz2zgYeC2LItWSgYb6ETzzghA5AOfuk9z9ZWdueOLRs/lAwghyRXXoYeMuw==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 CH3PR12MB8233.namprd12.prod.outlook.com (2603:10b6:610:129::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.92.13; Mon, 8 Jun 2026
 21:16:29 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2%5]) with mapi id 15.21.0092.011; Mon, 8 Jun 2026
 21:16:29 +0000
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
Date: Mon, 08 Jun 2026 17:16:25 -0400
X-Mailer: MailMate (2.0r6290)
Message-ID: <DD2E08E8-1FD7-43E3-A2C8-B4435D3773D1@nvidia.com>
In-Reply-To: <20260608170348-mutt-send-email-mst@kernel.org>
References: <cover.1780906288.git.mst@redhat.com>
 <50d410b47fe3f45327783e05bd306d5eaab75e65.1780906288.git.mst@redhat.com>
 <aiaUDTeHDA45ZXFS@lucifer> <aiagMc9Ng_AE_adh@lucifer>
 <aia93IzhTgi1vGi6@casper.infradead.org>
 <aicfERTP3H6AndOs@gourry-fedora-PF4VCD3F>
 <D1CF67EF-2CF1-45F8-9265-70A528C1CB01@nvidia.com>
 <20260608163257-mutt-send-email-mst@kernel.org>
 <BD0C8760-BC10-4BF0-9EE3-9B0DAF0D977A@nvidia.com>
 <20260608170348-mutt-send-email-mst@kernel.org>
Content-Type: text/plain
X-ClientProxiedBy: MN2PR05CA0056.namprd05.prod.outlook.com
 (2603:10b6:208:236::25) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|CH3PR12MB8233:EE_
X-MS-Office365-Filtering-Correlation-Id: 327640ec-9261-4792-9398-08dec5a33516
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|1800799024|366016|4143699003|11063799006|56012099006|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	C8qykidKy/Dpjp13DwP4tcl1We7wHPr7hUQ3GksFigWJ6igS1jcItrKqI6c2s5HfTYApPdYTc05OMp4TZGloNcXF0hvpvh02WhP4Z9wTs1nxcMRY9dtbh2K7ROX/Al4wNvuEs3caN7IgDVh/CyRhl4rmpIVqlqkyQgNRKcSgYlqQfyqzTsRlvyeoWeTNhOh04j1Gk7+998VgrIXgvxLqMfQtMT8Bf7WFu3C7TKynYMPQLqnhW1NFl1hFeGbGkj2joKhVuOp3BgD9VHHUIdDzMQqo0jJVOKRsRvwGDsgQBrjGo3QK8SNYtGB9XBKyVW/BexeNRQDYz1aXc2yMtXc99y30hWHJlDdsJj6/6cXib3r7w48jJCzhIOThiSOG6uAnAi/Q35Pq72+GqXtpi9KlpHEA2Vi/hXrx0Yl5tHTbtBc4+BzefDRhO63jvxf6NTP4ly5ywNCOJLbLweY9w9pMEmL9qGWCHAqtMwA4Wa4b8YiBiVjRvc7dUOne3MAaGS2myOpPic2WvejqxsOBKAG28eQOTLARTo+AaDWBID/8ynNEJ+VARjTHrkNisinGb3Fr0CdqXYAPo8R2BhG+lH4K3P+qnr1c6/atllzmvXXFStgXatC1XGjNvPH6ZNBVd9b9oDjavBCfcUO1RJ7yHPv4hJ8+nHQ1QyQBiqMWC4dWqnZixazaojJ6Texz5DJ2BEPg
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016)(4143699003)(11063799006)(56012099006)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Us3aLT/CNmk/ejJcKHzyGsQTyiJBtaLxVGybGAFNr1/WC/xOwmt2LX7Y37wW?=
 =?us-ascii?Q?pstF2JnEw6bHd+bWnM9tpCxiX11zxWES+t2NlpuVYM5rtu7/97Tj2Uuya3el?=
 =?us-ascii?Q?5AMZVUTHC36hB3GxUViYjsvTaEMJ3W9+/bQbwmqts3K/8ZkIhVEqsOs5v+ft?=
 =?us-ascii?Q?CsUTefvoYyx1Q79KzoN3vwtXdC7U0392G72R/dYx6IWRKNVMS1poMKf8ycKo?=
 =?us-ascii?Q?gx4RH6V+3P3xqQteKbxGGD9yBA/3JtcEVTmFN41pCamz115e6mSk2iOdvPex?=
 =?us-ascii?Q?/sv3I8HomK7dPszOjvzWaMM8osv6bxFT8rC9HgRjgokJlwlUX1Ynvu6iQFMU?=
 =?us-ascii?Q?is0mj2mIzN6Kk/40TLHSQtAFVwsGJkIsaD5ajOzgDq28dX58HxpdldLh44Cg?=
 =?us-ascii?Q?iX7x6KdD5vbK103P1Hdl7E/Hi2p1u/xNPymeUor/fVD7H9NitleAaMP/xz6/?=
 =?us-ascii?Q?LF7E8QbqdDAhSpLPubcMRQVzMQylnfvTviAUsAGCEgtE15Xyj5rYUNZ9ZmTQ?=
 =?us-ascii?Q?oZuXVyU5CR9f5PlWowBmBv2uPS4UlpWw0KuxcHV22v6PsCsJ/vm9KYxwEw9/?=
 =?us-ascii?Q?3Nl87A4wJhB8ShPjOQGQPeyyx7et2VSzlL5WtP6uYmaGCU7mcCYxrVAfKURh?=
 =?us-ascii?Q?Mgf7qTFZneHinvJOhtgOxsrbUs0C5s89Nwg5NNQcyvV72z+uWOMPRzfcBFzn?=
 =?us-ascii?Q?2ULapBFjs1F3ZaFJvvfaLT+UCJoWXVZ+DFTE+t3PRyBik2MLaKBjmNtm5c1G?=
 =?us-ascii?Q?DVLTXz/dTDTxWJapEcZf6C+4FBRFDKwF8uBzgVt69u7jcb9AmUoWDLU2tiNr?=
 =?us-ascii?Q?FIJAmR+Te5jcpEs3gjsseNC+4lyXK1xDgtWiyrhoYCOG7hO09GnLquhwyAnR?=
 =?us-ascii?Q?8UFzbOfcmrI4O4cM6g9nEkkG0D3irwFQtJFhpLTROwPcqQbd9m5tuI3ZQnXq?=
 =?us-ascii?Q?6VdHFwofuWZJRKX1XzhLO5cADE6QGaaBQjqAAvwiFZq5djnxWcMiLS7KnTzF?=
 =?us-ascii?Q?D6J2NHO0J/uA6+4yXx2hUeOmWq41ktvEJNpQlfhE2W87+S9Q7U/iVYsyh8ri?=
 =?us-ascii?Q?Utp0N7kulgUy3qwymnqhpPta71HZOUhHFo2xY5sonFY7BtdOZQGg+M/MW54H?=
 =?us-ascii?Q?ZvMwv7++77QMRtrFr+FkVnFqjzLFwXodAqM0JzSqPYwFs66ziv/n7SmHesD3?=
 =?us-ascii?Q?8JsKMINEhGt2z9Vy3F0NuFTGcvP14zp0qhWzjbK6jPztBbH0oFM+DyESRPTm?=
 =?us-ascii?Q?wMM24sfUn/LohqnLgQKHdgfn4p/PZWH3kL6jEJRzTMpHQuE9Nl17JxEFuT7/?=
 =?us-ascii?Q?TY6qWaO/zKXA8x2zKPeqFhnhG1tPy/vRSZ1ejcsZwxAzsMNfZ74NNV9xJtws?=
 =?us-ascii?Q?hMPHqCfvZa9refQxtut3C3psIdOSjpcV0I0iiPbK8+gLgAjIZwZovLCg1YRq?=
 =?us-ascii?Q?GLmbZjSalX4hpMHhBzyPMuMgUpU+xU+Ap2lxHtNKszYxaO+/WQaaxd1vgwSI?=
 =?us-ascii?Q?ECol+CM6udHXQKW99k53yCPOT0f93c+9qcAz2ZsMgl3A8D/96XyMrmti60Gr?=
 =?us-ascii?Q?k7Y7eSkiCxOo+7d49n0JUq/khDXrWHzPKVX7pOhZ7vqv4kyXUZAghWWFmrLo?=
 =?us-ascii?Q?gUar1z7aW7nKpuGVtOPBXHSfv3KPmgFub8Fn1Ua7VBPxd66wrdnaHDzt40Et?=
 =?us-ascii?Q?LUvk+VwEt/Mh3BZo+1AVjxxO59a0XnGhLJQ1LAXQEZLLEMuE?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 327640ec-9261-4792-9398-08dec5a33516
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jun 2026 21:16:29.5383
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SWKroQM5PlJK3fA7vcAXwYSfPp1GIhTBgoMwX8v+VPLb2592vzXbSx5Bf1+x8QdD
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB8233
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: AA83120002
X-Rspam-User: 
X-Stat-Signature: 849bz7qcrw9knu4xyskd6xmehoofqbn5
X-HE-Tag: 1780953407-306914
X-HE-Meta: U2FsdGVkX1+GRV3PK3RgUrHQ2A603IbpJ+l+SgMVlv/jUi9NsOJribnLFK2ZPXXKusvPQo+Q87PX/XGp2VNx1zjGDBbA1gXNs9HmtUOXa5lu5PaiPSjPZ/ZIca2W8W2VNzlbf99A2gsvdwnOUOT0oq8lXT96yxr3Ie49JZDNITkkT5yansBndZTj90lpYL+dbz6Hz7iIaiGhDBRwMuZlPftLcvq4g5keb9KU5a0i5iJets40rShGb2DKZAhNrQWoNM0mSSdI7cGwkfYGrTZIlAlJLV7U15U6Rt8EIYrElhqeWiwfgGc2AU5eMRJT395t49gvVOPCy3aMu/T0I7FWum+h6Xgv4j+PZ5LM1z9PDrTCnJS3pcTFLMxIs1li/x9b4X9Rrg6HXoDTjD+5WDBioco9z+3HVLpWzmDXcKNjY6npOEFXwNolRDfSG2FcXcP+dADqcO/EbnDRKY2DYVNlYxlKycEjI8/c+MJBh4PqZLRdbFzcqv6yrcgJW0ml6EJQwcFb4GjQLHsTRJrrjc4/WlUNREK1xFgsiPGf1FofsUpLCfuJN7e+xbGp0KB+xsXSIO4VATmz62ldc+GZAcwxFZIN1LStGcoKKNIB088Kjd1lTmO+7mqCU2Ah47OkzrqogC9s7+/KVrR1UN93vd+F4GBx/K6XRxEb0ulAYShdKKsrXrtNSpXh+wZdNSw0jcUevxsoal0b2cOYd0HS/xKOybur45Sdgx7SfZbUFCx0os1apuUn2a+x7EF8hPB/dMZP/YfVFOlNvouUKuPEkwqD21BlCkvAXdofAvc0f6e0+tGEqsTU2HXcNwslbz2Cxo5tP+l5RENzQAo1woKngu5xkkY9CHDuM7Y73q9yI/wRjUIHv8e6/cD7hGqHyQUKubknhwh58pS/S0N2rrSW7j/JisgSzh5yMKlXmRvt+kT0D1NaYtZk9O5x3YmGeUWxhN0HzsdxIpekuMJmYtVp+3L
 XaaxxAZw
 sytt/qtz5s93OT+fXHbSIpiUl7HyYgiV3KoKt1XOpeg/zKEjraew/rEt2bj8uqRIY18kAUb1fCFZyxx1Jwz0/7qAIBXePndDr+ZOQtSoFKnwNj3XS8vrL18mxffqS81KeSFH2OSSKqfIM4qTzAwNsGTbxNzhK0PX7kuyUp0Ln1NcxWdH4vPKsvg2QW4UTDlWpDN+uk/t4n2iPuht+MrtXHsWpNSXJGqcuC0sCH3Bayt5y/anZu4Sl1uUNUkbQpUQF28MwsquPBfSNWiWvkMrh0YH9DsSPB5AJRRBblZZObRkpWTKUwQLJ9UcEO2+S6cS8UJa71koW02iznLFsvCbDWtGeLvOSjOh5PdgqvII8xfWqIVAHNih1WWldroZQ48BENdfsnNHs8aLxwGu+axIX7ZeZcQvSEmPLx/HCH5XDdzpdAtcmFi45sL0HsD1IbF3iIf1R9VKBjlWZbGTcxgIHpMeM37CHlpUUkVkAz66KIH1tFcc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8 Jun 2026, at 17:04, Michael S. Tsirkin wrote:

> On Mon, Jun 08, 2026 at 04:40:15PM -0400, Zi Yan wrote:
>> On 8 Jun 2026, at 16:33, Michael S. Tsirkin wrote:
>>
>>> On Mon, Jun 08, 2026 at 04:21:08PM -0400, Zi Yan wrote:
>>>> On 8 Jun 2026, at 15:59, Gregory Price wrote:
>>>>
>>>>> On Mon, Jun 08, 2026 at 02:04:28PM +0100, Matthew Wilcox wrote:
>>>>>> On Mon, Jun 08, 2026 at 12:06:35PM +0100, Lorenzo Stoakes wrote:
>>>>>>> But instead of overloading user_addr to indicate all kinds of things, instead
>>>>>>> make life easier by actually breaking things out.
>>>>>>>
>>>>>>> Like:
>>>>>>>
>>>>>>> enum alloc_context_type {
>>>>>>> 	KERNEL_ALLOCATION,
>>>>>>> 	USER_MAPPED_ALLOCATION,
>>>>>>> 	USER_UNMAPPED_ALLOCATION, // Maybe? Do we ever?
>>>>>>> 	/* Perhaps some other states we want to encode? */
>>>>>>> };
>>>>>>>
>>>>>>> struct alloc_context {
>>>>>>> 	...
>>>>>>>
>>>>>>> 	enum alloc_context_type type;
>>>>>>> 	unsigned long user_addr; // Only set if type == USER_ALLOCATION
>>>>>>>
>>>>>>> 	// Maybe something suggesting context or whether we init before in some
>>>>>>> 	// cases?
>>>>>>> };
>>>>>>
>>>>>> Ugh, please, no.  As I suggested last time I commented on this
>>>>>> trainwreck of a series, lift the zeroing functionality from
>>>>>> alloc_frozen_pages() into its callers.
>>>>>
>>>>> This sort of just implies writing the "alloc_frozen_zeroed_pages()"
>>>>> wrapper that does the zeroing at the end before return, and then killing
>>>>> the post hook nonsense associated with it in the first place.
>>>>
>>>> This means it is going to be a multi-step optimization. This is probably
>>>> step 1.
>>>>
>>>>>
>>>>> None of this resolves the user address annoyance which is needed on some
>>>>> archs for cache flushing.  Whether anyone agrees that the page allocator
>>>>> should be responsible for this particular operation - open debate.
>>>>
>>>> This is probably step 2. But does the virtio use case apply to these
>>>> archs? Does the performance matter for them? If not, maybe this part can
>>>> be left as a TODO.
>>>>
>>>>
>>>> Best Regards,
>>>> Yan, Zi
>>>
>>> I doubt it. But I don't get what's proposed, the code that we
>>> have to modify is arch independent?
>>
>> Change user_alloc_needs_zeroing() to only check address aliasing even
>> if that can cause double zeroing for virtio.
>>
>> Best Regards,
>> Yan, Zi
>
> Ah. I started with exactly that in v1/v2. It's a simple approach.
>
> But mm maintainers said no, user_alloc_needs_zeroing is a hack and
> I must not add to it.

Got it. It sounds that you now get conflicting ideas. Maybe you should
start a [DISCUSSION] thread that presents the high level idea of what
you want to achieve and all the ideas you got from the reviews, so that
people in this thread can have the big picture and come up a consensus
before you send another version.

Thank you for patiently replying my comments, since those points
apparently have been discussed in prior submissions.

Best Regards,
Yan, Zi

