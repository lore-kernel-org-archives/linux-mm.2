Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 51CABCD4F3D
	for <linux-mm@archiver.kernel.org>; Wed, 20 May 2026 15:21:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B05E16B009D; Wed, 20 May 2026 11:21:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ADCB26B00C7; Wed, 20 May 2026 11:21:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9CBB26B00CE; Wed, 20 May 2026 11:21:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 89FE86B009D
	for <linux-mm@kvack.org>; Wed, 20 May 2026 11:21:37 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 3DA161C0CA4
	for <linux-mm@kvack.org>; Wed, 20 May 2026 15:21:37 +0000 (UTC)
X-FDA: 84788162634.02.94EDBCC
Received: from CH1PR05CU001.outbound.protection.outlook.com (mail-northcentralusazon11010018.outbound.protection.outlook.com [52.101.193.18])
	by imf10.hostedemail.com (Postfix) with ESMTP id 4B591C0003
	for <linux-mm@kvack.org>; Wed, 20 May 2026 15:21:34 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b="t/ZcXUAA";
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}");
	spf=pass (imf10.hostedemail.com: domain of shivankg@amd.com designates 52.101.193.18 as permitted sender) smtp.mailfrom=shivankg@amd.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1779290494; a=rsa-sha256;
	cv=fail;
	b=iQ0nZVTqaU06ptkOC/BgPZhCnG0TuqRVvfoZoI/kfCFhc/DQ1qYoMIxM9kk8NUxEZYhtCW
	jYg2w2vDAoLDlOXvTTSUeQBRPaLwO4HTWnGfnoGOIFpAYfpj36jUj8/haQ/sZbQgPI11cn
	Dttxrfurcb3WeIpLTTsNqnZoSm7n1Yo=
ARC-Authentication-Results: i=2;
	imf10.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b="t/ZcXUAA";
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}");
	spf=pass (imf10.hostedemail.com: domain of shivankg@amd.com designates 52.101.193.18 as permitted sender) smtp.mailfrom=shivankg@amd.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779290494;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mpRhOlsmscV5WNjGbZGhhyqXQGkMhhn65nz0UtHGu88=;
	b=aZD+aVtJV/FjMZof1hHVOg4PFa9GBPlB8DJ5MKc30XE7haQJLvLf2MW8Lrxrk3TSrTEIlW
	9Y4Ux0c+B7cT5hmEXQ0rJsTbBro+2gHond2I8r0iouNBmpLBA230IjJEX9wCXclJ7CoAOy
	AAGYtjF/E/U6XrBkxAFi/S1oBMnw6XE=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=T7MgFnHxuRSIuC3ZsbDeQRN2ZcvEkFynqLsEgbG5O4+Z+vVtysEggXVwhmAacOVx8N9t6laD3tzlafrYzOl+tgXrwJgTHkDA7Wl8B4sf8sPlyk2tc2w//k5LpDYd7b/U0oSaj4kOl52MKt6Lx6Hlxl1AtNWaFkDYN14N/OGZJVzP7h2GcIJTiCj007bj8nJtTyyWVrXQYroGriyZETQsR8gU/b3jlUflKO0AUksQB0qh6sz6QbZgQplHQkmaQ3uUj//x63vvMxJhUkcFAh1D/27TYYT+rNuU5rmWLAMHbSLYRQFArquPHcl4iZ/cc+hNdv5r0cdW9Otx9PH/+XcmmA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mpRhOlsmscV5WNjGbZGhhyqXQGkMhhn65nz0UtHGu88=;
 b=bpdapL4SjSJG2Y9tevLuaV1YzttnS4Ma7YUheHNkQrojujDqyrU8DFLtaWaLjU2g8CiAvwbzsCJNrNXeFf5ONktw7pRgBvn5zDmcl2B+iUUqAWrh/NRiVoZl7BxZnAmDpVczt1lbeOk6DZ8PFBwpbFWt54xVdlIam4xw5E6fqBEtKNynRlEVYoZ/Ftw/UEuO6tjb0H+NX0Pt5WiOXsKYeNPIWZU9GdwuSkvq4xrLpTv2kS363dVqT0tZZH+Nenp1Unsmzo9EdyDQ6e8FCDgakbgn8bAXiPjjTvxhn20xnEpkb5IVtMPbPt/fUAAsOuzzOgLzytA+GrfumGa8maPytA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mpRhOlsmscV5WNjGbZGhhyqXQGkMhhn65nz0UtHGu88=;
 b=t/ZcXUAA8LqPA7XCCa/9LCZT6NqlFFX/jsOiabttw+sVCXYLnCjUbmNtUE685JOCuSUqYkWUPuIc5G8L3aZtuPZy/VkQY6goL402mc12xV8r6318rVhiSD/i9rja2Zm9VSonOB/95fs4T0L7i6vD3VTUPUvM88e+XwVKsz0eNmM=
