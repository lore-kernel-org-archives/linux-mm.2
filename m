Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 790F8FD4F07
	for <linux-mm@archiver.kernel.org>; Tue, 10 Mar 2026 16:53:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9AE6E6B0005; Tue, 10 Mar 2026 12:53:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 984F16B0089; Tue, 10 Mar 2026 12:53:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 867156B008A; Tue, 10 Mar 2026 12:53:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 75FC56B0005
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 12:53:09 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 1B57E57397
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 16:53:09 +0000 (UTC)
X-FDA: 84530748498.29.183535D
Received: from DM1PR04CU001.outbound.protection.outlook.com (mail-centralusazon11010069.outbound.protection.outlook.com [52.101.61.69])
	by imf05.hostedemail.com (Postfix) with ESMTP id 753BA100015
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 16:53:06 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=rlC3EikR;
	spf=pass (imf05.hostedemail.com: domain of ziy@nvidia.com designates 52.101.61.69 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773161586;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9bDcur15C91I6Z1pQRqdIQQXYcST/zyjk1z+93AG2aI=;
	b=DpHrftfui6nZDZpImaIZAkALNIH7bBLVyP+MzqpWFzt7r1i5NVF+aZxai5/nsu6FEKlp2G
	mo/+s1zLGb1/8SNPJ2u7BUzwPH3ABioXzFmXG1ZONI2AvrARybWj3/zLaWs5el763IHpGQ
	8MJrJS/GK/o+dj0TcKTZNQ3ulNg2X0c=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1773161586; a=rsa-sha256;
	cv=pass;
	b=yJ+LCsdYqpE7b0UtvCPLhYI9zJYTvKg8cyTHZ5Dd/O4KmKEK0tXiDl0ckcIMOj26++1NZS
	RTtAM1zeoirzsLE0AVe6vdoq1lnNCYZ1JWoWya2udm1W8OyaRuH82ZOm+c6B3ekPV7QoEa
	+KPp7nsas0H4goFZVijRNLpt8pjStd4=
ARC-Authentication-Results: i=2;
	imf05.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=rlC3EikR;
	spf=pass (imf05.hostedemail.com: domain of ziy@nvidia.com designates 52.101.61.69 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=FdRwYbwFkv/g4p2O1219zWt5dhWLeQzoVrGsSlhxo6CTYAeAuVgB+rPwO2jCu9IWc2mHd3wVT7UOhUyOy1pNWmOh4HdS5eoY9fTgjeMVnX1YrnrzI6AGb52CX1m6oEiB1gAB59uU7+Yf++7u6722AMBJhu20nz7exPphGFdA5b4LmDkQQKr5f/zdipLnF6ml//pqTd1456WpKdSPaDHcHP1f5H48uqnZyT2hbIprPx9hCSKjWV8lscsorukAk2IlMy1u/uLzfXetZIaOtWu9I7y0bfSVufgJ7wnngZa7HFJNi3bCFAHljl+0SWmdeRpO80Cm3JvBEmYSdCnvuFHnDg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9bDcur15C91I6Z1pQRqdIQQXYcST/zyjk1z+93AG2aI=;
 b=i6cI79vx6rLqGiF8Y0DrCA3QtHXYOEG7mc5oFRdfewmU4aTXx2BUD9KUBp5b0vbGUGGfuhUJdUAMvevlFpx6BclNqEE/lA5cjoVfuMBPvdnfH5Qb0wfvUvIMnC3+2jAptyeU0yi5Dk26qFn86G6j1ns6r3UlG5CV2dUti0FxeWCRyprKrAPiucBdlptC56Ji7n4Ax6k8N6a/H89fom5HdNHEdEKxw41MzeBPkstWDMrqO5W6qChisWWOYe3CnGLHKcgkhWiVWR+TDx7XKfe08VKsnbgmChgGqz8UptPj8GEf1xOpL/ulwNKo4JG3E41WKvEqjzzsdGKiM9T/gW2ohg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9bDcur15C91I6Z1pQRqdIQQXYcST/zyjk1z+93AG2aI=;
 b=rlC3EikRn1IUc6OHfTDmJkCVaDzP+LieeIqHvtmXNR76lWKM2w8MOXc9b/pxk8CgeK8CXD6v/CO1JlDUZmRzxDIeQZw5/xa8NbWtAeMRgT3n/nHhWclxMqOeeI7wK/ZVyNy6IPOrKSV4s1KzetS7RINi50LHUbJ5vW6w5qj60xBIEJKt3+JFndwHSscPjK1s0JWFVNlzYW6ZQilmGMPrWw+04kU3W1z+E84Ywp0IrVD/O9qw27eOObGVtQgDPcaLzKJzdagUADgAq5nD67hZxhgJQ+ocoCDEeAucKdoiSY1nN18zq4caNtRo7XOiyVHrW05nCgvFyqsvyT1iZxVF7Q==
Received: from BL4PR12MB9478.namprd12.prod.outlook.com (2603:10b6:208:58e::9)
 by IA1PR12MB9529.namprd12.prod.outlook.com (2603:10b6:208:592::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9700.11; Tue, 10 Mar
 2026 16:53:02 +0000
Received: from BL4PR12MB9478.namprd12.prod.outlook.com
 ([fe80::4d08:451e:a51e:33a1]) by BL4PR12MB9478.namprd12.prod.outlook.com
 ([fe80::4d08:451e:a51e:33a1%6]) with mapi id 15.20.9700.010; Tue, 10 Mar 2026
 16:53:02 +0000
From: Zi Yan <ziy@nvidia.com>
To: Usama Arif <usama.arif@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>, npache@redhat.com,
 david@kernel.org, willy@infradead.org, linux-mm@kvack.org,
 matthew.brost@intel.com, joshua.hahnjy@gmail.com, hannes@cmpxchg.org,
 rakie.kim@sk.com, byungchul@sk.com, gourry@gourry.net,
 ying.huang@linux.alibaba.com, apopple@nvidia.com,
 linux-kernel@vger.kernel.org, kernel-team@meta.com
Subject: Re: [PATCH v2] mm: migrate: requeue destination folio on deferred
 split queue
Date: Tue, 10 Mar 2026 12:52:56 -0400
X-Mailer: MailMate (2.0r6290)
Message-ID: <432188F7-DD7B-44AD-BCF2-C61847349CD1@nvidia.com>
In-Reply-To: <20260310105419.3256755-1-usama.arif@linux.dev>
References: <20260310105419.3256755-1-usama.arif@linux.dev>
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR13CA0087.namprd13.prod.outlook.com
 (2603:10b6:a03:2c4::32) To BL4PR12MB9478.namprd12.prod.outlook.com
 (2603:10b6:208:58e::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL4PR12MB9478:EE_|IA1PR12MB9529:EE_
X-MS-Office365-Filtering-Correlation-Id: 6d497249-18e0-4042-825d-08de7ec57deb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|1800799024|366016|18002099003|56012099003|22082099003|7053199007;
X-Microsoft-Antispam-Message-Info:
	nMyJFm2Wzag0CRfAeeS6nmUlhP2K4D2agdWn5AEj4+X8zlGQdUjqumT+5Hh9awb46vUMJi6OoPE8z1r0ciHnOrLRpjVTECoazA8cporlQGCAFxa/7GAObGtuUfqajbr8MpbnMtsxITT1IDqwqqorzA+B+vI9yY/zvWOw4PxXGlvouZbzcXcJQaovRxvYv1uOmAyyiCya4x3Dw7aKSHDMWfb2Z5vyqCb7QV/LCIM03K0E6UXp/7iYakVsg3aRTpPTE4tiz69X0L/7qnbs/c23oR5ZjJZuYTmnINaMKvJf31uO0cw0YJ5+YU7bSi7zMIKgsj/uKQBjKOzMMxXwjABFcQcgUi/KFqxDJsKLPE+ssWXe47oQY1rVHIifz06vmaS5LqZh6g/jiIm0kCsUmP6dHehlpEG5TU3KgRTdG9j4jGpOlt5mGjBssami427hZGCNxoi3mI0MSSb6nktFJJHCOGShOa2TEiPIJIojmPoR+20z8VX6hx9AdPyAVuBB17fjf0QIUVIeSqRqaMKpfpfBJlfZbbQ0X7NOQDCkcE5M2RunoPa1uZo6ndUzT7IFD0TU5LUPkcnPDWOc1tQJQCXxcAI98eQz8grdR4SiHKufdo9fd5NNdqpq5jM79xCDttXFYBxC4QEMhePab5a/dWXPkGfmMwcfDHGUyIfXrzZ/RZON8S/4/kV4ZwjMB3ADUZ1hinlOd93cKuAts6nmZHhvFJG1ebCSG1VB4wPYhCoQfX0=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL4PR12MB9478.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016)(18002099003)(56012099003)(22082099003)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?idEDJ0TymEDltygLzbW5cICsiiP/ZF52l0XbDLd/L577ZlvXbNqoZAoGT+S3?=
 =?us-ascii?Q?JMbkTTUGyKl966/ZwSmLdXoBn1prn+G8Imm7f8NlkixbkAiUhseJOqIkd+O4?=
 =?us-ascii?Q?iFclOHS1RURsJCqPipeG9DIR5BPeNtDh46XNqDiNbde2cAl3i6TKqb05D4nL?=
 =?us-ascii?Q?EuqM2OfZv45UX/YrEmePztbSowB2fQHlOK11a6kw2pZMRPhNRh8ISab/pv4i?=
 =?us-ascii?Q?LyEqoopdKuCImLXIclKBK6tY60+1A1S5JM+doLtsuwAgRSwNV1jsBEeY3/RD?=
 =?us-ascii?Q?42m+EKNUIiJZTOWMnTm88xZ77lmv7LyZuQPOLprDBW3QUO3+cZhLsMMP0RGz?=
 =?us-ascii?Q?wDds3M4W12l53Nd/WxRbp9gAK5+IlYyFnCRrDxBBLjE6Hc9R/xPAC7paIm1B?=
 =?us-ascii?Q?Gms2ElglDtAwxRy04Yq47WpaA4c3TBJuf0cnoReiAPNbni62gtYVWk/jIdhe?=
 =?us-ascii?Q?sZflQfcq8/2Vm18aNrwiy+tudl4idbrBbvnMWOyQuqZHOhodKbVelE8iZlTW?=
 =?us-ascii?Q?J+L6ASNWULoAPrvAQvkH2xOi5gyGEUS77tjlH8/zyZSMMSbEO0A/usbH9Urh?=
 =?us-ascii?Q?BHg6mtfs4Gy5SXde9OfJVGnpzo1BiANoKVnYraGnaz0bCYE7dlIuTj4C0NXr?=
 =?us-ascii?Q?NV/yc4B/0tjUsKbbuqYVk5Y0k59VPRDDZM93ZjH6o1/rWdZfobMQ0J4HP76B?=
 =?us-ascii?Q?NI28lW7eVD0RYNU0kSBBywXqyOC3f6GZObgJupVz1PT1YreOSsO4f/djiiZH?=
 =?us-ascii?Q?9e5GKuWi09PSCf0unYWPMg2UF6hy89/v6Yiu9d3N572CkfiaZrhATN4HnDZ0?=
 =?us-ascii?Q?O2VuL4QJqTQClnwwXFMv2EOcWSshTcKqrYYzXV5fVQCWB4zjSPbJflVcbIjF?=
 =?us-ascii?Q?lh/g2g0I5tD1tDV1VicWaBCeeQX1hnR0bmtM4udyjVnZnJq9U4OAuKASrBG5?=
 =?us-ascii?Q?N5GP4C9VKvZ4/3ogXB6RUFRE55t9+6k8j8Jw7nUJDbORFIlY1dYOVwh6LxH4?=
 =?us-ascii?Q?LYonEEHAJ8fAKw86oXBJc8x4cu6m/uhtE75gW6CCVehM+OrTB0va1uen23KU?=
 =?us-ascii?Q?fHVC6M8s4mzIxVheyoXyVRCDJ3xyoQ0uxk4/s5advxIx1HS0i/Xewa3bgBOr?=
 =?us-ascii?Q?Bonnb0sIcmqYWA8YzdPzY2TCG+KjE6CbTtnaVOKHs17ko0W+Gj0C3Ic7uCNr?=
 =?us-ascii?Q?onT5Pe1cJOXXVGtzHebhvclQBSDcA1oGPXdFAPyOnsUM2QOydTuQlP89rNC2?=
 =?us-ascii?Q?+xS2GCU6VynojYLIMN7F6dDr3J/5mL3BcQjFcXWdJqm7rv6W79DFgB/ddNsT?=
 =?us-ascii?Q?aGYOEWsuwpM1fKJDCXwQIpaHpfYbpmDQo2LvgLhywYGykhh4DA8mYQ2aRxBZ?=
 =?us-ascii?Q?ng1O9NBrlLiTET/poERn0UQHQhFJYIyTDZIYR7GpwW0QhP/EvOTcM5IUpAKB?=
 =?us-ascii?Q?1VCVl910WUzlXa6yzhjqzJwTjf5Pl8E8EkuazlYQuPjvQFntG52/dglc3k6b?=
 =?us-ascii?Q?7SdJIvpnqFuogtHls0Hi/LozIFo9BwVlSSQdGpKmpUr5KPOqveUggrTCzTt/?=
 =?us-ascii?Q?0lg3DzV+svfOaFQFZD+HfGATAmVoojUhOyx9TBbN2lhGKzTxVu4YSgU1PxM/?=
 =?us-ascii?Q?wwctx7lSWFoF1rk+pEE7y+W3zfJi8UiEmYQBFrqn7LLheg0Mq1voeJczX1Bx?=
 =?us-ascii?Q?BiKU1BJhANTI4+kvfbZ97RMNVuqYMzBnOcq0Rt+olosyYV0z?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6d497249-18e0-4042-825d-08de7ec57deb
X-MS-Exchange-CrossTenant-AuthSource: BL4PR12MB9478.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Mar 2026 16:53:02.1060
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VioWOAeIRwySSwwY4XDR9P6lqEWb2PiL6Ug+XbXGvXca9lAH/H8O4Y2nUh9Ub7Pi
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB9529
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 753BA100015
X-Stat-Signature: wpzn799mp4a4ami6skg75ucjj1fs41gr
X-HE-Tag: 1773161586-101116
X-HE-Meta: U2FsdGVkX1/04y6Tg5BVR8YGwwMvVG/ciTIH60ua/iRlE1f+2wXXr7suzpaWd6i7Fl+Muk6M01i67a+HXO8J/BZv48to2+X3+yIX7jqQq1is2d5R6jH/8UzLy7f3nKDzX8l3slBOaAsivrLVkqe8YpmHlVjrIvzDA6UMsSxjJs/iUc83ix5k0wd08PjVS3tHKy5rIPA1zwq7+lw0zbU+7SqEZjHn9Tnh/kFbXrOFs6xfRxJSh17kgY4eCNgYQeMGevMkJsHIYSDfPnXV4TlCxIqR2E4Tf/2R3VYc5TesHZ0TSCtKOItTNnYTBaJROr1G9R5LHYtUoE4JxgRowoRaUz1h1S8pbn1Am1fD9qEULJuL/3BZxGxJecyOB42tutbOtlWJ9t2KEo+OaWxocsF2ofD0l8zfWSYtkEqb6rs/V3PyZxAs6jz0Cgg41A7GRnIVqHKe381mjK1ty0A7oY992jtVF0wkifgG5flqixnf/dL/NJRjpBYTTgtJbX+O9vwi7GTQAg5K26mqWYoWjArCEhaJ4tz+z+Z7EJ9yvih93z2JblCzODMkSq/JmsvO5wg9Ccse44/6tmmsj0fVRZdJpk7u6koopjvYN65qd+eIWK7+GeWtzH2lrgR/Q6tJsrEtutY1A8jdyvhdlLC9Sy/MkC7xPC+tJF456qsBcnB7i52mACRrgv9J1x0/W1wvwZDRLEumpbJECIbr3jI3e395crbP9fZwdfgsfZyjgOPDtM16adYCWAiIqB6zJ66iKPxoVJwMhSFdbD6zQRTjKAcupHKWOyac0aOF2VBuiWztEmPW44bMpbJ75vpgvjJ7H42LZx/4sTRRCxf0VMd2m7pPvxY6+z5ANJl5JuJ04a+Zyl83bvvdYnNSHC8ruNxBko79Tdj38I/U1lnWvHoscJ6CtD0WhBnlhArsFyp/M3Jdy+RAZA2W1LkD3fVln2t5eIFYRtCZ88u7AP+aTopJsh3
 +omd6DgA
 GoIX7
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 10 Mar 2026, at 6:54, Usama Arif wrote:

> During folio migration, __folio_migrate_mapping() removes the source
> folio from the deferred split queue, but the destination folio is never
> re-queued.  This causes underutilized THPs to escape the shrinker after
> NUMA migration, since they silently drop off the deferred split list.
>
> Fix this by recording whether the source folio was on the deferred split
> queue and its partially mapped state before move_to_new_folio() unqueues
> it, and re-queuing the destination folio after a successful migration if
> it was.
>
> By the time migrate_folio_move() runs, partially mapped folios without a
> pin have already been split by migrate_pages_batch().  So only two cases
> remain on the deferred list at this point:
>   1. Partially mapped folios with a pin (split failed).
>   2. Fully mapped but potentially underused folios.
> The recorded partially_mapped state is forwarded to deferred_split_folio()
> so that the destination folio is correctly re-queued in both cases.
>
> Reported-by: Johannes Weiner <hannes@cmpxchg.org>
> Fixes: dafff3f4c850 ("mm: split underused THPs")
> Signed-off-by: Usama Arif <usama.arif@linux.dev>
> ---
> v1 -> v2:
> - record whether source folio was on the deferred split queue before
>   move_to_folio() (David)
> - record partially mapped state and update commit message (Zi)
> ---
>  mm/migrate.c | 17 +++++++++++++++++
>  1 file changed, 17 insertions(+)
>
LGTM.

Acked-by: Zi Yan <ziy@nvidia.com>

Best Regards,
Yan, Zi

