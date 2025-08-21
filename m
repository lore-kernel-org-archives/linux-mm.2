Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B6792CA0EFF
	for <linux-mm@archiver.kernel.org>; Thu, 21 Aug 2025 20:46:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 067148E0055; Thu, 21 Aug 2025 16:46:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 015B48E0048; Thu, 21 Aug 2025 16:46:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DF7C58E0055; Thu, 21 Aug 2025 16:46:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id C76968E0048
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 16:46:44 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 99C10160550
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 20:46:44 +0000 (UTC)
X-FDA: 83801948328.10.9EBB0EF
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2070.outbound.protection.outlook.com [40.107.102.70])
	by imf14.hostedemail.com (Postfix) with ESMTP id CAD7610000A
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 20:46:41 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=svFEWHWH;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf14.hostedemail.com: domain of ziy@nvidia.com designates 40.107.102.70 as permitted sender) smtp.mailfrom=ziy@nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755809201;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4zV4M8m3AKmKwHhJ/SUSqW+gzDWqxJUe6URDNOe6HNg=;
	b=noIxZFBg8/DTXl2q3BYsqs+s+37DbxPIWm4vsa2pCNN/sFXUOF8BrU1jCUDKJwPtHRE2+d
	xGRDQnkJKccM1u20vQ1oaet4ND6S+LRGAzqSNWzRTOYYQdeBsajjaKwbgvGPdMWTn65k5v
	4TxNtZHQb3L2zbe+HjxQufezXE67RUo=
ARC-Authentication-Results: i=2;
	imf14.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=svFEWHWH;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf14.hostedemail.com: domain of ziy@nvidia.com designates 40.107.102.70 as permitted sender) smtp.mailfrom=ziy@nvidia.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1755809201; a=rsa-sha256;
	cv=pass;
	b=x2+o6l8y9mrzycey6M1wDLNS4RTUZ7Dvh7VaALk+Wm+KaXFCuHYNGqMf8XMaj7KUIapvDT
	hF8TVeBS6hzxn6DVrEQvS1NYiIodb8TqktFc/pkyaFCoiVcIncJDa5Wj2ImljqoC1TbMiW
	cNIgxRHYjbCbQctmLS4c5+Maeih4Fr0=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=D7n8Z7XOVuaGW3/8muWolwOxvE3k9c4reLFr8ladj3oIAxjNWAzplfEqql2MVHjX5lz8ePRZRn3Yd9A9Zi1U7bMfNUjTJC4JWAqARfcilaU/VKLd0i4FPk5KQjKNn54McdWF5ek1+yZH63JlW1cxDDTEjRzcrQMcLzfG9Sj3IacE9M86/KeS+mPptkkWCLyVaK4m/UV+58C8E2VYdyFpBQP8hFDnOIjxx7q2EEVrKU3oJt1teH5TLwxTyXY6KNGXNP+K7bQ1m2JkBIXbxskgc8CJXthtRPKrFE1NfEgjMsBg6mc62XDQUc1fYp2s6Dhw9h9ewuiYQS3KsGn3TYAs+Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4zV4M8m3AKmKwHhJ/SUSqW+gzDWqxJUe6URDNOe6HNg=;
 b=eHkFQBui4f1aOqxE73ULCkaM0E64XeXA3dMoPbUumA1SCpOj1yY1Y6o5u99oxuMVGMLcfGYVQ8Go0cuj5sm67vJEXDOdb70qhO7zybq/RKA6UkDduT0qOpZiSstu5c3++xcaG22bOIbu+4b0uY8lm73pDa3xDjxjYiMfNtQxMs0DMwqvF86y10gBZChAS0Gl0w2yxvB0LQi9SpNsyIioh/S6tCWOHoUoYZsu/fBGxiPbyiJjmKHcTqt2Vzv9Tlu4/wGqGXXr4YV3SJT8XO7B1hc94y8sdvtufxU8BhqbQI12eLRm2ABDZvsv2z9Vkh1YPQ9jlCHHjpHkT4HSryZNFg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4zV4M8m3AKmKwHhJ/SUSqW+gzDWqxJUe6URDNOe6HNg=;
 b=svFEWHWHXr23e2uL3rGh12VhkxyLf3mwQcvXJ37klIv8qd/0PAcItH6P/a48Ugvw7ayWHw1mgAjIXfd+cQpeX8LgkVRxeBw3VR0d9GC/en61u+AhKEvLuamepUquZru+Eqd59glFqHBavQez0fmYSz3r9gR6jLZmzRHbSMQUKhbIvvNCs77yMDmJ1KkWfVFqaraYoJdL2Z+AwZxbAfmwi2Q+zCd87cvTRZRyuVG1ZML1NTz4Y9ASbobEO/5hneQKjMBqVa7cQh97h1YGDxzKCWpOK8NZG9D/DRLyyS4s0rmlPCeg5oplEfo3UxXGp429t6ReY0N8Bjog3DNy1k38aQ==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 CY5PR12MB6576.namprd12.prod.outlook.com (2603:10b6:930:40::12) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9031.13; Thu, 21 Aug 2025 20:46:38 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a%6]) with mapi id 15.20.9052.013; Thu, 21 Aug 2025
 20:46:38 +0000
