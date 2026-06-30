Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4AA18C43458
	for <linux-mm@archiver.kernel.org>; Tue, 30 Jun 2026 23:45:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 040C76B00A6; Tue, 30 Jun 2026 19:45:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F346F6B00A8; Tue, 30 Jun 2026 19:45:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DFC766B00A9; Tue, 30 Jun 2026 19:45:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id AFCF16B00A6
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 19:45:23 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 3099A8B4EF
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 23:45:23 +0000 (UTC)
X-FDA: 84938212926.23.CA37B96
Received: from PH7PR06CU001.outbound.protection.outlook.com (mail-westus3azon11010043.outbound.protection.outlook.com [52.101.201.43])
	by imf31.hostedemail.com (Postfix) with ESMTP id 4DAD920003
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 23:45:20 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=JAYxVLnu;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf31.hostedemail.com: domain of ziy@nvidia.com designates 52.101.201.43 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1782863120;
	b=Zmo4fam31D7ADz3TFZPpr92Hc6g7RpsTAnEmk2Av8bcB5VqCWQkJCf6ZYM+aLRJ6MtUVNf
	yfFlYQFot1+Fl0xRw0xSiTjzu7ivFefGj0fQEJOvqu1aANPK9Pu+1QLAzdhaSZLoExUlf/
	1/BeZ3s8mY3fHqmzyJG6ihdK7cMi5sM=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782863120;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JK30rEjN/PoNqE8829PgFsHL1yAZgOpduJppUnxGzQc=;
	b=s6Efd2uCqp17tokv31l0ZArXNKQ+bgUpOP6v2A/0IJ22so+giZx4qXPLj7XxV0LlZwXtZv
	wHM76H97+OrFxrEVmRTYmp+EAJkS2E8aVIlOQRNQKmQWbyITCEbHQgCOV1zldzsRvAHo9C
	obvSHPU72zXUb4rGeNl2Pcem02nJ4uM=
ARC-Authentication-Results: i=2;
	imf31.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=JAYxVLnu;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf31.hostedemail.com: domain of ziy@nvidia.com designates 52.101.201.43 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=OBC5sCJbbCDpso61aMzx+t4pLkBA1tZIvHfGaIxZ0gS46SpqojDkE9Yyh3F9ILy99+sVgrqEWRBsf77d2io6rOHUZHUAFXE1QlwzGFCblZMkZGZtWJ7ACygUN9ch+fSrrEYQhQXV7ts/H2XBRHezjD/j1YZ12weTjMh3cloW7MeU9TMgQBMsN7x5734oQbFbtVvPFAh6RrAdW8x9Nz6T3q1dL/o+QO8keGBfqJXZOWmIcVeRZnRPGESR4Q9Cwk+zOqBpKW126hFRpYxXTCgP6x/C5azIkoJPA83diOV+MZWOpXOcxJRmO5EToSJjB9MS0pl+dpbbAp5nFqnEhLeWTQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JK30rEjN/PoNqE8829PgFsHL1yAZgOpduJppUnxGzQc=;
 b=b8tAc6vK4Vkw6h5PEN4wkOP/QxYhmTKwyyQdND+aDfvj7cuFeOWvQg+I4JBZhJeL0bmEzeZFV3UMIWN4mFf3GeWpJ0Yr3aCmCVbMqzfxAvwz72TbaOhCy1WopqQKp7dGZLxHih0gdtwxghvrofHCg/3fT/whgMLlQtbRf3yt/6XeFIDRfW+litvzw14fomvmyJs1nSLAiNr6QHSD48ESVZcsCn51U1vpyEZZS2Ijnv4aUQEo8zViVaVu0WPTHWwQbatflyyEWn/Vh33LtTqSC463XP5K18MmfMYvkFcbvlu+RyaQjedswNISZ75oMZjKvRR/XiFXEw4F9115Z5y/8w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JK30rEjN/PoNqE8829PgFsHL1yAZgOpduJppUnxGzQc=;
 b=JAYxVLnuIErkBR2diyzJ8HFZOITeTLq3pXE0OwQl1WvHPDtah98Nw8mRje01q8epZhVBFBgxxPUrRvxzawvshQhQo8NvHqhwHqWWke4bqeJIXMpIZC/nGhYuPwTPsOUIegK9p7LtTHHKVWMgFYM3Szj/hpNAo9nh4tLGctGcj+NWgMiHn3jrc7OlHi2FussCGGgojdKIpAIMHffqTE4RtdcDLdy+slerDSPPDugF1BaPPAq6J6/GovB03vJa4/g+C7Z4nHZS7fRYXI7lPBrIxDysVIh/Ep6i/Xtjm1R1eDzzfSzJeJvbI7HHfF40mviORXDGTOb40ZYjKhSHyJ/T/w==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by PH7PR12MB8106.namprd12.prod.outlook.com (2603:10b6:510:2ba::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.181.8; Tue, 30 Jun
 2026 23:45:10 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%5]) with mapi id 15.21.0181.008; Tue, 30 Jun 2026
 23:45:10 +0000
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Tue, 30 Jun 2026 19:45:08 -0400
Message-Id: <DJMS84Y4KYDY.26GNQPOZ6G4L7@nvidia.com>
From: "Zi Yan" <ziy@nvidia.com>
Subject: Re: [RFC PATCH 0/8] Introducte Reserved THP
Cc: <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>, "Qi Zheng"
 <zhengqi.arch@bytedance.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>, "Qi Zheng"
 <qi.zheng@linux.dev>, <akpm@linux-foundation.org>, <ljs@kernel.org>,
 <baolin.wang@linux.alibaba.com>, <liam@infradead.org>, <npache@redhat.com>,
 <ryan.roberts@arm.com>, <dev.jain@arm.com>, <baohua@kernel.org>,
 <lance.yang@linux.dev>, <muchun.song@linux.dev>, <osalvador@suse.de>,
 <chrisl@kernel.org>, <kasong@tencent.com>, <shikemeng@huaweicloud.com>,
 <nphamcs@gmail.com>, <baoquan.he@linux.dev>, <youngjun.park@lge.com>,
 <peterx@redhat.com>, <usama.arif@linux.dev>, <willy@infradead.org>,
 <vbabka@kernel.org>, <surenb@google.com>, <mhocko@suse.com>,
 <jackmanb@google.com>, <hannes@cmpxchg.org>
