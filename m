Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9E342C531D1
	for <linux-mm@archiver.kernel.org>; Thu, 23 Jul 2026 13:47:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 97B196B008C; Thu, 23 Jul 2026 09:47:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 951916B0092; Thu, 23 Jul 2026 09:47:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 841CA6B0093; Thu, 23 Jul 2026 09:47:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5B08B6B008C
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 09:47:23 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id EB0B58033F
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 13:47:22 +0000 (UTC)
X-FDA: 85020168324.02.1E61ADD
Received: from YQZPR01CU011.outbound.protection.outlook.com (mail-canadaeastazon11020122.outbound.protection.outlook.com [52.101.191.122])
	by imf20.hostedemail.com (Postfix) with ESMTP id F146E1C000A
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 13:47:19 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=efficios.com header.s=selector1 header.b=ga0dRTGb;
	spf=pass (imf20.hostedemail.com: domain of mathieu.desnoyers@efficios.com designates 52.101.191.122 as permitted sender) smtp.mailfrom=mathieu.desnoyers@efficios.com;
	dmarc=pass (policy=none) header.from=efficios.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784814440;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9/GitQjcGH2mIiNI+a7xN9/s8PzYXfJ7Jl66civdlFU=;
	b=tVBj3oEOtuLrWo5vELDWjNtpOErda5F8yFPpdc8oIW3bYUddPZVKPWlWPdcUBkUvPkTSXt
	U0WzWVgDiVAtc8Ep7Yyfz/7WYUe9qk/81PnhzOfUC7cfS/jpwi9ad3OJfqaQ47C7lcifII
	rlNzRyDE2FZngmgMua5J49ksEaTcTjs=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1784814440;
	b=iVex0+EKR9tX6F2BrfA9HahJ0dy4WVKtaq3aDuHINhJYcTEBUOMrIr/rz11HnGujU/gNKI
	nZW4aTyFxYCeybxEfx9Ngn334I/I5Vysi2kWaBkuAaSxtGryNNhr2A512S5NDiUxiGUc3j
	gMiPGPD1MfX7Sfkt8nHp8d+TwAYH8vI=
ARC-Authentication-Results: i=2;
	imf20.hostedemail.com;
	dkim=pass header.d=efficios.com header.s=selector1 header.b=ga0dRTGb;
	spf=pass (imf20.hostedemail.com: domain of mathieu.desnoyers@efficios.com designates 52.101.191.122 as permitted sender) smtp.mailfrom=mathieu.desnoyers@efficios.com;
	dmarc=pass (policy=none) header.from=efficios.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=XJP+I0Ase6a7RvEA9sseWncxnFvAU+7BRVy4iQNGhKamQL1pQLMGIVsFqL+g94GZuZ1yCgYtaRAJypc54qsw0HHB+mpulhIQAcZQiWqz8b3w3WDrvNilNvYjO6LDCiJq0t2nhvqrHoUetHBtLVXh9dFojLk9WrsY81WSjdXTVx6Zbqy3pes+Uu9smZbzKk4dCywpUCGkXbMHFv0G35jRCm8zAXYlz/NCn7qBNcNhfylPEFP6wPsKjEkVw6e6A3GUd1yQ6ztsMe+8qEfQfg0QF8IX5Zzo8ptwEGQyLjqpwFomgQ1MjytV/bGQ+OJPraVuBaDNur4tAFrK0I/OpUQzLQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9/GitQjcGH2mIiNI+a7xN9/s8PzYXfJ7Jl66civdlFU=;
 b=igF886IP/7p+FUY0KsVy20mIJxNThbWJ0j1U5Ygi4GJLtwx1g9k/01SDZxGUnbWkoa7K62yZet+45GKcAWbP3u0nEcz2MS0DVqJFnW1x3krs0SUpWsQf2pr0te1OXVkQ336UlQAu66b/TwcnpjhLLawnz1X0glPrG9el2QYwDzZ87XtUcFaeDtHEsfuIUyj1ffFVK8hBbh7q+DbKteIXUZJPnt62Ru/s7aGJBgAsfgOaX6vFmt/kTAy4N6HnVG55xIPaUcwINoFRjvVt7XwraU1LbjVhE6Hab/nfjE24rWDFDRa4tBlYlqLfATzONjgwGNjq7c9i8fqopSpq9vuX0Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=efficios.com; dmarc=pass action=none header.from=efficios.com;
 dkim=pass header.d=efficios.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9/GitQjcGH2mIiNI+a7xN9/s8PzYXfJ7Jl66civdlFU=;
 b=ga0dRTGb8m0RVU3+Wwf6v43fdu9dgKwHG27YOdykGs09fOGaTkSEngv91XJZ3T8nseb9J7AjVgRRwlIvsEDdsIGAJ5NxINvlrU46IcdJ3xD2uq8oxpy5kWQuh7PEUHzmnT1UdvH1iWcUbixLWQENVCPKxmPnAgEekmo7cgj2qkPBSoj4wma211vTSpd8qZo7Aur11jhW53nWRbmerxQgKo+TR1KWzbfyxlzRx+jO6lCK8zB+Otg5U2x4rZuju0yhRHtGZZbFGkJph1p+huSx8s6NYiuO/LW4TwgYVBTWhamr5WpomHCS2UEfEu5f0hk8f4x/vYPWcGdhADY8zSKC1w==
