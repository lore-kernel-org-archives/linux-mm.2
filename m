Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3AD1DC44500
	for <linux-mm@archiver.kernel.org>; Thu, 22 Jan 2026 12:26:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 29E456B017B; Thu, 22 Jan 2026 07:26:31 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2760E6B017C; Thu, 22 Jan 2026 07:26:31 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 14ED36B017D; Thu, 22 Jan 2026 07:26:31 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 023646B017B
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 07:26:30 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 606A31602A6
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 12:26:30 +0000 (UTC)
X-FDA: 84359522940.15.E3F896D
Received: from BL0PR03CU003.outbound.protection.outlook.com (mail-eastusazon11012018.outbound.protection.outlook.com [52.101.53.18])
	by imf21.hostedemail.com (Postfix) with ESMTP id 6C43F1C0004
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 12:26:27 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=S5C9Ry6X;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf21.hostedemail.com: domain of shivankg@amd.com designates 52.101.53.18 as permitted sender) smtp.mailfrom=shivankg@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769084787;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Qi+dOaYG7gcjIEmGRGPGjEIw25xbz3schHoMdN0WIWk=;
	b=c7Zv9DR1IHL2fUdjMdPiG0tTHHpkD+Mz93NQ5R1lVj8WM+ivwOHc4t5N5Q7/dvnhMy2pCk
	tqh+jZ7zrSKW0Ur+fszoyHx7xToWfnopij2BP0PWeOD1HycyAeAk2ZjLw8bRHpd9WFBmt2
	D3JqeCF1NYQEPkecOStMtNDwYbvsdec=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1769084787; a=rsa-sha256;
	cv=pass;
	b=RKCOzQOnlarD/Ey5xzxod3gWBO9lR/IpRpxmVGgxWJw62HRLJ1hMz5M/w1UzX7poja5Pnp
	ZOfAYB179FeAU0jTj4b0ktptiyonm2rMU6oXyzyAwehbNG4o3Rq8e8rS4i1Vaz7u1NmW4s
	TLi60M7axMxMHNsH2uLa7lkGE8U+7gM=
ARC-Authentication-Results: i=2;
	imf21.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=S5C9Ry6X;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf21.hostedemail.com: domain of shivankg@amd.com designates 52.101.53.18 as permitted sender) smtp.mailfrom=shivankg@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=QmD/PX+he9F0qd5LFnspnTfKZP79fSikFNRo1nVohXjDrtYmlrTuku37OMBIlXgMPrigTfDniU2Dc2bFejMjasCQVHSjcta4FYD9PXB6mpYj9bc+OzeVrnR0+lNOivvuh4Ezm5Jjm9JGeCYaBrlcSB3mzsq3K0DQhrY01WKqE+jXhPpM3vrwKKxpAGRih9vqVuJduXZWUYBFB5Qr+y9fx7Os39TOAuxJAus724aEPQvcuOizDizqhB/5s/+w3/2fm/HosTWHfuLqA4E6Dv1I+JYcNChGbxWjun5HFpYR10Y6yKbIX2VqbgLBlKZQ888un+2FW7xinA8JCz7LOGIB6Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Qi+dOaYG7gcjIEmGRGPGjEIw25xbz3schHoMdN0WIWk=;
 b=XVvBMwOc88+SKngOVf8YTh7qf3RauEPj+Rr6GoHT5IdNH0YwYJoVaQ5C5VgKHxg6oNEloaQbjAhW+hHClM4Rlktt37zh1PUzyOG5EbSHbko0uE7+pNjYA6hbeIDjuJpuOSrm9NSf2lR/94IRlXgw7qf7W9HIB6EIzxNxeoviDSoW1Vk+bH5vK+4lcR56fGliIKV6ndkdmseJBsnGLYbQTjR9fHP6VAdVDDAGx90cOG/notVHsiJ05EpkZ277DDdGAJXoLTCldsiUQBRS9xeJWhQnGGcjLKv9YIX6KZ50K2nPGzKm7Mw8nVV8otpdrEXX72ZSbEnTCrrFohQBIzh48g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Qi+dOaYG7gcjIEmGRGPGjEIw25xbz3schHoMdN0WIWk=;
 b=S5C9Ry6X8i1154EhvNpv8Z9nc7qFvpQH4x5pWpo0MwYEnvOxVwEHmqaCKpM1st/s8o0YQRGwP/pdDq7AH1hTgjMe22pUd/l2v8kMKH8R1uwngDzEazDvG0DnydeAPlb6K9bWN3Bt4nmdCDh03QDxnkI49LBmCKF4bhN69fmaRD0=
