Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7F040C53209
	for <linux-mm@archiver.kernel.org>; Tue, 28 Jul 2026 01:39:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 92D336B007B; Mon, 27 Jul 2026 21:39:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8C7FB6B0088; Mon, 27 Jul 2026 21:39:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 743316B008A; Mon, 27 Jul 2026 21:39:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 2AC006B007B
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 21:39:48 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 745241A0278
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 01:39:47 +0000 (UTC)
X-FDA: 85036478814.15.8796E84
Received: from DM5PR21CU001.outbound.protection.outlook.com (mail-centralusazon11011046.outbound.protection.outlook.com [52.101.62.46])
	by imf16.hostedemail.com (Postfix) with ESMTP id 98F2E180005
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 01:39:44 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=E3RNQR1Z;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf16.hostedemail.com: domain of jhubbard@nvidia.com designates 52.101.62.46 as permitted sender) smtp.mailfrom=jhubbard@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785202784;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zD2V+Clau+3HWwyXLI/BWgXanKHXeUudlnSWUAXpuJc=;
	b=jWV9G9Jwo32xKTV2+qFEClUwAloJPPCEYheGXpgg8sUGMUVE18kF8y82A3n+oQfnbD+rqa
	AWD5yhnLsF4Tqqr4dZ2tbLt+sCEdOcK7HoC9rKHd9I8so3+rYfV0Ng/+CakQ8Ty/FZOxMI
	dZxMyCgv/HACjetcG4+qiDFuBDDePAY=
ARC-Authentication-Results: i=2;
	imf16.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=E3RNQR1Z;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf16.hostedemail.com: domain of jhubbard@nvidia.com designates 52.101.62.46 as permitted sender) smtp.mailfrom=jhubbard@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1785202784;
	b=YloeeOOEuR7Qua/ae4lKQnvY7trbJRYxicoUKKDdGIRPsIvbWXYNp8t5jhkVZp4oZjEn+d
	8YsSyQ5SbTWXb/bQSut0wRxfFY70irwFHFhWZCR04MZwUHLq7OmacrT1EoLQbdH/LZd7K5
	Z9/sFK6P9urb0Ls8+TNoEm7u86lAXRU=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=TJduRaFinyPFt3L0ltsDSMa4ynU4drtoFRydQBppzdMKLhF4Prp1azMEh/oIatrFhe+Cg38ZHU1/5tgNyXcDKJGvh0pCHOiybr41iTdCzcHbmJcPCeHAfa0SUbLVHUjkanNScQNPevPs+5EWdmQUWaqaI78ecwZ+BSZ0sBm0Z5KVsHbtx27mhnMVlKalwh4xZeZUtedEGf9Q+3uF5qhf3/wHdZ8N3KkePG5VW2Be565OS4sv+Ityw+UyRlSN3Mw8P2uB4wPhqREFkwMEE+lS6GcZBaQk9VKSQYWRgTFYnPKh0Xq5TYs/B1sBv2zTnE01x1AekBeLUhkVPAMpZU6/yQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zD2V+Clau+3HWwyXLI/BWgXanKHXeUudlnSWUAXpuJc=;
 b=XouOOcNq5VNzCVgDmBtu79A7YjBykbYbyRDu1rYUkvu9/NqbQjZU0/IbVz1jRG4f4HE7rNJ/W6tey2p/UTciL5WUT8ZCnvucjwb8v1i7XMHWlm/JhjDdRhI/ptrIURyHA+f7TIEiDBjpynsfJmrpufIB5dQLBYOIiF6Ys5p5tPcdI4hNiA/xwdAhDQrv6GjbI6OrBLfuUPjRJs2OX9xwERAn5jO7t/i05P3d0Ss5Tapr/hkZYe/6kr4ATyAm0Pol30BgYKEjLpIkAcw4KsIVvM82o/mI9+ElTIXPd439U4X1d/0wkFclWhD0nSfNZZW9p24R0lnMjH2KgWIJhr+QZQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zD2V+Clau+3HWwyXLI/BWgXanKHXeUudlnSWUAXpuJc=;
 b=E3RNQR1ZIjvB1GF+jMoGSWdnsOLmblSACaa5XSyGcAUQwLBCTi9ZTAL0CU7o2/luNEy+u5uEmcKDLIXbzxfiD21q2WaNlqdtXUEIUiy+uZLuv8orwEGqOoIwMyKWwhBaobsbH9N0M3vicMyIoDLfjqwn2WTHD4H+NcT+shhtAWwZoCPPB9Xnh9sszvZpDvLJwAbik1XSN4gX5dAlkF+VX/XqK5DT0ctQ2bayTXhjl2J3UPRiZFH22MeZumTfv1lvX7E33ywiiFxGvRdA26AkhpwGsCSLCsAeZ1VpKkxwq5UL+4bHO4nkPHE4ngOqyW8QCgTKCgXw0nDRz8mIP0GHzQ==
