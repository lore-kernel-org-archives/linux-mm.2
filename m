Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B4EFCC43458
	for <linux-mm@archiver.kernel.org>; Fri,  3 Jul 2026 14:46:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 99BA06B00B4; Fri,  3 Jul 2026 10:46:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 972786B00CA; Fri,  3 Jul 2026 10:46:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 861D36B00CF; Fri,  3 Jul 2026 10:46:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 54E636B00B4
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 10:46:31 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id CF59440121
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 14:46:30 +0000 (UTC)
X-FDA: 84947741340.26.A44ED2E
Received: from BL2PR02CU003.outbound.protection.outlook.com (mail-eastusazon11011065.outbound.protection.outlook.com [52.101.52.65])
	by imf31.hostedemail.com (Postfix) with ESMTP id 0DDBE20004
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 14:46:27 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=C2BebNDW;
	spf=pass (imf31.hostedemail.com: domain of ziy@nvidia.com designates 52.101.52.65 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1783089988;
	b=RbiQYM1D1fm6ZjlYOlVh79+W5fw0k9V6bBKoS8W6N/d/22/47xGUSzfWcQWgTYfFWzPWXB
	uRJRStLCtsZtFJj34y9wpOzrSq+EHtBBm7CQNBAgfAAgR2145CIgmd9HFKqdDa2quXeiYF
	txzoDwEKVwbnX3JKbS0IKIez213jctM=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783089988;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FJlMUhgOh72RiyBoYHgff4OKNcPspVe0r5L8CMzP07U=;
	b=fZr8yVGzmueS1cFXceej2ND1Ljqg/kaJR1E2hEzfPEeOtwiTpWphWlGuPPNzW739gbVwCS
	2XXDnMEhAb7+CTGNqnhVznDd47DxmIvnhc6pTpyYN8NPiLHU83zTdEZa6Kz6l+l/93QPMt
	WJiVc6IT4tbJ5Y1A1B4sCrGMZVGTPEQ=
ARC-Authentication-Results: i=2;
	imf31.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=C2BebNDW;
	spf=pass (imf31.hostedemail.com: domain of ziy@nvidia.com designates 52.101.52.65 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=odjhsngE6b0T777A5BeA7s1aIVGbjRpYCviOftY6jxiUeGyB/daDzm2efaM2ODJIv9HLVt2uwaXSLuWG3fPiy2Z/yNDqTQeEHGdfzfTj4KLlZSxBPobjazOecylqVKc0Y/C4mhvIdOyCB2dm2ZhKwh4j2XKNDxz3vpsfwTPo9lySy46p+qfvpeGqkJEGelDIxsxy8BqCXG4/VsQfGLbZYASsGqWdetHoYKVm+1pQNAVKf/orhZ/JfvmCgSAk4e1cxlxwbDE5EV/iKifd84MLbamzl1HWHVQVtLwv4e1cEz9wC5FktSj3Gg5aiYiWEcm4R80J11mW12VH7MxZzSYXQg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FJlMUhgOh72RiyBoYHgff4OKNcPspVe0r5L8CMzP07U=;
 b=ssotbu2rZP6VqZeOnSn7GewK6EM5JloiO55Swni8Vdr9ywprSeJxFT/fhVzMrlAxifKgR/5J1OgA6fiy7RfEYOAARb+bVq2vB7KHTjerF5ISCOAoCINQBI5otmKlFHXMnk8+IMkaNOqNpume/0z/0Ss2NjqCgMn//0YwjvCQqaDwY2jMnjFI2j4K/3H2gnzzdPCM+qU250pfl2sMMIr9h8woDXVKWnULyoWFJ4JfuDgM9APmAHmDPgJM0RBj1fNVmZ45lZr2YW2OQB3jGkfFhmPgCOmsG1giR9VEX4ZxnVM/dDgLauEburcP5pVxput+dxFzaz82gGNvh8OuxTSlaQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FJlMUhgOh72RiyBoYHgff4OKNcPspVe0r5L8CMzP07U=;
 b=C2BebNDWmj9LbHXQuAkphZjMR/3WCuPnaE/dFGjNSwWjQZ0MN3s7qcM+/5qeePrmO4CA9jpHPMcOhgyxQH9Y7Pv4R+SwFz4oCBakCG579WSo6wDU0adDkbeZXHAUiBLxOiKoXy4BX3Q3IM4goQU0SGdGLdW6iRRRz/36ifxlfJm5rdCInr5URsJD01mgVjWgKZ6JfCgTOs2BgTU6x9Eqz4AGEOk4sgRKigvPVy50jPLuNwJTfBYI+BiewvmrIb3goFN+uHrel0IrRKx/UdFNoU88C0mVA0ljk5jo9UDVDNyT0lxBjRpO5JfYaDjeQ0uW69YKZ2b7waRi/UiMriymyg==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by SJ2PR12MB7989.namprd12.prod.outlook.com (2603:10b6:a03:4c3::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.181.10; Fri, 3 Jul
 2026 14:46:22 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%5]) with mapi id 15.21.0181.009; Fri, 3 Jul 2026
 14:46:22 +0000
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Fri, 03 Jul 2026 10:46:21 -0400
Message-Id: <DJP0N91DMW61.HOWF4L1JTL70@nvidia.com>
Subject: Re: [PATCH v5 07/18] mm: move some stuff to mm/page_alloc.h
Cc: "Harry Yoo (Oracle)" <harry@kernel.org>, "Gregory Price"
 <gourry@gourry.net>, "Alexei Starovoitov" <ast@kernel.org>, "Matthew
 Wilcox" <willy@infradead.org>, "Hao Ge" <hao.ge@linux.dev>,
 <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
 <linux-rt-devel@lists.linux.dev>, <derkling@google.com>,
 <reijiw@google.com>, "Yosry Ahmed" <yosry@kernel.org>
To: "Brendan Jackman" <jackmanb@google.com>, "Andrew Morton"
 <akpm@linux-foundation.org>, "Vlastimil Babka" <vbabka@kernel.org>, "Suren
 Baghdasaryan" <surenb@google.com>, "Michal Hocko" <mhocko@suse.com>,
 "Johannes Weiner" <hannes@cmpxchg.org>, "Muchun Song"
 <muchun.song@linux.dev>, "Oscar Salvador" <osalvador@suse.de>, "David
 Hildenbrand" <david@kernel.org>, "Lorenzo Stoakes" <ljs@kernel.org>, "Liam
 R. Howlett" <liam@infradead.org>, "Mike Rapoport" <rppt@kernel.org>,
 "Matthew Brost" <matthew.brost@intel.com>, "Joshua Hahn"
 <joshua.hahnjy@gmail.com>, "Rakie Kim" <rakie.kim@sk.com>, "Byungchul Park"
 <byungchul@sk.com>, "Ying Huang" <ying.huang@linux.alibaba.com>, "Alistair
 Popple" <apopple@nvidia.com>, "Hao Li" <hao.li@linux.dev>, "Christoph
 Lameter" <cl@gentwo.org>, "David Rientjes" <rientjes@google.com>, "Roman
 Gushchin" <roman.gushchin@linux.dev>, "Sebastian Andrzej Siewior"
 <bigeasy@linutronix.de>, "Clark Williams" <clrkwllms@kernel.org>, "Steven
 Rostedt" <rostedt@goodmis.org>
From: "Zi Yan" <ziy@nvidia.com>
X-Mailer: aerc 0.21.0
References: <20260703-alloc-trylock-v5-0-c87b714e19d3@google.com>
 <20260703-alloc-trylock-v5-7-c87b714e19d3@google.com>
In-Reply-To: <20260703-alloc-trylock-v5-7-c87b714e19d3@google.com>
X-ClientProxiedBy: BL1PR13CA0290.namprd13.prod.outlook.com
 (2603:10b6:208:2bc::25) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|SJ2PR12MB7989:EE_
X-MS-Office365-Filtering-Correlation-Id: 42755317-7870-4dfd-d709-08ded911d998
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|23010399003|7416014|376014|366016|921020|18002099003|22082099003|11063799006|4143699003|56012099006;
X-Microsoft-Antispam-Message-Info:
	s8kynOSG+3Wy9ZHugfS54naWnWbSa9OKPU0peTlH31ztrJC9YJngAwdS4yhQGVO9S2iDU/8ucsLY1gdq4AWY/788fn91vRkwR0rOJRfT//3SH6fP9oAgPyF41jls+RZBeYt4fG64NGKzL/1PirTDwy9PAY+nUbQl4qWPY//69MtgZrAcWmEW+f6xsb9f97plYXkWhBRKyAC4WrL6vp30efOUaWyDWTIn0NYsDMao16vmrK3hfSOAMmIthgEgT/cfYoH2eQUAIynsY6cK+zF7aqWThVulkugmL1J+kfGOHNBOhzqEpOMM3yLETIabIQF87/iPRH39RUq+Lq4mcCAsH57cydV1/TMqqheXkDNuVq3/FPFMH3QKzKz0nbWnq3yB5WiLYTo/TTerBXsxfrZbcX63axhlrYY5xR1WnBIvoMTdRcQDKGXgBzdVjTRnrrpQEhPoDe0ZoOIUdYYHJNxlmY2v+06D/F6tdIAEsLgzYP5uSWOiH5KazEqJg4axb5RGa54E8+v5Is/z66KkVC+11gwoFIpadN03RnUyHMipF88/KJ9VPV7ReO3N36ui8zX8n6Ui/NZIKaQpR1sxoekdACcgo10/NGeDvxhxiGTKmUyInN0vOulS16++3+y66r+/EnSwplu90ck3TdcJBpwv6fmcwZz9CujoY2xKTEh6cVlcT+0JLBjlM0pB+XWMtmcUHBd6kaTpmOE0Jeu84KwOfg==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(23010399003)(7416014)(376014)(366016)(921020)(18002099003)(22082099003)(11063799006)(4143699003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?MEUybGErQS90K2pzWExicVMxOGkvWVp3dUo3WGphTGV0V1hYTFAvUVd0MDJh?=
 =?utf-8?B?QVJiY09JbVRHUnpvcHE3cDMxejhVMHR1SG5lSS9raHRzaXg4ZW9HQVVLSHl4?=
 =?utf-8?B?V3hkL2g0TGJrMTJvNDVPQ0d6UHpZUU9ENUxjN0VUcUxMUUl6ZG04L1dHU0tR?=
 =?utf-8?B?ZlJ1K0llQXJnT1lSTjhLVXB0djNlRm9HY3BuTXduVm9LcE5oRDVPM0ZQSnNn?=
 =?utf-8?B?Z1YySVNpajFrcnFBOExKWFNMOUY0K0ltQW4zcW53SHRvV2tqczd4Ykw0WDFy?=
 =?utf-8?B?SjNScS9qc25mSkwrWUQ3V0tNV25NUm5yN0t0T25abTdXUlFnMnlKR0JGKzlp?=
 =?utf-8?B?VUFoNzV5MFB0VVVEZng4Ynhnb2o3bHdEZjJpYWNhVlQ1UnM1NTRvUnBWWnRB?=
 =?utf-8?B?bmF5MElVbHRxLzk2b29hb1k4RDZmTXRQVWp6TTdMR2o0MzdackkvZElBclE3?=
 =?utf-8?B?N1NSb3ErRFVCWXFaWmRtYXZydnQ1NjZHZmdFUjJsRGhJVTVrRVgwTVNkUFRR?=
 =?utf-8?B?d0gzNE00OXdRRElKOVFhRmNCOGRxMWNuOUkzRklDZkdmV2xSV3BjNDg3V2kz?=
 =?utf-8?B?SnJibVJ0R0xqZnRWeXlFamw3VDhickI4QWdsVXBHaTcxVDlUeFpFRE1WbkRa?=
 =?utf-8?B?L0ZKOHNQVGRZRHBHVFBFdGJZTW9IbERQRlVHQTJpWThqdUFseW5lZ1NkOUlq?=
 =?utf-8?B?bzdBYzlhN2kvWEdySitTQS9sVVN6M0Y4MWc4NHZYc1B4UncrVFA2YlJ2MmxT?=
 =?utf-8?B?ajBuUVVKd1pWWUF3Q09oZE1aZzBaRlZrMkdyNE12bnA3ZVBTc29xUWovZUJZ?=
 =?utf-8?B?Tk45Q3FSRFdFZDJ0QkVuNDRLSXpYVmlMdDBCK0orVjFPeER1eS9hSDZXTXFF?=
 =?utf-8?B?NlA2SXhEcGhDMlpqbHJYUUNoS29ad3I0T3AxT0tnNlhkcEVmdzBpRTl0K1Iy?=
 =?utf-8?B?TU5PS2FGN09od3k2ZHlsR1VTVmlDcXJpaVJUc2xYM1JtdCttc1NpNEN4S0hx?=
 =?utf-8?B?SjI2ZmZBNmNTQUxkMDNhR1J2M0pMOUlCYUFXMmpvUWtmd0RNK0kvR0VqbFM1?=
 =?utf-8?B?a1RCZEl4c1VkNmh6OE5TdjNvZzZaalBZQXlmU1NLeXozbkU5Q2xTTzJnUThv?=
 =?utf-8?B?TVBqNnZ5djBMOU1lUDJpV29FSStibDV0T3Z4N1lwbUUydmR2VHVUUTgzSzlh?=
 =?utf-8?B?TE05MkF6bFg3UmNoMWNUMVdMQ3VQVkN0d3ZiUmcxUE9ta3dSQmNUSGtzano2?=
 =?utf-8?B?bnJtRDVPY1NPZHh3M01DRzhSUmhoREhDY0IzSGRDQWR6RnZDdVRHUGdsanFE?=
 =?utf-8?B?YjBnT2NGU0F6V1p2NlNBcUFYVjI3MEg4VVhXaFNCQURCN2dDNWc1NGVRR1Bs?=
 =?utf-8?B?YjdqTUZFeEdEYnRVaEVSbGsvaU9VcmRkd0RPcm0ydzJhOFVJY3NvYmZQTGZ3?=
 =?utf-8?B?bkF6c1l4VXVTOElmdnRGa1NIZ2pRNDBhOFVWQTJhTEtid0hEUjB3SFloTVRM?=
 =?utf-8?B?a05ja1RFWW1WRTZxZk5XTDJ1M2lJamJReEhmU2c4RXIvNE42MDhsQWlyU2I4?=
 =?utf-8?B?OXFjOU1GZUdCcTBsTi9sNTlDKzlheUFWREt5WmhKRWJuSmZzYTZUMHlnS2tr?=
 =?utf-8?B?T1BhRmN5TmZ3TnlQMUJkbUdsQUJ1QkFxd3hBOFVzQWZEU0xuMVVsR2NvRkhh?=
 =?utf-8?B?S2UxbEhvTmswcVVDQUJmckF2YmZ0WTVuaFh2eUhYY3NCQ2NhQkU2TElNTEg1?=
 =?utf-8?B?dXltSVJjUVNvT2U4MUk1ZU5UMWNwN1RERFJXaFp5K05FblNUbXhoUkorS3B2?=
 =?utf-8?B?SHY3T1VISVV5WndPMnNaU203VkdVNzR6TnlwSnZxMUZLL20rb0dNKzYvNzVL?=
 =?utf-8?B?d0ozWStqSnY4U2dvYkFvcFBUdUc4ckJSVWl5NkZPUnd1ZkxCaFg4VGR5NEdy?=
 =?utf-8?B?T0xCZklmUWQ5aFZ5Y3VqaTNzdCtJaVFHSzdkZnlSdkhGaUFDZlJ1djNMQkJQ?=
 =?utf-8?B?YUhKVDlIZENhcFVaTzh6Nm4vTS9RVTllRUtZVkIxUWtRdDQ1NHZGNldJZG9j?=
 =?utf-8?B?YjJFOEtKbVZreldadm9sZGdxaHNWdTNIa2VYK2Q4QzBOaUVpQVZDekJOQ1Zl?=
 =?utf-8?B?N0NETFlnRytJUWFIUzA3OFI0Q3cwOWE1bG95TWpqVjBCS0R4b0pHVTdkbFZx?=
 =?utf-8?B?cEJGdWE2VTAvRy9hNGZ4OGJFaERIbEI5WXFtVm5hTHZyNERiM2ZFNXBJSVZj?=
 =?utf-8?B?akVLamVyYnc5TThJbmt3ZSt6YitzdTE2Mnh3MjM1WE9lbkNIM0syS1lHNjdu?=
 =?utf-8?Q?m5B32Mb9Lh0NKoVz6j?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 42755317-7870-4dfd-d709-08ded911d998
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Jul 2026 14:46:22.3043
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 94wohbc9C6m07VHAQly69FAkRpPHSbj5TW4TCQSnAg8XZC1kOfe3y5Wde1SCv0Av
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB7989
X-Rspamd-Queue-Id: 0DDBE20004
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Stat-Signature: 5y4uiyq9gkgkj8ji5e4unmrf7k919m7n
X-HE-Tag: 1783089987-293403
X-HE-Meta: U2FsdGVkX1+LUIGevYnCzYhQfIraeXU/UvcS6AcCIjdhziPYgzkrZU8P2TFE7sYy5H5eWOk7Kols0Ewzet82olHm5ImEGgnBcIH5n4lEOHW5aRiqQHn1VrRVMIQ5nBPwMTZczXn17YeLkVI6StUpjF+jvdyysRNZ+sh5e9WivQSTAxDxakIqYY2aGvYEJF2au3Pr7jXt9b1r7/geqRheTo4mLKa0SdzNkdZV2OgDgH7TkF9+Nf6WpUC82bW/kkUtiBEz4xm2wyDImEA9hdogh5ujt21d73uOUN757P8szxqtfJq8drOf1gOfB2VuHmbxqxAsLwGlL/q/RjtksfH6XisJWK0rJXxoVq6EkAc1ElyF8Hkzb4tp23HLcunLgn7sB4mOhkyZKQeO69FENMLgVeR6V8v0zfIi1MJlmJMSjkRzehif53chYrB5DXNJmFjeq4WJvL9MwOSpxQW2YzeF9EHT4AAtlHWfl3sMMriZVycyFdMEV49BJ/Z8V3oSl/x5Ks/x2KLjaN0ohbK+UIGyMxUY+0Jii59NEIaIz462SgsZpvpY0DYE4OgWs2NlVJdg3iqAT2btIVfTFw5ynsw9y8te0Yq8dBIqyxrfwJ5G7Uwn+Q5JFxNmP0onIZKpHH7P5A/A18vGaIQ7sFjYc+nOCbO/BVLRgyMdWJsZpfZ/Kw7kWZtW2ouHp4PBmEjUr0neD2MDavuMyBhDkiISX1JxpXjeo/xU44YrF257L3aOcifl7mp/k4rKCRwtC7EhUpgy+B7g36ubmVSvy3j+bGr83m8Hc3Ma9C/69Gr2PXdgHHHy1Q17N5wo9HE9id/epBi/v5bfOSZpe0QgHUey3Zg1jrYfueOP8FZOvj29QbDyRpwogmQeriJWGsS7blSi5xo3qshxDtJjCsjwrEhjqNMKxpm4jlLBzVvLbZyLLKO+Mn5ObLk1JD7A1bqjLeRAtiEB3IUuqc85wARcDO7uN5q
 myG4eogi
 P2P7hWQuVxxVF7o2ekBBzOi4PK5EfnEYvPI5jr4R0ktHR3hpfsDwHywvYjifAiGAzGtMFMA0A81lV37MFrNx2+toYqn/4NgyHS2jI/7K4OAQskrWy2s1v5i9xaiLQVcrky2rmTntuJt6VV7CbtlpQurU2k9vCFIez6D3VQEweQugkzA4FFjNHf/1VEriAKECulVInCsDFL+GK22NQPWx8dAlTIK7xETgUkKrHmz3aGvE7g71AjBv2VwmtFRPYl7AvYAhaZleXw41di6CWoVvONRi+e0MzsLKB66MU6ea5t0QRRz+HFKT/p0Pt3uDX+N/2NJJlPTZWEuk/jqLMAAM0DtJ8PX0MpLZ2Sb6tg1C8GugNDw2mr7kd/FE8ZEY7g5vCee8KNB5rDgodzu0+CLY/0vMOiv+53MUHspVQD/ChhJQsikxhjJlJ+d0aIygGmmgbag4pnIP6KvEQXrAPtNp8ootXau1NqtHdn7XefnFkd8XAGZ8DCuoQlJWHcu32agwSLtSpFOUdjQW6AGqj/t+x0WdSryK2uNi648BWTmAYC3KxPqCbrHj03FDYZV2kT2FQbQ3OUKpeqB8NA+PA0waR65cd3w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri Jul 3, 2026 at 8:31 AM EDT, Brendan Jackman wrote:
> Some of this stuff in the public header is only used internally so
> shrink the scope to avoid silently growing new users.
>
> drain_local_pages() is still used from kernel/power/snapshot.c so that
> needs to stay behind.
>
> Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
> Signed-off-by: Brendan Jackman <jackmanb@google.com>
> ---
>  include/linux/gfp.h | 26 --------------------------
>  mm/page_alloc.h     | 27 +++++++++++++++++++++++++++
>  mm/vmstat.c         |  1 +
>  3 files changed, 28 insertions(+), 26 deletions(-)
>

Reviewed-by: Zi Yan <ziy@nvidia.com>

--=20
Best Regards,
Yan, Zi


