Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 328D1CD8CAD
	for <linux-mm@archiver.kernel.org>; Tue,  9 Jun 2026 18:39:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 771316B0088; Tue,  9 Jun 2026 14:39:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 748DB6B008A; Tue,  9 Jun 2026 14:39:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 638376B008C; Tue,  9 Jun 2026 14:39:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 53D6B6B0088
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 14:39:41 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id D8DF6C26C0
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 18:39:40 +0000 (UTC)
X-FDA: 84861237720.24.7AFDE97
Received: from SN4PR0501CU005.outbound.protection.outlook.com (mail-southcentralusazon11011020.outbound.protection.outlook.com [40.93.194.20])
	by imf07.hostedemail.com (Postfix) with ESMTP id DD86140013
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 18:39:37 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b="HW/7XQDn";
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf07.hostedemail.com: domain of ziy@nvidia.com designates 40.93.194.20 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781030378;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CUYy7hWVfORsTFymfhojemPuStjNYx7jE+eVlMQ4xA8=;
	b=Mv0/k1vZ/nknlV5lub8Q4ZA7kord6stwmVb3z5Ocmx3rK5RNqk47NGMW7MLeMEdGtLLsX2
	1TKAEsJdnvE0oUrYbzgH2Au6HlIbsYxWlXAsaotVbpBzFJvOqbNGbO1DBuHPBkvQQve0EZ
	KBiggswtJ9aO82GwgC1wlkdu/kPz7kM=
ARC-Authentication-Results: i=2;
	imf07.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b="HW/7XQDn";
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf07.hostedemail.com: domain of ziy@nvidia.com designates 40.93.194.20 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1781030378;
	b=eKVkNu849gU37qvEDbnSn1iIPTlkpUU1HIsaP3NmAgJVMbjqXguJclOUJS/+jZlMFWVRIY
	WvnB+RzcyJ9Vbco5zDxjd3gyJiAz05EnLC58WliQsWtwXL7lpz/wFnQEwVs5Rdv9ABFaaP
	5n3hEdHhOKMuJD2TudTqzE7xK4swxeE=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=PoS320x0u9F7TF//qpcd/gQP9ht94gAoSThxa6bgvSFyDiqQEkNFmoZslw2ebyZEtRU6kP/cGtZxTwqYqdA9Nk7s6Y0MaPqQn284umG9ko7QpZyVSJO/L+977eVUc7DbF7nkMEv17w73tzQeoSBaXhcXV/9cC/wERoWZli9Y3eTtd1gtjqdUvzKw0IBkCrk22l8cxtEKZXvOD6XRIAgs3QvBJhkv4vIK6DDZ8EorRrx/uT4gUcsQZ1545ke1Cl7SSVse/otse1DWnm8i0MFXB6o+IBZ5amAFMhcQfHO5bue8BHlr355VAXciM/B+Wb9Kc7sdrev25D9pQVPVWuCaag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CUYy7hWVfORsTFymfhojemPuStjNYx7jE+eVlMQ4xA8=;
 b=cpeKAjAKkjjCQBiDHZoVt/+RkdhakugtAHRpibdOdxfv/eYe1UldA+2XcVc5y+QgabhI3rL7fl4Mp2DGxckS6IsEa2zUZgYilDuq181tcTzyMBI3pDepHXE0y8N2iKJSyRB4ThPCzj0BGd2hns5fBfICQlEf1c/akCDdEQxSSC0enwSGqW7kN5UgmksGxlQs5PjneF/7Fpx/ohn5PqoBEOtBDAXdAOUJypyoIOHfLwxmBw6WJjJlDdaHAmZXXfwERmbw+srsqmmYRhYqF+KIxXF1QKvJWyL6bjPZvnBkLrCxecrTSLf1K9h9oo7JWeDzztRndVGr42jw/nsmmzIp2g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CUYy7hWVfORsTFymfhojemPuStjNYx7jE+eVlMQ4xA8=;
 b=HW/7XQDnaIm4i8s+CEfGeezqQ4Xh0gcga4aopHPvtOzVt5sl4VT477AvIbSGAWJF1RqSEXSNpM0QtV7DDZ/0uJtv88nUa1d40G/uPIKcDjr7bAqfcBLNPbzxVRAOjwp3BRlf49IFGXaHxa9K3dCLfjaFo2SmBXU0OkHO4YEHW5VCBnP2PD8EEHCAxyv+vuEN+U7MGAkV0YrukRLxB66swZgY6GjeHP1lCQuNZdgFykyt69ZctNLZ6Kne9eb2Suq6Hf2yawD4OCCn346aByrUMcc5hM4ltQiqESH6x8Td+n7fkGyU7xZlwVfTcf7q2L+8oWtK6JhWuHQbOeibk5zO6w==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 CYXPR12MB9280.namprd12.prod.outlook.com (2603:10b6:930:e4::5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.92.13; Tue, 9 Jun 2026 18:39:31 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2%5]) with mapi id 15.21.0092.011; Tue, 9 Jun 2026
 18:39:31 +0000
