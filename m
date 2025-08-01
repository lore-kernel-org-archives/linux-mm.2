Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 42359C87FD2
	for <linux-mm@archiver.kernel.org>; Fri,  1 Aug 2025 05:57:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7DEE38E0003; Fri,  1 Aug 2025 01:57:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7B6AB8E0001; Fri,  1 Aug 2025 01:57:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6A5368E0003; Fri,  1 Aug 2025 01:57:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 5A2148E0001
	for <linux-mm@kvack.org>; Fri,  1 Aug 2025 01:57:29 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 9C7BF141089
	for <linux-mm@kvack.org>; Fri,  1 Aug 2025 05:57:28 +0000 (UTC)
X-FDA: 83727131376.22.80F3D67
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2089.outbound.protection.outlook.com [40.107.243.89])
	by imf23.hostedemail.com (Postfix) with ESMTP id A938C140002
	for <linux-mm@kvack.org>; Fri,  1 Aug 2025 05:57:25 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=ZLcUHu62;
	spf=pass (imf23.hostedemail.com: domain of balbirs@nvidia.com designates 40.107.243.89 as permitted sender) smtp.mailfrom=balbirs@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754027845;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=U0LlxbdXo42CVK6veGR/0JKCC7KSfIW7BSJsnfp/umo=;
	b=xqOCjMiaYhqqLy72JFBwP0jrYAs4nML3ct4dZjDecFMyCG+zqpLVgMV96phS9oNIhwIRkU
	0mpkjni3mf0h52KI1RP70AhYKxjO9zkHFX8U1GzOfqyFtfO3uzRWPNc06YsDUCVQdjDBKh
	e5DUjhmsiAevHMl0BeY6P0Tp0G+26Ks=
ARC-Authentication-Results: i=2;
	imf23.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=ZLcUHu62;
	spf=pass (imf23.hostedemail.com: domain of balbirs@nvidia.com designates 40.107.243.89 as permitted sender) smtp.mailfrom=balbirs@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1754027845; a=rsa-sha256;
	cv=pass;
	b=oNf43eGZiDdOxCR9kHEpGSrnYQ65I00CfHTviPqHDS9ErQr2Jx/9vhR5xetXNtxYHmXYWs
	DZYvKNYeJqaqInhH37s1/kJRyqykHtkvcEG/piTJWfFMrcTGGzL2ZLAOVX29VLI9NUhrHY
	kZERyNIYu+IKPmsRFfMNg3P1SkCGXQA=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=S+Bgb1nuwlnyq9NXZEWlTRgFBkwqKC9b8aSNeHPL2LpV6eJmZGjnHgANqBKRQYIHjPkhcsLZkNUW/yHY2WzZM/+/i7EZ2vWF5vyXi7rn1cJlRM6T2SR1qmK9MLZHqRKIqXhniz/+WYp9mmSRqHXee8DFA9pRWNTPRAE7Osp282xawHR2F/PEaNILgxCLGvxnPoEGX2s//5g4IQO1fDpSto7yIgQRYcAp0P8ozM7ZMbN02itQSYg2u0/RTG5im3ySiAbbZJ+Q8c/v6duMmKXR6WmVe7sU260QWqAvd7wprRdXa4G8KyOZM2OaY1sDCLdSxNbzGvXvgk33Ya0SfEzZww==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=U0LlxbdXo42CVK6veGR/0JKCC7KSfIW7BSJsnfp/umo=;
 b=ppm9bXJWfi4ZVsbpluxtx9VdVf9BvkdQbscVyfdkJBM/3immJzqp3x0xmcVZdku6eClkqfr5BeFQBqQ9fgStHPh1H1lSrlRXYYyFqE5MhckIrRwFFZNSDnqjPlRmmaKpebEMdm2VYOmSDRUyMiFfqMSE01cLyZ4uP6cf+mGi7i0BycdxX0QTuYMR7fS1XQHaOhzsDjN7HeTvEUlPZ69hqxHzZ1sJGaZboxfDW1fc1rH6ElpCR2zFLo6APta8ooPWdDPdNo8jQBD0K4NG+sPRUzlrz/AbTZNMfHp3ep6j2m/nDcpHXHVVvVgwbkDkxhSJ1a509zP++jAXUV+hJiLIBw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=U0LlxbdXo42CVK6veGR/0JKCC7KSfIW7BSJsnfp/umo=;
 b=ZLcUHu62iJk2jn1SMaztPceme2t3txiNzNWK8beNYGSQUH58Kb0q6KE+wcJFbRSshLWoB4KjknLtB2m7A0Fy70Qao18T9SXnC7EYgr97xVETokdtO0JH0W8BuhzVTbV2ZbLLYvLkk25YHrhKJ58xgGDKgj/TbaK+tlO7HDESrp/PIHRU/S7iAsbq+IR0dC6RRhYowBSbAN7QF8Mg8GxPqHqPI3TmgOtuH9gS8eG8Rwiy+VXYu8gjc/dbFzL3YDoBO2mZvyw+s2me5Lbowmun1HxHdZDZI/TSJG6lR9J1vyG+EpkynqDF/nmGm2WrmxuzfXZu6I4mnhU5LNgqDkRqmA==
