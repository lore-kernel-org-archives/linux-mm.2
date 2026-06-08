Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6892FCD8C92
	for <linux-mm@archiver.kernel.org>; Mon,  8 Jun 2026 15:41:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CC3566B0088; Mon,  8 Jun 2026 11:41:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C73726B008C; Mon,  8 Jun 2026 11:41:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B40796B0092; Mon,  8 Jun 2026 11:41:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id A26956B0088
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 11:41:45 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 3964712019F
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 15:41:45 +0000 (UTC)
X-FDA: 84857160570.12.CD01F8E
Received: from CY3PR05CU001.outbound.protection.outlook.com (mail-westcentralusazon11013054.outbound.protection.outlook.com [40.93.201.54])
	by imf09.hostedemail.com (Postfix) with ESMTP id 57900140005
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 15:41:42 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=qxrzd2yi;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf09.hostedemail.com: domain of ziy@nvidia.com designates 40.93.201.54 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780933302;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VYmSS7qrsCf01n/Z6Hk1QjszCv6FStv2uHqZ0Z16eH4=;
	b=8fyTV/JFxwOn1B7qWbGARkkTFvYdFSeWPPwBx+ak2z9POXOcpV2e76fcH+yNqh1c8Q7Sov
	p3NTuGFQP5JoRy+VsuZEBS9DN1aXucUCUpM1NnJEvqKVAz4VH/CbUglJlTa4aI1sLHAMED
	a/TW5tPJFL3o/gowtYTWCbkY7IGuKIA=
ARC-Authentication-Results: i=2;
	imf09.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=qxrzd2yi;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf09.hostedemail.com: domain of ziy@nvidia.com designates 40.93.201.54 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1780933302;
	b=5RgIwTJiStiQhubGzTR91Wel4zGdTbn+49WltX1FFCwzwl+sr9gXEKRCyAEFPsFLlMbHTR
	2AGZUlO1AsDlNUOum60WhdMAtL95nu654JzTuX15qQZ5tGtPpuU2gZ1UsbOf5TX24ehS/G
	S98BpPFbGp1IcWFOEPSjvbLfo8Wk7eY=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=kTT+8U5cIvDvV236Mnr4oD5IML10Z+l3CynwFKPd5J4eWA/rc87X9K8pIeGkyC/9WO7uu/u5vAWaG0A6DGQaH5OrMM2yeYeJdM/ks8BC/Z0kAWt9TzJZdCDW5ItQ533RhoCfMEcDhWH1YU9mblmcvFwrHOfk23A38YUGGWJELxHJIWMFrJM5F4wtNStNePQ+peB21UPHyiJjtn08bixN0FOjyW8f6Qtw650mX60Vu15PKgWyeOO8A9Xh+3Oi9kjrcyoX2FDhWy9pj+x09Omas7TftFhwmc8bCwvzKLVPCxbVoE8kCmYUXp8d3AfE1p6O1QavQlQAbiXUC/JJyF5DhA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VYmSS7qrsCf01n/Z6Hk1QjszCv6FStv2uHqZ0Z16eH4=;
 b=Sw6x66QkJf9RVL5ee89UYVTArZhlmfVmGkvREzHKxRK5Qh5okrcOpI6yMOjMM43GjYArk5GU35aqIjXw6syjnJ7djXfIpyBhDHiQof8Yxdxrr4Tw16nyLXJ3J0M7kDPeDFf/FRC5rhRpsTTPY+aeEp8dGJdm2Ku0hiKLHknxWXW9+pN/uZFEI9eLA3bM0yay2McGTRcaS3WpzUcvL1Ja3l3Q5peoibeooLBT9WYjzSi32PUXy9Ry1l9sRQRvUeZQuBezjg9g9HeCRIZdHhdujkx/KszYhMdcOFXVPKQbmggCdDlPDsD/mgFDmBNmbOZcReYm/UyGbjJHDTHGm/VgQg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VYmSS7qrsCf01n/Z6Hk1QjszCv6FStv2uHqZ0Z16eH4=;
 b=qxrzd2yieASB+6pDEtWlWeb2rgeA98I7ar+6U3X/hmtUEgQBF0aBEAFIjKtnLceG1jVI/pHxyV05RpmaY3gc0i/Wn5nuRINTI1irIInE0JVWXJVGePL6hYrGhhdB+D7zQcmT1ahZX9/IEi/yelPudHmbT45bUHKr9Xr5qzYYjkUdsXrgFCURUmNNwkhx69Jm9GO23314kv4oHgT5wtxjwX7ChCTteb08VKQUDhnY/N2F8p1kIU5Wip2ySeKPb8BcEEN4/43yBsjsrKBIx5SbyExVAyPmlE3eUcMemrO0gsuuyqHw1dodHcENx7ex9YArWbInLtlpMEdhyT9VVUF6Ig==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 SN7PR12MB6982.namprd12.prod.outlook.com (2603:10b6:806:262::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.92.13; Mon, 8 Jun 2026 15:41:28 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2%5]) with mapi id 15.21.0092.011; Mon, 8 Jun 2026
 15:41:28 +0000
