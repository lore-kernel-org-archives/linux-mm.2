Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6B936E7E371
	for <linux-mm@archiver.kernel.org>; Fri,  3 Apr 2026 11:06:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 657736B0005; Fri,  3 Apr 2026 07:06:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6082A6B0089; Fri,  3 Apr 2026 07:06:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4CFC06B008A; Fri,  3 Apr 2026 07:06:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 3AFBB6B0005
	for <linux-mm@kvack.org>; Fri,  3 Apr 2026 07:06:55 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id E0AA7E17FA
	for <linux-mm@kvack.org>; Fri,  3 Apr 2026 11:06:54 +0000 (UTC)
X-FDA: 84616967148.23.59CE0CA
Received: from CH1PR05CU001.outbound.protection.outlook.com (mail-northcentralusazon11010068.outbound.protection.outlook.com [52.101.193.68])
	by imf12.hostedemail.com (Postfix) with ESMTP id C8B134000A
	for <linux-mm@kvack.org>; Fri,  3 Apr 2026 11:06:51 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=qhsjG7I+;
	spf=pass (imf12.hostedemail.com: domain of shivankg@amd.com designates 52.101.193.68 as permitted sender) smtp.mailfrom=shivankg@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775214412;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=t5rvnIry9UjrerDVzyOdltOjSDa/SF64HNl36nSOjaY=;
	b=Fyudhxrk1O/nYvEy76FRAIQeXZk646iJXVf9VJ0V8YKvxhzjrCgKSThJ2+M6mhe0kzEYM9
	6bua7KzUnvXmfI4PNcFbJbVjOh9rV02SBOev9Q67FfkhvPpKWG23s1m2wOTu0cOoBrXcZJ
	IIMPxOBQQ/sPNivmh2Cpk1o68jH2ViY=
ARC-Authentication-Results: i=2;
	imf12.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=qhsjG7I+;
	spf=pass (imf12.hostedemail.com: domain of shivankg@amd.com designates 52.101.193.68 as permitted sender) smtp.mailfrom=shivankg@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1775214412; a=rsa-sha256;
	cv=pass;
	b=HVvTfooYpdZwRMsxhg1II0NziZQnQLeDJEclv2ORjl13z935ubyXqrwDpEL/EZMBgHOsGS
	4Jrc9uqthtHAH89NrBpKWzrM7Zf16Rb+s6jsHBGAt01BxUvYDccuWvZaut1TWSV4yFUatJ
	MaAPDRc/8mq6tMXLZ3SCfk4atKR2TbM=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=aO4dPGYAZ2c+M3YsgyP8vOfFsihczQRnqznR3m+iSIkGVCi8Cv8UER32QyfxdFnRxQAYo0sTLWhz5D2bQZDl4yMK4wv2vKaPmepLjYnlr5UeIfIHKWDS7OLPQWckQ1/AxNjOv6mloM2cyutnK8F+QInZtJbL5M+qNQnrkI8gnK0a1nmTbAGgrJAkIlZv2bMYmmVRhUk0aGi6XAvipFfpJYUyZu+d+/Mmco66qedqOL9ZgIQKFFloLUogS0t5NyKkJ/ABoeARFKnNWMEmc+5vNhB/n57PHtumid56l2aHmVhV2Hm+5+/xOEDkwc/9znqjA5Ae1fH42xu7wCh//WQalQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=t5rvnIry9UjrerDVzyOdltOjSDa/SF64HNl36nSOjaY=;
 b=imtKZZBJvCg0/nsY+kOOv3RuDjjenL1NQFUQzBRxIYfP9ZeRMr+IRBlLA3ljqHIX3LnzPPn8zoQb5+EXqzzlFMHKqMof8iPfdKf0pEpwLISFrRv8EwYbVPnVty4Jk/alqf54tEYizaqDc8lAaWE/3Y3+hAettrCdmDXrZ8lT/CTuYDxDoO57L+72Vif+ovSWFX+ziiTgXvgH2ysAEa7ZGrsY75lRFFfCwZboWXScsji9nPRoukue00KpdO2Dn44oQzmpoVKBNcSK/QluZR2WLmjTFsC3vy/qApeTI88LkQGjkMN3aAJUrCC6H8yHQg+UjJp2kIoM64mBmte3o+FfOQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=t5rvnIry9UjrerDVzyOdltOjSDa/SF64HNl36nSOjaY=;
 b=qhsjG7I+oNoAXxBoVP0+XjgRRE5tnmZkjwBbyCqLNs2cuvkVXzwKvFvHSg1NLfegbVXz+eE2dsdHIYKXRR2McXTV243VxBgdOcF6UHoyqEq3AcPHbyShlyB87mC81My5NspfwTXDEFQCFUoowh8L4P3FSxya16LMmByat468iz8=
