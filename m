Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2A2F3C87FCB
	for <linux-mm@archiver.kernel.org>; Fri,  1 Aug 2025 16:29:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7CA956B008A; Fri,  1 Aug 2025 12:29:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 77BA96B008C; Fri,  1 Aug 2025 12:29:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6431F6B0092; Fri,  1 Aug 2025 12:29:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 528FC6B008A
	for <linux-mm@kvack.org>; Fri,  1 Aug 2025 12:29:40 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id EB6321D9AFF
	for <linux-mm@kvack.org>; Fri,  1 Aug 2025 16:29:39 +0000 (UTC)
X-FDA: 83728724478.20.A1B01EA
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2055.outbound.protection.outlook.com [40.107.93.55])
	by imf01.hostedemail.com (Postfix) with ESMTP id 331DC40013
	for <linux-mm@kvack.org>; Fri,  1 Aug 2025 16:29:36 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=NrLkKbpC;
	spf=pass (imf01.hostedemail.com: domain of jgg@nvidia.com designates 40.107.93.55 as permitted sender) smtp.mailfrom=jgg@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754065777;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pJJM4EZKVnt3t+yNadjWzDSo/q5ptRkPqEfLmtp2Vek=;
	b=lnTKrIkRNV9kCq6EVemw5ncBZ/k05OJM0uKQzG04dfIPTTPO18rwJEGGDi2oFiSKKR0dE5
	OXXb99CfdXfg8mMqpFVsHe1KiS8UZEMfVzC09HAIgnoM7AEPE8NBzMSGRAHslTA5eEIHP/
	tgk3+2rr3V7g5kanYWZFj1hHQE0K880=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1754065777; a=rsa-sha256;
	cv=pass;
	b=TGRicwD54U2tg1ZT3AQY+DGgm4+WAeGkUaciODWqUs5u+D4/Zw3ZIhG3IChzp8vY+L0tdO
	lFqL+i/eSTMteis+EGKjYHd0S7IDBKiZJxxBSVXdldZwgNlQOzycq4uKQFZPIMPBRF4hBL
	e7SpUNCDXIiJbmYzXuNw9BqJutD5xs4=
ARC-Authentication-Results: i=2;
	imf01.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=NrLkKbpC;
	spf=pass (imf01.hostedemail.com: domain of jgg@nvidia.com designates 40.107.93.55 as permitted sender) smtp.mailfrom=jgg@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=D2H3oXkqvw3iZWVinRSowcrxvH6CvkGeTL/+ZUdvL8bW0/37RMuDV4t18Xuz+LcXWX/QRijRUMJ7OLqavw9P7I58dw1yC0HYdoxlUSYNHhPmcDE9qV7hpZiOheJsymqh96VEZC6oCgnWt15AOOhJSrqgZX7GvlsTf3p3CYy+fgUCHngtPyXNe1bCte9eWhYK3mB6q4jz6GYtElAI5kuBSJ4j0xso7m2cStVCytxCriGKqEq2PksqdjncLFuqgPaskFxnA152lq6d5vwTIa+dRQ/kdB1CohreROPIhfr8a+Qi0np+0HOnmMMVihC2ukbno14OUKy31WcFqGPVfZ9T3A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pJJM4EZKVnt3t+yNadjWzDSo/q5ptRkPqEfLmtp2Vek=;
 b=ILXeVPJliQCoIk2rr5VAfMswza94TrBs/pPuj5fWCEEJeo2oovTaGGPBWYNR8Nd43KFMl8PFudR9JT8hwUMd7NDgJbMStELQnqXktDH/F5ETtZahuTnTbQ7QH14EsZk2tV+/z0XDq4DpGsqXR8TV4E/cIG0LXjP52VTNj1z3Jj6dRB/RVsk7s0jnG9hdgoYQkS2k3nIowByQDn2Fi8AtVivopQZ3gQRAib1esjYJN5fdOKj/byR3ziF8VV/WNZnjTL8+TOjdTVKaT0QXTREyY4tJEzuzYkMLAnL6F3Eyo/7hWjCUaY55L2v+KXmyDW7606yYxnRSJ9nczIcvr6MuwQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pJJM4EZKVnt3t+yNadjWzDSo/q5ptRkPqEfLmtp2Vek=;
 b=NrLkKbpCsA0Fhbs1RpvCKdnnNKewsB12s0tHrlta3u2r3eW1+5fTMLp6SazG8aaK3jgobNjtZEXMpzCFlSFWOVjwRzyx7AaBtbvuc/LqOA8i2QVD+fVwqqiJ7jbvnU9O0/GCv3P3FPCXbKwEYUZdujH50MRv8rKv8ihVc5YOGYGL5/5CLAtMSw1Kz6vRCcnUcNFemsSxwr3puRshb/4cppkjWPSSn6gmL+1XXBoZMLtOb3QQwZ9FhaquZjGfHaFSj+oObiOI4rWPL1p5gTHP1X6aH81ynLoI1ydzlcyo80jXZ2hrTHZZkwzLk2K4NeJ8pDUH8GuMi1FPUBc7NuIpow==
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by PH7PR12MB7281.namprd12.prod.outlook.com (2603:10b6:510:208::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8989.17; Fri, 1 Aug
 2025 16:29:31 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%7]) with mapi id 15.20.8989.011; Fri, 1 Aug 2025
 16:29:31 +0000
