Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DEC55CDB479
	for <linux-mm@archiver.kernel.org>; Thu, 25 Jun 2026 12:35:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B92036B0088; Thu, 25 Jun 2026 08:35:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B1AF96B008A; Thu, 25 Jun 2026 08:35:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9BC156B0092; Thu, 25 Jun 2026 08:35:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 71AC56B0088
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 08:35:38 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id ED1C7120688
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 12:35:37 +0000 (UTC)
X-FDA: 84918381114.21.4DC1D88
Received: from CH4PR04CU002.outbound.protection.outlook.com (mail-northcentralusazon11013029.outbound.protection.outlook.com [40.107.201.29])
	by imf07.hostedemail.com (Postfix) with ESMTP id F14094000D
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 12:35:34 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=nNbm7JkY;
	spf=pass (imf07.hostedemail.com: domain of Christian.Koenig@amd.com designates 40.107.201.29 as permitted sender) smtp.mailfrom=Christian.Koenig@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1782390935;
	b=GT3g5xrp1RJL6MX3GAY7jF30+ENxWfy7uiZHBAx+fWpF9khSn78ftye1fBnVXc0G1bTviZ
	jL6BMr720np17HABZQPDSm/UP+ahAtxYXV1UUj9xAJcZ92yIy54Y6PhtB15fB32Q9d5CuB
	LCqhUEoIOSH2M/LCX5ET7W3qpLV/l4E=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782390935;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ryze3UjmA3E4Dv/DLNGkNECWugYc7/tlPN4w4pkO240=;
	b=gFFpdWSCM2hPGdSglg1H4v9+BypL03ra5LmVFa5a8jpLt15UTNNJiIxnFJ53a99NxOkvaW
	9BnWjNcyzHtMszO0MlDvPMguviFX0ITUSAnnC4qbBrG7gAsT8+d+r0XsqFlo5d54nMj8QR
	u+D4IC826qYhpNu4popUMyRLznzLu08=
ARC-Authentication-Results: i=2;
	imf07.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=nNbm7JkY;
	spf=pass (imf07.hostedemail.com: domain of Christian.Koenig@amd.com designates 40.107.201.29 as permitted sender) smtp.mailfrom=Christian.Koenig@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=sNzOmab42SNFNAhCcpoHd4grHtfysl2hb6niWcLUlMlN/Lr9TAtW8Wi1s5TSr5XkMZJdjjcE3+pkORcgoB80gQtw2ifF3yG4z+I/8q8c8P41dBIHE7ewxXVxzhdbPQ/apnZrhi+7ZOHwVS51/78wMnG7tZeagioXzGUyatNUlLImUPbi6BLwFPXZECFkBdK9hCoKLSjRmOJx6CfCSKVo3TM6Z/imSGMXAyICj2iHrggx4yKApPx8qUsnJmCNZmCGDv1Stgaeo0YD0y9e7Plih4d0eL6Y41+7gIxVz+ZmZBRawJTxCV3QQJNehggmX0A3jqyM+SUW0mjUQP45VunspQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ryze3UjmA3E4Dv/DLNGkNECWugYc7/tlPN4w4pkO240=;
 b=q9cjU0OPZr3/kPB1noVegSrPvSDFL0tzBPzpZfwo6CMTm2bzI4uvbwAVLhjAgnXnfdgI7RhiWRQ4qKv2c358kHrdXa+YAfxa8w9Z6gwd07Y2XB0FYT8tuh4qH0Lgz/795wsM1XI5t7BdH52nqx6cgWWy9aNIl81j2pwc+tSEd1gKxJfJecx66dmv+oRmhpMIwFTniAjPfnaTw/hXjJf8RW4x3VnCDuw1PO1xUKzApKmyeEALTvl4i866A87xdBNP2lOzK39JNVhUBGZ/04p6dgTc6Zlej7ZXLR8Ard69kLb5vfYyGanh+QNI6GHFdbGoot6EPKmLjImVpq4ckbEAjA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ryze3UjmA3E4Dv/DLNGkNECWugYc7/tlPN4w4pkO240=;
 b=nNbm7JkYAsqI7EFXPs/C5oXKsfM6YkDlztq7W1pO7CWy80/LQFkrm1039nDookc/lL+KucNIqIPxrOf98z/pscamFZxNCqL4tDeUdYJm3hza73bjO7C5dTcaCqbvhAnM3BsbfmniplzJD3Xwhl6avN6PtfrT5Q8Oc/iWr307AZM=
