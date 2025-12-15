Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3CA5ED59D99
	for <linux-mm@archiver.kernel.org>; Mon, 15 Dec 2025 06:11:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9DCD86B0007; Mon, 15 Dec 2025 01:11:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9B4686B0008; Mon, 15 Dec 2025 01:11:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8A3506B000A; Mon, 15 Dec 2025 01:11:56 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 795566B0007
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 01:11:56 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 129CABE4DA
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 06:11:56 +0000 (UTC)
X-FDA: 84220684632.16.B6CA3E0
Received: from BN1PR04CU002.outbound.protection.outlook.com (mail-eastus2azon11010030.outbound.protection.outlook.com [52.101.56.30])
	by imf11.hostedemail.com (Postfix) with ESMTP id 2EE7440009
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 06:11:52 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=iiCd9r98;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf11.hostedemail.com: domain of balbirs@nvidia.com designates 52.101.56.30 as permitted sender) smtp.mailfrom=balbirs@nvidia.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1765779113; a=rsa-sha256;
	cv=pass;
	b=el8JehKj0LKM8gNOHjFS36MCMkdwpXAYHSutKJhWxuQyUCjfp01b3HVHCHi6KhaK6Tlpt3
	QrQEqpcJw0KjOxtPBOUzGhcgPa/XGKIvwt5PfslAcwzkwLQD+W7NBl6aeFAhkn7/Ad6XmI
	NUKmf8jK/YUs3k7Q1R3aSZiP4z/4AD0=
ARC-Authentication-Results: i=2;
	imf11.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=iiCd9r98;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf11.hostedemail.com: domain of balbirs@nvidia.com designates 52.101.56.30 as permitted sender) smtp.mailfrom=balbirs@nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765779113;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SvM+VF5Tk57sfO3VE82CIAGuoDmtUArEph3EeqXoeSA=;
	b=sNfqKs12E9LqhV1MbTzuVRwi8sfHGOMYm0EPIqyX+ArXHpqz8bPPY9HRY3776ck2r5jLQ2
	dy4zGYRReo1lnPGd7sml97/irL/OXD129vFNrbm3NGoHt8EE3+5viAO0gVVmJezQbhq1uH
	X6xtG1lU8JSdM9zk/ZW/80QA70pnAa8=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=LgLYhRDPPSiXyslkbmY8mKzVdDZh0Kna8dQvjFUX0A1n4HGVQ32Vbw0wUToVdjB842vz4knBfN9mKv5teZ3d7m2jTekLN+2vtYy2ew/G6Xapg8eIOg8OXAh/LMf58IHNYpbi1D8Z5rFmjd+/2nnOxfsAyYh1xV+dWEST9jBZQOfyMgELTlZCPuZL6oJhufuLGct0IThL6e3HLJGeM/7uTkz9PXAQFSFwCEnpGTSVjz6eGfbEkwNvJOOu/IAZmWd/RJVA9XQc3O2bC9hif5w72QEgX+vWukNZSoFt1Tt3vZ/712PzhQ1tRkmTGA+sTPx9rDExo8DevijH9fyfGPaWhQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SvM+VF5Tk57sfO3VE82CIAGuoDmtUArEph3EeqXoeSA=;
 b=E4VRT5mSWV+tWwWhfjEE1eerdLpiJ5siDrI1JNLJPtl0OC/cqMFTxtOdKydgizz3/iV7tCAJj4HCdQxWjzM9ZMHtC8d9EjkemAprMp1uVOydDGOTDkgmi4KkCNBMPbVeNQOzAF8QLrp/MhXhUIx3nqu4wh27Z7Sy9FBtBZTFOXOUpCqBRb0JvHYQO6wPlO1mJ8I+9+scQNubV8coyOgD5/uNg3whV+emMkGfPeANqMu7grhmxXHFZWyTlLaIm1J+N3lGf2YwS8J5Ha7I6EmUaEKs1v6gYZx/naNegukXx1DY9dvMhodeEeSxo2DwbW3nlV9ilEfSmCfImAL9SO5E+w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SvM+VF5Tk57sfO3VE82CIAGuoDmtUArEph3EeqXoeSA=;
 b=iiCd9r98oS6n8MaQBdIF8SEmPjlAN2EQSR/nGaF0xwnh4Z3M06LKW4Rv60gxFwZxdSD8FQNvRoKsdcl0xcSDZZrMJZisVKJcWZhlU6eNLWWlrNhcjzygaetKRTQSmjdt+1Cf+Cs+U2rEICdgx5Mg36OfOHvpXAP/y5UqTpcSJHdztn1L5NKHYf0Dss/kgQXCkhIIY8bqlzw62Ra3fGPThIYOCcC2zdYaRQFdJ0GZhWOW/6KgaP9swhkGP5lBQo4VuKYqg+ba6m7v44SUtgLIyNWSG6uvlGrblTavERd4VNW7IIvmP5xtf38PuDumC46SrRLuSy4Dku5k74rWmRKeLQ==
