Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B35A8CF3189
	for <linux-mm@archiver.kernel.org>; Wed, 19 Nov 2025 10:25:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EEB516B000E; Wed, 19 Nov 2025 05:25:50 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EC3806B0012; Wed, 19 Nov 2025 05:25:50 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D8A7A6B00B0; Wed, 19 Nov 2025 05:25:50 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id C3ABF6B000E
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 05:25:50 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 58B1214041F
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 10:25:50 +0000 (UTC)
X-FDA: 84126975660.09.4AE5FC0
Received: from PH8PR06CU001.outbound.protection.outlook.com (mail-westus3azon11012023.outbound.protection.outlook.com [40.107.209.23])
	by imf17.hostedemail.com (Postfix) with ESMTP id 4FD284000B
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 10:25:47 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=Uw29Sjig;
	spf=pass (imf17.hostedemail.com: domain of shivankg@amd.com designates 40.107.209.23 as permitted sender) smtp.mailfrom=shivankg@amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=quarantine) header.from=amd.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763547947;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Uvct3PlfG/KfUchZIjxXaZTmsWv2o85h4tQKY3VAtNM=;
	b=tUn40wYUfG048AXS00oscNT1vwxkX+tVXU0G5Q2xl/6YSJXTwepB81s99/nfXf/JD2mMV4
	ht/yPRHRVZQ302XINQRN/32yosmuGB8DqQTxOVMKlOyktboJVNB33hDpsH7CXzYIUkiF4t
	3pa3PamxY3TChEZNxhFoq8o/VLZENWo=
ARC-Authentication-Results: i=2;
	imf17.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=Uw29Sjig;
	spf=pass (imf17.hostedemail.com: domain of shivankg@amd.com designates 40.107.209.23 as permitted sender) smtp.mailfrom=shivankg@amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=quarantine) header.from=amd.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1763547947; a=rsa-sha256;
	cv=pass;
	b=FnaiI6rsheHTt6pz62UHfyDDmQfn0GUJMovbWjsui77cACMP1/7ypkRtwle9ZaatBe6250
	g7w6qPKwYADVHLBs+qmdHv9aRlpLWLqoIF8ZT3yx7UN9ku5tCpuNZEyvjWjL9gt49BGkDE
	BiwIkqaTO7UL/lv0Ctw6w/JvAa1nSmU=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=RUAdk3UEq2Y3XXqFw7LgUtQZQCxIjht3qEwKBPIxhE6aiCWzWVSHPfz/xGtvRG8bXTCkMt1wNvPBW+EwJXFby3ps33/TZKSOmPmwd+iyO9f8gJ70eb4iW++v8h9BjyS9FxRgtLzeG3KBNgcxoycd1fgDQ9cHLbivV7droq4THEDqPQNAurVSa2yjrEQ1Qg67UELEcvSGYnn+/pmNuyypzyRc7denmfOAXVHsR6WOq67o2KineCfM2PAcq9POwJsfk3x4ieD9lwSjcCFbsoG7nRY7/dOAz+yB9EIJbf3CdgWRgN8hC8Vk0PKTg44ur9pzzj3K9mDqaVEhAJX64AxOCw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Uvct3PlfG/KfUchZIjxXaZTmsWv2o85h4tQKY3VAtNM=;
 b=dRqZgN9rstCY4gNjFVsuEGCw1FILP8sTGVRHhzKj1hUe83vYLv/DZL5ituKZ0ju0v2GyaxeOwJ2XL3y2PencixEaWW/VrIjSpR65w2gme4v0oAvocDQg4SpCmyDm4iMPNIzh7/MTtjqWxCPL+kVw5YJOiOA2n+JUMCEx4b0xa2rQzIXpEvHw1WQp60i/gwLYtszIAJJAyBgX1y4Wnm6/fJnKgodSDFeOk0kFdtbzn+4CnMuCTLW/UlEgoVJljE8maZUB2qounjVbxx7q801TX3Qbt2N8SN0dmx1Ljpg/O8eRsTaXNL33jL5SB1G7Tk5WiWm/PE0xvdMCq2lN+5iJBQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Uvct3PlfG/KfUchZIjxXaZTmsWv2o85h4tQKY3VAtNM=;
 b=Uw29SjigKQXBKaSTleJkIUB4Sv2vqSJYwocQ3wmJ8jF0K4Z1Q3ibp8v6COgTGDcFjqKeggiPaKdtWY/wVPvfDlrIqtGdf9uqF5iiwEQUa4cUVKYRYso4d3JlREIFObdNWQ0t9jVjq/dcOgGEx7MentUrLEt3faIs4ZTOIdITATI=
