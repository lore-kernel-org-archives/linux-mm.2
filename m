Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D2E22EA4FD7
	for <linux-mm@archiver.kernel.org>; Mon, 23 Feb 2026 15:22:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3E07C6B0005; Mon, 23 Feb 2026 10:22:46 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 38E0A6B008A; Mon, 23 Feb 2026 10:22:46 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 21AFB6B008C; Mon, 23 Feb 2026 10:22:46 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 0CCE36B0005
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 10:22:46 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id BD35F1A01E1
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 15:22:45 +0000 (UTC)
X-FDA: 84476088690.05.E2D59B9
Received: from BYAPR05CU005.outbound.protection.outlook.com (mail-westusazon11010001.outbound.protection.outlook.com [52.101.85.1])
	by imf13.hostedemail.com (Postfix) with ESMTP id CC1D82000A
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 15:22:42 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=1R8fHFBg;
	spf=pass (imf13.hostedemail.com: domain of Christian.Koenig@amd.com designates 52.101.85.1 as permitted sender) smtp.mailfrom=Christian.Koenig@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771860163;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1a8DOf85OXZZ9cRZWI2U5OsHQxBvst5ogD53MlLBsMc=;
	b=UhqCtNg9LhJY9kWRMX51p0oMVgpvUzMLHazzY0Gwys0i8gZkD1FHhukzcK1P4IWqaT39Kz
	EzQSqTJ4AQMDj9nYjLR6XJ54Z38Bx5pg1VTYAW90WpIOc3tKGe+1cC0aWJoXC2hzDyM39d
	ii7LDpMZkql26yK/tT7jQ7LFjmt6Pmk=
ARC-Authentication-Results: i=2;
	imf13.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=1R8fHFBg;
	spf=pass (imf13.hostedemail.com: domain of Christian.Koenig@amd.com designates 52.101.85.1 as permitted sender) smtp.mailfrom=Christian.Koenig@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1771860163; a=rsa-sha256;
	cv=pass;
	b=GdNplPXmSzU+5e79HoMLpYIWv05Wb4NUVCd1rt4uFk+hBHP/bHPjKx8LCa6LkWf7hJ+YbW
	zBX/s3O6jucPtEwO7KuuMSwGOmcUWcnAHqTVpwTvyElEF4PBK0D1ubYXnkDYIwzzJfRskv
	LsDTy8yUKTvQA2OQJux6rZqb3zCgcuU=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=gGsWoYQEn5BteuaHUdwewRBKmYId9br1Xf6oKr6/Zl7DWDjPheceNAH/A9GQtJN6sZ9ev0wVoAvBrSxJ1Yzz6kJIo4c/fDMqbm+OT3SxGkXhcCBZKJHgh1dPXXH8t30Otp5Poq5wVD+xj70R0PAFusrJi/vCRhZrMCE+f5BXYkNjpJ/iGqbSb1Z63MeTVeJem80sID8XT2VdGLhHpUxkXNbCh4I9ngrgTV5NWy0sJqXAFdu8cLZlsdxdYQMa15iOQb48gYJVG2/qXDUwqAM3Rlmcoh/kLgMBf01EJNZiOdARyYm5fGutnubM68UhwktWGUAWQcHVq19AXPcHnopfNQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1a8DOf85OXZZ9cRZWI2U5OsHQxBvst5ogD53MlLBsMc=;
 b=JSoLMdD4Az83v3RXlDrRqYALtLtGtQWY0Qi6ZNNn0jClzZh+tpcJb9Ymqw6eAF0+1DcRmMi3G9eJjkZMLr3iOdDa0VhW0HwYUwMm/Ld0y0EV8PhJdjGVVq5MRoycTj4ziqCyqL+EOTIEzhl9yK1FFpMgLSMIZesZh1fyw3othDVtgo/qI6EBmBdHViSU0mAoMKLbZ4F9rrq4dcPAKYNL262AwNUn8oAilgAK0zblPMp8pTWw3xqGQqv/ETQMvPiUDJ0AZqDiWly/qIWuHKBbr3A+7kT5+pdmQbhfMMEZasMc4PNtZqJ1+TQjKe3+RHlmWLWTxce+RlkWTLsL/4jXKw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1a8DOf85OXZZ9cRZWI2U5OsHQxBvst5ogD53MlLBsMc=;
 b=1R8fHFBgUVgxvXX/8n38SAQySgwHRMVByiGxuhLHkUcWANG+m5bqzIFlDRcX1vlm1yqVaC2efQZi/O9F//d12ZvHwscIAwdb9oCEvLEZ+BnIHvreo9BfmwtCa2cQEW3oe5zVdkXnXQmFm42uiKzxe2IbwIr57p/t6qLfjOHzST8=
