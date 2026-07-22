Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B8BDAC4453C
	for <linux-mm@archiver.kernel.org>; Wed, 22 Jul 2026 15:28:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B60956B008A; Wed, 22 Jul 2026 11:28:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B11996B0098; Wed, 22 Jul 2026 11:28:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9D9556B009B; Wed, 22 Jul 2026 11:28:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 72D346B008A
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 11:28:43 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id F3DE01401FC
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 15:28:42 +0000 (UTC)
X-FDA: 85016794884.30.C270256
Received: from SA9PR02CU001.outbound.protection.outlook.com (mail-southcentralusazon11013015.outbound.protection.outlook.com [40.93.196.15])
	by imf06.hostedemail.com (Postfix) with ESMTP id 00D6E180007
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 15:28:39 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=ccraX+XG;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf06.hostedemail.com: domain of ziy@nvidia.com designates 40.93.196.15 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784734120;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QqRZL/rt0dpnEKkm7K2rlY2ObLEkb0mChA17+uCwGnU=;
	b=zljVEBY8w3sNyDRci/vC8zp19Ov8QLGja2s9ONiy79GmOzC9kdxcQCYx199Tyus8O4qqtZ
	ox3a9bDtV6htdOwtlnuybmUL2sXvo1+dNJQuYjW5301m2ifjdge10MTCbACPg8BkEkxTbD
	SF6AP62gGtACEVHdZJpm5xnxHLLjZqU=
ARC-Authentication-Results: i=2;
	imf06.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=ccraX+XG;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf06.hostedemail.com: domain of ziy@nvidia.com designates 40.93.196.15 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1784734120;
	b=gfPZphzvUNLthQT6kie10E2ztq9L5Yj6D7fRDk7Pr1IrVk4Z04p7BFSeLLelkT0WBr4+gn
	zJ1XDqlwiKJ4aJgMsZj6wo4hGBytgphcmiPekFElDcx383cwa1m/vIdnncTRDIzAYevxYU
	zJy/hGCLDU2CHnos/tMiN5QT77GD3pw=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=hPOW1fTVx2Wuans8dJa8ce/fsd00QbbmVAR0uvVdnSWtDnSHT6/GXo5yN/M1QI7uEWMEi/vx571U43yra5WhkLSXNbtTPMkmcO1oBEyiUvD6URe6UioUX3r3qgCW/9+4DOLc1NYdmOfOn+HQdtRYclB5pDweSgx78/P0VRABSzQU1jZE7TzN4MfYZo8fJY4VZRQgf7nNl7v5TICQJkSlyiIp10Q9cqvOzXDCf9foPbZYf8y8liVUy90AFFe+E4zMhelPzeuGg15k19EcsoTowt6TvuLnmbiKP+AIG1CFtaB6IMOpasDcc9NyJ3hKWCBOYb0pCIQJlwWPr1ON35JBdA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QqRZL/rt0dpnEKkm7K2rlY2ObLEkb0mChA17+uCwGnU=;
 b=u3Lcnd2arCfNNzaIR1NAV7K3OUWs/+vA2ChX4TVhfYXm1uf95apNN7ZAVcYHhN0K+Q+9AW2+dFPNtfjb3VycNRgWjKdKZv9W4gV4jJ1MjCus6j5R6MY73HqUSGoFRkEkGv0CERathAfjfLj+bOqlvjNBmGQNFfoq1R2BPkEH2LoBaDDlfF/UMqawJDDpF+9u0sHRglxY4ZCk2HbcFhWGUAR2J1vYZ0LQ3D/8M1/5dv3mSJlIH5XVXnP2gm3UrxaolZMc6Kf5HbVNvKzlruPWl9g20ibyFqARHHZConafkheKVnzWi6Z1cRVEai/w1vcAtxalDn9AJNWubkIp7/is7Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QqRZL/rt0dpnEKkm7K2rlY2ObLEkb0mChA17+uCwGnU=;
 b=ccraX+XGob2V/oIUoPe4s1hI+hG78PRdhMaFKEyY0rJg3iCll5nuFs2NjjmdTN7XJ7DiGP4HuRrj2HPo/U42TcdfKagu8DJZXnYo2XF10gLXgNL/9HKj708rhavCpd1ir3fT8gxx8HM+JxCKKPjDbkKyqiFsxeA+PcOcK5jlNXxZK3n6aIMWJHLcqEUHkjkd9dLcEIdfIzCU+qjoCSN5VFAHle6eI7Vz5Ir9EWdauxHM6tRV62WZwgGh8b1oRR66b8zaYFbq44cL7kh92Ejj7G7AfxmUrQ2XcGrGPATBv2eWc9LcmioyuBqU7YVjW+ZDvpEjZLjMWLONYJTSeWPAXg==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by MW3PR12MB4380.namprd12.prod.outlook.com (2603:10b6:303:5a::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.245.10; Wed, 22 Jul
 2026 15:28:34 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%5]) with mapi id 15.21.0245.009; Wed, 22 Jul 2026
 15:28:34 +0000
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Wed, 22 Jul 2026 11:28:31 -0400
Message-Id: <DK57FVTRTLR2.1A906PYJ2TCE4@nvidia.com>
To: "Matthew Brost" <matthew.brost@intel.com>,
 <intel-xe@lists.freedesktop.org>, <dri-devel@lists.freedesktop.org>,
 <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>
