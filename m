Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9EA0FC5B56A
	for <linux-mm@archiver.kernel.org>; Tue, 11 Aug 2026 19:39:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 811A86B0088; Tue, 11 Aug 2026 15:39:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7E9546B0099; Tue, 11 Aug 2026 15:39:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6FF226B009B; Tue, 11 Aug 2026 15:39:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 3C08E6B0088
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 15:39:41 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 761074022A
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 19:39:41 +0000 (UTC)
X-FDA: 85090003362.12.C841138
Received: from CH1PR05CU001.outbound.protection.outlook.com (mail-northcentralusazon11010026.outbound.protection.outlook.com [52.101.193.26])
	by imf15.hostedemail.com (Postfix) with ESMTP id 8323AA0017
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 19:39:38 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b="q7/Qxrcj";
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf15.hostedemail.com: domain of ziy@nvidia.com designates 52.101.193.26 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786477178;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WGIFXQeoykY0BzTc7800gvnjof56C8Obolu9GJvlt1g=;
	b=3qnkiCzEHT4XZqwji8j1u8z3ZdcbrXwWE5/PcOwpkMP1J0MqREtVi6GS1RlhXf7HzmL3MR
	gA9zNAzYbRrfjSFbTOp4rjwdSh+R3VnyKXTCM1M9cyLT/rRj3Bvv0wydwU65fi98rdU9p9
	EnucvfUDk+CJIDXWPSgYurFw2THjOFc=
ARC-Authentication-Results: i=2;
	imf15.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b="q7/Qxrcj";
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf15.hostedemail.com: domain of ziy@nvidia.com designates 52.101.193.26 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1786477178;
	b=XdYrMUFW64cvd2YkI+cpcDrlCCVSPzhZ82HHTeAkDzuomwWRpQ2g6XQI0J+hOVeXfRvJG9
	31KVGdixRtuakOP1XlAuUK7tHLvwa5ctuiUOflalq2SLEgoF3AS0bn/kxvO0pgHajlH26V
	0Ace52RKk0Jd5o9Lz33Ze3yIOrrbAIk=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=B9pYzIDN4Q5uHyAsFrgw/34VDTu2e9MhuJgvRPJ0x/TSx7yD2rFr7lsNQ/wanp8wRto39GVvPxda6xXj5cx0qXQHDzwlGoICJ9fO/jVHvUuHCBvZCYQ4wHANDiE5JWHH03UmcR/qcPNbWUm1dFV3ikRlOJualx78fcBteyYOwSWPNd8aXSXRKPhNUl1fyJFY5H/XXjoVtJYDs5Stwa0Q9ECGS1+k4Q6PBfMAxzxr2WxE2POICJ9ha57BRx+zFrI8udtzkYLkSWxPx2dqvRFKHBrt1pL8z+vPGmU6TZ5BQM7G3ucZwzP3yKQDZjj+sR3KUEIqygTMcc4ZpzrBj8iOsg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WGIFXQeoykY0BzTc7800gvnjof56C8Obolu9GJvlt1g=;
 b=nJc3tgAp2HeOjPUi0dz7A0ebi+/1hsMBVpya4uLExOFwu+90JMtp8ziiUty62NIRcmlBxbA1lZOucxNx+pMb8C2D+luhvZw82yxUpkftebFDHdykOA2plu/OfyQ7cdqpR/EaXZVNNH9CZx6a4bxgl5AYtngT9lYO38jhfvOPL8NrOUvmdTJ2qMnUReHd04YQgAMFo5YTR8QAOQfofDaAp+7UqlOU/624Lk3Oz+QEzwiHh38EnmTvFcevAVQVvgVhjS4XwTij1f825vVeUAL6H5gr8+/FgexhUD/AfnHMMFdmK2FyqXEC98Q5KvsoRzrV3QT5tevI/tsMAMvZIDwmNw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WGIFXQeoykY0BzTc7800gvnjof56C8Obolu9GJvlt1g=;
 b=q7/QxrcjfbOhy9zvnYBpyWmjNtf6RjgI729QrE7PHtNiw4jcBewZq9FseZWT1KM7tL9MSOUWN82CfMF1cUPRJL9p1c+gOqma2/RddiRpH/MZy1AwWxYfOGf3OS/SouApUKdFMSsMmLPWvEDGCtB76pQDLRJL5/GEdzLg/NaNKq3RMhuoAgRl3OUx71ze85WA1zDzCU10xBODU77gE+8gP8ISnEUUxthDgvcu64TaxiE4Ffayf6bARqBnJS+UN/v0xDxwowjKVNHaVKM18J/V8S38mljeXf7Cy5aOKZ1Op0EwEkI+fUQdEzjcKzERS3IB9Boq2VR5y6jl578+91uw3Q==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by LV9PR12MB9781.namprd12.prod.outlook.com (2603:10b6:408:2f6::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.315.11; Tue, 11 Aug
 2026 19:39:35 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%5]) with mapi id 15.21.0315.011; Tue, 11 Aug 2026
 19:39:34 +0000
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Tue, 11 Aug 2026 15:39:33 -0400
Message-Id: <DKMDAZLT402O.2EXGHD0HWB6GS@nvidia.com>
Subject: Re: [PATCH 2/2] mm/page_alloc: replace custom bad page ratelimiting
 logic
