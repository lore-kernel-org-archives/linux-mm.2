Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 38F4CFD9E15
	for <linux-mm@archiver.kernel.org>; Thu, 26 Feb 2026 21:27:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 73B106B0153; Thu, 26 Feb 2026 16:27:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6F1F06B0170; Thu, 26 Feb 2026 16:27:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5C9746B0178; Thu, 26 Feb 2026 16:27:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 46F186B0153
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 16:27:32 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 05E2C57CED
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 21:27:32 +0000 (UTC)
X-FDA: 84487894344.22.91016EB
Received: from SN4PR2101CU001.outbound.protection.outlook.com (mail-southcentralusazon11012063.outbound.protection.outlook.com [40.93.195.63])
	by imf12.hostedemail.com (Postfix) with ESMTP id 2DE9B40004
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 21:27:28 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=QjqFaphG;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf12.hostedemail.com: domain of ziy@nvidia.com designates 40.93.195.63 as permitted sender) smtp.mailfrom=ziy@nvidia.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1772141249; a=rsa-sha256;
	cv=pass;
	b=mnBXO4aS6qUW/3pmmqB4PQIKJ3g4GFvpIRMDRtxORUWXmjSb+4ewGmlMvKtQo+eACFlO39
	eGREUD7veDXJV6wxyag0mPa1tLgp6APUzRtJSaYJJHcP2iKqljeEHkhSueSvGWnPv/MTNJ
	DnWq80LKk6HY8jFfsst7WV7WLf0kYSo=
ARC-Authentication-Results: i=2;
	imf12.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=QjqFaphG;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf12.hostedemail.com: domain of ziy@nvidia.com designates 40.93.195.63 as permitted sender) smtp.mailfrom=ziy@nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772141249;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4uKjc43mI572fFeDKQ8+KrzP3Jqy/FD/YnbIzRJv0Cg=;
	b=kKbU+O1+nfJBQcLpugwCyy61PuVRZ1qfdDhGF/TTtyunsD79SCQZSc1BrRJAiwbnzAnSdF
	y56hShUslIAMQOwSydSpfRRdt4iup8x2m0K5i7NpvMHGR9ai4uXoR0ih41IuXuo9kmZl+k
	qblhySqGHqhNmOhBGMDWsaLs1LsV3qw=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=KtRehIRVNQMmo2VSTtMSECH03NUtSZF1QMksdKqsSyhrCf9JWkxuRUZT8PxWHES54V4CywafjCthi95dkmvloflvwhQZZ3CtTPeBMqNAXwYvFFWa1/BbITaFAlOZHv856rzb8i3dllN2SEE7eAJS+oRiadpB00S5YAymB8CKGQIqtTV7t+tOJH1Pt4KRf+1b/iZNA3Saa4JJtUgDVKF21DgV5RW2zC4Iai0X9vvtitkl76d8gnS0PuSydVL3F78qRUNU4ILfsN/faiJxUuWnAtBkf7yRggAaErvusAK8oJ0piGXAiSZ6cWD/f/uUYroGGOB234HmoJDmNdpWWfSBAA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4uKjc43mI572fFeDKQ8+KrzP3Jqy/FD/YnbIzRJv0Cg=;
 b=e6WsXbsE1cPj8OtiHkxnXaSYMvBLuWysori40IQ8hQGKogRFwggPq90up/lTYpakKJvmpnBldXhZ1f1wkU+TFQPAklCJrC5JX7hbXmQOeeg3cHrUBNXhCkNuyKUNSkKARXiNqM34mKo7A2EtMtn9Rx8Kl1dw2Mfcfy8EortJXtE8YGDto2o52ZK7w1vJbLU2NEx7qORwAhhhHQY2yPAlXWTiwwgP/6Q/NT26xmP3iQ9tRzI5o8614FIoFaSKQh7MIGGrt1tZMco0zrplEg7XfJd+urN7tlDbF7SGLf3TFWbLzNlvvz0T4B9XN3pClfySrGLO68DJ3p1wSbk0wbogBg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4uKjc43mI572fFeDKQ8+KrzP3Jqy/FD/YnbIzRJv0Cg=;
 b=QjqFaphGLeaNX6Rq1NgArjRrYX76xO4iUF5+mumlvaSc9kuLw8JUYs4rtuc5WFNSQiHqqMCBa8jzqOEK7POzoTuQ51QfoEek5eHW/EYPa8kG5DIzobJduzI+DoLfpBmMPq1i5SC408MoRNUGJVlxCwtdILZ5yY3CsMtuKLvl8yaOaJYgtIav1HCph54SNK+TurvxvPpWSnp7HoW79cUJwa2JddNsuN/ZUuviOFKHXt0RppJ2ImKNxTb7S1Hwgqlc2cvZ1kOES9sd1Rvc4RR3WxsbYq2X9AWzQGOF4qlA1N1bdugQL30mwx/BGEv1bU3QeZAI4ej2AE1DM63ED9riKw==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 PH7PR12MB6860.namprd12.prod.outlook.com (2603:10b6:510:1b6::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9654.14; Thu, 26 Feb
 2026 21:27:21 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2%4]) with mapi id 15.20.9654.014; Thu, 26 Feb 2026
 21:27:21 +0000
