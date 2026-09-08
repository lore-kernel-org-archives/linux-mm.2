Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AD9ADC79F9E
	for <linux-mm@archiver.kernel.org>; Tue,  8 Sep 2026 02:56:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 89BA86B0095; Mon,  7 Sep 2026 22:56:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 824476B0096; Mon,  7 Sep 2026 22:56:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 677416B0098; Mon,  7 Sep 2026 22:56:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 3CC0D6B0095
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 22:56:41 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id BA6131A034F
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 02:56:40 +0000 (UTC)
X-FDA: 85189082160.24.11F62CA
Received: from SN4PR0501CU005.outbound.protection.outlook.com (mail-southcentralusazon11011023.outbound.protection.outlook.com [40.93.194.23])
	by imf31.hostedemail.com (Postfix) with ESMTP id D396E20002
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 02:56:37 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=fnzvRsdG;
	spf=pass (imf31.hostedemail.com: domain of ziy@nvidia.com designates 40.93.194.23 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788836198;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PQevcIRM2dc7I/YIXVU4WFpH3ye55IqcOiT75scB9ik=;
	b=13vXlQvdw2ziq3N7bYwbaGayzFgK9oq0jNqtXQR/t347L93wYSi8qx+v7a0ybWAFmKA6i2
	XT21GARYT23SSojncCEidylb4RmF4uyZKjRucHfBMHrMP8tTwCDFQwEDBhGBNGL/G1KDql
	X6/JUaKx+qluxpaP9l1kETY851EjiCg=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1788836198;
	b=4ZJy46NIK1/OgzJMgGSLapfYoedo5QUntIavvieGMZu0OeQp5DA2MGpbVa8Sdvy734V/6C
	1e7IAyx0meC0WMEWp2Ec+EHneT5w2g89SxwKAxWWTq6JKQM88x1brFX2D4CI0DeQNK1DGy
	QJKi4waf4ir3+kZOEfZ+UpR9qv+ZWOA=
ARC-Authentication-Results: i=2;
	imf31.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=fnzvRsdG;
	spf=pass (imf31.hostedemail.com: domain of ziy@nvidia.com designates 40.93.194.23 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ZwxgY1r94GDAr50yfJU2nRd7tYSZPeM5xSckZkKTO9EzZF/zj8wFiWsu8nTv5tgEIEFYXIAGaI04qCLmdMdXCwAsOjXpLQw5+e9PSMIUOb9vLwRJ2cqpq/cUBLlZB85nalR1aoRA2zuiJHVocTavyeQgcOJI/7hgEPN0QqlLdrRy0O3bjagSEf2MKCxvHQZguHEb5KhDprzUuQ17dyfDxI/QNTYu/za1VsES7838QgyJHZRwoz5HOrLwRMIT/hKmqiuUr3MRU2LXL2gHoCPJExO7tzFUXZrtqGpYd8hulKZz5tW9QZw6SWdzVzawT2Dl+LFpX995MczeILdZqA7u3A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PQevcIRM2dc7I/YIXVU4WFpH3ye55IqcOiT75scB9ik=;
 b=RWf68+U62rzcZtFjE+1u6lMS+pYCF0GHSxmbUKpBzPPEczILzKDU/raPhTQp7QtVvypHr8TVeQC25MB4a1DOQQ2eSRy2KOq60Aw+TwMVHGc4L5rlJPFMRrMigb+8E8IEs6M5KeZbD8lymDWHB1WhYma1sprYv6b+8hp+mDNdU0lWAwkiWZfJ8WR/8QzczZl7ijIqF6EaQaxMlPJ8Q5Cg00HchAL7LyYqo+WnWcOXfXK0yONJL+8piUrhPM/41MR6dKWW2XtkNMkOHb2uNs7PhAwU3ToZS7597h+IjG5w/+nkMJMyhTmfJ1Vor3jzBhyvQ8MJ476hrZpKlFWIdylICw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PQevcIRM2dc7I/YIXVU4WFpH3ye55IqcOiT75scB9ik=;
 b=fnzvRsdGXtw3Z6Jm7J+FrXJjRfuETSt+3MiWuYXRGLeH3FNlPTSvOGidUJ8y2MJhOsB3HdHs8Xz3RPIsKZzHecTlfxCVlrKhfLznAzsdrWD6wXWZsR7IdXfbeuxorGGK9xmWLkc8WwxP52YtJfdXA4t5m3PiibecGTb9McZXmyYj9ugNZunQCFhRORFfjBqezWiF8KzLc4f7NA/jdYMfdIDUho2AQ7LlGYpPA2yZAmFy04/3sh1cPbkNEbDDrp4XDzWBvbzYpz3y8pJsRr0nbJR04368pIVi1pP2QI2Cb54Xu7qL0gIIjLKQpfV5gjyUFJNLOfcb6ZwLQQBMIntFqQ==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by DM6PR12MB4435.namprd12.prod.outlook.com (2603:10b6:5:2a6::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.382.15; Tue, 8 Sep
 2026 02:56:28 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%5]) with mapi id 15.21.0382.014; Tue, 8 Sep 2026
 02:56:28 +0000
From: Zi Yan <ziy@nvidia.com>
Date: Mon, 07 Sep 2026 22:56:09 -0400
Subject: [PATCH v3 02/14] perf/ring_buffer: stop using PG_private as AUX
 page high-order marker
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260907-remove-pg_private-v3-2-6ae22f9d9272@nvidia.com>
References: <20260907-remove-pg_private-v3-0-6ae22f9d9272@nvidia.com>
In-Reply-To: <20260907-remove-pg_private-v3-0-6ae22f9d9272@nvidia.com>
To: David Hildenbrand <david@kernel.org>, 
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 Muchun Song <muchun.song@linux.dev>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
 Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>, 
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
 Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
 Gregory Price <gourry@gourry.net>, 
 Ying Huang <ying.huang@linux.alibaba.com>, 
 Alistair Popple <apopple@nvidia.com>, Johannes Weiner <hannes@cmpxchg.org>, 
 Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
 Kairui Song <kasong@tencent.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 Zi Yan <ziy@nvidia.com>, Peter Zijlstra <peterz@infradead.org>, 
 Ingo Molnar <mingo@redhat.com>, Arnaldo Carvalho de Melo <acme@kernel.org>, 
 Namhyung Kim <namhyung@kernel.org>, Thomas Gleixner <tglx@kernel.org>, 
 Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, 
 x86@kernel.org, Mark Rutland <mark.rutland@arm.com>, 
 Alexander Shishkin <alexander.shishkin@linux.intel.com>, 
 Jiri Olsa <jolsa@kernel.org>, Ian Rogers <irogers@google.com>, 
 Adrian Hunter <adrian.hunter@intel.com>, 
 James Clark <james.clark@linaro.org>, "H. Peter Anvin" <hpa@zytor.com>, 
 linux-perf-users@vger.kernel.org
X-Mailer: b4 0.15.2
X-ClientProxiedBy: MN2PR03CA0027.namprd03.prod.outlook.com
 (2603:10b6:208:23a::32) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|DM6PR12MB4435:EE_
X-MS-Office365-Filtering-Correlation-Id: 5b88c763-ea9d-4434-42da-08df0d54c798
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|366016|23010399003|1800799024|921020|10067099003|56012099006|11063799006|22082099003|18002099003|3023799007;
X-Microsoft-Antispam-Message-Info:
	E4sVKwAs2L/BvlivQlcvHg0unm4URMVwG+gD3Pfrsciy1vDQxT5p8CKA/dNXDZadmGZKraLhQ3NqmB5gKMFjN13u4lxts7f2gb93EaCUzjAzYCXCGX1EoY/4J/Mtaief+S7e8FT6yFjp9Lk8IfZPI0oI3Y95rFPBibOKn4Lnhz6yK1DTwe4fG6m6XCGCvQ30z4pVCd9K/tZMRbwd33t29uMVNW5MDJAcKXn7K6rXBhoel2iq+GzLoO9xxEAa0GLAQ7SUGa2DpMIXLhG5x8XZ4+my4LzxmK5J1BMwvmH3xXAMtNH/kkg5xjCSVTechAjQxgZWg/zAaiCCDCcwRQnKfvkZXGwQjKfmwWLai3Zx29LFamDIl2nzdTenm2IhUdcuJ9L45eJMCWZiY8H3FFXjmzxpKuQXndvG+9epGvmHDta4ZiHPEg56RlYFUQFVj7Lb0BaJQW3bfF6Ijdx4P/BlKBI8DBQuLYGnl4y1csKyz31wbmO8f3qA/5BXMIYjmdVb759tINnEzxSQxVeKvTpkiDsZGvm/6lyeQEQL+Yy2g+EYeCOg/ASPEeijXCy+xgaZtkqHnINSUbnKPCM/+J6DPIF0F7B9fgAcCuocSi80kNL+p24QnW9Z2Slu1UGviNocIbitExbgH2Cj4ChSNMnzrfsPL1dDAqnkAEtJ2kIZS0iYHCzfeWBZIEAf74wozS4H+zNnHveiYu0pDyRvvqW0Lg==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(23010399003)(1800799024)(921020)(10067099003)(56012099006)(11063799006)(22082099003)(18002099003)(3023799007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?SlFQZmM2NWRzajdIVXpUcHJ5WHVOb2xSUE91VktsTDJOakhtaGx0NTVSTDZk?=
 =?utf-8?B?VUlLbk5aemFCejFyR2x5VzhML3FDWFFuTG5GMXZVWllPUUFXOW93RmxEOXRl?=
 =?utf-8?B?S0R2VTIxREtIcHpEdy94YVozSmdjWFg4NHRLWEg5dDhRT1Q3Nkt0d3YwZ201?=
 =?utf-8?B?L3Q4NElpY0lNNHdTUk03VzRVZWRMMWpMZFJiKy9KdjlaMmJtblVYVjI4Z0p3?=
 =?utf-8?B?dmVoQVI3YTR1dUtNd24wUE5JendlY0I1UGdDSVhRdHZncWpBV0s4SFY0KzBD?=
 =?utf-8?B?NnJENm9MRjhmdTlzWFdnU3ZjOU9Qc1ZoblgzUllISmhUUGhlNUNhRVhaQlY0?=
 =?utf-8?B?c2M2Y1dKUGNLb0FBUkJSQ2F3YWdZYXc4OHZpNkJWbTBEVGp4cUxlWi9nTVJh?=
 =?utf-8?B?YUovRkxiT1RuN01MUWRmVXhrMWZsTnVIMkNFVk9tNjNrK05vT0g5VU1VaU1Y?=
 =?utf-8?B?RGNoOHJ1QXdsb0I4S3Y2QkgxSWZaYmVINHd1SVVQbHloTkF6dURjZFRjdkhR?=
 =?utf-8?B?dURQM2ZlbG11ekc2U29jR01PaFUzMzBJNHU5NHRzdHg5dmpiWjhDMWhQTEo1?=
 =?utf-8?B?VXovM3pmMDRBTXkrVlNoaVpPaHNLOTdxTFlCV0M0TVNkUEpwbS8vVXBpK1dw?=
 =?utf-8?B?YUk4U2VOeFYzT3NudXlMblRsa0ZxVlJDRm1PNHF5bDRXWXl0OUFJczl6Q3R0?=
 =?utf-8?B?VVlLMUhvY2Z2dWd0My8zSjZTSm9RRFMzUWVIbkoycmZmVzcvcHZ4REtQRDYy?=
 =?utf-8?B?aXVqa1liVjZSbGRPczVCK2RIVG93RWdWY2ZYQUpLZ1FPRkRpM01FVUNXMkFL?=
 =?utf-8?B?eHROODNYZk4xOUhNSUFRcURab2FHbHJLMzIzdzNHK3VuTnljSGllSjgyZXNY?=
 =?utf-8?B?WTA4VVI5MHdpSDhDMDlyTXR0ai9UY2QyTGJ3UjdZbCtHQ2pQaFJVSkhvOWR4?=
 =?utf-8?B?TVMvMGVtUlIvRVFaNktSbXBRR0xzWXZZaVBKdU5yMDZhV2MxQnA5ekVlRTVP?=
 =?utf-8?B?L3E5Zk9rMkxYSGVZZXZaVWxuZnhPU3BiWDYrQnV1WXp5aUhZSmkyZXJHZEZG?=
 =?utf-8?B?Tm45UDh3dm1TODZDck1hRExMMG1VL0wzeWdlMVVkRG1iTDA1NVN5YWY4bFBl?=
 =?utf-8?B?Snh2aHp5amNBNHZyTU4xOEJYLzVIaG5vTHc1QWQvSjRYYjJWMkVMWm5HV2d4?=
 =?utf-8?B?elVLczYxY0ZaRndPd0lNVGo5eEZyVStxMmRjbDF3cWl3enFLTGo1UklKM2I4?=
 =?utf-8?B?U0NCSTMrTTNleVcwd0pHMEQ5dU9xTEdxUXhuV2IyaEZIZll4cjIxVkFoU3B1?=
 =?utf-8?B?VkRQb0tJTGI0N0VaY2xYdTh1aHoxa1dXZThyOHZ1SzlPN1ZPd2p3Ulo2UHJS?=
 =?utf-8?B?dk9zbXltbmp5Lzhiam5uOVFWVHV6dVRFM1ROVmFiUDlRVnRtc1ZsTldxMnRR?=
 =?utf-8?B?YXFzMi9pQW1lNXo0UG9KUVpKV29MbEp2NGxvTDNUbEJ4SW8xVEpSYjYrajFY?=
 =?utf-8?B?WXNDb2RHT1YwRzAwclA1bENmdms4NnJWVVo4Sm9zN0tlT0VtSWcwVHVucUFr?=
 =?utf-8?B?WlN3emNTOUNoc0pTWmR3OVZVY2hLcEIzNWkvRWduYWxSOFNpSXIzc2E3Rlpl?=
 =?utf-8?B?SjdLKzBIam5uTlJKUU9IbVJ5TGVNMllDdDZzR04zek1OZlNPa0x0N0RaeU5j?=
 =?utf-8?B?M2tzRjZWa281Rm5rY3FUSFZ3dWp3WlYrUFJEcUlhV2VrVHduMGdlWm8wenB1?=
 =?utf-8?B?L1JRV25kRTRYQ1lYaWxkeDVFNGM4SENodVV2SE14RWQ5a0taK1lOblZpbEpW?=
 =?utf-8?B?M0xaVmRCRFViZ2VrRHE2eHRkMGIxU3hjMUQvNHh6MFVuZXU3Z0dITTR2dmQ5?=
 =?utf-8?B?dmZmOWVyZmlXT2NWUTIwWnhUcHYrQjBrM29POC9NcGovM2plekxTZGw1WkEx?=
 =?utf-8?B?Z3lYTEFjaDBVeTVXMTlSRlMzM294aVhRSlpHQmhuTGpCdFc4dVp6VXgzMENR?=
 =?utf-8?B?QUhYSmJpTGF3dXV1TGtPZ2lnMno1cVVHNk50bzh1YmtveHZCOU96VlIyMDhN?=
 =?utf-8?B?b0hzNXY0bUZHeDhZQUpyYVlraW5QTTlvb3R4Q2pzMnEzTDB6N2xQK244eEZz?=
 =?utf-8?B?bm83d3RqS29YWU1wK0JjY1NsRHhMNzVzN2tUSlVnYlVtckcyaTJPenEyTExZ?=
 =?utf-8?B?TTB5L3Z5TFVqd1ZXNVAvTXg0dVRwRklwdGk5OU5SMmozRDU2clZJdDgwVDBi?=
 =?utf-8?B?ZXRkMXJOUXovclFGM0JERzZGc3g1dmpLaVBSM0tJWEVvVXN6aGVBVGM2ZmZH?=
 =?utf-8?Q?p9Aa0DDlfuhLdBAjVx?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5b88c763-ea9d-4434-42da-08df0d54c798
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Sep 2026 02:56:28.7850
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VnT1nC6lfYWyLShhQUD/hAEvxo78duc93+N8eS5FStQ3fQJwIKo5GIOtfqhTpDXW
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4435
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: D396E20002
X-Stat-Signature: i58fopsy3aob1zzuuw79gpu8xiuugbu7
X-HE-Tag: 1788836197-582142
X-HE-Meta: U2FsdGVkX1/S4fLLhaIRzA7HcGIHodWJuYy8uz/xrxX6amg0qmwEWLMFr8VQN8tSMBCETEWdafl05C8Zqr7cvqFJFlGfP5mWyWfbxOkdWNRURRQDjhar7LjCCDdK4CS/Z1T5Q912AqawE7cTfsbv5lBeiDzvKIJis3tSvsMpwqg0eLUhwp5lDFJasaColnMiId3YnPaN6QDUwblS5FduPDabMMJG1Xm8tTBFkOezTM/guT9yTZqMMdfN7cTZO8PZ/gDlWGnQ4Tz4lQ3nNlnEmszgc7NvWrdayxOicU4KjdzeM48ZuoSYEgbu5XVvvYPB2OAHp+TM42lRIpJflvnOafnGIrUMkfZONmS1rCZDymIs939ZYX6megT9GRkuZd2OnbKXNtLxIMK/J7q67brc+73sFXmVjfDd5PA8Z4Ewh4rl3KBqc3FdNWoJj4FEFS10+N7k75x2eHSjHgwKcdWdmFUpXhjxHO1qIUXZDLccz24c15Z5+VHDww/UJgLLctHDEMnsujrdu5hFfDE023VqyV9Zi019qSbHswlY5ncywgv8rYTs12XdCVJOcWKlzCVICZYjlXQXmccfXY+i27be6UQ67r6h+mmFqDKiMmTsJZ7Vtku6J3CeFZos+FWChxtrNan3bpwcZt/8wTN/BRnaV2NnpCavqmJz3abbGTxxcPQLyyYCSDAVcExJZiGS/5bRHEQ9c6UultMAnEacphzxZNYkEyW9GxMuU5cFRg9jL2F3f9hWIlQFMBTCyoGflzIvyJKQUhjWExsgwIiAj6I8nZG3wtN5W5xbvhOoDfH+AaQL5AECDFPC6ie8FOQflGPbH8afjo9FnL3/eKEGGhN7cm6ZZFsEwPffTwJ5tSAuOmdvZrFgnXOaLVppZi6yQI9rUgjp9ax8Z1yvL+xE+MgUOtGojuJ5iRQEugkB8cHvxvTqYpt3GLAASsg9UnRUpITN1oB/vtNikxo3uzdMwXc
 1+ILC2o+
 KVTLUAeDBL86r+Fo9xF+3fChdn09SGceslCM1CH89xEiB8r2vVkpcDbYOgxlMXJnd4O9tc7qxa9TjkzsLzK5i9ryfhS78pW5Y2orwkqT0Ek5uk6F54PWZkWfxLMfoH64r+F8kQr6EAS3noDh95hTi3OgKWUxCNTPkmB5lftxRqAFbQRQmwCtyL48GozYDQNya7RjXk/0vBOcPJvrJNwGYuo9QndhazzBgvfF8OBVne3jZtyQmfsuEPsmmz2KTPKH2P892AI/2IDavr922LBotxvBRbeFwzR3v8XMH8XqabpaADGgyXKRhP6aRePwCsqPtecXiokll69cWJWylkDLDezHlwYOrqMiy0wbaQs9NAqwnaJP78Jtj0LNmkvscy4EQC6BM3p2X2TshHAX05zI/Ea1WTsN3wQX2msmQIe6j4XjZxItUh70Of3IfffLNKSVxh+HZ/7exXn9QBIWn/EMUDQ+mxttWUzSgaH2bo5Rrkr1WxWMOoy7JEEFiSYd9FbRxnk2zzKWmIZvDnTHQAvq3mNa0zO5E5gb5ePEDFMPEHzPJCC3oLT3pkVHRBSStghW0FcWC1LoTGl9weX41wWULJ+7dzQYiBA/7haUty+s27BsAGw3Sau3IipWqqkNvQA7CP4eR1n3agZ3KpdS9dtpamJ6TA0RMU22YAdTkk73Xdw5h3DQtEdPOVkAzJWXPCsdeh9vUk/AGr1kMNEjZgADEMkVIZBqbhv5zIK0XFJ0UsKFohkXq3PAolSSA5tCxpTFa1zissh2k5+ZRKjo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

A high-order AUX page sets PG_private on its first page and stores the
order in first_page->private. Stop using PG_private and check
first_page->private for AUX page order only in the ring buffer and its
users. This is fine because page->private is 0 for order-0 AUX pages,
matching the page order.

It prepares for a future commit that remove PG_private.

No functional change intended.

Assisted-by: Claude:claude-opus-4-8
Assisted-by: Codex:gpt-5
To: Peter Zijlstra <peterz@infradead.org>
To: Ingo Molnar <mingo@redhat.com>
To: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Namhyung Kim <namhyung@kernel.org>
To: Thomas Gleixner <tglx@kernel.org>
To: Borislav Petkov <bp@alien8.de>
To: Dave Hansen <dave.hansen@linux.intel.com>
To: x86@kernel.org
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Ian Rogers <irogers@google.com>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: James Clark <james.clark@linaro.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-perf-users@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Acked-by: Usama Arif <usama.arif@linux.dev>
Signed-off-by: Zi Yan <ziy@nvidia.com>
---
 arch/x86/events/intel/bts.c | 3 ---
 arch/x86/events/intel/pt.c  | 6 ++----
 kernel/events/ring_buffer.c | 7 +++----
 3 files changed, 5 insertions(+), 11 deletions(-)

diff --git a/arch/x86/events/intel/bts.c b/arch/x86/events/intel/bts.c
index cbac54cb3a9ec..5849392cf26d5 100644
--- a/arch/x86/events/intel/bts.c
+++ b/arch/x86/events/intel/bts.c
@@ -66,9 +66,6 @@ static struct pmu bts_pmu;
 
 static int buf_nr_pages(struct page *page)
 {
-	if (!PagePrivate(page))
-		return 1;
-
 	return 1 << page_private(page);
 }
 
diff --git a/arch/x86/events/intel/pt.c b/arch/x86/events/intel/pt.c
index 5754cd4055628..49349afee6119 100644
--- a/arch/x86/events/intel/pt.c
+++ b/arch/x86/events/intel/pt.c
@@ -781,8 +781,7 @@ static int topa_insert_pages(struct pt_buffer *buf, int cpu, gfp_t gfp)
 	struct page *p;
 
 	p = virt_to_page(buf->data_pages[buf->nr_pages]);
-	if (PagePrivate(p))
-		order = page_private(p);
+	order = page_private(p);
 
 	if (topa_table_full(topa)) {
 		topa = topa_alloc(cpu, gfp);
@@ -1296,8 +1295,7 @@ static int pt_buffer_try_single(struct pt_buffer *buf, int nr_pages)
 	if (!intel_pt_validate_hw_cap(PT_CAP_single_range_output))
 		goto out;
 
-	if (PagePrivate(p))
-		order = page_private(p);
+	order = page_private(p);
 
 	if (1 << order != nr_pages)
 		goto out;
diff --git a/kernel/events/ring_buffer.c b/kernel/events/ring_buffer.c
index 9fe92161715e0..061b5cb222266 100644
--- a/kernel/events/ring_buffer.c
+++ b/kernel/events/ring_buffer.c
@@ -630,11 +630,10 @@ static struct page *rb_alloc_aux_page(int node, int order)
 		/*
 		 * Communicate the allocation size to the driver:
 		 * if we managed to secure a high-order allocation,
-		 * set its first page's private to this order;
-		 * !PagePrivate(page) means it's just a normal page.
+		 * set its first page's private to this order, otherwise page's
+		 * private remains zero.
 		 */
 		split_page(page, order);
-		SetPagePrivate(page);
 		set_page_private(page, order);
 	}
 
@@ -645,7 +644,7 @@ static void rb_free_aux_page(struct perf_buffer *rb, int idx)
 {
 	struct page *page = virt_to_page(rb->aux_pages[idx]);
 
-	ClearPagePrivate(page);
+	set_page_private(page, 0);
 	__free_page(page);
 }
 

-- 
2.53.0