From: Zi Yan <ziy@nvidia.com>
To: David Hildenbrand <david@redhat.com>
Cc: linux-kernel@vger.kernel.org, Alexander Potapenko <glider@google.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Brendan Jackman <jackmanb@google.com>, Christoph Lameter <cl@gentwo.org>,
 Dennis Zhou <dennis@kernel.org>, Dmitry Vyukov <dvyukov@google.com>,
 dri-devel@lists.freedesktop.org, intel-gfx@lists.freedesktop.org,
 iommu@lists.linux.dev, io-uring@vger.kernel.org,
 Jason Gunthorpe <jgg@nvidia.com>, Jens Axboe <axboe@kernel.dk>,
 Johannes Weiner <hannes@cmpxchg.org>, John Hubbard <jhubbard@nvidia.com>,
 kasan-dev@googlegroups.com, kvm@vger.kernel.org,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Linus Torvalds <torvalds@linux-foundation.org>, linux-arm-kernel@axis.com,
 linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
 linux-ide@vger.kernel.org, linux-kselftest@vger.kernel.org,
 linux-mips@vger.kernel.org, linux-mmc@vger.kernel.org, linux-mm@kvack.org,
 linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org,
 linux-scsi@vger.kernel.org, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Marco Elver <elver@google.com>, Marek Szyprowski <m.szyprowski@samsung.com>,
 Michal Hocko <mhocko@suse.com>, Mike Rapoport <rppt@kernel.org>,
 Muchun Song <muchun.song@linux.dev>, netdev@vger.kernel.org,
 Oscar Salvador <osalvador@suse.de>, Peter Xu <peterx@redhat.com>,
 Robin Murphy <robin.murphy@arm.com>, Suren Baghdasaryan <surenb@google.com>,
 Tejun Heo <tj@kernel.org>, virtualization@lists.linux.dev,
 Vlastimil Babka <vbabka@suse.cz>, wireguard@lists.zx2c4.com, x86@kernel.org
Subject: Re: [PATCH RFC 12/35] mm: limit folio/compound page sizes in
 problematic kernel configs
Date: Thu, 21 Aug 2025 16:46:34 -0400
X-Mailer: MailMate (2.0r6272)
Message-ID: <FFF22E91-6CA5-4C8F-92DE-89C22DB3EAD7@nvidia.com>
In-Reply-To: <20250821200701.1329277-13-david@redhat.com>
References: <20250821200701.1329277-1-david@redhat.com>
 <20250821200701.1329277-13-david@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: MN2PR07CA0030.namprd07.prod.outlook.com
 (2603:10b6:208:1a0::40) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|CY5PR12MB6576:EE_
