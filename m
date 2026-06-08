Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1729CCD8CA4
	for <linux-mm@archiver.kernel.org>; Mon,  8 Jun 2026 20:38:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 270866B008A; Mon,  8 Jun 2026 16:38:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 221956B008C; Mon,  8 Jun 2026 16:38:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0E97E6B0092; Mon,  8 Jun 2026 16:38:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id EF3EF6B008A
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 16:38:14 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 998501A0276
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 20:38:14 +0000 (UTC)
X-FDA: 84857907708.16.EB22540
Received: from BL2PR02CU003.outbound.protection.outlook.com (mail-eastusazon11011015.outbound.protection.outlook.com [52.101.52.15])
	by imf06.hostedemail.com (Postfix) with ESMTP id B2908180005
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 20:38:11 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=SxFOyEAm;
	spf=pass (imf06.hostedemail.com: domain of ziy@nvidia.com designates 52.101.52.15 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1780951091;
	b=WAEFdgr7ZYqefYhhVdjokITbcJz7VPDnye8AhrR4XOsVSdnK/LC2/k1Uii4FAP4/YMf2G7
	Qe3Su8wr4YzWRRjq5lwbLHMQY62CmgmiX5NS+RZMVFrpxMrPVxqdsNPD0Pt2eiqjRQgjqb
	H+NJxwfdmvZozsui6IxBHuS0s6+wEqw=
ARC-Authentication-Results: i=2;
	imf06.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=SxFOyEAm;
	spf=pass (imf06.hostedemail.com: domain of ziy@nvidia.com designates 52.101.52.15 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780951091;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=h8Zg8fwqD4WASbNQLxyDkNjEs/C17XeHrcqDBfVE+jk=;
	b=A7sTBvTjY5nkDRuAPl0QVh3XCTvoRB15BQzuPU1NiK9m/seGDBIkZergqLMLs8Uk5RdXCM
	2EXahHq5g4Kml4BKxj1Hrms6U8TtYDW2IhCpPOmjkkW+P146cD/Y7mEAu4Ala6fqU9lqv5
	CWgHBE99eebzycda9ZCWfkI9Mq2e40M=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=QOWIX9M1W+WOXBoC1WhZrXW6OD/GtBPlSBf/oZ+DqQc0ApgE2lZY/QVGvPnPH7yyuGAlHscTKmLCypp+Xc/Qg7BwQYx5Hc82muDNXhshpwD8PZ1Nvo+Jezv8xsdtpHcNIJ1m3H0gzeCfrOiWBpvD8m9VvyFVyFceXGoHwlCHZRw6PSAVKN2D1yWAfceVr/9A7WNM7AGHF3yX1HYTaqMT2J7taCgrrkPvpZMooM8QRgQu2zZf44Xc8N8vFOairCmFSGnEwBvMOrAy5kap5Ll6htmjEgInnyOfQ+/80nWrUzTAfcW5XrAfUIBx55+Gxo+5xIM3fnREpYxf8pg+w0DccQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=h8Zg8fwqD4WASbNQLxyDkNjEs/C17XeHrcqDBfVE+jk=;
 b=eJtyhGBV/n2pbygvuheaVjNiPYI+ZG5cV5taLgNoC3D+iHQlf26yXjvDHI8HINQL99VRZGcyNid7HRPW9Eqhp8Nj55fqJ4TfkiJP6qhS/gbggxNreEbmaKCI2deqHt/6wsJ3NcMkau0igr8lk7FHCRap8ObHRXfehsDFZ9M8MwHgWfQmKlvTI/7d1wA9xe+3C+LEYHKRD7UaZSELitW4WzFIk3vBitO/3EnP0PCf0wP5FYFUp5M66Y2KGc1xmY2VJbCCIa70K+rvq0z0iiF05jDnvzpN9AMT8Lk0yhduEgwzv5nhurKnHA7PkPz6BPrLj+qtBNIp/Ane3z1mD1Y7BA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=h8Zg8fwqD4WASbNQLxyDkNjEs/C17XeHrcqDBfVE+jk=;
 b=SxFOyEAmeHN274+bUvPdGrleJI/qtPFyO6XbHFIrFp7BBUfYKuA1CgJ6rQcV20LEMHqdNGhB4/Iehpk/+DtZHHmcayIlJvBFc0U5ZdqNwPFW3ehOFp1eGjl/0A1zy3hvc/vNe6HgjS/FN78yjxl7AImvwY9wc+7SwQZyBYdp92XiER83gCVfOPj9O+00amjYGnk3GBVkjJY3FKPEsR1YlNNPN9RRt5e0PHToSmTIPGMLwkUP2ItFBfT24NFaThH+yLvNRV8HDrqoc4Er7UhwquQUAb7+gu0AvT9//ihRfdYEXsAMb5FuZ7B6cuUP9iFiO6qMJNm0ZjF00/uCwy0dgg==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 PH8PR12MB7325.namprd12.prod.outlook.com (2603:10b6:510:217::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.92.12; Mon, 8 Jun 2026
 20:38:04 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2%5]) with mapi id 15.21.0092.011; Mon, 8 Jun 2026
 20:38:03 +0000
