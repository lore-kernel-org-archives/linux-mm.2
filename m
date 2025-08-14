Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CA091CA0EE4
	for <linux-mm@archiver.kernel.org>; Thu, 14 Aug 2025 15:53:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 510389001A0; Thu, 14 Aug 2025 11:53:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4C108900172; Thu, 14 Aug 2025 11:53:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 312F99001A0; Thu, 14 Aug 2025 11:53:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 19FE2900172
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 11:53:09 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id F12D0834B0
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 15:53:07 +0000 (UTC)
X-FDA: 83775806814.28.337E798
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2069.outbound.protection.outlook.com [40.107.223.69])
	by imf23.hostedemail.com (Postfix) with ESMTP id 2D2A414000A
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 15:53:04 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b="uqU/zdZ6";
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf23.hostedemail.com: domain of ziy@nvidia.com designates 40.107.223.69 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755186785;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=coye6i8oHaHQ2bdF3UW1jPG1mc3iee9wOtEN1DTXaw0=;
	b=pWjxcSpWd6LWAn/dag3He/RezSWSNaamgdlkqzAMr8dMAs9IRcDJtXlzsc3Lke2kdHabvj
	GCHXT547mrJH/Qx0f6mjTMBUC7K0PsWq2huUr5eLOgOGecm0p00nCQe9LxM3iPPMZpaFac
	nYCnWsUvqRX6dMeKdmPlDBv2/XtLQx0=
ARC-Authentication-Results: i=2;
	imf23.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b="uqU/zdZ6";
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf23.hostedemail.com: domain of ziy@nvidia.com designates 40.107.223.69 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1755186785; a=rsa-sha256;
	cv=pass;
	b=1ifuMunW0AQP4wjP7Q1JHjVzQQ+86EkykGtqaDWm9PALMtN4ZiW2H0rUZgUn7+3ZcjuhAY
	0A1lTLtvNeLb3N4vcpzn4UFR9Bv8YQfeAJpuKG1cyvFSjRUk3XOrJZIBrEkx/6WKQmWRJi
	JgrfR3nQht/MT5PiLlzb6o3mIQjghbE=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=U3aX6738YKDobH64on1HRNvVDKbCxYPbQdOYJaM82NMsOkpps+2JIcE4bSrAGHE3lnuXUgwmSQenOEayIGZbCOCCfeB6yCoLm86xdVbnV12RqGYeV807ynstd/4fl3cVARAzbdsOB//LLwWgNVe8hq9abrcUS1GVkjk0G2QUXsocf08HDS5JzjiamOp4CgczVJ3DGXSbNgFPrnwWAaXKP7MMR9gYLzh7sUbMI31CO1d5lrWKaKAJbJ8fdFDYuLZfDHkJbP72KDowRS7QAJg3QWlEySMfZm7aNPAhWtZ58qXNB1KeqnKjXgClyly12TOCsDofefQ37zWllJka+qKqEw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=coye6i8oHaHQ2bdF3UW1jPG1mc3iee9wOtEN1DTXaw0=;
 b=FqaEBdh9WZiwiTaFmMUx2nhzWWinNajrFwaZ73c3Mb0mrEDhVQhhlT8mtayp9QfapN6JB1QYbSR7WT7bYAJa/Bd+zZ6Gpi8mDwD4r78jKUrPAyAQqZYzcwxSP0SPMDXJO+jLg/RI1e8LFSvGI4oRAb3yZwf2V+FpwxH2w03WgX5LX94rhM4u7F3SNmQUz9kPhV7rBP2SmR385pYH7U1TKcVE8JMoP2hn6tMotgeNVr0t+++FLsP/kK6zJG0Wy3Jyy4g1vUsYkI3ESMXlTXCzXKxUKtqfggcEuISjBhvfPzFuYsErHmqjfP/S6sx1IluRok3ukcmHSCI1HVOIIjgwDA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=coye6i8oHaHQ2bdF3UW1jPG1mc3iee9wOtEN1DTXaw0=;
 b=uqU/zdZ6JQoHfayTmIuCivL21IUG6a7M5ybmplC2S1gzqjb3yN2Vxmjj4LHlKHzNfh5B1Tbvv80CsTVB+bi9wlWTmB6Djg2POpve1DWvKmAEJIROxo6LfikxUDU1Lv9fboa1eFxa3fnVDyN9mCHKQWmPDVxetQRIHJkIIB1SVv/2m5i/2q+t6Md0/g4mN+zM1KzD7HMorMIC7R3yAtACvqDHid1o1bJABMQXPXiYiLOAxGI3JgBj3xc4WK1XYJJvnJZaW2CMXixIT1IaiJT0duauY6JEvmw/WJBD5wCBxPedKhIgXoSoB/y3VYMlRupf98qf6fE9TA2nAcjFqIsQhA==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 LV8PR12MB9111.namprd12.prod.outlook.com (2603:10b6:408:189::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9031.17; Thu, 14 Aug
 2025 15:53:00 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a%6]) with mapi id 15.20.9031.014; Thu, 14 Aug 2025
 15:53:00 +0000
