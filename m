Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 774F4C61DD3
	for <linux-mm@archiver.kernel.org>; Fri, 28 Aug 2026 15:13:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7D6696B0095; Fri, 28 Aug 2026 11:13:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7875C6B0096; Fri, 28 Aug 2026 11:13:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 64F166B0098; Fri, 28 Aug 2026 11:13:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 353D16B0095
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 11:13:14 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id B8B9C1C1C9F
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 15:13:13 +0000 (UTC)
X-FDA: 85151021466.24.91E4A47
Received: from PH0PR06CU001.outbound.protection.outlook.com (mail-westus3azon11011044.outbound.protection.outlook.com [40.107.208.44])
	by imf09.hostedemail.com (Postfix) with ESMTP id CFED3140004
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 15:13:10 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=NhYfzgUz;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf09.hostedemail.com: domain of ziy@nvidia.com designates 40.107.208.44 as permitted sender) smtp.mailfrom=ziy@nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787929991;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PmfbptkEE3XALNNgR9MxxtWU7Ah6JNGAOltLGzk5iD4=;
	b=WdO721l0bTXucLX4lOrAM0o4wqT3dYcGCeT8T2AFgxoV3JdhPXvJmU4gS8a1Gwzbt62Iid
	dPfE4a0lXpJaQN2g8VMZ4f8cdkFMQvtYUgLFUQ+n0h1bYB1OdprPcUk53NblOkRjclXGGJ
	4R121dckT5dLCJpqjj+EUsrA/cRxrIg=
