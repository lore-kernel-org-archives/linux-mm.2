Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 71C01CD4F26
	for <linux-mm@archiver.kernel.org>; Wed, 12 Nov 2025 23:56:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AA9DB8E0006; Wed, 12 Nov 2025 18:56:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A5F878E0003; Wed, 12 Nov 2025 18:56:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8FA968E0006; Wed, 12 Nov 2025 18:56:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 7A9358E0003
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 18:56:10 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 27D6C140742
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 23:56:10 +0000 (UTC)
X-FDA: 84103616100.06.C1AA033
Received: from PH0PR06CU001.outbound.protection.outlook.com (mail-westus3azon11011032.outbound.protection.outlook.com [40.107.208.32])
	by imf06.hostedemail.com (Postfix) with ESMTP id 32D37180005
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 23:56:06 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=KS5CChao;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf06.hostedemail.com: domain of balbirs@nvidia.com designates 40.107.208.32 as permitted sender) smtp.mailfrom=balbirs@nvidia.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1762991767; a=rsa-sha256;
	cv=pass;
	b=x5OgRB3SyJRbYnbjfQnlqyQya/YdiGouPBShLUK+DpAiOoMeDvx4+zK7WKfy2YJJs1YgzX
	CvBvtAZ+6ngtjdzkq7/AG6zMktqG3FEJEQOi/WTfkOtSSC4qXkRHDLa1JdcZxWGCOewqHO
	xsF/evQIj0BCivJX67qFTayM/ZByzj4=
ARC-Authentication-Results: i=2;
	imf06.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=KS5CChao;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf06.hostedemail.com: domain of balbirs@nvidia.com designates 40.107.208.32 as permitted sender) smtp.mailfrom=balbirs@nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762991767;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7YuqWwYa5dhHzE4L7hqNgjOWrJww9VqejAkhY9DfJ0A=;
	b=comQ7QQ8+XotdFaYlNGDr43/Yu5EeGf/kO0K9q1lWoZVOOVyo/bxdBlbq7JIZKw4hzH12l
	hNdEcADOX1+tH5zMvPg5jG4SNSWMdyP9ZV6MoKhSocNZghnhliiMRdqqlM2tu1OJT+NBe4
	0vKEqMfEcKPZhyUowfO68DOdeyBr9ck=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=TcqdXuworCjKZO/2/aNGfS+1BYOJAF5X38G879h7+2Jw3ASgv2lrsbnCx90ntMhdopJ+VJr0StDUuJmDjgvUh4+lKCT1E1IkN61PdKwY1wKhEkILd0OHydI5MsXwqkCX/3TBRQzvRrliQLH0Ix2fpCPpoiYq6lkg7Ui57toTWXe2Rly/T7hsxmxF4SESAd8pSAoppkLj60CjNMLvV4wgXFf3khdvXnXVw1E9ghWXnxjHbuNIrBuzOVDJQhyyMsIXRGEdVeJWcjPNtHZTHEeMntuGWgkLwBkBnxpGmJYK7Xhv1Sh8DjJ0L3ZrxVRgBYTVkSQwL4jOUYU/VIPwq6biMw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7YuqWwYa5dhHzE4L7hqNgjOWrJww9VqejAkhY9DfJ0A=;
 b=LE4TzrcwquvTYnPV1zDWJychzkAEUd8IxkpYZyXv6lnkW4eLCHBzLwoq9GWJ1lQ9ukrcddyPMqlayTOhtDdFmm3OEKIIosGA0DWY+Hyz2roFlkAJS7iSGtaFj+UD69Svz16vewwxPpyjzgUMziAmaWjRKWDmKg6W3yvlOj7akEVpykoT/LFPw+3GFShjfS31rw8u7Zg7qt7nqcqFZ3iWn/XVcZk4R1yAoIu8goH1+uSxhNjlCkCeogLQNM/S67aqi9yewvg+j6ICb6yk2qWr7ctiJ+vsMWsBHvq4WyG4aCviHvMeNCseNsE072VOfFb61qLqkz8Vso4dhIzpAoKG6g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7YuqWwYa5dhHzE4L7hqNgjOWrJww9VqejAkhY9DfJ0A=;
 b=KS5CChaoXwm6L0CDWI5vk01dQaZw6rRvcITN/+TVDWKUSFjf4ycVCRqNI37hqot3S8ppJW+Iq8OwazeoYbxu8XNDxeGVRLYF+0jArDSbvBk4CKupEVxzBBJkzAp0gMdhBXaX6ySoSFC1glZ1HvNGhSh/tXjKDrxAU59UELkHXWv+9vJRJ6KmjT2sug+gtzQW/lAyZ+GCLXl87XwW69UlLupnbcmsb6wLu4b9o1Hq7hDbZtYapqwOV1H09008TqW7BbzXigbKnBF71TvXNBikjZx3z8ewzvjAvN+OzY6LWwp+U4Y0J/5ha6ECcXTaqQxvuVlmNpyKkVZFq9CaKkh/nQ==
