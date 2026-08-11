Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ABBCFC5AC67
	for <linux-mm@archiver.kernel.org>; Tue, 11 Aug 2026 20:45:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6D8C36B00AC; Tue, 11 Aug 2026 16:45:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6B0436B00AD; Tue, 11 Aug 2026 16:45:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5C76D6B00AE; Tue, 11 Aug 2026 16:45:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 35E856B00AC
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 16:45:32 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id BC34D1C0030
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 20:45:31 +0000 (UTC)
X-FDA: 85090169262.05.102E4DF
Received: from DM1PR04CU001.outbound.protection.outlook.com (mail-centralusazon11010051.outbound.protection.outlook.com [52.101.61.51])
	by imf05.hostedemail.com (Postfix) with ESMTP id D3DC8100005
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 20:45:28 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=Czrvp8BJ;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf05.hostedemail.com: domain of ziy@nvidia.com designates 52.101.61.51 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1786481129;
	b=Npq6/iFC4zyL/W42AvV+Q2V+dPL5IAQBd9ZcL8EgHtlPIeBfXBNx7r8HXgcE9VgRICmwx/
	r8QER7fHUtbz4gEvybqQZBOchvvIb6gCt/tUUJ0uDC3tYrXPXdk5KmfvqNKKJTwD6y90VF
	7KLKKkuDU+7L0M1XL1t0viRpPncs3qo=
ARC-Authentication-Results: i=2;
	imf05.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=Czrvp8BJ;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf05.hostedemail.com: domain of ziy@nvidia.com designates 52.101.61.51 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786481129;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=G7vBUUVyPlhK7EGMCvtgvUsI/ONmOzvcNfbyZLz2ZkA=;
	b=X1c9RYB/1/G0+x0rEU2H9mO6dopL8YVq5xKqhkHRMeMUU8jrnSZt/gc2iZ8QrVkveC8cqb
	BBFilaEgj3z/acRcwypmNYHdkvJBHPnnctBvFr1RNXrZGHO+mvqxd89bthrr/a3lZ82I0L
	DX5BHAJlWwGxBTE8JoEr4alp2XUZ/k8=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Obtgh+tTxnxWNkwEJZYq5CV5sRkQvONqvWN5+DYTNAknJyKTrhwNvnFR+GSldtt5YypeE1rKUNtyuLaDjoNCUrLQmesAldXZpn+NzM9AmZ061D/qnYIV72/ymKgumacS0N87JSsBRQj+2qe2UrpZuEH0DYUwbIVlJaN8a6YmjiDhnEZBWy/AC3L86/mkLWYDxTsMu1IQnMxeN88oXhT4cE/AL2+Qop6AjVvDTk4+oD3YufTVJK+sZ1GHPR5vX/ZRgpNdsu8uCetBp8TNSyZpgdqCKrCUK8/Zqs8qLM68wUqvKtcfvrmPvZCPXC4R0FvlX5CJmNUvpSD+2TBQSrK5hQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=G7vBUUVyPlhK7EGMCvtgvUsI/ONmOzvcNfbyZLz2ZkA=;
 b=rDER7pZbiFA/jRa9E6E2QZtc686gY1TbD2szEu31PR2bGebXnTrCPGH90olp0mOo4ON1YnL62Z/fMacLSB+JqCwDrJq9QAGFI8figcWa+GR+HU/s7OaArxYH3ZnuMo57f0w0+BngDs4teXyTd10/MpB1TTlTOkThF6ENQ8KdvzKlCbxwYxqexx7oyyVOoDb5/0HwJBDjPjDi1/+y6Xr6OBxqGFbRVbNwjgGDr9w/SAOOp+heSvSmM+MFdZHf1BTU1nqeQgpjR8EzX7GBhX9xYPxp2Ol2xKNloNrgYbfvTvDNtktTcP6leskknCmhBntEJmK8VGi2oxV8A8ogiiwLrQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=G7vBUUVyPlhK7EGMCvtgvUsI/ONmOzvcNfbyZLz2ZkA=;
 b=Czrvp8BJg8XI+oqE19e8sG39V2jkBZQleRr7ld37YvVQhC8CoCcti6C14l1rWEjgh5cWGy5sKBDfkY6VvKiY9CSlKf7cxlHd4tMKwJulrvpyG19t0uArMR2adWwMIbScEd0sw6hcc35DzHJ7TRc3howb0lPs7RyPVpe9fER0GpyfFwWWpI20ptszXMV96tMPXQRvQxbFFvbJilGol023HMOXuE7LAasDVNF+ltar/pJcy8I/CmPikUMj3uPbzMbTKYxhWKjTUqzwk1Lk5Tr9rngzCBtniTiDw9Zr6SBOlIeuUhxooyaZaQwBJgB+a3daKwuPSWNahhO5s+V3DI0mvA==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by DS4PR12MB9612.namprd12.prod.outlook.com (2603:10b6:8:278::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.292.25; Tue, 11 Aug
 2026 20:45:17 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%5]) with mapi id 15.21.0315.011; Tue, 11 Aug 2026
 20:45:17 +0000
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Tue, 11 Aug 2026 16:45:15 -0400
Message-Id: <DKMEPASDM0ZN.3NJEFGFDDFFE7@nvidia.com>
Subject: Re: [PATCH v4 2/7] mm/khugepaged: extract reference check into
 folio_pte_referenced() helper
