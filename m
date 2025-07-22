Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E7F86C83F1A
	for <linux-mm@archiver.kernel.org>; Tue, 22 Jul 2025 05:42:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 818178E0003; Tue, 22 Jul 2025 01:42:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7C8C88E0001; Tue, 22 Jul 2025 01:42:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6B8198E0003; Tue, 22 Jul 2025 01:42:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 5C8B38E0001
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 01:42:43 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 076EC80271
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 05:42:43 +0000 (UTC)
X-FDA: 83690806206.06.AF89210
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2068.outbound.protection.outlook.com [40.107.95.68])
	by imf20.hostedemail.com (Postfix) with ESMTP id 405E91C0007
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 05:42:40 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b="oawuO/md";
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf20.hostedemail.com: domain of ymaman@nvidia.com designates 40.107.95.68 as permitted sender) smtp.mailfrom=ymaman@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1753162960; a=rsa-sha256;
	cv=pass;
	b=0ORUNzTVc2SYEtDHcl+PQoI1EuwTZeq3HnYO9r8DlYou9M/8gQa4eP+oFnKm4H0OkHxT5X
	VGDCBggGnSaWlreapaqZrVWv30WQQGfdI/wIK2VFZfTWFwS9X2Gj1qdGmjuBIt5uCvi3q9
	kAGsoDRotnjUINyDd9knHou8naDPNnM=
ARC-Authentication-Results: i=2;
	imf20.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b="oawuO/md";
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf20.hostedemail.com: domain of ymaman@nvidia.com designates 40.107.95.68 as permitted sender) smtp.mailfrom=ymaman@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753162960;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MdZN/D7pasYBLufWKrVTXTveKM/eDH45g9TxEw9CPqQ=;
	b=b6TBc3tRq8MdCIwCIBu+fJstkk9JFUXhWfJAP+4FASaRQKjHwQuqeoCAynz6HC+owpP1Lt
	C9HyM4cRIHlcwDa5rSgExIf9I7DL0HEK14F61im6V4o4H1KwxfFvhTDz2Uy+rePTCs7Le+
	/D+c1SB/mYM8HUuGwELeTKOMDtsVZl8=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=n3bTmwE+isBI1MGfYnIgJvo8maWsJRZSIt8AZUNwrGO5cuuC/P1f+v781sYy6vowrWLkuJ/mYGcE1TEiTGhth9nu3zezS+MEERon2AEnfBmOeQHLYANY5WsqcXMumj9wdm209rPGk2wo08q0d3vrmYbHw7uSJbtkEld61wrHViMHZxSha8tNypFK93rD+gCav045+UEPLFGvom6DDuszmpAvXbGC1Fibfbhy/vjvAt0ejWVd35ioOmW1W3//FQN7Svvn4f0i9Rrj1RpeKXFFFvU85YDNZD95gx/H0BinVLy4WMrnuMuMvG05+RwiIcedTWFP2jLzTy/gJj1AcO606A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MdZN/D7pasYBLufWKrVTXTveKM/eDH45g9TxEw9CPqQ=;
 b=eLp01jazV1fdduSsHVClUxTfbNhjW9ltNUgHWqG3xEy9uTesRRd6LNU4K/3YIqaksrAdcQ1GOJq02gQDPXUeT0+021NgtboBpFlRb39obTtP5HtKO61uKieouYDbHNMUi75oXdKSxTCYlBQzGRctIN5MAhuTcdbWaUgxYGxZ8CljI2DIqxErreA4VVpzzKK6IqEYsjorjxgMWTgYl/H+IvBhtJNLCl8H2vSLQNnFvQkZ2uE0hIWILi89R/9gVqJkg/aUsaGq2KrAsDktKJU4QOzGPaGg2D2VyfbCXmD0BdVLS9RH3TLoPZnjDqhx3kIody8oQGWxco2DG+txxoiJWg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MdZN/D7pasYBLufWKrVTXTveKM/eDH45g9TxEw9CPqQ=;
 b=oawuO/mdNiwRDm5a/WBvI7voBmshh7cFhK4kF89XWpF4YkbkafZcpeurDNKD0Q4KC0Nom5V+8s4PVauCe1x+MkFmMy52cMvGYmB1joiIATQf+EDSphrV1kveeJwB7UWaFDqNSux0m8C0/iVaxSI/WYRGc2xUpfMxUyvyUJw9lElEHfn72c8aOR4TqxNH9dguN1KT8bSKp/A//DqaC560RlCGcj+sGoCokonYcostioOWb1GLgGYKU0TAu+VB3V7VGrx5u4ixdGsCKxuH8OGNqRX0UR8kPFZIRZBAH0WXlDuTKmhC3DbM2lUnV2Hu66xeoi//i+8yU0s4b/w/JVtk6g==
