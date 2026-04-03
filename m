Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 103A7E7E371
	for <linux-mm@archiver.kernel.org>; Fri,  3 Apr 2026 11:08:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 744B56B008A; Fri,  3 Apr 2026 07:08:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6F5C66B008C; Fri,  3 Apr 2026 07:08:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5BDBD6B0092; Fri,  3 Apr 2026 07:08:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4A7836B008A
	for <linux-mm@kvack.org>; Fri,  3 Apr 2026 07:08:56 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id D8CDF1605C9
	for <linux-mm@kvack.org>; Fri,  3 Apr 2026 11:08:55 +0000 (UTC)
X-FDA: 84616972230.04.69C1999
Received: from SN4PR0501CU005.outbound.protection.outlook.com (mail-southcentralusazon11011020.outbound.protection.outlook.com [40.93.194.20])
	by imf12.hostedemail.com (Postfix) with ESMTP id 2FCED4000B
	for <linux-mm@kvack.org>; Fri,  3 Apr 2026 11:08:52 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=yzG2KMuO;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf12.hostedemail.com: domain of shivankg@amd.com designates 40.93.194.20 as permitted sender) smtp.mailfrom=shivankg@amd.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1775214533; a=rsa-sha256;
	cv=pass;
	b=6IFDjq6sFGEU4+Q9VKc6WSjCDaDePSna1DulKG995sFmAtsVKrPOUEsyv+O2ZJg9h2OVBh
	q9lW72BdKEPG+FWKK2nqEMiTbfsmzlYeWYC+bDCZP0YtN+0lt0Rcx7VQ9pFt0OK+iYiLZN
	RjY36K5eM0ysH4XF9yoRwdkdCfjVeK0=
ARC-Authentication-Results: i=2;
	imf12.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=yzG2KMuO;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf12.hostedemail.com: domain of shivankg@amd.com designates 40.93.194.20 as permitted sender) smtp.mailfrom=shivankg@amd.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775214533;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DLNVa0Kde5oefWWk3AQU6LSVICI5xTSE5s1YytCTi6g=;
	b=X9TwXaVb1CldlWdpYNqIOKWV+kvQC9tV24903b+76LiBXxLygtsoO81Fur44R8jp1SWSq/
	E7Aqp1x/Ut+N/4DEqUjHEVcLp5hxdwwoiEl84z2k6CzXYg8Izy8M1zXVbOPQE4omeKC7y6
	CZSebbKvODpUVIRgOftF4YAlHzv+bUc=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=fLLWPapK0POUN6ZKbJaVewv4onGYIf32X7EG77BlXyEhoO6OoY47kqdhMzynEs5QaMkXRKMvlNJfEkyUeO5kbGWY3MrWl1//XOt0dTOJ5w6XImcYrYNA8PqM5Y4CrSfQg5IFrE6d0vBSWlrsSGUO1h13Y13vTmXNj/ld3sLtA2AhkF5Lb4pp6zQhf4fRuBGbTBTTpB/sulAUL64oNj53R6PwxGROOcLqmnhOhVWxKyevW2qKpk0N+UaRR1po1fzy3LXuwkFrBoX4rWfebAlCi/TyDZ7jxdKtqT0wsqQWu3W+AacXyllYg5O1nXI2HZKTnguxK32clBa9oFjDsrgChA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DLNVa0Kde5oefWWk3AQU6LSVICI5xTSE5s1YytCTi6g=;
 b=CaDFm3gclASVciJZrKr7gIa3xwKsXrMqulUNFwfB2NZn5BbckVb4U7/HGN8lfmxRTua0t9/1VguOKZa3KaZxvTOdePl4p9tUF1RxuMe73QgITUTbuOa+uOUm7YvtaIV2Li1kUr0w0m88LF72xt2M9sFe93PqUu3BgWu5N111WXsDY+wnx26Aglc7vhZ4k2mCY5mm0Is681ieP4FKcV3TtQBKoQ/f1lsaLr5bY5KQjuzPWNgTFs7iQEkgy4FSuqLev70INNni1siH0gyvfmo/6JnTRuxriHbeSR+huYfU75smqDzvF9QznavlYXkZwlmnOhjs+bXX+uTrh2ZJUvr+Wg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DLNVa0Kde5oefWWk3AQU6LSVICI5xTSE5s1YytCTi6g=;
 b=yzG2KMuO1awKpxn+fSrNIRDGY5q4p64AXG4wBm+7PTnKT90aeY18Jrb5OBzWi/uCMSIruJsIQx7OPXqKb0Ha7BDnxfb5loAxeqEjFXie2BSIc4GvLEYK35pf9XURC/ZoZzlkhu0VlORLLTxGxMwnQkMKb+jdr2/dYoylDP0dBqw=