Cc: "Andrew Morton" <akpm@linux-foundation.org>, "David Hildenbrand"
 <david@kernel.org>, "Lorenzo Stoakes" <ljs@kernel.org>, "Baolin Wang"
 <baolin.wang@linux.alibaba.com>, "Liam R. Howlett" <liam@infradead.org>,
 "Ryan Roberts" <ryan.roberts@arm.com>, "Dev Jain" <dev.jain@arm.com>,
 "Barry Song" <baohua@kernel.org>, "Lance Yang" <lance.yang@linux.dev>,
 "Usama Arif" <usama.arif@linux.dev>, "Vlastimil Babka" <vbabka@kernel.org>,
 "Mike Rapoport" <rppt@kernel.org>, "Suren Baghdasaryan"
 <surenb@google.com>, "Michal Hocko" <mhocko@suse.com>, "Jonathan Corbet"
 <corbet@lwn.net>, "Shuah Khan" <skhan@linuxfoundation.org>
To: "Nico Pache (Red Hat)" <nico.pache@linux.dev>, <linux-mm@kvack.org>,
 <linux-kernel@vger.kernel.org>, <linux-doc@vger.kernel.org>
From: "Zi Yan" <ziy@nvidia.com>
X-Mailer: aerc 0.21.0
References: <20260811-khugepaged_pte_refactor-v4-0-ddac39d61c4a@linux.dev>
 <20260811-khugepaged_pte_refactor-v4-2-ddac39d61c4a@linux.dev>
