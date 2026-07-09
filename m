Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 35A0CC43458
	for <linux-mm@archiver.kernel.org>; Thu,  9 Jul 2026 18:07:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 632F36B0093; Thu,  9 Jul 2026 14:07:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 609C76B0099; Thu,  9 Jul 2026 14:07:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 482376B0093; Thu,  9 Jul 2026 14:07:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 183EB6B0096
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 14:07:02 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 9290C1401E4
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 18:07:01 +0000 (UTC)
X-FDA: 84970019442.01.3E6B742
Received: from DM5PR21CU001.outbound.protection.outlook.com (mail-centralusazon11011025.outbound.protection.outlook.com [52.101.62.25])
	by imf07.hostedemail.com (Postfix) with ESMTP id C83254000C
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 18:06:58 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=BBe4Qd7D;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf07.hostedemail.com: domain of ziy@nvidia.com designates 52.101.62.25 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783620418;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TTJbnrb1rBxt+bSgnYN1SSoLjgkhyqynpuN7zOekdsA=;
	b=1edpDfiyR8m0ONrJmaDYzL+UYOIHCv9ml6O0okcCbP9mYPu29SU4uI+5M8GBVM8jUYEmIb
	VbpfEI297WelZ64eqP/djslFyNcBQLsqutwFtnAsw9nmQ9x7oJKR4/eUpm5TOxXV5QG3Jz
	V8xyY9Cq+d52eae0DIgcXxRlMO9CnPs=
ARC-Authentication-Results: i=2;
	imf07.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=BBe4Qd7D;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf07.hostedemail.com: domain of ziy@nvidia.com designates 52.101.62.25 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1783620418;
	b=h2lWZ18XYxgrph5x4gGQsncAPuoiZd9aULXTonfpzv2yCQksoqFRh5Y3A9kq4Jtsc/UVLP
	K0J0E+xOg6ewKWCsAhSZerRi4PXu6KcOPTClC4SZC8t5vPxNHL13iVmPXFuqKkkoxKal8B
	h2RUNUBXY2RTRf3S+8G7ScyVEB2uLeg=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=RXZPKNyvSpDFiJiysDwWfqGHfBHNJ2zOZ8J6Co8TrA+geUqYyUuz99WqA4A6jCTtOuPAgu4bqgRxQ8dqSixthvSXjfT2dCQncwcgbkjUQeJg7m1FxZ676pcNnanAa85owO+UkXeX7GNLxTDWTfFfOD1Gg6eOBA5mPLB9BPpul9r7aZYfKXjh58vs4wttvyFlOFrfRdGELo2DEyX8slyVLfpSw7KweASJUZ96KsfOLDTph398FUr24+3YAaAZ9Ra160wIaJ/X5nFXmnYPC+P2CsL18knsuoYq8dL2d/0HuzHrbxULQ3wH9vCD+BVjJIeY55Kqk7rbbSHAWzpbw6WbFA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TTJbnrb1rBxt+bSgnYN1SSoLjgkhyqynpuN7zOekdsA=;
 b=M/VduVh3t4MdhZhkJ/Sf1tZlsWgwLshPBHrNpD612Ki1GksBykeAreMjAJb+OUUYk4oaPlbQ79DDDonheYJoQFVQ5sBsN4WIHs2/cIufU4t8e+TeWJopSX3rLdsxAZuESAIvi3g7YCd5Wbg8IP1zH/TP330OQ2pTNTM6Zty45rqgW3gC/kCGVetqkwVXOZ/m4/LDymRPhJ6ajYhyla/MvftDj84jfIf6GgC6LvfQ9AULukCrfcTloOP5sEx9Nw6iqDlspd04EKZO9tXph6fQA5hb8j5jvhOJzzpQafRKzGb8kzJrm6fbnhJ4K1399KE5eNXT/osE7zwB9DJLPA8ySg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TTJbnrb1rBxt+bSgnYN1SSoLjgkhyqynpuN7zOekdsA=;
 b=BBe4Qd7DGm6Z2g0k26NSVayHygOP2uZ7XVUoBAd/qI7P0a0NlvD6LV1ABIk15iDaD4DrB6fCBwwYbdyC6CB9xSbs0vHgdzGETKc7pG0Jipe2c5+WtAPPlOC2PEXhhiZtl7OIFsA6UjYavUfOQL9SfgUqDJj7ShArY2oOQsH9hW0a4CHeDHjA2t+nJbUDMvVMqqHcCoXitcFr2nTXsGF6V8rtOsShi2EI+w9oKm45VZGE3vRy4cc99SpLSYvu6i/+G0sJMNvwLCaCWNi7qZagH0OZSganmn6LCzsmlUsO/9Epkh87wgZtSjoJYpKyW1SmnLIhE1fXq9H74v8QQIaF2A==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by CY5PR12MB6226.namprd12.prod.outlook.com (2603:10b6:930:22::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.181.15; Thu, 9 Jul
 2026 18:06:48 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%5]) with mapi id 15.21.0181.014; Thu, 9 Jul 2026
 18:06:48 +0000
