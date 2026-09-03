Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D51A3C624A4
	for <linux-mm@archiver.kernel.org>; Thu,  3 Sep 2026 13:51:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CC9F86B00B5; Thu,  3 Sep 2026 09:51:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CA0F26B00B6; Thu,  3 Sep 2026 09:51:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B68826B00B7; Thu,  3 Sep 2026 09:51:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 86EE16B00B5
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 09:51:08 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 204D41A032F
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 13:51:08 +0000 (UTC)
X-FDA: 85172587416.10.2440B88
Received: from PH8PR06CU001.outbound.protection.outlook.com (mail-westus3azon11012009.outbound.protection.outlook.com [40.107.209.9])
	by imf02.hostedemail.com (Postfix) with ESMTP id 483F380009
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 13:51:05 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=QBELvnDV;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf02.hostedemail.com: domain of ziy@nvidia.com designates 40.107.209.9 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1788443465;
	b=V2IYma5Mlci8GhpfQUiCF66wNpxsud/g7mHTxTZdV8HUqJxVZ5H8F99z42YSIV/gOCHSmC
	iv9xwG8aRXczSPhQBcHH3V1YJjbNMWTZXptEDLBqyVBiUZma+JwvOcfcRNLNljtlbNIexn
	3I1TA4Um+R7zoojvxvgCwnPyKLA7v44=
ARC-Authentication-Results: i=2;
	imf02.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=QBELvnDV;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf02.hostedemail.com: domain of ziy@nvidia.com designates 40.107.209.9 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788443465;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZoXJljDt4l+WiCLEO93RA4EgqLHHixuBkgcFvlR0U1M=;
	b=syVW5AYkY8N8HqAZS09WlAyFA7mSBFORsXEvC9MoElDzRP9ODgBevF00lARUHR3IUCxtUp
	H96ZW14EUFovbumUt1yojQDPP7xRD/hqJprX0N/ou2csmr9Q1PGvuBzhlPz8lN0IRbNFDR
	nxAPYRnOeCKsqW5sgba1z2hhOYmTu7U=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=kA9eKTReSL80EuFnlU8BT6sGd6adieCL/ioifM78j4pew20PJK/gpr1uAYAbNuoY3fLK1kyRgc7EkEgtT1KGYH921tD3l4mZHDeSNnL8UCe+XXUshecHV/Qv5Mj3rg8Y+MeofoOE8Ub1u+btRYj7ZKVe1JAhp/hVqtmkrFrsP1PgV/JH9ZY0Gk/5C9FHsBwAmu7uUXY8TI40xSHBnK/fyvZGegpLpnjE2xC/NUkbxzWRDsL0xYNphuQw15PPwa80UK37vc21WicBt5L7TVRm/gjCn3COyudWbW8zeOodwjKKjPbXxKtuP7mAdoTyFEdO46DZukwnmWRQb1JJgb1A+A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZoXJljDt4l+WiCLEO93RA4EgqLHHixuBkgcFvlR0U1M=;
 b=V26c91GGf3wUQf/gHlr9h5tdrWF54pXh/05pacqCbD9R4ezy2j2/VIDWghs0tuD9GIogjoXc0YE0fMZ/QYR7HKgsl6BmU2yAukYPL7kuQignK2CapIOyG0JbSiuFaQp7GXb6osdzlXzruoFBErfP4b/oF/SOSY6mIPhLE753PwS+KCwRN/lcLRnaOiy3T1dHyDTXEsbZzyyThbReCB4dgqMY+WyCQXuiilpF946ty4EykIi55XUPD18jZcFJkGSb8nY5VeT77LKJc33boQSwnlGECeT9gIhNGkiBd8/GgAuGkzAxSSMxBGGh2a9hD4cC/Ks1KXZGYMY3lYFTV1ZtkQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZoXJljDt4l+WiCLEO93RA4EgqLHHixuBkgcFvlR0U1M=;
 b=QBELvnDV0nMGoCpVD2U+bRvfNdQePPLGk2WE1Z9cVhjk4OXqG/Q51FTdynL4/h8g0yqpt9aM2MBtSVmS+Nks4JEN9wvYQN1I1y7x9rfysNiJuLDfgSMYvvSNtEmbGEY9QqAUgmeFEW0axklvwx/F4F8MSC4f7MyZYXlMTJ1lHu/yRKgCQ+lpW0XoT80VC2A3q0cSBhBScY99NNPA191sCmr5z+eg980uiHWhvlPtBtwabqk8s4032qwXcKXEI59hlyzCZiIAfUYrMlT48GFOYHqsy4QLWJnpKz/glbqq7N3pUndIUbgCcuzp2tZiYjqjwMX7u1fI12TUVHlGFcDCOA==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by CH3PR12MB8331.namprd12.prod.outlook.com (2603:10b6:610:12f::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.360.13; Thu, 3 Sep
 2026 13:50:59 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%5]) with mapi id 15.21.0360.008; Thu, 3 Sep 2026
 13:50:59 +0000
