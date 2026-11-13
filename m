Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4FDBF606A335
	for <linux-mm@archiver.kernel.org>; Fri, 13 Nov 2026 20:26:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=amd.com header.i=@amd.com header.a=rsa-sha256 header.s=selector1 header.b=Mn5iPssb
Received: by kanga.kvack.org (Postfix)
	id 6E3F96B00EF; Fri, 13 Nov 2026 15:26:39 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 694F76B05BA; Fri, 13 Nov 2026 15:26:39 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 55C396B05BB; Fri, 13 Nov 2026 15:26:39 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 27A616B00EF
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 15:26:39 -0500 (EST)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id AF8621C3045
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 20:26:38 +0000 (UTC)
X-FDA: 85431228876.14.E9FFCE9
Received: from CH5PR02CU005.outbound.protection.outlook.com (mail-northcentralusazon11012022.outbound.protection.outlook.com [40.107.200.22])
	by imf04.hostedemail.com (Postfix) with ESMTP id A2C8B40009
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 20:26:35 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=Mn5iPssb;
	spf=pass (imf04.hostedemail.com: domain of Felix.Kuehling@amd.com designates 40.107.200.22 as permitted sender) smtp.mailfrom=Felix.Kuehling@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1794601596;
	b=GkvhyRmucuRS6e3EJO7JYLaCysfb5JxjYOx5YfluDskGecFwJb0KNI4wj1hF3djrsnUScG
	XcB1ew/Otj0U2Dz8ZmX5xyBWpJMO4yEdJFLB5saHmZEZCFZ3HkxwwaUBubF6dJ6awtIyfj
	npw1zdiTTJk2gukzlkrja6NM/UlTwGY=
ARC-Authentication-Results: i=2;
	imf04.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=Mn5iPssb;
	spf=pass (imf04.hostedemail.com: domain of Felix.Kuehling@amd.com designates 40.107.200.22 as permitted sender) smtp.mailfrom=Felix.Kuehling@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794601595;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aJbNS2m9FwSqPyxfRUNR+6UM/KmeDdGibiAf3sCi5+4=;
	b=Wyw9IomOG7nCTlCwZIio2Z8Nn5V9trphcpX62mURIhSSJ26Trd1qKmzV+ZEgEJg/eVh+HU
	Y+z+CCeLYK8y84O3FiUdGU0RNtrmaFUdIALcWd+H0Xl4ot/zpOFUJXlkYXtc706kzaJjvw
	PcIW71Nez2RCufVXTQPneHmUrgbOnuA=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=pAYBL/m1Ms9RDURjJ6RZu0hQzp64hbxlcuw0dLu2qqbeqc6msXsy2GOwEuggLe4aEY0gLzJR6Vq4dzrzNC7cxO3K/wEx2PpwDlFrKnzseBhHqlpE0AEEGkh7Zy1BZv0Jb5WOQYM/YIlknwwHb3wXncx8yKI9x7wauiVtEIYNW0LdSW72tGpTVwM3mIFLj1ESl9JlhLCmqgXcm2MRmrROiwBG7Pr/BOd4U6PhUWeNsuS6fb4SJS+gLHU2BPbrJmDHB9C+E+EExXkUBNXvW5HaoS0D/I8xm2jNxNi3VQnNHXzjhkAq8ylIhD5H+7Xf6AnUcKV2fCuYrS4oQWYJi1QfoQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aJbNS2m9FwSqPyxfRUNR+6UM/KmeDdGibiAf3sCi5+4=;
 b=t6g2LfCZrHh+Z5M5GZQgHOH5SHmWH50hnq9tIWj/7eSJH3x0ibVpLZBOEt9fo2pGTK/PmWpRcbhGcB/ba104ICroyOPNzdEHvs2iwxb75AE+RKe4Cz2+yBQx0O9XCD9WycJu7/sxug1vZl7xYJr2IJ0VIZ8JB7BRor3f+0RCfyfCSrhxeyFuYrTPxZ2fperRq6BgFsbP7knD0sibCwzZkqCdWWtX88EVlr4+LkJD0duoPWvDNiqT0+2hXSLo9hvep8xc+3jS04+LD4tNIwlMrjOWRw58v8LJu9stSZf9mHhuC9ubhFB3oL83SreoHpvJw6Ey1IK6Z8AS6e/XZMexQg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aJbNS2m9FwSqPyxfRUNR+6UM/KmeDdGibiAf3sCi5+4=;
 b=Mn5iPssbz4UY8RRdLTLj9VX61rsC9J+WlgPwsmC0nAp6zw04JY56Kwjb7Vsv3VAgiSUd/dGrsXSRAys1JbVVUJaPUnfRIKmCNg7CJu4Gc5e5wvqLOetUBz0qFUbJ9+DimpoeFUasOwt0q2kWDVyQyEuYsa251lKL/UURmEkHPEs=
