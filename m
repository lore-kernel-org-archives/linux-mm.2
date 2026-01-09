Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0DA55D26D7B
	for <linux-mm@archiver.kernel.org>; Fri,  9 Jan 2026 17:28:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6A65F6B0089; Fri,  9 Jan 2026 12:28:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 652CE6B008A; Fri,  9 Jan 2026 12:28:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 50A436B008C; Fri,  9 Jan 2026 12:28:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 38BE56B0089
	for <linux-mm@kvack.org>; Fri,  9 Jan 2026 12:28:34 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id D22BE8BEFB
	for <linux-mm@kvack.org>; Fri,  9 Jan 2026 17:28:33 +0000 (UTC)
X-FDA: 84313109706.01.BD0980D
Received: from SN4PR0501CU005.outbound.protection.outlook.com (mail-southcentralusazon11011032.outbound.protection.outlook.com [40.93.194.32])
	by imf25.hostedemail.com (Postfix) with ESMTP id 11D3BA0014
	for <linux-mm@kvack.org>; Fri,  9 Jan 2026 17:28:30 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=Fvj2pGGe;
	spf=pass (imf25.hostedemail.com: domain of ziy@nvidia.com designates 40.93.194.32 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767979711;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xoW7j1Om2H6uCrQejweC25e5NKqmYgoCIsclhHzWBw0=;
	b=HLceogRwHnEBkajZpdsDFs8JOZj0889kcPUqgx79kx+3oGdQqtONZTrqD6ZR7f0/TU4Om/
	lJfPhh7/UEr2OlDba6oY8Wt46IjKQRZ8AyYQSQ5xI+yT+snvwuocHVtNdaqHFN4kJe/knT
	cev2wIjclMF8Mm2qgQM7OIgdjFoqcR4=
ARC-Authentication-Results: i=2;
	imf25.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=Fvj2pGGe;
	spf=pass (imf25.hostedemail.com: domain of ziy@nvidia.com designates 40.93.194.32 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1767979711; a=rsa-sha256;
	cv=pass;
	b=54ApfNs4YG6fQe9L+YJnr+BII/l/BN/r+tQbR6xANfMJbBq4okxO3OMhV6F5bCU4VCcHpi
	gUNGZMW7Xb5mlTjde/Ao4b0T/a7xmb57Hck91cLEZgi8funur8MTaNJ/2EhPKlPRaF1727
	YZiySfd516LmKN4JQCEu495Oz1jePFs=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=gjicVUqozaX3u0WXagrt8Nxf0BDeHZXZlGtfs7EWlGa1s014mbeqTQnwquPWvq7IFdfdm3nhhfPzWgcTZlRIlt5ToWQK1F2NyVz45w3qgTJjY+fvKAU4NExTPpGHJu1qt9pyrSFapeE4GXxM6k21s0No9NVvC7YXxJEowlHlCvcAu9KnVNMQP4/O/1+NJI1Iez1boMq0JMBuZlJd3UQg8tVqEojKIcbj7VeaczsM10q/49EZ/5Oyy8+9PvwkD6WhCllY4DdsuluNqNiLxAGrF7nTIVUcwWuUiqeW1QL6f7KSrHLQkEY7Erv/Zo6Cc4J2qy+qfyYqzeo/Uk9XZBe7Jg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xoW7j1Om2H6uCrQejweC25e5NKqmYgoCIsclhHzWBw0=;
 b=HlAGK5ejlGK4o/YG/SOXYD5BA37xI18ssFI+IUhbonbtfveKslFej/OmtANhYYkj9593p6WN2oa5Tk9AdPn9ea4kWiR+h+Cb7r6G9D1koHc4tluJs+2pXir7o7xKRPx9XTOGl1waQ2DOO7j+27GS6XC+tCl5dpK3r8V6gvgrA09QbTcrbdd3PMuIozBIA5Hw97gtEwykP9K6ofCVC2oqOTWw/w+Hc6FCi25UqJZ1LN0hbQ08InQtqtrqzKxUf++VT0+Y12ojYyKiB/Wt0gQwqYPsJRFLuLqTPPeGQa2Rlj86y+dHhfew0LzbdjYReGo2Zd9M91vDfEp6YQlT7n0HTA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xoW7j1Om2H6uCrQejweC25e5NKqmYgoCIsclhHzWBw0=;
 b=Fvj2pGGe+y2SO25MgeLplVhqzn5rpS1FjB50Z8GTTG4RM8P1dxDBpxje/fDS/p68uQoQHBOTHsih7T+aEUhOITzVL9GOKm0uuculz4ytVkLqjO7HJ9xYlTim9N/Tl55/u5AVk3MFq3FJIGCtuWrYYux/S0PnQPRviOYbLOkHVViyOnnq+qom8XKuGWXNDtkkz92CRpqnqFu5uilb3sx//V2fARPODXdMBUngihjZO5hrsV0lwRMewigSxJ3tXa83TAdpJLSifB/DgC3gA6oAm26gNn3Astn9K1Zq5OrVh17wYc/8gcCkSEi6hg7+d93gYcoCkzctPbZR5w0KIhhGTA==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 CY8PR12MB7540.namprd12.prod.outlook.com (2603:10b6:930:97::15) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9499.4; Fri, 9 Jan 2026 17:28:28 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a%5]) with mapi id 15.20.9499.002; Fri, 9 Jan 2026
 17:28:27 +0000
From: Zi Yan <ziy@nvidia.com>
To: =?utf-8?q?Mika_Penttil=C3=A4?= <mpenttil@redhat.com>
Cc: Francois Dugast <francois.dugast@intel.com>,
 intel-xe@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
 Matthew Brost <matthew.brost@intel.com>, Balbir Singh <balbirs@nvidia.com>,
 Alistair Popple <apopple@nvidia.com>, David Hildenbrand <david@kernel.org>,
 Oscar Salvador <osalvador@suse.de>,
 Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
 linux-cxl@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 3/7] mm: Split device-private and coherent folios
 before freeing
Date: Fri, 09 Jan 2026 12:28:22 -0500
X-Mailer: MailMate (2.0r6290)
Message-ID: <DF5A6B81-7811-4654-855F-8EAB76CCCE51@nvidia.com>
In-Reply-To: <d1d80b81-678d-4d28-9ac2-95cb74824e73@redhat.com>
References: <20260109085605.443316-1-francois.dugast@intel.com>
 <20260109085605.443316-4-francois.dugast@intel.com>
 <d1d80b81-678d-4d28-9ac2-95cb74824e73@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BY5PR17CA0035.namprd17.prod.outlook.com
 (2603:10b6:a03:1b8::48) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|CY8PR12MB7540:EE_
X-MS-Office365-Filtering-Correlation-Id: 70ac0904-74e6-43ce-2e22-08de4fa48036
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?ZWVUMEtsc2Q1ZXFLL2NGcXkzSE9MNDAwb2NsMnlrbHVQRmRncEtPaGRpL1g3?=
 =?utf-8?B?SloyZDlYNEF3UVBTaVlIcGZNWmZmY3NMQk1yWFBCTEpmaEgrQkMyU2NpaHdI?=
 =?utf-8?B?S1pIWVFFcWUwamVibEVQTnVTZGg5T3c3RWwyNmF5REQxa1RsWGo5QVB0SktF?=
 =?utf-8?B?MWFlZGYwd24wdnVrbzROSGxVYVFmUE1DQWhhaHNkNTRTR2I2enBoY1kxZE10?=
 =?utf-8?B?SGZIaHVYSTVDTzJ4VlFCZ1JQMkFHb0dYbVM3SmE5aE02QldmRE11YnZid3Rm?=
 =?utf-8?B?amlmRWh2TTkzaDNCa3ZuRjlRNE9vSVJKdHFhWjlVWUFEaXRIdlJja3NINEZ3?=
 =?utf-8?B?YklNZGxpYW4rSEVWSzBoTzhlbTBiUUZ5OVBJWlBKSTNSTm1WRzVKYitvY0dE?=
 =?utf-8?B?emc0SG5BVmRZYUxKRENBNUR6TGpkVEFYVVpnT0tVbSthM3gwTXBVQytUeUVS?=
 =?utf-8?B?WWRWWlZOMUcycTkzVjFCRy9IdmNncDczcVArajF4QjRxZFVsUzQrOWtzZnFV?=
 =?utf-8?B?d0dzT1NqdElaZTlsTGRKOE1aWTlxTk0xemN2TmVsbzVESDhxS0xzQjlHM290?=
 =?utf-8?B?elVLOTBTUVRTTnRMaHNPQ1pDbnFrTjJOUEh5cVVPOEp4c3ZTLzNuczRHZkpE?=
 =?utf-8?B?d0UvajIvL096V3lqcVBxNTJFNUJ4MUdoeVNWb0tMcFRTZ3FDaGNJdU9Oa1hQ?=
 =?utf-8?B?QWtRaU5GVjh5UFN5MllnOW9BNlRwZ3J1dlFPWlc0RC9aZE8vajNyYldlME9z?=
 =?utf-8?B?ZGNteTRpT056RWRJeWJVdUQwZ1JnL1pWazRTaEhCRkpxSnBUR1F6SE81QjZy?=
 =?utf-8?B?enRVYnduSElURkVwRkVrTGlsNHNQcmtSQUR2QTBYMk9iWUJQMC9qZGVlZjQ5?=
 =?utf-8?B?NzdBdTBwZEpjWEcxSWwvcElESWdxZXlOU2duY24xK2diS3ZSaXNFcUVzclNo?=
 =?utf-8?B?Z3B1QzN6dG1sT21VVmRFTzl0bHZwM0U2ZTZic1p2OCtvSi9OQXVpTExBNEM1?=
 =?utf-8?B?aEk1N0dpeHoyd3VxNytIMDF3V1p4aXBQVGNwY2hjUWNVck5UZWJrTDBpVDFX?=
 =?utf-8?B?MWttbExXbXkwWGZUbUorTWVtSXBieTA1ZVdUTHQ5RHMvcUNhZVB6RVJSOEY1?=
 =?utf-8?B?UU5ZTVVUNHdhMEZNYzV4NkRHelFFaFU2NUpxZGZJaVR3VW5MYTF3QUhBRFhO?=
 =?utf-8?B?czJUQm8yUUJhVmZxV0lINXZXNmhyZkdvOHhUcE9JaGUxMnVrQWlrVklvTzd2?=
 =?utf-8?B?ejF5MWF5dEtRL2pUdmwrZ1Nmc1pmKzJYSGVjNUMzUE9oTEVvYnFpZE1lakNs?=
 =?utf-8?B?bFVJSHR1U2N1ZXFuWHQraVNzTGxtSkxTV0VYVnRvR3JYYms2dXd2V0RTb0Js?=
 =?utf-8?B?NVJVV3ZSWUtXVHZWUFB4YjQwdmhqSnRCZ1Zqek5DbEpaNGQvQ29kZzJzZW1z?=
 =?utf-8?B?L2JRM2hKdzJtZ2RNQkl4bGxwcmQ5NVZUUHpCTzNSUnoxQVUvQjMvTVBSOXZv?=
 =?utf-8?B?bC9abnRSaU9NeWNIREFSRG9TMjNpd3NNRDZEbHhFT0l2QlZoV0FmOUNydnNL?=
 =?utf-8?B?REtaWTRTMFZ3Qm9HaFFDWHE3MmhpbU14WnNmWGU0MWZOemZnN0F3QzN6Wnhj?=
 =?utf-8?B?bXlYdHlGS1hZMzU0RUNzMGlrL2w5NFNvdTErZFJTYWJ2S0xsZzEyNUl2UENC?=
 =?utf-8?B?OVFCYURXWlVOYk0wOHVHME9FdzdMMGlCNlo3OTJYQlBGYWpTTUxUNmd0THJv?=
 =?utf-8?B?NHRkTlNvaWtta3RQbjIxbGpJa3Zuckh6Vnl6ZTE1aDUwaUFibVplMWlrREJO?=
 =?utf-8?B?NkpFcTZUQzVyalBBWVc1azNVL0FxcGJZazlnWThQaU9ZbDJUU2hTS1BFb2ZJ?=
 =?utf-8?B?OEFIdDl6UjJPSllkUUJKVkhsdVgza2gzNXB0dmdMWXFRUUVUYnlURVhKLzNP?=
 =?utf-8?Q?V8pJyuc0bzSZhM05GAgJsrZjnMooTA/V?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?d2lrbENxcnpVanFya1NORXBtVjJseFZvOVVzOE9RM1RIb3hOUFA4QTRDWDB3?=
 =?utf-8?B?aVBEOXdXRk9LdzR5RUFpL3l2MUMrZTBVaXgxd2hHLzlVYURFZ2FHUVVocXAw?=
 =?utf-8?B?S082aStGR1g2YURsUjVhd1Q3aWNrSERuMjJqSVpOcC9QRXJQQmRLSEZzSkRP?=
 =?utf-8?B?QmlDRnY1dlpsU3JRZERoQkQ3ZHpUakgvK1ZhL3kyTkVYandkVXQxQm1Wc1RM?=
 =?utf-8?B?UTNhMDhGeC9JWHhQS3MybHlMMnprTFNjNU5ldWdZV01ZMTdQYTBCRFBzeFcy?=
 =?utf-8?B?cG1wSFJZUWdETEI4RDF5Y1R2SVhTQk5uay83bC9xTCtMNW93NmV2ZnA0bW9x?=
 =?utf-8?B?K2cydDkyNktNajdtbzU5MG1lOUI3d3RKVE9GcjM5SCtpNlkxN3h2OWNFSktF?=
 =?utf-8?B?aDVhcDUvRlRUa0lNeWJNVjRqaW9TSmZNS2FjOWlvNDQyMllUb1J6bTBhOVpL?=
 =?utf-8?B?S0cvVklwWExoNjJCdTIwWEsreTZsck9qcUllY2lkL3NHRmNmaHRaK2Via1Yr?=
 =?utf-8?B?RVUxQkFpdVk0ajZsL3lTdVZRUnBmRTVpMXlhYlpOajRHWVlvbW5FQXdlZ1dI?=
 =?utf-8?B?b0lSa3BQLzAvM3NXQ29aaitzTmRmYTNwdmJuMk9MR2E0MnFneFBCVnVEQURj?=
 =?utf-8?B?Z2QxdFZEVFBaQm03KzBPVWo4ZnpBbE5RK2pFbTh4QWx5RUlTRzg3MXB0cGc0?=
 =?utf-8?B?Q21LYW1CMk5HQ3FjK3ZJYWdxU3Bqc0N6aGhIWmFRdzdYeGFjZUM0RlZoTjJ5?=
 =?utf-8?B?ZjBXUVpnVUJOdGl2dFU3RHhiVjJqU3htZk1WRFB1Z1JVNFc2SHM1dXd1Q0Uy?=
 =?utf-8?B?NHhkMEY4VjVVTTh4dCtIRlg2OXVpMzZES28zRFh2L3JFOHF6eUg2QmxEa0ly?=
 =?utf-8?B?eWVMUmF5bmc2N2w4eHREOXhWd2tGRkV3YnVKSDJISnRjS0Jwc254Rm5SRzNU?=
 =?utf-8?B?YmVMOWlrakRTbFFNNW9IdmNKL2dUMWFWNjg2Y0NTYlIzQ0RmM1FCMUdnaXA5?=
 =?utf-8?B?WG92L1ZLRURnQnEzK2xlSXlvODBqTE4yYnBrTmdMOUFSalZ1MERXUHA2N1V4?=
 =?utf-8?B?TzlQZm5ocVB4TXAyck11d2tjYnNHdGdXZk91dVpFUWNiSm05UzNGbnByRk9s?=
 =?utf-8?B?VmkzdVNtY01MZ3pybkJqZlVDei8vRXY0b3BaUVVLMlFzeU80VUxuUkd2bzJa?=
 =?utf-8?B?VXNWMFkxOEtRa3ZFSWVBS1h2SkQvMUNGNlVTK1ZSbTQzRFcxY3ZTbWhXNXJY?=
 =?utf-8?B?R3BaaDhpTVNGdXJ1dE45WDNvSkVNYmZxdVJONzZLL2hLYVE2bkNaRGJBOUVF?=
 =?utf-8?B?cVFyUy82YnBMaWZZZnZvcW1KRldkNXVIWjZEWjB6b1ZzUHM4Z0ZTK3ZVNzFl?=
 =?utf-8?B?dnVBY1NUNk1oSHFURDU0UFM2d2VQMC91UkF6WXg0bWpDV1NuUkt3UGpBSTlu?=
 =?utf-8?B?Uk9sSW1LU0xKWm1kelFBc2tKZTgwVnRXQ2o2dHdOb2FraEt6QldSQ1Rpc3NL?=
 =?utf-8?B?UW0xa3dMOEdhRTBzL0FMMDNhMnU1bjlyN0tHc01jQ2pBZUZiKzVyVzRBQ0tx?=
 =?utf-8?B?WHBBcWtzMldTQTZBY2Rtd09Bb1VPODdnZjZudEMraisweWxUNDB5aUJpRDQz?=
 =?utf-8?B?elo0c1ZaVGQ5MkZDTmJnUnA4NURQUGlJSlhIZTdIZzQ5eUc4UGQ2SVVFa3BY?=
 =?utf-8?B?YXZmS3E1WnRHaDJTYlNjaG4zMlVnU2twNm02WlpOQ1haM2wreW1WbmJ6UTVQ?=
 =?utf-8?B?ZlNhL1ZzelRDR1NJZEtrSTlSaFBhVWlST2poS3dTRVovR1JERjh1NlA5Y1Ay?=
 =?utf-8?B?OXZpQmszUXg5NzZPRkIzU1lIdktjK3NLdUhPUEdaUzNGUHdvNHBtTGhmT1pQ?=
 =?utf-8?B?U3F4Q3I0blJubnJnb1hRNk9zVkVSVlJ3cWpvUGVzTVdMVllvU2doNmZlTVQr?=
 =?utf-8?B?N0hTQjhvL2xyb3ZNT2N6ZXFxSUVRcEsvTmlla0tzeFRMWWJFdWRvSnh3TDBW?=
 =?utf-8?B?UUhRMGR5QXo5NTlJc0FsWkdycWtjNGk5dGs0LzhlQTJVZHhtenpwL3JxNTQy?=
 =?utf-8?B?cEtBWHJ6TUJoK1lsMDN5TzlJOTlzVDlITUtTWmVkcGU1UVpBM0NvZ21Za0Z4?=
 =?utf-8?B?K1Jxb0VFOThsY0hLbWJDMHhZY0cxS3J2Qm1OZlA3bFl1YWk2Wno2UDZTQUlJ?=
 =?utf-8?B?MlhEalpUNkZHajZ6ZTlkL01mRVpJVDExaFg0OVBMQWRXVWsyMnJBc1MyTVR3?=
 =?utf-8?B?cXB3bmk2ZzIzM20vdy9kUDdMc1U3ajNXTVZGbDNhQ1pUbGtEL1FMbUF0akxT?=
 =?utf-8?B?cG9acm55elhtR2FBZnRUZWl2LzRRM3pnTFZ6UEFRYnkxS01KWFZYUT09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 70ac0904-74e6-43ce-2e22-08de4fa48036
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jan 2026 17:28:27.8794
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Zq3eqBdkaiFswv1oHFTWkyl/7/gH6/KGpOsdr0313tXV35oI9S6lhayJ80r28a+3
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB7540
X-Stat-Signature: 7ty5593m1fhnjd995g95nhykwj1ntwgq
X-Rspam-User: 
X-Rspamd-Queue-Id: 11D3BA0014
X-Rspamd-Server: rspam08
X-HE-Tag: 1767979710-208931
X-HE-Meta: U2FsdGVkX1/27dt2bbuzetSj4Nu4bGxFFyk8IxOyYkNjPEek2ujXCngkvIP6LZVATKfXH/e2gh9vWdQbGBvMCah8+Uxkwqslk9aksYPn5UJ78GwHSKLFML8YDrXzXX4NVt+IUNQRsxdf71OcUhI2gxydz0BhhQX6o+r0BH+ZO0h7Mzw0VtxZBiTDQFWefIzGYhrjV+7SZVNIaZaWSQjIjt2xOOdTjSUXJu9NGRYvLDTLVyeewNerMBtoaq/vGrcH1cfzxove1rUgCbsZuSAwiJrEp8aty8PNCz2LlBhKBHZmFQWKIEJsyId/ubjORopPefMQQA+Kq+i0mmlel+1E1XBmcDUfKhf42i6Cgi+krfdHJB8sN6Bdj62lfdPMTIotyWqND+r5nUKl3tp1ycjgSzPag/00BsJpjS6ZNOeqegqoeldh3fek7fFeaeZtowA+U7PGiu2fJc6HFgRn2rV7uK3PjUjTxRfK0YpDqU8CNeergnC1WcUJuuywHePVbgXYV1V14OYDwThaEvXuASjQ1dChV2aNJ8HYZh9QPcpDpyy71hmbQg1v/IN6DU4QYt4RNl1TDx3b4cL3mZAFfEWnmYNAYDWJqe5p69FNrPIHYz8AhiRcjky8/t9boGoisZ9+oZmeep+9zFytyzUv7wZjz7QRwDZQWMv12BgJ2jK2TAe8Q0odXq8QDUc3+tx/DArTHf29Q54PH3pkJ8kBGkTOHJ72QBaO2BhVnLK9q+a3p1YmStWWKo88KjjRG5UfAYC7TMMv5+we+I55l8JMf3UfTj7dLdUwelsPs7T8reuo5z8HerPLpfDk4U6Z/K1hfiwZEoOgbN9Ck6rsXXXBD65BpWXkxFAoPaOFfEwQE3ln27Eg4nPGbkLlJaXqWuOddsE/Ca+K8/Q6oVRZck6KgLGRqtAQSgN8+wyxUBO2kuM8nPIuydu869erfemL1P3lSODu+s+k8x1wHJLdSo/DG7x
 1htdMM36
 ylqBd6e9Yv3jSv0NQYPB2296Fb2gwKs/g615/nnnF5YsPHm1A8Zik+5vztOyZxbxBPvVGkUb8eKuLxsoP1sIhpFB7z+UEtP7jT93SwL53RP8Vfy+z8RId+wRITZ0ecG1WCWOrAkLbOo6PWNrJq3kaLSvaLvzn075/vq1D5eeP4u2f9iX+CodWhqppuQ+O3gNo3znmEjWHMEt676Xtw/75GrgbFpCVp4/NoXdjZ+KwlOPdEXFsiKdvEjbBOzhJfkOQJq/uRwNtMVUeikAis9tjPJinaZS2pFe8WdU17aX12kccq6ibc/Ro6myADY6SwtlvYXKAFMh8MvY1xFOM3qKxpaz0FSkSn+AVd/8s5jyWvl1Ade5FqSjA9JCc3OS+f9nVCUXLpivWakS0eq9Vi6rDr3j7H1uaks8lCxf8LD/rmByH7fkropN0qygF9KMZ2NAhdC2WS6nRspSp21vBf12X44NapUl8uxxcs4pyGbypEoXlabizU/aecWjsJzGV8xgHr5tI0kfpX5WwJuGhHJR3LTS/bnLkXb0+ZVUwgRcTjuHI50baQ9jqX9t1uBkgdsKDx8hDz7X9y2RRwB+WtJu41i2nhg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9 Jan 2026, at 6:09, Mika Penttilä wrote:

> Hi,
>
> On 1/9/26 10:54, Francois Dugast wrote:
>
>> From: Matthew Brost <matthew.brost@intel.com>
>>
>> Split device-private and coherent folios into individual pages before
>> freeing so that any order folio can be formed upon the next use of the
>> pages.
>>
>> Cc: Balbir Singh <balbirs@nvidia.com>
>> Cc: Alistair Popple <apopple@nvidia.com>
>> Cc: Zi Yan <ziy@nvidia.com>
>> Cc: David Hildenbrand <david@kernel.org>
>> Cc: Oscar Salvador <osalvador@suse.de>
>> Cc: Andrew Morton <akpm@linux-foundation.org>
>> Cc: linux-mm@kvack.org
>> Cc: linux-cxl@vger.kernel.org
>> Cc: linux-kernel@vger.kernel.org
>> Signed-off-by: Matthew Brost <matthew.brost@intel.com>
>> Signed-off-by: Francois Dugast <francois.dugast@intel.com>
>> ---
>>  mm/memremap.c | 2 ++
>>  1 file changed, 2 insertions(+)
>>
>> diff --git a/mm/memremap.c b/mm/memremap.c
>> index 63c6ab4fdf08..7289cdd6862f 100644
>> --- a/mm/memremap.c
>> +++ b/mm/memremap.c
>> @@ -453,6 +453,8 @@ void free_zone_device_folio(struct folio *folio)
>>  	case MEMORY_DEVICE_COHERENT:
>>  		if (WARN_ON_ONCE(!pgmap->ops || !pgmap->ops->folio_free))
>>  			break;
>> +
>> +		folio_split_unref(folio);
>>  		pgmap->ops->folio_free(folio);
>>  		percpu_ref_put_many(&folio->pgmap->ref, nr);
>>  		break;
>
> This breaks folio_free implementations like nouveau_dmem_folio_free
> which checks the folio order and act upon that.
> Maybe add an order parameter to folio_free or let the driver handle the split?

Passing an order parameter might be better to avoid exposing core MM internals
by asking drivers to undo compound pages.

Best Regards,
Yan, Zi

