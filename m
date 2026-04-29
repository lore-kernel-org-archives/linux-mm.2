Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 55EA2CD13D2
	for <linux-mm@archiver.kernel.org>; Wed, 29 Apr 2026 17:09:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4E9CC6B008A; Wed, 29 Apr 2026 13:09:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 473A16B0092; Wed, 29 Apr 2026 13:09:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2F1846B008A; Wed, 29 Apr 2026 13:09:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 11DA76B008A
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 13:09:16 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id C0D3AA036C
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 17:09:15 +0000 (UTC)
X-FDA: 84712229070.05.35465A6
Received: from PH0PR06CU001.outbound.protection.outlook.com (mail-westus3azon11021092.outbound.protection.outlook.com [40.107.208.92])
	by imf13.hostedemail.com (Postfix) with ESMTP id 9DB3D20009
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 17:09:12 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=os.amperecomputing.com header.s=selector2 header.b=TikVcGly;
	spf=pass (imf13.hostedemail.com: domain of yang@os.amperecomputing.com designates 40.107.208.92 as permitted sender) smtp.mailfrom=yang@os.amperecomputing.com;
	dmarc=pass (policy=quarantine) header.from=amperecomputing.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777482552;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=llOt8myS0tVUljaZQijMKsneO7ZccgsFHtUA/Ox/uU4=;
	b=spEJXJNH/IITIh2Ho49Ns7y0wvcLbAI0qlaWIz60FGuGKeBropm8/Sm6ijUWt562+M7YJe
	uANHgkSDRAiIwncnPnyqwBRN1jqQMvM0f8OPQya8pxLktTzd668JYt/Nz8xiu4pSlSk9AT
	sVa+S5vK+Dljf4XQgZz5iTwCGBW9DYY=
ARC-Authentication-Results: i=2;
	imf13.hostedemail.com;
	dkim=pass header.d=os.amperecomputing.com header.s=selector2 header.b=TikVcGly;
	spf=pass (imf13.hostedemail.com: domain of yang@os.amperecomputing.com designates 40.107.208.92 as permitted sender) smtp.mailfrom=yang@os.amperecomputing.com;
	dmarc=pass (policy=quarantine) header.from=amperecomputing.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1777482552; a=rsa-sha256;
	cv=pass;
	b=Llv2JJxogCpjPLeSu6FVg8MGLC8iJHGJtIJXVhRot7cWuJd5KSxjRTf3g837Jv49HJDOKr
	wB7wV0Mxah1DSuasAGlTklEnCuYBEXs5j1GMBZoRydGRfE6h8psSE1rKPcFnbEnYhZZ6es
	FuLCccbOAILl8+Nb0T964iLSyCLuKOI=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=XLDowJcavj6La5m0eCvUUklchtVrq7I5IM4iuzZ5viRXb6FrJ24kqebjGRFTH91VvDTLPNsSh3YhN5DvQM/QykDIaGIPOSp49il9uJM2zYabWaDCFO5gsho9/LhYuIiA5fHDK7ZN0MG+DRXq+gmy7uHpFMr+mMxw2pu2tdZrIkjUWmjvkNw2G5K6XIDkV/Bbm1RzIfA8fcBIDl5djCYs7c+WbEi3SZbTz2i5dOaZz0Fy7b4DtFRG/cmw1j8SmBRVhTVo6L/VqdmcQwQQr0YAlwM47CFcX44+mupaXua9b0Dh1vz2jrMLNjpKWqqhOX9+cgVn77MConLzaluRq44C0Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=llOt8myS0tVUljaZQijMKsneO7ZccgsFHtUA/Ox/uU4=;
 b=Sn7v4TCiKuLxFqQHXKyMtkXODrLA8CbfDsjhcVLulDtO1zC6b6xAsbSVkxSg4ICjeIUwnaPs4bKiq9nxx3jzVDRqrcWIIm54dP53VjHxNCdB1atrzI5ifcFhPVXqpgnVXsUa25nL+9HEVpuzMx7yXKGdTsF0RTb8qeo9qrB3yjybAQhqL/riUBElkYniwTaccGRLkH0KNkFJ4oqIhY3peimbhwAPwX9m5DZUiHb5iYjhjEp15CpOb9zejzuzp6g1nGmsNDLLc9BjAM4t1c/0IDVhKL9qfcZkVs5USER4Mpcxl4QYaR8j/CZnCLShDxt5Sws+DxWENJqFtkBLpEB00A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=os.amperecomputing.com; dmarc=pass action=none
 header.from=os.amperecomputing.com; dkim=pass
 header.d=os.amperecomputing.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=os.amperecomputing.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=llOt8myS0tVUljaZQijMKsneO7ZccgsFHtUA/Ox/uU4=;
 b=TikVcGlyAYFhG+goqEXAWCdhR3Bl1vyfBN6LE4psUJqGQBqrkM1JuXyAKjb+Mu+EsZBFY/gK12h57QuosXW8r5fqjfzj9bUNVtQM4RfItrcFvFo4PPwLNlQhC0eWgh2+tYkBaWBDdpZ4i6R6xwTlqA1PCYsaE0bPQ+SsOgf1bVU=