Received: from PH8PR12MB7277.namprd12.prod.outlook.com (2603:10b6:510:223::13)
 by PH0PR12MB5607.namprd12.prod.outlook.com (2603:10b6:510:142::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9412.11; Mon, 15 Dec
 2025 06:11:49 +0000
Received: from PH8PR12MB7277.namprd12.prod.outlook.com
 ([fe80::3a4:70ea:ff05:1251]) by PH8PR12MB7277.namprd12.prod.outlook.com
 ([fe80::3a4:70ea:ff05:1251%7]) with mapi id 15.20.9412.011; Mon, 15 Dec 2025
 06:11:49 +0000
Message-ID: <e6053bc9-f027-4abb-bae7-fcb254e04913@nvidia.com>
Date: Mon, 15 Dec 2025 17:11:34 +1100
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v2 01/11] mm: constify oom_control, scan_control, and
 alloc_context nodemask
To: Gregory Price <gourry@gourry.net>, linux-mm@kvack.org
Cc: kernel-team@meta.com, linux-cxl@vger.kernel.org,
 linux-kernel@vger.kernel.org, nvdimm@lists.linux.dev,
 linux-fsdevel@vger.kernel.org, cgroups@vger.kernel.org, dave@stgolabs.net,
 jonathan.cameron@huawei.com, dave.jiang@intel.com,
 alison.schofield@intel.com, vishal.l.verma@intel.com, ira.weiny@intel.com,
 dan.j.williams@intel.com, longman@redhat.com, akpm@linux-foundation.org,
 david@redhat.com, lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com,
 vbabka@suse.cz, rppt@kernel.org, surenb@google.com, mhocko@suse.com,
 osalvador@suse.de, ziy@nvidia.com, matthew.brost@intel.com,
 joshua.hahnjy@gmail.com, rakie.kim@sk.com, byungchul@sk.com,
 ying.huang@linux.alibaba.com, apopple@nvidia.com, mingo@redhat.com,
 peterz@infradead.org, juri.lelli@redhat.com, vincent.guittot@linaro.org,
 dietmar.eggemann@arm.com, rostedt@goodmis.org, bsegall@google.com,
 mgorman@suse.de, vschneid@redhat.com, tj@kernel.org, hannes@cmpxchg.org,
 mkoutny@suse.com, kees@kernel.org, muchun.song@linux.dev,
 roman.gushchin@linux.dev, shakeel.butt@linux.dev, rientjes@google.com,
 jackmanb@google.com, cl@gentwo.org, harry.yoo@oracle.com,
 axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com,
 zhengqi.arch@bytedance.com, yosry.ahmed@linux.dev, nphamcs@gmail.com,
 chengming.zhou@linux.dev, fabio.m.de.francesco@linux.intel.com,
 rrichter@amd.com, ming.li@zohomail.com, usamaarif642@gmail.com,
 brauner@kernel.org, oleg@redhat.com, namcao@linutronix.de,
 escape@linux.alibaba.com, dongjoo.seo1@samsung.com
