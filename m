Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A2914606A31E
	for <linux-mm@archiver.kernel.org>; Sat, 24 Oct 2026 12:21:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=outlook.com header.i=@outlook.com header.a=rsa-sha256 header.s=selector1 header.b=sC7zG9B4
Received: by kanga.kvack.org (Postfix)
	id 37BFD6B0A72; Sat, 24 Oct 2026 08:21:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 32CBA6B0A73; Sat, 24 Oct 2026 08:21:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 21CDC6B0A74; Sat, 24 Oct 2026 08:21:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id EA1566B0A72
	for <linux-mm@kvack.org>; Sat, 24 Oct 2026 08:21:50 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 77C511203AE
	for <linux-mm@kvack.org>; Sat, 24 Oct 2026 12:21:50 +0000 (UTC)
X-FDA: 85357431180.14.F01B3A5
Received: from CH1PR05CU001.outbound.protection.outlook.com (mail-northcentralusazolkn19010023.outbound.protection.outlook.com [52.103.20.23])
	by imf13.hostedemail.com (Postfix) with ESMTP id A947B2000C
	for <linux-mm@kvack.org>; Sat, 24 Oct 2026 12:21:47 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=outlook.com header.s=selector1 header.b=sC7zG9B4;
	dmarc=pass (policy=none) header.from=outlook.com;
	spf=pass (imf13.hostedemail.com: domain of x-professor@outlook.com designates 52.103.20.23 as permitted sender) smtp.mailfrom=x-professor@outlook.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792844507;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OwDPfwbuPswJhCNRDJlO9rvOVCSCy+LBNbyYHF2t2TU=;
	b=exhBOXQu6kZTl/d/0DtiEhk+4g2HwGXCXmoPUUi6V3mPPGec4Yei7EOA+gUXMb1UltLb+s
	ZjT/BcECMzWM4uXY/m/CgeB0RJmKAmloplNfTBuluaOST4trNyT7LdzNNAU3Qin+YonlVD
	rZhrx8gsmL0iDcj2eFZZcmt6a2H0cpY=
ARC-Authentication-Results: i=2;
	imf13.hostedemail.com;
	dkim=pass header.d=outlook.com header.s=selector1 header.b=sC7zG9B4;
	dmarc=pass (policy=none) header.from=outlook.com;
	spf=pass (imf13.hostedemail.com: domain of x-professor@outlook.com designates 52.103.20.23 as permitted sender) smtp.mailfrom=x-professor@outlook.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1792844507;
	b=qdktyNVq3c1JgL4e8daLp04mwqiZMCmBERF5Qfl9XSH21LkbAR3Zi3RA/UakFdSGPeXFwx
	PJb4Ml/8we9AOaeta8g2bVWMbnqF8M5InTOJtQYFY1d83qD+vmefD3dp3rcpZN9LriGERL
	5Fmn0M94kVCBY96ed41RB86XI4eEzWA=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=TgamToQuEyBhhYOakWrYySnt/Kz+UlEzROwYmj3q1j+gAgwAgGv4F247W9wdDwwN3i2GIpbjTk7B6dOyNV4jBICt1wOz/ymSAt3JQ7NhMJge2eehWX65guHsrS96Gq/UURp7kuNK4JApsUbQJkPo2kCkmc4hT3kDYrCoaPR6uKaAMdbBHFmDQvfeIfjCNFEhcmwCHT159cx4S+qcO0mH1/MEl4Xe6PNvqWmjFc+C207WYFDjbpOy4Wrr3elrdhKC6Kzp9PwSuJ/snj8yIhclnQ296K0J123RybVXtysGlJJlFyUoU3I4NclYidiLH1eQ+AJryvgXTHcMVUiVgJDkmQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001; h=From:Date:Subject:Message-ID:MIME-Version;
 bh=OwDPfwbuPswJhCNRDJlO9rvOVCSCy+LBNbyYHF2t2TU=;
 b=KP9JbKmmmAUG6ivcVBfu8ahjCc2fJhUdXtJsVciI2yXdRayfRbKV5uVN0zi5eOkaVyFMX37uFYSLEY46aAXSL21swTU56zMiYMp4MBufQ1UWsbJykefZDRsg7AHsx8+BOhKjseWZOnuC+/kEroWf1E+G3gEElccbev5ZpImgxqj7AndydN1jAEb1xzmPyeKvzFA+xu7wBMsMHK3UH6HtBnd/yyNKx8BjlKQxnsE6qm/P7k2LYtMMhBEBaStHGgrO3Iyy1UbWyCQU77Gpl1iJ1Zy1iQeJQc/jE34+/VbAnnie6RLKURO3r0UemCxtx97eos+QTkIWrZ6WWdp4G31+og==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=outlook.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OwDPfwbuPswJhCNRDJlO9rvOVCSCy+LBNbyYHF2t2TU=;
 b=sC7zG9B4BqoHTV4C+ti4j2o/akT001WGldUDMcpC2GpYk9QmYbp/cU6HcLaFOqgCdpz7qvh+OvAdwk72anI7UYtbJLN2TST0ZHqleoRuVj7gum/CkDW2V6YScpOwwQ1uRt3rnDzpPyZgdeLgEdXHHCa8Mf4XRjgKVFcJq6ysuyB8NQFeQqG/wCzskVn1vmio2UboezPBu2BVXI8g6o0VJxTDbpM6fafw5DjjO4HQ5KpAi8NgYlyEjVexkaqCQA5FNXD+elBuA2VRAwTeGAJM+d0Py+dZpQnsBNxk9KtmbStbTVpAEot2uK+xDslvAwFrfWogpMAxmO/oFVog+IJlJg==
