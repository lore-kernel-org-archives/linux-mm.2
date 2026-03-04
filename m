Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E7645EDEC01
	for <linux-mm@archiver.kernel.org>; Wed,  4 Mar 2026 01:27:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1DB286B008A; Tue,  3 Mar 2026 20:27:46 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1AFEE6B008C; Tue,  3 Mar 2026 20:27:46 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 02D2A6B0092; Tue,  3 Mar 2026 20:27:45 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id DCD4C6B008A
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 20:27:45 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 8AD8416038B
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 01:27:45 +0000 (UTC)
X-FDA: 84506643690.03.18DD2ED
Received: from BN8PR05CU002.outbound.protection.outlook.com (mail-eastus2azon11011034.outbound.protection.outlook.com [52.101.57.34])
	by imf26.hostedemail.com (Postfix) with ESMTP id C0B8714000A
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 01:27:42 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=HAdB9uB6;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf26.hostedemail.com: domain of ynorov@nvidia.com designates 52.101.57.34 as permitted sender) smtp.mailfrom=ynorov@nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772587662;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IGeVqNjwUVnnv04DLmB98uerxeVeGpf0Q+oR8LtmdS4=;
	b=ccjtlhAbtHztFvMcmeJqeh+m4FmTaTNCxAusbe71YG8vyBpL1PwckEk3LLe8Fm5aD0yeO0
	h9Y704F/zvp0rtMWljDlVb6LT9yeeY5wrZ3R5Qty0tbK9rNPfwSb5cj2LI/eyxqtzw37ih
	cGeTu+klqB039s5Cf1aAtMwNaQz1pl0=
ARC-Authentication-Results: i=2;
	imf26.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=HAdB9uB6;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf26.hostedemail.com: domain of ynorov@nvidia.com designates 52.101.57.34 as permitted sender) smtp.mailfrom=ynorov@nvidia.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1772587662; a=rsa-sha256;
	cv=pass;
	b=jFCRcfS2iegMQxS9/Hakiz66qj1OwujROzi8RYLE29Vc86Dh6zNCX5BNt/qVGGiL9pcZEc
	iU+iiKu8R8R8TbznBcjd/NwWMQHf984kBZW+0tfRxXG5JBxC6V508hkDZEOHMqKup3sHQW
	yjVoh5upQloZ47qjgEHDdIwNf9ugr/Y=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=iED0zGCIOOIGU62GmRCVpWBl4c+rcUp6nvjfpNp+y42ccMhjVzIC4Qh6UrnJB/WAgSUv/z8xKvhbEn99Ro4VnimRZiY/W4IZ97U17fOq87ZdsyQ4o250CFCenYqC+sWajKdLylMsip3Wm7IaCPVhhHZe/Mw2sO09yhFFDDeXH88wuXXHV5rgJ/Gd/vKq5xb9LAtAqk7Y/L1GFcnKv7gsVyEqTqbidBzlY9FMoc4ymm8koxNK7G4oercgl4GqeXqSDf3D7Khnr55aPSsH0seDcGlkDG266Gh7078DSeDXcdGYOGE8BuNBR45h/NPl2XNaheNAg1vhdK4oE9nDzvL0Sg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IGeVqNjwUVnnv04DLmB98uerxeVeGpf0Q+oR8LtmdS4=;
 b=FROr8t/eU/NjMTlCCl1Q0jOq6ly5hP4t8wh2Sit/V2nQBk/DBPf5Kpo8hbMjbKcDRti+R1UnR4/nJn6lTmjWfE2cayyh3qBFf9hEGoLuwdKbu90dPpX9h8A9Igf65pFj1DhlE5yIYHjC4bMtb5OEPCSWVdH8HNcFiph5JNsNpPo+L2DqHjUwnmhX9iu+h5u1Y4nZ5rbLuC3kb0O+NqfUKTMlqqveP4C56IUqCxKTdxeABkb/YcPq+Bl4LwA2OL1widR10f40aZwkAS7dcjILxbFS+qeUz28WsZfUAkLA55Wr+fKOKhrsyTHeHcWCzXFdQGwiWnxnFc692w8nZ4OROw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IGeVqNjwUVnnv04DLmB98uerxeVeGpf0Q+oR8LtmdS4=;
 b=HAdB9uB6yOxsfFxjKqy+x0vwh8Lw5wacGIxSYUuFMIEygGeP+d9Nerr8p0NBIptkG6w32qkNBKgdoGt6sr6dUvdAGiWdVQtuONAIxdAtHvUWo+IVKsO7tzCXV88la+UgV986BGF2xmU5GNtvT84HQkHE3Z6GGgPTJEUJMwPmPBKyy1kXnTgWmNbWNblxst5GH0RQBaGMcz+KKD577SEWeLvIX4XJ/oki/TgWv048Ew3sRj0wzWpaQD7ZQpe1+oC0wO8X4T09RvjwGaHDeFFLCZAU6SRE/A0QMIXoIvti4bIQXekbueA0wo0vwtR3sGn3Dc9DlEd4dxYVvW9kpj4IOQ==
