Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 97542CD98DA
	for <linux-mm@archiver.kernel.org>; Mon, 15 Jun 2026 09:19:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B916C6B008C; Mon, 15 Jun 2026 05:19:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B1AC66B0092; Mon, 15 Jun 2026 05:19:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 994F16B0093; Mon, 15 Jun 2026 05:19:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 823CB6B008C
	for <linux-mm@kvack.org>; Mon, 15 Jun 2026 05:19:21 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 2091E4098C
	for <linux-mm@kvack.org>; Mon, 15 Jun 2026 09:19:21 +0000 (UTC)
X-FDA: 84881598522.09.511E599
Received: from SN4PR0501CU005.outbound.protection.outlook.com (mail-southcentralusazon11011000.outbound.protection.outlook.com [40.93.194.0])
	by imf28.hostedemail.com (Postfix) with ESMTP id 11103C000D
	for <linux-mm@kvack.org>; Mon, 15 Jun 2026 09:19:17 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b="cE/nXaO7";
	spf=pass (imf28.hostedemail.com: domain of Pankaj.Gupta@amd.com designates 40.93.194.0 as permitted sender) smtp.mailfrom=Pankaj.Gupta@amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=quarantine) header.from=amd.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1781515158;
	b=FiyWzpH6cmRrZMQ7nMFmjOhNDN08GFNq6pk+fIfa9uQTEGK+Qset2IgdXvV7MR98Ur7pae
	818iAuli4WPoqZ8vi9sQPkgrDZfFVK7Za7jKe2x7v+HgemqJogA9uNNWW60XhvdIo0FbZf
	b3EIYLdErwsu0oUGniFrZENZfsdOXNU=
ARC-Authentication-Results: i=2;
	imf28.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b="cE/nXaO7";
	spf=pass (imf28.hostedemail.com: domain of Pankaj.Gupta@amd.com designates 40.93.194.0 as permitted sender) smtp.mailfrom=Pankaj.Gupta@amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=quarantine) header.from=amd.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781515158;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BIVILeEDjDV5j/zmD6ZlHFukm8DbXC0WNdBMTnVFdBY=;
	b=QzoHQYDvBCtNr8D5tRwEnwHJA0TeujPiirMOdlwcmmSuY5ZRqX3pf2qgg8XvqDmKIFzjua
	AJ3lSVdpg4OsYVR+/3Bvo/21W86Zsg8OT7Y54wF29GyETRiDsO8lj+8ZDMaKdi2fjmVyB9
	1BmnGp09WI2zN/Y5pfrUMQtW3iYbVc0=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=CUlvNgRTcFpDSZ7VhRSH4ntbSzgiKTIRnqVm/YammoE0bHDx6Ct3dv8lhuyaJQ3D11Dfp7A6sVYRRLHz+vQAnI5Fl0zWQZFyV/tidvCVwMvzmw587tCalesvXTAl9S2KCxSCFMy8hp7uAUkdNsrf6H+juyWC4j1+kOrhMaxcmsPMdgI28E/xrAkQMKFE8PBEYcY6ZjTNlbhrfdgdP6z4X6SH3rFH5LSgytHMVLKjFxsbpDYbiBTTYmatblfjCRlbcmSps+T5kAMDtRr6L0T/vJQHTAlEcu4a4Z6+P2Y3TdZcfPZjGFnUnw17D05FMyDI/0N2Jrlxf/bT+3oCzE5VAQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BIVILeEDjDV5j/zmD6ZlHFukm8DbXC0WNdBMTnVFdBY=;
 b=N7bHXZrpB3ChECXh/rE3gnYrHzAisWnhu5s1mPlXP2cdczGjH3usU4f2eV5kP8aJZtPZdiqB1a1gefw8ao4Rnm5vLKm0RVMtdn80Ymb6QZDvg6lQhZe58dsLYFXpFqY6eJ+nHy1EVy4QlOcYNpwVB0pdd1al9ubEruuwVmZQJFGSFVl7cRwfjEGYN44L280i9Mwb+szgDxUhGlTi5IFDIEW5nVuVoXxYgjBqe4u+LluqOgA778hOiUl7oHz/pe7WzKe2kHKemjNOdG26OX8ZISZ9BYn+/HJj4AAfy5Qop8NZ7IDoh8olPcbOUoyvrjCR6fJsb//l20SEjyn8fwVqaQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BIVILeEDjDV5j/zmD6ZlHFukm8DbXC0WNdBMTnVFdBY=;
 b=cE/nXaO7Pz+iVU2Zv2kMrP+8L0C8YftdspoGIhXUZnpRP5M1dAlFO6duJUcAsiN6QgV9mrCS/uC+2rVvn6YXDMBr0aR1vi0A3T04YYpfzUCm4JFCtaW6N5LvSb0BPWVwUviMbkS1wcXS2FhQLcXkfzGhhjYbSksjYyIZEZYoWOU=
