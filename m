Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ADC4EC79F82
	for <linux-mm@archiver.kernel.org>; Wed,  9 Sep 2026 02:16:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 802FC6B0092; Tue,  8 Sep 2026 22:16:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7B31C6B0093; Tue,  8 Sep 2026 22:16:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 67B5D6B0095; Tue,  8 Sep 2026 22:16:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3EA696B0092
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 22:16:46 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 260F9807B3
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 02:16:40 +0000 (UTC)
X-FDA: 85192610160.19.69A7F63
Received: from CY7PR03CU001.outbound.protection.outlook.com (mail-westcentralusazon11010032.outbound.protection.outlook.com [40.93.198.32])
	by imf10.hostedemail.com (Postfix) with ESMTP id 3ED56C0002
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 02:16:37 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=IfVIkBGe;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf10.hostedemail.com: domain of ziy@nvidia.com designates 40.93.198.32 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1788920197;
	b=zU5xxu33LjyQmRiF7gIJdl7lBMGoYWxYKf2yBlupP5HqLzhCI0zC3GomqkczaDk0afqcXl
	r8chUohFhspVNz2JB2ETrh+4nu7wZNZCHXLeebUoBbMNRkqsgjz/Cst/JCARRPu2vswp//
	zlljuOq9d+vrMQQ9qz46EDwZFwTU0AA=
ARC-Authentication-Results: i=2;
	imf10.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=IfVIkBGe;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf10.hostedemail.com: domain of ziy@nvidia.com designates 40.93.198.32 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788920197;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bQBf6q+XKtz82AzeK39RAYG0K9DZmCdUs2hXreU/WoA=;
	b=p56EHUWiJjrltL39RJiy3/djhsR6b/nfaB5Sr4fc2jhgj8ppggdr4GoxZHFInYBibkgE58
	FAPtEvBSwPbYAV/aBWbTLv8SUl47vFDNY2NHhWXRQKkLDCKfpKdAeQOXxrFE9ZkbfCrNUa
	+JxSFR+KkaylNH5NRSa1QjLe9BSjvJM=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Ck/Pv446+xi4iALbe8RLlQaYWC22JesFji+oMdr+jgzgdXP5W6mLwvABZl34LrGCnDnw13lMBlgp2raYtmLEEkuyrpM6mq9AB5k2IYUVJtSpSw/O8scU4IEpSyh/xdINdbOwQC1S2GPYtLdnZpjZCVP7htbLQ4g9Rshm0d6bZ/mDwL2D8/TegueJxMdJ0RVz1QdRBH/GKShWNXjnuibpuq8XcMG3B28MLmssfAwByQlpsrDMnWFeHbr4pVuTzjWX3MCcOTZQ5IdtttErRa6puGLtciLIjGNl0Fhi89HVV8F4wx9U1uXiv8OJR48GHkDY8fX1QIo1YAAesyN5pMKfTA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bQBf6q+XKtz82AzeK39RAYG0K9DZmCdUs2hXreU/WoA=;
 b=Bxwi9QFTq9Yf30ZUtfg5T6W2oDm3F8UX9+mYirHWqOMY7FSCD9LjkuUg7VIKAkZwtaxmkxZc7X7BKns6BpfYN/hKMZu/40Q45Wj9hP6I0TXUGuySaORE0sWKVf5mZwEhds7tX4Yu40K3hyr+uuUA6D89hT3bzreUkOR57Egh1yTpSd2sJy48MS6cBPw8p9W3tcXDQjd3u0TNzhxKt6JwtBWE1pNA2SeWyhhoYEukJktptA0ekw4UkQPb/MwyPp58kUCAmrSDZRXeBf9p2rXA7UdkglRWnV/aB3JzVZKFTPLrnXA9T2OCEFx/QL7KJfFtkmXducgy3WYen5PVbWiZgQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bQBf6q+XKtz82AzeK39RAYG0K9DZmCdUs2hXreU/WoA=;
 b=IfVIkBGeISXhZRlwNPTCqdX6ng6XAiQdILK1tDD2bPEIbxYx9a5DcItrqPtrkO3eAtdY6xXYZeC9EEjAXwBsnqMuGYZzI08xXvGzysdVigOyddisgsJ4vIRQpcRspP9s5onujfT6ynfWUOWwNmW9CEZwCqFLhLGNzc9nV7QSb6/fYf16jqq/RRS+2yxd496ynh+5Cc+briOJYrwekd15ou+xLQSmw7Uebh/1VcB0J0PHcwhwMyhiMOnj2rxBcAxWTlXO3vBdxILdvxBJn/AWNRUeiaigGqBEYFf5ET2sePw5O3NqfLp5lNqhSR5EskaFK1Olwliq1h0Wb4TvyaEUJA==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by CH1PPF4CBE7339A.namprd12.prod.outlook.com (2603:10b6:61f:fc00::60e) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.406.6; Wed, 9 Sep 2026
 02:16:30 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%5]) with mapi id 15.21.0406.005; Wed, 9 Sep 2026
 02:16:30 +0000
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Tue, 08 Sep 2026 22:16:29 -0400
Message-Id: <DLAFA5J0PEF4.147CJ8RMCNAFY@nvidia.com>
From: "Zi Yan" <ziy@nvidia.com>
Subject: Re: [RFC PATCH 0/3] mm/vmscan: adaptive multi-threaded kswapd for
 NUMA-aware reclaim
