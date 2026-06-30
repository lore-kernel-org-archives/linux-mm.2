Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 670CBC43458
	for <linux-mm@archiver.kernel.org>; Tue, 30 Jun 2026 02:23:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DB86C6B00C1; Mon, 29 Jun 2026 22:23:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D684F6B00C2; Mon, 29 Jun 2026 22:23:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C30486B00C3; Mon, 29 Jun 2026 22:23:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8F90B6B00C1
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 22:23:47 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 1053D140325
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 02:23:47 +0000 (UTC)
X-FDA: 84934983294.25.1007CFC
Received: from PH7PR06CU001.outbound.protection.outlook.com (mail-westus3azon11010046.outbound.protection.outlook.com [52.101.201.46])
	by imf14.hostedemail.com (Postfix) with ESMTP id 3DD9110000A
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 02:23:44 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=epSTdsaZ;
	spf=pass (imf14.hostedemail.com: domain of ziy@nvidia.com designates 52.101.201.46 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1782786224;
	b=NiYzufqDOvugwZou76C6NUUV28zZrmpZ4ClvF89qpzKiKUCNsR1I9Nd1D1JLDJCaWcqRaY
	Wz2x9l1/9G5fiZYusfY/KK+gvg9I2xNEBhvVrvzIGrjAk+87QYC3bIexgezYW+pqIYa7LJ
	bP2o2LB/1TUT5aruf+JVzQidnChYs1Q=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782786224;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3EOEI+mzztej2xbLsolknaQvtarYRGyZ4YfSsnuexUs=;
	b=ERHH7b1fO1ZidifBi/AYxSBMVKDFFMZ26bRB3JWlK5wMm41n9On/dSlbOpVEZjvJXOEto1
	llhAYNPlqfop3b3vDhJNYJdTshWVTGukZRpS713OVZwYYSEf3+4M+Abn2alYICFbu4mMF7
	npwTrPT623Gj1JDzTQUdFtbDCwMIPqw=
ARC-Authentication-Results: i=2;
	imf14.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=epSTdsaZ;
	spf=pass (imf14.hostedemail.com: domain of ziy@nvidia.com designates 52.101.201.46 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=wl6kfa1BUnjxtnEyPOqZ7dNTZbA3DAcY79Akf1wHI+Nq6xjRBT4zbG6OtfM2tUUjf4aJHwJwb+g1nLMP3YydBdU7m2k4b4fHz0qKm0TJJFb6+TXrIqMMfgN5dxWwOkHX6JKYFPNAuo472KvWspllCHLAy7hx+cVRQzqi0gJBcIRb12wfW8amt/ZMLyM2vweUzGYTbaj5lBVQAo9sbDY21Rq4f5rg0GHSNvVCbC8Ia9PyTJQRuP1sVz/LXGzR0JSQhrpj6l3VwCEpT2873L0u+o4RhoAHgP4MtoaGocfkRP8HKTpVJ/LlYPVY3azHKRrp/z6u+x2saZXcs7IvSay9+Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3EOEI+mzztej2xbLsolknaQvtarYRGyZ4YfSsnuexUs=;
 b=q6e/Uiu/eTvvi1jajZ/ICPDON/wDzA9XULMHzlmMUmIsjNZbI6CX30mytsli3+neFX/euY0q+32rPI94NmXG4pSYm4dofYevLMjsRLx3XHyiCc8p7hXCn2fajLjKlvWfIZrZr+YuVCh5Q0iyZ9g3EDIBPJfcnqKVbnxJbuuZK1GFrgb/ZdNaKRSeS2R9IiaH/kKvBY0cF9SPzDDJ4MoZEacLAEJWqIx4zrTgR2B2WEpf3QNRMxz9Q0S8o1sVYLOxxPB0jgbOVvE6GT6K4oiKiRO/WJ81OGChFY70rRUIuSUXDu/MuxA7xjp0yFlqt+gezVdLrHu9AQm5Batq4bdaQg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3EOEI+mzztej2xbLsolknaQvtarYRGyZ4YfSsnuexUs=;
 b=epSTdsaZzWbfW+krSHSNgYpNYqCWROf7vIVB5jar4GfcV0pIbgr4N+WHF9luWCaXp8gaLvsnS4tVVt6pWXJF4CEWALXbNts3a+W6oqO5gnbxVBgUsISARQjPc2HEjy4mR6IiWBHnKsYNRaCHscDXw4r6nJov6qS6uFa7J4TQiOEF5Kd3i72lhWspH1pGW/b+jb0aZspg2Kpdu/fytPyRsiG/JtpdxK4Ew2i2B7gBWp9iW2wLsCupwu+TpTaHtHhpafKxitzn9oQAdcjns0hB10x75lYLkyWn+Oe5Vfm5EvM8PGS3cbZ0IPM1sJzOIYfgtDnv0zSjNhoejs0LAyGwsw==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by DM4PR12MB5745.namprd12.prod.outlook.com (2603:10b6:8:5c::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.159.19; Tue, 30 Jun 2026 02:23:38 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%5]) with mapi id 15.21.0159.018; Tue, 30 Jun 2026
 02:23:37 +0000
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Mon, 29 Jun 2026 22:23:35 -0400
Message-Id: <DJM0YX1IJNPW.26MDYJ1PHIN51@nvidia.com>
Cc: "Vlastimil Babka" <vbabka@kernel.org>, "Suren Baghdasaryan"
 <surenb@google.com>, "Michal Hocko" <mhocko@suse.com>, "Brendan Jackman"
 <jackmanb@google.com>, "Johannes Weiner" <hannes@cmpxchg.org>, "David
 Hildenbrand" <david@kernel.org>, "Lorenzo Stoakes" <ljs@kernel.org>, "Liam
 R. Howlett" <liam@infradead.org>, "Mike Rapoport" <rppt@kernel.org>, "Yu
 Zhao" <yuzhao@google.com>, <linux-mm@kvack.org>,
 <linux-kernel@vger.kernel.org>, <stable@vger.kernel.org>
To: "Andrew Morton" <akpm@linux-foundation.org>
From: "Zi Yan" <ziy@nvidia.com>
Subject: Re: [PATCH] mm/page_alloc: free allocated PFNs if the range does
 not match
X-Mailer: aerc 0.21.0
References: <20260629-free-pfn-on-alloc-contig-range-error-path-v1-1-496ff9ca22db@nvidia.com> <20260629190616.050ab4e309669fae250c6c37@linux-foundation.org>
In-Reply-To: <20260629190616.050ab4e309669fae250c6c37@linux-foundation.org>
X-ClientProxiedBy: CH0P221CA0038.NAMP221.PROD.OUTLOOK.COM
 (2603:10b6:610:11d::24) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|DM4PR12MB5745:EE_
X-MS-Office365-Filtering-Correlation-Id: 6ec8a5bd-1918-49e4-2de5-08ded64e9797
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|366016|23010399003|1800799024|22082099003|18002099003|4143699003|11063799006|56012099006;
X-Microsoft-Antispam-Message-Info:
	gQB2Gfhyelb57Pi84TVCpTUhSptabGwegy9mP34nHByd42mpAk+AxhQm+zD3t0geudnIjN4Y3UpN2nbjlWuPE3RW043v3es0adbzv2gg6PelGv/tsC0RywIo8IUSnxF0vG7tgaHp8vrSR1owx8m34BrR58iHXPf8Rob5hE2mq6pIQNIGtNEXBIvODYqN6SE7Elq99ZXP9QQxMWdvTzjKvQMbamx3acm0Ni6uTTIUfbCuVYO/qZKioubHCXQ2NZm6D1h466cQV4S9USPa1g2dwi1jHgZdl6xJBkCMZD54q/eOZWMiJ5RtTHTPwJxdBV5u3JQSbe1CnU0j9Aa3Q3cRcMwvjBCS+efJG2vbiWSl/lzbhQh0jpj29ppGeYjzATam13dKPGy6AjSv151rFLsFHi6GLs8/sjEG6Dn+w6gei9Fhkc7JyKN4SQ2XR/zk9li5JxbFYf+qYjshvM6enDqcNc7mJCqFrvHh544PT/H5a9rkykkVs1ukbSAMPqO21XBsUtHda31Qu6MftQYwb/MkMpL+NcTXmgSR5nVaBjUmW+9v7grHeaFnutqaWEspfnbny7dZICrlo35RlF6c7Q9Ag4SHgmW/nimN3gbksQclE6Nd87tY91Ono4uk8irN9eQxNBGaGUB5E7tn+W/Umni1fKLyiEv2o6ALBUyGjBrrjx0=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(23010399003)(1800799024)(22082099003)(18002099003)(4143699003)(11063799006)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?SU52YWRKRWtJQWpjSjNhZlFYVWRXemtrVE9NU0NuNVdFbzlCeTRzaTJLL2po?=
 =?utf-8?B?R0Rpb2RPUzBkSFNxajFnRUJyY3BsK0Y5NDA0QVZLRWFGTHVHNlVOclZraWpF?=
 =?utf-8?B?QUovRWFMemZRLy9kTE5Fb0UxVVMzT015Z3VFdVkvdU1zblBDS1MvV0hjU0pL?=
 =?utf-8?B?cEdQMVRTd0NkVURRUVA5NU4zcU9BUEx5UEQ3a0JWQ3pQekxOWWoxMFZxOGlP?=
 =?utf-8?B?N0NBYVFwK09reWN3RDNMRGJiL0Uzb1VyVzMwQlYra2dDUGFJc2hQTElKbWtv?=
 =?utf-8?B?WDJ2eHhpREdpNFJETDYwL3AwRmc0TlpQWHh1V0lVcUxCMUdEeXFDU0J5RkZP?=
 =?utf-8?B?RG1uNTZROFkxUDJZSUxmREJhTTJHQTFrdXE5bmUzSVl2dzVmdS81dm91ZGUx?=
 =?utf-8?B?RDk0VHl0ZmNIaVRjK1RMNUh4Vm5oNE1sL2N4Rk5ab2hCajZ1ck5PVlp6RXEy?=
 =?utf-8?B?emUxbWlqUi8yZkkrUk4rODVPcXRvUG1zTDhWL3pSNjdoa3dTMjlNNld5QTNp?=
 =?utf-8?B?RitCVHdQeFFOUmozSnZPajRhVk1LSkpVdWM0Tk50Ym9lbytyMlcyRGltZ1FU?=
 =?utf-8?B?S0hKMjdOdDgyeGYrbWJGZXJWRGV2NXpiZ1FrY3Z2YVIvQ3RQRitzYUFkczlG?=
 =?utf-8?B?RmUrUC9keitwcW9nZGVpYy81YlQ3NmhsM2loMUl1dDJNRFBETFVUR1FQdkhT?=
 =?utf-8?B?bWlBUjk4SWlKczFONll3WXNiN3EyZmRmNUZqaTFTeVZBMVJrVllLRmFmZVhv?=
 =?utf-8?B?K1ZrRDdwN2ZYWmczdG0zVUVwRUw3cG10ZlI4TGpEamcrWUpjSHA5Vjg3N1Nl?=
 =?utf-8?B?V3R4VEc3cGJXKzIvV092ZnRZM2RuaFBkcDVlUDZnRGY1bE55dmFyZEVXZ0RJ?=
 =?utf-8?B?cmhVclUxNjhwRlp6eFBhei9GMm9MNEh0VTBXb0gyMVhLTFErbTF2QlU2SU5j?=
 =?utf-8?B?OERnd2lSbEdUNWtkWEEwd0JSS3JRU2E4Um1HV0o4emRlTzlWeGJjV0Z1SUM5?=
 =?utf-8?B?ZDFFQnRBR1hCRG1iS0RHSldEZDdlakVBa0ErQi9WcCtMR250VW1lZDN2c2U1?=
 =?utf-8?B?MmRSbEJPcy9mWWxYSTBHNkpaY3ZvZ1d0RisxUW1zcEU2Rnd5RDE3ZGxQR1Bh?=
 =?utf-8?B?QVgzdGM1ZDZqY3lvbWZ2NUdUYzgxVnBzYmNZQTZsVDBidVRCNGozbWdBTVdW?=
 =?utf-8?B?eDhFc3dMUmRzRDZhL2swKzZ1WDRjemR1dU9LT0tOeGZVZTZialJLOVJ4R3Iw?=
 =?utf-8?B?aGdLWFpzanljYnhMR211YUpiQmovdVZnUG1oaFVRUTlqaVVVRTA3ZTA0OEpY?=
 =?utf-8?B?Y1B2OVdYZFJPbHRLcmcxNUUzZ3h6NU1waGZxU0ZPUDRTUnlxbWl5b3MrU3FM?=
 =?utf-8?B?eE1yRzN5dUtmOVNXekU4TjQ3NlBiaWxZMHhjM3lnbkJoWSt5anpUOE5GamN3?=
 =?utf-8?B?ODJUNkEreVAzMlZqSEVmcm5YaUZsVCtpbXAwNm5xRXRUc1RVbk5HbzVGSnRm?=
 =?utf-8?B?SHhZUmJVUDlJbXBjVmVpenZwNWZIcUpUTDc4S1JsaC9TSTNKWEVXU21rQzM2?=
 =?utf-8?B?OVF3YXozUDBmNjM3UEdSU2M0L3JFOEREYUQ2VDdBbmF6YXQ1RkxWUnpmNjZo?=
 =?utf-8?B?ZVhJWmcvY0dscjRoZkRaSGMzNE84NE14b0YrZVBJVExaSStKcDJTNWVVajd1?=
 =?utf-8?B?aEVvRGtpZ1RJY09yTmc1WGhCaUpKUnlEaWF2NnpuUkNZZ0l0YWtIRnp5UXhM?=
 =?utf-8?B?NG9IV1JPVlFpcnpzYmp2elFFYkY5OVhmcGQ4dVArQllvaXBSQ0s2Vk5Xczgy?=
 =?utf-8?B?QnU2ZFRzM3huak1Rdm1pUkVIWEFjRjZqY0FUUDZYY3VUSDJQbW4raGpwQ1pX?=
 =?utf-8?B?TFArRDBaMXRzeVd6VmZ4OEp1d1BMRm1NdkN2ZmU0Q3A0ZkViVUxzVGRDWHg4?=
 =?utf-8?B?N3pIVjdMZ0d2NDhuQWh6RVBlYm1JQmlvb1UyNE1xQ2x4SEk3ZE4yalZ3WTBT?=
 =?utf-8?B?R25IbWxFNlQ4SFlVUHNXVktWczE5eS9TZUMvL3kwTDhTc01lK3h4UnJIM3I2?=
 =?utf-8?B?VHlUU2w5OUdpNzdOSzJOMmdobGdVMlpSNU5vY1RGS2NjOGErSUpPbHdUVXNw?=
 =?utf-8?B?MENIZ25rSE9CSkQ4Z1IvNk11akhWRDc1dm5VMXpVbHlwSUhOc1hPUWROMGo3?=
 =?utf-8?B?emxPRHh4Q0I1ZVJBY1VwUmR4dUtrdGp0V1R3aXFMVDAyNzhNaU04bjhTNWtW?=
 =?utf-8?B?VDhXRlNjTlhtUktmblBJdmJFUjhZd2VVME05alFjWkw5ekpXY2U0MHByUU1N?=
 =?utf-8?Q?uWBW/GG/7HRv9sOdok?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6ec8a5bd-1918-49e4-2de5-08ded64e9797
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jun 2026 02:23:37.3298
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Dh+AOfvvisltWH6Nvqw4NyAEVql5dnUIpRTSfFh7+PWll1lHd0ffApBk+O6J0Huj
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5745
X-Rspam-User: 
X-Stat-Signature: cmy9aee3qp1kc3whapsn1afoyzyiyyjh
X-Rspamd-Queue-Id: 3DD9110000A
X-Rspamd-Server: rspam06
X-HE-Tag: 1782786224-488734
X-HE-Meta: U2FsdGVkX1/WTU8pUqfMFEm0T/N3ep+O1YZl2qKd8gLjB88Js1RyaTESJEu7f4EH1x2O0GP3gUHZD3lJoZnCSRvCYghkLxASb0gbTq/dMqufaIb8zxOyfeOYiCE20D8TXTtiliDFkXoKTqqK88K5iYV4Mts7tjaf/ZIofNR2ChimQ4k2wLUCudY+m0zQn3fSa6ykYLrMIkQua3TMXrlAsSE15as23JrjJvZvStRlo3zwH++9JoABNFIXUVZOg6vdtp4++HShrIoKjWaJjz01npWqBFfFolX1zFOX60wcI6Ho1mCruzVCMZCMBj4fuBlf6hW+X8YqD3uwvMsFCNZPspY5CX8MRoS+GhJkJggbaMAolqgPuAhSMEY51UfR35ERf90oz5D5i7itrBjFTl4e/6bSra6fWqwyTCuCztaBV77qVrWJLlxQIKm06wO2S5liwoV+QURo7e3VftZPc7bM/q6BBxhqjQ2nwmCfgvHe/tpRQ/WfIQgYRsNYpmu4PphsP/E2g9Fwl/pUbsvwpOhCBQv4xkxjc7SAwPPOp+GU/cTAKtcGpwLSZW9OthJrMRm46J2gra47GTn/qsoLtH4GeWIYlhmhgZ7k20k+VW2CEhVJyP44lPOZ3FOLuYPxn/Wr+RPnV9/QSb0JOnIY22gUwne5nu6MMYmRzvem5vVdT7OEYAs40dYReCfPcKy1PE+Ag+qpCyhQjHtv8jFwFuC298edkl4i1zjz6J/x5VVAKCMZ5IhH/bPPvJkPmw3nS1p0iT6xVXyiB7t7+CHTTILRg6b9cEjN4yJ0YoXJxFGuityhmV+3WD70zhFDT2jL64Au/qcqvk/AyHJKqFtZtq+l6zuRn/pQP+qhT5djhObT9UUKKH88/8t4vRQES4sre8zuun+RiDXHr3PYMS1r3flf7KDKRuCdS2KqF8JRrwnw93p1hZUmeWycmP6BhAXsrBeZNX0awPn+QLm6piz1CKH
 CWiYwiJQ
 /AzbzkQisNBKimySVQXS05JhTxO3eJXiKptRjRU8jcQC4a3s0igmK24tNAdGLEpRfS75RxNciVmPI8Rd/YMMuVtq2+AMUam+oN7Dbtb5IVMFh5tqY2FDUC+SwjuIukLbYkMLI/+lb8rPO1PftfhOTSwOxHM9cYdUngSc9vfppTEDGTsFplN/g5KtY4VyDBNMaOXo6WBZw15Nh7b2WcoABZ2L5mOjypa30OX9j53FKblDYaCtvbjAyIRkVYgYgi6rdM1TtBiyX/iRfmDu87mmhl9srbVuaMJaa3FiDdcXkYpBOg0P0MCx58Dz39n6PsXq/ox4WVEvqVecbBkzXLAwUpXOjTIScP5A+FEf6KVZJqf3wgr2DhviB/dc0YpAJoakjpav0h5+5wF2LFduBaluKU2mDmbEyokk1hGilHKO0Men6g93fmy/R4udJh4EGVKTqV2IU
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon Jun 29, 2026 at 10:06 PM EDT, Andrew Morton wrote:
> On Mon, 29 Jun 2026 21:35:33 -0400 Zi Yan <ziy@nvidia.com> wrote:
>
>> When using __GFP_COMP in alloc_contig_frozen_range(), if the allocated
>> range does not match the requested one, the code errors out with EINVAL
>> without freeing the allocated PFNs and causes free page leaks. Fix it by
>> calling release_free_list() in the error path.
>>=20
>> The issue is reported by Sashiko[1].
>>=20
>> --- a/mm/compaction.c
>> +++ b/mm/compaction.c
>> @@ -88,7 +88,7 @@ static struct page *mark_allocated_noprof(struct page =
*page, unsigned int order,
>>  }
>>  #define mark_allocated(...)	alloc_hooks(mark_allocated_noprof(__VA_ARGS=
__))
>> =20
>> -static unsigned long release_free_list(struct list_head *freepages)
>> +unsigned long release_free_list(struct list_head *freepages)
>>  {
>>  	int order;
>>  	unsigned long high_pfn =3D 0;
>>
>> ...
>>
>> --- a/mm/page_alloc.c
>> +++ b/mm/page_alloc.c
>> @@ -7235,9 +7235,11 @@ int alloc_contig_frozen_range_noprof(unsigned lon=
g start, unsigned long end,
>>  		check_new_pages(head, order);
>>  		prep_new_page(head, order, gfp_mask, 0);
>>  	} else {
>> +		release_free_list(cc.freepages);
>
> I wonder if there's a Kconfig combination which results in this being
> undefined.
>
> I couldn't immediately find such a combination.  No doubt we'll be told
> if there is one ;)

I asked Codex about this and think it is OK, since release_free_list()
is defined in CONGIF_COMPACTION || CONFIG_CMA and
alloc_contig_frozen_range() is compiled inside CONFIG_CONTIG_ALLOC,
which is def_bool (MEMORY_ISOLATION && COMPACTION) || CMA.

In addition, isolate_freepages_range() above is defined in the same
Kconfig condition as release_free_list() and there is no issue, so the
use of release_free_list() should be fine here.

Hmm, I think the fixup below places release_free_list() delcaration in a
better location, sitting next to isolate_freepages_range().

I will wait for feedbacks and send v2 with the fixup later.

diff --git a/mm/internal.h b/mm/internal.h
index 6f9e5c2a6065..764fdc0d7cbf 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -821,7 +821,6 @@ static inline void clear_zone_contiguous(struct zone *z=
one)
 }
=20
 extern int __isolate_free_page(struct page *page, unsigned int order);
-extern unsigned long release_free_list(struct list_head *freepages);
 extern void __putback_isolated_page(struct page *page, unsigned int order,
 				    int mt);
 extern void memblock_free_pages(unsigned long pfn, unsigned int order);
@@ -1067,6 +1066,7 @@ struct capture_control {
 unsigned long
 isolate_freepages_range(struct compact_control *cc,
 			unsigned long start_pfn, unsigned long end_pfn);
+unsigned long release_free_list(struct list_head *freepages);
 int
 isolate_migratepages_range(struct compact_control *cc,
 			   unsigned long low_pfn, unsigned long end_pfn);
--=20
Best Regards,
Yan, Zi