References: <20251112192936.2574429-1-gourry@gourry.net>
 <20251112192936.2574429-2-gourry@gourry.net>
Content-Language: en-US
From: Balbir Singh <balbirs@nvidia.com>
In-Reply-To: <20251112192936.2574429-2-gourry@gourry.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR02CA0046.namprd02.prod.outlook.com
 (2603:10b6:a03:54::23) To PH8PR12MB7277.namprd12.prod.outlook.com
 (2603:10b6:510:223::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR12MB7277:EE_|PH0PR12MB5607:EE_
X-MS-Office365-Filtering-Correlation-Id: 4116ccc8-88c5-4b6d-e831-08de3ba0d545
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|1800799024|366016|10070799003|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?aUo2L3h2ZEVFTExnUnRSSzkxd1duRGpQenZkR3pEY1YxM1dHdFlRNWpxZmY0?=
 =?utf-8?B?L3I3S0w2Tm0vaFhhQXVlY1ZRL3ZuRlQwQTRWemtPaUhCSk4vb2txR3QwdjFy?=
 =?utf-8?B?Rkg2SWh5cVpESEpEb2ZqY0JXdVhXM2poQWRhNUQrblJETHMrbkdkNWl5VWtp?=
 =?utf-8?B?TnNVenN5NnVQa0VjQ1p1eWV4VG5FODAyL29YQ081anJvYmZQcWRGVnh3VU9G?=
 =?utf-8?B?NTlTTkFRbUFVSHJMVkN4MnZ4ek01RVVyMjg0akg3dGFHc1kzMVI0eG41T2wy?=
 =?utf-8?B?Qi85VzlhbmdVdFJQUTk0RXZidlhxYUpTL0JNTWFCdG10RzFKK2ZSM3NVNFUr?=
 =?utf-8?B?TmZ1RDFmK3BDQWdjaUxOQ1kvaEdjQUxKRVlrV291eHExb2kwZlR1Umlsdzcw?=
 =?utf-8?B?bFpQZnlKandpUnBUbzNibWhScmdWYmRHQSs3SlpuelU1b28zMGlYSldXOWw2?=
 =?utf-8?B?ZW0zVVZKMWJCYSt6bHNRbU1VOGdpcmxidnZDYTdIa0dwdndFU1VBY1dtTktU?=
 =?utf-8?B?R3ROY09Rc2FmOUQxZTRsNGJkQU5kNXF2bXpVck5PSU9uU2crejdIWWpLOXhm?=
 =?utf-8?B?V2phV0o4OG1JMVpsUU9tSWowaHRGT0RjRWl1NHd5VmhKK1N5Kzg2TWFIYXlN?=
 =?utf-8?B?Z0o5dFlib3lEZDVOOENqajhISll4Wi8vZDhQWXRWYk54WDZLbCtmUWk5MmNu?=
 =?utf-8?B?Z00xVXYvSWh6bmlvdC94SFJXSzcya012bWZaMmVQMkU5ZHpuSnNtLzFsUEtD?=
 =?utf-8?B?NllpanBZVzJnTmFZZ1hSZ1AvU1pjSFRRUGhiUUZ6RWRFWkpiaWhPR2NEcTIw?=
 =?utf-8?B?NW44c0xjRUlVbFlGM2cycHZEb0VGaXAvV1JjeFdtU3VGT2RBekJUZG54QWVR?=
 =?utf-8?B?MHBxZld2eFhIanVsYkZzOVE0b1Z1M05NdUlCNk5oU01Yc1RGRGJpMEk2Mk9j?=
 =?utf-8?B?Z2RxTlBXMml4TUdSZkFlSlFHU0RQbG54ME9SZm04SnZud09hM3RpN04rYjRW?=
 =?utf-8?B?VTExU1Q0UFQ0UTE2YnY0RUp2dkl1SGZ4M1ZhM1VROHdXdVk5NGtlZ053SkJ1?=
 =?utf-8?B?U3o0anlZc01BS1JtUnMrYzcyVVVlTFhhY3VLellDLzlvcjY0YzB0all3UElh?=
 =?utf-8?B?cXV3WGhCSlRDR2NrWlU3alJ0OTNIbFBFZnJQL25qOVA3TEovYTJhZUJwN2t3?=
 =?utf-8?B?YW96Z0poRURHUzYzNlNWTjBiL2FtUkpoRXhCbmVOekptU0V2eURYK3V3MG5X?=
 =?utf-8?B?MnZRVmU3amRUeVduRVB1dGdQR2M5RFlrUHhGdmN3MFRSR3JaVHRXQ3dQdXFN?=
 =?utf-8?B?MURpZFNTaTlkeXdHcUZPK3VCakdjWEkwSWsvRHNoR0NNcTFwUk05cWlUQjlm?=
 =?utf-8?B?VHEvSllzZG41WlFWZUxlVkg1Tno5U1RTUkhOdithUTNJYkNsZU84RTJkUTBh?=
 =?utf-8?B?WXpnM3RMVjBscVhMQjlZYXRmT05nOFAwQVFqNjhueE5lUjdIMXo4MndlTytU?=
 =?utf-8?B?ME9EcUdIQWs0M1EwRjFGYjJBUVRaNThya2tFNDNldU1WdGpodTByTEk2WEtG?=
 =?utf-8?B?U0xQeTR0bGhBOVEwV0l4YXFMY05FRGVLVnRsQ3ZBQUNKbDg3KzMrbEdsTWl3?=
 =?utf-8?B?SmcxYjdFblhYbHZIR0NDcUEyNUpmdUZwczdTNjRqdkFyZWJtdVFLVjQwRXA2?=
 =?utf-8?B?bWdIL3BGUTNLM3pVR2xPdkJqNDBoQlF2Y2ZPU1FDSStkT0lxK0xsQXBwalZv?=
 =?utf-8?B?MUhWWURjN21HRWtMNHlla1lINGk2S1UzWWRDc0hYbnRybXVTTnlHaUM3TkV5?=
 =?utf-8?B?Z2pKUjdJZ1pkQTlieUZCMUlneVZQUDVBWkJ0c1YvcXdQclpHOEFNVjByZ3hT?=
 =?utf-8?B?WEE0TVJIQml4Qy96K0s5T0lqUzd3bFBnNFBrUm5BNDJwSlFVQjNwQTZxYk9J?=
 =?utf-8?Q?VHZ5ZsJa8IBD5DgN7SNU30ILV7Nv+xG3?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR12MB7277.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016)(10070799003)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?ZVFqbjB3c28yelVta0NLbHk2RWxZMExlUUhlYjl0V1F5STY2VlYxd3JMcUww?=
 =?utf-8?B?YVJMYVdOOGtPZFM2NDhyTkxTdDk4OFBwQlFSUmJiajJZb2FLdEVhWW9DOTRT?=
 =?utf-8?B?bjNiaGZyem9JbC9rRkxyaHFTZGNrTmZ4dUZ4NjJuelJGd2p1Qkl5bGRlK21a?=
 =?utf-8?B?SzlsSXRGbTlyMGQ3dHorbGVvendPMFNjU1JBcVh2UXVaVDlPSGU2RURyV0hS?=
 =?utf-8?B?RDA3b3BUWEp5eEZXM3ZEVGRGeUNsRTVMS3p2VWhsaGU3ekVkTlM1VkFBdlVC?=
 =?utf-8?B?dTN4U0kzTnZLbkNGTHpsZU1sbndOWkh5QkpxaG43b1BTeGhVNUF0d3NST2p6?=
 =?utf-8?B?Zy9zOTZsWDg5Vkw3aHlVSEdLVFZYNlVLbUxxdVBsQmhJaFl6cG5XeWN4T2Qy?=
 =?utf-8?B?bVJ1YnlvNHRvaDVtSFltell0eTh1QmJJN0I2aVlNdG1Ob0RUQ1JncmtLOUhF?=
 =?utf-8?B?dTdES2txQUVQbEZ2NE53clF3YmlxMUpGc3IxS1RROGFhMWlleVY2MkEyOFFH?=
 =?utf-8?B?WmpDWUZLRWJwVVR1MjFjT2I0VzVicmtDeGZXQnZLSDlrWVNGMFlIczVtYjkz?=
 =?utf-8?B?NDB0WElpSGl3ajI1VE45TXZMS0FtcWFqb2dQSjlsM2YzN2NFakErc3BLZndk?=
 =?utf-8?B?YUNDTjM5eW1qaGlJamUwUklQSm9yWlFLbzBiL3VtQVdqaDNaZVlzVG5lUDFE?=
 =?utf-8?B?cGJndjBkQXhsc201RTNYT1Z2N0RLNHBFd0ZRalMzL1pQbi9kMWNCdzdra1U1?=
 =?utf-8?B?eEpwNUdlTnYvWUlXV0QzanF0b09BQ1I0S1NENFVrWE1YMS9UcTBmOHArWHlU?=
 =?utf-8?B?Y1FUTGN3cGFTa29aOFQxWFZ3V1NpUXljbFlzM2VyZm9yTkJYNzRDK1ptVDgr?=
 =?utf-8?B?Z0RMQ2ZORjJTb3BBWjVLYklKKzhqSjNtU1FVcEhtek9HdmZJV3ZTM0J4aTEx?=
 =?utf-8?B?dkFScW13YTFHcHRsdTNmZ2F3Zm8yTFBKQ1BMNmdRY00wUk5rYXFhbnlQeFo3?=
 =?utf-8?B?eFhoOE5TZlZsU0VsU2doUFlqYXlxOHpYUlNJSnBMQWw0TlIzSHkzUTBzQzdR?=
 =?utf-8?B?YUorVXJxU0R5dkF6ZjVlOTloZUV6Slg5K0lIMEQxLzAxeWhSRXg1VEZTVDJI?=
 =?utf-8?B?bGRLTm9MYmovUGZNRXlBc1VhS0U2NW9BNno2T2tOWk85SGpkZmErOGZHMkdT?=
 =?utf-8?B?Q3RxUWtxNjhkL2FyaWRHQ1R0K3kvZnpIOCtDVTRPTndya0tmc2pPUDhScUk5?=
 =?utf-8?B?QzVqUzJLZkRvQS9jSWJJN0E5MlR4bTVCWWtsTUpxUzQ3NDJrdXVHTm9ha005?=
 =?utf-8?B?UmEyY3h2TEgwNFluZG9qMGFjbzVveDRvR09DSnovcmp1dmtaQ1Y0cWdZdzBY?=
 =?utf-8?B?ZytxdVR3N1V3YlVkT3RuWCtiMjJsVU9oNjQxckt1VWtveldVU0QyTnppdWsw?=
 =?utf-8?B?SSthWUdtWXQvVjk0ZjdoTEtkS0lxbWdxWVZVdXZWVmhvUkN3bHhHNTNlTy9B?=
 =?utf-8?B?Mm9xNkU3WTFEeDFGQXNFR05RTzRIb1YyUTVnS2luRDRKZXFiUEE5aU5EeXMz?=
 =?utf-8?B?NUR5TUJzcUF4OFpPZUNoRUlOZEpUcjlSbkN0SFFMa0Nvbk1lcFRhSkVSMXl6?=
 =?utf-8?B?WW1YQ25PcVVzcmFacFBkR0trWll1WjZmUzdlOUlwb2RONjJqR3huSmkyaXNu?=
 =?utf-8?B?M2xpSEJTTWVPYjdVeFJIdHBjNS9NZStmY05qdmRCS2FxcUJySU9WQlRzUFZY?=
 =?utf-8?B?bDJqNTNoNDJUNFd5VjVYeEpyU29mZUpkU2FTVkVGK3dEWTFJeEpYeVhuTXd6?=
 =?utf-8?B?VUkwM21Fci9lZDFFMk1SaHBFTWFpL0hMMnRRTUI1OXZsejdhR1poWDAzNTZu?=
 =?utf-8?B?M3pFbCtmcEhhakdmbU9QM2ozSVU2U1h2a3pkc3lwU1ovWkZkOGVkUVFlbHVC?=
 =?utf-8?B?dUV4dEcxR1ZpQkFKUlVxUW9DaXNocmJudUJveEY5ZDhBWGVPaDllaDV3V0hJ?=
 =?utf-8?B?TUwzOENlejhOS09KMXZWM2M2VG1HTkRUWDVaUG92UHF1eURoN3hsdHFGWHA3?=
 =?utf-8?B?a1NSN3BKY09BcEIzQ3ZBZEJ6UnpLbnpWdkZFaGFQZEtVVFpFVmhobmVlRUdJ?=
 =?utf-8?B?VnRDZDQzenZCM3lSd1NyMG5tdU94U0Y2bzVGV20rSi9uQjBPQXFFWTBVcDVz?=
 =?utf-8?Q?gg1JCcwHDHkAY06UO8G4Jz8I4x7V9ei1mW/Du1Mpj5fg?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4116ccc8-88c5-4b6d-e831-08de3ba0d545
