Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5107CCDE001
	for <linux-mm@archiver.kernel.org>; Thu, 25 Jun 2026 12:37:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3A6416B0095; Thu, 25 Jun 2026 08:37:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 32EAD6B009B; Thu, 25 Jun 2026 08:37:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1F8906B009D; Thu, 25 Jun 2026 08:37:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id EB26D6B0095
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 08:37:03 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 78793906DC
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 12:37:03 +0000 (UTC)
X-FDA: 84918384726.05.4462B30
Received: from CY3PR05CU001.outbound.protection.outlook.com (mail-westcentralusazon11013019.outbound.protection.outlook.com [40.93.201.19])
	by imf05.hostedemail.com (Postfix) with ESMTP id 9365F100002
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 12:37:00 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=MYTnbgWF;
	spf=pass (imf05.hostedemail.com: domain of Christian.Koenig@amd.com designates 40.93.201.19 as permitted sender) smtp.mailfrom=Christian.Koenig@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1782391020;
	b=Zbc3R9tPRtZ10vLtu0z8z1oDwoJ1isuZnhrD6UR13qGsPieoE91Vc2KXOQCOr9WYNFA9p5
	SkXSaFl/O14Zcbdfide3rUtpY3cwg5sGJj9/rWdA4MUiSAvRGuISRMgvNi9gqsu3zMe19C
	GWVK6v3/oum3GzlEI8IHWAQ2icmQO1M=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782391020;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+ZJmav+l4wWvycEDiTRl/SxHmv37D0WfFytN3TQ6iPw=;
	b=ZZ5nmyOlSmJnToaUu+gddY5+GBp8PonoVAihDYoWcVA/VhlBma/NkUmLKKxsUz6VF/RC6s
	D2Aj/A+otezBq5wMR74UtZzMhfUhPT3Cgo1lNVbiHI/OfK54LXvYeRCx4gQgjg992YRvNX
	KXc2yD3gkXzyK/eps3dWmcP3v9kBmT4=
ARC-Authentication-Results: i=2;
	imf05.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=MYTnbgWF;
	spf=pass (imf05.hostedemail.com: domain of Christian.Koenig@amd.com designates 40.93.201.19 as permitted sender) smtp.mailfrom=Christian.Koenig@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=p6XZYCFr5N3DpbHCwftvOu/fqPBnNdOk10lQD5dWLKc11oKzhP731TG5Kdzt+IlktNQuoP+PU6cgBm7lTCzeQ2dI282FlWZ4rqgypA1Q93GDAidy13YteNA/1Qu+YdSMY0+B2ReyGzCN6HZ+IymkEBcky/aWMOdaKvpbtmQdGt1VujX/7uzx3eXWXEDz23oyjwCI6kBlNNaLJEJljV494Qiequ+7K6BC1wCC9UXY0HLMZJs15VJjW4Nlgn6XFJC0LdJoeAXh3Wx/HDXa8kgAD3+2LdwhgrHUkpgeSJ1gP65Ia6Ec3Xw6AqmYR3FWAyBddEFt1E94aHbzj1UrJrGQMw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+ZJmav+l4wWvycEDiTRl/SxHmv37D0WfFytN3TQ6iPw=;
 b=Ab2Us7pyGVr4Dr0Fh3iyEr2DGDUvp+hZB+GUFLLudF0P1v5kBAEgcbNTZDN65eVluvaqVyHdresGM0lNTWX+qD5tMMaUKwAnkeygeonPm42TMWOSnH8A7rNabefxnBSoapOw9Xxzh5ErtNuwoOy3ZOllG6Xmk1lzsPfD9sMwgYkDYErZlACUToZ8piWqmwuIHhf/d0FZnlA/OkKtoH+KUOHCDEYIC1w5xR3JA+rlH4OhU/+I4DvVCH4zK/EX8nf0UMBPM0EiPlMwLFSvD3+Gh0GiNssKSlvlJ7RzwXR2A636C4gqf/bTmojXeAu52EQVCljpzoLLPS60eqLn0ZSfPg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+ZJmav+l4wWvycEDiTRl/SxHmv37D0WfFytN3TQ6iPw=;
 b=MYTnbgWFOPIwiPe3LRFwSIgqWl+OrO0cflnGPyiqpj8nhAbVtL1pEgmp2HSxLHejfOBK9lDabjVK2ua7YyHtt8hh8S472mjqNkUvzSxhJZwkSDoyMcI49iKdgYPrMEvJAaNBhdYq9tM2KtlWTkpha8RSi2zBcFpj8XdTSRk1hMA=