Received: from CY8PR12MB7433.namprd12.prod.outlook.com (2603:10b6:930:53::22)
 by PH8PR12MB7302.namprd12.prod.outlook.com (2603:10b6:510:221::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.113.18; Mon, 15 Jun
 2026 09:19:13 +0000
Received: from CY8PR12MB7433.namprd12.prod.outlook.com
 ([fe80::faae:d638:bdc9:4bf6]) by CY8PR12MB7433.namprd12.prod.outlook.com
 ([fe80::faae:d638:bdc9:4bf6%3]) with mapi id 15.21.0113.015; Mon, 15 Jun 2026
 09:19:12 +0000
Message-ID: <44c996b7-e95c-4a9e-99fe-4f66aa21279e@amd.com>
Date: Mon, 15 Jun 2026 11:18:58 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] mm: page_reporting: allow driver to set batch capacity
To: "Michael S. Tsirkin" <mst@redhat.com>, linux-kernel@vger.kernel.org
Cc: Miaohe Lin <linmiaohe@huawei.com>,
 "David Hildenbrand (Arm)" <david@kernel.org>,
 Jason Wang <jasowang@redhat.com>, Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
 Eugenio Perez <eperezma@redhat.com>, Muchun Song <muchun.song@linux.dev>,
 Oscar Salvador <osalvador@suse.de>, Andrew Morton
 <akpm@linux-foundation.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Brendan Jackman <jackmanb@google.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Hugh Dickins <hughd@google.com>, Matthew Brost <matthew.brost@intel.com>,
 Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
 Byungchul Park <byungchul@sk.com>, Gregory Price <gourry@gourry.net>,
 Ying Huang <ying.huang@linux.alibaba.com>,
 Alistair Popple <apopple@nvidia.com>, Christoph Lameter <cl@gentwo.org>,
 David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>, Harry Yoo <harry.yoo@oracle.com>,
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>,
 Wei Xu <weixugc@google.com>, Chris Li <chrisl@kernel.org>,
 Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>,
 Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>,
 virtualization@lists.linux.dev, linux-mm@kvack.org,
 Andrea Arcangeli <aarcange@redhat.com>,
 Naoya Horiguchi <nao.horiguchi@gmail.com>,
 Alexander Duyck <alexander.h.duyck@linux.intel.com>
