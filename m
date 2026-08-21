Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 10D6AC5DF94
	for <linux-mm@archiver.kernel.org>; Fri, 21 Aug 2026 21:44:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ED95A6B0095; Fri, 21 Aug 2026 17:44:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E89EA6B009B; Fri, 21 Aug 2026 17:44:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D513C6B009D; Fri, 21 Aug 2026 17:44:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id A66A16B0095
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 17:44:35 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 18CACA024A
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 21:44:35 +0000 (UTC)
X-FDA: 85126606110.12.9F3708D
Received: from PH0PR06CU001.outbound.protection.outlook.com (mail-westus3azon11011018.outbound.protection.outlook.com [40.107.208.18])
	by imf29.hostedemail.com (Postfix) with ESMTP id 2B5D7120004
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 21:44:32 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=Vg+1jUsw;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf29.hostedemail.com: domain of jhubbard@nvidia.com designates 40.107.208.18 as permitted sender) smtp.mailfrom=jhubbard@nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787348672;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=N2CRHuM+VgolawidMnn/dMIziwy4qRtU5K4cxn5bTVo=;
	b=MbVV2xhqDTjJZDe9u6etsZXCqjI+r8ANPQ/fOs3W7OKx8FFWvLuDQCQCPI6/40Oc8vYIRj
	W2cxIEpKplB19GXGTtpWFZYtRgkbbrqwNz3sJ+xb6fwq2tvR2VWqq4cVhoQyivrFsUqiqN
	RIf0+nLVOwubn15Lk137mSSPfJLgc8Q=
ARC-Authentication-Results: i=2;
	imf29.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=Vg+1jUsw;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf29.hostedemail.com: domain of jhubbard@nvidia.com designates 40.107.208.18 as permitted sender) smtp.mailfrom=jhubbard@nvidia.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1787348672;
	b=dIIyNHrkQgEDWjRSNTn+CVlfTcqom64QCmudjMeN69OHCgpNv+fFOCs/l1A+61cuJnWDsr
	WT1203ZndKMpXcuyrhVwNTMN3lzOm+j4XBrkH0SoTTLBPXxMBkakyLaqEMRboP4pbCto2u
	nSTlvbSL4+z8UHRlQsVtXVaQAJ/CsdU=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ZRxjFaK9QWqqO5XO1C2TXeTR6BSIb2KNejC7PvLUCWKBb/eWHD6M5aCFhAMlu6cplTc409sdRkz8b6r7o5W+wFkTQrFmkD4uPveJA/Ty/sMaH36j2O1Ps5gGOkNgL3z4MVZGL54vQAUASLvJvL/dDCodv9q5Lo2nV9PwqvI5QFZ/cT//6WYHFKuIegywafElUR/O99Ho3mKOKoM/woQY7biXJzibhUaKhPwPsDLY4WOafs6Cmo7jjKjiW0eYI1Z01J8m66o2WmExKRQYhNfut7UiV3wsmsqPYM7AC8BIz4UpOMkKXnoG2ze++7b52ecxdtEqKC5wMX71Iyiln/xJJw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=N2CRHuM+VgolawidMnn/dMIziwy4qRtU5K4cxn5bTVo=;
 b=Ov1zdG2/8GhKLtO8Kf6iBf1RrYXUbrhKkWbJI57nC2KvzPzs/SbzRdMj9E4q8gQRqDGXln4YE6g9KF8c081k3u/w97NWCRVdoWcjdyxDorGv52xGiKmHg17jKqrqSl9FejJaANB7kqgG0E8wDUekYVAsStCCEi6H9/KWaLAG0skjkUxRjn8AEWZ5MX6I/qkxolEcIATeO88vrPd9/6GyldthHmBqcaexW/P03WiKt22pK9Eh4YqqqdLYizMVYp7sH5hUz8tguU2RzOa/DZSpa2MunYE+OECINHhayXKIryGDEDe02n06DUrkrtoBuFNu8+JpFlhUED/RCD3kSOKDHQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=N2CRHuM+VgolawidMnn/dMIziwy4qRtU5K4cxn5bTVo=;
 b=Vg+1jUsw0YJUO+ipqZIBguv+ZnmX5MKInqCIEV2XJKgUwJHX/Y3gekvt6S46FQ8YoZnKSOnBtAvzeeDnDS9OA0L6QHOxsr4lrJ1arF6qLsrhmsdW1pLa3iDR4flkeOpk12tigayNuNdXZdHQ8Xwo5Dc+FXMi0EveoHLRcqeuu5c0+QT0Q/Or/jotJT9jIMrj3WOJ/+kOCYYM21wzgzhD27zef4A10dfFUIMqV+VvzC+zJAEupoNfDSALKIRJrpZPfszFaoMnjbJ8aciWoD7hnC1tPgsw93i1Wsn6RqwRb3szCNq3GER4k6GuqMWaAiifT/3mDyXtPjYoLax5tF2g0g==
