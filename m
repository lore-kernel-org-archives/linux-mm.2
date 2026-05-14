Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4A537CD4F39
	for <linux-mm@archiver.kernel.org>; Thu, 14 May 2026 05:18:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 119736B008A; Thu, 14 May 2026 01:18:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0CA6F6B008C; Thu, 14 May 2026 01:18:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EFBD66B0092; Thu, 14 May 2026 01:18:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id DD87B6B008A
	for <linux-mm@kvack.org>; Thu, 14 May 2026 01:18:22 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 6B739C19D2
	for <linux-mm@kvack.org>; Thu, 14 May 2026 05:18:22 +0000 (UTC)
X-FDA: 84764869644.19.506512D
Received: from SA9PR02CU001.outbound.protection.outlook.com (mail-southcentralusazon11013019.outbound.protection.outlook.com [40.93.196.19])
	by imf19.hostedemail.com (Postfix) with ESMTP id 6F00F1A0005
	for <linux-mm@kvack.org>; Thu, 14 May 2026 05:18:19 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=iD4TmyGm;
	spf=pass (imf19.hostedemail.com: domain of shivankg@amd.com designates 40.93.196.19 as permitted sender) smtp.mailfrom=shivankg@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778735899;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xall7EWWT/rJ0wN/C1Y0lrBhqJOBFYYVqTnx3US/mV0=;
	b=uIuC3YoOTdqsvLwPnDWNH7nzmDHicMAk3iJBTcJ4zmyDAljT4q2atJjuTMLRZGT4CE3Ay2
	UkvHZ9NB9Ca5yGYiHfarU4il7edsJtGFre/lmPU5GjlL3GfMBluKwoVk8tNDZVQ1Af89Pn
	JpQDKDO6/qOLfWQNdP6atJDr0C932Gs=
ARC-Authentication-Results: i=2;
	imf19.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=iD4TmyGm;
	spf=pass (imf19.hostedemail.com: domain of shivankg@amd.com designates 40.93.196.19 as permitted sender) smtp.mailfrom=shivankg@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1778735899; a=rsa-sha256;
	cv=pass;
	b=LM9wpnIY3dd9INT/fleiM7cQP+rwfwjBT2QYiyVamePtYaw3t6zgKE5oVXd2CtAoykPEBY
	XE8WlOXwDvMlwHOBqmaOrJJ3oSC0xzhRB7hiOqkB1C7R0MYzTTQ6VA8wUnDrQ5fWQn7uVe
	37rOKe2YBQDFlGtasP7FKffqrkXASsQ=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=P7Xawei4rSC3oEKHbj0P6g/3or45b3hiKz2UhdrkeY4tI3X3TOsTNOCtVSV0IHriyhrysbFP7LiDIhGNg5K6v2jltO4f47NUTXgDWeR/kxQcX0OC93Y7/lcXO0FNjvsPLxURHeEgLfxf55UoSaqZrnHrywYxqzDDHDClNlgXkusj4MGOErIFVVLj0kO0LAuRO4fGbYuTTQN91Rv5lgdpjUrQOZ9cAHPFTm2iYWJ20RMAAAPshVe0tnUvoaw426Od3ecu4FH+5zh2HfdL+zULeRZxSAlMkqGU51VE3Lx7W+v1IsRUoh4rhHN3CuE9a8o5N/i3031LkJBGJdQ5lQSvSw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xall7EWWT/rJ0wN/C1Y0lrBhqJOBFYYVqTnx3US/mV0=;
 b=fRAt53roJdXHtS9a0MeivcoHQzXOhfirqGt+nTTpLkTRh4CIH8nA9DgRgmBTwnO97rqnkl+yTpOepGeTttvVYGszDJ7nXKA/reXJrWmpHEjoYGXsVa4T6jnApwkBWSZj/pmLAQa0GMsXS026r1ZIktfNnyR4h/rHabOyA50Fy+EtGajwdLR+tf+MJ+7Lq41quHoxAHZRSBoby7N925HJGrXmu9EVCu/S5aYGIMhKKaX8pKsc2GlE+5PLIDFlPcs7eDamNE4cfVZiF58eJczp2u8qW7tm6scC97OOvtDYuFrFPehQHNpCli782ey7MaC+Hug+XImHPE0rBUmZ2xPekg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xall7EWWT/rJ0wN/C1Y0lrBhqJOBFYYVqTnx3US/mV0=;
 b=iD4TmyGmZBYk3b0S02qhIssmXtk90C0aaWsehnLfmLj68NYIdqqaKKxB9tJAvarpnGqAQdIlSfgpJE4mcsgrVJ7qq0CE8D8EChT/V43rURX6ZPvuyGZEhgBmiWZ96DvD21/D229ZMPe5O+Yng9t19NFu6p+cmpR6ZVg3N9CT/9I=
