Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 904ABCCFA13
	for <linux-mm@archiver.kernel.org>; Mon, 10 Nov 2025 13:08:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A9B858E0007; Mon, 10 Nov 2025 08:08:16 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A73438E0002; Mon, 10 Nov 2025 08:08:16 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 961C08E0007; Mon, 10 Nov 2025 08:08:16 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 7A3FD8E0002
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 08:08:16 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 1CB09C0D48
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 13:08:16 +0000 (UTC)
X-FDA: 84094725792.21.0E97990
Received: from PH8PR06CU001.outbound.protection.outlook.com (mail-westus3azon11012013.outbound.protection.outlook.com [40.107.209.13])
	by imf08.hostedemail.com (Postfix) with ESMTP id 16125160017
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 13:08:12 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=DYfDQ64T;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf08.hostedemail.com: domain of shivankg@amd.com designates 40.107.209.13 as permitted sender) smtp.mailfrom=shivankg@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762780093;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2lvjpzBladOlw/mtH7fYmXutsGcPrHg1byXFTaniNxA=;
	b=wlKBO6jkO9p6aR1hvBw4cXTsoaQOic2VRj+iQLtIJbJczH/77W+K4qLZrIo2Iy65ajOMDk
	1rZQauJIYYHUatO1a8pJ6NZcncLLTu4KS6tctwgB8eeMLdC+ETAHWPiPzVrLZsE4fRFvre
	aW/BpKpoo7MbxBKPLH0DpubfmLl516M=
ARC-Authentication-Results: i=2;
	imf08.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=DYfDQ64T;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf08.hostedemail.com: domain of shivankg@amd.com designates 40.107.209.13 as permitted sender) smtp.mailfrom=shivankg@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1762780093; a=rsa-sha256;
	cv=pass;
	b=ItdPCePl9t817VpPUVDwhf2AbkcbkJ6WZNEBgttjhzvJvm75CgMf4KYisDvaM70abOymVq
	YC/o3WcbpUdTvRqhVmEamx2BH7X1YFMl5IkZ3ulOP9HQpnZlNcqzgCnpDejrIy2TKIuoVt
	iGWV7sw4rpKaL/b+NXQ/F60lLBI8dqk=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=YPxbadb196aUr1t/E4uk5lRdqBo5RLmUkX/GKWxN017Z0+W3P8FEs0n0rPh8EMLX6ITsv3/5uuJXWlPyctKGvj+U3o9w4w2JBJlQqJfNb/f3+sqOWzCuzpIOP2GWZgpo0y1mYV++Yffr2hsS5bGgJQXOym9uBeJf24XusjsQzkuc1j6SUx5r+wcRoyX18i0bPBsm8AAqoBXCISgLWV5daiBJv3A1VaDZjxdOXpCLyVf8x2d068Gd5kgmNBJnjS14cz4be74c72pxmrZwU7mxSPY599B2GlVADq9iBcatbCk16BJybSnxO4he1GuroRXTlmzDPHHcpN8VtXZuL5DrDg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2lvjpzBladOlw/mtH7fYmXutsGcPrHg1byXFTaniNxA=;
 b=ypDDWKFSvAi4p1lrZBSTBs5tPFrgeLorxUBNOlv19v8NUnc7aZrCTvC8W/VuKKQrr7iEEG8DOe5XY5zC1BVvHlIpHYCqO0X/ySyFM2+QVGzynB8L5OQ4ajJ+53kavMXkxZisAXeRgnpUzlQeLLYvibkgf22LiFtfFSXjUn32umfL2oTfm/1VUUmocsLByZYyGIXL2GB8407R5MzPmanZLQIZjN3b2zXd68/SO7W3NgZx1Nne8KKS+OSOX7WhLavYv2THpPZcctnPvUw4PYPznKa69/8MR3zVwpnN46e3oL6VYzk2e0swQx/e433tV0Ylvm5VnnsT0JA7t+eqSinO2Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2lvjpzBladOlw/mtH7fYmXutsGcPrHg1byXFTaniNxA=;
 b=DYfDQ64Tm0J04DtMVLSS+Ajk3mgYiNtls8n7er2lk2E0zUAHdTxshBhoH443p8wNYm8dxddn1HfhKVfxP1iKfuu6N6cMl76DBnA5TQP9TZpwOPlm9TYJ+YLVPTrsvP9FvhQrAh/g3/37/HOBHdfCe56rauVW5LEYhWgK8YSfODA=