From: Zi Yan <ziy@nvidia.com>
To: Usama Arif <usamaarif642@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, david@redhat.com,
 linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, corbet@lwn.net,
 rppt@kernel.org, surenb@google.com, mhocko@suse.com, hannes@cmpxchg.org,
 baohua@kernel.org, shakeel.butt@linux.dev, riel@surriel.com,
 laoar.shao@gmail.com, dev.jain@arm.com, baolin.wang@linux.alibaba.com,
 npache@redhat.com, lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com,
 ryan.roberts@arm.com, vbabka@suse.cz, jannh@google.com,
 Arnd Bergmann <arnd@arndb.de>, sj@kernel.org, linux-kernel@vger.kernel.org,
 linux-doc@vger.kernel.org, kernel-team@meta.com
Subject: Re: [PATCH v4 5/7] selftest/mm: Extract sz2ord function into
 vm_util.h
Date: Thu, 14 Aug 2025 11:52:57 -0400
X-Mailer: MailMate (2.0r6272)
Message-ID: <D3D3F7A5-A7CD-4D93-AB76-2200569AF98E@nvidia.com>
In-Reply-To: <20250813135642.1986480-6-usamaarif642@gmail.com>
References: <20250813135642.1986480-1-usamaarif642@gmail.com>
 <20250813135642.1986480-6-usamaarif642@gmail.com>
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: MN2PR07CA0010.namprd07.prod.outlook.com
 (2603:10b6:208:1a0::20) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|LV8PR12MB9111:EE_
