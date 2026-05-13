Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8D52BCD4851
	for <linux-mm@archiver.kernel.org>; Wed, 13 May 2026 07:47:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 01C9F6B0005; Wed, 13 May 2026 03:47:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F100C6B008A; Wed, 13 May 2026 03:47:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DFFEA6B0092; Wed, 13 May 2026 03:47:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id CF1C96B0005
	for <linux-mm@kvack.org>; Wed, 13 May 2026 03:47:52 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 6ADE2120795
	for <linux-mm@kvack.org>; Wed, 13 May 2026 07:47:52 +0000 (UTC)
X-FDA: 84761617584.15.52D1597
Received: from CH1PR05CU001.outbound.protection.outlook.com (mail-northcentralusazon11010034.outbound.protection.outlook.com [52.101.193.34])
	by imf09.hostedemail.com (Postfix) with ESMTP id 6E52714000F
	for <linux-mm@kvack.org>; Wed, 13 May 2026 07:47:49 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=m9ER6tYw;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf09.hostedemail.com: domain of Christian.Koenig@amd.com designates 52.101.193.34 as permitted sender) smtp.mailfrom=Christian.Koenig@amd.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1778658469; a=rsa-sha256;
	cv=pass;
	b=QxJWQDlryu8jmxnU8zpnUYq0KVAZxIEXs+imU2XjqDmmIhME0bZnbdAjv0p2m3wnjUtFM2
	a+qKgPFGvqz0WYogSfcBGUGUdmhC/hz5e1DavW6UecSjyHHGkv6FwAvcN/Jj8LE0pV1WQ5
	J6mXsEOrpA/PDRr+qoBDZ+UKlwckZqU=
ARC-Authentication-Results: i=2;
	imf09.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=m9ER6tYw;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf09.hostedemail.com: domain of Christian.Koenig@amd.com designates 52.101.193.34 as permitted sender) smtp.mailfrom=Christian.Koenig@amd.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778658469;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eSMMze0X1t3niHEonNZoaeG5b8BHCbIE51hU9k2o1f0=;
	b=5MhNZgjHODO6wqbkcOEmiJEYM3nXOlZP7l5fG5ozn+Dl+nAmpkwnBpg4VBXwRr/pBIOCha
	yONE163HqJ9RTkQ5px7LAV6hK9vLZmPdO6LsqTY0mjsmKTjNWJUsA7DtiOyY2ohxxCFbW9
	gtb2SkV9KAy1FIQn6/6rVonEpQih99g=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=AjT60frQXRXX6LCF4peQKIX+FQOti13BmK+MC5qro9ZqRmePxgTmjbiBEd1CLaf+L+2r6NzOhPmQiCfXihpQiRfMGkSPP43ZeVQqzjQwPMPghTR6A4qo3Fw0thmyqnh+YE/pPpObOwH4DaAAiG06cSreYmdL0CutK2ULhik/jLmtZXkTgL/JCRCPqbPgd08Z6ePXRY3toONe6f2mhEOPxK2vRl51pTJV2nY4htRe8juag+Gi7BUoY5lD2sa0dQr5Hmtw7nmmoSUDT5eZ6NvfTigExdkXMLtoXRooRhZYBZ+2wA+duhrsfqluUtpoK1KJPBx2h6W8lrUKFNO9tDorgg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eSMMze0X1t3niHEonNZoaeG5b8BHCbIE51hU9k2o1f0=;
 b=vDGH51ywaYEPUz4beOlvc/NRI0b3TQFqvBFQl7KfwCHwB7OX2X3plUHLSd6FteUVGph6vfJcOpIVpfymUkBFd90SCqMs+E7bhGjxEkk2Aap8CHVR8f/doXE4IUg/bUSqV84DBwgiyikLoeV6pMNyP6Q1wWkBS4u6AxhUsy3/41KeSBfP4GAdJnaGDhExBIcaH5sj4TeYt4hkxBh2rLP7gVJw3rXgLF0uvsavfrDUcIXr/9LiT0iwgaSVEnEZbhpSan3xC2+X0eoLzqKyx2wZaQVkEYYjDzg/nTfdQbidATX4F3qLnrZ/efwKbBwsj+R9C728WD9HR1OQYCUMw0wWPA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eSMMze0X1t3niHEonNZoaeG5b8BHCbIE51hU9k2o1f0=;
 b=m9ER6tYw5Yr4L8kLV3uk0d4w6dlnw8uW+eywlhICq6pNiMCh6H0hPlcaNLWMfZ891+vOXo5qodWWH45MSmhM9D91qDrBCuxufDuj7kcrAEBEykblGJr+zSUblPx+4fl+gJjDE/XyvL4Z0fIh+kJA+oyL38gj8pTciGK9iPN9P30=
