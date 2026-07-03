Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A2727C43458
	for <linux-mm@archiver.kernel.org>; Fri,  3 Jul 2026 14:07:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8F7DC6B00B6; Fri,  3 Jul 2026 10:07:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8CF716B00DA; Fri,  3 Jul 2026 10:07:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7BDB16B00E0; Fri,  3 Jul 2026 10:07:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 519896B00B6
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 10:07:18 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id C91AEA0153
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 14:07:17 +0000 (UTC)
X-FDA: 84947642514.26.3B42B1F
Received: from BYAPR05CU005.outbound.protection.outlook.com (mail-westusazon11010027.outbound.protection.outlook.com [52.101.85.27])
	by imf22.hostedemail.com (Postfix) with ESMTP id 005E8C0009
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 14:07:14 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=FmJFlUM0;
	spf=pass (imf22.hostedemail.com: domain of ziy@nvidia.com designates 52.101.85.27 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1783087635;
	b=coVUFWTHI2gN0nELPOZe7BSUU20JZfzwfz4HYYdEd955pnqU3w1wfKX14JJmzO1x+TAZi7
	nVbg++2G+yt3aWyAOvpVMG0vX8g2JcmUDY7TsU214YfcITqDrJkjGOLeD6TDH20oYQidkB
	DZqmUUODYft9heW7c+lb2aK1+2Ml2Tw=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783087635;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=J5SsvOiulisatS9mB/z4aC3rLtARcX2CCixaRThcDWQ=;
	b=LMIwtAUXLIPIS/5PfpQClyDY4UTD1WeGslJ6D2lqphh66H/0lOgNNZO09/rhHv8vVOGOBD
	I2dzBvPpmpdA7jx7a8VuI5F67EtJkoD8YyncICMxXBn5juRAtZEiaC7GK6LUZUuAnm58xs
	ylIp79YQ68Maom9jLFPTREXCtyeZcu0=
ARC-Authentication-Results: i=2;
	imf22.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=FmJFlUM0;
	spf=pass (imf22.hostedemail.com: domain of ziy@nvidia.com designates 52.101.85.27 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=kSL+ueDbw1PJkWCzegcxFdkLjd+HwZH7YL6Icjep1jQ7A/3BMEuEB+zYOFDLE8jCsm8Hoy4720aaXA4k0gwqRRtNt7W7QyGijnhRWhbt44hwLAqNLgvLmr18lk9Q8SZ+YyO0vRMNsPGxjg73Btr8so9i6m/bY6EwbRn1gzgkcOVi+/jgOWCgfLZOmaGNcWSfsDuKUsS/hkXwq6kI1Ap7ttxf3SUlYur9E2t8xYdExzduXNWtR1xDfIcALqI/HFLvQoh5+oQpv8KLzAI8Vp7SlGgRpEMv6UY6BaFXKAo+QhM8CDLfVHzZ/kLIliMly6aQ6uY4ZZay/N+uBgsx+hJgcw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=J5SsvOiulisatS9mB/z4aC3rLtARcX2CCixaRThcDWQ=;
 b=tMNKx5tD1sQ62sIzNOfDWo3FWBjJ1lTn5dXsg32QnFMZQRimLtLF4Ck5uEc8bQoIxuzWJJ8p2O6uUyqIZCoUOA7Sa3UwxVIpjAGX1gz3YBjYwTImj4q6b7fHzX7tcsOLrL4KntJocHS2YrBNebWQC/LS3uMMEjI88Lq9CU7JuaBqrPAY1oHXXRkBaTVoUIB0bLQ/kCmoESLo6TZtAUzImpoheVK6SKjGGG6kuTS4paSJFHe2GrleAIlRKeK+8d8pB35HJ3WkjCjgjKfih2mYAzADAqz7QdebqA9dXKbaqLn4uwp5zxK5SRV8RJyW/8jRUzl19bvo944HmhQouveVIQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=J5SsvOiulisatS9mB/z4aC3rLtARcX2CCixaRThcDWQ=;
 b=FmJFlUM0SdTkpTNq2jWNyJn/QUxaq4UUie/hGuOMmTRs7BW/9/0aI7AjI8vipKOzHyLV/+9h56791TQwArrwvzHw/0bD6Ra0Xm4y0BILcPrL0piEjq4rgkKSJ/iw6dtcVaMRXhF/x/qpQh7qP8BeYhjkoKgkjzYV62N6ySpHQfQYN0s+IOKbO8O9xnCIo99uOTPHNmVM7cSCvX3QAn8nTrOLvgBxp2RMHueaADrRt/hoeWp5fBbdx2FHrZsoF/AbfHB6c2sFqdgl0ozIDNqIZL67ZmPKpvrfGaDOSOcsEJ4W6PPeKDcfE0slAwV1H4kKWtUYbsgg87GkmlBB6kVDUw==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by CH3PR12MB8308.namprd12.prod.outlook.com (2603:10b6:610:131::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.181.11; Fri, 3 Jul
 2026 14:07:06 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%5]) with mapi id 15.21.0181.009; Fri, 3 Jul 2026
 14:07:06 +0000
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Fri, 03 Jul 2026 10:07:04 -0400
Message-Id: <DJOZT6IW4YGT.1U1IO3ERN9NMN@nvidia.com>
Subject: Re: [PATCH v5 04/18] mm: Split out internal page_alloc.h
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
 <20260703-alloc-trylock-v5-4-c87b714e19d3@google.com>
In-Reply-To: <20260703-alloc-trylock-v5-4-c87b714e19d3@google.com>
X-ClientProxiedBy: BL1P221CA0040.NAMP221.PROD.OUTLOOK.COM
 (2603:10b6:208:5b5::15) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|CH3PR12MB8308:EE_
X-MS-Office365-Filtering-Correlation-Id: 2a4294d2-cee6-4ee0-3610-08ded90c5d4c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|1800799024|23010399003|366016|4143699003|11063799006|56012099006|22082099003|18002099003|921020;
X-Microsoft-Antispam-Message-Info:
	hw0R/6jp8qKkSodU/ltQoeNxKmw97YI9YBHdvsxJx45unYEoQoG9CK6YsPu6lTGRO6Esq6U92Yu7DTc/j3WuOhu+KhMccCwlDWnkv7GSMV3HZyGx3UaSBxh1AXtPvUYuLI2wq33eACKuR+cZhiQLloxOWXQWdC+wr4qb2ojSitXE478nmQKX4U3Bw25kuvnalpRoo+QV/Y1sDPepW9IqiJjzhzWgUxO+F7T2kxKwLx3boGpERchbawAR48QcUyNRgU7EoiP4XdCr2vB58bjUDxKzoWl2xvq/3lmvdA3rKIm72QjIcUEQ99+QLQNFBD2CjFoq5qfz/T7eK6vVtpx2/PrAwJHrxRPIWxtFxZ3bGO1nMO7jn3hn9GirOZCWZ/EkAKw6fJy0jkl0ssygiy2ir4n8k1AGi1mwlFT/h8Osme7OgUG7L0jtqWoUIPXA/Ngj9u95enZyTpd0AMUceSGwTPzV2DnGLjj4vxSGoAX1cvPGrk8mNWybciNPM5gBVXyOdSC00RYJfV/gSHlo95FgvZT+6lgTcfP6g/NThaC8KXJM5FqPqbYD03DVChaKd8SsUbzpZpnIwSnwsFbP+UUdsHEmQKz+nRrFzLz/Dph7pIiIDF0FAt+9uijFEGTn+waAilsLf2zb7mJLNazVVP8SDd6lRVfp0qJLQyIuHFU5yDI8sffT4DqelF2sAZt9Er3BGazMhIQWxM80ASdobHcF0w==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(23010399003)(366016)(4143699003)(11063799006)(56012099006)(22082099003)(18002099003)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?TThOcVFmVzRDaUk4bUFTQnBVNWJVOW1jMElpM3NDWmJJSnVOUWNQSEhEbHly?=
 =?utf-8?B?NkJFRmNzWE92NTFJYmx3YVRxMlgwVXFVRkVFM09LaU0xc3ltNVQrc2J1Q25B?=
 =?utf-8?B?MW5RNTFmWDhnNWRhSmcyaGU1QTV1QkhIWkRRS01CSTlPYXZSemoyRGZBUUE2?=
 =?utf-8?B?Ky94VkRQWjh6UmlyK01jM3cyYmE3RTZ6elBuQm1Lc3ROSHJlMElLK1dlV0Ja?=
 =?utf-8?B?S0JRaU1yRG1COVVjdGM1UmQyMzBKc2lqWmYyTFVhOXpxak1LVnBtclFMS3hM?=
 =?utf-8?B?b1p0TW9sK1Nqb2pob3JRR3BMNHZjSzZQNEpvQjhzcGNoVXFuNHZpVDRocVhs?=
 =?utf-8?B?R2M5U0RwQVhuUi9GSURwVFkyT1hpVFMvTmZ4MFNIV3BUTnRleGlqY2R4Qkpp?=
 =?utf-8?B?aUFBaE04TmhEQlFFUVFCOFBMM0Z1dVQvbE5tMU1vUUZvUmJSNUVDSjRWc0ZR?=
 =?utf-8?B?Q21CUEg0aVdoTjNvV1ZGb0poZVFic2hIdWtyNmdCdVNiR3UvZWR1WFM4aTA0?=
 =?utf-8?B?Zm1yOFRLNjVTWE1VWTA3b2dYRXhTMitIcDdaRTI3WE1jeThpYTZSRmR2RDkz?=
 =?utf-8?B?V1U0Q2tTQ3JRczd3ejZNaDAyTnlzODd5SHNIK1NLS0MvOUh3RDBXWkF3dzJ4?=
 =?utf-8?B?b3F6Q0VOc3dQcnZaYTRQME1nNWxsVnBNYnlFbk9WeklHZ2pqUkZqUytlbU5R?=
 =?utf-8?B?eUQxYndaSXU2eWJUZVBlYlQxcmVneEdtWXcwdWtXU1FaUEdYQU91TDZ6b0lt?=
 =?utf-8?B?TC9OQ2dLbkp6WTBMYmlCenBtT0NtbWxuL3JjYkV0OURkR24ycE9RYzZKT3hv?=
 =?utf-8?B?S3o4aWNwT0VDOFNnMFJncklHeDE4R3pGOHRzdFlSNCtiaFFYVGJGRmdoNHUw?=
 =?utf-8?B?dW5tRERPR3VOQnZJWGd3UWFHbDVpdlpHV3kxbm55czFQTVBSNFh5OWZWMnZH?=
 =?utf-8?B?cGNPa3VsRXRHeU5PbmxwNnpMaUJET2dlYTdVemlHVGkzSW9YZWhDWVNqZThY?=
 =?utf-8?B?VjVBYXBUQ0s4RnNaRHBpTGpJOWx6ZGRxSG8xZU4rWnFVUjVGTWwxRXcwZU11?=
 =?utf-8?B?TkQ2SHFuZWswRmhIR0FwWU16OTdMUWI5Vzl3MGJrZkROQjF0QThock0yU0RK?=
 =?utf-8?B?V1ZVek1LNWtER0VMc1BXMnBJU3FSTnpOZFM4eXNUaUtsVGt6ZS8rVFhuVTNG?=
 =?utf-8?B?Z3U0OTZUdXlxcm9WT1p5M3R3SFRMbURFL2F6R0hIWjBGNlJxR21MV1FDZUo3?=
 =?utf-8?B?ZHplYllnN21DSTVlbWNUR0xyMy9FSnRLbm83MzdiS2YxKytUNThKSHdOMXU3?=
 =?utf-8?B?MEJCek9nR3VnSERjRmM2dDA3VVdHcmZyeGE1OEFWOS9NRWZEM2hJSnk3eGh0?=
 =?utf-8?B?Y1ByMXJEZ0JEa2c1Lzd2dklRMmluQjd6M1VJMGxwa3Uwb25zRWwxRVVLb1Y1?=
 =?utf-8?B?UmN5elNQemRZMlVTbmhLeEIwQXMzOGt2TlBkSlhzazNtK2kxTmhLcmpnbkQy?=
 =?utf-8?B?eEFHU0VIc3czbXBoNytxMFJ2MW51ZXRaWTBJb05Xa1V0ZmNSZ2h4Y2RLS2ZZ?=
 =?utf-8?B?d1pPRHVkMVdjV21KTVpKZ3MwTkJmeHY3enRHdmdZSDQzMjJOWkdyT0k4Y1Z6?=
 =?utf-8?B?eDFOTm9lNlBnenlrUEw4R1Q4ZW53MWw4UDVTelBxbTdqdDdwLzBVdkNoK1li?=
 =?utf-8?B?cm91L0dtYkJlWVJBNUZSa2VSYzJ5OW9Ocm9lL0tqRVczSDk3emNJU2ZtWWhU?=
 =?utf-8?B?WmYwYnBrQWE1Q1Nuc3lmMHk2dVJBK0h5RmFPdUtZeEZZUUpQWTJkcmcwVkpR?=
 =?utf-8?B?QTRTMjhNb01hUU83ai9WcXlWdHlBanFsYmU2U3Jwd1VXQnNaZkU3SkdJY3pJ?=
 =?utf-8?B?VW5venJoMFYxeGcyc21kK0NlTE5rVWxwMndVVENlNk95V2tVa0lnSi85MGVJ?=
 =?utf-8?B?eS9kb2NUakNNWEhiN0ZrejczcjUrV29ZMXYvNWpkbGlybWhEck1VZExOY3o0?=
 =?utf-8?B?VVRBbGlyZUp0UTRTTWR4NVFvZWQyRVg2NjRJTmQ1NnBCaDlCWXRsNWJhajNK?=
 =?utf-8?B?aysyT0d5VUdZdGJ0YitFRVdmOG1ENDhoY0QvQnZNdUY5TDJibkdnTmZQNWlY?=
 =?utf-8?B?cWEwa3BJZmUwUUV4QmxReXVaT1RQUktRejQrdDhMQU5FYkgxVHhMRXYwTnM0?=
 =?utf-8?B?b2VmQUFSM2tHOTdSVlVnS3RWSE5WbzJmaGM4YisvMnh4ckp5VzBRTFpGSFFo?=
 =?utf-8?B?SHBwZHJaNTNPYkRZYXJjd2xvUDJLb1JPR214QkQvTzkrR3FXK3BKWFhwY0Vy?=
 =?utf-8?Q?Ssu2rRcuHunOD/RVp1?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2a4294d2-cee6-4ee0-3610-08ded90c5d4c
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Jul 2026 14:07:06.2663
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5p5KO8PwWyAxsIBqu/yhjjGDyjUWr+ynhsqRo3f0GnuqZF25peofDJIMN4gm4vwi
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB8308
X-Stat-Signature: hxdewft13dajwunogqojfarkntyowb14
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 005E8C0009
X-HE-Tag: 1783087634-49855
X-HE-Meta: U2FsdGVkX19TzOBZYvXTfmUcCvvuFGJaL3iA9Vw1NayMWH9u95K5blSMtlIlFIaGvXuIqjjFFrKFOLQidziC3eRDVCmmTOiu88Qh1zzu5mIT2jTl08RsjkRZUfP8UImtSWwUAdkyYTIsCw5S0hFrmaT6Y6x1gI5aOSz9c4EMi7SVe0MwMhVPfWWLgcBvOhq75hU3QUaMAyOdi9Yw0kugHpMnMY5KL3me6BMaWoA/KFS0eMtu6IaDxztIB/ALX8y5QJfkthJ/2+fSfqdL3L1GFw7lZ2FYscEuA1G3Xrf7BfmlfdrIGOl/frZpJl+b3kTxzoeHEPkBbykZu3YANZZseS7XOL/mekPU01ES0NKVI1QK+3v4sDZCcXX1/5rr3fXImRYdP495ROKNq1jbwKHt//AyseUp8zFZX/rZ2cmHt7SoJSWvzfWuNbJywzvY16wwlG7+u71kfEFM6QnZn9cdlg8Te5HaSZ+ql712J4Kynmc8AZ+D1o22BoZPWEo/CXi7dAzMS8LO3R4Lzwj+iyUhrSuuY0sAGFWStC5vRnlp8gwhY3q0+xznf4/1yT1E0k/FUgEPWVDlXBRjd7U8neNj791gjJbRoNTHrp/8rZbKZgZGMLwT+jGo0ox6uh6+wEhWDsOfiW3p1xsRKkexfhZyz6Flcb3Td4jR2z6oL3apb17DnQG9PyZAGeWsZOcFyPKfoqGwH7Xp2pd4u/Q8tewZE+7SZ9dMZEvjmBRmZ+l3oramX9mvOHEFUJxG8LNM/FvWBmwkHDwxci8zXc3GbSvOb6JKPUP+bnrWSwTCzxw40GR2AKOl60X5vx9tMSd7L2AAHrMnOhMY5lJHrXCIQcAuH6QTw3X8wdci+P4zL/rG8Yi0N82+RvPPiZUUKSYzO6jm0soEXwok8hacZWiL5YubUpTe6hnNSZbKtakV4sJV2m/DQz7h76meRmXwva/GG+GSkf96QwMpjD70xzADQrH
 lJiFOHOd
 XAdZN1pKi2lT78awuDi1jp13nC+lMtXWMEq/0msEOmPNCjxKugJLYHVcgiofqr0YueZkQ4KAYC6ydM+50fB6420XdOPAkoMFNIdE0qCIa7M1ZwnyblUrrvUrjQ7JTWR7R+X/iwAs7hm3fEg2pwD/2F14Ebu4zOhHRXKzPAyrKWZMM4F37fZAjIgfG8KbaeKNJmzZMsL+G+gIRsXg6IL2CqApvK70e9dkYRM2KXVV3XHDQ2+jXvYJbQN3YS7WFbUcBMmKNwsaymO9qmop+bAIQ99Jw/w8AQ1am6V54qJqOTom2OVo7LWi/nOPb7XMmJrbZrkSwqr6TSl/O+3DO7/+KqfborYXy5RTkowaPw8wWrzTdjV8D5Ld0FiRhLDV0Ev/Q2zGxMNXu6AOORONoVnvLWjsq9ef9qw0TYPOVUvOBk0F0V514J8Glrg/ujEEQzufjvfYz7AsJwk7AWlAPj9whi4zJdC3kz+Zl76avLgCM57K3NMipHxFNWC0Na8MUp9C1eYi2hsk0N8lZL3MuqdtbHEEDSuT0357+zXRA6jm4WjA7HLth5Wf5o5EzzElrTB51C1Fb
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri Jul 3, 2026 at 8:31 AM EDT, Brendan Jackman wrote:
> internal.h is a bit bloated, seems like time for a page_alloc.h.
>
> Where it wasn't obvious, the heuristic for deciding what goes into this
> new header was "does it support/correspond to a definition in
> mm/page_alloc.c?"
>
> Only need to include it from ~20 .c files out of ~150 so this does seem
> like a genuine reduction in scopes, which is nice. And there's no
> circular internal.h<->page_alloc.h dependency, so it seems worthwhile to
> split this up before that inevitably emerges!
>
> Suggested-by: "David Hildenbrand (Arm)" <david@kernel.org>
> Link: https://lore.kernel.org/all/41e92bab-6882-401a-8de9-154adbdcfb36@ke=
rnel.org/
> Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
> Signed-off-by: Brendan Jackman <jackmanb@google.com>
> ---
>  MAINTAINERS          |   1 +
>  mm/compaction.c      |   1 +
>  mm/hugetlb.c         |   1 +
>  mm/internal.h        | 252 ---------------------------------------------=
--
>  mm/khugepaged.c      |   1 +
>  mm/kmsan/init.c      |   2 +-
>  mm/memory-failure.c  |   1 +
>  mm/memory_hotplug.c  |   1 +
>  mm/mempolicy.c       |   1 +
>  mm/migrate.c         |   1 +
>  mm/mm_init.c         |   1 +
>  mm/page_alloc.c      |   1 +
>  mm/page_alloc.h      | 269 +++++++++++++++++++++++++++++++++++++++++++++=
++++++
>  mm/page_frag_cache.c |   2 +-
>  mm/page_isolation.c  |   1 +
>  mm/page_owner.c      |   2 +-
>  mm/page_reporting.c  |   1 +
>  mm/show_mem.c        |   1 +
>  mm/shuffle.c         |   1 +
>  mm/slub.c            |   1 +
>  mm/swap.c            |   1 +
>  mm/vmscan.c          |   1 +
>  22 files changed, 289 insertions(+), 255 deletions(-)
>
Thank you for the cleanup.

Acked-by: Zi Yan <ziy@nvidia.com>

--=20
Best Regards,
Yan, Zi