Received: from BN9PR12MB5259.namprd12.prod.outlook.com (2603:10b6:408:100::17)
 by DM4PR12MB8498.namprd12.prod.outlook.com (2603:10b6:8:183::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.48.14; Wed, 20 May
 2026 15:21:26 +0000
Received: from BN9PR12MB5259.namprd12.prod.outlook.com
 ([fe80::122c:cca7:c2b3:90ed]) by BN9PR12MB5259.namprd12.prod.outlook.com
 ([fe80::122c:cca7:c2b3:90ed%4]) with mapi id 15.21.0048.016; Wed, 20 May 2026
 15:21:25 +0000
Message-ID: <a36348d0-73f5-4599-8d06-c9472d0b8d72@amd.com>
Date: Wed, 20 May 2026 20:51:11 +0530
User-Agent: Mozilla Thunderbird
From: "Garg, Shivank" <shivankg@amd.com>
Subject: Re: [PATCH 3/7] mm/migrate: skip data copy for already-copied folios
To: "David Hildenbrand (Arm)" <david@kernel.org>, akpm@linux-foundation.org
Cc: kinseyho@google.com, weixugc@google.com, ljs@kernel.org,
 Liam.Howlett@oracle.com, vbabka@kernel.org, willy@infradead.org,
 rppt@kernel.org, surenb@google.com, mhocko@suse.com, ziy@nvidia.com,
 matthew.brost@intel.com, joshua.hahnjy@gmail.com, rakie.kim@sk.com,
 byungchul@sk.com, gourry@gourry.net, ying.huang@linux.alibaba.com,
 apopple@nvidia.com, dave@stgolabs.net, Jonathan.Cameron@huawei.com,
 rkodsara@amd.com, vkoul@kernel.org, bharata@amd.com, sj@kernel.org,
 rientjes@google.com, xuezhengchu@huawei.com, yiannis@zptcorp.com,
 dave.hansen@intel.com, hannes@cmpxchg.org, jhubbard@nvidia.com,
 peterx@redhat.com, riel@surriel.com, shakeel.butt@linux.dev,
 stalexan@redhat.com, tj@kernel.org, nifan.cxl@gmail.com, jic23@kernel.org,
 aneesh.kumar@kernel.org, nathan.lynch@amd.com, Frank.li@nxp.com,
 djbw@kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org
References: <20260428155043.39251-2-shivankg@amd.com>
 <20260428155043.39251-8-shivankg@amd.com>
 <810e9a58-9c08-4f5e-af5f-866685ca09b2@kernel.org>
Content-Language: en-US
In-Reply-To: <810e9a58-9c08-4f5e-af5f-866685ca09b2@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BM1P287CA0013.INDP287.PROD.OUTLOOK.COM
 (2603:1096:b00:40::32) To BN9PR12MB5259.namprd12.prod.outlook.com
 (2603:10b6:408:100::17)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN9PR12MB5259:EE_|DM4PR12MB8498:EE_
X-MS-Office365-Filtering-Correlation-Id: 99eee0cb-7241-4bd3-3326-08deb6837542
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|376014|7416014|56012099003|22082099003|18002099003|11063799006|6133799003|4143699003;
X-Microsoft-Antispam-Message-Info:
	BBxklvqk3GYm8nY71kh5LZ0mPluApimoWMJ3pyVF9lK0BeHrjqQBQ4pLgvun/M7paIc4H1jIphvmijRAcotryVq4UrXLBZIzd9X5xtzs9rO3xMMzLcGCmA9oH1InZH3yVk2cAewbCrlRYWmnWyqxHJYXTPh7kNKtFwYIjYexI3+jyENW7r3EXSZeRYSgLBLjVA6plwXbOW9FOsSwqdfskg7L1+mcD+c1z5193RlDBwfy36mc4tWXFBooeyVWLkgRTg1lDSkk4ORj4bRccAjYjf1hNi+d/RG/yYhJRF5ZLcyOpZlBK+F0ad36bGhR2ijrtPZvzUevJgWcKdLlLa4i7B8I0iWpKWvijgHPUSnbiGgHrMcDfLTo4nDUlLFXLGId6Z+JtyH+PJf22Ezzb9XA7IxqTRJOdFSY2kQwI52JCbeEmyve/E+DSOrb+gPndrx2xsq/w75rzOUi735uIQ8ft1aSEKl2f1DtToZFn9L7V5qC/tCTEeWO45U57miKmvGKznqDMkG2VsY/YgLqT2rGZNLExijNCjj+LGvBMGHfOZFATpi9K8Zv0Miz/xwzM9xYgPNbltJUP2X7ICluAz8kCD5kGl7cFUXWo3zQ4DK6+pDsfha41pagsAEi4P6lHJtKOlsYfOjfAIh7YXl4N5lZJ5Cs/zLx7nYFD1pkPwzVTKN69oQ8pFf4kYrwkA90ISuO
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR12MB5259.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014)(56012099003)(22082099003)(18002099003)(11063799006)(6133799003)(4143699003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?OWFzZjA2Wk1ndDF3Um9KbitOYkc1LzI2cU9KMUdwQ3pmWjhySm96SzRqZkJE?=
 =?utf-8?B?QUFGTnJianI3bkFueTczVzZTa3JTd2xNZkd6TytKWjZFWk9sZXhJSHErM2Fw?=
 =?utf-8?B?UEtkYUFFck1ySFpleTEycUZzdm1hQjZ4bjVlTDVicUNqSTB5Z29vekZaZnhR?=
 =?utf-8?B?aUx4VHNXMjZZQWNoZDBXQVF0MmNtSUtKTEpvN0NhLzkyWGRpZmhMRXZxMnMw?=
 =?utf-8?B?WnBRUXYwMmtoWjhrSHFBczZvWXFURzNHeE5aYzhRa1FBRUpPVHhwbGZNMSt3?=
 =?utf-8?B?YU00VE1iYkh0a3Z2K2RjR29zMW5XOWpqWUdPblovamF1T0FraGJnMEVvNkJo?=
 =?utf-8?B?azNVc3RkSmRXS1JDUEVBWTlvSHNaQ2JQUi9mSnNQOVl1RGhjQ2Z0M3ZaL1pD?=
 =?utf-8?B?UXY1Y3N0Mm9XdDFhOEJEaHVPenptU2JMcjQzV2RIUkllNG5jR205RzdxRUVJ?=
 =?utf-8?B?R1NqM21GUkVTWDRGUjlEZXI1eitXaTRGS2c2dTY2NHkvRWdzL3dvNmk2SzBr?=
 =?utf-8?B?VURJb1FZYjlpY0NkdnVZMFEycnZkOGpQVCtpbnBTd0lnaGJsTk9Id2dyZ3lY?=
 =?utf-8?B?d2FFVGNNck15N3NNK2p5Y3l3SERKditlR2NSOUpxWFVwdWNXNTlwc1RDLyt5?=
 =?utf-8?B?OEhLWVVVQlBsbDk4Q2ZGbnMwM0Fad1BSaWRDdDBaazVsa2xGU09qR051SFFL?=
 =?utf-8?B?S0RFOWo5RWYvMUFGSzNIbWc2ckRkQytrYm5IYnVOUVByYVppVkxhVEhpNlAy?=
 =?utf-8?B?dmt1R1QzS2ZWSUFSNlFRMmdWWnZZcmFCSVFYMmZuWkhUbi9sSEVtdlN3MExC?=
 =?utf-8?B?eENMdm4yQ0lPOElOd0Njc1ZTTDlNeWVWNHFLLzJjOStDV25sbEQzQ2hkbWJo?=
 =?utf-8?B?N3JCSnoyRjJuaWVZeUtYekZiYndWdXpKRlZDWHlpUjlmWUx5dDlhdCtoSkMr?=
 =?utf-8?B?R1lkditUdlhhMVI2RlI0elk2SG13bmJpcEh0QlFSaElhSTRxY1hDVkFUSmtK?=
 =?utf-8?B?dzhSR0llWURUQ1ZQMjVYeGszWHVVWWNZdllPSmJvellHOUc3MTM5Vit3MjdD?=
 =?utf-8?B?OTgyZk5yS0h6cGZ4SjR4b3lZMnFtQVJyTzJ3VENyeGRENzEra0NaU01lVC9v?=
 =?utf-8?B?STZ0M05FUWhCYmxmcWdPQ0xvazEzVDRNS205Q3dPTTBTUEo1M2JaWjZkd3JW?=
 =?utf-8?B?RytSVTBDaHNTWFZwN3hMUGljVGM4eW5LazNYMkVzOFVyOFN3YlZ3TU5YNjhR?=
 =?utf-8?B?dTNrTzlRV20raE4vMUVNRi9Ja1NtRkFPd01PQ2owbXZkUVQxdkNyOUFqTU50?=
 =?utf-8?B?MVZqVFdVWm1sQmZiQ0xTYkM1SWI5R0p1UDJPSno5K2NRL0dkQjNRR2IzaDZn?=
 =?utf-8?B?VDZ2dlNjVFFaYVJrRXVKVk5zeGxFV0NENnV0bjU4UDE2UFZsaEh4L1liRk0z?=
 =?utf-8?B?c2xJZXYwTGhUZ0hPejl3Z2Fqd2hGbXhNeDArcXd2S0xDYUlJNnp6V0JkeU1s?=
 =?utf-8?B?TjhuYzlZUWUzMWZxdFZwQTZUYU5Nd1gxbzdJb2QyWWRQSHBDZ2NHMlV0a0xT?=
 =?utf-8?B?d0YrNmc4RllMN1RzUlJjQjFySmJVWVJCdFdiOFhHcTlsMEJzMkYvcFpHYkl4?=
 =?utf-8?B?VEJ3TzBxc2N1MFRlOGd5Q25Kdi9RMGRmMXVad0hTMXV5c3Zubmk4NDVFOEdi?=
 =?utf-8?B?Vm93cU04V1BkVVZnK1JNMlBPRXB4S3RUS0tsbXNWTkZsQllUK05BeXlKWi9Z?=
 =?utf-8?B?MjlRZ0NyMEM2dHhWWTlNbWJVcUVkMGZ1b3NvTWx0SVVzUE9sN2lGa1ZnMXpQ?=
 =?utf-8?B?UCtSdDJQQS9ZUU52SGd1UDZra0ZsQlhSZnhTdiszY2hSM212NEtuMXlyMFZv?=
 =?utf-8?B?QVpEa00wTk5sWVhBQ0ZPcTdrZytsWE54QW4rSHFYVy9aWFFuQkZ6YnNNN2hJ?=
 =?utf-8?B?NURNN3FibWR4aTlKaFg0SHVlaEhoRmYrR0ZwZ0lhbDNXdFpzTmdmd0tBMVJP?=
 =?utf-8?B?UG9hOVdhMERUeHpPazM0RVhha2l3bzJ2OUZJY1pjaTk3MWpZa0xIazZDREpZ?=
 =?utf-8?B?T2w2SGE0WXhkbXFDM2FqMXVRSllkWklIbEtJUXl0NHNHWVJjd1czWmI3bHN4?=
 =?utf-8?B?blZ4L0hFelFqY25jVFZiRjRySmVtbVhkcFFKdjdLNmxuK251MXV5cVZkWVl6?=
 =?utf-8?B?d0MyaUpicUltRVVrWUZ2WGpoRWtQQnh0TjNSY2EzSWpTSnliN3ZSemU2QS90?=
 =?utf-8?B?c1FmQmRNMXptM2UwbWl3OWo2bnZhL3BUT3pmaEJnVzZPeXlrQ2NNb0lPbFVI?=
 =?utf-8?B?ZC80WGttUUNvakJiaFR3MEdIbmZmSXZlMG1halNseGhzd1FqL1RQUT09?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 99eee0cb-7241-4bd3-3326-08deb6837542
X-MS-Exchange-CrossTenant-AuthSource: BN9PR12MB5259.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 May 2026 15:21:25.8723
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DO1+zD41LmPOZGNd6RrbLD7GdsXnaqNxwgx2N2+ce7VN1pmOs7UZP4zb8Jh+rU2FPLz3oIyLG8V3KW70xPHv/A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB8498
X-Stat-Signature: tdxzeek7kpaxtmqf8m1x99aaqiftrif4
X-Rspam-User: 
X-Rspamd-Queue-Id: 4B591C0003
X-Rspamd-Server: rspam07
X-HE-Tag: 1779290494-576453
X-HE-Meta: U2FsdGVkX18FpHNe0AGgErUHgwB6VQMof9eNi45f+VYbl97lV7KqA3YuZdg/ZZcZVkaN4GvP6Wlib4k2QmtysfnQ7iIm0TP6dgWrW2x0JmgWGYKP449jth4Qu4lhmpsC2Zow8hIByi1tVP8SGqfk11XhKhmI1kyxkRes6s9Wfzd5cHuFym0hMhdoEcrHGh2mgnbtEPzOZd0GS/27at4M2nyKBFdnfJNBTtJYif4+4DKIiX5ZBECjePC7XX8xAka799Ebw/7m/NV+7okaLsSJbxn+epRhjmXVAStVZ8yTS618fjmLlygx9Y3wH32WSrkqEscHZS2l+DOJdOBcPEXksjMJPRUrwLPSmtiX+TltCOWv9cLXqvChNdHoSmE+6nQqDgKWz+F+pUH55wFfGghBbhAM00TQ80fZQFf3ZnrFzeknF5FkT6uBipe/Ig6iFHzZaHzKfTOFN4xFniAHxX/CxVmxWwDpeUWKRkYygys02kJwmSaE7JLA1vOfrAKVpNK/v0tKv6YfubLmaM8mxtUFRzNJWjT7xB9QKnma+0Hveu2kdlPhA46gu2L/I30pXBdveKzDm4wdD/WqjMl2kdrzP1Uc3KaTZZbpuNZH+IR8REcimgpHBJlas9WZGI0M/oN3PUPKozdWvo2DoIyqdme74ydYk191eexuOB9qRpGNcTPS2Df1ltkZ7EKcFlxMjAcCDmV3+xPTmn4K/eGN2NuU3G9jOxSuEy0f2zfPa5wB4lnEei1xnKdxMSDEG0VTzI79FZNLePanZQGWxl2GqLEhAPjHriyrioUaMrRpHv1G/e/wLLt2Gs7wM7v7MEpo5Vs/kpyxybt+5E/IXyVRhLjE1saw6AdEYhTaKAI8fk92mtoQ1JJevnkNMfOWbJBmgHpUrivPbrJDZIuYR8FxUmY2fXjzxM+NA9NgoNmqUmgIyEAUNkCGtTLcoKdtBuyvpWLdfi9yc7oUFasamO2FoWA
 R+NrHody
 kEkuRf3CzOxbuRDvtcAjX/NZ8FXP010zCY+z7Avy8YFx2hJKVteS2QEjs6ymf0IsCtlc9RAF0hcbvCM+oc35yB2ekHl0TpuB/2ymlbaXDWyl2wznPLiNBNnlWE/SGI12z+BAdPAWDMa0EfeT6Y5h2H3pdsrpM6mYvXXzJvtyrY+wlAFUFCd/CtlY/5OI4rOluekyGAhs9nm/3VI3vvLM/J/rHIR4gGJDhP4+BvZDGb0aVXDKOEoHWR/urp9cId/JfdQ+SKHLFh3C8vklSF+PYj39aKEVsoNGMLXUNsWSA/QfdDt4frHLx8KbvopCyRM5Kna/FhU7Kf77Rk2d85zihvFm3WPD5hAlYnG2TTdLQXFJCZkoksDOrjK4XoVImIMIOCwkyoSeCh//N+QyI4KOfFY5KE2WFw67P13lwSjRZHJN9+8jFfyxC5B2M9YWNqHb5GnU6yjELgkB/zMF1H+gPcR/Q23bbSNE9+i07quTdr32+Dz2IJ8agkP5dKDJCdpo0agTzTbB5HJ6FcMGp4elEg9ty5vZG1C7jo9/j
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 5/11/2026 9:05 PM, David Hildenbrand (Arm) wrote:
> On 4/28/26 17:50, Shivank Garg wrote:
>> Add a FOLIO_ALREADY_COPIED flag to the dst->migrate_info migration
>> state. When set, __migrate_folio() skips folio_mc_copy() and
>> performs metadata-only migration. All callers currently pass
>> already_copied=false. The batch-copy path enables it later in a
>> subsequent patch.
>>
>> Move the dst->migrate_info state enum earlier in the file so
>> __migrate_folio() and move_to_new_folio() can see FOLIO_ALREADY_COPIED.
>>
>> Signed-off-by: Shivank Garg <shivankg@amd.com>
>> ---
>>  mm/migrate.c | 53 +++++++++++++++++++++++++++++++---------------------
>>  1 file changed, 32 insertions(+), 21 deletions(-)
>>
>> diff --git a/mm/migrate.c b/mm/migrate.c
>> index 03c2a6f7e5e4..c493e67e359d 100644
>> --- a/mm/migrate.c
>> +++ b/mm/migrate.c
>> @@ -850,6 +850,19 @@ void folio_migrate_flags(struct folio *newfolio, struct folio *folio)
>>  }
>>  EXPORT_SYMBOL(folio_migrate_flags);
>>  
>> +/*
>> + * To record some information during migration, we use the migrate_info
>> + * field of struct folio of the newly allocated destination folio.
>> + * This is safe because nobody is using it except us.
>> + */
>> +enum {
>> +	FOLIO_WAS_MAPPED = BIT(0),
>> +	FOLIO_WAS_MLOCKED = BIT(1),
>> +	FOLIO_ALREADY_COPIED = BIT(2),
> 
> I wonder whether we want to talk about "folio content copied", to not confuse it
> with folio flags copied etc.
> 
> FOLIO_CONTENT_COPIED.
> 
> Thoughts?

Good point, this is more precise.

>> +	FOLIO_OLD_STATES = FOLIO_WAS_MAPPED | FOLIO_WAS_MLOCKED |
>> +			   FOLIO_ALREADY_COPIED,
>> +};
>> +
>>  /************************************************************
>>   *                    Migration functions
>>   ***********************************************************/
>> @@ -859,14 +872,20 @@ static int __migrate_folio(struct address_space *mapping, struct folio *dst,
>>  			   enum migrate_mode mode)
>>  {
>>  	int rc, expected_count = folio_expected_ref_count(src) + 1;
>> +	bool already_copied = (dst->migrate_info & FOLIO_ALREADY_COPIED);
> 
> const, and no need for ().

Will fix.

>> +
>> +	if (already_copied)
>> +		dst->migrate_info = 0;
> 
> Hm, why is that required? Might deserve a comment.
> 
> Likely you want to clear the "already copied" marker?
> 
> 	dst->migrate_info &= ~FOLIO_ALREADY_COPIED;
> 
> ?

Yes,
In current code, migrate_info only carry FOLIO_ALREADY_COPIED.
So, =0 and &=~ are equivalent and similar for |= case. I mirrored the
how anon_vma/old_folio_state get handled __migrate_folio_extract().

But with your other suggestion of marking already_copied immediately
after folio_mc_copy(), then bitwise clear and set will be required.
I'll do this.



> But I wonder if this really belongs exactly here.
>

I did not understand this.

 
>>  
>>  	/* Check whether src does not have extra refs before we do more work */
>>  	if (folio_ref_count(src) != expected_count)
>>  		return -EAGAIN;
>>  
>> -	rc = folio_mc_copy(dst, src);
>> -	if (unlikely(rc))
>> -		return rc;
>> +	if (!already_copied) {
>> +		rc = folio_mc_copy(dst, src);
>> +		if (unlikely(rc))
>> +			return rc;
>> +	}
>>  
>>  	rc = __folio_migrate_mapping(mapping, dst, src, expected_count);
>>  	if (rc)
>> @@ -1090,7 +1109,7 @@ static int fallback_migrate_folio(struct address_space *mapping,
>>   *     0 - success
>>   */
>>  static int move_to_new_folio(struct folio *dst, struct folio *src,
>> -				enum migrate_mode mode)
>> +		enum migrate_mode mode, bool already_copied)
>>  {
>>  	struct address_space *mapping = folio_mapping(src);
>>  	int rc = -EAGAIN;
>> @@ -1098,6 +1117,9 @@ static int move_to_new_folio(struct folio *dst, struct folio *src,
>>  	VM_BUG_ON_FOLIO(!folio_test_locked(src), src);
>>  	VM_BUG_ON_FOLIO(!folio_test_locked(dst), dst);
>>  
>> +	if (already_copied)
>> +		dst->migrate_info = FOLIO_ALREADY_COPIED;
> 
> |= ?
>

Will do.
 
>> +
>>  	if (!mapping)
>>  		rc = migrate_folio(mapping, dst, src, mode);
>>  	else if (mapping_inaccessible(mapping))
>> @@ -1129,17 +1151,6 @@ static int move_to_new_folio(struct folio *dst, struct folio *src,
>>  	return rc;
>>  }
>>  
>> -/*
>> - * To record some information during migration, we use the migrate_info
>> - * field of struct folio of the newly allocated destination folio.
>> - * This is safe because nobody is using it except us.
>> - */
>> -enum {
>> -	FOLIO_WAS_MAPPED = BIT(0),
>> -	FOLIO_WAS_MLOCKED = BIT(1),
>> -	FOLIO_OLD_STATES = FOLIO_WAS_MAPPED | FOLIO_WAS_MLOCKED,
>> -};
>> -
>>  static void __migrate_folio_record(struct folio *dst,
>>  		int old_folio_state, struct anon_vma *anon_vma)
>>  {
>> @@ -1353,7 +1364,7 @@ static int migrate_folio_unmap(new_folio_t get_new_folio,
>>  static int migrate_folio_move(free_folio_t put_new_folio, unsigned long private,
>>  			      struct folio *src, struct folio *dst,
>>  			      enum migrate_mode mode, enum migrate_reason reason,
>> -			      struct list_head *ret)
>> +			      struct list_head *ret, bool already_copied)
>>  {
>>  	int rc;
>>  	int old_folio_state = 0;
>> @@ -1379,7 +1390,7 @@ static int migrate_folio_move(free_folio_t put_new_folio, unsigned long private,
>>  		src_partially_mapped = folio_test_partially_mapped(src);
>>  	}
>>  
>> -	rc = move_to_new_folio(dst, src, mode);
>> +	rc = move_to_new_folio(dst, src, mode, already_copied);
>>  	if (rc)
>>  		goto out;
>>  
>> @@ -1536,7 +1547,7 @@ static int unmap_and_move_huge_page(new_folio_t get_new_folio,
>>  	}
>>  
>>  	if (!folio_mapped(src))
>> -		rc = move_to_new_folio(dst, src, mode);
>> +		rc = move_to_new_folio(dst, src, mode, false);
> 
> ... mode, /* already_copied = */ false
> 

will fix

>>  
>>  	if (page_was_mapped)
>>  		remove_migration_ptes(src, !rc ? dst : src, ttu);
>> @@ -1720,7 +1731,7 @@ static void migrate_folios_move(struct list_head *src_folios,
>>  		struct list_head *ret_folios,
>>  		struct migrate_pages_stats *stats,
>>  		int *retry, int *thp_retry, int *nr_failed,
>> -		int *nr_retry_pages)
>> +		int *nr_retry_pages, bool already_copied)
>>  {
>>  	struct folio *folio, *folio2, *dst, *dst2;
>>  	bool is_thp;
>> @@ -1737,7 +1748,7 @@ static void migrate_folios_move(struct list_head *src_folios,
>>  
>>  		rc = migrate_folio_move(put_new_folio, private,
>>  				folio, dst, mode,
>> -				reason, ret_folios);
>> +				reason, ret_folios, already_copied);
>>  		/*
>>  		 * The rules are:
>>  		 *	0: folio will be freed
>> @@ -1994,7 +2005,7 @@ static int migrate_pages_batch(struct list_head *from,
>>  		migrate_folios_move(&unmap_folios, &dst_folios,
>>  				put_new_folio, private, mode, reason,
>>  				ret_folios, stats, &retry, &thp_retry,
>> -				&nr_failed, &nr_retry_pages);
>> +				&nr_failed, &nr_retry_pages, false);
>>  	}
> 
> dito.
>

will fix.

Thanks,
Shivank

