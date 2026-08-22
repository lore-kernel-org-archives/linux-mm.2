Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CE81DC5B572
	for <linux-mm@archiver.kernel.org>; Sat, 22 Aug 2026 12:28:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9B0DB6B009D; Sat, 22 Aug 2026 08:28:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 988B56B009F; Sat, 22 Aug 2026 08:28:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 89E5B6B00A0; Sat, 22 Aug 2026 08:28:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 648B16B009D
	for <linux-mm@kvack.org>; Sat, 22 Aug 2026 08:28:16 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id CCC121C0084
	for <linux-mm@kvack.org>; Sat, 22 Aug 2026 12:28:15 +0000 (UTC)
X-FDA: 85128832950.29.04650A7
Received: from SN4PR0501CU005.outbound.protection.outlook.com (mail-southcentralusazon11011006.outbound.protection.outlook.com [40.93.194.6])
	by imf09.hostedemail.com (Postfix) with ESMTP id D7344140003
	for <linux-mm@kvack.org>; Sat, 22 Aug 2026 12:28:12 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=ARu+gKM9;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf09.hostedemail.com: domain of ziy@nvidia.com designates 40.93.194.6 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787401693;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xHK58u6WubAcaP+k9evBI8wobQCnrso9+yZAbv6f8lo=;
	b=gYouLzfWHJl8Rt8DQ0d/NevgMEW/fk7z46mS4GZfStzzhlmW8oEhv3xRoYMesVwjF19fw2
	++xqRt3LNGy6pHIWvK+AKS7i2/1z99LI++q8JXxH7AKH0aiWpgDNnkKJ522eukZWbI/u3O
	fEXUdtRbK0v/TOJuuMu7DvYNSWM6bc8=
ARC-Authentication-Results: i=2;
	imf09.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=ARu+gKM9;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf09.hostedemail.com: domain of ziy@nvidia.com designates 40.93.194.6 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1787401693;
	b=dPvIzDDopHF5i2SW9rUJCrldPkp6IdTfHiKPfwRTYENETe4XA7mQWyNylA2UnySzh+cgbJ
	aCNO/y1ZAgJYPibxiBx7Q6xbtEw76Fvg003Kp4Byo1wB1Hz2/3aQcwgQ/Tg2dh8freRZOf
	B4rkTaiIks3HPxKw5Jtolg39h72LyBs=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=tb+/mjRJHUZaPTaMXWSK9cUNbC9WVQHj6g1go9cwDOTp1sr3UnTC08gLFwT+z6XcshYvz+6viEvRgh2zkQ4I1RvIEryHnncfGzgEBLJqhF/dKlGvFHB2JiF8Yj62SES2/qaZZgdY/UWMF1dWWXTpJ0lTOPWWdXcbjPwWmyPGdGpfkaCqjikoFa7PFyRcpqoQruRNCy8lekjLBHXQiknV/lBOz+E2bQrgq+FImuGmx+10BaczarA96K5PisNWAJLPXCfHcfZOG+xm8fLaoGZaRIrmwQZ7046vyBy+fz9QNxaYy4dnrzMU1IL5tksy1dTTLBzzqhpBaKdzSmUqs5NpHA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xHK58u6WubAcaP+k9evBI8wobQCnrso9+yZAbv6f8lo=;
 b=DN4gjmUXOg7Bu2IoM+1hBY4Xe8yxTFdeGwfu/Kesx+oRS3rMeAfPzqXOefbAoAE4fdyXD/unlCjkDqq8BcYy86v/bHEw2d9HNgPyWGpbG1hWytAPQ7eix0lfV1lvTxZ5ebwZZ60m8DkR1f8Rsa5LQP1YO7kTV9nq/68Yw9ihMBxke3IbADUIVvFM+HIq8F2NGy0v8MFqHyGHPoj5hWPN5tJ6PIQ2xiaIKPy/OUKIup4Fu3ysH9tjeqcGD1gPa0qgKFN3HmKgRBDzh6bR67jefz7Erz83oxLsYSYj3KDU6Iri5OGhBR8c5/0q53gIE7sFVxRwEjZ66h+vfwdRg+TW9A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xHK58u6WubAcaP+k9evBI8wobQCnrso9+yZAbv6f8lo=;
 b=ARu+gKM9fiDVsSLLx+f5gqBSOayI8aY0XTUplCE4h0T2OoQTzwQQNnY85U0XJtUB9wOTF8o8/ltCk6tYCN2Fe3BtXVQeNMCTmlouMFXQ7P32bLe0nWho5cwDkxAw7Gcwi0exYBrTMjliS3wMkRNXWGvwIcL079OZnZ15gUc3NJFv58VTuw2fMyrAMjFBE2Rgj7i50WxhCfbNStvjjuR1o5txp2Zd6U4/07zqy5PH5oGH/UErxh7A8wpP0nHsjgSue+STHD+EX757rJSU4egt6f6Ds92Wlysrxt4htTtrEQTSzAbkRdZMiWagUMq+jCoK9xSz6cuPkO4K9eKsFwlMsg==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by LV3PR12MB9168.namprd12.prod.outlook.com (2603:10b6:408:19a::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.339.11; Sat, 22 Aug
 2026 12:28:09 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%5]) with mapi id 15.21.0339.010; Sat, 22 Aug 2026
 12:28:08 +0000
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Sat, 22 Aug 2026 08:28:07 -0400
Message-Id: <DKVH0NGOIYZP.3MGUBJ9WWUTCG@nvidia.com>
Cc: "Matthew Wilcox" <willy@infradead.org>, "Shuah Khan"
 <skhan@linuxfoundation.org>, "Randy Dunlap" <rdunlap@infradead.org>,
 "Andrew Morton" <akpm@linux-foundation.org>,
 <linux-fsdevel@vger.kernel.org>, <linux-mm@kvack.org>,
 <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>