Received: from BN9PR12MB5259.namprd12.prod.outlook.com (2603:10b6:408:100::17)
 by CH3PR12MB8909.namprd12.prod.outlook.com (2603:10b6:610:179::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9769.18; Fri, 3 Apr
 2026 11:08:45 +0000
Received: from BN9PR12MB5259.namprd12.prod.outlook.com
 ([fe80::122c:cca7:c2b3:90ed]) by BN9PR12MB5259.namprd12.prod.outlook.com
 ([fe80::122c:cca7:c2b3:90ed%3]) with mapi id 15.20.9769.018; Fri, 3 Apr 2026
 11:08:45 +0000
Message-ID: <3e1f520f-e3d8-4ef2-b474-ca4e988bbf2d@amd.com>
Date: Fri, 3 Apr 2026 16:38:32 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v4 2/6] mm/migrate: skip data copy for already-copied
 folios
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
 <20260309120725.308854-8-shivankg@amd.com> <87wlz1zlf8.fsf@DESKTOP-5N7EMDA>
Content-Language: en-US
From: "Garg, Shivank" <shivankg@amd.com>
In-Reply-To: <87wlz1zlf8.fsf@DESKTOP-5N7EMDA>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN5P287CA0022.INDP287.PROD.OUTLOOK.COM
 (2603:1096:c01:265::16) To BN9PR12MB5259.namprd12.prod.outlook.com
 (2603:10b6:408:100::17)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN9PR12MB5259:EE_|CH3PR12MB8909:EE_