From: Zi Yan <ziy@nvidia.com>
To: Tal Zussman <tz2294@columbia.edu>
Cc: David Howells <dhowells@redhat.com>,
 Marc Dionne <marc.dionne@auristor.com>, Jaegeuk Kim <jaegeuk@kernel.org>,
 Chao Yu <chao@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>,
 Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>,
 Baoquan He <bhe@redhat.com>, Barry Song <baohua@kernel.org>,
 Matthew Wilcox <willy@infradead.org>,
 Dan Williams <dan.j.williams@intel.com>, Jan Kara <jack@suse.cz>,
 Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>, "Theodore Ts'o" <tytso@mit.edu>,
 Andreas Dilger <adilger.kernel@dilger.ca>,
 Paulo Alcantara <pc@manguebit.org>, Trond Myklebust <trondmy@kernel.org>,
 Anna Schumaker <anna@kernel.org>, Mark Fasheh <mark@fasheh.com>,
 Joel Becker <jlbec@evilplan.org>, Joseph Qi <joseph.qi@linux.alibaba.com>,
 Steve French <sfrench@samba.org>, Ronnie Sahlberg <ronniesahlberg@gmail.com>,
 Shyam Prasad N <sprasad@microsoft.com>, Tom Talpey <tom@talpey.com>,
 Bharath SM <bharathsm@microsoft.com>,
 Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
 Maxime Ripard <mripard@kernel.org>, Thomas Zimmermann <tzimmermann@suse.de>,
 David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>,
 Jani Nikula <jani.nikula@linux.intel.com>,
 Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
 Rodrigo Vivi <rodrigo.vivi@intel.com>, Tvrtko Ursulin <tursulin@ursulin.net>,
 Chris Mason <clm@fb.com>, David Sterba <dsterba@suse.com>,
 Ilya Dryomov <idryomov@gmail.com>, Alex Markuze <amarkuze@redhat.com>,
 Viacheslav Dubeyko <slava@dubeyko.com>,
 Andreas Gruenbacher <agruenba@redhat.com>,
 Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>,
 Ryusuke Konishi <konishi.ryusuke@gmail.com>,
 "Darrick J. Wong" <djwong@kernel.org>, Chuck Lever <chuck.lever@oracle.com>,
 Jeff Layton <jlayton@kernel.org>, NeilBrown <neil@brown.name>,
 Olga Kornievskaia <okorniev@redhat.com>, Dai Ngo <Dai.Ngo@oracle.com>,
 Jason Gunthorpe <jgg@ziepe.ca>, John Hubbard <jhubbard@nvidia.com>,
 Peter Xu <peterx@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>, Jann Horn <jannh@google.com>,
 Pedro Falcato <pfalcato@suse.de>, Brendan Jackman <jackmanb@google.com>,
 Hugh Dickins <hughd@google.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>,
 Wei Xu <weixugc@google.com>, Qi Zheng <zhengqi.arch@bytedance.com>,
 linux-afs@lists.infradead.org, linux-kernel@vger.kernel.org,
 linux-f2fs-devel@lists.sourceforge.net, linux-mm@kvack.org,
 linux-fsdevel@vger.kernel.org, nvdimm@lists.linux.dev,
 linux-ext4@vger.kernel.org, netfs@lists.linux.dev, linux-nfs@vger.kernel.org,
 ocfs2-devel@lists.linux.dev, linux-cifs@vger.kernel.org,
 samba-technical@lists.samba.org, dri-devel@lists.freedesktop.org,
 intel-gfx@lists.freedesktop.org, linux-btrfs@vger.kernel.org,
 ceph-devel@vger.kernel.org, gfs2@lists.linux.dev,
 linux-nilfs@vger.kernel.org, linux-xfs@vger.kernel.org,
 cgroups@vger.kernel.org
