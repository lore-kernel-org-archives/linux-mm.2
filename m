Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 921BBC43458
	for <linux-mm@archiver.kernel.org>; Thu,  9 Jul 2026 18:07:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 45CB66B009E; Thu,  9 Jul 2026 14:07:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3E72F6B009F; Thu,  9 Jul 2026 14:07:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 260E46B00A3; Thu,  9 Jul 2026 14:07:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id E01006B0099
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 14:07:04 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 58E1DA027D
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 18:07:04 +0000 (UTC)
X-FDA: 84970019568.25.A7327CB
Received: from BL0PR03CU003.outbound.protection.outlook.com (mail-eastusazon11012061.outbound.protection.outlook.com [52.101.53.61])
	by imf19.hostedemail.com (Postfix) with ESMTP id 828291A0006
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 18:07:01 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=ZfJnlO4k;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf19.hostedemail.com: domain of ziy@nvidia.com designates 52.101.53.61 as permitted sender) smtp.mailfrom=ziy@nvidia.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1783620421;
	b=UHb0EjgbANO9xRFP8fKuPLCcHPkJTUk3rMaxih7xD8HkQoHuzcyOjyr8oVXU+s5apnloh8
	9qLuQasJ/tsK7CuuAfCrIOl2Fn7xgELN37hqZzdSHpe1HMlfjEi6ezbQAu9DPKm25zHcRj
	TvbMt8TN3OQ6Rdj8DspOxmqO2fHeJ5s=
ARC-Authentication-Results: i=2;
	imf19.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=ZfJnlO4k;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf19.hostedemail.com: domain of ziy@nvidia.com designates 52.101.53.61 as permitted sender) smtp.mailfrom=ziy@nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783620421;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BrnkQW3dn/SdmC7Judyo8ArjiJlgoibK3jYXxYstAaE=;
	b=ZJrDmAPY6RKWLrd6GeqEK0jMNrLPERqDW1Ll//sYmFP1b0W/VwMopTCGrxpHLevxoT6etO
	0UsdLcCd1X0HpnbdZi5eYQKcuBqx15XSBEgQ+Nq7A7/+PWqDKkx38mMwpjMYgbV1uTEKFj
	25LlGzq5PWDDrvFeT0HR2BiRGroCxkk=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=JH0bMyNlt4ej8FjcLnSl6nf8rlwBmghPpS4znxfCDskDShxPce2xBn/e/6RvCwoAouPTfGZHsfI/+pe8tbJahbHrLHPzvj6+cIVi/ree8xSgC9LVdH1CuNnYro0SCzGRkXQVCRca1UBZtYjjoGJmQOeZONq9E0qraHYwDeMkAwr7Y6QnkBKKAE7y1pR4srbFGz/4AcXq5qdQCwdxxXa9E1m11fgf481QhmOFcMXI4zVTEIaoZpjtApk2UrvWcS4yF8/nS0p8yiIYFlabYqjtOBE/LEEN6moyJsK9SXgXFB/B7WVklda/ckJLJy9+c24rqNWLTRfvNxhUJNBPKgzOFA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BrnkQW3dn/SdmC7Judyo8ArjiJlgoibK3jYXxYstAaE=;
 b=L90PPD0XDEcMAiDch9Ba/srnQJ2cYD92cFi3EA3rM0iFy4Y25O6XPZY1qhrl1s/VZdTlPszlz/mikH8DL8NSFiuW9TF59X8Fcp7b8o9ehv37mZRdVByGam019cbry1EzxRj0Bq8MmQ1Blqcyvf50HLehdVLEznz5kvs/tgPSIVGi0ITWHbzCqBrAHcmc6KjCEaUHPXYOJYzjLaSM3mZcPkM7wsaizMWEY45VXIVIL3N5wEGcqE3gqmtCmtvpts+t+bLQFTzMYUzC/BqBMZg+gXSG/YM+9Unh9EIZ5ql2/yWejv2vWq5P9Bx9iwroue7ds8xjvi+Nvl1mxj0lcwtSZQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BrnkQW3dn/SdmC7Judyo8ArjiJlgoibK3jYXxYstAaE=;
 b=ZfJnlO4ki7h26981FA3EJNmOtNH/mAPHDcI2DC+mspQMRh1XEZ7sRo0GbZFKoIPeSQ20eY8vJ/etzqTeT5piPblfj2TTp8jYlF+TyAQo8HFvhzqWC+78AIClnl7Aez5TIkej15IGPlbGMj2xI3J33r4MsMCmH62yMg2KsskAyD9aYw0g8TigGYu1HPV5R2PSacWMuNyHHxoP250EOKC6WK0ERlFnIrRM4jYkzgNU5cZ71PaHmXls8yjjBa4Y1B96asLjnqXTH479m0/6As2z3FyzrwIsgFDdEImUe93P+lF16wrdteGhlBv/ZQHDb/Vge8x70nFKG10X3pAY3CQ/yA==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by SJ2PR12MB9007.namprd12.prod.outlook.com (2603:10b6:a03:541::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.181.9; Thu, 9 Jul 2026
 18:06:53 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%5]) with mapi id 15.21.0181.014; Thu, 9 Jul 2026
 18:06:53 +0000
