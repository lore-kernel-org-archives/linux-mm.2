Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 03BCBC44507
	for <linux-mm@archiver.kernel.org>; Mon, 13 Jul 2026 16:20:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C92066B00CD; Mon, 13 Jul 2026 12:20:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C42A76B00C8; Mon, 13 Jul 2026 12:20:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A95EB6B00CD; Mon, 13 Jul 2026 12:20:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 63A5F6B00C8
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 12:20:44 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 9F2A21C6F37
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 13:51:55 +0000 (UTC)
X-FDA: 84983891790.28.F401260
Received: from SN4PR0501CU005.outbound.protection.outlook.com (mail-southcentralusazon11011011.outbound.protection.outlook.com [40.93.194.11])
	by imf11.hostedemail.com (Postfix) with ESMTP id BFB4340004
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 13:51:52 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=r9vHA4Xg;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf11.hostedemail.com: domain of ziy@nvidia.com designates 40.93.194.11 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783950713;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xkaZn802kLTJMYpAzoQptQF8VAnYlBA6ckoRN95yfEM=;
	b=eS8A+xgJGjIE8HO5RM2ZL6xEUKCizLAjG7hbWgpF3hkl1su3czuNR8ykBu49gze5TUjryP
	0l7qHAh+AxqRvqmCtKbVAF0668Elbbm7JGiVyl3PYyHowZyagYLCFLSb/H368fTiOQcojq
	RaQ/lYiopR9fNKaKCHmIFq2dhPtZ8NU=
ARC-Authentication-Results: i=2;
	imf11.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=r9vHA4Xg;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf11.hostedemail.com: domain of ziy@nvidia.com designates 40.93.194.11 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1783950713;
	b=DtqrE2T24hl0ZpyhAKy/sc3ZdaUOYUH/9JlOWe7oSSgQt5rB0bm1YNR7WeBxRwAA4EuBf7
	qP6vxtdv9500Nc9kzJSeGwry8LchDxEnySluOah8fV4YHYEBFCueMu4fhj8UCqGOFS6SmY
	1Jw7ChMDiSdvvKdF97d6RVn4F75YezA=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ib18bD/+j3fNovSxT93+me5uX8PiLNakQckWWhzhILYPgL0Sywy5GanJotPBzfqQz58psMBiwHASiQLANXB1vDCyrivcjQPLbAdCdc7WLx7QY/m1COe+jspcAkahfl4vh5b9UrTLOSryCrVngufWrhw/QcwKWsQm+W6wfp+KHtVN4si3TuE/KZRKmJGARDnWrZJrIgqVFYEa8ET4N9jl5HSK+Hx+1+SABKgncGywmGM5d3+TZDzBNNjiApbzX7nIBvsPNwaFvvp4izzkWLf3DGzmktNt379KpgpJIET7xvsONIzMqdlxjjX6P6lQ0PriUnBHVQN84Odi4rUS2IU9RQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xkaZn802kLTJMYpAzoQptQF8VAnYlBA6ckoRN95yfEM=;
 b=p04GuttwauHntrYSg0IKYwoHQBWKPRZYvhpYnEYJ+ZhCCOax/kX8EKwJDpwieV8x3cZCUV/qDqR1hEAPVxVVBD7i74tJrTGotfU0R7PoNSWYLU56zGIxlzQFZDlKVxHJeGNGtR8tEPVQPD13dfU2n5M0YgUan5X0TvXIpl21jkY8yCjIwRfU6TalEWaDNO1coa94MeeA1+lzU8ZDiUMmSHV/5AQzR4VeWYO0MZbrzs8CDIaQpYScaURbIaSVCqZI3ZXzsox2XQAT13RTmMVV20jdckc3rGLH7X7lHeHqusitvcdrqRwwdvM9/7B9VQdJPesj6QBH99AZm0iR636iIg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xkaZn802kLTJMYpAzoQptQF8VAnYlBA6ckoRN95yfEM=;
 b=r9vHA4Xgl2NGxXmsq1DyrwwPReTIoJUDrLgTkJvTPRMh+hWztmzGGnrMKIqwvDn/1WO2cW2SvR/p3CSzZAEnqY0EyXhQ0IroNMDLCImYR9m9AdRBWry9qWKiTaznjCLCvY97i+faKG7FiqQryY+A8PgMFJofA47y//GRKkpA0Z1BxI0ENHm4wk7bFLZRf/oF0MLpULrWOFrDKyA36bgNhqgkhKbGlSVD1PXSgYF/2UrZo3Y/h5HpJaokpJqggoYqLx/MLjTOR7Aok8zUko2nc8Jat0tVI6yzklB2eTJhF3VRfr9ygIpj3hpYJJqi0lYgApjaA6My/2DeZs67J5Or5w==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by MW4PR12MB6756.namprd12.prod.outlook.com (2603:10b6:303:1e9::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.202.18; Mon, 13 Jul
 2026 13:51:43 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%5]) with mapi id 15.21.0181.019; Mon, 13 Jul 2026
 13:51:43 +0000