X-MS-Exchange-CrossTenant-AuthSource: PH8PR12MB7277.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Dec 2025 06:11:49.3697
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +OrI0foLEK7b1lxpf1gUVzV4P+uCMFW6mOBt2WpoN9TpgSo6qwASnrMoLGR42z0KalWnBAS0sS11s8aar1LO+Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB5607
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 2EE7440009
X-Stat-Signature: 1nh14tz1qup6do4xefbc7e9ycuaity7h
X-HE-Tag: 1765779112-300407
X-HE-Meta: U2FsdGVkX19o1piF0ZoYUYWS/cwOe9tJuWYS+bYQmJm6SL7SEoeaUD9RgoznpQd4SP3bcX0CVPdqU8YprdBpFAzjY2eJpK3wDPvGWPABv313SMysQ08JKHnJzg5AEnR6FIW96sOm9xQ1EDAi4f2Z2U3IFneodBRzaEPAl8cSNBkuREbWKeXmkve2gS4JlhSwZd9lPLPwFsEebkyXaer9KYsFdpWihe2guaPuoV/GpgxoUSg6HHWDCZWKzpRP7UtlUfwQfm1JXvgP5GF5HqTew7UfQepVxaq+K2mRS7wSl5aSIych4yqj5kxD5Ir9QKLICUX/3/rzM99i6jrD64fLxoFFtBfdFw3OlH2dKRz8nR/cYSSHpU8PmvQ1BnGdWpzk8BRB+OhTDvQn+nzLuQJ0L7VUfZdTFCBk5sHxjksstGtA4p7CbQDsznaR8k5csHE7yL+ydv/BCSxD8lPNm2Fa4LHpywPsFGuHGE45SRexb3gXZd0tng8YbRLtZlAizKRGWC64OVbb3DwXlI+YciTp7Xky+Sr7LXRhn+gXwGKbK0wLMy47g9wmVfv6/DgjqZJNq/KKiXsjFx704WIXCqXY15M2d7gcQlY3mH1Mk5JE9UKACorkyQlngF3ok6CCnzv25FPr67iBqnFp/tjVU0NSWPgxamY7K4iDn+Z9ZXMc8sICDdSMfiuXHHXf26nQA8z0HSD4l+r5LaoRo60w/uBv/rgdBKtKVT60TuR6bUwKg6z82q0hKdu/f3fqxgcOImLL9eLQPu1mGVus2X7da8JB8LMvhfL3XEXN9UEVgM4uNO3V5CQ1BjvtZmnXF0m5UOwpYyLp/qjxFOknVIvNUk57d+FUZb0Pu+Ij1km5mgpsZyDlrgM3Rg7bvOaPSw+wjI6wV0tS5Em5eLi2BGk8JOhvRKREqGXDQ8Ov3WSvB1uHjeTH7DBGbC1l8o2OkYb0E8cCXEiGczerPF+ZeqUs9Sz
 bK0CiiIk
 m/IkVYyGKfQGhccRD/KlCn/gl6HGrM6pMw3uoC0maNtu9uc9sb81EUPKetMS6t8Z0Y4Kq/CPiklWnomQWw81AmUZ3b8+ze0O2OWtYO0MTokRoYtMg1DkyJQFM7Eai92NdVSwqjRbaMPASDgirbZ4CLkQv/suRQJSx03CPbntxcfrzyX2EZegzPCQmqw7l/0rVMlPOfdDiIBIvTw1MrRnXNSIrHQIc2i6CFrqOIuSGumC4Smni3JNWw5r3Pbx4qgYHSXNpk/nfH2cwlYSm7E1fixttple84K9d1Qu9jnEoG0l9o3RowM9LRsEshsSEkqNJkYEqVU+wjywjqe6phOmqOYKvw5LZqwpbH17SLQcyYVNx21Zf6QP95+muphsQtsZwBizOvXRVrYccJdRwmTWtGisXnuA+hSHOeo0/tMi9ORBz3qeRNnc7RM36kko9miwNHw3quhB0h/cbJe6Op9x5spIjMZ/yMHA3334rgKCtHMJfjW+JSLaBjRHZ8EDHSuzMYrkcfWexfho6pJQXn8WKVllhr6ugL7hevmuRtXIpBJno5k+hCuso9kUZ+Wpq/5IkDcQDOMLjHgxHplTQ/VpZ/HjPLw59IEySqzeDPqfFgYPgCf3AanwNKCLdpyS/Tiz6cvv/7Ip48ljttXQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 11/13/25 06:29, Gregory Price wrote:
> The nodemasks in these structures may come from a variety of sources,
> including tasks and cpusets - and should never be modified by any code
> when being passed around inside another context.
> 
> Signed-off-by: Gregory Price <gourry@gourry.net>
> ---
>  include/linux/cpuset.h | 4 ++--
>  include/linux/mm.h     | 4 ++--
>  include/linux/mmzone.h | 6 +++---
>  include/linux/oom.h    | 2 +-
>  include/linux/swap.h   | 2 +-
>  kernel/cgroup/cpuset.c | 2 +-
>  mm/internal.h          | 2 +-
>  mm/mmzone.c            | 5 +++--
>  mm/page_alloc.c        | 4 ++--
>  mm/show_mem.c          | 9 ++++++---
>  mm/vmscan.c            | 6 +++---
>  11 files changed, 25 insertions(+), 21 deletions(-)
> 
> diff --git a/include/linux/cpuset.h b/include/linux/cpuset.h
> index 2ddb256187b5..548eaf7ef8d0 100644
> --- a/include/linux/cpuset.h
> +++ b/include/linux/cpuset.h
> @@ -80,7 +80,7 @@ extern bool cpuset_cpu_is_isolated(int cpu);
>  extern nodemask_t cpuset_mems_allowed(struct task_struct *p);
>  #define cpuset_current_mems_allowed (current->mems_allowed)
>  void cpuset_init_current_mems_allowed(void);
> -int cpuset_nodemask_valid_mems_allowed(nodemask_t *nodemask);
> +int cpuset_nodemask_valid_mems_allowed(const nodemask_t *nodemask);
>  
>  extern bool cpuset_current_node_allowed(int node, gfp_t gfp_mask);
>  
> @@ -219,7 +219,7 @@ static inline nodemask_t cpuset_mems_allowed(struct task_struct *p)
>  #define cpuset_current_mems_allowed (node_states[N_MEMORY])
>  static inline void cpuset_init_current_mems_allowed(void) {}

The cleanup looks good

Acked-by: Balbir Singh <balbirs@nvidia.com>

