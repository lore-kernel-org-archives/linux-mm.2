Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A15E7109317B
	for <linux-mm@archiver.kernel.org>; Fri, 20 Mar 2026 05:52:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0F0066B03D0; Fri, 20 Mar 2026 01:52:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0A1C66B03D4; Fri, 20 Mar 2026 01:52:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EAB606B03D6; Fri, 20 Mar 2026 01:52:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id D16DA6B03D0
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 01:52:54 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 7C1631E12D
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 05:52:54 +0000 (UTC)
X-FDA: 84565372668.14.3E87F70
Received: from SN4PR2101CU001.outbound.protection.outlook.com (mail-southcentralusazon11012068.outbound.protection.outlook.com [40.93.195.68])
	by imf08.hostedemail.com (Postfix) with ESMTP id A777B160004
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 05:52:51 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=L5qdtUU5;
	spf=pass (imf08.hostedemail.com: domain of apopple@nvidia.com designates 40.93.195.68 as permitted sender) smtp.mailfrom=apopple@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773985971;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AEafgFIoYk9yMgPZXwQqz/sxXQi9cJkanRA/IEoWF5E=;
	b=Dg2u+7kId1TIiyVrttjHFcjXALYa/mnXw84pmaqgPvqgTy2dbyibsIE204o/MNIl5ZETlo
	SKlelYyylGL+eTD9SinTywXB1GYst2rEE5NS0VuDZGuNccMNMeqm0NG+IQlMf+Axwc3onj
	Bg96FVvqhropIcqUNpMAd8GXifatYlY=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1773985971; a=rsa-sha256;
	cv=pass;
	b=42u63XZMYmYj59TO2SLM4xuevMQ27XSmB4GnvdFe1spITS0Z4MaGs/goTT1/xnGOuQ/bEE
	PnW2vkLa5sJ7VnUBbMzRytQbTvfePCDFKx1H/ixEE4FVfJH9F5H+nKtlwioJMTjGLT8Tfq
	GC5GzREv4aSIuy/6u3ds9/OX5ecOvgE=
ARC-Authentication-Results: i=2;
	imf08.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=L5qdtUU5;
	spf=pass (imf08.hostedemail.com: domain of apopple@nvidia.com designates 40.93.195.68 as permitted sender) smtp.mailfrom=apopple@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=wIt0KgSze2qDCDgbBKeRnU/IUfEViq9y7ALW2UxRDbrwFmUdqQgrqcl2Rzh8bC7K/46G7cushWsLhb45ErXN0sMv9IGTEdmTwwTLBT8U62Poj7xw6OOgq6eGGxaGYmmF7hf6NKrLbXhZU6quYvMt4/puApjHLr3TMgrbIm4FLDeKL1VA5Rkl6nCyegMfHrmuvBPgqoYqq5zpVeNFXv0RNO+1/3JciW7xMhq84BLpR9pIncBW5x6QMxcpCCEowMtADwMoywEoAatj5HuUJc7L0w6/b1B21tyobFFVCOVeUWZONKJBwtGN3rzYBO2smBpdKLy5jOc+ukFsoINCcTF4Yw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AEafgFIoYk9yMgPZXwQqz/sxXQi9cJkanRA/IEoWF5E=;
 b=Pt8k9c/D/Ic+Yj8Yi+Nut2iFfNC6Xyy5boR2xDjWZw0tNVlVS4f7HIujj6jn28OcXVZl1+btRDj1VTm7M8uRbsMFlxYCAW/XcfI1h5hCEUM+b71571UzmsnAZcpVaRhRUeYSeTCAldoklB9FL/eVGJdaBMrLG/N/3oW5HKafCFnlJ+hDy2P2omzM8hFpzx3a0TmHFuNe5isFfaD3jrVfEyxaMsH9DtShMijwfqgcIKhKU/Vd6mwARFYgYN9TOqmvgVolXIeO9wDxWEMikhSPyVtQm0fldbdIZLxZ3aonhvcmxSgwDwyc58oghWNdaf+YAf3XYnKtuv7dqXJe++Gs9g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AEafgFIoYk9yMgPZXwQqz/sxXQi9cJkanRA/IEoWF5E=;
 b=L5qdtUU5W5MF+UEFxyJdf4KSVHhloRl5LiSHK0gC4dw1VBNqlYpfD/o6VFEDII1r2BMfCXDZp6oU0rGCupH/vntBuAm50iaEe63CrvBHtIajc5sYL9bUkJvNhTuZ9hrEjaBt+hUmk5ZzRuN5wVVw1OLn4ATkmUl7hvNhPeT9RNxmKz7oJjNJY0Ghu6OJUDvv9M0GK3ROtn0c93L0Up4QXdAQ/9tkH42FNDU9u2uxC+Rh8c6xDY6UNuWvx5haTY9fO4Mx6be6A8rPpY1w4mzF89rIN9oMCVAFmZ58duIKjA/raUNkkAaGjc955yfuPlBzrbQQNl+cmkKV8pGMBrKfyw==
