Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 506C31099B32
	for <linux-mm@archiver.kernel.org>; Fri, 20 Mar 2026 18:11:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BD7336B00B0; Fri, 20 Mar 2026 14:10:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BAE8B6B00CA; Fri, 20 Mar 2026 14:10:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A9D416B00CD; Fri, 20 Mar 2026 14:10:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 974FB6B00B0
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 14:10:59 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 4EFAB13A6DD
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 18:10:59 +0000 (UTC)
X-FDA: 84567232638.12.DDCBB24
Received: from CH4PR04CU002.outbound.protection.outlook.com (mail-northcentralusazon11013002.outbound.protection.outlook.com [40.107.201.2])
	by imf08.hostedemail.com (Postfix) with ESMTP id 7974C16000A
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 18:10:56 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=TzyWjwg4;
	spf=pass (imf08.hostedemail.com: domain of ziy@nvidia.com designates 40.107.201.2 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774030256;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eM5uoeC4obMl8CVNETQXrNa5pqnSLheUoY8AcQwLytI=;
	b=icC3tA1F760kvoFZm9Xv96i6trYDC74vr4Rz0Iv0gq469GR2D8e2X9NMJg2MZfZiIuKiMg
	sYC3kyT8axoSN2hFp1lDUiJbMZ/4Fv1i55KINGvOZCJwZikYirHaacqcxZwscK5o5d9LnY
	UkFwimpzY5QKe7F7WaIzOWciFaG8gAY=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1774030256; a=rsa-sha256;
	cv=pass;
	b=R0TxWD2ONQt6mMDD3Wi67ijHoclPjYfZhmN1m0kkFtU4ae+eYFGsvoH3DT3L3Ul4msuq8y
	vcw6/L2gGy94sXCkj1EGHm5vpXDqkcovYCj61TP/qWeBzJzZEjY2dPDUqzXMvFUCvDDl/H
	G18UrOGD14MTqAdQHIQNiocIz5jimKk=
ARC-Authentication-Results: i=2;
	imf08.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=TzyWjwg4;
	spf=pass (imf08.hostedemail.com: domain of ziy@nvidia.com designates 40.107.201.2 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=r0JflTmvQbhHZl18mC9YugX2bFIzaUJJsjcWbggwc5Otd/KZJMTwXvSa1PTbtjBdDA2gsrllhqG4JpGUHl7gBp5VnM/n3UfO9Q/7lyFTB221RFui+MzdpLuxVGQBCHJmVmmJMJgCEsPUjYz53R4afSrtEA5uS+6uSFZue7lQH10h5waRPYmbgSEhqJrbHfmlG3f764YSTXhGqjokI0RaMpzLPiI63VsGT9RjifSh50tQJUaVNPg7vxwDNLGc3pKYZQoZT++pStSncDPrDdYrY8W02t/EcwpZnnN5ZjeYAKTmG5JJ15sdauHntcZU4rpR3rv5JWorh1uUq1fmGWa8Zg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eM5uoeC4obMl8CVNETQXrNa5pqnSLheUoY8AcQwLytI=;
 b=C5V42GO5cqNJ+6jduYdtXXb0A2x7+NU0jYRvmh+jyRcd5CYcLnpwPIMbd4SIsxpv2GqUQbc3XiPvGirfxZfSqPpv2U2xYzPotI8bVnuQpVygjBvTfN60KEalUbfkJBBp3FkfgTvE8I+BYcIsfVlgxjRZ7g+tER+rDLrmtllFXHd+c7LLugYmRHWvkWEm7TlqxxzOjPX0aPpSlIvitgBIlECmB8NYQqeywMAcs3iovzokHWEYBK6QiVn6af4nrjQMkalyoRjbWe2ZIGwJzVKISElliBLH9ekcRuRiW0DxAeNGw/uPY5SwXGB6pdI7y9R+wAWYrKRVUXZYsz37HDXuvg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eM5uoeC4obMl8CVNETQXrNa5pqnSLheUoY8AcQwLytI=;
 b=TzyWjwg4VpfTbExlVUOwYXSAhC5R5FkRzd0YvR/WPzMcbpVbrGGnhhwPvCCQJ1anwBWK9duzJy0qTRCui4uZjD/x9mdF5YJtNS/Ka6npA5PynXkjiKeVSDlL6dxcQYTL1rETWKW3YYJ0JchjxmM+A45Qr2mpFMsChmpkpFYqfqSuO2zxkypXDnS9/qrWL6slcTcI4vS4SODr7iGyE6J3SsJU1kOQrSMRM4Vr4sXQBinunIRAPOZ6kyk3wm8zuQBIglYrDN078yPh3IzoJbdz3CJNp4T+u0uYq/Xu0yqE4Hl5NbaCg4c/nONzCXAQnHu/+UeE2KR//cLu9+EE0OOAmw==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 LV5PR12MB9778.namprd12.prod.outlook.com (2603:10b6:408:300::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9723.19; Fri, 20 Mar 2026 18:10:53 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2%4]) with mapi id 15.20.9723.016; Fri, 20 Mar 2026
 18:10:51 +0000
From: Zi Yan <ziy@nvidia.com>
To: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Hugh Dickins <hughd@google.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Matthew Wilcox <willy@infradead.org>, Bas van Dijk <bas@dfinity.org>,
 Eero Kelly <eero.kelly@dfinity.org>,
 Andrew Battat <andrew.battat@dfinity.org>,
 Adam Bratschi-Kaye <adam.bratschikaye@dfinity.org>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH v3] selftests/mm: add folio_split() and
 filemap_get_entry() race test
Date: Fri, 20 Mar 2026 14:10:46 -0400
X-Mailer: MailMate (2.0r6290)
Message-ID: <26961CE8-79A4-4163-9D27-996E01BE00E2@nvidia.com>
In-Reply-To: <def912db-ea7e-4cac-afa2-8e0b9c279549@lucifer.local>
References: <20260319190409.294523-1-ziy@nvidia.com>
 <6b087c27-a5d5-4f49-81e6-1204209b0c89@lucifer.local>
 <D60C0C65-11E3-4060-9295-B67F90E9D774@nvidia.com>
 <def912db-ea7e-4cac-afa2-8e0b9c279549@lucifer.local>
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: BY5PR17CA0042.namprd17.prod.outlook.com
 (2603:10b6:a03:167::19) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|LV5PR12MB9778:EE_
X-MS-Office365-Filtering-Correlation-Id: 04d531b3-cd98-4928-978f-08de86ac057d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|366016|7416014|1800799024|22082099003|56012099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	0PR/HipYkCFj2cnsLtH7aT99VZ38PwFFm8U+Ql+QbL9+yMT7UPUrLo6lopyjelyHUlOmUcgq3wFX1Ho8rlR0SgmXhwcW8cL06RuIIqeNuUIkRFICSpfAosA3pJOwfygdoRpDRyE7SKwKxguc+WTOhbFtoJ7CaeDMzst5LPEgLTkNRDFI4KvDKDKA6gQFRqQFK36rGtHkR3grX5ilR7XBcBfTkDSrrUZ3Ex3wAhy3bl/nUy/lf6PpYedEBeFdUQWbWF6XK2F8lLebSoQzJYapQBc5hXCyIbJxD6VUuuYCuKefi9ddSqHjc8JZvA/eMGnpM5lWf72+VV7yhFi+u5923Yelal1+YMf0PNprKxw+erQ/21m3BXfSHvwkKJL7++S8j5DegCjyQJ68xnL7Wz6ghgnH3n7iyPPcDJsdZfGa0A9L+hXk30R2YJb8xpj/3elOzL5kbRZbIMc6S2W844VD1A/cZXCQPK8f96+hmYrJv358xUbKgQAaNTCYsJ9BjCEum2oineR0eMxrLBCFrXZQ8OqqevZkgaOt0nYz/WwtE82XsGhCUkulsEAjqsNJMrTpjkMPRkhiY2GwLkS/0B5Se3Ud/KZPF16zHnIkaPQjW814tBnk1uAWxaJX1wQq9B+aOTZmZ75cDgbWBy/nqaW2uyG+Lkb0iJ1eUMhrJ8RlI9xinSUyWsD73+o991wV5MWgYLgQhHDiHBz1Caq1L6yKnErAGbjpY1k00y6pA6R2Pq97eHmLzDRExv+/yfc/XoUd
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(7416014)(1800799024)(22082099003)(56012099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?4JJBKezKjT9GY9MbX4w9tAqYDtV2akqR2d7WIcL6ZuGJ1FVWtvXBo8g8qiZ7?=
 =?us-ascii?Q?sgrsFDRUY0ckircUwPvHaKWvJTTPZLRlmOOP3rzbfu47P9tPruYSdW1RtV0Z?=
 =?us-ascii?Q?B/hfM5wcD3vpCTkbMIWA7eK+hMFR5DIZQFSf9PfiDb/u6Xan9Nvm5hFOUfek?=
 =?us-ascii?Q?h5DtkPmdOYEpAmy6KaCB+g2eneoV2tbVp0fi1Z/Lymgy6M7KxXQWJgfP2v7U?=
 =?us-ascii?Q?+f0HNeCJC1ikiUTyZlNuNjL3nZ8U8pAgc28lB5fRiA8G2RVhtUuYkTk+4nGO?=
 =?us-ascii?Q?5emnrin8BFSxa0GHWrmlgEUlIOSTPFLfcBgfifvVvgIPr4XBYU1qSPngLYL6?=
 =?us-ascii?Q?kKn/R/U6DTq3a5F4+2j5sPWwjX1F1i0dfvko3neBKS+ZJnkMXnnozb03CXj3?=
 =?us-ascii?Q?OGbB7+9UAIx+W+jdoo4RmwPMHFKrk3rVBXve1V1gNspGoPvX53TqzpV6MIKQ?=
 =?us-ascii?Q?NMy8I4OyEabT738N5LBx9dBktHTHhhnLBrEN3nKskck66BwcXXbpEBkbQbmS?=
 =?us-ascii?Q?u3k2CvpgWusPKesrR56kQoadoTiayEBhoN+Tjwgmpv5qUqzUKNI2oxg1fexz?=
 =?us-ascii?Q?UAlFOGLwP6UrMlWInEt8B9TozaMeEFf3HALUhdfSSs92ZB70jPJLzy453yZH?=
 =?us-ascii?Q?5GVEqdbz1l0BbVQzp2U6OOhKAO+L8co/7vFaqeHyuJhU7k5uH/PaJeUjlPAv?=
 =?us-ascii?Q?ztUfvk5MILVL2sDyPYE3dJRrEd/xsSFPdx+7NowtizqKM01krP1Hc6XDcGX4?=
 =?us-ascii?Q?1ZjORuJUN1jdUKjv2HQYP3GNIC/u4e8KV6A6LKPuXBcUJQjZGtPIGGmD/6Bm?=
 =?us-ascii?Q?S/lqvvJrMuH0/l/pYcvZK5aeloM2JhDK4Yj3ezvo/2BRrlHVaQRW3X+KDcOj?=
 =?us-ascii?Q?PPOVMnrw10h3/hlPFhl3ZSaqqGAqyFiv4PIlbeDrf0geWH9GTUoe2w9mQHs4?=
 =?us-ascii?Q?YvmCqif3gb838At+7gm7UgL6zwUYJG2+rcRI4vjF5pDK4d3akaGPxszvkLeU?=
 =?us-ascii?Q?xTZc/B1X73NfXIsR2DY0JNkp0QQfF9a1xMoItLX/ef0fz5GqROnr+1AcKPol?=
 =?us-ascii?Q?ssOQ+uF0U9YHv4TeT8vz5a7WTD/yy3Zr6gezOVJWe84fgJqi0i0LGU0o/H8A?=
 =?us-ascii?Q?GoukmRb9m5/25t9Bm0FFwpaARclTY/WSkO/QDAyuJGteRFf5RazVJLeemNyk?=
 =?us-ascii?Q?Gm56+X/ubD2kvXNtgyX3umayCqJXR7eJIYlZfquEBGEWj3l3FbHwbwmsBx7V?=
 =?us-ascii?Q?v+9k9DGYjTd+UTA74R6tu2QvNCNim+eCEUO/xBjy/LQsyFW8QAOSYIqIaDTM?=
 =?us-ascii?Q?amtWak+7JW/QRVjUotZ937hZ1x6KaHhYk0VzGwoZPz2q1gRXZVAdzGFYD2zt?=
 =?us-ascii?Q?LKEmjRlmlHER9K7ACJz01/TML9NLKn4vN5abWDuiz8O2M1zfiKPU3dF+EO3A?=
 =?us-ascii?Q?J8R2xh2vI1WyCAadie2rGa1nLwQ5DNYGyRghIfRPF3fuWO7FYjjRl64ynWTX?=
 =?us-ascii?Q?5N5R7t8H/E/4BzFGzIK+ZnEISCMPLYjOAtWWkkTvFSHJw54szdFoJ5FYHTn9?=
 =?us-ascii?Q?oBwJvo/D7HXSJ+3SdSpJAll8PaTlWjibi5YCd1ilLFY1If7/UWk7ATy9ZWTi?=
 =?us-ascii?Q?rXxbuX+K2vOC30SN1ZermAEmY72S2mydVjE+s4Wl2k0sIYZyUkogkDeWBKJF?=
 =?us-ascii?Q?bZGOj6O02nMjn5c0icMRnoWD2bvM6Z4I6BJ2VIQrj8J6fggggNX9emZdVHgd?=
 =?us-ascii?Q?Zf9C2+vuGg=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 04d531b3-cd98-4928-978f-08de86ac057d
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Mar 2026 18:10:51.8992
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KAfmCmY6tYSIZjHyeQ/k+Up5pQ5v+uNjqSq5ge4+1xk5Dr36gkKzd263gAyht8+i
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV5PR12MB9778
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 7974C16000A
X-Stat-Signature: r4n95rkktmrigo6x4affdtaynt8fankk
X-HE-Tag: 1774030256-202828
X-HE-Meta: U2FsdGVkX19TIe/bj3FEmvPPGqKSUhef3H0AcTFetWLM8EL9NzwuP14u/Fulw8zdCmdnmhcqXHWLBj9klSzE7FaFa02z/AhJkJ61iRnLoOww+zOszCzwKR1c9RBQt/WvmtCtPOOhuM/YOkVnfC6LyImJgdEbmKzRz2Kgqzy4j32zCM+SUGsxbhMg0wXI180UC8uZlwmuyLCVqOlGGhfVeqdscvoxt4ZBtDRnXVV+TNcQvtqBlHK8/Uqa4FLNGniZmALyUagjo6NVS/+EHhTzLPIIcLrYTkX0cH7Gf1ltmhuLim2zhh6w4rmCVE2oEegvdM1VuPYKYXi8YL3Uny8VsXost66FjBf5OBxREZB82s4zrjP1Yp9CXxlXb8lYq60zYT+LWnbc8VPTnrKHLF2HhQEsYgFd4iQQGXWsf5GWBk20oDMTjeP5kwk07BWJx1SbaVOtkWaXpiFSS05TfpB2OXzvMeuY5AQfXAFuFIrAtK8ERiwOGCrpNGFPFZkwXLwmpGHFJQJ6Chii0HIXd7uJMPhzbf0y5vi7c0fi6zh1QgxkQbs6/QfED7Bdvi6PnLcos2vop+Y/ScqkqvF0vAMISqN4ztJAO5CCW0lYp+wCtG8+ir35f5JA4ZvqcD4FXnzjYcuJG3Cjq0KQM40j/+60TRJbgF7FkHP2+KpOjuv4ZQ45fjCpKROiEWyzxDu1767DHKWVcnCt3KsVN42hKsSNQ9AQcRyEQjgq44qRpbL8HUIkfAkAbL78mfDOklt0LNnhutnn3V0LRQYoOwF6pI2yjPzpn3xrItdYIQUgOrr5XHYhQep9nexNZCjCeuiNZwIFquJTld09LNjYKefDxf+rFn68yyMx5AKR+dQn3ojhlu6VjrmVkwVndeatYjPn6Mqlq3gA5b/aKUiuWPecOYab/1L00O94Vd75vrggfI0TpKzyhT5+qKdeOOBKynTS7nmmLjDynQ/QF1j5bwrLmXt
 aU+8owoC
 2fQTF3mCeoAcpxs3Cr1YXWk3vMqZpIC1O8X1yzo3fmm+Kqql80B5BccDLgXGV6QHfv69lC1q2aGpQBCnYvcUhB0/Be4AsktLz5vszym1Z/ilTmSdKswwblKZguXn25hBiURCaagKSQvIk9ErP5yWiw+VDUeZVNk0pIJZmTcFKLpgYS0pBDhxAzwhv5jqtk2ENEGJBmxxDI03eec/E+8VYIKgW3hkzS43xr/w26thjqBJd7++jdTuc7lWAcuvVEqeIFcMxthqYW9RMZchrWgEYkJlypHtuUfPVw9ZiIc35cNxDPSMNqrk3ElJ23Yq0lczSycGm4YV2ylZhoPdYL0ZySsfsx2/NNh9sXuZhdJkDH/WqAbWeT3zxyDaHncyavllTBLpBpTTzTzde28xFGyehHDM3JsMtrF81M1umxpQLANxAG+4iB8i5w2by+pQiP0//jNF2cXnfhvV3mr2RW4NQ7YLU/toTwJX48UOubnaFpHOREzFKWN0rbVrQkOtAodRNws8azV1jA1TShdF21vTUa5nhrsu9dSkLS25V7NjlwY6inLPHJHePXch+bg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 20 Mar 2026, at 14:04, Lorenzo Stoakes (Oracle) wrote:

> On Fri, Mar 20, 2026 at 01:58:18PM -0400, Zi Yan wrote:
>> On 20 Mar 2026, at 13:53, Lorenzo Stoakes (Oracle) wrote:
>>
>>> (-cc old email)
>>>
>>> On Thu, Mar 19, 2026 at 03:04:08PM -0400, Zi Yan wrote:
>>>> The added folio_split_race_test is a modified C port of the race con=
dition
>>>> test from [1]. The test creates shmem huge pages, where the main thr=
ead
>>>> punches holes in the shmem to cause folio_split() in the kernel and
>>>> a set of 16 threads reads the shmem to cause filemap_get_entry() in =
the
>>>> kernel. filemap_get_entry() reads the folio and xarray split by
>>>> folio_split() locklessly. The original test[2] is written in rust an=
d uses
>>>> memfd (shmem backed). This C port uses shmem directly and use a sing=
le
>>>> process.
>>>>
>>>> Note: the initial rust to C conversion is done by Cursor.
>>>>
>>>> Link: https://lore.kernel.org/all/CAKNNEtw5_kZomhkugedKMPOG-sxs5Q5OL=
umWJdiWXv+C9Yct0w@mail.gmail.com/ [1]
>>>> Link: https://github.com/dfinity/thp-madv-remove-test [2]
>>>> Signed-off-by: Bas van Dijk <bas@dfinity.org>
>>>> Signed-off-by: Adam Bratschi-Kaye <adam.bratschikaye@dfinity.org>
>>>> Signed-off-by: Zi Yan <ziy@nvidia.com>
>>>
>>> No .gitignore entry? :)
>>>
>>> (Just saw it flag up locally in git status)
>>>
>>> Linus says don't remove, but he doesn't say don't add :P
>>
>> I did not know about that. The fixup is below. Thank you for pointing =
it out.
>
> To be clear I'm referencing this re: the .gitignore _removals_ ;)
>
> https://lore.kernel.org/linux-mm/CAHk-=3DwiHK5_oBUdUiNAaevmN9f-ORe+QBqb=
RefAZaw-RbgEn3w@mail.gmail.com/
>
> Thanks! :)

