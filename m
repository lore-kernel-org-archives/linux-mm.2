Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EF37DC53200
	for <linux-mm@archiver.kernel.org>; Wed, 29 Jul 2026 15:33:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D86106B012E; Wed, 29 Jul 2026 11:33:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D37286B014C; Wed, 29 Jul 2026 11:33:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BDE326B014F; Wed, 29 Jul 2026 11:33:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8D4C06B012E
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 11:33:04 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 1AFC9806E8
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 15:33:04 +0000 (UTC)
X-FDA: 85042207488.11.C496EA4
Received: from SN4PR0501CU005.outbound.protection.outlook.com (mail-southcentralusazon11011039.outbound.protection.outlook.com [40.93.194.39])
	by imf31.hostedemail.com (Postfix) with ESMTP id 2F4F920008
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 15:33:01 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=pIUB6Irj;
	spf=pass (imf31.hostedemail.com: domain of ziy@nvidia.com designates 40.93.194.39 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785339181;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yn9fRGMJ1ji1OH3rw/UB05jTy788HhJay77K0eaCVAw=;
	b=tKIjvEF3GctkI7Jpb8/Ofn5oGIRm+qhW3uqseqKK0UWEQYvAODm6GLSWFLwNaPUUhWBXAx
	sD0LWiQWWwkiOghr/Hg/+StYkpCS0SslTixWXaDOolXsulcEXzYxNJXgkrEJcyG10oSa5B
	vMaVNTaDcSxqDC+InNKXFRcGM97Za/U=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1785339181;
	b=jdmVTxgYJCC4A7I1EDiWt1qpvEo7sUn07zI3W6k87OervRhZWZkBVaZES4/n8I/k+v6ePg
	L769WpL5njxZQvwLgo2/076MoBEwOC852LoFmLZH4He9gbcfAeKhgOP909i4GfnVxsSp/6
	gbkzoYwbgL1QMteFgQyhaW50A34nJ90=
ARC-Authentication-Results: i=2;
	imf31.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=pIUB6Irj;
	spf=pass (imf31.hostedemail.com: domain of ziy@nvidia.com designates 40.93.194.39 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ONqPUOdZhoO0anHSxO7BE8421fdvfqEPfuSVeG8W989GZgZJKEoI9Wctv3arh69sQSveyoDn0rRrGT3cHo3SBJXjzjgXmH3CK/dPU2j1jfgeJyhCE1CJxiuCP/y9835SOihXTtitTmjc3pUpdxn6LKCUzHQiSvNmMbM4mPaXcgBQbkr56vWu5fxbM/jl+im4uYuib3tLm/X6P1I8wKoUG1uoxwfOz2ede/7MOnSVgUrLKh1TVFtzduTEC4XCl/i0Q1Vd0wX+nhCzkbSmQItdqsFXI48VAASFadC8h6TZdCblCEy+GScHQqZyRf1tIJoB1e69966K864l+gtiD7nYew==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yn9fRGMJ1ji1OH3rw/UB05jTy788HhJay77K0eaCVAw=;
 b=XsNcjv8ZBv3JEDC002MujMWPkBXaJaCrIu6eUJmVDmREvw6p5iTEWFMpDRCqQ2i6FLVAFuAfezrsIhVpBCNjIwPi429RiiIiXWwEJ6qhnUKO4MBE1iprgRmI/YSq+vGQ5c5Q0TP8dljOUmvmVaLc5lBNuIGVK1d09uUJWkJ50nG1eg22zfORvR3W/pMeSlW9tdkYy0Uutifo8FLQ0Kc5WRr+rh4I0PfqI+Xm3fvqFMX+m4R6BuBnZbwcvldFuDxW3gwl2keDvmHjMYLCggpnZ5wpaM8Di0DHEfKp5Y2AvAoivWIRk+lA5xc3hkSaR7omRmXV+ixtdVCzji4ts1JAaA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yn9fRGMJ1ji1OH3rw/UB05jTy788HhJay77K0eaCVAw=;
 b=pIUB6IrjPPFsyoQoNO3heDON/lyy4BSHJya6wkBMTGW7eV7RxhtmzTdV9pc8gXOj5XpTDyRwyCfSkFkXFL+i8MxRUmqTQA413TE6wu4M0o02D26MRvP2GtiCXkcOf1iNMxNhJdLraly/fFUd7Mkk17NVQ8h/dpRMg1Rae/X3mv+2377bCbtxw2hjHyfJu7H0wgbbpn+RxzPY6SNsHwCaVR/vtBLFKEiav1szU7E4JdtsAeQH5sGbfK6OIcRQJ8pvF0CC3DEzYskGLQ1paiMpQgRPKRsFt+2jtBzBxi1ssm9jiffsK5XW06yT36RSfm5eOGtwu2tJyxrTasaO2+KP9Q==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by PH7PR12MB6834.namprd12.prod.outlook.com (2603:10b6:510:1b4::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.270.12; Wed, 29 Jul
 2026 15:32:54 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%5]) with mapi id 15.21.0270.012; Wed, 29 Jul 2026
 15:32:53 +0000
From: Zi Yan <ziy@nvidia.com>
To: Brendan Jackman <jackmanb@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, linux-mm@kvack.org,
 Brendan Jackman <brendan.jackman@linux.dev>,
 Johannes Weiner <hannes@cmpxchg.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] MAINTAINERS: update address for Brendan Jackman