From: Zi Yan <ziy@nvidia.com>
Date: Thu, 09 Jul 2026 14:06:05 -0400
Subject: [PATCH v3 5/5] mm/page_alloc: remove set_page_private() in
 prep_compound_tail()
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260709-keep-subpage-private-zero-at-free-v3-5-7e4fe155f5b9@nvidia.com>
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
X-ClientProxiedBy: DS7PR03CA0048.namprd03.prod.outlook.com
 (2603:10b6:5:3b5::23) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|SJ2PR12MB9007:EE_
X-MS-Office365-Filtering-Correlation-Id: 26e03199-831e-4357-4f3d-08dedde4db67
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|23010399003|7416014|366016|376014|11063799006|56012099006|22082099003|18002099003|6133799003|921020;
X-Microsoft-Antispam-Message-Info:
	N6ES/tEEQiYBs2wcc5X3A5XvSHRejxMyLvqQ4UiHIRZLQwrlIvBPP4pOGlRQibPp1pfdOSIV2vBGXX7lB1eSEUgcV4dltG/Geor22ipc15jUJv2tN+zHrgfpkTREtK+F5bPRgqjKYbBNateb3ZhCF7yTWThiNNr6Yg07yDOAcdNJdhH8T1+6BElpaU+DGnm1Q/xf7sXgjHfYXCWOKdEpI9CV0zrC8xnyKiwLVePh5RvSKMpR1Sytqzx6t8Kbd/fPHUkW1q80QsQBuDKVhi5sVwzSnI/VCiVM3MXFcpJiNc2KlCZEECp91doMU7LQt6syNEGNRbUItICZHXMvVTYNnyoDWs2C4oLW9Y71D/NKv9MjSNwlJsJvoeldTYvA1H+UzsKGO7twUC0FgrP5MLLBWRbdw/C8hEYRc4haWQkqzeT6WdA95CSNB3VUejeZGsvIrl2prunDY9jEgp32g9dy2d7CUVV/2Wd0WRBCYC5qChV/4AnP8OqClkRebN6SfmcQOKHZJ2ICqo+6CFuoxHXo4OFg1A2QMCpZP6ZRYYTcpa0Qbn79ZKs5RRU83gUx11xgsOxNFop2t2JDJCfNNDCcCbQH1raMQ0BltbkMOmjPA8hAPEobVA8lV+gXPfZNFhEXTF1PdBJKXhqSpPOL8/hZXywBfd+7HbOsRRLL8dhw7Q3k/WU5NdmCtGiKS0dYw5tF59QI8+4dmhFHdE1rriBSlQ==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(23010399003)(7416014)(366016)(376014)(11063799006)(56012099006)(22082099003)(18002099003)(6133799003)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?QjFFU1M0NUJESmU0Ymt6NDBhVitiWUlpUVBJek9kcFFlSXJLSHJLazNNOHNI?=
 =?utf-8?B?TTNhRmpRZGpDTjZUallQc2ttdWUzcmY4bDA3dVpvajgzNTRVdzBIamtvOEt0?=
 =?utf-8?B?emdZY2pTejBqSTl2OFNLQ3I4ajFuYWhwQXpaZ240eTVnK2JiZ25Ra0tNWDdU?=
 =?utf-8?B?UGhJN0YxbENXWUgzckNqVHNlVzdiN1MvaHIwaUE1cUQxOHZCRDlPMVNyUExh?=
 =?utf-8?B?OGNNYVhXaDBYSG5wWU5IMjMxelA0UWE2UUZsRm9lMnRUV2pKeXB6NUdha1li?=
 =?utf-8?B?QnBuWjZaUnd4RXNob0J4U0xqZmswME14cFBTVG9mK3U0cGRnaG4rcXhUR25U?=
 =?utf-8?B?TldlczU1RFlvTmwwNC9oeDhMRXhxZWw2ekxjaGVXQy9WUDM0dGFUMktNRUI0?=
 =?utf-8?B?TFFiWlNBT1I1Q2JGNzhkRENIYUtJdTNmVlZWQUltVVpyUnU2R0g5bWYrKytY?=
 =?utf-8?B?U0Y4Y2ZEVVRZWE9oSDV2SjRZZlhGenNmUWV3ZEo3OU5DT1F0dmhYNlhSV1J4?=
 =?utf-8?B?NlRhMmx6RWt3cmIyREwxeCtyVGZtdDk2a1dNMUVEbzhmcE1yaWRMcUpKZEJF?=
 =?utf-8?B?MEN1dGxhUVgxeUlkSWRwaFg4WGp1Z04vYi9tUHh2UURXQkpXMnFhR0hBOThT?=
 =?utf-8?B?KzNGQXJJOFpTWWpBajlRdWx6bzhETHZiSDB6RytBV2cwc09zVFR4ZzVPa1Bt?=
 =?utf-8?B?aXg4N3g0cm5pemlZbmdRMjFZYXE4bXRka2orR3pLcU1Jd01YamxVNk1FUjA0?=
 =?utf-8?B?dkVWeEM1cnZtelZEK0Mxemk3ZmY0ZXEvRjNiRFgvRnZpOWxGcGlDeERPNkpq?=
 =?utf-8?B?YkFUYVRKY1lhNWE3VFViRTJUdjdlei9yVVpCdjBMSVVWdUFHQ3NNM01ibDhv?=
 =?utf-8?B?YmN1amR5QWg4dFVZbEJ5ZStDTEU0OFVWNjFScForeDFFYWlxeUpvVkF3Rmcx?=
 =?utf-8?B?M3Z4WXNBbFVZNFV4eVVyUnN1MXBkWDJoeEFWWlV2dXczdnJBN0pKOWVodzl1?=
 =?utf-8?B?UWpqL2NHTGQ3dG5FbXJwWVFBazhnVFVFWnpUMzdaVDB0aitVZHc5U3JFZm04?=
 =?utf-8?B?OStKRDV2a1lNa0cya0FFMjdhVTBkV3hab1k3ZHJhbGlrT0dhd2pOb1Q4cDQ4?=
 =?utf-8?B?WHM0bDhkNlpGc2FuL2N4NElZcll5ZlFnaWljMkdsc3dEd2Q4Vm9PNXd3OFFi?=
 =?utf-8?B?SHRWSGQ5ZmVKSXpFZFN4azNjN2pqV0FuVnpNQURGdlluWU9ja2RHQTJDQVl0?=
 =?utf-8?B?bDlwVThuVm9KRXRwazArSU9XVFVqY2F1UGZ3dVRac2dEeDlmU1h6S0hteDBJ?=
 =?utf-8?B?WXFlL0ZnbDJWYXZNa2JpbnZlSzJGVlVOd2o2VEdiVTFidGtRd0ZPRUlGWUdX?=
 =?utf-8?B?THlFUUFOalJ6WTNTWjBnSSs4eFcxd2pPaDIyTWdWRUNwWDF3eWhoMTR5Vmcw?=
 =?utf-8?B?RUNGMjJyMXlHN0JTV2ZhSitIL2RMd2lNZlVHZnRPbnJNQTgrRjZQMmc5Rlgv?=
 =?utf-8?B?N21HL21BNjViVzU3akc1b25tVFpuVEdGOS9BaERpZzNaSFV3TVN3UUZ1UGVa?=
 =?utf-8?B?Tm5vRTFpU2xKQ3E3V2c2dkw5UktUQjRBMEFFNUVNaFhhYlpTcjEvbEJucWxQ?=
 =?utf-8?B?dDA2aFVGVjA5Yjh4OVR4MXZyMkpmend4UTBadENGSWlIZXVva3RzaDJSdUM0?=
 =?utf-8?B?QzJ6eVNQelR3ZW5HRkR2NElhVDBPQ2NtZkJkVVF2eGtod3VZb1B6b1dicGI1?=
 =?utf-8?B?RTVzbHVhcS9FZGZoQm5KK2RnZnA0VDFQYktWYVVrMnd6TFVkWm5sR05tcTdV?=
 =?utf-8?B?M29tRnpaVDRqcHcwcHpVTjNQeWhIeVNXK3EzOVl3QjZjZ1V6aG01VEtpem5h?=
 =?utf-8?B?RHhCVWhnbnN3T3R0TmtHMzlzUGUvaEpyMkd2RUFtR0lmeWFidVVhWjlzOTFq?=
 =?utf-8?B?SzJlWmloT3dCcFFOREMxNEhHcWJ4S2JvV1hJaHpqT1dWSk1KSEwyeTJTTnp5?=
 =?utf-8?B?L0ZocTlld01IcFBaL0trbUFMNFlLblljdnQ3RnA3Nmd5WG1XUnU3dk0vNmcw?=
 =?utf-8?B?cGJNOFFDZ0pWOHZocStGL3ZNTzVVUXk3SmdPVmR1NTY0SkpMS2JMK0RwRnFR?=
 =?utf-8?B?a2FMOHpGQTFqY1JHR05CcitxMjdWTGhrOUtWTXBROTRmNXVydkZidTJSb1c0?=
 =?utf-8?B?MkRBM0JqNzFMbVdqb1QvWTBSY3V5UHlzMmxicjYwWG9mZFR2RUsyUzhWVEtB?=
 =?utf-8?B?YWJSd1RwdlZVVmpUdUszUlBSZlhPWW1aRnpnVFhuQmVjR0hXVGl6eUxOcXh4?=
 =?utf-8?Q?i8eRf4MToVCyX8bvcy?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 26e03199-831e-4357-4f3d-08dedde4db67
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jul 2026 18:06:53.7710
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: iPkfQ72wIjW5iATs4n2RmoxmWYjIeW8rJbfy6kl7T523zMmnbL/MzfYpv3Hy8LeI
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB9007
X-Rspamd-Queue-Id: 828291A0006
X-Rspam-User: 
X-Stat-Signature: 1n7psh4gszutyhxsnqcmkhacgqyteyrm
X-Rspamd-Server: rspam03
X-HE-Tag: 1783620421-448983
X-HE-Meta: U2FsdGVkX18+zLL3xStlJPLEXTP+dTvUXrRkbrcXSso8ETZqfXYjlDCTotiFqi/ZvX5dnewPC7PZszb3/knwkxIZZtXSbV0DGfmy0QqAzR0Nb1KSFor/3ke9687fMg0xfBg8tEnKyQyGloilKQ3RzLrOxRjDYZz9LQOTBqwxdzujlmP0/GzlGGafuDE3ObumMhYqd9nMQvu7trHSq6b68nvZE7015m8hBotw+iE+IB/Gh3vFRQTcxLCTAIlcl7ZD2iVmQzWPLvV5WX0b9irlVnWqLXo+TcSF//uTDYQS5UozvDI8w/SHv+KKXfFV1JE5DeiAZraL6NdNzAP2g73w40nJ8weKP3UvakeqXHUk89RKIzPgy4fiQK6Q1ahDEAcZhStiuKkMRig72MPIw4VH+4ZmvtsCpK7tX6tNjIahDFrpjZyR3XX9kaxzhDXlzzw9iFNQ5DDJv0IuGwONYGiWoJzDkBuh9Q+BdVbBWZ8P+IHRVq1H/brSj59uk6zc0Vf/mLbz5h6QqV4W2zv7pv0eUWm6jwH4fqsBDSJa2hHA1KL80/D9z2ujgCKbLstPQX1VhGykSkP3M5rfEjCw8HTyMObhQkAtQQjku2Iayk7d9F1tCtj3dd1scHIcwkRB7mMRumLISVBkYlNWaLIaRZA6ctxt6ureMREDPl8FXWKpqay/M7pSwIImxgiVGIqzvW4nkeM8iLquDiA89cUukKk6plx3q53ILKhxSuS3LQ8n1pp0F2xnaZd8+GeKUa1nzM4yCdnYS6mOdCkL1XZQISTDMl7eZedTKbAXK20G3v3kVa275CP3AXHkkcGKPa8JMB/Zijns+xx75PhAqyV4W3h2gGL49kfG8TuAP4etdYdZYMvegitIruovdZG03HS2/oSw3mqayAT8hSJ3d5z9oM9j4s+kYvqK7JHaAb2hKERrJIQggX6OYEdI88Eq0VdPOxHcXtMp3bd8nisQJGMo9Qi
 OOubggb9
 jRBk8ZqJtSvnW3Ue4zbyZQryM5t9qmNUvl28W2pPt+yrLreLqS1PBsoGjrZkALyWFFpvPKgQ+8Nnx8MuGJKVRwKxbUYdNhF5YDiTui6+KaQJ6Vhs87f4uJgU8vtGqnCaNyva7VbU54FHICx5JcvjbqxSzeNN5fsX/mm2jSsX8SYLBYRoQ9DhN4kzklG4PTQOnHSpgbseHS7PZFU2R++ytRveMGS+veGJZuC/6Ma+S560e7a1ppPsH/nSzcCdVhOXaxpNeFAcBKm+chn8hd32QrMP9RZIB1G1iW1EhqlPytaIgtAqnAerHuEAq/8PL8KyNDqMHT/TfU8AIiLCoK7SP7NNDnH6CNrN94upOy+I5HC3bVxUejYufhj0AeH6wMQyM6ilOYKnR7pmRVZzF2tpPbD+O1TvkuBEpMcQ/NsVPrGPYsQQNQCOkIYFVRDjaxmHCdGGdex9fyxMy/0BvDSG4vlaX2A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Tail pages are expected to have (and optionally be checked) zeroed
->private when they are freed. It stays true during subsequent
reallocation, so replace the tail_page->private initialization with a
VM_WARN_ON_ONCE() in compound page preparation.

Acked-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Lance Yang <lance.yang@linux.dev>
Signed-off-by: Zi Yan <ziy@nvidia.com>
---
 mm/internal.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/internal.h b/mm/internal.h
index 841c27611627e..398741a8ab092 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -741,7 +741,7 @@ static inline void prep_compound_tail(struct page *tail,
 {
 	tail->mapping = TAIL_MAPPING;
 	set_compound_head(tail, head, order);
-	set_page_private(tail, 0);
+	VM_WARN_ON_ONCE(tail->private);
 }
 
 static inline void init_compound_tail(struct page *tail,

-- 
2.53.0