Cc: "Buddy Lumpkin" <buddy.lumpkin@oracle.com>, "Andrew Morton"
 <akpm@linux-foundation.org>, "Kairui Song" <kasong@tencent.com>, "Qi Zheng"
 <qi.zheng@linux.dev>, "Shakeel Butt" <shakeel.butt@linux.dev>, "Barry Song"
 <baohua@kernel.org>, "Axel Rasmussen" <axelrasmussen@google.com>, "Yuanchu
 Xie" <yuanchu@google.com>, "Wei Xu" <weixugc@google.com>, "David
 Hildenbrand" <david@kernel.org>, "Lorenzo Stoakes" <ljs@kernel.org>, "Liam
 R. Howlett" <liam@infradead.org>, "Vlastimil Babka" <vbabka@kernel.org>,
 "Mike Rapoport" <rppt@kernel.org>, "Suren Baghdasaryan"
 <surenb@google.com>, "Michal Hocko" <mhocko@suse.com>, "Brendan Jackman"
 <jackmanb@google.com>, "Johannes Weiner" <hannes@cmpxchg.org>
To: "Ehab Ababneh" <ehab.ababneh@intel.com>, <linux-mm@kvack.org>,
 <linux-kernel@vger.kernel.org>
X-Mailer: aerc 0.22.0
References: <20260908221059.14777-1-ehab.ababneh@intel.com>
In-Reply-To: <20260908221059.14777-1-ehab.ababneh@intel.com>
X-ClientProxiedBy: MN0P222CA0023.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:208:531::27) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|CH1PPF4CBE7339A:EE_
X-MS-Office365-Filtering-Correlation-Id: 89594ed3-d77a-4c1c-4f7e-08df0e185c66
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|376014|23010399003|7416014|1800799024|6133799003|22082099003|18002099003|56012099006|11063799006|10067099003;
X-Microsoft-Antispam-Message-Info:
	ODmcvPkIcIfQzSfbQFTvbEQI2/zKozaeGTKk4LpE3V9Mz9vLrfR5mAifRjUTgAzf1OsMIPmb0R2fYKSBC2yuV9AwmgZTwJdev+AxxM6MXxc8qHWE0WO5vbowxFbD74S7K3eQD7rOpi/LgvWfrObdhHVcFbr0ezoqi94M5Q7iq+AsQW0hpzjAQWzaWSXmFWsbr4NIs2P+YpToLGLLp3otFTHiubEWWZXSqDWpcyZrvb4HgHqjFcvVgHxAdVlpMEa+P9r0An9zMI3gu0OC7mUrqBMuj7piiMMYEwauPhhBlY+orE8rz92hQZ0KdoxJ5aeCy1n8PSlMgd3kMHhtzKGvjK5gHcO1IpUd+77+dl7H4gFA0Qeuce7Ld0Euf3/fwOHEeT+eILeFQPxoTDw5M8Dg8oTOvOLIdSFDdlv2QJGjmO8IupLrCaHplcnZV8lwUcH/Nf3OA4pSj/etY9siXWQv1IeYL03J1xsT7WU8VwQSXQJs30KkxJ9y6MCo6C/fe7yhdkYIH+8Wn8lOM+7Sv8iHUC/EiPwpPaJ0wZbfI8rLYZoq0grsX9YxvY35i2sF7D+c9I2Dk7u/70+4cNDcrl0sSVHvQKu3JmoIu2aIlppQt6XUbTbyg/AYlmc4QiO2lxTkhAiWdaNVJKGJaAdkptO/R17AWSZdIa6W7HPBd2GTs5o=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(23010399003)(7416014)(1800799024)(6133799003)(22082099003)(18002099003)(56012099006)(11063799006)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?ekY2ay9NaGNoRlRrcnJrNi9NUFhOUnpvQ3Q1MEJUbU52anc3OEdxUnJVeGdQ?=
 =?utf-8?B?UUF1N1ZHZXJqUExmc0xTTG8yTXR2V0pGdFc4Z0VvU0QyT1JXL09kSlZJWmNu?=
 =?utf-8?B?REtBS1E1RDNwREZzNFYwR1N6eDdrQ0RXMXN4YW5zMzlXSXBUOVZlNjBWd2h1?=
 =?utf-8?B?KzNGb0VQSG9Sa3lFNFZJOFhQbEx3OGlOSEdiMGN1UGZqaXB6U2gxR0NPK2Nl?=
 =?utf-8?B?RzNVUnZBRWR3SGh5emxRV3Vsa21aZ2dVdW9RYXplZEJNbVlLZkJTcXZSdnpT?=
 =?utf-8?B?NGNXTmVSMFk3V3BYQWsyVXNsNVhhenkvUXhrRER4eHphei9QZzMxZnM3dkFl?=
 =?utf-8?B?RmRzcWFZclpMNlk2SWZ2ZzM2dmoyUzlla3B4MW5aU1JhSDhtclA0WlZpcWt5?=
 =?utf-8?B?aEFYd1Nka3d4b0UrNGlkRmRNcnF1ZnUrNUVsV3NNZDJHZDNvRm82YmJiSkxO?=
 =?utf-8?B?V1pMTFhUQ3daU0k4MVVFRmZYRXRhQ2xNNWJndXg4T2VKYTBxMFVNVWR1dmdp?=
 =?utf-8?B?UUJrcThDT1FLZUJoNEpuSnNBSzRTUmI0MnRxb1d1VkFHdFNFa202S3hIVWx6?=
 =?utf-8?B?SGtUY1RMdDQrUUlDUytBNE9ibmMwWmk2ZGhQMEdrYVE2QTR2d3JYNGJlYWlr?=
 =?utf-8?B?ek4xbjV5ZVMxc05mVGQzMjk4WHBQNzJZZ2VTNFpGb1JTd1NBNTdtcW5lZVZB?=
 =?utf-8?B?cytBc2RIK3ZFTzFLdjAxQnFIdUZqL2NJVmpaeDV0SStlOG5Wbmg1aXpsb1U1?=
 =?utf-8?B?MUNzNVZxdkQwMkdQSTVqMVlqZURRWjkvdExtaDNZZDBRSGFlaDVPNy9tWFJu?=
 =?utf-8?B?TU9GU203TGtkbE50azJqY1ZYQnJPL2VxZjlrejIySkxyaXdLYlpXVnA5WmdI?=
 =?utf-8?B?TU1CaFRGa0hPUzhSV085R1dBZXVaZVF0YVg3NGxVdkd6RC9GbWtFZWFMYVhO?=
 =?utf-8?B?ZFVCT29VazM2ZGNKMlhqcld0bUJDeFZVMWVReW1VUkl3VnJ2OWZaZEdPTlN3?=
 =?utf-8?B?ajQ2UHEyeVRxeENOZlVPbkFTVG15QzhlN2RUZExFRmxaWVBTTGlJUGJDbmZI?=
 =?utf-8?B?SFF1STZ0MTF2ZXJOeitCWVJ2UERrSkswNEpzQ3pSWDljblk1czdPQlFMVHRH?=
 =?utf-8?B?NHJsWTJMWlRjcVBVdVdKeGhYZEFYZitrc3R6SndCK2I5TEdVNm4rOXd2cU8r?=
 =?utf-8?B?SmJoZVE0dW5PbEVmWWsrTndaaTUwNnpmZk5yTHgwYjRSZWwvV3VHRUM1bjVr?=
 =?utf-8?B?RE56VlEycUZpZTUrUWY3MXdLNGhoVW9qcUlaaXFnUnpWT0NHRGVBR0xLa0Zs?=
 =?utf-8?B?VmZJSXBEcjk5cWcxemhTWm1DcWNnb0xZOGpXbmVCNVJKL2ZSQWc1aldRRGc4?=
 =?utf-8?B?dXpmOW1zWXFjdUxGSDRaUE9xZFEyV0RlOWJKOUhsa2ZRWW5SOEZiRDFsOVcw?=
 =?utf-8?B?Sm9UNS84NjNrMkNLMi9UTGhrU25iMU51Z20rL0pEeCttRytXZjZnWCt1YjV3?=
 =?utf-8?B?bHVRcGJCR0g0WEpEa2hkWVZBTXZGYzhrR012eFA5RnF4cFU4NGdMSVFYN2FO?=
 =?utf-8?B?WVFyZWRsQkFnaEM0eUZSeFFNaG5TUHdVOTlzdmYxRUlkcGdSalVsKzVjOEU1?=
 =?utf-8?B?Y2ljN3pTOGxpWmRoRXVYbTlwc0VBbC81MTk5WkkvN3RSUW5OL2E2ZkhOV3RX?=
 =?utf-8?B?N1NONzlLU0VHREtCSG0yNCtJZTJLR3FXMVM2YUpmU3U2N3lkUC9PNkN0eDN1?=
 =?utf-8?B?YjQwbkFqYzk4RmFUUmlNVmU1QTJUOEw2LzF6WEtJVlJDNUhVUktNdWdYWGZX?=
 =?utf-8?B?QTAvTGVXL1NlbzhlMXN0TTJvNm5uYlhxdE45TGR5SDVBVldCYk8yNXhyL2Jp?=
 =?utf-8?B?dkhUQzFoNll3RXRQMlFLUFdQMVNtdDRBNUhtVFlVTmR3OC9yTzJEWEY4VW5p?=
 =?utf-8?B?RDVZazVUVU5VNllhRWVFTDY4K2lPcG9JYTI5NnAyRUJsYmdkM0tCZlA4S3VR?=
 =?utf-8?B?dDhpOWV3Q3ovdmJ3akcycXVRbUhPbU9PYUF3TXJvUTd4ako5a1hZcWQyMEd0?=
 =?utf-8?B?RThtcmhTNTZpaWxTdnpOdDBmemxuNGdlTFo3Uld5aUtxbXpRN1JMY05QU1k5?=
 =?utf-8?B?bkprMVJDemlqWmkvVUV3V0RXWjE1SGZqM1F6QlVlVkUzUGtqRUFPaTFHaC9S?=
 =?utf-8?B?WFpkcy9EYjFQRVR6NGU2NDR6VVBDYXhIK1pMOFI3YmNvT294SVFscDViSEJI?=
 =?utf-8?B?cVgrZFd0V1NBMmJZSWpxaWpyMDlGVGF6RnBnQXdYNlVpK3o1cUVKeE52SFM0?=
 =?utf-8?Q?o1GWs0hv+asnT+lMHd?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 89594ed3-d77a-4c1c-4f7e-08df0e185c66
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Sep 2026 02:16:30.3216
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NLqU04c5sRQSOsetkBDWRXLiKl4hCRyvuGNAudIymtkN8X6iLDqahL2E9o15fpFB
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH1PPF4CBE7339A
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 3ED56C0002
X-Stat-Signature: zrcnkqfcq1ttd3bao9jdqtfpssebexiz
X-HE-Tag: 1788920197-380976
X-HE-Meta: U2FsdGVkX19oskJsKw0CJPV+NOkMHeelNUCPDQeMV0kiBN4NrtLl9MDnKz/aAjcM863ilF1KEyHf5IwiF/9nVZgQyVev8XMY8kAFc6mqc3G76oUGNmhmiU1dJ4P592vZt7pH4VpvfIw7THoHij4mC+blJdPTXp4W+aAkmItGQ52F5VH7YFeA/ASbN9Bbhxn5rfZ+HeNVYGhEdVxorSFkgPBiMd7IPKBoNgM9SYCr37VHjKK/bwAXmaxmq7WvzUKUppv6kX7+67QBN7HYsaSY3PbdIA1hHKFemdmiG0zGG0vJp/dwfhLAXyRWOb7ddx9tA3Wn0dOuQkl2N+MtlWl8lxcY9Kz7U+biuu9N8Hm+8hl7tBRvVAjhpLWASYIDsLvYupHm2FVqJDESv1F1rA7H8YczzfWpZmTMToCidtFRBiwzZqOxtoCn4JkQc//rk7OOsCsdyx+doG2wqmXy4cDNPiDoF3WAHEEjnLwyk3L3OefmqYZ1RDvQXOrERSEV8Q3NuCOx4B19QPIW/Zq6CawlMdklr1CNK3NwXcGM0NjxHJDHjyMe+BC26dHaEWOlH1yPi9yvvctvW88ouOL2+nxR3Sr2R0L1xE7wiE2Jb4jS5Q2yyjvDEw5CrsCMtM7BRj9VwgmZ3vwPTDXUxxZeleMp6RNo68i/Kbx/QFC37pVbhaa+rB82NceSvL8twBBSAJu/Lw9jPobFTM4uTtMFfJcQIbXcmgMTHVZNl2hIuRGJL7wZsjVNNtUUbNIVNzZCD/xPG4u5pAPJJOKq/VFEzV35i6Tfhn6NXBpcdJv3AtZl7ifCBrQqpss4BdXJAn1i9pVJ4C02cm022rljCPj5OaRNIdisM8Z7S8UGCgHdIvVHNR67xNVzYE7+DTRegrRaTecUxJ8RrKvVM0CS7HyGGLZ0KoewjDq8Fb1F3iVzrQif0s5iNV1b+W0CikvvBOhXsYNdtG+OjAFyMrhqrxjnUBt
 AywDk0RE
 28UKR8Kqux10DiCyrCYzE6RS0TZ7vdq/A8/rnbOzvfSxJHitId/jUDwXzutq3c3ElqkBgbaI6HYHua+Khjg3Nul625CyykqQ6M5U13uKS/4E7jPWBt0QnbefsFPiZ66Hweu5wBn5QZtdqryow3A7jHBBalAKzKc8fJSY4y4IQta4eGxkvZxDdnrNZ4S8fNy/e1SMRsjW1HAS71btV8Teb40XTP8U2Z8aI2oQpDfqEqb3Jk+q6Pi2LsCJ4js9JVwH77Ax2XWxvrPEQBYc/KWB8f12diuh1MYaZv4K1Hcqc7yF8KmRQreVSADcpA/bvzftrX2rixpeLFRKSddIf923IZswY3I+3PD3P2t2bEKEGqnd2jeY2h/CRCHl6AmbT5w7w3O/ZSJ9k591MwMg1PGzRiRG/StTfrlP5t9wI4ptXSofxSFg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue Sep 8, 2026 at 6:10 PM EDT, Ehab Ababneh wrote:
> This series revives Buddy Lumpkin's earlier multi-kswapd proposal:
> https://lkml.iu.edu/hypermail/linux/kernel/1804.0/00342.html
+others

Please Cc everyone in the cover letter, so people can know the
motivation of the patchset.

>
> The motivation is stronger now than when the patch was first discussed.
> Many current systems have hundreds of cores per NUMA node, not the
> single-digit or low-tens core counts that were more common at the time.
> When reclaim does not keep up, direct reclaim can still push allocation
> latency into application paths and leave substantial CPU capacity waiting
> for memory to be freed.
>
> This patchset adds adaptive multi-threaded kswapd. The wakeup policy uses
> node load to decide how many kswapd workers to run, so reclaim can scale
> when it helps and stay conservative on already busy nodes.
>
> Series summary:
>
> 1. Allow multiple kswapd threads per node and add control plumbing.
> 2. Wake an appropriate number of kswapd threads from per-node
>    runnable load.
>
> Concerns from the original discussion and how this series addresses some
> of them:
>
> - Concern: Direct reclaim is intended to slow a memory-hogging thread.
>   Response: That can be acceptable on lower-core systems. On high-core
>   systems, idling many cores while reclaim catches up can cost more than
>   allowing reclaim parallelism to scale. It can also block higher-priorit=
y
>   tasks in direct reclaim while they perform reclaim work on behalf of
>   lower-priority memory-hogging tasks.
>
> - Concern: More kswapd threads may hide deeper reclaim issues.
>   Response: This series is additive to ongoing reclaim improvements. In
>   our testing, multi-threaded kswapd was able to improve performance on
>   top of what multi-gen LRU already provides.
>
> - Concern: Existing knobs (such as swappiness and watermarks) should be
>   preferred.
>   Response: In our testing, those knobs alone did not reliably hit
>   performance targets and could increase CPU cost for the same workload
>   objective.
>
> - Concern: Need evidence from real workloads.
>   Response: This cover letter includes Cassandra results showing higher
>   throughput and lower response latency.
>
> - Concern: More reclaim threads may increase pressure on well-behaved
>   tasks.
>   Response: Adaptive wakeup addresses this by choosing thread count from
>   node load.
>
> - Concern: Additional configuration can increase operational complexity.
>   Response: The user-facing interface is intentionally minimal:
>   max_kswapds_per_node.
>
> - Concern: Lock contention may serialize workers.
>   Response: The Cassandra runs below still show net gains, indicating
>   contention did not erase the benefit for this workload. The wakeup path
>   now uses wake_up_nr() against the existing kswapd_wait queue, avoiding
>   pgdat->kswapd_lock (a sleeping mutex) entirely on the allocation hot
>   path.
>
> Real-world workload results (Cassandra):
>
> Tests were performed on 7.0.0-rc1.
>
> - max_kswapds_per_node=3D1
>   - throughput sample: 171146
>   - reference latency value: 6.375
>   - op rates: 43256, 42731, 42341, 42818 ops/s
>   - p99 latency: 6.3, 6.4, 6.4, 6.4 ms
>
> - max_kswapds_per_node=3D8
>   - throughput sample: 183639
>   - reference latency value: 6.0
>   - op rates: 45791, 45253, 46534, 46061 ops/s
>   - p99 latency: 6.0, 6.1, 5.9, 6.0 ms
>
> Observed improvement in these runs was about +7.3% throughput and about
> -5.9% response latency, which shows practical benefit for production-styl=
e
> database workloads.