Subject: Re: [PATCH v2 4/4] folio_batch: Rename PAGEVEC_SIZE to
 FOLIO_BATCH_SIZE
Date: Thu, 26 Feb 2026 16:27:08 -0500
X-Mailer: MailMate (2.0r6290)
Message-ID: <A890368F-2759-4D02-841F-CC758950B0D5@nvidia.com>
In-Reply-To: <20260225-pagevec_cleanup-v2-4-716868cc2d11@columbia.edu>
References: <20260225-pagevec_cleanup-v2-0-716868cc2d11@columbia.edu>
 <20260225-pagevec_cleanup-v2-4-716868cc2d11@columbia.edu>
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR05CA0163.namprd05.prod.outlook.com
 (2603:10b6:a03:339::18) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|PH7PR12MB6860:EE_
X-MS-Office365-Filtering-Correlation-Id: 95873c9e-8b3d-4029-5345-08de757dd352
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|366016|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	3yjkJPTWlW+QmhMYV6Z2bbt8fbXjxoudaa3396emOIRmvTiF+Wm+yDFKpkYh/4ibzBJOSjTRsd0m7oLmlpjdvWr5j7UfMrUCGz/Ct+v1eC8Dmg7NYYAr+4joZOuwyDbdDljEd4CMaa6Ocn4VKcptWM7Ub7ImmQDEhMguWevlJ2yffun+KRczqARPx51VIFQynFBLMFJ6KB3mt9qOzdYsMURxvedeia1HwZLrJEf87j+dUyivIF8DuNCSCq0etOtr4RpbQO4qeo/Qi/o4NPbYPGtbdYAAp1HioibYgZm/pX2y7+0qUYOGMMhre64tBHFEOSrexBscR3x2C4SDrtcPZhqDd+24fbIJIiDG+jucNGE1IUDjneoOXH0jZIKKekm2TccCk1OUj7OCLK102LlWQPBln/4BJjtDYwu9UTSKGp7MuCOGzyRxH8/iGDbSkoHFw4On+iV/qCp5hIkoXXIhE25cWT2l65pUYMV6q/g0AuXgHhO/53Fc0rcSUhLvOCeS1qjVuQ+kbQ+Cc+TejahNKq22e1koVJiu0LvwYBJp5f5dKgZoRp72Ohi346Pai/CIYGq05EC8PQukMj1f1AvqkgkOphAHEAYtXZgpLmjAvTtOhKOYUgHjbTElwL4qDlayfZlbVzcII5T5CPZ5hUUkmzMKc/ddzDZVZMFMEUps69iND5dNeK/UehwJdVB0xbc475LOxNsS9BeO2gQvo6X0iKSTUluYLj8PZsb6EgEHkoE=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?48Y5TV7dc2GZx0b1wplzMo/LoWtmFaZENzl6jygOekoEUi5IMuDeahxLNZ03?=
 =?us-ascii?Q?RjLr4IXFL+Tss7DnNSb+Pz9ZXZpQjyg9lhzdTrx8rF7Xe13rzgNzZlCT5RXo?=
 =?us-ascii?Q?+uaNYvq28NPZvSZLqyLyy74kNvq0KgvOWFuSyjICwgjaWHA4Mv+ruSTpXG+2?=
 =?us-ascii?Q?PbVzdq9ntdeMB2C+A3MLKZdjxxvjhyINzj5H3l7V4UYPWi1rlTTnFspIlwRt?=
 =?us-ascii?Q?Zv/8P6a+SrnC4DzFC7Q3NkA3BuzA1bTYLA3WiJtQ2/Pnp3vqCqSugOavNKf6?=
 =?us-ascii?Q?8ZtUfdUgVB22+0wIk2twF+Uc+YWQKtQw27lNCP//D+aBJKCKgSsvp8QG2RSr?=
 =?us-ascii?Q?hZQVrXUFWzrM7Ovz61U1YqZbj7JMrE/6zecKlbNiePiFV5qzsQqN1jLKhOlg?=
 =?us-ascii?Q?Giq/UHUEk61UWtpPouz54VmOgc+omOGcO0BB5TWcEcUODz8m9wKJ23S01efq?=
 =?us-ascii?Q?VTOjkRqjtqQ+gp5YQaEnSmtdPN0hkP/B6fvp+by69m/WeeLplFAc2SJRjau/?=
 =?us-ascii?Q?Qod7NLRQ5xV7bRWMyVNsIwul35nopG+3O/JlZXmTx11+P0wdQavzsHcOqOdk?=
 =?us-ascii?Q?zJP3RuwsTwYFHWS7+H0WX4UaLahRdOdr334vQL4GRCdUWlFDs9yiLeDHis/c?=
 =?us-ascii?Q?67ZGjcZ1yQpEdY5VTCk2s2VnMGktiDm+XqWNaOUvamWw+EiPDCkpzzwIC2QZ?=
 =?us-ascii?Q?w0jx91vAjVOM+oeE1fAT0CLSxAOWXQTabDPSWsKNDxO9gZJXS1RQ3ecMLzEA?=
 =?us-ascii?Q?zvO69fXifJCc1AKHeplb8WhO1Rrg25jyWgjC24Kga/xr5rIoBej2EWbdSSR+?=
 =?us-ascii?Q?Z97YPen68zbvXfn925nGnT9kJpwyOPoNEYfoXKi9Dkn3Zb3Y8NzsN7cTdIWC?=
 =?us-ascii?Q?qNwwUF1Fa/nrmwz/eV6JSyD3b0t5FLwRE3SxAp2z4wzRB6ZZxTXt264oiIY7?=
 =?us-ascii?Q?IIZbF21RF0mpqqFFSwEEIMSNsNCylBi5gkxgrmBSNG/PyZWvOZMv/xs1xT9S?=
 =?us-ascii?Q?lVp3ICxmDJZSvSnICuTnS5tBKGxp1sYv1kpYfbRkO76AVOlo22ea+4JxHOR7?=
 =?us-ascii?Q?JFqlzHs0s63F/UaI6xpaC5xDYEtkeQ4uT2ELE8fRKYzWkfkBC+U1oNSQVbW1?=
 =?us-ascii?Q?jznuTzCOWVUhYa92WWP13oMCrkfGwQ0ppo8HyKzni4Y7WRXORvkzQRNLlNMK?=
 =?us-ascii?Q?FyPouts0Y17ZuTuefOqYAJs9BSpZVkdVDlqzCl3+NqpO8ybYIze3T4fGgEjc?=
 =?us-ascii?Q?HoY8Morbxi2B6GhD9qhKQwkFBqXhE8yg8BjXGia32C7jG6XJWE3WiJg6Xv9e?=
 =?us-ascii?Q?mhLpSj6M+7nErYKdNp+WD//ixLhQrrdbbgtA/f3smsWszOHvIGSXKT3EZu9I?=
 =?us-ascii?Q?FyofC6cvQjxgMXQxWwt5P34Fn4mDIybbnRYdvMQBKRAU0ZI1nC1bVNIlOPjx?=
 =?us-ascii?Q?/npGHwZIS/YDEkLt+yv0fbkovhbSpuIj7tSSo7pEMhtdGMDN+9KAQRHlnTSw?=
 =?us-ascii?Q?d/ow0Le5B9zPI/OpCuLWtJYqH1ot36vQCvxImiDef6SP6yItRNTePLl0BZw+?=
 =?us-ascii?Q?oFOCmmJFiyFh9QWRa0nLigvThlIJoPJ+8CvTd2FmK7WE6OWvFIoksdYvNW9J?=
 =?us-ascii?Q?pDzEU9Llih8BBuRTADViD1znDJ2zK2VBakwjbkJd0OcUR6ZNtnQxfMSyNoU5?=
 =?us-ascii?Q?8Z6wYe36F80pY83pbqipF9Av97VmhU5qhhlGUA0QZClanPbi?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 95873c9e-8b3d-4029-5345-08de757dd352
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Feb 2026 21:27:21.1358
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: aduMoDd5lxnqMcBQuDO+PXo6/4koqjDzn/hs/w3f5Ey21lau5RgRDWDzNO4s2GJM
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB6860
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 2DE9B40004
X-Stat-Signature: a4webuagd7dt8gabasxzgys373sbt4b7
X-Rspam-User: 
X-HE-Tag: 1772141248-694504
X-HE-Meta: U2FsdGVkX19E5txtOWcQznZQGFGV3dctmij8TUD3hrzvowdQ9AsBUmEORTEOLklIJtJgAAtOuBdA44FK3U2lyuIe+tdUCixWyCQSkj2svAQ4NJ+u+dbprjejOYnP1SYi5BS3zu+gaYKbc/BYagsMn0TPwbOPh8wPhxcFG9jOKh4KUz8IZ6n5X4uCgTLAO2bLwwpA6OS9Pjdbmm20x/AMrvsXd7S85ACm/T5nvB0TT76Fn+2XdaXRnoYzYCz7HmENzPEgPLIxTTzN7UtjkEXnBfWYebYKZJab8b1sOCuLU6ooq3fIGwb2wOj2dI3PqTEfBMiCRhpzsXzWTiDV3AZRrcfFT01RWttz5r6UkxNx8bm+EKWfJRS8b8VKZb0BHCTEpB6jKN4PJ0PnlM6qquFfe6tTITLLl8q0kFVSs/xH1DWM/My96xh95oxS39rrTtfmz4qLpGf1mIzw1IoxbOOh0Hd8P/TtdG6QkNXLeCR6Ul3llrj94Obkav1+8wXLUq2sf0oSeDsOny76DSAY7AXhA8p6UiZkF+ToXQaze2pcSe2TxJZcmJ8MkCVeRpnZBENX08vtxHVZWSjDBOviSElfisJHq4xG5f1AquRN/5GDTSGKcGPUgrp0qxh04CBHBrVDE0ZHlDoniXreyP4BAdIJlqsTAe87iNUlPrg0oxU7i3wd6whxatv7WxqB0ngsWIabZoHrkTTfm664VW1ihWm+XAfYbgJ0DhYPYUaNPZWrxF8yCXXDEDB/2HcM0dwx3UmLwXvEbsB/RvOSesher1Gxp6itTBpJkVa/aXs3dOtWezvWxkyh2yks3rFQrvbRyBeR6bqPbEGDPWoaICfN4e47n93bSlmPNUzy5Ac3stVJQXO3ydWyGJBXBItgFW1+cULK7UWAwiVK9tWkXbfbKdRgZhqmkmyArx05CH24ADDf9sr23NuYIgyfXnyLi3jv944vz8bq5DH3roRvCnKWqgT
 lOQ6CpqG
 O91XoINKEPiH/0M6D20ID3XbHHYEO0lT+7pFuxfGB7TBHJVLx4mUpC82AsKxPVCno6yHlSwijPWXOPNjqILpmlsBMMDSor2quI2TvyytCLXaAb2x95zigFq8OdcCCKRBfCPbmk8n3CzH93TcgT5zKqnxpR2YiWYPKqXDuyg7hBoTb7SQUlKzuJGaMeuUJLflE+OY+XXLNe+25FK9iv7zCGVvwpFZHoMEpmQcU/lOVlFNK5y4PggBmhLcbrxXzJm+UgnQYL7yShjO9c6PPbggtmnZPWCBklgdvebMzn4f1+LO9PlX2ijrTnuZdVOVL1tuuHI4yTJ7A+eqew8kMTrTedcK2jcQzJ8RPUCSM0wx3biIZqSbFR1/HF3NF2sin+ewsy7i8hZ/c2sWNQsAQI/uWXt85qF/bfN79dbwVGrutVJFWhFvhSCnQnAj7jyzoJjgU6/BrOy92bmdZrR6hHenjg/qhaw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 25 Feb 2026, at 18:44, Tal Zussman wrote:

> struct pagevec no longer exists. Rename the macro appropriately.
>
> Signed-off-by: Tal Zussman <tz2294@columbia.edu>
> ---
>  fs/btrfs/extent_io.c        | 4 ++--
>  include/linux/folio_batch.h | 6 +++---
>  include/linux/folio_queue.h | 6 +++---
>  mm/shmem.c                  | 4 ++--
>  mm/swap.c                   | 2 +-
>  mm/swap_state.c             | 2 +-
>  mm/truncate.c               | 6 +++---
>  7 files changed, 15 insertions(+), 15 deletions(-)
>
Acked-by: Zi Yan <ziy@nvidia.com>

Best Regards,
Yan, Zi

