Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 02EE8D29DC2
	for <linux-mm@archiver.kernel.org>; Tue, 13 Jan 2026 03:25:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6669F6B0005; Mon, 12 Jan 2026 22:25:02 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 614E86B0088; Mon, 12 Jan 2026 22:25:02 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4A26E6B008A; Mon, 12 Jan 2026 22:25:02 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 36BFF6B0005
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 22:25:02 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id C75C11A167E
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 03:25:01 +0000 (UTC)
X-FDA: 84325499202.07.5F5A119
Received: from SA9PR02CU001.outbound.protection.outlook.com (mail-southcentralusazon11013001.outbound.protection.outlook.com [40.93.196.1])
	by imf13.hostedemail.com (Postfix) with ESMTP id DD35720003
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 03:24:58 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=lVY+ULJr;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf13.hostedemail.com: domain of balbirs@nvidia.com designates 40.93.196.1 as permitted sender) smtp.mailfrom=balbirs@nvidia.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1768274699; a=rsa-sha256;
	cv=pass;
	b=lMdrouQ2yCLycAIwjWIazeUI5IivTdAZtPZ30oioF1zu6aB3+/CSApCwViGP2PhIFZvR6t
	w74RCnQa93h56oa09zLT6xDdmRum2/b6PZtcZUdb+iJqIT4Tzeui3F+617gkIqkACOYZk5
	/trasIvdDCNvFZ5odx/I1/QrQI5XVK0=
ARC-Authentication-Results: i=2;
	imf13.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=lVY+ULJr;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf13.hostedemail.com: domain of balbirs@nvidia.com designates 40.93.196.1 as permitted sender) smtp.mailfrom=balbirs@nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768274699;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qputef999k1LF3zGwDw+bJwBR7qBsw7MFiv2DZauONg=;
	b=l5Vao57Mbc0YKqEIOWs7HAkteMiVR1QIYIk365Zz9whpaOvXQSyTRI59Ohte/1+6Px2jdz
	7sjS7WtgMnR80gnJYriCp8/3YAQDCl1LavwodeDfi2i+PuakCSKlR7PILBJJ4Dy7nP7H73
	V6OfYcbcEZnUDf2qRcs/p8qhuiKGM1A=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=DQqpCxqu+DsNDChcEz3s80q8N6v3CPTRxKLM9LFFObvg887gj8zXJN2G/0lcgd777+LubpbZ4Ug9iehEp96EvRFywasD61cP/qTEIFKhtDXlkKM0wnYTzXtgLMiMeRgBCW7pgfpdiGYEmErr5fIEofa4hu+ek5CyLVbBFGC0yoAoNHs8MhTJHrWkYroYNqBVFcroEGQSbgKcUbcj9BeiJbHMi/Z1X8YhtoWDGVczmQnfCDkzyhAL9NqC7rPf/hbKDyUiNb6vBCNwfHhnv+Mkyu9tFTl7NlzBnqw4idPLyhLWrr/j/rNMELtgTwi1bo6TboglAsLkO3NXh70nVuttPQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qputef999k1LF3zGwDw+bJwBR7qBsw7MFiv2DZauONg=;
 b=V78z13Z2wOrx8VCaUiuLzBjzvMXF9iXWl1dkwh3OEGDZS5zzwVwKaF+A7V+BgoD3DjtM0lhlb4KCiL9GxLH2DWjkrS85OKFbXbkO5orVmbRCVXpTNkFaYtiklCwBdRdjZiQ09ULhXOWNd3SdYaKvlhpokY076OVhJ6rsj3QPEoTamMdsc93MGO1hUw0d5pta+U3gDGfn6dvsVs+NEhDw4UFpuH3oms/3GxtNhzAv8htBDqnNMuHQ7GlsYObTeK+Mm36UIaViCugtmubJ4PLdC4sl9mNELq0XV44xc0VmnmZLY3edc2xPiq/i1TXSVi7hCCe74krh1jeLoffA6l8Nmg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qputef999k1LF3zGwDw+bJwBR7qBsw7MFiv2DZauONg=;
 b=lVY+ULJr2E5L2ztsBdSz47ZECxvDiNupU75CW6sap5eo6DZOqw0cehrtRuT1uLPsbtgGQLZGYtMklPUNbAQdojqbU9fWRuoCBC+FbMsybVQqtzUnni890deSqkbP6ecFx38ijeEB6b7fjlkliPAOTUikgeNM8Jl4CCMmcyrsxBTYTcgBHgF3RrtHlDpdH2GYHvtHnDUZ3CECMt2C2Zu/Cy21w+UQQPWhrNiwYlevi+ioXgsrTwiXdcEJKbDevnrxmWzVxcXbf0w8bE+AoSC+z7aT1Zd4M/5wVgTnpKvVWJZOF7nJZ89zJQJNcJuvBmb5Dz86dw1DEA6VU28ZAiZ6iw==