Received: from PH0PR12MB8800.namprd12.prod.outlook.com (2603:10b6:510:26f::12)
 by IA1PR12MB6651.namprd12.prod.outlook.com (2603:10b6:208:3a0::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9654.22; Wed, 4 Mar
 2026 01:27:24 +0000
Received: from PH0PR12MB8800.namprd12.prod.outlook.com
 ([fe80::f79d:ddc5:2ad7:762d]) by PH0PR12MB8800.namprd12.prod.outlook.com
 ([fe80::f79d:ddc5:2ad7:762d%4]) with mapi id 15.20.9654.022; Wed, 4 Mar 2026
 01:27:24 +0000
From: Yury Norov <ynorov@nvidia.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	"David S. Miller" <davem@davemloft.net>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	"Theodore Ts'o" <tytso@mit.edu>,
	Albert Ou <aou@eecs.berkeley.edu>,
	Alexander Duyck <alexanderduyck@fb.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Alexandra Winter <wintera@linux.ibm.com>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	Andrew Lunn <andrew+netdev@lunn.ch>,
	Anna Schumaker <anna@kernel.org>,
	Anton Yakovlev <anton.yakovlev@opensynergy.com>,
	Arnaldo Carvalho de Melo <acme@kernel.org>,
	Aswin Karuvally <aswin@linux.ibm.com>,
	Borislav Petkov <bp@alien8.de>,
	Carlos Maiolino <cem@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Chao Yu <chao@kernel.org>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Christian Brauner <brauner@kernel.org>,
	Claudio Imbrenda <imbrenda@linux.ibm.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	David Airlie <airlied@gmail.com>,
	Dominique Martinet <asmadeus@codewreck.org>,
	Dongsheng Yang <dongsheng.yang@linux.dev>,
	Eric Dumazet <edumazet@google.com>,
	Eric Van Hensbergen <ericvh@kernel.org>,
	Heiko Carstens <hca@linux.ibm.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Ingo Molnar <mingo@redhat.com>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Jani Nikula <jani.nikula@linux.intel.com>,
	Janosch Frank <frankja@linux.ibm.com>,
	Jaroslav Kysela <perex@perex.cz>,
	Jens Axboe <axboe@kernel.dk>,
	Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
	Latchesar Ionkov <lucho@ionkov.net>,
	Linus Walleij <linusw@kernel.org>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Mark Brown <broonie@kernel.org>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Miklos Szeredi <miklos@szeredi.hu>,
	Namhyung Kim <namhyung@kernel.org>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Paul Walmsley <pjw@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Sean Christopherson <seanjc@google.com>,
	Simona Vetter <simona@ffwll.ch>,
	Takashi Iwai <tiwai@suse.com>,
	Thomas Gleixner <tglx@kernel.org>,
	Trond Myklebust <trondmy@kernel.org>,
	Tvrtko Ursulin <tursulin@ursulin.net>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Will Deacon <will@kernel.org>,
	Yury Norov <yury.norov@gmail.com>,
	Zheng Gu <cengku@gmail.com>
Cc: Yury Norov <ynorov@nvidia.com>,
	linux-kernel@vger.kernel.org,
	x86@kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linuxppc-dev@lists.ozlabs.org,
	linux-riscv@lists.infradead.org,
	kvm@vger.kernel.org,
	linux-s390@vger.kernel.org,
	linux-block@vger.kernel.org,
	intel-gfx@lists.freedesktop.org,
	dri-devel@lists.freedesktop.org,
	dm-devel@lists.linux.dev,
	netdev@vger.kernel.org,
	linux-spi@vger.kernel.org,
	linux-ext4@vger.kernel.org,
	linux-f2fs-devel@lists.sourceforge.net,
	linux-fsdevel@vger.kernel.org,
	linux-xfs@vger.kernel.org,
	linux-nfs@vger.kernel.org,
	linux-crypto@vger.kernel.org,
	linux-mm@kvack.org,
	linux-perf-users@vger.kernel.org,
	v9fs@lists.linux.dev,
	virtualization@lists.linux.dev,
	linux-sound@vger.kernel.org
Subject: [PATCH 2/8] fs: use rest_of_page() macro where appropriate
Date: Tue,  3 Mar 2026 20:27:10 -0500
Message-ID: <20260304012717.201797-3-ynorov@nvidia.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260304012717.201797-1-ynorov@nvidia.com>
References: <20260304012717.201797-1-ynorov@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BN0PR03CA0018.namprd03.prod.outlook.com
 (2603:10b6:408:e6::23) To PH0PR12MB8800.namprd12.prod.outlook.com
 (2603:10b6:510:26f::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR12MB8800:EE_|IA1PR12MB6651:EE_
X-MS-Office365-Filtering-Correlation-Id: 9d5ef22b-1a57-4eda-0193-08de798d3048
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|10070799003|376014|7416014|921020;
X-Microsoft-Antispam-Message-Info:
	bq+OItVEjdFj3R+kSIj8PKEZm9rT2y72Umt3vM6mAdwTCUfbmoyjvTbDhdJoFEhLLmlcq3evDSyyZ+iWXxITH1xXhno0JvFu/nGAF/UPSkQprLoUB938yE88wGnc567MO3rFTipNYwDi7anPyn3cfBC6zgopKbjPxlyeXhfOuJvIJaAykzrYaHALi+dF/Qa5vKZG0uH7/RRStIXf4RAXGQvILSsPW0hcoSySepVkwW/fuijq+yP9MwW7+nfk1zrTrOxKh++QwwiLaI5uKmuQVUqN/pNs/Ky/nx7mZ4bcZbrFKXK2c8i3GQY0MiRjPO5bB45GBmS1Q56XvqdDdkJIlTJz9P1568UV96xw8HnJzQzyh271RTlP4io7fRsXp3ndh/qrk2A/q+zwx3XIVpNdQyM3IMatyKjZu5AYKmuOpqvWDx2N2knNrOLhmQYNpQQHyXmj/HhUa4A+eDoGfBpIPsHtpC1UrlQ4yX8gjbDJkArhYDbbWXbfNwYLuVBm9D5cGqobbLoY58lZbVlzKTUa+gLYXJhVtjmVjptZYidvzSZ0w5KfxDqlSkeK5qDDtmYFlO7l6FgRDqjYGnGK6qj179cHWrrhl1SAFeNiEJw93PNuwNp0gqppDjxaWunznNuI/uZvl4Mm9kF8gMsGIeCBO8OkvrnzcNr+wWQ1t1wN/L13jsrvkAZCVEFCMxi6tSgDbdsKma5a6jZuBFn6PFoc9w+qBF/g7Fs84L3OEse0F8n56h2v9e0bjPQliaTW0W2NR+cE0qNUjWtFjN2MlGHLOg==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR12MB8800.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(10070799003)(376014)(7416014)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?0Cx8YW/ZsWdlp5nFQSFDMtaaoiKhzaf/iLi3FkL2TcI1hmc3gF4PC3YAfJ8A?=
 =?us-ascii?Q?L2Vwrv3zrshdG8iMD/wC8j8W+A4rzmsbC5fkIE7CLhvzlRKC+YkEY/JfEy2X?=
 =?us-ascii?Q?3YICgbR8OJ8fsGU/Blevb6MyeArwnN0UKpxcE5vz1TURXEkcQWMu0eOfkVqx?=
 =?us-ascii?Q?ZQiA1kkG7K05zOibALq73zZU1w4M0ZWTHJP+9WRNCnlbew532HDOd+tgwpwn?=
 =?us-ascii?Q?olPnhH1dwRH9XNzrKMYbKq537vCeUBs0KQh0s0g5/aH27PZU4ZNT2FlXa6py?=
 =?us-ascii?Q?SFoaCNPSJcF42FtYhcaDiyRp7sQzg9HAbHOq6in26uXwd4A8EElWljIyTcmo?=
 =?us-ascii?Q?MW98ruS//lyQV7ZNXk5kLkiXKHMwNNxs0OEhiazYS+ungmX5sSHLjJFQH/Db?=
 =?us-ascii?Q?/rDRUI0oMHKUpbVr5Qyui+ZYTPgzyJg3DI7WeuaMvSN6ZslvAqlX6KdEE543?=
 =?us-ascii?Q?4kpRE8GRrxwbxbNveyPw7+6OR1pdIJv0JrYY7J03ZcbZmU1GQzL+9gH27HzX?=
 =?us-ascii?Q?zDHVviRxpjy1+YhB+agGNVW1NUJtaR2uZKM61S63lypR2V2+MO1kgzIahZMt?=
 =?us-ascii?Q?r64dncefS/1q62c8MpgSHZnXvdizUl4H9flHaHjWAdiU+CoIyKtj2KPJoD2U?=
 =?us-ascii?Q?c5WUCGqzs8xNACpgDglhacwJFAwErM+q1/fxqb+y8VeaBaBYxKvyEe7IzQny?=
 =?us-ascii?Q?+MexxiYVGkBjEScScU6c/j2Qs/Jry2gYbhhpj/kNdWX6cF5Wp1q1iuW3NGP8?=
 =?us-ascii?Q?jLdrvcn3j2YqUwOWTewREmPTV8dq/3TvyQhkyJ2l77VySJ6KjXLK8Xt2rBgF?=
 =?us-ascii?Q?g99Euy6agN+ghLeiuHJVxOZw8pHwV0u5gnzqlm+3E8pOGKtX+v1277DAlZk6?=
 =?us-ascii?Q?uQMw0HGntg+KgfN+10XzLhshiqclcPgbQjcLR97MG500DmVj6w7l1u0lrS9Z?=
 =?us-ascii?Q?O3BFI2uxPqmzMtII7++2BtsD8LzAGWqLhGz1pUvXO5Bd97WVF4anogmUp3TQ?=
 =?us-ascii?Q?v92iAdx8Mal+8ND57UMvuNkS/AXYzW4bi+pIrCGBd2XU9hZoH2x2ZRUlRHpk?=
 =?us-ascii?Q?oy1VQVC0EY2ISFefNuTiFLbTgkggffX8+UoO8mkjb0Rsyiv6UWW4UpRnVxhV?=
 =?us-ascii?Q?RSNHfmq8rsS++CcG0UaeCy3RqPcIhMfgrd7Bop9K5s9I13kwmBWRwpQEmcvy?=
 =?us-ascii?Q?LZSTFf4UT52doFjRIJ5vTt35w3ZwQSHyBgtN76neJ/Rcz9msbCqkp1TONt22?=
 =?us-ascii?Q?ywpxy1ZtHSvdVQ+TMQEDjKaTVlMP8mrTfqNOEEYaYniokApzhpBPXV4bbbXi?=
 =?us-ascii?Q?dExGARuJ/29tTxVLyFUk+lVgh0im4zeUP5/G8ragoKnrVKMx9NM72NojAS16?=
 =?us-ascii?Q?MvqQlLEuWMTwDGHI0XvwX8dfaZzsdImcI8BDw/iu6R3jEoN85/sDZ4pqoxkg?=
 =?us-ascii?Q?2hDwplKA3ov4IzP+chPJVbB/yLlQyLVudahT8UIS8uiJr9qvqM1zB6L+HOh9?=
 =?us-ascii?Q?UvsEixM41PeRmyaP5s7SX04n5xHx7OIJfYuZZr/9sAMtO8VCx8ddqd5Eu2oC?=
 =?us-ascii?Q?csXFllxMbHLTxD7Nq7ElZ3blrD1YTzwtj4qTgykMm0QxVcAagLSTAYua3ydX?=
 =?us-ascii?Q?CPoA7QnwqeGHgYEvGivQ3QEMaYUjfqz2JDOS285A7aERo/APKUlcVkzYpz04?=
 =?us-ascii?Q?wGDkkwMFXkq8xCqPJ1bIzLF/PyT2/Iy6qOWh4PG3oj9xJMvG8lUNA2wu3EIE?=
 =?us-ascii?Q?bjm0qqfEoQFc1p6gugm3EOB7t/0Vzv6yKSdSt8ZbC0J0tdN+FWf/?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9d5ef22b-1a57-4eda-0193-08de798d3048
X-MS-Exchange-CrossTenant-AuthSource: PH0PR12MB8800.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Mar 2026 01:27:24.2579
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2dz4Z06b32r8MDduTDf598JW1nm+Vv2JNKiDjsEUMC1d3keIvpVVbRA8cGLPUoaZVRPhJhbPY2DLafNPy1iBmg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB6651
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: C0B8714000A
X-Stat-Signature: tofumgcqydw9jocdt1gdfinos7igje6t
X-Rspam-User: 
X-HE-Tag: 1772587662-12395
X-HE-Meta: U2FsdGVkX1+ymXIQa6CKIp/93lx6+5MJKHdKVs1F4FTd6phnQUn/XF478ETtvG2DrmzRBZNH6upOxM09HevxFhFwRfkZHgWcX/rhzBMNHz20AX/8FFbhjV7rjSZxIQDU4uTqQKHYmVR808EcfskElhmnwbbLT03k/bh5Euyr5Fk1QEKEDd13ol1KgRF/EKL0c9nDgbSyqXI0PCy23WFTz+hm5g1CI6DAntbIcOOZJnbZZxgL3Rw7FzjGK1ED4xvEn/YTjGJxCF00ILlj0lLHk412snZLbVsWz4uHzMKLa3PpzF0KQB5YA9zTmpo+Xz77XwjplhUt//chWMd7iYBO6Ha2T8RvyhhTgIEU5BIVjIZzsTqbph/MuqAMxHk+cpucqa1Yo9Da2sXageC/1s0ULUwYSvRDB9rip8vmEJcLizVTNsOcaewX83Hkhh8/7D0+9fIjuJOY6CsJEHpbQsRDW40U9X25KU8mBpY5gomV5/3S0Tk/y1fkUbI2eGkV9AJuVk5USpndYLxBDi5c0Ko22RmpQh9czyDer9FEk9XLYyDDHPlFPD5m7eGqtFwYrcV7PJ5sw+XFUp7V+H8GhR/5ppujIxJF6LYAmlwH81+GYYsbSAphnTmqf165dr6ZlHEgnlbG1QMWHZk9YbO/9ZDnbLxpz65T2dzaISVoxaD5BxsV2r3wAw0SkebvBEW3Eid8ohtfaEUr6veMN1uYVU6qSXaEXMP0kj4caHcSmFBppEoIYR0TSUs+5fPdzwVCOdCe6HqpRU7E9+5YZp92Kg4Bp64sKhIMhIn3tX5s2DhblvYbUBEE2KuEPNIj8a4QE8JtbE7G7LgDXG/U6zYnQTviue+rBIqYbTWosr6xgsh2zAojxX5zLua1VLTNlA2yKjudTJ4CFVlDg+PZ33QMe+qp1PGp5Hks2+iS4WXHEPrSQDulTRjYu/DrHgg5J/e9CQlwyH9A6oHIb2VCdhxQjIS
 EkgZafYo
 SVYaTD5ikPQoFxLHcFQhxEsqaMuqlUgS+xT+Kk2kWYN4mUJXy1oSWoKJ7oWZfh/wMj17e/PLr/x9i8cJ1rvGHhSSpuHvJU8In7mCMwCh1zGZFXN+smKG+pyvpjUuKQBqmvJINaTqMjpXyvNewOAGWkqPV6n+JHLSceQ6e/vT2yxwrbWwYbrRvLcewA+3xraW+Q67fpkjbLYI3eHg0SPDrQgq4O5HeqxZxT3Ugqsj5wzfojq0rBzv2z0Lf8eQ+g+jOPWozp2yvBoiaUhBuu5R6H4kZdgrpx5J5apMl8YRe3YX0nTGdfQWdpbCWA063HsHgkD4gj9t5tDcS9Nhtc/6t8btMBmS7zk62WUFOS+QqfFw2uYXzYJ/BTC5nX9hT6ouoHzo3hYwc0kLVugeA7qe1tRGFMJFVKoUddXcFWgY6r3tNOGOe4V9FFPP8Vxve1WoUzslXQXT34al4u9l15+v57uhUo4ovZe/F9ebK+WWpUk7n+W9e/KUjH1mzUzs4iq6SB6do
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Switch filesystem codebase to using the macro. No functional changes
intended.

Signed-off-by: Yury Norov <ynorov@nvidia.com>
---
 fs/ext4/verity.c       | 3 +--
 fs/f2fs/verity.c       | 6 ++----
 fs/fuse/dev.c          | 4 ++--
 fs/iomap/buffered-io.c | 2 +-
 fs/nfs/pagelist.c      | 2 +-
 fs/remap_range.c       | 3 +--
 fs/xfs/scrub/xfile.c   | 3 +--
 7 files changed, 9 insertions(+), 14 deletions(-)

diff --git a/fs/ext4/verity.c b/fs/ext4/verity.c
index ca61da53f313..3dc95581e4b1 100644
--- a/fs/ext4/verity.c
+++ b/fs/ext4/verity.c
@@ -74,8 +74,7 @@ static int pagecache_write(struct inode *inode, const void *buf, size_t count,
 		return -EFBIG;
 
 	while (count) {
-		size_t n = min_t(size_t, count,
-				 PAGE_SIZE - offset_in_page(pos));
+		size_t n = min_t(size_t, count, rest_of_page(pos));
 		struct folio *folio;
 		void *fsdata = NULL;
 		int res;
diff --git a/fs/f2fs/verity.c b/fs/f2fs/verity.c
index 92ebcc19cab0..1c3403fbf2a8 100644
--- a/fs/f2fs/verity.c
+++ b/fs/f2fs/verity.c
@@ -44,8 +44,7 @@ static int pagecache_read(struct inode *inode, void *buf, size_t count,
 			  loff_t pos)
 {
 	while (count) {
-		size_t n = min_t(size_t, count,
-				 PAGE_SIZE - offset_in_page(pos));
+		size_t n = min_t(size_t, count, rest_of_page(pos));
 		struct page *page;
 
 		page = read_mapping_page(inode->i_mapping, pos >> PAGE_SHIFT,
@@ -78,8 +77,7 @@ static int pagecache_write(struct inode *inode, const void *buf, size_t count,
 		return -EFBIG;
 
 	while (count) {
-		size_t n = min_t(size_t, count,
-				 PAGE_SIZE - offset_in_page(pos));
+		size_t n = min_t(size_t, count, rest_of_page(pos));
 		struct folio *folio;
 		void *fsdata = NULL;
 		int res;
diff --git a/fs/fuse/dev.c b/fs/fuse/dev.c
index 0b0241f47170..efd7e6ca929e 100644
--- a/fs/fuse/dev.c
+++ b/fs/fuse/dev.c
@@ -1157,8 +1157,8 @@ static int fuse_copy_folio(struct fuse_copy_state *cs, struct folio **foliop,
 			unsigned int copy = count;
 			unsigned int bytes_copied;
 
-			if (folio_test_highmem(folio) && count > PAGE_SIZE - offset_in_page(offset))
-				copy = PAGE_SIZE - offset_in_page(offset);
+			if (folio_test_highmem(folio) && count > rest_of_page(offset))
+				copy = rest_of_page(offset);
 
 			bytes_copied = fuse_copy_do(cs, &buf, &copy);
 			kunmap_local(mapaddr);
diff --git a/fs/iomap/buffered-io.c b/fs/iomap/buffered-io.c
index bc82083e420a..99e56ee6c3d6 100644
--- a/fs/iomap/buffered-io.c
+++ b/fs/iomap/buffered-io.c
@@ -852,7 +852,7 @@ static struct folio *__iomap_get_folio(struct iomap_iter *iter,
 	loff_t pos = iter->pos;
 
 	if (!mapping_large_folio_support(iter->inode->i_mapping))
-		len = min_t(size_t, len, PAGE_SIZE - offset_in_page(pos));
+		len = min_t(size_t, len, rest_of_page(pos));
 
 	if (iter->iomap.flags & IOMAP_F_FOLIO_BATCH) {
 		struct folio *folio = folio_batch_next(iter->fbatch);
diff --git a/fs/nfs/pagelist.c b/fs/nfs/pagelist.c
index a9373de891c9..221a90f57812 100644
--- a/fs/nfs/pagelist.c
+++ b/fs/nfs/pagelist.c
@@ -60,7 +60,7 @@ static struct page *nfs_page_iter_page_get(struct nfs_page_iter_page *i)
 
 	if (i->count != req->wb_bytes) {
 		size_t base = i->count + req->wb_pgbase;
-		size_t len = PAGE_SIZE - offset_in_page(base);
+		size_t len = rest_of_page(base);
 
 		page = nfs_page_to_page(req, base);
 		nfs_page_iter_page_advance(i, len);
diff --git a/fs/remap_range.c b/fs/remap_range.c
index 26afbbbfb10c..83f325e7f96b 100644
--- a/fs/remap_range.c
+++ b/fs/remap_range.c
@@ -199,8 +199,7 @@ static int vfs_dedupe_file_range_compare(struct file *src, loff_t srcoff,
 	while (len) {
 		struct folio *src_folio, *dst_folio;
 		void *src_addr, *dst_addr;
-		loff_t cmp_len = min(PAGE_SIZE - offset_in_page(srcoff),
-				     PAGE_SIZE - offset_in_page(dstoff));
+		loff_t cmp_len = min(rest_of_page(srcoff), rest_of_page(dstoff));
 
 		cmp_len = min(cmp_len, len);
 		if (cmp_len <= 0)
diff --git a/fs/xfs/scrub/xfile.c b/fs/xfs/scrub/xfile.c
index 05581571854d..95707407aa6b 100644
--- a/fs/xfs/scrub/xfile.c
+++ b/fs/xfs/scrub/xfile.c
@@ -135,8 +135,7 @@ xfile_load(
 			 * No data stored at this offset, just zero the output
 			 * buffer until the next page boundary.
 			 */
-			len = min_t(ssize_t, count,
-				PAGE_SIZE - offset_in_page(pos));
+			len = min_t(ssize_t, count, rest_of_page(pos));
 			memset(buf, 0, len);
 		} else {
 			if (filemap_check_wb_err(inode->i_mapping, 0)) {
-- 
2.43.0