From: Zi Yan <ziy@nvidia.com>
To: Christos Skarlos <christosskarlos.kernel@gmail.com>
Cc: akpm@linux-foundation.org, david@kernel.org, ljs@kernel.org,
 baolin.wang@linux.alibaba.com, liam@infradead.org, nico.pache@linux.dev,
 ryan.roberts@arm.com, dev.jain@arm.com, baohua@kernel.org,
 lance.yang@linux.dev, usama.arif@linux.dev, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/huge_memory: fix various coding style warnings
Date: Thu, 03 Sep 2026 09:50:57 -0400
X-Mailer: MailMate (3.0r7028)
Message-ID: <DE50DF72-2F77-4B7D-8A58-A071B0E56F74@nvidia.com>
In-Reply-To: <20260903092200.88910-1-christosskarlos.kernel@gmail.com>
References: <20260903092200.88910-1-christosskarlos.kernel@gmail.com>
Content-Type: text/plain
X-MS-Reactions: disallow
X-ClientProxiedBy: BL1PR13CA0068.namprd13.prod.outlook.com
 (2603:10b6:208:2b8::13) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|CH3PR12MB8331:EE_
X-MS-Office365-Filtering-Correlation-Id: 342d7aa8-6e56-4bc4-2a3b-08df09c26288
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|7416014|376014|23010399003|366016|10067099003|11063799006|56012099006|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	kh1XXfMVh5PwwviZu+2JYqQy6kj7QCgl5K696g96Ggk+QdSUzUgEcTpxNoLLjg7LPfA1U3Rs6NEeKqIwrVimLJkn9BBg0SMxF+Ehm6f93TflF5pNZxTd2Gm3JNoTlZFWn3tmBtYvb+LWXrJdqg5lAmo7UwPWmMeWExtl6CMkPwJ5zdHMZ1WFK+qoY58QUnoTNUs3ZgpUUG+wc5a0W6+ED3+wCf+Epj4cD4Jw+p1EfllxtmgvQt1uN7dCE34vKRLewD1+VLvvwQ8KWiEAejlI0dbxAI8qmZbXfi4NuvX/Gm+GkRK8TB6369WxIL9P1vI0UOX/0rrIWsOJUWgPE1IVdnFHZBoPckvPzha3mbXk5H4N+KhGbNZdFtBUW8NO89BCaOOk/88tZrqUVrPoV2BS5hi6TRHiSDHg2FdPBw9dC4Bi2/CELruQx13i1Ma1TkXKYQ04y94vA1Q5It9O/74zdZqz5obML1Vx49GR2kS91zCAAdiXyla17k2NKPsxlvy54pebVEcp4KfDpZUDXjdAjA7veoNmiOVxLS5vclL9q41768j1tT+VaSjHC09H4jPUt2GZLnMIysF/VLUhBpj7LnYE46YZlBAkwEbsjKBvQIgcvcIyVPuspVPKgMWcwU9RJ3gslaCURrLUHV3Ov7/5rmIE2gKbL+P9S0Ol4ujvP0U=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(23010399003)(366016)(10067099003)(11063799006)(56012099006)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?2e8X2tWXnmzl2MZcLYhzmjxP0ysvGcYqTDRTnGy6eZxcSlTN18/3zwaZR2tS?=
 =?us-ascii?Q?Jy/X8YlPZFE0DeArH7twPSmUN+20pnjqr97Xh8wKB+BXjR43X8o9qav0YRGw?=
 =?us-ascii?Q?XxdU07iYBiuv3Kz91+TA6OsBBape4VNMYJmsAkob+cHyq/lgLUSP8Vu1zXaG?=
 =?us-ascii?Q?lug7HbwipCP8YzxoDZlW7XS3BsXU9W7xDP/JJ0liSYeQOzWQ025LFuxQsLFM?=
 =?us-ascii?Q?6w9LeawjNqO2UxjdgAjtE65+ow7psNrJttl1ikbfeRA+UG9QVsCNhqUD6Y6S?=
 =?us-ascii?Q?bC0hSOFCQFn5Lw9cMBmAE5pu7cniLhULNHPiCjG4yhaJ+WYzEYU0BcOZRvcl?=
 =?us-ascii?Q?TpQxFb+RaGbDUAZ7LMY+hHDZSjAKn7siZ8Ck5cQNEJyeBXqaPTNDAQV2CVQ5?=
 =?us-ascii?Q?Swjqgn086klwLUfDhhmGwVQWvVY4y0txIrZvyKEH7CCpneu1e8yrQxT+VVLF?=
 =?us-ascii?Q?AXxtg9CMTYWObVmjUOioB3cvN1/s/8laXta451xMcZq9rqYpgS77joiLeCs0?=
 =?us-ascii?Q?vQFPTdOITcfZHMEYpwhfGlfM0dFQR+PixmOXdKUEEZ+JU99yd63Y8XPLhSFn?=
 =?us-ascii?Q?XlV7dBoqicgWXai+9oLeOlQORBNR7sQCUes5w11zxZD3MRVzloPOY2AQ5ozA?=
 =?us-ascii?Q?pr5QWAJA/FSUvi3DornwKeFy+6maKhBpHEoe+MWNDRnPO7fjgiL4x/ypDvt9?=
 =?us-ascii?Q?woEZPpDHEcZ40SAjb+osy7IUg5u/RIUqFF6RoO8xoRZ+H8vEuYj8RxMyzC4J?=
 =?us-ascii?Q?7hBhDsOGeCl+M3oi96LhaJOih6QYTNBnttUUsE4LEdRmLDKfKnKfRiGesL9g?=
 =?us-ascii?Q?Vt5tJxMwcXVhRZiwufNhScPS37TWCHc7g5GjbxAxCyTxkajgSHkemVdu4L14?=
 =?us-ascii?Q?E+bcHFaedsDVukwJbLYHiA5lqSfqA6ZJIziPjK+HDQ2KYknyKDgW0fgaQhS/?=
 =?us-ascii?Q?zGPpBRpSAic0uF+YWN6Sm/0ZSUyVkiDpvpvii0l1mJIjtg0UrVnEs3u0QWRK?=
 =?us-ascii?Q?iFgKmpMuzXrKastEJ334AcLcm9B9e0vfLFdvdtJ7Kpe2UNvWycg6LIVpHYFq?=
 =?us-ascii?Q?ifvftU7y/H4ZxGDft2ih4mvqCF9+ZVneSn3qSFSGlsmccQJN15By9qKuWrA9?=
 =?us-ascii?Q?aJ6LhY4S70K6Uisqx+WVK/lu3EkWTStjVJ/L2VAE9amrY+egN2MUjmtGYoY/?=
 =?us-ascii?Q?o+rAYpeQTVbTvIcm2EAGmryOdvI3ASPd+Fg+Uuxwhm+ANy/I9IR7yE/dK13e?=
 =?us-ascii?Q?Vtgp2BV0uHexSsyuFcqzY1BNTNfhGDiqVqs8EtF+JhZM7TcYKLopkGS+4xTa?=
 =?us-ascii?Q?FdBe4lfR6dLOYuynnCQRR1vgPc69M151ZIAMcOH5AKmixbioN0sYGlcCS5J7?=
 =?us-ascii?Q?fgR/v7HMKjgZVLuVptDJBDVAFtcU89UVXEx51OjjXABFFygMfyrl6zxFU1lL?=
 =?us-ascii?Q?sxDmjCqhw3UpPJEL1NOCH1+vVEKK/eU7lgWwbRAbf7LG2PZXPuYtWWmhpXEF?=
 =?us-ascii?Q?LI/1VCGLv7MQLnHuMbB9hOQRYAGuIH+c4+4oNbDcTEEwB+I5z8gwkOxDhAAj?=
 =?us-ascii?Q?IGGegMjKIR2Zaf50t/8huvlt/t9GMUQgVKYW4PQX7aWQ/VeLLoXciNjiEtEB?=
 =?us-ascii?Q?CWhiMyMi1JHKFCxH6hHg0P9FMSZ6zbeUEvlzJfeA+xqQxZMAhUr3ptKHve94?=
 =?us-ascii?Q?Q964Yl8S/VhnYalAJu1zCu3mLecQsb+QVoYrrWLaavdvbJVd?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 342d7aa8-6e56-4bc4-2a3b-08df09c26288
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Sep 2026 13:50:59.2386
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LYTg8kfuAtDCbyHwW/Sbb47TdAZhoddJXtX5bBUfuUJrkMxV2N+QuUHM6oSl9Ohd
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB8331
X-Rspam-User: 
X-Stat-Signature: ouy5j95mhmk4dh9u3auk45pnmpn3yyhy
X-Rspamd-Queue-Id: 483F380009
X-Rspamd-Server: rspam06
X-HE-Tag: 1788443465-632313
X-HE-Meta: U2FsdGVkX1/kh0fMr2uEXWOI3daJlMAHQZrRuc1Gosf6WB34bxqb+eOXFBQzCF2Qsxb5gX9HUTjfJeE1HzsiExyl7mWMXXjkViuUdbxMqR+T1EhkRaX4U9CbHeyA5zl3Jn3ER+iJbEydPfuWhmxW+t3+TB0XrWe1XkwsKPfxUReSj6eN4NK9//4FGWjAapgqTGtl3vydv99knC3PSmhNXK1/thSWBQLwHfPU4zbtwfbO0LXyAnj3od4PpwTRv4170KZhpekrBITkR0xfMF5Q4xyzVO1etNOJ/NtM9OMnulkWh6XXXhpH5kLcgfrGsbghv+s2BDdmXgSnSlz8uYWi33cNpg+50p0XCQsy32WVvQivu68d0BrTMEIVmdd9XprcCMYU5+RC4tK/ZZ+QqGK7wNqiBj97BnaEu1lVUoepyqBs8LmiQx8c6FuAqTjq+Vv5iktuX7z5N7JVSfH2jVovSSuRUwk5+HbWDtBqcRysvLeRToMBgG1K+CwY6Ee/LY1ldhF6APeWKxv+IqUC5cXLWLJEQ+2tbRUFYqYAXCay7XwtXfKy0jyuC0xHIfnGDfF1gnMfhT5tNJBZilzI/tSIwCcq6xJ15eZE2Lm2QR+AUIpwEVmBYyhIgOrJxCiI/rUQFr20vZ0WDs7mulGJ7JmlJmUPVceMvU9W4O3oDQBGHu1LGw+VoSZfzZKIcuIuV1QSVv8Zg/le25izU5dswrq0CtwESMT1ZEJ3ziCtp5zDu5eblTUS5hS9AW/BFtPPDQ9OHhc+a7wf+t/01TeHEH4bY5Vt/YkMwJo9O7sZaj1hIqHVdKdWiDYspC4uBkCt/XjaQeldbprT2y/AYik1NJpVJLuZ3FNfTnmT9+Llq50lgSOwiDMuB47229eyDquilp5aFwwhgiGgF6z/npgRL78oGnOzOu7IV4AazcydBsQVmBG71BB3sLLPXGcjQKxT4Cs0hfmOZOHDiRCSmvrXwhM
 WfvM8+Vp
 zq8IEB9rwaEbgWEUJmBnAVNsIAjFHk7kb8l6BGE+up1Pe0uZRwjd4yW4z6Us1WeM+lyetx6sndNP2KpkX+AyB9bNZ5DZe6JGGSEn7lj683qVraaKfwp8OpEjSuMejQHBUlB5+hi7ej3D8aeIdsXWAzqRQDnHErv2i0OcbWsKw36ZrQ69+weVnLMBHglCR/5fKJwJhkxAubYpYKhzZapz0v8F/zCj9E+S4eS/ZjAvZmjjB36/BWr80UOB5smBvxTXYwP0h14Hf1pEJ8J93uI73qHPQiykmXPGzK1FdxzQkS50j6WtZSSqwtNsdzRUhE0Gr0MLKvf+6W9C6rb3AchiGJr5TlA7HkTs8ABoJNGrjZ7mtUBpLKEWpiT35C7H+CRRVQ6o2A4zrp/sDe8Gd+WYhP7NoBQptmi5aU+rewr6b90yq2uzbY/2ks9OEZeM7qPzw9Sgo1e+W3u1CV/r44ogw5/cAMXY9xvzlp6jG565zkdSE4k2hY32fLjqX5JPu/CESRUpkTOFYpZq0Z7h0deJMe1sYOg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3 Sep 2026, at 5:22, Christos Skarlos wrote:

> Resolve coding style issues flagged by checkpatch.pl Specifically:
> - Add missing blank lines after variable declarations.
> - Remove unnecessary braces {} for a single statement block.
>
> No functional changes are introduced.
>
> Signed-off-by: Christos Skarlos <christosskarlos.kernel@gmail.com>
> ---
>  mm/huge_memory.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
>
Reviewed-by: Zi Yan <ziy@nvidia.com>

Best Regards,
Yan, Zi

