Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 45C6AEA7941
	for <linux-mm@archiver.kernel.org>; Wed,  4 Feb 2026 18:30:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7E4F56B0089; Wed,  4 Feb 2026 13:30:03 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 79C016B0092; Wed,  4 Feb 2026 13:30:03 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 69AA86B0093; Wed,  4 Feb 2026 13:30:03 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 574796B0089
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 13:30:03 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 051781C088
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 18:30:03 +0000 (UTC)
X-FDA: 84407613486.01.287756F
Received: from SN4PR2101CU001.outbound.protection.outlook.com (mail-southcentralusazon11012002.outbound.protection.outlook.com [40.93.195.2])
	by imf12.hostedemail.com (Postfix) with ESMTP id 276994000D
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 18:29:59 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=WOqBwoSX;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf12.hostedemail.com: domain of ziy@nvidia.com designates 40.93.195.2 as permitted sender) smtp.mailfrom=ziy@nvidia.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1770229800; a=rsa-sha256;
	cv=pass;
	b=HhUGJK8ZY9lVegRv2ch6tA6uoElsan7aG09MVpItlRzbvyq7FoSqDn0hlHapb1/7372Md/
	HgqJPzmjHEWQcutLVqaYhUu51O+5FjU8h9IAMFyCepAefHzPA9yfHUpvIxWmzeCurLOKGE
	+A8UsKSAOMQJ0XmmdZEBU7kA4SiFUdY=
ARC-Authentication-Results: i=2;
	imf12.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=WOqBwoSX;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf12.hostedemail.com: domain of ziy@nvidia.com designates 40.93.195.2 as permitted sender) smtp.mailfrom=ziy@nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770229800;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7noREwzUhqdue3DRo0+G9ddaGzsZ9AHeNgAdBokqZXg=;
	b=rHtRHrejWqxVJXsA8d6y2OgEC7kcNXY3bMWH0Na4TLTQK2RYHfbAZR5TM+7NY9JSZFzVQW
	1XTG6HGx1VPnf7xpAqYX6hOTKaDB6CCh4hIwGLNxGPjTN8I5qpRJCjU5Fg2U2nHmJN2M71
	dCRTVi1VKzyxNjZYP3YdmRR9nZ3sZcA=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=er9P/6yl73bzxOsUM0SbqtmMfHHw7j73v641fa6ujDPrhGGAKwSlg/VX7+xmRUWrTCODKTIK2sN9owL/m7TYMoXb1mL2URYpcTQql9/YMPUksFR9RQuTCk+PAdsmQHFOMbCPFowC8NKliZimiPyJk8gohnYjxPmArjq8XDon4D/6fc5Kz7n6lx68op+UNPHU26iAjT84xhFBX7onPJ9XKjSfbEF7b5bJ9Ri/ubm3yO3upNgMauI9OLeoUI5tHcvxIR9VBjlGOrxBpT5fHnplfadUUsPmvw0PKHjekoI+pPsH4X6H9Caizfb5c5JeYipw0b8+1W1HuHPiQkLdrKIMmQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7noREwzUhqdue3DRo0+G9ddaGzsZ9AHeNgAdBokqZXg=;
 b=w1flGF3PhuNo272u+nPW3LKcusDqJJt5HX/tNr0KBgaXsZThjYabBefCfRJZUsuo+B07MQLiBV9yLu7teSvTo9UR92hY93app3lnqwlryyTkCX8EtiQkCmZDlZYHM1erhJUkQLvtKovHrZy2kaQrP3YM0D4hzSRHIINwjBo/5E4WNHTnpjvallEVuUB0Kt2FS8ftdoxMVRsQVviG1un6d80IYUWnM56MQx/kve+u2izSrUSDC5VmujH4WUaB1+LjKU1oXoEcwptPfVQln9zCsadVVZe0yDu0KB0nPnK6nFuLsrgEoO2MU6fs5X2gnT60ZzvZMUEqFBUlds2jLQuekQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7noREwzUhqdue3DRo0+G9ddaGzsZ9AHeNgAdBokqZXg=;
 b=WOqBwoSXqgPeNQaLcELVbHEnWQ7Uo4zga9aSa6EAZ/3Hq7logHKTLdECxSzfhpd1lhL7Kjgm6yvfWMbTL9pT/eEbKVkPoMyxkl2SOZJhW0PsbjCqwD9NZ4lKpwS/EWyW9oqot+++jk9Cz/FXrLyaYvg2z2EXImgJPlS7cjgxemcoX8ON6b9lgd7XV5P2o2FVcunMgmScIubyuowSFPU1LCGe5XgbUx/SWkGSEQ4EDbcZqwCxPdUQn97q/HcCCvdVLz+DfSAfafH710HmxQhXvioDgbvjU9FD299vKYjDM2nzd7GEIExCTsDVCQXNIvkbGpU9+G/+gU4USjO61KAPGQ==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 DS0PR12MB7947.namprd12.prod.outlook.com (2603:10b6:8:150::17) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9587.12; Wed, 4 Feb 2026 18:29:52 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2%4]) with mapi id 15.20.9587.013; Wed, 4 Feb 2026
 18:29:52 +0000