From: Zi Yan <ziy@nvidia.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: "Garg, Shivank" <shivankg@amd.com>, akpm@linux-foundation.org,
 kinseyho@google.com, weixugc@google.com, ljs@kernel.org,
 Liam.Howlett@oracle.com, vbabka@kernel.org, willy@infradead.org,
 rppt@kernel.org, surenb@google.com, mhocko@suse.com, matthew.brost@intel.com,
 joshua.hahnjy@gmail.com, rakie.kim@sk.com, byungchul@sk.com,
 gourry@gourry.net, ying.huang@linux.alibaba.com, apopple@nvidia.com,
 dave@stgolabs.net, rkodsara@amd.com, vkoul@kernel.org, bharata@amd.com,
 sj@kernel.org, rientjes@google.com, xuezhengchu@huawei.com,
 yiannis@zptcorp.com, dave.hansen@intel.com, hannes@cmpxchg.org,
 jhubbard@nvidia.com, peterx@redhat.com, riel@surriel.com,
 shakeel.butt@linux.dev, stalexan@redhat.com, tj@kernel.org,
 nifan.cxl@gmail.com, jic23@kernel.org, aneesh.kumar@kernel.org,
 nathan.lynch@amd.com, Frank.li@nxp.com, djbw@kernel.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 3/7] mm/migrate: skip data copy for already-copied folios
Date: Mon, 08 Jun 2026 11:41:18 -0400
X-Mailer: MailMate (2.0r6290)
Message-ID: <F496EB0C-B329-4A61-B4B4-0D434563281F@nvidia.com>
In-Reply-To: <7430d69a-616b-40cf-a2e8-6ef4e57b6857@kernel.org>
References: <20260428155043.39251-2-shivankg@amd.com>
 <20260428155043.39251-8-shivankg@amd.com>
 <810e9a58-9c08-4f5e-af5f-866685ca09b2@kernel.org>
 <a36348d0-73f5-4599-8d06-c9472d0b8d72@amd.com>
 <7e6a7626-5a1b-4672-91bd-85b0f4ee2ecb@amd.com>
 <7430d69a-616b-40cf-a2e8-6ef4e57b6857@kernel.org>
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR03CA0377.namprd03.prod.outlook.com
 (2603:10b6:a03:3a1::22) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|SN7PR12MB6982:EE_
