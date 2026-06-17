Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0D925CD98E2
	for <linux-mm@archiver.kernel.org>; Wed, 17 Jun 2026 16:49:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7DEA26B0005; Wed, 17 Jun 2026 12:49:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7B6ED6B0088; Wed, 17 Jun 2026 12:49:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 67EB96B008C; Wed, 17 Jun 2026 12:49:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2F5406B0005
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 12:49:00 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 8A5C31C4882
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 16:48:59 +0000 (UTC)
X-FDA: 84889989198.20.4D3708E
Received: from BL2PR02CU003.outbound.protection.outlook.com (mail-eastusazon11011011.outbound.protection.outlook.com [52.101.52.11])
	by imf28.hostedemail.com (Postfix) with ESMTP id 876F2C0009
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 16:48:56 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=0ZQGqtkx;
	spf=pass (imf28.hostedemail.com: domain of Pankaj.Gupta@amd.com designates 52.101.52.11 as permitted sender) smtp.mailfrom=Pankaj.Gupta@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781714936;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=juaSScdyi1/2BynBZ5mBhqdigVslTcGOxNDLdtwT25Y=;
	b=BCjqNjhfZmz2jD43v1eEfbF/XgBhnNuCpWBRUqYpoyZvwHfB/2/NJGpnhRNpGJII42ROKn
	dLq8aCVzUVG23ZVDSFQsR2xTYfvyUaxMIicnzRsqa3bCz9jMk71Sc523Ot2K06F9KK39yB
	sFkj9uNEekqBJwrCl1n125Thi0v9Doc=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1781714936;
	b=6w/Tt8zW3FDmRXP8dPANOIxwQymLH7WblTdLfR287Yy6xsWxXlH4lWyWK7b00zxilwzysU
	eZOBdASj9Gesb5kYaLq39ND0KyXOZOKZiGDxacmU80zKDJ5tVpi25li6TvEOpXMTgVwzZy
	GjsYrDDA8YN0JcU3T7iKgEAOqQzG1DA=
ARC-Authentication-Results: i=2;
	imf28.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=0ZQGqtkx;
	spf=pass (imf28.hostedemail.com: domain of Pankaj.Gupta@amd.com designates 52.101.52.11 as permitted sender) smtp.mailfrom=Pankaj.Gupta@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=fY/EuFKTcCCRk0SSvwEgGf4pa9ejk+FfAsSs8kd+JLSlNZL6x01c2KP2Jw4GA8C1Bhi3Com5LeD12neP7oayZzERH2t6RELe/Wincthcmo4Y/eanAZzCmNcpF26b0uhZ7qlq++Gm4P6Df8xrz1rYxUg8yTyJ5P1bppSNN1Lks5hZ0mARC+FxaSn+tpOR3JtphE5xAKJ7rAeuxXlHR+ZUsEwzVwHJwWH4+USXJGeZy97h6aOQHzLh32lYlLWMT9HfTyQ/F6MYdiD1Gj9EBlegSyMv9iiufJSuKiSHaZ6FV0prr/Zp06aHGNAmBCERU8xmfynFPF+r2orP74SG1eulkw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=juaSScdyi1/2BynBZ5mBhqdigVslTcGOxNDLdtwT25Y=;
 b=dUVMritJfbKd6MXvgc/o9asYDwUQBa2V2Aw9NW9PwAFgPT1yqBvx7adl5E5XniBHIJMoZ94y8uvos46AKUHGE51uAkRmRYiO8CREQq/t6t0OuaH/mX5pHdbVIyZyvd23i1vWc63mMcBhsdK133LAI1slsxJXwtLtzgJylsGpd/qTVSi8w71kosPFB0F53NGfyAnz6C4S0s8ZpSXC1qe0d19Mhi0NJMSqN83xIBROxWWlicvdL3lQJ1y6s1VJtjaWECVxpVOfwI30ou++S8AxwLp4ikl5EXHZzY1Na3VnmtWJpFiU50zMvQsqYTiBzKFXmzEEg70eC8HC5tZ+HQvnRw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=juaSScdyi1/2BynBZ5mBhqdigVslTcGOxNDLdtwT25Y=;
 b=0ZQGqtkxQwVurMAnq20paFUu9rZLXm8TCPhbyRcC5v74Dqc0RjuqiI1oc4k6q89GK6l6Db68/3N/Llfsj782Rt8pYxIBUgAgUmh0zhI3xk+jLC1/7tuS+KxoRHZxAUqi1o4JvwC+XJX6OvLK5ZCEUMCJ0oJqYiXQf7C5YXtXXcI=