Received: from CH0PR01MB6873.prod.exchangelabs.com (2603:10b6:610:112::22) by
 SA1PR01MB6671.prod.exchangelabs.com (2603:10b6:806:18b::10) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9846.26; Wed, 29 Apr 2026 17:08:57 +0000
Received: from CH0PR01MB6873.prod.exchangelabs.com
 ([fe80::46eb:64a3:667c:c1a0]) by CH0PR01MB6873.prod.exchangelabs.com
 ([fe80::46eb:64a3:667c:c1a0%4]) with mapi id 15.20.9870.020; Wed, 29 Apr 2026
 17:08:57 +0000
From: Yang Shi <yang@os.amperecomputing.com>
To: cl@gentwo.org,
	dennis@kernel.org,
	tj@kernel.org,
	urezki@gmail.com,
	catalin.marinas@arm.com,
	will@kernel.org,
	ryan.roberts@arm.com,
	david@kernel.org,
	akpm@linux-foundation.org,
	hca@linux.ibm.com,
	gor@linux.ibm.com,
	agordeev@linux.ibm.com
Cc: yang@os.amperecomputing.com,
	linux-mm@kvack.org,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 03/11] arm64: smp: define setup_per_cpu_areas()
Date: Wed, 29 Apr 2026 10:04:31 -0700
Message-ID: <20260429170758.3018959-4-yang@os.amperecomputing.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260429170758.3018959-1-yang@os.amperecomputing.com>
References: <20260429170758.3018959-1-yang@os.amperecomputing.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SA0PR13CA0008.namprd13.prod.outlook.com
 (2603:10b6:806:130::13) To CH0PR01MB6873.prod.exchangelabs.com
 (2603:10b6:610:112::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR01MB6873:EE_|SA1PR01MB6671:EE_
X-MS-Office365-Filtering-Correlation-Id: 0ffee449-9840-4092-3ac9-08dea611ffb7
X-MS-Exchange-AtpMessageProperties: SA
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|7416014|366016|18002099003|56012099003|22082099003|55112099003|921020;
X-Microsoft-Antispam-Message-Info:
	5+7eRN0r4eDMqkaqSnOU3LgQKOlMWxyCv20DxgklCCF9PqqaOv+agKNKS1nkudHvss1BISm4JYM5gCjDVuiYGFvbdaERK3ylnD93UcuzTrOXohHDtT8nH9n3BZOIPdYifhiCuK40B6e9Nwb2D7sZGU2zUHQqCHar78dMo6IGrtyYkw4Zg42aUCGGJV5viqTYWUwnTjRYAHR1FTK1yjkT8EhuGjJsjUOTjdnLQUe+NWCglvKvRvUhDr618npvsVXBaEjfjtg8mAtmKg3iz/YWlcRrVmZNbaZ7qY2XKiM/LCAgbMEbPXy1RAgyd4aGqCfq4YkJodgzfYKJ08Hjamax54nNfuHr/k3T9L9aGSnBmkEx9/CDG02t1evNkXJQQ31ebsrvRrr0RAGieH1JkCU6sMHLryb1ofbE3LGzwRsTr6LWG7CUdiCuqXy6/QEE4swWd3XOTG1GsGub4DakQYtWmNxcqePMdJreat/5Haa9SQk+ovl1ub4eOueESsoJaICfk9cC4Nc0zOnMPpdh0JHKKkNGBU5r9ojEK1TwKM7anAzfx2dxQRFqwOEVt5Z522aLTTtWsfRngf89AFRtyJlPXuABj/PaBRkSE0D/krOcSH0pS8buxQ4iZzuD4P8Pd47NdRIGybfRaPYSVPAobczthngPHirPuFYywx4WE04iLiWPjhFFVd4wAP1mjT6tX/gszMzTUCJDr9uPbEARdEUAkC87O8CFuvxsYCTdh6qIznQYnwKKsAs/HIRYj9R9EL0JVT/1t28yVIKuqrtvjMMrVA==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR01MB6873.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016)(18002099003)(56012099003)(22082099003)(55112099003)(921020);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?f5Bf+y9j+M9/o4NoxQlec2r1/fxhUmWWK0cPyn4M/sWafdk9sKjJD6lW1vpw?=
 =?us-ascii?Q?joWKiuINOkPS3n/wB+nrItBaB7UtAEQiPzdgtnLk+x/dEyppUHobaD2ziWwV?=
 =?us-ascii?Q?PQ7Rk2rBaRXLRgX4IWhLJBKafYaf07K5qytRBlC1MMKjALKOozH/Hu8gz5qW?=
 =?us-ascii?Q?ZGezwYWi9t4hYEw+3w8lBHSwxgm21A0t5kd0X/ohOp14rRNGlr388xhA3PZa?=
 =?us-ascii?Q?pIPblRgSOSg48pz6GilFWtSo7KUqB/V6pwBW/x66Tbu+ZG5b7wAXBmYHd9SO?=
 =?us-ascii?Q?+crGtGRYTXchN8G/3WfuMb2/ISB5LhC3ogXpvpwSK2jVs3HeOESOxOZLMN6H?=
 =?us-ascii?Q?o8A9+COBmgOaxqBo251ltxKuVH0GYdwe6JuewLlCupIfDmnmY2Ej7CdaQ6wT?=
 =?us-ascii?Q?Xn2Xzc0h/ITX8Nx6T++hnd/dYJOY/Wr4Vf9FW5YjLY7byOIoiQJYKREdAhpF?=
 =?us-ascii?Q?o07Nafe+eac0kX8VCxWgE9a1laSUC0YgRbuwy1ajR0y8LI8VJqZzvncTCGNR?=
 =?us-ascii?Q?hfysAzaREuoa7630F7fevn3QGbbUO9AxyCALZreL3Jv3vp1at9uLFHqhXd1u?=
 =?us-ascii?Q?3KhZ7ijje9JGF5h5kiiUw7ivEJc8C2BgTwtgEFgXU4vQzWIYg6dD3nTWOGBl?=
 =?us-ascii?Q?/jwbft7KHDqY1DaWD4d28ibT8bthdAQRTpPo+IdIRh9XOtreIW+O7Hv4dE41?=
 =?us-ascii?Q?10a/pBhnTo6Fle6YATJqbelFiERk9L62VuOn6mkXfwdQyU/Bx3Pv2Z0cbkAt?=
 =?us-ascii?Q?s1YluFSuEvFg/Umz0XXcctUE34wEqdelxg2yifIXn//Um82vi+ifI2uEbWgs?=
 =?us-ascii?Q?4vv9g+wfb30ieIX6U93meVvIapgQjQkLm0s4YjcH8QE3NJsmaFcnBfn+1RnU?=
 =?us-ascii?Q?rahhobGpW3OdOU+v248tOqHA5GfXyUNUQjJi8REugSqqmmDjdvgVISHMk9DR?=
 =?us-ascii?Q?rE4m9OamnyZVG5E0daVaBKqEZROOuhcJyDUA2VfFUY+uq9+BKXCESegkknJm?=
 =?us-ascii?Q?DT5Yc+CwkspDadFUA+5vdHo1EcJNEdP4Vc1gjiTP05Z0lPa/ZK93wnP4rlts?=
 =?us-ascii?Q?vamFx7jMBRgtq1eyVU5edDu5N9E+g+VmMrnOKEMhrNL5bL/3wBwsq7QULAyt?=
 =?us-ascii?Q?xKNy2hOZui058yZ/9HMcn6ixnp8Fuq84JxSexXOaUN2TrPK3rG0fl47v4XIU?=
 =?us-ascii?Q?E81oXz23XwNeqfuf0Bl2gw3v3gi1iukHAmAAkOs3bt2+wiFf7fGP4dF98CZs?=
 =?us-ascii?Q?XA6ZkE/7uWcA96TQrmiVYZ6zxeX97tBXPXgJ7XQ6S3OE4tG1aluTadqYWOQj?=
 =?us-ascii?Q?9pxejxeU0fFZj7jutH8MInlB5RmHoJFJ8l0f5lT5atS4dmDyWBcTnQWRiPc2?=
 =?us-ascii?Q?KEYIzBjeEsSXYkh3g52uG42D7c8it9oTUSXGCFeylHOvajCwItmjGPYA9mwK?=
 =?us-ascii?Q?IHpDdIx7Yq576jzwlHqVWt0j+P1Z6oiZLhu4GDDsBHX+9CqK0kRcbK4S7L3X?=
 =?us-ascii?Q?y8WNX6lHF5CfM1Io/z1FH7OCbrAu0XEwrdrBZCG4PgUcOUOkznCuh5n4Y1pM?=
 =?us-ascii?Q?XA3vkKUv5Naa/7XZG9inIM+HqUF0RVUEn3wnn/ashPPP57zS/CQtnsuKBMlI?=
 =?us-ascii?Q?7cFjobYpJgraEShaEAwQ8AtI5B6BaeDdoPfE2TN/J2jL4C2LoVZmz8xKBeIV?=
 =?us-ascii?Q?/5SkGjvMQdNakLH//rxxr9KwOu3nSw/WQfJRXTtcHdvrcQgG8iiMBRgmh4AZ?=
 =?us-ascii?Q?J0jVA/yJGxQZWUd6DtBrnsya/lORLmg=3D?=