X-Mailer: aerc 0.21.0
References: <cover.1782538002.git.zhengqi.arch@bytedance.com>
 <e2bd33d5-4de5-49cd-970f-9e80eec91a3b@kernel.org>
In-Reply-To: <e2bd33d5-4de5-49cd-970f-9e80eec91a3b@kernel.org>
X-ClientProxiedBy: YQBPR0101CA0229.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:66::35) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|PH7PR12MB8106:EE_
X-MS-Office365-Filtering-Correlation-Id: 301deaa2-c543-4cf1-d8f4-08ded7019f50
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|366016|7416014|376014|1800799024|921020|6133799003|11063799006|4143699003|56012099006|22082099003|18002099003|3023799007;
X-Microsoft-Antispam-Message-Info:
	mVQq6uUpk9PxQv+ZZ+rKa30vm97Lm9kGg8roj5lhbEcv4zdkFqaUCF+InBysJ2H8fERWSpJ0UvrTK0bjlX8HO3HrQmO5zeFZPjGxaBlcRfL0HoErnicX3ID+GiMr/L/R2qM5WZWtUI2osFB69ZgrXbgtFvqImuq6nlTDOimXLnd+PSBg8vS2nEhp2VqD5IsdU8Tve64f9+NRCX3uhAbbIQWZvKwkbHYGVOxJvOjMQB/5r1dQfoEW5/F23ISNzF0oCiuTWy/hurnXFh1nVwI6psXccXKpV8w8d1kLYfweQiyoO5eeeVxGEaN9nsVfMv3NKzhZHlvHx0Ul8Me2I9N0658OUUOm0NqIvsacYMZBtApCLRslvP6yg1uJQLk/0Q+xphqczJiP494kCpmvzv6NHlxMYDKmubQAl3QC9D6LnjIzuPh4gG2mIXXqDsSh5PbJg+yFtJ6nbMZ87cgMT5UFcUqYen9SVQfJeu/qtb+ttOJUpVprCEtI++Lx8lLQuvgKNBmz3HobK3qvDjTvQesw7GoeAs0HtQ00RZz/FgHL5q+yMnKQBt262YP/z18nFokYbpmxntgsSANTGyjyVnBDq40r6dH43ipj6PwFb5CDTGU0nKpYYMmfoajT7YlxiMPAMyH8xjs8qsq4ezcovL3RJlqvqy7NxXF27AWqPVeR/FAn6ItKNxCjzAfP3JbflaK9JesfKuVvQK58//dAwqf9Kg==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(366016)(7416014)(376014)(1800799024)(921020)(6133799003)(11063799006)(4143699003)(56012099006)(22082099003)(18002099003)(3023799007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?QkxsUyt5ZWtYUDNvQmpYdkh6bGVmTks1azFwUlUyOUl6QkhkZ1RlRktqcVhn?=
 =?utf-8?B?bHNyaHFEVVZrZ3hiak51LzJwVnpRWW9ZM2M1N3RiRWxQMllid1llMDZyNGV6?=
 =?utf-8?B?WFhacXdqc2JHNmErajVLTDltRno4UERzS25RekdvOHRxRHdCRGdLcTBySkNB?=
 =?utf-8?B?c0psY2dYMkhYcnVmQlJZeTJlcUlUOVlmM012QWRCMDF1NEVqd0JUcDd1RmN2?=
 =?utf-8?B?L3U2cTljanY4UHkwTG1zaURDM2ZMeXRFUGh3WUlweHF0VVpURU04Q2g0bVNH?=
 =?utf-8?B?ZHJXOVFocmJ0UGtuVGExSWE5M2pqTDhEbUR4bkQraDlSQlJkeW4zMkgwYUkz?=
 =?utf-8?B?UmNxRVBaTUkxMU8vaElua21jbU1LSGJpMTFXczJ3aHd2RENQaGIzNU1VeUJY?=
 =?utf-8?B?SFVLbUVZcDVSVi9YdlpOU05Mckw3SXBXL1JGaU5pc0poQW5RVi94ZVo1VzFi?=
 =?utf-8?B?ZWhqVDIwYm9TcE1XaVBQKzlub1FSRFNjYmN6K2RDWE8wYUtTMzM3ZTBYUlhB?=
 =?utf-8?B?TGk5QXFsWUNNSE12SCtET3g4UU9hMittSjdCT090Zy9lMHBlc0hHME05eTZ1?=
 =?utf-8?B?dExLQUVKcS9NK3JLNUliRDVRVFhIcG5HQmxXQnRIWTZoNExDWndjaGJCYk10?=
 =?utf-8?B?ZFc3MVVxMkhCQitnV2xyWEU2Um9BRGNUa01kZ05wTUM4ZUI0dzc3UkJ3ZDA1?=
 =?utf-8?B?YUlOTmVIbFFrNndQU29UZ05QRmFwZ1piNUdVZ2pzeHdoaUdrWm05U0VEdkV1?=
 =?utf-8?B?WU9hSnBGcmpzUlhvZEtDSzlsQWh1UlFaaVJtZUFlcVJSa1h2eC9qajZWYTNB?=
 =?utf-8?B?NDgyZ0F0ajdWQmpXRVlDMnZacDNZTVN5OFo2SmNhRXVMdUp1YUlMVWt1ZWpY?=
 =?utf-8?B?UVA1UFU4K0NSWVdsSEdZanBxL2NXWGQ3cWFTcHlnRkkxTERiY0dyYzZEMWtW?=
 =?utf-8?B?endvS2gyYXJuUkxIVFFPUERNYzFWdnRkRktXQ0pEWXNpZi9kaHY2MllZY0dD?=
 =?utf-8?B?M2RiM1YzRWJ5NVVlblpYcjltcXJvUmtZeHdkS2FEUDNpUGZ6dVJhZGE2cjFD?=
 =?utf-8?B?c3RTdnJpWm9wcFhFYVJsQVhBTGR0VUtCaVZCUmpXQmZKck9KbmJGNlE5Sk94?=
 =?utf-8?B?RVpteWRzQnlneDBrWVVBK2hOckdGKzJJRC9XZUd0cm9xNy9yWVE4UjRIcE93?=
 =?utf-8?B?dDhKak9jNjZ2NDI0U3J3T3QzU3BmNzNwdHora2cvLzJVcko0RElrb296WlZj?=
 =?utf-8?B?bU1jTFhoK2lmb3Y5bmJacVAvL2dEUUpDRnRJWkhwTjEzbkNZUUtqRU5mTWsy?=
 =?utf-8?B?ellPTkg0MDlYVlRUdko4cnlyc2JISjBjckQ1SEUxUlNBTDIyZkdUTURNTDJS?=
 =?utf-8?B?ek9JUzVaQVJLNHdUNEJrWjdvUXVtcERJT1F1ajFZL1FJRWRLT1FHRHZHazlj?=
 =?utf-8?B?NjhIbERITDcyQjRGc3dlVUFCZHBLSWs1M3FQNVZYV2F0L3JyTXU3VWlTZWJR?=
 =?utf-8?B?azJnZjMrN3N2bnZvdmNDOHVlaHpEbXdjTUJyRkhYYmYzT1g0a0Z2QUJCeXZh?=
 =?utf-8?B?NjZqYnpsMjk3c2JxZE9yY3VUVmpSL1ZSL2hKQXhscm5iai9IaTVkNFJjOHBP?=
 =?utf-8?B?bnowTzJIc3JMWE1jb2QvWFU4ZnREUWM5UEZReDdYNitMN2tiVjRZcUVEQ0Z6?=
 =?utf-8?B?QVVlWnVyTFpESFBpZy9pSFFXanJPbUhKSHd5aFNwZ0tlZ25XVDQ0MEh2dW1T?=
 =?utf-8?B?WHE0dHlXNUVYck5ISkc5bzFvYUdGYmJjSVhVOVgxdzlZa2tJNHZNL0N6R2xW?=
 =?utf-8?B?NW1DRUpJblRKbXMrTVF0ejJvSlNNTlNRUFRIdnpjanQ3blVlSTg4Ynh2YVA5?=
 =?utf-8?B?eFhVTmxvZlFQR0hZNVNuTFhrenpmd2s1MFZ4TVNDVEtJS2tZMmhYcjNGbzh0?=
 =?utf-8?B?Zk5TWTBtVXpoL3ZRSjZzSHhENVQ1TzlLQ1RxbDFDYnlFU3RjS3kyM3dldXNC?=
 =?utf-8?B?dlRsTHdzKy9wNHEzODhvOFhIV1FxOE81Y21nWjVmaml2THNmTjdWbTZBUkIx?=
 =?utf-8?B?aldIYUNxbUdJYlJOWWVpNFBld2hQNGUyK3N2YXRCSGcveHlHRkNzNko5RVls?=
 =?utf-8?B?TU9OMXZ4SFJtRDV3akFPVmtrL2RhN3p6MFk4NW5JenVFZkYyeG1WTHkvN0NQ?=
 =?utf-8?B?aHU3eTA5RnhHOEF3QU0yR3U5dHZQbWFHcVk2cTZldHYxSGZNdHJBNklnL2gr?=
 =?utf-8?B?Qi85VjkzYWN0SkpGSldVa0dvYXdMQ21rdllLL0hqQ1ViRE15VVE0Q2tMa1h0?=
 =?utf-8?Q?3+Z1EmGSz4WBIb5Z5i?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 301deaa2-c543-4cf1-d8f4-08ded7019f50
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jun 2026 23:45:10.2584
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZGKVt0seru1tdjY34bB7V0tJRX13vre9zQAVTB3d3M1qoGKqgkvwnWIwdG/lxJxd
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB8106
X-Stat-Signature: qo4xfngdqa6k3aqa8a6hszox8zi7pdkg
X-Rspamd-Queue-Id: 4DAD920003
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1782863120-495069
X-HE-Meta: U2FsdGVkX1/VTkCUo2jyyK5/6oDFzZ49uuOHRgFi3qkKPfipACAIBQelUZ/uHClPIFVkySC0Kl9LFAL+DwxrKi3yMaJyaZLAlJ+Op292gLTfQ4jWVwNjsb0DK/48nA1Tvna+a/gURnjbERdvPmuDPjzvfhyQcaTL3wpQAcDkO62kkgdZaGGs9PqzCP/zDZ77lDUkzdUi+AFyaUF7ZPjDgfCnuUd3XyT8ndxmR10fhuqbqb3s43gQjYa1ANLjhYy1f5pqs3jTe1NskMK7c2rBr3J/qV8ZIdncoIcb45c5N7rK0iDBS2lOEW0EGcswsp4dXP5i6pi2rZjgUpH1+8wlTxK2gh03JvFiEFMF/DrD8Me/ZsSGhAts+9jEJXaGrRlbm0LLnxigNEZJ+Qv1g3CXgamAhprg/YIe0noX06O7nxzr6qzg8likMOw/2UGfbpsDZVTI5J1wBlqiSl+EucNuEC6XgS5JMKTe0J088gB26c/KezDJ38nj0cqoZJcDVBSCOZsE3EAkmx3GeKb4Q6UecHJasE44ynyYzsgv3frSEa710Q7ZiZPQL0vmeKwepzpmy6GGgG8cg1mk7rcyk2Yp/avx/b2aOr9JbG8nOOpoIk9ruvPj4ILlkRNOc07sMsfFRu2aSNKDcz+EuXf1ZeSHEP9BxIYOVrGbz8mtmncX1s0tve8Xk0qGnYpFNZugrJI6JfatsCfdoIqc5nGESbqb8Q/0ebqB7fWk9pAZvT50XOuCh2p386EOppvBNdY73namxxxPmoT7K9F0wsqUwbDDN5qqQVrSi7mbJPG5Ydm/wlrk+WqfNwuRBhOeu45/xlyWnYqNGHEtMK1jl/vxk1K/g5pD1F4Ri2eP6EenpLVilH0+mr///qQ9RHN+phWDX51KCwO+2BqCnXvCfG55ubBWsjZOO44fepvNTIR+J+f6nHALHWVnpl9Hk+JpLhghml1DIHdtCC3GEq1IfmitMk5
 AiEvG94b
 /EBN9idx/GZiBQX8pNGR9ITfyOsAfnSImBFsR//YU3RNUYngub6XDg5GpUdzR2B5BQq9BCi6AV1Cp3G1ykySn2+0xwe4rP9IURRl0gXAuQzwkVjZ5kpuyOAvEW0oN747X/BsetE6lpFXIshF6PZFEiuAZDeHrQU6ZqjoRU/1Bk+qNxByPraADx/GZF3FvBev3++CepeoccQ2GeUW0B1yvmx6GYhqUGSDuDJr/hsaIYCzfLPzzkvwqnF+44dc3O9CLeFtY+aoIWtLHBjFOG2awA/lF9Z7iy/U0Wtxy9AMfhDNhEh3mgYs1eY0Q0COpGIrzphlLhfmCpfsSK8l1Z09Vf4ysS9+UX/krDu+7fA7aH954nV9mztbru8VBOH6/nO1O5/jclwgre+468/HKtfPUKaV85J2+h9l8gc++yagFZqLGEQOFQ7bgNtqdkQ0+K5/E5Z+MSLYvRJohmosLoHJNxQSfNsA933D200Ds/I9HQu9vt2dt/CnNGxU4wu46y+d7Tk6n/AXXKqIJOfMiFjDDgFQo7TTw9je7gA/509jKO227/kHv33mwTPAvffkIJoXvDhx5ux0j8rmvPsw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon Jun 29, 2026 at 8:20 AM EDT, David Hildenbrand (Arm) wrote:
> On 6/27/26 09:21, Qi Zheng wrote:
>> From: Qi Zheng <zhengqi.arch@bytedance.com>
>>=20
>> Hi all,
>>=20
>
> Hi,
>
>> This RFC patchset introduces a new feature called "Reserved THP", and I'=
d like
>> to open up a discussion on how to use this as a stepping stone toward un=
ifying
>> HugeTLB and THP (Transparent Huge Page).
>>=20
>> 1. Background
>> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>>=20
>> Currently, two huge page solutions co-exist in the kernel:
>>=20
>> 1. HugeTLB: Supports reservation, guaranteeing successful allocation wit=
hin the
>>             reserved pool. However, it does not support features like sw=
ap. And
>>             it is a relatively independent subsystem.
>> 2. THP: Does not support reservation and may fail to allocate and fallba=
ck to
>>         small pages when system memory is fragmented, but it is more tig=
htly
>>         integrated with mm core and supports features like swap.
>>=20
>> Both have their pros and cons. However, in one of our internal scenarios=
, it
>> seems we need to combine the features of both to meet the requirements.
>>=20
>> In our internal scenario, a user process needs to reserve double the amo=
unt
>> of Hugetlb memory due to hot-upgrade requirements. For example, if the
>> process needs 16GB of Hugetlb, an additional 16GB is required during the
>> hot-upgrade to satisfy memory allocations. After the upgrade, the old
>> process exits and releases the 16GB of HugeTLB. Therefore, in most cases=
,
>> the extra 16GB of HugeTLB is wasted.
>>=20
>> A straightforward idea is to use the Hugetlb CMA feature, reserving a to=
tal
>> of 32GB of hugetlb_cma. During normal operation, 16GB is consumed, and t=
he
>> remaining 16GB can be used by other processes. During hot-upgrade, we co=
uld
>> try to migrate the memory used by other processes to allocate the requir=
ed
>> extra 16GB of Hugetlb. This might work, but it still requires reserving =
32GB
>> of memory.
>>=20
>> We also found that during the hot upgrade, about 10GB of the old process=
's
>> hugetlb is actually cold memory, which could theoretically be reclaimed.=
 In
