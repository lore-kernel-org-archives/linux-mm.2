Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6657CCCFA18
	for <linux-mm@archiver.kernel.org>; Tue, 11 Nov 2025 05:59:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A7DD48E000B; Tue, 11 Nov 2025 00:59:11 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A55218E0002; Tue, 11 Nov 2025 00:59:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 943C28E000B; Tue, 11 Nov 2025 00:59:11 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 83B9D8E0002
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 00:59:11 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 42EF888B36
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 05:59:11 +0000 (UTC)
X-FDA: 84097273302.06.D43C60B
Received: from SJ2PR03CU001.outbound.protection.outlook.com (mail-westusazon11012038.outbound.protection.outlook.com [52.101.43.38])
	by imf10.hostedemail.com (Postfix) with ESMTP id 46DAFC000D
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 05:59:07 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=WTUQbT0s;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf10.hostedemail.com: domain of shivankg@amd.com designates 52.101.43.38 as permitted sender) smtp.mailfrom=shivankg@amd.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1762840748; a=rsa-sha256;
	cv=pass;
	b=tKshmI8xZOXk7+MTJe1mV8MfLhCh2OZV9+Ac5bFWIy+hITQJyA0bVAneSxua6X91U8KqXl
	FqPMUHUqXN63b3+PdTcB+ijxyNrN1PkvlNb/m9L23Ebco8nFHAYr/xLBQ/8IcJf46iLiv7
	LlkVMALdxl3PZDdAr4G3Fa7bKzIltk8=
ARC-Authentication-Results: i=2;
	imf10.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=WTUQbT0s;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf10.hostedemail.com: domain of shivankg@amd.com designates 52.101.43.38 as permitted sender) smtp.mailfrom=shivankg@amd.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762840748;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7Ff+p2tzGhD9rj8pxwbwXPcYA4tfjOvixLAVdAdKAWc=;
	b=slqkkUuyX25Dh0ALZqFOtc25AkrufoQleKOpZpM456EQhtERa2gzb3oyP+nWI4uzeupI8k
	XDMN+94z5PyshKuKht8T0jAh9mqBzwFlqyxLueAUoYW/Uhhaj1/lWGQbWpGk92D3XZRtnR
	FK91VNJjKbPOEk3bYPJng/OaWoTM6A0=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=elq1WNqsm7J04W8iSOHNUUq3o+28S5emYLNQWijjSjDJfLisFwybmVXqE710L+orbNExvenQ1fDAwru+spbnUxHjVIAwYc539Hv6gxvqtg8ZQkf2ZctGTkqz//Sz4c5eiR5eag/C8H7A4oCiTAyPqrotpahzKf5NHqJmoqQi9rzVGvOJ/5Q+rRHrCxzDhw5cGgUtEAhFkJGeCwWENPbqj1/3LzUHwiuT0eARKnJcDnfwiaWxEhmMgdEG9sPiZTip/qNLMSViCa9j0NMpEHRQ+XbzmZGBqn0rNYldmCAhlfYPhRStgxHyKZrtxNooX4uwQlLZjl9CvdIZ/oCEcGDaMQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7Ff+p2tzGhD9rj8pxwbwXPcYA4tfjOvixLAVdAdKAWc=;
 b=OwDIrArMB1QpEWBN07nkFW8fm24rwxGQwmqgU3eLPp3q4ERY57Z5yjbbBkKQ0xJxCmT5nFBWdhJFS8EF9MSA3QPC4YFMCHzqyErwFfMOpYQtloyrtfpQPc/Q0ea41DWpPEQUiFNwWzt7b+L5S5OCd754B6ozlDK57NMgSDwJoONjx8K+7Q7TUMjtmzASW/JY7fRr07Kdn44iw/CcNkUCFGr8rsSBUjNR4oAGAy8nawwXIm9RnXW4S66diqq90rbsv7skWeRzKwNK2JRthWhFxrinBAPQQzLSGjGy7hBzsj6cGjcp68aZoYEyzoSRx97Przzd530TmCk940ogSkFVSQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7Ff+p2tzGhD9rj8pxwbwXPcYA4tfjOvixLAVdAdKAWc=;
 b=WTUQbT0sLDw2thUODg+Q0pcXu9op/nYQTfurH2FkHeaxQaEudhssLdgX0WTiMSTNeSthjkWRJENNRleEtLwxMx35Wy56UocV802DxB13z6qe8aceixzdd/CvE1lL6Ngo3LFNBVQLeru0zxHVL5dUYdLQsLPxo3x3vdMIooSzoi0=