From: Zi Yan <ziy@nvidia.com>
To: Gregory Price <gourry@gourry.net>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>,
 Lorenzo Stoakes <ljs@kernel.org>, "Michael S. Tsirkin" <mst@redhat.com>,
 linux-kernel@vger.kernel.org, Jason Wang <jasowang@redhat.com>,
 Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
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
Date: Mon, 08 Jun 2026 16:37:59 -0400
X-Mailer: MailMate (2.0r6290)
Message-ID: <D754DEDB-3A3A-4F6E-BF64-79086F0A6467@nvidia.com>
In-Reply-To: <aiclJGgB07L3rV-P@gourry-fedora-PF4VCD3F>
References: <cover.1780906288.git.mst@redhat.com>
 <50d410b47fe3f45327783e05bd306d5eaab75e65.1780906288.git.mst@redhat.com>
 <aiaUDTeHDA45ZXFS@lucifer> <64f2e580-aa82-4849-9236-b8ec4208ca24@kernel.org>
 <AEB19464-20A9-4C5B-97B8-681CCDD81031@nvidia.com>
 <2475e4c4-9ba3-4091-9bfd-1c1c15163da7@kernel.org>
 <aicbZ9lewv1wJqqS@gourry-fedora-PF4VCD3F>
 <8BB8D6E5-8644-4CBC-BAF1-0AA19702E042@nvidia.com>
 <aiclJGgB07L3rV-P@gourry-fedora-PF4VCD3F>
Content-Type: text/plain
X-ClientProxiedBy: BN9PR03CA0265.namprd03.prod.outlook.com
 (2603:10b6:408:ff::30) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|PH8PR12MB7325:EE_
