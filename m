Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 72EBAC43602
	for <linux-mm@archiver.kernel.org>; Fri,  3 Jul 2026 13:48:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C29556B00DF; Fri,  3 Jul 2026 09:48:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C009C6B00E3; Fri,  3 Jul 2026 09:48:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AA1B86B00E4; Fri,  3 Jul 2026 09:48:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 753B56B00DF
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 09:48:02 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id EAD69A0149
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 13:48:01 +0000 (UTC)
X-FDA: 84947593962.01.71AAC85
Received: from CY3PR05CU001.outbound.protection.outlook.com (mail-westcentralusazon11013043.outbound.protection.outlook.com [40.93.201.43])
	by imf05.hostedemail.com (Postfix) with ESMTP id 05713100008
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 13:47:58 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=RZmt9+UR;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf05.hostedemail.com: domain of ziy@nvidia.com designates 40.93.201.43 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1783086479;
	b=RnKaCOF006IYpXFA6WqJuhVEnyzZAFkg62nHrmb/yUPz8J2zOotQoOJ5rI/ksmrArQT1wo
	Z5LyXgPaWqftZCniM9LmKOzUl7TU/ycqIeTkpSET7MJeNb+JSIMWyOddkXZP9FbNiAO8jJ
	rCpBG3N8QcJW8apXm8AL+GSablnjPno=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783086479;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YfspqPDDRXDSFdB2kpNPW/CpRH1lf9qxgcSYx0eqZdw=;
	b=JEeRwftmJ/r6+2o2lsnwOQJqvrRbWep67XLQ0sXxT/PhPJIZ/eJ9UoShQpSkJfgQupNF2M
	cfQNZRnvXNRnvp20YLOp+awt52n2qMJ0YTOaKTxoVXG+dFqviCLhBUVSwCqj12HEC7Sa+E
	zp/Tkz3guizA7CqjL/KJ7p6goOJlxII=
ARC-Authentication-Results: i=2;
	imf05.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=RZmt9+UR;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf05.hostedemail.com: domain of ziy@nvidia.com designates 40.93.201.43 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=hYVGM5ufqzGFFaVqJIpjFboRsGgCAu7kc+qYcrQi5JXGAIaAFVUL8geiqUtvUBhtt9EULtYU1S+aMmniaR9unLRQ9vqG018Ojo5z5nKf/qTCtaei5rbnjq0JfgYVg02Kfuh8OgbugVl+eIJhDe73qIISUfndy37j5HaDn/AQUN7V+rX8Cr0rw8ki2ajLMAd1/7OeLmZe6IUkcErsjo1RpsTNE5LYLa+kyceT8XecwucODfrZ+VYvN0uHIuMkuv4X6bJ1PKWS5RkuLgG1QUkePm4SU+JRYCrgfpaUgrNpVuxeRBWPR71bLtQMqOBqsCvMyJevOolNSKwz1jvwGG+cNQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YfspqPDDRXDSFdB2kpNPW/CpRH1lf9qxgcSYx0eqZdw=;
 b=Ik7NdSmhRpJny1s8bF9EdL9mVtLP2NlmTfmDGBQGpECmoP4+UaGT9lpl4nFOiECzzpFxjRRbfY3qFGJfL14JY5xujWzHH1usvLGs8xzGFqZP6zJhi78uaFmPYq4drbOKbZAW2OI2Y2kQH8hFLBuCU/asGJ3gd7RH2BOk3rTW7+F9/9VsbA3qvc/PpOmrKahXuWbSZNhjpa2ALan1Ew/txTzsY47YjzSN43OSvuapVy+m/yB8IxnJbNHTJkEIMN0RXYVRcaeI3Bk0s6M/I3EtJK7ivlEcg12HSu577rlGHmVtg8eH79ycmssK8Ehvnjx+ua5Ldf6k+tAo9XfMY+xSag==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YfspqPDDRXDSFdB2kpNPW/CpRH1lf9qxgcSYx0eqZdw=;
 b=RZmt9+URv0HdFSPRRh1EU5T9HeG0suZVOWaJepa5HQJ0hMSbgwrm0ao0fmCnC+We1PX/x3Bv7dJVvGpaO39wWKVBf8PsUzTbnRl5HJr13ToxnMaOhy7WUptJ0Io3Tf9+3wlUOpRitM1lQX3tQmgcuwx3rZWWTWRzC/WyHem02qM2/5tfmP9dDqi3wJem7vn68sn8KbSPAhMYvbSMWP6pciLKinnI90ecvP3NNoXnh/qC5nhyML8vnP1b1yATN+DqZOewtcXB8pjwf3AyQI+R/EdAxr4P+mV9OnytkGPD7N1m0houy1+oMyb1rLS0/Osr900PJjnSxi42KogxzzgQ/g==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by MN2PR12MB4111.namprd12.prod.outlook.com (2603:10b6:208:1de::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.159.19; Fri, 3 Jul
 2026 13:47:50 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%5]) with mapi id 15.21.0181.009; Fri, 3 Jul 2026
 13:47:50 +0000
