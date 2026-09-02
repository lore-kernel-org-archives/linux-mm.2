Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3ED58C61DD3
	for <linux-mm@archiver.kernel.org>; Wed,  2 Sep 2026 01:57:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 40CBE6B008C; Tue,  1 Sep 2026 21:57:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3E3F56B0092; Tue,  1 Sep 2026 21:57:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2D39F6B0095; Tue,  1 Sep 2026 21:57:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0410A6B008C
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 21:57:32 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 7F04680675
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 01:57:32 +0000 (UTC)
X-FDA: 85167160344.17.99909F6
Received: from CH1PR05CU001.outbound.protection.outlook.com (mail-northcentralusazon11010054.outbound.protection.outlook.com [52.101.193.54])
	by imf28.hostedemail.com (Postfix) with ESMTP id BC63AC0004
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 01:57:29 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=Cbv7rHO7;
	spf=pass (imf28.hostedemail.com: domain of ziy@nvidia.com designates 52.101.193.54 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1788314249;
	b=FfK4DZSvgwJcCTOdOkJ576DAmsc4FYfqo5piSkpI/bvYbnivv2WneUL4jWokYGdEVMJWnx
	Zx3HTHZPAiQp8B6H685Ys33j86dCgOrg9jEoSM6Qr6irau5aCMbA2vAQfyLD2wepQG0tu6
	24Rc1INgxpA4i2FXup8tfAqUmesni7s=
ARC-Authentication-Results: i=2;
	imf28.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=Cbv7rHO7;
	spf=pass (imf28.hostedemail.com: domain of ziy@nvidia.com designates 52.101.193.54 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788314249;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6ti2UZ22foCHCBQz5S6+4lGKIgAZLw7P4tSyC45CFbE=;
	b=4AAfsx/vLPf1JWJBSS+5LbA+fc3JZK5Go36k5sRpCzh4GqvUvoqW4yl7edom1IIZdhvtXj
	Babbc3ZSi4Aptisvc/ZAWNLIbeJok6bkffCNmDxvdAOQaslHBuhQ71s/0taud1Er+Emac5
	TkmVwVmDGNH601uAyqhGAGwleG2ThVM=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=y600fBY6Sg0ve5s+zGHte3H7VwyqNwQR3q4AIr1eBjoNbe9Ju0FLcDh6vnuxWcHhdgMO4NDv8wO7VtzAGCed8oU2ZgHX+8BL9x9nTXLriQUFFtYhiOo/+xNGRT40F0RVEvXSdOTUwpdohKxaC7TdsrosWUN8Ku7VFxrHoWXqQ6R+RWx1Xs9fBvHoD3I5YR839317YkFmgV2rgHIVfmUO1+aAf/2KN6c8F6imJHcQsGyVIudD4CQEjEDyWeVp/2Omt8MOw8Pi3I+sEOh+IkAuDAPwEDCNICibmeNEbzdbO3pojKqVlttj/OE8kCN0CVVWwQM1Wlkte6SKeAHTO4/25A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6ti2UZ22foCHCBQz5S6+4lGKIgAZLw7P4tSyC45CFbE=;
 b=Vn0UiDEkZL8JlTVLMW71Oxpqmvyijp5DxGvDK9JOVFibDLj4peg2FJwTq5lnjKrKvVZuxf4iouRvloU4/Pc1LoIAvxy2yg/KdEaDbGGKduTrkMd7KsVv1ersOWVGzexJB6OOsCP8lotx1KfTeP1z/96+Y6lOp6mIy+ww5jzfWwOt4AOlI2bAt5ytA+3fMhs9IVtWfC3kjRdveL23A0kvXQkkc3g6mTm33vRfkyahKK00k1P55bPfhT5pW4NjDYM8cpTu45Eth5Hl7PfMQYn7maX2zRqzKP0r2d73vpsKza6Yw//rEF0jZfYablS2pozAUuI7R7X8CQwbjXSIa14QPA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6ti2UZ22foCHCBQz5S6+4lGKIgAZLw7P4tSyC45CFbE=;
 b=Cbv7rHO7aAHTaD5aDcw+s2cjaUK8O+7NOWfBXSMH+Q1GQiF1dVFhHIb7I8qfJIuS5i0yirg4a8hL7fMVi6QBjX3DRWi35uInwta9IR1YcUz/4UNvWLuQ5Rh/PjE22PipxoVw75JJLOdgDoghf8QzxEx1/V3y1o6CgMoVIpyrrc+HeNyVVsKfq2eRRkCAr1zBG5yZwdC5tF/fdIOnrx87UMO3zuLoHzx+lxpqW2K8k/YigWm6CV418Jla/X/tPhbDgt5t0qtB1KmhQTw1KuU5qLRydf77+U9P/WZcxKZuZPDDiQ/2t+JRk0jI7aQjZl2+k+iNGv2ocpmOfahmTKbeNw==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by SJ2PR12MB8157.namprd12.prod.outlook.com (2603:10b6:a03:4fa::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.360.13; Wed, 2 Sep
 2026 01:57:25 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%5]) with mapi id 15.21.0360.008; Wed, 2 Sep 2026
 01:57:25 +0000
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Tue, 01 Sep 2026 21:57:24 -0400
Message-Id: <DL4GHQ8J08N5.6G85VESOPSTY@nvidia.com>
Cc: "David Hildenbrand" <david@kernel.org>, "Matthew Brost"
 <matthew.brost@intel.com>, "Joshua Hahn" <joshua.hahnjy@gmail.com>, "Rakie
 Kim" <rakie.kim@sk.com>, "Byungchul Park" <byungchul@sk.com>, "Gregory
 Price" <gourry@gourry.net>, "Ying Huang" <ying.huang@linux.alibaba.com>,
 "Alistair Popple" <apopple@nvidia.com>, <linux-kernel@vger.kernel.org>
To: "zhaozhengzhuo" <zhaozhengzhuo@uniontech.com>, "Andrew Morton"
 <akpm@linux-foundation.org>, <linux-mm@kvack.org>
From: "Zi Yan" <ziy@nvidia.com>
Subject: Re: [PATCH] mm/migrate_device: fix function name in kernel-doc
X-Mailer: aerc 0.22.0
References: <7D206FC95BDCAA0F+20260901065131.1759298-1-zhaozhengzhuo@uniontech.com>
In-Reply-To: <7D206FC95BDCAA0F+20260901065131.1759298-1-zhaozhengzhuo@uniontech.com>
X-ClientProxiedBy: BLAP220CA0004.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:208:32c::9) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|SJ2PR12MB8157:EE_
X-MS-Office365-Filtering-Correlation-Id: 143a537e-1b29-4809-349d-08df089588d9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|23010399003|376014|7416014|10067099003|18002099003|22082099003|11063799006|56012099006;
X-Microsoft-Antispam-Message-Info:
	5YkAHF7O4/Xs48WUssEKZuFyt+/LNmqBoZsE9SWwXmlr0QVF9hUNQ1EVra+0LQ9QpW3XKek/b5Zfc9uhz5O6OQdFbeF2L1EFlulupZhKGLr7luUxs2G1QFOmZ9xuRnNbr/nGq22oTOht/cCzwIHcxPc2KM0dgApX1t2M6Z3j46zBKhdcUaOeUyx2fE4edqauIOv7zUBs7KVxuhJu+E4r78yNr/zsp1libbi+dCI5+O2DuEuyqP7OOB4s/x5r9gioUJUSKJPflbh/LGoT3eYVv5Agn6G/8eKb3vXRoeKc93EFDhmXsqsn7Z71vnnIIIRabYOqCU0mx6XnM/UrdwfF3Nk+x6VJiwHl561jQGkjBDcptjzPK7sXNahVebLcquyaSgQgco9mPSuSMasyMPaQiLKJBqI0Z3lmap3S8KWy7Hq/sl68idM8jzeyBnjIQo2H7hRF0yRBXX0pmE3tdE1FQ5Snu57YCTFGChoCI0q4vDcaudK3Kmjv/PUwAzuNoua/3ONZ6rtAJtjPnDVviAxMuacGzDqmLCs+tmNyHp3cLKgA4MictGDJ4HAx/aF8suih46EQqeuhylxVmRILy5AxguQq8aI6dpsHlvoAV8CJW+6q2K2N5/GnHFpV6hh/HPpvt4SbY/UzqZgRX3BI4I8DDj/h/JkpVWD5IFc8uTrxb1M=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(23010399003)(376014)(7416014)(10067099003)(18002099003)(22082099003)(11063799006)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?UEZZbXpPZEY1SThjWm5FS1ZIanNQbU9kMmIxNkF6cXlXYVg4UGdxd3Z6R2Ix?=
 =?utf-8?B?VFYwMGRrLzV0UHIwa05XbHhIZnZNd2xrNktyajczMFh0Y3VqVWRpUGJXSlIy?=
 =?utf-8?B?NHhrdEx1UGF0OUNEeHFoZGhqSzh5VHV5aEo5dWJWQ05EZldKTGFNeEg5K2VY?=
 =?utf-8?B?UnJEVDg0L3Rxb2llR1ZTZ3Qrb1ZqQmQ4WldTTG1mZzhFOFB6OGc2VWhHMGtt?=
 =?utf-8?B?Z1VFajUyZ3lBS2ZGZk12b3JuV0VId2lwWkYvcnRncUVES0puMzNMc293SkxR?=
 =?utf-8?B?alc2Mi9ucnBtcVRrTVlKckxaUE84bXFBdFZQbStMYVR1WlpyMG1WUHcwWmkv?=
 =?utf-8?B?QjA4dGxRVy9KaVJta3Y5NzdTVTVmOXlNam5iUGNBWGhhMTE5NzB6cFJYbWl2?=
 =?utf-8?B?dVZmY2lqbE9Vb2JaY2lmd1AxYnJLZC9HS1p0ekM5dnh3U0ozV0RNNTF5OTVY?=
 =?utf-8?B?OXNjZURjS2xrcXRSMFZ0MFBNK3VmaWpYK2xZd2w1d3RjRUw1ZVQ4MmZ5Y1BF?=
 =?utf-8?B?eHl3NnAyb1pWNHYrWlQxR3lDaFQ2b2d1NjMwam5ybzRQTXZtTi9nSDIyUmpF?=
 =?utf-8?B?TzkyaFZhSW55NkVZeDVXSkg2aGhJYXc4d0w1bTNoYVVKR1plTXNwM1p0OFQ4?=
 =?utf-8?B?aUxEaUc3Z3JEd3VDb0FjcFBsNUx3NmtaaVJPRW1ySGM2RjVrMjM3K1VFMUxw?=
 =?utf-8?B?czR0Rkw4WU42WVorY2RONzRmTWlmbXZWZjFYTnFsUFJFWUQvUXYyQ2RKK0N4?=
 =?utf-8?B?dlRaYVV5NWlMYUR4VzgwZEVvdk5EdUlqSGZ5QUFWQmtvWHdWZmlJZWI1Q1Jz?=
 =?utf-8?B?dHRmbFBadWlUWVpTRTYwRHRUeEVqbkI4Q1RsR0QvZmJKeTcwb0YwcXJDQ3g0?=
 =?utf-8?B?cjBLOFAxNWxjakZIbURlQlMvWU9WYlBMWVQvQkVTK0JURzNLT2t1TmhOQVEr?=
 =?utf-8?B?WlBXMlI0OXNYelNwR3dJMktEKy9pVUNtclFUU282Qk0wNUhpOHh3QVlMSEps?=
 =?utf-8?B?NDVkT2lnMnJUckVuMENSU2ZRSk9QR3FTTkZzbmtVWDJpcG9BU1VHZkQxekJ6?=
 =?utf-8?B?b2QxQlkwM2ZKcTdpNGVraFNBeGZpRDhyUTlQM3h5ditnUFBTNlE3UVV5eTBq?=
 =?utf-8?B?aEJNZ1E5VGROYk93NDNhRjVUOE96OE5US0lyK3lsM3hSVVZzN1orZnNkUnRk?=
 =?utf-8?B?czFXcDdUWWxEc0dIa2U5dUdOUlRBbnIyWXpUVEJselZVNENoSmtTSllkQ1Np?=
 =?utf-8?B?VENBRENVM1lpemNTUUZpQTNkQllpZERxeHI3MWFlWEp1TkRtRnNtcUlBMks4?=
 =?utf-8?B?dkFXdXZSRUhBczJJcERWcUZMS0d2dGVYaHJ4bGwzakZlRHBoUFVrVFVLTy9v?=
 =?utf-8?B?OG9Eb0IvMnhiL2I2eDBwMnRuZVJSSUpzSkZHZHR5UkMySUJzYkhtd01sb3Nm?=
 =?utf-8?B?QjhoWW5ObkRxWThkY3lYVmV6VWphZjRBZTdCNEZaS2h2SGZVVUgrbTN6WE92?=
 =?utf-8?B?MCtYbktPem9NNHNrdE01djFEVVVEM0FqdUJCaHgvL3JNZVpOZXZhWkZXUE0v?=
 =?utf-8?B?VHZGQVlmdUpHem9pdU9ZejU4QUQzNGQ3UzE0M0JRYnRNSUxmdEQ1QUJlWFUw?=
 =?utf-8?B?TFY4enBMSUlLOWtpaG1MbUwrYzZqR0NCOWg5azVnSHVpdk9LQjZSN0k1eVhW?=
 =?utf-8?B?K2JIR2V2QkFWdVFsQm1NMEcrN2lGOTZWVml6UUlyOXdhamp0RnZSOUk3Q081?=
 =?utf-8?B?S1p1MURvRzYzNEEvWWVCOWp2UkhTY0dNNURpR1oxcTJqc3ZJS0J4cGNWUW1B?=
 =?utf-8?B?bXJSSlllakJEZ1lYR2I4SlVxZDJwTUNOK1hsL280WWxkNEF0dnJuUWZUeVRa?=
 =?utf-8?B?MytFbUtDcFVueGx3M1FwT0hOWnQzT3J3NElnYTZ6UGNMTFlKZVVDZEdKWGdy?=
 =?utf-8?B?ZE1ETWJObSs1STEzdzdtZmU2M3prQ0p3TVZjWmdZSERWSjZtSExRa1pGSEYz?=
 =?utf-8?B?clo4b0V5VU1GemtvSXUvQnVXMXY4eE9Rb2xxTzZZYXpMRWVzSTN5YmVLTDZm?=
 =?utf-8?B?QitQaURuMlY4VEtYZTB5eDdQeWFIbGtoTFhtYzBwbDI1dlg4SllIS0FQRGtO?=
 =?utf-8?B?RHRidnI1Q1FvQ0tVekdTOXRyWjhwNUswcmM1cjJsZFhsc0xyaWt6QkZ3U252?=
 =?utf-8?B?UFBGb2o1RjBWcjExYTlVbm1rYW5aOUlFdFFMMVR2dUk4L2NxamJab0Iremha?=
 =?utf-8?B?aU1WT2crZFhtV0h3dUlGTDFicXhWOWJUV2F0OC93RzdDbXJNeUdNOTNiN2ZO?=
 =?utf-8?Q?G/dxQ1x0GkHOusMZCh?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 143a537e-1b29-4809-349d-08df089588d9
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Sep 2026 01:57:25.0905
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0tNJegMrFeHyrk/pFwoOpaMJWvF16lpgR1VvQU7hKp5rCCjtg9B7UHvZ0PxRp32/
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB8157
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: BC63AC0004
X-Stat-Signature: stfirg69z6r7qxiho8tuoqfw4n47otre
X-HE-Tag: 1788314249-182275
X-HE-Meta: U2FsdGVkX1/LLz8BmcdiR/k4nyHnLdz23qTtzKtet5e2loT2g0YaocJr6T9zo1C4/wPtnzZWrhVHszQDxV3C1yv6pPvxxNmIBm+s9/Sh5f1qJMp9ASVZmgkb/vXiT4PSxUwMlyCBF9YafREB7hza9DVfA5dfbGP7Bv0Rz+yivjJ5wN2SyiNP+2vAluyGwf5geFXg97ReIXOsYftKAsEPISMOjUYI4Un4Not4l4XQlyZlrIk7mvA4YugGq35VmtbdF8QEFMoDOTrIyF/H2lXNNkCEJVg/54pCeydq0R+hRT7vKodhzDfpj14Qo6njDAXqzSIrEOAxBMLmKCPuWKULdRpbYAib8WvKZVu+RL/VfXuLWg8RgBCl6DhudliCuuonyZSxXyxI4ZNxxtsG0abOuloOuBXy23WB3dWqP7RO+rkItWHq8HJOmwxFijkXpCvh0ipJm8yd+D4T3mDoLpg0/sDbdODGmkNl8Me93fybhHqe+nXU7pSjFfD6VJyKBkePRHQAlcZ98CWR+t9U7Hxy5LY8UN+ISqwgj1DF/M5YShuCu0b39A9lWEPyP8PlDwieft7DVb561vzJkt+oD7pKxWOXQkT/AfyQV0PCAuWSFylzpt3uSGBLD4dBzKGnhTIaoWD4bTETX/knwM82pc5kVa4RYiWaLFN3B9OFfZTs2boUtJnwcbiG7w3CHBtW+33TwUwh0EZAj7bchOF0qh+bUhHz5qEJl55Hjw0vWAoPFpJLASZOe1piYCC9n+jYywH38iCbLepCJwWP1b47Ew7JEvgUOT5Q/rjaJW4pQ8Vh/CxFDl7J2imYbDv0Jv68WaG/ROIHfimmyKroWBe3ZyNiegnQC9m1MNjMUc1u7IkqOS7h851FgqtrIB2p7BKY4H/e6VinVP24RLSmZqr8+QySoPFIof4vn2ZpMRCoKtkoOz1AUdWdWxu1GhWaEuvZ0otSgalohtADJYDDmJobGAL
 3cXdudE5
 UqsZfaYryT9qsiqnthVgB+Krev55xmcNOkVX2pYX79jfWyMyK5iObnRxsFSlqj0BBsgrdoYKczPI5nXds976ltmnztVevLC39sEW+h6UNUpAM60XyUGfT9b8WwEYMCt1N5Y8Fbz5PDqKviXfIGFAuhTaQsPO5uTpUa4ArNJyRU+914SLhKvjJ9YkJTkrI8QsAY/ENvxJj7AURLZdGeqbKjq3GH2DrLhY8LNdb5t+DIPqPqRq9WReAta2CZM/36uTDWU7uAKwnXnsZo6e8O1W/JT5dt28Y7VO3YaervLeZKheqeScuT02sAyLjVsVYXKHRVG+kfeV4ylMLEFXub1ufpEtV4LjlZbgPnIe7gyL/yQb1IK5oQywqdo3CBw7eETEX0feTHLKi1WmU9VXMrtQBHvTJ3Jfdc96DBJ9zvAUi+5rmIPv1BsHqjXvFtyiLsOSqMY5NqxHaXMp64AmmL2XbXOxJrSEX9ke2Noh31o3i7sWuS3cRItrjd4ynC9oHYQxasylykDdgSjr/0hXK8VJtQD2RbNnIDmlU0PFuuBVZHKPAGy9M1VOf3z273wZvb2h/+y3R0QTnwLke/LA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue Sep 1, 2026 at 2:51 AM EDT, zhaozhengzhuo wrote:
