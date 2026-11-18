Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 41AB4606A333
	for <linux-mm@archiver.kernel.org>; Wed, 18 Nov 2026 07:54:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=BpH9clYr
Received: by kanga.kvack.org (Postfix)
	id 3BC806B00EF; Wed, 18 Nov 2026 02:54:11 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 36D726B05B3; Wed, 18 Nov 2026 02:54:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 237636B05B4; Wed, 18 Nov 2026 02:54:11 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E8B836B00EF
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 02:54:10 -0500 (EST)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 7C9B2806D9
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 07:54:10 +0000 (UTC)
X-FDA: 85447476660.04.CD2CB7C
Received: from SA9PR02CU001.outbound.protection.outlook.com (mail-southcentralusazon11013021.outbound.protection.outlook.com [40.93.196.21])
	by imf09.hostedemail.com (Postfix) with ESMTP id 98AFA140005
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 07:54:07 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=BpH9clYr;
	spf=pass (imf09.hostedemail.com: domain of icheng@nvidia.com designates 40.93.196.21 as permitted sender) smtp.mailfrom=icheng@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794988447;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Bz0I6CT+DYTzmMDg9zFl71rJDbnSeOrM3Ki4H2rXybE=;
	b=pZyI71cLlhxugvECW5xPGt2+n/3HKc3IJFCS6Th1mWFsSBEhZcdi63m+L+XHAInheenU1f
	IT3JWkMIifo3WCowSEXtJBrMidLiCBLpU9Fel6RcDfQ9mis5oWMDQtv27y5qQbrSGNgEWP
	zWqJOAYYJuCNoC54ThJl65hMfOg+57M=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1794988447;
	b=EmMZSBAqNPJP+EqjuorG/ANiTRcRpO3iPTBi73YxRyo47u60SJhRw2FUYDg84ZrQd+Okie
	p5lrn4PYT2+lcMj4fRCyt+PYV/BbSPj4kT1T7WV5Ko/JvmzNQQ9TQ2GDIbKmpF5scTq5UM
	z14wG0jlWUq9qNPVtGF7ebB24m1We5s=
ARC-Authentication-Results: i=2;
	imf09.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=BpH9clYr;
	spf=pass (imf09.hostedemail.com: domain of icheng@nvidia.com designates 40.93.196.21 as permitted sender) smtp.mailfrom=icheng@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Q9MzpVI1lUReK/5fEPe1Uv/EKO/+8xUO4q6wSeRJUKod4q/5UjUOidslkeet9102pkF6h1QVnctAJztUpVp7ULhMAgUv8RDWFGQxi/lcvP8GTh1lA4Vdl4FHfsZO07AbuHHXioUard5v6A3sdFDVLwj43XijLZP4kGO/cLVo22lnzHzzEI/ANyPK6WtpfwotVHNZnVRH2QLdtQYhQ0Z3MUGDJkIWrPYrUgW/XZRYVHeGDtBTe0SLHWBe/mhzQBi2UdBZxaCutuHBJGeirCpTflMx6ZBtJSFoSVONzjIX/pPW5/G7qY2rg7AnM9hT+BDTqgiOdhNNIZUiRwO3QOjH5g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Bz0I6CT+DYTzmMDg9zFl71rJDbnSeOrM3Ki4H2rXybE=;
 b=Au0WZTPZsc7nPb1AjT/0esAV6h4grgTK9iTMv77X5bEcpgH6L9+iTcJGoo2lfMrZ8lejQCW0RkaGTkvmXpZKgZebnFFSr6VK34VzuYmv449r4q8E4CIQeoDzOYGBfuyHW+hB+5Eb7z5SO4SScM2BasNiF6HBXHCKYE6twJhW4ZNLgw6nq3RW1cMiu8HXv0Rc+8gB7ymF6YhVQCEgQg/UvOfDkEBmh69S11hGrrVv3+XUs98341pIVOAdJ2TF8V+0qKxKv4tIHbptLPSCNS/E23yJWeqzPAtSRvOSLyBCU1oQbDYRvpRQv6GUA++6enUA68dz5SZGUYGEiSUuHMFGlg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Bz0I6CT+DYTzmMDg9zFl71rJDbnSeOrM3Ki4H2rXybE=;
 b=BpH9clYraFNPXY6oCG/ZcfUhjS4D3C54SPfIdbctsO0jPps8wK0hvENfwK2/EVqIHGZXQZ4d333msPjYSSiN/BAdKuj0a5rBSsV7lLEiyouP9Ar4n0O4s5Rjwl8HCU+4UaYDvlVNoCPotsD98BPQMiBjUz5RQa8lPSsT6eXHtSdBEAtLbEyA79cfrkz45K+ZwPlo3IINw4ihdVhGopADIymJz9u16YdQ5rWhe+OpubFCX59MFHU3phnmS478TqhT0vhFwwhFhyCUQghwZ6Y1go1JERIOJPtZzP80k67rcxzyqMj8ujPQ/ubOM6mVVUUqcQKwP0E2CFnAY+pE8rtQMw==