From: Zi Yan <ziy@nvidia.com>
Date: Fri, 03 Jul 2026 09:47:47 -0400
Subject: [PATCH v2 2/5] mm/compaction: stop recording free page order in
 page->private
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260703-keep-subpage-private-zero-at-free-v2-2-2970fe777dd6@nvidia.com>
References: <20260703-keep-subpage-private-zero-at-free-v2-0-2970fe777dd6@nvidia.com>
In-Reply-To: <20260703-keep-subpage-private-zero-at-free-v2-0-2970fe777dd6@nvidia.com>
To: Andrew Morton <akpm@linux-foundation.org>, 
 Vlastimil Babka <vbabka@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Brendan Jackman <jackmanb@google.com>, 
 Johannes Weiner <hannes@cmpxchg.org>, David Hildenbrand <david@kernel.org>, 
 Lorenzo Stoakes <ljs@kernel.org>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 "Liam R. Howlett" <liam@infradead.org>, Nico Pache <npache@redhat.com>, 
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
 Mike Rapoport <rppt@kernel.org>, Dennis Zhou <dennis@kernel.org>, 
 Tejun Heo <tj@kernel.org>, Christoph Lameter <cl@gentwo.org>, 
 Alistair Popple <apopple@nvidia.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 Zi Yan <ziy@nvidia.com>
