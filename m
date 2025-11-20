Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AF284CF64B3
	for <linux-mm@archiver.kernel.org>; Thu, 20 Nov 2025 04:45:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 14A476B0011; Wed, 19 Nov 2025 23:45:59 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0FB336B0026; Wed, 19 Nov 2025 23:45:59 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EDD6C6B0027; Wed, 19 Nov 2025 23:45:58 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id DA93E6B0011
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 23:45:58 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 41CD5140745
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 04:45:55 +0000 (UTC)
X-FDA: 84129747870.01.E2A03B4
Received: from BL0PR03CU003.outbound.protection.outlook.com (mail-eastusazon11012031.outbound.protection.outlook.com [52.101.53.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id 6D5B0140009
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 04:45:52 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=ofZZndB7;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf23.hostedemail.com: domain of balbirs@nvidia.com designates 52.101.53.31 as permitted sender) smtp.mailfrom=balbirs@nvidia.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1763613952; a=rsa-sha256;
	cv=pass;
	b=436cWXqY6HIlTdsNJjnOgDthRlE2mp7TRJ/l6A5exBCHh656ua7RR32UDN7VLPdk6tMNIW
	1KB5nN3tJ09UQB/NZotkK/CEoiCloAfwDlAL5PwwRwxmRghnlUoqD3c6psnnO5oBGPh1rP
	epfbIs+QxLt9SvDzY0VKWCs40OIfEqU=
ARC-Authentication-Results: i=2;
	imf23.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=ofZZndB7;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf23.hostedemail.com: domain of balbirs@nvidia.com designates 52.101.53.31 as permitted sender) smtp.mailfrom=balbirs@nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763613952;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gFlRbVq2vR/HsZzD3ziBFN6uNFHXVZnc53SqYWgqVtE=;
	b=Mu/3WC+lvTxIBygSS9nRlhzXcIiusUrLE0LLXzXSc8Od6arjgGo21niCIoqpIHO7Z6C4EG
	DZ1wj/e3daTTXXxDIm7U36SqGK+oZTUwirzrwY7MYOR9qXFcbpjnc1PYJaislLm/dVZf2m
	3MUspH71QS13WXefeTJf6bnGcVv5hCI=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Fc5VSdp1g6PexBNyGtoV37USZ0MvqLkBsNqZFgQIhvay+nVkZmFlZCG90QcMZm2bor2utYfuH1OaPUGLxAQDoH0tdUrE3WoeLodrmTDETfRwMycDiJikB/skDAyNS4Gv8u8nPwSVzSWzQon81K3/E1i6vG/Hj1+Xmsi9HfDZYcSAZbEqB4qibIsKsmV0w91C3kZnO6tYVD6nr/zjFzGNAyVStoj6AJqP9oK/c9Q86YDJSEf/g92kUQT9eQmgLvJYogdObnte0ulq8xwnDXW3qt4aonA6GcuNVrSEIG0a+lZOG5+PI8c/n2ivjhpxDJmyySMLDbiSU7NgPSPx9gQEMA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gFlRbVq2vR/HsZzD3ziBFN6uNFHXVZnc53SqYWgqVtE=;
 b=GXXs3keXmJTIx2hk9JNdVarXkkOQkYz9LQFW5Jp4iWj1+TJUzYsdOaYzxxfgQJ8F9cpvV/V2p/RxuvscfAN/T0yIfxA66NZJVxSzNTYc4+HBrK6Gwc97r98BKhcy75Mdax1EueE0307hPsAifSTcd6/MJWxoKZ+Q0gpNersYWWZzwGWuMrpdOdUdXjNpDh2I6AQGSKpanU62zFd41XoncJjkr2xhHNsJFv0Clb7TRybrDzSVN/UWEMngwhzXsIiEPe+adDyqmzYjpnt8gKa2pFUEgUZoWr/50GbsSoFkNAG2dx3Qygw2EDBxxt6/eXZx2FMLajGviQgiV1XnHyluYg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gFlRbVq2vR/HsZzD3ziBFN6uNFHXVZnc53SqYWgqVtE=;
 b=ofZZndB7zGD5XU2x6kRfqntW9t0Ktv1Wz3CcQy6MTHPNycH1Qg8hI1+uRN6eOMEgz0k6R1n04ikwMPdP3EDqpRJ74hND3JY3M7iXRrDkDQec3i85D0ZbhJyuwnUjFqtCYfULX+yqZ757YUY5wQ2Wi8G5EnN67q0JiAKcLf2MSPUz9O+G8sUSRocyEx6hng8s0AzouXO06oiHB3hhN3BYEFXqZ6+YpmCQsqz9nSE5TwPayeGpqm7Buqqqk9YTcDci5s39wWJtUsz/xte+FknPMK5Xf+KtQKE728nISaAIcrpoy4+1AHBgJDdugU3s7DmJot9LgX/HeXnVIxJBH+BENA==