Received: from PH8PR12MB7277.namprd12.prod.outlook.com (2603:10b6:510:223::13)
 by IA1PR12MB8468.namprd12.prod.outlook.com (2603:10b6:208:445::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9499.7; Tue, 13 Jan
 2026 03:24:54 +0000
Received: from PH8PR12MB7277.namprd12.prod.outlook.com
 ([fe80::2920:e6d9:4461:e2b4]) by PH8PR12MB7277.namprd12.prod.outlook.com
 ([fe80::2920:e6d9:4461:e2b4%5]) with mapi id 15.20.9499.005; Tue, 13 Jan 2026
 03:24:54 +0000
Message-ID: <91015dcc-6164-4728-a512-1486333d7275@nvidia.com>
Date: Tue, 13 Jan 2026 14:24:40 +1100
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v3 0/8] mm,numa: N_PRIVATE node isolation for
 device-managed memory
To: Gregory Price <gourry@gourry.net>, dan.j.williams@intel.com
Cc: Yury Norov <ynorov@nvidia.com>, linux-mm@kvack.org,
 cgroups@vger.kernel.org, linux-cxl@vger.kernel.org,
 linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, kernel-team@meta.com, longman@redhat.com,
 tj@kernel.org, hannes@cmpxchg.org, mkoutny@suse.com, corbet@lwn.net,
 gregkh@linuxfoundation.org, rafael@kernel.org, dakr@kernel.org,
 dave@stgolabs.net, jonathan.cameron@huawei.com, dave.jiang@intel.com,
 alison.schofield@intel.com, vishal.l.verma@intel.com, ira.weiny@intel.com,
 akpm@linux-foundation.org, vbabka@suse.cz, surenb@google.com,
 mhocko@suse.com, jackmanb@google.com, ziy@nvidia.com, david@kernel.org,
 lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, rppt@kernel.org,
 axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com,
 yury.norov@gmail.com, linux@rasmusvillemoes.dk, rientjes@google.com,
 shakeel.butt@linux.dev, chrisl@kernel.org, kasong@tencent.com,
 shikemeng@huaweicloud.com, nphamcs@gmail.com, bhe@redhat.com,
 baohua@kernel.org, yosry.ahmed@linux.dev, chengming.zhou@linux.dev,
 roman.gushchin@linux.dev, muchun.song@linux.dev, osalvador@suse.de,
 matthew.brost@intel.com, joshua.hahnjy@gmail.com, rakie.kim@sk.com,
 byungchul@sk.com, ying.huang@linux.alibaba.com, apopple@nvidia.com,
 cl@gentwo.org, harry.yoo@oracle.com, zhengqi.arch@bytedance.com
