Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7A5C2606A339
	for <linux-mm@archiver.kernel.org>; Fri, 20 Nov 2026 00:55:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=LsnZPUHa
Received: by kanga.kvack.org (Postfix)
	id 323DF6B06CA; Thu, 19 Nov 2026 19:55:48 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 286206B06EA; Thu, 19 Nov 2026 19:55:48 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 127CC6B0723; Thu, 19 Nov 2026 19:55:48 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C8B2E6B06CA
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 19:55:47 -0500 (EST)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 15E5080D26
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 00:55:47 +0000 (UTC)
X-FDA: 85453679934.01.7E137BB
Received: from SN4PR0501CU005.outbound.protection.outlook.com (mail-southcentralusazon11011025.outbound.protection.outlook.com [40.93.194.25])
	by imf21.hostedemail.com (Postfix) with ESMTP id 1C3341C0002
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 00:55:43 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=nvidia.com header.s=selector2 header.b=LsnZPUHa;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf21.hostedemail.com: domain of jhubbard@nvidia.com designates 40.93.194.25 as permitted sender) smtp.mailfrom=jhubbard@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1795136144;
	b=vgWtYjNhMjzblqjCqsYcnBgT9y6q8vkz8mBsiKvJjMb1mzm2JzuQssQ0upjUvlccqzDbYl
	28wUlJ6yYtgi/HZ5TnJlePGupmF+pCR7awf7T1HCpjelMNJFtiw/qpx4biz9/lfQVYSv5u
	/QaqoLdfXr6Vx8BOOwJOwOIq9j/9ZXg=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795136144;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TNeToXTSWuC2G6wbkcxOdRUaeXtvpYO5/35YT38Wyrg=;
	b=XcI2vcCZ6OlHyJw19pKJkA3gm3+lB1Il7Hax+w1nfBhG4iG3KDQKN9hXzjsy8hI/vKvb8b
	fhqLuZX5z3nsdzQdVH4hIgYAFkzuSvoGE7dlCpf9+RyW/oXv+bcw0RRRHGkwIrRZgOtvys
	ufsB2PN3n0ZcJXDN7ro22GdLBpUTsE8=
ARC-Authentication-Results: i=2;
	imf21.hostedemail.com;
	dkim=pass header.d=nvidia.com header.s=selector2 header.b=LsnZPUHa;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf21.hostedemail.com: domain of jhubbard@nvidia.com designates 40.93.194.25 as permitted sender) smtp.mailfrom=jhubbard@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Qrjryl5KStWLRWLPJ9/oViIldA6lVO9AYNmAYErXxNxrIQiTMJy17Hj2Xun6BWxcFhPj6VV+TNK06WtFlSyqYWoY2YFFzt89pcX0KntrQFcrySen8XJid0dMTz2IbAH1p7VjIwQQr+pnUL5D7iGinTu12ye59ZpHUjBsdmI9wxB1CDPVvIQx1sWDBazK7l3wQokBPU4nwCUOq9GCxJ4Uf1W0uZUZZl9OQdxYraQnvKjV+qTKz3okcQXq91IqXrQ0nywGcbWGbcg0M36I3Gz7FFvnOSkGd3FPEpBi9h/LivCln52aK2VFK91GQKDHd1PBqX/oUS2EzFdp0eRliHS4jA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TNeToXTSWuC2G6wbkcxOdRUaeXtvpYO5/35YT38Wyrg=;
 b=wbtcfYB6EVgbO9fSEfFDu+DhdIXuIAoZ2pbAFA5wkxKzHIYTN76T258bjS0b2uzHahDNap0yAEq6YXFewlk3nUUvN6GfPhDVVSX4eStA2XWJSXTeJATUrIfwCEVK5Wf3YLvtFbBbFIOtFPl6LNy0ntyvP5+AcuAe01xARJ+nuaR2GeZTylmoQYajQotyDwxjUAS5axg2IHBNM5RFUWKByFrmRO3M6MNmbh5pIfzN91GIjcPI5kbnDMXTa91ah24VwkFHY+A+HXrYs/iJXGQyeYfMaIlGH5ElFINiu3UZ2NBtXZVtM6qMqHgxZUjoXsbEf/FG38UhCenOl9WYzn8VYQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TNeToXTSWuC2G6wbkcxOdRUaeXtvpYO5/35YT38Wyrg=;
 b=LsnZPUHaUs3KobCL3GO5Q1ps44jvF1vk3tqgMu7BQDCI3tyePhQz+CBFqc0ILbIhm3C4riyqgbiXld/p/5Pg1KfU3zOkDmBFP6M8JbzZqUTZkYKiTq0Dy6Sr+fm68hf5rpAgWwkEmfWnLrnfkMCG48FhavZO3YZmJpmeCFuoctFqlkX1W24UrFQ1ESIKlsKb9Rg76LmpQO3D9gG6jAOjn2C6SR1LD75QZW6/O5MFaUjb+LvSUQ75JLCImb+RLdAiXY1rWmz16x8aFEI9kdwlm6vrbAiFzwjDu0H3Kqg1rKFYPb7a9XpIgmOn1jFw8gyIAVRAzY6VIfiS6y8PFlc6Tg==