From: Zi Yan <ziy@nvidia.com>
To: Balbir Singh <balbirs@nvidia.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>, David Hildenbrand <david@kernel.org>,
 Matthew Wilcox <willy@infradead.org>, Alistair Popple <apopple@nvidia.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Jens Axboe <axboe@kernel.dk>, Baolin Wang <baolin.wang@linux.alibaba.com>,
 Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
 Lance Yang <lance.yang@linux.dev>, Muchun Song <muchun.song@linux.dev>,
 Oscar Salvador <osalvador@suse.de>, Brendan Jackman <jackmanb@google.com>,
 Johannes Weiner <hannes@cmpxchg.org>, <linux-mm@kvack.org>,
 <linux-kernel@vger.kernel.org>, <io-uring@vger.kernel.org>
Subject: Re: [RFC PATCH 0/5] Separate compound page from folio
Date: Wed, 04 Feb 2026 13:29:45 -0500
X-Mailer: MailMate (2.0r6290)
Message-ID: <33B161E0-5468-4A31-A5BC-B4F1FCE72CEC@nvidia.com>
In-Reply-To: <2EF8F5BB-7CEB-431C-B9CB-00B1E3E44E1E@nvidia.com>
References: <20260130034818.472804-1-ziy@nvidia.com>
 <70e06ac9-5cbb-4616-b20c-33f5bc1601e6@nvidia.com>
 <2EF8F5BB-7CEB-431C-B9CB-00B1E3E44E1E@nvidia.com>
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: BYAPR11CA0097.namprd11.prod.outlook.com
 (2603:10b6:a03:f4::38) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|DS0PR12MB7947:EE_
