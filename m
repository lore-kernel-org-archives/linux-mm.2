Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 528FC606A32A
	for <linux-mm@archiver.kernel.org>; Wed, 25 Nov 2026 19:27:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=garyguo.net header.i=@garyguo.net header.a=rsa-sha256 header.s=selector1 header.b=JbZE5jIw
Received: by kanga.kvack.org (Postfix)
	id 263DE6B0AA9; Wed, 25 Nov 2026 14:27:54 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 23B7C6B0AAB; Wed, 25 Nov 2026 14:27:54 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 104286B0AAC; Wed, 25 Nov 2026 14:27:54 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id CAFC36B0AA9
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 14:27:53 -0500 (EST)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 31699410AE
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 19:27:53 +0000 (UTC)
X-FDA: 85474626426.29.B6A91D8
Received: from CWXP265CU008.outbound.protection.outlook.com (mail-ukwestazon11020074.outbound.protection.outlook.com [52.101.195.74])
	by imf08.hostedemail.com (Postfix) with ESMTP id 40ABB160003
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 19:27:50 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=garyguo.net header.s=selector1 header.b=JbZE5jIw;
	spf=pass (imf08.hostedemail.com: domain of gary@garyguo.net designates 52.101.195.74 as permitted sender) smtp.mailfrom=gary@garyguo.net;
	dmarc=pass (policy=none) header.from=garyguo.net;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1795634870;
	b=gSNITCM6Lb9CzNkwy8jCgH7z5/HnECpCNeDeEIYCR+Swt5K9HYjL5DFidUNXcMyihv5gJo
	ffcyBKIYr40OS1n52OjnTB96GM/qUClWcoMOGDRqXu1/WJ5tvoEjlLfdfqhJ63Eh6MOKo/
	hLf/E/pwYSi0Zj+DRag6eMjo/MsCgXY=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795634870;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LRG4sROYrakEOSmL3Uc6/xUxMOsh5Je5fzWSQOKNIP4=;
	b=Wujcm9N1MuMOgkeZPD75YujrZfBAyY0BK+Si8LYyfM5MqyLiUBmwnlfTFzY1V5/b3RXx0K
	ILQgXycezJI0mcSB1CKRPEWPV11FO5RwvZ3Q8a340c54kHIv+RFMChPi5sKpZxHfouKkf0
	V7DElWKrJWQrG6vecDJpY9PwCs2xlbU=
ARC-Authentication-Results: i=2;
	imf08.hostedemail.com;
	dkim=pass header.d=garyguo.net header.s=selector1 header.b=JbZE5jIw;
	spf=pass (imf08.hostedemail.com: domain of gary@garyguo.net designates 52.101.195.74 as permitted sender) smtp.mailfrom=gary@garyguo.net;
	dmarc=pass (policy=none) header.from=garyguo.net;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=UEkfIR8XA4RG+MX6Yj3DTrEX8n2xN2b6za1RoJl/M+geC8JcBl2uwIK1Bw9reiTJFOrOPSOS/NWlorHqqFZ8/9L43nbJJGrc8KPOw2YZIwsHtS3xhu94HCc0rwH5GTfZKibj/fn6Bxs/Jw1TuWNTr3nGD2KE2+duWqS1PouYiJw8Z1fzyBcjFsuytOK7I0l+qcgzbqijJXlNkTGR7NXUDcMz/J/fXaiatVNYCxH5M6HCoW3jSN7M18RlO7y/f95n0f36BCoSEu/glbpMz5fupTI6L9oOHn9r47ymNXqZtoZoQcuD+8t3HoAduWsg2jX7E41Xcgy+Yx8NTsk7X21I5g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LRG4sROYrakEOSmL3Uc6/xUxMOsh5Je5fzWSQOKNIP4=;
 b=tqlbDhkcIk/AkWa+cvwzB03a16Q31dcpGoQC0ZFHe+eBmyrmoNYYSt4wF8l1+V2XA1TxZG46a9ILWvsCe3a6gP5w/pUtWnFadnFcyssKe4w+959NOC5ww5rDnIjxLnpCJLRGblmPE13Th4xvmsJA4H3P/5jDSDnUtrXr7qOcG2U9Q9IzUNztEYQ2/Lk+S0cC0uoxa84BXM4T/QPuYpwb6fUGeNFnRvWDmOF83pv12dHAf+VX2Pxh4fRXd36s41UQ7mcnANP6wnOEKGXjEsmwFxtOad3/IQRvVLPCJhZ6GWNRdBnMsHK5qULMygGZ82fd8fCIoowjkLd/+5LD1VqihQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=garyguo.net; dmarc=pass action=none header.from=garyguo.net;
 dkim=pass header.d=garyguo.net; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=garyguo.net;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LRG4sROYrakEOSmL3Uc6/xUxMOsh5Je5fzWSQOKNIP4=;
 b=JbZE5jIw/gjUxBeqQWG19b9uW9SKXsgW29WhMTRWQpmSwhUEUkicyPlgx2ST2MPXzw8hCAEV4i0fnUmSme+pk/ZEuWJv+9ptJb20xsbsosCuGEXTX+eBo0pw6N05wZiOlY1EXY8LLo90cKGA6A7752dh4U4Moqh8v2a2tbgrvH4=