Received: from DM3PR12MB9416.namprd12.prod.outlook.com (2603:10b6:0:4b::8) by
 MN2PR12MB4174.namprd12.prod.outlook.com (2603:10b6:208:15f::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.245.13; Tue, 28 Jul
 2026 01:39:40 +0000
Received: from DM3PR12MB9416.namprd12.prod.outlook.com
 ([fe80::8cdd:504c:7d2a:59c8]) by DM3PR12MB9416.namprd12.prod.outlook.com
 ([fe80::8cdd:504c:7d2a:59c8%4]) with mapi id 15.21.0245.012; Tue, 28 Jul 2026
 01:39:40 +0000
Message-ID: <a7b5c758-6c4f-43c1-98d2-3c7f9a90ef51@nvidia.com>
Date: Mon, 27 Jul 2026 18:39:38 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC v4 01/12] x86/mm: add untagged_addr_remote_unlocked()
To: Rik van Riel <riel@surriel.com>, Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, kernel-team@meta.com,
 Dave Hansen <dave.hansen@linux.intel.com>,
 Peter Zijlstra <peterz@infradead.org>, Suren Baghdasaryan
 <surenb@google.com>, Lorenzo Stoakes <ljs@kernel.org>,
 Vlastimil Babka <vbabka@kernel.org>, David Hildenbrand <david@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Mike Rapoport <rppt@kernel.org>,
 Michal Hocko <mhocko@suse.com>, Jason Gunthorpe <jgg@ziepe.ca>,
 Peter Xu <peterx@redhat.com>, Matthew Wilcox <willy@infradead.org>,
 Usama Arif <usamaarif642@gmail.com>, Thomas Gleixner <tglx@kernel.org>,
 Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
 x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
 Usama Arif <usama.arif@linux.dev>
References: <20260724222934.1463812-1-riel@surriel.com>
 <20260724222934.1463812-2-riel@surriel.com>
Content-Language: en-US
From: John Hubbard <jhubbard@nvidia.com>
In-Reply-To: <20260724222934.1463812-2-riel@surriel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ2P220CA0013.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:a03:5da::16) To DM3PR12MB9416.namprd12.prod.outlook.com
 (2603:10b6:0:4b::8)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM3PR12MB9416:EE_|MN2PR12MB4174:EE_
