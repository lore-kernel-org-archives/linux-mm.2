Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 43164CC6B3A
	for <linux-mm@archiver.kernel.org>; Thu, 15 Oct 2026 16:17:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3F01F6B008C; Thu, 15 Oct 2026 12:17:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3C7AA6B009B; Thu, 15 Oct 2026 12:17:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2B74E6B00A6; Thu, 15 Oct 2026 12:17:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 07D416B008C
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 12:16:59 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 89E31A88FB
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 16:16:59 +0000 (UTC)
X-FDA: 85325364558.10.2A580CA
Received: from BYAPR05CU005.outbound.protection.outlook.com (mail-westusazon11010040.outbound.protection.outlook.com [52.101.85.40])
	by imf31.hostedemail.com (Postfix) with ESMTP id 9428620005
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 16:16:56 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=dPBYtxYa;
	spf=pass (imf31.hostedemail.com: domain of noren@nvidia.com designates 52.101.85.40 as permitted sender) smtp.mailfrom=noren@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1792081016;
	b=kV1Dob/fyfa9dW5gInYGmdXmjSykGoIqYkL6bZevQQQnEvrqDzAlggJqIiffXJsaToHs3v
	JDx64cG0TTOvLqR+dXCqNiq6mPdzwnL1fJHIexxAzaN2IL5KlmVzEVBAF3eBHvCB7ozu/l
	kYku5DG3Y2gzr/CtcTc9fB0I2taR5wo=
ARC-Authentication-Results: i=2;
	imf31.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=dPBYtxYa;
	spf=pass (imf31.hostedemail.com: domain of noren@nvidia.com designates 52.101.85.40 as permitted sender) smtp.mailfrom=noren@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792081016;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=K3Cv6fGJH6C2oyCtrbYwZiDSqVG8tvi8cbhrQxFM4Jk=;
	b=mtfvumpRcFZ73h55bLiIFxa/osR4mlRXc6aqWooQZbXst5CvZOAO5NzJNGtHpw2oiQQBOw
	evTNfdsgi8g8OA8sSwSTcpg7MYGKfe2p22s7j3gqm7h0piE2DK5PmfXc6RoIJG1mIcItf7
	i5zGdogRJ3zEAXfm/M/7LkOha85U6TQ=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=DLQqJwKVOyVe+r+ApbdgL3uwDK8sS+eY8tqRJNSpskuJJAuzAnkmDvdaWiY295LlTuva1tOCsm1v5oMnAkdFWl8jqg/d8rReeTF/itloks2AFEQVuJLg54fUXSWlQk7J9ReWNOyrg+ASRL3oNgcLRkTbI6Fs6u8XHdY9x4RFAsuU2qD/i1Z9iku1V0WTUPBzXxmEAF7OJm/LgmiO6WV6GWjt3XQyvCVpniopeskFE45LvhTqQW3px67ai7VMuy3aRZDtzCdqK/5oxZq2INc9ft/4p6qHy1Yw9SodRy8prxJ7oMncDMTT6nJJbzp8mQycI4thUhFDzSuWGl4g3JG5hw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=K3Cv6fGJH6C2oyCtrbYwZiDSqVG8tvi8cbhrQxFM4Jk=;
 b=vdxqgyRnt3P7jmM2X7H1IPx7aEQnvN2snYbaE8q2fgQk+VBAhSqtgiM/II5dgI+cIHJbQ67Zsy+gLtkN+4Kx8W/xQStsBwRhEdYFX7CwLRPPdixTTU4gTsqWpCI8mAsVY1vGp06LUPtWEYFQLyb7VWgyU7Zf9hNygIu5a/FG1YUZvXdWL+Wts2+/P7zdHBPp3n5XVv3OJAD89M4fjepL8J/8/Tlapm3NhJ+ofPD49bZ4acsXd/WN/CJsFMtao/ulal1ICzB+e0UQQULCUfbhQNVm870PMgekvCbtd2YPsSo+eHYwonVZtMelNjhtUBOP/aZoYdTLrCy7RdrH4Vnl8A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=K3Cv6fGJH6C2oyCtrbYwZiDSqVG8tvi8cbhrQxFM4Jk=;
 b=dPBYtxYa6VYmezjMsKXzrxjiZloMv4eTLFxQrtKiG8+TgxiXo1OrmSJeF6ew5xbFS5JVN8WBVXIFVKfUybHPKub/zLd8ZQRv7FQpKZ6KSEB+bQREokfzJpTxlLCtBYssk5Wcg6PY4zqTBm8oQj550ri4yZDYXBLo7RkpanYhZqN9Pa/q0vEbEnXrqtVMVJpGjjklL7TpRhKNQlEVlFcNyFKo3WNwYbne0p7Ghb2z9i5LEaDT1yZCqsMrx9P1Od49KdGbVF/Nt8+jQMeFbLyzbNNlkYGE9icazc8nvoAdLWXeH1ArvPq4bkzrpaiUdfqBLId3IpX/jWHPRUHRVG57MA==
