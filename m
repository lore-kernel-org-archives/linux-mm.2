Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E2695108B913
	for <linux-mm@archiver.kernel.org>; Fri, 20 Mar 2026 12:35:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1F32F6B0005; Fri, 20 Mar 2026 08:35:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1A4536B0089; Fri, 20 Mar 2026 08:35:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 06BD86B008A; Fri, 20 Mar 2026 08:35:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E83396B0005
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 08:35:55 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 9B2FB1BFAB
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 12:35:55 +0000 (UTC)
X-FDA: 84566388270.09.FA68AA8
Received: from YT5PR01CU002.outbound.protection.outlook.com (mail-canadacentralazon11021121.outbound.protection.outlook.com [40.107.192.121])
	by imf26.hostedemail.com (Postfix) with ESMTP id 9D4D1140009
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 12:35:52 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=efficios.com header.s=selector1 header.b=Da61isnk;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=none) header.from=efficios.com;
	spf=pass (imf26.hostedemail.com: domain of mathieu.desnoyers@efficios.com designates 40.107.192.121 as permitted sender) smtp.mailfrom=mathieu.desnoyers@efficios.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774010152;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eX0yLDxOYEVmY0VjJRbU3dRuM/SuwQpOsOsDQY7c2Fc=;
	b=wrQf60HcPv9TaaQx0ugfrUR7IWJ7QasfqE4hI9szHNxIiIJJEWvXbyaihh2FkJjJdQOM11
	Bmv7KVSMBQYhnsR3P1cwYebIP/V/4MObHc7W2ssOqXxO0j9WHYIzKCljb9LZRShZWrj9YS
	KIjJxyMms6IZEPJeeOAJQpwORZ1Yb50=
ARC-Authentication-Results: i=2;
	imf26.hostedemail.com;
	dkim=pass header.d=efficios.com header.s=selector1 header.b=Da61isnk;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=none) header.from=efficios.com;
	spf=pass (imf26.hostedemail.com: domain of mathieu.desnoyers@efficios.com designates 40.107.192.121 as permitted sender) smtp.mailfrom=mathieu.desnoyers@efficios.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1774010152; a=rsa-sha256;
	cv=pass;
	b=QUisCRxuQhfYG94f9jJr8u35ZpswRE+k4GNk3eOZ/yoseWGmQPLUYDRiXCI4w+vM5hvckC
	ycdqi72MBPY+qUjzkKAuS7tVMsYQJ3lmjiVvnOKhQtDN2KMYZrU8UnMzrutb2yAIxuRJdJ
	EfnHuEUK6aAL0jYIkMVCCsilKWPieEY=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=hJqnJJU92x/RkbJf4xGTrpUc2MEXNCpgKJQLoJENRRnlCXHfB7jwW4jV+yzM+rTFbeWci28o24yDkiBT1TVFVuE3sglHN6U9C6scdGTCoH+8TYbbldJ/9swt8kqncwNSimJOlxR0PiG6pEmZiN/CUbULfnMVYwh7Ltw7LV/lfnT5lIGHeRjpsXxZ6gVOYQ8sIWVAS1Kj/gV+Rpa6YXjJBgNwbF12VDY3DKJs57dpj+iliPKGrF96Febvx5jiM42EiQ/dSwpRUAwyO/yRXtCiqW/qDTl2wW7Z0K8QFPgDQ8fMEXjr0OyBLkBQ6oVJX9ccQ1Rd+ucW27XLKJmijYzjzg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eX0yLDxOYEVmY0VjJRbU3dRuM/SuwQpOsOsDQY7c2Fc=;
 b=fvDPzfKS3HIpmdcZ7Jrde8zHDHTTtL9eZVoEZUrdeXZDu2sKZVEVuP8QuveUa8A423GdeJtazYP4BCM8ySrT1/DVCPDsbhu9EXZ8WGh4H6pUdOrcoAIrZDi45KpEOfw2qYrN9D1lsynKme6xB6OdEiKbqvaxqIolJrAkGYr1pQpnKCmYQHPxm4rOmgUni/Exnb2y/h7PGOVhXxP42t+ugDJGq/tkzJJT7K0JemyJYEWY/jCmmVBYwHBWqWadaC92VHlLJ8SOBpi1ct1iwDE0HNnD2uS5nhdgano3itUBeZpKTqW70aafPVH02RKgcgCeMipEMYtwlFrKrz+tv9K7uQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=efficios.com; dmarc=pass action=none header.from=efficios.com;
 dkim=pass header.d=efficios.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eX0yLDxOYEVmY0VjJRbU3dRuM/SuwQpOsOsDQY7c2Fc=;
 b=Da61isnkpY3e7yoC1rvTDBiGwbRLFaitFEp2JlYEICArx3S0VnKplynMZ6epPiJca7SI+wX3WHCbHkIapDdymO/T88Dqs7PwSY02FhPraVW57+0SOE3n8KICH1sHyKhzHcRnGchaIF1q0ZI/sDnqoghBErRR0aFkhIMLBWP9JT1OewMSD4Oa36qZ+buEVTpTADoe1gl7jUJMo05ZR7wEflg06E8MsOurrd/hzj2Zn1s75MT9r1vyJbc6jIz485wLEpABv4fZsjnhPujSrllLnlv7lcnaNTs9xjkwbYHRn5R2gjB6MTf9FIledf4c/9JRbMBj0Pf0sysM7ZJK4k3cFA==