Received: from PH7PR12MB5685.namprd12.prod.outlook.com (2603:10b6:510:13c::22)
 by PH7PR12MB7841.namprd12.prod.outlook.com (2603:10b6:510:273::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9913.11; Wed, 13 May
 2026 07:47:43 +0000
Received: from PH7PR12MB5685.namprd12.prod.outlook.com
 ([fe80::ce69:cfae:774d:a65c]) by PH7PR12MB5685.namprd12.prod.outlook.com
 ([fe80::ce69:cfae:774d:a65c%5]) with mapi id 15.20.9891.021; Wed, 13 May 2026
 07:47:43 +0000
Message-ID: <c6b4031a-5625-4b1b-8a51-6e47241d32c9@amd.com>
Date: Wed, 13 May 2026 09:47:31 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] mm/shmem: add shmem_insert_folio()
To: "David Hildenbrand (Arm)" <david@kernel.org>,
 =?UTF-8?Q?Thomas_Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>,
 intel-xe@lists.freedesktop.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Hugh Dickins <hughd@google.com>, Baolin Wang
 <baolin.wang@linux.alibaba.com>, Brendan Jackman <jackmanb@google.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
 Huang Rui <ray.huang@amd.com>, Matthew Auld <matthew.auld@intel.com>,
 Matthew Brost <matthew.brost@intel.com>,
 Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
 Maxime Ripard <mripard@kernel.org>, Thomas Zimmermann <tzimmermann@suse.de>,
 David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>,
 dri-devel@lists.freedesktop.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <20260512110339.6244-1-thomas.hellstrom@linux.intel.com>
 <20260512110339.6244-2-thomas.hellstrom@linux.intel.com>
 <f14d99d3-c1ff-453b-a280-17b8c4d5af94@kernel.org>
 <b4800086347aa3b27edc42b6536cb3a2b76a1aa8.camel@linux.intel.com>
 <26479389-459b-4cc4-914d-e7d29d5e5cc9@kernel.org>