From: Zi Yan <ziy@nvidia.com>
To: xu.xin16@zte.com.cn
Cc: akpm@linux-foundation.org, david@kernel.org, ljs@kernel.org,
 baolin.wang@linux.alibaba.com, baohua@kernel.org, lance.yang@linux.dev,
 usama.arif@linux.dev, chengming.zhou@linux.dev, qi.zheng@linux.dev,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, npache@redhat.com,
 ryan.roberts@arm.com, dev.jain@arm.com, wang.yaxin@zte.com.cn
Subject: Re: [PATCH v2 1/2] mm/mm_slot.h: add a helper function mm_slot_remove
Date: Mon, 13 Jul 2026 09:51:41 -0400
X-Mailer: MailMate (3.0r7017)
Message-ID: <2C5D080C-4621-446F-A90B-03E729865C5D@nvidia.com>
In-Reply-To: <20260713143707966lCkTinO0i9zYAc1K2ZmqZ@zte.com.cn>
References: <20260713143707966lCkTinO0i9zYAc1K2ZmqZ@zte.com.cn>
Content-Type: text/plain
X-MS-Reactions: disallow
X-ClientProxiedBy: MN0PR03CA0009.namprd03.prod.outlook.com
 (2603:10b6:208:52f::14) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|MW4PR12MB6756:EE_