X-MS-Office365-Filtering-Correlation-Id: eb8ac312-0b16-4328-1b90-08de641b632f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?ZrXShWX53mFNb8TQMmq+fZBLPhwjeZW8meLnXAUrMJARevqYv0uS/61MdFjL?=
 =?us-ascii?Q?GIaBXv8rURNiH3thXwF1lRaCCs3xzSp69wY+8TOI5L2yiqPcfYa32fMrYS01?=
 =?us-ascii?Q?XgCEDVtRsCmRS/9NETE7+g9gBwr9SubIXE77LpLZP+6Bfbh6tv8wvmbFG2Dx?=
 =?us-ascii?Q?pZc8sciwaN8U5pbWykC3qQ1t8WxMR1PXlXtroItP+MTbLgQnbk97zK5eLd+E?=
 =?us-ascii?Q?UCb6nJeCDLHEAOoXhMM9vgvmlVnyTiUZZlWruaHnS4xO4CMv+/Sy3bkjcPdt?=
 =?us-ascii?Q?LK+R4kaIZzfY0AEHuEUlqTy/Yf1rMp3DY1SMu+HzFx1KaUJBjR5r5eQaPJVi?=
 =?us-ascii?Q?jJtdB7GeJ7aqqIZmvadfH7pN7P7Xa5PcQO8y6Hq3AvplCY6H7wFbbI7KgQno?=
 =?us-ascii?Q?8FINCwzfN68zZ1H8x1zrXXQJqpR49cmZ7/ISPP/VPXsCHZdSWC3WnDhuK74s?=
 =?us-ascii?Q?A6zQY51L5idtZ67eXWlF+RNxekIZtbP/3fam4KzG9n1/79X7Lo5HNw28XU3r?=
 =?us-ascii?Q?MFBh36xvOGp0eV5HQ3ipVuvslmkoqpsvNw/mKd7lKsQyBokc+bZzcff5Rpku?=
 =?us-ascii?Q?eLHzhBsy3Kdy2IwI0oMRIdaV2TK3sogaPuYdmzQRyK+pEsWuTnjwe7DuQHFe?=
 =?us-ascii?Q?1kX51DXaptiDJKI9GfaMZVq9jO3WW3ejzBCqZUjeOelD9qfQMNA8TWWFnBZT?=
 =?us-ascii?Q?P0vp7+xWFiidE5KGa75i+BC+d3nQ8YxaNsHdVyrKSQWFSHtIWR0JjSwQda3c?=
 =?us-ascii?Q?bLZlyfWYE579iN9xRXlyD88ekRKebOZWJbJebPnpui5WNNten+yRxkOT5Ir4?=
 =?us-ascii?Q?gLgS1l6GNRdshpiGDwxJA9q4usmlYKj6XxoQ9aH8bqh9k+7lor+3EToBJ5ih?=
 =?us-ascii?Q?ig0q8CP945GfTnGtFMzIbPhcWbRzINQKCye5bcwp4xBJRxHcxOkWVD/WCK7/?=
 =?us-ascii?Q?o+fsvCtvGL5lsdPJk0KUx26SD0EbJoWiGfwPd119udH85GQPnIhx2eCD9MiJ?=
 =?us-ascii?Q?uNpCYgNvO1OjaIQaYSVQjFSHrRqehnB4PTw3zzxwuUNNBMb+Cyjk+CKfkGzC?=
 =?us-ascii?Q?LYTl32k7J4BdncNkHHcq6p9ExSKYjXe/hv6u3RhPe/mbUMBh3faPHOm895Qt?=
 =?us-ascii?Q?YRV/YCMFYZcjRfDpSb5u/71TkdjZLejIROwduDUA+FQZa1lYaJfV7X1IoDeN?=
 =?us-ascii?Q?MaW5u3pjg730nLj9zj6KDIufAE+jnZDf3JfwD8sUcPE2wVQ7aFmWTXFv+tuO?=
 =?us-ascii?Q?ukAiedF9hyVWS66Qd2v+BXEweKOKUXQKSZ/h2dH/6VBjjHsumzl7e2GmbiRS?=
 =?us-ascii?Q?gTy8WplxnuKls+YE7xLVyRfUOReUzbzNKPxSPxUMlmpWiMRPZYgRy0ZI2F3h?=
 =?us-ascii?Q?vt2bSZN3qWq6WExs0cw5MhD8kM/7oPmm64+Eof1G6AdvuJ9zyBrV7V8rbBok?=
 =?us-ascii?Q?KDB1INuxcGenzAWwITKb6Eu0YBwVofSAUcSjkBpImXdUDe0MO79mjqFXl1Ht?=
 =?us-ascii?Q?UL3Dk25myKV6yF4ESOQEOK3pOKY+Jpgf2Cpy9MUsKfJJ6QBmhlcOKerrQTEc?=
 =?us-ascii?Q?Din/ojpYDALy8K1zxzQ=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?JfY6FfLgO4xSowBUk3Rqc2llstXGlqPiYg7UNL/CA4em12F2+IZ9z4pr939e?=
 =?us-ascii?Q?Pu06Fy9qLcE0B9nEJKAjarCU4VjmHDRWIDA0Vf4HnRQ5+/uvKLAwZY+PG/cQ?=
 =?us-ascii?Q?cwk5RJmeTaQVDqlsqeI87tBMNtuyWyVx72P6lWw4rc8QhlVLt57cjPJfDl2L?=
 =?us-ascii?Q?XgkxLyF8Z5LI+Ju/BuQVk05F9lkXjT7hcCTSrx2NmzKd1/Ym+OG2VqVSFOX0?=
 =?us-ascii?Q?1iluSTu2fios5Ka89/EA6wo8CUZUpJVxj/lFMv/ATP9/+5ZMn9wR0E48TRjA?=
 =?us-ascii?Q?tGhCmrm1An/JNJJG2ZRZRT9Itmlf9YUGR7stG8WpGkrpewptVuTFniwFrNlw?=
 =?us-ascii?Q?7h+36wdY1klqE+iUwCNlygJid3YBgSjWW8R91+bHxGCn6zt75vDjAn3ZXxSt?=
 =?us-ascii?Q?sAWAlXjNhkItXRyFvBZJt+AAxuKmMuUv1ez1Ck2AVSCZy9aojOwQEUs5yx19?=
 =?us-ascii?Q?VGhWE+Jz7yWOTNOY1s8NIHZh6fLpTzxBV2d5mQXYivcDpXPtxHaiJf2gHhIe?=
 =?us-ascii?Q?lzEDvaMbO94NhVIHrFPrp1HjjaFr7jpYWmXFEplm7cpzNqn5mFWmRElWiz+l?=
 =?us-ascii?Q?W6n2UfNU0ZCWwrGDUnSZBuXIKTG78vw2nKnt88F6zCCFXPYpI+8gd0VDbeE1?=
 =?us-ascii?Q?HIC7i/pVH+76GVh9QsDLhYa6BKTvhw0YWVNEzv9bzjrP0w2FVORmkG0HbOL9?=
 =?us-ascii?Q?SQXRFI2hAytyb5soPOkC+/I5uLeMcCay77Eg+QkrWvQVaSRtCGyn0ULGrSQT?=
 =?us-ascii?Q?VTq6q629MUsaDFla9s+yNqMxsxvcEbvfqxi2wIrHY1G+XRmTV1ud6Qf9Jv2y?=
 =?us-ascii?Q?CkOwGkCo8MRJNPQUZMDQVoqi8J6zDU81q9kaurjHMFNHJGCOw+xs/gT41wyc?=
 =?us-ascii?Q?dixd48nXXFHBDjgn3ILdN/C9uFNyUF/NlM0M6F8EKA3/TXaOrwf93++D+YeR?=
 =?us-ascii?Q?W8DRoVJj1KPVTFsgfN3RXLPb1xbF1QNJzuloOBHfvZrwWXSgkCCZU3ytVS0Z?=
 =?us-ascii?Q?1YeYPnZi65uEjt8vCvQZvgCR6x0KYuNQTpLssNcOgHJieMuUjYDw30RSWIax?=
 =?us-ascii?Q?o3KfQLblriBq58a88a8eyRuOLlxhpxs5q4oK8B44LlqjA4bwiBhgDe0JJJaY?=
 =?us-ascii?Q?VpHr4+gkfiq2chNyH+TCEFbt8PV6hgOxeQMKW2leKkDgueKuB0EYNNw+KqTt?=
 =?us-ascii?Q?9Z4qAyFPSsoIPKTpeVYSg8bgIk3b7LphlSPopdcPzAorTJQsU6sOkKLnQNiF?=
 =?us-ascii?Q?d3pGBoN6OW3IrWzj1KD9WEWAHGqW6T37WCPu5Po7wkxybwjMEutNMHfl3MiP?=
 =?us-ascii?Q?EEwBzppBvD0mIWX5iBDUxA8uQBS2Cnka/u2yWWzLBbgLaYUQg0xpJBze8s+C?=
 =?us-ascii?Q?ywRDDyKkysUtznZKJeYX7kKj76Mu2A8BKXVsQt5D0l/oj9A8JMhY+tScBhoJ?=
 =?us-ascii?Q?0ExMfkPAdWvqSr9HX993ogDSUCKFeF5r2djrnRsHKjfIhpCI6UI6eK9Bncns?=
 =?us-ascii?Q?iCCLJ91v7MopS+wmEI2+n9zeXrmoSh0RjL6GnOnzaoYV/A5eOYq4pPs/L/Si?=
 =?us-ascii?Q?ojAkBaxHPOTWxNxcjbu1hqgfBzcRlYwemG8/EgQalgFtlO/UCWsf3c7RLLQQ?=
 =?us-ascii?Q?n2jVkfdi18nbapse5NuV4av3QRgXZIvox8DozhD8/DM/4BotsxQbqsNBHOe/?=
 =?us-ascii?Q?tjmt4BImCaqLMDQSovNTrvcAsRh9tcjgXiA/zPhRAWGh3riE?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: eb8ac312-0b16-4328-1b90-08de641b632f
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Feb 2026 18:29:52.6052
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FusVtlKgnQH7PuaTAX4u3aDt/wBTq1g1VkWIZTH85PJ7jT1FA+ODG4EBx7PggRYP
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB7947
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 276994000D
X-Stat-Signature: n6aey7orjmibyfa8yhgaeyk96g9u791z
X-HE-Tag: 1770229799-429354
X-HE-Meta: U2FsdGVkX18twgQhylTpBfxnW6rd+sdYu42VygEpRgYTNMJ8x9RlNDYIdye+GUvXS1AgJRkdmlABOX/vF982RwjdhzXWATEk/900tPSgAVr6Pa4F6LZTCtudDRLmtox8kLcSuCVBRET86grJbEInyjHUX8IuqMcU1AMymUEWewWFoCsTGgbCk3ILvjizotRnvWUaaav5qnq3bNwal1dJJ4gzKe8Nzvdvwi0XPgo+GizLByvDKkm1dhnToaRbqjHDKpDSCIosHMj02+9eDzHbz5spsVFcje/FBEbOaJIrGBAgmhaeIzPudeiAvCVnlorvEDqKaYuxZjk5n09wOBLwpm6QhOlOTEQ3keVlGsbK2m7wdcGGvTmwhQAtmfqbEJepTjacVigUMRRSWXCNeOXdvm2ghPWrexya/YpE9jiDTXHOsAImca5GbrxPTI6upYLK4MlcjKN3d4HKmUsCvoE/lCrgp2gFd+2A7xlFipJlugcnSIKwwOlQa5lfMLGpmczltnnAWqQXp7pkwOlMTr2nDBNelQHrx6BygULdHSQw2mgfomfIZwNT2k5ZvcT12NeHyBGxNheKjKKn+rhfvEVfU8uTcjAo7pFapwT451za4fMvVTHLjjISguh+vW5oDKGkFmOexcnKDX4xBQIFNw1XFQnRDD0hheEsYOc4oRB8gjpHJPK+wHyCFq/STMveUtCRaXRV8HLE89LG+tVwHUPFYPfR4yU6b+7yF/wuy1LkkUvy9VVDd8JbcERxdTlt35hWxjsFnqz2LXCQeytrPQCapxOO7L0q7MqrOIgtjxhbtGAFg4fhJPWwZr2tlimDPz4I2cxYif8HXztSgrb3whXF6uspnouGnHTUPW2BvuaB7DOn1qZeywSX2NAiiO6Rb2uMQjZBhPu7AmwO3FkZY8+WhUfGz2EsEoMwHJ7CIyDhWzeqLGfOQi3JNwISwQcOXDT5Ak5LGYUg3tJeBpzi4i/
 DmeYCvxf
 Je8UZ0gLe1Tmr+VHCbUAg3vr1Omgt335dCzXuhvizxaLPvK2T1UrZCSn7t8F78bJxqWbQ6Q8PkOtLjqAZYr6RZo+IcpqpjvRuliHQ5bgPcTwJ+T85IAoggk0Df23ZkjZ2mETDvelfrPAoUXtjSSeLh6bxVJtakzeHJ4sxav3+LTdOnZSe264v3l9L/VFpIDoVh34/xuxpAVXpSN1AwCwwoH33ltH8L8je/rW+MZFskzO4aiGbVqr2EXMASqoYfyQCVoI9e5z92wdBRyd80Lso7ZMQ7ogfnyi3P2f0GLqti3CmJiAa2BstGGV+E9/Lm0vhtbo9bnDNnVGP6vVQ0QWwDG2YFBfEBaDKWhqPNNmgDSpm8/LdLx7ICu5UXnkn6cEyYQOl+f0IamP6Hb5CVyX0o7cT8Smsy5zK1bY+sF7fcsMmXzOyX4I/6iDotQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4 Feb 2026, at 11:21, Zi Yan wrote:

> On 2 Feb 2026, at 23:30, Balbir Singh wrote:
>
>> On 1/30/26 14:48, Zi Yan wrote:
>>> Hi all,
>>>
>>> Based on my discussion with Jason about device private folio
>>> reinitialization[1], I realize that the concepts of compound page and=
 folio
>>> are mixed together and confusing, as people think a compound page is =
equal
>>> to a folio. This is not true, since a compound page means a group of
>>> pages is managed as a whole and it can be something other than a foli=
o,
>>> for example, a slab page. To avoid further confusing people, this
>>> patchset separates compound page from folio by moving any folio relat=
ed
>>> code out of compound page functions.
>>>
>>> The code is on top of mm-new (2026-01-28-20-27) and all mm selftests
>>> passed.
>>>
>>> The key change is that a compound page no longer sets:
>>> 1. folio->_nr_pages,
>>> 2. folio->_large_mapcount,
>>> 3. folio->_nr_pages_mapped,
>>> 4. folio->_mm_ids,
>>> 5. folio->_mm_id_mapcount,
>>> 6. folio->_pincount,
>>> 7. folio->_entire_mapcount,
>>> 8. folio->_deferred_list.
>>>
>>> Since these fields are only used by folios that are rmappable. The co=
de
>>> setting these fields is moved to page_rmappable_folio(). To make the
>>> code move, this patchset also needs to changes several places, where
>>> folio and compound page are used interchangably or unusual folio use:=

