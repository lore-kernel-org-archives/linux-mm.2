Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 68005CC6B1A
	for <linux-mm@archiver.kernel.org>; Wed, 14 Oct 2026 13:18:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5D93F6B0095; Wed, 14 Oct 2026 09:18:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 58A226B009B; Wed, 14 Oct 2026 09:18:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4788E6B009D; Wed, 14 Oct 2026 09:18:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 1F2D26B0095
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 09:18:33 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id AA836C0554
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 13:18:32 +0000 (UTC)
X-FDA: 85321286064.03.A1159C1
Received: from AS8PR04CU009.outbound.protection.outlook.com (mail-westeuropeazon11021122.outbound.protection.outlook.com [52.101.70.122])
	by imf26.hostedemail.com (Postfix) with ESMTP id A7BD7140013
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 13:18:29 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=virtuozzo.com header.s=selector2 header.b=tNGgUaNc;
	spf=pass (imf26.hostedemail.com: domain of khorenko@virtuozzo.com designates 52.101.70.122 as permitted sender) smtp.mailfrom=khorenko@virtuozzo.com;
	dmarc=pass (policy=quarantine) header.from=virtuozzo.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791983909;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=16I7Gnlehp4rtQgca/20zMUSGtwWYLFnOQWH6uyrbAo=;
	b=1CN+8PdQu9Sevh/Tdy+VlNwL/VGDegSQpY6eUOwqY/x2D78peD/S6sz3svUwnUAoT9IXrK
	gV3udWcP/sZQiD/L4EDGXAa2/jKms2RaNYZxr4vdt+wwLypEXqf1mp4tpom7eSPocmVWnq
	CnejKAOA+PGwTOCL4AvdB+kNzLm6rkg=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1791983909;
	b=VbragRM6nPHTI/u58ZdbWXN77/etPbsT7jUYw3rjV10KmjC1mDWwtFXwz1GbeKmv2JtgcO
	zvQou3TjuV3D13M+OIw6AKIWgnfdyMa591CRyo5BJvcVJafhBn4xSv9uCXrtYLm3N8sVAX
	1hghWmk6+wKUewA+ifO3PCgnGKHclAY=
ARC-Authentication-Results: i=2;
	imf26.hostedemail.com;
	dkim=pass header.d=virtuozzo.com header.s=selector2 header.b=tNGgUaNc;
	spf=pass (imf26.hostedemail.com: domain of khorenko@virtuozzo.com designates 52.101.70.122 as permitted sender) smtp.mailfrom=khorenko@virtuozzo.com;
	dmarc=pass (policy=quarantine) header.from=virtuozzo.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=jTc90a+SfTE4fgUT8ZUWSGtOvjWo6kTZTSbKvga7UwEuIGLl+Oj2aYNA1v4PIxeSqfaV942PU5elRFyWV+IR89obXvdUgufD6prdAN1gO3SiuiXuaOy7HD/RQ2yi4AWg7ezbqJWbwaJjHG0afCxBO6ahLBF4e5N4Ye0TMaW3YNz9gn6tCoUGjNuCvAdUyQz+IMgD47WC7/HrOy8YqhFVKAvCQr2it7C6sauayeSXjppT+6gVrqvXvelUvLJ88B3q6AHqOQRPkm7qia34lenS7/Js7nVjfig+nD1Qb8P2LwPY4RwDjzqZFyq/NJsgDm/15AiQN6nML3C16EJxTFXodw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=16I7Gnlehp4rtQgca/20zMUSGtwWYLFnOQWH6uyrbAo=;
 b=Ba6Zf4CiMZpns1FN15TxR0mIsi88xFxwWUFw4zAPED987/tsCHMnDwCych3uRKkHdNqtLjNiuDAIzbTKblAElnSHTNgiP5rif4pCVLBBWAIG7q14CMn9DYxMdP2GnZ/g5Gep4plZTGDoo9U7jkQfKqNJtiTnne8SX3fwE5TUFRPaYrYI19V+t1CLO6ocv+uQ8ukMh74Aw0Qv5nHwarHEGfm30YjV/7nY7AIzjgnTjtZanUkChsHbP2geLwBVacGCR84pQBGzZHBvGyGGfMNPJGsV8h8nSa0kNHHpzv988cbIljSh5H3RginvjKpvhsHX5Nc58IaBCjHZnrr2cFTGUA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=virtuozzo.com; dmarc=pass action=none
 header.from=virtuozzo.com; dkim=pass header.d=virtuozzo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=virtuozzo.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=16I7Gnlehp4rtQgca/20zMUSGtwWYLFnOQWH6uyrbAo=;
 b=tNGgUaNc8W8e/opjNd7hcls6GHD51/YFuSckYVQVMfIrpskhTUOvwO/Ek5TvhEXoSf1d6yyJeoPmaxQU3GXoUl4x/Y1KYiU77IMvOtWdtK49DvNbsaE4lPMO+Ww0Ul8Z7eB9ixT3NN0b2zeEge+G59Ui1D/XcKcVdnNKcNleKP7M+kCVn3BwFjAVy1hDsQ+TvRmtCiAsBmo0CY+JKgiHt6R0ULDw8OMAtAo0dF+9xwkhoqu2mzFDHmzAlMjP3IOuZZ+zcZzKXCHDk38xSO16ai4wF+TGdwYpvhncCltFR7EVhHciwtCrhVGiP7lUuaIJDFTvZ4jGPcVkVrz/6W8AiQ==
