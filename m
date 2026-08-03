Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2E39AC55182
	for <linux-mm@archiver.kernel.org>; Mon,  3 Aug 2026 21:05:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CC5D86B007B; Mon,  3 Aug 2026 17:05:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C77D26B0088; Mon,  3 Aug 2026 17:05:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B3E736B008A; Mon,  3 Aug 2026 17:05:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 823E06B007B
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 17:05:28 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 0FDA71A080C
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 21:05:28 +0000 (UTC)
X-FDA: 85061189136.08.964DBAC
Received: from CY3PR05CU001.outbound.protection.outlook.com (mail-westcentralusazon11013044.outbound.protection.outlook.com [40.93.201.44])
	by imf03.hostedemail.com (Postfix) with ESMTP id 284B220013
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 21:05:25 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=okQQYAJn;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf03.hostedemail.com: domain of ziy@nvidia.com designates 40.93.201.44 as permitted sender) smtp.mailfrom=ziy@nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785791125;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XREpuZBe0n3lN7r7Qv8j0KvE4PoKPPmkt622YERMb9o=;
	b=WxaSJ74nUGDr1Hdr7Fy0raWYuItE8qTgcd5NOoaW1GpKXBwU/RbNCMeLKlwlIVXjKVF49C
	T1ZIuz2E9FuVBwCMy8za4sikWHv1r064KDd3a2QPujymeSwDIF6QvgubfhzNf1tvgyQoyP
	GFyZhgi+WvQ8KY8ANjvxcrBoPJ+Nkr8=
