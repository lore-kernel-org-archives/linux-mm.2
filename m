Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CD599C53219
	for <linux-mm@archiver.kernel.org>; Wed, 29 Jul 2026 04:50:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C7F8A6B0088; Wed, 29 Jul 2026 00:50:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C30126B008A; Wed, 29 Jul 2026 00:50:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B1EAE6B0093; Wed, 29 Jul 2026 00:50:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8C2216B0088
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 00:50:54 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 2501640523
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 04:50:54 +0000 (UTC)
X-FDA: 85040589228.04.C0C9570
Received: from SEYPR02CU001.outbound.protection.outlook.com (mail-koreacentralazon11013028.outbound.protection.outlook.com [40.107.44.28])
	by imf15.hostedemail.com (Postfix) with ESMTP id 02DE1A0009
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 04:50:50 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=vivo.com header.s=selector2 header.b=jcoPe42S;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf15.hostedemail.com: domain of xueyuan.chen@vivo.com designates 40.107.44.28 as permitted sender) smtp.mailfrom=xueyuan.chen@vivo.com;
	dmarc=pass (policy=quarantine) header.from=vivo.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785300651;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=Ktn1G2j1Le5/QkheOaFEO8/opN2sPXTAQHOVmb3v9c0=;
	b=xWtXJpnNolIJH1PFjnbYZqmvrJkryXD7OwUg72s7PjwVmbJhA3vycldgMJ0y/y0qjM9wtR
	N+TllCwcWL6ig+1OWZeIljpZNZOCIGwUjntpPrbi8MQ6hMiULkT7Nul9udnEZN5+uZNWUI
	TJfyAtJTgNB8LJkPxqZfeOplRUEUY/I=
ARC-Authentication-Results: i=2;
	imf15.hostedemail.com;
	dkim=pass header.d=vivo.com header.s=selector2 header.b=jcoPe42S;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf15.hostedemail.com: domain of xueyuan.chen@vivo.com designates 40.107.44.28 as permitted sender) smtp.mailfrom=xueyuan.chen@vivo.com;
	dmarc=pass (policy=quarantine) header.from=vivo.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1785300651;
	b=MY1WOUkujgBppv5/yQnISNylGPVVmM8M4zg0gC6qtNQBTkqlhqszJWeWhEojZUyf1LIBO2
	NcS483MANzOESBfLgUQraJfMqRmekW94miQIsQI/lfPbIT01hzzb9iCfZarMcV4qwbtA6V
	U8HDUUcRnBA90gk3w/xFQp07urPnah8=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=RI8IETU9zFZ9UYi7P7D4MgpQLIBCgNvaHPEJDt4skDw96/Uk8Wodo734tzI6VaV4Fblwj9Xhjv8eERZTx6UYGLKLed9hvLJsgxDmlpSL3eWnFqIHGPHN2nC1gwVewdAUEQl9XLVZdJWLf4Yf5CNCs6YXnJlyTD9fxXXMsjSAkmwas3eG47wctZ8kIo4m5siy6x1cxKauHy8tOIPAmv65J3CMSGm5AwY58Um81ZEg0dxOpsUVcSsoku7oQ6RxbhWNL4XAzbTWrobfJUP5+/AETq+tqFmQUgSoq0c+L1xmPIeXTODwCerYxlH4XILve3CdBO/x6AOPCx+LACVgeYUUlQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ktn1G2j1Le5/QkheOaFEO8/opN2sPXTAQHOVmb3v9c0=;
 b=ASIaT1SXbammJZW0RuEwOZGs3hGheFp/UDZNTsx1gMxgQW2vNhxJyM+OKknpgbhFY2ZJ0dq/Ebwg5/H73FVhshsoFGfx4AdrNGVUNfPtu7bBUoG0tcDAQT8WAmxHYWhZKpE3OwFr0SWa6S1k6T1rgd5AK3h+yKpT9aDnazNPrIvx4BpvVQCzkbatL1ZiDuQB69AApIWGzCBt09LHLXVJH1sPl4WF0TVEJ7pWUHBkSxXOFzwc/9MipKuX+2eCEyomeUjguj6t3c5DhQMPt7mt+HgK3uZHuVe8Q0bpr5tDTywqICq4RIghRVjBejQLPSLMOICEbTsy8zc+IDXhi5vK9g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vivo.com; dmarc=pass action=none header.from=vivo.com;
 dkim=pass header.d=vivo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vivo.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ktn1G2j1Le5/QkheOaFEO8/opN2sPXTAQHOVmb3v9c0=;
 b=jcoPe42SyoGMlKfdq4v6CC49vJ2gfA1oaH6H6378WPuqn48A39/5uEq6VpUjROtlcdfOcRKPrrH/+iK8N37+2/TuOO1+WwNg6c+yUolh9NTRMsOzCNeIsVaGBly1AjdBhnmg82NLUWfMYz1emFRo8JG8w0kd8zAo8PklYGicVKtLPHvQ8JWpv1o8Y+2UAEzPeoEJy2qYXNI46cDYMT0oBxif/uXOoe1fOB0qKY3MaOji284LxdlylnOmIRD9srYgSV8UT6+pcZzCuv65gSAFX78R6R3o1er7aHBj0AUq9mzsOZWsaOvcexNfMtyeUHr7p7b4x8I8QIh4Iw73yDRmzQ==