Received: from BN9PR12MB5259.namprd12.prod.outlook.com (2603:10b6:408:100::17)
 by PH0PR12MB7931.namprd12.prod.outlook.com (2603:10b6:510:289::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9769.18; Fri, 3 Apr
 2026 11:06:45 +0000
Received: from BN9PR12MB5259.namprd12.prod.outlook.com
 ([fe80::122c:cca7:c2b3:90ed]) by BN9PR12MB5259.namprd12.prod.outlook.com
 ([fe80::122c:cca7:c2b3:90ed%3]) with mapi id 15.20.9769.018; Fri, 3 Apr 2026
 11:06:45 +0000
Message-ID: <198ca11f-8918-4f47-afad-e8ff14643254@amd.com>
Date: Fri, 3 Apr 2026 16:36:32 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v4 5/6] drivers/migrate_offload: add DMA batch copy
 driver (dcbm)
To: "Huang, Ying" <ying.huang@linux.alibaba.com>
Cc: akpm@linux-foundation.org, david@kernel.org, lorenzo.stoakes@oracle.com,
 Liam.Howlett@oracle.com, vbabka@kernel.org, willy@infradead.org,
 rppt@kernel.org, surenb@google.com, mhocko@suse.com, ziy@nvidia.com,
 matthew.brost@intel.com, joshua.hahnjy@gmail.com, rakie.kim@sk.com,
 byungchul@sk.com, gourry@gourry.net, apopple@nvidia.com, dave@stgolabs.net,
 Jonathan.Cameron@huawei.com, rkodsara@amd.com, vkoul@kernel.org,
 bharata@amd.com, sj@kernel.org, weixugc@google.com,
 dan.j.williams@intel.com, rientjes@google.com, xuezhengchu@huawei.com,
 yiannis@zptcorp.com, dave.hansen@intel.com, hannes@cmpxchg.org,
 jhubbard@nvidia.com, peterx@redhat.com, riel@surriel.com,
 shakeel.butt@linux.dev, stalexan@redhat.com, tj@kernel.org,
 nifan.cxl@gmail.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org
References: <20260309120725.308854-3-shivankg@amd.com>
 <20260309120725.308854-14-shivankg@amd.com> <874im51wcc.fsf@DESKTOP-5N7EMDA>
Content-Language: en-US
From: "Garg, Shivank" <shivankg@amd.com>
In-Reply-To: <874im51wcc.fsf@DESKTOP-5N7EMDA>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN5P287CA0017.INDP287.PROD.OUTLOOK.COM
 (2603:1096:c01:265::13) To BN9PR12MB5259.namprd12.prod.outlook.com
 (2603:10b6:408:100::17)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN9PR12MB5259:EE_|PH0PR12MB7931:EE_