X-OriginatorOrg: os.amperecomputing.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0ffee449-9840-4092-3ac9-08dea611ffb7
X-MS-Exchange-CrossTenant-AuthSource: CH0PR01MB6873.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Apr 2026 17:08:56.9983
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3bc2b170-fd94-476d-b0ce-4229bdc904a7
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 94EIXaMcCNVVJX9vXxMBfKORZDfl60eJaudOcqnphwG8H991kHyG9bDSmkq8R7ySmf01Bez+dRfo2MLWvntPL3bZWL7Vy0FJJT0msKCjfT8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR01MB6671
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 9DB3D20009
X-Stat-Signature: euuc74eh6146yrfj74fttmbfmiwk79jt
X-HE-Tag: 1777482552-410194
X-HE-Meta: U2FsdGVkX18Rha/ljuFnNXFeFa5ShtjTAT+4qsdW5zeFKy15nZn/9vqNq3uBRwFudlcHLfR+m3B2Wx58j4AvUXG5vlOW0uMbMGtn6AwHBoUiy1GCfXYNYneRpZw5s4VtMCqwGDc83B3q2aOaIrLFB7tkS+YF+//rgpdYHZGQAEuItjj+LilGGwUVrRhctz+1aKNneFosy6kBzRI6VkaNVrGhhB2N6wkAgTWU9FdfLeko9LFhy9env/hvI8Syq2xQPFu/swFChJqO3qk5D60FGmPbkjySDocV5p6QaxmxeO2102iUBQWfci3c4WEOHLTKKqXLORcCJTki6K8YbN2xSUexHzQXGKJqGy6fsy+8apevjJfkvBMo59SorsNOswvwslUkL3S61e/YxAEMrTrASRHctupBPNksL7T3AKYROjNHsjofivpRwgk2VWkoiLuMBDRmkYTHoOrII6AB15uSuBNATkQSIzwrmeMvSH2fujrkiIdL0hwol3pO84tZYJZ8POLQ6MMxdM481r/XuNj0oL0tkRaenDamF0EotOF84+iFbeNdlIethjLOC+dZsknjq5Cwd2u/dxqnaw0xklhuEYqGBLXs4Wzwah6OV0pQAkB4RW5dtZMWNaPVp5JxbupU2lcgP/llJLtYjIf/z2oQvUKIFETtWTfkALR7zsPWCjZa2w0Oh6qCHznwOdYt6UafVvLINx2qVHTU9uZf07Uib83UNUX6gBlbqZCdYLP14bBURo+eMvCPbmW5Y0EffrxCOaRDbQZwFf38voRnHvt23+en2d2gO99iYdqJPJI8qsUA95gvAnwWLclMUUhA/Pl75/T/5Q/CqIVO0ZzP+z5ZxledVl8E9muOs8XOax5TnXQGRkGYCs8fVgqHN4Y8fEcrKBE6b7WD1WeJnQpCz1F+ZGrIanAVP1jWX0Iwa4GDiLWsdUikpGT+J1R3/Sj5yTa1nmmF0k42RUHjPCJ9V2S
 /o8tsMor
 M5ju8XOCOFkkiwFE+WbR6PTveo9LESYnHIc0K6MZh0fwNVxyN3K+l0sHrABQuq+z6OJSXvcun1yFxkKFrECJeaSxsBhhq6EKlBFE1IcUExnJAwq/duUTiKJOHprUDq2NZvCdRE+8VsxOc9q0lLUJ5kHPqOjLL8Uxo34J1nOqmNM6t8i2TAUzp+ftXs/C6j2ma4XNpCM/Wwtrv8Yz+vnbAOXoddnCuCVnqVg8dGQzMWBqfAstEW7ec0J7APaiem3OU1Q+V/g1QAebq76N7BPATCEIJ4IBsBQaOvSdDimIPMf+DAVz5XyUU1piSoC4/7Js5KUv6X+6urbNUdFL1+sFs2BKvUFGv3wb2CdZ+k/RC2zWKrNNKfBkm8qgxZUOoPkqJt7ayjd6XXrFOzaAI3ZvYv4xD88AGfY1S5BYCTGbvNYk7gm0cFUENrn5hX9uL3CLUzRYmPqVdtybiH8FyA4WvBRN8rpdUksndxJruGHuHyktEkkiRY7NBXn9bCqxrcSOXk3FLvEvEMGg7iDlMVSrKP5h/iPqKIzjK6orQuuKKQjpA2Jg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

