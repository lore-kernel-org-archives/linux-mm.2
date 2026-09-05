Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AD62CC624DB
	for <linux-mm@archiver.kernel.org>; Sat,  5 Sep 2026 16:12:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 928D76B008C; Sat,  5 Sep 2026 12:12:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8B2756B0092; Sat,  5 Sep 2026 12:12:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 752A26B0095; Sat,  5 Sep 2026 12:12:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 479B06B008C
	for <linux-mm@kvack.org>; Sat,  5 Sep 2026 12:12:04 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id AB551C013E
	for <linux-mm@kvack.org>; Sat,  5 Sep 2026 16:12:03 +0000 (UTC)
X-FDA: 85180200126.09.4100F70
Received: from DM5PR21CU001.outbound.protection.outlook.com (mail-centralusazon11011060.outbound.protection.outlook.com [52.101.62.60])
	by imf08.hostedemail.com (Postfix) with ESMTP id BBBD616000B
	for <linux-mm@kvack.org>; Sat,  5 Sep 2026 16:11:55 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=h13O7c2q;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf08.hostedemail.com: domain of ziy@nvidia.com designates 52.101.62.60 as permitted sender) smtp.mailfrom=ziy@nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788624715;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=t75tNt8IYJ1NpnIKzaoxFOFeRX7FDrmGqgh9+xX3FNU=;
	b=fpwh/OfQOXJqvFctV+37lkntwpj+odIC0T9i3NRLZ6u3koplzp2FHQ//KkjYpJgaU0VLf9
	yUpQO8py1G8xzGQr5kNUXbeGneJe2JU8rHb8vt2VALl4elTIOeC3yjw3TLWzpTk2afc2Fl
	/1dRYzzwIBdGMMTSKwSb+HGq9F63rAM=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1788624715;
	b=ygS7MztFqCJ2PqmMNYo49gCpKQ3n1ZCwi547uKvw8x+lusSRupNPX8654F+S39d92q1aQy
	MJBTQs8/qNQHU/5dtg6noDHJ0uXHZwKcsxJEn0DaZ/9IaibU2RVEWzbnfeHmNfFDLX5po1
	0AhCIsdb56z5ZCDDBqzxLvb2Jo7jCrM=
