Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0188BC43458
	for <linux-mm@archiver.kernel.org>; Fri, 26 Jun 2026 18:36:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 674076B012B; Fri, 26 Jun 2026 14:36:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 624B16B012C; Fri, 26 Jun 2026 14:36:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4EDC66B012D; Fri, 26 Jun 2026 14:36:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 2329A6B012B
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 14:36:03 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 8B4241679F4
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 18:36:02 +0000 (UTC)
X-FDA: 84922918164.18.6EBCECA
Received: from BYAPR05CU005.outbound.protection.outlook.com (mail-westusazon11010025.outbound.protection.outlook.com [52.101.85.25])
	by imf19.hostedemail.com (Postfix) with ESMTP id AF70E1A0011
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 18:35:59 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=dl0uSx0C;
	spf=pass (imf19.hostedemail.com: domain of ziy@nvidia.com designates 52.101.85.25 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1782498959;
	b=zDObjDhGOjTuvnzEtaVolkyT4CLOWo/BOmUZmfe7ABqG3Si99Q3Y5gW/XSdeX/OrEpy9xl
	Mh+sLNBUEu00tpgpkHqfpX+uC2ZKkEN9Fe1Y4vIws8qGaw7f/EjDaflSiXTw7nuEJY95BV
	VkrP8LI7WF5n0NhzLxBztKnw+zb0ik0=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782498959;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XfN9pokQwdpW+ZvmQYLnaRwlDQFmIIo8dFAAqf8XYxA=;
	b=tQ6OrixCeFGlLjGJP1L1ptzx3DuPhsUSOPCXzOhbJ3Cr7LF9GsOSWPHnwVrv2tL6Eor1O+
	qd7PfOM1drV2+L3OkrpCp0xM0AZryfDAaUgrpYwlGsGW9ZqUbNscOsxK1V/1f6H+/PDrpH
	K/MC5keXCydfXVHRsvs3WCnEPo0kz/w=
ARC-Authentication-Results: i=2;
	imf19.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=dl0uSx0C;
	spf=pass (imf19.hostedemail.com: domain of ziy@nvidia.com designates 52.101.85.25 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=HdyFPfYuerHfOQ4h9/TZNFu1c2n8C9QqTU2gxKqtRKoBPONeNzPYJWjCrtfUuVg8fVUYAUDQ3mEFDy6WZ2K76lJjP0JgeO5E7w0kVznswArFpq7O8j9uQBeY50VrBbzG0K4vz/iOOjwMAAX2UbHmq0I4nxkm4f5xUqUjnoC63ZfbJwYfGoqvdtMTQ4zrDXY5ObN794WPCt0+W9CxK1LCnwZ1j6r3OZ3LnDqdnl7jL5osbZbc6mxop0eSKowkdj9MY//D3LnbMmRtcoxp3iWZ9WBdy0XA7nxoWNC6jyUpdIs3A2YQ5BZTLB/biXSAfR5ivWg102BZB5KpZYtb+Bekvw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XfN9pokQwdpW+ZvmQYLnaRwlDQFmIIo8dFAAqf8XYxA=;
 b=QHohRvyF8Oe4SZtgDVeQt0cgnW0XL4I8kcJQXj4oNCs4NFY7lA1Ofc/DmRONbb3XIuuCyIPN1qbgr2lVS1LE1rNZ6Tio4IARyxIl+jfycw4ybXIIS6fK8DGPq/4ekik3KPgWMatfxU8dFmupBr8/SMfhvRFKzJZTA0FvSRzeWu97CRsCYgyBuL9QUAVI+IA8ri8zeEo8qhpIvb/Uv7wDmUl4ayjT4txzMf4RCherxudNle31v0VFyB4rtvdvM1gU1jxZ3R6/bURBfLSWaIYLzXmCyuQaVEw8jq57eATJNQN6JnYfhmLP6fMkH1wVmRPXO4jF6QjZQD7epeseIBtrrQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XfN9pokQwdpW+ZvmQYLnaRwlDQFmIIo8dFAAqf8XYxA=;
 b=dl0uSx0CmznXqSAuklJtK7KlBrf1CzMk6gznyCLvyEiXAFuZYR7OBbyZWJctWtMDXtEdheXD1mgowSqzB4WrkSz180bO5vv8rqZ9XBVXh+z8wOkBqXUrWoHTFvyzaDqTlhlzf2r0AWobXbsSo7NPGiihNLI21AXbkDjuZBktd6v12DtjqYp565MIyKEs6nTWA8qlcFKo17AzkxbxhyQWDkKI+kqxFh74tbbII+6RQMfTcM8IM943GGLKz1Ex/oA7KX5kzwOqIiE6dLlE2iqGxaX5Grj67proYHMcrjrZacpCVZ+L8EQla4HCUfdLRoxFvEPs1vEOna4k1DQb3ytKaw==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by IA1PR12MB9497.namprd12.prod.outlook.com (2603:10b6:208:593::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.159.18; Fri, 26 Jun
 2026 18:35:56 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%5]) with mapi id 15.21.0159.016; Fri, 26 Jun 2026
 18:35:56 +0000
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Fri, 26 Jun 2026 14:35:54 -0400
Message-Id: <DJJ756YZMVQC.1FGDLS2UJ6P80@nvidia.com>
Subject: Re: [PATCH v2 1/6] mm/page_owner: extract skip_buddy_pages() helper
 to unify buddy page skipping
Cc: "Suren Baghdasaryan" <surenb@google.com>, "Michal Hocko"
 <mhocko@suse.com>, "Brendan Jackman" <jackmanb@google.com>, "Johannes
 Weiner" <hannes@cmpxchg.org>, <linux-mm@kvack.org>,
 <linux-kernel@vger.kernel.org>
To: "Ye Liu" <ye.liu@linux.dev>, "Andrew Morton"
 <akpm@linux-foundation.org>, "Vlastimil Babka" <vbabka@kernel.org>
From: "Zi Yan" <ziy@nvidia.com>
X-Mailer: aerc 0.21.0
References: <20260626024550.25677-1-ye.liu@linux.dev>
 <20260626024550.25677-2-ye.liu@linux.dev>
In-Reply-To: <20260626024550.25677-2-ye.liu@linux.dev>
X-ClientProxiedBy: DS7P220CA0075.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:8:259::17) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|IA1PR12MB9497:EE_
X-MS-Office365-Filtering-Correlation-Id: 711073cd-b6e5-45cd-15de-08ded3b1c28e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|23010399003|366016|1800799024|18002099003|22082099003|56012099006|11063799006|4143699003;
X-Microsoft-Antispam-Message-Info:
	T/ZGErpJZSBADt4fJ5upKVZGP2PwY6qFG+l0pn9d9GahannNxOgPZNvZRDD4mfoOtCShlenGRnjGgaOxAKgJJXhORW2BEi9AMFyGKsHwxzJnipKCV8dXGXJ8aMnBfCa145rA8DNYNaFu5GQivWfS5HwUxaFQ9vpqCegMloWjIBGiT72VrPyhJMqBoOe1QPrFhh5Y3BWaFgPuuRmXr9eXrRFlkdpC191tLN5SYttxWSqIM6lEFJRc9g7IMax3afKasgYkiv+9phxldww6tVMBvqHrhCu9lkPxIvwgJQYS11Z63my5ZsHlrDz3YjjUVJbj6FQyv56x0CEiYR7TjuuBadiEMJ2NDRoWz6nKvfXfVvOei+0YVb0WaqufcevNTcHIVKmPFAXZpKxACWHXCfMVml6gfI0xOOuBOFMXNFxPhAUo+6JCAyiEjakGkJE3ZSSMPfsHfOaEvsWl/U6nmywAL27GXjt1daFYbmUMFg3idef/GseMP4Y8yEfHojP6ioLRLpvLA8gcy64bhx7eP99TQbM+1dA3dLmjiH26oXvbm53zyWPktCLna3d3iQAliKTsbJpTrbbe4EVO2iLtl0x+qkqsZKyoquLgOPMpXwuJAY9OevhqfthWa7kT++4qE8MKBVb6WgFueMmjRaTMdKW7X88KdbGUAsB0Py+5fZwogX0=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(23010399003)(366016)(1800799024)(18002099003)(22082099003)(56012099006)(11063799006)(4143699003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?UkdOYUtKb3laVEgzeFVkeGFlWUk5ZUJQUGx2MUxPN0lCQi9SdHVHU1VXZHFT?=
 =?utf-8?B?YmM3NFRma0hRUXFpOExVSCt5ajlqbWlZc0k5cGtxaVlhWU5HNFFWRXN4NHYw?=
 =?utf-8?B?Q1JmMmlqSEprbHh4M1R1VmNKVlI0NkxLd1EyZU5IaVBEcWVKMTNsKzAwcWJV?=
 =?utf-8?B?TkVoYVEzZ1pvamEyUlVkQ0RVbG9MR2VUSGNoRzJrT3B6UE10YTVDWGRXTlNm?=
 =?utf-8?B?YzV1clQ1SjVtZ2cyVUszd2NXWWIwMzY4TzVmQzdxd0tEa3pQaGkrbE5CL3I5?=
 =?utf-8?B?Y1V2K0NsdHpJbS9SSHl3UEl5OWczcW9KdUgwZkFzbTFpbnBWbW56SU8wTkti?=
 =?utf-8?B?Y2ZXY29VM2lBTGRuYU5LSERZT25rOGlMTzFQc1FTQjFLK3ZDdURuQ3NnWXVp?=
 =?utf-8?B?TE1QMXdvSHM1bFJMcG9ScGtMbXpCZkRqUkRLaVlpU21vTmlKS3dOWWJNSkcz?=
 =?utf-8?B?cC9MRnJZcnVQOGsyd0tiUENXMW5mMFBtdHEwdWpHbTRFV0lyWXJPM2VJY25X?=
 =?utf-8?B?Z1JzSHR2TExIRURwOUhndXREcjBkRDFNdjdzQTNmTEZscm5pWFQ0MmJQbkRD?=
 =?utf-8?B?eXZ4angxdXljQzlCclN3NENmQkR4eTBKd2MzS0QyVVl5UHdGU29ac3REaFBW?=
 =?utf-8?B?NzVmWngveWIrSmcwUzdiRWZUSm5GZVpyZmtRYW55VEVNRUhxemM4TzF3L0xa?=
 =?utf-8?B?N1gzemRUWnUxY2xJanNFekFkSXlITmJHeWdWQnV0a1JnNFcvd1lWUFZvZHdT?=
 =?utf-8?B?WFZIZFBMSjhiZUJqM2pSMWp4TXJ2dndqMHJhemt2L0JaSzcwRmltYUREby9I?=
 =?utf-8?B?MGFjc2laaStucXdiNE03TEJyaXNIdTZ4WGV2NWpFb1VzN0lNdzFqYVhMeUpu?=
 =?utf-8?B?WkJxVHRTTk1DWldCUEc3UlpxVHY4MXNQN1VkK0puQ29XRDE1cDNLKzdCaFRk?=
 =?utf-8?B?NEdvNS91NFd4em1pM2RLRWs4Zjd4ellpSVBaOXl2Nk5oS2ljMWozU21EZTZH?=
 =?utf-8?B?d3FWTXFRVEthOVV0TVV5NkE3L2paWHJBY3p6V1FMVlNOTVZsK2w2bjVCaDJJ?=
 =?utf-8?B?UWRMRzNjVkRJSzFxSW9YMVRDUkwxbm1BZit0K3lINmtHbmN2L2lQV3hIOVpS?=
 =?utf-8?B?K3dUU1dxK0NBaDdLWUdQQk9VUXRDNHhmVG4wQUFlNWN4L3NpQ1V5YXRxZEts?=
 =?utf-8?B?U0hQNXpVUVNsZ3FkUElTWkZYbGltTjdFU0dtYkE2K3F3NXNGcmVPcFhYUkw4?=
 =?utf-8?B?VTlCV3JKeERaWkVoWXZLakZ4U0lldXd6cSs2Sk55aDMzakk5NGFiWDNnaUUz?=
 =?utf-8?B?YWp3TmFscUhzM1hHYmZsOUM0OWd3NTlrT01EYmxNTHMrQm5Wazc3UDNPMnlP?=
 =?utf-8?B?WCsxRyt0dE9lbWgxUyt6eWppVUdQcklYWWQ4TUhDU1l6R0ZhYytTTkNSdUdS?=
 =?utf-8?B?cEVXd200a3luc0tDeTdCR2VqWUdwK0swbWQwVnRwL1RqaFhpc1YvcVN1UzNW?=
 =?utf-8?B?MXMyNHJRMDBKdkEzT2dZdFU3eVZFNENxa2VQckdsVU1Oa2xkQkMzenhRa3hY?=
 =?utf-8?B?MkV6RWNXS0x4Y29vaTZVbThjYitndXl3Q0xYcEJHRVdvOTlYV1hTbWkzSjJF?=
 =?utf-8?B?ZFFkMU1sekVVS255YUdFR0R0TDQybW1EV0NxZHlEdEgvQlJ0MHlnNVVqTlpL?=
 =?utf-8?B?OFpRRjVMOTR2WWtMeXJScDlUMUw0elBXeW5DZ09ZR0ZQaFdXeTllS1JyeHU1?=
 =?utf-8?B?aXhsWlBaOXVZRi80dmpxUTcvZkd6OFAvU3RXUVk3MmxjYWp4RFdYREtRTStv?=
 =?utf-8?B?V3VxTklxRHJYUEQwQUJWWndvN3JpVDVMM0lzVDVpbjN4Ym1QKytkZnlVTHli?=
 =?utf-8?B?ZjZzbk5HSmVoQjhZejZ5U291Q25qWVlxdXlPSFcrdWVYWlJ0cS9XV2MvQUFT?=
 =?utf-8?B?bmZiZjlnV0lwVXduQk9UQzhrZmNjQ0hEZ0Y2SEsvSjkzZWdtSjcrelVKdm1a?=
 =?utf-8?B?cXQwNExwU0dVTEVsRzV4SkdTcXkxMHZUSkFDeXdMY3F4VFR1K3JnYUQwajU3?=
 =?utf-8?B?WWZUejluTFBlakFhUTl3L1R2T000ZFhadkRWQkVyOWR5QzlCdHhUdzIyVWdO?=
 =?utf-8?B?bmEvaGhFUlRoaDg5NzB3VHZlb2hZaVYzM3hMbDdCL3FQRXJONTNpbUdUcGVW?=
 =?utf-8?B?bjM0M0ZsNlEwamtzMml6R2UvdUFsM0x3ZjdOVW44VTV4cTNsNUllUGxYWk9L?=
 =?utf-8?B?N2FSUEpQNWxMMkZrY2RQamZxekRGWnU5M3dXMEM5dUpscVdZT1dkVnlLOTg0?=
 =?utf-8?Q?TAgKD929/TErq/NzJ9?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 711073cd-b6e5-45cd-15de-08ded3b1c28e
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jun 2026 18:35:56.1182
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: w2Wi/rHs+ZZKM5Mmg3VXA01aKR5d2uSdjNZZLypsLJmw/UlvaLL5+PMgp7fr7nJS
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB9497
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: AF70E1A0011
X-Stat-Signature: h7rx67fdxfxue3oq34rk5exmomoy1cuo
X-HE-Tag: 1782498959-507960
X-HE-Meta: U2FsdGVkX1/4s9IvaU4jNfwKWVqljBYmjulOrYOsyFoOW2TzdEOoRq/qrCJJWonrR6yjWpbpj+4l8UJnBDflimux6U+Yf44oeEjiTMwhOjOXn/LSEEDhQcNca8T8vwlxhm7/81VO8tk4CyHabMkotJxGP+/AlhaeQNlbAKhKeYOnY1Oe594MjWaxKJLDCGw9m220mbs1QXGY+8ANMnNyn2bpBadzP6rvFaKtuudcWSEAp2oIIYBsywRqVlmrH6nTaH8eOfBbUmpBm1GV55rduVwrv12KRQImjhnjyvAeyepLIzpRpeiXtkTk1obrD6ImsyoGytEPo4n5HnXwCmATyt+M/v9OLfVlkDq3JS+iw3TVqvRufoY+uYj4hNw8qTtlzJ9eLOIllTsCAxgJeeUaoafqH3Fj3zrYAo4BFzSVscYkhj4wloSBMLc1HVKnhXHlRFPTzpFUiF2LcNRiB4h74IOR1nUPzcnLs2BneFT4J/V7aeIcfiELH20g7dMZTUt1SqyZl9npc6pMcqR/wmVklZFixNbWw54Qj/nzw+PT8xlcIr97i4/qcDMuiRoWIaqgXfV1RIirwYMT2y29mLmI4ZDtPsF+xAp+ZNGSNbYb6/kYmeHMJXZ2R9jQvjJQPwPeOt2mJUC6HuL4hIC02L6APt2+MrfiL7FX9T0t8MLEDqLjFdKstrr3Lgj5U1eub9gyJrEAF5j5hJdciKFQaRYV2wVtsWO1Hnd7MtItx50jbiGq+v4qh2MWgGqLtbtIf1fKGYB29o9B1j+R+bLQe24zLlDvGDceGJyAeSlBPyNpxLYpteJA+oBwI5cGPO00/zcfiT6lgy5+pAZA/KEV2v0j9n9OHgYwsagUrfHFl7K0Bhwp4i2ZX8o/mO4C77jwwkm21KpUwMBafTpPXlmreK4nwGCbOs76RC25DtbMUqA+NyjoN7ipm7TY4zkfqXUseGWBZoWH5cmS7cOgyM542HK
 hn2G6BCj
 vW0XP5it5DJaBLgBlNNmpLWXrPKsvTmmKvUBQY7uwLyoepJbt/BxaMZUu7yMnnQElTagJ+G6HW4OIPR5cv8J3+GIPPrI8bxiFDbwVbhgPzqIwI0Xk0swJB0+WB0mVZfR5lplBiKRNX9DFmiNW5BoptDs7Z9xw4tDreUO0U15Cx7x2pbOXmLyfurwLxgqWCvM+wmuiyrLk76uEhqTcO0xSWAtMPs3HRTLOCr9UfXWiH/5LwhGOcBnh5ekrpYiNXUNY2ElEqbU/R4aOn+QVk43db/n6FgsZr7JG6Tqg7LGyzCM51lC6FUAIyqzkfMfYy80D7j8NgcN5jTdZ6xWkD34Z3RZ4PjnEkEXD2RN3HxZUEW65S+pe+AdFZsEKFKMbnNdHk/fxlkU5d8MpzsOAKn9gkU45GVVR3knMNGwgOmkbbQvaDslQpFKd24XWUYnZylNUC5CS
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu Jun 25, 2026 at 10:45 PM EDT, Ye Liu wrote:
> Three places in page_owner.c duplicate the same pattern: check if a
> page is PageBuddy, read its order via buddy_order_unsafe(), advance
> the pfn past the buddy block if the order is valid, and continue.
>
> Consolidate them into a single inline helper skip_buddy_pages().
> The function returns true (skip) for any buddy page and advances
> @pfn past the block when the order is valid; returns false if the
> page is not a buddy page and should be processed normally.
>
> The old init_pages_in_zone() variant used "order > 0" as an extra
> guard before advancing pfn, but the continue was unconditional and
> (1UL << 0) - 1 =3D=3D 0, so the behaviour is identical.  The comment
> about zone->lock is preserved in the helper's kernel-doc.
>
> No functional change.
>
> Signed-off-by: Ye Liu <ye.liu@linux.dev>
> ---
>  mm/page_owner.c | 52 ++++++++++++++++++++++++-------------------------
>  1 file changed, 26 insertions(+), 26 deletions(-)
>

LGTM.

Reviewed-by: Zi Yan <ziy@nvidia.com>

--=20
Best Regards,
Yan, Zi


