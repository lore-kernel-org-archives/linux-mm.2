Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 56DF5C5DF81
	for <linux-mm@archiver.kernel.org>; Thu, 20 Aug 2026 01:35:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4E1EF6B008A; Wed, 19 Aug 2026 21:35:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4B97A6B0092; Wed, 19 Aug 2026 21:35:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3A7DA6B0095; Wed, 19 Aug 2026 21:35:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 115B86B008A
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 21:35:16 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 8797B8064A
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 01:35:15 +0000 (UTC)
X-FDA: 85119929790.08.9929452
Received: from CY3PR05CU001.outbound.protection.outlook.com (mail-westcentralusazon11013043.outbound.protection.outlook.com [40.93.201.43])
	by imf07.hostedemail.com (Postfix) with ESMTP id 9400040006
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 01:35:12 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=a+1pmHiT;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf07.hostedemail.com: domain of ziy@nvidia.com designates 40.93.201.43 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787189712;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Wb9cq9xFl+iZwFMULQrdIc3QLx1Te8+93RQTxgSZ1IM=;
	b=42b6Cw/+USXvwTHPR/duYa46K0JLJCTAZOJ6s2wAZdR2CLnzWc7zPj7Lav5BmrRR4h5qRk
	d39WBx2qEOINauC8V+iYFyXanBokyCyS4xPZq2wBcF4qvVayzI8UFDbprAMBXWep+o2QRQ
	rcyTIiCvIHQv6CbH48KMgVRzZaYGht0=
ARC-Authentication-Results: i=2;
	imf07.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=a+1pmHiT;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf07.hostedemail.com: domain of ziy@nvidia.com designates 40.93.201.43 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1787189712;
	b=X0sd9lZXKbpXXyzKIM4ATdBnQKJu63IO8qTqB8f2C7FeSES/EBSspWSm44n6xgkbmZTJss
	c6JxSNnz5LywunHsI9C9j8zuBMdZaBDDrj/ujeW0EqyzfFtRz365c4OZ6VK2JbKAvx3NJ0
	5kdtNnmYzmPcARTD7J1jB4jBCxb5Cqo=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=EpeWjUlWtrqzRz0obPk2ikVib7qO4NNhqsvStuIDquLqwLeect0w+u4YTrvcygHCmmPHgVboH5t5HiaFPmlJGzhoyxbHmnbRSou6Bd3sOaL0zDO/Zc286o0qGB2UwB/TlEtBFXwduOSvYjXPojTwcKlnwXQjOjwb5V8eh4CPTLM+HU3GcX/cTEyJ3wmvgkqOOYv2usgD5PnkHGJOVL34YGxHRd/at82VpXaPG7YOCbJNXfMf8mTkMgo0eEuCflIYP5u4otXE0vM60LtxpI2x9Fra6ZhBZ90VO8z5EC0nmdfc+g/PCOwz8OODpe4AFys8P5ugZIht239Jtkbjgwz2iQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Wb9cq9xFl+iZwFMULQrdIc3QLx1Te8+93RQTxgSZ1IM=;
 b=hLrfpm+LDU+xR02XNUjfPkQ+dPO6zdSt49faHlF3e52FqCdgmo7RWV5IDGwBvzZYFvfQbitFtm3w3Tc3AAElkFD0U9uQdmejraRyVTOCVWFSs2UKBWjNX0xg4q3YoNVBwhR1OUKsi4vu4Tdap2G0f6HR7G7e2fqp7TKpvjOIRvUA05U5zvFB8W0TJCkE7HBBxdBnUjTLqLkJu1uXdqGBtwue9LqGuZPI0G+YZENMfvkESaUtGk51tcUBMLD5wYQ8mEiKlm+8xohA0pWZjqViTZKFQk91B2spJYu0ySTzlIFmdHUgQeij//dV6B2qxCycujGkOqNZzfUDa8xUUweWRg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Wb9cq9xFl+iZwFMULQrdIc3QLx1Te8+93RQTxgSZ1IM=;
 b=a+1pmHiTzpcFr9dDV/en+O2VJTg8VlHbMWKEAENsts3FYx1XmOF5+3LlBUSm4hJMSNSyIajITwzxZXPTIYdch4l8qbl/jX9+ktNzioRcinopiHzAf22xz0DpQhOTRfnfHFCcMQ/W4sl+dVSIGexpLwS5gePm5x3hPJqGVBtgw2kQPRfq5ok1dlrzlRFOEJ+UGKDYztWs60XJGlQekvyAbU8VOP6PtUqDsVYI5kohIi0WuRO7ff0eI5GUrKVgNfp8fqgwIhnVXmISM/BhWi+YMGiGUTkxt7/lt4v0DU+YXiT3f8aTcQ5WJam9QZNHa5arx91eHFTHWOAoQy2/5oEk0A==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by DS7PR12MB5741.namprd12.prod.outlook.com (2603:10b6:8:70::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.339.8; Thu, 20 Aug 2026 01:35:06 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%5]) with mapi id 15.21.0339.007; Thu, 20 Aug 2026
 01:35:05 +0000
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Wed, 19 Aug 2026 21:35:04 -0400
Message-Id: <DKTDVK2AL7WA.QI1IO4DKEQJ4@nvidia.com>
From: "Zi Yan" <ziy@nvidia.com>
Subject: Re: [syzbot] [mm?] [gfs2?] WARNING in read_rindex_entry
Cc: <apopple@nvidia.com>, <byungchul@sk.com>, <david@kernel.org>,
 <gfs2@lists.linux.dev>, <gourry@gourry.net>, <joshua.hahnjy@gmail.com>,
 <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
 <matthew.brost@intel.com>, <rakie.kim@sk.com>,
 <syzkaller-bugs@googlegroups.com>, <ying.huang@linux.alibaba.com>