X-MS-Office365-Filtering-Correlation-Id: 0b63a1b0-7fa6-493f-e9c6-08dec59dd6c7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|7416014|366016|6133799003|22082099003|18002099003|56012099006|11063799006|4143699003;
X-Microsoft-Antispam-Message-Info:
	gmgBlJbfvdfSHWR1cwRaq7jDyV0CAk2vcoE1hSvOydLuU7BhqpdCT8qG/htGC+8884FOYj/vlkhMiFWq4xzQQs1qiQgqKOdcE8ZKB6rcCr+NjsPpfxROxECUp42CBfXqRwDEcOon4FvdZnTLMA4Q8FsZKLkXQAXdJMl+Tt7xqiTKAoSzctG4OeA2OvzZsTqg083usZdBfs7VxW71ryJP0HmURhIOOdurLT+lJWOM/Rh2cRIQMQfjUbyvvvMAYIZcFEELHdDrML7r2cwKAaXAgiVsICSZBBsP1SjmVYWH64JWt4pdQHoRVewPYPSZxNaMgbYZ/mu89NufL81qNyro+fq51zaj+R5FGaqEyur40PeuasV7MwaTdOpnJYS/N7DhRLzozUgC5b9s/BNPBJOKZreRHUI/guHixWtGSvxe/XqTDfaMvujK6fCwf8MYeIEMFTSgxov6Dp2Y4Ifs7MlZiRW9SUt/bhinxily5ad0KagfxqPzV1Dj/iVcRJg5nC6SsjYtdtHP+uermahojphUhjKHx3JNTWidwuLw5Ph/f7cLxEbdDZQDwgsn/XKg5bs5rmDcBW1xVZ1LI+MJsDSVtQofud7UZi2M1yxbqeFOtQHTuRF0FJvH2/ut74kfPnCFDVrOS5bA+8ze29FqVtVvjoW8yoyeI9vn+ua1D4tT9hvzfkvYnAhzo+ozPOfUMBaT
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016)(6133799003)(22082099003)(18002099003)(56012099006)(11063799006)(4143699003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?bn4NuTsShjCE0OJsXtfr2sNLIiVBKYw+UTTJs1n535UuS+O091wVv3v0R3ru?=
 =?us-ascii?Q?+YaHPcI7wKFRskH+xDOhv24wQOcYLSogI7LRjH9mRmXMpRPgFBLSOYM+PmEW?=
 =?us-ascii?Q?JXBRVsbq9ODAmSfQ6Xp3pF0nNBQEII30i3WolvMeuro0lHtcW+RbGbHO6VzC?=
 =?us-ascii?Q?s76RzvZaiCtWQtp7P5vGhNkC5qIQ3Jgy0FsZtvUwRAZCsKqqUwd8tpqBtfnI?=
 =?us-ascii?Q?VruNCvEiqgiBw8nUezge8W285kbJuoaa0pT2KxC77kGn/95EZw/coxE8zfW3?=
 =?us-ascii?Q?ypU+BSy9gum+Qai6cTdPjRTV6KVCp46DUH0saxGv/Ab/JnLQRdRUasjEh3pD?=
 =?us-ascii?Q?nop072Pe0Pn4TiL0qATIwxWgSwauuO2/TWmLa2g3NekdVQvcZ4Z8wiqbJ1kO?=
 =?us-ascii?Q?tQn5US0ioCLOTsi762LpIhDroQwv1wqG39GeWu8+1plG5IHBpd2hfUiXpZoG?=
 =?us-ascii?Q?Zxbts89fLsOkiEJxmVZx++enmpFssgqPNyOHo8+YfCCalMoFUF7RkJkhef/C?=
 =?us-ascii?Q?giqga5y8R6n5I0DWFF676pzF8H5Tm1hRsVl9OxCrEqQ+5RJeZLXBF0NHnahD?=
 =?us-ascii?Q?xjZA+oDSqc76ijd/37FUBMRRxcZR1KnUmgIoTJfYTBm87rjc6bYcfZOg+Osn?=
 =?us-ascii?Q?Xf/MNHSiQv46xN89FJ+hazmUob5qrZjcgjdU0AR1yM2CExOps9jljrQjFgIX?=
 =?us-ascii?Q?zC1srxStuG8+9vONo01Ov0+0aCSc5ssS1lCMU1AqrpFEUsAWXJmewRJw0yCD?=
 =?us-ascii?Q?CVu5qhMwZS0W9ku6W2pS5SYwe/zN+IiSLnq0AyQKo1+mUC00N15sDyeMN3HF?=
 =?us-ascii?Q?q+2SXqM0kq+b+kK+Y+QfIupwhvw7d290dWHFbyxPyKX+tGSHdQlRBzt/PBwn?=
 =?us-ascii?Q?AF7JmsPri7T5kBT5RaXvYvMo+0DlYZGYf5u36eBHWz5ZxvE0ZL1uga8WG91o?=
 =?us-ascii?Q?wvSCK41Hv0jpyF24FqgOlfnqpw3ja1neM+kkg06fDw63xcfiiqtx8qQunFl1?=
 =?us-ascii?Q?CeXgxCra2PCyFINDpqcJnrar+ihaEm8Co/WVyTRGVuaHYwy2RM9kUnjv/DLa?=
 =?us-ascii?Q?/tC0g6hGQnJwkbskRH3eWpx5l4LC5i2yYtCcXSdyeAgeMg1vP5AfwHQ9WgMc?=
 =?us-ascii?Q?mb2dz6CSjTeHO5pSSX2Z0f9mEorOKLpWnVXUwhtA6ju4svwzd7E30CYHSFW/?=
 =?us-ascii?Q?lgxHCrYTnDJeGxjralvDTos+i4tPiVS6CNlGej0Jv/1aB4GliN2BuIqcsY4G?=
 =?us-ascii?Q?wth3JD0dmvOOAqreHzuxAcLATmColSg1qYXRsC4SCmW3zERQvjR19pUWlzRf?=
 =?us-ascii?Q?T/ydGP7I+kmO7WOu3PHC3DqAEM/wd60MGv6XO/0GO6yuCcJ2Ol5B+E36uCny?=
 =?us-ascii?Q?7SrV56i0WJ0MZhZZliB/6nPCTcHl6WriPtG9IPfXN8Pc1k2OKqQFihP3pEIz?=
 =?us-ascii?Q?hjOgjYJesCq8WR0/xUDpr4pCMvE5gnlhlpqja2uftiNFZVYkanmBFZqbyyAO?=
 =?us-ascii?Q?wJAVLCq5iyldbAsCa6neLHxsfcC8YfBv7uHnP/aGCowYlL9U+3zzcVONo6Tr?=
 =?us-ascii?Q?VQS+o/8wroGMu5XFXIOXY1O78EN3KD0wzIBQFdWCTT4arMPoNIJMfXzfq6rm?=
 =?us-ascii?Q?ZuyNyMXvnhtolQ8deuxqYelW+MDdGVp73fuIq4p+0TKSlsHTvX7rbiWOisWo?=
 =?us-ascii?Q?E6QtkHLDdQY8ASZtz6D0Xt5cEGY8PI+hqkR8Io8BJD4sLH2Y?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0b63a1b0-7fa6-493f-e9c6-08dec59dd6c7
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jun 2026 20:38:03.8346
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: iFZrue5zdqPY1S18r5qZ3eErpXhMVnAah1qRGsAGC3du0d0OEq+mokbp24ArCuEd
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB7325
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: B2908180005
X-Rspam-User: 
X-Stat-Signature: cwyqniik9gfjx7m1e5messif6t3fdy7e
X-HE-Tag: 1780951091-32213
X-HE-Meta: U2FsdGVkX1/YcGMjx2MkDQ1fNUdvTBPQ8fz9bCV76oKu95/X64YTXJTAx0LPzIsavu4PVYQpIPPZZC/PV9VW+qWvzz3S+zKjm3Sd9Bu+ZtaZ85pxBpdXXQDF+aJ1IdV/f6K+ivuY5DWh3WSgItpOO4MDerwT2NpEP246oaBZxxDQzICXtzZTBseJezIL04fReABwd6zY3AGz0eM5HIdW9A49w58ZlXZZEHr6D35MBEJ/MNE84ON3gzYFMFohfC8MoEnBsmtb+B4bHdkgZc3+YlLm6EEF0huSAoFRmXcYC4eeWGGRvS42e0y4Ud/RG6Tobv37AkYIb0A1e3NLqtJJMIGzlqY+6GWsuM5V5An27DRKYbW9piLTzWq3k82AcX0V8P8vTit6FRwXA37wTB3dr3Pzn5hBsbPHQ63+yBfbRjgIqspwZR7zv+Y2k8+DwAH30hntaV6AIVARTDDjoo3TvGjMhGuVFphixKwGb+xKuSBMejcMiSORZYifiOT3F2kh3i0ezLtnHRrGKtzkBKJrlvze92VNN4kCEcwaQKE0x/r39mj4aM7msJQol/gbUPZxtQYS+eMHBv89KcnyATIQuXYu08NqvD0G5XFmxpchaNWjpxfCvfwfQBCT0Mvu9TnzT3BhEYrxHe7Is/yjeAMdXwyxpNcfiLZCnsa3MJsqXaVoRs0ktY/LNwn311JuDcLfmbZtg/oKHkG/ucdrZEXwYYyqi7+doZklwSXOXbAYiQKmdDQ84gmo414JmSURVarO1fC/UcqdlazNE1ocGRPboZt6Weavdz2ctK0o6Ueb58gSoevYALDHSf+dRvwZX1ZW8NEaohwYsqs0wvjyGPmuo4uM2bz9u8WkYhZmu1Cz6p38IGzIZbY/O6Lsd0buTQHuFBqAECb3R8mcdCKkzETzgD2tJ4HTOAUpSh5Sm1UoCdjQHmq9/3Xx4DTiNoGIL/b67dyuUj3n6/ia+S4j9/A
 OMS7KUga
 XVvZiJeWSolFDg5v/5QAmYAhWrJIFuAXm38iOMlDk6E8EUwPwzAJ7ID5j3yXUZKvQK6rc3VCz3HNaP1ZHjvUdGosCZSX/6eiZMqfyDij1l8bI8juylgdzSdRen0ENaq3jEmP+SeSDEMccbtNDi+JUvDIsozXwDpEXw0ELv8j+2xMXqRgeTWf7LpyjpRU4Uwchoe6AGam/ParYBYl+1XWgf1LQkDlehPucQ9n/2v13zCFySZyOZEfyKSZLX8y7cXIzxiuix8ApkvS/Icel8chkiaM9zk/A2VVknbRcHj/JMSGBg2EFS/fcFDvSayIQtQwqthIFxsOKaWImVHk6SlA/wSf3c0I3nGq/zKeYZZxzG7Q2XS+k8RzifPDusDCGqJnozEIPNHflDJo7slX4CzzTZN4VDCC8pQu0u1IfeNYWf20Fm2X1LAr3soTR2YchbrI4eZAjTi4L9U7aLDjbKTIe66lcFxrxZIw1VwTtCtoMnXcimvo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8 Jun 2026, at 16:25, Gregory Price wrote:

> On Mon, Jun 08, 2026 at 03:52:20PM -0400, Zi Yan wrote:
>> On 8 Jun 2026, at 15:43, Gregory Price wrote:
>>
>>> On Mon, Jun 08, 2026 at 08:39:10PM +0200, David Hildenbrand (Arm) wrote:
>>>> On 6/8/26 17:27, Zi Yan wrote:
>>>>> On 8 Jun 2026, at 7:08, David Hildenbrand (Arm) wrote:
>>>>>
>>>>> Or should we defer zeroing after a page is returned from allocator? So that
>>>>> user_addr does not need to be passed through irrelevant allocation APIs.
>>>>> Something like:
>>>>>
>>>>> alloc_page_wrapper(gfp, order, user_addr)
>>>>> {
>>>>> 	page = alloc_pages();
>>>>> 	if (gfp & __GFP_ZERO)
>>>>> 		clear_page(page);
>>>>> }
>>>>>
>>>>
>>>> Not really sure what's best here. I think we'd want to limit the lifting to some
>>>> internal API, so it cannot easily be messed up by random kernel code calling
>>>> into the wrong API and not getting pages cleared.
>>>>
>>>
>>> We're a bit in circles on this.  We discussed explicit interfaces a few
>>> months back and the trade off was:
>>>
>>> a) add user_addr to the existing API and cause churn
>>>
>>> or
>>>
>>> b) add special interface like above
>>>    increase the buddy surface
>>>    leaves open the ability for users to get it wrong easily
>>>
>>> If we forget VMs for a moment and break this step out separately, the
>>> core question is whether page_alloc.c is the right place to be calling
>>> the folio_user_zero() or whatever it is.
>>
>> page_alloc.c calling folio_user_zero() is fine, but my question is
>> whether we should do the zeroing inside post_alloc_hook(), part of
>> allocation.
>>
>> What I propose is to lift __GFP_ZERO up as much as possible,
>> so that most of allocation code does not need to care about it.
>> We do the zeroing right before the page is returned to callers.
>>
>
> essentially we end up with something like
>
> alloc_frozen_...(..., gfp)
> {
>   folio = whatever(..., gfp);
>   if (gfp & __GFP_ZERO)
>     folio_zero(folio, -1); /* don't do cache flush part */
> }
>
> alloc_frozen_user_...(..., gfp, user_addr)
> {
>   folio = whatever(..., gfp);
>   if (gfp & __GFP_ZERO)
>     folio_zero(folio, user_addr); /* do cache flush part */
> }
>
> The downside of this is obvious: it's easy for developers to get this
> wrong and call the non-user interface for user-bound allocations and
> miss the cache flush (that is only needed on some archs).
>
> Not saying that's a deal breaker, but it's something to chew on.

I agree that misuse can cause trouble. But if we do the churn approach,
what prevents developer from doing alloc_frozen(..., user_addr = -1)
and using the returned page for userspace? It is possible the allocated
page can be exported to userspace later.

BTW, that cache flush thing is fragile even today, you probably can
do alloc_page() + vm_insert() to get a page without doing proper flush
and export it to userspace. There seems to be no mechanism to
prevent that.

Best Regards,
Yan, Zi

