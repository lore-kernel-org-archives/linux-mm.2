Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 36049C43458
	for <linux-mm@archiver.kernel.org>; Fri, 10 Jul 2026 11:30:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 28C4B6B0092; Fri, 10 Jul 2026 07:30:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 23CDE6B0093; Fri, 10 Jul 2026 07:30:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 107566B0095; Fri, 10 Jul 2026 07:30:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id DAF2B6B0092
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 07:30:27 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 6F0611403C4
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 11:30:27 +0000 (UTC)
X-FDA: 84972648894.27.E5CF7B3
Received: from BN1PR04CU002.outbound.protection.outlook.com (mail-eastus2azon11010013.outbound.protection.outlook.com [52.101.56.13])
	by imf13.hostedemail.com (Postfix) with ESMTP id 7F73920004
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 11:30:24 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=cqfiqnih;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf13.hostedemail.com: domain of ziy@nvidia.com designates 52.101.56.13 as permitted sender) smtp.mailfrom=ziy@nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783683024;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4p3VCC34HJihUkm0jHOePH8XjMIb/Qa73MASVq8+qBs=;
	b=8HnTtMRxj0T3lKheZzG/M8bI3AsBWWNaPjQkIhlzoyzNakZhAIOPUjAjx5McsA8iscxc8L
	scThk6F2ScD+zjrZnFq/4Rf0r7SjKdWq7tzILdAhkkbMqPH2/k+nAV0qSTdOGGFIPPTstY
	LGb4WkPoGhxJ3iKiZuGE5BVCqn5FuF0=
ARC-Authentication-Results: i=2;
	imf13.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=cqfiqnih;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf13.hostedemail.com: domain of ziy@nvidia.com designates 52.101.56.13 as permitted sender) smtp.mailfrom=ziy@nvidia.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1783683024;
	b=DQ2YOaRnolUzUX9q5VgIdaHotoAxX8kEdp+IoCytP1H9YC0MyIMRJdINAPTrzeg5SKg+uw
	WoZpdf6t/EawvrvWjp3riuloQjG1OtjXg7R4T1S15Q/nJpGBH3dyFWdC8QbfpkjKBPPDGL
	T7ax7TB8eYrrqwfhRCMWSy8dv1ZuvgU=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ZoCaBcbfdMdv+HxCbRgWqHOXWe1jW9YeESjlOQ8YqSQrToJdJcdf6DLBoJfpUuXCR0GVWHYpNUzpdi8gEnpviHqlfomiQgTSEPoihR1iIFj0KnrZfvJOED12ZWRYaOfLP+SdGUOswemA31TUXQLB1gblopNNxgPE8M1kJnHgzeHZzs152r99rbh3wukqXMPAqqOZnc2QHfLjU34YB2W0gL/DUlBCpjziVteIS9bCRRjdpEtcxWDLBwI/Ov8l7dyyILtkGzKvOYWBr2bdSuF8ZVQwG+6uNKUAQfKtrLZHJ3e7/BtvdsTV6DSXNP8doSVEEeyqLQFN7BYsHsTKbVoHbw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4p3VCC34HJihUkm0jHOePH8XjMIb/Qa73MASVq8+qBs=;
 b=spnVzzYyQYLdVp8z4ntcXC9t/8JKQf2y39sZ5pKdTG67u6V2XaYi8OksCTmjjmWl4CYxuztNiEWOM25U1rkrWvq3xdmdQu7vDK7tORwPbGhGjEaK7IpEE4xaH7dMm4LHgmxpUQoRYy9xxurdd6xXRE3nZIdy7U0zJYKWNJ0DnfzFhrO78jR8hD0IxuQHvXqn6D1xzxO2pGbw0+yIKAynPotUUu48m57IZUiHzNZwIVeNQWmrzuPnSKOjyM8xmpJc1KMOzpucy24RBvcjHiX9MKKRMJFCawdJrlEv3qKqRu53pCm2M/5efci2vKtBUHGIFeKLeg0IsPIdcpk5nhnDdA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4p3VCC34HJihUkm0jHOePH8XjMIb/Qa73MASVq8+qBs=;
 b=cqfiqnihetJOF0UnSrxS9tFVsHQ2f+fIQhX9mCJv16ZienRq/kC0lQ44uxlbf5PfBxbcZ9rG5hCXIDMeJO5iJW2dFnFqZE624JY/wUu0yBOt6Ezc1MgqyrxU4PY+Ft+StvRgWealp9t+SPGF5waandfL1A+p2WEA4rIzKwHM4eK6pURn4fzv7z66pmrcjEW8UbJ6L0jvV2OSuloGmxf6GoJfpZNb0Oc2900MmCPnMVFr1ebggeLFVsseOculVS/Sj4MyqhGeBswDb3cdpuECMxOhtaU8yJPSQTWeoEiohlSphs0Zgqp+drovNYToMzBiMwUcn+gFJ1o36Ziedt6V0A==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by PH0PR12MB7010.namprd12.prod.outlook.com (2603:10b6:510:21c::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.181.16; Fri, 10 Jul
 2026 11:30:16 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%5]) with mapi id 15.21.0181.016; Fri, 10 Jul 2026
 11:30:15 +0000
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Fri, 10 Jul 2026 07:30:15 -0400
Message-Id: <DJUUUX0BK942.1ZP1I5GNIGEY1@nvidia.com>
Cc: <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>, "Sashiko"
 <sashiko-bot@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>, "Andrew Morton"
 <akpm@linux-foundation.org>, "Matthew Brost" <matthew.brost@intel.com>,
 "Joshua Hahn" <joshua.hahnjy@gmail.com>, "Rakie Kim" <rakie.kim@sk.com>,
 "Byungchul Park" <byungchul@sk.com>, "Gregory Price" <gourry@gourry.net>,
 "Ying Huang" <ying.huang@linux.alibaba.com>, "Alistair Popple"
 <apopple@nvidia.com>, "Balbir Singh" <balbirs@nvidia.com>, "Kefeng Wang"
 <wangkefeng.wang@huawei.com>
