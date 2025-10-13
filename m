Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0F45ECCA476
	for <linux-mm@archiver.kernel.org>; Mon, 13 Oct 2025 11:05:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6BD258E002C; Mon, 13 Oct 2025 07:05:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 69A438E0007; Mon, 13 Oct 2025 07:05:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 582A08E002C; Mon, 13 Oct 2025 07:05:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 4003D8E0007
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 07:05:08 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 0221213AAEA
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 11:05:07 +0000 (UTC)
X-FDA: 83992809096.29.F69A0D2
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf29.hostedemail.com (Postfix) with ESMTP id 6EF25120008
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 11:05:04 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=q1Y+i67D;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=hfzCuu+l;
	spf=pass (imf29.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760353504;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/i8bGbwEKZW/mp5gMqsZlJEuERuJO71TRjnYcP7vz4g=;
	b=2GGMzDRNnVCIUCbJDvTrAtY1kh4BRT4VC8IyB0LLbjwlYD2vjFjjtIsNDtvqnO2lbXAMBv
	NlxZv51ahV9NJtVdNzJ3E20gCbfUoy05jpdiaZjgyJtxE/jbH1XHvClJ8Zj/pzoI+OWXTP
	lNZNJdtbQ+Ufa3sJ/77BBB9bZC0HAmY=
ARC-Authentication-Results: i=2;
	imf29.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=q1Y+i67D;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=hfzCuu+l;
	spf=pass (imf29.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1760353504; a=rsa-sha256;
	cv=pass;
	b=JcuYx49IsM0ngP2PFrY31KWl23NXHBC6Agl9jGNMzJB0LEXpjHQhrhT1hw1mbnRFCxEU88
	KiRUydqfmqCTA3jhe0hZoEP9UJ+yOECK3YjjAPHpC2jmw1N5OmuBaLBoQdlROMavMO875/
	dF/ppcyEKow/bC/uS2v23nmLWS8uqZA=
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 59D7uKcr013075;
	Mon, 13 Oct 2025 11:04:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=/i8bGbwEKZW/mp5gMq
	sZlJEuERuJO71TRjnYcP7vz4g=; b=q1Y+i67DTBJ+SLI2rVGU0VUpj4p6Z68zVg
	+a6OWkrxi/JGQrqTd6kELDxG01Iik53AaOREDXF3teQ8VBobl4/Hqs8izGhe/l1o
	zipMWefbwL0cOJ8IG4zPS1GfBDbOWcPya/9gUH/LGkHaSElRSRD+yJmhnf2RpEZ0
	/MUSO5blQNURAVEa1kWKsai7HeLYzmNZ6o0uoc/pxYFtKRhz4cw64mzEGGDsp9Ox
	8oPZCs5SuK1exek3g81twVFIranKrClVFwnqQoGLxY+1NTa1AB7x51knw2WrZhXN
	1hSSOf13dEfBdLQB+gzjZCErTQmiJbddUCLs/mjsgqIRvwKsrCag==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 49qdtyj2ew-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 13 Oct 2025 11:04:58 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 59DAiQ33037103;
	Mon, 13 Oct 2025 11:04:57 GMT
Received: from ph0pr06cu001.outbound.protection.outlook.com (mail-westus3azon11011014.outbound.protection.outlook.com [40.107.208.14])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 49qdp7drgy-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 13 Oct 2025 11:04:57 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=YW9NT32hGNwaH5gUICF92qEeg0E99yYIMGf+guV6iUEVflZaCWQjJ87laTwWTVZUsc3Scgmn636Jz2OolywZVFJfZZkeSXcVDe0bZFAE7todTpZyZULCAgTSfzUIO/j8qF7vyJ4oNdo3MQ3oTU0E+PJiKdhOuaDLMAKNy5iukPBKfc6KH+uqg+PMSvxEmHujgIO3VcPNIC7ygdOpNRAhVO01WKkM9IORbzltzeMlH40Oe3XY13gyEG7LGm8A0DgO1MvH1g1+2wLltdK5meCRo2FGeFx+2CHpfjNjuEUe+GqGr8W0LvL2k5hQyI7iMiSU/enpAXJC9zAoe4RfsS6YZQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/i8bGbwEKZW/mp5gMqsZlJEuERuJO71TRjnYcP7vz4g=;
 b=PVWj1nIyUeLbv2Nj+LQHf/0+X8AzvDcXA5XlPJA1sZbzvWfP39kDWe9TXXcwfgPRJuMQfHENIn4GjPa7Wlk0X0uMA0/dzDRPOBw0qLYchM+paUUvCy0cxneVwaoLMqEuz2/KvZO3+c3AJRUTGrQa1+enUtw2TCmi69ZrFzvkO3bbjJJikG+2p4tP90HmPcZAjWST0nc8bcC9azP2Pf2Wxfet9qsnr7iazi6Z+XmxaayD/zRz3NqjfmLqahXk7kiublap7qTe/6W/F5bLxCBm6CFGq7cuGRBTvA0Yz1M8rQRKQ1h7/y0btC2LZGutrqcUkQFpe0N3reSM/KZI2Be/kw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/i8bGbwEKZW/mp5gMqsZlJEuERuJO71TRjnYcP7vz4g=;
 b=hfzCuu+lCn5ZYGG5H0/GuvSDiC08+DK2T5Nh9eYek6vK0kPKOGeNgp4dDXCkv2NuufLwZL3RVMr11a+CVOOuGSwopLelqFHORi8aQ2N2OSEv9/qc9RoPIYLINVZqeolyftzgmndomf7dmiKbzLuvfOtKd+EyucIi5wsNSRb9IBc=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by DS0PR10MB6725.namprd10.prod.outlook.com (2603:10b6:8:132::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9203.12; Mon, 13 Oct
 2025 11:04:53 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%2]) with mapi id 15.20.9203.009; Mon, 13 Oct 2025
 11:04:53 +0000
Date: Mon, 13 Oct 2025 12:04:51 +0100
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Ye Liu <ye.liu@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        David Hildenbrand <david@redhat.com>, Ye Liu <liuye@kylinos.cn>,
        "Liam R. Howlett" <Liam.Howlett@oracle.com>,
        Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
        Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC RFC PATCH] mm: convert VM flags from macros to enum