References: <20260108203755.1163107-1-gourry@gourry.net>
 <6604d787-1744-4acf-80c0-e428fee1677e@nvidia.com>
 <aWUHAboKw28XepWr@gourry-fedora-PF4VCD3F> <aWUs8Fx2CG07F81e@yury>
 <696566a1e228d_2071810076@dwillia2-mobl4.notmuch>
 <e635e534-5aa6-485a-bd5c-7a0bc69f14f2@nvidia.com>
 <696571507b075_20718100d4@dwillia2-mobl4.notmuch>
 <966ce77a-c055-4ab8-9c40-d02de7b67895@nvidia.com>
 <aWWGZVsY84D7YNu1@gourry-fedora-PF4VCD3F>
 <69659d418650a_207181009a@dwillia2-mobl4.notmuch>
 <aWWuU8xphCP_g6KI@gourry-fedora-PF4VCD3F>
Content-Language: en-US
From: Balbir Singh <balbirs@nvidia.com>
In-Reply-To: <aWWuU8xphCP_g6KI@gourry-fedora-PF4VCD3F>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR05CA0105.namprd05.prod.outlook.com
 (2603:10b6:a03:334::20) To PH8PR12MB7277.namprd12.prod.outlook.com
 (2603:10b6:510:223::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR12MB7277:EE_|IA1PR12MB8468:EE_
X-MS-Office365-Filtering-Correlation-Id: 7984bf14-3b7d-4f28-b7af-08de5253520d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|10070799003|376014|7416014|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?MEFXUTNuL2syekV1VVE3YjFwTVVRaDhFd09qdVFhODlqNkVpcXNZZnZUZnNY?=
 =?utf-8?B?QThhQWZQc3YrZjNIaWJESXVjaHUwWFNiMDNZeUxxRHNSZ1psdzIrQ1JyUXRN?=
 =?utf-8?B?R2krN3V1L1dKaTRXZUE4b05wcGFOVHVGTnNzRGJBSWxLUk81c25mem13eWlu?=
 =?utf-8?B?OEc0S0N0Ykp2T29VcDhVK21PVWZYRmFjS1dvSFBnSWJDRmxod0RvR3pwVXda?=
 =?utf-8?B?Y0NwK1Y4dWxHZXFKQ0V5bWFEWXR1LzVIQmhyNlZzWVVzODdXS0lLaXU2RVFH?=
 =?utf-8?B?eHUwU1I4Q3poYlErSEhGdlc0WDhicnRrQ0pJRlp5SkdMSEdqcGNOZ1QzSzJ5?=
 =?utf-8?B?VFB0NlY4VXp0WURDZ0YraCt2dmN2bUFENzhpZjBlcGNzamE0MGUwcStQOG9m?=
 =?utf-8?B?Z0o0MXJzQkRxaStaZDBuOXVNb1d4RHBEaDVFcURFenVaSlhVQjNITUNvK0o1?=
 =?utf-8?B?VTl0S0NxbVhEdWljUUM1eDdRM1IrN2twVFlZZytRdVY4UDJYWGhtbFJLZUNi?=
 =?utf-8?B?SW1VdzZTaWFUVWpnbkNTVitYelBLVWtYWDNMQWJpZ09ISlR1N1U1VFBFazdY?=
 =?utf-8?B?ZjBCb3p2TVRIeEE0MU9hZmd4OVJhT3Q2d0REVnFGUHBNSHU0MUNIcE5vWmdm?=
 =?utf-8?B?MUU1ZGc4WXVienpTM3ByRVU3QytuQ25BV29CVGc4amhGbUkvRXZIZGc1TVJZ?=
 =?utf-8?B?dVRXNHdVdEdLRE5GSVc5MElGbzdIU0ZYTm9WajNHSTg0SDNJRnBNMTd0MXU5?=
 =?utf-8?B?QjMwVkJpNnNvYlpOeDRoTlNRdTBpRWZuNStXV1Z0R01GeU5wZ2l5V2FNNzdF?=
 =?utf-8?B?TjhsYThLbWpXdjRoWU81dVVMSUFVZDJlUDlPbEJxT3ZNbEZjN25rSTkwUFl3?=
 =?utf-8?B?cEpvMnF1T3djUE43clhuRUVZcEJUbHJoNDI0WEgycE9pRTk0aDVHZldweWU3?=
 =?utf-8?B?RU1SckRoUWNRMnZpdE0xTzc2ZE9wbm9wNklkWGkyTEF4dkNYdDZRODdJakNo?=
 =?utf-8?B?WHBJKzM5TWtkMmc2K3M5bjR4THNpa3FSbml3REU4MU9oQ09GemhBdTVNa2Za?=
 =?utf-8?B?dURwUHNtVFhYT1N2VTF0ZjBiQWFFMGoxTkFEbHRpZ1lkdE5wc3NrTHliUU8y?=
 =?utf-8?B?dnc0K215aXBMVVpVUHM2cFU3bnhLU1Q2WmJNZlJiL0REZWtiZm14UHYrVHNG?=
 =?utf-8?B?ZE1rcTFaNjlQTHRQQ0JzSFJDUVhaZ0pLclRpUnV5YnFqU0twdFMxUDliMlZ1?=
 =?utf-8?B?QlpwTXpkaFNraUw2ZnM4dWpLTVBNbDZYeVFuSm1jT3lBOFA0V3dOMTNiOGRh?=
 =?utf-8?B?aFptZnR6TWVEZlBuODVScTJqUEQwRk94SmdxdGs5czJlSTJGSDR5Q29ZNFha?=
 =?utf-8?B?TkVhZm1BbU9QODFENVBaWmRKNUpaSWhzeFRla3FKMi96MFFUTlBEZThzek1n?=
 =?utf-8?B?ZllPUkNWNkhSR3lPaUk3WHNGNHNOYmx0a0JjeWtXeG9OR0NUSFJKbTRtZzR3?=
 =?utf-8?B?MkxXVnNsRDJnQVpnTWg1Qm56TFhDRmlrZ0FFRW1DQkV5N2piQ25WalBUamtD?=
 =?utf-8?B?dnptZ1FKaUtIRTNzdEl6anNROGcrWFhOVFVTcHVDclVPLzIrYTdJNzhsY1pP?=
 =?utf-8?B?MmR1TWhySXpZSnhkV3Z2ODJuSlpmc1ZVMmd4T2J0K3ROQWJWdWl4MTUzdXRV?=
 =?utf-8?B?cmZYdlRiZmtvOENhUlVFRTdmZ3F0K3FLYTNneUpLR3QrUG5qSUV1YUtnc3Ar?=
 =?utf-8?B?MmVTSlR5WjZEVitFTjQ2dXltREV3UjRDNlM4U0hkLys2YitkMCt6OVhOUjA1?=
 =?utf-8?B?S3N4RVp0dlVrKzhBeFNBeXNoM1VycCtFUzA4Y3U4UFhFL0lkbDZFVkc3M29h?=
 =?utf-8?B?U0Z1ZU5qTkNJelJDRzljQW03L1NqMXZxeWtuNjBDcjFuWXV2OHJqK2EyTDFM?=
 =?utf-8?Q?2zM72TTedseolFPo4pVcoj1qgNg0orex?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR12MB7277.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(10070799003)(376014)(7416014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?ZGNhdjNzVnB2MmRYbkE2bDVyV2luZURUQTBkZnN2WGE3Q0pSeld0K21VSm9K?=
 =?utf-8?B?b1ZFanRQTTFyVzdRdVBOd2Qzd0FoSis2a2RZejJhSHRXVGpCaWJFekpBR21S?=
 =?utf-8?B?V3JXb2dENndNWUJ0YXkwOWs4RElVek9HZDd3elNCZ0FSUDdIT1pORmk2N1ZN?=
 =?utf-8?B?a3Vtc1ovVXVXblN5Qll0b25BaWhXRE0ySXpMVm8vUDcrRFFWZUhWanhLd1No?=
 =?utf-8?B?WG02QmtkdW9MT1QybmluWlV5OU5lNlY0Mm5pSDZDL2FTTTYwcGV1L0xhM3ZM?=
 =?utf-8?B?cW0rV1YyczdnNHVPTlB2Tm96cysxSkNQbzlONDZCWUFXamxQNG1UdW5JbDky?=
 =?utf-8?B?N3FCc3BXOXZjQ1VzMmU5RTVocDd6UzdSUmtEOVlvTWdhUFI3MGY2K2hpcmZZ?=
 =?utf-8?B?QVFVRFVxVjRPamVUMjdXYjZURkd2Z2E5YWRBdDlKZktzcXBvVkFKMUhrMGRl?=
 =?utf-8?B?dnE1RjdqTnZGdUpOVFhLV0hBNEpkTmo3a2NWY0tTYlBkVGtWd2l3S2pjdjhy?=
 =?utf-8?B?aFgybklMNlJSODdkZUNxbzI3U1YwWTd2RVBVeTVmaFBKRDJNWEdjQ0hwZHVH?=
 =?utf-8?B?SW9EdlVXZDBOd00zTnR0cEFXbVNzblk3TVIrQ3BJb1hyQjhRNnZucVZjNnJa?=
 =?utf-8?B?bFFjU29xeU1jdVlkS2FOUm1kejFmZStvcDhHNHo3MHZHVW9lbW1wUXRIUjc1?=
 =?utf-8?B?OVZpUDNFRlY0dFh2QlY0c2VHc1NsZWNwTmduUE5GMVpkNEl1Y3NFUHJ5WHpx?=
 =?utf-8?B?enVYcFFUOTJHcis1MklWRGFoVHExVzMvNDZpYVpXbmZMZ3M0M0JOcXB0Q3VL?=
 =?utf-8?B?NUVHckMrY25wUFdIQ2dsTGxOQVFteFNvVWthckJySTRVd2pteUxwcm5xN2FI?=
 =?utf-8?B?ZkpPbi9BSk9pZXg0K0J1UmplZXY0RUdpWlh4Tno5Yy9XS29DaFhLR0pBampi?=
 =?utf-8?B?bzZkMWxtRXRJUWxoZDFveDZXZ2RJUFNvYmtZMHR0dlZYTmZHNmxlc3g4a2NO?=
 =?utf-8?B?K0xYdm1YVTdTSzZGdnZ4T2FibmdXQnI4WHAvNFEweFZGZWdUUU1GelBQTHpr?=
 =?utf-8?B?YW1aZmw1ckdSd3NONmVKU2RyTTBDYWEwdFpZSkxONFJiRnFiMWVBYmdDbUF3?=
 =?utf-8?B?dW0vTnJCb3NNS2ZiNzhDTnZ5RUsrNUI1SzFNaDVWbk1YbVBraks5bHF0RVZl?=
 =?utf-8?B?U1RxU0hqRHJLNXNSTjhmamJEbnh2UTE4cjExaG5wRlN5WHU2THo4dDlRM2dX?=
 =?utf-8?B?ak5peFlOT0tYMmp3N3pWY0J3c2IveG1INDhDR1pqaE0xVzVyQTNXazFZMmgz?=
 =?utf-8?B?ZzhZeExndlpyQU8vLzZUNGNYaWdhZS96dk4xVWNLd1gyRTlxRk8vOEFGc0RZ?=
 =?utf-8?B?dHk3eGpIYXBtZ1MxWlhZRWZXSEtqTXYwQk1hdFhlam9HY1pOOTJNR2QzUVN5?=
 =?utf-8?B?azIrK1ZWRTlmQ0xEWERwTzN2WXVtRjd4YTQ1dzRScUxFMk11R3gxU3ptWXpI?=
 =?utf-8?B?bU14RldqakxsRVdoUlFEbExUeVZmOXNiOEtwSWVSV2Z1SjVTa05VVU8xK0lM?=
 =?utf-8?B?NG9rdVN6TTNxS1hhSnAwaGdJYWVpdFRmT0kxd2szdGZvUi9BMmFDRUlQbUVp?=
 =?utf-8?B?N1VwRzJ2UmY1NHl1Z0Yzak0zbjNwaXNhT3o0Y2pxcmZnQjRNcmIvUVdGenh1?=
 =?utf-8?B?dmxZSSswbWFpRkpnZTQzY29kY2VxOVo3anVsbXRaRTRGak1EUjR2OXB6dThw?=
 =?utf-8?B?THZUZjR6dnFZRTR3YXBFMk9CK1VNaWZzV1QyTTI3M2E0OUkwUFE3OVdscWI4?=
 =?utf-8?B?THhwT2tDQ3lKeS94b3o0MjV1ck4xUGtFcEJNM2MwdlJOYTg2YmVLMlBiQ3dW?=
 =?utf-8?B?eUNhc3lQUjI1RlBqSm05SUxqUGZyeW96dW1zcTRNYXFueDlCbEQ5elFXUW51?=
 =?utf-8?B?VkNtSVRQUm1CN0NVSzh3SXhqbjRsU21aYjhTQlFvSkpvV0RoL05DOVlXNzVo?=
 =?utf-8?B?ZzNCdDBJdXJZSk91M1oxMEtnYnZHdWRPa3phQ1o2TzU2cS9ZY1RyUzVJdGhq?=
 =?utf-8?B?MXlpeDlJWXJXbVc1YzYzZU9zYTJUcDBFTDk2MndONlVFMTVsaE8xV2Zlemlm?=
 =?utf-8?B?OFF6YUdxVk5DbHpET3IzeHNBUTZxdDRNNVBvUHo3ZEVTZG5QeTRTRmUzckFB?=
 =?utf-8?B?QmpyanlLTS9Rc3VtSVh1cnFJd0pUZUF3WVNwZnlMTkI2dEZOV01IcTB0Qk01?=
 =?utf-8?B?TFd2RXY1dUpjM284Ti9UZG1aQzNkRE1wVWxITitxdnJzMUhyUVcwMTNJQlVp?=
 =?utf-8?B?Y0lUbXJPeDNRWUR1VGZPT3hsME9zNnNMb1JpQ1NHZ3hjMjJkdEhhVnJPeWlM?=
 =?utf-8?Q?jSHS1IkPn4Ls9NDBvdn38VUd+oFkOVSu+3wYd6TRLNetV?=
X-MS-Exchange-AntiSpam-MessageData-1: XFpECy/Afys5lw==
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7984bf14-3b7d-4f28-b7af-08de5253520d
X-MS-Exchange-CrossTenant-AuthSource: PH8PR12MB7277.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jan 2026 03:24:54.6672
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pQhSX6ZCxtlmMbMdO/16OOFDGfBrKtnw9M+6wg5QfHQDwO3NXHB6YXMob6PKffdAj7okpZI+Fh63G72jfpbGsA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB8468
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: DD35720003
X-Stat-Signature: hbqsjy74nebi9d7nusp46ykzbab5hgzj
X-Rspam-User: 
X-HE-Tag: 1768274698-333088
X-HE-Meta: U2FsdGVkX18crLYD3CzDLK7w0ClGsUaWMgWtOjRYl1rpt+EZwaYM62WR9ongN2xLgWiTf6DduGl60wkrQcA9H6lFGgR8QcFJnR2auqM8QFqGwGOirabzJJTP+FdmUAqgGo0RvI3DJPjSoz6Hs98Q0IJE4aAfQdY+m0OHzJtHCVFvZgL8Eb76ClgVMvbhi1EC3Fvw/IB+v2GE2U8T5P93m3UdhpPG6h38kVElPcRdZF/hivo2oICbM8fKONG7+toG7mYZpQMrF9xCT7vQHfCu9yTZp/fhIEx6RPDZ5/7Ocj0KfiBav6P5PuzfO+TsuQzyNmzOgnATNw309z8+afFDtOp1YQbbEAogNtz822h5ZvVKA+rPpA7irfsFtgAAb+FRndS/PPlWTOiPbiz7nDjNRUiA83pGkvBiYQ1vVp17C+OGrTPc05NilNEfUkInsk9bdqXQkHFXSCp9TytNMld3jxABm25xASpKe4v/7gn8XRADsbhBlIXF7t1fNzz01/m+sG4+7TXjAOdAWoQHlrH3zUMYm5I8sNrmCKLNwbakj5iMRHQa0nfOgk+V2QuTmcHIyY8Sdn12YBcBnPa9XtDDrG2BWCaco4pGz+ql25DR7geESCGL3PqcrNcm+d3MYjKk632U7p3XHQgrBx79CVP4krXQmR4b54zHYIBU86fxlk2RX5/ViJJ1LgKCgh2RS/IkIZzboECf7i4NQjGHfisGUBDqeGxdaZWkNcGiRRqZPbg96LdPDolGMN5ffN+M+EyX2hUNrK2I5yHdwfXdpzwCItOlv3CWdqq5Kpw+snSE25FykygxvOm6gUvVlfTN+LELB3nnbptqXoMps99w3YgL8vyX2Ipfc/Po3qINK46e9S74UB0Kc2DjmRizUR2Q2QCizYZlec659mDNEdpYwr+NOhH9YYa+bsf5FdcA5Iu49RfSql13bHZpsMAuByXNLqOO3DcJJCmbqHJOumKd/Nc
 zzSJmdbJ
 wJkxKiCd6yG6f3t/E9Uh75lsHceXz80On79D3wXuhpBsYO/4qneYFAlpmVLDsaIiYtg9hwwNTYH6reRDtNErmi1bcFcz3fpCI/u2rEaf9547tOEiLST4pBX/5WLropCXN6Vl5Un637hUo6UNR1SGLn+C3HxjdSwNh0vZP6Y4GZIVjTcrkIxS7qBAB93d7t0mUCJhQzF41npFu2N8ZBIVX8yvZldO+ryJyQQ/6lktTQ9aXd8HgFdHkT1sT+PBg25axKe8itDgi12tfrCQcb5vEWPERbzH+sY6cY0m1NHaDfuwDfO6CiWR0vmd8CwvZ8NJxPDand5j0exS7hUWHLRwZTl5hKUawEbc+kLdwGXnODw1nV3a6oC5wmc2cTmfAHTui9RW2BqH6BR8lmDrTFK70ZvzyclQRWhak5vZeMXm5Gaj83+3p5YYGtZZetH3AG1jUFneTnt+gmIGCIiaRRDVvyy/lqyl4Q+0qLoJlvp5eD0aFhs9L0Jks6fs0JVOY9h3odCLRvpV4c79McKc3Iv3cvuhkf9lb/dvshl6vp0W7cimx1L8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 1/13/26 12:30, Gregory Price wrote:
> On Mon, Jan 12, 2026 at 05:17:53PM -0800, dan.j.williams@intel.com wrote:
>>
>> I think what Balbir is saying is that the _PUBLIC is implied and can be
>> omitted. It is true that N_MEMORY[_PUBLIC] already indicates multi-zone
>> support. So N_MEMORY_PRIVATE makes sense to me as something that it is
>> distinct from N_{HIGH,NORMAL}_MEMORY which are subsets of N_MEMORY.
>> Distinct to prompt "go read the documentation to figure out why this
>> thing looks not like the others".
> 
> Ah, ack.  Will update for v4 once i give some thought to the compression
> stuff and the cgroups notes.
> 
> I would love if the ZONE_DEVICE folks could also chime in on whether the
> callback structures for pgmap and hmm might be re-usable here, but might
> take a few more versions to get the attention of everyone.
> 

I see ZONE_DEVICE as a parallel construct to N_MEMORY_PRIVATE. ZONE_DEVICE
is memory managed by devices and already isolated from the allocator. Do you
see a need for both? I do see the need for migration between the two, but
I suspect you want to have ZONE_DEVICE as a valid zone inside of N_MEMORY_PRIVATE?

Balbir