In-Reply-To: <20260811-khugepaged_pte_refactor-v4-2-ddac39d61c4a@linux.dev>
X-ClientProxiedBy: YQZPR01CA0073.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:84::28) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|DS4PR12MB9612:EE_
X-MS-Office365-Filtering-Correlation-Id: f44b79b3-d55b-4c11-60ed-08def7e973bc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|7416014|376014|366016|1800799024|4143699003|10067099003|56012099006|11063799006|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	qqadqeJP6ljRfIS5bhVI3b+0+xS3trHyLFn72tIf08VChnH6eP6NThhO5LM83gRrPe8UkFFF0euIoEEKJ3aTHFbHs4Y4CbE8HAQX9t7S6D8MZ12ivVKr2HiiEkiZxPbYzYpAjSIeIOj00OXeasw0Z3TimEvI8WHWPWQb7UBPSfz2sD0LpNfuDYxnhEG16v/g6Plfp1+O7vaD6E9LmkQB6xg2zZ55ffQblBdKbK4BPtjxEXSwgcYL0iyxO/c17dRDjWrHe6uaHS4yycZ2NZySp6d5dQQ0BOyOAdIaECWEudjpB1FDtviHf9XiP2vP2Tld4zxDyPO5D9b2WwcRjbfn3qRSJI/TN7emo19eCZenE9fKE29ujl2ZVPDkEF711UiY02QpY74ZWc+5OnLkhnUX33jX1SP3mZEhDO1bjbD8vzRqJz08GFrPY/QyW3aSA98O2Gr6TYirhIMg6tpd7bo21JYuZ3FGMhMULenfv/0oxIo3HAlAy3JHZqSaBWthN42on9qWwGh5Hxt4Ilm8z4IWZSMwkwqV7O0S9WIoxVt5ylagpnhha0jjrNi5DR+HoYqJ6JvMx4dHv+2+QHvgT78sd+i214xX1mjKJEVtTvtEnRq1Zg00h+PjqxzLfqh0u8F31putctH65D/NdmrLOcg5MwdtnVIbXbfsqajGeN6cBuk=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(7416014)(376014)(366016)(1800799024)(4143699003)(10067099003)(56012099006)(11063799006)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?RkZ0bjN1eWM4c2dtVUtBemxvb1o1NFdGWlRZV0t2aVorSTgzZ1IwbHJnQ2pB?=
 =?utf-8?B?VDFnWVR3RzkrRkkyQ3d3VVMzazdOWnZJRGlGZGVxemI5ZDFLcDdBcjVMVUNO?=
 =?utf-8?B?VmY0MDVKZWcyak8yVkY1ckV0S2FwZCtpRTZNU3pMY1lJc0daSjBna1dFUnFB?=
 =?utf-8?B?VG1jOVJ5WThKUzBZMi9MT3B5Y2VMY2k3ZSt6bUhvdWZZTHJRb1haOU9nK2gw?=
 =?utf-8?B?SDd3ZERabHF5TURtOXRXWUNvT3BqN01IZVB5eURxblZwbWR3bWJJWFdOMUNu?=
 =?utf-8?B?d2swbDlJTFNOdmFqNGpaYXNFWXdoSWZteTQvTkMrWWN1T1phUVZrQzB6SlJq?=
 =?utf-8?B?cHZLVFp0em5zOWdFeXlKK211c2dvM3laOVRBT2xZZkNMbEJEa0wrOXo5dWcz?=
 =?utf-8?B?UktQODM5UUV0b2V0Ukw0Q3c4aVFJc3lzc0ZnYWxySVRXaUFyZFNLbllMbnBJ?=
 =?utf-8?B?WitkTDRxRUJCTmtvTThBN0NLTFFhZzRVTUJNNWFVV3FZdlBOamNWa2ZkaWha?=
 =?utf-8?B?TGk1Q0ZpdGRnWkJtQ3ljTjNWZjhxQ1RDM0xuOENWZDJXM1ltLzRVdVhXM2tv?=
 =?utf-8?B?TnBzczg1VkxuQytDV2JyOW42ODNOQTNpSFQzOXgxMld3akpmVUc1b3R3bFNS?=
 =?utf-8?B?K0NtYVpXeVhnc1ByN1pSV3lkOTAvUHhIemV5aGo3VzVTOVZXN2RmVkNESWJx?=
 =?utf-8?B?THZPNUE3YUhYSXhxS2xTWkxqeGZCcWZ0ZW1mRkV2dGMrQ2dlci96ZXJDVTdl?=
 =?utf-8?B?dW41dEpDSXN0NEpxTG1jb2dBSDZFaDU4ZSs0eGJ5a1BQYllJdnN2YlozVWlS?=
 =?utf-8?B?ODlMWU96YzVySFl6cmo0SGs4MHRJS1BGa0dTVVd3NlBIaUtuUTdETG9YT3Np?=
 =?utf-8?B?dXJuS3BVRG5HdndzOTNNYkVrc1g4eTl3TmpocVV5SFRrVE5YNm54VGdQZ01F?=
 =?utf-8?B?U2pJcEpTM2M3YnFpanJFZmcrNjhTWGc5U2I5dmEyYkk0alpLemRUd21qSk1O?=
 =?utf-8?B?Tm85Tk5LdG01OU01V1JVMDZCTXNMZVAzdy90YXo0bm95eExkK2lmWm91WGhQ?=
 =?utf-8?B?Qm5qNW8xY0hMTG44NlNjRVBNdUVIOFZwcjBVdzhlRnIvRXVrQUp4RGhRUFg1?=
 =?utf-8?B?cnRKdXJ5a0k1ek9DMU94ZHBnVStETnArQWM4R0NaL2lqc2VqWnFEYURnQk9s?=
 =?utf-8?B?WkVRbFI1eTFOSjR5eGd4Slo1aWg1TmM1TmtPS3FIWnBZZ05xazVLdExJMlZQ?=
 =?utf-8?B?eGxNRDF0dWVlaTIxVmxRU3NHQVQvWDBPd210UUlJMkYzMXFFa2JhVW5VYnZY?=
 =?utf-8?B?dG05dERTUkNYbGI2bjJ6UXRDcFUwM1kwNVVYV1poeXVGaUpqRXMwa05VZ1hl?=
 =?utf-8?B?a0lESnFNZmtEK3k2WUFrbVpYV093YjdsSUdyQzhiRlJQNGdjYjZSRGg1ZTVx?=
 =?utf-8?B?YmRGY042NWdMQTJWZ3FXYkNTTVMwV2ZYam5WdXVteWRaNjlKSE14TDFmTTNS?=
 =?utf-8?B?NEFpODZqWFBzckpSaGo3bnZob0VTdzlkRmgyV2YzM3JTVzFCQWxqYmdVK1NV?=
 =?utf-8?B?REJYbWlFaElRamNjVXdWNnlueVpsSjFhWWdyaFdEUjRUT0xySjNuV0E3WWdW?=
 =?utf-8?B?MllIbnJTSjV5WGtUb3ViTVJwdzQ0MEVLTjNMa1NwckJ2VU1qQTNPMURyZURZ?=
 =?utf-8?B?N3REZ3kxQ25wdllKRmFZaXJhQUF1dk9LSkd1WTNPcGgwMEZMSHpObDJIQVJD?=
 =?utf-8?B?WW8yUzFiNU0vUVkyem1UODRkT2hqekpIOE5tVFVkUXJWemZmWHJpUDN6cHl4?=
 =?utf-8?B?QWZNUDkxWEx6c3NnbitZU0FNeEdRRFpGOHBieHF0Q0M5TEdmc2ZSMFpuUFNr?=
 =?utf-8?B?WWU2azRoNnVSWkM5aDJ0RGk1eFZkUE5WaWxTYzRqeHU2RVA0aHh0SW1kemlX?=
 =?utf-8?B?WG93UmVVdFh0QzdNTGF3VkY2MUh5Vk5vZHY2VXNTbTJEWE8xUm9JYSszTGtE?=
 =?utf-8?B?OXNVTmswN29ONmhKc05yMzFwYkdxeVgxZDVFODFTS1lndjA3c290V0x4bnJP?=
 =?utf-8?B?Rlg3b3hoTDNzUmlkLzRCU1RmT1ZZdHhBT2xVSDhCWk5Za2dwMGErZDZVSUpr?=
 =?utf-8?B?bEZsREk5MzJlMTJ2Ulk4VW84em5RWVZsRGFKSmJQc2E2UXhjK2JrSEpGR3NW?=
 =?utf-8?B?bmh1bHRrdll4Q2E1eG5GQitPcnlRMVBTekc0dUM5RE54RnFRQk1HY2tHWW1V?=
 =?utf-8?B?ZXJPSjI0NUdSMFhzUVVWSy9ObkFKUGJzeEo1VTRXdVlQRFJ0cU0ybDNFb21u?=
 =?utf-8?Q?vqCjCtAZlMdsuPKiI/?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f44b79b3-d55b-4c11-60ed-08def7e973bc
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Aug 2026 20:45:17.5577
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: EELpBBLbwTSt6pxwlH/wDNEmvvzReOa0ZvNmtIUfIYan6Bbi3LjhEt0oXv7m7pkk
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS4PR12MB9612
X-Rspamd-Queue-Id: D3DC8100005
X-Rspam-User: 
X-Stat-Signature: 71izaf5h18qpu5ij6h5ugjxe49wscut9
X-Rspamd-Server: rspam06
X-HE-Tag: 1786481128-688158
X-HE-Meta: U2FsdGVkX1/j3EFEU7W/dcvvFl1ZwrXR9m1MMyy++1Zh3ycaQftwNIDoAipf+gjRKXvQ7IS18OHk4zPRVcT8kAVb/tdfwdH8NQzCn6zEsUfleCfw4jGZwq/lI7v+djE+6eimTdExr4y511FiaFqdEqSn04t8mZqWDzh4vHCjJUNymo3LTXJrepXNV//2oQEZ5kEAnaL2j3lZ0ThrfR9d7trPWmK+YE3eWPTErw9KqslgS5zPM4VUv8+IJ3zG1FLsw8JENy7NgUiUfIIQ0onpctborw1IjeA0o7434LHa3Dkymn+sRkCyoFL7xwagTatw609OCH3CT7mnpBBGAZy0FNjb3s+Glt501pOe4e+nU7afhr3qTTLe6QoEgaBulL0bU1bei8FwwUgSYi0cxt0LBZ5eYeETN8E9Y/MpqR+RlDalUxjZ2VpgjliBRRK/9kBZ696aZxikwEkAnharksemEMYGPpeqgX+2egf7yt09gl/uOJeqRaUwd6Mfvnng7epbBwoHG2LK3DzMqor0KSFH+ih89dGyDzYx49qKtfXsZS6cRRfgkyfmaW7djSD/V0fYQx/b8llAXDN0OKkuStCiT8ldFbg6xvptOZYxlvPRnnCNa1ZcZ9Cl7gR6LgZkYuFxcqAUxG18uBPgHtjGoE62wm8swLGVwLJnQl1iETMtCZvDi4C0TsDZ97OeOV9+/Ng5767m9vn/6unlgk248azNaxVMAVyPIto2A/FLKv6Jv2usY7syOQaSLuEmW51t9/hg5/HXHNF57ENqXtZu8H+bGqzBe6PxwLKGeR5eMKpzSuOCO3M5i5cRlkDQ+19XVQVz1MBLP0XEnne6XaFwQGshQOWznHb2Q7hUhyyvh0aPKp0wnZhyvczeuQ7jUwtr5vEdiML13aOot//3hEa5RhzOBA379Spkjos8vifTKMovBB8DFvJ+5cEmwofER4mu//u3nWQryMMkQk7nHWLQhFL
 4vNa3z4b
 AChoysEpJC/WnS/Z/AgpP7q2gdpu9ZUJzgQ8I0FYIFTq4oACsFiSHKuNlkXqtEpSDvDyyEqkIyr2lgJ/bgDNrdphLQ6/vbBAXk7+QbSn18sxfaBLm2kYyp+PZITkBQVAOQB6bgTtuLC2+uHFDl87Z5+L/37MQSWKtMCOJGW5wcSby0LJ90NEQtPRnKaoj12eEue++KE1H6zVIaKEZc6aPKJ0RzNlKD0P4z4bbJuaLE4ZIzIyiRqFTD3qMC4NJKK6xHDsQoomKJfw8Pt04Gp++9mSDnkbTHZcke6S8Z+ThRgwXygq2RMaO9Nt9EQSBE78mGR2kJJIQ9iZVh2bVR3fI4FuLje1h4FvmgeUm7AShGPSES/QMmVoujAczjjtAl+rY53SozgY00SdIR2QUiSu465RHP/WhLfycXOVTJvENkDEbmJLr37xKmn4jX6qD1cbEjJ1s
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue Aug 11, 2026 at 8:48 AM EDT, Nico Pache (Red Hat) wrote:
> This change deduplicates the "is this PTE/folio referenced enough to be
> considered for a collapse" condition that was repeated in both
> __collapse_huge_page_isolate() and collapse_scan_pmd(), extracting it int=
o
> a single inline helper function.
>
> Also move the comment and use it as the function header. While we are at
> it, updated the comment to clarify that a young pte is a recently accesse=
d
> one.
>
> Acked-by: Usama Arif <usama.arif@linux.dev>
> Signed-off-by: Nico Pache (Red Hat) <nico.pache@linux.dev>
> ---
>  mm/khugepaged.c | 32 ++++++++++++++++++--------------
>  1 file changed, 18 insertions(+), 14 deletions(-)
>
LGTM.

Reviewed-by: Zi Yan <ziy@nvidia.com>

--=20
Best Regards,
Yan, Zi