Received: from PA6PR08MB10708.eurprd08.prod.outlook.com
 (2603:10a6:102:3c7::20) by ZR6PR08MB999901.eurprd08.prod.outlook.com
 (2603:10a6:910:d2::23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.522.11; Wed, 14 Oct
 2026 13:18:26 +0000
Received: from PA6PR08MB10708.eurprd08.prod.outlook.com
 ([fe80::1999:c6db:dc55:494a]) by PA6PR08MB10708.eurprd08.prod.outlook.com
 ([fe80::1999:c6db:dc55:494a%5]) with mapi id 15.21.0522.011; Wed, 14 Oct 2026
 13:18:26 +0000
Message-ID: <723a480e-1aa2-4e06-a5b5-38948a8b50d5@virtuozzo.com>
Date: Wed, 14 Oct 2026 15:18:24 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] mm/shrinker: size shrinker_info_unit to a power of
 two
To: Qi Zheng <qi.zheng@linux.dev>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org
References: <20261012-b4-prep-vstor-144715-size-shrinker_info_unit-to-a-power-of-two-v1-0-5a7608393b7a@virtuozzo.com>
 <20261012-b4-prep-vstor-144715-size-shrinker_info_unit-to-a-power-of-two-v1-1-5a7608393b7a@virtuozzo.com>
 <c2d25c25-2fd4-4bb5-a021-3cdf23e493d0@linux.dev>
