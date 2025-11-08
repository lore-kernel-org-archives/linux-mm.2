Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C72FDCCF9F8
	for <linux-mm@archiver.kernel.org>; Sat,  8 Nov 2025 02:40:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3006D8E0029; Fri,  7 Nov 2025 21:40:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2B0B28E0006; Fri,  7 Nov 2025 21:40:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 151B08E0029; Fri,  7 Nov 2025 21:40:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id EEBB08E0006
	for <linux-mm@kvack.org>; Fri,  7 Nov 2025 21:40:07 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 85D7CC0685
	for <linux-mm@kvack.org>; Sat,  8 Nov 2025 02:40:07 +0000 (UTC)
X-FDA: 84085885254.16.0F7A8BB
Received: from MW6PR02CU001.outbound.protection.outlook.com (mail-westus2azon11012030.outbound.protection.outlook.com [52.101.48.30])
	by imf07.hostedemail.com (Postfix) with ESMTP id 97E3140004
	for <linux-mm@kvack.org>; Sat,  8 Nov 2025 02:40:04 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=jSP5APgZ;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf07.hostedemail.com: domain of balbirs@nvidia.com designates 52.101.48.30 as permitted sender) smtp.mailfrom=balbirs@nvidia.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1762569604; a=rsa-sha256;
	cv=pass;
	b=5Olmw1RgjCMFUWE64S+XOJpvo3lQXw6ScBlcTJ+5Y6aY1KtuL5o1O/qgnjesFSu8+0Nsx1
	yAoellflKhJtNqvZUsrQI2QvsCWgMRVmVZj//IW2MuLmb/x+HNiByE+X+1NRlCA/u911zW
	Z2LATI79ryw1AfAvw7/HGQoWMHQqwkI=
ARC-Authentication-Results: i=2;
	imf07.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=jSP5APgZ;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf07.hostedemail.com: domain of balbirs@nvidia.com designates 52.101.48.30 as permitted sender) smtp.mailfrom=balbirs@nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762569604;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IDkTjdjSm8Po1hq7peLxFx5fEGu8QvdP9C2dukiZRbc=;
	b=Xj8zG4+ej1iZZXXvaJ0K/IT+fukuS1G51frSifiG4bmfh0x3Uz7Z592Xb7GLydanTNtD0j
	HWvJ0VAuAOrWgin9j1lIAMNzgHZNo7XuVomWmjJwW/SRrZfHbyuWMVg4ExylcMxBmchOFQ
	EzFOn/3KyXTU7wb8/0YwDAGV/g6vz7Y=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=nQN5x3mAv5UuQkkyGW1MsgJHYviIWAh/k6CE1XtdfMf5p6ZCy39Mb+YXNXQyiWyPh0GNFkngEM4x3yGN2rNMp1vMfhkZLAvj3g7M6hUfWzLm+dcPhPrDTorkIgF3twzRpcJzO46uLsVNddV4RFWPU+et2mKDbYndSsBYyTDKLQNZhq6ow5DYGZeF8FK0Q43J6z0HjWJv6u4O1BvtUSfWcz/p62ysWI4WqmsSAbszFeonfaobjzC0HWYvEev7luztNY4RTOT2cLxo7J+/oq6+mdhjzoAsl/RD6ckSSeu7GthVaMqvQ5VLTF+wQDu/lKpUXhLuNnDOAPRUF0auI8LFXw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IDkTjdjSm8Po1hq7peLxFx5fEGu8QvdP9C2dukiZRbc=;
 b=o9sbvrDDJDQj4zHBGFl22lCQ9ZsZiqdISL5A/YvUm4QjQVyYo3qeBK2C94NCsvoMbwgguyObOie2fGbtUbEoWggIbTT9F6F3uVjXZQqWQyHa/aDEUcht6L6EMSrU2/EDAp+g76h5jjELyusvQ9SO1OxmgPSMiEpNpXza0aGZclyUodjJnLiLrhWKp9arpJdJfZAlRctwDY/xTBEUYpyFhwT6r2OlX7pXl9EgvtJKzN1I9bt80W8EwTR88iEDh+Y/xKR9gWPbfAkbQZgjw32dfp9y7bmJp81bWvhcv3806w/1LwU9F2kp8lzRwTg/qwsboZbvzqwaK9u9VyMNK44sHQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IDkTjdjSm8Po1hq7peLxFx5fEGu8QvdP9C2dukiZRbc=;
 b=jSP5APgZoo7of6k8Y2lJzwwPacIolqMdeknDPeYg3KFVdoQTQDMBzbj3WTzdHlmqPaWu1GOUckH2pPVZGbiYGQt4Fr/kcD8k5pKeFkUL9IUzXn477ZrksIexlrUCHMmLOUA7jlLBgIYY2dtZktu8t1lRBo3/kKEC97wofnb9QryOgKsHOPNDtxOUG+5LsA8b1kSg61Ubrdlr7V0DPdvTBg8erex2u1hzv6LGXoIFQz9QZt2NYtlr/ICbkSS7o7sJEVxscgwYlQ27Fz7/mfhhio1Z6RkncQuBkfdD6uglalKDXx9TQawM4Fyxp+ir4qw2tD0Y8z1pKr+QHdYZcjNMcw==
