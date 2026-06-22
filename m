Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 04648CDB46F
	for <linux-mm@archiver.kernel.org>; Mon, 22 Jun 2026 15:20:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5088D6B0005; Mon, 22 Jun 2026 11:20:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 492606B008A; Mon, 22 Jun 2026 11:20:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 331F76B0092; Mon, 22 Jun 2026 11:20:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id EAFC76B0005
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 11:20:57 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 6A4951201E6
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 15:20:52 +0000 (UTC)
X-FDA: 84907911144.04.D4C5183
Received: from SA9PR02CU001.outbound.protection.outlook.com (mail-southcentralusazon11013028.outbound.protection.outlook.com [40.93.196.28])
	by imf19.hostedemail.com (Postfix) with ESMTP id 8923D1A0009
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 15:20:49 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=nuOFYMmf;
	spf=pass (imf19.hostedemail.com: domain of ziy@nvidia.com designates 40.93.196.28 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1782141649;
	b=xFLGTqrv95ISLslwBbJ1lrAp4vFON4KBbsKUMSKaFx+gkFyAcXELvHmwOxhJqLU/ZcwuAh
	89TpRfaqMviGL+/GNdBDYeytnYXjJW+JDEnGpHOYXnbTrBz98gh1R0G9jqcWK006jkndde
	CqvW8doVJIddI6dMhiJwwysISeoIT+Q=
ARC-Authentication-Results: i=2;
	imf19.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=nuOFYMmf;
	spf=pass (imf19.hostedemail.com: domain of ziy@nvidia.com designates 40.93.196.28 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782141649;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Zhv2sau2Ry8F9i1giwBH5fGy3zSM4peNZ7WWPSv7bIQ=;
	b=7/WNvoip5C7JQ5ZA2EM2J11VJNSA03P6Fs/GAxVtxOJxXQuuBArDv6xMWvs9CahpQrb5Qc
	7m3EhbiW1wVzbNrY3Oik+xAUBzN1B+pEts3GhRmv3/YTmtn10BtboFyAgSuGTA2QQ16OvQ
	mOs4HFhr6/+N7fhQZWW4ag7mSiMDgkU=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=pG7cPy+fmj9/wgE2XyeGqnkBaV8gZLB0qfRPBUMQo5c6o3gFRFg8Fwf4xSGgULTs2Vd7KfRuPIeoiQ8tJaUl9bEDvkAgYuSvwzjTRl2rv/D9Hda+HGy8/S1UzM5LCchq2hjBtqcEZDzQzKRwteiVkbDw/JggKFXb1WFDNM5FIofwfGGS8Vv/2J0PHLiRTENHb3a5Ch1q1RP0/PzFcakcefgOSDdyj8gntlr8cZFOU51TLNyLrnK3h8Bc4eCF2JgXAdVVZXP6ty3WTCiJrINq+tgj0BuDmnpkn0rEjwwzU8lwOxxdV6S2/3Kj6TsdpkqwW06TTUn6i1QxGWAEOrBJ6g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Zhv2sau2Ry8F9i1giwBH5fGy3zSM4peNZ7WWPSv7bIQ=;
 b=UtB6fW3i6CshkxDPPt8/xGRsdz9xLorRzn1KEe20NHiTN8ScHmPpoBHwPU2uNxAbdCARLBUHVVCPBsE1JIL+KF6Y0j59oRzioRL7r1rnS8uGh7BlmmhQJvorAVmaS7+I71WhmTAPyoDK0XqgtlNHNtoC/E/YIDSM6n8ckn0btd1c8VfbBz/pJKeBy+7aHuEUmVC/ZnTnUmqq/hKzkXm8dOmc3GvPDhDq7cEd9r/umkvG+aJ1MHEl6zU2vldPu0xmMybkTuYDGx+zIvl6fRt3auFQRe+VE/FfenIJTiD5EscI1rCvByVltg7bTot1YrCGXl+Due64GoukrDg+eaDS9g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Zhv2sau2Ry8F9i1giwBH5fGy3zSM4peNZ7WWPSv7bIQ=;
 b=nuOFYMmf8/R6Dj+oDSwgId0CQzNbVfEb1c5NMiTROaZ82IyD0RERuecTrXP+bvE+N3NL+HOTQmvoU+EEgW5UeDvYKBVJDHwKgbCcRvHpKaR247rlnZTCbp132LKgbeWBNl061SPvQV1EDr9rwlx2DqDb942+AHmFnKrwJ2m6FB77eGW15/I1pBormwK/v6TbYFvaFYbmNlz50L0dbPVWTQM6Ya9bQ26x92vk0oUFGQRDB4f9rH5QHMzfgfvm6gP780UN3vXHpZm0hxxy5ZT5SNv9jRZDTi+nxw5EO3v45hBiWpZT3G0fcOS9IVPDyvQW9aE/rVb2+iSdmxYYZKoxkQ==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by MW4PR12MB7000.namprd12.prod.outlook.com (2603:10b6:303:208::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.139.18; Mon, 22 Jun
 2026 15:20:43 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%5]) with mapi id 15.21.0139.018; Mon, 22 Jun 2026
 15:20:43 +0000
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Mon, 22 Jun 2026 11:20:40 -0400
Message-Id: <DJFOHJCQM9YS.23PHVLJ0FKUMD@nvidia.com>
Cc: "Miaohe Lin" <linmiaohe@huawei.com>, <harry.yoo@oracle.com>,
 <osalvador@suse.de>, <lorenzo.stoakes@oracle.com>, <jackmanb@google.com>,
 <hannes@cmpxchg.org>, <nao.horiguchi@gmail.com>, <david@kernel.org>,
 <william.roche@oracle.com>, <tony.luck@intel.com>,
 <wangkefeng.wang@huawei.com>, <jane.chu@oracle.com>,
 <akpm@linux-foundation.org>, <muchun.song@linux.dev>, <liam@infradead.org>,
 <rientjes@google.com>, <duenwen@google.com>, <jthoughton@google.com>,
 <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>, <vbabka@suse.cz>,
 <rppt@kernel.org>, <shuah@kernel.org>, <surenb@google.com>,
 <mhocko@suse.com>, <boudewijn@delta-utec.com>, <ljs@kernel.org>,
 <osalvador@kernel.org>, <willy@infradead.org>
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>, "Jiaqi Yan"
 <jiaqiyan@google.com>
From: "Zi Yan" <ziy@nvidia.com>
Subject: Re: [PATCH v5 1/4] mm/page_alloc: only free healthy pages in
 high-order has_hwpoisoned folio
X-Mailer: aerc 0.21.0
References: <20260531055829.3636554-1-jiaqiyan@google.com>
 <20260531055829.3636554-2-jiaqiyan@google.com>
 <84a0b176-8534-e03a-9e6e-400c74ddab0b@huawei.com>
 <45290F97-B8BD-4A9B-934E-0A122A5F3A80@nvidia.com>
 <CACw3F51hi1SAs264i0FKMbieOQhCpRQQ9s7gS_cHDYgHsqu0WQ@mail.gmail.com>
 <DJAY8RKHUO52.28U7OSO06U91J@nvidia.com>
 <db7d1c9d-3d73-4502-960c-9c2023b90471@kernel.org>
 <DJCAWX74LL8P.2AX46L7QCCWKV@nvidia.com>
 <CACw3F53jgq5JS+0qkC3Jmj-jkDRHm1H_Z=Xvv-jKoL5XHy11sg@mail.gmail.com>
 <c8ab2147-c6aa-480f-bfe2-55f095b55add@kernel.org>
In-Reply-To: <c8ab2147-c6aa-480f-bfe2-55f095b55add@kernel.org>
X-ClientProxiedBy: CH0PR03CA0098.namprd03.prod.outlook.com
 (2603:10b6:610:cd::13) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|MW4PR12MB7000:EE_
X-MS-Office365-Filtering-Correlation-Id: 95617d71-8c92-48d0-d8fc-08ded071d386
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|376014|7416014|1800799024|366016|56012099006|11063799006|4143699003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	yVJJN/W2Uee0HYYAKQym8LpPv0PtStqZb07E/FPow833AQQduRz6IJ2WyfC8ncAHsXGK5DEaweyBWg3SsS3cEAiz48imIV2ZuNhwqBmIxV6KEVmtMh2OClq0ozm/sqqp3j+Svdv0IW906GJuuFX9VqymivHYRja2fQVLpAUAZ8HQT9Uz6W/VRqa5gHzI0m6PpHOfEFlXXy0a5WYVePx0Gh96JPssTeThAnb2GQA83XhteK+DcimBzvTYDe4+tI3LqHaFH9LFyCrIp+DwOWOYqCoHDi1Y3bHgneuePOjUIiIOPjze4ewqHCGqePdW6J75Q6DJUaxwsVYYKY8gl0+u6oqJfngQq32+XoRwjHAp7G+gX9ovsB38cBh/mLJazZOVDN7RLZv5sGhtKWCC6pIg7vypth+cmPXXJd8EUvEYCIDAjwLQgTgGCYoAFItGnS0iaotNZxuIx3Gxb2ZNDW4J8Fx60pX7X0mtNqdXtoOrMjRhCVtXW/t4opvLuetQyom/yobcizz2H2Ox1cNiPolIv8ieC1AHvHias8yT1BItNgjvxtghnEb0hRdvl1JrOvQJ3Nju6YYKOQIFJoYjVjGhQJnvhM97Cr7+zPct0FRvphyeeSO1bKJkakfQGt43WJ7ZuG8M8lIvUWnH3NlK0/t/FCdPn5llhD1fqxR2Oaa/vKU=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(376014)(7416014)(1800799024)(366016)(56012099006)(11063799006)(4143699003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?V1lqbnhUWlBLZHBvN3FhUVNGQkdmYnFJQVlDZWNlUk9zdUowY0g4aVFkOGhW?=
 =?utf-8?B?ZFVFMndtUE5sNllVSFhKMS8vZmUwRDlFeHZlUVg0aElLUUJMSjlLZjZjZllX?=
 =?utf-8?B?UW1LQVRpZk0yWTZYRUlEZlRiRzdpSDRmdStNLzlkdXlEQVNibmY3Ry8yUWYr?=
 =?utf-8?B?VXZuWk1aVlBjUFo3VXdjM3loWUUzZGFQOHdqcXhLcUszTWxXYmlEbzE3QjdG?=
 =?utf-8?B?VE9sYXliYkVpdll1VlRyTWd3UTd1VmVybXI0RjA1OWNyQVYzQUptMmNDUlZL?=
 =?utf-8?B?Y0lNM2lrNXJoMkl3aFMvWXd4NVVJTVFRV3MvREZaUEVBRTZWRndhMXVvaU5s?=
 =?utf-8?B?anh5cWdJeUt4V1E2Tkw0ellPMmxRdWRxeGUwVS9PeWdDV1RKK2hmOU8xdjUv?=
 =?utf-8?B?OFkrS2E2anRnOS85QnR4MnlBMkRMSUpiRXJjRE5YZVFKZkk4aXNMQTdQalNw?=
 =?utf-8?B?VzJjOUEvaDluRDNqclkwSEJKYXF6V0Q2clp2Z0FRSk9yb05wSk9lWld4YXRL?=
 =?utf-8?B?SmxWek9ZOVhWaWtGMkRBenR3YzJqRUVmSlF0RjRxb1BrbWg2d2NtcE8zbWcv?=
 =?utf-8?B?Z2pBdDJ0U29tN0VBZFhvUjZuS3AwOUxIZWFsRDBnYmxRS2k0NDAya3didS9l?=
 =?utf-8?B?VGtZT3FnUWs5WC9hZWFENDBNNzFnWmJVSGdwSCsxaTVMU2hiQmhiTlJQSTRm?=
 =?utf-8?B?VzM2YmsyWWI0SEFCbUkzR1pJYUhiNkNLSHhRUTBJYWdMTGRGSFZSSVJzcVlt?=
 =?utf-8?B?dWVoY3BaWkxpSW9aSHdOeE1aT2YwZFlhS2JEYmRUTzdPSHg1NU9GMS9ZMEhW?=
 =?utf-8?B?aE5kL3k1QlVVQUE0MXpHb3F5RnBwUVBoM1dQTEczM1FmcUNXNUNrdWdNamV4?=
 =?utf-8?B?NWNhNnRiUVpheTI3amwwaFl2WStnbEV1MjZWdGRROFJFbW9IMWxWZmdRU29H?=
 =?utf-8?B?SGlyYXlSTDhkOUd6dE5wdTNmZjR6ZFl3bXh0QnFPaStQODNIdEN1QXBuUWV4?=
 =?utf-8?B?TVVESFV4d09mYUVkUmdUZ0c4SitHWGFYVklkVHNiSmtRa1prcjE3Qkd3aEtK?=
 =?utf-8?B?VExwU3BoUlFqSTJJRUdDalhyVGNNYVhxTTZrNVVTdUFqeTVnRUtYTWxIRlZH?=
 =?utf-8?B?R1Fxd1h5Wkh0TC9uQlhwZ2Ztdm5ac28rTzFFR0MvVkx0eEh0T2FRQzhzN2lB?=
 =?utf-8?B?RVpuZHYyUHh4YVQ0M1B5cTc4Y0crd09tRDRYRXhsNmJzaHd1R3QvendrV004?=
 =?utf-8?B?UU9tVmt4amVJRjgyVlFsWi8xNnl4RlM4OVFBL1czTWFPYS9MN3BaVGJyR0tB?=
 =?utf-8?B?VUs1NE80dW4wLytGc2RidGxhMTF1RDhYdFhETUJtQzVnNGdlV20yK2QwMzcr?=
 =?utf-8?B?OXFrWlk2Y2JxTWxqVzRYS3Fta2FoNzA3VjVhZ001Y0RKcWxGQWtnanRDSW1Q?=
 =?utf-8?B?VXlPMXlvaVl1MGxzaDltNTM5d2pzdWJTVUNBRDRxM3hLcWdDc1EzSmlxZUFP?=
 =?utf-8?B?cjNHdWFXdTNDOUlvR2htMnhQZXZhNGpyV3c0QW1xeUtsbU5iQTMvaGZGLzFt?=
 =?utf-8?B?WmhDU1lFTW9sYkhnMER1VVVIcjIzam84ekVnYTdiWXRPVWI5UzI5NGN5WVZ6?=
 =?utf-8?B?NkE0aVlnc09zb0VBbTUrVkQvSXZiQzNxVjhTNjcyekZRWU5yd0sxcGpPTHZm?=
 =?utf-8?B?bFUvemdUZHZPTFlzOGk5bFYvUjhxb3g4MjR0U3lFNFFpOVFKdFA2ZFRYRzhy?=
 =?utf-8?B?Z1E2YXBPY3dFRmtQMTZLZVFZYXBPYS91QmNHMFFFakIwTTNqcG03OS8vRlhs?=
 =?utf-8?B?V0ZGRCtqV0FPTWRqNlp1V0lnODVlSmtJUzZ4MSt2bWNVMkZYYTIrdU16UUll?=
 =?utf-8?B?elBVb3p0QWhCeEtzVUpXZ3BSU3htdlJBcTJCOFNDOFBIQmxwQkhETnA4UXV4?=
 =?utf-8?B?VjVsNFU3dlU2S0ZhbFdhemlpK2ExQTJNdHpTRlRnM0hmb1ROOXh6TkFTemJG?=
 =?utf-8?B?TW9URHRJYy9qRk9abVNPL28vNkFoMHRwQ1UxMDVJRU1UM1JDWGpLcXg0bjdP?=
 =?utf-8?B?Z2hUM1gySmw2cHRpOUVhVndRUlptaUNjUjIwUGFTVnR4OHAzQVBWaGJxdVdT?=
 =?utf-8?B?RGtYZG0zMnl3NVZFMHozSC9BdGpXbkVwWWNxQ3JEc2hybkNTZC9hNXIreEZv?=
 =?utf-8?B?dFJpYzdNV1FZdXB6V0wyK3JPaGhrQnM3aVdmSVFkNUdvQmQvSEdIcEVXQU5n?=
 =?utf-8?B?aG5wUklLbGFCSUk4ZDJENk1TL3hNQWxpOHdxcXBDUWhmR1g2S3hkRnNvOHZn?=
 =?utf-8?Q?KY/qG7hfXmCAO0DRx1?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 95617d71-8c92-48d0-d8fc-08ded071d386
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jun 2026 15:20:43.3432
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: e9bnl2P6CpHX4KhaHyLv65XxeStWMYWXpTHdPZWa9gtjx+SB1jKp0KwgIiAsZp8w
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB7000
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 8923D1A0009
X-Stat-Signature: kjop5a5kjj5jjp9yfypgwkgyhbscu48o
X-Rspam-User: 
X-HE-Tag: 1782141649-850814
X-HE-Meta: U2FsdGVkX1/Vs+9xBGbuX05XbZGmIpN6tqNueLpY2BlG3jEpGFPTxWY3XArdIcHUtNR/Yi7a3WIum3L8E1mSYDof1N4Q2hrfmHlp2P52QrVc2copc+qL1Vjxsbyan6mUAy/VCyVgoho/Sq3KWXTVeaxHY3aCG+cy5l1IWD6tV72UIbW2VZf3OLERpBLjhO1kuZq6TZVfjndzv3Pv76ukd/cGEydAFu3eHk6gahxHHYa7cns234hJXPYMuw6ml9IViDUwMY1GeHA9b0js6G+hKrtmtXlhHne1sBwpD8uYoDH66af8LV81c+iMM5TmaVEzLywzH47rHkIfYiBVANji60NwUtnB7/W/SwfMjzivWEitEbGdQb5tMZc95Otyor6OZ6ej287O6K/iORVyzES01FT3kUnoP1ZW7Y+lhH47KX9afgNIxJawgWtfzLrPTJ5xGXlaWyFyv5HSthy3EvPx8eTAvZutcrBpRsmiOYVoxZ3HgNYsJphLkRawnxqFTrwoJgf4WtT3IbrcwDitVe9uWogpqSiRKAnq9nGrf0mxEKqp5ke6me+6C6w27okL5IRDYXZ57KVulxxlnp7BhslVxOzQ/EVPx/sX5mSjqweVVbEsoBT4e0RUb51aWOu5eI4p23si6JueKNnW9Ekp5bgFumFDvXDLifDV3l2pkNra8PQnD42fWEZH0Jt620zajXcG5ZuMw09MndwqklHq5Sjp4uneX2WKD2AWZfIRDZkEj8ifeRNGwo9Q59ule6ARnMmSPY5b/ZPw0fv2dDf1Kb+DK1zdnHbT3STmHw8AHybDL0FezQKpK2IsuCvl4nVbn08qI2PJwdytxBh6v/tfuI15XkHTEhyuoc4qFyREbLgrukA1vycnvqJQK94K6Kwsk2+96Bp/T3gh/0NYR2NtTf+w5TtZBGuWMnYPmtgruExd9dMeySbO1Jr4MjfQUbB5QfDxv7RHwOdhHIHRz2ee5Tw
 eZc8+JLV
 kPXNpF/UTQB7kN4ZE+kKHN0B2juFk5PHG+wxUOxh8GC7KzRAPrUTIt5Sbiuo14nrgSprPNGXF5dI9CVn8VMJ4/AafgVrVD7gNAL3gKFVcdPRqnxRGfgXZr1CKhMlOntjFb8GUXr1ft7OjktFj4kJyjcv12UbBBiPTDl0d4jHYNlDUQpS23yTFdaJQ3Lf+I1HBS09Egvq8MX7I0v1XTMfSuRV5Qln1RI66qS7o/eIbmOtFie7Mn6vGHJJbM8ABEGbuD9DrzGRrqi6yZt3WcHyrYdw+hcsWpc4tHA8Afr1JYnIAzgAALM9BuTdiW7v0FlYhC0DOtjJVMyoXao4bxa4MK1rtcMoBqy1EnVaoo8AoHu3cyE9sPGGhxuVEeaz6ZMSIf2+D+vaEQz5aocGETQ55ueJXYJH9nuZI6eCRCK9kFqKPaT1z3GR3PWJBnNnIwpb78RMFCvPE9q0CYhn4jBFQtO4DBlO7rNJ+GeWi+fJs0X3Un3LMHPSRdngHccocP6V2TKma2qI6PAn9m1w=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon Jun 22, 2026 at 4:35 AM EDT, Vlastimil Babka (SUSE) wrote:
> On 6/22/26 03:13, Jiaqi Yan wrote:
>> On Thu, Jun 18, 2026 at 9:04=E2=80=AFAM Zi Yan <ziy@nvidia.com> wrote:
>>> >> when copy fails with EHWPOISON), the next list_add() is going to cau=
se
>>> >
>>> > I think we should fix compaction_free() (as a separate patch precedin=
g this
>>> > one) to not proceed if prepare returns false. It could in theory alre=
ady
>>> > happen before this patch due to a random memory corruption of struct =
page
>>> > causing some of the existing checks to fail.
>>>
>>> Something like below should do the job, plus
>>> Fixes: 733aea0b3a7bb ("mm/compaction: add support for >0 order folio me=
mory compaction.")
>>>
>>> diff --git a/mm/compaction.c b/mm/compaction.c
>>> index b776f35ad0200..b2104cbe63477 100644
>>> --- a/mm/compaction.c
>>> +++ b/mm/compaction.c
>>> @@ -1876,10 +1876,12 @@ static void compaction_free(struct folio *dst, =
unsigned long data)
>>>         struct page *page =3D &dst->page;
>>>
>>>         if (folio_put_testzero(dst)) {
>>> -               free_pages_prepare(page, order);
>>> +               if (!free_pages_prepare(page, order))
>>=20
>> ... for other cases that free_pages_prepare() fails, this is
>> absolutely necessary for correctness. Do you mind sending it out for
>> formal review (I will be happy to help review).
>
> I think it would be faster if you just added it to your series with a
> Suggested-by: or something? Unless Zi objects. The change is straightforw=
ard.

Let me send it as a hotfix separately, since Andrew prefers to have a
standalone hotfix to avoid splitting a series.

>
> I'd perhaps do just a
>
> if (folio_put_testzero(dst) && free_pages_prepare(page, order))
>
> to avoid the goto?

Will do.
>
>>> +                       goto skip;
>>>                 list_add(&dst->lru, &cc->freepages[order]);
>>>                 cc->nr_freepages +=3D 1 << order;
>>>         }
>>> +skip:
>>>         cc->nr_migratepages +=3D 1 << order;
>>>         /*
>>>          * someone else has referenced the page, we cannot take it back=
 to our
>
> Maybe in the comment here add also the possibility that _prepare failed()=
.

Sure.
>
>>>
>>> >
>>> >> trouble. Or you can rename the function to
>>> >> __free_pages_prepare_and_free_has_hwpoison()? At least, caller knows=
 the
>>> >> potential side effect.
>>> >
>>> > Uh that's long. All callers are from PAGE ALLOCATOR mm-subsystem, it'=
s not a
>>> > driver API so we'll know what we're doing (famous last words :)
>>>
>>> The name above is a half joke. :)
>>>
>>> BTW, I do not even trust myself sometimes. ;) Just look at the
>>> compaction_free() issue I introduced myself. But I do not want to be to=
o
>>> pedantic here. So a comment above __free_pages_prepare() should be
>>> sufficient.
>>=20
>> There is already a comment about the possible freeing case.
>>=20
>>>
>>> --
>>> Best Regards,
>>> Yan, Zi
>>>




--=20
Best Regards,
Yan, Zi


