Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B2714FAD41B
	for <linux-mm@archiver.kernel.org>; Thu, 23 Apr 2026 06:04:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EC4246B0005; Thu, 23 Apr 2026 02:04:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E74696B008A; Thu, 23 Apr 2026 02:04:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D8A566B008C; Thu, 23 Apr 2026 02:04:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id C7D5F6B0005
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 02:04:49 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id EC0AB1C038D
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 06:04:48 +0000 (UTC)
X-FDA: 84688781856.05.8D2D3FC
Received: from SN4PR0501CU005.outbound.protection.outlook.com (mail-southcentralusazon11011038.outbound.protection.outlook.com [40.93.194.38])
	by imf09.hostedemail.com (Postfix) with ESMTP id EDBF1140002
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 06:04:45 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=iDLMXlSG;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf09.hostedemail.com: domain of balbirs@nvidia.com designates 40.93.194.38 as permitted sender) smtp.mailfrom=balbirs@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776924286;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oX6VXG7yqjSJ584VzQgw9qIHvmuZYSUSJPRi+p9aQRk=;
	b=f24Jl5ml53UDKTHVxOp2HeCN4oNyWZXBvC3962kG8mBbXyvf9tvrra7+4VflV39qeFW9Jy
	pZ4DeRvPSoCiu/Un/hhGfX7dbfcU8NjKLMgPrqs6vE7Gn+C1ksd3pz9jNfZObDKU/NCEuX
	L0NhRf2glk39N2Lu3Ud8WcP6gL4Qd1U=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1776924286; a=rsa-sha256;
	cv=pass;
	b=u/CbOZnVRorBowsnI3Ogh/X9iWEhg3UnPiHj2ccDuW4xWYHu9O6ZvfLGBge981W+vidwbN
	FR3rdE2Nb9da1dNJV7G3zClrdzds1LO3QVao4UePMMC48h3NaOLMEcyixVYLoYyFUxtmxr
	jxWTEzgjT7x6lJgamFNq2VssPF20qNk=
ARC-Authentication-Results: i=2;
	imf09.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=iDLMXlSG;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf09.hostedemail.com: domain of balbirs@nvidia.com designates 40.93.194.38 as permitted sender) smtp.mailfrom=balbirs@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=M94iFYPcViMURDrXyOzJYj929pVx2/tSvjGzHA0+y3Lpb2llUVPCgJ6Fs5bd9Q4NUXp7/HXuRxlx9inVZ3xOF6qmaDZor39yrN4yyKH0GJByh75INj5gXwBREsdt/T3C2GvQ3AChlxX2yt1b81WSvbQRW9jGvj+lhsG1yu6poDaGpOTtRWVt7GllMM6bfDZGex42H5jCs/kbB8b6FZCADCc7754kaVrpZLX91mBbbowqzctv4IFYCsGmjRigy+wfAhc38gwOkx0i5dLibzvW8M7wIXy5N86uUEhVbFYpg4iL8vORNPFB9c2HuSndMKezKYuy10T2EiQmRbreewI/9g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oX6VXG7yqjSJ584VzQgw9qIHvmuZYSUSJPRi+p9aQRk=;
 b=GacU3fhSGdcyucDOLXk0D6rJuMDUad8IzeT9k4NjuAbz9W0L+nYCk4kPCO/D+Nc5ZLBRWRBrequmKHzxBd77T0rQUnsIUKQ8p3NxikMpSAEQJTg4vZk3IE+/shVVsjfMd25l1RrJmQX8JbUZRWqw0ovSdF/2CVL7pD9QabXqU9pcPtpAkjo4YRS/lFKAGKSzxaq+c/+4rJANwJzBelCkLkP13veO1rqQ6sLwv+DhvXhHCQgYQaSf0Pu86mZP4nf8s83M/wrZLm+zbqnB5ielSMbNl6RzNSCaTBmgh+958rUriPiQ4/eAahqBn53mr+1b4ckIch+W+BkMJqdcN6a4rg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oX6VXG7yqjSJ584VzQgw9qIHvmuZYSUSJPRi+p9aQRk=;
 b=iDLMXlSGDQCyf6vEkOz6vA1BUjmkYJHoH0zHgy2xIaTc5QD2sBJ+bI5mGLh7xlc41utUbjR+4J4FvOg6B5u6AMBeIC3Gqjg3I63Dv1VXgQg5D/I5Sxi69Gbc49OR3nObduEll3JYQzrEkhoPYlwA9ezRCdpN0c7P6NSHVI99VhkKkfOutExSbP6SkE6L/EOoDDi4W6jHNFSOX3GZFX/5lT++6fga19tiuZSupwx77hTR2gclCmYGRMD4RrlXr8IMIosCCLwiC1DpQVxQmgAAfjFnC0MoYhMDkb6JILaSS0Otw+ylNdQJ3nXh7mbtOVQFof/IVWiGijtBuJqv3dc8vA==
