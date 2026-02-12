Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A97D0EE3695
	for <linux-mm@archiver.kernel.org>; Thu, 12 Feb 2026 16:22:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DB7366B0005; Thu, 12 Feb 2026 11:22:18 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D3A9A6B0088; Thu, 12 Feb 2026 11:22:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BF1F16B008A; Thu, 12 Feb 2026 11:22:18 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id AB2386B0005
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 11:22:18 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 50F65B68D5
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 16:22:18 +0000 (UTC)
X-FDA: 84436321956.28.9ACB692
Received: from CH4PR04CU002.outbound.protection.outlook.com (mail-northcentralusazon11013029.outbound.protection.outlook.com [40.107.201.29])
	by imf03.hostedemail.com (Postfix) with ESMTP id 823EE2000D
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 16:22:15 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=ETYKQcJV;
	spf=pass (imf03.hostedemail.com: domain of ziy@nvidia.com designates 40.107.201.29 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770913335;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fW5HSHOkJdLZAKiQHmDjD/3fav6lXuAsFHoe49uS50A=;
	b=xEdioJu30UNGwjaM3JAkzJuizz5JQWLXlZLm9Ox283pqwdZ84CHdLb2baW9KbopawdEzoO
	ukZfADlP4r/zwdPA4RmTZ1CO4t8MU/pJbdUCg6N5KlQXX/qRmpisqJ2dkT6BtSQZcgjawU
	y9Imq3HKDkDdXz8aXzw3RhW4UYUBjZ8=
ARC-Authentication-Results: i=2;
	imf03.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=ETYKQcJV;
	spf=pass (imf03.hostedemail.com: domain of ziy@nvidia.com designates 40.107.201.29 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1770913335; a=rsa-sha256;
	cv=pass;
	b=hOJDtHMHuGQMmefw4XOyq4cDfBSw8HYW2ZqH5/GesIV359Kl4Lj9U6Z0UJ52S9U53GBRFA
	/EfXOQcgrntM7Vxb2qzOGCYTQegt5FN3++oovtqZzIX0zkPVVqHugvueSDzsFUh0Jzupbi
	MwanM3t6trjrPCaauxTE3oCsb/g2JjY=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Rjq8t+zr3kTZHevCib32Hn480E8q5wbwTJFuhEtF6Y2LXyYthsW9lDob0bywcV/JhG1/jTmV1oDJsHFgei/dWIAsc8IsHmwJWgymOxuEFdzS1En/nb/LfbkyiT8Hq3GR8bpgi/otaSpnL/QgclYmEhF+WUCar3PK/mnqhPN5RW97kGoodImgfT3Jdm13BcOEHQPl3jH+C4qysi8tK0Wszp72gTj8Z7Myf5tQh3OCcZNg/CtMr7cnA5cdSZS5SU/T0tQdY2P8m8TIKhAPGlzNBmy4aGAhV8YSbEO5D8xcxaHlzCHByalWh4IuRCPoo9yUWs73UXiEwTrp7/ada4ul9Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fW5HSHOkJdLZAKiQHmDjD/3fav6lXuAsFHoe49uS50A=;
 b=N9TLVPhdZDPUO4ttfcnSu4fOSkWxnjl2/36qEhdGwDV+P/kelk6/QVOzRAuGezoFHmjL3Tvox48EixbdjI8CT8KJRxTUnht7ZLLk8xLBSFpPpA7zh/TRdKuAKlXlPkbL6mJgu5ufC5b9mEPiN+4lVJmlPG74ZTi6HjecCJU4x2YVtNL1mNxKXQy5u8LsHd6Ryuux6Z1SvBdPjuzaNVRLSPW1aOkjT2lsZpZXVU05QoLj8UIk2hNwwaeh1MkF1kn/x9YA8DXVkATII2uMWenOs+LF4kACLuiH/ojcK1rw53t70M91R3G++1djamCDjsm8pbXwijQtUBAG4UivyRIZVw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fW5HSHOkJdLZAKiQHmDjD/3fav6lXuAsFHoe49uS50A=;
 b=ETYKQcJVaBW2actomON4PvatRQRMpX+rx/FyaqwtSQXjver7YlW5V1I6gjRaumv6mZUunPOiujuZ54wgqzlf1c7M1wwJKUQPTwNddArEnCSAb/7xDjQtlvvR+xK7LMhS6a7PFX2kmzgVjXYB4QxZ4L7XTdL6HeM5PAwCUaIED3kQIf7y6/WcfnY0AP28sfeAoiJBUlmz10eEVIoMWSun5loQXbhbHBWCWtN5Q/thmAwZg/PeIhjdaW1KikFMNA7cqUBlzhHa9UlWzY8TnSLR6uHzQwlffvR4HgNXRtV+CT2NnZWdIuFS4mZ6FSUbzJnEhySvWISUxvf8GUQjMoo6xw==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 DS7PR12MB6069.namprd12.prod.outlook.com (2603:10b6:8:9f::13) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9611.10; Thu, 12 Feb 2026 16:21:48 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2%4]) with mapi id 15.20.9611.008; Thu, 12 Feb 2026
 16:21:48 +0000