> The kernel-doc for migrate_device_range() says that migrate_vma_setup()
> is similar to itself.  Refer to migrate_device_range() as the subject of
> the comparison, making the distinction between virtual-address-based and
> device-PFN-based migration clear.
>
> Fixes: e778406b40db ("mm/migrate_device.c: add migrate_device_range()")
> Signed-off-by: zhaozhengzhuo <zhaozhengzhuo@uniontech.com>
> ---
>  mm/migrate_device.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
>
> diff --git a/mm/migrate_device.c b/mm/migrate_device.c
> index 009bfa8b212d..4a614a3488ed 100644
> --- a/mm/migrate_device.c
> +++ b/mm/migrate_device.c
> @@ -1398,9 +1398,9 @@ static unsigned long migrate_device_pfn_lock(unsign=
ed long pfn)
>   * @start: starting pfn in the range to migrate.
>   * @npages: number of pages to migrate.
>   *
> - * migrate_vma_setup() is similar in concept to migrate_vma_setup() exce=
pt that
> - * instead of looking up pages based on virtual address mappings a range=
 of
> - * device pfns that should be migrated to system memory is used instead.
> + * migrate_device_range() is similar in concept to migrate_vma_setup(), =
except
> + * that instead of looking up pages based on virtual address mappings a =
range
> + * of device pfns that should be migrated to system memory is used inste=
ad.

While at it, can you also drop the last instead? Since the sentence is

... instead of ... instead.

>   *
>   * This is useful when a driver needs to free device memory but doesn't =
know the
>   * virtual mappings of every page that may be in device memory. For exam=
ple this

With that fixed, feel free to add:

Reviewed-by: Zi Yan <ziy@nvidia.com>

Thanks.


--=20
Best Regards,
Yan, Zi