Received: from TYPPR06MB8235.apcprd06.prod.outlook.com (2603:1096:405:383::20)
 by SEZPR06MB6301.apcprd06.prod.outlook.com (2603:1096:101:10e::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.270.12; Wed, 29 Jul
 2026 04:50:41 +0000
Received: from TYPPR06MB8235.apcprd06.prod.outlook.com
 ([fe80::6ef9:8fa6:5ebd:96]) by TYPPR06MB8235.apcprd06.prod.outlook.com
 ([fe80::6ef9:8fa6:5ebd:96%5]) with mapi id 15.21.0270.009; Wed, 29 Jul 2026
 04:50:41 +0000
From: xueyuan.chen@vivo.com
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	linux-mm@kvack.org
Cc: Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R. Howlett" <liam@infradead.org>,
	Nico Pache <npache@redhat.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	Usama Arif <usama.arif@linux.dev>,
	Kiryl Shutsemau <kas@kernel.org>,
	Bob Liu <lliubbo@gmail.com>,
	linux-kernel@vger.kernel.org,
	Xueyuan Chen <xueyuan.chen21@gmail.com>
Subject: [PATCH] mm/huge_memory: fix huge zero folio publication race
Date: Wed, 29 Jul 2026 12:50:18 +0800
Message-ID: <4ee89c27873fb4d9e598f8a5cfe71d700ecf894e.1785300563.git.xueyuan.chen@vivo.com>
X-Mailer: git-send-email 2.47.3
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SE2P216CA0151.KORP216.PROD.OUTLOOK.COM
 (2603:1096:101:2c1::10) To TYPPR06MB8235.apcprd06.prod.outlook.com
 (2603:1096:405:383::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: TYPPR06MB8235:EE_|SEZPR06MB6301:EE_
X-MS-Office365-Filtering-Correlation-Id: 6b858af0-0961-4c86-8503-08deed2cf145
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|7416014|376014|23010399003|366016|56012099006|11063799006|10067099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	+oBuY/aXqE0O93gKWPkJeRSMFAUFFGtbNzCyyxoji1Ug4iL8G44KXndU6p2dHPdoykMuCH/tVXTVy95ofDv+mjdI67GeqVllGSEU4IF7C3dnP0VhmMWLPfY1C60Z62+I/zmPSrIIEEqWJpGBNu1D01l/qjKGJQR5FKb7XHTGLoiqZjo9qcLwlqYZn58Id4K65YqAmxJgkiCLiBrnNmPTuT7eg3sdF1EYt6CZYAbQQyF28NoaQNqfcVkuefReq4n+K0MSU5cv+WM5fAizOXBaMVzjQhwTkMKVDvbYjW1RX93YBrFShQQCZgQxqCmo4ljnLiiuUPBBBpu8JwLkaD7wh49cj2w8cTc7w836B2gPvneB+D+9l8HGnitjATXpDMOnyRDoZJVwUmATSXGkpu6NzkPrLI9gfAj57DkirLmzQtwqlkN9WKSZCDskPqWvkBcB5edkDpvLaclj9qHELpFAR18VmCUIMU6z1FcYLtQF+X2aA9b3lnNu8s9cMHV1eyhVmUYSD0xOQKH2ohg6d5zemwGIczs2kNGmOS7lbGTwPGhvvv+gOxQWL0p7dkQ2ZAeb+3AlLaktDsx9dzMlOKr5h/sRc8tvpir4MwZb9qVRAjdrB8DBi5nhH/LErqK7G6kdBEpvfzIlJpPGq5RXLYYxSgvp56YY7o1CEBl7W85Vu0U=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:TYPPR06MB8235.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(23010399003)(366016)(56012099006)(11063799006)(10067099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?04rZR8zSJ/K2msSdCkY2vh4pQYLEpDD+gBCWQb/FInaovekSwLu8CIbcdHN4?=
 =?us-ascii?Q?B9gH/ep8ttb/vUHEKIa9f9XWxXUYW6YJ7a66cKvLLD1j17L2XOL/vzUBj8ba?=
 =?us-ascii?Q?3KZ1xP9kdvsCLoD88rp9xYgK7IWde0n++NQ2XQUP2IYBwvJ/9B7JYUFZVjek?=
 =?us-ascii?Q?dfL0o2M9DVjbm1tAe2giY3Qpk+VG93VFzPV8zWTXZTgQAb4syyZi2sOIQlrZ?=
 =?us-ascii?Q?kqH4OdQVBSeLwn/ZUgM+Febi4nDuWMHEjMAFHMZZgagP+RrLTTaj+GAOISp1?=
 =?us-ascii?Q?z4RZ4ULDdzCJc++oYVfNu52CWh1pWalfkY8TgMGC07lRFh7KJL1WelQrYrR5?=
 =?us-ascii?Q?9tsrrkT6R5HWgjXX4S4SHX2NDUvMsBIPcCJ9A5nblboKgWqa/DQLN5or1pwy?=
 =?us-ascii?Q?/el52i336WSiwE/dhpulLb9OXUJl/oH7OZ+Y7bGQreR1kUPcE8ppSdhjcMuT?=
 =?us-ascii?Q?Fi3h4/4VFvFB3x9foX1l151rWz72T9Gr5wC2d8Y4tEXidjP5vOi6AGnsytAj?=
 =?us-ascii?Q?aOW8SrsKHIZqTRc/6wqEU6EfDcr6awsX4EFYyZMlrqePWU4qeedRiidfRGWD?=
 =?us-ascii?Q?n/LPkDTgXHg8jfLjAMfAUbtz9hYgU42INqTr/TadE1/NJRowh0o/oQ0QGWAC?=
 =?us-ascii?Q?yUtk4YU1IYQQ8pTigQNNA+tq3ogNqqLXAv+XWn7TlVIEd+diY+/zfIT9CRRF?=
 =?us-ascii?Q?vhe4XpKJhhA4RcZMf/54HSdXXxDRtJ2mzhIZxftkFZ3lUCKN+vk5ZH96qyx7?=
 =?us-ascii?Q?VCVbdU1h8EFYlNR1XWEiL+VWJNRIMcu0hBVGwxwUGDemoKXqmwStGo/57DTj?=
 =?us-ascii?Q?wsivtc15DB6buN0V713Z8TAEK2IS2zH+a+1vm+vejaIXuRVXnYHqG+/kgYYf?=
 =?us-ascii?Q?5QFnuBPv08LYcs6kzKaZP0KOS6l7YEnKdDG8IlwttMpd8rJMZdannkh/re/1?=
 =?us-ascii?Q?YeflqDq1F2jHOmHDSSU2esS8HGpFBtsPe9a0TRynXMk8rCg1CCDP/g8QCM78?=
 =?us-ascii?Q?dFXzj5CaCg9AAkfrtmnOscQdQ09yNoH9MjZU2OaMkPxT1HIxO/uqwC4D0RDz?=
 =?us-ascii?Q?Lru1kR1IfP6g1ZztCiF1F3bMEdNn9v8HegU9nEvWy2P9SDOXV0NsQCeICBQg?=
 =?us-ascii?Q?Y/zlIU/+qd8coAeGtv3wvdTMQ5y3ShdTZ4MJ3xHK+f9YNNlIO8uuD5hjJst4?=
 =?us-ascii?Q?8RMTER+Kb3jopFSf46++WfYMoXFYaXGY0zvZdA5a9Dew4QMDNC72NfUcQ5S/?=
 =?us-ascii?Q?+pCYDYEXJzR+MEBM/paVTxikycMTao+qo7jy/xWJUxQiEF0U8vAg4YJCotth?=
 =?us-ascii?Q?bAGiEN/e5g2CrrCCOGsjlYb7azgt6AVtyUnSosZIYLDc73XrG1isNXhxpqLV?=
 =?us-ascii?Q?NMcd9i5ereXjAKwGHwOumiLVplnY4QZBGNgdyQqOFreKHDxt4lBsE5nOVAdq?=
 =?us-ascii?Q?hNzj52RiBFf60hzs1IqsFMqPIMdBIS0efLtRyvp4Y03lGmUYBlWZwwNuCRhb?=
 =?us-ascii?Q?Q1TmsNRmXZsW7u4d9Brg4G7waCUgDyHcHUPMxxSeU9QG3i1e+c8+cRue2D4k?=
 =?us-ascii?Q?X3AoQgflllRwUF/PzXRQHbhcSJulNScyIZwHvBAmb54YPflTYDn3Mt4xjOof?=
 =?us-ascii?Q?rYrf2pJT10hWEcH6FSCrs4tYV+jyCrAMetk8g6vMQYpNxS8JXrLdOHxB7N2R?=
 =?us-ascii?Q?PMRxB/EX1tnxSp8WZOWqV3SY1H3zbSmej6HMH8basKGhauU6L0a1hhcjmX30?=
 =?us-ascii?Q?91IaWyyU1A=3D=3D?=
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6b858af0-0961-4c86-8503-08deed2cf145
X-MS-Exchange-CrossTenant-AuthSource: TYPPR06MB8235.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jul 2026 04:50:41.6112
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bcRR+Z7HoKMxzSJ3lmNww/3/CD63mxdtW5M9VbRXYDX071DNcsIRK+Isfm9GcxZ4NWGq4IjE08PgIhPmgw8fww==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SEZPR06MB6301
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 02DE1A0009
X-Stat-Signature: z4716hs9b9jwynprcr1kyrfnmrskrrj8
X-HE-Tag: 1785300650-252784
X-HE-Meta: U2FsdGVkX1+Gk0wfYZyIcF6z0Yp1UXKbcf+k61PJXevm04A82FGkD+WwbTNei+GXI5jSw+w4ZgneMf0NVU1o6AYs+13qZeGXJDKNbQFE9uQ5irD9Qr1xGkR5dTJEq6CTkV86FsmBjKUuf4PGgwOVbMVDw9wB5saxGb1yMDsGvWkhrUamPo4ug5iA8PSbudyWa7MaCY362ehjjB//1NzJDv/W3lhmEywbnQdG6G5GbXY2950xSi+fFl0M/AldRnk0/H71+kFGmQ4OOsnP9yWco3fyKDg+gl3nrD8O7D9iRIbVUNZcAS5hRziKuT/vtcJACe8vJE4ZymH2zW4TvsQtAxcCZwrXNADoQIWcVdmHNtWciCONJKeMw6rusvPY+Wtt9ico6Yi7ozYQm1XPtIWmByOW9fm4tzSrV4pG3+8bm1Tp6q/6nhLhTupl/CXmnoUEtZiRr51SNLA5u4aqs/m1kz1YxH4ufAxzhyzKNaeGgOB7k3gEBdWWvl/NimGxiq/BvFZOqxowEqhLbj1yaVGRa4KahS8Ff/N/wvUzGP1R2PthzhKD6ZyGiCcxGD1Ph+iGdO0pJhz0NPGQhQcf1lujr8g/F+3nZkp56txSGC/gAFR6sP3obUVoABC/gm6i2DmpOmIrrh6NLWSmaLHIXzFV9MK7m45yyu3HWhUhdie+etQhr8a8JV1CS+shleLm4Z+lLb/tUb6CkCIjqDqiPujQ1uhwpxcAAfaVMJQGR8fvRAxak6EgEnBK2dTTX814vEn3/ogXprzRJLJ2HDUeIKGi9j84gJVXrNbXwW7BqjsvHxYtAySMGlY6UcG7/I1B1/yIrWr2vpv3P/H/RHLkiiJHM/aybaV1JmldThrEwXlAxd3nA5zRpLgQLyidLhj2uVVfCvEFtije3T00Kr7YnkOJPWcPqxhtoakThnmmJJrrBsF+CH4J2PKiXQOzo9o9k98jY6vWbi4oDzx0ZUvcoch
 OMK7Rb9f
 klPQkYCZXInOXAVYsTGmSvpJnu6CXnvyvdNZ2kLpV3DcYWa9WuuyI9i6U4wMfDWt59cTZiF9+29/kr5sbelcl7e2zWtMtJh7ggQ64l5j1Pls8/SWgz/yvqMjpzGk14OWiWkH1tNQMrhCRUHb9LnNMXqzPy0wsaTucHvmRaeB9+vHYupsD0egb6MG+vLd0bp286uDuY43a7DC6KtqWJ7y3hkH2h6ZkRzqje4xx9HiwhWFMjOPrOE3OjFs8AeF1Ujj/3XS2y/6EaBJfqN6mBHoWJMt7xNdQDsP0ETE6E8FryewyK4rWaSoNBZOA7QK58+ffK3rEsINlU3x+Qo8HHwb96NvWHX7Tt2rOcyTcMNC7ycrt7t39VpR26lSaOkFgsti9qNCMQgDTY8aMnb0RMOKFDq0i6qt+tbD23pIa6yOXiZ+TyuBZzqwi11XqP9/766cPTreyXiniR/xSui7t7c80jcPTgkFFgg1BFJaTzUPQAt+EfcX/WBza5rLUAdVvCjQU3JC8nX9x2C74h7zzLtu+PK0vyA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Xueyuan Chen <xueyuan.chen@vivo.com>

get_huge_zero_folio() uses huge_zero_refcount as the publication gate for
lockless users. However, it publishes huge_zero_folio with cmpxchg()
before storing huge_zero_pfn and initializes the refcount with an unordered
atomic_set().

On weakly ordered systems, a racing atomic_inc_not_zero() can observe the
nonzero refcount without observing the huge_zero_pfn store.
is_huge_zero_pmd() can then misidentify a huge zero PMD as a regular
anonymous THP. The write-protect fault path may consequently mark the
global huge zero folio anonymous, exclusive and writable.

Use atomic_set_release() to publish the initialized folio and PFN. A
successful atomic_inc_not_zero() is fully ordered, so a reader that obtains
a reference also observes the state published before the refcount became
nonzero.

Fixes: 97ae17497e99 ("thp: implement refcounting for huge zero page")
Cc: stable@vger.kernel.org
Signed-off-by: Xueyuan Chen <xueyuan.chen@vivo.com>
---
 mm/huge_memory.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 032702a4637b..6c74d0375377 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -245,8 +245,11 @@ static bool get_huge_zero_folio(void)
 	}
 	WRITE_ONCE(huge_zero_pfn, folio_pfn(zero_folio));
 
-	/* We take additional reference here. It will be put back by shrinker */
-	atomic_set(&huge_zero_refcount, 2);
+	/*
+	 * Publish the folio and PFN before making them available to lockless
+	 * users. Pairs with a successful atomic_inc_not_zero() above.
+	 */
+	atomic_set_release(&huge_zero_refcount, 2);
 	preempt_enable();
 	count_vm_event(THP_ZERO_PAGE_ALLOC);
 	return true;
-- 
2.47.3



