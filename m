Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E0AE9C5DF89
	for <linux-mm@archiver.kernel.org>; Fri, 21 Aug 2026 14:25:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D021C6B009D; Fri, 21 Aug 2026 10:24:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CD9C36B00A3; Fri, 21 Aug 2026 10:24:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BC87B6B00A4; Fri, 21 Aug 2026 10:24:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 846666B009D
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 10:24:59 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 1BDF01C00D8
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 14:24:59 +0000 (UTC)
X-FDA: 85125498318.19.7204CA5
Received: from PH0PR06CU001.outbound.protection.outlook.com (mail-westus3azon11011032.outbound.protection.outlook.com [40.107.208.32])
	by imf14.hostedemail.com (Postfix) with ESMTP id 22E3E100003
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 14:24:55 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=jzV7ECDf;
	spf=pass (imf14.hostedemail.com: domain of ziy@nvidia.com designates 40.107.208.32 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1787322296;
	b=TBdU6ZgqvGurL6ryHdsO9pQvQwsMUhLv4nIQ6M3cbjAw+wBD8S4JTQG5pGUjEzZZWpXCna
	pCV1q3TSxclF3UCLlO3J5tgGM4GAz5Y0UyyKdkEhLHFy5VJKjkmyzuYayHvSq4GpS46Zw5
	/4S9UCgHy8s8Czsxz7SFayX2r5PIxVM=
ARC-Authentication-Results: i=2;
	imf14.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=jzV7ECDf;
	spf=pass (imf14.hostedemail.com: domain of ziy@nvidia.com designates 40.107.208.32 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787322296;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2Jwl0Ojc5DlQcGwW+CEMWKzfKrDDywfKjSAnRtWMucQ=;
	b=D6AzvLXop58Nur6wv5arFt5JpWpcMQmuce2ae7xUoFJZWnIvdZJvfxlM9HCQX/i+flPPNy
	pKRDZFAY/mDjh1+YZDLizlBaEGOYJsQwKQTPPVA0rno6cH6NvcUT3MhbzVDX7tBXcAEyUC
	tHs0Kea+jMQwB1lCzjUpbvy/457mud8=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=NVZUF5csB3h+wEh44MVC7+H1vYYLFeK+ZGXV/xCmqk3Qzn+zInIyoY5DrXjkB+9O6bPJ/vEN2YQMH2bXxYHbTOAXFlxeRUb/CVv5SIyQYXrKOIwXzygQwaoDV0EazkfqpnY8xPkaepDpv0Sw96bTinOtjplvFcXhuXQFdiGF02V8djskV9jmuYv5P97s1wv05do1HTvt0Ay3irNgdW4VqbLXKlg5wByfXpb2hiKnzqAsjh3Z6RTXYIrR3DsffauF2yyHHWz8eeBsT4X8er0CXnrBX5JWc8Rq4kucXFDvJhCjw0rtjnEPFpf+dl6TwKWMeq47BhLBERviIx06pBV5RQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2Jwl0Ojc5DlQcGwW+CEMWKzfKrDDywfKjSAnRtWMucQ=;
 b=RWRw4FDnElbduOgvbwtaZvKPwVErhtKoW/ONF4s7bk4XIJEev2h6TvF2PQt5n2mf003hOpveHVDvhKMiOXrGAd6TtRc7h+neBOmPvT4x7b+IzvJjdqxxU7R+rteuSrs4jm5u2ZcNHQd+RJnI+7AXvXdFNWisV83VD5T5mk5fj0q638UkdY7BXuNuYW8UZH6GVwINq8mCMfWIOKswebkd97v+uyfWXTeKPiN0LAO0JCzViysH++pPx1v3Jf45UJ2SAiBSALGiGrF8Wf8TNpcU6FEkFE3U5vBHgz2+l7bZQJKQfrX9mepvckekHDoa24xm0N8YdOrWhQszupFdsl1y9Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2Jwl0Ojc5DlQcGwW+CEMWKzfKrDDywfKjSAnRtWMucQ=;
 b=jzV7ECDfafC9CJKhftGhLVW5f9ZVRwlit4dI+CKtwUmk4aVpkhZC7yDKtzpfDE8roGQQs0IqoolV+yoWiF8LyeNqLMJU4awqXmwT2lv/jGbeoZBRKgMaPjXwYTULuKLsh1TdwOQyEn9DHn828WsVGMxOst2LMc1Jfqhs++ZAPsG74ewA7hiD4n0Z7ogfqvsIaM/bNm3Nvqk96aky+4f4XmcGqmeeWqw1ECREcJWNQXsamDNfd0RmfTegur5zleqfado5X1oFGDlWxKO/SsJPnugrEpOXhdc4CpkDkWrCknkqZAMI3SAUnh+UqfEc/UjHJlRJeMDGxlP07N7p7pmoKw==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by CY5PR12MB6406.namprd12.prod.outlook.com (2603:10b6:930:3d::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.339.11; Fri, 21 Aug
 2026 14:24:43 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%5]) with mapi id 15.21.0339.010; Fri, 21 Aug 2026
 14:24:38 +0000
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Fri, 21 Aug 2026 10:24:36 -0400
Message-Id: <DKUOVAQ3T03S.14GFWAHY0I6HO@nvidia.com>
Subject: Re: [syzbot] [mm?] WARNING in ep_write_iter
Cc: "syzbot" <syzbot+805630f1453e490427fa@syzkaller.appspotmail.com>,
 <apopple@nvidia.com>, <byungchul@sk.com>, <david@kernel.org>,
 <gourry@gourry.net>, <joshua.hahnjy@gmail.com>,
 <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
 <matthew.brost@intel.com>, <rakie.kim@sk.com>,
 <syzkaller-bugs@googlegroups.com>, <ying.huang@linux.alibaba.com>, "Greg
 Kroah-Hartman" <gregkh@linuxfoundation.org>, <linux-usb@vger.kernel.org>
To: "David Laight" <david.laight.linux@gmail.com>, "Andrew Morton"
 <akpm@linux-foundation.org>
From: "Zi Yan" <ziy@nvidia.com>
X-Mailer: aerc 0.22.0
References: <6a820ebc.9ebadd4d.20b15e.001b.GAE@google.com>
 <20260816135201.98590b17b526dda8c4ec9105@linux-foundation.org>
 <20260821093039.04538795@pumpkin>
In-Reply-To: <20260821093039.04538795@pumpkin>
X-ClientProxiedBy: YQ1P288CA0007.CANP288.PROD.OUTLOOK.COM
 (2603:10b6:c01:9e::12) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|CY5PR12MB6406:EE_
X-MS-Office365-Filtering-Correlation-Id: 0fa3f5e5-5bec-4f7c-2e64-08deff8feeab
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|23010399003|376014|7416014|18002099003|22082099003|3023799007|6133799003|56012099006|10067099003|11063799006|4143699003;
X-Microsoft-Antispam-Message-Info:
	t9aJ/9FmU39fI1Y9pbGwzF4T+baxpUQ78J9524vWYj/glCqBTt3hNSi5ztzOFjh4IskEdi08rdSln7OQPpU3X3bOcLQp3we1GPooftTe71sAdd5dOY0UGcROO17TS0uGKyZuLitt1Vea0R7iDT7pSfKzssAZGmjXbNhLOMYfydb/ITcewDKKkjLtNAAGIFaTvcr15iwGRyua/3fPaeGl2snlI2uy0BrURa5UA92SVih1ZxaF1lau1v4nnip2x3VHIkEmYIu/oA9n/nNl8+wuiMb/YEtAOqd541iRKZdP1XCR1ukL9gvS2P3IDxfsXAe0a059tct12YO7LF/P6HeezPK28bBAaNMmyCf0HHP1HiS//hLSWLa6V4LXgDmdrDl4MKp1XS1JQkEqimEojmGv1BT/JWsdcXiAs1SMK/CDOyJKd7gT1VD52tR3bEHYL149k+y8jmxIY3kvHos21JWjAvhK7diD+15W2Wybfxwqr+GVr76Fy67nwsvE1hWsM241QYTlJY8SbftGad59RLUUnkcWIv2QDKfT7wFYSelB1BfWeoYyitvFFhKoN9DVrrvZMXaV3ZgcKO5DwNHTahHPXSKxQ9SioxCNM9IK4a3I4oE4YZLgqnBZXf3U9osgv/HS1ygX7R5EjC9VynIbHOAGsA7oNd5aHnJcv+DqYbGtxUw=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(23010399003)(376014)(7416014)(18002099003)(22082099003)(3023799007)(6133799003)(56012099006)(10067099003)(11063799006)(4143699003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?TUhmZmdIVzlFR25uU0JsR1VNSDljdEs5Wm8xdXBmajNkdDdOVW1hSGpYa3FF?=
 =?utf-8?B?UWZPMFZuRlJCNnUrZ0RwSENQTHNwWC91bWdGL01zNnpGSUUvaXJLWHdoM2Fi?=
 =?utf-8?B?YitFckRWYzZxeXM0NWg0dlVyaUszSFYveGhIMlRXcnFpelBsaE1qMEdxVmhK?=
 =?utf-8?B?SXBYZWFUOSt6VU4wUHNIMFJBaHB4SUlYSHYySVJKOVFoZXpJN0FsbFhCOTE0?=
 =?utf-8?B?VU5GV0paV2FWbmFmSVIwKzluODJIRWh6bm56RU8xaGM2N2dXcUhzS2dDZkFB?=
 =?utf-8?B?SzlGVkJQVWx5NGZhd3Y4cVFrZkZRUmVQOW9RNktvNjE4SkltRDNRZW85NC92?=
 =?utf-8?B?QTVFNnB1NGU5aWVGbG43WkdON1YrWlFvK3RCZURSdzFPTSt3WVhrbVpPYnJa?=
 =?utf-8?B?alNDYllQejlLMG9OZFN4V01GRGZOdSsxWXo5S3J0U2VuQlNFQ3VnenFJVWxa?=
 =?utf-8?B?bEtLTEx0MmNLNURVUzIrckVDM3d5aXA0Y3JHVXl4SE16dmVQb090ekd5bkRl?=
 =?utf-8?B?M3JmejhJZWEzbVZYNTg5QlFGbGZUM1I3MmVqY2JuT0VJS2dKd1NINy9MR1dv?=
 =?utf-8?B?S1hMMHViUWQyR2RDc1oycEdiU1ZrWStSaEJMaFBoc0psaW5VTDRvd1FyY3pU?=
 =?utf-8?B?bVdrZmVLRS9TUk8yM2EwOHBTYlcyeDZZWmJGOU4wTUwrc3hSSElxUjFlcmN3?=
 =?utf-8?B?S1ZZY3pJTW9BbVV6QzVNR01nZjFqRjBla3VVZ0h3R2FFRHdjdTVTUFUzTWQ3?=
 =?utf-8?B?ZHhOQkJjR0VMTEkxMkV2eUJsK1lqRjRWQlB1cFFKeS9iSnU1bm8wWmNmVmVs?=
 =?utf-8?B?dmJSaEZLZ3NPcTV1UzAwU2dxajMycjQrUzR3RzFWc2dQMjgzM25YSHd3dklT?=
 =?utf-8?B?RE9FSXcxYk5xMUZJbkw0aWJmY2dzS2dMQXF3TkQzVTgyRmJpSWRxN3JwY0ls?=
 =?utf-8?B?ZWwyK2dqbGs2N2w2djh4a0wvaWhWaVpUblZJc3l5N3ZaeUxxQ051ZzE2cDYy?=
 =?utf-8?B?NEhQRWZ3SU1yY2VaeElDcGd4RFVnUHNKM0J6blEwTHNvOTBQamp2RHFwRjI1?=
 =?utf-8?B?a2lSWnBUVm9qMWpCVEszY1JqVEE5Nlc4OFJrM1kwUUhsMTh0V1c2Y1o3V09R?=
 =?utf-8?B?aERDek5RcWozRTg1N1NOUERMQzBoUWdwWDlhTG1TVy9VVHB4cUN4VEt5UU82?=
 =?utf-8?B?bkI5SmhtSGtwQXpNZUkrcnlucEdjTHNBWi94TW9ueHNXdDhyeEVlT2RvdnEr?=
 =?utf-8?B?MWpId0JvNzZZN0hEYUZiTHIzOFo0UHJldllWVmFubElDSjRUbXVtR3lvTnVZ?=
 =?utf-8?B?ZnBZWTJEOHpQNHloR3FZSURHZzU4ZGQ1ZHZsUmdjRC8vRnFraFFSTDJZaGw0?=
 =?utf-8?B?bGs1d1RBMWU5MHVsT3o4enhORmdEMEUzUHhuZVhjOGhCb0NDTWRENWExQVc5?=
 =?utf-8?B?QitXZGVDNGFsQldyR01xV2NyN1Y1YXlUNnRFYmI5anFqNHlUSk5rN0pRMlNU?=
 =?utf-8?B?NTZqTFZ3WEJVRXdVY1RPK0tyUTgvVGVCZ0NTbzRDS29CNDFMQWp4cVlUOHhS?=
 =?utf-8?B?VE5EaTFNM3FnNmh5OFFTSDVOdk1LQ2lQQkhmTW9OSWw3N3VWZTZiWHBqR1d0?=
 =?utf-8?B?T0JLZjdQT3pXcHdWWHNJTjhpMWlCTVloTzNXZ054RllwaVlvbE5nSnlrWTI1?=
 =?utf-8?B?U0tLSExVV0thU1VYYnFsbGU1ZG9yUHJSRjFvYWsycnV1MjdCVVJMOTc3R3VB?=
 =?utf-8?B?QjRHbC9jOE5STmxsTnd5SXNBVFBwR09WL3ZYZUQxMVNBdlRsRjZveDZycm55?=
 =?utf-8?B?cWFiQUJJMkxLSktYcTYxcUtTbWdyNjNFeDFvODhpck5wWWh1ZkVHTDNrdHA4?=
 =?utf-8?B?S3FBQ3hDZjhKVVVtWHIxb2lpaWxTVUFwSXdoVlg3SkNiVDQ5SUFqSWp0b3RE?=
 =?utf-8?B?ZWhzTzJseFBFeGRaMkxSaXhnYXpGcXNwY1RRRktvdzRiK3VaZ3FmK2dLcTJB?=
 =?utf-8?B?RmJhcEN3emNhRzM4NVNCRjIwNEJtREs0RlpacWFlNnN5NkR4Y0s2MEZlQ3RI?=
 =?utf-8?B?Wm1XOUt3OERoWXhON01qdG1XQjFRZGsvWTlmZkVRamV3STI5NlYremhDdFRt?=
 =?utf-8?B?TjlrdTRGK1VXZ3BJTGdJYjFOSFJiYTVueXRBZzEycHdiUE1wR09IeFV1S2tO?=
 =?utf-8?B?RS8vNkVscEw0bVAyV2xPNHcwQUxLVXd5eWhvbkduOWxGSzIvcU4vTkh6U1NE?=
 =?utf-8?B?MFg5bk5FVWc4R1lhdlU5OVMwcHFlUGRTZkYyZTBKQlFJYityK0xIS292MENN?=
 =?utf-8?Q?SshqEgrU08l70EcNxH?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0fa3f5e5-5bec-4f7c-2e64-08deff8feeab
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Aug 2026 14:24:38.4057
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fd1UzCVS2JjEqulFz3M19y5jTT2chsl+c6Pnce4hYva7syNYKrXh5tOBaBGPm+x/
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB6406
X-Rspamd-Queue-Id: 22E3E100003
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: ugg8um99hnu8ik5c4zth36p16sqkw6at
X-HE-Tag: 1787322295-887160
X-HE-Meta: U2FsdGVkX1/vPsXsneus/UFb++zxh49nnTe8eadvh63zkZCmFcz5KpNaoLDnJCeZr+/1JWGcCOOuqmUa8shq8NGgt1Ju+REK5/LKOhZl+TWt81NOPc5bjQxJPv7rnCNwwTJ/Q67N+oqbPC2bmqa8s8kDlh39zIZAhCfI5Bjy15FwGABICJL77GaOQvDQpKE+pXfVCYvM33fpXWZi++TfHvA29bbhA4hDpCTEDeAvivWmEG/J8GDTHnATFPyKYcDH8nSvesFsxqkkn4Yma7h+hcnYrErJ9vOQ/tM4VNyBj0qZZNXP/82yfrRRHbJBEsmn/QmqqC14le3e4HxQr5SmcBD1EZ4WsVCrmMOrOvpvt5bNtCCg4yxQQPIXq5cERth5nPfh6RVq8RMDgEGyclakeAiOY0tsvMzmzRgPnrXxb1Y8L2qm9YlUPf2iXrUejSKlECfDhfHfFp4dNni56etRXqnfLa84YDXtFNe4md2IGN06QWxB4AiTCsFhLbhuid0SN2DnlEirGUSGZkAtr9B9bd7XhajMceYy93o+6P8q3oNRIpg994EOiYZZ4aevZmWj8ZzrpZ2qsUslvE9X3WHu5nBPLgloz/YDCr15GgXXrdAFN580LruG6lALBq79/RIbMfDwlvDh2Uls46sOLCfBUsRtOqPhYFinbq/bMSqaRHGe/27hV8PhYMf93AFr973QbHZkC0D6fjfxVCLoZRj8cX9rXQWPQvN7RGmWxqd/hLYw/K2dkWn0LOG+P7GheeXowjRzQ9RGgLy8uSDiSj9nuMqN7FYCtecXExuaqwJ6dmqScg34Jp+JRtOaxp9ot6W97y4mNYkIAZKnlrjEXO21R/n5Rb9Q1i/JmCUZSe/oXwcVIS2tOSQKBRdr3CcvEIsOTkRVm9Npdp8uSR10wXwnn4BLvsx6PAfAuTs4NCQ4JxTaE9dpjC3KDCYQk7EtVaAjbWXMMYP/jUfEkN0s8SM
 Yv1ENi7t
 P6tg8cp7Mugb+prlsra4hIAZFhH0ttltYVNJ4hO6+8BrdzYqdG+987IYqDiD3JMbn+L7XvT99Lu9oM3mWc+5n9OEx2xXLpQmSHpF4hJHPzD3SSmdrGArF8gj8eAmrvzJXPPE0fWAZz+Gm9diDYTG+qYV7jAYCUlBrzUq7u1c9qTs8Edx6u2gO+9laU+jI9II4CcoZGRKKj91CzG4tT4W1LELQaWWGNL6L/7Ms88UXXTlI026tM5qeA/NXnzZnSwswkC71mv5Fzt6QYkrl8b6SzLZVzwRWaKZ7cDDGO5EuOsaJCm0QG/r2/t9x1R1o1T74Fn0XkTvJ1rv1s94u6Li4qPo9Vp5p6C7xDBVX8rieN6We3eSqoyOQ4o8J4wqIVcM79mg8if5w/L+G/8svVCv/BLPK6CAM6BO8zh70w1zQQC/bfKkMlrQGw48PiqTRe0usuKbJ0bdiCnjau5f1BBLEvpZcMK3++/72bH33e5j2p0xr2trG5Y1uCxobk7vKDwRrGoVAw76yWdFoO9WzyhK9/VayxN7ZgknpMarCqBlrcykIbVnxDBmBbbOEo0gIVL4qv8mE7FGVl3dluaOkf93aa11Su9AIgXe/KSTX7jP1ItlILg9Ym340PY982mH6k+aAftvpczaj9qvkH+DF1w6K2SiVkzyio48ldj4QoJ86CT0CkvpZYxLvX1n/7iF9Ib5tGcR1HRVdmKchXGnOZlKtqZfZGKLnW30XqVsOTglPTK1rE1qfc13VKtVd5EmYSMyG63bxiyByImOxiQYPzREZENPTeyU1yPDoCp3CbcowcmDYy2LhNshNaX5Xo8JPtnUNfvhqXnQU7f+EnicDVwuVPBXJpbGPwmoAP52CJALHoIMGJtjD6PFpV8An04IJsTY8EFbwUvsctPpXsE/oqrO4qanQ8UYOKr8xMJeQ5rZ2HNUV3e16D+rNcNWSKP5ZnHSA3h3oV/16hKg+npDNPruhu/f75nC7
 6+wBJ1Ys
 zLmw3LM1ZdRouevHXw1vmFaPLDQ7JplLy5bBXeddnBod6Uu2q6LfWFiavnJXiRUhAkdoo2KCXiaLpIK/+p6tgcwWLMU2itB/brs+aTnB9/hnKQx09tJXd/owFHcKez0JKSCzDRirnbgiJbrNzwzO5dWZpMEilEDhU4I0/SBhr8R+mOEOfokgIx65KOALMVWPlVGOI1VnNOJ+XkG3TdPTMZ55Gl+A/nyV2zUcsaxoToT4YTHyac/FMw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri Aug 21, 2026 at 4:30 AM EDT, David Laight wrote:
> On Sun, 16 Aug 2026 13:52:01 -0700
> Andrew Morton <akpm@linux-foundation.org> wrote:
>
>> On Sun, 16 Aug 2026 12:25:48 -0700 syzbot <syzbot+805630f1453e490427fa@s=
yzkaller.appspotmail.com> wrote:
>>=20
>> > Hello,
>> >=20
>> > syzbot found the following issue on:
>> >=20
>> > HEAD commit:    3d6d817622b0 Merge tag 'scsi-fixes' of git://git.kerne=
l.or..
>> > git tree:       upstream
>> > console output: https://syzkaller.appspot.com/x/log.txt?x=3D1592747958=
0000
>> > kernel config:  https://syzkaller.appspot.com/x/.config?x=3Da59830cba9=
1a1981
>> > dashboard link: https://syzkaller.appspot.com/bug?extid=3D805630f1453e=
490427fa
>> > compiler:       Debian clang version 22.1.8 (++20260613092233+e80beda6=
e255-1~exp1~20260613092250.77), Debian LLD 22.1.8
>> >=20
>> > Unfortunately, I don't have any reproducer for this issue yet.
>> >=20
>> > Downloadable assets:
>> > disk image (non-bootable): https://storage.googleapis.com/syzbot-asset=
s/d900f083ada3/non_bootable_disk-3d6d8176.raw.xz
>> > vmlinux: https://storage.googleapis.com/syzbot-assets/d19e0514c02a/vml=
inux-3d6d8176.xz
>> > kernel image: https://storage.googleapis.com/syzbot-assets/f6da706811f=
4/bzImage-3d6d8176.xz
>> >=20
>> > IMPORTANT: if you fix the issue, please add the following tag to the c=
ommit:
>> > Reported-by: syzbot+805630f1453e490427fa@syzkaller.appspotmail.com
>> >=20
>> > gadgetfs: bound to dummy_udc driver
>> > ------------[ cut here ]------------
>> > 1
>> > WARNING: mm/page_alloc.c:5280 at __alloc_frozen_pages_noprof+0x2ce/0x3=
80 mm/page_alloc.c:5280, CPU#0: syz.0.0/5319 =20
>>=20
>> Thanks.  drivers/usb/gadget is the offender.
>>=20
>> Gemini sums it up well.  "ep_write_iter() needs a bounds check prior to
>> memory allocation".  https://share.gemini.google/5NzjyttO0ULc
>>=20
>> I expect an easy fix would be
>>=20
>> --- a/drivers/usb/gadget/legacy/inode.c~a
>> +++ a/drivers/usb/gadget/legacy/inode.c
>> @@ -666,7 +666,7 @@ ep_write_iter(struct kiocb *iocb, struct
>>  		return -EBADMSG;
>>  	}
>> =20
>> -	buf =3D kmalloc(len, GFP_KERNEL);
>> +	buf =3D kmalloc(len, GFP_KERNEL|__GFP_NOWARN);
>>  	if (unlikely(!buf)) {
>>  		mutex_unlock(&epdata->lock);
>>  		return -ENOMEM;
>>=20
>> or do what Gemini said.  Me, I'll add some cc's and run away.
>
> Should there be a separate flags for 'request too large' and
> 'no memory available' ?

What flags? Are you suggesting kmalloc should return an ERR_PTR to
distinguish different error types?

>
> Although the errno for 'len too big' should probably be EINVAL
> not ENOMEM.
>
> David
>
>>=20
>>=20
>> > Modules linked in:
>> > CPU: 0 UID: 0 PID: 5319 Comm: syz.0.0 Not tainted syzkaller #0 PREEMPT=
(full)=20
>> > Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian=
-1.16.3-2 04/01/2014
>> > RIP: 0010:__alloc_frozen_pages_noprof+0x2ce/0x380 mm/page_alloc.c:5280
>> > Code: 74 10 4c 89 e7 89 54 24 0c e8 0e 2c 0e 00 8b 54 24 0c 49 83 3c 2=
4 00 0f 85 ab fe ff ff e9 ac fe ff ff c6 05 95 d2 18 0e 01 90 <0f> 0b 90 e9=
 17 ff ff ff a9 00 00 08 00 48 8b 4c 24 10 4c 8d 44 24
>> > RSP: 0018:ffffc9000e13fa20 EFLAGS: 00010246
>> > RAX: ffffc9000e13fa00 RBX: 0000000000000013 RCX: 0000000000000000
>> > RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffffc9000e13fa88
>> > RBP: ffffc9000e13fb08 R08: ffffc9000e13fa87 R09: 0000000000000000
>> > R10: ffffc9000e13fa60 R11: fffff52001c27f51 R12: 0000000000000000
>> > R13: 1ffff92001c27f48 R14: 0000000000040cc0 R15: dffffc0000000000
>> > FS:  00007f6f4a58c6c0(0000) GS:ffff88808c549000(0000) knlGS:0000000000=
000000
>> > CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>> > CR2: 00002000000010a0 CR3: 000000004323d000 CR4: 0000000000352ef0
>> > Call Trace:
>> >  <TASK>
>> >  alloc_pages_mpol+0x212/0x380 mm/mempolicy.c:2490
>> >  ___kmalloc_large_node+0x4c/0x120 mm/slub.c:5274
>> >  __kmalloc_large_node_noprof+0x18/0x90 mm/slub.c:5305
>> >  __do_kmalloc_node mm/slub.c:5322 [inline]
>> >  __kmalloc_noprof+0x405/0x720 mm/slub.c:5359
>> >  _kmalloc_noprof include/linux/slab.h:992 [inline]
>> >  ep_write_iter+0x1bc/0x500 drivers/usb/gadget/legacy/inode.c:669
>> >  new_sync_write fs/read_write.c:595 [inline]
>> >  vfs_write+0x612/0xba0 fs/read_write.c:687
>> >  ksys_write+0x150/0x270 fs/read_write.c:739
>> >  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>> >  do_syscall_64+0x174/0x580 arch/x86/entry/syscall_64.c:94
>> >  entry_SYSCALL_64_after_hwframe+0x77/0x7f
>> > RIP: 0033:0x7f6f4979e0d9
>> > Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 8=
9 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0=
 ff ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
>> > RSP: 002b:00007f6f4a58bfe8 EFLAGS: 00000246 ORIG_RAX: 0000000000000001
>> > RAX: ffffffffffffffda RBX: 00007f6f49a25fa0 RCX: 00007f6f4979e0d9
>> > RDX: 00000000ffffffb9 RSI: 0000000000000000 RDI: 0000000000000004
>> > RBP: 00007f6f49835024 R08: 0000000000000000 R09: 0000000000000000
>> > R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
>> > R13: 00007f6f49a26038 R14: 00007f6f49a25fa0 R15: 00007ffc6cf49328
>> >  </TASK>
>> >  =20
>>=20
>>=20




--=20
Best Regards,
Yan, Zi