Received: from SA5PPF8ECEC29A9.namprd12.prod.outlook.com
 (2603:10b6:80f:fc04::8d5) by BY5PR12MB4132.namprd12.prod.outlook.com
 (2603:10b6:a03:209::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.592.11; Fri, 13 Nov
 2026 20:25:31 +0000
Received: from SA5PPF8ECEC29A9.namprd12.prod.outlook.com
 ([fe80::fd82:d106:2d09:2dcc]) by SA5PPF8ECEC29A9.namprd12.prod.outlook.com
 ([fe80::fd82:d106:2d09:2dcc%5]) with mapi id 15.21.0615.008; Fri, 13 Nov 2026
 20:25:30 +0000
Message-ID: <4b9042de-973a-4036-a6a0-2294c65a1ee1@amd.com>
Date: Fri, 13 Nov 2026 15:25:25 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5/5] mm: check permissions and bounds for vm_ops->access
To: "David Hildenbrand (Arm)" <david@kernel.org>,
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Andrew Morton <akpm@linux-foundation.org>, Willy Tarreau <w@1wt.eu>,
 Jani Nikula <jani.nikula@linux.intel.com>,
 Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
 Rodrigo Vivi <rodrigo.vivi@intel.com>, Tvrtko Ursulin
 <tursulin@ursulin.net>, David Airlie <airlied@gmail.com>,
 Simona Vetter <simona@ffwll.ch>, Chris Wilson <chris@chris-wilson.co.uk>,
 Matthew Auld <matthew.auld@intel.com>,
 Madhavan Srinivasan <maddy@linux.ibm.com>,
 Michael Ellerman <mpe@ellerman.id.au>, Nicholas Piggin <npiggin@gmail.com>,
 "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>,
 "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
 Shrikanth Hegde <sshegde@linux.ibm.com>, Rik van Riel <riel@redhat.com>,
 Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
 linuxppc-dev@lists.ozlabs.org, stable@vger.kernel.org,
 =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>,
 Chris Mason <mason@kernel.org>
References: <20261112-access_shite-v1-0-988a5c470db2@kernel.org>
 <20261112-access_shite-v1-5-988a5c470db2@kernel.org>
Content-Language: en-US
From: "Kuehling, Felix" <felix.kuehling@amd.com>
In-Reply-To: <20261112-access_shite-v1-5-988a5c470db2@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: YT4PR01CA0304.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:10e::20) To SA5PPF8ECEC29A9.namprd12.prod.outlook.com
 (2603:10b6:80f:fc04::8d5)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA5PPF8ECEC29A9:EE_|BY5PR12MB4132:EE_
