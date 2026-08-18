Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0CE9EC5DF81
	for <linux-mm@archiver.kernel.org>; Tue, 18 Aug 2026 23:45:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EE3966B008A; Tue, 18 Aug 2026 19:45:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E9A9D6B008C; Tue, 18 Aug 2026 19:45:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D34426B0092; Tue, 18 Aug 2026 19:45:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 98FDB6B008A
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 19:45:42 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 2C1F3140324
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 23:45:42 +0000 (UTC)
X-FDA: 85116024924.26.9F8E73A
Received: from CO1PR03CU002.outbound.protection.outlook.com (mail-westus2azon11010046.outbound.protection.outlook.com [52.101.46.46])
	by imf02.hostedemail.com (Postfix) with ESMTP id 3666780007
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 23:45:39 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=PNSLsZD1;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf02.hostedemail.com: domain of ziy@nvidia.com designates 52.101.46.46 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787096739;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qfZWmpJOWVqg5gGtEpJKGkFxeaqACZAOn8XT346TsR8=;
	b=nAMpyxHiG4TpaA//pYSJbJH0k2XT5UMnlkiy55rmXhRFgOPKrVTsF+1TSeMN2y/IcNR+SL
	rkxArvde+Q33WPCe1NASN/XVyAQbyxGOmg4rVs0vTdDR+el9zk3nqZSmNzlrN8E4E9OumI
	RyfnvEpnQVVI7ML0fp2ZwQahnmsX9Ik=
ARC-Authentication-Results: i=2;
	imf02.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=PNSLsZD1;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf02.hostedemail.com: domain of ziy@nvidia.com designates 52.101.46.46 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1787096739;
	b=qDs+tpU6+d97UmCcZUQzXweajHAVuwMIRsah8jdUn+7f7k8Je80UQsQNxW8ZjViZfc0Vyw
	Mxen0DyoWIV2u5WtiQffMMUCap1ZO+AoM9Zn8Nmp/ur8W8JgNnqRbvOnirD2AaN15Cx6kT
	REDVJlAkkadE+eja25iS3sscIQnn8d8=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=a9mY76l046xPc/FSYfPi1Ut7KKr4cV3KjxY30vQxg2FnfOgvtmyoDIZ7whp82AIIfPpnwCBol7ZWS7Tszv46zHw/hdfgkCdmtaNW7zOumaJcmT76ooCRqZetQkd3H1fnvI3K+BkGPKTmrSa6OIx0bjRjcWm21z4xs6aNxXgwY+oW6XXgw1tVe2STH547TpPLvzrvs4c9mi5dDnMba4hi83p3DybMhIpwazIcVbspuHVnh2ybt5hE5IIeXfxVyjeJ4UutL1T7L+2QDwZpq40ElQ1okIJAp9DY1ZfWL+V4LNJLmfQp4vorRAtrMQg9EZ1mQNyUIctBQw5lNUPXWuuH8w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qfZWmpJOWVqg5gGtEpJKGkFxeaqACZAOn8XT346TsR8=;
 b=eF+lWDz/GUCf6RnJpstBKuW+x939vE5JmvT9ecLCE7+A1HNN5k5iQtWiOdcwmap7wkj/5piQ3d4Y9+0MxAY11VO7epqeATSLZzRZatucjsa/zgtH4WuowFaBi/iS8Y0azE4HeNL1D+v0rIKYjbleEYZWt8VeD84TeMXXOy5yT+Jjhbpol8LPL3juEnBZlB3yao/BGE9QvP7c69F13HfLe59Je/AvOrvM9MyKyPSanQdT/YC5hm043AuAJXwkd/Vj62EXNro5rluYZ0pp4QdicfzuA1L9f57r7EZ5u87itUsj3k99b6hup1XxhldHEHuxy+PrWOYFWEkHr2cd4MqSiw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qfZWmpJOWVqg5gGtEpJKGkFxeaqACZAOn8XT346TsR8=;
 b=PNSLsZD1/ho1j90UOM2MjgpiiTWsNUNlOv+7Zw0tWdz7je28YZS+DYi1wfZ1gWn2AgpiaBq23cOgVJxP8bFI58QlneQ2JVpPjSPGOM3fzZJA3EqZbn68uy/dA4Yea/AAlx7yW8B4O5DeRSS0uy5v7QZHtAX5SvO8Mbd0u8NhO6n9tOjU23aoNsI2iZGMJADt6MlVBQBJQkCWLYNymKYTEzNl8xv6l/MtgNwz82momH3w5ObRxsurZLq/24DtYfc37BjLxZIx95BfQ58bSEhAoJVrc2ZD3fleQyGRcqzuVqYOTD3XOcJBaOSlnIjFpDX501wPI0j1sukmhvlO/m7emg==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by MN0PR12MB5835.namprd12.prod.outlook.com (2603:10b6:208:37a::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.339.8; Tue, 18 Aug
 2026 23:45:33 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%5]) with mapi id 15.21.0339.007; Tue, 18 Aug 2026
 23:45:33 +0000
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Tue, 18 Aug 2026 19:45:31 -0400
Message-Id: <DKSGX4MUL58E.1QQZGHROS8EPS@nvidia.com>
Subject: Re: [syzbot] [mm?] WARNING in ep_write_iter
Cc: "Andrew Morton" <akpm@linux-foundation.org>, "syzbot"
 <syzbot+805630f1453e490427fa@syzkaller.appspotmail.com>,
 <apopple@nvidia.com>, <byungchul@sk.com>, <david@kernel.org>,
 <gourry@gourry.net>, <joshua.hahnjy@gmail.com>,
 <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
 <matthew.brost@intel.com>, <rakie.kim@sk.com>,
 <syzkaller-bugs@googlegroups.com>, <ying.huang@linux.alibaba.com>, "Greg
 Kroah-Hartman" <gregkh@linuxfoundation.org>, <linux-usb@vger.kernel.org>,
 "Vlastimil Babka" <vbabka@kernel.org>, "Suren Baghdasaryan"
 <surenb@google.com>, "Michal Hocko" <mhocko@suse.com>, "Brendan Jackman"
 <brendan.jackman@linux.dev>, "Johannes Weiner" <hannes@cmpxchg.org>