Received: from YT2PR01MB9175.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:be::5)
 by YQXPR01MB5739.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:c01:2b::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.245.11; Thu, 23 Jul
 2026 13:47:15 +0000
Received: from YT2PR01MB9175.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::6004:a862:d45d:90c1]) by YT2PR01MB9175.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::6004:a862:d45d:90c1%4]) with mapi id 15.21.0245.010; Thu, 23 Jul 2026
 13:47:15 +0000
Message-ID: <bd3facf5-cc4e-4fa3-95cf-0f4aa926ae23@efficios.com>
Date: Thu, 23 Jul 2026 09:47:13 -0400
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH] mm: use precise current RSS for high-water accounting
To: Nirmoy Das <nirmoyd@nvidia.com>, Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R . Howlett" <liam@infradead.org>, Vlastimil Babka
 <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Shakeel Butt <shakeel.butt@linux.dev>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, stable@vger.kernel.org
References: <20260723134158.1473841-1-nirmoyd@nvidia.com>
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Content-Language: en-US
In-Reply-To: <20260723134158.1473841-1-nirmoyd@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: YQBPR0101CA0313.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:6c::26) To YT2PR01MB9175.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:be::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: YT2PR01MB9175:EE_|YQXPR01MB5739:EE_
X-MS-Office365-Filtering-Correlation-Id: 6d5e595c-d220-494d-81e6-08dee8c0e7a6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|7416014|376014|23010399003|1800799024|56012099006|10067099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	h6TZp3sUszzVi37Zc21J0dz7w7HpHhfnGCua0FnD7XllmfvHDqa5FVrZFQu/XCXtfguu4rLOI5jHwapIahRiVJRCz2adcOZFW5LkUarE/NCIbxqStAT30U4zIpNhtoXGtCHoSa/PkB8zfd6cLVLOBfBIZBCj6Boq0z7wbSpKQ1bRQif6/3g80dvcJFHP1Zn8Bhl3ZAmwE0gZKUI60/jeyOKYq0hzycPUHPY4jz1iX3T2aguD5QPGtJTVgkMfs6YWH9gwTM+HVbcTJ8CccFzvomuWQ8gyPAGuug+ZXUPT3HZTaNk87U+KQxMHVHfczxpI/fNPnjLQ+aF9bKLDyWQy+P5ik88i/xCsdGQqzql4vv+P6d6j0GmYe1ZjzNjv+LEX8qMBRZlHWff/u1WgOs91cG20dIsdL2wEp3A7ZGk73pH2W0xt8up0XrVG88qKQZYIqQQUOROHSDy0vpdklrVZtHSYGi/ti+FoxM5VsCyLQQeCVQ9Tou4cZh94cETkvb9ci/oIyxPOZ7fjU3Xwu30hOptFSLvbXaB9iu0CdIyrW69RRyt2bX8XUZScCPLWSeWQi9FY2NRWD94r2r5VOlKooG2Hox8dJvP9Vfhn0NJuIrc=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:YT2PR01MB9175.CANPRD01.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(23010399003)(1800799024)(56012099006)(10067099003)(18002099003)(22082099003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?Z0d0VVVlaDBQYTZwejk1aFlpTmpCZ1NXMzVtVnpRaXJrbHpIQWttRVhEKzYz?=
 =?utf-8?B?ajE5alFnOGJseHdpRjRqT1VFTGxldVRBdTZXNzJXd1BMZ09sWk0yYjVVdjBl?=
 =?utf-8?B?REZjbHhIVkhJSkpTT3RySjVaU0s4bm1zT2svdXlPMW9kaUFwVVNzaXdxRUsw?=
 =?utf-8?B?UWpXODF4a25RMUc0Y0VvT1RuYitESHArdHgxNFdRaCtSMXFJaDgxeklTbmdH?=
 =?utf-8?B?RzJGSXpiNjhob29SOWFzQzJjUXhQeDc2TDUrTHNaT0JCRWNRRmJxeXFEempY?=
 =?utf-8?B?Tm1OZ1hLMFBPSGxiQnNVNnE5Q1Z5alJySytBWVZkNVVJNE9rUHVXc2lKSmdr?=
 =?utf-8?B?dUhkZGZiY05QUlhIYU1LTEV3RGZxckp0VFlReXlUMHk3RG5heEN0a09SKzN6?=
 =?utf-8?B?KzY2STlacTMxdHhEZW9MSUpzZzhzMG11VmdMTlJiR1V3Wkl2Tys4QmUyY2Fm?=
 =?utf-8?B?NWJIZjBGU0pUQkcycDgzU282ZHlrc2FXK1l1b055cUhJdzFRbXMwMUdzVjBU?=
 =?utf-8?B?MWlDS2VSNVdxaERoMlprOGFGdG16bEk3MzhHRXo3YjNFYklQb2h0Umo5OGlK?=
 =?utf-8?B?d3h3ZmpZYnlidWl4eEU5cEpPMzB5OGFUTUhIMEUvSnF6bGVjTkJCUllPdDYx?=
 =?utf-8?B?WXBDRUtVUUNmYUE4eGIxYzR6RUhxRThXQUErWENvcFpGbm5DcE9PYkdnbjB3?=
 =?utf-8?B?VkQzUktGaC9sQUZEUTNuM0VOblI3UGRDdEFTRmtZNGJYRGhJMVRSZXlHSXBi?=
 =?utf-8?B?YWNNcDFEM3IxbW5YRWw5cjRsMktiYlk5b3hpeXdRL0EzMzRyVXRXelhIcVdW?=
 =?utf-8?B?Z0RpK3dpUzRoL1BCNStRZmtsR2ZoYkhxTmhhaXZucEFqUUZCNTd4YisvZk1T?=
 =?utf-8?B?eFlVMzAvMkRPRk94ekJrU29oR2NBa2Q1SzZOdUloNEdsSGYrMXNOM0lJN0tS?=
 =?utf-8?B?cFB6a3pURDZzN0xzK0krT25YSHNQSlNacXhPc1hyN1lLRHduV0dxOFdtbCsx?=
 =?utf-8?B?ZWo1MWk2TUJPZHFROUhvT3FXbFhkT25LOWVMZ0pTY211TTRQNExvNExUQnFE?=
 =?utf-8?B?ZXY5KzZyUGNzc00xWnExTGh0WVZNcENQZjV6ZVc0eEh6NytYSXBna2IxRnpk?=
 =?utf-8?B?dWpBQXlQa09aZTFRTTlmVlpUZlJRa3M3RllPV1JxeGhRTU1CM3NTZDh1RVB2?=
 =?utf-8?B?cmxQeWRVSGZobTdSdVozc0JHczlmSmpod3Yzdmx3VkR0TVlrbWcvV0tQVFhr?=
 =?utf-8?B?N3B6NEVFcVdHSjh6TjZ6NWlES1hoWmkxM2hFSjVVbFk1UjdZTFZoeGRUTE9F?=
 =?utf-8?B?VC9EN2wxRHloRFVGQld1cFVaS0JXeS9oMVE5NGgwS09UaHVOejkxK2RiaWVD?=
 =?utf-8?B?Z2tPNWdvUnhPM0x6b3ZMeXBvR2xmZ2Nzb0ZBbG5rN0F1ZGo1Y2NKcXN6Mndu?=
 =?utf-8?B?bmN2V09qUTBsaldiUkFIWWlna2VjeDVCSE1EZTlpU1cxSkE5NUJDRXpRamhG?=
 =?utf-8?B?Y09xWXM0blRkYjh2KzBFaWVsZEpoY29FeFl1UWFnSWZEWFhFY1YxblF0TXNE?=
 =?utf-8?B?dkszeERxWXZ2ZHJFK2dQMUJPUmRwSUZoMkdFZDhlamdNR0ZkQ3c3MDdOdldT?=
 =?utf-8?B?TkNaQXlQLzVtcTVOdGNBMWJvU1FBMEhHNUxzVmRUQzQ5eml2OWZ5dE8yRDhK?=
 =?utf-8?B?NUNKbjd5aS9PZ2U1SUozakp4Myt3dGZlT3RqaXdWNW5LOVhqQ2RLSjROcWlO?=
 =?utf-8?B?L1grSzZwS20wc0pYUzk1cUZUR0Q5OHYwZUczd3U2TTlNY0NMQ01HMUV2ZWJK?=
 =?utf-8?B?VjVjQldkbUVYTTlUYXgwd1lzNUNMdG1Dakk3REJab3VPcDlLakNMQmt6UHN6?=
 =?utf-8?B?Mm03clUwbTZOZUpMUkVlV3E5K2Q2bmhuUFQrMGdrTEZJck02N2x1a3Z1MVRx?=
 =?utf-8?B?eHJuMWpqUk1sNHJFbUNvZS9zSHp5YzJwaHYzaGF3dlZGbHhkQmc1OVB1c1Jr?=
 =?utf-8?B?d2F6MHVZcFpjdnJvRE5hQzVIWFM5eWRRQ1pWOG1kNnlRZUNTSlcvdGJBU0tW?=
 =?utf-8?B?RGNtaTdwV3NtZ1NQN2tJRWM4bTV2VHdmWXQrbC9QSEFvVm5rUkFsTkVGanVU?=
 =?utf-8?B?VVdraXRaT1psbHNIZDBaYzVjYXVCUFkxRWJrZCttTVFkOHFkZW1IR3NHK3ZS?=
 =?utf-8?B?cUFzSDk5enpDdWVweXFFdVpWOFFRK0R0TE1wd0hkV3E3Z2ZDdmduRytScC9G?=
 =?utf-8?B?YlRxTmxhUFlVZkZ3aWRkcFdKczgxa3F4ZE94ZnNaZnBRMUVZYkFWZVBZNi80?=
 =?utf-8?B?NnFsZ1d4TjMwMGpZS3BFM2dreFRKMk1KbEtXbFgySlFMYWVNb0ZXQytkSnZ5?=
 =?utf-8?Q?Ojnx3omgIosahcjUNEh8yLgj9//mV5/fMXq0y?=
X-OriginatorOrg: efficios.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6d5e595c-d220-494d-81e6-08dee8c0e7a6
X-MS-Exchange-CrossTenant-AuthSource: YT2PR01MB9175.CANPRD01.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jul 2026 13:47:15.3113
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4f278736-4ab6-415c-957e-1f55336bd31e
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: P2NHAtVKUYvgyZhqVJKvB9yieKpvWbxH5UtrZenmukdtibETilmGS/TdnPyJJ0XBPwxHIwOfs5qudIWuVP4mWstHNVlWwRXQjvPzrbApuVY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: YQXPR01MB5739
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: F146E1C000A
X-Stat-Signature: cgwgrhdajx6hpoetusryjg9keoxq1h7u
X-Rspam-User: 
X-HE-Tag: 1784814439-593356
X-HE-Meta: U2FsdGVkX18NwVk73eJ/mchG6RWaDXk5lmCRIbZFW6e1y0Tcc0S/3JJCugsfGaAASDLpzK7DubgPfF2nFi9KlQTJVHZl6lVXlgyBzSIqBRSmZXa15437wJ9eLy7QqvQHBwDIZXj2D9fpoawPkbe7xpNXG7vj19uNCDoMNch3zvymxp+NhAFDRLrjb0bhN0cAxdcgQdzZ+ekERTDGLqvu8nfq+pxAz3wgFEc30RMXhsVTpVsXGrrumdZcstpOUQAM8WEtIHcXkQARkz5ohcjvttWypij6ZiZMv5cda9jyTXXnECEYi0KOEYKB8vVIju/orXYT0BGSPXJyCf82k2ioViJpQSnCZAkOxEuP3rquEnZ9OT/lijjJObrigM/j4Puv9rqYYvGf5Q06l/2jQPxFxNflhRzFf9KR6257LuNVvGPLRLQTGUQaEMCt6erILjUUF6aatEaLKqZvRsfZbGVZLRTnVzg3hMpnRRMZIebufr2RaCSM5iiGrzgFdX+wAGy1QnG3VAcRHG9vpb+HiDL1jEyXzGywmtKxLRLkKxRcfY0gmpe1wlf284sbDwjHgnsSiulgf1im0kW+Z1HsZ/9CXqVLPBAsMiA5Ip39I+X/cNWdCzeIXe68yizE7POAscgw3Rq+EflIm+sQY1t64uxIWGZNSKmVgeYSi7mS5LsYzzc2mY/P885ogeb3qpXlHsiQ9M+SFGRX3oYjcyvcHb4SH6vTl2Te2D/eCP0XdQGU2/0DMcFz9a0SVJclX98njMO66C4k2l+y9Msm/peggdFxJ8qiKcIAyllvusmB2ZBTn1v068wha+UuOlr6T5BXQ9OVG32jK38BBNSQQ3B9mvhstFhIaPyoeXBkL7o150BQ+eMekpAtD3V55gS4KJbvLXe+pGXX0uuAlxcQgtt42cADfHKQOlUobs1lXIkTaXfLsXJouzoptN6sEU2spLeNX0Gb1qu+6mzF6Q1UulFAafd
 whMTO/9S
 UoHJnxl63qOH3iyUVeO1yJPHNmnvuB8N7yZnKLQn7QE7v5eRbAtAdtpdl31FmgqKEfxFKHO2zCTLplKmqwENBDeMJrpKzihz21aLrI5vXr20N9C7n/2sariEcxfDZduC7A7rvAOWVgwhNs7pZUcUFpMNP1wI8PFL7eeAdv68bWr8uiEtxsuTBoaVGhoMC0MgP79uNRuJgu8n0RuWFb+Ni3JuCTr6tLXhf6fdK/vkWeIuGkYz+yqL+pNTReRb70GXIOiZtcxpS9hEKg7Mpd2vJStau3MAedRFY5L/bWvWWyJ+uP6u3tHHx2AFvSThH44Kcp9VKmzPIDkO08CzOiZ7pmdZoBXcHLElbeZzM8yh7LYOCnwy2+NO36PI/jiCYOVGu835kpM6iW4ysds4MCnYdKyG2tsxwqh3Hn2v1JLpZBkKh6639dnUVk36BY6OwfVIZ+NwgcpwVraxzklvvfGk/hA1GCBHnsgmzSNqaP4gdTj3iA5yyJm8K2CQY2nHmCxHOOTFFzAHNK80WXVA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026-07-23 09:41, Nirmoy Das wrote:
> get_mm_rss() reads approximate per-CPU RSS counters. On large systems,
> this can under-report the current RSS used for high-water accounting.

Did you compare this with my hierarchical percpu counters series ?

https://lore.kernel.org/lkml/20260707131544.75906-1-mathieu.desnoyers@efficios.com/

I've sent it to Andrew two weeks ago but have not heard back from him
though. My series attack the same issue you are trying to solve without
increasing overhead when reading those counters.

Thanks,

Mathieu

> 
> On a 352-CPU, 2-node system with 64 KiB pages, reproduce with:
> 
>    sudo -E env LTPROOT=/opt/ltp \
>        PATH=/opt/ltp/testcases/bin:$PATH LTP_TIMEOUT_MUL=5 \
>        bash -c "cd /opt/ltp/testcases/bin && ./getrusage03"
> 
> The test failed 10/10 times with child.children=270336 instead of
> 307200.
> 
> Use get_mm_rss_sum() when reading and resetting high-water RSS. Keep
> update_hiwater_rss() on the approximate path because it runs before
> RSS-decreasing operations.
> 
> The patched kernel passed getrusage03 20/20 times. getrusage01,
> getrusage02 and getrusage04 also passed.
> 
> Fixes: f1a7941243c1 ("mm: convert mm's rss stats into percpu_counter")
> Cc: stable@vger.kernel.org
> Assisted-by: Cursor:claude-opus-4-8-thinking-max
> Signed-off-by: Nirmoy Das <nirmoyd@nvidia.com>
> ---
>   include/linux/mm.h | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index 485df9c2dbddb..1b613c6356baa 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -3405,7 +3405,7 @@ static inline unsigned long get_mm_rss_sum(struct mm_struct *mm)
>   
>   static inline unsigned long get_mm_hiwater_rss(struct mm_struct *mm)
>   {
> -	return max(mm->hiwater_rss, get_mm_rss(mm));
> +	return max(mm->hiwater_rss, get_mm_rss_sum(mm));
>   }
>   
>   static inline unsigned long get_mm_hiwater_vm(struct mm_struct *mm)
> @@ -3429,7 +3429,7 @@ static inline void update_hiwater_vm(struct mm_struct *mm)
>   
>   static inline void reset_mm_hiwater_rss(struct mm_struct *mm)
>   {
> -	mm->hiwater_rss = get_mm_rss(mm);
> +	mm->hiwater_rss = get_mm_rss_sum(mm);
>   }
>   
>   static inline void setmax_mm_hiwater_rss(unsigned long *maxrss,
> 
> base-commit: 4539944e515183668109bdf4d0c3d7d228383d88


-- 
Mathieu Desnoyers
EfficiOS Inc.
https://www.efficios.com

