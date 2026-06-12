Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7D2BECD98CE
	for <linux-mm@archiver.kernel.org>; Fri, 12 Jun 2026 23:46:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 541396B0005; Fri, 12 Jun 2026 19:46:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 519986B008A; Fri, 12 Jun 2026 19:46:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4077D6B008C; Fri, 12 Jun 2026 19:46:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 2E9C96B0005
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 19:46:21 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id BF5911A0272
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 23:46:20 +0000 (UTC)
X-FDA: 84872896920.24.02A8679
Received: from CH5PR02CU005.outbound.protection.outlook.com (mail-northcentralusazon11012041.outbound.protection.outlook.com [40.107.200.41])
	by imf20.hostedemail.com (Postfix) with ESMTP id D6CEE1C000B
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 23:46:17 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=IJWSILpC;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf20.hostedemail.com: domain of ziy@nvidia.com designates 40.107.200.41 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781307978;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jBDl6hZzloBCc+5AzxerwpC00Z3yAiSbyQtD9q9nNa4=;
	b=aoHS0aw3EkSCcu/c12/928XK6jM8nfxlk9v/6OtBTGN1IMTBMvmFIjgEBXXiOqAnEbyiuW
	eWOUQgat+5iHJaLp/g+SkFmBJ95MoqzHg+pIIJAo0HoA1xRiXUeG7sWC7ONDQTe7wqX4dK
	RzXCTxM/pXCWl0UIxBVLajuWhBd+Le4=
ARC-Authentication-Results: i=2;
	imf20.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=IJWSILpC;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf20.hostedemail.com: domain of ziy@nvidia.com designates 40.107.200.41 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1781307978;
	b=YXm+WkNzKYTJftd1lRxnzXcOO++vK4D6NMOoqmX+umoK+j5UV6nB0bMIrkwfaUe+/5bHjo
	XuDGOknfzo6/nI1jeZ4QdcvRcvkIArSZ7+G0s+iYLkXOcv8AdhIluEzU8wYNG0Ihj7TJQE
	+00tf9fpCWwCm1rES53mb2Qg80AEPfU=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=bCPHlKFp19tLiDD6TubiL3VCbmwE0JFWzNdFDSftRj94W1N7/IXvpPQ2L2AxxJOBilOF1p9AiSUtZA50recAS0wU8fBIcY/I7etzpZROVGvJz4VtG+Dqk7ns15zGM6Ut3I8GPnbPUIvDFRVd8pBwmjr2FZiIShtlo5deg/0LzRWsie5Yiw4eJoF2jbSftz+Lt3+yynrkDlqt/uB3YgkE/7Nl6ha1gqmiyBR+S1D3tXMgVHTK9BYRL74bSD3kpkGjF07JX4cP4rhxPRRobBn8/zx3y3hrKvmXPhBb5A1b8FTsl9CB+p6wbU5FQKri+uFplASAWZnYiJAZ1lp4y2iVOw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jBDl6hZzloBCc+5AzxerwpC00Z3yAiSbyQtD9q9nNa4=;
 b=QsJGtwV4m3p73JfdFlXfbdV/DI8z6Xn8uxnStX9ekPIORdF0TFZFQe8DahRLpgEjW30nU9UikhndctiXn7fuCCFYZFy5rXCHodQmu/24dAz8v5QTc00pXKlT4ZpMKyE9jJIDqd8E4n+6VASN59+L+EZxLDOVA8AF8BoxYF60rW/c0otTCKertcui7SdR+cWRx8AVbWSzTVna2igiHFC2IXVEAP1+uGcWw+yYYbfpMGUvSMv40JBDiiu8MKO2/ap8GVJjvIxF3Q3Ox2HDrhHinysB2VKkKKoq3ZbGTZPir0g1BP9kGdv6RIUvX2MA0opvYZxWVAUMAseSIn047xthQw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jBDl6hZzloBCc+5AzxerwpC00Z3yAiSbyQtD9q9nNa4=;
 b=IJWSILpCLKqhS8aGFMwyjdbyc8BNYOqV0emKcPm1GxaMqYwXYpIApNYWJL11bvLnEHEdec/BECD/fP0JyaSoVuGaKdqFeWUz6+P5sMTnhrerxpN7x9+Mt9nPkdErdC99jZBEdemLcrtUustuAVq8axGdmsHaHJyY12addaKVxRv+loG4XfBwPjTF5jHu0IgS7m5ajor2Tnc+duyJOVUfIMhVLnUP/hX4YNZzFLUkpaOwS4CnS297x0HNcGm+Go6vcRFPqdORS2hkD7hkE6Y4AR406s9lwSa3y1fFP2u1UYQJbvYW3MUlC2ndCRasHkUOYzIQGpGPkGbHm2l90zdl/w==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 CH3PR12MB7619.namprd12.prod.outlook.com (2603:10b6:610:14b::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.113.15; Fri, 12 Jun
 2026 23:46:12 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2%5]) with mapi id 15.21.0113.013; Fri, 12 Jun 2026
 23:46:11 +0000
