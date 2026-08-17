Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7578AC5DF66
	for <linux-mm@archiver.kernel.org>; Mon, 17 Aug 2026 01:48:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EDBB36B0382; Sun, 16 Aug 2026 21:48:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E8E086B0383; Sun, 16 Aug 2026 21:48:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D54B56B0384; Sun, 16 Aug 2026 21:48:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4E6436B0382
	for <linux-mm@kvack.org>; Sun, 16 Aug 2026 21:48:12 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 5F1F6140640
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 01:48:08 +0000 (UTC)
X-FDA: 85109075856.04.F5DA670
Received: from DM5PR21CU001.outbound.protection.outlook.com (mail-centralusazon11011004.outbound.protection.outlook.com [52.101.62.4])
	by imf15.hostedemail.com (Postfix) with ESMTP id 7A10CA0004
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 01:48:05 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=hccIOvMv;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf15.hostedemail.com: domain of ziy@nvidia.com designates 52.101.62.4 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786931285;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qQegPhqe6GcBTrpaWoKUtCN9B5Bo3XgInkn0P76LVrs=;
	b=WClMKHK8KlBSfrPLn9ng/xSRtUZlGAIVnr8S/3CRYtIPSeeOt/Fimf0gzVylOcCiNqoqce
	9FynqPrgubY1Z/LwU3AjRd3S9OgbppuE1KLdD1wnm9TjmzAcN8U98ZxZU1hsUuuI3kEyuY
	0mUYyBiFt2gVpYCJ4KF4yxP7rSEBoXk=
ARC-Authentication-Results: i=2;
	imf15.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=hccIOvMv;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf15.hostedemail.com: domain of ziy@nvidia.com designates 52.101.62.4 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1786931285;
	b=1eTfcTMoZUjdUahl/SbKPQS4DpZIrtYGG/lH4okNSABTy2GQpsGJqcZxqAuarcmJz1AWDl
	VSieOsK++0+LjesxyFoHTUqqk+3CmGe+3g1NkNvXozZY+b5Wpnr0WyHj8jd5gBnGVqVqvl
	kJsh91niYNSrhNFM6oXRYRf75RapimE=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=lUTRj3aUXR0Ax9Hn4LRlq/bQecmz66MpBB4piaUEg+nrQi0ruaVGWPzPm0kvEbWLotqLWmnv0airMWoZLB8jzi/P56LuD+LGVxDvxLUkvreLgThkoMwK5zAMlYP/fN19eKkUzGv8MaFu5uj923kOoS/JumqTDCZr2JXSu2dku8yKAm+LG+siGu1o1NYkMFRXKGW45SvnvDzxBQeQulvHLyqtsS3ey5WVIWKwMj1ytCK+yU+iZMdh8gpiy1zMSxZEPqk/MOYrl700eQE6LYhVrMaxZJXfDUtdrwApSFvKF44hGnXew/0z+Tm6RufsXtWfONlufZO1Qi45npMS7Q0GGQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qQegPhqe6GcBTrpaWoKUtCN9B5Bo3XgInkn0P76LVrs=;
 b=Q6Wf9bkaGkz7tC7Y/olNYW4w+W7oxWcFLMDHFDfm/GsK8uyLnovvBLunuNpoJV+3P7LfDLwkAAOPLjQjcFaeamxP5AENR4YqRwZmiYMSS5xLwG6m2dqkua6EJXyTUjF5aW4TLTKDwWT3CRZsn4XVAqvWv3PQKdvgClcC0igG6WA55NGkiyeKHDY3hwFoOuQjwqDXQi6EOgNU5n2IQZwTGnsX9cQp/HQNYvwCOQeh9Ix8G7qtalxTqrVq3nV91jkrntGtamh5pp7A5TD+Zq98NNs5/lHq9cKph9FuwxTcXvPICaMyeTd4ufHlVorMZovJa2C7AVrKWBWbQ2DFc/MSaA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qQegPhqe6GcBTrpaWoKUtCN9B5Bo3XgInkn0P76LVrs=;
 b=hccIOvMvCZNxe/gK0QneV3lVpICGRv+pili9LYJfygDjNg7m1LcBCqnU0aQABwRxmo7nSYJHyE8Ir5nt0KjqmURX3c2bSjz73vid2Gqm/H2TOsKVM1AWL0d6w66/NCIp6lkktWQ7ERKjOTeSeM5F8xvPpq3BI402xv24URGX++iKLJetE5etWhBjzelrggprIci8uHkbVUTf5AigSUm+p1blZt/3//xtSHdIrqaVbbYG0cSqsZt7gI4R4DzBJ8Qwb6Lp1vf9GK0RqNsgDhZrFwwkVRYGpkkXPmCnnLVbzDw4lAEPejKXy1N2WGF+HrOFiR3T7OrRpFZbNycK3FA7Zw==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by BL4PR12MB9479.namprd12.prod.outlook.com (2603:10b6:208:58e::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.315.13; Mon, 17 Aug
 2026 01:48:00 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%5]) with mapi id 15.21.0315.016; Mon, 17 Aug 2026
 01:48:00 +0000
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Sun, 16 Aug 2026 21:47:58 -0400
Message-Id: <DKQU9SQUIKDR.2KEZZPONJ1IJ7@nvidia.com>
Subject: Re: [syzbot] [mm?] WARNING in ep_write_iter
Cc: "Andrew Morton" <akpm@linux-foundation.org>, "syzbot"
 <syzbot+805630f1453e490427fa@syzkaller.appspotmail.com>,
 <apopple@nvidia.com>, <byungchul@sk.com>, <david@kernel.org>,
 <gourry@gourry.net>, <joshua.hahnjy@gmail.com>,
 <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
 <matthew.brost@intel.com>, <rakie.kim@sk.com>,
 <syzkaller-bugs@googlegroups.com>, <ying.huang@linux.alibaba.com>, "Greg
 Kroah-Hartman" <gregkh@linuxfoundation.org>, <linux-usb@vger.kernel.org>
