Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1CED6C43458
	for <linux-mm@archiver.kernel.org>; Mon, 29 Jun 2026 02:57:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3B9956B0095; Sun, 28 Jun 2026 22:57:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 346A56B0096; Sun, 28 Jun 2026 22:57:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 25CC16B0098; Sun, 28 Jun 2026 22:57:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E352B6B0095
	for <linux-mm@kvack.org>; Sun, 28 Jun 2026 22:57:08 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 462AB1C3539
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 02:57:08 +0000 (UTC)
X-FDA: 84931438536.18.BCFB4C6
Received: from SJ2PR03CU001.outbound.protection.outlook.com (mail-westusazon11012051.outbound.protection.outlook.com [52.101.43.51])
	by imf27.hostedemail.com (Postfix) with ESMTP id 74E9D40002
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 02:57:05 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=D0gCMDA7;
	spf=pass (imf27.hostedemail.com: domain of ziy@nvidia.com designates 52.101.43.51 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1782701825;
	b=MWtM7wHjBdPASTayCCsggI21a7Gkho1WVuiLK/zxsOlMeoH9z0NZgX0kNWRjJVgmHfQbD2
	j2TfdvyBqqPAR6uv3NGSyZ3TsqgiBQ1eiCYSuhIuyAO8h9TbGdicmjKJX2usdNKb581W65
	hxKxkeTvnqIq7m8bCCr188V0dsY5zLU=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782701825;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8NwpJehe5HGPNUo4cEhsAIFzht9WtCTCJO0f6MF6JfA=;
	b=bUb9rqC7BQgumOw9fp5Bd7x3k7XU3rpkdVlqlW0tow3phfi2DUfLNpRehjs0TAjRTNIcNu
	EcDqu0arOaqOTld/aTFz8oXhhMJn7xjRO4SFhyrGkwzrpqHLIM7KD4CpmSfbzCwbYdE5x2
	g95QLt2UoOJSePU2h1GIH1HRPbd7Zqo=
ARC-Authentication-Results: i=2;
	imf27.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=D0gCMDA7;
	spf=pass (imf27.hostedemail.com: domain of ziy@nvidia.com designates 52.101.43.51 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=RTDKqHNwamvFCxHRzfjc6vOLatQGq8hI3gEYmo71ozeyuWKq8siWh/Py/mOTFPTLJTHQ1/4R7hwzTmjdEQ6iVVOMID36mv4ORLXJnovtAFb+IAPyhcUJ2ZXvtcw+3GFTj/WCR6FXLcZAMfGUrAvRzU5n5Jtrlf1lSjr2PTNoVc0xZp4SLnYs2wkISmT18JNyQyw1LZ3RKw/hYnDpzHWPdNZxzn4jLESR+veYNIJzL0pdk7SqPFnYQLM52Yutqnb5M2VKxP6aGHXHp2mq4nc3bp5J3dRCGDuVV8BkDVbf3d8PJ43Q1aPo3QWYoQFgQAFO7SAXza+yqCeqP2ycTMZ9hA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8NwpJehe5HGPNUo4cEhsAIFzht9WtCTCJO0f6MF6JfA=;
 b=RBTGfkifF5aQh33UwrPH4ShOnvNHtw9caA/tI6BTNmGLlv9IcYMxjJGtQv0M45uU6pei6q8FY2PG1P4UeD3pj+7qffki5U7yzbW3AQFmwLpaC6Ga3QTCCdWq1acPzyqHTP87PIpPn4zZZAySaws4vP5ZoHKO1ylvN8CH2b5KLCXI2TQTR8iFJ8fnRADkQJx4vbyFI81hgRQf8qFLGzbDp3oMWii1+WnUjLDDUktq0UGTu9GFglu0sFV4GRhFXtyIgTUm1nSOwGYokJWP/H3c1FkIYK7+3K9GSEX5KKdYOeZ4GfY2VmrN8QmYmpfrJMykiCcJ6NjY9Lmo8OSTwDfHdw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8NwpJehe5HGPNUo4cEhsAIFzht9WtCTCJO0f6MF6JfA=;
 b=D0gCMDA7Ut2GeI2I5HZClRh5cqyiMcXfNUBZJgyiPDCdsgYhCJyyN5dVxFpDI3jGaFIx3LfL5QTHQ40PFOUGtHmbl2p050FxBsxFpQHNN7yI0H3PjEuJSY47JI5DepKprHPtp5uWggzHFciiPgmI0zFMKgOZWK4NNXSNv0OEaGLjBeHcxMyzUqnyjp43mnt2GmmhMThg4js96+BrDOx2W3dSGM8NN7QiBqWKecfpaMeyNyjYUW2CDevcV+QV0PWil9doqda2lJTEppiQr2SpMHVRXtEPdJmWy1I89EeWElJvWYWGC8hoEj7cKXqlvSQ5FMH9v2hMUxQBn8a3mSs9hA==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by BL4PR12MB9507.namprd12.prod.outlook.com (2603:10b6:208:58d::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.159.19; Mon, 29 Jun
 2026 02:56:52 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%5]) with mapi id 15.21.0159.018; Mon, 29 Jun 2026
 02:56:51 +0000
From: Zi Yan <ziy@nvidia.com>
Date: Sun, 28 Jun 2026 22:56:22 -0400
Subject: [PATCH 4/4] mm/page_alloc: remove set_page_private() in
 prep_compound_tail()
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260628-keep-subpage-private-zero-at-free-v1-4-f4ce3930d10f@nvidia.com>
References: <20260628-keep-subpage-private-zero-at-free-v1-0-f4ce3930d10f@nvidia.com>
In-Reply-To: <20260628-keep-subpage-private-zero-at-free-v1-0-f4ce3930d10f@nvidia.com>
To: Andrew Morton <akpm@linux-foundation.org>, 
 Vlastimil Babka <vbabka@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Brendan Jackman <jackmanb@google.com>, 
 Johannes Weiner <hannes@cmpxchg.org>, David Hildenbrand <david@kernel.org>, 
 Lorenzo Stoakes <ljs@kernel.org>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 "Liam R. Howlett" <liam@infradead.org>, Nico Pache <npache@redhat.com>, 
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
 Mike Rapoport <rppt@kernel.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 Zi Yan <ziy@nvidia.com>
X-Mailer: b4 0.14.3
X-ClientProxiedBy: CH5PR04CA0004.namprd04.prod.outlook.com
 (2603:10b6:610:1f4::10) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|BL4PR12MB9507:EE_
X-MS-Office365-Filtering-Correlation-Id: cb568309-e3f2-4e75-dde7-08ded58a11e2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|366016|7416014|23010399003|6133799003|921020|22082099003|18002099003|56012099006|11063799006;
X-Microsoft-Antispam-Message-Info:
	+dtt8EHl8As4audnFI6wl6fK7cCYCX74sQc9zuHUriBQFaqaUrHvIhO7x1upsGT1S7AXawP9z7FS3u9z8xCJHzYoRtK73Zfzf2AAeVwe7sJdcbPHCBDtT76SngBTO3QfE8h2RII5H/zq63pG1d5xEOdu2tKj5nO4KaZL/fUPXMJdJODqXUV39rMhTkgS1IZz9WwUt+RfWYxTVykKGVU4IeF3TXHtk8CsuYLVLrDSgQdmvPD12MF9fHElpXVbaqx1aalUphLmdPLkxIJdkITRsmqZJtDsJ+MGkkAT0N+CGDGSxMfImu0g2sTlFjxqT7bs0yh31akKKrvQJlm/CZI0dSGnLrChQX1ZK+7NL6iJWOYDjofz9bFzjeq2CUvCNwLdMCLf6wmJVCP2d/ZuS2C4pbMjS6dO+zQ6tID5swiruQxP2PhrpykLnYRXEQxb5AN2KVXtjSkmi5uKB4aqBZpiicIcwCpXXwLnFukpEtQo2p2gDBulixDLjkXTTdWbB/62XSYj/9+AkZVvK6QC++UEqnYBOhSDkE9L+anfIMYTuQY0L+jwyYJHW8L1FoynX/7dG+1c9uDWV9lHHSsf90BTtdU+1OYZSClBU5HGrkCTmgphAfm37+R0QeOjHEn1eJlcCciCYa7FbZC+YrPbbxlO1Zaz7/d75gTxrehEqsOcLZ5nq7TvTRd7kV7Sbp7sKG+ymHXBjOI1c//IOxmvD/UHZg==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(7416014)(23010399003)(6133799003)(921020)(22082099003)(18002099003)(56012099006)(11063799006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?TU9ST1p1Q05OT25yQjBFODVuSWN4cC90Y1F0OFJEVWE2MU5MZko4cldDS2dm?=
 =?utf-8?B?YUk1ZTdZWFExUm1tRGd2bkFTZEM3cCtNUU5OWGFqNnA5bWRIOHg5VHg4REhi?=
 =?utf-8?B?WDErVEsvcmtXVHRJRkF1Qzd4YjgxUE5lOEJzZGpzMHY2UUdPckEvWk5sYjF0?=
 =?utf-8?B?WHFEdUdIemdnN29TOXE2ZE1uUGFCY0I4QkhGSS91SUVWZm9XWGJiMGltbzMx?=
 =?utf-8?B?UjM4SUo0ekswcUdKZXkrTm9aaHFtYi93cndwV21HU0lRTEhpdHp5aGhpR0ZC?=
 =?utf-8?B?VWI4S3RENzFCRm9JbldUc2NUTGpUZUdxdnN6b080c0NNK3o5UGRtNjFtdjRI?=
 =?utf-8?B?UlVpa1JtRVlGM3FFSkUzSnRTbnF3N3F4MjdRRDJVbXVscFQ3bXpXYS8vRzdT?=
 =?utf-8?B?dGx5eHdTY3pzVzNNckh1QitWb1F0bHQ4d0NnMnlocldBL1pyYlhuZ0hRcXV2?=
 =?utf-8?B?OVhtRWxqYldJOEZhdTRXUUJMVWNsN0s2eDNZMXBMazhUMHd5Y2IzNmt5ZFJI?=
 =?utf-8?B?bVVmK1lPd0ZVTmJFa2lrZDlweTBTWmRmN0VqSkg3MHlyMk5JUVA0Q0Jha1Ju?=
 =?utf-8?B?TmpTL3MrN0VDckhhbWxyL0JNdjZ6Mm1kMC8wL2JMSE15UE8vSnd5VnJTMi9D?=
 =?utf-8?B?cEtXWnhjSjBqS3J4UEMxTXY5RHRqdG1GQUVRRFVaRnp2d3JkYlJhb04zRytI?=
 =?utf-8?B?TXZRTk9XMysvY3U1eFMxb3ZURnYyUjRPbmJtQlBYUVQvODZ4ejdOWU0zeEMr?=
 =?utf-8?B?TmJVOVR1aHZSRHJqSGNWVjFGUGZJT0lTMnpmZ0wzbk1mVDdXVlJDS2xQVEJ6?=
 =?utf-8?B?OHJPV0djbTJzOHVsc1hGanFzU01XWWpQaVFvNDFRQ3RRZ21EQlp0SitKbG1D?=
 =?utf-8?B?ZCtLSTJabFZNOGlFNXUxeWVXb2hneHd3VjV3TWFmRW9oVTMremFITTNJUVJU?=
 =?utf-8?B?OGhtKzhsdjMwYnpUczg3VEI0U2FVSmcxTVRzMVlaK1Y2VVpMWTI1a1hEcTRL?=
 =?utf-8?B?MmlqZ0RUUm5yMUd6c1RoaHY2ajV3dGg4b1RuVjgrMEZ4TzQ0TVJNcVpHc09M?=
 =?utf-8?B?YW9uOXNqUHRrTDd3SEdubGE4VDA2NnAzQTZCNUJEL3VMYjFMeElRL1B0Q2Fv?=
 =?utf-8?B?NGkvMXRBMDB3eVd1S1pXb0NYeHlNNGRUQjRkSi9ZUCtnNTlteG9zN0MwS0Fq?=
 =?utf-8?B?SWtGcUx5T1E0enNuYmNXdGtXWHFzbXlIVDlWcnEyaHdUajVoaHMraE1lWnlI?=
 =?utf-8?B?WUt1eldmckxpM2dIWTc0RGUwNGdiMkdxU2NpdjlPZzJWSmlNOFNXeVlZMzA4?=
 =?utf-8?B?T3F0MHR6Q1hEd3VTVEVOdUFjcFQ5VmIxT3FIc0ZHQUsxelduU2ErYmtrRUhs?=
 =?utf-8?B?MER5emFVUXI3VG04RXdRTmxqSXhaK2FHL1ZqblNFWm5qVVd5eks2Wmc1MlhX?=
 =?utf-8?B?NXprL2V1ZHlpMlFCTXJyNnR5ampRUWFuSG5aUDMyeXpoRVhJNFdFMCtrbEo2?=
 =?utf-8?B?WnVGYzBqV3RHRlR1Q3Z6VC9xU1hkcDM2OHFmTzZKSTNBL1BjQ3VzYW4yNTBS?=
 =?utf-8?B?T1VNbzdLY2FpUVRFcy83ZS9NbmVmelk4cjR5RlpTTndQL1NwN2J6N2dGeVNy?=
 =?utf-8?B?Rk11RHUwVkk0ZXBxbWY5dkpYWmNBaUZDb0N2VjlsaDhBK2dLK0xhaUhxQXdC?=
 =?utf-8?B?anVjZHdHZlJOcm5DRW44OUR1a2VJWW5BZVlsQktCMkxRZjUwQTltRHRiaHdU?=
 =?utf-8?B?OC9kQUZ2RldKNlI2U2R6NjZnZ2w4L25NWEJWcGdOZUdHNkpjNXFwTWJsemg3?=
 =?utf-8?B?SXhsR3RLTkEydVgvZFR0ZittSktBMy92MThrQXRrcjVIUEJXMnJ2S3NBam8x?=
 =?utf-8?B?VzY3dTN5cGtkdEdNM2dYNWQrM3JiV21kT3ZiTzdVa0lSOTlPY0twTHdRU3F0?=
 =?utf-8?B?TGFOQ1F6WWt4KzRRN1NFSzd2bDk4NnNVZXplVCtWTzcweHhqajdHMWt2ODYw?=
 =?utf-8?B?WXBZbnV2N25xclRPa0o4SDZQT1lFNTEvQVp6UXlZT0FSdjNVbktWZVFTaVdk?=
 =?utf-8?B?dEhtQW9aRFhBb2NJM0RMWGhsZDZ4cENlV3lNVUE1RHE4TTlTRzdPMzQxVUly?=
 =?utf-8?B?VE5oLzRCR01JcUdGc08xRk50YzEyMVJNMC9heGhXQkp5Vnc3bzBGN3dEeWVN?=
 =?utf-8?B?V3Q3eWh6SkJaMjlHMkFIa050ajJBSHh6K3Q2MEtIc05MRGE3N3Bmd01sRTJH?=
 =?utf-8?B?ZXNZcDBJSTlYL0Vyc1h1YUJWanh5OGpKUjVTZHNJVVQyeUVvaStXMzAzY08z?=
 =?utf-8?Q?exv7YujlLnc/DlZMbu?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cb568309-e3f2-4e75-dde7-08ded58a11e2
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jun 2026 02:56:51.6812
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gj8nBM125UOE5RdJShbvSwpv23rkS1lr6HFGALxsA5dFyw1R28ITj6HFmmcqIxVQ
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL4PR12MB9507
X-Stat-Signature: ae7y9cex13q6fuht4ewbdwncn34kmxfq
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 74E9D40002
X-HE-Tag: 1782701825-175326
X-HE-Meta: U2FsdGVkX1+tyii3yMS/YuSM+7esJ+UCXQz6AqWlF5y/gTi2usNUGuHph6Uuye+oCRaa0qD+WO7GSQDacMcJx9HpHGopSneDEBLicmcFVby0WcHWuadW+aTu3aF5eZn7mE70l8rHOTiQwK3339obfGmhWHtUJPudHynw6yRQWvrDiuxuzD2hD4BMV0Az2NasGvqIG46pJUXE8yiNPky5W7j+rHdxV6OU5MmoJba39AuL9gqDnOl8Npr74Xqrqink5mBk2OPRpK+JDLaxQtmiSrjQE1kfxemGI81G+VWR9va8LdRgMa8yrwPP4NsMo9EwTunreqOwEi3c9sBrq5raZs0h6XhY2PsJhlupXQauEBPXpO+p5ulN+d6r+m7qPbAKewj6KVNXcRklgmRYCz3L8MMtddRcxM4AlAhONB4HtDjLmzffZUcaBxZBC8eH53FI6skTAx5P6d6aEXHy5zHVyETcuhuQBcRyMHmNhhojeGB5UE/+1wqfy1F9z+IlqWnPvMMbbycEzwQACprYRhnOJiG7MNizF+2AHwfgALmcUoNYcUAiFCEo9kxxH/+RRypEcCY48u1yUWiswsTtxQoGEd6ICI9FeZ7iKZEcfGhxOs31SvAQ3vcTQyWute2E5LiDHHVqpNekiQeiMYQWer9tkgCgZqVCEHO7Ao9UtcqdF3GLUraXsJRxV/Up6rsYrkDUQ9V42whFOOKA6WGso/pBji4lQtKf3j6jV1FOcT6M7ItTcZ5EV0XRJ+zaVoNkT9xUcl3VkSV39c9gp0xknbop061G6iQdRfy9P40g/3W/L/p8u29Xx9qqiuZyzN1ZjoXUk+Qz12UAW1fdwgnNYs4bAVGj31fRmtn1gMO80JZ2dnSJRhl7d8P33SnLPMsD2BTaVUn+Lmo0dv7lRqGoNWJ5EdDYb/LSqv9ZAFPa574B1JsyswVXzaqwhU1lnp/IVIbISFz8cVo/srMkT5YYyGT
 H0uHJNVj
 0PGy+SDgap43aGZejXoM1WvoURekJm3GAl+5DzgDQ/8M7FwQQIKR/Zen7LLixy47nVLhuje/9b895TiOMvOhJvSRRYuI5AUCXKwRrzuiOgYTPZC6qUxJr3D+MxdzWjsc/PMPVMZKsfT0X1/AOsJ4w723Cen26DX23/oyRfQeYG2RsGm+JVPfTJo/jDg3MPj2XliC7cwMY0Tlo8MQfGq4XK0iaFLac3Bq7GERpuVMP+4TRtKE7md4qFdPr2GB6TYe8BiHHLjZpwel6ja1j8P9zMiRgOAEmbWU/uAVuV9Hyd5Wlt8R+qDE1nh7qBitfBejkCbEIZ0fS8YHYtDU6cR4XMePDOmVilksnOdJ+W6yHg33+zUlC90XdW+TCJVUZXF8bOY7Hooc3Ajyaajd1zy4taJSigyDKIxdz2Kb/MGCqXZjlT4S1ANFL/6H5l5mV3srTqhlL
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

With the subpage->private == 0 check added in a prior commit, any allocated
compound page should not have nonzero subpage->private. Remove the
unnecessary subpage->private initialization code in compound page
preparation.

Signed-off-by: Zi Yan <ziy@nvidia.com>
---
 mm/internal.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/mm/internal.h b/mm/internal.h
index 181e79f1d6a2..c96421ce9350 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -895,7 +895,6 @@ static inline void prep_compound_tail(struct page *tail,
 {
 	tail->mapping = TAIL_MAPPING;
 	set_compound_head(tail, head, order);
-	set_page_private(tail, 0);
 }
 
 static inline void init_compound_tail(struct page *tail,

-- 
2.53.0