Received: from SJ0PR12MB7458.namprd12.prod.outlook.com (2603:10b6:a03:48d::13)
 by MW4PR12MB7168.namprd12.prod.outlook.com (2603:10b6:303:22d::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9298.12; Mon, 10 Nov
 2025 13:08:09 +0000
Received: from SJ0PR12MB7458.namprd12.prod.outlook.com
 ([fe80::83e7:e6cf:26ed:2f3d]) by SJ0PR12MB7458.namprd12.prod.outlook.com
 ([fe80::83e7:e6cf:26ed:2f3d%6]) with mapi id 15.20.9298.015; Mon, 10 Nov 2025
 13:08:09 +0000
Message-ID: <3b10d11a-3c75-4c37-8810-e238113ce75d@amd.com>
Date: Mon, 10 Nov 2025 18:37:58 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] mm/khugepaged: do synchronous writeback for
 MADV_COLLAPSE
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@redhat.com>, Zi Yan <ziy@nvidia.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>, Nico Pache
 <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
 Lance Yang <lance.yang@linux.dev>, Steven Rostedt <rostedt@goodmis.org>,
 Masami Hiramatsu <mhiramat@kernel.org>,
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
 Zach O'Keefe <zokeefe@google.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org,
 Branden Moore <Branden.Moore@amd.com>
References: <20251110113254.77822-1-shivankg@amd.com>
 <f21b37bb-7a2b-412b-be76-e8968b4c375d@lucifer.local>