From: Zi Yan <ziy@nvidia.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 "Michael S. Tsirkin" <mst@redhat.com>, linux-kernel@vger.kernel.org,
 Miaohe Lin <linmiaohe@huawei.com>, Jason Wang <jasowang@redhat.com>,
 Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
 =?utf-8?q?Eugenio_P=C3=A9rez?= <eperezma@redhat.com>,
 Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>,
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Brendan Jackman <jackmanb@google.com>, Johannes Weiner <hannes@cmpxchg.org>,
 Baolin Wang <baolin.wang@linux.alibaba.com>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Hugh Dickins <hughd@google.com>, Matthew Brost <matthew.brost@intel.com>,
 Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
 Byungchul Park <byungchul@sk.com>, Gregory Price <gourry@gourry.net>,
 Ying Huang <ying.huang@linux.alibaba.com>,
 Alistair Popple <apopple@nvidia.com>, Christoph Lameter <cl@gentwo.org>,
 David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>, Harry Yoo <harry.yoo@oracle.com>,
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>,
 Wei Xu <weixugc@google.com>, Chris Li <chrisl@kernel.org>,
 Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>,
 Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>,
 virtualization@lists.linux.dev, linux-mm@kvack.org,
 Andrea Arcangeli <aarcange@redhat.com>,
 Naoya Horiguchi <nao.horiguchi@gmail.com>
Subject: Re: [PATCH splitout] mm: memory-failure: serialize
 TestSetPageHWPoison with zone->lock
Date: Tue, 09 Jun 2026 14:39:27 -0400
X-Mailer: MailMate (2.0r6290)
Message-ID: <FB250C43-790E-4AB0-BD40-74665FC601A0@nvidia.com>
In-Reply-To: <8c1f468e-b50a-487a-a267-8d1ea5a61c87@kernel.org>
References: <df06b66fe4ff8e925ee0714955abc2183a727b90.1780998980.git.mst@redhat.com>
 <20260609111020.e88f51a7b6ebc37360d66fdc@linux-foundation.org>
 <8c1f468e-b50a-487a-a267-8d1ea5a61c87@kernel.org>
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: MN2PR07CA0007.namprd07.prod.outlook.com
 (2603:10b6:208:1a0::17) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|CYXPR12MB9280:EE_