Received: from BL1PR12MB5851.namprd12.prod.outlook.com (2603:10b6:208:396::13)
 by SA3PR12MB9226.namprd12.prod.outlook.com (2603:10b6:806:396::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8922.40; Tue, 22 Jul
 2025 05:42:37 +0000
Received: from BL1PR12MB5851.namprd12.prod.outlook.com
 ([fe80::d4a:9ce3:c92e:e938]) by BL1PR12MB5851.namprd12.prod.outlook.com
 ([fe80::d4a:9ce3:c92e:e938%4]) with mapi id 15.20.8922.037; Tue, 22 Jul 2025
 05:42:37 +0000
Message-ID: <419c7a17-b20f-41b9-88af-f9f83c8611ef@nvidia.com>
Date: Tue, 22 Jul 2025 08:42:30 +0300
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/5] mm/hmm: HMM API to enable P2P DMA for device
 private pages
To: Christoph Hellwig <hch@infradead.org>
Cc: =?UTF-8?B?SsOpcsO0bWUgR2xpc3Nl?= <jglisse@redhat.com>,
 Andrew Morton <akpm@linux-foundation.org>, Jason Gunthorpe <jgg@ziepe.ca>,
 Leon Romanovsky <leon@kernel.org>, Lyude Paul <lyude@redhat.com>,
 Danilo Krummrich <dakr@kernel.org>, David Airlie <airlied@gmail.com>,
 Simona Vetter <simona@ffwll.ch>, Alistair Popple <apopple@nvidia.com>,
 Ben Skeggs <bskeggs@nvidia.com>, Michael Guralnik <michaelgur@nvidia.com>,
 Or Har-Toov <ohartoov@nvidia.com>, Daisuke Matsuda <dskmtsd@gmail.com>,
 Shay Drory <shayd@nvidia.com>, linux-mm@kvack.org,
 linux-rdma@vger.kernel.org, dri-devel@lists.freedesktop.org,
 nouveau@lists.freedesktop.org, linux-kernel@vger.kernel.org,
 Gal Shalom <GalShalom@nvidia.com>
References: <20250718115112.3881129-1-ymaman@nvidia.com>
 <20250718115112.3881129-2-ymaman@nvidia.com> <aH3lPnIUGn29HJFo@infradead.org>