X-MS-Office365-Filtering-Correlation-Id: eff6d2d2-3ef9-4b5c-cc69-08dec5746796
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|7416014|376014|1800799024|11063799006|4143699003|56012099006|6133799003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	H7KNgX2Rd0GxTxtopws/csYQ9qM/kzVhghCqsg8TqqlZ+Jn8wiIB7gIXamtwcGBPnJSnb47jE40rnat/Y9+GmYW+ipRkOw5tHlc00XI5zpeFJMZC1XzJekLrrFPv7dcjHu/LjjIzHqmFOnbnPCuxrml3tWklnptPwaPUPEr7vDy2ihpIBbD/exg2eVawzGV9RDXdt322z5WG0V2bvJ4uyAZsEbJ24Sd6jpszSanfOhRV6wytcNdFDujUfVV/WUT1Uu0Yd9fs3ZfXcfoOURpFm6bLNUkBJK5Ka9vMEGhenvq5TzePDcgnZphzOiPtO92gSsK6mvobsWz7LgE7vzkUcjXamWSLT7lXz2xGP0mgNKhB8H+QeIBo5RFsbZKF1/Q92aO76DRJwm2QBCl3BRtS7JRLmSD6hlkThgM51kJWl6bUPlV2wT10hzJDSFxDCnPh+zHqVAo1oTsI2ET9D4NX/AJdtEzsMtccniPWOZLwsplztug/Xu6RJ/Sk2IfSYVSUTsv0E29xtwUSLHF07+qcFqN0F0Ilalz1YbjzLC14nMkA983dGsYn7SOml1hXm+dmw7yh73OVt3PDsIJDEov+Jj+nKVKHy7kZCiqby327UByNymISjxM1V5FJd7T6xT78RZ29VO/Xa4i6plb3id510J9jaEu16fHWYUyU/nP4rJCO95/8s6KgHSleX1UwaBWzVsnsqB5Bg1p8WKxK7R5OHA==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024)(11063799006)(4143699003)(56012099006)(6133799003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?JqJlVomML6xjcSW7WM4C5NSNzWYkvhk2E2499w43Ks1dOLonVIrUxxr3jraV?=
 =?us-ascii?Q?8URMyQsOL5OXZ5qh6+YyOkQHIpDDbLj6domtCT88aqJ6dD2yFBj3C6foe2wO?=
 =?us-ascii?Q?D6uQjbzphJ0FaCa3HT8kF5pb3wRmhg1ba1wXI7idHoW60hezSReLNBJL0gcw?=
 =?us-ascii?Q?yGMFGXM8RiPTPCWUA0u+cFJ7gK9W7B6EsyoqZ8vTfcsUOmqFc0JOm2rsBOEt?=
 =?us-ascii?Q?D8lfn0hQEpSBpoHJZpU+EPM14tmhNvAvFBuYXIvk5pTWGAjihhXOQj50v/sf?=
 =?us-ascii?Q?JNRTbnUXi3rR1J9/ks03WZWQ/0FCLuKXsVOAzVo8uqPpbpRskz2KJYgPtcVk?=
 =?us-ascii?Q?CIaW9pJttNzx9zUAo0s62pX7CLi2JYRy8nf1kse1QV41wuKlC/W5S4D6qP7w?=
 =?us-ascii?Q?w9umSsZ0vhdQxAdIBs6IO6ThcbZpCMa0lih6NDt7bJUw8dD+bFbp2c9GwPPj?=
 =?us-ascii?Q?7gwzhJNHYhLsw+PN77gMoksxTSc2PZPB2i9eCDnE4/4R/Tre7FbOZ6vv+ZX+?=
 =?us-ascii?Q?7QgbD56e06Gi3/11q75oFXwhOJBMcP+vV18eA9mykN/IW2Jlu0a48rhjkbGI?=
 =?us-ascii?Q?4cGXaKgHByOawqex7n0DljiL32CAldf+050MxQPqodXQrwTAtRehQcLwgao/?=
 =?us-ascii?Q?KQtMmt97btEOxiIRdjKKJIM5OfkKq0ZCNmBNNIzJDs07Xov8MDluYLjENQSo?=
 =?us-ascii?Q?/UP2aw0yjaw2Pcrqhu+47s1EbFt4gV6uiSfkfR+THqKxJiY2gNElc3iLcRTd?=
 =?us-ascii?Q?YBfiysh7BJTaG1dP3KOrrtBKJ3de4k6VZy3Mw/AYmIPFEQ/AWT2uco+sfSwH?=
 =?us-ascii?Q?/zHdAYZboE7MeMNgHwt2LdvjspQ/PIB6epoJQZCQR52tBIAKY2KnQJzhktjx?=
 =?us-ascii?Q?XGBDsx19jQy6wG+BmubexdOm/d0q9wPgoB7JbRd2bLAWWOSdMWddj8hBBzhX?=
 =?us-ascii?Q?fy8BnvNXRu9qHHAVNIsOSgQodSjwPJhpIbjBH9c/mRRfCWZoQ9aG7RwGaTYt?=
 =?us-ascii?Q?VMIe8CsOXvJLuPUPw2MyD0Qo+nZX/qty/MXZeXJt4q6IRTZyWNoGLDgqq3mE?=
 =?us-ascii?Q?9xDWQJJ2rpNkmni0DpYtaH5fNU99dMBo2zMrq5mtaFfxDkJRPsz4pP7VDwOx?=
 =?us-ascii?Q?yTqF71caO5Cds+Bw3rU84em/Jcx2d+gLGBYTYY1sA86sHaeIY817oEBCXIYv?=
 =?us-ascii?Q?dpBkEVV5mxZLa9LqT8VnjQ+blGdInOS20zu84hDj7BWZRFiK31QCPEK55Mi3?=
 =?us-ascii?Q?fVAkDTBEtZYwl+Rzxkr4D/dA5ibUHLcRIerj5riwyGWQC/Yh3JDjGHoTPhlb?=
 =?us-ascii?Q?sZdyIFXQ5XxeqjgD2EVDJdkmUSVpcox7xkpQC3t1d59CZIMKuiNAT6P5gWoC?=
 =?us-ascii?Q?ffi+JguqlxYB7zJxJEPQGYjbQ0gZMDXk/uOnfChGMnkofvPSyYrmc3yo1Smw?=
 =?us-ascii?Q?j8++1NMzQsxGBK2B4rO8/EtIuWhqFHbWBjd0g4oD12J8Oioa7SvcxtVzV/Wq?=
 =?us-ascii?Q?/dyK7puRZMIfR9s3wEoRyRGlEjKS/iS+7Qo+/X1ggFt2zsfAF5gXeXzBw4y/?=
 =?us-ascii?Q?qxve1t5pbUMLYAkXc+o1YYiXlg8vO+73gBgF23Xwa6XP0oKJZitn1W16/bN+?=
 =?us-ascii?Q?k2jwv/1T2GcJpo3XmZA+uQP3xQz60QFlFncdNLZHfhFXOme+ovFRGuKYR7Qr?=
 =?us-ascii?Q?6r0ph55qBZALW9ekQ5A73BevFDEFgzqzwj5NkOZUazz90Dsh?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: eff6d2d2-3ef9-4b5c-cc69-08dec5746796
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jun 2026 15:41:27.9230
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: U4hDP6nXtN7W/JtPuOSEcpMOwGx5RVBr+g0MT1C8x4ydiK4hPaFrtjQvar3yLnd+
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB6982
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 57900140005
X-Stat-Signature: hxk6k76qfa1mzsst6nhooo8sxg4mstw1
X-HE-Tag: 1780933302-674596
X-HE-Meta: U2FsdGVkX1+2CVc9zf54h36CNLQhQZLPWfjCPUc3qDnIQh8bMs9/5a5cD5osjDr397jDoAnPxqtyFRHUHfB8JYbiLMQgqGD2dkVaGvzXfjcqQkYVVk6sliHnycLTBF8RjEKNhC3vyB04xMD2hKVIwlJ7jYY7t2XiBOclZkmSSAu3i9pRtpwlvA6iiJ9bOecHwCJJPPXle8vlqdd7D+YoLUZ2dDqpSp5/gLJv3+OSMYxSqqgUPFnEa8wq/rpGxh2yul4h5T/BNE5srQHTyastX1t3zb16p8CEFWp6ogBbZfsslIWEuzZs2xBX5h13GETNbnWvUB6AEe1xUom5WUOh2AyOpfSXpbh0MmorrnZnrvddLgO3wSzUfKHz+4LVNX1qR6AQUz7FnUqz/fEpsV8Nz/QmegzRqFp53+wIg58sm14jyq3Rpmg7zhcREqANEATs4ZCAoF9cj2snMpael2bFLaAVoTCeDWEgBonaTMZpv6e8VgAAhqG8Bv35MF4FVxqyGmzD3+8SmqTWz+VqTCxNnbbRE3O1o32/sP88ES4gYYLFOtzUuj1ANL+6eYYfgoa5IPdtRdSGSVCX/Y1N6JIQ2BCv9Lv348DD2ACUB+3YexYVYxk49InqTba3bDf5NpEYKLEjBVrsEiv7lx/UhiIa4WS2vGL3DXaAAcPPI7U0fty0h2M+XNeabDk7ND6FZDILS29djVxE/RUFP0UbshLzB1cvsHvYx4vKL1Q7HT4PCC/mcFhuTR9jBHYXNKfXhgoD/7CjHBdRwZQ0LM90JpxZQs6ezfHdWUh4BlzzbRVtUA3bY2vyVYu9EiC9LDFUnmEih60q+a5m9OWxicCplaK/oBQ80PBbgRpVPTRlgZKRgG56ffJvxPLKnUX/CUi221ypYJ/C7KEa96xPkS1cfHuC6CORiThOA6KtT6piiya+Jwbwh5AN0QCGxXA4n28sz13f7UCSXt75kyb2fa3k0sG
 EwiB4PVm
 ANw+iPv8IvkvtSdqk84E+G5UJAFfKbAidu3c8YNPKIY/FOdPNCe6X8MB51sWFiaabt3NfX6kxTpIOim0oukcGwQAMDtP8mxR4vmlN1gIPWIyHHW2GsmV7Xt15XDcomfou1M4cZFTbFl1IpGtQIiRS8TFeEweKdJBh34M+dYQ6pSnFdmg45QH5KoRca3kJpjcLIXWpZ2ams1NOvtLyEbZQY1Bsc3YLy3O7XQIFcslya8qEyGN5P59ILrzGJUbsSPca1dL1j99YGTZtJnm3C4nVIEcUqR+m36G4AfUuxIqTgBUPGDVu+J9wkRLuWDhVEmavxoIQCPCE+fT7y2PTnBYEv9rl1P6Uxq2pHaNOcQpJdlGvYukBO5De3aY4dpTw6xmKzKSoIsYNsA/p/EX6Ttnm6iw0tB45jg5dcbN3t+2ES2eLwDEETthM3jK+NrglIQO7CK4h9ae8dEAY0qi/YgLnlqIdMW9IsqL0G+M4G4lH+aUQF+8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8 Jun 2026, at 11:18, David Hildenbrand (Arm) wrote:

>> Sashiko Comment:
>> Does expanding FOLIO_OLD_STATES to include BIT(2) silently corrupt anon_vma
>> pointers on 32-bit architectures?
>> The anon_vma pointer is packed with FOLIO_OLD_STATES inside dst->migrate_info.
>> To separate them, __migrate_folio_extract() uses info & ~FOLIO_OLD_STATES.
>> Since anon_vma objects are allocated from a kmem_cache with align=0,
>> ARCH_SLAB_MINALIGN defaults to 4 bytes on many 32-bit architectures. This
>> means a valid anon_vma pointer can legitimately end in 0x4 or 0xC (meaning
>> bit 2 is set).
>> When __migrate_folio_extract() masks the pointer with ~7, it will silently
>> clear bit 2 from the anon_vma pointer. Any subsequent call to put_anon_vma()
>> with this corrupted pointer could cause a use-after-free or a kernel panic.
>> --
>>
>> #define ARCH_SLAB_MINALIGN __alignof__(unsigned long long)
>>
>> I initially assumed this to be always 8, confusing it to be same as size of
>> unsigned long long.
>> But the GCC docs note that alignment can be smaller in size:
>>
>> https://gcc.gnu.org/onlinedocs/gcc/Alignment.html
>> "For example, if the target machine requires a double value to be aligned on
>> an 8-byte boundary, then __alignof__ (double) is 8. This is true on many RISC
>> machines. On more traditional machine designs, __alignof__ (double) is 4 or
>> even 2."
>>
>> If my understanding is right, Sashiko concern is valid, and I can't safely
>> use BIT(2).
>
> 32bit makes this tricky indeed. And that's also the reason why
> FOLIO_MAPPING_FLAGS is currently limited to 2 bits.
>
>> I see few option from here. Either I can gate batch copy for CONFIG_64BIT,
>
> That's a bit nasty as we'll have to special case 32bit vs 64bit.

IIRC, multithreaded copy is already gated by CONFIG_HIGHMEM, otherwise
it needs to perform kmap_local() at each copying CPU, which complicates
the process. Then, this code will only used for 32bit without highmem,
I assume there will no page copy DMA on 32bit platform. Maybe it is not
too bad to limit this to 64bit.

>
>> or I can force anon_vma_cachep to 8-byte alignment via kmem_cache_create()
>
> That's an option, but I would not do it just for this optimization.
>
>> align arg. Or I can change the migrate_folio() callback to pass already_copied
>> info to change to dst->migrate_info enum.
>
> Can you elaborate how that would look like?



Best Regards,
Yan, Zi