Received: from SJ0PR12MB7458.namprd12.prod.outlook.com (2603:10b6:a03:48d::13)
 by IA1PR12MB8555.namprd12.prod.outlook.com (2603:10b6:208:44f::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9343.10; Wed, 19 Nov
 2025 10:25:39 +0000
Received: from SJ0PR12MB7458.namprd12.prod.outlook.com
 ([fe80::83e7:e6cf:26ed:2f3d]) by SJ0PR12MB7458.namprd12.prod.outlook.com
 ([fe80::83e7:e6cf:26ed:2f3d%6]) with mapi id 15.20.9343.009; Wed, 19 Nov 2025
 10:25:38 +0000
Message-ID: <a2770a50-5732-4483-b958-4693f0f08c7e@amd.com>
Date: Wed, 19 Nov 2025 15:55:29 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] mm/khugepaged: return EAGAIN for transient dirty
 pages in MADV_COLLAPSE
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
 linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org
References: <20251110113254.77822-1-shivankg@amd.com>
 <20251110113254.77822-3-shivankg@amd.com>
 <67325651-b7d5-40d0-a9f1-3009b61c8d3a@lucifer.local>
Content-Language: en-US
From: "Garg, Shivank" <shivankg@amd.com>
In-Reply-To: <67325651-b7d5-40d0-a9f1-3009b61c8d3a@lucifer.local>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN4P287CA0099.INDP287.PROD.OUTLOOK.COM
 (2603:1096:c01:278::6) To SJ0PR12MB7458.namprd12.prod.outlook.com
 (2603:10b6:a03:48d::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ0PR12MB7458:EE_|IA1PR12MB8555:EE_
X-MS-Office365-Filtering-Correlation-Id: 2773fdbd-8539-4439-f256-08de2755fb97
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|376014|7416014|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?RlJaaHFXVU1xVkJmcEZsWERBVzl0KzdDa2tkL1lJTGQvSWh1YXVDUU9nQVFV?=
 =?utf-8?B?TWZJLy9sMk01NTl6OXJ1TFNVL0xkdG03cmMzTmFzZGRWQ0lkb2p2ODY0Z0RG?=
 =?utf-8?B?Z29BWE1oR2t1UjM3a3BISlV1eExuTGJNNHBrY3FrVnpRdkZKZW42akt3dGV3?=
 =?utf-8?B?aVFuWWlsRFFCMTdMZ2cxUVgrMmYrRUVOa1NFUHRoc3paVUluY2Y1RUVnZlBG?=
 =?utf-8?B?NkhPa21yZ09CSVhwaE9tcVdRNjMva0pVWStvU1I2Y1NvZ2FicDJLcHNjODk4?=
 =?utf-8?B?b2d1TitudHE3NTFRSDlESEtET2MrWEhLUXR5VkxkaFArMFV4WCttcVdPT2hB?=
 =?utf-8?B?cFhQZXFUSWUyOGsxMkRYS0RwcWdtckFQdFJPVHgrYlFqT2YyUEg3SkhqQmhK?=
 =?utf-8?B?UXZQVERidGdVYU9HSGtIbDN6L0h6YUtJOXI3U041YTl4Vmt3UXVlZk5zYnNu?=
 =?utf-8?B?TXRMdkE0dkFtdzVlcDVSRTA0RDZEV25XcllsbldNNGx4eFEycEovMTZxQ1hu?=
 =?utf-8?B?eDBBblp4T2IwaXdBRnRHaFRaanlZMXVNUVV6L3k0bVBmL2lwN0Z0MWJCNGE5?=
 =?utf-8?B?RTZOOWRTMkZMSEdybGNtemY5KzFWZHVFdGJRRUhzSGpscXA4cjFmQ1BqczVC?=
 =?utf-8?B?Z2JDTzhJbHVxZ1Q3ZjRDUWRDdVYxSG16dTgwSXpqVFdHS0prdk5XaE4xVFlx?=
 =?utf-8?B?TFF0TDV6Q2VFSm5NNU9wa1c3ZjdZeE05amFYVmdyVlZWU0h4Mnc3Q2ZFd3BK?=
 =?utf-8?B?SUF4dG94bXZBaW9Fbk05M2g2UFVzbU1vay8vWXM4OXJiWUpkMjIvbGdzQnRD?=
 =?utf-8?B?b054VmtIY1Z2b2NaVGFkczlwTTA0SlhDUVh6dzlVeUN5M3F1SlJyOEdqSTJy?=
 =?utf-8?B?QmZkS1RBaVFXOXpFWXB0cUJjdEUzWFZLcEFoV3k1OFBkemlQTTRwWCtUaHo3?=
 =?utf-8?B?Ti92OUNaSHBRYk00T0l0NkYzMzdvUXY3c0M3czdkSlhSekMrYndPa2NpOXhH?=
 =?utf-8?B?VXN1MndJc1J0a0dYMDRVcjdYUW1MNmxsY3RZZUJQTjk3aHdiUkpzbFFUNWlo?=
 =?utf-8?B?blEyNU9KTjg4b2hsVXdkL1Z6eWp0cGN3RlRrYldzRktzaFR3M1ZUd1RQRzE3?=
 =?utf-8?B?V2lKbzFkZ2RUOWQvZ0NmUjJYV1BSUnd3WUk5SEJOdU1xTWdWczVyZ3NFMFN0?=
 =?utf-8?B?SDJablFUM3BaMlZwbFlsWDNHY0w2eFpjZjVsK2krVG5WcDRyS3ZEUlczejdF?=
 =?utf-8?B?MzBhaEFDcm5Ud2M1YzgxRmE4bHVPdWpaK1FMRDZZc2tRVnFRM0NVYUhybndq?=
 =?utf-8?B?ODFoUGdwaXk4VUltZFlkZWNoc3BKY1FXcjJ4TWYwZUFQZHkvMmtjQk5NTVQ2?=
 =?utf-8?B?ZElheUVSN1RMNGt4Y2htcWFlTDJHb1JzbnNVOG5wMHduQkVZTGJQYzdXcGdm?=
 =?utf-8?B?VmkrdGMydlBsSTQ4cU5SK291dUtITHlrMXJBNCtLK0wxejlJY1plaWNPK3Ex?=
 =?utf-8?B?OEI3dDRuTkNzVzRiT0prVGc0WktpbUxWMW96N2VkUHBJMTVMS2RoUDNsc1h3?=
 =?utf-8?B?NjFsZFlHRnhiU09xTUQzeXRyS2JmV2M3M3YvQ0M0RHF5N0xRVWEyU3Q4c0FM?=
 =?utf-8?B?WHR0clIxRkxXVm9nUUpMK25KMW1Sb2RkYWtnOGRsZTBMNDR0cFl4d0c1RzRj?=
 =?utf-8?B?VzFqeUFzdGV5SVp4L3dkcjdUb3BWZ21NRThhM2lNSGVoZVYwaDlZaFBuVmR0?=
 =?utf-8?B?bWs0MWU3cTl4dU1SVis1N1poM3k0SVRkbUxveU90UVAvYWVxTkloOVNybXBs?=
 =?utf-8?B?YWRzbDRmbUVkbmxwL2EzdXFDaUNkamlCQ1VlbDF4bC9kODRVQm45TkV3S05y?=
 =?utf-8?B?S2pRbUROUk9aNTVYaDJDYTZ5QVBoVFd2MVZwdTh0ZFM2eEZBdzdtWW9lSlhk?=
 =?utf-8?Q?C/PbNeCjzHHmvEF6Zc7KoWvXJjofFTVR?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR12MB7458.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?T1MwU1ptZnRMYjRSN1FLWjlYSGxTSFZzU3N2TVBEc1A0eXJMV3BmTEE4SDkx?=
 =?utf-8?B?b2VVN2t6Y3AveU8yR1U2Qk9iSEM3YzhLN0NGODlhbzkydGRBZjYwV1lUMjhC?=
 =?utf-8?B?aElUcmFMY3pibEgyeUxQeTBIMnFUVFh6QXZmYUExZ0IyUXRaZG40Y2Q4L0hq?=
 =?utf-8?B?ZGtRTEVmZ2JucjUxVWFxQ2V5WXdneU1peDArS2gxZTQwblpLQjdtVUg4TDRh?=
 =?utf-8?B?T0Q3OE5NRm9zc05ncjJVWU5nZWJjbmpMSmxsUWdXdlp4eUZVcjUyZ2xRK2F5?=
 =?utf-8?B?WDBFeUV5NHlwOC95K1c0NStCYzJSbi9vMDIxRnRXNGNzMkR0NUpKRnN0TmJP?=
 =?utf-8?B?allkblhuWEZVa1ozY3BVZS9jSDJKdGs2dC9hYUlUK1FISm1LUGFVNWI5RVRV?=
 =?utf-8?B?QU9sTUxnQ280SHdvcnlDcEMySEMyZTVJcGdia2FZYWhXMzhJY2NjZnlZS0p4?=
 =?utf-8?B?Yyt4amN4QkVDTTd4THlleGgyeUdha0tFM2JZTHB0R2U1ZGFja0JZbktucHFa?=
 =?utf-8?B?bWxXWFVmNVhBYUVrM0NvWUxWcEp5VGg2TTRZZW94ZGdNQjN0NFY3N0VlM2Zs?=
 =?utf-8?B?dm5iYkVHeGprN2VQMi9uOWllM1MzV3c2bHo5MW5zMDRqU2JvSFRpUjIvZm5s?=
 =?utf-8?B?ZXo4UDZXbXRBSXhSNGVtbklvR2JGN2FYcjlMc3BIT0lBZVFhUE5WcG95OGQv?=
 =?utf-8?B?Uy8vcjEyVXd1NEdseXhNdW1saDNOdFRwelhrQnNEdEJTRTQvY0tsSEltUFNy?=
 =?utf-8?B?V2hYWWFZRmtHVDZLS2NBSE9QL2dRTDExMFN0TWdDN2hBTzJPTVhaankyckdO?=
 =?utf-8?B?UHV4YXozdW02Nzg5ekxjaDZvL3hoLzFZdTNWWUN5LzdEcDFyeGlPbi9GN042?=
 =?utf-8?B?WmlMMSs3ak12TDNuWHpNRjBaQ1Y1Q3ZDdS9Jb01KZEpnbS9xditCZGtQQnp2?=
 =?utf-8?B?Z2VmbFdxSmhpbHBGMG80cEZZMVhvNXR4M1Q2eFQxcGNESDRNYkYveTMvMkF1?=
 =?utf-8?B?eEtGY0l4VHZNMHZNWVZOV1Z4RWl1SnloakNlNy9MM1ZzeENXUC9qaGt4VlBo?=
 =?utf-8?B?cndYaUQwQ0dpTkhKSmxqcXh3Yk1iVmI4NXZ6MlVQb1daRkxPWU90WW5GTjlF?=
 =?utf-8?B?MlVacjR6LzgxeUN6YXgwUTkyNUtIcTV3N1lmK3RRQlNqZGE5S2JKWnBFV1k5?=
 =?utf-8?B?T0JZbFdhSnR3K0h1SktLRmpXcFpqYWpJaVBiVXFnTk9tQWZoTjkvOXRMTnZN?=
 =?utf-8?B?THlUNjdEaVAwTEdNYUpUMklxcFAyT1RKNmdNcjZhUVBHRENSVzZzWmNWRmk3?=
 =?utf-8?B?bklIZzc4cDYxTU8rMkV1ZDJDNE4zREcycjhSODdmZG90SThzOHF4Z3lQVFRn?=
 =?utf-8?B?YmljdVBKUGxBZ1h0LzlDcU15NHhBNmRlWDI1SHQ1b2x2bGo1RmJ2cFQyZ3Ar?=
 =?utf-8?B?eVltTlB6ZDZ3dHhydDhyVy9iVk5uOElxL3BHd3J3bW56LzhVWnN2Y216aXhw?=
 =?utf-8?B?UllUZW5obmNMaWxFMmpRWjNIVHp0WFBOK0FwZTlHU1FwODl2elRaSXgvaG1G?=
 =?utf-8?B?ckJERXo3M09KK2JGajZLTUpUZE9odGpoZVFoMGdnbHM0cnBldGxvc2U4SlBm?=
 =?utf-8?B?TDkyYjZaalhOWVFnY1l4SlVxWEI4Y3o2UXhWTjhNT0hIRkhFcEVTbFZTTVR2?=
 =?utf-8?B?TmpCYzhmeEloL1pISW5ndmcvOFFXSytpc1NDSG5lWXoxaTF5anhVV3NtZE4r?=
 =?utf-8?B?TFdjOHY0c3FRdzI3STZSdzNXTWhZS1hhaklQYllQSnRvaHQ1WjViZWpWMWpY?=
 =?utf-8?B?Vzg1RWdnTTNTSGF3Um5PMFRiejBQWnlzd2p5c0lVTTdpSkdOZ2dOS0lpQkNI?=
 =?utf-8?B?U2NlTXpRNVJRR0JleERtTUtBUXNOUk9zVllGWUUxUmtkb2xKOTVZd0FONnFt?=
 =?utf-8?B?SDRYUWZ3NUt4bDQvNTR2WXlacjVsU0lCZlNZTHg4bEJCUGxUMTFOR0FyMDE0?=
 =?utf-8?B?Y1JmcldFeWFaaG5PV1lSSlVUWnFMd3NQd0hVNlJ2blBGWUZaNVlkVmVpbDhm?=
 =?utf-8?B?OWxMTlRGUG1CaExoaDJWSEJ3cStwSFVCeDBiSHZvaDJYaDVEejR4UzMxdndB?=
 =?utf-8?Q?W0CxvYDUC8dt36WCLbJvu2g5p?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2773fdbd-8539-4439-f256-08de2755fb97
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR12MB7458.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Nov 2025 10:25:38.1536
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XCQEiforJGsqGDQhTvHpNyXWq5CyRL6ofn8QgMEtVDmiv/bAvD+HnV7KL4kVx5y+tBddcdapQNH0LguKNq68oA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB8555
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 4FD284000B
X-Stat-Signature: yhheqnjjnsmcwbqorh4zgmzj4gcyoqp1
X-Rspam-User: 
X-HE-Tag: 1763547947-19488
X-HE-Meta: U2FsdGVkX1+0wDQ702YnVFfMxZWbCsGlDxTzxWB/LL6f4N1N7cBM0aNE3KzmO1uCQRDhAPCwjcfBHlw+v6VBbJoQuzYwl391QRr3SiOU+p1wx+htavxpaz4tbzECYz8ZaSjyIUyTg3ekOTsm9/5j8SUcgInTFYapvXMAM+DIxZEnfpkaDViEKrRWAREk3hol3cMunraDOiZlsge7CC2uT450AU3vuFbgNeSxwCrDUHMsfEmEl2zVXdEuBHgxiDBAOybeMKDzmnbRSXOtLGXy7vAqVmLIiWtsjiALOSynA6j8wDwE+dk1Vhkpermv7EpDHtjXSM73zHYSqsrgfWVBkrctzTePVaS/AM5L3Xdvh5/1qKpoOMYoV2iXc1uJLTgQifG4NJDJhPY1N/sCG5OK5QdWlfzhy41BhkVR8th9SYu2zYLeCKMtdfpo1/RB8mJ1r5cBpQAEx8q709p6JJJCwUM+z9PL/Mem+EuHH8cmMkIrxwy7esHQfd4/Vtbo1OpksuH+Z3e9dUxCOSXUelac/F1MUQyU26XdAq4+EbVULYgSdavI1BRL4ukl2Ade2AbJIBDtvhJuHVdW8q22rIb3PMTErwrg4QOker/ikk9tgl1VvT6kPKb+u8rwXQwxGIOlXs3BklSQGyA06GKAJbVBK0OrRekBQzi3nijqzjE3mhtqwGQUiCWfZSMSo78NXMFQWYbP6TAeocGBEapQbGIq57JFRbEQ2FQfkNGIAmVXMX7qqfVlPOaZOFEnCv7FtYr15vEWl9VVdfdaT1WXOqab6B11gz5EupKNB1GfMdwDrq2Etq8juSu3QYFO2ykRElj2mQMkv8QJLy4y30PqLBWwvGX0bOLbiINBfiQIAfG9qeWUVN/77uZUfo0c7WRA0ZsDj3T/GaOQIl4KojLh87p42JdMLKhkbzVqPOcPtsTLtR5PxxkqFLVAzR8zPM13SFAQCjqN+KCRumB3OpBNYLS
 g7qDnSX1
 icCCROYgBur2e2q1vcnyMSLFcYEh/iH5b1Rj+SzU7VWqD+f3xzyVP/CC+36w6mbzu3GN3vT4LNwWF85G74cBPJv8xCAHzPMU5jp603/EOqDbpii0+XsUhtbCPClcBoRYaDBLcwmYDx5i6JjeHTPws1FQ1Eg2PBDqK6JhexThD4OhcAHLvGmwY9dbCgty/tUc31I+uy2+uKJ6SSunzSYzYTviLj5QcvahUwEoSfGcjoczfkZ1JyI1my9FaACqd8HogQxQSa4GmzSNf1CX2rh7Sd20Sbiu5foW1iJp0XtVLe5m6kL8dfg3Q8Qossm6A0Oo5jOSeqQr8dyD1YNopRjH8lCyylmVxEg+WbdYTH8V1pJ/JY3OA12Icrc67EfBjYwLHy2C0KbzrsUXJN3Hz7L4hQl2sVtpKf8o08jSfeAGb3iBzZft0z1Kl9ykYANHjJp4Ro36+0NaQF36b48zAlJFRyu1uFd6OwYErq1fn0O26nEA7uRCi+/F+FIt1bw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 11/10/2025 5:26 PM, Lorenzo Stoakes wrote:
> Please, please, please send a cover letter when there's > 1 patch :)
> 
> This 2/2 replying to 1/2 is a pain (not your fault that perhaps you're not aware
> of typical mm series style but FYI :P)
> 
Sure, will do this in V2 (posting today).

> Also there is some tiny conflict on khugepaged.c in mm-new, but it's literally 1
> #include so probably nothing to worry about.
> > On Mon, Nov 10, 2025 at 11:32:55AM +0000, Shivank Garg wrote:
>> When MADV_COLLAPSE encounters dirty file-backed pages, it currently
>> returns -EINVAL, this is misleading as EINVAL suggests invalid arguments,
>> whereas dirty pages are a transient condition that may resolve on retry.
>>
>> Introduce SCAN_PAGE_DIRTY and map it to -EAGAIN. For khugepaged, this
>> is harmless as it will revisit the range after async writeback completes.
>>
>> Signed-off-by: Shivank Garg <shivankg@amd.com>
> 
> With comments below addressed, LGTM so:
> 
> Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>

Thank you for the review. 
> 
>> ---
>>  include/trace/events/huge_memory.h | 3 ++-
>>  mm/khugepaged.c                    | 4 +++-
>>  2 files changed, 5 insertions(+), 2 deletions(-)
>>
>> diff --git a/include/trace/events/huge_memory.h b/include/trace/events/huge_memory.h
>> index dd94d14a2427..9014a9bbe64c 100644
>> --- a/include/trace/events/huge_memory.h
>> +++ b/include/trace/events/huge_memory.h
>> @@ -38,7 +38,8 @@
>>  	EM( SCAN_PAGE_HAS_PRIVATE,	"page_has_private")		\
>>  	EM( SCAN_STORE_FAILED,		"store_failed")			\
>>  	EM( SCAN_COPY_MC,		"copy_poisoned_page")		\
>> -	EMe(SCAN_PAGE_FILLED,		"page_filled")
>> +	EM(SCAN_PAGE_FILLED,		"page_filled")			\
>> +	EMe(SCAN_PAGE_DIRTY,		"page_dirty")
>>
>>  #undef EM
>>  #undef EMe
>> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
>> index d08ed6eb9ce1..7df329c9c87d 100644
>> --- a/mm/khugepaged.c
>> +++ b/mm/khugepaged.c
>> @@ -60,6 +60,7 @@ enum scan_result {
>>  	SCAN_STORE_FAILED,
>>  	SCAN_COPY_MC,
>>  	SCAN_PAGE_FILLED,
>> +	SCAN_PAGE_DIRTY,
> 
> it feels like a lot to add a scan result for this, but I mean... probably
> actually valid.
> 
>>  };
>>
>>  #define CREATE_TRACE_POINTS
>> @@ -1967,7 +1968,7 @@ static int collapse_file(struct mm_struct *mm, unsigned long addr,
>>  				 */
>>  				xas_unlock_irq(&xas);
>>  				filemap_flush(mapping);
>> -				result = SCAN_FAIL;
>> +				result = SCAN_PAGE_DIRTY;
>>  				goto xa_unlocked;
> 
> Hmmm shmem dirty is going to be weird but we also have:
> 
> 		if (!is_shmem && (folio_test_dirty(folio) ||
> 				  folio_test_writeback(folio))) {
> 			/*
> 			 * khugepaged only works on read-only fd, so this
> 			 * folio is dirty because it hasn't been flushed
> 			 * since first write.
> 			 */
> 			result = SCAN_FAIL;
> 			goto out_unlock;
> 		}
> 
> It's weird though, why would we have writeback, surely handled by swap, and
> won't it be like anon, i.e. pretty well always dirty? This comment seems
> copy/pasta wrong.
> 
> We do need to at least mention in commit message that shmem is explicitly
> excluded.
> 

Looking at the code, the dirty/writeback checks where I'm making changes 
are all in the !is_shmem branch, so it only affects regular files, not
shmem.

Should I mention in the commit message that these changes are limited
to regular files and don't affect shmem?

I'm not sure I fully understood your concern on shmem. Could you please elaborate?

Thanks,
Shivank


> 
>>  			} else if (folio_test_writeback(folio)) {
>>  				xas_unlock_irq(&xas);
>> @@ -2747,6 +2748,7 @@ static int madvise_collapse_errno(enum scan_result r)
>>  	case SCAN_PAGE_LRU:
>>  	case SCAN_DEL_PAGE_LRU:
>>  	case SCAN_PAGE_FILLED:
>> +	case SCAN_PAGE_DIRTY:
>>  		return -EAGAIN;
>>  	/*
>>  	 * Other: Trying again likely not to succeed / error intrinsic to
>> --
>> 2.43.0
>>