ARC-Authentication-Results: i=2;
	imf09.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=NhYfzgUz;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf09.hostedemail.com: domain of ziy@nvidia.com designates 40.107.208.44 as permitted sender) smtp.mailfrom=ziy@nvidia.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1787929991;
	b=kgy082vLXhKIF7OZNMvjbGBaPRW+UO45/owjNMhoFRcPwNFfPINO2UjwHsEwsus6F49A3G
	T1xuSo4LBESVfAq5xRS9e0qaEcXbMqVqpP3YqJ5zt4Wgm9uMDRsTFZGGuLBXO/c8VNseDp
	PxGJc0E0ZeAtBHUp26GQpIyEb68VCMA=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Bitq2IKKIoWFIcXgdGMl011krBFposFdLfZ8YWpWCJAF/aBV6pPgaxPuLsJh5DJrY4e8UdbeZbeQ/zgThNn+HdzjVh10O5RLk34NQizg0k9scCu1oB+0L4I46Xa0sW+fmsYAnMF0RIRQ7Xm/1bPV/z9Janj1bFQyPJOc5I9sJcQPpPnaX7SnAnLfk9v3tnUrASshI5tN/rj0o2G/sEVmW5D0HrjZ/rZn8IyUlVZECZWyrV25qGtTODs5LIsdNXn0vKZtnr/z94XhcRjYTv3rV0krDGpWnqo87K41tbSeBNrNR+I4SaDoLSXin3b3HddPx3E7yR/AL991rcJu9FP7nQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PmfbptkEE3XALNNgR9MxxtWU7Ah6JNGAOltLGzk5iD4=;
 b=kM7ZbokUXUBgt7kowsvzxIsFJOEpVCERF+jvFKkscSJDz9Ggj7em5D2vVVYB4mGnb2MTVW7uYb2zzw8JhegjrCW5qrqnQNqHmeLgUSdXNyFldip1HPRV3lInXEg7Me77i6qUM9e+AYy8yke5HvwJAU8kvhNPN1gYx2slwaKLwDGZztIVhD8G07dWHQGrtT3dQWerT7oG++tvxjwHW6Bxo5Z6ZVO+u2EtI4aMHzgVpoQWHKude2ztG572m/L0xZZMMbzwDvUp1YLCYdupwCfYgbM9ArTcZB5swDT4vRCtvdP6qy/zg2xAIRPx6njs9F408dLILSvO12WbLjapmbYfqA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PmfbptkEE3XALNNgR9MxxtWU7Ah6JNGAOltLGzk5iD4=;
 b=NhYfzgUzsTQsU+ALTMOqD7xnYjj5LwxXlJfjFOae33lhZQlOL127St8/NNsY//BLnE4/aDx58kq28ifrXyqhe4NVjtETKpUK7vk3gfcvVHfN9lx8YPzNM+YxoqWfEd/nHGRNmV8USZL5jfJZ2QaLyNvl6zn052H/3kHVqmjiRelUSJ3ACrcmz+4gIY2c7fblQZPmnnIUehZES9o5skCgrgwKnVLn+9zm6rJ4lEZ4+fIXuX9O4BwIbYwhRkGOHRiOquMSBVSdT3ybxlGdyEwljsg7XFN3EJ/mWMLqvcc++5C0LRJ7kP6I10x/vAzPU5hMWnYN5YD6A5n4VBj6TjGQZQ==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by SJ0PR12MB5673.namprd12.prod.outlook.com (2603:10b6:a03:42b::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.360.10; Fri, 28 Aug
 2026 15:13:03 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%5]) with mapi id 15.21.0360.008; Fri, 28 Aug 2026
 15:13:03 +0000
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Fri, 28 Aug 2026 11:13:00 -0400
Message-Id: <DL0OA5ZF6VX2.33NA9XE20959G@nvidia.com>
To: "Yeoreum Yun" <yeoreum.yun@arm.com>, "Andrew Morton"
 <akpm@linux-foundation.org>, "David Hildenbrand" <david@kernel.org>,
 "Lorenzo Stoakes" <ljs@kernel.org>, "Baolin Wang"
 <baolin.wang@linux.alibaba.com>, "Liam R. Howlett" <liam@infradead.org>,
 "Nico Pache" <nico.pache@linux.dev>, "Ryan Roberts" <ryan.roberts@arm.com>,
 "Dev Jain" <dev.jain@arm.com>, "Barry Song" <baohua@kernel.org>, "Lance
 Yang" <lance.yang@linux.dev>, "Usama Arif" <usama.arif@linux.dev>,
 "Vlastimil Babka" <vbabka@kernel.org>, "Mike Rapoport" <rppt@kernel.org>,
 "Suren Baghdasaryan" <surenb@google.com>, "Michal Hocko" <mhocko@suse.com>,
 "Shuah Khan" <shuah@kernel.org>, "Kevin Brodsky" <kevin.brodsky@arm.com>
From: "Zi Yan" <ziy@nvidia.com>
Subject: Re: [PATCH v3 2/2] kselftest: mm: replace usage of /proc/self/smaps
 for check_huge_xxx() helper
Cc: <linux-mm@kvack.org>, <linux-kselftest@vger.kernel.org>,
 <linux-kernel@vger.kernel.org>
X-Mailer: aerc 0.22.0
References: <20260828-fix_split-v3-0-374022586a4b@arm.com>
 <20260828-fix_split-v3-2-374022586a4b@arm.com>