To: "Karl Mehltretter" <kmehltretter@gmail.com>, "Jonathan Corbet"
 <corbet@lwn.net>
From: "Zi Yan" <ziy@nvidia.com>
Subject: Re: [PATCH 6/7] docs: xarray: Fix xas_try_split() name
X-Mailer: aerc 0.22.0
References: <20260822121651.1559-1-kmehltretter@gmail.com>
 <20260822121651.1559-7-kmehltretter@gmail.com>
In-Reply-To: <20260822121651.1559-7-kmehltretter@gmail.com>
X-ClientProxiedBy: YQBPR0101CA0333.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:6b::26) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|LV3PR12MB9168:EE_
X-MS-Office365-Filtering-Correlation-Id: 20ac8dbf-b228-4997-99e1-08df0048d2fa
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|23010399003|376014|7416014|1800799024|10067099003|56012099006|4143699003|11063799006|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	vTJSRObckMRtdlZSNV57TfnDV9+LhxB6XL1DrQUhsR4mOxoIdO5f8ruUCeXtEdJAcrrVlmKu5Gr3gv3pi43ngU/ZdmTIqm99mepehEHkZsVx3BkK8oj+E+4ND+bmQ5a06SW7ksqh4FrIBgpT2urhsW4w4xe2IHB7YVjQLU3j89x/JMJTJPmfdDjYi77/E0k7vxgA48kz6D1GS7ceMDQA/cwTbpv2a7rHi8JLqH9ywWkgy6DpFQQ2NdoYphZXqyW6iJMoTSBt8bpospVGZBqbfvBsPHhgrP6X9LnFVwhJoxA2STMLadWkfKm8wTPqX+e4TiPrX2OKS62058/kr4XFIRvTqP0eMJOwzWFMt8+xsd9OOR/woJ/gb+ctmsntjdHTncOw4EvifILbYR+4haIBUk185buaH8gDL06gWXKJYa9Km1Kog6vlM12RQVK0rUPdMiAtrXmXpZmUERuFjoI5TuCNGlchghWQ92U18+sWAoT48rlkLJldZGgPnjCzciEFuPWL8MZOv21DG9IkWDEZ1OL+6yfI2pwRkK1741ayq/LJypWxqqU2G52lLfT0PDSehFXsM6ZfStmnTnif2JLg10vBjHO5s6C9hqOYD5UmsQ1hIKfRw19gGciQOFtwyfgCTNYd6CC1FMiD9ExQY+bNcx7Zdu8o4l2OC8zzdK5XA8U=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(23010399003)(376014)(7416014)(1800799024)(10067099003)(56012099006)(4143699003)(11063799006)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?RUFiZDE1MVhSZEsyV2hzUTNZbnAzMTdOb1h4OXFlb0RJOXU2WWhJMGlTb20y?=
 =?utf-8?B?M096TTVhcEhZd29WVUxHbmVBRjhhcExMbmsrYnhqZ2h3emFNZmQrTE56TUNY?=
 =?utf-8?B?NEowOGN0dmZSS3o4MGtZTHFRbGdvTmt4SnRDN3p1Y0NtNmM4eVoyWVVTRTJL?=
 =?utf-8?B?aytzOFlOcGs2TWswRDlPNThjSmRJamQ3VVk4SVlyR3VIZk9DMlZMRWlzazhx?=
 =?utf-8?B?VXJub1lDRlFwNW5iM0NocjA4ODBRNkdyZGI2Zzc3UDU5ZGlQNDhPUFdZdDBP?=
 =?utf-8?B?THcwd1lTc1VBZkwyTFdYUEhVSEhmTWlqNnJFQ2IzL2Zrc1ZraEY3VDBQZ3Jh?=
 =?utf-8?B?bWxOc01vVUtWWGltMStrSXE5a1psRTk5NklKdFowUGo4ZC9yOFl3TjZtR3pU?=
 =?utf-8?B?ZVc3MHdLY3VXd3VibTdOZ1YyNHF2VHJ4K1h0dmQycGZsL3lWWmt4ZUU5c0xp?=
 =?utf-8?B?enpFYmJGZmNYMm56QXZreG52Ylp0dVZvUmpsUGl0aTVBNml5L2tNY3FzZk5Y?=
 =?utf-8?B?VEh6SjEwcHh4U2ZhLzdjdk0yZkRaSGttZ3FTUEtsYWN3Z2JWTi8wUGVBMTRm?=
 =?utf-8?B?TGczS3k1MFpmOGwvNkN1TmUvamV3M05ZTHRlc3h6TTBMT0RXVmdiMGkrazVH?=
 =?utf-8?B?M3dPQlVCLzl1RGczcU1WRGEvUVdKemRhaWgwRlp5by9admVsK2t2YnFJQzhu?=
 =?utf-8?B?c1JBUXJ2VXl0V05YWTJsSTQ2enFLYkFrV1ZpZ2h4ZDVadFF2N3VVRElNMFFD?=
 =?utf-8?B?NEJzc2FGMEtYVzZpZFZvbnFWbVdvcHNKbFhtQUdzNUJmeVlmc2xKbXVFRlFj?=
 =?utf-8?B?ZndIcjhZOVVMUkRDSWtpMjlDUnprSEE0NGJmQ0ljUGlYVENXS2c5Y1l2VTRI?=
 =?utf-8?B?a2R5SHdCQ2cxSDVxTHFBdmNHc25ObUlEckJmRlhJMzJjUkJqL1VaRWdFV0Q0?=
 =?utf-8?B?TUE0QlAzcVoyZ1czWldxQ0p5T3pBRkRhb29QcXl0Y29PL0sxd0tla25lYXda?=
 =?utf-8?B?dXR4U1VaQ1ByYkhuQVV5VnI4dUpiUWx5UUpxMnRwWTFqbUNDRk1NOElPY29D?=
 =?utf-8?B?MkpGU3dPQnZST0VNSEpmM3B4dUZabmc3ZmxSdWNNa2YyVkc4WjBuUDJCRG5E?=
 =?utf-8?B?cFFrRHV6VlJXakVUUXdGVjhSclZIREdCbVFwN2k1UndLd0tEc0hlRHU0MDZz?=
 =?utf-8?B?UmtYclN3allvQklKY2I3Z3lUQ3JIVnV5M0JjaHRnWkFaVHEwSGxQaS9vR3lD?=
 =?utf-8?B?VjFkTjlkLzcwdHVUaDRnWXRSRkFxZnYyVW5nUUtpb3NzNXdSSVMwczNwRjdi?=
 =?utf-8?B?VUd2QzB3eDZ0MXRndlRUWDZka0F5eUQzY0JpMHFZM2hhUko4a0dGVDA2bmha?=
 =?utf-8?B?ckxKWnMzM09Ua1dsMy9TeVpiUExCUHVqVk1DUTdWSTFJTUpQVUZkQjFtSHNC?=
 =?utf-8?B?MFlGTll1NU4yVzlpQWJUQ2kwMUZYTldLdDRpWm8yMC9vYXBkM3J4RVZ6VVpt?=
 =?utf-8?B?VlA0eWgzQitjNHdmL2w3VitQRy9IR04rMWJKcVVQTDcxTlJNMXZkTEJtWXhi?=
 =?utf-8?B?U2tUYmFQREhEMG14VVpYT2c0T3EzeVg2VzMvYmRySWFGUncvWlJ4aHU2QlVO?=
 =?utf-8?B?L1ZCRmpheFdvZENMYUxSbmFGNTlWbUo3ZC9FRjR5RWYvalFOSVQ1N2xjTkxX?=
 =?utf-8?B?RFZCRUo3Z3JES1hKL3JZV2RCYWtNbndsSEFQdENUUDJ0aStpZkZrRWVCTkJq?=
 =?utf-8?B?a2tOU3FETmdibjRVN3lHU1EvMnl2bHRvL1poeFJIY0NweDA5SHZsL3oydG9h?=
 =?utf-8?B?M1N3UWl2YUVoQVVlTU1ZNnRTWG9ob1dVVlRYVzVZeXl4Tm1QK0dyVnhGUFAv?=
 =?utf-8?B?RVpiRDRMWWFhZ1VXLy9iQmVoTXBUUlNXdTk4U2Vkd2sxMmVGK3YzUFlkOUlT?=
 =?utf-8?B?M1BGc3dYaEN6cFlicVFJLzNwNHZlWjhnTTA1OW9XU0p2OCtTcWR6eXBWMVdo?=
 =?utf-8?B?eEI3OWREYWVxdGsyZ3BESCtLNGZQSFplVXZqbFRscUZFRkdvZlQ0ZFQrby9i?=
 =?utf-8?B?WGVva2NOU05sUHpEeHZrOWJ6aGFib3VMK2JxeWVmWWdXVjQ0VzlzOUx5UDcy?=
 =?utf-8?B?M1pSRGZ2Q3NoUHBjZFYyeDlkeW5Ed00yRlVWKzFKbnR3N2UxNzNVUWp0S0g4?=
 =?utf-8?B?Z1I0aC9rT2NVaEROTytPdHR3ZDhVUnhOUjB4TEQ4alVMTkc1RmNZbkJ1UmFO?=
 =?utf-8?B?V1RSamo1MnBKWWZ6cHgvTHViS1FESU1SRjhBK2RvMURjWXdIOVVIQlBUUFZX?=
 =?utf-8?Q?ONJyXnQre2UQCdBYuQ?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 20ac8dbf-b228-4997-99e1-08df0048d2fa
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Aug 2026 12:28:08.8220
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8/pC7fqoV2eCidLZMKsWhwWiutFlqMcnoebRTgWvLYN6D0GqDFmGaUoO9JxmCnfR
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR12MB9168
X-Stat-Signature: 64ynpxt5ss4xm971t8iq7dduoa1bywwj
X-Rspamd-Queue-Id: D7344140003
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1787401692-229464
X-HE-Meta: U2FsdGVkX1+tTZDO68dfI7LCCusW51ilKE3bEAUbpuV5sQAcgdy0TD5rSy6UMzluqckNYFFKoV4KW/Yz5Mdw0uYlDUdi+PN4+vCcgSZwYONtsRMaNMc/GQDEV3gMfrwgt4WrcqpXnmz/VvHJprPH8zCe88qWSj1X9m0zfEpXCXI0tmythrR2e0YgBtnLJuMTLdyrDkofB1tJu2EpyxXBhyzjaOwwJ5uJ5ylqeVyRyw67WnOjXc8o6IzaNRAwsRnqgLejnauSyoRCNzQiG4C/sk7ufaKIQkn83tzdFvzaOFH1mHFAW3c6yAerS+24DWwb8KdBR5IE/VPK6eZ2pL7dD2L0oSEgeGZg3X3GWWAodjsf+b4++4W2SRdFpIHIQ3VLDx8P7DcwYpXzQg0+ZD2pRkM+ZHoxVYlwCpC5j/C06sTZMmAbmBBQ+GN/wty6zvLEA/6I9iPNoAcUdYCM0OAna1/l4Qj7E/M8xgLhoynMopAsogGgIHSsVt62gBTLi4+Gaw6YHM5r4sG4dMu7DwDxYlF6nxviWN/dkw+LL5wA6ucrTanfmqXa6t7SyBGNJg7eDUjrf95tZEG1X7X/1YYaDbCoTlxWszPyDVHdMfqxAK/1HoyGPkdxa/VcLLGSEhu1hgRfLSvYj57Rb4QUKo1MgALsvrDOd3OnBHv4Mgbku3MgiX8+LdPlZY9Tk/oKdxDmvAX0lbVZXHLZTDjdZgEkCMBnqREe6lnWxk48Dt3fB60W2TtoYsBjQw7R0m2us6AdW9nAAIq90Em0zjrNxmqzqyuhVsq1qZVJ9IG39n009qhm8XKGoqzLBlr49uuIwRI33dZah86sgWzpIxtcUCYSlr0thwXfpllhar8gtBmyb46u1v3ecSFUlcpgTC7XvR/wCOIm13y+gkp3O80Eqm+0jAPex0IVyyraf0cFGr5nvlJcuDzEXg28bljvBrHO45VGKeHUip/niSONdK5jb+z
 RSN7YPdy
 i+LW4GDObcfvssfy9dmkEMcTEHsSre9xFzluqoZculbVo3ibin4z65dL2KIju6cvSzknyzHiDmflNmUSEAoCauZoY4K/U0Y0t1fxoBuK2QQ4L/M/65LEafY6Gko8YrjUxECPUVXx/VL9zMbM5z08R5RduR6hQHJrbc5utvYOiQMU5bqTuJOloT5llz8Wbs0eWx9GZK94RffhXQvMXAjU9UciFwN8xkXwIuGe948EseaKOm1XAz4m1qnTYlI1PYrJlJFl16mlgZPrkXutLdH2uCciDuRbQoRidpx3eSD74AwDrw088W+EOz51+RJ/hlWXfgCcJKRmyn5HcpuC2LAddweW8lputaI2+jDNNKtGaPmyJsRIM1qraFDEndcawA904WG16m39qwI9hxqqfcac2930iTt+tp7D1kGsQAvoMi1tAY6sXRltDDAKTCMsl4Wh6g+xfFb5R+PrYOKo8WfqrPxbLZQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat Aug 22, 2026 at 8:16 AM EDT, Karl Mehltretter wrote:
> The iterative split helper is xas_try_split(), not
> xas_try_alloc().
>
> Fixes: 3fec86f8aa8c ("xarray: add xas_try_split() to split a multi-index =
entry")
> Assisted-by: Codex:gpt-5.6-sol
> Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>
> ---
>  Documentation/core-api/xarray.rst | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Thanks.

Reviewed-by: Zi Yan <ziy@nvidia.com>

>
> diff --git a/Documentation/core-api/xarray.rst b/Documentation/core-api/x=
array.rst
> index c6c91cbd0c3ce..3d2b20c05a937 100644
> --- a/Documentation/core-api/xarray.rst
> +++ b/Documentation/core-api/xarray.rst
> @@ -490,7 +490,7 @@ entry at every index to ``NULL`` and dissolve the tie=
.  A multi-index
>  entry can be split into entries occupying smaller ranges by calling
>  xas_split_alloc() without the xa_lock held, followed by taking the lock
>  and calling xas_split() or calling xas_try_split() with xa_lock. The
> -difference between xas_split_alloc()+xas_split() and xas_try_alloc() is
> +difference between xas_split_alloc()+xas_split() and xas_try_split() is
>  that xas_split_alloc() + xas_split() split the entry from the original
>  order to the new order in one shot uniformly, whereas xas_try_split()
>  iteratively splits the entry containing the index non-uniformly.




--=20
Best Regards,
Yan, Zi