>> extreme cases, we could reserve only 22GB of memory and reclaim the
>> remaining 10GB during the hot upgrade. But unfortunately, hugetlb curren=
tly
>> does not support swap, and supporting it seems quite difficult.
>>=20
>> Therefore, we are wondering if we can introduce "reserved THP", which is=
 THP
>> that can be reserved. It can be consumed through methods like madvise(),=
 while
>> normal memory allocation cannot consume it.
>
> madvise(). Gah. No :)
>
>> This can achieve an effect similar
>> to hugetlb. And because it is THP, it can relatively easily support swap
>> features, which perfectly solves the above problem.
>
> No, this is the wrong approach. We really shouldn't be making the same mi=
stake
> hugetlb did and support reserving of non-filebacked memory (IOW anonymous=
 memory).
>
> And even for files, the hugetlb mechanism is an absolute trainwreck, beca=
use
> it's not NUMA aware.
>
> This really needs some proper thought.

You mean the reservation should be done via some file handle, like
memfd, so that it is easy to apply memory policies to determine where
reserved memory locates?

For existing hugetlb reservation, there is no fine control, like NUMA,
or cgroup, of the reserved free memory.

Is that what you mean above?

>
>>=20
>> Additionally, in 2024 (or possibly earlier), there have been discussions=
 about
