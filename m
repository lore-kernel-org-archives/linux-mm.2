Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B4B65C61DBD
	for <linux-mm@archiver.kernel.org>; Wed, 26 Aug 2026 01:57:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3A6716B0095; Tue, 25 Aug 2026 21:57:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 32F346B0096; Tue, 25 Aug 2026 21:57:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1FA1B6B0098; Tue, 25 Aug 2026 21:57:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id D93E06B0095
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 21:57:35 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id C26F4C0222
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 01:57:34 +0000 (UTC)
X-FDA: 85141758828.01.4301507
Received: from PH7PR06CU001.outbound.protection.outlook.com (mail-westus3azon11010041.outbound.protection.outlook.com [52.101.201.41])
	by imf09.hostedemail.com (Postfix) with ESMTP id EDC07140003
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 01:57:31 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=mAOuOPHW;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf09.hostedemail.com: domain of ziy@nvidia.com designates 52.101.201.41 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1787709452;
	b=WxxHLBBBTtfz96c3/8hL37bi7oVKkhIWbD5PEDMPCEjWZXvw2m/UNaNP2DdkR68jEKP/J3
	2LWyFNV7nliCep+hJm5yhiWmEWBE8HeqhF7pSnT0XvpcJOpsrZATVyo840urND9NS5PsxU
	DHmzbpg+MeKpjXoV+tWMCAmPSOGlCFs=
ARC-Authentication-Results: i=2;
	imf09.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=mAOuOPHW;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf09.hostedemail.com: domain of ziy@nvidia.com designates 52.101.201.41 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787709452;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MWM6G+BrfGL4pKmf4fqqg5dURlVRdvb49e1obUGRYLM=;
	b=boAKzmsJJJ3B5eatAGr9tUVcr6GD71p+vm9PaOFKnwGW6XU5I+qx1mQPgU9HzhYOH8FeOg
	3Ye0BXtlFVQe3T2ib2iq54KXDXea2mCdSIqa2w93WwKhVzs3Kxav0BYaF2HB+vzgpjo2Bo
	KDkZ3TYCLzgP/fJfGJ0zG7jRSv5AVTo=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ObXLF2zLXcn1qMkPhXi9D2HczmMLs10GUbF0izUGJhaXZdOVvlMmjeFB2GoGYafz5sJIEF0+HNx9WnmKU6SsWmnM2tcW+wPYnBqL1lnUgQptJxbtfuCjUSmbmtqwgH63i5kkMNNlXs8V0bBKJA4yr4tMeeJ4aVMO0tIclvwWVV7vcvLN0k8bDi4LplTwC5Bdsze8z/r/9xIiMJsjBkOHPfRier9kpUyYSZcMOzlNCcDvKKW4dqj3wEP2C6NwpyTn4BpK+klLy0a2WbLotToHM2eJld4ilaLg6Ncc2HcWPS7JVmQo/YK6Snr41in8gDp+z43klAhqCEAifTlZ1MOwbw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MWM6G+BrfGL4pKmf4fqqg5dURlVRdvb49e1obUGRYLM=;
 b=VeSUage10dh6JWhqfQNvTQfAt2q8jQoRs67GM8SNzIFinC28t3SIcA9iJiT1dHCJE6Dw7itKavGXGlb0S/UCApU1fcjpAH83avq8GT4WnVPqJlmAp7wgG3f6j+/TzmR9jFEr4itaM/ZOKMe9NpS/d1ZzL888U282MKqftwpwSAw6zvxZnJh6hsjatvAXVtfkQSKcmlyyF3Gt0719F+ckhy9UTvvem3ng5b4U/QaYiQhUfrrbEY0KYGywmwrFE/lGxu2S/92BcEDcjag/PNBQBAOVOkKNPE9TrOoBCU6n5ucSrtXaqMB7A9UjD++Kz/cH6VIztX4KO62WWASrEnIRlw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MWM6G+BrfGL4pKmf4fqqg5dURlVRdvb49e1obUGRYLM=;
 b=mAOuOPHWj9T/vKhRa1BWCYBisbK6q1KHFnXzSPyuib5r9GSVIy2oM59ow/Hz/S6AGJaxgB8pYJQve/wdVZ732LGOORFr82CLbH9r19MpE3HhpX3SuZE9sQ+2bHAXh9i3Xo8k19NSiN/jwMyFIDoI/TPANieqD6PHBBmw/vIa/exJg2dY5jmYjmE6FbCOFcBQ/mksD7j0ljjAJ1xbA7cIGCZloRKrb+zXMUUqLh4P+yUXGIcOPGLKx92tUmXmgii15WcfflmZ60tEpW76B18fulZ7JrjHSgTJp+Mq4qOg12BtPVP5W19Rw09dTML4jFo9NjrmMyCQD0pZlFCmS0Ywng==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by MN2PR12MB4421.namprd12.prod.outlook.com (2603:10b6:208:26c::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.360.7; Wed, 26 Aug
 2026 01:57:25 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%5]) with mapi id 15.21.0360.006; Wed, 26 Aug 2026
 01:57:25 +0000
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Tue, 25 Aug 2026 21:57:22 -0400
Message-Id: <DKYI3WDF6SO4.36O1VGH8TDYXO@nvidia.com>
Subject: Re: [PATCH v3 12/18] mm/huge_memory: add kerneldoc for the split
 helpers
