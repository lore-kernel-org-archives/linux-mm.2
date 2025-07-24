Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A9D41C83F26
	for <linux-mm@archiver.kernel.org>; Thu, 24 Jul 2025 09:36:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 28C406B0255; Thu, 24 Jul 2025 05:36:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1ED516B0256; Thu, 24 Jul 2025 05:36:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 067956B024F; Thu, 24 Jul 2025 05:36:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E699A6B024D
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 05:36:43 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id A36A61A0294
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 09:36:43 +0000 (UTC)
X-FDA: 83698653486.09.40A9BF9
Received: from SEYPR02CU001.outbound.protection.outlook.com (mail-koreacentralazon11013041.outbound.protection.outlook.com [40.107.44.41])
	by imf30.hostedemail.com (Postfix) with ESMTP id BFCE68000B
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 09:36:40 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=vivo.com header.s=selector2 header.b=boEcYcKN;
	spf=pass (imf30.hostedemail.com: domain of link@vivo.com designates 40.107.44.41 as permitted sender) smtp.mailfrom=link@vivo.com;
	dmarc=pass (policy=quarantine) header.from=vivo.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753349801;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=53mHRHbnkcaXOexWL8cDGwbwJVeVOlA1WgPgWe77P8I=;
	b=6k2bVMe8kDUIE4tKsxSgDBUuAcKoEJSdIm/Px0NwQRt8gg4AX381JDqHC/NN+xKRc+gbsE
	hB3DMUVR5u7Og+Z0dgZ1pQXijy4WZDohbUIpiOAI90Qe/m0zS24gm9iiNYFcgOJSu1jEAf
	2IXh+LtoowCz5Sj6rWHPoupfPsExVpk=
ARC-Authentication-Results: i=2;
	imf30.hostedemail.com;
	dkim=pass header.d=vivo.com header.s=selector2 header.b=boEcYcKN;
	spf=pass (imf30.hostedemail.com: domain of link@vivo.com designates 40.107.44.41 as permitted sender) smtp.mailfrom=link@vivo.com;
	dmarc=pass (policy=quarantine) header.from=vivo.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1753349801; a=rsa-sha256;
	cv=pass;
	b=4H1Yn6PjFYRbzOQrg3dfYg+8Zc5vnnkgJ/NxIJ8LG0btVFo4O/DwN409FvxcIm/ZMoevNE
	VpHUYyGPfLf0nBYdNbLbhEpUW8mgjePY0oysOgjeknjQZ29gwl5m3cZmjhXZdkGTpdjlt8
	ZTU1J2xfXumkq8Q/AF5VZ2xsOI68Jxo=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=NCN9E+9P1s0/FenY9Oj3lm04iBJp3uG6Gav5E5vqtOgfmTf5RlzRZGjXDA2NLnLT8enqhNpw6l+jY2BTM8Q3IFxG8HCo7EgBJUsWf77DoSmJtHPhSyJuZMS24JQKvDzsbauouZTOS+88/pjwfP/qp4Mwbz4q0YhZQKStWwX4wddUUWd+u5F1hK0+NlpF61f3rvuSRpUO5fgBuatpdLMHEY9ULtUBahYHoapG/4vQBe3urYLZBVQNuEGKAfh7ddWTDwkewiXHOmCt1dKF3jMi532X6+ni02EZmT9xWovOzu2n9jHYWR3YXeATCl48VfkARct+HjR3w3Q3v682mzoqEg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=53mHRHbnkcaXOexWL8cDGwbwJVeVOlA1WgPgWe77P8I=;
 b=PViW71Qud+dsM/eBun3kuQ1Rn6j35vjdS2h4nVwP8X20tEYLJfasRRO/V+2NnLofxiSvEarHpuqJHuLpn2+U8VrKIy6CpyBYn1B+qyVuJic7G+MfzBoePkGBMm8nMAW2amla7rqxbd4ExcINE7N1oxbl4kA5D8UMRi+zpi42QslIjlWWCJUhygvT8tUYEQLwj4VBk44Wmf91lfTrR9NguaIWVTiNrTG7h0cftRZdqRYCqfbJRHQH56nXg2bNwtyuVabeSuwn2YVLqWrBNJhQv2ihqBzwQ4lzT5gapwhX6Tr++UQpnrRzMv/pbrmwdiP0KslG3bkyP9aMx41ONMitsg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vivo.com; dmarc=pass action=none header.from=vivo.com;
 dkim=pass header.d=vivo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vivo.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=53mHRHbnkcaXOexWL8cDGwbwJVeVOlA1WgPgWe77P8I=;
 b=boEcYcKN5KWurihwON3sU4pPJZO75WCrNP7dK39YXmxRE4VNd1L/MMcnI0yP/ah2a9itRPy3I0NQV/QgwVQMt/VH93S0OnptTxBaHBGo02doBTioN29GN8z6rCSWYfY+MvnOgKzvImqCVL33l5c/pOLn8gydP29FuCkXGbkAIXgSjWPIhF7UOy/5KSyCJtHsFPYhIU8EHsl7yDgCE0EWrVasapeJqBRUyJKWwph6zege/u7zMKPA8xCoHrl73v9ZmpvZxNhkkw0j2MJJX+pCgMBBBB9TiiNLCHLOU8iUe6ZjDijmvzxK9UbgF0uQAF8oK4jJBtdQwLUG0kR8thQYaw==