Received: from CWLP265MB6051.GBRP265.PROD.OUTLOOK.COM (2603:10a6:400:1cb::9)
 by LODP265MB475252.GBRP265.PROD.OUTLOOK.COM (2603:10a6:600:4f3::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.662.7; Wed, 25 Nov
 2026 19:27:46 +0000
Received: from CWLP265MB6051.GBRP265.PROD.OUTLOOK.COM
 ([fe80::55f6:f98b:7fad:c6e3]) by CWLP265MB6051.GBRP265.PROD.OUTLOOK.COM
 ([fe80::55f6:f98b:7fad:c6e3%2]) with mapi id 15.21.0662.004; Wed, 25 Nov 2026
 19:27:45 +0000
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Wed, 25 Nov 2026 19:27:44 +0000
Message-Id: <DN4JFP1ZVV3Z.210A8I4BVRT6C@garyguo.net>
To: "Andreas Hindborg" <a.hindborg@kernel.org>, "Miguel Ojeda"
 <ojeda@kernel.org>, "Boqun Feng" <boqun@kernel.org>, "Gary Guo"
 <gary@garyguo.net>, =?utf-8?q?Bj=C3=B6rn_Roy_Baron?=
 <bjorn3_gh@protonmail.com>, "Benno Lossin" <lossin@kernel.org>, "Alice
 Ryhl" <aliceryhl@google.com>, "Trevor Gross" <tmgross@umich.edu>, "Danilo
 Krummrich" <dakr@kernel.org>, "Lorenzo Stoakes" <ljs@kernel.org>,
 "Vlastimil Babka" <vbabka@kernel.org>, "Liam R. Howlett"
 <liam@infradead.org>, "Uladzislau Rezki" <urezki@gmail.com>, "Daniel
 Almeida" <daniel.almeida@collabora.com>, "Tamir Duberstein"
 <tamird@kernel.org>, "Alexandre Courbot" <acourbot@nvidia.com>,
 =?utf-8?q?Onur_=C3=96zkan?= <work@onurozkan.dev>
Cc: <rust-for-linux@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
 <linux-mm@kvack.org>
Subject: Re: [PATCH v4] rust: alloc: add per-task memalloc scope
 abstractions
From: "Gary Guo" <gary@garyguo.net>
X-Mailer: aerc 0.22.0
References: <20261125-gfp-noio-v4-1-0f67ab9895ab@kernel.org>
In-Reply-To: <20261125-gfp-noio-v4-1-0f67ab9895ab@kernel.org>
X-ClientProxiedBy: LO4P123CA0425.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:18b::16) To CWLP265MB6051.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:400:1cb::9)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CWLP265MB6051:EE_|LODP265MB475252:EE_
X-MS-Office365-Filtering-Correlation-Id: ae893c79-1bcf-4a72-9940-08df4b2a2ed2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|10070799003|23010399003|7416014|376014|366016|1800799024|921020|261102123227099003|10067099003|56012099006|261026121527099003|261022105027099003|261026140227099003|261021121427099003|261028144727099003|261009223027099003|18002099003|22082099003|6133799003;
X-Microsoft-Antispam-Message-Info:
	BWIAIV6DdLcOj31o+i9y+oSmOhG+GZwGkMe9Qwn8uFZfOLvNnPBE9zpyi5dPHudf1qj7r5bIoDlJM+rGjcLBWpoUeLS03sVU22p9FsFqIrlnJll1wz0O4JZeZetMQ+BmrUHkqLFHJegXduP9CYpYB+LpIE+fuBXwxdsFEvq3rge71OxxIdOR4GuPN/dPPyDREZ/hHrjsrPqIJnO1M+T4CkVOouuHwfnW4+vT6b5Hq9gtCfwLxlVufbEy3GvYxA+HOV1tD3/PBUqeLpNm6ubwqyKmWnr4xN8jf2tdojlQDGwz1p68JZx2eCYfwY0SXR2PwFkFfcZN/s7HcvTQecvZpeHiI1I19hSmeK3c80yTNf0FLQizQjjtXml+UrQm8w2rHP5DnfLe73VEZtz9+57VgS5zCThkt265rngavqFKsD87ty76BHaVNzvCHeMHTGvNo/X9Xyrp6YROyEQeJaQtv9sbrzLOOvkglZWMQLUdkbCEooztksqYsk7jd1AXAaR9+aI/y7mrI8fSI9FYxZY+pVtxNW84wvsMX/HLc/+lOfea0VfKtOhnVEtcqWoWx/UFoqWAqWWX0SjZFa9ixre/eLmv6BNuhEJ1Byum4ueXr9Vtq13IUFmTvsBX59RD+QhIBuYK7gscJCr+v1kMhsfiptNWtfC7aVXTp8wXH7Lxjbc=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CWLP265MB6051.GBRP265.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(10070799003)(23010399003)(7416014)(376014)(366016)(1800799024)(921020)(261102123227099003)(10067099003)(56012099006)(261026121527099003)(261022105027099003)(261026140227099003)(261021121427099003)(261028144727099003)(261009223027099003)(18002099003)(22082099003)(6133799003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?cmRNWFdyeWJTMDdaY1MrZ3FURlhPMUdOSE5WUXVBcmxPVndQdWJ6WitUOHJJ?=
 =?utf-8?B?c3J1dDN4QUYxT0tUVldhWlRuL3pXaXdyTjZCSVZ4RENMS1BuMWQzeUZPeXVD?=
 =?utf-8?B?R0RXbkpWZnVQbU9jNFpzWU85S3R5c1hKQmhVK1lRSDBOQXBPRWZraHNOV0Fm?=
 =?utf-8?B?T2FneXNRZkdwdUpHZmFKcFZsQmRMcktPWFN3Wmhrelk0SkFuT2k4MUp2NU81?=
 =?utf-8?B?ZzUzWjZ2cFltSnVlQTdDc1FjVy9vd3VDZDgzNEpEdzVJOTlPRWpaYzFsa0sy?=
 =?utf-8?B?WkNhSzhoMTJxOE5BWjV1NGhYTjBtRlQ4OGRTZWtyYUhNZERHTFArMVpoVk5C?=
 =?utf-8?B?NXhsSlB3Vlg5YjJrTTVvaURzdXBZbkJTRGxxYkpBRFYrN29oRmpjOTJvc0Mz?=
 =?utf-8?B?T1hBTzdIcUV3dit2NktnOGF0K0U4L3gzRWRhRUV4RmJKVnhwTGp0Ny9talVn?=
 =?utf-8?B?ejBSWUdCdWdxbWgvL0ZDekpRZVk3N3lnZ1YwaTRMYzJnbit1clpQaFU4dTZ3?=
 =?utf-8?B?N2VrVk9BMXFNdHFMZUZlTEdDUlRqSmVFSncwU3RpeWxtMnp3QWIreXNWOFVk?=
 =?utf-8?B?V3ROM3cxNzBOb3lQYTVzNE1admlpUVlYM0hBTTlPRk9LQXZoTlE4RDkwTUdm?=
 =?utf-8?B?T1Q1K0thK0Fqb0V4cXA2NTc0Y0lpWW5BbHVMcVgvTU1EYXQxbU9CejNIVXpi?=
 =?utf-8?B?Zk4wMnIzRnR1OHhPNXRTWmh3UzIrNVlyTUIyOWtBUStXNFdKQTVTQVpQR05m?=
 =?utf-8?B?Ryt0dW9OYzZZa2h5Sk1ZRDNaVytjcm01WG5CUWpqQ3NPdUVLWUdOV1pjRkpC?=
 =?utf-8?B?anQrNjFEdlhRRVZXT3NEUEU4RXd6VW1JZkRNRVZOdytQM21Ya3ZybStvMkhr?=
 =?utf-8?B?QkJma3hOWThudEJScFhWMnRsYUg2dkdWaWFrMzlsTjVqeWRFeGhZRXNhdG96?=
 =?utf-8?B?WnE1dS9Dcm1xWDNia09Wd1pSSDFyZE0xanpSamc5c3FDeHEyU0gvZFFlb2Ju?=
 =?utf-8?B?bHlqYy92NnRuSm0rQndVMlozYWVTbWtRUzczNUozekFvQ1VWQytkQ2xDMDBp?=
 =?utf-8?B?T2g1d3I3aC9QM2kyM0tuWkdoUW1hVDdZcC9SKys2SXRJRDdHa0ZGdTJuMFpL?=
 =?utf-8?B?d3kwY0lRQXliNTBaeFp4T2N6NFNWQ3Y1dFI5ZGRyTGx4NU5LcUR1TzRmakw5?=
 =?utf-8?B?eVdzZzRkWWJZbWZ2VUt6OGo4MW1kazhSeFpUS292T3F5a3ZNYVM2RHdqdTRS?=
 =?utf-8?B?aWFpMFN1eDgwQXIzV2g3dXJPSCsrN3ZSc3JDRGpjSFhRRkErSFlYMytweXBF?=
 =?utf-8?B?a3diUjJnbEdES290RVJCME9BdFFpSXZYekUrSFZLMkRJWnNsUklEcCs1aUw0?=
 =?utf-8?B?SlpTd1ZIMDBZK29ydVlsVVpTY1AwTkZhMml3NW43eVVEYmNkZXN4ZStOQTJ5?=
 =?utf-8?B?dEZEU285Z2MyZEtlQWdkVHhEWlRxS09CR2Nqb1c3TnMyV0FQUFJjcW1PY1d0?=
 =?utf-8?B?Kzc5eGszV2pCZUkrREF1dldJdW4wd0NjdEQ0L3hhMGUwdmNDYXk3RjNpUCt2?=
 =?utf-8?B?ZlJvMzN2RkR0ZzJxUHdiMXo2L2xKcStNMFNSNnlTRStrVlU1Ym9vNm5BWDNN?=
 =?utf-8?B?RGdOc1hxdTRPS2ZETFNxRHZZSkF4Vk1BOWRXNXFMaTh6UUxvL05IVi9NTzVq?=
 =?utf-8?B?V0pVYjc5eXVuT1YvSzljenJDaTBUbUFzSmpKT1hMZFNCVGRIcjYxSy8raUxM?=
 =?utf-8?B?VURibFlOMzFUSm1CdUx2QXIwVHNyM0Y5M0tHV1JIK000bDhrVWl2SDJEQjhu?=
 =?utf-8?B?U2hsTUtpeVVKYnFUZjc5MUpGWWdJb210V3YycWhRYktKREhJS1lOWWZYOE1q?=
 =?utf-8?B?dm8rU292bFEvMi9UaGk1OExqSzBQZ2hYcDg4eHRhM3p2ZWhTNTZ3NFRmL2tx?=
 =?utf-8?B?K1FIMDN5RjY1VG13V1FDSjd2eWxuRWM0VWxyejNqWHRJR2hwTVZjUTdyWmJ5?=
 =?utf-8?B?aHdLcG1FR2ZBSkprS24vMzFKeG14a05kSHN6UytOMjkxY2JNUzRwQ2xTUFhy?=
 =?utf-8?B?cmVCY3N5NmVZREs4RmZBTXpXMFZuRUJTdjNFcXNycnZ6NFRldVhHMmRLd2pO?=
 =?utf-8?B?d3crWVRqR2ZyZVRHcUd0WEcrb3FNbTVINTAzZjRTb0M4cGdhR0Nld1h1T0ds?=
 =?utf-8?B?bUdrZ0p5VGVyQ2NDQzczUW96TWlWVUNVWUZKL09DdVNWV0p5NU1zVFBFdEFM?=
 =?utf-8?B?R2ViRE1GaE11WXdpdHBUOGpMeHlNajFNQmN1RXhEQVlsdkkzc0VYbU1saDg3?=
 =?utf-8?B?YWEvMkpNdjhZK3dtdXozdENuZHZYS2svdm9hcW9OcUUza2Q3bWZwUT09?=
X-OriginatorOrg: garyguo.net
X-MS-Exchange-CrossTenant-Network-Message-Id: ae893c79-1bcf-4a72-9940-08df4b2a2ed2
X-MS-Exchange-CrossTenant-AuthSource: CWLP265MB6051.GBRP265.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Nov 2026 19:27:45.7516
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bbc898ad-b10f-4e10-8552-d9377b823d45
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: J6DVKIO4v4hbHpcGzBJragthIodMDwMWZs9u78Jn+TF+cskHlXeTbBn2Pv+8acHSruXbegISCcISQIfJ0mPPHQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LODP265MB475252
X-Rspam-User:
X-Rspamd-Queue-Id: 40ABB160003
X-Stat-Signature: ibjk5w7jroa8d8s1n6y3ii6ddwukd4a1
X-Rspamd-Server: rspam12
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795634870-118345
X-HE-Meta: U2FsdGVkX1/qEGxC1JuCtmRVhYR486mRUhi2ZFsMBPKYX/4ASLx+zSQ/Fg0x1RrQuGUAHGW7Z9015MbIJMczM9X+NUqDDT3FTjl3rVJF3K7CbLFOL9pm91gfmIKTY/sf+bm5DFPlfInUUz4qmXGk2M4u8EKFinXI18djOQhHSkL1yWiuB+9O7N3T2Hx0UzsDaYg1UT0srvNwDkzxa/k2P0WFyE7QipIQgkymKxYfFB5fqBrLxOJdXn9Y8uFbTEOvB0VogSFyfWwyHMnmy4tm/4tYaZZrAiOQAZFgq1Q00YQtw24bXaQEa5IE7TxFDiu4qLIknkN1T/+boSRs4My287R1VLTTxpirHDovnx7+DIiGPli+UUkxAsOCNp2Mt242bZ4C+CfTm/GWxFVPrBENwzE0AgxGZTkh+pjuiau8TgRtqq61uF5TTyZc4gaTEi6g9+Xv1KrjO9t+MCujWqhHpgevAsTzpgiq44imVi8WRFuZxE5BR3YgoaGFjKua0NSgZfApFb3ujA8MI/7DqnlEDOs76VxkvrpcFjYYJrqnZBvOv765frD2jEbXr+oA9E8NT8VPIm1pD9Fc7wvNUZkO29r4YW6M6PPfFw43DdWW4DqxLbh2inlAWxBmcPUYJqk2bga18/Tjl2b7lyvQjrIlO1uyAQTCQUhV6cf4WQ6dCllIOaX2j/dsGr5B5V+VuWf5/uPMUhERGXbOhqG6QF/75SJlpwtVRJHWg0lt+I1KgckACr4SfBpxhqMo2x89kzJFmUBF7tb8B01+ogtuwy2QRi4Gka19Y2fnT3dm1q+8woxeToy4fcVYruYOD3bzJdCvMFvYoh/H1RRrDs7rdx5zSijIZWultAoTWauQAlg+//PBCzhNTYFDKNT/Ij6wN4JWCF4BpyUG1Gw3ncgkWFboaRCzgggOq0Z4YIHbe60OfCkXDKaWKYa1vI9XSJh1bCDjCXyFXVIrZXdZR5/DegF
 gPjCzkgZ
 NbuU02mFKKV/htzgYqupbNGiDVRqPrjdUgIPxT4W4OqEuRFacxo9gjOmWYrnvt5iGqxfOBHfnE11i3tSRJODNnHXdu+vti7apT5WjvWKhwTDGrfupA1T6FoR0r0+Wb2P+yXGtcd/2gpWiDb9WALYiWQsPx8YGhKdkstDlY1ZSukhwUSCHmk9WAWGSr1z+MzH+skYA7+2tzEKeoVHdMCutRfSgdpROW8REd9beRBMvvNfNYDtYkbzw6ZDbMEAbjyYHkPyugSKr7MhVkL70/Ry+YP2OxQ6zM7de1PCmD22VdsOsiidiqC/Ql+BWSYhV1h9vfgjmuJtzC89udytcZ43Rm//EXWeEdDYRWHw6YMAKSvsRixS/LZjqtL872liqSjOi4Ne2gI6o0065PP5A+KQuRpGr5ccjRrTye/VVyDK6h4IEU3bT8UrQ/O5GZ3nIbyrSxFwVuEeB3KhRiJ5qaX9rd+uO8oaPL0L5uOCiVKHnP0+L/7/OcpvDlApHH62qaLCnG2VLIxpGpXhl/VbMkjpxRVY3Ce23tqSEiq1GObFLNiNAUkB/YOjype5bi7TTBo7zAPoZPqFedwLKRp4FobdwyxZ3rDnfpixfF2C3Kq32585BUfAokIvt65+FffL8gMZP2uF180CFxjVEwLvbwltg18iro9JDKizw00BZTFBL0VEarVzDxeKiNBBWTHT7HXbVwnWvJrQl1R/kj14oGJgi3fS2T134qhsyiT9+ignM9kPxiYns8h5wMpbPlrwG/rE+YD6PPAKzIptQYrG7aY3r1sJX0BRFPPRmE/vhKs6If2AkxFM9gofLXXuKRMCaIMlqspPPixzVbRMPyqHIprjQQozo3YK5AMgwi6Ey7NFtvd1VnsQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed Nov 25, 2026 at 7:10 PM GMT, Andreas Hindborg wrote:
> Add an abstraction for the per-task allocation policies exposed by
> the kernel through paired save/restore helpers in `linux/sched/mm.h`:
> `memalloc_noio`, `memalloc_nofs`, `memalloc_noreclaim` and
> `memalloc_pin`. Each pair wraps `memalloc_flags_save` and
> `memalloc_flags_restore`. The save call sets bits in `current->flags`
> and returns the bits it added, which the restore call clears again. The
> pairing assumes strict LIFO nesting; restoring out of order corrupts
> the per-task state.
>=20
> Expose each policy as a variant of the `ScopeFlag` enum, with
> `ScopeFlags` as the corresponding set type, both generated by
> `impl_flags!`. Add `alloc_scope`, which applies a set of policies, runs
> a closure and restores the previous policies before returning. The save
> and restore operations are not exposed on their own, so safe code
> cannot leave a scope open or restore out of order.
>=20
> Signed-off-by: Andreas Hindborg <a.hindborg@kernel.org>

Reviewed-by: Gary Guo <gary@garyguo.net>

> ---
> Changes in v4:
> - Replace the `ScopeKind` trait and its tag types with an `alloc_scope()`
>   function taking `ScopeFlags` built with `impl_flags!` (Gary).
> - Replace the per-policy C helpers with a single `memalloc_flags_save()`
>   and `memalloc_flags_restore()` helper pair.
> - Do not expose a safe/restore functions public (Sashiko).
> - Mark `alloc_scope()` as `#[inline]` (Sashiko).
> - Link to v3: https://msgid.link/20261109-gfp-noio-v3-1-a573e7be9c44@kern=
el.org
>=20
> Changes in v3:
> - Rebase on v7.4-rc1.
> - Replace the pinned `Scope` guard and `memalloc_scope!` macro with a
>   closure-based `ScopeKind::with` entry point (Alice, Gary).
> - Make the doctests compile and run under KUnit instead of `ignore`.
> - Document that `NoReclaim` has no effect in hard interrupt context.
> - Link to v2: https://msgid.link/20260605-gfp-noio-v2-1-cfa2e236c2a3@kern=
el.org
>=20
> Changes in v2:
> - Rewrite the patch to use scoped allocation flags instead of exposing
>   a `GFP_NOIO` flag constant.
> - Link to v1: https://lore.kernel.org/r/20260128-gfp-noio-v1-1-9a808fc49b=
44@kernel.org
> ---
>  rust/bindings/bindings_helper.h |   1 +
>  rust/helpers/mm.c               |  10 +++
>  rust/kernel/alloc.rs            |   1 +
>  rust/kernel/alloc/scoped.rs     | 134 ++++++++++++++++++++++++++++++++++=
++++++
>  4 files changed, 146 insertions(+)