In-Reply-To: <20260828-fix_split-v3-2-374022586a4b@arm.com>
X-ClientProxiedBy: YQZPR01CA0176.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:8b::25) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|SJ0PR12MB5673:EE_
X-MS-Office365-Filtering-Correlation-Id: 5e1469b5-94cc-49d2-58db-08df0516daac
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|7416014|376014|23010399003|921020|6133799003|10067099003|56012099006|4143699003|11063799006|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	4NnFLN4srVqhO78v208/lm0Tb6Gn68HZj3JCFd4ARmDzW63d56R7itW8DJ9ttADoSuD/q0qXer3pzMHV0dMRA6kfAyu/mb2jzpIBesSpzws+ObiX1G+IyS4ai6umV0G0XEP0L1gi27Z/4eGviZfGMY89CCZKEthKED2zfQWOhVIHVSxsZjnDxut6XStgOMoFPdnjUoFYjxcznzMblryvvynicHosuI8GoLjRfGi4fXtGocHo83L2AsWFkOPeNd1A4cGl1hYmE+c2adbo0+DlVNPe06zwrEHq+rLjA9215rPlc19lFLQXzPgrJDtL/weiMcrQeNCv4KEEQCDx7JKXwER6/a9x9pKnpu+C6qAwi4AodCcyOBiXyRCBY3++d5pUAXFFQhPjfP3iGLdo5/klENJdfoaU+8NV4q3c/J6kkVf68tnC/2oPHX15WmqKE6pIejoornuK7m/jUJsAOSRHQteJyp45BZIG19FD90uyt1K8IOz7Xq21Y0IEESOPBJNa5+AljsPbEs+yXYnJu9+6BEzvRaImVYzjAztuwOUPw9s9Cs2PyvMvkpjXa0Mk709gbURWDVkJnQvK/W6dZieq8K5ZbJJdpQ3O3ON8OQG1mJ5DyeuEPdNDo3mopArZ02VMp5fPJ+ICZhRiDWYAL2ODvC/iDveoWLOUyMvSEYstc6FNeFIWSj4D5yXD+pxNz1cqf4mXce2JoGHCfyeo7I/pYA==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014)(23010399003)(921020)(6133799003)(10067099003)(56012099006)(4143699003)(11063799006)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?ajdGZWFEcVpjQlJRNHJNc3EyR0NzYUNFZktRMzVyRkNxcDc0OUZiaFBueEVm?=
 =?utf-8?B?eDJSYktFaGZQdms0dUd2SC9hNU9lNytRdlVwclhZSnAySkRwenpGYnIybGJU?=
 =?utf-8?B?clpGRG5SbGJOTVYyZlFmNXJhQ2lRNWlqWFQ2QTU0eFpsdGNTRFFuUUFyQUcv?=
 =?utf-8?B?bzk5R3JkWmRnUXVTUU5mSFBzc0J6UW0zQXpObGh0TEpqSDdxUGQvQUJSTTI2?=
 =?utf-8?B?ZE1ZVGxPYWdLT2RDZCtEZGxZWWIvVHN2UDJnRm1xeE1FZTRUYmhuRDZ6eDN2?=
 =?utf-8?B?ZDVjSGkvTGRLQ3ZlODRkRTNuY21RQXlhWEdJZDVWMXBGZnRlMmdUZzJ2QXZk?=
 =?utf-8?B?d2ZmZm1xN0tGcnUyeTkxN0ppSWNTYmJzd3FqK0tLM2Rqc3Jydkx6R2F2MkhD?=
 =?utf-8?B?V0FpenZBNlNMWFh2U1NLU2svR3NFcnoyb2JrVnhYbk5WV29rK3ZHMDI2UCsy?=
 =?utf-8?B?ZDI1SkJZb1RjV2QvSEF2dDlCa3llZ1NDR2xuaXlZZHdiN0U4ZHBLeDU1V2JG?=
 =?utf-8?B?UnAyNlQxMVV2K1Vvd2dXNFJJS01Zdk5SVzdteVlOZ3ErMFY4cnAyVU9iNGMw?=
 =?utf-8?B?Vnh6ZVgrZGRPcVRNYXRyMC9Lc0RGemZBWDhwOFplYndrYmlYdW0xbktVYmRT?=
 =?utf-8?B?RGhnRzc5Z3g2eXFtaUkzOU5PS3NMcGFKaFhXYmJCNXh6ZUdmL2FNZ2QzZUVk?=
 =?utf-8?B?YS9xc3M4VDNiazZJREtDTDEwL1c5SFgxN1ZwYm96UkZBODg2M3Fpdmg2cVlv?=
 =?utf-8?B?M1FMNG9FWmcvY0FVTVdkL3JGMEpXTEVJb1dlYlF6U3I1RVVGcXZ4SmpGTG9i?=
 =?utf-8?B?eVAwMzQxRE04OGJFUjJKRm8wZ3pVajZpVFlYNHVkdHA1c1ZTb0F4SnFTbTd2?=
 =?utf-8?B?cXZoblZWZFVuOEdKd0UzdzkzbTIyQVVFNWlXQjBsYjduQkVsM2JxdlhWNlpl?=
 =?utf-8?B?dnBTTll4MEtsM1E0a2FJMERhYmNGZmlMNDhPRUE0M3hFdUROeC8yTWJJMWxX?=
 =?utf-8?B?SDY1V0taMlJxR3hrNCswQWVBLzdoamcxb1BzWHJ6Qzh3NGpqWElTdkNsODll?=
 =?utf-8?B?dzdnQ3N0Nm53eDhGZEk2TEkxNzZ3TWNtQk5SbFB5OXNVcGxtVU8vaS9EMXR0?=
 =?utf-8?B?d0JMRS9oaENYc0lRTHlyd0t4Mm1WN3RYajdlVGZvZGExcXdVTmZCei9ocG5v?=
 =?utf-8?B?cUFjNm5hbkY0WGd2TWY0Uk5JUHE3UzVWZWFjL1FBa1M3MDZqTDlyeGE0T2lB?=
 =?utf-8?B?VmtiWDgyOVdtbnBKUzVQWXhLK1p5K3d4WGp4L2o3bHhNQVlYaXloTTZHTDZx?=
 =?utf-8?B?K2M1M2NUWEgyZENadTJnWjdGYWRVc2lKVjREdzhGSkNnbWRBaFF3MHFUYmJC?=
 =?utf-8?B?TGdnM0FSQXNDZDUrNDJKZThxeFdxclhhdUJqQjdjTzJjZEs1S040WlJ1Yk1Z?=
 =?utf-8?B?cWxlTnZ5Wnd3Ly9xWldnTWoyd0lGZkZaa1pFLzB6Sm1lb2JkSTF0WDZ0TE9L?=
 =?utf-8?B?NnRrQjNJWm9KN2RaWDBieDVDa3ZuMUhHK0l1bEVEMW5sSHlVallyOUFJMmdP?=
 =?utf-8?B?ZzVGcHlMTXJGeFB1Y0tQd28zNlMwNmowNUQ3K2dQTFVuK1Nad1JSbEVJaTgr?=
 =?utf-8?B?d1B4bHlTWmFTcWttT0ZFVkFVMjdRNitvcWo5TFRqcSt5Rmw5UEFIOHN3bWxT?=
 =?utf-8?B?TEdCMU04VnN4aWtvUDUwWTYzR0ZpR0M2ei9KMUtlVU5GaDY0NlpHcHBBOGVT?=
 =?utf-8?B?eVZObFJUclhqRGJvTlJ0L0hWQnR4Mlc0dUtwTWpub0c5TGJMeEx4STJOSTV6?=
 =?utf-8?B?NUViN2hZU3ZxS01KOEc5d0hpa3QwK3phYy91THNCQmVBUTZzZll3RDBYL1J5?=
 =?utf-8?B?bWlFbkticEFNOEZkOWtlQTNhNXFEOU8zUDdTTkFQc0MwaVEwNjFSMi9YaDlk?=
 =?utf-8?B?U3U0QTF0clZ3T3Bha0dFVjNZZ0piL3Z6cGNBVS8vajBLTEdmdUpYVkxreFQ0?=
 =?utf-8?B?elFzTkRXWG5Mbkp4dU9ZZ1N2SWp4b09OanBML0JZejgwUy85QmU4QWt1SDVW?=
 =?utf-8?B?Q1hKYWUrYVVRTXE3Vm1SSVhCMUc2dHRubXROTWFSUGtsdkxpWHBGMjZEVXJT?=
 =?utf-8?B?Vk55RnI3cW0rZllwQnZrb2tuN3BwRGFGOFBCTCtlajJtMzYyT3ZnZ3ZhVHFq?=
 =?utf-8?B?a1hGa2JjUk16eEFrUEpvck1oZUpPU0ZNb2Fvb1RTTGtseXMyN1lZUVB0Vlh0?=
 =?utf-8?B?UHFtSjZvWHJUcHVKa3ZkRzdwdDlFeE9VWWhvbFhiUDdobUM4Wm1ueUNEdlJD?=
 =?utf-8?Q?wQc3gB/NyqLUAfk+TZ?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5e1469b5-94cc-49d2-58db-08df0516daac
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Aug 2026 15:13:02.9604
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +PxXnFrhWAnMPdxL08IKQFHk+MALdkIVh+AIm7JX7JT4XqPuPrdRSbPeynmrpBoM
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB5673
X-Stat-Signature: wy6mso4ef64toh6x316zqnewejnrygf9
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: CFED3140004
X-Rspam-User: 
X-HE-Tag: 1787929990-681607
X-HE-Meta: U2FsdGVkX19aRiE423JGHjhPCyVItDwofdgfNS4Nt9p1JmHAz++KMU4ixyOG6Sorfcpn2rBtKlkMZ5+vUa56Jsb/q5iJ3YODOdahDQ4hOX+s0A8mFdn+2fpghKxManmJ0daJ2FNyFj4FIXJ/tNbP+FhQegfWSG00n3EHB86E6uEF8o5Guh7s/l0hT4c2SDp7HNTnORorgyZPkyvOBPg1i9RqeFy2ofoiEMoIV8SuJKQdJdpjz3+xbcUbKJnO8sxOVwwisYh0v7MvpNKsp1Yt2qO4BFjI88IRiJFei/RZzuyaH0m7PQ+vs5xRQeRSus8Is9WqTSV3XBIKA44PRu5K8e0Lf59l00u7dNrX9mM9gPxB2iiwQ+R6nbPAaFqb3QmMLrf2hBJZ89Rj5DTqjXa0LJjYyUcK1yTHiyTsQqyfWSpGcQc7wF84JycWHe/dgqmsgaGnZH9BcHUy8s6W8fZJg3UnG8vvX6uz+y3BgVwDZNQi4XhUsJUP4pLxkNH3ryxsVd8/747gnNjNQMDhFNMn6jLidvDf7FYeEdjW+93jq3WVXEY+0DLFMxZb6QyMlNOYo8jlj+GtFDSOs3IMmAuJRjuTlT51z7qiaejrl1sdW49qYuFVk3SZBVeVC//bzEdcV+YNg71i2Ht7ARy86jWJNUpUiKANrcPA5t+A7ManrXVSbt8cZeY6AK6Y22TS18uakORe3U1e9XZAkOZsfMQSFrHv8JNqpLd3PHlFaHfBhQC9j9z/EUATSdrtuuUHJUI1wp/gNI3sub8nNNNhq/IA2r1SyT2PdJ8nZrambXw6SinSJwbLqmdcxGeZwLOJEzJTR4GHfWtk1MpMqMg4FR1uJairsokhgAAfb8AYNRdIzLtNuWUIDDjZ1paZ0x1QKaD8CBodhYfRYDLBoJsVOgvtSckmqnX50pnkdp9P2qJkWavyLDgx5zptGO+b6wjWcaLONqlLilRK4kfZALoCeku
 BIVgv57Z
 iHOcb9Fkvk3zHIdq9ZVmcvEvPr55V7VPgKfP9duFbIM//zdMgb1pdf0Mnr3GLO+vQb44w1Ad+pEb9WvsVnr9MvK6yFa1asyuTHNWJoLW6cc26MiNNs3SeUiYXlYZKmnLW1SI87mG6Qh5ep8fmGgYb9UAnxINelbvhHZxs65aTGJKyrIB3aE6/Gi5ghJJlUawhgSc5bTdec4U2mGqtE4Ja4dW3KNm/ZPgP3QgQOssMa+WEDDuXmFDCAfGA5T73n+P6iAMU2tpBOENd978LXyZLoo04/7/7N+wRjslp2435L6TEXon/wT8xCVrH+T+h6L9HX0YSr6RzJZDj3DiiugcPk/feBpA1g00ZvDPVmBUYHkO+REmbLkrDdK5I0i5XCbQYsXFoORasDdxxPWC5wXzIPQ7YoQNJv0jdJUT5CaR1j8ftHXYlQN516EC/42xBTt0qbacigMF/aqUrJEePAwfSYs5iiks/CeqnLmsZj3BSqykE1yL44v3ADmKqP3og3vZoJ/CwyOfDp/h0dqWFK2+9f+5yvw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri Aug 28, 2026 at 4:11 AM EDT, Yeoreum Yun wrote:
> Since glibc commit 321e1fc73f (=E2=80=9Cmalloc: Enable 2MB THP by default=
 on AArch64=E2=80=9D),
> glibc may call madvise(MADV_HUGEPAGE) for sufficiently large allocations
> made by memalign().
>
> The underlying VMA may start at a different address from the aligned
> address returned by memalign(). Furthermore, a subsequent
> madvise(MADV_HUGEPAGE) call does not split the VMA because the flag is
> already set.
>
> This causes split_huge_page_test to fail because the check_huge_xxx()
> helpers incorrectly require the address returned by memalign() to
> match the VMA start address reported in /proc/self/smaps.
>
> Fix this by using /proc/self/pagemap and /proc/kpageflags instead of
> /proc/self/smaps to detect huge pages.
>
> Reported-by: David Hildenbrand (Arm) <david@kernel.org>
> Suggested-by: Zi Yan <ziy@nvidia.com>
> Signed-off-by: Yeoreum Yun <yeoreum.yun@arm.com>
> ---
>  tools/testing/selftests/mm/vm_util.c | 145 ++++++++++++++++++++++-------=
------
>  tools/testing/selftests/mm/vm_util.h |   1 +
>  2 files changed, 92 insertions(+), 54 deletions(-)
>
> diff --git a/tools/testing/selftests/mm/vm_util.c b/tools/testing/selftes=
ts/mm/vm_util.c
> index 4821a3563036..083b72d92b14 100644
> --- a/tools/testing/selftests/mm/vm_util.c
> +++ b/tools/testing/selftests/mm/vm_util.c
> @@ -351,31 +351,13 @@ char *__get_smap_entry(void *addr, const char *patt=
ern, char *buf, size_t len)
>  	return entry;
>  }
> =20