>> the possibility of unifying Hugetlb and THP:
>>=20
>> Link: https://lwn.net/Articles/974491/
>>=20
>> After all, hugetlb's management is relatively independent and requires t=
oo
>> much special handling in mm core. The introduction of reserved THP might=
 be
>> an opportunity. In the future, reserved THP could be enhanced to support
>> various hugetlb features, such as acting as a backend for hugetlbfs. Whe=
n
>> reserved THP can completely replace HugeTLB, HugeTLB could be entirely
>> removed, and reserved THP would just become a feature of THP.
>>=20
>> 2. Implementation
>> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>>=20
>> In 2024, Yu Zhao proposed a similar idea:
>>=20
>> Link: https://lore.kernel.org/all/20240229183436.4110845-2-yuzhao@google=
.com/
>>=20
>> The idea was to introduce two virt zones: ZONE_NOSPLIT and ZONE_NOMERGE =
to
>> guarantee the allocation success rate of THP, achieving an effect simila=
r to
>> reservation. However, it seems there was no further progress, perhaps be=
cause of
>> reluctance to introduce more virt zones like ZONE_MOVABLE.
>>=20
>> This RFC wants to discuss another implementation:
>>=20
>> 1. Introduce a new migratetype: MIGRATE_RESERVED_THP.
>> 2. Introduce two new hugetlb-like kernel boot parameters: `thp_reserved_=
size`
>>    and `thp_reserved_nr`. When set, the required memory is marked as
>>    MIGRATE_RESERVED_THP and put back into the buddy allocator.
>
> I'm all for some mechanism to make runtime allocation of large chunks of =
memory
> easier, by adding a pool from where multiple consumers (THP, guest_memfd,
> hugetlb, whatever) can allocate memory.

