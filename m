Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 55BA3C5DF81
	for <linux-mm@archiver.kernel.org>; Wed, 19 Aug 2026 17:49:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EBE5B6B008C; Wed, 19 Aug 2026 13:49:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E6F5B6B0092; Wed, 19 Aug 2026 13:49:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D37286B0095; Wed, 19 Aug 2026 13:49:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A0EE66B008C
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 13:49:22 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 1F2E21405D7
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 17:49:22 +0000 (UTC)
X-FDA: 85118755764.21.EF3B836
Received: from MW6PR02CU001.outbound.protection.outlook.com (mail-westus2azon11012047.outbound.protection.outlook.com [52.101.48.47])
	by imf19.hostedemail.com (Postfix) with ESMTP id D31F61A000E
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 17:49:18 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=is1NGV4c;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf19.hostedemail.com: domain of shivankg@amd.com designates 52.101.48.47 as permitted sender) smtp.mailfrom=shivankg@amd.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787161759;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=K2H4S40jcNgex2kAnse5il4fhrCGLXq30/iJHro9/JU=;
	b=qNlmtDPEQkGyDaT0L2b5GpyWSR7HFVxLiSr7OdP/IV+oA+tqV184xjGMc9UddAwaenxP9r
	J0DjnOkH/INGAa3XbILbdWi0cm5psXFObZr/H/CzrjLZ07zX/Pc0PNLeRVmYv1rbDoF5Uh
	OU1SMNu3/6wjgxMBVW21zQlkgYZkD5Q=
ARC-Authentication-Results: i=2;
	imf19.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=is1NGV4c;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf19.hostedemail.com: domain of shivankg@amd.com designates 52.101.48.47 as permitted sender) smtp.mailfrom=shivankg@amd.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1787161759;
	b=N1MHlKQxAW5/4ZdedK6OtyyPmEpS8i1fJlm6yghqncVcOKSFlehT3NbtKfFXzI9kDhTeWU
	yaDREuUrIKIyfWMySNoZ+yD2EOkrX7VGh5oOgybZ0chhGJY6Z25Wnx/KXu2oHbUgel5zPa
	HegPuhI94oZ1K8qTEmFWjEAqmRh3B5Y=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Pd53THzS5d+b3RROtXYjNa43h57NifQ+vq/LRps+usGeY9u6YYYiX7eAjgtQeHGjGvMBYCQgveOwfsdnqm0y9noBGdhELP0VvQdJpzCRmJ/zslI0cw7iGkhi4tIKijqx0ULWo+GXc8VL2Zw/+57NNl8OW3VsEmuQuVXmmhSyeCMt4feDIjgjB8faYSThEm8RQso3O3CbrIAethpUtr3e0eP8tIkC+e8A+8oogyAoL38bilb9M0fVnAWs1f4IPC640Q2SuJlmj/79WsY0e3gBjoXbwTX0TvJRI/DZgXA09t/7gInT9ytu1oQUUD2rit9nIL5dnlvZrKPDY059WncCJA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=K2H4S40jcNgex2kAnse5il4fhrCGLXq30/iJHro9/JU=;
 b=KJ+AJ53BclBwg/8muLxwZ9K6nDRCK4IdoDheqHe6B9GPILDIdo2Y3w8tyTfvuf9iXQaVqBecLdLcT8IQLnHZ8SeO2y7uZ9sNr/4Iq+ZYBVcg4Skj1dx4D6RUSYhaq7Fp+64DtwsAhZ7tN0S6J6dA+NOqbRxU+Qko3Mc8nExRi2FslWCUfjtJ9GvDeDUwI2KwpwU6aqzj6kDpB+YRz06gFoESwLjgcLzfcZDsKkhnzYYTAe+cEW3DGWplQ9yCNb28jZ9k6LOUdB3hRzjTCs7KeXiFcKCL1yTsdyCYapH8TmdM+QQsvqX2C1ia1HoqMvr1kmYCERiKjZgSZF6ogGnxUQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=K2H4S40jcNgex2kAnse5il4fhrCGLXq30/iJHro9/JU=;
 b=is1NGV4cGNf8WEH8+wOWxYA6OPhinMYA2CUGPs+UVqEGoChl6uIUpsheGVH4UYdR5clfz/1J9gJdWSF0g6P62qfFd2k4lWSwfgCsfe8D3n8FrUqXzht/bQpYYC12RCaOwGc2jC3T+vC0MRp2iq0Xjd60aAGbn36BWP7AXUasbKs=