References: <cb43adc61d2ed3069b2fe428f3e051dbdc4cc28d.1781097156.git.mst@redhat.com>
Content-Language: en-US
From: "Gupta, Pankaj" <pankaj.gupta@amd.com>
In-Reply-To: <cb43adc61d2ed3069b2fe428f3e051dbdc4cc28d.1781097156.git.mst@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR0P281CA0001.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:15::6) To CY8PR12MB7433.namprd12.prod.outlook.com
 (2603:10b6:930:53::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY8PR12MB7433:EE_|PH8PR12MB7302:EE_
X-MS-Office365-Filtering-Correlation-Id: adeed595-09b3-4238-1b07-08decabf2a2a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|366016|1800799024|23010399003|56012099006|11063799006|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	vED1dLNJHX+yQE4ZzbCuw1zAGgmOTA2gvf5UrVSKak4nQqF1a2D8YO6RgPjn9u/c3i/DV1nFSljNUdq5dQDL2BtiKSLqIoIK+wTK7ylyX2N8/0NBI45BQbcWRHREtauyCy0wTVanKLN2sQJuyrHQ/NssioiGM54iBTpH4q8jYrla7ufVpOkJvGJaz+umYq3qUh/vKpAfoYEGRPeTUXDc7MAYUp4RsPfPAALXUge3c+20OcOJ7Ksssy6KARr7V3YBWAmxK30DGfrS4zfK0kRmyViYVCz2Sw2Nxnju1FQ1jOUoovWItKUGNnoTZoq2DUYPZLLFN2ZPWw8JufJKJZXo5f2EZIN1MglOudVMjRXFNQrNxn/Wz3zREF/innutuOTCCyRQDIQwzt2BwXGwOfnTnsogIE2IecPdIr8+sOzkx2UbMQYP85+90kLLGfitPWnBjWjGpepr4jjZhz3rPLmJPqbz0QF9TQm4X4DQ8auUMFQMP4B0SuUiILdIoPvaphEvEe/dkQGbxDOqaWVMo8RntoEa/7GF/LWdJwRrbALbKJisY3KOQJHNL5srFGLyTbpGB4YbaBlQJrSwWvs2MrSozLj2y5git9L/O7IigBz1CtA7g+al6eMiFIqi3egxnWUcpLiWRu2J7mh1hd7SN/boZvgF+GjKlgi6ApoKSUXlQNGjk+F7nQz6rwyAAL8LTDn/
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY8PR12MB7433.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024)(23010399003)(56012099006)(11063799006)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?cXZCUnQxbU8yRkZnRHhiczVzWkhJbE5rYnhuSlNXcEpGTHFYb2YyaVg1L0o0?=
 =?utf-8?B?QmFoRFVobmszZ3dtenFtWmFuTTcyc3dRL1hFdjB6dHBiaTVNUDRCLzlQR1Qr?=
 =?utf-8?B?M2NOOXdxakQxczFzZ3dkcHRYNk5MVE9WNk5ickdZWUdlRm5nRHB3VTJYWnRE?=
 =?utf-8?B?c2p6SjVTdjdSVnNVSmxJa2pVYWwwKy9HKzg2NDJBNm5PQTNUcTRaUURYL3hv?=
 =?utf-8?B?dktkUk1mQ1pZcnZCaFZ5VGVJMGhCYTVFdW9aTkRpVS9LMHVvY2p2YjNhS0NV?=
 =?utf-8?B?TjFpNmZ2V1QrUC9qUTRqTXZSWFBHUTI2eHEvS3hLUzdSbDBzMjVYN3VwSzJs?=
 =?utf-8?B?YStiTG5OUytjWEtvUDdlQkh1Ni9RNXlZb1lRMjJxRndVb1RzK2hNeU15T2xn?=
 =?utf-8?B?eXB0dnZQd0pJMkhPWDR2QWQ4RU56dE5rbTJXYUNVZzIwVUFveGovMkZmT1px?=
 =?utf-8?B?QmxEMFM1N2ZyMklKQkNuMEt4UXpnenNnQUN4ajFTZkNFQmVjWmN3OUQ1Vk4r?=
 =?utf-8?B?WHVnVGp1enVqTDBrMmdZNWJZUWNhY20yQlV5Mk5TY3JhdnRzaFVnUHRXQlJW?=
 =?utf-8?B?NzBaMXZkU2NpWktVU3NicnhUV3BoOFZTN0xEOGxqRm1WTCt3a0FVcG9taFdY?=
 =?utf-8?B?a1BkT1lOUEpFdTN3SjJTOS9OMzlGQ09KMnZFWXFESWZZSXh1YkpyTVEyWURW?=
 =?utf-8?B?cU81MGFMb3RNd3pEWDZTSFUxUm8xWDBDNnNsUHRNa1RISFloOXFUbHFENm80?=
 =?utf-8?B?L01hTTBLL3E3aHNBMXROYlMyNk9VMWl5OGVQR2RVN3MrcnNQRjlFWEVBc0Nz?=
 =?utf-8?B?VGlka2ZMWlhJN0tKaWZQWDB4Yjg1aE5VRlR6ZEdqZXI3RG9lbllWWTZmSG1H?=
 =?utf-8?B?dmk0SnRNbWYyS003dFcrZjdlT3o3RUxrUVE0cmV0YnpoRGZjYmlsRU1CTVBj?=
 =?utf-8?B?a2VkVmVUbi80SEdaWnFtTk92YU02Vk1HT2JSVytJSzZTNXRzbXlPcFBkU00y?=
 =?utf-8?B?TTk3UGtyQ3NWU1puVDFhbi9PbkVCMEtXMXUyNWI0N3JDa05NWlJXRy84QkFZ?=
 =?utf-8?B?dm0xb0lyMTc3eDZkQVYxdU16bnJwS2NkODA0bWhUaGRnWVNDMjhxWjBYUnJE?=
 =?utf-8?B?ZTFkUHBUR3lNbURnSG8yNjk2VmNEUWpsVThVaGk4Q2wrdXdjKzE4cHFkZVl4?=
 =?utf-8?B?bkZ2Nml2WUs5Smx3ci9Vd3hSZ0pLY05rZlBLd0tJKzd1cjRNOFVoanI3RG9i?=
 =?utf-8?B?MmlSWkVFZVBpRVBYcEJFMGtGcXlMenpjbWZYUlNVemU2Uk9ka0doUVFRRlpo?=
 =?utf-8?B?WGNrZlZtWVR3NG5VbEorT09Bbk5LV012N1g0QWd0RnliVTU2RDhkUXNKYnhM?=
 =?utf-8?B?V0MvNi8xYVlwb2FjTTBCekloMzM2TWZsT3lYRmZGUzZzMnpWaER0Q3gzVXJx?=
 =?utf-8?B?UEVmaEkrTzZmYnhHeENCVDVaU1Raa3NKOGRCTXdETUJCK05WMDJLOGdNNzNH?=
 =?utf-8?B?YVI5Z1pvVzVhQnpIdmxkdHR1V2l4clZGTS9JaklZSmMzTjA3ZkJhdW5NWEgz?=
 =?utf-8?B?akRBUDZFT04zbVBKMC96SExQeW5rVS9aMTdDK1ZCMTNOaVlNMURmcVhYa3Zu?=
 =?utf-8?B?RmlSdHpoZ09HbDB2Y1l5ek1VcEhVWjlDZmdEVzhCRExLMG9YNGFnWGhnOFM2?=
 =?utf-8?B?bXNiV2lMcnU1RERTYWcrc054L1M5ZGcwdERmWG1jVnVHTFdlZWVBSE9YbnZ5?=
 =?utf-8?B?NUgyWUdsNldDZk4rQmg4bzBLSVR2MllTeXo0TW9SandSbDY0RDNiKzcwNVk5?=
 =?utf-8?B?Z3JoNEQ4UVNSQzRrdi8wSXpGb3IzdXBJTUFZZkxzL2N4clhZU2F2dnNTZVd0?=
 =?utf-8?B?UlpnSXRPTEFXallUcTdoWHFwNGtWUSs0RzlGbTFhbGlueHJnMTAvbjVlNmtT?=
 =?utf-8?B?MVhCd0ZCT3d1c3BrTUJNTFV6b2JIdmdEV1g2MjB5R25uSlg2ZU04NUZWUGNl?=
 =?utf-8?B?VnBmdzQycFFhaVpLSFpJKy9SNkpPUzRjNzVjMXQzbGpMNzZSVDE0QlpQQTc1?=
 =?utf-8?B?d2RzTVlONGxjOGtSZDRHYXFvZkJpY0FHZy9BMTJGY1V6b2xYQ25XNWtxbnVU?=
 =?utf-8?B?K2huRTdZZFk4MnhqYVBlV0lyWmVqL0p1ZGJOMEJWdjROY0ZHS2lHZTljclND?=
 =?utf-8?B?b3NsdVBhdS9QNlBySjFuTGFKUjdhQXhnazU0TXA5ank0RmFkQmJ3WWFpWXdP?=
 =?utf-8?B?akZkbjNqVGU2MnF4U0NoYXovZ3dqV0lNMkhrMmgwZFFBajRwSnc5b3oyRkFB?=
 =?utf-8?Q?Q/mj80pG2pO/ADGo+W?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: adeed595-09b3-4238-1b07-08decabf2a2a