Message-ID: <809f552d-3282-4746-ba49-066d2bd8d44f@lucifer.local>
References: <20251011093054.886460-1-ye.liu@linux.dev>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251011093054.886460-1-ye.liu@linux.dev>
X-ClientProxiedBy: LO4P123CA0174.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:18a::17) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|DS0PR10MB6725:EE_
X-MS-Office365-Filtering-Correlation-Id: e6a9cf4d-e09c-4e5a-073e-08de0a485669
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?2Gs7j1jWGib/6BlKOE64nbqt37vIf68H51LXjmXa+H+PA8eesrSQGEbZHeYY?=
 =?us-ascii?Q?1HlnFFrQsr2OA/9Pe27MF9t6o89eUF04X3NYYoHT8i49cqDPyZrpGYFTOnDQ?=
 =?us-ascii?Q?SpSFb2Rc6QqzQuJuACJGTvzhNkBJh2rDkYwkxxpeNw2EYXuSgVF43+/Ogq1B?=
 =?us-ascii?Q?aFQU1OQKdl3itGXqcCQVWHkSRy2k+aMyLoQQdJcO4G0NPalWbhnel8cB/mbm?=
 =?us-ascii?Q?UQBkqkPH5EC2ixoBz592zXJekHkD1U4g1yCl69YWQLCtd9ILFIOwXp4mYn2O?=
 =?us-ascii?Q?p+8D1hUFa9XeNLGD+qhfvagpBtkDruFyRa6Jq3KRRczrvL/4+5dFF+RGmEs2?=
 =?us-ascii?Q?dgNhAb0lEWaLVuStRvrlJV4G5roTASm0h15i+dtS6L2A92LJy3GkqC3oQw8k?=
 =?us-ascii?Q?KKAgPOmWB7nS5YJX8C23VHpSWxPjhvk3UE6ObLZKg2411NM96lYV5G3yFRKv?=
 =?us-ascii?Q?ipM9OrBa654Zet2joMU9Km9A65HZWvhhUOxjUH3ScPutmgu4vSWqms0VFWi+?=
 =?us-ascii?Q?0Zs54XlYOU/e1jaE0ZR94hRC945B4tpNspqKc2v/Qj7dvHiTBz3Nim9+1Zyc?=
 =?us-ascii?Q?epVMKmLis83s3/Sa4n6uDUJQsDG4WYCnkAL5DpFzK1MpI1rjZ3cW6HwvUM7a?=
 =?us-ascii?Q?HtkcsPPmsP84+LY045LSVxCwT6gPuJIkRqpSu0uEFpYFurTcsP21wPKrz8j5?=
 =?us-ascii?Q?+lkGb4u6fD1rTwhoHsi52g4I2LpraOUBhSU3LAHjq+iaqbAsKy/+/JKwrDNF?=
 =?us-ascii?Q?VRWSp0LTAwGoWYb4iFiUE28ci2JLpO1PGPDPaO3zrRpTxqCb2bQ4/ZQj6IxJ?=
 =?us-ascii?Q?kGaskPqgJCdGEMcNacpeaWaAJW3JqY39cGYYpmhbFpVbuTr+XpCr8D0/ryjJ?=
 =?us-ascii?Q?SQRwoUqLZkjMWQl7k8celeMRZkkf83x5wcumnc3jR7y40q7r3cMiKY5Cg901?=
 =?us-ascii?Q?wZp7aNLjWxoHA84BmKRTHzu7g4DhiKw5pwQhew//+dvvJLc1+0HmdCYAkVg0?=
 =?us-ascii?Q?mAUXV6NavaqMKHvJnXqGYRufojyDv3Sk8kicu4Gn+3OHc2qdFsmKdSy2Lk1X?=
 =?us-ascii?Q?Bh6fcYs804iFhjlTiJiMKCfc8rh5PFmIv0107R/4fNImK6SMtCYsGqDkcSfB?=
 =?us-ascii?Q?cfrk198qUikPjHLFdq06gK2uLN5OpSSp4CxZssnQPETQHfQfoWqralXpqfWY?=
 =?us-ascii?Q?Okr3ou0O2fbDwvuUWKfPCMK//9wYJSNqQO582frdfIkp9qOoqAJ18b4Z19+q?=
 =?us-ascii?Q?XHO9dLceIEnjLpV0Tv7dNBNwZUqk2jFB/OhUYx7jIbnjLYguoMbZdaPonwmP?=
 =?us-ascii?Q?pP5nBA8KCFIr4TDnELf1LcC45PU6anl4iDgW+2ZFLJj0qcV5izLsiv27qiEK?=
 =?us-ascii?Q?V0TPEEmSs6gfrbnm6/9ONzZ3f9mab+O6C5f6B23sup137L4jLItAyYRJh1tX?=
 =?us-ascii?Q?PCmlFnfMLrSaRPjYzL+d08clzlXstmGC?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?dEx3b+L2k4F0pMEIICIU3qnP6Rrt4dNjNbANX3l9pMf4+z4va+dViad48l8w?=
 =?us-ascii?Q?fhh8RuP6JCg9a576uzqoK8ryq4P+iJPgjiiettQ+QNxPrpPCyXviDQfbESY9?=
 =?us-ascii?Q?OoYdLHFseQdXliTP8naYwx6VfiQYhrTTKQFTkInjYQOfM9pgCOO+6jy/aEuP?=
 =?us-ascii?Q?qPjDQelv3cyfcwaUS5v6ABBUL8MiLvhbJHpISuoi0ZCJRcxpgRuSjSVS6HK0?=
 =?us-ascii?Q?GXmRZtGrOcwcd1d9+c1B2/ocrad+ayc5m0PGUdhsaO7T1IE6L25kCiRYYqYP?=
 =?us-ascii?Q?Vb8exEkjSZLfGaeToO8GrBm1n0CZu30iV74rFwHgcBth4MzHBlaguY4tA7Qj?=
 =?us-ascii?Q?zOihuREHMhwZs0BeA05O+SxF2icGwdK7+mIQ+YqBNLshKIfuPpTKhoYd3zK1?=
 =?us-ascii?Q?UYytnBynqLbZS1B6ZOWhsO3e9tjOoBHPWOIE27chj3op2DveXbQlQJE/Wuk4?=
 =?us-ascii?Q?Vg04HZjg286s5NG4+fe4Pi73b3OEot+pzQF2nrHdEuyF0BVBEFkgF8dBow+g?=
 =?us-ascii?Q?fixh1AC7hte9BNiNLZN10HYuvnUFiyYATrpap7IELqFoKZQj89UBmH3rzLVM?=
 =?us-ascii?Q?tH5RXLsTzYQIs9OHtWDDCyAbEK2QPAvgLPpXXRJQI3McsJIxb4cccv/Jrot5?=
 =?us-ascii?Q?0vjjhPuvj8etDCdU0wnaZa0nyM7AqAsfV1/NQfflMlj8sbt+CvQahGvSv/SD?=
 =?us-ascii?Q?GS0D31U2+he8cBh7IY31XhyuyOHS522Am7ztyeHDxmixU+a1ZUtCDu3TXm3n?=
 =?us-ascii?Q?+SMrB0nNcCTNjEmHgdoMsPzXadysIVg9vMEqXgemKM8ZmvUE0WIcM2ah4uOd?=
 =?us-ascii?Q?Qp5Lz5IYWAcVquvcJTApXTGsiTzF5hEFYWSfUfYiBhxujx6sTAhudt4PzJec?=
 =?us-ascii?Q?cn9bOwda4KU2NnpWt0dwubSkhMXs6w9lDvakm6E7CFA9AwMA16hnyWGxs+Wu?=
 =?us-ascii?Q?f0MIHJ1tjC7jSN5tflp2uqfpLbB+5nyYBNfvFFH585iv7wdacvwOb2Rs6FKD?=
 =?us-ascii?Q?ZRV7mLjtt48Wjjxkc5RysYJXhsP9BS8Mh9kB9vyb4Xq/ZXOwOtzObwSre3ZY?=
 =?us-ascii?Q?gIAdDDnD1d5MOzAeTbmP3HNDmrZZQUQyPQbyUvZGUxtoXHIk0IrWkL/rsKCb?=
 =?us-ascii?Q?7/JpIUQbxXEvvbasyRbZj1DvIBqyWIrNEflCNmcZrNR5QaTyMseLkQFFCjCu?=
 =?us-ascii?Q?ftwSFNMj68enZ5RLmUbhDEsxqKwwTDsYhsY+dvalNzlBkYeFvrqSDhh00B9U?=
 =?us-ascii?Q?cLfp9a5qxqlsrt6tdVlRlZU+cf8czTzKxZOPH7r/qCZirE0aJ9fzeLOyzsIw?=
 =?us-ascii?Q?JHtCBhGwB3SGxIR0uXzaGvRwP9J5Y8WtkPGGPm1AFIlKyJayqKrEDtsG87D3?=
 =?us-ascii?Q?71eDAiC1cNOhu6kynEGDgPjsxY7KaOiMFDFyeDUz0MryqECtCyuJbYu/aZn/?=
 =?us-ascii?Q?xz7XBuuhGvRadZ8LCvSQOMTjuPV5weKaDYSAYhgPLNbevwPtfq2uL7IqRAid?=
 =?us-ascii?Q?u8PiJa2BVoCvMCv/XtB+RF9UnWMHwMOEwIssfh3f4fRB13cm5Bp9W9HNzTlB?=
 =?us-ascii?Q?1N8COPp4DPhKo5xQG2PzEXiVHkt+WJPfa186fmrZskL7oREUI1RIxx8RbLgo?=
 =?us-ascii?Q?zA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	u12f9gLhjaO2v+tvsjd0xFL8C6v/K+7H8ZRsgIiZ1LmBo22lD3nm6RiYEtsgBrz7SMQFaRzIbIHQOcDyoA2lmMndODMH4YDveffKiYLfjrOrV6fbXSgN6DGsLMs+iiKPnkUcKAaTimIAEjYPGpeZxn82mT8mjzuIubRIh1OeZjut8CVt4s/2FPcV/RxF5MkMu2pXGRRguCkDPtEohKBRCWcEzZ2NZqv9Y7LK41zXEVhwMM1e0YZYzU5MYbDIsPDBu8KfshfRZIFQ/6AbD83JW5nuNS8eKWxIKVcV4r8FJ6G8vMNJEH+Ts98WJi+SOJGPHPfxiuzDEpKsN2gx9qrl9C57nW7UvDjC8GVlvCnNUVTrAxAw6SyARM3NeRuxAgOp9+AjAp4yRfzEVvoLhQPuw7DCDVTSN+q3tKPoPB4r4tAkXBBXszmk/hwc2/bJagaXPVo8VGqqAJ01WSGa6OwkwtUpXoBk3Cxp2AM44/Ks15FNub9UeB3qUdmUPv2kLYgVVKgPE9TWw6Dx5aa0hptm7QADHROsWOI8UYiI6eVUjqWjRVnyTwRY07shjqX3VQEfdktaPBtZYpRFWvCIzxINyfd9wOuBmx5siAmxvxBTBV0=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e6a9cf4d-e09c-4e5a-073e-08de0a485669
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Oct 2025 11:04:53.7490
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tJbUMni+t5ZRgmGa7j2ICswxGQkDo+Eaq41YUCC4Oqc5xsWo96ntUZBB0CncxvsYBgPq6LtPTj/lpDgZxYlDu1I8pCBfIWLgHV6PdDOtdu4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB6725
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-13_04,2025-10-06_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0 mlxscore=0
 adultscore=0 phishscore=0 bulkscore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510020000
 definitions=main-2510130050
