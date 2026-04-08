Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 789951073CAE
	for <linux-mm@archiver.kernel.org>; Wed,  8 Apr 2026 13:05:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 806836B0088; Wed,  8 Apr 2026 09:05:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7DE226B008C; Wed,  8 Apr 2026 09:05:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6CD116B0092; Wed,  8 Apr 2026 09:05:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 5D50F6B0088
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 09:05:09 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id EC815C0210
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 13:05:08 +0000 (UTC)
X-FDA: 84635409096.04.CF9F4E4
Received: from SA9PR02CU001.outbound.protection.outlook.com (mail-southcentralusazon11013022.outbound.protection.outlook.com [40.93.196.22])
	by imf11.hostedemail.com (Postfix) with ESMTP id 76BB640013
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 13:05:05 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=dpqQbrZY;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf11.hostedemail.com: domain of jonathanh@nvidia.com designates 40.93.196.22 as permitted sender) smtp.mailfrom=jonathanh@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775653505;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8ShGTk7jPFHUcUkfZ1NwAbbIGcepiNFUy8h8ZRik3lc=;
	b=IJCSVUgEGPlX2HBB+GIT7FrRD/l1o0XY8of1A4l2N6+uDOwazIHm/z7XqjBs09TVIEg7RM
	h3/+ekUujAakpn5rYXWjh2fOZwkmr8lLY79h0bEt2LZMpg2hpuUSzd4bH94ZZEAE7BQa45
	koDhH7a06KpOYIIG7bOxi1lb0ryjO/A=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1775653505; a=rsa-sha256;
	cv=pass;
	b=XOiB7IHFz/2rTiujDI8ROqafI8Ol84gOh6Qd45GJSiRsXWPLbJPvAZehx4QY1aY4/qNWXc
	+7+v4WYlJoQyYE2BX8/P3q90sAErVWsbxuLOjVABD3ke+OltV+xcFhUUBupsL7ZzcH+yL6
	vFZOEBh538xibSBmxY5DWHNwRAh3JSs=
ARC-Authentication-Results: i=2;
	imf11.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=dpqQbrZY;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf11.hostedemail.com: domain of jonathanh@nvidia.com designates 40.93.196.22 as permitted sender) smtp.mailfrom=jonathanh@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ngjXcDK4/lR7/zLfXNn5QdYsFNeLRuCHOQAWpPAZvTJSeDD1s00gzHTjwPYoyDbtIkpupx3SR0/UvOHr3ompKG7tKdd6mZrDEUb8iG39rnnHjTIK3X4qRO+TBEtFdJTmK2h6BVqcnrFK9+CVv+irmeiyGuVb+LaHKvOJ3cZkTA9B/R7KmT4IAfLwlwb2MnuDukrf1oIntdj0odInBIEtFK2+wkc+EHLuNph5Og0JV9YxzMrS0sMH0hbOpRqLaWdlHnuk3d3SiucS3ddSBMeJcix31dz4WQ2ZjYLzV9M7RUIsl3QzgCBcfC9yq0KBpn9juxjymkKdwxc1F4LLd4eaEA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8ShGTk7jPFHUcUkfZ1NwAbbIGcepiNFUy8h8ZRik3lc=;
 b=T8M0QsO9qJucJfBCbuFxgWo6rwg70lyxDJhKxLYjW/l39NgIcmD5K6FpjmqCUq5UXUzPc3Y6lMBHBQi4nxVVkSDNlta6zUJj80fzKmj7szXft6F6twAa0GJ5EouYx7SOom3tKWJIvz/FQK9r+M295a39NLAq/KpRRMXnTfSHkSdG0ts/pPCj+K6iRc19VdHYCGr1STh6xd1IipWuA0QvBFc9Q7G8C9CMsthhcHI267qPr6AtiugWJUnquXnV0/zAj6wtLvLMaaX80Pa128iKdPKi0h78vnrM9iDH3OzOvtdjE2yaoNp1YhmJhD6kis5nPs5m6632MbB1ow5k3Nt7rg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8ShGTk7jPFHUcUkfZ1NwAbbIGcepiNFUy8h8ZRik3lc=;
 b=dpqQbrZYiYYaA+boRfDzblxJmopU9FM0jYKgofbUue1XZgr5J0rqSGyfCkZG0sIg3A/FtNzwNWG70zDD660Dsw6gXOlzdGZQud7cJTeq9+Fr3AFuRTbxU7+tyj20PH+Z46q7ifed+vE8H1JXWGJCl45M4CML/+sEVxEvGHxpiks5cndrsottTcP3lO8N6iZIV3rb+PTvQ/WqZeRhHbxDzaJCI7G3fL5UegChmKWMivJ6hNTYuXXpDv6k2g1XjYXLT/JnIlxMHq48TBxkUvuQVMiqsffGcXH3feA6wpF/sm22ryCTTe3w1ehe+jb6S6RRx8V82kgnRsUwbnkyBvPUmg==
