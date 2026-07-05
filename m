Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 34126C43458
	for <linux-mm@archiver.kernel.org>; Sun,  5 Jul 2026 03:39:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 085336B00A2; Sat,  4 Jul 2026 23:39:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 00F3B6B00A4; Sat,  4 Jul 2026 23:39:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E18796B00A5; Sat,  4 Jul 2026 23:39:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 948556B00A2
	for <linux-mm@kvack.org>; Sat,  4 Jul 2026 23:39:45 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 184411405E0
	for <linux-mm@kvack.org>; Sun,  5 Jul 2026 03:00:56 +0000 (UTC)
X-FDA: 84953220912.12.55DEBAD
Received: from BL2PR02CU003.outbound.protection.outlook.com (mail-eastusazon11011038.outbound.protection.outlook.com [52.101.52.38])
	by imf24.hostedemail.com (Postfix) with ESMTP id 2C40118000E
	for <linux-mm@kvack.org>; Sun,  5 Jul 2026 03:00:53 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=aHeZpL1B;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf24.hostedemail.com: domain of ziy@nvidia.com designates 52.101.52.38 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783220453;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mZI8xjwftEfCK/s0clvaoGNIcmMYBCvnGWNvDJOHlSE=;
	b=xfZAtd1cW+sJ9UO/5jOmPON3+ycks+tf8+HZpIpubflYQhPNU/r9jUmitabRlmdD4vfQa1
	enDpYnk9ACoVTJyFf3tKO+qIDzXmdos7lafWy+b0EdvioDePCiotQdai4DbTcXteFw1Ulv
	XY9+XunkNWpSEg8+3tsxPlEwmFrRlss=
ARC-Authentication-Results: i=2;
	imf24.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=aHeZpL1B;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf24.hostedemail.com: domain of ziy@nvidia.com designates 52.101.52.38 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1783220453;
	b=8CEnE98e38qgrbjiqm3kAedXd2tZroPIFJrza27pYGvgkrd5PKuSgnwRuGzoyimDCZ6ze7
	/v1lmz3PyWF0L6NdVyJrRm32BlImnVaNHzPShdTj7oA1vx8wwXQya10xB9xlIK2P5YqEBc
	0vFNahHbvffdkIWf4JFzD7/tarKigBE=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=m6A9gXkct3PEZwuTX5WEIfBUBu0ZqQ5Rzpt3vA+OQLWPcz+cUmZVa4CBK2NqVMGMhLxJf7sa+mylddKKbKlhP7QG2rxnyjzoOk2cp052PdA1zL8htWnamfl12w9oUaol/9L86tvokYsSbYky4pP/0E4FmTU5LWc4nEQtvfIGLWEfz5h5oXMrq+euzrMOYatP6N2dYYdETdKCVjKo3jgd3uhdyejyamQgpBysGCY4tgPaSX5mcT2ChLpnYmEjblxjMGdU8tbLE6rvX2S91nzaYKeF4nmN6cNeNCqVAUYIjiQBiwbaqgeEMgdrvIm8H6nDz1JWY9tuZ9r7O7437MXj9A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mZI8xjwftEfCK/s0clvaoGNIcmMYBCvnGWNvDJOHlSE=;
 b=uEl8hlfonW4SQSjMpAz1S4BZ7DC7eoJ6MbAIQB0ua/u09UKufz17N8GVQy3ff9sNFy5A2K4182w3pWdQOp1hKx3mESDnpo0/a+KTYHgViik0BV10C/V37gYR+jKIR8A0p21QMyAum3nH9PBaRg2ae7VWCUIz8dz2ezdQF7Qj2YhqHjdMN5Ye282ueEc1lpWAj6het91MfuMPMKoFKkqlisxGdy50zTNzt/ig+lDyyAW4Lg42ybRMBW7lOc5xdy7LhsxM3rWJjIWswjK7zQIZMXdRMMUTCoIQ928bkNlcuTi4MX5Gq9DLRPsT+grH93Nii2hlMtDzkXv12WEnBQZ73Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mZI8xjwftEfCK/s0clvaoGNIcmMYBCvnGWNvDJOHlSE=;
 b=aHeZpL1BsMTROYm2AYHuam/b1VOjzFYV37gWFX9pTlLoxC3Y9ecqsoDHpwB2U/B3osXerPesciJHqaatqjCjBtSJCDXmbroWBM4PewYnFTba1wD14pX3/BuLIRe/4uyvZuy/3Y0c6NAYum7N3eFYl60k56ORrxZ7pJyfAhyzTGInmi43vWiflPrOQ25LwtQBIE2+nEBOd+YPLVpkUQfqgOTD64W321NqYzFTwB8Jvw3nl7o+0zBKF05/G9fqst4uAeUiIUPjgh44n5N8RTzaifFk591Ktxc6Cn4FGNy9SP7UWL/sjspkdl8A938Q37lshSJlV1rFxalFRALAaEjJKQ==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by PH0PR12MB7984.namprd12.prod.outlook.com (2603:10b6:510:26f::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.181.10; Sun, 5 Jul
 2026 03:00:48 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%5]) with mapi id 15.21.0181.009; Sun, 5 Jul 2026
 03:00:48 +0000
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Sat, 04 Jul 2026 23:00:46 -0400
Message-Id: <DJQAW40O46NQ.102IK799EYR9P@nvidia.com>
Subject: Re: [PATCH v2 0/5] Keep tail page private zero at free and folio
 split time
