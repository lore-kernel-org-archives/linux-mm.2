Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3ACE5109C057
	for <linux-mm@archiver.kernel.org>; Wed, 25 Mar 2026 19:53:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 63DCE6B0088; Wed, 25 Mar 2026 15:53:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5EF406B0089; Wed, 25 Mar 2026 15:53:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4DDC46B008A; Wed, 25 Mar 2026 15:53:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 3C69D6B0088
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 15:53:00 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 7D15B160AF6
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 19:52:59 +0000 (UTC)
X-FDA: 84585633678.21.CBC672A
Received: from CH5PR02CU005.outbound.protection.outlook.com (mail-northcentralusazon11012065.outbound.protection.outlook.com [40.107.200.65])
	by imf03.hostedemail.com (Postfix) with ESMTP id 9B6252000B
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 19:52:56 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=RVHDOpOG;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf03.hostedemail.com: domain of ziy@nvidia.com designates 40.107.200.65 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774468376;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0GITReRNvgfUDVbXyCb0+4QwXZLrQUEYn/GmnoHQVno=;
	b=2XMM8NimDV/hDST4jXRhxb18ui05cnBYeadJcZ7D6T1LTyIvLDnX4rWeq3mRvJtKpis8I/
	3fJ2YjgJtu4mZEI0Jmun3O7R/UyhQrsQkHAF77cwPYQkYhlWPX/+lDa3aW7ZH8sCw3VCLU
	KDEpo8541C5wEy1ksr06NyekwUzWBxM=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1774468376; a=rsa-sha256;
	cv=pass;
	b=CgjuBxZZ+WmQK8A6VoBlBean1cXUf9KE0pDw3FPMAQHvy57DcX/yFh4og1zSppBEMO4iwu
	nqoTIKAqI1U7wDbKMIDO1ATi++BLJsGX5WXA4RkkwbWGjlpY5mtGRv0DhwALGCFFDyHf5h
	+JIKeNDSRBt3OzmlxjuMY9UHHbU5A8A=
ARC-Authentication-Results: i=2;
	imf03.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=RVHDOpOG;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf03.hostedemail.com: domain of ziy@nvidia.com designates 40.107.200.65 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Z0iQHdqwmvooDcYFnsw4z5pm6dK1Qg3ADcneE1FwLQeJc8g+PjAraEF7my96gXlCcI8RNS+pMWP6Vc542o26DO3nPlB+fdgHfffNFJLG4uvw2jrqT3Evs+XmbqcMdmECriNjzubWB3ANeYYAfD1tOKVv0uLZ24E0ryRZ2ODkvueLdNuK0xWIf2MudJ4Zlnqz6CK9s33lEi4GQx5/NtNqkIMDIeUA1GU7ySn0RTBUpD73GWY+L/6L/YYPfpiU/pOlfYbboP53fDYkfxtHeHKQpNZQJaj1OURvqudWLzg+nJfgNE+54lfMLnWTiyZV3cUgSP9ei6fGWzafqR/L6PIcOw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0GITReRNvgfUDVbXyCb0+4QwXZLrQUEYn/GmnoHQVno=;
 b=kY8PiggbHLMRwf90be2e0sQeqUYDZCmysHKAAXAEyfpqvuJchMzX3xD6MXZAuzfPDH5hwHl/RL7jhbzboQNTA3ji1IdQeDq/BVtCJrD+dMCv2Q9f16LqzFN1RT+nBo3SJASgotIWR4kQeAPsymnevCRWZ6gVWDl7aNyAUZy2j6i1OJrgGPWlRU5PYzCPV9uHYZ64MfkkGlYx3TNS3HrsXtBPKkjNGJAu4sTrtvHwAURal/GdrEsbAa6UuRjYW4LMaIgNUv2NGAmrj6ZpYw6oGV+rz4X2zWKQg5CC/MM6XHQYFKprnhezAItYhLYWb6hLA8Twa5vyRizXROkAB5bj/A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0GITReRNvgfUDVbXyCb0+4QwXZLrQUEYn/GmnoHQVno=;
 b=RVHDOpOGV651LqF11TZlMf9APRMgmIoESD6eDB347KSLD03DS0GxouzCDKOwSmwfBuO9WZdEZgUxRqhpoCOoILWnT0ExQDwmqoDfXx1tiS+j6qE4D8Dglrn8BC1zwiMDY9ainuScP+UBZA6FTR63Ws5G2avumkWdhpl+Ng64gWFXEhr44vj5/VCufG5AAu/DTjLFegaAEEjYiwPmPX3N2yZbzS0oQSRvgYlz9rKWaWvdtXjh5n0PixLNPM93kFI+Kv6/MxGS1v9b4hk3WTSoUr/YPBfvmH1Aga3oCRKyAsUzaXWyz128LiETAwjmHi+bxc1kTROt2AOujrFGsDSOyA==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 PH0PR12MB8174.namprd12.prod.outlook.com (2603:10b6:510:298::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9745.20; Wed, 25 Mar 2026 19:52:52 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2%4]) with mapi id 15.20.9745.007; Wed, 25 Mar 2026
 19:52:52 +0000