<snip>

> +	for (; start < end; start +=3D scan_mapping_size) {
> +		categories =3D pagemap_scan_get_categories(pagemap_fd, start);
> +		pfn =3D pagemap_get_pfn(pagemap_fd, start);
> +		if (pfn =3D=3D -1UL) {
> +			if (!allow_nonpresent)
> +				goto out;
> +			else
> +				continue;
> +		}
> +		if (pageflags_get(pfn, kpageflags_fd, &kpf))
> +			ksft_exit_fail_msg("read kpageflags: %s\n", strerror(errno));
> +		if (check_pmd_mapping && (categories & PAGE_IS_HUGE))
> +			nr_pmd_mappings++;
> +		if (kpf & KPF_COMPOUND_TAIL)
> +			continue;
> +		if (!check_huge_type(categories, kpf, type))
> +			goto out;
> +	}
> +=09

There is a trailing tab.

> +	if (check_pmd_mapping && (nr_pmd_mappings !=3D nr_hpages))
> +		goto out;
> +	ret =3D true;
> +
> +out:
> +	close(pagemap_fd);
> +	close(kpageflags_fd);
> +	return ret;
>  }
> =20

Otherwise, LGTM. I assume the replacement of memalign(), from the
discussion between you and Lorenzo, will be added in a separate patch.
For this patch,

Reviewed-by: Zi Yan <ziy@nvidia.com>

Thanks.

--=20
Best Regards,
Yan, Zi


