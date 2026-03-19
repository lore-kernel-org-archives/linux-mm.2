Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E71851091901
	for <linux-mm@archiver.kernel.org>; Thu, 19 Mar 2026 17:39:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5D3506B0574; Thu, 19 Mar 2026 13:39:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 583FA6B0576; Thu, 19 Mar 2026 13:39:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 473A46B0577; Thu, 19 Mar 2026 13:39:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 372486B0574
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 13:39:38 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id EC9865A115
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 17:39:37 +0000 (UTC)
X-FDA: 84563524794.12.B14A0CA
Received: from BL0PR03CU003.outbound.protection.outlook.com (mail-eastusazon11012057.outbound.protection.outlook.com [52.101.53.57])
	by imf04.hostedemail.com (Postfix) with ESMTP id 4332E4000E
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 17:39:35 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=Pmi2h+2R;
	spf=pass (imf04.hostedemail.com: domain of ziy@nvidia.com designates 52.101.53.57 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773941975;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aB5GogGh1k8EhzujYNB3nBYa5yAvqU1upagpxS07e84=;
	b=PohjiXGIbabspXBQfRwXVc5caXIjA/utMP0N7JgBdwYOEoLLIkGjq+0tzhBZjMZGEIvN5a
	2onBdAK1jYhKtJ+eFRSaf9KwnyEDuDqSBjFF9izaBjKeRTqGbrIHLAV1G5Y4O/wydocFX4
	wb3BzwLv4vY2wEpWP4enPakloZcIa+A=
ARC-Authentication-Results: i=2;
	imf04.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=Pmi2h+2R;
	spf=pass (imf04.hostedemail.com: domain of ziy@nvidia.com designates 52.101.53.57 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1773941975; a=rsa-sha256;
	cv=pass;
	b=A2iPGZigKnmHiRRj07z29ELQ53QSo0btR1Uv++fC+QJAx8lyu6hpPD2JDL3yNYEqCB0RdG
	IWlzTPWiI8apmhI/13dGWo+0BWfr8CSH5YL8M0I8Z2ZMJ5mdBuIlbr1FlJpbTQMLNBBB78
	E4M50+015hyEQrj+SkRnx421d/31368=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=vi59yFMEVH/M2SwOJ5pLShp2RzzCQqxgjT9xxR97vN/jBxSqVPpElzycsg6VsOgNZLCV30+Ch6Twx4qWZm8DLGl0aamd6wYRaXuKZ2CIyEARvd4G8wwxo88YOZjQbUANzkXV8hTNR+AFtJxxWIMNqyszkmT34q2/2HVU3OfFbmiG+oFKg4/hs+LZUlAqurD0TdJrrI/2zNUc3ih7f8PrAlPHLSy8ES2D3PEwBRg89KZCc+O25eSyo4UIUtUUXNz8EFAKqh+bTBAt5NRlnGjlnMir3HhVBiwIjMDEoHBiBeD9834llGmI5K//wxRlWExMUrwlJuIUPzI9pwO7bHxdaA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aB5GogGh1k8EhzujYNB3nBYa5yAvqU1upagpxS07e84=;
 b=UMSKzS/S0OdYBq6Fh3vnF3lQQ7J/6WE89oVqgSORmmH75GPHqaAnvY5923IjkJcG+Y5yHlVGC4ebCzWYDPpIGdHbEcIAKuS6of+iX0oBvfYV5dPWZ2rlLlDDKfORSpO5SsWVfRyAU7nRav+ZYPEWRydBh2MAzHjtLV5G+ckIT5i8W6FI4RXjqQW4XwIxF9xAvzE8zViuKJlDhDxB791zHMBmFIoLdvF87/ooqjSKnQW+/uQWor+tADNq+I8VpaxYC9K/Q+bxTmK+4hSthzHYM1gzkGenixer7fHxYIyv2Td6GSpH6AMrdFjLZAjwCW1GBLFoeBE3KS9lZRqzwnYW9A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aB5GogGh1k8EhzujYNB3nBYa5yAvqU1upagpxS07e84=;
 b=Pmi2h+2R4bL+gXhXWe+WYqUom+EY3tw2Lr3wDO6EQFyl/OuWI09xKWKtWBzLeBMFMrmANwfryZBuUJgVvpFqxctmqH0g39uLCBO4kXp390nZxdmxrnUIJKORJexyq4ymWFGvUB0X59GmD9ISb9s1EMqB5HkWToSO70y3w/7LQt3I/2HDBfiUgu+Qyps+B57DI76o6Xj6KvwtsybWGxCZSVHpWjwLN5CkkDjhLQHYQk/24xNEpxnXWAcBajVe+lAoYazw50X6UgcnMVTtppFgvbQ3ws6SXAI8Efe/JK2D+7sSiLOVtuiLn1oIs1nO4DTPMifTiyDhO1K1RomluQp8/w==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 MN6PR12MB8492.namprd12.prod.outlook.com (2603:10b6:208:472::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9745.10; Thu, 19 Mar
 2026 17:39:28 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2%4]) with mapi id 15.20.9723.016; Thu, 19 Mar 2026
 17:39:27 +0000
From: Zi Yan <ziy@nvidia.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: linux-kernel@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>,
 Will Deacon <will@kernel.org>, Huacai Chen <chenhuacai@kernel.org>,
 WANG Xuerui <kernel@xen0n.name>, Madhavan Srinivasan <maddy@linux.ibm.com>,
 Michael Ellerman <mpe@ellerman.id.au>, Nicholas Piggin <npiggin@gmail.com>,
 "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>,
 Paul Walmsley <pjw@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>,
 Albert Ou <aou@eecs.berkeley.edu>, Alexandre Ghiti <alex@ghiti.fr>,
 Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
 Alexander Gordeev <agordeev@linux.ibm.com>,
 Christian Borntraeger <borntraeger@linux.ibm.com>,
 Sven Schnelle <svens@linux.ibm.com>, Thomas Gleixner <tglx@kernel.org>,
 Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
 Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
 "H. Peter Anvin" <hpa@zytor.com>, Andrew Morton <akpm@linux-foundation.org>,
 Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Matthew Brost <matthew.brost@intel.com>,
 Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
 Byungchul Park <byungchul@sk.com>, Gregory Price <gourry@gourry.net>,
 Ying Huang <ying.huang@linux.alibaba.com>,
 Alistair Popple <apopple@nvidia.com>,
 Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
 Clark Williams <clrkwllms@kernel.org>, Steven Rostedt <rostedt@goodmis.org>,
 linux-arm-kernel@lists.infradead.org, loongarch@lists.linux.dev,
 linuxppc-dev@lists.ozlabs.org, linux-riscv@lists.infradead.org,
 linux-s390@vger.kernel.org, linux-mm@kvack.org,
 linux-rt-devel@lists.linux.dev
Subject: Re: [PATCH 2/2] mm: introduce CONFIG_NUMA_MIGRATION and simplify
 CONFIG_MIGRATION
Date: Thu, 19 Mar 2026 13:39:09 -0400
X-Mailer: MailMate (2.0r6290)
Message-ID: <42DD15DD-9BBD-4A65-AF76-ADEC557AF416@nvidia.com>
In-Reply-To: <20260319-config_migration-v1-2-42270124966f@kernel.org>
References: <20260319-config_migration-v1-0-42270124966f@kernel.org>
 <20260319-config_migration-v1-2-42270124966f@kernel.org>
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR03CA0195.namprd03.prod.outlook.com
 (2603:10b6:a03:2ef::20) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|MN6PR12MB8492:EE_
X-MS-Office365-Filtering-Correlation-Id: c0502396-98c1-4ef0-1268-08de85de77e2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|1800799024|366016|18002099003|22082099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	6zpuQDdvB1yW5aeBK6CMilMeUWX+MZEI23Azc7ADxTbRYVlt0jdXU2/iWZkOHsOhNTkfmsj/Pz1ZDZPlfc0iEsxu5w17NGo+ClqwXFx9SVzQbi/ZyelNLxWqJNxu8+ia2bzVsIiRUuN4Zsqygz31alQUak/HhUtM8qvve55/9QEynVnnBtIjtUnIQ5S4FsPK5Tw/0/p5hxvuvktYJoJjRjqroyVblb2lQCBIJL0PnNZfyUKb0icZxokVknj5YaMMgCUKCdoRsNU3x7NArGHi60eC2Wn0BkUlKltLefSlu9qQrEfxjnm3R5ECHWMN0ON4UHmzf5UOGKYc6Ac78wjT2xmNvXCuyqsfAaHB4iO0zfFkTI/L9TSaCbxW3F5R3hBu7Ij6hXoCWmA3mD2YjmlncW1JD+aog3pEcQ1Qc5G1ULV4Rk7tFHhGdBDdZbqCsn37SBkOyT3mOfQfaD9wBNsqemYJr8Zll9S7bTeAc5ld1v85PVyltdBw1YT+TcTgIDYnZN4BPmg2jyVfMSPfmvrDPEoNNzH/b0E4TS03xqSU0yLcK+sks6AlAokeYUh7Wna0vpHV6+EUJX38LiBnrhCuSXNisDFGHK6mOIXfoMKwPGPY5Xo7S88q3ggACHqPSrrvyrLhELG6UG5cEZ5hgH0qwvUaVaRyR+lwke2rvYWO/ibS85geAjv1/MAeThyue1YKAQzyrVJiNDQpKsz7rlCffKSY/SoBxIBrTBCBC3L6AlM=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016)(18002099003)(22082099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?vj9d5CzGm35TZS7phsBOH9ToJaEfiHH4LywbKDYhJZTbaTySmMsuDPzNUhzK?=
 =?us-ascii?Q?oAFwHuOI+Ztv03gHlg48EyZuvJLj/mz1nub/RfOq1lUXsSEKj9hduQE8yWI/?=
 =?us-ascii?Q?IjYO4hvJ3rt7lWuQQH3tQzHbFi9xVj2qtFBXKB1vTz2At0qAtU7dZE3A0N3O?=
 =?us-ascii?Q?iCednXSWsP9+iaUcdgpaw0waY68MImPo3uTB4obu3L8BhB/5fi8md/Vbnyef?=
 =?us-ascii?Q?4knvBT+9Js7TpPT4dfPm7wIQySLkzdNgq7a3NIwb2mDN2tPTbtUh9/Qe5OJv?=
 =?us-ascii?Q?eKlSCCxq/vMKsdaIMXNV4QDrOJoYHsoHfNtUdfKiTYyb+PUhz40Vomb4/zwi?=
 =?us-ascii?Q?IhvfUx8tmUgw4xPKM78cs389hCFLkFln3Kv86g0Pe3mzSo+n5BsrPEc3GU2B?=
 =?us-ascii?Q?kAT05PAO16Q1lokEqTT93EPc6brALo66QXIOFze4Ur5waDmGPtU4Jn4IKh3a?=
 =?us-ascii?Q?Axpjpf0R38hE6wzs214bYC/6TMUuYgBp4+3nfLbJ7YdxrmDPtysVvBg4gWmG?=
 =?us-ascii?Q?ZfELIfN3bJ7HCjnGqmqhiFhLwWNFTUjDjMjukvGGau+4Xl44lw8xSCuWCK6E?=
 =?us-ascii?Q?iuxjAQetqbNGBputFf3LxaU0Y4ULoOpnYP5bsDe4pB902bWxL3AiXhEM3gPR?=
 =?us-ascii?Q?/vpID0coqkd6s7sOV2DqHvrGr3RDIBHlUWsCcYtJI40JSKm8+hTkTsOkmYzW?=
 =?us-ascii?Q?QB/21f4nyCEirmsnG8LXpwnO3JFjI9aKfEhKgsql+PjQxiIxlOHqbRvv5BD6?=
 =?us-ascii?Q?9acCowf7ECQ7OelkI4MwTIwJqutNNp2FKz6xheG4DWzruCSbYaC82R9bkeTC?=
 =?us-ascii?Q?NvXXan7AYVHW/Nf3ZXPT6q6olEDzsww6q55lmjiTjCvIMxnUkQaSYJVLKhdr?=
 =?us-ascii?Q?7t/n0qCH1CV5DP75EFwpYt2axcp0bIX3AtbBG9/qxQiIXo4Zy1vQQ//dkP/h?=
 =?us-ascii?Q?Su7BCXI9kC0iw9BPE9tV1bj2BQlrSfCVygG8Tj/3TgTydyhiJLtj5VtUL//8?=
 =?us-ascii?Q?9H+mz4vLgb0N3xIxHWIz6v4tebv0FVLnKDqXoZc1pqgllcA/T25yrCzbTkoR?=
 =?us-ascii?Q?sytPhUZ3NEXJ5ikfKfX2vy6gZAguumY0uFwe8LzfN2zeHxDYU56viiVilvnw?=
 =?us-ascii?Q?V7GOnGVAI/u3RNbXmlWgFaB0fYXj9xxaYaZILG5Cx6tpIKJooKD49hYvKdBl?=
 =?us-ascii?Q?hLBCS3gTECJPUy7rWVsrN5wBAmJY3UUpapYVt98qkGpyRG4S4E+JKWMMBBNx?=
 =?us-ascii?Q?0hfEu51DzXex7SzPXOfE40pYswLGVtZXeClEQiBt45rqJoqoFx3IuQ+mYWD5?=
 =?us-ascii?Q?Cd7g9w+BB2Bj5GU4FHljtuLNEk620uIyd8VnyUhBt5FxdB+JD8LVjeDgmjZk?=
 =?us-ascii?Q?MIexwmeCYX/6i9NuveB8eeLhiWDxMqhvwWOxJxiKu4NVA1EZ0Dt4zaU9vOlh?=
 =?us-ascii?Q?70fEO1DHD0Pp4wkdS6gUG6nk1nz1ulROlBkjm5gPXG7WS3W0nsrPrFdnW4nu?=
 =?us-ascii?Q?rzE1hDPzYtQWycctvpE792g1OMuZPzLT0oBBsF67KhuoZjxjdygPyZNgIyvI?=
 =?us-ascii?Q?j7DNxRSswiaOGK9Ej8BQHnkS1itK1px6KTSHWepaJ+gP0GU3P9wsyaxwMy4u?=
 =?us-ascii?Q?1TY7M4+SWzSwIFMa+cr5Xe+xEghup+O5hHYlKZ5jVtnjOcmmKJk3CIoBZWIc?=
 =?us-ascii?Q?Xv/R2ZlZb5jKOly5J8p93rFUKxKtvwnJ7vwkwijsyz9T0fgo8PrdBbCP+PCM?=
 =?us-ascii?Q?LBQ89XNO7A=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c0502396-98c1-4ef0-1268-08de85de77e2
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Mar 2026 17:39:27.5656
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6oxJGO1GyFY/VC09tZfgCWYbo2sjSkrQX0km0hP5BMVjAEeVPC9sBwnuOH3jLky8
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN6PR12MB8492
X-Rspamd-Queue-Id: 4332E4000E
X-Rspamd-Server: rspam07
X-Stat-Signature: rwgtocgt99ana7646aebc81gh83n4nmh
X-Rspam-User: 
X-HE-Tag: 1773941975-238558
X-HE-Meta: U2FsdGVkX1+cRO64GgGZWSbi6O6+Pb1SfUMLCZZ7HN8+rSqU1ICcwF3Vi6nUcRxukxLPLTSS09jcSepck/UlGIM/yWJelVu2o3xD6WTyh04YShCFovf1CQKOHu1KuXysLZe+0Yi0/MDFZd1DWBVbo7YgCRuPvRv6zev7J0X6stuhs9glGZA9RHR5G0IguCakfZsQePK2939ya++6tTxFFIZSy8/t4jmzVDBkW4BIW5JcPu5YOZL31CgvHNQfD+X0ed27XaOyA5Fwn+s3PB4Z1fbgqPtgwd9X3aMEBCvW9Z6Ko80pgkrlIQq7E2Dz6nmptmUKDv+0TcDu8WuQ7d7aAQ5S1xqC/fcTamDMVHvdJfH9Sun8u0pCAqMFIttnzKtmj+4dFCxC0pzzcsiTuue9CegSvsEUR6ea6hdNA4v74TJEryqvlxvlwQJKonMCyf8iduQdD9vTFSi0lfyPGlKYrq/qPldp659sYkP3h/yjSNijFQDhO19Nr4td6+z/Ddga2HfVrVadmQNTumUQcO4Ln9ChVs7lXLnVLn/SdrFusOLuN0NtCnOO/wQVM8KMgUqtCU6TPUP8tatJhkDalNzjgY3ERjAQA9ldMMp60/Y03o8jrc+VFeEPKcK5g3cZ5j+Ndf94SmZoWManrfRG/04EAFQxgk4+mE2RDyn20HPfL3JyodS4EV/7Py733Z5AGC8EgQ4wEhpFHxq/uBBN4qRtKq595OUYOd/ywYZ+J/7jWQAzS6NPSot87Clhuaw/rMeYFKrquC6gosaT2WISrj4R/BwPFGouUkLPJSSNZupy9qtaJ0z9+7FwonYe8gPXH0gGKfvjGKKFHNvQg8MpSEkzS6AS7/wnL3/eBl4bfPo1VpgGDXtnS+PO8vEm7Y3rZfzfFx+r9L544Uuqzw3IHC4N7jqN16gM34s4RkGEvxdKcgs5V6c0JjvKxtitDbMFEvbwluc5y1wzSo4WKjT3S19
 CBay2rUU
 lJUnMBJYVTYlvWdYDi3FCwv2J71GwQLAuiUVfg5qW13OWNE6NUxfK1GSiwJYKlOnWS9kW8Q3XXUcM0jAhCxJRMdFI+BCG1gyN4x7JFtReVAyWQOWCqer9O3T9VBDhGfBLePOH+2eUP8WYoT0uU66Dm/Cn29ojiQkVF4f2WNAqujuCbI6KQyd5y3Qk6rete6S6UVj+gH66kgL1Z90FpLPlXJHuS/TUOLE87r3orBWIZPRClqVERZWKWmNQYs6v4qIEh3cLYxSxnKOGvWQZ0nw7HnSliytrOU7t29I8biYclFi6pl/9GcOwZgHA9AFvM5/KHnk6JI7WP+VMKQfHE+oreX/WB0rn+xpTyoKBCc96X4ftfrYQdSIBhA6rSNi1mN2HiVbL+/8YmAdafmkzzlNRngmgpbccdsrR5zy1o7WMcD3rfzobwxBksG0x7jqI5ha45XGWvv1EUpbn2OkmnyKC1U08jNYh78IpY42XRL9G9UyhHQs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 19 Mar 2026, at 4:19, David Hildenbrand (Arm) wrote:

> CONFIG_MEMORY_HOTREMOVE, CONFIG_COMPACTION and CONFIG_CMA all select
> CONFIG_MIGRATION, because they require it to work (users).
>
> Only CONFIG_NUMA_BALANCING and CONFIG_BALLOON_MIGRATION depend on
> CONFIG_MIGRATION. CONFIG_BALLOON_MIGRATION is not an actual user, but
> an implementation of migration support, so the dependency is correct
> (CONFIG_BALLOON_MIGRATION does not make any sense without
> CONFIG_MIGRATION).
>
> However, kconfig-language.rst  clearly states "In general use select only
> for non-visible symbols". So far CONFIG_MIGRATION is user-visible ...
> and the dependencies rather confusing.
>
> The whole reason why CONFIG_MIGRATION is user-visible is because of
> CONFIG_NUMA: some users might want CONFIG_NUMA but not page migration
> support.
>
> Let's clean all that up by introducing a dedicated CONFIG_NUMA_MIGRATION
> config option for that purpose only. Make CONFIG_NUMA_BALANCING that so
> far depended on CONFIG_NUMA && CONFIG_MIGRATION to depend on
> CONFIG_MIGRATION instead. CONFIG_NUMA_MIGRATION will depend on
> CONFIG_NUMA && CONFIG_MMU.
>
> CONFIG_NUMA_MIGRATION is user-visible and will default to "y". We
> use that default so new configs will automatically enable it, just
> like it was the case with CONFIG_MIGRATION. The downside is that
> some configs that used to have CONFIG_MIGRATION=n might get it
> re-enabled by CONFIG_NUMA_MIGRATION=y, which shouldn't be a problem.
>
> CONFIG_MIGRATION is now a non-visible config option. Any code that
> select CONFIG_MIGRATION (as before) must depend directly or indirectly
> on CONFIG_MMU.
>
> CONFIG_NUMA_MIGRATION is responsible for any NUMA migration code, which is
> mempolicy migration code, memory-tiering code, and move_pages() code in
> migrate.c. CONFIG_NUMA_BALANCING uses its functionality.
>
> Note that this implies that with CONFIG_NUMA_MIGRATION=n, move_pages() will
> not be available even though CONFIG_MIGRATION=y, which is an expected
> change.
>
> In migrate.c, we can remove the CONFIG_NUMA check as both
> CONFIG_NUMA_MIGRATION and CONFIG_NUMA_BALANCING depend on it.
>
> With this change, CONFIG_MIGRATION is an internal config, all users of
> migration selects CONFIG_MIGRATION, and only CONFIG_BALLOON_MIGRATION
> depends on it.
>
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
> ---
>  include/linux/memory-tiers.h |  2 +-
>  init/Kconfig                 |  2 +-
>  mm/Kconfig                   | 26 +++++++++++++-------------
>  mm/memory-tiers.c            | 12 ++++++------
>  mm/mempolicy.c               |  2 +-
>  mm/migrate.c                 |  5 ++---
>  6 files changed, 24 insertions(+), 25 deletions(-)
>
LGTM.

Acked-by: Zi Yan <ziy@nvidia.com>

Best Regards,
Yan, Zi