Received: from PH8PR12MB7277.namprd12.prod.outlook.com (2603:10b6:510:223::13)
 by DM4PR12MB7669.namprd12.prod.outlook.com (2603:10b6:8:106::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9298.13; Sat, 8 Nov
 2025 02:40:01 +0000
Received: from PH8PR12MB7277.namprd12.prod.outlook.com
 ([fe80::3a4:70ea:ff05:1251]) by PH8PR12MB7277.namprd12.prod.outlook.com
 ([fe80::3a4:70ea:ff05:1251%7]) with mapi id 15.20.9298.012; Sat, 8 Nov 2025
 02:40:00 +0000
Message-ID: <d6ad21dd-82f1-486e-8a0d-b007b39b4d32@nvidia.com>
Date: Sat, 8 Nov 2025 13:39:54 +1100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] x86/kaslr: P2PDMA is one of a class of ZONE_DEVICE-KASLR
 collisions
To: Dan Williams <dan.j.williams@intel.com>, dave.hansen@linux.intel.com,
 peterz@infradead.org
Cc: linux-mm@kvack.org, linux-cxl@vger.kernel.org, linux-pci@vger.kernel.org,
 Ingo Molnar <mingo@kernel.org>, Kees Cook <kees@kernel.org>,
 Bjorn Helgaas <bhelgaas@google.com>, Andy Lutomirski <luto@kernel.org>,
 Logan Gunthorpe <logang@deltatee.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@redhat.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka
 <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 "Yasunori Gotou (Fujitsu)" <y-goto@fujitsu.com>