From: Zi Yan <ziy@nvidia.com>
To: Nico Pache <npache@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, aarcange@redhat.com,
 akpm@linux-foundation.org, anshuman.khandual@arm.com, apopple@nvidia.com,
 baohua@kernel.org, baolin.wang@linux.alibaba.com, byungchul@sk.com,
 catalin.marinas@arm.com, cl@gentwo.org, corbet@lwn.net,
 dave.hansen@linux.intel.com, david@kernel.org, dev.jain@arm.com,
 gourry@gourry.net, hannes@cmpxchg.org, hughd@google.com, jackmanb@google.com,
 jack@suse.cz, jannh@google.com, jglisse@google.com, joshua.hahnjy@gmail.com,
 kas@kernel.org, lance.yang@linux.dev, Liam.Howlett@oracle.com,
 lorenzo.stoakes@oracle.com, mathieu.desnoyers@efficios.com,
 matthew.brost@intel.com, mhiramat@kernel.org, mhocko@suse.com,
 peterx@redhat.com, pfalcato@suse.de, rakie.kim@sk.com, raquini@redhat.com,
 rdunlap@infradead.org, richard.weiyang@gmail.com, rientjes@google.com,
 rostedt@goodmis.org, rppt@kernel.org, ryan.roberts@arm.com, shivankg@amd.com,
 sunnanyong@huawei.com, surenb@google.com, thomas.hellstrom@linux.intel.com,
 tiwai@suse.de, usamaarif642@gmail.com, vbabka@suse.cz,
 vishal.moola@gmail.com, wangkefeng.wang@huawei.com, will@kernel.org,
 willy@infradead.org, yang@os.amperecomputing.com,
 ying.huang@linux.alibaba.com, zokeefe@google.com
Subject: Re: [PATCH mm-unstable v1 3/5] mm/khugepaged: define
 COLLAPSE_MAX_PTES_LIMIT as HPAGE_PMD_NR - 1
Date: Thu, 12 Feb 2026 11:21:38 -0500
X-Mailer: MailMate (2.0r6290)
Message-ID: <96A92DE7-BBCA-4997-8943-1A28271EF4DA@nvidia.com>
In-Reply-To: <20260212021835.17755-4-npache@redhat.com>
References: <20260212021835.17755-1-npache@redhat.com>
 <20260212021835.17755-4-npache@redhat.com>
Content-Type: text/plain
X-ClientProxiedBy: BY3PR04CA0019.namprd04.prod.outlook.com
 (2603:10b6:a03:217::24) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|DS7PR12MB6069:EE_