To: "Alan Stern" <stern@rowland.harvard.edu>
From: "Zi Yan" <ziy@nvidia.com>
X-Mailer: aerc 0.21.0
References: <9787b33b-b30e-4c5e-a0ee-7f14515c7166@rowland.harvard.edu>
 <DKQU9SQUIKDR.2KEZZPONJ1IJ7@nvidia.com>
 <20260816194213.0e813ed338144ebc81ed4050@linux-foundation.org>
 <472add4b-f16a-4b87-bbc3-98c8aa385cf5@rowland.harvard.edu>
 <EDCC14FA-F7D8-4F72-B780-37D09E26D16C@nvidia.com>
 <EECC6FB3-7559-4D22-B9DA-33E30E5EC181@nvidia.com>
 <7deabd9c-04d5-4a45-8b8a-39929c046152@rowland.harvard.edu>
 <A2BA0883-6B5D-4AB1-A7CF-6B9BDF27F439@nvidia.com>
 <2bf01548-723c-465d-8368-247a814f61eb@rowland.harvard.edu>
 <6FC11E12-9428-4975-B135-E24805C2D9BF@nvidia.com>
 <15b086cc-7f10-4766-9b0c-88c3302e7398@rowland.harvard.edu>
In-Reply-To: <15b086cc-7f10-4766-9b0c-88c3302e7398@rowland.harvard.edu>
X-ClientProxiedBy: YQBPR0101CA0101.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:4::34) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|MN0PR12MB5835:EE_
X-MS-Office365-Filtering-Correlation-Id: b06c68be-5075-41af-d249-08defd82cb67
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|7416014|366016|23010399003|10067099003|56012099006|4143699003|22082099003|11063799006|18002099003;
X-Microsoft-Antispam-Message-Info:
	qpQjISmauqXDPvwgNI1JTsmCjoIQvdlSlnSBv/ULVVAoYArvEwqwy0DYF+12QnESHIqm/FNrNtzVuQzFCDLlunXx0nEZtRCC/UiDYPi4GuMikZblZiT0ejfmFPA7iiciBneHUHy4dK7Vax9iXjF4138JivIdpl1DRFQoeJKXJ6W6KLSNQthlYsv39KKpX8TrDFPmHNxYBrehZLDOwKzSZAD747ItDsOFYo+PxZoiltADhU7eAvl0r8v6Mw1nG9adyES+Es0ll2ed5UyxXMSWRmKphL2tPOzfGz+ypVqtI023GljzwWFD2DaRHz+4mFNnCy43GisDwHhA+D9pOtGj+UqHwIIFQ3skHuCeguJk+9IkD1stTdVCmWTRrqepjKcB+11MqkUdCI6FhqnsasyC5n12sFZkYEqkrihrvQY4jH2OYa143OhAOoBk8xyiZGfMRWPmPLiKTZOd20i3SYxODIk3x9pMZpNU2wOgtDRV9AeyimUCA3HPdpHOrHuhXj0uxoPgkWwpHkgxhXkG9v9KvLV3h5obQb2g4Fe/Q1Dmwj+atGpaOMJqom8kwv5cBvOzt5KFLNnk2B7vRnPKgoTk3ZGmZYO/wHwIJVIkR5W6gTGC3EaZrOhct5vUmJ+pT0NH0lATI4ymo/szfdcFtI4tzdnSpjQ91AocXIUojtp30YY=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016)(23010399003)(10067099003)(56012099006)(4143699003)(22082099003)(11063799006)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?Uys4dGcrUVMvR2JSZUYzdERkaVR1emo4WjZ1a0FTdXpxanMvSE1nYkNuN0J6?=
 =?utf-8?B?cGM4UitMSitwckIzbXlRc0xHbk1qbHBXSmRpNlBzNkxGTWJSL3kzL2dJM3ZK?=
 =?utf-8?B?eTh5TzVyZXc5MkZONFhVaTFiU3ZZL1dNZEtDUUY2NFFLQnJ3U2tKUWZXcXlu?=
 =?utf-8?B?d2JZT0lnLzJPRFlMNDdhY2dIUm1DWndnU3IvaGZlTVcrM1NvY1NxMEhmRm9Z?=
 =?utf-8?B?YzZRditXOEJGcWwrNTE1RmptbGtIaTVJVGpZbWRvMVdmeVBjUGR0TnBlUzF4?=
 =?utf-8?B?UnpwcVVwdER4SW42ZFFsNWxodTBxSE1CaXMrai93eDd3MTU3OHZzN1orNVla?=
 =?utf-8?B?Q2hvdnN6U0RZT2VBNHZGRFFySjRPZkkrcUh4UlRpaGEyeVpteG9ISDBKaWRv?=
 =?utf-8?B?VUdDTUpQUFAvNVNyVVhGaDREakk2eldyVSs5L1lJd0k3ZTdFRTZGRDBVNzBT?=
 =?utf-8?B?T09KNDdXNXl6emtETWlDRHdkcHozREZ0OHNaMmNHanI5ZUhQZG1ITy9sZVpu?=
 =?utf-8?B?RmxYbEtFcTdoT3hFRTZlNk1DK0tkMVg3L2hqL1pTcnJTYXVWaFN2R2RiK201?=
 =?utf-8?B?TGFhWDgxdkV4QlhlM28ySFgrV09nUk1XZHlnTEMwOFd6WE9WMHNEejNCSnZY?=
 =?utf-8?B?eFoxckgvZkEwYWlsSlA4MitpVk92bFRZTXdGbE9TRXdnTHpZbVp5RlJIZ0pH?=
 =?utf-8?B?aVFxNDVPLzNpcnhwTDNpRzdxS1NhS2JFdXdOYTZ4eUVqaVcyTmlZdkJSNHVo?=
 =?utf-8?B?cnRvUmY3L2VYRm9Vd2MrbEsxbEZvaFRtcDlqMUtkZTE4MjZOSGE0UTZ5SUJ4?=
 =?utf-8?B?RUFtaTdPZmM1OG8wbjFYMVRaRDY2cjdwK1FiVVRkYjM0VDZMUGczSmgrZlNH?=
 =?utf-8?B?S3JaM2NhT1RmNUtCK002T1Nwanc2dzNxOGxlMjZ4YlBrazB1UmZjR0hDTm1V?=
 =?utf-8?B?dDlIeEk5c0V2VTZ2YVd0Y3VxRERWa2c0T1pLdWdYRURDYzJnNmEyTFcxQ0N3?=
 =?utf-8?B?M3VWa05rRDBGKzN2WDBjTzlwWUtvaFo4RGNwSEJOUTlzV1ZoNW4vUlE2SVVl?=
 =?utf-8?B?Y1pFak9lTWF6eGtxSytrSFJVeGM4WlZYNWdnU2Rsdm5MajA2ZEQzRk52Wi9s?=
 =?utf-8?B?RzBLUFQ3NEVWTkg4WGVmczJaY3RnVHpFZElOaHRHQXJiRzhLVUEvUmo2aFY5?=
 =?utf-8?B?V3hyN3dZRUYyZW14V0NZMU9KcUEwQVRSRlZZOFRxcEIrak03L2k0cjRsMG9r?=
 =?utf-8?B?S2ZqZXZwK3BuWjZNRmhia2hiOWVKMlNzQm1mczhTc3RmMCtoZkZ2ZGx6WWpv?=
 =?utf-8?B?K0lWSk1aQUZRak54M3dhUXJwNS9oci8xdE9jeHZEUUszR0p5bWEzd09iV1ky?=
 =?utf-8?B?SlNrMXlYVndweHFSWGprOGE1M1VSclVrUDRsbkVMM3FoNGlaeXpDbGxMa050?=
 =?utf-8?B?U0diamtvL1I5cDc3alJ5RkxsZjFkZUY3eC9xelBGblFyejFKVENUTTNBVS90?=
 =?utf-8?B?Y1FVSllvbWs2MlBuZ2FYa2x5MG1rZkVYUndONFkyQ2lKMjNaZUIreG5qa2Vh?=
 =?utf-8?B?NXA4dlk4S0I0M0VZYzdGb1NTdG5pQm1PeTdsSGJrdWNOclRyWG5YbGtTS3dL?=
 =?utf-8?B?UGpTWDgzQzB0UnNvOXVteklDNE5xR05zS0xEVFlFU2ZzWWdxWmx1U2pDQU4w?=
 =?utf-8?B?V1NuNDZCQVJxanhHYU4vdFZBWHkxekxsUzl1cW9JOWQvOEd2eEQyamlSM3ha?=
 =?utf-8?B?NVltREdqU3plZXI5VE51NXNqVlc5Q0hTTWpGT3EzQVFoOGJVcm5oR3cwT0R1?=
 =?utf-8?B?aURpSm1MazhMbXpNL0hQL21KUmorSXRnNU9zYWgwNkxheU9FTG5jdkkxZklq?=
 =?utf-8?B?VzNqMkxPOHhqL1UwTU10eHJ2MGlERmxWeStkN2l6YW1sdzl1eG9lNWNyZEdT?=
 =?utf-8?B?L1NqVlFjUW5CNlRwOWovZ3E3TEM0ZE5INkxhNGdCTmZGWG4zbTFjRTJqU1ho?=
 =?utf-8?B?QUNmOXF6MnpMT29JNExnNjlHTml3T2RlQk1rZGU4WC9RaDMvSmoxSU5uQ2JQ?=
 =?utf-8?B?M0VoVzVQRXZzbVFoWC9VZC8wMFNqZXhiaW1RNUVEWm5FSlNhWG44WjNROWMy?=
 =?utf-8?B?dnFOZDJTdDB0TjJuZm1iQmlkZVk1bXBvckp0eFV2cEJwdlNNQVFRMXlBSjJr?=
 =?utf-8?B?SStEaVZjZ2pnS0NXQnZ5emxEN0FRbmRYZDVjeTVhZEd2VTZkWjhHc1FoK0VP?=
 =?utf-8?B?NUNlaHBpOXdyOXMwWDJjVEw4NDUzNytrc2RpWHhKNTFkSGFXSFZvSGNmTnAx?=
 =?utf-8?Q?KbhNDocERhifd0/NGw?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b06c68be-5075-41af-d249-08defd82cb67
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Aug 2026 23:45:33.4920
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Pmx70C/Lpm2Shp/v9jRPRUC3NieJTznlSC+nKs3mZzbU6xCIXFDhY+eTaOeLZB7G
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB5835
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 3666780007
X-Stat-Signature: kqppu9qtt91dq87sc7c88rhjowz7dxqq
X-Rspam-User: 
X-HE-Tag: 1787096739-331429
X-HE-Meta: U2FsdGVkX18L7H9eZoxC71+RcKrRk7XPzBM03CQnWyuaYdX9igbJUTwtnPwEYPnPJzsr0vpud/621fxhVa9+npM2WRNpcKA4Cz1RqzwK859cTPva65AuW7hgODI8dD7RAD5Nm7VUNd8U6EDiY6vyKDhjgneb9NvLraZjAs/+Pn4gqymqxqsz4xR4g0McIESa0ZWQyElktO+sjYqc/MK5Pz7cLNGqvu+ZM5BRYe0z01bVx+TEAaoJDHgWSu152Er2hupA3lcxMyTRwu8I69X18Xq4LGKWu0rR9M4QgkwQrKEHMrFM6bQLI3Q7Gkh8gRg6uIEVIjylYZvUMykK3tDrmNUxc6h5fLQiMbNvYDss5qncxFb9iVOsjtaHw/imfkv2IbZ11dNJ2bbJakLN8mIF/9URpumgY+lXZXQuH3VVnmJaXbh582VElkHRupbsnYi2yRK+DAoSU+ierej59lThJCit33nvUfZZDw/LcDTuiIdGUbarc3XWsJJIaRlCLi6yu4mB8k6jOHf79dBFehtPwBLv2X63R9ltwVGnNUpHYTmpJA+0xAsCZm3a5TQ0IWkJlWGSyQt3sULUCmcT2uocnB8yxNCFDcQD0wAbix9i0BK/L4yA88d0HgsMPRZXWtsK52TsNdcyGKUykvGS68OdSAiCq76UISTLHKpPrK5/sEsevSZKJDZDb/CCmFOCvnTYSwje+MGtdsHPofQhFOTIO5Gu6eXwMOwqb9QNbbm1Z7GBs4AGAy4iSzCnXFUu/MmBdVGFyI9rQTUWmsVI6umjMCBSpq3CJHK9WuGeC/xmAkwzDmG972MCCo74P/QyulB/F8Bam5OY49It7zK1MMtgAMkYTm6HYmmsLP49Dncsk8/nNMSJ7PnrO7uhctUZ/kMq6yJfv1JhQmWnMOUZJW2pck3Pkb4eXU9r/8+4g4tn/+AxYN+QsuIVfLrcu346oiLnqclTASTTpCQp/9Cehy3
 xNUAJH/n
 FJs385TuDVCqdKKU2sKJLzi0Dav3HGaRDURhVZCzm3IIrBqLlf2jcXCm1Mt3dvpM/LRpMm56tvuBsU1Qpcp1fxN5U6UXCqnNlY0XpUTCE6fOKAFA5AxGigaL6BfR8t04L+ckf8Goyfvblew95Dt+ayzyQCLXUVYYA1VgS9/bzshZrjQvJdkpf1YuA0TvgZwRAsq3gBYrqcnY9bQuKBvQNmKmPjnn7MJ2v1n8s45r8WbelZDEd/Nx5JYQ6TbyfpUeDmPdsnviP09LPBsPLpWVmBfty/IeEYXYzdVYkeiujDwogWFdLB7l6aMbRzjF2ITwHKGCeAFb0ZluWXD/YC8AHyXy3VxrA5EpdeMErWNlaHFb+gL/39K9E2SfatqVnzffOs1c8b9aJ79gmivNyT+b9MHh1UtV5L3IMnBaZa9fLeUAcGEI09dfIBs8Iud2ruzlCy4CDbhT2rI5h3REBmuy/YYaykNj1Ngft6hXwdyoUuJ72kBKSXcXDAXYMxm6QI84YUKP5LKKRSdxbaOAs4HYNY6uDRZsYYH7ECmtaRfVxQp47d75LZ+uPeHGDe1ER0CAFfeIggGRX48XYhzjlRWhvnU0FOQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon Aug 17, 2026 at 11:12 PM EDT, Alan Stern wrote:
> On Mon, Aug 17, 2026 at 02:45:19PM -0400, Zi Yan wrote:
>> On 17 Aug 2026, at 11:37, Alan Stern wrote:
>> >>> Regardless, if it is important to let kernel developers know that th=
eir
>> >>> code is doing something wrong, why not make the WARN conditional on
>> >>> CONFIG_EXPERT or something similar?  In other words, prevent it from
>> >>> crashing production systems.
>> >
>> > You didn't respond to this.
>>=20
>> I do not get your argument here. Why does this WARN need to be condition=
al
>> on CONFIG_EXPERT? What makes it special? Or you mean you want all WARNs
>> to be conditional CONFIG_EXPERT?
>
> This may be a moot point now, but I'll answer the questions anyway.
>
> This WARN should be conditional on something indicating that the kernel=20
> is meant for testing rather than production (not necessarily=20
> CONFIG_EXPERT but something like it) because it does not indicate that=20
> an operation has failed badly enough to leave the kernel in a=20
> dangerously unstable state.  Rather, it indicates that a programmer has=20
> tried to do something that can't possibly succeed.  The result should=20
> not be dangerous because the caller should always check kmalloc()'s=20
> return value.  If the caller is unable to recover from a memory=20
> allocation failure then it is the caller's responsibility to WARN, not=20
> kmalloc()'s.

I agree with you that this situation, kmalloc cannot satisfy the
too-large-to-allocate request, is not fatal and is recoverable since the
caller handles NULL result. But without the warning, some callers have
no way to know if they are sending an unexpected/undesirable request
that might come from a bug in their code. With the patch, kmalloc
returning NULL means two ambiguous things: 1. the request cannot be
satisfied due to current memory system condition, e.g., insufficient
free memory; 2. the request itself is unreasonable/unexpected. It could
make debugging harder.

>
> The same is true for all other WARN statements.  If they merely indicate=
=20
> a programming infelicity and not a dangerous failure then they should=20
> not fire in production kernels.

It is hard to tell whether a condition is dangerous or not. A caller
sending a too-large-to-allocate request can come from a miscalculation
or a wrong user input. It can also come from some data
corruption/overwrite, clobbering the request size itself.

--=20
Best Regards,
Yan, Zi