Received: from SA3PR05MB10385.namprd05.prod.outlook.com
 (2603:10b6:806:39d::17) by PH7PR05MB9058.namprd05.prod.outlook.com
 (2603:10b6:510:1fe::5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.546.20; Sat, 24 Oct
 2026 12:21:41 +0000
Received: from SA3PR05MB10385.namprd05.prod.outlook.com
 ([fe80::e22f:a0f5:fcb0:9b0d]) by SA3PR05MB10385.namprd05.prod.outlook.com
 ([fe80::e22f:a0f5:fcb0:9b0d%6]) with mapi id 15.21.0546.017; Sat, 24 Oct 2026
 12:21:41 +0000
From: Yingjie Wang <x-professor@outlook.com>
To: "akpm@linux-foundation.org" <akpm@linux-foundation.org>, Manfred Spraul
	<manfred@colorfullife.com>, Alexey Gladkov <legion@kernel.org>, "Eric W .
 Biederman" <ebiederm@xmission.com>
CC: Yingjie Wang <x-professor@outlook.com>, Vasily Averin
	<vasily.averin@linux.dev>, Johannes Weiner <hannes@cmpxchg.org>, Shakeel Butt
	<shakeel.butt@linux.dev>, =?utf-8?B?TWljaGFsIEtvdXRuw70=?=
	<mkoutny@suse.com>, Michal Hocko <mhocko@suse.com>, Alejandro Colomar
	<alx@kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>,
	"cgroups@vger.kernel.org" <cgroups@vger.kernel.org>,
	"linux-api@vger.kernel.org" <linux-api@vger.kernel.org>,
	"linux-man@vger.kernel.org" <linux-man@vger.kernel.org>,
	"stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: [PATCH v3 1/3] ipc/sem: account enlarged sops arrays to memcg
Thread-Topic: [PATCH v3 1/3] ipc/sem: account enlarged sops arrays to memcg
Thread-Index: AQHdY7I5+7KGvRyM9Eaj2Ub3pY3rbQ==
Date: Sat, 24 Oct 2026 12:21:41 +0000
Message-ID:
 <edbb4aa04440205874d8a02a7f18e82d8188b937.1792808260.git.x-professor@outlook.com>
References: <cover.1792808260.git.x-professor@outlook.com>
In-Reply-To: <cover.1792808260.git.x-professor@outlook.com>
Accept-Language: en-US, zh-CN
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA3PR05MB10385:EE_|PH7PR05MB9058:EE_
x-ms-office365-filtering-correlation-id: 5f46a94d-72ca-4a8c-cddb-08df31c95c4d
x-microsoft-antispam:
 BCL:0;ARA:14566002|19110799012|12121999013|8060799015|8062599012|31061999003|25010399006|4140399003|24021099003|38102599003|15080799012|11091999009|21061999006|41001999006|24121999003|22091999003|1602099012|40105399003|53005399003|10035399007|26121999007|102099032|440099028|3412199025|4302099013|1710799026;
x-microsoft-antispam-message-info:
 =?utf-8?B?aDg5ZEFhZjFMblVUc0c1VFRjaUdGYXg2b0VLbG9oZktvemw1dy82YW02KzFr?=
 =?utf-8?B?REU4dmxISUdFZi9KVUJVT2RRL1FJL3ZPWXZEbXhrTytPbFVzenpicjA4TzNK?=
 =?utf-8?B?YWc1VDU5bmplNDJIa3RsSXUvUkNZekpYQWxBdWl0WWlRMlpaaEFYNDRCWDhm?=
 =?utf-8?B?eWNLQkxadjJGaWNaSG9yU0F3ZGhYQlVmbXFTdmVTeVYvdHZWeGcxcDdxQkF2?=
 =?utf-8?B?L1dQVjR1QTdEV2ZiQW5CdWtYRUZHekdDeDNiRkdRLzR3cEhxKzhWTEJaMjNH?=
 =?utf-8?B?dTdkeld6a09MTWljVVFSNWQvcVh6QXdFTDcyYnZJUWVTZm1OUzR0Ky9nNWlp?=
 =?utf-8?B?STc5UUlsYjhsTURJTVUzdmtkVEgrclVWdUkxM0JMbU96RnVOaVppOXI1YzVZ?=
 =?utf-8?B?L2x1MUhHVldvaFpCc21xdjBVZC9tcmF5ZW5WZEJicEZWMy9jc0FVOTk1T0l3?=
 =?utf-8?B?V2ZvMXM5TXFPTFRNS0wrd0Jpem9yZElFZXlUWDJGZitIc1d1NUZTdjg3OW04?=
 =?utf-8?B?MmVJcnMzeGQ4cHlqTTJZN3l0djREekQ1UHFrQXQwaldOTzFBRnkzeFBTcWkv?=
 =?utf-8?B?a2d2ei9qWWlSTkNqU1BsWXdlUlBHQmZ0blBwTCtOdzlqM1NXSmtBYzZYV0lB?=
 =?utf-8?B?VS9CbGhHWFN0UTdLL2phbmgwdkNRMzBpV0pISzY0RkNKQVNDQnlUa0RRQW0r?=
 =?utf-8?B?L2l5YXV1akVMVUhIVTlnek5MR1M1WDVlaHZLbEpGVlhnRnlaOENiL3Ntbyt4?=
 =?utf-8?B?UDVBY25HeGd1QWd2eVVhaXpkOVp2Q1NRem4ydmY5VnpzbEJYRFlTc0gzNmFt?=
 =?utf-8?B?UkNMZzM2VHBFbFBhN3g3MG4zODFYZmZjVlg2Q01lQTFLb3c4REdFNVFBQ1NF?=
 =?utf-8?B?N09RYlFEVFNTQWRoWVRyQ0dZQWttQUI1TUtxZWZoYWFTWk9VSDJIVUt4VnlX?=
 =?utf-8?B?VFdRQjdJU3JacEZWR2FyNExEWWFSRDR0V2FNTHJQTVlwcTRyZDlseDhsQXdQ?=
 =?utf-8?B?czZ4WXhlN000Y3hBK0dNR01lZTRuWXVYazNCekMxbHBXUFYzQ0l5VG43eTNP?=
 =?utf-8?B?aEhSd3ZKbHBtNFh2OEdsYnNjcDNvTEZVTG9RUXhDWnVSazBYSWRsMWNVZFVF?=
 =?utf-8?B?Q3FKOFM5VVJnT2N4cG9HL01aQlJZMHI1d0U5dTc1UEQ2OVZIVTF4bmVPb3VP?=
 =?utf-8?B?OE1yRGpWN0pqTDQrZXRNbGFQZnZ3TThFSkMyMTJuWjJvaGxJMklYUmdVL0hC?=
 =?utf-8?B?NmlzaTk5N25Ya21KRkUvdUVvUDVJYUpHak9mM1dGU0lsSE9OV2w1QXpHdjE2?=
 =?utf-8?B?eEpDMjhodGY0V1IzYUJoc2lTS3NHazBvc1pocm9HeHVuZ2ZqclU3OGtKRmNN?=
 =?utf-8?B?Y2toZnZoUkhlSklBRm9mR0lQOWxpeHF4Znl3K1o3K0g5VGhiY0s2ZERrbUtI?=
 =?utf-8?B?VGUrdlhZRHppVHZySzRwUERQYi9oR0VCbjQ5b1krVy9tTE5TeHVjcU5nWDVk?=
 =?utf-8?B?dk1hR1JYV3FmRXFkcEg0N2JnVWkwWUlhWDcyYlEyOG12bW50OHEwRE5PNXUw?=
 =?utf-8?B?cVFad1FPby9hL1FlV0NIOTVRYklGaXlYTDN0bGxlZS9CVkhzTEJnWERrNXRC?=
 =?utf-8?B?SUtuMEdMWjlpQk42RVlxR1VlV3NPME4ra2wvMEE3dUtBN0I2Qk5vK3dyWXBv?=
 =?utf-8?Q?QnM3u6cNZ3QIQDWGKJRv?=
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?VVl6Mlk1OVR6M1B6QldObXZhY3hKTDVEaFEwMmF3Z0k3MFdXQk0ydHNoUGVF?=
 =?utf-8?B?Q28wZ0xYc0dMR0lyeUZsb3pUczgxbkVpR3NGdm9UeVRjeVhHZ2Z4V3hCN3lD?=
 =?utf-8?B?NWlsdjJLekM1NnlMcVRNZStXN1plY3VNSkdCbXZ0bXczMzIxNEF6THA3MmRy?=
 =?utf-8?B?a3F2OFZwQWR0NVloVFVKNm1ObFFyZ2VXVHFwOFBTSjl2c3FFcmZTMlZZekxP?=
 =?utf-8?B?UVp6Q0I2THN2bmdiSDJxNTJ2S1RoR1ZHdGVEUFF0bnU5RG9zL1RIY2hCRHF4?=
 =?utf-8?B?Nk9RUlVjRUtzV2g0V21FdmtueEtsV3doWmY0SGxWa0ovdVpzUXY1TkRUU3JP?=
 =?utf-8?B?cldjSElZVlZTeG9zeDN2blk3a2xzMFp1VVo2Q1Jlc1J6dlh5NmR5bERXY29z?=
 =?utf-8?B?djh1Nklzbjd1MmFZOWp1aTZFMXRuZVRkMUJuQTFpQ2JPTE1Bemk2L2w5QXhq?=
 =?utf-8?B?YWQwamJIa0dxMGNianhOcTl0bnBQM0p2MGdBQXYrWTJFaGFLa1p1Tm02b3lm?=
 =?utf-8?B?MnB6eUU1eFZHT3Z1MlEyYlp4Uk9nOWtvNGYwa0tMKzRpbVVuUitZbjBDTHVG?=
 =?utf-8?B?aE5kNGprVHdoYVNyZFJiUlJxMnFaZUlZU2dPY0NjeUg4RExpY2o5WVZCclZP?=
 =?utf-8?B?eHRXcEs1bXpwQlRlRzg2T1JodzdqOXZqdDBlS0FFa1JLTUZBVVgvdktXTCtK?=
 =?utf-8?B?RlBld0NTQmFQRUExVzlodG9BbEp1d0I2NUwydTRUWEMzcGx0LytMWHVHMGpY?=
 =?utf-8?B?TFYvTmF6dk0vTFJJNTd4VGhla013L0xrRWVkeXNyUTBhNnoyNXFSMWkwWC8z?=
 =?utf-8?B?WnZOZUJxdXR2SURFQkhrU2lKSS9hMHcyVCtQbGllbGc0TWxlTUhKRTZxYU5q?=
 =?utf-8?B?U2dKd2ZjbUQvTFgwa3UydkJKcXVuWTBmMWk0T2lQUE50eE5TU1QySmt6ZjYr?=
 =?utf-8?B?ZzNONmlmbjdHWCtrSEgrblZkd2kvL2ROVFp1WnhoMERISnNWcjdETnQvdG8r?=
 =?utf-8?B?KzFLUndUN1p6VjN3WTVXRFdtSzFENW53cEltQlJHVzJOQ2pLK1ZqeHEyb3A1?=
 =?utf-8?B?cVlsMlZSYVF3MTREUFpleUJBWml4RzErWmczWmY5VnE5NmszVytZc1N5VDZ4?=
 =?utf-8?B?eVUxUXFtRi9LSlUzWnZTS2VoRG9yM0N1T0NkNWVueWNhMmN3VWJvZ0lTZHl6?=
 =?utf-8?B?UU9rQVNJb09CU29WN1BWT2dnTW4zVWhwZTV4M3dYUjBSNE81R1NBdVM1dEtv?=
 =?utf-8?B?K04vK3ByWFM2WUQ2Ry9UNkttWisxRW9LdTZxWjNYVUR5SXQxOFZmSkEzcXZC?=
 =?utf-8?B?aENOeVJ5RkkrOHBQZUlBVVNDaTZRSmtxVFN2OEtEOUpyenRDck5EODdNRFBJ?=
 =?utf-8?B?NWl4eXQ3OXlqcUtzaTBYeDluYUxJMU1EK1Z4aXlXcUNTMTFIdmsrRE5GeVJy?=
 =?utf-8?B?MC9rUkF3cVQzRlpidDM0TkNOUGRHSjhjS1dxMXJReitWODhVVWt4Z2RmZ3Rs?=
 =?utf-8?B?YThvV1RoQjY2bUlyRE1Ib09hcWtBa3BwcW9GOUl0cWZ0dlNCbldrYUt0SHJr?=
 =?utf-8?B?Ym0zajBZT3M2T21pbGZmMEdMRFBuQ3d0SzZiWXFTcTBVaytnb3IvbVR5OGMw?=
 =?utf-8?B?V2tpTTcrcEJ2STNGQzdScUthSGtHaENwV1ZESURCdVhTNlBYSTV3L3J6UVBn?=
 =?utf-8?B?U1dvU1B1YlFJWG1ibkx5dEdRV3pvRGtjZllNVWVTalY2VEF1VW50TUtwUUFq?=
 =?utf-8?B?dE1wVnlGdzR5SmZIYUhraEtSUDY0MXA2bmtZd3RZTy9saEk0MjNuSStWMDNo?=
 =?utf-8?B?US9tZndhU05QdHJUZ1l3V0xhRHlWWnoraVlvWHcrNk9vQ3luWmpPcU1OS2hN?=
 =?utf-8?Q?2Akgl6MC34fe3?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA3PR05MB10385.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-CrossTenant-Network-Message-Id: 5f46a94d-72ca-4a8c-cddb-08df31c95c4d
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Oct 2026 12:21:41.5661
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-rms-persistedconsumerorg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR05MB9058
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: A947B2000C
X-Stat-Signature: 4147k9ebty8571cq7x8ubtmwntcky7qb
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1792844507-680667
X-HE-Meta: U2FsdGVkX18DIhMPkcxp3P7eIJrc0ENKvZmmHo2/7NEvXSB+wZBYBj7MWPV/meC8WrwN+Oiu/PaoYbHL86xvps+ncLISh0lwylqH58u9DrPIH3bEpXDvfO7giLkS1SCT08wKDCMB10CVSljjVRDGOGQ1bVOYSH9xdG2bCUz6Nc4mprsDOf3x8rarq5ycAmfgcLaVfhlldiU+kPJ3KIxVRivf3GSEL97FacDLU5HsXID4xNcoAd6zS0qNfRD8UsIPynIf9KnFGrK3Phmdpg8dxj5gOT+WCJDYCE6DX+1oO5Xl9VwRFcPKF+nsVzuih6tnd2eBrgIRUL+O+O9DSlK+PBSL1p21yTcf9MJV7+mhTMbXO6S7/zzsvztzcV6fAZa91PUbLW/MUMKm5WAk3u3JWisyCmPh7VgE0ktXXyPVYipZ2CaoKLMhp10/1cUFHKZBIBsnAusb9rw7uKlqjlhNNkPjLZmV2aupq2ObXwU2YlbolujDktzxQb5hOU3R1lIo2afvKPrl+FU2lV8zNP8/KVVV9qDUZttuaXsvWYvefKMtQx59LBFaOCQZ1SALFaz3xkoFybszTsstmVrLVRBIksIrROZ9xPGrPw4QKpwl6Wgs/LW1uqcYwgl/Dn0r2TZF289GgBjzGb98OYlkdrgGqKloVKCBFuCjQEPWjzf4zRdaYR7tX+2hY8GjOZyIoFBDlzdVvmnIfGtsXAensKlpKpnWnQnWl8BTfvjXQBdD7HEjGyUGiNbuWShDKnS1KmjhcebtvvR/xI9QVetXUg57vtCce0nHQMZV+XdZTGZ20MOKOgu3E2OLjkz8eGWo/giE/E/c/2Qi6PwefO4BP0xCtWxPXIQOEeY6H0Gt45/Fz75EKEB8PtUiYsnkvF2YnPPXmdxf8nLl2WUAdCiMina2V7ws6b/ekGM2oQ3ajU6mQE/Bs8k3OBQi3BT5tYX365G46+st7tcCezjxBAQecwe
 UoNQPiKh
 xdeCsxVgMLUL3POyRoJTpj00R663nGXiPWD59yjep1FT71eItCQExWbaCiEfunaUFo97JpmM2OA7nLEuur4HNoBgakBFCay+BYVdhcvW29zpZ6nFIdh9VN8UMrOaMeDEmuOwryJiBFQZMKINPYLakbZVtS35xtdIt+UwGqzOlfDpWfZzYgrjp5qFYzUH13lZ7oB0T35Nofr7zyvK56TJ0Dwfb2qaJt4TDZX2aEZ47MCo449FhilpBgpih6/L3hcK2K4+dyR5uOL7lRKIcMwhEHpQSWhP7ISKciSJsZYDDEI7Zu9NpS68+Bv3mMm+68yIXnpqJsD/DTo0iUNfutZrE+vVH4axVmT5x88kCDL0OT0MwccLD5hLfC+FZclRlIwzosiN3gLLs02NICEwEgaJiylNmlgqXEYpBC2r8P0leOCXnr05CRZlClD/pOMnjDGP89B2NoC7HW96FtQgvNfGTjq92duNLLaAtE2BVg4bMZIQlMto4GoLSPjaYalxqAVEXbK+AnlLZpC3FUjWxFpAZhJHcMIFGsmD407G0CPDRP5ntA29c9RHQy7gySOVpbE07s33QedkfBNusPm8z1y/DDlty9JVF602lteiPVzPNKmMGMls=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Q29tbWl0IDZhNDc0NmJhMDYxOSAoImlwYzogcmVtb3ZlIG1lbWNnIGFjY291bnRpbmcgZm9yIHNv
cHMgb2JqZWN0cyBpbgpkb19zZW10aW1lZG9wKCkiKSByZW1vdmVkIGFjY291bnRpbmcgYmFzZWQg
b24gdGhlIGFzc3VtcHRpb24gdGhhdCBzb3BzCmFycmF5cyB3b3VsZCByZW1haW4gc21hbGwsIGRl
c2NyaWJpbmcgYSBtYXhpbXVtIGNvc3Qgb2YgdHdvIHBhZ2VzLgoKU0VNT1BNIGlzIGEgVUFQSSBk
ZWZhdWx0IHRoYXQgY2FuIGJlIGNoYW5nZWQgd2hlbiByZWJ1aWxkaW5nIHRoZSBrZXJuZWwuCkl0
IG11c3Qgbm90IGFsc28gZGVmaW5lIHRoZSBhY2NvdW50aW5nIHBvbGljeSwgc2luY2UgY2hhbmdp
bmcgdGhhdCBkZWZhdWx0CndvdWxkIGVubGFyZ2UgdGhlIHVuYWNjb3VudGVkIHJhbmdlLgoKS2Vl
cCB0aGUgaGlzdG9yaWNhbCBzbWFsbC1hcnJheSByYW5nZSB1bmFjY291bnRlZCB3aXRoIGEgZml4
ZWQgaW50ZXJuYWwKdGhyZXNob2xkIG9mIDEwMDAgb3BlcmF0aW9ucywgYW5kIHVzZSBHRlBfS0VS
TkVMX0FDQ09VTlQgd2hlbiB0aGUgYWN0dWFsCm5zb3BzIGV4Y2VlZHMgaXQuIFJlcXVlc3RzIHdp
dGhpbiB0aGF0IHJhbmdlIHJldGFpbiB0aGUgZXhpc3RpbmcgYWxsb2NhdGlvbgpiZWhhdmlvciwg
d2hpbGUgbGFyZ2VyIHVzZXItY29udHJvbGxlZCBhcnJheXMgYXJlIGNoYXJnZWQgdG8gdGhlIGNh
bGxlcidzCm1lbW9yeSBjZ3JvdXAuCgpDb21taXQgNTBlYzQ5OWI5YTQzICgic3lzY3RsOiBhbGxv
dyBjaGFuZ2Ugc3lzdGVtIHYgaXBjIHN5c2N0bHMgaW5zaWRlIGlwYwpuYW1lc3BhY2UiKSBsYXRl
ciBtYWRlIHRoZSBwZXItbmFtZXNwYWNlIGxpbWl0IHR1bmFibGUgYnkgSVBDIG5hbWVzcGFjZQpv
d25lcnMgd2l0aG91dCBjYXBhYmlsaXRpZXMgaW4gdGhlIGluaXRpYWwgdXNlciBuYW1lc3BhY2Uu
CgpMaW5rOiBodHRwczovL2xvcmUua2VybmVsLm9yZy9yLzIwMjYxMDE2MTUyNjA5LjI1Mjg4MDUt
MS14LXByb2Zlc3NvckBvdXRsb29rLmNvbQpGaXhlczogNmE0NzQ2YmEwNjE5ICgiaXBjOiByZW1v
dmUgbWVtY2cgYWNjb3VudGluZyBmb3Igc29wcyBvYmplY3RzIGluIGRvX3NlbXRpbWVkb3AoKSIp
CkNjOiBzdGFibGVAdmdlci5rZXJuZWwub3JnClNpZ25lZC1vZmYtYnk6IFlpbmdqaWUgV2FuZyA8
eC1wcm9mZXNzb3JAb3V0bG9vay5jb20+Ci0tLQogaXBjL3NlbS5jIHwgNiArKysrKy0KIDEgZmls
ZSBjaGFuZ2VkLCA1IGluc2VydGlvbnMoKyksIDEgZGVsZXRpb24oLSkKCmRpZmYgLS1naXQgYS9p
cGMvc2VtLmMgYi9pcGMvc2VtLmMKaW5kZXggNWVjNDFkZTdlODViMi4uYThjOTgwNzE3NTUyMCAx
MDA2NDQKLS0tIGEvaXBjL3NlbS5jCisrKyBiL2lwYy9zZW0uYwpAQCAtMTc2LDYgKzE3Niw3IEBA
IHN0YXRpYyBpbnQgc3lzdmlwY19zZW1fcHJvY19zaG93KHN0cnVjdCBzZXFfZmlsZSAqcywgdm9p
ZCAqaXQpOwogCiAjZGVmaW5lIFNFTU1TTF9GQVNUCTI1NiAvKiA1MTIgYnl0ZXMgb24gc3RhY2sg
Ki8KICNkZWZpbmUgU0VNT1BNX0ZBU1QJNjQgIC8qIH4gMzcyIGJ5dGVzIG9uIHN0YWNrICovCisj
ZGVmaW5lIFNFTU9QTV9OT0FDQ09VTlQJMTAwMCAvKiB+IDIgcGFnZXMgZm9yIHN0cnVjdCBzZW1i
dWYgKi8KIAogLyoKICAqIFN3aXRjaGluZyBmcm9tIHRoZSBtb2RlIHN1aXRhYmxlIGZvciBzaW1w
bGUgb3BzCkBAIC0yMjM0LDcgKzIyMzUsMTAgQEAgc3RhdGljIGxvbmcgZG9fc2VtdGltZWRvcChp
bnQgc2VtaWQsIHN0cnVjdCBzZW1idWYgX191c2VyICp0c29wcywKIAkJcmV0dXJuIC1FSU5WQUw7
CiAKIAlpZiAobnNvcHMgPiBTRU1PUE1fRkFTVCkgewotCQlzb3BzID0ga3ZtYWxsb2Nfb2Jqcygq
c29wcywgbnNvcHMpOworCQlnZnBfdCBnZnAgPSBuc29wcyA+IFNFTU9QTV9OT0FDQ09VTlQgPwor
CQkJR0ZQX0tFUk5FTF9BQ0NPVU5UIDogR0ZQX0tFUk5FTDsKKworCQlzb3BzID0ga3ZtYWxsb2Nf
b2Jqcygqc29wcywgbnNvcHMsIGdmcCk7CiAJCWlmIChzb3BzID09IE5VTEwpCiAJCQlyZXR1cm4g
LUVOT01FTTsKIAl9Ci0tIAoyLjQzLjAKCg==