Received: from PH7PR12MB5685.namprd12.prod.outlook.com (2603:10b6:510:13c::22)
 by DS7PR12MB6167.namprd12.prod.outlook.com (2603:10b6:8:98::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.159.16; Thu, 25 Jun
 2026 12:36:56 +0000
Received: from PH7PR12MB5685.namprd12.prod.outlook.com
 ([fe80::ce69:cfae:774d:a65c]) by PH7PR12MB5685.namprd12.prod.outlook.com
 ([fe80::ce69:cfae:774d:a65c%5]) with mapi id 15.21.0139.018; Thu, 25 Jun 2026
 12:36:56 +0000
Message-ID: <5b9c74e5-d1e8-48b1-b5e9-7c761b9dfcac@amd.com>
Date: Thu, 25 Jun 2026 14:36:48 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/3] drm/amdgpu: block THP for HSA userptr notifiers
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
 <SY1PR01MB1059636EEFF3E5C5156F899B8C0EC2@SY1PR01MB10596.ausprd01.prod.outlook.com>
Content-Language: en-US
From: =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>
In-Reply-To: <SY1PR01MB1059636EEFF3E5C5156F899B8C0EC2@SY1PR01MB10596.ausprd01.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR4P281CA0311.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:f6::18) To PH7PR12MB5685.namprd12.prod.outlook.com
 (2603:10b6:510:13c::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH7PR12MB5685:EE_|DS7PR12MB6167:EE_
X-MS-Office365-Filtering-Correlation-Id: a6d9146a-7417-4a8b-e3e8-08ded2b67137
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|376014|7416014|23010399003|1800799024|56012099006|4143699003|11063799006|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	5MmGkQNzvs9bS8AAjWuV+zPJ48t+waDQ5FyFvVsbfaIXzLH1+2jJn+H7ak8iiWivRnvY6L5PKNTrU7aW8gzMrX8PGTdvE1j3g1h5pWvbRlDXZVUQtgSNmrpv4IKkr6a5I1AyAy6TsTfgaBNen0WH/L7SdeFqPAHnUjv9WrCmmyxCuxJ86Hxc9BOUD6BIJNmAzpYe9WRecpJ5TkvaRlAUThA3CPzo/ZxOG1jfUkE7ZNm+egFcBOS6P5EGD8w+wZqfcVOTD0PGow7VV+/bRHz3S1nZsccMrW5eF3jNwqPjElESdfIlkQa57vF4w5fIoyegZb/IpWWTdfdw38X+AbFitQKs4r6BmoDI2fdnr59Wj3XO08mVYtX4pyd+3yj8NEMvd3pX7ap9OpopPn/xzEv/nmIbsHlc8+aCRjTz+NTWEaaJNXLVVyO1w+6MPhHFQoHmtWHY9iJels9iVW9XoU/kfPahAMAKfID6ZM4Lp31C8IFPudzPdpPub0iLDA3qzcEHmta43TMSQLx91s+rqmMGmg5LdztQ8bFsSrYYCiscGcElWrIaMv3I09SEIgqKFNOhM2OrZ24LTPC0xglak99cQeyZgynE5j5GZEKQxhu6I7zILxco1ELvyKFH719gegib2aCkdaEeC6jxNBATvAAMwe2mEPPhkyWtAiwlwh9n3SM=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR12MB5685.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(23010399003)(1800799024)(56012099006)(4143699003)(11063799006)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?a29nOE9laGV2ckFUdzJFSnBhNzhLaDd1WlYwQytXUlZVd1VBL1ZJa21QdVZw?=
 =?utf-8?B?Y2JNekRMenlKVDY1bmxtc0E1amZFLzl0ODRxcDVnSDh1UVJad0FxRkh4eUxV?=
 =?utf-8?B?NlErTSs5cUlCejIzU2tSTDI3R2dodVpFTGNtbEphY25VTGk1QjdpOXJ1YURj?=
 =?utf-8?B?cE85TnBxYUM1dktBY245TG5DRjB2L3ord1pYc0YwSTQvSUVYSDRSc0VPUUtE?=
 =?utf-8?B?UnE2d24zWiszSVV0T3ZUTmRaeDFNNWpUMkNUbzRoYitxVXM5eXBKSjd1bWMw?=
 =?utf-8?B?SElQT2trOEVjWDNQenU1QTJXc2l6bFRPV21FSXJsT2ZiQ2tEMlZ4UnMvbkl1?=
 =?utf-8?B?U05rNVlxdkJqWlo4WVl3VXlUM0lPNkMzdWpQcEY2eldnWVBRTmxYREc4bkUv?=
 =?utf-8?B?bnQvSnJhbFhYbTAxRzhpcVkyLzFXdkw0Y3NMUGtmRERyYWJlSEFiaVhBNVpz?=
 =?utf-8?B?ZXlnV241Q3JSVmhqSVFzZzl5NEJ6blZJa21aSU5ITlRBOHhEZHY1V3VVSUhu?=
 =?utf-8?B?c2NFZndnSDh0eGZxMERFeWs3SDE4YXdsZTc2QkhZc1JwUzVSOGp5UG9WSm9w?=
 =?utf-8?B?TTd1MjhGWXdFL0FMVFFNYU9SL0hMbk5aSmRUSEh0a2NHZnlDN3VGUUovVU5k?=
 =?utf-8?B?Rks2STc1N2gvRWx2VW1iYXNYVWJKY2EvdHgvVUFpYSttYnJGS0NvRnBBZ2ZW?=
 =?utf-8?B?VXgybkw4UXkrZklpRVR0S3M0NFg5OGFpYjluaTV5VVdTSFhoUElrSUJsanlJ?=
 =?utf-8?B?MnJzQ1hRUy9MNjZKQkY0aUJtaHZWajF2RVF1Uyt3NUl1VUNjbmtkaG8xWUtU?=
 =?utf-8?B?c0hlZUZFeGZ1dHNLNUY4d096SDhBWFR4UFROMTVIeHROR1VFaStQa2RFaGF4?=
 =?utf-8?B?cFB0UjkxN0hSbnF0cStNNnF1QWViZHlWU1dadml0ZDNjbUU5RzdqY1FBWExy?=
 =?utf-8?B?azA0WXYrQmEyVi9JVEZOSnpmM29rTXlhNjlKd2Ziam0xcCthSFUzUm5GQ24v?=
 =?utf-8?B?Uk0xL0pKNDdhbCtRUm5iZXk0NGY5T1dzeTBqMHNuU2FZQ2VBaFRwY09KaUFK?=
 =?utf-8?B?Q2hLK1JBb0YvQVBjZk9xaVhvMHBVVEtHK0lsSDA0UkRyL1V0TnA1bHBFLy9l?=
 =?utf-8?B?NVhwaTlvTkt5NnVGM1BHSW1UZ2Q1MlJYcHBXVjdpQ2xFaEZ5MXhhUHVXblJ1?=
 =?utf-8?B?eGYwa2l6VzFXUmNRWlVOd2NEdElCM25xS2dUTG54TjZuOVVyVTZsaGgwelJO?=
 =?utf-8?B?QUFOcXlLcm9YcmFyZkg0OG5EWCt0YjdSMGVwWmZpcks3ZGd1ajZWTkJYRmND?=
 =?utf-8?B?YVNpMWUrR3c3QnFuZzZXT1BKNXIrSTRWVE1kZ1VMSTNhRVcxT0V5N1lRTDdY?=
 =?utf-8?B?SHVjaU5lTVNwK2owVUpEZEpsNjU0MTZ3bEQ1OWNVSDZtcnZtVzZndXFLMGd5?=
 =?utf-8?B?R2hjK25lVldqNFBFK09DaHRjYmlja3AvVXJUSXpGcVBrbWIvRVQ4N2Zja0Zk?=
 =?utf-8?B?aU5ka25QM2xycXphRTBaSlQ0VDFtSWVJWUwvZ3RJVTJiZ054QnhROEZQU2tr?=
 =?utf-8?B?UWQ0R2xOZk5Gd1MwN1dveE5iMERCUVlZcWt2THJYMGJ3UDBERldqaWVLWUpl?=
 =?utf-8?B?QkRhYXV4dFFWNDkxWmpEOHdNeFdNdDNKRGtTVTlwSW95a2VRNThxZmQyMkRj?=
 =?utf-8?B?L1ZHRDBDc0c2YnUzaU9QWlZ0Z2VjN1BkdE5UNUtNbzc0Q2htdTRrNzh2ZXl5?=
 =?utf-8?B?RlBFOEpGMWdOVENQTEI5K1R4UHFEQUVYcmxPZitDVXRrRlppMEJJMHBHWVd6?=
 =?utf-8?B?c3Q0YTJLR0JWK3czMHJuSjhPc2srQkUzTWU2VURZQzZiUzBFSWFvajJzMEJa?=
 =?utf-8?B?M2F5UTZCbWlrUnJWMlNWZnFmOVFRNkQzSllLM2RES0lzb245TjRqZEVkcmxM?=
 =?utf-8?B?cjFNcm0zZ0Vwc3U4UFBnWWo5YW5Yb043WnNLbTB0RTVhMlFKbXlzS1BSQ2tU?=
 =?utf-8?B?SHMyS0xONFV6T3I0RFVhbXdLb1VUcEhYbXZyeWkyNGNTYmttdldYSFlaeTF4?=
 =?utf-8?B?R0RmRy9Sdk1MSHpGd3dXWUJBcmlET2trcmxQOFhBWFUyNlhNVXJ1bUtMbmJY?=
 =?utf-8?B?NDZqMzlDMnZiZGZVY3o2VitFRVQyZm5qZ3Vsd2RrQmNEUnowai9mYyt0YzMx?=
 =?utf-8?B?eE9CSHpSeUpnbVBKSVVkTjMzdzhad0xrSmhVQW5WNGRjRUN3cWVCSXhzclZs?=
 =?utf-8?B?c1FYYm9BK1BsUndnM0NtR2RBWjEveFZwZC9QUllyWnRIang3NEtwTFB0cGF6?=
 =?utf-8?Q?I9Px2vjtkfH4FLFGNo?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a6d9146a-7417-4a8b-e3e8-08ded2b67137
X-MS-Exchange-CrossTenant-AuthSource: PH7PR12MB5685.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Jun 2026 12:36:55.9849
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: z6oaLuvs3Im+fVYBP4kbnebitk4+bKI5ug+r6Pv+jLjcqNUFQSHsWguwSyuG9Uec
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB6167
X-Rspamd-Queue-Id: 9365F100002
X-Stat-Signature: ijrnx87dqmpgead6w1z6gp9zecjrh1sr
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1782391020-627789
X-HE-Meta: U2FsdGVkX1/fJjJXcspiwAWhkYccXALCwIcD5mm2yfkUdxkGEUoElp0Fw+uaEUD5P33/cWx9wFQXl54CwjLg7VbO9FTFxSynkLBNWVy8p740bFTEolUKbbtOJbB2CuiEWge2VcDIrd3buS3I4yht+fSJ7DzNOCp6bdj3VaCr577ZmHGxRFG/dc7I+PslAzy+gfMQtJ7pV2RyHovYxUu7EvUts4tM1EOMzx5Q0WhzJkD8MNHl2NaAIjbPz5v0Z+ua1nuyamGu9kU7n3CafwRaRZmUlBDELjJXKoI60ydiMeGmw7jq7/Xod6SA3xfq8Q6W3LdGUWhpSBClUXW63w6RlEzcOGOQwla2mv4Ob1CMe2kvXsfG0SAESc31QG9ascQVgcXmmSHVU16wm+fUxRnqFTCoMRrcIkxnyK2DxOzqxvtcCLW5FfawK+HpKlAP5GsPCGTLLdTpzSRcHDRekvWRkOPmP4SmNKvdfTYm7B2B0Aoi1OWMKLtMmJwrk12EArYLLtkDbZuA3/Fc8RhvA+4ACmwGnVhGo6k6GLymtkpMOi7ro+MNGEu8uoLMF+4wvY27ub71qCXLZjQH+wIz9wDbKKsVh06CSa9222zdo3m47aWHOyvAxnPTaA3X9zg6gqGqtk78P7zFw+uXMyfdJkn5IYpP79QkqLGompUU8469cDcQrO372qZnyTYp1pRGMlDGxqiJhrLFS77gGoG+cQE72TkBcjt5+1MpMRb2ghmZuOJbN1jAx6ETrKnLPm6B+NR9saT8dqrzr6IUU80iTYIKPCKBeN55hLiwanZrg3kg+Sh8guJCX8Tvg8/Zg5YTaYBodzAqtadh2lykLUWwBve/EJZdApBj0oNBHWpzJgePH/S69BrFEWU5GXT55h47KSEdbW6B7oPYKH+71dGQLQkDm+9+SMU1BB0xjFkWNc9dPZFFxLEnpIPMoNb/b3nnBi+Z6xytlc0D3MR8Laeela8
 Sgd+9fZf
 3dCB/GOj3rzdd5v3FPODR8dw3QUBP9TCpg4Lp/NgO0XY/So6o8Jfc4Po/x97uedRe7HTO6QYKKZSBp2byeogPjI6ja3193zz0qJWSTfFc7YvJUV5wyIJWog20L8pmjTJ77OFS/q+4zzs9Yv+vkFZOhHmVwQNzo1gGqYVVMJBSVDsXIbwylebNGyGG5SoA6rjAklhtn9IC2J2uzS6YsYQdS5qQ4XnpZE2l2RU33ODFk0zitrqE5nAFweIOFHZuX6f5Nv2pvmn+zRrDoboOAj7shPY8ZHk887W/JHqL8bOm4jc/74ZdOTDkuIYg8AGoTXt+gPziB1y4UIYO1qEZDGFxydKbSCsR09Rbajz2R9NZHkpfdOooDqKGsnpwA2lWkz1MiP/vI7bmXXRP2XAXp0Cp1qXtYrlmAlBpGDrdY2t0r5CBgrGATpGMxqdtqItFbWVUefPN7H0nboab37A/MPfOcGeVykUzmji7oTDxoag1Bxjg2ev5NHmkuX6a8Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/25/26 12:59, Yitao Jiang wrote:
> [Some people who received this message don't often get email from jytscientist@hotmail.com. Learn why this is important at https://aka.ms/LearnAboutSenderIdentification ]
> 
> HSA userptr buffer objects are used by KFD compute queues. On systems
> where the GPU cannot reliably tolerate a CPU THP remap of an active
> userptr range, allowing khugepaged or MADV_COLLAPSE to replace PTE
> mappings with a PMD mapping can leave later GPU work failing
> asynchronously.

Absolutely clear NAK to this.

That largely sounds like it just work around some issue and is not really a doable fix.

Regards,
Christian.

> 
> Register HSA userptr interval notifiers with
> MMU_INTERVAL_NOTIFIER_BLOCK_THP. GFX userptrs keep the existing
> notifier path and do not opt in.
> 
> Assisted-by: OpenAI-Codex:GPT-5.5
> Signed-off-by: Yitao Jiang <jytscientist@hotmail.com>
> ---
>  drivers/gpu/drm/amd/amdgpu/amdgpu_hmm.c | 25 +++++++++++++++++--------
>  1 file changed, 17 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_hmm.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_hmm.c
> index 99bc9ad67..c0b36164c 100644
> --- a/drivers/gpu/drm/amd/amdgpu/amdgpu_hmm.c
> +++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_hmm.c
> @@ -44,6 +44,7 @@
>   */
> 
>  #include <linux/firmware.h>
> +#include <linux/mm.h>
>  #include <linux/module.h>
>  #include <drm/drm.h>
> 
> @@ -130,16 +131,24 @@ static const struct mmu_interval_notifier_ops amdgpu_hmm_hsa_ops = {
>   */
>  int amdgpu_hmm_register(struct amdgpu_bo *bo, unsigned long addr)
>  {
> +       struct mm_struct *mm = current->mm;
> +       unsigned long size = amdgpu_bo_size(bo);
>         int r;
> 
> -       if (bo->kfd_bo)
> -               r = mmu_interval_notifier_insert(&bo->notifier, current->mm,
> -                                                   addr, amdgpu_bo_size(bo),
> -                                                   &amdgpu_hmm_hsa_ops);
> -       else
> -               r = mmu_interval_notifier_insert(&bo->notifier, current->mm, addr,
> -                                                       amdgpu_bo_size(bo),
> -                                                       &amdgpu_hmm_gfx_ops);
> +       if (unlikely(!mm))
> +               return -ESRCH;
> +
> +       if (bo->kfd_bo) {
> +               mmap_write_lock(mm);
> +               r = mmu_interval_notifier_insert_locked_flags(&bo->notifier, mm,
> +                                                             addr, size,
> +                                                             &amdgpu_hmm_hsa_ops,
> +                                                             MMU_INTERVAL_NOTIFIER_BLOCK_THP);
> +               mmap_write_unlock(mm);
> +       } else {
> +               r = mmu_interval_notifier_insert(&bo->notifier, mm, addr, size,
> +                                                &amdgpu_hmm_gfx_ops);
> +       }
>         if (r)
>                 /*
>                  * Make sure amdgpu_hmm_unregister() doesn't call
> --
> 2.53.0
> 


