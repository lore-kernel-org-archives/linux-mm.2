Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 04164C61DCB
	for <linux-mm@archiver.kernel.org>; Fri, 28 Aug 2026 20:59:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D13906B0088; Fri, 28 Aug 2026 16:59:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CC4766B008A; Fri, 28 Aug 2026 16:59:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B8C2D6B008C; Fri, 28 Aug 2026 16:59:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8613B6B0088
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 16:59:06 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id F304C40594
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 20:59:05 +0000 (UTC)
X-FDA: 85151893050.18.1B133FA
Received: from CY3PR05CU001.outbound.protection.outlook.com (mail-westcentralusazon11023078.outbound.protection.outlook.com [40.93.201.78])
	by imf16.hostedemail.com (Postfix) with ESMTP id CB00E180006
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 20:59:02 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=os.amperecomputing.com header.s=selector2 header.b=Auyae366;
	dmarc=pass (policy=quarantine) header.from=amperecomputing.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf16.hostedemail.com: domain of yang@os.amperecomputing.com designates 40.93.201.78 as permitted sender) smtp.mailfrom=yang@os.amperecomputing.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787950743;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WW2b3IJFH3R5O+YyVv5U6CsFkBHtaNIK3J3+4SAj95M=;
	b=6ZUU+jyhpGAeNcGayUwrKeDf5d3zcmCDONKWraLtL2SGSrPdWvabSP8ah2d490amCfs0OX
	2GSSQJmbYb51NkbshwPZZ+UoSrAvuXjVVCqGA5Ojdq9ZlAXNFdDMUZEMxQ8R87Pu2ndmyG
	Aoeup0TRTVh6pY89QIlMYwoiOX+c87I=
ARC-Authentication-Results: i=2;
	imf16.hostedemail.com;
	dkim=pass header.d=os.amperecomputing.com header.s=selector2 header.b=Auyae366;
	dmarc=pass (policy=quarantine) header.from=amperecomputing.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf16.hostedemail.com: domain of yang@os.amperecomputing.com designates 40.93.201.78 as permitted sender) smtp.mailfrom=yang@os.amperecomputing.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1787950743;
	b=h/CqaBb3LR4nbVZ5Pp3bwHmrglt7GJ7ZoyhHLIXMiTWymtyO5kSpLJK2ol1eLrdGB7WTo3
	ZOZcsEIJM1Eae/RhZsv6eHfNduSiq2chH6FhcATIEj1y2zRcX9Ykzw3NHTKI+Oso1kwmop
	8iwukRyqw+/08G7vOFYGPb207RmO+pw=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=s75x7y9CYuaM9/nGDdUBQ6qz/jdjubZvqP3XYOOZjRDkvz/btW+GwdJa89J8v060M64444DbNdzc8C57pgTC3W1CW+aUuGjO8iwvRZl1AvLwGit6H3UBnmcc+DziYzFgGKIYq4oN8OqmvnZ9XbJ6foWS/3hrE+lOB/V1Obhpib49maluEBHn9yjqjDVT+gkUFhTTvmshOnvi/Pg2jshRGJD6Bsqd6EHlLiFCcqbws/KfVnj8+IWu/4FPu7E7O0L8GdzB0/R5aJ5mn15GucxJL4pRka6GrkHRP+32t/Vq96RtVg2LoI+8xrhd7FMB0hwzlSqpWYhy6qyFRW4BDfBmaQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WW2b3IJFH3R5O+YyVv5U6CsFkBHtaNIK3J3+4SAj95M=;
 b=eD+yw08qYIp0AZ3G2TUQZplaFIXxMPsGd4KEn0031TRTVRTDstnvpqAoaUHFA/9nivE8TS8XKyet1A/rn930Yg8U7Pw26ILIrRbQWRwkcDMbljcDw6jcgA/pet4SYtvWMMllmaTWsG2ct2/01YrS/FIqeT/EyI8N/Jr9lWhXibBnpeEo8lA6O0juj70nOv7RskZQdOmZEDClswK7joHjTototOE9FWkOpuwi8rSj40tHOpR26IXXmAN66o1byECkjAHhyf2w5OkDqztMDBbuaALadXhLGog66NwVD2osi9rX0aZU2ctoVXMzAxM4oFR27ZnufgH9v991T5mkdF0vEw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=os.amperecomputing.com; dmarc=pass action=none
 header.from=os.amperecomputing.com; dkim=pass
 header.d=os.amperecomputing.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=os.amperecomputing.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WW2b3IJFH3R5O+YyVv5U6CsFkBHtaNIK3J3+4SAj95M=;
 b=Auyae3668u/x4/puHoVkeHWLI5szYcul5PYlCDiFJWpa7DVmPrBh8+RcYzYVN0IyJnmjDaTdYAJyLpib6nr6cTshcb30Nt0XwJOfltYUPYQZF1YSqBDPIFB1CYdRckkMXeYEYl9onyYqu/pKo2xVVJAUzHulD10sNyM7DGAYaTU=