Received: from PH7PR12MB5685.namprd12.prod.outlook.com (2603:10b6:510:13c::22)
 by PH0PR12MB7096.namprd12.prod.outlook.com (2603:10b6:510:21d::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9632.21; Mon, 23 Feb
 2026 15:22:31 +0000
Received: from PH7PR12MB5685.namprd12.prod.outlook.com
 ([fe80::ce69:cfae:774d:a65c]) by PH7PR12MB5685.namprd12.prod.outlook.com
 ([fe80::ce69:cfae:774d:a65c%5]) with mapi id 15.20.9632.017; Mon, 23 Feb 2026
 15:22:31 +0000
Message-ID: <da2f5f7c-0252-4085-a490-a505d0169bc4@amd.com>
Date: Mon, 23 Feb 2026 16:22:17 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 00/11] Zero page->private when freeing pages
To: "David Hildenbrand (Arm)" <david@kernel.org>,
 Christoph Hellwig <hch@infradead.org>, Zi Yan <ziy@nvidia.com>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
 linux-erofs@lists.ozlabs.org, linux-block@vger.kernel.org,
 dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Brendan Jackman <jackmanb@google.com>, Johannes Weiner <hannes@cmpxchg.org>,
 Jason Xing <kernelxing@tencent.com>, Yushan Zhou <katrinzhou@tencent.com>,
 "Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
 Vlastimil Babka <vbabka@kernel.org>, Christoph Lameter <cl@gentwo.org>,
 David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>, Harry Yoo <harry.yoo@oracle.com>,
 Huang Rui <ray.huang@amd.com>, Matthew Auld <matthew.auld@intel.com>,
 Matthew Brost <matthew.brost@intel.com>,
 Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
 Maxime Ripard <mripard@kernel.org>, Thomas Zimmermann <tzimmermann@suse.de>,
 David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>,
 Jens Axboe <axboe@kernel.dk>, Christian Brauner <brauner@kernel.org>,
 K Prateek Nayak <kprateek.nayak@amd.com>, Davidlohr Bueso
 <dave@stgolabs.net>, Eric Sandeen <sandeen@redhat.com>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 =?UTF-8?Q?Arve_Hj=C3=B8nnev=C3=A5g?= <arve@android.com>,
 Todd Kjos <tkjos@android.com>, Carlos Llamas <cmllamas@google.com>,
 Alice Ryhl <aliceryhl@google.com>, Damien Le Moal <dlemoal@kernel.org>,
 Johannes Thumshirn <johannes.thumshirn@wdc.com>,
 Dennis Zhou <dennis@kernel.org>, Tejun Heo <tj@kernel.org>,
 Gao Xiang <xiang@kernel.org>, Yue Hu <zbestahu@gmail.com>,
 Jeffle Xu <jefflexu@linux.alibaba.com>, Sandeep Dhavale
 <dhavale@google.com>, Hongbo Li <lihongbo22@huawei.com>,
 Chunhai Guo <guochunhai@vivo.com>