Received: from BL0PR12MB2370.namprd12.prod.outlook.com (2603:10b6:207:47::27)
 by MN0PR12MB6001.namprd12.prod.outlook.com (2603:10b6:208:37d::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.14; Wed, 18 Nov
 2026 07:54:00 +0000
Received: from BL0PR12MB2370.namprd12.prod.outlook.com
 ([fe80::86cf:c3ec:2cf5:74c8]) by BL0PR12MB2370.namprd12.prod.outlook.com
 ([fe80::86cf:c3ec:2cf5:74c8%5]) with mapi id 15.21.0615.009; Wed, 18 Nov 2026
 07:54:00 +0000
Date: Wed, 18 Nov 2026 15:53:54 +0800
From: Richard Cheng <icheng@nvidia.com>
To: "Gregory Price (Meta)" <gourry@gourry.net>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, kernel-team@meta.com, 
	linux-doc@vger.kernel.org, driver-core@lists.linux.dev, linux-serial@vger.kernel.org, 
	linux-pm@vger.kernel.org, damon@lists.linux.dev, linux-cxl@vger.kernel.org, 
	akpm@linux-foundation.org, david@kernel.org, liam@infradead.org, vbabka@kernel.org, 
	rppt@kernel.org, surenb@google.com, mhocko@suse.com, corbet@lwn.net, 
	skhan@linuxfoundation.org, rdunlap@infradead.org, gregkh@linuxfoundation.org, 
	rafael@kernel.org, dakr@kernel.org, johan@kernel.org, jirislaby@kernel.org, 
	kasong@tencent.com, qi.zheng@linux.dev, shakeel.butt@linux.dev, baohua@kernel.org, 
	axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com, baoquan.he@linux.dev, 
	baolin.wang@linux.alibaba.com, yury.norov@gmail.com, linux@rasmusvillemoes.dk, pavel@kernel.org, 
	lenb@kernel.org, hannes@cmpxchg.org, brendan.jackman@linux.dev, ziy@nvidia.com, 
	sj@kernel.org, muchun.song@linux.dev, osalvador@suse.de, nico.pache@linux.dev, 
	ryan.roberts@arm.com, dev.jain@arm.com, lance.yang@linux.dev, usama.arif@linux.dev, 
	kas@kernel.org, xu.xin@linux.dev, chengming.zhou@linux.dev, 
	joshua.hahnjy@gmail.com, rakie.kim@sk.com, ying.huang@linux.alibaba.com, 
	matthew.brost@intel.com, byungchul@sk.com, apopple@nvidia.com, rientjes@google.com
Subject: Re: [PATCH 02/22] mm: publish and clear node memory states via
 helpers
Message-ID: <av1ZBTpLpJC6DJqA@MWDK4CY14F>
References: <20261114070959.3490008-1-gourry@gourry.net>
 <20261114070959.3490008-3-gourry@gourry.net>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261114070959.3490008-3-gourry@gourry.net>
X-ClientProxiedBy: SI1PR02CA0048.apcprd02.prod.outlook.com
 (2603:1096:4:1f5::11) To BL0PR12MB2370.namprd12.prod.outlook.com
 (2603:10b6:207:47::27)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL0PR12MB2370:EE_|MN0PR12MB6001:EE_
X-MS-Office365-Filtering-Correlation-Id: 58f4c84a-3eb3-408a-5b28-08df45491b15
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|366016|1800799024|7416014|376014|18002099003|22082099003|261009223027099003|4143699003|11063799006|56012099006|261026140227099003|261028144727099003|261102123227099003|261102130727099003|261026121527099003|261021123027099003|261021121427099003|261022105027099003|10067099003;
X-Microsoft-Antispam-Message-Info:
	lt0OmyFX7aR4rBVqunNKivPTc9OTqiupFmFy2aOpjJx9PsEysqje2M1YoroCSIpniDYuwgI3zE2bqS3OcjVMzyTKHaGsgUplKRaaC9d0vprfClSlTGb4qJO3cJLBwBOa4w+kIYrqnhTBKMplvRazbrnVoExG7JxW5rYL6whX6j3V6Xrbywhph2WAI+2VqnCtIh36S1A5RrkmH72QrPpZtE6RdahSGPIrQvfk52T8diMQt1QQfP7CY9s0iv2AgDcvh8Oj2ss3vefsNxhQMJj+kqCjEZ4Ar6rIziIUWy++NNNmuMShRQwCMObmqdoioNVGHzEHLlAoh18Gsh3ocpbhtxCfhg6fO/C4gtJREYtjPOPH4adolMldHteF0HSlWaK0eX5FTcIvUbgkTND/OUviy/TEtD28/acHABKPYsdUwyhPlr6nsZnTpZg7NII2JpnUUWCJEgL9ioivWJp+3BWafNRoggXFcV1C63mYid5CgfbN0OEisnENRW6QFAM8Ta/J6S1tk8yF5ejFXOHr06fCMDDtSVgSKGIBrBKIrwLzdVAKlzgCPJT3cDaXXTHfPqsVeNN4C5r4mhmZXfLthSLewexn3qezylYz0QoC6Oo4lqdspKv6JSTUCluhE1b2VasgVkpcDvglwJdBcV4HNIBGq+DJx+Wt/vwp24mXWGQ0v3U=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB2370.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(366016)(1800799024)(7416014)(376014)(18002099003)(22082099003)(261009223027099003)(4143699003)(11063799006)(56012099006)(261026140227099003)(261028144727099003)(261102123227099003)(261102130727099003)(261026121527099003)(261021123027099003)(261021121427099003)(261022105027099003)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?MlJg5jCnkA9axlfdz5I1BjoPQcj1EUgFkKOEf3iwGjXIbH5kliFlzeDNvkYq?=
 =?us-ascii?Q?xP0//vqkOaBE+U2plNvjSKrO4QTI6YWmZkQTPDOEVSEJzMcurKMvQLRzG3Ov?=
 =?us-ascii?Q?N/6SnyqJKkUkBEbtm9JhifLzuNRnLnpFdqLBnkX9YnYwNRb2vTNA/h1gut0u?=
 =?us-ascii?Q?pZ6nrMdye7U2qaRe6FjJSm7IEjEK1pcxO+z01P1xLAzjRn0BR+WtS418+6cO?=
 =?us-ascii?Q?Nn8fMMTbiuimkTvow9ZYyNdIXQB1AaXbovQ53CN0ev2vvfpbpo1I4HUJKLsN?=
 =?us-ascii?Q?OUwhADhWC0/E6honjlaHFwSkxqnUHyPCDRj9SSXgXMeJElHfdkeAwiaEXiuC?=
 =?us-ascii?Q?CUWSNLc7grRPqeH1LmyEyC2iHjKp1jvMG7sifUhQHFGIA7dX7jhpYJbEwIRg?=
 =?us-ascii?Q?v4Ope3muirFwpF+qxRGm0pj0DElyvX4rdpw6HTyxupHNrXkM2Jta0uee+ydN?=
 =?us-ascii?Q?40VzldloW3D6JOy/QRoBgvsukBByzsxEk5MGGhe1FMkafMooHzTiSIidus2r?=
 =?us-ascii?Q?pUZ+gs5dEAgJAepB5qQsdIcNyzsMqvgntFY017EnDYug0V/1UE+qPjojQt26?=
 =?us-ascii?Q?+Uh8uHjVuDRqg+AiTLbUrB28EEODCf5R21cwJhfsMUfyOvp/aY4gQ/UiZZZO?=
 =?us-ascii?Q?S+HgesH2f/NcgEb4Cdl3LcDt3vZbxmuP3Ns629PnTk62E3+3NVJGCaoT87Nc?=
 =?us-ascii?Q?raL/mKgy8k9fwf1eQ6m2OnhRHUyx2Zwagb/O0T4H4DDNpBEuEjIFc/mjS2uQ?=
 =?us-ascii?Q?jo+O0eF+/lVr8/eXNiIe+EfB63Mbw+mTMLE78XeFKHvNK4kB4/9VC2wjzwH3?=
 =?us-ascii?Q?UuzfaIok/wa3/S+Sf5qi7b4/B/4fDOCsg9LZ73+KjQBWMOZcRfpNvhjEiiub?=
 =?us-ascii?Q?SFypMgg7WZS4d5h8391mYID6/8RCPskxXJVdc+WnBYJkiP6WrZUWJu8ilfC+?=
 =?us-ascii?Q?v/OhZWaz+0aKl1zVwOd6JEoFd3O+3GCysVu9OGvzRSa17tnXBtLo8nAlKngQ?=
 =?us-ascii?Q?nBfVvXvz38MmdbzHqi2CgSFvTDdPp85c0LeEcCtjI96H+8ZIzsFCE/ltP1CY?=
 =?us-ascii?Q?X5//S6NoU1g+dh754yu9UZN6XIKJaC7aHqY+5hkLHWZ5JSHeI6jvNJD8kALh?=
 =?us-ascii?Q?3fZYCZU7ogcm2T+0TamPf21BU/QVsobV6H/57IU1y0Gr8YUlH2MuxZ59rJXt?=
 =?us-ascii?Q?ryiUKqCv1gJOwh2BbU0HLIr0iszh5RLxXcEaD0YnCR7m+gyHBBesabMP2fWZ?=
 =?us-ascii?Q?aP4dMq/88PVz64l9JyGGsKWjQA9R+OsAI0Quu9QUhRl40TnOdjQJZewiK/Fl?=
 =?us-ascii?Q?sMhj47ClqW2idL/jRJREnt7II6zl5eaN4vNPM/IIM8Ks9xpB6X4JJxqnNvCV?=
 =?us-ascii?Q?EMtY4yTzw1by36M3v9QTuAc7Z6vp7biw5Vg8OWdcslNqrPxLnbRjiHy482cK?=
 =?us-ascii?Q?o2INXPYvRF7qHk0d/j4jMrFGwdecczeXFYEkHj+rBMILhmlkCcgQAwxz51q4?=
 =?us-ascii?Q?KM9fYcI4r9PYlvYn+ni8Ue8W4RgcXVn9dtmV52bpeqYv++8oHS0OIAaiXIc+?=
 =?us-ascii?Q?E9bZng82zkG7a1748c1qHXwEIUO71lSSWMeub5cPfKCHa6LXs/ZDOL2rGnVC?=
 =?us-ascii?Q?2CCa8NK+H6wM3d5leyOcU2d2sBgzItOho4WIc9xdKYJVKPCKr9dvHxkK/Ird?=
 =?us-ascii?Q?cC+jtMlglfQHl2LlZWlbuPf65eNZDrV7GmMX0mnqik64PUld?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 58f4c84a-3eb3-408a-5b28-08df45491b15
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB2370.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Nov 2026 07:54:00.3567
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ocebmwWXrMmSKYPKnWEeRMFUUEweR/yVCOM2AHXa9Gs10IrbY5n4SS0Z7UbGqrQMvxze7Q5CAlBSXJDAcwUz0g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB6001
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 98AFA140005
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: aykmicwsh1jahecms7uwdj1x81rpuitc
X-HE-Tag: 1794988447-81682
X-HE-Meta: U2FsdGVkX1/4HwUsIlJhgZZ2BkoRU9khq+ctTFA1MIP1EabOsWFzitYmmqKvYYVhnd1Y0FhpTfK8SrbnWbvKkie8zYHpJsQ/2UclL+lqAwiAnlwG6FggVSBv/38MM9LCgm44oLHklnKvlnOHy2Vk6r5Imp8xI/c5VKJd3AZj5QUBD2gS+CIdBmwJV5bwzWyKx/dkpHhPPoccbnjNy4vSgsyfMf1tg6NDtsmEBdRMlP0IL4cUpOI3L6HOetAF4YuKaAWxAIBP9iQx7EuCF0N5QJ0ha5weICKimXJ8uP1dChFtNXohZPvQ3aqJtIcEmqnhwa4RxJdwC0rv8hZ9j2b7Qif3uG+0BjZkeBYJt4R8DvcxV3TUcP7F7bGPHxStCNqhpsPmoFt3Mw8v9Za5bwQH60Gpp8Ym6TLlupDWM2wJ8UXHPBO8dlIdd2s6X55jWNv3zjqscLXuj6Rvoz9eU1oslGUmjVmPB4s0rf2c083YGBQ2mmT4AFCzrQCI0ln3STf02gQCwgN73PMfyDsHruA6sWiKZHqhnOvoPBH3QJgKUHsj5uv5hEtqrXQhcazqGC8KHoo2ILydWsal/yYcfynHnITKPaFAZOM7FxKtur0TjjM/DyD3Ydiq6ZvVqJ5Y0ByWHOr77fx9HaDPJfiWKzUP2DSw6oIUoUZHu5OVacNMjmw/zm/H/aJVgjCHxA5CbyaDORLKcJ8Ershife1Fy51pmaP+ls//oHvWgUIgPij4wKatsV2bDfyUKMeSHgBAZogsdpHLq+VySZzNxMmvtmzCWuIawusHrv4zsNF5aWgW5qqayyyr3+Cmug8h7t5A9qv2WrcPYkNNUVXGgASkjSIVwi4ZtbBvbdXIAWvF7aj8Pmdbf2iPT2wC1g6KJVXaLfVJbolTYQj+hdXggdrDGHLaI3uGyfao2QM5qcVAICkGFXDiR65o8jB+cv42M5doEdAc/JscmNrgOzjTdPBNgqj
 EIYchicb
 P7ECuH+zNxf6eqT5o3ye/N19vE/2xMw/AjmoJYxltoaGxvUYlXn8vMeQKbUokphfJHookPZGgiVlOudVR4QQ4dqPk8o4TmJzEy38u3IxJfm2dqNnNkZV+V4PuRDoCYVpoMq0yWzK4zmAYJGm88A2nA1qjzzN7U+3lPwZCetEqZj3ZGX8YMaMZU9cGu0KE6Sm+ftnOtp20Oc8boYJaoetKxvaK5qDFSZhjVjCTH4hkCWejoP1YrX89AjtqNWipdP7d2xyHtI9Wk3TysBq0BuwikYwrn4XEikZ9qmc/ORZjZYQONCsP3368CLPID74Ooyd9EGx/ZYjvcb5B5g4nIemI9bFSV4MN9LsfkTy1zrD34EVP4oWsZkgzRkhHYjMJiehZauYh28zaRFxjf15rLDMSEg+kIOl0tyeR31bKtbWPkXCn0wOsF3tbHNvgywTHpPXUluvhnK0iezjtgIn1sVgVWcYj+kuIQ6O28SV6tG8kvmNnK0E0xNuZD49x9a9xAxGzfPEi3X4rymaJmxFhmGnDeaN00NUKFiIXvUYr
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Sat, Nov 14, 2026 at 02:09:39AM +0800, Gregory Price (Meta) wrote:
> N_MEMORY, N_NORMAL_MEMORY and N_HIGH_MEMORY are set separately in
> free_area_init(), check_for_memory() and online_pages(), and cleared
> in offline_pages().
> 
> Centralize those updates in node_set/clear_memory_state().
> 
> Behavior is unchanged.
> 
> Signed-off-by: Gregory Price (Meta) <gourry@gourry.net>
> ---
>  mm/internal.h       |  3 +++
>  mm/memory_hotplug.c | 11 ++++-------
>  mm/mm_init.c        | 14 ++++++--------
>  mm/page_alloc.c     | 15 +++++++++++++++
>  4 files changed, 28 insertions(+), 15 deletions(-)
> 
> diff --git a/mm/internal.h b/mm/internal.h
> index cd3675c044e0a..608a83c34c224 100644
> --- a/mm/internal.h
> +++ b/mm/internal.h
> @@ -62,6 +62,9 @@ void lru_add_drain_cpu_zone(struct zone *zone);
>  void folio_deactivate(struct folio *folio);
>  void folio_mark_lazyfree(struct folio *folio);
>  
> +void node_set_memory_state(int nid, bool high, bool normal);
> +void node_clear_memory_state(int nid);
> +
>  /* mm/vmscan.c */
>  unsigned long zone_reclaimable_pages(struct zone *zone);
>  unsigned long try_to_free_pages(struct zonelist *zonelist, int order,
> diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
> index f04a248d8adaf..490f400498f14 100644
> --- a/mm/memory_hotplug.c
> +++ b/mm/memory_hotplug.c
> @@ -1184,14 +1184,11 @@ int online_pages(unsigned long pfn, unsigned long nr_pages,
>  	online_pages_range(pfn, nr_pages);
>  	adjust_present_page_count(pfn_to_page(pfn), group, nr_pages);
>  
> -	if (node_arg.nid >= 0)
> -		node_set_state(nid, N_MEMORY);
>  	/*
> -	 * Check whether we are adding normal memory to the node for the first
> -	 * time.
> +	 * Publish this node's memory states, including any newly-normal zone.
> +	 * Hotplug never adds highmem.
>  	 */
> -	if (!node_state(nid, N_NORMAL_MEMORY) && zone_idx(zone) <= ZONE_NORMAL)
> -		node_set_state(nid, N_NORMAL_MEMORY);
> +	node_set_memory_state(nid, false, zone_idx(zone) <= ZONE_NORMAL);
> 

Um, so I am not sure how much cache pressure this will add, I assume it's small ?

Just want to point out that the old code only wrote these bits for a node's first
memory. THis now does up to 3 set_bit() calls on node_states[] for every onlined block.
The result is the same, but node_states[] is __read_mostly. A test-before-set in the helper
would keep the old behavior, or if you would like to keep it, please address in commit message.

Best regards,
Richard Cheng.


>  	if (need_zonelists_rebuild)
>  		build_all_zonelists(NULL);
> @@ -2146,7 +2143,7 @@ int offline_pages(unsigned long start_pfn, unsigned long nr_pages,
>  	 * list. Otherwise this node would still appear in the fallback lists.
>  	 */
>  	if (node_arg.nid >= 0)
> -		node_clear_state(node, N_MEMORY);
> +		node_clear_memory_state(node);
>  	if (!populated_zone(zone)) {
>  		zone_pcp_reset(zone);
>  		build_all_zonelists(NULL);
> diff --git a/mm/mm_init.c b/mm/mm_init.c
> index a9d848c92678b..b4c4dba93652d 100644
> --- a/mm/mm_init.c
> +++ b/mm/mm_init.c
> @@ -1763,21 +1763,21 @@ static void __init free_area_init_node(int nid)
>  	lru_gen_init_pgdat(pgdat);
>  }
>  
> -/* Any regular or high memory on that node? */
> +/* Publish the memory states of a node that has present pages. */
>  static void __init check_for_memory(pg_data_t *pgdat)
>  {
>  	enum zone_type zone_type;
> +	bool high = false, normal = false;
>  
>  	for (zone_type = 0; zone_type <= ZONE_MOVABLE - 1; zone_type++) {
>  		struct zone *zone = &pgdat->node_zones[zone_type];
>  		if (populated_zone(zone)) {
> -			if (IS_ENABLED(CONFIG_HIGHMEM))
> -				node_set_state(pgdat->node_id, N_HIGH_MEMORY);
> -			if (zone_type <= ZONE_NORMAL)
> -				node_set_state(pgdat->node_id, N_NORMAL_MEMORY);
> +			high = IS_ENABLED(CONFIG_HIGHMEM);
> +			normal = zone_type <= ZONE_NORMAL;
>  			break;
>  		}
>  	}
> +	node_set_memory_state(pgdat->node_id, high, normal);
>  }
>  
>  #if MAX_NUMNODES > 1
> @@ -1924,10 +1924,8 @@ static void __init free_area_init(void)
>  		 *memory-less node. The pgdat will get fully initialized by
>  		 *hotadd_init_pgdat() when memory is hotplugged into this node.
>  		 */
> -		if (pgdat->node_present_pages) {
> -			node_set_state(nid, N_MEMORY);
> +		if (pgdat->node_present_pages)
>  			check_for_memory(pgdat);
> -		}
>  	}
>  
>  	calc_nr_kernel_pages();
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index 8532af052d74b..834d199ff8429 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -208,6 +208,21 @@ nodemask_t node_states[NR_NODE_STATES] __read_mostly = {
>  };
>  EXPORT_SYMBOL(node_states);
>  
> +void __meminit node_set_memory_state(int nid, bool high, bool normal)
> +{
> +	node_set_state(nid, N_MEMORY);
> +	if (high)
> +		node_set_state(nid, N_HIGH_MEMORY);
> +	if (normal)
> +		node_set_state(nid, N_NORMAL_MEMORY);
> +}
> +
> +void __meminit node_clear_memory_state(int nid)
> +{
> +	node_clear_state(nid, N_NORMAL_MEMORY);
> +	node_clear_state(nid, N_MEMORY);
> +}
> +
>  gfp_t gfp_allowed_mask __read_mostly = GFP_BOOT_MASK;
>  
>  #ifdef CONFIG_HUGETLB_PAGE_SIZE_VARIABLE
> -- 
> 2.53.1-Meta
> 
> 