Received: from CH0PR01MB6873.prod.exchangelabs.com (2603:10b6:610:112::22) by
 DM8PR01MB6999.prod.exchangelabs.com (2603:10b6:8:18::18) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.360.11; Fri, 28 Aug 2026 20:58:56 +0000
Received: from CH0PR01MB6873.prod.exchangelabs.com
 ([fe80::46eb:64a3:667c:c1a0]) by CH0PR01MB6873.prod.exchangelabs.com
 ([fe80::46eb:64a3:667c:c1a0%7]) with mapi id 15.21.0360.008; Fri, 28 Aug 2026
 20:58:55 +0000
Message-ID: <6c8d880a-0517-4669-80be-8a134f4bf7cb@os.amperecomputing.com>
Date: Fri, 28 Aug 2026 13:58:52 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 00/18] mm: arm64: Add kernel replication feature
To: artem.kuzin@huawei.com, catalin.marinas@arm.com,
 akpm@linux-foundation.org, david@kernel.org, ljs@kernel.org,
 vbabka@kernel.org, cl@gentwo.org, linux@armlinux.org.uk, will@kernel.org,
 mark.rutland@arm.com, liam@infradead.org, rppt@kernel.org,
 surenb@google.com, mhocko@suse.com
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, wangkefeng.wang@huawei.com,
 panov.nikita@huawei.com