Date: Wed, 29 Jul 2026 11:32:52 -0400
X-Mailer: MailMate (3.0r7024)
Message-ID: <41511F8F-1BDE-4292-B6AC-D2F1D9902D7E@nvidia.com>
In-Reply-To: <20260729-email-change-v1-1-666ae7c2b7fc@google.com>
References: <20260729-email-change-v1-1-666ae7c2b7fc@google.com>
Content-Type: text/plain
X-MS-Reactions: disallow
X-ClientProxiedBy: MN0P222CA0004.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:208:531::11) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|PH7PR12MB6834:EE_
X-MS-Office365-Filtering-Correlation-Id: 22437ce7-944f-43d8-4998-08deed86a840
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|23010399003|366016|1800799024|56012099006|10067099003|11063799006|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	PLplBhd0vHTbXPMN8vb7zK3eNnMPBzq5h1lPx1a8nCTi9+taZsWh+7dkptDJKLyMLh9UvD5xbkvK9OPI9y+LHUiBaUPuSP1la+F3z/KtgFiF6itGcP5a0bI6S8VAvMt4W8vK1BLj6u3YCNI/dzLjRcwPDggZGULSfU7/KBxXf93VcN/xyzQhF3yCzsZc6hAy3OroB4p7V6fB560nQhcawovniGmmn71sMSlumPhsdZATeCoB7MJIf0EhUeKUz0zh2zQVIInWQfqDOamWtBVgtegFPwgpfzV+WLfXvMh0LP52T/CZVFPMr4KwENMLxud4Bb2rtskptVkjggK3bn0MDYRZw+7AB3Yab6hEcJc30MYcq/si+fMKJIH9rRs/+1ge1L7Nn8JT09L3iKR5ML7NNuGnN3JiK/OfqrK+Mo66L4DtfLqOR579mJUuybYzqdAKakM8rOyBKYyg+0dVxPvY2VKHx/LyA2pH2yQRhISDbf6wiTeQIJiieK6ru6tBZ1yfWyRt+9BObh9+x80RSvo1NOmHF2ZmBvXbwGLhJsxnCA+2mHeCuOZhsYGb9zokf1ryNyK1dO4A1pLBNfOSAsJvmbraQDmOZbUTzt1zRRE8q/xgu5Xu/jh6Vk+nl1riaoGaJjFW8KGYIEgQrV523ynwsLe1kVpoThfBwDzhujihM9Q=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(23010399003)(366016)(1800799024)(56012099006)(10067099003)(11063799006)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Fye5BTX7qd5OauKBwPsePqpVZcp6GcnfYl6WEUcDRcJPB45b9RM4q16dyDyN?=
 =?us-ascii?Q?aUh1MxmTbAPr5DRUYSSrJ3kaWrKqY9iRgXSBTFW5WOqLnwpNrlJ1khFdzxR1?=
 =?us-ascii?Q?XbZGD/F91gWjP8xYWHueVG9TUcO4riP/Btjl0aCnyoSPp40vcC6b5KHjqHvw?=
 =?us-ascii?Q?eaNCwWc5s7xFcdT8rQC9hwOywoAlAndJEv4f4QnxaNvdLxeyswVJaiYWmQK+?=
 =?us-ascii?Q?ZcuKO8hHHuV9c85fNOWv1Lf5f316KpUfRIpyfq0yTlb6WlMQ8iMA62EmOCei?=
 =?us-ascii?Q?9tW7KfdZ4ID0z6kgNP2tIYIQsqEsxFXENYXBs3FurohtY3tO5eB3o+Y9Dd5F?=
 =?us-ascii?Q?vLSMmXDUPeFKHqyWV6EBA5ZR52VSdvkZvk0QR2+h79ui2ervcG8qbkaLhVva?=
 =?us-ascii?Q?ht3MFlKZOKpRyI+ebRHRaI/D9NrpPQ6IqE4SaAWfbciH9CDqcQhnGW8G2VRZ?=
 =?us-ascii?Q?+fTkQpw8MBWCLp7Xn4Q2/4O25e6HvIDwiae11/j+7S2yl55SZDBELz/L+FOl?=
 =?us-ascii?Q?lB8H+kyWY1HWtAGOgjB6yI4Crj49CBXQRH8yT0zu8HX5o0l5jFgKzM3YGtXb?=
 =?us-ascii?Q?gMmHG89cbYM3SjOV4vb7+UDNJVqVbrFLI0PssqQ+jmv7x3X/RVi1+/AiEbQM?=
 =?us-ascii?Q?epG/lYFKUVXgzO5bTdd0/uO2A6WTTVAsohWigUGj2Obu0fUVad0mJ4FLg6QX?=
 =?us-ascii?Q?kxzfs5ErA5ff/XRBPORJYph3+q0+pw2zeEsuwYHaOHh/T2cxTeZe8UVtoK2k?=
 =?us-ascii?Q?OWypJEyXPbShSZPpdzBWcJso14cK9OuDBuVKiixw9AapNR0vaDVq/Nwpo8CH?=
 =?us-ascii?Q?Pdtut1E6trqV1wAkMpQBjw9CYYg3jP1MexZIakSrnSXwnXDM9mrdJZzNmMKf?=
 =?us-ascii?Q?gyaXbWRj3qApfA4rjcSfRytxezKL+l+DbH428+SCawQv++8dRi/EUVESgcwC?=
 =?us-ascii?Q?v3rGplN6R2gc5+ki3J9LH31M7MXWXxQQQghVCD4tM/JgHOcRlXsFfBOE7ijU?=
 =?us-ascii?Q?gn8HTFIKsahYFkByblb3GPIlNR52VMCkShQ74QRuiMWq2ZW9/fHzbB9sAhQN?=
 =?us-ascii?Q?mXV6oTRxEhT1ugsI1PctbG2cMZJ80sU+DidKto9OseGn/VEm5XDEsOfGrc0W?=
 =?us-ascii?Q?3vGRBbvudzNUHDDmbTa+XMfB7jRtfkQ8PRfly+VrsIcn/seuo8i0VKfLSyjR?=
 =?us-ascii?Q?jknKZJNVJ4MnjzQtQsBaY/LDLjmvsW2C4BAbtHRRaxZ+mDaDhlUTfaS26Ube?=
 =?us-ascii?Q?BnZytdOlFwrOGdjyfyxyXqzlGJb5A1vJj3NQbWOA/GbI2HTw2IjOey2/uKb+?=
 =?us-ascii?Q?Kyngk9GamB4nB7JoOc700VSJ6L3p00Z6scMP/40AeJyMaIAXkqsVJS2u36fu?=
 =?us-ascii?Q?YPUwTGc8EmKUe8tl21umubIdzX2O6PWje/kwnkU2UvX4XXjLP1pvman9Ji1W?=
 =?us-ascii?Q?R0Zwpa6OQnWsjBlI8fI1MQ9GAWcVi6VA8do4VW0gIc0HTdakweKOT0EWZ8bx?=
 =?us-ascii?Q?1tkARUxCu1/66ODXEtbAkxkwVIBhnlu4IWreazWx5tZLoW0DQTk5rxYWXy3X?=
 =?us-ascii?Q?T+1LqfMZv642ZQSqmXCKX/bPtXhEIG211IIDBuoiZdUZtMu1CeHK2LUjTjcJ?=
 =?us-ascii?Q?Ca9qfmDn55B4hZQ66lfOighPEaZriw6bmTEGH8+liizrY4Rz0aFsDwmHdN7W?=
 =?us-ascii?Q?5A19DMxKXNHTzea6E35357MDWPkWfQ/gYEaX2wnogHzbnM0O?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 22437ce7-944f-43d8-4998-08deed86a840
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jul 2026 15:32:53.9089
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4iVxFxaFO2zrScU0D68XpbT7wmAVbhyWqpn7m3Xo5LibgpflNnIMWOjFxb4/zodS
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB6834
X-Stat-Signature: s5jwk5obcddko9hoyn988rd6o4g9pruk
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 2F4F920008
X-HE-Tag: 1785339181-520932
X-HE-Meta: U2FsdGVkX18TuPf4A/8N9zjoto2geA1iyxOoCMU8dFDFcnRhuOpLkf7r1srUrkWOT/F84pCZ8EAR6NSpniACgwa+YqAfnqx2iOaB8M9djydIailo1BAH0Duyj3NlCGLUB4x1gPw53IRtX3mB449NMdIOkOLFuf5LjK25KznuOxsDeNxLPsEc0UxK71QitvBNrJX1kFXaLLhPTDEfso1yQFtZgyaUAsbUt3STV4+QQJwYhwMs5tfrfD5R3yzw3FEn8OeGz37Z1otXhxawMmss30hpgNuJOAMabmmW5IPDKZusTQ1RCnIp/szXz70VSClVHGxBHdcIXs1jJMsMDqGKZPweG9ZDZMcazqntWHq/nshKpi+FqQvqqfJbbm34Rab6cGC+AjqGWavvtEYSzqhYX59sWmAMlyH/zYWK/QJeoIGqQLqI6qwESix3X8/tOzV12I5PZad8iwFZX8AMy7MnCJDVoUpwj1NMi3C9zyBOE4NSFuy7epHRyiULj8YJbbdR+8/llyh0J2Otx4NEgspvOrhOAqcn2TyNoMvBp4fSVqdbS6w4YMtp/dHmfBD94In0AaFhlIIhJZiW2C3WQeRTvq+oaU6/KUJN9NjeJ53M6jhDGM/PHqjL9JGET8MLmDPYAEGHovEbhXuJZ105qRoE0p4tVpetX+PpNEu9IaWpc/Bwiej+0RdrmOrIZKnZUPGsRmkqv1nuSj5cnpCYdLN+4UQqX3vRUimqBegJcSX3Coc6qHW7Dr5dtt2Rw7GCdqe91NA08CfzjiFQdmnKdH6+yghvWYGLauB57d7qQb8VksQhH8TCBKjH6U6RsyrA1UzKmB6GudueTEnchkGHDYaXYkwr+GTKIcRAL0GElaNrbyO5lTMZQURcdDyznv1rQgGvGEqpA3fYEYNu/gSj6xE0M2cy5RL3ERtRJrSCwldi8PdnQbgTTNzVf6FD+LQ6/JLvOJYb1r8pjOlOtAa8wRQ
 5xawLtyH
 LXyt4u9SYnNE5GEeegVuoQe0ThuGblARx9qN5d9iz/7NYEbP8UL74mKbrm5B3UFYR1S4RamTH83XRJlyySXRf8lRHK+BhB8j7eEJZoMCngxQYoPvpKS1msqLQZNe9tAs8YNG8t/CU+d0liMGK5loKe80iDvaZzngV1/QJaR8QvgrLm0Hz8Yy3Me9GNsbEgfnlJ+0zefcdhyW4hGJxRUQh+KKZha2dfzmlbRLfAe0e6obgJ1zBkwkydWvS42Prr+0dFCvLObOzaFGLnVsUA9baNzd/IqWkBZ7LJCsS/HLuhff1Y2mqfph9VKEC6XNrpnxOogdGzXO5K5QPrqFKGck/8E7OW7atf4wrmc2O5HRVYnE/fPsM8xLxZIjD1b2dm/gZ7kcF8U9MOJriIAT/HC8MB1elji+8YUFfJs4mbkiafDvacDn5C3XQJczjVXny9YMMkjziCbOvGddzDvG7MV4tJ6bBSCkmZmPue5tL7yR5SmMtc2LNa84R5pL8B1UUEHOJmPXXK3yxh7Z0jxieNR7JaaHIVdQG/XoSvAKNym06HN/JVTn+VfQ7xGcIpHj153bZJgBVhn331iUbo7COCTeCIIw5unp8GsP5dgwEDonjKQrWY/k9aB7VQQ+hCOjfrpUkX1+YLXTHTsX/FpeEfR4D897BH8OfO7dPHwPR8wtmueTk8KLXgWyC756oDuBdyPON71gKLZz5W9O3eH/034OnQEp9A9/YaT9Wni69LClIkw4Vpbp4Sg55kW8XzrL85KVl3dlpuArMIi5/s7oaNtymCt1Q7AvRwSw/NL0MiiYvxhMNjlFUfeijOGnePG+xgVUD3qvIc1YWVShb4uZm10K5hjAKeuTpLy6STnylUbtw2EuPBAJoSwfK/DBt4CgaLEEnevgQL+h20q1ylRyze4GAcXF8QgoCRfqijNJU1r4how0viBj37sLZXDFHXXYlg7b/c/fnJHdcpIAbtUY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 29 Jul 2026, at 8:01, Brendan Jackman wrote:

> From: Brendan Jackman <brendan.jackman@linux.dev>
>
> Switch my entry in MAINTAINERS and .mailmap to my @linux.dev email address
>
> Signed-off-by: Brendan Jackman <jackmanb@google.com>
> Signed-off-by: Brendan Jackman <brendan.jackman@linux.dev>
> ---
> I am leaving Google. Luckily I've mostly de-Googled most of my Linux
> workflow already, thank you Migadu <3
> ---
>  .mailmap    | 1 +
>  MAINTAINERS | 2 +-
>  2 files changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/.mailmap b/.mailmap
> index ca6dc25758026..7324e1af59c2f 100644
> --- a/.mailmap
> +++ b/.mailmap
> @@ -170,6 +170,7 @@ Boris Brezillon <bbrezillon@kernel.org> <b.brezillon@overkiz.com>
>  Boris Brezillon <bbrezillon@kernel.org> <boris.brezillon@bootlin.com>
>  Boris Brezillon <bbrezillon@kernel.org> <boris.brezillon@free-electrons.com>
>  Brendan Higgins <brendan.higgins@linux.dev> <brendanhiggins@google.com>
> +Brendan Jackman <brendan.jackman@linux.dev> <jackmanb@google.com>
>  Brian Avery <b.avery@hp.com>
>  Brian Cain <bcain@kernel.org> <brian.cain@oss.qualcomm.com>
>  Brian Cain <bcain@kernel.org> <bcain@quicinc.com>
> diff --git a/MAINTAINERS b/MAINTAINERS
> index a22b942616cb8..2657cbf6df903 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -17162,7 +17162,7 @@ M:	Andrew Morton <akpm@linux-foundation.org>
>  M:	Vlastimil Babka <vbabka@kernel.org>
>  R:	Suren Baghdasaryan <surenb@google.com>
>  R:	Michal Hocko <mhocko@suse.com>
> -R:	Brendan Jackman <jackmanb@google.com>
> +R:	Brendan Jackman <brendan.jackman@linux.dev>
>  R:	Johannes Weiner <hannes@cmpxchg.org>
>  R:	Zi Yan <ziy@nvidia.com>
>  L:	linux-mm@kvack.org
>
Acked-by: Zi Yan <ziy@nvidia.com>

Best Regards,
Yan, Zi