Received: from SJ0PR12MB7458.namprd12.prod.outlook.com (2603:10b6:a03:48d::13)
 by IA1PR12MB8467.namprd12.prod.outlook.com (2603:10b6:208:448::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9298.16; Tue, 11 Nov
 2025 05:59:01 +0000
Received: from SJ0PR12MB7458.namprd12.prod.outlook.com
 ([fe80::83e7:e6cf:26ed:2f3d]) by SJ0PR12MB7458.namprd12.prod.outlook.com
 ([fe80::83e7:e6cf:26ed:2f3d%6]) with mapi id 15.20.9298.015; Tue, 11 Nov 2025
 05:59:01 +0000
Message-ID: <e38e8059-a62b-4ad5-8316-5af02a0cc1b6@amd.com>
Date: Tue, 11 Nov 2025 11:28:52 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] mm/khugepaged: do synchronous writeback for
 MADV_COLLAPSE
To: Matthew Wilcox <willy@infradead.org>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@redhat.com>, Zi Yan <ziy@nvidia.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>, Nico Pache
 <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
 Lance Yang <lance.yang@linux.dev>, Steven Rostedt <rostedt@goodmis.org>,
 Masami Hiramatsu <mhiramat@kernel.org>,
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
 Zach O'Keefe <zokeefe@google.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org,
 Branden Moore <Branden.Moore@amd.com>
References: <20251110113254.77822-1-shivankg@amd.com>
 <aRHs3pA2kOr_uD3k@casper.infradead.org>
 <b7313a45-c36e-4390-a0b8-46f412474f86@lucifer.local>
 <39c8a4ed-53b5-48e3-baea-f67cc1e8be4f@amd.com>
 <aRH2pdhMBQ-20IC9@casper.infradead.org>