Date: Fri, 1 Aug 2025 13:29:30 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Jens Axboe <axboe@kernel.dk>,
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
	Amir Goldstein <amir73il@gmail.com>, Kees Cook <kees@kernel.org>,
	Josef Bacik <josef@toxicpanda.com>,
	Matthew Wilcox <willy@infradead.org>,
	Vlastimil Babka <vbabka@suse.cz>, Jann Horn <jannh@google.com>,
	Pedro Falcato <pfalcato@suse.de>, linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
	David Hildenbrand <david@redhat.com>
Subject: Re: [PATCH 00/10] convert the majority of file systems to
 mmap_prepare
Message-ID: <20250801162930.GB184255@nvidia.com>
References: <cover.1750099179.git.lorenzo.stoakes@oracle.com>
 <20250801140057.GA245321@nvidia.com>
 <3cf76128-390a-4ef2-85a7-e3ee21ba04b5@lucifer.local>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3cf76128-390a-4ef2-85a7-e3ee21ba04b5@lucifer.local>
X-ClientProxiedBy: YT4PR01CA0157.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:ac::29) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|PH7PR12MB7281:EE_
X-MS-Office365-Filtering-Correlation-Id: 88bb2e3d-65e7-4277-8328-08ddd11897c2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|7416014|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?6bXujqj7XFkkwTg7yoVHCuHF8Nps+EKlGQpwW8mdbUqIvef0BJ8fYwakmBZD?=
 =?us-ascii?Q?v0GOtVYLkHpPuY+5EdM6/IojMBBtfmqDUopiVRtQ5p8N1OapSl0GCXfPA6eA?=
 =?us-ascii?Q?lSSn2GPqJTDNRFafqPn3UpXU1br4ihDNzdYNujF4TySO/KC3059Dr1BislNN?=
 =?us-ascii?Q?qR0rNu8356CT2DheqSHsxWRRj/CFJ868tTaiM/aW1ps3yWbfviRfs8m1rwzc?=
 =?us-ascii?Q?Lm6ErqBWVlUAWMDcL+1ucvouGb7nn0fZm8BeTQc8j/WcgMS1fgexAT58sVxL?=
 =?us-ascii?Q?DWGDQFtghr44ishsDP22wUYoM5Q8ngqjd6jc49dqHyxbM9NddO9H2wVd0HT1?=
 =?us-ascii?Q?OaOUdTQUwwBj2MiyKpT8fmbclVN11QdETWNWpvbP76q+1Qz+Ni0EYJJmGfq3?=
 =?us-ascii?Q?4jVu9bCn9BFUpLkOzw1tO2lOcrSARgLOPFJmoSI664e3soPvCJnz7wVbgf1v?=
 =?us-ascii?Q?N+KDasTr2q10RCLKxQAvV5T6PNWdxbqc72rHe8cYfdYj4tSR98TvBjFQQno+?=
 =?us-ascii?Q?qMPJqzskfIsGFHPcX8CNLvmdTSLlzuw3Sif6ttMs9rEb/7JV7/sv8ZyIOJuv?=
 =?us-ascii?Q?8aGNoxMsKfbjkFAjJmxfbTSAnLxbkCwlVw8KhwGoOTrGwVofVrQELggwfX3A?=
 =?us-ascii?Q?9ufQV7wesutA4YyPDBTnbRJD98oRLYpExU8lzloQ535OMcrtMJf0uy6ys5ca?=
 =?us-ascii?Q?itjYPYjg+nTkLkYl0HSEkcSGoWn65CY4XQewO/f3mm4w6u9on1s4rsxmvHJh?=
 =?us-ascii?Q?C4dnLOjS5XZPfZnWNB2YEpzagE5bEelMYM+PT/DlHrxnqvObM7qL4CBTWYxu?=
 =?us-ascii?Q?1BFlhR7eKW6M+yicQQgmoA8C0olSF8wNry0E1OMZaycbDx0J5inujQPgKvp+?=
 =?us-ascii?Q?yaH1eTXk44Vu5rLJLytQ9HhkWL4X7fVtkFPgn4zuuVkvKnzsvoarzTuKxw9+?=
 =?us-ascii?Q?3Puk/+7W1v9EL7+7veImaYqjI4lKzawmy66CcKT5yVKtRtOsOWxdZa4Kxtvj?=
 =?us-ascii?Q?L03ikyjDG2/qQaNYwEN30yGgivqDl4o+BNR98DmHCjdam1wPD7yn8St0+s0M?=
 =?us-ascii?Q?eP3zFfUGPc/M55utLQTW4yl7xztbzld26vAMQxBw7Kd0TH/2noV3rIWP9nbw?=
 =?us-ascii?Q?nWO6d7HAlF4+4y2xokdOMdXBt1QmdtHwmVP8481QH6oqomd4Lutq7XmTvxsf?=
 =?us-ascii?Q?fS3zRP4wNNN8if6NGfiaNJ+SZK7Q1OKMZBZRa9mhvbe0gFByS2vLbaVxbhgE?=
 =?us-ascii?Q?6CllMgL9/yqjZkohpKx1WdfH7WDi+jgOq6wy2iIQ3GUZmnYci5HVJFbA5/Sx?=
 =?us-ascii?Q?IZDrRqwOt8WaUEQj1lL5tpGwU113a41MIfGcxQbb1HzMttD+9E6wvHmkLiof?=
 =?us-ascii?Q?KhD/2WqJBl0gZGPCoXVSPY+/tkkEnxGbx98qtUXu9jzb3jewfw=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?/eCvRK1UlY1d6/9xJaFu5mW7W/n6j/XZnxDxlI56LkBAXpds/JRuqfponf+/?=
 =?us-ascii?Q?OGgBAb8789of5qfqu30SCpIvC8/4m4C0uR/C11vBHBxCHlpM1KAJNUTiqe8X?=
 =?us-ascii?Q?eKR/1t6lHgAZIuB/V8TsdnAMn3HPwbaLVourho32nuLb9ho172GQbURu0WF6?=
 =?us-ascii?Q?lc2Xeowz5XXLCXYqXhTJVL+XM6PKjchUTyMX0wb9ASp90se4IY9L0waHvWqS?=
 =?us-ascii?Q?L2geEJBSRN439jOYJqXplZuPFmYelMYxQHI7ngvpiNCvXwKBH1Yiv85ExJjl?=
 =?us-ascii?Q?pJaVzHhJZqh/4tCBNUzAT6LrvGmoNa7/X6u4qE9AV+B2UgQXcwei/Zvo2pP5?=
 =?us-ascii?Q?gqTzNAsGxYvR7XAASYd0TPdweK6h8DAyEjZgmyus3XNdXiccFCp7VcW7NFck?=
 =?us-ascii?Q?higm5i8fKMSJ4N7nfvGbdJG7VAAAhK7VEDS9i0uzksvPSiJ/GUDV8E/a7GVB?=
 =?us-ascii?Q?dhJ4kwezOoE7YAf4AJvCwpvPdbnpHm48L3zHmQwRLXyyea/wn2Cg5bu/kQFw?=
 =?us-ascii?Q?mYR7/VDqx3H+WWoI3pJIu7Wow/bPxxkEgvBptf9VJB6TCZR3Q51HZ3VxF6SZ?=
 =?us-ascii?Q?v0C6G56EP7IRtra9wJBTH76rPG1KHRJ8Tco9CMVdxVS0/e+ny41sgoBaMUz8?=
 =?us-ascii?Q?1X+9G2uiyDgy7fmHYaaVencFXIm/hbC4RiR1/ranlgChYGwrygV9hehAD7fW?=
 =?us-ascii?Q?tOi56yTdC7DBhCcWoytgQCC9SwahzJaa21lHOlSqWHX7DXk6ydQRjCyCYBKk?=
 =?us-ascii?Q?4hI2IJ7X5EGUxw1YIbd5qTdD3uZC7rBTsiaFiObn9Tr8D8w6OdVi1CcynEP7?=
 =?us-ascii?Q?eFdOL+6D7WlVNbi9EbPiBETQLvQOU95wZzsaNfYgHU5lJ5lFPpzw1QrbJHeD?=
 =?us-ascii?Q?THbuY64qNV5Elfvaxy/P+w/l6/q0TKwERE9u355vyeSWXKOmHMqBZceozNnb?=
 =?us-ascii?Q?pRG0icZHhMSQOjuY9NYW4z+GPo2ka3QlOr45T8T1bF+JTKUkhxpZgEeGvPHI?=
 =?us-ascii?Q?BDMXy4WZVbhqV2hrOcd2OwIyq+7CeiGLKUyIHNX3w9TwyeuLld7Xqu6QOJwX?=
 =?us-ascii?Q?pLdRlL23t/g1JzsqCaud5rUw5dTADYZOpQE/lPACEYgZEnEhFyaXumqmDmMr?=
 =?us-ascii?Q?zWp7KL+EVdje+uLexocE69V97Vfkv7lBSqYovcVoT9BRihn9vBlDrkB28Lsu?=
 =?us-ascii?Q?mmUIi0ZN77zSbw/aYBo0Kwmlbkx0z7vVkPwvVWTV3ToI8kgAoNkTZeeLhfSq?=
 =?us-ascii?Q?0sem4ksVT3ZnFTeEo/pbU5xhbZXquFbf7Qby/4eisN6VBSumOoC/jWxX/IJI?=
 =?us-ascii?Q?fp38SMGcCFth0idJa/7gSs4zMgVBuup3sksjdqmGkE8zQURWm2zEYA7OV6Zh?=
 =?us-ascii?Q?MSx7Um+XAXDUeH7VE25LMFU2s5ECoIx34Hed7fy9Pf3lk4tXrdrAVtTqtSaF?=
 =?us-ascii?Q?ZQ3YEa40Nhe6Rjb3jkuMwDYE0Aa52sx9E7F8VC5H61rJBpc8kVgFTiy1lcCS?=
 =?us-ascii?Q?w11LpmbV0a5JenZGeU5W/YRmEx+6669zXGSROiEDzXOJrquRlNPAUdafk4AF?=
 =?us-ascii?Q?JnPTkA+uKWhtrbyHuRI=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 88bb2e3d-65e7-4277-8328-08ddd11897c2
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Aug 2025 16:29:31.3585
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: F6pt/ZToG53hF2HArccnZg2upkh5UNLJe4eGTZmksj4NCMoklVLXZUEaEM01Z2EQ
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB7281
X-Rspamd-Queue-Id: 331DC40013
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Stat-Signature: gwmej4c8gfkux5yio1bf6jofqu6x9qgy
X-HE-Tag: 1754065776-985728
X-HE-Meta: U2FsdGVkX18UWQwF5n/sLkLfDolXVr/6LdyzkC9ZFZ/gi8ep/9MjecrJIcmavGozA34YO94Cfh0OgI45A/CQwrCFOeJT6igB6G14Z9C+Gx+BaO5jAJUPyoPiPhbfOiABq5SsBavGnDER0Y6NxsyLz3s2UR7juwZ3Gau69mP75rRnQjgASgpuEOvjfrZzEp559aiURvtpmyqObGPfHZMnh5bG21RyNzyBAHu4UDNJBGyc/p+TKJCYpRNiFooep3oVZ6x/gcSLf0+GyW78mpcbSbxS7ZBWeqYZRcfdT9oRWNP3JrK3xiy1Lrj69M5h/ZP/5RiiwZP5i8IsNAnpspOlQvuOo24qsiPzbWgazQIygUq+fKCpWdV1f5Tnn+bgAInyUqJNF/SHWBOSTqXmMIC4lKJf6ExJpiUc9NZ7o6vrl906OQhD1zgsjabsZQZ1O9M2hRWZ78itKEDsWtW7PVT5TONgTkrCBcg4z57jAeWYF82bMMNWhZ+A1ZAFhL34zJ+9fQeL4WVJN7CQ3LEIxoPDCCJcaCv/Zp55JIy5e69VoqQrBLqGqMPGXxUcpDFoqpFjGuJ6PN83FOAiHlyYydevFgZ1LDjP8UeisFP927LsGTk5GS18EkEch3/moSMDTRzxyIlKy/JG2nkz7CLilBej8s+mcTLRMfMpZuA5nxq3lF79zmWPmiHBxIjbRmNzXuR4I596HeGXD78sCt56x1FWwU1Flf3vWU2ucS+C+4TYnGRcp1aOWqVmUmROTPrO3VThUSym+oMxZ012g1+TW/qEqDEtMjDzoDmkr5c0PORM3wcv+s2+Jwbi9iM5PHKFman5qcGLNKOa2u4CCElh/6GhnV+Y+ts3+xRun939cpnqz4y5/fTskj1pVtPcY5+0kA81Rb+x+nBrZZsrpeITZ41M7+qTm+OdePLhvLfp2SPoSls/4tjeFcmaGSsoNHOGVAcpn+Ob1rfn+fRqXzDDe7+
 F4tiWqBE
 pBkvTr5kyhKPuaRhgsp07irLdVR1dVa4VeyIY6CmWnJSV/uWriPThLo7LI0z26Sklijg9NXfM9GvgguJu05ptEkbANBjrohffixDXThIl7UyjS4MwwihIs2zEiuRIc74/BShj8PpWP385XAY9lJV+n23KTVugK5GPu3pmvNNgrLS0Z5roHQAzsZgdkHunKI97JMAa4J9dZAAMx7+H0E7ugR2oVcKYkvCcgYbSD6/3kvdNR3F82Fo5kHk1Al6l7737sioGiYcegs2Im7ZcPLXnJR9+lTlIYbIY/VROGKcC1tYahf6331VYmqJEviqL5LT5GBZ2fk/k7gbNbC+vOyZUmJs5zZzxbeCvn6g3l3xacsqhFbY42m19ZfaLQ40eggRAAkdizrrL+4DxLOm1UFtDcR1iWIJbN7VZkl7F8MmPZkb4jhKhL2uaKgN0uTGfSgALM2qBgdX264KKrkOeQmqzK2pZgneJl4mYypU1cvn5HqJZkG/ikICN3pXR0TxZgvf005HQBDE4I6fOTg0vnPoAwUvs0xj/2ilGmd49xXavSgrOqes=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Aug 01, 2025 at 03:12:48PM +0100, Lorenzo Stoakes wrote:
> > I would like to suggest we add a vma->prepopulate() callback which is
> > where the remap_pfn should go. Once the VMA is finalized and fully
> > operational the vma_ops have the opportunity to prepopulate any PTEs.
> 
> I assume you mean vma->vm_ops->prepopulate ?

Yes

> We also have to think about other places where we prepopulate also, for
> instance the perf mmap call now prepopulates (ahem that was me).

Yes, vfio would also like to do this but can't due to the below issue.

> > This could then actually be locked properly so it is safe with
> > concurrent unmap_mapping_range() (current mmap callback is not safe)
> 
> Which lock in particular is problematic? You'd want to hold an rmap write
> lock to avoid racing zap?

I have forgotten, but there was a race with how the current mmap op
was called relative to when the VMA was tracked.

ie we should be able to do 

     CPU0                              CPU1
vm_ops_prepopulate()
   mutex_lock()
   if (!is_mapping_valid)
      return -EINVAL;                                       
   <fill ptes>
   mutex_unlock()
                                        mutex_lock()
					is_mapping_valid = false
					unmap_mapping_range()	  
                                        mutex_unlock()

And be sure there are no races. Use the lock of your choice for the
mutex.

The above is not true today under mmap, IIRC the VMA is not added to
the lists that unmap_mapping_range walks until after mmap() returns.

Jason