Received: from DS0PR12MB7726.namprd12.prod.outlook.com (2603:10b6:8:130::6) by
 PH8PR12MB7026.namprd12.prod.outlook.com (2603:10b6:510:1bd::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9745.9; Fri, 20 Mar
 2026 05:52:46 +0000
Received: from DS0PR12MB7726.namprd12.prod.outlook.com
 ([fe80::5807:8e24:69b0:f6c0]) by DS0PR12MB7726.namprd12.prod.outlook.com
 ([fe80::5807:8e24:69b0:f6c0%4]) with mapi id 15.20.9745.007; Fri, 20 Mar 2026
 05:52:45 +0000
Date: Fri, 20 Mar 2026 16:52:40 +1100
From: Alistair Popple <apopple@nvidia.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Jordan Niethe <jniethe@nvidia.com>, linux-mm@kvack.org, 
	balbirs@nvidia.com, matthew.brost@intel.com, akpm@linux-foundation.org, 
	linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org, ziy@nvidia.com, 
	lorenzo.stoakes@oracle.com, lyude@redhat.com, dakr@kernel.org, airlied@gmail.com, 
	simona@ffwll.ch, rcampbell@nvidia.com, mpenttil@redhat.com, jgg@nvidia.com, 
	willy@infradead.org, linuxppc-dev@lists.ozlabs.org, intel-xe@lists.freedesktop.org, 
	jgg@ziepe.ca, Felix.Kuehling@amd.com, jhubbard@nvidia.com, maddy@linux.ibm.com, 
	mpe@ellerman.id.au, ying.huang@linux.alibaba.com
Subject: Re: [PATCH v6 00/13] Remove device private pages from physical
 address space
Message-ID: <abzUKN62gOA5b6FN@nvdebian.thelocal>
References: <20260202113642.59295-1-jniethe@nvidia.com>
 <4b5b222a-18e8-4d48-9acb-39e5bfe4e5f7@kernel.org>
 <abiloqDpIs046DJJ@nvdebian.thelocal>
 <b1ae55b3-8058-40ef-96f5-5caf97b1ace5@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b1ae55b3-8058-40ef-96f5-5caf97b1ace5@kernel.org>
X-ClientProxiedBy: SY6PR01CA0024.ausprd01.prod.outlook.com
 (2603:10c6:10:eb::11) To DS0PR12MB7726.namprd12.prod.outlook.com
 (2603:10b6:8:130::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR12MB7726:EE_|PH8PR12MB7026:EE_
X-MS-Office365-Filtering-Correlation-Id: d343d5de-dda6-4ae4-385b-08de8644e878
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|7416014|376014|1800799024|18002099003|7053199007|56012099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	iKKKYjgs68Sy0G+kixsde1V6TKWns2QBvOGLakQkMVbsOUb+29ApJsvH5+ieEbWm6GYTZ0gNSQf1fLr9hYnnKZp8vqVg9Jhhid4Aj3/tqnXpcYQaEJyjFs2P5YoEChvobNP1PgMOeBtUsIL09y7YPgkXC1hFwuep3K7vfB+wBbyG2W+IJVV17Rp8SDrRjnW/6O/GjYiUN8Hp6MCWwMSVyhshWHbxRJFjPrGiAOzfaVXFun6BAjh4/ZabX6v6P3IhXgxiVIKAmMkiAI9PhiWK4+Hj5ov95C5l2EKSiOLkMBw1GuwTDeuyDcP13gVLXDZmx1DL8zs4cBOzsTsQuBb1lXnrk3GKOZTEuIewdyMAQ2+JGKcZVUaWZ0mGNvM7E9PWMdGZ4WwdGzZdGMWCbP62gyX68kUyZbN+u2YGBpVoWN+7Pql47T5M6N3Ayq36kemQ8D2jK31hm8KatvJBC3dUnhVNBjhgcWqMX48LtWLi/X7juaAt4clvyqSxlsCir9pUSF4re+LeVnRX2Ntwj/gkV8RAZecZAn/N0Qmp66RyEGUa7+bRtUUeOwtYxL3ClyY9DwNEy0/3oigjM4QZconlWTj+kXvM2t0QsdkCR9rjBOcrd5UsN9pAjfszMAau5O3DncaRhDP4pzm2zCzT9zp6AvWF8h/BBZqq5E8AX34EIiMzR9ftrRogm20WVIfF86vVgmfV4gkTZbCewaMakIZz6g8UevmANevPdBP/pm6WGNc=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR12MB7726.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024)(18002099003)(7053199007)(56012099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?7NgRQF4rjtlIlAKPWHwkN4lJBjxY3Gkfrj/bGBtzjgyyoobtWByDKaGwHe49?=
 =?us-ascii?Q?GqoB5hRfqe5w7oUfvDxl0gbP8xOi7oWL+cFsXYBUVn+mMbGFseauWq5IHtP0?=
 =?us-ascii?Q?dDBvqsLuCgcC3s4eQK63sKd5MbQDEeM/i2cZm6do2zMHeZLg3+5okg6krmBI?=
 =?us-ascii?Q?1Tz75fwAjOIGSn3ql6x0ECLSzkc16rzi3iicStNu3T2saB0AAuF1bO6DyXCL?=
 =?us-ascii?Q?E04ZdT+oqCA7qzZ3dUAp/eIU9P9E6Ix8ufVOeh+TqLnyLJpLfI6HHt2pOgDy?=
 =?us-ascii?Q?m5TvTIoUkeQrbgr6vq1zfNPZeaePrRtomXM6E45M0mFLro3NHuN0a0Wqr5Hi?=
 =?us-ascii?Q?fU94kZ2vBTugwAF0HboGkUWQ3KZVwBAJAf5B9wGvmaSc8Z9ty297WgLviBG6?=
 =?us-ascii?Q?stJPGazoCJD7vVHBJqIa0di2zec3mvon86oP7TLGiDxOV3uz6d9nR3wAsL8R?=
 =?us-ascii?Q?bVp9HbIDgBNHqjTur+RD+F7aROARmwJ3UxbO0ZwRwTugMQlN6FvNRt0YENyq?=
 =?us-ascii?Q?KLFB+myauQfZY3JtRYOeK6eXcdS1uqbdvpT2ZqTIcXvWJdVqJkgNLMRo2nuP?=
 =?us-ascii?Q?guQGivsJBwZxwYCoAd1IWj4IFZxsgdHBdzprWnW+JSS9BVDz+XFxyFf6cIDS?=
 =?us-ascii?Q?YdgzoPOMv8VSyRHhDn7m2sRTKTL4eJiuIKlD7WqNgCu26zy9tO+IM40UFUGR?=
 =?us-ascii?Q?wyObKjMaLMklEs6oWx2ccxYxkh8RUcN1Qwpz/v+/5Ko8oCP+ZOvFfLNOe/Wb?=
 =?us-ascii?Q?76qpust1KhrRsYGM8k2qy4oGl33yBiM207/R0qj8jesjS5jo5/3Z3bfCvkSa?=
 =?us-ascii?Q?tCvfJ2sEb7Lz/S0ZtSzBqM5j8g5qCVaoPSiZ9lxflPFkuV+SrQmgO7oySIXG?=
 =?us-ascii?Q?4ngS75HbMukKi+b+TQFxZxXdf+1yiLP5kEtNswXJIplF6ltImSAtA/OvTbli?=
 =?us-ascii?Q?UBW2tNGYTvwzTjyJV8uffVudaH+9R8BlaZqLluQDJTdFYDtFcLsftpPUf27d?=
 =?us-ascii?Q?Ed8IV8IX9gmRi/pDKLxIxDElLlO1Xcy4EQxQV6QNP6VNb3WX4MNHHGadJ7r1?=
 =?us-ascii?Q?QCUtDinUnUm8WIQlLx2upIRmiXMJGFJNdKoz7KcdTKJVZlGjFJOovK3UG9S0?=
 =?us-ascii?Q?CuIzOh1DnN9SsUypnBxymXojC7CaId9uHUhvKroFn9m8gpLZmolbEHJieqWo?=
 =?us-ascii?Q?rxFF0sPbiwYrUe0AX1tgePwd1bja1IzrPB0FfNP6qvXXlWuh7mMQBBkHxjIj?=
 =?us-ascii?Q?z7IEou3eHez7qfqMWUiQapXe/cfiUKtS/V6ykIwtcG/E1hNhZbm+52pKgp1m?=
 =?us-ascii?Q?DhLWq5r3uFZ4BdVtqfp/58re//HGx5Q8e+CsWthHUJNh8dXlvt4PahNqnKJp?=
 =?us-ascii?Q?eV2p638eDbJEEqoUe/nT8JRjVZS+GzGnhG53HhMvYD0VZZYjon428LKFL57m?=
 =?us-ascii?Q?G+pvvsrsO5xRSb57HI2UNgV0rvfdmc0BTxk9+O9iZU0wWuiXi03arICa61q2?=
 =?us-ascii?Q?WHgGLQJT93Id7zuMyhrIM+2ycpEW5/ijoVupKzrdheCDw7e/8vic0CHpL4DV?=
 =?us-ascii?Q?S1O2k9ARZAu46XyyPUJgfQ9HTytK3M9HTApilx1/aAT+MURyItKUK9QHAdO3?=
 =?us-ascii?Q?7b0thsj4FK3u0fKwVJ+mFz07V3ZJk9rEBjTyagzcUt8CUEHDLMpH84SvuSY3?=
 =?us-ascii?Q?f9arnS2ZnQo1O/JdZFm7QLAf6WL1Ri9X3qE0mD1ULH1axFAc5an4ZibSagNJ?=
 =?us-ascii?Q?jVrEnVGdkQ=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d343d5de-dda6-4ae4-385b-08de8644e878
X-MS-Exchange-CrossTenant-AuthSource: DS0PR12MB7726.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Mar 2026 05:52:45.5093
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CT+lNdAHzl8wLpfqyG/5cGUHcKctZvT59x+ZFDHTHZHcxTpIXA8Dqk1/DO82cZRswISxJI/89WprDlq1HE/Fcw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB7026
X-Stat-Signature: wx3snegken111k3jwj7qmkbcwe1nu6ha
X-Rspam-User: 
X-Rspamd-Queue-Id: A777B160004
X-Rspamd-Server: rspam12
X-HE-Tag: 1773985971-321071
X-HE-Meta: U2FsdGVkX19OZAzVIYW3pYiDLzO3pc+CLR6WxAni8VCs/I5NvVwOheEfdICr3dHHDYRJOBW9dpmoo0Cw1IsW86xHW/jbbiTVmkIV2LndzaH5vV+DcF4dmBpNP4iH1McgGgrreQam008W/yLuo+zQk4Hh4ORj5cvBZC0jOhBEzEdvYbX7uzC9/JEbRrJ62jQVUMIrjhL3R0EJ3InUQT9UFpM92+zMrSqc0vYebkTbbJSwXFaqzyC12qSPhlrvkdXuYYu1DF+PokvhepNuz2m1diHdfhmwPTJ7m5XC2SRCw0t3aZ1Nk8HzY1CaivrTqanYkbR2FoOVgfoTHoDgp2/WNzHQNVJ1Hq6t70XQ7adXHmdJadnSjfhxQpqXN5I9nCUGR2X2jPImigNVfdhtzUooJGC3YtW3qDGrL0eew9VAow14KHEf0IXHV5TQRZfC+PORQcavGzZ3ZQ+MYDF28j1k9wG0Wlte/J8M7kp4LGuxMDyh7E7FBQJsb7NyEqAGch751eP0hJMmarn9D2rC13s3DYJVaB1RQkt/JYCjgwy3ZsoiPCoQS37x+6V7yce5CvBv/VneWBrzr7P14012ejSXRca2bQuewnMll10WxJ+IV6pST8niNmi6K3lvQml2h5jTQMeVCzApmYe2EL7iATy1sG+ijoPclkbM/hDoa7DDFh8kDjMNL3Q/WkE7m2jiFt8Uu070hdX4cuSDFvQrkWoD8UIFU4ndleecdz1tZaM5WdecrmngPEXOx8OCmUZnxSCl9dGXoTqWgqbrhwwogvcMt09L/rkzMItHg6SlerS6w2EAjhaKLoDJaYoXwkmk0hPDvAVhOgPnzkEdfoMmYrcixFBopazhtzbl4V7teWpSzBWHY4KrU3i4wrBQ/V1vGukNPdWvGlcXgrnonBF8oy0creGaj46EqaSm7v3BSSUaw8iU1Y7lBlswyUV/FoO0Bcq1gvCNpUDZ3CyHUGFw3dT
 z4M2b01i
 N5aVwZ4Dg/4GdxXou+E9TcoH3HZ+LoT4ryGjSyOdEaxozB3AN3OeWY2xfo2OsanDDGlSSF+RXiBXFPlN/Bb425VjJAuXgZVHJxhMoh/5ev1OGRdngC3gbbT5XwJrEgICzGaq+LQo3KXn5We7nk6YYwNyvVOit8smUZje9nVu4wsa1naBAelGBgbVMdQyzLHUoy+PGwHqwpo8uQ5vX86cptwM+FvMYzgB9V/DSPrzTzxFrsVbX1DSh6b3Wz/VDUU3E+XF6Pdmc9gAt5tE1r5nDO37Lq9IztzwukLDkbfatsEJ7XKwswxgg8JfD7SYuXy3yY1GZgLT7QHPURpUo6HM/6wmrZN+pt5nEIMd+GyGKgeuFUcOfDmodSDlgGfVbWlhVX8+EL0c3dLqd/lE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026-03-18 at 19:44 +1100, "David Hildenbrand (Arm)" <david@kernel.org> wrote...
> On 3/17/26 02:47, Alistair Popple wrote:
> > On 2026-03-07 at 03:16 +1100, "David Hildenbrand (Arm)" <david@kernel.org> wrote...
> >> On 2/2/26 12:36, Jordan Niethe wrote:
> >>> Introduction
> >>> ------------
> >>>
> >>> The existing design of device private memory imposes limitations which
> >>> render it non functional for certain systems and configurations where
> >>> the physical address space is limited. 
> >>>
> >>> Limited available address space
> >>> -------------------------------
> >>>
> >>> Device private memory is implemented by first reserving a region of the
> >>> physical address space. This is a problem. The physical address space is
> >>> not a resource that is directly under the kernel's control. Availability
> >>> of suitable physical address space is constrained by the underlying
> >>> hardware and firmware and may not always be available. 
> >>>
> >>> Device private memory assumes that it will be able to reserve a device
> >>> memory sized chunk of physical address space. However, there is nothing
> >>> guaranteeing that this will succeed, and there a number of factors that
> >>> increase the likelihood of failure. We need to consider what else may
> >>> exist in the physical address space. It is observed that certain VM
> >>> configurations place very large PCI windows immediately after RAM. Large
> >>> enough that there is no physical address space available at all for
> >>> device private memory. This is more likely to occur on 43 bit physical
> >>> width systems which have less physical address space.
> >>>
> >>> The fundamental issue is the physical address space is not a resource
> >>> the kernel can rely on being to allocate from at will.  
> >>>
> >>> New implementation
> >>> ------------------
> >>>
> >>> This series changes device private memory so that it does not require
> >>> allocation of physical address space and these problems are avoided.
> >>> Instead of using the physical address space, we introduce a "device
> >>> private address space" and allocate from there.
> >>>
> >>> A consequence of placing the device private pages outside of the
> >>> physical address space is that they no longer have a PFN. However, it is
> >>> still necessary to be able to look up a corresponding device private
> >>> page from a device private PTE entry, which means that we still require
> >>> some way to index into this device private address space. Instead of a
> >>> PFN, device private pages use an offset into this device private address
> >>> space to look up device private struct pages.
> >>>
> >>> The problem that then needs to be addressed is how to avoid confusing
> >>> these device private offsets with PFNs. It is the limited usage
> >>> of the device private pages themselves which make this possible. A
> >>> device private page is only used for userspace mappings, we do not need
> >>> to be concerned with them being used within the mm more broadly. This
> >>> means that the only way that the core kernel looks up these pages is via
> >>> the page table, where their PTE already indicates if they refer to a
> >>> device private page via their swap type, e.g.  SWP_DEVICE_WRITE. We can
> >>> use this information to determine if the PTE contains a PFN which should
> >>> be looked up in the page map, or a device private offset which should be
> >>> looked up elsewhere.
> >>>
> >>> This applies when we are creating PTE entries for device private pages -
> >>> because they have their own type there are already must be handled
> >>> separately, so it is a small step to convert them to a device private
> >>> PFN now too.
> >>>
> >>> The first part of the series updates callers where device private
> >>> offsets might now be encountered to track this extra state.
> >>>
> >>> The last patch contains the bulk of the work where we change how we
> >>> convert between device private pages to device private offsets and then
> >>> use a new interface for allocating device private pages without the need
> >>> for reserving physical address space.
> >>>
> >>> By removing the device private pages from the physical address space,
> >>> this series also opens up the possibility to moving away from tracking
> >>> device private memory using struct pages in the future. This is
> >>> desirable as on systems with large amounts of memory these device
> >>> private struct pages use a signifiant amount of memory and take a
> >>> significant amount of time to initialize.
> >>
> >> I now went through all of the patches (skimming a bit over some parts
> >> that need splitting or rework).
> > 
> > Thanks David for taking the time to do a thorough review. I will let Jordan
> > respond to most of the comments but wanted to add some of my own as I helped
> > with the initial idea.
> > 
> >> In general, a noble goal and a reasonable approach.
> >>
> >> But I get the sense that we are just hacking in yet another zone-device
> >> thing. This series certainly makes core-mm more complicated. I provided
> >> some inputs on how to make some things less hacky, and will provide
> >> further input as you move forward.
> > 
> > I disagree - this isn't hacking in another/new zone-device thing it is cleaning
> > up/reworking a pre-existing zone-device thing (DEVICE_PRIVATE pages). My initial
> > hope was it wouldn't actually involve too much churn on the core-mm side.
> 
> ... and there is quite some.
> 
> stuff like make_readable_exclusive_migration_entry_from_page() must be
> reworked.

Yeah, I was displeased to (re)discover the migration entry business when we
fleshed this series out. The idea was basically that raw device-private pfns
can't be used sensibly by anything in the core-mm anyway so presumably nothing
was.

That turned out to be only somewhat true. The exceptions are:

1. page_vma_mapped which I think we have a solution for based on the comments to
   patch 5.

2. migration entries which obviously we will have to see if we can rework.

3. hmm_range_fault()

4. page snapshots, although that's actually only used to test zero_pfn so we
   could probably drop that if we just guarantee device private offsets are
   always invalid pfns.

> Maybe after some reworks it will no longer look like a hack.
> 
> Right now it does.

Fair enough.

> > 
> > It seems that didn't work quite as well as hoped as there are a few places in
> > core-mm where we use raw pfns without actually accessing them rather than using
> > the page/folio. Notably page_vma_mapped in patch 5.
> 
> Yes. I provided ideas on how to minimize the impact.
> 
> Again, maybe if done right it will be okay-ish.
> 
> It will likely still be error prone, but I have no idea how on earth we
> could possible catch reliably for an "unsigned long" pfn whether it is a
> PFN (it's right there in the name ...) or something completely different.

The idea was (at least for device-private) that you never needed the PFN,
only the page. Ie: that calling page_to_pfn() on a device-private page could,
conceptually at least, just crash the kernel because it should never happen.

Obviously we identified some exceptions to that rule, the biggest being
migration entries, hence the helpers for those.

> We don't want another pfn_t, it would be too much churn to convert most
> of MM.

Given I removed pfn_t I don't need convincing of that :-)

> > 
> > But overall this is about replacing pfn_to_page()/page_to_pfn() with
> > device-private specific variants, as callers *must* already know when they
> > are dealing with a device-private pfn and treat it specially today (whether
> > explicitly or implicitly). Callers/callees already can't just treat a
> > device-private pfn normally as accessing the pfn will cause machine checks and
> > the associated page is a zone-device page so doesn't behave like a normal struct
> > page.
> > 
> >> We really have to minimize the impact, otherwise we'll just keep
> >> breaking stuff all the time when we forget a single test for
> >> device-private pages in one magical path.
> > 
> > As noted above this is already the case - all paths whether explicitly or
> > implicitly (or just fogotten ... hard to tell) need to consider device-private
> > pages and possibly treat them differently. Even today some magical path that
> > somehow gets a device-private pfn/page and tries to use it as a normal page/pfn
> > will probably break as they don't actually correspond to physical addresses that
> > actually exist and the struct pages are special.
> 
> Well, so far a PFN is a PFN, and when you actually have a *page* (after
> pfn_to_page() etc) you can just test for these cases.
> 
> The page is actually sufficient to make a decision.
> With a PFN you have to carry auxiliary information.
> 
> > 
> > So any core-mm churn is really just making this more explicit, but this series
> > doesn't add any new requirements.
> 
> Again, maybe it can be done in a better way. I did not enjoy some of the
> code changes I was reading.

Ok. Was there anything outside the exceptions above that you did not enjoy?

One idea we did have was to make the PFNs "obviously" invalid PFNs, for example
by setting the MSB which exceeds the physical addressing capabilities of
every arch/platform. That would allow dropping the hmm and page-snapshot flags
although is still a bit of a hack.

Ultimately one of the issues we are trying to resolve is that to get a PFN range
we use get_free_mem_region(), which essentially just returns a random unused PFN
range from the platform/arch perspective so an architecture may not recognise
them as valid pfns and hence may not have allocated enough vmemmap space for
them. That results in pfn_to_page() overflowing into something else (usually
user space VAs, at least in the case of RISC-V).

> > 
> > My bigger aim here is to use this as a stepping stone to removing device-private
> > pages as they just contain a bunch of redundant information from a device driver
> > perspective that introduces a lot of metadata management overhead.
> > 
> >> I am not 100% sure how much the additional tests for device-private
> >> pages all over the place will cost us. At least it can get compiled out,
> >> but most distros will just always have it compiled in.
> > 
> > I didn't notice too many extra checks outside of the migration entry path. But
> > if perf is a concern there I think we could move those checks to device-private
> > specific paths. From memory Jordan did this more as a convenience. Will go look
> > a bit deeper for any other checks we might have added.
> I meant in stuff like page_vma_mapped. Probably not the hottest path,
> and maybe the impact can be reduced by reworking it.

Ok, lets see what the rework looks like. Thanks again for looking.

> -- 
> Cheers,
> 
> David