Received: from PH8PR12MB7277.namprd12.prod.outlook.com (2603:10b6:510:223::13)
 by DM4PR12MB6229.namprd12.prod.outlook.com (2603:10b6:8:a8::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8989.12; Fri, 1 Aug
 2025 05:57:22 +0000
Received: from PH8PR12MB7277.namprd12.prod.outlook.com
 ([fe80::3a4:70ea:ff05:1251]) by PH8PR12MB7277.namprd12.prod.outlook.com
 ([fe80::3a4:70ea:ff05:1251%5]) with mapi id 15.20.8989.011; Fri, 1 Aug 2025
 05:57:21 +0000
Message-ID: <d0e15115-b486-4e90-b946-ad97a748c9aa@nvidia.com>
Date: Fri, 1 Aug 2025 15:57:15 +1000
User-Agent: Mozilla Thunderbird
Subject: Re: [v2 02/11] mm/thp: zone_device awareness in THP handling code
From: Balbir Singh <balbirs@nvidia.com>
To: =?UTF-8?Q?Mika_Penttil=C3=A4?= <mpenttil@redhat.com>,
 Zi Yan <ziy@nvidia.com>, David Hildenbrand <david@redhat.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Karol Herbst <kherbst@redhat.com>, Lyude Paul <lyude@redhat.com>,
 Danilo Krummrich <dakr@kernel.org>, David Airlie <airlied@gmail.com>,
 Simona Vetter <simona@ffwll.ch>, =?UTF-8?B?SsOpcsO0bWUgR2xpc3Nl?=
 <jglisse@redhat.com>, Shuah Khan <shuah@kernel.org>,
 Barry Song <baohua@kernel.org>, Baolin Wang <baolin.wang@linux.alibaba.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Matthew Wilcox <willy@infradead.org>,
 Peter Xu <peterx@redhat.com>, Kefeng Wang <wangkefeng.wang@huawei.com>,
 Jane Chu <jane.chu@oracle.com>, Alistair Popple <apopple@nvidia.com>,
 Donet Tom <donettom@linux.ibm.com>, Matthew Brost <matthew.brost@intel.com>,
 Francois Dugast <francois.dugast@intel.com>,
 Ralph Campbell <rcampbell@nvidia.com>
References: <20250730092139.3890844-1-balbirs@nvidia.com>
 <20250730092139.3890844-3-balbirs@nvidia.com>
 <c2f2fe52-a358-489e-a1f2-5c0a6f5b4db5@redhat.com>
 <22D1AD52-F7DA-4184-85A7-0F14D2413591@nvidia.com>
 <F60614E1-28D1-466B-A434-7FF1061B0778@nvidia.com>
 <9f836828-4f53-41a0-b5f7-bbcd2084086e@redhat.com>
 <884b9246-de7c-4536-821f-1bf35efe31c8@redhat.com>
 <6291D401-1A45-4203-B552-79FE26E151E4@nvidia.com>
 <b62234fc-051f-4b2a-b7da-0c0959fb269b@redhat.com>
 <8E2CE1DF-4C37-4690-B968-AEA180FF44A1@nvidia.com>
 <2308291f-3afc-44b4-bfc9-c6cf0cdd6295@redhat.com>
 <9FBDBFB9-8B27-459C-8047-055F90607D60@nvidia.com>
 <11ee9c5e-3e74-4858-bf8d-94daf1530314@redhat.com>
 <b5fa0989-a64a-4c91-ac34-6fb29ee6d132@redhat.com>
 <EC99D49E-86FF-4A50-A1AA-FC43A7D3716C@nvidia.com>
 <14aeaecc-c394-41bf-ae30-24537eb299d9@nvidia.com>
 <e5dd3f46-c063-45ff-8be7-64ac92534985@redhat.com>
 <71c736e9-eb77-4e8e-bd6a-965a1bbcbaa8@nvidia.com>
Content-Language: en-US
In-Reply-To: <71c736e9-eb77-4e8e-bd6a-965a1bbcbaa8@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BY3PR05CA0044.namprd05.prod.outlook.com
 (2603:10b6:a03:39b::19) To PH8PR12MB7277.namprd12.prod.outlook.com
 (2603:10b6:510:223::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR12MB7277:EE_|DM4PR12MB6229:EE_
X-MS-Office365-Filtering-Correlation-Id: f2b2490e-c15d-4a4d-ba3a-08ddd0c047e6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?Y0ZtTjF0MWVpT1NUSmE0bDdJeUFYYlVyaVpqUDN5UU9KZld2eEp0V2ZsM3NT?=
 =?utf-8?B?Y2F4bGs3ZEppSng5L2U5UjQ4eUlZRHhVSE1IWE03SnpodWR6SkMwd1QxY0Q2?=
 =?utf-8?B?UFZndkg3dzdkcGoxK2Fjb1lTbDlRS0pMcDZjYkk2UmlhWk0vL3UwR1NYdmsz?=
 =?utf-8?B?U0tyb1VSVmpzRUZCUllLaGU3N3ZyeGJBRHJueUNWRkhMVTlyZFpnNk13YWwz?=
 =?utf-8?B?cmRENCtwd05RdmNTVDhvQWlRaUZ1RXVvWERKaFZZakJPVGZNN0VZaHRrcHVa?=
 =?utf-8?B?YXJ6ZXNZVFFTS1Zob2h1MHVKWWJYZXE5aWdqbDM0NmhRN2hta2lDOFZkblpx?=
 =?utf-8?B?Mzg3bVJybGsydmNpVlZZVzV6ZEFOeFh2aE9IZkdCQTNJMEFEUk9reXUxU1ky?=
 =?utf-8?B?RFhwcy9JY3VLOFE1by91dDBXVWZQRXBDdnZmM25kTGJZeVA3d3BjOFJTcWRx?=
 =?utf-8?B?MWVnU2l0bmVmdExqN09sS3NaSzRQdTFRS3ZVdlpIUkI3djhyMGpuV2FHeU5M?=
 =?utf-8?B?M2NrNU5mSktyWCtmSk1BUWJOU3NHMkczcm5BWTNlblpISjdRaTlFU3JLSkEx?=
 =?utf-8?B?aEViN01XL0tVZkdTMVRJNndGMS90MURzRTRVMS8yR2FUck1uckhMaFdZWGEy?=
 =?utf-8?B?QXVIYmp0dndSZWxQRTFlaXFoelpRVGVEaFUwejlrTUM2R2VhTytmalJlSHBD?=
 =?utf-8?B?STY4alM4NXBDcTdFY1FsdkgvT1NycnFnSFQrcEpWcHlzWEp0VytSaTk1aSt5?=
 =?utf-8?B?SVU5VUVDKzBnQ05WQ2V6SytSVDNkTEpCekFvRnFZOUdGVm1lZ1lDK3ZRUnJs?=
 =?utf-8?B?UVhJRkhpUE9jN2JjZUJaT05iM1FNRHVTUjdNbm96SmlPd0dmZGJvVzVoTTZO?=
 =?utf-8?B?Y0w1MldUcFBwRzVTaGsyTDZrUGpWZXVqQzFKY1BMNXFKaGhYM1B0dGZrOHBz?=
 =?utf-8?B?NFJ2QlpWNDhIQ084YWpsTnI5a29qazQyNno0Ry9kQ1hXZXZaTXV3UVNLc2xS?=
 =?utf-8?B?c3ZQVU96UE5tT3R5U2lMaFl3Mjh3WnBtbHlJV1V5YVpRVTlGNlZKemYrWXNw?=
 =?utf-8?B?K2JqWmE2YkF5Mk5qekFnYUZUQnNyVmlFUHltWXcxZ1hHSHBwVUwxRVRTRVBn?=
 =?utf-8?B?SDRRNHlpc3QzNFZLRjZ4U2VJMUEwQU8zM2NqdmhzY2s4OEpzakxPcEh4U3U2?=
 =?utf-8?B?ais5T2piMzBiUVRnQUxnZUIyNm1LSlVVK2xZMUZxQ1B2MjZZUmJPUGIyM1F3?=
 =?utf-8?B?T0x0TDNjTDhPcG1LRGRoWmR2b3BjREk0VzdnWDYvY1ZaYUYzbFZrV2VOWEo2?=
 =?utf-8?B?VWdoaFN6ZU5WeVNia0lLNW5GYVJxOGpZajh3VjF4ejNCNVFibms4VWNRMVIw?=
 =?utf-8?B?Si93T1pUb2ZSZ2ZIcHNBUytJWS9VelNjUzZzYy8yREtwQkZMaHpDNURoUEpt?=
 =?utf-8?B?S2k2cWowQ01PN1BycUpLS0pja1luZCsyaGx5SWVPQmpza1R1L2VKZjYyTEJG?=
 =?utf-8?B?eVF5dSsvKzFJZHJnazVsbU9mZTN3elZDYkx3aWwzZ05QUXZRMFNuczVRK0N0?=
 =?utf-8?B?N0R4cHZwVUFLNVJMaU8wdll1OVpoZjdKSnJmQzdaRGNpdVZPNTlabXRPazRO?=
 =?utf-8?B?OXpicUlEd1BFeGdIU3pXczlta3k3TTVhcStTaXkvQzhoVlNBSDdlM3JLeFlk?=
 =?utf-8?B?NlpEbXkrWTlWeEo4WGx3VXVybWxCbkwrTG1obHVNbUJhTnRBYzZCd1ZBc3g4?=
 =?utf-8?B?WERDVEZLNFF3bnBJcjhYT0VoemNrVGVJMEp4NmFQR1VQWm5HaUwyRDZ0eFBS?=
 =?utf-8?B?anUvRUVjbVhJVVZoN3ExUWRlbC9zRWVtTlM3VkJlRkZidGtMaTdDY2tpbVhR?=
 =?utf-8?B?MnpZQSttSzVFdkpGM1RjbWhjQUJMbEd1QkZkeFI2MW91UlpWeFdnajBQOW4v?=
 =?utf-8?Q?qYehTtaXycM=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR12MB7277.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?ejNaczJIUkYzZ3ZxQngzM3hmN1Z5MlcvNG8yU0Q2TDFsWHFLd2ZWbEZWS29q?=
 =?utf-8?B?SElwVU5BYk1ibzQya2JwYTB2UmlPZ2RhWmxXVVovaW1qcUxSd3JNRlNRbVlC?=
 =?utf-8?B?VGdRT0JmUlpEV3ZnckNaNjRkV3pOWUlMNG40a2M0OXhjZGFXWWJEK2txTjhx?=
 =?utf-8?B?bkZ2ZEJycTIxaFQxclRrb09yYjRWQ1ZnYUhmVmdNSjBkUGg2THNhSmVLYWhx?=
 =?utf-8?B?dDROTmVoZlQ1MkRsR1NVQ3EycFh5RmE5UGY0NTJqMEc1WEs1MTdlRVNZRGR6?=
 =?utf-8?B?eS9xNFRjaGZqTnhJSmRocVNnS3UvN2hOWW8wWWV4ZTc5OHM2SmNYc01mRmNn?=
 =?utf-8?B?QmZ5ZFkzV01HTUViYTVXTzBobWVKV0J1eWR6Vldwbm5RVTRpM1QrN3VIb2Rk?=
 =?utf-8?B?bDEvd1dVZ1RVVHZQSWR1MjE4VDBHekFQbmV2dmdhdi9YRlRYTWRid2wrY2ZQ?=
 =?utf-8?B?OE5ZeFUyRnpaVGpNSTBTMkdOSkM0ZUdmYjBDWk9HelJVcDN2a3dJUmhuRis0?=
 =?utf-8?B?QThvNXZFNXJsNVQ3U1RIOCtXcEZqZjU1ZGdHbTdtZ3V2a3VWOWFsRmRFUWh6?=
 =?utf-8?B?WXhtdzA2M2tEYlNBMmFHMW5jejgwd2lId21BK1VIM2F3dFluNGFqcmVKNGJr?=
 =?utf-8?B?K0tNYnM0RXhsZjUyaFFKdk54OWJJTjhJQUxtUE9yZGFiZUh0Q2FyVjJBc2lD?=
 =?utf-8?B?STZNVm1kT3FBWjA5VGlMa3J5OFNicmg1emJTdjVWVUdWRjNlSS9UT0dJWmZU?=
 =?utf-8?B?ZU1qT3RCSEQ5VGVrVUNnUjlNaWMwTE5oRCttMmZadncyWVZRM2pFTFNUQmZl?=
 =?utf-8?B?NDE5U2YxZ3A2aXFJcXRUVE00Wm1iNndja1pINmZQdU1sL2dlVm5IQUlBQ2FM?=
 =?utf-8?B?dGtZR0llaDF0UUZDTkhELzIrc0pmK3gzOUYxNFNxRm9IbytWbFJ2MXE3bldO?=
 =?utf-8?B?RjhFS1JKdjNoQ3U1cmNEK1o1ZjFtV21GQVZIY1AwdG42MUl1dndmN201S05Q?=
 =?utf-8?B?Y1VzQys1ai9hNHR3NDBZc2hDTFRjS0ZhZUxETlRhbmVlZzl4UzN2bW9SVlJH?=
 =?utf-8?B?VStSSmw3NEtHZmFLQ1YxVlpETE80ZGF1cUJaOWxkU1B3SG83R0R5RTZ2ejhz?=
 =?utf-8?B?dndOSjBEdmJ4OUhvSUwyYkd0UGhkVjFVbE9HWEEyOExLRExLSVJCQjJhYzN0?=
 =?utf-8?B?dS9EVG9KVmMxUHhwbENoTmtXKzhucnNhZ1BiZnNRRTQxZWFoRjNsSTRQWmZY?=
 =?utf-8?B?M281ODMrQmE1NUZUVDhBN1NZc0ZFNi9NcDltR3k4MkNuUDhBMzlOS1lCTFY2?=
 =?utf-8?B?Nyt1cDA5TzJkcGV6cEM2eHk4dS9GckgzaktyWXE0SWlEdHRkOVZITVk5K0o5?=
 =?utf-8?B?dXU4SXcrSVd1ZFY2Y3EwaVpTM2VKR2xTb2dkWnQ5ZGYvTEZjMEt1eGFkbmlP?=
 =?utf-8?B?dFcrQ0lQcEU3Y0xtUjZ6ODZiSW9VdEJkREIwQnk5RU93ZTZUR05WbWlzcUo4?=
 =?utf-8?B?RTdJRm5DSVErUHVDUWFqaEUrMEtaSW9FbWVIbTlRc0JkN3ZJYTI3RkRNeEw3?=
 =?utf-8?B?KzE3cC80VXJwTFNjMmxHU1dtS2F4OEQyanAwYlE1R1lGODRlWkw2dkFUNXF5?=
 =?utf-8?B?K3dvYlIvbG1YYVdyMDdBeU5tQklEOXlCbENpVkcvSHhjRmttUjVhMkRjemtm?=
 =?utf-8?B?YkJWZlFYcHRudjR5V2FBc3BKTnE3aTJaczY0ejdUOEZWalk5dGQ3OFRDUXZo?=
 =?utf-8?B?a3lLSHo5ZWQ3RFF4NWNianI1UDV0RWFUL0M1ZGJpN2ljN21aZWVYZFVodWN5?=
 =?utf-8?B?QlN5UWVqQURTRjgyYXBsM0tFNHpwQnF2Z3FIWmoyTWZ6ZjdQbFRnM3dRbHEw?=
 =?utf-8?B?bEc2ZmNPdlhIQjEySHU0d21OdjBqY0pUcVRZdDNZYmNGTmkvcnJPWXZjTk5v?=
 =?utf-8?B?SHlZc3pTbGpiSVpmZDQ5aUVJRTRqVTNEalFVcDI1VjBKZGs4MnoySWRvYmNh?=
 =?utf-8?B?ZVd4L0pIL0Y1T3c3azNTVkx5dFlXTHM4Q2Fab1A1NFQ2ZTgrVGJUVGRGOXZO?=
 =?utf-8?B?eittcWFEUU1XR1pSd3lxRmxCaVVwWitMdFpxK1pua3JvUUc1WUlUcGo3N2R5?=
 =?utf-8?Q?yBdEk4m7ot7s6ljIsgiZFkAn9?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f2b2490e-c15d-4a4d-ba3a-08ddd0c047e6
X-MS-Exchange-CrossTenant-AuthSource: PH8PR12MB7277.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Aug 2025 05:57:21.7082
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Dn0iey/8LdykzkYi0yZ3oHsMIP4xnXw6D/8SBfvM7+YOpHpEbstaSPVMQ7Gi90Orpew46XW3AqBoNtEQHgrmIw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB6229
X-Stat-Signature: 7f77mbmpef991bo6z9puwxad8bu1pbfb
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: A938C140002
X-Rspam-User: 
X-HE-Tag: 1754027845-729890
X-HE-Meta: U2FsdGVkX191xiftW87wS0yv04RV/DzRvynz1qKqS1nHHG7mbUgqS98rMU+maCneT47tM80zorbSsCGSu/SMO2MlFVzjikB5FBs5EQlDFIKyHu69jzpwCYnwNqiAQFQmqXBjnSKqlIkWatk2+NEma6WclMPry0hmzv8W8wXpAKNbG9OrUMTFK+DoHNpoYAeLr1JsrqKuoVJ5Y3U0+05LC3ruU3tGq2fxs4OW3eMb5BB0QGCDFJavJTJJjsHNjTsDOq0dge2Zf6botx/MBTIXGasLyMO9cP0PKlfTydFFazL4PaUKj5rDRDcUPdT5Bjn1eCA0gBRgbzXJXwwe/QCUnhvB0qbmVugqNSCRHEia+MBfgftSI+W/uTOZo8MXaUL8WN4iGFB6grr1VUpTqcr6SsTiYYqMbCOdI1MavEP/ZtQ4hq9gDJ6Aea6un7nXLefPlTwdHOMml6ihB93gGANwEkVji4wP8pAW2o2wo5Dd144LFAvUrf67v2jMbOvzRB/v+mR7q0x3bB8T827mLuUUc1fKcz9VHnViOCZ6NHgqF2248V3suMmLvVSYCUbaJ5h259FNHYA7n27e8DhBDf1MQFop1/5t/CUik9C1dwIG3UHvMgaIasPMBUlUUOzMH+tn92+Z67eavuX5Wo5G0Zmbrxyw3dbBl0aOl8W7iuKKMDWq4L8dAWpsaH/qQfmF3ChJUaYXkMwb+43ECsT8qLucd5dAQjpsJ9E5Stq1Gfq9iuI4CBt2wxE16tt6QQyMSS3XDXOvUstSErAbtzxAoqseTr1S5/OxDC93pyeEV3odYwYNVGmjUHU8dQsVckiCX2JsA5vDEemOed6rta3Atxa9TwexMpkrdXkjzK8Q/dqXgO1mQrhb/uHIepPg0r4y9uHV0gWKqGTZ+Y0tnaI6nLuhjd2uIniwdVHlXtHFckiI6U8nlbwKvEtzb88HtjhlU7fe5fpB+ehm9DYqzbBGpY5
 b6Kx/mln
 i3lvGN9hVpYNgF4P0HitavmMOC6qksLuDvE4MbeMfNjoIqjSBHwJ5n3kICW0hqiO4yOIwq9+9u1PZK7S/u6e6k/3lWE9VJIhKAzh4oWstqhGCuvF5KZLrZjGLGJ6UHKSA1aPZ5VmpQ/mSy5cbO9uvIObCf7J2vTKPliLXSCy3b+nboMkBqBWXwN18zXTS+nPGHhitrKGgXpr9i0zGLf2PiNWOL98WwREw9Evn6DX1mk+Y9vTo1reZufZULddvgG5p5appbJSiI0Ig1tkmJD45VQ8EfEgN9lFmq0Z3/m19FzldU9UB0Xxd39cd9yTnqGltdtFDa+sEFmxekbZ5TiQmbb0nMz3Il2PH4MSt1xdQF3K345tBtONe8pz5XoWXZuqeLFuBLjO+GGzd96uH2ML4MpdvoCFBeHhO0HouWyJvvGRMBzYayDcIliUnJ68CswsMG44tdZ6z0AOwwXSPpVscEJGQRhKlGNFimQqBrwr+qW38yD/go5YyqYPJJPYgBIpyx/a7xFY4GATz0JWrkdop5uW2fb6gS8YyAOrEZcf3mw0kSplC334r9kbJncswbDjVdIA4kJKm7cLSSF/RHkP1CBhhX6PgKRpnAcA+y46PuRiUk7JkNZuLsSXKEzxOLIKCY7Xxw0m8nMzbAGVeYTPhI6cjbtLtk26S2Ta1zXNHz7AOx36Yxgat1JXre1uyst7Lv2ISXXh9Eu2r2FiWZELQ+IqF6FptYfpWcwsRl2qnSqEXB3NbLAuMx4Hcll0r/WoxTgHfBQTDVv4wMTwBhkn3KmcqalNFnriaZ11+pOQ5TDicwrcPRkeF4VjnIlCCl3OqHC7OqkEGDax0eKoY0T9NefSL3pH3pRjT7FBq/pjG0xNXTy/MgMIijMf7EJ1eTjNc+nXwwXo8QNM5tHZfcJGGxMYL5g==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/1/25 14:44, Balbir Singh wrote:
> On 8/1/25 11:16, Mika Penttilä wrote:
>> Hi,
>>
>> On 8/1/25 03:49, Balbir Singh wrote:
>>
>>> On 7/31/25 21:26, Zi Yan wrote:
>>>> On 31 Jul 2025, at 3:15, David Hildenbrand wrote:
>>>>
>>>>> On 30.07.25 18:29, Mika Penttilä wrote:
>>>>>> On 7/30/25 18:58, Zi Yan wrote:
>>>>>>> On 30 Jul 2025, at 11:40, Mika Penttilä wrote:
>>>>>>>
>>>>>>>> On 7/30/25 18:10, Zi Yan wrote:
>>>>>>>>> On 30 Jul 2025, at 8:49, Mika Penttilä wrote:
>>>>>>>>>
>>>>>>>>>> On 7/30/25 15:25, Zi Yan wrote:
>>>>>>>>>>> On 30 Jul 2025, at 8:08, Mika Penttilä wrote:
>>>>>>>>>>>
>>>>>>>>>>>> On 7/30/25 14:42, Mika Penttilä wrote:
>>>>>>>>>>>>> On 7/30/25 14:30, Zi Yan wrote:
>>>>>>>>>>>>>> On 30 Jul 2025, at 7:27, Zi Yan wrote:
>>>>>>>>>>>>>>
>>>>>>>>>>>>>>> On 30 Jul 2025, at 7:16, Mika Penttilä wrote:
>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>> Hi,
>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>> On 7/30/25 12:21, Balbir Singh wrote:
>>>>>>>>>>>>>>>>> Make THP handling code in the mm subsystem for THP pages aware of zone
>>>>>>>>>>>>>>>>> device pages. Although the code is designed to be generic when it comes
>>>>>>>>>>>>>>>>> to handling splitting of pages, the code is designed to work for THP
>>>>>>>>>>>>>>>>> page sizes corresponding to HPAGE_PMD_NR.
>>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>>> Modify page_vma_mapped_walk() to return true when a zone device huge
>>>>>>>>>>>>>>>>> entry is present, enabling try_to_migrate() and other code migration
>>>>>>>>>>>>>>>>> paths to appropriately process the entry. page_vma_mapped_walk() will
>>>>>>>>>>>>>>>>> return true for zone device private large folios only when
>>>>>>>>>>>>>>>>> PVMW_THP_DEVICE_PRIVATE is passed. This is to prevent locations that are
>>>>>>>>>>>>>>>>> not zone device private pages from having to add awareness. The key
>>>>>>>>>>>>>>>>> callback that needs this flag is try_to_migrate_one(). The other
>>>>>>>>>>>>>>>>> callbacks page idle, damon use it for setting young/dirty bits, which is
>>>>>>>>>>>>>>>>> not significant when it comes to pmd level bit harvesting.
>>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>>> pmd_pfn() does not work well with zone device entries, use
>>>>>>>>>>>>>>>>> pfn_pmd_entry_to_swap() for checking and comparison as for zone device
>>>>>>>>>>>>>>>>> entries.
>>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>>> Zone device private entries when split via munmap go through pmd split,
>>>>>>>>>>>>>>>>> but need to go through a folio split, deferred split does not work if a
>>>>>>>>>>>>>>>>> fault is encountered because fault handling involves migration entries
>>>>>>>>>>>>>>>>> (via folio_migrate_mapping) and the folio sizes are expected to be the
>>>>>>>>>>>>>>>>> same there. This introduces the need to split the folio while handling
>>>>>>>>>>>>>>>>> the pmd split. Because the folio is still mapped, but calling
>>>>>>>>>>>>>>>>> folio_split() will cause lock recursion, the __split_unmapped_folio()
>>>>>>>>>>>>>>>>> code is used with a new helper to wrap the code
>>>>>>>>>>>>>>>>> split_device_private_folio(), which skips the checks around
>>>>>>>>>>>>>>>>> folio->mapping, swapcache and the need to go through unmap and remap
>>>>>>>>>>>>>>>>> folio.
>>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>>> Cc: Karol Herbst <kherbst@redhat.com>
>>>>>>>>>>>>>>>>> Cc: Lyude Paul <lyude@redhat.com>
>>>>>>>>>>>>>>>>> Cc: Danilo Krummrich <dakr@kernel.org>
>>>>>>>>>>>>>>>>> Cc: David Airlie <airlied@gmail.com>
>>>>>>>>>>>>>>>>> Cc: Simona Vetter <simona@ffwll.ch>
>>>>>>>>>>>>>>>>> Cc: "Jérôme Glisse" <jglisse@redhat.com>
>>>>>>>>>>>>>>>>> Cc: Shuah Khan <shuah@kernel.org>
>>>>>>>>>>>>>>>>> Cc: David Hildenbrand <david@redhat.com>
>>>>>>>>>>>>>>>>> Cc: Barry Song <baohua@kernel.org>
>>>>>>>>>>>>>>>>> Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
>>>>>>>>>>>>>>>>> Cc: Ryan Roberts <ryan.roberts@arm.com>
>>>>>>>>>>>>>>>>> Cc: Matthew Wilcox <willy@infradead.org>
>>>>>>>>>>>>>>>>> Cc: Peter Xu <peterx@redhat.com>
>>>>>>>>>>>>>>>>> Cc: Zi Yan <ziy@nvidia.com>
>>>>>>>>>>>>>>>>> Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
>>>>>>>>>>>>>>>>> Cc: Jane Chu <jane.chu@oracle.com>
>>>>>>>>>>>>>>>>> Cc: Alistair Popple <apopple@nvidia.com>
>>>>>>>>>>>>>>>>> Cc: Donet Tom <donettom@linux.ibm.com>
>>>>>>>>>>>>>>>>> Cc: Mika Penttilä <mpenttil@redhat.com>
>>>>>>>>>>>>>>>>> Cc: Matthew Brost <matthew.brost@intel.com>
>>>>>>>>>>>>>>>>> Cc: Francois Dugast <francois.dugast@intel.com>
>>>>>>>>>>>>>>>>> Cc: Ralph Campbell <rcampbell@nvidia.com>
>>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>>> Signed-off-by: Matthew Brost <matthew.brost@intel.com>
>>>>>>>>>>>>>>>>> Signed-off-by: Balbir Singh <balbirs@nvidia.com>
>>>>>>>>>>>>>>>>> ---
>>>>>>>>>>>>>>>>>   include/linux/huge_mm.h |   1 +
>>>>>>>>>>>>>>>>>   include/linux/rmap.h    |   2 +
>>>>>>>>>>>>>>>>>   include/linux/swapops.h |  17 +++
>>>>>>>>>>>>>>>>>   mm/huge_memory.c        | 268 +++++++++++++++++++++++++++++++++-------
>>>>>>>>>>>>>>>>>   mm/page_vma_mapped.c    |  13 +-
>>>>>>>>>>>>>>>>>   mm/pgtable-generic.c    |   6 +
>>>>>>>>>>>>>>>>>   mm/rmap.c               |  22 +++-
>>>>>>>>>>>>>>>>>   7 files changed, 278 insertions(+), 51 deletions(-)
>>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>> <snip>
>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>>> +/**
>>>>>>>>>>>>>>>>> + * split_huge_device_private_folio - split a huge device private folio into
>>>>>>>>>>>>>>>>> + * smaller pages (of order 0), currently used by migrate_device logic to
>>>>>>>>>>>>>>>>> + * split folios for pages that are partially mapped
>>>>>>>>>>>>>>>>> + *
>>>>>>>>>>>>>>>>> + * @folio: the folio to split
>>>>>>>>>>>>>>>>> + *
>>>>>>>>>>>>>>>>> + * The caller has to hold the folio_lock and a reference via folio_get
>>>>>>>>>>>>>>>>> + */
>>>>>>>>>>>>>>>>> +int split_device_private_folio(struct folio *folio)
>>>>>>>>>>>>>>>>> +{
>>>>>>>>>>>>>>>>> +	struct folio *end_folio = folio_next(folio);
>>>>>>>>>>>>>>>>> +	struct folio *new_folio;
>>>>>>>>>>>>>>>>> +	int ret = 0;
>>>>>>>>>>>>>>>>> +
>>>>>>>>>>>>>>>>> +	/*
>>>>>>>>>>>>>>>>> +	 * Split the folio now. In the case of device
>>>>>>>>>>>>>>>>> +	 * private pages, this path is executed when
>>>>>>>>>>>>>>>>> +	 * the pmd is split and since freeze is not true
>>>>>>>>>>>>>>>>> +	 * it is likely the folio will be deferred_split.
>>>>>>>>>>>>>>>>> +	 *
>>>>>>>>>>>>>>>>> +	 * With device private pages, deferred splits of
>>>>>>>>>>>>>>>>> +	 * folios should be handled here to prevent partial
>>>>>>>>>>>>>>>>> +	 * unmaps from causing issues later on in migration
>>>>>>>>>>>>>>>>> +	 * and fault handling flows.
>>>>>>>>>>>>>>>>> +	 */
>>>>>>>>>>>>>>>>> +	folio_ref_freeze(folio, 1 + folio_expected_ref_count(folio));
>>>>>>>>>>>>>>>> Why can't this freeze fail? The folio is still mapped afaics, why can't there be other references in addition to the caller?
>>>>>>>>>>>>>>> Based on my off-list conversation with Balbir, the folio is unmapped in
>>>>>>>>>>>>>>> CPU side but mapped in the device. folio_ref_freeeze() is not aware of
>>>>>>>>>>>>>>> device side mapping.
>>>>>>>>>>>>>> Maybe we should make it aware of device private mapping? So that the
>>>>>>>>>>>>>> process mirrors CPU side folio split: 1) unmap device private mapping,
>>>>>>>>>>>>>> 2) freeze device private folio, 3) split unmapped folio, 4) unfreeze,
>>>>>>>>>>>>>> 5) remap device private mapping.
>>>>>>>>>>>>> Ah ok this was about device private page obviously here, nevermind..
>>>>>>>>>>>> Still, isn't this reachable from split_huge_pmd() paths and folio is mapped to CPU page tables as a huge device page by one or more task?
>>>>>>>>>>> The folio only has migration entries pointing to it. From CPU perspective,
>>>>>>>>>>> it is not mapped. The unmap_folio() used by __folio_split() unmaps a to-be-split
>>>>>>>>>>> folio by replacing existing page table entries with migration entries
>>>>>>>>>>> and after that the folio is regarded as “unmapped”.
>>>>>>>>>>>
>>>>>>>>>>> The migration entry is an invalid CPU page table entry, so it is not a CPU
>>>>>>>>>> split_device_private_folio() is called for device private entry, not migrate entry afaics.
>>>>>>>>> Yes, but from CPU perspective, both device private entry and migration entry
>>>>>>>>> are invalid CPU page table entries, so the device private folio is “unmapped”
>>>>>>>>> at CPU side.
>>>>>>>> Yes both are "swap entries" but there's difference, the device private ones contribute to mapcount and refcount.
>>>>>>> Right. That confused me when I was talking to Balbir and looking at v1.
>>>>>>> When a device private folio is processed in __folio_split(), Balbir needed to
>>>>>>> add code to skip CPU mapping handling code. Basically device private folios are
>>>>>>> CPU unmapped and device mapped.
>>>>>>>
>>>>>>> Here are my questions on device private folios:
>>>>>>> 1. How is mapcount used for device private folios? Why is it needed from CPU
>>>>>>>     perspective? Can it be stored in a device private specific data structure?
>>>>>> Mostly like for normal folios, for instance rmap when doing migrate. I think it would make
>>>>>> common code more messy if not done that way but sure possible.
>>>>>> And not consuming pfns (address space) at all would have benefits.
>>>>>>
>>>>>>> 2. When a device private folio is mapped on device, can someone other than
>>>>>>>     the device driver manipulate it assuming core-mm just skips device private
>>>>>>>     folios (barring the CPU access fault handling)?
>>>>>>>
>>>>>>> Where I am going is that can device private folios be treated as unmapped folios
>>>>>>> by CPU and only device driver manipulates their mappings?
>>>>>>>
>>>>>> Yes not present by CPU but mm has bookkeeping on them. The private page has no content
>>>>>> someone could change while in device, it's just pfn.
>>>>> Just to clarify: a device-private entry, like a device-exclusive entry, is a *page table mapping* tracked through the rmap -- even though they are not present page table entries.
>>>>>
>>>>> It would be better if they would be present page table entries that are PROT_NONE, but it's tricky to mark them as being "special" device-private, device-exclusive etc. Maybe there are ways to do that in the future.
>>>>>
>>>>> Maybe device-private could just be PROT_NONE, because we can identify the entry type based on the folio. device-exclusive is harder ...
>>>>>
>>>>>
>>>>> So consider device-private entries just like PROT_NONE present page table entries. Refcount and mapcount is adjusted accordingly by rmap functions.
>>>> Thanks for the clarification.
>>>>
>>>> So folio_mapcount() for device private folios should be treated the same
>>>> as normal folios, even if the corresponding PTEs are not accessible from CPUs.
>>>> Then I wonder if the device private large folio split should go through
>>>> __folio_split(), the same as normal folios: unmap, freeze, split, unfreeze,
>>>> remap. Otherwise, how can we prevent rmap changes during the split?
>>>>
>>> That is true in general, the special cases I mentioned are:
>>>
>>> 1. split during migration (where we the sizes on source/destination do not
>>>    match) and so we need to split in the middle of migration. The entries
>>>    there are already unmapped and hence the special handling
>>> 2. Partial unmap case, where we need to split in the context of the unmap
>>>    due to the isses mentioned in the patch. I expanded the folio split code
>>>    for device private can be expanded into its own helper, which does not
>>>    need to do the xas/mapped/lru folio handling. During partial unmap the
>>>    original folio does get replaced by new anon rmap ptes (split_huge_pmd_locked)
>>>
>>> For (2), I spent some time examining the implications of not unmapping the
>>> folios prior to split and in the partial unmap path, once we split the PMD
>>> the folios diverge. I did not run into any particular race either with the
>>> tests.
>>
>> 1) is totally fine. This was in v1 and lead to Zi's split_unmapped_folio()
>>
>> 2) is a problem because folio is mapped. split_huge_pmd() can be reached also from other than unmap path.
>> It is vulnerable to races by rmap. And for instance this does not look right without checking:
>>
>>    folio_ref_freeze(folio, 1 + folio_expected_ref_count(folio));
>>
> 
> I can add checks to make sure that the call does succeed. 
> 
>> You mention 2) is needed because of some later problems in fault path after pmd split. Would it be
>> possible to split the folio at fault time then?
> 
> So after the partial unmap, the folio ends up in a little strange situation, the folio is large,
> but not mapped (since large_mapcount can be 0, after all the folio_rmap_remove_ptes). Calling folio_split()
> on partially unmapped fails because folio_get_anon_vma() fails due to the folio_mapped() failures
> related to folio_large_mapcount. There is also additional complexity with ref counts and mapping.
> 

Let me get back to you on this with data, I was playing around with CONFIG_MM_IDS and might
have different data from it.

> 
>> Also, didn't quite follow what kind of lock recursion did you encounter doing proper split_folio()
>> instead?
>>
>>
> 
> Splitting during partial unmap causes recursive locking issues with anon_vma when invoked from
> split_huge_pmd_locked() path. Deferred splits do not work for device private pages, due to the
> migration requirements for fault handling.
> 
> Balbir Singh
> 

Balbir

