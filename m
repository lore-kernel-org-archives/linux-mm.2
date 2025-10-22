Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 08812CCD1AB
	for <linux-mm@archiver.kernel.org>; Wed, 22 Oct 2025 20:27:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 648798E0003; Wed, 22 Oct 2025 16:27:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5F8C58E0002; Wed, 22 Oct 2025 16:27:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 499738E0003; Wed, 22 Oct 2025 16:27:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 3220C8E0002
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 16:27:58 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id B9D5D1291F2
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 20:27:57 +0000 (UTC)
X-FDA: 84026886594.22.36F33AB
Received: from SN4PR2101CU001.outbound.protection.outlook.com (mail-southcentralusazon11012037.outbound.protection.outlook.com [40.93.195.37])
	by imf29.hostedemail.com (Postfix) with ESMTP id E4559120006
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 20:27:54 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=Y1tELKD7;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf29.hostedemail.com: domain of ziy@nvidia.com designates 40.93.195.37 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1761164875; a=rsa-sha256;
	cv=pass;
	b=TM+vd3ItZ8aUqZ6+qJFIjHq/WAFWk5D9tXEsv6aCMrB/X76KMz6U8iJSiSMt4kR5rgzHL1
	XfTsDJglUPyMKpdeQzsJU8+rZnRdof/XwJDx9LFvYYoHX+6t9CMFn+GIkuE6IqKjs+Zz5e
	TPCXjOTKmhcErBZ9C7G+p+Lt2D5HU1c=
ARC-Authentication-Results: i=2;
	imf29.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=Y1tELKD7;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf29.hostedemail.com: domain of ziy@nvidia.com designates 40.93.195.37 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761164875;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7KWIwEvOf2SWrnA7B/10QM4ogb+LFi5POJ0B5Bvm/0c=;
	b=fdlf4ODoyyoAllYlWVjxQYRq9qlxxBMcgvGTz1VvHKnqBz9iruCTMhpqKYFNIsEyXtVqgo
	MEK3CP6dYVsJ0s2GiRvgVznw37S8zg6eeY/RRhtIpjmsefsQkuVLIDq3ikw5yGAD90AsUi
	cWn3gc3GxsfTuz2hJfjqj/joesMzvd4=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=XUoy6q/hwKClIJlZcLKz0VV6E5p0U7fOILop+uFldJCTXyLAAG4/+cQYjuOOWUNgxfWwHCoe0qACvVPmzzR/D6EbKfxJ2y32gwqtrsRgGyqWIf6n7HPewIfouHGax1xhkwQquz/CimxtzRckTsttki6rAsnfrjHKJOaylVBtErwOJv3oDNworMAO+LXTv+rR7YOqfSQC13fWQsUrCMcp/tx012D3/AC498qgOcwvmD2ZVxXPKHfsIz2aw2DBmr3tzAxVVEwqa9cvTMt/hWcgNm7lL7kIGa8NYDyAA4dqWSPBJBfz/0LQ/0HsnOTrtDJuSln8OIWXg/+2fRJHoztO4g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7KWIwEvOf2SWrnA7B/10QM4ogb+LFi5POJ0B5Bvm/0c=;
 b=rdK1KNWcrWAqXCXlHW6JFoNO+gLHPb5mh3/nSic3B/QtHbjx9nBjabWLjov9efUmeLwZq78gCDdBZG3pz5Z5vlc2xB2mIL+WfYsTFLpO/z9l50hrhsrb8NfPfAB+yFfCGgoPawCosZ9LVbKHsP5ymOF5cE2QIhQsv4Uu7YRLLYm5AJ0qNwdWlwbFLahftpGJwC3JvSgagiLC4ttw/Q4a+1bjEN/CiGVHFA9r1cxFCH8yIky3oPxYVq3Yhg5KpGY9XcG/u09vinnCQQYCKIUJzdOcJsR9u7/8ZYMFk0V7/ZAU6KbVARbymqqVfqEMEoYUdhyQ3ej4NMoviz0BV2MR/Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7KWIwEvOf2SWrnA7B/10QM4ogb+LFi5POJ0B5Bvm/0c=;
 b=Y1tELKD7E2pC258KVU247o2xaZKEpV3PrKGFT9dSNeN6fqgG2oLmOHjvYQVG+iliHLf9/HFyXC2fL1e6HRvzi5XW68ZHp02nEMIipu0ApjszbJ7RfSdxwzQXWPx7lmGLD0QjcbWxiHc3kzOyd0OQmN0fo57cg6swMjGPOYcM/z5sq5Si25wSloWnLq7bDU04Ubp506B2PE5zrleKgkFgyMUpYtJ1OTa/c++/Jpjw6VL9wguD4FCyWNjUSUXLcuPGGCHkxExdbW5L0eJLezTlo+8NcwvX/PIOXS1IW55f8gnswazSmIWc7SDtoEI3h9Q8Z09MjhDEiTBq2L6w/QGyIA==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 SJ1PR12MB6194.namprd12.prod.outlook.com (2603:10b6:a03:458::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9253.12; Wed, 22 Oct
 2025 20:27:51 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a%5]) with mapi id 15.20.9253.011; Wed, 22 Oct 2025
 20:27:51 +0000