Received: from DS2PR12MB9750.namprd12.prod.outlook.com (2603:10b6:8:2b0::12)
 by PH7PR12MB8778.namprd12.prod.outlook.com (2603:10b6:510:26b::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9769.15; Wed, 8 Apr
 2026 13:04:59 +0000
Received: from DS2PR12MB9750.namprd12.prod.outlook.com
 ([fe80::56a8:d6bf:e24c:b391]) by DS2PR12MB9750.namprd12.prod.outlook.com
 ([fe80::56a8:d6bf:e24c:b391%6]) with mapi id 15.20.9769.016; Wed, 8 Apr 2026
 13:04:59 +0000
Message-ID: <e7e4ea66-49cc-4996-a638-25f6cb08a42d@nvidia.com>
Date: Wed, 8 Apr 2026 14:04:54 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/3] slab: support memoryless nodes with sheaves
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>,
 Ming Lei <ming.lei@redhat.com>
Cc: Harry Yoo <harry.yoo@oracle.com>, Hao Li <hao.li@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>, Christoph Lameter
 <cl@gentwo.org>, David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org,
 "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
References: <20260311-b4-slab-memoryless-barns-v1-0-70ab850be4ce@kernel.org>
 <abE6uqdzMUv8k0mU@fedora> <8ab58ecb-1fc1-42a1-b67a-c3107de2ece4@kernel.org>
