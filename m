Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 70FD9FD4F1F
	for <linux-mm@archiver.kernel.org>; Tue, 10 Mar 2026 18:41:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 93F476B0088; Tue, 10 Mar 2026 14:41:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 90FDC6B008C; Tue, 10 Mar 2026 14:41:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7F6E96B0092; Tue, 10 Mar 2026 14:41:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 5B30E6B0088
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 14:41:36 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id E7AB41BD20
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 18:41:35 +0000 (UTC)
X-FDA: 84531021750.21.CF1278A
Received: from PH0PR06CU001.outbound.protection.outlook.com (mail-westus3azon11011063.outbound.protection.outlook.com [40.107.208.63])
	by imf29.hostedemail.com (Postfix) with ESMTP id 38A05120010
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 18:41:32 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=cH+tZ6sR;
	spf=pass (imf29.hostedemail.com: domain of ziy@nvidia.com designates 40.107.208.63 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773168093;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=O5BU0PDpEDpQ9QU0HiAJFbM0RiTtmI0MhsOsoGVrhe0=;
	b=3fVSgqqc+eQtV2QhL9PjLq38BLGNx1RZvXh9x9hTHVYsbeBuCwW93ZSWdrQtBRCOK56+JP
	oXEHhXkFHWzGnI2G0WMZUyfdkzLFZMN1JLgXjuiTV7GCHDN1sn9PyRXCsRcqnridtbYut1
	Wt1u/xJOErr0lZSgkxhNJSiXuDbRKgk=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1773168093; a=rsa-sha256;
	cv=pass;
	b=GcpQCeCr6NZPbO608Tye8ax/nHJgSDzK6T+XteC9RV8ZrKatKV6H6fPEtw0DPy9CDu/ixr
	7FVtWq8BPUlF8FH+Z21MEZBUu/NWI7QhSqsrtLKlM9VRPR3TfQgXA0DJgXYVJxBEAm1CgN
	uX/zWB3Qr5mJdoCmFO+yWTqfk3MkXRg=
ARC-Authentication-Results: i=2;
	imf29.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=cH+tZ6sR;
	spf=pass (imf29.hostedemail.com: domain of ziy@nvidia.com designates 40.107.208.63 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=NB/ZqrMgQcv+Xa0wmsruHMDVOz/pkWFNiLOIXP2+mjRZfMiij4LfulWDN9G1ihe9dYpstV5r7IeYT1XlDsxciuF0tXT7LHtITFuRfzkFSjQkKVuch2qmbXUu2LaUo0rpNCTbWkYAAkByaSmPd4pNjuKyZF+2iuS50xv/6+lttaW9eJHKi+n9iFrJ4JAH4PgnTmTND0mNzUwKM+vhxtfSaZ+KX2C7agcUvV/vwrs7ZFE8PcXub/2sPhKAmSgH36uqWboCusqA/+vPuxf7Zzl30KAAgCbCKS9QEqq8DENDH+TksE2e0/8jq7QnnMh1VDcKPV2f2oVkeVeCOVNIYeQX2A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=O5BU0PDpEDpQ9QU0HiAJFbM0RiTtmI0MhsOsoGVrhe0=;
 b=ZCJp1xM39DkhZrgTRJFTLgSReEHkXImM9UpVNRuvqEJUILJDSDg1GJ1yWDhgkY8Ppdl7/M7Zh0M1r67PcamZxPNx42W2v4T1Rphld3TOtrDLX1PDlZG5YMqxfl1vrMUY4Z4+CnoPi+41F/ON5pVgqNQouVbdw/F2vaAZoGjoi17yr7VUugJyKMSG/XFPwYj41mZ72/PTSoSIY/fp93sMjzupLvc5qhDGFpKC+2Sx4fOajy3vKuez+iXS+Gl21eGxFEdSc6wl+7JZ3pnk8NIfeuAiCEkyQDNqLAnMg3m6vKpyLbFtuBfxoUIXDwDBUZ/L0dci6Q3EeZ0Yb9PxCVTEaw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=O5BU0PDpEDpQ9QU0HiAJFbM0RiTtmI0MhsOsoGVrhe0=;
 b=cH+tZ6sRKI6tC7gsEJGUt3pE0OH7pWltaPd5aXYu0cR6XARTYlDxhLHYjoY5P7AccML7NYZ5oXyk4BEV3s3geedKYzGllfQn8J9lM37EHX8G61bT5FQkEGJkG3HUvwWOHil3GaS5Adzl6VAde+DT7ZfM1mntpcd59N0h/LUzub7remnhLPpNDp7mxOoqdA5PmpAz5xC+VshEQhG3lo/0LjIdmeusuKNGrwBMIBaZFJv9YIoV5p+5FsWnZ6hHtOJX6X7/MewKaV7rAeZaEwiQO8s2JRwz/sJx63R2tW0ZD6Z6qgZFZn9oCR+5I6PDFJtR1sP4A4EToRHPL0ZUI4jODA==
Received: from BL4PR12MB9478.namprd12.prod.outlook.com (2603:10b6:208:58e::9)
 by DM4PR12MB6400.namprd12.prod.outlook.com (2603:10b6:8:b9::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9700.11; Tue, 10 Mar 2026 18:41:26 +0000
Received: from BL4PR12MB9478.namprd12.prod.outlook.com
 ([fe80::4d08:451e:a51e:33a1]) by BL4PR12MB9478.namprd12.prod.outlook.com
 ([fe80::4d08:451e:a51e:33a1%6]) with mapi id 15.20.9700.010; Tue, 10 Mar 2026
 18:41:26 +0000
From: Zi Yan <ziy@nvidia.com>
To: Breno Leitao <leitao@debian.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Vlastimil Babka <vbabka@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Brendan Jackman <jackmanb@google.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Mike Rapoport <rppt@kernel.org>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, usamaarif642@gmail.com,
 kas@kernel.org, kernel-team@meta.com,
 "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
Subject: Re: [PATCH v5 4/4] mm: ratelimit min_free_kbytes adjustment messages
Date: Tue, 10 Mar 2026 14:41:20 -0400
X-Mailer: MailMate (2.0r6290)
Message-ID: <65FEE4D6-B4C5-4CA7-BB9D-2B17A2CE0CC4@nvidia.com>
In-Reply-To: <20260310-thp_logs-v5-4-686099175bf6@debian.org>
References: <20260310-thp_logs-v5-0-686099175bf6@debian.org>
 <20260310-thp_logs-v5-4-686099175bf6@debian.org>
Content-Type: text/plain
X-ClientProxiedBy: BYAPR06CA0032.namprd06.prod.outlook.com
 (2603:10b6:a03:d4::45) To BL4PR12MB9478.namprd12.prod.outlook.com
 (2603:10b6:208:58e::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL4PR12MB9478:EE_|DM4PR12MB6400:EE_
X-MS-Office365-Filtering-Correlation-Id: 7a30a95d-0997-411b-ff47-08de7ed4a2ea
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|366016|1800799024|18002099003|56012099003|22082099003|7053199007;
X-Microsoft-Antispam-Message-Info:
	vRPASrOIwE9IxW1fnTD0bxy9/xglSo+v37/uJELtbKo4aKuOBsRSl+wDXlN6jmU8Fw5UJnHh96bMBy2WHSHLD9C8KS3fhP3rV9go9Vt87zmw7KTiKjEWayOUs0HLkYc76b5HV4sGL+8Cn3qRgrUaj34xzxNeoNRq7A8dCFsVUgATz6C3sg6YEqcfDcsGjZ0qeY8q7luaQV9WLRPiWs/A+8CNCim6nmpAqfXDlW7N0cHBEwIdNlHMu9TidBexV5kJkHWXG6D0wtVyPziIUCMGDCoa6fgvl41sxLlEK1kQOgG8+vd20I1jZ07gqapjmYMjBEwSR5Wy84o1wb/Z4P6aoX62A6fDCswKOzmSqtqd5TjwNO2ARRsEZkRs0o7WYEHtr326oyKsLQPGlhHGm4zg0nJV8igU/ZJsWARflg9zjYefCosWJxKAfw2uNcPf+wrwDwiZXncDeVcFPpxlOIa7DtWJpg6cuJDAV0Wox//AuCzqVYyBfa2L0Mc8ER+XPuCl7XfSL/DY1SFiA7q5IVARsZH7JARO0TplnE5Hi3y1SesJJ8w3MNlUixXmDpjHxvf5P71o1m3iHXHuswksb7OOKMOzyBsrz+H6oPwj59HbEk/ngHpEBQNNvtj73OxZauB7cBQiK11oxAY6ds0Go7+TR4nB3xVKFsE4Ss+wepa6XBC5PZ9WBBbIUXtYO7Vopk0aBYBb5TyJCpvVHViBcgywod/9ORKcbFDYFlusLw4267w=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL4PR12MB9478.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024)(18002099003)(56012099003)(22082099003)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?iFKiw9RrJ47n3fSe5/1RuZBWD6GATr9YBC4gVG56vIVxDaRTjybiV1qd9kBU?=
 =?us-ascii?Q?ec2PfITlX0eyu+BIhMq+PPoHeI/iHIv2zAH0GOG/8/tOTFAMltilTdraHQd4?=
 =?us-ascii?Q?QtUqckfJLhu+SuL73bxAIrrzq9GLmGshwoCa5Oz6IFDwYO5IROmzFOErY36i?=
 =?us-ascii?Q?vS3aVYJXATA6MgeaFkUZ+AESyBsYDSEt0leMS49m45HsJnXO3BlU6fSIkt1T?=
 =?us-ascii?Q?WR0dT7FTI+B7UVSRvdLI6Yw32kQksDE21O0ayPpESp/qBZeBDaOPaVsAViZN?=
 =?us-ascii?Q?QN6LGvj9M7jUaQYu/orWZeXDRz9aoez7YOD8xwNdrvWOTbpuxhvWV4ahPvCL?=
 =?us-ascii?Q?Kc7q6GymnC1gzoXguQ53sAlJaMnRT6DeGxqrTZ57/JrR4LmD7e6Hi4DPlhWH?=
 =?us-ascii?Q?Wt/DvwmS+uZzthdAwDGzerTNZNqEe26Y5R8ni9HHL3IGVNPbuHLz2yBgx4dy?=
 =?us-ascii?Q?yLwpef1J9VelZ01/av5GOkk277hhSjB31oODghKMn8EzWGtACYvW/IQWK2nk?=
 =?us-ascii?Q?ADgBYY/YeXykpjhGQX0bTOi7TDj01nmshMpZZVKZHaJtl8YMnFZ5S7cL9meK?=
 =?us-ascii?Q?xfouO9O7UhUh9yS5lSQxMnoG1bUNPRFzsf2/8VKPAqsC1mBdBVxk7j3rZWyr?=
 =?us-ascii?Q?sGiXpT7xAQUuW6qDXHRjT9azT1e8zP3jR7kzcOVZllBc4uqHtKSmphv+QUfL?=
 =?us-ascii?Q?dubFWVoA52zXrGp4St8ZmEmv0kVi1MEkKKMWBCuqOfdHuEWbva1qEt/smosF?=
 =?us-ascii?Q?oo30JVBeGPqeOmesanpmX2nKleCDRAggZCLc5PlupYZrGqf15T8M/nl4dja8?=
 =?us-ascii?Q?Bz9UGu5oy8ir5JCjk2jpLghMZ8YRaXqDYTQF18pAuWsUX9AedlgTrOcbJBYL?=
 =?us-ascii?Q?ViFP7c5B/3C/B7z9A1edL1TNTpmUPnn1lvCPtMxQZAWJWlWlwXdeNLn+R63G?=
 =?us-ascii?Q?Oo41wz6c1++8xbL0OLEe6oImU4k2ojQjHDZxj6WLweEgF5Ym/4g4tAKeZ+6Z?=
 =?us-ascii?Q?Lyhn2+d0U29FyQp8bza4M0iSCHPc29aQ+0ZR/b15iUGem7xooYuHpSdaUtmq?=
 =?us-ascii?Q?eFDo/2BoKwDwN2IH0Om/sM3UoiA/rLoo5cKLQpJnE0HybZCWUUBau3+5+Ivl?=
 =?us-ascii?Q?Nn8HrU3rQFo/kZgXjtzISK9JxdTK8NcdVvKFYGrOnm4/umzexUOZIvEUaGD/?=
 =?us-ascii?Q?89JYHDLKb1vPT/D+iqEEWIkmf/5hMQzFT8rfK+zi6D+MOmP71yvFVj47/I5g?=
 =?us-ascii?Q?lsJsfE0FjzZsAP1zl3jTMX3Y/xcBBesGp2wLeQzrdpP14EV161Ns03GeA3O8?=
 =?us-ascii?Q?5zjoyvPUxlSZOIjXA3oNbvpMqerag4+JsX2ESx0aQJJzNG3SV6mdOhqiFAHT?=
 =?us-ascii?Q?utdw3Ck52RxFwT48r/KdisSOM92hvPseUL3tjOni7C0DAMStxU9AIfK1t0iW?=
 =?us-ascii?Q?D5qZ9a/zwe+FZhivyejT7d5MdROKd/kndtc0ps7+dXX4FokJLLeg0626RynW?=
 =?us-ascii?Q?X2cJPcEVB8DZ/eLozXj+sVnMeHuxccGrcuC/gf+TPGkfFpeFuhs8mVplBrOr?=
 =?us-ascii?Q?ZF4RwfRZrRBXPlUD5CMQHACmDCm9NwB67lMAxEhesGa68aQW4TZ2eqAVt0D9?=
 =?us-ascii?Q?kZkucONINMb16+Q33ALy5rGihCNzSdmQ5rD/xlCgYLTM3ay9DnLKxF1awRMb?=
 =?us-ascii?Q?8XJ/sqarVOA2BKOCETaZ7t6sGJ1acekkhWnNRkq5Fe+tgNm3?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7a30a95d-0997-411b-ff47-08de7ed4a2ea
X-MS-Exchange-CrossTenant-AuthSource: BL4PR12MB9478.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Mar 2026 18:41:26.5921
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /jK+ZakSRwc4tqUrrlnaH/G2Ly5dqPRkjjhYHkrOAvt3lg9xR2CmKIdefd+BhJ2d
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB6400
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 38A05120010
X-Stat-Signature: q4bqm8f4ux6ztkbo39b6fjbz4pbghodk
X-Rspam-User: 
X-HE-Tag: 1773168092-395146
X-HE-Meta: U2FsdGVkX19CO+PidcidNcHLfyNqnd8lJlIncLTS8Rd1NPE6iUD71IvMZdmqjP+n1glaLoGjn8iAdBqyO2DLgFYY5oo0XpXIxyyjbpcnXvzolAiXzCxfyVyofDB6pFT2z3kdZyhsIXfoNBg4lkeadz73oaXK696MpX2RF52pPuGCrgxzGSHT1ItrBd2qrf/xDlnvpBRzo3w0gE/xkP2XEJFz+Yk/Ga3UOHJBouH75VHhPLzVkP3LK3bHBz1nyMY1/y+h2Orn6W6b7ZcVFlOAa+bQaKhiXErQHVTMlUBHbBzMRjiav/eFJrFygGba5M++9Hs/FBUwTv/iVSIhJHGtYmbRGxaWobjTppVlobaCGGTIf7t/zRdseIb0tnZ2Bs2X9RCdUCGuUy0rThpQUQJJs9FGgwFKCoa6bP0fjeI4R29FLWkSjaAd0+0oNyqa52g9QZdJJ5n9rWnO21h7a6RSI8BaeUo2DPrtpbwci8Je2uvnxOn6X6dXfUJ19HxEMAT1V3QTE+e7vv8oFINtmwjlUSBlW/G6yDo3T84QTJ7SvJ3FFZ1bQ5kxQPWlS9XtVWmSuFg0iZIO1TR+Vlbh0SvkcAmNVBFa4cnY/nlwecmN3VdAF7KD4Iw6ou6G2awwBIZi566QCjwjDSRKcpz5QRt7/PRJv68maPzdAl9CIl7eeiM3R6JVCROWkHBwClo/sn1xtZBu66IBptxgkwgZRmyayWHJ7Gi8yUNE6G56RQJbMNMkLpFq5nz6D2j5TqJ9LMO2oINLelHIPmesQ9R1YyejpJi8XGVuiT1Vp3mM9qtElHEMeGIytk3JXxjVbvj0WIkH4V3CJIh7bYDxaeVqbEht741t8H375okgOr8BiquMgPYHZ9/nF8WFdgbhj9ecumR8ZHlDIeAgKrWDEaI92tuHUsur/XJJ4C4qgmfagvLrUYMteZbPEOYqnZXYGi7tVEV5mpd8KKGnuR7QGl6/Yuj
 zs7m/Gh1
 V/bjH78H0vo1Th0+GMOEwFHiA8dbVRaAWhxBIJtCfuUC18exdQ0Fc4tuWIADkVilejrZLgORCb3bozwkSLp6J0R8kfAHPI1W6JWC9BBjlRYlc391144ehJm4t3n8RlvLKtMLGveCfOvlbwtWL8UGQ/v553SQv+ZkTdcMcf7kp9pWGOASG7BPz37RcKQdh1FscT/zn0akPTTcJiWlgjlFCn7pk1rY9eosrOtnFddW3Cc0CnRwz0wPQWFRL0emOFPnLOSkIRIdgD5arpNSYrk78zdjy5VJiDvV1OqMXEpxhLYu47zaY8z/4XM8mUfn4xO4RtOh4ZTelnt3T9AT476ktk2NpOC4ljGhXfsuG3lOImgQ+ZnWGYUd9XoxFVNgeSI0YfRjBmKDCIIeIq1OewNjHptVJiCSYdj0lvZTndPRA406+haHzwvebOaaIIo0AtmuHjDu6kgpDg9fF9cf7Fq36LcU57g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 10 Mar 2026, at 13:57, Breno Leitao wrote:

> The "raising min_free_kbytes" pr_info message in
> set_recommended_min_free_kbytes() and the "min_free_kbytes is not
> updated to" pr_warn in calculate_min_free_kbytes() can spam the
> kernel log when called repeatedly.
>
> Switch the pr_info in set_recommended_min_free_kbytes() and the
> pr_warn in calculate_min_free_kbytes() to their _ratelimited variants
> to prevent the log spam for this message.
>
> Reviewed-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
> Acked-by: David Hildenbrand (Arm) <david@kernel.org>
> Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
> Signed-off-by: Breno Leitao <leitao@debian.org>
> ---
>  mm/khugepaged.c | 4 ++--
>  mm/page_alloc.c | 4 ++--
>  2 files changed, 4 insertions(+), 4 deletions(-)
>
Makes sense.

Acked-by: Zi Yan <ziy@nvidia.com

Best Regards,
Yan, Zi