Cc: <linux-kernel@vger.kernel.org>, "Andrew Morton"
 <akpm@linux-foundation.org>, "David Hildenbrand" <david@kernel.org>,
 "Lorenzo Stoakes" <ljs@kernel.org>, "Baolin Wang"
 <baolin.wang@linux.alibaba.com>, "Liam R. Howlett" <liam@infradead.org>,
 "Nico Pache" <nico.pache@linux.dev>, "Ryan Roberts" <ryan.roberts@arm.com>,
 "Dev Jain" <dev.jain@arm.com>, "Lance Yang" <lance.yang@linux.dev>, "Usama
 Arif" <usama.arif@linux.dev>, "Vlastimil Babka" <vbabka@kernel.org>, "Mike
 Rapoport" <rppt@kernel.org>, "Suren Baghdasaryan" <surenb@google.com>,
 "Michal Hocko" <mhocko@suse.com>, "Chris Li" <chrisl@kernel.org>, "Kemeng
 Shi" <shikemeng@huaweicloud.com>, "Nhat Pham" <nphamcs@gmail.com>, "Baoquan
 He" <baoquan.he@linux.dev>, "Barry Song" <baohua@kernel.org>, "Youngjun
 Park" <youngjun.park@lge.com>, "Shivam Kalra" <shivamkalra98@zohomail.in>,
 "Kairui Song" <ryncsn@gmail.com>
To: <kasong@tencent.com>, <linux-mm@kvack.org>
From: "Zi Yan" <ziy@nvidia.com>
X-Mailer: aerc 0.22.0
References: <20260821-swap-thp-cleanup-v3-0-9b43f5163238@tencent.com>
 <20260821-swap-thp-cleanup-v3-12-9b43f5163238@tencent.com>