From: Zi Yan <ziy@nvidia.com>
To: David Hildenbrand <david@redhat.com>
Cc: linmiaohe@huawei.com, jane.chu@oracle.com, kernel@pankajraghav.com,
 akpm@linux-foundation.org, mcgrof@kernel.org, nao.horiguchi@gmail.com,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 Wei Yang <richard.weiyang@gmail.com>, Yang Shi <shy828301@gmail.com>,
 linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org
Subject: Re: [PATCH v3 1/4] mm/huge_memory: preserve PG_has_hwpoisoned if a
 folio is split to >0 order
Date: Wed, 22 Oct 2025 16:27:48 -0400
X-Mailer: MailMate (2.0r6272)
Message-ID: <5BB612B6-3A9C-4CC4-AAAC-107E4DC6670E@nvidia.com>
In-Reply-To: <d3d05898-5530-4990-9d61-8268bd483765@redhat.com>
References: <20251022033531.389351-1-ziy@nvidia.com>
 <20251022033531.389351-2-ziy@nvidia.com>
 <d3d05898-5530-4990-9d61-8268bd483765@redhat.com>
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: BL1PR13CA0141.namprd13.prod.outlook.com
 (2603:10b6:208:2bb::26) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|SJ1PR12MB6194:EE_
X-MS-Office365-Filtering-Correlation-Id: 465512e0-d157-46b5-9226-08de11a978dc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?MXDCpKcF758zXOMaAN9jGWt7YsTTen7Kaz1VEO7ZAYF9xRzkzS0+5Rf/uSMG?=
 =?us-ascii?Q?Z1DSoYYxtOWBKH1E/eOV78F4pwn1PhHmpT+NssvZQclelEGPhWjuE36BdqbB?=
 =?us-ascii?Q?JpK40vsp5L7UYrtB3u0DLDbOGlpXu1yBNo8rVURkXE1YHSsfoPjrxxR7XyrG?=
 =?us-ascii?Q?BaDNGQ6uk/dETaoYcy3S/teP9K4AkX5qZe97/xqG+6pOJouU3gd+Mm9MEzMw?=
 =?us-ascii?Q?xoAvUfX5YEdqaH7uXkHK04SscHGHqTjBY1EngJNTUYVhGqr7b/MIe8j6gir9?=
 =?us-ascii?Q?Sj1QAt4c788RjAi5WoMik/U7Nn5yKV3rMptWlNOZTLuWuIpHBBCf7zwDWFPP?=
 =?us-ascii?Q?xLtKbCdSGudoiVQa8MjhRmqyvVFpJZUgltUTaZVbci+EW0vxXv3gbRqtFBM6?=
 =?us-ascii?Q?PwZsnBy6cnQ91I/X0YCir95bvZZdnR1LdhHkpmP+69XaeC/E7CFZxPWNobvA?=
 =?us-ascii?Q?RtVumnM5eNbfwS/eHsl6gE9L2kT3hEoZzAnM6585QxicSY5ya/7+hod6nXP8?=
 =?us-ascii?Q?NPGkJ8EG+C87LmBMzGbYWNAurhY74iQHnWcof+lwp0+0dDk0Kl5K2whMwqzj?=
 =?us-ascii?Q?UvpipDYMbyjcgWTavi0TIZI4nXgUzzjQPriLuw2OtN6aVLTAlqJfIGAWcZfK?=
 =?us-ascii?Q?AU5zMhww3jxXuGquOxFKOg1rwP+kSPM7zVFSWiclcy0Io52mD0s+TMw4BIJ6?=
 =?us-ascii?Q?YNo+67bFpJN4xun++INvYDJ00Pc/k5rTI+OijZJQGzpSKPuRdGMEV30bHwd7?=
 =?us-ascii?Q?QQv6s7a5B9wTQpWeJElGiNCav3sz5adHHB9QnN3TJeP2QMmHUzcRW599DX/t?=
 =?us-ascii?Q?n3K68hlM0naSK8+paSzFZ46QP5HL76OUYnBQS88OwwqUY+fosPLPB/2mT8qc?=
 =?us-ascii?Q?bDfvEaKhoYn4ZL/aZwSYxYoSbztpVC9e2i6vltXRjnjasQXiaFRKQZ838Aj9?=
 =?us-ascii?Q?YuP5Hk5Uv62yCUY/vE2vh4nL6UoE+2YZFiBQSn6bsW8Wdx9s1J8vGq7zz2yH?=
 =?us-ascii?Q?VhS69iXv3IJUgp+jyTKW/OFYiJ9JHx1VXhPOPwkzf2ewf4FDsNB4fbjsqxkx?=
 =?us-ascii?Q?7IOZxdnOXRVUqEX1HqOjb8zAfcqMR6YgZGkRG2Pj5rb2ISIPQOERzcRhh8tq?=
 =?us-ascii?Q?fIHBgfQLeCY2GjJ/iSso7hAB6CDXVTW/7cLnUZHi41iW8BwnSU1XwpmXOpDl?=
 =?us-ascii?Q?TMMcDIgXKEdIdsj0TWy091tD1ioOEHLWIxm/WmkTFwCnCNS+Qy7bdoiXctQO?=
 =?us-ascii?Q?Y4KC9lT4KY6sPyTsmLyIxmv1Qna1vsbbkCmiQtMpmfhNSsVTZqDEIWa9hFVj?=
 =?us-ascii?Q?ESTLi8YTEnXR9K2BPHAbwnKXIft7ztkPlahwHa6pGSh4/2eWgMha54tkwoRi?=
 =?us-ascii?Q?HRPQ0ilzct1YQ/lToGzeqtY/yLbcULg5pWtVIaE4gf3Whz0cIOc7sFmQX2SS?=
 =?us-ascii?Q?h0Yso38+A3JowVJYe6L95r0TBp1eZkRKLrEolfmEFEJGPrQ5F3+Nww=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?PasDMWgt+Tu+atCC99iUhz72DBBNbfnPzsmpaEFUlx23aRhT1QGtVlTMIJWT?=
 =?us-ascii?Q?fxFZNHHUQu2TV+VonDQmgHkLZr0TrJ7sZaRfQyOt9TcTs8w/G60vyQ2zCXLD?=
 =?us-ascii?Q?0lneaZZpQLaMcpRiER8u5JfPhwLKEVqXCzvDFtbo2OUrghuX2axedZB599MW?=
 =?us-ascii?Q?qZXpecMezmULVxJ8u/H8kTA69lP/g851sSLb2oTkqWUJTLY8fqPbWHoIr/u4?=
 =?us-ascii?Q?fnM6Oq/Iagkm7BzmdX8avtqwSKnniwv3tA4sJ8aWp9F/NXT0kZDm9fhs9pMn?=
 =?us-ascii?Q?xWuKmh5OsG8eP4Mf1lsI31QkQti/43v7Sjd57BPn/nP7HTI14xRQOq+b6sN8?=
 =?us-ascii?Q?M8+jpZWMLNEEChuhZTNAXa3Z55Hn+3mdEzXqbR3xrkF+zQl613lrP8CfFFW3?=
 =?us-ascii?Q?KhTBeUyXvX6U/bnDC7gL++nPS+MpvwVs5hCZpozK32cKBN2FuAZap/gccEez?=
 =?us-ascii?Q?/rQ9rhEAqL5Z7rGAyKLq1xhDJMtrw7fNyo2iVHOzi4esbfZY+Z5EVytHaL2j?=
 =?us-ascii?Q?I+3YrD7y85gk60KFdUzDBF7eUhwcu9wxISVXvU+duczA5MpUBl3iAZwN4p/X?=
 =?us-ascii?Q?YzXp3EmhPjtvCenYtmH8ypPME9tn+f6vsGrtJeLAiA3h+5cE/W+V8I/r+I5D?=
 =?us-ascii?Q?XmRQIOBlFrB2zQjzsoiKWQx1PdF7z33LbCl1m0WokV0CsR1SRqON6B2R7ub3?=
 =?us-ascii?Q?+kTco5YSUHcHeZXXwBou9PjlG2iftkjrAQkimsavtCpVfaDxC7iASifiGazn?=
 =?us-ascii?Q?TwFkNqLXrBAqjW1YU9xDnsii4J9RE3t0UgWIWEum2Np3OQtZsUX5DQ+SS4Uz?=
 =?us-ascii?Q?WEz2ob8/N2gxTp4lLk7i7sxXD7MlZkYQgWz4JbElFMTtDimEjPnw9MEWZoRY?=
 =?us-ascii?Q?UHl9ohGSM9qBin3LpwZ+/J0xpsV2bQ1TUi/qGhwRABwhKfIR8xFR3+bZ1v5/?=
 =?us-ascii?Q?sAdEO8jJuepBpWpNQVQ/GfiV5/n17PkS5nXn57bvYIPz/qyKyxfHqe+IKntZ?=
 =?us-ascii?Q?60rciqhacTRWvAw7XNyV60zeCLwS24PkAs7Bn1GrGT1AyTEo968LyYFcCYdv?=
 =?us-ascii?Q?ng1rspkHCIR+2qcqQSQCAqjnHHSALS6wwbnBhrpIUBSjl/yWGq2sPc0XfZLb?=
 =?us-ascii?Q?y+EKGcr7kWmnY7pDnl6S1346uqmGYZlblRe6Nkz1yPB3bkOI+n3s9sFNcuaO?=
 =?us-ascii?Q?OHckB5O7fybTljxJjv1hNQTYBYR5BdInri5chKNneeZ2nWBTPGaWUuHTHoRn?=
 =?us-ascii?Q?ijjPHK98gb/2vMMMZO3SHQAG14NWxDp1cbvxZiaDkl7gfdusfJueMmRbLsH5?=
 =?us-ascii?Q?fympmjarhfjRVsWYwh3+GEKFyt2WN24fhI4fjKRGkB2QSel3R2KosH5dw0tQ?=
 =?us-ascii?Q?r6MIh3c6ZETRxbrGhwfAQXl3rWcV3vNDCo4MvPH7WPGDxEodjMhHrF4a91dA?=
 =?us-ascii?Q?2VGpFuot6ym84dgHgDJ75dacfZxUUhSaR1RYiGc4qgjUcIFXACgi672/M+N0?=
 =?us-ascii?Q?tKGoUpZblsaOJhQYmxff5DV6CfhT/GTRL3ivd6UbK9b4g3S34x0Xa6xwHvWX?=
 =?us-ascii?Q?ML/D+e85FwRFBc2BAsMKuijTwhNojy/OapfVLRDY?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 465512e0-d157-46b5-9226-08de11a978dc
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Oct 2025 20:27:50.9660
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: T0LIZLERqzunwtZFDH+/lxA6od2wKstW6U9Xe9cKS1n+sR6iPonhFXDfqcYS47bw
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ1PR12MB6194
X-Rspam-User: 
X-Stat-Signature: kh6i1a99mxpd74k8gey5wj4um48w3861
X-Rspamd-Queue-Id: E4559120006
X-Rspamd-Server: rspam09
X-HE-Tag: 1761164874-744755
X-HE-Meta: U2FsdGVkX19NaEn0BpBFGplXavzipO2JVWOXFmTLX5mL1Fg0mxZwBgNjjrH6EDn63omYzGeLbXr4rZAy+JmTvBaTzZj5S5VFOJdHW0y7gErDfFcSr2wuU+yahDSNyUj8LwKb6E82tD106iEziBLo4sSmk0gzSBl7D/E4Y3rDpn5qdxAMGzm3DZwzON8Jpjc71g4mvwkeBqyABXfiN8KdBWqB/0PMUjm5TX2gYGeIWsEvk/pCMGYSgSeYZfneTAUvJxi2fs3doA9pVHxYaUH+PAKfYXCSZDMFGTIIMpry0UbkXfEWEx9QsaDCNpq5jfeTGE9B4aA0S6wa5xt8/ObM/sjxAEK4vvK+SnGai+CWMsg0ITyHe3lnrJDqa1WO1h8P9USHEdKoBAjFk8KPyC3oHf7mh22ZCh4H1tEwt8QY/dsD8YbAE1sbpUCt8PUx+DG89xCxjLpUqS8j2PCZmiYW27uu4/+VMmJ7Pl/BA9hb1XlHHLOo83ioCKQ2vep8FgPZUB750EqIwnBPJy+ZexMwBZkCKYrhaurfTO+G08d819fcFd05d9GwpxOR6uAhU+D1JYivhQaRxO9EBtE1MpcK78/PE+KgnDr6N6sX3vzqYrrWrdhPxTuWB4G7g4JC9TNVqLpOS4sFzDN+6s6/pXuBdJPyQh28n8EGHlj+VRpmLe48WgEKwSsQv6m3qYB0k32aGc9GeZOjzz2s0e9g9adtOTgIw4arD4GSZMOY9D5NHbuikm/WHNixLJ4DKECuHSmbEyowtCO3AkFG62IP8BgQKV1eI/ATxZNC87PW7fJsGnl5O05/il6iBVpSIuSqxwaNehfII8zkXOvS98Pq4sgtnkTTqHfxBM3NwVc4eczt2RZJxtzL/JqmI+V8uhhT/mjGmfq792vNi9NdIWnZEguAF/C9UvRLlKT9wHGM1T312KFmYjBmVQidF+4tL/lfztfTjj2DNETOqMJw/8QPi+9
 RcZaxI+S
 5Dvs5W5ktvySCtnxh/CJXGIvR9HKYiYFWuAHWcm/OJAfzEUdI/cvNN8I/AOb2Bk8xOd2c64O3zXIXSLUHWiP1un9kA9sRJvNhnHsNnbr0dHKMrnc2JmMWvZgraX/L4atzKdo2tAk28Zmd7w5zlqwpWQZ5nDcdOOFoN0LSmCp2Erwh6MSbfuLR6jzNRiSEGJjNszRIz2gP29z/Ge9KdF105TGlcGWLgoOR4uHpZGZSnS48+YtRPaZ4FwKq5K4d+1JMypbhtlEkHJRW0jNWUTcwhpSIjumxqFlzHQ48ticgbGjf6eI0Ulp83iGDa86Z3HZtteyMoZap9uWvHwUyUsFQ5KRrqpnoYTr/fs61M1tYKZvK+NxqBEVZaLo1EoeebzZ3ZOt7DL5dTnW0iI+pO7HGzTR1F/25Xjrw0iTdPw+gUSjSJKU8mxx8wF8JNrmkVxpqgab3x/e/OupuT04W0+QJQtydEbGxbJNOdPMhjn1bvP5anXLdafbQx7fKXt9bDcxPZCo1qd273VAuBSn9ADGGw+Q8eUBaTD7xPJ7a1oYUTuGZXsE=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 22 Oct 2025, at 16:09, David Hildenbrand wrote:

> On 22.10.25 05:35, Zi Yan wrote:
>> folio split clears PG_has_hwpoisoned, but the flag should be preserved=
 in
>> after-split folios containing pages with PG_hwpoisoned flag if the fol=
io is
>> split to >0 order folios. Scan all pages in a to-be-split folio to
>> determine which after-split folios need the flag.
>>
>> An alternatives is to change PG_has_hwpoisoned to PG_maybe_hwpoisoned =
to
>> avoid the scan and set it on all after-split folios, but resulting fal=
se
>> positive has undesirable negative impact. To remove false positive, ca=
ller
>> of folio_test_has_hwpoisoned() and folio_contain_hwpoisoned_page() nee=
ds to
>> do the scan. That might be causing a hassle for current and future cal=
lers
>> and more costly than doing the scan in the split code. More details ar=
e
>> discussed in [1].
>>
>> It is OK that current implementation does not do this, because memory
>> failure code always tries to split to order-0 folios and if a folio ca=
nnot
>> be split to order-0, memory failure code either gives warnings or the =
split
>> is not performed.
>>
>
> We're losing PG_has_hwpoisoned for large folios, so likely this should =
be
> a stable fix for splitting anything to an order > 0 ?

I was the borderline on this, because:

1. before the hotfix, which prevents silently bumping target split order,=

   memory failure would give a warning when a folio is split to >0 order
   folios. The warning is masking this issue.