Content-Language: en-US
From: =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>
In-Reply-To: <26479389-459b-4cc4-914d-e7d29d5e5cc9@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: MN2PR22CA0004.namprd22.prod.outlook.com
 (2603:10b6:208:238::9) To PH7PR12MB5685.namprd12.prod.outlook.com
 (2603:10b6:510:13c::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH7PR12MB5685:EE_|PH7PR12MB7841:EE_
X-MS-Office365-Filtering-Correlation-Id: 0bb75a48-a8f2-485e-1dc9-08deb0c3ea53
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|376014|7416014|1800799024|11063799003|22082099003|18002099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	v0QwQ+C83A1YKYpv+F34ZsFc2ITQJCB6StcZJOjD85+DbYJ4FnaHvhGF0rt4g7fWMV67p1EBzdXRD7iHlR+MAzE9JjKAKq54KlXyk69wGpwMJ7sF+oscjmGuLUza9jlmTwv9p3UIYPIBQjSa5Tq0pBioosZJCHT+B8vXQMSkUaoZsDuRs+wsOYuo3lsMCXph+Ejz++knnzAmudK7tT/4q8uF8s+71QamV3zBLWI+8nVSCMbjMEriaMktLr/+sBispnxT6ZaNkMLPjzxVvxhkU79yLjYNYriLyBXIxLFNWV7Ppp8ruYaBkL/FqMjMXiDs8NjQ8NdYjkjgETfokj6Id+ZtYy+RWvrnyX/EXu+LChAbH7K3VF5PZNexaF6XaQQC8wyiWSmOUgBz5dIloA5XZKlxJBfv54Ahf/LN3XbDOTBBwjE8DOa78IPkMSO8WWN7355FxiMPDokPBjM8YX2p6uuxd+tgHjDnUGDrwkRly1AT/v7n1zo5TOdSIJpmsmdwWFL0N+2CiZ9CasKByW9r4hZf936N+IMDcw7eRs1hRTHsDCNDMygeiibQuYlrZZgdvKqKdIuIo8Q8SABKrzBIn6Jkty4uOyh4dElnLdpaMFK4PR/V6/cZa/nS8rpyOiSsCeFTM0KZmSgBectKGi7ueKNKzM30loc+759nRH/YTdy0za+fWlS1pljLVQ7+PUb0
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR12MB5685.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024)(11063799003)(22082099003)(18002099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?VGROYk9VTDFzaXhqRVZoNjRVVEVpZzUxZWNsbjkrbTRqK3BEajFaejh3Sncx?=
 =?utf-8?B?Z0xoZ3pFRUl2c0N5M0hjRU9vUHF2ektUeEh5SkgxbXM1NmpzZHBZSXJHaUUx?=
 =?utf-8?B?TG02NGlLVGVkcXYvK2RJYWpwcXZxL1NuQzBrRUVhWmhrSm8zZWNHUUp0MlVP?=
 =?utf-8?B?U1FrbHM2T0JoL3FDTHBCRUpnRlJUaTMwTUlHUjQ1THBaY3UyWVZDKzhmaVU5?=
 =?utf-8?B?RGx6dzk1TXlBMytMY29PWHVCQjFzbFViN2pyWDdjTlZlQTNrT092cDBkc0dK?=
 =?utf-8?B?dDFNVUMzU1lSb3F4V2xKb2dRYlU1MW1DS1BwVWRteEJyQmJVQ0hVUzFqdXhT?=
 =?utf-8?B?VjlDYzcrTXJNaGpGMmtJeGJxMk5FZTRiSGJHbG5NMGhydVU0V3IzeDVpenVx?=
 =?utf-8?B?L0grQW5iTWJtK1kzM0daa0E4V1IzU3FLR1p6Zmh5ZG1tQmtSdkpMdk1FQ243?=
 =?utf-8?B?TzczQzh1azFRTTRxc3U2b2pCbHFhMnNoMzhuc3ZRU0NSdThpaUpIdVdVZ2E0?=
 =?utf-8?B?eEd2SjNFMHBVM2RrLzl6eHBoUU5QTFVPTU5aVVZMVk1QT0pNemZIdkdhOVp2?=
 =?utf-8?B?S2doWGhvL0xJd1o0U1pvZHlNZ2UycjM4eEtXTnRhUnk4Z0FRSTAwK2xnQ3pL?=
 =?utf-8?B?S21KR0UyNE9pYmN2S0h1azJMd0RERXFsaFVlMmpnQmhBVUgySUVZWnkyMkdP?=
 =?utf-8?B?SkREb093Z0RqcE40ZjJNcWsvdlMvbGtDUnEzM1pxRnhTT0Y1MlJoeXUwMmR3?=
 =?utf-8?B?c2lYRHpYRnFrb1NkWU1EczVpcWxMb013Z0RpOUFOb2NtSmlNTGlNNmgwL2l3?=
 =?utf-8?B?endTTmhHSlFNaWlxNFpvT0wwRU1pRW9GS090Y1k4OGh5VGdlRk1CY2FZTjQw?=
 =?utf-8?B?dlRMcjlKWGdOREdLMlhCakkzYzJRNllKbjZWNVlHQjJqMmNrSkZNOVBFL2Z2?=
 =?utf-8?B?UXVBWUJRQmJIY2ZPU2RRa0xKOUoyaTBXWnZ2V2ZjT0orVVNObmZydjd2WDVJ?=
 =?utf-8?B?b1N1YkloRDREcDZqM2NwUFNlUEErRStTUjBMQURGZ25KRHB2Y1dTNy9Jb01R?=
 =?utf-8?B?U3A5L1NoNHh0czFlSGo1QnZLeXBHWVlQOFNiRldJMzVQSUNtZEU3b1NYTWlw?=
 =?utf-8?B?MzUvTkltb3ZZY1ZLTkNuQWZxVGJjdTJXTjFqSVdTSEZHeHpXeTEzMGtzUVNu?=
 =?utf-8?B?a1dldlM0M0xqK0NhdXI5cWNNUGdWMFRoWGczVFMyZjNnSWpUVFpNSTNjTFFH?=
 =?utf-8?B?WmcxZDBqVDc2VnJQejczRHBNdkw4OHFyc1JOclZrbFdHbld5T2RHWUJLcmZu?=
 =?utf-8?B?bmhEUnc1UUkrVEZ5QTdCT3NldUp2V2lLRGtldEFMVkY1clFQUTdrYkdyU2pm?=
 =?utf-8?B?RkpHd2tTUk9yVU9Cc1JlaTBEZHQxNWZMTGdWRHV6d0l4RWdrbEwxNGt4Viti?=
 =?utf-8?B?N3dKWi9NWTZhQ3ViYWx1ckJnVk5ObmI0aDFYRitkcGFGWUwrOVdBVU9qWloy?=
 =?utf-8?B?Qlh3QS8wdlErbW4vbmNQT0Jrdmk2M2I2aDBGRVEzT0tnNVVGeDhmMHBhS1ZB?=
 =?utf-8?B?dVRnZTFzM0pLYmduc0UvY1c4QUtndkhrOUNoWXVaYlR5OWc0TXJOam90TUor?=
 =?utf-8?B?dlZHOTJjM2dMTFp0NElIRTNzdkRzVUJNKzlSNWlZbHhPcHk1MGsxdWpqdGox?=
 =?utf-8?B?dzdRRjNhRHlzQVJjaFdnbDVaK0xFQ292NVNPSnFGRHJPNjFKckg1K21wN3Jw?=
 =?utf-8?B?dWswMGlDN2s5T1VHZzVYNm12aTZSZWlBaWFNUU03LzVPWFM4cExiY3BvYUZj?=
 =?utf-8?B?RHQ0RGkxUTYvcnNadk94UnJBL0E5c0RGallyUXhxOUJnOGNvdUY1eUU2Tjlo?=
 =?utf-8?B?b0gyZjMwNnpONUNDZnRZNU1HUTJQYjIwUU9kbjd0VjJMNmVpaEw5NHNXdGcv?=
 =?utf-8?B?NTExYTh1NmlZLzYxL2JoajFKRHRlRjZiblRUT3hSVHR2ZlNCNHV6bVJNMEtC?=
 =?utf-8?B?UnVoYUIzcjVPdTh0RHQ2TnlyVEExczcrS2xvYUV3SVh6WjRPZmRkSm0zQ1BM?=
 =?utf-8?B?R2IvaUtxelozZGY4MC9ZT2dpb3lvdTJ0UGVDQVpsVVViUDFiVWttMm0wcC9Y?=
 =?utf-8?B?bDNUbDdXb2xnQ2xoQVlEbU5oL242a0p4MmY3VnZvZHhHYVB4QWJDK2RYYzk5?=
 =?utf-8?B?QVZmcERoR0dXeEVadlBMQUFhWWxBOFhxWVA4Rk9wdy9ubFViT0UwVWlRWVRw?=
 =?utf-8?B?bkVJOGduT3RqeWZEWEZGZFhITkxWSXNvaHdLNXNzYWkxNHd2Y1dlR00wQW1F?=
 =?utf-8?Q?0Rig9V76BKIizvZxTY?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0bb75a48-a8f2-485e-1dc9-08deb0c3ea53
X-MS-Exchange-CrossTenant-AuthSource: PH7PR12MB5685.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 May 2026 07:47:43.1512
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OvqxOCohnrjrUGfxzguY1DJ4hZA586CCsUVBcjTFROd/sGdyiVa1P1oewztKaEBh
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB7841
X-Stat-Signature: widwgqwq4qtn6zrazknybp3pmburqc9f
X-Rspam-User: 
X-Rspamd-Queue-Id: 6E52714000F
X-Rspamd-Server: rspam07
X-HE-Tag: 1778658469-676408
X-HE-Meta: U2FsdGVkX19bNucOBYjjM7z7tKqyof8Ic0ekUBP/QF/2Qyj8rEH3NasieFxb2pIe2JTE7BLYJxLgA9BvrpFcZfO3t1LtABVUC+VDvMUd4bDJY9m7e5tRqANooVSvxIQP6KZ3VXbOuG1VkusPEIBqdEsjbmHDO4P3qCO25xAYJd/TbNsr/NUhJinxsSPd9qM6PAMznKQFJ79IUvOZss1KCZnYKqfftIBHy1eVqeX3XJQXt2NAy1J8ZkLReySDClEcfKHI5Zk+YI4WhdQTTauVY2sTPuTEdRnaEpuN8BH/d62pfTlMcPAZ35Q/r0NWDXjTADGSk0ctcZhUn+RpkJToAy4MEkupjYJ7PQPE5ERtH2eob/xNlRVbXNIIGvCWH3YD4VuFB90C4N4P7E85Us/GrLzMEkKa3VYvzkVLHGxGEtZFD5bJLe76Z5nE7dOfMRjv9x6zTJUBh7ItkiDjkktkCKAsFdfEnhzAYmz44kwxA4bz6Ucl2k69AU74zCUXR3sWK4C3A9X24U+AMRz3ZEFl9GMAJPiKu53g3LClMOtUsKqkv12l8Asf4Fl3WcneIxlXlKq4IAOC8jvUNwIMkJquI1/DH+vz1GAO4q0NHpnJVsBm6nI7WKBflRELxtfFoZ0r2V+qO0wzRWszCZkjtHMq6P25ZyFzHsSIuxCzSZVRrfFWzZNqG7VGG7OStQAq6lPx/piHEyuS1C2tVuXxZxTD5z8SWVRF24tS2iL0e5hohKSNW3DKDHxXNK/EfOC/7yvPfTic+VumtqyOICNcA9iIOXJM7F4QUgMmNYcKwv9wfF2je3qHeh39mwtbP0oXOBa9RXcl/gi3PByxUKTJKjNSmr7ND7QbMgqBU+nQhYkEwUKxuJsQqUv5TRExKn8SVWT6gLWkl1BIvT38LmQBgLUANQgvr9qOjHpHFl7TF5iYGDgP/rM/zdFfSgUdvqCaspMwepfuqUN6oPSpus2fJU3
 W44rK/Bp
 Roo47aKX4+FZYi4xJe9Z+dzILyyxiYaZf7FteqoFcux8RtlI9JN4LaVvUpYz1BRYamvrRpIqMHzdaTdCBHzIDpHBxk5O7K19QIpq6sxLmmWp7wkjByUCSNM7wXA75fGw5G4ctV4rlsNsNgedujjkgFK6JyVVSA9aL5/wCMp/0F7fV3TEP1FiHIMtbB6o6aaX+i8zHFAP1Z31AkPlWIVH0kSDs3HzCxcqfdBa7kHLf/28ONWfp5fGNO9e1pyVX8Iqrd+kNnzNzE+H0VlWhVC2ZiV+mM7H9ETgIQqm//pNjQi8g7OtDdDqcOytyKieoxzRLYLdDvjjNMUY04bLqcNd+WtrbAN13nYwQUbR02wMAv7acik0G7V5Ne054mmvdfqN73YDBi+I45stdKYw4TB3SHife1eP2gLL3o45kCy11QqJRAcMQCIkeyKe/UkcWkbb7NhK7hDUNUEkE0/irkMs6J48TSp1Fscs8GeLnGh4EDPMt0s9QmQqukcuLAYt66bCu4tcT
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi David & Thomas,

On 5/12/26 22:03, David Hildenbrand (Arm) wrote:
> On 5/12/26 13:31, Thomas Hellström wrote:
...
>>>> +int shmem_insert_folio(struct file *file, struct folio *folio,
>>>> unsigned int order,
>>>> +		       pgoff_t index, bool writeback, gfp_t
>>>> folio_gfp)
>>>> +{
>>>> +	struct address_space *mapping = file->f_mapping;
>>>> +	struct inode *inode = mapping->host;
>>>> +	bool promoted;
>>>> +	long nr_pages;
>>>> +	int ret;
>>>> +
>>>> +	promoted = order > 0 && !folio_test_large(folio);
>>>> +	if (promoted)
>>>> +		prep_compound_page(&folio->page, order);
>>>> +	nr_pages = folio_nr_pages(folio);
>>>> +
>>>> +	VM_BUG_ON_FOLIO(folio_test_lru(folio), folio);
>>>> +	VM_BUG_ON_FOLIO(folio_mapped(folio), folio);
>>>> +	VM_BUG_ON_FOLIO(folio_test_swapcache(folio), folio);
>>>> +	VM_BUG_ON_FOLIO(folio->mapping, folio);
>>>> +	VM_BUG_ON(index != round_down(index, nr_pages));
>>>
>>> No new VM_BUG_ON_FOLIO etc.
>>
>> OK, can eliminate those. Is VM_WARN_ON_FOLIO() preferred,
>> or any other type of assert?
> 
> VM_WARN_ON_FOLIO() is usually what you want, or VM_WARN_ON_ONCE().
> 
>>
>>>
>>> But in general, pushing in random allocated pages into shmem,
>>> converting them to
>>> folios is not something I particularly enjoy seeing.
>>>
>>
>> OK, let me understand the concern. The pages are allocated as multi-
>> page folios using alloc_pages(gfp, order), but typically not promoted
>> to compound pages, until inserted here. Is it that promotion that is of
>> concern or inserting pages of unknown origin into shmem? Anything we
>> can do to alleviate that concern?
> 
> It's all rather questionable.
> 
> A couple of points:
> 
> a) The pages are allocated to be unmovable, but adding them to shmem effectively
>    turns them movable. Now you interfere with the page allocator logic of
>    placing movable and unmovable pages a reasonable way into
>    pageblocks that group allocations of similar types.
> 
> b) A driver is not supposed to decide which folio size will be allocated for
>    shmem.

