Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F40E4FAD3F1
	for <linux-mm@archiver.kernel.org>; Thu, 23 Apr 2026 02:52:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 69F3E6B008A; Wed, 22 Apr 2026 22:52:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 64FC06B008C; Wed, 22 Apr 2026 22:52:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 565A36B0092; Wed, 22 Apr 2026 22:52:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 481846B008A
	for <linux-mm@kvack.org>; Wed, 22 Apr 2026 22:52:59 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id D88BF4027B
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 02:52:58 +0000 (UTC)
X-FDA: 84688298436.30.CF6D6FB
Received: from BN8PR05CU002.outbound.protection.outlook.com (mail-eastus2azon11011067.outbound.protection.outlook.com [52.101.57.67])
	by imf24.hostedemail.com (Postfix) with ESMTP id 0919B180003
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 02:52:55 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=G8MPNdvA;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf24.hostedemail.com: domain of jhubbard@nvidia.com designates 52.101.57.67 as permitted sender) smtp.mailfrom=jhubbard@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776912776;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lxFhZjgjEMaIXFbcNqgfL2uD+bRQHVOfiqS8yhbV/kA=;
	b=sJEdKJ1wWegsQMUP6Go/2uYc87h8UzgBy0eqSwmS/P0qrvxJokqpfsSjqV6LR25L/Guv2q
	Mj/pkGwfR3p4pv+tFKPi7egEICHIpnRJ1WpUG0SLnUPpU5GTufKn1XQgqpXDyFsORP4/I1
	ViQArdbxnpUONl98VJvL/3K47WKc2Ac=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1776912776; a=rsa-sha256;
	cv=pass;
	b=5KUT0fPHcSIIyeaH9zVndMLgwMpOYNSCPtwrl2Xs1tsWv/dgIMFIuZiJCw8hPbqlhUw1nB
	ueWtYxy7AgQt2vZm6MgDglo4fk+P0Y8IVOrEOAYB1e49cqEHoiul/voIxuEWIBWEMpiDQk
	aM58j42eEe/6Y53+25K+ufXqdMGqErs=
ARC-Authentication-Results: i=2;
	imf24.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=G8MPNdvA;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf24.hostedemail.com: domain of jhubbard@nvidia.com designates 52.101.57.67 as permitted sender) smtp.mailfrom=jhubbard@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=MFzxBsqXUgC+48XSdkYcXYQ/kFE37bhA5+UWeayFjbzTPkdTOfqxHRH94/PynSBqWs5l502APk54xgwVzvIshG5do4MBPrkn0u9ChLgPDBco7L04OUPxxwbgxGRniIp/otaQzJXBeYM3bvKR6ngHS487kHKBm+KdbSfQy15P7FknDWeW+H+zZDD0GKJJB0MOGLATSVODwVZPZt9+YHkEF7WzpGWISlMqZhhY88PoKIJ1WXYbQVxXVYmCUpvQvYS/yy5p6mi+Cds1HJjbW3kK/0sWjnCem5GLCiVxRQdWhB3jphvsRPBv8HCsCxAlBVH/JZGMhHPO33l+thdK2etS3w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lxFhZjgjEMaIXFbcNqgfL2uD+bRQHVOfiqS8yhbV/kA=;
 b=eOzYktAyPsr4Bxwvwx0y04zcLV91MhgHmgae7sItLpz5TMVTzVqtTzjIUdIadWaPwrdTNFEzYCPar0rSLxyWBIDtlEvaA8mt1jiC4yZUzQl/VbY5g9IxO/MlzB+VoqNYazcSTPI6eOI1s2OI46k4nDHNJ8q34MZqDukwaYPZBHX3OxZ0+70MZt46zu7pqCNg9v2QfoZ051F8UsFH6IiI6WXld4klIbGodXsjURCmEaz4mVqF778N3nJdYIW1oHU68b+ggDPJj9Wq/aq+h71wu3y3ueXN3WXibW7EJ7X73wbERSyyaZy+eiB43Q8VBdh9pqvnvYh26CGqg2xLwpkvkQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lxFhZjgjEMaIXFbcNqgfL2uD+bRQHVOfiqS8yhbV/kA=;
 b=G8MPNdvAnfxFQm0oHRFnj1ni0wSWtpTUWez7dCspgOgFUZOHTqrI8+SukzINl27i5zoOnJpApME25f3xkwPL1EcuwtLSwqN9zxItH91kWcIuZ7d8ay5UmLuZoTQiNR67KiXyag6qjPG8wLzauL5H9ijGXv4iK9DEzFwYm8SysIfw8oA3tAbQukTob8NSb2+mq1W3cROIMTiwtaNDrARSbE4skgsLGEt1mLy9Xp3RpDl50p4zKCiCzqvpHMHMlGyYepZAQsXwynb9P7H5GyQrFiHMUeg+jUoe1zLH9duOyv5FEdmJ9k4cIIeTGZsq8+IarFKwHiApX78trGVDERsKeA==