Received: from SA1PR12MB5614.namprd12.prod.outlook.com (2603:10b6:806:228::7)
 by CH9PR12MB384484.namprd12.prod.outlook.com (2603:10b6:610:310::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.639.10; Fri, 20 Nov
 2026 00:55:33 +0000
Received: from SA1PR12MB5614.namprd12.prod.outlook.com
 ([fe80::1a0c:e9e8:f3a5:d9d6]) by SA1PR12MB5614.namprd12.prod.outlook.com
 ([fe80::1a0c:e9e8:f3a5:d9d6%6]) with mapi id 15.21.0615.013; Fri, 20 Nov 2026
 00:55:33 +0000
Message-ID: <4f096d70-6f94-4148-8f47-242b8551e5f9@nvidia.com>
Date: Thu, 19 Nov 2026 16:55:30 -0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC 0/5] mm: GUP dirty + ->release_folio() fixes
To: Pedro Falcato <pfalcato@suse.de>, David Hildenbrand <david@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>, Zi Yan <ziy@nvidia.com>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>,
 Lorenzo Stoakes <ljs@kernel.org>, Peter Xu <peterx@redhat.com>,
 Johannes Weiner <hannes@cmpxchg.org>
Cc: linux-ext4@vger.kernel.org, linux-nfs@vger.kernel.org,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
 Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
 Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>,
 Kiryl Shutsemau <kas@kernel.org>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Kairui Song <kasong@tencent.com>,
 Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>,
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>,
 Wei Xu <weixugc@google.com>, Baoquan He <baoquan.he@linux.dev>,
 Michal Hocko <mhocko@kernel.org>, linux-fsdevel@vger.kernel.org,
 stable@vger.kernel.org
References: <20261119-gup-dirty-what-v1-0-236d69f25c24@suse.de>
Content-Language: en-US
From: John Hubbard <jhubbard@nvidia.com>
In-Reply-To: <20261119-gup-dirty-what-v1-0-236d69f25c24@suse.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BY3PR04CA0021.namprd04.prod.outlook.com
 (2603:10b6:a03:217::26) To SA1PR12MB5614.namprd12.prod.outlook.com
 (2603:10b6:806:228::7)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR12MB5614:EE_|CH9PR12MB384484:EE_