From: Zi Yan <ziy@nvidia.com>
To: Muhammad Usama Anjum <usama.anjum@arm.com>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Brendan Jackman <jackmanb@google.com>, Johannes Weiner <hannes@cmpxchg.org>,
 Uladzislau Rezki <urezki@gmail.com>, Nick Terrell <terrelln@fb.com>,
 David Sterba <dsterba@suse.com>, Vishal Moola <vishal.moola@gmail.com>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, bpf@vger.kernel.org,
 Ryan.Roberts@arm.com, david.hildenbrand@arm.com
Subject: Re: [PATCH v3 3/3] mm/page_alloc: Optimize
 __free_contig_frozen_range()
Date: Wed, 25 Mar 2026 15:52:46 -0400
X-Mailer: MailMate (2.0r6290)
Message-ID: <6CEABD7E-5E01-4ACA-BA22-2AE5B90ABFA3@nvidia.com>
In-Reply-To: <9cf2198b-71f2-4653-8b6e-62e635757a4b@arm.com>
References: <20260324133538.497616-1-usama.anjum@arm.com>
 <20260324133538.497616-4-usama.anjum@arm.com>
 <309C0716-A53B-422D-ABDE-E865DE0473BB@nvidia.com>
 <4ca68533-9abf-4d54-ba15-5ab9bc3ed0dc@kernel.org>
 <9cf2198b-71f2-4653-8b6e-62e635757a4b@arm.com>
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: SJ0PR03CA0074.namprd03.prod.outlook.com
 (2603:10b6:a03:331::19) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|PH0PR12MB8174:EE_
