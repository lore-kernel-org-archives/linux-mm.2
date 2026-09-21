Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BA5CFC982ED
	for <linux-mm@archiver.kernel.org>; Mon, 21 Sep 2026 09:43:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D72236B00DF; Mon, 21 Sep 2026 05:43:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D4A766B00E2; Mon, 21 Sep 2026 05:43:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BEA9B6B00E3; Mon, 21 Sep 2026 05:43:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 96BA56B00DF
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 05:43:05 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 132381C2DB4
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 09:43:05 +0000 (UTC)
X-FDA: 85237280730.08.2CE4574
Received: from CO1PR03CU002.outbound.protection.outlook.com (mail-westus2azon11010003.outbound.protection.outlook.com [52.101.46.3])
	by imf06.hostedemail.com (Postfix) with ESMTP id 2D96F18000B
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 09:43:02 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=NU4DlasR;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf06.hostedemail.com: domain of icheng@nvidia.com designates 52.101.46.3 as permitted sender) smtp.mailfrom=icheng@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1789983782;
	b=dpLlI1UJ9IeDB9uivPD2JbU8t/35GdQ//M85RklEu975bXbmIBFjG7H/85PJNXEUDU+xse
	+m7msDDTuLsXNM4Fy02Pv2t6rKTdNPVHvNJ2c5S6K9HT1uuK0oQxyOOAEQNO7S6dJsF1tK
	0gkKz5dSBOirKgA4nmcdVaKyyv02TUc=
ARC-Authentication-Results: i=2;
	imf06.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=NU4DlasR;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf06.hostedemail.com: domain of icheng@nvidia.com designates 52.101.46.3 as permitted sender) smtp.mailfrom=icheng@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789983782;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8bP4dyaFq/MBjFyeK1+sF4xLpS8TtuO2apA2hhInUEE=;
	b=pmFfKM0jMj/wuXXSUdfTUntQtBkk7RT/6rJGT5wXQc9Rsf/grLQjwvdmB6mmoH/utaiiet
	e95KnMrY6v9P/5n9TCGvtahbS2DmZ03/X06zyBwe1uX0KN7hyCawnosd9T5qkbvBUrvNL0
	mVEKD5pM7l9UAiEp+ESo7gEZEUdNrrI=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=omJHQjpZPe3VIGqbjMTA7WrokK8nwW0sI9ltsgEo0yNeg2aWRVn40F/alSwT1y7hAqzKCmLwcRwTu10uBR3MWkjPmKxeRuaEJn7TOijV41Vekmc/YuArZE7iT9E5I7S4pcEfsNJtIrpcjPUh9xCDHahVpCaHiJaL5ssQQPpUGyaO9Kxsg8oa4S1R0cG6NFDK95htOFyh5/TTNOr/5bfu+7dgp+Sdsx5cRldHzGItkdRBF/9Tgs16dC9MOLwlu1/XtIDyZFw2G11Xe2hAY1bq1ONQeHOHu7BkHoy9dPeOS5e+T7o726d8wVbHUB4X2htoLcFeL9vXpOwhp7hnrYhUJw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8bP4dyaFq/MBjFyeK1+sF4xLpS8TtuO2apA2hhInUEE=;
 b=TLgcIBblq5ydNgnIU5Kq77DbHtTYLcXq6jskjrrM3gGKDNYmC0CxVV/xz6roRXXsiL5jipsYZT8ANEXlRb9zRhGoLbNWKLgWqbHOqZ9kDsAnLvBvO7DhSohABfXVJYIbdkZeIMbqSXPYQ7E0DOnvITcO9fpfJI7zMERUVRAFx7XW689YNkTavteTTqFWhSTngKDRusMvuwz+920fGiid0rZNG5wsgfAnbDNq4tvJCmdtlGGU0eA+aedndcmFPEccqlDABckeFs70gIP53W+ezjQafiEDQrzf00GKc2obbXXCJQYSZAd7yQwU9OqpQWMTyw/kqONOSJGtK+zOTh5Rjg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8bP4dyaFq/MBjFyeK1+sF4xLpS8TtuO2apA2hhInUEE=;
 b=NU4DlasRDOuJvrOKutMPXhNXfWLhVH7aQ5rNbLj85pVaPqepZoLiZQFe88LCSIc0p5kEZeE/KYxFIX2O2n8+NozZ+9vN7+UvkMjh2ZTYjgkes2/F72hDywZ9MNYIsQX5By/kQWobI7FMvI0Czc6/PhwG9fMR2IwrSfxhFNDbcm/CIxiwXwuzEm0+FjrGDKkvLBV/GeCyvWWWyCkXAPuNwrYC6f8xU4pwxuxh+k+75wqMabKKDz6pIa8xJsYTq57LtxoqTvdty1+cEtLwH0kklnknBoTgvHQ6xPEAMsWEIeArZRN5zTSFFh8V0GITpI97EXJt3fPTvv8ntTQD8vgL7w==
