Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8E9E6F483E3
	for <linux-mm@archiver.kernel.org>; Mon, 23 Mar 2026 19:07:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 08F6B6B0093; Mon, 23 Mar 2026 15:07:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 019816B0095; Mon, 23 Mar 2026 15:07:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DFCCE6B0096; Mon, 23 Mar 2026 15:07:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D02386B0093
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 15:07:24 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id A5F241B89E6
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 19:07:24 +0000 (UTC)
X-FDA: 84578261208.21.DC2D68F
Received: from PH7PR06CU001.outbound.protection.outlook.com (mail-westus3azon11010060.outbound.protection.outlook.com [52.101.201.60])
	by imf12.hostedemail.com (Postfix) with ESMTP id DEE7D40013
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 19:07:21 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=T6HZDHrq;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf12.hostedemail.com: domain of ziy@nvidia.com designates 52.101.201.60 as permitted sender) smtp.mailfrom=ziy@nvidia.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1774292842; a=rsa-sha256;
	cv=pass;
	b=IO4cKsTMCqITSW4DplhAUugNsu3JKnOytp7bLI7k4LehCEKpkKqmP86m6tTwhLEoTs09Ry
	sqhDSdcDeoSdr2Zd6mLyAk1O/WZP73xpr00ZKwWJScyVP6zjkFvHEWvw0eExdfqXSAoBft
	Q1cyYcnzpw+Sh/Q9W5fFrKKYz94oAxg=
ARC-Authentication-Results: i=2;
	imf12.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=T6HZDHrq;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf12.hostedemail.com: domain of ziy@nvidia.com designates 52.101.201.60 as permitted sender) smtp.mailfrom=ziy@nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774292842;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=w5Y4Ma6nPfpRSXY4hh29wB6hPN6i+d96I0iGCltyoTo=;
	b=qrk0i7wrjbQDKNUpPNSRHywE2huy69a8eCqXNVZ93HKZzzO1sd/pknk1bMGEJFBG2y/hwx
	v/8jhqVoRA0VntXLRlcTy0yugwDBNHH18jOToBHUz5XsqcOsYKhzwt05JU21vfq/FWnt70
	Uj1pYGrdeQnpL4D5R9aRDGWFKskZvHk=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ttRLBhtSq0gGns+1vPj8aJ5j0T4y9SE0joAYj6utyl8b/DG8PiJuTA3/Sg843Y0SsOSQBbY6pfY6k+kVDAcwlIilfUKj3+luLo2rWcrVnKo1sdATh7bEn5UU3vDy1IfKXcJwZChLyGfjhRENCqOAp02qfxJAqErdD+tOD3b2uktSw31jE1gnpNHNeHHy3LWYD5AOIcDmNG60b5JylD+96kQoZcqSj9al7uYQGJFv58uTtgAUppyxXh6zycXzwmxITJ2N1LxPLr5ZSdEA/85Jp2VBMBwJP5WNTakzkbqbxnMTNDt0uzlLSLkNn7S+XgIeANQUPBSonqUyo0wB/V3Ulg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=w5Y4Ma6nPfpRSXY4hh29wB6hPN6i+d96I0iGCltyoTo=;
 b=UvL/IUulJ6nK8SeJQ3TObYjEtrewTbeiFGVrcKhp/TBbBE/Y+BwrgDbQeu4ZoIH5SCVYAVpdD982qSX9QEyXbQcBGNtAU/jrVd7zwPLTJPxxyYx8GxeMANe6sxeWF52PvcmZzHx7P1zKpHaNvJpETdIJ4c4XAGytrOaX9W8xHDwrC3McO5KdA/m0fP/NOjkB+kAeo0IoEjuZnmFDpc7m+MwgIj7X2yGT1GWjJ7pZQYH+zTSK0Nd6t74+a4+Fh/IbgBEOR5+/BRHnkrDafJwJQrBNx7v0vKkQUbuWHY1XochgI8ubD6rDNMlxF+Qm6CF6yMJisK9zGM1L1apynxLT7w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=w5Y4Ma6nPfpRSXY4hh29wB6hPN6i+d96I0iGCltyoTo=;
 b=T6HZDHrq+3NLT1J7RmU6g120tfTeIIH652izmCNqbOENPMZm8TxkRnW3yACriX87ocfjTp8Tm3d/gbCv9lOhNSbVWlNShAcCIkagi1uFGNfDHJb1ewVwDEwgyYOBduux4hZgudbO5GOdMSZ+iXg2DMH6EFV36gys4Kdc+YptI3YnIYKTTG/UcwYzDgp+gA88lbOn7JNpbljpQMzK0WrXNgMjcCyqg8cX1GoFnfjHaRLTDSzZ4lKJ46EJnlUZ5kh1xqSOxpc/9T2BPrCwSV75DJMqq9ANFfdoL5zpVUoySWHgwuX2fzqiHmCaBXpejVFMuXoRM6mfon09rovzxwDs4g==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 DS0PR12MB7607.namprd12.prod.outlook.com (2603:10b6:8:13f::13) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9745.20; Mon, 23 Mar 2026 19:07:01 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2%4]) with mapi id 15.20.9745.007; Mon, 23 Mar 2026
 19:07:00 +0000
