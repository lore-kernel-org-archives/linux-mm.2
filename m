Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 40F91C624DB
	for <linux-mm@archiver.kernel.org>; Sat,  5 Sep 2026 16:19:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 518C86B008A; Sat,  5 Sep 2026 12:19:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4F0486B0095; Sat,  5 Sep 2026 12:19:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3BB186B0096; Sat,  5 Sep 2026 12:19:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 0A8B06B008A
	for <linux-mm@kvack.org>; Sat,  5 Sep 2026 12:19:35 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 8D537160321
	for <linux-mm@kvack.org>; Sat,  5 Sep 2026 16:19:34 +0000 (UTC)
X-FDA: 85180219068.09.69F1EF6
Received: from CY3PR05CU001.outbound.protection.outlook.com (mail-westcentralusazon11013070.outbound.protection.outlook.com [40.93.201.70])
	by imf17.hostedemail.com (Postfix) with ESMTP id AA3A740006
	for <linux-mm@kvack.org>; Sat,  5 Sep 2026 16:19:31 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=bxdxa3Ib;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf17.hostedemail.com: domain of ziy@nvidia.com designates 40.93.201.70 as permitted sender) smtp.mailfrom=ziy@nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788625171;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5yroGCP36jd9iGdttX5PA53FVPQYvOacTTpC665/140=;
	b=Wzn0ixITUBL8uzWEhP/m4SqKtB+IpZLstPSUn2iODKIBBA+anQa9zo96Wu+P879viWWaE4
	Oskb/EwlVMYvZacxEZZDS1dPop+OJFjfMjSl+Yhe9rn0JE3r776DX05DyDNqh0huo/Plha
	tuOSsEUtvmJT5rkoADRsEVOOIUlaNsE=
ARC-Authentication-Results: i=2;
	imf17.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=bxdxa3Ib;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf17.hostedemail.com: domain of ziy@nvidia.com designates 40.93.201.70 as permitted sender) smtp.mailfrom=ziy@nvidia.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1788625171;
	b=CB3Dbw2RWp4zEsoSLBU/KqSW0JqatTtqHgntrP78EuhGE5UA9+14sMp1rDMU3zYW5108d1
	jR1WeVtFGITWGMoXTd39J96YaHy6zSVoI9KCYczIaCLfu4T6jmPWQYikpZv/Dcf8dpoOqw
	n7gOy0a9nfiUzxSlm98vphpEV2GjyAs=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=MwK9U1V9Mx5pfYNQnOlIP3uCMd/vOxvgBxb84HlnV1mnwQXBz1yK/31zprzeiMkNziLUJzGjXqun8TCukjBA4nnaOuV9eyc/1GgMc4lPrkHTm7w6SRgJRI+px9fGpFUfhPtWGZl5ha38N89oB7r6acuMp7Snc8ok6JA7MkqgX2GT5Zq8TEEYXS6qBfInEZJNvlNzrXuNEtqIagIAb1WvnuxmJ4QiExT78qvgSdHyPvQV+tsiG5f9MUbRm6BtM2uAq7MOS3fe4Yc3xPrh6oE8JO4P2rJLhZ9vqWObHHBOe1Ie/C0YWMuJWgcbZM9VNJ5l8ooSc849fvq5iCARvZOvTQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5yroGCP36jd9iGdttX5PA53FVPQYvOacTTpC665/140=;
 b=oeKdTxmGDKjPBIyDZ05EbdjUTJ25tItEkA8gEvAhTLHLSd0KbY4unRsbmvNy2iDMClU+HuMM9EkdD9ooac/2zztqnKyJgKEByxMkd7Woc6Un3rZ6+fCuGYZPHARz97jzlBPjjUVq3rzo8OUFeTqImLPawLcq6WCSWtDMBT5LOD8RgrZbvXZD3opX1JQc9yYlsfISiKbMTCI47HG/C90qKuiCfa+JFcQlVAzZ9hHhAOb8udDD/fYWSpql0XTSYv+SZ7/+aLPxPEd5uQlUS4fNPpqjSSY7haVeOOapojAEiJ4KrGsVHkwhIQ36MRyWMBlhIg9Z7mddgEwob5Fwr4yiRg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5yroGCP36jd9iGdttX5PA53FVPQYvOacTTpC665/140=;
 b=bxdxa3Ib4pBidDNZVZp7ZNBO5Z4Q/HuVjohX7KjBS9fEE27Pf71ul3beQkvA2XETeBDZ9sPJ9nsjp7qs8a8fYOXujq/x0AtuxUkfVX4b1TM4yVHzhr1AHFgop64ahFOaMzDO4jKysVsaSXqMcb2u4O9+hn1sKwlq68NGqpHAndFSpYlEfJ8EEojGnB9MvSJ5RwajZFg0GzSyeG8vZo6RqY6HqmbXzFxnBl3WRiWYHfotFN4fxXD4JX7dF5kaB2NbdEcrAk2ZW9E8iFP4xnNGnRwuRELGwUOLU737Q71fm0J2jQh4YLsQgCOTUMbOzJa/6WETKHWIYOLvM0S3K3LRRQ==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by BN7PPF0FD1DEA27.namprd12.prod.outlook.com (2603:10b6:40f:fc02::6c8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.382.13; Sat, 5 Sep
 2026 16:19:27 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%5]) with mapi id 15.21.0382.012; Sat, 5 Sep 2026
 16:19:27 +0000
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Sat, 05 Sep 2026 12:19:24 -0400
Message-Id: <DL7IPCXK95Q3.G8TUACB5UNZQ@nvidia.com>
Subject: Re: [PATCH 1/3] mm/mmap: fix various coding style warnings
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
 <20260905140140.60792-3-christosskarlos.kernel@gmail.com>