References: <20260223032641.1859381-1-ziy@nvidia.com>
 <aZxaIEFZr2NvO2eQ@infradead.org>
 <cb8d6ee2-fd1d-436a-b934-aff87adf5dcb@amd.com>
 <5105764a-8313-45bd-8b91-8c0ea8cdf077@kernel.org>
Content-Language: en-US
From: =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>
In-Reply-To: <5105764a-8313-45bd-8b91-8c0ea8cdf077@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: FR2P281CA0010.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:a::20) To PH7PR12MB5685.namprd12.prod.outlook.com
 (2603:10b6:510:13c::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH7PR12MB5685:EE_|PH0PR12MB7096:EE_
X-MS-Office365-Filtering-Correlation-Id: 3364a66c-0ac8-4d55-5507-08de72ef5c87
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|7416014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?UG9uNWhBRUZOUXJvUHNQNjhhTjFDenRMeGpUdlNnR1BUY1U3SnJrbFRoWmxM?=
 =?utf-8?B?RTNMZ3dRb0RjVXJIYVA5RWtxQ0lGZlhjWW1pMDZIOWRxaSsyVDBrcUZIOWZa?=
 =?utf-8?B?MlFjZ2MvRDI1M3pTc0ZrYVlDdnhvRDhrbUZrOTBVU1hWcXZwOFMzV1EzWXpj?=
 =?utf-8?B?TzZqeFhaR3F5T0p2eXNUT0Exa0h6N2xCQ1Vub29zcCtkakVxRmkzcWJUK2lu?=
 =?utf-8?B?VnJjM0FSL3lLS1dROGtwZU9EaitWUmZzQmduL09ZNWJYY3JIdVhOdUFrU2dG?=
 =?utf-8?B?N2VtMXZ4MWJtWGxRWnN3VWhEWWc5eU1ObVpiNEF2ZnVKendib25WdmNKZkNX?=
 =?utf-8?B?eXpCN3diUVc5LzBYYVUrYlM3THJUcS8wZUJUZG00QktJdldHdGR3eFJhZE9h?=
 =?utf-8?B?c0JlWWFwWG5qRWpramppZXV0TTJtZ1o5VHRBdlVGYkZJNWlRQ0pMaVdhQmVY?=
 =?utf-8?B?dk9ZUXAwYlZHa2FWREpuM3FFUUxFODBCSFBvZ2lsbTdLbGtJY0c2dFFBNEFr?=
 =?utf-8?B?WTE2RXNkWWVZWlBZN01leEtTUVl4aFVxQTZuS0FsWUVQbHZFVDVqakI0cHdm?=
 =?utf-8?B?eGtQU1hVZjRYS0dlSVdaNDFSV2ROSUpCa1pzSmdXeGxYUGdjK1RYczd1UDFi?=
 =?utf-8?B?NU0vL0w3MEcvaTR1d2FmK0tsUWVWUmJzdkhheWVDVHpLVXlWdCtDVFBPT2sz?=
 =?utf-8?B?Z3ZuMnV1VjVKcFdpdkVrMy9rSWVBYUpTTk8yeDFQNVB2MXRqL2Z5Zm5EWDJ5?=
 =?utf-8?B?cStOZmdOTXRYWmZpSS9FOEJYTW1CN3NZL1Zwc0FGOXU2OWd4eXJOQXQ2QWJX?=
 =?utf-8?B?MW14UjNydlVPWVhubkZzanYyTk5TUk9ZWW9yM0MycGVwbVd0STd4M2xxUVJk?=
 =?utf-8?B?eC9VVkQ0UlBKVmFqSnpLZFdlNlRhZm8vM3phL3JXa2Z6NzgvZnk3VVNrY3pv?=
 =?utf-8?B?RzRqQ25BUmVEbjVsSG5TWm9sVU9rc2syTXo0TnBIN211TUpjWngwT09vNzRy?=
 =?utf-8?B?cWxMVEQ5YTdoL2dQVy9iZUpZQ2dJK0gxSWxIMFJPbDJuUGVkbTBOWFJXSU1y?=
 =?utf-8?B?UzhZTDMvWUpVK004TGJLNU16bzVWaXpoZTh5R1JqRG9tbEtGTCsyMmZreG43?=
 =?utf-8?B?NzBUNXJqOEU5TTFTWEFNOTVrZks2S3MvUG0rU0Q2amo0anhhdWFqTTBPbitw?=
 =?utf-8?B?dHFkMzJPbkJxRllHd3RhZGJub1dtbEpYdGM4Y2FWYWtDdm1hUDY2QUtOdGNa?=
 =?utf-8?B?ZDl5M0g5aFkwRUJ4dStVTWNkdnk4UTlrb3ZzdE9WQVoxSldzdGtvS3JkSHFj?=
 =?utf-8?B?ZmpRZHhLQm9TQ0FTdnFPZWN6YkpvdTB2Rk1lTjJYQmZta2hUMDVIM3Fma0dt?=
 =?utf-8?B?WGlUNGxUWGVXUUJpaUJpK0ZEK1hCVld1NG9ta3F5RFI1OW0zOXZQQnlDZlIv?=
 =?utf-8?B?V1NLRkZDZHM5clY4bjNPRkdBWWwvTTVuRG1WcklTVFdGZ2RrQlY5c2JjWDJC?=
 =?utf-8?B?QWo1clRzWi8wUW9yVTBrOEhCZHljaEdqKytkUzNhRnZTM2hWZitlQ3Y2eHly?=
 =?utf-8?B?QWdVRWZCSUt6d2tSYjQyVDFicGFDaXpuQXBpajVPNVQ0NDFaTFp1NzlhM3NM?=
 =?utf-8?B?ZkZBM0VrWi9vcEdVME1ZMkhjdy9zOFYybkJJNFIzVmVBUEx5MWh2TUFIZmZ1?=
 =?utf-8?B?ZytoZ2RjUnBJdjYydXo0YnFPRUNUZjRXT244aDlpTThRSUhsQkoyaS95WG43?=
 =?utf-8?B?dkpnako2L3NhRjRTRzNPemtkb1lwSFlGTGpMWHJnNTJUOTFFZTR4alNUQnJR?=
 =?utf-8?B?bnN3d0dINU5EUzNVRlpnKzl3VmtCZHREdGYzbHljQzZRWlI2UTdHMVdHeUQy?=
 =?utf-8?B?MFNPQmwyQVR1aGdSdXFVNjdJRlFTczBsUFJYc0t3dFhpTWJEMnVRSjJXWHVi?=
 =?utf-8?B?aWVCaEVDdkFrN0x0VnRmUWxPcXV6eG1XRGhVeEQ4VzZpb2R5SFhmaHR5Z1F0?=
 =?utf-8?B?YkMwV1VRbFBQSkxvTGZscWlXMzhvYUhvcjhaaW5tSFpUS3JnUDg3L2tiWmdH?=
 =?utf-8?B?cFlKRFpsOTY5amNWUE81U1QyVDM0RXZwNTA4bWRtd2VjSGJuQVo3SGI0ekk2?=
 =?utf-8?Q?ghgQ=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR12MB5685.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?OEtrTmdLSHRMditnMmtZVWsvQmY4ZlZ5VU1BeVdQa2RvS0tGY0R5aVY1Rysx?=
 =?utf-8?B?TmlXS1g0SzRXMktqMVdZQzRoTTNaY21lOHhFL3lrZ0thUkJ3Rm5wemNZUmpG?=
 =?utf-8?B?WVprT3pZajBxTkNMcy95Ynh5ck1rQ0FwZWpuRksrelpQYjVxWFZkUWtQSWV2?=
 =?utf-8?B?bTVJSXRIU0U5WkZ5Szd5NnEzNDIvbnBnMHhnTzZGVlE3TkZFRWtXb3JBeVA2?=
 =?utf-8?B?TG1FK016Y2dxaVN3cURWOTNURExHbERyTDBTbHBNL0l2Ny9DUkNiR3ZPeVRP?=
 =?utf-8?B?RjRySTR0QjRjb28yYWpJeHJzd2M0NE44OHlaTE1MVHQrdnpSZkxSdFBKUDZW?=
 =?utf-8?B?RXhUU0lwZEl2S2lCVDdhYUI0TVl2ZFV4Zm96d3VTK09kSnl3MDEwZ2dYSVJn?=
 =?utf-8?B?VnRwWkpsdjNwd1BzTmxmUmtPZDFzTFNZYk9UNG92TU9QT2ZuamdNRTl1eWtN?=
 =?utf-8?B?RjNBL1lnc2cxVHNCbkNXUnJKcEU4QWtpQkNXeDNVenV4Ly9paTNoMXl2emFK?=
 =?utf-8?B?N0N3ZHB1RzRjblFZajJKN2pTTTBDQzJXZ3JENm1teGs0QmlvOUdabXZrOXpQ?=
 =?utf-8?B?ZGowcmhDVUJxVDV3a2VNRXZnL3hvOVUvMWh5MWVtcHp0WVF2WmhmNmtYK0ps?=
 =?utf-8?B?dU1GZExEajVBQ2hVbHNsWnUvc3pTNnNVeG5RNExVK1VoUmhTUjdGM0ZWWHN2?=
 =?utf-8?B?b0hQL2lhc1ZkMmtyOTYrU05qRkd1S3pQUzdWTDhvWGxWMzdIb3VOVC9tWnZ3?=
 =?utf-8?B?SEpvb2ZRTmJRbTNlMmZiOTlmdTMzZDZ1MGg4U3JVTTQyVUZ1VGZMakRKMmp2?=
 =?utf-8?B?eTlkSjUzZzVVOVBHOWp1WmgyRDVxTkRBK2RPMEdYdkNGdkZwU0pGdUNHMUlO?=
 =?utf-8?B?MnNVRVhTRThPMERLcnY5VVdEM2V0NFVnRkducmFRWG1qZ0FHTVZFRXdhbmpB?=
 =?utf-8?B?cXpnSDI5QWdaUFlzWmQxOWc3NlR3VHAwTFpZc1JmQ2h2NjRCZWEwL3N2cnBK?=
 =?utf-8?B?WDF6SFJQcWtzYlBaZm5sdHlmNnN0SlJSSHF0cTRzdk9hSEk2ZjRIZnU2UHZ4?=
 =?utf-8?B?Wm9ycDF2UU1qcnJsMGVFaU1nclh4QW5pSm51ek92L3QvbWc2S3lhcGUyZ1Fs?=
 =?utf-8?B?dnM2cGZaVUp6ZHd0eUNuWGlmRTRQdFZRdlBKZlE0TlJobGFGYWJHRER3ZHBG?=
 =?utf-8?B?SXdFTVY4M21IQ3ZOQ1YxdTg4Q3lReWJVanVZdmx1U0RxbXdWbkt4Qjh4NkNX?=
 =?utf-8?B?QnhhK0dsQjRpb3p5amJ6R1MzclRiY200VFAyZ1FDYnNwSHlVZnQxbVE4MHdZ?=
 =?utf-8?B?Q2pnRGh1azc2RUF2TElLNmdzNnpHNU9LWEpqSkFLMG1XRGlQMU0zbldIK3V3?=
 =?utf-8?B?MGlKWXVUOW9LTHMyMlhYeXJleDBQSVAzSElFT0dON2g4VUpFVHlMeENodDY2?=
 =?utf-8?B?K3JZL3RJOHRDSlBrVENxY1hNck1JRVRWWkFJQ0ViTGkwTFJrM3dpTFhXTVlB?=
 =?utf-8?B?R0RPK0Z3SUpCd2ZlVitIZGxzSy9xUHd1bDR3RXNmMUhwSG9EeWl3OXZmeEpP?=
 =?utf-8?B?Yk5hOHd6S2RqeElNajNIUDY2bUl3VExzUFBYU1hPWGNYcUtuQUVyZlZuSjJK?=
 =?utf-8?B?bzNsRHhuc0dTR0ZORWltcEF3VE1EQnJubVU1VFFiRGkxWDM0MmQwZFZXQTQy?=
 =?utf-8?B?Z0FjemVSRUJhRkhMRFVWYitFY1pyc0UrbSt2ZXREN0xvV3d6RVBwbzg0dDcx?=
 =?utf-8?B?Y0xQYmx6VGh1aWxqTTQ1RXpPYTcvU3ZYRXRENzJMVkZYZUtrVmttcVNqNjZk?=
 =?utf-8?B?YmZidFk0amp5enRqYUFRM2JlbVVSckF5ZmZWeFpPVk5Pc1ZmdjFTUUtaMEVP?=
 =?utf-8?B?UHg0NlFzL2lncHJMN1BVSnpBNXBDSXBGb0tGdDluOFZHWXpnTEZOVFhOclVx?=
 =?utf-8?B?d2F4Uk9xNzZpbE9ING00VW5vRnJqa3Z6d21MTWlOUzdJZVM2Q2V5eDUwSk1T?=
 =?utf-8?B?cHBENitMNEhrTE1xUjk5QStsSHc2L1BZSDl4ZzFrVHFTVENZQnJBS0pFY1k1?=
 =?utf-8?B?OEVqbFpDMzFZbGNQVk1CQnd1OEtGcFZYeERjUWNEbHFWTm9aRUYrUEF4MzBq?=
 =?utf-8?B?bnUzdTBwT2QzWlNpSnpjMmFTSWhoZ2toRzYrZ3haMW1KUTJ6QXJMeDI0b1pv?=
 =?utf-8?B?SU52clpaVXNsYnZkeDFIaTNma3ZPdTF3ajhIWGQ3TjVWNGd3dUFHYSsxbDV6?=
 =?utf-8?B?WDZMeVQwNzdqM2x0VXZqeG5SNEdPRWxNRGxIM04xMUNCd1JzZlIxbFV3eUp6?=
 =?utf-8?Q?oNt/DRR6nbShYklv1Q?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3364a66c-0ac8-4d55-5507-08de72ef5c87
X-MS-Exchange-CrossTenant-AuthSource: PH7PR12MB5685.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Feb 2026 15:22:31.2876
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ObwsaqhfVgEujivvym37aVRlFcjn2SUWXLOtHZw8Y5i7PdnDsTHnhcYGobYklASG
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB7096
X-Stat-Signature: dsaifmhazr4rnkei97xdd6c53uerwcok
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Rspamd-Queue-Id: CC1D82000A
X-HE-Tag: 1771860162-12673
X-HE-Meta: U2FsdGVkX1+3p5qoZi9jDxjCB1/rNGo1g2J7D2iqEtkxColGrXzMrYi4AahXZ0uT01dfCiU18T38FXEBSagmKK1xYP7MjOpVe63dx/BuRPC0aSpHmJky0OuZAGoEPAzpjtUDV0c4cuzP3uAD/Ewi/kAp/wNhs/Ihg9QL6dfeTMTrsSuDqc5SKf1m7poaAAPvvAZCwH+Jp06WzlA/LZSJ5o2POwVTgTz8IBcOxt8GwfG9i9OWYeNf7tsZj/MktbkRABYLyMMUk0e3KZ8LvMGfZl20Wkol4P1cHyYi1TWtojEbwa4yFq8rzvRUblo1JyzF01GfELfCEupFUFKMwGPajW6xfLLiGkJnLhNGqJT9pUPdo8+OGnFft5tJa8h8Lb9j3JgrQC+JpwP4S0woeorRZ5lEUqIsFfZZixw52ud4jwEJMto2aHL0zNnsbPW6a81jDB3xdjvCCLJCHOziMJGhMDnFNZ1wOKt903fhLwfUKZmeYchTKVOnBUxHBs2qllpVDgasXdoIgnJiZJCE1w3DC5Fzbe/hOj/vd3xlPGS8X0Fd/z98kMA2gkCM1ktpoMzQHZ0mP9qs9DuWLBrX+LUDbs9EfZzwmIB/Ku+A3Ql9f3x8kvR5U1Oi1fln823ZLGtRg64m0NJRYQSBQv5AbJFz+dO0urOGNBIvYLCL/YSuwCNKGnGvEosuoK3WngYDEyNoLrtn4yRCn7VOILcoLRTxSWsj4t5sMHYPs2lF04vJ/CexkSvfoLKqElrv3DqmscdodasTWxLyjo9ETandsgrg75V1/1BCSBFo9/Zv+8K3itI6nO7WgoAar/IJk8uHW84sq66+Nacq6Gr2reoALOIbLIuC1LKkDhztyks6x1HoltAiSlaA58mzVVknk/hsXZVlOeSIdY1qoFKgvj8GcNApuc7rpCCod+4BHf8pKjFj7SR0VE0TWLniqI2xFDRTWQQ0fIdxqhtC1KQ2ODlvFV7
 +JODFg7T
 ixZTwuUdG2NnR7u/6fEIpfF+37mfC+OF4L4f46EfNB4/J/NjRq49EOPAppR2bRWWM7NCxMcAmFNa1tewIXHqaItQNYF9/LbKNm22Cwotk6RMiycMb7Hm5Xw/+IwIczOdTiorP4Te/XhWI/XMZCl7KXBFwd2l9GeLUe/vvpj2uVdw4MtysL1LszXPbJlFnayH//LEZ6EfkHhfTzuKSSx8agxOe6gcHMZTv+J6DB/q7rPw/fy/yIPMM/VN25SpBwVYBJE3aivDTWDAMhSf8gG2ALqc2ZNSczfWjcnTf9C04uU6tG85JftTB/r3ocs/hYxYuUafnGarr+kRVjdjt4Rh759joLULMKmeKPZqGe2b7oesNS5F8Gff2bDhQNskYcDxMhhXIraBNcdTfHKFEuYctg3LNXIbhJfkEbBcmAz8D16Ma5srhpisolqpfG6Ug/S2hmYmRPJ1hsVKCxN4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2/23/26 15:14, David Hildenbrand (Arm) wrote:
> On 2/23/26 15:06, Christian König wrote:
>> On 2/23/26 14:46, Christoph Hellwig wrote:
>>> On Sun, Feb 22, 2026 at 10:26:30PM -0500, Zi Yan wrote:
>>>> Hi all,
>>>>
>>>> Based on a recent discussion with David Hildenbrand on page->private
>>>> is not zero when a page is freed[1], this patchset is trying to fix all
>>>> users do not zero ->private when freeing a page and add checks to make
>>>> sure all freed pages have ->private set to zero. For compound pages,
>>>> both head page and tail pages need to have ->private set to zero.
>>>
>>> Requiring the user to clear a field before freeing is just a way to
>>> awkward interface.  Don't do that.
>>
>> Completely agree. This is just asking for trouble.
>>
>> The cache line(s) backing this struct page are most likely accessed anyway on free/alloc. So I don't see much extra overhead.
> 
> I think the question is more around handling non-head pages when freeing larger orders. But maybe the overhead of zeroing page->private it there as well in __free_pages_prepare() is tolerable.

Good point, sounds like that is a bit more than I thought it would be.

> I'll note, though, that we already require page->mapping and page->memcg_data of pages to be zeroed by the caller, so it's not completely crazy. (see page_expected_state)

Well that's not defensive at all, basically everybody which forgets to do that can cause hard to debug trouble. Maybe that practice should be reconsidered.

Regards,
Christian.