Received: from BL0PR12MB2370.namprd12.prod.outlook.com (2603:10b6:207:47::27)
 by SA5PPF8DEAB7A29.namprd12.prod.outlook.com (2603:10b6:80f:fc04::8d4) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.428.16; Mon, 21 Sep
 2026 09:42:58 +0000
Received: from BL0PR12MB2370.namprd12.prod.outlook.com
 ([fe80::86cf:c3ec:2cf5:74c8]) by BL0PR12MB2370.namprd12.prod.outlook.com
 ([fe80::86cf:c3ec:2cf5:74c8%7]) with mapi id 15.21.0428.014; Mon, 21 Sep 2026
 09:42:58 +0000
From: Richard Cheng <icheng@nvidia.com>
To: akpm@linux-foundation.org,
	david@kernel.org
Cc: jgg@ziepe.ca,
	jhubbard@nvidia.com,
	peterx@redhat.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	shuah@kernel.org,
	linux-kselftest@vger.kernel.org,
	kobak@nvidia.com,
	kaihengf@nvidia.com,
	newtonl@nvidia.com,
	kristinc@nvidia.com,
	Richard Cheng <icheng@nvidia.com>
Subject: [RFC PATCH 1/2] mm/gup_test: Track long-term pins per open file
Date: Mon, 21 Sep 2026 17:42:42 +0800
Message-ID: <20260921094243.64698-2-icheng@nvidia.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20260921094243.64698-1-icheng@nvidia.com>
References: <20260921094243.64698-1-icheng@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: TP0P295CA0006.TWNP295.PROD.OUTLOOK.COM (2603:1096:910:2::6)
 To BL0PR12MB2370.namprd12.prod.outlook.com (2603:10b6:207:47::27)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL0PR12MB2370:EE_|SA5PPF8DEAB7A29:EE_