References: <20260827161158.3618409-1-panov.nikita@huawei.com>
Content-Language: en-US
From: Yang Shi <yang@os.amperecomputing.com>
In-Reply-To: <20260827161158.3618409-1-panov.nikita@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BY1P220CA0040.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:a03:59e::16) To CH0PR01MB6873.prod.exchangelabs.com
 (2603:10b6:610:112::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR01MB6873:EE_|DM8PR01MB6999:EE_
X-MS-Office365-Filtering-Correlation-Id: bd39a912-c37b-452c-aa1b-08df05472c65
X-MS-Exchange-AtpMessageProperties: SA
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|1800799024|366016|23010399003|6133799003|22082099003|18002099003|55112099003|3023799007|11063799006|56012099006|5023799004|10067099003|921020;
X-Microsoft-Antispam-Message-Info:
	mOyE77vJe3PnqPPArWXcSi6WaoWTXYMjQpWVxqOvukyTwR7jNYzqKr8IR3cM2XWEtMGkZGkdq7CdNrxbLD3/v0rv9R0eRqE6c3NDAuPhkAunopeaU1h8FRR5gXVe90siqBdFIdz1tBn3ZKdM8yDX7wZY20id+v+VPvK553DquOP2uPIWidpQsrHcTrhhhSChQ1dQRU4jZB4n9ikmp8xVJfRzPR33OAWjRfsRiwsi5UnOvKJ/2Fw3XGnet3LoCAfG0YiSfumlUJHbHNstgCHmeMBYYOUsR5vT7Y2+U4+hOHxjokYnVm7EfUmBO2JkdNDIlQkFBktEVk2QrWNQQ3QhkspxhK5FU0JjQ/rrVUSIhYK+YqSKzy+WzP2ug3uO4AVLPsA6tvZ8juntjT+5SyKDkL9lJpQ6npvSMmwFxw8XIv3wnJ2czLPMxJmj4Rt/VDERNAn/M7SZyrxf/KhBaPLxlwfCjYyz0tXs18fnH9H2K5hIeCKt1qJOYMs+obKZMj0wS0Wq099GMm8pbVaatmyn9d6V3GqWvEgAenQT/sgXdEBFH5BrUgLU8FueRjb4C6oATWBnjRpMCb4zKk65pEwB7bL3jaIQz6sjJFU/VAfwNCBlQQ/PLkzBt09HZ1GQ8nVa/RpSI4tzDqLqSayREbaKXg==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR01MB6873.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016)(23010399003)(6133799003)(22082099003)(18002099003)(55112099003)(3023799007)(11063799006)(56012099006)(5023799004)(10067099003)(921020);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?UWF5aXdhMUM4NzQ0cldyVHpWY1J6NHQ5UU1WY0JISFM0TEVzZnRJcXFlbnd5?=
 =?utf-8?B?eWpINXlRL092azhKUGduVW5WbXdtYjlUY1NaR21zK0tGM01pUHRQQnFsTGZQ?=
 =?utf-8?B?RDBhZHc4UGk4NElFSnhZbTJUS2Rub21wSEszSjhNbkV4K3hPcTlVNzFidTFE?=
 =?utf-8?B?T1hpcmpLRUNuVGhiNGhQbVlmd1BueEs0T0hlOFhHY1I2UlBoYkU0L0JuVm5E?=
 =?utf-8?B?dmVCcWxYUzZYZzlnOEE5SjUySmNTc3dTemVrQkxyYXM5MEdoNVVVdW1IRlU1?=
 =?utf-8?B?N08wKzJGd0x6QU45RmEzT0tCWTY4V3RaZU5wZ1JYVHBDRkVFZWx4K0NpSVlQ?=
 =?utf-8?B?NDR6djY3anZITGJCWmNTeit1M0liajNjVjFyY1p6cnVGZXFlWFpOUGhGZ3JY?=
 =?utf-8?B?VFNFVjAweTJoaE8vTXd0QkszOFR0MS9zS3pBYUtSK3prc2d5bDV2bHJCSVpi?=
 =?utf-8?B?T0hvT0lpOThoeG0zWHY1NEE1U3cycUZ4NUQ4S1JhY21TZS9rSjVzUHQxRnZK?=
 =?utf-8?B?ZEliRmZFVzhRRng0ai9QdVRoeWJGNHl5TDFLalRpTlBNMW16bURTR0tIY1Z5?=
 =?utf-8?B?cXVKcUJCdVg0aGZ3NjZMNXM0SUFXYnRPUXk4NmxmQ2RGOHlWTUpYU2xidGc4?=
 =?utf-8?B?Ykthcy91d2hYZFFyKzJKazl5K0VLMllTTk5BOFhzdzV1MldKWE9hUDRoUFJl?=
 =?utf-8?B?VFRTV3BzbkZJeVJZRVA0NmtrTFFySlU2MEJmV0QwK1ZNYjREbzhSQW5VL29v?=
 =?utf-8?B?a2V2MkkwdXJ4a1RHTncwMWcrdmNLNE5STDdma3hjR3hUYTIwelRyTTNBRm1u?=
 =?utf-8?B?R3puOWhnMHpPRGNCSmVrdGhLcGc3NTVQSE5RdzBuMVNHcVo2em81OFZ2b2N1?=
 =?utf-8?B?aGIrcDFCaHBhN0dWbWRCZU03cmUwYnlrZEk2dVZYc1NtcjhsUTE5TGVLMlVX?=
 =?utf-8?B?cHRJVm12d29IZ1B0anFOTlZxQ3AxWHgrM3Nwdkg1T2FEMW5iSHRld0daZWRX?=
 =?utf-8?B?ZERGelJMRCtNcmkvQllEcWIrZEszQXl1cEsyZXRZZDJhVkk1NWdCVnJaRXV2?=
 =?utf-8?B?V241TjZwQ2xYMHRQZzVQZ1hob0Fuc1ZlNEN5Z241M0p4WGZpaDl4VFJucG80?=
 =?utf-8?B?OXA2WkR3azV1MG4xdHIvZld3WGUrRVVoTXRRbUxSQnFGODQ5WkFEVG9IaThr?=
 =?utf-8?B?S0k0bTI2K1ZEcTQvVWJ1VTIxQjhPUlBpS3E0c2NPSHBXYzAxYTl2RWRBLzRn?=
 =?utf-8?B?bjkwMUtMLzhDUnNCZ1JvNktlN0x5VXdkWXhKZUg0ZUk0U3hpNXdHZThCTUZC?=
 =?utf-8?B?aVozNE1vdnEvSUZ1dWZZemc1VVZPQ1VzVlErRXl3NUhuamc3UHZ6SEZrSVR0?=
 =?utf-8?B?dFcvUGhJL2JjR3FRQlZ0bVk4ODE3eitsUW9sTkx1QUpiWXBCN3RPOFFSckNk?=
 =?utf-8?B?WWVRV0tZNW5NU2hlTGg0NmQwUjNGM05RRnQrUUhka0JsSDF3elYxaUlXelZp?=
 =?utf-8?B?dVpwV1JBT1dJMnRFZGFxcjRCdnFlbzEwQTFBTVFKVUpJa3hxWDhqeXJqRUNr?=
 =?utf-8?B?TVFjbkR0WGFMYnlNUUpoa01lMFZDaktLMjBOVE1ObkszRTZqKzJoZWRGT2dt?=
 =?utf-8?B?SzVqRVhPVUhWdWV5aG1WTGtJQlB4dnhsUFV3TWNNSWVEYndmaU12Umh5KzQr?=
 =?utf-8?B?ZEIxU2VOYUE5MU1pTWNhWnJsbG1PTUwxUUtxM01pOENPYUpwMnFwRmFYYjMy?=
 =?utf-8?B?ZXFBSllBTHdzVVFncENuaE1Zb2RiTVl4YzlIQXpOcVJOVEtPNm9IUWZTeW5M?=
 =?utf-8?B?cloveWU0UW9xV2F5cDVwbTBJVld6YVl1YTJaN3NoZjRKR00vSXRDZ25tU2Fl?=
 =?utf-8?B?YXZ3bElFTUI1M3ZqWUh2WS9qbENCODdFQVkrNTVNMkpmV3J6TVhCdVFKQlov?=
 =?utf-8?B?K0Eza3JueExtdGFlWjMrZS9mM1pxODdsVzJJbWFpTnY4dWx5QnlXbnNrQVVW?=
 =?utf-8?B?V0k3U2l2R2R6NkJHbjIySWFCa2FZeVpwczdjTzhYTmd1UDFhQzNnL3lnVEZH?=
 =?utf-8?B?Z3kwVDFxK3REMmZRa0N5TDhoVVBzUnVjVUxKdk1JU0dGSWFKbEh1WFpTWEFU?=
 =?utf-8?B?eHZONnE2M00wY3RuYWRJcFZ4cFNmZlN5d3lST2tPTEpKdDhqcmx4TG9TdnFG?=
 =?utf-8?B?YnF6Wm5tUjh4Y1BsUHpiaDFBSVEwcE9CaXlGRFhHMU5OZklRZG4zb3JCY3lk?=
 =?utf-8?B?U2dkZnpxeEI0MmY1OUhSZmtqWVhIWVpxTmNPcE1EZEQyd3pBQzNtSUZHSlRJ?=
 =?utf-8?B?MjRSZXBwM08vM2xNVGx2djZ4WS9aRFNVOGE2N3pBVHNSakUwQ2NJc1VTS01I?=
 =?utf-8?Q?l812XpGkVjXueJco=3D?=