Received: from DM3PR12MB9416.namprd12.prod.outlook.com (2603:10b6:0:4b::8) by
 DM4PR12MB6590.namprd12.prod.outlook.com (2603:10b6:8:8f::11) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9846.20; Thu, 23 Apr 2026 02:52:47 +0000
Received: from DM3PR12MB9416.namprd12.prod.outlook.com
 ([fe80::8cdd:504c:7d2a:59c8]) by DM3PR12MB9416.namprd12.prod.outlook.com
 ([fe80::8cdd:504c:7d2a:59c8%5]) with mapi id 15.20.9846.016; Thu, 23 Apr 2026
 02:52:47 +0000
Message-ID: <4903167e-0c6b-43f6-ab88-cb709a7179a4@nvidia.com>
Date: Wed, 22 Apr 2026 19:52:44 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 0/2] mm/migrate: wait for folio refcount during
 longterm pin migration
To: "Huang, Ying" <ying.huang@linux.alibaba.com>,
 "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R . Howlett"
 <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Zi Yan <ziy@nvidia.com>,
 Matthew Brost <matthew.brost@intel.com>,
 Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
 Byungchul Park <byungchul@sk.com>, Gregory Price <gourry@gourry.net>,
 Alistair Popple <apopple@nvidia.com>,
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>,
 Wei Xu <weixugc@google.com>, Chris Li <chrisl@kernel.org>,
 Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>,
 Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>,
 Barry Song <baohua@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
 linux-mm@kvack.org
References: <20260410032333.400406-1-jhubbard@nvidia.com>
 <87h5p4isbb.fsf@DESKTOP-5N7EMDA>
 <51168a90-d6ad-4429-8043-3dfdd81cb9a3@kernel.org>
 <878qafix71.fsf@DESKTOP-5N7EMDA>
Content-Language: en-US
From: John Hubbard <jhubbard@nvidia.com>
In-Reply-To: <878qafix71.fsf@DESKTOP-5N7EMDA>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR03CA0013.namprd03.prod.outlook.com
 (2603:10b6:a02:a8::26) To DM3PR12MB9416.namprd12.prod.outlook.com
 (2603:10b6:0:4b::8)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM3PR12MB9416:EE_|DM4PR12MB6590:EE_