ARC-Authentication-Results: i=2;
	imf08.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=h13O7c2q;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf08.hostedemail.com: domain of ziy@nvidia.com designates 52.101.62.60 as permitted sender) smtp.mailfrom=ziy@nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Cdg7l5D1g9T0H+p5afpWQkgE/6vdFaHjGh6NTfN9kbu2mhTpCFYs+894vXC6wSGm6HAtHLsr9P80RD6jdW69siclHhu1+8DlR9tOmKHNpukaeFcokWQwaZ5jvCNJQ+Wotqrj5IckruPQruehrv3KqPrEJgrXyLxLXopbQm9CEuCfrrQjI3x4C/cg1LMkFubxQH352n6ulvOps6Hcu88rKScUn04LuI7kpBhfA+gtZPOhv+JZ9SS3k2dH8ExCN2/q52QU6tZ62RdadS3gK3lq6Paty0g8wJmTQXkXEW6cX2Ge5AkW03s5fFIx+uXn9xSxgRTuYwenavgDU9cHoqLS4g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=t75tNt8IYJ1NpnIKzaoxFOFeRX7FDrmGqgh9+xX3FNU=;
 b=pX/wufQHJ8sY8ZKuxk3WxsgKwlqUYUncfnpVOmKWJ6zad3aI/n4sQT2fF5GtUVvRh8pqdgXCDgywCooYgjdEDAcTzCFj6LFfxciEREiZKZRcR1fCWhDUT/g5t9mKNmRIm4bgJlWGHK5XbSnR3UI6GNLZ4YE8R3VW0c6GAZ0KTo7G3eiM6woPUwaNUZv+Yc+AxNbXxrqXiMuqGtKt47mPbO2RD2CyvoFugNeajpVFnip4PpyR6jXNKA0A9YWV+ibPVilKoS8l8Dgykg5WzQ3GLMmDMrDgQcfITOH/FP8RAwG7Z5SLX2v90sTP5VBxGYIaa8g4JuL2DlIvrgLvYngneg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=t75tNt8IYJ1NpnIKzaoxFOFeRX7FDrmGqgh9+xX3FNU=;
 b=h13O7c2qq6Krc5kHqgcR8ZGploBT/4TmZiIAJtEtquspzIbDi00Mjd4lwYk3lx8sA78w3175mmLG99ZWwDBAPbt5DOALLtz+CHO5tf9VQcSGKzw3gytl0L3R0l/c2TfXL5Z09bzlag50XwVriGL5U7BDvuvFxQpd5gMjDaKM4P7IOVXAlH3dYeqMEI/lsYJJJHk7HyzOdysgzCUtZQlp/kDTahBDrVnXEZr9m19vr+iSu0f8kAyaUYXWN2a8Nsd5HDCQ8HNlltAJ89jWIyTp5z06JoBXQrWsVp+hye0iMLm27o7i87SlU2GL8ORuaq5JuPAxqdkcihdC+X7FexByWg==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by SJ2PR12MB9162.namprd12.prod.outlook.com (2603:10b6:a03:555::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.382.14; Sat, 5 Sep
 2026 16:07:48 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%5]) with mapi id 15.21.0382.012; Sat, 5 Sep 2026
 16:07:47 +0000
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Sat, 05 Sep 2026 12:07:46 -0400
Message-Id: <DL7IGGNMLPBP.3LRVS1CFLYS6L@nvidia.com>
Subject: Re: [PATCH] mm/huge_memory: fix various coding style warnings
Cc: <baolin.wang@linux.alibaba.com>, <liam@infradead.org>,
 <nico.pache@linux.dev>, <ryan.roberts@arm.com>, <dev.jain@arm.com>,
 <baohua@kernel.org>, <lance.yang@linux.dev>, <usama.arif@linux.dev>,
 <kas@kernel.org>, <vbabka@kernel.org>, <jannh@google.com>,
 <pfalcato@suse.de>, <kasong@tencent.com>, <qi.zheng@linux.dev>,
 <shakeel.butt@linux.dev>, <axelrasmussen@google.com>, <yuanchu@google.com>,
 <weixugc@google.com>, <mhocko@kernel.org>, <linux-mm@kvack.org>,
 <linux-kernel@vger.kernel.org>
To: "Christos Skarlos" <christosskarlos.kernel@gmail.com>,
 <akpm@linux-foundation.org>, <david@kernel.org>, <muchun.song@linux.dev>,
 <osalvador@suse.de>, <ljs@kernel.org>, <hannes@cmpxchg.org>
From: "Zi Yan" <ziy@nvidia.com>
X-Mailer: aerc 0.22.0
References: <20260905140140.60792-1-christosskarlos.kernel@gmail.com>
 <20260905140140.60792-2-christosskarlos.kernel@gmail.com>
In-Reply-To: <20260905140140.60792-2-christosskarlos.kernel@gmail.com>
X-ClientProxiedBy: MN2PR16CA0052.namprd16.prod.outlook.com
 (2603:10b6:208:234::21) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|SJ2PR12MB9162:EE_