Content-Language: en-US
From: "Garg, Shivank" <shivankg@amd.com>
In-Reply-To: <f21b37bb-7a2b-412b-be76-e8968b4c375d@lucifer.local>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN2PR01CA0196.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:e9::8) To SJ0PR12MB7458.namprd12.prod.outlook.com
 (2603:10b6:a03:48d::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ0PR12MB7458:EE_|MW4PR12MB7168:EE_
X-MS-Office365-Filtering-Correlation-Id: 9fa8b708-cda8-4a40-4db2-08de205a31aa
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?RmVDT3h1ZTAxTnJJY25oNFViT2oxaHZMZWl3NFl4NGoyWnBidlpZeDNvaGVR?=
 =?utf-8?B?bEdvMzlIaXhtT1FZdm83WUVlT2drVVpZS1J1VVdhRnBGVmNYUVNFRkNBbUhN?=
 =?utf-8?B?L1dmM2hzemFCZFhqODNJRmxncjRyeExYNzZQV0NxL0ZIeTJWQ3AvaGpmaUx4?=
 =?utf-8?B?RXlpOTdOcnBXc1B1RU44VDIrNUpjYmhPbjVyUXdhWGxkaXhuZ1ZiRmN3blhQ?=
 =?utf-8?B?VmFMOEovSzUyb09yUTNtNDdIZm42NyszcHZ6UlE4VUJVWFlUekFxK1pnelcw?=
 =?utf-8?B?SlN3T3BJQnE3S1czNkhFUThJUG45R0orUnNKZnkySmVJTGJ6bDUxSmpDWW53?=
 =?utf-8?B?T0JpTzhsaktoSGtWR0lZTFJYcUVpcm55Q0ZnZ2ZFMW9uVDBkRWNxUzNyRG5r?=
 =?utf-8?B?QlJzZTh2WUdvdWZHQ0FFVmlUOFBOUHpJNGUvVUVwZ2VVM2t1NCtaSFBZenY2?=
 =?utf-8?B?alF0ck5LUUlRMFE4RWtaL1R2OENUNVcwWTRSNWJmb2pPL2dhb0h5eU90WGE3?=
 =?utf-8?B?NWVYZ3VGbFRHZDJzd1VTZEp1Yk5YK0N5aTI3R0JxZVpLWXJTTGR6ZXB0TGpY?=
 =?utf-8?B?enFONm9QVGpXQlA3NDJhNVlNYTAwRGJJSURKUUNveTVKM1hlOWl4WWdFaG1S?=
 =?utf-8?B?U1dFNFFwa2NMSUdsdkZZQ2NGb3BnNHFWWlM4UnRlZFJ5Y2ZXWnRLd1gxWG05?=
 =?utf-8?B?cHBUNi9XUzVTZExubG1OMjY0SEdzNlhqWlozSHdEd09oY25QZ255cnYzYkNR?=
 =?utf-8?B?NS84U1NvWGppVnRDTHhmNWY3TWdiR1hIY29HZFdtdVFaMzFxZWg3Z2RxNC9s?=
 =?utf-8?B?c1JMZzg5b3c2SWVzbzNlV3g0ZEw3dGpVbTErUThlSGNZWVJxQStTcFJXOHRQ?=
 =?utf-8?B?NVk5K2RnSXhMTnF5WnU0aDlkdnNlMElTempBQkVmd2tQbzFuYjNMYjVaZTFH?=
 =?utf-8?B?TTJKZmFSTFRKbGJGYjF5WmkvUnJmaHFoQitrYUMxQ1FDV2dUbVFVUEw2dytZ?=
 =?utf-8?B?S1c0SExwWmc3aTVESTJEOHVkbUNVd1ZqU1lNNjhtNVY3b0VCNFhidWlyVVpt?=
 =?utf-8?B?SnZZTTlqczl3eGg0MmJLQmIveUcwV3RyeVpicXZxclFWL1NpSHluSFJDdkF2?=
 =?utf-8?B?MzNzcS9JamREdG8vdEpwOUNRVlRYSjRpL1dhOUV0MmZjbjh6SHY0cDZZTTJq?=
 =?utf-8?B?a3BWK0ZhUjUyMFhydW4zbnplNER6a2tCUDhhcUFsVWV0WnBFbnVVVTZYYmlk?=
 =?utf-8?B?RFNQNExrOTdNKzZTaU1HUzhVS0wzZU5rbDhiYUxrc0ZaMVZZZnJOZ09Gellt?=
 =?utf-8?B?MC95VkFxMTRDcURiWDVzVkhOd25DMWU4ZS9HV2NIN0dyeDVFV1M2cjNXS0tU?=
 =?utf-8?B?VlFCNldCaThuY0dwaGV2RXQ3bTlHN2Q5cFAxN3JsQXFyZTlnYkJ4UHVlUHFi?=
 =?utf-8?B?dEhkMDdvK1MwV2tzMnlZN0pMUHVTREEwT203R011b1I2Ym1WWkpvc0x6V2hi?=
 =?utf-8?B?K0d6bHBYTGFxNk9FMVBBU2tUWkc1QW11UlBJR09DL2hkeTBydGxKSVdobUJ2?=
 =?utf-8?B?R01CUlhPUm5MSUhqYjV2aHd2M1RhcE93YTJDaTBIcDBQUTNMZ3o0WWtzZjBt?=
 =?utf-8?B?eFk2b2dwMnp2UVVUU2tDU3FqV0ZkeGJHQlVGN2UrQmR2YVlKOTVwOUlQY3g3?=
 =?utf-8?B?cC9Dd0MzZHNRU2MzTUpxYWVJaEZoUEFSSWpZek50bU5Say93WEJKN1dRZ3dX?=
 =?utf-8?B?MWJRbnUwWTFwUFBYRVFCMWhFQ0xzeWF4RDhwRVVBRUFhRm1KY3hlZm9XV2t2?=
 =?utf-8?B?ejNJKy9HMHNmOHJGR3lLcTRtUHQxbk0ySnpXb0M0blJXdmpYOTNTYjlVNm1h?=
 =?utf-8?B?cVUyQkN2ZHJ5V3pqYUlXcVkveGJhVEFaVTlqaTJwTjNlL1U1RXZ6YnVFZGVF?=
 =?utf-8?Q?R66bNsvVsCniGyc7NTVEb0g58+D7WB96?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR12MB7458.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?Z28wL2FHUXFSZjhHTjVsMEU5Sm1yL21kbk04YWNKQmJZYVUya2ZYdzRCZnhZ?=
 =?utf-8?B?Wm9CNjVXTGNUV3lTd0ZGeG9jYkN2b0xramxZK0ZsS3pnL2pkVVNqWlpkWVo1?=
 =?utf-8?B?WDVBdVIxSXFQL2ZsVEpqS3M2bnMzRE4xVi9yN3lTNW5WeFd3cWxzbWxKdlF5?=
 =?utf-8?B?azlCL09UdEFONFFpa2hQamJMSUE4WG5qSmphU1RFdERtZkNVSlJqMDBhZEdr?=
 =?utf-8?B?TVBENERjcks4ZFZ4VS9PUzJ5UVUxZ0JpNC9oUE9aZjhnQ292NDZXT2NSR21E?=
 =?utf-8?B?bXhZT29nd2tWdHdadnBjcm9uRTlTS05PMjJsallMcXlQNlBBQVg3bXlBT2lO?=
 =?utf-8?B?dXlpR2kyNUJlcW10azZxaVI4eGIrcTBGNmFEUTNWdUpYZnRJNjNMMTRsRDlC?=
 =?utf-8?B?eElHZnhSVmRQUzRDWVJ6Nmc4cU1XNkowZUExQk1PTlJzWHhJYUF4bldocGox?=
 =?utf-8?B?eE1Udm5Ic1ZwOGxzNS9DUS9OQmt4NlNGNnZwNytMbDBMcm9ySm5MV2V0QnNY?=
 =?utf-8?B?SGNQZXNTM3NzNFd6SHZJSHBrVXJZM29sazJqbGFRbTgwZ0pFQ3ZKUkFtWnlI?=
 =?utf-8?B?QXRoVlV0dDlIaGhsNTZrdThUbUdNMUpYYjdqL2hsbXNhbFRmdW0xNmp4N05l?=
 =?utf-8?B?cXhCN1BxeHQrUllFRFA2NlFCV2lrSTh5a0dPazZRcjRyYUsyU1BZM1U2MGJU?=
 =?utf-8?B?RTZiM2tGNXF4cmJyT0kyemFqbUl4bDFLQUtEa2lKNlhCWnZmUkk3M2ZBdzNm?=
 =?utf-8?B?M0ZFMC8yYzZJQmo0bFZtcDRBK2JIYm44VnZGK2ZRNmJXWlZQbUZRMVAyL2Ri?=
 =?utf-8?B?aEN3TlhmeGVwZjV4b0pNVjZiSDdjanJQcGNpOS9kOTAxTWh1Q1U3bDAwa0h4?=
 =?utf-8?B?dENjMDA1VXhuaWJabWlFUjN4Z21UdFpaendCRTM0QXdNeitjWk5kQWdjRFFU?=
 =?utf-8?B?b1U0T3pRMlNobUpjZDVqS0tiTm9WeW9NVmt4MnhlWTNGR3pTSFRNNHo2bEJY?=
 =?utf-8?B?ZWtzYVpHdHJwSlAwT2hQc1NqOStJaGxQWXlGazA0WnFNMmppcE5hTWJCQm5t?=
 =?utf-8?B?QUJ2ZGhRN0E3NTY4V3FaREJkdjU1UnJtWlFsekIwMTNySUdHOU1kRkNMSmE4?=
 =?utf-8?B?Rmlzdyt6QU5LK0pGaStsYTIwcVdpS2JEaGMrYVlxWW4zbnliZ0tjelBqSkt6?=
 =?utf-8?B?aytWdlJqSkF2TUdnZFZndldHVnk2b2NWWktZZTgySUg1ZURSWENWWDZNTFAz?=
 =?utf-8?B?ZlFZNEZzRnFhL0M5L2gzNzVLL2xRNU1WTG1YbzlHRmNLN0FFek11bzFvRmhl?=
 =?utf-8?B?aEREZGdQakE4RU9qQVJZRUxTYXAvQVN0K3h2NkMwQjY0clNGM0JKWXpPc0RQ?=
 =?utf-8?B?eGF6YVhGcUsxaFhsb3A4L2FoK2FuM2J2OEZXNjZJQS9ZdWt4QXhIM3dhYlZv?=
 =?utf-8?B?R084TlJNd2I5aktncitwSHhBaWJqeVVVbStCTkxNTzBBR0Z0VUc3M1pIQ1cz?=
 =?utf-8?B?Mm01NVRUVWpCMkhuN0ZGdXFQUGhKb0p3TGlMcTlCb2kycCtjaFB4aVFhSEhU?=
 =?utf-8?B?dERwZ3NQTGRpb1p2VWVXWEw0T0g5VDhkemVqakcyNURnMHhBbkdnZjNQaXdh?=
 =?utf-8?B?SXBJekZ0NGpSQ1VWbkd2NlNVcVdrNjZFTFljOWRESFYyMkpuMXB1aS9DM2lv?=
 =?utf-8?B?V1puSnJ2eHZqQ2tGQTdJczRvS2tFUlNrTjVnMy9OZHZZVUNQYnBwd3FiZWRw?=
 =?utf-8?B?c1BnVzhIenRmTTlnYk45NVk5ZEMrN1ZyNVBnWUhNSWRPcUxOTWFucCtTeEp3?=
 =?utf-8?B?cm0wYmkyMnVlWnlkaVRIVnBwWFBFK3N6VDRpL2dsNWw0WGJyYytwR2hCRzJm?=
 =?utf-8?B?ME9VV1NaVXhibStNcHdvc0NoVFRsZUVycEMxK1RrU1QzTDI0Vkp0aUZKT0tr?=
 =?utf-8?B?UHhhRmVSRTNQbHJ6c0ZhZkhSWEV1ajBOWGw4SHBTVi96aUtWN05qTzE2YXJr?=
 =?utf-8?B?MXp5TTlmVllicVJXZjk2ZTdYT05SWkZhVWU4TkxIQk42a3BwOTFCZnIrd1hS?=
 =?utf-8?B?NjRGMnNJdXdKVEswQ0ozU3dyQXBqVlhPaFY5TkhyTmdBM05mMlFOU1YwQy9U?=
 =?utf-8?Q?vIS/dy3NyuNc2Ib/S5taBz7b3?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9fa8b708-cda8-4a40-4db2-08de205a31aa
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR12MB7458.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Nov 2025 13:08:09.0199
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2RSwjNoxLbrudgtM6GZqlaKWa01ADInOjXQVZn3apBInM3iAvWFBxudmwrRtHZbV/JlQs+wRgebIRcim7QO7AQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB7168
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 16125160017
X-Stat-Signature: gsf81ys6411a51x1ecakwshah97n1qzm
X-Rspam-User: 
X-HE-Tag: 1762780092-180101
X-HE-Meta: U2FsdGVkX1/GOsP+WNNQgraVzxEffsoJJSZAvbj1rgmkFU/Paa9apR2/c0nWM5+pystUzkUCOtCAdjJLWcOsywCqeDccTHjzm1J08d2icVsGFiG9q8iJ/H8NfIIQvpRTq+WUBjIqL+zQa4CxtGT5w2nNn2j/nc9ADDwZIB2e+uP/gOP/ZrbcNKLXZDUsk4HM/wmWznbvb6vpAWUx/sQHtJfX9v9n9d5ISQSLPVsvD1sWFA3NRGq43npsQk/lVElQ1WCE4YsPkTwYMh48ZY64sg4618rbqh9DdJp2Sc3+LR7bykQRlFE/sB/jWsTmiQcGc2RzAAdUagyyRGH/vIMUidKkR/vLB8s0r3EwY/HJzcOonVMIoqWr31BNg9BA+Gykfq3MyYpJ6B4n39fC0aWNVojYEMqEZgCTL82x55zh/hGxLbdsa7E2WWv/CE79Tn5WLQkA4w7ttdcseOU+Ra0R5pZRKxNoDBvuOz9DlskE7/y242IRtOQOJRnJTVESQqeuM7BeClokbC0VfWOGVQGmxrzbeSn2Y1rdFh+x7ceEecJAqti9HPFrDJ4nRIW1E7Vzdw6dmVMP1tZYFkcbECxRTS5KyHwTpS3d2zF2Ww7k0SbP3UV7froCod+hwxTfv+fh5fJYhWQ+fIHw1aswYCc35zs5uqTs8C+j8+NYpbkRKuzD2sZYBHbqhARAym2Pl++YXRrq+OrSxIDDNg5TKHqEBXabN+ZCXT5m996e0WriJHSkI5iPMPIBgzaojxOc8zvvKJsZsC1NHruSqFycaPElzeO1zd27yRR5D6drcB0o8QoScAZ6QLvIS30hFJLkY55wVP/kD91n9cZlYfTKJiqhvkO4Dex5RwUfp+A4W9NoA5eEEn64otxhR24Usx/SSrh1CcVAwNdu1VSz4v6hFTbwhRXa2p9nx/qnsXaGTDjfeQEW+4cc3tXFhb0tAKt22rnO6LtEIzIWqZfdwok91ar
 cb0dWcAb
 CzK/3EaeadWXsI5/Bx4tG8vMtpHVhD9JghnvwzONOGsVb8JaEvkyARIdwaZwUUVtdy/nooPjUKLvp+T0/G9AK6O0EQZe6M+3wgVMaIM/TYo+Ejy5oN5FD+VwEHBe2ZAaHfKTB3+8f6ObuA2PWafIDWmIPW+m4xkmOOODeVceZm/H/Vxvyb0WGGFEC0LMZBfI3Uo/T9GkuKtp8qTFN1thPJ0GiXXiZZRi9MGCMGqC/tLlD+BrgyMuQJjSfMMtSXQxws1387rV1keJFzmQO66QAtiSGwuiGoJDGxAaSj4WvpCBlW1SD33NzA5xiYpK2V2r1m1ics1fS2fXBCms4DW2lMVTHpMqSy12lpdcJOf5m2NU/MDu+WgCGbPXqkne9+aKuK9yuIbQbn7vC+Atq+TMMO4ZsWOX0KoXYd1kDBOQuhcstlR8lBOijvLYzB66/1AJIqdtJ/A+AJltme78=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 11/10/2025 5:31 PM, Lorenzo Stoakes wrote:
> On Mon, Nov 10, 2025 at 11:32:53AM +0000, Shivank Garg wrote:
>> When MADV_COLLAPSE is called on file-backed mappings (e.g., executable

>> ---
>> Applies cleanly on:
>> 6.18-rc5
>> mm-stable:e9a6fb0bc
> 
> Please base on mm-unstable. mm-stable is usually out of date until very close to
> merge window.

I'm observing issues when testing with kselftest on mm-unstable and mm-new branches that prevent
proper testing for my patches:

On mm-unstable (without my patches):

# # running ./transhuge-stress -d 20
# # --------------------------------
# # TAP version 13
# # 1..1
# # transhuge-stress: allocate 220271 transhuge pages, using 440543 MiB virtual memory and 1720 MiB of ram


[  367.225667] RIP: 0010:swap_cache_get_folio+0x2d/0xc0
[  367.230635] Code: 00 00 48 89 f9 49 89 f9 48 89 fe 48 c1 e1 06 49 c1 e9 3a 48 c1 e9 0f 48 c1 e1 05 4a 8b 04 cd c0 2e 5b 99 48 8b 78 60 48 01 cf <48> 8b 47 08 48 85 c0 74 20 48 89 f2 81 e2 ff 01 00 00 48 8d 04 d0
[  367.249378] RSP: 0000:ffffcde32943fba8 EFLAGS: 00010282
[  367.254605] RAX: ffff8bd1668fdc00 RBX: 00007ffc15df5000 RCX: 00003fffffffffe0
[  367.261736] RDX: ffffffff995cb530 RSI: 0003ffffffffffff RDI: ffffcbd1560dffe0
[  367.268862] RBP: 0003ffffffffffff R08: ffffcde32943fc47 R09: 0000000000000000
[  367.275994] R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000000
[  367.283129] R13: 0000000000000000 R14: ffff8bd1668fdc00 R15: 0000000000100cca
[  367.290260] FS:  00007ff600af5b80(0000) GS:ffff8c4e9ec7e000(0000) knlGS:0000000000000000
[  367.298344] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  367.304083] CR2: ffffcbd1560dffe8 CR3: 00000001280e9001 CR4: 0000000000770ef0
[  367.311216] PKRU: 55555554
[  367.313929] Call Trace:
[  367.316375]  <TASK>
[  367.318479]  __read_swap_cache_async+0x8e/0x1b0
[  367.323014]  swap_vma_readahead+0x23d/0x430
[  367.327198]  swapin_readahead+0xb0/0xc0
[  367.331039]  do_swap_page+0x5bc/0x1260
[  367.334789]  ? rseq_ip_fixup+0x6f/0x190
[  367.338631]  ? __pfx_default_wake_function+0x10/0x10
[  367.343596]  __handle_mm_fault+0x49a/0x760
[  367.347696]  handle_mm_fault+0x188/0x300
[  367.351620]  do_user_addr_fault+0x15b/0x6c0
[  367.355807]  exc_page_fault+0x60/0x100
[  367.359562]  asm_exc_page_fault+0x22/0x30
[  367.363574] RIP: 0033:0x7ff60091ba99
[  367.367153] Code: f7 d8 64 89 02 b8 ff ff ff ff eb bd e8 40 c4 01 00 f3 0f 1e fa 80 3d b5 f5 0e 00 00 74 13 31 c0 0f 05 48 3d 00 f0 ff ff 77 4f <c3> 66 0f 1f 44 00 00 55 48 89 e5 48 83 ec 20 48 89 55 e8 48 89 75
[  367.385897] RSP: 002b:00007ffc15df1118 EFLAGS: 00010203
[  367.391124] RAX: 0000000000000001 RBX: 000055941fb672a0 RCX: 00007ff60091ba91
[  367.398256] RDX: 0000000000000001 RSI: 000055941fb813e0 RDI: 0000000000000000
[  367.405387] RBP: 00007ffc15df21e0 R08: 0000000000000000 R09: 0000000000000007
[  367.412513] R10: 000055941fb97cb0 R11: 0000000000000246 R12: 000055941fb813e0
[  367.419646] R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
[  367.426781]  </TASK>
[  367.428970] Modules linked in: xfrm_user xfrm_algo xt_addrtype xt_CHECKSUM xt_MASQUERADE xt_conntrack ipt_REJECT nf_reject_ipv4 nft_compat nft_chain_nat nf_nat nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 nf_tables overlay bridge stp llc cfg80211 rfkill binfmt_misc ipmi_ssif amd_atl intel_rapl_msr intel_rapl_common wmi_bmof amd64_edac edac_mce_amd mgag200 rapl drm_client_lib i2c_algo_bit drm_shmem_helper drm_kms_helper acpi_cpufreq i2c_piix4 ptdma k10temp i2c_smbus wmi acpi_power_meter ipmi_si acpi_ipmi ipmi_devintf ipmi_msghandler sg dm_multipath drm fuse dm_mod nfnetlink ext4 crc16 mbcache jbd2 raid10 raid456 async_raid6_recov async_memcpy async_pq async_xor xor async_tx raid6_pq raid1 raid0 kvm_amd sd_mod ahci nvme libahci kvm libata nvme_core tg3 ccp megaraid_sas irqbypass
[  367.497528] CR2: ffffcbd1560dffe8
[  367.500846] ---[ end trace 0000000000000000 ]---



-----------------
On mm-new (without my patches):

[  394.144770] get_swap_device: Bad swap offset entry 3ffffffffffff

dmesg | grep "get_swap_device: Bad swap offset entry" | wc -l
359


Additionally, kexec triggers an oops and crash during swapoff:


         Deactivating swap   704.854238] BUG: unable to handle page fault for address: ffffcbe2de8dffe8