Received: from PH8PR12MB7445.namprd12.prod.outlook.com (2603:10b6:510:217::22)
 by MW4PR12MB7014.namprd12.prod.outlook.com (2603:10b6:303:218::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.139.11; Wed, 17 Jun
 2026 16:48:52 +0000
Received: from PH8PR12MB7445.namprd12.prod.outlook.com
 ([fe80::1932:ff86:1006:b2e6]) by PH8PR12MB7445.namprd12.prod.outlook.com
 ([fe80::1932:ff86:1006:b2e6%5]) with mapi id 15.21.0139.009; Wed, 17 Jun 2026
 16:48:52 +0000
Message-ID: <a1c1d1ad-7b8b-4201-9dcd-524c34142873@amd.com>
Date: Wed, 17 Jun 2026 18:48:43 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 20/22] mm/page_alloc: implement
 __GFP_UNMAPPED|__GFP_ZERO allocations
To: Brendan Jackman <brendan.jackman@linux.dev>,
 Brendan Jackman <jackmanb@google.com>, Borislav Petkov <bp@alien8.de>,
 Dave Hansen <dave.hansen@linux.intel.com>,
 Peter Zijlstra <peterz@infradead.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Vlastimil Babka <vbabka@kernel.org>,
 Wei Xu <weixugc@google.com>, Johannes Weiner <hannes@cmpxchg.org>,
 Zi Yan <ziy@nvidia.com>, Lorenzo Stoakes <ljs@kernel.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, x86@kernel.org,
 rppt@kernel.org, Sumit Garg <sumit.garg@oss.qualcomm.com>,
 derkling@google.com, reijiw@google.com, Will Deacon <will@kernel.org>,
 rientjes@google.com, "Kalyazin, Nikita" <kalyazin@amazon.co.uk>,
 patrick.roy@linux.dev, "Itazuri, Takahiro" <itazur@amazon.co.uk>,
 Andy Lutomirski <luto@kernel.org>, David Kaplan <david.kaplan@amd.com>,
 Thomas Gleixner <tglx@kernel.org>, Yosry Ahmed <yosry@kernel.org>
References: <20260320-page_alloc-unmapped-v2-0-28bf1bd54f41@google.com>
 <20260320-page_alloc-unmapped-v2-20-28bf1bd54f41@google.com>
 <fe191e75-29b3-49c1-8c54-55d41b3e786d@amd.com>
 <DJBG44TUTGYT.YIR4GG0EZ7CS@linux.dev>
