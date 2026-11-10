Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A785A606A333
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 03:37:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=d581dfVh
Received: by kanga.kvack.org (Postfix)
	id A707C6B05B7; Mon,  9 Nov 2026 22:37:28 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9FA756B05BC; Mon,  9 Nov 2026 22:37:28 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 84C956B05BD; Mon,  9 Nov 2026 22:37:28 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 5571B6B05B7
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 22:37:28 -0500 (EST)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id B7773408A5
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 03:37:27 +0000 (UTC)
X-FDA: 85417799334.10.F2A8510
Received: from CY7PR03CU001.outbound.protection.outlook.com (mail-westcentralusazon11010031.outbound.protection.outlook.com [40.93.198.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id D4FE4180003
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 03:37:24 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=d581dfVh;
	spf=pass (imf16.hostedemail.com: domain of ziy@nvidia.com designates 40.93.198.31 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1794281845;
	b=Zh1+i/tz1l7LhMRqOKnuPwqKzYtePLRFD/AekSi/05OAxrQmcxhXXOYivudxkLP82vX68t
	3of60BvgdaL26vQkYN1BTYoJt4rI8j2ne0xBuINdOYFNFMtq+PNuqLeQwhqdneizd2h6tl
	M/Sv+c8/C5S1Cl5e4yEIfF+e/+Cs8Po=
ARC-Authentication-Results: i=2;
	imf16.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=d581dfVh;
	spf=pass (imf16.hostedemail.com: domain of ziy@nvidia.com designates 40.93.198.31 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794281845;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MK71BqVlfYYwLZUylUvFhYnPqT/9TN5kxAI3LNfAMeg=;
	b=sNcaPhPTPySb/aAtRrdXhzgRUiZEKmJsX5BVeo0OrR2cNJzPH3Jb4wY8C0y1RMNSlbzRH4
	ufpD9h0LoHPmKu+B1cGgAVx1X+Q89Qk4rjfwjLxcx/bAEoER6bymepK4CJF6pO5XyiHIYC
	1+D+gQGofvlO4/BKIKYn67lEMWv42ZA=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ksqFe0wv+wYywUvPROB4zvGrHX5FKbDnnhNpPnFCGmPdzZj8Cse5knMEp3F8xiryOq6I8/itWBzhRg59bC6wY3NPUK+uP/PkC7wy42IFSh/YeQ14TAG34/tDnwAFFMjo4rAnXmYKjZ8lQRaxZ5kVXdD3DmmeVbmSJ1UZSFwNm3LCiW0S2u7Du108WpZdIuFZtRfAM2MUAnxcXzvtBOr8Q7BNqc4jJIdNgCe1Y9N62+Qz9L8DQ7HaBMRyVnWTPTe76NeP8qyJ00TILtevnnDMLbo1k8biGdE5Lw3P9LSnPqQzbNjaKdaJjDrl0SbKArryoZdfjU8PUzs+I1z5AwwOJw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MK71BqVlfYYwLZUylUvFhYnPqT/9TN5kxAI3LNfAMeg=;
 b=PSVgO+0W2Ue+Tpx0BKc2Skfb3qTEUsgP6hiTVsPGaJ/2zuxsczucO1oK5udlhBtZo7PTFA/Aj/OZ2f0b2lczE509U+K6pTDzCg9t4iPwjjy9Dqf5N12eVgmuKh1/tsKaQujjSf+sprBOSjXaBqt1npApYck6Bz9d4I22KiEqd2LLqkQx93viqA7uVtDBKUuGLiu+6Fn3JyJN/g08R905PBQooNhjQ7YiKjkPXfcCURTeRbmPI0+CvgiS9WTPFGS4MYwDlKb5UjhmgPyoxgzsQiYw2EGFDnevRKeYBrSEHjCJoqb2gjrRGQ8hTmwRlnPYhObifgN1EIeQ70XDSUeURA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MK71BqVlfYYwLZUylUvFhYnPqT/9TN5kxAI3LNfAMeg=;
 b=d581dfVhyXhNzD5lcjDZyP8/1fAcjvJQk5fWblxLmmzhrGXvuW9RD3EDDufikQ888m7+ifXMcuIDevW/M2T+RM6eaVBarBILMUcLT67Z5jKT3Us2FnQo0B/DAnActkDmXGOGDqr3Rs6KR/TE6tJ6wBuBd+VTj346fUTueOuHXh5KJgjM7FnGpd8kaeYcsSpKBy+zH+ifrE4TrSrCH3JZADkSOypSbvRjqi4oZqjbMa5q5VMeiElfjnfjkxTYL6sVeneXKCrG81+b+mB1I3NC8WoX6TCns9BjkVXrIFHzJ6BR5FQpBGcdkgmI9Nx7fS7hfye3EtsUbRK++xH+r0bUsw==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by PH7PR12MB6977.namprd12.prod.outlook.com (2603:10b6:510:1b7::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.592.13; Tue, 10 Nov
 2026 03:37:05 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%6]) with mapi id 15.21.0592.010; Tue, 10 Nov 2026
 03:37:05 +0000
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Mon, 09 Nov 2026 22:37:03 -0500
Message-Id: <DMR7TM8YG70L.SE7L6ICQOOT8@nvidia.com>
From: "Zi Yan" <ziy@nvidia.com>
Subject: Re: [RFC PATCH bpf-next v4 1/4] sched: add helpers for numa
 balancing
Cc: <bpf@vger.kernel.org>, <linux-mm@kvack.org>, <cgroups@vger.kernel.org>,
 <linux-kernel@vger.kernel.org>
To: "Yafang Shao" <laoar.shao@gmail.com>, <ast@kernel.org>,
 <daniel@iogearbox.net>, <andrii@kernel.org>, <eddyz87@gmail.com>,
 <memxor@gmail.com>, <mingo@redhat.com>, <peterz@infradead.org>,
 <juri.lelli@redhat.com>, <vincent.guittot@linaro.org>,
 <akpm@linux-foundation.org>, <david@kernel.org>, <gourry@gourry.net>,
 <tj@kernel.org>, <hannes@cmpxchg.org>, <mkoutny@suse.com>,
 <shakeel.butt@linux.dev>, <roman.gushchin@linux.dev>,
 <yu.c.chen@intel.com>, <zhao1.liu@intel.com>, <tim.c.chen@linux.intel.com>,
 <lizhe.67@bytedance.com>, <mgorman@suse.de>
X-Mailer: aerc 0.22.0
References: <20261110032913.71974-1-laoar.shao@gmail.com>
 <20261110032913.71974-2-laoar.shao@gmail.com>
In-Reply-To: <20261110032913.71974-2-laoar.shao@gmail.com>
X-ClientProxiedBy: CH5P221CA0021.NAMP221.PROD.OUTLOOK.COM
 (2603:10b6:610:1f2::8) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|PH7PR12MB6977:EE_
X-MS-Office365-Filtering-Correlation-Id: acd01986-a9f6-4752-dc5b-08df3edbe3ed
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|7416014|376014|23010399003|366016|22082099003|18002099003|10067099003|921020|4143699003|11063799006|261028144727099003|261102123227099003|261022075727099003|261022105027099003|56012099006|261021123027099003|261021121427099003|261026140227099003|261021135927099003|261009223027099003;
X-Microsoft-Antispam-Message-Info:
	OxauXoo+V2fYQWSqWrFocTC4dM0UWzeKkcJD6JFVmo1A0D79zgobNUyr/bNyzGQP81tbwMx55VCGBynJDhAbxA6FrriEJlgrBz/KcyntjfJuWtqg2v9bgqvnSJi74RKDD/SOKP6Kj6r4q7nLmwqhT2kDjc13HB0zqlIky8yl27lmyH7e6qn+zOIh7vm8Qe5N7jHbsmda8DzyDF16Y/Jjw8bDXacWhxqP9Euu3QLhUrvGdZHj6Jemb0aLshqqWFZsq10m++Hv5er2qJxBQRJ/xRPrb1ovlychmfxe3WvlUkgDAXyk3Cdt637Us9oxr2AYIqOX83otDdf5J1GG1QoB6NFaTyPVzCiNoxAFSmEmNkK/WKmufdwukEhK53UVAa0ktFuWd9HSpUyhbESKHcBSKkldPGEUkl961PGJqu8uFnCte6T0vbWqpCTTZ5kYj2wx25tH3tLAVeHcHHYDYvfl+QvhI1jgZ2Y3OQHbw/Dx4+S7nIkawV39JPiyKOjbIjTlvgyqkCFRmSc5/R6YrTZNvtJwKWUdG8U2JtTPWoK9yNn3hmpnXH/XHTvyTqKLfaH0MLKmNlIEiJF//8J6MJcRqJpPBur3kjXTBFkBrdAqqJrEqiXZVpmPMwAObsjMrS+syV3/MPquXoo4sOJeGPQnuQvUwMRv0hhQ7chux9tzvEfFrjbNUbnwwJ9vwYiR4vttWzEN6HyE0kCYtuV+byf99A==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(23010399003)(366016)(22082099003)(18002099003)(10067099003)(921020)(4143699003)(11063799006)(261028144727099003)(261102123227099003)(261022075727099003)(261022105027099003)(56012099006)(261021123027099003)(261021121427099003)(261026140227099003)(261021135927099003)(261009223027099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?OXF0TWhzWVJyZ3BwVlNDbUhkam9Xc2dmUE1QeXowQkplR3RaYTBqOTRRYjRE?=
 =?utf-8?B?TEJYdHFEdzZKZzZFV29vQ1UrQjE5MGV1ODNqb0w0bERuZSsvc2VEaldraUk1?=
 =?utf-8?B?Qk00eXRzUTF2MzN1MVRCVGhHT09ma3JhYVgyYTVOTjd6eFFPaEVkWTRJVlVD?=
 =?utf-8?B?RVY3WllhVWYyRGZUbnc3eThiek5XWjlOcWwrSU0yUHQ3WjNQMkJMOWg3K3Rh?=
 =?utf-8?B?TGxkanA4N2h4Z0FqNTh2MzRERjVxaTljRTN5cFRCeTJpRGFqZm9jR2dLSzU3?=
 =?utf-8?B?MGtRNjZKREVTMFBUcC9Zb1RneXpYcFBDMlcyajRxc0JLOWcxTHkvZHgzaVMr?=
 =?utf-8?B?SFlPRjVqY1M1djNPMGR2Znp1TW9sSmpFaXVIMmpFUnlZOEdMNEl6M0MzZHA4?=
 =?utf-8?B?a3NJT1QrQzJZWThQM1AwSythMUpHRXF1bXZhTFNzUXNZNlRlSzlTWjV3QjVG?=
 =?utf-8?B?WlhkelBvS3BVRUp5QnNUTGQvVmFBNGJyNnBZYVFoQUJFYXRZWXJoZFl4UW9P?=
 =?utf-8?B?UzZBNnpsK2h3ZkNmMnJtYmNxRTVqSE8yRlNMSEVrYzFOcjltc0hCd1RaK3RG?=
 =?utf-8?B?dmZsNFFPMHNidERIQjJsbWpOTmhnRUgrU2FoQnpMR2NZNkcrc3lGa25vS2ZI?=
 =?utf-8?B?Ly9ZT3g5TnZaUUI4VExyckt6Y0x4dkhSb0FzME9pWnFSVU13ZVNLZ1JUc0lU?=
 =?utf-8?B?VUsvN2N1L3ZjQzQwbFJ3b2xRbDdhQnhSbGxFWGtNaFFkK1BmVXlzYzcwTUhS?=
 =?utf-8?B?ekJuQmEyWHpHakU3VEhhTlZGRSsvY2VtTmczQ1FtdmJGcW9EczBxRUMwSDZC?=
 =?utf-8?B?M05PNXd5Zk50K3Z4cTNGOUcwZDZrWmhzS2FocUhVaGFtRlI1blc2d0h3TERr?=
 =?utf-8?B?ckwvY0F0SFpLbzhjS0ludmlpTUdVZDNtVHErRWt0dU43Z1VNdWd1VkhlaDJw?=
 =?utf-8?B?YksyYkhyWmNZOExTVExITTBzcnYzajE2dy9qS3JyVnZ5YkNMdHIvTXpKa3VG?=
 =?utf-8?B?dldpQkpkZUtuMndKdWlnUXlBTlZiS1ZWQ3Y5UStpQjg3R2RvemwvWktCS3Jh?=
 =?utf-8?B?bkpqOE1oMjFTQWI5K1Q4cHdtZzV2MlViUUhHc3laT3c0bWhkY0hPTElWZ0Vv?=
 =?utf-8?B?ZGFhTnlpaXIvSTV1NVRhaFF6NVh4c3JSU2xoYVZlZVhtNzNMeWJsV1AzSVdV?=
 =?utf-8?B?eHBRbzR2QjRqc2dxWWE4UEVHaStMOGgwRTM5WU1yQWZuQUVNWm81MEFiZGI4?=
 =?utf-8?B?VUZLTElCSkJhYVcwOGRTZWxrdVBNUS9BcDQzMGZzMlRaa2pWdlk4Uk1GRUF6?=
 =?utf-8?B?alpaVlFPYjFjZ0dNcGtZTVVNbll4akJYV0prbkpjSVR3VUQ3MXY5TFEvQWZx?=
 =?utf-8?B?amZzQUZTN2NxcSsrWE1xYWM2SjZkN1FiNGRDUlRSQ3ZKOXQwMEFCaFRyUVhh?=
 =?utf-8?B?WEhXUGg3Wmp6MHlwR3J6UFVUVjNNRWpZRlI2aUNkWTU1YitKaXlJRUJhbUEw?=
 =?utf-8?B?eUdjc3QybmNiMmRYUkFsTGU5RTNOTVFyeHdkZjlxb0lyUTE5UXNDakxOZnJh?=
 =?utf-8?B?YWltRGlIQ01lZUxyWHpOYk1JVjVjb3RPcnBKUUUyM29oRlB0enBUZ05MNVcv?=
 =?utf-8?B?QlFOL21GV2xEUVJMeXNvM202TVprZTIwcTdQcDVNRFRpMGIwRXlOcHNjajlT?=
 =?utf-8?B?WUVDc011TnNwZUVXTW1nNGVWSVFjOGhDandXR3NYNyt1TmNsRldmd3AwRXhE?=
 =?utf-8?B?M1lXWngzNFNtK2Q3QnRNdXJoMEZVbTUxY1ZqTEd3WUIyRmR3MFdna2dBZ3Fq?=
 =?utf-8?B?aVVqREU5WXJzdkNwTnk2R0IvZU9TZENtZFdiWmZxUkpmVkJwVERMREpZMjJa?=
 =?utf-8?B?eVY5YmZCK2lpQ2tFd21reTlFWUppS1dIbTZHVm92OS9SZjlVbXhGY1RKVkt5?=
 =?utf-8?B?RmpZSUEwaWNkc0hKcW5JK0FqZ09hbUJONnBLTGhnckVvSzM2SHBuemFZU2hr?=
 =?utf-8?B?YUpOVngwUmpDS1psTkQvVUxQNjR4Zk95M1VnWWNJUFZYZXljdW5MV2RhdjR4?=
 =?utf-8?B?RCtSNXJRd0ZkVVV2NWFPU256YjI4SkF1cWNPTVBFR0VCbDYxWEhLSHRIWHFO?=
 =?utf-8?B?Z0RKV2RrZUJNakhYM3RwVEh0cnVGMWxiV3JZWmhFb09lWmRLUFM3YVFKMUND?=
 =?utf-8?B?UW5VZ1MvTkJoYlZDYlNqK2c2bnlaLy90SXJtalE0QkNBT1NRd2JtRHFQYkps?=
 =?utf-8?B?SjA3Vktva2ZVRDdJTFE1UmNtWXBwdG1IS0FZTmpVSERGRWlnV2Y3UStTWnds?=
 =?utf-8?Q?2i2FJ2MP3lrw5inSE0?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: acd01986-a9f6-4752-dc5b-08df3edbe3ed
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Nov 2026 03:37:05.3623
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Pn6K3qDmngmMfcDVVtZXGY+BDC6JDqUVurSYCtx44u7Yej9uI7NhPU+zis55lNQb
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB6977
X-Stat-Signature: aqr3oncsz7jodeen9ugs1brfghxpk4iu
X-Rspamd-Queue-Id: D4FE4180003
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794281844-264867
X-HE-Meta: U2FsdGVkX1+NnMpRYHp6OHDvxaTPl0MKukRNOV1mUM6/nj35AaiQch/giPCW5rKTI18JKvwasbU9WtXI9PlPGZg5JWe7BfgOj1nYT7qLSnpuFKhqt7Zclm77HA8wUkII58ivwiTPPpjKUmAL5qtANr0PfJS0i7k3Esz3P8leOpzftEzCeM0PIB8Zb+4TqpcUz/o+6pUkaOOqPS19XKhLBNaitVkLYNrWUCQUH/WkmF2FIMRpmAvNVJdNv4cgRmXLoNDX4FJXpSrFf3dccbN7xS56Qsm5hB1bVsuVk4zXusAegSnUmtyXN9P4oSTBrfzlRFkeQVVrd/bWy9s/BaFiArI09BPI+Fvdvx9GgL5Nq72Tsul0uiuPUPfLCYd5M2sLOXFGeTqaDzPfzeDTCe/WwTZ3WGAml5/MTqtm48XT2s4mbogN5UoIQXWuh9lo9IBbzkE9bN87ETkrYgiG26n0+/H6yeeKtTB8mLq4S2xQDEHZKzW/U5XBo+1UDVWTldXvEZosaXwT3Jb7iU51/UcmYlFV0k0+ZhX2VBkAck8QFhFb7zj77HN/UhWVEsdWXOhKhu8srQRHq0r+M4CYFGOArL9P6gqNUgZ73k30jr5XbDXV4k4LR4Yp0p9v8hhUGWCyE11gwzS9OIjAsxMmdfS9cz/0maJ2BFBO14tBCgjLAIb8FCBA9NdfsAdvnahY4zdWWb3QAxu4ZozmtdtGapCK572Za5mt6scrav3om9FlA4DdAc7S5rSBoKCZyRjIgOIQxcmuakSLcVFlkJSA/dZN8BGLlWEEE9XXgg+VHyAoRsGIJu7bpP0/+6yCWeAimmyW0nC2Q/6A+e8YHHkWjtxEkXhj6EPJpKZwe+xAT2FFDUcVaJwQkHHWWBZ2J/B4W8DmFWJlRUDPrOHR910hdX3KOICRK37mi8mSW736N25XIEzm7xAzo/s0wO+s/LS4YL6oheNwkEoSe+mGthhlVJp
 r0w7f7ql
 B0T2YJE9BQSe0ytRnaL1IInlNSZx7aJ2KNm5/ueci4N23h8lWhiafxCaXhMtSaqWjwI/z9HKRg0+o47/qnDSDaUlZ8dAEKr0gT65j18IvWNA1qJk2oZp47LSoN9WAL2YWjykT4eHqaydz9JeH9MkrHD0b2tO2ITPSyw2Z7ynscd5xyoyVyIFDYjkz6AYv2TICqn/PmQVyN7rcmIYdNZ6ZZxGUYSEDZ0DxuTSIGH0//mjYlSmS58JAdtik9Ex77ZePrfK0qHPLE6MkriNoBOe9Y5qBEthLPADlTL6VZqbMNQNghc5m2vvV23HazfNHzCU9rd/A6+lyk8zFk8B68PxYFZEJSPGkNSsxnc4JeCnaJXvoNV9Da1nuohytyVC18lvk/6HuzFfzbFrwni2sH9ye0sXqm0bkxDCciNKjlrH8ybNe5PVYRdH7Vo+NsGLglY39utOJMfWFuW2O6ml8ctlPN8yru9/onKmYleUJtN0jRuaCdxprAM9bfJ26tbRzdNhwM9ymjwyckJddLHw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon Nov 9, 2026 at 10:29 PM EST, Yafang Shao wrote:
> Introduce task_numab_enabled(), numab_in_normal_mode() and
> numab_in_tiering_mode() to replace the direct accesses to the
> sched_numa_balancing static key and the sysctl_numa_balancing_mode
> bitmask.
>
> No functional change.
>
> Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
> Cc: David Hildenbrand (Arm) <david@kernel.org>
> ---
>  include/linux/sched/numa_balancing.h | 36 ++++++++++++++++++++++++++++
>  kernel/sched/fair.c                  | 22 ++++++++---------
>  kernel/sched/sched.h                 |  1 -
>  mm/memory-tiers.c                    |  3 ++-
>  mm/mempolicy.c                       |  3 +--
>  mm/migrate.c                         |  7 +++---
>  mm/vmscan.c                          |  6 ++---
>  7 files changed, 57 insertions(+), 21 deletions(-)
>

This looks like a nice cleanup and can be picked up separately.

Acked-by: Zi Yan <ziy@nvidia.com>

--=20
Best Regards,
Yan, Zi