X-MS-Office365-Filtering-Correlation-Id: fe8841e3-2829-4207-5f38-08df46a0fae2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|1800799024|366016|23010399003|10067099003|261022075727099003|261026121527099003|261026140227099003|56012099006|11063799006|261022105027099003|261009223027099003|261021123027099003|261021121427099003|261022113327099003|261102123227099003|261028144727099003|18002099003|22082099003|6133799003;
X-Microsoft-Antispam-Message-Info:
	CPbWQasccBrchxMYh1cf/xMSAk4D3F7pzwVa/gaU7aHNbFlZhT5bf290jQTHdXfl5J35BIhvLMN7GaIRfKRfrS380htSwctScYhR1JidHTnO0c8jQfE6O1eJFIps5lcZ7nhEZzneHtykwRd/gjTbG5XyNcjbDobjKrrxdnN5a9AedEExitEdV0i+mpCmtE1fZ7I2NReb0JciazV/SLfhQcy78y3EW3+37SMMZOJC9gZA/8mr6qz+jocB7PSP9Dp6SIzYfG1q5qr/skeDy8DQzQpuIxy7NRx6Ni1EoFNu2ou4fUyb71lVRMWAMFQOH2QpXgkTmCNpapnQK9S2fuxNWDn62Ylg6UQBOKxfPQdvKHDyc4DENDORnROGGdKUYMNF4U8lmQ20wqUbZfZKVDaYnAfW+W57o5JNOuZfCLrKXLFqJxRe9azqeZtC9R5gMGy1NawKBd2tJYHxMn1FfneDE9wJnSu7D4QynY7GdmlGM+Plkw3bV2VkRJnAplYjuhmkeUQximXFSGcTe1qYbf/vMz+BGBgGkitceLtYDD8dtgFZ7JYGD07XjVleznrSiZllYdW3h24CWwf05ccamghNwtzupkPNrNygr0o92u7hMlW0Z+KffwJhOlbhHW6m0JPcuTjnyXKuJC3OY81ndCCavEvr1FVl9dbGoW+MHukNkpM=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR12MB5614.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016)(23010399003)(10067099003)(261022075727099003)(261026121527099003)(261026140227099003)(56012099006)(11063799006)(261022105027099003)(261009223027099003)(261021123027099003)(261021121427099003)(261022113327099003)(261102123227099003)(261028144727099003)(18002099003)(22082099003)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?b3ZKakFvTjE1MVhKQ3c1SlUvNzc3SXlJRXNjVTZ2Q3A3R25tdzVkMjJEN3BV?=
 =?utf-8?B?ZkZwVG92S0x6VEx2aG8xaVBoRjFqSFNReEhESmk4bkl6OWJEejJqcDZ3SWFn?=
 =?utf-8?B?Y2NFZDlyUDZhR1hlS2RWRmlqMDVtM0ZiUFpDZXFQNUR6Q0hlUTR1UFRYK0dj?=
 =?utf-8?B?WGI1Ylc5Wkw5MzlleGhpWUJ2MVV2NWlEZ2FhSEJyMEh0WC9odlhBdVpEZmxY?=
 =?utf-8?B?UnVaZE01NUhxVUd2SHZDMTVTMDJmTGRGQlVMTUs4THlqRjQrL21DWVlETnV5?=
 =?utf-8?B?eHZ5SmVtcVBDcTF2L1MzbURPczJWVTVYWFRUNEM3Y3dRSE5Bb1dEdU9CSE41?=
 =?utf-8?B?ekFwdk1zNURlL08rOFgwUkU4dEQ1bUYyRGhpRnJESktjSlVINTRsTG8wWHl2?=
 =?utf-8?B?NFB5RDVCU1FlZkFsQjROSXVMTFRvcnluaTQ0K3VhTUFyZnZiZXNNeFl2dTJs?=
 =?utf-8?B?ZTRUVmVIbmFSUGJ6V0MvZzU1N3k3V3htZi92SUM2emIvMnlDcnE5T3NmbFh0?=
 =?utf-8?B?RkxxVnFPWXJZVE1zMjdzMTUrK1dXOTlJWEVYNUNNais4b0VIT2FndmtPNmhw?=
 =?utf-8?B?b2t4MnNsT0EvUGJpOENpM0RyR2VQUy91bHlMcThYcVN1YnpHWXdKUXBxRjBq?=
 =?utf-8?B?L21tWjI2VG8zbHhZTGpJTnhQSnBqMWdRZ2lPcUZXODQ2NjV1eXNVWlpEMlc5?=
 =?utf-8?B?d2hiRXhFVlM4SHZFRDVsazVzUTlQU2hFbWN4TXpzZnA5aThFaEI2ek9UVGZU?=
 =?utf-8?B?T1hsbStrWlVNR3Q5aGZsZlJodENwdDAzZjVlZ1JaKzFkNEdxRDhtL3l3S2tp?=
 =?utf-8?B?cnVjQitDUnZHWmFLYVE3d1dxbGNNelkvRUY2UmNqVzRyRG5rNGYvTi9FYmdm?=
 =?utf-8?B?M1NTV2ZDNmV1Zlp0VkM4ajJDWkpNdWV5SE9INkI1Z1N2aGQ0aFZjSDdqeTlz?=
 =?utf-8?B?WFFzZnpwc1p2VTE0Q1JGL2dockhRQ3B2dGpWQnhaamlWS09FVDF6b3l1K1lm?=
 =?utf-8?B?amY3R2lnYWJNeEk5eXQxcnJJYmVWUWhTaEc1TUxMSmI0LzJYdkloSG9lZVJF?=
 =?utf-8?B?U3JiOVBBMDNSNDVJLzYvLzY3L0tnUG5Xcm01THFtSjZJRzhHdEZhVEovQ3hV?=
 =?utf-8?B?T3doeVE5cVNpWkRBOHhIUFlEOWs3cmhYRU1CYWNjdnEyUHB5OXd1MVdpOW51?=
 =?utf-8?B?Mjl6eVBBdkMvMVl4L3RXcEtObS8veUt5UGwycG1rWkIrWmNqWnhmSkhRUXVa?=
 =?utf-8?B?blJ0Ui9JNzVhcXhkeml5c01tNjBsRHozVkJPakFDNWdaZFJ3Mmtkd1FUMjN0?=
 =?utf-8?B?T1lNQ1RjbzVBU241dlJoR0QydS9QYU1JMzJnUndvSWpRL1VsVXc2cHBDc0th?=
 =?utf-8?B?RHFkbVluVjJFNXVlMTZPVU1haWhuYWNTQm5CakJGdmcwaWFRcFVCQVlkS2p3?=
 =?utf-8?B?SnZBQ1RCV2F4cTVXSkFJekxBc0xxNlBUM2ovNDhUdlZGT3dIeXZ2TU1ySmtR?=
 =?utf-8?B?Tldkazd5NDVvVkR3QmhqUGZ4Z2xPaFE0QzFTczNZZTZ5Y00rL3kwZVpOdmQ0?=
 =?utf-8?B?cXU2aVh6SHk5R041eFNKbnJld081eUhOUlpmcUo2WlE0ZitBUGxoZzc0NnZH?=
 =?utf-8?B?ZHBOQjVvT3lHVjFadk1GQ3pTeWIzckMxR0hseVRibDJHTWVwMmRkeXNWTlhS?=
 =?utf-8?B?TzQva3dHZllhcjBDUlBLTldudnhKSGlzdTluVXVKRDVTTkVJT3Fxbm5mWEVt?=
 =?utf-8?B?NjVYa0QrcVBNMjUzWHd6UnpnSC93aDUxWWI4T2ZSYis2bVhWanlwakROdXpK?=
 =?utf-8?B?VjE1ak1YWEtmYTdNZnJNb0tMamRaRW5xV0hxWHF4cmRwM2hRVExpalJzaXp4?=
 =?utf-8?B?S2ZQYWkxcHFQdWpZTG9jSTZ6azhyT0UyREc4VGYzVDJHcWRORVQ0NVI0N3pw?=
 =?utf-8?B?d3h5bDNTT0JiaGp3QWJ1QzJDcFBQcTFzK0V1SmZURnhMSC9BdkU4aDRERHIz?=
 =?utf-8?B?R0dhMjZESVRNQXU2dGNZTEN6Y1M1U1pRcjRHRlZQK0JMRVZqb3c1MlVQZDdN?=
 =?utf-8?B?dktGMk56MXNDL2lnaUdOV2dRTlUyNnlKOWV2MzBldHRIYlJMQkx4TDlLbnRo?=
 =?utf-8?B?cWs2R05NOWU4ay9hUE9yYjY4eDBXVjB6UjF1RFlXWGdvb28zMmNWb1JZYWdw?=
 =?utf-8?B?c3h5Z2xrZWlUczJXTkJ3M1lPKzgxdERsNU5jMXFmOFlNZkROUW41YnNxZG1E?=
 =?utf-8?B?ejhOYjFhUVYxTVZzczhVZktlVGpRdHpZUlIrRzQyeXpvKzN3T2F6Qk91SWN4?=
 =?utf-8?B?QmxuMlcwb01ac01rS09VQVM3NnV4S1dURDRPd3hRWHdybmJUTlUxZz09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fe8841e3-2829-4207-5f38-08df46a0fae2