Cc: <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>, "Zi Yan"
 <ziy@nvidia.com>
To: "Andrew Morton" <akpm@linux-foundation.org>, "Vlastimil Babka"
 <vbabka@kernel.org>, "Suren Baghdasaryan" <surenb@google.com>, "Michal
 Hocko" <mhocko@suse.com>, "Brendan Jackman" <jackmanb@google.com>,
 "Johannes Weiner" <hannes@cmpxchg.org>, "David Hildenbrand"
 <david@kernel.org>, "Lorenzo Stoakes" <ljs@kernel.org>, "Baolin Wang"
 <baolin.wang@linux.alibaba.com>, "Liam R. Howlett" <liam@infradead.org>,
 "Nico Pache" <npache@redhat.com>, "Ryan Roberts" <ryan.roberts@arm.com>,
 "Dev Jain" <dev.jain@arm.com>, "Barry Song" <baohua@kernel.org>, "Lance
 Yang" <lance.yang@linux.dev>, "Mike Rapoport" <rppt@kernel.org>, "Dennis
 Zhou" <dennis@kernel.org>, "Tejun Heo" <tj@kernel.org>, "Christoph Lameter"
 <cl@gentwo.org>, "Alistair Popple" <apopple@nvidia.com>
From: "Zi Yan" <ziy@nvidia.com>
X-Mailer: aerc 0.21.0
References: <20260703-keep-subpage-private-zero-at-free-v2-0-2970fe777dd6@nvidia.com>
In-Reply-To: <20260703-keep-subpage-private-zero-at-free-v2-0-2970fe777dd6@nvidia.com>
X-ClientProxiedBy: YQZPR01CA0031.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:86::29) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|PH0PR12MB7984:EE_
X-MS-Office365-Filtering-Correlation-Id: cba50119-a32e-4369-7433-08deda419d91
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|366016|1800799024|376014|7416014|921020|11063799006|56012099006|6133799003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	YInbpDXdYSVF/I9cAe3xNChrpW+EajUIM/RD04H3ebg24f1WB0Jo70be4e30ONkUpjgGu1XchFWVEbhnoA6TsVdZeOo6GgLtD0zzjqGKkAeiqEIq2euDj5hsecPCJt0+fiLJFZchT93CzvkZuLp5TdMtEcgJm1OJFPIuTAQxRxrsV1jklrCojaGf9/m7ukt3usrVvIxOe6QTBKQiQg6LHcXIfu4Xx/3I8Bdmq2y83MMC9JXmeQ35YvHfIZeGJY863ROJr+OtMp3G6H28Z4buOzao4Cm4LurUAW1hLfswg75GwVq/ZzxtyHyi8JfSKJTbQhzdFOnTHXq35iJFNnH4B5m/ye+aN5I3SoCTFqLC1gygBcmXvOq4fJo3tDUE+6UIH0rKzwqNMeI7hpZKgKlNjKfh/MOzltqzg5KxMlikN68vVOwAzwoqLGpdjT8mBeksRmQc2V/hX46egLlE2LhSLKJNgUeMWizPbspOYC37a4yMzn4QBEMQ/Gc7LRnslJyURsETZO+MQ5gM3G+as5cp/ydSsM1qqtcPebUhmu6LNrS3vqibCXOzkzE0JPiB6bQ2BvAkzJX39XHjw78cdVE0Il/AuA5ITJFa1wnal39ok1orKK3RoKcRBKufn6ZImuGIJHSWJB8Y/v2PGgJMLZSC2ysTEuDnZPoVM24C468A0lVTTxgHG4Fe9WokhO2HAGMU91+vWXxpFbR+AeDEqMZYBQ==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(366016)(1800799024)(376014)(7416014)(921020)(11063799006)(56012099006)(6133799003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?S2tMaUhGNWVNTk5wWkVtTFNBTlZDdFNJOUNreU9FTmdXRElqWit5eFN1azVr?=
 =?utf-8?B?ZDdLYXJGRUVudy9YaXZLZzg5N1pyYUtldW8rNWsxMkVtL3hBcHhyd3cxVVlU?=
 =?utf-8?B?cXBJVkFnazdMb1Ywc2hHQXlabFFGUzAvNCtEUHlkZm8rTGZUeVI4NDI3eUxp?=
 =?utf-8?B?d2NJYmFZT2prZW5KN2Q1SXB1NE5MYloxNFdBSi9WRGR2TEN4MVBXVkY2YjAx?=
 =?utf-8?B?bVhKUE1aUmZ0STlVNDEyYnJOdnFORjFGSk1lWk8vRkhBOStla2VjNHBKOElW?=
 =?utf-8?B?VGYweEZGWDZBR2xGZ2JlRm9pdm5jdlY1SFFlUVdua05oMmFtcW93emUzMHVQ?=
 =?utf-8?B?ajc0M2FNaWlHM1ZLK2NXNG9mZHVsR3huRHAxTVBYb2lObWZQdXpaZEtaT1VB?=
 =?utf-8?B?V0MyREhFb0xLd0xCK3AxYmc2OG44L2pZUjduNG9jbmlPTTVVSGlOMzJxMGQ1?=
 =?utf-8?B?dCtWZm1hOUdMeHQzS0ZDR0V6N0NMdkZWeStCOTBjL1ZVM2U4QXp1emFvVmJT?=
 =?utf-8?B?b20xTWhGaFdaQUtwS1Z0YjRBOWdsQjU2YStHbzl6Qjd4SmdnMmNsbTBha2hr?=
 =?utf-8?B?VWVGemkrZENpOFE4d2ZYWHpMaytCYlZrdGtQdE0vR21LOWZpdHBxek9kanMz?=
 =?utf-8?B?c243RWpFaFNwMVVFV3hFejAxY2ZiZDVmU0doUldwVWJ1ZWxPLzVvNmNobGUz?=
 =?utf-8?B?d3k5ZWUrSXk4cU1LeDJ0OUg0NFJ4K2kwQ1pPUG0rd3d4ZzQ0YnZiMEFBN3FW?=
 =?utf-8?B?NE14SWlRcG0va3VYL1ZmVm5JenRteDlLVmdTQlFiLzNTZFVSaVdhQTZPRElT?=
 =?utf-8?B?NlgvL0owYnNBQ1RMcE81ZFc4TWpuSFhLbUpYVWpwRVNYQXNzVEhyNzllWm82?=
 =?utf-8?B?YnpzN0NrT09tYmd2ZTJuNUloMm42VHZTQTMvOUs5UDJRMENPWFZNNjNGV21M?=
 =?utf-8?B?ZWNMcUJ1Ry9BdW5qV29FeUFTcEZIZEFyQ1l2c3AyN3g1VWdoUzI5LzVXMENh?=
 =?utf-8?B?dENMS0tKbFdFclhCQjhnMjRiRXhmcjVYazNZK0hQL3NyOGd3aUpJK255Vllj?=
 =?utf-8?B?S1BsNzVwQ0tBSVI0TC93anRNMExGR1FxWHloTjhOckJudjErTlMyTnNNSFlP?=
 =?utf-8?B?aXFxNUg1d1RXTHhrVmtOaWlodVEydDJMd01RT09vSnRrcVo2L0lRVUtIUHpp?=
 =?utf-8?B?YzV2ZGQrU2ZHdHh4cE1pcURyTHRjemxodWFFQTZEc3RnTUNzTkxCTjQ2OTJa?=
 =?utf-8?B?ZlVNZ0NlTmFJK2xONFROa0Z5ekplVGlwZnZzNGZHV1lBZ2pJSy82emtRZUxT?=
 =?utf-8?B?SkR5c1V5ODU5amdzSU5aamlnTHk3TFBKQU1kU0tqYnJMYTJNaDBVUjdQclAx?=
 =?utf-8?B?RjZWYjVWVWZUNGh0dStleURlTExtaGdLQkFwYUVtY2VRMGJWdlpRbWRJeXdS?=
 =?utf-8?B?RGN6aHdyRGhMS2NTc2ovb2VuS3VwS0ZjQ0tzTnVyQjM3dGNNLzQyWGhLaHlV?=
 =?utf-8?B?VjQ0RU1NUk9DZExxakR1MHZ2UXFtZlQ5ODM3bUkwMVVOaFA1ekZaWjQrUTg4?=
 =?utf-8?B?ZGZ2NVpXVzVUNCt0VXlBVU9RVGl5N0MyTTl0b1JUeXEvSHlVMVZTM0NKeTd1?=
 =?utf-8?B?dWNJRHZKTUhGT0lhcFE4UCtaR3BDSDhxTUJ0bVFoN3NrYmtZT0dxOG1DNSs0?=
 =?utf-8?B?VS93akdFVnlTRjZpOHpCUWptZWM0QkRmbXM0bHoyVndMV3R6cUVINy9HeEpk?=
 =?utf-8?B?dmFJa2tpd0swZjR4ZDBsUkc4MU1Pd2FydXJCVHBTa3AzallSc1RmM2R1N1cx?=
 =?utf-8?B?aVJPMTVsc1lWLzJpUXR3enhRbHZmbVZTZVM5ZjlTWXEzc1pLb3JYb1ZiZGpx?=
 =?utf-8?B?cEdHdXRwc0NES1F4ZENubzZYeVF6M0t0YzJKSW5ValNMczlORmtiMUNvUWkv?=
 =?utf-8?B?VjlERnhCUmhvL2l4SUFQTTVjTlc2QlJCTFJhRUZjVVZqNkoyMlFoMlNxUkdE?=
 =?utf-8?B?ZHFwMEx3RXhoUG5qMm5vV0lnMDJIVUdGVVkzc1JNSUVGUm54WFVFbkpkRTNa?=
 =?utf-8?B?MVFjQUJrWHlZQnRBNDFkZm01T3BVbjlISEVPbThRclZud1RFdW94aWZNWDU3?=
 =?utf-8?B?UlRhUVRaNHpnMUJjQy9yTlk0VkRNNkZZUUswV2xjQ0ErY1ZUcjBEcW5Gam9H?=
 =?utf-8?B?QWpISUVOVm9DcmxkcW92amEyRGxRL2dlbGJMUThMQXVyazdrbnBqYjZoZ3pI?=
 =?utf-8?B?N012YWpPeXQwUHAyWFVXUEFCbFA5MjcyM0R0REJ3bDhtMTBpREJiRWdvOHZq?=
 =?utf-8?Q?Bx4/NTGYIf9Rbsrp/I?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cba50119-a32e-4369-7433-08deda419d91
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jul 2026 03:00:48.6143
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9c55J3GNi18/8yHd653T8AImOzHma6MlvKJAj9un2gdrQS4s48iER/q3gkZLhyhi
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB7984
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 2C40118000E
X-Stat-Signature: d53hdyycogaj6nrg65ib4nbcoao6eo3c
X-HE-Tag: 1783220453-827586
X-HE-Meta: U2FsdGVkX1+P9nvZ0CTzZor4wOTrjqnuzKKXYFnoYKlntXzbrCS6a7TjWPEYAiatPyAIdGsmNOlgjXNVL4bHAsbXf1/34W3mtgsDa2iuz50lIdu6L6SURH7ntZ6mZI6YlP5sPgNSLyQzmFzvpLU30gxXCejgWkN1D8Ah5KH4AdTLcIAb1JYHDTbBxDQ1i2UIGwlSm+sCY4d2DxyjFwZCnqjQtiH+ZSVMJzZv8vbDqPXaZr1IgjqH/84o6JrGfPu2RBoWSK0Y7rivrTwcz7UlPDRvnSSrnYy5zn9p18XsuX8iBb+AMw646964Xn9pfImw78QvJRPHroj8kPhTRuisoHcoK62i+hCrebFZjB7BRsAdWain6CE8ZUs+Rw/aMqMAygRwWo0Mle9ZUX/zQxLjjnOQkOlo2Yjz2vb5Dxab7yp9YBdl+vTNpgEvgy4c2Vi8ya7Lsbn8FFYP2TPrheIQukZXpRU3uRS7elvUFql20KLH6vEN24daluv/KfLcUL3WSeDO3TX3iV9IJIj2fS2VfaFvzWg2X0ZAKUbejJeHm3qDmdDUb5g4uIaUP3bVdVR0lVd95uWgvxqrpym5Q9KnXUvhIlOmaG0nwztCxjyrZem3keg6BVg+x41SiVcYUWGJMNHtFzdwaKbxY4aE5m5MdWTt/KnWUHb8hDsFvbdZE2CtTMYvvgowSTNgsh3+DoGXgKVbxn8oh9WPRgPDkONV9Q+jM6GPGnFMCmFKuuSNbsw7gbFvJ020YJq9mSyPMP1DkUgIsQFKYEWlQ0wm/Cp0FS6Ik81u+UgVn2GbK4RBJKbgPWNufZR+9GV46qH7MxTDJFYwormaBWxXEdz+d6aJxaj+tcjr76n/Xn2Vt67jouGuld4mmebFlu2AgMUtakjOiPODxDnEcDtFEEbxdvOPgkjkhtBwURyO3O65+d9+tXqjFiuxbYSoOKz7F5wRCOaJrd1GMC1zLM7mczYvFMl
 0pZLx72Y
 H9MXz111T0HnFOfXYAJzpjbRI3cb0STSyl3BStOpVE9itnqGWsBeQ/rgVIIje4uYMZJsTyv0RXIsBQzGs+iCFQ0GPF4/WuFor14p9FwXwqdqdeygfM6wi0vkNe+rViCfYU69JT2j9VkR9mwMN/sbNyuPpIsDSQ5Ze3wD2Qtu7qdz8G99ZWaby1jy9cg8BX9FaSVNX0wv5RI4CFRJiQreAoV+/waobJ2RrKT3aZbirF3zq9EZOzAgN6TuKTLOn3gfYI8/NYotj7uUFoxqP/3wBc3Nnd94+Eu/DRJ/V7OjWDehKBCRyIw9tCnSyOtHPXp1hNLGHEEk1uWzwwdJxxMggFW5K3UIPnzkKHKZpzvUysXpxKQuM/XGY3bIMzNUkUvKOWGqU9lU1UXrGekHvETvsemDFLC/0EuNGlCivDCXA3+M4oQvloUJ5zukvO8eJSlecMcQobD76L472GUl+Hlb1JARACNpYZX+LeBOb2NxWkc8pzAihrhmM+Sh0Sh/5+xbje17h
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri Jul 3, 2026 at 9:47 AM EDT, Zi Yan wrote:
> Hi all,
>
> This patchset makes sure tail_page->private is zero before compound or
> high-order pages are returned to the allocator. It also checks tail pages
> that become new folio heads during large folio split, before their privat=
e
> fields are used by new folios.
>
> It is based on mm-new.
>
> Note on ZONE_DEVICE and DAX page/folio
> =3D=3D=3D
> ZONE_DEVICE and DAX use prep_compound_tail() to reinitialize folios, so
> tail_page->private was reset before this patchset. There was a concern th=
at
> after this patchset stale ->private can appear after ZONE_DEVICE/DAX foli=
o
> initialization. My reasoning is that no code sets ZONE_DEVICE/DAX
> page->private, so their page->private stays zero all the time.
> ZONE_DEVICE_PRIVATE page migration only supports anonymous memory without
> swapcache, so after the migration ->private remains zero.
>
> But let me know if my reasoning is wrong. It can be fixed by adding
> ->private zeroing code in ZONE_DEVICE/DAX folio initialization code.
>
> Motivation
> =3D=3D=3D
>
> page->private is zeroed at page free time since commit ac1ea219590c0
> ("mm/page_alloc: clear page->private in free_pages_prepare()"), since we
> concluded that it might be too much to ask every page user to free a page
> with ->private zeroed. The holder of the last page reference might not kn=
ow
> whether ->private needs to be cleared.
>
> For compound and high-order pages, tail_page->private can also leak to
> later users if it is left uncleared. The page allocation path does not ze=
ro
> every tail_page->private field, so they can be seen by new users and caus=
e
> unexpected issues[1].
>
> Check tail_page->private at page free time, and check tail pages that
> become new folio heads during large folio split. With those checks in
> place, prep_compound_tail() no longer needs to clear tail_page->private
> when preparing compound page metadata.
>
> Overview
> =3D=3D=3D
>
> 1. Patch 1 clears all pages ->private before percpu-km frees them.
> 2. Patch 2 removes setting page->private in compaction code when a free
>    page is taken out of the buddy allocator. cc->freepages is indexed by
>    page order, so storing the free page order in page->private is
>    redundant. In alloc_contig_frozen_range_noprof(),
>    isolate_freepages_range() is used to grab free pages from buddy
>    allocator and it leaves the aforementioned page->private set until
>    either split_free_frozen_pages() or prep_new_page() is called. That
>    stale value without resetting triggers the tail_page->private nonzero
>    check once set_page_private(0) is removed from prep_compound_tail().
>
> 3. Patch 3 adds back the page->private check for tail pages promoted to n=
ew
>    folio heads in __split_folio_to_order().
> 4. Patch 4 adds a tail_page->private check in the page free path.
> 5. Patch 5 removes tail_page->private zeroing from prep_compound_tail().
>
> Link: https://lore.kernel.org/all/20260206174017.128673-1-mikhail.v.gavri=
lov@gmail.com/ [1]
>
> Signed-off-by: Zi Yan <ziy@nvidia.com>
> ---
> Changes in v2:
> 1. added reset page->private when percpu-km frees pages
> 2. replaced subpage with tail page/tail_page in all patches
> 3. moved implementation details from cc->freepages patch message to cover
>    letter, since it is too much for a patch description.
> 4. used VM_WARN_ON_ONCE_PAGE() in __split_folio_to_order() patch without
>    fixup. The expectation is to catch any violation during development
>    phase.
> 5. guarded tail_page->private check behind is_check_pages_enabled().
> 6. replaced tail_page->private reset code with VM_WARN_ON_ONCE() instead =
of
>    deletion in prep_compound_tail
> 7. the pre-existing issue in alloc_contig_frozen_range_noprof() is under
>    discussion and might not be worth fixing.
>    - Link: https://lore.kernel.org/all/d44ae8a5-ec70-456b-92a0-ce7ccabf69=
17@kernel.org/
> - Link to v1: https://lore.kernel.org/r/20260628-keep-subpage-private-zer=
o-at-free-v1-0-f4ce3930d10f@nvidia.com
>
> ---
> Zi Yan (5):
>       mm/percpu-km: clear page->private before free them
>       mm/compaction: stop recording free page order in page->private
>       mm/huge_memory: add page->private check back in __split_folio_to_or=
der()
>       mm/page_alloc: make sure tail_page->private is zero at page free ti=
me
>       mm/page_alloc: remove set_page_private() in prep_compound_tail()
>
>  mm/compaction.c  |  3 ---
>  mm/huge_memory.c |  7 +++++++
>  mm/internal.h    |  2 +-
>  mm/page_alloc.c  | 13 ++++++++++---
>  mm/percpu-km.c   |  9 ++++++++-
>  5 files changed, 26 insertions(+), 8 deletions(-)
> ---
> base-commit: e031e55776cf9193b4720a253e92539ca536d224
> change-id: 20260603-keep-subpage-private-zero-at-free-a1e1435025dc
>
> Best regards,

Answers to Sashiko's reviews:
https://sashiko.dev/#/patchset/20260703-keep-subpage-private-zero-at-free-v=
2-0-2970fe777dd6%40nvidia.com

Q1: To Patch 1, this isn't a bug introduced by this patch, but does
pcpu_create_chunk() overflow chunk->populated on SMP configs?

Answer: I am not familiar with the code, but based on my understanding
and the chat with codex, a patch like below could fix the issue. I will
wait for the feedback from percpu-km people about it.


diff --git a/mm/percpu-km.c b/mm/percpu-km.c
--- a/mm/percpu-km.c
+++ b/mm/percpu-km.c
@@ -74,8 +74,13 @@ static struct pcpu_chunk *pcpu_create_chunk(gfp_t gfp)
 	chunk->data =3D pages;
 	chunk->base_addr =3D page_address(pages);
=20
+	/*
+	 * nr_pages covers the physical backing for all units.  The populated
+	 * bitmap and pcpu_nr_populated accounting are per-unit, so only mark
+	 * the logical chunk page range populated.
+	 */
 	spin_lock_irqsave(&pcpu_lock, flags);
-	pcpu_chunk_populated(chunk, 0, nr_pages);
+	pcpu_chunk_populated(chunk, 0, chunk->nr_pages);
 	spin_unlock_irqrestore(&pcpu_lock, flags);
=20
 	pcpu_stats_chunk_alloc();


Q2: To Patch 5, does replacing the explicit zeroing with a warning leave
the private field uninitialized on production kernels?

Answer: there are a lot of ifs in the question. It starts from one could
allocate a non-compound high-order page and free it without clearing
tail_page->private. This assumption is wrong, since Patch 4 will catch
such code. So there is no issue.


--=20
Best Regards,
Yan, Zi