X-MS-Office365-Filtering-Correlation-Id: 1128218c-bd90-4519-5ec1-08de917117de
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|366016|7416014|1800799024|18002099003|56012099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	ju06154okFQzII/1HowMGEj6s+DMl/4wXaY4QB06nLG9J6TKpqnptbr6cMQ4Vl/+Sr6pbjXAFDJ4AvdWz5j2ndLIpd88fT4SDoRY9tn7hZh+oQUvDh22CNf5+Uln09oMbze9Vhf2U6FrMzkLLDozdlaf5k1o4FRR8G+mAPbXBhGrObkDzsQbfPyTd/EXmLnsaLtXsgu3/oPSU9OWnzI6SACQ+xRf68gXryTvYfEX8dIgW9LGzPoSBtn+Y/uvWK5vd/8OMwzpZ24Dcr59fen8TOWb8pvOEkaXfG1b8RlvKXQFg4uvEOOlEliLwJAelgt84dZJTjJugOGJXaynSLsC7WjQ65R0W+AYetLZxCViB2mm/DpM10SHmJPc2uBHbbsUzQ0DsUXNea0jWVux/YB/vyGkuML6f0tjUnxzAS1eMekUU9joUzUmWK4hnnzUNaUHW4+KRAuUXVEryJuwlY1vT9LOKRXBpR94InckJU0BgHDFzM4581gAwzYdkDx0BP0lQ12ay/1mij1BRTK/+ccd3TYgqxmGOQBjE+MqJGiTOh+pahufKT1GXR84x7IItqJDlxgPKJrx5EvcE7IAtXck+5qJyr5LKHIWa3IF/SdU1fsDdR9pBWLoea6E3xkWbf7Ln5QBbyVqb6HdUuh+BuGaI8lPMkW9zQ5Quhm9DpX8yFMvARP1pGVEcuwkLM8QhA1bjWJhGeinRqH1/9yEPelo6EtK5KEaY3r6jQZTscv3Sss=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR12MB5259.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(7416014)(1800799024)(18002099003)(56012099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?L0RxTysvQWdSak9vaHM3ZVhXL3pOS0xIcmUwZjJBR1JTZXRReUwrZlZwcFA0?=
 =?utf-8?B?c0lDWi9BRFVvbVp0WVFVMEkzeHlDOGJEcVE5VjB2Y0ZvRWNsSTBwZ25MMWVv?=
 =?utf-8?B?TU1Fd001eE12UjduVHhuYWhxcWNmOWJzaVhNbnVUVHJtc21oTW53ZnU4REM2?=
 =?utf-8?B?UE5XQkF6K25kd0ZMZGVxcjhVM0Z5WktYQ1F1VXlmWjMvbXBxeit4M2xmdzRO?=
 =?utf-8?B?Q3JaRzFyaUs1dCtKN2E1b1FGWHBuNzdEWDBURHN6NEdRL3dIQ0t2d09iNURp?=
 =?utf-8?B?WjZZbHVEUTJ4blJCbmV0a0FCT0IxN2pHY3hqalE4Q3hhakpDSFRBcDU5ZHpF?=
 =?utf-8?B?U3pta2wwQjlqYWE2ZVk5SFZGSzFBVGd5eXFUM2dwUWpNWHA4Z2M1cEhRNGFn?=
 =?utf-8?B?eVczK0szb3hsTUp5OXBiT0JHVUwwMzdDejdxandRSFAzSGVSR003RFJYVnhl?=
 =?utf-8?B?eWtkMElTRWpoYmczdXJiRjd1bEdsZ1hxU25qVUcwWE03eWhqa29Jcnlrc0NQ?=
 =?utf-8?B?Y2hpZzV1WkdTcGdUL3puS3BYeTFCUloydGl6SEdCc3dIUVJJR0xnQmwrS2FQ?=
 =?utf-8?B?M3dOaW5ZcnI4M1RHeTdOMkpHUHAvTWdCZ0lROWxsRk1kWlJ5V1F6c2g2TUZr?=
 =?utf-8?B?NkNDdHExdmdwYnJOMkZ1bUxMd0FVYjAvY3dOdXU5aS9aYWtGdUVjTld5OENa?=
 =?utf-8?B?RzJnWjYvYzFMR2MrTWdMTUI4MlM1RHc3VjlwZDhvUUpPRWJocHFqUGcrWE8r?=
 =?utf-8?B?UXlVb3EycDVXcXJ6ZWlhWjF3Z0FucUpzQWhvR0owWFI2U3NValY5MXJYODMx?=
 =?utf-8?B?UTF6QlNRTGF1MnNQS3ZOa0ZFSU95UndDcHdoMkdxN1h6QStoUzdxUlRoMmZ4?=
 =?utf-8?B?NmJnRENZRFN6S0xScE9DOS9VWWY1cUFnbmZuMmZqeHIrbEJDMGg3YjBlZ2ZE?=
 =?utf-8?B?VTN6RHd3TmhBaEZvMmFoY084MFN3ZklONHVqakNETzBVQ24weFl2WFkxc1pV?=
 =?utf-8?B?aWl1YjRwT1hLcU5MakFLdzZTdFZBK0pWeVg3UlcyT0IxRmNoSnJwbmdVSEZF?=
 =?utf-8?B?R0JLUE1yanQ0ZGdBdXFBY2VRUXMvOHd4UjFCVDFIZ2J5ZGZPQk9wenVhKzRr?=
 =?utf-8?B?dXJnMHRlTVZOWFNBMUsrSXlCalVqeDEzL043SjFjUk0yblJ5QlRtUklySzJs?=
 =?utf-8?B?Z3E0Y0F3Nm1FOXBlWStScUJrY2tZelJ4VU9xM2VlMFFRU2hsVmxIRnpPT1RX?=
 =?utf-8?B?dDNrbUF6VjRhQ0VBazZoWTZDeUxXWVkrNHgzQ1A5Ny9LNnVMZzFlQWFhTVls?=
 =?utf-8?B?anNaSlBGeG14a3UyM3d4eUt0SGlicWtIM3NYUW1mVFdOOVVXV3NEekRvL2ht?=
 =?utf-8?B?YkVrRk1mZXllZEo2L1RNeUJJYlFGV1RjMzI5Q1VrZjBYY0pBZGhhS3Uxak5v?=
 =?utf-8?B?MlRnbzdvdW1QSnI0Tm5EdVVuL2gwVzVBbU5lUDhDOEI3Y3dUdFNtVEk1ZnVE?=
 =?utf-8?B?SHBHRjNuUWUrSFdHUlZWSlhtM2lJNEFNTE81QkhIMFNvbytsbXQvcUlYUzR1?=
 =?utf-8?B?dFlvYXhXTDQxOXl3YzJrSzNZZmFtREhQTDd6bEJQZWxIUDR2UkRlZ2FSWTVU?=
 =?utf-8?B?LzhSR0lSK1FqR3NkaVNTZWZWVEdkYUgyekc1a3lqemlXUllxM3RQQllJaHkv?=
 =?utf-8?B?clVRV2pWNDM0aXVscitmaGdMOXpYeHNod3BWS05JYTZkb3FwR0ZIVExzOXp5?=
 =?utf-8?B?UjBBQWlYKzl2YkF0NWgvaTlKN1djdDd6aVgzcTZEbDhyWW5RS2Z0NTBzanFN?=
 =?utf-8?B?WG9vUHVrR3BTeEF4S2RhMVB1akpLRTI5QXo3SGxJYU84UG1KNTZxOXYxTWhG?=
 =?utf-8?B?L2l1OXJUZXoyb2IzY2FyY3pzNVUyZ3U3Yllvck5yZ1k5QmhxOGpFVFpJcXJS?=
 =?utf-8?B?S1ZkRW5hZXNHOURUQ1FRQVVPMDBaY1huNmNOa25xZEVYR0ZVcDRmdTZsdXRZ?=
 =?utf-8?B?QlF4aGZkVUk4TnZVdS9GTmNiTXJLTVJ1RmtLaVZIVktjUWd1K1hOZWNVZXNs?=
 =?utf-8?B?VHR3V3dvSDEyalRxekFhUzFPMzUvQk9CbjlQWWw2UUN3YXVQcXYwK0xUR0VN?=
 =?utf-8?B?eHV5dEVEZCsrc1U5Rm1jR29DRzlGbTFzT1hiK0ZuR0tkaDVZQndlYzVzMXI0?=
 =?utf-8?B?UEx6dTRUUUFoV2txYlZFVXZrYnUxaFJqdG9LZ2ZlZmd0ZmtnaDllMHo2eUJn?=
 =?utf-8?B?Ry9wVWpYMEZQVGpMV2t0RGRWckVhMEtOWWhCK3lnNlJ6RUVwZ2dmbkdtblN1?=
 =?utf-8?B?d2VRVW91UEwzaWlmalJqOXoybXNVWVRINjdQVkRtVEtTRE1ReVBwdz09?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1128218c-bd90-4519-5ec1-08de917117de
X-MS-Exchange-CrossTenant-AuthSource: BN9PR12MB5259.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Apr 2026 11:06:45.3893
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ktqKMw1YlHpoqnjt4VlgUwRsW7loWxH0uDc3iDKVRejK0le2aLZvFbSpa7QToOrsKnGsPsTT8aaHbjdhovJPzA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB7931
X-Rspam-User: 
X-Stat-Signature: wxihyuy68szfpa1r4cqrfwr7dqwo97co
X-Rspamd-Queue-Id: C8B134000A
X-Rspamd-Server: rspam09
X-HE-Tag: 1775214411-292231
X-HE-Meta: U2FsdGVkX19kprOq1XZduMQmj/JdnWFCl0M66ftajaD9cyVBpiBQ6oR80bKp46s0SXNrMsiU6iKpFTLMEvIOXFCF+BOQXa08TxHhoHIhZh4lzqzmIocYCWf2MDZ3m+YLwtFG6x8C/WZKN8hiC4uXLOarsv3RQ9+1eGK6LGAQ5VGWVX0SAOXnYq1T6316PD9xZeBAAVqoTDpGabliJQdl0qWwQnaGGSIsgV7P1nK/XqmlvZN9qXnjLyqTeoD7V5IIfxb3jehfQ1kWLVF2wjTI+yoPMtEWshheV5QdqIbbqNghmCRzefTCiAdW2j238bO3xalQaR54p9Wv4JU3NNvGDTchrTkYCGIoYlDmf8hUIF6b5xEKhL2ibtCHOHB7/zkTckZ1I4xwbscr0om4nWx58yiRR7tZh6I5tgGUerDeT9TNZ457pLunn1KpVtVmFseNblpmYyYWZ2OkyQQPBeWn/8wHTfJuQAFCCY4L+ASWKB5zIczNoBTjFnz3GFWcMi5DxSuB82Qq2LBA58R10N+mdYGuj914+xCLw0KY7OGZ0PYN56znyiGA0bDwpU0NrpgH1AyUPRt1fIgKEpT3tP0QVTjRG/RepqofDJZXP8ZG9ByXLQE0aS0dDoCR5kYRkBqPsp8//ddLASx50dWkbUvnaxHBzvj4vV6F0n3KmkA7nAOtOjuOCztPiNlSZXMAbBsLEe3bC7CsX+jXqjYX/hwBWSDEK6/t5GAmB4ebQuoNzczclHF6Y/darpZZrDAwqt+RWOL1af34MzEgalgH8trJVP4XAg5UuaZzcGLtfbfEt036oFhQx2ZmatpNgnHduA2kL0kyO8Ufd3FpYyffTIvxxg7rmszBA8OEYJojBGfQylVOypIq2BWzTZJ078U7l3bG4Lm/0q41ZViJJKkTnaWbsYQ01HgMyCJp/NLfUl2XOCBdp9yNkF8IYQXA3YexA+fnHumc7I/oRt8i13urRT2
 UjA7L45p
 qiPLcyJdrFAOvpN5H24WfCz98yQidnlTEG4CVjFpZlXl+mrs4xhwmrTjeyG5vqj0WyL52wZhFQv/eBcnvOgCCYP8QQKvL0MPkRSLBHDxx0qNAPUr42FpfU5BxZACFD45HJR7cHUHKmTTIOak0zKRDh3VZmc2LOHm9R3R4J4ceZHrQO4dYFKEDW1yrYBCrrEotrntenoGIUEc69QWQy5oQabNOsyI/JUzYhPiFsbLp2tCdnUkUvgFENR/7IA9h0dYpM5E2BvrtqHdZ2+/l4oFdi1xOWJe6rR63wEZjIMGvIdSCxco/c7pi2buLJyLGNEVjWF1xQ2twpT+e/XOFVUFBrBSJOzuXUxfI2IlKEb+EahtPJDr+wIV7GdqXAncKVwSPn36wHAifzr74pBNf1F69yhKdyzTXnECqsFkILeGYdXnj8gWVm4DCn9NyR8oGRlnNNlZcz67llInggqDbrGKLW3mWi85UmAvgi3TBX5QUxfd0Qo8sAjQfOtirVOx3ljXPbAYtJIhYQ9ma5h/Lkp7at0WUqqX93JBOLt03k4TJoAMwWj0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 3/24/2026 1:40 PM, Huang, Ying wrote:
> Hi, Shivank,
> 
> Shivank Garg <shivankg@amd.com> writes:
> 
>> Simple DMAEngine based driver that uses memcpy channels to batch-copy
>> folios during page migration. Primarily for testing the copy offload
>> infrastructure.
>>
>> When DMA fails the callback returns an error and the migration path
>> falls back to per-folio CPU copy.
>>
>> Sysfs interface under /sys/kernel/dcbm/:
>>   offloading      - enable/disable DMA offload
>>   nr_dma_chan     - max number of DMA channels to use
>>   folios_migrated - folios copied via DMA
>>   folios_failures - fallback count
> 
> How about placing the sysfs interface under /sys/module/dcbm/?  We will
> have multiple migrator implementations in the future, so dcbm behaves
> more like a driver, right?
> 

Good point, I'll move it to /sys/module/dcbm.

Thanks for the review :)

Thanks,
Shivank


