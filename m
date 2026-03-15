Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A3BB110854B6
	for <linux-mm@archiver.kernel.org>; Sun, 15 Mar 2026 00:03:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CD2C16B0088; Sat, 14 Mar 2026 20:03:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C564D6B0089; Sat, 14 Mar 2026 20:03:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B0D9A6B008A; Sat, 14 Mar 2026 20:03:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 9A8416B0088
	for <linux-mm@kvack.org>; Sat, 14 Mar 2026 20:03:34 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 2B5458C3AF
	for <linux-mm@kvack.org>; Sun, 15 Mar 2026 00:03:34 +0000 (UTC)
X-FDA: 84546348348.24.B2655FA
Received: from DM1PR04CU001.outbound.protection.outlook.com (mail-centralusazon11010048.outbound.protection.outlook.com [52.101.61.48])
	by imf16.hostedemail.com (Postfix) with ESMTP id 4A0FD180004
	for <linux-mm@kvack.org>; Sun, 15 Mar 2026 00:03:31 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=fXlSS6pY;
	spf=pass (imf16.hostedemail.com: domain of ziy@nvidia.com designates 52.101.61.48 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773533011;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ya0Z7A2lUpbMnBC9YVheoeum8HF+7aSR0OA7WF5VBxQ=;
	b=YmaWoXSoMoOxIGHAZ/V0ABOdoDBcD34JACEiC6lUyuGXl+/TGYGptSnlBUHAPhrS+zAUQ3
	ctA1SzrSMbZTph2eFKU0Ngvu4baPGX8mAlCffuB7gwIteW4U3u6MTbq7RfRyW8OlfiH3Ku
	qw5udk5/v+5BurehVuDbRzM2GgYRUwg=
ARC-Authentication-Results: i=2;
	imf16.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=fXlSS6pY;
	spf=pass (imf16.hostedemail.com: domain of ziy@nvidia.com designates 52.101.61.48 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1773533011; a=rsa-sha256;
	cv=pass;
	b=bG25Lgwv/pD8M/YM1b3CRFY0tmS08BbitTKpjxi4z7NiidNq2kpOAcU7kzVNEHsd8WUwzX
	blfJfT0NPf5QgNovTYlFPZUHGP3FQnpERBMcpV3criZB2idWhVf4KebbP2IGlv5LyiD7cy
	DqRMzg5CGP4tKMBNuRff/UAGWugwQB4=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=MyvlAdWeMO0Lz1jVi8H+Z/j9H3PT9M4sxSOIR2LCi5S7uIIXtAeXKIOKLg6VlK5F213/iRJBwtSJItWYKbL078oB6Btu70H5p5aGVYXuYk2cl5h++ETBBwZ+isBG3iASLx9r2CLwIVz3gc7IZsgz2bHqDbOieebxOQQf/GSMyi+b5jUtPA41AvuoszOe7KG+LavuI6qy79GxpgSHrPTb+j0EhaeWlG9al6dXFrhSsRnjMxKWkqpTihPN/Qh6ZnfrhI9rv8xz/xel3pQqXHZT3J6LhQ1Swn4j1O15gEvOz+HezIdQgQVucav7s/JgTQe5kb4rNvtqpTHhN57hH+di8Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ya0Z7A2lUpbMnBC9YVheoeum8HF+7aSR0OA7WF5VBxQ=;
 b=itdVK8Mou9U197V1uNVNzFeFoWZar+RjhmoDH9JHdmbcstLC1o0vlMP1c44JV1nR8SSD+Lch87ZGinU5seAQBm/OIOBzJTaMdISbaAxozdTnVegjQ9QsevjeDYMLQyfxYzauvsq70zEUkQgu6A3qUPp6lIVqUKc7c+bzcFKUj6hEZgwsJLE7b2G3NwaGtX7EEU/62G7IUbLmc7IEckonXzdkzCQU4KbK+9YXwVS2mJYGBmn2GOljVOnfQMWcjD3juXZw1/vdU0HpsVII8HaeAYGiDb2GuM7mXQoudZHYMyO4eqk7H03o+4syArDmiGsHbka415DyavT1G+k4dDi82Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ya0Z7A2lUpbMnBC9YVheoeum8HF+7aSR0OA7WF5VBxQ=;
 b=fXlSS6pYkisPKzT8adMBQ1+JDb9vHdsoswA/pE7uJTKZKxohMACFmKpmCucX/SBVbYwt1NxJqGaxR6jF69QJEsIL5k6gCrKjYTw8fK7VDIbD4DKukwRDvLLv8f0hFeZfVwGimzl26nmsUmkaLeteG0P4F9OGvglNCgPyvS21csNp6LQ5ktz1eVK23WbQTW36zgn4q49O0FqBxW88ucIRI/rbJ2eRrQe3EIw3RfeBvx/tc6hFV+6WhkwKHXfGDg2/yVg3ptSFXDxCSwMk7DctC3a2IizgTwyRLaQbefxTPmmu6colHjUssH9XXAF8bKp26tjobD7pdcWFm0BrI2aOKA==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 DS7PR12MB8230.namprd12.prod.outlook.com (2603:10b6:8:ed::5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9723.13; Sun, 15 Mar 2026 00:03:25 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2%4]) with mapi id 15.20.9723.013; Sun, 15 Mar 2026
 00:03:25 +0000
From: Zi Yan <ziy@nvidia.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Zi Yan <ziy@nvidia.com>,
 Hugh Dickins <hughd@google.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Matthew Wilcox <willy@infradead.org>, Bas van Dijk <bas@dfinity.org>,
 Eero Kelly <eero.kelly@dfinity.org>,
 Andrew Battat <andrew.battat@dfinity.org>,
 Adam Bratschi-Kaye <adam.bratschikaye@dfinity.org>, <linux-mm@kvack.org>,
 <linux-kernel@vger.kernel.org>, <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH] selftests/mm: add folio_split() and filemap_get_entry()
 race test