From: "Zi Yan" <ziy@nvidia.com>
Subject: Re: [PATCH] mm/migrate_device: avoid overflowing migrate_vma
 collection arrays
X-Mailer: aerc 0.21.0
References: <20260707-fix-array-overflow-in-migrate_vma_collect_pmd-v1-1-ce3ff4627653@nvidia.com> <b806c878-e1e6-4af9-8816-678955288d82@kernel.org> <DJT9JHBIGW8V.17SI5NN5GCJVQ@nvidia.com> <DJT9Q4WLXSUG.GHQOMM41P9PZ@nvidia.com>
In-Reply-To: <DJT9Q4WLXSUG.GHQOMM41P9PZ@nvidia.com>
X-ClientProxiedBy: BL1PR13CA0228.namprd13.prod.outlook.com
 (2603:10b6:208:2bf::23) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|PH0PR12MB7010:EE_
X-MS-Office365-Filtering-Correlation-Id: de82bcf6-296e-4218-96d8-08dede769d22
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|23010399003|7416014|376014|1800799024|18002099003|22082099003|4143699003|11063799006|56012099006|921020;
X-Microsoft-Antispam-Message-Info:
	7K17tSgsDA65We9l+h3ld5eIs3G0ucnI3DYuLmHOfmOu6khlL+qv8RNfDj3etbSK0Z2UMpOqB4pNhHD1TsiUeXwOsy0xRFX3LdN43Y3/FmvN7MQwgloN/BSJfT0E9eRkTPYY64HaGlt+FaAdpFPkYHMsjdmjiKu4W/QJ5lLhkkLkt+B5xtvV5yhLEMS5Hkfk9BMgG0lpAdx07jK3a2IRwZLZTil7TAkg7HikM1UElRS6X1llBXsSRv4pPcJTRv78W9W9Cifqt4XXoUQWNs/XzppRCxVG4r4+gBrb3wGtZH6giOpnQPwWKWg9Jtep6qy5TNCUo9OtlzZ+Nns6W8ZCB+b+jrRINZkK7apYpmOr63Clwf3VldGCTwzVu9Z/ze4PNS1C/qoge476xOQ3baqyp7m2//QQCue2gFxt5LxuBzf+NOwnfwqkjWwPjSHGpDRbOO5C57wPquGcSsyz2o3BXtRIl5QB6NxtTumEOlQfOIS9OAj2bmh4PvV8Bxrg1xwFmRwyxAwDJ8Yd0Gmeh2Ucom4inJ8FcBi2R+TousqPUGvRrsJIOd3WylhMCi9Siw5w2/atoQP3KIAu31iik0FBc5DH4yY+wJVHg3tBuEcn3QGdOl23E/AhajvLMFWWbe/jjD00mRAmJky5/VsoeZodLAelKk0wHLqRN5Y1/N7voXDvTOiBXEItRVdQ3ID50neGroG7BuwIhuNXTRyPiERg8Q==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(23010399003)(7416014)(376014)(1800799024)(18002099003)(22082099003)(4143699003)(11063799006)(56012099006)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?MVBtWXVhY3BBODNFcTNiK2ZqZUdSM3BDNkVzNnlMakN6ZDROQmh1ZGlPditr?=
 =?utf-8?B?ZERRdTNnbTdkMEoyS0t0dU01Y09mNi9lN3RkOUhXM0NHeTYvdWQxRDg0RjFR?=
 =?utf-8?B?eFJhZTNVQUZRQkZERVhvUmpGOWVzL2orcjhNb2d2SlBRbG5pVnRmd2p0WXE5?=
 =?utf-8?B?Nmt6NDlSSXdTRjU0bElkY3hOUzUreTI4L2QzdkVxVVA5MEN1SWo0eTllMGNT?=
 =?utf-8?B?bTZ3QXhFb0VBaDllRzNIMWhmdEpJL1dsWUxTWWV3TWZzVFVQaXgwa21yY2Jv?=
 =?utf-8?B?cDJhTDNrSkpGVXVnd3JCMDJ1bVAzbFRXZm5nS0RqbGYxZUVLR1M2M2hCcmJC?=
 =?utf-8?B?YVVEQ3c1NVVIVmJhcCt4MytsTjBENTA4NlV3OHdlTGpZUDJBTUhweDRyMGM0?=
 =?utf-8?B?Y0FCaWUrR1VjelFDNUpZem1iTDVndlk0M09zS2c3dytHbmp1dDNlcHBWWUZl?=
 =?utf-8?B?T0hxOFptLzV5WlVzY3RxM2dsVUpvNVcvVXZ4SE43SCtrdzFEZFkvaGRHY25z?=
 =?utf-8?B?akEyYi9IV0owQ3huOHFLZnIxRTd4Qml2eGFqL21HVitHeHBoenNIMU82ejRT?=
 =?utf-8?B?emJnQWtWVDhTdUVSK01qYjRzVlE0MkxmbEo0cjZnZWVncENSMnFzQ2NvTkg3?=
 =?utf-8?B?Lyt1UVY2cW94WnB5WFZXSXNUN0lCbWh2d2EvU2pOdWF4RFdmWExHR0dqRDgr?=
 =?utf-8?B?VnJvd3VDNnpDVWZGa0VQd2hORDdCYlh6YitTeDVDYnIzMUh4TnB1V0JpNFZk?=
 =?utf-8?B?MU53VWtTVkxRM0hiR0lLTjNOZTIrZmJEVmNZOUtKeHZ4dzhoeEJLZUVqZXBJ?=
 =?utf-8?B?czZETjg3dDUvUkkyRGVWNDQxQ2ZlcSsvbWZKbVNQK212UzBTL1VXRStRdkxE?=
 =?utf-8?B?aFRlV0NqVE42Z0ZJNmZ0UDMvd3ZOWU1oSVM4b1JRemJBbW1BUnIyTUhNcU51?=
 =?utf-8?B?aWNZSzJvd3Job1hCdUtmakx5VHo0K1JyaHpMcXFYWUVwQkFuUW5vZzV4NTRU?=
 =?utf-8?B?emFjMm4wU3VKZnRrWmZ0eW9lWXN3RHVBOXF2elRDVE9XV0hIZ0ljYVZmMVUy?=
 =?utf-8?B?V2NCYTl6R0JVS2xyU0FrRjBVRUw4VGd1WktWYUdCMVQzMDhkZktYMDNKbGJI?=
 =?utf-8?B?bWlzK2hpbGgrb0ZGbEp4T0Frd1JjM1JJV3dkU2NNNHlxbmszUTRCS1d2eDdE?=
 =?utf-8?B?NDVOM3hRZFRsREFPbDhUaUJEVGRicHZqZkFTaU5JV1RJNENSTFpQREhVa3V5?=
 =?utf-8?B?OEd3Z3JJT0JCNy90b3V3bHBDS0k2NlkwcU5obS9EZEpLdzFUcHRSZzFUQk5M?=
 =?utf-8?B?cWN0cGpJTlIyaWxwR3NxVFphaXltdCs3T3VnczVsc3NuL2pEazZqSmFvZE1Z?=
 =?utf-8?B?WmI2cFFCR1pOYWZEYkI0ZTBkaDRCVzVHVkRNYzFINk5ueXRaTDBqczdSUmQv?=
 =?utf-8?B?dGNuK2JlbGR3NWR6aXhzS3FiWlU1SUt4WVZYUWxxTk90b01DYzlqRjN6bmJt?=
 =?utf-8?B?UCtlbmk2NGlkejdmR09CalhLZTU4UjdvVm5WdFpRVVhxd3BONkt3SzZTWk5U?=
 =?utf-8?B?ZEZPeThoUjN4dzRaMTluK1lGdXptcEV5YWJaMDhmNHdxb0h1ZVp3eXEzdmND?=
 =?utf-8?B?S3N4dWg3b2ZjZy9xZ2tCTU1WVFJBSjB3SFFqVndEcndaSTBVcEdDQWxTVDg0?=
 =?utf-8?B?WVB3WC9VR2FrcnhNRHdzd1JqT2hTTjQvbklQdzVIT1U4Z2ZTazJlcW00azAy?=
 =?utf-8?B?cUFHWlYwOTdKbWRQZ3ZoeWtBWUZ0V3d3Q25ZTlBFMFU2UWxTY0VSYmVOakto?=
 =?utf-8?B?enF6elpQU2xBK1BhdkFETEg1ZWFZY3djQk9weVpNcGRoMldybnZyeS9UaW9z?=
 =?utf-8?B?ZmZQWDQ4ZG9OaWtNejR6U3N1OEVmTHhCZ1pSMUN6ak5aMVJRRWdZNmlnaWsx?=
 =?utf-8?B?S3NWb1gyM3JML1hrYVBPY01YQnk3TU04Y3ZrME5PdDltelFGUkNIeU1CYUg1?=
 =?utf-8?B?U3lUaGpZTkovaWdSWHdVQXZwcWIwWFpacEorQkJYc2VFRVlPMTlBdktZRU5h?=
 =?utf-8?B?MHFPeVFlMmNJOUx1SDRlNnVseHZQYUNKNHJwdGhrWGJCbGp6RlhSdUJyYnhK?=
 =?utf-8?B?NUVKMURnOXk0eGQvMEh2NHkzYUVXdlg0MEExeTVmOHlJTUppdzQ2dVQ3MSs3?=
 =?utf-8?B?bExYSTRyNDM1dUdTVmExSEV0U3JmREFVdzBVWHJKL3ZqRmg3OEo0MVVFNVAy?=
 =?utf-8?B?Y292UEtXc1dLRnkzZjhSRXlWSFA0eFZ5cDRJZHNoV2YxVDY3TjJMekM5M290?=
 =?utf-8?Q?twWVvgFMrFQmugqmuG?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: de82bcf6-296e-4218-96d8-08dede769d22
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jul 2026 11:30:15.9332
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /vJwkplMb3d4lICOmwZhppcLuEnFd8hQK8VfRQXD7otTKQWGGX/KjzzsJkfrpjYj
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB7010
X-Rspamd-Queue-Id: 7F73920004
X-Stat-Signature: o6eepd1rhzo9nmmsfqo4ahi7npwoupk5
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1783683024-757273
X-HE-Meta: U2FsdGVkX19bQSehyySHJsq2YZgcIy6we0rFHCvq7wk+azsUiQs2JriE6EP9V3wRY1k/X/SyVn0KcYMro7lV2+i2M1/4nSeaIFRn+uqFzLvntDQFnKAbE7tu+EU0VsOs+fojLAu6zRh8yNWLI8Wn9NeQC91jHma0zdNTAYMSiKWUBsNpWD77Lbb3p7fMyfzHUlzW75RYJIPhQ6QsrgaESfEKqAIrCR3Q6JGZtfVDlHBILr+s2slVPQ1b5KPno5K9cvQcszW/eayR5H+gbp7PbCZ2EQJzknL5KvRxNHlAzwv5Wy6U7BtuKGnplKV6S4KClxW6Onh9w0zhV3q5djKBal+AAWsCOHsNLLUHkPGLRxkr4meHcNMduHz5EsIo1SWsLy1bILKTfh13WXuWb4DjWndkz/anDfo072CGV34Wze9JosVqqh2BupjdXkQ2mp1N5igjlAdZTxNDCfK5nIvNOFZd0JnDlBzk104bZosx9Dx2pdK/8SwQ6pMLiV2VY7PgfALjfXUM/kmG1MzsWJOiysGwn+947O/TWJt/Kg7fsFy/H3zumIrBV+2r24FIt0dL9fcOXzg2nDHfZqCYe3GgfG7wmu/3s6vZVYeuxE+YYK/163FubatY6IMWjFGhVSHZ9WvxDOKfISWQ5TUamnNS0C7OU/kqmrHUMdMXh6sATZK9Z7cx6PtyPte/qQzwlb9CneZAjzrmX7gHGkdWbjU87JvUjWnhqHZC4yO86Khy81QmDVus+rkPr2EXcE9ent8DM5LmvLiBjdG3rq5yM3GlXalmydtzNtYx7AV+QZDrDMscsKc4FKHMyFH+lYWS1ZMlgTqgKl91P9eo0SZOX4eNUW6wg5YQToxZ5pG+RCbG7/dempR2YoVWkmai7Vms1odwsMIBQUhwSG5eIJjCHJiG7/OG9WjfDK1S8UZUHzw3/HYlG4VX+amQ7svWJX7v9/OeiCXcME7nANlPxyX1DY6
 cD/D+qRv
 H9CqCMMNV6naXGi0yxlwukzYcfJBydggrOCNV8r5/jQPPEOiAnOq11Kh76RJ9VM8hkcNl1229rwQ2HEbqJOtyhcKByYr/KyWp5GcLJUoseX0GTIapBI3tfM7HLNpI0hK2iZ6lMic9Z+sfGvHP1E8mcBA8Qy38xZRiWavoA+frpNMOFKW2mrsgTDRJSC/nK4a3BAWFoLCIcupSAJS3oNFJHWc0T70rOmSMAlGCov8UbX/DulZdq9s9JeKKPRB9+CQrBsV5F3B8D3XNGfMd7tky5w6xGl70BI8D/mFkJIHub0H0MnkUJNsYjpGrwPNRWg/fpiLs08g3XtA/v8YRiwmhz0yAhS+KG8On6j7mxFodjDzLOksHH5btlYGCQ9ZzJt3o5nWiuygGNfukoVlrIJYroUzDU+1hAEmF4Upv8WR0t5Uk2gU+ftOLJFTozpkPlVYSsH0SVn+7Z73ZfWLLJJKozMlF00foJW7VRo8g2GJS52F2SIrbjZ3Wd6l3krk1HMMp/uUdRuZ5gsbXOYhMH5fSUzHE9Q36YSGEAc/iBQrAGiwR3yKxp5k97X9U2aKjfXzBvM3uG6NOUW7ifuKo0YAqvu8Dy1K2EOrmuELvapROK7ckbQUBrQ+Mf+F4IA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed Jul 8, 2026 at 10:43 AM EDT, Zi Yan wrote:
> On Wed Jul 8, 2026 at 10:35 AM EDT, Zi Yan wrote:
>> On Wed Jul 8, 2026 at 4:43 AM EDT, David Hildenbrand (Arm) wrote:
>>> On 7/8/26 03:50, Zi Yan wrote:
>>>> migrate_vma_collect_pmd() can drop pte lock to split a large folio and
>>>> restart. But the code does not handle restart properly when pmd become=
s
>>>> huge or cleared. It can overflow migrate->dst and migrate->src arrays
>>>> during the hole or skip collection. Fix it by:
>>>> 1. avoiding migrate_vma_collect_huge_pmd() if some collection is done,
>>>> 2. skipping the rest of the range if pmd no longer points to a pte pag=
e
>>>>    table.
>>>>=20
>>>> Fixes: a30b48bf1b244 ("mm/migrate_device: implement THP migration of z=
one device pages")
>>>> Reported-by: Sashiko <sashiko-bot@kernel.org>
>>>> Closes: https://sashiko.dev/#/patchset/20260706111958.3649651-1-wangke=
feng.wang@huawei.com
>>>> Assisted-by: Claude:claude-opus-4-8
>>>> Signed-off-by: Zi Yan <ziy@nvidia.com>
>>>> ---
>>>> The issue is spot by Sashiko during a patch[1] review as a pre-existin=
g one.
>>>> This patch has the minimal change. An alternative is to reset
>>>> migrate->cpages and migrate->npages and restart the whole range from t=
he
>>>> beginning, but that also requires a restoration of no-longer-present P=
TEs.
>>>>=20
>>>> Link: https://lore.kernel.org/all/20260706111958.3649651-1-wangkefeng.=
wang@huawei.com/ [1]
>>>> ---
>>>>  mm/migrate_device.c | 19 +++++++++++++++++--
>>>>  1 file changed, 17 insertions(+), 2 deletions(-)
>>>>=20
>>>> diff --git a/mm/migrate_device.c b/mm/migrate_device.c
>>>> index 2fffeb1f99694..6ceb47ec1da24 100644
>>>> --- a/mm/migrate_device.c
>>>> +++ b/mm/migrate_device.c
>>>> @@ -257,7 +257,12 @@ static int migrate_vma_collect_pmd(pmd_t *pmdp,
>>>>  	pte_t *ptep;
>>>> =20
>>>>  again:
>>>> -	if (pmd_trans_huge(*pmdp) || !pmd_present(*pmdp)) {
>>>> +	/*
>>>> +	 * Only check pmd when addr is at start, namely no pte is collected.
>>>> +	 * It avoids collecting the same address range [start, addr) twice
>>>> +	 * and overflowing the collection arrays.
>>>> +	 */
>>>> +	if (addr =3D=3D start && (pmd_trans_huge(*pmdp) || !pmd_present(*pmd=
p))) {
>>>>  		int ret =3D migrate_vma_collect_huge_pmd(pmdp, start, end, walk, fa=
ult_folio);
>>>> =20
>>>>  		if (ret =3D=3D -EAGAIN)
>>>> @@ -267,8 +272,18 @@ static int migrate_vma_collect_pmd(pmd_t *pmdp,
>>>>  	}
>>>> =20
>>>>  	ptep =3D pte_offset_map_lock(mm, pmdp, start, &ptl);
>>>> -	if (!ptep)
>>>> +	if (!ptep) {
>>>> +		/*
>>>> +		 * Skip the rest if pmd becomes huge or cleared. Flush if any
>>>> +		 * pte is modified
>>>> +		 */
>>>> +		if (addr !=3D start) {
>>>> +			if (unmapped)
>>>> +				flush_tlb_range(walk->vma, start, end);
>>>> +			return migrate_vma_collect_skip(addr, end, walk);
>>>> +		}
>>>>  		goto again;
>>>> +	}
>>>>  	lazy_mmu_mode_enable();
>>>>  	ptep +=3D (addr - start) / PAGE_SIZE;
>>>
>>> It's hard to express which feelings reading migrate_vma_collect_pmd() g=
ives me,
>>> haha :)
>>
>> I guess I have the same feelings.
>>>
>>>
>>> In case we split ... couldn't we just undo what we already did, before =
doing the
>>> "goto again" ?
>>
>> You mean we reset migrate->cpages and migrate->npages and restart from
>> the beginning? But it is not only that, since the code below also
>> changes PTEs into migration entries. We will need to revert them as
>> well.
>>
>> Hmm, migrate_vma_collect() documents itself as "update the src array and
>> "takes a reference on the page" without mentioning changing PTEs. I
>> wonder why changing PTEs is necessary, since later migrate_vma_unmap()
>> also changes page table entries to migration entries, although
>> migrate_vma_unmap() changes all entries to a folio, whereas
>> migrate_vma_collect() only changes PTEs from the specified VMA.
>
> OK, it is an optimization[1] when migrate_vma*() was introduced. If
> there is only one mapping, migrate_vma_collect() will set migration
> entry immediately without waiting until migrate_vma_unmap(). Fun.
>
> [1] Commit 8c3328f1f36a5 ("mm/migrate: migrate_vma() unmap page from vma =
while collecting pages")

Hi David,

Do you think this patch is good to get in? I would like to get ack from
you.

Thanks.

--=20
Best Regards,
Yan, Zi


