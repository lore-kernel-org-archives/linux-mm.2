Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 06282D7878A
	for <linux-mm@archiver.kernel.org>; Fri, 19 Dec 2025 15:20:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5945A6B008A; Fri, 19 Dec 2025 10:20:42 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 53AD76B008C; Fri, 19 Dec 2025 10:20:42 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 41C866B0095; Fri, 19 Dec 2025 10:20:42 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 2E5476B008A
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 10:20:42 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id D2D0E160295
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 15:20:41 +0000 (UTC)
X-FDA: 84236582682.17.35BA95B
Received: from BN1PR04CU002.outbound.protection.outlook.com (mail-eastus2azon11010002.outbound.protection.outlook.com [52.101.56.2])
	by imf15.hostedemail.com (Postfix) with ESMTP id 23BADA000F
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 15:20:38 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=KVQ+0vQn;
	spf=pass (imf15.hostedemail.com: domain of jgg@nvidia.com designates 52.101.56.2 as permitted sender) smtp.mailfrom=jgg@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1766157639; a=rsa-sha256;
	cv=pass;
	b=uwr11/iCqjeGgzFvc0dUtAvBMfHTAG0kHSJGGwBx8n2PVK+kyS4a81H0n6OtGZmdLJuBk0
	NQk15DT/0mki0ajBCmCvZmmQqKfmy5bsEI1NTAGacADr/NkLdBNTo2p++3Hu/nNzVbl70a
	NaGP642GpAmF4zcGetYKCc1KTY3P/jo=
ARC-Authentication-Results: i=2;
	imf15.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=KVQ+0vQn;
	spf=pass (imf15.hostedemail.com: domain of jgg@nvidia.com designates 52.101.56.2 as permitted sender) smtp.mailfrom=jgg@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766157639;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Zsv+mFwFoBwD47lNnWVfcZOkjNHauuhV7+U+BvwizIo=;
	b=JUSO547j5275KmB4+yiO+p6TuhFnKEWbgvsC3bQ9mNvm0YghL/X0OySm2Qc2qEzspqEGQr
	joKWZvDEwUtT5OoMlVsHqKZmFYChkApr+QZ0IBsYPulGqzS7CsQ+2PrTYAdlOpZ9NXXhDj
	w7fGNIfwntGhUciic+YkJ/iHA5tU+30=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=W39w2zzqE5+CIXuFVBr0GxtICwzszxHDD09MvbdZdskLuSG7eUK17+3J3AQUXze1RGFx5C3gOQ0JycX55KB9UEf4feVhT7TobqUBw2IalVAWu3THgJUdblyGpa1a1EqHZJ3B0cDYSibBJIb1dgLoCWhxLvEPEjXN2mtCM/xXnaY+io816wsIhD7xBLrWjXtbfpUCM/GX2jVOkiVx7GR0pIieRwaQpWHowe1gJ1N8IYJHbbtKPLWgxfZmZmKcPzD0rL++Psfcp2PX6HVjdsS9FuyDN6TPB+z3y7kSRh4C1OQOWNQEkFLkXZ/UpNeV9CLvmawSESK/+98Or0x3GOsdVg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Zsv+mFwFoBwD47lNnWVfcZOkjNHauuhV7+U+BvwizIo=;
 b=SWTDnmAbN8avu54cozm8lAMq8wKS1YcaqmZq5ZWPi29GZzXmqMqBiKO5RANfzTIk0054aZA3pBAuIzd7ffZ1LRWg3EWrfY3YWsCkSCK/RdSHFzKJJiQKMcGNHmpqSEDpngiR982tiirjQQq8oqIIlfFnyMCGTGv4L3j4EOFgiLinr0h9d3DGjix4qEpQgngwjSnKlksTOh20CUZB8G4imQupdnu295EJKiezjGvlOAtSlsGIo2YyZFYjxR+qAaRwv3zh0EpTWVHVGyu21l+HAw2O+kfnlujsMryvNot98bVwkcqD4O4ftRLywMMwiWfZThS5TYND7lxtvoIcK402AA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Zsv+mFwFoBwD47lNnWVfcZOkjNHauuhV7+U+BvwizIo=;
 b=KVQ+0vQng697LINGvC4/qWdfSkFWcswKVyesgwhrLiyhRkqO9EsKKqQvcEeav+DbR3O4m8hxLueCvC2hfKACGRtOmhj5q/aHTGGDHD7y5Gk9gS4b0IftLPhKRvSvj0Nbf6tlgO8EVfR6+w/dGyvnkG1yFi+Fox43ml8ek2CB/K1fQnB6DbQ8G1RxwC6fqc8DFAYruU4qrunJB+eWh5SwwNbtPEQJA90ac6KkZLmfLi0l07hXnpPSZOOEP6dK62S4mnbrWlORzwixmojT+MdwTgjXkbcxXlDNIrKz5CX+hiFlo2mg1PvQkdxXW14qyOVr81RNaa/JB3CqRB9DBTJ06w==