Received: from BN9PR12MB5259.namprd12.prod.outlook.com (2603:10b6:408:100::17)
 by DM4PR12MB6544.namprd12.prod.outlook.com (2603:10b6:8:8d::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9913.11; Thu, 14 May 2026 05:18:15 +0000
Received: from BN9PR12MB5259.namprd12.prod.outlook.com
 ([fe80::122c:cca7:c2b3:90ed]) by BN9PR12MB5259.namprd12.prod.outlook.com
 ([fe80::122c:cca7:c2b3:90ed%4]) with mapi id 15.20.9891.021; Thu, 14 May 2026
 05:18:15 +0000
Message-ID: <6a5e794a-a608-4126-9abe-0d512a57dd67@amd.com>
Date: Thu, 14 May 2026 10:47:32 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 1/1] mm: batch page copies in folio_copy() and
 folio_mc_copy()
To: "David Hildenbrand (Arm)" <david@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, x86@kernel.org
Cc: Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>,
 Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>,
 "H . Peter Anvin" <hpa@zytor.com>, Ankur Arora <ankur.a.arora@oracle.com>,
 Bharata B Rao <bharata@amd.com>, Hrushikesh Salunke <hsalunke@amd.com>,
 David Rientjes <rientjes@google.com>, sandipan.das@amd.com
References: <20260427142036.111940-2-shivankg@amd.com>
 <20260427142036.111940-4-shivankg@amd.com>
 <073e5e2c-7102-4141-b0d7-fa5635f811f5@kernel.org>
Content-Language: en-US
From: "Garg, Shivank" <shivankg@amd.com>
In-Reply-To: <073e5e2c-7102-4141-b0d7-fa5635f811f5@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: PN4P287CA0130.INDP287.PROD.OUTLOOK.COM
 (2603:1096:c01:2b1::10) To BN9PR12MB5259.namprd12.prod.outlook.com
 (2603:10b6:408:100::17)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN9PR12MB5259:EE_|DM4PR12MB6544:EE_