X-MS-Office365-Filtering-Correlation-Id: aad002ef-6bfe-4ce8-9111-08deec491760
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|366016|23010399003|1800799024|18002099003|22082099003|56012099006|4143699003|11063799006|5023799004|10067099003;
X-Microsoft-Antispam-Message-Info:
	cq+fuVxNYlGqn+tDQcSKxknueDgsLlvZIRpw99QB3O9vkx1tO2LdVe7vJr9T1W2h/XZ8sZGl7ZvILD4J5+D03BIm+7nge+fbQVkJppB9cTc46hWynfIdKYmOJGu5b2Rwsj7AF18y1+/5hrnsf8e3KxRhygXzTv4PCClIcTwzsSmfxSJzAGzHJ63X3JQxJr4pv0LLPfObAWjpNrnqmsLu45wxrt3E7unSjTl+/nAnFej2oMIsfFg7ZhDAe18gE2fhhis5NmazcVBYfRj2ECK+MBlnXfEUPO9urjV1i/wXoS3p3Iwn/cBSnh/J4q/JepxqPEAeZfkRpdteL47zWpa+0ulNZzjuD9LPCfXZN4m42SxrnjpcZkej95GInid9uaVoYhE+4JnAcMOmNUHWwNnvWSn8ZyZx8L7TStymb/WbFoWNsX6T9gkBKHPcH6WuqusiFK5hM45h5uozlb8S6deE/l3VhsQuISjFAgNnWHpqgpZdrJuf6Br8a7ofI12gIhN9HVJc5ZMOTL91LngmrKrmjW8PnFS036we435BWe7QbDsb2rFffch0DNSUiiGnvTRchjNMoIe+ugxUm6OMUhktSdeECDw0eMaiIfvHxci4ol+4CvqQAXEYp5Mk7oODiWMTalQqo198PJAWbrAvUR3aocdOOwKGv/sY0TNxdX+APr0=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM3PR12MB9416.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(23010399003)(1800799024)(18002099003)(22082099003)(56012099006)(4143699003)(11063799006)(5023799004)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?eUNTZGdJaTJjQ1c1MDJvZzRqd25CeEIwNTcwcFVoNlZTSzFLbTdnUXRDaHpS?=
 =?utf-8?B?cXlQWHBSSlhOdmRoTTEzZVJkQlRobEVOZ1hxcHZpdUEvZzBFWHBxRXJyVTBs?=
 =?utf-8?B?R2NVY2RONGxrek0xb0pzc2pVZlQzeEo1WVkya0ZVbkNHQTd5OEJRclJLZEoy?=
 =?utf-8?B?WHcvdHl6YkhaeEhEclhxWTNxc05vSEd0TTNHTGxKTXEzQndnUDgzL3BXVHVQ?=
 =?utf-8?B?eEVPd2haaktBMlRKcndHTUxlMlpFeVlSK29USktrZ09iT2Q0N3d2cmIxOWZW?=
 =?utf-8?B?MWRiZVN5cEE5SHdXZ2xub2tKQmhQRXptQXdTdkI5YnFEcWhySnpkMzlobXRU?=
 =?utf-8?B?K0tVSEh2R25Kc2pXQlNaR24xL3pXTDRPTTBQbVMxdldlbklOeFZtRnVsVHZt?=
 =?utf-8?B?VlZJbGZzZWZ2UGhEaFRNTkRhUWN5Z2RDemlrNE5hcEUwWGRjUGhWQVA1d1Rk?=
 =?utf-8?B?VWtnKyt0eU93Wml5ZFo5dGdqY0ZFdjUwLytmN0xYVGxFVEZNUDFGa3I2d2JB?=
 =?utf-8?B?Szd2cm1nYjNRazdwb0dya0JWUVdQRGJtWkFaY1lxTTlpRkpxaHhDQ0NCOUlY?=
 =?utf-8?B?Um5hZ0s3V0FpTUdvL0xLa1I4Skt1WXZPZ0lkcFJsWTVaUDhFc3BDT29uRmRj?=
 =?utf-8?B?cXRTVE1nOVFXSXpzQXVPMnIrTVNIT3ViQVlvVi82aWJZRnVkeDQvQ2Q5WFl4?=
 =?utf-8?B?aFNBbzdDMXU4RWRNYlVEdXppQVo2b3l0cU9yQnMxQVZpSi96Y2tJalBYd09S?=
 =?utf-8?B?ZVMzdGkwckFhcVFwdHNVME03dDNvUzZTOWRkNjlVeC9Pa0t5V3BXSHZyckdv?=
 =?utf-8?B?TVM1U2Fhbm9BZmJ0U1BuelpKK1ljMGdjeXdOd3lxckJMdlI4UDVpN1dsUnB2?=
 =?utf-8?B?MFpIRGtQektqTmNaa0tCK2Z6dC9QTk44d3pCcGVndnFyeGxVaEM4NUU2Qkl3?=
 =?utf-8?B?UVNzSzZvczk4TE1NcDdpV0N6WWZqUW83WGU4bTJYV2ZvVGVBNGV1YWJQSFMv?=
 =?utf-8?B?S3RHRXZtWFN2elFFSy80Sm12Q3dZcnNvcFo3NTgyN29Ld29iUy9Odk84Y2sx?=
 =?utf-8?B?Y1IzNHczNFJRWmg1Y2VyYmxtSm9WVkV1WW9Gb21GTU84MFVPNnl1bkhrR3Ex?=
 =?utf-8?B?cE9nZytkalNMNlRjZlJRQXlLMUhJSVZ3S1BJbHpRNzdzd2o2eVVXUHp5dEtJ?=
 =?utf-8?B?d1A4ZVoxNU8zcUtVYkRvSVN0TXVtRVh2a0g4NEo2N2ZlbHo1dlU1K3BVVkJj?=
 =?utf-8?B?RC9oWndJbEYzNjc2Z1I4L0tSMDVhZm00c0FGcGJYV1lWUWlyZjVzakJGQmhu?=
 =?utf-8?B?OE5ST0FIc1h3cFdFVktLaStNbWtwd0FqRUJlRGtSSHRoL2dQdDhsdmdwNldR?=
 =?utf-8?B?QXNGK3ZMMllJQXlGUmFnS2phbU0zajZ2aTJpckpLdDlQMVhESWJvblpkMHht?=
 =?utf-8?B?SU53MlZBNGU4TEtCRlc1MlFBWk1ubWt6cTFqMnBpY3ZmcUZWRVI2emlSN3Z1?=
 =?utf-8?B?bVJhTys2RVkyMUtEZUhWQkdlc2hSZGxoaFFLR0tOT3JVUHIvTGFJU3QySFk1?=
 =?utf-8?B?TVI2dFNGZkovVVVsSEtXUCtiWlhiL1hkcEtwZkZ1cWNwSlhuMmt0OVoxYkhM?=
 =?utf-8?B?RjlmKzk4MzYrRXRpK2NMU2xTMHpEWVg0blFxcjZoM2U2Sy9QQ0pEZWQ2bDN1?=
 =?utf-8?B?Y09kUE1nRDJKNXlqSi9qUEZ4Nk5HV1lHd3c4NzZsUlV0NkVHR0lsQlI0dUFE?=
 =?utf-8?B?SjNRZ3VyTFVTMkdxMEhtbVpDclRFR1VlemNHUTlpWTlwMEUzM29JbzUzV3Mz?=
 =?utf-8?B?LzVkVDNJMzBxR2QrUUdWOXRnUVhXeGR3UERVREZ0Z05VeWtkTHo1UURVK2pi?=
 =?utf-8?B?UG1US1JpMHlUcTU5UFhvKy9mZmw4UnZVaFA3MTBqQWdMRy9qVXFhT3BZRkNj?=
 =?utf-8?B?WmdwQXRpNDh2djlScE9aOFRhbnVEaFdQa1cyZE92RVQrL1B5L0laWWlGMEdw?=
 =?utf-8?B?cXoycHhOL3JuRlEyaGMrYTQzZEw0eGg3QlR1c2pwLzlzTFVTOTA1ajVRcCtw?=
 =?utf-8?B?aXRsd2twQnpmR0dFMXczQUJScktZTTFvV3BDRkF4VlgxYWRVMUR0RG5mRGNo?=
 =?utf-8?B?alE3dlhGN2JFdGxOVVpKenhLaDFtMEJvQm1ZQ0NRTGVJRnNYVjNISWtacmFV?=
 =?utf-8?B?WjJBYkRSMmlQcjB5MWJQT0dMenhTU2JrQ2tZeGFqaEhoeUR1T1hvMVBaREM3?=
 =?utf-8?B?eHJzMHg0QTQ1cFNwZ3VrTmFKSW9TNWxxMEk5T0tYWHdxMkVqaEtOcWtTMjlx?=
 =?utf-8?B?dGRVbkxmb0tvOVprYnhGN3pHdHpGQjNmelRaQWdwUUZSTStGVjVkQT09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: aad002ef-6bfe-4ce8-9111-08deec491760