In-Reply-To: <20260905140140.60792-3-christosskarlos.kernel@gmail.com>
X-ClientProxiedBy: DS1PR02CA0002.namprd02.prod.outlook.com
 (2603:10b6:8:452::16) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|BN7PPF0FD1DEA27:EE_
X-MS-Office365-Filtering-Correlation-Id: 3c5ee84d-276a-4be9-4c0c-08df0b697507
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|23010399003|376014|7416014|1800799024|10067099003|6133799003|22082099003|18002099003|11063799006|56012099006|4143699003;
X-Microsoft-Antispam-Message-Info:
	KIdRWDhvuliwzd5tqCgd+rSbLPoH9ni+cQVK77q3yqj3zD4y4Gr05a9oQAzf1oUGrhiy3uhPSCc7VCCbkJh2JDNdh4ImINtRgBBCnVizLTVq8YOf8GEUxMVgHdtgSEbei7q5bP+LOzQF6Vl8uQG31KopRiqBMk+ZtWvPTXDX5q+FTfNsHRnrjZqA4Mkpy5fpfocCzE+9q49ztOjhoGh9XJ8+6M5VuvQmebx6GLQbZqQ8bs6dqqqP32T7ymE9+wTNi+AZakRiVJjAfdzr+lbQP2yfXy+n9Z6ZpP5/cyNv2LQ5Ob+cAeJ7EIhCLlGyXeALgvOC0SxO94/B29WBxl33ZOng5z8WIIbFfDNpPgZn1ICoL85GaY8lvEzJrI0myfDuYk6WhjVzYZea43dmojiM4oqRc30E+tJJsaN1ZAzVrcECoROuVYfSJ43h/uSog2QXV4zFEdLMOhJraKdJRPgAWZgkOMUVJIM/zSm6I/3gS+Zk+5MV587gjoNi0a/jlpdJqYAm8dtNaKTb1X8r9X9/2+ymdBIfZ1IQCwuNLuAjDYVvdStMavw/j3PrUwUh2JLu/b4qmKH3As5BoqASLXkBeEXNSwpjYeR4Z5NwymeCrLd3TiabV3lKBuqCavwVaC6Dp17GjxnBb5VrhTQnwV8bTpGZ60s3OKT/CR9Y///NPx4=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(23010399003)(376014)(7416014)(1800799024)(10067099003)(6133799003)(22082099003)(18002099003)(11063799006)(56012099006)(4143699003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?S3lyaHZEVG1IYURRNExtZStLem81dVZtWmJRUlFKNm9pY1p2TFloR1dkOUhZ?=
 =?utf-8?B?UGdBSTJzZjFxWnBFY2RQZDg2QS9ENllUcjIvTnRsTkk1VzhvdGJqem5XTUVq?=
 =?utf-8?B?NWxMZE1JZ1NmM0ROUEtHTHdNTzl2ek1YNExJQytjTmppVzdNYTZObDNsT1h5?=
 =?utf-8?B?Rkl5WUxlWk1QK1NOemhZK21zbzMyM1JHKzJtaFQ4RjdvTlluYXFRckZueEtT?=
 =?utf-8?B?cEdRODJmUFNReDZtTDdlUXM4c2RaR0RpZFYyODRIVHJjeENlaEVkeEkySG93?=
 =?utf-8?B?WmVKeTF2ODFWYUNTR0I5TEd0SVdhOWtyZnlnd2dUV2dQZEhhTE1Ecm16NUlh?=
 =?utf-8?B?V2MzVUNlanY2bitGNmdlckEvMG81SitDRVpVcEF3d1lOcEE3aGdxSWg1ZEpF?=
 =?utf-8?B?VDhzZDZKcmNHNmJiN0ZtVGxyNUE3RTZ0N3Y3RThIcFBYVzlzY2t1THpVSW1p?=
 =?utf-8?B?SnlQY1daVUVSNzNNdSs3OTFwd1ljTk0wS3Y0bXNHbDRlcEdybWNheW16QU9B?=
 =?utf-8?B?Y3Uxb1BLTXlIUnBnaVlEVkdsbER1aFhZL1ZnTUVodHFHMWdseGpVTFYvR0ZV?=
 =?utf-8?B?elNTNFpib2dzQkI5NlZFdGVVTUg3SDUrNno0Tk1qUElCOGtWa0tZRXdkSllE?=
 =?utf-8?B?U1F0bUYrTzdvYUdyd3pXdnlBU1p2aHljaGdzaXNOcTdLYVljZmJiR3Azc3RE?=
 =?utf-8?B?cFl2d0Z2RVp2S1g0eFBJcGM0ck55QlFYWkdmcXQ1Uk9YUThSa01MVm1jN3FG?=
 =?utf-8?B?YTBFcytENFV1NUM4Q0orTEtiYWZ3UjJLYTlDakJkNjJXYllva2xxR1pjQVps?=
 =?utf-8?B?MWJLQU5PMDFJN1I1ZDZDclhORTZvTXhMWHljakQwSmUxZVlrV1plUUZTM21T?=
 =?utf-8?B?eko5d2hyRTRadFF3dnAzeXVxbS9JRjB0QjlwamdIWHlUZERkbnhadDNhUFk1?=
 =?utf-8?B?d0RLb2dVQWtIOWlTVEhRQmpjQWpscUpSeUR0eklKZWVEWmh1dUVqYkNLbFlD?=
 =?utf-8?B?WExsT1RFZlM4SHBxVFBFbXQ0dFZuMFRqWU9ERWUvNnp4OHBMSDJXRThtM3RK?=
 =?utf-8?B?U1EvUUgxVlgzTGtGVTVvRUFqMko3RjJlN0Fya0wxQWU0TWFVRnE5cS9PS2Zu?=
 =?utf-8?B?ejd5Nm1KWmNjZzRwMWpCOG53ME8wU2QvdXhxR2cyVUszcERTV1piUEdNanJU?=
 =?utf-8?B?Q0hON0hLZ2Z2Mng5dmYvYURsRGRldDdGMkNRZFc0V2hZc3EzbXMram1WUVhj?=
 =?utf-8?B?dE1hTEFmaFE0dFR3bnMwMjZ1WFpvd0JnKzBTVVd2R0xHeGd5b3A5dFlXSzM1?=
 =?utf-8?B?SmN3WERlS3lzZE1HUnpVSzJEcHVwSG14VW1rU0ZxN1BpTjQ4Y3hQUUpCbS9Z?=
 =?utf-8?B?S3hCNWJESEV1UlUrM3RJV3IyMEl6dXl2Y0d5WWYwVHlPUkZnZkVjQU5oQlNi?=
 =?utf-8?B?d0FlaUN5YzlhaUZpZStxenZPeFdnSlpRQmtEUGZIWkhvMkZ6K0FrTFQrNmpK?=
 =?utf-8?B?MG5LcUFNWFNpR3pjS1Axcko0djlxcnBSZExKNVhOYzIyQzc5WURkSlI5Wi9k?=
 =?utf-8?B?WkxGYWtKVjJSVmpnK2drR0F4Vy9TS3hkcW1CWk50TERtaThmRGRZWFNLMEEz?=
 =?utf-8?B?bThpWlc0d0xCSkgwTzVzMUFMV2lHN21GbFRPTDVhSkxXeGNzSHgzd3V2c2py?=
 =?utf-8?B?OUNXR1dlNEhpQy9uS3ZtdlNqTjhDNjJwRXJ2aDJNQlh2Q1lyUEpFVmlzMDdJ?=
 =?utf-8?B?OHFMNU5ka2QzQVkyZXk4QjZMa0pXMEp3ZDhWbXBvckxwZnNoWHJOeGZwQkd4?=
 =?utf-8?B?MUUrY0lDaHBWdktGdHE5Q3NFV1J0M1V0aG4wSW94VlFlWitYRnkrZzc0Tzc5?=
 =?utf-8?B?SDdxZGJTbmRlREQrNTMrNjhYN0h5Nnp0TWdWNE1URWxOM1YxQVJoNVo0TGIy?=
 =?utf-8?B?ZFpIQlkrcWdaOVVPeGUrVXBPYXlxT1NKRUZYbHliclVYRmUyclpVenFUZ3BQ?=
 =?utf-8?B?RXVjdHA0WG82Z0NnSTJ4dEdEVnVhdjY1aE16eWwvR0JWNU9vTVZRM09PbHJM?=
 =?utf-8?B?MU1hZ2t4dzhnK0NkY1dsUktWajJhRm9aMkZpemdJWm5COXJFMkozejgxdnB5?=
 =?utf-8?B?T3N4Yzg2bzVKR2tVMVFmTmRsSjFaOTl3YTZ3TktBOGZjNmxYWWN3RmJOQjB0?=
 =?utf-8?B?YXZJeGUyN2lTMXVHNVFMVlhua29DQ28zdjk5UFRFUkxnUlRjNVJyQ2thRktV?=
 =?utf-8?B?b2tBN2h3N2k2MURocXNkb0QySjhuUHY4L2NDSlRNNllMMFp6Z0xQMFRyanR0?=
 =?utf-8?Q?msDqTzMftH5cdwFkKx?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3c5ee84d-276a-4be9-4c0c-08df0b697507
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Sep 2026 16:19:27.4041
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ID+//UCfPufs0Q10X2tWkIl3XcRmfRrbppN4UnIH6hvwXGpwJN4RVaI+RKGchDjH
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN7PPF0FD1DEA27
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: AA3A740006
X-Stat-Signature: zqcohyhfkger4g8kith97zyey18ymtof
X-Rspam-User: 
X-HE-Tag: 1788625171-713454
X-HE-Meta: U2FsdGVkX19n1xF69nvKL01ky3KcRR42ZXaISd4VtCEhdwprim8acMQ3JkvGqsq44GcAKP01R2pz6WsaDE9UKIym1Kz0S6LX9ryE78QnBf3mSbIkUFr/crAhARS/UuLmK1pQPP9riitIgfNmbvaj3vjpZnW55Pnr9e5KFNVqtN9bEAf9k2UvMvT0+d1Vt9G7MaadGxKCJpjJjZOF7xFax7UOs1W2UZvhxtGuM5IU8Me2x1+0gbquioIbTn5vSc1DMLt8fSidtbcj5PIP9iF+yUwgFrKIyBW24IlMURzpHPzdA+kAptpJu75DXlXZFVRtet4VbHJICNHwOVEuPpjgBMlak1qKoz08I6f9bV2KYnHjnbiWSvCbjZzQj/f6dFrA+8NJ5U4RmdA+SaPgIwrO/Y4d7klztdOlkZ/DljX14GnpxE/yXXsYo5c/b0YtfxI1LoeN+kzqBLZB2k1HI0is1aJUoEmt/795HgSwR8QH9KSIW60X4WNy+ZgSOmUe5Y/zJaOcCLhcHAw5auZ+/5lSodWEGam1LnIoPYH/4B5asbIAqB/gjKK5MOkB6sy/zMUK93KbXk6dbYHSD/NOGG8jcl3Kw0jfdpjpVYCSRANSzC7kBOsxL4CNQb9/4TcmbOXfVq9R+115FqjB35Maa9ojpYO6krBeAQ8L91CN4oNgCM0fmkgdqmpij8fJ2s7vnaFIEN8qzhny4yQY7yYbiP3xxe1znACPsz/+k32RlHjXov9dd8lTS8bHWs01xdeWQBmP6lRD2tq9l3LpcqIcqb8a3r8xJrj5qvGNKhswRpP3W+Rh/Gy5AiCRyho+WMVpwTtn812bg97oGWPXH4CDiDB6+UVSbXux2EEoQmPMD3JhwRA78xaaBti04ASalW/WiIcYR3S+JH9Xe6MZPOa8375p7NBDlR0TCfpWtSLGyXfonNKkB2zg7WZ2cC3ui5Qoj2jCmLofPaBAKeuBn5tOXRK
 iioHPhqe
 NBuWo5kv3vssEQOxt/Tk7/Eu+ZJ3QI795pT1THTtQdc0Q0MbV3Rz/DSWRBtKJT0SVtTZvUOO/CWdPFSR3C6f+pah+Q4mZzmB8l1ldMCc5Qczomw1ev7wGKTZx83I5AEZbFhbvE/NGTSEYcDoZBaD9xfE+aI4V/eY1wQdIYYXUMTbphURsuo4Y5qo98R31u7DNMJNpa9HQE3HKOUuSws9yZ6j4TFFEsH2/s9NVfYyLPFH9Ap/fw5w7HoQI41BZgIW6y35s/nUjocCypcS8TJL7lGCzpxVNdufYkKzY1sIoircb6+x0QLPrEliSQS1+0SwYF+7JhIKJtLMIDrU5ZiH/kLps2Cl25s87j7JM95MTBPerKMR9eb3xnxRE59o+Ut+0AsRHNDXvEMDrApF8zZX61Hvh0VnYfKNo37OzuobeWv4ZWj9gFvJTv0yvopGxwafIk8cIZ5dlEDNtOoG0zYEuiRM1+5ezbGxR2Vrz7lTdyfA5RQD+90EU5xekA/EHp59TalwM
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat Sep 5, 2026 at 10:01 AM EDT, Christos Skarlos wrote:
> Resolve coding style warnings and errors flagged by checkpatch.pl script.=
 Specifically:
> - Remove the obsolete filename reference in the top comment.
> - Replace <asm/cacheflush.h> and <asm/mmu_context.h> with <linux/...>.
> - Add missing blank lines after variable declarations and replace spaces =
with tabs where needed.
>
> No functional changes are introduced.
>
> Signed-off-by: Christos Skarlos <christosskarlos.kernel@gmail.com>
> ---
>  mm/mmap.c | 19 ++++++++++++-------
>  1 file changed, 12 insertions(+), 7 deletions(-)
>
> diff --git a/mm/mmap.c b/mm/mmap.c
> index 4bf26b0f1e6e..626d3d2493ae 100644
> --- a/mm/mmap.c
> +++ b/mm/mmap.c
> @@ -1,6 +1,5 @@
>  // SPDX-License-Identifier: GPL-2.0-only
>  /*
> - * mm/mmap.c

Why?

>   *
>   * Written by obz.
>   *
> @@ -50,9 +49,9 @@
>  #include <linux/memfd.h>
> =20
>  #include <linux/uaccess.h>
> -#include <asm/cacheflush.h>
> +#include <linux/cacheflush.h>
>  #include <asm/tlb.h>
> -#include <asm/mmu_context.h>
> +#include <linux/mmu_context.h>

mmap.c does not use any functions in linux versions, why replace asm
versions with them? checkpatch.pl has no check for these.

<snip>

> @@ -942,6 +942,7 @@ find_vma_prev(struct mm_struct *mm, unsigned long add=
r,
>  			struct vm_area_struct **pprev)
>  {
>  	struct vm_area_struct *vma;
> +
>  	VMA_ITERATOR(vmi, mm, addr);

Have you checked the definition of VMA_ITERATOR? It declares struct
vma_iterator.

> =20
>  	vma =3D vma_iter_load(&vmi);
> @@ -1017,12 +1018,12 @@ struct vm_area_struct *find_extend_vma_locked(str=
uct mm_struct *mm, unsigned lon
> =20
>  #if defined(CONFIG_STACK_GROWSUP)
> =20
> -#define vma_expand_up(vma,addr) expand_upwards(vma, addr)
> +#define vma_expand_up(vma, addr) expand_upwards(vma, addr)
>  #define vma_expand_down(vma, addr) (-EFAULT)
> =20
>  #else
> =20
> -#define vma_expand_up(vma,addr) (-EFAULT)
> +#define vma_expand_up(vma, addr) (-EFAULT)
>  #define vma_expand_down(vma, addr) expand_downwards(vma, addr)
> =20
>  #endif
> @@ -1227,6 +1228,7 @@ int vm_brk_flags(unsigned long addr, unsigned long =
request, bool is_exec)
>  	int ret;
>  	bool populate;
>  	LIST_HEAD(uf);
> +
>  	VMA_ITERATOR(vmi, mm, addr);

Ditto.
> =20
>  	len =3D PAGE_ALIGN(request);
> @@ -1290,6 +1292,7 @@ void exit_mmap(struct mm_struct *mm)
>  	struct mmu_gather tlb;
>  	struct vm_area_struct *vma;
>  	unsigned long nr_accounted =3D 0;
> +
>  	VMA_ITERATOR(vmi, mm, 0);
>  	struct unmap_desc unmap;

Ditto.
> =20
> @@ -1454,6 +1457,7 @@ static vm_fault_t special_mapping_fault(struct vm_f=
ault *vmf)
> =20
>  	if (*pages) {
>  		struct page *page =3D *pages;
> +
>  		get_page(page);
>  		vmf->page =3D page;
>  		return 0;
> @@ -1711,6 +1715,7 @@ __latent_entropy int dup_mmap(struct mm_struct *mm,=
 struct mm_struct *oldmm)
>  	int retval;
>  	unsigned long charge =3D 0;
>  	LIST_HEAD(uf);
> +
>  	VMA_ITERATOR(vmi, mm, 0);

Ditto.
> =20
>  	if (mmap_write_lock_killable(oldmm))


--=20
Best Regards,
Yan, Zi