Received: from PH8PR12MB7277.namprd12.prod.outlook.com (2603:10b6:510:223::13)
 by SJ0PR12MB8140.namprd12.prod.outlook.com (2603:10b6:a03:4e3::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9846.18; Thu, 23 Apr
 2026 06:04:39 +0000
Received: from PH8PR12MB7277.namprd12.prod.outlook.com
 ([fe80::2920:e6d9:4461:e2b4]) by PH8PR12MB7277.namprd12.prod.outlook.com
 ([fe80::2920:e6d9:4461:e2b4%5]) with mapi id 15.20.9846.019; Thu, 23 Apr 2026
 06:04:38 +0000
Message-ID: <b0bd6cdc-511e-4fad-959d-3fa75c865aa8@nvidia.com>
Date: Thu, 23 Apr 2026 16:04:32 +1000
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/5] mm: Introduce zone_appears_fragmented()
To: Matthew Brost <matthew.brost@intel.com>, intel-xe@lists.freedesktop.org,
 dri-devel@lists.freedesktop.org
Cc: =?UTF-8?Q?Thomas_Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20260423055656.1696379-1-matthew.brost@intel.com>
 <20260423055656.1696379-2-matthew.brost@intel.com>
Content-Language: en-US
From: Balbir Singh <balbirs@nvidia.com>
In-Reply-To: <20260423055656.1696379-2-matthew.brost@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SJ0PR05CA0205.namprd05.prod.outlook.com
 (2603:10b6:a03:330::30) To PH8PR12MB7277.namprd12.prod.outlook.com
 (2603:10b6:510:223::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR12MB7277:EE_|SJ0PR12MB8140:EE_
X-MS-Office365-Filtering-Correlation-Id: 5f6ab843-8319-4cc3-e12f-08dea0fe33ea
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|7416014|1800799024|376014|10070799003|18002099003|56012099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	aFIntQNCMJlFgv4lmQz8seFAFRPs/wM5RhGq9G05BK82KtsHHb+hXFf81Qu4Hgvag+TGfv11pTmT/qqG4pygN6RgG0GkItwgA3Nn1OSssx5y6R5eAeya0T3Qa24CaHJRsS6l15l1B0Zp5h9OKL6Kc4wQaPkb5j5Jz1c3RqzC08zEZn/8eFBMk6aAefCGuhwCbfIjVbjGKnOsycRTytKNLAZgs3+YDZ60b9v8fIWC+wpFnn68Qd02LYv9HPCQ1yl2+zP0m4ZWfldmweUwVuVLSs4KBokDt4UEEP0dkNoJgES5+PWz9TQ25xocoJALNhrxkI/92oV1MwlNRKMZAMNAxLMZCZHZIObZ6UJYHIV2T8HCzn3TIN2ZGPZA+/B/SEJymosYQkl4C3PcEx46NtsFSm6jiOcKV2yQ0jz9sxXWF474sbaacVj0IF1k/x+P+aTWGd1UcSg+Cch/eMlWCr79C/h1niyqsCaPWbEvUgOoLkT7g8ifknZ2i49/tUFBrQ2M1uIjV8ieOCJtBKW0Ve7IgqmIdQuKCyBwgikcV80O97l0z227RUXLSR23ObVl6Gwd+mMdE4HAzbW5mlZc3rxJR30/4Umn7tRlIksWgCqV+rIRx6bBJDWdrZdcuc2n3SwV+BscrlJLraaRXm4K+EsmxnRNFxbq3gObosQaODHQSmlSttDnwqTIt8yxVaG9yFUEIwLhuUoWU+fbGOwxMGe3/NMFu2DJ7uOHgUSPrmkee1w=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR12MB7277.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(1800799024)(376014)(10070799003)(18002099003)(56012099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?dERLQjBMakpORXJuSU1YN2k1Ry8rb05pU2JqSGE3Sk41TkgxbHRuU0o0KzFw?=
 =?utf-8?B?V3ROcXhXNXZadTRFbWlWMjZFWlpCbmJjSHh5amFwckIwcUJ1a1BseXFJSkh1?=
 =?utf-8?B?SG11R1IyUHZCazVaYVZRUlJDM2UrZytOYzNOeDRGd1BvMVZLZUNqeUpmaTVE?=
 =?utf-8?B?R1o0YkxmSUFMNkJmc3l6ZkNxcEY3eDB4cjc3V0xxUjltc3lpRW5YOENscjVu?=
 =?utf-8?B?dVo2WXp1emlqTmdMNWFpRmpzUTNWd25mUlhNR1RZcENMUTlBeVN4K3IvOCto?=
 =?utf-8?B?cFB6WnVUbmxjU0JkS2dHdlc0TTBLVWhvOFpnemN0TmsvOGNDd0JvamFNc3Jk?=
 =?utf-8?B?cEQzMjljUm5sZ0FxcFZkcEo3c0FiTjBoVjd2S3pTTnlUU3A1S0xNbTN3Y0pW?=
 =?utf-8?B?SnN1MVRheVV4b2NmNkM3VGZpLzhkZEdKNExjaDk3MXV4dDhOenJreC9WMzQ0?=
 =?utf-8?B?cXlWdkhjejRkS3o3djl5NC9MZE9SaHZScEkwLzhhbDlVN1JXQTZaVFE4Y3pa?=
 =?utf-8?B?MXkvVDdmcXUrRnpwMXl3Q3czS08rajlTL2JSWnhielQ1NURCUXdQWUgxdTVI?=
 =?utf-8?B?dnBHQ0cvb2JXQjAvd2JSYktxZlliTlFzRCtzeSs3VG95Wm1UbG5kcW44dnJQ?=
 =?utf-8?B?NFc4SXlsNWtOa1I2U09TdXlkak8zaDQ3aG9ERGVJVlpoV2ozMStKMnk4MGdn?=
 =?utf-8?B?UWZjRWxUTVc0NnQ1ZHd0NTlkSmxtN280eWhZdU0wZ01ra0FPVm54MlB0c1Ft?=
 =?utf-8?B?bVR1cVM0Ym4vSnRtVFFEa29XZHptNlp0Mk90SWRMT2s3NTBIK1BqaUhXdlVp?=
 =?utf-8?B?NVNseFdvSWJ4SlNDdVF0NzdJVG51VFZwQTMyTnhrZXJKdk9EWFo5WUNNZ1ZH?=
 =?utf-8?B?NkpFYmRwU0xvYnNvUzdqVFRPcC9rcElJekROL2FaM1E0RWJBYTZ6Uy9oOFBW?=
 =?utf-8?B?YnFGOXRGSEVGaWEySDJjOC9PUFhzalFOZ3I4ZFdkN3JiQlAyRjVzeC9lNWEy?=
 =?utf-8?B?c0V3ZnQyaDZaT0RxWTRzMFI5QUZMY3pGKzJIM0ozTC91K3NGbk5OanhYWVla?=
 =?utf-8?B?dG1tR0VzYVd3MncvdWJVbGdObGFSWll0VHNmdXBhcTR5bnRFSGVKWXhhSXZp?=
 =?utf-8?B?eXlVb1ZnK2trUktWa2x1M25NS2JjSkFtWW0zWHJ3R0ZRTUtxNlNyZXdUTFl6?=
 =?utf-8?B?SWNvU0svWDVRSmdxV1RGYlJtRlJ0bHcyMmtOU0F1NjFOSThVRldHbm1PcnRI?=
 =?utf-8?B?bjZJZEJFZ1o3Y2dTWnVmUkhxcnlicCt0Y1BaK3AyeXdXbC9OY0FJcVphS2NV?=
 =?utf-8?B?WnBtcGtOc3VsWVd4S1RFM1YvU20zZzNna29xNVBPSnh4MjJzRUxPdkowdTYx?=
 =?utf-8?B?Y3RZMkVLaWx5QjJUajE0U0pnZWQxMzh0YjRoNjFGL05zeWZCNWl3NmliSTRv?=
 =?utf-8?B?bjhwM0ZsYmxRTXpQV1NSWTAyZEJObnpUK1paeU1FUk9OMHoxUmdOQk03SXVj?=
 =?utf-8?B?TlhEK0pveG1SM0tLZVdQV29rZzByUmFzYytWZVlISVJldFh4akRmODR4bmNE?=
 =?utf-8?B?K1VYZmtIWjlVWXJMTU5SaHRnTXV4SUNFTElUcUM5NCtYai9nbWxVMTJTa2Vx?=
 =?utf-8?B?UkV6VU9YcUNKeXdYOGI2VnVOWjZsdlpHR1B6RGdqa3ZFcWFSSHVDZHRRWGwx?=
 =?utf-8?B?dHAzUC9qbjBpYm9NQjZQSTNicjFYWnpiRTIySzIxQlEwRVA3ZGNEOFRsQWVu?=
 =?utf-8?B?b3dVYmJFTlJVOWNFaXNtSkE4T0ExRXUvWDFZTllFbHdvTmxHTXFXOGlUSFhu?=
 =?utf-8?B?UlRrQmpBT2c5aGNRd2VseXJtQjE3VUxKWTBDN2JLc0dmMEVXbDhQQ3FIRzMy?=
 =?utf-8?B?UTMyYjlFakpObk1sRU95YlRiVkJpbEVUQmppWVM0M2Q3YTlNN3B2Q29lRk92?=
 =?utf-8?B?UUFFYnFTOW1WWGRQRXNpaHdGVmpjYXhEelQ3YlhNaDRJRVNsdDRUamR3V3Nv?=
 =?utf-8?B?YUpDSGxqc1BiRDRJOTFyUzZvZE9udER3YnRxT0krYXNxQVB2QlRxTXJOTEZO?=
 =?utf-8?B?WWJYN003MHBrTko0NExsNEVFV3p0R3pKYUJyQmFMQW5OSU1iQ0gxWUpZS05F?=
 =?utf-8?B?ek1aQWxYdXNxRzBDdGN3c0JBOXk0ZUMrM0dsbC9PN0FIaEE0Vk5vMjRWOFMz?=
 =?utf-8?B?cGl6a0Y1eWdKc01Vb0VNU0ZWQk9NNTlvYTdpWkJqUkFQVW1oak83Sy9SREV4?=
 =?utf-8?B?bC9mejNpT2FCTUx4Zm55ZHY4UEFENnBxQys2Q0cvQ2tEWU1qUWl0V1lvN2tv?=
 =?utf-8?B?c2ZDN01ocnNHak1uTlVmTTVEdnZKcTJEQ0VqVHIrKy9JTVgxYklQZXkzWDNs?=
 =?utf-8?Q?V7tVcMp766vIim4Pxtra2VgvYo+WQdPuZg0QJ4G52ktF8?=
X-MS-Exchange-AntiSpam-MessageData-1: jqTGu5TRbl0tgw==
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5f6ab843-8319-4cc3-e12f-08dea0fe33ea
X-MS-Exchange-CrossTenant-AuthSource: PH8PR12MB7277.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Apr 2026 06:04:38.7620
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gakdiFdC+ZQ3tfauMC02F9ZnIdp+pTxyJGqmNJRPNco2pQvTWW2kwlx9+PeinKF4izZx0kKTBQU7D6gTtQXuoA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB8140
X-Rspamd-Queue-Id: EDBF1140002
X-Rspamd-Server: rspam07
X-Stat-Signature: xe8pd9je1hfu8ke3csqdpucw4qgsbrg9
X-Rspam-User: 
X-HE-Tag: 1776924285-214043
X-HE-Meta: U2FsdGVkX1+95ta5GpAPckLwOD98aClnWPpVXppth0tik7XQ4wCqrsFTBkUmt3MRLYgnKHSgXkeJzhywWzUvJCOowO2Oig52Y5yeSwuKon1m9TK9sP+jXwipxt9pm5C2nhnGwFq+qnwR5U/J0d3j/t5ca9BgAG7ZyhXABX4t4JUJVblEvPtoAvJZUYt3zoQQAO6A18YjF99G5/7il34WkBV+CNFCUZjV1HtDGvK8mkXhOAJgYUIBYBUgB6m8GFBOkGj8Q1yzLHN5rOMT8egKWPgQbIrjoTT2eEvrULSzya/FfXDZX2RmOWm/HrQbGevQUnQp7Wq16fZdSoYWj3HyYQMtM2TNgQVB0aiZa3Y6BCQ64S5+63eFI6p6NyO7lBfT36WfTaBcK7sRAEhS00vK5FPZvE48acvKCEWDLHXuVXyD33WS/9NRuo1qTzMkatQKIVwl81YmLvZSXlbzcpxuhH2N8D/RuZKUqqLV65tlYpmh633J9s0/cmloV+7q7QMs1KG8o1D7JGr7Go6BzjqVe0p8nejRgtqxATTuKimJw3ktZI1AApjaY7OQmh0IiGUXhBYFacxiiDHNEgFFplnP+hmygJPcexufxsYN3+/R3qidk+e3kzzGQc9ezOrG+0+zKuGAyB4ogAv7wVHtsQrcgwfBAMe39DtGhpm2Kudy5bP8BgoeQLCUN0eBmFoAmlM2Ecb17LglvqNkRNsLOssd0xBdZIy6NiY9/FHKGK62hyRFq1RVBPXkvv83A44aPmPaSiJcItDkNgBSSfJnnLVSnkhgU5HWzLIYE3PFhdKGpeWH8TrtZdbkIDvSbtR0ij+/wmzr9SlIzffd4lYch+dCMpFPyq/rjskQpEA1uo23uP5l7sLuOG8UOK1ubYLvbVhXkSCn79MTxfGT5D5CBUFbQQgAVI97FHmgxPzddOAXn3X7Yeyn9cTLrZdMjaoS/RwEpCFFBTXn5mVu6EcQ4HA
 HEQQk6FT
 j4BsEB9B/HtSa/P8j/1ykMR9L5ufX0hhmhn0ruJ5LG3bHWBonYmIdt0ZZKn1FeBIIl5JmZXXMhwLhiuQCU68CzXfV8oSp1oRKaznlx9/tWYmLRtBys4yu7bVQQwIdqPGbCS6BPS11OXgN2pUPItNQV5nysT/HX1mn2lxcATLzhg4s4TUbjxt2selVbG51v6WE4OHTUFbB0qLtuQp8897uh/dM+OSMIZ1Dzoc0qTTumGOMEjiaL3HFOeS1hJ05qdMd95RFBXdExDsF4uOwBSYpK3M0atk2JiD81+jgE/4NLkN5CrQTcQKsDcBCgS8FYibZrT+nBLa3a3zJ9/zFwkHMttB0GBzFDNMvgVVjcowvN6d3TjvQkCHfb2U+ik5UeivHYglzhhoagbBu8ASNeu9oYlOoI4ivCPdiEWyQtMiez8rZ4gCVoHLyam4WwzfEf5tGDS+Btlms3iTzp2wWMyIpHogrqEM5Z7tAl/4hSXGT8U8EWS3RkgHDhl0xl35gNN+Qw8LhLsyOjqMGHMC5gc99i0LR2s1TTjcYfMM2Nq/zGp0GaW7d7MKQSz+JA8wv0aiupQoZ2kxXBJvDfNbh1HOp8kez2+r6X8bLFByuLxWxzmkLLLwhXPUy8xck0BphEEP0Jc1dcg1wK6/LBycUDebUvMR15gbSAtuu42uu7eDZ3t/7H1v9IqJgCcpS1oZFF3GxzlpGquSGi65y2NdmEkJtAMunzDh+Yx2T4dADcy4KREx74GNViKFbsO2zA0FJkRoNn3iW
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4/23/26 15:56, Matthew Brost wrote:
> Introduce zone_appears_fragmented() as a lightweight helper to allow
> subsystems to make coarse decisions about reclaim behavior in the
> presence of likely fragmentation.
> 
> The helper implements a simple heuristic: if the number of free pages
> in a zone exceeds twice the high watermark, the zone is considered to
> have ample free memory and allocation failures are more likely due to
> fragmentation than overall memory pressure.
> 
> This is intentionally imprecise and is not meant to replace the core
> MM compaction or fragmentation accounting logic. Instead, it provides
> a cheap signal for callers (e.g., shrinkers) that wish to avoid
> overly aggressive reclaim when sufficient free memory exists but
> high-order allocations may still fail.
> 
> No functional changes; this is a preparatory helper for future users.
> 
> Cc: Thomas Hellström <thomas.hellstrom@linux.intel.com>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: David Hildenbrand <david@kernel.org>
> Cc: Lorenzo Stoakes <ljs@kernel.org>
> Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>
> Cc: Vlastimil Babka <vbabka@kernel.org>
> Cc: Mike Rapoport <rppt@kernel.org>
> Cc: Suren Baghdasaryan <surenb@google.com>
> Cc: Michal Hocko <mhocko@suse.com>
> Cc: linux-mm@kvack.org
> Cc: linux-kernel@vger.kernel.org
> Signed-off-by: Matthew Brost <matthew.brost@intel.com>
> ---
>  include/linux/vmstat.h | 13 +++++++++++++
>  1 file changed, 13 insertions(+)
> 
> diff --git a/include/linux/vmstat.h b/include/linux/vmstat.h
> index 3c9c266cf782..568d9f4f1a1f 100644
> --- a/include/linux/vmstat.h
> +++ b/include/linux/vmstat.h
> @@ -483,6 +483,19 @@ static inline const char *zone_stat_name(enum zone_stat_item item)
>  	return vmstat_text[item];
>  }
>  
> +static inline bool zone_appears_fragmented(struct zone *zone)
> +{
> +	/*
> +	 * Simple heuristic: if the number of free pages is more than twice the
> +	 * high watermark, this strongly suggests that the zone is heavily
> +	 * fragmented when called from a shrinker.
> +	 */
> +	if (zone_page_state(zone, NR_FREE_PAGES) > high_wmark_pages(zone) * 2)
> +		return true;
> +
> +	return false;
> +}
> +
>  #ifdef CONFIG_NUMA
>  static inline const char *numa_stat_name(enum numa_stat_item item)
>  {


Without any usage/users, this is hard to review. I don't understand the heuristic
or it's logic as applied to fragmentation either.

Balbir