Received: from SA1PR12MB7272.namprd12.prod.outlook.com (2603:10b6:806:2b6::7)
 by DM4PR12MB6640.namprd12.prod.outlook.com (2603:10b6:8:8f::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9320.17; Thu, 20 Nov
 2025 04:45:46 +0000
Received: from SA1PR12MB7272.namprd12.prod.outlook.com
 ([fe80::ea7d:e30d:fd74:c9e2]) by SA1PR12MB7272.namprd12.prod.outlook.com
 ([fe80::ea7d:e30d:fd74:c9e2%4]) with mapi id 15.20.9343.009; Thu, 20 Nov 2025
 04:45:46 +0000
Message-ID: <b7af446a-eb74-483f-8a88-d48266278f05@nvidia.com>
Date: Thu, 20 Nov 2025 15:45:39 +1100
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 3/3] mm/memory-failure: handle min_order_for_split()
 error code properly
To: Zi Yan <ziy@nvidia.com>, David Hildenbrand <david@kernel.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Miaohe Lin <linmiaohe@huawei.com>, Naoya Horiguchi
 <nao.horiguchi@gmail.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20251120035953.1115736-1-ziy@nvidia.com>
 <20251120035953.1115736-4-ziy@nvidia.com>
Content-Language: en-US
From: Balbir Singh <balbirs@nvidia.com>
In-Reply-To: <20251120035953.1115736-4-ziy@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BY3PR05CA0003.namprd05.prod.outlook.com
 (2603:10b6:a03:254::8) To SA1PR12MB7272.namprd12.prod.outlook.com
 (2603:10b6:806:2b6::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR12MB7272:EE_|DM4PR12MB6640:EE_
X-MS-Office365-Filtering-Correlation-Id: 44446377-010c-44e4-6888-08de27efab6a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|10070799003|1800799024|366016|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?Q1d4Z1NaTWZpbXFwdVpnNzVJMlMzMkNNU1RiWjNlNDhRajhXSCt6UEQzcWtT?=
 =?utf-8?B?eERMd0xlSnZFK09nUkw1Y1BRcXRBdXhRVzFCbDFzOEVBUTM2czJCM1RmbStR?=
 =?utf-8?B?ODJVVWlJMWRHK3lYM2FqdHNRTDRsVlpJSWFFd3I0Q1Vic080U1liY2pMUFVn?=
 =?utf-8?B?TFowU0xmQkI1ZklkYjd0NGF6L2pjYTkyQjNpcjFCcER6Y0ttOGJiaCtzN05R?=
 =?utf-8?B?aW5Pa0grakorTFJ3eWswTThjd09GdUhFYkJmUXF0NUtJSGNKS2lDQnl4YXAy?=
 =?utf-8?B?SzE4OGMrcWQyY3dia0VScFRMTVVmVHRjOWNKbTJGbmxxSmUrZkdWNjlmZ3Rp?=
 =?utf-8?B?Ti9Hd0ZNWnowaUVUZ1FoclJjZVkrenViTGV5Z05NeTF5aGNHWW4zMEdLcHlw?=
 =?utf-8?B?ZWlxdTVTR2JCUXlROVoyYUlNaTZ4SGlXOHJta05iNy91cGdhSG9XOUx4N3Ax?=
 =?utf-8?B?K1N2TjRUeVdtRFNYc0R5YXNlTFJjbnZrdmdKRDVEZnljNFhBd3VGSEdOWFdq?=
 =?utf-8?B?N0dQYXFEZXJTOW0zVStCbVB6SkN5R2wrZXBDd09uOVhPVy8xd1lxUks0UUND?=
 =?utf-8?B?ZUgwdzY1UXVuZXV0U0tCVE8yYTJ4elltdFRUNGR5NVRpNHRtdG55T0xOWWs0?=
 =?utf-8?B?RVNuSlNPWmhsR2lqWlNJRjdyc3dHVXREWFpNTmRVai80V2RnaW5BdWFBTjhZ?=
 =?utf-8?B?M1RkMEdRQWJ5eTBsZGVmaFowSnZnejJBenZBdEUycy9NU053WW5QT05oQWdE?=
 =?utf-8?B?UHgrelpSUnArOFVXamJJWGROdjJudWNpVmZ1eDAyWmJEdHVRWEluanJkYTV3?=
 =?utf-8?B?d0dPQ0c3aXMzSEhQTDZMZTNWaGhHbWpGVEdsQWY0OEg2T0FVQmgycWlnMjJt?=
 =?utf-8?B?dENiVTgwNjFxQ1V6YkRkS2hva2VhTTA2L21xWXlhY3hKQm9RdEhiemVIMTZB?=
 =?utf-8?B?aGg2WkVXd2dwVnRLRDdRenp3RDhINzRVZHNXd1lyR0lsdU5VYUFEc0k2cmhY?=
 =?utf-8?B?eTMvZDU2VkNBemFGeTk5YWZ1V0RZSFRDTzRwQ0V0aExlUEZIZ01iQUZVY0xS?=
 =?utf-8?B?QURpMXZyWHBqUmxUeXdQQzVnQnE0bUhIMTdNbU9oaTY1Snp6dTJmRUIxMjFx?=
 =?utf-8?B?bUM4OURQVkgvVC96MnNRejNITXRhbG9qd2xXbjl3bUxBSUE4STJFM1Nwb0Ji?=
 =?utf-8?B?YVFyZFVsQjZreHBEWjYxM3c0TDBIREZEekFvbTFIVHY0YjQ4bHZKTXZ2eXRq?=
 =?utf-8?B?S1YxYURObHMzeUNEODlCalI4Y2tJVFRVWThEUW53eFllUm9YdjlqcjJaQUd3?=
 =?utf-8?B?R0pLYzQzR0NqRjVvN3ROSStZY1BWYUorWjNjaEExRHBPVkJrZmVpWEc5SzF4?=
 =?utf-8?B?UWluOFJXTzl1V3FYbXFGdFpRbnB2SVUwd010ZW15QWJmQWpaVVlIMkhvV2ZT?=
 =?utf-8?B?MDZqcWxtM00xby9pMFNRSmN0TUtadktJS0didWFza21TU3kxYVppZ2MreGVi?=
 =?utf-8?B?ZzV3aDRYZHdYbE9aZVdybDQvcnJKWDNtOHJENUlybC83SkEyWHlGRk0wY1kw?=
 =?utf-8?B?UGN2KzNVNkdnRnBkcURwRjMycnRjTzZZajR2b0tGVmJyR21heUgzYVdhYTZL?=
 =?utf-8?B?QjF3VzFuTFpjSVRjeGVvb3hCY3E5N1h2ekVqK3RFS3hXZmtib2lKUDVYZlhs?=
 =?utf-8?B?MXlyd3dJcnQxVUxXUnMrVGZGd3dXVzIydndGTzRINHp2MVdldFRGcDd1OC9m?=
 =?utf-8?B?dnNWVXNQUURzcXp4Uk95dUdlNy9wSGVhR0FZRGdVN0hvbUpvc3k1QXRRM1Iv?=
 =?utf-8?B?NG1Ibytob2ZmSVZkY3JxaERLbVB0c1hJbmpMTXA5aXNWUGllVmwzdWlmTFMr?=
 =?utf-8?B?MU1Ob3M5NEE0ejg5Tm53bUVhcENVZitxL2E2MElNREpwdkNoY3QvWDBuQUhI?=
 =?utf-8?Q?sGU4nevy8qlTfIMhhQ1afZ3ppvE4AqjB?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR12MB7272.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(10070799003)(1800799024)(366016)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?dWZKQVZpcGhUd2cvS0hIeFpUUkttSTBjVjh4aGlxei9oUm42TE1VcHgxZlFq?=
 =?utf-8?B?d3RCVVBYTTQzSWFzUEYyanRuVm5PZHpOQkpTMGZRZFZkdFZJVHlJajZqSVUx?=
 =?utf-8?B?YzFnaGE1OHphL1dxZmlreU0vZFVCaFNYRzFyb0VxZGcvbGtSWXF3Yk51MUpZ?=
 =?utf-8?B?c0JEM1NEdUZGRk1XTzRNZkV2QWZBQU9FNnlqOHc5ZTJuV1ZnS2RsTmlIV29a?=
 =?utf-8?B?eGlBVDhsUjNDSlhldms0OHI0ZlcrNUR4dkZvdkhtYXVtZUtpQzVhV3hlMWVU?=
 =?utf-8?B?aXBlMDdDQXNFS0NaMU1VN1dRVjBnVXdHK1lNUCs0cFhMQXpPeFA4R253RTFK?=
 =?utf-8?B?dTYxR2lqNkNWanIwSFloUzE1YzVOUTBCaUxJYTYzYlFEcVRFekRvZjNsZkRV?=
 =?utf-8?B?VnlEQkVWc3pmK2JaT2ZHUUhXVDlLWXF6THdNYk5IUGRHZm1IcEQzVGs1Nldm?=
 =?utf-8?B?L3dwM3ZlNzV1L1FvMzJ5UkNrQkhDTXZ1NTlFOUwyVlgyNzlTd1c3WkNoemJ4?=
 =?utf-8?B?VlFiRlQ2UkpGa3drSGsxSkQ0UXB0NFoyOFkrN0g1VEJGZ2xEMEpJYkdQa00v?=
 =?utf-8?B?RmhWQnBoNktvc214bWEwQy9zeVY2WlZJbC93a2hlYkVYMVFIU04xckMxQUgw?=
 =?utf-8?B?aFhGYjRraXJpSG9PZnFKclMrSDVTVzU4T24xOVp0YThFZzZkSnZLZlBaY3VN?=
 =?utf-8?B?b3JsYjgwdHNIWGpmYlp6YjBoSWRzaldiWHh2VENaRnkzNG1DVFNsNGZPeTBI?=
 =?utf-8?B?NVloaXlOZitZTnJodlRoTm14aTFlSUJFNEJLTk9jK3J6UUE0RUp1R0JVWGVF?=
 =?utf-8?B?UmxUMVFjcUxmdWNJSldZSEpXMWI4Z21xT1dkRGtTKzNKdU5EaGlTblVuVWUw?=
 =?utf-8?B?M3Z0QXZVM2tBcWJMTGRZK2xNTlppcGxTa2FJV0lueGNVK2FuVGlvNnRNdFND?=
 =?utf-8?B?MnN4TUtzeXZoTms4bzloYjVVOVcwRDFIK2RXc01kaE9GaTF2UFF4TlptTTg2?=
 =?utf-8?B?eVVJWElxZVBhREFrWlp4ZytZUUY1N3JQbTVySjB3VFh6aGdzK0lkdXhhMWpG?=
 =?utf-8?B?R2pNQVJBOGxKRFVzQkFXU1hyZDhKdjJvOGJMY0xpNU12MHNwdWk5UTZnK3hu?=
 =?utf-8?B?eG1idFFSOXNjZFM0d0RmRWxvaEU0c1pEZGF3SHhnNDlZbFRkYVpvNGtVRVgz?=
 =?utf-8?B?aWxWZUxITmtYMmJPSFZLOENKRFV6M3pMcHk0ak1MYTBaSDNYT05NeS8xQTVz?=
 =?utf-8?B?YlRMRWw1SXRDbWo2a3lITGREVzQ1NmUwOVRHMVRxMUdqUGdjMlZOWWw3ZVlD?=
 =?utf-8?B?Y2d1MUVBRmExV2oxZ0cvRndqcDNqTkRDY2t3TDNwbkJFWEU5eXlOaEdUOEto?=
 =?utf-8?B?RlhzSUdaK0RuWVNKWE9SSzBCL01OK1ZiZE1WajVDOEVzZXR1d2pvUWNENlRB?=
 =?utf-8?B?Q0VieWNkVGNIR2E1MC84eGNraDJqUWE2Yi9zOUhVaDJ1TStpdUl2YWdHcVcw?=
 =?utf-8?B?V3hweDNLZVBmdEwrdzNGUUFFYTIyM1RHaWZXS1Nzc2hIK2dRNFVQeW9oV1hV?=
 =?utf-8?B?T3dMTXhVeXNTS2dKVS90NGh2QTh1aEV5cUwwK3FHN2huTW45bEMzTmhxYnJs?=
 =?utf-8?B?M2NnUStleVJGeUlJdzQ5UjNzZFM0L1d1MEJuSGtzK2FvVHFCV0xTemZFbklJ?=
 =?utf-8?B?c0hRbkRReTJ0UXpmbUFGYWRSMUpRdnU3RWxSSnNnWUd4NVE4S3JzUDlVZ0dI?=
 =?utf-8?B?VnlSTktHdE96THZVVEVrUks0SGExSXhhY1B3RUxrTTgwaVZ0WUZGb3UrM0pa?=
 =?utf-8?B?SzIxZGM3QktVQzNmU2FpNk5lY2kwZk5DaHRyTDdPWHdJZE0vVmZ6UklKWEJk?=
 =?utf-8?B?dWxyRXdHUFFCd2FzQWJ5WVh0cVVxRWRSRExvRktnajdFUlBFKzBXa1pjTDk3?=
 =?utf-8?B?N1A0QWdWVTNJTWxyV09JVlpXMERtVnViMXJmcFQyb2RIRmJ5VXIyYlJXekZD?=
 =?utf-8?B?cVVTY29icXY0bW1kU1dNZUFwRlZyZlpRaldhNUpwNnRGQUwvbkVQcHN6RHYz?=
 =?utf-8?B?UHpyV3VVbmFSNGViN2xaTUpBVS8ydkYwTGZ1NFdxRWNFT3dMQThVVDFGYWUv?=
 =?utf-8?B?OEcrYVM5c0tDcXZUdzVqWHZWZTJBUHhIdXNJUHVsekk0azVMazZJalJNbllN?=
 =?utf-8?Q?Fw3eSYdRyBQu+3S3/kmsbgwLEv6eRKBOa8QP85pbNUiq?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 44446377-010c-44e4-6888-08de27efab6a
X-MS-Exchange-CrossTenant-AuthSource: SA1PR12MB7272.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Nov 2025 04:45:46.0987
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fIckfNTEzUgmpwctf+jmW+LAiyVHmIQxK3aIBQnZv2OZqnBvY4sAXPAE3FYhAT3wEDXdgFGU4aBpOAyNOanaJw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB6640
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 6D5B0140009
X-Stat-Signature: ru8nkeg4f971yswaasqh9xhcmwqbz38y
X-HE-Tag: 1763613952-278376
X-HE-Meta: U2FsdGVkX19p5co9m03JvoZA57le4xxIbeGezGyo4Lkhv4fXY/NXKQCXodDci6ROEid7bz84E0+B/PvYZkGzqHU+p2sG8wtjADiwJDRM12iynGkIUyV25GOF8fyDuEz2h5B+WZSjb1ru8btilvEXMwN9owoAT11tMOT+IvjyLrsXUNcM3zjMt7xlfjfEVOttCyyLHn6etNdQbAJyWI2sAF7ugO28zE/tS1j/Dhd0dPzUc3iKpzGVs3pWjTUFogh45z3H2/gAnvx2GgTlwTlv07GXjC+d/mNpirqraHTZe/2dwatfwT3K0+TPxD28xYI5+KtZ/R2KACfXZhC82QAh1bTpHimmzA8YspEGnNp12Y7RmvY33D7pFO9nkJiwqlJi0B+QULwT7B6myTXzDdaLCYU9Y5RrtyoYkY2Fzi/fn0nLhyduJJiSyag7L5m/AydSDwhiFLt1fE6cOddebbm3DwOQjBLVvHleb2Qzq24hp5xdYdzQNPtH0jTIhs725Mp/l6P1c61OIqn+LZUeOByJlihfQ9ec0JHpcRA4GLiXCe6g6Rqp2b6DZDXh3fczKeUjG8IcTbJg4XDNV5c8otRZmJvgoYxHcd2Yn6Ba/1cLeYVcoJIiUe2E1tcS5dmEW53bTi/rZspZM3+RmSfrXHxywvb8n5BPsbgvV41D0qIxuggykhjhWRteM0pb1ML675dybEZExQlT8t2R3aC5imxJGZdU384CMPnvndxViT5O1QmuKitfwWoDTxmbDcbVqoEBZ2CtTa8V08Tlc+VIZs0zedBh/8+dYKiIh4RcAvquKOQj+9NqRVxNoqfIor7mSsoeX5KvOb9PtpPd38FRGnAudTjmG5TusFTfGBKCVw/TArUBisX8LIiWVVBsiFvK2M8YsjgGqS03nmQychBAgqFBl7hfHKCnWLpX5E/mk9D8mNMscv8nUsPn4X03LKDsbeouH4eqIk10FoCvTtrP2Em
 GHIlTDMA
 ztjT26avEzKIFjWl79NEGSf79YzVK92nryKFRegweYBb7t7eLHi9KRj4Ql8lcA3k+zDbvHuvW/WYom/EdptJDynBHk3iZJJgJ6D183TjWhBJca9tpner2LF3XM7XXfNEfBoWvzjh/O0zjlpJmDg49yDxXTiIjsNQt8wPRs+NcwCy0CE/tEgFx1tDTxfKijJu4s0nuDIGMXHZ5GHJFx3yRG0Om1zOMg7revlJNsnNdfCt/O8UtoCkFVEuBw0Bpr3gH7wGScQMZSzXZifoAZlyfJHIDZ93Ja4H/oerZpwkR6gEv2Of458Xwzyh2j/ljsR2/KlpkSnBlzULvLemhMoUZcIFLD/pCccmd3ZVcRSuDvia8qBuJRuHlpd6KlZvkEASI7eGWf/jxXJQ7pkHZvnLkoxhIhDu/Jy/RDUAsPgTREwqGxAPCb46AKPjLKZ8Mr6as/u4cUT6mBY60bowfT2YmFbEy99HlOPMP/FuGlyhqIXyzlFnNucqncOlIWsBFw2hIzVw4xkUAXSMBYtrVS0b3TO60+Icx9tndLQhHKe0ulDsb52U8Gd7RHqP5jw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 11/20/25 14:59, Zi Yan wrote:
> min_order_for_split() returns -EBUSY when the folio is truncated and cannot
> be split. In commit 77008e1b2ef7 ("mm/huge_memory: do not change
> split_huge_page*() target order silently"), memory_failure() does not
> handle it and pass -EBUSY to try_to_split_thp_page() directly.
> try_to_split_thp_page() returns -EINVAL since -EBUSY becomes 0xfffffff0 as
> new_order is unsigned int in __folio_split() and this large new_order is
> rejected as an invalid input. The code does not cause a bug.
> soft_offline_in_use_page() also uses min_order_for_split() but it always
> passes 0 as new_order for split.
> 
> Handle it properly by checking min_order_for_split() return value and not
> calling try_to_split_thp_page() if the value is negative. Add a comment
> in soft_offline_in_use_page() to clarify the possible negative new_order
> value.
> 
> Signed-off-by: Zi Yan <ziy@nvidia.com>
> ---
>  mm/memory-failure.c | 8 ++++++--
>  1 file changed, 6 insertions(+), 2 deletions(-)
> 
> diff --git a/mm/memory-failure.c b/mm/memory-failure.c
> index 7f908ad795ad..86582f030159 100644
> --- a/mm/memory-failure.c
> +++ b/mm/memory-failure.c
> @@ -2437,8 +2437,11 @@ int memory_failure(unsigned long pfn, int flags)
>  		 * or unhandlable page.  The refcount is bumped iff the
>  		 * page is a valid handlable page.
>  		 */
> -		folio_set_has_hwpoisoned(folio);
> -		err = try_to_split_thp_page(p, new_order, /* release= */ false);
> +		if (new_order >= 0) {
> +			folio_set_has_hwpoisoned(folio);

if new_order < 0, do we skip setting hwpoisioned bit on the folio?

> +			err = try_to_split_thp_page(p, new_order, /* release= */ false);
> +		} else
> +			err = new_order;
>  		/*
>  		 * If splitting a folio to order-0 fails, kill the process.
>  		 * Split the folio regardless to minimize unusable pages.
> @@ -2779,6 +2782,7 @@ static int soft_offline_in_use_page(struct page *page)
>  		/*
>  		 * If new_order (target split order) is not 0, do not split the
>  		 * folio at all to retain the still accessible large folio.
> +		 * new_order can be -EBUSY, meaning the folio cannot be split.
>  		 * NOTE: if minimizing the number of soft offline pages is
>  		 * preferred, split it to non-zero new_order like it is done in
>  		 * memory_failure().

Balbir