X-MS-Exchange-CrossTenant-AuthSource: SA1PR12MB5614.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Nov 2026 00:55:33.0533
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Y8lCQtVuHezOjOfaGxGFi46rKEKdWvCZPJwCkq2Mm7FQe8NWrC4Z1baCp9fLpfM8fEbxfvKjhFUJrQ3LbG1iNw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH9PR12MB384484
X-Rspam-User:
X-Stat-Signature: 3d86aa4fps6rnqic7gs41d46du1rfjrq
X-Rspamd-Queue-Id: 1C3341C0002
X-Rspamd-Server: rspam12
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-HE-Tag: 1795136143-503025
X-HE-Meta: U2FsdGVkX1/j0Az5LkrqiLE/7RO0bYrAjHMOAO87u9AgIkFEpjlSZU6gxu2atXEw5wtno8wCHFXut7X32qmU+RTC5m0grqI1FGm5CE110m3cvt6ZT8P0czpgGkv6uvB6Sd1o1EgGwFFeRBHpss9GxTN+xNij4bTRhiz6dI8e+FAb0dKjKJfoTLABSkD648pGUO2ezX3ptvQp+bTk+4Glep8Qa3iTz6ZZG63Bi/OQl+pgGr0S1PafZVKdS/gjXNZ1lWJuc+7/W/ucxUKmKwAI5tME1G2UMLGoJpefgGKHwaMUqlTtZns3D5lGT87gN5BjGf8OuowSSDq7hwu5L2cLp5R14kJ1IWSmaK1nkmM1oGCdp0RsT37Vwvu65HWjaXmeEPIr0TaWeQuRVqiupfoyPsQYhSeJ2exJEy0+QBPsQblnyqovlfAVni+ATL3j5/Wka/AksR9XGAnuGIkELVhIbEUDQp4ZEUj9kNYm4lkAHndafv4eSQyS3eA240Aiw0XXn+7nLou/U/Pgw1vko+zl3cPzZjhV/cSv5yjM/ueA0Qtnzdfce6MrQ/55s9ScVyKDvNVqdGvUAdpdE8mcamqd+elM+FS4Yx0IYMJH1nIzT6k8fdcykfR/cTAnIUn/Y+ZpnKLTXuFssSjBARXp0kYn1r2MvW8hBI0ylsKp+xmGQQml28ifPpqvGXo6jL9fvmY8INBflEGiYskmF/nqy/u8QxTEW5+Oa0p+X/heJgyBZUw9jvw9R891x6XxSLG+Te93zmOZgL9VAsKHmCqDKhlEehRusAKqb+ooPuOJGkDZxWk3qTdMNJGCR7P69aRc4KywrRWTsi6WSoRIdZsqXLhU9ivtQCO2ElGHKjYluSl8doytrywAYeQrKerOT38rTDmIqWcOWxUKLPSsSiAEhqj0RNOoknOPjLkYKrc/Blr7mGkC17vYPfLzstcrm090TH8oM/hvnhyMlwlWXekTmyR
 5zRvlG4i
 UlRQmdILSnJ7lQ/UoqGBkZhqpN6x0hB9gvBP/vdn2jlDqcOEckbTfe8K1Th4YOR20idypp/Un7ZEBd7n2ilDzS7nNarnQQ3LiOPXj0ERzQCOZPB7SkuIgVWEjNAZ1MhqmDYQ2ljecTSDyn6t/GTXcb+e7IErKJCigvQat/ytMFSZ2gjgJO4NqIzJdSWxPvgiPMiZTwQ+N/4K/HUKIrS2bVVx8ZOMG5uaixV4TiJYlmAFPR/kEpBNSJPBJuYvx94VVtPQr8CjHv5Db5Vqre2biFFJ5Spx4jjhFhnxBouP5Q0+Lgni2IsHu3gQDFz0HhZ5LmzI4ZVUrmj2dnIJj2H6vRyvH5uZUBGiajQ/Bu/aLUbsxtX/oCezjxKPabx518IwaJ7P6V6Y9cBVXKNRY6vxlcBXboQutig7RchLXpEfli7nfU/PUg8Ci1VptgteuG2yyhOK3ATtBZUhJAxzbB+pZ28QfVngZlk93QLL4fndn7mvCS2sGBvpeUWBRJzfdIseGilvMux9kF7XM0CC6lO9QR9tdX7d2S6hgb5UgQPahymZ1tzs/zz1XArPl6zOkh9ua16maEKtKNyHmR4HCHFVDah97Xo7XokzAMHZmrVgVD+fHYteqZN1KMUmgYP4dgEaUKW+FO1jIO/J22RkJKlvp9GFZSq7ZDiiTDBEfM7maYNjnJSKt63nxowJ55P1n2txkTeOHiCP8/SOVOv+uN3Sjt1XqSa8DumIFraTqMrQvfFImocJoVvTmPRSErxljFASqRbFvdSdFIsnErtsGlw5PH2Snuj59WpCHgBN4OH/j8h7vkgdzSXrAsxJNi3ZrOPOm53fh
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/19/26 12:10 PM, Pedro Falcato wrote:
> Sooo.... It turns out GUP dirty and ->release_folio() interact really
> weirdly. This was initially reported by some AI agent, and David let me
> know.
> 
> The basic issue is:

The basic issue is covered in a series of LWN articles that span 5 or
6 years:

    https://lwn.net/Kernel/Index/#Memory_management-get_user_pages

Probably good to read and absorb that. There's a lot.

The problem remains not fully solved. pin_user_pages() is a building
block, but we need to fully coordinate with filesystems in order to
finish. It's good that you are looking at this.

>  - ->dirty_folio() relies on buffers/IFS/etc being attached to the
>    folios. It _cannot_ attach them itself, as dirty_folio() cannot
>    block.
>  - certain MM paths (reclaim, khugepaged, folio split, etc) are very
>    trigger-happy when it comes to asking filesystems to release them. In
>    most cases, barring any dirty folios, buffers, it will just drop
>    them.
>  - there is no problem in usual IO submission, but issues start to pop
>    up with GUP, where the code flow (roughly) becomes:
>         [get_user_pages(), etc]
>            ->page_mkwrite() called here, or before
>              ->private correctly populated with whatever the filesystem
>                expects.
>              folio is marked as dirty, initially.
>        *write finishes*
>        folio_lock();
>        folio_mark_dirty();
>          ->dirty_folio()
>               dirty_folio expects ->private to be populated by
>               ->page_mkwrite(), ->write_begin().
>        folio_unlock();
> 
> What happens if any filemap_release_folio() runs (and succeeds) between
> the initial dirtying (plus eventually writeback) and the write to the
> folio completes? Welp, it's unpredictable. ext4 for example will
> WARN_ONCE, and likely drop data (see ext4_dirty_folio()).
> 
> So, what can we do about it? It's complicated, hence why this is an RFC.
> For the possible solutions:
>  - ->dirty_folio() attaching this FS information itself is not really
>    possible in many cases. ->dirty_folio() can't block, nor is it even
>    guaranteed to hold the folio lock while being called.
>  - Can pincount help? Kind of. Things like folio_maybe_dma_pinned() are
>    rough, and don't deal with the usage of get_user_pages(FOLL_WRITE).
>    pincount itself isn't available in the common order-0 case, and not
>    available on order-1 as well on 32-bit, but who cares about that^W^W^W^W^W
>  - Could get_user_pages() ban FOLL_WRITE? Mayhaps. I would not be
>    opposed to that, but that's probably a larger change than ideal for stable,
>    and I'm not familiar enough with GUP requirements to decide to go that way.
>    This would require migrating all FOLL_WRITE users to
>    pin_user_pages().
>  - Can the whole system be reworked? Probably, but not for stable.
> 
> This patch series is really rough but kind-of works. Instead of using
> folio_maybe_dma_pinned(), which only interacts with pin_user_pages(), I