ARC-Authentication-Results: i=2;
	imf03.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=okQQYAJn;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf03.hostedemail.com: domain of ziy@nvidia.com designates 40.93.201.44 as permitted sender) smtp.mailfrom=ziy@nvidia.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1785791125;
	b=DFaqb5u79/xf36SDihFra8+A5AXqtv6nynlcy/trqFXYApFbQbj16EuZlmhCwzTL3BAEo/
	24sd6QsrhkXHu9DnZNMamChzR/g6Z504TPOPZiZhX8fT8GvnfPbrYzijlOdYr/oA/52hyJ
	tsDHvzT/bEvvEORdGjPHQBNsxNWAVAA=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=iRbqIDYTQckXuGlw1HQqIOepasaRaCLp/zES+D4zJ7faSFxvx+nr+GesT+3UxLAtbtJFid1Mu2aDOiCKreUX77HFqt6CCuShX2y6OEa2fTKf0qs4ZjDL1Q+RnHbSkyrVqj7iVX3zO62uloyUP4u6WArgwLnocRR3Nf4O9Z50ekG3st94SWLBSnoiR6f1KbaAL0vptSwoggZSTrT7gQISoqES2CA+p3UQAn6mZdp5j3PsmaiQiNmc4MzS3DB8m4RSWDsar9fH0L4f6ltpFy/UlU7ub4eznS80C7OYrEUvM2fuDYI7jDLyJ2P2i6xE5DzAjuI/+1eEqoDG+djvXswYYQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XREpuZBe0n3lN7r7Qv8j0KvE4PoKPPmkt622YERMb9o=;
 b=Acnk/q9/q+zOBPHJy/Ss3VuhU81yyjIxSMyYneDrCAwprbpVLDyQvXkk3iGhxvVPSQxZEd/aQPPRzitoG9bAtojD5oM9ON+Hiokq+Vy825ySJFD+vfWMAcA05yGLo69Cb/fUi9tsmOu+Fs8MQWrVnN6d4aUONB3ToaXQYLMfcod2FuoxYzMNW8S+lAYC/S1fkIhhcc7aIJBwJMz4uTokKzzgpOP8C0aPB5BfwGn5eOs+MhDSiTWWXXw0TkbRplb3N80tbfQz02y29C1ErcpdWQN4n63Ue/PFtU+LaV8TY9mVTS6U1ewLFJVMqjtmzIwSKn8Ygk/mlomx/z4tV1Awzw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XREpuZBe0n3lN7r7Qv8j0KvE4PoKPPmkt622YERMb9o=;
 b=okQQYAJnam8O0eeLuY8Eu8qgZZv/ZkyPIW/Mkk9RHxETM2FklZ0Jjyc/SYbLYemd1zePuPK1soXGxUToHfyXtOikRgi08+MWKoGnWfhXpI3g2EZJ8EslIy8NdvaOvlGFPtHcRhIN/y0gkjcsB21LBAfVYv/pXCHpoel8UYvksFEGhmWYqbidnrC8kQOdbc/efyx1tNgvapHsjIh6QLuoRGfDWzboz3h4epBlw581LanjlmTShO6i/OelbzOuB6mHL8E0o4QRvFr9zcPQqa/uy1NZo5T9QDLLEm1Yj64W43TgOXA+S8VDU4lnndbn+ipnyS+P+YfNmC2oJHn03feZJQ==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by DM4PR12MB9735.namprd12.prod.outlook.com (2603:10b6:8:225::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.270.17; Mon, 3 Aug
 2026 21:05:17 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%5]) with mapi id 15.21.0270.017; Mon, 3 Aug 2026
 21:05:17 +0000
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Mon, 03 Aug 2026 17:05:12 -0400
Message-Id: <DKFM47T0EL9B.2LJLE3UFJ0E2X@nvidia.com>
Cc: "David Hildenbrand" <david@kernel.org>, "Matthew Wilcox (Oracle)"
 <willy@infradead.org>, "Andrew Morton" <akpm@linux-foundation.org>, "Muchun
 Song" <muchun.song@linux.dev>, "Lorenzo Stoakes" <ljs@kernel.org>, "Liam R.
 Howlett" <liam@infradead.org>, "Vlastimil Babka" <vbabka@kernel.org>, "Mike
 Rapoport" <rppt@kernel.org>, "Suren Baghdasaryan" <surenb@google.com>,
 "Michal Hocko" <mhocko@suse.com>, "Baolin Wang"
 <baolin.wang@linux.alibaba.com>, "Nico Pache" <nico.pache@linux.dev>, "Ryan
 Roberts" <ryan.roberts@arm.com>, "Dev Jain" <dev.jain@arm.com>, "Barry
 Song" <baohua@kernel.org>, "Lance Yang" <lance.yang@linux.dev>, "Usama
 Arif" <usama.arif@linux.dev>, "Gregory Price" <gourry@gourry.net>, "Ying
 Huang" <ying.huang@linux.alibaba.com>, "Alistair Popple"
 <apopple@nvidia.com>, "Qi Zheng" <qi.zheng@linux.dev>, "Shakeel Butt"
 <shakeel.butt@linux.dev>, "Kairui Song" <kasong@tencent.com>,
 <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>, "Minchan Kim"
 <minchan@kernel.org>, "Sergey Senozhatsky" <senozhatsky@chromium.org>
To: "Johannes Weiner" <hannes@cmpxchg.org>
From: "Zi Yan" <ziy@nvidia.com>
Subject: Re: [PATCH RFC 01/14] mm/zsmalloc: replace PG_private with pointer
 comparison
X-Mailer: aerc 0.21.0
References: <20260731-remove-pg_private-v1-0-142c97ba3562@nvidia.com>
 <20260731-remove-pg_private-v1-1-142c97ba3562@nvidia.com>
 <anCuGbQ_-pTajAed@cmpxchg.org> <DKFF32LRYH32.16JIXI4LUS5E9@nvidia.com>
 <anDHoYNn0lPc34cK@cmpxchg.org>
In-Reply-To: <anDHoYNn0lPc34cK@cmpxchg.org>
X-ClientProxiedBy: CY5PR19CA0061.namprd19.prod.outlook.com
 (2603:10b6:930:69::7) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|DM4PR12MB9735:EE_
