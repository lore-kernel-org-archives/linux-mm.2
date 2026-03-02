Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9D9BEEA4E3F
	for <linux-mm@archiver.kernel.org>; Mon,  2 Mar 2026 16:37:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1166B6B0088; Mon,  2 Mar 2026 11:37:13 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0EEB26B0093; Mon,  2 Mar 2026 11:37:13 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F12A06B0098; Mon,  2 Mar 2026 11:37:12 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id DDF856B0088
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 11:37:12 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 5FF5FB6D37
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 16:37:12 +0000 (UTC)
X-FDA: 84501677904.30.65F2F8E
Received: from BL2PR02CU003.outbound.protection.outlook.com (mail-eastusazon11011035.outbound.protection.outlook.com [52.101.52.35])
	by imf18.hostedemail.com (Postfix) with ESMTP id 52ADC1C0010
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 16:37:09 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=bjyof7Sw;
	spf=pass (imf18.hostedemail.com: domain of ziy@nvidia.com designates 52.101.52.35 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772469429;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZK5Cg668mpmbKEd8qH+eBUB8aMjoDwadNyxm2Rri8TE=;
	b=vyxWLuPFFAnFGyHt1MaAdaNrvI3GBKECfOZDa2uqwPMkwPqelWXHODmkUbjXLZB5eMKfiF
	D+bK6intB7ioLGfVyqZ2IyRXfq7hY1vfzNbQnGLlU8Bao/tIJONQp0vhZBkp/p1X5wxPYR
	IPhlyynxkJbIVKerL4tmapnxBhizRRk=
ARC-Authentication-Results: i=2;
	imf18.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=bjyof7Sw;
	spf=pass (imf18.hostedemail.com: domain of ziy@nvidia.com designates 52.101.52.35 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1772469429; a=rsa-sha256;
	cv=pass;
	b=DwmGEFz6KHMuMNWmpJhvZNNhu9ISKn+T0VFymr+YFuocwyoj11WCpeRuNFef8rvtJ05dtZ
	x3EVwO4Oj0yQR9eQ1kQsXzldhSYAfc0SKajlo3HEEJxgyR+tTVwvdhuBeoc5d8o0WYZYn3
	LmKtQITUSOf0S1TMx52VXDQnGkqYrcs=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=aW6uSSjgxLbMOhlsGPokTXzk0nxMtlIe762IveR9l9tbC5vHP85af70DzT4vgbpxU8qiwyB/oczFyUXNWgFkeguA+9Iye7Em4GT0nVajmtefp4UzNR5OGv6yrRRu+YV6R/TnzrqIzG62Y4u9Nu7LZmxxSgaCCU/Kp/3t+dpe8vVKBW59OxaFYakzEX04LSUPaL4F1EVr4tXWB/dRwE7MVFGmX0gtEsv2QsTF8NXaK6Ke5IrhvT/sfVXudj2vDe3yB6uk3c7y/64IwkF5BGxC8fU38Q7hkbeI5K8SFkTsnAH7AIeyod9HOorlVl56PAWCV7NwJ90z7t5u+3rfi8bVrw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZK5Cg668mpmbKEd8qH+eBUB8aMjoDwadNyxm2Rri8TE=;
 b=CX1mwGrUlveSRE0g903tq948zqY1ZdIWg8yzhHwtWZVgkKR1UNzACl/rUzKxBIcPNO5qrdKETq9m6pRe8xE8p2Ah4Dl509vU+HDPP+k39gmzDH+DzFWyJwdWFcg0MjojaToY2yMdVXB93JGkxAfEN2WOSoLFZ6C3Llvrh7XVZh+Yxka0CySXoH10uUiyhmkPhaN/K/sKrwNe5kiw1FLQtgnhkBg7n3ejgjM8EkvnktY0rH2w02uM3KwJOLXosMijBmZkvrDVVN+mDKFFNsXantvUBjVms1eMiSqVXS8PfkYWdcU0JPL2mFmLcSExb5+ZRjE2foHoQXEWMyHCWdfseg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZK5Cg668mpmbKEd8qH+eBUB8aMjoDwadNyxm2Rri8TE=;
 b=bjyof7Swp9g1KkWqgF4hb6cPU3GwWVysJovbF9voT++1o5la7HFxtHfCoPOiXDA8aPPmgJGXX8TKwzyaxJKXEGiKy0/sHdoa+Jqv3aCkgtWmK773n+nvvFeOQwXcTpgYPz8NJ6DllhqX4QCuD4b/46Qnff++/RDTi7/QXPBjc53Yh1qvIkLYQ9Lw8/h9pIJsleiyMVMx4ZaOXwNkNrfm3/98wDQUQts8l28QZmArTNYrS9fUqMx6HESRUdnXfgMwcxQyeec5eIdc25EP6w0oJkmrWLCuREUZYJnqlDiAYtUXC9I98EqjXgXYJ4V/xjXcQa53MOM7ymtaY3zMeIrWNQ==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 CH3PR12MB8879.namprd12.prod.outlook.com (2603:10b6:610:171::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9654.16; Mon, 2 Mar
 2026 16:36:55 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2%4]) with mapi id 15.20.9654.020; Mon, 2 Mar 2026
 16:36:54 +0000
From: Zi Yan <ziy@nvidia.com>
To: Lance Yang <lance.yang@linux.dev>, Bas van Dijk <bas@dfinity.org>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Hugh Dickins <hughd@google.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Matthew Wilcox <willy@infradead.org>,
 Eero Kelly <eero.kelly@dfinity.org>,
 Andrew Battat <andrew.battat@dfinity.org>,
 Adam Bratschi-Kaye <adam.bratschikaye@dfinity.org>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 stable@vger.kernel.org
Subject: Re: [PATCH] mm/huge_memory: fix a folio_split() race condition with
 folio_try_get()
Date: Mon, 02 Mar 2026 11:36:49 -0500
X-Mailer: MailMate (2.0r6290)
Message-ID: <A120B74B-D8E0-4810-B0AD-CC34ED7BFC9A@nvidia.com>
In-Reply-To: <6a568d3c-daf3-46ba-a3ce-0a0deca824c2@linux.dev>
References: <20260228010614.2536430-1-ziy@nvidia.com>
 <d9e30bef-621f-444a-a1b0-510c50927d9b@linux.dev>
 <64fa6a73-8952-4ee1-b7c3-8b0ebef3ea78@kernel.org>
 <6a568d3c-daf3-46ba-a3ce-0a0deca824c2@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BY5PR16CA0027.namprd16.prod.outlook.com
 (2603:10b6:a03:1a0::40) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|CH3PR12MB8879:EE_
X-MS-Office365-Filtering-Correlation-Id: 58182013-49d9-4d78-82e8-08de7879ea0c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	enIJtFfFbH/VfdO8HndBSQqua0zN2K4+F94KMczdblGDtXC1IUhm+F+DTNHxsX91M2wZ+2cepqnXqlD4FMPD+BhQsoHRKzIBWhq7fQnOiyM7oFM1DxGzVgEcTSgaE/2EJhm8K2UncudlaBpacIHGTYORpDkSmxUdDvxGCYISD1gR+tyUzgPUz1tlHIF0BpHWNTyDYNs2WlZG4J44e1DHw3Tu/ZL/bRFTqslcPsHM/TCupLZ8NT+6bYYiYKsLZFoyA/aZfJjlqkSWRORy8uXvpWyH6ftlrY2e+uKuu1Bv6HwFmp6LmIEcm291oCO3wZdkPI22AqYqYrvfFzXvw/vo7dAc6FmAY7vwcL4Hne9ZTEnHuBkR+o1cK676DdVGtv39f4IZl3xIRVe6GAcC7VnL3IVlwiIlX1ljj9mvAs/0p0ONq+YB6cRFwgXrjIY8b6lVcG5iNT7svmzSfmecV8KE1WNEYyrJ8bwq5Gv/Ty7tJcs57rfHb0qENXAzytSLgDqmCF5utFT4kxqveZd1u4pZgG17N7mH0K2/s/ur4Bqfzz5ILX8L56KzbQdtPcit9iByD46ws2k2z48mBN9lEoQ7WnVtNGiTj7dxw9Ox5eB0yS0gzCPA1cvVi44uK7+z3wrcLEMqPWq0l9zIl5nivtTSpw50dfUPTSiNmiER5k0jwcYQo5URk8dN5Nn7YTm+MogqAxr0dxYuQf+BAQk+y3b58dWHzbkAYIB/NScZYRbPnKI=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?NXVraEQ0KytzRWU0bXEvTnlyS2l3NTFCMXRFL3RhNlQ4MytoSmJ0UkFMTFJQ?=
 =?utf-8?B?WDdoVTExaE16NVdvZkRtczFTNmx0MDdncmdJMVZneS9Sd08yMnhKbDNXV2RW?=
 =?utf-8?B?RUsxZG9wK1M4N1lnOWZvbTI2ckVCRTBMMysyQlgyei9VMzNKNkhiSzZXNWh4?=
 =?utf-8?B?WmQ3dVhXenRRZGF6ZUJUR1ZXanBsZzFvR1B2enZKSVdTR29qbHJjM20vQjQz?=
 =?utf-8?B?RnMrSU5UemlkRHNyWGFuZGFHSE5Fd2VTcmVvVWtIVitsemc5VTJTdnM5Z25S?=
 =?utf-8?B?YkdKcStRZzJqdUVHQTZoNGNob1hpUHR1Y0JqbGtxT1dGQTVCTitZelkzMGxV?=
 =?utf-8?B?V2NYcVdqeWcwWVBqKzYxUVJIL3VXMDZXQzVKSWxtRUx6aWVZbUI2eVhzRmdn?=
 =?utf-8?B?MWNpNWU3a0h3OXBLRmxybThhUG1jbVI5a2FFRWd1V0J0RHRTcUxwMlNqY2lx?=
 =?utf-8?B?d3AxSWxZNjduQmVCVG5NQVNSTU16OEhXNzExNmhqT0w5R2h4cmVPMy9TMEVC?=
 =?utf-8?B?Qk9aUFptcXp0S1dxMGtLVXBrSzRadytXYWRkZUxOZDFFMktVSjdUeDVNUXJN?=
 =?utf-8?B?NEZBV3N6NWVtKzdkMFJ0ekdZK245OGRXUkVhNUxyLzBNOU1NOEpDeXlVbEw4?=
 =?utf-8?B?NU9vQzBUdzlsWUVqbkt4WEtqR29hcVVDSHd1ZFJtYXBOZkY2UkQvMzdHQXJK?=
 =?utf-8?B?RUxnRlJialJHYjJRSy9UTjhYYXNtNkp5RFlESDNPbjFueUtBTnhQWXN4aWVX?=
 =?utf-8?B?cFRmUVN5akV3MHFYQVoxM0NkR1ZuNUI0dnlGQlRINTQ5WFM1cWFrN2MrTTMr?=
 =?utf-8?B?VFM3OG1XS2d0NE8zd2diSG5zcHFtbEpaKzFqTis1R0RsUVVLMzFYSU5DTW1q?=
 =?utf-8?B?elJnSWZUVzhVVW8zWnpWNkExV2UyaGFEN0dzUUlrTlA4OHE4NEZXbXJuUzJx?=
 =?utf-8?B?MnlDQnk1aWdGb0UwNGRaempWdEVhUENTRU1RSENkeE1ZNzAvL28vTGh1ajFj?=
 =?utf-8?B?NXpCK1FybnNTaWNCYVA3WXN2KzVoWVgyN0RwNldwNGhGT3krRVNnWWVKVFMz?=
 =?utf-8?B?ZFdHT0pvTWJEeWYra0FicTVrTW81VkJuZFhncFBBTUh0WkZBclU1OUZqbEVO?=
 =?utf-8?B?Zk9acy83Z1FacGVTa0hjTzl6M2ZoTEVkQm9TUG1HYXhYZmJrV01peGxraFZR?=
 =?utf-8?B?MjNIdFlDWjVCTXZaQVBMMWp0eHUvalFHdFc0S1VLV29tUHo1Um0rbit4T0wr?=
 =?utf-8?B?TlQrbndhYlUxU011VDVwUCtVZWc2WE9VblV6Q2EzaTJScjNOUERWb1Q1ZUtq?=
 =?utf-8?B?Tmk4a0NReGlOalZsRVVNU2djSGhSL1hVcmhiVm9KZTVZaDJ3RVFPcytZcWkr?=
 =?utf-8?B?b3V1bnMxQkZjTTlhTVJSc2lNZkxGUGdpbjIwZXRDUE9henhYVlhWdEs1NmtT?=
 =?utf-8?B?ZSt6UHhRbmJuNnA3dHRMRXBmc0V4d1FybmJwTnh6S2o5ejEvY3JFNkFJREE1?=
 =?utf-8?B?WDM5ZjR3NGl5U082Wmx3cGJLVDJVcDhzdyswOUJxK1AyOU1lQm9IN2x0czM3?=
 =?utf-8?B?eGFsOHJiSXltd2FGeGFJWWhWK2xnd09adnFEMUVVZUFMdmh5ODc4YjJKa1o2?=
 =?utf-8?B?M0dqNXlab256MDlrTCt2TDJxbUxDMHRZUjNjbU5ERmxIaS8xYVhMZUt6Q1VI?=
 =?utf-8?B?VUpnOEtXaFUzRllFbnhTVkk0TllEdFdQWXdhWWxQL2NodTJ3bFdrOWZCdTB3?=
 =?utf-8?B?ODR2YTExMmk2N3ZLTE1nUElYSTJQL3o3VGZsUGU4SjM0UktvT2FHbUlKSk41?=
 =?utf-8?B?U2doM2lLMWpYU3prdkJVdW5STVp3MDMrWllMVGJlcEpDb2Z6TXZQWlFha3Rr?=
 =?utf-8?B?ZDZBR1ZMV0RMdGpRSXUxYkdUTFVJamRPMWpKSitqbzgyTEwrWXRDZVEyY0lK?=
 =?utf-8?B?TjdTK3I3S0x1VEJqTlVRODBsSElEYkdwdGZvZW5nOHZCSUpwcTJlQWtJTjFh?=
 =?utf-8?B?R0prb2JHRmZ1a0VoaSt5V1FiUFRCOVRsaFNZUnIwcUlka1hqRlhwQzQrbDJU?=
 =?utf-8?B?SWZyaCtPRHg3bGFMb0lGeWVmNzJEdG5BVnhPOWJQVzAvVklxcU5iZkU4ZGhX?=
 =?utf-8?B?anpNTVJPc0EyMExOUnpqK3R5UjE5eVlEdStPNnlnT1J6alh1RkJ6MDRWNFZT?=
 =?utf-8?B?Q0tadktuOVFTaThwQW1Ec1N2bE5vNFpqZjRIQk1YdGV3Y2k3MFhLQmtHYmFi?=
 =?utf-8?B?RzI2aERTUDNxb0c5RXcrY2V5MWZudFc2dnJZYXBrYlNyck5uakpQM3NoL1N6?=
 =?utf-8?Q?guDeqYsr5Wzk+mOZ3M?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 58182013-49d9-4d78-82e8-08de7879ea0c
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Mar 2026 16:36:54.7698
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: o+DiMobMXELmGQkJX0f3CdVcW7ubLkIpQgVdGkylEagA7Q3tUChSNxR7k/h+4f8e
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB8879
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 52ADC1C0010
X-Stat-Signature: ncizyrf3b3c4rnnapchcsn3f6a9i9w3m
X-Rspam-User: 
X-HE-Tag: 1772469429-866950
X-HE-Meta: U2FsdGVkX19jtsofXGk6UGsBVGUNwDDDj+cN6UOeEQjl1VFeWm0+L3aWDApx54OgKYwh3rQZ5gPewTNagQ3nIDeGdErY3V3jaU6wfraf1YmItk70yLqFIVYC6g7XrFiz5eaIVoX0sJ4AOz+ykOBSpK5ndiJGPEcvT3wP6nUSo35HaGUjyiqlnlzor9UNXXBlCdkqioSO9R8wngd7U6bfsY+utp0YaKjVyx3AHm/VWyzoFxgsWo9CCc3WIrENiKZqDa5DZn5a16F85k41IrRXwM7S8o1tQbi4F38BYkADzDE2/UEGL+VGfMspGBDUJ4ZGO+b8q5T3C+8inzCZA5C1XYax/N176tXsRjkbyL0SoIX7yLTlWmn0rhDPczHeCNcLzwKux5ET2ClemULwqNY6sFvbJaMmZcy9+d0BoW/gMbtt+LrrAkBmP6bwhHtKMHGN1s2UiosjMmqfd+k1cyvQlaxUNwlJ0YiqniAE6/0/NsOjROYPc09zb+zLW1dlAPCLoh1VbS3Fan45L1cTIi63AFwPFcFLYkawU/3kTve3M6pAXvY4G2aCcQD9lqxWJJmW7U3uS1LuckBqnwjMJ0Q5v4em3T3ZAsS+JYyXFqK0uLxeY4nubOtIi4i3bqF2LqQ3pUFQBMBbqV262GaPwnACAwLfyA3E6MDZF5WZpwYpTy8OqcaCQnHF9VWcpZyp+SFw/Bsi2nraiSHkGyp3BeLCul8+byxNEI3et9foziSckQ5VpThUCcBAliXA2a3++kUkwmwfHyYNCrr0uEJVA1fbISpK5XDvYTg4pnmVKERLXlvCCx7dfg9xy9H4qLNAAV7qVEtVyv15zQohMzhb99eY8NK1MSfIINmEw3XsztbkWuH82n2Dm33cDdHVI2OgFvyT+rhmfZ4zwe3BR70JdhNkUb6jaVfojFTRlq5/WiNA4zPdhNHLrU06Q5Tm71CqEKoB4lNQ2+OCEbCGUbskuB+
 F8chbMsE
 EwMCsWXwE+BpIqkKvrUFMtrYdyXcdtE1ZxKLNA3JFehp8huIHibU7T6wUXcAeutUMAdEO25kpo5JH/NPdX9gu/6MQF42uKrXpj6wooO299Qt1gctG59QcPofLGZdUr2qvVgmsqLgjbo9p686ddfkzHP0u4cXN4KuxFztdThHMExHkZUsG3ZZWEFixjCqRr1s6BQoLMPno5Hizd83g3idivXPFhj/vWn7exA8scbP6X8wEQN98RJrsZGrWMkp+6SnqlNPgRhyLWrBQaDEMf6Pj8BwXBmT7CvpbHFBpxyLpjmaeATlvXC40P0LrRuzTPB631lFsWHzuDwxYG3+cjGBwhNJ2eOo2NaNOPYX9jhF1IBuD0yqWupRz5FuCJ7Jv8UTUmsktOUrVXeX1kJ8hPR5nyHXpmVEeeZ+sSV/5KQOwu89rFQciuGjZfX0r3+lxzUrwuTOF0JQggieldvAVU6oy8peUGpygU8AOJD48RFZAWADpEFRthUUivFDsB0G9uB4qFEk7WhcIH2GSoAAxmtL7YoOXYHOS2WjAb4Sgp04s6/0jr9Imyd3F2tlohAbVzmjiztqAHg/H3vbMlf9VVzr4GgwsT/mpLXuKBg2N
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2 Mar 2026, at 10:11, Lance Yang wrote:

> On 2026/3/2 22:28, David Hildenbrand (Arm) wrote:
>> On 2/28/26 04:10, Lance Yang wrote:
>>>
>>>
>>> On 2026/2/28 09:06, Zi Yan wrote:
>>>> During a pagecache folio split, the values in the related xarray
>>>> should not
>>>> be changed from the original folio at xarray split time until all
>>>> after-split folios are well formed and stored in the xarray. Current use
>>>> of xas_try_split() in __split_unmapped_folio() lets some after-split
>>>> folios
>>>> show up at wrong indices in the xarray. When these misplaced after-split
>>>> folios are unfrozen, before correct folios are stored via
>>>> __xa_store(), and
>>>> grabbed by folio_try_get(), they are returned to userspace at wrong file
>>>> indices, causing data corruption.
>>>>
>>>> Fix it by using the original folio in xas_try_split() calls, so that
>>>> folio_try_get() can get the right after-split folios after the original
>>>> folio is unfrozen.
>>>>
>>>> Uniform split, split_huge_page*(), is not affected, since it uses
>>>> xas_split_alloc() and xas_split() only once and stores the original folio
>>>> in the xarray.
>>>>
>>>> Fixes below points to the commit introduces the code, but
>>>> folio_split() is
>>>> used in a later commit 7460b470a131f ("mm/truncate: use folio_split() in
>>>> truncate operation").
>>>>
>>>> Fixes: 00527733d0dc8 ("mm/huge_memory: add two new (not yet used)
>>>> functions for folio_split()")
>>>> Reported-by: Bas van Dijk <bas@dfinity.org>
>>>> Closes: https://lore.kernel.org/all/CAKNNEtw5_kZomhkugedKMPOG-
>>>> sxs5Q5OLumWJdiWXv+C9Yct0w@mail.gmail.com/
>>>> Signed-off-by: Zi Yan <ziy@nvidia.com>
>>>> Cc: <stable@vger.kernel.org>
>>>> ---
>>>
>>> Thanks for the fix!
>>>
>>> I also made a C reproducer and tested this patch - the corruption
>>> disappeared.
>>
>> Should we link that reproducer somehow from the patch description?
>
> Yes, the original reproducer provided by Bas is available here[1].
>
> Regarding the C reproducer, Zi plans to add it to selftests in a
> follow-up patch (as we discussed off-list).
>
> [1] https://github.com/dfinity/thp-madv-remove-test

Sure. I will add the reproducer link to the commit log.


Hi Bas,

I used Cursor to convert your rust-based thp-madv-remove-test to C.
Do you have any concern if I add it to kernel’s selftests to check
this race condition?

Thanks.


Best Regards,
Yan, Zi

