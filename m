Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6D10FCD98CC
	for <linux-mm@archiver.kernel.org>; Thu, 11 Jun 2026 15:14:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B30716B0093; Thu, 11 Jun 2026 11:14:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B08216B0098; Thu, 11 Jun 2026 11:14:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A1EE46B0099; Thu, 11 Jun 2026 11:14:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 969D06B0098
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 11:14:20 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 3D3E21C36DA
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 15:14:20 +0000 (UTC)
X-FDA: 84867977880.03.E4FED68
Received: from CH4PR04CU002.outbound.protection.outlook.com (mail-northcentralusazon11013051.outbound.protection.outlook.com [40.107.201.51])
	by imf27.hostedemail.com (Postfix) with ESMTP id 3DFD440018
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 15:14:17 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b="jdyE4G2/";
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf27.hostedemail.com: domain of ziy@nvidia.com designates 40.107.201.51 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781190857;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LlBUea1nb7Lnjf5ezViQA+tQzekJPY6PGtl6z+ZTNhw=;
	b=2UNHBpBM4KVRxrnTx7whTBwZAC6d6d62ebPLwPKHXvczSw5TJitlBRyH1VpDP2IGwtiiX2
	iuY2dXluB+6Z4hTuG5+LVOX7jiemEcdh5IW9lwi5XWtz3FPfzVY72gT9BJwWeCaKjUHFcL
	hKURX5mco3GZUHkIvy771GCbpNhEodw=
ARC-Authentication-Results: i=2;
	imf27.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b="jdyE4G2/";
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf27.hostedemail.com: domain of ziy@nvidia.com designates 40.107.201.51 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1781190857;
	b=e/FoAN1Qsq4+jmst5N1vsfAtrNYpdKG/ytOTvMYUnIlXoInb+iBpbP1dB0FjcRGanMR0vp
	4CvZkZTtxNt2PLlHZYluUAFQ9DCij487HLew521902IkU9NXQLiAErR+gUcdwnGBTgegwr
	DwX0N3QzaSYLXJXN46fZZ+GR8q0pkTc=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=qeJB5b9ZS8p6Ke5HN8cHCtAb3E2tuQkUjIv53fBXw3itc9cIoH/osKu9vdH2U2s7z82p3MMuiEXSPLF5bKKbpp8NawPji5V2voazei05ZU9toQggeYbyfgrcjyfoVT0k8KWlKFglV87tzbLLuRGvHdrh9FQDKhf5aQCVSqh8EbDEnN55IZzWpbog6n5vCOJSfG68YtY4yS2UcNu9e6ricPIlzAdsB/2vSaQrnVyIcrbodIsIIcoul1q64rMtpnWPbW4iNGoTpwFrzwari6IkS++EjNmEeJ1uYaMT832BYJEc+U3+wwxJYlPH7EXwNz7GwR/IS3DggKXpdMqZemYwdA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LlBUea1nb7Lnjf5ezViQA+tQzekJPY6PGtl6z+ZTNhw=;
 b=baNT9nUw8IZ0w8+hvWFNjEluD8q21bhhEzzDXcQn6alJdsWzgU0Q1tnIzRTYpm8Lu1N7LhwAQ20RfU/iiXx/K4AfIVIVz7Uk4CQX3uAQLY18xOZ09+POlg0TMkxcy44mTaX2UjoVxKInsoL8tEyPnreb9xTCLnPYDwgc0kQoivnDxvxvUBPNmkBvO4ygyfRolQI9XVJEQvpdWTMs6vmuyxa/tYXtOxA2p3PsS4xCaBZ009iq10VbENaiNFnhMxDyz+zrJurNSUFiNye1kV4maGnQqr/DPU3FH8ayZ32is1X7GmVZH4Wx8S+a/uWuU6xwIjTXy+3BmFvkU5m4p1UgtQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LlBUea1nb7Lnjf5ezViQA+tQzekJPY6PGtl6z+ZTNhw=;
 b=jdyE4G2/8pO5SZWnSD1BfZwzmfx0kTxxdePY4fDX1m0MxUF6xa6+3CyedJEJ/3U93mcujRreOu9eYJU+cz9dsJApTIODazoLK8E1ZjfXRUULSwYNOelxoFUk+KuRPVfxJORAAxMTQ8v56eRde7j2vRfCADQ2GT4S3uG2OmYdqgJNttatFPFV75+qgW9k0EZmLUHHvXLNJtbY8Nh72AzSwMSTY85OAfOWhQqE5MtepwwHInegfOKjqPVSKXLFWgrlAmqPViheUyHSqgHREqoRUyLQHgxM+UD2fpobAI6JxBMZqDI+hzjdH5P//XoZ6cXK2GSU2Q+O2luJnCj56UrINw==
