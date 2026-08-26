Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5540CC61DBD
	for <linux-mm@archiver.kernel.org>; Wed, 26 Aug 2026 01:31:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1289A6B008C; Tue, 25 Aug 2026 21:31:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0D9FD6B0092; Tue, 25 Aug 2026 21:31:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EE3ED6B0095; Tue, 25 Aug 2026 21:31:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id C59F86B008C
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 21:31:40 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 35D14120147
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 01:31:38 +0000 (UTC)
X-FDA: 85141693476.04.92E4F97
Received: from DM1PR04CU001.outbound.protection.outlook.com (mail-centralusazon11010021.outbound.protection.outlook.com [52.101.61.21])
	by imf12.hostedemail.com (Postfix) with ESMTP id 3EB1940002
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 01:31:35 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=Euv3Vd8T;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf12.hostedemail.com: domain of ziy@nvidia.com designates 52.101.61.21 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1787707895;
	b=m+seVzw+D2a4L6D9poEh/Se0HRHoNEVV3as4dzUPBGau+5kyVrpXlnayfu6UfrgoI/koTt
	PIsbF2OylU5iTLWxFkRPbmYrRYxw8Ky+0NeQNWXJxWcpWeTM6tXXpvREKK1y1JpqnT+YXJ
	pVXHc3vXZ4IuwUYpGmVYAO8QQ3SNL6w=
ARC-Authentication-Results: i=2;
	imf12.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=Euv3Vd8T;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf12.hostedemail.com: domain of ziy@nvidia.com designates 52.101.61.21 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787707895;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cFIHjndXePGR+IkGeQXkk3NNWVM2HYp8S2VkdZsGDWQ=;
	b=ZLq/IAkPGO7zhoyRQ/LgSiNN6gzNdbd4O5NGyMKHFBtK3S2l9YNR7vJWd6Cj3XAAK0TH/P
	FtkCO18+mu76+sK8gQy5MmrJJPmt/nzMYPcb7jVtOEWTMaGkPaR4i0oNnre713Y3u7gbkI
	+mbKWY3kyvSJVvAzVlcXSwKUbDlWDxg=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=DNRvSiY8X16qqPKBSa/ggx+ogEC0jFU2Qgk0ISQJlzCXU1wPSQmm1+vWnwaKcKzitLplG1R7j+p3cCWlh3rIW3s/IoWGS4ITSJcAhmP0/eYnowKQ1dQc+bWlmw8LGBb1t6I0gXv9zxBSu1L/YoIT9mbMv6CLjLbq8d/WmT+YzVXCUjw5h0rmqmGzdK09v/Dym2eNWOWbYVaAzKvhfes0Do686Tln0InKpwmhIxavIy0SJIJ79rYQd1UGFtxA9Us9/33+onTpWnEpoQ+y7dJx9o0oftSkJlTXoYSypoOw4nzDT9ChCYRc6nIGz1BNZhmhhBLMUSv5XWCujX+uf8cDPg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cFIHjndXePGR+IkGeQXkk3NNWVM2HYp8S2VkdZsGDWQ=;
 b=mTFbDoBgejBpggXusMHWEE+6MAXgnNoQaoEGkAZg1MYpCd1GaiVciTw2PFWOMmiuJQqY4xEtFOchRQXcRLFLoVLCCMqDTZ2XFQ6GzSGXbUtIiER+TcQZbNTkXCgHiqYlZfQhB9b9edgnQTc3pqGK6iy/knoe812/zgr69enzLtkIKCrRC6xVIHtTXRgWFFeM3kSRrY4GYaKrw0TQzaO5KA+lwTboUQQzjsfEGr8r/wwlafAkoozOg7hZqIzRqPZ2KVR8/MPSXghVh+++GCvMHZAoLGats2+3NvfucxWKp1MZw/T/i5CnMJJ2S157Q2u/zbtGrDN0Z9aquOj10/3uZg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cFIHjndXePGR+IkGeQXkk3NNWVM2HYp8S2VkdZsGDWQ=;
 b=Euv3Vd8TiORQTUUSNJTzUkOjwZf4yi16eUR2gOP4fKFdjfE68XJ91LWnjY0yj5xBD0L+VDU4xMPH9dUddkDTDbnqUxs6jGwBUclyfgYynd9RZ/vLGNewmz3R4jTZL0rzQuXhZDyl6CXVharRuNn+2eWzMy1k3wxRQlMoN77mltMIqGpN6lDAwgV74E48DNS1SLMYy0tta68qmaQAKCkrz7sYNkIArGoQGz2nMI6GcDL5oAnEgvekGMFh9oyliYkqBpm2Ggn6ZN8lMew4ulZ7ig3qz//RDSlH2Kyx1JTLp85iVl6vjaGn1TH897jptTBBz6hYZGXbzVKVJkPrJ+cPVg==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by CH3PR12MB8404.namprd12.prod.outlook.com (2603:10b6:610:12d::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.360.7; Wed, 26 Aug
 2026 01:31:29 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%5]) with mapi id 15.21.0360.006; Wed, 26 Aug 2026
 01:31:29 +0000
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Tue, 25 Aug 2026 21:31:27 -0400
Message-Id: <DKYHK1O60WCX.1RF4YR10NEL9T@nvidia.com>
Cc: <linux-kernel@vger.kernel.org>, "Andrew Morton"
 <akpm@linux-foundation.org>, "David Hildenbrand" <david@kernel.org>,
 "Lorenzo Stoakes" <ljs@kernel.org>, "Baolin Wang"
 <baolin.wang@linux.alibaba.com>, "Liam R. Howlett" <liam@infradead.org>,
 "Nico Pache" <nico.pache@linux.dev>, "Ryan Roberts" <ryan.roberts@arm.com>,
 "Dev Jain" <dev.jain@arm.com>, "Lance Yang" <lance.yang@linux.dev>, "Usama
 Arif" <usama.arif@linux.dev>, "Vlastimil Babka" <vbabka@kernel.org>, "Mike
 Rapoport" <rppt@kernel.org>, "Suren Baghdasaryan" <surenb@google.com>,
 "Michal Hocko" <mhocko@suse.com>, "Chris Li" <chrisl@kernel.org>, "Kemeng
 Shi" <shikemeng@huaweicloud.com>, "Nhat Pham" <nphamcs@gmail.com>, "Baoquan
 He" <baoquan.he@linux.dev>, "Barry Song" <baohua@kernel.org>, "Youngjun
 Park" <youngjun.park@lge.com>, "Shivam Kalra" <shivamkalra98@zohomail.in>,
 "Kairui Song" <ryncsn@gmail.com>