Received: from PH7PR12MB5685.namprd12.prod.outlook.com (2603:10b6:510:13c::22)
 by DS7PR12MB6167.namprd12.prod.outlook.com (2603:10b6:8:98::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.159.16; Thu, 25 Jun
 2026 12:35:30 +0000
Received: from PH7PR12MB5685.namprd12.prod.outlook.com
 ([fe80::ce69:cfae:774d:a65c]) by PH7PR12MB5685.namprd12.prod.outlook.com
 ([fe80::ce69:cfae:774d:a65c%5]) with mapi id 15.21.0139.018; Thu, 25 Jun 2026
 12:35:29 +0000
Message-ID: <8f68ce2f-c33d-49f5-a671-7a4ab2f4f3d3@amd.com>
Date: Thu, 25 Jun 2026 14:35:21 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/3] mm/mmu_notifier, drm/amdgpu: block THP for GPU user
 mappings
To: Yitao Jiang <jytscientist@hotmail.com>,
 Alex Deucher <alexander.deucher@amd.com>, David Airlie <airlied@gmail.com>,
 Simona Vetter <simona@ffwll.ch>, Felix Kuehling <Felix.Kuehling@amd.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>
Cc: Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R . Howlett" <liam@infradead.org>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Jann Horn <jannh@google.com>, amd-gfx@lists.freedesktop.org,
 dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org