To: "Alan Stern" <stern@rowland.harvard.edu>
From: "Zi Yan" <ziy@nvidia.com>
X-Mailer: aerc 0.21.0
References: <6a820ebc.9ebadd4d.20b15e.001b.GAE@google.com>
 <20260816135201.98590b17b526dda8c4ec9105@linux-foundation.org>
 <DKQP5QC9XTDJ.3MI016NP0NPFY@nvidia.com>
 <02c2e5c7-0d78-4763-90ff-75fa87105fcb@rowland.harvard.edu>
 <DKQS9ADYVLN1.246LJPQ9QQYVP@nvidia.com>
 <9787b33b-b30e-4c5e-a0ee-7f14515c7166@rowland.harvard.edu>
In-Reply-To: <9787b33b-b30e-4c5e-a0ee-7f14515c7166@rowland.harvard.edu>
X-ClientProxiedBy: YQBPR0101CA0332.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:6b::18) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|BL4PR12MB9479:EE_
X-MS-Office365-Filtering-Correlation-Id: 839b94f4-c065-4ba5-78ea-08defc0191b2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|376014|7416014|23010399003|1800799024|56012099006|22082099003|11063799006|10067099003|6133799003|4143699003|3023799007|18002099003;
X-Microsoft-Antispam-Message-Info:
	lWoT+Z3Sr4NGmFKAsOQplmW47jmTjqu4LrPWLMUbXkB9VzQ6rHSO9qfn4eFYD7Jx7JGDFn44pDRDEs9dBnqb7bHSNFAy+IphIpAt1VpPTqUGJP1YaqchAYoRkvcvDhwV3MFuCgSGDi5io+GhsOnc8Hf+OV2T/6qAkr9nHUhknIXQQ1McBFK+3Khxi3AIBfhUD8iKSiXfZRzGFDzHyK37F9iqHz+xMtoZixTGR8cD4zvSwDRqPYvS93pAuX4TktPiZOU1O+bAtyz1macErYovWgZlw1sYCcQ/eCVSbN30mMSZnrEuntXlpWRo+bo/X+CSLictsT+Qn7uM/of9JaBhNpuLzL3jc5Xn+/R/Ce5wXZqZnD4jNZiQ+IdbihR+NhIbIUolN3i5woz9GDzA0aTx555MQyljiC/B+AN9m55Lnm+EajnKm33WoiAuAica7HCqE2Zbupo/S/WYpf9H8IIMVJwtBM4AV+lv5pw1yLN1WfhBpbdorfoXSzJMGEFr7c1VPHDMY6So/eF/p+hMTDQ/7DqBIC36mTNqNOqpKnn6Jws10swWblOveT1mBECis79w97WwHGMC/Narnt12vh2u5Xv8KCmgNWoj4D6dWpjVgrZI5zhBsdxcfibAmltdsS9rouyEIAdRraTCQiCaDux5amFsVLsRAoy5yFEd+cvAz24=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(23010399003)(1800799024)(56012099006)(22082099003)(11063799006)(10067099003)(6133799003)(4143699003)(3023799007)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?WUlBMHFGSENsVUUrcEVPa3NjNXlrcWtsWkRPa2RIZFBDWkN5bmJPM0RlOWND?=
 =?utf-8?B?Sm93dGpibEE4cE1ialpvU2l0UGZwOWpjdEVtVmUyY0tkYUlnVURML3VFd1A4?=
 =?utf-8?B?ekVCZXp2TERkbWxMYkd0Y3JMZnFYWjh5ekFoMW16S0MydkNVSUhxcmZleGZ4?=
 =?utf-8?B?M1BhZ1dFZnZFRjJzT1FsK2FWZUFYdm45OFMvbUlSbFg2dzF4dWpuWnhwNGdR?=
 =?utf-8?B?bzRybGIwejJ3ajBJUjZHdTl3amhXdzRENjJtQTRUWStWQXlxVHNvT09wRTVY?=
 =?utf-8?B?QUI3SFY5cVVaRVZPdkhhVXJWNFBVTXp1K3RWSlZId2kwYWpjRnNZeG5mY0xV?=
 =?utf-8?B?RHl5bVowbEx0MjY4QWYxdnpQTjBZUWFkRkw0YTFRZUhXRG9PMnZXQ3laRzVy?=
 =?utf-8?B?N0p0MXU1UjcxMW5hQTRTSFZVdWFxSy9ORHR1VVA2b3AvbVdza2tXU2c3OVhq?=
 =?utf-8?B?YnNpdllaZzVjTG9KMkF1SzNFTDNzSUxnK01jaGJ0SjcwVlNoUDdrNkxvc25E?=
 =?utf-8?B?NERXOStmbTc2ZmZGc3krYmtQWlp5MDZvK1ljdHJ2M3ZXblBmVEp0YUpDZzZr?=
 =?utf-8?B?MGU5VG1IaDFQSTkwc2hFYkVPWDI2VmVqRjE5Nk04Z3BwL2ZWdzBDYVh2V1Vs?=
 =?utf-8?B?R2hSLzR5NndpRkV0WGJjekE1enNsWjNwTVY1bnI5ZjVaUXpjclNPZXRpSHJB?=
 =?utf-8?B?ZktXbXN3aDRsb0IrWjd3UzlZU3JnTk5GTTlEVzB3aHZQWTVFdGxFbkEyOGRi?=
 =?utf-8?B?VWdadlpKWVJnN095b0I1ajhhMVR2cEVwdWE1eFpWUFhoRHhxZ1NsbzdsK2xv?=
 =?utf-8?B?blpaREo4ZUJBU3U5U2pCakhoVDg2SDhxY1RjQXUyc09mOCtSNENaL1BvY1hi?=
 =?utf-8?B?R09kclRKdE1ISm55SllENDZPQmc5dUZ2RFZmRVVZVVNQTVd0TEJFNjJzdnN0?=
 =?utf-8?B?aUdJZGRmSkJPZUV4UFprSzJDTTFlV1FpQUwvVHhpMVBBUzhTbmVDcU80NDVu?=
 =?utf-8?B?Sk16Nm02YW03ZUp3UTBxOTNmS2Z1dG1IelFqcmZyZ1VKUWxpM0ZvaDNzdmtP?=
 =?utf-8?B?NktFTDFPSjFHaS9kZXhTNnk0cW5jMmlLUlBuZXc3c1JZQTRhNVIxUkt3MWo1?=
 =?utf-8?B?ejBWODYxSVNSNXJhckxRQXpqUENFeEttYmpjcSs2b0M1Zm5UTS94eW1BYkZ3?=
 =?utf-8?B?WTlNOFlaOFE5UWJoTVRCeW5hSjl5czQ5aVNNMkswYkl6T3crbWJOTWVOT3lj?=
 =?utf-8?B?ckhORFNrR3FtdE5SMHBBaHo5T01yKzQzMFVteTcwRnJzdnVkSjk5RDlQUVhS?=
 =?utf-8?B?QWwvQ2hQTVpnK1JwQWRYUVFRYUwzT2pwTWJDOUlsTDVnSmRIZFB4YVhQNGJn?=
 =?utf-8?B?T0o1VUlubVo4bnJVdUxFdTZYOU5ZVGg4OHFDcnZTRXZBbGhjKzdHdVJUcXRB?=
 =?utf-8?B?d1haVzlyT1FxSEp4OWhURnlhTGlNcnBNSUxTRmRRMUNpcHdYU0VpenIzeUdJ?=
 =?utf-8?B?bElvajNxSG1wa0lORGVxSjcxcjl1RG40Y2ZOeTNRVHJnUDV4V0wwSER6c3Bs?=
 =?utf-8?B?cS95SXd2TXpJZUhuQ3g5ZTBIQzk5Y3VyQkwrVGlkVDVsTUhScmMrVDZQc2ZD?=
 =?utf-8?B?d3k0MExEOHJNVFZITDdIYVBBLzQ0WUwvT1dWTDEyZmRjeVNFSkdvaSs2bjNJ?=
 =?utf-8?B?b2d0aCttbFRHdFI5N095NUJVc2VjckI4NEYzc29UaXZqNUF0RHc4VGd3YXRU?=
 =?utf-8?B?Zndod0V2aWg4aW9ibGZDVDlWQ1pwS2dKMVpyL1JtRE4wRGFWaWI3UnJUNzlW?=
 =?utf-8?B?RFllMkFyZGJVMTdvNWx6QlpreGRuK1UzcWdXc3o2NTFaaGFoYzVhbWxFbHZW?=
 =?utf-8?B?TGFaR2pJRkxhNy9WSE9xNVlmRmVwck1obHlzcWR0UUtMb3k4Wnc4eWcva0FQ?=
 =?utf-8?B?U2NjYWdDa1c5Y3p6S1VQNDZJTnV5OFZXSlEwRk16TlU1ZFl6NGFhTUlTc0Rm?=
 =?utf-8?B?N3pPTmhhb0NoR1dhcHRkeVVUK0hEdXROa2NRNy9FdU1WTzBiY3RucC9nOFFW?=
 =?utf-8?B?RG1JbkpvcHhSSE4wVVgyWkYxbS9MMWprakVGZTFIaVRWNUpPMkZNcWxuNkZO?=
 =?utf-8?B?c05XTWZYb3FzM3lyNEFRalZ5S1FiaHFlUnNkSnFmZHdaZ0ptYU0rWTl2SE1y?=
 =?utf-8?B?KzdoWUhYTnQvU1BsRm9nemdISE5qdnhucXZ0M1J2ZnVpazBIWDJFOUUzSXl0?=
 =?utf-8?B?NWxBcG9CSS9PbXR1Z0MveGdwcTNkMVM1OGszWlZTZUFPaFJISVNpcktzV0ht?=
 =?utf-8?Q?6rCfDydQq4VxlwEuFs?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 839b94f4-c065-4ba5-78ea-08defc0191b2
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Aug 2026 01:48:00.3848
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qOqfyZ3ws6XsZxlIvzPjFchq8tOnGnjzVfCdyp5zDjphW4y2hnxHrVedMozlYJE0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL4PR12MB9479
X-Rspam-User: 
X-Stat-Signature: sjd8wbs1csfduf74895zyyo1coaiiipp
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 7A10CA0004
X-HE-Tag: 1786931285-187008
X-HE-Meta: U2FsdGVkX1/1B/kQIZjReRSaseaLcANPZpZpyHFRu9D/cKQBTcHwdRO1ed99cKKsEE/UiCBG84/sppEbJEgbX8gmZTOWCWFoFejkmyBKGzgDV4KU6udTzCTgEwJcZJmpIfSd1o3TlUd3V6V4y3acJXF4mC3DGG9hFe+59taPy1G4d2JZ1IsLAo/ncZUYo51nxtibU7h6eB3ZiXdOpl6EgVb2MsiH+VgbYOaOP1P3SgIMB9cyMwY++mUjWYPe6AbECi3GBn52T1fEywifokpSA52UWlrY+M5Dv22FHN/4c+mEgh34oNF3jBiO1W9ZKCCiT1QHcGKDwW8+5L+Re4d8NcR5ldjx/MvIWLggmXekwLG+3Cv6x4HhIdMZ+lRFJQJEIJogRVx0rQCIZ/nxXfu+DvJtFZr5ULfthXodZJ9U4TT/5XOyFFH+XbOqzJ+ZuRjfyUieeFyFglXPc4BE5PcEzX1ypvN70+5uT99QHval0mhkjaSsaL6G4Is0bix2hm3Xeraoxw8WDz1mENM84NM7tWHADNX097F70x71YgRP7BHcs5oT4TVGFq8E0DfhfWqhCrdR2HLS+hXc26Tdwry7vdN0abKQAOcrRvuo6ECyQmDroE115sqg0EevdnTq08rDdVeuX8b0agjaHXJU/HeNrnKFVPjYCBVSgdrf3NhLE7rvbJ11/13jtJ6oTz/deIZ3rc09wMbAjpmQxCp8od+DmqDm6B8DuC30iTO28xkAHurO0d6FihZ4ATgpysgf1KOfgjduUrcKdaN9ubHVRytTLeOqMpC4clrSMwskCbLx5+61PohauHWMi5HUf4vf8Sugs61wkCYK+q9xI5Yfn7xKInz31FCWUlrQv9sSva3IEu4TKuntueflaSiw7GpBgj+C/9FFv5KsfZBlycWJvrbAjkjf5dJ/9Ywcyk5HavcMfw+MVlBDw8RXzV+ev7335uJqQ3FyuTrBoOOXkz/JyOT
 BLHWZimi
 Gm5pSNpdM2y+xu26y9droXnErU8VqnZ6tKF3x+cOO9fzRS41uKirDXiTCCjIlE/nAha7v1xOh1MkTkryl3L1a+xBocYHJpc/vjxuyqKyBAq2PJLmNyUNO0+HgcbVNJp3BlhjUN8t1eLl48+7i1McKb1zA2cRotADbfrB80L0I3CYWFfPRS5rfZqvjiMOXeV+VRZarxQ+4eWujKejD9fsNdSbELOh51jBTCp3HOJ+ys6Oa5rAeIskZ1JHoi5WgJHcYuJTa63mfUSIbFZlhxLmzcjrAnZ/gVQwDRBaPdXjsFZcl5RexRf3jUPXKDJ+iKyZOSFm9lq8ZV83tt4y+z5rxGA31lvg4DTy8MQsQQAITbSMi2OPmQCGFAkY3WeRdz7ZCo2TeG5xGnJJHNZ2g1ZxE8OYDtev0FRmkwnr3ydYQxsRHu1KlqJdcjPgGlpxDYDN6SBpwfw6ia7cqGCr3UhPZeZXn0Q+txpBmH+3tHMhA74qEjVxG2RjtEK8rQLi1YrzPq652Tx0MtPIWS2iLEuKkEsHEXlP8VeaMBtfQ19TFdeUitNPbWNVUhoN827AxG0uopKyTB8J98s4lh17jFBQOQbEOIqE+CytxLNua6KKf0arK6dNIuQlrHm+nnDrl1RQW2khBVxiy3/TrtoLjs1mJFuA0qDwKqymHclVgSGLMfRMTtqwvLa3PSDHdzSOHvbVP/OkkEFK0Lcyysap06cHJHSe2IS2hJSVdsd/iT+yPmzU3ialO5aSV7gK71qeVezsmxuGv/YrvzJKaFPwYRWz0WPHMmMuxSflS6DYYl4yeYzZ8ko74Rel6zGn8EbUwE849Q0jA3dNgtvCUuZDODBb78QNL+BFnGZKGJMmXAsyCFk+XsUwW4mQpCme3YV/n5D4qH3rJaEKjLX7M1G46/7KTsqhNviOWNvrHdheS+tL8Wmb0OW6PZcviBg8Ujqf+p+fqgDrSRUwpAUsQISgxHrlHKjvpyV52
 tSuiZPBw
 IjwhFhBhkbkbTULMX6iZng959j5wiPw+6NORaST/1PgvuwIjZoFDSFjK7nYCfNWNg6YKsTqhH4uYO/DBMNOCFgb+KpuqGOFEqGF/JP92Y3/pcN7mt+WhH9N+DzwmmIq1U2NOp7iQnt9a9vkdvVK1+/VtmjnJEYxzGlohrzHuAhsfL906QdcLyRq8HJ1rjxTa
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun Aug 16, 2026 at 9:15 PM EDT, Alan Stern wrote:
> On Sun, Aug 16, 2026 at 08:13:16PM -0400, Zi Yan wrote:
>> On Sun Aug 16, 2026 at 7:32 PM EDT, Alan Stern wrote:
>> > On Sun, Aug 16, 2026 at 05:47:34PM -0400, Zi Yan wrote:
>> >> On Sun Aug 16, 2026 at 4:52 PM EDT, Andrew Morton wrote:
>> >> > On Sun, 16 Aug 2026 12:25:48 -0700 syzbot <syzbot+805630f1453e49042=
7fa@syzkaller.appspotmail.com> wrote:
>> >> >
>> >> >> Hello,
>> >> >>=20
>> >> >> syzbot found the following issue on:
>> >> >>=20
>> >> >> HEAD commit:    3d6d817622b0 Merge tag 'scsi-fixes' of git://git.k=
ernel.or..
>> >> >> git tree:       upstream
>> >> >> console output: https://syzkaller.appspot.com/x/log.txt?x=3D159274=
79580000
>> >> >> kernel config:  https://syzkaller.appspot.com/x/.config?x=3Da59830=
cba91a1981
>> >> >> dashboard link: https://syzkaller.appspot.com/bug?extid=3D805630f1=
453e490427fa
>> >> >> compiler:       Debian clang version 22.1.8 (++20260613092233+e80b=
eda6e255-1~exp1~20260613092250.77), Debian LLD 22.1.8
>> >> >>=20
>> >> >> Unfortunately, I don't have any reproducer for this issue yet.
>> >> >>=20
>> >> >> Downloadable assets:
>> >> >> disk image (non-bootable): https://storage.googleapis.com/syzbot-a=
ssets/d900f083ada3/non_bootable_disk-3d6d8176.raw.xz
>> >> >> vmlinux: https://storage.googleapis.com/syzbot-assets/d19e0514c02a=
/vmlinux-3d6d8176.xz
>> >> >> kernel image: https://storage.googleapis.com/syzbot-assets/f6da706=
811f4/bzImage-3d6d8176.xz
>> >> >>=20
>> >> >> IMPORTANT: if you fix the issue, please add the following tag to t=
he commit:
>> >> >> Reported-by: syzbot+805630f1453e490427fa@syzkaller.appspotmail.com
>> >> >>=20
>> >> >> gadgetfs: bound to dummy_udc driver
>> >> >> ------------[ cut here ]------------
>> >> >> 1
>> >> >> WARNING: mm/page_alloc.c:5280 at __alloc_frozen_pages_noprof+0x2ce=
/0x380 mm/page_alloc.c:5280, CPU#0: syz.0.0/5319
>> >> >
>> >> > Thanks.  drivers/usb/gadget is the offender.
>> >> >
>> >> > Gemini sums it up well.  "ep_write_iter() needs a bounds check prio=
r to
>> >> > memory allocation".  https://share.gemini.google/5NzjyttO0ULc
>> >> >
>> >> > I expect an easy fix would be
>> >>=20
>> >> Maybe it is better to stop asking kmalloc for unreasonable len:
>> >>=20
>> >>=20
>> >> diff --git a/drivers/usb/gadget/legacy/inode.c b/drivers/usb/gadget/l=
egacy/inode.c
>> >> index d87a8ab515107..20905f254968f 100644
>> >> --- a/drivers/usb/gadget/legacy/inode.c
>> >> +++ b/drivers/usb/gadget/legacy/inode.c
>> >> @@ -645,6 +645,9 @@ ep_write_iter(struct kiocb *iocb, struct iov_iter=
 *from)