But the result suggested we should not have multi-threaded kswapd,
because 7 extra threads give only 7.3% throughput. That is not a good
use of CPU cores. I suspect these threads are competing for LRU locks.
We might want to partition each LRU list into N first, before N kswapds
can work truely in parallel.

>
> In our runs, performance numbers were essentially unchanged with and
> without the adaptive multi-threaded kswapd wakeup policy. In both cases,
> they outperformed the single-kswapd-thread baseline. This indicates the
> adaptive method preserved the multi-threaded performance improvement.
>
> Addendum: alternative approaches evaluated
>
> - PSI per NUMA node.
>   I prototyped PSI-based node pressure ranges to drive wakeup count.
>   This became cumbersome because robust PSI-to-thread mappings were not
>   straightforward across workload types.
>
> - CPU mask snapshot policy.
>   I also tested a simple CPU mask snapshot approach.
>   While functional, it reflects a moment-in-time view and does not captur=
e
>   pressure trends over a broader sampling window.
>
> Buddy Lumpkin (1):
>   vmscan: Support multiple kswapd threads per node
>
> Ehab Ababneh (2):
>   mm/vmscan: handle racing max_seq advancement
>   mm/vmscan: make kswapd wakeups NUMA load-aware
>
>  include/linux/mmzone.h        |   5 +-
>  include/trace/events/vmscan.h |  28 +++
>  mm/compaction.c               |   8 +-
>  mm/internal.h                 |   3 +
>  mm/page_alloc.c               |  26 +++
>  mm/vmscan.c                   | 419 ++++++++++++++++++++++++++++++++++++=
+++---
>  6 files changed, 465 insertions(+), 24 deletions(-)




--=20
Best Regards,
Yan, Zi