From: Zi Yan <ziy@nvidia.com>
Date: Thu, 09 Jul 2026 14:06:02 -0400
Subject: [PATCH v3 2/5] mm/compaction: stop recording free page order in
 page->private
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260709-keep-subpage-private-zero-at-free-v3-2-7e4fe155f5b9@nvidia.com>
References: <20260709-keep-subpage-private-zero-at-free-v3-0-7e4fe155f5b9@nvidia.com>
In-Reply-To: <20260709-keep-subpage-private-zero-at-free-v3-0-7e4fe155f5b9@nvidia.com>
To: Andrew Morton <akpm@linux-foundation.org>, 
 Vlastimil Babka <vbabka@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Brendan Jackman <jackmanb@google.com>, 
 Johannes Weiner <hannes@cmpxchg.org>, David Hildenbrand <david@kernel.org>, 
 Lorenzo Stoakes <ljs@kernel.org>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 "Liam R. Howlett" <liam@infradead.org>, Nico Pache <npache@redhat.com>, 
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
 Mike Rapoport <rppt@kernel.org>, Dennis Zhou <dennis@kernel.org>, 
 Tejun Heo <tj@kernel.org>, Christoph Lameter <cl@gentwo.org>, 
 Alistair Popple <apopple@nvidia.com>, Usama Arif <usama.arif@linux.dev>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 Zi Yan <ziy@nvidia.com>
X-Mailer: b4 0.14.3
X-ClientProxiedBy: DM6PR04CA0024.namprd04.prod.outlook.com
 (2603:10b6:5:334::29) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|CY5PR12MB6226:EE_