X-MS-Office365-Filtering-Correlation-Id: 9b968cf3-b633-446b-6337-08dea0e3665b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|7416014|376014|1800799024|56012099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	QwVZFigOlNHe0nvIrm7I47i/hdJ2qgb7eXqUf/gAr2oArLo0kvASAmw2wU2zYMyW0KbLS1yPIktHH2dIHc4RTyDaDa1NGbIkZ2bTLqDgx9y9J70RVgq6WpUxe3R+yv9ay1Wx/TDihNwKILdf2MQ3sE36bVQCsfWhydMhQvrNhvF4wKJo/ckaT0YXiRKnTJNQCl7ZsmJgN4mkBtNSSOMLkciy+oBni2G7NDVlBAcnK4ulh8dKGqF6kfZV6FASzXs7FzhYBln8HYfGElMo13f6+geyife+jm/dr032BC+ZJhzuWcQUHReLqMIq5F/lwCKacGIpPMDCEh4aIp+CMhm+o4HLyAXvDpOmd4iIvkXKECF3peugkpE5G9SItlMWbZvFi89gmPse/GpupgOCjEcTOF7DnqcW3r74sipnkrh4UD+Dgtho4c9IJPPrPTrhm3+R0Hlbn6Cphp7OCQTtANYJAxIJaYhnm2+S4cJh1nJBEQ6jh4Mfyuyj/jqwjO7OHHAuNGkpu5uU1420XwP/aDA2Kbsi/lxY6Wgb3m6VWiCdg5yZPXEscwVMsEIwp4x7RHoM1kAdAizaLq+Crm8VHzE+6HUZIGXAHBDJ4F6hXnOw+LX4boJERPca9TPeQShj9sENlbYcSEmgRQEhe5+sPoZXjMx9eO1XiIO8i4+XVEnUtEnUhbFhTByN9O9d9+87AxboFl6go2qLwB5/zjS2ivgsXDNTvg2PvB4IXAauR5YhmcY=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM3PR12MB9416.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024)(56012099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?VERIeE5SMkxHakVQbzFYZVZWeWlqUm1jUjZCUU1WcjhNSjNqb1d4YjFoZDFR?=
 =?utf-8?B?Qit6R0o3Y2VzOHVRTzZFRVZiaG14TVZvUER1WmFBcVlObzM2OFNLR01GK2N5?=
 =?utf-8?B?ZXBOTHBKenp2ME5aRTVOaVppUjdDc01aZFRvUWxQQndSb3NhSUxDL0x3Vm92?=
 =?utf-8?B?YUhSdm5aSW5Wc0pibU83dW4xWWtOa0ZnNnU2cWFHMmxxbEdqUktHRUd6NmYv?=
 =?utf-8?B?c1hSS0l3eGFVQ1pEcUd0eFFReG1kS05wUU10UWpUSmhyeEpxd1FOT3NPejhh?=
 =?utf-8?B?WWtHRFFqbDJTNW5pUGNKOFVZMFRST0U3SUw4SEFCUW5UMWVMbHZvTVBKZUhK?=
 =?utf-8?B?UDk4OEVEbUc0Mk1LZjI3MHpCYW44NWt6aFNVWVNJVzRHTldIR1ZEcmV2Rkw0?=
 =?utf-8?B?S0VRajhRQWgrcUplMkxocTdwN0tzOCtHam9ISGdRQXE2Z1kyL2pwWGtZNll4?=
 =?utf-8?B?UURaZ25QNHV6RW0zQ3NFWnBCSHB1UFE5NUJ3RXRuaFk3L3ovZFZFTWo1dSty?=
 =?utf-8?B?YkxEdERiZkQ5MWNPK3IwaS9kZWJjRFpIZXhUOVRGcEZLZ1ZYSEg5RHVVRmVB?=
 =?utf-8?B?OER3dzF5REJYTmZDYmlxN3h3Q1RYcnJXNzFHWXh4NmtMK0NXOWRtODRkMHI1?=
 =?utf-8?B?WEVKOWpQY0hybnJEZXcxMWNmVkRjZEN0SzRmMm9HUkRzS1d3aWVXNExFRFUw?=
 =?utf-8?B?SXh6ZXZQcGFDcHEwaGtGVXF4YWM2MDArZTZLaWRhQm1CaWNuZ2pjVkUrb0xJ?=
 =?utf-8?B?VjFpeGlvdU5FOUVmdHlFVDJuLzFBM0RBUC9odVhhU1p6WWVmZnVYaHVvcEtW?=
 =?utf-8?B?OHZxNWZJc2Z1UFlHYnQyanpMUG1ZSjJ2Z2dFOUlxUG16MmxuaUtHTHBEMnhY?=
 =?utf-8?B?Y3ZFTXpHUzFmS2gzU3JtSUhkZzRkYUh3R29STy9KRXNvM2dCSjIzdSsxd0lp?=
 =?utf-8?B?QXpsQngxZjdUSnQzNUtDY1RpczcxWmxndVc1aGV2UnFvdm9DL05yazlaRlZJ?=
 =?utf-8?B?WGNjcWpUODlTQWFUdU93Qjl0M0pTdnVrUklIMHN4TmxFaHhJdGc3ZXE3cjJQ?=
 =?utf-8?B?T01mbldSYytEK2dWVFoxTGV6WW94ays2enJLL25wSlhVb2FadjcrS0RGQXI3?=
 =?utf-8?B?Sm5UWDJIYTZOZFYyNWZrN05pSkgxbnlkalRQdVREcXJBKzhOKy9kL0NOUUtV?=
 =?utf-8?B?WDJ0T0lkaUtjZHpZTzhoNExMYzFXajNHeHVTUHNncFFsRHhFcnhqUGRzSTVm?=
 =?utf-8?B?NWEyaVArWlk4eldTVmtqc3UrSEtqS2dtWGZmWTI1NWJoSWx5OEg4bzFnaXBE?=
 =?utf-8?B?V2VXUXFTWHpSZE4xQjhGWXRpbnBTRDUwU01wdEVHeTQ4Z1ZCaTdwOGpXT2pv?=
 =?utf-8?B?d0FNZUdNRnhvNEdETlIvVGxzeGJLMVpZRUxwK2l6NDZMYStsRlpsWWNsZlhB?=
 =?utf-8?B?bVArbnB4cE1oODFYK1dGUlFlRlZMNXdnSEhWRnNIWEoyUHYrMFJtcHB6N0gy?=
 =?utf-8?B?Wm9NUTdNODE2SmZ6SzZnMW1NSnYrbUxKakVzMFBzYUhLL0RybWR4aU5OUFpG?=
 =?utf-8?B?MFF3bFY0TjVLQ3lEUjlMVEI4clNZdzNxRGRXZHNZa3FtRWN2WGdkYk1UbG1j?=
 =?utf-8?B?aUl3Y0xCMVZ3M24zVUNGb0k1UVNqbVNCRmFTR0RSKzljeU9FYUluZzVXcDda?=
 =?utf-8?B?UEZrL21aR0l5RVFDYVJybE4vY1I4bXlOMGVOQ2dTZEVZUUdzQitQaEpWbk41?=
 =?utf-8?B?WG1zZnZMSVQ5bnJYcTROVkd4T2tLc0FRTHcrNVVMRlRWN2VicUxBYkYzUDFU?=
 =?utf-8?B?eDV4b0xHWlQ0Y05xdXlLZzcyTG5KbkJ3ZTVmSVg1LzJnckdhS2Ryczh2U1VG?=
 =?utf-8?B?c05pQ1IrNTFmVURpSGY4a1Qzdm51UEZiOXgyOVJKVGp3OEYwd2h5SSs0dWhI?=
 =?utf-8?B?SE9zQ2p2NjRLSmdxMlBLNzVIZHZ2WUFZWHhYcllCSEc4NnAzNGNEblQ4Qjkw?=
 =?utf-8?B?ZVozVmJZQlA1ZkQyczVKTjUrWWlpcHpleWZiaE9jQy90RVhaWnM1MFJFMUhj?=
 =?utf-8?B?eHoxN0UyaEdWLzU0TkJKeEdpejdveTUvRDVQcVlLdUpNSHJ6K2Y5WjY4UEI3?=
 =?utf-8?B?aU83akwxZlFmcEp6ZjBtdVJwUnpBY0lHSDY3dU9LeWhnTWxZNnRKM3dhNjg1?=
 =?utf-8?B?aHVudFkwY0NuWWxOcXljTkhNNnhVbU9sUmw2Z0dVMlQ3azFGcU5LZG5SUWow?=
 =?utf-8?B?OHpIdFdkWXBEalZMTVZGNnRBQVIzZ2NjN1puSkE0MVZ0YmwyYXNFSHNzZ1Zw?=
 =?utf-8?B?OVhJVUMwSDFUbmplT2pibHJXeDA5cXhnSnQxRkZtRllKZCtNK1VVQT09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9b968cf3-b633-446b-6337-08dea0e3665b
X-MS-Exchange-CrossTenant-AuthSource: DM3PR12MB9416.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Apr 2026 02:52:47.1418
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dXrcZQHfAfIzh0Oea0H/vfd2cCL0erBvyMvRu/S4coSQx+3Fzg2MPPbvZV5BUQbYtV6l3veGrShUCFx8UiHW1Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB6590
X-Stat-Signature: ct7a7q3mkya8a7wusjzc7haz5ma7zcqz
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 0919B180003
X-Rspam-User: 
X-HE-Tag: 1776912775-936900
X-HE-Meta: U2FsdGVkX1/qVzaNxztO1kYVKgprV3BPvZ3aBZ/lEkgDxcfjhp6N/yUQNtgzJwC/SpCO8CMMiJbyTyOVFC4x8U1RU24s6HdKyTpOx6CV0MJ6K9Djz35rIMGgW4kJDveq9vVfn84bdvwXVlKzPjFLAEhcuN6jm2W9jfmNjPQ9BYagA0cFuK9tKlWVoZYUjSv0ila1l6nms0dBAeOzGstxE2AhDMt6NeWm3VCLyA59tdI3CVJKVoqjEAs1co3icdd2FUDimUXfAKmXp3S0T4r+KjmloEQDrIUgBR0rG1i4mICMywiC2JG5sEnz7SO8mkpIT6l2hKg9K7WkxCH4qGPX2IN/43CRRfpz09UVFqvivQfofDPURi4LYRXlWOR4AzHK1JCe0u4OXfzOoDRcV+R3eEPp4HlJ4PKA261f3IqLMrORKrRGwB8cLXVUkWNSmyggVJR9s9iss6GmdKNDZ02niqbHmaPPed/js+O9uW6WJ4/tjKA/dBPfvNhEapv6dJpkiXsfCEuhzWHa7jydH2fdgE+JomDwdWp7n7MRo0gDa+W+c0F2auIcLzsr5j/zXlJDZNrv74EMex7A3gk91SQOC2pODkKhW2G2KfulwHuv8LVl8Ree1KPjNaXqxOkJe80/IXYu/Hdr+rdQjq84bo6dwJ3Fm51hvtoJQpZzLntS/E49eV54nheH4ydK2Zklf/9Vg3TOu1YnjVe4Dm8l+6eA3bv6MeMAwv6aIp5Etq88fqts0CeucjGFAa5uYUSWx2FTiOe7nkU0lPrWktF1okIr5IfwsXh4ESNylXchuEjh/8Co4642RV7Nv/HK8aGNSxmLaZj8dEEDg4hPaHs53/BMf0SM/elm+xj5mnp7NiWGl8nxsmCmaorCEtaAgbfpgZbguQdBFKBLbZpJIh+78KvesiJ92Duq7tvg+9gRYX4yeHTkKZsSy+5KYXdLtl+RAUkPjd9TAUIKZ3BykQxwALh
 ndQeiYk6
 Lep0mTnrBDOc02kMIxRHxA9gPSn5q30MPk4EsqcgVZUp1iuit9hMGvpTMRr35P+6fiOQev1Zj0ZZfAevuL5j48itIqEUyDKO3/x7olODVZamhlLgMtdadqPuAKi2j1Ttd6osNGKj7uLYiSA6XCAdNWI3D5hNg0k5KqMNciYSE/iXSSwTe54E5Z+bB0BbKXXWOoj2nY1utHF7JJiuOVpYl94mYFhvFQxIPPJQCQsD0q6VjtwgeMbgURsM/vmHet0CMn2VBJxgjTJq3R2X/xOXXWeVHCizQDF5vPVZ2oDWZp6ZySaaDDh7/kS6U00q5kIhivOEvz5ctruV4376AfvDl4vWZtWLdr2QBp6RmP0e3oQthrHKs1uun4JvUaT72Pg9FqiYvly1MqF7q4qHqUDMXbBG0shbMAPjWvCkxv03a+zudnrO4T/MIzlsWLPpkV+q4bBFWTZXBNJoFa0777lUGwBvTs3USXeLXtjMXHTfHog090/Xvs/EQuwnsj1x+5mW+No3gj037/WYSPBrGFU7Qfk5QJw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4/21/26 6:46 PM, Huang, Ying wrote:
> "David Hildenbrand (Arm)" <david@kernel.org> writes:
>> On 4/21/26 11:19, Huang, Ying wrote:
>>> Hi, John,
>>>
>>> John Hubbard <jhubbard@nvidia.com> writes:
>>>
>>>> Hi,
>>>>
>>>> This adds a bounded sleep to migration so that FOLL_LONGTERM pinning can
>>>> wait for transient folio references to drain, instead of failing after a
>>>> fixed number of retries. The wait uses a one-second timeout. An
>>>
>>> Is the one-second timeout appropriate for all users?  Do some users
>>> prefer fail-fast behavior instead?  If so, should we add another FOLL
>>> flag to support a timed wait?
>>
>> We should avoid a FOLL flag to affect that behavior. FOLL_LONGTERM
>> already implies that things could take a while.
> 
> Yes.  I am just not sure whether one-second is OK for all users.
> 
>> So we have real examples were failing is even desirable? :)
> 
> Hi, John,
> 
> Could you do some research on this?
> 

Yes, absolutely! Great set of questions from everyone, much appreciated.

I'm hoping to have some answers to post before LSF/MM, these are not
too hard to answer.

thanks,
-- 
John Hubbard