Received: from LV8PR12MB9620.namprd12.prod.outlook.com (2603:10b6:408:2a1::19)
 by SA1PR12MB5613.namprd12.prod.outlook.com (2603:10b6:806:22b::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9434.9; Fri, 19 Dec
 2025 15:20:33 +0000
Received: from LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::1b59:c8a2:4c00:8a2c]) by LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::1b59:c8a2:4c00:8a2c%3]) with mapi id 15.20.9434.009; Fri, 19 Dec 2025
 15:20:33 +0000
Date: Fri, 19 Dec 2025 11:20:30 -0400
From: Jason Gunthorpe <jgg@nvidia.com>
To: Peter Xu <peterx@redhat.com>
Cc: kvm@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	Nico Pache <npache@redhat.com>, Zi Yan <ziy@nvidia.com>,
	Alex Mastro <amastro@fb.com>, David Hildenbrand <david@redhat.com>,
	Alex Williamson <alex@shazbot.org>, Zhi Wang <zhiw@nvidia.com>,
	David Laight <david.laight.linux@gmail.com>,
	Yi Liu <yi.l.liu@intel.com>, Ankit Agrawal <ankita@nvidia.com>,
	Kevin Tian <kevin.tian@intel.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH v2 2/4] mm: Add file_operations.get_mapping_order()
Message-ID: <20251219152030.GA371266@nvidia.com>
References: <aTWpjOhLOMOB2e74@nvidia.com>
 <aTnWphMGVwWl12FX@x1.local>
 <20251216144427.GF6079@nvidia.com>
 <aUF97-BQ8X45IDqE@x1.local>
 <20251216171944.GG6079@nvidia.com>
 <aUGYjfE7mlSUfL_3@x1.local>
 <20251216185850.GH6079@nvidia.com>
 <aUG2ne_zMyR0eCLX@x1.local>
 <20251219145957.GD254720@nvidia.com>
 <aUVrfs1w6Sg0jfRw@x1.local>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aUVrfs1w6Sg0jfRw@x1.local>