X-MS-Office365-Filtering-Correlation-Id: 4ff36d82-19d0-456d-7707-08de91715f73
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|1800799024|366016|22082099003|18002099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	HMfBPfDD0hqQnzZBRe6nT9DJlhCoXSGXQ64RqHLjyT6dhgIEYS1+E1L2caX589ZNRiMeA8KhTyyeDvYnkkH7pFxw7xbA7s1X+DiyDXKgiOeyFwF8DlrzZlJg/qm9kMyp4yFio/GYCM6zFKiWyBcrY9HYSHQ8W6DUvLc+kR3+ETBUA9PrxsKM68fBPxL7UxQ1ZhwlKMzzCrjiuI6Ws4d9s81Z5Aa5aoz8n/WWsb0CpMXVn+5gcRuRSiRIqWCix8pq4qF9oPrSds+RJxpvnNqxjO3vLqdj6o7wTxFNLa1VAQ+OqA/Um2sZEkxOw8xmAYpHi510ycWyVLrrnCoGtoq1wiRoIi/SLhqRDhP0u3TnR0p4vjPFPJqrJitcmdCXbk0wRq+Urfk0Slts7Xy67NH4vNgLCStWcSaZbDKBVlscQo69whjdTPoorJmb7d71Sr1ymra0emYy/DPLkRWvVUn/he/ILcwV1wrWqciFH32X85SUdG6z/TzLB7S0LhPoRlXykm+IfNlxVNtluvtjjKy1+wKY8svqCnt9URbdgF9JAieBCswudNa2FAjv62NvCybKVmzyDJ2zzWuDUlo1aBimNpePrCmVmyevnACCfLdEZs//i//WgkGq0+ISAN1ec7iNuLtxrehjT9BUw1N7dEhOY79huRkYvlzXk40MBWQlnDfLL0RbS2PshX8M8Sw5ialp
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR12MB5259.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016)(22082099003)(18002099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?NE1BS3B3Tm5DY1craHBGNHpLMzdwMzh4UHVodklITEVYeGt6eUhaSzVhTTZB?=
 =?utf-8?B?b1RuZWl1VnJ1bmxzUHlScjhyNVpMbm9uVDQ5TXh0L1pXVVdEL0RveVl0Q25V?=
 =?utf-8?B?ZGo5L2llQzdEa2t3Y0pFczNYWENwdGlzbkQ2R0NDZ3ZTMHNWbGNDRkRPNnlq?=
 =?utf-8?B?VEhkOTJWRHBBdUFMd3REY3UzZFJoamxodWJYTFl3RGg3V003L0FqaFE3VG41?=
 =?utf-8?B?U3FlRXlaZElnT2RaYmpSQ2RWUTlMaXREVm5vUzM2dlI1eDFQWE9ndzVyTlNF?=
 =?utf-8?B?c3Nabmd3WGlNRDAyUE9hM0RiTldPYy9RV1JBTlpJZVp6d1F1Qm9XYjRZM0Qv?=
 =?utf-8?B?a2VyVnAvL01xaEFDbVpLcW44U1g1Q3p3S3dFdUcyZ0lyMDVyL1pjMzhrQm1M?=
 =?utf-8?B?VDhSenE3MUtMSkdrdE1FYk5JMEVLY3ZFV0ZSb21KMTBpV0RtbXI2UFFBdDJ0?=
 =?utf-8?B?OU9jSFk4RFdpUlBid01QbGpwTFRQRDNzRldnQUVrdXpjK29BczYyRFd0SXQw?=
 =?utf-8?B?TjhmV3BnZGJRRDVPdmNIdVIvYkhoV2tkRGRBQWQwNWxnbVU1ckptZnNwOUlV?=
 =?utf-8?B?Q1VrSGluQk5EclRvbS9LMDBXWlhpV3JXc1JJcEduT3lGRlB1M2lJa1dUZ3Fv?=
 =?utf-8?B?V09wRlBHdkJXcWNWcWVHY2Q3SzFXNzlOQkhmazNEcWQ0aFNNK3AvZEJObDZp?=
 =?utf-8?B?WVIvcURRT2x6M3o3WWVnSEw1SkRXd0VCdDhtbUlZZ2k4RG51UGJUZ1NEV1Jn?=
 =?utf-8?B?bytiQ1FnZ3Z5Q2V0eFQ1bnB6Wk9ReXRXbHE2b2F1ZTJHU2IwamlDYk5sZXNq?=
 =?utf-8?B?NXhXK1RIR05qcVJ2NDFQSVA5YW9SYm1nQzU0bnpmMzVYVVAwdjVuOEx4aDR6?=
 =?utf-8?B?M05FenlYWEZVYVhJckp2NUNsdUFNVlpSUUlrbW9YdVJ3NEF0c2ZKYkV5Skxq?=
 =?utf-8?B?VzNoSktQc3hPMDdSeVM4MmFxWmViTzJ3bXdTT0M1QXYveXJBOWtsZkNlTEdE?=
 =?utf-8?B?bC9adWdMTXNVbldjVVRRaWhvMUFta1kxOWpjOG50b1A0WGhPcnJBMjJoZkxR?=
 =?utf-8?B?NGhDRjUzSzZrSkpHWEVDSERDSlRBK2hwM3Jpenl0TEhEb2FHMWphOS9jUFpH?=
 =?utf-8?B?R1MrajR0R2lUZkpKenhXdVVPVGU2UjVaWjRoSmhQK2tNSmNJWEc5c0VsRHFU?=
 =?utf-8?B?R3d1ZjZlVnpvQzY5MisxR0I5VitFZEJHbk5lQjdiOHBkN3Rpd0orc0dZNnNX?=
 =?utf-8?B?SlVpNGszRWdzZkVaVUI3cWtBQ0p1eFd3QnBhU3FsaFB2QlcvYk10SDByY3Bu?=
 =?utf-8?B?ald6N3FmbGRuRjQybmhMbUZiTHRQd01GaTl6OE42aENFMVdNMUpJcUN2K2Vq?=
 =?utf-8?B?TnNaMWxFN2FJVFkrOHFhZ1A1dkMrdVJDV0pMSDBxU2JOdjBydys5RDB0MDBm?=
 =?utf-8?B?ZmxUTk13UTJxbDdmV25KOUhRNTRWZzVTRFBKR3A0TDAyNXY2ZUoyVmw1MkRN?=
 =?utf-8?B?YTJ0dEo5RUNpd21LYlZIemxVYmQrY2FMNUNpRURydjRhZTAvSW1zV29va1Fv?=
 =?utf-8?B?SHU1bndsTmd6bWIvQlZ1eGJOeStTMWhwa3o3QXlDUHhLVU5qbVAxak44Q0k3?=
 =?utf-8?B?OGFTYmJYaENmM092OWZmb2tkTjU2ME95TEZ1dm1LZ3U2UVFZdFBoQlB2UWpV?=
 =?utf-8?B?eVpXdDViZUxvMmVValZHb3R2cEgzNU9kU3pWbUsyNzlLYUM4SGlzdXcxQkFK?=
 =?utf-8?B?Q1oyUjZycVIwdDlJUnFjZGlhaTBjT2FHeEIyUzg4SWhNWVlQL1k2UGZ5S0dK?=
 =?utf-8?B?YVJZY0JWM2VtSFZKUmxIV3lVTkZpNWkyRENPYlE4OWx0eEMrcS9aRFFqMlN6?=
 =?utf-8?B?RCt0aUx3OEE2M0RWTFl3LzBzYzFCVjFsbVQ2eUk4ZmIxcnVEREp4ZUd4RWh3?=
 =?utf-8?B?MS9Cakc0QkdpOUhKY3NaTCtGbDlqMkd3aGw3K1F6bTF6cWtpdDFPS3hjdmtp?=
 =?utf-8?B?WTVRdVFNZTBIN1BIYjYxRko2SjYrVFZYRDhrLzJZZFZjYjVEc05MeFR6ZWNZ?=
 =?utf-8?B?T0VwNkhEU29EQ25ubzZ4Wk1ibWFxMjVxUlV0WTZySkxVR0Jyc0hLbjRrQTBI?=
 =?utf-8?B?ZkNJUHdGMkU2TU5pQmhJTHRObXNYL1k1N0RjazNVY2xBVytiRG9TTCtOMGNF?=
 =?utf-8?B?ZWI3clN4NjFqWVUxWngrQ20rOUs0b3BUUW5CbDdiK3l0STdjZzJrMTdYZUM5?=
 =?utf-8?B?aUpuWW13a21ja1BseFhGcjY3ZFR2QVNOTGlCNVptdEczUU5YVGdRWTdENzhn?=
 =?utf-8?B?cGVLUW5vaXkzeUg1dUNVZkJNTkQyeUp0T1J4cTA0dWplb1RFTnZ1Zz09?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4ff36d82-19d0-456d-7707-08de91715f73
X-MS-Exchange-CrossTenant-AuthSource: BN9PR12MB5259.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Apr 2026 11:08:45.2962
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: oKBx/XqRv2EFyxHEQraXqDnpkR860uk+07E6QdtLuQEVDP90u9Qv0vtSuWvgk5M9iJQnSzq/iiuFpYxSUgLutg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB8909
X-Rspamd-Queue-Id: 2FCED4000B
X-Stat-Signature: 95xdrg6dd79bcioanpczyyk8cty5rgxu
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1775214532-813084
X-HE-Meta: U2FsdGVkX1+TtrulagfQCznQG3leah7+yQyBPO1v42pGuua6kaSatvXgHjbdyxRpN12stRj9ctXXN4P7VX9X6NwNz0KnQcFHMqFJFX37qnTP0KyzzpK87KNdj2MQUB0JtQ2QWAhy2nw+BUjMHoWam33gxDcy3IBuTZU0ZXMeLUNi6ZtbL58D8UVuOa4DyYF2TsLcER5ZndRON1wPtwMo6OdbtdBMqNQ54voO1PPijzLx8Z3C18BPIdqqtHBVtyNCDNPxF2CAvsOaCt+H4D6yxRsW7a8Nmsa8YXmdD/SgW/fAN3SwfqHH4DewKXn4v4vR7Dc/QYIQGGKMpquDV6PmeO7AUXe1uggQqxyYUSwgUcccpcZNFqA3pTATq6tqJr6SNCatoPEgMbhdiKm8dFSIcDKM1If5Q7po4kCl2cXFegjnOhcd6YPypl+9ZtPYLMisXseXeiGDdDsSTrNSNhaXj72glciuMiDSS9K4eX0mskMCqHBX3r7J8EDlHQ5p2OuvvGb+65U8syLIyInZ8qrvVb3HRKTyiLCApRHRrrazg5nLMJ3sffDZYSBkg5zvGyFqRHxKMqDIlt9zgSjZNiWfgqpUkb/GQErNrGd277v1mp0vmoLh6ITIw8SGUnV2jZmzdFEZkAhJsLYkHtOiFh41idMSBIjln+h9nSrctf4Rqbt+qTHtBlc7oHbVBwhv0QXoo2blrSnqBtiJDCBzdFBN7rm07SEC9Y9INwkQ55+Rjh42qn/qJ61vBA56J9qvzRV9Zzb0JlNHPt9W0331F8VtcXW1JSLZJQ1Tfh/p+oWuE0T2ENLBCYlsQpdOSUUNp3IXE4J3lsqEOndP9OO7cZKle3Q5AF6GvV1z9J6Jgz/vZKrMAIwb8Y5CvsHM0+36Jcpo/StNHClNxzMfpAzdreVjGJZSc4HYROpZl1hXKSWuPQV+wKJll/saphMGFUQOWr4bCLOoX5LC0J4iUqR7iIn
 uMml6oOS
 S0Mpahsc0pSQkA3jWZlBWuE1zrwa1dFb33m9u
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 3/24/2026 1:52 PM, Huang, Ying wrote:
> Shivank Garg <shivankg@amd.com> writes:
> 

>>  static int move_to_new_folio(struct folio *dst, struct folio *src,
>> -				enum migrate_mode mode)
>> +		enum migrate_mode mode, bool already_copied)
>>  {
>>  	struct address_space *mapping = folio_mapping(src);
>>  	int rc = -EAGAIN;
>> @@ -1096,6 +1114,9 @@ static int move_to_new_folio(struct folio *dst, struct folio *src,
>>  	VM_BUG_ON_FOLIO(!folio_test_locked(src), src);
>>  	VM_BUG_ON_FOLIO(!folio_test_locked(dst), dst);
>>  
>> +	if (already_copied)
>> +		dst->private = (void *)(unsigned long)PAGE_ALREADY_COPIED;
>> +
> 
> IMHO, this appears to be an unusual way to pass arguments to a function.
> Why not adjust the parameters of migrate_folio()?  How about turning enum
> migrate_mode into a bitmask (migrate_flags)?
>

Using folio->private, keeps the change self-contained in migrate.c

David suggested adding a dedicated unsigned long migrate_info field in the
folio union. I'll switch to that, as this is cleaner and avoid hacky use of ->private.

https://lore.kernel.org/linux-mm/27b1b602-129f-4bc5-a553-386e8d1f5d90@kernel.org


Changing the migrate_folio() a_ops signature would touch nearly every
filesystem for something that only core migration cares about, and does not look
practical. We can't add to migrate_mode enum either as currently those values are mutually
exclusive and ordered levels of increasing synchrony (ASYNC < SYNC_LIGHT < SYNC)
And there are checks like this (cc->mode < MIGRATE_SYNC) or  mode != MIGRATE_SYNC
This could break it.

Best regards,
Shivank