X-MS-Office365-Filtering-Correlation-Id: f9cd4689-d80c-4219-8430-08deb17833b1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|7416014|376014|366016|3023799003|4143699003|22082099003|18002099003|56012099003|11063799003;
X-Microsoft-Antispam-Message-Info:
	u6OIVt+z+QLOANFN/zjldhlKGnBRoUSULz/4WSII2vbBCuvGrZL0qL/2uzk0sN6g7B1E5Q56oklvtrkA/e9fr7VuPLYMw+C/e81i6I/DO9EbgZs0g6oNx/+31sNaUJJgyHVcXM56TIt1FUq7ozNaXjPUgWxxP4SF7gIKXV95yRkPn/UqXzOUBVjt+LDJr1ZkbV9h6e4PIBLwF6sGJ+Medaz8KgNvQ2U58X0s5cJ7mt1nsYEVxeI8O8buaUvzWoTb7KM54/X/suoKW9zDCgrd8tATPxD+JsMZMCP1+e4qK9RW88+YTpVtgTumxTxfaNJVC8rBG+J9js8SE77uxrgeY5WDm6VTHUdpOzHyAfYNPUhYurzUS4VB+rUIeah7aUYLOJ9FIn6U6/sGIn/WQPFI++b+hSd5lD2nSqub6xDuHhvR+B2fVm72Q4wdoyBGgf9O28PYVQ65wcSJFmHPe3HQwAzY7BKMfuQYQnHD+d4Rc8ShgbjT+j2EG9qF18Dj1Pb9JF+Uk5MizsQM4TX+BtNpyh+3rFdNnvJmtObj0Zims34zECSUz1noNVzepN6+k2nu/GPgLIlikYYuslrTZlUVpX3kA+qoSx0m4NMfwWqoNJU0dS3Dq+ecce0zBdcSbGIdv77pDGr0WIEGAjrsl2jnZ+D4Jf/j8s46ocNFBLWMGcP+OI7oIu7LvWndO5HexTjx
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR12MB5259.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016)(3023799003)(4143699003)(22082099003)(18002099003)(56012099003)(11063799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?V05xTHpzNVAyODZWQVY2bWk4djFacitncEozRTQ2TUE1NGxLNDJuK3RaV0lI?=
 =?utf-8?B?bUUyM3IwaDg5RDVJeGxpWG5xbnc4cVhuS0lmaERwTEtwZE02K05RMWZVeHYx?=
 =?utf-8?B?N24rNlJ0TUxnd1kxNDIvVHBBUVFhUyszWUI2OGlMUHcxSjJsVGcwUTFOZWJH?=
 =?utf-8?B?cHBETmVEN053RUF5KzQ4RlFPei9mYkNENjJvWk41Q1Yyc0dZSDFBUFFXNjRU?=
 =?utf-8?B?NjhxU3N1OGZBR3hxTCt3MGJaQkx2eGMrcmpqQkJtY2xYdVNYbDFiOG5TNGJJ?=
 =?utf-8?B?TUVMYWRvMDA0QkYxcXo4SkNoL0RXTUFjbXIyejB4bmFNU0Zadm9YdFJDMjZY?=
 =?utf-8?B?WVoxK0ZOK1J5REZiRzN5WGdqVXROSzJoY1B2WFdKL012SklxQVNtUTh3MWxL?=
 =?utf-8?B?Q0hEZnhyWFIrVnlFYW5DZ3Y3MWJkMW83bjBEZWJCR1g0SnJwK01EbVo2cEl6?=
 =?utf-8?B?THRqcXdkY05Ba3ZvVGtDYjJhbXRMRmJIa25NemFmbWJzdytXYWpOeWRwSXNj?=
 =?utf-8?B?blIveGxVVWN3RXBjSUZHZldRK1NKUEVGS1JjYmVoYWd6MGp1YTE3VU4rUUpH?=
 =?utf-8?B?NE56TStVU2N4bThNb3NiUThKa1VhY0NQNStKbHRJY1cyUVpxcUNUT3ArOXV2?=
 =?utf-8?B?MWsvcjRYVklSejZoazRJNUFBZWQ5WkZsSWFSY1E0RS84VXpqaTZvVDhTZ3Rs?=
 =?utf-8?B?SVhzbksrYzM4VFFudGxQZThRVDUvUnhGS2pUYUNod2p6MktXbnhVQ1RpNjBL?=
 =?utf-8?B?U0Y5MmZ5WjJKSk1WMHoyV2ZPanVuYjlkL1g1WG5kaTVtak1aVTFpenNna0lO?=
 =?utf-8?B?RkxSNUxMcHJLM0dxdFp1czhEZWZ3c29TYko5d3M2c3JuSTJ3Smg5ZHJQcGxC?=
 =?utf-8?B?YlU2MythQU1uaFZoYy9qUTFIcW1GVS9xQUp1VjNnKy9OMW9FRGxmRnJBcllD?=
 =?utf-8?B?ck16blpPY0xZK3hUdlFsdGJWY2VuQ25rcmN4TDk4WHFsTVZMb2s2WTNhVS9T?=
 =?utf-8?B?b1AvQXh1dDNJQ2dVSWlnSFk4T0p6UEpFUGRXNHIxVzhKb21JaXEzYXo1Zk9O?=
 =?utf-8?B?eUNDR2hYQ1BoRDBSS01PbU5DKzc4V0o2WTMxT0g0NE1xbnJYTzFiSjZaT0RN?=
 =?utf-8?B?V2tBWjFmWjExQVRHMnhlQVhxOUtJR3BaRzQ2VGY4WWdQcStDdDVxbndYU3Z0?=
 =?utf-8?B?YklXZjZHN0tNdXdsQkZGY3duc2hxZzNWTkR3ak1La1gwZWZUQzdiN2hWS3o1?=
 =?utf-8?B?MllIYjVEeGdwN0paa3BIT3R2RVEzdW5HdEd3V1FLb3lFN3dqemVOQ2llckFy?=
 =?utf-8?B?RHdHaXd3Y2xjYUh0QzNWMWR2b3NVUEJjbUxkU2xlOVUwejRibWtjQTNzWllm?=
 =?utf-8?B?UWszK2l2RU5mTVJMRVo3ZWxWSDJveVdic1h3QTJLSVBMODZwWWluZkltN3Fa?=
 =?utf-8?B?bkREU3BpTHU3MkVMVXRXbGV3WmdIV0VON3FQT1p4V2Fja05pU2JkSU5raUxE?=
 =?utf-8?B?TmhnNUQvUUR0WVBFYllPUEFqRGhQb2d1dStzOU1GZ1lDa1lhaWJtZlFFUGFM?=
 =?utf-8?B?eXQ5OFVRQkovZXNUNitYOUJCTFBZcmtNTElzcUs3aG4zNGp3bXhpVWFVRVlR?=
 =?utf-8?B?OVVsREpBMGxTRUNFNVNBMysvTmlPODcrU20wTEd5Y2dLdE9qTGZjeDQxVWhV?=
 =?utf-8?B?TGFWa2ozY0RSSXZ4LzBNSDJBZ1lRVFFqeVQxNnFnK1N4REhpS0R1YmNHMnJm?=
 =?utf-8?B?YVIwT1I2ckh1ZWZHMlY5bWJVTlpIWE5MYnBPRnNPRmduNnFXYzlaVjh5a3F0?=
 =?utf-8?B?MTZvTFJaRHBDNHdsSStmNFhDdnZDNnRIR0xTcGh6MW5CUnJzb282YllzNzU0?=
 =?utf-8?B?aDVWYUlHR1o0YWtpZ0pMRE1jZmJNV29FU3hXaDh4TW90UFlnMW81eEdudFhv?=
 =?utf-8?B?TlR4RUdDU3dCSXlDRGI5SjZUWFRwMlFtUDZmWWtzMUdKa3VlbmozaklhaThE?=
 =?utf-8?B?aGVxODNZcTVpOEFGNFplSmhrN3BHWEMvZVY4NEFvaFRxMmxRVktXYURzK3F5?=
 =?utf-8?B?anZWM2gvTHFPV2h0QUVBYkQ5d05KemZxaWRjRjNxZ21MUVZqOUpFVkRnTnB1?=
 =?utf-8?B?bTdleVZ3eldmUmdLMW5pVk40SmxwbXB3Qm9yLzkrVnBYWU9la2N4UWJmL2lR?=
 =?utf-8?B?Z2JrZ01oOTFCZVZoWlRVZHB4em5FcTVwV05DV2hySWpuVkkydEVlMmhORlU1?=
 =?utf-8?B?cWxHaTN5ZklvN0RybUVKZFJRdWhaNFZDUFJGUDlGWlo4aUYyd2hrL1FtUWIv?=
 =?utf-8?B?dWFkMlVvcmlaNVN2ZHlWWXpHNUxMMStTUjJlL1B4THhRWmx6Nys2dz09?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f9cd4689-d80c-4219-8430-08deb17833b1
X-MS-Exchange-CrossTenant-AuthSource: BN9PR12MB5259.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 May 2026 05:18:15.6176
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qxnGlSxJwdheuwFA+1M0e/n3ojwHlvlDik93Qku/hxy3fuRexPyylF9IZQbv/Rje5G97hAh/lVGitE4XCpr0GQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB6544
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 6F00F1A0005
X-Rspam-User: 
X-Stat-Signature: 17qk9awet6u9d4nb6h1i5eyzh9ktidie
X-HE-Tag: 1778735899-719229
X-HE-Meta: U2FsdGVkX18Sm2TIY/ph4+AhHcSvP735CHhsXCuD50Mj3eZz/haNzxPZygWbH0OtUUk0FCfa9BbpsFlEJoaFCnvny2WPmi1Eatl6myqzG6InpZm+ApBpDCeKShxMOJ2wQquPjYZSC3OQUSAZzK17BxltaSegkofl/uNqngSFlFURNkJjmyIic4IKPMBe4xKvnAoyttsBNGl1BxxvIW+A7t5wvmdDZChqUXUrg3lYMjoO9ZJWlSCHDyAmS0nlIqeVwwTpwi3jrEZHJSfYoBFeBiWj6VY1xhrNvaYzQCC5jz7ciTVUxXX6/WwlSn/50TqxGwiZkUWFvQbTIwvzdld8eB8YfaBMUcLZYLlR22j7+S2SDE+r6gmTOJM93KgltRfZvjnYA5Cla0STbQBzN97nAQjB3Z3GQkhShSutr2fgOiqIPkGjvBTCbM2JZ8+GLgRqm4BErmwl3Fq7925rbSdXQxyNe0qFcGqiZVBPFxKgo0cabslNki77K/y4kWRFV5xC3suMOjHDRIwOCNNeQjr0mQSBJ/HIlTsHIg7Gyst6+bogVQ0veinJVpRaLGhQ6MuCR2w2zh1RxVzjhS7joBeQtv6fto1DFsrw/gtesA2nbEgm29QQUcHaVXFcB1l6Y8M5LM4O2lnIOjcxG0RaPUcRVu/XSNOTo4GMHWaIE8sEX1PfJwiyN1PbtMFU5sOXYrdvU7j184l9VsodY3pwPSL+UkkBMn0UweNu6IqFDiVGY8GPMT/gmfuqjEsSvKF6R1dmrqaQ0YkE84pxgNpNtBAsJ6ww2n6NeL5fQcIJJgOR0o+oHlQSWfKkoP51cnvuXYJCoB905ZjmfW0uT5QNhCP7LA5817GyoN5AmyggDacroYdke/vLKkqrs/bN+3z+vrlHch+63ELyXYLtUoAIA+hOnL92hIhdFYAO4VmuZkJ317JZbDRVnIwquKaSVdMXpjocqxKGdPhk7FFwFAbN+0X
 FyTDTZp7
 A+zLk9KCIRtLLXNrmcE8bUlfzJYUP9MR5fdL9fjrtv2FYBfM792UQYVy73R81x6T1RS7PU1neM2j96hwMVUZBCMHADlHKX6EkStBbIl93FD+E5986PhGqaunexcRFs0ytkf767OSYOXmJjG3Rw947T1twq54meNlu3V+4tKErTwlBFWfDYebI1dGjJayXozfwtUOopaKApjmGme6xv5b2daVuNo2IcAqPXqrHzVWkwoYbiZxOWqiJQVmePfnElxdfXUCpN0eY5vpZfdwZ1+k2hReprwqY779YR9sgAfndmAem1v0zFxFM7Hal0y++tUl++OsHfuJrd9VBuHgIwvX6Ej6tR0jpCY09CXoHg5utT46QzH4piB5uYjIDNCJaANzyJBoZDZnHzTbX6Ogz0tCar7hgcVE0KtWuO8X0leLYQt9Op460i+eppng1/FtAcxuRXmr/Sx/BKf5W07yr+I1ZV2iy+jM52EqNmNst
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 5/12/2026 3:01 PM, David Hildenbrand (Arm) wrote:
> On 4/27/26 16:20, Shivank Garg wrote:
>> Rewrite folio_copy() and folio_mc_copy() as thin wrappers around new
>> batched helpers copy_highpages() and copy_mc_highpages().
>>
>> The current implementations iterate copy_highpage() (or its #MC-aware
>> variant) per 4 KB page. For a single 2 MB folio that loop runs 512
>> times and pays, per page:
>>
>>   - kmap_local_page() / kunmap_local()
>>   - cond_resched()
>>   - one invocation of the architecture copy_page()/memcpy() primitive
>>
>> The new helpers issue a single copy_mc_to_kernel()/memcpy() over
>> the whole contiguous range when CONFIG_HIGHMEM is off and no
>> architecture overrides (__HAVE_ARCH_COPY_HIGHPAGE) copy_highpage().
>> HIGHMEM and arch overrides keep the existing per-page path.
>>
>> Tested on dual-socket AMD EPYC 9655 (Zen 5) with a CXL.mem node.
>> In-kernel folio_mc_copy() microbenchmark on 2 MB folios, source
>> evicted from cache before each iteration and measured throughput:
>>
>>   direction         baseline GB/s   optimized GB/s   speedup
>>   DRAM0 -> DRAM1     18.65 ± 1.37    38.03 ± 3.21     2.04x
>>   DRAM0 -> CXL       25.46 ± 2.89    39.29 ± 1.17     1.54x
>>   CXL   -> DRAM0     20.61 ± 3.95    35.07 ± 0.62     1.70x
>>
>> End-to-end move_pages(2) throughput on anonymous 2 MB mTHP folios,
>> 1 GB migrated per run:
>>
>>   direction         baseline GB/s   optimized GB/s   speedup
>>   DRAM0 -> DRAM1      7.20 ± 0.03     8.01 ± 0.02     1.11x
>>   DRAM0 -> CXL       11.12 ± 0.15    13.07 ± 0.03     1.18x
>>   DRAM1 -> DRAM0      7.21 ± 0.02     7.95 ± 0.02     1.10x
>>   CXL   -> DRAM0      9.10 ± 0.05     9.49 ± 0.01     1.04x
>>
>> On AMD EPYC 7713 (Zen 3 / Milan, REP_GOOD without FSRM/ERMS) the
>> folio_copy() bulk path regresses because memcpy() falls through to
>> memcpy_orig (an unrolled movq loop), which is slower than the
>> per-page copy_page() (microcoded rep movsq) it replaces. 
> 
> Do you know what the reason for that fallback is? Could it be fixed (e.g., when
> we detect page alignment or sth like that?)
> 

The fallback is gated on X86_FEATURE_FSRM in arch/x86/lib/memcpy_64.S:

SYM_TYPED_FUNC_START(__memcpy)
	ALTERNATIVE "jmp memcpy_orig", "", X86_FEATURE_FSRM
	movq %rdi, %rax
	movq %rdx, %rcx
	rep movsb
	RET

AMD Zen 3 does not have FSRM, so it jmp to memcpy_orig (unrolled movq loop).


On v7.1.0-rc3, I measured these primitives and the kernel's actual memcpy()
across three CPUs, using a kernel module that vmallocs 16MB src/dst buffer
and times each primitive for comparison.
Numbers are mean (in GB/s) ± SD% (= SD as percent of mean).


1.) AMD EPYC 7713 (Zen 3), Flags: rep_good only, no ERMS/FSRM:

  size   unrolled_movq GB/s±SD%   rep_movsq GB/s±SD%  kernel_memcpy GB/s±SD%  
