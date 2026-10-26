Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 948D2606A31E
	for <linux-mm@archiver.kernel.org>; Mon, 26 Oct 2026 23:16:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=nGLRYP9D
Received: by kanga.kvack.org (Postfix)
	id B234A6B05B0; Mon, 26 Oct 2026 19:16:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AD4596B05B1; Mon, 26 Oct 2026 19:16:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 99B8E6B05B2; Mon, 26 Oct 2026 19:16:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 6DF8E6B05B0
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 19:16:33 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id E40CF120923
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 23:16:32 +0000 (UTC)
X-FDA: 85366338624.28.3DE0537
Received: from CO1PR03CU002.outbound.protection.outlook.com (mail-westus2azon11010050.outbound.protection.outlook.com [52.101.46.50])
	by imf08.hostedemail.com (Postfix) with ESMTP id 6561816000D
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 23:16:29 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=nGLRYP9D;
	spf=pass (imf08.hostedemail.com: domain of ziy@nvidia.com designates 52.101.46.50 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1793056589;
	b=mb7TbkIhcP0AjtVKXmKUQYwlib6BxM96gBCOi7Wye7pS72TuLu9szMdykrSVOEfMVuQhjJ
	ooYTz86yVBYtuB/vOhUtTtHD9J5Hy2UScsfkyNO6pkXWKwqL8tHIrKb5mnRtDWXJTFQNNN
	H59Mi2mXoJzFATFSEGFcZ7+X+L6jpGg=
ARC-Authentication-Results: i=2;
	imf08.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=nGLRYP9D;
	spf=pass (imf08.hostedemail.com: domain of ziy@nvidia.com designates 52.101.46.50 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793056589;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=z2Kp0rk3FZjtZ2QW0QO6SQUUk/rfrVULOdm7Sav3EiA=;
	b=R30QWVyVhpMI3u45tiyRy/ZHWLS7MGfpVmJOHkgS+afPLHjv5uJtt4sqhaooIXCbYxNSEi
	HqgOKwB7tQB5n5kBI4egVAyndPvu7ZenjJTwOUVwcozDSGpf+qZv/TfaWhcrwxJFA7F1nT
	XFMWdudLMytyXdNz3Dj3mj+NfXOPu9E=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=nKw2rPCdn8tSHgk7AvXHKz8PPuIZPUGPmOOgtcdNnediWpkXor9CrT32/7HkTC+D1nf3Q0p4pEjLt2DATt5CHJJX1gqcFDa/nUtYcZoVB0iOkxzrgyt5dIppTmGY16RTmEFsXd2glSKo2BMmtbdrdX9u2Vn3wuuCD/aNitGXsUGnWgt6RPdHtbbclwDSxd6tuxW95rtmP/HZ0kObou+mdxRyq9cfrpIsTcnOBmjpG9x583Av5TK5urdeNcpXGfUFlCEBA/68h2zixsRbdQ0KcL9KjTeF0MlzyFueyp0UzQGg567afTqby3qTBxQcIVl7+suQ3gWApTMoAcq1YGz7uw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=z2Kp0rk3FZjtZ2QW0QO6SQUUk/rfrVULOdm7Sav3EiA=;
 b=jFQVWMdfnwcBjmzhPfPGa0lpCxw6q+P1VjXyHg7oLxaeQrDn/Dgwrz3/HSa9D3G5pAp0lX1DGQuIh88kgz9LNizwyOLlZsMaYZSC3rjgS+WkJoaqij3RW6K/tzq+nTHTKf0IpwVaJj7PpTxBg4T/jKI+Za5UK2I1NJ8zp8JZ5qSqKHXhTP9w++gyqFgV6pxSNF30YNYnYPyoTbHC2NoMQGBtJOdDMfw8EHhkBfqtsZmXgrXWeHdQJ0fz5+LWTtQF4hJxlpcxhbx/7Y9Zs93y6JDX8ne3KYNmMpzQX3HZmxYmrgvQsn9fBPX1LDAlc33Rzo0k77cW2X+DwTqHhYCTOw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=z2Kp0rk3FZjtZ2QW0QO6SQUUk/rfrVULOdm7Sav3EiA=;
 b=nGLRYP9Dtnhw9NUCM5LnxAyr1uQwa8oQti1Phs0um4t7OXTtAww/VT9iLOz+BOVDLMlEFr9kDp2tyDtMhDRFc+8K6m08hZdUQeQ0BrlD5LrS/eRVse4tynEUEXGxrBsq2DBYCoCnYy+Lt3ZJc+XQ5vCrOgQOL0q5WjjmZwKeOqI4qrc4zgGPqnvZF+suYHqjRUo6my0pWt21UMb0MXunZF6KTAOhttjXznO0vj2Oor5H7kwbl+j39jGfV+Bb5iFNqC2icbzBaLugZsmC1cRMhombTDPgRFzyu4OAFmxkMWxKUzzwDl5A0bAtHpAEtPZKxVbavQCncM6fHIsXV4nKPQ==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by IA1PR12MB8224.namprd12.prod.outlook.com (2603:10b6:208:3f9::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.546.22; Mon, 26 Oct
 2026 23:16:24 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%6]) with mapi id 15.21.0546.021; Mon, 26 Oct 2026
 23:16:24 +0000
From: Zi Yan <ziy@nvidia.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Zhang Yi <yi.zhang@huaweicloud.com>
Cc: Gregory Price <gourry@gourry.net>, Joshua Hahn <joshua.hahnjy@gmail.com>,
 Rakie Kim <rakie.kim@sk.com>, Ying Huang <ying.huang@linux.alibaba.com>,
 Johannes Weiner <hannes@cmpxchg.org>,
 Vladimir Davydov <vdavydov.dev@gmail.com>, Michal Hocko <mhocko@suse.com>,
 Hugh Dickins <hughd@google.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
 Lukas Czerner <lczerner@redhat.com>, Carlos Maiolino <cmaiolino@redhat.com>,
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
 Daniel Verkamp <dverkamp@chromium.org>, Jeff Xu <jeffxu@google.com>,
 Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>,
 David Stevens <stevensd@chromium.org>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 William Kucharski <william.kucharski@oracle.com>,
 Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>,
 Nhat Pham <nphamcs@gmail.com>, Miaohe Lin <linmiaohe@huawei.com>,
 Naoya Horiguchi <nao.horiguchi@gmail.com>, <linux-mm@kvack.org>,
 <linux-kernel@vger.kernel.org>, Chris Mason <mason@kernel.org>,
 <stable@vger.kernel.org>
Subject: Re: [PATCH 07/16] mm/shmem: avoid moving the truncation start
 backwards
Date: Mon, 26 Oct 2026 19:16:22 -0400
X-Mailer: MailMate (3.0r7032)
Message-ID: <0D22B04E-5730-4D3A-ADA6-9F1AF94F06AA@nvidia.com>
In-Reply-To: <B1241F56-8000-411D-A137-24596E599C85@nvidia.com>
References: <20261026-fixes_shmem-v1-0-703206d5fa0c@kernel.org>
 <20261026-fixes_shmem-v1-7-703206d5fa0c@kernel.org>
 <2E377C76-D62C-4A2A-94E3-ABC40C6FCDD2@nvidia.com>
 <583728ed-dc63-4685-9ac5-5a980db55973@kernel.org>
 <B1241F56-8000-411D-A137-24596E599C85@nvidia.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-MS-Reactions: disallow
X-ClientProxiedBy: BLAPR05CA0009.namprd05.prod.outlook.com
 (2603:10b6:208:36e::16) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|IA1PR12MB8224:EE_
X-MS-Office365-Filtering-Correlation-Id: 5a6d59e2-1854-4549-cfae-08df33b7277b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|376014|7416014|366016|1800799024|261026140227099003|4143699003|11063799006|56012099006|261026121527099003|261021123027099003|261021121427099003|261022075727099003|261009223027099003|261022105027099003|10067099003|22082099003|18002099003|6133799003;
X-Microsoft-Antispam-Message-Info:
	1/01wpAmGwwNB1EGpM45h0r7rLLQ1iROiU616VRI/gvPYC+Xd2uYW2WknvGkrnIH7st6KRChgK/sTr/xMi7j/JW7ejPEq9WOTf4TZmpLuwRNSpXms25qs54XhojP8h97zG39z31dYDHPSwfsW72HqpptgC575Sgc2kH9JA8khij6mTGqYLuAu6JZnywoakInIRdCSDGT9fp6JpuijRe8nQhps2MUiNEfwZrOp8m1V34MGJ+QAchenyw86e7vmQHbvH5YUjojGoMRtE4ofcsrs7tdWxnwQBTbOnV/1mTviTavpAnDLyJpzgoSGvh553LLeTEC1TcCWGKdolZ4Mz96VtOhyCWn2x0671szX/+zaYsudTdOs+NsspRocXVxumprw+OclTKyFx31Yf/WaiVJndnjMALODSNtgEZK2Saoz78E2Ka8aDEW7oqVuaipkfRXIQ+VrIb6lsg3DbM+hSLP27wwDQ1k9YZWfK4WR5Rn/ZdN3TW1caAoc8fWrnz/uJe4GS8C9vjE39JoV7mJkj6ZybjKOsYRjcSyNa9XCUic6i3AwhIDmTZ+/idqd8/4t/QJUgZh6HxbonwawdRN/dYCbEYuLw6BZoYppngkW/Yv5zuX2U4jfuG9D/8QvHmtlrQQicWLuuo2pD8h6AmI/neqevdE0FauWsjZHXCVAGMnus4=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(376014)(7416014)(366016)(1800799024)(261026140227099003)(4143699003)(11063799006)(56012099006)(261026121527099003)(261021123027099003)(261021121427099003)(261022075727099003)(261009223027099003)(261022105027099003)(10067099003)(22082099003)(18002099003)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?V1ZmcEM0NGYrQUluUTNsWE0rMkRiVjEwOWFiM3pSTFJCVSthbWJtMW91MXpX?=
 =?utf-8?B?Kyt5aTZMRnkxaFJJa01hZ0tXWnZId0JMdVFNdUZXV3ArL1h5UjFwemNvMnkx?=
 =?utf-8?B?dXdRNXVodDdBUUpJTG44Ky9McmlWMVRua0ZJSVk5RHIrZFFlNXBOZHpOYW9X?=
 =?utf-8?B?dmFjdnNSbmhyOGFRR20xVmcxVHd3czRDUnFjN0FhV0dyUTk1amFIRHlCTGVS?=
 =?utf-8?B?M0ZyTXZwazdxanQycHJZbUxkdUtjTyt1T2RNVTg4UjQrUFdLZStnL1JEV1NJ?=
 =?utf-8?B?SERrUkFic1lxbCt4OC9Ga2grb3VvNjlveFQyUW5SVjJITS8rSXVZRjd5WTVa?=
 =?utf-8?B?cVA5MUpmZzhwajVEek1JQm56TlNxOHF5LzVrQmtUSkpTejRTZ3QyUW9LZUU4?=
 =?utf-8?B?Wk1reklRVVIvT3hhRlVNVkcwamtubXJoOEVlZEVvR3hQMlM4WlAxemNrQWNU?=
 =?utf-8?B?OHBsYzB3ejM2V3hHZmVpaXV6WG9YWkJwbFB1TkZGdVpNbzA3REJlVnI5SVFx?=
 =?utf-8?B?UHZwL21nbHhDejFXdFlBV09jbUhNN3pkUFpERlFGVWdiNXMzRWZVNkpOMGZL?=
 =?utf-8?B?YzB3WFM5OSt1T0MraDR2ZXVyVCtRckhyaGtrbDVPZmJPV0RVd3JZZDQ5Umd0?=
 =?utf-8?B?VmZSTlU5MDdMTDM5bXFyYkR0UjFoMkMvNTRIc29Fb01MTHppMlAza1h3a3hU?=
 =?utf-8?B?dUhQYTdlU2t4djF4ZzNRNzRmT05GbkhpS3hmeHphblNJN0xidmo3Qk5LTUR3?=
 =?utf-8?B?Tk1UWnBqRnJNOTVCUGtrWnF0U0tneFVwMmpNNkU4RWJwUkhGc3lnSnBWRWpU?=
 =?utf-8?B?b29ibXVnZWZjbjBUdUNsUUd0NzJSWk5CLzJGTUMwMm5mNWFOcm9MK01ncVlx?=
 =?utf-8?B?MVJaWGpMUGVHQmlCVU5jQU4vNVRyYysyK3d0UmZwTUJRSWljWEt0SFFVaHpI?=
 =?utf-8?B?RXk1Szk5NWl4d0cyUTFOVTlIakRsQTlTV092L1phR01qWklZYk1YTVRkQ1A4?=
 =?utf-8?B?MjFycEhQMlRZdk5tNy9mVStYcUxCUEFoNDdqRkppcUpZemFDL0NPbzQrZXR1?=
 =?utf-8?B?T3paN2ljM2ROZXRpd1RKbnU4QkwrUUtTNjlqSjVmZTdPTnRhdFhQeVJmS0lK?=
 =?utf-8?B?eEdRN0h1SWxjazJ2djg0RitwNjBRREdDNTRhbU5VTXBjY040T3NUT0xWVWM0?=
 =?utf-8?B?cy9wdUN4cFEweFJxZTZtaXFJQ0dZM2dCTS9QSm1xd3BVTEdBbksxOWducXBi?=
 =?utf-8?B?M0MvaU9aRXE4OXkvZnZCd3ROU0VOSUFsOGRDZ01naXFGVjNFSzdoSUl0NVA3?=
 =?utf-8?B?WENIak80bHRCTWxFbWZDQmhZcmVuZlljSjRscGQ1dDJleEU4TVhXcWhQRFFo?=
 =?utf-8?B?V28wY0Q0azExUjFXYUpERmxhaU5zQ3hsOTdQOUZ1cFBpQkpoS0EvREdPbkov?=
 =?utf-8?B?YmorbXFBWHAvRHRkOXplb3NQS0lXZHA2a3A1Y01EYnJVQTZteVp0S1J0ZmVM?=
 =?utf-8?B?K0pzSUxwSnoyYUN2R2JydmxiS2JtSEdTVFpMQ0E4Tk4zMXk2bVJYaVYwUWdR?=
 =?utf-8?B?cndVWUFkbUNmRFE5Sm8yTHFRVDNEYXNyaldMM3B3K2hydFZHQ2dKaXh2bWc4?=
 =?utf-8?B?ZUNKajJHVklLelFNcmJKR0xIcWpTZlhkd1JIeE5nZkpqWHhrWHZMQ3dqVXl1?=
 =?utf-8?B?UGw2VkhxVG5VSGJTRUNKb1VTVlBhYjQ2MjQyNWtYZW9VNEVxSDNTbTlHOUFF?=
 =?utf-8?B?c0NTRkdGNGR2M0hzcWZPUTYxbnpUaEtkOFZ1ZDZzelhlU0VHMHVsVlFQVVdL?=
 =?utf-8?B?NzUvelFYOHYrU1NyS2YySzJFbUMxZjdiTGVrcThkRG0weTFjYUExdFZrdEdQ?=
 =?utf-8?B?Z0FuRjd3QzJXdk1XNjI1UWEzMTRRNjYzTnQ3WWlZVjZUb0d4NHZvNllPVzJl?=
 =?utf-8?B?b2pZOGowamJXd04rSDVUM1AvTFA0cE5ERnZqbWloT3JCSFRqd0JzVGJKNXpG?=
 =?utf-8?B?SU9vM3RMVXRObXgrL2h0MjYyd3JhaFBBM3htS256MUJLZkMyTGJPWVVVb25R?=
 =?utf-8?B?cklvY1Q2RnA5ek9sYlhGTEQyeWV6QW53ZDlzZ0NHY1ZwT1JLZGJRa3hhL09y?=
 =?utf-8?B?L3VnNUFpenBKUDBrOEsyTGNzMzlsSnJtMndPZVhKOUN3TkNVdDhBSHdrUlJ0?=
 =?utf-8?B?MXU0VTE0TXovMmxQTHFRVmlpWDd2UTg3WVl4MVY0ZnJRWWluNkNDdDRRdG9K?=
 =?utf-8?B?NzJFNG9PYnM3WndERmduRzBiTVk0aEd3ZVZNMVh4dU9EUXZtd2RXL0doS0ta?=
 =?utf-8?B?bSt2TEFnTno3OUlRMU0wUzhMSHhRYjRpYi9hbXRCbWFrSHVjRjFBUT09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5a6d59e2-1854-4549-cfae-08df33b7277b
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Oct 2026 23:16:24.5691
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: i3tKyEQJlivK2CO4G3q9Xby60WUgabXPdqZN3M4dgmi2+K8+bgJ6xEWw0+aUi1Ch
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB8224
X-Rspam-User: 
X-Rspamd-Queue-Id: 6561816000D
X-Stat-Signature: g1sjh98cf4u617n8gyfrmeadaqdejim4
X-Rspamd-Server: rspam01
X-Spam-Status: No, score=-16.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793056589-810587
X-HE-Meta: U2FsdGVkX19w12CvqcXj5yCPuJrbleOqhB9zXki9aEuxV/Wfrs+8lXfALFNFoYVBtlSI3kV+golfMXYsDBtjc6b1QY/4hZu6NiRReUxUs5zRLqCC1C3d39Z06jkKrPP4iDXkH1xuInH3AZJuRhWY0ocLThTRmig3MN0VZrEuCXs+xH3Ya28mpm2x52GLLuAUgC2IL/MVZsidEpE8M5/ChNsk0NCbiwH4ZI9Qqv5rSxmSNI9b6O8zrU8deI/Mt6doIOm4viV64SX2GqO5f/WwxSnK5Yx3hCRKjTN5//W+K5QcZsAew47LDyj4zyZA1GN8sWLE23h3+NJ9u7EmbKzQb6liENzQF8PGfsV//UMmQ8fYE0rQY6tcVZMM5/jSKfNMzs4kxk/Qn+xhiX0GLPm3M6EhG57RX0XFLsiM0ZcWopHyegp4RmTsv2JllMNfD77eO7+U/qOFTzoyT4ufeRR5e1aMK0cVruUr0OVav3nnYF0eaQXb/J5MgebsvYJJDZda7mMFVD+7xp7k9aeqip1uDqo61cSZ/N/TEFI6ySH8gQtfVPTmc5ddcqQxvjst+RTwPjdwpkmNkQXHTEq3wlcNgt7MXNMC0TVxQaR5l6H0mOM84xRi/0S75lV0YSMWU6aVlcpieIMDXDpsXCLiaZnJpVJnfjfh82Wz0a5TDRB1BbxzJOGdcWtTVNwaqXUNwX+xM/CKQgeWaVXb/HhGGpasvZnEmnaucZ+oNinZbhfuyCf914LCbMmBcct97jbpqL2Gkz9Yo5Ooltz/H1yYZlsrqTMJ0T0SbAAg0cjWSj/+0vahYG9e+ufGS0FP3uUCmsw0LiNSK6xv75ru2T/1gJ+yIJJv5xzHJ8amClewE50VrvbtMUikLIKSA2m91C/Vl0ZxgIORNtO/0qXBCFibJ9LGnJ9FVVIHjkdcePMj8IeDBMvd5Jdhnfh0/omhoN0ia92Iln8WCrHzFZKBfZIyNQ1
 lZGK6HYy
 EcHuLtzMSdq8vZK6iXkcU8lAzK7Z8iZzlY1RbsTppEh+uiEnkKrpgAWRep7KRj7z5YDGarw/stzjwRVEhb2B+IwGYjGyRl1pCaaIi9Y4nXTZWZn0uOw5plDVebqOIjNy3dh3pfImYNee/ORnmDobXgHdFMpKp+bh1ZPNFyDgG+9TiW6wi/KPgo6yLMx7l0lBY3rwBfX7dEEjHCjltE91lonRfTsT5qHOD7gL6k7V2IpHN64ZNSUx+uQE0IoiKA5zlD16A6ba7avZjjJyOSZeV/awEIHuQFRnLSorUfXPTY/6TCV2bnU6V4LmjD7986xhDfJyudirov4Of9ygL4DwjZO+NBozlWTAg12Poc2eiXs1HVZnwx99BKQv/RGhW3WUBIPJ8bkV4nTyWMHLuxCaQ1zw46eEZ+Un6eV14pkvcVD/yOdLGt2kywbK2URk4d8rW0bI5qurgyQECpY+KoQIIQ5sFWExwFaJqCd9cNXujKIfTtzoYmnqJDdFBPA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 26 Oct 2026, at 18:39, Zi Yan wrote:

> On 26 Oct 2026, at 17:13, David Hildenbrand (Arm) wrote:
>
>> On 10/26/26 20:21, Zi Yan wrote:
>>> On 26 Oct 2026, at 5:40, David Hildenbrand (Arm) wrote:
>>>
>>>> From: Chris Mason <mason@kernel.org>
>>>>
>>>> A nonuniform folio split can fail with -ENOMEM after splitting off som=
e
>>>> smaller folios. shmem_undo_range() then sets start to the end of the
>>>> original folio, which may now lie before the truncation boundary.
>>>>
>>>> The final scan can consequently discard data below the new EOF, or
>>>> keep retrying a large folio whose split point lies outside it.
>>>>
>>>> Keep start at least at its original value when skipping a folio after
>>>> a failed split. The part in the truncated range has already been zeroe=
d.
>>>>
>>>> Fix generated by an LLM and sent by Chris Mason in private.
>>>>
>>>> Fixes: 7460b470a131f ("mm/truncate: use folio_split() in truncate oper=
ation")
>>>> Cc: stable@vger.kernel.org
>>>> Signed-off-by: Chris Mason <mason@kernel.org>
>>>> [ david: split fixes, simplify descriptions, adjust comments ]
>>>> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
>>>> ---
>>>>  mm/shmem.c | 8 +++++++-
>>>>  1 file changed, 7 insertions(+), 1 deletion(-)
>>>>
>>>
>>> This is fixed by Zhang Yi=E2=80=99s truncate_inode_partial_folio() fix[=
1].
>>> I think the commit is ad27479793682 ("mm/truncate: fix data loss
>>> when splitting straddling large folios fails") in mm-stable but
>>> not upstream yet.
>>>
>>> [1] https://lore.kernel.org/all/20260928120833.3440834-4-yi.zhang@huawe=
icloud.com/
>>
>> How confident are we that it fixes the same issue?
>
> The issue here is that folio_next_index(folio) used in the mainline
> code can be an index lower than lstart and the fix is use max()
> to prevent start going backwards. (I wrote this to make sure
> I understand the issue correctly)
>
> Zhang Yi=E2=80=99s patch passes start into truncate_inode_parital_folio()=
,
> which has a new signature, and it is updated with the folio=E2=80=99s ind=
ex
> within the [lstart, lend] range at the beginning.
>
> So this patch fixes the issue at the caller and Zhang Yi=E2=80=99s patch
> fixes the issue inside truncate_inode_partial_folio().
>
>>
>> Does it also cover #8?
>
> No, patch 8 is still needed. I am checking it on how to rebase it
> on mm-stable.
>
> Patch 9, 10, 11 might need rebase on mm-stable too.
>
> Since these patches are on top of mainline instead of mm-stable,
> you will need to rebase them. IIRC, Zhang Yi=E2=80=99s patches are needed
> for ext4 + iomap buffered I/O conversion. Hmm, but Zhang Yi=E2=80=99s
> ext4 iomap patches has landed in mainline but its dependency
> is not. So we cannot drop Zhang Yi=E2=80=99s patches and ask for a
> resend. Adding Zhang Yi here.

To clarify the dependency, without Zhang Yi=E2=80=99s
truncate_inode_partial_folio() patchset, the ext4 + iomap changes
would cause data loss. We probably want to get Zhang Yi=E2=80=99s patches
in first to avoid that.

Patch 7 to 11 do not apply cleanly on top of mm-stable due to Zhang Yi=E2=
=80=99s
truncate fix, where

1. patch 7 can be dropped as I discussed above,
2. patch 8 needs a folio->mapping guard for the added statement,
3. patch 9-11 can be applied with fuzzy, but I need to look into
them about functionalities before fully trust what LLM says.

The rest of patches have no conflicts on mm-stable.


Best Regards,
Yan, Zi

