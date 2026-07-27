Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3F919C54F4D
	for <linux-mm@archiver.kernel.org>; Mon, 27 Jul 2026 18:23:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 463596B00AE; Mon, 27 Jul 2026 14:23:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 43AEB6B00AF; Mon, 27 Jul 2026 14:23:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 302A66B00B0; Mon, 27 Jul 2026 14:23:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id F13726B00AE
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 14:23:46 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 8BD4EA0605
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 18:23:46 +0000 (UTC)
X-FDA: 85035380052.28.DAAAC4F
Received: from SN4PR2101CU001.outbound.protection.outlook.com (mail-southcentralusazon11012015.outbound.protection.outlook.com [40.93.195.15])
	by imf26.hostedemail.com (Postfix) with ESMTP id 9997514000E
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 18:23:43 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=cPcuBL1W;
	spf=pass (imf26.hostedemail.com: domain of ziy@nvidia.com designates 40.93.195.15 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785176623;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vpauCh0IeiNpe2PnqpcFKvqw3Ocm422EzLb5euim1Bo=;
	b=mcE4Lr8jKizgJFew5tANvLrU+UCmXEmIixGE9KO6P6bU0R2kXp3MXfb/HxYVoLVDtXPNG3
	25jsxMaOaN3/eV4TuyZc+QBTzC1Lns6AcwCgPn/kppAkqDEMnc4yNf/gOfUz1W1E6/IJ2Z
	O7NZOWR4R81dTYZHXP9UvjUd6bFIfS8=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1785176623;
	b=rK/1b5QT60GHq7ZooFoXNrFUJTTnQsJDaeMTnbeS0AS2pWhFwdzo/Jo/TXl5YkGYGKGdPx
	6JIt6tI73OZyrmr48s8r1ZWJSCnadhvazs+GC20mo3IBJahR2FgCuI8Y5qdp7iWasYPdZH
	iyfNLO4K/NJyXtD2QPlw9uW55eBomrw=
ARC-Authentication-Results: i=2;
	imf26.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=cPcuBL1W;
	spf=pass (imf26.hostedemail.com: domain of ziy@nvidia.com designates 40.93.195.15 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Zr0VCJ4MVdTOSN+MONutYPjH7qzo3Ucr21EKkYSanFNtxbkmrKSmTzuf4pBNehPxIEBLIKH1/AhS/k/BNfTylF1xP43uwDpjbYMq7VpauuFvWx8IOmkgevByvH0rKpZLFGH/4hX2sT3eCk2adv+QrOt9LpwQPIeBE9XiWTi/l05bNQ96wuD4X5SpLY8EsTlYbBshnnH6myjGZFyA2SVlaI0WcffNXbw0U8a2fWqjdAuNNQF/FReO2Q8ljZL1Ekmmk1iXuLn4gz+UDpLO8gvjI22z8hdJ/xiz8dIL5Z8I5nfiJFSc0FAUNdIqyQCzxK2va7tTDp3YSl/GDWU3tgk1kQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vpauCh0IeiNpe2PnqpcFKvqw3Ocm422EzLb5euim1Bo=;
 b=y11wc2agFR1nZqkxj82Sgu92aWyXLIlKoBdo1C7ae+CUwPuZCYH1FQAoQMPWunbZ0eb3zZYTklCuiXQl44H3NZZ5VjABFXd7u+goFL5rDKU+IJQd7sR2qF9YDFUBUE2GotuKD/GfNHB+wXsNl65sbYQ1xeoRaEajZ0PJkE+DwAtJWt/DtkeZ4F0oU27TMb2VFC/cJQ9Own+GRvF+ilagSSinCNtjRhMaa2H+ZTqCdTUS1D/oOjtlli8ot1+Y+jd0IlaQELaYIfhcNCDtW55kEAlLDMCe5cFz5G3L+uKE9BOIsJEzTn2wPPjfo/qZHP9dc3wg/DYfXa70+DpubRrCHg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vpauCh0IeiNpe2PnqpcFKvqw3Ocm422EzLb5euim1Bo=;
 b=cPcuBL1WYMN9kr6ys+jskHwh6yfj/51kYGSQp7fbHPFCjwDXi2F4agAHV4ttlDDD8TcTLiPLV4NXx4QVSX5Ax0nW/lcwvvzCkkQDKonvTVejuNvtb4hiqVYie2Gj/XucUQdvx3+XDcskjqnFHaf8j6aJaAALfneTPiLs7ukrT8q/WdTQURDiYoZlcsIm0Dpy0pENjU4xNMIpC39EuNTYHexpzM0IIZyDp4ARZZh/KPyOkyVJ2GDuB+PtTVnlHj3jHvjLrnSfCh2r8m25qJf2PcD5DlXK561gaioIiC9ccat/ZX9KEbg7ybuEcqaYvPGQLQekt87Eqb+8g32PZcYoXQ==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by SN7PR12MB6929.namprd12.prod.outlook.com (2603:10b6:806:263::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.245.13; Mon, 27 Jul
 2026 18:23:37 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%5]) with mapi id 15.21.0245.012; Mon, 27 Jul 2026
 18:23:35 +0000
From: Zi Yan <ziy@nvidia.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Matthew Brost <matthew.brost@intel.com>, intel-xe@lists.freedesktop.org,
 dri-devel@lists.freedesktop.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org,
 Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
 Maxime Ripard <mripard@kernel.org>, Thomas Zimmermann <tzimmermann@suse.de>,
 David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>,
 Christian Koenig <christian.koenig@amd.com>, Huang Rui <ray.huang@amd.com>,
 Matthew Auld <matthew.auld@intel.com>,
 Andrew Morton <akpm@linux-foundation.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <liam@infradead.org>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Tvrtko Ursulin <tvrtko.ursulin@igalia.com>, Dave Airlie <airlied@redhat.com>,
 Matthew Wilcox <willy@infradead.org>
Subject: Re: [PATCH 1/3] mm/huge_memory: add folio_split_driver_managed()
Date: Mon, 27 Jul 2026 14:23:33 -0400
X-Mailer: MailMate (3.0r7024)
Message-ID: <2FD2B991-09B3-40EE-8230-49BE3A239EEC@nvidia.com>
In-Reply-To: <a0c06d8c-fc3a-4ede-8aba-8c7430027a35@kernel.org>
References: <20260722044220.1110278-1-matthew.brost@intel.com>
 <DK564OOZ3JUK.292JORO9KGKEV@nvidia.com>
 <DK57FVTRTLR2.1A906PYJ2TCE4@nvidia.com>
 <a0c06d8c-fc3a-4ede-8aba-8c7430027a35@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-MS-Reactions: disallow
X-ClientProxiedBy: MN0P223CA0028.NAMP223.PROD.OUTLOOK.COM
 (2603:10b6:208:52b::17) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|SN7PR12MB6929:EE_
X-MS-Office365-Filtering-Correlation-Id: 5f269edb-27b8-45ec-46b6-08deec0c2bbf
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|7416014|376014|23010399003|366016|6133799003|22082099003|18002099003|10067099003|5023799004|11063799006|4143699003|56012099006;
X-Microsoft-Antispam-Message-Info:
	iWjhZ+4YCnlpm1RrrarX685+qWo33bwA3tg9xZUYVcCgLqeE2eExW+lmvSTRpl8kZQlLDA0UJ8HkAQO1JtBjCZAIWenF6RHaHGWXN1/K3dbY5SF6qXoJx4AEfQzJkbNAT4wTLQq35cO9x+EqTDgU8sUNrR7TxLn6l14I+ORnvUbmEreSp/GW0GpaiPfmHHlzaRrQrTppQ5qeKcjixu3aFUjBtxS+9raMHf0a5F432ErQuCtMZpDCa+7Ceh4UhXXK5oNwqMf2gLumW+p7tUdm5C+k4x0FroXXxi3QPiLn7uWorcCou1O9hzfuRfx+vDt3I2doqJZCTZMU5DbaE9vfdVK9zFz9JQEQd4ylnNFAZB6od4lRK8SGAaMIkTLBF1K5RivAHl+iwgQ0QehazBoTMuGBDGlXh/3eX3mEucY8LY5fM6vJXGHNlMDsgLBjJszjkRdYDGKhKFADUI/i57udGw4GV7N1yCayK6m6Bep91a8efAwhLT5o/9PxWH9UXOtVLkQ+cdE++sFfZQpeZBhYoz77bcDtVaPztiatpHF7BhZWDQsua1ynZbQ0zyEsQZjzeaOGciILLoSNfS1zl7KEkb9urfpskIlHY4qiaJKZIJcnHOYW1rI108mxZ+9ArirBPeWLVVpZrpAE1n13E04sYwaXfHsFNgP1D2UfapdU5e0=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(23010399003)(366016)(6133799003)(22082099003)(18002099003)(10067099003)(5023799004)(11063799006)(4143699003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?eDhuYi9ZTHRRU1lFblB2ZlJJbnBVWHloeXFwaC9SY0RDR25YN254TWVSTFFZ?=
 =?utf-8?B?Yk1ZY0FBS3BFUDlKdGNENzNBb05mV3JXOXdrQ1VXYzVYdUFKYjdudndJUHFT?=
 =?utf-8?B?TktUWnZLMjNSeWFFZlBHZDAwZGxTb3dtYmdyOFFoWHJzbjdBOVI2elhSdkZZ?=
 =?utf-8?B?VFpaTk5IY3ZwK1BSeGR2NXBZZTJUTitSdzY2Q1FWbnpKWEY0dmwyWXpoa01C?=
 =?utf-8?B?UlJJUkZ3a2FlVU9icDl6WllMb0JCd3lQc1JPRHROR2V3MmxwVVNad0g5SEtC?=
 =?utf-8?B?WGgwNVFXTS9WSWdJM3ExQVJrQ2JmZXhna3VUM3VXZElXVXppNE5wNW5RRFdn?=
 =?utf-8?B?VDBjKzNKY21mYTZ2Z1NVVnZ5dElRb2pMS2Vjall4Y241cXg5SkxnelFrUTA5?=
 =?utf-8?B?OEZzTVhFY0t3ZnBBb1pUTzVHaEVtM3VaNGY4UkNpNUJXZS8rTURoOWFlKzkv?=
 =?utf-8?B?TG44V1Zhdk16eXgrcWRmRTY2ZGZPSlR3eEl0d1pEQS9MOXlXTzJWbnFKWjJw?=
 =?utf-8?B?dXJiWlNoOFBkekgzU3FzMzMrTXUwandwSHpwS1dXQ3JEZlFkMC85cXI1Z1pz?=
 =?utf-8?B?ZVFSQlpzaGJ1SU5TRzF5OERUdW5WUXZEU0M2cmQrVEFxY05YbzQ3ZHdSM2hN?=
 =?utf-8?B?eGpKejZnQXpyVTdhK2k0NFJ6YlJ1VUx0RUtzWG85TUpVWU1mS1dSTHVtc1d3?=
 =?utf-8?B?V1dHSmFUTENPMXBTV041cThCVDhLdGR3SnZrdm1pL1pkZUJlS1pNRjdGSThy?=
 =?utf-8?B?SGRYb2ZJWVQwTVgwK3U4eHUxdlNZUXpKdzFEQzdWK3luYUpheVFMR2xsdzVD?=
 =?utf-8?B?NHJBSElqSVB2VTZmOEl3YWdKeCt6WktzMWhYTmk2RDhVNFg0ekdXWDhrYkw4?=
 =?utf-8?B?eVpTcU16b2xLcEFmOW9xNG0raHZwTERYR0xvMm5JMCtKcHJOdkkwVm9ONFVY?=
 =?utf-8?B?ZXhYM1o2QmVnUFNnUXJZZnFWN0k5R1dheDlGdHVaQW5jSGFaaGNma2VhZ3l0?=
 =?utf-8?B?bENvcWdMNy9KTktjejUvTGlnMUxjREYreWNjK3dhV2dPWDRxdnB2Z0ZrcStV?=
 =?utf-8?B?Rmw5R1JTOUNqWUlIK2p2bm5tcldZaUduelVlVzJYZXM2em9BVHIvK05vSnZn?=
 =?utf-8?B?R1ZacDlzZURPK2hBM05lVGRRYUEwQ0JvalZNWVROR3dsSzZYVUY4VVVqSmxr?=
 =?utf-8?B?ZzdiNDhmZ0J1R2duMm8wYnRIWkcyQkJRbGxPZTJYQmMrQnZRcVZiU3NLYUQ2?=
 =?utf-8?B?N1c2Z2FHbUd5bU43K1c5YjFYQlhTMktTSTZCL1pjdXhubU5sUDE2L2l6YjE0?=
 =?utf-8?B?Z1N0OEl4VVgrZStoRGhWUDU2cVdCSUNiM1oySWw2ZldJMGhFRkV6M3pIWGxh?=
 =?utf-8?B?L0p0YXNrd0ZWZVhWT1FTV01MazBkcFQ1NFZVbnlHVzFTa0lnR1NHTG5UeURk?=
 =?utf-8?B?bnJDd0VnM3BzSWZLTE1wOWdYbkhYYUNWUTBKZFh0Y2VMamN3YllDVTVyUFZO?=
 =?utf-8?B?UTFqYk03TENVMHc2eDI4aEJtcGljWnNCN1VvQjN5YW51a0xFdE5yNWVXZjFN?=
 =?utf-8?B?dU02ZjM4ZjA4MFY1VTE5SG1jZDhESTdKcldvTExYcWZmeGhrMUEva0pOSEJM?=
 =?utf-8?B?cjk5UFN5VWhSdWUxUzdrb1RRUDhWaDYyaFNNWjgwL2ljaTVRMVVYbStRYVFj?=
 =?utf-8?B?UGNKaURPcnVrYUFiVklpNGFpVXF0VWZrano3SnJsQW5BbGlWUUpGUkhXTTc0?=
 =?utf-8?B?VEdpbWVEbE1QK1lUczZYTFRIWnhPcWF4cjkyMXg2T3RoaUxSdWNyL1JiWEI2?=
 =?utf-8?B?eXBZZTB1NmVtQ3M5WHRHVzJlUDFUV240L0FWZEI4TFMvb09rM0R5M1lPamRt?=
 =?utf-8?B?R2MyVVc0bEJ6M3BzUjNqbDUyS1grRXNTT3VYcjlKZzNrVDZUcHlwaTVQZDNi?=
 =?utf-8?B?cm1DT2Urb2lLNnk4a01US21xOXl0RWtMcytqb01SNHJrNzV5ZnIzd1hnQThR?=
 =?utf-8?B?K1FvVWMveWU1U3RSYWxtZkJJcUpwYXo4UmoyQ2xXWHNkQ0lJSFlpMzBrMmpP?=
 =?utf-8?B?eDFCT05UWXlGeHEvellieTJWN1BHeHpJTGhzN1ZmbGxjQUVOMnV1dWZLdUpo?=
 =?utf-8?B?T3FoRXFaSkx4VHVqdThTWTAwVEVVb2wzR21UUDdvN3cyN3JSdi9QY1I5cmsv?=
 =?utf-8?B?RTNsYk13Q2NBeWRBSW5CeWtyL1dwUy9uUTRRTmZkYTYvMWtPLytwRU5oQkZy?=
 =?utf-8?B?c2N2Y0V3QTZ1V0x0SU5Tdmk1MGFwck4xQW9uUnlQdEJkWUI0VUJpMm96Ui9Q?=
 =?utf-8?Q?Y/FCNCb7RpSwpwMGEX?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5f269edb-27b8-45ec-46b6-08deec0c2bbf
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jul 2026 18:23:35.4128
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SB1kxIf0RN2VXdEZEZ5Z5tyZ1mC96cT+dogv+X8tnqpqy6aNsrvfqhcnWWibskKJ
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB6929
X-Rspamd-Queue-Id: 9997514000E
X-Stat-Signature: qx1519dun1mhmez91rg88y9gaw7aneuw
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1785176623-877268
X-HE-Meta: U2FsdGVkX1/A/ETuRz8sqlpUUf7C78/eVN/EiMokWI9ZhXvXYN+PHIp0jq/QyE06Sb8FsiO4QUIJ/ZNBBIThLKSOcLeR2FPL/4OQiSdHi9nX7AbI7+izW82Ai8xCHntS1Pgf12qcGFwZHqywhJLWxwsOfbfc+EioLMgx/Hsa+4kkLWp3dcWzzJCxZ0B/qUsngIENoFTqvjETzVUW0M8v7i9khAbBpwBAn9KxHw1NYk2lbjsAxFMro+hwKG9fjfl4ltJnl02hG9R3OHQ67koJ2dt54mUGVhKsaa9aXrelIlbMTzc/XBe5Yx0CikxHtbmHncQLQm9TCCNKoQ6VPqgOBuAv9XwFyqP34cU+p1BIl59m8IETkusTkvagAEj38Y02D9n0V51bjLc4lYAeOQb5H0R4vhWhO1I4YP1rRe67B4mcrio9IFA9/+jHykl6oaPqz5oW7y4sm8CVHrX0ysPxWnieK/FAy0dAhAG2yPFdnSRluHxJv2D8qLgmg0Qvx/hKW3FtsrRZIYzRg1B88nWiWZyDDV5vAXKGrA2LlwYOX23w0uoT2wNVeeVEO1voa+P7Na/+CDv01Z3vzid1T8CEPTJ9EYm8VcHg7jHSWYb2tXfMBKUMVezQv1vtvp0gvT/mUZ89KNfKwIZNfTggNilHJ+kICCGEF+R5Nxy0gwobl8Hh69mrsbmmkX8frtWYJD2Qe9XOg53vfCaHq8pDSkfA0JroWYL+FnGWG0ceBsqPv4bVLkgAlmtAncFS53pFaCEO/39KYKWv/8V+87i2wMmWYUMyuF9lr943vSgQ66pduNMvUQDV6xWYPWNdT/ME1XFpxr473iZ9/3nVkkXyHzstrBwGG6WFYSz5alJBmeMWoYaUih6PDiJ5dQggVlCIYYKp3FlwWuNWOqU5Ra16ARBpsr1Aczy/OQNkqFWELCEFB7vt0rGIJEE5kYAZHXKYZzFwnBPJNUd2G1spmtuQyjI
 i3g2zWy7
 JYYNEEoHLcDaT043lPwDSiPIIzQNRqTbPVIhK7JSPG+SRrQ9rzn7QBw6BMj27HSKJCgdGRk2lGhrlM7siEKOGUBKOtTNPc7ScOeHQWMPRKqg5462fd4tUyQfyefuRg19LjSa23T0XSB/qPmxJ5oXJtyujPMOeQAtBDHwZi9HBi6eZSsnx4PHW8VqV+YDu/cv3EBSDTRY58JJSg/8uNmR2q67tbSnCXmpwAV367IuZzpLWzjo7i95mJ8n6oZvLjuZBCnvwlH+w651ggHWm4y3hL23cNENiq0paOPOtmmwT1E6UtklSknMppxjrRSbiCHkyn8oU+sFs9K6ukSIa5FmDnUvdE7+3zFi0HBKRUz7BD6n4TkpSlL/1bm5pBn8m37a5MoVMkedVrLcaLQw01iILJz9kbwn+Xv3Ot5jcCkhw4Pf1tbNVL3T9lG0SS6+Vzl+whHlxccY2M7f0WUoeKvIl/LOtayF+tz73WV9FNEgiT06+8X2on41k6du0Dpz+seBaFnyc6ny6qWVnb3EFTohQZixXTxYQpHEWSE+mOpqGRHY6IsUAjunfrOAwtEj0FA3xDPLXls3Amr7NDBvi/I07w60wemWm5iGsqID1wtqIYtt1UX1ON7EJmGB2BUciubwSGvqYR9dmt6WLTWw4t5ZDef5wCTsDCewmLXxUCCtj5XwiJs8G/BACDw5tznrP3hwpN1RvwLQl9hUNic2kmgQR3VjOE+Njqpg0Yyj08Ct31rZVHuUR3XCCfRh3uL4isdtcgN+T6BuYDu7H2Ix9oIzjGs4EC3Q/BPXTXhpEMViI+RvN2cZ4PUxH/D8Ke+FjAa1O+e+EQB+0tcKamMxcOJummtJEIsj/YJ54OSGzSBj/r3cpY7CdXe/J6fjh8/f5GBHLiofvMNW/+dwObXM+q+uko2ubqFeL0kuq5hLWjuDNcUcnq8Wnau/wDViy9Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 27 Jul 2026, at 13:33, David Hildenbrand (Arm) wrote:

> On 7/22/26 17:28, Zi Yan wrote:
>> On Wed Jul 22, 2026 at 10:26 AM EDT, Zi Yan wrote:
>>> On Wed Jul 22, 2026 at 12:42 AM EDT, Matthew Brost wrote:
>>>> Add a lightweight structural split primitive for large (compound) foli=
os
>>>> that a driver allocated with __GFP_COMP and manages entirely by itself=
,
>>>> outside of the core mm's view.
>>>>
>>>> The existing split paths - split_folio() and folio_split_unmapped() -
>>>> are built for folios that the mm owns: they perform a refcount freeze,
>>>> walk and remap the rmap, and take the anon_vma / i_mmap locks, and
>>>> folio_split_unmapped() further assumes an anon, pagecache-style refcou=
nt
>>>> model (nr_pages + 1). None of that applies to a folio that is:
>>>>
>>>>   - singly referenced (the caller holds the only reference),
>>>>   - not mapped through the rmap (folio_mapped() =3D=3D 0),
>>>>   - not in the page cache or swap cache (folio->mapping =3D=3D NULL),
>>>>   - not on any LRU or the deferred-split list.
>>>>
>>>> For such a folio the split is purely structural: because nothing else =
in
>>>> the kernel can reach it, there is no need to freeze the refcount or to=
uch
>>>> any mapping. folio_split_driver_managed() therefore performs only the
>>>
>>> I do not think so. PFN scanners like memory compaction should be able t=
o
>>> see them, unless you mean something else about "a driver allocated with
>>> __GFP_COMP". You will need to freeze it to prevent the to-be-split
>>> folios being touched by others.
>>>
>>>
>>>> compound and split-accounting teardown via __split_unmapped_folio() an=
d
>>>> then hands each resulting order-@new_order folio its own reference,
>>>> mirroring split_page() for compound folios. The caller keeps the origi=
nal
>>>> reference on the first resulting folio and is responsible for freeing =
all
>>>> of them individually.
>>>>
>>>> The immediate user is TTM's GPU page pool, which allocates higher-orde=
r
>>>> compound pages, maps them into userspace via VM_PFNMAP (never through =
the
>>>> rmap), and needs to split them into order-0 folios under memory pressu=
re
>>>> so pages can be backed up to shmem and freed one at a time.
>>>>
>>>> A CONFIG_TRANSPARENT_HUGEPAGE=3Dn stub is provided so callers can buil=
d
>>>> without the split machinery; it warns and returns -EINVAL.
>>>>
>>>> Cc: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
>>>> Cc: Maxime Ripard <mripard@kernel.org>
>>>> Cc: Thomas Zimmermann <tzimmermann@suse.de>
>>>> Cc: David Airlie <airlied@gmail.com>
>>>> Cc: Simona Vetter <simona@ffwll.ch>
>>>> Cc: Christian Koenig <christian.koenig@amd.com>
>>>> Cc: Huang Rui <ray.huang@amd.com>
>>>> Cc: Matthew Auld <matthew.auld@intel.com>
>>>> Cc: Matthew Brost <matthew.brost@intel.com>
>>>> Cc: Andrew Morton <akpm@linux-foundation.org>
>>>> Cc: David Hildenbrand <david@kernel.org>
>>>> Cc: Lorenzo Stoakes <ljs@kernel.org>
>>>> Cc: Zi Yan <ziy@nvidia.com>
>>>> Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
>>>> Cc: "Liam R. Howlett" <liam@infradead.org>
>>>> Cc: Nico Pache <npache@redhat.com>
>>>> Cc: Ryan Roberts <ryan.roberts@arm.com>
>>>> Cc: Dev Jain <dev.jain@arm.com>
>>>> Cc: Barry Song <baohua@kernel.org>
>>>> Cc: Lance Yang <lance.yang@linux.dev>
>>>> Cc: Tvrtko Ursulin <tvrtko.ursulin@igalia.com>
>>>> Cc: Dave Airlie <airlied@redhat.com>
>>>> Cc: dri-devel@lists.freedesktop.org
>>>> Cc: linux-kernel@vger.kernel.org
>>>> Cc: linux-mm@kvack.org
>>>> Suggested-by: Matthew Wilcox <willy@infradead.org>
>>>> Signed-off-by: Matthew Brost <matthew.brost@intel.com>
>>>> Assisted-by: GitHub-Copilot:claude-opus-4.8
>>>>
>>>> ---
>>>>
>>>> The patch is based on drm-tip rather than the core MM branches to
>>>> facilitate Intel CI testing and initial review. It can be rebased onto
>>>> the core MM branches in a subsequent revision.
>>>> ---
>>>>  include/linux/huge_mm.h |  8 ++++++
>>>>  mm/huge_memory.c        | 63 ++++++++++++++++++++++++++++++++++++++++=
+
>>>>  2 files changed, 71 insertions(+)
>>>>
>>>> diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
>>>> index ad20f7f8c179..35661d82d54a 100644
>>>> --- a/include/linux/huge_mm.h
>>>> +++ b/include/linux/huge_mm.h
>>>> @@ -402,6 +402,7 @@ enum split_type {
>>>>  int __split_huge_page_to_list_to_order(struct page *page, struct list=
_head *list,
>>>>  		unsigned int new_order);
>>>>  int folio_split_unmapped(struct folio *folio, unsigned int new_order)=
;
>>>> +int folio_split_driver_managed(struct folio *folio, unsigned int new_=
order);
>>>>  unsigned int min_order_for_split(struct folio *folio);
>>>>  int split_folio_to_list(struct folio *folio, struct list_head *list);
>>>>  int folio_check_splittable(struct folio *folio, unsigned int new_orde=
r,
>>>> @@ -656,6 +657,13 @@ static inline int split_folio_to_list(struct foli=
o *folio, struct list_head *lis
>>>>  	return -EINVAL;
>>>>  }
>>>>
>>>> +static inline int folio_split_driver_managed(struct folio *folio,
>>>> +					     unsigned int new_order)
>>>> +{
>>>> +	VM_WARN_ON_ONCE_FOLIO(1, folio);
>>>> +	return -EINVAL;
>>>> +}
>>>> +
>>>>  static inline int folio_split(struct folio *folio, unsigned int new_o=
rder,
>>>>  		struct page *page, struct list_head *list)
>>>>  {
>>>> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
>>>> index 2bccb0a53a0a..06f9a5f35df8 100644
>>>> --- a/mm/huge_memory.c
>>>> +++ b/mm/huge_memory.c
>>>> @@ -4185,6 +4185,69 @@ int folio_split_unmapped(struct folio *folio, u=
nsigned int new_order)
>>>>  	return ret;
>>>>  }
>>>>
>>>> +/**
>>>> + * folio_split_driver_managed() - split an exclusively-owned, off-LRU=
 folio
>>>> + * @folio: folio to split. Must be a large (compound) folio that is o=
wned
>>>> + *         exclusively by the caller and is invisible to the core mm.
>>>> + * @new_order: the order of the folios after the split.
>>>> + *
>>>> + * This is a lightweight structural split for folios that a driver al=
located
>>>> + * and manages itself (for example TTM's GPU page pool, which allocat=
es
>>>> + * higher-order compound pages with __GFP_COMP and maps them into use=
rspace
>>>> + * via VM_PFNMAP rather than through the rmap). Such folios are:
>>
>> Strickly speaking, these vm_insert*() compound pages are not folios,
>> since folios are supposed to be rmappable and they are either anonymous
>> memory or file-backed memory. I am working on separating them from
>> rmappable folios by replacing PG_private with PG_folio and marking all
>> pages in a folio with PG_folio in page_rmappable_folio().
>>
>> Hopefully, we can find a better name, like refcounted_folio, later for
>> these non-rmappable compound pages.
>
> They wouldn't really be folios, I guess. They would likely be a simple
> "refcounted" memtype that allows for compound pages.

Yes, they are not folios. But =E2=80=9Cfolio=E2=80=9D was started to replac=
e =E2=80=9Ccompound page=E2=80=9D
and slowly becomes rmappable anon and file-backed. People outside MM still
thinks =E2=80=9Cfolio=E2=80=9D =3D=3D =E2=80=9Ccompound page=E2=80=9D. But =
once I manage to remove PG_private
and get us PG_folio, page_folio() will return NULL for non-folio compound
pages and we will need a new type for them, =E2=80=9Crefcounted_XXX=E2=80=
=9D. We can decide
XXX when I get there. :)

>
> But what is the conclusion here? It sounds like "folio_split_" is the ent=
irely
> wrong interface for these compound pages.

We probably would allow folio_split() to be used on compound pages now
until we can make a clean distinction, e.g., using PG_folio, between them.

Yes, folio_split() and its helper functions are meant for rmappable anon an=
d
file-backed folios. But currently =E2=80=9Cfolio=E2=80=9D is de facto =E2=
=80=9Ccompound page=E2=80=9D, since
for example prep_compound_head() initializes folio fields even if it is mea=
nt
only for compound pages.

After folio and compound page are separate concepts in the code base, proba=
bly
we can think about how to have two split functions for them and still keep
maximum code reuse. Namely, we could have split_compound() does the compoun=
d
page split (e.g., copying page flags, adjust compound head/tail/order, etc.=
)
and split_folio() calls split_compound() and perform extra folio operations=
.
The details are TBD.

Best Regards,
Yan, Zi