From: Zi Yan <ziy@nvidia.com>
To: Zhaoyang Huang <huangzhaoyang@gmail.com>
Cc: "zhaoyang.huang" <zhaoyang.huang@unisoc.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Barry Song <baohua@kernel.org>, Baolin Wang <baolin.wang@linux.alibaba.com>,
 Lance Yang <lance.yang@linux.dev>, "Liam R . Howlett" <liam@infradead.org>,
 Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>, Jaegeuk Kim <jaegeuk@kernel.org>,
 Chao Yu <chao@kernel.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 steve.kang@unisoc.com, xiuhong.wang@unisoc.com
Subject: Re: [PATCHv2] mm/huge_memory: do not add dropped split tail folios to
 LRU
Date: Fri, 12 Jun 2026 19:46:09 -0400
X-Mailer: MailMate (2.0r6290)
Message-ID: <E8DC5ED1-AC9E-4362-91B3-21D49A9311CA@nvidia.com>
In-Reply-To: <CAGWkznFJO5Y9+nicnY=ViuUbWzg5F0Gq3+RYFe9AF2j26k_UeQ@mail.gmail.com>
References: <20260612023456.2424044-1-zhaoyang.huang@unisoc.com>
 <5718685A-8469-48F2-8FFC-10C4BE054F10@nvidia.com>
 <CAGWkznFJO5Y9+nicnY=ViuUbWzg5F0Gq3+RYFe9AF2j26k_UeQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: YQBPR0101CA0272.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:68::13) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|CH3PR12MB7619:EE_