To: "Andrew Morton" <akpm@linux-foundation.org>, "syzbot"
 <syzbot+9d20c3ad7d29227de28d@syzkaller.appspotmail.com>, "Vlastimil Babka"
 <vbabka@kernel.org>
X-Mailer: aerc 0.22.0
References: <6a863306.ae6ddae5.3da009.0013.GAE@google.com>
 <20260819171409.e30eed94c3f7eb44b38e5ec7@linux-foundation.org>
In-Reply-To: <20260819171409.e30eed94c3f7eb44b38e5ec7@linux-foundation.org>
X-ClientProxiedBy: MN0P220CA0004.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:208:52e::15) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|DS7PR12MB5741:EE_
X-MS-Office365-Filtering-Correlation-Id: 570c8c1d-14d1-4d9b-59c8-08defe5b432a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|23010399003|366016|7416014|376014|10067099003|56012099006|6133799003|11063799006|4143699003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	1oohi+GHpsei+hk6RW2vQcs2C3g9vNoRZ3yasX/X8mst6902NkGMRAgNQR5LBwUn8o9I8QJSEZC+GrwvJCD/gFKIEbxdF33lHTcjtx8UkMkOAiYgf60i+Jk4pAD0ORd//QmTdNj2lfqrYh4QD6sqi4DuLr1J9ldVnU+33rhv7GG3af5yY7vBDFMGb69iVqRxRWBfGNeGpdWDWbG7/o3ltI+AkbeL6HfYUFrZAyQd4kEWXgNvnRtEPWdBBHYScoNz14dps2thtg92WloYuELN+e461Ho9Bm/nBQSutm+QoH9jkGGLip5a8HVmx0DuDBbaFI1zXLxj5gopBM/TIvTFnVLS+kHZm7H3hWEZXHY1VqQ03CvW3ghuGgcTWU05Ps2bvT1hBhFe8GFmUvIQwgiAVe3Ju9rkd3CclH7UkbDtdCzhLbQoo50bH2Bie/IduqUdQtXRx4PnNKjjctc6pqLXBSBeP/7ANWpWnBF12b+HMqObExSbIv0NYlAoFyvsxTE4Q/cKC4/4PrkofVXz8d0MKBRsx6qZlxFCFBDMVzFXBWsK59nLmfIaNPbYigGdurdogntFpAUBZhevnwqB1se1ukGEaqfXCNATzmbAG/G8mudB/HjRc/JW/DIU9Fk180RNXRA9zj1CXI+2j28dIj5vaIiheVivwgY9KEsPq75sSkA=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(23010399003)(366016)(7416014)(376014)(10067099003)(56012099006)(6133799003)(11063799006)(4143699003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?VXN4NjRMQVcyeURjSlVRazUyUlFrU2Jvb21iOFFkUFROK09CZ20zNjFzVlN6?=
 =?utf-8?B?SGNoL3F1UFNFZ3VDV3hXUkFDbEZscXZVclNuT25xTVRrUklCWktjbWdnN1JT?=
 =?utf-8?B?aHhwMTJ1ZTR3YnFEYllXY2phUUdqRWhSbExzaW1PeWVQcUVDQWFOakdXSXNt?=
 =?utf-8?B?ZExYeU9iSkpjL3l1WjB5WEhqNEQwZXhTMFlUUk03Vk0ycHFTR3hnZTYzV3lh?=
 =?utf-8?B?SFhZUEhEV0lCYURFQTFhUldIUkdFWE1yWmg5MktnL3FwakVqMHNsaUJCUjZ0?=
 =?utf-8?B?UG5scE1rOWN3ZDhsOTBoTUgxclUrTUJ6QmtsRWdncHJzQ1hYY0NBN0tPalpM?=
 =?utf-8?B?STFHNE1IREJyWmNnVVdacUp4akRzS1NGQUFmNjNqSktadFF6azBDcFh1elF1?=
 =?utf-8?B?aExNdlBoWXJTQnc1QnA2Y3hsbEkvTWlyV0pVV3lvdlNCU04xbXUyTzN4aGNB?=
 =?utf-8?B?b1VLMUg0Qy9NUHQ2aGdFd2lEWVBEcDRsVWQvV0FnZSs5cFR1UHM1c1hJUmRN?=
 =?utf-8?B?OG5iM2JsT0NNNkNDMXVNREx6SFpTWnhNZHBrbGZ1NGx0Ui9BVS9jV1FZRVJL?=
 =?utf-8?B?VFZsb2V0b2dVb2VHZ1Z3YkJvODN3WDMxckt0bHBRV2pyOHdOaGlpKzBORXFz?=
 =?utf-8?B?aW1uMTRHV0NNemc5SVVWY1FzYzlITEJKL1VTZGl1WjJhby9ZRTJPTUV6dk03?=
 =?utf-8?B?eFZCeDZFQW9Sdy8xZ3lMeXFTcVlCeEg3amdOMWQzRmVFUHpSanQxb2JrLzc0?=
 =?utf-8?B?WFFCRDFsaElMamxxNys2b3QralZkUTNYMWIzNEI2b0ZTRWtJM0pUbHB5MmYy?=
 =?utf-8?B?Vk1jZnlSZFpiRktsSU9WQTN6VGNsbk9KeEdqRWc4MVZyWGExQzFOT0d3VmxO?=
 =?utf-8?B?SXlRbEJVVzVWc0Zua0FyOGNZQnhaMkR6L2dNVmN4eGpjMTVtZFd0SDJNRVFr?=
 =?utf-8?B?d3hXc2EwV1M0WlZyaytUeTRySkxqeXBGYitsVUFnWG1oZGF4dUFNZzArUUFK?=
 =?utf-8?B?d1F4K1hTTUJVeUY0OWlFS3N1K2ZBWDRtZVFMdHpYVkpHTDlsVHFTdWlxVEhp?=
 =?utf-8?B?d0VGWElzUVVUZzV5MHhwZEgxeUYxT1lzejBrOFNGeXBqaThRTjRGL2ExZ0Za?=
 =?utf-8?B?S09OYWFHdFB5eFU2ZGV4WkpJa2xlRjB1TTdsRlRCcHhJMCtlMGRVWFJzWXVZ?=
 =?utf-8?B?TWhHMUN3NFMxL2svd3pST1cwOHhoQWY1R1RQWFFZZS9sOXhUZjk3SXVPaDBt?=
 =?utf-8?B?WkZQVW1VVkd2STlsMHFxaVlCKysveG9ZUEpRUXZwQWRiWm5ObDVYdkdMYlF0?=
 =?utf-8?B?SWhySWpSMGtOR29MaVY1dGt5VVRwSjRYR1BtSW1rVE9XRzcyZVovY2h5b1Ro?=
 =?utf-8?B?SkZIelQzMXkwQXRRNTU5aGlJaW5rU3ZXVS9FK1Y5dkpXYXBMTXY2UTRwZC9v?=
 =?utf-8?B?Rk9YOE0zZkhFdzUrWFpFb05IeEI5a0VVd2I4akt4bFE2cEo0UVdKRVV4ZndU?=
 =?utf-8?B?MGlOYVdvY0hTWXhoOTIxbmNOK2pNM2pQVENaeE8zc3J6MzRsc3dlU1U4U3JJ?=
 =?utf-8?B?RE5lU0JYZENiRWduSWNiOFU2Y3R1ZmduK24rZVR3d2lObk5FaWpjcXRySnRF?=
 =?utf-8?B?eHZjMFcwZzM4dmFVRUtOd0l2bE5aWlZZS1V3T0MzWUhhRE1KZ3NzdUxPdGxS?=
 =?utf-8?B?NFZKVUtHRWVpQWg5UmM5QnIvK2NYMXFjVng3R3FLMUpkMGRJcXJPZjI3RU9a?=
 =?utf-8?B?eU9PeWNkQlRyM3NXeko1SFRWTDBVbEJ6ZnhRVVpsOXlScGJKWHFhZElselpt?=
 =?utf-8?B?ZzJRVk1xTUNJdzZ3SStsMHk3aThOU2dtdG04aVp3L3hvcXRDSEhUKzlOdnVC?=
 =?utf-8?B?YmVmYnZqeGlWQm5LcHFZMEc3bWE5RWcvdGxDbDN6UnRnVU1seERTRXNaQVph?=
 =?utf-8?B?dC9ETzJEZ2pzQlhWSFE0Q0xZQlp5NG90YVdSSGs1MDZDZzVXZ1NzYUc5WUs5?=
 =?utf-8?B?ZFVUa2NFVjVjVUZCNjhsY1ZPZXJKOVJmK3A4a0N5a1BTZDF0WFNiSzVSams5?=
 =?utf-8?B?cXlKZW9oYVlGa29LMDUvUlp4NnhCeUtFTUw3M0NDQVlnWkdaSjVESS8rVm8v?=
 =?utf-8?B?cGZYMjVzS21kcDNNeVI4bm1MSzk2OE9hUGJOVVcybzJRaC9uUm56WlpvT1Q2?=
 =?utf-8?B?VEpFRFJsaWpzZVpENnBkNkZaWlJnQXJWZGwyaHRwVHhzZG4vMDFqM1JXVWtM?=
 =?utf-8?B?ZzBHMzVFaFpRdTBRTnYvdGNwT3NsaTFyWXR5dURXS2JXQnhPMkVBd2tTSWhZ?=
 =?utf-8?Q?ZTjEWpCOLB1Ac29M/c?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 570c8c1d-14d1-4d9b-59c8-08defe5b432a
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Aug 2026 01:35:05.6644
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: N0advEY9Hfd8e4aj7lkxC0ooJ1dib/bURwOLrWgJCfGjluy/DN9pTgOuHoObv3hh
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB5741
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 9400040006
X-Stat-Signature: dsyp8swf9wmxn78d6o1ussadjhqab9tu
X-Rspam-User: 
X-HE-Tag: 1787189712-117723
X-HE-Meta: U2FsdGVkX1+qKEAApfPbPjDmyBeK/IbQlckxZ+785P2tQPylpH4dbIPEFxjLzucz/yY2n5v9jr0sYJ/pBPvAt0congA2LPHV7ix5cwrmT2GrY0tzNHawWuxT3WC1nfnVwg+1hvaZV/pB/OYJQ/RLDy9eemsnNqifE9PZxsQMWQXGytkjmUrDamtDYJpZ3V1QgCaPRiJRVNStqZRelwT8toiVKMYhUO3ihFtJQiA+cQ+WeI/b/HoiQ/cDWpnIhAeQXNYkfouoEh9tnCVhPADcPRkdXP2h3QGb16ZLEdjBDTQWB5x9dbr7/1VIvH1ZTSI0SuLxAyYhkTP6JXEvED6PCGTDdC+nPnDh6KU6jBHrkP0cPFZX+Hz4MDNxZX0HyG76oRQ1VTswHpWhEKQ/ZYqDs1sDFj/RG+4xIK8c0m79j8zUDZdcaP+hM82nEZkuk/yCZWXWE+OQdDen0UOriVPsiEBff5o1K+t61dnwMLCeIqjUPvrv7/pnc5BfG7otHVxzKPO6MQPgMWH/7hLxNv6yAzjNbvMJ/ZTjtZ5HjZ/jPvNSBNlQaEqcdeC2cSYc9gLC56auP4I2hJdhFQjuSoI3jHbCyb0Vuy/desPPvX+nZmDr21P2L9JDGHRXyA0nu6PhSt19z7PptFn3AMQrjTN5ee4TQx7R90Qc5RxLL3TphULNUKio0ANa9TIGWjKDWaRTyeJAfuHbmfvII2yJyzpCEOeBsiqzhu5IFx0W+o+4rP4D1kfWJF1ciSWJcdJHHWQEeJ1wFaodyQuGvFYFeE0maAaPRJ5aXQ64w0rMC77k3WU7bCMGi6F7a0P44PC27qjtVHev0Snk3Kgx/LdjNTs84r3JJxlPivplFvKZSgH0V6FVc7J26xcnMJ8IN863c2m6/jkAteuT8r6tRm99kUl9KKAsp7OlIjF0rWSSFZTlox5iLyEuju8GLExKtWqdQwZF2dYfuZCSBce3kUo7YUS
 +E4n40Se
 +bg0kfbt4l1ulEaHUwJfgkoFT4Wi14nKRnxEB6FOyD6QxFUw2BNeiulUm6wT+cVl3qxglaemkpMnccfoMb+WU1N45t8BI7zakpzzKu/MpRKdK6U/cY5ipvZJFEUnka6XfvcIE9OGFPO+DVWAQ50mjPHIx/FdhoAxVJfQ7NGw71alyvxzQ662mgLPeTuANka0ydjFr3G7EtSHI35eoeZqnKLkQasgFrBGPFCh3BR/NPkUTbIi2VQ9kQeYtsKOosIvbfQX3pSB21L4rMWMkFJmlBtOjLC71BAtEISx3sukyIilUCCfRH4FxqR9rYYnTpoBLb1aAWZVpOUJxpN/L0bOr6Og41lguMIBbWCmwIpi3T88Eu+hehu/l+U7ZheIokgYHkbCpAQs6xSUgl4awYrdQ+6739tBSrH1DgQH30HUIC1asjxSAwPrRy6Odv/lcxERiAYzggXrWSTU8Q/LkX3jww/0ZDRraPxhjmQdcdPjUohsLcpytELC7z2bp24dzBUm8MVRxORjLCAgj+uoiEVpYmwlW2TyGtqNL81vm+NlhM8g40tJP+10HN4WaPf+pquMQTjPXjKY32ZxsXTFZGBaXKXR+GJo2IUPhY9a5Qtq9SFj0vo6Qiezx0rNSbZLcoRINpQ8cghmub5QdTdF91k5FsvOZaqs5e6s6wL6pIRdZNpOAYaXS9nwuM7crOLkHRv8Ka/yQA19Jnx8BLVHUnSTljniqymLcVESDUtyA9v2YDLxy1AXHMz51zHoDsqzGcvgkHaRhqv+C+0UW8L4oyrsbNp9y16oUvs+Scw5G4po1/FKVxLC1lddf/8DPNfeWweU3qHmLR97gh/qoiR0VNUsM329DJVPUWPsQzqJJLyLgwr5GZr3puwb6IMOBUrL8Bt9g6uxMlsG4KGJKDnLy3T8zVU7LfqjM2nrN4EnZ5oB9+L6kdFJSRxAEOGNK52gQIhXlLCPkGwnNbHRIfRq7QyvcKDEjoS+6
 QYOmBPSe
 olqbbeqc4AiqEbIzV4eTRx8rAyxglQAVsLkvkXvfGvgYrMpgr1ImH+7LVQd8IeZBg+ofqX1JQlbqweejNXFvoa+cXZF/q65XqCWWmnetcBZOMlIMVRa5rkrWYDep1DUeKX3fnzL50YCroeNjbkKl0AZ/nBFF+Van31lq252MUd190w0MikkicUGimdqjwJnA26mxq69/kp7gYA9YoBsym9MtdwNSV2OGpUefw2R3xbcIXsaZp8aCHOt2YUBybsRi3DaJSuORX1GbuF0AT/PpQErnWzIFK7LJ7r/4ZHn039Y33hzNhm9iUwZdGAcv7bSi+1k/2owTCBAerzUu3f9iTO4bbrGXYcRapqCTTx6Wo2k=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed Aug 19, 2026 at 8:14 PM EDT, Andrew Morton wrote:
> On Wed, 19 Aug 2026 15:49:42 -0700 syzbot <syzbot+9d20c3ad7d29227de28d@sy=
zkaller.appspotmail.com> wrote:
>
>> Hello,
>>=20
>> syzbot found the following issue on:
>>=20
>> HEAD commit:    15ef2f78c49d Merge tag 'input-for-v7.2-rc7' of git://git=
.k..
>> git tree:       upstream
>> console+strace: https://syzkaller.appspot.com/x/log.txt?x=3D108712795800=
00
>> kernel config:  https://syzkaller.appspot.com/x/.config?x=3Da0fdc3b56674=
6377
>> dashboard link: https://syzkaller.appspot.com/bug?extid=3D9d20c3ad7d2922=
7de28d
>> compiler:       gcc (Debian 14.2.0-19) 14.2.0, GNU ld (GNU Binutils for =
Debian) 2.44
>> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=3D1487127958=
0000
>> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=3D100d2a255800=
00
>>=20
>> Downloadable assets:
>> disk image: https://storage.googleapis.com/syzbot-assets/c2a8c7d3a889/di=
sk-15ef2f78.raw.xz
>> vmlinux: https://storage.googleapis.com/syzbot-assets/2da78afed345/vmlin=
ux-15ef2f78.xz
>> kernel image: https://storage.googleapis.com/syzbot-assets/c4ffd97e4708/=
bzImage-15ef2f78.xz
>> mounted in repro: https://storage.googleapis.com/syzbot-assets/eaa412081=
2b6/mount_0.gz
>>   fsck result: failed (log: https://syzkaller.appspot.com/x/fsck.log?x=
=3D17f52a25580000)
>>=20
>> IMPORTANT: if you fix the issue, please add the following tag to the com=
mit:
>> Reported-by: syzbot+9d20c3ad7d29227de28d@syzkaller.appspotmail.com
>
> Thanks.  Mounting an intentionally corrupted fs image, I assume.
>
> It appears that GFS2 forgot to validate the `ri_length' which it read
> from disk.  That gets used in compute_bitstructs()->kzalloc_objs() and
> the memory allocator didn't like the excessively-sized allocation
> attempt.

+Vlastimil

This makes me question my recent patch[1] that returns NULL for kmalloc
sizes bigger than KMALLOC_MAX_SIZE. It masks this issue.

Probably, we should use __GFP_NOWARN for the GadgetFS warn[2] like
Andrew suggested, since the caller does not care the NULL from kmalloc()
is caused by invalid input or ENOMEM.

For this one, GFS2 needs to validate the ri_length.


[1] https://lore.kernel.org/all/20260817-limit_kmalloc_size-v1-1-5bef487701=
cc@nvidia.com/
[2] https://lore.kernel.org/all/6a820ebc.9ebadd4d.20b15e.001b.GAE@google.co=
m/
>
>> gfs2: fsid=3D.: Now mounting FS (format 1801)...
>> gfs2: fsid=3D..0: journal 0 mapped with 18 extents in 0ms
>> gfs2: fsid=3D..0: first mount done, others may mount
>> ------------[ cut here ]------------
>> 1
>> WARNING: mm/page_alloc.c:5280 at __alloc_frozen_pages_noprof+0x2427/0x2d=
c0 mm/page_alloc.c:5280, CPU#1: syz-executor256/5629
>> Modules linked in:
>> CPU: 1 UID: 0 PID: 5629 Comm: syz-executor256 Not tainted syzkaller #0 P=
REEMPT(full)=20
>> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS =
Google 07/16/2026
>> RIP: 0010:__alloc_frozen_pages_noprof+0x2427/0x2dc0 mm/page_alloc.c:5280
>> Code: e9 8d fb ff ff 31 d2 be 28 12 00 00 48 c7 c7 a0 64 e1 8b e8 5b 8c =
69 ff 2e 2e 2e 31 c0 e9 02 ed ff ff c6 05 54 c1 9d 0e 01 90 <0f> 0b 90 e9 6=
f df ff ff 48 c7 c7 80 ae d3 8e 45 89 f7 44 8b 74 24
>> RSP: 0018:ffffc9000345f0e0 EFLAGS: 00010246
>> RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000000
>> RDX: 0000000000000000 RSI: 1ffff9200068be36 RDI: 0000000000040d40
>> RBP: 000000000000000b R08: 0000000000000005 R09: 0000000000000009
>> R10: 000000000000000b R11: 0000000000000000 R12: 0000000000040d40
>> R13: 1ffff9200068be74 R14: ffffffff9b759444 R15: 0000000000000001
>> FS:  000055556d263400(0000) GS:ffff888123ee1000(0000) knlGS:000000000000=
0000
>> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>> CR2: 000055886dbe9978 CR3: 000000003394d000 CR4: 0000000000350ef0
>> Call Trace:
>>  <TASK>
>>  alloc_pages_mpol+0x1fb/0x540 mm/mempolicy.c:2490
>>  ___kmalloc_large_node+0xe5/0x120 mm/slub.c:5274
>>  __kmalloc_large_node_noprof+0x1c/0x70 mm/slub.c:5305
>>  __do_kmalloc_node mm/slub.c:5322 [inline]
>>  __kmalloc_noprof+0x5a1/0x820 mm/slub.c:5359
>>  _kmalloc_noprof include/linux/slab.h:992 [inline]
>>  _kzalloc_noprof include/linux/slab.h:1309 [inline]
>>  compute_bitstructs fs/gfs2/rgrp.c:766 [inline]
>>  read_rindex_entry+0x4a1/0x1250 fs/gfs2/rgrp.c:931
>>  gfs2_ri_update+0x6f/0x3b0 fs/gfs2/rgrp.c:1001
>>  gfs2_rindex_update+0x40b/0x480 fs/gfs2/rgrp.c:1051
>>  init_inodes+0x1f78/0x2790 fs/gfs2/ops_fstype.c:872
>>  gfs2_fill_super+0x1d3d/0x2cf0 fs/gfs2/ops_fstype.c:1250
>>  get_tree_bdev_flags+0x38c/0x620 fs/super.c:1640
>>  gfs2_get_tree+0x4e/0x280 fs/gfs2/ops_fstype.c:1332
>>  vfs_get_tree+0x92/0x320 fs/super.c:1700
>>  fc_mount fs/namespace.c:1198 [inline]
>>  do_new_mount_fc fs/namespace.c:3765 [inline]
>>  do_new_mount fs/namespace.c:3841 [inline]
>>  path_mount+0x7d0/0x23d0 fs/namespace.c:4161
>>  do_mount fs/namespace.c:4174 [inline]
>>  __do_sys_mount fs/namespace.c:4390 [inline]
>>  __se_sys_mount fs/namespace.c:4367 [inline]
>>  __x64_sys_mount+0x293/0x310 fs/namespace.c:4367
>>  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>>  do_syscall_64+0x115/0x870 arch/x86/entry/syscall_64.c:94
>>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
>> RIP: 0033:0x7ff9e8de99ea
>> Code: 56 53 b8 9d 00 00 00 0f 05 83 f8 ea 75 a2 c7 05 a4 30 0a 00 00 00 =
00 00 eb 96 e8 51 05 00 00 90 49 89 ca b8 a5 00 00 00 0f 05 <48> 3d 01 f0 f=
f ff 73 01 c3 48 c7 c1 d8 ff ff ff f7 d8 64 89 01 48
>> RSP: 002b:00007ffc770eecc8 EFLAGS: 00000246 ORIG_RAX: 00000000000000a5
>> RAX: ffffffffffffffda RBX: 00007ffc770eece0 RCX: 00007ff9e8de99ea
>> RDX: 0000200000000040 RSI: 0000200000000100 RDI: 00007ffc770eece0
>> RBP: 0000200000000100 R08: 00007ffc770eed20 R09: 0000000000000000
>> R10: 0000000000008cd3 R11: 0000000000000246 R12: 0000200000000040
>> R13: 0000000000000004 R14: 0000000000000003 R15: 00007ffc770eed20
>>  </TASK>
>>=20
>>=20
>> ---
>> This report is generated by a bot. It may contain errors.
>> See https://goo.gl/tpsmEJ for more information about syzbot.
>> syzbot engineers can be reached at syzkaller@googlegroups.com.
>>=20
>> syzbot will keep track of this issue. See:
>> https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
>>=20
>> If the report is already addressed, let syzbot know by replying with:
>> #syz fix: exact-commit-title
>>=20
>> If you want syzbot to run the reproducer, reply with:
>> #syz test: git://repo/address.git branch-or-commit-hash
>> If you attach or paste a git patch, syzbot will apply it before testing.
>>=20
>> If you want to overwrite report's subsystems, reply with:
>> #syz set subsystems: new-subsystem
>> (See the list of subsystem names on the web dashboard)
>>=20
>> If the report is a duplicate of another one, reply with:
>> #syz dup: exact-subject-of-another-report
>>=20
>> If you want to undo deduplication, reply with:
>> #syz undup




--=20
Best Regards,
Yan, Zi