Received: from YT2PR01MB9175.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:be::5)
 by YT6PR01MB10892.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:11d::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9723.23; Fri, 20 Mar
 2026 12:35:47 +0000
Received: from YT2PR01MB9175.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::6004:a862:d45d:90c1]) by YT2PR01MB9175.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::6004:a862:d45d:90c1%3]) with mapi id 15.20.9723.022; Fri, 20 Mar 2026
 12:35:47 +0000
Message-ID: <7780a471-9d99-40a7-ade7-0c4594ac36c7@efficios.com>
Date: Fri, 20 Mar 2026 08:35:46 -0400
User-Agent: Mozilla Thunderbird
Subject: Re: NULL pointer dereference when booting ppc64_guest_defconfig in
 QEMU on -next
To: Harry Yoo <harry.yoo@oracle.com>, Nathan Chancellor <nathan@kernel.org>
Cc: =?UTF-8?Q?Thomas_Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>,
 Michal Clapinski <mclapinski@google.com>,
 Andrew Morton <akpm@linux-foundation.org>, Thomas Gleixner
 <tglx@kernel.org>, Steven Rostedt <rostedt@goodmis.org>,
 Masami Hiramatsu <mhiramat@kernel.org>, linux-mm@kvack.org,
 linux-trace-kernel@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20260319233745.GA769346@ax162> <abzKcGiRSR_E8lLN@hyeyoo>
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Content-Language: en-US
In-Reply-To: <abzKcGiRSR_E8lLN@hyeyoo>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: YT4PR01CA0253.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:10f::6) To YT2PR01MB9175.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:be::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: YT2PR01MB9175:EE_|YT6PR01MB10892:EE_
X-MS-Office365-Filtering-Correlation-Id: 19126c4a-e384-4b8d-74a3-08de867d3656
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|7416014|366016|18002099003|22082099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	LXlW/BV5vQ+TTUhHwFfFMCaptNTZAERmTolgtWfVCFFQEpGMnlSN8skoV9S57iQYiUnv/wkc3YpQLO08k5wlNJbds3BqzpuQpkKhl1wbl/7VQ1p4mfgaJfqyhpO4wjnE3Lj1gND3lmFnKBsgZX+lwpBUR+IaUr8UjtP+O70t1xq86As+o2m9Q5EGxyTuVKZaZyEzShomKL36Nd78nFJ+5SGqYLmMEn+BjNNn9yFoImjnzkxV5oREgHz+b7tkrYQpIs+fPFJMn+lAyKtfp3CMUQu8cyDS+47x6F5F22zVBC4skD1kJHijS1wjRLQcq/VZM6gYZJkJ0GBVQA6MMu8PeDE5jvYEoE//ClKLGcFWTQ29FNoO7GW6ieUBsOcf8Rxze25s1bPzOpICaAWJKoWy697PN+WdI0HCcJ0qB07LPoayhfTUg8o8LN+iHnjP493P/bQgwBfD7U039aZDe59nyvmUlzE/iVtu2e5GyOxZ92uavKS7P9v419jsQJYbX9xll+EdhnZg2g5UqNa0UztPUoAzj2u41PXUXygkfOsVb30hiJzvUyRW17Az34gU4MNj6JVpxPbcZ4Uwi2kbqPnNc7lmhlxoqGAnNgfBmJXSltH7f1B/rn2fgH9MX49JHymt+UadrWWkLmEXZPKv7n3vbWjMpy5KR4Te8x9E8omE0HA=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:YT2PR01MB9175.CANPRD01.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016)(18002099003)(22082099003)(56012099003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?dm5QL29ReEtpbzFaN1JySG1oMkJzU1ZVUlZHWDNiektCL01QaTB5eUpVTU1S?=
 =?utf-8?B?bXR3WjlIVCtlZlpUVFYwdFhNTjhYQ04vSnFBR3V1Uk44OGI4eFBLTHNsM3NJ?=
 =?utf-8?B?cTFBbkhJVEhTaDQxbmNXZWM5UUo5dTVNS1JLZkNLZlJoYmlzUTVVMDNqZWVq?=
 =?utf-8?B?YmhlT1NiNnNidG5IeERqR2NEZitNSnZCK1pQYVVIU0xTMnpQQ3NvSDZQbGZN?=
 =?utf-8?B?V0syZWVYdEFYSkFxTVFQTGRXSnprZ0RhUDBZVjE5TGo0S3AzWUJvcEpzNWVj?=
 =?utf-8?B?UVV3QUd2dG9aZDQrd21JSHdPNytlL2dlOXZXa296Myt2MDA4U2I4RXBCa1VT?=
 =?utf-8?B?aGVOZDh5cGRFajkzVlRBWUdBMUpXMk1vMG9BKzB3ZW5ndEVrWEoxU1FMK3Nx?=
 =?utf-8?B?UmZ4RldLWVBoQzZCQ2hrdjhnQ3RQTUZ2Tkpuc0txaGZUc0hBT3lkaGFvRGVz?=
 =?utf-8?B?TkxwUGZPaVhRTEd1MHU4T1NLeUZGM2xqaU5oUS9mbDlrZ3Z2QW84c1NqYXVP?=
 =?utf-8?B?MW9JZTdFUWoxdGM0Q2UzcVY4dFlCQVRJaGtCN3p5ZDN1TWpvVnFOMEVUYjFP?=
 =?utf-8?B?RVk1WGtWV0dtNEtPTmNCVXhQRDJyRXhVQmJ5QktlUWNSTVNuK2VPeVpwbEw3?=
 =?utf-8?B?THZYb0psekZDSm5NSHRGRlRmUlIyaUdSdmxEOWN3RWlWa0ZyUHU1c2J6b25T?=
 =?utf-8?B?WFhJakpxZDUxOWFQYUFYQkN1Z3YrNHQ2ZVZjN0FYZDN0NXM4UjZXTzBrRDF6?=
 =?utf-8?B?U3ZWWTRERTA3MFpITWY5ZlIxVjBqbnYrUm9IN2NkV0RDZXdEdURRVUxPbm4y?=
 =?utf-8?B?QVQwRFBqVStHWVN5dnllR2FWYzIvQUNCanJ2amZQOGlCeDNpR0NmRFFpTWJU?=
 =?utf-8?B?VCtQZElnRzdhZURCbWh6bWJkbVFselU5WkdlazNvalJNamhhSksrNWxSU3RZ?=
 =?utf-8?B?YmZtNFFYZDJRK1ZkMi9Icy9DQk4zVmNTUDhFZ0FERHFSSGhIMU5IRFdLMkFB?=
 =?utf-8?B?UkY3TFNrZ2FlaEhWcnBEZmZLVWI5YlIyMzE2ZVFJTGRCbDd2ZmJ6Zkxlb0xI?=
 =?utf-8?B?ZDQ3bERIcE9hMWhyY05TWlFsbUFiVzNleHBKN2xtS2tiZHcwQTluQWRZa21Z?=
 =?utf-8?B?emdlaDRXNVA1aHRKb1B2OTlDNDY4Zlp3ZU1scE5OaE96N29LMU5xdllvWnJt?=
 =?utf-8?B?U3B4bFNEUnJBYm9ZS1VRVm0xNWdkeTV3ejFrYm5pQ0N2cmd2aE1xakRJTnl5?=
 =?utf-8?B?SjU2Ui9uWHlvWE5OdmJ4aWx5VU54bUVzdDBzWUl3TTE1d1QxRnBhUmtKOStq?=
 =?utf-8?B?RHJicEFqeGM3c3N2aFRGNG8valZNUVRKbEJKSklUOWt1cVQ1U3V3Szl0YXM0?=
 =?utf-8?B?VnRJUHczL3pKcjVxR2FETE96VStRbkx4UjVvK2lrVEprVXdpeGlNYWpZRXFl?=
 =?utf-8?B?Uml4dEZ6d1hFRDRYb29xRjY0Vit5ZTVJMllHejFHZDRaV1NLUFJnbDJScFBV?=
 =?utf-8?B?Ync4Y3hCQzhvbmFpUXkyUjY0SnFNdHJLeHlpK0J3bWl0YjBkczFuZlgwdGZy?=
 =?utf-8?B?THhuejRCUjI1RVZvQzkzUlJmY0lhRmFuZEtGRnU2ZjEvQ29ETmdad01oV1h2?=
 =?utf-8?B?dEJYd3ZKMEVFVmtOdXdwMUxTL0ZWZ2pUVHdaRDJnRWpDWWozRWZiczFlSU5H?=
 =?utf-8?B?bTZxSVp0N3UzSVZYRGRXeTBCQkJtb1MrWHJYbjVUL25KNXlWQ2hWeTg1dEFn?=
 =?utf-8?B?ZzJSVTdNU2RmbXRGYWs5ckdyRnJRNjZsR0NLK29pRVhQV0ltWGRxYkJzcUlq?=
 =?utf-8?B?cHp6OFdneS9tbFBzNzNsNG5HbENrRWdaZHNVUFdINTg5dDBmck1qbXhqT1RB?=
 =?utf-8?B?UmhKZ2VIc2lGbnMyZjlWYi9teTg5b1RWYWlleHg0ZkRlQVJLTTMvRkYyV1hu?=
 =?utf-8?B?ZGdBNXB5Mm5ESCt3NW1TUUYyVC9Ib2trM1AvREh2MGpyRDc5UTRnZG9QK012?=
 =?utf-8?B?ckFoaEszNWk2b0RkYy9aaktPSklCeUpBZWZrZlEwU09icFo4QzVYSFBUZkRi?=
 =?utf-8?B?ckphTDk1UTNhQzlTbEJ4dTB4aktkVGpKaVovdUhYV1BiWkpEaHJvL1MyWm9q?=
 =?utf-8?B?anhjU1hwa29lYlB0TWlOeEQ2c1pORUN4eFAyb3V0MjZIR1VCRnZjLytsWVpx?=
 =?utf-8?B?dzFNSHgvRXZXMytOeURWaTMrVGNlcFBFZnc3aVpJSGEvUnFiTTlCeWdtNGc2?=
 =?utf-8?B?U00xcnJ4enlGTDBVZkdDQUpwWkRIb05TcjNuNzZmMnZMZTAxaS81WXBCRGxY?=
 =?utf-8?B?VlNIWWRqM0x3SEpackdPUFFySU9EL3RDeVMzQXU4ei93ejdpTHpSY3FlN3FT?=
 =?utf-8?Q?1fpChIbTHNjtZkDUnt2dzE9klMh7bkbB9qYza?=