X-MS-Office365-Filtering-Correlation-Id: e4384bc9-9802-4c2e-c667-08de6a52d238
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|366016|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?/5rTQC4GfSsUWkXRl4zijT1xSSJD+bC0n5YReKXuHrqX81RDagfD8Z0FOZMX?=
 =?us-ascii?Q?MVSW0ssvKFQNhQCDJKNVx4OZrn+Qg3o47nYcFJHaeZ0fuY2frT+MT2iHsgBn?=
 =?us-ascii?Q?dMRkmwe5Pwq9picFvqWO5/joS6hTHReiqKMM8lDwYuk/DdI89ZInff7/rngs?=
 =?us-ascii?Q?vhXzyf7abrpECQTi0WeFhNs/tPUTW8O6mULdJnGvPnu0rOsG0C2OEvI9fPe6?=
 =?us-ascii?Q?W4f6rJ6LgjDqNYljPzNIwel2lCtzrTvAVbDBFdmMc2VtEaeIvr4nSpjmRJc0?=
 =?us-ascii?Q?pAbZ2xyNpX0vxJHCmzArhcdNl3EHuONIEp0MnMCnW7rTSuK2JkwSLi8WQAnd?=
 =?us-ascii?Q?m6nqwdTfR7ZGQzrOGgiI8+UQ4sO1eFp52ThmncUGms+yYySyGTZeWGrk9l8z?=
 =?us-ascii?Q?2QfgyVYtrJpb0MMdtj3V33Qz3ZibgZ6rIGqZkN8W+pyDvLyy7IXyPBd55fK8?=
 =?us-ascii?Q?jUsi08BisODNoMM+YarfEkyGhD9k4KBuibuwnEcW3E0BglHyyT/g+jWNRiT6?=
 =?us-ascii?Q?GpCATC068VHSAStVojyfGupEemYrUahez/wKB0po6LsWo578PP1OqVemmKL5?=
 =?us-ascii?Q?QFC9fH3AlHGpabEIw/k10X0XMFsp1hMKjOnUjaD7p8hW/LyV+u+ws35f6P2P?=
 =?us-ascii?Q?9z5rAvYVEYLN7r/dLCV0KCB1Zv+4k6fWypI6KxkkCCPzCufcf3Qdkr7Vt/NN?=
 =?us-ascii?Q?PKk7BRcSFBhEOdA5HRvM4ne9Mzlzfe/y9kuOvRbucmr9y1WAQ4LH4TKV0qak?=
 =?us-ascii?Q?pfxIbgyow7w6w9fRrld3RvQMkTtEUfOnHJyDqS/ajy4UoQBxWtIkjvNSyVt2?=
 =?us-ascii?Q?7JZdVqQTLFFPzOiBL7ERCdDMQHc7Q05quOhruiX/KOcG3h9Kisp5M0gTMN8e?=
 =?us-ascii?Q?TMUYkxqtMu7NI233TDCwAbbOPdJHgJFLKyRA05RQbLkOdHEF2n+I96w+2+Fz?=
 =?us-ascii?Q?VuDfaOpcctY+DrAP7QWg+v+Z07CRi+9E1yQOzfky/fAqX8C5Ucg9dZ+QaDmf?=
 =?us-ascii?Q?cyPHAuCOIHR6ZpkRNObiWw/Xj2C3PCCmxeFCw3OahA0x6dgxJzNZHUbUeWIF?=
 =?us-ascii?Q?FOoNxNxlS2Xe2qR83VLDUdcwB18rCFGm48WaLXuT7vY5zZXPbYdH/7V9/iGv?=
 =?us-ascii?Q?hWAm1VZgsVo7Edbj2rhUkTgUA2eUsiTESj4W18KCCwdlZv3yxrs+lWXP01/3?=
 =?us-ascii?Q?zQ1IWgq9j10+akOowhYDPEVpUWXHQAOEyjvU7YNRY2QG6RGXVw4f4ZMHy0Tu?=
 =?us-ascii?Q?//ZuAAT5AOAHtvBytwughs9zROHYMT6MnOQIjycjMWOIAhuGJ34p2eNOwIK0?=
 =?us-ascii?Q?oJ4mJgD6Xcut0I0JhfQfddqfOAtjBmv0ksP42UpiwOIhxXKeg6eQRzKtUDpz?=
 =?us-ascii?Q?IYxn18FndIYQkCU6jCR9Pj/8NQ6oZ+xhNUY0n9NYo1Xs4YV+3oSAIQVzBJxv?=
 =?us-ascii?Q?VTK+/+DL6DY07ZgsDJUzkkZfNGAImZznGa44wHhsG9hK/ssG0GdqYWRNr7Qo?=
 =?us-ascii?Q?Nv05EdIbgMlrKvto8X+rvapDamnMklInn8c6EvseRtifTscsGc9/XeybsTcC?=
 =?us-ascii?Q?LDJ7/+t8BO1fpU2LcHw=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?ilIOo3VPhviOSsDWixyxzfGZRPXmtl364MLeuL9oHdf9sIl44KKciCzuj9yT?=
 =?us-ascii?Q?83cRKYyv70vdbclPAlf4BEhBwv9J6pV8aeZh1lq8PHuxroixNTrUA+CVSn1E?=
 =?us-ascii?Q?3wwkP65vyo7ujjmVJzY9tvgB+enQi+PWJnodcWuGZCYW8BzgWGhaQ+QWhmcL?=
 =?us-ascii?Q?CbSItxY9Fg00oJKMDZK/8ZWAED1FXRWV6MLSqXY56txPjzT25xptz1gVkiXz?=
 =?us-ascii?Q?QMSXO7REUETg5zmH38W0s6P/KvKPmaO8i1WgNY2OVv6HxaNXWLRYuG1Iv6x8?=
 =?us-ascii?Q?fMKJOExuNC63+Uj/Ozux9MFl8so9wUJD69k1T2A2x9g66qmkhSSMKhCg5Uz3?=
 =?us-ascii?Q?5MLGZdB6DujSnrYvlGMIT3aCQA+1JQh6WRFhblpYWmZS4bs1SN11P0k+UJnP?=
 =?us-ascii?Q?IuEQ6Ro52iBCVR6yHK32vYLXclO3imlda9Ry+3uRPN8SR229FmvrrAiOm2vU?=
 =?us-ascii?Q?rZojY60v5Ti53BbiQNx622zi6C512gTHGF51R6yQasG8nI9hGLrWXCCe/kI+?=
 =?us-ascii?Q?+wirqjFBjIwJwvMER+W14W4aEhUE8b4MNqpxcUF9vKv92hSV/u4rVCDK0nAE?=
 =?us-ascii?Q?YOid+Rer9RdWmW/J/LR+QATtWlm7gpKogys+uGuiON9uraUgscpnle/0HBS2?=
 =?us-ascii?Q?YNvEMrR/R6XlWPAjGt87Povoywc3SfXzjDSO7cxm5pe2IKbs+ReVYCAiWHx/?=
 =?us-ascii?Q?cNk/0QXeRijphbxf03rDvqefA0qIlr7cwPGTM9DsLRmMbchM7lmBv4Mjg1IH?=
 =?us-ascii?Q?Jqw+JNBwJVuTG/hIYORfkOgdFBYH6UP/GEdcDCeDwqiOQ0SuJC8PPt1DAFUG?=
 =?us-ascii?Q?1eBPMi4crQU/7DXDBThjLvGgnOUs0VUMb5lQ8zz0UVuaTxUMHpW6HPegjIWM?=
 =?us-ascii?Q?wleXFegp+JDhY6cW0mxmZgieidnJTyq/Hjal0kObsILOJ4v4sOClZHNrQlUE?=
 =?us-ascii?Q?//wQhJfprJJyIPUU6s3sdRztR1K+Yma4zTFIF8vkHoTGYCb2sKVN92Bw0ixF?=
 =?us-ascii?Q?JG4YTOdurys2+N6NoIyj2ToTu/RG/MddhV6O5b63hRMCn+T5CGAHpjMHC6Rv?=
 =?us-ascii?Q?Q1dyGYiEtlrjNuncfb1K/s6aUrEVvMgxGZ856kh43/SKiIcSbrRF7eLMmV+M?=
 =?us-ascii?Q?CASaBOiScKCpmBKlN33vkkJ0jPeNjkLA0Dug2rLjNEeomznCeJmI04L3AzF6?=
 =?us-ascii?Q?Eh17k/1TihSH5E1xrMvTxRJZO/iGKdAAnJYCz1fjt6/AkMeTePXFlfvPe/xt?=
 =?us-ascii?Q?jY8gYawDSpJlohUYCaTbJba81fDNxxa2ZH7a55mGay2L7uU+nItit7B3AcHG?=
 =?us-ascii?Q?EZasSEhQ5kS2eaFr2isV+HKitnXWVO7nv7L28P2k9cjJG68UuswEHMwlYUVF?=
 =?us-ascii?Q?b5W8BHqmI87wljAtdYi31EYLV0yT/bcEDWoGB4mjZvB6KYRoyi0gEBR3Tevr?=
 =?us-ascii?Q?panRUfU8kKdTXrWmKJTUoY08TRsQU0KS11WnkFVbDV7tM8Cq5ZCaeIjZLRnA?=
 =?us-ascii?Q?0tHVJZKFYmGWiSdft3lsTnN0M/IAW57Lauq5X02BcZHMDD/jJY+gTRbDf/nL?=
 =?us-ascii?Q?fceku3P+uErh17V5CfMPL17MWhvP6C1alFcatDAeYVqO5Zkwz30KK+HkBX1O?=
 =?us-ascii?Q?hNbSwL8BDU6QVW8OtmrwJAsKdkLzptkj59Mwsb6hkNclYO1NvKbQ4/BvYebu?=
 =?us-ascii?Q?vqqkziJVhuf2hPzfi1cAiBHgEDXDye2k3HIjmYtHBq1iRqbz?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e4384bc9-9802-4c2e-c667-08de6a52d238
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Feb 2026 16:21:48.1652
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nvBO1v3F+60i+SUdhUY9ZBZKBlFJBWZ+skT/c6U87A009auKBPuLCQ07qEQLboJM
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB6069
X-Stat-Signature: ospj5rzke6yh8zcncsegq74kjmkbecxs
X-Rspamd-Queue-Id: 823EE2000D
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1770913335-801753
X-HE-Meta: U2FsdGVkX1+ScIfiFxdrcJ5eXmmT7vNmees3SQb5bYgSIF2x7FXpuY2/fowS/0fsq4NOSzYIkn58hkx/k35reCKkOd6uzhywt6g7qQaTrg5KEBJrqb/DLnD1fDkK/xxgFbpnedTcyKSZaur3i92i7U9oonEDk1dtRfptiiYHSNXQwDLuxtyClEgLeQzELmu32jZ1ONdHmbbpG62TQq1+uXX27cOswXn1v/ilo0myEPx9f5IwjgMMhk9zCoDpN0A2tRaTE3WbXe0BIMvPHCg6ijt3vpgciV0HdqRE+HzDHSlRUzwk7XFZFSmNgUChM+seq/e7WTHO65YSuBc2x+cPqeie1Xbmi2hTQs34iIpwMjb1bsibaUvNO5uZMI1LVrWX5v3x2xO4+GzTIuPn30rp/FiLKIriE78ZlS5HncWPzEM2wgsQWFzCsVGv267v8jMTccr+/82DviTygsfIMe+e1KtRFBBnUPgnvOPT0TZpCfeq5aNKs3IjsiaP3sfpYsVOjvXxs3BIQRqCTBs3HV/qeToLUuXBTw6oM6FaPpf43FxS7rIi6dN85WuUpKr/krOr6gAariKfqs8G1Yz/A8d8st3gQBoGsTCJXnoDAfbc/tMAK/NCZLSNTI9Uvq8Cz1W1iBQyYvv0ICTbT2oSkdgLG0h9PERIjJXws2oU206ZWnRQNSdqD3E5TNLTUbpIIAVGGRzBQwsjx0tLeaHyrFeVJqcAzdMxbthscjSTpDt+OWrpuzbLXtW4zMN47ibXBDBVYFMkzjbEf67TO8+kV1aO4fKuDqjJlAJLp+9mXy5pOVimx1RH//EX7GjuT53DCdWuxT1aeYbBaql+R0WtHF9JRFEiTScSIvDalLaZ7MSOFgtZpmdE+epqovNUXQNj3daacC0IvOwVZRlHC/3iRhkMcUa0l9hlQvxXNNhInTRWOeaOlllxldnsBXv0Nd+YnsrU0IkSinnCeV2b87wi0t7
 OZ2Nq6e3
 IrK3FJS2t9wOhb2sysC4YCMPahMV7bk7pniPKw4l8qu1u27Ir/E7qG/2vfUp6MF3t7Sv6I7a/F/OL8NrlpjJGnlcyn5rzQujcYMICTPjJZAv+H69vAW6z/QacLFbDt5OIf9+WiG8H12Av+JTP7em0gZhuuZ49E1IWD0IcORd6CU1RLEMXgQ9cOPZOlv91hf3UImhP5hqSIe8jyZHfAQqy6u0RPsooE5e+XIiIhYx7vhs0y/srA5UOJoVvOTnnRmX7WWjto0PW+ryHvSlORdQLiTND2vJoatixnDbD+WHWrWPAaku5rlDeykZIW8s82HUW1HFLs6bBm4nORXvTJkgmVPHB9lpl9Mruek0Djwibq9J0XypBsuaZJZ618Evi8ex+pEgkagcVFCwvKCAosCHHlLRRQtoKG6kREHC4EtNP43aVZCVCJ5KTbTT9FsLKma6yGXtVtlI7WTnCLvQQQ6fMxtT6BiF0Ct2hJ/Wxo1zUcvDmePI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 11 Feb 2026, at 21:18, Nico Pache wrote:

> The value (HPAGE_PMD_NR - 1) is used often in the khugepaged code to
> signify the limit of the max_ptes_* values. Add a define for this to
> increase code readability and reuse.
>
> Signed-off-by: Nico Pache <npache@redhat.com>
> ---
>  mm/khugepaged.c | 15 ++++++++-------
>  1 file changed, 8 insertions(+), 7 deletions(-)
>

LGTM.

Reviewed-by: Zi Yan <ziy@nvidia.com>

Best Regards,
Yan, Zi