>>>
>>> 1. in io_mem_alloc_compound(), a compound page is allocated, but late=
r
>>>    it is mapped via vm_insert_pages() like a rmappable folio;
>>> 2. __split_folio_to_order() sets large_rmappable flag directly instea=
d
>>>    of using page_rmappable_folio() for after-split folios;
>>> 3. hugetlb unsets large_rmappable to escape deferred_list unqueue
>>>    operation.
>>>
>>> At last, the page freeing path is also changed to have different chec=
ks
>>> for compound page and folio.
>>>
>>
>> Thanks for doing this!
>>
>>
>>> One thing to note is that for compound page, I do not store compound
>>> order in folio->_nr_pages, which overlaps with page[1].memcg_data and=

>>> use 1 << compound_order() instead, since I do not want to add a new
>>> union to struct page and compound_nr() is not as widely used as
>>> folio_nr_pages(). But let me know if there is a performance concern f=
or
>>> this.
>>>
>>> Comments and suggestions are welcome.
>>>
>>
>> What does this mean for treating compound pages as folios, does this b=
reak
>> code that makes any assumptions about their interop?
>
> Yes. All folio initialization code is moved from prep_compound_page() t=
o
> page_rmappable_folio(), so such users will see warnings on some folio f=
ields
> are not set properly. They should call page_rmappable_folio() on compou=
nd
> pages they are planning to use as folios. A common use case is to
> vm_insert_page(s)() on subpages of a folio.
>
> For in-tree users, I am converting them all in this series.