Received: from PH8PR12MB7277.namprd12.prod.outlook.com (2603:10b6:510:223::13)
 by SJ2PR12MB7896.namprd12.prod.outlook.com (2603:10b6:a03:4c6::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9320.15; Wed, 12 Nov
 2025 23:56:02 +0000
Received: from PH8PR12MB7277.namprd12.prod.outlook.com
 ([fe80::3a4:70ea:ff05:1251]) by PH8PR12MB7277.namprd12.prod.outlook.com
 ([fe80::3a4:70ea:ff05:1251%7]) with mapi id 15.20.9320.013; Wed, 12 Nov 2025
 23:56:02 +0000
Message-ID: <12f21140-15b5-4354-b3fb-f8c96fe6c506@nvidia.com>
Date: Thu, 13 Nov 2025 10:55:57 +1100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/huge_memory: softleaf device private fixes in
 remove_migration_pmd()
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 akpm@linux-foundation.org, David Hildenbrand <david@kernel.org>,
 Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>
References: <20251112044634.963360-1-balbirs@nvidia.com>
 <20251112044634.963360-2-balbirs@nvidia.com>
 <c5ebefad-2b1c-45c1-9a82-17a024d52d1c@lucifer.local>
Content-Language: en-US
From: Balbir Singh <balbirs@nvidia.com>
In-Reply-To: <c5ebefad-2b1c-45c1-9a82-17a024d52d1c@lucifer.local>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR01CA0064.prod.exchangelabs.com (2603:10b6:a03:94::41)
 To PH8PR12MB7277.namprd12.prod.outlook.com (2603:10b6:510:223::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR12MB7277:EE_|SJ2PR12MB7896:EE_
X-MS-Office365-Filtering-Correlation-Id: b5661a84-319b-4e94-268f-08de2247092e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|10070799003|7416014|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?S0IycnVheWExQWN2clpXQk1yM2UvR2djbnZxeXVaUTJ5TldVeTB5MHpOY3pM?=
 =?utf-8?B?eGVZR2xzZGdrUVBnQlRHOTh5UmtXS25EM1BKekhSRWNrT21FaGRBeTNpaDN1?=
 =?utf-8?B?eVduQkVPRGVPVWRnNU1FdHA4eUlJRm9YbUxSU3FjSkdQMzRRNVRDWVhDUHE0?=
 =?utf-8?B?eFZsd0puVS9DSUhyUGNDVWNjSFlORC9idDdma0RENURHbWVCMkJzNFNVZDJN?=
 =?utf-8?B?SFVJdkdlNHBESm8veWtWem1Ra0dzS2U4aURPb2ZjazU4N2x1bUxtWmh3bVZO?=
 =?utf-8?B?dGdQbmRGWXRITXZWTWpiSmlmMnV4RmVaSUE5Q0pZSHNGZU55NXJHQ3MvY2Fq?=
 =?utf-8?B?NXIzSndIYVM0UG04MFJRU3FYb1hXMkQxN0E1bHJJUlJCTms4MTBhUmM1b254?=
 =?utf-8?B?TW4rRTVnQ0RKL0ZjN1FkYlU4aWFTSUxKZG0yKy9DNHJITDRpNkkxNGQrUU54?=
 =?utf-8?B?NnlsTDRmNmJReVdoY2JqY25oQUpxamNxVWVLenV0ZS9iSDZqUzNCRW83azUx?=
 =?utf-8?B?Q0toUllnQXdZdkJYSmF5UGJhUFNRTlRxbE1XRTJqcTlsbytmSTYrWE0xUDdL?=
 =?utf-8?B?M3BoRjdDelV2NlVxdzZKaVFuVTlXdUVzS3JCVlB2MWhQMTd4RlFZd3VFMXJ3?=
 =?utf-8?B?aGVuaCsvUUxaTGZ3SnpzOTk3TGhTZ1cvTWlvN25sMnAyL0hTa0xQbm1WMlZ3?=
 =?utf-8?B?MlprOUd2WUxYOUVuYWFCK1l4WlNCSWw1YVN0ME8xUTQvU2hWekt3Q3NDeUU2?=
 =?utf-8?B?QVVkREdPMkZvd3g5RU44eEVmVGxabkpmRC9lbGVmMWp2bVJaUmhOMytySUw2?=
 =?utf-8?B?RkZ1bmRWd1ZGSUJVanN2UmFnMG5lRm5yRmtDRllNTUdpM0IxMEJQYnpoV3Zi?=
 =?utf-8?B?eTEyaDZBb3E4K3ZVZTluajNFWGFRNUwzeUdMQTJMUERrZmJCc3lsVE84ZGpF?=
 =?utf-8?B?cFFSbkg4am40czRxUDR1ZEdmYlFnRjdGUEhjS2x5dGIrY3A0YzhJSTREdlVI?=
 =?utf-8?B?NGRzUGlQZ0tIcGdEaVV5SUQzTUhtenNRL1lIZGFseG5lMm5qY3F5bVBwbXcr?=
 =?utf-8?B?bXpCVHBIMzNwUENFdURlWHZpU00zWGVkQVdLbG5ITGV0ZWQyOEZ0NnJZaW1l?=
 =?utf-8?B?OURMblNCK2g5Ym5sNVcwUlRaWEpTUWRtNVpsVlBJWXEvNnFqVWJ0M1ZVNzF1?=
 =?utf-8?B?U2JiZjdRMTJxNFBSUWN5UlBSY1hNOXdxek5WVGcyUDFTN0FkTU9qUCsyMXV0?=
 =?utf-8?B?emNOWGdWSHFtVzRYL1BPejUrbE93NlQ2VHl2aEJXSVJ3Unh1Z3FHbmpPcW5s?=
 =?utf-8?B?Y1dJMGlyb09BR1BSK0p6TmV4VWIrSWZsOE5LVGV1R0pqUXlXOVhRNHBEVFhX?=
 =?utf-8?B?VVpGd1hJdStOcytueWY3M1lkWXU5c2lVaHVwSlpNeUx2RDlOYzc4d0Vsb3ow?=
 =?utf-8?B?Z0FMTWR2Ly9Jd2xsNmNDT1ZEdC9yZU1PSmlnSXV5bDYyanczRVJzNFBqc1M0?=
 =?utf-8?B?SlZJU0FCdGwvbElST3VFWFErZ1htc283TG5lUjhRWTA3Tm1wL3NOcVB3eUJC?=
 =?utf-8?B?alVza1BkaG4zU1FGSHQzemcrVnpKQlAxSE9XVjRlZ0xaVjcwWmF3NldoQUtE?=
 =?utf-8?B?WGlkNHBUVXRWUE9jRVFBclVTM0trSGFuR2s4dTh6bGliOVZqZ3A3V2k2MHBW?=
 =?utf-8?B?THJSUlQxVjZYbHQxSjhnRXZMQzV6OTJXdzM2NTM0TTBQeXdIMC80R09NVGJi?=
 =?utf-8?B?YWlqY2NrZGlHaGw0U1RSYngzTWZFcThJUjRneWV3V1Q0KzdIN3ErZ2g1VmZ4?=
 =?utf-8?B?SGVrczNFZnJsdEtickRGRkpUdDhmR3ROQlEyTmMyTnNpMHBvSmtnVHduQzl1?=
 =?utf-8?B?QWxFTUJlb1lTUTY1N28vTXNOWTJNY1JLbSs5SDkyOVZLVTJMUUlQSUVVekFn?=
 =?utf-8?Q?39X7EUF6wPJx1L3jx66qk1iLkkYTBpoD?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR12MB7277.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(10070799003)(7416014)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?cWkvSFNjbWx3TmpxSnY4YWk2QjQ0RnBxQ05jVldIVXNMODVBOHQ0bVcxL2g5?=
 =?utf-8?B?cUFXMFM1bzU0UEJackc5S2pMaE5xaHVwU0doaXpZWm9nenhRaVV2djhRY2dx?=
 =?utf-8?B?dXZWdGdMMzBMQUxaaTFiYURYZDJSbDJLZEpBcjZtV3duYWQxTXcyT2xvZmdV?=
 =?utf-8?B?VUxlbkZ4TGdWN1lYTENyQy9sRW5QbFhCM2lCU0FOWjJvTktYQ0UxRDN5eFZT?=
 =?utf-8?B?K0pGRW9keFFaMC9CRmFjUk0xNWJVa2dpU3dxdUlNbTIwMVVUN0xrdnAvY2FL?=
 =?utf-8?B?L0pFeDF4WDJEWXFoTXJuaW94RVZjY05KNlJvSkV0L3daaVY4OENyV2Y3SjZ0?=
 =?utf-8?B?am84blNnSHhveWRwaTZLWFducEJCMGYyV1U3ODdUT2I1NG4vNGsweDljR3Fl?=
 =?utf-8?B?ZXVGWldjNUtsMng3eGY3dDNDNitKQkswSGZzeExoSGFwOW8wUkFLRlRnSzl5?=
 =?utf-8?B?THdFOG13UVk0WkxDTEU1QkF1ZjBOUmRhWTh0MVlLYzVRS1I5WnU4cE1IcVgx?=
 =?utf-8?B?QVpDOGlsbjNpWHh0YU8rNEFrdTJIbUNZL2xUdHp6WGViVURjWXJxUGhucG5G?=
 =?utf-8?B?UWZWK1phZVo3RHl5Y2xUcE9WY09Hc2grTzhXNTM0dDNmajcrUU40YTV2ZjlB?=
 =?utf-8?B?eXlpbHVteEpWSEpkcVpqNCtDdGx4amdaVk43TUV0Sy9pZXhSZTFnNlZKQ0sw?=
 =?utf-8?B?V21kOE5QTjdNUXV0NUphWTlUU1YxQ0EzelE5dEFaZU1ucGZwNXlqVWVxZ2N4?=
 =?utf-8?B?cUxZaVhXaUNnK1VVMUwwdFR6U3dIK1dNQVBwQkZoM3NpbWg3djdUcENtN1A4?=
 =?utf-8?B?RnpYZnhVN1BlSmFXcHNpSVkrd1J6SUJWVE5xQ2tDZzZDOUd5QlVRWjJNb3Ft?=
 =?utf-8?B?cHhNaW9NdmtlUGZxUW56RXhOOElMSzA5WWdaendVQ3VGODhyaDdpREFYWkRX?=
 =?utf-8?B?QXNISFhIb2dyN25zcnoxanRmWjRSUWU3Um1nemNOZmxzTDB4eVpLbUc2RkVR?=
 =?utf-8?B?Qjd6UXY0WG1YTjQybGsrMTRPbllnUDV1alBiUUd0T1IzV3hyNGpiTnVLQlRX?=
 =?utf-8?B?ZmVRc1dZSmpMUVlzZGljQk1lWFR6U1dWbXR6VGZHdnhBeU9pVERaaE1MZVBI?=
 =?utf-8?B?bmVZNEQ0MlpKajZIRExwbndxVnh6emJNTEM4ODRjQklMVTVnTGRnQWNVOVZy?=
 =?utf-8?B?amQ0K2R0WXljYVFoeWxDSkppdnVUeUplRGJTeHM1emd1aEJNMjFnZ1J0Nk5s?=
 =?utf-8?B?R29VU1V3dXRrSkEyMHQ4TFNMSmg4dVBtRlljdE9KSWRXeU5pQ085OXo5UjBp?=
 =?utf-8?B?ZktaUksyOUdlY3RGSFR5Yi8wbVRMcTY5RVZyWnh1UmlJRWZISUZQQjN1bG0z?=
 =?utf-8?B?UlVyTnNZZ0ozWElNWW5TdXd1ZGxtWjczNiszUFJNVDNJeDczcElnSzErU0dx?=
 =?utf-8?B?NnlNcEdGcHNPL0ZYRnZ4a2d1SHlmMjJrUDJxcEJ5eEtuc0c3dTEwSmxiSFJJ?=
 =?utf-8?B?ZlJXM09wV294c0ppb3dnSEVHL2ptY000bUo3eEVtRmNJTE5RTEpkLzFkdFZw?=
 =?utf-8?B?TTREZmYvLzUrVEJsekJMQ3ZmeXk0alowRlNCN3haQmZoWjRack0wUmxhSTFp?=
 =?utf-8?B?KzdMVTlCclJLMjd3dWY1MkNTeUFMZHVHWEpVbmE0cXZoYlJ4cjRuWm5MVUg1?=
 =?utf-8?B?L3RVZWRIbm1kUk9xNXlhN3BKdkxXVTNvb3Z4cE44TWxQSkZTYUJQazZlRER3?=
 =?utf-8?B?SE14S3d4b2M2R2pBb2RyOS8xa1ZrVms1MWNTcXczK0JnTnZVdHhPRmV1TDl0?=
 =?utf-8?B?NXhQazZMc1pxYnVCNjVEY0tVd09yR29WazdYU1FhSHFOQmNVT2RoWEtGWW4v?=
 =?utf-8?B?SkRINmJFVXovS3NMdXB1R1l5bEVVdmpmSmI0S0xvU2ZHbXRQWFZoSGY1YXkw?=
 =?utf-8?B?WHZ1d2xucXFvRUV6a1BaejFmWkl4UkIxcElCUVRnaEVJZUgvMXI0M3E5Qi9K?=
 =?utf-8?B?aGphd0R4N0lVdGh6bXZ6bWc0ZTVtWTMrbGtta1NDZ0hrdEszdE1wMFphdEpE?=
 =?utf-8?B?U3owVzExUG1malE0RVgyN3hQVzNZNmgzM1R2KzVNdWVqbFczQ2g3MzJMQkQ5?=
 =?utf-8?B?VCtPclErVHdWK3VWS1hDc21jK2pPN2tCZ0NYQUJMVGp3Zzl6TXZRR3ZJaGlX?=
 =?utf-8?Q?ZjvQebgiaYYsqgGjfG/OQwYFkkK93I2GWcuibTxqiUaT?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b5661a84-319b-4e94-268f-08de2247092e
X-MS-Exchange-CrossTenant-AuthSource: PH8PR12MB7277.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Nov 2025 23:56:02.8330
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: sRevp7R7FizBSTRpqximiOyzmYovF+QaedwIcmLF2NYGvKS0UcA9LObMkW13JH/lqgSvPSMfQIlwO9mG0SwB7g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB7896
X-Rspamd-Queue-Id: 32D37180005
X-Rspamd-Server: rspam07
X-Stat-Signature: tdaypkwd53b3iwwb8yywepfucxf55nwy
X-Rspam-User: 
X-HE-Tag: 1762991766-542547
X-HE-Meta: U2FsdGVkX1+6Q3urrd26NQMUU0Z0oFB9rCL7aGCmrMt4ZNRaPQjJeul76z3kN8An9rJ5wBzgMQREFiyMkClAKqHVfm6KFMV3T4m+L75PtxKzZko9qT75+bB+uT2nXjZOH3h/AxbawcPr1BqCQVKXx2QhmgRiI3IKgSnmjhm4rUyz4+qpO0i/cl0wEdv4k1xbcADPQVL26T6F+0nwEL49mxWQQlr544dg7LnddckCg2Dgheqszzg6spri5u6rtvPeXK9KADA6U/WDbNW9P3tfr4TY4UpK8K9uzfGjBk+QBCKKnKoUkKmVlawLBndE9ENTGzCw67RTQjrrh6uTjxutk53KWqSNuT4Ws9j7UT1Rp1rS3/SGnbzK13yOlDrGTqQrNrs+uQSMVbxynPuSscfY7BwBL3AR9jv6AomwMfhwJY9T1Ussqyr24huMfKC+FMUacHfFC92Oi4U4RPCbsstjnIf3gdRtASPECMiP5tJFArhbdccqJTsfM74Tna6YAtmC7u82/APjmPVdTxM3jbTjykFYoMgLLJKRU1f//xFUPHbds0kYQpwcdru1Ca7Lx35rIqZ1z3KPq+sMOexokSuIhy1P51wXE6bfii8DkRxjEWkUoVjTDriMGVZDfKAmvGjyEKOuSVGYyqMyMSAVH+UNDtyc6hR1/u+b9NLz+Dk9s5WhBhyrrNIjQ85F3tbxgphxbg+z5Q9NsLsJoX/Fzutd/7txWkqdMh3Mol/E3pXN6P28V2We2BDfySNaQ+ZWNip33sYU1OrXoXewlaEZvOGNg1W/mQm7p+T+LKZEgWvDs3MBJ4+I51/oQaLBdV0iwaODvdaL2RZiR+Dp3IrM6WfyGLAMof55Dq9mz4Srno6fATbiu4bRIW3bOMw8I/64qg1ocNaVYh1QE+5kuAEorHHSnjqRv0kySznUa00dJNhzAzv+d8j6A3SEiAxrS7xoNcyxr5EFeAKN/zsDYDsscr7
 m5CYxQiL
 lXJTEcsJRPq8Rbar/QbQJKV4KJAcDLr8zMAVQhPwN8LWZYInsiaGTvO4Mkcp2PgYJsr0h6Pu6fRnYwViztIIj+v7uCAIA77PBoviPewGrthF/7vme5Gz72+9IHqIG1FVmM8W0s/SaVdBQEzXReKIR3ebJsxsRULLy/JrMbW9nPPdICdNy9GeE53+GQrIRdtAIpIZwr9SVVDPJwB+2vE+0xgrMNamEy44tL8q2r5uiRS7VKKykdK04BCXgpONLxIWEdU/7QT/5pyXmlr2PJR+INw37Pr9+crJRnBs0yxCyNDGPRGtmm3NBq+t8fd2w4GwKALLao/yfp0uBB+XagIOLqR916smgyr5uDfFW5q5Ql4C1Dj5vSgNDbmKpaBHfcv/iPOvpGZYbxyGw0xtkirmtpfgQy5J/9R6p521l+tj3R1JGBedMWoBENwAvAigbgxrP6GwU9FbZdROr+T4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

I noticed I did not respond to this

<snip>

>> +	/* NOTE: this may contain setting soft-dirty on some archs */
> 
> 'This may contain setting soft-dirty' is confusing. 'This may set soft-dirty on some arches' perhaps?
> 
This is the existing comment and it already says some archs. Am I missing something?

Balbir