From: Zi Yan <ziy@nvidia.com>
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Song Liu <songliubraving@fb.com>
Cc: Chris Mason <clm@fb.com>,
	David Sterba <dsterba@suse.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	Jan Kara <jack@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Nico Pache <npache@redhat.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Shuah Khan <shuah@kernel.org>,
	linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org
Subject: [RFC PATCH 09/11] fs/btrfs: remove a comment referring to READ_ONLY_THP_FOR_FS
Date: Mon, 23 Mar 2026 15:06:42 -0400
Message-ID: <20260323190644.1714379-10-ziy@nvidia.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260323190644.1714379-1-ziy@nvidia.com>
References: <20260323190644.1714379-1-ziy@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN2PR14CA0018.namprd14.prod.outlook.com
 (2603:10b6:208:23e::23) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|DS0PR12MB7607:EE_
X-MS-Office365-Filtering-Correlation-Id: 2d8349f2-6c85-43aa-404d-08de890f5cbb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|7416014|366016|56012099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	0CviLTIXWQ/9g6iz4hYfoJpsWhmEHOrI/MBNE1VzH5KL/86DeXPZ0ck95kYZirU2Ffzx8MREkq2MpKNaj47XC26rBzza0Gy3Fm9q+WNG9x3cCU9CVh6dzvdrEiHskfdlxeNTxCD7eXISvULjl+pY3sSqHrSF7MmXmY8jfr0rYw7OGLOc4KhJ/DBi8yMEtWpL4jmIsW08hBL65302Gkhy9kjkH8pX4Ri6giymcla9HSAJiQGjqP5Qks9NZOPY50GJl3jFkUEJsvHGxilGD6uzpmWQiktl160CTCKVhDtyW0hT4mRHItYWrRY9IObABnZR2H9mNYFDFydLjh3Cpntgc6skdzi25BZVj/NCrvEJzHX9AspI0EcwWnLrzL5wZTwM7pJzZ4CU/a1xa9UYjZNaCYxyFwzibmhe9mCxYjsb2sHnJ9wkVC3v3vdNEju+ZBzd7/ysD/8NUPOB9DaM81LHzF9s5tVadIosAr3zPPU8sK2Wyu7q46WtjYbpIbdzsB9+KsfP8F/I/dTpUeY8PWbRt55LGCZ+UUaPV0fxESnqM0INTBV1wMT9l4C3qgC4ZeAPo7YiSOvQhoKnOoQviLUPcR1E3LqD6yxCtMgmAunPtLpAww1tDKqdydgMOyaLlVgxKA62Mrn/21eCwEGwB9e63QKQynWbWqF7z44srtnxuzJTDGXvovORjroKJEqqyPpwodELf8hIctrr/PufKf7EDCe3OKnySYr+/g+4NgkkjIA=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016)(56012099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?1EfDz8kplK3/BpNRPbwejoEpJnKnFF4tqLxxfAdiZjEUvITOz6NkXR45Pvj4?=
 =?us-ascii?Q?lZoGPyzxg+CRrFl1PA+R7iVFlDvi/9InNAwoX3KPl0Ry0u6NQyVyS10vQaSk?=
 =?us-ascii?Q?J5STZ24DGcrQA9JjF0VA/lRxyORWexj0J5D6jU/3Wz/C03ekVgHdLjUPR1pk?=
 =?us-ascii?Q?7Kt7aouGAYZZVd5Rb4h1anAS/y6F3PXn6CejeGN6aqO3b9u41qxbap10Xz6R?=
 =?us-ascii?Q?vHvrL3lgBrf6bfKeuUFRaU+xV1MlaC/n2+sjQ9/477B4Qk2a5azcvHbdwnSq?=
 =?us-ascii?Q?DdCMc7ihrkbwY9IDGVO9YydIRDnH0zYw8XR6CUkC1PjosJE1sUhL/DgkhkuC?=
 =?us-ascii?Q?MFXrKPfHK2V3FYoT/afFqtx/T4KuYT7I/y0DZra3U+wLxVlCnJaha6oAvRfS?=
 =?us-ascii?Q?0rlGePYEwUyoSurUjLcJy5aR4uKyXRzsdYnq5iyzQ+BKN2iwlfpsqaagSrEG?=
 =?us-ascii?Q?F1xqZp4KvlSQju1c0E82wI4s+cYlfsXM8cr/kLSqvj7EPIeYI0IJJCyNwzde?=
 =?us-ascii?Q?z609KtnWou2iHE07p5/LIB5g/+bkGRHvLxGpAR3ab8kQisBwJohwQN9exBsr?=
 =?us-ascii?Q?3C3HBgSojUm9dmNyz4ajUmZg7bKxRkFEIcVzACLm3OCK9WSjc/Q/ex2vohjK?=
 =?us-ascii?Q?fAXUxwKop/1oIPHgsgaD/RP01BmDSY3Rvgv9T3oviEBlTndjKCOphJE5Klmd?=
 =?us-ascii?Q?V1kUcYFLLRjWYMKTmWPhKaiTGw9zd92Itp9PsEqPaiUmwnurGJTDmI1qZ5X9?=
 =?us-ascii?Q?3WaK6tMQxZBBIvWxjzJnXrrskgmfUng+I8tKCluzz0tngaCYn7L48N0A+7GC?=
 =?us-ascii?Q?tTPHiDlW7HiNfi12ldhvB+4XmYBfCIl6DxznS5J2bsOX5VTvug46jKfdWiap?=
 =?us-ascii?Q?9yH/M5YdAoJzq9U9j8PzuCrvW//vNZ2rWIhEyZxd0a5kDRRqVZxnETfMGOdN?=
 =?us-ascii?Q?05COjlwueMBsTHc5lAsOdhY+fs24ua1c8fEKtXhkgETi4xnHmMc/bvaK7Zt4?=
 =?us-ascii?Q?hMc0FxkUsdPW/ZeDbAqO97PAplCwt4Zjoirvv4ybvjwGDDbJMEdNmjLmvJDw?=
 =?us-ascii?Q?FgKq4IQelOvZvnzOcSB3hFMpsL2b3xTBRs6y7v571VrtPxG/IN+qShya7qFr?=
 =?us-ascii?Q?aDu7iRXelvJe81NZdU4W+0AbSFAOQ6TU2W8CNOH5NoVvJ0A5bCYA0o3llW07?=
 =?us-ascii?Q?pYN6nYLdT5HVg40FhAXF+ETmVeJv4kb5FHWrJesdLX4OuGFRF9p2D1EflbeG?=
 =?us-ascii?Q?dos/zK5b+VPtv37Lvq+zG654ZaDUJKdvoat88Qz/2Cey0SZ6CfrrQWbpPxgt?=
 =?us-ascii?Q?m0MI9/spT8bb0ezFSi6b+pptnUTyC7iW0mWoOIDSFMKO2YrnwkN4nAUeTh/a?=
 =?us-ascii?Q?8mzOrCQJc6Wf5QiGRfrhYAr4gx9GrORVlbxnzoQqTXG+ioPvROl606UgQoZl?=
 =?us-ascii?Q?Soupywox+I/95T2vd3foDm4FSQ4326LvlqaUH1TlNYwPmJXeNvkW+hQls1kL?=
 =?us-ascii?Q?EXHWfHR2L8WFthH4aPBXIefe+kxiMpro18eGOoy2DR+YC+WSCCPw3nyMcXku?=
 =?us-ascii?Q?UFHa5BGTTg7PO0faFWMMeS3Tfnn5PLfKXKv5PAxdPv5EPZxZTnmr2Dx75D/c?=
 =?us-ascii?Q?fcWqiEh8Wia6oQm+RF3m1ca03QzIO4huXhth84c338bvhPNH86D05AC1bo39?=
 =?us-ascii?Q?O0LFxePJfjgN4bNVL/h4/BUBTNQ9RlrTIlQ49ghpixkVamNq?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2d8349f2-6c85-43aa-404d-08de890f5cbb
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Mar 2026 19:07:00.8044
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: z4huzFS57HAk0JlLhL2nG/rvsSDpjxT3URwg1NmqdNG0FiPTs5JaAqYJ11qOh6ya
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB7607
X-Stat-Signature: wec5nafqqkkb6nr7anrx9q9cza5gcued
X-Rspamd-Queue-Id: DEE7D40013
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1774292841-47895
X-HE-Meta: U2FsdGVkX1+OLIfjdorv5Fxff2PZLX3MsUtqyXzsq0Nkpc6g5Cgv+d3ldRnuMQ+8rosqyeal5hcZ/v+rTM5w40HCznMCVck08GWSThS9pdJDXruHjVn+Ce/In/pxecDpD1LRZvORQToWFvAEDD/6RVw30oMo/4WjcJB42V/acSaFUUXXiY20Gyf3u18W3/MhpOIO+qSIp/OPiHHmhROjrXhXobC89w/A6Khf386gJ94CqA7oLCz01Z4Kw58+oygnv8yvibEkiJeGZhQHG+Nk3fhqsIjMFiScYAhP3FiGVyB11F+5+fRAWJqlRNniV+poiOrU0B34CA0tJb0+0HjnvJMQfL6DXeVJECW3h7vrmiI+Hkhddl7dGn/UYoJ2hN47CNS7wiDvwJvhfLxILxeDffn3fGQopDnW3otZaTnkxYboj4TAq/RWBFhyMglL4GBk0nfyO3HpQ+dI6vAvWv+3OyOta+jIVI51m4zNChhcGnxCllXnKbJOweeChQ6IfITJuI3ECBZibVOpR3fn/WZE8Ljvis8bYVG2H0pe6cPTPbN5hDLMouF1XL+eRONRj9UPBHt5UvEhVih2v4D+dRihFJNuU5bveF2UjqIG98IfEaD60qt+k+U8B2+T30lDPMrfX3AvH4TEfMQUPlC/S0Ko9Owi7Cwqd9hEmH9V3+Lkrv88y6PXa8WARbvsnLVLubx5ZR50G7ct24yXWAqO8x9th/clmIfNJwU3Nlmdi6YVElVJkn82tQUIw78zHz6hJeOpTSPQE5GoRXEdehRgK33S25HJlTMkVpkV2EyGKFmrOvqU87D+Ea/w2bzr+5/tAKzrbDPTnVg0EADULmRV6+lOWC+W8N4si5rJQ1I8gnKnaNaRarAi6u0AHZBJav1g0OxnuHID8tiZ1AZ5OWp1r89vNe3+Eo/AoDjyHyF3klitD/yZWauppiBZua/QQjifidJ50u3yndzHegfI4zvQUJN
 g2VfX4MP
 fyQ1x3PsYpx9xyQB4POd1Sn0lTPzibW0TnrAyodfqHwwUTlipM/eaVpHplBkl+tGR1JAbbeb0kkbaqKs0bpMe7KX93YonaSUR1ZCLkwW+qqZzOL4fDlU81NfMVdo7lNUf1nHBqM9ewUQMQ6QDWvLZ4kPAfkZsbaExQAKTp52aoAkdIC9bPi9HRT0tI9B/m5rdS2sSnb35gGHaVesiLNJAv8Qt1ZqzhQ+hBgM74RChrGBJLhxXI0NUUyRIalDbmz9NhvmSbYiifjNaaB97eis47SigQzffA3oWeSmSkP/yJFNJK1lhcCFJfFz+UtZKHaY4i6EMsdJhSClslA3f4vsAKmY5C6gqZcm6BmKApywQXz043N6Zc1fFcJbFJoC5iJa571NXp+C4fUX+TY9OwT/pBpGeZ31awocIAiZpcPYaOOFpD4w8KzJ5WCyzmw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

READ_ONLY_THP_FOR_FS is no longer present, remove related comment.

Signed-off-by: Zi Yan <ziy@nvidia.com>
---
 fs/btrfs/defrag.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/fs/btrfs/defrag.c b/fs/btrfs/defrag.c
index 7e2db5d3a4d4..a8d49d9ca981 100644
--- a/fs/btrfs/defrag.c
+++ b/fs/btrfs/defrag.c
@@ -860,9 +860,6 @@ static struct folio *defrag_prepare_one_folio(struct btrfs_inode *inode, pgoff_t
 		return folio;
 
 	/*
-	 * Since we can defragment files opened read-only, we can encounter
-	 * transparent huge pages here (see CONFIG_READ_ONLY_THP_FOR_FS).
-	 *
 	 * The IO for such large folios is not fully tested, thus return
 	 * an error to reject such folios unless it's an experimental build.
 	 *
-- 
2.43.0