X-Proofpoint-GUID: wvHfdQgzkt8IF2sfjxaLoM4bahe-iNM_
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDExMDAwNyBTYWx0ZWRfX8tjX7ZeKwwbx
 vNmF8+TfnBeunI38ZlHpMPpndMWffu3rNf4s93KkiWgT3werLdyTU1DVxwMoBq+zORfqcbtIv3r
 56gV9cw6xu+mtdIV9bAn8XuCX+MWqBFDMYLIivgxaDnCX9HxemhjApubO2aUPjIscmCizlaWMHT
 SJlSFbMUhEC4rq29UjAQDJndf+iKu+s12m3gj4/bf3A8i90bKRPVpLs01F8xnlXFYkj6sx9VQmQ
 dO/AxkGGZtEFCmD+LpdgEtawfRPbkfLtqwPoVhiTsb2Ny7EAAWQNHD18+KvxIV8vbgn/tl9/dXH
 1sBt9/zxNt2yNXM6Vhf2FhPxRZURw5X49qKFaJz77Lm65dp4pQVSpdLnmnYvAUxxYHxG3fvenKl
 PYYaVKQkuKoo5RAwKEduF/I/haYtbA==
X-Authority-Analysis: v=2.4 cv=OolCCi/t c=1 sm=1 tr=0 ts=68ecdcda cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=x6icFKpwvdMA:10 a=GoEa3M9JfhUA:10 a=CQz0DxbUt3c5JPvD0lwA:9
 a=CjuIK1q_8ugA:10 a=cPQSjfK2_nFv0Q5t_7PE:22