X-MS-Office365-Filtering-Correlation-Id: 5f10b15c-cb1c-4e21-efcf-08df41c44312
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|366016|1800799024|7416014|376014|18002099003|22082099003|921020|4143699003|261028144727099003|56012099006|3023799007|261026140227099003|261009223027099003|261021121427099003|261102130727099003|261022105027099003|10067099003|261021123027099003|261026121527099003|261102123227099003|11063799006;
X-Microsoft-Antispam-Message-Info:
	BmKi6OAuR0IQLOPbyveuoRlDniq9nplfbS7NwDp9vyCUyiYtG/nC8nHlLDZ2BNpG6LP4Ss1ahqu+5OO583RhU04UpFM5bVt0DgPWlszXYrHy3fyCmUFl5hnyYd1fueui7MDKtIgwSWmSKnrmkvggD2+D8iK8hbZaN87Jdbkz5X3IDKtEOoHhmbbicnY7TEe/ExkBL/9TSjkNFT+Yu8txH0nmYidsy9uIniZ2lfEEAsXCNvUSTNRn8+8HPt+ytHbJTkkkbvuVIqHftpQ2VgcliuW6ERx5e67SIEvHlgDdMpGJDB/CjSY+PIOkLFoMzmLhVD3mrAqEKfJAhROsXnnGa9a15UCA29A/HHHmdY0djLupdbJbEf538VwypljSaIKEPp7vAwkpE1Bk/+0EKVAAsLGoK4UbOpZ6sMDSiN+ImkojrSS4mCpyo15IQZILOW/nTUXUBaeLLcLJLCMxqneXWNH6bOHQSKwgOSpMTtuN1TknCWy2expo3193PRlnr1OQjhtoZ9FM0VgPhSaynmWP0xjn26a8U1Ai2FShYZp0aIKdeeUJ6RDNHYNqur25iaMdaVXHqSaot4m7RznYCQQyPOusjSMtNhUeSQGZXqML/I5bLL/+2kcAtK2B7B9DlSUBsduOI8efFo5RXf1EseLGc32tSgBLAQAvJS5NPg3NIFRwlW1oINwzvl1oD7MSxRg+fb/fxIOk8xGOZvLsN0u0dQ==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA5PPF8ECEC29A9.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(366016)(1800799024)(7416014)(376014)(18002099003)(22082099003)(921020)(4143699003)(261028144727099003)(56012099006)(3023799007)(261026140227099003)(261009223027099003)(261021121427099003)(261102130727099003)(261022105027099003)(10067099003)(261021123027099003)(261026121527099003)(261102123227099003)(11063799006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?UU1TOWUwQ2orNnRBN2R2dHl4cEpFYUZoZFc1N1Bzbkg0UEZDa2YwdUFlS1dI?=
 =?utf-8?B?cEtDTllvS2Z3Q3k4ZUhaL2JsMWY3N3MxNXIyTVhHbW0yZU9BNUVpWjArWEdK?=
 =?utf-8?B?K2lwTTJ0WEZINjFSOWpaeHRqd1BORU9rVFVuNUVsOWVPNUNsbS9NVFdxb1FE?=
 =?utf-8?B?dzRYRm1va2kwbjRRMldRNVF0ZXRBNnltcVRndkxxMFQ1NzRMTkg2QTlSbTFI?=
 =?utf-8?B?QmRFZXk1d1RMUWYydGtJUTJKeHlWSFNpTjUvVjhTVC8wcWxLdERHY01ocVRt?=
 =?utf-8?B?YWdIeG5HckhLaXFMN3NpamxjN3pMWGJmNkhOVVdxWVY2a2xYYzN0MTQrNDNS?=
 =?utf-8?B?clNzVTA5NjhwTHptZFRIdHB3RXMwajZUQkl6ODNNVFpETWpuMWdENjZXVlFM?=
 =?utf-8?B?eStpalkwTUk0N05ZNTBCRW9xUm9EQ01NTnhrRy8zZVpMSUNlVE5uSnlueFZR?=
 =?utf-8?B?M2dIMk01aGZ6bVZJVi9NQXIwZjhWZ21xN2xSVitkM0F5eVdDN3owUndic29o?=
 =?utf-8?B?akZHcDQzVWtsT2dxbFZTb1JJVGNmMXc3WU1zUUsrajhRcGQycXNlZ1JiSkJW?=
 =?utf-8?B?VjVhWmp6UDdtNjJzVTl6ZnRIQjdTNFV4NkZQa3gyNkJjQWtGWGZrVS8wWlJE?=
 =?utf-8?B?Z2FiQjBRTG9TaUhUSTBnWjhHQVJjT09lbi9PSmUxakk2TzdDVnJkWE5vV2d0?=
 =?utf-8?B?WDMvT2F6bEZVcmJLM0FKb2VPMEJOMlo5dys5OVJ6aUJCd09USXlmdmQ4bEtE?=
 =?utf-8?B?b2l5ZGZKM3ZTSVJJVzJwZGdIN0NxV1FZNTU2UDcrekpmWjV1UVlqR1ByZTEx?=
 =?utf-8?B?d1daRmpCRmhZTmNObGlDT0RiRUdxajZTeGVtSzVIMXc0TzlVYlczd0txekpm?=
 =?utf-8?B?U3BYbEVYTGpsMGVSR2hnRzVkbTJ4SmowcTBVRTBoTHpncDVuYjVxZC9acTZs?=
 =?utf-8?B?S05GWmtPSVlzQU9kdEVDMndLRFoydEFRUEpGQ2pCUnAyQmdXenhSY1RDQWZE?=
 =?utf-8?B?RGZ4Z3FST3RkSUYra015MnNNUC8yUmFvZ3ljWXN2RXM0dTd5WUZqSzlFK01m?=
 =?utf-8?B?dk5hMWg3VkxHalNOUWZTM1pQaUtIbEFwRmtXNUxiOVpGNHNvT05UOUV4RlA5?=
 =?utf-8?B?cFhyN3BpWTNLdDc5REdvdEtoMFA2K1JaOWJ5YWVOMHdsSTkyaWRQbElMdGQ1?=
 =?utf-8?B?Y2I3bDNGTUpGMmRmamhORDlIaGhnd0pmSWJmV3JPWm45RllpeFhaWXU1S2NX?=
 =?utf-8?B?TEx5MnNkMU10YXQ3UFVPUjFmUzIrTTIrM3M2OTBqWk5CcklzUFJzNXptOHdK?=
 =?utf-8?B?V21BN2pVZnNMdGlxbWFlQ2hjWk0yOGI0TnVFRExCUmNFdEoyaGJXUDR6bDNK?=
 =?utf-8?B?NU9xOWdETzlDY2lqWmh3bnlFNkJHN1V3YWRiazd6M214aTJPejJESDM1Nlo4?=
 =?utf-8?B?Q0NXdm9xTEs3YnRXSFAvc29RdEx6ZkxxNHhSWWV4aERPamUzUERBbmN0V0gv?=
 =?utf-8?B?TFoyTWE4emhFK3FnWFNVQTh0cG52TW5nSnFydmRINXhjcmdTY29KTW5STDZG?=
 =?utf-8?B?dFpoTW04di9acEhZbzJBa2hOTjVBUlVVSWxaSkxhQmtCRCs1TUNQUThpZGhv?=
 =?utf-8?B?aWhJUGJpME5MOXNZR24yOEhTSE9PQURxZkRYL0xZczRhazBkcHU4ZkNKRlUw?=
 =?utf-8?B?TWRHR09hbzFGNDR5SFZDc1ozWmd3WE5zUjhEZWx5d1IvdVlLQlJjWEJxZ0I4?=
 =?utf-8?B?aDhveVNJZ0pvalg2WEhzdnJreHYwdUNMaXpva2lxTFg5QWpDWjRpQ1BHWWVt?=
 =?utf-8?B?LzdZdE5yODRBVVVlWnF1aE84Z2lPczNlV1orMU1iZ0FsbmF4emVqd1ZrTFh3?=
 =?utf-8?B?MmpCMzNNUG5NNFExa2tKL0Q3Um1FellTcmNYREEybkswQ25tZGxGUUc0Rkcr?=
 =?utf-8?B?Umhkb3Fja3JOWFl4bGo4TWR3RUZCM28rRTBoNkhPYUtpQlRWM016MWtQWnRa?=
 =?utf-8?B?eFpBamFwRUpKTTZyQzBKQ2gwRU9yU0dycWgydkpuOVVjNXEzZHRtaFpaUmpJ?=
 =?utf-8?B?QjVzNng2Q2p3bUk1L2JEby96T1pTYm5JQ2ZLYlpBQndYT28zN3NNaXByUDRR?=
 =?utf-8?B?SnZEak5EQ1A2YzF2dXlzYkJIVjc3SXdmZC8zd0FhRDVYajRxRG9jVFlPMlc2?=
 =?utf-8?B?WHN5SVRkWWNMSmVrS1lWR2lYN092MmhnOUZjR1k5ZHB5RFVoRGtlVGVNZDg0?=
 =?utf-8?B?RURudXZxODhDQmV5Ykx1b29YMk11djlueHhyTUxVSWhoWmI5eGNEKy9rTGdB?=
 =?utf-8?B?cStuYS9EcXM4SnVsT25YUmovUEdyRkFYVVNFcWplOWxyNmJEbTF0dz09?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5f10b15c-cb1c-4e21-efcf-08df41c44312
X-MS-Exchange-CrossTenant-AuthSource: SA5PPF8ECEC29A9.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Nov 2026 20:25:30.7258
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: G/dUCZhBbr1YS/kAMI3U0/T8UdavHgOxC77Yl2hSLj7fqmqI/9CYjy4ge2RCfZxxUeq1+nzeiFklR6KS5+kxMQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4132
X-Spam-Status: No, score=-22.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: A2C8B40009
X-Stat-Signature: 8tuwegp3meio8qaiq8efuscnw1dpzs3e
X-Rspam-User: 
X-HE-Tag: 1794601595-974760
X-HE-Meta: U2FsdGVkX1/NFZllGsD+z7DDPittQiCu+Tkrm3Cl3/slTwEkJTfLonfv9gaMh995Sk1euLsAkcIMOFzd5C/DlusJKgmr0ba7qkvx6BcRrpCLdwmVXK/kpRPfUSIu00u9KdrtN5mK//hvKMDKDoGOgNoa+PXLBplNBZfJA0qjJLn0Z9K4j4C87Vx5R05fQA/B91IMNCz2ojsMywQDJH63gglfCpxMDPMVS0bYvx9UFuz3crljXQkHIwCE04zeSACKcahaaDLRN5uH5kTzQ29Z/ZcqnPHJvin82LPCSUCEX6DkbOMWWXI8WY530e6Dm4CUN2M8WjpIrCZKqoWk8oxutPC2h3GN1RAYhFI7deHxXyR8Y70ZNLmDF+aNJcvr8xMDMrNVY7Dx0A2sNZImITdfoZijy4PA/5u8p+N57xxNj28ksb2PSvGVM+FdBMhVjrff7U2xrzY+D459nL/6FXySuSA9ZcRYBEykgs77CxOcUuYGXYOdP9nJB0qfaEUcXsRxTRXPoODx77fr8Mle5xbJZTwqZ9kOAAJai5dW/vkmiEGPJDnPI3pBuzcYw+xR0tmkApDMymYRu+6AibHlnJo7IiJqcsDvxDWrn4EFmhcbbDutP4wkU3Jd1s/HDcCVMVDnO5l8fZcK1/FaIhgvDzBO8Le2S6i/wQQp+iLgWT5Vd94tWh25D5k+9uxZsZ5m6JrsfQ9zuMwERXIPabVIZtfmyQ9NW1T8l0K2VHH6MqFFy/Atjb1SEiClIvbdurWZpRlz1uFPAH5Iel9arZOFxAD/gOZXu6d+HnhiVxDu+qUAX+lO+vWFNJzQIT0+tG2pUa7gvHoj9KWWNEOmV3pDy4BadC9J/SMnahX2fKXTyQ0NGtc9v/gDTWOwl0d6xxVAzakQ+wAAdVSDbAus1500/pyVRGj9CuziWZmIDl2ZSdFKlUpNkxtLvb6OYa9ppZGSlFR24+odzwefGlEusZnf7dw
 QoJjPJh1
 08KxW4E+BSJyt9EruaOLmJHn9sV23Mt8fA0mjsrQ55J1h5O/k0nwKI2++QR8FCK/L2AnvA9168kFkebnnOUED/h38OfxqS2BIB1k566vY2qzlpSYGm+gi5D6yOaMD3FY2xW4/aAWIgmkU6225yTye1VmBeZlIYmFQrScHTLmBCoUqBHbFh6h2k2dUUHW/Z/qaXTj8YCjc1bVQN9lKfV/mmartBNx79iICOi57E7Efwe7O781gECzzqHmxvcOGUE6ZWFWxTt+C/Y7tGPg9hRjsS4m0b0CCqlIeOsxv2KosU1RTGJ5MGWMFXncV/lzTHeyZqgDZy8Ba6tKjsMvMS3L760wQ1G0uAiSVp5pLJm4itr3dX4cckbIOa1Xgmh8v/fwwd06zF+qX4VssOFwA2CVnolZ7ixcitQrW/Adk41HVqWYve4o/6rI9C5REMugQYexVg4I69u2J8IRt+hGAkCVBt7lwacEe3H9oBfDM24FjUBQSH/oqRHyDc8EkKThRt/W2hQrvG89ylnhS5blgj3CL4iP5oKxx2ntemfphnklN09JCjdftJpc+917zoGwKKLNwmB7oot6rYTxGhMniob7Armn+lLV1HfaHGjJaA9JkMrvoSl8e1vtzKq/Jlw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1


On 2026-11-12 17:09, David Hildenbrand (Arm) wrote:
> GUP rejects VM_IO and VM_PFNMAP mappings early. __access_remote_vm() then
> falls back to vm_ops->access without checking VMA permissions and without
> limiting the request to the VMA size.
>
> Consequently, /proc/<pid>/mem can bypass protections even without
> FOLL_FORCE, or cross into another mapping without checking its
> permissions.
>
> Check VMA permissions before calling ->access and limit each request to
> the current VMA. Implement similar access permission checks as GUP,
> however:
>   (1) Reject writes to CoW mappings because the callbacks access backing
>       memory directly and cannot handle CoW.
>   (2) Allow forced writes to non-CoW mappings with VM_MAYWRITE.
>
> This intentionally breaks forced writes through legacy amdgpu PROT_NONE,
> MAP_PRIVATE debugger mappings. The workaround in commit fa5239f2af98
> ("drm/amdgpu: workaround failed COW checks for Thunk VMAs") cleared
> VM_MAYWRITE to avoid CoW, but debugger writes still succeeded by
> exploiting the missing access-permission checks fixed here. Reads remain
> supported. Userspace must use MAP_SHARED instead; ROCm 5.5.0, released
> in May 2023, already does so.

Thank you for considering this use case and checking the ROCm history. 
The patch is

Acked-by: Felix Kuehling <felix.kuehling@amd.com>


>
> Link: https://github.com/ROCm/ROCT-Thunk-Interface/commit/fea44fab6e84eda52fcf6b419b35600c18f4c022
> Fixes: 272ddc8b3735 ("proc: don't use FOLL_FORCE for reading cmdline and environment")
> Cc: stable@vger.kernel.org
> Cc: Felix Kuehling <Felix.Kuehling@amd.com>
> Cc: Christian König <christian.koenig@amd.com>
> Cc: Simona Vetter <simona@ffwll.ch>
> Reported-by: Chris Mason <mason@kernel.org>
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
> ---
>   mm/memory.c | 25 +++++++++++++++++++++++--
>   1 file changed, 23 insertions(+), 2 deletions(-)
>
> diff --git a/mm/memory.c b/mm/memory.c
> index d4370c1b331c9..9872f289c1e49 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -7362,6 +7362,7 @@ EXPORT_SYMBOL_GPL(generic_access_phys);
>   static int __access_remote_vm(struct mm_struct *mm, unsigned long addr,
>   			      void *buf, int len, unsigned int gup_flags)
>   {
> +	const bool force = gup_flags & FOLL_FORCE;
>   	void *old_buf = buf;
>   	int write = gup_flags & FOLL_WRITE;
>   
> @@ -7401,15 +7402,35 @@ static int __access_remote_vm(struct mm_struct *mm, unsigned long addr,
>   			if (gup_flags & FOLL_ANON)
>   				break;
>   
> +			if (write) {
> +				if (!vma_test(vma, VMA_MAYWRITE_BIT))
> +					break;
> +				if (!vma_test(vma, VMA_WRITE_BIT) && !force)
> +					break;
> +				/*
> +				 * In contrast to GUP, we historically allowed
> +				 * FOLL_FORCE write access to non-CoW mappings.
> +				 * However, we must always reject CoW mappings
> +				 * as we cannot CoW here.
> +				 */
> +				if (vma_is_cow_mapping(vma))
> +					break;
> +			} else if (!vma_test(vma, VMA_READ_BIT)) {
> +				if (!force || !vma_test(vma, VMA_MAYREAD_BIT))
> +					break;
> +			}
> +
>   			/*
>   			 * Check if this is a VM_IO | VM_PFNMAP VMA, which
>   			 * we can access using slightly different code.
>   			 */
>   			bytes = 0;
>   #ifdef CONFIG_HAVE_IOREMAP_PROT
> -			if (vma->vm_ops && vma->vm_ops->access)
> +			if (vma->vm_ops && vma->vm_ops->access) {
> +				bytes = min_t(unsigned long, len, vma->vm_end - addr);
>   				bytes = vma->vm_ops->access(vma, addr, buf,
> -							    len, write);
> +							    bytes, write);
> +			}
>   #endif
>   			if (bytes <= 0)
>   				break;
>