------------------------------------------------------------------------------
   16B      0.38± 8.73%            0.41± 0.43%            0.43± 0.31%
   32B      0.85± 0.19%            0.80± 8.37%            0.84± 0.07%
   64B      1.68± 0.35%            1.60± 0.03%            1.59± 9.37%
  128B      3.23± 0.22%            3.04± 0.62%            3.19± 0.03%
  256B      5.99± 5.78%            5.62± 4.15%            5.93± 0.42%
  512B     10.07± 1.36%           10.49± 2.60%           10.02± 0.21%
    1K     14.49± 0.09%           18.19± 0.37%           14.31± 3.48%
    2K     17.11± 1.01%           28.04± 2.37%           18.14± 0.56%
    4K     18.36± 0.22%           39.15± 0.50%           19.57± 1.14%

- kernel_memcpy is tracking unrolled_movq.
- rep_movsq is 1.4x-2x faster than the unrolled_movq fallback for >= 1 KiB.

2.) On Intel(R) Xeon(R) Platinum 8362
Flags: rep_good, erms, fsrm

  size  unrolled_movq GB/s±SD%   rep_movsq GB/s±SD%   rep_movsb GB/s±SD%   kernel_memcpy GB/s±SD%
--------------------------------------------------------------------------------------------
   16B      0.89± 0.93%            0.64± 0.10%            0.69± 0.57%            0.66± 3.52%
   32B      2.08± 2.46%            1.28± 0.15%            1.38± 6.21%            1.33± 4.28%
   64B      3.97± 2.26%            2.55± 0.24%            2.83± 0.22%            2.65± 4.48%
  128B      7.45± 0.09%            5.00± 2.53%            5.48± 5.04%            5.30± 1.60%
  256B     13.24± 0.01%            9.79± 0.57%           10.12± 0.37%            9.81± 0.34%
  512B     21.67± 0.03%           17.87± 0.02%           18.43± 0.79%           17.81± 0.25%
    1K     27.84± 1.96%           34.54± 1.24%           35.67± 1.88%           34.56± 2.49%
    2K     32.67± 2.35%           59.58± 0.01%           65.67± 0.18%           59.35± 1.12%
    4K     34.85± 0.64%           95.35± 0.00%           96.64± 0.69%           95.35± 0.00%

