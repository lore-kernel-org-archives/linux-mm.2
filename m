Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CD60DC87FCB
	for <linux-mm@archiver.kernel.org>; Mon,  4 Aug 2025 18:04:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 22C148E0001; Mon,  4 Aug 2025 14:04:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 203E16B00A5; Mon,  4 Aug 2025 14:04:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0F2FF8E0001; Mon,  4 Aug 2025 14:04:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id F31B06B00A4
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 14:04:28 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 93E9E1A0807
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 18:04:28 +0000 (UTC)
X-FDA: 83739849816.26.9BB1ABC
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2071.outbound.protection.outlook.com [40.107.244.71])
	by imf07.hostedemail.com (Postfix) with ESMTP id BB45540011
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 18:04:25 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=ixEm4c5V;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf07.hostedemail.com: domain of ziy@nvidia.com designates 40.107.244.71 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1754330665; a=rsa-sha256;
	cv=pass;
	b=Y2f6GYhDezVFdsbiiy8PPOkZXbc+5sSeb6LzkFjdmPrycRC70sYiUIpkJVNQouBE7SBK2D
	WMwuOKnCocSj4GZxYZ3F32IvlnW1CyqGI1cou2hQbaGPjTD7E3kfvuM1VmlyuCa2ESjA1K
	5I5kV0yfqKq9TtuQP7K+yQ3gfShuuBE=
ARC-Authentication-Results: i=2;
	imf07.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=ixEm4c5V;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf07.hostedemail.com: domain of ziy@nvidia.com designates 40.107.244.71 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754330665;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zcIJi8xZxYqzUjEJ2eomhnNn4VqJ+NI9+JUhKpAvt5E=;
	b=HZVBqq67Vpm//NEkSZkONJGwF9TO1rrarCsJhHceO2LwIrVcfKyRLSKg8XyrXl8ELbfSht
	BiZIzjCaKoqW3Jp4ayExXjTw1QACNOV4IYOUj4ixlULgExpwZ7y8D0LD5l4vKTQdZ88kct
	4d8tUgb6MlYm42/vmW/6cBbRYFI8iKI=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=LYkUeIZaT16Wa9aosLdU/WzTITbY2QikpAR1EugahiDQajInbCGYGQmeit59hk/Y72Ae/1/hiFVTcqYFs5dq1aDra9GCSyWmysd+omyGI5H1kER3ONLUlGXNQD++/fmn8J0H/uKzJCBtNJ+GrJgfmq+PjPGBFcQOumodpdXorKmRlNC0oTB36X56zgFqcEAWX8PDhrjpWcxFF5crfu1fwGLti7tPDLc5obOZPdXeF/kJ6TmLP7BjdzovSR54/Gvj0lPQMKHJTgxxeAkcrRZ+H2j2ear+4tbCCQz6QyG7z/FSTMd12YmDx/S1oSKXzAbbDuy6uQiKM86kEUb/jc0SOA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zcIJi8xZxYqzUjEJ2eomhnNn4VqJ+NI9+JUhKpAvt5E=;
 b=IIX5AZLcE658sBzW7BY+DwNefCcVN+njhUTcVhHFCbzXRdKqj6gjf82U1/PESybISMQ+LYJ0Eh+kBYV+NMH/YdH1W9yvyVgbc5KBB/yFC0i9qV4uJJ4Ch4scerb2Q85M/2L2iv/zOPp6TUcSl0hPZ4YWegua5MJgW8RJMhcRqS28ACQyfeYMbVxITzPhbaicopQETGOypLKbYDDvVH4rd0xeXxwe2+xxmrAK3qbsz5Be09bmNfFUWSEL3vMQ8GOyQP5e1VqBkwabF4cvaqjGEmrYhQnkJxkfZK2Uwb7NA+W9lumWJU8CI0bHhTjg2xkuZ+jWZnqz81bCM17txpj+Yg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zcIJi8xZxYqzUjEJ2eomhnNn4VqJ+NI9+JUhKpAvt5E=;
 b=ixEm4c5Vy/CKwUWad6pf4DMJSTCb4x0LAAd9gkAoxvfmLY59eryz6kWIojXC6lEfpLeJQwhb5INCu1hKVQYODbafFjRzIEI1iIHFjucVAlE9UyaRkqjVFNMNdQdQ1NjkwihJ6WYqcXroQfYWAeeq9+GhCIejc3Nn55uKBOlfe7el5Fx/GkCogmt6nzvOFeyklTYaY5bCWQEq2RzSQVJke0rfelojwe0X7EPns4K8R5GlJzbpO+QHKScdPEOo1NZj5h/w/b1GwrgTKQro46Ae80WhsB6Opx0wxS99hVYpmYWsmVCsgFJdFC+AhtG0JH4Zsti4PCbfWj3o2EQJu5HNFQ==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 DM6PR12MB4172.namprd12.prod.outlook.com (2603:10b6:5:212::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8989.21; Mon, 4 Aug 2025 18:04:21 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a%6]) with mapi id 15.20.8989.017; Mon, 4 Aug 2025
 18:04:21 +0000