[  704.861524] #PF: supervisor read access in kernel mode
;39mswap.img.swa[  704.866666] #PF: error_code(0x0000) - not-present page
[  704.873253] PGD 0 P4D 0
p - /swap.im[  704.875790] Oops: Oops: 0000 [#1] SMP NOPTI
g...
[  704.881354] CPU: 122 UID: 0 PID: 107680 Comm: swapoff Kdump: loaded Not tainted 6.18.0-rc5+ #11 NONE
[  704.891283] Hardware name: Dell Inc. PowerEdge R6525/024PW1, BIOS 2.16.2 07/09/2024
[  704.898930] RIP: 0010:swap_cache_get_folio+0x2d/0xc0
[  704.903907] Code: 00 00 48 89 f9 49 89 f9 48 89 fe 48 c1 e1 06 49 c1 e9 3a 48 c1 e9 0f 48 c1 e1 05 4a 8b 04 cd c0 2e 7b 95 48 8b 78 60 48 01 cf <48> 8b 47 08 48 85 c0 74 20 48 89 f2 81 e2 ff 01 00 00 48 8d 04 d0
[  704.922720] RSP: 0018:ffffcf1227b1fc08 EFLAGS: 00010282
[  704.928035] RAX: ffff8be2cefb3c00 RBX: 0000555c65a5c000 RCX: 00003fffffffffe0
[  704.928036] RDX: 0003ffffffffffff RSI: 0003ffffffffffff RDI: ffffcbe2de8dffe0
[  704.928037] RBP: 0000000000000000 R08: ffff8be2de8e0520 R09: 0000000000000000
         Unmount[  704.928038] R10: 000000000000ffff R11: ffffcf12236f4000 R12: ffff8be2d5b8d968
[  704.928039] R13: 0003ffffffffffff R14: fffff3eec85eb000 R15: 0000555c65a51000
[  704.928039] FS:  00007f41fcab3800(0000) GS:ffff8c602b6fe000(0000) knlGS:0000000000000000
[  704.928040] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  704.928041] CR2: ffffcbe2de8dffe8 CR3: 00000074981af004 CR4: 0000000000770ef0
[  704.928041] PKRU: 55555554
[  704.928042] Call Trace:
[  704.928043]  <TASK>
[  704.928044]  unuse_pte_range+0x10b/0x290
[  704.928047]  unuse_pud_range.isra.0+0x149/0x190
[  704.928048]  unuse_vma+0x1a6/0x220
[  704.928050]  unuse_mm+0x9b/0x110
[  704.928052]  try_to_unuse+0xc5/0x260
[  704.928053]  __do_sys_swapoff+0x244/0x670
ing boo[  705.016662]  do_syscall_64+0x67/0xc50
[  705.016667]  ? do_user_addr_fault+0x15b/0x6c0
t.mount - /b[  705.026100]  ? exc_page_fault+0x60/0x100
[  705.031498]  ? irqentry_exit_to_user_mode+0x20/0xe0
oot...
[  705.036377]  entry_SYSCALL_64_after_hwframe+0x76/0x7e
[  705.042200] RIP: 0033:0x7f41fc9271bb
[  705.045780] Code: 0f 1e fa 48 83 fe 01 48 8b 15 59 bc 0d 00 19 c0 83 e0 f0 83 c0 26 64 89 02 b8 ff ff ff ff c3 f3 0f 1e fa b8 a8 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d 2d bc 0d 00 f7 d8 64 89 01 48
[  705.064807] RSP: 002b:00007ffd14b5b6e8 EFLAGS: 00000202 ORIG_RAX: 00000000000000a8
[  705.064809] RAX: ffffffffffffffda RBX: 00007ffd14b5cf30 RCX: 00007f41fc9271bb
[  705.064810] RDX: 0000000000000001 RSI: 0000000000000c00 RDI: 000055d48f533a40
[  705.064810] RBP: 00007ffd14b5b750 R08: 00007f41fca03b20 R09: 0000000000000000
[  705.064811] R10: 0000000000000001 R11: 0000000000000202 R12: 0000000000000000
[  705.064811] R13: 0000000000000000 R14: 000055d4584f1479 R15: 000055d4584f2b20
[  705.064813]  </TASK>
[  705.064814] Modules linked in: xfrm_user xfrm_algo xt_addrtype xt_CHECKSUM xt_MASQUERADE xt_conntrack ipt_REJECT nf_reject_ipv4 nft_compat nft_chain_nat nf_nat nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 nf_tables overlay bridge stp llc cfg80211 rfkill binfmt_misc ipmi_ssif amd_atl intel_rapl_msr intel_rapl_common wmi_bmof amd64_edac edac_mce_amd rapl mgag200 drm_client_lib i2c_algo_bit drm_shmem_helper drm_kms_helper acpi_cpufreq i2c_piix4 ptdma ipmi_si k10temp i2c_smbus acpi_power_meter wmi acpi_ipmi ipmi_msghandler sg dm_multipath fuse drm dm_mod nfnetlink ext4 crc16 mbcache jbd2 raid10 raid456 async_raid6_recov async_memcpy async_pq async_xor xor async_tx raid6_pq raid1 raid0 sd_mod kvm_amd ahci libahci kvm nvme tg3 libata ccp irqbypass nvme_core megaraid_sas [last unloaded: ipmi_devintf]
[  705.180420] CR2: ffffcbe2de8dffe8
[  705.183852] ---[ end trace 0000000000000000 ]---


I haven't had cycles to dig into this yet and been swamped with other things.


>> +	if (!is_shmem && cc && !cc->is_khugepaged && mapping_can_writeback(mapping)) {
>> +		range_start = (loff_t)start << PAGE_SHIFT;
>> +		range_end = ((loff_t)end << PAGE_SHIFT) - 1;
>> +		if (filemap_write_and_wait_range(mapping, range_start, range_end)) {
>> +			result = SCAN_FAIL;
>> +			goto out;
>> +		}
>> +	}
> 
> I feel this is the wrong level of abstraction.
> 
> We explicitly invoke this oth from khugepaged and madvise(..., MADV_COLLAPSE):
> 
> 
> khugepaged_scan_mm_slot() / madvise_collapse()
> -> hpage_collapse_scan_file()
> -> collapse_file()
> 
> ofc you are addressing this with the !cc->is_khugepaged, but feels like we'd be
> better off just doing it in madvise_collapse().
> 
> I wonder also if doing I/O without getting the mmap lock again and revalidating
> is wise, as the state of things might have changed significantly.
> 
> So maybe need a hugepage_vma_revalidate() as well?

Thanks for the feedback. I'll incorporate these comments for v2.

Thanks,
Shivank



