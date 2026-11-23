Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8DD93606A31A
	for <linux-mm@archiver.kernel.org>; Mon, 23 Nov 2026 05:52:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=ubRqVjdo
Received: by kanga.kvack.org (Postfix)
	id 95DE06B05B6; Mon, 23 Nov 2026 00:52:58 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 935AE6B05B8; Mon, 23 Nov 2026 00:52:58 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8246E6B05B9; Mon, 23 Nov 2026 00:52:58 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 5B8536B05B6
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 00:52:58 -0500 (EST)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 3DBCB1A07A1
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 05:52:57 +0000 (UTC)
X-FDA: 85465315194.23.FC06740
Received: from DM1PR04CU001.outbound.protection.outlook.com (mail-centralusazon11010049.outbound.protection.outlook.com [52.101.61.49])
	by imf25.hostedemail.com (Postfix) with ESMTP id 656F0A0007
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 05:52:54 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=nvidia.com header.s=selector2 header.b=ubRqVjdo;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf25.hostedemail.com: domain of balbirs@nvidia.com designates 52.101.61.49 as permitted sender) smtp.mailfrom=balbirs@nvidia.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1795413174;
	b=KJIqO9pMmOh12p+el4d3mgpRyJM6BtfY3Pqu7JcYs1d2NgcReRTmFFZFWDdPkgAFJgiAfI
	WgxzbnI6WkvDKGOED6o9V+jJXoVe3GoHglpIqty5CJf3CvA3O8cMjmFCulndInnHSCtJi4
	vgP2pqHKI7LHRoHva1P7qmR0MI9wJUw=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795413174;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MrqRTHNK2gC+Cpux2diFWuleGl1Gko1WQhJIOUlu2bY=;
	b=XmtLL9ncZHAkfF+Iw9EAnrI6aAaCGQZc5c/GEzrUCXbQRbVISkcHv1nmS8+ST0YiwsrwD/
	DmGrPr8web6q0MeTivaOqSjWS1OPvJA82bq6luTJCmF95AHrCSo7ve6WSbJXDQ6heUE5Sw
	WhPz5P/XvTGPQaAgzIwN4yBrV6/ygT0=
ARC-Authentication-Results: i=2;
	imf25.hostedemail.com;
	dkim=pass header.d=nvidia.com header.s=selector2 header.b=ubRqVjdo;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf25.hostedemail.com: domain of balbirs@nvidia.com designates 52.101.61.49 as permitted sender) smtp.mailfrom=balbirs@nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=T1n2fGlgOtQsEszQrmh9cUR+98GLJnj71Ub3DJiThqAi7Pgh3q6SOtRgzgycJFGtJz0J0xvA6m6iYj6bQW9827z/oYbVMCXSPUjUju68sa1UeohjUoxwnqeHxMzG3dhVsz2CvpEDZyboY3RBDbcFQKPwgYrr9EZ7zIrZz3/5/r8xb371kZtSi02yqkxGbuA8o5DhimW3Xzkgjh5ALSKxAjRbdnwMPa2LWCcjq0ILAYc2SIPp1/bwaKHGUTYLZDwTBa1lp9AsSrkjU9MOZvBVIjBhf6hQqr/llUQ9m+DyXgVFhpjTSr62i56++xg0PKDsZxyNlQhB+/Y3ffvm4/TvAQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MrqRTHNK2gC+Cpux2diFWuleGl1Gko1WQhJIOUlu2bY=;
 b=j2B3dQIMNlL/wdiD6jwSTAfmC1b52Fi/+EUlgvM4Hv8ZrIB/N1xsIc2R/PiBaUOSCKJPsg+ad3m9Y668n/WBhSmHVyDrztKMk524tT6GIAmeP0JwZapItyXUDKOJYQ9iI/CmJ8VEGI+pi9V45t5ZuD/ERM+WZ4yQFWyLor5BeW5dZwyqFSMpngiOur5u+t3sxeqLjUvEr3YFskm4oTql0QwwQK18pcQDw8WhrgKuUEn3Kv0t6KlKqDxHIyweX+FrxkQckszVu0Tc9RM6EbIwCikhuWhOrYbm9NfxbIIm0IVDCOOVXpvuvwZ7d3DDtxx1nQBNDAovvGbZcBeYGqHCDA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MrqRTHNK2gC+Cpux2diFWuleGl1Gko1WQhJIOUlu2bY=;
 b=ubRqVjdoo3J9fTuGm5zosNiKdgTkhWzxGnKoqcq58NfJNuri82M9ViUGt97NvIMdBswIeTCzHTefbZzvzNiYxAsQwIZB7YrZDZTvgagbvc+Z0gLR7nDO1keVZio0YAYxkxIP6oLBJi111wW/7PC38FqsWH31HFQmRMx5aQyu3w+FVWPMZjkLUnt4kgZj83/CDxCnSJawJ8qroozpSwO+MLMB1P8Ey4l9JYos8hqrwdrkoCTak2Gs3j1uWoA5eWb8/3hnUyzV3O7C7e6r+9AAXRsgXnfMUB6AVgsxTlZi0+3vpDqtpCsZq16TxTwGfBcCoJS4vg/2CU96gxexAKwJ3w==