From: Zi Yan <ziy@nvidia.com>
To: "Pankaj Raghav (Samsung)" <kernel@pankajraghav.com>
Cc: Suren Baghdasaryan <surenb@google.com>,
 Ryan Roberts <ryan.roberts@arm.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>, Borislav Petkov <bp@alien8.de>,
 Ingo Molnar <mingo@redhat.com>, "H . Peter Anvin" <hpa@zytor.com>,
 Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
 Dave Hansen <dave.hansen@linux.intel.com>, Michal Hocko <mhocko@suse.com>,
 David Hildenbrand <david@redhat.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Thomas Gleixner <tglx@linutronix.de>, Nico Pache <npache@redhat.com>,
 Dev Jain <dev.jain@arm.com>, "Liam R . Howlett" <Liam.Howlett@oracle.com>,
 Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, willy@infradead.org, x86@kernel.org,
 linux-block@vger.kernel.org, Ritesh Harjani <ritesh.list@gmail.com>,
 linux-fsdevel@vger.kernel.org, "Darrick J . Wong" <djwong@kernel.org>,
 mcgrof@kernel.org, gost.dev@samsung.com, hch@lst.de,
 Pankaj Raghav <p.raghav@samsung.com>
Subject: Re: [PATCH 2/5] mm: rename MMF_HUGE_ZERO_PAGE to MMF_HUGE_ZERO_FOLIO
Date: Mon, 04 Aug 2025 14:04:11 -0400
X-Mailer: MailMate (2.0r6272)
Message-ID: <0F98E975-AE29-4355-B2F4-D1B299F7AD98@nvidia.com>
In-Reply-To: <20250804121356.572917-3-kernel@pankajraghav.com>
References: <20250804121356.572917-1-kernel@pankajraghav.com>
 <20250804121356.572917-3-kernel@pankajraghav.com>
Content-Type: text/plain
X-ClientProxiedBy: BN0PR02CA0010.namprd02.prod.outlook.com
 (2603:10b6:408:e4::15) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|DM6PR12MB4172:EE_