X-MS-Office365-Filtering-Correlation-Id: a516e6a3-50f3-4248-66b4-08dedde4d84d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|7416014|23010399003|376014|56012099006|11063799006|18002099003|22082099003|921020;
X-Microsoft-Antispam-Message-Info:
	oL7lDpqcw0vbInYU0ioA6zmoyDHTEHtKfQ66o/jr/m1e1DNcV9q+dfdHW7TKtFd6oUCjpFXFqaHpZ+3XCVQtvGFDuy59ntNe5n9wf28UmwBL213/llISac5xfCI+CZYbgNuLx9UI5lbZ0KyaWZyhX+Kt6VqDV7KcRr+PoFe5g2v+w8lU/vG0k5bxGZCD9fAKxG31XmpQsRA24BPo1YJR2g41/bYt8Ir8Fhrh288jUW3yVPjhBWv+10xpqut00SFqQ5Gqe7K2ez94Pat+dvIP9kO8UGIbJytjPPg4d59ZL6lE4WNb0XBuMuVd5dVx23A4WN2tqF5ttSoXZmAfxNMGW7LJQ62SKaEw8hiNkxuvMEd3CYEcLpIMNvHR6Yii6En/ODRA0GEivF5r89hgkG0l+zj3A+DPS+/7tPbXs3mXl31nWtaj+1ttCV5aGt9Y2U3HetCm8jfjpTi2L0441q3bdABOSw2SWPCeCj+Pelq75A+bLuRnnc3DxXeY8/5i1Y+2N8LoBQ3Y4xE2x6JvbXV3icJU+1Ga/AU0uhphmo8l/wddEsfoEU/OrusdHYrBcblzKiucdbu+gFY7SPRkZoPnAxqwZHjuLOwicHqurlyluEBbyGHZ3rIF5oC/OebVBHGNWDuXFEGALL6LaiiWskFKb40VvDeQpXCXRvLm/Z4ThPMu0ypHN4B48eSDfCNnoQKbWmdyNwA3oJ/NhuiNaAAetA==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(23010399003)(376014)(56012099006)(11063799006)(18002099003)(22082099003)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?elYrcVFocUg2aTVtVGJHMTJjK082NzRTazFQNmtEYVp6RHB4NktwS1Y4VC9r?=
 =?utf-8?B?Vis0WUlnVGx5QzBmbEtOcVorNmJXVytGa2ROQmdQQlJVNVB1dTdsSnVLS0Uw?=
 =?utf-8?B?SzlFcDFCRGVUbFlSaVpBNXM1MkRPZ01XVW5HeFFBWnJtUVlFdTZZTHpyUFg2?=
 =?utf-8?B?YUtnUmVlNjhFOC91UXBLNFdFRzdFemdtUTBOMWtGMHJSZ1NheFdCVkVXMHQ1?=
 =?utf-8?B?Z2d4L2dWeUFnNE9GRVNTUUxjNzBqT3pxUC9vY01WMUwrSmVNL3g0a1ZGTndY?=
 =?utf-8?B?Zm1LdXVDWWEzWThpYVNSV05SSm41Nk15ZncrblVLOXEzRUZ5YmRVTTkzQW1l?=
 =?utf-8?B?UHJxMnVWQk40ejlkRTdGNitDdHprVE5vMWdOakx2RHd0Z3MzWjhMcFc4Q3Aw?=
 =?utf-8?B?ZkJGcHhzMlM0NWhBU1V2N0swUGdacGdtNUxiVVF2QXN5U0lCbmxveHJLRXgr?=
 =?utf-8?B?UXpEQ2R1SXRHMXFHNWV6QWJzZXFTcGYvUjY1Q2FFQnhXNXhlenJsTE8wWlJQ?=
 =?utf-8?B?QTcvNllXWDVreHI4ekMwaTJvTDhYR3JTSnFnSFhmMkZOWHZTUDkrRXJ3UGVx?=
 =?utf-8?B?VDVhYXUxVzhBTWIxYWI2SzZNcjk4aVk5TVlwOGFZalo2MWo3cHZYamc0QXJ1?=
 =?utf-8?B?WmlPNDNkMThZdXZscHBRaXpPa05WZFJKS3FtdFBZZ3JzS2VSTWFOcGhwT3Ix?=
 =?utf-8?B?d1puZnR0ZmlPS29WbHFLcVhDV1hIYk56cGNobjV0Umh1WHFpV25GL3duMStU?=
 =?utf-8?B?eGh3ZjF0MlBzVGw4TXdPOGIySkowZ1M4ZHh5VmlSN0xuVW1lSUVuZWtQMHdk?=
 =?utf-8?B?RUlrRUlDWStISUh2SVMwSWJ4czdhK1l5QkIvb1BXTEJSbkhjMGtkM0twQXd2?=
 =?utf-8?B?eG01UWx2WlhuQ1VxenlKOEhvVnc5dDlnZDBCVE5sWGE0VmFtdWlBa1JZR01G?=
 =?utf-8?B?THBPbis5TUdsZWw5WW5nTUQwUHpzdFJhUzZuVFVnK25ReVpOdlpyVURtbW5Z?=
 =?utf-8?B?S0duaVB1Qkc5T3k3ZXZNQ2QzUUt5TWpjK0dYa0pkaVdHcUhXM1NZU2x4OG02?=
 =?utf-8?B?eFFLMG40VmxxTmxMM25ldW1DL2E5TnN2ZFd4VlJGOWExVlVvWHNZdkNIUnJI?=
 =?utf-8?B?MzVvSE9ORkFIWDdEdjVYM3N3MWxLdmFwblE5Rm5yd1pwcTVZWTJxN0tqVjdJ?=
 =?utf-8?B?WlRubWNnTFRTREhiMVcyY0M0eTE2cHZhN0pBSzMyMDQ3VUx5eGUyM2ovYnRC?=
 =?utf-8?B?U2FmTWV6d0h6MUw0ajJPbG54OE9YdC8yeEN2bjk4eFJwVkRJNTJwWk5OeGhI?=
 =?utf-8?B?K3FpUUJ2czU3QnFOcVJxZk5jQ3kzREdKT1Z4cTQ1RStHU0ZYbUFicWx5N2VL?=
 =?utf-8?B?WGtyQWhqeVowcDZ5bVd3bW1ZK1orOFRqZjZBL3dNVkp5cWdCa2w0NHduZ1Ex?=
 =?utf-8?B?ckc5R2FwQlpoRmtuRTVKQy9zV3duK294VTRUNUh4RnB2QWFyOVczamN5WFg5?=
 =?utf-8?B?VzZKZFVjWnBsWXAwZHEvUzFEWW1NTmRWSkZ6a0NYQkJTNytOcmtKUVkvYXpw?=
 =?utf-8?B?cmVrVms5cE5WWmswb1lyZG1MUUNIeU1HeUorZThldlBvaEFkNjBPNnVxd0xW?=
 =?utf-8?B?eWJzN3QzejlkUndXUENIRXNiTG9mczJZVXQ0SDl4ampyQkhKaGpPc0IzUlNr?=
 =?utf-8?B?U0hzQTUvTXBFV2hKdHdleDhaRFRQNnJTVTdmR0habWovMTZCcnpRdUprWUVC?=
 =?utf-8?B?dk8zWmlQSWxjeEcrMkNiaW1uSmdyR0xpeEdQVk1zeHJjRXRjS2JPWWdrUWV5?=
 =?utf-8?B?ZE9sS2FSOFpXNy83WDVBc3VNdWF6aWNOMEE5UDhidEZxKzY2ai9LeHBmWnNU?=
 =?utf-8?B?djMvMU9YcWVmT085YStOb3Q1YXNUYUlRZmlvMUpYbk9WcGtMZ3hiUnlRS2NW?=
 =?utf-8?B?RWsva3ZkQmxweVlkUUFQQ2dxdmt3a2F3RVlBQ3lCUFp3cmRDMEFGYXZuMktX?=
 =?utf-8?B?ejhKMjVQRUo4TGNMSE1uNlZET0NIWlEvaFBPMW8rMFVjcjh4Qy9udUJ0TmZR?=
 =?utf-8?B?dEVYY0h6NGlOVlZZU1ZhdmF6TzBxdk83bzg2clpLbzVPYW8rUW9nV21mbzNz?=
 =?utf-8?B?T3FtS3pBckZtZGthQzI3bHhFNmZHZituQVpueElYL0Fja215UU1HeXZOSDFj?=
 =?utf-8?B?TmJJOUE0YmxlSnpWUUhhTDhvRjJuYkg1ZnZtbXp0eGhhNUJrdkd2ODJPT2Zr?=
 =?utf-8?B?OTV6NmFhcGtqVzcyMXFQZ0F1bmhlTzNpSGdjVmhnK2JYd0tESnVHMjhFVndu?=
 =?utf-8?Q?P9jt5mqoQoi9pz4uth?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a516e6a3-50f3-4248-66b4-08dedde4d84d
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jul 2026 18:06:48.5324
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /TkvbE2LPFXPtWwheskRTaliV+W1kEt4Cw//ljaWaa3VrGbWxu7wN7b3svi/jcMz
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB6226
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: C83254000C
X-Stat-Signature: j6mks5gzh94xyyt6wbydwwtcoccw8jp7
X-HE-Tag: 1783620418-505713
X-HE-Meta: U2FsdGVkX1/bsddis1Nc57LQWeBzABube1b94yOmR8ZY7uBTbYDhHNcBclJc85eLkXtJvd+ymxr3BqrHQ1vc7DvBnfMz1SM21udFeNmzrksLYa4RtY4zhNi6lqmGtXEgB20Lk3Df+mXJgkrrmSJVYsFSHHj83UYVCv52M/9Y84ndZ6MxK3chnv4vFaquJz2YO31zEc/hts5KNAs3G7eP8Bki6ybey6jKML/LamchRK+bEDLveJbvWjmEQcMlvjoceHsB4bu7aGsyfePOejQ0OeVEP7lwSBMrPhSTRNUsLBTMiyJh9gOFHA73dwzDX0xQ9e9mHSP4NvrrGbmf0HEap7CJy8thmZhQEuIuv7+p7xJj5S9DcbLbogxbiaO7quLg0X62kzmBbQJ5PpIcuBfI/7Nw6bBfqAM1aUDkv15PWfY+WlN3J6jq45hXSLg3dz2r8PQkMXQu087fvOLdRCvZtXoEU6NHqoEHK7eQFYHtxMfGlz0DM87EQuSyBNNZdAuYJmAgE2Yc4yRq3R5ZxFHatl/NidzBlgdpDcmHvKu2lhUbiiX0Gjgs/lh/Upw6Qd5F8+D99Dlp2dljo8WHvqMgS03h60oIvKWibNYN272MBWntdHyhGVCELgDTO2MDvTlpUm074dMFa5LP1Qq1LUde+0HsIIcnU8sn8js8MfG+G8n5oqzESvlJ+gVDD2sKWtUlEvkmAbnnW4Wu91Bvpi6+tZPBEg8R5q0HSwD0EobfHYVQqel8u6ughX61yBMlFNSjN6eDAfl9Wxs4+mVtfQYxiSRMB5OdgFwwKgyZXBWkhnKthwrbfAwmUuYrZoleQ7K3FM1SWgQpKzijMH7fvN1S5nL53rfPMs+Ls0GhI8QU2TwJ+uZvzmUxkAmc9eqDKvTp4bwC5PwAOzJBZcgmzStq8sm2E5hf2SYcDL2UhYxv8l+WIG0Zv5IL11ZloFzVgGPvVQKbL2csiWvFcNOF/yi
 Wes/0IB7
 DG0G6NxbO92E8Fb2FAh1UmctFkUpzrM79+9fn8g90AN7z3+RiP3zeRkJ/gYxSzN722RhyGGzEV9aekBK6rkC2JGgF5GeCsgiIwwFMxo3k810pX9Dix6fnCm4i7T1SCkx0ipfmS/w+hg4J7HFw0dQnP8A16/ZFE3UxdRnTuDIQLFKa6ZZ8bH8uL7MKkA+DOmrp7jOBFuD4ImkLAjHfc0rNqMW3uuuMBGFfDdMLCNUH3mK84zu5TERlRG2eDSkEHTUxKTeZG9vfL8LgwatG73lD+TOGtnTdW4WAcAECgLcyOuijnJgwtSrFXlvKahPc14dLM+djJqHB9F17VtuE2JjugFK39veRQw9tf1ayo49U0QGgQuRnJHGeVIZnjlG0t3heSZZsManLxW3pX0shFanNM5dWtDFrmWJAk5RnwCdwwmjUEeRKrKP/FTe4vuSjRGaiK8L+
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Commit 733aea0b3a7bb ("mm/compaction: add support for >0 order folio
memory compaction.") stores isolated free pages in an array indexed by free
page orders, it is no longer needed to store the order in each page's
->private field. And there is no code using the stored order. Stop doing
that.

It also prepares for an upcoming change that ensures subpage->private is
zero at page free time and the removal of set_page_private(0) from
prep_compound_tail().

Reviewed-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Lance Yang <lance.yang@linux.dev>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Signed-off-by: Zi Yan <ziy@nvidia.com>
---
 mm/compaction.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/mm/compaction.c b/mm/compaction.c
index 4b2318fad4eb5..9f81055a358ed 100644
--- a/mm/compaction.c
+++ b/mm/compaction.c
@@ -645,7 +645,6 @@ static unsigned long isolate_freepages_block(struct compact_control *cc,
 		isolated = __isolate_free_page(page, order);
 		if (!isolated)
 			break;
-		set_page_private(page, order);
 
 		nr_scanned += isolated - 1;
 		total_isolated += isolated;
@@ -1618,7 +1617,6 @@ static void fast_isolate_freepages(struct compact_control *cc)
 		/* Isolate the page if available */
 		if (page) {
 			if (__isolate_free_page(page, order)) {
-				set_page_private(page, order);
 				nr_isolated = 1 << order;
 				nr_scanned += nr_isolated - 1;
 				total_isolated += nr_isolated;
@@ -1847,7 +1845,6 @@ static struct folio *compaction_alloc_noprof(struct folio *src, unsigned long da
 		size >>= 1;
 
 		list_add(&freepage[size].lru, &cc->freepages[start_order]);
-		set_page_private(&freepage[size], start_order);
 	}
 	dst = (struct folio *)freepage;
 

-- 
2.53.0