pin_user_pages() was specifically introduced for this exact class of
problem. get_user_pages() is now meant for other, much more limited cases.
I've attempted to document that, here:

    https://docs.kernel.org/core-api/pin_user_pages.html

> introduce a new helper that helps places deal with the folio refcount
> directly. In that case, we can also deal with GUP. On the other end,
> moar problems:
>  - NFS private data itself takes refs on folios. Now private data (that
>    we could perhaps release if only we tried) is keeping us from
>    releasing that same data. What?
>  - ext4 data=journal has some funky usage of buffer_heads. Data journalled
>    filesystems will not, in any way, dirty BHs. Instead it will,
>    *only if it was DMA pinned*, set the checked flag. ext4 skips
>    dropping those buffers if the checked flag is set.
>  - ext4 move_extents seems to have suspicious usage of
>    filemap_release_folio() as well.
> 
> Many of these have suspicious Fixes: (which are definitely wrong). I
> targeted these patches to complement Jan's original fix. Anything before
> that (or which is missing that patch) is hopelessly broken anyway.
> Proper Fixes: can be added, but many of them go back quite far.
> 
> Signed-off-by: Pedro Falcato <pfalcato@suse.de>
> ---
> Pedro Falcato (5):
>       mm/khugepaged: fix filemap_release_folio() interaction with GUP dirty
>       mm/huge_memory: fix filemap_release_folio() interaction with GUP dirty
>       mm/vmscan: avoid releasing FS metadata for !FOLL_PIN gup folios
>       mm/vmscan: be more careful when releasing FS metadata if buffer_heads_over_limit
>       mm/filemap: refuse releasing maybe_dma_pinned folios
> 
>  mm/filemap.c     |  3 +++
>  mm/huge_memory.c | 22 +++++++++++-----------
>  mm/internal.h    | 48 ++++++++++++++++++++++++++++++++++++++++++++++++
>  mm/khugepaged.c  | 19 +++++++++++++------
>  mm/vmscan.c      | 18 ++++++------------
>  5 files changed, 81 insertions(+), 29 deletions(-)
> ---
> base-commit: 9663aa0da7070d958e333477ce0720512e9fa016
> change-id: 20261116-gup-dirty-what-b73da748f5d1

A git alias to wrap "git format-patch" with a sed(1) invocation is a great way
to avoid accidentally "leaking" gerrit change-id's into a posting, fwiw.


thanks,
-- 
John Hubbard