X-MS-Office365-Filtering-Correlation-Id: b44a795f-dc86-41b1-21bf-08df0b67d41b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|7416014|376014|23010399003|10067099003|4143699003|56012099006|11063799006|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	CT0HSTZGZlJu0vXmgcOEYHqSS8pCVSXw/Emp2x1ckYQjSWmRY7mkvb5TQVnumRVPYNKzL6Wl6YvImn8QCYapTTI9nDGPP5rpBPbmVT4LrIbGrGTWcO1P30MxUh08cs4pA/wgDM5ap0PTo1oge8dk/0HgO9BTaK7pFHtPrx2vQkU+L/aF6R9HFLUZQg7BGzjq6oVErT8ysBltEboDy+RBZEYc6EHANzjfyiOmTmRl2J/YjOLQ7XNkZDu5h9A3z5g/ggoan+s1hUxcrGr1Q857WEFZmPSuTB5/ZO9dlZ7Xe9vcnMKZ11E+fxhgDffGToDkn8yZVXfWGwq7rxPlakZXu4Jrh9CN5JacaarQWvnTPSXun2mJg5OLDqHs/7l7YdjuMLVeT7dNcJKBrNlfP7XAVfr+yZPpDya/9HoyF3PUXSdUaVicnvHsGJeYKyy9b3/+k9P5/EdpEsmlImtyDUfla6QQSNNDvcYznwDzBslnhdQv4/CiWLsQ3yHmE+jCyBArsK0N/rDFvnKpYGZAL7kJZ2UL1iwkhVtMD8ITiP/J+lLXPoRBmTn2nMQe+qk2XKP4B2XJ029Jt4RrbaX1cczsizY7LRBjnt87ImqOHBzBhTLuJNu0pPvJPeLrRdtZpgxOiwwaUqgPNz+lBCBP6nS+x+I2sNdPQowBwdYtjFCEQUY=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014)(23010399003)(10067099003)(4143699003)(56012099006)(11063799006)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?aHpBaWtHc0pPN0lSRE9NTnVLTGhYOVdIVVlaRisyUWdRRDBkdXhRMjB5bkxM?=
 =?utf-8?B?NS9LL3psaStleHkxSXNCbzNuUUd2OHdCTlFPZGlpb0kyS0JsdnQ1TFhObXdt?=
 =?utf-8?B?NE9QZ3NGeVBGQWN5NTNUVWN6SXBNaE55T1k1bllhTGt6WWUvK28rcUlRMldy?=
 =?utf-8?B?VVBEWWduQ0tCZXVrTnRaRWJrWkl6QkpZdmlvL3RteFJJNWhvRmoyWnNPbHZh?=
 =?utf-8?B?d0dqQ1ExWlhaNm1CMEhoZ2pIbUIrUEJ2MmNCNnBIbk9ORUYwMUJlM1BWWUlk?=
 =?utf-8?B?ZUc2dzB6ZnMrMFN1QmV1cXZUaUFONGFTTUdQVHF1dFY2RE1ZT2hoQ2gzQm1q?=
 =?utf-8?B?Nk4vNzM5NTJlbXZjMC9idDhMdjZJaFg3b3g2bXVkUXZYWUdqemg0bERHdnNI?=
 =?utf-8?B?SFFvT2VHbnRUdU8xdWdlOXpoa2k3dkN0OXI4N3A1Ym53WmxSclc5QjdCUUow?=
 =?utf-8?B?MHhkSTQvVmdoQmdIS0ZVOExvRTk0QkdRbWIvU3hTQVdqMWMwMjNlbithMmR0?=
 =?utf-8?B?QnFWN01ZZTM3TnpmMXNST0gvaC9uc1ZDRGxqTVdJMHkxWTZpWTVxME9xYmE3?=
 =?utf-8?B?WGs3UWNlYlBEc05nK0w1SnJpUDJxckJUNktCZGwvc2pwRkxzTWZUWlhkeG1P?=
 =?utf-8?B?cTJzNE9uZlM5Tm84WGliQ2x5NFUvNjRKRXE4MDNJbmpBRXllSVFVSmxGTW1r?=
 =?utf-8?B?aEpwbnhMTEg4ZmlTYmJwSWkrL0ZjaUI0bWx3WlMzb0xkclYrNzgvOG8rZ1kv?=
 =?utf-8?B?Y25IL1Vib1dNS1NRNXBpYWpVejhFT3BjU24zU21iUkpWTjZMVjhBYjVrMDF1?=
 =?utf-8?B?VjB0TDNGaDZNSXE2U3VTcFQwdmdRSkJxOG1GV24vNmYxclpudzZEOWRPSk9I?=
 =?utf-8?B?ZFduSkxMUnJoQkxrQkE2a1JOS29WOW5ua1AzUFFqYmFsN3lrWWJ4cFVlRnJZ?=
 =?utf-8?B?Z1VrU1VkVm1CZ1dQWXhmblR5OGdUK3pIWFpaSFpaSHlleXpuaTRsVCtzWTVR?=
 =?utf-8?B?bXU3ZEk2cGJtUENWd1kwTzN1M1ZnWFlGUGM2S1FaeTVnNFRpMzVZTE9lUHFK?=
 =?utf-8?B?c1ZBTi9Xa3hBcExUOXRmL0NEZWZEekVQbVRneGJhNmVpZ01zNUgwRTI1WTBk?=
 =?utf-8?B?ZTgvMHB6aWNIT3l3RHluc1htd2dNSHlFVDcvVXFuUjdrZXc1MXZQeEwzZjBS?=
 =?utf-8?B?ZG9TMm0vdnVJUHc3anQ0MnJUR1UrMS8yR1VFaDR5Z1NSZ2ZyMUV5NGp0NFEy?=
 =?utf-8?B?Vzh2VWU4dGhrZXpHbEU1Q1Y2NDR2QkpkTFc3LzBUb3ZEWGZvVjJ1Sk03NElG?=
 =?utf-8?B?WVlQRW9IYjNnMzVDc1RtVnVnWTdScXVDbThadnlvZmVDaTR5bnl0QXVmazNL?=
 =?utf-8?B?RWc2WXhKME9ob255dmNPMlJaS0RidVN6bkxCQWs5Z0hucHl5Ylg4YW0rS0J1?=
 =?utf-8?B?UUFXUGVIN2h4WDZEZjBaVjY2YmhHbGdEaWRzY1ZoeW9jbGNwZXcvWm5LSHlm?=
 =?utf-8?B?amNDOGdiSGpzQUpKeCtXaExCVmxlSHpQRDNjSW1GOFZ3WmIxakZENmpKVVlw?=
 =?utf-8?B?VXVFNXZoZHBwNHdWb01XRmFqM2RHTGxkcU16NEl0czlZZlNQYWFWZVZZMEhn?=
 =?utf-8?B?L1R4Mi9ZTXkySGNwdWU1WFlIejNZRUFYeHhHbEVXTHEyYUZiQy9CQ0k3ejgw?=
 =?utf-8?B?bUgrclFBUzNiTm9uYzY2VE8wb1Npa3hHT1lOYUZXSEE2ME9IU05rdTc2eWRy?=
 =?utf-8?B?N3l4VWRPc3hQd3ZDUFJyTi8rRFozTnFGQ1ZBWERFNjdMdEpsam1oKzRLS1B5?=
 =?utf-8?B?VVBiell2Y3NvTkRJRmZEWjZMVE5ROUFwSndnVWc0bjJoWkFKZWNtR2c0enRm?=
 =?utf-8?B?L0RES1dLQ3pKbUV4eXR3em5tMWQ4aTE1WWozM1ozam5FU1BCZ2FQMHlEaHZv?=
 =?utf-8?B?enYxU1ZCMTF0Ym90VzZDa2QwUzRLR2RPNUJieEhkQ1A3ampqY2xpSFovQmlZ?=
 =?utf-8?B?TEpmaERIWkVDNlMwK1VLQjZYS2laQjZWMkNLWFpEOUg2ZkhKWVo0M2lmcktl?=
 =?utf-8?B?a3ROdnBsbXNESUl3TkJVQzdPMVJkc2xNVXE2ckhtMTlKTW02cHNlOW9lbXNI?=
 =?utf-8?B?YzZGYkRxSTZvV2dhTlE3VXN1RGZuQjZueURmRkNUSG1rVDNYK3cwWHZMci9S?=
 =?utf-8?B?RnFwUHNZOHQ0R0FMdU1rc2xpVmVSNGRMUWZPdENQZFlQaGZmUEZha1hCa29Q?=
 =?utf-8?B?M2ZlVGJGdFc5OHBLcUFETkFNb3NZYW1FZ0tTRXFKc1ZoL0xsTkFpalAyU3NV?=
 =?utf-8?Q?LvFwprbuZnm9AmsdQr?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b44a795f-dc86-41b1-21bf-08df0b67d41b
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Sep 2026 16:07:47.9115
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cCLCO9y86iBPjk1/dKnJ37XqhObDjTDjxo/mirHkXnfbd6Lz7v7iNl07sS0DOwP7
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB9162
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: BBBD616000B
X-Stat-Signature: g8kqdk1y4bze3k9do7j19ddgzt1pjige
X-Rspam-User: 
X-HE-Tag: 1788624715-487303
X-HE-Meta: U2FsdGVkX19aI+oqSJyS7n0Ps6ikEcj9lEkv7CYfFkqK6T6o9GFGltsZcVj9zFwp3c+jnGxmBKzmm7sXpj5P+fHAC7gbTzQznGJJwxEw3cY8c3ZAtCC9kO7ungIRQgjbyH0K/Zw016q6bR1y1SNTDv6cLpR2ho7RBSjbue5UXkEZhwCbXCUoPLxMNdZWpF+nRsxb+bflUdBeZZFeqMHLuAqSkzCrghTocoJQNGfAguoX0TC6IaEFclxjM7r983YUValxxDCceRvJyf5xgL2rGbd1kLLIoodX3l5vdjDN2RqNYnA+mAqhf42aDXxFLKRmo5j1RYATll8nq0pLK9RojxI9eGT5HkyO6LCveU3wpCu6fpgd/TWWRQ/Hk+OBT7myjWL+ZMnje1L8vKwDm14+NPdHJTTOt2hKHS3tfAXp9Nzyh6A6mF5bn82H10PY+BjwAYRKyPxM55JpKv009WxkjqJoxjxLaYreTnobCqKmAHu7yw8bqhut6yNMM+Ne0PjFuio4T/+YdYd9dd4FrwC3TcxfRNBBF6X1oOyKJJKH8wFEyMKUnynLSe/6+cFfGIpSqUQjFWZj6e9+lIoQFG05BUSuvs5tb8Vux9TGyYTFBV7zfA5uVBCnMTlDG0zhc2kEn6Z4/WGOb8p5MId/R0fAcUkCkVwIY+9VHxWSPgLgCcdT3+KVYtdP3+XYqgucmq3s0yg4PVkgxdj3uAy+54qJ4jABCbKdXzZNlhug+lURKio9gJGl7K9IzQFq/kQFa3YHrbF2MY6rdewU4wVmqLpZIfMb/d/KwnD0hzawDOJl6XpcGB5NjUbs9vyVwKHeap1MbXpAeWtIU1AnQd4Xdr+WipK+P4VhIPn4hHzMTPbwLGZ4NfW+bpic8wfhwZC3ukWDfOULND9Pgm8F770NISFPb7qHuc9Za3mEJ2ZOrEb6y1Y+/afqGJ6g3sNFzn2g+arMc1EAj2iZrbZj6eRfTJH
 IbPHSiQw
 5wgcLZ4Wlhk/PFH95MNN7cebkONdd5RvkeVNjWXNxAKvLrLeAz+CQv++CKPiBwTZ9n6BKV0F+rdiSJWdqo9YsRl/QnxP/baqYMm9ABFtbS60noMsn8voHKo77WwiOwnyc20u7WcfkcxO+gIW7yeAKZTBbkN38kT8gO/nr+j4em9e9N7M0U+7Z/XmqTDwPhN5b/2VNeZr0rIBXUVRg++kqNWG6AwxMPGzUBU/SRaUYjMdMED+MvZpcQUyq1X3m2zxbFVEsugc9uTwurtii1hALfzwtBTlOIhYrsgABpT3BsoUb/AkUtmGjpAPiB0v3ItHeL/+Ha3GpeZ8Cni9/H4Nlp87nSUo94mbaLYJ7VF184vOL/eHytH8DHDWZ3p6wGqXV3ECNugEPhaKtI7Uw3vST2q/nL48Xy4nqBgiQZdrkcVtsoh9HufR56ERskk6uA/jh/wiu53+EfCbFZ+VnfoZBOmQFj9gMT2u0Q8D/CjyENG2ZZl95IqXmmNfRyJr8Ew2rqm+NoSIQ1wovdIyfNVh5Ln6/R8eTBM212AP5
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat Sep 5, 2026 at 10:01 AM EDT, Christos Skarlos wrote:
> Resolve coding style issues flagged by checkpatch.pl Specifically:
> - Add missing blank lines after variable declarations.
> - Remove unnecessary braces {} for a single statement block.
>
> No functional changes are introduced.
>
> Signed-off-by: Christos Skarlos <christosskarlos.kernel@gmail.com>
> ---
>  mm/huge_memory.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
>

You already sent this one out[1] and it is reviewed. I guess this is
sent out by accident.

[1] https://lore.kernel.org/all/20260903092200.88910-1-christosskarlos.kern=
el@gmail.com/


--=20
Best Regards,
Yan, Zi