X-MS-Office365-Filtering-Correlation-Id: 18c4b75b-92d4-4d13-1a49-08ddd381568c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?EqJMPmZS+WdcZQr8r5VPX4nIhft73DFG5avx9cvwWbfUG+TixP7jCZJLcASk?=
 =?us-ascii?Q?Mq/L4EiGFfllUMV/7U5wCH9L5mSI7PJXbAu5YBdzmj7au0+P1VhupWPnyrPW?=
 =?us-ascii?Q?FsC3E1+QhnxdeMXohg2WXJGP2cuW0FdlKD4kCIyGVL05ydnV0cP4NPWkc2P6?=
 =?us-ascii?Q?s5iKDwu7cfsIL8Oz7npL+sXP/MV7TM1J3dcIFFlpj5taTVxxT81CYfduF5Ju?=
 =?us-ascii?Q?/upnbV3zRDmK1aurLJbpbh+C1bakgsAh+ieXl/PhzNvtaPzmxQkGJ3LtT7HN?=
 =?us-ascii?Q?l9MEHQnuCC5jjeFhThCcNHHCxogRMH/FDTGObEzoOdJBIxLsN7t1do1Dx1zr?=
 =?us-ascii?Q?j1dL9bfcAdLni2szo5iYkKhw3stoxhydPXnF8HMYfBVkUOVChv9Qg5wWs9+c?=
 =?us-ascii?Q?XLvZh71EF+5BWteVDiX5Z0I0IGfRq/Z0jg43ocGyvo8Q2zAGozmp1Xfw5qJL?=
 =?us-ascii?Q?+g8YpWMhm0ME6LG5j1ZFQ828PpOlFySmYEdXv9MK3e7h8lIXNcgIiQbjO1s8?=
 =?us-ascii?Q?FVP+bUqMH0I60tjJlT1OcDZrjI1BqUiEv0ifXuscXDBC243HQ1mpZ3VHxL84?=
 =?us-ascii?Q?vm0ddv55P3lb50XS0EX3XN5nlfleaSNpaLhGGbFxDcuePPsBncmXR8XzpCLf?=
 =?us-ascii?Q?RXdhsB5lA6IJ/prQbn5O1oFzcw98SZsrsqdvY5/aETv2vPZwjnIwXqP3VeKq?=
 =?us-ascii?Q?V5EyhuK0G+VNMqMqRVONjFMQQ69q+8Z/aCxgfMaHxByy2yzRqyfFRSq3vr/P?=
 =?us-ascii?Q?qgn5xarKfd2zNHKgRmOFXyLD1mXoJTH7L+nffweaBbM3RLk8NcHfUvLI4wCG?=
 =?us-ascii?Q?VCoLSukB+a6V+03GP36m1FLneVMGkrgBm5ZRoFyc/atRu/ALTOtkYmOqNJxj?=
 =?us-ascii?Q?X6lDR8a7mjiwJ6ndh90x48NYbI83sC0eIbPwcvVS4L9pOwjA9d6uxVOI/9zn?=
 =?us-ascii?Q?3qH5xo46YtzZDsnyl9T4ZsM3QmOXl2Mg2ZdbdQfyv9SjWCRQe+2A3UoT5u2j?=
 =?us-ascii?Q?zYfzUKmhzfhtGjeRIr+CIzITbvPmmlPklyukuDx0mBq6P3pztEVlxIu7Y8tY?=
 =?us-ascii?Q?hI2ccPY268G/MYCbFyh1nXExM3B8j0tnmOR+1kZIbT9JDRcCVZcBiRzlOBUW?=
 =?us-ascii?Q?QmN94fuHNp7iSz1NsuCK4JgN/P8d0Hdl9HqfP0YoGjV2ZxmGqUAs14qTmJfe?=
 =?us-ascii?Q?7FWsX6b2/8FpqK39Sx0uvGU/O2EorBZbAfBRhk2UzRvnJa9u9mi97zQBhfk1?=
 =?us-ascii?Q?OwGJvxRmlwAE4pjm2YtNKaR5w75xndFYA9wAQNgNMnWiffwkmvhMWn/dxlRE?=
 =?us-ascii?Q?NJu6u1ARST0m7vPAYEORupEbZtGLAcSbKovSthRbqKZadjutMOdZKKCCs4dT?=
 =?us-ascii?Q?ZbhCbZWb8j6kQ007CMwQ9v/VPHvd3R16Ehtgqaljx4xxN2ygeb2Vu0xZBbke?=
 =?us-ascii?Q?t/5fdU/ktHI=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?gPPXFpr+pgZZ6Sfh2XDuEXlUsqmdw1FitlJl+9Jwvc1qzVLB0pn5KXHj7ZjX?=
 =?us-ascii?Q?9OWeohpwdefRuR04/VXP1bqqRQ/DIp8AazCivm05kccq6eadCLtGJccXF9Ru?=
 =?us-ascii?Q?olPxwcb2pC8ZNWeqmao2eyAhgvf0O51v8UTLYIvfbLG66vNDD+FJPOOUVDR4?=
 =?us-ascii?Q?kWDfn+jy+z0hWaVbFvhA5gQa2NADW6+JunGJ3+dKqJ6B9t6d0iXCaOOnAJMg?=
 =?us-ascii?Q?lxt4ETmz/Rq3EeofVAzmE6Gz0As/Ynsu9kQKdMSg2DSdYXz/Ogi910iqOIzu?=
 =?us-ascii?Q?pwGA7Ux8HLF0wPRg54z4OZZ/EyhF8YMx3gg8E/nXT8Leoif+xaBSgm1Ffmgb?=
 =?us-ascii?Q?4ziQ4NiW4onjgzPW4q28t8xPu28vx38Fm5Nx+h3rgkIOq5lNQpQNHTNwHZXJ?=
 =?us-ascii?Q?WcIF5ookguXHcJJaHHSyJzrT/jL+6yVRbuwz2ldMJC+R0BNebvftPLivrkmI?=
 =?us-ascii?Q?zxVCODLqtbzP5K77mECLmCsSV+KLr5BaRc1nhxw4qkYUFxyfc21/ig0M+k4+?=
 =?us-ascii?Q?D8yWJbvgsL7i9AKARqJG/1RulieXnNhwWQXH25vL9FRVayIJHz20Cy0kLgZ9?=
 =?us-ascii?Q?IhdXr5pyXDI9TVQMY+qV92QF+EkiwvVK7Caw68cY43/pIZvfbqF0S9nfuDW5?=
 =?us-ascii?Q?URg+7P8ltFd6B3tTlFI/EyYaLh9JByq4pp+m0khQWV0ZgnWQdppN+jPCh+pP?=
 =?us-ascii?Q?8I/j9tvLQTDbAD5Opq5qbTNyEd9fLWt4Yn9dlsjCZqoRhr5UamGbyVIszTQJ?=
 =?us-ascii?Q?fd00fKp5g2CHeZfCiz8umyebtUrCbLTmAwi7cmTgi6W88TzOBlLxXZbxQfQf?=
 =?us-ascii?Q?aR1mbYSP4APQCTOK3EU4Gj39ARRUXKk8K1+M/F/U9/fzSP2BPdof1/8iKeQ6?=
 =?us-ascii?Q?+mBhXOpH1wC0YTlu7gp479Oiaozu9BVGsgwwFNSfXkgW4CvG6+T+hZFTdWC4?=
 =?us-ascii?Q?PzuZPmIXEXV3yg+r26t+MCH8IyWURHh0ZhtQq8FUqFhjMANG9OXstCByhNYE?=
 =?us-ascii?Q?p6LXr44V7CDgtkCVEfnBAS90omNG4Jx1RtJ21MG3GQkOkxGy03EkztKO44gC?=
 =?us-ascii?Q?11wGNn7k7vzOjTTFQRQTPXnSOdXIbwLC02kOfKpUi/tlIcqo0K8FbYW9QInW?=
 =?us-ascii?Q?6BbzUJAgUVa3ABNcfXi4t/CYByLgkbEBzK4+jqbYjU/4req+j02SBW1+oKhY?=
 =?us-ascii?Q?p9/C91m12ocaWSD/JfNJnvMtTwa6z/zShCEmHQegoBq/qYpoOF1pcf/mCd/V?=
 =?us-ascii?Q?dc5u2W2BjGZZH4iJ9b83yTlV7UTm1u0eHS4kaMVTpJ0uagyzr8NdEuXSDvUP?=
 =?us-ascii?Q?09SCkn1xWXWguXr8OqZQsedL4m00wsoecq/i2Nxs5JzNoWq2+mdE5Mhjp6SG?=
 =?us-ascii?Q?7iBbt/R8ykZ5dl30AAi0X97E7RyZuElcPchfvz7zgp86555IvMuIbP4jMX8Q?=
 =?us-ascii?Q?3Dp3WkxZk/1ZFv5oOt/ISS94112EAnuTbs4Kywm49/6F6f+kOiya1oK9wuOp?=
 =?us-ascii?Q?9+ll6YtDGrl7HZcpEsWU/HPfTSgc2ozl++vmS9owNoFrXvCJxdBySaov6c4i?=
 =?us-ascii?Q?miMwZNfcUwkKQw7jCZlcdesa0woFV/fXg9oxEQyJ?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 18c4b75b-92d4-4d13-1a49-08ddd381568c
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Aug 2025 18:04:21.4065
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VimqIc0GsFDocO46orm6Nq/Qh2xKf+zlYvQyVi4C7uUHpSJR5BlS8uGM5MWpIRyP
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4172
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: BB45540011
X-Stat-Signature: hgdffkoe9rajw481atcogbxj4w8nrsui
X-Rspam-User: 
X-HE-Tag: 1754330665-510690
X-HE-Meta: U2FsdGVkX1+ELvY2klZI/JBAFYNPz27fFbLewFVuJJJ3NEy0xVKEIVIs/+kjphWy1/7ddIXJYAI+DcLakHvXgnKqmNIlAVcqy09pEhjaxHGkryzEloh9Ow3iWGUHo3kQozawZWdgt7egHCFzMazDqlvvCzvElD1AvXq4Hl3xlAyy/7861yskmRoJWzYsapEnf7PZPUXQJ840TzPJGPEg6JIslQF0Bpd73kb93ARvwwrAyw7Mx+u9c33bLkTbLAJCo8U73UFL/iD8RiZkG3V4vde1Kmo7+oZ7wIAiyIUals5AdMs4LecRd/t4dWEQr6hnqPR5Cn5107JT78GP+E/rmxJAmNgz0iJc1NLymLoPwPyTOK4xHsCi42w09TWUMpHHOMhwClXTN2Ahd8eA9lTtNklZEPK8OwpC+58r+qXYU78t+wjYOMOsnUEEsm7GRGBJc1BKTjHXHi/n3UcjnH/8aMHGT9P/Z817VwCFgNAVdT2peP6UzqWQaM/6+GBmrwPHzjr/YIKxiD6cT0vFMAiNP/gS4IFCEOyWuWKZzz+38EJeTRQMVgWFCfRGcwxInwfSE70wTFcy4XH3Sh10jurPEQ/QSuX9az21SOawU15KZffaHQlN7OZeAw8wW7uJFWtRzGssTA0uebR5LUVv0gKCpZu0j+DiiJszPTDKgzOcXp3BmN2ENxFGVVCJQSUBN9segT0fTFxbsM/TqGz1ngCeP55lzuObsBOyyXSHNvmguq1BNV93y0l624FBiAhXBNGA+1XwYVYsKXDIvQP457XO+G6+oFTrvCc5orQHKQkxRJNULXcFiK5yWJ5mWdh/5J/nKgolvLzAL/W3s4xuQenv6xzYqdrtLhjs4kFpRd++6K9bMAmPDJRmIfPhFCeJjeajIG0AUaLeaS474KizEtQfA82lij8CKbVfwhapWG0yNHcktWiprmzBnv8jSH9AdZLWanhFiO/dt9qdSNMYR2D
 t/M9HYp8
 JbUMuBvydvakigV3mah9fH37AA3agR3NxFQkh134GlwUBDbgsOHVlman4b/bHhisYNjuXifaZiG0ToEDwJB9MnMPHywetE5opm0MIAEOXJdlAZODow6yXjFTt6Bi1p053UyFw08pGYIzWqDXgUtQ2BIc6JLP3rndbPcUyz/ZNK4eXkDet+ao0vn1El6x57e2U7Qlv2QibExj5kHtMl80jhwEtOLcjAH1WzxOAAwL9rtEAFzaksB+aNT2UW+MtuSNZqLFXwKpOtv2lVACHrrrE5IBdKFRMbh6AWkk89iASoCrfFCiaghBuSQqUdeZlBYUH0CvFgQ0z2zY1QMQSXT3VF6k3PZuVXlFlJWUpGZ2wT9ECAHB+PGG9Jtkk3H77dDF5AVcddA+mG3dibVAFM5Af7HZZptVj738CogwgsAKWLm7FEBSQRvvfafP47EIXQxCegMC1hPDyUbsaSpr87VpZc4HgcOFM46LTPuLSBAZYQYKVXrvdOaAJtD+xS5aYYSOPm+WcyXdjU5b0Lk6rRjqrTaQicET4ErQdfvlqyAXJBa2LuT1J4u2RlMCZGUYq4ChdRt3/Uoqs38h+0NRdhaOhNPCCoj2GTuGJyhE6
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4 Aug 2025, at 8:13, Pankaj Raghav (Samsung) wrote:

> From: Pankaj Raghav <p.raghav@samsung.com>
>
> As all the helper functions has been renamed from *_page to *_folio,
> rename the MM flag from MMF_HUGE_ZERO_PAGE to MMF_HUGE_ZERO_FOLIO.
>
> No functional changes.
>
> Suggested-by: David Hildenbrand <david@redhat.com>
> Signed-off-by: Pankaj Raghav <p.raghav@samsung.com>
> ---
>  include/linux/mm_types.h | 2 +-
>  mm/huge_memory.c         | 6 +++---
>  2 files changed, 4 insertions(+), 4 deletions(-)
>
Reviewed-by: Zi Yan <ziy@nvidia.com>

Best Regards,
Yan, Zi

