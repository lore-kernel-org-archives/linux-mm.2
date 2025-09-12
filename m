Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D1EF1CAC593
	for <linux-mm@archiver.kernel.org>; Fri, 12 Sep 2025 04:52:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 343718E0007; Fri, 12 Sep 2025 00:52:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 31AF38E0001; Fri, 12 Sep 2025 00:52:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1E2B68E0007; Fri, 12 Sep 2025 00:52:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 077B18E0001
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 00:52:08 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id C588311A142
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 04:52:07 +0000 (UTC)
X-FDA: 83879376294.11.F5CB209
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2063.outbound.protection.outlook.com [40.107.95.63])
	by imf26.hostedemail.com (Postfix) with ESMTP id ED4DC140002
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 04:52:04 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=UKxvgSri;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf26.hostedemail.com: domain of balbirs@nvidia.com designates 40.107.95.63 as permitted sender) smtp.mailfrom=balbirs@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757652725;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kHHj7p1C/Pn1UK0TIwEiLsFgxXHhF8omns9htI3hjsg=;
	b=zMLimNOtTlT29xL81/Zi1V9BqZy9GVaGzx+oHEjl3SwV6PFqCud82zyzsvovtn/p/2iPnI
	7lGzGdyoVPwowCjxFYtUB1g+wb//3tepQC8TEfa3wElY2sLwJ60xIFbnhkioT/5e2TjaWB
	KdtCxVbbttfZRFjgCVzo0idd9kqLYpw=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1757652725; a=rsa-sha256;
	cv=pass;
	b=wf50V3p2zjmBtfdzOlsjw1YJ+MrxUyhke7imnUCjY5BdnBq9e2kaHyLDIwzRjbIj30ghmt
	bNJW1rqE0Nze9RZl3UA34P3ApFX26pP6CDBvTjgujq0tL/xRN0N4xAH3S7OE7UAnwPseVp
	AgqoNYfNX7YPtqIoDTYYgsff1MN3YH0=
ARC-Authentication-Results: i=2;
	imf26.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=UKxvgSri;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf26.hostedemail.com: domain of balbirs@nvidia.com designates 40.107.95.63 as permitted sender) smtp.mailfrom=balbirs@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ElfrGhaif51p12KHjEtQdpDU8nImTyxG00SxcGa4L0Nbk+X+9zlw7qoaY1aH+LzP6AAZ+gY6TAil6ZowDePL5sPWV1Qmp5j8eLBYEls6Dh750wtJnohGrXMK0lJclII4LfOHTs+PmsBzvSeEsTMAfHCem2V51+ADkJkeouOxlzWfNr4vGh5dosHlpjtrNw/89JH5qcLRG8plBpvCWVB27d/h3x5HSvb1V6sAbdyRRKTWgjrngScTeJIuwFpi7XTYZJKv/ZqBtmdVyyQ5M5ezCReBfV1ObKIzlqCbfhYKHoFcrsygKE5hkOSNn+2nqF45NQXJMynrX6nDBYPiZN3CZQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kHHj7p1C/Pn1UK0TIwEiLsFgxXHhF8omns9htI3hjsg=;
 b=MqmZdoa5sl6na3fs6GbKn+exO1QwTHD0HA/MEDpAdrliBRPQ3CZRD9kFYzpGLWWrgvNRCiM2Urfe3hdwkeJa09tprdadhHUb5Moj9vb8QyK2Iy0SESxud29dYSys1nH07kd8zWVAiFnnoVY+NELh01lzzHYwiHWirlNU5S5jVe6ZXhEJ3cYN+OTDlLnXMTaQoIqoWl9Ic4GXb7eIk3/XXwQbBiqbqoSviQWeQl8GTA872OoupDpKbnwYl3vwMlIBRBAM9vL/Al2UmxSm1iG/3tJcDrkUg2NPblWs6H2mZs1biT59je0qfY9Y8MdM3lnBSAuxqtNWEJqVgM67AzknRQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kHHj7p1C/Pn1UK0TIwEiLsFgxXHhF8omns9htI3hjsg=;
 b=UKxvgSrie8ITih8sJqvLnMyf9Oms+FwOHvayb+mSCjoXpQYx4KmYumIYSpe7riqV4AAcYHRkVdbOSJp6EgCNKDTmEc72onx1rO/DT7DFnQDioJhm1O/mcrVF20baH10ZOf38wNuFo3KA58Al6y08i8uay2ReceE0quRKsCBhXehYGMw3qePg156zERrBJVshDWwIn7rdtHqYWO9ADimTWIXWtDBkz9A52srQJ10w95v/EmLcQNnw/76GEPUeErXxsuqdBRyA0mWzsglLeAHVv5birfJWstAzt8fSZZuydRelhV7Iszgi4+wYwJj4U8o8QzjrfZmoA8XwHDUWJAgn0A==