Received: from CH3PR12MB9730.namprd12.prod.outlook.com (2603:10b6:610:253::9)
 by DS7PR12MB6238.namprd12.prod.outlook.com (2603:10b6:8:96::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.639.13; Mon, 23 Nov
 2026 05:52:16 +0000
Received: from CH3PR12MB9730.namprd12.prod.outlook.com
 ([fe80::843d:c1f0:b2ed:4128]) by CH3PR12MB9730.namprd12.prod.outlook.com
 ([fe80::843d:c1f0:b2ed:4128%4]) with mapi id 15.21.0639.012; Mon, 23 Nov 2026
 05:52:15 +0000
Date: Mon, 23 Nov 2026 16:52:10 +1100
From: Balbir Singh <balbirs@nvidia.com>
To: Aveline Noir <jm5905938@gmail.com>
Cc: jgg@nvidia.com, leonro@nvidia.com, akpm@linux-foundation.org, 
	airlied@gmail.com, apopple@nvidia.com, christian.koenig@amd.com, 
	dri-devel@lists.freedesktop.org, Francois Dugast <francois.dugast@intel.com>, 
	intel-xe@lists.freedesktop.org, jgg@ziepe.ca, leon@kernel.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	Matthew Brost <matthew.brost@intel.com>, mm-commits@vger.kernel.org, mpenttil@redhat.com, 
	Patchwork <patchwork@emeril.freedesktop.org>, SeongJae Park <sj@kernel.org>, thomas.hellstrom@linux.intel.com, 
	Vlastimil Babka <vbabka@suse.cz>, ziy@nvidia.com
Subject: Re: [PATCH] mm/hmm: account for subpage offsets in device-private
 PMDs
Message-ID: <awObsp2ugvQZ1JQV@parvat>
References: <179342234355.4.16705453209886955762@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <179342234355.4.16705453209886955762@gmail.com>
X-ClientProxiedBy: MEVP282CA0075.AUSP282.PROD.OUTLOOK.COM
 (2603:10c6:220:202::15) To CH3PR12MB9730.namprd12.prod.outlook.com
 (2603:10b6:610:253::9)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB9730:EE_|DS7PR12MB6238:EE_
X-MS-Office365-Filtering-Correlation-Id: de5e7853-6e43-4473-a3af-08df4925ed60
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|7416014|376014|10070799003|1800799024|23010399003|6133799003|22082099003|18002099003|11063799006|56012099006|261028144727099003|261026121527099003|261026140227099003|261102123227099003|261022075727099003|261022105027099003|261021123027099003|261021121427099003|261009223027099003|10067099003;
X-Microsoft-Antispam-Message-Info:
	QpiQoDrXu5FqpZCcFbs71ZJDka7HDyCHkU/2wVusAIG45zHOdR6nNYRsThgpBjRQjED1DgiR6jo4Sqw9LEFh06v/GR5tCtKjRhZL2K0mQ7f93ER4hvMhZe1ffsf1ahVw7x2YQmfZbLT8SSqA9v3X/ys9DaUhcWs0EhA9/BZKMmLdEm8S71IAIlP+QO52uf9HFah4fma1BMxH3TYDu28TSGi03ozeKorMu5nsI+RiLqsEY0MznUnuMd9kVNfIZbi/l0UXstBTK3dlcWWO29C4JmXZLUlGF1JXi0u4RknnzVaawb7AkSkyYdIQ99xuAprRm1SLrkqTfz6D98ma/WZCyKste1kGYG4KFClOjBmrZerEhucv0GIiFhb0fQGi4qwcKIyIgOe/1i/npmqJIDmigWxODZnk/WFZlVJ91sUuRLYSq3RPJo8uqDaaJkIBxyGvtpNPTvKzkTW7qBYm6hNycBkUvmm+GnSLAuUjeYrB02zRCDFdqXjxDX14Igntq+ZpuRYxqFflGjvImSw4tNOGMmmZ+8ROC3teXSQBbpN8FhU7vt6lm9k65Bjx1qbsSgrE7L7ZzlwyIZFXOebT+tMdo1m7K7dS7yNup+DAO9N085RI75eQ83KR+WtlHAZlwWYYzj0weB2pGzaZGIvvtjjhaaXMZ/I7Yj/5wZhlwUsY9AY=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB9730.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(10070799003)(1800799024)(23010399003)(6133799003)(22082099003)(18002099003)(11063799006)(56012099006)(261028144727099003)(261026121527099003)(261026140227099003)(261102123227099003)(261022075727099003)(261022105027099003)(261021123027099003)(261021121427099003)(261009223027099003)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?aWc0UWJWMjltT016SDVxT1dVQlpZMFJxVHZQQndtU0NqckJreUNMeUFQK0FD?=
 =?utf-8?B?bHh2Mzd4RWFVUDVFQ0N1R3NUTDl5bzNBbkc3TkhDSHBKS1l1aWZpbDBuaEt5?=
 =?utf-8?B?bVZkR0JzQWJuMm5WVlVFdmZhSDFScDBod25OK2gwUEJXNzJoa2wrb2hWVWlB?=
 =?utf-8?B?MHJ6UUhyK2czd1NOVlBKM2Jobjh1UE0rV3JxTUFpekEwRWxjbis2OGlaWTE4?=
 =?utf-8?B?SllJeUJpNkdVS1RPWnltTXdHV0pOVmJ1RmxlZlRFQTF2ODZKRHV2YVNyMEty?=
 =?utf-8?B?N3VCdmRINDFpOXVKcnZFdlQ3bXk2eU9QMENrMk42K0pWaEJ3ekd4amxndDRL?=
 =?utf-8?B?T0NkMFRuVUlxL1JsblNoeHJUVkxFOEg4ZFdMU1FCRzJOalFHMjR0clpXMnZh?=
 =?utf-8?B?QVpHTjY0OEUvMEY1Rkg4bzl0OERrVFZJRTFyaDNDNmlLUU1BK0ZmT3FlMENj?=
 =?utf-8?B?QnVTMkpRQzlNbFhuQ1laaG5aVHpMeWJNbkRWR2hzK0dQSEtBN1ZQWk90MUlW?=
 =?utf-8?B?NS9xN1ZuQytYOEVkYWpoSnR0MmU5eXZnVVVwRVF3OFoybUN3THRzT29RdUtu?=
 =?utf-8?B?N1JpWTJhd1Rtc2hZUkRTb0NFZXVaQ21DcXNqK0JTVDNWVERFdzFnTTNDUXM3?=
 =?utf-8?B?Ly9ZUEFEcmlyVXFJRjZPS2kvUVljcUZUT3ArL1AyOFVhSlNzRUhuVk1Yamo0?=
 =?utf-8?B?T0lrcG54c2dORCtoTzNiSG9FMjNHV3NtOVd5cU1oQjkzQ0NDTmdnK0RQVkt2?=
 =?utf-8?B?RFhtSWs0Y3kyTmFaUHA4UVVqN2JKaHlETVhFRzRNWWovZmp2b0tDNFkvSjVP?=
 =?utf-8?B?VmxmK0tDV0lOVVhBdW16eW5JcHNjNnBlUjlBdjg2NkJpaU5rbzZXZ2d0Rm9i?=
 =?utf-8?B?c2sxNGJ6V2NkSE5xUTJuZTNUK3V0emFVQzd2L1o1b3A5Z3BaK3ZmcjZOdktW?=
 =?utf-8?B?bU4xZGZXMXo3bWh6V0FHbmVXbkxJVjJtRmRTVlhGRm9UbmZ1UGg1dUlLOG1T?=
 =?utf-8?B?cmRicmtlWTRURVVQVHlQc0NNNkU3SWdhRnVadHRvUzhmSzJuQkNRUEZJWC9I?=
 =?utf-8?B?Ykt1bWlXV1l0YmNEenhFaXpJZ2FEUE5KZ3MyZU8vaFZFS3h1UVgya3VQejBW?=
 =?utf-8?B?cEFrekJvTFdxaDlWNTBacjVsVkZOSEhSUWpSM3dOdnRlaEo3enhWWEt2akRx?=
 =?utf-8?B?UldqUFZNYlJsOTI1SGdlQUJqT0d5YmJPRGozalVhQ3hpNlRqd0trNEhPb0Fl?=
 =?utf-8?B?ODlqUm1DVjQzYTJuazJ1T2MyTmpCR1dBM2ROMmllQzdWTmZOU2s1Q0hYWnBw?=
 =?utf-8?B?dk5NWTFhWmxoR0grU0RVd2ljVyt4UG0xV2xhaGdXekVXL09qWGt1ZnBYQUxH?=
 =?utf-8?B?Q055cFhRV043NWx6SFJ6MTVpMVlZV2hCTHpmd0prNVh5cERlS01QaGg4c2c4?=
 =?utf-8?B?cE05Y0Fxc3JXUlFCdHBjcC9KT2VWdUVuK2dOSGhnVEVhMGV1Z24yUVJvR25H?=
 =?utf-8?B?b20yK2VSSGsxeDVXcmR0UGpvbURpV3l4REVpVDZndkxBbU5vL2t2WENWSGtV?=
 =?utf-8?B?WEpZRWUxLzNTMGljMU5vaG5sMFdHR2ZmeDlPZjdjRnlWd0NuTVYxbVRKQ3Rq?=
 =?utf-8?B?VHppSUZsd3JocG1BUWs1TkczdUQreEhNTjhkNDVONGllL2VSMnFlbVJ3OVZz?=
 =?utf-8?B?TVk5b3Yxcy82SjEzZkZtYkFkS0JMbXlaamVaclQvQ3Z5WTRScEJoMkw5Mk1m?=
 =?utf-8?B?dnlINmUrR3gwMEE3bHZkbC9MRm4vQmxHeGkzK3hqZiszdnk1U0ZleFdwRE9W?=
 =?utf-8?B?RUVtZ2xVdWdoUTd0N2E1K2hrekFlZm9CNHVhc3pnTytjMThySXJZQUVIWlJv?=
 =?utf-8?B?YnQ1anNuTFZxc1dtTXZheUtyb09rNlRwYWxqY01UNnBOeEwrU0llL3VYRFl2?=
 =?utf-8?B?RFFQYlNCMTF0ZFRLQWJNL3cvQlBvL0FrNHZIK1VsZWNyaWZTbHNENXpwYm00?=
 =?utf-8?B?TGFTREhWbUVHMnp3dFZtNUNPQnBYa0VyNUVqaHZqY1BORUdnNVZ1M0dvQ2c2?=
 =?utf-8?B?am1DMXRQZ3I3bTNWMUZsb3ZwUU9taWl0UjYycVRLRjlMVTJXMHlzeGxMK05v?=
 =?utf-8?B?Y1Nxcy9SMU5CTDJ2elRONHVYU1oyL29PNVluZHRIR1Z0dVBFRXR6UkxmeTRM?=
 =?utf-8?B?YjZqYW5MeDBNMFpEOWtxRXI2UGVrYjNVUG9SbUM0M1o5MGhKaWJYQ1BWVExL?=
 =?utf-8?B?YjhrSVc0N0crS0t3cG14OEJ6dnhycis2Yk9BZlRrQWI5eGlxdFQ5dmFuZFBv?=
 =?utf-8?B?UDhkaUsvVjFwMitNeUR1KzZGMEdzQUxuelFqWTFIWWdVbnhMREhIeGV2aHNQ?=
 =?utf-8?Q?k0DAw4G0agMfotAtUBfComQfgo6lWj+84VQcBy09yD/lE?=
X-MS-Exchange-AntiSpam-MessageData-1: bMurxbR3w5vFpA==
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: de5e7853-6e43-4473-a3af-08df4925ed60
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB9730.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Nov 2026 05:52:15.8116
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Ovv1snhNfZJW7St6ni4xDtp/QbG3dmr7PBr+l/zQTvW7lNc04U3hcnf6FcyWVhccXJ2D+5gNQbZQoJCBi+4rsA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB6238
X-Stat-Signature: koa7bbiet59q96dgt7b56ucn1fnzrgeu
X-Rspam-User:
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 656F0A0007
X-HE-Tag: 1795413174-297514
X-HE-Meta: U2FsdGVkX1/YDa70bnAb5wGzWVqlzqz+vVdWj/t6IGcogRcoSmweMU6n01a5huWX2ExUwIs4ZeETCZS+uV4uOwoFiuZC3V0PLCfbaSKw0IaJmixmqYPEg3E2MjSUakDJ4Sj88hlrp68rfZWMopk0hNbQu1yviXfAT6gq4jtBo6hukvlic1ET3VihIJoummdd1rT60xvsuKuyUsVsecnzdHQNfGSdeyAEFMfqTXa80eE9DEcCvJTyRlTPp7A4mu9mYS0h0s2L9EGtmjxH3n6B1CgGONTLRFdZJQAtSTgVnHAjYN/1jE47wnK22wGdTDFaYYLuQRXioe5qYksmuRQJPltFd/tDVGSZJCt+DvfR6jrtvtDUqnt0J/KgqeQ0tqxPzbUMSchp9ptghp+Znu7CtFRjuyPiNLPKCDZINEVsuylIeIlvh8/guslEX1MPILiQuvMhSarek8oksgwHu7ox5jUAAvtFLEDEzqAK3cMBRsotLI1sOIwbW1JM5nd3kg6VqqVqB/oT8nrJY1LyypnfcJITLFClJ4Q051VSxvC8waA5o1XpiFgJsQiACTV4RCFFidAtsnP5yugjCQGk/fNMNq2MlQefxl4RZWbO5oGw/rgJOg/rPzg3AnqodURDVotNbN6xsjcHql/8R6PZYAbzQY9ef8XJu4YLbVD6yzXOIa9EFfleoCdQ80OhcXrJPlGRdZ8DCUqTJ97c3MBuUkT8pSPUYt/zLT6hyRYsA58/bJDC6DSBe8Lm5L3dpBG1pYObNcRt/qwcLlA0GSLWx/eQW86oDuNiWw9WISrBr1baAJblKmQXzNfEu/K4hkWwLY44cfTE3wuVCdpaYmg+ceHpqRfWjvSXyjw+gEigQHziEIWDQaVwo44ryDN9On1pCq/36u4k5SzHnYvrEd5uCK6lu78np2tCHvfNZqhucN5loUzEZkX+vxn5L3e0njDadPYStPtydnk5upfV8CT+YoB
 FmoQdIYO
 8W1IB1YxIo7thRKx9e2a7TlaTm2+GuzzuFShhismLNFt3KUqx9iPxrj71HXNmYmlMvF5c/Jzw3V8ycqT5DAHu5LBN4sFfEYXbKR4LdS0s2yogj43uniruNQPB82pewmXLc/fYJGIAhL7UAl41mzR6xj8aY9lp/vO5B4v4RLieO+XOm+WcPWouG0W2arjvrrNBWPUt2YSJCELLar+ZlAzHtH96briJ4ohtW8NhKqEcbsNFL4BduGELjf1IkoNiD6AuwTrG/5Kk6B8+iq0b3zxV7uRQE0mHKGndvBuF8BYoL+AYQfzrYCUk3qCSrIpwCIpynh4jGcdwIxNWwXgLHqzUayOeo/fRyX+uiDtvqUuwJYnhcoV3SjHljU0dCp40N4ldQHyDDRvZPCkoesdRFnXT53dXz+gizXoIICPcc0HlA7X0+m0Evs7J7X6klAfyIc9zYWcnvgj8aLpBpo4FrUhsI+fcy5gzXEUQIrEbl7+LUrthm77Iz/1rxg/hRiBHw6Q4tXH1p0kXni9aAryvATadSjNjYCRvPTjq9iIGvn1w8OYZ9vo66OEh+blaOO446MT6TDBWsNrGjJ0I2pWqhcaqssraAjETeyF/a0op6ySQXYtrxpq3ETyAtrO0OVFUQoe0IIK/U6k7QvXAtAI7tulRjAjZghA6NCqz4H1I+h7csxzKswVUVx2I5T+PIdKnHnIaSjUNenIh9Y9snWs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Sat, Oct 31, 2026 at 03:07:58PM +1100, Aveline Noir wrote:
> When a query starts inside a device-private PMD owned by
> range->dev_private_owner, hmm_vma_handle_absent_pmd() still fills the PFN
> array from the folio's first page. The returned PFNs therefore refer to
> earlier pages rather than the requested subrange.
> 
> Add the query's PMD-relative page offset to the initial PFN, as the
> present PMD path already does.
> 
> Fixes: 10b9feee2d0d ("mm/hmm: populate PFNs from PMD swap entry")
> Signed-off-by: Aveline Noir <jm5905938@gmail.com>
> 
> ---
> Found during a synthetic test_hmm check of device-private THP handling.
> Tested PMD-aligned and non-aligned subranges, PMD boundaries, split
> PTEs and fake-device data accesses with test_hmm in QEMU TCG; all
> executed tests passed with the fix. No real GPU testing was performed.
> ---
>  mm/hmm.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/mm/hmm.c b/mm/hmm.c
> index 2f1e98c6b644..e89f140d3e5c 100644
> --- a/mm/hmm.c
> +++ b/mm/hmm.c
> @@ -355,7 +355,8 @@ static int hmm_vma_handle_absent_pmd(struct mm_walk *walk, unsigned long start,
>  	    range->dev_private_owner) {
>  		unsigned long cpu_flags = HMM_PFN_VALID |
>  			hmm_pfn_flags_order(PMD_SHIFT - PAGE_SHIFT);
> -		unsigned long pfn = softleaf_to_pfn(entry);
> +		unsigned long pfn = softleaf_to_pfn(entry) +
> +			((start & ~PMD_MASK) >> PAGE_SHIFT);
>  		unsigned long i;
>  
>  		if (softleaf_is_device_private_write(entry))
>

Looks good to me!

Reviewed-by: Balbir Singh <balbirs@nvidia.com>