References: <20251108023215.2984031-1-dan.j.williams@intel.com>
Content-Language: en-US
From: Balbir Singh <balbirs@nvidia.com>
In-Reply-To: <20251108023215.2984031-1-dan.j.williams@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BY3PR05CA0008.namprd05.prod.outlook.com
 (2603:10b6:a03:254::13) To PH8PR12MB7277.namprd12.prod.outlook.com
 (2603:10b6:510:223::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR12MB7277:EE_|DM4PR12MB7669:EE_
X-MS-Office365-Filtering-Correlation-Id: d90039ec-6e7c-4c0e-0173-08de1e701ce7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|7416014|376014|10070799003|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?QkxLYWM4NjZ1Z3NSTWt6MTdpNlRLZ3pmcjBFdCtOSGlGZjBmOHk0ZEl4MG94?=
 =?utf-8?B?dGdIaUx1RXJ1VEJjWU5IWnhGdXh2cndpNXdwL1d6SERlTjF3WnFsMXUrMTJW?=
 =?utf-8?B?djZKQ0ZOZmtINXpGVmxkRDNKQ05nMEJuRFNQMlorZE5UWnBJZlFKRExPZ09U?=
 =?utf-8?B?dDE4Vk1IWWdTTVQrTTcyZmlPa29zVzlUWUhBSWVVVVJOaldzNWp6TzhYWW5H?=
 =?utf-8?B?dWxJWm92Z2M4cVVQbEQyTktYMlRUQUhJV2x0QjVRQ0ZiRk44Q3MxN2l1ckEx?=
 =?utf-8?B?Q0xSbWp2S01OSHNITnQ1VlZsNFdVK0t1RTVPN0IvZi85aHR3NHJRdW8zY2l1?=
 =?utf-8?B?TkdPTmNQUFJ4Nm1hSzgyVGZuRjB6RWJUNjZHcmRtdGxxWktON3FocUNQcHdJ?=
 =?utf-8?B?dXFwYnZ0cUcvbUJ6R25BUE9NVG4yTVF6VGthcE5xVEJUekU5VDVWSUNOL1JD?=
 =?utf-8?B?cnViVzdCMVFNK01UdDZRVnpienFYU2xwcVFxcElWa2FUUkpUaGR5TE5sT2dO?=
 =?utf-8?B?TzI5Y0pnQlNHOUQrb2NFTkVoaTEwRHg1VUVYeWo4SExYK3hwaXoxSW9MZElR?=
 =?utf-8?B?VndBRkkzTThOdDNaZ1hIcVNTN0EzRnBjMmJHSkJ1UDBkT1I2V1pudllOSXEx?=
 =?utf-8?B?Y3ptdldzTFErcUdIUzJCVmFBN1MyM2lzZDdLSHlub1ZMWURkTEVDOUxmUFB5?=
 =?utf-8?B?UldReGp6OHVOWE00Y3V5WkpLcDRxVXI5dE1YbGxYMHJDaDNBOXU5eVdIOVZ3?=
 =?utf-8?B?cll4a1Q3WUhIMlRHTTV3WkhScWgrdGltZFBXUG9hYUtLRXN2UG02M3NEZmdS?=
 =?utf-8?B?T1ZxdGw2b0hOV3Z3MERwem42MlU0RHpBZHVoci9MdHB3TWlkSFRIVzE1NG1X?=
 =?utf-8?B?c2p4ZkRjNGVYdVdkVTYzK2IwUzljMVpvdDhuMDJjL1ZHU0Vac05pWmwvSmVo?=
 =?utf-8?B?SlBlcFRPVnFsR29JVlZnSEpJd09sMnFWUGJJNEdpZkx5dVhENXAvN0V4Z0VR?=
 =?utf-8?B?K1RrdlJQMTM4Y1JoSXhRVm1jZktCZFE5WFpaazB2V2c2dkhpZ01kWnh1R1VO?=
 =?utf-8?B?UzZOYXZyYnpyY3VHeWRpRW16VTUvYUVJNDhtSC9ySngrYWFYQk03RW5Benlq?=
 =?utf-8?B?WUdOdzIzWXdYc0xFTnhRVlh5WHZncGZNR1F0TWdwS0laQnp5bjVUdHlFWkpu?=
 =?utf-8?B?TmtxWHpJL0p0eE14U0ZyMEdXS2ZOMTdGeE8xRGJ6dys1VE5adFloS08zRzVn?=
 =?utf-8?B?WDdkZUw3QVRiUkhNdlQxOXZBNHhVV0lNZ0YyY3hvVmpXaVZHU3Qva0szK0FO?=
 =?utf-8?B?WXJvRDRza1hoRmdzeDRFb0szUndlazVrZWNMRExjanhYVEQxeXo5VFpDZThG?=
 =?utf-8?B?K2hRYVZDdGRSTWpTenFQOFZLR2hkZUc5UmJWdENCNFhHT092N2dNUHBLbEQw?=
 =?utf-8?B?dHVsZWxXWTRObllsZUlZclc1STR4WnExcm56TDR1VHI2UzFzRnN0eHF6NUZO?=
 =?utf-8?B?V0dKVHJpVmdVRVJ4QllTbTdOYjFQbFM0ZlY1cTV6dWcrTUxib2hjZjZ6SDJD?=
 =?utf-8?B?a1BPQVorZ1UxbEp2THZRSS8wWk9EYWF4aXZubldyaEhTeS9TUFZMYUh3eXRE?=
 =?utf-8?B?TDd5OUF3UUNCbFhLb0ZaSURGSC9vbDVTTWFOT1dPQjZKdy8wZEVLM0hDTC9Q?=
 =?utf-8?B?YS9Vai83a3ppWGFYbThUZkl2OE9GVGNGQWovRWdLdkZOZUpwYVpqWW11aEc2?=
 =?utf-8?B?bWFESFJQck9uZFF2TmxDbVZJYUZGUXdFcC9GMlYrTXdzQklJNFVaL0Ireklh?=
 =?utf-8?B?aW9yZHVDQkJ4cWN4YXhmY2JuK2dXOUhwQlF3eFZlUkxBaGpTMEIrUXRkSlJJ?=
 =?utf-8?B?akRuU2l6ZmlCNnhtdjNMSzRObklLSDdVWjk4elNwTmZVcEhHSm9pSnFEaXRr?=
 =?utf-8?Q?jtajltok8+LQxg0Ts04FtjKmaSF3fJXC?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR12MB7277.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(10070799003)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?eGF0bWREUkZIMGQyZ1FDNGdhMWFCenVmSnlKNTZicCtXVHdRTXQ2VXRGN2t5?=
 =?utf-8?B?ejFyQk4yam9LMWhmMTR5UVJFUFViTmI2VEtJUmpqK09KbXl5K2FBNE13bEdq?=
 =?utf-8?B?WG5QS0dFMzlqZWNwT3ppVjlYUzArRjlqZk12Q1FaeHZCR3Y0Nzh3UENqaTJZ?=
 =?utf-8?B?K3ppaU5NSHo2UEFtNTI5azI2VHkyVHdoQUdpcERaM1lFRS9DMnpiSVlaeGlH?=
 =?utf-8?B?Z2w2QmhIbXVVTnowVGRQZnN3WURiZVVIRXVBeDYzcGhmSjEvZUREUWl4ZjBh?=
 =?utf-8?B?aU9KUmF4YWFxT2NPNUZxYjdYRHJOZmtNbkhsUkNLa1d6aXQ1SW1NODlMQmJx?=
 =?utf-8?B?STgwM2RpQUdrVEllblRWZ2haZHY2b3F0VUtMcHVzNVlTYStmVjh6Nm1Bajlu?=
 =?utf-8?B?WXdSKy9CbmI5RUl3ZXJWZjZXMEcyMU1pbjc0ZGx0TGs5SjJ0OXhpYXc2blZS?=
 =?utf-8?B?dDVjeXNIbURrYnhYdjRsQWhvNGVrOGRQK0NzZFNBbFVqN3lFUUF0QzBpY2hR?=
 =?utf-8?B?M2JockwvZ3NmR3JSQUZsSDFHMmlPWW0xYk03RDVKTjFjRy9lcU1oSlg5TVdx?=
 =?utf-8?B?cWp6UWJ1WEFRcmg5ODVCWkNVaEgrdDBsRVVWdFBtMituZ1JGY2NZSXZKMDRa?=
 =?utf-8?B?US9leDZ2OGIwbWI4Qkp0c1VsUnR0cmFYbEVGUVpKYUY3blYwb0gxL1pwUGJU?=
 =?utf-8?B?Y2ZodkppOWlCVGMwVVo1NW1RWk1zTG51UllZeVN2TmQ0YTk3SkxlSGhTQk5s?=
 =?utf-8?B?UGJmTUgvcDdZeFhFY0ZPV0RVNDFHQlRqK2FvK3R4UTRzYnBBV2czZGlLajhR?=
 =?utf-8?B?VDBybXhualUrQ3laSVhmSnMwYkZHWHVkWTlpbVpnS0NiNVVYVFNiZjJvUWd2?=
 =?utf-8?B?d2xkV2QyaCtSbXZweGZObzQyaGFxQ3NKa0poMERtSWR1bGYvWFExb2hRQXFu?=
 =?utf-8?B?d042UlA4RUdOY2RvRnBPeGtMSkJFcEJtbDhxS1dxRmJqY0hYWUJUUTdOV0xD?=
 =?utf-8?B?MEdkOXFuUm1BOWZVK2F0Vk5JM0d4elpXY1g4MWw1c0VmTFlmVndTSVZYV2N5?=
 =?utf-8?B?NDZwLzFHd29zM2ZITWcvd0krZUFSWjNOTXhGeHpwdjZGNjFyM0UvaDJyczFC?=
 =?utf-8?B?Y1dyRkJkeGUvVTd3ZFFSNXh4dG5sVXU5eVhVOUFPaGlnVUhvTUQzRW9BM3Z6?=
 =?utf-8?B?SnpXZ1pHRzVDcjJEYnorbDVOeU9NQXJGSDJuTzhGQk4wY2JhYzFMZ0h5NnF1?=
 =?utf-8?B?QlFmN2lZQ1pmVTZnOGROWGFJRSt1ZEpNUUVmY1d1WEkrWDVLL2RqQUREUDBq?=
 =?utf-8?B?VU5uamdIQmlKdXYwQ1RSNnRGVkYrTnNqU3YxTDlOSzF5RlRCaUgrZkZyQnFp?=
 =?utf-8?B?ejR3K2NKQVdlOXJCQjh4SS9vT0hoZ3pPWkFvVk42LzU3TWxSTDFvRVkydmJY?=
 =?utf-8?B?eEQya0pMVi9jcWNDSW1tNHZQbFpCbFcyZzVNL3FHcGhsRmtwcmlOQ3p5S0Jz?=
 =?utf-8?B?STdSK1NiMUphb3FGWk9WRmNtc25SRytLdXVFVE8wTnVhQWlKaTBJbmVyMndB?=
 =?utf-8?B?WXpTVFJxTWJsZjlJeVArcmFhd2JqSWJ4U3h6c0s3ZmJyaEhvL0lLV1g4Z090?=
 =?utf-8?B?YWI5R3ZtVEdHYVZLOCtIRkQyOU1LbUtxVCtIbkVkeWdXdXRNY01QOTZBMGhl?=
 =?utf-8?B?UnV4b2lENmlMUnhhYUd3U1pSZGtjWlNJbVlSSXBrbEtBVzROTGs2TzZObjlC?=
 =?utf-8?B?cWdkRnR2ZE92WjJjaTFiOGhIazVKQTdRNHpGemwyS09ZVzkybjlOejVCcHo4?=
 =?utf-8?B?R0RETUdBVmxJc0ZTSzNHT1d2UXorN1lGYW1FemNjZGk3Y1hsYUZndkRHdFU2?=
 =?utf-8?B?a20rOVRNNVR5UWp2T2s1WTIyVnNNZWtxdVFleUtxSHVGVTFHK05GM0t0eGp3?=
 =?utf-8?B?RFFDYWFtYTNrck9GYWovMi80cmsxYnVhOHVGd2ZRaWYrNWNSblR1OGFBd0dE?=
 =?utf-8?B?ZkxvbHlROUl0V2NUVWhqUW5CRDBaMUtXYmE3YXp5RGo4OU9FR2JTVldIWGdV?=
 =?utf-8?B?YWpaWVlWUUFCVTBmUmJ6eUNRRUN1dEV3WE42SGoySXNVa3NaektMVEdQZThm?=
 =?utf-8?B?bVQzdG5veFRKM1pVaVpjUXg1THRXdDJVS0dBYzQyK2JNWVFNdlhpYjUwYW1H?=
 =?utf-8?Q?8ZzxOJBRLqVg+vr1yjhShVIygTEoEmgjR7bAB9c8B//3?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d90039ec-6e7c-4c0e-0173-08de1e701ce7
X-MS-Exchange-CrossTenant-AuthSource: PH8PR12MB7277.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Nov 2025 02:40:00.5709
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: aaMiCGCT4FDYTOvBWJT0Uux6Kotn6mvpC7w8WnQICMuJt/oPV3PhPhs3Yda23Cm6dYEHaSpqCiNxpMCQoZpheA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB7669
X-Rspamd-Queue-Id: 97E3140004
X-Rspamd-Server: rspam07
X-Stat-Signature: o9eqwxaisjs8my57wbd7ky9tfmughzsb
X-Rspam-User: 
X-HE-Tag: 1762569604-851666
X-HE-Meta: U2FsdGVkX18c+jkCm3eQNbIOFdE4iqUfM5CjuXY5yBV4a3T0eOPsMjkegjTSEALWJfM6YaqgwdxXUQ9dJnNj+IlfyTXRwk7hfw+Fx6ncj6J9qqsjDkL3UgSXdxzcelTZ4/SgCGNUoeKQSzeVhBwWVx138dfKDwwQaKIZgouW3tkINr7oPK1eQ/HQun6EZcha6jP+jQvHaZXZagc7QptwTOFzxdH3QlwOUIFoMYjrXDHdHKl9OTjWFIDI8bHAN5R17r1sPCkDj8HO5M5WQoiHpUJZial3suN8WfMopYx3LLBUyBvFS/O25eJ4MunLMK4jw+5sV1EB5M80kbTKVgHD77uh2XzUOxE4uSMZ/UWIgfY8bkK/BIuZ+B10O5Q3s9L+pXlkF+ZPDbYNE8Cg9ro/OfcYrtbhwhYaa0dLe0czICrcW4MjLGu7eHGedCJtFMld398HpRZ4OHQmkSrYYWfGwUBqvq4ltbBb0pnERfpBjxYa59x7fkcPlpdtIP8tFzy5mYo2f6/LjzAEzIxRUqDEwdv87QRbOSKVs1TW4X1eaER3nUJLX205m+zG1ZuaUh52lA1rzGEQGsQiZG7U2k+09zk8/I+hbU+qzaFwqmie+B4dFcnoK3OFAHCgH4Wt2MS/vXL928S+DEiT9hSk3qn6tZJvC7fCjfOy2mJox3OzlUn2YRX3NCJhZZQQ1tmU8mG3s9QV6OmNjeVEJewqQJ+4OWjx5vOU8OvXJml0EOyRTPH0JiYPtaP7haUWbQMkcgvFger1UUtC10VqY4/t3nYmzI7dK/oufrWFEfbemjgysmFmWWbBFd4u+SdrNxAsnyOlEq5nb6lnVGQpHcCSWgrEkZ7NJBIYLUrgw0cU7KDDvtUbDhZ22uOCMX93e7qbKxaAMV5tKMajvENWyOE3XvIitweuMgVe6vSwZmpZHI/13u+UoN588uJL/PuLoNyYt3epbqq5JZMQLP28UqzQ4RE
 uSTIMCrl
 Qreh6Txbqz8ZUkxeWpqJk9GaiR/cY7HjiSqzDyV49zSEABBL4fTFxgAaFSlSvEKNoW6LEPiF0UrmkDyr2KZriRrk/2FBCiGzF9u6D1ZqGaY52lHQcL5FDqF97KSmPfDF+TJtOHNHiHrCAbOvJzv32mH4NRWmV62ec3EpHuDTKMCCMuR9pVFiVj4SwyD2K4UUyD2+3iYZtrz6CN7v9b0C94l85l2qXYqAzNMKbD5t/1buw+818/7+MHfXZYQOp/LH5QZlFytpxPWJ2dIfHTy5Yyc5XpzsvXAJhK0HwnfVJFdWnQM+Fqn8F59EZLudbsiKmSYBFNjHBFzjzPyZppChZbn6BxaAVVSCNbGkyhjfbMhqiC/cKfKSBlc3jxiuNeTQhdIzlhLvJE5l1O5iLYfBZN8k8FpaVX/0yOhFHCTSGojua8ud2L6nFYlZ1khVD4ciK+VryYhNY3rvXpwsSE2WD3ZaRexlVUjZWY/WDIDT01RF/X9kpHlFxmiM+kI8ZDZ8rhEVkAxDt6AQXmPaFDX92aL2uuB0RKZWMQHpvOJ9xH0BrJ7ucrSnaKakN49ANJqQsBXYfD8OGoEcN7TaFX2X3MLCPA0yUQjePn3YFyI8CAP9ou3eA0704QySAxKd2w2xOdBcvrlKbAoEkNjsS/rhreWdDCWzlARegvlyzmeN/m+RYLvj31Zl6rqtiwSX3wNEMU4Jdzm+Z10jqYh2Z+TDDw+SSYcroXY+HIZiI9qrILGN+DmWd3pDogrxCgh1ay0fnSIIqoZT2+88FIjiqpdlYc1HLJ6tumH+k+fs6HATDWVF5648lFkpUTTPGeesWVDMuZhs50Z6lTojuioZqDnfzht+mLi5Ff8Z7HmVASJzjYC8TCvQFZBiSjw+BnV9ST2DZOMnd
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 11/8/25 13:32, Dan Williams wrote:
> Commit 7ffb791423c7 ("x86/kaslr: Reduce KASLR entropy on most x86 systems")
> is too narrow. ZONE_DEVICE, in general, lets any physical address be added
> to the direct-map. I.e. not only ACPI hotplug ranges, CXL Memory Windows,
> or EFI Specific Purpose Memory, but also any PCI MMIO range for the
> CONFIG_DEVICE_PRIVATE and CONFIG_PCI_P2PDMA cases.
> 
> A potential path to recover entropy would be to walk ACPI and determine the
> limits for hotplug and PCI MMIO before kernel_randomize_memory(). On
> smaller systems that could yield some KASLR address bits. This needs
> additional investigation to determine if some limited ACPI table scanning
> can happen this early without an open coded solution like
> arch/x86/boot/compressed/acpi.c needs to deploy.
> 
> Cc: Balbir Singh <balbirs@nvidia.com>
> Cc: Ingo Molnar <mingo@kernel.org>
> Cc: Kees Cook <kees@kernel.org>
> Cc: Bjorn Helgaas <bhelgaas@google.com>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Andy Lutomirski <luto@kernel.org>
> Cc: Logan Gunthorpe <logang@deltatee.com>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: David Hildenbrand <david@redhat.com>
> Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>
> Cc: Vlastimil Babka <vbabka@suse.cz>
> Cc: Mike Rapoport <rppt@kernel.org>
> Cc: Suren Baghdasaryan <surenb@google.com>
> Cc: Michal Hocko <mhocko@suse.com>
> Cc: "Yasunori Gotou (Fujitsu)" <y-goto@fujitsu.com>
> Fixes: 7ffb791423c7 ("x86/kaslr: Reduce KASLR entropy on most x86 systems")
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>

P2PDMA requires ZONE_DEVICE, Most distros have P2PDMA enabled, you mention
smaller devices - are you referring to kernels/distros where P2PDMA is not
enabled and only ZONE_DEVICE is?

Balbir