Exactly that is one of the major reasons why we aren't using a shmem as backing store for TTM buffers in the first place.

While HW today can usually work with everything down to 4k it needs higher order pages for optimal performance.

So for example for AMD GPUs you need 2M pages or otherwise the performance goes down by ~30% in quite a number of use cases.

Everything between 4k and 2M and above 2M is still preferred because it results in better L0/L1 reach, but if you can't get 2M the L2 reach goes down so rapidly that people start to complain immediately. 

And that stuff is very specific for each vendor and HW generation. Some have the sweet spot at 64k, some at 256k, most at 2M.

>    I am not even sure if there is a fencing on
>    CONFIG_TRANSPARENT_HUGEPAGE somewhere when ending up with large folios. order
>    > PMD_ORDER is currently essentially unsupported, and I suspect your code
>    would  even allow for that (looking at ttm_pool_alloc_find_order).
> 
>    We also have some problems with the pagecache not actually supporting all
>    MAX_PAGE_ORDER orders (see MAX_PAGECACHE_ORDER).
> 
>    You are bypassing shmem logic to decide on that completely.
> 
>    While these things might not actually cause harm for you today (although I
>    suspect some of them might in shmem swapout code), we don't want drivers to
>    make our life harder by doing completely unexpected things.

Yeah but that is the requirement the HW has.