X-MS-Office365-Filtering-Correlation-Id: 91ab22a5-2e15-426d-ce07-08dee0e5df68
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|7416014|376014|366016|1800799024|18002099003|22082099003|11063799006|56012099006;
X-Microsoft-Antispam-Message-Info:
	KbEIc3GNXe9u2/Vg2ENdvO+z1MC2DdDOEFECZXJWpZemZrzq6iOSO66GlyR5BxsWR2MV2/QrpGsB7Gn1KkvNTecWyoUjSXPOBBXPc8rbfDiEZ0TQOys2or/6VZKWc6tHpNp9xtSvAWSzQENE3Oeu8QQdC1hNEqEWyhX3Vgz01QX3SKVoVyBwBVF+RNoy2sJ0PbwkXAwF5XN20U1NrdzBtBMpSaVUBrDR8fXn1BLFCf166aLLDWU9bu2yMfuuD+5tAJjuHQmYrV7SlIyi8bsyWQpgEVNyOkoJWxMOFT1jA+ExOTP7Hoi9MyBztA4Nq0qhhs/BlVSK17h1o5f00SkX0Xt0BgYZ1Z+TUMac3Y38UcKYXSq1I79p/0OIGZbRqPVBFUHJmTvB1g+ESGWjmDanVlH+iz45scqs+xHSka1y1zf/nNJyAqVA10D3tBeYRY691wxP4VEXzu7Ucs6tkGYMqBd1+Tw8TRz6SoOsEolI2Lm7DmEUcDr7VWPXgPqi2ktT1w7pq0Q8l+HXHmAHDEXsjAdO5zDd5EbrOrByilFR0l9fhRoMRx9mw0Sfauj2xqItHkt9atqzLba9VJzgkbFbXSnYYWepvR+VJexSDZCfMsm9ZVlWYgOfCT1wBkkl4/EIonUaPUSQ3h9hte2OSFUUHv4xaKT/ULe/ugyzuwhMYSc=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(7416014)(376014)(366016)(1800799024)(18002099003)(22082099003)(11063799006)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?J1gBMBq2Dz+clFvsiSMS7tBaEuALb2CJ5ooegq5Zrb8XSOeDddUXo1a3YM9S?=
 =?us-ascii?Q?kwBTJ+bvmUrTWoiDMB7P91f4sLP/TU/bvbCzphGAAi85oheT4kZnTq2c67yJ?=
 =?us-ascii?Q?psopl692wAWWkM9SQ2ZaggeuVlraqOJzod0WSkabLuNKbWVgZ6HtD+n+Tz6W?=
 =?us-ascii?Q?clMV/ClLDmKQk4rXIJTCBoWGb7SU2Mu0mrRWSO6Qy+GwgmvOCgxPw7T+tz+j?=
 =?us-ascii?Q?J+bOswt2b18tm8hRG0+AC+z2ZDh1jxQXizfQAfaq7Ws49tRFqnkTrJrqVOJE?=
 =?us-ascii?Q?P5Vv3v1Z1rzUoJjwggM2UBfux69q/F9wyGkv5hKQPxkIG0NJnKb2aRURrHqh?=
 =?us-ascii?Q?SXCyMD4DrGVhLGm90f0N0p/l2ZtHgemmZqPnMfyF5th5241qC5+glNedK/J6?=
 =?us-ascii?Q?EFQekvOf8EzR21Q9zGePtRkRrTxGj6MqmLK098Kuox6bXVJz2u9zxxJ4Yiu0?=
 =?us-ascii?Q?Ho27vxJYhj/HQu/mQt7Zi6xAgLea7TnemiECdwVVg/ovM3vJBg9wtDf8pf/0?=
 =?us-ascii?Q?E7B6fcVgiiPX5tDv4jaHQEqxPtmGE5kn43X6UiWIoAMPFtvfJwXExYooC4VU?=
 =?us-ascii?Q?I+UCm/DnBurmqIr0RTNjMgICmAum8tpZb9dvxhlZcuAljWNYzksffSzy7Vai?=
 =?us-ascii?Q?hrITLqnqOMbFMwtvk07lnOo/VoRoaePGsA2vWyWh8Q5m9JUx/nWL5Wu2h4iD?=
 =?us-ascii?Q?+Gr5y7XtvLyy/+uXzEmHbAiHdV67CnRXH/HlXpSKtDCulpW5wR40tytwAyv8?=
 =?us-ascii?Q?cxKPuSeXzJm8t3Vj30uqclfxIbyqaD/QDIgKP/PUeTyCC8TSzsLgoD+hfNSn?=
 =?us-ascii?Q?rOHpEm41amLpPU3GdGZToini/0H38qK0grTvDA7j6WiHldPJCKN56ushH3dj?=
 =?us-ascii?Q?rwC4T+/KPilJWADBHcWW7TeAF1i5S9UCd4ryqcB9L43KTXzBRHIMjbP589LV?=
 =?us-ascii?Q?Ad6gtHJ4lOBVxApwAAobDhtTsOQVHq5U4dD/fxpiZFjbUn9c2YqysW5IrjNk?=
 =?us-ascii?Q?tGKmY/Gvet0uLqernaModyPlypyLvbXTj00SfpINRyDRO79IGcE9AGv8bdBJ?=
 =?us-ascii?Q?VkJfyXf/AHW0HkCf9WO8l1g3lpi6zZ1s4ut72UDohqjXlBdl37327fMBOERS?=
 =?us-ascii?Q?sVE6vJpV1s6Hdn5lPFhZkN3IzR8lAAOhI6Qk2m5mqnXyYtnmvw0rQlUjWV95?=
 =?us-ascii?Q?4n46ScOucZ2Dv09tcAgFyf5ueFgm3eT4SOKC/ko+LBfAIP78+j90yLRXT83n?=
 =?us-ascii?Q?vOc9lsJwweu2CSU5loFZ3V5iLLOH5NcO+DjEHkZTBkZz4fhjaFSAV5BXy5sX?=
 =?us-ascii?Q?ubD6ALMhvqvO++78rCmYTlGUANtA7SqU9xKjT6KVLc6koIwv2Zs76Omo8cpZ?=
 =?us-ascii?Q?jrUSCEU+ZcStRJs0DzVzgFqaeCigjbeqIY1l4VgwMUcio3YQqk7VQikO3SoG?=
 =?us-ascii?Q?+C7UiwycgPzwlN3h04K2wPzU1YaFmFJ73Q2W4bikh/TFWiEvjMVq+yOIjUgF?=
 =?us-ascii?Q?u3at8GuQVr5fjGBz5XatWNqKbsiPv3uRLxjyRNGtiuEBCZKI/+jc9pUSOXFQ?=
 =?us-ascii?Q?25zbavLqnejGedYGjCdC/JGqXgbv5oPuAdunQKIa25N3Eaw/COFd7kMd6FKC?=
 =?us-ascii?Q?4R/T6VzspJd1pJIfJ0yy12yfPb9wJzmH4UbG8dPwDIIlniHdMpjjCRm+iKK5?=
 =?us-ascii?Q?1oUNTZLXM8f8ZYwReI80V4/S3bMH5Esv2BLQArXcM/KUkoIc?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 91ab22a5-2e15-426d-ce07-08dee0e5df68
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jul 2026 13:51:43.5024
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 18rfplayT2VwSxZC3VlKB6vem4OMpcsoWp+xraCaNx0bjoVvaIjr2qzYXB6EIb6G
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB6756
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: BFB4340004
X-Stat-Signature: 837i3d93ti5eidjrcdb8joe6p5kb45zf
X-HE-Tag: 1783950712-965853
X-HE-Meta: U2FsdGVkX18tUu7DiD6tXXdKrsIA8NMAf7/ST0okS7gWgCz3As54PXaEYXzwxPG2Z5rn+PV/De/h+3w0AUyQ3Vyi4TuEvq6jhVRKODVHYJ2xOj4AAXFeJ8C81LZJfYQsCviGdcXVS0LG1kt2hIEgi85npThsfwAgLljkQkP6Ra4CgK7s/NvSk6DjbB3jg37pqS2akNFSJ2p+ggFP58P/FC6syLc+dCseJUtSPS/jaaI8gipUxN69/6Hrg63MvGdodf1MV/xw92zycY3+UoR3revMUOSE9KcHasnGEMl2gQwaj4VdBzaoVceU786KONzwdO+37KtdNbjET/1tpvvaMYrMQa56KCoaQmtoes/dEfzqW6pYy/6D1JaysVxqBGDhUDXkbL+93Zb1ELVq5DcC5BIN0dfP+ZnuV3tKyWmwYUPvxAl/Ja2H3S95TWhQPyVZa8yy9PgS1COd+M5lMpW867mRMUsMPD8JF5frWWzqn8ZA0sJFQacX4x/emBI1ocDcSa9mHFhtryGA1TQqVu3+M7uJGHXL8f/dU8F/twbtxTz5nAiTI/T0PURDUQg9+ev6qwDLMWaUOV9e+IjOg2tBYbrpe0x0mcWTgaoYLtDc+e6izrHR6F1RteOM9WE5hFYht2SoLpuGJ3FTv+z4vxFD4AJQAQeRE2HsJ5nNgDg6bjD+Ds/TXw37X8W94vbz3M1TFG8uVF4bmYc3ULvg7nKxydHIvp1/vMjzexdBuGXPyZ7OLxtrjJ7f6hWMHwArPwISsxtUAKPXOHQLlafXCRKjOaOESmgFXLa0uzk3YMu3YE7rkZDSTL3JsxQ9Sv+yuxwPPsWZkadF4DKYfUp29SW3/ZIr7ru0zT3Wxf+yi3Z5Bs6Dk9be2LTIp25mXGdEVZqxFhroML5whosDcM8pT2/Ik85anlwwZ77EbmEkr98WSWjagesdS/fLsG5nLrBnuPExnd2PMIFBCUUDClV2E8/
 bKd9tdqK
 nqGqLyrUe1znKJCPAU69FKlRAyoUG1PXVIaVDqDorOYwkcHqVAdRf6b7SC1xqbI34C+aC1yO9HgQxkZ/FQZGLi22PYC67kgDHe7av6RulyVz0JhwJ18xwUgbsB8c0xJqui+7eY+5Lv1ryCMwU02H+oI45k4C7ZisRHaEq5xmyqR7FQfZDrlFPgE7AVvtG/CIoHAozo9zq+rp+GTX6Fp3w4QyCkxh52s+LVOVKsWjOTMrNlOPEHeLmHxoAUIFIkUIqA/lZXb6CopD2tV3Iob8BkJc8ECBbVzVC//I7Ly6fR6QsT9Ud3GN9omSgaekVdR9jc7O1o0ciUSa38P5/52z8Ot1LgEaWiS4MzwibaQ2lyiPh1ML1D877JPD/NkdTzYHBNr6UkooDYonz+l4GDX9GoEUH1cczkV1YUkyGUwC5yCdBuAhgAxz3VG9fmcEmeR01OxAqd0iH/xBynlwyi/n3UyVJqDYVJ322bQ0nqdbPg9plLQeinn+mRewdSw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 13 Jul 2026, at 2:37, xu.xin16@zte.com.cn wrote:

> From: xu xin <xu.xin16@zte.com.cn>
>
> Both THP and KSM manage per-mm scanning slots using the mm_slot
> structure. The slot is kept in a hash table and a list, and removal from
> both containers requires the same two operations: hash_del() and
> list_del().
>
> Introduce mm_slot_remove() to abstract the common hash_del() + list_del()
> sequence used in both khugepaged and KSM.
>
> No functional change is intended.
>
> Signed-off-by: xu xin <xu.xin16@zte.com.cn>
> ---
>  mm/khugepaged.c | 6 ++----
>  mm/ksm.c        | 9 +++------
>  mm/mm_slot.h    | 5 +++++
>  3 files changed, 10 insertions(+), 10 deletions(-)
>
LGTM.

Reviewed-by: Zi Yan <ziy@nvidia.com>

Best Regards,
Yan, Zi