References: <SY1PR01MB10596EB75463208A8E1EBBA0FC0EC2@SY1PR01MB10596.ausprd01.prod.outlook.com>
Content-Language: en-US
From: =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>
In-Reply-To: <SY1PR01MB10596EB75463208A8E1EBBA0FC0EC2@SY1PR01MB10596.ausprd01.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR4P281CA0311.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:f6::18) To PH7PR12MB5685.namprd12.prod.outlook.com
 (2603:10b6:510:13c::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH7PR12MB5685:EE_|DS7PR12MB6167:EE_
X-MS-Office365-Filtering-Correlation-Id: 95379ce4-7b81-47d7-ec87-08ded2b63db5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|376014|7416014|23010399003|1800799024|56012099006|11063799006|6133799003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	SL0a2kkuM10cSU4swVoNPm02nnNsKualirIAIwzlSsTeNyUfJMfGAkY3BnrAvbY5Lsdt4g0qsFtWZnNUt5G7u5lY/cuSn3D0RDrsWFduMneCo8hZPxA3THxUcg1RqmvRzGHDL/ovr2LMp06Q16wjldPp9sdYbgEu+yqWOg6oObOrTF4uxYkaebEqtCnYUes6PtA5SecqYOr/NBGhMpbx5AMekzpyMSbtGE2lWvsNTMeueJm9IGeCcAtj15aP2ZxYUmsEAel0KYwo/7P2v6mOmM7jndMPsC7NuSd/5fkf29A4/C5X1o+o90AW23hUbIxRrH2QdSVSaEJYjQVSTlFW63hYk/EommarR35JD09ASEWGdIiTJIwe3R2zS5N1IDo+fku0hJvjdsKsG1L/c+bdkQ9/jRzN6mE/cYyGgmXynqDNB10pRSbVTDpj9eY9Q3PWnUVPPldl541KgX9+Kxjri80+jnbrodz3naVbADx4wUqP/q+XRO8sPF2KmGUdUzZsnDgXMuzc+ec9suViftoWS0o25lxR9ofSfPA7Xn5SLcxjIWG+q14uq+NzBPZdOqpE/HO+BOI7Ln0gWQgwW2LcFYc22+LQ2Q5vS7Al7ka9+nH/rJtEFdYNfdHiLX9AgLbDo/DHBmKqM5Pz5NdtmAwY/dOP9EzYNy7U4SbtPvPEd1Q=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR12MB5685.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(23010399003)(1800799024)(56012099006)(11063799006)(6133799003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?c05UQ25ZNTllV3B4a1NhUUlmaDh1VTdaSEFwWmNWZVJXK0psOTVMQjBTRFlv?=
 =?utf-8?B?Wkk0WityM0xpV1V2QkoyWlFMaVRaRHlnUndGVGZDYWJPOUFxeEJSek40c3Vh?=
 =?utf-8?B?aXQ2Z2dkVW5IVVNvdGdaV2V0WkRQcnJxR2cyMjl0RXllNDVjNTlSSnZCUHp3?=
 =?utf-8?B?ZXg2eFpnKzlrUEZyZVNRL3pSVDdSdDlKQTRYaWEvMktLWk9ueGk3dXgwU3pB?=
 =?utf-8?B?WDMwdnI4U1B2bHpqT09heGltWkNPOHVtb0Jkbkx6dXJIc0tLTnVsVG41aktD?=
 =?utf-8?B?aENYUTZLdnBGaUtObWk3bFNxM1o4OW5tR1JQZlJFdDZQL0I2QThRUXZuaHVR?=
 =?utf-8?B?Z2ZHZk4wQ3h4Ri9XMnhMMURSNFlSeTlMYkdSbFcyYXZsUmdZSlgxdkVSakha?=
 =?utf-8?B?L1Z2dFY2aXhsejlwL3F1V0VKbXZIRjU4a0VNLzNtUXFuclJ2NTlhWVFMR0tX?=
 =?utf-8?B?Ty9McHR1OThzMDU4UHdrTVJkaXNWMC9KYU5qNDJSSjBVY1BZeDdjSGM5N0hs?=
 =?utf-8?B?NFBoR1YvbG9BOEVIaC9XVnNGbFZxaEd0aDhnTUdOMVlLVnVSSDdwMUprUjlr?=
 =?utf-8?B?MW1lb25jUGF2QjBMeis0QnQzL0ZzUDRXcHc0YUhOK0xWdWtGS1d2UnJDSG0r?=
 =?utf-8?B?VXQwOUE4dFNUcXhBQVh4UHRKaWpBTFNYR01ZSmZyMXhna2ZtbzhUOWhlLzNJ?=
 =?utf-8?B?Tzc2WWV6eHJRSjFpdDBxSFJYWmVtUFhHb0M3bjRRTjE1TkNOQUVzVVJ6MzQy?=
 =?utf-8?B?VkFVanVCVzcxWE83akhlRmY0SU9kUVBNWWRGR0xOMXI3QkJueEgzcFRSc2hw?=
 =?utf-8?B?Z1FJQno1c1NaQjlwN1krcjBXYU1TUjJjbG9FTjhjeDNabDQwb0F4bzNqcDMw?=
 =?utf-8?B?OXlzdTlBd2JWSERkaDFWRjJ4VzFaTXV1ZkUyRW9BWmFoQXAwUU5Wd2xCYjBy?=
 =?utf-8?B?dElrTjhyWDZHRkZUbkRrMVIwQWExZnhvM3R6RHdZemY1bVRsdmNoSGd3UHNq?=
 =?utf-8?B?RmdJSXFnL2lBUUpjWGh4SmVrWUc3aFBJVnJJKzFYblJZSEh1RkR4dnBNYUZw?=
 =?utf-8?B?T3QwQ2JCcCtQdm5vMTRKTmhZTFhtWHdvN0RTaFJ2WitBRXB4Tnd4TVFsZDdU?=
 =?utf-8?B?M1B1ZDZBVlloQnhHZ0F1OHpGd1lHS2pka3ZhdXdXakRWUk5uT3B1dUdLNm1D?=
 =?utf-8?B?S1JLYjZLaDFaYWU4R3RlWjV1ZS9MWFlDSzRQRCswZ1ErMnB1bmlnMjFHcUhY?=
 =?utf-8?B?aG1iRHRLM29BM0t3WG5ZSllpV0dKWXlLZWE5eStXNWZrM0YwNmU4YjVwbDE5?=
 =?utf-8?B?dThvRk52YVR5VmJTK1crRGZxdDJWU2s3QUROeno5ZTljNlBpZ3dVMmdrL0tO?=
 =?utf-8?B?YW9OSXpZTzJYN0dMek5pemlHRk9HTEZEbWs0SkdvTHZHKzNLa3NpUlVrWUpy?=
 =?utf-8?B?NC9uSGpFZjFHdDBKa2o0Uk0wcTRpWCtXcHRaWWIvZWd0WXNRZnBLcHRqc0pZ?=
 =?utf-8?B?dzlvQnZrZkpBTjdyYVZSbGVwYXhNMW9FaW94a0duclQ4ZUNkRXdtK2dDNHFw?=
 =?utf-8?B?dURoaDdYS0hNNkVZMTExakYrTHE3V3JWbHJEUVl3TWhoVXYyd3kwU2pJbHRy?=
 =?utf-8?B?UWNWRk1LSzYxYTJxYVVIeHo5emJMa0tUaDM5Z1dSdXB2RlgrRzhUb2RXRHZo?=
 =?utf-8?B?ZjltNS9GVnFFQkxjNTVWZDlvZ1ZoRG50eFBJdCt4MDFBWGxqMnQzWStubWlL?=
 =?utf-8?B?a2gwVTBJM0t1Tk5yR25KclAyR0NFbUlqSmxHclk4bllJRVVSVUR2aTJHWnAr?=
 =?utf-8?B?WUMrTE9zS3hKdkc0ekMycGwwVllabm9YVG5nemQ0cWtMYzNSbjVzTmEyME9Y?=
 =?utf-8?B?VHo3OVlveXhRcTFXajhJWTl0aXlQMG9YYzlNeGlodTZHTUFjUXh6TkUzZUt2?=
 =?utf-8?B?TS9EdmtLdVhJOG9hT2gyZGZxV0xtdE9TWW56SENySGFzb3d0c29hSlBwY0M2?=
 =?utf-8?B?dWp3SndSNVR6U0ErQ0xScnB3cFF1VWV1K2l0bnRkaHhpaFJncHZETHBRWFZn?=
 =?utf-8?B?ZU96NTBOdnpkbk9uS042RlJnQWNzYmgrSGlLalkycVhIVzJxN3BjUklkdmhH?=
 =?utf-8?B?S1BxSUdkM3BhejB1K3dRbFVUYkQxMGFzNkFOY2VnYkovcUR5azFacm9VbnIr?=
 =?utf-8?B?YmFvVGtRZEV3YmdJcENxeFMvL2x6WmZ5MFZrMDF6d01JYWtaZ0ZxdTllSlZF?=
 =?utf-8?B?OUVPc2hlcnhxZFNWQlk1VzVGRTFuVENiTkZvK0NpazJkZ2hRamRKMk04bTd4?=
 =?utf-8?Q?097WY517pY/VlYZ6QA?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 95379ce4-7b81-47d7-ec87-08ded2b63db5
X-MS-Exchange-CrossTenant-AuthSource: PH7PR12MB5685.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Jun 2026 12:35:29.6462
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vwvPDdUv+Jbb7nM/BsZECkFKpnEgY87W8hCPO6UoVM4J21JWelG36DkysioC7Ha9
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB6167
X-Stat-Signature: rnhryho1jtqumb5yt95pa4zffprd4ctz
X-Rspam-User: 
X-Rspamd-Queue-Id: F14094000D
X-Rspamd-Server: rspam02
X-HE-Tag: 1782390934-704793
X-HE-Meta: U2FsdGVkX18Fmxjbwi+U+acUmsKBxbe/HI/MiJ4Pgx2pa/bAOGq6kRFy5/gFt+suzOQTDHT8NeNjhskeBHPDUQh5816fXAXVpaybQc8gbxUnFyFEJMmUvYTb5+8TFE5bFEQKLuMoYlvkOy6uzo4tiiTsYb8qAgUBuWBRWuBQPcd83aY6N0YpJ0jrXvLJxoybWQxUq7wSqd2r7zemqkzh1Lp6lQNv1C2My1gZomly0JBL+ygtwtxzFMvagvMzwwleEBVRw2or+qJxYPGZth74Yqp0QY/1uaQY5VeSzqtQ43U+BvvsmkJGSlx1Rhi+/VdM3yj+yinPzENAx3CRbinZXJuYDsG0G7elphcfa1Ee3aK7ngjnLYwmVDQbaHcRCtYFmUnCD/r8g2wLS3IWLcLD2s7sqw0OWYUmxU/ZatfIlg+6RBUnjl4Eclc/jp6/GHa3xzKP2L8MsD+dwL3k3lEXaOErL96Zz1tYqJiOZ9U9VHN4fdbIPH5zkKl3pGJ4ynx3WeRrzqvFSm47h+Dlqifv/mKDCezSUJxiUE2uWr82pMr6axapJB/ohgISEjsxd4bTdEDdshdmX9B6dOABk+jdhdh1DLs7Vt2pI5BF5My8m0wJG23N0YxoShj0HmU2l2vvW+d6qe3D4rQi3ZE3F/EGh6AGmQhEJ79+BH8C7aZ+GoTmCw0yZHXEnZ2NtrMv9xejt2sgcrvnPsPWZOk3kc3FjPfg5P5pD6dl6/0ahDNdHaAgVnXA9hK1vN6W7gsKhowVa61s4j8zz6zLKbPRV9KXq6+PXYC5rh1NSQa3KPg50aq6NNfsjinxuHw/3zzobeL/DC6VChgirvwQA5CMMNsHSKg9WwlPuVRaHzGGaCNLXvq8wFSNYVwmJ/YhDYfg6mo8iCtmgmlRvmTMP5XLoh797zDZNHygXZPcrjxe/ZYnFe0YhpxHYaSR6uOGS+s/tKt6CAFJacKcb/qds6lVV88
 B4aonAT3
 zVpJraKmroVRvaJvRJCrbu+B2YQlGtOqrwelOB63Jy+1a4FrK4pHuQGt5Do0HHNXsQoyslqduDsHz+yzxyHSf+cLVyoYmeo8Hnym4KzupxASE4GBiOzSiL9vZsr7EYOT5kWoRrOBiuFhDOiv2KHpFJa5x3kA1Re+fEoKhNWgsCVzE685ieipskQviOkcJzymO/cO3+jJtqn8qkahHe8zTpTNHiocfpDmvbVwW6uZ12DyYm1zePSUhEiav7BAqAmbPw01XHdHmXaHC8f4qEs7LuOEofbLeNflpX8hcVpXHbxpkq4oKv63PFT0ZIlcY2W8Hlat4wKUgqxZarXZJNpuUxCuC8UNLeVvr0U5ZS7TEv7VDKbfhNacTauw7G2q/my0rIPwqWwKpEQrR8MSiZbhCIs7QV1bWEyPF+Rlx+W5N61lrDCaMLFOu8QGIpu26NWmKksM/lUbZg6BFT1dj4Ys/cKMbeCKafaMu1FvK
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/25/26 12:59, Yitao Jiang wrote:
> Hi,
> 
> This series fixes a THP policy problem I found while debugging
> frequent ROCm GPU failures on an AMD Radeon 780M system during ML
> training.
> 
> Some AMDGPU/KFD user mappings are registered through interval
> notifiers and cannot safely tolerate the backing VMA changing from base
> pages to a transparent huge page after registration.

That's certainly not correct. This is a must have for a whole lot of use cases.

Why exactly isn't that working for your use case?

Regards,
Christian.

> Userspace can
> still apply MADV_HUGEPAGE or MADV_COLLAPSE, and khugepaged can also
> collapse the range, after the GPU mapping has been registered.
> 
> On my system this showed up as asynchronous ROCm/HIP kernel launch
> failures, often reported later at a synchronization or copy point. I
> expect the issue to be relevant to AMDGPU/KFD mappings on
> XNACK-disabled GPUs more generally, because those mappings cannot rely
> on replayable GPU faults after a CPU-side THP remap. I have validated
> the failure and fix on AMD Radeon 780M / gfx1103.
> 
> Patch 1 adds MMU_INTERVAL_NOTIFIER_BLOCK_THP so interval notifier
> users can ask the MM core to keep the covered VMA range out of THP
> while the notifier is active. The MM core applies VM_NOHUGEPAGE and
> clears VM_HUGEPAGE under mmap_lock for write. A later MADV_HUGEPAGE
> over an active opt-in range is treated as an ignored hint, and
> MADV_COLLAPSE is rejected by the existing VM_NOHUGEPAGE checks.
> 
> Patches 2 and 3 opt in the AMDGPU/KFD paths that need this behavior:
> HSA userptr BOs, KFD SVM ranges when XNACK is disabled, and
> GPU_ALWAYS_MAPPED SVM ranges. Other interval notifier users keep their
> current behavior.
> 
> This does not disable THP globally and does not add work to GPU
> command submission or kernel launch paths. Additional work is limited
> to opt-in notifier registration, opt-in notifier flag transitions, and
> MADV_HUGEPAGE attempts that overlap an active opt-in range.
> 
> I tested this on top of torvalds/linux commit ab9de95c9cf9 with:
> 
>   - scripts/checkpatch.pl --strict --no-tree
>   - git apply --check
>   - x86_64 defconfig build with TRANSPARENT_HUGEPAGE=y,
>     DRM_AMDGPU=m, and HSA_AMD=y for mm/ and AMDGPU/KFD objects
>   - standalone HSA/HIP reproducers and the ROCm/PyTorch workload that
>     originally exposed the failure on my Radeon 780M system
> 
> The standalone reproducers depend on ROCm userspace libraries, so I
> have not included them in this series. I can send them separately if
> useful.
> 
> This series was prepared with assistance from OpenAI Codex (GPT-5.5).
> I reviewed the resulting code and take responsibility for the
> submission.
> 
> Yitao Jiang (3):
>   mm/mmu_notifier: let interval notifiers block THP
>   drm/amdgpu: block THP for HSA userptr notifiers
>   drm/amdkfd: block THP for non-replayable SVM ranges
> 
>  drivers/gpu/drm/amd/amdgpu/amdgpu_hmm.c |  25 ++-
>  drivers/gpu/drm/amd/amdkfd/kfd_svm.c    |  36 ++++-
>  include/linux/huge_mm.h                 |   5 +-
>  include/linux/mmu_notifier.h            |  28 ++++
>  mm/khugepaged.c                         |   9 +-
>  mm/madvise.c                            |   3 +-
>  mm/mmu_notifier.c                       | 204 +++++++++++++++++++++++-
>  7 files changed, 286 insertions(+), 24 deletions(-)
> 
> 
> base-commit: ab9de95c9cf952332ab79453b4b5d1bfca8e514f
> --
> 2.53.0