Content-Language: en-US
From: Yonatan Maman <ymaman@nvidia.com>
In-Reply-To: <aH3lPnIUGn29HJFo@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: TL2P290CA0006.ISRP290.PROD.OUTLOOK.COM (2603:1096:950:2::6)
 To BL1PR12MB5851.namprd12.prod.outlook.com (2603:10b6:208:396::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL1PR12MB5851:EE_|SA3PR12MB9226:EE_
X-MS-Office365-Filtering-Correlation-Id: fc4fb341-882a-4a19-dee7-08ddc8e29088
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|366016|7416014|10070799003|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?a3l3YVpGSXc4L29FeXRkeUFoVnhBYVB3TlhlSWdQSXJvbWgzdjJiZVBtWUsz?=
 =?utf-8?B?VTd0SEFtUTQzY2dMa2xjN2h6MGZUVEZDaW9oWmlHVmNodHR1enFKcFoxTGFF?=
 =?utf-8?B?WTVLOGVWdGZNYnhGb2dwMnlBajh6RmVjdE1mTitDcVY2cTFZRjhMOTNnNDBy?=
 =?utf-8?B?Vmh6WGZqNVgva3h6ZXM2MGpsRFMwZXUrVTg1YTVaYzN5U3hoOWk2L0dZcTN5?=
 =?utf-8?B?bmdDRExzeTZja082MVdvOFVZV0FCYVJ0YTBWbStENi92K01kQ2NlS0ZlbDBa?=
 =?utf-8?B?bVgvR0lreTJRU1ZmL001REpOajB3aFRPVGlMTi9RelRQcFFhdHdUNWIxUisw?=
 =?utf-8?B?MlBucnBMT0M0NXJMczJyNkw2dEYveXdidDZjaHdOY3Q1NGsyOWdSQnRVSmVB?=
 =?utf-8?B?bXh3VVVyY0krelMxNElrdVBZU2VhTjJ6TmovdW5nYjJFQVE4OUZxeUgrbi9V?=
 =?utf-8?B?T0lpRTVQOXo0SUJ1c3BRblYwdEE1bnEwQWlydDBjY3AzOUNtUkIxRW95ZHBM?=
 =?utf-8?B?Y0s4OG50cHhJQmlFNlY3WG5RaFY5dDJGN2FtWHZzRURLS0JIM2lVRXNsa28x?=
 =?utf-8?B?RUpFeDhnMGFNMkxrNFlKUERGS1V3SjlFQnIvUDdpLzM5NlJGOFRlSlRvYWR6?=
 =?utf-8?B?UE9iSEZ1Si9tYTI2QVhLbVRCamo2Nm81Q0JvOEFtVFhpZlFNd3VDZFh6RGQy?=
 =?utf-8?B?b1lVOWUzZldjWXdWbk40aHViWkRkb1h0VDEvZHBLbWU0MWVJaWxRRWZEbmZI?=
 =?utf-8?B?UHFhLzZ5TE9mc0ZJbHNFU0Z1R1Z4M2hCYUNicjc3NzIxQXFiVGxWejViMjVY?=
 =?utf-8?B?ejNzeUVINmE4QllCamkwbU5pOTlSeVpQeU4vZlFjVHZJRUVxVVFGNVhoNFZw?=
 =?utf-8?B?Y0pYVUx5dXVBVnh0L1d1RVU5SFpBSU5TeFhHeTVreWdhNG5MNGtwUFo4SWEx?=
 =?utf-8?B?Q1VHT3pkQ3NQVzNrT2tqcUZBTXhjSXlKejNybGpDWENVRkpWSXJZUW01MEJv?=
 =?utf-8?B?amNEK0lxcUNhbzY2ejFqRU9DS3lmbXlzcnZRYTFmcWZZTFZTSnBibnI3czIv?=
 =?utf-8?B?TlNWdzNsYnRRS1MwcVFGZVhUU0hnSTgxNXJrRjc3NE1ROHc4UVBHMEYxNGpY?=
 =?utf-8?B?czJEdmxqdVhFdXhMc1lmZXRwY1dIbmJnNWtzMXdWMEFXQ2lSTlREVndPTHdw?=
 =?utf-8?B?NnZOK05EbnhhYjRQMkxGd3ZNZDBaK3Fua25ZNm1mdXhBOWFnV0loVXQwTHV5?=
 =?utf-8?B?bVdJNXJMemhFNGRMQnZKQldRWlllZ1AyL3lpWXo1aTlKMy9PdzJtQkRzWllx?=
 =?utf-8?B?YXVPclRqWmhUS0kxcmR1RUFONkI0V1V3VEt6RjM2SnRQaHBkQVVYWEp4Sks4?=
 =?utf-8?B?UDNNZEYwdFR2bHNmVW9Ib00wd1ZwbExHUzc4czVpenRDUXl1NGpSSUNBRGcx?=
 =?utf-8?B?THd0UlBnSUFoc2hjdE1IQXp0azhNeHIzTmZ1TlFtVGJPdHV2eVVReUY1VkNM?=
 =?utf-8?B?czJ0MnRSZE1HMWtpY25iNGxsd2gxMkRXeFhHNHVNUUNMQ2ZzQjFlQlpKRDV3?=
 =?utf-8?B?U0hEbGo5QkhRMnk1aHArVERLdThldGFYOWw0cWhVb21DZEhoUlZHYlRNVjJs?=
 =?utf-8?B?Wk1tRkFpRnc0NzJWc0lwcDVFRXV6VHA2U3lURE9iL3pud1I3ZlQvUXhLRi9N?=
 =?utf-8?B?S01qUlFrNEM0VWp4ZytQdVZuUkhVU0RZYUpNdlpuN25lWU51MGRaODJhNENI?=
 =?utf-8?B?S0JheEtUU1pNd2pCY3dESHBtWlpjbmlvamZ0eDMyNm5KdU14N0NvRU5LcS82?=
 =?utf-8?B?dUJtODdVYnZodFRZZXZDa0JtTXc1cVRJUllsN1hsOWdlVlZzYzhkTGMrTDQ1?=
 =?utf-8?B?clBlUk1uTm51L0Z6ODVkSmpMb2FyUnpSRTJSd3NncFNoTUgydUdoNkg3M0pm?=
 =?utf-8?Q?+YO2WG2G1vQ=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR12MB5851.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(7416014)(10070799003)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?NkZ2WE1BV3NwUHFLSnoxaVdXUGhrb3BhWDJEWC8vazFJaTFRL05xU2R3S0RB?=
 =?utf-8?B?VTZIekpZWlJrM0lTZjM4VVBnT0M3Q3hYaEVxSm9zVDlrYkJITlZlY0RZQ0tB?=
 =?utf-8?B?V0g3UTdLdHFYSS9GTFRaZldkaFRId2dHMFN1dFVMVjVuTXRPbmxLZ0l1SCtN?=
 =?utf-8?B?UWh1aE1VVml0dDFUeTVTWGVnS0NJZDBqSE1aOWpxTkVsVVFVdUNTQkxOYzFY?=
 =?utf-8?B?Nk1xN2g3eXpQM0hBTWlHd1REMU5lNTQzNWRsU2l5eURTWjVKY3h1NG83TU90?=
 =?utf-8?B?S0M1amV6L1djM0VYQktRa3F0YXk1STNnRTlsWW02UFNYZnN6M2NFUS83RTV1?=
 =?utf-8?B?cGVNT1pHeWQ4VHhsK3FrZytYQ1BwTFQrL2NzOEtXWk1zeHVXZFJ4YU56VzZl?=
 =?utf-8?B?UFVtSFo4QVpPNWFiL2g0U0pqN2dBNXVVdzUwVTZER0NNbS9NSHp6QldKZy9j?=
 =?utf-8?B?T3Y2ZjFiN0ltQ0gxZDhRYzlPQ0tZaE0yeUNoSzNTY1lHOEl3VTRYd2MwR3FP?=
 =?utf-8?B?V3dMdk0rY21CNGx5NUdRM3NEREhvMUFqb0RNWFBEV2dTZ3Fkc1gwVE8zajlr?=
 =?utf-8?B?SzJZb0VxTW9YSEZua3U0cnVuZk93ZGlUYWVjdFZTRGJVbzh4V2lRMHlWZFg1?=
 =?utf-8?B?aGpIcU1lbFRkd3lHc21pNm5kc0U1M04zOGNLdTlkK21wSklJbi9WaEJCRnU4?=
 =?utf-8?B?Uy9PMitlSmNKTXR1SjBKUjNSNXllanFQeEt5MlEwdlZzOTZ4cVJmbExySTFS?=
 =?utf-8?B?OGErVlJ6cndYVU5OQnRKeTlWWFhvelBENzM2eUxiSlp1QXczdElpeUthRGsr?=
 =?utf-8?B?VExYeUhia1hML2hjaFBuckw0dWdHZWFwZkNScDBBdXI4bUNia2E2SmIrQlpt?=
 =?utf-8?B?YlNXYTc5eXRFZmpLbjFNdjN1OHhLT0ZjYXZoUlo1VVh5MnlmZUlRZGIxVUxF?=
 =?utf-8?B?WHRjQjRZR2V4ZlplK0JIK1ZjcUlzSVpubDdudFZHRmhhVFU2eGZTT2RTMC9O?=
 =?utf-8?B?cGpjYXpXWTcyK1pjV0dsSlJieUdFVGtFNU1VeFhHY2FEc1JmT0dMNHZYcTlJ?=
 =?utf-8?B?TFA5SndFNEJoOUxpL1hldkl4ZzlEQ1Jock1jYldkVEZ0SnAzYnd3QnlKUVJl?=
 =?utf-8?B?dGZDenhORlNUK3VqbEwvcWZSVG1LQ29TL0cvT1FCYVZSSWcrOGJ3YkZPRU0w?=
 =?utf-8?B?QzVHZ2RuTWNhdHFoOHJ1RnBuRzRPYlUyMVIyOCtOREpFbHpDaGJMZGdJaHNV?=
 =?utf-8?B?UzZ5c1pvVzFyMXRDYzhnZUdRZzF0Q0creGVidWluNmpoOTIvelBWbHRXenNL?=
 =?utf-8?B?K0dYTmNNMzRQZGVNQi9OZXhxK3hxT0lEMWdxbXd3RlI4WEVtUmFXNEVRTEFS?=
 =?utf-8?B?RzNiZXJNMlpoYWhvWjZoU2lrWTFwMitET0pvK1dXREh1T3ZyNzZISHlMTE85?=
 =?utf-8?B?WENIdWNnNkNOb0pnUkxoeHhuOUVCZWpxdzJJVnQ2OEg1VlpwNmFKdGdNUUNs?=
 =?utf-8?B?UTY4amExNS9FUFZESXdxUzZzcHloK3JNUUFJdEdja2VUYXJSTGJ6NGcxbVFH?=
 =?utf-8?B?VmVRT3JzTVZrWFkvR2RZcDBZL2t4NEQwQjN3emtXVVRlSDNwcXFWSjBpNEdh?=
 =?utf-8?B?MW9yNk1IaU15VlVvc2Q2YU9XRXg1Y3lCMFZkYVF4OXBJdHZ4RlJFYXNBMUd4?=
 =?utf-8?B?MDRQWmsxTHVXdkRoZFEzUm9OM2xSNlRxNXJybkdTdmw0Y1lwaXBVQ1RZdmxS?=
 =?utf-8?B?dXNINXFBNEVWZllxNm1FRTJUdkIyYWVaWjhETkN1MEVZaHZHbFRFRWxrNXlV?=
 =?utf-8?B?TVZuMGdaRTJGK3ZlSjF6a24xdllsaDVRRCtaUkZGKzRrSXBGUGt5N3lXSjU5?=
 =?utf-8?B?d3d2cFcrZW4vM2hrVnlRdk04VlVhNGdKVWF6MklsMkxoMVd6QkNIaHZPT2dm?=
 =?utf-8?B?eXUzNTdXbG1lVlFIMUZpV3haMTE0bUZGWmJ0b01KeUgzVktJcjcxSFo5dVVM?=
 =?utf-8?B?NEVkdTNsMDQ3OWwwVU50U1RTMlo2RVVBWm9TS2VnZUFoYjhLRWp1ditKNnpC?=
 =?utf-8?B?cjRic0o5Z28vY0lUSGhoZW0wWi9scnFGL3FPWTZYc1FnY2sxaHV1dDhtMFRF?=
 =?utf-8?B?ZHdJWVdlRDQ1VFVpMzBzU3hsRDFhc0JSQ0x2RTcvQ09GT1pXZVpVd0RPb0g0?=
 =?utf-8?Q?G4WUCYHYm59KPXPhiFjJ9t0mK6J29pjJ31Z9Bm3p8Qvl?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fc4fb341-882a-4a19-dee7-08ddc8e29088
X-MS-Exchange-CrossTenant-AuthSource: BL1PR12MB5851.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jul 2025 05:42:37.2367
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PWqWGfEIT3Z2ADAjIkQi4Y5umyScdZx5PyT82iQ/5+YLOigC9XvyvsVsbOMMYsvdSTBM8NPx0dsNO/Lc32c0vA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR12MB9226
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 405E91C0007
X-Stat-Signature: hxse79icyjxu7mapciotwqo6nsjxtxar
X-Rspam-User: 
X-HE-Tag: 1753162960-641883
X-HE-Meta: U2FsdGVkX18hM9I3tMSXJU/iocAgqheKjbZ4YbYf+uVp5s44OX/z0KHQNiEyzEkE9ZpqyVRjgpAqSD5/sDiNC+g0DadLQWHnQWMPAKlimz8FolTdlrm8N/hZLTq4YgP6ZoQBb3ztpYJUeXhzTMp5UkTcETn1DxzYP7iNA5W6rLdmjB0JqnEyPzIlwouge+DDQ4E8wDSCd7jSE1uPx4JmxSkAsasTSYF4a+nrueLPwztgtBaxSs2uPYWWn2gwEfvDVaTgx7IgefaUplD4cnfMwuypdfdCmxCD0ZKPFisfJQoqK3Efd3dT9DNuN/KR9sU40rlVyxwAXJTbd9f7kpNk6AbeYtMFh37e33k0xfiAy4exdJyBLrD0dG2OWdalhCj2HPrER1Ueis3Xl+teBOvtwA30mfQ+EU/xNQfRHA9thKA9Boy0+Csa8dh2lcUvf+YEoQCcVN9+pTGXJKlgpomlkjW2X6EQI+HP0ejoJN8ObiojoeM8JW8JfwYSFNS6T8G1WrHzQfUzz/68bLWZ+ptuVSAAq67U4x708tsD9kj5wwfx8dNLoMHRAiLF3iZTZG0rARS2m4AShNuZxA0V5AQN1Sx+61c/sb1YDlDb3ysMUz6u61yhUs0QUnqXvEvghnBWxsGePO/wnunTSag0mSzdeeEP7NoAan9T6v13g4k9mTBtPp7AIpKYBX1QnbMbyqUebGyeDFzvQIE6IO2IvF266lKYHoZtRNn3MK4UvjaDKfrad+SqDWMZg76agD0wjhVUVJm6OqYO8SbCTAiXOazkye3ozUbNCb2ZtsnHM2oTF8s6cGThIjyedIAinEvVr9cq59G2HeRDLgN0mimqt7BPlDNiNRyQ0UQmNuiz/JYdqii0kxzVolB4TYQHKMI+bQe67MqJaDnYcb4gmeueTrcEo8n+/n9tp+XFBN9yiWzM52qjFbb+VaZUQ6JUPZyFsRuv+CA7RCeJaMXj7R6wi8n
 eYs3UR1X
 EICoxfezxioCZcSTio1kBobh18YbU1JyMxdOwz9IBrgLA2cbmEb5Jh6yCSvYqB7w1RUc7xVZ5DPdgbbyL2HIZ2JQyzkfv0v42KF70jOjD8JY10I/9SPxaDQOOlwSh5OXSyVq+2jO7kA2O4DR/AnuT+uOo8rIAxAOdvXQ+E+7GrE4sC9P9pBN4WDzDjVTYoSPD9pfO2vXmEJ57kECRJaQmyoLWfWe7xYNRJOO9XX/zf51FgmBBehrbaI+DXsEHK/GjN12C95TgYpoEx5TaeTKUpD7p0zqe3M7Lqif2DUjixUY6tTOIeLMU0AJlq1JE9+/5ahU5MZPgOXyq5XyhIzOwqfesT8WPQzOzDM5lI7xZAtBQDzqtI8ior1/96c25leHWE8jyFeHCy8vlkvhHSUfjoC4QkLmMmgVsaNaR/Mr5Lfkc3BDgi4MlPmY0AaHMt8U5Tlt3zMT7ryNdUPVJh4fvMPX0VFohJei0Hch8dpge/O8JXtY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 21/07/2025 9:59, Christoph Hellwig wrote:
> On Fri, Jul 18, 2025 at 02:51:08PM +0300, Yonatan Maman wrote:
>> From: Yonatan Maman <Ymaman@Nvidia.com>
>>
>> hmm_range_fault() by default triggered a page fault on device private
>> when HMM_PFN_REQ_FAULT flag was set. pages, migrating them to RAM. In some
>> cases, such as with RDMA devices, the migration overhead between the
>> device (e.g., GPU) and the CPU, and vice-versa, significantly degrades
>> performance. Thus, enabling Peer-to-Peer (P2P) DMA access for device
>> private page might be crucial for minimizing data transfer overhead.
> 
> You don't enable DMA for device private pages.  You allow discovering
> a DMAable alias for device private pages.
>
> Also absolutely nothing GPU specific here.
>
Ok, understood, I will change it (v3).
  >> +	/*
>> +	 * Don't fault in device private pages owned by the caller,
>> +	 * just report the PFN.
>> +	 */
>> +	if (pgmap->owner == range->dev_private_owner) {
>> +		*hmm_pfn = swp_offset_pfn(entry);
>> +		goto found;
> 
> This is dangerous because it mixes actual DMAable alias PFNs with the
> device private fake PFNs.  Maybe your hardware / driver can handle
> it, but just leaking this out is not a good idea.
>

In the current implementation, regular pci_p2p pages are returned as-is 
from hmm_range_fault() - for virtual address backed by pci_p2p page, it 
will return the corresponding PFN.
That said, we can mark these via the hmm_pfn output flags so the caller 
can handle them appropriately.

>> +		    hmm_handle_device_private(range, pfn_req_flags, entry, hmm_pfn))
> 
> Overly long line here.
> 

will be fixed (v3)