X-MS-Office365-Filtering-Correlation-Id: f97d9f8a-d383-4ed4-3ac0-08dde0f3d36a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|7416014|376014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?SkI4MUd1MnFwSm5GZlcxL3UyT1dpaW1UaXNqczgvSENZR1h3a0VYMjB5TGFC?=
 =?utf-8?B?YnNaaFFiRUtnZnlFUjRCZ2hycjd4L21CUVZPUU94VTJHaFpVS2FJd3dyZlRB?=
 =?utf-8?B?ekJUZ0hxWXVIL0hOZytqTlBWK2UxdkIwRXp2N2kxUWQ2RjlTNkoxdkVIazVv?=
 =?utf-8?B?aUtXa1hZTlhyY0M0UllNNzdFQ2pzM1BxTCszRkIrTzcwM3FhZkp6SVV2bElX?=
 =?utf-8?B?SjA3cVRNc1VnYkh2Z1d3NkduZlVZUEFHMnlZaGoxd3lnTCtBKzFMQzM1TSs2?=
 =?utf-8?B?QWVrOW5Zd2dWajdmSG5KNVdUWU4rNVZKZkhzaXAxTzlCWlJoN3ZsMXA4V2pQ?=
 =?utf-8?B?WEVlZlBZY2ZYL1c5ZEticmduamsxTGZEalNWRlRJS1ZFWXlYZmNlejBJNzdR?=
 =?utf-8?B?MEx4c011aU05Vi9BN2dBdFJwZGRidldKRlN6RjJtWk9saC9nMGg0cFRodmhL?=
 =?utf-8?B?Um5mS1VKMVFZRTFnU1dsSWt2UjJ6NkM4NTRzT2R2amo5OXBQRXZVOEpxWTJn?=
 =?utf-8?B?Q0dmdURPYlA3d28yanFvd1AwenEzZUtiOTNRc3lvWVZDMWc0NVE4VG9MUHZJ?=
 =?utf-8?B?WGRUMTlLNVpVa3VPZ0l2cXBRRklYQVlERStoc285Ny85bGpod2JPWEVHNmFO?=
 =?utf-8?B?M01hc1NnZEFNSXZwbGVncWlPOFZlQW55bzdSMXlxSlRua0VqQVhtUllvZHNB?=
 =?utf-8?B?d2RsK0tTbmlIdUMwYzNpZ2RiR3dQcHJJdFFGZlFEZU42ZFFYTUZhR3pkUGx4?=
 =?utf-8?B?dG1ubGtmazJhOXFPdjZFTVpKd0VreWkybE5Mc0FQZmZXL2Vzbk40WTdnQjh6?=
 =?utf-8?B?WHNVSitLMDhqNXV6Y1FhM0QrNmU1MWd0a1ZsWkNsZ3pCUXdTUFVsVysxVVRl?=
 =?utf-8?B?dXVHdUFObUxaMkxOR3NjUnpMdGplUTVCb0dnS1VSak0zbWdpN0V2RXZodGxQ?=
 =?utf-8?B?Yk5XVGk0SkxPenlMeTJaWjRIei9acGVHSVczVk14TlBHQ21MdnNObTVBY3hi?=
 =?utf-8?B?bkphZG9GTWNTN0Y3Y2sxMW13a0pVRjIwOXlHNWhaMFQrUnZjc2JZOGhXNzRa?=
 =?utf-8?B?Yyt3QjVrZDZIbmtYM3NKdmVBSzNxMXl1RTNpcnVTYjJCMVo5Yi9yaTdOMVF6?=
 =?utf-8?B?dTVWOTIrMC91cEpxM0NUejVNa3llK3ZuMnFJbTFQc3Bwa2cwTExKU0hrYkZz?=
 =?utf-8?B?VkM3SVZPek5zYVM3T2hUZm5PMEVKbk85WEg5TGJaN3J0RU4vNXg5SGZjR3o4?=
 =?utf-8?B?QnU0a1ZscmRUNzdab2NXaUc4NHV6N2M5a2x0ZnhBNjZkVkZnWHkydCt4UXhJ?=
 =?utf-8?B?TzBhaUpxenE4S3J3cElMQ2ZyREhWdStxSkdmdWNsRzdZRGlIbXNkcHgwWGg0?=
 =?utf-8?B?K2h5THJHeU5JbjlIeHNuQmxHZG1UNW9MVElNWUJ2LzlHazg1M1V1WEFDeVpw?=
 =?utf-8?B?TWpDOVZtQ2N1M3kySU40Y3Q3MWV2dC8wUWw0QUFJTkRPN3NmZmNBUXo4ekR6?=
 =?utf-8?B?V0ZncGtjQzQ2WGV5RUV5M3N1eWk4cDNubXFGMkoyZWpNY1c2SXJ5QTd4ZXRQ?=
 =?utf-8?B?b2h4TkZSTEZFTkczKzdzT21yZkVzK3pOMDlKV3NITDE1Q2VBQ0tVdWdDcE1i?=
 =?utf-8?B?Ykd6SlBPZVQ2YlZFUWFRS2o1K29yNlhUdnV5NEVGUWpqQUU1Q1ZyUGFMN0Vj?=
 =?utf-8?B?MjA5SFNnVTNVc1prMEw1LzhxS2hZZFpYTm9TamxOdlNCS3pCUnJxRTNmWUp5?=
 =?utf-8?B?SG1Pc1B4cUw5Y3VMN2U3OU02bVhCdUFJVGhzQzlUN3EvdVNYc2phMHFoSDdG?=
 =?utf-8?B?NFRnKzJDRW5ONmdGblRrUmRRa2U5N3lSODJTY0lNWHFLWlFkMWp0aHQ3R2dv?=
 =?utf-8?B?cXdIY2xNQ2JlQVZoc2VNL2ptMy8xT3FXdTkwN1ordXZtNFc0bStDVXBDcGVH?=
 =?utf-8?Q?f4dW6tbCcB8=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?M1U5Nzg5L2lSWjNqemEyeitmR2VINUtlSU85UzVROVJpZTdocVZMYWhaS0JV?=
 =?utf-8?B?blB3M3pXNUowMGZ2WUl0OGloUFF3QXk2RnVHemg5RFJTRzRWYUpwSmdoUGlL?=
 =?utf-8?B?SzFYRCtoVG5seXlpcm02ajN1TnpyenBXUTlNUSt3ZTFqb2FoS1pCUVJNYmVJ?=
 =?utf-8?B?amRERXkrWkRoZzh6V21YbldBUzBqVjFONlZFdGVsTWdGb2hncG1SMk1xUUU0?=
 =?utf-8?B?UWxNVWN3bnhBTFNPZHNXZGM2ZVFoTmJsMi9QU0UrendSaWxYK29mZENCOGlu?=
 =?utf-8?B?aC9nS2Fma2xOSHJLdzRuZ2F0cUNuUGxQK0F3STh6ZG9VVDBtOXZPTkgzdmJF?=
 =?utf-8?B?VWJvM1hYYnJaSVBuVXdtdnJ2UXJXUEcySm9lWG9kSnNmSzdaTnJGTkR4eUcx?=
 =?utf-8?B?OGt3QXdEMTBmcmwrMjJNRnVLdDdnOG9wVjUvWHRyQVFpM0MzN3h4MXJaS1VD?=
 =?utf-8?B?N0N3WTBKK0xuYmhySUpUK2djYzFodmwwNHBWdklScjhMc0s3Z29XQ1BjN3dD?=
 =?utf-8?B?MG0xNnlUOHYvSzFFb2I4SklpRjlKSVZKM2lYK1pPWVcyRHRhOHF1czVCZEVF?=
 =?utf-8?B?R2IyRjNzVVE4bHorbFBhdmRSd1NvOTVJMzZlN1hhSk1XaDBBL3hLai9IMUdQ?=
 =?utf-8?B?MlRhM0NENDBLV2hLQ1ZvY0hoVEhTb3ZBTmorQlVoNUUrQnU0ZWtRMXQ1b2J2?=
 =?utf-8?B?eGpxaFhCOG1KV1pqZnJZNTRsUFRvR2lVdE8yMHBUQjEzZ1ZLSGtsMjdTSkRT?=
 =?utf-8?B?SDI3MER5S1B5eTNvaHZNU3R3VXV0bWVRVEJSUVNFRW5rY2FFaVlpeFZ5ZkZr?=
 =?utf-8?B?d0xXdzJEb2U4cCs3eDF3ODdNVHRFaERsdVdoSnZnd2k0U1E4ZStaWGNpSUZr?=
 =?utf-8?B?K2drT3FCZXNzbks5c25Idks3Ym16dEpqclVCbVRVaXMzWWlFUWVRcm5GbVlt?=
 =?utf-8?B?YmFMR3lBQ3M1WEJLWU42aEpIaEZvb3MrSkdsRFByaDNPejkzQnZQUjNEK2Y5?=
 =?utf-8?B?Mzl5ZE1XUEZPNDM1RlptNC9HU1JQSGFQMU1pUnBUWlA4MDE3UzV6dHVOQUtp?=
 =?utf-8?B?QVpQSUs4b1djVjN2QjYzdjYxVXJJQk01Tnhic3doemFDWFIvSy85THM5eTUx?=
 =?utf-8?B?MU1NUE45aWg1L3lSb01rdDk5TjE3bXJaV2VEQU1XT1hISlJLMnlqaEJUejZJ?=
 =?utf-8?B?cFowbGNoSm40b2dEMkFUQ1REZ21aQ1RSaktSVzhoTEg1aUdUYXgzTk1UcVdq?=
 =?utf-8?B?ZXVWSWxqS0lwYzdwUHJQWGY0Ylk5QkVnZmZqM2hscTJ5ZzlzYWZMOTNvNUcv?=
 =?utf-8?B?Y3I0eCtmV3lUZTVXZm82akxJZGR5ejFkdEdRWVBLSlUwbFFZSTYzK2hQbTF3?=
 =?utf-8?B?TjRjU2dWdVlPRDBFVnR3aEYyQnRtUGlRTldMUXQvVnZhbjZrWVlqdWQ0cVBX?=
 =?utf-8?B?a0hpd1RxRk9SY0ZUaVJJRWZWTGs3RkJzWmtZUmJUMFl6dU9ML1BKczZtRmxD?=
 =?utf-8?B?R0JJVlRMaHFEU0NhZDdhdFVqbGs0WWFsOE1nK0h5WEtneXBPam9Fa3g2NGww?=
 =?utf-8?B?MTBxUGh5elp4UGQwZ0FKdWJvdXFkR3B4eGkvQ1VYUHFacWhZVE55U2llNy9i?=
 =?utf-8?B?bnBadllEa3d2TkNYSDlMSjZRMFhoVVFidjRvUU1PNGhkeW1wVms4Z0xZeWV2?=
 =?utf-8?B?cjJSME45TGFQSXFzdkJYK3k5U05kNGgyWWRkb09lU3F5d2UwRmVYeTZtUzJP?=
 =?utf-8?B?UHJsZTFPSTI2N0xUcVpaQ1RsZEtpQ1puTWpSMldweVdTQVVpY3NjdGljd1R6?=
 =?utf-8?B?ZlhBc05hbE9hU0cwc0Fma3dwdjlIU3RYMFJLMnRqaW1rbGQwKzZhYmdOeTd4?=
 =?utf-8?B?Mkx6elM3b2ZyTm5nOGpYWitubnZGK0crUzZLNEFaVkg2ZEZMWm02QXZJcGxQ?=
 =?utf-8?B?Y05zN0VKL1lpVk5VSnlJVk5vMVpVdHQ4bW04amtxS3JlY3c0cEdueXRPZ1NQ?=
 =?utf-8?B?Wm0zVXpiVUU1eTFiZUxldmNZNitPR242T3g1WDFxNEpkMWRKZ1N0VmM2TVFF?=
 =?utf-8?B?OEtrRzdGOHY5SG56TlJwc25TdXhBWkZRclIxd0JGeDMwZzZYWDZwMkVMdzI5?=
 =?utf-8?Q?iGSEfvKbOqJjhZOwyafJMnQlm?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f97d9f8a-d383-4ed4-3ac0-08dde0f3d36a
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Aug 2025 20:46:38.6244
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RSGSzTIr7NyGNE6H/rambemJg2q/cUNnow64qllaMHUBPoVY1W9d6OWZBuLELSR0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB6576
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: CAD7610000A
X-Stat-Signature: a8mwbaxc357hasu9fu58phty18x3rkui
X-Rspam-User: 
X-HE-Tag: 1755809201-459371
X-HE-Meta: U2FsdGVkX19voCtaObmpqhIn7bNEmOmtmDK25H8HXFlsybRj18wyZ4HlMzrrbJhVAhdgfvYWdTToqfJ3m0ioGdlC4rT0RLJHoygcNi51rhX2uaZ1X9A8wL1S4l7VkNOUxgbgCBJz6RNLp9vLwOso6GqS/bRNqbLL/1l3dhkry0E45nEZcUJrhNGpyETjnFjIg6LOc55z6HxUx3Qj12SajQDc1oc151jLkVd61wW7k7C9Whqqce1g2YW1Z7lhC/X+iqOGb0QjrlFoIkjz2Ryo+09GgmqzqS9JICUaZfWdYJ6EDD//pdr1+2uIu3ZrEzEdBX+U0+CI1JIqaR3ACTuPQItFhQPrri+UD/CRZXcGJF0Hwq/xiAvEMnwC9VSDhqu6uvBQc+6I29PFvjRBKuCr/UYLLAp9cm1T+tRuT80bcNSRAIpJnPQIQRBsBnMfmkk4qNWDzFQmejCkPLEvp5e2BkrkOCuxhUPqbs7stLOFYGHJC2R28ObFg3i3VLIABXXcKD5Z6acngIAiYMWsKceqDnuz812eC1Id84T5PDnX0EeoawuuOnNPHGwT5uH/zdTDbI6V0ZqzPfsMQQTTE3wXo7HR/2239aWcJWlJPwr68MPa5eKoJRN76mZ22Vp/6kjD9+grbrH8Q0dwYMw+ak0bbgUIPv6aUtgL1r0WaqniS8BB7EVZI3QW1O0+OVXgNlZmcJRSX/xbBxm07t0VyqHmdplUTK+NqmUv+Du0VfqaLIISI0x2Qtg4heiCcr8/ObNBwEOHrL1StYCn7fmEf4zQIhIvY02QAc/BVWBeszoV8g3Oq8QqLqRdK+CwHvQFaHG3lyhbCVK6CpkkoEDN9u/90t3jUTDBzW6fogY2myFS8+9SJ446e51a6Zzu87qYK8WYM3kXYapfPavQagU8O40dnAUf3RXyQEEB7ORWwkNxL5IUO+uH7zRmRoP9hS1aARNUUevvPzUKEfvf2UmrCW2
 Lcp0jAuO
 7gX0jcpIg6jsL81bRtgY4+32cDXy1aeyhIYC0a8rGssVTml7jZEOErjDA1I6k1xdBnRq2emrTd0UsjYasWEqI1BosRm+O+UXw/wh1bGjytch6cAIm51y98qA3hMGHaKhlhRqiqkuyOfUjloxysgPhzT90QAc2b+OrXYMLbJ4BifuO4rYQ4jg1FVPvIX787rvTdpwV3MdOtaRSlJogrYpit0NMzGzhgiWTsyF+NuXQ5lAfI4F5+/zCsiP1O9sY1takb9KGIUPRQejo//HbJkGxjHLsEssZCWvy+YLbcend/ztRqkKsmEJjryog6B7piJI932vU35TuHHKUvvjFtcGY/vxumjWc04KH3wQxqpl8jZS3I/4qFHnt0WQvaNrBskYcIPTJ2OwiqKnQ14GWeloBhtQqDfU6fWqddwYZje0ztkBxxGR+bKjd5DBP5nv4zHAme8VRlYPzSi623uxegC6ncv4zrglu3tNpGHXfYbcvn8D0Knyz4Im8M7K54vLjDgojFDVfnFrQIQq77WIYTD9ohljIbHBHfVyBTppCXjxa5FTt7cEfpovAj0Npqx6Cqn0HWDSA
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 21 Aug 2025, at 16:06, David Hildenbrand wrote:

> Let's limit the maximum folio size in problematic kernel config where
> the memmap is allocated per memory section (SPARSEMEM without
> SPARSEMEM_VMEMMAP) to a single memory section.
>
> Currently, only a single architectures supports ARCH_HAS_GIGANTIC_PAGE
> but not SPARSEMEM_VMEMMAP: sh.
>
> Fortunately, the biggest hugetlb size sh supports is 64 MiB
> (HUGETLB_PAGE_SIZE_64MB) and the section size is at least 64 MiB
> (SECTION_SIZE_BITS == 26), so their use case is not degraded.
>
> As folios and memory sections are naturally aligned to their order-2 size
> in memory, consequently a single folio can no longer span multiple memory
> sections on these problematic kernel configs.
>
> nth_page() is no longer required when operating within a single compound
> page / folio.
>
> Signed-off-by: David Hildenbrand <david@redhat.com>
> ---
>  include/linux/mm.h | 22 ++++++++++++++++++----
>  1 file changed, 18 insertions(+), 4 deletions(-)
>
> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index 77737cbf2216a..48a985e17ef4e 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -2053,11 +2053,25 @@ static inline long folio_nr_pages(const struct folio *folio)
>  	return folio_large_nr_pages(folio);
>  }
>
> -/* Only hugetlbfs can allocate folios larger than MAX_ORDER */
> -#ifdef CONFIG_ARCH_HAS_GIGANTIC_PAGE
> -#define MAX_FOLIO_ORDER		PUD_ORDER
> -#else
> +#if !defined(CONFIG_ARCH_HAS_GIGANTIC_PAGE)
> +/*
> + * We don't expect any folios that exceed buddy sizes (and consequently
> + * memory sections).
> + */
>  #define MAX_FOLIO_ORDER		MAX_PAGE_ORDER
> +#elif defined(CONFIG_SPARSEMEM) && !defined(CONFIG_SPARSEMEM_VMEMMAP)
> +/*
> + * Only pages within a single memory section are guaranteed to be
> + * contiguous. By limiting folios to a single memory section, all folio
> + * pages are guaranteed to be contiguous.
> + */
> +#define MAX_FOLIO_ORDER		PFN_SECTION_SHIFT
> +#else
> +/*
> + * There is no real limit on the folio size. We limit them to the maximum we
> + * currently expect.

The comment about hugetlbfs is helpful here, since the other folios are still
limited by buddy allocator’s MAX_ORDER.

> + */
> +#define MAX_FOLIO_ORDER		PUD_ORDER
>  #endif
>
>  #define MAX_FOLIO_NR_PAGES	(1UL << MAX_FOLIO_ORDER)
> -- 
> 2.50.1

Otherwise, Reviewed-by: Zi Yan <ziy@nvidia.com>

Best Regards,
Yan, Zi