Content-Language: en-US
From: "Gupta, Pankaj" <pankaj.gupta@amd.com>
In-Reply-To: <DJBG44TUTGYT.YIR4GG0EZ7CS@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: FR4P281CA0344.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:ea::7) To PH8PR12MB7445.namprd12.prod.outlook.com
 (2603:10b6:510:217::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR12MB7445:EE_|MW4PR12MB7014:EE_
X-MS-Office365-Filtering-Correlation-Id: 568f888a-6f55-4c4f-85ff-08decc904fb9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|7416014|376014|1800799024|366016|56012099006|5023799004|11063799006|18002099003|22082099003|4143699003|921020;
X-Microsoft-Antispam-Message-Info:
	8rgTtT6XMJtpV7rxnAxEQl0KJl8G5Rlq3kYne5GC6prGjAbLp7sx7D5pF7z7Bf1spK96IPy4nmMTcVHNnGFx1Aob8AEDlr963OR6kuRf1QB3qffivNHTyJ2CLGcs6CsHLsoAIk0gKxdltA0LsIv23RzM17oRL73mgWIqSqGvHnoZbCtljN8eAC2qJWK7VizQZqwI4Sym0TfvWYSpcVKpDeChA8lEK8yMRw8VPWksbra2JSr16QrrIn8lzxBloUHXzCXhDIE17i78V3a2fBZUhbxQqwdO7WcHADtuNQaMn9pLQIrf0vvW3zQbb9XwxFyk9izzbLDwepY9rD/c1zlbF0a+USoTvl81DMKvx1NCFuMDBdGBuRMI1zY7dTn96r5mXGiyI1oTHWR6x8DW7dosr11HXmSl68DnqBMMfOKDMAK/7GDScPgxApAr8FAHAm8bEB0QKNxtK/D6JC+TCcjcWQ+dFtfSV8Z941LTTR5KpoaX0oDkmSMM/ZAbnl0J3OGDxCoRt4QcshtyzNDxkIlwFf1ffq4rsr6IM/Ojrtk24GpcChHktBYcYpgIxYkZA1r1oe73TNPbsP7cZfFDvgLGIHeD0i/xXwZ2FD4y1w5TBIFOkSsijvAtM+c9o6KSpXvm+j+hU8aSlgzmV/YOlSueCqR7+BoKKnGN2f0mNKbSlc6yVh5Df49DiGVkiMKTB3u0yfxBWNiZsWXDUXl+SrJR3zwtR6DGFsdJnnXhD6/Up1o=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR12MB7445.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(7416014)(376014)(1800799024)(366016)(56012099006)(5023799004)(11063799006)(18002099003)(22082099003)(4143699003)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?VHNBSHJsNGU0YUdHR1cwWVhpbnF6eTNOMXpHWVFTRi8raTFuUWM4aTgrZTdV?=
 =?utf-8?B?L1hWQjB4S29NNEVaZ1JLY2RGVlI2c0dVKy9zVnNVVnpBa0ZOMDBPQ2hNU1dH?=
 =?utf-8?B?Lzd1Si93V3JMcjk5cmhmRGNKSHNDaTAxdWxzUWVpSFVPTjhCVGJrZ0VBRGlj?=
 =?utf-8?B?alNuZHp6bnFQSmIxNklWOXkyOTZ5bjUybkZmTktvMWVEWmRXWHVLaGtlU3Ew?=
 =?utf-8?B?Skl5SlZOWnFSdm1FMFBwck9yT2p5K3l5N3d3NWR0QllpVEdCem41SkpUSDlz?=
 =?utf-8?B?dE8yOGdVZE1TQk92SGRLT0dKNkxVSUxwOFhVT3lFQldXMXFINHcxSDVuUllK?=
 =?utf-8?B?cVFaYjZrbXNvNjRyd3QxR0dsOFBCNTA1dVZQMjNFOXljWUoxeVNxTTdqQXJX?=
 =?utf-8?B?K1FYS0E2L0xPVlpRZnNDMTYvaW1iY2JsRzlGU1NhQzVXbUlNWTBCSUg4aGlD?=
 =?utf-8?B?eGJaaVBDN2wzelc5S09WRmlDaW55OG9nVll6Wmk5WWMyMVEyUGxFQk94Zk5w?=
 =?utf-8?B?NmhjQXZnbXJDQ3dJbnJjVWxQVEsrN0xIeEQwRjhLQzVuOGwxdHI1OXFEQkw5?=
 =?utf-8?B?N1YrSUJWcWdUaWdUYWQzU2hScDgxWk1kV00wYTZCNkhyTmkyVklIc2pxUjZO?=
 =?utf-8?B?RHh1bnZ6UG1DUHJjaDNpd0YvZVZSWUNvVnFlT0twRDN4ZE5aSndXbW5GcTRP?=
 =?utf-8?B?Tnh3QmtFY2cxNUJ2MkFLR0ViOW44TndTNk9CZmY5VVZrT1ljaFR4YnFiOFUy?=
 =?utf-8?B?OE9jeWRyaDUzMDh0ZTRBeTB6U3VMTWR3QTErb0lZcVp5VjNZamkyZDQyb1gz?=
 =?utf-8?B?NVhlZXYyMFZoSkMwbEhRaTBEd1hBWlJVWTBib1huQkdnNGlKUy9uL0tVdDRE?=
 =?utf-8?B?MFFWOTZVRFdxV1UzeW9OR0pWTWNjYnBMSEx5ZjgxYjVucmVFaXlVWFpmM0Vu?=
 =?utf-8?B?VHE1OW9XQVJWUnp3YzlGTnF5MmJSZlp2Y3Vjb0swNUdiREpBK1VUazIzZVFV?=
 =?utf-8?B?REZyV1NqcnVIaHRZN2JraGxja3MyVlR1dVdnQ0E4ZFJXMnh4U1E1MHoxNEdO?=
 =?utf-8?B?TUJ6dUpkY1hxbTRsKzZwZExFRmdiRm92eXhUYzNDY3o5U1hFaGZnL29RMFVG?=
 =?utf-8?B?Z1pRalN2K3FEejRJbEJydFU0QVlTQmJYS2hDeXdzQXVNWnR0TjdnWHJnRm95?=
 =?utf-8?B?THpEcVgrUXAvQzg1RmZSTWVxaVF4Y25LYmwreVZsZUk3SzZ0b1I4MjlWdmYr?=
 =?utf-8?B?UjVtN3A5Sm1CaUVoeGVDNWt5N09QdHN4N1JwNXM1K1k3WHl4eTA0WjdMd1Nz?=
 =?utf-8?B?WUZkV1FOeElSMU5xUjBscXZnRUllc3JqeUJqUGFQclhyZTF0cVFGZmlOblIw?=
 =?utf-8?B?L2tYeS9QOU5lSDZvZDlMUlhFZ2lJN3BXTjdqSDExcnZYRXNhUmZXaDlQWHM1?=
 =?utf-8?B?YkgxMDlKb3hBVGdmak9uYmo0Y2wzZERpdFN3WVpPZlFVem9YTkdjdUw0TG1q?=
 =?utf-8?B?N1lsQU1zNGMxUVhZUVZqdFRIK3BWWmxlU002UU85bVhJbVFDb213WTlOZnRw?=
 =?utf-8?B?ZG9lOE5rL1Rvd1hHYWtVdE41dUJ4ZURiRklzNmFuRitVWHp5RUUzNUgrUlo5?=
 =?utf-8?B?V09VMTZjWkt5MUc5N1ZTMzQva2JuK1FORlVSYXBYUzVRVlF6TSt4YUszQlJW?=
 =?utf-8?B?N1VON1JzUnltNUdRMURqNVVtWm5ZbXpsY1Z5Wm8rWDFobGpFNS9UMjYyTEFl?=
 =?utf-8?B?dzJtM05rOHdrWnZYTU1rSkk5STNodGpyN0FhNXg2UFhjL1U2VmwzSHZuWU1t?=
 =?utf-8?B?ZjMrOCtZdWhncWZFWExIaXNBSUVUNU1ObVpuK1JLM0hkTzltUmFDNDlsWGxL?=
 =?utf-8?B?VjFxNzhqbFZPcDJVS3YxUTB5emp4VHEyUmNhdk1GSnhuandBQ0FjUTJlSlBu?=
 =?utf-8?B?cjRGMUpDYkNBWTd2Q3RrcFhJUWhUWGNIOHluTjBKMnJXRnVWSXdSazlEdmFx?=
 =?utf-8?B?ekpRb1h0bGNsVWZVYWFSNHdwUTJieDNsamRNSTIwbTZRSzE3WVRTcmlvVGNz?=
 =?utf-8?B?TmVveExKY1lYRHVubjcyV2tMNUxVWU1IRVdKdS9xZzVpa2ZFMWVRWmprcEZx?=
 =?utf-8?B?QzBrQWN1NXZrUTErbHIzOVB5eWlyTHIwK0o3MlBiMTQraUtPWlFwdHBMQi9X?=
 =?utf-8?B?a2pjNmNNNk0wWWI5NkszQy80MUw4UGpaRlhFQzkwNVBvVWJFTzNyeXlzRy80?=
 =?utf-8?B?T2J1cnZUZy9VVzI1d1h1aTBMSDNXREVZUGEvU25WcmMzb2xUaWMzZjJPNDdH?=
 =?utf-8?Q?sRpekx3+ltjkz1qQoE?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 568f888a-6f55-4c4f-85ff-08decc904fb9
X-MS-Exchange-CrossTenant-AuthSource: PH8PR12MB7445.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Jun 2026 16:48:51.9724
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Lr4/XS4A2js0azQDhfLbZeEbPq29+OUelnwObHuW4Erm4fbdy6Dc//u1W5T/DRvONuVoqZPvPzFKabb4eWDyBw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB7014
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 876F2C0009
X-Stat-Signature: dj51kcd9wetx7tk9xyycf6gaw98mb475
X-HE-Tag: 1781714936-285515
X-HE-Meta: U2FsdGVkX1/qmkU2lQ/LBp0qrZhq7Zr0rchkZhzLAMNGTfORE5lB2KboIcqgdXE1kTVRYQn8Hc0eyYgXnx5V3tkGuT232/NrBnNNmNkQuLMLDrXGKqLnXmHdDVecDWAfszmaHvmteN6486Y7tnyuaxtvnkyw/1A7YEByEiQBfqA13MnwM+aLvCEIOmg4eX0xNpTbKLdl7+yLJeKJU+Z0JdjUJhP0Agt557BoPNGX3z+DKE3Eq9jQEA4dAK5tuZlNwP55o9sNWDTwIHvbDWFALkdG42EggXjN65jpp1DqyaVmHXk5AFeU9eeqO0Z4d4M6ix1wpDMrshRE3TvjzAWj11IDHdsm6fWBVAhxsu0jrh3jLpSsBqAFtl3fS45NHUh8wiiu869m8JrQ01d0RTc7ybZ/Py348fLQVUl12ZHaPK/kI3E6cinh226oZg//uVn9I9BCVd55mbWMxhpSOhGYX2rfoc9h0yO5u8Z5Apn5ZvicEVpfc3RMqq/Fk90PGhQ/aAk4KvmkhPQvkeEkt7jERwT5vRcITCMDXaJqkybNU8aKmquMzYZk2s23uQu6t20SpmWCT/DgydSi214Q/ETRN2HFSVEtRxV2RYtkHS6bskN9ys5jSF5e3pOnuA//SWAnB8TFE5NsEE1v73+UOAgi+AYhwqdeYNNAv2G6J9Dx3jK0i++mUfkVAn+VfmBUIZgfzl30PGs2+po6vqYt+4e5goAsuUuWG+mCgIhSI6vr+DHdyc+t8bN/Imy5NGkeq8HoG913tUopjbPoe+tdaSMl5vIqjDV6Yd/Jsr6Kc+25nz3g5kMA1XOsuzNvZ8eTUaDCN2Iv4QRrcOKV675DG+iyk5bnduQKda0ilpgAmz8Tbn1e/+FrxY+Oeyf5Apr75AxrhlL7Q+hpVwWAAkF6hJQm/PUxV78CuiD15H9Fw938BSpifEKU61VQR9K++kxbbhzO8wZERLt/cBAw5YyrRrf
 ECDa7MEb
 +Qu4jvkAHT1QX0d3Z2zl2mMUd9neT5IrrdQ9mcbNZFa432XteL9D8N01vbHUSXNJ430iYwXJ2/LpHHMiQfZa7ttCpIryDn7POzz1+zxrplOeKRtD2tFMdq3evLinFQ7ea1lkYDpIb7QnRbc8y8PzbvwlPpak9QOGVJE14vAeLHMQJ1/USwkVUSnRsAOvDP+/MTU40oL0krHWXAZVF9BxxoncWv8V1LXhy2G0nC6xEF/6r36I3U2dPSlkcYWj/65bJD4VBK3H+ns/SgQwNV9Dtee98CLF6iJ1or79WvedxTeKjlHem2zyW6S9cacum7PvntiBT9JDdRBmJ3Xbk90H88dijHorz2enArLwfxb/ZgsWJx4uGojXjI2a+XeO1/f80MHF83nWEKCutPJdmFAoKjChZ+751OppRWnxdqWCtQR0A+rOuPz0YlWvWvS/gJBzhBMn/3vLZWr2c48LbxF8liWms3x3YCbySbIEV
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Brendan,

> Hi Pankaj,
>
> Thanks for taking a look!
>
> On Wed Jun 17, 2026 at 11:32 AM UTC, Pankaj Gupta wrote:
> ...
>>> +static inline void clear_page_mermap(struct page *page, unsigned int numpages)
>>> +{
>>> +	void *mermap;
>>> +
>>> +	BUILD_BUG_ON(IS_ENABLED(CONFIG_HIGHMEM));
>>> +
>> I was thinking — would the fast path read better if we moved
>> migrate_disable()/migrate_enable() up a level, into clear_page_mermap()
>> itself? i.e
>>
>> migrate_disable() -> here
>>
>>> +	/* Fast path: single mapping (may fail under preemption). */
>>> +	mermap = mermap_get(page, numpages << PAGE_SHIFT, PAGE_KERNEL_NOGLOBAL);
>>> +	if (mermap) {
>>> +		void *buf = kasan_reset_tag(mermap_addr(mermap));
>>> +
>>> +		for (int i = 0; i < numpages; i++)
>>> +			clear_page(buf + (i << PAGE_SHIFT));
>>> +		mermap_put(mermap);
>> migrate_enable() -> here
>>
>> Right now we split the migrate_disable/enable() a layer below across
>> mermap_get() and mermap_put().
>>
>> Would it make sense to embed that in the clear_page_mermap() API itself
>> — mirroring how we already disable IRQs at this level for the
>> mermap_get_reserved()?
>>
> Hm, I guess the symmetry would make sense. The reason it's this way is
> because the mermap_{get,put}() API mirrors kmap_[un]local_page() etc
> which do the migrate_disable() internally while there is no precedence
> (AFAIK) for an API that automatically {dis,en}ables IRQs. That might
> also be a side-effect of the fact that local_irq_save() requires a local
> variable while migrate_disble() stores its state globally. Similarly,
> there is no equivalent of lockdep_assert_preemption_disabled().

Makes sense. There is cant_migrate() though, maybe in current code we 
could use in mermap_put()?

>>> +		return;
>>> +	}
>>> +
>>> +	/* Slow path, map each page individually (always succeeds). */
>>> +	for (int i = 0; i < numpages; i++) {
>>> +		unsigned long flags;
>>> +
>>> +		local_irq_save(flags);
>>> +		mermap = mermap_get_reserved(page + i, PAGE_KERNEL_NOGLOBAL);
>>> +		clear_page(kasan_reset_tag(mermap_addr(mermap)));
>>> +		mermap_put(mermap);
>>> +		local_irq_restore(flags);
> BTW, writing the above just made me realise: we don't need to disable
> IRQs here, only preemption.
>
> In a WIP version I did have mermap_get_reserved() requiring irqsave, so
> that you could theoretically use it from an IRQ. But actually I don't
> think that makes any sense since it depends on state in current->mm.

Agree.

Thanks,

Pankaj

>
>

