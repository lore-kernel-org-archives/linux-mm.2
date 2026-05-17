Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 58E44CD4F21
	for <linux-mm@archiver.kernel.org>; Sun, 17 May 2026 13:55:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B7B7B6B00A0; Sun, 17 May 2026 09:55:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AB67A6B00A2; Sun, 17 May 2026 09:55:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 97DEA6B00A0; Sun, 17 May 2026 09:55:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 857366B009E
	for <linux-mm@kvack.org>; Sun, 17 May 2026 09:55:53 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 27359120563
	for <linux-mm@kvack.org>; Sun, 17 May 2026 13:55:53 +0000 (UTC)
X-FDA: 84777060186.19.01F1CF9
Received: from SN4PR0501CU005.outbound.protection.outlook.com (mail-southcentralusazon11011000.outbound.protection.outlook.com [40.93.194.0])
	by imf23.hostedemail.com (Postfix) with ESMTP id 586AB140009
	for <linux-mm@kvack.org>; Sun, 17 May 2026 13:55:50 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=oWK8EG3X;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}");
	spf=pass (imf23.hostedemail.com: domain of ziy@nvidia.com designates 40.93.194.0 as permitted sender) smtp.mailfrom=ziy@nvidia.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1779026150; a=rsa-sha256;
	cv=fail;
	b=m6qiWjwYhaLdE6LiUUjmRXY+ZHa/AdwjpEntF3+xux1UgbEuIwpSQ4jlflHxYfZ/+6n1Ei
	Bu2mHf2/bk/yz1s3oqjxnbYkplzGHMvoB6O+dU84Zjn7erLoaP0mgDLtt0lmTXSiGuro6a
	QZ4FoWB5SrpfSWNz/kx6zZB7+ONWa1o=
ARC-Authentication-Results: i=2;
	imf23.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=oWK8EG3X;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}");
	spf=pass (imf23.hostedemail.com: domain of ziy@nvidia.com designates 40.93.194.0 as permitted sender) smtp.mailfrom=ziy@nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779026150;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PvLIPKL51Kbj3vlSAHwOw+N5Ez5Bo2Fuh0RSLikMH20=;
	b=CMfygxbw1FIuvtPJAqNTyIl9tei2SSrKXEaeBx8UPmyw0O5f/ij6oM1FF6XAlGufx7fiMc
	krO+QyQjJ9CzoaZwvVni7R+Gs7kEb2S2li+EnlIYSuZy8h0c9fSyfpoPCIp5i2bK6K8su2
	QbNbpnXc2Q7RngRxwR+f29lADaCkygw=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Jr0tntECgAnu9HdM7nOmZK7AiXdyc8LkcqnX+kfRoJD6TaKeTkAJ4uizxiT9vdHmNEKpLR8ykTraHPSVV8kh2nKbwdr8LKD4VSUEaZSOg7DlzvSy9jNqb/KMqqO8CNoAnZl0PX7jORfIQz4bus1vUuDFKcFGPxgKnFrf8eYrrqAxTI/ZDrZzxCKp2Ji7P6hinrzuyHWR2Jx1/M7oHoziOMgT6xd4PF8Alasl2GfWoBdImw6lEz/vulMk50J+NdPsNTpOI5i96GnzPZis2R62ex1nDB3gSuFsh4c2f9I8ykDn8Hsk+smTLFgxYYjobL9gQCxiICHqeiLquWQuPVfjTg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PvLIPKL51Kbj3vlSAHwOw+N5Ez5Bo2Fuh0RSLikMH20=;
 b=Q8BNgGFdiNZH9Wy5YqdJavc7nzhVglZHOP/bP2QXY8gUHzB9KRGp99B2kIn7xXQ5w27oJ+IIi/fr3cN0Oseq7jatN8QcgiAzKTJr0zTHDcTnSvTBX++4L4cky9yh+RnEkcTKXI8OhLkvXLMMTLH1JG4K/2USt7KUovIrK8/HilQUC643X7p1Yil0dM+EI6Q/w2kfxt/J94zKowN/dMOuXregz46U0HMmtNAB4OgBxhWaSIIzZ6efXJEm+nSR98xTmEZlq5SLLCrS8wU051SzNMbcd6Lb9UyAELrvs68pz9vMso75gaCyIqJcbQhOkPHCPED9dBcUflh4tDZyzd3yMA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PvLIPKL51Kbj3vlSAHwOw+N5Ez5Bo2Fuh0RSLikMH20=;
 b=oWK8EG3XCMhHxXrm+1AJ3F7J4JUy06TwMBMQl4L/+a1aTgSqZDwh2I/jJnha7zyR8tGu7hn20xtk0UGAUogl6Gy8wJ0DUDVSTZ4j8XVusP/QmOjMBTnzhDkVHIvJKcq+d8XsJJK5Xl3QDRQaTEamMcOxWEVbW7oROH3BPnrZbXOPatdns73z0oUYVu9WbK/sJN7R1CTaBW4YAwz0MNyKIGPu4EXdJpNpR+Coc24hHo8EzRTw9yXZzLH8Gym22rxCDRMHuKK7Ab6JvJDxEaziNGpgSfIEVBZX+Dm+v0k592CCq/Fq8jak9Ajszg2It0xaJUl69g+91C/RahOmUshutg==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 CY5PR12MB6322.namprd12.prod.outlook.com (2603:10b6:930:21::21) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.25.23; Sun, 17 May 2026 13:55:05 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2%5]) with mapi id 15.21.0025.016; Sun, 17 May 2026
 13:55:05 +0000