I agree with this one. We do not want to invent different free memory
reservation mechanisms for each possible consumer. A shared reservation
mechanism with different reservation and allocation policies is better.
>
> Call me very skeptical of getting the page allocator involved like this. =
(I hate it)
>
>> 3. Introduce a new madvise parameter: `MADV_RESERVED_THP`. Pages marked =
as
>>    MIGRATE_RESERVED_THP can only be consumed via `madvise(MADV_RESERVED_=
THP)`.
>>    Other normal memory allocations cannot consume MIGRATE_RESERVED_THP m=
emory.
>
> Definitely no.
>
>>=20
>> This can achieve a reservation effect similar to HugeTLB and guarantee
>> allocation success.
>>=20
>> 3. Future Plans
>> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>>=20
>> 3.1 Enhance swap-out and swap-in for large folios
>> -------------------------------------------------
>>=20
>> Currently, For swap-out, THP_SWAP is supported, but it only tries to swa=
p out
>> the THP folio as a whole. It is still possible to be forced to split in =
some
>> situations (e.g., fragmented swap space, memory.swap.max limits, etc). F=
or
>> swap-in, it is almost impossible to directly swap in the THP folio as a =
whole.
>>=20
>> But for reserved THP, splitting is not allowed. We need to ensure that i=
t
>> remains a whole huge page during swap-out and swap-in, to achieve a func=
tion
>> similar to hugetlb swap.
>>=20
>>=20
>> 3.2 Integrate reserved THP into the common reclaim path
>> -------------------------------------------------------
>>=20
>> Once swap-in and swap-out of huge pages can be supported without splitti=
ng,
>> reserved THP can be integrated into the common reclaim path as a normal =
LRU
>> folio for memory reclamation. This fills the gap of the hugetlb swap fun=
ction.
>>=20
>> 3.3 Use reserved THP as a backend for shmem/tmpfs
>> -------------------------------------------------
>>=20
>> This would allow shared or file-like usage to utilize reserved THP.
>>=20
>
> Really, any kind of reservation should be file-centric and have some leve=
l of
> control.
>
> And soon the question would pop up "but how can we control this inside me=
mcgs".
>
> This all needs some thought.
>
>
>> 3.4 Use reserved THP as a backend for hugetlbfs
>> -----------------------------------------------
>>=20
>> This would allow existing hugetlb users or applications to seamlessly sw=
itch to
>> reserved THP.
>
> You are really talking about a memory pool that can be used by different =
consumers.
>
> I raised that in the past in the context of guest_memfd, whereby the shor=
t-term
> plan is to take pages from hugetlb's pool, when really there should be a =
global
> pool that can be consumed by various consumers.
>
> A lot of questions around that.
>
>>=20
>> 3.5 Add 1GB page support to reserved THP
>> ----------------------------------------
>>=20
>> Historically, there have been several attempts to add 1GB huge page supp=
ort to
>> THP:
>>=20
>> 1. https://lore.kernel.org/linux-mm/20260202005451.774496-1-usamaarif642=
@gmail.com/
>> 2. https://lore.kernel.org/linux-mm/20210224223536.803765-1-zi.yan@sent.=
com/
>>=20
>> Adding 1GB huge page support for reserved THP would be relatively simple=
r
>> compared to regular THP.
>
> And that's what I told Usama: start with 1 GiB THP support for shmem/tmpf=
s, and
> make it configurable.
>
> How we would add a reservation mechanism is a good question. Because huge=
tlb
> reservation is a broken concept. And anything that's not NUMA or memcg aw=
are
> will be a broken concept I'm afraid.
>
>>=20
>> 3.6 Remove Hugetlb
>> ------------------
>>=20
>> Once reserved THP can completely replace the existing functions of huget=
lb, we
>> can gradually remove Hugetlb, leaving only one huge page management syst=
em in
>> the kernel.
>
> I'm sorry, but no way this will work in any reasonable timeframe unless y=
ou
> mimic the exact user facing ABI -- and I don't think we'll gain a lot tha=
t way.
>
> I know, we all like to dream, but this just isn't feasible.

Based on my understanding, the key takeway is that we want to have more
control over reserved memory, where to get the free memory, who gets how
much of the reserved memory, and more.


--=20
Best Regards,
Yan, Zi