X-OriginatorOrg: efficios.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 19126c4a-e384-4b8d-74a3-08de867d3656
X-MS-Exchange-CrossTenant-AuthSource: YT2PR01MB9175.CANPRD01.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Mar 2026 12:35:47.5696
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4f278736-4ab6-415c-957e-1f55336bd31e
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4dwhl5DD7XouRzRqYGx1aRLnquliwim7gVz3VrHyWyx3xl1apyN2dhe4cURjK1uIDIo1GKuwJKdI727XyoYqaoBADor3h7lHyBCXOCIydnA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: YT6PR01MB10892
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 9D4D1140009
X-Stat-Signature: 5yoiuq44ij96pnuw6gmmhy9gfwcncsaa
X-Rspam-User: 
X-HE-Tag: 1774010152-123687
X-HE-Meta: U2FsdGVkX193SGHFbnvmUrW3IPSDqDLdomYjLtFP9pu5pFu5kn+5JebvBbhxOYU7upowNF/w5bHajzh/tE76kDlFOF2SxJAtOJCxTOX2UQa60X552T0/QPDPPY9T0cKEleOZFTsQnof6ngAs9N2f+77ond4jgj2+GVUtukeDqLP7YJWtNkRAIt92zv6Q3vqh8Z83Ky6koEraXfB+bdF6jzqpc9ddATvZFaoS9xLoIbKb3505jIYI4423sDJ1LAvTOI7Tu2Fp/H/OIJma4qi35iu5EZQuaBiraQ1osYL681PN/lYvQSsEHzMrfG73DzrEuPI6zommFmr80H7SsE8bpRBfJUz3bi3T8szuAVGFG9NBEFdj2ch6zR7XzqgK7xnw0gsCFBV1lfwRWbI0kMpHrXmBL3zlTLLCFTvMtHr00oTgEi/BE2CIdC2qZ2hTSY2U5iwAuXqaHaOPAdIqIF3uhuEdCCcaZXZQkxojzv5WQ/SbKThuvK/CrXNVpjSiRBOJZtgkvev32MoHekCxIj/NBvx3xiHatZarCNDlv/99I5xYLC2GiNiLYJ6oXSkqr915b0bkcMpDfzUiqhnasstZhp5jS7Rrs3DOq3dbU1UeTqbNbddlVOza00O0ipyG/vYLQG2fn9oNxRj0b9Tk3g2kBYyVem039n1b6CgdtqdOS4g135buLTgcSIIYQ3xhMALA5ggUYYtkH6ReFSDt5CJsslZamIpO8jKefc+mHL6DjlJrjJNDSW00A5PyCVVIIXkW3IDRXtohsphaR9QHnTTI0nBEy6uBeJw+6Bqso2qxGlhrypu3EmX2ZdkSB13x3GrdjLrEu42ZLG4k35uHWyRd6b5UpZf3+AsgjvEFoHyn43WOyuQiKpt19tfab03O0WybwRsAGPZheXFc62gjBbGNLtBTC5pMkJCWFK+dejN8z28CaQYEQcc8kq52v/Np+LsZkfB97zuKtxgabFaowz0
 Jaoqf3qr
 fkzMY0vr/RcPEy+YqnzegE1rgf9mYJHaJot5cwx8KS454IyDnozYCBdVsZ8C4IDn4qsM1V20YIb/fk7A2qQ5UcHeibTOZvOJns6ZBzSfrLDg+HymoX/yYzbNEFXhn69eXHZhAzdbXavhPTAgrLXOpSdRyQwhhJaU9yBXwK79y8JGMSGxtDPky1JsRxjbwKczh/RnqXVmp8inOrbsiLbiPoFTKSP7GVj1vTPIDACWg6enY416mF9JRmSbUpOMUnX/iw/NkP79svMwLrC47sJosS9cQqfyAf8Hj9TuocMzQyhHiTNFgihXfV8d/o/+infH8+NidYISwsTgu8S3Hu9hNLlsMsNqr7iVE3aH/ttFOvufaCMiZsSpL/GW6YT+sp51LYvnm4ew4IODRN8wLUJJjBX/ofl4nhPuved1+Yt0uO1fFk8FQvMyc/c57NvOySCqDheciSJn7zg0WzDB48me0zB4xGSevv+8audD4hKEWWsP452ZQHoGK9c1OZPLVrdwNj/EERFfJ6eISgW4JtRKogbebGP+lMrxHKLa2+3fZKfk0r24=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026-03-20 00:17, Harry Yoo wrote:
[...]
>> [1]: https://lore.kernel.org/20260227153730.1556542-4-mathieu.desnoyers@efficios.com/
> 
> @Mathieu: In patch 1/3 description,
>> Changes since v7:
>> - Explicitly initialize the subsystem from start_kernel() right
>>    after mm_core_init() so it is up and running before the creation of
>>    the first mm at boot.
> 
> But how does this work when someone calls mm_cpumask() on init_mm early?
> Looks like it will behave incorrectly because get_rss_stat_items_size()
> returns zero?

It doesn't work as expected at all. I missed that all users of mm_cpumask()
end up relying on get_rss_stat_items_size(), which now calls
percpu_counter_tree_items_size(), which depends on initialization from
percpu_counter_tree_subsystem_init().

If you add a call to percpu_counter_tree_subsystem_init in
arch/powerpc/kernel/setup_arch() just before:

         VM_WARN_ON(cpumask_test_cpu(smp_processor_id(), mm_cpumask(&init_mm)));
         cpumask_set_cpu(smp_processor_id(), mm_cpumask(&init_mm));

Does the warning go away ?

Alternatively, would could use a lazy initialization invoking
percpu_counter_tree_subsystem_init from percpu_counter_tree_items_size
when the initialization is not already done.

Any preference ?

Mathieu

-- 
Mathieu Desnoyers
EfficiOS Inc.
https://www.efficios.com