X-Proofpoint-ORIG-GUID: wvHfdQgzkt8IF2sfjxaLoM4bahe-iNM_
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 6EF25120008
X-Stat-Signature: hf6x8j8zzah37ad6a5orh8iqp6rs5ren
X-Rspam-User: 
X-HE-Tag: 1760353504-449321
X-HE-Meta: U2FsdGVkX19N4jc5W+qxxBjN3gfR4SVNWgikX1VQ/TSWBwM7fiAHjxcZ1NxpQY5hI8Jy4ydwKduE4d3EaUJh3nFKVznpQVvKaqWQZTOt855R+lfWsWTEyo54OKOGcIYAqTvDOZbahC5NFGQFWzCbDGETBWSEPhL/6xB65djhKX2E8e0EtQL9WYcIpU3F6VvyhLgWwfo55sAdk3MgWdodVmKKPlaXqUzScAevqTa5TjZ3x2GW/mvTVqsaf9lh42s9x0l66ezmOsDTDHoDwSBzijjmFB4k4c3Qx9oNGTyp7WO7X11N3M72wzgcCnad9Xuwr29OCsaG5OgI/+0yS0iZ+egvvLnkLfrRkk/VYMyOhob5X0z/kK3CC3HwIBfIvksWAJIRofhP6Cp3znvyVdxCm7FiQ1eGBGL2OTXjKxZnwp0vMJ78bmbabRsj41HUPaTGhfdMqx7vZuE3k3rzvLflweRZPopEZYUNZB/DsCsfhifprAFp3dQSkpWhFWqPfxL0F5YA/AQibnMTkrYU4Uc5jwnK9KSL7PuFCm5rctWWb9WVm+bW5uNufNRfkf+tdcb4t63B4WSYN2UFbjn4fj923WdYT2wKSLz9j7hTf2JLEHs1pZt2jkx3MKf/JMAivSLd7aWu03a1gB4V9QGy3VGVzFnw9I8+x+H0mpEkGKDwZlex2urKzyFo/wSeQn94cAY0t6Xf6itVPiaGoGU4FAF7Lp+01one0yl3gzJpzpmBI2EI5FpkP30ZFyElspTGn16zeWtTIF8jClO1PC3x1qmKoIUaM9pgDE6dOUYGDoksz+b+h+aa1n3ixLR1vC9m/+VVwHaNon7TMSLS4RCavGs1ttoLrn8P8Ydqiq5Dlq1cf0lyKJWXqL+vVimZtXVCznE64nXsHNbib6SMNUv/+JvJnM4bxZaiN2orqC/4G9dfu8rMmpKSxHo22WZf8MkuDGf39DPtyTbY9GQzeOHZf+r
 UfoStXCv
 I30IrgC5WyyrHva+mlzOFER++zG01FQ55NDBe0pJLrbaLvR9ekUY24eBG2sTkb3yvGoOcfYKqPbTvce1/o7FoM6akOWZPCgatpKGn79ETKGjTK1r51zLAjoHIJsJxpqYUKikhE2ThQax8zin9wLEauoVeqnRsPXe8OA3L5S9TgYv3x82NOIzi8KdOpT8fZoHqAxKiCBU1aa7i5n6hm7UOghi7R8Sv6Ov4cICgkhoJ790GP5ZJU02SLPLs9/39/Y5s5LY1LquBlrDim9vJd7vml2EX7kl079rn3OoukiVmIW35DWHA3aJg/TrQLw3KadP7Q1SZm1KTB90LODyAeWaGqIozD65VfiwA3/MEPXHVNN4rsU5lp7t0T93aND0iBbMpdg6e1fnl7Kg8CQzAccLUbS/i6sDrXriiGRGyiIEYJFRnQBHGih3h2pGHmlH7PbmG/RbwzsEmC3q86J4kiveSay33jz4nmV9tD775uWyIXL2APIe6w/g5ndO9qDa16bj5x7zWD1MiquU9UfPSKPcQ6u8LD1+CIMLp4gsieusTpaQHh3bOb1EGmv4i7oLZooNeseJLK5MpAjhmDyU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Oct 11, 2025 at 05:30:52PM +0800, Ye Liu wrote:
> From: Ye Liu <liuye@kylinos.cn>
>
> Hello MM maintainers and drgn community,
>
> This RFC proposes to convert VM_* flags from #define macros to enum
> vm_flags. The motivation comes from recent drgn development where we
> encountered difficulties in implementing VM flag parsing due to the
> current macro-based approach.

This isn't going to work sorry, it's not valid to have flag values as an enum
(they're distinct) and also - importantly - I'm going to be making significant
changes to VMA flags soon (to allow us to have arbitrary number of VMA flags on
_all_ architectures as recently done with my series doing something similar with
mm flags).

HOWEVER.

My upcoming (likely, multiple) series will result in code using VMA flag _bit
numbers_ in preference to raw VMA flag values.

Therefore, these _could_ be enums.

I will note this down as something to look at when I implement the series (it's
going to take a while, given the very extensive usage of VMA flags throughout
the kernel).

Cheers, Lorenzo


>
> Problem:
> - Debugging tools like drgn must hard-code VM flag values
> - No type information available for external tools
> - Maintenance burden when flags change in kernel
> - Error-prone flag interpretation
>
> Solution:
> Convert to enum while preserving all existing values and semantics.
>
> Benefits:
> 1. Better type safety for kernel code
> 2. Enabled dynamic VM flag parsing in debugging tools
> 3. Improved debugger experience (meaningful symbol names)
> 4. Easier maintenance and extensibility
> 5. No functional changes or ABI impact
>
> This change would particularly help with implementing the 'vm -f' option
> in drgn's crash mode, allowing proper VM flag filtering and display
> without hard-coded values.
>
> I'm seeking feedback on:
> - Overall approach acceptability
> - Any concerns about enum usage in this context
> - Potential impacts on other subsystems
> - Suggestions for alternative solutions
> - Whether this should include trace events update
>
> Looking forward to your comments.
>
> Signed-off-by: Ye Liu <liuye@kylinos.cn>
> ---
>  include/linux/mm.h   | 90 +++++++++++++++++++++++---------------------
>  include/linux/mman.h |  7 ++--
>  2 files changed, 50 insertions(+), 47 deletions(-)
>
> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index d16b33bacc32..7030108c3759 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -268,62 +268,66 @@ extern struct rw_semaphore nommu_region_sem;
>
>  extern unsigned int kobjsize(const void *objp);
>  #endif
> -
>  /*
>   * vm_flags in vm_area_struct, see mm_types.h.
>   * When changing, update also include/trace/events/mmflags.h
>   */
> -#define VM_NONE		0x00000000
> +enum vm_flags {
> +	VM_NONE         = 0x00000000,
> +
> +	VM_READ         = BIT(0), /* currently active flags */
> +	VM_WRITE        = BIT(1),
> +	VM_EXEC         = BIT(2),
> +	VM_SHARED       = BIT(3),
>
> -#define VM_READ		0x00000001	/* currently active flags */
> -#define VM_WRITE	0x00000002
> -#define VM_EXEC		0x00000004
> -#define VM_SHARED	0x00000008
> +	/* mprotect() hardcodes VM_MAYREAD >> 4 == VM_READ, and so for r/w/x bits. */
> +	VM_MAYREAD      = BIT(4), /* limits for mprotect() etc */
> +	VM_MAYWRITE     = BIT(5),
> +	VM_MAYEXEC      = BIT(6),
> +	VM_MAYSHARE     = BIT(7),
>
> -/* mprotect() hardcodes VM_MAYREAD >> 4 == VM_READ, and so for r/w/x bits. */
> -#define VM_MAYREAD	0x00000010	/* limits for mprotect() etc */
> -#define VM_MAYWRITE	0x00000020
> -#define VM_MAYEXEC	0x00000040
> -#define VM_MAYSHARE	0x00000080
> +	VM_GROWSDOWN    = BIT(8), /* general info on the segment */
>
> -#define VM_GROWSDOWN	0x00000100	/* general info on the segment */
>  #ifdef CONFIG_MMU
> -#define VM_UFFD_MISSING	0x00000200	/* missing pages tracking */
> -#else /* CONFIG_MMU */
> -#define VM_MAYOVERLAY	0x00000200	/* nommu: R/O MAP_PRIVATE mapping that might overlay a file mapping */
> -#define VM_UFFD_MISSING	0
> -#endif /* CONFIG_MMU */
> -#define VM_PFNMAP	0x00000400	/* Page-ranges managed without "struct page", just pure PFN */
> -#define VM_UFFD_WP	0x00001000	/* wrprotect pages tracking */
> -
> -#define VM_LOCKED	0x00002000
> -#define VM_IO           0x00004000	/* Memory mapped I/O or similar */
> -
> -					/* Used by sys_madvise() */
> -#define VM_SEQ_READ	0x00008000	/* App will access data sequentially */
> -#define VM_RAND_READ	0x00010000	/* App will not benefit from clustered reads */
> -
> -#define VM_DONTCOPY	0x00020000      /* Do not copy this vma on fork */
> -#define VM_DONTEXPAND	0x00040000	/* Cannot expand with mremap() */
> -#define VM_LOCKONFAULT	0x00080000	/* Lock the pages covered when they are faulted in */
> -#define VM_ACCOUNT	0x00100000	/* Is a VM accounted object */
> -#define VM_NORESERVE	0x00200000	/* should the VM suppress accounting */
> -#define VM_HUGETLB	0x00400000	/* Huge TLB Page VM */
> -#define VM_SYNC		0x00800000	/* Synchronous page faults */
> -#define VM_ARCH_1	0x01000000	/* Architecture-specific flag */
> -#define VM_WIPEONFORK	0x02000000	/* Wipe VMA contents in child. */
> -#define VM_DONTDUMP	0x04000000	/* Do not include in the core dump */
> +	VM_UFFD_MISSING = BIT(9),  /* missing pages tracking */
> +#else
> +	/* nommu: R/O MAP_PRIVATE mapping that might overlay a file mapping */
> +	VM_MAYOVERLAY   = BIT(9),
> +	VM_UFFD_MISSING = 0,
> +#endif
> +
> +	VM_PFNMAP       = BIT(10), /* Page-ranges managed without "struct page", just pure PFN */
> +	VM_UFFD_WP      = BIT(12), /* wrprotect pages tracking */
> +
> +	VM_LOCKED       = BIT(13),
> +	VM_IO           = BIT(14), /* Memory mapped I/O or similar */
> +
> +	/* Used by sys_madvise() */
> +	VM_SEQ_READ     = BIT(15), /* App will access data sequentially */
> +	VM_RAND_READ    = BIT(16), /* App will not benefit from clustered reads */
> +
> +	VM_DONTCOPY     = BIT(17), /* Do not copy this vma on fork */
> +	VM_DONTEXPAND   = BIT(18), /* Cannot expand with mremap() */
> +	VM_LOCKONFAULT  = BIT(19), /* Lock the pages covered when they are faulted in */
> +	VM_ACCOUNT      = BIT(20), /* Is a VM accounted object */
> +	VM_NORESERVE    = BIT(21), /* should the VM suppress accounting */
> +	VM_HUGETLB      = BIT(22), /* Huge TLB Page VM */
> +	VM_SYNC         = BIT(23), /* Synchronous page faults */
> +	VM_ARCH_1       = BIT(24), /* Architecture-specific flag */
> +	VM_WIPEONFORK   = BIT(25), /* Wipe VMA contents in child. */
> +	VM_DONTDUMP     = BIT(26), /* Do not include in the core dump */
>
>  #ifdef CONFIG_MEM_SOFT_DIRTY
> -# define VM_SOFTDIRTY	0x08000000	/* Not soft dirty clean area */
> +	VM_SOFTDIRTY    = BIT(27), /* Not soft dirty clean area */
>  #else
> -# define VM_SOFTDIRTY	0
> +	VM_SOFTDIRTY    = 0,
>  #endif
>
> -#define VM_MIXEDMAP	0x10000000	/* Can contain "struct page" and pure PFN pages */
> -#define VM_HUGEPAGE	0x20000000	/* MADV_HUGEPAGE marked this vma */
> -#define VM_NOHUGEPAGE	0x40000000	/* MADV_NOHUGEPAGE marked this vma */
> -#define VM_MERGEABLE	BIT(31)		/* KSM may merge identical pages */
> +	VM_MIXEDMAP     = BIT(28), /* Can contain "struct page" and pure PFN pages */
> +	VM_HUGEPAGE     = BIT(29), /* MADV_HUGEPAGE marked this vma */
> +	VM_NOHUGEPAGE   = BIT(30), /* MADV_NOHUGEPAGE marked this vma */
> +	VM_MERGEABLE    = BIT(31), /* KSM may merge identical pages */
> +};
>
>  #ifdef CONFIG_ARCH_USES_HIGH_VMA_FLAGS
>  #define VM_HIGH_ARCH_BIT_0	32	/* bit only usable on 64-bit architectures */
> diff --git a/include/linux/mman.h b/include/linux/mman.h
> index 0ba8a7e8b90a..4a0adbdeccdd 100644
> --- a/include/linux/mman.h
> +++ b/include/linux/mman.h
> @@ -130,10 +130,9 @@ static inline bool arch_validate_flags(unsigned long flags)
>   * ("bit1" and "bit2" must be single bits)
>   */
>  #define _calc_vm_trans(x, bit1, bit2) \
> -  ((!(bit1) || !(bit2)) ? 0 : \
> -  ((bit1) <= (bit2) ? ((x) & (bit1)) * ((bit2) / (bit1)) \
> -   : ((x) & (bit1)) / ((bit1) / (bit2))))
> -
> +	(((bit1) == 0 || (bit2) == 0) ? 0 : \
> +	 ((bit1) <= (bit2) ? ((x) & (bit1)) * ((bit2) / (bit1)) \
> +	  : ((x) & (bit1)) / ((bit1) / (bit2))))
>  /*
>   * Combine the mmap "prot" argument into "vm_flags" used internally.
>   */
> --
> 2.43.0
>