X-Mailer: b4 0.14.3
X-ClientProxiedBy: DS7P220CA0039.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:8:223::33) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|MN2PR12MB4111:EE_
X-MS-Office365-Filtering-Correlation-Id: 25acc621-b0af-4cf0-6669-08ded909ac9c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|1800799024|376014|7416014|366016|921020|18002099003|22082099003|56012099006|11063799006;
X-Microsoft-Antispam-Message-Info:
	nAgTXGgtC781A9EBnLKml/GG4iJ+9fRzXCOc7my3t+0rCQ5MlB41evJ9bAjeZJPK3zkA01Eow8r2I61J7u4Ik4fO13b8HwKIpw8jSMxrFZTBK13TgFX5FPCMNAsbHq9lXS+liD2ITHf59tL4NJYSpudhc3MRbzN4WrDBkmIY1r/tAQwwzHp+a6QUuohN1JEcjtFViYhHi+4QZH4ntFoGvioE8XStztaRtnFPsKR/QtHGOtw4Hk5dsabacZucbiwsLpi/lxzvR/dNb9/1wlomCie7pnQ/ITqbgVICLqYmPrXAZg1cRUWfJyMlYimb+vwjhq1hgMwJvFo4vqT+sYvUbvGQgwT9DgnsHXx6yrW9FsexnQIn77AFgjPwiLtDzzf9xU96YnaBPSpNJGMkvQwe+nQXSZQBYFo1mHMBI3KxXgvRVu2GiEoPrSB0JhAgMTXnN0OGz5txlqQB9iQuDv3SKFGPEA38wVK/19Jl8KCi210XSfovBeLuYKuJ3u/rwlkq640NHyfjqnR0sdD2LTxzCa/x2hBGFa3JJ9qc54xbEYRk1WgtNZ1CHqvD1o5juV9PiPW60WUUrEElQQk+pH4OchraZRbwPmw3s6P3NPusFf2XDyBrTdhNQaGQRuOiz7kRnF9lNtacPrThKo5vvT1F8D3J8iyoKLO/VZY0rca3zbN9QE59cfYBQiWWKTCnEaQG0aZnaUuSWDMarlbwSMCmFQ==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(1800799024)(376014)(7416014)(366016)(921020)(18002099003)(22082099003)(56012099006)(11063799006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?blRXQ2d5UExOYzd5R3pZNmFhb1RnNTVxRjk5cCt4VzI4TVdCZmFYRUphdTBP?=
 =?utf-8?B?MEdIMmt2ZmZqU1NPNGdOZU5PU25aVzlsaU9iMlNNc0pXU2Y0anpuV0RpZGhW?=
 =?utf-8?B?OGtEdlFaU2JMUVI2Z3ZVT0xySUFIcEZZcXdEZXJTMzZoY01MTjlFbXh6cFda?=
 =?utf-8?B?MS96a3BHV0xVbnVXUURLa3E5VWh3b3F4TTY5OGN0WUpMR3lOemI0czdyUGFp?=
 =?utf-8?B?NFY1SnRvNi92T1Qzait2U3pNL2o3YXFxWEptNjNUL1V1cWhrUHBtS1FMSUUw?=
 =?utf-8?B?eEFVUEU2TnpmME0xTzZSWmpVYmtLMkU3ajN1a3pQRFVMM1pvM0NEQ1hnMGJp?=
 =?utf-8?B?SjVnb1NxeXZNb0Z0WnFjVnBITThwckVaV01ueWIweW1WU09sUlpHS3NDUlNZ?=
 =?utf-8?B?eDUzNTN0RFRxTGV2RnVjOUZDMHVWMmhNTUR3RlQxQ1ZHUC9Fd29OY0ppZ2pj?=
 =?utf-8?B?Vzl0SGJ0bjVMN1lIbzF5OEo0YWVIbENySmhrazFZL3dnMEFjdFBCclFuRlI4?=
 =?utf-8?B?NUo4TEJiSWtYaWFYUWIvWnZ1MW8wYU1OTC96OXNxY0srZGozQmVDUTg1Sk5F?=
 =?utf-8?B?UllvdVd5eUR1MW9LNTRtSGJoK2tvOW9KeFFYNDZQemwwOFgvWTZnTnJZL3JL?=
 =?utf-8?B?a2w4aDV4RGthQzB3UUdyajI5MXVBcCtjcFF6Qy9yZzhwVHVaSDdZemRjdWlh?=
 =?utf-8?B?SVNQYzNiQWVBdVV3a283YytUMjlkSU1CZGlKZ0hvd2I0akJEZ3p2VGF5ZUV3?=
 =?utf-8?B?SEpnWFZnZkxrcE90NGVTNVJWbTA3bjVselRHZEZIUElUbEUyYU9CdkZ2bnpi?=
 =?utf-8?B?V1pPMzFVS0t0Q1d6TjBrcnlwRXk0cThTL1c1Njl5L0x3M2xraXNoUjBPaThy?=
 =?utf-8?B?OENhdDd0bFlacjRBbG5ldUsza3VKK1BvcDltV2FWblM0L3FPRkxlaU55QXhy?=
 =?utf-8?B?QVFYZ1lPNTF5ZjZlZXR2TnRXMUVNaWJtTitPcnlnWlFhVUh2cEhTNmoxWXp5?=
 =?utf-8?B?b3BPK3BoM3lHNVBROUplN0lNcHRHbW1BL1R6WnhrL2U4YW5OU1ZJdW5iUVZl?=
 =?utf-8?B?blV0SDVMRkZmUHRDWHpDUWFMbXhTeVZUb1Q2bWNxckRVRllZOWpGczdra1gw?=
 =?utf-8?B?MlhDR09QVjJMamVzWkFCMERtWGkyVEczNStXaytWcjFHdXA5UXI3eFlMQ1dn?=
 =?utf-8?B?K0MzTVlDSEVkcGsrVmkwK1FhZzZ3TGZES0JlNUNDSUdoRW05QnZuNjRxWEQ4?=
 =?utf-8?B?SVZOWGhlY010b25yRG1pYjVQak45aFNyYXliMmxvdGZ1UmN3UUdFdm1WcnpY?=
 =?utf-8?B?Vk95RXpJcFNua1cyQmpsNlBSZmlrWEFmeG5ORVo5RVBUVTdDdXNBRk92dDFt?=
 =?utf-8?B?SE5TbUpNdExsNzJySWZvWWFnWGdqNVdKcUJ2cW5ibzgxZUMwb1JSVFhreHVv?=
 =?utf-8?B?MmlzeE83enRpZzg0QjFkTGpoSk5NRXdoUHRqYzE1WGpZYXQ0dTlRbXVPTTYx?=
 =?utf-8?B?cDRSSHc1Q1NuVXg5dEN3dkRWWGhpYnQwaXFHRUhWYjFoeFlPWGtjczQyQU1U?=
 =?utf-8?B?T0tDamd1Q215RXQ0Wi9GYTZuTG1maUkvbG1VNU5vYVlBdVR1alZZdUJtVy9E?=
 =?utf-8?B?eVhQOVVlTGZwcXZkbHR2RHNCZGhmNXEwL2NGaGc0cGdySk9Ybk1tTVhYN1hk?=
 =?utf-8?B?enN0eGJiWHF0STZ0YVhUK0w3cEVnUUpHeHlEY3pFcnlCYi9EWlBaNU1EMFRW?=
 =?utf-8?B?dVNhbzdiNGx0VHZmWmhEMUxZWkp2akNvSHhVZHBaVFEwaHBldHBZWTB4TmE2?=
 =?utf-8?B?My94VXFRN29ucnhOSFZSQUlCWVlqenhxRm51d2NvYll6MThiSEU4M01hRHZV?=
 =?utf-8?B?bno5YWRjYVBrdHRXRFBKaHR2VWkrV2VkTzVkMUZKeDBiandIMW9lMkh5OXhE?=
 =?utf-8?B?b2VSSjE1Ukd4TUZ0N3FwOTB6c0J6MHU1ZjdOMmpOUUt0SVMycHM3SDNyNi9T?=
 =?utf-8?B?N20yNzJXNmFsV3NQNkNWR1UvdVRhWEpwaXdZOFVhVWd1Q1JEUTRmeTN2V2di?=
 =?utf-8?B?MDZFMFZOWGlvRkZRL21EL1NEeEJEa2I5akNSWkNLS2dpSGNkRVhGY3crSjZv?=
 =?utf-8?B?SEY3UFJzbjd3WFMvdkxidXpYTTAxcHcxOWN0amxNZHNGbG5sdUJwOEVxbWJh?=
 =?utf-8?B?TitWcERZUXZsNmtZK3I0eFUyOTZmc1c4UnhNUWhSKzByLzhsRTFKWU9SQ2FV?=
 =?utf-8?B?YmRydGcvU3NoMzROVGpWZGQwY0pNb2JCRjVPMWJ4dFA0bDZ6RUdvbTUrdUZL?=
 =?utf-8?Q?NU1fZeBv0att1SqMLI?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 25acc621-b0af-4cf0-6669-08ded909ac9c
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Jul 2026 13:47:50.8255
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HCBHYKnc7iKKWHvUcJXrRhQ6d4EiiQZwqBhOhhh1w7x0Gw4Hu5c8W71CX1nDA4Al
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4111
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: r89z3yu95gzrtb3f1h73rtaff8uhz9dj
X-Rspamd-Queue-Id: 05713100008
X-HE-Tag: 1783086478-331225
X-HE-Meta: U2FsdGVkX1/GmmXmLv/GQNPUuZN90hGwG+th+qG9ncXg57rQpw0ZgPI7KzbUor5BG0g0QAWMy8NdJ73PVLIgSXufTRKe71E5M0GPI+FhkIBOhYdB9AHhBGwOy6GI7KdrQtEa+dnGN/hMKKCvIrpOEWM79wxXvtB9XlIy40QulCtnd1cE6m88DTPse7+sJ2o5fkSk56ANmjIRS8MvhTnVQR8AwDL6LoMYvgFmko03Bexbcb/8iBOHT4+o9XjFRQT9eblE2su/j6RYODSuW3OxGDcBbNa47BUDliOD2TeedLWQr56jeX3pYCYZQxZpB42X+0OMFmFIqrvmV5zEZUMEJZTqFGah8H/3hqsUPVWcgjwGS4X1gOhqSb5D+KzYlgaAvzQPWl/9Zw5+KJw2GHmKKndLAGerFHd0fe/2cBa848l7JvsE48CyvPIajrkR4xqpf/AXWy9jC4625TNJ8Z1OgWrqwbbeNcznaAA+MNccQlB9lSxJp5Uyl1AR8UlA1h8bSk6baF8XbovHB5ZdLlByWHGoQGxxViEqaQbyKL8rkmm0fbf9ReJLHltVHlu1Z4y5AyuM3pXf5NseyYeFLZSWvRTdO6hpSfGZL6vAgI2kvqP+HbrzoEM2Ytl6GmxzTaQjtzsPFN3mnDKfK1xltdaePFzjoADOM37AH7gWVQqrYNVTLWu6r7Bb+WNz2C9WgcRfQfIi0eiCpNykU5HPZ8hlM6pgotC+I0EalcUlh/BXSit3bHCSQ6XuJLN5SZrzRFJDkEkPVIKGUsKjpH9UPycipNmnRebG0Sl8vR225C+SGQVxmdRacwPNgpHrdEUR0xdrh8CZhhtGPxNgpW+DWyC/D88e1M+TtLNYVufr+jqpbysHeIdJPOEnRXVMe8lxlrsuvS8iuSqAiwv/XeWIwzsEYZ260gg7M57RpTwDa9iCX5H7e9nk03kKRJZ3IbxyQg0HrXu77UHQkDZoh7O4Ev1
 k7dH5Uvk
 8avvgaIV6N9oZPdhY+y+JZM2XLt3HSwBZFXuYP1W7wEApL3JRQiXPOF6aWa3FAofhirvPfNaEUlGsIokOwFGbPBRndTMn6jKExF9nWlVsc0rY5uo9nMu+8owtdGysD4jvGyO5Sm17sGy+bVVvTl2iGHxUZAZRn7P1+hELNln8Cz0lTuyP8qPFCvfexb+l6uFeKNIJFbB7Ps0PKyjpIBTFP1PFCwfnDEqIXcwj0nkg7QIGUZIZtABfWTa9IXkek+oVXqgNwMWTXuyfXz7M42eCZcDZJs8ummBQNHkcKO1wkIIhvPgH7TVj8j2xJZqI0mTm+dkROVRYpfQq3hpGHDvfC3IZWUBV7ys8L0yJJNxhgMCcxupgK6yk/uZfJBBcYhMCDyWY+0Oy4MattsKWxgfbl+KI7ByMQ6ChBT6CxzI89h2kQjPHTxGteyqUKa7rZiiAmO8+
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Commit 733aea0b3a7bb ("mm/compaction: add support for >0 order folio
memory compaction.") stores isolated free pages in an array indexed by free
page orders, it is no longer needed to store the order in each page's
->private field. And there is no code using the stored order. Stop doing
that.

It also prepares for an upcoming change that ensures subpage->private is
zero at page free time and the removal of set_page_private(0) from
prep_compound_tail().

Reviewed-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Lance Yang <lance.yang@linux.dev>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Signed-off-by: Zi Yan <ziy@nvidia.com>
---
 mm/compaction.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/mm/compaction.c b/mm/compaction.c
index f08765ade014c..9f4204853afd6 100644
--- a/mm/compaction.c
+++ b/mm/compaction.c
@@ -644,7 +644,6 @@ static unsigned long isolate_freepages_block(struct compact_control *cc,
 		isolated = __isolate_free_page(page, order);
 		if (!isolated)
 			break;
-		set_page_private(page, order);
 
 		nr_scanned += isolated - 1;
 		total_isolated += isolated;
@@ -1617,7 +1616,6 @@ static void fast_isolate_freepages(struct compact_control *cc)
 		/* Isolate the page if available */
 		if (page) {
 			if (__isolate_free_page(page, order)) {
-				set_page_private(page, order);
 				nr_isolated = 1 << order;
 				nr_scanned += nr_isolated - 1;
 				total_isolated += nr_isolated;
@@ -1846,7 +1844,6 @@ static struct folio *compaction_alloc_noprof(struct folio *src, unsigned long da
 		size >>= 1;
 
 		list_add(&freepage[size].lru, &cc->freepages[start_order]);
-		set_page_private(&freepage[size], start_order);
 	}
 	dst = (struct folio *)freepage;
 

-- 
2.53.0


