Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2135AE83F05
	for <linux-mm@archiver.kernel.org>; Wed,  4 Feb 2026 17:41:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 14FE76B0092; Wed,  4 Feb 2026 12:41:46 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0D34F6B0093; Wed,  4 Feb 2026 12:41:46 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EBE6F6B009D; Wed,  4 Feb 2026 12:41:45 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id D5DC46B0092
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 12:41:45 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 8418F1C09C
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 17:41:45 +0000 (UTC)
X-FDA: 84407491770.06.C5B47D8
Received: from MW6PR02CU001.outbound.protection.outlook.com (mail-westus2azon11012033.outbound.protection.outlook.com [52.101.48.33])
	by imf03.hostedemail.com (Postfix) with ESMTP id A36F12000E
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 17:41:42 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=kTvwM10P;
	spf=pass (imf03.hostedemail.com: domain of ziy@nvidia.com designates 52.101.48.33 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770226902;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5jleCOufadrmhNLgiTft6lIBB/i2b2co6YSaN0Bmv4Y=;
	b=EuqxJkpEweZeY9ZYwyM9BfQHQafrQJiEQ4oJTGcQFDdaQIliGUFLFnYjTINYDmNoDPNdZZ
	rUW7t9D9gSoPRaWyOOXmlt7+2mc21KRr1wMRxJztz2OKqtEYDfIuBwBYx54B1P/6ONqeh3
	sSxczv14rDGU2iD/aRNBtsb+x8JNzd0=
ARC-Authentication-Results: i=2;
	imf03.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=kTvwM10P;
	spf=pass (imf03.hostedemail.com: domain of ziy@nvidia.com designates 52.101.48.33 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1770226902; a=rsa-sha256;
	cv=pass;
	b=4WZ4RJFqOpthb+otdjEbX2BDy4DAH5nJnbdzCgPV0FiFAgzs7E2Vp70lGoCm7ML4dGBMMJ
	PzlKukkOI3LrSVE23E2g0oJrZicfmgfqDodkuNVh/cacvYyWibxSG4WVIXIoHHxO/fnnjc
	UjXudhCNNJWKnqCg11n2okZMJCaWSDE=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=fCZwfxDuhzi/275pK7CbppLNALxFG/Oz0UQoqFnlC5QCdoyQstzlUCqObmd21Tb0rnHCBBB9ZQ99IbdhuOnS78QrLna/pHJShIiEQ3ZYfUB/0p3CpiOyuYlk7LpD8C6K2l91fFCFwV8r4P6cJCGMC86vf+2AOh5ORAZiYYxsHQlOP14a+bO1YzUV/8wscXKyQWp2ZLdq1B2s1os5kRV0fYsGR288OcUs9M7v9wVSvvwGdVLQDUGnOuWomd0sIqHoCXLhJt0kSfpwwqHxMmYJdNpM/BT0CjBosyZ5jnX/qBF0f94/oYR4BkBSLIlKbZGxY3/V8ReJBVoNUtXtnmXJhg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5jleCOufadrmhNLgiTft6lIBB/i2b2co6YSaN0Bmv4Y=;
 b=tS10a1+wopI6q0QiPd00VgJ0aTlZuQPK+/Yu4ROX0W0ZZqp7kZY/ZkUEMVJtz3nLMxNP5z0nrfodZZzSj0J6TY1UP3EWJmdYU1TBVrADPLbU2uwOrMe2QrStuI1ThIH3MiCX0O5CYOHyXmlNXP3sRwiu60fTVHTu/LVZyMLzdmdhby5BqexeSebcQ9GLhF8/1eV0hClFHppHP6ZaR16a4TWowxFAk0hpJnTd5Ahx/M629PHhmswRs/M+TXwQh0lXUwUjvr/YPiB6E6k+waLLgkvjqZn/UKF3M8Mxsz9/bbObjwrUfZm2MT6bGmkETyGODEmX3MdjnmcyM/5yPFuk1A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5jleCOufadrmhNLgiTft6lIBB/i2b2co6YSaN0Bmv4Y=;
 b=kTvwM10PoXy4TkL8FuM/8fX+gfqSnhkXmjb1Yj8zkVwpJHX+KThoPMgwIhGweIrOVkWv3G/Sy+o3f4EtACaJR52zLe80VJdslb/NEaDnDkUPp+CrVKVvhePuXy62BQBnhSooAGQrpDSWPsxbRvKfy3i0ReoNJtnI8H4hzGgnMXBa2xNxIsAybunONEnCUl47Xup55YDtj0BYXTcJnOgsmWIrBgmiPPOncBZ+r579a9B9307H2J56gr8P1E+FCnoAINxkcSTccFCBSJMueYZaWO9rdPUtGaipV5qzEuQxflCmelTs6ree4Pen8zrBjgWjLCtsdS4oJ5seUBBR1BEhng==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 SN7PR12MB6862.namprd12.prod.outlook.com (2603:10b6:806:265::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9564.8; Wed, 4 Feb
 2026 17:41:36 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2%4]) with mapi id 15.20.9587.013; Wed, 4 Feb 2026
 17:41:36 +0000
From: Zi Yan <ziy@nvidia.com>
To: "David Hildenbrand (arm)" <david@kernel.org>
Cc: =?utf-8?b?5piv5Y+C5beu?= <shicenci@gmail.com>, <linux-mm@kvack.org>,
 <linmiaohe@huawei.com>, <akpm@linux-foundation.org>,
 <linux-kernel@vger.kernel.org>, Matthew Wilcox <willy@infradead.org>
Subject: Re: WARNING in memory_failure() at include/linux/huge_mm.h:635
 triggered
Date: Wed, 04 Feb 2026 12:41:34 -0500
X-Mailer: MailMate (2.0r6290)
Message-ID: <032058DC-CD8D-406A-B986-740E41C834B2@nvidia.com>
In-Reply-To: <25CA4D90-A24E-49C6-92D2-08080EC81466@nvidia.com>
References: <PS1PPF7E1D7501F1E4F4441E7ECD056DEADAB98A@PS1PPF7E1D7501F.apcprd02.prod.outlook.com>
 <b9e89c85-807c-4a8b-aa5c-8c1325e75445@kernel.org>
 <1db245a8-f9ab-42e4-8cc6-cc7562961921@kernel.org>
 <48978612-6933-4897-85DD-6740B6C8570B@nvidia.com>
 <25CA4D90-A24E-49C6-92D2-08080EC81466@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: MN2PR05CA0065.namprd05.prod.outlook.com
 (2603:10b6:208:236::34) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|SN7PR12MB6862:EE_
X-MS-Office365-Filtering-Correlation-Id: e7e294a9-239b-49f2-3e45-08de6414a4d4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?YWpHZ21QWDJYRDZGWnhlTmdJRWJ1dXZNeHl5T0llOEJsZmZ6TW92YjJyTHZU?=
 =?utf-8?B?N2l5UE9USVRXbXI3Q2NIaXlKSFE0TjQ4ZXJDNmF4ajUzWTVOV2FxYW9pemJJ?=
 =?utf-8?B?WDBZNG9Yd0ZoWGRpT2h1R1J3czZkUnR3NldCY3Nhd1FHSFJXTGVyK0ptWHNU?=
 =?utf-8?B?TGhXMk5wTGVkT05TUTJaTEZJcHZJQW80SUM5SzJRbHdGaFFxVjd5MkIzWHpx?=
 =?utf-8?B?ZHVyU1JweFdQZzZhQXZ0UEI5ZytIUUtnUmdJUWVWODZ0SEZvdUdrSmFBRXlk?=
 =?utf-8?B?NFFEWXpnSkVvSVFnRkk4MXIzbVRsbjhKcU84ajg4NnVsVTRHV0x1djdNSHZV?=
 =?utf-8?B?QlVORmt3aFlYNDdKUUxTcWtPRGRJMURpTHZpV3RnVlpTekluK1lBN2JkcFk2?=
 =?utf-8?B?eWZseTZCNnFRU1NvY1BCYWZEazZiRkpVbnhFNkpqR2d3bFFGYzRHb29IemFw?=
 =?utf-8?B?RTRjNm1vWGdyY1A1WkVKcVV4OFBSc1gyVnlSdGhRK25KaEFDalIvN1crZ2dP?=
 =?utf-8?B?elhCZFdraExFQWludWp4ZTQrbTJDd1NOcnhIWE9YVTFFeTVlaERSTjBhcFly?=
 =?utf-8?B?RUhWWTRZMk5hSTNIVE5JYjExU2xYTk00Wk0vb1ViU0F6SU9pNHJkS2tGRnBh?=
 =?utf-8?B?ZlBRNFdkUkhtb2Q0SkVKd09nTGJCYXNXeVp4NXBRTFkramRtd21wSE9DUnAr?=
 =?utf-8?B?T29kd1NVTDNIMnJlRjN3Y0syRFZvMTNRNSt3MEtpNi9GNWZ1MkpqMDRNWHRW?=
 =?utf-8?B?Ujh0TGpObXl5emtnR3ptYXlHUllKbzFJWGk5SWlHV1FSNE10OHZwYWhXb0x2?=
 =?utf-8?B?S2w3RFh1Z2k4aU1ZSlN4YkF1Z2g1blpocHZkeHZEK0ZtaG1aNTVQVC8zYktY?=
 =?utf-8?B?eWgvNUFZZTRZRWp3clI5NlkxVmMrSVJXSGJnVjI2OFZvdXl3a3FIMFlydjdL?=
 =?utf-8?B?eGFjeVRybUN4anpiNmFrdXdydU9HblYzc3dyeXNoV3N5NGQrMXI3Kzlnc1Rz?=
 =?utf-8?B?bzdaUFUyRDFVQTlyM3NZNllxejhlcSsrK1ZQRXhRSDZNd0JSRFpuZDROQWpV?=
 =?utf-8?B?OExTNFhOenZpSVFzSjNsaS8vZ1VaWXNicXc3Vi84YU9hc2FvMEFSZnREWm5y?=
 =?utf-8?B?VmJ3QUdySDFDM1FHU25ZVW1hUUdGVDBUZHphK3k2dWpEdk8rRklJQUVMa0gr?=
 =?utf-8?B?cGJ6SGt0aEh0TlI5N1QrUDFoaVlJamI4SXc5K1NLWktFUFduZzhrTUppaEtZ?=
 =?utf-8?B?Wjk5U3Nlczc3WFlhOXdFYXViNy9qeXR3RFZ3U3BCMFBqczlqWGVxUFFrL0pM?=
 =?utf-8?B?SFNrOVFhS2Ntam5JcHlYWjNndWJka1NVckZSNHdQdlR6UGx3TWxoKzJ0TE5F?=
 =?utf-8?B?dkdYTnFEd211NGVkQzRMeTVHY2lzbDhRc2VNaUtVenFUR1JmZXFnYVh1cWg2?=
 =?utf-8?B?b2I4L3l5eUdQL09ReVh4L09KZG1WdnhrdmZMUXE2TXl3VHNRd1RVZ0h6ZEIv?=
 =?utf-8?B?M1lGWXB5WlB6MjBDd0JSaGsrRWExeEttUVdYUlBOanVyYmN2aHdqNEhTWURr?=
 =?utf-8?B?Y2JIakdmNFE4T0Q5T3R4N1ZWM3ptT2FJTzNBMEVDUzkvc0kwSno5MUY3cktW?=
 =?utf-8?B?RUIxU1RSbkhvQkhxQ0I3cTdtbHRRT0VTd1NRNk9IMlhWZGh3T09hak9leGNo?=
 =?utf-8?B?MkF3YTBMWUlhYlJKa3crUGNlNXAzWjdOMDd1WFhkV0p3OVpHRVo4Qk5HUW5T?=
 =?utf-8?B?UmJCRk9WVmNwVUZYZHFKVU16K1NOTmNEc251Sk1LVTErcHhTQ0ZqMVpRTnNm?=
 =?utf-8?B?L2pYZHJsN1VoNUt5aVFscHkwYXJ4cUNIUmpBQURjNUtEOGV2RjNTOXp1NWlv?=
 =?utf-8?B?MHVrUU5PVHNqMkQrdFNURUFpamhJdWpxOTNIWEVzWWp3Nlcyb1BNV0E5d1Rr?=
 =?utf-8?B?MEJ0VERpams2ckZkOTJ2UWxhajZydjhPNDM3cFJYSzFybEtGeTU0anNjYy9B?=
 =?utf-8?B?UVJKRUc4WW1aTGtsRkVLcklubnFuSU9ZT3R2a2EzSDc0bXFqdVN1enZZbW5r?=
 =?utf-8?B?VlFkRGJQbDZxQm12QkFmZklLQmc4ckFYNC9EOGNaSHFMUG9NbU1Nd2pTTzM4?=
 =?utf-8?Q?mKtD7R2AP3xqO1jTXZzhu546S?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?Mi95SkZ6OTR3U1N6ZVNoaytyTEpWTzlVVWxTWE9IL2lSM0d0YkdxNndKeVBy?=
 =?utf-8?B?NDQ3Uk5UVWllQlRzWGlpODdCcnk2NFYrbTNQT3g2L3JycGROUHJvZUlPdEx1?=
 =?utf-8?B?ZmtCdzVpUUo1U3VIYzVFekc1clRSQTFLVTVOcmx0NlpEM0lxZTRuS203MVF2?=
 =?utf-8?B?WmhCR0JtMHUxcko4bzNmQ3E3VkU5eno5NmlsZG4yQlNNcm1nZ2hDNXorVDdj?=
 =?utf-8?B?MWR6MTVSZWl1YnBYQmNYNE9HcmNPMkZlcDlmU0NCdXptVVVhdWhjazZkaTN1?=
 =?utf-8?B?Q1lNRDBFQmp4QVAvcWFZZW5QRUw1Y2wrVE1HaDVMcWdyY08xekpQd2NRR3dJ?=
 =?utf-8?B?ZVJVZkNkTjRpSU15Y2xqOWpWL1dzcUlmM0lYM0tVcjhlRk1IRFpJSWI5VjNj?=
 =?utf-8?B?alZucjZmeTVyZDN6c3B2OTFPZThwenFjSzdXMUE5dmhPOG53bVB3SHQ2QVR1?=
 =?utf-8?B?d2t3TWVFSlFKL3JiSmQvM25JcEJCMWhiOTJwNEhuUVZ0M1lqTjlZY21UeDlu?=
 =?utf-8?B?QUxRSHNwaU83L3c5REp3bkFPdFZ6S3kvcUp2YSszelg5OEh4NmNKQno2L2Fo?=
 =?utf-8?B?NzIwbldvc25lYVB3MHBlaFFzVTlFVW8yL01BT1preE5MU1c4akxpZVZGSDZ5?=
 =?utf-8?B?WGNLRWNJUTBNdDFXbVFVOFZRM0daajRoQjdyZ05OUDJKeW5aMTZiek1qb3Vn?=
 =?utf-8?B?eW5nMHJVK2RIbEE3cFl4VGRWb1JMTzlSM1dydjNLTis4aUVQSjZaSVdLekUx?=
 =?utf-8?B?UGZGUWFnTm9zSlFNUHBVMDlCT1l3OVNISkphNGY4MlpJanh0c29aeHhQQ0tC?=
 =?utf-8?B?M3hzVGJEckFvSUF2SEpLQXdGSm0vWjJqbXpwd0NNV1ZoU1Zmb3hMand0K294?=
 =?utf-8?B?RHVBbXc3NUdoeTYyb24zWjdMSWswVnVKTURDWlRJNTJHSGx2MXZ0alh5QWxG?=
 =?utf-8?B?UkNYZEdSZ0RiY2ZkM2kxWmhFaXpFSVBUN0E2K3RhNW9LQno1ZWliRUI0VmlU?=
 =?utf-8?B?YXFoMlRPTDYrclBXSjlpd2I0RU1ZUUl6VC9XamlwaUd6SkwrTjJVNXNaZ1Zj?=
 =?utf-8?B?L29UaG1WUVhRZTR0U1JKbVJCRUE2TVQ0V1p6N1A0UEZERUliajRORTV0U05p?=
 =?utf-8?B?L1NJMjNoUXRoSjhFelNYNThLZXhLMVgybXIrYUpxeFl6ajlGMFFSTTBkWkxP?=
 =?utf-8?B?VGs3b0RUNEM4UEJwYnhOdS81WWVKK3BRYU5PbEdFVUZjYktnYXdDb1EwRURs?=
 =?utf-8?B?R1M3K0hqK1poRy9BRXlTRGd6ZjI1S3h2eGhvbDU3NGNDQWhPZ1E4d3UrS0tK?=
 =?utf-8?B?cWZwU0FkalExVERsRzNrbE1pb1VhUkxJWEMxdjd3b1Jpa0htZUFCSEcvTThM?=
 =?utf-8?B?czFCTUEyS2VDRlFEbkFUbmh3b3cxaEtrY3NpOE5ETWZ5czV3aXpBSW5wcWhp?=
 =?utf-8?B?ZnExYWxqSUFYazJoRXc3bkJlTTJhY2RsNllWODI0Nm9iLy9Uckl3dTFDTzVk?=
 =?utf-8?B?R2V1UURPSXRxckVDaStjWE8zLzlVL2w3eWpjSnBsb0xQdkR5TEFLMmhlU1FL?=
 =?utf-8?B?b3BHRys1Vmp4dExkWk9UWitEK2VKampNUXFLcEErY01yYzE5ZmRxOGpsblBS?=
 =?utf-8?B?anMrYjBnTFQ4TkhsS0VvWlo5Z3hQQUtXdEN6cFZpbitDOEFZRGM2ZnNkY3Av?=
 =?utf-8?B?TVpCYzV3aEh5allZU0JTdEJ3aDRpdmw0cmZOem1Oc1VkU2hrTkJCVllUY0xs?=
 =?utf-8?B?T3ZjdlRIcUhYbVEvZXhTNDl6ZFlZNVdkN3VEZFNhYnNjcmdoaTVKUW1mb1Zt?=
 =?utf-8?B?ZFc3SVQ1UG53WkdDclE4dHk5eDVtODFxcXU4MUdldFROQUM5VmVZS0RLRmUz?=
 =?utf-8?B?ZzErRWpWRDVmSk5jbGd1K1EyYlN3S1V6blZoUVdHOGRsWndnejJsc29YOXBj?=
 =?utf-8?B?ek1oWXF1LzA0WFM5NUZWa3lSL2QwTlhmbFByckk4dFhHRm45ZHZpQmNZQnZD?=
 =?utf-8?B?ekFJRGJEdXYvam5qMG9PWjYvY2txWlVLZWF3YTFZRmo0VnV4S1pFdlZ3NmRx?=
 =?utf-8?B?eXcwM3hCMEZjQ0dJaW9xbEtwYUl4NkhwS0FPTHdERUdmTUxpSEM4b3VGUC81?=
 =?utf-8?B?Mm9QVG5lc3pkWUliU2sxNjFtcFFGa3FhUnlYcXMycDFGdzJ2SVlHUkFrVE12?=
 =?utf-8?B?UDh6ZUtqRVBTcnE4b2h6Z0laMFJEc21ZclF3NEEybUVVUG5pN1pHREsrc3hE?=
 =?utf-8?B?VUUwWUxONXIyVm8zYWhJcDJPYjY2ZERFWnFnNVV4VlRwTS9STy9MSUVMcHNz?=
 =?utf-8?Q?gj3Nv6mY3Fd/T+OMXZ?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e7e294a9-239b-49f2-3e45-08de6414a4d4
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Feb 2026 17:41:36.2077
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LuKXSdxwbCaatIuXj9VukysbfQ+TjZuZRYcNoAzKv+R3Gx9L5j3+HzZ9jIECTp2f
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB6862
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: A36F12000E
X-Stat-Signature: infet5pwwoscabxs5bfyhpq6uwh4hny1
X-Rspam-User: 
X-HE-Tag: 1770226902-459761
X-HE-Meta: U2FsdGVkX18QJQt55y73fviQBi4QW72iNSUm1H5ANfOCwmqBiXxI4kxI0hWR1en67j4UR5KRFcnSft4KoC+nfnaXRjGzbu4vaSP98nxxZpp3z0XUKpIcU1MKmwpl/jnK3TGmSqP5hDbdhH4dSdyI1QofJnnMnscZw935qOqpVYjLIMZPou2IK2fI1ECaH0WOhsHN8KWa8fttmRYzpmqcafGF9exP5YHJZ3rlMvQhr4b1RfH8GLJc+fmqYu1rqdIIqok6OM0G83ZwDnq4Yzo9foynmurMTa1EyYQoXu/MBpiCQRkma0HpeymcEf41W2+QZQNHFbKgpH0f1dObyZeRZug54BVrqvX8L7cc20uUX6tUgCAT0vm/TWX3wMK5YUsECDjzFju6MyRA5gX1lXUrio+1x+VoIAdDu+chA7xAsTsbabuNx7adF7UIUmWTVAhE7CZss2zbXS3SDwFm7Wa24+mHbhz5Z0RX21yQ1k+2YNR7VIVsFttXpb5h8WeFfuRkqrJApTwYA82p6XBRe/a1//vgiZlVxVX2prMR6phOpTi7s8G3qCYLPpZa6YzP9ndBHw7+Eh80rjYXwnZIkFygdup5vp3dGjPovEDOwH1LVOwlC9utVR/R8KHmt+mwL1pyNoDxMWeJFu7oXEkgWZCUrrIhkgrXC5CbS/eC63iN3T70TEVlhS1jV8W6SvvWtB6ziGenptWh8noYY45HfI4mDyC5oQ+MdyKQGbnObIrioGh26CXTMHSU4O+iwAbOVXk4RZmbgl6Vr5gg4W5gx5rSXv80JKHNCkWPyZKGNtvM4yIsckSN7pknKVRwkCqFqANYwqsiNweXfYaRbFXMxNUWKTjU1DJuG1ql/T5u6jo/IpZIltowOGlVJg8G4dPr/h+XdEBpVbP2eus0QiQBh4cWYBavSH1Dq3d0GSGGw9kPKbBM8Ln02errStHrbV2db0FG4XV8p3M72IXnpKGkoyF
 MRaxtkYR
 IZ+axdh6+ZkxH9yfaokx2roej1w19Gf/MUCdwTEJLljOsXWg9unscAui76KZUhnsgpRBtyf3WVbFqnViem1tkww6de2VSq7lDXA1kjng667QvlTplwQ5mJ/yQd67ZuStgyjqEWGzJyw/HcszIIS65lkQXWGa/5I6jMrrV/CnhtTcx3NgDKe/MyJ+qm3VOzay2vqHiAFmtKSDjehAAPceWk1zxd643w01jyc0a2I7IcMZGJheVypgw4wfuckivRTUc4Ni6tL7hnaqkUeLjTOwFcUBKybeLBKPLYUag/eMB4fVimw0/EUW6miPREr0xfDvJ8lAsksT6YIpg6XTFjdKzGXPm3Bhxt2hrjowsprzJWCp6Pi8Va8SD24uFh/+VJG5hT/SsJNBIog1ByNdLB+4ODD2ZAqzi1g4I1AOHtaA3H/YG/bmez7LIgD6oESawd1ZYqCvMmPfUgXPpAUtSXrAa2ZMd+Mt4lRlTE5YwKi4beRaDLltHYHVjrhNwsBlx1GZ+V5mLWCC2vg5/74sWLi6O5fIkvHzL5QBDlmc4ECrnJjMWFCU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4 Feb 2026, at 12:34, Zi Yan wrote:

> On 4 Feb 2026, at 12:23, Zi Yan wrote:
>
>> On 4 Feb 2026, at 12:15, David Hildenbrand (arm) wrote:
>>
>>> On 2/4/26 18:12, David Hildenbrand (arm) wrote:
>>>> On 2/4/26 13:49, =E6=98=AF=E5=8F=82=E5=B7=AE wrote:
>>>>> Hi,
>>>>> I=E2=80=99m reporting a reproducible WARNING triggered in the hwpoiso=
n / memory_failure path when injecting a hardware-poison event via madvise(=
MADV_HWPOISON).
>>>>>
>>>>> The warning is triggered by a syzkaller C reproducer that:
>>>>> maps a file-backed region with MAP_FIXED, touches related VMAs, and t=
hen
>>>>> calls madvise()=C2=A0with MADV_HWPOISON=C2=A0over a large range.
>>>>> The kernel reports a VM_WARN_ON_ONCE_FOLIO(1)=C2=A0from memory_failur=
e()=C2=A0and points to include/linux/huge_mm.h:635, suggesting an unexpecte=
d folio/page state encountered while handling a poisoned compound/huge foli=
o.
>>>>>
>>>>> The target page appears to be a compound head page (order:3) already =
marked hwpoison. memory_failure() seems to reach a branch that unconditiona=
lly warns (VM_WARN_ON_ONCE_FOLIO(1) at include/linux/ huge_mm.h:635), which=
 usually indicates an =E2=80=9Cunreachable=E2=80=9D/unexpected folio type o=
r state transition in the huge/compound folio handling logic during hwpoiso=
n processing.
>>>>>
>>>>> This looks like a kernel-side invariant violation rather than a pure =
userspace misuse, since the warning is emitted from an unconditional VM_WAR=
N_ON_ONCE_FOLIO(1) site.
>>>>>
>>>>> Reproducer:
>>>>> C reproducer: https://pastebin.com/raw/UxennX2B
>>>>> console output: https://pastebin.com/raw/wrhKRwZY
>>>>> kernel config: https://pastebin.com/raw/dP93yBLn
>>>>>
>>>>> Kernel:
>>>>>
>>>>> HEAD commit: 63804fed149a6750ffd28610c5c1c98cce6bd377
>>>>>
>>>>> =C2=A0=C2=A0git tree: torvalds/linux
>>>>>
>>>>> kernel version: 6.19.0-rc7 =C2=A0(QEMU Ubuntu 24.10)
>>>>
>>>> @Zi Yan, this is weird.
>>>>
>>>> We run into the VM_WARN_ON_ONCE_FOLIO(1, folio); in min_order_for_spli=
t(),
>>>> which is only active with !CONFIG_TRANSPARENT_HUGEPAGE.
>>>>
>>>> But how do we get a large folio in that case? folio_test_large(folio) =
succeeded.
>>>>
>>>> I think we rules out hugetlb before in that function.
>>>>
>>>>
>>>> Looking into the full console output, this is an order-3 folio (fully =
mapped).
>>>>
>>>> How do we end up with a large folio here? I am only aware of that happ=
ening when something would
>>>> allocate an order-3 compound page (not a folio) and map it into the pa=
ge tables. Yes, that
>>>> is nasty and can still happen, not sure yet though whether that is rea=
lly what the reproducer
>>>> triggers.
>>>
>>> Looking again,
>>>
>>> mapping:0000000000000000 index:0xffff88800fe2e600
>>>
>>> At least mapping=3D=3D0 could indicate a non-folio thing.
>>
>> From the C repro above, syzbot opened a dev "/dev/sg#" and did mmap on i=
t.
>> Is it a device driver issue?
>
> OK, it is CONFIG_CHR_DEV_SG. And the driver allocates a compound page at[=
1].
> Since we initialize folio fields in prep_compound_page(), it becomes a fo=
lio
> when it is inserted into a VMA.

More details:
later at sg_vma_fault(), the driver just handles a page fault by supplying
a subpage from a pre-allocated compound page[3]. We then get a large folio
without !CONFIG_TRANSPARENT_HUGEPAGE.

[3] https://elixir.bootlin.com/linux/v6.18.6/source/drivers/scsi/sg.c#L1241

>
> It seems that my compound page and folio code separation patchset comes r=
ight
> on time[2]. Basically, compound page should not be a folio.
> With !CONFIG_TRANSPARENT_HUGEPAGE, __GFP_COMP for allocating a compound p=
age
> that is used as a folio should be rejected.
>
> [1] https://elixir.bootlin.com/linux/v6.18.6/source/drivers/scsi/sg.c#L18=
68
> [2] https://lore.kernel.org/all/20260130034818.472804-1-ziy@nvidia.com/
>
> --
> Best Regards,
> Yan, Zi


--
Best Regards,
Yan, Zi