Received: from SJ0PR12MB7458.namprd12.prod.outlook.com (2603:10b6:a03:48d::13)
 by IA1PR12MB9740.namprd12.prod.outlook.com (2603:10b6:208:465::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9542.10; Thu, 22 Jan
 2026 12:26:25 +0000
Received: from SJ0PR12MB7458.namprd12.prod.outlook.com
 ([fe80::83e7:e6cf:26ed:2f3d]) by SJ0PR12MB7458.namprd12.prod.outlook.com
 ([fe80::83e7:e6cf:26ed:2f3d%6]) with mapi id 15.20.9542.009; Thu, 22 Jan 2026
 12:26:25 +0000
Message-ID: <7193b89e-ac2d-47c9-8fa5-68e35c57d4b6@amd.com>
Date: Thu, 22 Jan 2026 17:56:17 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V3 2/5] mm/khugepaged: count small VMAs towards scan limit
To: Lance Yang <lance.yang@linux.dev>, Dev Jain <dev.jain@arm.com>
Cc: Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>, Nico Pache
 <npache@redhat.com>, David Hildenbrand <david@kernel.org>,
 Ryan Roberts <ryan.roberts@arm.com>, Barry Song <baohua@kernel.org>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Wei Yang <richard.weiyang@gmail.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Andrew Morton <akpm@linux-foundation.org>
References: <20260118192253.9263-4-shivankg@amd.com>
 <20260118192253.9263-8-shivankg@amd.com>
 <829b62c8-e3eb-485f-8d7b-01419c841cc8@arm.com>
 <d9d569cc-127c-41f8-b16d-d6e11ba7b43a@linux.dev>