X-MS-Exchange-CrossTenant-AuthSource: DM3PR12MB9416.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jul 2026 01:39:40.4321
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: EPCVSqu2is8MSeuYCCrF/0DSn33j6JneykYErDYYnE3IY6rw4KxWQrnV1/NF6G0jilq3IGVfx4q/vF8zE7+VZA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4174
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 98F2E180005
X-Stat-Signature: 5g7n7yg1fuasoroc58ijcci5pnkydxyb
X-HE-Tag: 1785202784-883252
X-HE-Meta: U2FsdGVkX19HbNvDd6l+MmUH3NKyW2d+D95M5a3F2cMCYJ4otAyop+A5BVQR69TBh4w9FuX3nlMccg+gzrkb1AQ71ajC4csy1H1FZl6T5NvJcBsjF00K7NBTPontnwnVkK/LxCxscwpzym+stjisCg6EA5NUoN3rDI4xai80Xg616GXzdmNFAtru8zC8R1y++sOKjejg/AT327qRFZfTuHgoMmrZ93diVb4UrhMYp1p1x/xe2O52PcYDzfiQ5KotIgjyG0AulEy7Y90SaNO84BPo3wNeAbTkdx8n6XuaqE5nI63Xhf6UpC3rPihXgCh8z5h8Hc5wvrCxZb0jh6RCi+rNRbTF8MzSaYtQih2kjqgE2Z8L6350LaR0UPnNcGbCJap75mdNtevDu1wqZhXtrWI3WHiXTxms6DuL0abJYdhToKsbdEs0a7/92J7dPn2YOfFcKar1g3ckUkEpoP/Dz1Nt4kNfqY5vTcGj91URZEXmBSP33/M/3L7ZQDwA8+9hJ64SvGF8Kv5Wzpa57thdbqf8rE+1dqly+xtokraA4oywPRud9hbCvTo9JuzAhtqlRgMESu/D3odcli9QJzQ0OLdxWYBmXTt4y5lTp8JeuRRCzauzLvdlrZ3cn/jXXTxcLJOpJgTywSQXFWenP/6HCv3DBwjsLIexTroxkzztSguNtXUfMDXMEphJX3miNtdHqt7L4mdUkil3xFdakdswo/dEpwpOMAt28UKk75Z7qEUkra+WBOzZYcC2tlU5fQ+oreVYfEWq0U6+ZFA7jR+AvdXPKDy+TyxMBIilKxLyBl45hf2SXbLdPFMf/tMoLB+PhtdfC6PRGveeeGA4hL5rUb/8cFsZZvq083jQg439fGqdKlaf8Ix3vS9kaXD0cl1/M/EiZMLsE4XDE2jB3Hj8urFSvsh6VLkGxZFgJzsh2X0DKXsWPLtT0A6x1wn+OteaGzf9w/eOGEUzb1iUqma
 ajk1CDVf
 cm3e2yvViGsYSxr5mpg7R0ghuEVHfZUEAtMg3XfaAZOnxzmC3P5N7T/UaD5S9pwT+OSljofii0B/2kD4+LBRIXuS3zZV3c8yeFiLcpN7tWwybtVlOQVvPHRp0ZTncjGooVnPUYGwhPt3Xmo3z2AT+tr2RNy9aOECpzhQ2MHU65EB+LxXHvaR4v2Shg2tho3xPKb6OGi7OMh/RSndXXjp4eUo+pYtatKPc/DeewW5DUqRa6qcdW1NF1oPTOOhJO6Yawz3v4btKwaFltM1N+GKoSjlQcR0bdyv4r1IzLMicvOUY+Ii9k2YwB4GYdXmQTTazAa4kbhSzxK7NPp1trwLWm0w9dOGUW1RSbr2U5vn4oJBBZANUTZsaAl9Jw/NhTFRlaeTRuqk7VK2pML4yLFTV+cTOVKqnN8OvHL4MfDzgGUsFzsUwWc2gbFTnWCt1rbFDNSnO071eRCtWnKs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/24/26 3:29 PM, Rik van Riel wrote:
...
> -#define untagged_addr_remote(mm, addr)	({				\
> +#define untagged_addr_remote_unlocked(mm, addr)	({			\
>  	unsigned long __addr = (__force unsigned long)(addr);		\
>  	(__force __typeof__(addr))__untagged_addr_remote(mm, __addr);	\
>  })
>  
> +#define untagged_addr_remote(mm, addr)	({				\
> +	mmap_assert_locked(mm);						\
> +	untagged_addr_remote_unlocked(mm, addr);			\
> +})
> +

With this diff, mm is now getting evaluated twice.

You could instead do this:

	#define untagged_addr_remote(mm, addr)	({		\
		struct mm_struct *__mm = (mm);			\
		mmap_assert_locked(__mm);			\
		untagged_addr_remote_unlocked(__mm, addr);	\
	})
thanks,
-- 
John Hubbard