To: <kasong@tencent.com>, <linux-mm@kvack.org>
From: "Zi Yan" <ziy@nvidia.com>
Subject: Re: [PATCH v3 04/18] mm/huge_memory: split the routine for
 splitting anon and file folio
X-Mailer: aerc 0.22.0
References: <20260821-swap-thp-cleanup-v3-0-9b43f5163238@tencent.com>
 <20260821-swap-thp-cleanup-v3-4-9b43f5163238@tencent.com>
In-Reply-To: <20260821-swap-thp-cleanup-v3-4-9b43f5163238@tencent.com>
X-ClientProxiedBy: YQZPR01CA0133.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:87::25) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|CH3PR12MB8404:EE_
X-MS-Office365-Filtering-Correlation-Id: 356d573e-a33d-4ec2-a06a-08df0311c08b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|376014|7416014|1800799024|366016|6133799003|10067099003|56012099006|4143699003|11063799006|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	PZxm02li/2CWOMYILcaP2ecUqWw9uUApYepOdy9Y+nrhKKl3t24PfFLAiJOI6hK4s0atmMZNPq5gLX2GjYQG3ceN07u/WX7X0go7IgUL8Pznf6pcYNEIiecjSIfxZwEGWpcO8WIsxd0fI2V15gpujzaFT1qb3aGirEhdkvznNmXuc+7EzWD2N6wlKENDeLpd8CNngPJh1bS8TsVfSd5o6H1U2L5otV+0LhYLjaNIcWhpjEG1ijo9IBtOt8kTensUnNNcf1AY2FD3HyxI6ARMykDJAUMm5O7J9zFyEKKt2fnUQ+dvK8MLEz13UdBNdpcrt3TS4uxGTYlARrt5UREWS0mSmeieu3d0PFNDQagssu/oQg04rtFtxOPI5+WC4TpkKy89ukn+J1nKfbH697XJ4RSNrlx0tlUFao8CX7/x7nLeXo3aAbPcDsdAc/UzjJAiqet48LsY4Mzq+wV2vDjkGBslJ1geZu2OW2uYB0+POlmm2QAyopw63l+nWBTy+T0pNA5FvKP+w1Sq5CNi+cpJRLSoESWKuBPSOVOOuoIzsgUe4QgjYHxm31QLosSsyZqispJZtQuQdYyDHWhWGoXwWweznKFN9o8RvWEAzL+yDSSQYNV3T79u6j+wFoPy9zS1RiFjDXqG7fOKv7dfecr3d/REztMzcbn6iahzoalf95I=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(376014)(7416014)(1800799024)(366016)(6133799003)(10067099003)(56012099006)(4143699003)(11063799006)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?NHZrTUppaVY1MGN5VWh1d1Rhd3dQWFlML2duU3ZRVGpIL2lwODkwaTZIZ3Nv?=
 =?utf-8?B?VGQ3b1ZrT3MwTGFhc1hZZUlKWUVoSkN5RFAwQWVuY0psUWx4Mzl3a2svWDRi?=
 =?utf-8?B?RDlLZHpYZzhiREZQOU16eHFHRjRpckI3eU1DNE5OS2xEK3ZRbzk5aXk4SXV0?=
 =?utf-8?B?STVZanQrZEVPUWE0T3ZOVjBDYW9xMllpd0M4ZFZHN1pRUm9yZG54S0s4ZFdr?=
 =?utf-8?B?UnczVUVOOG9rRENSeGJFeUpVS0UrTE0vOFY5T3JlekhRQ0h4cFpwS2hDV0Jl?=
 =?utf-8?B?TFV0WU9vMTVUdWZFWFNublV3UGJDREgyK0pIQmxUSEVmak1ObVBBa1E3cjJI?=
 =?utf-8?B?cmdsc2ptbll2N0NvdE1HcXRWZ1NBSXhQeG1VT0lFVnBhblpjNC8vak5FRXhX?=
 =?utf-8?B?ZE8vcmFPS3FKK1JGSldqOWdTZ1g1eEg0c2p0MDl3VEE1N09RaFMvai9QL01P?=
 =?utf-8?B?OWp2TFlVQjZ3Zm5oQ1Bhcld3V01JSmwxN0h5TldNS3dTcVZoUTl6Ung5cmt5?=
 =?utf-8?B?eUMrQ3ovUExTZzMrMUxZTnhIV1FCbEhxa2NIZGdmaUJVVFRuK2NBN2FJNkhV?=
 =?utf-8?B?bnNiK1ZpMUVLOFVHVUxleXpPTmdBWURNZlJmL08vQ1FqdFJQUmwxVFprSCs4?=
 =?utf-8?B?ZUhiMHJiRjJnZi9HdXRHa0M5MEp2YlVKV0lQczlOc01NRG94RjRGdituajF1?=
 =?utf-8?B?U081b0lIZkFEV29STDhLdVdJRDUrdjVQSjdXZk9PbjRkOVZtcmdYb1VDclVJ?=
 =?utf-8?B?TUY0anVDZHdoWmdrKzJpSXJXN2UwTFk2c3RmRElud1dTWDFnNGxleDZsQVhx?=
 =?utf-8?B?eHdObVlXVFVnejBDRXNvRVh1bXc4dmJFd0hadUJPWFNJeVlYSTVLMlIvbXFY?=
 =?utf-8?B?NzdrVGM5VnJGUzNWRWY2d0ZtQ2hZbHMwQ2p5cFA1UmxtWFZkZEpFUW9tajd5?=
 =?utf-8?B?NG9xM0tkenhRS2lKdmpZbCtIWTYyMkJ1ZnlBZDF5blpnQU45emdnT2JVcDFH?=
 =?utf-8?B?Q3hYRHo1ZVFKRG84ZU40RW1HdlRCbDgwVkQ2VGtjeUFZY3lNcDhjUkdXVW4x?=
 =?utf-8?B?b3ppRUxXZ0V2dVhTMzdWeUY5TnUyWjZjNFF1aFpZSHEyWm9SYklIcjdvbWUx?=
 =?utf-8?B?SU1lbnRnTGJOcUVyZ1Zjc3MxdDJUY2ZQbUNuejl3ZmRGcmFVRlZpMkwyV2Rj?=
 =?utf-8?B?dlQ4bWlnQ1owN3FjRjRTZ1A1bUFNYnkwQWRiVGlHRk0rUjRZSitYS1JwQXdV?=
 =?utf-8?B?UFMwWXpQdU53TmNoY3NkRU1lRHBUWS9Ja3VQZk5ERFNkSFZZWUNGK3hLRHFD?=
 =?utf-8?B?aE16bWFNVG8vUlRDUWJIUW9mcHVNWHlGNW1WaGRyODJBckxmSUlhUTdRNzVL?=
 =?utf-8?B?Wkp5RUJXNXRpeGVURlNKd0xxb0NDajlkQmk5WGxldVZ6TVltYTFiZzVBZDgy?=
 =?utf-8?B?dHFsRXF6elNwY21zUng0UzYxUTBRbUhhSUEwa0NaWUF4Z2ZoZE5KME1XT3l1?=
 =?utf-8?B?M01BZlUrRnVTUG85akdnOFVzTDlIbXRJR3U3VWpkb0dFbkdMdzNTTFYyazlo?=
 =?utf-8?B?T3BXOE1scXJpS09KclZwMEZwZk9PeHlrQnFuUWtxdXNzeTJndHdaVDgyb1dF?=
 =?utf-8?B?YTFwZmRseXdMVFU3TWFnQUNxdHR1VEhPLzJLTGhrWmxtbmsrSFAxanoybkx5?=
 =?utf-8?B?TXY0aDJ6NUZVQ2ZTd2p0cDZMTjNoaG4xNDJoclpiUHVrMjRkKzRXQzUrNGpR?=
 =?utf-8?B?RFduaW55Tzl2Kzcra1JMdUtTcHpSeWJJRHY5TFdFME03TnZkbkVvbURycGVu?=
 =?utf-8?B?cWF1TFlQM3QzNTNQdjgrcGJLZ0JBWGRjb2xsVlpGcXNTWStJNld4cFpHRmR0?=
 =?utf-8?B?MEZXa3hYbVFwYnBUSWQyVEVOcm0reXphUnFJUkJCaXpjTVp0a0lvTW9RR0FU?=
 =?utf-8?B?QVNWV2ZNd3VWcnlReTBtQ1JHbVlhOVE1OFdwcHBUQ2VYRkVvTlQyUk41dXRO?=
 =?utf-8?B?QThhY3VIeHA2TW9hM2pHRkZIcTlQTWV2M3B6SXR3NDVRUmFubDhGQkt4aTZV?=
 =?utf-8?B?OFZFVUxzdkdVUFEySXlwT2JXYi9qMEpWOXhLU3VubEhCNVIvajRzdUg5ejFC?=
 =?utf-8?B?anU2NVBMdFhXVGpkZlRnZkxPWWdkK0xZTWtOV3JCWFhHYU5DWmdYckhoa0dM?=
 =?utf-8?B?UGV0L2N5bXlaMVNUdkxodVY2WlMvS3VMM0tzSmdpb0U5Wk91anlOOUFBNCtW?=
 =?utf-8?B?aStzc2V1bXJpUDl6eS8xS1VPS0w4OENjdm93aEFYNkM1YWIySnFsWWsvbEMw?=
 =?utf-8?Q?M/Fs+5VNbHqP0WDwLz?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 356d573e-a33d-4ec2-a06a-08df0311c08b
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Aug 2026 01:31:29.1605
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wIC3jkAcDueysxkzHCqRSK5SI99UHr92SXLq5nSt1hE0aKyB7d64Wy2KNsTTnTX0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB8404
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 3EB1940002
X-Stat-Signature: g8kkyphkiuw9bwezcnapcohmijw9889e
X-Rspam-User: 
X-HE-Tag: 1787707895-189947
X-HE-Meta: U2FsdGVkX19imx+tZ3Z5tZLxk67vvtHL8rZHrdqzk2arOjzkrlIdfpGd1+L2+0dU7Ipd/BRDysOT9+QyylXhPJMV9o3fA3daVBLfzGOclJ6nkF/C7stPE416NWbgtiYD8VKDLa4QwHuJiao+qUiuyENPDg5/WOsR28IpyJWt6A4av8stMl0Bb586cLMZaS0qeRwIAZwNeOi3Rv1O0Qy8AxN8IwnJQUFXIxcDXhEDyxmBNC/Uob73/4a6cLvfQOtn93zVE+UQBBcoNw17VecUGLTRQd1NVxI8qJz5jfwXEH5/uw3X8rP7aEgtrJudhai9S5ivuvdISfFIF+hUPj++fIwsssGfSbbYsniVc/BIFUW9IFtNQTStWi0/fBc4VY2oKNuzREjLjquOHY5cyU8ZRVspaUJ0Y40ATjRpK8DtBwPLa6sjAhHyJqeZl7ZBAjJMYzCaFDHTMjPOdAktvTlmStHhtIeiQ0fJeMoe2Y2wcUjEW/Fg3ERbHy53U0O8xtrJhRibUghP9HZZnzPrGVheye7G74F0eLadHgWfNBv7/+wDN/zR58yfv4GYKYJHj7EisISJ5BeZCS4amDbsehm461JJYHewFJjOHJxFW7SvM5crfHxTi6C4ROw2Wf05IHCgbTeDcl+Om4Sfm2ZTYMtLC3NSzI37o2755A7WWcIQcIcvvL5fYAcRsK2GZYcmEVbKutcf7SUfE49FD1+69AUHQYqXo6JIJGWYde80ue/bom1UGNZkymb81q1EfshXfhwd47nJbRCTUC2Qul3zD8s3J0n3n87PdX8TjvtGEwd6r80/Yhnqod8+343LJqKmcqxP8Uk3IxBDyC4AZMzM8pqqebw2WSjyt+jFqTSMWiH5JAjZ+G8vZDTCtQmAlA19970vkPNZ80BmYc6fLGP0UTszAWl0kWLVE1ybiGbBnmPuV80PvQJT6yeZZGP08ZJErZUt8pi/JDvr0/2gbPDIlC4
 2fU4PAju
 B7dDESQNwBmJvFIkSrN3q4ETN2Jxm+0PDAMv6F1vNs88PEr2sscTW3gV2cXXLRlIR1sWW0hm8rGXGVuQCOYpTUTkCMwILDvSesFg8XMs5zO7gE0BqwtG9BOa3QmngfjW2d9Y3mAaMsrxNx+0sMSNgJ/5VooJgAX2VaDQT/ifShbe7Q6W0psPAMIEg2WSzRvnwC0b7doUJakjYsnzb0Y69ZdpfMLLGABdBiTd8B8GN6Kul1YYzKg8utJXpQgKUDHOjzF+QiADpPoON/lNKtGuvVM1PGL0mhXTGLd+FVvN+B1Kn2sxVeP2JPrPfOoCCAR/98p7WAxX1OsV4AUmA5Seq1iqAy7m+l/YgzSVn7/L34C7AiDbhmlhhL32qhi75mnq/09kve/++72ZCnrJW0ru+JfujjnjEy90SpxM1BOcIWTuAt5c72IJBokdiqepivQbATJ8FH5lOcMEvmcmgQj97XOwXyt9BBazqRsqNtIbY3NC/hmuekaKGuzagH9cv9hMsZ2yo8X/31w7AqiE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu Aug 20, 2026 at 2:55 PM EDT, Kairui Song via B4 Relay wrote:
> From: Kairui Song <kasong@tencent.com>
>
> No functional change intended. Before adding more logic, split
> __folio_freeze_and_split_unmapped() into an anon and a file variant so
> each path can evolve independently. The two paths shared little beyond
> the folio freeze call, the LRU locking, and the unfreeze skeleton, but
> differed in all other per-folio bookkeeping and routines.
>
> While splitting, some cleanups become easy to apply, and helped drop a
> few now-redundant checks. Also introduce a folio iteration helper to
> avoid a common pitfall of iterating post-split sub-folios: a sub folio
> might get freed mid-iteration as pointed out by Zi [1].
>
> Link: https://lore.kernel.org/linux-mm/DKJSFCLP967N.YBR4DNK1NM2N@nvidia.c=
om/ [1]
> Signed-off-by: Kairui Song <kasong@tencent.com>
> ---
>  mm/huge_memory.c | 119 +++++++++++++++++++++++++++++++++++--------------=
------
>  1 file changed, 75 insertions(+), 44 deletions(-)
>

LGTM.

Reviewed-by: Zi Yan <ziy@nvidia.com>



--=20
Best Regards,
Yan, Zi