- kernel_memcpy is using rep_movsb (FSRM in use). 
- Below 512 B the unrolled movq loop is ~20-50% faster, >1 KiB FSRM wins.

3.) On AMD EPYC 9655 96-Core Processor (Zen 5)
Flags: rep_good, erms, fsrm

size   unrolled_movq GB/s±SD%    rep_movsq GB/s±SD%       rep_movsb GB/s±SD%   kernel_memcpy GB/s±SD%
--------------------------------------------------------------------------------------------
   16B      0.53± 0.39%            0.53± 0.21%            0.55± 0.13%            0.53± 0.14%
   32B      1.13± 1.49%            1.06± 0.07%            1.09± 0.16%            1.06± 0.09%
   64B      2.21± 0.12%            2.13± 0.07%            2.18± 0.14%            2.13± 0.09%
  128B      4.25± 0.12%            4.26± 0.10%            4.37± 0.12%            4.31± 0.14%
  256B      8.01± 0.19%            8.61± 0.27%            8.61± 0.18%            8.51± 0.10%
  512B     14.14± 0.18%           16.80± 0.24%           16.80± 0.23%           16.81± 0.24%
    1K     22.93± 0.73%           31.70± 0.48%           32.37± 0.28%           32.02± 0.22%
    2K     30.36± 0.27%           53.24± 1.01%           56.58± 0.22%           56.04± 0.22%
    4K     35.05± 0.65%           80.25± 0.41%           83.90± 0.20%           76.23± 0.37%

- kernel_memcpy is using rep_movsb (FSRM in use). 
- For smaller size, unrolled movq are close enough to be within noise.


Regarding the fix,
One option is to make memcpy() fall back to rep movsq instead of unrolled
movq loop when FSRM is absent. The data shows the benefit on Zen 3. For
the Intel, unrolled movq is faster for smaller sizes.
But, I'm not sure if adding these complexities to memcpy() is welcome.
Happy to work on this if it is helpful.

Another option is to leave memcpy() untouched for this series and add
a new copy_pages() helper that the folio copy path can use. It would
use ALTERNATIVE_2 that picks rep movsb on ERMS/FSRM and rep movsq on
REP_GOOD and per-page copy_page() loop as the final fallback.

Thanks,
Shivank