X-MS-Exchange-CrossTenant-AuthSource: CY8PR12MB7433.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jun 2026 09:19:12.9052
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: oyiBTfSkfBitRDL8IBso+MsuderJyyAuL99uZmc/FsYXFjs/D6kDopggieie7Jm7qNAV7ZlC6s4CpbIWv4IhMg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB7302
X-Rspamd-Queue-Id: 11103C000D
X-Stat-Signature: otaktzrymu9attz6nmimooqip659ke8r
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1781515157-484110
X-HE-Meta: U2FsdGVkX1+i6FQfpYveI3qwyp3f87dRKDYIxRxSy/yWzOmphlLEMpXzSmXQTYWXhRHRYIKEuZhtFJw3q2cB155RR6LIDm9NGoQK6kfYfB/QAazweHQ8QS8JbnkpzOj0DIcJCs98JuK8REKQrY3l7Nts71rVamPN5USCJBTzh8mds5enPu8ohAyDICNGZ10f/OtpZW2JVP85B/GbWy4pAoRQGDALVq7rZ5dcD4IlJKk9bMPZD6bJemSwXmO5ehthOcHyUJnkm1Qhlb8XIvLBU8C9NhkQXlqBlSi6oZk4XZlr3FMLOhjn6Zw7eCY41mxDFOaB91Zj5Oy3CdV3ChyK/nQemXY21Hsw0kj+gz57kXLJPlOo3ZTjut5KF2ZS2mSos5YvWdiP2z6pIwKNGK09UNpmQd9SMTOdH66o3GM8enwj6FgpMubZfprFiu8+7vY5k5svYczS/pKPGl9f9sP6HuiNalWm/IglCPyrUG41Qr4bjogRuQCEf7JwWVsKwLJHu4bX3YHf15W9TcR9kMjdbL41UsFt4K090ecjNfz8wrNOdZ9SDFbpgQNdTTC3Sf/qiUXg8JfIXjoLkPM83kc+uGuJ2x9fJ89tjhRYpWvAiKZHm28kABKLi4mgzFjzBzKkyonQT+BEMetmb4gEWWASb2TpBeVpse/lzpcRh+My7XkD7KkoPGLpkpxrbwI06A4XRPeXjJnerCo6qCSYD7dWXviiBXYBmDjIMMQWI40AvvghibvbjruAzN/e943/4jyIlxlK/4XTGb2PXIleJvyjXWt/hOIVXac9KGJHSL9dBSpJg9SFwvaFRU+3Nkx7IKZc0SI0AZ4icrKa8U3RbQclY4bTE2qVoK3Oc9nbIBM4jHGlMpGOYgwPg0bAwu2CF6Ivdz7QvBoBsjkmLFRd7Wu22H+XlZePQE4hRRYZMuSFve3fmWUtL0GHjNp+P6GjvtlsJI74BCmi0iHRLpF5qb4
 mLZgi88I
 /JU8uyP5JH6wEqF8TWKrZ1r01X1VLG1r76exJqrj9f3Ly58HtQgbWXyfd96EM0kAqX6lgxUqFpUwEZzDCQCRQG7gX6wvZCfV0YmW2vXQMMayh/L3K941DGbVPzDy3bKtJAvb3IGMI6Z/cj2VBCEvHZuAEZ0alBVOJ99cSVc9pr7Arjat4Q8TLIU07VX1fTR/xZX9DK1E4gw9KFDVRTor3ur0+e/0Mq54FF3XVe+RyvTGfvuCx4MvjQe9RH24OKnQZqogbR4iLySloCT5SQPJDLrdS5Q313KFhjFiULh3DsmdJsXqMgdyqOslJkJ3P7lINuDEVRihUslO/nKrIXmZ/L0xDIdrcTfw94+KBTC0tkEvQS0l5ekNKZSyCPb+NBogyVthV27SVaY+UWJHr2twvHqvBYK73dKjgJU2KSn+VMtqE1Q5dBdhk7j+/XpoeGQXoGiY0cDIHv7Lr631nRSHh/WmRWcj5yvpSbp3RlqAr8MLHopTE3LuwjFxD2vVWjzfk8Z601kfTCk4ZxpW8VOfEFkHLXZLiu7tu093vEu6NrkqzU7McZfdMZ9L5PVzSQvlWwihx
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