X-MS-Office365-Filtering-Correlation-Id: 058af484-1a01-4e84-20fb-08de8aa81973
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|7416014|366016|22082099003|18002099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	n9N60LoquE8X1908OZqWa4leR83oN6KNr2f/XcUNi5VcYoweXByHe6p/eGGU2Kc496ZdPoVjYQHNqJRB3GfER/b8kntNLSQp9hYu1BYuefX6u/ANdyfO/9Xdtb5AiGEatrvr/IB1/f3TM60ktS7dJ6b/lE9V7Xmi9bRlyui1uqYtCxItF61Y+wNZwWxeE/G7uCJ6TeEwfjaERjTwjXTdFPqSrxj7p1upU91IG47R51DOM9ydUEs3IukK9D48jSz7yokP3HCzgGtKUGxSKlnAaWp4O637UOKw8xfcYHhifCgAS5UJSeayE8em/isQH7eH93v0eyd9hZmQrr3LJt8aZMXuh8wNvWPCm999vEWcmAJiAmat75+HzBXfwWr2PZnF9Hs4F/iLNj7Hvv5fnVbhBlcIhLkmbZM9wUCPvU3MchwAOrTTpe4A9E/GpmmWc4xthFywgTuGQNj80YhAnpag8b0DIk7Y1b7IjQeosEfPdze1/RPJ4o5DpHnN0Bk+qi5FoCU7z2dOjkDd2fMts2EVYihe7h//Q0+Z6kEJ+rHanKhLeLWr4GwYNsu0BfUy3QgXzEwPVAoSEdUIAaSqPZ4pdnhvMoMsWvRt7Kx/Lfp/yNsrHhy/tQ5ozeZOIC+TJncUBaQmNq1IyB+mj8RwSL9m6lcJDhkBRE9vx44q0vnhSw25KRHgBK1xXFAw9yFtcP4irlVfcFob2uKRVBTdLH26YjdpB9RQOgnG6cCm+6qhMsY=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016)(22082099003)(18002099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Qku4pwmOikMr8VnzMdG1nrfZoK6IY6MySbajXEFMAuTda+Rv2D1Em83fE6Mi?=
 =?us-ascii?Q?+3dSEWiGmAMle//r9WMkxEPdX6Hfe4prNTdpbJYaLLarbtJXqS8ug8Q2eVuj?=
 =?us-ascii?Q?RM0fCRTYCA1HLS3yiaLHhT3QMm6lU7vB2vMq71rf8Asio0F4Ikb8R48VAL/G?=
 =?us-ascii?Q?JXgPUmWkimRpNuaBtDpvLrBwJBK85rFywJWs33nMu8rF77Ovn7Len1tUUkKU?=
 =?us-ascii?Q?i8cUxG+vUnaTwBVG6peATwCEKVTRa+K79S69+iBdGpMow/HcdvIgl6zKf9Qt?=
 =?us-ascii?Q?NxktlUfcsVHeT9YpDSDcTlEEgbry+LEowxtr0bSx53P2AdUiooZU+fNm3HE+?=
 =?us-ascii?Q?Qe/U3xPtEIg5bYBwQbOpwx0Twk4NXnSKQ9OAkhqyhi+J9iJpZc9tJX4WjaoL?=
 =?us-ascii?Q?0jro+ptMjBzzru1abWqqhJPIRayrrBwfgh6T41k57iR5ZirKuePO4QaQsPYR?=
 =?us-ascii?Q?fRl6NAxxNqHxmTXYzMvrh2FUd7Ym2XpE5Ol7CRpH7hOJXvXpBfpIJv1GYGKR?=
 =?us-ascii?Q?p/HzFI86QGBnJFTCcRHQ12sr8/mU9YTfzyj06VCNW9EQ0aohU345RxjuiqxX?=
 =?us-ascii?Q?kC4uXtKCZ4NdQ1+ohRkTxCLSP8SDiOQsRM6C7oodHUCacKuMRvlI2QZSvMcC?=
 =?us-ascii?Q?LthFDbupm2KbD2d8l3/2Y3sQL2MMd67ORVqMEWEhQIirGPqQFKu/hjnftLay?=
 =?us-ascii?Q?uCU3eag/C+UJpukreoqDqj7dmJHomlveDspomuyminC4hBhbRbg6zuvOIX/1?=
 =?us-ascii?Q?vviB8fLnQYS+H30mhExYPycSV+vfO/51UEVVVtATZzABgC3K6ykp5mFFS/Il?=
 =?us-ascii?Q?uSSpthALseCUjSoxixCz8m59UNZQNc812bafZALUd+tv5XB6GjxU5fM1S52v?=
 =?us-ascii?Q?sr3bJaKU3F9dkfpiQ430F031+xJPJCVDVIHRkxOXBY5uF2mnP5Ral4Rg0ZCP?=
 =?us-ascii?Q?ggyHKhwuD1smSqXD5Hptc9aGys8KOufYHq6MkdSIQKqgl1o4AhvEYpvWv/Qx?=
 =?us-ascii?Q?eekpiTT7q1Gf5oRbe+Ebi6q3QBtkjX2l4mAWwDlGmoYWeWgD8QT0gOAlwUKH?=
 =?us-ascii?Q?rCD5MzJjg/l5nyK2xP+smAa+AYgH7WwpqGBL9YjulE79tpViRo9w1TlR5ZRD?=
 =?us-ascii?Q?o+Mq12qO9mDyAdQ1xY+uxrZwjn6oFpu7zI3kQk1SZ2FvUhuQKtgkoWxiRcNH?=
 =?us-ascii?Q?hs3HLgLOPokEd2wlPpsSnlbxUPsAR09h9Qq5nqGIrETKu9+5XHfmSAbJ5/0I?=
 =?us-ascii?Q?8EOwWKBQqDuo2B7TmgC3+KUj7TWQ3pQgIkKwpwTT0Oszx+Usj2LI7LVOsg/2?=
 =?us-ascii?Q?Mfzmc/aDF3DMAqqw5WcdbcFCzHxMsc4ZFagwhiHJT2RxwkGALZ1YMCFAzMTy?=
 =?us-ascii?Q?3tx/gxtym3sHxN71m33Wep8P94YnY5tIdOUJUmb/GO1CqFmsLOhm2hcGCILI?=
 =?us-ascii?Q?ahZdp7PJ+DPt1jozA9/WtA3Jj+UKxdz/gpXBrgDlKUlcsliQH3/es9FwUNFt?=
 =?us-ascii?Q?l9FnaD7ONHWrdvC2WmoHiuCkUrafi59+4ALv84mcGysJRocjXeJ+5UGvYUUE?=
 =?us-ascii?Q?ou73+J53LSqrdyD7xXcTrYh6cLU5yX153OZQkRme2HNjkpzlKZCyHj6Rtksd?=
 =?us-ascii?Q?3nyxzuutFdVcBQisAEhBvQdNLCQT/x/IRVj6tjUAHkOQdd2i82NYpzK//ZZK?=
 =?us-ascii?Q?gr/HvuCtYre05pb9T9QUhwQoDOuOVN79gByn2JnffkQMHhmxI8VQABZHvf3f?=
 =?us-ascii?Q?18AdvzcbXQ=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 058af484-1a01-4e84-20fb-08de8aa81973
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Mar 2026 19:52:52.0730
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +7zSAe0npB8HTKpOQ9GrGfkxHsVmwf0b/lXJVUKDTiaS7Cfv/UsRdzmDlcSUV1Sr
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB8174
X-Rspamd-Queue-Id: 9B6252000B
X-Stat-Signature: oekp8f3b3k58xtnpbri7j5m4j6t4yi84
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1774468376-229919
X-HE-Meta: U2FsdGVkX19/oLAZvYIO7ERSJNsSEjoUgdUyJcMVC08y7RrvjJ9QE5A9eOOaoFJcH2HxEQse73bGJJ9RszuTuAmJDBSc46Mv/r2QfySiCRFPlIjsgbReziesOUL52tvhvSiunY1v1TamwtDls7Ya67FklO6Wb1HcPLASTctQyPYJ3G87z/6q6bbFx8gG2qEDlHjEdOVgTjc+IlwCVWXJKkREObG6aWWdSXdJN9++3up0TUwfTnvvBZfWrh7Rc8aMe9jr79ivDbVMc0QnzWrCORO3DXkSWl9sS6GsrvaOxxCTgIqdt0DUAnSm3VlTbAKTJtd67U4OrImcKpIOjEHoAg2GHNcJ4NGCYtKFesVfyp3NG3snVGxodaAslPx1MLzBZEGUeMlRKuCTZc4NU3IS9ZVa0/FhzdirHfESmygjFsNDC5IzDWLCsirfQ3Jk+hyZxQqeIjBrAIyKA+fj6+9GRzalFSMznPyxBPWwJElDU6iVThRb1qbh4kR9Zetv/lJXmWvG9iCCPXu4sPXtMZcWFsqWq8ux024ttZNXTX6dzYFNEanMBuVqr2+F3C31usEy3dYbDApSUGQdVjI6gLyRDJDenx3Ae+NRexlCGdrvifT68HqcFivVwGEUhrC9C9vmcJWGF3gzawQyrnw/uATElZvovdyl9J+FvAPRqdT3sd3HYS3o6Am/Y5es8x3uwlR5PXQMx49KgcNH2RSSG+hV5WBfwvzsaHccKh6zuR+L6l6Hvs+0X+RHgd0UDG3NY1lpDvANWWl6ZM85DEORCCBkMyDEvXBiGAZdwxG+oQIHFmE+aqkCChfAbVqQZtXVMIt5lr7VqDejrXO/NIDXXHNwrAZNxjvJYVYCu5RAxGsoVCfk0QYNomU8iTzyYdyM+/v0ERsow2oTwRHC43Eq3O1XxmaJA7mjdAcHT5Vf9Oj2N7IZAobRCkemp6zDckUxY09SmbkAbUqv8IeHmmw8H03
 4V53Jaay
 MMh1IqyXSorb0HxyqKIdBqZqG0vOARwLJQeKWNUg5rMe2AVGKNRGkFURolMQZGmS5xqBhIDeb1v9lRLv/XAs5/XyfPXsmK+VHq731/jfQz0X8XSNvdEmFmhypNJrQNNoIkyhzVOeq9VEmD6KNpWK114iR0wz2F4sn7JSQJBrXfs5KjGcm6lwCiy+KhRk0k2L/QQwvdw7wJ1OaNndNnXdUSR56aHPIFPeEDW0CY3qH0hX4zcVdjrWzwjqbEz5V2MpRIVQzgGGBiX+JiYPsl8+Uv8chuoo/9Q9aJDJZWZRIvArO75ljQkAyT7qXJCzdfxWTYKQKzmTqfOl7O/ju1GTfJJmzHmjn7sAogNvZPpkEkKPI+JBZhXRQXQ895XQZ5q/9OeyTJ8GaIGT5H33hp9yyQMZ4gV7oePBV9kxsUvpcWRgzNjIt4pRmClVoOuDi174sZGheM/73/C3i4YL5VbkdTRADdQzhl6DX+VZl46Drq3BYhCI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 25 Mar 2026, at 12:03, Muhammad Usama Anjum wrote:

> <snip>
>>>> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
>>>> index 250cc07e547b8..26eac35ef73bd 100644
>>>> --- a/mm/page_alloc.c
>>>> +++ b/mm/page_alloc.c
>>>> @@ -7038,8 +7038,30 @@ static int __alloc_contig_verify_gfp_mask(gfp=
_t gfp_mask, gfp_t *gfp_cc_mask)
>>>>
>>>>  static void __free_contig_frozen_range(unsigned long pfn, unsigned =
long nr_pages)
>>>>  {
>>>> -	for (; nr_pages--; pfn++)
>>>> -		free_frozen_pages(pfn_to_page(pfn), 0);
>>>> +	struct page *page =3D pfn_to_page(pfn);
>>>> +	struct page *start =3D NULL;
>>>> +	unsigned long start_sec;
>>>> +	unsigned long i;
>>>> +
>>>> +	for (i =3D 0; i < nr_pages; i++, page++) {
>>>> +		if (!free_pages_prepare(page, 0)) {
>>>> +			if (start) {
>>>> +				free_prepared_contig_range(start, page - start);
>>>> +				start =3D NULL;
>>>> +			}
>>>> +		} else if (start &&
>>>> +			   memdesc_section(page->flags) !=3D start_sec) {
>>>> +			free_prepared_contig_range(start, page - start);
>>>> +			start =3D page;
>>>> +			start_sec =3D memdesc_section(page->flags);
>>>> +		} else if (!start) {
>>>> +			start =3D page;
>>>> +			start_sec =3D memdesc_section(page->flags);
>>>> +		}
>>>> +	}
>>>> +
>>>> +	if (start)
>>>> +		free_prepared_contig_range(start, page - start);
>>>>  }
>>>
>>> This looks almost the same as __free_contig_range().
>>>
>>> Two approaches to deduplicate the code:
>>>
>>> 1. __free_contig_range() first does put_page_testzero()
>>> on all pages and call __free_contig_frozen_range()
>>> on the range, __free_contig_frozen_range() will need
>>> to skip not frozen pages. It is not ideal.
>>
>> Right, let's not do that.
>>
>>>
>>> 2. add a helper function
>>> __free_contig_range_common(unsigned long pfn,
>>> unsigned long nr_pages, bool is_page_frozen),
>>> and
>>> a. call __free_contig_range_common(..., /*is_page_frozen=3D*/ false)
>>> in __free_contig_range(),
>>> b. __free_contig_range_common(..., /*is_page_frozen=3D*/ true)
>>> in __free_contig_frozen_range().
>>>
> I'm adding the common version. After the change, I'm thinking about the=
 current functions and if
> they can be simplified further:
>
> free_contig_range()	- only calls __free_contig_range()
> 			- only visible with CONFIG_CONTIG_ALLOC
> 			- Exported as well
>
> __free_contig_range()	- only calls __free_contig_range_common(is_frozen=
=3Dfalse)
> 			- visible even without CONFIG_CONTIG_ALLOC as vfree() uses it
> 			- Exported as well (there is no user of this export at this time)
>
> __free_contig_frozen_range()	- only calls __free_contig_range_common(is=
_frozen=3Dtrue)
>
> __free_contig_range_common()	- it does the actual work
>
> vfree()->free_pages_bulk()	- calls __free_contig_range()
>
> Should we remove __free_contig_range() and __free_contig_frozen_range()=
 both entirely and
> just use __free_contig_range_common() everywhere?

The idea of adding __free_contig_range_common() is to deduplicate code.
__free_contig_range() and __free_contig_frozen_range() improves readabili=
ty,
since people do not need to see the /* is_page_frozen=3D */ true/false
in __free_contig_range_common().

>>
>> As long as it's an internal helper, that makes sense. I wouldn't want =
to
>> expose the bool in the external interface.
>>

Like what David said above.


Best Regards,
Yan, Zi