X-OriginatorOrg: os.amperecomputing.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bd39a912-c37b-452c-aa1b-08df05472c65
X-MS-Exchange-CrossTenant-AuthSource: CH0PR01MB6873.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Aug 2026 20:58:55.7650
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3bc2b170-fd94-476d-b0ce-4229bdc904a7
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VCfZS0LbDenOmrHUBvBnRVnFxau0iqLBSaV99a1zH0R+8gJynVpzMc3sduJ8l0Lizdhe9EdMuZW4x91/4peCS79CG0zARGpjv9mSgdodMyA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM8PR01MB6999
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: CB00E180006
X-Stat-Signature: 4f6ya5c6r1da6ax4fezynjro4ysptwff
X-Rspam-User: 
X-HE-Tag: 1787950742-829428
X-HE-Meta: U2FsdGVkX18vSUIQh2XZsj8n+FaF35dxXihucgk+oarxv4u5sS6EtcC2mK6u50rP15kQ7is8UL5nS0t+N5gRrKXdZVchiNPCdjcIOj5musQBu9BYPArOJ9tYtCyhSZTB/2Q8ENwL/ADkcmBEhYJ9fUe1jHRlq5dYau3MLe+ISiCTvoAZ+BvTvm43qbXDTM5lUY/uer+R9uuG7DhuIYen+2s4aLJtgcnPoF7NAq5NIATOLP1JygtfzdzmJdziln1hVv7nkRfSps8L3HdPz8LhV1uJ5mVuRXcLHjswt87UNPeLoFMy6xOZWhLmoFcBS1v4Q6b+eMV04WnveY5KUQS9IsLvygzbQjyKgN1YJ2ADWO/x9E3PnlWQ/rQTFNDVxEl6NIbv9lJws2rIrpJxoGpD2CgZwCtT9G935yGa/Qn1b+LGZo/VgC8v5VVjeWKLN9w9q3pkcOns49t0IYdZZPqF9T2QiQbS0/GBRpW3n6B+Zm8mE6GTzXLFo5cgEstSjdAa4Nds3bb8CCWXpyA6vn8U/lOuSHkg8Ikdvk9+y3fTil6/x1gTTb+5dma3viZUcyWdfH7FdAyeGwSChzNuLJLvx7iwWi601l7sg6rZo2rmPZ8zB91UBoRFI8hc8/bLY04Rc5U3rik/k8Mu2XSpx0EJe9ObbJ7lCKMBaO2Ikq+9bxpLWihdLJJT2CzMbxmgQHFsXL0yubo1HZ+u9kBAzOWoihjhUoFmZParkVgnjhnUOKLZmS47kFQCAUyvCn8SvC/+5jt6U/fO3o7ioYpC/+HcrFpl+Upm6vapXH7mFH4ZmHAkoYbOxa0YRzAi5+CFNo+gqxFdOBGaNk2xl6ljBcXBNZj0QsoDcYGiNPvHj+MWngaKQfSOLEaxLz8ybolIJTOUObIii60hpQJHeFkaZuhkPd/DEKPFPdxZqqMOa+9S0NPFqeXChKBAyUGpQkirHUA9cTTpw+KRfC99C7caomZ
 7CZaSB+F
 Xt+yxKSHUZ2rFFPZ/t5BQa1PfP02DJGASgn6H1OZxHucGepc9HQIDfLOp8EIvcRXjgldpD6cDpbv2sPcp3nntYPKJwdkGjOmeBs9B+hj5jFwEkvlJxarAuw2OEgxM9FVTsQux88Dr7PW+jTM8ETqFvX0uzVyzTy405450iZ2fSEcZ/ecLRrO0xFi3BF17zcznAuML+Wt/PYc3yuMNhwttSvyit9C91CCK7gQ2sd8MD42m9+zntzl3HRe+8uTJdeZLk7bFmTxPfMHeKV3kEr2FThAwUrYkV6X6TfWuejFGfGGOWrVo+IYpOYOjuJv3wlCp0kvFojJo+C3rc4RkHNdQ2pWsb5OOLhpMlCacOhVd5h3GX2mcnTIEBYEyd+KafYSZHeK0rihJUIijlGpw3vmx/aBLpeGKPik2pnen0J//gugMdTvmrD1SJtOzdUoQUvywzkJi79ZkwggNjit9LuBA9J1ItZgn94426tettkSOkz5+c3+CdR5TrWVtIvBnZgbFrClkF/TqpOqfp52HLH1WcvqrIPr6v06I6LwlfX0nv7wGtLb6t8XAq/AJeUy+0cQclBg5IxvdHTrxfFnJvRaY8ixej1hPphIc8wdqBSvg1c/2tkAEgI+z79FbfmnwdD0Q3hZsFFNCgYrgcndxsDXrsaCrejivqAfcWdB6aDc/9uPUlaAW71oZ5rI1VuIF7cujsZsGSaWR3N9hpkZLhbxkWiFFXFiehqdoS2r5gGFWf7ugQyTbmqJlxBBi7eKDKNF3Ggji50ukaxjWUZ8Jr+v4otraF1Ix5uDDxZAVNgUjppCZXMOAeG45rJnlOvMmv47YxLMTDrE1inSmUNw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 8/27/26 9:11 AM, Nikita Panov wrote:
> Current status:
>
> There were several prior submissions with some sort of replication
> for NUMA systems, including one from our side for the x86_64 platform.
> In the last couple years, several research articles related to solving
> locality issues on NUMA machines through replication emerged as well.

Hi Nikita,

Thank you for the effort. As Christopher said we are working on the same 
feature. Please see the below inline comments.

>
> [1]  - arm64 kernel text replication
> [2]  - x86 NUMA-aware kernel replication
> [3]  - x86 kernel text replication
> [4]  - NUMA replication of user data
> [5]  - Mitosis: Transparently Self-Replicating Page-Tables for Large-Memory Machines
> [6]  - WASP: Workload-Aware Self-Replicating Page-Tables for NUMA Servers
> [7]  - PaCaR: Improved Buffered I/O Locality on NUMA Systems with Page Cache Replication
> [8]  - Memory page replication for Linux on X86 processors
> [12] - Optimize this_cpu_*() ops for non-x86 (ARM64 for this series)
>
> As of today, none of it was merged into mainline.
>
> Patch set description:
>
> This patchset implements initial support of the kernel
> text and ro-data replication for arm64 platform.
> Linux-next was used as a baseline.
> (903c1cf6dff9 Add linux-next specific files for 20260821).
> This patch set heavily relies on our previous submission [2],
> their generic part is the same, these solutions might be merged into a single one.
> However, after thorough re-evaluation, we were not able to observe
> performance improvement for the x86 platform, so we have decided to stop this
> direction and switch on arm64.
>
> Current implementation supports the next functionality:
>
> 1. Replicated kernel text and rodata per NUMA node
> 2. Vmalloc is able to work with replicated areas, so
>     kernel modules text and rodata are also replicated during
>     modules loading stage.
> 3. KPROBES, KGDB and all functionality that depends on
>     kernel text patching work without any limitation.
> 4. KPTI, KASLR, and KASAN are supported.
> 5. Only part of a translation table related to
>     replicated text and rodata is replicated
>     (up to 2 pgd entries if kaslr is enabled)
> 6. 4K + 48bit and 64K + 48/52bit are supported and tested.