2. after the hotfix, folios with PG_has_hwpoisoned will not be split
   to >0 order folios since memory failure always wants to split a folio
   to order 0 and a folio containing LBS folios will not be split, thus
   without losing PG_has_hwpoisoned.

But one can use debugfs interface to split a has_hwpoisoned folio to >0 o=
rder
folios.

I will add
Fixes: c010d47f107f ("mm: thp: split huge page to any lower order pages")=

and cc stable in the next version.

>
>> Link: https://lore.kernel.org/all/CAHbLzkoOZm0PXxE9qwtF4gKR=3DcpRXrSrJ=
9V9Pm2DJexs985q4g@mail.gmail.com/ [1]
>> Signed-off-by: Zi Yan <ziy@nvidia.com>
>> ---
>>   mm/huge_memory.c | 28 +++++++++++++++++++++++++---
>>   1 file changed, 25 insertions(+), 3 deletions(-)
>>
>> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
>> index fc65ec3393d2..f3896c1f130f 100644
>> --- a/mm/huge_memory.c
>> +++ b/mm/huge_memory.c
>> @@ -3455,6 +3455,17 @@ bool can_split_folio(struct folio *folio, int c=
aller_pins, int *pextra_pins)
>>   					caller_pins;
>>   }
>>  +static bool page_range_has_hwpoisoned(struct page *first_page, long =
nr_pages)
>> +{
>> +	long i;
>> +
>> +	for (i =3D 0; i < nr_pages; i++)
>> +		if (PageHWPoison(first_page + i))
>> +			return true;
>> +
>> +	return false;
>
> Nit: I'd just do
>
> static bool page_range_has_hwpoisoned(struct page *page, unsigned long =
nr_pages)
> {
> 	for (; nr_pages; page++, nr_pages--)
> 		if (PageHWPoison(page))
> 			return true;
> 	}
> 	return false;
> }
>