X-MS-Office365-Filtering-Correlation-Id: 345d2414-cf16-4c92-732c-08def1a2eb95
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|23010399003|376014|7416014|18002099003|22082099003|5023799004|4143699003|11063799006|10067099003|56012099006;
X-Microsoft-Antispam-Message-Info:
	tKbd1WCLdxWpKtSAvhAmQPkk5FYu4/bFu2DLVrrRmlxPV+I8bH3fnXMCoj7wwN/04KY63ws5tZd7tkHeWDdOE84VwyjhFmBU6KASbkLUIo3EfirZugRVffC0I/shUGrOHxBJzQYKWlIRsgOJjM1gMdjxVTEzyN/jHOeyfTp3LbjqodeOXYaV0+g7gaYktWg4mVb40tscoMJ9Z3+M+2aFxZyleJTH9z0G7xC+6f5GbG2xgmg1VwYib3VyMgFHDmzUynNqWevOAXTitfuQS0nr/90OrDGxRUDB0PyzhZSHtYJTuu8l/LECF1Xk58u+jKVd41QIdf58BHQIxt5OfMz26Ddy5eUF/rJMnOxeyK6mzUrctltaptQ8fmnqfHW1Oo/3E+VMk1l6J3IwFjeHu7QL2Fkayf5YNWFjN+PnllIpvf7IYn4lu/6rc8W1vrTLZggAPTNayROfRdqneW95qgVldgtGJA7t4qaANw3+MME0ldFlUxmWWyhhAfXPlsmMSDVrz1sziXJofgLVQYvF6iZ4XKMrKTBRJ4BfulrcPbp3ZhW53MkHilGVuLf3/aSBd9aOdjnW4goi3GaYx3IK7+F/zDQ2XG6CmUIRzZDR/yjS4iXrpvxH4pA0m1jEvJWKBlAws0ENEjHy/yGvhOikGABDYeq9paCz6QyvzsU8NWprkhA=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(23010399003)(376014)(7416014)(18002099003)(22082099003)(5023799004)(4143699003)(11063799006)(10067099003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?R1E0Qzg5NEJiVENYck4vZTdxNHl5TlRYazNoTUZuOU80ai9NT2xDUnpoSjl3?=
 =?utf-8?B?Y1IrMVRRenVad1ZVbmhHZHVSUGlDczB3Vk1VNmdnRmtVMFFmbm5sN1dkM3Zu?=
 =?utf-8?B?Ri9mTlNNUUl5STV5cVloVVphekYyTjBZTjVmeGlYNDE4eEFGendJb0VwL2Iw?=
 =?utf-8?B?YmUzaWhhR3NYc1hyMGdpOWtIOElvS2hnZS9LcTQxb0tLQkNJcUhiYkNkbFA0?=
 =?utf-8?B?QlorQmROcENEaUlkUUVURXBoSit6UVhkampON1RWYndZOWZCeWlFUVliNC9n?=
 =?utf-8?B?ZnE0V3VvTU9yR2ZvajlnTnF3dTdJVk5BL0hkaGtaM3g3dHIxQzlOWXdoWDJu?=
 =?utf-8?B?Tk85bkhmTVdJZWVhWmNud1RWUlUyOVZBdFQvNFNrb0ZPb1JEYmRxbk91a3Fn?=
 =?utf-8?B?MnVkMWtxUWNkbFo3R053Wi9GT0xFcGV0WTh4NVArV2hUem9qcE0vaEI5T2x4?=
 =?utf-8?B?UDEvc3J6Yk9LZXdiVE9tQXB6dzFYd1dMUWI5aGVPOWk2bk13aU9xbVZpVCtQ?=
 =?utf-8?B?UDg3d0xwb2MxaFRnamxsbHI1Q2lNOVdCcE54U3EyOHhMYmtqN05XRmhMaTZU?=
 =?utf-8?B?MHFXM2FGdVFPaW41TXlSNnNheUpzaXVqTUtpVFJ3dGhSM09rMVlzMms1Ym1V?=
 =?utf-8?B?SWw5ajd3UlJpRkM4YlNValBKVGlCUXJLTUVuakxoWnZqeHhydXcvcXc4ci9t?=
 =?utf-8?B?ZTVtWkcvVnZ0aDcyU05tQnVvemZCTUxqazVOUm1oUEh0Y2Nwc1YvWk9Tdk9I?=
 =?utf-8?B?cnFwVVlYQmlXZU9Ea2Y4L3RDQUZ1ckJmbzlyeFRuVC9lNEpycGRYTllYWlo1?=
 =?utf-8?B?czNjMjJGKzR5MFNRNmlCVmFJSk1jRTFJRHFYelF5OXZsNy93ODVEU1UwRnhn?=
 =?utf-8?B?QjFPQmRyTnVCeVl4dTdxYzQ2cW5vYm1VRWR1SlIzRk1zTFlmZU52SmNOMDhh?=
 =?utf-8?B?aFBFTURhUGQ1MDlqZDZSVWF0MEZaWWdic2xpZFFLNkl0QUhMZXduTm5OelVW?=
 =?utf-8?B?UFRGSi9PejZ5cmx2SGRhM3VFK082Q2g4TlgrZWgxc255bjRBMFZ1QThlM0sw?=
 =?utf-8?B?YXJVeThzUENRRG81MGQvVXF1bU5vRUVBcEN4KzBPdnVDTzJLZ3ByU25UKzcr?=
 =?utf-8?B?dHFMd0RscmtPaG1PWWtJZ3g0UmJnMmkrQnFTc2VKL0I0bjRLUnovNUJ6YUpn?=
 =?utf-8?B?YjZyb2tWLzhJUmJTcThlZkZnem9lQmV6NmZDdTdRdnRIanE4VlhkdGtjQ01p?=
 =?utf-8?B?WXdDZ1hVTzlOeVBNQm9ZOVZSUTRMRFJzY3pSVWVBY004OGpVWW1Ra0xpV2k1?=
 =?utf-8?B?NkF1d3hIcUFhWkdyWDdaTjBaQUNGV1NpQWM4ME1LL1ZBMjZJM0NEUDlTT2dM?=
 =?utf-8?B?YlgrOUkxUXFwZDhhZTN3NzFFRUVJVmwvcGhTbVl6VTY3a3lNZUxqVzJHb2Yv?=
 =?utf-8?B?YmZ3cjVKd3B3UTdhUkF5VFlZT1VmbjFsT3RNckh2VnMxZUtYaWVTSW1HOWtK?=
 =?utf-8?B?enUzNTFLV2ZFM1FwQUJWaCtJRUxRQzdqVGxFV2pQaXBWWWtHTlhCeFI1K0NT?=
 =?utf-8?B?V3MxQitmU0xEbUtnUTdLUndscHM1b0RvR2F6QTZ0MXU5a0lzQkp1a3oyWU1V?=
 =?utf-8?B?WGIvVTk3NWl3aDI3Wktzbk9JcVlQb0EraVFxMFdwemRqZ3MvcnFrZm1yUWRN?=
 =?utf-8?B?UGZKakxzNnJYak1yN2VNcHdtRnl2SU5UVkZuOXhmeno2RFZjdVNISThLaWts?=
 =?utf-8?B?Q0J5UW5hM1dzcFBSUDJ2NkVxaGlhTFVyOXJGQ0g4eUlYZjdrQXFzL2dZbXN5?=
 =?utf-8?B?T0Ircjd6QmFucHZLSkc4NlFRL1I1bHpTZm83L2krTVptaU4yMUlETzZhTmw3?=
 =?utf-8?B?eXI1TVExNDN6bEtPWjBycFk2bTZ1MXh2aWovYXdBMC9obzBNQW84bDV6RlFa?=
 =?utf-8?B?RW50anRnRFVWTGxNSmkzcHBERzFxVTJlZHR0L0VzUGRpVXgyNGhrYlJONGdJ?=
 =?utf-8?B?WnpuSnNYckE1ZzdYOUxCeHZxRnFiVXlpZFBXSUMyTVdOY1FjQmI2NW9SejBj?=
 =?utf-8?B?bldDWERKUi9MWXdGdDAzeUw4emE2V3FjdklMcURrQWxydzN4K1pSb0JBeFJN?=
 =?utf-8?B?UmdvelpLMFlsRHRlQkZwRFFBTUpSaTRINGQ3UXdWeFNsY3ZyZk40MXN2VWk5?=
 =?utf-8?B?cW0ydGNlaGZmYWcraldkbk8xdTB6TUJqQUpWaER0RVBTSzJmYUlucG9DTGto?=
 =?utf-8?B?VzFxcEJnQjdFellZWUd5bkF5bk1YempsRjN3ODdFTEFUSlByZWQ3UmZQcTNE?=
 =?utf-8?Q?pYH0bG2+wR08arRE8B?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 345d2414-cf16-4c92-732c-08def1a2eb95
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Aug 2026 21:05:17.4566
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: eFM3iVQk3BUJTZKA5I94XWwBcEB83owOnF4bp3XOOEbRpzMszk6j7fcUH8U9j1Xd
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB9735
X-Stat-Signature: uyzeegm46xqm7n7xm51skku5t6nm365g
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 284B220013
X-HE-Tag: 1785791125-90112
X-HE-Meta: U2FsdGVkX194+Rs3NfiprJRX0JP9Gplo92pCIJfjFQqmFkfRMvMsTlw70lSAP0eJUOGlU2AcqzEVE0LpVe1dUgXAIXqBJ/LpnJCvh7/yRZn5lp5KZfX0Bo7ysENZpkebF70PEmg6J+bnHFN4xrzQFTCMCcZezH46wlqlZMJjJBfULU7NHzC1eTaB5hJLY6AHmpMK1/0ny1j+YlG1h3h1wOjI5G8HWL2ERGZpAHObZeQORpQhc2U8srWrZYznnJnDLkaJwmZwR502gyjx7MZqJ/A1gI4EBolTkbyUOh/vCOuKZlaV9vj4P/r2g3kRgM9xXDDbnO5/o0T40MTdk/VUUbu/T97iwCQYNcwPMQWIw6+dySTMnzOZJ8TK14mlquhsbBeuUDJffeMc8r7N2LiEyahJWvRYccLjzi/O8184IFIq4aYaUWM3LO9eMnpQzlqYqLxcjE9Fp1DLU3wkAbeQfEMxunjxgKHmVo97tej8mBAoacHdGMNFWPZUs8qDezlCb7Shs1vnX6gFwCZDcRo8PGa4c3wQcG02dX/bPZIVEPuimjQ9UE8OHKjIkRI7elQXlppkK6+qmnVebmSGnNwpaIO2vVEUJjgnNfGm+VeJ0PtbuNdxEOKgDaNeAM2O9VEaQRBd14gq9I8yLzYkPcc/7g0Gv63/8oHovjn3MmN2srTXDEmxRDdNNra+o9CpzEWUk8lI/AtflqeVZfdMUxOCKLzo/Hly4YXBdQiRiIP9Ko1zGyXsZwQIw/gbZO8Aj+kQmdchRxC6ZeQG6ZUV0La7ejDmNkevRZ8rbwIcEHnc9JqY58FEWTRyFwUw9xJyMAJs4ASmfM/uWofAIyb4sgqQqj3QiXqbFNe9Kp1ER3SvyVhgdmzf+CG49TKhorLOzIIZ6HfG9rnzCMI1qJjwcDKezg+x++rXoc1LpPg8C5HhUzg1P3syZtn6XOxHfhOLXYkrgYZnYUWjtvKPsxI3PVs
 DQapC/j+
 g1sHxUsQUHL3UWUOXSDinOfe1gWQMgOMi+1BO1/k61gylawfHt9E0HtljeKb0YVaaVKyQ6sNz8L7ke2PEx5Ud5Hp4fnIjZPkAu9syiVqoM8wEz8VC2Gi27Ou+ngQqh58G+e3GgAlPzXhij7t25DwjgmDeMcuaDq0ljYauOYvCML7ZxJz1aX0sKF2DpjPAfcsQQQ97J/79kAetDlnDWdMDGlSzelsR7jakytsQOaY6+WtqRp1Tm62+E29jo+YGKgle5bzXZx0mou08diy8l1RV2qG+eERA2a6UzSt0pyxQc9cPACSQEBknH4k6c+Sejjvbn/OJgLEcr9rSwX1Wur9j9tynxcU92Qb+diBp6CiD+DIUM21g/pKcLy/h2hR2umwkoOdW+qx9w45/CfbWUk/ohdq4O2RPXk9AJMW/uT8+H2gGcw8vTSWgCLLy8u9Lt58zNNAdyI49RtG7pNFADn2H7K1sXxPl4xmjYlIwrjl4hTP3OeCPZ4iJhPYLMy+1nU+xZ+i1BuHc2iXKnEc10Q8X2LaYXXkMrJDzZcVFSsByu9ss/9fYaCXDQgF/Ttgt0ByWVGoaEGagpnRffnAbxxYk5Tx1WJVOAAf+6pyy8Et2M6a8tmQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon Aug 3, 2026 at 12:53 PM EDT, Johannes Weiner wrote:
> On Mon, Aug 03, 2026 at 11:34:35AM -0400, Zi Yan wrote:
>> On Mon Aug 3, 2026 at 11:04 AM EDT, Johannes Weiner wrote:
>> > On Fri, Jul 31, 2026 at 10:13:24PM -0400, Zi Yan wrote:
>> >> zsmalloc uses PG_private to indicate first zpdesc in the zspage chain=
.
>> >> Replace it with zpdesc->zspage->first_zpdesc =3D=3D zpdesc. The check=
,
>> >> is_first_zpdesc(), is only used in VM_BUG_ON(), so performance impact
>> >> should be negligible.
>> >>=20
>> >> It prepares for a future commit that remove PG_private.
>> >>=20
>> >> No functional change intended.
>> >>=20
>> >> Assisted-by: Claude:claude-opus-4-8
>> >> Assisted-by: Codex:gpt-5
>> >> Signed-off-by: Zi Yan <ziy@nvidia.com>
>> >> To: Minchan Kim <minchan@kernel.org>
>> >> To: Sergey Senozhatsky <senozhatsky@chromium.org>
>> >> To: Andrew Morton <akpm@linux-foundation.org>
>> >> Cc: linux-mm@kvack.org
>> >> Cc: linux-kernel@vger.kernel.org
>> >> ---
>> >>  mm/zpdesc.h   |  2 +-
>> >>  mm/zsmalloc.c | 15 +++------------
>> >>  2 files changed, 4 insertions(+), 13 deletions(-)
>> >>=20
>> >> diff --git a/mm/zpdesc.h b/mm/zpdesc.h
>> >> index b8258dc78548d..4fd81c2e80769 100644
>> >> --- a/mm/zpdesc.h
>> >> +++ b/mm/zpdesc.h
>> >> @@ -26,8 +26,8 @@
>> >>   * with memcg_data.
>> >>   *
>> >>   * Page flags used:
>> >> - * * PG_private identifies the first component page.
>> >>   * * PG_locked is used by page migration code.
>> >> + * The first component page has zpdesc->zspage->first_zpdesc =3D=3D =
zpdesc
>> >>   */
>> >>  struct zpdesc {
>> >>  	unsigned long flags;
>> >> diff --git a/mm/zsmalloc.c b/mm/zsmalloc.c
>> >> index 8204b76f78308..e8ef227624efa 100644
>> >> --- a/mm/zsmalloc.c
>> >> +++ b/mm/zsmalloc.c
>> >> @@ -290,11 +290,6 @@ struct zs_pool {
>> >>  	atomic_t compaction_in_progress;
>> >>  };
>> >> =20
>> >> -static inline void zpdesc_set_first(struct zpdesc *zpdesc)
>> >> -{
>> >> -	SetPagePrivate(zpdesc_page(zpdesc));
>> >> -}
>> >> -
>> >>  static inline void zpdesc_inc_zone_page_state(struct zpdesc *zpdesc)
>> >>  {
>> >>  	inc_zone_page_state(zpdesc_page(zpdesc), NR_ZSPAGES);
>> >> @@ -478,7 +473,7 @@ static void record_obj(unsigned long handle, unsi=
gned long obj)
>> >> =20
>> >>  static inline bool __maybe_unused is_first_zpdesc(struct zpdesc *zpd=
esc)
>> >>  {
>> >> -	return PagePrivate(zpdesc_page(zpdesc));
>> >> +	return zpdesc->zspage->first_zpdesc =3D=3D zpdesc;
>> >>  }
>> >
>> > There are two checks: get_first_zpdesc() and obj_allocated().
>> >
>> > static struct zpdesc *get_first_zpdesc(struct zspage *zspage)
>> > {
>> > 	struct zpdesc *first_zpdesc =3D zspage->first_zpdesc;
>> >
>> > 	VM_BUG_ON_PAGE(is_first_zpdesc(first_zpdesc), zpdesc_page(first_zpdes=
c));
>> > 	return first_zpdesc;
>> > }
>> >
>> > If you expand the helper, this seems kind of pointless now:
>> >
>> > 	first_zpdesc =3D zspage->first_zpdesc;
>> > 	VM_BUG_ON_PAGE(first_zpdesc !=3D first_zpdesc->zspage->first_zpdesc, =
...);
>> >
>> > Mayyybe it could make sense to assert first_zpdesc->zspage !=3D
>> > zspage. But that's a separate issue that the previous check didn't
>>=20
>> Usama has the same comment about this.
>>=20
>> > necessarily catch. And might not be worth checking, considering how
>> > trivial create_page_chain() is.
>> >
>> > In any case, it doesn't seem worth keeping the check as-is.
>> >
>> > And with one caller remaining, you could delete the helper and inline
>> > that expression into the check in obj_allocated(). What it does now is
>> > self-explanatory; it doesn't need another name like that PagePrivate()
>> > check before did.
>>=20
>> How about the version below? Basically, I made is_first_zpdesc() more
>> straightforward for backpointer checking and first_zpdesc checking.
>>=20
>> 1. get_first_zpdesc() needs the backpointer check; the first_zpdesc chec=
k is
>> meaningless, since the assignment is done above.
>>=20
>> 2. obj_allocated() needs the first_zpdesc check; the backpointer check
>> is meaningless, since the zspage is from get_zspage().
>
> Personally, I'm not a fan of "super predicates" where individual
> conditions are only useful for only some of the callsites. They tend
> to become obstacles to understanding the code and lead to subtle bugs
> when developers misunderstand context requirements.
>
> IMO it's better to just precisely express what each callsite
> needs. Only factor a common helper if it's actually the same.

OK. The below is what I come up with like you suggested. I realize that
there are actually two things to check for a zspage chain:

1. all zpdescs point to the same zspage,
2. for a ZsHugePage, handle is only in the first zpdesc.

get_first_zpdesc() checks 1 and obj_allocated() checks 2. So I added
comments to them.


From 4567d7d9cc8c84d5c05de92ee8905f4c5e5cf67f Mon Sep 17 00:00:00 2001
From: Zi Yan <ziy@nvidia.com>
Date: Tue, 28 Jul 2026 22:41:23 -0400
Subject: [PATCH] mm/zsmalloc: replace PG_private with pointer comparison

zsmalloc uses PG_private to indicate first zpdesc in a zspage chain. It is
equivalent to check zpdesc =3D=3D zspage->first_zpdesc. Replace
is_first_zpdesc() with zpdesc =3D=3D zspage->first_zpdesc in obj_allocated(=
).

For get_first_zpdesc(), first_zpdesc is from zspage->first_zpdesc, so
replace is_first_zpdesc() with first_zpdesc->zspage =3D=3D zspage, the seco=
nd
requirement of a zspage chain, where all zpdescs point to the same zspage.

is_first_zpdesc(), is only used in VM_BUG_ON_PAGE(), so performance impact
should be negligible. While at it, change VM_BUG_ON() to
VM_WARN_ON_ONCE_PAGE().

It prepares for a future commit that remove PG_private.

No functional change intended.

Assisted-by: Claude:claude-opus-4-8
Assisted-by: Codex:gpt-5
Signed-off-by: Zi Yan <ziy@nvidia.com>
To: Minchan Kim <minchan@kernel.org>
To: Sergey Senozhatsky <senozhatsky@chromium.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org
---
 mm/zpdesc.h   |  2 +-
 mm/zsmalloc.c | 24 ++++++------------------
 2 files changed, 7 insertions(+), 19 deletions(-)

diff --git a/mm/zpdesc.h b/mm/zpdesc.h
index b8258dc78548d..4fd81c2e80769 100644
--- a/mm/zpdesc.h
+++ b/mm/zpdesc.h
@@ -26,8 +26,8 @@
  * with memcg_data.
  *
  * Page flags used:
- * * PG_private identifies the first component page.
  * * PG_locked is used by page migration code.
+ * The first component page has zpdesc->zspage->first_zpdesc =3D=3D zpdesc
  */
 struct zpdesc {
 	unsigned long flags;
diff --git a/mm/zsmalloc.c b/mm/zsmalloc.c
index 8204b76f78308..b87679757e7b1 100644
--- a/mm/zsmalloc.c
+++ b/mm/zsmalloc.c
@@ -290,11 +290,6 @@ struct zs_pool {
 	atomic_t compaction_in_progress;
 };
=20
-static inline void zpdesc_set_first(struct zpdesc *zpdesc)
-{
-	SetPagePrivate(zpdesc_page(zpdesc));
-}
-
 static inline void zpdesc_inc_zone_page_state(struct zpdesc *zpdesc)
 {
 	inc_zone_page_state(zpdesc_page(zpdesc), NR_ZSPAGES);
@@ -476,11 +471,6 @@ static void record_obj(unsigned long handle, unsigned =
long obj)
 	WRITE_ONCE(*(unsigned long *)handle, obj);
 }
=20
-static inline bool __maybe_unused is_first_zpdesc(struct zpdesc *zpdesc)
-{
-	return PagePrivate(zpdesc_page(zpdesc));
-}
-
 /* Protected by class->lock */
 static inline int get_zspage_inuse(struct zspage *zspage)
 {
@@ -496,7 +486,8 @@ static struct zpdesc *get_first_zpdesc(struct zspage *z=
spage)
 {
 	struct zpdesc *first_zpdesc =3D zspage->first_zpdesc;
=20
-	VM_BUG_ON_PAGE(!is_first_zpdesc(first_zpdesc), zpdesc_page(first_zpdesc))=
;
+	/* the first zpdesc must point back to this zspage */
+	VM_WARN_ON_ONCE_PAGE(first_zpdesc->zspage !=3D zspage, zpdesc_page(first_=
zpdesc));
 	return first_zpdesc;
 }
=20
@@ -833,7 +824,8 @@ static inline bool obj_allocated(struct zpdesc *zpdesc,=
 void *obj,
 	struct zspage *zspage =3D get_zspage(zpdesc);
=20
 	if (unlikely(ZsHugePage(zspage))) {
-		VM_BUG_ON_PAGE(!is_first_zpdesc(zpdesc), zpdesc_page(zpdesc));
+		/* only first zpdesc holds the handle */
+		VM_WARN_ON_ONCE_PAGE(zspage->first_zpdesc !=3D zpdesc, zpdesc_page(zpdes=
c));
 		handle =3D zpdesc->handle;
 	} else
 		handle =3D *(unsigned long *)obj;
@@ -848,9 +840,6 @@ static inline bool obj_allocated(struct zpdesc *zpdesc,=
 void *obj,
=20
 static void reset_zpdesc(struct zpdesc *zpdesc)
 {
-	struct page *page =3D zpdesc_page(zpdesc);
-
-	ClearPagePrivate(page);
 	zpdesc->zspage =3D NULL;
 	zpdesc->next =3D NULL;
 	/* PageZsmalloc is sticky until the page is freed to the buddy. */
@@ -1001,8 +990,8 @@ static void create_page_chain(struct size_class *class=
, struct zspage *zspage,
 	 * 1. all pages are linked together using zpdesc->next
 	 * 2. each sub-page point to zspage using zpdesc->zspage
 	 *
-	 * we set PG_private to identify the first zpdesc (i.e. no other zpdesc
-	 * has this flag set).
+	 * The first zpdesc has its zspage->first_zpdesc set to itself, no
+	 * other zpdesc has this set.
 	 */
 	for (i =3D 0; i < nr_zpdescs; i++) {
 		zpdesc =3D zpdescs[i];
@@ -1010,7 +999,6 @@ static void create_page_chain(struct size_class *class=
, struct zspage *zspage,
 		zpdesc->next =3D NULL;
 		if (i =3D=3D 0) {
 			zspage->first_zpdesc =3D zpdesc;
-			zpdesc_set_first(zpdesc);
 			if (unlikely(class->objs_per_zspage =3D=3D 1 &&
 					class->pages_per_zspage =3D=3D 1))
 				SetZsHugePage(zspage);
--=20
2.53.0




--=20
Best Regards,
Yan, Zi