I think 16K + 47 VA bits should work too. I guess it is because there 
are just 2 top level entries with 16K + 48 VA bits. That requires some 
extra effort to sync up kernel page tables.

> 7. New cmdline option: "kernel_replication=on|off",
>     to configure on the boot stage
> 8. For verification check dmesg output or /sys/kernel/debug/numa_replication/
>
> In general, setting up a new pgd entry in kernel translation table
> not often scenario, most of them are covered by current patch set.
>
> TT overview:
>                     NODE 0                   NODE 1
>                     KERNEL                   KERNEL
>             ---------------------    ---------------------
>       PGD   |@| | |@|   | | | |*|    |@| | |@|   | | | |*|
>             ---------------------    ---------------------
>                                |                        |
>              -------------------      -------------------
>              |                        |
>             ---------------------    ---------------------
>       PUD   | | | | |   |@| |*|*|    | | | | |   |@| |*|*|
>             ---------------------    ---------------------
>                                |                        |
>              -------------------      -------------------
>              |                        |
>             ---------------------    ---------------------
>       PMD   |READ-ONLY|MUTABLE  |    |READ-ONLY|MUTABLE  |
>             ---------------------    ---------------------
>                    |       |                  |     |
>                    |       --------------------------
>                    |               |          |
>                  --------       -------      --------
>     PHYS         |      |       |     |      |      |
>      MEM         --------       -------      --------
>                  <------>                    <------>
>                   NODE 0        Shared        NODE 1
>                                 between
>                                 nodes
> * - entries unique in each table
> @ - same entries accross replicated tables
>
> Since for kernel space and user space different tables are used,
> user space tables are not replicated at all, so synchronization
> is not required.
>
> Known problems:
>
> 1. Other combinations of base page size and va size (especially with 16K pages)
>     should be adapted and verified.
> 2. Replicated translation tables for the vmalloc region are not local right now.
>     Allocation performed with default memory policy, so translation tables
>     for kernel modules will not be local. However,
>     replicated text and rodata of the modules are local.
>     In general, vmalloc patch should be cleaned up.
> 3. Any modifications of kernel PGD level. These modifications
>     should be synchronized across all replicated tables.
>     Right now, for example, memory hotplug/hotunplug
>     lacks this support, vmemmap and kasan regions for
>     added memory might not be observed correctly. This could be fixed
>     by patching all places in the kernel where swapper_pg_dir
>     is modified, or by "lazy" propagation on kernel faults in the pgd-level.
>     Propagation approach will not help in the case of pgd_clear()
>     on swapper_pg_dir though.