X-MS-Office365-Filtering-Correlation-Id: 8d455c18-5d21-4c7f-503b-08df17c4b808
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|1800799024|7416014|376014|366016|56012099006|11063799006|10067099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	TXjS6Kx834XHkMUBiA6GSfWBjpDyVM5WmDMGoxAzcLZ4327m7mhwGtIhX3ISEWF03F64Ch+CNBsVpuDnRIN9ShTXRFGylGQrmYhZeFve+RVd03SiKaKfSQGe++lXe7mm6FqEscQRINQqbVhlXPsCv5X5yhCTVkRBPvzrz3Z6poH2+NT4X9LYofZeeUv6j7cIt7nPxSdwNApuWg1sUBzkMjaTWSWYrrASxDUAMFi2glDKPiI1fHtHuuK3v1asm6mGs5x+5QDEPoK81AB606d7F8fk3CszPbBGfuhbXbQ+5XHs798TyfpYnYSKHXvTirsiqztwt011pWAlyDlWsvsM36j7NiE0/4oaq/X3nElsA9blztXcCiKn8nAcjFMOo5cEupGQOhoyAI1I+eIYwI/pnW0eKxcUj5+vBSul+nAL8VW4EOvtvDoAAmyPDhR1vOwOgUmpMmlktp65RsUXId7JeXJ78MG6mzb+sGz4eXn6KgJ5bPJPMoJDQeyn2qi4RApm1mk54+8PhxFTMzZaIEDIy2ogPEffR83NbcmhID/JpWfKNTwFttNNXHwBoof0NBNceTo7VvQIkqaAZl/peUdO6GbvOb9HoBxenlikOn+S5SXsEGpBKy1RxmtKgFgwiB5ZhMfO3wSjbRjQiFiFtEPkscaQa4Fv4PnqubG4N51lOu4=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB2370.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(1800799024)(7416014)(376014)(366016)(56012099006)(11063799006)(10067099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?69u1okdOX4xtc4N+040HOn+GVbuBYM2SFI8beEKJQvK0HSmn4lCXe5Iis5Rf?=
 =?us-ascii?Q?Bq2ubGda0jNZMr4WQP8G7nSFu2m+4KF8K2L5Dn4QNKc3dp8vyMEzVyEt8557?=
 =?us-ascii?Q?6OSkcLXe7/Jdt8VnYsYFuv9m9THcUFSr3L88mkynufZHaHPhFuwWqVeukK+T?=
 =?us-ascii?Q?KBirr3zvI8ZfpreE7NmNb4izzr/7iWMPLKAmkzGU8vmpoVq/CYpvoUP7/aHl?=
 =?us-ascii?Q?vJaIfWdDsvW5A3shQzsKNR/XlgJHRf5p+J3AP8f+KNjNeTZaarG/uiDGdnea?=
 =?us-ascii?Q?GPkQvTpKLlcYj1c9Zzynhq9SSmwK/JJN9pfYqw32WhEdDSCfNlceo8WIF+qD?=
 =?us-ascii?Q?ljB5yNRnuuhoQcnKpW2jbpk63tGrpHIi22Ikh5dOhSVDHJKzMzo7+RJ/VTDG?=
 =?us-ascii?Q?EGcYc04avQE1BG3l+j6/WyHvbi2WKntQ9gNypAWeD1vh9nTTqoBB7ABXug3L?=
 =?us-ascii?Q?xe8T6JYejHdSiJqGg6Jde9m3KWdcjboN1RUGrPibGHtrWtnIqZqWUKv71jC5?=
 =?us-ascii?Q?NSx6pxf9imeH0gtJh/muCyW2TSu6w4WedpywZRbWtDt70cL9BHoopy6Y7r8s?=
 =?us-ascii?Q?4jcvEL2LAJfjn9nHlKX+UHmRE/ZrUl84HrIA/DRgz7aGcFJba9u2czg5GCOL?=
 =?us-ascii?Q?6DIV1IJfwFzUFJTsLElysdn1HR7TXw/31oDvkP78kh9GgxeCMzm1lwHaR2zM?=
 =?us-ascii?Q?FFVx4dtoV8kdjsfCZCNmE2eSp8XCBQZLR1ACwq/389Xb10BuQPlTRjnjaFIe?=
 =?us-ascii?Q?lCWHUZe9VoSyKt9FZ3bh6ZWtQWtbjNjD/W+aXb3L54hqnv3ORGyhwiOuTTbe?=
 =?us-ascii?Q?Dh1AdZdG5EpxK56myUmoniqrhnq+AztWn8wEptQFsp4+pTZhDHi08GzHhbIV?=
 =?us-ascii?Q?LCWKJFYFli27KAZGqbK8xnyoz9OFRDikVdattU/3w80GL1yVqZlkD/mHwkEq?=
 =?us-ascii?Q?B2krbUVHFEvVamn3GvnEr51pcmCKBiCH+Rfz8BUmW3OhiqIRRoXq/2FwRZi/?=
 =?us-ascii?Q?fBeBhZgQ+fStnRcewun0lAdFmJ/eYKZd6K+P/VVNkyee5n/Pq53bQ1fUroY6?=
 =?us-ascii?Q?7puGYUcVPIPmhON4vszcIXlo3QgS3uUcrnqPaIwaRbX5kLuvg5SJ1daFtmk0?=
 =?us-ascii?Q?VE7QV6e7Oy10WxApwVv5iWqdryvDFmHyZIKOijRXW2UcZk8k9ejI8KN7b0Ax?=
 =?us-ascii?Q?5bcsAuy67/EWfNqIijJ4LlHRYzA/4XnEcGmW8bIThL5blle94Niaso+yIyQb?=
 =?us-ascii?Q?IlCgg0LKy+NTgK28z+pPYrevgKZzQ+G1E04IpxS/kKtIoafVF4pD1LF3YtoV?=
 =?us-ascii?Q?RagbVoLOCHj1qBig2LDnQ9VKFNlXSobRah35+ZTXSLJgPrmnZ1loy2F+k6Pl?=
 =?us-ascii?Q?qrvc9xri3f5QPtfNmJafnW4bGvO9Pnl1w73kMH+EMi4p80m6hyVcSa1QjaF0?=
 =?us-ascii?Q?nYMqLRdw3XEvMbJjZkor7mVH7ez8L5APc0lM6Hff/eBaWxob5ZHxYz4z8Dc2?=
 =?us-ascii?Q?+s3Tv21/+WgZBFnkV6WiM9rUXeTFGzJRCjYNa/CGx7bUxk4CAt7vvOwl4Wvd?=
 =?us-ascii?Q?G6ssuQw90y0n+fVx49wZpHglbV/cKre8Np5xMBp4SHh5UiMCTKRxqV5M6mhh?=
 =?us-ascii?Q?BVVPL1QFvHBa+6VDeuZJNhBc3vnGq1+pRvBurC4xRyjvRPexTCBFAd94jZR6?=
 =?us-ascii?Q?4Vpky8Kvr2R0s78jyFwJSzXP4BJfzJR8VvGh909XOt1yRunQ0yTQgCHz0nlN?=
 =?us-ascii?Q?F4euutiVvw=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8d455c18-5d21-4c7f-503b-08df17c4b808
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB2370.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Sep 2026 09:42:58.1239
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pFngicvnrwn0+N9oio1xPthXKnEWtBKbq2DnZnRqLnfgfCucoErv5uzz3EYRKy8rWn710rKpfK3R+K/fGH041w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA5PPF8DEAB7A29
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 2D96F18000B
X-Stat-Signature: eb3647gpekapupt3ycsn7w5wdwuhqfkc
X-HE-Tag: 1789983782-813664
X-HE-Meta: U2FsdGVkX19QzKhv10K29JlK9ISBsGCy9f5xi+tf1jCAWu6bx+Zb66sM0WAppENLXdfU2TCnmQ6ygYNygQKteAMzxpwvkiMSOclkyHi0BNbghrtdXn5P+0a1Ot++LhCLrs+9Yt6Fhu3i58ws3ZmFBQPGSn0rP96nBqLKfz9IgbqHYsm5UfWmivG9Ekr9DjScDD49coKJqGXmttEkEjNfSldDyLuWnvDBs7q7/3xBWshdvPM/HGj74sMiV6KLaFdrvlfEer3JqtvWG6i+5cc34QmVHBxCMEiL87Zgs7v/SYcZKksAGr8ZWJStU8chuax/Li4CdOriZ6TqhQl4Rw53IoCQQFsN8LZZL0RzbA4+apDhAw2LTKpWw+nIaosapmm0IodqDLgri516AcVmf2Y41Yo7w6IUXEyrp51V0rZWBTDOCC1XgAPfeydAdufRMxTt425cXuk0FUk45XyPOo8jw2voaLP6U65mo+NCdFj2pi3HtkT1mc7C2c83HcPeJYw+zebMf3CiWkRMZ00Ch82EkFLp9MuiO2+1yfc+uv0qmQ0gxUTXsFnHnado44r0WNMVhxjdcXDOz29nKQGreWKfzrernz82ZKvkGWBkimtlxXD+fCakaoqy9hfkfUQyTzqZgwRisOM/dhouqnB+IVqXFdaO2cpWqbchT9zXEp4bnunetKVCXHluk95Tl9YTLPGmG1shtA2MlLTWVzRMxbYHUG2gakyCvsF3l1kNreHGqbr62yDnXlS5NQ5mn63xtBzlt4BkiVQoHUjkilD0Cl0XMY1PQGnzxbma77MXfO/za8bbFiWIHaz7WZrZYPp0BasE5Ys6/SVg/Ux8Z2E1dCn9VhcyJxP9LqZtzzmxifdrP0ywt2av17ULqTOYUCrQ6psI7bahU+KZHtXzH/RSIVKMDcUXUImOKdNsSmL2NNkKckMxqGf8A9je70kUZxuGWlx8uGO8wjcDd/zZsFGOTHg
 VwhjIOTY
 D80E70/UO5feJR0uyyslhVqbL8KU/9ZDrI7fHHVDRy8u6L4DTjgnLhPfTQyf/NDNKZ2L6+Csq1uvYX43TzSSduZFUxAVdldLcagq0TpDCL2+1L/qErukHBviCOjgsbzBacMcHlLU+KfSPUPO4IlZh/W/mOlw4XA9Z5UyXMW090q0FVKBILWv5tSZn6+SCJ2+jyGGs5L75NvdAJ9F4GNYtnndg7pG3waKULhofNazuH65/19lUVY4mt3XDqWtQ5I5vYpcWX0qOgMiXUwQxqrVzY3LAS7xyeJZFggt+QLvjfpE6fGuRzy7jeQPBH/LypVsJNyBYvwDsaGsjbkF9cwnwUwKpK9tknAQ5En80OzxDkyxzX61DRH+39dhgu+XgleAunzfD4YXJKPiJsTpkiXt4r41KbSS4Nqs4mLyVKm1A8CG67n6ZIB4AQB/Nlw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Long-term pin state is currently global, allowing one gup_test file
descriptor to block, stop, or release pins owned by another client.

Allocate the pin state for each open file and store it in
file->private_data. Serialize START, READ, and STOP with the per-open
mutex, and release only the pages owned by that file.

Descriptors duplicated through dup() or fork() continue sharing state
because they reference the same struct file. Keep the ioctl ABI and
same-file duplicate START behavior unchanged.

Reviewed-by: Koba Ko <kobak@nvidia.com>
Signed-off-by: Richard Cheng <icheng@nvidia.com>
---
 mm/gup_test.c | 88 +++++++++++++++++++++++++++++++++------------------
 1 file changed, 57 insertions(+), 31 deletions(-)

diff --git a/mm/gup_test.c b/mm/gup_test.c
index eb4c9cda16ed..d0bd84b66624 100644
--- a/mm/gup_test.c
+++ b/mm/gup_test.c
@@ -208,23 +208,25 @@ static int __gup_test_ioctl(unsigned int cmd,
 	return ret;
 }
 
-static DEFINE_MUTEX(pin_longterm_test_mutex);
-static struct page **pin_longterm_test_pages;
-static unsigned long pin_longterm_test_nr_pages;
+struct pin_longterm_test_state {
+	struct mutex mutex;
+	struct page **pages;
+	unsigned long nr_pages;
+};
 
-static inline void pin_longterm_test_stop(void)
+static inline void pin_longterm_test_stop(struct pin_longterm_test_state *state)
 {
-	if (pin_longterm_test_pages) {
-		if (pin_longterm_test_nr_pages)
-			unpin_user_pages(pin_longterm_test_pages,
-					 pin_longterm_test_nr_pages);
-		kvfree(pin_longterm_test_pages);
-		pin_longterm_test_pages = NULL;
-		pin_longterm_test_nr_pages = 0;
+	if (state->pages) {
+		if (state->nr_pages)
+			unpin_user_pages(state->pages, state->nr_pages);
+		kvfree(state->pages);
+		state->pages = NULL;
+		state->nr_pages = 0;
 	}
 }
 
-static inline int pin_longterm_test_start(unsigned long arg)
+static inline int pin_longterm_test_start(struct pin_longterm_test_state *state,
+					  unsigned long arg)
 {
 	long nr_pages, cur_pages, addr, remaining_pages;
 	int gup_flags = FOLL_LONGTERM;
@@ -233,7 +235,7 @@ static inline int pin_longterm_test_start(unsigned long arg)
 	int ret = 0;
 	bool fast;
 
-	if (pin_longterm_test_pages)
+	if (state->pages)
 		return -EINVAL;
 
 	if (copy_from_user(&args, (void __user *)arg, sizeof(args)))
@@ -263,12 +265,12 @@ static inline int pin_longterm_test_start(unsigned long arg)
 		return -EINTR;
 	}
 
-	pin_longterm_test_pages = pages;
-	pin_longterm_test_nr_pages = 0;
+	state->pages = pages;
+	state->nr_pages = 0;
 
-	while (nr_pages - pin_longterm_test_nr_pages) {
-		remaining_pages = nr_pages - pin_longterm_test_nr_pages;
-		addr = args.addr + pin_longterm_test_nr_pages * PAGE_SIZE;
+	while (nr_pages - state->nr_pages) {
+		remaining_pages = nr_pages - state->nr_pages;
+		addr = args.addr + state->nr_pages * PAGE_SIZE;
 
 		if (fast)
 			cur_pages = pin_user_pages_fast(addr, remaining_pages,
@@ -277,11 +279,11 @@ static inline int pin_longterm_test_start(unsigned long arg)
 			cur_pages = pin_user_pages(addr, remaining_pages,
 						   gup_flags, pages);
 		if (cur_pages < 0) {
-			pin_longterm_test_stop();
+			pin_longterm_test_stop(state);
 			ret = cur_pages;
 			break;
 		}
-		pin_longterm_test_nr_pages += cur_pages;
+		state->nr_pages += cur_pages;
 		pages += cur_pages;
 	}
 
@@ -290,19 +292,20 @@ static inline int pin_longterm_test_start(unsigned long arg)
 	return ret;
 }
 
-static inline int pin_longterm_test_read(unsigned long arg)
+static inline int pin_longterm_test_read(struct pin_longterm_test_state *state,
+					 unsigned long arg)
 {
 	__u64 user_addr;
 	unsigned long i;
 
-	if (!pin_longterm_test_pages)
+	if (!state->pages)
 		return -EINVAL;
 
 	if (copy_from_user(&user_addr, (void __user *)arg, sizeof(user_addr)))
 		return -EFAULT;
 
-	for (i = 0; i < pin_longterm_test_nr_pages; i++) {
-		void *addr = kmap_local_page(pin_longterm_test_pages[i]);
+	for (i = 0; i < state->nr_pages; i++) {
+		void *addr = kmap_local_page(state->pages[i]);
 		unsigned long ret;
 
 		ret = copy_to_user((void __user *)(unsigned long)user_addr, addr,
@@ -318,25 +321,26 @@ static inline int pin_longterm_test_read(unsigned long arg)
 static long pin_longterm_test_ioctl(struct file *filep, unsigned int cmd,
 				    unsigned long arg)
 {
+	struct pin_longterm_test_state *state = filep->private_data;
 	int ret = -EINVAL;
 
-	if (mutex_lock_killable(&pin_longterm_test_mutex))
+	if (mutex_lock_killable(&state->mutex))
 		return -EINTR;
 
 	switch (cmd) {
 	case PIN_LONGTERM_TEST_START:
-		ret = pin_longterm_test_start(arg);
+		ret = pin_longterm_test_start(state, arg);
 		break;
 	case PIN_LONGTERM_TEST_STOP:
-		pin_longterm_test_stop();
+		pin_longterm_test_stop(state);
 		ret = 0;
 		break;
 	case PIN_LONGTERM_TEST_READ:
-		ret = pin_longterm_test_read(arg);
+		ret = pin_longterm_test_read(state, arg);
 		break;
 	}
 
-	mutex_unlock(&pin_longterm_test_mutex);
+	mutex_unlock(&state->mutex);
 	return ret;
 }
 
@@ -375,15 +379,37 @@ static long gup_test_ioctl(struct file *filep, unsigned int cmd,
 	return 0;
 }
 
+static int gup_test_open(struct inode *inode, struct file *file)
+{
+	struct pin_longterm_test_state *state;
+	int ret;
+
+	ret = nonseekable_open(inode, file);
+	if (ret)
+		return ret;
+
+	state = kzalloc_obj(*state, GFP_KERNEL);
+	if (!state)
+		return -ENOMEM;
+
+	mutex_init(&state->mutex);
+	file->private_data = state;
+
+	return 0;
+}
+
 static int gup_test_release(struct inode *inode, struct file *file)
 {
-	pin_longterm_test_stop();
+	struct pin_longterm_test_state *state = file->private_data;
+
+	pin_longterm_test_stop(state);
+	kfree(state);
 
 	return 0;
 }
 
 static const struct file_operations gup_test_fops = {
-	.open = nonseekable_open,
+	.open = gup_test_open,
 	.unlocked_ioctl = gup_test_ioctl,
 	.compat_ioctl = compat_ptr_ioctl,
 	.release = gup_test_release,
-- 
2.43.0