Received: from DM3PR12MB9416.namprd12.prod.outlook.com (2603:10b6:0:4b::8) by
 MN2PR12MB4125.namprd12.prod.outlook.com (2603:10b6:208:1d9::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.339.8; Fri, 21 Aug 2026 21:44:27 +0000
Received: from DM3PR12MB9416.namprd12.prod.outlook.com
 ([fe80::8cdd:504c:7d2a:59c8]) by DM3PR12MB9416.namprd12.prod.outlook.com
 ([fe80::8cdd:504c:7d2a:59c8%4]) with mapi id 15.21.0339.010; Fri, 21 Aug 2026
 21:44:26 +0000
Message-ID: <67fc54f3-8889-4e18-b72c-e14266bd4703@nvidia.com>
Date: Fri, 21 Aug 2026 14:44:14 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 0/4] mm/vmscan: honour node reclaim limits per type
To: Roman Gushchin <roman.gushchin@linux.dev>,
 "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>, Ridong Chen <ridong.chen@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>,
 Johannes Weiner <hannes@cmpxchg.org>, David Hildenbrand <david@kernel.org>,
 Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>,
 Kairui Song <kasong@tencent.com>, Barry Song <baohua@kernel.org>,
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>,
 Wei Xu <weixugc@google.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Ridong Chen <chenridong@xiaomi.com>
References: <20260821081741.1340277-1-ridong.chen@linux.dev>
 <aogMyu5R_DZRqp2J@tiehlicka> <aogQ6iDA7RkuTtDG@gremlin>
 <7ia4tsonw41j.fsf@castle.c.googlers.com>
Content-Language: en-US
From: John Hubbard <jhubbard@nvidia.com>
In-Reply-To: <7ia4tsonw41j.fsf@castle.c.googlers.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR03CA0357.namprd03.prod.outlook.com
 (2603:10b6:a03:39c::32) To DM3PR12MB9416.namprd12.prod.outlook.com
 (2603:10b6:0:4b::8)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM3PR12MB9416:EE_|MN2PR12MB4125:EE_