Content-Language: en-US
From: "Garg, Shivank" <shivankg@amd.com>
In-Reply-To: <d9d569cc-127c-41f8-b16d-d6e11ba7b43a@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: PN2PR01CA0027.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:25::32) To SJ0PR12MB7458.namprd12.prod.outlook.com
 (2603:10b6:a03:48d::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ0PR12MB7458:EE_|IA1PR12MB9740:EE_
X-MS-Office365-Filtering-Correlation-Id: f24679c3-5058-48eb-6bd5-08de59b175ae
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|7416014|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?Tk9UQnVmYm1mYnRPdExlTy9vVC8rNmdpaXk0cU8rd3VuV0g4Z1gyTStMUkhS?=
 =?utf-8?B?MWlDbmdGTGsxU2ZDbVJ1eC95YUZudS84bEhPNVIyT2FtQzdyTndtbWJySVUz?=
 =?utf-8?B?VHJ3NzMwWTJ4Y25RR0p6YTBhS2NFcUlweXhFQ1VGTEh3TFpPV0U4c2sxdzNS?=
 =?utf-8?B?VkhqeVZ5NE91bGxQajBzd0FHOExOY2UrT3puMTRGVnQ2cWRlQUpNZG51VENJ?=
 =?utf-8?B?Q0JPVSt6eWd3M05Ea0lYT0pwdDRIK1lhNlBpc1libVdBTmtRb3ZGVDViaitz?=
 =?utf-8?B?d2dIUEFxQ0RuNVZSS1lFTDVGK1B6OVBNc3pCZW84SUdWU2lKcDM2cDJ6Q2l5?=
 =?utf-8?B?YTExeXJGYlRIeUh5di9Bd05YdzlVVGhLZ1VzbFdjUUhuZDA4cXV5Tkwyenpo?=
 =?utf-8?B?L1Q4ZEJKQzdzamFzY09IZEtOYWVzTkhsallpUVZ1aVJCVmg4WitvN0N5cCtB?=
 =?utf-8?B?MXNBV2R2L3BJVWJTdFBuVGpRM2R2a0JCcXJIZ3JQN2NJcXBXOGJFUkMrSXlJ?=
 =?utf-8?B?cURrYlAxd00vVWdQcWwxT1NKVnRxelAvVnpUNU5BODY4NFZjc3VYejE0V3ZK?=
 =?utf-8?B?Lzlvd0FZcGU3VlJNSzdBdmxCMzBRUHNsYVMvMFgzMm53cGdMSjd3OWo2Y3Nu?=
 =?utf-8?B?eGUyYjREMFZ0NWRsWHh0bUtqSjYxeXBYOHE1RmFVOVpqSXRKOGk3WmY0Uzha?=
 =?utf-8?B?NDVqbVlLcnkyZ1FRMHVnODZtWU04dG9mNDJZVVJWOWRpSTQ5N2REKzRwSlFk?=
 =?utf-8?B?YlVaTlpiOTZWMU9NdUVZaU1yOW9WMmxCSlhaTVBqOUtqNTJCTkhkZEQwU3Ew?=
 =?utf-8?B?U3ZKZzlJYUJNZkRxbG5yVlBsUDl1WGZ0bDRhdFdHS1g4MjhtWGZWbU45ODVK?=
 =?utf-8?B?bzVTRDBJdWdoYnZWQ3hGNENaVVJ6M1B6bGwveEZyaHBGNmF0WGMrOUlmaXBI?=
 =?utf-8?B?L0dJaUdRRkpmYWhrNUhPclhjazVyZmZDUzJiUkNoTmtaQUFReEdhVFVJb2p3?=
 =?utf-8?B?WDhJS2ttK05mSDVhN1poaXlVTXlWRExCWi9SODI1bEtESDZ1VWNZcUxBeU1j?=
 =?utf-8?B?TzhMY2F4MkdtQWNySlpBYWJQcERTcGcxZkFWbEs0YXd4cmhVaUhrL0ZNRGMz?=
 =?utf-8?B?WTkwS3NiWTlMbnI3R1ZtdVBHQlo5VnY4eDRNd0lvNGVPVmJVMXVrVWJjWVVZ?=
 =?utf-8?B?emt5MEJSVTIrVVYwNGhYaWpENHBITzR6U0J6UU9xUVVSZUZyeHp5TDlWcElo?=
 =?utf-8?B?TSs1N0s1U1BqQXBQT2l2MUdlc1h1YldPeU12L3RIQ2N6clJpTUFYa2taaDU1?=
 =?utf-8?B?amN0OEYwWXlYUnU4S0tnblR6QlhMQU1SMk5Lb1NnZVNlK2pTbDFpQVFUemhE?=
 =?utf-8?B?VkxEYi8rT1lIM09CYUtQMUVDdDFYV2FISUo1cHBwV2Zhejc1L0VQSE5XMEpr?=
 =?utf-8?B?SFA3K3ZDb1M2MWNtVEdFVjJ0eExuNnlrb2I2MUlPODVVZm1yOE11cThIaHlV?=
 =?utf-8?B?cnhSRGFxcHc5dmFuTS9JNnpQemhCb2t0a2RmcitnNEhMOUdCcVRSWi9YV2Y4?=
 =?utf-8?B?MkpldXpiNzBlQmNla1ZraENqYTZqSFNXbVRCQmQ4ZUZxZk5jTmxVbXI4Mzl4?=
 =?utf-8?B?eTFwdXg3NnlQUUxRdS82bmFRRExZakJmQzdpMTlzZ2hxYjEvUks3WnRJWk12?=
 =?utf-8?B?NkwvVmhJWFhWWm0rOTB0VnI0UU5Ia1RYRFFGUnZudlMxa05UK1FOV1B6eGhE?=
 =?utf-8?B?RytqK3U2ODZuTWdleXBCcDc5RmM1eCtMQkdjelpjb09mTHdzVkVsSEpUS1F2?=
 =?utf-8?B?Uk5xU0NvTFBQUVpLc2xhTjBBZW5Oc0hlZ2tIYzg3R2pXV0FvVndNWmF0akpa?=
 =?utf-8?B?Z2pldjI1dlFiSkVtOHBiZS9hUzZxVW5KL2FXQzI0alBFcUt4bVhjQUxsSW12?=
 =?utf-8?B?STJmRTBtVGREVkdnVWlDd0M5UW1CK2tPWForQWRnQ1VqTE5YV2poMHc1ZDhP?=
 =?utf-8?B?YWU3WmFBeTdxZ3pDUXRPb1BGbitnY09lSDB1ZnFpV0JoL0pBSlFVWUNTdURj?=
 =?utf-8?B?NFZtdjlNUlJZdU5RaG9wVzQ0WGJlcmREM3pINTJuc3c1ckliY0xoYThYN2Ez?=
 =?utf-8?Q?cWMA=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR12MB7458.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?UkZoT0oyNFU2Y1FKMm8yVnREejhCVWtjSFl4a042TndLT1UySnJOVm50Wis1?=
 =?utf-8?B?Zk9ZWk55UThpdFc5OWRTQk8reGt5T2pJajhsOHFwTzZpQ093WktCdkp0a0x1?=
 =?utf-8?B?a0E2cWZIZTVXYU1ZYlNHeUtzWmZ5WW85Q05VWFVZTXl1aUpLVG1pU3BwTW1u?=
 =?utf-8?B?SCtuV3U4WEVNcEdTS2JRK2JKY1RLTjd6bWYra2k2TGVKN1MvNUh6L2ZiNm9m?=
 =?utf-8?B?dDV1M05OOU0yQjBKMENXUXBFWmpFVVcvMnN3YVoxaUVueVQrWFoydjgzVzFt?=
 =?utf-8?B?VkpCQlVLTlZOZGNlem1XMnl4NjM2WHhiZWl1bDhmUHMxd2FLZFV1REN2SURm?=
 =?utf-8?B?VEZoTXBONHBnU1NCV3JySXpDYStzVlA0RzFsMzJOQ2hkVFNjbzR2QlpMWEJr?=
 =?utf-8?B?NHRqdUtHdTZjdEFCck9rcWM3VmNjZjROcXZCUVgrZUxNL2YvdjBpSmN1ZXd3?=
 =?utf-8?B?MEpldkFOMlJEZUR1ZitUK1NlenNTbVdWNlA4UERQSDkyak1wYStFL2dPanRH?=
 =?utf-8?B?Nm9pSEtUbFhqbUZLUUR6T1RwSVVEb3JhaFM0ZGNiQkdQT2loeWV1eUVsVklq?=
 =?utf-8?B?SGdZL1Z4T2dRdFcrMmhXUWpmMXRCaDZycWJFTS9tdjliREYrZUZYeWhQOW5B?=
 =?utf-8?B?UjdNOG5XV2lzVjFkS1dEQnE2MFcrU2NnOXZtbGJEY2RFSWtvbXBlNGVBNVlT?=
 =?utf-8?B?WkxXUzN6RDA3eUkxSjR4T1d0MW8xd3J1N1Ywa1ErR2VGMHFqejEvc01RY3Vv?=
 =?utf-8?B?ZGFXa25vdGtib2thWDdGdnNja2RpSDdXeXJsUUN5aEdSQ0hIbTBWWjZ3RSsy?=
 =?utf-8?B?UzQxUnpiMFpMNWhVT2RFaFRqQkxkWlhCYXZGWmVxa2cyQ0lxb0ZiMEc2c2pD?=
 =?utf-8?B?TURFSmhqU3FnOWZJeHRWTC9TdHdpSVNYQmY3V3o1MjJka2FlMThQWWZrWUND?=
 =?utf-8?B?Q0Y0YkRHamp3OHFXWksxVThiSU9NUHBLZzFISHZaY09Ga3RTS3hURytyRW1B?=
 =?utf-8?B?Q0xacmx4bHgrMjdSV3JqbXNxYkJMUXYwM25rdnRJNStWYkpNSWJKWHR0KzJ1?=
 =?utf-8?B?RXMvZGsyeGlKYnJPb3hFYk9UUWg1Y2FGbEt6Wnd4ME9NK1FQR21xWjdlSTdW?=
 =?utf-8?B?Y0xucndhYUpPQm85VENZekpXdUR0QmRwTzM0VmIxNFNEQmQvUzVieFcvQnBi?=
 =?utf-8?B?RHd2elR4Yk5qeS9ENmpXZk1aK1RtLzl3K0o5QVZhN3Vaek9hekVoSy9mUzNh?=
 =?utf-8?B?UjZOb0F3MWYvWDNrOHVPbGo4RFUxY29XUi9hYlY5c0M4L1JhMFF2MFBTYlZX?=
 =?utf-8?B?YWNQWnJhWWZJbWpHWjB1VmVZYXZwU1ZMR2JlZ1cxeWYyNXp0U0VmWjYrT3FR?=
 =?utf-8?B?OHcxYjUvbzZ5cGhQcDQ2WmRDWUQ0ODZJUElZcXptejlrWmhWWThMcUlBaENY?=
 =?utf-8?B?aUwxTlUvRDdJUTNlOHAyQndkcVFzWnRtcENKMlN5UGFpT2xoZkQvTHB2T1FP?=
 =?utf-8?B?dGRvTVFqTCtlZXpvVmFBaEU5K1BKWVRQdDBKdnFhOW1XTytaWVhEUW14ZjBJ?=
 =?utf-8?B?Z2lNQ29Xbnc4U1JJRk11YUg0cXpiNEM3cDlCdnQ3S2EweFZ0aHFWOXpMYWFz?=
 =?utf-8?B?QnRjOXhIdEthS2RrMTdzcnZjdjV3WXBXL1dNTVRVNDBNVW1uNk05WnVPTmNB?=
 =?utf-8?B?ZzJSdHppOW9FczNPb3dzbjJlbEFPc3ZpRjZMd1pudW1UeFIzK1pRMTlxNlBo?=
 =?utf-8?B?a2lUSWtoWXc2TEpBanBSaFpMdjFxYWlUVFlRWEVxc0tZVUE4MEhFTm9DK0Rs?=
 =?utf-8?B?U0k5dlhIS2UvM0xwVWRXWkgzTHh6cFA3VFV4WmFTZ3pkYmhBVGloeFlTVkdV?=
 =?utf-8?B?YmlLYXJRL0I5UGhhSGx4WGNvcGMzTCtyMVc1REtCc2Fya0Y5ZjI2MkJHY294?=
 =?utf-8?B?bllab1p0cVY3bExFTjQwc2tBdGpJTyt3RmV5WXZnRTJhS2dNQ2k5end4TWxh?=
 =?utf-8?B?OWFTWmZLYWpEakd5UXdmVUE2RzR1NkVBVFJsMjJKZVh6eGxWWWhzMTZoSjNv?=
 =?utf-8?B?VFpmQUxRbEJuV2hFbUhxanA1VlNwbE5lV0lJaXVxQnlhUjVpTEFKVkM4OVda?=
 =?utf-8?B?WUdMT09JYmpMT2M2TktNYVJqTythL08zWlZheXRkZ3Z2aUNzRXh3TWVQVVBv?=
 =?utf-8?B?amhlNDJ2N2N5UTZOZTBWUkMyUGpjYTY0UXMwaHBOWmhTY3pZUXJFdExnUDhp?=
 =?utf-8?B?dzBhREJLRXRCRFZ1TjJwVjRaZGRZNEtoQjNMOTlmL1dpRjMvS2NWVjRlUGhr?=
 =?utf-8?B?MkZmZlFQMnFwSXg2MzFuc29paFNXdHpKSDJlc1k5ZUtSZTZwTDlPUT09?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f24679c3-5058-48eb-6bd5-08de59b175ae
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR12MB7458.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jan 2026 12:26:25.3223
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FtsDhUvHSPkV4nRX+QSGjNMJTy0D60yMPlPohIjqgefvD7WJG9zaF2PisU6DQRin1BegnRjoaCRwmUWfRLs4Zg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB9740
X-Rspamd-Queue-Id: 6C43F1C0004
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: s656u3156h87zk9j5skjxjwtd4pwfqw9
X-HE-Tag: 1769084787-244588
X-HE-Meta: U2FsdGVkX199f9qUJH8fz797vpDLY/qJG5ApW2SBtIJpEMVUT5K+altAALrI0QmlGDzy4BtWWz0bwqfoU3r35bzs3sP3i/BjvSzJnSOl/uKvwhenpClstARevgwEE8GgO40EjNldHE/6rx9nG54Bi7rx5EW+b0NOy12rAHlCPLxTuB7Eh/rtT9US1Ov02qWEtwT2tx9ddIVgQH4lVZbmfmtj4DFQG2h10OrXdRDVv8l7vlIZviP/0MVpD5K4qKM7AzgZm0VyurDqypeoAKTD65gQrAeJA1mvyaTKrjgQwbXP8mM/KXIoB+QpMQyjY6cqmUlhGfnmvn5IKO83MIj9pMKfSbYcqcVznZs2jbOK5AtumT62qckLBge7+EY6WichlplxnY5a65kCoJ2GASSmM5WOko2k1aNyEKOo7V6vOhItnnyuvSxPkbfTJQYKF1qPhYVfeQBB1ZFZ3Xo+JICvjyWp/oJVY1xvDOj28IGUsMtwypkAHpcPy4YXTXtKZBhO/G7CKML0KSHqGbamF+TQXa2R9suQpxVQRTo4j9SNtT+N2j+WTDMzBvVmb4y/WTAWzLF+biYNcAmBlqV8/fhEAdzFJu0AcVr9NUQ8lFYGXiE4KonrwN7r/ceD6Bm9BRNLHoA90aVkKd0YqHRivQDl133H7CBPV9/asx7LPx18oXV7v//7RLXNYYKY95O/qt8ipyepfsQr0GjC3w3jat8Lf7wSbDEbJ2iOigafblBVCRDPVTTMK6+xWvPFY6/HOnBXDwQ15/yZFS0+phxVjvfPRk+Md+4F4cZHi7rR5RjIeLH/RjQyV66VSXHBXPUSu4uh5KMD7U9aaihdf8VUdr1xuB56Efd3C2PcGEw/Dz8VZOoU7PxJ9DikD4LqzHQLGIviTBKN+6pGr5ejN7peCvGu2Yh5uVLXSvoDmh7RTZba9S4id8RBlW93mhiBEZyEMFjH5K/yOl5veE4GWhdb6Tb
 NDykD2zL
 ncviGIjg/85kXammszbDia3JbP4HfoCRFO5U/AYSJe+L6yYBh6MeaF49/lgML990s38ZazPzmpeYJ8/PZ71sZ6Mo8G+KOjpSAfaehwsI8ShIrNB7+rCCmoBYPU0FYvjqphoGSvKloerFLxitd9j3RlvKJRnTdkfcwhdVhq0reop67BkVOcNNjt6DlOLVljoXE198iD1KTm1LjUbz5b9oVmA0p7GT+RV41KynGSJeCLad74Wx5J9AwLsP2Wa4y0VEhB89JM2IhtKRg0N4IXsqxHBWFIzUNncCVd8YzSCeTi7gE3HOwMsO1JpHj80swZOulAo67n60KabdiSKca2FRyyoCTbZMskX3Oq44I3mAwvjtRhJwzz0PBBajQV1VTCnvk59aFFnu4dYps99LruAP+1fkYQjg5lVd32Hn6Q1hSYXmvXsBCe4GzLxIiwnN8HHxa45XmnhFdm4S4RGBUkvrsrgXwS8J+9gaXgQAgeqVACBynetdTpRT4Ri/s76zrz8nz5KLU
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 1/22/2026 2:14 PM, Lance Yang wrote:
> 
> 
> On 2026/1/22 15:32, Dev Jain wrote:
>>
>> On 19/01/26 12:52 am, Shivank Garg wrote:
>>> The khugepaged_scan_mm_slot() uses a 'progress' counter to limit the
>>> amount of work performed and consists of three components:
>>> 1. Transitioning to a new mm (+1).
>>> 2. Skipping an unsuitable VMA (+1).
>>> 3. Scanning a PMD-sized range (+HPAGE_PMD_NR).
>>>
>>> Consider a 1MB VMA sitting between two 2MB alignment boundaries:
>>>
>>>       vma1       vma2   vma3
>>>      +----------+------+----------+
>>>      |2M        |1M    |2M        |
>>>      +----------+------+----------+
>>>                 ^      ^
>>>                 start  end
>>>                 ^
>>>            hstart,hend
>>
>> Won't such a VMA be skipped by thp_vma_allowable_order()? That internally
>> checks, apart from eligibility by sysfs, that the extent of the VMA can
>> map a hugepage.
> 
> Ah, you're right!
> 
> I was worrying about a case that doesn't actually happen.
> 
You're right, thp_vma_allowable_order() is taking care of this, making 
hend <= hstart check redundant.

Thank you for catching this.

I'll drop this change and send revision keeping only the unsigned int type 
change for 'progress'.

Thanks,
Shivank