X-ClientProxiedBy: BL1P223CA0040.NAMP223.PROD.OUTLOOK.COM
 (2603:10b6:208:5b6::13) To LV8PR12MB9620.namprd12.prod.outlook.com
 (2603:10b6:408:2a1::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PR12MB9620:EE_|SA1PR12MB5613:EE_
X-MS-Office365-Filtering-Correlation-Id: f263791e-2910-4cea-ee6d-08de3f12270e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|7416014|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?Euy2Lj2xq2e/ESxXBS/yBEnu1pPESEryzWq/ZFo/4ZTMKyk6MP/74yzmrXfP?=
 =?us-ascii?Q?h8OZ8I+4g++HYQfVrubEXiPBWoPV0X3LOj7eic7RmXC5pszEwDJ0sPHMhZvy?=
 =?us-ascii?Q?8h0vGl9EDjMPoCPYCdL16Shu6KNxQMFzY6zR9EyKLIpRblQiK6JHh4rl0+IG?=
 =?us-ascii?Q?BqSIlsFYrc6KuEtDf/4iDB1IC26Du81qRWqQjjQHRyxBo0uRYmhTCwhtXBYo?=
 =?us-ascii?Q?Ktf8MN5sU0vGfdLR3hi34bpYGXyEKq1TDNQ169dzPCSxqzLTpk1ts0eAXghL?=
 =?us-ascii?Q?rRtQeZTbcrgy1IB4cGJpLa6joCFuMiN/AVAs56cZs5vlppRxnqXkLHn0sdwU?=
 =?us-ascii?Q?GK1PsbOHyQtuOkuuqpl37eQxcgpCTEJSVRHahFc8XqIDYcN61zkFPEwgVweI?=
 =?us-ascii?Q?t0isTkbl8FYPUuTcU6cZGQxqw371knY/W6zvMwBeuxpWzLa42v9wQu2LPbfo?=
 =?us-ascii?Q?uVoMY4sXzsh3Yyr/W8DrdCRlwzw5ZsVTrGNymL7clD1HsBHV69EGEshZ1QoK?=
 =?us-ascii?Q?pkECmMRPeUopVuSdCbJ9xiouapP614wQl+xvFCjvzWJktzZfPRrDMKVSnzK/?=
 =?us-ascii?Q?ocJvd9Vuu3wE93UMjpMZYHfdvLUNbapXYRq/Q6J3kMSbCj2W+XM8Utrobchu?=
 =?us-ascii?Q?r+rRA0L4zujzkj3QleISoBxP4pB0z6Ufl5lC8UPPFmJGU8i1sin8jSHzwNPr?=
 =?us-ascii?Q?fgSS5QTclY8oSnIlsgmbS1+83HRMgFNZ4c5c55lD7kfMihbx57xmnzt/C3rX?=
 =?us-ascii?Q?JRbulB9WQS2gFiPE/jvoeqS+jRZ/oiUFJoHblyPLOzWpncxIlada5780rVo7?=
 =?us-ascii?Q?MpNkjJCOZ7a0gSs/umZ9/5zpWJVXCEwVEz17rLZdceOCPmXQMzI8ADRwqRzG?=
 =?us-ascii?Q?8/NXN3M5LC2IaJvGQOPQy+8ZMlrqsvkO7bw1RcHc2OvgoI95fSXBGmW5SiNv?=
 =?us-ascii?Q?zxFYSFBf4gh50LRJyMe7Wq+TSR9M8zPIeaDpkIOhQXjK8LOuFJ2fuPx32x4Q?=
 =?us-ascii?Q?8TUOM16BZyiwUtfShCVZGKu9/JUgB5F16mmLpH5t7QrSAMSen7QSER2InHH1?=
 =?us-ascii?Q?/ov1KiWjFWeyTHzL+ejZhtwlvlpctAw1qlLCgKm+b++iLgzuWgNNNwf4xfRU?=
 =?us-ascii?Q?GgS7YdJeFHfu317b6/JKV7vfywqMm6gaocC3OOwdV4F04UrpqJm8bRVQ8vS7?=
 =?us-ascii?Q?j8VthLhJfO9Ij3ZcSQUnjDEsLrMjJ7MhSNg+8vZRzSuoS02YyoDW36OViQv7?=
 =?us-ascii?Q?Fe2KXDNwZSAFeG1R9g1gOHq6vTsmpavdtlX9Y9wpEqXHMftNrWYhq6TyRRMa?=
 =?us-ascii?Q?kGjo5C2b6QIKhnwpbeLkTYXsYPJk2SWuNw6+igYga0u7dBq7uxXnzun+dxe+?=
 =?us-ascii?Q?RG2NThmmqNF5dLqXzbxbIrvl4TwsOuXd3WNGTaAjHrFU5RqCijUxFKgpB4ER?=
 =?us-ascii?Q?s4Mp4VLVULTiEeuRA/8HWdFjYUf8qCoZ?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR12MB9620.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?8+Dm5VIg3hwY/UsGghMQbesTVLAjNRdE3bY2YDBnpNsFHklLuL2CDsEvpGh0?=
 =?us-ascii?Q?mW9UKEOX1eFKc5pPT5fkTp0JXYA/btNRsni2dEWBEx2B49+M+2E9SnvDga4T?=
 =?us-ascii?Q?Dj6L+UvjJ/GMbsW8z1IYSgSemGIyS3xhLt5dHpkd8SNiEJgah6ZhiNWCbnjt?=
 =?us-ascii?Q?cXHUdsB1uY7AoV+xeYI8T829W6v7qJ7exOmnIHl2285PiT39fSYsCnNGEkw2?=
 =?us-ascii?Q?BppwFGKRAZz/h/VVNrfoRzCIYuVkU9uWuNpbYoThUv4joh0YeRbQxvgpZcbc?=
 =?us-ascii?Q?fI1fUDSeNopBzNe5TBJtBuM+Ma7iehfZI8ZkvANA4OHUIb5Z6oF5Vf84ClPu?=
 =?us-ascii?Q?j8kN2Mv+49j0497oaU40rmHIKVTUdhPUMpbGSeb3zBRqlDK9vCeECocGcCLg?=
 =?us-ascii?Q?72nIxI2u5czaOIfhQpqxoS3fn2ntMzmQoLSOTf9TQvCtpb7Ou+Mp+E3HnRqP?=
 =?us-ascii?Q?96v8hqhh+PtBLyZXIxPsm1kOTAExV6n0BkKAkV0+Pc3Xd9MILCy6ihfeEJTG?=
 =?us-ascii?Q?bGzvBO7/8Pa//3kuEARcVCJU/PdlbiNUllF5YhA7BI7HUbs/jcQvct+MA0Bm?=
 =?us-ascii?Q?UgcVM2w2xqmLWS2A5Gji4BgvgK8YRM4c5SMGaOXsu2vQejFochdrMk8SKYBI?=
 =?us-ascii?Q?zyUmwTZ9d9dYU1xE21Qtf+95rEeagFHumtzVGXNYdVOtqGNnvNzBLz3YkkOm?=
 =?us-ascii?Q?P2CoNECK/AvfkDB36kDdsexFNV7RccvrWQW85I+H/oaZdl654NSgVJ7VipSN?=
 =?us-ascii?Q?OBSGDyeP3ILaMTNuBU6HAAEoSQl+uI+7ALvXroVd9MY5f5Dzsbq9AKlnsViD?=
 =?us-ascii?Q?J4P+CTsAJ53NJ9RQHNodVs5Xky8L8f5zQC11Whet8O2vxIkXPHxJQEOhlhn2?=
 =?us-ascii?Q?F8kwCbwDioqQzbPMb2mApcq2WFYIRH7xqVJVtRj9lLmYjvY/CxnpXBSUtqoU?=
 =?us-ascii?Q?3RrLlftMqmKV605S8/gXF+F+zcU0CDbiXJBafVy0Jgbh4ftK5l/7iasC+Uci?=
 =?us-ascii?Q?/Ub6rIYObb1x+iiXDRGQteTk3eFQBCgWkJ6kOVP5EaN8hI1HgnYC42YQdeow?=
 =?us-ascii?Q?xlQuQsq5tXI2UGQHL/8LLf/9tGyS4RoFBVYTQXoOcZJq0mYbCdVjgdoY469W?=
 =?us-ascii?Q?laII3pe2chAlK3iDQrL9dNfICJCrOfW/HqmRDsbtps/EpOA3zaVig0U9qaQX?=
 =?us-ascii?Q?cmLAD/VSLpfcDdoBgbqsdJB3KC0VQAIOsIzNnerJ7Sj7krA7MTECt0ji9HJD?=
 =?us-ascii?Q?9MZskO6SHpxhyKicmSse3hK946Vs8g2VaSD+vUv6XzoZtEKNb24NJrBIc7aT?=
 =?us-ascii?Q?UAa+F9M+cRgbUDIl9ut2V6AEt6WDbk507WeKS5qZ2ACMwlsjdM3umDP7+7FI?=
 =?us-ascii?Q?g/dTZ5rIZnng6tTYmYayeRpKTCYq0NQs1OnMQU8R8uXxhFyrjNRGUZ3ZzZeD?=
 =?us-ascii?Q?OatShzudT8FXoQ6uM1b82i12Vpgh0sTHEeBXz+memiiRGV0rnsDuZ9C5QCNM?=
 =?us-ascii?Q?bzJSTybgglRlh33L76hfGrhsHlsfpDzoqbkdkNCyZSv9kfAp1O85GiA5+Zx4?=
 =?us-ascii?Q?AxuLJx1DpCnlHobvjjv1ModRDaf3jaJlrPHId+F1jTUkh3DrtOr7Pp56LcqS?=
 =?us-ascii?Q?oYVHBbkBT5JIzx4FMZTc5nQXfz1FcNsvajv0LD2vrqsT+Gt7WYsMXzj6M/sG?=
 =?us-ascii?Q?S0OaK5nVvjRxnjQj9+th+3+8Q2v59tVaQe+YQnB/CMyKq5kj?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f263791e-2910-4cea-ee6d-08de3f12270e
X-MS-Exchange-CrossTenant-AuthSource: LV8PR12MB9620.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Dec 2025 15:20:33.2479
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: APtczqH2bw7YpfnVLqwF/gXIPtg6W2Uj37YlWWwzhOSzIuOdQvJ1B4mHNs6dE6kh
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB5613
X-Rspam-User: 
X-Rspamd-Queue-Id: 23BADA000F
X-Rspamd-Server: rspam04
X-Stat-Signature: fhrx65fdbo1ekkmmom7mtc7xfjnufgpu
X-HE-Tag: 1766157638-537381
X-HE-Meta: U2FsdGVkX1+XjMeGijY9/aU/X1J7LTFvTnYthQZMOHE8DxgdsP57cvzRQ61UMyv2XnTRjCMbK5oOCTdehG5xiXCYkTOq2G79bawMDgZdocVgJy+lNauigmQXtJ/x6LbH5RwNUfh7M9ObWOLh5HXuo0oWr4j743uPCjeIIMKTF3iXQjeygh98gqRZ9+HZJIBnD1uedVjTYfOmw070dyKGMCqK88Be1r57SorAlRWfrMTSnbbJHuOIT0Tz94XnmmWyZYzBUEg+fCbYCAaXWvr456GOZfj353XBnZ+iy/ax3rbqGagoMknDOAhvH5w/4AUDJgG94sP/wjVNbfCixy6mPTvWJhqKGj6NexVvljE+1PU5qWDVupUSs7K3IkFFE/zUEm+Hjvqi+pqU+KDa3yD6eGsSur1kaVOPe0Aw5pUewHAnQn4ijo585HSsSU6p1kRKYb37omnQf8mDi02MOBtUbKZmAaHkCaHDWMa31uORUbO0zYPK3OWTpoWo09AIq7uBD53pJQ7m8g/hLIhexUXat3zuJW3VQp7PQgNjPgbz7GhofzuuoUHXRqwpiBIt2qHiFAOSd9FHo3IvDLF/MIyEYSVe7Cu9d1ghFxRCjLL5bJ02wt8MzWfcgswawwacv7fIGZucmPZaZnvab5RivDasgw1qZ0djaGLCnSlQj5Y90MKHEvdg8b05WmGJCz/7Mr6BK1VzO6sC8DDz6bh4sHtlR4E3PZcIjTpp96ussCFB/E6/tvHW52B1wuIyCCpfY/d1Wr08omIsGHE+6BW2w+QurucwztToWQiyw+HEBAvHUcB9c1+HhCMtK2Go8/o+iMia6jqLGyGREW4b44hb6qMqYQtSsGRI07kNBFH7ereBvXs+ZzzvF9E9JoQi6npirpoKMk8B6T5+BL0Lh4mRFO43Oe+OODhvp+by5lR1BJ3CAGA5x5itX/IFDYD4Tx8TVjHQl+Cll/hKLloMwcDlZzk
 1WJlq2OE
 UeKDW2IWsLxRHGnwXk/XJrhLAhlbxOU0wjcvm+CRZrKjB+hK8HqVVBZP3JD6FSEJHQUwzLMJwZdbWlr0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Dec 19, 2025 at 10:13:02AM -0500, Peter Xu wrote:
> On Fri, Dec 19, 2025 at 10:59:57AM -0400, Jason Gunthorpe wrote:
> > On Tue, Dec 16, 2025 at 02:44:29PM -0500, Peter Xu wrote:
> > > > > Or maybe I misunderstood what you're suggesting to document?  If so, please
> > > > > let me know; some example would be greatly helpful.
> > > > 
> > > > Just document the 'VA % order = pgoff % order' equation in the kdoc
> > > > for the new op.
> > > 
> > > When it's "related to PTEs", it's talking about (2) above, so that's really
> > > what I want to avoid mentioning.
> > 
> > You can't avoid it. Drivers must ensure that
> > 
> >   pgoff % order == physical % order
> > 
> > And that is something only drivers can do by knowing about this
> > requirement.
> 
> This is a current limitation that above must be guaranteed, there's not
> much the driver can do, IMHO.

There is alot the driver can do! The driver decides on the pgoff
values it is using, it needs to keep the above in mind when it builds
its pgoff number space!

> If you could remember, that's the only reason why I used to suggest (while
> we were discussing this in v1) to make it *pgoff instead of pgoff, so that
> drivers can change *pgoff to make it relevant to HPA.

What? That's nonsense. The pgoff space is assigned by the driver and
needs to remain a fixed relationship to the underlying phys the driver
is mapping in. It shouldn't be changing pgoff during mmap!

Jason