Received: from PH8PR12MB7277.namprd12.prod.outlook.com (2603:10b6:510:223::13)
 by SN7PR12MB6791.namprd12.prod.outlook.com (2603:10b6:806:268::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9094.22; Fri, 12 Sep
 2025 04:52:01 +0000
Received: from PH8PR12MB7277.namprd12.prod.outlook.com
 ([fe80::3a4:70ea:ff05:1251]) by PH8PR12MB7277.namprd12.prod.outlook.com
 ([fe80::3a4:70ea:ff05:1251%7]) with mapi id 15.20.9094.021; Fri, 12 Sep 2025
 04:52:01 +0000
Message-ID: <c2d563b2-da9e-4e3b-989a-97f7eb828d6a@nvidia.com>
Date: Fri, 12 Sep 2025 14:51:53 +1000
User-Agent: Mozilla Thunderbird
Subject: Re: [v5 03/15] mm/rmap: extend rmap and migration support
 device-private entries
To: SeongJae Park <sj@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 dri-devel@lists.freedesktop.org, Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@redhat.com>, Zi Yan <ziy@nvidia.com>,
 Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
 Byungchul Park <byungchul@sk.com>, Gregory Price <gourry@gourry.net>,
 Ying Huang <ying.huang@linux.alibaba.com>,
 Alistair Popple <apopple@nvidia.com>, Oscar Salvador <osalvador@suse.de>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lyude Paul <lyude@redhat.com>,
 Danilo Krummrich <dakr@kernel.org>, David Airlie <airlied@gmail.com>,
 Simona Vetter <simona@ffwll.ch>, Ralph Campbell <rcampbell@nvidia.com>,
 =?UTF-8?Q?Mika_Penttil=C3=A4?= <mpenttil@redhat.com>,
 Matthew Brost <matthew.brost@intel.com>,
 Francois Dugast <francois.dugast@intel.com>
References: <20250912015910.59404-1-sj@kernel.org>
Content-Language: en-US
From: Balbir Singh <balbirs@nvidia.com>
In-Reply-To: <20250912015910.59404-1-sj@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SJ0PR03CA0057.namprd03.prod.outlook.com
 (2603:10b6:a03:33e::32) To PH8PR12MB7277.namprd12.prod.outlook.com
 (2603:10b6:510:223::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR12MB7277:EE_|SN7PR12MB6791:EE_
X-MS-Office365-Filtering-Correlation-Id: 1daa207e-92cd-46aa-682d-08ddf1b81c92
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|10070799003|366016|1800799024|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?S1RuNkYwbkJvYmtUNTA4ZmFqU0R0TVBBYS91OUVxS1RYampIWVl5aTk1UDl4?=
 =?utf-8?B?WGUxeUo2dE1BL21qZ2ZrelhQd3R5Rk5FZzIzUGkwT0VObEpER0ZxOUdPdURO?=
 =?utf-8?B?N3R5ODBDQlYzWlV4S2hVZE4xa1JqRXBOK1Y2bHRjd25QSTVWa003ZUNWSkgw?=
 =?utf-8?B?R2twa2Jid0V4L28ybXBySWI5bWtuVlROT3FwS055aE0zUkRCOHVvL0llUk1R?=
 =?utf-8?B?Qi8ydkxHaEJ3YU0wNWxCTmpSYXg1Q0MrTGk4disyZldDK3BRWTlSaGRpdSta?=
 =?utf-8?B?clY4dnlQTEQyVTk4enkrWlRQMmxNUmlPYmJ6V1lhaXBCVVNNZVVjbTh1VGpD?=
 =?utf-8?B?QndZWWMvZkxzTWVoTnY3bGNzSkhwendzcHdrRysyRmNkRG9xMDUyZU1WZVZ2?=
 =?utf-8?B?YWplbmtyQzBORi9CQUE1VGpocUFzSHpaRjl0UlNCc0ZNY3N6OFJja25ENWlD?=
 =?utf-8?B?UHloWmEzaS90a1VXRk85dGFzemJqOHMxTkNzZHdyYWE0SW9mM1Q4eldjazMw?=
 =?utf-8?B?WXVWWTZFOHpxV3NNSU5GVktQUVRQSjBwVDJRbnVVSERXQ3FPM2FmUGgxOFdC?=
 =?utf-8?B?UWZUT3FZcTNPWUtpOElPb0pjR09Xem5UY0pZWFNDVjIwWk03OHJsODgyN3Nz?=
 =?utf-8?B?R2sxRHEyMWxOWklWZzRxdkZORmxTYWRzQVBPR0N4L1hDQXhHejBXZ0pNZ0Fw?=
 =?utf-8?B?K1MzM0JuMVhqV0pJMm9qYlVJRys5bFMvY1IrRnFaWHRMeVVWWHlDK3hJaGtG?=
 =?utf-8?B?Zko5cHA3b284UnlIWUFhQzFFMXkzTUg3VVFROEtidGtZSVg0S096Nk8ydVhG?=
 =?utf-8?B?MFlFTnJDS1VuelpVcjRPVHkxYlJDeEphamZwQzVDYTVrNm5VSXVjRGJxa1ZR?=
 =?utf-8?B?TW1KcGI3QWdLOE9xSy9iZ1lHYU03MjV4QitNQ1lvdzF5aVo2UnE3U0U3NkhJ?=
 =?utf-8?B?azYxK0VqQ3Vub3NPTW45U0J6QkhIY1BodXB3elo5cGZrdnB1Mmo0UzZ1TWdG?=
 =?utf-8?B?RTBiVkE5OVRacEZqOVBnWjMydDRkc0NycWdHVzN1Q3VKT29EVWhTZ3hVRG5j?=
 =?utf-8?B?QUsxeEhlNk5IYkNzTExWK0hNMEJFSVg0WEtvZGt3U0s3M2VtR1A1OG5rd09S?=
 =?utf-8?B?dkkzekh3VUFuZWdYZWFZV0FrQ2xnNHRQa3AvNTBNSkxVY1lxVmdFN04zRmpj?=
 =?utf-8?B?RTZxbjl0b1ZFM05DeElXZ3pheVhOd3VvanJzbnNqNG1yQU1DRUg1Sm9RQkxY?=
 =?utf-8?B?emR6RUx6cEpjWWVEcXp6ZTFaVnFvOWJPRzRCa1E5dlkxZ0VRWFhzUU1hWGhI?=
 =?utf-8?B?Y1ZpY2tLV3VhTThCTW1EeWFZcjVuRExEYnhRQW5xMnJ6Ym5MTVlNWE1MdFl1?=
 =?utf-8?B?NGx1akV6UndIRk0rS0JWVzFUbEJQMDRRLzg4VWtSOWVLSGYyL21jUitBUno2?=
 =?utf-8?B?UktndWI4T2JIRTBPNlAzOHhKT3FvcmFxa2h0TS9oTTFiZE52Z0lMZjhmOHNL?=
 =?utf-8?B?WVM3cHhmMCtVRWtkbmpkMkM0MGpJdUo3RUJ1bFdGRit2VnZSVDR1NGdwUFdR?=
 =?utf-8?B?b2FRbWhRdHhncWFreWt2ZllGc3ZDN3RJZVdQRk0xeHpWbzBUaDdMZ0Jwcys5?=
 =?utf-8?B?ZWR5SHZDT2drZmVhaERVc0hYYzhJSUF6N1crZGNqNDJvTjI5R0JrTDRweVZU?=
 =?utf-8?B?elBNM0F6Q1YrT2Y5V3BjOFpsSnQreWQ1ZldLZTl5WFVKV0tYY0IxTGpuRUd2?=
 =?utf-8?B?RDJ1VHRzN2NaYlEraVNTT3Bvd1M4MFhuZXdlR09NcUh3VG1xdkpldDBCcEFk?=
 =?utf-8?B?OFNRWEFMY0dOdElUNjZHQWRLVE5PRjZad25NdldoWk5CdmVUVVNWWGV3U2s4?=
 =?utf-8?B?TWlPQ0NteFd1WFlsYTdlSVhlU2NRY2NteXpGZG0wZjZwZFE9PQ==?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR12MB7277.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(10070799003)(366016)(1800799024)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?cDg5aTBETjNCcTFIa2NEY3BYeUpWVlhBOGJmNzZ2RkRpVFpKNk8xaWc2Wnpt?=
 =?utf-8?B?em5QK0RzVkJOQ1YycWViVVRrVDEwSnRyNGVOY3Bob1pCSGFYSzNjRWpqZlYr?=
 =?utf-8?B?WTN0dGI3QnU3TmRyVk5IUTFZWjBFTnBkcHFVVDZ2cFRIWk42ZmtES0ljaUY2?=
 =?utf-8?B?YnZNMTFYRktYMHBIWkh4ellKTUF3Q3k3cDVCL3dsTTBxdDR0eEhMb0U4VS9z?=
 =?utf-8?B?UTZOTnJKNTErT09RaWNvRFpJVncyWmhWSW1HUEZpTUZSNXdPczhxWFlCQWhS?=
 =?utf-8?B?NndLczVwUnBuRk1kYUV1UGNoU042LzZjTStGQ0NNQ21BMmNhck9QZTVMOXVT?=
 =?utf-8?B?Tndvemx1c2JCWHhQU2w5cHRMcE54SHM1WmdXSnAvZHI5ZHVIT0FpRi9MUlNx?=
 =?utf-8?B?T0VVME44QnVaUWtjNFQ0Y1JrdDRRalNaOTFNSlIyZTdUMDlVeUtzSDFNeWpZ?=
 =?utf-8?B?TGZEU3ZsZDhrc0RGRkRpdzJpaUU2VTVwWGtKWHp0Y1NaazBRTWl3UDE1M1ls?=
 =?utf-8?B?Q0JqZjZWaVN0aE1SWEppV2pkdmdBek9DSm5TZXJ3V3JLYXI0blJnZWt4eE8y?=
 =?utf-8?B?WHFCTnkyckhLRjMyU2d6c2FkWHpOL2ptYU9HbVRQczkyU2RzOVJ2ampBWExy?=
 =?utf-8?B?QWdCUVB6eW8yeFlyMk03RjBvK1h6Y21rYVRHUllrSXliOWFJaCttZ0RidzYz?=
 =?utf-8?B?SlkvVWR2Tzd2ZFZIdzQwMEZsQU9wcFNjc2VaeXhBQS9BWThYYUk5eUdEc1Rh?=
 =?utf-8?B?TnJPcDZJYVFZRXJwVGxUT3NBMTE0VkNCcnRPd2YrV0Rwb09GQnhaSVpyRlls?=
 =?utf-8?B?K3FrUDBLMy9qWHN1RnNSaEQ5MFgxRWh0WGROc2VjZFZ0TTZLL3NYM3dHc2tX?=
 =?utf-8?B?SFlFSFFoTCtpZGxQbXVKY2pmNVVScEV4Q0ZNdGxIOWkrUmY4VUp6dDlwdHR0?=
 =?utf-8?B?T25FVHNNNFZBZ0h3b0ZhVmFiek9FZk5QemJqK3cwa3BUN1J1Wm1QRHdHZXdl?=
 =?utf-8?B?N1VHdElSWjZ1L2dDRGE0dnE1OVc2eC9ibFE3OWVueWloTlJSNXU1bXRERmdi?=
 =?utf-8?B?cC85d0xwaHFrRVpUTnkvZTh2b1k0OU8xQVlJUTl1QlRTdVdwYU9tK0RNNndV?=
 =?utf-8?B?QXNnZWEyZEwwQWlrWFNEOVBTekp0VHFMTGgvdjZxWGVaenVEZGNaZE0xSDBM?=
 =?utf-8?B?RFBpam9VaFpWY0F0RkVWZjJtczlOWmJRTlRNN2plT04xRTh4QmZDZ0dHMUJO?=
 =?utf-8?B?aXhVVkZMVGIxTDVDb1NjK2x0eXB5cWI4eU9pS2VJV1lleXVqTzY1REgxZkJU?=
 =?utf-8?B?a1hZYXBnR1dZcVRodCtzdmpKOFl2OE9MRXpKd0xwOGdWY3E5cTVjNlBHZml6?=
 =?utf-8?B?aFc1TGZMZFJXZ2ZQQXJROVB5Ti9aMW5yOEtPQzhTWi9vZktqc3gyNjVpNk5o?=
 =?utf-8?B?bVN5dDJJbWJzMGc3OHNXaXZJVzh1OEpKbVg5eXZiaUVSRTZRWVdGbUNBbEJ6?=
 =?utf-8?B?UmlWYm5qNzQxaHdPS0dVWE8vdzdpQ2oraXFncUgvOHRvOUZac1FVd1NNSVZR?=
 =?utf-8?B?MlVZOW02NXVtbnViRHRxQjJPMkh5NWZpRXd3VUk5U29Ba2FkUWJWS0Q2aFVP?=
 =?utf-8?B?aC9oMWJiekhuTW92V1RlNXJVQzcvN25ndnB1ZU40VkRjSmZCZnVMWUNhak5S?=
 =?utf-8?B?a2pXY1lsV0NJNXRIYkRnVDBBRnFYSXNNVFMxVWdtN3BjanlwNzBra2VrbjJ5?=
 =?utf-8?B?ZzlRWDFOWFJNbVJXcTVRaVlKMCtXRm5YS1FxS2U5TWJibTNXdkZJaWpGRlI4?=
 =?utf-8?B?WUNKUWNiN1VPWVdDbEtENktMNWdGRFoxRzBnTURhTEkzY21DSVQzcmwzMjJz?=
 =?utf-8?B?aHo1ZDRqT25SV1JrbkhQSVpuUTdtMTN4NStULzQzRjZxcjdWM09OalZRWHhs?=
 =?utf-8?B?MU40bmdwbmFOS0hYaGp6d0Vmb3BaSEQ3RGppM1E2WGhidHViY2RCQ2JFQ3Fo?=
 =?utf-8?B?cFplZnVMZWIrR3J6dTNCUzJiQlA2Zk9GejRQZXQxM2liMTQ3aVl0d2J4MnE5?=
 =?utf-8?B?bmtCUXk3Y3VaMnRsd1oxSTljS2lrUHY0WDlocVdISXFCSWYzOHJZRWY5aG9U?=
 =?utf-8?B?TnllejVHWVRmR2ZHcWpxSHEyLzRzVWlaU0FLMnAzOUxIS2gxc2NUOWJGT2Ux?=
 =?utf-8?Q?p2OGVOl7USMojQwakUXIZ7OvpsqIZ/a+XDP4ee+Yi0Q6?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1daa207e-92cd-46aa-682d-08ddf1b81c92
X-MS-Exchange-CrossTenant-AuthSource: PH8PR12MB7277.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Sep 2025 04:52:01.3193
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KUuSbUvfgpkbqu8dvUhqFa1yo2H1HLc6S6EGHg3PB6jWviUVEkF4uzVI9kMGti1QROaxGCdk6KHkRx7+3P59ww==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB6791
X-Stat-Signature: juyphaywhu5t6nsks66is6k91bdnueza
X-Rspamd-Queue-Id: ED4DC140002
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1757652724-667655
X-HE-Meta: U2FsdGVkX1+jH/esMbAl6353yZtQxHsWbZ3H3BKKaAzxGf/CtaoiLIEtc1/Rg1srGcT8H6CD4F2Zkx2J/DXZJRWwDsEKd4UkFL/Ze0ugtvBITzs5Bk7QaMpXfj4fhqn6cPOmErFyoJQ6s9zwxqDmbrv4cBLljQHHy8NaT73ppvAAMthrSwb4z/1iKF4ClivyjdPD5EYjEBrntUFePmHm24HA7QWJNYxo/HpcmQYKj6hN1YRyN7OdXonNoEoqEsxSUcMNX3AImgaPwwAlI9Z+d4Q5ZKQ/+4gdOJKaVO0QZOsVjeWhZUaDhGt/ky7pBML2kKjPpoNER3HgeVpJkthsEIQtICfYb0eMsJQQOLypCiEM96TA33l5C8WhSddymb/d1jlP+dNxy5mecD3HIuybc7wj+WPJ+/O5dF5Ymtiix9m0HgmyBGQ3OhQnD5VvI91ojuHvSQXGi4A+fDDcsg/bNfHG3Jh7YERpZhUrKJbpq4ZRKPHv1CM411US+shzmpcy40Ixj+S/ej3uiKzoZnkhJ8u0mfOpEASq/xAuGALHtaBy+EFG6AmYiRjC7py103dWoSY4p0nAXaMfJ9rzg2x+40rdK3tDHppqOlWIgK/pPbVj2/r4Y6gmgnkEquproAsfRW1GUqpQ+rZzMUEW31pKJQ7QUebaDYiXhjn9jgmO7XTp1LHc3jL1pmUZr/k3y0E8IgVYi2+xqIwzLjxvUxkZAIORsENCVDFuXKMj5sRtFo0CTaY9zqTn0fpCWT4BsVJfuCf6k7o5zo6j9MwSk/pkV6C/NeRA0p9BHN4/52nM0gq6aMnPfZm8xeBhNDEFb0ArmTS9HGNG03Ny4W1PboC7Qo/5GjBzu/79PUfY/huL9Zz4XbVUl4/m1sB5+mO/Kge5z7Qwns4zT5+/n4ORtUxnSxcq99sJLBWV7DbOZhTnmqfvVzpmPeTGx9+WWoBp21WgLXtLVG04Tz9xaajMBWD
 yRUgcZZ4
 HMoUOVni0FYOHFKmiXUUg6OhA9E3bbn12Ino/tM9fysxbVtqorAZmZZ8eBQRkWlB71antlU2k/m9JGWN7/UxOk+DytSpYaIDuE6//5n41FxB0MtEpfuHB4bvU8EP5lSWvciAsSU73gliPX+gsJhzF7BwpnZMy7ZzG92hISn+DsVVkVlU5XJIrb++m9NlbYiZzto+ksuZbo5qUz/8JtG7YAOu5uebpOVNOdrR5/c7BrrBqrSlRCPLAolZ7cv01TinKpHeqN6O3x7lTELoeSXyWYbZBJfVtljUYs/BEGMclsbRiB6FjlIAm04qKl8jFwAhxcR0L32GSpocHWIxo9Y8mQarhPD2WUpVgE0UYoAozPb5R8qIldKxMXd89ioopY9gxMWVkO+cvOQocZs3Z+6zvn1kz+QhAn6Ia9lR1uKm0uUStZJBK4aWBnlnSDaAKEtLjVHE7+c6/ZeKdBCY6TIicdv2ac+tzsrjauKlKgavp053ULT1l2t5vb4v1RGvhMGggUg/ynTYWcWoyaH22KznCXo1J6XTQo9Gsuv2w2/pSmPKv3+vdpGGVDGJj86Jklfg6M1n6ibkHQzMsSyRkjJY/9v0KqLwOAUNeYPMy/1xBNpmyWfJ4zSpaatj5vfDFl6w2z7OalFcxpmtRB8MDkCzGucM88srUbF6xrPubohmhuWxs+2X9/FTOzz4aoPwMdrgqa76UTZ/Pw0UZn8kIc6mb2kRcIHhHOgrOue2wW6tLO6PQqJoXujLt3QMpvTuZ/7vW3YcjBJB0qOvagLtqpLdinUMX7bHUm2hn83culTEeVQjpqTRDx5ZzEOWpQlKXoN/Vj6xPqYggz2f3OeRm3JZB1vJ+bKq9oXgmrovHOvBV/qZPQWFBymjGYXL0Y5AkhIV8XBi6JkBv/s8z5rXbSUWxaZ00k9Vwftd3jWAk+ZVENR1pPFYNyDZwMVm3L2F4qqN+vVoxl80qVfYFXtUV6Ndtlr8gHVzE
 X7UQTIyN
 8Q/WwA8733oX/0Pcy2oj+Q==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/12/25 11:59, SeongJae Park wrote:
> On Mon,  8 Sep 2025 10:04:36 +1000 Balbir Singh <balbirs@nvidia.com> wrote:
> 
>> Add device-private THP support to reverse mapping infrastructure,
>> enabling proper handling during migration and walk operations.
>>
>> The key changes are:
>> - add_migration_pmd()/remove_migration_pmd(): Handle device-private
>>   entries during folio migration and splitting
>> - page_vma_mapped_walk(): Recognize device-private THP entries during
>>   VMA traversal operations
>>
>> This change supports folio splitting and migration operations on
>> device-private entries.
>>
>> Cc: Andrew Morton <akpm@linux-foundation.org>
>> Cc: David Hildenbrand <david@redhat.com>
>> Cc: Zi Yan <ziy@nvidia.com>
>> Cc: Joshua Hahn <joshua.hahnjy@gmail.com>
>> Cc: Rakie Kim <rakie.kim@sk.com>
>> Cc: Byungchul Park <byungchul@sk.com>
>> Cc: Gregory Price <gourry@gourry.net>
>> Cc: Ying Huang <ying.huang@linux.alibaba.com>
>> Cc: Alistair Popple <apopple@nvidia.com>
>> Cc: Oscar Salvador <osalvador@suse.de>
>> Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
>> Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
>> Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>
>> Cc: Nico Pache <npache@redhat.com>
>> Cc: Ryan Roberts <ryan.roberts@arm.com>
>> Cc: Dev Jain <dev.jain@arm.com>
>> Cc: Barry Song <baohua@kernel.org>
>> Cc: Lyude Paul <lyude@redhat.com>
>> Cc: Danilo Krummrich <dakr@kernel.org>
>> Cc: David Airlie <airlied@gmail.com>
>> Cc: Simona Vetter <simona@ffwll.ch>
>> Cc: Ralph Campbell <rcampbell@nvidia.com>
>> Cc: Mika Penttilä <mpenttil@redhat.com>
>> Cc: Matthew Brost <matthew.brost@intel.com>
>> Cc: Francois Dugast <francois.dugast@intel.com>
>>
>> Signed-off-by: Balbir Singh <balbirs@nvidia.com>
>> ---
>>  mm/damon/ops-common.c | 20 +++++++++++++++++---
>>  mm/huge_memory.c      | 16 +++++++++++++++-
>>  mm/page_idle.c        |  5 +++--
>>  mm/page_vma_mapped.c  | 12 ++++++++++--
>>  mm/rmap.c             | 19 ++++++++++++++++---
>>  5 files changed, 61 insertions(+), 11 deletions(-)
>>
>> diff --git a/mm/damon/ops-common.c b/mm/damon/ops-common.c
>> index 998c5180a603..eda4de553611 100644
>> --- a/mm/damon/ops-common.c
>> +++ b/mm/damon/ops-common.c
>> @@ -75,12 +75,24 @@ void damon_ptep_mkold(pte_t *pte, struct vm_area_struct *vma, unsigned long addr
>>  void damon_pmdp_mkold(pmd_t *pmd, struct vm_area_struct *vma, unsigned long addr)
>>  {
>>  #ifdef CONFIG_TRANSPARENT_HUGEPAGE
>> -	struct folio *folio = damon_get_folio(pmd_pfn(pmdp_get(pmd)));
>> +	pmd_t pmdval = pmdp_get(pmd);
>> +	struct folio *folio;
>> +	bool young = false;
>> +	unsigned long pfn;
>> +
>> +	if (likely(pmd_present(pmdval)))
>> +		pfn = pmd_pfn(pmdval);
>> +	else
>> +		pfn = swp_offset_pfn(pmd_to_swp_entry(pmdval));
>>  
>> +	folio = damon_get_folio(pfn);
>>  	if (!folio)
>>  		return;
>>  
>> -	if (pmdp_clear_young_notify(vma, addr, pmd))
>> +	if (likely(pmd_present(pmdval)))
>> +		young |= pmdp_clear_young_notify(vma, addr, pmd);
>> +	young |= mmu_notifier_clear_young(vma->vm_mm, addr, addr + PAGE_SIZE);
>> +	if (young)
>>  		folio_set_young(folio);
>>  
>>  	folio_set_idle(folio);
>> @@ -203,7 +215,9 @@ static bool damon_folio_young_one(struct folio *folio,
>>  				mmu_notifier_test_young(vma->vm_mm, addr);
>>  		} else {
>>  #ifdef CONFIG_TRANSPARENT_HUGEPAGE
>> -			*accessed = pmd_young(pmdp_get(pvmw.pmd)) ||
>> +			pmd_t pmd = pmdp_get(pvmw.pmd);
>> +
>> +			*accessed = (pmd_present(pmd) && pmd_young(pmd)) ||
>>  				!folio_test_idle(folio) ||
>>  				mmu_notifier_test_young(vma->vm_mm, addr);
> 
> Could you please elaborate more about why the above change is needed on the
> commit message?
> 
> For example, I found below from v3 of this patch series:
> 
>     pmd_pfn() does not work well with zone device entries, use
>     pfn_pmd_entry_to_swap() for checking and comparison as for zone device
>     entries.
> 
> Adding that kind of elaboration on the commit message would be helpful.
> 
> Also, seems the DAMON part change is not really required to be made together
> with other changes.  If I'm not wrong, could you make DAMON part change as a
> separate commit?
> 
> The code looks good to me.
> 
> Reviewed-by: SeongJae Park <sj@kernel.org>
> 
> 

Thanks SJ!

v3 had a separate flag during page vma mapped walk, so the walkers had to opt-in
with a flag, I removed that after David's review feedback

This change is required because we now support large folios in device private
and hence the DAMON changes are included in this patch

Balbir