Received: from PUZPR06MB5676.apcprd06.prod.outlook.com (2603:1096:301:f8::10)
 by TYZPR06MB6639.apcprd06.prod.outlook.com (2603:1096:400:45b::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8943.30; Thu, 24 Jul
 2025 09:36:34 +0000
Received: from PUZPR06MB5676.apcprd06.prod.outlook.com
 ([fe80::a00b:f422:ac44:636f]) by PUZPR06MB5676.apcprd06.prod.outlook.com
 ([fe80::a00b:f422:ac44:636f%4]) with mapi id 15.20.8943.029; Thu, 24 Jul 2025
 09:36:34 +0000
Message-ID: <cd253bcb-3ffa-4871-ae11-59d158fafada@vivo.com>
Date: Thu, 24 Jul 2025 17:36:27 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 0/9] introduce PGTY_mgt_entry page_type
To: David Hildenbrand <david@redhat.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Rik van Riel
 <riel@surriel.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Vlastimil Babka <vbabka@suse.cz>, Harry Yoo <harry.yoo@oracle.com>,
 Xu Xin <xu.xin16@zte.com.cn>, Chengming Zhou <chengming.zhou@linux.dev>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Zi Yan <ziy@nvidia.com>,
 Matthew Brost <matthew.brost@intel.com>,
 Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
 Byungchul Park <byungchul@sk.com>, Gregory Price <gourry@gourry.net>,
 Ying Huang <ying.huang@linux.alibaba.com>,
 Alistair Popple <apopple@nvidia.com>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 Christian Brauner <brauner@kernel.org>, Usama Arif <usamaarif642@gmail.com>,
 Yu Zhao <yuzhao@google.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20250724084441.380404-1-link@vivo.com>
 <86516155-f2d9-4e8d-9d27-bdcb59e2d129@redhat.com>
 <cc560d48-884d-4c8f-9fb0-565d74ad769a@vivo.com>
 <e9bb93a6-1e95-40e5-ad10-a60d80735432@redhat.com>
 <6d14e212-418e-4734-b256-b75c6fade25c@redhat.com>
 <23b986e2-80d6-432f-8188-7a11d6915c9f@redhat.com>