X-MS-Office365-Filtering-Correlation-Id: 34baee54-7467-49e5-9c62-08dec65671c2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|366016|1800799024|11063799006|4143699003|56012099006|18002099003|6133799003|22082099003;
X-Microsoft-Antispam-Message-Info:
	FB6+tAcXRNJvG1t+CfUD4ggbBZ3PPRxAXeH00rOFRktlnanbFvEbSR4pQeXTPA+ttzb1aBW0x7hsP309egnzXWQEALsIIdRAizMzoA4oZtGvI/O0BQUcCNjWS7P7q9AtNf+OVa02WXdVEJJ7W1WkWLuMLIlAKjeG1/HWa5p1i3luemjwJePIgaX5XIvbrWc/z8aq7ahttD/Cgo61EfeCvspAitjmezsX/OgkMI6ysAgeeiv3jY/3lnL3nHCs12gBlSdj83UOaEyVX8LgGRwOaT56J8cXCmeO67sQbU9/cibbkQZUXkr8LeZtA2dU5u0bR/O1Ao8roaV3cUGCpL+EKPRRhR01Laz4l7ASAgSAVO1H2QBbmn7yUv5CiL6RLVpNOZJRg4eFixSoqcTkryOUSMXJladob+ttX5zkwmAA6sPYa1ZegQB27r4nX28VlUErphVtCPjEVWgY+wStFhoMj7xKGV5ldbgEpRmdCvuz0zZv0NLfwU+Vi/5WQ1NKJLAuENe8ImkRx4eS9frPnpoggi3mVztjdhDboyhYWrB0tw6gKTxuyDz9GHaTQqK9Uh2elr7g2mj6I/C08ovkRD7BQLhV/lLdIBLc8WpEzLiOV6gjmyyQ5gTaTU1wFFIGm+DQGxanAoctWbMx5lweGYmrJV0BOnRZyqmS234Y9WagEyVQuPMTqmXiA8sEBTb0vVB/
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024)(11063799006)(4143699003)(56012099006)(18002099003)(6133799003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?u91ofIT1qFAWCkYr3jBRz61zI9ZE35FgnhbLWOKmXEY3Bw8ZbIp4snUcfgTC?=
 =?us-ascii?Q?A3bw7d2x8ab7pVSmyNUtQDyrdsCFMfchy7LpGWqDlOUkT69hVZFSvkN5pa6s?=
 =?us-ascii?Q?mGKDPY7o+pzJP3KO593lz/CnJ1dUbt/T4Jf4ofNxw4OjVHbav8M/sP6Nf8d8?=
 =?us-ascii?Q?O3IbXPlIPg+G6U4nl0zER9xubv+Jkh1C0c0AttPA0Q4ydnL5Y1GTXz7R8Fya?=
 =?us-ascii?Q?V2vanjDY3btsQv38Poh3fBAQANkvIJH1L+xPSJSnb+4yl3bkUYmgHjeL+Td2?=
 =?us-ascii?Q?ND84sGIOecjwwiWKUdxfFGxcgWgmqYOMfYar7QEvGo2rnDDi0gwR05NMl28W?=
 =?us-ascii?Q?+Jh/X+N1//auDsE5Jfz+Jh4ee/BoMrvBNfrmndM6xUJeJrcITv4KoXxTHZAD?=
 =?us-ascii?Q?tPi3Ou6rOLPo/6pPzGcwIGMfEAK6Oou73EjFLMDpJHU/Eh6iUOg6l1Ry46NK?=
 =?us-ascii?Q?XxMVNBuczDpWS2cvzs+uQSASsVZdKbdNvPQcaCVGd4hgjMGVyjmWGx3wYr1q?=
 =?us-ascii?Q?cUwkXmW88a+TVmLnOMv0bFGCLlf6UehZeWIeZ8N6UTCI0yMgh7lLYhsSxdHd?=
 =?us-ascii?Q?w360TxJvagPAfz6BhND29E9GxUadK3h17yP13tc/GMDSK1eE/kELf6bPjCQR?=
 =?us-ascii?Q?eW2AQHBO4pYiNoNimYTuJDvXTuZd1j5fh5XrQu1smIC+29z7MBxR1MSNhdjq?=
 =?us-ascii?Q?wmKO4dWoYx8JGc9cml0x7m1uYRnR7raP/2Z36ex/mwqNkxeJGMMCTjp+fIfy?=
 =?us-ascii?Q?jjneKxaz7fFVaeKeyti3ZtyD1lzsBr3y4xi5ndzZErTS/ondYtZfyhi8WIwp?=
 =?us-ascii?Q?hKugkUIe3V4ecZgVBePf4W6jRJjEKGR+gYA0755PTSCb5ft9DWlsn9frdPQw?=
 =?us-ascii?Q?+Ul2ad8IBTeETmgFwgm/TJPh2sbmHcFJ8bVGIF3hLUrlcFY1Z5XPfRllC4v/?=
 =?us-ascii?Q?jwVj2pbKg3b2F9pBbpn1Z2jHdFg4U685pzKBeUpcsoL5frggLXDhhXW6JmGG?=
 =?us-ascii?Q?nno/AinMeTTNFW597nyyC6nzqfnyH13mW4B7VoKr5zoKgHbIjFlk7JMDcFcc?=
 =?us-ascii?Q?xNOtgHh62X+HYqDvrMQ0uW1l6DpwSzPtdp/haqq7k1yUzDw5MUrMfF6KeQ6X?=
 =?us-ascii?Q?EXuBzkBoxJlQynRXkIbUwJY2H5hZSl0QhpeGHXw1soBNoebm2ddZia2BT1Ys?=
 =?us-ascii?Q?QDn1SbYICnsQEYZ38RoUX09QF2rhI36bo7CkXua3jyAcPTptERymkeUc5fiY?=
 =?us-ascii?Q?QODkdK6juZ2t16MzHm6fn6qEGMols6skgaG+HminfZmj7gVfy4jrD71XTlZH?=
 =?us-ascii?Q?Ss0CsmievusJ8XyaPZreXUOYBEd5NTeNUgnpKDqWvbWZpVssTxzYkZmYZGci?=
 =?us-ascii?Q?qmS/ye1Nekk303GqphRZ6SIvlOP9USFmJmGD42afYLS+sLnXhstxDpQiA/G1?=
 =?us-ascii?Q?3A4kyilgxMBLheHQFsFEltsfGpP7oROOnJPr3k2MdMD3SfHcUqeOigyKuZN0?=
 =?us-ascii?Q?efZH20YdMwcGVjBWCCHFiIRum1sCikzWKRFJhNx46LrIrXZcmoyQ+i+umyHY?=
 =?us-ascii?Q?OQgWjaAYr7s2xKa+tCqT91qeAZUxl29LfS5Ut+sLdc0MfpRdR0wbr/CSkCUb?=
 =?us-ascii?Q?436KksjhAwCXpVgydn34olzJgl472cXxsLp3vEV0vcPQN/7qbc12kJ9v2TzH?=
 =?us-ascii?Q?PSUO5ZWBl2AVjF7SRHASeAwB4LYURBXpNImW6qg3I7GMCF3yOjlY1JaqO+t/?=
 =?us-ascii?Q?HpcvMl0X+g=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 34baee54-7467-49e5-9c62-08dec65671c2
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jun 2026 18:39:31.2216
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 23nzwLhNddzLeMl/euDW2G4Y8gRs2MuGtN8OJlTwyUb7q4RLnQhMPf/pfg5Q1xyk
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CYXPR12MB9280
X-Rspamd-Queue-Id: DD86140013
X-Stat-Signature: wfekmrdwace3jwdhg4fhyr5h5fe8c8nh
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1781030377-782220
X-HE-Meta: U2FsdGVkX186jAaBp8JReOdlap2T4lnnd6TNYK+O2c2/wWlKfE0B3yzBVGgcKh6sPojV7Kj3rZcDt9eA++gTJ1prRw+iQ4eiMKppL+saz1iFdwFWzH8eyC5Idc5mPApFQzPiyBMWlvqRYmreX/r7p+DNBP9+V82SHjomrsmMKD8eWbz3aEcF0tdAP3Znze7CRsJTlBh02J9ggMTwBJbPtPEX4mjHhcewO45qPt8uL9eaVAAUKDrLHTMaitO95d6eZ0Umjiu4k+rkWvZGXkpPmyp60MfYFIdjm0+2WSFQ41Ahh5zd22wtVzSFCGtIeJGmuBAPSPtKiru133/Q6eeZ8rrWewfusGQWVD+zI5DkUEp4HPERZMrVEtAwIj1Me81kxs4dtzljDT9Q/oK0Yc++KK7+N4oo6fEjrcvAd7dJWdERPa9zpAEum2dcZHKT71sfLOcAvAoNt2mp/PQq+YDadkdPNdQxfQ4em6u0zASpn4tfFHcIGFP35FkruFJoypaNrZaPbUKx+5Cl5pnSNBM3n8vJmm9PJteSG0ZQL4zr7v5oAyuW1X0KpQiMZSvVhcpTTArbrcpoGAw5nYCrE1d+QrSDdOXM4Zpac/RYBFJb5W7dD2elfcJgQ3qcKXazQH1ZxDprQn4gRUU+D1t/QbJFeLNBXHBYOhIV5Zmrf77iqHlU5LR5FGweQDAAYMze4AV57P2/lxZxpU00bXjL6HbCwCut6diqYJWQUVPEWDGJNc/Qd+U09G2zjFrGoILmlzs3/V8DfbehccLhA8SFQqDeH2G9OIHkNOUE/BhMUna6l226N4q986ua5RkSXRGNGM4VJE4/RiZ7QTbepeFuRSA6xqL4kK383WMgurM0Mc0fbvfby+bjbq84a7SO0ftQu0jA528QuPI/33vQapCoGfMStS9mF5YcyB16MrQc0cCZStO4tkKJTcRMFC4cogh9soA4DV4ZZeV3Q9JnJSTibJb
 iYWEYVpr
 t6cdqhtL4x2PU35s4kKQ1d0KooPaB5vSIi3EAqitTCDLkPemfGBds5kE/EUtoTLa/vQP64XD1Ehtk1V9iTx+N4j4Vj8IOB2YM+0lC7DZ9xiDteWb9QPa8keOmxIfIRzdVu1XmwyE74SdBDHed642ebYfMwMNE3Iv33CZNB5Y6RVEwelxDITE2s6Bz+LKbxh2ukIfzSt6RWNGR0uUFpHZIsVD7i399sQVOK6KsJOJ3CJWy2mWrZsLjBKAlfkDVAk61rcPjARnyIZ3ISVGnsDK5uRHhQp+ObZ4C7BXkqXTyOt/KqgNcb1t+wrs+aiLWyLIBmERRT82Z39nz6fqQoDYyiff7s4cQAROHNiVkId9QYFAZrDWyLdBIWTKj2aP3K3xh2fqTus6bS8NlVk8qrdog7uQ5lpDJzr7auo5kk9tdRD/CtPM2vUaKwB9mfZmbtqotPUosyDLCedP9bOi7dcca97t+Kpiir6Y9UvVHahvSzWrr0Fz2yqPfF9tJeMyoDIS3FpEBTzpdoIU6PrY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9 Jun 2026, at 14:38, David Hildenbrand (Arm) wrote:

> On 6/9/26 20:10, Andrew Morton wrote:
>> On Tue, 9 Jun 2026 06:12:49 -0400 "Michael S. Tsirkin" <mst@redhat.com=
> wrote:
>>
>>> TestSetPageHWPoison() is called without zone->lock, so its atomic
>>> update to page->flags can race with non-atomic flag operations
>>> that run under zone->lock in the buddy allocator.
>>>
>>> In particular, __free_pages_prepare() does:
>>>
>>>     page->flags.f &=3D ~PAGE_FLAGS_CHECK_AT_PREP;
>>>
>>> This non-atomic read-modify-write, while correctly excluding
>>> __PG_HWPOISON from the mask, can still lose a concurrent
>>> TestSetPageHWPoison if the read happens before the poison bit
>>> is set and the write happens after.  Will only get worse if/when
>>> we add more non-atomic flag operations.
>>>
>>> Fix by acquiring zone->lock around TestSetPageHWPoison and
>>> around ClearPageHWPoison in the retry path.  This
>>> serializes with all buddy flag manipulation.  The cost is
>>> negligible: one lock/unlock in an extremely rare path
>>> (hardware memory errors).
>>>
>>> Note: SetPageHWPoison and TestClearPageHWPoison calls elsewhere
>>> in this file operate on pages already removed from the buddy
>>> allocator or on non-buddy pages (DAX, hugetlb), so they do not
>>> need zone->lock protection.
>>
>> Sashiko is saying this doesn't do anything "Because
>> __free_pages_prepare() executes entirely locklessly".  Did it goof?
>>
>> https://sashiko.dev/#/patchset/df06b66fe4ff8e925ee0714955abc2183a727b9=
0.1780998980.git.mst@redhat.com
>
> Battle of the bots: it's right.

Yep, __free_pages_prepare() changes the page flag without holding
zone->lock.

Best Regards,
Yan, Zi

