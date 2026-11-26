Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B0F36606A33A
	for <linux-mm@archiver.kernel.org>; Thu, 26 Nov 2026 18:44:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=amd.com header.i=@amd.com header.a=rsa-sha256 header.s=selector1 header.b=gqcHuWuh
Received: by kanga.kvack.org (Postfix)
	id 5556F6B05B2; Thu, 26 Nov 2026 13:44:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 506EF6B05B3; Thu, 26 Nov 2026 13:44:29 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3A7456B05B4; Thu, 26 Nov 2026 13:44:29 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 0FF6E6B05B2
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 13:44:29 -0500 (EST)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 0B61D1C3D38
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 18:44:28 +0000 (UTC)
X-FDA: 85478145816.28.CEFA359
Received: from CH5PR02CU005.outbound.protection.outlook.com (mail-northcentralusazon11012023.outbound.protection.outlook.com [40.107.200.23])
	by imf21.hostedemail.com (Postfix) with ESMTP id B86541C0004
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 18:44:24 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=gqcHuWuh;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=quarantine) header.from=amd.com;
	spf=pass (imf21.hostedemail.com: domain of shivankg@amd.com designates 40.107.200.23 as permitted sender) smtp.mailfrom=shivankg@amd.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1795718665;
	b=UFPMFzjBfNzxBtrYbK128cnCjblttMPMr6zCSu17EN4lKaM760GqIWUdWhW7kOE58GMvmD
	5Zyv3jD12GXknGXMbpzKcUkxd1qdVo6F9NCPagIXVchor2aXirXAFAgMPRlikbE0u55sMp
	Z+Fwxw2PTEGkgPD/LyPkX8OgLwwIj50=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795718665;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bqqY5Z5rol1g/Hc65Y60+6FrfUyz4bsV6STmWi9QxjM=;
	b=c87zn5Ij67kUmOLclkNnPCkNTrQRCjJNqK+dsGuu8SFpIypQLq86rAYS52akj66ztFKl7I
	UseJLWlPvaitDKuHjJfFW3RUmHDJDHRjYsPhi9ffTl7hHAe84KG2gkvMp5yAOqNTFWjwCa
	JrNXLRCFqkomakUInu7zrrZ8QG6TplI=
ARC-Authentication-Results: i=2;
	imf21.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=gqcHuWuh;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=quarantine) header.from=amd.com;
	spf=pass (imf21.hostedemail.com: domain of shivankg@amd.com designates 40.107.200.23 as permitted sender) smtp.mailfrom=shivankg@amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=N4z4XfxhVdlGeuZYxmSGY/wO3Q+NqRFj7s+SVEpq8nLI9dHuemPchAWMy2mxCy9jVVMtRC1bWoLpagMQwtwAYTyxg9mvos4K+Mk/LfO/GbcGsFzAQgcWizphfCMjKdfwql9LplUNv4Cnko8wmLO37zcq1BTdnD43craqkWXjD1230zxBEZB2qzt9gyXjBAATkPymuITaldRFV6jUfZQoxWnKkAFx/sgCixEhMOVCQaklkY+RzJHfCB/fKQ4jFoajPFDiH894whi9eReig31zLvg7CALGxHYKk7xnuElLI9EsfVAPph9is2eXDjYlFOuvr+NvOvJZVnfhG13hSIZrAg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bqqY5Z5rol1g/Hc65Y60+6FrfUyz4bsV6STmWi9QxjM=;
 b=H3bGv0/OBLK6IsaNi5A3lFImadxcPw89qX0LQbcdbua+HiB4yrKFDgO+oYY7cUPDqr39Tlprg6e8yI2gKpeCpbt0JaUXxcyxZ7ceVq7dRSePayrM284hj+aWYSyEexguZe2O+/xzHfsrNmRavrY4kqph13dSjRxprJZmOwTh9wsvqAFwuymw2WG8b1wKR7WXiQyWMEm6G9v9BAKTiWIZWTvrYT5ywq/cGfMQYtQ6+GcDK3TcCHBPPn8L59fc+0iG5kmxTSM7veMBWZgV4QgZVpkFFW4gX0fazYi4spajz5a5v8/s7U3pIOdPrtllIsHtLdjTCNPQ8ZWZAN+JcQpKCg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bqqY5Z5rol1g/Hc65Y60+6FrfUyz4bsV6STmWi9QxjM=;
 b=gqcHuWuh8IUjKBasuJSdMx3K+PxxIFRnBOMEYXhikbmxh1hc5Ik5bT2WgnsE/J2vZ6zm8l9+WNlfeDDK/qtvHb2j+NulZbaDoRdFnyfl6en1gFEJNHtNFrr/lE+XlX19AaCC0pd13c+UpmaDCjRHa1NbNScMSxQaU6uWEp5jkjQ=