Date: Sat, 14 Mar 2026 20:03:23 -0400
X-Mailer: MailMate (2.0r6290)
Message-ID: <EC71CE3C-08D9-48FE-95CB-B6A43B4BDB9C@nvidia.com>
In-Reply-To: <20260313114037.3593642-1-ziy@nvidia.com>
References: <20260313114037.3593642-1-ziy@nvidia.com>
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: BL1PR13CA0328.namprd13.prod.outlook.com
 (2603:10b6:208:2c1::33) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|DS7PR12MB8230:EE_
X-MS-Office365-Filtering-Correlation-Id: 4280cd86-378a-4a4a-9d28-08de82264798
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|7416014|376014|366016|18002099003|56012099003|22082099003|83080400003;
X-Microsoft-Antispam-Message-Info:
	3bUfXng4PRoE5Wi+d9+LXXFAGBEmCa7Rq3S3O2/b3gASIdrsIQW4pFNdJUkE/v3dm7ZGdERZxEi8HLsqYzVM+ux4y+R56gKwyYlVfmHkk3yuKIFhs0YRQMJBm8rA47uwrBrkQS3Bvnkx2lF3elD9wMPNHGPmokg1yNk/EqeXrIbAm1VYX2HzFKte0WPGt/rpkA9kKImSF0Jo7PbDA4xrOrpysxhaIWWACo4MkbxcadsGetzgeW1aDmA5CUFYgulejEwwZlDuYa+LXW5p9AyhdgXH1rvFeVghgerprkD2o+TisckhJN0WmYeD4vvqsZ2LM1QGZ0OzGIN3hL+V+7yGrH9UC++chUY7crbGHYdiNya3VlpaBX70dXavbzGNINn2pnQKOq+KqGwLQuIxCYmU+toZupowy22w0VtyUqMkMaEHhR6OzhoRUiYrdd+Pw34tfvic/Ep86K/UQoE047KTgJIxQbBOJYybULPzMGkVYit1aN3Qc1pwEKGnl6moJywSIfc0s/1NVM8MTQs5DtjFFoeahIRxiz7LgbXLt9tjS6A2YvQSL9nkLo2dbGl2UJLTXS4EHk4Y9yzQxp8vmauPK7b7pJqYQsGWQgMbFzgwuJ87TEYPylEX5CU9ObD8STZzxwoY8HLEzhVzeTzLo41ZOuO0n79ucCzwPFD0QvmmO/5f0S9OJUGM+rPWC89S6+bmpCWg0Vq6u/ahS+bNYoylGD9UkjgushndU+FQTz1Nn+US7psHP3MwsOjY+VVl1Pvy5mLC3QxzYXDfAAl1FWZd410fO3uuxB1oVB2UWWTxMnM=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016)(18002099003)(56012099003)(22082099003)(83080400003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?na12ajhWjydusb0Rp6/u6BczbLqymzn29yBLGjRjq+LsKNIMeG1rCv5iTrEe?=
 =?us-ascii?Q?Z/Q1hath6SwJ+J4m40MEiLmcYft9E7RcV9Ltkdrt2x3eH1hatjcZNEK6z1B0?=
 =?us-ascii?Q?Cqk3BntwClVvuX2/661La0aijZhWj00logNeWoXqiN57W0xqxqM18vC06B0K?=
 =?us-ascii?Q?2XJq0YwJL5QJ4krdbQR6P/tsIjOUoJSBdTuJXVjD/mUE/ri7RN9qRiV4y0D6?=
 =?us-ascii?Q?yGBPDa3YzP5OfBNZqLb2MU9zJL3yx8Xmb9J/wRmd2nU1GULJuN11JpeeTi6B?=
 =?us-ascii?Q?RvZfzbdfus8tWM2tukQomU+Zwk09B+K2YIsBOQnnSF+3YB8TIMOE0uQDdRSo?=
 =?us-ascii?Q?pxPPUAzKlUsg8rXvnvr8KQNEb4FvrMDwdkkwQrMqJG8ACVuo5RWUHqOmlPoK?=
 =?us-ascii?Q?i3VH5sOu4wFgYXdzwLzO+M5+nF5MYQ8/V6N2xAtCBlHFVP17fv5nesACHP2t?=
 =?us-ascii?Q?VkhYH1I2ffpHhJ5PZa88esychqL6cWdHCY80DuKfGBPTf4I1czB4HGPx2zYs?=
 =?us-ascii?Q?i5ZFxdfw/r32748cnfSJSR1GpAg9jdCv0WvZ1VmefLJwSl3kXXhD3M8Y/lWx?=
 =?us-ascii?Q?4C/HK3hGNvqZTsaGhx179sDlC7K/jforI2DYAIa4Vi/gS64lKL8bUiP2Fp4q?=
 =?us-ascii?Q?UgDc9anHApjGlmLci4eysZrSwlDIQ+2FZqeVNIJOHk8vWbcF8z26FoydVVe6?=
 =?us-ascii?Q?H76UTnsZh7mLgujDBQL9ldpeW/xj1HaGl3hSvaVoHgugxq3l0lG9soTjC9Gb?=
 =?us-ascii?Q?aH57kKrbdvaW0WNp0+rRy3baR0BkuJ5dh5eoHEzMXSqaJFhp+4WVyeNJK9OO?=
 =?us-ascii?Q?gWjJjoR04QPjcYsNMylEJ01GCMhecISuPgrQMmxJnrepLsTy6eSY8ok9DUMA?=
 =?us-ascii?Q?574eIv68Eew9LH02aYvlbgHb0Qg01/xmQwzS3OS45Q/NxZeLIHgwxn649ZbC?=
 =?us-ascii?Q?1nHb/icklebWOYsimscp7BVjgmiI2J9BtmtiBQVxCh7COrCy9QiRfSaP8zEU?=
 =?us-ascii?Q?NJ5FX80ZTQMxTK5mjjmn68/lkq6Z4uoFOas8nAGFK7jFgwdVQOyq3ukjgIQs?=
 =?us-ascii?Q?9PUlFrOfNfOuy7Z5lBEA54xfjj/REIxAocD6IukTBQsFZCaIB9Y+89/b/E2c?=
 =?us-ascii?Q?UgVKgCq3HwJCn+XPvz5deQeWwFcg3Cq5xQRnqnEx0DpUyA02c03/kkNVjxUo?=
 =?us-ascii?Q?FF6jAPvIDbLVYFQeVTNO43pET37YrFrC18CauMLPXMccbjoXQkmOKEqonAB3?=
 =?us-ascii?Q?gtMNarVC0Atdkqiyif6o3+YT825RFcsP822As6utBm8xZtSPFORAXXmFiXTE?=
 =?us-ascii?Q?wvQvC5OsJDBs3OCWRszmOTsF7qPcmC5ANG7cSLi1+ru/nyVlKP/YGpLfbc6/?=
 =?us-ascii?Q?e8eTv2VVrJSPpoy4peETBTP0wx4vefUpB9RlLyKSfF9R9LSJOShWMzHewJW0?=
 =?us-ascii?Q?O1MAA3KhnnLmd9eSDTqw1RJu61IEqsIPKy1Zb7NMTf5qljOWTBWfEVtHs8uN?=
 =?us-ascii?Q?bnMx8LO69qE2Xh6ZO8hCdZObZQDlhRuLdDsKV+943qnnacj7MyKqhvK7CqlN?=
 =?us-ascii?Q?DOLGV1Xt+tlHXvHUr8X31TIZ2xklyCLl0Zxb+IEmQmVeXcNMaYKpKSfHrtL2?=
 =?us-ascii?Q?PVP4yLhJBZy1EaGzkMtpoX+Orhq/wgCAMB+fAL927HsWUNqNaHhfVhEA7sgv?=
 =?us-ascii?Q?3D1dUh0Q3HenQraU/xsycnORxC71R+pmnTui3x4jI48LSVyg?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4280cd86-378a-4a4a-9d28-08de82264798
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Mar 2026 00:03:25.6645
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DaalxubAlPn2DvMwQQW9MCOBXFmStuMN1lXRLskzCwZvzDyuBIrQsx9DG+O3GZ17
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB8230
X-Rspamd-Queue-Id: 4A0FD180004
X-Stat-Signature: m3k44i8pqwu8i4tfrazn8perg1nn9gqm
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1773533011-555212
X-HE-Meta: U2FsdGVkX185GtUaqDXFI32k7+pe1e+UmnSZSWgLQGKmtV3n0Br+EiSAdgyF+3mV6RoFR6yEkJTo10qgLY7fcLkhG3a0zODrL8hyMfgXI94QTCBUQG9ye0J8p6WjGbOtLpOF6rVOwrh03rCI7IyzR+jS9gXspKyshvQL7BiQ8r2UjshG+nzygAAY0w///qj0j7cQH0dByVcww1xWCCufjdccXdW73b80kF+K+hJV96Erv9c0oQdZ1iqSYll2nWuZzglbiTjJ1gBPApMUyzLW8AWjcfSesY2zQXurIn+Qp5HdvjroyJ7NwbgLw13wWohdWdCbBosD+cj+mdM0AyxEJ24f3VojggJ6dOMjCcRpZyME5vnrW7RZqxhobP/MC/X3MQtcp3q0JQYnbVXAXG2+oKOObdXvTA8UqVdfw/wThp3U8FTFQJDVe78VbkzV2EtTCdZKj6L6rcDMSsPrJkv23Z6ND4ThFZ9ZKQMz5K6tDGfPq+d6SQuPh//RZUYg9+uwKSzECtxgSK3RdHmZ3yslq23cOgLjJ8VrZJEdjGmT5vB1zBXGodDyiq5YNPX5S1F910UbbM0/R1/74CqUeNZ6oh18eqWeTCj6xF+1J5wwL/BIa5yx0D9AtRjdXWrv4m1kLFr6dSGixgeVqP8MHNELJk4QHw2VZO/a/oLGP+fcHCD3fMF2Gm7yO8aqkJrJDy5LHdHZikhQUV3IzL43GajFbpprhLx1pceeTTzk71IVRtChX/n2/f1BihEUkUphcuMnsmcWsSD9wV9YPZPpvEgpgDbHU8Bdt4pLAbEMzUiqPUu72NX0QHZjKGOslZreL9pQyLU4EXjmVEUmFKjGPb6DP48t6dJJcdLMIuuZ7srvvujUyVeKdUAvz8xYsQeruy8iQp66YQXhqJDweQhdnGJ9yh3665hOYMJysqLwWAFPKBwIAED8Dr2ChFM3M4Io4crrusoWDoWynLMhx1wQyDT
 g2q0aAJW
 41wqcydaUpKSWrJ43IFRYcdTtCXxGICntb+sOGylsdyy5CQ8x4jAGthLpnU9dmaTDPYVHpdZDyL332P+/+I5MZJsdqw25Hfd6AI4CFX+jeUvUPSqULRvgbkJvL3pjyVnb0WAVddUknWgyPYJ3rK4xVTFfp4QKRWuyK2jxgMkCKgSThqxNjT3EOafi0caJq+JfnrzaydkLSMFMJG4xitnpnrKkUkwboJqRffdgeqxlfbY9uxCX++o/QBLKtMqrFGSsJBH4C0IDLDZHbo1BhdwjzG86hABsWtLnEfXXZCMQhefYq9oc/ML6ZWeXR4CnTkZ5gt9Y+yOn6UTXl4/qGP8sWwaMNcRzsgYJOUuO06yBsAR6P3RIspKNI9mNl7OA1KBIxDF5eZA65aQKOb0jpOVfrn8kvlMzSRS2OtBDOpeZF2RGaAwYbvyLFm0RgGUI8zo1hjqZitN3cMPFeD+0sz3rhucJmwjh127cdfG/rxkj+SrUfsJPiatuI0VvuGkrWo+w4PPUSr2r4sYQNqQHH0SjgP8LwiOHiVC/EoQCIFTOlNLL6pTDp9jbzl8zcKxGhSUv9clgoRDlyvZ8aCo+w+avESahDEwnDLqrVh6Y35Js0qqK2dwGp+GMpBQQIA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 13 Mar 2026, at 7:40, Zi Yan wrote:

> The added folio_split_race_test is a modified C port of the race condit=
ion
> test from [1]. The test creates shmem huge pages shared by both a paren=
t
> and a child processes, where the parent process punches holes in the sh=
mem
> to cause folio_split() in the kernel and the child process reads the sh=
mem
> in 16 threads to cause filemap_get_entry() in the kernel.
> filemap_get_entry() reads the folio and xarray split by folio_split()
> locklessly. The original test[2] is written in rust and uses memfd (shm=
em
> backed). This C port uses shmem directly.
>
> Note: the initial rust to C conversion is done by Cursor.
>
> Link: https://lore.kernel.org/all/CAKNNEtw5_kZomhkugedKMPOG-sxs5Q5OLumW=
JdiWXv+C9Yct0w@mail.gmail.com/ [1]
> Link: https://github.com/dfinity/thp-madv-remove-test [2]
> Signed-off-by: Zi Yan <ziy@nvidia.com>
> Cc: Bas van Dijk <bas@dfinity.org>
> Cc: Adam Bratschi-Kaye <adam.bratschikaye@dfinity.org>
> ---
>  tools/testing/selftests/mm/Makefile           |   1 +
>  .../selftests/mm/folio_split_race_test.c      | 380 ++++++++++++++++++=

>  tools/testing/selftests/mm/run_vmtests.sh     |   2 +
>  3 files changed, 383 insertions(+)
>  create mode 100644 tools/testing/selftests/mm/folio_split_race_test.c

I got some AI feedback from[1].

[1] https://sashiko.dev/#/patchset/20260313114037.3593642-1-ziy%40nvidia.=
com

<snip>

> diff --git a/tools/testing/selftests/mm/folio_split_race_test.c b/tools=
/testing/selftests/mm/folio_split_race_test.c
> new file mode 100644
> index 0000000000000..cf5a5666bab77
> --- /dev/null
> +++ b/tools/testing/selftests/mm/folio_split_race_test.c

<snip>

> +static void *reader_thread(void *arg)
> +{
> +	struct reader_arg *ra =3D (struct reader_arg *)arg;
> +	unsigned char *base =3D ra->base;
> +	struct SharedCtl *ctl =3D ra->ctl;
> +	int tid =3D ra->tid;
> +	atomic_size_t *failures =3D ra->failures;
> +	atomic_size_t *verified =3D ra->verified;
> +	size_t page_idx;
> +
> +	while (atomic_load_explicit(&ctl->stop, memory_order_acquire) =3D=3D =
0) {

If parent exits early without setting ctl->stop to 1, child will loop
forever.

I will add prctl(PR_SET_PDEATHSIG, SIGTERM) at the beginning of
child, so that child gets TERM when parent exits.


> +		for (page_idx =3D (size_t)tid; page_idx < TOTAL_PAGES;
> +		     page_idx +=3D NUM_READER_THREADS) {
> +			if (page_idx % PUNCH_INTERVAL >=3D 0 &&
> +			    page_idx % PUNCH_INTERVAL < PUNCH_SIZE_FACTOR)

page_idx % PUNCH_INTERVAL >=3D 0 is a nop, since page_idx is unsigned.

I will leave it as is to show the range of page_idx % PUNCH_INTERVAL.

<snip>

> +/* Run a single iteration. Returns total number of corrupted pages. */=

> +static size_t run_iteration(void)
> +{
> +	struct SharedCtl *ctl;
> +	pid_t pid;
> +	unsigned char *parent_base;
> +	bool *is_punched;
> +	size_t i;
> +	size_t child_failures, child_verified, parent_failures;
> +	int status;
> +	size_t n_punched =3D 0;
> +

<snip>

> +
> +	/* ---- Parent process ---- */
> +	while (atomic_load_explicit(&ctl->ready, memory_order_acquire) =3D=3D=
 0)
> +		usleep(1000);

If child exits/crashes without setting ctl->ready, parent can loop foreve=
r.

I will add waitpid(pid, &status, WNOHANG) =3D=3D pid to check child statu=
s
and break if child is gone.

<snip>

> +
> +	atomic_store_explicit(&ctl->stop, 1, memory_order_release);
> +
> +	if (waitpid(pid, &status, 0) !=3D pid)
> +		ksft_exit_fail_msg("waitpid failed\n");
> +
> +	child_failures =3D atomic_load_explicit(&ctl->child_failures,
> +					      memory_order_acquire);

If child exits abnormally without setting ctl->child_failures, we will
miss an issue.

I will inspect child exit status and fail the test if child exits abnorma=
lly.


<snip>

> +int main(void)
> +{
> +	size_t iter;
> +	size_t failures;
> +	struct thp_settings current_settings;
> +	bool failed =3D false;
> +
> +	ksft_print_header();
> +
> +	if (!thp_is_enabled())
> +		ksft_exit_skip("Transparent Hugepages not available\n");
> +
> +	if (geteuid() !=3D 0) {
> +		ksft_print_msg("Please run the benchmark as root\n");
> +		ksft_finished();
> +	}

ksft_finished() here leads to a PASS status.

Will use ksft_exit_skip() instead.

> +
> +	thp_save_settings();
> +	thp_read_settings(&current_settings);
> +	current_settings.shmem_enabled =3D SHMEM_ADVISE;
> +	thp_write_settings(&current_settings);
> +
> +	ksft_set_plan(1);
> +

<snip>

> +	for (iter =3D 1; iter <=3D NUM_ITERATIONS; iter++) {
> +		failures =3D run_iteration();

run_iteration() has several ksft_exit_fail_msg() or if it crashes,
THP settings are not restored.

Will add signal handlers and atexit() to call thp_restore_settings().

> +		if (failures > 0) {
> +			failed =3D true;
> +			ksft_print_msg(
> +				"FAILED on iteration %zu: %zu pages corrupted by cross-process MAD=
V_REMOVE!\n",
> +				iter, failures);
> +			break;
> +		}
> +	}
> +
> +	thp_restore_settings();
> +
> +	if (failed) {
> +		ksft_test_result_fail("Test failed\n");
> +		ksft_exit_fail();
> +	} else {
> +		ksft_test_result_pass("All %d iterations passed\n", NUM_ITERATIONS);=

> +		ksft_exit_pass();
> +	}
> +
> +	return 0;
> +}

--
Best Regards,
Yan, Zi