Content-Language: en-US
From: "Garg, Shivank" <shivankg@amd.com>
In-Reply-To: <aRH2pdhMBQ-20IC9@casper.infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MA5PR01CA0153.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a01:1ac::14) To SJ0PR12MB7458.namprd12.prod.outlook.com
 (2603:10b6:a03:48d::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ0PR12MB7458:EE_|IA1PR12MB8467:EE_
X-MS-Office365-Filtering-Correlation-Id: 124d3d93-f1df-46f1-f829-08de20e7690f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?dUw0Vm9PcUxUQmxIV1VjelpvVFdLZHByanZNeHVLNSs4N2hJanZXQ2lOK3J3?=
 =?utf-8?B?VjZlZXluclY4V29UK1VxdjJjT0kwUjVHZ0ZkSVUzckJ3ZTZ5OFQwR05PNVhJ?=
 =?utf-8?B?WFlFcXlFZitDUklEdmF3WXBNNkZsejltLzBMMUl1NlFiWXZCQ3h1SE5pVnMy?=
 =?utf-8?B?Y3dJTnY4ZDBaaG9aQXh1SXlFTnBCWTNJQnQ2ellaaE1FY0VDSDZZbHhTU2ts?=
 =?utf-8?B?QTRhL2lwbnU4RE1jb01kRmRaVFVERlhkRDBxOVhIZ2NRT0N1eEFxZStQL1FY?=
 =?utf-8?B?bjdFWU9QOW11WDUrRit2a2dxRWlSWWhWaE41dTl2STA2bFpDcm5Bd3VVampt?=
 =?utf-8?B?RVJLRnBDYTdCcmFnNUFndnBhZ2xmMkEzYVMzcDR0OGFVdGt3QU5ZcDJ4WmZO?=
 =?utf-8?B?QnlKMlZFMXZoRHc4Y2tlMHc3WnRvb3ZTYXlDRnI3SnpFSU1wMWVGOHRIYkZJ?=
 =?utf-8?B?TlF3ME1ldVF4N2IwNGxnK0I5WkpydldrNGtxZXVyM1BldEp6MHJJZjB2YXZn?=
 =?utf-8?B?bkJSb01LZGVoLzN3VkE4VjRJVFgrclVOOFNOaHNvOExnRk03QU5iUUZNNEw5?=
 =?utf-8?B?SUQxeitaSkV2SnF3WE95VnBaQ3ptUnltNDRiaWJDT0Y0QWRaN2NZbk8vSGd2?=
 =?utf-8?B?RnVENzhJWlJpbU53SVBZSHRicHdmNEVrN1Z4N0JGbmZBYnBRZHZ4dTR4Q0Mw?=
 =?utf-8?B?ZFNzMlFMQ0d3ajhQYUxrcExnTStMM3NhT3VZU0dvUFFkVEtDVi8vUVVaejU4?=
 =?utf-8?B?VTdBbTYzMkZLeGNlRE5iRklzTTViaXczVmE0WXgrTVpVeEM3b3lEdlhHSjNC?=
 =?utf-8?B?aUFXQXpSZnREaXNZZ0tMdW9Id3VoOGdWaUw4MWRnRzc1d3BCZWJJSkF2dHR5?=
 =?utf-8?B?UGJXanNLbDh6VG1RN3MrN3U3RDRmejM5eGRJQjdMMURpZ0szU3M5ZjBFQXNE?=
 =?utf-8?B?Z2tFRUxkSDIrRXVSWkVuekNmZW95b1N1OFJhS0E5emRXVndqTWl3cHQxR1p3?=
 =?utf-8?B?K1hMS3RjdjU5d1U3d3FSekJldEVjU2E0d0dSNjZNdVQvTGVLRWZyMlFpYnRN?=
 =?utf-8?B?cXBrd0h6UUk3U0dkeGkrVmN6cU5IMDRVMTJqcGtsS0xjeTdSa29KZHlkSmJ2?=
 =?utf-8?B?MlBNVSs0L0NTNDFCYy8xWGVjQnJuVDVPOFA0MmhpclZjamVNWGVlbVVmZU1B?=
 =?utf-8?B?MzZFd1ZybzhwZFBuWmgvRW9tVjBGamxkTHh4alBDNDVheDdYTWVNWURSc3hp?=
 =?utf-8?B?Q2VKSk5RaU9yZmlkRU16Sm91K2xQSURqQ0xxWFpnUlFQcWQ2QlB5V3NXdW5G?=
 =?utf-8?B?Ky9MMnAwMnAxWDFEVGYyMG5TQkZZMUNPd3ZGSExZTlRzYnZ4dkNHdHFuMTUr?=
 =?utf-8?B?SzBOcExqckRYNHNjakZPdDVWbnhxalp0ZTlJRmJKMXlhR3hWRDl6cnF5bUs3?=
 =?utf-8?B?L000ZDZaSXo4ZVE3c25GcnVQWTFPSlBMZ0RxMGR6citNYlR3REdsb01WMHNw?=
 =?utf-8?B?b0gxTzFOK2RlME9TaTFsdXg3TC8zSXA5Vkk0M24vMUo1SnhWUGxUZFBWZUlE?=
 =?utf-8?B?L242V2Q4S3Ryb2Z2cVdKazMyc3k5UEdIUHppNjBGMElIbS9pRFlhTnNvUlp1?=
 =?utf-8?B?OHM2dnYxTThxbXRMeXN2SDI0MytONnZXSFp4Z1R3a0ZtWXBacUg2TWFvelJu?=
 =?utf-8?B?U0huSXhNT1dpQmZUUE1vRzk3aGhmRUxFY2FJb1B1OWk3Wkd1V3oxWGViREhW?=
 =?utf-8?B?THNxN3lTOEtNVmt4bFRCTEVzQTJzeVpHbXJyMXBiSUIrSzEwWVBKUnlXM0px?=
 =?utf-8?B?Y3lGOEVvbG5LMEswMlZyMlpmQ0pPcW5rMnlPKzluQitWNmwweTRrT2MrRGRQ?=
 =?utf-8?B?NEVwYk9rWHJsaVhPMWZNdkJqTVZEYWcyUGN3QzJjdmg3Y2swSmdZMGhuKzc2?=
 =?utf-8?Q?k/c6CKTk1CZfQfutd9Uucii+EOYff9Dc?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR12MB7458.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?Mjg4Y1BUN0t5TER4QWExd2EwcFZsdGpvU0tWelFkWms0VklmZVV1bHBJc1Ba?=
 =?utf-8?B?eXRGU0pDNVNiZVFZMjhTWFlzeUhRMTNzZjArUk5rOXRwLzNqNVdYbThJcTZu?=
 =?utf-8?B?aFBiZG1Da0p4aWtiemY3NkdHRk5Pb1B0SmtVZTZOWW40Yy9CWmpyVisvUzc4?=
 =?utf-8?B?amRnTS9kQUJhNjVmMnN5RXpqamZOeEQway8vN2h5NEhCYTBBbEVJRUQxQm0w?=
 =?utf-8?B?TXFxY0c1VFhFYXRpMkxpdzhqbTJUZjgwVm1aWnNXdkxWWVErTDVTbnIyR2wy?=
 =?utf-8?B?UmU5THp1SnZSTjlTT0xzYTNSV1Z4c3duWHp2RVpyUnZ3UFY5N1lTY3BBcDVD?=
 =?utf-8?B?eGo4T3lPMGl6UnAzazdsckNwdDVjMzY0NDNERjdZVC9NYXRIb044OXZ5dTNj?=
 =?utf-8?B?bG4vWGFpTU45OXByVGx3MFZQS3lzY2FwTW1jYXdwSFNqY3c4YkI4QWJLMXhI?=
 =?utf-8?B?dXV0RU83TklvYjhLY3N0cG90WXQzdFRUb2tKMVIvZ2pXendIeWZhVitTWUxW?=
 =?utf-8?B?RHJLVFd0NHlhMHQzODBsWTZrVWxNVWFWTDJuMXNKV0E3SG5hUXFJeGNoTTdU?=
 =?utf-8?B?ZmZYblBVV2JkNWcxMy9pZC95azFaRWJiYWRZbllram1nMlN2dGgwbWM3VEpB?=
 =?utf-8?B?RkgwVWlsQTZONDBGMFF4TzlLRXk0ajRYYTBOQ2g3dUtYODZtZ0VpTGRXRXdu?=
 =?utf-8?B?VWpsOGJ3VFVibGNpOW9zRDVtZzRVdHl5TGFPWjJWNjYwdE83NzNFMm1oZUo2?=
 =?utf-8?B?NFJmUVB3aHdNMEFkcS9XdHFLaFRQK2dVeWQ5OEtoUkZDeDdHOUF2Q1lNeEpF?=
 =?utf-8?B?dytqY2NwZm13YldRbHF5MjNFUmRxaVl2V2cyTy8yTTBqTFJ6MzdCeEY2L1cr?=
 =?utf-8?B?NWxOY29kdWZaelVYT1JJNnJFME9UVm0vampjOGF5Y1FtRGx4cnFvVEU1MHI2?=
 =?utf-8?B?Uk1LUit1VnR0TFNma2RzQVIxMFoyTzBLRjEyeWUzaGxGVEx5eEhGMXJpeWVz?=
 =?utf-8?B?WVE2bmd1MzRZaTZ1cEtwWXZFU240dEYySkJPR1hYZlhXa0g0RGE4ODJYMit5?=
 =?utf-8?B?My80aVlOa1FNU3dtclNnaHBkdFZ2RTV1RUpuNHBNWUo4ZWVMWmhPb051dzlS?=
 =?utf-8?B?NGdFcGU3RW1qUGlrN0hPdGhSVTB2Z2lHdlZnaXRFN3k4MkJ1Syt5eUZheWJB?=
 =?utf-8?B?aWNsYkJHMnRPTVJpRDlyM1NYSHZVMFZma0FUTGxwdUF2UDFzQmVIWXAxdGFP?=
 =?utf-8?B?dkNLbkovZnRzeThYVWtKY2drSUVLOWVHdlhLR2l1OVVCTHpBYytHdThkdHRM?=
 =?utf-8?B?VjEwK24yOUhjOWpzVzZBdXlHbTJlMklMZ3F6dTRQUEszOVovWktYSTNWSlNF?=
 =?utf-8?B?enNZL0t1MzJuUTBJd3FLanUzUWVOdU1TRlJFWnNCZFN3UGZEOWMvbGxJUDBF?=
 =?utf-8?B?cm1Sb2dhUS9FMVVKbEdoNXZEdDBuUmlIRC9pZmxLWXhRUTJ1TkNpZE53N0Fl?=
 =?utf-8?B?REZ2S3gwbS8vTjBYVHNvN3BibXJaZlEwWFR5bmJETnYwb042dDRlVFhMc0R0?=
 =?utf-8?B?RGcrdXJnbkZHdnh0czdVNFV0RFoxVHhVRUZjOTBZTkw0SnJqd0MzcmdNSXpC?=
 =?utf-8?B?aktVS2pMS1JlbXhxNkIrNkhXazJzQXQ0aFhiM0ZlZ1FoZVJRTTU4SHIyTHhy?=
 =?utf-8?B?YXdtRTJjME01S1l3SnlFNktTdS9xRGJONlB4Q0NwajJhR0pTNXN0VVFEQVZs?=
 =?utf-8?B?cU1HT3lxZ2djZk8wZXVnRkFpeEpUWXEyeS8xbWxwZUxvbWtyNStEU2NqbCti?=
 =?utf-8?B?OUszbzVxYnhpbHBCclE1Q0VlS1ZJVkgxaTFscnV4Y2hRcHlBOXdOQ0xQQmFK?=
 =?utf-8?B?UU9ncExFUUh2WHNKN1hRMDRiNHZ4dDVQcGxhNkNXNE5mWmhra29YMDdOQ1F0?=
 =?utf-8?B?MElFQkNoMHhCSitmQ3ZJcGpLQTV2WHdTNE51MUZDTlNOeXlrQjBQclAxRFdV?=
 =?utf-8?B?azFnTHlvOC9LKytnUTRCZDh0b3MwVVZtdU5yMVl6bHA3NHJlc0pzM1lhK0dX?=
 =?utf-8?B?VVJYYWF2TEtQeHNLU21PdkZXdCtZSDFPZzFyQVBDZ1JsQWNCZGpVbzdqR2FC?=
 =?utf-8?Q?P5vxSd6lo5l/b2yBthIxBuugx?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 124d3d93-f1df-46f1-f829-08de20e7690f
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR12MB7458.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Nov 2025 05:59:00.9977
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XJArNAPeLj9poMpxcRKJIMcaUZuI9pcOODj/L8wtQCQvyUW+OtC+Pjj29jB4MfwjtiJignh+IEkVKkA7SZQEbg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB8467
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 46DAFC000D
X-Stat-Signature: g1gmp9qt1fqstwxturrdsh4ikadeqzse
X-HE-Tag: 1762840747-804935
X-HE-Meta: U2FsdGVkX19/F2zyQ9FCTypoDPQ78Pll219miFDtvYoYGLnzOuYa0zjnfUa1L/VCMkqGqSfqj3KIJOow1/ejlopKS7ov+PCDX1Nht4v8EfxDhmm/8nDxViXzhZFB0P5Ca0BMq3po09/CK0AJ/vQEchkiXAp/RNtFwZKekYQSl/SYBYh/B0HumYYYUtGxrg4Db1BVoilZlzUMYPbNzWg3CWgpAhrULETF38NPts5Q57PdcmvJoH8PPtl2R0RpnrXEzJrk9Bi7ywULQ8z25xuZMpFHXA1zQ/yhVw7tjR+WUYFvIGEPKIPnI88UA9uCuy4UWR1C2CG/GGBDIE9JwA1a6Ngo+poQ1sYtBWeEiE+QIDK5VW/5RPQ2utCHsK7LugRJnZB+LMsY+qXOhIfWSOaxQR2sUW4USFLQZjoi2GYOzHy6iM5OfZYMYM/ydelIvHbNS25OH9119rphnUROhWPrWuj2KRZ6RzBNQTMOrD7VQjLnNyQSqnMzQpk+Xt8w5U8dBW0aVz/jOqWTxGy2ABlYyx5W+1xSi3IXDjwpRJuh9JtWQXUISVPeWj4aRnQDQigAKhvwkrA1Wg2O5LKdKQ8fpQNEc+wJwsp2G8LVIJbaMfD/yTiCXNmy7RVRy5jAd2PKDf5ANTBtFdtMggG8HRuz7aFvh9SzIt8PG/I3QnR9toiFADNekSuroC2UOewEWam20ekkF0pArvj/j/NoIEqxXh9gL0z/0QgJ3TzvXd1DmRr6eJ68zby/QOCdGlP1NQy5iMdN3Lm0a3aAkPinfRvYX21CedBLD8cTJt8HiR4jxMSLkDvkro0gVy+kQ9o0F0wUxJJt2luQZp7K6JVzc0+9sfOFlgQ7l66OtPldlYByRumSIBwb3nebGBQPT45hC2FxM3XdsNTMjdIAEcyeMGNy8fXAE/cIQTwIGyVq1aVrg315XB1BxBwoe2FjpFZW+oOntJ58Z15jrdD4PwsxBib
 LYvSufcI
 QDTIZj+ZrnvCS+lCWwBLXTkj5wXBiQpl8BrLaL4d4nyya/wWuAOLCWBkPgHMG+o2d7VRMxqvEmeMcbJiHct4Veu1jJ0DBaag7jfadM1u0UjqtxMluSNF5jFTriBO0yh15fxN3FaEEIWEAN8MN7h4ZaqXpfg7auemPmZlvrB3kSuxdm22waP4AKjE0azQIkmn01wvzmhB5YTjhggweuLrwCoyExfcKGW6d8nEQzW6BvgfMpUaRFZu9uy0xTN2tUu1klccMAgcjQ7v4LBvrdcQSJ5MIl+fRqwbqsqGm71ovDDug1+u7fIKNhwZaBj8uOQtWbgkIqedVBAkZafmjI7z626d3B3nNW+mH1miJiquLQeXtIb5oZ+BIMrHcKqo4gaIDeQ4HpzBAmaDR7WJeua1onTZ88Hy0lMSBmzV2QAx1JBePiIPSn/V7euMUjApnUqD3yJDUTcVz/PgyX74=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 11/10/2025 7:58 PM, Matthew Wilcox wrote:
> On Mon, Nov 10, 2025 at 07:50:17PM +0530, Garg, Shivank wrote:
>> The issue is copying those binary to a freshly mounted filesystem.
>> The page cache folios remain dirty until background writeback completes.
>>
>> Reproduces 100% for me: fresh XFS/EXT4 mount -> copy binary -> execute -> MADV_COLLAPSE fails.
> 
> Yes, but this is an uncommon thing to do.  Really, it's the kind of
> thing you do when you're testing something (like, whether ext4 supports
> large folios, and whether that yields a performance improvement).
> It's more reasonable to change userspace than the kernel to solve this
> problem you're having.

Fair point.

You're right that this is primarily a testing scenario, though it may also
potentially affect JIT compilers writing executables (also uncommon) but more
research is needed.

For userspace workarounds, calling fsync() before MADV_COLLAPSE works.

Synchronous writeback in MADV_COLLAPSE seems reasonable given it's already
a blocking operation. Alternatively, dropping this patch and keeping only
patch 2 also works for me. As for user sanity, returning -EAGAIN instead
of -EINVAL and some documentation would be beneficial.

Happy to go with whichever approach you think is most appropriate.

Thanks,
Shivank