X-MS-Office365-Filtering-Correlation-Id: c9791c72-cd1f-45d3-ff07-08deffcd5f31
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|366016|1800799024|7416014|376014|18002099003|22082099003|56012099006|10067099003|4143699003|11063799006;
X-Microsoft-Antispam-Message-Info:
	vXNrYwGL0IjlkY3DGc4ri8jwmqNGHFtPC7/8IwJQlLugDq0PYNtAtQSlSvpiiz4zywo+pGE+c2XoUmB4rzm55KILVD3+Rp064xcX1/f0BnoSjEPKScBhHa9JXJNhrmP418izUw5FNNIBR+drn4a1kU7/KEP3FLdHZl/b5e4w9fynbBj0i9+Dfb9aCrhD2uK9/1IJpp5qoj+hwhOYETJY60ricP7lRBvwqtYZjG4+lM39yubRSv7lQQOhL6bmgTqi1ERUoPCWoAGu1P9hAdVIiZiXJ3ikA9BRH6ZhbKHez7dIAwxDDC9QfMgkpLqwuiEVtIduhKQ80mze8Id2EoPQRO+J6k/L1U1QsXfk1zgncO5AtsFMl53Lx9A++bZ66PmApXG198+IFCPkO/QbG40tz45jRsVhJFmN0TQin41HTmNS4Bud3mNdI8KgacrsbWlX/1K5DGAD++d4/WHf9li1cGoO/MfPm8qvsdDnfScK9Kl2lNT8kx5uTZ9/VIKMsXDcLn0oEmlBnixGWkqJUm6gDom7ro5Uy5xTBpmaBIY7OzlyIm9bUHGrbQXCOCD1jxCdw3ejOa9i2H2Q978nWx1oXPcLi4MvGSoSzmF5CMywpGDaCS3xQUqFXnfSS6QdxjxdN0N2nFqxuA00nKYolJ5vK/djqDtIu1sZ2cHu/RaPNOU=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM3PR12MB9416.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(366016)(1800799024)(7416014)(376014)(18002099003)(22082099003)(56012099006)(10067099003)(4143699003)(11063799006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?bWJ3U29SSzIzSmk3VllvV3RaK3dVeGJmWnpuN051K1NXeE1BQjdaVEduNkda?=
 =?utf-8?B?S3NoSDNPZGRyOTRtWlNwRHJNa3pETVZFR3I0bTZZOFBGVkJ4TG05Ni82MGtp?=
 =?utf-8?B?a3VjdmZ3U0VWLy9rWXFqSkVzeEZXb3R3dithRGprZU51OWdOQkRQeUc2ai9O?=
 =?utf-8?B?MWZnZXNnd0hOQ0lvWjluWTQwZHBXc2ZqQlR0QmhyMzZJd2g0MWc2SlVDeml5?=
 =?utf-8?B?ZnhkM1BEVGxsRVROYU80dFpGKzRuSzF4UlczaWRkcFBYWWY5akoyQytzbEJV?=
 =?utf-8?B?aGRZYy90bFF1bEQrQmc1aFhBSzVMaHVjN0RiMndOekFRQzFhVGJEY045aHFh?=
 =?utf-8?B?MzU3VkpveGhiMTBKb0V6b0NrR3UwZEN2VDZXaUdOSmxVRVUya2xhd2dTUm1N?=
 =?utf-8?B?N1E3M0tMNmM0MmVTQ0VKQVREbnNOcGkvSzhmSzJLRlA1MnVxOGdEbmhkLzN3?=
 =?utf-8?B?NHB5cGtacU5taXZTUC90ZTJCVTFYZTZwTERBbnJpY1N5SFh4M1pPaHpEMnVI?=
 =?utf-8?B?U3dGUk44Q3Z5QjlTME50aWZSU0N1NUY2YzJWaGttV01zRk1XOG12VzN5VWxV?=
 =?utf-8?B?bVZkUCtOMGpHZGRPSE44amF5S3czZDdRT3BNdnR3TStlSUUrMjNPS3p3TmlU?=
 =?utf-8?B?cHlidVQ2dlM0MVIwZHRvRi9uZUVIaVAwYi9ZOHpDT2plSTVRcm9vbGFCbzlS?=
 =?utf-8?B?K3RlandkS3FqcjdWYWhEY2kvbzJPUjVTVkVNOXRFQzMyVTRoZ09SNmhsdlhl?=
 =?utf-8?B?dWNKQjlZYlpIS203Tk11aTJCS3Y2MDBYTFRQM0lvbVpDUHhUOHhlUmloVm95?=
 =?utf-8?B?UDZKUlFCQ1FLaUg4SldLZmVwVUJMbk9uNlJzQmpOMTJmTFEybVR0S2dUN0dv?=
 =?utf-8?B?VGVLR09PNnREb1h1c1Q0eGZKb2NrbjNnNzZ5cm9Oek5lcmc3bjVuY2NobkFs?=
 =?utf-8?B?K3c0aWw5OXpqRytGZWVORlBRTzRsZVJCNE1xVmxOM0JuQUhqNWgwT2JPM0VI?=
 =?utf-8?B?L3NkNjRGNGIyUTF1SHhsazBSUWM1Qi9wSGhoTTg4c0pyYjNFKysvc0ZXRnFV?=
 =?utf-8?B?MTZSTy9aZE9TbGtQSlJ2SG5SRko5djQvYlZrbnZPRnBpdjJrNmtTMU5FZk9K?=
 =?utf-8?B?NWtiTDdFKzZxdE1NNkxLR0tVTzNsN1RxaVcrQytFalpaVXYwZ3A4ODdWdkQy?=
 =?utf-8?B?ME02ZHA3MHhHV3ArUnRTeDZWNWFJL0d1RjNTbXJtMDlGTkN1RmRoTWdIakcv?=
 =?utf-8?B?dkZCeTJZZDNhR2JPVVZvN3NlT2Z1dDczbDNRRGRLUTdJbVZVekc5dkp0U2dq?=
 =?utf-8?B?MGNkREIrRVZHVTA0RmxEVHY3N3JlOU1iWTMyc1NxRHNEMytsVE52OGFvY040?=
 =?utf-8?B?SkRUQ1pTK1FyeHpzMEV1YjF6ZUJzUFV4TEVRR0xmWkpRUkNpSUo3eFZnZ1dh?=
 =?utf-8?B?cGFwNXNZWFk1Tzd5dGF6QzNva2VTakUvMnZBWThpZVNHQ1hMeGRSU3ZETVRJ?=
 =?utf-8?B?N1hCMC94YjhHUmFYU0d1bGZXTi9KUVM2L21YUHRJcFJJdjNzSjF0eHJlMVhm?=
 =?utf-8?B?SDhkaXorTTBwVFBKczBhQTJBQkVZZ01sWlNYQ0hHeDJ5MTdkODFlbThOand2?=
 =?utf-8?B?bVNiVEVBRW8zQVArMnpyR2lhVVdLV3FKbEh0TjNITmdlcnFzVEN5N2hnbWRB?=
 =?utf-8?B?ME9LSGRVUTV3bnc5QkFHZU5YdS9Wb1ZzNUhmRFZXQ1lwcVpCdWtqUmxlMnVW?=
 =?utf-8?B?UTJJdnM3aDl5VHVsTnp4NFkvMnNCYXc0VFVPK2wvbDZkQkovNXFNVzJ0NDhl?=
 =?utf-8?B?NWlxL1gxb1lmSlk1S2lXcFVKMHBMSE9DRzdDREJLMXQ3aUhVSkF2aGpzcVZi?=
 =?utf-8?B?N3c4bUR3NDlWMmFXWjIzQ2IvWWtPcFFkSVpPaGw4RTFSUTRYQnlXV0JRcGk5?=
 =?utf-8?B?R2ZPeHRaVGtsb0NqT2FjakR3UlRSZ2lRSTVLMkpoVkVhSnVneXRVMGY5YTU1?=
 =?utf-8?B?aFFNOFUzK3pqenZsajI5cTBFVWEzcUplTUFodEgxY2kxcERqM2trUW9odGxP?=
 =?utf-8?B?WFl1b1ZoU0VWRGxHNHp6RmtmV2YvMStGV0pYcTRIRGZLVW9RME5RQjlHZFdn?=
 =?utf-8?B?akNnU0lVUTJKaTA5RmlpVDY2cENpYW9wUnAyTVdxclROT2hHTzNQZk51QzNj?=
 =?utf-8?B?T05LbERDakZlMEphMzd1cGg3a2xjNDI2TFhiOTBmRVFET1ZJRk9adHJOa0ts?=
 =?utf-8?B?a0hNUHk5WDhSaEI3RUpwVjZsUkw5dGd6QXl2TXkrVlRqd1c0RFc5cW9ONU1X?=
 =?utf-8?B?Q2IrNkY1NW03Qm1xV3U2NlhkbGF6R05mWnUyUEg3Y3hWWDBXalFGQT09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c9791c72-cd1f-45d3-ff07-08deffcd5f31
X-MS-Exchange-CrossTenant-AuthSource: DM3PR12MB9416.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Aug 2026 21:44:26.7874
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YALzAh1S+Me8frXC/fk9dih7a1iTqdK34r+4eV+l8OcykmnkI8VKpZOOgx38ae+/ySoPtSaDGkQnOP357vl9TA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4125
X-Rspamd-Queue-Id: 2B5D7120004
X-Stat-Signature: gnz16rjmgipxi3a7ybts6ccuf5qcyjuj
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1787348672-351276
X-HE-Meta: U2FsdGVkX19hG/Meei7qwZ3ZqQJoown7YQLbI/F0dYlPqvkwyLrX05SC/Qn2C1nFsemwrRRNetLS18UGJOqsat/bldh/mXiMgoftB84xyjZ0Lm3o9J+qGvmt6B8raBWNRlwTfqJnufLsDP2KsYfSPAS57UCrYEtjWqLx+/wj4SSnNF/dl8pnOkQ6gU4ot1PbqZ/HXOdgVhDHAKQ0OS3lNcPid7woAmvAaZNd+o1ezRksWIaaxf/WF0yIJky4wi4vor8knJSh4UdtrkRVdF2GZfBRY3uuK5Exrj6+EA+o4tkY+m7vKgpCVeU5Y+Nd5rGloL/6v/bMB+dUQbTE3sdp2CIlgsUR+xEccDiF1wCaAKuFR3gY5Xz5lxnUb9XFs/rgCAtoDoW1u4dACg5cPH//A1//oAVRKGNFLwmQwIZp2xXKmKSMfrd4dIAc5DP2qCDpxPjkHBBGpzIOMGI0d/XDC0IzZ+raobk8WTlXiQT78tayozWZDhhzbAVzNUGAfQOdPocOBCiImFXP0jJ99sMpc2OY1nJAN2hgiiOQ+btZ8ODqTPILsFI5Y5G921C3VcBthapqp4sNjGPmwQKUtJxnLn80X2dkoGoA6ZiIWCJv5byI2wFzoEbFnGUoFLy4V9G/552bjz0OJ4nLMRCA14+t3BZ25da7YvbRDcdgqtrS5Fn3U2so0oOOkCE+sUd+pLI2YUnxymBcTudfac4TERl2dz/+OovrBEnSad+Kg4sKhVKNa0zT1xX6r2hBjQRfNbVf5WrW+wCdlZ+FMJ7fBDRaeFJy36ZSbi783KH6Ho51EMImHK5Eep4zqgUv9ZZmVb2m7ydKSxFpPtgz5gM8rL8084FZ5QtA44CnazMqz9sJHvYpsFuGtIBcXzXv/Rq4dWuUcRlgtXP+6tW3+YJYGSzkpT6rG0GaHFTw1P9LjjnL3nu510rTvKEGniN1pkUlTNmhbaqO/bP0iBbHT2v96JG
 oAVuirO6
 lfAXMkqu/WTRprrcRMmdaa1vexXlxN2suLxeqQG9fNIlJM0gIL8PUnnfzByrJOBvO3r8gVT/9HbPHWya1VA5SLNyz4GFLHk0XoiGNaFVXo4Xv/uY79lxajT2EgxHXqjGzu0sAhb0t1COGFjC+FPbTuB598o5T9CzR9xop3RjrmCHkly3OK7gS0ZZcHR2NHIvU8e10K+eMU8Kdtz/X9jf8o0smhc95OBc2REHjNXyGhnjxzPt16RCH9RuADFYj9BzYwNX8s5aNHYX98Z6deiT9FcpRy6Ur/daoRliOqTfGwLbyxrSKIm4tzCLLFFy3FOjXnqKdMvhYcpClgYF7srKRSlKq7MyzfDwsyf/wzE+IVNgGstLhRy+9iwoWrpaxQljMpmzJbbeTGD+AmoR4Gg/ATJcyhZZMFcKB25s1PHyh5CL4L0PGWPRV4tf95A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/21/26 2:35 PM, Roman Gushchin wrote:
> "Lorenzo Stoakes (ARM)" <ljs@kernel.org> writes:
>> On Fri, Aug 21, 2026 at 10:31:06AM +0200, Michal Hocko wrote:
...>> We already had _too much work_ prior to the slopgeddon. Now we have a multiple
>> of that.
>>
>> Roman - I really think we a way of switching off the 'unrelated to your patch
>> but' stuff per-subsystem would be useful.
> 
> I thought about it, but switching it off completely looks dubious to
> me. So maybe moderating it a bit can help? Like not reporting completely
> unrelated issues or at least do not report them more than once?

Or, reporting them *once*, and not as a reply to the patch! 

After all, it's "unrelated to your patch". So then, don't pollute that
patch's review thread, right?

That would alleviate the most infuriating part of this cycle, imho.


thanks,
-- 
John Hubbard