I mean we can keep torturing the buddy allocator to give us 2M pages, but essentially we want to get away from those specialized solutions and has more of the functionality necessary to driver the HW in the common Linux memory management code because that prevents vendors from re-implementing that stuff in their specific driver over and over again.

Regards,
Christian.

> c) You pass folio + order, which is just the red flag that you are doing
>    something extremely dodgy.
> 
>    You just cast something that is not a folio, and was not allocated to be a
>    folio to a folio through page_folio(page). That will stop working completely
>    in the future once we decouple struct page from struct folio.
> 
>    If it's not a folio with a proper set order, you should be passing page +
>    order.
> 
> d) We are once more open-coding creation of a folio, by hand-crafting it
>    ourselves.
> 
>    We have folio_alloc() and friends for a reason. Where we, for example, do a
>    page_rmappable_folio().
> 
>    I am pretty sure that you are missing a call to page_rmappable_folio(),
>    resulting in the large folios not getting folio_set_large_rmappable() set.
> 
> e) undo_compound_page(). No words.
> 
> 
> 
> *maybe* it would be a little less bad if you would just allocate a compound page
> in your driver and use page_rmappable_folio() in there.
> 
> That wouldn't change a) or b), though.
> 
> 
>>
>> Given the problem statement in the cover-letter, would there be a
>> better direction to take here? We could, for example, bypass shmem and
>> insert the folios directly into the swap-cache, (although there is an
>> issue with the swap-cache when the number of swap_entries are close to
>> being depleted).
> 
> Good question.
> We'd have to keep swapoff and all of that working. For example, in
> try_to_unuse(), we special-case shmem_unuse() to handle non-anonymous pages.
> 
> But then, the whole swapcache operates on folios ... so I am not sure if there
> is a lot to be won by re-implementing what shmem already does?
> 


