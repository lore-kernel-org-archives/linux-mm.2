Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EC5AACA101F
	for <linux-mm@archiver.kernel.org>; Thu, 11 Sep 2025 01:50:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3ACBF8E0005; Wed, 10 Sep 2025 21:50:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 35CF78E0001; Wed, 10 Sep 2025 21:50:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1FD478E0005; Wed, 10 Sep 2025 21:50:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 0802E8E0001
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 21:50:20 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 8DF09B8D54
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 01:50:19 +0000 (UTC)
X-FDA: 83875289358.19.2A7BC36
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2062.outbound.protection.outlook.com [40.107.236.62])
	by imf20.hostedemail.com (Postfix) with ESMTP id C89211C0005
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 01:50:16 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=Rf68Jgpx;
	spf=pass (imf20.hostedemail.com: domain of ziy@nvidia.com designates 40.107.236.62 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757555416;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=D1ITkLxREM2on98JK16jWYsMoBfWnCGKtTrTBD+ka18=;
	b=ieNBGPVEqPDYaSxUGpiZ3TIK9ijM0YPoADjY+taC5QWGVYQcKfWCnmfyXGwbHzkV9T2O0N
	Ylb410B3IOh4TZ7uoRT6eX6IWrNWgnTQymeSPvDpNn0rDu4Fu2/gRUly4Z2BlJHhYmCOXl
	Uo91vvQE9N1XH+aYe6gjLRQ171WkF7k=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1757555416; a=rsa-sha256;
	cv=pass;
	b=3cEld8oeqGIMi0KwXkEeSSwREPbcTghsm76w+3IUUjJwuGCVyu1SdhrmRY/ZqCuahkS9Rc
	orI+VSlWuT/oyqjjyIhW/xG4ZsSZk3sMS9RPK1VgzntSS9aNfxpaQXrYSMCTiGMYV3e4OG
	ueMoyWwZov7fDqjcflaXE6yPZTbClVM=
ARC-Authentication-Results: i=2;
	imf20.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=Rf68Jgpx;
	spf=pass (imf20.hostedemail.com: domain of ziy@nvidia.com designates 40.107.236.62 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=wHA6Mdh1xy9Jh0W9jXi8Lm2EgVaxLotIhHFfHsURkRHc/afMfsZGA3Qf4P3r7FZK63qDvHb6Q1jMAGVJ0OuFkQaX/GiTCD4by2nrVJEMSheIh5BxZApEEYeOKuem/z31phTxWRV70CXi9Mux/3MTVLaxyXbIqz+44KEp+M6QRF690w+LMP6x2TbQflIMmF3g/WxJSLfzMYWFm8gmKyuOP+2/Kx/I27ayPg8BPo1lNP9qvAQ9Yh3FmbMm2qfn9g3u59gh5SeGL1q6zxAXY5OjlS335EarmzdxJuRWQoeW15bW+iuqptlzwiIwW1hZXeKtZ++iM48rDi0mPg06GC9jZg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=D1ITkLxREM2on98JK16jWYsMoBfWnCGKtTrTBD+ka18=;
 b=wGhZkM0oIN0I1f9xeHKEWWNJbd++HkZN3H2ePDhvPmU6EL3iaJjk7t9s+4rO/TqmcjfKwHbj/I53MCNxax+0ZeTxtzp4ZmmaVu2oqW1Wx5Arjj4SKYQUDYeXpvYDRCjthEbeMjxDFaaGvFq4Ppze0alZM17+yyMNCqok5iJaLLrn3WmC1OneoJQ9UWQdd+Bje8A5BRxQOjQ4D0htk/tmq1iqnXwuUKA+AmQgM1ggX0Zs+q8mzaQa0NStqQ6/5xJ982Jmlq11p/MXGRc9gknusMh6ubqhJSDe/9u6sSyA3nVhQq+mlhUIcXaDjk2gg6mc6VtkHBzzBaNmW43ctpk3Gw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=D1ITkLxREM2on98JK16jWYsMoBfWnCGKtTrTBD+ka18=;
 b=Rf68JgpxRu4+yDnOEiPJRcDa9uG3l/TIbMbN5hJh9eWYis4LbOPZnTzwro/rYhlvM/oNLo0rALZ9LDDhJoo1PjLoCdYAu8dKidUCtpaSDJzKjDVxI3yxRUiKOPTiVniOMymsGyZIizckmrzG/QnoUdj907ujbLziKUxY28CUyjCJIGHII1Y1OwZt8a9AvixGz/MobqnqIWtBp2MzJJxvUZS5mqZi3P9AIn8kv0ns+tUMLqXxd8aHEYTLcHID0Tl+shSG5qfkbHLajhhVC6UfplyJOUcIRTVAYe7n0jKDHlstiTF27ruVmd/YADD736cKmDNooUbKQmp+0fkCZk+www==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 PH7PR12MB5653.namprd12.prod.outlook.com (2603:10b6:510:132::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9094.22; Thu, 11 Sep
 2025 01:50:12 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a%6]) with mapi id 15.20.9094.021; Thu, 11 Sep 2025
 01:50:12 +0000
From: Zi Yan <ziy@nvidia.com>
To: Wei Yang <richard.weiyang@gmail.com>
Cc: <akpm@linux-foundation.org>, <vbabka@suse.cz>, <surenb@google.com>,
 <mhocko@suse.com>, <jackmanb@google.com>, <hannes@cmpxchg.org>,
 <wangkefeng.wang@huawei.com>, <linux-mm@kvack.org>,
 Oscar Salvador <osalvador@suse.de>
Subject: Re: [PATCH] mm/compaction: fix low_pfn advance on isolating hugetlb
Date: Wed, 10 Sep 2025 21:50:09 -0400
X-Mailer: MailMate (2.0r6272)
Message-ID: <2A28BE8E-E62D-4ED2-8A35-759BFAE4C52C@nvidia.com>
In-Reply-To: <EBF646E5-8A7D-4115-808D-E13033240659@nvidia.com>
References: <20250910092240.3981-1-richard.weiyang@gmail.com>
 <20250911012521.4p7kmxv46kwz5fz5@master>
 <5F7DCC9D-4CA2-4BA2-9EA8-F04C3883E289@nvidia.com>
 <EBF646E5-8A7D-4115-808D-E13033240659@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: BN9PR03CA0499.namprd03.prod.outlook.com
 (2603:10b6:408:130::24) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|PH7PR12MB5653:EE_
X-MS-Office365-Filtering-Correlation-Id: ead6ac57-081e-4d68-3b2f-08ddf0d58bab
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|7416014|376014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?UlEvOC9RbXgwbVZZQ09zRXpiNjVUVXpUSUdTUDFBUzExOHlOQnYrUVk1N0k2?=
 =?utf-8?B?K1hWcnl0b2VaRU5VNXFjQW9oL0hENllxekZCSXQwcitmSDJYN3B1STd5R2RW?=
 =?utf-8?B?V0VUcnU4anE3Y1JLNVpFVFpzMFR5UlNPeDZzWHo4aUNmblpPd1dBNlg1Vzh0?=
 =?utf-8?B?dW9pZ3Nyb3dOV29RV2VudEZleHhROCtpQnZxSnIwOWJwR3JNTmZURkpnVnlk?=
 =?utf-8?B?Z1UrUStibFFPWWgxS0NuYTgzaXVFdi9POVVyQ05Oc0pSNzE0ei94OFVTV1JO?=
 =?utf-8?B?MFZqcG9JMitVRE1UbXlKaEpJSUJMMVNwN1ZjTnZqQWYwVStlcEhpTW0xZGh1?=
 =?utf-8?B?TGc4Y0NjZ25tcjRadTJlYldHakQ2bGJBN0ViT3c5eGNPdElnRG4wOENvaHVk?=
 =?utf-8?B?NHR3aGQwbUU4MnZZK2k3Zml3cFlEV1kwZk5GRXdzcE8zMm1YRU54UTJFN3dV?=
 =?utf-8?B?bGhEKzZBVENZMmhuTy93RzhQZHl3TDhVenZyQzlVVjFYdnh1NWhDYTZmNjdH?=
 =?utf-8?B?V2pMWTZValhKQ3F6REVuRmFxQ21YTWh5UU1SMGFmeVVGWGpQWFF0aGhqa1E4?=
 =?utf-8?B?VVNXWVE4NkYxSWJkWk9BTVhKNnBGVjRZblROY2orVTlXWm5Hanpyek5ROFJU?=
 =?utf-8?B?czF0NFRwWVc5Z2N1S0oyWCtTN05WV0t3RFA2b3pkYnYrL2VvaHJlVXJQZ1Vo?=
 =?utf-8?B?aE45WlJXb3l5cWY2SWRTcG5haDVSalJLTldWdUxLYXowOFdteWZhRWVQbU9w?=
 =?utf-8?B?OUxQbXhrbU83S281eHpQK1lBYmdnUTZQbUFXR3A0cUtOTWJ2UVR5QVRxMEQr?=
 =?utf-8?B?MU8xMG5GbkVMTUlFaW5XWjRPeWdsUGZJY3laR0x6ZHliMTBEMHZRakJIRVV0?=
 =?utf-8?B?ZDBHK1QvcUJ6aU9OcHcrZk53OEhXenFzZDQ4eGlCTWtIZG1JTjZ4aXAyRlpR?=
 =?utf-8?B?ZVpCbkxaSDVzR3hhNkN4MTdGUCtYSnFQVng1SnRvbGJUOHRaaGErZUhFeUhn?=
 =?utf-8?B?RHdGM1NVOGN5alBUQXJWcDA5NEVvQXd1SkxmRm5TZXNBcUdrRUE5dFlSNU1k?=
 =?utf-8?B?UmUrVkthTzFKbXFhWStvK2tkME5qSmlvV0R5Q05kU2tMOWNYbGlOazZxOW02?=
 =?utf-8?B?MFp0OThNOEtZUUU2bjJjb2RaN2p6Yk1QbHpHUk1lNHg5R0tnOFR2WFZmWEpB?=
 =?utf-8?B?MlVXeXViU3FnY2liZExlazdiM0hmTldTdU9nTU41Vld0VUMxTm5HcEw0SFFW?=
 =?utf-8?B?QXpvdkhhWHhESDBjTEcwTGtGMk1GczAyb25FSFBJb3Z3K3Q2UEFCTm9LZFBM?=
 =?utf-8?B?b0FwNkwrNlVnVDYwSkwyT1drWGVsdlZVZlhmUGhVLzFqb1FKM08rWG5Nb296?=
 =?utf-8?B?NGlZOEtJVDhPakZuR21PYjJmUFpDeVNJSXFScnNhWDBML2RidnlXTjJhMG1F?=
 =?utf-8?B?OEJnNnN5QzczVGtreFZXaDluU1JrTWdFeXloTElRUloxd2JFbk1BKzNPa20r?=
 =?utf-8?B?ZjhhOFgwWjBDdHF5U1VzQWw1N1B5dTVvckgrQXNuSXFRMHFIQnZlMjV1YnFy?=
 =?utf-8?B?RVBvWTZjMEtkQkl1Q2U1MjF0SzBMZ29GdWJYU2NpbzFlbVdpWGhETHZMWC8x?=
 =?utf-8?B?emJ0bDVBMmY0RmE1YUU3Mko4L09kOTY4S0hVZ1lHcU9xNFBCRUMvUjJ0YXBO?=
 =?utf-8?B?K3RibTRNQy8wUjVWdm8rYjg1TFFObjRFd3BadGpYa3ltb2hpaTJtSHQvcC84?=
 =?utf-8?B?bHRaZWdIUkxIZGN5TnprSlA2Y2hhYmRiakluZ202aDlPSDd5UkpmTlFncVhD?=
 =?utf-8?B?SjBVMTVzNUR3ZEM0ZHlaNWsxdHUxaURSY1J4VWFBbG9ZVCt3dFgyNHZrcmIr?=
 =?utf-8?B?WkNSM2UveFJTRFBzYWN6dzBuRWhsbjdlcUphWE5YTi8xbHR4MCs4RCtoN0Yx?=
 =?utf-8?Q?Jmvw1E0xkOw=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?SGR2bVhYODlEUE1DeWViYlpkdHQxWFhDRHRpSWN6bGFTQ3ZyMWtERDMrY2tD?=
 =?utf-8?B?V2ZUd28yY2tYc0w5Vk5JV1E2eXNidkJGYURVQ0toT0UwYU1FcmYwQkhob2NN?=
 =?utf-8?B?aGU2c3IyVTR4NDU2a1YvNmRiaXd6disza0RHa1hsR05MTHpUY0RSaWl4MUhM?=
 =?utf-8?B?bVFHeFg4NDg2M3hoeHIvTEdKS2t5QnN1RnJ0dDNLWUUwOTRrWWk2ZjJ4LzlY?=
 =?utf-8?B?UFFNVlpYejRUcmlWNUEyOXNCeS9iRmtlQ2wzTFZkMUt1WUFpWFo2S2FGeXdW?=
 =?utf-8?B?QmNJNXNQTmlFKzl6T0liZUl4Zml4MXdPYVJXcTd5MGVFdmlnUTMvb0o2eC9Y?=
 =?utf-8?B?WFFKKzRzN0p6dXJFRi9GUmdScDNtN1lIdTl0MVZCc1lkSnVzbjJ4aTlQdkF3?=
 =?utf-8?B?L0NiWExqbFNLdUNIOWxPSU5kZ1c3YXhENGdPaUNNeVNMelo2d1hZRHVsL3ZM?=
 =?utf-8?B?bUUzWlpycHJYZHJlRmZ1VlpqN1hrME1SWTl2VHY4ZUppQXJjMHdUT2RlTW5y?=
 =?utf-8?B?NXFzYldMUUREd1FKSjBvKzkzTnROY2RESDE1akd1ZjVmbjU4dWtwVjg3c3d0?=
 =?utf-8?B?L1VNcnpTVEJGWWVKY0V2UzBESjh4Vm16UnF0TFd2Sy9GdEkyQ21pYlFvZ3Zl?=
 =?utf-8?B?N2ZaY21mZitaQkJMYzYrWVk0WE5SdnFBR3FYZk94RkkrZDZISGhCblRVZTd0?=
 =?utf-8?B?NXdYaWhIc2NrWUgxR3d3WXYrZUMyUUVkdEpKMTRrTi9jWStyZkM5dm5mWEVH?=
 =?utf-8?B?UEdNZThRK3Z0MHZpN0lOdnNMTit1QlQrbUtjbmlOVFlISTlpTFZxa0k2UEZO?=
 =?utf-8?B?d1Z0dCtBdFpIMDdIZm0xNTVjVlpoM1NqYzhjTTRyZGRNYzRpU3k1S2VWbnk5?=
 =?utf-8?B?NnlHQ0tkM2VTbjR3UzFyUXUwbm1MaHdQd0NZalpYSWQ1cDJ3REdtTDdyaElh?=
 =?utf-8?B?dXMxUjFYUktpWFNOQStXKzdmaWVXRmJ5V05yQ3IrMUpKaVRrNTJzblJtVE1K?=
 =?utf-8?B?dnlpZHBpeDZBaCtXQ0ZybzR1UGtmQUNsSTNRQTAvM09uMkZXeWlFejJKN1Jk?=
 =?utf-8?B?UFhxeWEwNWN5WE0rTm1RTnZTTFJzMC93YkZmNTE4RkJXajRtWVpSTnY2cDJO?=
 =?utf-8?B?V1J6UGZ2cEY4VTJ5S1JkenBQT2xJYzRmSlhJR0NaWlVMTDVta1YxMm5LVm9K?=
 =?utf-8?B?QjZtZk1zTHJ1WlBkYXFzSktVbXBRWFFFNUFOdjJCNHI1Vmd0VngyZDRNTmdR?=
 =?utf-8?B?TU00c3ltcEJyS2VZRUd1Q2tJUzVjMGZBRnBxQjZFQW5QVHljQzhYUHk0VmNO?=
 =?utf-8?B?Uk1IL1pnVmswQUhIS1BmTDlabWZqL0M2c3NxdDdyWC9lZHpwOVJaL0lPK1ZM?=
 =?utf-8?B?MitkY2lWMHFSWTZ4eFVkTlpVUVdXRStFWE12bE1Id1ROZmdSOTFIWElQZU9T?=
 =?utf-8?B?QTh6WTZXREdORHQwRVJiVU5URWUybjVtamZUS0VRK3pFdGIrU1RiSVBhOXZR?=
 =?utf-8?B?OW91bUdpanUyTFl1M0puSGxKMWhUU29WTkZNSkpJMDRXS2xKQUcvb1c1SXl1?=
 =?utf-8?B?c0NFbDkxQU4vNzBpNDRNM2xnV2U2WlpDNm5XQnE4dUxDaExBclZmMHJHdjNG?=
 =?utf-8?B?bXNBanBlLzJTaktJVFZibFlpb2NNakVEVnluSktDYnhnRGFSU1djbENZWlhJ?=
 =?utf-8?B?cm5EbmFPZGF2aTZhUDNyc2tJNFJpaHovUWIwQTBzRFlxNEg1UGQvRmtwaDhi?=
 =?utf-8?B?Z3Z6YVY2Sjh0M1NlNjFGblNFVWlObjY4Q1krRzRZU2hFY3pzbU5IQUkvV1pU?=
 =?utf-8?B?WjB2dVNPcFNCSnRDeWR0OVo0SVVpTWZoTnB3R214MTBzeTYvczhGNnZieFp1?=
 =?utf-8?B?U0d5eUlYbkgra3RlZk5WdkhoeHppSEx4MnpwMll1MUZ0TEpuTXJaVGUwQ2VV?=
 =?utf-8?B?dVlVZVR1ZlRmUTBhVmxmMHpNOXpXKzduVUdPYzFEY1hWNjZXdytOSVRMa3ln?=
 =?utf-8?B?S1M4MGFERHhhaFBIUUZ2TzlGU2FXRVhkQ243dXlLQjJaYXhuWUlEb05vNndO?=
 =?utf-8?B?MmRybGNLMnNwUlMyOGNFcGFyMGhndE9SUFRWY0xXMFcyU3dLY08zWXp1NkhM?=
 =?utf-8?Q?bx0/Vo112HlOaFQYifV6D9dQL?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ead6ac57-081e-4d68-3b2f-08ddf0d58bab
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Sep 2025 01:50:12.0252
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: x2WZ3U5SXZgu3HxCzkzPB1I1f4EhpVFxiaiL3UyM3Az/ZcvBcSg+ZJt3z4nKyJAl
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB5653
X-Rspamd-Queue-Id: C89211C0005
X-Stat-Signature: i8fxtyp6j4md4qigxu16i38ohbjc6uqw
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1757555416-96169
X-HE-Meta: U2FsdGVkX19U8g6uFYgxPNgDBUN0eQtVtgM+Zzvbs/p5dNFCxUt5MvXZQl1cvgLT23Vo+9x1tcYSdrh+bedSoknJtBOotpreClbPx64/kflmmhy3LlN2xMuEJBKRKx9NDBOCdW99CPJR3hmYPGdJHlujZ5tfGW/ykf2Vz8c7FYiRXzUv948IgdrN6qd9FyovK04P2qPtlCi0ivr2pkL37tZfHrPGkXEcVP2Jis/dBGVoahVwgtteWRwLz5RfmMEnQoUOBkHxC2V+/C9oOZ+wekBwOAj88QgdfDkYV/2umzzj/K/3Eqbzi3Zs1pn4VgpH95JNNkLbsVJVUuRj2gzU9PPnZAO1rb7SXC2tN4vfruQzswp7WIYsnRckTjdW111t6OG9gAJlSYYwZnRnv9AuZr4KBpc+dJUsIoe/dVL0DH6JcmtTLhP9MQPYZoNuHsFfQNZoUEBiV0DH1uj1/guPvz54srBUmwYm+wzlLn5CRUlbJkvbamDB9jXfwF0JQ0XJXlR70IcgWr5cfQp3D9Gz2JLazv1fWGkU08P2VFVUgEw5mJoDxiBFaoEofoIYcXu6q/zs7X8/WXR6YMLmX67T2wDt+cSOQ58ZzxX1CapHUb2mIwxIsBwiJb1Wnq+znKNwl9cEK+b2jG02vOFznZmy2GV0Rq2PmKQw3FQ5LDqPDNkujnqEBUhr7GdTsdqel6TqdvKchrLJaVTPixH8PNhi/mfkiyIhgriTQ7uV7OLL0sncZUtuIXqTq6ItHsfY3zw1szNb7MrqYCTQhbgv1QgkOuN5Fo+E+iyDs46nkibWXuXpwxMMVXHFqEV/UNbE88vKrq1StRbiIphAKqah0d2smyFmmUR1RdiyKSa0PfqYl7DVROa/By37vwwMo8B27J0OTfmEpdmleNubOhEOY1cUthzPxkqH/iJZrv9VC/6r07Kc9tuGh3oriNXwh72SBthIYPtBJJQz8PBRGRhW0H5
 cfPqcylx
 l92OLUvCgMsQRoF6G0PevcSmjCVmnlYAEls9NyowJmy1+uPgxiRVIREbf9GPdtNHpF6Rl0uE2E3k/X++Hyfq5zFWPOi4xQ+lZyZtOPNRyvbGpUyhd3Ab7HZQ5NGcPhekalncITsTTrD7/ZJx0DAc56h569mkDdqQ9V/LHPdn8WvK9hyCboqvs8H5ZtYLR4SnWU9HaADH3GyYHa8XhMTU1yxSvl4B7eKQJwCT3P/LErcwumyI+YCplKsQ4zZnqnVPxGnM7ByxwL3/UOunQvm74Ag+/OSRChfHGzOmDOB4wMg6Ky5IEoLnZRZDKoCtigyu/DpfluF1EjDRVYnDolJU9GMx5a++CpU5LRoMpyqT7qwm1CnJ8ztIqQacU+XWetjf3CkSWtz0kvRI4VRI3rKPHntne05Oq1BEpxKA2I+NcDzI6gyMYrES3chwaYnR+OpoQrSzuaRshrt7FKsFjSFmi9LckNUIqvEgtLdWU1IVpL56t/RikORP284BpWxoRaTHPEtM9djVvdDbSqRBudLIMcWdwMM0dUokW9vmQhzuVxnRorh5487eYUD07VaYAKjZt+XKgMGzbZ0+/HRdqHJ4IPL8+f1ur4JI+wyZdrjQ6Sp6pMXNpyiROTaithq8yA7MLHTQirquJWaLTJkI5CbXfH02+HQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 10 Sep 2025, at 21:38, Zi Yan wrote:

> On 10 Sep 2025, at 21:35, Zi Yan wrote:
>
>> On 10 Sep 2025, at 21:25, Wei Yang wrote:
>>
>>> On Wed, Sep 10, 2025 at 09:22:40AM +0000, Wei Yang wrote:
>>>> Commit 56ae0bb349b4 ("mm: compaction: convert to use a folio in
>>>> isolate_migratepages_block()") converts api from page to folio. But th=
e
>>>> low_pfn advance for hugetlb page seems wrong when low_pfn doesn't poin=
t
>>>> to head page.
>>>>
>>>> Originally, if page is a hugetlb tail page, compound_nr() return 1,
>>>> which means low_pfn only advance one in next iteration. After the
>>>> change, low_pfn would advance more than the hugetlb range, since
>>>> folio_nr_pages() always return total number of the large page. This
>>>> results in skipping some range to isolate and then to migrate.
>>>>
>>>> The worst case for alloc_contig is it does all the isolation and
>>>> migration, but finally find some range is still not isolated. And then
>>>> undo all the work and try a new range.
>>>>
>>>> Advance low_pfn to the end of hugetlb.
>>>>
>>>> Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
>>>> Fixes: 56ae0bb349b4 ("mm: compaction: convert to use a folio in isolat=
e_migratepages_block()")

This behavior seems to be introduced by commit 369fa227c219 ("mm: make
alloc_contig_range handle free hugetlb pages=E2=80=9D). The related change =
is:

+               if (PageHuge(page) && cc->alloc_contig) {
+                       ret =3D isolate_or_dissolve_huge_page(page);
+
+                       /*
+                        * Fail isolation in case isolate_or_dissolve_huge_=
page()
+                        * reports an error. In case of -ENOMEM, abort righ=
t away.
+                        */
+                       if (ret < 0) {
+                                /* Do not report -EBUSY down the chain */
+                               if (ret =3D=3D -EBUSY)
+                                       ret =3D 0;
+                               low_pfn +=3D (1UL << compound_order(page)) =
- 1;
+                               goto isolate_fail;
+                       }
+
+                       /*
+                        * Ok, the hugepage was dissolved. Now these pages =
are
+                        * Buddy and cannot be re-allocated because they ar=
e
+                        * isolated. Fall-through as the check below handle=
s
+                        * Buddy pages.
+                        */
+               }
+

>>>> Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
>>>> Cc: Oscar Salvador <osalvador@suse.de>
>>>
>>> Forgot to cc stable.
>>>
>>> Cc: <stable@vger.kernel.org>
>>
>> Is there any bug report to justify the backport? Since it is more likely
>> to be a performance issue instead of a correctness issue.
>>
>>>
>>>> ---
>>>> mm/compaction.c | 2 +-
>>>> 1 file changed, 1 insertion(+), 1 deletion(-)
>>>>
>>>> diff --git a/mm/compaction.c b/mm/compaction.c
>>>> index bf021b31c7ec..1e8f8eca318c 100644
>>>> --- a/mm/compaction.c
>>>> +++ b/mm/compaction.c
>>>> @@ -989,7 +989,7 @@ isolate_migratepages_block(struct compact_control =
*cc, unsigned long low_pfn,
>>>> 				 * Hugepage was successfully isolated and placed
>>>> 				 * on the cc->migratepages list.
>>>> 				 */
>>>> -				low_pfn +=3D folio_nr_pages(folio) - 1;
>>>> +				low_pfn +=3D folio_nr_pages(folio) - folio_page_idx(folio, page) =
- 1;
>>>
>>> One question is why we advance compound_nr() in original version.
>>>
>>> Yes, there are several places advancing compound_nr(), but it seems to =
iterate
>>> on the same large page and do the same thing and advance 1 again.
>>>
>>> Not sure which part story I missed.
>>
>> isolate_migratepages_block() starts from the beginning of a pageblock.
>> How likely the code hit in the middle of a hugetlb?
>>
>
> In addition, there are two other =E2=80=9Clow_pfn +=3D (1UL << order) - 1=
=E2=80=9D
> in the if (PageHuge(page)), why not change them too if you think
> page can point to the middle of a hugetlb?
>
> Best Regards,
> Yan, Zi


Best Regards,
Yan, Zi