From: Huan Yang <link@vivo.com>
In-Reply-To: <23b986e2-80d6-432f-8188-7a11d6915c9f@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SI2PR04CA0013.apcprd04.prod.outlook.com
 (2603:1096:4:197::6) To PUZPR06MB5676.apcprd06.prod.outlook.com
 (2603:1096:301:f8::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PUZPR06MB5676:EE_|TYZPR06MB6639:EE_
X-MS-Office365-Filtering-Correlation-Id: 9dcd1412-e546-4c9d-5f3c-08ddca95941a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|376014|52116014|7416014|1800799024|921020|38350700014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?MXZOTzZJd2tEV3M3VXJPSEJpVmw2STkwdk9OMzVma1ozeTZ2QnNkSUpPL295?=
 =?utf-8?B?MEFJaDhNQlF4WngzSDdLdXhxc1kvMndZVVFrc0dXc1FoK0ZYcGhVNlBRTkxN?=
 =?utf-8?B?OXJlMnJPZXZVSFR3eDVpSGpJRWViZlJZellWT0UvSC9KLzRiQjY0WTVmOUhX?=
 =?utf-8?B?ZFZCKyt6UStIaSs3U3U2a3VPbmZxSnlpT1EyY0ptZFNibkhNZkZRMXVPVHlT?=
 =?utf-8?B?aSsrdWNNQ2hBNXAwY0ZZYUw3Tll3YkpxdHdiRERPc2w0Mjk4VUJhN2x4S1Fn?=
 =?utf-8?B?QWZxQVhINXRkNlFtZ2tFNmZEWmNrdXl6N1dpWjY2L3paYkJPUGkzaTVOcThx?=
 =?utf-8?B?ZzFBR0JvR2lTRkNWanJ6b1MxTm9IbUt4YiszZmdIMWpmVlZ0bmhmS1hkOFM3?=
 =?utf-8?B?ZDVRQmxVdHdjejh2dmpia1JaSk1ZSDNnMXpma0o3QWJvZUhkYlFVbkJQY09I?=
 =?utf-8?B?c20vR1Rib1hBN0xuQmZ6dERobFIyd1BtUWd6VUFsWHBzYlA1RFllVXJUUUtq?=
 =?utf-8?B?RHhpZEVQYXkwcWtCS0s0UDBTUk5wRFpPOUZGdjhoQzBEalRObUpQRUIxN2Jq?=
 =?utf-8?B?c0tWMit0ZTFRbFFLQklyUGZqUW51ZlIzYytLT0R0aTltUVRkamt0RWxWRmM4?=
 =?utf-8?B?dFM5QngzTTZkbkg5NmsrV2NWaHd4eHBCU0VqMnRJeVFZdVIyeUlxd09tWXVQ?=
 =?utf-8?B?WjllN1hDa2hId1gvMUVha2psbnNPcWt2UnZBaVZLdnFJQzcwUFV5SCs0bkc2?=
 =?utf-8?B?bHRHNE8zOWtYTk9tSTF4UVJMZ3E5N0dMdG9aTG9JK1VkMU5DaVBoSGdvZjBv?=
 =?utf-8?B?cGE2cmRMd2l2RzhyZFFaN29oSzI5dlNmRW1qUHkrZmNFM3NWOHFISzFXeVFD?=
 =?utf-8?B?T3ZNc3NhSXFvNmM5M0VoSnFvd0ZUVXV1M3lVWG5LKzVWT2M5SlY3eTIxWUxX?=
 =?utf-8?B?TE9DY1RGdGpqVkhIbit1M1ZPdTdGb2dYUlZNV2lFbnZhTlU2NTNjVysvZVcv?=
 =?utf-8?B?MTZzVVVzR3lpNG5lQlgwNWE5VzdFS3pJekwzckw1NDQrZHJpc1hIY2kyVUUx?=
 =?utf-8?B?TWdBMkhLQzJ1RzYwdWxad0FZT3lsOC9TVElsalV1czVsck1OL0VnUGg2MmlW?=
 =?utf-8?B?Sjh2YUNseXd1bmhabm1Wek91ZmV3SmdsSkl6RWVYcEVDODVQRUlMSmJzYWkx?=
 =?utf-8?B?NmV4Nm9sVE91b0V2NnBjbGRxbTArUkdBcWJ3eEk3UUlWTXFQMWNLcHNVV1J2?=
 =?utf-8?B?c0c3VStrd3hsRTVMRnBERHhuWk15d0d3eXJGSmpISmFyNTJsVG1VaFVHQXND?=
 =?utf-8?B?dm5vZnpnK1psRVBPbkxobU42Vk9VOHl0WTNrSUVGYzBha0ZtbkhqcE9QTENk?=
 =?utf-8?B?c1RmNmc3VDJLS0VZTWV2SnRZcEZZcjlmRWtWc2EzTGJoemtJWmw5c1RnU0Ry?=
 =?utf-8?B?WjAvb3ZPcE9UakhYbDJhc0hjSERDMkk4Sk4yTU5Kc0Y5dVVueExqbjRVWFdt?=
 =?utf-8?B?eGNrTk5qMzFPZHRQV1lBMklLek1PV3REWGc3QkcwQXNoLzllWmpEaCtZZ1J0?=
 =?utf-8?B?MGJKWTVyL1JpanFvcjRhcy9ld01BdVlPR0tSS0JBM3M1S0VuV25GbnpubVRM?=
 =?utf-8?B?MjRvTk9Vbk1yRUF6ck5VYnpjb1dzZG9EK3R1ZzdJMTdQdGxXVTdyMWh4bWt4?=
 =?utf-8?B?bTBHN2QyRWxjeFowMFdFMDd1UFBDMHZ5UEt2QlFSQTdVOGxVTXlralROSjBk?=
 =?utf-8?B?YVhScE5HbWJ3ZGFrby9tWk1OY3p5MVp2djRLUUpybFBLVjlacUJLa2NjMytI?=
 =?utf-8?B?cUJlWHZvSDZmdVFFR21RV3JlVXJWWTNzQ2tCSEhHT1Q4c2dzVlpFUGF5Yzcv?=
 =?utf-8?B?dWhCWktkM2x1VnE0RUNsS0pxcWF1c0NlSGNqUEkyTjdMRFZXRHdyYkMyVkVq?=
 =?utf-8?B?R2RIOERKT2ZJSWNPRjVpLzFPejZxczlRb1BwMVptZElYOU1jQUQwRTlQYVRX?=
 =?utf-8?Q?UHTmVRAA5kG3dhKXWyni8ajQh5JrR0=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PUZPR06MB5676.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(52116014)(7416014)(1800799024)(921020)(38350700014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?cEF6SGpIa1RmSE5aSWRuQ0VLaG5LSWRBTlZGQVArUTJudENlUk1uYTVLREpN?=
 =?utf-8?B?UGNuRW5CakNCZ3JRcVFsajUzaUF5NFZZcDVMbktENHRZYXMzeXZhMERkZVF1?=
 =?utf-8?B?WXR6dytuL2ZXUVVhOG95TlNvSjQ3cE1pL3RnYkRtN2hOVTdUc1Jhd3lQdmJS?=
 =?utf-8?B?WmxuK2RVcjN0WlBFUWc5cUVQMW12bFJOWkZFbk9HcFBTdTg3dVllUityODhN?=
 =?utf-8?B?ZUVxN3k4QTRKQkhNUnZETTA0alZESk13QTlnQktJSXhpb0Q2RTVkaUVKYkth?=
 =?utf-8?B?WS9HREVXNFVxOWJnUkZuSEtBNHJ5dDI3Z3ZnNzlkQ1lpTlRPRUFvNHlOMVQ5?=
 =?utf-8?B?ZWk3dTBHdjJEVk1aVHNIamc5VDdJTmY2NWpvb3luSjFod01oVG8xQzA0dDNT?=
 =?utf-8?B?MTcxYWhoWE9ZUUFCVm5OczJjNndrSmNxdUM2MjFoV1ZkeWpKREUzN1AvU1l1?=
 =?utf-8?B?dlFnbC80dFluRmNHMGVHM1pvWlpNUG9WYjBQakJhZ2x5RWpLb1V2QWh1MWh5?=
 =?utf-8?B?emxQQnV4TjFKQXYyQVpObzdwaGVyK05sZXBZQmk5U3ZVbEVERlJNU2U1V3Qz?=
 =?utf-8?B?c2xYaVVnNnArcTZLcGhZREJvV3R1M295dzVNaU42ekx3dS9RTlRjaTBkNzQr?=
 =?utf-8?B?S080clR1UnNRTmtQcWVmZlZDMHR1TENPaWFiTkdSTE9xS3FxUmtaUWhtdTMr?=
 =?utf-8?B?N0U3SXRwRHdtVW1qcmxTQUI3OU1WcnBGd3kvMWw4TndDakM1UDV6QVB1bGdU?=
 =?utf-8?B?RXlQNkN1QUVyNnBVV3NqWjFNUFRTSWFNcnZjNlptejM1Wk9NODZudXJJd1Nq?=
 =?utf-8?B?aGFUeXpyVHJSUVo4ZzhsQzY1QkR5MHlnMG5SV2pMOFZJdmhRRlAzWTdMZC9Z?=
 =?utf-8?B?L3ZXTEhVQ2VTTU42d1A5aFRXaFVvelhmZVp3K0hQc0FCL0Y4eWdtNURqSWNz?=
 =?utf-8?B?cUJHYTZobThiNlJuTFBWcHdqMzFTQkE2OWpzVzNzaFI0Z3lKMzdqRzJ6U1hs?=
 =?utf-8?B?Z21OZjBRTjZ4MmdTUFUzNitGek5zSUhpMGlwbFluc0E2aDZSRWxSMjBXbmRR?=
 =?utf-8?B?Y1hJMzhqbEF5eXp2YnZWdklaWTVkUlpHKzJGUHY3WFFVOXViU3VRQU5PZFRr?=
 =?utf-8?B?RXhuWTltNG9lWWJ3RjRBUlg1VjYwb1JGTWRQZnFTN0pVVWl5MEoraWFJbTJE?=
 =?utf-8?B?TDNIWUd0NVV4ejRiaS9HWnk1dUtqb0VEcVk1YWdSQTNXQTVSbkVJeHhPWGp3?=
 =?utf-8?B?aHVoblpUcGFDY0dkcUszS25xRmd0Q2J3ZVNxY3Ryd1VudHdsYUJBaWJkcTRz?=
 =?utf-8?B?cHpha0hiUlRWcDJ5U1JVejRQRTBmUUxGaVhrQVFWZ2pRUUlIOUVUYms2MUl0?=
 =?utf-8?B?WU9CR2h4VDZiVG1GNjE2d0cwcWNGS1hIZ2lPWldxTnBsV0FpdFJOMlRoQXgr?=
 =?utf-8?B?L0VFL2REckhYaGJxTnNQTXc3SjJsQlhwTjRScWRHWCs1N09UQVloZ2dlb0NC?=
 =?utf-8?B?VEJwZk1vZDJVbnZVVzdLQWc0U2dVeDJ5eFRveithM00xczhWN2ZOcjN1UDhM?=
 =?utf-8?B?QjJMTnhOdHhhdGRGZHgxU2dBc1ZVVElQRTZMMTRvNEt6SHRsMlhMWEIyc0ly?=
 =?utf-8?B?TThUUEtNTHpnSmJZRHZ6S2dvc3RZSHhUYXRKaXlSQ0U3RVJUUm9pdnErV3lB?=
 =?utf-8?B?dUtqeE1Jdkcrdkl4RUtHVUxwUU5vMTFSbm9oUDhPbEpITUZNeUMxS2xYaTFt?=
 =?utf-8?B?ZVkzRXgrRHFHVmZJVU9PV21nNkxwM01DZXZGRnp5T1pqVmJsMk05YVVrYlFD?=
 =?utf-8?B?RVhxb3cyZnJrZ2R1a0xQQjJzNDBmbTkzRXRoUS9vb1BsQTJmZkZTU01sekk0?=
 =?utf-8?B?ejZXWkdPYXJZQy9oTWRHMVBYR3JJTUwvQmZDV2FsbjBoc0hqUXJWNy83d0lt?=
 =?utf-8?B?TU0wSWNZUmVmWkZPWlk5REFiT2pUQmJyV2w2M3YvOFdhZ0d0c0xSUGs5Y0ps?=
 =?utf-8?B?dHJxQkg2ZnRtUUlSekpQeFNVNHZkZjF6YWJuWmZVY1cvbmRUZ3lkTHNsV2tY?=
 =?utf-8?B?MGQyaHgrcUNEUWdCTVJlaG5nbkxVSURCWFpVUWt3bXdXd3BxaVZKS0Yzei9J?=
 =?utf-8?Q?B2JAy4kTYDjWCyRiDdF+9q49K?=
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9dcd1412-e546-4c9d-5f3c-08ddca95941a
X-MS-Exchange-CrossTenant-AuthSource: PUZPR06MB5676.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jul 2025 09:36:34.1468
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: aMPAcglzBUVVY3ruET39g4ObwvQ9sA+VSFkRTTMJ3tTmCTWMpn0GdqN/T3EOwv6+2MZEO7wYQqmE/4bP5ygGOw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYZPR06MB6639
X-Stat-Signature: gm9qrkw57ijnqzwniw8hk9rastprdxts
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: BFCE68000B
X-Rspam-User: 
X-HE-Tag: 1753349800-275435
X-HE-Meta: U2FsdGVkX1/IJ6Rms6rMD7dmraC7DTuz4RWlz2GIyPxRDykSHp9AHs5Zxmi0hv0aFXT9iPtXKpGKvOJIVDzM7RU0BtddIZpwNWCJ+V3MuYuslZ30UqxROKUBAVV4CrZ9bCdirtnVH4Dd+fdqHGZKooYd2LAEXdI4vhogV7dq6CeGdpVJqkDMF4sfgaBY92SiD1UekRkCRBR3veXijy8KUBQBrYKXfvwS7y2CZGH++XmIa0rDmDMUXflWwW9D6TTiYXMrXFppMCseBJJQ3s95TbDFirsBDSjYeXznU+4LZi74zW0xdUsRlvXSFSEl+CxQ4JcIuxZzgkMbr80MNgPXwMrDvMaR2FaQ99pafm5bG7ZWI3z/lsJMBXSxPUzPgQ1W6xcR740qOHTVjVp6AEsZMfkMJ/VR8DUtiGgcTN03xpY+Nmv6g+ox4CuX6heGdZM9y2s7Dp1IGB0KVDsax22COdl+MeMJ4QjJZaCmp1t0LUC4KBkCSOnZfC7EhVdEuk4O0r6YeB15TVtsVoS14Oc84aadBP2w0dyNDYDtiEssgBTdkxNiiAVJdAbWJdGCv1jcxpKnlaiVsJ/A+FpEuAfJjeY+tlYYAsVKZ2hOVIRw8WJ7SF95dVcnkbhd8tSeNxICCqLrfCrkNs7j4Oz3VYaejSTS+me75yGexl+1aV6oyAFD6RFEpZYqzxFAmuxWCjx+HALBalSFnP7S52SMn2G5m5MiJ/r4XeL4EpCgy706/UO//h24BYWq2GH4xim8ZFSrmx32rytgmAEtQbIroXjgiwAW54NmQe1kWtzaaKIYePcQFuo1SM4sQctSAvRXhGAI//Q1mW8wn9pgTknbzU/EInIcH++z8T6rrLTdrrE/btus1Fk+xvD3y2voo7LkiP5SNCYv2v2VTIApZlYZNsbZlq/2bHvA2pzD60UAapYfiePDTlgWMPhXL41z1rwj7enZ8G4IzROxetkIPx1IVTg
 khJex9eW
 Ner8pvFXqzsVdcz0P0z9tV7M3QKIQtDhlF3kkHLiOY+tm95gIHrjaiLjF/CoQTtMdttVxIPYNPI3xA51+PnsTe66iaW3bFZe8zzwghLNlbh6PbVanc7I8xrwvJD/jhlDuVuNuCzfvRF7EEcuq58N6o8LlOLQXjyMNtrVyqBCNsqTFtUk4rt4ao5hcC7L6pLxPPC0HpI5me9r6p7az2JH11krxGmbKZGPdA8aSUvZMayNoy+510sMqZHQTy07aGOifHaOPbrPQa+a4Hz8RY8BZ/Ux552StYIeU0Bo2MkT0iGLkm3+GbJ7njtHEwWE4nJXyqk5VF1W4rfyCuiHPre1Q4HDRiWKLbQulBCr2MIXtNoobq+s1VYE/CNCxGTzyTWHv1qIyDvAjDtJ4fn8BBB/EK5CnMVgyXMlmbd1Q9BQKwVrWXXbB0dRVMkmdFZrpMiBU0XGH0zISUwldY8Q8NnSzu+LWogINp5kK4FhEMfzidmnl77RC9B+rjVF2+6zks2+0uMFSjyG7HiAuZyyY+W9+gB3FcFKpt/9uEoZsTmEmODgjrl7HxqMXj0hQrYgyZ0n2PS+wTToq7sC3APghUC+4M6Dv/ViMh/dZD5bZzafHPXmTvdA0sZEQOhgyTdwneJFLjo9V7NcKpKLWH8fJFWRHWjBGUIEonQFVbll23DCZHK2tkhYEE+w4HS8rX3Vw5a7GK6S7zpMiVIj1cXRR2yEsgzWkcg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


在 2025/7/24 17:32, David Hildenbrand 写道:
> On 24.07.25 11:20, David Hildenbrand wrote:
>> On 24.07.25 11:12, David Hildenbrand wrote:
>>> On 24.07.25 11:09, Huan Yang wrote:
>>>>
>>>> 在 2025/7/24 16:59, David Hildenbrand 写道:
>>>>> On 24.07.25 10:44, Huan Yang wrote:
>>>>>> Summary
>>>>>> ==
>>>>>> This patchset reuses page_type to store migrate entry count 
>>>>>> during the
>>>>>> period from migrate entry setup to removal, enabling accelerated VMA
>>>>>> traversal when removing migrate entries, following a similar
>>>>>> principle to
>>>>>> early termination when folio is unmapped in try_to_migrate.
>>>>>
>>>>> I absolutely detest (ab)using page types for that, so no from my side
>>>>> unless I am missing something important.
>>>>>
>>>>>>
>>>>>> In my self-constructed test scenario, the migration time can be 
>>>>>> reduced
>>>>>
>>>>> How relevant is that in practice?
>>>>
>>>> IMO, any folio mapped < nr vma in mapping(anon_vma, addresss_space),
>>>> will benefit from this.
>>>>
>>>> So, all pages that have been COW-ed by child processes can be skipped.
>>>
>>> For small anon folios, you could use the anon-exclusive marker to 
>>> derive
>>> "there can only be a single mapping".
>>>
>>> It's stored alongside the migration entry.
>>>
>>> So once you restored that single migration entry, you can just stop the
>>> walk.
>>
>> Essentially, something (untested) like this:
>>
>> diff --git a/mm/migrate.c b/mm/migrate.c
>> index 425401b2d4e14..aa5bf96b1daee 100644
>> --- a/mm/migrate.c
>> +++ b/mm/migrate.c
>> @@ -421,6 +421,15 @@ static bool remove_migration_pte(struct folio 
>> *folio,
>>                      /* No need to invalidate - it was non-present 
>> before */
>>                   update_mmu_cache(vma, pvmw.address, pvmw.pte);
>> +
>> +               /*
>> +                * If the small anon folio is exclusive, here can be 
>> exactly one
>> +                * page mapping -- the one we just restored.
>> +                */
>> +               if (!folio_test_large(folio) && (rmap_flags & 
>> RMAP_EXCLUSIVE)) {
>> +                       page_vma_mapped_walk_done(&pvmw);
>> +                       break;
>> +               }
>>           }
>>              return true;
>
> Probably that won't really help I assume, because __folio_set_anon() 
> will move the new anon folio under vma->anon_vma, not 
> vma->anon_vma->root.
>
> So I assume you mean that we had a COW-shared folio now mapped only 
> into some VMAs (some mappings in other processes removed due to CoW or 
> similar).
>
> In that case aborting early can help.
>
> Not in all cases though, just imagine that the very last VMA we're 
> iterating maps the page. You have to iterate through all of them 
> either way ... no way around that, really.

Indeed, whether we can exit the loop early depends on the position of 
the terminating VMA in the tree.

I think a better approach would be to remove the fully COW-ed VMAs and 
their associated AVCs from the anon_vma's tree.

I've been researching this aspect, but haven't made any progress yet.(I 
have some ideas, but the specific implementation is still challenging.)