My percpu patchset (I saw you mentioned it above) already had these 
problems solved. I have not looked into too much detail yet, but it 
seems like you have replicate kernel page tables per node. My patchset 
added percpu kernel page tables. It should be able to support kernel 
text replication as well without too much extra effort. And it can 
support multiple usecases, for example, this_cpu optimization 
implemented in my series, kernel text replication and some potential 
security features. Multiple usecases should be able to make it more 
attractive and convincing. So as Christopher suggested it may be better 
to combine the effort.

>
> Overall, this patch set in an early PoC stage and require some improvements.
>
> Overhead:
>
> Memory overhead for the kernel itself is about 30MB per NUMA node
>    on our deployment. For kernel modules - depends on their sizes, but text
>    and ro-data are not that big.
> CPU overhead - replication performed on the boot stage. After boot
>    only "rare" operations are slowed down -
>    module loading, text patching, kernel table pgd-level modifications.
>
> Performance evaluation:
>
> Our local testing was performed on
> Kunpeng 920, 128 CPU, 4 nodes, 100Gb for each node.
>
> Microbenchmark:
> Kernel module with a huge text section (~50MB) filled with CPU-bound
> instructions. For each NUMA node thread is spawned, each thread in a loop
> executes isntructions. Total execution time of each thread is measured.
> The insmod call bound to node 0 through numactl (less time is better).
>
> node                 0        1        2        3
> Before time, s     5.567    7.598   13.294   18.905
> After  time, s     5.469    6.960    6.777    5.531
>
> Diff               ~0%      -8.5%    -49%     -70%
> In this benchmark, interconnect was not used by any other actors,
> so microbenchmark numbers might be significantly improved.
>
> Customer's evaluation:
> We were provided with the following feedback on this patch set
> directly from our customers. Unfortunately, we do not have details
> regarding how these measurements were done other than it was
> a production setup.
> Evaulation was performed on Kunpeng 920 and 920B platforms:
> CEPH distributed storage +5%
> StarRocksDB              +5%
>
> Couple more words about patch set and technology:
>
> This patchset was merged into the innovative branch of
> the openEuler distributive 1.5 year ago (openEuler-25.03)
> and was actively tested in production environment [9], [10].
> In addition, besides the kernel part, we have published
> user space replication (for translation tables and rodata) as well,
> but it is very complex and experimental
> even compared to this patch set [11]. With replication in user
> space, we were able to achieve the following numbers in
> performance improvement:
> MySQL + sysbench      1-6%
> Spark TPC-H           4-20%
> Phoronix test-suite   0-25%

Thank you for sharing the performance data. Does the SUT with 4 nodes 
have 4 real sockets? Nowadays the CPU design is moving to multiple 
chiplets. Subnuma configuration may be more and more popular in the 
future, so we thought kernel text replication can help performance for 
more usecases other than multi sockets machines.

Thanks,
Yang