Received: from BL4PR12MB9478.namprd12.prod.outlook.com (2603:10b6:208:58e::9)
 by PH7PR12MB6884.namprd12.prod.outlook.com (2603:10b6:510:1ba::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.113.13; Thu, 11 Jun
 2026 15:14:09 +0000
Received: from BL4PR12MB9478.namprd12.prod.outlook.com
 ([fe80::4d08:451e:a51e:33a1]) by BL4PR12MB9478.namprd12.prod.outlook.com
 ([fe80::4d08:451e:a51e:33a1%6]) with mapi id 15.21.0113.013; Thu, 11 Jun 2026
 15:14:09 +0000
From: Zi Yan <ziy@nvidia.com>
To: Karim Manaouil <kmanaouil.dev@gmail.com>,
 Matthew Wilcox <willy@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>, Nico Pache <npache@redhat.com>,
 Luka Bai <lukafocus@icloud.com>, David Hildenbrand <david@kernel.org>,
 David Rientjes <rientjes@google.com>, linux-mm@kvack.org,
 Andrew Morton <akpm@linux-foundation.org>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <liam@infradead.org>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
 Lance Yang <lance.yang@linux.dev>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Kairui Song <kasong@tencent.com>,
 Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>,
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>,
 Wei Xu <weixugc@google.com>, Rik van Riel <riel@surriel.com>,
 Harry Yoo <harry@kernel.org>, Jann Horn <jannh@google.com>,
 Johannes Weiner <hannes@cmpxchg.org>, linux-kernel@vger.kernel.org,
 Luka Bai <lukabai@tencent.com>
Subject: Re: [PATCH 0/5] mm/khugepaged: add collapse hint machanism for
 khugepaged and use in mglru
Date: Thu, 11 Jun 2026 11:14:06 -0400
X-Mailer: MailMate (2.0r6290)
Message-ID: <BC930D36-A35E-4D68-9DA1-914E4223FB6B@nvidia.com>
In-Reply-To: <20260611092313.7d4knb2irt2rtswu@wrangler>
References: <20260531-thp_collapse_hint-v1-0-866339cd4c2a@tencent.com>
 <CAA1CXcCLwS=3CY48oFDMUsHEkBkJzLWQJke41PMQE65k2DdR-g@mail.gmail.com>
 <aigktfOjYwxhzEhb@lucifer> <20260611092313.7d4knb2irt2rtswu@wrangler>
Content-Type: text/plain
X-ClientProxiedBy: BN9PR03CA0338.namprd03.prod.outlook.com
 (2603:10b6:408:f6::13) To BL4PR12MB9478.namprd12.prod.outlook.com
 (2603:10b6:208:58e::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL4PR12MB9478:EE_|PH7PR12MB6884:EE_
X-MS-Office365-Filtering-Correlation-Id: 1fe005b7-3cb7-4d06-1921-08dec7cc1630
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|23010399003|376014|7416014|22082099003|18002099003|11063799006|56012099006|4143699003;
X-Microsoft-Antispam-Message-Info:
	TuQertveGEH8YUL/Zfg8Ph3LeMph5PNS7NxMPBwBMo/lsq0OYDP7U+B+ujlgq8HolvgiarqPZsifrvO/NdHLheVDn+GLncbOqopjQDNJGb4yTY1182Z4Q+XOYVxq0wwVKMeXdboNSVdz4pwBw5hTlwUaRARQEABlJIM4tIrEzyZSG2/IM0P4WZeW3gCFPoiz6z/bwkDRxvpqKAVcDVgi/sw27sY9rxXlETwnyc/MD2UR2WZUCnvUPwr5CfCpN6lycPrCAkNfZ84qyJk1MflbJp5SnqmC6jEtziF1ZdSdZGINjToIeWchEvGDgWNvxy3P5SvJb+C6Iw0FKvLkS0q5zPzUFZI1zqIYZLYY6tY9di1qw3RJz6nIaI72/ZhnKZ0ISbZ4JDZY8d7hIke71P0SRonmaWHfEUamUvmfGo3D/BsrBXcaebJnShUlHUf4Zxk9EG0y20zBPtkWGeocHTqyj5tbxv7X72jda2IidtNlB49mwYafdEfihkioUZpX2nFoSzsNOrJeu0jGupIHyNF7kQY1ktM271PjsCo50qEkk9xu/MLbN33qkuPUoAYov5ny/1I4apsHLREKLJRnd8UaCg1RZeQYT7OnIzN3e+1wau1H13U7b7zc/DzZTCYwKG3skLgG0CFCMyVvxZsTDfSmejRzR3ie9cRPVel2IGemVccIWFEdSAD2zyEJ1V5YTMgY
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL4PR12MB9478.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(23010399003)(376014)(7416014)(22082099003)(18002099003)(11063799006)(56012099006)(4143699003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?/Kc1Nk8d61ElJ8wK9OVq5SXsOVMnhlqCWfGXdFy80akugMG7wL5Pn0mOxMfx?=
 =?us-ascii?Q?Zl7Yi3hiXwxvxbWYodCxI+XBlmO7fPQILuO0WT18yIBJIZrbrblDEi8mD8jY?=
 =?us-ascii?Q?NGza8yToSGCNzyxqY/NiqaNwZp3WI1HU7xdGPMpVCZr32h7FpV+p0Fb9iQNV?=
 =?us-ascii?Q?hiHgbgvNavEKgGSR6mJEvkzE+EYkvGU3KP4zii/D13LIoYSiMU8Ydkf7rhF2?=
 =?us-ascii?Q?aKqE0IPxRM5JPFWFP4UYEJS6W6q0r/xICcFpPnvNifUfR1/9VLCzuih5yBr+?=
 =?us-ascii?Q?ZEIBTavYWo4yjKJsuLWFP8IJJx01zDagkTm26+HSoN1xRndRNZeR5sUZkyBR?=
 =?us-ascii?Q?sA0Bggii9OqjAtBJd48IDrEiFSEltxCxJR1lbMnRrHMBMa4KnD4+mEOlBKjl?=
 =?us-ascii?Q?qX+nl7ZmvWWemO36R3QWwMqx0fCNoK7KZcBkWazdbb59zHMXxOV3FsbszauL?=
 =?us-ascii?Q?H65Y+WR4p6zrDDB7VDT05R5wY6uSRWf/5uGA5Ha8i/839iTGGwnF/zhOsKW/?=
 =?us-ascii?Q?jXHdWHbQzqbZcM7OQ8it6dwXgEhOjvK+8xwfvADL+xdhHe8MvX/qqqAdnyJJ?=
 =?us-ascii?Q?p4M7hfRHWzjtw9drtkCcjC2GZ+Y9Wb4gMSfsNhNsy+42iyRON8+5Mxx1+kBn?=
 =?us-ascii?Q?VgdVQw0NPdRQlyhDiYsjSCgFclQlxrsRsR6YLbDV0uUhqiGIt/PUgU/quzUH?=
 =?us-ascii?Q?V+EJ+oQhR5VTU7ACkRmyX3sR5WdsHTYJhvIMVXjTpNvElyUIC4Pn9Zd2DiPG?=
 =?us-ascii?Q?dckLsvFGOrNfb9uLLSdwtkUo76GRyJLFI8yvZHRfkzQF9V1lAEPXq076+TS8?=
 =?us-ascii?Q?g6sAnT2XnKw5DdAC247AILx7hMt3+1Mdw6QEv3B9dWL1qqx+p6ywTKlNZ+Fw?=
 =?us-ascii?Q?vM2sc5Jf+gDQndUCb8zWhS2i2e0msra7ciOTwiY6qEo4pdNy8jtXXo1la5gh?=
 =?us-ascii?Q?iKygDRpmmcr/JvqT441iW0nhBsq+o9SaZsQjd1Om/CYujnXhWZAntALjPR9T?=
 =?us-ascii?Q?bZoBtictV9FL7LGAZz4uZv7gMjUq/t7xEWXZGsCI2yFP3TqtuZ9wIM9uJsQb?=
 =?us-ascii?Q?shF1alwWDPOadf3F5mVW/KvonevSjI0If1l7TN7mdUjOiLcmfZi+9g2+cWL8?=
 =?us-ascii?Q?tV+5IEi/1Q90lx8XooxcVnCpfguJxAnMPnPLxDnJo9FhK1PA3y6DXe0pDrTN?=
 =?us-ascii?Q?UgVWUtCv9bzb1mJQ4BH+U030DhLRsC+u7vWgpjHR2KCrleEZ9BTlw8LEUXIT?=
 =?us-ascii?Q?afJ8OsA0KELoCvjFueUl3jHn4uqmo5JW3S+P0Am6sRusUY9mtTJtzVj6m6bQ?=
 =?us-ascii?Q?HWn4ffyloI2IzA8k/LyF0BnV85HDMnhI3bXQvkqeV5Ml7a5OcydC1DLKx1j4?=
 =?us-ascii?Q?l6iBiVqYSE3snJ86pjBrhF6lK5CBtx7752LS/g/IDHCyLOCi2GAfu4Za8O9P?=
 =?us-ascii?Q?IKYkQVyRPlNSWRMLeU+yQOe2INRGnwbfqkROI/EtL2LeGSWvCFp4I5axYxHn?=
 =?us-ascii?Q?GW5jOS39GZZhZnVP9zaSePJsBxvnGlHDDWjE8fS1nV3a0l6mhztK5v3EGW0g?=
 =?us-ascii?Q?eqNxZVdEsdNoOOLcsyk5Zi18X42fLFWH1KMjE/W0LwHOBD523MJED+0l/WWO?=
 =?us-ascii?Q?SQ7YuALTfeAO6xksaebQLxjiNE5W+H1JBdRKgvN7iyUCMZsbuACeahNeZzRK?=
 =?us-ascii?Q?GlB2BaUfnB4f3PYU8gIHWOBJWDKESuWcTk9lHiHsrlxgoDMc?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1fe005b7-3cb7-4d06-1921-08dec7cc1630
X-MS-Exchange-CrossTenant-AuthSource: BL4PR12MB9478.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jun 2026 15:14:09.4891
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: y1ggBixCW1xHMpbTTLOaANMAowIVdQUU/iKfPw5DDxyxwNS8M6GVbgvy9syEQYEl
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB6884
X-Rspamd-Queue-Id: 3DFD440018
X-Rspam-User: 
X-Stat-Signature: 7fxtc9psknmkwmbmb8wercqouzfht1ic
X-Rspamd-Server: rspam09
X-HE-Tag: 1781190857-619774
X-HE-Meta: U2FsdGVkX19Q0oEHwpqDIxj4HTjlzCv+udz9rUAZUVfEmdi6JImnMmupwhzzW11f5CrLz+v9INymjR7NaMqb6eSyjMrYETuG/SNMkwSehTKjcI5aMyNajL6xYxuGNseckLgsNkXPrleteAooWTV60AlyjjixTJcadKgQceMclc6ato/Fi6xJPRgpxsnktl0CBGqQMjFmJYP/BudhRWJXPB9QKjcyYysfxCI1USbGWuKiEWJOqLpvsE6qDSuTiSWEbgZXdiqLEf4yCkxo+IcU5Y0Iu+kTPuESWGhjobI2u+hpLGS9ypbWFPtUCqzBNJR1bo+yyEehQFE4NCwTwKPT1X5k+ge2kQcE6A9F4RW86YN9dGFcXrW/Ny68UkMHlLikrrDQxw+jnSsGIG4zXWWiVtiWMgX34EahrXyBZyG+UGGHdLGigNCbhwlq9bhmv6eZxAg0lhLmxeCXSA03SOKf8tBANTQC/ohxCMnOC7gtPGhCx9jITcdn5kPEBSbQEEZJGeNJxJITUpTeYhCvL/BEYmJuUGDtKWfpNOtSQfVcxmmlAY5DB+IMsZ0vAvKngPTQtjdJMrzMeBBCQ0DGregxQUGZzEmKdsaf8kpvoMJx0V2TlUEXXAXtMioxhly9bPXGB/z9mAwm4JsUuagWG8jievNL8X73bfZCXDRiFXefI5G7TUrv8Fj9mQbPirVI7pqcGQxVvaifz40BcOUupXZVl0Np/ruZ6LIzdM1MkZKdtZa96LNMoP5RB6g7Fy3LOP7+yyu7qlLA3gSR8TJP84YZ+rwABnu17IdaKagRNoXFbGi6YA+v7r1yZEtrY7T6SpUtfO2OFHAs781WeZxpSHS+35nBeZanpr+Tx+MtE9usk0BAZowAxdaurAHW8nKvGmSpO+EnL0kGQe8vwIE231Ng+WB3zzDOLgnjaB6YHVFZ6X7oDIgAwe+9dNfLEW8pVx3C8mp5p88f1TbXzEybCy6
 Rf9LoSof
 bLB4+PFlwdiUm34ocrOYWRQzbseyFL4b1AScMYRCaBXhT3Z4drEn/2EX2apLU8ZQYjsyFL7HYf0DyXKMthE/ie8FFt7b+FPBWv+aD9o1rXPRvRgPjz+EfcLFmQIUh6TLAG/W2CVxmK+I8XBfvd5kO69Koh1POvBcDxWFt8IWqjRx4lwdgc5HGTpat1irBpnHDh3u1QzQtzDX4b8Xwk/4sl+aR+5n2tyJgKAyObD6i+SxftQadt91LzYv54dqNUQv0fagrB9Xc1g7ogGGC62IdNG6qyfly4+UH+Kccboy+IoMdSmy6IzompfPbEK9BCbw6s37cIdLz0zIEVfEMwA9Y1FqM9vZRHZh0krq+Qe+wdogIse3Zi18InB4soVKqSR3qq/8yCfAB2lsJ0rfb6ZWrtl7MJovtCbP6NYUSPQA0UgtAApFt/bQaDRAsJT4auO2McdKs
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 11 Jun 2026, at 5:23, Karim Manaouil wrote:

> On Tue, Jun 09, 2026 at 03:44:21PM +0100, Lorenzo Stoakes wrote:
>> On Tue, Jun 09, 2026 at 04:17:45AM -0600, Nico Pache wrote:
>>> I had future plans for something similar as part of the thp=auto work;
>>> however that requires significant thought and investigation into how
>>> we can properly gather hints for collapse/split THP candidates. From
>>> my perspective we'd want a more global structure/system outside of
>>> khugepaged, that would directly call khugepaged (and others like
>>> split, etc). It would also tie into the allocator so that at fault
>>> time it could leverage the hints to make better decisions. My fear
>>> with this series is that making a decision now might complicate future
>>> work by adding complexity we may eventually want to remove for a
>>> better solution.
>>
>> I know this is future planning stuff, but I want to point out that we need
>> to see significant rework of the THP code base before accepting any further
>> major changes.
>>
>>>
>>> If you have the chance perhaps you can lead a discussion on your
>>> proposal at the biweekly MM alignment session.
>>>
>>> +David Rientjes as he leads those discussions. We could use that time
>>> to layout a plan for what needs to be done for this work, and for the
>>> work surrounding thp=auto as I beleive they will be interdependent :)
>>
>> We prefer to discuss THP topics in the THP cabal meeting, which both THP
>> maintainers regularly attend :) having separate sessions we might not be aware
>> of isn't really helpful.
>
> Hi Lorenzo,
>
> How to participate in the THP cabal meetings? Is there any public link
> to join? I'm working recently on anti-fragmentation, which is kind of relevant...

Matthew is hosting the meeting. You can ask him to send you an invite.

>
> Thanks
>> And 'THP auto' is a broad topic rather than a new feature. I don't think it
>> should be seen as a topic 'owned' by anybody, but rather something that we
>> as a community should discuss.
>>
>> Series that appear from nowhere trying to implement significant changes
>> along those lines without community disucssion will not be hugely
>> appreciated :)
>>
>> Thanks, Lorenzo
>
> -- 
> ~karim


Best Regards,
Yan, Zi