>> >>  	ssize_t value;
>> >>  	char *buf;
>> >> =20
>> >> +	if (len > KMALLOC_MAX_SIZE)
>> >> +		return -EINVAL;
>> >
>> > Is there any reason to think that KMALLOC_MAX_SIZE is a good limit?  T=
he=20
>> > allocation could still fail, and you'd still get a WARNing.
>>=20
>> KMALLOC_MAX_SIZE uses MAX_PAGE_ORDER, anything bigger than that will be
>> rejected by page allocator. This warning comes out because of it. This
>> if solves the exact issue here.
>
> Are you saying that if len < KMALLOC_MAX_SIZE and the allocation fails,=20
> the kernel won't WARN?

Right. Just pr_warn() (from warn_alloc()) to tell allocation fails and
NULL is returned.

>
>> > I prefer Andrew's first suggestion.  If the user asks the kernel to co=
py=20
>> > too much data, just fail -- with no warning.
>>=20
>> __GFP_WARN gets rid of all other warnings, even if user asks for a
>> reasonable size. Why use such a big hammer?
>
> Because on many systems, WARN causes the kernel to crash.  You don't=20
> want the entire system to crash just because the user asked for more=20
> memory than was available.

User asking for more memory that what is available is pretty common and
should not trigger a WARN or crash, unless you have panic_on_oom set.
You can mmap a virtual address range bigger than your physical memory
size plus your swap space and try to fault all pages in. That would
cause OOM and the system should not crash.


--=20
Best Regards,
Yan, Zi


