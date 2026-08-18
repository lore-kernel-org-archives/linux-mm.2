Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5855FC5DF74
	for <linux-mm@archiver.kernel.org>; Tue, 18 Aug 2026 03:05:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 429296B0136; Mon, 17 Aug 2026 23:05:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 403D06B0137; Mon, 17 Aug 2026 23:05:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2F22D6B0139; Mon, 17 Aug 2026 23:05:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 0111C6B0136
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 23:05:33 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 8CD911C1E87
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 03:05:33 +0000 (UTC)
X-FDA: 85112899746.06.E06AD5A
Received: from PH0PR06CU001.outbound.protection.outlook.com (mail-westus3azon11011046.outbound.protection.outlook.com [40.107.208.46])
	by imf10.hostedemail.com (Postfix) with ESMTP id 753AFC0003
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 03:05:30 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=YRhqIJra;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf10.hostedemail.com: domain of ziy@nvidia.com designates 40.107.208.46 as permitted sender) smtp.mailfrom=ziy@nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787022330;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QCoxR5yIPT2U452UB+MOFIbJAtI3HJ9BVBY9Zxy2sGk=;
	b=vwtvTx7tkfiE4S5dmIH8+dXAzEkFLtQGRlWGX5GacgFDh+gvSavUpt45PeahuBu8Zx5MDi
	3RDxSRXCpsJDB6q8Ru9MwdAk7zWa+8qO01zK9hS6rdmM+3O/W6wREjqHff/XCIMMW3c3Js
	Dm1gQOIZmlhjBS1VZvmXvMbaiIArrRw=
ARC-Authentication-Results: i=2;
	imf10.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=YRhqIJra;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf10.hostedemail.com: domain of ziy@nvidia.com designates 40.107.208.46 as permitted sender) smtp.mailfrom=ziy@nvidia.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1787022330;
	b=6jBjqjWfRPvVXufSvy7/3JxscoMUPEVlfv77mLqxoFg2J8ZSqQfrNQ/y04CGukMQbszc5S
	eyEC21mkWSCA4Zidd7ZX/NDA8aHTUCKvcrgarKu+8VCPkLjjsT+826u0D/csoRHOw5u1Rl
	PkllLAumzZpj5/2UmULrO0k57BLvSu8=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=J+F6TokjOsugay/Xq+27NCL2a4XJFRARyQhv26KWD7YYnTnFGG+764edcXsMY9omfNzLjiKuYqIxxZJ9xDE0CjjeHairbKj4Ld4/sC/zR+Tm4Q5DeYRqktz9zbjzUVDNWJKfliwlsoW9ZhE0XT64E31Ai3+DTos7gEgBfS1KRiXPPTUoKxb9wL+9b1Hj+/4iGWfe5t6IPdsvw0RTDMJ59lZSgEe0y1b3sRsEW2KFT5AZAlGmaKfpOYo7nLWwZ9kvArEGNXlLE6TtRCQVJqIi5lIUUgQ6wOeUwt/oWz5vIiDwoyGkAEgj6zcTWYh+ag6TW5U0y3jrgjod7bcIPgdbRg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QCoxR5yIPT2U452UB+MOFIbJAtI3HJ9BVBY9Zxy2sGk=;
 b=HXVc+Ip2Wmzf4CKYuhwh0FzRVKulyHH97hVjUAzTKzA+oQ84C2tanm6lQGcn2UFeyPXVywTh8Wf7+p/ZwBq/SdYC+xa0pfotqyOfyF9JN89fyJWM4Yg6OKmCuZNa6PcOfyxoY5fR2cxakgI2e0V8fZPieN6UUDZCp8RPtZPiqyIaIHtBdetUOhuUCiVTB5WBOs77qnhc3ycqVqDERiBeA464EjXqvBgzxbThWrCWxnmlzag2ZGphX5aas1/B0KmaVirUETfWfAKA+ku1aF79QWVqiBmnbmUxiHrPMjdlm95bCBMsHsQM5XV//bhXQ4Qlp9gjkIYTnHJf9pHEadvinQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QCoxR5yIPT2U452UB+MOFIbJAtI3HJ9BVBY9Zxy2sGk=;
 b=YRhqIJrarHmvbeIqW62DAQxpcA2Sx7RdR3tJiBvxaH1h2T+nqoDlatia/GC+76WeSLkyJRKSk7JHpRzk86k+IMPR4pEv3juZ3MA83Npd+iDBZPXrE+Y6T+WlXDhEY7UGilZ2Tp78Sb/uNLX8moK+fsSGjf6rUclq0w0jtKwQBs2yfDVQWfSkf69q2JTcdMEBCMclkA3FzJYJKU1Ah49XA+ph80fYRLdJLO5FzfV0siLnvnooqI8+dPsGLVcWBNrwZ3zCG4HG3emPRUxxYHt9dC2JiblHV2YXr8VhN31u8gE6hnH3CN8jhtSeaFUcD3QrL4z7KrPqtIyIvv+3v2wwlw==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by DM6PR12MB4337.namprd12.prod.outlook.com (2603:10b6:5:2a9::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.315.13; Tue, 18 Aug
 2026 03:05:24 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%5]) with mapi id 15.21.0315.016; Tue, 18 Aug 2026
 03:05:24 +0000
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Mon, 17 Aug 2026 23:05:21 -0400
Message-Id: <DKRQJL624IEN.3NV6JO13ZUTPB@nvidia.com>
Subject: Re: [PATCH v2] mm: fix incorrect vm_flags usage when checking
 allowable orders for tmpfs