X-MS-Office365-Filtering-Correlation-Id: 3b3f875a-8cae-4075-e795-08dec8dcc8a2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|1800799024|366016|10070799003|23010399003|22082099003|18002099003|5023799004|11063799006|4143699003|56012099006|6133799003;
X-Microsoft-Antispam-Message-Info:
	d/S91GqdA5OmherXPn6q0Ldx2QsfebVxgRNTdtgxwvRKpwv9n/poMtmOhE5BhuOQj7jrk/4j/ZE9W9PRiqqrRDIJkvwwiufGDTmTbk+fcK6bsOTcOaga/lxbHsaMKDq+T7YLgI+Eqr90vMLXtrYctxjUtheCsb6mbkwpVDV6Bl8suc94drrl/j4w4pgSJsLn3lolyA882+aSXR1dPj/vp8c+qtOGpoO05f6/wX1Y0FpZFywTNwth7xj/NMTj/SG35NL4jMCiJkcthPAp6YRgOg4k0MF726W68DPHvSuyRwR31qpO3WbyyOCEnfoKYzpnPHWXxHbZZBepGddZxr9kW7Wmd6aNRPalWptA1nMGJDjNg6tGV1RAup5QW0SFMozcZdOjhzaZdT4FS0WYqhHwj2ViAAhonIH9wV1CiqdPbk/wc1Sgw9KDCVmtepGUNVJUux4RALACvVw9rP0AzBbP9WTNXtOWPjQLHX05e9yn6odahtaH5m6AnBzUl8KDLeICS8G1unxZ2UqDFd5Lur8nsQ1c4zQN7YR44/mH7tvPZb2WY6N9hBq7KwPjr8KmAUPyNDwqcfQQuyQbjjzcBCPv35ntTdo2K1j5gGnRtNIEoTiOyuOsunTu4bSEu2c9Q22rRolRatRK24D5qCzsNspvCFKDmKdlAGVPyg7M846ezht8QiVDZgZltVE7jBkB2COeHpSHP9SwDhcDd1v5LR4YBQ==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016)(10070799003)(23010399003)(22082099003)(18002099003)(5023799004)(11063799006)(4143699003)(56012099006)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?NDdOU1pWUEFmSFh0bVVwSWZnN1BubjRtQWtXalNhcldFSzdCZUhNYzNyWlpG?=
 =?utf-8?B?MFF3d2F5YU53Y1pwZjZaamhRTU56dXVQTzFhb1M1aW1HYi9FWHdhUEpyWTBG?=
 =?utf-8?B?L1dQNGFBd05KY215ZHhFaSs0WGlHbERQcHJHdXplNWNIQ29OTzdMQjVrenpM?=
 =?utf-8?B?UTNjVkU4Z2lmdm4wNk91UHlGZHJ3QW9WTk5TRkxSeFFodHhzelhqSUpNUUFB?=
 =?utf-8?B?VnhkSWpKS0pidXNLZC9rQ3ZrNlNaK2R1bkxmU0ZxT2VqeEVqLzJ6NG5YYkVC?=
 =?utf-8?B?TjN0aVgvcXo4L0s2cXpRUXlERGUwRGg5clpOc2tXdEFQRGg5aGd2YkRibzda?=
 =?utf-8?B?N3JxLzR6RjFMdEdFREs2eFlSTXJ4OUVsQnFYNE1FbmEybVJNaUR6U0JQa29U?=
 =?utf-8?B?SGpxWjJLN2FCYU1xYTdUSDRWUC9HNFV4bG1MZ0FWcElsd2p4MFVQK1hHb2RD?=
 =?utf-8?B?MUFXSDRXQzlaY0IwSWRrN2d3V0h2eE1ZQ241b3V3eThpNzMrZHhKVTJTQ2Ex?=
 =?utf-8?B?enJnbDhSdHRFaVhlQTlub0RjRVBmemhlNktxcUdZdExyNHZ2T0tWNHp4MnAr?=
 =?utf-8?B?OTFwbWVQbzI3TFZkNUxNUEVIUkhRcVpDRG1FUlczZ2dONHNWclY5a3NMS3lF?=
 =?utf-8?B?cWVCcWNESHNIb2lOT21lV3lydHNxRkhBQ2VldWZHOWMwKzNQUXZMMHBVYXRC?=
 =?utf-8?B?SzA4NjluNDN4SVVOcXZvQ08wSXFad2p6aWxlcE1RM0w5T25Dak9DbTIwVWF3?=
 =?utf-8?B?T2VvVkZFUENGUmVROGUza2JyY2tGUExrbmx5T3dTRHFORWRhbDBoUmFmYTZP?=
 =?utf-8?B?NE9xeFoweWNrUGRIbTE4cHUrOG9vSzdYb2tPbWhDVzVIdHF1RkVURXgvb21o?=
 =?utf-8?B?d2l1MmtTNUtRZ2lLd0VuNnE5NnRTVFJNd0dZbDk5WCtqNEFBNnQ3V1VLMXpX?=
 =?utf-8?B?SC9udlhsZWxKMmtQdjRBZWFWajRHWjloUFFhL2VQWXQwL1pBT3JMbG04dW14?=
 =?utf-8?B?M2tUbU1sKzFLUnVGWFRvbjJZWm4wTjNlWnllbUdGU25WcmUzMkFabGZBSjVw?=
 =?utf-8?B?b2hkWlVGZXJDc2ZDRWJyZVBGQzY5NUJwbjZUaXFPMzNhYmEyRFpzbDJFdHBo?=
 =?utf-8?B?cUs5WDJScFY5K1VDZk1GcmVsZHg2d1drRVJyZHJzMTVKR3NhdkhIeFNMQnBC?=
 =?utf-8?B?cXRVcmtZT1dqZE4waTJtamZtc1RnMTc0VDBnNjIyRTkycG9HZXcxZWVYOS9Z?=
 =?utf-8?B?VzJWSWpNNVE1TThGOVZZYnR3TitraDhrRFJRRVZJcTliY1YvdlVrNFBTSUZk?=
 =?utf-8?B?ZzNhUHZhVit3VW1VNnREdFp0SVhkcjV1MjM0RWdSdEtvbFluQitrdTB4LzBR?=
 =?utf-8?B?ZUtjaXlvTUhpeThmOVhiQlVyemR4Ymp1N091K0dycERiU0Q4Rk9TN29OdVJ4?=
 =?utf-8?B?NlhJSUZrYVRnbmZqZ3ZsOEhuVTdwL1JsU2JTbmRjOUIrb3d4S1lTd1cwc3lw?=
 =?utf-8?B?N05BMVBxQ3MwSlU4ejA3QTFTbFB0UWdZSUxzY01SdGpYZThsTlU2STIvK2FT?=
 =?utf-8?B?NHM4TTgrK2c5VGpGcTB6SkJHUDNiWjhKZVFXL2plVEhnUDQrRkRMeUhFMThC?=
 =?utf-8?B?Y3ltWXB2c2lUb1hqZnVjb0lkVlVpM1o4dER1TWRrRWxpVjVOajNXekxYUUt1?=
 =?utf-8?B?d3RHcU9oSkxVZEw1V21WWnpRcUZLYmRWL2RtTnUvS1FDNFBubXUvZW1YbXkz?=
 =?utf-8?B?NXk0RWdISitaTGVPdm1jandXeHJOaW05bHdhRkJPcHlURDJiN2hUSXNQWS9k?=
 =?utf-8?B?N01iZ1Nuc3ZteDNTem9VbHZac1QwM2VZQlZCRDAraTRMUmNJYXhEMmgvWFAr?=
 =?utf-8?B?WUJlZ3dzYmMvSlh2VTU0UlVZaWRQRFk5RXRyUklZaXN4N0dEQlNEQnNnZzNK?=
 =?utf-8?B?eXhTMUgzWDk4MFlYYVR4b1FjMHhreEdPU1VjZEs1QTFaK3ZmeFdLMHpGTWJW?=
 =?utf-8?B?bllWUFZ4R3RjclNoR0dmNlN2UDZxVUhWK2ZScnFad205djkyS2JTQ0JyL3Y4?=
 =?utf-8?B?dnlwUTAvc0h1Rlp0c0poNDdkbDFFQ09YbG83UlYvdDR1b3V5RE9PNzJnQ1N1?=
 =?utf-8?B?QUJnaVU4RHJLRHRZdXJwakswWW9PWFcwMmZUUGU4R2VyUXR2cUp2ekZnT2g3?=
 =?utf-8?B?V0Rwd2E0Q0pxbXVRVUhBTGVMdk4rc21ZbVNQS2tPNjVSNktoQUZNUW0yYlNV?=
 =?utf-8?B?MzJhbFhGR2lRQXZKM1J1aDRRNHNUQzhzaFBIenNwOFZBSzMxYTVFU0k5YU5y?=
 =?utf-8?B?T0loVGZlVk5VS1g2UGJWbmx1ZUF0b3JNcVhXcDBXKytLanhRZUdPWmZPejI4?=
 =?utf-8?Q?Gy9/q4vimDGi4jf2Xfml2kOD8jjR3mAKeC+PN?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3b3f875a-8cae-4075-e795-08dec8dcc8a2
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jun 2026 23:46:11.8701
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yrFE2g776aXuSPfyt16B0LfapsIvVhi1WVyNISnC7xu2Jpm4QpZvz14pr9gzgY3K
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB7619
X-Rspamd-Queue-Id: D6CEE1C000B
X-Stat-Signature: hen1d9fr1w5ch1iugs7cjyh8kwn7hiwa
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1781307977-863237
X-HE-Meta: U2FsdGVkX1+YAUPl9Xa+TFvKStpv2UUNSLZHxUUSLJZXU0rsMpz+TJSy7yqcYeX8Elhz3c4H3Ryr/Qc4L0VpEmonGPFfRdwAZg3si/87UPdLvj4uUKIxWMpVsBywqTMs6t0anTF1mSFWgT4MMm5Mam0nCn2E2fXq7ku4ISmM8DESnrB+CnSYdHcGSm35V7Qnip7VniWS3otIVF/ytA8LBwUcvvreTw9eDMFK4/7YlKmD+jdyAd5u9IwdpoQBmQ+IVNNN6TFVv+Gr16APbvrq/mbXbNVn/f/ToNOLIw7kf8B8u4auIpqB7YfyEZ55dtBXrpzZWc3kAsVd6k/1iO6OWgeUV9Y1doni+m1pn7ip6bzCTY5s4qb5u+L1qr3EYhsmQ1sduofnAivSkreji1IekDJL78Ldf4xV3ac7OmmYMmG7PrdmRePr/bm20cRD9H7oo3YSpKyuXbjxbTxNsGx2IMP1GAfc8BMBQY5QaLCec0w6SVSZy5PQq85z21RVDtyUQRtpwNPSzWdtw7K5+ALMqm+VDQOSTaeb24xkP/TinhY9XQ6xhiyqF43arDGWDAqGKQkdZafWTyWZ79oZdRz0gY1cCEq6SmFD+ILp6KRgwQ8qvdVW+CQEPrHCm4t/dNVSzB085qDm3OwByyu89z4+W8P0sx5VlUn1nd2MMzw1v51Uq3R8hPy8RCit0NblL0dbQZCFjyEO4h7goXr6yGS8TGEeo2JGzCAuvkACBjSHWwmAD9VITL+5rEQ+tVNiaJpMPe75kXeUHOTg2JVIUZxTsMtDyDtEGS31IAfxwU4QaREm3lTF7Nkycacok6vcM7kVMcwsxfEa9AXAaT7YGNt4bjbpJhCwvycm7N1n3onLs886nMPcqneBNSBHrEBp3t7Og08nUIzVRK8LFDJeDvgXwev5M+fwwqNTb+A5WmbHb8tepGZOL/ra0K0+2fOQG2KkF20ZC0qVdorp9sZ5gtW
 EJ1qs5HF
 UizvuzDEFg00usd6x1iKT7yhW1t3bxwxjaR8hsXiJDhFeu3jCMCCcgI8+ooN+rgZGyYOkOdeXnVWcUtE7E1TKWMNpqUWrGfUh8mzgjvs4g3+0uRXoNEISf8Ohu0DJHyfbStHZvb4CCLE0ZJxDl2Of//Wsrvpendy6r/B4bOlCr152fdHaw48NSR6YFbTfa4YCQa78FKJupv5z+9Yu4bYPFq5w/ckJEj1PVDMkOxn09iTIIVarYAUJsqRvmUJ8f15eMckvQQuBPULaucGPHO6CnmzkwgzC6QoYUrHZiA4lm0xG5e3XHiY316T/iFj2+m9Os5y/B3jtCkaDOGs5iPr8OoiH3d6816y+r50sKOt+TIn6ZKDrWBgN2EEd9ESLl5B3f9JrCbqGZY/UYWsxpyQMqWqq2szB1MV8jK6HNfbau96Xy6lnBfvwtVqyDKiQy8wNruptvcd20I3Ql/7GfeAC1zg4LWBzuaNk2AlfPvvKONqe9MAHnCKtA/YBfagMZwWB/Km5EwW+pBw07OD8gSbkb7m5p+c171rlZJMwnYUCDfpywf4YPrjPsDaOVW02pr/iEUBz1aH/Wpu2NKaD5KVKogDCqw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 12 Jun 2026, at 19:38, Zhaoyang Huang wrote:

> On Fri, Jun 12, 2026 at 10:12=E2=80=AFPM Zi Yan <ziy@nvidia.com> wrote:
>>
>> On 11 Jun 2026, at 22:34, zhaoyang.huang wrote:
>>
>>> From: Zhaoyang Huang <zhaoyang.huang@unisoc.com>
>>>
>>> The kernel panics are keeping to be reported especially when the f2fs
>>> partition get almost full. By investigation, we find that the reason is
>>> one f2fs page got freed to buddy without being deleted from LRU and the
>>> root cause is the race happened in [2] which is enrolled by this commit=
.
>>> We solve this issue by reverting a f2fs commit 9609dd704725 ("f2fs: rem=
ove
>>> non-uptodate folio from the page cache in move_data_block").
>>>
>>> There are 3 race processes in this scenario, please find below for thei=
r
>>> main activities. However, by further investigation over the code, I
>>> think there is a common race window for the truncated folios between
>>> split_folio_to_order and folio_isolate_lru, where the folios lost the
>>> refcount on page cache and remains the transient one of the split
>>> caller, under which the folio could enter free path and compete with th=
e
>>> isolation process. This commit would like to suggest to have the folios
>>> beyond EOF stay out of LRU.
>>>
>>> Split:
>>> split_folio_to_order() can split the big folio into individual pages an=
d
>>> put the resulting subpages back on the LRU.  For tail pages beyond EOF,
>>> split removes them from the page cache and drops their page-cache
>>> references.  A tail page can then remain on the LRU with PG_lru set whi=
le
>>> holding only the split caller's temporary reference.  When
>>> free_folio_and_swap_cache() drops that final reference, the page enters
>>> the final folio_put() release path.
>>>
>>> Truncate:
>>> The changed code in move_data_block() lets the GC path evict the tail-e=
nd
>>> folio from the page cache through folio_end_dropbehind().  Once
>>> folio_unmap_invalidate() removes the folio from mapping->i_pages, the
>>> page-cache references for all pages in the folio are dropped.  The foli=
o
>>> is then kept alive only by temporary external references, which allows =
a
>>> later split to operate on a folio whose subpages are no longer protecte=
d
>>> by page-cache references.
>>>
>>> Isolate:
>>> In parallel, folio_isolate_lru() can observe the same tail page with a
>>> non-zero refcount and PG_lru set.  It clears PG_lru before taking its o=
wn
>>> reference.  If this races with the final folio_put() from the split pat=
h,
>>> __folio_put() sees PG_lru already cleared and skips lruvec_del_folio().
>>> The page is then freed back to the allocator while its lru links are
>>> still present in the LRU list.  A later LRU operation on a neighboring
>>> page detects the stale link and reports list corruption.
>>>
>>> [1]
>>> [   22.486082] list_del corruption. next->prev should be fffffffec10e0a=
c8, but was dead000000000122. (next=3Dfffffffec10e0a88)
>>> [   22.486130] ------------[ cut here ]------------
>>> [   22.486134] kernel BUG at lib/list_debug.c:67!
>>> [   22.486141] Internal error: Oops - BUG: 00000000f2000800 [#1]  SMP
>>> [   22.488502] Tainted: [W]=3DWARN, [O]=3DOOT_MODULE
>>> [   22.488506] Hardware name: Spreadtrum UMS9230 1H10 SoC (DT)
>>> [   22.488511] pstate: 604000c5 (nZCv daIF +PAN -UAO -TCO -DIT -SSBS BT=
YPE=3D--)
>>> [   22.488517] pc : __list_del_entry_valid_or_report+0x14c/0x154
>>> [   22.488531] lr : __list_del_entry_valid_or_report+0x14c/0x154
>>> [   22.488539] sp : ffffffc08006b830
>>> [   22.488542] x29: ffffffc08006b868 x28: 0000000000003020 x27: 0000000=
000000000
>>> [   22.488553] x26: 0000000000000000 x25: 0000000000000004 x24: fffffff=
ec10e0ac0
>>> [   22.488564] x23: 00000000000000e8 x22: 0000000000000024 x21: dead000=
000000122
>>> [   22.488574] x20: fffffffec10e0a88 x19: fffffffec10e0ac8 x18: ffffffc=
080061060
>>> [   22.488585] x17: 20747562202c3863 x16: 6130653031636566 x15: 0000000=
000000058
>>> [   22.488595] x14: 0000000000000004 x13: ffffff80f91e0000 x12: 0000000=
000000003
>>> [   22.488605] x11: 0000000000000003 x10: 0000000000000001 x9 : ffe8572=
1f0e25f00
>>> [   22.488615] x8 : ffe85721f0e25f00 x7 : 0000000000000000 x6 : 6c65645=
f7473696c
>>> [   22.488625] x5 : ffffffed39b23026 x4 : 0000000000000000 x3 : 0000000=
000000010
>>> [   22.488636] x2 : 0000000000000000 x1 : 0000000000000000 x0 : 0000000=
00000006d
>>> [   22.488647] Call trace:
>>> [   22.488651]  __list_del_entry_valid_or_report+0x14c/0x154 (P)
>>> [   22.488661]  __folio_put+0x2bc/0x434
>>> [   22.488670]  folio_put+0x28/0x58
>>> [   22.488678]  do_garbage_collect+0x1a34/0x2584
>>> [   22.488689]  f2fs_gc+0x230/0x9b4
>>> [   22.488697]  f2fs_fallocate+0xb90/0xdf4
>>> [   22.488706]  vfs_fallocate+0x1b4/0x2bc
>>> [   22.488716]  __arm64_sys_fallocate+0x44/0x78
>>> [   22.488725]  invoke_syscall+0x58/0xe4
>>> [   22.488732]  do_el0_svc+0x48/0xdc
>>> [   22.488739]  el0_svc+0x3c/0x98
>>> [   22.488747]  el0t_64_sync_handler+0x20/0x130
>>> [   22.488754]  el0t_64_sync+0x1c4/0x1c8
>>>
>>> [2]
>>> *F: big folio before split
>>> *T: tail folio after split
>>> CPU0 (f2fs GC)              CPU1 (split_folio_to_order)          CPU2 (=
folio_isolate_lru)
>>> *F: pagecache refs =3D n
>>> *F: extra refs =3D split
>>> *F: PG_lru set, mapping !=3D NULL
>>>                             split_folio_to_order(F)
>>>                               folio_ref_freeze(F, 1)
>>>                               ...
>>>                               lru_add_split_folio(T)
>>>                                 list_add_tail(&T->lru, &F->lru)
>>>                                 folio_set_lru(T)
>>>                                 folio_unlock(T)
>>>                               /* T PageLRU set */
>>>
>>> *T: pagecache refs =3D 1
>>> *T: extra refs =3D GC + split
>>> *T: PG_lru set, mapping !=3D NULL
>>>
>>> move_data_block()
>>> folio =3D f2fs_grab_cache_folio(T)
>>
>> Getting T from f2fs_grab_cache_folio() via __filemap_get_folio() should
>> be impossible, since the xarray should either have the original folio F
>> or folios are not EOF. But it reminds me a bug I fixed recently.
> The folio be out of EOF is caused by the coming folio_end_dropbehind, rig=
ht?

To be specific, __filemap_get_folio() can only see:
1. the original folio before the split, because only the original folio
is present in the xarray as a multi-index entry;

2. after-split folios that are not EOF, because EOF folios are not added
to the xarray[1] for __filemap_get_folio() to get.

That is why I said getting EOF tail folios from __filemap_get_folio()
is impossible.

[1] https://elixir.bootlin.com/linux/v7.0.12/source/mm/huge_memory.c#L3884
>>
>> Does your v6.18 kernel have this commit[1], which fixes an xarray issue
>> in folio_split()? If not, can you give it a try and see if the issue
>> goes away?
> Yes, this patch is on the tree.
>>
>>
>> [1] https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/com=
mit/?h=3Dv6.18.35&id=3D08b2b65c63bb26dbb2a4e2adc2ce96e2929b8b60
>>
>>> ...
>>> __folio_set_dropbehind(T)
>>> folio_unlock(T)
>>> folio_end_dropbehind(T)
>>>   folio_unmap_invalidate(T)
>>>     __filemap_remove_folio(T)
>>>     folio_put_refs(T, 1)
>>> folio_put(T)
>>>
>>> *T: pagecache refs =3D 0
>>> *T: extra refs =3D split
>>> *T: PG_lru set, mapping =3D=3D NULL
>>>                             free_folio_and_swap_cache(T)
>>>                               folio_put_testzero(T)
>>>                                 /* refcount: 1 -> 0 */
>>>
>>> *T: pagecache refs =3D 0
>>> *T: extra refs =3D isolate
>>> *T: PG_lru set, mapping =3D=3D NULL
>>>                                                                   folio=
_isolate_lru(T)
>>>                                                                     fol=
io_test_clear_lru(T)
>>>                                 __folio_put(T)
>>>                                   __page_cache_release(T)
>>>                                     folio_test_lru(T) =3D=3D false
>>>                                     /* skip lruvec_del_folio(T) */
>>>                                   free_frozen_pages(T)
>>>                                                                   folio=
_get(T)
>>>                                                                   lruve=
c_del_folio(T)
>>> later:
>>>   list_del(adjacent->lru)
>>>     next =3D=3D &T->lru
>>>     next->prev =3D=3D LIST_POISON / PCP freelist
>>>     BUG
>>>
>>> Assisted-by: Cursor:claude-opus-4-8
>>> Signed-off-by: Zhaoyang Huang <zhaoyang.huang@unisoc.com>
>>> ---
>>> patchv2: update codes to eliminate bad page status
>>> ---
>>> ---
>>>  mm/huge_memory.c | 22 +++++++++++++++++++++-
>>>  1 file changed, 21 insertions(+), 1 deletion(-)
>>>
>>> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
>>> index 970e077019b7..c24c12f71157 100644
>>> --- a/mm/huge_memory.c
>>> +++ b/mm/huge_memory.c
>>> @@ -3878,6 +3878,23 @@ static unsigned int folio_cache_ref_count(const =
struct folio *folio)
>>>       return folio_nr_pages(folio);
>>>  }
>>>
>>> +static void clear_dropped_split_folio_lru_flags(struct folio *folio)
>>> +{
>>> +     /*
>>> +      * __split_folio_to_order() clones these LRU state bits from the
>>> +      * original folio.  A folio that is dropped instead of being adde=
d to
>>> +      * the LRU will not pass through lruvec_del_folio() and
>>> +      * __folio_clear_lru_flags(), so clear the cloned state before it=
 is
>>> +      * freed back to the page allocator.
>>> +      */
>>> +     set_mask_bits(&folio->flags.f,
>>> +                   (1UL << PG_referenced) | (1UL << PG_active) |
>>> +                           (1UL << PG_workingset) |
>>> +                           (1UL << PG_unevictable) | __PG_MLOCKED |
>>> +                           LRU_GEN_MASK | LRU_REFS_MASK,
>>> +                   0);
>>> +}
>>> +
>>>  static int __folio_freeze_and_split_unmapped(struct folio *folio, unsi=
gned int new_order,
>>>                                            struct page *split_at, struc=
t xa_state *xas,
>>>                                            struct address_space *mappin=
g, bool do_lru,
>>> @@ -3958,6 +3975,7 @@ static int __folio_freeze_and_split_unmapped(stru=
ct folio *folio, unsigned int n
>>>               for (new_folio =3D folio_next(folio); new_folio !=3D end_=
folio;
>>>                    new_folio =3D next) {
>>>                       unsigned long nr_pages =3D folio_nr_pages(new_fol=
io);
>>> +                     bool drop =3D mapping && new_folio->index >=3D en=
d;
>>>
>>>                       next =3D folio_next(new_folio);
>>>
>>> @@ -3966,7 +3984,9 @@ static int __folio_freeze_and_split_unmapped(stru=
ct folio *folio, unsigned int n
>>>                       folio_ref_unfreeze(new_folio,
>>>                                          folio_cache_ref_count(new_foli=
o) + 1);
>>>
>>> -                     if (do_lru)
>>> +                     if (drop)
>>> +                             clear_dropped_split_folio_lru_flags(new_f=
olio);
>>> +                     else if (do_lru)
>>>                               lru_add_split_folio(folio, new_folio, lru=
vec, list);
>>>
>>>                       /*
>>> --
>>> 2.25.1
>>
>>
>> Best Regards,
>> Yan, Zi


--
Best Regards,
Yan, Zi