X-MS-Office365-Filtering-Correlation-Id: 00a9b36f-cfbf-4ab7-8061-08dddb4aa56e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|376014|7416014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?WiSM8WTHbMHCq76y4GA3q07LdsiJHBwm+lHRl760fCUixcJz1Otr11yrPeEw?=
 =?us-ascii?Q?3b5RGG5LT8cPZVZJ59B9LP7H7neIK0D/ly47G1P1iy4Hhb12h1wXLzFtkUrf?=
 =?us-ascii?Q?B4gFbsvNYyq6nRIvrYbSx77WnIJpWUY6vwMuDnk6pFxYClQdySw41ixaft5G?=
 =?us-ascii?Q?7ecaSbdkFK+8coEedO7gYcyCZnR4mubggfhYcvvj45n/6zy3ylidQP/uBhE3?=
 =?us-ascii?Q?3Z/JwjKnwveM6V2oJ5UN1NjN4YYhDs9xprdPDeKrDN0aRqazsnIBSwiWD/mC?=
 =?us-ascii?Q?sQ+oFmTXkGeEcj35Pm38Z2paYWLPUokKxuoiwkS5RejT517eNyRD+LcpU7CO?=
 =?us-ascii?Q?nqaMAVETsczf1DRvyeBMyycVSrjmtYQh6PVyYnOly9TAh60yKg+dupKTLwf2?=
 =?us-ascii?Q?eVRcM79oGawFIOBmndzwnNGuPVyaKfo7PeQKaM38VzAy0YitmrbnoFYhaI7l?=
 =?us-ascii?Q?5Tb2wBIFwUuHYn+MHvCPES+6XS1LobSqphgycGKy5b92ZtW6482k/siahlrm?=
 =?us-ascii?Q?o01rZd3MFpxAmWPwZ9pBRNlc/EZDQgYxwxAmbekqSIiZPqi1FFQRhdGaiS5p?=
 =?us-ascii?Q?mzChgNO16rq+RmQLsfzYaR2bnNmLGwl2i5aW2o1+drl5jG5PqeufD41dehF/?=
 =?us-ascii?Q?INHfWkhXIcQJvDf/wBzvv/HQ7brUcykZkZK3kbIt0BwmlfnfLM1pT5GCEf6H?=
 =?us-ascii?Q?eST8mDPwDXhQuSuffJ9R3ob9wupv0hHYfEN8ulxaO3M55rH1y2EYu1yRMVZr?=
 =?us-ascii?Q?VeZnO54PinXE8nMVAtzQlQ+GZbL0Qws2VQoikdWLiD15rwNq3ncEFSv7eao+?=
 =?us-ascii?Q?VrpouqNZJecQdpO4Sk+em/2+R5cMA08tg7Mt+8jbJ8/VU3DAqmPUPI/I0Bqn?=
 =?us-ascii?Q?s7PxzAL8gMRb1lwtMecLfDXbeLDcQC2dr9wuEc871AChzSPfE1+g++siMnho?=
 =?us-ascii?Q?xMiAf/mj5vT4VFxTmGk2bLyb3Y5bUMzenHu8gM8a3VM/VWWqn8cSVl/cK5Oy?=
 =?us-ascii?Q?F9vD6BQrcSsa5l9tbtBndK0179+rFpLQM+AIzlcNu1w0cMJHj2sU/zi66G3b?=
 =?us-ascii?Q?p76CAYYPmyrt0gje8Lcg7ijXrTmqXHpskk7Gw6PodePZBmZYgJ1FZW0JtHZk?=
 =?us-ascii?Q?OljogoBPyV+gy4MLw5zqmZkAuuvOLwPZYLqz0cRaO/kbWwsxhMGFPriCayg8?=
 =?us-ascii?Q?etaSjNqMyFHB0BMlD8a5soh66LxJ/eMR9PZzlPXPldJ+33A2zBETHiYu2sh9?=
 =?us-ascii?Q?+2rLZjWWu6XviclLDfvs+YjOv8dk1A/s+JuZa+XUA5b568mNykU3Nc5GbH0Y?=
 =?us-ascii?Q?aUO/+3MkDUSfFIJEmd6wq77xtovcCRUKzHucmxTyo7a+iOnDqfrPLJyvFeeN?=
 =?us-ascii?Q?p7HxErYLemN5uNIPZdc54RISuu9e/QEcQhBlegZRnYPzEcduRxkQHeVwQ/ze?=
 =?us-ascii?Q?i4hXg5Hd3uA=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?9d+p5/N7X4mZKgFDalwQRGEYBv5KiUdRqfJaRdXx2z0gUrHP9gwDKhAMYo9D?=
 =?us-ascii?Q?O6RL3I9HaS3Kd2CZoJmGjWBY79QjtFQScYwgdtLgNoSPzscbN8ocK5BpUj6a?=
 =?us-ascii?Q?naAe7QQWHUHZ8NixM2B+HDjZFuyvPwIEm3E/jcUkzfJN3a7MJZXL8o9nJchb?=
 =?us-ascii?Q?8Zl4eigj7Y4Hwdk+BE8YIz/M2z3uwTHapYSmu49k/mq/eDmS/mlpJJUEaOLu?=
 =?us-ascii?Q?YvEnJveuhFMRI8JtuZtOpVWzWvTOvWR7kn//Ds0T6LI0LJnZJgOAoo2Dj+mz?=
 =?us-ascii?Q?bN+vn66mT/2tginsN2GwdluVtCxxJfoaEBeCRTr2O47+ZnNLmjMt9tFQRNNT?=
 =?us-ascii?Q?lO8y9t44Vyez8NblVG0ecY3/RXRjp9g6tmivpO61RII0v1Dr7JeodocxLlGP?=
 =?us-ascii?Q?us8fTvC9lSidDliGR8LIWFjWqpBuNKwqqc2YoQyTWgdOG7G9JijDxR8ICbrt?=
 =?us-ascii?Q?0jLIhWZTm5YSbH4sVEg/lqX3NmOVFhDCM9gldoEbRBLSmwfXhDF7JbO8kJr+?=
 =?us-ascii?Q?8rZkdLZG+1OejSvTsIWDb/tHHRFX+S/xcLsniSE80rDY/6ashosEUYbASaR6?=
 =?us-ascii?Q?Jijm3Utf7ocxtRq7FDnbiFwzYXODTZEC9c3HwWN6L3PX+YSXuosfN8ZDS1Pv?=
 =?us-ascii?Q?H0hxFUAELb938z0Wu8Q+jF6hhZqh+ISVsutvLlsrnZ3bWXwuiDsxDOqb7ejK?=
 =?us-ascii?Q?lhw0+XiHr7XLx1ImpdNmDO8qQwytviDK5fneEGGB+x6WcHsO6/sSNBVHfA3c?=
 =?us-ascii?Q?lDBy1MvE2NOKHY/7bhakGzeblZKZYOqjixMjZm3+GXdeOuiKrhCp5XozkFTs?=
 =?us-ascii?Q?QRZbglC/mh1kwnyC90Jh2wjS/3P0NpEfKFasRb4j+oWptTIy+iASzeuXdMBl?=
 =?us-ascii?Q?bpiSBZhDQLPjhahZBy8gREBqFibv/5gmOHJR/84yk4BQDWl4dqHwCwWvttqO?=
 =?us-ascii?Q?iLTLUPu4evoMeO+B1CzNFmdoxb/XEf2hoNxTtJI2ptgRUSlaHqhflv3R7Y79?=
 =?us-ascii?Q?4SMdiF506KLeNtsuQ87McRIAmc4q9vPsPhUj369wArbI1sEdLCbhTaQH6Zdg?=
 =?us-ascii?Q?+PwtuECkVNFu/TPyBnsbeCmPqn/0bfbxCqM9icDLsrC0a/LETjxlf6RK+j+d?=
 =?us-ascii?Q?nbkWWWMdHEusdxSWTlGEJaddiC6QK7XUCfYYEsw7Vghnez623dfXhnIODPEf?=
 =?us-ascii?Q?Md8XGVlVwYriZTKnJGiicyF94FdOYh+yAeRYq/7aV3HHEt++Vbj9gGpIVYW0?=
 =?us-ascii?Q?Cy41wGHWruWfSeRwaH0+u1AdhuBIb5dDN9TE6e34YHszrqke7Egb2/2zowU4?=
 =?us-ascii?Q?Qm5IzZHGt/A4lezExkPGVZq6vz7Pf14XfFloXHcEG7vdI3fZRC0DxbmYwOl8?=
 =?us-ascii?Q?qUyCo7R35SGylKkmj28kTybfYLpFbvgrzJD+o7H9kUe4MKl+Py8XJy+OpRpW?=
 =?us-ascii?Q?gAAXra/j9ni6m24og48ARiBaQ6aetepufaWwtFgeoWcBz4Yj9KPC9lD0Umx3?=
 =?us-ascii?Q?GpfmzY48UE+2A8wIDAa88gwY2/7YpqW1LpL5jdRgHwO/fGFc4tMJv7D5iw/C?=
 =?us-ascii?Q?eFCHhhfKGSC/IoiBfxaCeLP9Rkm3JweRcGDs6noK?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 00a9b36f-cfbf-4ab7-8061-08dddb4aa56e
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Aug 2025 15:53:00.7484
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SJhXASYfmaRy2W3xgin3w9EU+9fjmGFk4+rG90cF4vRPU1AhdAVt//MQAWJ2+2OH
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV8PR12MB9111
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 2D2A414000A
X-Stat-Signature: uc8h77o6ce9kdmxzyexkh8e3k9wj9ijw
X-Rspam-User: 
X-HE-Tag: 1755186784-322319
X-HE-Meta: U2FsdGVkX18WjW9YUCcoMOUNek3mY15lJExLpVm1XgU/RVBTiGzfWRoYqHvblC6GEuQRpewgpk0FBPMQbZQkMcVuMlgBZr2KCJJ0Bpf/wrS9U71v4mkasZlLpCe6JbrX6IVgCMq+BZS7d7nEVJzdzPzCpihi/esP/r+j9Gp7pwksgHoA9asT4gEKdMCWytcNdex6ZGtYG5X2PbtUGDKFoE5jjK24Tmntzm/5glaDXeGgnii8YEai8Mj+iq6zByY3Dl6Rz6g+dTr343dxUzL1QHjT75Nthj24oQFNktQ4rJJJuoezX6r3iDZrwNaruGNesMLuWkx/UtBbmXo+cjjq0Em8gqQNdq4papCsMV+48+avFcKjaIJIEYUb+h/AEhDdrCbKK5hqGLtWwjHznLdgOdgL0/EauhxcBlKgleZGsG7HQt/HtlMWka+A7kIRpn7WbZZ2p0Wf4ealKz3Sq7i0lL8S/JtiDaPf0Zt8QyLuADes0oSLSWbg6dmQ5TyY1Fc9Z6PVCUAkvH+JaCLU5z+4UDiP7LFgHyPQwS2SUcpsDMSctq026oVRJIUqbslOSZSThBzAARp0TeQ5RRVtzyJiUcVG47K4TwfPfSFgIed6UWc+/5ydp7kbNjPTIdxzcMuUUI3v7Dtvh+sBemEc/DeeXvbhvx2rSdMBFXQRjGFQdhvNPsdnZMRTfJC2J2sIqQgi4XXY1ajhaPOUw3qQMra8xBAPKpaMzg8T+qWnDGRul7OWTa8VhwttIgK2yLKH1zKyoJOG1IOpi6dgoC66+tujAziGEoIXR1WVGkUdVVzPYFnV4s8NCLCPRXWp01KbggIWzHPvWWDWRhY8dezJ8NYuaw2glxERIycUf2eC7a67li5YzgR3i/1oum8mz97EfcXVjTyKP28k+x9f9S73Lvmfzq9BoHGl0VD81I1uJEaO+MW2lIT+xF7OkHCjSuF2I4Bys6I+pQAJx0CSh2+hLyM
 ZveG78xE
 XB3yHrl6SALr+7KXByJYJ2IrzxXTMOckQEEmr8xyX3G9c6WjKtRcz2mFr/qM9BCIR5AGTEcO2Tp5Xbx0e33VPIGgMLLMa1XRKnns22RFvd5B7rz6h4p37g+945EBNy7PGccdutXwWyiSCk3TdaD2IhzJK0hmtGXSu8UtNeC/hdUrltJcu78bmy091fI32UZDllHHYd6ohpd67khqnys3IEWpD4qclmuUKrvS4KddeBAwkejepy0jdT7iQiHrsElCjp0brQNfrRq/MXm8MYsLG/AeZWEcpd81fenyY7flNPIVH+XEk9ADvr7v7P9RhkLn+KRul1Lv8bIZVIf4658mqXoKtubfV/UEQm7Xuq2m1JXpVIzJQ7DyfqqiQeNQak5GGH/zvjRa1ADQJX2crfVOAbXonZnC2QpKs3ccE6FVE28SXBvcvpFr4PbWVp64+2eba1kFgGXnNJDz8dj0gmMBDIBnINLZ29+bWe2baV0AQrta4D1xFZP4y36Mz1k+1y8Sj9QqImTU92Mx4k8j56BlqZ85rAUA2r1GCg34/YW+XayTs9Jlwxx/jo549aVGxAo8wy5gljvL5naXTdAoa9OqAkoMC+4M2fCLqxkr5826A0Ju8+qr+6DdRwL+fW6jw7pkg9T3cKUfsgXCYjb0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 13 Aug 2025, at 9:55, Usama Arif wrote:

> The function already has 2 uses and will have a 3rd one
> in prctl selftests. The pagesize argument is added into
> the function, as it's not a global variable anymore.
> No functional change intended with this patch.
>
> Suggested-by: David Hildenbrand <david@redhat.com>
> Signed-off-by: Usama Arif <usamaarif642@gmail.com>
> ---
>  tools/testing/selftests/mm/cow.c            | 12 ++++--------
>  tools/testing/selftests/mm/uffd-wp-mremap.c |  9 ++-------
>  tools/testing/selftests/mm/vm_util.h        |  5 +++++
>  3 files changed, 11 insertions(+), 15 deletions(-)
>

<snip>

> diff --git a/tools/testing/selftests/mm/vm_util.h b/tools/testing/selft=
ests/mm/vm_util.h
> index 148b792cff0fc..e5cb72bf3a2ab 100644
> --- a/tools/testing/selftests/mm/vm_util.h
> +++ b/tools/testing/selftests/mm/vm_util.h
> @@ -135,6 +135,11 @@ static inline void log_test_result(int result)
>  	ksft_test_result_report(result, "%s\n", test_name);
>  }
>
> +static inline int sz2ord(size_t size, size_t pagesize)
> +{
> +	return __builtin_ctzll(size / pagesize);
> +}
> +

There is a psize() at the top of vm_util.h to get pagesize.
But I have no strong opinion on passing pagesize or not.

Anyway, Reviewed-by: Zi Yan <ziy@nvidia.com>

Best Regards,
Yan, Zi