We need to modify setup_per_cpu_areas() to set up local percpu area for
arm64, the drivers/base/arch_numa.c implementation won't work anymore, so
moved it to the arm64 directory.  No functional change.

It looks like riscv is the only user of it after this change.

Signed-off-by: Yang Shi <yang@os.amperecomputing.com>
---
 arch/arm64/kernel/smp.c  | 49 ++++++++++++++++++++++++++++++++++++++
 drivers/base/arch_numa.c | 51 +---------------------------------------
 2 files changed, 50 insertions(+), 50 deletions(-)

diff --git a/arch/arm64/kernel/smp.c b/arch/arm64/kernel/smp.c
index 88a82eb56fb3..0cc8f4a9efa7 100644
--- a/arch/arm64/kernel/smp.c
+++ b/arch/arm64/kernel/smp.c
@@ -821,6 +821,55 @@ void __init smp_prepare_cpus(unsigned int max_cpus)
 	}
 }
 
+extern int cpu_to_node_map[NR_CPUS];
+
+unsigned long __per_cpu_offset[NR_CPUS] __read_mostly;
+EXPORT_SYMBOL(__per_cpu_offset);
+
+int early_cpu_to_node(int cpu)
+{
+	return cpu_to_node_map[cpu];
+}
+
+static int __init pcpu_cpu_distance(unsigned int from, unsigned int to)
+{
+	return node_distance(early_cpu_to_node(from), early_cpu_to_node(to));
+}
+
+void __init setup_per_cpu_areas(void)
+{
+	unsigned long delta;
+	unsigned int cpu;
+	int rc = -EINVAL;
+
+	if (pcpu_chosen_fc != PCPU_FC_PAGE) {
+		/*
+		 * Always reserve area for module percpu variables.  That's
+		 * what the legacy allocator did.
+		 */
+		rc = pcpu_embed_first_chunk(PERCPU_MODULE_RESERVE,
+					    PERCPU_DYNAMIC_RESERVE, PAGE_SIZE,
+					    pcpu_cpu_distance,
+					    early_cpu_to_node);
+#ifdef CONFIG_NEED_PER_CPU_PAGE_FIRST_CHUNK
+		if (rc < 0)
+			pr_warn("PERCPU: %s allocator failed (%d), falling back to page size\n",
+				   pcpu_fc_names[pcpu_chosen_fc], rc);
+#endif
+	}
+
+#ifdef CONFIG_NEED_PER_CPU_PAGE_FIRST_CHUNK
+	if (rc < 0)
+		rc = pcpu_page_first_chunk(PERCPU_MODULE_RESERVE, early_cpu_to_node);
+#endif
+	if (rc < 0)
+		panic("Failed to initialize percpu areas (err=%d).", rc);
+
+	delta = (unsigned long)pcpu_base_addr - (unsigned long)__per_cpu_start;
+	for_each_possible_cpu(cpu)
+		__per_cpu_offset[cpu] = delta + pcpu_unit_offsets[cpu];
+}
+
 static const char *ipi_types[MAX_IPI] __tracepoint_string = {
 	[IPI_RESCHEDULE]	= "Rescheduling interrupts",
 	[IPI_CALL_FUNC]		= "Function call interrupts",
diff --git a/drivers/base/arch_numa.c b/drivers/base/arch_numa.c
index c99f2ab105e5..b3b91ceed6a9 100644
--- a/drivers/base/arch_numa.c
+++ b/drivers/base/arch_numa.c
@@ -16,7 +16,7 @@
 
 #include <asm/sections.h>
 
-static int cpu_to_node_map[NR_CPUS] = { [0 ... NR_CPUS-1] = NUMA_NO_NODE };
+int cpu_to_node_map[NR_CPUS] = { [0 ... NR_CPUS-1] = NUMA_NO_NODE };
 
 bool numa_off;
 
@@ -140,55 +140,6 @@ void __init early_map_cpu_to_node(unsigned int cpu, int nid)
 		set_cpu_numa_node(cpu, nid);
 }
 
