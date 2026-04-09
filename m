Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 42CF2F364AF
	for <linux-mm@archiver.kernel.org>; Thu,  9 Apr 2026 20:10:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9ABCE6B0005; Thu,  9 Apr 2026 16:10:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9836C6B0089; Thu,  9 Apr 2026 16:10:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 89A476B008A; Thu,  9 Apr 2026 16:10:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 7D6976B0005
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 16:10:31 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 17BFB139861
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 20:10:31 +0000 (UTC)
X-FDA: 84640109862.24.769C6B5
Received: from SN4PR0501CU005.outbound.protection.outlook.com (mail-southcentralusazon11011047.outbound.protection.outlook.com [40.93.194.47])
	by imf20.hostedemail.com (Postfix) with ESMTP id 4147E1C0008
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 20:10:28 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=sYnqP4at;
	spf=pass (imf20.hostedemail.com: domain of ziy@nvidia.com designates 40.93.194.47 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775765428;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TvYOlE6beCM0sBQ9h1R01NfbU4GGHKYjn7Rb5QwOHMo=;
	b=PiyecsxYiu+Ty+RdYfe4I0UNLBwX8e8jWHFraPLLhgI/vxDmohHHCnhhPT5+6L2vLkOvpH
	dEGzrt2o6qP/lfO2yR82IU55q+511A6ti1lgt4/hB0tMjnnhyS9YHQRvaIk+KrLR6bEFSs
	9LLOUtGLvDkvUC6hFP7cyesZz1ynJ50=
ARC-Authentication-Results: i=2;
	imf20.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=sYnqP4at;
	spf=pass (imf20.hostedemail.com: domain of ziy@nvidia.com designates 40.93.194.47 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1775765428; a=rsa-sha256;
	cv=pass;
	b=monHcJOpi7nyxA9EIhw62KlOyxJ0oRhFEX9yAcx1Pjm/O8biLi+kHIhOuBJKvp9BjC0zLA
	ofkOlwzJe6FoIPBhkZUqeYHBcO2Oik2umaOrXF2biVXUP7Txel4RqMR1NPScbyFpJOl1/H
	+TUoW2Pr3xSZZcslj9EdSpPxgJ0frNI=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=lM0p/cycgxTPj4WBLHo6+/yy1UDXjtw6oROHoxt067Xm1il2oAFCOfoMUMr2eutH3AFYGfDNbjUSZ0t0wv0dxT/A4mL71noT6Sq5SqJLmvoneg4hwt+yM2tT+dMLNoxuJ6oHDMmaoot+a2GILOOPl89/s0Jzsb3A+tQvEWetpF8x4uLasMWG03XcTMSqes7AhnpvcByz5aCkB6XPAAA6Su6c0aJeAJpVSzbD56Zf+KSztjIQk+c37BD/ea2y91l+tzBpWLtl2Co8U65rMPpTs9E2Tu4owI3L5n5xmLEohmazMzydT+xsnbVhhRuj0uZMbVG+OxF9RxAkuUwTDAJu5Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TvYOlE6beCM0sBQ9h1R01NfbU4GGHKYjn7Rb5QwOHMo=;
 b=sEA6KW4hntwXVRDv/rc0uMwAXy+Q5n67RzT0u1NyYhoRnbypSm/Hd/65X0Scb6nW+XAcgX431slJ7exkmTeXt39cWgJSlcsjtk+zvJeoYDH1OVd0I5/PiLZgAb7TDxaHN1qWZ1NpEmgqh4jsZk31fZht3/qpTGDSg3s0zwUUzAN7MJHt2uEOFfgBJNs6Ry0Um852TuEoA3nfSo3LfDTBIzp7sA43etQm/Yur7JQV8JiEsNMT9MfFEToLnXyIDlzFW2SlkNRFyDTIzub79Y2wnYlX6j83praVGFkHXKRt3JBopr3gqnogsRBz4YsFXczGeKmNmWIFT1oh+EjGhecpNA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TvYOlE6beCM0sBQ9h1R01NfbU4GGHKYjn7Rb5QwOHMo=;
 b=sYnqP4ataJwE+RLRrhvDTHfAdPW3T2Xc0mwruT2LTrPWl/llGYXhsB5pfvZgI1hXAbSRo/PrCVG/uVWSs+xQRFmyCIQb+ekRV9hc6Xas3gO7lNBXeMBIW/S+/2h4jt0/Nrb62EvqJRUmqpC/EYvgg1GP3cqWc3dJtjzQbK/h3B6frQjRgTB0FnPIWR9T3EaBNmsYxUrIDrfwnKeTpzq3frUWGsxdKJDZNKaDJEapcimyJYR0XiufGUkqIzxexbxZI3hOZZyyofQl7SWU69anGIDty5hkVMjD6aoi7dijubiBz70RWzcTDD8TD/it0qYTpPQl6oD78L8ncFKb8yO79w==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 DM4PR12MB5962.namprd12.prod.outlook.com (2603:10b6:8:69::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9769.42; Thu, 9 Apr 2026 20:10:18 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2%4]) with mapi id 15.20.9769.014; Thu, 9 Apr 2026
 20:10:18 +0000
From: Zi Yan <ziy@nvidia.com>
To: Luiz Capitulino <luizcap@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, david@kernel.org,
 baolin.wang@linux.alibaba.com, ryan.roberts@arm.com,
 akpm@linux-foundation.org, lorenzo.stoakes@oracle.com
Subject: Re: [PATCH v3 09/10] mm: thp: always enable mTHP support
Date: Thu, 09 Apr 2026 16:10:16 -0400
X-Mailer: MailMate (2.0r6290)
Message-ID: <3B2D36D9-4B04-4548-ABA0-AE5DAF66B2EF@nvidia.com>
In-Reply-To: <7830cda5-b3df-4da1-805b-278d5af6b2b1@redhat.com>
References: <cover.1775679721.git.luizcap@redhat.com>
 <6dea717fe8c86003e7da33c9a7623b834649d5ee.1775679721.git.luizcap@redhat.com>
 <772C4431-FA93-4477-B1CE-3BE5EA97FD0B@nvidia.com>
 <7830cda5-b3df-4da1-805b-278d5af6b2b1@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: MN0PR02CA0004.namprd02.prod.outlook.com
 (2603:10b6:208:530::11) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|DM4PR12MB5962:EE_
X-MS-Office365-Filtering-Correlation-Id: 09e5dcc7-2962-4751-cd6f-08de9674053f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|366016|1800799024|18002099003|22082099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	8W86x36ILKxvjZuQ1ZIz7RXm88AmfGnhPUaEJ7qfXVpxnbVzgN2w3CQTDEVwxNp7BEvdwVNn3foSXoI3OUIBbZyEOctuxoUMytwkbfpe8Bv59BM0Ib+7Je7Iw9ogpV6kUNK7dSA0F2xQxayqMA7EQFq2G4lGmFy2WSKLoa1jer5+yXL+4jP1c0frvcwDqLGtNn2ATEVQO++kQdMTyd7HLUm1H82Dr7JHPv+ST4jsIehsGzp/KPzFeNCYizgJ+omysuUhN/rgYRTyvZsfCOuu6QDC8S7IYAOWA+MYFp4Eg8heywV/wmzXvUL2zVijTZm9xMZt+xcmxHr+3vfWVzIka5n77r3dRUnLgWpD2vvFSgZCVIca/NgDoDCrFHvyYlYLkQNnXRhtdmoD08uUBmdF5aDrJBVBuS4NRJNdtLOcCT6XhOVucjsc3kMvwKWflIjBgoMLxW5Krv/FuzV5HZwHDG6MiRX6fCPlwj6vDGZ3iJvEBfCLwKq3mC+OM9dn5TdpMQ4tgS80R/agFFq2yPjlgvuvhl1Wcr8/ZEcMw2TsMHxKsHQPl2J+wsUiVi1bzei08NsGXsQDQK26x0U7XZ3T2QpHVM+uCRcpvSID1qc54WHsEYm8f/GqJHbwDC6g8XRXdNK8uYpIa/EARNaixgTo+AHuL/FN2eWrOlUxsgffkN5YvVNa5OOhszstYszSOhy94lNnOW0GTgC0xF/tV38aIR9QNXyUROJUB7Kvn3sSHoc=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(18002099003)(22082099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?bHNROVVPV0dXMC9hcitRQTd3L1RIcXQ5dmNSS0tYR0s0SEJDbEVXQVNPSXlX?=
 =?utf-8?B?SG1CMndKajZMTElpdW9OQ1hoeXU4Q2szSnhZVjAwcjI5bHhDYTB2UWptS0ZN?=
 =?utf-8?B?ZksxK21yRktla2Vrbm9nZmxuNHVxZGcweWVFcjd5dUtHcG55dU1XdGJxUmU5?=
 =?utf-8?B?NW52YlQ2VzIxeEhlWXhQR2dSbysxYi9ub3dzdWZ5QllFZUtPdHAyWUo5VFNM?=
 =?utf-8?B?dUpVMVJTRkxYZzNmWEZQaHliYTI1QjNla0dER0VPMFRENDRUaHBJMklBRDlK?=
 =?utf-8?B?L016NmkwTGpFTi8reVo5Z2pkSk5oQmFBZGVBMmZXeEdROFRnaDlrVkhLVU14?=
 =?utf-8?B?QVBCVmgxWUJqRTdvaDJxZkdPQVZyWnFlbnZyYmFRRUc1UUowNERveVRLQWNM?=
 =?utf-8?B?cEx3ZEZkVHdaUWhsWlJESG5QRUVSRGtDaFlieWxYK3ViVUF4Y0MyT24renZl?=
 =?utf-8?B?UUZqdkNLUDIyWFZsL0ZEUkN4TzVZMFFFVEVoSTJ3Ukgwb1l3UXJuODdQVzky?=
 =?utf-8?B?RXAvdTJnNGh3L0NmN2NNMUM4Zzkvc3U5a29XKzFXSjdwK3FqN1ZXblVzTHRu?=
 =?utf-8?B?UTBqVTMvWThnc2s4T3NuUzc4STFqMTk3V0oxWUMyR2dIQ1doejVXSDNhWWpT?=
 =?utf-8?B?a09EbklvdTZXM21OaXVabThjZWYrZmVmRU83UFRmaFpZeXFDR05TNHEwaHpG?=
 =?utf-8?B?NGc5T2FmODlUcGU3eG9uTEMycmF6c2hxY0Z4MU4wSWQ2a3FQRW5GRWFLM3oz?=
 =?utf-8?B?Y0pXdkgyZnFrNldNaTZFcUVWZ1FYKy9YRFh1U21wc2R6amF1L2JvOTlCU2k4?=
 =?utf-8?B?S29lL0ZUd3E1L2xUam5iOEJyODBPUGtTOFhqWEdIdEcvZU0yQUQ3bnFPR0ta?=
 =?utf-8?B?WGU5b3VFbitKSHd1TVI2SjhyVjN1dWxITkFoTVBOUkZScTc1UEd5bkl3RlNs?=
 =?utf-8?B?WTZGYkRzMzBpelBoZ2NMVGJGTnZDdUVtMGlBUitEekJtTWFjVDdRMEZKQ210?=
 =?utf-8?B?bVlUcnE4dVRSWi95Y1Riazc1ampaS2c0QVJra3p1MWVCVWwrMm0xdHFYSi9n?=
 =?utf-8?B?VlFPcGtNeXZINUJwbS92OGgvQVRMMFQyWGpFc2JPeURPWWNmUUE0UUpSUWdK?=
 =?utf-8?B?c2ZONG9RT0UwOEQ4QXlKbWdSQUdRdDhYcDNxN3B6bHUrTzlsTWZJVXpXVFFQ?=
 =?utf-8?B?K3Nyd2x1SWJFVlFHMHpVQ24vb1ozNTZzeEcra1BXRlBWbEhBYmhUTFJJaFJj?=
 =?utf-8?B?T0ZFK0JoUlNoaDFNNDkzVHhTR1huZnhzekc5VmRSZkljNnh1YkNuQTg5ajEx?=
 =?utf-8?B?anFyYWI3MDB2Z2JWVVlVMjIyWWFaUEFlekdwZWErVXk0Yk4xQ2NmZkdaRlRh?=
 =?utf-8?B?Zy94cC8wMytaOTN3NmRPMCsyaGsxdnB1d1hJNWdrcmJMRE5OWEhWN1VqOENs?=
 =?utf-8?B?Z2V0U285UzVtWEpJdXVWWlZPZFEzVkdwVXZ0dVdKc2JJZ3ZnQm9NWnZzYlJP?=
 =?utf-8?B?NlY1cjg0UWxTd0lZZHNQbnZleFQ5WEtkZ3BvNEx1Y3FxdUhCOVNJYUxxc3l6?=
 =?utf-8?B?VVBudTMzUk1XenJiMXlCTUhrZ3k5dG9lSEp6VzlUTzZkYVVlcVRReC81ZnRQ?=
 =?utf-8?B?ZWl4MURqTk9VVnlSUVZURktnTmVNU3h4TzNTWWFGSTdoNFMzQXpxVGlZSjFh?=
 =?utf-8?B?OS94cnV3TEVVSkxMNW5IWXVVcU5rTzVlSVVVY2FkUE5uSWRScWhtNU9yMkxu?=
 =?utf-8?B?UWVoRTVrZ2J1eXUzNU1QcFZwS2Jmc3h1eFZneVY1L0I4WGcyU0hjOXVhZ001?=
 =?utf-8?B?MG9jalVXRjZtT1BJUHVET3c2eXBUSkNIR0NoVHVZS2x1d3J5OGxLZktZeEV5?=
 =?utf-8?B?akx6WTU4bTRJRkRNUW02a0dvZmcyRTNaNGpCSTV0Z0QyQ210Tzg2eGpnQ1FM?=
 =?utf-8?B?U0RsRTlqSEhkTlZkR2NQdHc1RmZLazd5UmJUb3NmOGdzclBYeWFTcW55aUVh?=
 =?utf-8?B?TFh6M1VhUTNidEF0dmptc1llUGdoR3o0TVpuTjlOU2xsQ28zTFZrejNYSEky?=
 =?utf-8?B?ejc3UDFUZjdUNWZjTDRrekh3VW52b3ZNZSs3dCsxOGJtM0RBWklYcStzZmly?=
 =?utf-8?B?SllJQmEzUlZrN3N2RzFLOGh1b3F0TmlOYlcreGxkSTJXeTQxQW0wMGVHbWtl?=
 =?utf-8?B?R0RxYjFMbVlLdHc5ZjI5OTdjOFRCT0xFMGExamltSFlQOGpHTEJ0cWlZTGhU?=
 =?utf-8?B?djV2UGJUd3ZXdWhOeHJld2ZYMGw2RFU1V2RwK2dvU1d0bUwvb2t5WGowbDNk?=
 =?utf-8?B?akNoMDdJTEYwUk90UGZsWDM0S1RUZVVWZGI3bWRabjR3eE9UdGhZdz09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 09e5dcc7-2962-4751-cd6f-08de9674053f
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Apr 2026 20:10:18.3230
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: T+2TkHKD0T2BZr9bRdxX1Uc++h6fe2VCGe38P7gQW8VoXedkzj7Za3N2Q4U9IIS3
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5962
X-Rspamd-Queue-Id: 4147E1C0008
X-Stat-Signature: ykai5m3k8e7qc7ez8s8pn7bgptcos861
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1775765428-432215
X-HE-Meta: U2FsdGVkX1/J9lNYiETLD2CnYvOCxCMZNZxi41f1TwKlNBr4/98MaAU8FcXCDyzs7pR0jba4an4VcgVvlUIxob2RkKA5EQJMgz5CbcI6+iX6eDejJvyS/nJz1S2xLiTeKEVCgXB6OuZSB3/qKzU1xgLTSKXwigcq+4iTJwFYRUXHkfnxeLAuziqwg1RRit/F/mEqZLLdBRWj4gwZwKJE3jxSSsCGDz3JCrPSubv5CLphmmaQKUh9hL+vI7jlcNP9CqJIMrJLpCak3NdlFAOOn0ZIEZv04U2DKplZ0R7jgxykEICmd1XmpyO8ukfsmLzpbaEAUgnuCX1kefOk0/xdxDl9CFSfSoeB9y9KhPMn8fLocP+weh5Gjj134C3st+w/uEr7/C8/JlmArZ3aaTYIt1iKCiQq3RdzMYi7k2z3uHA6pmExm5DZzpoyiwCpvZvCp/A8DI2a5iDcSZXw4WbVDuD0bqpzWU70KFMV3AWTLkY0RmZvHh9N7Ze3X1ENLx+fUZBQeFyF1gf+0HTjOKNZyvch8KAuWP4uC1ue0bk+KpFQ43GjRgvWj3QUMRPpkku2JDSZh6W7baoN4rKaDW12GUM2ywLrKHtSUw4rtLhwFUzFEI6x4dYaOUy3rd0dpGq9wa3qFfiwbnBJzhjmVXIIk4SnYzOySD9Fi4yL1Rr4Ho1ttSCvI10TJhokl92Js10NeStUTVIpWLeG73GJ6lcoUkdsFGPFret0r48taStHCS4kNpUVxt8YPlvXGEbFGnPbNBrvqOmO3T4KCwnb+7BBQMQpeT5A8YU+diez//M3KDiuRHup9sZsCEG3qITdCl2bMPqKLlYhLJh58xcaIExhlFZglE79meaQDqOxiuB3yuf2I90tJQ3pzKKyN8Rai9F3a+6wm7lNZ5zAZfinIUba6xsJmEbUTR8Kj8IJwIrP/RvoeimYMjbcpvrSMWX5Jc7gu0W/uKeyq86lFapI/++
 a800CgzP
 ZEJyKTDit8Offoo+KWoUPTNj1j4ABVcEYH6pOngU5JqirBLJPjy4eFuqfYe9g1xCG4qRhv39a6NXQSH5tr++oz4Gdb+xlRSfeG/f6fQWwSESxRXT3L2wupaqsRPU3bmYCgfK5BFBPulzDOnful0HJOLB228/nx6yZA3buECu0qHjxs/Rv8lwV4ns9UbzNCSKrWZ/LDsoyfr1f850neexyfUqL5ikfnC7WgiMtm5RgrDnnR9h/GAKs0vNoss0iqZ129h6c4Jqxc0T/gMLGcSh2g78yLrFQ2jfedMpu1jLersSTMvQQrD9ZlcQKHMm3IUGGGgMxLHttpYVjQzVHVFDKJE76enXVKvraLKpKG/825zjs5Rl6pxi2GI9JfFiomDZPeF7UNI6Q8DdG6sxzg+G9rSnORz4idSII2xQ8
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9 Apr 2026, at 16:07, Luiz Capitulino wrote:

> On 2026-04-09 11:55, Zi Yan wrote:
>> On 8 Apr 2026, at 16:23, Luiz Capitulino wrote:
>>
>>> If PMD-sized pages are not supported on an architecture (ie. the
>>> arch implements arch_has_pmd_leaves() and it returns false) then the
>>> current code disables all THP, including mTHP.
>>>
>>> This commit fixes this by allowing mTHP to be always enabled for all
>>> archs. When PMD-sized pages are not supported, its sysfs entry won't be
>>> created and their mapping will be disallowed at page-fault time.
>>>
>>> Similarly, this commit implements the following changes for shmem:
>>>
>>>   - In shmem_allowable_huge_orders(): drop the pgtable_has_pmd_leaves()
>>>     check so that mTHP sizes are considered
>>>   - In shmem_alloc_and_add_folio(): don't consider PMD and PUD orders
>>>     when PMD-sized pages are not supported by the CPU
>>>
>>> Signed-off-by: Luiz Capitulino <luizcap@redhat.com>
>>> ---
>>>   mm/huge_memory.c | 13 ++++++++-----
>>>   mm/shmem.c       |  4 +++-
>>>   2 files changed, 11 insertions(+), 6 deletions(-)
>>>
>>> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
>>> index 86e489c0a150..6de3d8ebc35c 100644
>>> --- a/mm/huge_memory.c
>>> +++ b/mm/huge_memory.c
>>> @@ -118,6 +118,9 @@ unsigned long __thp_vma_allowable_orders(struct vm_=
area_struct *vma,
>>>   	else
>>>   		supported_orders =3D THP_ORDERS_ALL_FILE_DEFAULT;
>>>
>>> +	if (!pgtable_has_pmd_leaves())
>>> +		supported_orders &=3D ~(BIT(PMD_ORDER) | BIT(PUD_ORDER));
>>
>> Why is BIT(PUD_ORDER) also removed? I thought PMD THP support and PUD TH=
P support
>> are separate. Here the code implies PUD THP relies on PMD THP. Is that t=
he case?
>
> This was a suggestion from David to an earlier version:
>
> https://lore.kernel.org/linux-mm/dac20466-adac-4e47-8f50-87f4774fd57b@ker=
nel.org/
>
> My understanding was that if an arch doesn't support PMD pages then it
> probably doesn't support PUD pages either.

Got it. Can you add a comment on =E2=80=9CNo PMD leaves -> No PUD leaves=E2=
=80=9D for
pgtable_has_pmd_leaves(), so that no one would ask the same question again?

Thanks.

Best Regards,
Yan, Zi

