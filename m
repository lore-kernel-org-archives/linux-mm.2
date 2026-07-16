Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5CA57C44514
	for <linux-mm@archiver.kernel.org>; Thu, 16 Jul 2026 21:13:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2866E6B0099; Thu, 16 Jul 2026 17:13:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 25DE76B00AF; Thu, 16 Jul 2026 17:13:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 14DBF6B00B0; Thu, 16 Jul 2026 17:13:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id DC3116B00AF
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 17:13:18 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 70C7D1C0146
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 21:13:18 +0000 (UTC)
X-FDA: 84995890476.09.06C0DDE
Received: from PH7PR06CU001.outbound.protection.outlook.com (mail-westus3azon11010061.outbound.protection.outlook.com [52.101.201.61])
	by imf11.hostedemail.com (Postfix) with ESMTP id 7E8704000A
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 21:13:15 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=DYWEPL2S;
	spf=pass (imf11.hostedemail.com: domain of ziy@nvidia.com designates 52.101.201.61 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784236395;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bA8jHUfmeiY9ODIQ+oQrdalET7uV5CJGJAq9giAeSTw=;
	b=C2VT/LH94bf3QXfIUbQ3FinLHzISvEsoCN0HJxtGuPE2bJXuKPoXcY+LDzA/EbxBMnjS+4
	ERW6G9xwxvsN5HyAWbe79m4b6ToY2avw5F0tBAlaR93QoQodvqkTSSO3g+MDsDFwikXAyR
	O+vS3wYHOKNsrc/cdmK4wsU0LmTxno0=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1784236395;
	b=m44swktREq93wLjDomZz3M121rxaazl8hxraf2wOf6dIn4Xw4JFV8DFARYU39UhoPvMu5L
	F3o8C0b5PE5cEYgYqS04SJzI8W75bP6L5SFsLb5oq7d1/fdTzaZ9sGVNHWDmZILpUwuuzz
	7B65Pn0+/odDuiAhTMbj8prSu6PmLcQ=
ARC-Authentication-Results: i=2;
	imf11.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=DYWEPL2S;
	spf=pass (imf11.hostedemail.com: domain of ziy@nvidia.com designates 52.101.201.61 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=aqc3EFpBe88t8ZOcd7IkI8jLzaWwmDHihKSSiKqw2WR4qV+N3y2d/6A/ydC3oUoeJUUo56OvW0JrSh95W9Dn7Cw1fG3wI0pnjzz5DsjHLc/2nZJMSa6Yrr2g4A1ltDhBzFrwc5xC0jgQy0qY4xevubD/Td3SGAr1stHaRmfEEnXaqGz9SKWQQNxUfTh977TkOmqIsXxvEuQnFcsHuQYh0cWeCvKDz46/hGhC6aDSqMtxWPDl8VN3pWuaaaXmWfCjodQA0fex+7DwRFwTwAV/ZNGHrZmPLIfCcXs8fToOF1AhRFX6sVc/vC5sKLnkELq9FIqCE/KCEaY4jNvM48YRiQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bA8jHUfmeiY9ODIQ+oQrdalET7uV5CJGJAq9giAeSTw=;
 b=jI+TRtOUNzsGNczJFMfp2j3pXdDiuvpIN9Ymi/5Qz6jdW37ZdptbZt4l+tY8FJQHteuWuM8PBNhQfLkol1mqZIWaV+lB72XBO91L6jEuI91/YRfb9APsCQpRW3Uyk1rHAAuG+5TG+AzO9zrWuO0DoE7Dsvuuh14BAAznOYPf8ZU1y8dRMMS5NLgMh+0yWrbmMaduPsmt3tUn2g2ZQm40KC59PEhL3UE+zn3BBHlWSUvmvQdmwA33qzQrwAaQHY+8hs1E9s/2lo8If1d3MuIpDiDkdb68iSs0tL+KmaNposIuvd/P6XhyEz9zqN1TguHdsp7YmQLtvhMDf43CcZGxPQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bA8jHUfmeiY9ODIQ+oQrdalET7uV5CJGJAq9giAeSTw=;
 b=DYWEPL2SoDLNnCthPvmWquXvu2Uz+Nbiubr7CGDFfgqJE7HZ+gJNzkBleRWF+I7MwNcC4FBd3s99uuhVUAQktrvD/7N/FAg7Tp95z8oZHWMPi8Y/4id5yRTGyBQfMq+bNPr12+ojam5zL6jfUndy3XvTi/RE0CwSaOAwv67+2uJtJG+7PFL6aU1/tXNwUYOr/Ak7nOm2FilImoAaQFiWRUFEPGqlnTr1rBYVl5K29yARar+T1UAutkyKvsmIPdBMp9O0DWMKWVfZMw0qPdSmNXcURv6YiO/7XBIK0sSRDNfgfntZlR2AiRIjlvOtLCEdr6xCMmYZ88O0tqGKoTISrw==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by DS0PR12MB9424.namprd12.prod.outlook.com (2603:10b6:8:1b4::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.223.12; Thu, 16 Jul
 2026 21:13:07 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%5]) with mapi id 15.21.0223.008; Thu, 16 Jul 2026
 21:13:07 +0000
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Thu, 16 Jul 2026 17:13:06 -0400
Message-Id: <DK0B0GAV2XSN.1HKBPSTORYB0F@nvidia.com>
Cc: <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
 <linux-s390@vger.kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>, "Dave Hansen"
 <dave.hansen@linux.intel.com>, "Andy Lutomirski" <luto@kernel.org>, "Peter
 Zijlstra" <peterz@infradead.org>, "Thomas Gleixner" <tglx@kernel.org>,
 "Ingo Molnar" <mingo@redhat.com>, "Borislav Petkov" <bp@alien8.de>,
 <x86@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>, "Andrew Morton"
 <akpm@linux-foundation.org>, "Lorenzo Stoakes" <ljs@kernel.org>, "Liam R.
 Howlett" <liam@infradead.org>, "Vlastimil Babka" <vbabka@kernel.org>, "Mike
 Rapoport" <rppt@kernel.org>, "Suren Baghdasaryan" <surenb@google.com>,
 "Michal Hocko" <mhocko@suse.com>, "Brendan Jackman" <jackmanb@google.com>,
 "Johannes Weiner" <hannes@cmpxchg.org>, "Alexander Gordeev"
 <agordeev@linux.ibm.com>, "Gerald Schaefer"
 <gerald.schaefer@linux.ibm.com>, "Heiko Carstens" <hca@linux.ibm.com>,
 "Vasily Gorbik" <gor@linux.ibm.com>, "Christian Borntraeger"
 <borntraeger@linux.ibm.com>, "Sven Schnelle" <svens@linux.ibm.com>, "Muchun
 Song" <muchun.song@linux.dev>, "Oscar Salvador" <osalvador@suse.de>
From: "Zi Yan" <ziy@nvidia.com>
Subject: Re: [PATCH v2 02/10] mm: provide free_reserved_pages(), removing
 x86 variant
X-Mailer: aerc 0.21.0
References: <20260716-bootmem_info_part2-v2-0-4afc76c73d61@kernel.org>
 <20260716-bootmem_info_part2-v2-2-4afc76c73d61@kernel.org>
In-Reply-To: <20260716-bootmem_info_part2-v2-2-4afc76c73d61@kernel.org>
X-ClientProxiedBy: MN0PR05CA0011.namprd05.prod.outlook.com
 (2603:10b6:208:52c::17) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|DS0PR12MB9424:EE_
X-MS-Office365-Filtering-Correlation-Id: 1341bcd9-2a73-42bd-e7bb-08dee37f0862
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|23010399003|366016|1800799024|921020|10067099003|11063799006|4143699003|22082099003|18002099003|56012099006;
X-Microsoft-Antispam-Message-Info:
	zGXV5iDgMz+p+cQ1TmUBAKR4w91QuT7vWjgaA0LKVK0/n7C+FtBjziqCBd/rqEaET2RbDsZM8VFKSS9+G4A2PxquyUpQuZHc0qFZAsv3XTjwGHnxVCMsgpTI6DYEMaVra5wUx4hOzPd8glfVC/PkoNgpUcog6hcGdoR16hyAIkWCW8RWwZNNgupL8cVVjRu4YgU+v2WR5qE527vcPYYZlCcR1AFm4qYLx3Uhl3nOgTRl67hRSM7HhJhZbtOE+dGnVsKr/ka3V7h1buQgOsoGg8uT10dVIgaYKC+1j3bplX1RjY29m8IuRP7KfC1VLUcWkyfNPKR799v3AAtZP1pS/04wqAVEndqdjqEpg6KkIaezy7r1cb7fpysUa47F9API5Bn3XHaDj5xiZpQpXIAkPAwn6Z76fUhAONtm7aCU0ZPpBJvVKo3tdoJR58elWHaE906PjB7egdNLqaSbdeU4iG88zJHE3cwUrYUf6Lu4eioWz737dFyKHTnBaX8q3skvJwgjIFdI06A3iFlo4VfYUd5G3xMTycXGkJrozTOYdkm6dJO/iM6KLJHo9R3BHTMaJ9EjAs73oA3MUMkFWahZ6Tf4C2vXe6Xkv0TJXRcqWbU/f+iV8IPy2YodWg2tSH2StiH0svqjfayjABB/O7K0174Ue7wnduEeQlUspZg83wF2rTnEtPBV9/5Wwbpjx2yjHyOceZPhrBcKk3FthiuG5g==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(23010399003)(366016)(1800799024)(921020)(10067099003)(11063799006)(4143699003)(22082099003)(18002099003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?T0NNS3VPQWljSUhNcnlzQk5MS3ZpK0ZSTnpaWVRTTXIvS2RhMFhIc1N3YmEr?=
 =?utf-8?B?enF1SXF2YTdheVY1N0VOdTFmUVJpcDR1V0ExRU8zVndtbGlGa2xudTBITU94?=
 =?utf-8?B?Ylk1T05DVS8vK1g1RGJUT3FnMS8xTVRyNXlEYVdPRkpVKzdvNVRhS2M5YU12?=
 =?utf-8?B?M2JIVDZBOUpVR3Z2YndSV2kxY2VQT3dEWUNvTXhPelNEbXRHajRubTBjZFhB?=
 =?utf-8?B?YXdQckFEZmhJcGRwcG5GVlN4bGp6WGxpdWpWckpCK1dDQ2NuZzN1cXQrN0xn?=
 =?utf-8?B?eGs1Rkg4N3V4U1VoeWNtWFFDZkZNQVRNTC9OM0dvU1R2Uko4bXgzRGJkTGg1?=
 =?utf-8?B?dzJsU2lEUXV4ZlVyd0RJNGRVR3pSR0xRbGJPRWtRN0lnZ3g0OVgydy9ia3Zs?=
 =?utf-8?B?aFQ3aGlzeGQ2MmZ3R0dsVEUwb29xa3UvdkxsY3JwTHFGZ1oxcmNBQ2hTRlhW?=
 =?utf-8?B?QTh4QXV3ZDdUOGRYZytjUWM5ZC9ibmdXTTliVy91eHR0Y0JEMDJya0JNN1pa?=
 =?utf-8?B?R2I4T2I4UVAyZW9sNDc3UnJlSGFtbldOeEVZczhWVGFMY0d1SkFFeVFEVmlv?=
 =?utf-8?B?TEVkSFZTWSt0WmxLMVczbmdhOEozRjZnS2p3SGh5dnBFRjdLT1dKUElkTXlC?=
 =?utf-8?B?UUJaU2l1Z28vTHA3N2ZXdzh3YnYxWEVQZnowenNLTk5LbU1ScGNIdm5ZVXM3?=
 =?utf-8?B?RDlmK0tVNWYwQ2R0blBDRGpndVpNdEwvV0V1Zjd6N2xpSkFVUmgxR1dUSFlL?=
 =?utf-8?B?dkk5SnVJQ3RJMnk4ZmtXdTdUS2VEc2RTM2Q3bDMxTUpQTGtBOWErVUgzaXBZ?=
 =?utf-8?B?Mm11aklVOFFyOEVpUDVkSk9qb0ZYV1BQMkpyNEVBMXczOWwzZXdmamlaVVdm?=
 =?utf-8?B?L1lIeDdSamx2dmswK3VKa0lIaW9OV2ZIM3oxREloaDJCZ1R2MVpXWnF0T1lK?=
 =?utf-8?B?Nmd2K01CMFo5dVlVMDdlVFZFQ2F6UDBGSTVHZlZ6TG4xelpsdVZjeHB3YVcx?=
 =?utf-8?B?Ulp4TTZxV3pFN21wYlRLTVVQMHF5U1JvYVJTL3ZndUVvdHlwSTRPc2p6VStC?=
 =?utf-8?B?N004NXBhMW1kTWxjQVUwR2RRQVBqODFpSVpGMlMvY3BUUmEvNU1YZEZIVkF4?=
 =?utf-8?B?VEU2K09aS2ozMHRmamcrT2ptWVc5MWROcHFxRjE4OTVvVGxOc0NkSDBkT2kz?=
 =?utf-8?B?Vmo4Q0NscDFscHpkclR3NnZJeUw0N3A2YlNOdGdraTJiVGsrVEJadUFvUkk0?=
 =?utf-8?B?TjU3d0JMOURiUzk1aDAvT05TVUlQRis4Ti9laHE4WjVFYnhLS2pud3M5czZo?=
 =?utf-8?B?NHhLOUZ1UFk5OWRKTHNJcHFZR05nTktMWmtaQVhSMjdUaWtOcnhHRlBQYW1U?=
 =?utf-8?B?WkRzbTdtWWxpYTdEWlkxQVZ4MnF1V080cTVOQklOT094VUV2OVZNOWdXK2Ra?=
 =?utf-8?B?TDF6QkRxV1E0Z1AxSnc5N3N6UnFYTnJnMzJMcm8xZlpkTUVLYlV1eTBFMEsz?=
 =?utf-8?B?NHJMSDF4WE5VeGVzTlhrOUpRSEFmajFJOE83NS9Lc1hoamJCZWxYbmpTRi9Y?=
 =?utf-8?B?SzI0dWdYTDVHZElLUGdQK0pWNE9DNndhaXVvdm5XS2ZEb0pLb2NPNnAxWnRL?=
 =?utf-8?B?eWlIelMxNHRFL2o3NzRZdjEzZk5CTDhRdUR2VFl6dVBZU1pXTHpvbmcyNW5x?=
 =?utf-8?B?b3ZpY0pwei9DQkxhQ1BhMGIyMXcwSUdrVzRzRnFIN1hGdHRvMW5HQk9EM2No?=
 =?utf-8?B?K2ZMcGdEeUx5RE8vVUU1dUtJSEN2TGhaR0NJcTRKRUNKeWRqK0Y2Z0lVL01n?=
 =?utf-8?B?cExOV2FrTlRSc3hKTkdqcUNmejUwenlhK3pWY1R4Y09RK2FsbWREdDVxaVhJ?=
 =?utf-8?B?aUJhc09qQW93cENDbk5Lc2JibFRoY2R2SWNWaFhLWDgxN0RwVDg0Z25lMkNm?=
 =?utf-8?B?UG1UWUR5OUpIVFJ6c3R3ZEgvMGxEclZEL01WL2Y0dVlMUzZtdWxCczNUNi9p?=
 =?utf-8?B?R3hiZ2ZpNUQxQ0gzVzNEeE10U1pnOXN3TkNVUFcydGdJZFpTdHdSK213cmsz?=
 =?utf-8?B?cytHQkhaRVZhRkR1TVNGRlRyaHp0eWh0WmRlWFJNalFTZzlacGJ6dW40MDRx?=
 =?utf-8?B?ODE0V2RTVDltRm5PWlgzeit1Sk9Wd3FQeUYvSkx5MUtPcDRSNFg4bm4wSWt3?=
 =?utf-8?B?SEdnVVBTU29zR0NXRkl6NVNEM0tTd0RjUFBLWWNjQ1F4TUpGT0dIUklvekNi?=
 =?utf-8?B?bFI2YlMyRDQvdTdsejRQUmJSaWpaV2QxZlp2djFIZUl4bkk3TG50MGpHQUtE?=
 =?utf-8?Q?nBEU6kWdw05LT3MgnI?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1341bcd9-2a73-42bd-e7bb-08dee37f0862
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jul 2026 21:13:07.5360
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1miJ0rrYcqyX2erdQ0ze8URwLqkmJDCJzPzgj3xjNP8Rj6WSita2aoH3djC4XioK
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB9424
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 7E8704000A
X-Stat-Signature: etjuwfqmmjq4z3g5qa3x881kqan9hhxn
X-HE-Tag: 1784236395-224958
X-HE-Meta: U2FsdGVkX19Cf+UWtA1i2Iz7dk/aGZDwFHcgkNwCGqW1jlHcTsB2O373ysea1FoTF8ZpVBczMqHZ/zHXr5d1YgaCvNzWwnWkVQG8h8yDAydpZ+Ima+zA+HoVYkXB+or7AkvIzOSL2ZwF213VTeY7XDKm5w5uPP0LUXNtoiZaQpEapXErexpJL6rtwPI0IgAkTz6aVEmYfspbE76Hib8raru1wEcLny5y3yXKFi0F1CtEe/N94iuTlcXH3o3CHSmTWfHR4w7fZTiZX8IYFPs30EznEfGI9ILP1GdxcqFVrFhNDDVH+ENhoQlJdhA19qufVKG/M9nKqeNDQv2jxX2Xefok+v1E3TFBqExvE+tGWf+5DJMkmCm/SI0wfFNjfvEl9m2a+OGTsN60206EhSYD1CmpXenMzFpg/CE9PxXEF2iM1bkPA9bGKw0iYHz8vCDPi2cuts6Zir3cKJOwp5bdEgIMPePT+5EbThLi1u1L1qcwrWqe1R6bDuQwU+9Di5Vnz5qwQiLhJT0c+BrlNCU84A9wpGSC1yzg+2MuL6WeSlMz8fJHCj7VTAQWYAjIHHYIsqQ79OXZSP+O2IcNUk7aaz9h+LMbnSDvxv4u0KYKSZwep0ydV7exMklgpQhVVfi5DfmNJ1xWHPR0hKEma8bNV4cNBSjE8p+CwulOBwyZe4Da64W+exrIm5fV8ws0MkUaNu9UnUzenu4J/FsxrhHBM2ZxJvGGLtjxD6WhpA/kkonJMuKkHfyfPvbzWtunRh2iOPYj84jrYcEDZJuNtqUnJ6fUSFlxg2LUX3am9NRrvo3FhTOkOUmozibkLhZZyFZkR8qwK5yAEWmpOFwgNuDshhykFdXj96BqZLduBzbdM8td/CNPQxqCVnNk7iIeIC5MJvfxyXKcMhDPLbcUsioAIqXMz1f/bVz/iWlIb5OY+3teirbK/Q3+kO4OBym5xMANBmVQA8e9sEpZcT+w2iX
 Wqg185N7
 +QylOGDSv6s1NAQOQFDPAH67wbFD0XWE58+JFItV4IyDMIEBcVhEsX/syDR002Si4v4fOhNzN1V9t0EwBMsVhPJQnn0SEk+S3Bon4j6UBYcZY8YkcPSWRvv9ySKRwPkoajMTTDlol/IaBDhx9gU/bCk3NKyWUIdo+rRt2OccDGGALoaSyljjips2YWOr22b5KOxKIVdF6pVzf+Mznz8Vkaxl4AFoysBqyO4Xe2m3ory/gjD6MAXeXks2OCUR6yehmvz0HARU6FDU85nGzS9EdsmRr0imz3usYTKiZ+TT/p6guoBIqzxAvkTFxoG9ltaXjcJfcSR7Nr8lnbx838W4w3IsIdLhH+NJMdm9gLetaB3WIZQlruR3dVhKvZ83sfSjMHfp1R3OQTk+bxex8/OkoDX0XCm0rpi1dfctcEChdNT8CyOz9iCKO+fEedjBISb32srvIXrsESFOFTbeiElz8VP1A7Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu Jul 16, 2026 at 10:51 AM EDT, David Hildenbrand (Arm) wrote:
> Let's extend free_reserved_page() in page_alloc.c to free_reserved_pages(=
),
> dropping the custom x86 variant. The common-code variant will consume an
> order, so adjust the x86 callers accordingly.
>
> Make free_reserved_pages() assume that we are freeing ordinary
> high-order pages, just with the special "reserved" flavor. The target
> use case for now is freeing vmemmap PMD pages.
>
> Set the refcount directly to 0 (instead of 1) and call
> __free_frozen_pages(). Set the page count to 0 before clearing
> PG_reserved, so someone checking PG_reserved (and not finding it set)
> to then try grabbing a ref would not suddenly have that ref be dropped.
> That is arguably cleaner and safer than the old way of doing it.
>
> Add some kerneldoc. Use a single adjust_managed_page_count() call.
>
> Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> Reviewed-by: Muchun Song <muchun.song@linux.dev>
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
> ---
>  arch/x86/mm/init_64.c |  8 +-------
>  include/linux/mm.h    |  8 ++++++--
>  mm/page_alloc.c       | 33 ++++++++++++++++++++++++++-------
>  3 files changed, 33 insertions(+), 16 deletions(-)
>
LGTM.

Reviewed-by: Zi Yan <ziy@nvidia.com>


--=20
Best Regards,
Yan, Zi