-#ifdef CONFIG_HAVE_SETUP_PER_CPU_AREA
-unsigned long __per_cpu_offset[NR_CPUS] __read_mostly;
-EXPORT_SYMBOL(__per_cpu_offset);
-
-int early_cpu_to_node(int cpu)
-{
-	return cpu_to_node_map[cpu];
-}
-
-static int __init pcpu_cpu_distance(unsigned int from, unsigned int to)
-{
-	return node_distance(early_cpu_to_node(from), early_cpu_to_node(to));
-}
-
-void __init setup_per_cpu_areas(void)
-{
-	unsigned long delta;
-	unsigned int cpu;
-	int rc = -EINVAL;
-
-	if (pcpu_chosen_fc != PCPU_FC_PAGE) {
-		/*
-		 * Always reserve area for module percpu variables.  That's
-		 * what the legacy allocator did.
-		 */
-		rc = pcpu_embed_first_chunk(PERCPU_MODULE_RESERVE,
-					    PERCPU_DYNAMIC_RESERVE, PAGE_SIZE,
-					    pcpu_cpu_distance,
-					    early_cpu_to_node);
-#ifdef CONFIG_NEED_PER_CPU_PAGE_FIRST_CHUNK
-		if (rc < 0)
-			pr_warn("PERCPU: %s allocator failed (%d), falling back to page size\n",
-				   pcpu_fc_names[pcpu_chosen_fc], rc);
-#endif
-	}
-
-#ifdef CONFIG_NEED_PER_CPU_PAGE_FIRST_CHUNK
-	if (rc < 0)
-		rc = pcpu_page_first_chunk(PERCPU_MODULE_RESERVE, early_cpu_to_node);
-#endif
-	if (rc < 0)
-		panic("Failed to initialize percpu areas (err=%d).", rc);
-
-	delta = (unsigned long)pcpu_base_addr - (unsigned long)__per_cpu_start;
-	for_each_possible_cpu(cpu)
-		__per_cpu_offset[cpu] = delta + pcpu_unit_offsets[cpu];
-}
-#endif
-
 /*
  * Initialize NODE_DATA for a node on the local memory
  */
-- 
2.47.0