>
> Discussion:
>
> The main question we'd like to discuss is the following:
> Should the kernel replication feature be merged into the Linux
> somewhere in the future? In any form, not specifically this patch set,
> but the core concept itself.
>
> If the answer is yes, please share your thoughts on this patch set. What else
> should be fixed (or reimplemented and redsigned completly) in this patch
> for mainline in your opinion? We'd be glad to do it, and in that case
> I'll send an updated version in the near future.
>
> [1]  https://lwn.net/ml/linux-doc/ZHYCUVa8fzmB4XZV@shell.armlinux.org.uk/
> [2]  https://lwn.net/ml/linux-mm/20231228131056.602411-1-artem.kuzin@huawei.com/
> [3]  https://lwn.net/Articles/36602/
> [4]  https://lwn.net/Articles/45082/
> [5]  https://github.com/mitosis-project/mitosis-asplos20-artifact
> [6]  https://dl.acm.org/doi/10.1145/3620665.3640369
> [7]  https://dl.acm.org/doi/10.1145/3767295.3769359
> [8]  https://github.com/Carrefour/linux-replication
> [9]  https://mailweb.openeuler.org/archives/list/kernel@openeuler.org/message/C7M5E2K2UD7FV7XYPWPZREJBCOCBIVRN/
> [10] https://www.openeuler.org/whitepaper/en/openEuler%2025.03%20Technical%20White%20Paper.pdf
> [11] https://mailweb.openeuler.org/archives/list/kernel@openeuler.org/message/73MAUDM6WCGSSOKPZGPNZAYRNQGUR6DE/
> [12] https://lore.kernel.org/linux-mm/20260715180455.515692-1-yang@os.amperecomputing.com/
>
> Nikita Panov (18):
>    mm: arm64 add Kconfig option for kernel replication
>    arm64: align kernel text and rodata
>    mm: allow per-NUMA node local P4D/PUD/PMD/PTE allocation
>    arm64: add arch callbacks for kernel replication
>    mm: per-NUMA node replication core infrastructure
>    mm: add support of memory protection for NUMA replicas
>    arm64: add support of memory protection for NUMA replicas
>    mm: set memory permissions for BPF handlers replicas
>    mm: add replicas allocation support for vmalloc
>    arm64: enable per-NUMA node kernel text and rodata replication
>    mm: enable per-NUMA node kernel text and rodata replication
>    arm64: make power management aware about kernel replication
>    arm64: make kernel text patching aware about replicas
>    arm64: add correct alignment to kimage in efi code
>    arm64: add support of NUMA replication for ptdump
>    arm64: add kernel modules text and rodata replication support
>    mm: init kernel modules with replication support
>    mm: introduce kernel cmdline option "kernel_replication="
>
>   .../admin-guide/kernel-parameters.txt         |   7 +
>   arch/arm64/include/asm/efi.h                  |  18 +-
>   arch/arm64/include/asm/mmu_context.h          |   4 +
>   arch/arm64/include/asm/numa_replication.h     |  54 ++
>   arch/arm64/include/asm/pgtable.h              |   4 +
>   arch/arm64/kernel/alternative.c               |  33 +-
>   arch/arm64/kernel/hibernate.c                 |   5 +
>   arch/arm64/kernel/module.c                    |  11 +
>   arch/arm64/kernel/patching.c                  |  96 ++
>   arch/arm64/kernel/sleep.S                     |   8 +
>   arch/arm64/kernel/smp.c                       |   8 +
>   arch/arm64/kernel/vmlinux.lds.S               |  22 +
>   arch/arm64/mm/init.c                          |  49 ++
>   arch/arm64/mm/kasan_init.c                    |   2 +
>   arch/arm64/mm/mmu.c                           |  42 +-
>   arch/arm64/mm/pageattr.c                      |  72 +-
>   arch/arm64/mm/ptdump.c                        |  24 +-
>   arch/arm64/net/bpf_jit_comp.c                 |   4 +-
>   include/asm-generic/pgalloc.h                 |  90 ++
>   include/asm-generic/pgtable-nop4d.h           |   5 +
>   include/asm-generic/pgtable-nopmd.h           |   5 +
>   include/asm-generic/pgtable-nopud.h           |   5 +
>   include/asm-generic/set_memory.h              |  14 +
>   include/linux/mm.h                            |  92 +-
>   include/linux/mm_types.h                      |   3 +
>   include/linux/moduleloader.h                  |   4 +
>   include/linux/numa_kernel_replication.h       | 112 +++
>   include/linux/set_memory.h                    |  21 +
>   include/linux/vmalloc.h                       |  18 +
>   init/main.c                                   |  17 +
>   kernel/bpf/core.c                             |   4 +-
>   kernel/bpf/trampoline.c                       |   2 +-
>   kernel/module/main.c                          |  20 +
>   kernel/module/strict_rwx.c                    |  12 +-
>   mm/Kconfig                                    |  10 +
>   mm/Makefile                                   |   2 +
>   mm/execmem.c                                  |  39 +-
>   mm/memory.c                                   | 129 +++
>   mm/mm_init.c                                  |   3 +
>   mm/numa_kernel_replication.c                  | 821 ++++++++++++++++++
>   mm/vmalloc.c                                  | 454 ++++++++--
>   41 files changed, 2246 insertions(+), 99 deletions(-)
>   create mode 100644 arch/arm64/include/asm/numa_replication.h
>   create mode 100644 include/linux/numa_kernel_replication.h
>   create mode 100644 mm/numa_kernel_replication.c
>
> --
> 2.34.1
>
>