I did not know .gitignore file exists in that directory. Also good to kno=
w
about the do-not-remove rule.

>
>>
>> From bd164a7090c0e8b6e3013502c64c161214e38714 Mon Sep 17 00:00:00 2001=

>> From: Zi Yan <ziy@nvidia.com>
>> Date: Fri, 20 Mar 2026 13:56:04 -0400
>> Subject: [PATCH] git: add generated binary into gitignore
>>
>> Signed-off-by: Zi Yan <ziy@nvidia.com>
>> ---
>>  tools/testing/selftests/mm/.gitignore | 1 +
>>  1 file changed, 1 insertion(+)
>>
>> diff --git a/tools/testing/selftests/mm/.gitignore b/tools/testing/sel=
ftests/mm/.gitignore
>> index 83ad9454dd9d1..b0c30c5ee9e30 100644
>> --- a/tools/testing/selftests/mm/.gitignore
>> +++ b/tools/testing/selftests/mm/.gitignore
>> @@ -61,3 +61,4 @@ guard-regions
>>  merge
>>  prctl_thp_disable
>>  rmap
>> +folio_split_race_test
>> --
>> 2.51.0
>>
>>
>>
>> Best Regards,
>> Yan, Zi
>
> Cheers, Lorenzo


Best Regards,
Yan, Zi