Received: from BN9PR12MB5259.namprd12.prod.outlook.com (2603:10b6:408:100::17)
 by MN2PR12MB4318.namprd12.prod.outlook.com (2603:10b6:208:1d8::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.339.8; Wed, 19 Aug
 2026 17:49:14 +0000
Received: from BN9PR12MB5259.namprd12.prod.outlook.com
 ([fe80::122c:cca7:c2b3:90ed]) by BN9PR12MB5259.namprd12.prod.outlook.com
 ([fe80::122c:cca7:c2b3:90ed%2]) with mapi id 15.21.0339.007; Wed, 19 Aug 2026
 17:49:14 +0000
From: "Garg, Shivank" <shivankg@amd.com>
To: "kmanaouil.dev@gmail.com" <kmanaouil.dev@gmail.com>
CC: "Rao, Bharata Bhasker" <bharata@amd.com>, "rppt@kernel.org"
	<rppt@kernel.org>, "weixugc@google.com" <weixugc@google.com>,
	"byungchul@sk.com" <byungchul@sk.com>, "rakie.kim@sk.com" <rakie.kim@sk.com>,
	"vbabka@kernel.org" <vbabka@kernel.org>, "harry@kernel.org"
	<harry@kernel.org>, "ying.huang@linux.alibaba.com"
	<ying.huang@linux.alibaba.com>, "riel@surriel.com" <riel@surriel.com>,
	"david@kernel.org" <david@kernel.org>, "akpm@linux-foundation.org"
	<akpm@linux-foundation.org>, "matthew.brost@intel.com"
	<matthew.brost@intel.com>, "surenb@google.com" <surenb@google.com>,
	"rientjes@google.com" <rientjes@google.com>, "kinseyho@google.com"
	<kinseyho@google.com>, "dev.jain@arm.com" <dev.jain@arm.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"gourry@gourry.net" <gourry@gourry.net>, "ziy@nvidia.com" <ziy@nvidia.com>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>, "jannh@google.com"
	<jannh@google.com>, "liam@infradead.org" <liam@infradead.org>,
	"mhocko@suse.com" <mhocko@suse.com>, "ljs@kernel.org" <ljs@kernel.org>,
	"lance.yang@linux.dev" <lance.yang@linux.dev>, "joshua.hahnjy@gmail.com"
	<joshua.hahnjy@gmail.com>, "apopple@nvidia.com" <apopple@nvidia.com>,
	"fvdl@google.com" <fvdl@google.com>
Subject: Re: [PATCH v2 3/7] mm/migrate: split remove_migration_pte_hugetlb()
 out of remove_migration_pte()
Thread-Topic: [PATCH v2 3/7] mm/migrate: split remove_migration_pte_hugetlb()
 out of remove_migration_pte()
Thread-Index: AQHdKtuoB97plyzY70C1Ezquc9VyR7alRNWAgABriIA=
Date: Wed, 19 Aug 2026 17:49:13 +0000
Message-ID: <835e8dc70bf2080ef261c3bb52e13a08481fc638.camel@amd.com>
References: <20260813-migrate-rmap-batch-v2-0-3c5424c555c7@amd.com>
	 <20260813-migrate-rmap-batch-v2-3-3c5424c555c7@amd.com>
	 <20260819112419.n4fkhvbxxfhsyhun@wrangler>
In-Reply-To: <20260819112419.n4fkhvbxxfhsyhun@wrangler>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR12MB5259:EE_|MN2PR12MB4318:EE_
x-ms-office365-filtering-correlation-id: 95f7ef51-df83-403a-b190-08defe1a2eb2
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|366016|1800799024|376014|7416014|23010399003|38070700021|5023799004|10067099003|11063799006|4143699003|56012099006|22082099003|18002099003;
x-microsoft-antispam-message-info:
 9cs4o1b/AueMbi0XlMKCz34cJ8dqi+sInOOPQJNUyyJxp1ZjDEuOePRyZKxmtGXP/wdYhJOAY6YUWbovh48rKOOow22AUixQdBvvWXnnHgOItzy+nFzD/qihoulgEjiX9rC16bVSt5AJOqnEgoehesrCYxg5016lxhZ9/g6eE1b92TEbaL/PdqIp0H5fOIwW7DuOJ3UhSmI0ZyIw+SMVLPibKcPgKwZ5kkjWtWUJ7ODggjqWDYh8FZ+NXB4Qq/HTij03loKwIB3K20TsuuM7+UaALi8xzzgCLkKY04+kw/2XYKRUAVFyF/XkYcWlZa5Ka/bEhTSL6cthQLUXeP3kY54V/k8vyq5Na/mtNy57ga0BiFgB6pSAg3OrDBaLdO75wV3y4X5Qa4Lq8uMCX9BdxtOgMbbZ+btC/2AuuRPAB3Bwjo/3dbp9esDoQDx/f1OdHHjIY4uposKuAuFIBWhNg8L+cUVYks6NiLdZvjc5X3Hd+xyV738u1DKrnlLwhgSHrFvafdyz99rHeI2SZlMVa25ed3slwXdtg1nkvMCpo5o2PElT4h9GgGumzdIEp/vmuIcXonZ+DtM7rLwn6MUqa4OGIgFd+ffSyOq7XrAydml4FBFRWqE7cDJE8kKxIKq3Gynq020q15PIYsdiPN40Sx+zpP29kDugZeaPkeYPeQC/+oJUpTbHYQ3Z07fNJfeJdLHZI5VRQjTr7rhWzM3lzw==
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR12MB5259.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014)(23010399003)(38070700021)(5023799004)(10067099003)(11063799006)(4143699003)(56012099006)(22082099003)(18002099003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?S1BHdE4xbi9jcG03dGY0OW9TVVlhZXpRR3AzSytjV1U5dUJBWlNIQUVOYnZY?=
 =?utf-8?B?TWh2bkZEa3JpbEhrODR1R3pveFRTb0F1cW5GcVhNMG9NWjNZMDlYVXZnZzdq?=
 =?utf-8?B?Nm9XaWZMVyszYnFsSDNzd1I5T3dMS3ZrRUhxaG5NNWxtbG5xQUZwNytuOTNG?=
 =?utf-8?B?eTduWC8xQ05BMWdUMUtBZlhmdVN3anpSVWNTWDhPc2lJWFVsbUI0WnM5L1BR?=
 =?utf-8?B?dllYUFJ0Nm8wRmFDSnZKaC9EK25RWnZaMDVCcnA2TlJnRlNxUjlBR244aEJ0?=
 =?utf-8?B?SGdVSVdGZjVacmJ1K3c4SDBBbGNUUmxleGFDZjVSRUxISE0zd1RXWmZMbmxW?=
 =?utf-8?B?aXFlV3MxZXY0MnhhSXhyRFFiN0MyNW45Z3ZsMHF0U1d5dTZ1N04vbzFMT2hh?=
 =?utf-8?B?eGxpME9FTDZnSEd1YVplS3dJSmtIYzNJVm5JdUh1eVRqRkU4VzJhbFU1TGRO?=
 =?utf-8?B?ZkNqZENabGw4Q0lTY0hVeVhaZkE5RDdycDBPbHhhWTRnRWh1VHQyR3ZraFZs?=
 =?utf-8?B?b1BWaHFNTGZ5QkJhcm9DLzROSGNYM2k1ckxKb25zR1BJS285bFJaTUdDeW04?=
 =?utf-8?B?b01RRFJjZzRQamtwaFVUT1VnbzJ5TUgwSnFXcE5zcmNHQk4yYUl6YWN4aStk?=
 =?utf-8?B?SXU4a1RPc2tmTU5QTTdJQUZXOWwxcTM4SUIvSmI0dituQzN3WlV0ZG9ZZWxn?=
 =?utf-8?B?RXFMaVB5Q2JKRDNCS1IrdE1QbDEraE84T1hOUHJiZGtZRC9BZ0FNMmFQbkZB?=
 =?utf-8?B?eFpWclRNUHNTdlJlTGZqdnkrbjVhb2I2M1BiSGloNm5SRDRqaFBtdHowbzBQ?=
 =?utf-8?B?VkZNd1ViaDNobUJCQ1h1ZGtwZm4yRTAvd3p0MkgvclA1Z292c2dWbm9qNFlM?=
 =?utf-8?B?Z001M3FpdmVYZGVHa1NacStZVEY4WjdBK014VEQ3SlltOTVLMXJjZmcwVEp6?=
 =?utf-8?B?czNrNUpMNVJtQTJIcDhGOHVkWmxMVGJEZnhNK1Y2MWlOcDFlM0NwRUQ0Ynpo?=
 =?utf-8?B?Y0VQMk1QbjI5YTdPa3BPZzdPVGppL1g3cWNqd20xdmJRU0tyY3Bkdml5akpt?=
 =?utf-8?B?OGhRSWRsK0NUYzI1dXF4N0JDOWJIZWhPV3VDZUdGeG1nb2czMGx5VzdtTzBE?=
 =?utf-8?B?Y3kzTWtmbklHb3diM2VwcFdSQlQ2M0FsVDhWT20xUXhSKzlpL2dETTE2K3o1?=
 =?utf-8?B?aHg4Vzl0SVduYWZDSFdGSWNuaUdQRnB6NnN5bkVjeE80Ym5jaW9rVVYrSnBq?=
 =?utf-8?B?VXhSMndacHlhZkJIbDNUNW9ybWIvOGRlOEJGMzZvZFdmQm93cDNDSzkwM01r?=
 =?utf-8?B?K3dmSnRGeWJDbC9YVTBVUFBUbWFUcjJsaW1EYXFMcm9UWUtmN09Cc2ZZY0dU?=
 =?utf-8?B?SjNjMjBZaklKZ0RFVFF2R2RrTUkzN2tVRCtvQ2hNN2g2RVRIR1h0MWROa0E1?=
 =?utf-8?B?UUxyejZabTdDaU9RcXZmbG1qeC9RanBmOXk4RVpFdTBRQzlHY1NMUEx6cjlW?=
 =?utf-8?B?eldCUVlIVmRDQ0l6UmNuVGJ6VEpsaWo1am4rNklLTEljbFhuYkVtODUvVTRz?=
 =?utf-8?B?ODVtT1ZKa1RVaXorRDBPVEhFMG1rT1ZKbU9JRGFLVm9IU1lMZXREMWtXNkNj?=
 =?utf-8?B?OFJUM2hlZVNFdWZwbHowVFNKd09uM0QwQmxJWEd4TmhtUHRWamdZQTJBL0I0?=
 =?utf-8?B?N2t4ZEw2b0N6eEQzWng0U3ZqeXNyckxVTmpvRjNBRTkyVFBWQ2p0c00veWpQ?=
 =?utf-8?B?aDV1elNBQmNuazVkcEoyTkpWT3NCUkNXbWxtMjdEYnBROWsvV1Ezc1M5Nm02?=
 =?utf-8?B?dHl4R2Q1Wk9tU0pXdEJiWE51SENpUS9sK0VIK2NrNERHV2psR3p2S3p0RmxX?=
 =?utf-8?B?MjdCZGwzZ045OUkzUmQ1L0VocUNPUkk1a1dSa1NkcGt2OSsrWEN2cWNSYU1K?=
 =?utf-8?B?ditwU1N6KzZoQ1dEbEhwNm1HTy8zYWtVWituSlIrWjJNbUlreXZuY3BZOUk3?=
 =?utf-8?B?WCtJMncxRExTelpTNS9jazA2QzVjTllNQjk4bnpHdXJ4dWQ4OEt2MC9XNTZt?=
 =?utf-8?B?aThBVlhvNFRhRStUdmpMUzl4b2pid2tLSWc2OFJSNDNucldQcGdxUXkrM0RN?=
 =?utf-8?B?bVJaRWtwRXBKVmhHd1BVRFRwM0gwZ1pJREp5SDhJVHdYV1dVMHQrWVVZYmd0?=
 =?utf-8?B?ZU5WMGVrMVE5R2pLQzgrd0VsYm52WVR6WVE3S3NXZjBlWHMyZUxPRUxaZHQ0?=
 =?utf-8?B?bVNCSGxwaWtlaGlJR1lFK2pINWJScGQ5SVdmSUJ2QU9DeXZueTVENzFaRGdG?=
 =?utf-8?B?WnFHZWJVaERCclN2bzZuQUdmQ0piSVBlZU9kUUxxWThTYlhMNWNhdz09?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <B1CCFA1C58387B47AA2EC443672A0D54@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR12MB5259.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 95f7ef51-df83-403a-b190-08defe1a2eb2
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Aug 2026 17:49:13.8911
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: jjhVvRuqSFj4b9ZPtnB07ub9Y8nxX00dyP6kO2qGedh9/u1f9X5oLQFFRvxukfWh8UmMJLU5iCYcrqQSX3B4Aw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4318
X-Rspamd-Queue-Id: D31F61A000E
X-Stat-Signature: phhdresrrik3xr1d7am69q785aopkhkc
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1787161758-94316
X-HE-Meta: U2FsdGVkX19m4ojbQ8McJ+oiJDFEECOa8JKJk0HHrXeRNn+K1WjJJObwr7V7S4pxRqSAVfjEFnGIZoxJR3FhsMXCBi/woRBmXGfWyjCp6syj8mYd7/yO1lcbKeoTAnlUUVGPfaX9aFgKTe1xajBsUTZDYiijLG/tzCPSYwyZVgN6YFi/wfS80ZHbI4fOCLgwhSwXUKZyCZb6mVOVu0ztq4yR8+xvkffVbWTyxoBgtj3kRtjLQW9uElqGkuFjwpuW4Sp2VhJMOls0JrqzbmsYuZt6fBzKIuWe/7HVQ78azdvERdZYDOZ20SEHn+Y6cPh7N5zVzmUWb9QGOMP/mLC8GD8G88yT57oQVmnsh0j2CjGr9nCONpU5NIAw0vgLI5GU6bq5w8h6rUAq/E2vRIFBq5ZnBo6Dhd7GUHD6WuD5zim0KMxyOwQy5mtRE8bPMk7xFop5RGaGnl+ZfKg76LDQWN6pb47GwAjvWArKS2GpYscCuNePMDv2Ee24qjtpuFtq2QfivSfLZRRvCMOAmNHIuFpgQ1aQHK9P31sqyv496FKpROSU/lC0YB6ffF7Tg3VlVI+n9GT14MkJQ81s2iqZi4g7psQ0vtvtV/LB1BiWE/mWQ7t2nMcaTFVXqGKGuHWgtw6+U5OypvgfxNerQShfERdMc+leiqy/Mz+uBs8UfGY4uSRPc8W6j0FS7ulAuj5RRz452vs/m28nSCxG+NSBl9Iuk7Nht2f1CHO4GGlYMCsyEH/3QQeoNMxy3foQTvQbHfZtJi7JenWUhiITQAEHh41ZAyz20+Y10Vbr8AkZpgCP9QZfh9eWQI7bOYYJ2uC3N8wYK9dqff5NoaOR5Iu0F2aHIuxf0KNxTbN7Pk8sFNswzj7/RIfUVsAFNGhD8McqAMO1Vrzn61r97j3KFIsevszaeobSPNf0DMfdVEzcGusMMw9pnRrVV0+Eq5iJT6JZQQ1TacTQF9JiqUENPtn
 FtmxF0js
 DNzkADwNzV7dINAd2F4A994n5lpx7Gg16Y+PYNTP1xQNVGfhn7jtcGJvf4Y4CbbI7OT9bvKudqWtuHAQT1toTfYSCZBEjeTOmIKx90BIeYWJJHu1T0d4rxxvOjRnSA4xHnVMulTldqTW1N4pmx5io3g/MayLpVMYbbyflUCmq7hzsHN1bgCs01YDr+wlGJu50I/JiW7p7fiMOklFwWrAja3QV86i5MtugIG/Sb1FFqfjGnpryZ7OpR9OJSQpp/OvSuCeccT2ueIMFaKa5tzylcViDB3DCbQ9rpuhDSgTGsrUGegaz6tXpLyKm3oxASLhQwERwUhfplZJZiE2Qzp8+/HbVvpJEnqyY/UXzqGHMhUWVke7Qmu3x2fbMloN0Ug75Z00pj74bIwJieSkKflOlIPP9Tp/I3SbrxD6CLIR5IKx9s6DAqsDf/gaXqIyQBdAMQ5rD/XWazfMIS+A9e0dC/fn+aThWcnUVB1JQ4z4T6RpzjkPnKEuIlKe8RoZAMh9gVh3F0cwO0SASKK6KJlnvCJF0Ya0b7mX3nn2D8c3jTlrj5WgK80mooY2kdZYmI1o1GOXjeFEHyXiKmytD2X8k5wl/3ndxptTPOOOe5xsbO9YFQL2uJywhA6cb5g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

T24gV2VkLCAyMDI2LTA4LTE5IGF0IDEyOjI0ICswMTAwLCBLYXJpbSBNYW5hb3VpbCB3cm90ZToN
Cj4gSGkgU2hpdmFuaywNCj4gDQo+IE9uIFRodSwgQXVnIDEzLCAyMDI2IGF0IDA0OjIzOjE0QU0g
KzAwMDAsIFNoaXZhbmsgR2FyZyB3cm90ZToNCj4gPiByZW1vdmVfbWlncmF0aW9uX3B0ZSgpIGlu
dGVybGVhdmVzIGh1Z2V0bGIgaGFuZGxpbmcgd2l0aCB0aGUgcmVndWxhcg0KPiA+IGZvbGlvIHBh
dGguIE1vdmUgaXQgaW50byBhIGRlZGljYXRlZCBjYWxsYmFjayBzZWxlY3RlZCBieQ0KPiA+IHJl
bW92ZV9taWdyYXRpb25fcHRlcygpLCBsZWF2aW5nIHRoZSBnZW5lcmljIGNhbGxiYWNrIGZvY3Vz
ZWQgb24gcmVndWxhcg0KPiA+IGZvbGlvcyBhaGVhZCBvZiBQVEUgYmF0Y2hpbmcuDQo+ID4gDQo+
ID4gV2l0aCBodWdldGxiIGZvbGlvcyByb3V0ZWQgc2VwYXJhdGVseSwgc2ltcGxpZnkgdGhlIFBN
RCBtYXBwaW5nIGNoZWNrIHRvDQo+ID4gYSBvbmUtdGltZSB3YXJuaW5nLg0KPiA+IA0KPiA+IFNp
Z25lZC1vZmYtYnk6IFNoaXZhbmsgR2FyZyA8c2hpdmFua2dAYW1kLmNvbT4NCj4gPiAtLS0NCj4g
PiAgbW0vbWlncmF0ZS5jIHwgOTcgKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrLS0tLS0tLS0tLS0tLS0tLS0tLS0tDQo+ID4gIDEgZmlsZSBjaGFuZ2VkLCA2MyBpbnNlcnRp
b25zKCspLCAzNCBkZWxldGlvbnMoLSkNCj4gPiANCj4gPiBkaWZmIC0tZ2l0IGEvbW0vbWlncmF0
ZS5jIGIvbW0vbWlncmF0ZS5jDQo+ID4gaW5kZXggYTMzNjJjYzllZjY2Li5lZTFiOGE1NWEyYTQg
MTAwNjQ0DQo+ID4gLS0tIGEvbW0vbWlncmF0ZS5jDQo+ID4gKysrIGIvbW0vbWlncmF0ZS5jDQo+
ID4gQEAgLTM3NSw2ICszNzUsNTcgQEAgc3RhdGljIHB0ZV90IG1pZ3JhdGlvbl9lbnRyeV90b19w
dGUoc3RydWN0IGZvbGlvICpmb2xpbywgc3RydWN0IHBhZ2UgKm5ldywNCj4gPiAgCXJldHVybiBw
dGU7DQo+ID4gIH0NCj4gPiAgDQo+ID4gKy8qDQo+ID4gKyAqIFJlc3RvcmUgYSBwb3RlbnRpYWwg
bWlncmF0aW9uIHB0ZSB0byBhIHdvcmtpbmcgcHRlIGVudHJ5IGZvciBodWdldGxiIGZvbGlvcy4N
Cj4gPiArICovDQo+ID4gKyNpZmRlZiBDT05GSUdfSFVHRVRMQl9QQUdFDQo+ID4gK3N0YXRpYyBi
b29sIHJlbW92ZV9taWdyYXRpb25fcHRlX2h1Z2V0bGIoc3RydWN0IGZvbGlvICpmb2xpbywNCj4g
PiArCQlzdHJ1Y3Qgdm1fYXJlYV9zdHJ1Y3QgKnZtYSwgdW5zaWduZWQgbG9uZyBhZGRyLCB2b2lk
ICphcmcpDQo+ID4gK3sNCj4gPiArCXN0cnVjdCBybWFwX3dhbGtfYXJnICpybWFwX3dhbGtfYXJn
ID0gYXJnOw0KPiA+ICsJREVGSU5FX0ZPTElPX1ZNQV9XQUxLKHB2bXcsIHJtYXBfd2Fsa19hcmct
PmZvbGlvLCB2bWEsIGFkZHIsIFBWTVdfU1lOQyB8IFBWTVdfTUlHUkFUSU9OKTsNCj4gPiArCXN0
cnVjdCBoc3RhdGUgKmggPSBoc3RhdGVfdm1hKHZtYSk7DQo+ID4gKwl1bnNpZ25lZCBpbnQgc2hp
ZnQgPSBodWdlX3BhZ2Vfc2hpZnQoaCk7DQo+ID4gKwl1bnNpZ25lZCBsb25nIHBzaXplID0gaHVn
ZV9wYWdlX3NpemUoaCk7DQo+ID4gKwlzdHJ1Y3QgcGFnZSAqbmV3ID0gZm9saW9fcGFnZShmb2xp
bywgMCk7DQo+ID4gKwlybWFwX3Qgcm1hcF9mbGFncyA9IFJNQVBfTk9ORTsNCj4gPiArCXB0ZV90
IG9sZF9wdGUsIHB0ZTsNCj4gPiArCXNvZnRsZWFmX3QgZW50cnk7DQo+ID4gKw0KPiA+ICsJLyog
VGhlcmUgaXMgb25seSBhIHNpbmdsZSBtYXBwaW5nIGluIGEgVk1BLiAqLw0KPiANCj4gSSBkb24n
dCB0aGluayB0aGlzIGNvbW1lbnQgaXMgbmVjZXNzYXJ5LiBwYWdlX3ZtYV9tYXBwZWRfd2Fsaygp
IGNsZWFybHkNCj4gZXhwbGFpbnMgd2hhdCBoYXBwZW5zIHdpdGggSHVnZVRMQiBlbnRyaWVzLg0K
PiANCj4gPiArCWlmICghcGFnZV92bWFfbWFwcGVkX3dhbGsoJnB2bXcpKQ0KPiA+ICsJCXJldHVy
biB0cnVlOw0KPiA+ICsNCg0KSSBjYXJyaWVkIHRoaXMgb3ZlciBmcm9tIHRyeV90b191bm1hcF9w
b2lzb25lZF9odWdldGxiX29uZSgpLCB3aGljaCBoYXMgYXNpbWlsYXIgY2hlY2suIERyb3BwaW5n
IGl0IGhlcmUgd2hpbGUgcmV0YWluaW5nIGl0IGF0IHRoZSBvdGhlciBjYWxsIHNpdGUNCndvdWxk
IHNlZW0gb2RkLCBzbyBJIGtlcHQgaXQuIEkgaGF2ZSBubyBzdHJvbmcgb3BpbmlvbiwgdGhvdWdo
Lg0KDQoNCj4gPiArCW9sZF9wdGUgPSBodWdlX3B0ZXBfZ2V0KHZtYS0+dm1fbW0sIHB2bXcuYWRk
cmVzcywgcHZtdy5wdGUpOw0KPiA+ICsJZW50cnkgPSBzb2Z0bGVhZl9mcm9tX3B0ZShvbGRfcHRl
KTsNCj4gPiArCWZvbGlvX2dldChmb2xpbyk7DQo+ID4gKwlwdGUgPSBtaWdyYXRpb25fZW50cnlf
dG9fcHRlKGZvbGlvLCBuZXcsIGVudHJ5LCBvbGRfcHRlLCB2bWEsDQomcm1hcF9mbGFncyk7DQo+
ID4gKwlwdGUgPSBhcmNoX21ha2VfaHVnZV9wdGUocHRlLCBzaGlmdCwgdm1hLT52bV9mbGFncyk7
DQo+ID4gKwlpZiAoZm9saW9fdGVzdF9hbm9uKGZvbGlvKSkNCj4gPiArCQlodWdldGxiX2FkZF9h
bm9uX3JtYXAoZm9saW8sIHZtYSwgcHZtdy5hZGRyZXNzLA0Kcm1hcF9mbGFncyk7DQo+ID4gKwll
bHNlDQo+ID4gKwkJaHVnZXRsYl9hZGRfZmlsZV9ybWFwKGZvbGlvKTsNCj4gPiArCXNldF9odWdl
X3B0ZV9hdCh2bWEtPnZtX21tLCBwdm13LmFkZHJlc3MsIHB2bXcucHRlLCBwdGUsIHBzaXplKTsN
Cj4gDQo+IEkga25vdyBub3RoaW5nIGluIEh1Z2VUTEIsIGJ1dCBjYW4ndCB0aGV5IGJlIG1hcHBl
ZCBhcyA0S2lCIGVudHJpZXM/IEluDQo+IHdoaWNoIGNhc2Ugd2UgaGF2ZSB0byB1c2UNCj4gDQo+
IAl3aGlsZSAocGFnZV92bWFfbWFwcGVkX3dhbGsoJnB2bXcpKSB7DQo+IAkJLi4uDQo+IAl9DQo+
IA0KDQoNClRoZSBjb2RlL2NvbW1lbnQgaW4gcGFnZV92bWFfbWFwcGVkX3dhbGsoKSBzaG93IHRo
YXQgaXQgaGFuZGxlcyB0aGUgb25seQ0KcG9zc2libGUgbWFwcGluZyBhbmQgcmV0dXJucyBub3Rf
Zm91bmQoKSBvbiB0aGUgbmV4dCBpdGVyYXRpb24uIFRoZXJlZm9yZSwNCmV2ZW4gaWYgd2UgdXNl
ZCBhIHdoaWxlIGxvb3AsIGl0IHdvdWxkIHJ1biBvbmx5IG9uY2UuDQoNCj4gSXQgc2VlbXMgbGlr
ZSBpdCdzIG5vdCB0aGUgY2FzZSBmcm9tIG15IGxpdHRsZSBpbnZlc3RpZ2F0aW9uLCBidXQNCj4g
SSdsbCBrZWVwIGl0IGhlcmUganVzdCB0byBiZSBzdXJlLg0KDQoNCg0KVGhhbmtzLA0KU2hpdmFu
aw0KDQoNCg0KDQo=