Considering a recent report[1], where drivers/scsi/sg.c allocates compoun=
d
pages with __GFP_COMP and maps them into userspace via sg_vma_fault(),
I guess almost all __GFP_COMP users are really using folios instead of
compound pages.


[1] https://lore.kernel.org/all/PS1PPF7E1D7501F1E4F4441E7ECD056DEADAB98A@=
PS1PPF7E1D7501F.apcprd02.prod.outlook.com/

>
>>
>>>
>>>
>>> Link: https://lore.kernel.org/all/F7E3DF24-A37B-40A0-A507-CEF4AB76C44=
D@nvidia.com/ [1]
>>>
>>> Zi Yan (5):
>>>   io_uring: allocate folio in io_mem_alloc_compound() and function
>>>     rename
>>>   mm/huge_memory: use page_rmappable_folio() to convert after-split
>>>     folios
>>>   mm/hugetlb: set large_rmappable on hugetlb and avoid deferred_list
>>>     handling
>>>   mm: only use struct page in compound_nr() and compound_order()
>>>   mm: code separation for compound page and folio
>>>
>>>  include/linux/mm.h | 12 ++++--------
>>>  io_uring/memmap.c  | 12 ++++++------
>>>  mm/huge_memory.c   |  5 ++---
>>>  mm/hugetlb.c       |  8 ++++----
>>>  mm/hugetlb_cma.c   |  2 +-
>>>  mm/internal.h      | 47 +++++++++++++++++++++++++++-----------------=
--
>>>  mm/mm_init.c       |  2 +-
>>>  mm/page_alloc.c    | 23 ++++++++++++++++++-----
>>>  8 files changed, 64 insertions(+), 47 deletions(-)
>>>
>
>
> Best Regards,
> Yan, Zi


Best Regards,
Yan, Zi