From: Jon Hunter <jonathanh@nvidia.com>
Content-Language: en-US
In-Reply-To: <8ab58ecb-1fc1-42a1-b67a-c3107de2ece4@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P265CA0097.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:2bc::16) To DS2PR12MB9750.namprd12.prod.outlook.com
 (2603:10b6:8:2b0::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS2PR12MB9750:EE_|PH7PR12MB8778:EE_
X-MS-Office365-Filtering-Correlation-Id: e048d609-b813-425a-5e85-08de956f7075
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|376014|7416014|10070799003|22082099003|56012099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	B+GYXTwZZ4N5Ak8iXspirEhd9BgStzI2IUWrvsk/KWP5uylJZYkGz0aM/YLqzLdstZge/879fTCgkkTJgHZfDuZOfluI1XLFmlYrklrETe/Yb+1lWOlSrZC0WwtASbow07FJxpSGlGFJmrrlrMSeqmWUIG9sgBnnb5NDhbkpEXCQB2u4jXw9a2GBmgBc/92lz9BtcgLfpZoTkGJ1tsZCn7oCtGYi7z7HIX+Wm5Ov9tuNo+w5KRNofy/jTzZ3FAHiTdbiftn+nVCm4Aw0B3gKHyB2q6SL/uulGU0i5a5ODgBTyXa/C29mU6v4uSmv+GjvLstg5vJPgBeWOjbi5/SXneexDnRfZCEw5fh86J2WiHaO6YYW4oyWUNXdFfKNOkZbZK3g3/kA8WS0FuTADaHU/zv6chKgmkGUs4r6RHO6KchoKHpZdryjDTwSkI0xcEKbkj48q8Ah+YRWL3Tz8jShkuSn+sPvTV5/ySDuD2m6bU6J31bej0/oHpCHHGp6DsuFY8amilS3ZY4pkOmpFLjs4VtYlQDdG179qYxGi8L+V7M3q9305dX2MXIeQI3UyN3sHCBOwTlNXCufLR7l2TJ+0ikyFro0JKXBgnXAenFYeAwk8eEwK9qCW2B9oSwM1quCJGn3Mta1nXkB3ARQrUnPhuhN975vGCacr3mnetUgyCNBMqB9LHNuVH6Eq1KyuLQGsjj9CeTSdvqJcyYXGrZ84zMasAJFgcu/yJn1qVb7K/cdjreSSdxMYktK/r95X4ar
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS2PR12MB9750.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014)(10070799003)(22082099003)(56012099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?NTU4dEpVbGFjdUFwaTN6Qk1ZaGFLSXVOemxjMk4rWEFTU0lOV2hoRlNjUDR0?=
 =?utf-8?B?WFdSaElwOEVTaU9FL0kyU0lYRGhqUkdMeWMzOXVJMW9LaS9YYk5wR2VOdTVT?=
 =?utf-8?B?Vk9XSlJEUzlVQ3RlbEFnOTY0Sm1nc3ZHTUxXalJsZ3BLeHFKQUZUTE5seVFD?=
 =?utf-8?B?YVBEWTBqTHZ2QU9zMmlBWVNZZVlEN0V6TnlQcjlsaHhkV09aZ1FLblYyUzd2?=
 =?utf-8?B?SHNaMXBCeXNlNG56b2wxdU04bm9lZ1h1Y3BGM01LQThSNHBHeko2MnFLa29H?=
 =?utf-8?B?NjBUbHV2UmxZdE5HMks1VXVHWElvZC9ab052aE1hejJPbHNsU2pFdzRVWlNI?=
 =?utf-8?B?UnQ0VkEzdnlGZ0k4RWRQRjBUekQ0MjA3K1VUcmNQbTZESXEvR1FPMkZNeFRq?=
 =?utf-8?B?ZXRGeUlFOGEvYkNmN3NjRUgrZXAwbVJzL1NXbENHL2x1Qkorb3RsUkJIWnlZ?=
 =?utf-8?B?Q3MzNy9VaVIxUHlJQktxeUZKZTI4RTFhNjhFVTgzbXlsN2JyWnZOUnV2Wnpn?=
 =?utf-8?B?VHNEUjdVMzd1dnBzcTErZjBnNTE0M1ZHbUc3Wjh6NGxsaTJaN1R3V0VPSGRv?=
 =?utf-8?B?RGZPOGNUQm90akhaUGFXY2hoLzMyeFY3OXpIWk5wRWQ3Vy9jYTdxemNBdnBv?=
 =?utf-8?B?eVNOZWxzUHd6cFFwa2hTMWkrdG14WG0zU3JiVUxRY2VEQ2wzdTh4TUxGV2NU?=
 =?utf-8?B?WjErWWc1MVFzbG0xNy80WWJ0cWd0TWlSQ2IxcTVDY3RqRlMvT0RCRzg0T0lN?=
 =?utf-8?B?R0k3d3Jvb3UyeEx3Zm9FUEJxOHFlOGE1UWVDeHo5Y2FZQUlmN2FNMDVnTWFZ?=
 =?utf-8?B?bnZmTWR3QTBNSnZYZkZCYVJXU3BPaHI1VStCV0doV0xDMEFTSVdtNk0xREJR?=
 =?utf-8?B?WmFERkFjOXFVcUkvS3dndjlvekRBK3g2bDJ4N1FOME83SWhTdlRvTnlmQllk?=
 =?utf-8?B?ZE9EK1ZZWWYzbXUyQXhTekVWbTBYc3QwSSs2b1AvaHM2cGdpZE8xa3R4SXdx?=
 =?utf-8?B?MDZ3NzFOaEY4Slg4R01YYzJkRWRzTU1nRnRweVc0Q1dMR0NkdmE2QTY1Ullh?=
 =?utf-8?B?MUN4RTdLVVFBSGcrYjBQY1crdGlHd2tzMUREeEJoVWRMczFQWm5lQjFRY2kr?=
 =?utf-8?B?Zk03V2c4Y3pqeVBaV1d5eEFRRVA2dzhXZEU5WTJzSnRPRmVLUm9iSXdXbUlQ?=
 =?utf-8?B?ci96QTVTSGhnTzFrZTUrSFdrOUVJMkczdnluSmdOdnFha0FrNERVQXptZWJZ?=
 =?utf-8?B?S0h2RDk1U3RycWtaVGxTazNMMGFKaW9HSnFMYS8zWWZoZ2tSSmYyR2lnRXda?=
 =?utf-8?B?MTkyTm5Ybkl6Q1JUa3h1dEJzSTk3TFJUb0w1TStsL1JHcDdlbkJnSzNzelJP?=
 =?utf-8?B?ZXVQYXNOa1BlaGwvOTM0RWUwa3FkdCt5Z09iUHpYZnJtajFuYkpNNkN6eEpK?=
 =?utf-8?B?V0lWODNPNkdwMEZ2MjZtUmd2RlZDZzNXNXh4YXNwdVVhTVZsdmVlVWRxQkJ6?=
 =?utf-8?B?SWxiMjRhVlBtUXo5NUZaY2o2VHVBaTFKd2tBL1hTUERwVUUrM1VBTit0S3ZC?=
 =?utf-8?B?WjNnSjIzd2lQbHNWalUrblVMQys0Q1FjUkVSbUoyOEViMWdLTERyeHVxS25D?=
 =?utf-8?B?cjRDamFlcCtSTndveU4zek5JM3doZzBYdFhmSGM5Y3czdEtNRG5pYVNnTENT?=
 =?utf-8?B?VGRuVi9JZG1yZHU1UlVCSE43a21qY2FCMWhqdTdPYndlTEpaR2dNbVlDbkE3?=
 =?utf-8?B?NEdRNG5uV09tSmdWbG5wY1FTbkUzb0puSFRVY2N5dWtrZy9wRG4wckk0MUdt?=
 =?utf-8?B?aHo2eFRIMkJVampwUXVFTVcrTzFVMkFOSnZ1RFVsVzBDRDdJZjBSRGorSkxu?=
 =?utf-8?B?SXIvbXJpZkFVaU5DdTYxOE56RDJsLzF4VksydnBOaktKMHF1d1BCV3dBd0Ey?=
 =?utf-8?B?d25HaE9JT1Jzc0E2Q2ZJSEdMWDlpd1Vtd0V5bzEzYjlVeHFYamFKT2RUdjBH?=
 =?utf-8?B?WUo5Q2FxOVArbldRcUlVcktNMDV0alFXcWdLd255aG4yTlJrZEROWWQ1OGtv?=
 =?utf-8?B?UnBCQ0RzcFZKWmk5Z1pnSXdyVkF4eG1YT2VjRmIyazFTK3N4QldxUTZYbHlW?=
 =?utf-8?B?UklnSzdrMm8xMk43WmtCVml0M0F0RDI4d2hEQjFUYjBNbnpDSnZPeXFwalJs?=
 =?utf-8?B?NDVaY0RYRHJJV1QwRUs2WFlYWENEdkttdVlRTzFpWU1TeXZHOU1MZERVN2Vs?=
 =?utf-8?B?aE1BMU5vRmhJNDJJQmcxSXpwMy9sWHVvNHo1WnpRQ0NGNEVuZndEclk5dmVm?=
 =?utf-8?B?eldHaklqWVpBOU5YTUZhY3dPd1NTemNxVjk5V3E4b3FWZ1hXaGxyQ3J1emtN?=
 =?utf-8?Q?pwRDk829BiWbOTKuwW4Tei7fANz/jyjFnC5NhF9ujVS7M?=
X-MS-Exchange-AntiSpam-MessageData-1: lUv9SJ9qEWn7sQ==
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e048d609-b813-425a-5e85-08de956f7075
X-MS-Exchange-CrossTenant-AuthSource: DS2PR12MB9750.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Apr 2026 13:04:59.5274
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: y6bxPD09TLbTfr8bW449X9SNcUtociJYQRijj/K1SXFmovY1Lv+eKxpnOWFZHLYy5jnfGwIbZQrszW1wf7R5KA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB8778
X-Rspamd-Server: rspam12
X-Stat-Signature: otmbi1kiwiht94gqrhoz3oy7u65spz75
X-Rspamd-Queue-Id: 76BB640013
X-Rspam-User: 
X-HE-Tag: 1775653505-404405
X-HE-Meta: U2FsdGVkX186lpuU3NcrZ+I+v/mMHkUoLrArBWiWIlX5Ybfp8pBeoE1P7s8qNR7Lf4TVD4xs7vHVCjOPcoH1q+62zkw7x4GQLAxp1wRbmV5AlXB80PzusV+xI+CzxLI1gQJ6wbmjk7mBuebbSmASynHbqyzrScRif3RReBLnTuywoEmQAUbD+YHd+AKSS8vCYYyn/W+Yn2CBQz0E2ouQgAhuiwsFQYCljhqnBClvaGhuhPbEF4QoMGB+/LrsYQIQ00zWZECkddSBjxlN+8Rz5mmtXGXz8aBDfnACMlxoyf0QvukmlbpLgQMQc2QyStVjBjAUJ1DUQdVM0k5ovixqB02FtHj0DRtb3FLwxvsltussj59+f9lPsfT4qYvRKqLNqVK7SHOfWr2TA1ap9zVhw8zqwZEWHWqujXmmVmUZHq8KMTkcUMftT6kKkqfElzR0SpS1xfQeblxrsBjS3AZGZyUG1N60Rz9K6IzBNrQW2yKHOaXcQS4c0D9giUWA7V9W2M7e/UY7i1QZCDht4s5vpOOq4WLsJMFeVBh7FiV0Sk2hF7Rr+qTAY27PZjX+rUSSeAZk87GE4KSmfmXbHtRaitASw/mjc6CpxwhPd6hkp9ep45YqvjxdTg0fc8lEE9MN/ReK+ZvhkGr002SZdNTgHo84jQEtLSmlCE1NF4Q66WUUMoPxbvj0E7PIsDOQiTBWsY60Ywvr9Igdg6gkvyLI/f91yuLV3EQXWC9QTUsFeFLfF+RmWEHnuKTBf/vjgaheflKoxzS/Uit3Z0qCnzl2i9ktJv9hKTGHjBpX4+zo/ESIg27M+VAczFoOCQUBwPPz5k9YBtWoz81VDo8TzE92lBF92YsjG9QyGxUyf0nzan74fYfRQXSvDOnk0k4icMbhDNyB6xS8sgQHu+Eyq6YTa0P1CCR2wTi+0rBzl9lOR4zCh3CoOU2uvthx5Anw1yBVpdWiK1+xcyEbXT23KH7
 hGis/zAm
 WW+sR1Ckv1bkmTs1Hlqq2Lxwkfa8N+SdNkMn5FHFlwSvZo36hYX+j2jvK4T8UgHp+hs7JKTB6P536kzKOASW0E+WTbzwK/GcxkVKZeKpVJ0X+DBNQvujcas9wRLNvwhpfeIhZrYHaFmWxDJJ3f5AmFNDHmm7mckUJqw4QeMgs4kpHXBRS8zZMO+xwiW5y/wAPAufFPjyQKXJQBMLMLyC2/fNqNwaIeuXyCRLc/+CDP6UVqUBVoyg3P1xzTstQLIdX3lMfl1hyV4uXb8XWzsWTCI6jAg3GZcMW9QsQZSfQARVgvYUUjjV3jrFIWuXeBOHCxvQXTl2a3nyO7RYBZZTLsn2e2FAf1dPJ9qWGnHqE64G2ywJjPpBmkhU/K4ZCuR8s8k0H9lUHAYOnc4LV+pL9rTXYoTAD91Wt1tZ4wD9Sqe+lldnyc+dRvFt1l++lqWBIqSrNEWvvxBYDinuGDsr1xgUOhwWPGNcYAj4+
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Vlastimil,

On 11/03/2026 17:22, Vlastimil Babka (SUSE) wrote:
> On 3/11/26 10:49, Ming Lei wrote:
>> On Wed, Mar 11, 2026 at 09:25:54AM +0100, Vlastimil Babka (SUSE) wrote:
>>> This is the draft patch from [1] turned into a proper series with
>>> incremental changes. It's based on v7.0-rc3. It's too intrusive for a
>>> 7.0 hotfix, so we'll only be able to fix/reduce the regression in 7.1. I
>>> hope it's acceptable given it's a non-standard configuration, 7.0 is not
>>> a LTS, and it's a perf regression, not functionality.
>>>
>>> Ming can you please retest this on top of v7.0-rc3, which already has
>>> fb1091febd66 ("mm/slab: allow sheaf refill if blocking is not
>>> allowed"). Separate data point for v7.0-rc3 could be also useful.
>>>
>>> [1] https://lore.kernel.org/all/c6a01f7e-c6eb-454b-9b9e-734526dd659d@kernel.org/
>>>
>>> Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
>>> ---
>>> Vlastimil Babka (SUSE) (3):
>>>        slab: decouple pointer to barn from kmem_cache_node
>>>        slab: create barns for online memoryless nodes
>>>        slab: free remote objects to sheaves on memoryless nodes
>>
>> Hi Vlastimil and Guys,
>>
>> I re-run the test case used in https://lore.kernel.org/all/aZ0SbIqaIkwoW2mB@fedora/
>>
>> - v6.19-rc5: 34M
>>
>> - 815c8e35511d Merge branch 'slab/for-7.0/sheaves' into slab/for-next: 13M
>>
>> - v7.0-rc3: 13M
> 
> Thanks, that's in line with your previous testing of "mm/slab: allow sheaf
> refill if blocking is not allowed" making no difference here. At least we
> just learned it helps other benchmarks :)
> 
>> - v7.0-rc3 + the three patches: 24M
> 
> OK. So now it might be really the total per-cpu caching capacity difference.


I have also observed a performance regresssion for Linux v7.0-rc for 
some graphics related tests we run. I bisected to ...

# first bad commit: [e47c897a29491ade20b27612fdd3107c39a07357] slab: add 
sheaves to most caches

I came across Ming's report and hence, found this series. I have also 
tested the 3 patches in this series and it did appear to help with one 
test, but overall I am still seeing a ~25% performance regression (the 
tests are taking about 25% longer to run). I am not the owner or author 
of these specific tests and I have not dived into see exactly what is 
taking longer, but I just know they are taking longer to run.

Anyway, I have not seen any recent updates on this, and so I am not sure 
if there are any other updates or what the current status of this is?

If there are any more patches available I will be happy to test.

Thanks!
Jon

-- 
nvpublic