From: Zi Yan <ziy@nvidia.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Song Liu <songliubraving@fb.com>
Cc: Chris Mason <clm@fb.com>,
	David Sterba <dsterba@suse.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	Jan Kara <jack@suse.cz>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Nico Pache <npache@redhat.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Shuah Khan <shuah@kernel.org>,
	linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	Liam Howlett <liam@infradead.org>
Subject: [PATCH v6 06/14] mm: fs: remove filemap_nr_thps*() functions and their users
Date: Sun, 17 May 2026 09:54:08 -0400
Message-ID: <20260517135416.1434539-7-ziy@nvidia.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260517135416.1434539-1-ziy@nvidia.com>
References: <20260517135416.1434539-1-ziy@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: YQBPR01CA0021.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:c01::29)
 To DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|CY5PR12MB6322:EE_
X-MS-Office365-Filtering-Correlation-Id: 78812ac6-5ef6-446e-9d32-08deb41be64c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|366016|1800799024|11063799003|18002099003|22082099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	rwDmhwGdNPx8dmKZoxUg2kMKALsY+R0yFVOvJIhKkjCIIn78NTuVCpmY75Yxtz/ogRn5uJ146cC3qZnZt/5C/ixWAoGgIJa6ukHTiZU58QrfaGROV3AjFfrUptqvF/EuGsw5n7QR4SmBYUCJsJqPyheqWKPFaX6/uXQ7Ai8bf6cF9HZ1pAsPGOkt6jyRiVB9anXZoomrVyc83PoRaLxNTZiq2Fjpd2weZGc57MckqC1IClm1YsJEfk7mpW3iMZl+/sBh93CbqXpqsqMEi9+Nv9iZGEeCAHsVzIZrxKMDzIEIBawBgBiSpcYqXKXIcFednminqH04hFBRRVp7CJ6jM8ccNb90m7YR3B95qAkYikK8EAq1+QWD1yAa+XRurLDATxq96KbEzdDXFETEfmxz/IQ2lM6JR4Cf1EIbbs9WYI11EKJ+6AXdncH587CU4z9iiQcPC1+XSiNg49UEExQsa81DS2yifiVIPD2bR4HNifrjDRrzAJg7eaX0jTD8HtSE/K2y5y+tn0fN5JuO+bdY9D++QEq4D77jdc6IbGepjFbj+6+yZHZbJJMztExHvdshnLQNa79BC/ASkHtDdOv51sx9lQDwr9e9nWoA6PBfgo57I0Q1QiKxxUgJAEjm6nkp44bJgABuWXfCEn9JhSalU+YoMLDBlsam5l5gVhcOUaoz3UUNOg1uRZIb1LwrXNx2
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024)(11063799003)(18002099003)(22082099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?c6Z0UI25x/KYwHHpDQKcscW++9mTMogpwKPYtPli+/S47b+sCU3la0KeoIkY?=
 =?us-ascii?Q?ZHSnyZnhgzBOFmdFKWy/PekmhkxTjMPdDTZ0iN3jmf+70T7J0ZeWxg/QXRgR?=
 =?us-ascii?Q?sWZMEyCMoHCgRxUl8q/ldYJj5Dc+JFd4v8YvSYjvoyUc5ABknydfJwLKP0G8?=
 =?us-ascii?Q?YxzuNajkaC09QVGDmr9AmEsrS/b+V702s2R89z0uhM0u1wyeDy84OxZIDvhb?=
 =?us-ascii?Q?uI2UQIZPbHpcnfS+34DUlf/UMpZGSO4/pMNw/SOyh3hCdF8TAqUXpmerCsND?=
 =?us-ascii?Q?BE3sKODmUgkQmXIpRR5yTMCd+5SM/Jhx2no/05FnCxtvH04uKz4SUzohkFnN?=
 =?us-ascii?Q?FSLs/DFDsr6KZ5kMZMsnuN9w2FnCGcFxsmkVlIsdrpa1Rj8AWhsGccJOz75V?=
 =?us-ascii?Q?8uavpH7866v4aG9avT44foqpQ2kKloOnOQVY1lM8LQRmRTSf56UlENdfLA/T?=
 =?us-ascii?Q?KyeCf14FwvL/fLMeeim8b9/tcUg85Jx/e0eUKInjCaJVEM6fKKx/z/8+p7pp?=
 =?us-ascii?Q?ezJBIY+NKY0h9s5tAxXdg8uBtI7rMaPstNd1FD+ZvLTi/aJom6G8a0rT3mX9?=
 =?us-ascii?Q?NS1SCOb7ADSYxjJIt9tD6kxNO5Ga+OWINUBvhBbOL8L7DkfvbnD0TvwB9cQf?=
 =?us-ascii?Q?JETGOIkODYk3I0dK7v/diXQBmN0rVd5RirHt9AWnILZvv/Ei25f02zQ5X4Gr?=
 =?us-ascii?Q?vAX6MWeQfgrZHCT6IXZP2U1vXg6ZoOhjxKJoVHBX3sgwvZDBQ/FHVyGnJXs2?=
 =?us-ascii?Q?8GbsHU2lOg577/dw7RRZ5VujlFO9pIffymCQwdYFikglieDl4p862jxEXyTs?=
 =?us-ascii?Q?ARdAeb53XobdwDc8t8E1uxg7MlnuMAd/9qd/oLkgDsl2m0VYsqBZig6CGmBO?=
 =?us-ascii?Q?wmKn6+9ZG3JKkmRxi+FL12jO52YN708Gdjp2FCU5QbP1sViP7UQOVA/a8fLN?=
 =?us-ascii?Q?MAvnqOs9+51NZkUhMxJW2JVJx6AK1nJmYrkJ0Gonx9NKb0Yqj5kV65GEYE2g?=
 =?us-ascii?Q?t/asZKoPymLncLP/xh5lN2tFFNKFtUiXxk63/O3NuRVj6fj5Mwd0akJgV7yR?=
 =?us-ascii?Q?ybnMo67Z3ErVra4MZ67ZXGbr/XTnJKDEZpVqO9oo7NpXwiqELuaxC/dIMwba?=
 =?us-ascii?Q?rQsUDQLCh8IkZtxCyfosm92CMjVt5+yW12Og/D9BL0cQvxcyg2oxcnSJM8Ul?=
 =?us-ascii?Q?OwGVketYtkt2cet9MkqdvnYJWhRBwzlaOo4itrIyXae9Z6//syvt8/1/+Dzs?=
 =?us-ascii?Q?sNajzv2VvKF0lv/yMZa7zXM78Mf4RqJCiq0TV++ivGI3IOIrW2z0ae/WDMPq?=
 =?us-ascii?Q?gAm1eOF4nlqJjf1UglbFvlstTwDjcvfTOWBYEffVlLd7lNMt7ONuSAf7qKkU?=
 =?us-ascii?Q?pLa45hNhepQ9z34OR1WudhpGpK3G4CQXTf8WBzVSSZAF2vzeNTwEGHkG0XD3?=
 =?us-ascii?Q?5ME2xXPwCTE4/VJjzUcL8lK58cTwGv6TYePK0kKMyf/36rydEY8RadIH7u8S?=
 =?us-ascii?Q?u2DEXY8l8D0NbkCcYOxSpgZH35VITrHP2uAn6HEalGN2eXdPZuoF/5D7Yk2J?=
 =?us-ascii?Q?VkYj2rDwA+8w/b6C2iCOJ0X++0HGK846SfL54Wnz3EoNcpWME3oP9vC2Kqg1?=
 =?us-ascii?Q?mQIQ38MZGDoBvMRRAnmh6FnQnAHbmS8nHpgG4VjotBsa1D1mUGpTZk3cOwCD?=
 =?us-ascii?Q?ECTGw7b5GXg2fhBhEbsCuE7poWFoh0TA85NrJIahyR0iWXUD?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 78812ac6-5ef6-446e-9d32-08deb41be64c
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 May 2026 13:55:05.5174
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fusGN/jhktgOa5oLAyw1tO4TQPgpjQBPDYhLoRvRiMquUDKuBNoJdhqrnCpDAROi
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB6322
X-Stat-Signature: g7teucrudapm4cd8geai9jbjxjr4168x
X-Rspam-User: 
X-Rspamd-Queue-Id: 586AB140009
X-Rspamd-Server: rspam07
X-HE-Tag: 1779026150-207892
X-HE-Meta: U2FsdGVkX18GMpx+KnMxpHKtSAbBMvHu9WCBZRVDIMlARD9sVSaL2DmaBakA6bWRTCNkDLH6xLoJWmYhFjniKd+3eT3XosipbfKFYoRXQtSjbDDYn3/irur4la2CGEKMmZix5aXIOEd28y1bitaml6wfQmMT6viXvFs962QvXZEpRBaS9yK/Mh4ExSFjCNmkh2qn63M8yoJqqeHrx/yyNCBWVJkmmMlVTig5fVeYhPDp3BbhbKJ1vGvCKaDUBmqR1ocSmxNy5xRsxR+Pi06r6w27JObg2yYv7sDSUC2OIEa/OvpIl6B2IgxchiIr0JVV0egw3ttyJ3iEZIkmoFxZx0eOBCyCaSG3Sx6bC3thz1JewUZEPwEGkA/BRS9LjfAhxSG6m92XkgmGxZ+mqr3V/GPE+85oNwADaHgZ+DHKMVOl3Id7naKLMqOfuHEOOJ+2FT4iw6zH2viJIWJbYcNM9yGt7pjmABXUusCTTMTAlMQO2T9eb1bf6A7kGJXRjcW+JFz+H7bTHv/JUk4uuc9IGkyfQoAXhhAkL3qEttozJgg2y5OBhBox0YqkpQ9b8oaYF3BlX6lKXBIj5JWMkmSfS2u5BeTvCmlVXeNQDxCwKOgNQyuSewWqqoD8t8zPM1dBG+qAY3tCB0wa/1V9qV1imQ+YwKR8ZTBR/ZcV7A1G9YU3tquXGwnGOOiupJtWzRoUPiGiugjuBEiq8ymGerK6DPVoFy8z5Buec1ccYc1WR2UPx+tI6+42H266QuHdIWs/K0cwgFVJwLcacUyw2oL7Ay0ZSPnEViiddFxPi+ZiZu/hT/vKGsSlhHUqlemcFoSHqsdP9DJ61NK3axTclQSVWb8lnI42TG8kOCAdsRIwIbtfFUwAra5yu5kAOYDPYKrOGMsy4IJsUy+EDTct+3T26zplETtjA+8Y+j8uKPCe97wyVfWqDQutNqx+5hE6Aj2F6kg6RrQgxgcl3UhWr8m
 Z4uqvNep
 4+0JMATE6dy4Has7WZfPKk/dHeGlcvQ0arso/gJ+aM4gcXdhy1Bi6Y4jXK6pS5VJ7kQ+c212OzUkvNQIK/LAmTS4yMKBvgVQX3tCpjAR5or+ZDw13TUGQG+bEsSnDk9ESYnKPKw2f6li3lCIsr9PVAtKTqpEscGcxi9/7D0xyZneibFybD4b//20d85jzvQS8FJYvW0wwmHKHZdotWgWfw1R1yL5YX2XAlhtpAppMvMB4SpzmSRrMFcSqMGKb0o3k9VXYouxi4YTziZkmFwO8GLHoaqCximzHDCvNNHMDivYQCGBxYGCd9N6DeZnwZ7IthztOdzbHsn3uxoDzSFmvJvx53cKC6+HoSY4dGZMTn3KG6Iu6mUtAXeG+v5DJAySdcj8cSFf+IYBSs+BbvTGnaSACIDPZZXtnAkU4OkohduID13k9b4+obosExK5feoJsVVvGOfpmqOhMW96/lB8h2qvvNN9Bd0kdn1OwqQzqr+cqOWSJblKEDZUQiYgmxWEJAw3oCSDJ+VSAYjFcQHKeCz6AvVw4o2xM7aICzfEYCLxJOudMPPqOj7jK0oMI85NMMbfpGSb7XuSjXqfdI3m+Vzbv86AxQrPlf6kxOZ8lKXIaoCT8ZZ2F/BzlPkRMZHU7zkudGTNmsGczLs4u5oRsu8lVlR1oLnrCqS0uI/2EM3w+cKiC+a2y8NbPXs7pecqMt9tlcqA9Qa6Ue89N4+1Qf509dD7TU+tRIazeuyQHl/NfCYLAwAK31kNzKuyxNaavfEnYPa53i5IwnUeREy+eXDHJZA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

They are used by READ_ONLY_THP_FOR_FS to handle writes to FSes without
large folio support, so that read-only THPs created in these FSes are not
seen by the FSes when the underlying fd becomes writable.  Now read-only
PMD THPs only appear in a FS with large folio support and the supported
orders include PMD_ORDER.

READ_ONLY_THP_FOR_FS was using mapping->nr_thps, inode->i_writecount, and
smp_mb() to prevent writes to a read-only THP and collapsing writable
folios into a THP.  In collapse_file(), mapping->nr_thps is increased,
then smp_mb(), and if inode->i_writecount > 0, collapse is stopped, while
do_dentry_open() first increases inode->i_writecount, then a full memory
fence, and if mapping->nr_thps > 0, all read-only THPs are truncated.

Now this mechanism can be removed along with READ_ONLY_THP_FOR_FS code,
since a dirty folio check has been added after try_to_unmap() in
collapse_file() to prevent dirty folios from being collapsed as clean.

Signed-off-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Reviewed-by: Lance Yang <lance.yang@linux.dev>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Barry Song <baohua@kernel.org>
Cc: Chris Mason <clm@fb.com>
Cc: Christian Brauner <brauner@kernel.org>
Cc: David Sterba <dsterba@suse.com>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Liam Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Nico Pache <npache@redhat.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Song Liu <songliubraving@fb.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
---
 fs/open.c               | 27 ---------------------------
 include/linux/pagemap.h | 29 -----------------------------
 mm/filemap.c            |  1 -
 mm/huge_memory.c        |  1 -
 mm/khugepaged.c         | 28 ----------------------------
 5 files changed, 86 deletions(-)

diff --git a/fs/open.c b/fs/open.c
index 681d405bc61eb..c321b80027f13 100644
--- a/fs/open.c
+++ b/fs/open.c
@@ -968,33 +968,6 @@ static int do_dentry_open(struct file *f,
 	if ((f->f_flags & O_DIRECT) && !(f->f_mode & FMODE_CAN_ODIRECT))
 		return -EINVAL;
 
-	/*
-	 * XXX: Huge page cache doesn't support writing yet. Drop all page
-	 * cache for this file before processing writes.
-	 */
-	if (f->f_mode & FMODE_WRITE) {
-		/*
-		 * Depends on full fence from get_write_access() to synchronize
-		 * against collapse_file() regarding i_writecount and nr_thps
-		 * updates. Ensures subsequent insertion of THPs into the page
-		 * cache will fail.
-		 */
-		if (filemap_nr_thps(inode->i_mapping)) {
-			struct address_space *mapping = inode->i_mapping;
-
-			filemap_invalidate_lock(inode->i_mapping);
-			/*
-			 * unmap_mapping_range just need to be called once
-			 * here, because the private pages is not need to be
-			 * unmapped mapping (e.g. data segment of dynamic
-			 * shared libraries here).
-			 */
-			unmap_mapping_range(mapping, 0, 0, 0);
-			truncate_inode_pages(mapping, 0);
-			filemap_invalidate_unlock(inode->i_mapping);
-		}
-	}
-
 	return 0;
 
 cleanup_all:
diff --git a/include/linux/pagemap.h b/include/linux/pagemap.h
index 308d846531d03..627771e82eb16 100644
--- a/include/linux/pagemap.h
+++ b/include/linux/pagemap.h
@@ -546,35 +546,6 @@ static inline size_t mapping_max_folio_size(const struct address_space *mapping)
 	return PAGE_SIZE << mapping_max_folio_order(mapping);
 }
 
-static inline int filemap_nr_thps(const struct address_space *mapping)
-{
-#ifdef CONFIG_READ_ONLY_THP_FOR_FS
-	return atomic_read(&mapping->nr_thps);
-#else
-	return 0;
-#endif
-}
-
-static inline void filemap_nr_thps_inc(struct address_space *mapping)
-{
-#ifdef CONFIG_READ_ONLY_THP_FOR_FS
-	if (!mapping_large_folio_support(mapping))
-		atomic_inc(&mapping->nr_thps);
-#else
-	WARN_ON_ONCE(mapping_large_folio_support(mapping) == 0);
-#endif
-}
-
-static inline void filemap_nr_thps_dec(struct address_space *mapping)
-{
-#ifdef CONFIG_READ_ONLY_THP_FOR_FS
-	if (!mapping_large_folio_support(mapping))
-		atomic_dec(&mapping->nr_thps);
-#else
-	WARN_ON_ONCE(mapping_large_folio_support(mapping) == 0);
-#endif
-}
-
 struct address_space *folio_mapping(const struct folio *folio);
 
 /**
diff --git a/mm/filemap.c b/mm/filemap.c
index ab34cab2416a4..9a5e23fa6a238 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -189,7 +189,6 @@ static void filemap_unaccount_folio(struct address_space *mapping,
 			lruvec_stat_mod_folio(folio, NR_SHMEM_THPS, -nr);
 	} else if (folio_test_pmd_mappable(folio)) {
 		lruvec_stat_mod_folio(folio, NR_FILE_THPS, -nr);
-		filemap_nr_thps_dec(mapping);
 	}
 	if (test_bit(AS_KERNEL_FILE, &folio->mapping->flags))
 		mod_node_page_state(folio_pgdat(folio),
diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index ccd623b9501b5..ed49e5d40e8f8 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -3951,7 +3951,6 @@ static int __folio_freeze_and_split_unmapped(struct folio *folio, unsigned int n
 				} else {
 					lruvec_stat_mod_folio(folio,
 							NR_FILE_THPS, -nr);
-					filemap_nr_thps_dec(mapping);
 				}
 			}
 		}
diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index edb5c3656c168..c743ec41a7b8b 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -2477,21 +2477,6 @@ static enum scan_result collapse_file(struct mm_struct *mm, unsigned long addr,
 		goto xa_unlocked;
 	}
 
-	if (!is_shmem) {
-		filemap_nr_thps_inc(mapping);
-		/*
-		 * Paired with the fence in do_dentry_open() -> get_write_access()
-		 * to ensure i_writecount is up to date and the update to nr_thps
-		 * is visible. Ensures the page cache will be truncated if the
-		 * file is opened writable.
-		 */
-		smp_mb();
-		if (inode_is_open_for_write(mapping->host)) {
-			result = SCAN_FAIL;
-			filemap_nr_thps_dec(mapping);
-		}
-	}
-
 xa_locked:
 	xas_unlock_irq(&xas);
 xa_unlocked:
@@ -2669,19 +2654,6 @@ static enum scan_result collapse_file(struct mm_struct *mm, unsigned long addr,
 		folio_putback_lru(folio);
 		folio_put(folio);
 	}
-	/*
-	 * Undo the updates of filemap_nr_thps_inc for non-SHMEM
-	 * file only. This undo is not needed unless failure is
-	 * due to SCAN_COPY_MC.
-	 */
-	if (!is_shmem && result == SCAN_COPY_MC) {
-		filemap_nr_thps_dec(mapping);
-		/*
-		 * Paired with the fence in do_dentry_open() -> get_write_access()
-		 * to ensure the update to nr_thps is visible.
-		 */
-		smp_mb();
-	}
 
 	new_folio->mapping = NULL;
 
-- 
2.53.0