> At the moment, if a virtio balloon device has a page reporting vq but
> its size is < PAGE_REPORTING_CAPACITY (32), the balloon driver fails
> probe.
>
> But, there's no way for host to know this value, so it can easily
> create a smaller vq and suddenly adding the reporting capability
> to the device makes all of the driver fail. Not pretty.
>
> Add a capacity field to page_reporting_dev_info so drivers can
> control the maximum number of pages per report batch.
>
> In virtio-balloon, set the capacity to the reporting virtqueue size,
> letting page_reporting adapt to whatever the device provides.
>
> Capacity need not be a power of two.  Code previously called out
> division by PAGE_REPORTING_CAPACITY as cheap since it was a power
> of 2, but no performance difference was observed with non-power-of-2
> values.
>
> If capacity is 0 or exceeds PAGE_REPORTING_CAPACITY, it defaults
> to PAGE_REPORTING_CAPACITY.  The 0 check and the clamping is done in
> page_reporting_register(), before the reporting work is scheduled,
> so we never get division by 0.
>
> Fixes: b0c504f15471 ("virtio-balloon: add support for providing free page reports to host")
> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> Assisted-by: Claude:claude-opus-4-6
> ---
> Changes v1->v2:
> - Document capacity=0 as default in commit log
> - Document that capacity need not be a power of two
> - Drop unnecessary comment about integer division cost
> - Update comment on capacity field: "0 (default) means PAGE_REPORTING_CAPACITY"
>
>   drivers/virtio/virtio_balloon.c |  5 +----
>   include/linux/page_reporting.h  |  3 +++
>   mm/page_reporting.c             | 24 ++++++++++++------------
>   3 files changed, 16 insertions(+), 16 deletions(-)
>
> diff --git a/drivers/virtio/virtio_balloon.c b/drivers/virtio/virtio_balloon.c
> index f6c2dff33f8a..6a1a610c2cb1 100644
> --- a/drivers/virtio/virtio_balloon.c
> +++ b/drivers/virtio/virtio_balloon.c
> @@ -1017,10 +1017,6 @@ static int virtballoon_probe(struct virtio_device *vdev)
>   		unsigned int capacity;
>   
>   		capacity = virtqueue_get_vring_size(vb->reporting_vq);
> -		if (capacity < PAGE_REPORTING_CAPACITY) {
> -			err = -ENOSPC;
> -			goto out_unregister_oom;
> -		}
>   
>   		vb->pr_dev_info.order = PAGE_REPORTING_ORDER_UNSPECIFIED;
>   
> @@ -1041,6 +1037,7 @@ static int virtballoon_probe(struct virtio_device *vdev)
>   		vb->pr_dev_info.order = 5;
>   #endif
>   
> +		vb->pr_dev_info.capacity = capacity;
>   		err = page_reporting_register(&vb->pr_dev_info);
>   		if (err)
>   			goto out_unregister_oom;
> diff --git a/include/linux/page_reporting.h b/include/linux/page_reporting.h
> index 9d4ca5c218a0..048578118a4b 100644
> --- a/include/linux/page_reporting.h
> +++ b/include/linux/page_reporting.h
> @@ -22,6 +22,9 @@ struct page_reporting_dev_info {
>   
>   	/* Minimal order of page reporting */
>   	unsigned int order;
> +
> +	/* Max pages per report batch; 0 (default) means PAGE_REPORTING_CAPACITY */
> +	unsigned int capacity;
>   };
>   
>   /* Tear-down and bring-up for page reporting devices */
> diff --git a/mm/page_reporting.c b/mm/page_reporting.c
> index 7418f2e500bb..942e84b6908a 100644
> --- a/mm/page_reporting.c
> +++ b/mm/page_reporting.c
> @@ -173,11 +173,8 @@ page_reporting_cycle(struct page_reporting_dev_info *prdev, struct zone *zone,
>   	 * any pages that may have already been present from the previous
>   	 * list processed. This should result in us reporting all pages on
>   	 * an idle system in about 30 seconds.
> -	 *
> -	 * The division here should be cheap since PAGE_REPORTING_CAPACITY
> -	 * should always be a power of 2.
>   	 */
> -	budget = DIV_ROUND_UP(area->nr_free, PAGE_REPORTING_CAPACITY * 16);
> +	budget = DIV_ROUND_UP(area->nr_free, prdev->capacity * 16);
>   
>   	/* loop through free list adding unreported pages to sg list */
>   	list_for_each_entry_safe(page, next, list, lru) {
> @@ -222,10 +219,10 @@ page_reporting_cycle(struct page_reporting_dev_info *prdev, struct zone *zone,
>   		spin_unlock_irq(&zone->lock);
>   
>   		/* begin processing pages in local list */
> -		err = prdev->report(prdev, sgl, PAGE_REPORTING_CAPACITY);
> +		err = prdev->report(prdev, sgl, prdev->capacity);
>   
>   		/* reset offset since the full list was reported */
> -		*offset = PAGE_REPORTING_CAPACITY;
> +		*offset = prdev->capacity;
>   
>   		/* update budget to reflect call to report function */
>   		budget--;
> @@ -234,7 +231,7 @@ page_reporting_cycle(struct page_reporting_dev_info *prdev, struct zone *zone,
>   		spin_lock_irq(&zone->lock);
>   
>   		/* flush reported pages from the sg list */
> -		page_reporting_drain(prdev, sgl, PAGE_REPORTING_CAPACITY, !err);
> +		page_reporting_drain(prdev, sgl, prdev->capacity, !err);
>   
>   		/*
>   		 * Reset next to first entry, the old next isn't valid
> @@ -260,13 +257,13 @@ static int
>   page_reporting_process_zone(struct page_reporting_dev_info *prdev,
>   			    struct scatterlist *sgl, struct zone *zone)
>   {
> -	unsigned int order, mt, leftover, offset = PAGE_REPORTING_CAPACITY;
> +	unsigned int order, mt, leftover, offset = prdev->capacity;
>   	unsigned long watermark;
>   	int err = 0;
>   
>   	/* Generate minimum watermark to be able to guarantee progress */
>   	watermark = low_wmark_pages(zone) +
> -		    (PAGE_REPORTING_CAPACITY << page_reporting_order);
> +		    (prdev->capacity << page_reporting_order);
>   
>   	/*
>   	 * Cancel request if insufficient free memory or if we failed
> @@ -290,7 +287,7 @@ page_reporting_process_zone(struct page_reporting_dev_info *prdev,
>   	}
>   
>   	/* report the leftover pages before going idle */
> -	leftover = PAGE_REPORTING_CAPACITY - offset;
> +	leftover = prdev->capacity - offset;
>   	if (leftover) {
>   		sgl = &sgl[offset];
>   		err = prdev->report(prdev, sgl, leftover);
> @@ -322,11 +319,11 @@ static void page_reporting_process(struct work_struct *work)
>   	atomic_set(&prdev->state, state);
>   
>   	/* allocate scatterlist to store pages being reported on */
> -	sgl = kmalloc_objs(*sgl, PAGE_REPORTING_CAPACITY);
> +	sgl = kmalloc_objs(*sgl, prdev->capacity);
>   	if (!sgl)
>   		goto err_out;
>   
> -	sg_init_table(sgl, PAGE_REPORTING_CAPACITY);
> +	sg_init_table(sgl, prdev->capacity);
>   
>   	for_each_zone(zone) {
>   		err = page_reporting_process_zone(prdev, sgl, zone);
> @@ -377,6 +374,9 @@ int page_reporting_register(struct page_reporting_dev_info *prdev)
>   			page_reporting_order = pageblock_order;
>   	}
>   
> +	if (!prdev->capacity || prdev->capacity > PAGE_REPORTING_CAPACITY)
> +		prdev->capacity = PAGE_REPORTING_CAPACITY;
> +
>   	/* initialize state and work structures */
>   	atomic_set(&prdev->state, PAGE_REPORTING_IDLE);
>   	INIT_DELAYED_WORK(&prdev->work, &page_reporting_process);

With the comment change pointed by David,

Reviewed-by: Pankaj Gupta <pankaj.gupta@amd.com>