Cc: <vbabka@kernel.org>, <annh@google.com>, <liam@infradead.org>,
 <nico.pache@linux.dev>, <dev.jain@arm.com>, <ryan.roberts@arm.com>,
 <baohua@kernel.org>, <lance.yang@linux.dev>, <usama.arif@linux.dev>,
 <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>
To: "Baolin Wang" <baolin.wang@linux.alibaba.com>,
 <akpm@linux-foundation.org>, <david@kernel.org>, <ljs@kernel.org>,
 <hughd@google.com>
From: "Zi Yan" <ziy@nvidia.com>
X-Mailer: aerc 0.21.0
References: <7d5b5eb27be798f89d563b06254c947ff53db0b2.1787020910.git.baolin.wang@linux.alibaba.com>
In-Reply-To: <7d5b5eb27be798f89d563b06254c947ff53db0b2.1787020910.git.baolin.wang@linux.alibaba.com>
X-ClientProxiedBy: CY8PR10CA0011.namprd10.prod.outlook.com
 (2603:10b6:930:4f::12) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|DM6PR12MB4337:EE_
X-MS-Office365-Filtering-Correlation-Id: 8f6528cf-c505-4c84-de03-08defcd58c4c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|23010399003|7416014|366016|376014|22082099003|18002099003|56012099006|6133799003|5023799004|11063799006|10067099003;
X-Microsoft-Antispam-Message-Info:
	2V2eUTP95ePsYFZMuNe/VkZ1S080VTFs9OZmeTQHod9pto+CVOH7fKBw4vn3/EcDr1fyha9ZG0O60pc7aZU9IPdr+hR4kFssPCoiQ1OJ7L3FizvVfE/0mXf75peaugHSnimK5JX05BMJdo6BceAsxlFTXY4Qw4ZdBASsm/fC1J/8sSVlRcTCoEaKruaH17z16X7gv4qu1LjVoaA15HozhPmNPKPRcl+nOETGvpt7LjGdB++4VkHD2WjGPac55N0o9ylQC2FVXrAOwmsvC9BEDcYYuKLGLF+WgccgAET8FPZhsfvezRaXhGXPtx/do/phgM8MpQDtU9IdRzL0T77QTxil3JS73ewiM5BRUb/HiX+O2JQVQwwOkWskxx/1EP2nAf8D2iL8Hq9POtPkKUd8rPHhwcF98RTdkkEPdfijc0pFM8K9+lLQVY/AJHDpr5eXqXoxdaiO/sDTTHoMy0UWlV3v9LSXEhM/8NRL7Q2tBLpquyivhm6St92KOyy2En11X+HfAnQVJDEDKQIL/+rub+UcrtEz1AF3ex43uh3kGzpT/YPp9hMJlPdZdl8o/1Qj7hoXsFr34OE5LS3RJ2Vp4//6PGy6qPmAwLlT5HQ3JfrB8Q6YjAExzrjuLOEC6dDXHlXVqAGHDyh0pTtH0Wcr0iVqbwabsZnkGVoGQNPfKgg=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(23010399003)(7416014)(366016)(376014)(22082099003)(18002099003)(56012099006)(6133799003)(5023799004)(11063799006)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?Qmk0U0lXZUQ0NkdIV1ZNS05uRW1NbFBKakNpRkF0T2MzQk84NEFQNG9VNHI1?=
 =?utf-8?B?dWh6OGsxZ05BSTBwbW0yZldwSjN2TGJXL0toWHJHaWNKRW5JVmljSkFTVjdp?=
 =?utf-8?B?TzNjM2VzbU5GY3F2RFZFUldlaHZkclpLalVTTzV0Z3AraDV1dE9EeFYzVTBB?=
 =?utf-8?B?R01WdUZxNUFTK1RESzAwalV3bTl2dHdZUUJPVDVCdlAxbG5xbEhaaVQxdW1C?=
 =?utf-8?B?VktPWm5mT2s4YjdoZjFTazBoQms4U0JHR1BwRkQxNGlDTk1Zb09zMWoraFpx?=
 =?utf-8?B?V1laSGZEbnd2MzBFaDBvamM5YUNBaWdxNjZ2d3k2bFpHMmRoeFJyS01rVEFj?=
 =?utf-8?B?SkJkb1ZqZ3MwcHc4NXRHczVXV0I2b090NHcvWXljeGVVR0EvNzhqVkVxWFh0?=
 =?utf-8?B?V25ialk4VUJDVytheTFGUEc2Nkh4aHppUktsMHVuSnNGVmVMVEpYRVM3V0xt?=
 =?utf-8?B?UmNrQUpIV2dTZllJTU9TV0NkclRscldqOWxTcFFwbHVDY0kvMVVKaE5VYjNm?=
 =?utf-8?B?c1FQalJRMHFLT2ZLWHV6TUdFVHBKMmJzVFhtS3d0cnFHSGVrV2hLVThOMU5l?=
 =?utf-8?B?Tkw1WjU4Y2dDV2IrSXd1SFBka2VUSER0bWI2eGQwRlR4SkNzN1dsRWlPcjQw?=
 =?utf-8?B?TU9PSnNJWFBBbW5NZjh6UjNzWCtzQ0VlTnlLMGJkbE1KTXhnWEN0S0pLTGFk?=
 =?utf-8?B?Z3d5UlhlWmJ1a3N2aWExT2tpcXEwRnI4SFBVUlRRMnFIODVGK3k3WXpZcmlp?=
 =?utf-8?B?djFVZjM2Y1p5NnpyQTJ5NVpiZ044cWlmaGFHL2Z0QldHRkhnU3FRY1BPR0hB?=
 =?utf-8?B?ajBNYUoveTVzY2tDTjJjcy9rODRuRHRPYVl0YlZKek01SHpRZ1oyZGhnSC9U?=
 =?utf-8?B?czFrN05waEJ4WHhwUldRWjV5S3RDekdqaUJZMUI2d25TUW52ZGZQM25JMEJk?=
 =?utf-8?B?ZUdXb3BmR2l3RUxjZVFTRVhCd1lyVlZpRDQ2MzdRQk1OT2picklpcFhicEFm?=
 =?utf-8?B?MWhSYUhZbDhlKzlMQ3EzSTNEZ0ZRSFZweXpvbE5uRWl4YVcyc2dqQU15OXo0?=
 =?utf-8?B?bVpBUk9BQzJLTm9KaUEwODF1VTIwc3BNd25KNDZMWVBLZWVYWHlNSEN6aGsv?=
 =?utf-8?B?ZVhkYVZQRFRJYkV2aEEwRnFaVURtZ1EvMTh2dkYzaEtWSkFRbzdNZldwL1hJ?=
 =?utf-8?B?Z2h4WXV1MXowU0dEVzA3Qk1vWGNQL3YxQXY2UStETGZLWE1sWW1NejQ3Z2tE?=
 =?utf-8?B?VWNCbVRrUEYwTG5RNytTcDRkM00wZlJvNlVwY1RvbjNiUGEzU3NORFRqM002?=
 =?utf-8?B?bWRVa1lTcE1HYlMvdDh3WUpqREZxb1NpOFJPOTZRcUlDRnN1dkFLMHdWWXBZ?=
 =?utf-8?B?eWtMRDBTQ1VhWGcrOTVlRTd5NlB0WTR6NHN1Z2pyR0tRK0tnOU95UFlnNUFl?=
 =?utf-8?B?TkQzK2szaTQxcE9ZVXRjL25wTU1aU2wvUW9oTkhiNnQ5RWJNZ1JPTWZsWjdi?=
 =?utf-8?B?SDBRZjRFajZkMFA3bE1PN1FPWm13YUgrREpmVHRVMDlCOG5wMSt2VWNVSXJu?=
 =?utf-8?B?RnRTaWZsejU3RWxldWFRdk1SSXNEbjAza1lXYitoTXNSNlFrcVo1TVF6L09I?=
 =?utf-8?B?RG95cC9mWnhtYnd1MUtFSlNCKzNjRUVQaXd5L282OG1UYWFRVmZydVJZTE5s?=
 =?utf-8?B?UWpQaXIrN1U2WTA0MXQ1UW1Ca0p2UWI5SkhDeEJXdVE4ZTgxNmlBeEJCOEdO?=
 =?utf-8?B?cndYNjNrRGhQaUJ3KzNFZllxOURHR1pWMG1KalpGelo2a3l0czJ2TjQ2UmhC?=
 =?utf-8?B?bEtZdUVaV1NBV0ZTWEU1UWtvaXZ5Q3c4ZEJPWHhaNXBSbEI3cFRRYU1FWG9t?=
 =?utf-8?B?cXcrblUveTZ4MlNxYy9rL0prY21aR2JQQkdDcEYrMFRxTG1xRU02N2pCbUF3?=
 =?utf-8?B?a2RtUS8yY2hGMVZHbGtlL2tuOFBaRDdvdnd6SkhxQTRjbVpGK1Z4UGJwTFBu?=
 =?utf-8?B?V2FPNmM3SVk4M0E0WWJFa0s4VU9kdFdDM1RyZ3dWRllJOXdVQlZuanlWVEJT?=
 =?utf-8?B?ZVhqZkw5UjhtWEJKa1RsZ3pqMTYzaFdiNEsweG5TTnFmQzJ2b3VRdVhpM3Rv?=
 =?utf-8?B?ZkpQUE9iV2Y5YVBjSXZSVzE0aFZxbmd2OTlpN292K0E0RGFxVkJKTUJhOWVM?=
 =?utf-8?B?SlV6ZmQ3SHhZcG1HdUJGVTBGYjFybjA0TWZNU0UxZWQ5UDZlcGVDWWNJRkM2?=
 =?utf-8?B?dzd4bEtvdzVqYzBNb1lhWDNPb0w0a2pGZ3ZmVTFqczJyeU8yMmhKL3NNeEJ1?=
 =?utf-8?Q?dnawPDEsOZEN9CpUc7?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8f6528cf-c505-4c84-de03-08defcd58c4c
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Aug 2026 03:05:24.6542
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: q1KpU4TqHTmtDk6A6uYPFGIiXahOLNHvWcqFneHcTuoEBnk/Hczp9SK8PGa+LCxE
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4337
X-Rspam-User: 
X-Rspamd-Queue-Id: 753AFC0003
X-Rspamd-Server: rspam07
X-Stat-Signature: wxn7fw6fdfh7eg5gpz4h1mmfufyre857
X-HE-Tag: 1787022330-769263
X-HE-Meta: U2FsdGVkX19lc0kQj136xqK0u/JlFGdvQ5lLPd3JDuCCbd1fGESx4/VR6pePMZ5/Qa12YrAVIvspkWZvAiuCa0xyBzskQd+0pcVk7VSQMgODQWyho/pCNsmM8fAZoRiPj3Jc4LuU629mxemqqKMRWZHNwDhBWWO8yXAU1KmxbgCDVaVU5IYtO7c+RBiVyZOazmaOwqnpGH9aTxrtv9oD0v8wPeRCEkqp0JSxfzcg8MLTNoXy2ozgYWIA5fOoUpsWrE4PTD3E6ItOLQVaJ31Rw+vPtKaOuWYCRYB4uWKVJuxjW4MZ/0Cu+Vya1lb+3TTxDeZ2axdBuTLCSPMTjUAloy78rN+yahUuUEZXBOr7iR8STSifDLM85/jMtp2WZZm0wN9N/BR6s+hRf4Tj4+V+FAuIaijaO6VuxKZAFu6EMfJOhq6yG8oogEjK1cz9GTnD6bG0vVwDM0O9qLAUzxgGgVbnTM77Bi7/M3IRrqL3EFF17fcMlP5yqZ4lP4JYBJnTLaFEHQ3syWPLbUnseBsB+GbEvWj2AiRWEOOBBguhxXJiIewtwuZcKNcVIhWjfcvqEcNRW+NrrvQlBiG9cD/6f3/Sgb9Wub05g+QuThCjBTHOuQlJb/89PNo8tPJRhBCHWhaKa5IiuyVyaY11hJHNzyREi3Wd++rT5E8n8SIAwDIfwEV6KE+3cDQsGT6v5iHqbmkQtnSW7PHNDPkpUFNEDYuehg0fBICvpWeg2vV+C3PwZzHCyGHklD9ng0ZTU2MWYgJ4/XgclqR4f87xS8k4lZEFxJ7vzD54Ar/04x304xddWKvi88w9qpzcghfddbICEgLKauC2aOL5vo6RsTgx3OHsaLlAgUkeY01NdpsVy1euzf7iOvW156s6hbpThVAg5tavtKZaE0/gXFoXseu/u6iCSOtATjbveE5I6X7RGeTPNVP65QsfdreL1i14rVma69wZa50wokYPSPQ33Q5
 TMjncbxF
 tDKYjlAEoyj1iL4v5KQvFeClbCNx3DilWQk6oXKT6HTW1WhQ/kf5dleaxVnAuC3+p8CMBV5C2MEY7mrjWmKtWVa5eeGHk5HFTJ6/dUCdkFWAV2rUiRkH1kEuY3Yu3Am7D/Cf3fRKZtHaLvL5r3hhmFwmdFTEv6l7fEHKGf86q/WCbPVSvTk/yBoiGNocSGQlKetMzMBY0p4D22cDWvDvIADV4ejHe6a4mX3oqLc6gNTffMTtSegJEW3+XqI4Xt4rGP2ub+Rs3flfxh3xZ0O+m2sv1Ywc7/y9Wi9mMyb5Fp3j7xo7oWmFxb13r38rSaNRDZxOh29kI9nQ33G+byb4+XAGMt05A7E7TOZMmFr5zPZ1p9BgZFa0xJbxN1ETefqZJUY5KZjjj8kLsxZMVO/PRnkV1270pVIvvgxGuBKVxM/cMugk+ZYhEN6tTbLqTC9FumK72KhLcALaMyAr85JamBDOPitUqFI3Xdhl4IXO7Smni0FQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon Aug 17, 2026 at 10:47 PM EDT, Baolin Wang wrote:
> Lance reported that when nothing else causes the mm to be considered for
> khugepaged collapse, an MADV_HUGEPAGE-advised tmpfs VMA alone does not tr=
igger
> scanning.
>
> After commit 6beeab870e70 ("mm: shmem: move shmem_huge_global_enabled() i=
nto
> shmem_allowable_huge_orders()"), the shmem/tmpfs allowable order check re=
ads
> vma->flags directly.  However, when MADV_HUGEPAGE is handled,
> khugepaged_enter_vma() is called before the VMA's flags have been updated=
,
> so the check uses stale flags and incorrectly rejects the VMA for collaps=
e.
> As a result, khugepaged does not collapse the tmpfs file into PMD order i=
n time.
>
> Fix this by calling khugepaged_enter_vma() with the new VMA flags in
> madvise_update_vma(). Meanwhile we can remove the khugepaged_enter_vma()
> in hugepage_madvise().
>
> Reported-by: Lance Yang <lance.yang@linux.dev>
> Closes: https://lore.kernel.org/all/20260815181632.21453-1-lance.yang@lin=
ux.dev/
> Fixes: 6beeab870e70 ("mm: shmem: move shmem_huge_global_enabled() into sh=
mem_allowable_huge_orders()")
> Cc: stable@vger.kernel.org
> Suggested-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
> ---
> Changes from v1:
> v1: https://lore.kernel.org/all/ed34ca03ae7d65e89467fb87bc961f5497049c00.=
1786948410.git.baolin.wang@linux.alibaba.com/
>  - Update the commit message (per Lorenzo).
>  - Call khugepaged_enter_vma() in madvise_update_vma() (per Lorenzo).
> ---
>  mm/khugepaged.c | 6 ------
>  mm/madvise.c    | 8 ++++++++
>  2 files changed, 8 insertions(+), 6 deletions(-)
>
> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> index 5a06e3942e88..79effd3f3da4 100644
> --- a/mm/khugepaged.c
> +++ b/mm/khugepaged.c
> @@ -454,12 +454,6 @@ int hugepage_madvise(struct vm_area_struct *vma,
>  	case MADV_HUGEPAGE:
>  		*vm_flags &=3D ~VM_NOHUGEPAGE;
>  		*vm_flags |=3D VM_HUGEPAGE;
> -		/*
> -		 * If the vma become good for khugepaged to scan,
> -		 * register it here without waiting a page fault that
> -		 * may not happen any time soon.
> -		 */
> -		khugepaged_enter_vma(vma, *vm_flags);
>  		break;
>  	case MADV_NOHUGEPAGE:
>  		*vm_flags &=3D ~VM_HUGEPAGE;
> diff --git a/mm/madvise.c b/mm/madvise.c
> index c179938097bf..cb93cf82d8df 100644
> --- a/mm/madvise.c
> +++ b/mm/madvise.c
> @@ -178,6 +178,14 @@ static int madvise_update_vma(vm_flags_t new_flags,
>  	/* vm_flags is protected by the mmap_lock held in write mode. */
>  	vma_start_write(vma);
>  	vma->flags =3D new_vma_flags;
> +	/*
> +	 * If the vma become good for khugepaged to scan,
> +	 * register it here without waiting a page fault that
> +	 * may not happen any time soon.
> +	 */
> +	if (vma_flags_test(&new_vma_flags, VMA_HUGEPAGE_BIT))
> +		khugepaged_enter_vma(vma, vma_flags_to_legacy(new_vma_flags));

LGTM.

Reviewed-by: Zi Yan <ziy@nvidia.com>

--=20
Best Regards,
Yan, Zi