In-Reply-To: <20260821-swap-thp-cleanup-v3-12-9b43f5163238@tencent.com>
X-ClientProxiedBy: YQBPR0101CA0274.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:68::33) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|MN2PR12MB4421:EE_
X-MS-Office365-Filtering-Correlation-Id: 3dda4bfb-a630-440d-07a3-08df03155ff8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|23010399003|1800799024|366016|6133799003|10067099003|56012099006|11063799006|4143699003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	pVtmpKRMQBuMBcZfQQRUp53T0wYU3y28ijlafN4O56iWu9bDFArvUUQY77z2RnxTBDpOoz9PjjAn3vKrZveOf032s70vTM1XJwmZ8ubEdjXU43hPX0mR94LD+QqOaY+v2bqK12DWnzf6d6VD3xWxQuZZ3Sig1t0S4NBSkcinpzBicd2YW7twArBY1jYIWaO2X6+dKuEraJMgwa4qV181FJeND/3Rnt1l2PTQOIq9Rb34fZRZVyzkxL4JRMVd/KOoSuaUgc9+i3ZNEXUVYuCFaLZmnH8wpApFZYzcfNzfxSyCR1N67UmIXr6/7gVMhT6FfEmqGujFbniv4kpglz4ieeE5mvxAKEVJvmpGWo3RJEiM5hrviIkrOoxvJOQ2jcOZgQ7Q0TV/D1FnIZXf5HfDjNIZCaT0EiRX6BGl9N/k2iayMGl0EDY2evOKdAwoO866fqrDtNeNmzm9xL3l7JDMJDHAvq6m0bNys3CQCUVQaGwSCnpibx2EUuDOLUUZgPlqZACXIhb3Ub3C5lic3l3YUtqKdqASO4pGomiL45mwRS9qF23/G8IeLf7+4auWGG3TYhDkKI/Y1HXd51DUnh9fEHFc+w5bRVJa9fB+DTYmqD9ESGv9wk6s1wMVyUAxST49Z401iezQsXSqJB3ejduoOTf2rKDEZgMLVT9bvK4zwUU=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(23010399003)(1800799024)(366016)(6133799003)(10067099003)(56012099006)(11063799006)(4143699003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?UERYajg1a1dIUUZwMWI4NnE0aXpYOVM2OGZtZzVyaGJoT3krVmlieEZWQjl5?=
 =?utf-8?B?ZmRNbXhTT2pBNWVMclZKbmtQREowY0haVUU2YnZRSDJndjVqOXFoRmhaR2Fl?=
 =?utf-8?B?cXM1d2xLcTlHRjRXbzRLR3FyNG9TTEtWN1V5eDBBVEkwU3ZMd2MwdmQxM0Yr?=
 =?utf-8?B?N3pZeWwxSGRnMHU5QUxGZzB0VmZOR0piamlFcTJRcDVEMUNPS21EbkZQWUYx?=
 =?utf-8?B?RmtKNVd2bEt3VkZTa2dUSWFTY29ydjcrWGN6V0gzVjRCcTYrVGdnaitrWVVZ?=
 =?utf-8?B?TkVhRm01UU9sVHlqWm13Y3J2VllCSURncy92Vk1xUzBxQStES2h0MFBHdEZS?=
 =?utf-8?B?cWtkMnYvVUw1ZTN5SCs2bEozS2lxdlFWM0pXY21udGc2dnl0TUI0UHcxUS9P?=
 =?utf-8?B?eUo0V3dmMy9MM3QreUNiM0FNYzdXUU9JOEt3NC9BbVQ1OElWNStDRjdFWS93?=
 =?utf-8?B?QlpOSkxTOVZLMDJXcE00anQwbHpjL2h1RGFqQ2RleFVwNS9sV0U4bU43azg5?=
 =?utf-8?B?SkZMZXRPVEhpaW1ubHNyNGFad0pGNFIxT2RKU3lxKzQwY1A4UkFUSXNJSkZu?=
 =?utf-8?B?b0JpZVVVZjNXalV2dFNZZEF4OEl4dzZNMzcrK0NXWW9xYlBJNHZLYWNvZ1FQ?=
 =?utf-8?B?Q1pIaWE2Y3RqanZKUFgrVTJRczZVR0tXTXQwdFNJRWtEMzYzSGFZc2JFT0Rp?=
 =?utf-8?B?ZkRxTzF1bW5KQzZsOUFMRnlJZGNKbXVpRzkzSy9jTnliY3dhUkZ3cGVRTmk2?=
 =?utf-8?B?clArclpRejJiY29FUUY3bURqSzR4YTMvR0JZaVdCeVZLZS9KenNJV3o2aU91?=
 =?utf-8?B?YnZ2Z3djWHlDbG1XYWQ0SHZoNXNYTFhueVhMOWRDRk81aXNac3pxR2RVc2Jy?=
 =?utf-8?B?RW1hQi85OXJkcmVzYTU3cFFOWHl6MWRkRGtoTnlpbURKR1FDK2E2QmF0SmRv?=
 =?utf-8?B?aGFEbzE2dHE4dytCYVJvVDJMNEt3ZE8wUmdtSnQzMTZDcEVFYSt0bmV6bWNP?=
 =?utf-8?B?NmtjRkd4ZFdjS1d4YllVZlBuRzYraWEwRUpVNVRYWDJYbHcyWHFYRXZCaExC?=
 =?utf-8?B?VDFsSE1mclBCVjRyeUF1bjU3WEtna2JVWnlPYWt0Zmg1cDNZZXRRNzRZUDRw?=
 =?utf-8?B?dDNjTGFCZ3VVS3llS1RYTlhCUVo1ZXg1WXE1dVZhU3hRUk0xMEYzQW80azZm?=
 =?utf-8?B?Uk5nbHhZT0lHTjhPdDUwWTZnMno3bllPVnJOQWI5OUgvKzhBNFBCOGZOTmYr?=
 =?utf-8?B?WGZKRDJZQ0FZemFhaVVJV0FUeVlGRmsyNWNSd24zTVVpUWFQSWQ3SFlCRTg2?=
 =?utf-8?B?ZXJrSEllU3VocDlOOWEyU3RaTXBjMytuVGRPYnNwczFMQTljTHBLb2ZxY0Nv?=
 =?utf-8?B?LzUvdFhlRnVqMzlXOFI4QldZNmZEaXFaOVhHN1c2SFk2OGZlL1RBOWxkVUlH?=
 =?utf-8?B?ZC9OSUpuaWJlbzdUczhRY2VxTEl0K1dGTEQrSGNOVHh4YkRvMVBVMzdYTzZs?=
 =?utf-8?B?ZDFCQWtMK3FQNnhvSlVKSHVXdSszVnE2Q2orQ2Z2TlRCSXNabU4wNld1MVQ0?=
 =?utf-8?B?cFFOeTF4aUpKYmwwQSs1ZG1HMXlyWG5SVkQrMVBkd0ZLdnRmUmc0a3gycXg5?=
 =?utf-8?B?eVE0Z1lFNjdtMUFOa3FSRUZwWUFhWHk5NUUraWpMR2F2NmFKbElZMUhjaTRZ?=
 =?utf-8?B?SWM5NGMzemNrbXF3ayszZU50OWdZWjIwUGZ3RURvNTFVcTd2UHJPTW12clZa?=
 =?utf-8?B?T2NHcUsrQ3pQSU5vVHp6bkt5eTBadWtpRVFNSUQ4aUJEYzVWK3RNREQrZlhF?=
 =?utf-8?B?Wlphc09DY2t1dUlCRzJmSTFwMVlmaXNuaUNsM0Q2N2VWeWhoSXBYZ0huVUk0?=
 =?utf-8?B?b0RyRlljbnNzY0pXbVlCcG1zUU5IOTk0TnNVYVY1V1lrNUdPT1U0ZjR1TjFD?=
 =?utf-8?B?YTVuTkMrQWdMQU5OOUNJS0NBU24vbVd3ZXpSN2JYSnRvWisyZmxpSjVQdXRQ?=
 =?utf-8?B?cjNHSmhLVlVQTEJOUW9VZWR6UlFOSnlMdHhkNTEzYld1UWVWaFF6UzZHQXcy?=
 =?utf-8?B?MkwrNHkzNjdSYUJBUVBxNFRrUW9zV3BtdjZpa0Z0ZVBVZmd0Y2NZVEVoeC8z?=
 =?utf-8?B?MWRZN3JVb1ZDdGkyT3dTdmt5Sk1ndlVRNFkyYzI5UW1reDJ2WU5HYlQvRmhQ?=
 =?utf-8?B?SzhHMDdlQUNlczVKOTNwek9Nc1JXOXpYcU90WkYxZ3hrdVA0MTBsbGpnWTBD?=
 =?utf-8?B?SUdIKy9ZNm9yK2V5TVIvQ2FaUkp6YWxKbzdIaThNVDU5YmFMeU9XcE9JdUpT?=
 =?utf-8?Q?IAte5Kz8bI71p0a9xk?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3dda4bfb-a630-440d-07a3-08df03155ff8
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Aug 2026 01:57:25.1030
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zrgKz+/Dir4Fabbfb7rN160jLmWp5KCewt50eEsFZzu3JgZMocuc5gniQ8z12sQj
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4421
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: EDC07140003
X-Stat-Signature: kcnqp8qrec8ys4gayik3hsjsyuycumi7
X-Rspam-User: 
X-HE-Tag: 1787709451-245019
X-HE-Meta: U2FsdGVkX18+41i4brJ27BmOH7PXBe9Ft5bNZ87ch2TRikLuI0UCKYSU7YHUXNwbq2/HcKa8ttP1qSGgIrq1ickNwa/0uuPyP9sw6R+g71eavsYXo3md3oBMDFMAV5DAomLpfBooGqstGzxpdKrhnHL/PLp/phr9kLtSqIvgvcvBgZJZG0HFzEnA0pPHGcrqcqz0QcXLepiOGtBWqL8LM4snH+c29Gv/3zFAfCz5ymoVMNbblcb3CXC61rGbDkxR5bHjh/k9P+clEpu34fX9yOOSA3J7FX8DYa0/Vyzcusl6k0oPS7jYO8GQDRVkkkVZjQAPsqzgLgbkFV2ECY1JjW4Z6C/vy+aKpqwHBWtlb92u+WyAuTMXUIMOlI0rneDrmPNiqBh4EZ/6suZikzVf307ow7YcVi9kvJdy3Ps2cXcg40IngL9DyiWjxxpYBO9+esUHVP7+W7X5+XKQX9Od6QbF3y5Xu6wl9IdWzk1O1AfZV1X9X0FjDPmnrJ1JvhY8REsB/4GrJl0gxphpMTViruIQP3UdsA6RMw36Yn2kVxv/GCemzRjzPPPB5bbtVUPe2UJYa+J98QWsu6vI544hus4H6LhjsnMIJc8wb1RsTwVoMk6RO0+nzr7gOEp/9EbRJusuzQFsihcQ7pZYYKlHWdN7Tisi39+pIYcgbqTDzjH5gkVoh0wNbBmcYKzpBdbRKVnhOIcZCAodGFfrKKTK7zCklq7+qA0xbjGwNQQeTnrb9seLNOIfqPhJ446qrDUFO2IYtgD8VBaglnvuU6cXduyZp636OWLRKcHeAnuXFHkOuoSD11QsHl9JHgtO9EPQmePbOKHc82G1eAkkjc0gasjPjalUgAOQ8YghBYCQvDR2T9xQfS8ld0hj1W4X3W8tz7L+G5atYwvAguhvSEtU+CD4mBUPIREEXUgFNYgcqW31i/eeon9uDyOpiMbkynnbq5Y9Iyz3UV6bnXHvYiy
 9Jyw1yEk
 bDmWZsA9+uLhyqN6OSbOY4YY/d8Q7w6QPt0oxSztpNQvwTZHkYs6R8F5FRrs7I+ccjRbHAISiFKrY0VslXoHCzxgTCLFmZP73dhtKfi8nZIRkT6HrkI00P2/X/uwTNfBe24l3jrgh7LuG/ui2AJhpHjQ3EpCWsQp2hQVnA+ibx+xtM9R2zRC+3DExEA3Xe+tWX1vUFJHUHwr1keoiyXMN1COYFRZQL8QTvcRnwOp9Y+dxuABQFIPDlwTVNyaPW++4oSZGQroWA0qexJRiBbrROjwpfIfeV3hU7CgcSQ1mm0XxRvp71mzBg2Q884djg5/uZ0qmDhrTawDJB6gYeCR5PLJ7oW5Ch00yYgEQl+n9goUj9vf6/3Nqpw4vw5CkIbnO4YlAl0ECYkodSE33k9CpZaGdIh9YZQSSxLpxmM2h3gbWcbaA2lYpddsNycYgFb75xBso+s1/G7tOCm/6rQ7KG2NHcw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu Aug 20, 2026 at 2:55 PM EDT, Kairui Song via B4 Relay wrote:
> From: Kairui Song <kasong@tencent.com>
>
> Document __folio_split_unmap_and_freeze() and
> __folio_split_unmap_and_freeze_file(), and rename the file split
> helper's definition to match its call site.
>
> Signed-off-by: Kairui Song <kasong@tencent.com>
> ---
>  mm/huge_memory.c | 38 ++++++++++++++++++++++++++++++++++++++
>  1 file changed, 38 insertions(+)
>

LGTM.

Reviewed-by: Zi Yan <ziy@nvidia.com>

--=20
Best Regards,
Yan, Zi