Cc: "Lorenzo Stoakes" <ljs@kernel.org>, "Liam R. Howlett"
 <liam@infradead.org>, "Vlastimil Babka" <vbabka@kernel.org>, "Mike
 Rapoport" <rppt@kernel.org>, "Suren Baghdasaryan" <surenb@google.com>,
 "Michal Hocko" <mhocko@suse.com>, "Brendan Jackman"
 <brendan.jackman@linux.dev>, "Johannes Weiner" <hannes@cmpxchg.org>,
 <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>
To: "Pedro Falcato" <pfalcato@suse.de>, "Andrew Morton"
 <akpm@linux-foundation.org>, "David Hildenbrand" <david@kernel.org>
From: "Zi Yan" <ziy@nvidia.com>
X-Mailer: aerc 0.21.0
References: <20260811172156.356053-1-pfalcato@suse.de>
 <20260811172156.356053-3-pfalcato@suse.de>
In-Reply-To: <20260811172156.356053-3-pfalcato@suse.de>
X-ClientProxiedBy: YQBPR0101CA0324.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:6c::28) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|LV9PR12MB9781:EE_
X-MS-Office365-Filtering-Correlation-Id: 2ffa9bd8-58ef-43b1-516d-08def7e045a6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|366016|1800799024|23010399003|10067099003|11063799006|4143699003|56012099006|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	F3m3/a6LaY3HZV0s9JnF+tGRSG4mzJt2S0y0MRfsCpzVBAIp3uMg8C5Rxgqwh04KO8hO/9Qt8urywFwKIzVYaElIqI00dr5WdDImJ/nCGHu7OuNMr/4YNAuV0KoVqGe568WEZnJmhaR3NHB5vsDiwE7MTFihfD1CYp1JKgR9vig7JC+P3WmWUXhSzHMp8T5Z0PEEWlZ/p9ic6MDH0zrEiSQyVTZ5mK2UvafQxfjDv5uN4wriSIalMLW/SjxI/LqTI9p8vVWsmjTflcVZKDKZ1N8NSoFVSD2KJzQJguPIot+fRptlh5FhTY83qKgJZPo8vzqgZRgV8hlNPBU89TVceK2bYC5DjHXoS0wqzurIDDlaCuha+xuBCKqtJ5mlp9J9yx42cJ3cpoWQRyd0V4e/fln4iIWMghVBzyjjplo+pyqnzG5T9YuAUNrtxZbO1sGclfjgtc0vDYwsYGVm5yhzC7kjL04OI0WblxM2gL4zwZcZ1DbAeQeuTwEBM6VBTIrrRXmtHq9bfTu8ST+8oYKk8c17Ik4uSGWAB7SnE+1jZtNj/mFZm3/RZ0xBKqsSGhKS+YJfajKTKpp4gRcJ8+aioQO2DXDXZNwisExzzgULps3eSBfH3Xnte3Uamc6QhgG2cApMLVmSKirA/eU2AhIS7IjgSlD2nwaxdq2c3Pr2Ajc=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024)(23010399003)(10067099003)(11063799006)(4143699003)(56012099006)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?MXV1VjUxNjVQSDRJeGMrRDU2OFZoUEJoalpQN0FDY3pRVyt3K1FEY3AvdU00?=
 =?utf-8?B?ak4wMUZFNmVLMDU2d285SVhYSnVUV2I4d2NZMTJoT2IrczVua1VZODJiZkw2?=
 =?utf-8?B?M2lGOE9NaE5xTzc0L29JNU9IdEZkQUtDVWkvTSt3RnQ4S3c3RnIrWjNmcGdr?=
 =?utf-8?B?VVk3STFQK2RxZlM5czMzVHpJTDc5S0I4MWpIcVhtdmc1ZldDN2NMWU5reW5V?=
 =?utf-8?B?SWJ2VkhPemR1emdRSVZwUXA4dGw4TkZRaWl4ZWEyNlowd0tiTTkrd0E1NUs4?=
 =?utf-8?B?ZDYwNmtMTGVCSzBaekVHM2cyNXFtVEhoM21FZE45SmhvR2pFWFlXV0F6Qk93?=
 =?utf-8?B?L1JadzZWS2xrTU9RWFJ4RGJnSEIxL0FSQXUvK0pDQ1E1ZzNvN1VxVExnTURn?=
 =?utf-8?B?MURyelFRcndDMVJpcXBxUjZpZ1FIRkdlMUExOVBFbW0rVlFvK2ZiUkdSQngz?=
 =?utf-8?B?VlBFMmEvdXErc3h0TEc5YWtNSTVYeVVsSEdMR2RTTktsUEZWbG5UZE80VTVX?=
 =?utf-8?B?WXZpWGV5VWtlVmtKNXZhR0dDVkwyUzl6cGY4N1AyL3hVbTduZWltclMxYmxr?=
 =?utf-8?B?UkJvMFBwMnRRRUtjQkFyc3JEdGx4d0E4RXVsSHA5UGJLKzh0WHRST0RJejNG?=
 =?utf-8?B?czJTRFpHNWRrNnBseXA4a2FCOFBDVitEVW5UTGt1OVpaUTQxVmt3dG9ETnVW?=
 =?utf-8?B?QWE0ZlE2UDdlT2wvcXBEUmcxWlhBQXp0VXIvcmNtS2tMbEhzRGxyWjd5dVVz?=
 =?utf-8?B?NFdlbDdqOW44aEV4RFBwbTZ5RUVkekxPdDJBVVZsMnBDNGRVVnV3NTB6cUJh?=
 =?utf-8?B?eGZ0ZmNMQjlyUHIrZUp3VnBKK2RGcXBqdXZSeTFZWHpuZlIwakh4cHdGNWNJ?=
 =?utf-8?B?NEJLTkVzeVg3bElOeXVYS2VxTlAzSnRqU2RwUkRWblB1a1FXMGwweG1ONnhI?=
 =?utf-8?B?VHJ3YkVrdndpMEtaK1RUWHFnMERPdjBNcnViNWVDUUdQc0VHb2dqRk5zdDZI?=
 =?utf-8?B?cW8wNnU2S0E0cjRyc2ZUQU9DNXcwZVZVQTJBWERLNnc0MlAxMVMwb3g1dWRa?=
 =?utf-8?B?Nk03a3RhVytNdTdiVEl4N2F6QXgyaHNLWFJBTkY2MUtjZ0hQZWlET0NCeUZi?=
 =?utf-8?B?VE5pSk1oLzF5TVBwMUUya2NaeTA0L1l6M092NFdEVHNlYnBtOHd3RWlpN0Jw?=
 =?utf-8?B?QWpsWXhZWm8rbjh1MFpXaU9mcFdEbW5jbzUvQTZ6RFgzaG9YSnFhekZsWkl2?=
 =?utf-8?B?M1JpcjRDWFBKSHBURUFoVFZzZVBTT09UT1N2cUZVdHdLakJkMXV0ZUo0QXQ4?=
 =?utf-8?B?Q0tESXpKTElZYTNWeXFIQ0hYQzZFeWJTRVhFdURRYzN0UzJTc09WR1ZDZGZn?=
 =?utf-8?B?TEZERFhGcjR2dWNuZTVWeWhXdWszWGs1cEUxcHNUMlJmS2t6bVYrVFFZRVpt?=
 =?utf-8?B?ZXdMN2dtME80VHNkbCtHcXgwVnJudHp0cDFaY0hSMXVHOVNZTkhOT3RyL3NZ?=
 =?utf-8?B?STlhUWlya2s1V1lOTHlQQ1M3WHBoaXorZ0dXcDM5TllTYlFJcGpQS21WWEYw?=
 =?utf-8?B?UklzR1FMM1VTOGtTRmJQOTIyc2hGRkVaby96UzBDcVltSTVaZ2d4TUtOamJH?=
 =?utf-8?B?WXZvWmQ3M2hOVXlZVU56VlJKQjhFVVRybm14Ri9CRDZUT3Q3UTZ1VFAvZ093?=
 =?utf-8?B?OVdEWGY5cjdvWW9hV09QRjdxbHlWdVBONmtFVU8xQnQvOS9vUzlrenQ2dCtB?=
 =?utf-8?B?WXVsb3VVejBxakxpbnlXSGV1aHh3NTNKZXBJZjByTkJxQ216b0hrOTVoQ0JR?=
 =?utf-8?B?dHZ1WVVxcVRwWmhIMFdDSzZraWp3MUxlYmp6dFJvK2s2UEdmSlZFa1pJdmVr?=
 =?utf-8?B?ay8wcVJTYWlXWUNiSmhVNERJSU5SZ3dZQU9vRkp3Y3B4Uk1wU3ppVnZKSEJq?=
 =?utf-8?B?aUk0RGhoODU1VThJZUVWVThLeVRIUUNISjVub2tzVFNSTHhXY3UzMExDRVha?=
 =?utf-8?B?MHp5c2VkdUxuK0x2REF0SU1kRWZ3R2VOZjF2Z2tTTXhPdmsrRWVOeEpGSndm?=
 =?utf-8?B?dXVUVDZaTjcxQUhHMSt1dzY3YWU0cDUvcDV0UERoVytRNTdUcXBya25Jc3Vu?=
 =?utf-8?B?YlZwVWE5ZVR3WE1XWThtRFRMSTZWT09ZSXRGbFp4a3kwWGhJRUJsc0NWMHFx?=
 =?utf-8?B?b3N4N2l4VzMxUW1XVGFic2cwanVpd0JWVXZYTXNrbEVNckdrS21ld3ZBKzMr?=
 =?utf-8?B?QldNTWtQTWt2RmljbUFON0xFNzNBQkxuZGdHTWp0b3BvMWZma0hpTEFJQVVN?=
 =?utf-8?Q?o3hWaAlY5+Y/J3t4Vh?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2ffa9bd8-58ef-43b1-516d-08def7e045a6
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Aug 2026 19:39:34.7407
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lLYEiVfzlUztUwATbv/5AY1dQaIEEz1pIH6H5nrVvBdO39lb4M0yALxlaVM84Rv2
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV9PR12MB9781
X-Stat-Signature: yzz7u94dy7hmprdwdpaoscpkbb3dfto5
X-Rspamd-Queue-Id: 8323AA0017
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1786477178-337798
X-HE-Meta: U2FsdGVkX1+VE5P4WwU8Uz4tckeH3e2efWtYFEc14c+J7aaET0iIAhHsyICWNiP8KTQklijx7TZYrVpvlblwjCRx6+4YwJNX2bR0IZa3dWwzt0qpm5qndtVLxMf2bKiMTd8RUoQI6rrhYPIwiflyUFNuc39Tt8gz8pzgCgZPi7sJiubblPDdY0pehs88CCfeFXMVkIce9MyEDEWWR6AlwVMfNejngu/FuYjkleRGEGU2NHJ4vjkkCy1D4BP9YeFfH/kknhSvS9+OWGonHaZw0Hw9kxxzmxH0EjW3jTiQuwzJwqNG8aSL+i4V5V8ITANqkRkiSzDJuNhcfBbgsjAfbItJO7VeHlGsCO8v5ZlaOsCotXNH1/uk4gZjzS6DAhfs1CHPhdxkCXlar7zxUa0/Pl09/UbHSfFaxjZ4kv9fbZ4pZAzhU7fl5H2N1s0GkItJsaJf2urowmmlPmuRLD4qh03rTcfKUVkjrBLovpoO9WdNfacnF7HR3d+W5pK7+IoSdr3x+W68BV61iV5Yl4P70jfARZ3AWal+k944clf7bx2WoRIObxIpzJgyQ0dyvfuVxc4kjHoBiRdE3cV3laPhmfOVhvCAJmfweWWBFFJPfATs2rwpw9UuSPaghqKaR0JYKPwFjrlPYxefmHyZ8NmSokmDuu0rR5hVCNNiVe83kwjOHkzWjt7trjTHolxKiJFkHnQopl1g7qOulUIjpCmhqjvDPZ5E/Nxx1B1aqJho+bUrWKzh87gXjKqCGpgO8fFcVYnnrpheUNPfLl6nB3TaKoVcXlkNjf/ZZ8Ayz3FIRiY55aJsEcZtCtsUBVDPDpbapPLD9nJ64XyRLZ0HXrPJhOg61gKBI1rKzNDS+dBg7POSkFuxrbnMVtveAQgqb7CIQz4kxswtwY1l7p9JNTCJ7HtnGdtsVQqWXgB/yqfG22Gxtp8IPRyg2XU1GlKTMe0xKeyuKy72SXCgZoUQJYJ
 yvBQxW0C
 +DRw74QQ4AyhgIJpcVTHLnje0lb4U3CvM75rnYKhXy/QAqiMDZlS0zPLv++oLG5kK1E0gcdOWHGTmIWcCDHBbf2AplaAGbdZS4tDzrbcPfyArJ2UNNFoLkZVF/PQUj/yr/nGCQju0ZqDzkRPSlvWfVpNKKzTvCQBEK3yxC+DZE0Phh43EUDjs8bDhuUp6wFyIyoZksxsFtqD+mrqJFKV+HqF+XqCaqEmGCKQ4NvJP3wiYwYQ9nMzzTdR6kEG2WcxQGTYgZzzJNlF1WwFSdzKBF7uERQgJGbmKRcbRuAGEFQxN6Egeq0xyU8WPaEuxNOMTjEF7np4BVw95zIBIzr7CmrfleQQVL98b5e3UKBSGZyB/Ue4ScGO5qBqWlyR1NCdv5H9dt+Z3oAmdHjDfuUTsVauBWIfk92Dx3x7gZsY/bD9cnXdyrjqZe1SnboMh+JeeF2tw
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue Aug 11, 2026 at 1:21 PM EDT, Pedro Falcato wrote:
> The current logic (allow up to $BURST prints per minute) can be entirely
> replaced by the generic version in lib/ratelimit.c, used around the kerne=
l.
>
> Do so. The only functional difference should be that the new logs will
> read something like:
>
> KERN_WARNING "bad_page: %d callbacks suppressed\n", ...
>
> But that should be fine enough.
>
> Signed-off-by: Pedro Falcato <pfalcato@suse.de>
> ---
>  mm/page_alloc.c | 28 +++++-----------------------
>  1 file changed, 5 insertions(+), 23 deletions(-)
>
LGTM.

Acked-by: Zi Yan <ziy@nvidia.com>

--=20
Best Regards,
Yan, Zi