Received: from MW4PR12MB6802.namprd12.prod.outlook.com (2603:10b6:303:20f::19)
 by DS4PR12MB9681.namprd12.prod.outlook.com (2603:10b6:8:281::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.522.13; Thu, 15 Oct
 2026 16:16:49 +0000
Received: from MW4PR12MB6802.namprd12.prod.outlook.com
 ([fe80::51f4:a3d9:b44e:9587]) by MW4PR12MB6802.namprd12.prod.outlook.com
 ([fe80::51f4:a3d9:b44e:9587%4]) with mapi id 15.21.0522.012; Thu, 15 Oct 2026
 16:16:49 +0000
Message-ID: <26103c38-7b22-4176-8bc3-63e4b8fc6bbb@nvidia.com>
Date: Thu, 15 Oct 2026 19:16:40 +0300
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm: stop recalculating min_free_kbytes once set by
 userspace
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Jonathan Corbet <corbet@lwn.net>,
 Shuah Khan <skhan@linuxfoundation.org>, Randy Dunlap
 <rdunlap@infradead.org>, Zi Yan <ziy@nvidia.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
 Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>,
 Kiryl Shutsemau <kas@kernel.org>, Brendan Jackman
 <brendan.jackman@linux.dev>, Johannes Weiner <hannes@cmpxchg.org>,
 David Laight <david.laight.linux@gmail.com>, linux-mm@kvack.org,
 linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20261014140859.1006967-1-noren@nvidia.com>
 <20261014144823.8c89da26c547fa95936a2fe5@linux-foundation.org>
Content-Language: en-US
From: Nimrod Oren <noren@nvidia.com>
In-Reply-To: <20261014144823.8c89da26c547fa95936a2fe5@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MR1P264CA0035.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:501:2f::22) To MW4PR12MB6802.namprd12.prod.outlook.com
 (2603:10b6:303:20f::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MW4PR12MB6802:EE_|DS4PR12MB9681:EE_
X-MS-Office365-Filtering-Correlation-Id: 382cadd2-8808-4c69-b472-08df2ad7b6c6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|366016|376014|1800799024|23010399003|56012099006|4143699003|11063799006|261009223027099003|10067099003|18002099003|22082099003|6133799003;
X-Microsoft-Antispam-Message-Info:
	lbYbm+7HMKbjUvPIETxkCYOFReqfmX1Slx/Veod4b80ax6tCMhzu2LBhDQWCJ8z6oYdxQ3PrCb2A0sqJvZG8Tg6BSnn/QIWbe3N5ovW3VIWsLwz7C0UFoVecKqrP6fovpliz0adn/ZP0rU/CI0hNJTyADhRl4lymZ7e29XuxCMFtZf9M6B+xsUvcHwI/pa0aVA1mFbfXOTs2pdpCGwy7nbTAFKWMKCVOpCN+lFtUiL7xULRm6OrwCRJ5UqDt/vfDzxnUKVOzvEGwhuhm1KtVGACJtKwoEyPLcbeLADlMqSMWX8aBgSrrJILPrmuoKXixennFgkWC+zE8bzGMtW+XO6eUNaGOP6x0wYTBiD1FYBwZS6DvXf4s+NAiuVcYHiOu4scfTz3dkwwInRhWK/05lCw1GtX8jJ+w3x2DO3jZMU5PAK0Mlw3yC/RPUMeuepMXQxHJ9gGvrQtH2s3m+lOgjC2XHdg0W4smWid43ULJgndlBU4aIuq4NkHLMVDnzAVy7thLlQEa5Ma8BxzGOKLQPLEqAw/Gl4tMw/5VPx3fDLap5WbAmbyPgzfPYZs5TupCAecKDHYZb/VSxK6sqHU0BZ9efwQ+RktIyaMgFjPJvxopsa/X+J1zAz7Z9qzdTA1wJVYWFQC8DpHGiQLqmBH1GcMSvYZv9nn6oa9eV8DkRdY=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW4PR12MB6802.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(366016)(376014)(1800799024)(23010399003)(56012099006)(4143699003)(11063799006)(261009223027099003)(10067099003)(18002099003)(22082099003)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?TGJsNkpTdU1pZElieU9TVzVqY3MzWitWdlhabWdnc2JSZlZqMmZuUVpXVXF5?=
 =?utf-8?B?QnNuZHVmVy8wNExYZ1Bnc0FjcjBkVmk1QkZJS3dMZ3ArdW5IVmlHdHFreFJO?=
 =?utf-8?B?VmxlT25pQ2RGVG1SeWF1V1h2SHVZTU5HMEQrVExkN0VXd0JFNTZOUWhVYW1U?=
 =?utf-8?B?c0ZDNDkreUEzTFJKSW9ZVmpLVDNMVmxSZEQ3RGdCajF1MHFOcmM3VVAxZTdx?=
 =?utf-8?B?RTlwS1lyeWpTbVhPU0JyNzFwanJERTI1aGN2bjVkMUllMk5OK2pwTTlSUG5O?=
 =?utf-8?B?Mkt3NFRXZnJxUlVSUWhFVElwdGR5emRtQUY4aVVpQjJSYURsVXBidWdzUEJh?=
 =?utf-8?B?T01OTGFXOUNqR1hqVE1tb2JNTkEyMlFDK3Z1QW0wTzJmV3lOMXJZVWlhcUdQ?=
 =?utf-8?B?VDhzSDlCdUFpemtmOTRJcWdndmRoWFkyN3RLUGJJaGFEUEFWLy82eThueGUv?=
 =?utf-8?B?czNDQm9vbkU2S0ZZalE1bzl6SlRZYnFXMTlEeDBDNnN5U1M2enE1V3JRc2Ro?=
 =?utf-8?B?bjczYlA5UHBHYWNqOFYyVjhlQXVLUnJzQTM4ZjJ6Y3N0bjFGa2JRblRzdnJP?=
 =?utf-8?B?Z3RnU3l2R2VuVDdnWUR3TzBUUEVVTFFjT05pMTFRYm5NdVpqcFN0YmdOaUVa?=
 =?utf-8?B?RnA4ekJPbXB3Y2pXb2tVTUthOVdPTy8vMEpwVGtMekVpVnRaOTIzZEFCNjlG?=
 =?utf-8?B?ZGNYZU5aU3hYejJGOTZiTGxRRUJzRkVKU1VFSi9DbDk1U3NYeWY4bE1xaXRR?=
 =?utf-8?B?Z3dnTE5IM21KN2Z3NStlbVM3eWFvaHQ2aFRGcUtOMFpZcTN5UmlIcjRTNyt5?=
 =?utf-8?B?QTNCeWxaT1oyTjF6a1JGV2Z3NWZpcUt4ZlI5L2pQcEpZWEEyb0xoOXlXL2RP?=
 =?utf-8?B?Q0J1YVhxWkVlUjJnL0FITU0xeHlQYzJ5MC9CUXc1WEJEUUlYdHBCREVnMjNz?=
 =?utf-8?B?TVBiNm1leDA4S0JlQnZ0eVNoa3hiNWxubFR0N0liOUlZeVVxVS9SdWQxSW85?=
 =?utf-8?B?emw0bFkzamRCNmZDTmh1RVBXWFI3Q2RWbFYvTTExRVJPNzcyRFJDVVVzVnZh?=
 =?utf-8?B?eStJT3dzZkFHc09YdlRQM0tpbGlTUkY0RTFtQXVRQWp5U251Z1FFaDNPYkhH?=
 =?utf-8?B?UlNqOE45eWRkeWlMdm11V0IzWG5VVWd2NXlCQ1ZrZ0lWeUJTVmNOYjlMVUhC?=
 =?utf-8?B?dXgrMjRrbUVSMkhidTY4SlZ6YldOSnpRdlFTc05Cd28zUkJRa1NvQkkzVG4r?=
 =?utf-8?B?WUtmNnVtV3k4c08rK3l0Y2N1dlh2V2ZjUG9mT2NHUE9EU09NUklRd08rYVpM?=
 =?utf-8?B?ODNOVjhlYm5LaVRTdGNScmlveHJxemhNWTRLUmVHdWlnbnhOcU5kZTJrVVJt?=
 =?utf-8?B?Z0Jib1lHMFNldC9yOGtsLytNSzdDSGxaeDRqTGJWQnFQK1NONEtQSkNhQ3l5?=
 =?utf-8?B?L2ZQMG9Jd0UwVi8wNEI4akYyTUpZcHdGRExPaHpBK3VNZzRMNXM5eWRKK3pu?=
 =?utf-8?B?L1pZYXVHeHlTRlhvdG1aQ0NTNWR5WGpOUGI5MnVMS3FZc3dNaTg3T1lvQ2Y1?=
 =?utf-8?B?bkdoTE9wbmcxYmVLNEVDb1RqNzZReERsMGw3VG14MnN3Z210RTJnRGV1VFdR?=
 =?utf-8?B?VGVDMWZXWG9sL0J2eDJyU0YrRjhneGE1Mi8xdVYxWHR5RzhUZ0ViTFB3aGp4?=
 =?utf-8?B?YWlUOUR2bmZNMkMxSEVudjFzMnhWUWgvZm5DZURXek41YUlQYUlBWFY0SlFl?=
 =?utf-8?B?aW4zZ01XRXZHK1ZoeUtMTXh0TXoySUZPN295ZTh4VXRJZmtzYUs2YkFpdXZo?=
 =?utf-8?B?L2ZiZUVGYW1xMzg4TEdMcHRYeVRHV1YyQWVjRTZDME9EZUJVQlhodS9WZ2Zr?=
 =?utf-8?B?eWxqQ1FNSFVnaGVsSW9mRmdJcXJFVnkvd2hEQzZEd2VsRm1Rc2lEWTZiVnB1?=
 =?utf-8?B?LzNBMmxPd0x3bDhIRG8xS0tVbGxsUjJCcWxUYXZYQW5YanlvdnJlc3hKYmtT?=
 =?utf-8?B?OThRRGRVaFhPaTVFS08xMnE5YktsR1ZRTU9HWDYzVUZYVFZqVENRYkpncmEy?=
 =?utf-8?B?VFdjQ1c5M21MZHpya1NqZ0l5cElHa01VeHp5b2UvWThKYjBSN2h6b0dZYkJF?=
 =?utf-8?B?cy9xdkFvckFXa3pUM0FZMEV5UjFBMWUvZVpEbnhLNFQyYWxTbkFMSlBlY1N0?=
 =?utf-8?B?anVLSE01WThFVThlbGpMUmhJcUlrenNMWjU4dzVCQ2lqakhZTDQ3bHhhRXcw?=
 =?utf-8?B?ZGNXd2hDTkl4b0RpVFQ5RnZEcXlHWkk4QkxBd3pXZHlyVGxPVlo0cCt2VzV4?=
 =?utf-8?Q?mFoIcE6Cd9z5VPEB3V?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 382cadd2-8808-4c69-b472-08df2ad7b6c6
X-MS-Exchange-CrossTenant-AuthSource: MW4PR12MB6802.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Oct 2026 16:16:48.7872
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: b6gPbgzDWd6W/x+rBhjpHUDpF/7nOqfDE9PhgykMWCM93vyVCBX+sNkDKyfd5fpZYk+LMvMaBGQ6H2oFivFnqA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS4PR12MB9681
X-Stat-Signature: 9sipxgfjhyw4awj99bzek4gas3p9g9t3
X-Rspamd-Queue-Id: 9428620005
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1792081016-624424
X-HE-Meta: U2FsdGVkX19Xb7BL1HFABbEElr5xG4NoaLs0MfNzzzLQzctJu0jsJcsRPitxlxuTk0hd9cCMnd+3Fo/aIgaCQFpC+SoLJ2HBSEOCQL0eRdbNlkQCs3vMfyQszXiZWbPtZ7nMMEgzkhYlOiaE2gpJRwy8JAljgVQfCDVHA0TXl2y1Rx2Sk0+9TUShY0iOgcSYbv3N1jnKwszjkqC+ZTp/amn36l5SVe0Wjb+SzHpeSVNlehx2sgPqsjvtD67kzlUlSlhZOZGW6fElAHcFLHlL1Olkj73l6Q+Do7ZJS3MynPWDuiT52DkTiUIIGL4Jgj0oGb2X7P5u+SZ59P0A9HVHGJsHJb68tazLRxwjaT9o1bn/2yaZmmZbkCQZxRs3XjDHAFPBn97pmOY+j77LkSh90jgnBHGDAr78xeSStJh6DnqW0LNaXrHHTvHimivJ+SHdGCHL6uMyZtHIGn6njqa4U3wI7rjteFvq9wApmpWEDEgEQFkt6nssl7/kMeXXc2cEIvS0iRv7VrQnCOvSTfktnjb2VTBPqCU+hmnZbMYuiaGhi2fQBU13u2iwLhFcLUMpcmifHYxq/81u/W8Y6fdqvzu2TOJxvdqkHhq6DplnW3BlY9X700i+fnrfgBYTGuKbKObBRbyhHBqGvmGUAi2hLI5CkERkU16bYUktqsEE+KZD7LP67l+KVD6YTNT5Ie8wIpgE9oUZtTEBkTHPZlLpVdVnIuIz76wGg4Pk2IwQraHgz6UyyYio2tvf4qhsP1IHxodZacJ5MKMZw8DiR26h+UrK/v+mHMygNPDchJayxu+1C+Y8jkpBFk3PzkBlzKrJ61Haw+/wRYseIWBPSSGVaTvyewCSaSb5svclVufaS7G7T4BUBfuKIdya/RcUEAQah9gC+fGDYMnn+VSlib3oNhG7I9c/O5g1Mx/RtaiguuI1fvLksGdlyk2Bk2gIfOD+LgR9MNf9x1NJWP6Rkcj
 3s3v6C1f
 xNILT41xZBRLBKtv+pj/EnCcZr5dC172WeCHjIJ3OX+ImEyxM0seBPVZgABAgE+Psp3L18Fm2OuDQdY8Xiz7F4m7rZyA598UBVNod6VSJ1KTBimL8As+rHH46LY9z0LdotCtxwquEPhQUCDlAq0VrWcBszWVton6xXkitzOGk0Yo+Wgf7semhGGKHybvyP3+zx1pN2Rr5rBQK8EMDuu+1CMaHgIq/GWheeyYwZwzHS4jhNBIWDKZxMuSbdjZ/e5bRgcRKjhUvsCQiM49Sgx8L3tj4oUl6sxhhPLamdEzqzu6QtcEQCePKICQIWf9HCr5WqmRuPU1pJIPenD32Sawuta5qxewBgSZ/3oBEF4Hyt4oyZieic2xdWwQE0+oQhGhOZ7bo3CnALZL8AWc+KgA9mZasnA1Bg112fjdHLCD1lHTG9UH2ie+rPVF0o0z4k+feFlQIwwO0Qa2982mZxMbuiW9qHN2SdX2xOThvWELOLmbJNZDXWTMNmNmxxQdVcgbcpMskoYVxRqkhDlylKGdjEBakHCkzB7D6YB/gVGzumvNQiyub4MDLHJrVNA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 15/10/2026 0:48, Andrew Morton wrote:
> On Wed, 14 Oct 2026 17:08:59 +0300 Nimrod Oren <noren@nvidia.com> wrote:
> 
>> min_free_kbytes is recalculated on memory hotplug and on THP sysfs
>> writes. The new value comes from calculate_min_free_kbytes() or, while
>> THP is enabled, from set_recommended_min_free_kbytes(). A value written
>> to the vm.min_free_kbytes sysctl is replaced whenever the new value is
>> higher, so a lower value does not stick. This matters most when THP is
>> enabled on configurations with large pageblocks, where the new value
>> can be excessive [1].
>>
>> Stop recalculating min_free_kbytes once a value has been written to the
>> sysctl. Systems where the sysctl is never written keep the current
>> behavior.
> 
> This problem lies somewhere in the range of "minor annoyance" to
> "catastrophically horrible", but it isn't clear where in that range it
> falls.
> 
> So can we please can we have a paragraph which explains the real-world
> userspace-visible runtime effects of this problem?

Sure. Can we add the following after the first paragraph?

  For example, with default arm64 pageblock sizes, the THP
  recommendation can reach 5.5 GiB per eligible zone with 64 KiB
  pages vs 22 MiB with 4 KiB pages. This keeps a significant amount
  of memory free, reducing what applications can use and triggering
  reclaim much earlier. Users can lower vm.min_free_kbytes to avoid
  this, but the lower value only sticks until the next recalculation.

Thanks