Received: from BN9PR12MB5259.namprd12.prod.outlook.com (2603:10b6:408:100::17)
 by SJ2PR12MB8160.namprd12.prod.outlook.com (2603:10b6:a03:4af::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.662.6; Thu, 26 Nov
 2026 18:44:17 +0000
Received: from BN9PR12MB5259.namprd12.prod.outlook.com
 ([fe80::122c:cca7:c2b3:90ed]) by BN9PR12MB5259.namprd12.prod.outlook.com
 ([fe80::122c:cca7:c2b3:90ed%6]) with mapi id 15.21.0662.001; Thu, 26 Nov 2026
 18:44:17 +0000
From: "Garg, Shivank" <shivankg@amd.com>
To: "tejavojjala@google.com" <tejavojjala@google.com>, "Rao, Bharata Bhasker"
	<bharata@amd.com>, "rppt@kernel.org" <rppt@kernel.org>,
	"david.laight.linux@gmail.com" <david.laight.linux@gmail.com>,
	"ankur.a.arora@oracle.com" <ankur.a.arora@oracle.com>,
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
	"vbabka@kernel.org" <vbabka@kernel.org>, "akpm@linux-foundation.org"
	<akpm@linux-foundation.org>, "david@kernel.org" <david@kernel.org>,
	"mingo@redhat.com" <mingo@redhat.com>, "surenb@google.com"
	<surenb@google.com>, "peterz@infradead.org" <peterz@infradead.org>,
	"nhuhuan@google.com" <nhuhuan@google.com>, "hpa@zytor.com" <hpa@zytor.com>,
	"tglx@kernel.org" <tglx@kernel.org>, "liam@infradead.org"
	<liam@infradead.org>, "Salunke, Hrushikesh" <Hrushikesh.Salunke@amd.com>,
	"bp@alien8.de" <bp@alien8.de>, "mhocko@suse.com" <mhocko@suse.com>,
	"ljs@kernel.org" <ljs@kernel.org>, "rientjes@google.com"
	<rientjes@google.com>, "pfalcato@suse.de" <pfalcato@suse.de>,
	"torvalds@linuxfoundation.org" <torvalds@linuxfoundation.org>
CC: "linux-mm@kvack.org" <linux-mm@kvack.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "x86@kernel.org" <x86@kernel.org>
Subject: Re: [PATCH v3] mm: introduce copy_mc_highpages() and batch copy in
 folio_mc_copy()
Thread-Topic: [PATCH v3] mm: introduce copy_mc_highpages() and batch copy in
 folio_mc_copy()
Thread-Index: AQHde2cVdNDdRagqI0WgqtwpzpVG17dAtXYA
Date: Thu, 26 Nov 2026 18:44:16 +0000
Message-ID: <8ef0c61f525f3a1881d2717b1b7e43cd74d7674e.camel@amd.com>
References: <20261113-batpagecopy-v3-1-297f5b2fd28e@amd.com>
	 <7639d5f0-3dfb-4446-ab04-51317f604a69@kernel.org>
In-Reply-To: <7639d5f0-3dfb-4446-ab04-51317f604a69@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR12MB5259:EE_|SJ2PR12MB8160:EE_
x-ms-office365-filtering-correlation-id: c431f202-4678-4302-7d8e-08df4bed4657
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|1800799024|366016|7416014|376014|23010399003|921020|261026121527099003|38070700021|10067099003|11063799006|4143699003|56012099006|18002099003|22082099003;
x-microsoft-antispam-message-info:
 keuanFcYABdnhQSCIRARKzNJcGGXm8luC++xQD0VutFm/FexbKZ+dv/c3QtvaYCuQv+H4YvTioo86YYUvSumpi7JsOIAElrEFg2J8CPjd6oJVoo8QljqJ5CesO1j6lLVWZAAJrgt9l5M2uOztAOaHeEkmALiTHKCc+iLcIho7vve42VBUy2/n0UCjN+4XXxYJpvs/aL0SIoHvgSHwnXZxFG6XMnQ+Hdwn8FtsxeOFCpcfYiOD8eNf331OWnaHX99yAr8SrIbcFgGEl6fWb4aVwCGluhojeYs8EaL1Xf+OpjhMGQL+1nax8VyrBnelrFTtZoA3CPUgPXA/ZVDHZMFtRamJgKmVM/8z5kWtzZN089urYH0oTGmPbpZRGW0RjaKcTcpLKHHlBk5BVpzGjerxKjgekSdmq6suS9lExWQ5fqE6JkT+ec8iaAF2B9acf4Q6jXTeaRgRnITFwOFSj2w6epZEATsMu6xO8BC5ORGgEL8ngHysrt3W30u64BUqmjmmwl2N9x78lWtkDCjt7iZJt2BUycgkP8wFjLdoFlH5kuw9YQyyDjgxOUl6mzARDwj7BZBGH4qhVX47M+RwzSq54w7hVwRa3reFVrrurtGpY9Wdj04zWSdWwZgggE1vGtHIbYIBMx0nP0D3Z+mu1AxgXSHJJJ4UAe4K7AI3EQIBjAepAUG0PT6MPeLEGZwXKJfBsCf+Xr/Ny4RmKiYMZgbyzQZ0jtrsrBr3kZJSfOz1OA=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR12MB5259.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014)(23010399003)(921020)(261026121527099003)(38070700021)(10067099003)(11063799006)(4143699003)(56012099006)(18002099003)(22082099003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?ZmQwMEo1Q2M5czA5YTB6QUQ3Z0ZiVDNtcm96RWNlSDMwNjhKbndVSlAyY3dD?=
 =?utf-8?B?amllaWxOeHpXTzNCYnd6YXltOFA0OWJocjd1dElrczZIU0RDMFF4RUpaTnd3?=
 =?utf-8?B?NGxoQnZhU1ZLaS84NHJTUUVtc1hjcjFuSE9LbHNJOUs2S2orR0Q2cStkOGxu?=
 =?utf-8?B?TGdqckZ1S1hyMVlRUFQ5d0JYVTc5QTVraElDUWdOY0ZVYWQzbk9zL1dUQ1Bt?=
 =?utf-8?B?cjNkVTVndjJ0eTZLM1VJeUIyekRqaVVGVTgzZEQxM3NjNE9aK05LSmtWWjFK?=
 =?utf-8?B?VWdYemh3aG1jNGlvZnVKMTFYZzVialgyTWJQYWtxT3h4WklLcUgrK0x0WlJn?=
 =?utf-8?B?SUswK2FUaWt4ZDJ6TVBVR1YyQWk0aTZrdVU0RXJVQUVYWG44MGx6emo4OUhp?=
 =?utf-8?B?QjdRYmFhYWxTYmVyYURmMHZ1VVQvM1gyamZjVEJWVUFVOWlEMkN4NHBsQ0V2?=
 =?utf-8?B?U0F0ZDNZTFpRQk9QME5XdWIxQ2RidGYzU0hTZnhGVkdBY1VBL2FFbDRWQk9n?=
 =?utf-8?B?NCtLWWtKTXBzblVaL1NCdnl5N1FnMnpZNTExWnkwbnllcStKWVhrQjhIV1Nh?=
 =?utf-8?B?dFZIby83UVpMMVQ1U1NDR056ZWV4eHBZRzYwQlJpblI4NTZuMlpYaTViUmE1?=
 =?utf-8?B?YTJxbUs2SmtId2hGQUNTY2tDUjdidUt0Z0pYN1VXSjAvTzBqcTd1K28xektx?=
 =?utf-8?B?aUJYcGUzQlU3SWRnN1hxNVdpRXJrbUJwZEYxMisrSk1jOFV3NjNnbDFIV2lj?=
 =?utf-8?B?R3ZUUW1SaUN6NEFRSXZOZXU1czVXRGhDUWxEU3AxNXlldGJ4VUhiaHQrRnF1?=
 =?utf-8?B?S1RtVldnSUJYYWZVSU5mWWFGaFFkWXY1eWp3UUNJc0tMamNkNHk4dmxaUmll?=
 =?utf-8?B?Znk0dk9QSStHYlVlOWVtc3F4aTdvTDRQVmlsbzlxUW1jNFR5ZTdsSnZHdUZI?=
 =?utf-8?B?M0tTRTRtblRDYlZuTUhXUWVDa2JnNEhwcHlWY01DMkdEeWVwdTN4cmFpcUNN?=
 =?utf-8?B?R0FvVlZjQis4dDdRSmdkQmJHYkJ5Qm0zMHhzZEJIL0owU0NlNUNGM3VsdDBl?=
 =?utf-8?B?Y0VJK0JxMGZnT041TUFCZXJtSmFLbzZ0ZThrOGVUS3FiYjEyVWw1djRnYlRh?=
 =?utf-8?B?dlUxZXpMajY0Y1lqL3VhaHBRZGJEakVSSDBueGN2NThsNks4YTNJdmdGd2lq?=
 =?utf-8?B?NUZWd09ycG5ZTjdkTCt0amJLMDhHSytsa2RjMkFtOXZ5dVd3dW9LSEVzZ1p4?=
 =?utf-8?B?dWF0WDE4blNMNnoyZlk2cUhzcnh0ZjR2bEREbFF0bEIwZkdlY3hxZ3BMZndl?=
 =?utf-8?B?Q3ZTWlNOTW9lZ0xkUGFsdlU5KzZFdzZIUkZHTDZPMUs1dUI5alVBbllaQkFD?=
 =?utf-8?B?U01SZmNQbXhoODA0aTlaa2dKWDNBZ1dxT0VJcWZPUHJ2aE1PUUFzMEtrLzM1?=
 =?utf-8?B?c1hTdVI0cGhyaGRlc3NPTmtZSTJ6YWxiWjZ5NGdkQXpZZ0cvQVo1d3drS3hE?=
 =?utf-8?B?OFRVMGZMV08xRmNmTVlkcldtQlJQZ05FNEI0NXljeXZMZTNIVVpxUEF2SXFF?=
 =?utf-8?B?V1NKNU9kUzRiZHRDV1l3dVc3MjhRMDFiQUZwaWtVSnRwc01mZHpCdWZla3pp?=
 =?utf-8?B?S0F2ZDJEZDhYcW1KWDM0Z0g1OUdjQjdaaDNLL1RZYUs5aVdZaEVubGx4RFk1?=
 =?utf-8?B?TTQ2QkIvbzRua3AyRWpwcjAyTW8rb0hnQ0ZycHczZDJldFg0UERuZm9Ua011?=
 =?utf-8?B?TFNOTEh4NGNaU3dBNisrbEJkaWhoV3lSUk8yS1pCUWZmSGRpdkJUQnFnMTVt?=
 =?utf-8?B?dW9OQy96NjRBQzNIU1RqZ1o5UmJqOHAwV3FRcWRVdGx0R25ETmZiaDVDcTh4?=
 =?utf-8?B?NWcrbkVzTEVCcUdHOE01N3NmSkRBTUZuLyt3eDNEMDZhS2d2dUpvZU1UTFlG?=
 =?utf-8?B?djhwTHBQUk9mQWlUK0t3WWJUa0hvckZ0aTdmcWRHRWprMzkzWjNZdndDbXIy?=
 =?utf-8?B?RlBnR2JQNGl4a1JidWlPUHVxMll5TUxucjlieXlrZGRKV2pNVU1ub0FnZnJ5?=
 =?utf-8?B?VkZhZEQwVmMwN011d0tNRlJPQW5pZnZwbDRzVmszUCtDV1o2cmc4T240U3Vp?=
 =?utf-8?B?ZkxkSWtHZzhXNCtGaFZzam4ya1ZpM3Jib2J3Tkl5T1crR2xnQlUrcFUzd004?=
 =?utf-8?B?Q1RTUldVd2tqcGlYZFloeEZxbGxOOVVCTFlJZmd3OWIzUE5pM1lLdXEwU2dz?=
 =?utf-8?B?cGhHMlQ3UzNyME1xVjR1Yy9tZ1M5Z2I5VlV3RXY4K1BoQ2Vnemx4SmxqUUN3?=
 =?utf-8?B?UGV2Z0tHbUNwT2pyeTh4QVFYd3lrdlNUUlpXcUtKeDIrUy9hY2ttUT09?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <4DCDDB8F00EFD34CA65A64B6146348FB@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR12MB5259.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c431f202-4678-4302-7d8e-08df4bed4657
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Nov 2026 18:44:16.8956
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: rWYhIWP6ps5evT4YeErbuHJ7UZOBrJtaVncBIMWUbi964/Ms0/KtN2X7wgz8Hk7QXBJkimLkBYRqLRNLiu3qIQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB8160
X-Rspam-User:
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: B86541C0004
X-Stat-Signature: tq8hkcrn6myhe8nzjx7i5eka3zm5o1n5
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-HE-Tag: 1795718664-571005
X-HE-Meta: U2FsdGVkX18cqk5CLJBdlXle3FmUK1j1/pSwAnRolHzHatIGdJCgl5zxFs+SxhR4hBiUhRb0ggoILYg87rnQIWuV3fWPMT9NwB04sHcFhBim9wvqcysGLc3LgNFd1Tu8jzy4B/hj6YpBiXwNrhnW1fnCwZo8jTWbnv1mF42L+ObBdzBU5TYWibiYo2k5b+gMjFlNT8mlViqUCN9E28Sv357eZ5Qml8GnjaMDK2PXi7a6+MXdfDY4LA3EIXDEY6/1CePcybk4xiJMtgpBZ+32/+R3xhWXCGNN7o7JqgP0WsJ6LL3Mf8JOqBjiHbaSt/U4YEnDIwgi15bxRcbkG3fkTWBRmv9Q9Cvaap1bOsSYZ1IqO3L7MrU580XTRJ/2JNWbvD139ej1l+neBerX9mRn25quh2t+xgM3pRWJSu+GKGUVFOE85Rt8uB+egCiSwSh6e1rYHyagS0rZwEPZ2AUtyJgRYOr976IvUyiRjtxxa5oky6eH7ErSqmOz1W2N+QHy4CEe4cSvn8YiaFCR2nxEtLYX0XhiFdau5XKiTQFsv17Vk3kUwUv8grAZOTC9UXMsqlN5yxWcyOQ1aYUvWusGS6u22ukVfb9ij1LaxQ3h0W4xNgGurn+ATyEZXvzmA/gN2aDMlvgDYgzoiZm4VgpL+qGgeC8fpe9yH+bsvoT0t/Fdyw2e58SJmVaQ3xrTBJ83JBp2UkchSUonAlmGISGoJLIpVMDCvdXDvOD/GrruSuihVRfaHFTJFzn48CRzsv0B+L2TtvsB3NCLARKdzvkc806FOkKjarcdirp0mm7DC3TTYKlrkpoXG1hMEdmYyiNgB2lTC0IwxYSK/aPa6x/y2y3fxDThOIEs5vjJaahvv/4Th+I+bv5b83/hyyGZqbJpG6eeIyvTSn862PHLQ9amOFtzIrZn+YRhEXnVzG91Z3xpRB2Um6V1HcY6h5aSrhEz3ArlJJL6403ZmUkPfhh
 UNXnIdFZ
 PxvDdTT2zwPl2PI0VjkZCqZbOS5NpEpq0DaMUxTXMQsl6Y0roEYHJYSyzreoLEmK0ShAHIZn1oDsyLAk5uUD6GQwbqJ3qKb3IxMJKf53+WH1AS1WTN+FYY+9wOD91Md2WDpAYpGIkjL1kHGVOqiKmQRvF5KKSVYINMeTUhUjaSVkALzu7hp/Wyjgl+tmGdr435pG0BU7yUZkkE1baaUIMOYyA2JQKG80LCyCkwE6TDLXLCtpFgV9bhU58UNX3wQr2v5DgRpdlfh404iJlCsj/iYWzuoGzqsHhsV0M/NVPxWkBbmppLVuXjHOg64fmwY8WsPyGS5BMz54LoR+ScqiLobP+14akw6XJZpLVGoos+WHaZtda02IR/8XeEDuU4UigkN5udh32+4Z6QgKnTJ3AwPZHavCeh2GYq2CPP5k8xTkLY/UoqNg8L0rz4xuye0tuut1ZDrk5AqZ4yQo/EN/7SWcnw2yUvJT1VF3larH8hAr6b/qW0RLaypernptAtHjYtL+2azfLupZkMIsvD+OAa9XKmQYa2ajPjb5wNqgaLJzzoi4Dux1Vpus3OGAn+GL+/JxuR9+DtMcqi5XMkzWu7mb1sn53grcfDRYPxxR3v5eky7V2of141EFBDGNoWJgiyGdgnGL2lN1aCdnwKmMU15GNo1i4aIhVa5XGdQsUBOg2KNvQ9MF3CgpuiMeL5P5lQOKZ3AZC/A1wUnX3U/kD48N8NWwgUZFNioBjn09Plkqzhzx/m3LyBgFM1AkEt9Eur7b7UkrQdr3l5jWZ+bSOWTqBw3wXs/f0z2FJkTMDvRaC2H/da3SBlSNVdU8wYf9gZKzLywUgIE5Xy3SiCoFwVfBhhy31ehfggwNFQQ4BAa9xf/GC9R/0k9jcF1Qq4l0NGEqEy/zXA+CSFiU+UGNZ30YF0OHVu2nTLvEf6zB17km/24Y=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

T24gTW9uLCAyMDI2LTExLTIzIGF0IDE3OjIzICswMTAwLCBEYXZpZCBIaWxkZW5icmFuZCAoQXJt
KSB3cm90ZToNCj4gT24gMTEvMTMvMjYgMTg6MDksIFNoaXZhbmsgR2FyZyB3cm90ZToNCj4gPiBm
b2xpb19tY19jb3B5KCkgY29waWVzIGEgZm9saW8gb25lIHBhZ2UgYXQgYSB0aW1lIHdpdGggY29w
eV9tY19oaWdocGFnZSgpLA0KPHNuaXA+DQo+ID4gLQ0KPiA+IC0JcmV0dXJuIDA7DQo+ID4gKwly
ZXR1cm4gY29weV9tY19oaWdocGFnZXMoZm9saW9fcGFnZShkc3QsIDApLCBmb2xpb19wYWdlKHNy
YywgMCksDQo+ID4gKwkJCQkgZm9saW9fbnJfcGFnZXMoc3JjKSk7DQo+ID4gIH0NCj4gDQo+IFdo
YXQgYnVncyBtZSBhIGJpdCBpcyB0aGF0IHdlIGFyZSBub3QgdGFja2xpbmcgY29weV91c2VyX2xh
cmdlX2ZvbGlvKCkuIFNvIHRoaXMNCj4gbG9va3MgaW5jb21wbGV0ZS4NCj4gDQo+IFRoZXJlLCB3
ZSBzdGlsbCBoYXZlIHRoaXMuIFRoYXQga2VlcHMgdGhpcyBwcm9jZXNzX2h1Z2VfcGFnZSgpIG1h
Y2hpbmVyeSBhbGl2ZSwNCj4gYW5kIGEgc3BlY2lhbCBjYXNlIGZvciBnaWdhbnRpYyBwYWdlcyAo
Y29weV91c2VyX2dpZ2FudGljX3BhZ2UpLg0KDQpBZ3JlZWQuDQoNCj4gDQo+IE1lYW53aGlsZSwg
Zm9saW9femVyb191c2VyKCkgbW92ZWQgdG8gYSByYW5nZS1iYXNlZCBhcHByb2FjaCBhbmQgYWJh
bmRvbmVkIHRoYXQuDQo+IA0KPiBDYW4gd2UgY2xlYW4gYWxsIHRoYXQgdXAgYXMgd2VsbCB3aGls
ZSB3ZSBhcmUgYXQgaXQ/DQo+IA0KPiBUaGVzZSBsb29rIGxpa2UgZXhjZWxsZW50IGNhbmRpZGF0
cyBmb3IgdXNpbmcgY29weV9tY191c2VyX2hpZ2hwYWdlcygpIGFzIHdlbGwuDQoNCkkndmUgc3Rh
cnRlZCB3b3JraW5nIG9uIHRoaXMgYW5kIHRoZSBjbGVhbnVwcyBhcm91bmQgaXQuDQoNCkFzIGNv
cHlfbWNfaGlnaHBhZ2VzKCkgcGF0Y2ggc3RhbmRzIG9uIGl0cyBvd24sIEknZCBwcmVmZXIgdG8g
cG9zdCB0aG9zZSBhcyBmb2xsb3ctdXANCnNlcmllcyBvbiB0b3AuDQoNCkRvZXMgdGhhdCB3b3Jr
IGZvciB5b3UsIG9yIHdvdWxkIHlvdSBwcmVmZXIgaXQgaW4gb25lIHNlcmllcyB0b2dldGhlcj8N
Cg0KVGhhbmtzLA0KU2hpdmFuaw0K