From: "Zi Yan" <ziy@nvidia.com>
Subject: Re: [PATCH 1/3] mm/huge_memory: add folio_split_driver_managed()
Cc: "Maarten Lankhorst" <maarten.lankhorst@linux.intel.com>, "Maxime Ripard"
 <mripard@kernel.org>, "Thomas Zimmermann" <tzimmermann@suse.de>, "David
 Airlie" <airlied@gmail.com>, "Simona Vetter" <simona@ffwll.ch>, "Christian
 Koenig" <christian.koenig@amd.com>, "Huang Rui" <ray.huang@amd.com>,
 "Matthew Auld" <matthew.auld@intel.com>, "Andrew Morton"
 <akpm@linux-foundation.org>, "David Hildenbrand" <david@kernel.org>,
 "Lorenzo Stoakes" <ljs@kernel.org>, "Baolin Wang"
 <baolin.wang@linux.alibaba.com>, "Liam R. Howlett" <liam@infradead.org>,
 "Nico Pache" <npache@redhat.com>, "Ryan Roberts" <ryan.roberts@arm.com>,
 "Dev Jain" <dev.jain@arm.com>, "Barry Song" <baohua@kernel.org>, "Lance
 Yang" <lance.yang@linux.dev>, "Tvrtko Ursulin" <tvrtko.ursulin@igalia.com>,
 "Dave Airlie" <airlied@redhat.com>, "Matthew Wilcox" <willy@infradead.org>
X-Mailer: aerc 0.21.0
References: <20260722044220.1110278-1-matthew.brost@intel.com>
 <DK564OOZ3JUK.292JORO9KGKEV@nvidia.com>
In-Reply-To: <DK564OOZ3JUK.292JORO9KGKEV@nvidia.com>
X-ClientProxiedBy: DS7PR03CA0133.namprd03.prod.outlook.com
 (2603:10b6:5:3b4::18) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|MW3PR12MB4380:EE_