Content-Language: en-US, ru, sr
From: Konstantin Khorenko <khorenko@virtuozzo.com>
In-Reply-To: <c2d25c25-2fd4-4bb5-a021-3cdf23e493d0@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR2P281CA0047.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:92::14) To PA6PR08MB10708.eurprd08.prod.outlook.com
 (2603:10a6:102:3c7::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PA6PR08MB10708:EE_|ZR6PR08MB999901:EE_
X-MS-Office365-Filtering-Correlation-Id: 46b3de81-b7a5-440e-168a-08df29f5a192
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|23010399003|1800799024|376014|56012099006|4143699003|10067099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	pQllWE4gLaAXpvliRIi+a+F7fbSEniOMDYEC6Fpn9/HaJo67NziN6vnqZ/u4lNEMUeyBaqQYTf5EkvYYCb9kXFOUaIS79S0ZCdzpJMpcADnt+BJpV/B0O+Emfa+Yv7AZT0MxaeT7CCdNQeT+uDDaykohk4SZgoNtrj8IRvNHJ4LhJSiEcRaqZW8QcTPmdcpuQdBI0Fgu/KKhiqbjUmUonMR+0nX0R/RroiT0UpfsrXMaSfgqhBd9QwikTCjCqcG+2kXBg6mkPKGcEDhYMRnwnrLqOZrMMJZKszfDLYYonnfJjekekWjzlUtsDnDDb9w1bdXfYddU34b0oEP1qKUQc31aa9D2k+IbLP+FCJasBDkF1aD1WndTc7IdPo3YAJ28ueeuEoUnCyyhlEHY5zAa5zIZs2Gv24mngE9+0F+z2Lyl1YZzWmvMyoa0t0U9MNAF1YLpBrCB3Bgmlkz92s8RtT/7w3LPyjyWKlbA85PYCcnDZlU62PjA7EtdbslW/1Jnro2LjDsbZI2On0WZvqcStmmq1pFtTMxMIkrLmcNbl5cF/gPt0WApueQGvgTdAMdO63bZo4mttk9RTmHMzuJdpA7ELlCDwwgEfQsY+J3Z4PxrkUpWyG1uaAZq76A6hCwb10FgZW6QZRZ2ydva3suRSACxucR662MA5T3GSU08Mto=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PA6PR08MB10708.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(23010399003)(1800799024)(376014)(56012099006)(4143699003)(10067099003)(18002099003)(22082099003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?MWQvRGwyZEV3TVJVMnFrS0h3MFlWZ1VieGxsY0VpK0VnVE5GcFFXQ1NpRldm?=
 =?utf-8?B?ckVoQTVYZVRielcrbDRDcHhBYlV2NXd3cUpmd1ZHcUVZQTNtME95M0hILzQ1?=
 =?utf-8?B?cFROMnZ5Z1F6ZDErU3BWTEFrMnVjQzFxVEd4MUtPamN1bHFIVW9EKzJQcmUz?=
 =?utf-8?B?djF4QnQvTXFqamx2Z0pBbkM2Z2xDQURaTUREY1gxY0pXbFdmREVYSE9TT3Az?=
 =?utf-8?B?VVFNdkNqRFJkU2xNUDRvOXR6cVVwcVdhNTJGSnZZaEhGRHhvQVpYTWowMGNO?=
 =?utf-8?B?WUJwYUZHV1J1TTNRT0pNQzJxUDczRkM1VU1Ga2ZHYnA4eENZK3E0bmc0QkxJ?=
 =?utf-8?B?aERrUFB4Vm9yZnRhQmgvczkyZTQ0L2NoTnZ6TDVCRmpGaGNDdDNJOEdJSHM3?=
 =?utf-8?B?TlFvY0pVWFJFOFFHd1F5RE5vdU9GU1NJb1FlajJuYWRPWGkwdXR2VnlZN2ZK?=
 =?utf-8?B?eHBxWGJEKy9xWCtxYlFwSDhuT1pteWNBclJjZkRMOVUwTjNxNzhWR2pUeTMw?=
 =?utf-8?B?Ri93K09QQUtDK2YvUWdKdFVkTzFINk1aSVVrMG9DYzUvRCt1NS9BUy9tRTdS?=
 =?utf-8?B?Q1JPZDVFZno1MG5RVWtCMjBUUkdNbDBmeGk4enk5UjdDVXBFemlUbXJPdWR3?=
 =?utf-8?B?VjdMbFR1QVZOcFNZL3NPQkptbFpiMThFWEQ5WGE4dVhaZmFrWFFVMmZGTVRG?=
 =?utf-8?B?S2x6b2xwUkVEZHpZdEx5RXRFSmNya2ZLTS9uYTYxT0IxNlFsV0ZnQ295RGta?=
 =?utf-8?B?VExPVmFsd2N0OVB2RnpxMko4ck9SNkFTN0ZOU203T2JORUZJRGkzbGR0bGhj?=
 =?utf-8?B?TThENHZONkh5MktNZlBQNWhRTW94OHMrUXZvQldBazFjMUlpZFRoYUtVM0lG?=
 =?utf-8?B?VHpERno0bGRYU3daQld0MUdZTHdFUWJaUWFUeWdmaUx1RFZyb0ZZMTVXdmFq?=
 =?utf-8?B?V2lJUGV6TW52MXNQbDUvQlczWFhteEhuSzdIaVpuWHRoUUF5akx4RjVRRFEz?=
 =?utf-8?B?NHhaM0svc0YrRnB2bWlVSUhVTHN6VEF3bDVvSkRVTjFKUGduWWFUVkJNamhF?=
 =?utf-8?B?bEs2cjNXZERZV01Ya0dXZVMvcFpkR1ZUTHg0WEFUZGM3NGpOWkZPVDVtQkNj?=
 =?utf-8?B?bUwwbXRXdVQyd3FMV21hSStGVXBGNlpGb2p2Q0RtaEc1Kzl0NEVnZ0RYbmNi?=
 =?utf-8?B?ZGJvU05RMVFsWXk1bys2Uys4V3pCMjdVb1Fvd09FanJGQWc5eXRqYzZOZ2M1?=
 =?utf-8?B?dDFnOWJETjBBZ0xWb2Y2VDlERWdWTGdVc002ai82TG1ocXV4YTNLc3VhUFFO?=
 =?utf-8?B?RGVlMUg5bmdseklOd1p6WENwMU1NNHZmUldGZDluQjNZNUI2Ym1FTlU2Mmdw?=
 =?utf-8?B?czBvT2R0ZmRCaGxkUUxiaDR3L0NpdzFhWmFjaWlHOVVQYktkOFNIbS9CcnFn?=
 =?utf-8?B?ZmxwZ1RScEFnT1Z3YklQQU1YcTFoUUw2eVNLeE1lZmZnTFNzWTVXNlF6K04z?=
 =?utf-8?B?bkV2QnpHZURQZjFsMDVIaHlaMkFiMnRDVHNiQml5V2U3WHhYNjd2all5UXRr?=
 =?utf-8?B?MGo4d3BmR252QzIzMmNLdjJ6Mk83UFhVRWtaM0tOaXVWTERrWTB0ZVkrUjVj?=
 =?utf-8?B?TCtXUi9tSDQ5YVVMUmNRSDIvQ1YrTjl5MVlhaVRpVlVhT1ZTRVQ1Ry9CWFJR?=
 =?utf-8?B?NjF3WThCaVlTdnduc3BidndUWTBxeW5UU2p5Sys0YU4xbHhyQlR6dnFvMWNI?=
 =?utf-8?B?UWNUcGoxcW9PTnhVMmtMZERYMkIwbWdDMDA5VnB6c1N2YVk1UTBaS1lUSktu?=
 =?utf-8?B?UDhPKzB0dDR5VlkyMzI0Q1ZEZW5WRlhad2Q2WlZKeU1Ra2txSCtXL1BCSW5Q?=
 =?utf-8?B?WmtLdU1FMUFzUnBYMEo1R1pYdElUd0dpTHVMMkV3djEra3ZHdXRpN2V2dlBj?=
 =?utf-8?B?KzZxQ0lnVE1BS3hVU3Q0bmo3dkJuK1lpQW56bVFhM2JBdnhmSWhhc0hDUDF4?=
 =?utf-8?B?b2pzTWRoaWtpeU1BbXgreHN6alMyMThzbGFRL2d2RVhZcTlYZy9QYm9CMEw2?=
 =?utf-8?B?ZXlRdTVLYzc5eThieElXdFpCRjZMS2FjR1JEQjVoL2Q1bDRNaTAzQ0k1YzNG?=
 =?utf-8?B?dk10eUxyeHk1RnpNSHpEOWs3b2s4ckxIdytBQTJSK2g5MjBhNUFKYmhxbEox?=
 =?utf-8?B?NHdMZzNtWFg2TW15VEFlSTBNRWRXZk9iNGhSdEpKSkFaRzNMYXBzcHA1cXBu?=
 =?utf-8?B?dW95NVNMWVcrTUhXTnhUZGpETFZINU15QkQ0My9RQVNaZmkyVE1xQVNob3hj?=
 =?utf-8?B?SVBQZFhva2QwaTJRZnZ2Q3c4MWZCL1JWeGY0UjQ0RDBqaTZxa2ZjUT09?=
X-OriginatorOrg: virtuozzo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 46b3de81-b7a5-440e-168a-08df29f5a192
X-MS-Exchange-CrossTenant-AuthSource: PA6PR08MB10708.eurprd08.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Oct 2026 13:18:26.5401
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 0bc7f26d-0264-416e-a6fc-8352af79c58f
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RaWC/HV9vAgkUAzO+oR8MNHWtjWAFknPTscIbtD/F2AaR9iquHyGB4pR4YEuie0C8BU+OhziDPEOmtfCjMLhXQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: ZR6PR08MB999901
X-Rspamd-Queue-Id: A7BD7140013
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: ng9fjq9gzbeyicj3nmnzhnyonxsudjnq
X-HE-Tag: 1791983909-915088
X-HE-Meta: U2FsdGVkX19+BEdGZy2LYt2EXj/2d/78wmTY/sqI6v0vHynldRor08MdAcVoebFnVf1xszG90v4CZZicl4QAJu/4U88X6MNYdZhTz1QEDjjNUllb53q/x0Lbgp8sEcvoJEQ1ZAiuNY0UDdZKGLz8qxEJXEKsYyGArDosQqaNzqIz/WXBO9M/uU1kPRb5yZ/sBuIagftPcqyE5hIaH4iAONFOR/hDlQHDCCBSZiEJH5KFGPdEBLBVZtzbBa4n2MR4p1OBpCYE9x3S9HW9wo2DcmYEg8grO40qCru4C1nnLvn5v4zacAMfPnjFEV8cFRdnleBmx1KDldxN3EXeRQYz4zRvlBjAvYLoIYepR37Cxf8Mwo0+q6vqwPBN4cXM1SS8AImq9JXkzcuAtUFZ2/DHBVVs+NrUx972l9jv9J+O5PUly5CbqhELu0f9eonakJIAyyM4YOc/ot2tsj0Jwl9HlpEvuWWZm9klliA1q/hz0FxHDM70AipWFNkf9v0P5I6WYH9ll6JVvPHfw+eO7e1lzNjTlPmJgDa3ERU8htNp23d7IddEv6e+fSsn4YE6Yg35dx6vk2p+NKekHW+0WYOBENKbVYsX1v7fmeCDPGHRYSWHcG0yoFeraojoDHKYRgfBTk81VMwWKESXNS4UW3TcePqjU4XsFsqk63qjsBH86osEs+iltllacvCrTK/OID0JQOcN5xc+HFBtd5UZePev+CLcftGb4u2XC8SaP+Xm0BI9LTPPzMnno2cUByanHWufdAJFTizU/qPw8gzGm3labpGQMlqIjZV024dfDs2yXByri7HamEj4L1iYZRL5DEAsF5XGp4Chn5ew+nyixbtos8tSGC7UZ/7W21X4bgXXVzDeEO+P8RImmvLtGvi9qswdDrrA5TZ7jrlc55x1LyDSoGud7ACXxHOgz7sFC6N0MtZm0xtLTQwoG2zQMS9gEE9XhMCEw2dJbqiWjAvQTnF
 mMK0RlWW
 ez+ZsQFhwMJVVkxFizhnsHgqiSokaIaXvkCVHp6nZ/uYsCeFLRAjMr7u2gkTc6AgJMEazH2Vji5i2XXVYa2ym8C99a3Inr6tdNusUVfRl/Vhiu/xhrmqf5y9Jof2qAsRYVjXxGhwH5Z2ucxlp+onf8rRR+Hx61xIbCvcASJMbf1IpkbqRSwYvuMJviQeUwxEKjmDbAXYOPPFJ1//7groz0upmC3Ga1lJR8sstavtqIrrgSflv2yWelqkVqmiOLDBk0CNSiy0eRXx9V4Dq4IF9+7ay15fq81RHrUyecbi65UD/XX3AXwRE6A/3BUKezCeQrZvu9CXFj1S4ckDgy1SdPxYqn3q/KmhTlM1QRN6fS5IKybNVnb9YDXMh3woQvAWVH2eBsqIaBGaRLqhx7XazcjbhUwyZkF7gPsPs46HotnmLedTlyJbNdbhbeHsFBtLGQV3+lOj9TajQGfXA1AJpz8fhnFqw1oBzc8YlPiYDIHnk5vx6uOaVYYU4iJS7aOYIS2QgL43FGl5i8cpUAC/lZgEaWA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 10/13/26 04:52, Qi Zheng wrote:
> On 10/13/26 3:02 AM, Konstantin Khorenko wrote:
>> Every memory cgroup allocates, per NUMA node, one shrinker_info_unit
>> for every SHRINKER_UNIT_BITS shrinker ids up to shrinker_nr_max. The
>> unit holds BITS_PER_LONG atomic_long_t of deferred work, a power of
>> two, plus the one-word bitmap of shrinkers with objects charged to the
>> cgroup. That word takes the unit just past the power of two, to 520
>> bytes on 64-bit, so every unit comes from kmalloc-1k and almost half of
>> it is padding.
>>
>> The units are allocated when the cgroup goes online and freed when it is
>> freed, so a dying cgroup keeps them until the last reference to it is
>> gone. Their number is the number of memory cgroups, times the NUMA
>> nodes, times shrinker_nr_max / SHRINKER_UNIT_BITS. shrinker_nr_max is
>> the peak number of memcg-aware shrinkers registered at once, and every
>> superblock registers one, so a host that mounts many filesystems and
>> runs many cgroups carries the padding as unreclaimable slab, and keeps
>> paying it for new cgroups after the mounts are gone.
>>
>> Let a unit cover one id less than a word holds. The bitmap still fits
>> one word, and nr_deferred[] plus that word add up to BITS_PER_LONG
>> longs, so the unit fills a power-of-two kmalloc slot exactly and, on
>> 64-bit, the memory taken by units halves, for about one unit more in
>> BITS_PER_LONG.
>> round_up() in expand_shrinker_info() needs a power-of-two step and
>> becomes roundup(); the other uses of SHRINKER_UNIT_BITS are divisions,
>> modulos and multiplications that do not care. Assert the unit size at
>> build time, since the layout depends on it.
>>
>> Assisted-by: LLM
>> Signed-off-by: Konstantin Khorenko <khorenko@virtuozzo.com>
>> ---
<skipped>

> 
> Acked-by: Qi Zheng <qi.zheng@linux.dev>

Qi, thank you for the review!

> 
> Thanks,
> Qi
> 
> 
> 