OK, will use this one.

>> +}
>> +
>>   /*
>>    * It splits @folio into @new_order folios and copies the @folio met=
adata to
>>    * all the resulting folios.
>> @@ -3462,22 +3473,32 @@ bool can_split_folio(struct folio *folio, int =
caller_pins, int *pextra_pins)
>>   static void __split_folio_to_order(struct folio *folio, int old_orde=
r,
>>   		int new_order)
>>   {
>> +	/* Scan poisoned pages when split a poisoned folio to large folios *=
/
>> +	bool check_poisoned_pages =3D folio_test_has_hwpoisoned(folio) &&
>> +				    new_order !=3D 0;
>
> I'd shorten this to "handle_hwpoison" or sth like that.
>
> Maybe we can make it const and fit it into a single line.
>
> Comparison with 0 is not required.
>
> 	const bool handle_hwpoison =3D folio_test_has_hwpoisoned(folio) && new=
_order;

Sure, will use this.

>
>>   	long new_nr_pages =3D 1 << new_order;
>>   	long nr_pages =3D 1 << old_order;
>>   	long i;
>>  +	folio_clear_has_hwpoisoned(folio);
>> +
>> +	/* Check first new_nr_pages since the loop below skips them */
>> +	if (check_poisoned_pages &&
>> +	    page_range_has_hwpoisoned(folio_page(folio, 0), new_nr_pages))
>> +		folio_set_has_hwpoisoned(folio);
>>   	/*
>>   	 * Skip the first new_nr_pages, since the new folio from them have =
all
>>   	 * the flags from the original folio.
>>   	 */
>>   	for (i =3D new_nr_pages; i < nr_pages; i +=3D new_nr_pages) {
>>   		struct page *new_head =3D &folio->page + i;
>> -
>>   		/*
>>   		 * Careful: new_folio is not a "real" folio before we cleared Page=
Tail.
>>   		 * Don't pass it around before clear_compound_head().
>>   		 */
>>   		struct folio *new_folio =3D (struct folio *)new_head;
>> +		bool poisoned_new_folio =3D check_poisoned_pages &&
>> +			page_range_has_hwpoisoned(new_head, new_nr_pages);
>
> Is the temp variable really required? I'm afraid it is a bit ugly eithe=
r way :)
>
> I'd just move it into the if() below.
>
> 	if (handle_hwpoison &&
> 	    page_range_has_hwpoisoned(new_head, new_nr_pages)
> 		folio_set_has_hwpoisoned(new_folio);
>

Sure. :)

--
Best Regards,
Yan, Zi