X-MS-Office365-Filtering-Correlation-Id: 797603bc-a8c8-4e98-04be-08dee805e499
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|1800799024|366016|23010399003|376014|4143699003|56012099006|10067099003|11063799006|5023799004|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	rH6EkIaP9s70ljS4cZWYXQgsC3+UUuAkektu5SJi3GH1qCm21IHW6rgfbBttNaq6mhmk9Hv7GTrjrwvpRThksz4LFXrozLmET9KRZ7cpkEAdKLV7eBLYJnQs1sg9n1em6YkmipsKxkLj9rGCCOXOMD8LesW/anLs7jeHDObhMeNaBDVu9ocSnTNmpD14WCw30Lwl8HSmAgzc5mBdCBAkc8WVPUvB4UsrxU83v+ciwpYNQe46i7wyzhC1tcoUtd9eRAt6dkbi43VljyUXOiyqKPpKeZ0tF7WQkCTdqvmK1ylMkbuE1rIOgOFhRVOxpyYDQqHXDVlDw8hKP8U8NC7Pc7k1NbvI12njoBSGOYkJ3DP1J6nfOniTJsMl0pBiNiVkJtUDpvI7WodtF7eEvLnRqzjBDoBgYOjQSOrv4eY3rZiHq0aRe/5S3HHcmtDUnamXC5sOvf4mHON4CABkdBjmzxxCdletT3D3vPPk+iRK9FQVtGjgFg8kLDrP8uZrfYz2O+WP/PRQO6TlAmezH7vd8X8Hs85vfhNNY4RU56HnlzKz0pHhLJREXNApqW8mVYUjCcKbMNVin/MMdXTl3Ni8DUFC71DbDA1jfJdZvPqItl8UN4sQm8JiqvaR6JbtFZ4+brOZjdY+8t4JOada91xY1toVG4XrV5Ejt9ChGZKJhW4=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(1800799024)(366016)(23010399003)(376014)(4143699003)(56012099006)(10067099003)(11063799006)(5023799004)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?b0lBdW5JTVlFNzd2eFA3V3d5NTQ3WE01ZDRkWFUyNkdkRlV3WGJENHJEVzVS?=
 =?utf-8?B?UDFxS3VaZHdIWE9BQmNiblpHeXJONVZCL3BrcUlBTGsyM0V1ZmFvWW43c0I0?=
 =?utf-8?B?WkVmK0ZMYlhOenl6SjZTZ0UxQitlMnZkN1RjZkh0Nm5PTjFQWmxmSmVUaDVE?=
 =?utf-8?B?MytENDlPbGM2QlM3bGFCeWlSUWJUdUV1Rm4ySmozdjdsa1NETUZZQnU2S1pz?=
 =?utf-8?B?ZXRpNEJhRENZTG1VT3pzcDdkYkFWOWtQU0l1d3FTRTI5MnBDMEMrK0MyVHJ6?=
 =?utf-8?B?RlNjSXhSQ1Q1TWNLQnljUUJHQUZlQVp0ZUVleXR1NDZtSFc5bHdiQk4vdisx?=
 =?utf-8?B?a0RES0xVMGIyTHN5Z2FUZndJZWhXSXFYRS8xWjBmZHN6eGpIUmZOc1lxYzgz?=
 =?utf-8?B?YTEyQWpESzh5THJwVUMydkFQcVVBL0ovTFQyNy9SMUJ0RjgxajdiVzVlR05l?=
 =?utf-8?B?dm1oQTNaL3hZc2s4QjNKWXNTVTNBY3VHY0gwT2hCOHpSNTMzcWZDN0NJS0Vm?=
 =?utf-8?B?bmw5UUlBYzU1a2JvNzhpZzJLUm9lL1lhV1J2c3pySzVaUWxhaVBHbkN3YkFO?=
 =?utf-8?B?aEgxbWdXMmdQL1ZXekhzSDBmZkFPa0RrQWs1MjYwajdRbUZvVXNOMGUyREkx?=
 =?utf-8?B?Nzd2dlF1YkFjeDg3MmEyV0Z1QnE3ZGY1R00vUG0rbUN5TFl1dWhWY3FLc0cr?=
 =?utf-8?B?ZGZENXh3ZVNkYmtjckh4dVd5SHJNRjBWTEhYaVBEOXQ5NnUyOUhUSkt6TW9i?=
 =?utf-8?B?eTgxTDNrcnRIVHEzbmVoRm9iQ0hpSXJIQVF0SjhqK0Nnd2k0OXlIeE5md0w1?=
 =?utf-8?B?QTNtRHc3SHRGemxtRkdxMUdCeVlBVzQwL1JTRjZ0dFhOWEJmYzFqNUVPejEv?=
 =?utf-8?B?cFhzR0o0YVVkaHRsUWh5N21FRGpSSzFXQWNucVhRZ1dKMm0wdVlHeDNtU2Zk?=
 =?utf-8?B?QTMrRmg5QmRBcldod013cHdYUTNVcW4wUjZ0emxraE9FWE03NDBtbHdiNC8v?=
 =?utf-8?B?a1VyNU10d0ZMUjZNd1Izbjczd1drRzNxTEZBbXpLalV0UjhzeFRVam9pOXpG?=
 =?utf-8?B?VWFraERHeDFyZEJuU2RHR3Y2YmlwZlRCREgrTEJMaG9HNHFzanNuQnAva0JI?=
 =?utf-8?B?N2xvbEsrOVllRTBnNmY4SmNJSHEwSzZhY05NQnNFWktiUVpaQktMcWZXMHBz?=
 =?utf-8?B?UURZNE5jQlVreDBIVitwSVdSK08zTDNRU1gyZ0lrMk9Fc0J6c2NQN0VzTmk3?=
 =?utf-8?B?N0dRUmk1K0xyTm9jZUpLbjE0K2tBZ2UyVlRtM1RoQTROKyswNFAySWdnbTlY?=
 =?utf-8?B?R2Ivbk1HeXN6NXlNaGNwaU1rUkJVT1YybXlrVDdydVYra2V3YTRUdWVsMVN0?=
 =?utf-8?B?SHpIQ3J5U2pjc09OTVRiOHl1MnlBU2ttRjBSc0VIbjJxUEwwOFRLcTNvMmwv?=
 =?utf-8?B?Mkt3VUI5Q3JsaWc3WlZOR1FNdDd1K1RQV1licnQvVHJ3dllWZGhyWVgxTGdv?=
 =?utf-8?B?R2EwdlFDUTg0bVNYNVVvTkpUc1lIbjlRVHpLM3NmMlZQVDJzaDNkRGZ0NDFK?=
 =?utf-8?B?cis5SjhXUzFNMEEyWWlMUFphMng2b3lBczNFTXdvV2ZRR3A3c0JPN0Q1UG0r?=
 =?utf-8?B?TW5HRCsxa3o2MTRZcis5c0UwUm9ERGVScHQrQWNORC9tRW9GTjdLYWY0RC9Z?=
 =?utf-8?B?Wmh2V0NkVW40Vi94dVlibEMwYmVFNnhHWGNPb0pZT1I2bFJkTU03QXRoYWZP?=
 =?utf-8?B?K29QSDlHclc1Sy9NN3JPbnpQMFRGa3pTSTNZcG1PbU8rR2kvTU9WUFBHTVQ0?=
 =?utf-8?B?K3BOQ3E4aWFQNHJrYWtqM2VwNmNhNitxMVc3WURWajBJZjRZeWhEd0JYcWxP?=
 =?utf-8?B?cmlSNVRLcWhEdGlFUGpRK0NvdTRIOUtJc3JMQXR0TERsSk5iZXlrK2c4YUJZ?=
 =?utf-8?B?WmwyaXl3cWZQZG9ueTRQYVVtdHhqVUJDNFZ5MlFpUHl0ak9WSWxsdHV2Mk0y?=
 =?utf-8?B?UXJVMUNVVS9BaWN4cHJRZUJSMFZjMFlOVGw4aitQUEVhL3RGREFNUFRqYUs5?=
 =?utf-8?B?eTRmVnNFckZCRXZSRlBlV1d4dWUyQnRoQ2h5S2JWY2tsYjMwdGd4cFNzUmtQ?=
 =?utf-8?B?NWNlTXNpNkZwSWdMTk9uR2dzNEFZMENJd0FSK0dDMTJieU9DdUVlUFcyV08x?=
 =?utf-8?B?NzQ2Um5vQS9yVmdEWUNqMmIvcGw1cEltSGtSM0NqVkxHVVRnSEFuc2ozQ05h?=
 =?utf-8?B?TVN2ZCtXLzZxY0hQVnBBZGpIeWgxcXZPYmRnNjIyN0htSjdScFltMkpJeUg0?=
 =?utf-8?Q?FH030KQXhCkTmCiinc?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 797603bc-a8c8-4e98-04be-08dee805e499
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jul 2026 15:28:34.2426
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JWUZE/OYdqnUMUAyfnCirV9ZpQIljwc1lSXxe9ItW5v22gg6Mdct4K9O5OF+i/hB
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR12MB4380
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 00D6E180007
X-Stat-Signature: n7wpm6iwtitk9reiax7xuw6awhcb67ej
X-HE-Tag: 1784734119-999808
X-HE-Meta: U2FsdGVkX1/EFlMH/R4/Um7ycFGioeGPXgEZ/rD4PFZ/6u/h4pdrYvcQbKdBrZolsXQC3RGx8dASs9PCDwustZcX3WLTzDaFKY9Zdul5YDxa+zddSwJcRRhTL98YgP9zMSGxmOr5eRxCFJAKgKfdZ1P/QlwEmqkvb3pRjERv3b/eINki+neTZsox5KEuKUfg3u6nU38NEtMaClSisT4ydSD4CANNySy3H1JYbXHM3Vd8H0C6YJAEqEFIESaVBp/F1BJdSlYvf6KgRIpip6/LEwBQrZkv7EzuO/YicoqO92jc1kG+ggWmjM8TkaFS3hpE5MJjaCWjW4K+gaOJgQKU8XsU+ybFMKz3D4f+p32pNsrDFnVfTboGOnI6D6T5nw76ykIlHEFAQsohMVNfpRGjMhUkP4AA7zl80krF4HHtiuHj5Jiaem/V5kcVRYx3Q0uYLbkuI87Q496FWOGj2JurQqxglRxJwb3GUzKCkXE+0f98JKWktl1Ja5hV3/1OfpfIXy7ufDj+m45v7GMfossIrca4zfhtfx9EPNLBRFJrHLL45nBYAQ755SC7FwVcpjL4X0JN9hf4mTZvZ24NT7BFzTWKXRfdBHDhOrgBPRE8ZS8utLDyRNEgdBo6aA4Wxi7Tlwsd/+o8Dlz4cVI2hRGLE7E0DBrK+2P/+47nMpCcTtyU7x3ZHjmIzszpmFuzEOm75BGgwDzKJ+i/rHRTeFSmGYvSseWJMmJYbDzPfvYoXKxPUNelbyqeAIr3uOmziDSc7fBhff4G6qcetHssIqmQ1E41qcw+FkmDAhIAJ2MFF88HRloXuO7+H3U5VQYH/ojSKLGgSSN19sQw9daiTPL1GOEV3HOV82NcpXzeBqaLWIfMaM1iV/OYTu3IDhppiqAmsGqN9jmxdOOtgtQao8N7H2K6urcg4ygx9dN+XDzYebMyA1x+eTxwThl0xmVjm6hWpUVD8czw01BK2Q65pPA
 c8IQVaRV
 m8Pclo+1uX9TbHIGU7iuU7aoOO1HR75lfAcQzscujEqfF+nWMuMb+vo3qVlnc+R6QWrOUqWzbJTVkt8pMjj+te+5NfebN6TRJn5QIwDEhirSh4Sh32+SGhTm6ZH+gPWw+zdg8qLbeM7Aua13nvkKxwKffVYCJeA/B6oRaC72aB4LFsLC+ZDa9oyiO8VG/c4aTBw2hNyRUqLFd+xpohhBiVbPm+qsWvoYZOBIejv5lqI2Ks+2cgW71k3Y009JKdut5uBPeMKzZ9JIdltpJE9w3fEH/8Iep5KFrBh5gMspRSuGyqP6GiSJk1ZWg/7AQpKN1Oe1NXFBSOnX8OqJYkT+P5pQ+a8tqdLSO0ngufmN8JfPExNXoEJhugCG+sUNGnRhIRuiaDpucmvlO52Z5cyBaqA8Q+nG75750OsaneVlNnxN9zERBIHQar4Ql1yQwXsv7LYmwigvkpVl31cOWwCNdD6iXwDBQKQHC1e7J8urUKG2Y9qLF0A4xU1RTcVL6iRhml4Xj5iYi6sakTZtfL+/m69iQv6gfHy2Um92DsDy63dfOgQzxmbURGltVilVemBXKUHI0rKw04n7QmWl4nnGnyFdDMOxXoNKYVsNtioxLncJGoxw3PbV24eCurD2txaxYUs1bb3dZ0CYfVCReXncCc0wU8QMZYxi2D9WTXiK6uKGzSOAngbebzgq51WrQcULmCMdJVEECKy7EhCcV6mF6wD9qU3ObaiMaQ9sgYoR2hmnTbOsdhqbyCC64bS/SP+wy9Ps6eVb9HEke+wsNdoDQwy9wf4IONvIZMJJJ6OgOH90SRk/uazU8xKRlw+M9BvNt1TfnvHIa3IwDECAv6V9jk2M/POk5FMsFbonaRTFk+lLGywGbmyJM2lEKaIo5sDBybdbW+DVLLi1MO2WwYi7DSh7v1hN7KbQ2+Em+zOSLxvL0TWiovN7mtaWFDA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed Jul 22, 2026 at 10:26 AM EDT, Zi Yan wrote:
> On Wed Jul 22, 2026 at 12:42 AM EDT, Matthew Brost wrote:
>> Add a lightweight structural split primitive for large (compound) folios
>> that a driver allocated with __GFP_COMP and manages entirely by itself,
>> outside of the core mm's view.
>>
>> The existing split paths - split_folio() and folio_split_unmapped() -
>> are built for folios that the mm owns: they perform a refcount freeze,
>> walk and remap the rmap, and take the anon_vma / i_mmap locks, and
>> folio_split_unmapped() further assumes an anon, pagecache-style refcount
>> model (nr_pages + 1). None of that applies to a folio that is:
>>
>>   - singly referenced (the caller holds the only reference),
>>   - not mapped through the rmap (folio_mapped() =3D=3D 0),
>>   - not in the page cache or swap cache (folio->mapping =3D=3D NULL),
>>   - not on any LRU or the deferred-split list.
>>
>> For such a folio the split is purely structural: because nothing else in
>> the kernel can reach it, there is no need to freeze the refcount or touc=
h
>> any mapping. folio_split_driver_managed() therefore performs only the
>
> I do not think so. PFN scanners like memory compaction should be able to
> see them, unless you mean something else about "a driver allocated with
> __GFP_COMP". You will need to freeze it to prevent the to-be-split
> folios being touched by others.
>
>
>> compound and split-accounting teardown via __split_unmapped_folio() and
>> then hands each resulting order-@new_order folio its own reference,
>> mirroring split_page() for compound folios. The caller keeps the origina=
l
>> reference on the first resulting folio and is responsible for freeing al=
l
>> of them individually.
>>
>> The immediate user is TTM's GPU page pool, which allocates higher-order
>> compound pages, maps them into userspace via VM_PFNMAP (never through th=
e
>> rmap), and needs to split them into order-0 folios under memory pressure
>> so pages can be backed up to shmem and freed one at a time.
>>
>> A CONFIG_TRANSPARENT_HUGEPAGE=3Dn stub is provided so callers can build
>> without the split machinery; it warns and returns -EINVAL.
>>
>> Cc: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
>> Cc: Maxime Ripard <mripard@kernel.org>
>> Cc: Thomas Zimmermann <tzimmermann@suse.de>
>> Cc: David Airlie <airlied@gmail.com>
>> Cc: Simona Vetter <simona@ffwll.ch>
>> Cc: Christian Koenig <christian.koenig@amd.com>
>> Cc: Huang Rui <ray.huang@amd.com>
>> Cc: Matthew Auld <matthew.auld@intel.com>
>> Cc: Matthew Brost <matthew.brost@intel.com>
>> Cc: Andrew Morton <akpm@linux-foundation.org>
>> Cc: David Hildenbrand <david@kernel.org>
>> Cc: Lorenzo Stoakes <ljs@kernel.org>
>> Cc: Zi Yan <ziy@nvidia.com>
>> Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
>> Cc: "Liam R. Howlett" <liam@infradead.org>
>> Cc: Nico Pache <npache@redhat.com>
>> Cc: Ryan Roberts <ryan.roberts@arm.com>
>> Cc: Dev Jain <dev.jain@arm.com>
>> Cc: Barry Song <baohua@kernel.org>
>> Cc: Lance Yang <lance.yang@linux.dev>
>> Cc: Tvrtko Ursulin <tvrtko.ursulin@igalia.com>
>> Cc: Dave Airlie <airlied@redhat.com>
>> Cc: dri-devel@lists.freedesktop.org
>> Cc: linux-kernel@vger.kernel.org
>> Cc: linux-mm@kvack.org
>> Suggested-by: Matthew Wilcox <willy@infradead.org>
>> Signed-off-by: Matthew Brost <matthew.brost@intel.com>
>> Assisted-by: GitHub-Copilot:claude-opus-4.8
>>
>> ---
>>
>> The patch is based on drm-tip rather than the core MM branches to
>> facilitate Intel CI testing and initial review. It can be rebased onto
>> the core MM branches in a subsequent revision.
>> ---
>>  include/linux/huge_mm.h |  8 ++++++
>>  mm/huge_memory.c        | 63 +++++++++++++++++++++++++++++++++++++++++
>>  2 files changed, 71 insertions(+)
>>
>> diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
>> index ad20f7f8c179..35661d82d54a 100644
>> --- a/include/linux/huge_mm.h
>> +++ b/include/linux/huge_mm.h
>> @@ -402,6 +402,7 @@ enum split_type {
>>  int __split_huge_page_to_list_to_order(struct page *page, struct list_h=
ead *list,
>>  		unsigned int new_order);
>>  int folio_split_unmapped(struct folio *folio, unsigned int new_order);
>> +int folio_split_driver_managed(struct folio *folio, unsigned int new_or=
der);
>>  unsigned int min_order_for_split(struct folio *folio);
>>  int split_folio_to_list(struct folio *folio, struct list_head *list);
>>  int folio_check_splittable(struct folio *folio, unsigned int new_order,
>> @@ -656,6 +657,13 @@ static inline int split_folio_to_list(struct folio =
*folio, struct list_head *lis
>>  	return -EINVAL;
>>  }
>> =20
>> +static inline int folio_split_driver_managed(struct folio *folio,
>> +					     unsigned int new_order)
>> +{
>> +	VM_WARN_ON_ONCE_FOLIO(1, folio);
>> +	return -EINVAL;
>> +}
>> +
>>  static inline int folio_split(struct folio *folio, unsigned int new_ord=
er,
>>  		struct page *page, struct list_head *list)
>>  {
>> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
>> index 2bccb0a53a0a..06f9a5f35df8 100644
>> --- a/mm/huge_memory.c
>> +++ b/mm/huge_memory.c
>> @@ -4185,6 +4185,69 @@ int folio_split_unmapped(struct folio *folio, uns=
igned int new_order)
>>  	return ret;
>>  }
>> =20
>> +/**
>> + * folio_split_driver_managed() - split an exclusively-owned, off-LRU f=
olio
>> + * @folio: folio to split. Must be a large (compound) folio that is own=
ed
>> + *         exclusively by the caller and is invisible to the core mm.
>> + * @new_order: the order of the folios after the split.
>> + *
>> + * This is a lightweight structural split for folios that a driver allo=
cated
>> + * and manages itself (for example TTM's GPU page pool, which allocates
>> + * higher-order compound pages with __GFP_COMP and maps them into users=
pace
>> + * via VM_PFNMAP rather than through the rmap). Such folios are:

Strickly speaking, these vm_insert*() compound pages are not folios,
since folios are supposed to be rmappable and they are either anonymous
memory or file-backed memory. I am working on separating them from
rmappable folios by replacing PG_private with PG_folio and marking all
pages in a folio with PG_folio in page_rmappable_folio().

Hopefully, we can find a better name, like refcounted_folio, later for
these non-rmappable compound pages.


>> + *
>> + *   - singly referenced (the caller holds the only reference),
>> + *   - not mapped through the rmap (folio_mapcount() =3D=3D 0),
>> + *   - not in the page cache or swap cache (folio->mapping =3D=3D NULL)=
,
>> + *   - not on any LRU or the deferred-split list.
>> + *
>> + * Because nothing else in the kernel can reach the folio, this helper =
does
>> + * not perform the refcount freeze / remap / anon_vma & i_mmap locking =
dance
>> + * that split_folio() and folio_split_unmapped() require. It performs o=
nly
>> + * the compound and split-accounting teardown and then hands each resul=
ting
>> + * folio its own reference, mirroring split_page() for compound folios.
>> + *
>> + * The caller is responsible for freeing the resulting folios individua=
lly.
>> + *
>> + * Context: caller holds the only reference and excludes concurrent acc=
ess.
>> + * Does not sleep.
>> + *
>> + * Return: 0 on success, negative errno on failure.
>> + */
>> +int folio_split_driver_managed(struct folio *folio, unsigned int new_or=
der)
>> +{
>> +	unsigned int old_order =3D folio_order(folio);
>> +	unsigned int split_nr =3D 1U << new_order;
>> +	unsigned int nr =3D 1U << old_order;
>> +	unsigned int i;
>> +
>> +	if (new_order >=3D old_order)
>> +		return -EINVAL;
>> +
>> +	VM_WARN_ON_ONCE_FOLIO(folio_ref_count(folio) !=3D 1, folio);
>> +	VM_WARN_ON_ONCE_FOLIO(folio_mapped(folio), folio);
>> +	VM_WARN_ON_ONCE_FOLIO(folio->mapping, folio);
>> +	VM_WARN_ON_ONCE_FOLIO(folio_test_swapcache(folio), folio);
>> +	VM_WARN_ON_ONCE_FOLIO(folio_test_lru(folio), folio);
>> +
>> +	/*
>> +	 * Structural + split-accounting teardown only. No mapping/xarray, no
>> +	 * refcount freeze: the folio is frozen-by-ownership already.
>> +	 */
>> +	__split_unmapped_folio(folio, new_order, &folio->page, NULL, NULL,
>> +			       SPLIT_TYPE_UNIFORM);
>> +
>> +	/*
>> +	 * Give every resulting head folio its own reference. The original
>> +	 * reference stays on the first one, exactly like split_page().
>> +	 */
>> +	for (i =3D split_nr; i < nr; i +=3D split_nr)
>> +		set_page_refcounted(folio_page(folio, i));
>> +
>> +	return 0;
>> +}
>> +EXPORT_SYMBOL_GPL(folio_split_driver_managed);
>> +
>>  /*
>>   * This function splits a large folio into smaller folios of order @new=
_order.
>>   * @page can point to any page of the large folio to split. The split o=
peration




--=20
Best Regards,
Yan, Zi


