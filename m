Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 92A42CCD192
	for <linux-mm@archiver.kernel.org>; Tue, 14 Oct 2025 15:52:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E74F58E0142; Tue, 14 Oct 2025 11:52:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DFED18E0090; Tue, 14 Oct 2025 11:52:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C787E8E0142; Tue, 14 Oct 2025 11:52:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id B21FB8E0090
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 11:52:15 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 8421147829
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 15:52:15 +0000 (UTC)
X-FDA: 83997161430.07.77695D4
Received: from DM1PR04CU001.outbound.protection.outlook.com (mail-centralusazon11010064.outbound.protection.outlook.com [52.101.61.64])
	by imf01.hostedemail.com (Postfix) with ESMTP id 9EB8840017
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 15:52:12 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=URoSFL5i;
	spf=pass (imf01.hostedemail.com: domain of Christian.Koenig@amd.com designates 52.101.61.64 as permitted sender) smtp.mailfrom=Christian.Koenig@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760457132;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Wb87C8P1aFLeHS9KhL4fY5ErnnSuAwwUfoUF+W4y6Sk=;
	b=WVNYKpOa8VTDUA7ZF+WBBaTXpwUyFuEWDfKGaWByKdRgiG3gOpP0RRQmgVstZz+e9W9Jcb
	y8ahIADFe505c8WBNPZ6dxVrkuGZRJAq+Yyd/Dg0lfLU2KksAj1UbJHb15JUzkhO32qKHA
	uI+9U3a6PmeWRqKq9CfE+D3OP1ZxY+k=
ARC-Authentication-Results: i=2;
	imf01.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=URoSFL5i;
	spf=pass (imf01.hostedemail.com: domain of Christian.Koenig@amd.com designates 52.101.61.64 as permitted sender) smtp.mailfrom=Christian.Koenig@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1760457132; a=rsa-sha256;
	cv=pass;
	b=NPyLvlZ99cvjH4N2VUNQZrn6JHhWCnJH5fsHtYt5CbBj29W01spQr+qXVEF6dvMJdjZV/C
	lyfmAHNE0LVAS2e+hX7DP+UhTtpt1xk/g6snhdvwpHasZCWWM/rOjYIAp75dG/YeQsy62W
	no1w5fXzZfvcDMH1K4/FnXMwJgNWRpQ=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=mxCMl4dJtmceDlv0dp8BGKJVImTvI1Wg6ASevW1fSake3DgIA5TtuvwBie9/pcpMw4PadDyipeGDUEfBRcugEhT9pV/u5mAR1/1M1sncx6D/pvHgkvpohj5276daPrxobsXg8b7BzdG7mSJeO/9d/8k2qwgUfTsCzOrGWJyhDIkclKdNqs81Bvg/w/G+8HuFVlYoAdwJ7LSI7r3u7SAJwo+Gq7ot+rzWMWmupPAVV8maKx7BRQ5yIE+BHeTuI0bEKJq9dzq4p4CSzAk1RxP39fgPZHT6laB4/9SHp4BjyMEKbKEGryqZONOwNHgsI4olt0D++raumKsVK1fdYzZmQQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Wb87C8P1aFLeHS9KhL4fY5ErnnSuAwwUfoUF+W4y6Sk=;
 b=Uq5JXDWyvXPlzz3x5yq9kO6PKDNGk/uRITuA2HSqZkA8vfoQS2UWFGJBGLAE0IzA0s1iCD0h9+t24oJAVks7mud8ym0f+X7PeSWx7RZBBZES5JgNic3RE6wihAnPfb+pTQx1N4jFN8N5Zc/HC7nZ/kIcL+MOtY6ruL7jrX9bovHSMF3RGWLIcE9xZj+WQZZjz14kOo6izWUuySrZWscgDaH41uRXchSAnw3d8AitoDFxB0JR/2UMC7hMmf0yvhhSzIoV3/ARyMICuotc1m99ZH89IYm7r/XAFIvNxTxTjgm+to8cCRarudYF8qrI3RNohZzDAnr0uR+DEeShFgDPpw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Wb87C8P1aFLeHS9KhL4fY5ErnnSuAwwUfoUF+W4y6Sk=;
 b=URoSFL5idowJN0PmjfclTB5sf2Xo/+vRyKdEpYIIkzn+7M2QXuFE7+0bXlVZseACqKqwHus6cxuqyaDs5N85aT74Xh5Wv3DbXSz49M0ZXwlb34yHAyf7bcWP9IJi/4kReUZsaSLIt9+Uf+PbZmN6uyv3o9FSq5LqMKjpb+wMYLU=
Received: from PH7PR12MB5685.namprd12.prod.outlook.com (2603:10b6:510:13c::22)
 by MW6PR12MB9019.namprd12.prod.outlook.com (2603:10b6:303:23f::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9228.10; Tue, 14 Oct
 2025 15:52:08 +0000
Received: from PH7PR12MB5685.namprd12.prod.outlook.com
 ([fe80::46fb:96f2:7667:7ca5]) by PH7PR12MB5685.namprd12.prod.outlook.com
 ([fe80::46fb:96f2:7667:7ca5%4]) with mapi id 15.20.9203.009; Tue, 14 Oct 2025
 15:52:08 +0000
Message-ID: <97da9924-9489-4d30-a858-8ee5c87bc031@amd.com>
Date: Tue, 14 Oct 2025 17:52:00 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] driver: dma-buf: use alloc_pages_bulk_list for
 order-0 allocation
To: Petr Tesarik <ptesarik@suse.com>
Cc: Zhaoyang Huang <huangzhaoyang@gmail.com>,
 "zhaoyang.huang" <zhaoyang.huang@unisoc.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@redhat.com>, Matthew Wilcox <willy@infradead.org>,
 Mel Gorman <mgorman@techsingularity.net>, Vlastimil Babka <vbabka@suse.cz>,
 Sumit Semwal <sumit.semwal@linaro.org>,
 Benjamin Gaignard <benjamin.gaignard@collabora.com>,
 Brian Starkey <Brian.Starkey@arm.com>, John Stultz <jstultz@google.com>,
 "T . J . Mercier" <tjmercier@google.com>, linux-media@vger.kernel.org,
 dri-devel@lists.freedesktop.org, linaro-mm-sig@lists.linaro.org,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, steve.kang@unisoc.com
References: <20251014083230.1181072-1-zhaoyang.huang@unisoc.com>
 <20251014083230.1181072-3-zhaoyang.huang@unisoc.com>
 <87953097-a105-4775-88a5-9b3a676ff139@amd.com>
 <CAGWkznGN7W-txq_G+xpZ6DtH_1DNorYc=CxqUjebo7qfB4Sxsw@mail.gmail.com>
 <ecba7133-699c-4f3e-927c-bad5bd4c36a3@amd.com>
 <20251014171003.57bbfd63@mordecai.tesarici.cz>
Content-Language: en-US
From: =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>
In-Reply-To: <20251014171003.57bbfd63@mordecai.tesarici.cz>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: FR2P281CA0051.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:92::8) To PH7PR12MB5685.namprd12.prod.outlook.com
 (2603:10b6:510:13c::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH7PR12MB5685:EE_|MW6PR12MB9019:EE_
X-MS-Office365-Filtering-Correlation-Id: be49e4d0-fd5a-4a5b-afe9-08de0b39a144
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?ai9DT04xL3F4SDNIK0VuN1lRbnYyNlRyOFhXTUdIUzI1SGRLODE1UkpPWVA0?=
 =?utf-8?B?aGRyMHlJV2NucDRoMlcwQXRxUmtiR1N5bDFqL0VCbTYxNFpGNFpzOVQvemdm?=
 =?utf-8?B?SWhaUmhXRlVsUjBjQklCRjdsb1c3U1R2UXlTOHp4ek8vSldKaWpSbUluamNx?=
 =?utf-8?B?TWxHN0V2ZGZSUTF1SGhZc2pTd1llMXlBL04xeWRSdEdlYUZXNmxzMm9FTUgw?=
 =?utf-8?B?U3V1VmFWWTZjZnd4VUZTeUpWUGZQNWpmNk9jRzNqTFg5MHFOdVFHSEphTnZ1?=
 =?utf-8?B?YVBQUUJLNFg4U0lPRTdyVUZXSEpQZU9uMlY5Q2VSQWp1WXZwcDNBcG9SOGY0?=
 =?utf-8?B?eWgwbmptaXE0UERoU2xOMlFLdkUyS25US051UUJmZFZMZ3hndEYyUS9kMGhL?=
 =?utf-8?B?dHJuamdQdjdGYy9OUlNYM2tZTm1HSjR3a2JxS01Dc3I1YUNpWm1nYWFabmRJ?=
 =?utf-8?B?N2NsbHM0bzdUeVZFdm5BYnRXMWdPdnNQZUVaclBmamp2cXBFaHpGUXZmdU5k?=
 =?utf-8?B?cXBQbVBXSGlJaXpidHVvL0g2WkVCeVJEN3NaS004OTFWNGR2VE45Mjd4R1VV?=
 =?utf-8?B?RnQ2VkhwV1BYd1Mvb3d3WUd1Y05BVzYzMmpRdTJQL2E3MHZMOGNsV2VMVHpl?=
 =?utf-8?B?K1RiTG1xMHNkVFZ4S0RqR1Nzdjk4Ync5Q0o3NEI1TktjLzBFckxYdkdtYU1X?=
 =?utf-8?B?TjZzdVNRbHFWYzhpR05LWE1BQTQxNTI0cndRenBxQUNWQjZQK05RL0Y5aXNW?=
 =?utf-8?B?UDRaR1czRDhXT1RER2JxUlNXaVhsdVNWdUZrREJEZ3JLMmlhOE94ZzMrN2hq?=
 =?utf-8?B?cytoNnlDRTBhanJwWDlWWkl4bEhwd3hPK3cvY1VzZUIzTHZ6VnNJR0lvbmR0?=
 =?utf-8?B?M2s2cmFaVm1ZMXhRTFZFVkNrSHhmSS80bGI3Z0JDcFBITUNFVSttQmNIMW9O?=
 =?utf-8?B?eG1FQTUzaFB2c3VyQ2IzNVZ1WXNrSVpPck1wV25LNysybkVSdXNPU3pKUUJz?=
 =?utf-8?B?d1Bab1NXM09PN3hTcUhlT1MxNEhlQ0NyV04zOUdSeWNBSVk0SEJxNVhBTXp6?=
 =?utf-8?B?aitRN3lLbC9kM1hibDNnRDBNQXIrSERCN0FtVGQ5VE1udlFEa3pXK3BFU2Nl?=
 =?utf-8?B?R2ZlU1ZlUkZTUVNxa1pDNzJOaGEyc2pBWTQremtCN2h1TVoyQ2YrTmtZL3Vx?=
 =?utf-8?B?emxaU3ZsWUt0cFFXa2oxR2lZUU84U0FTZ0oxT2dZcFIwOUF2UzlaRHpTQ2Iz?=
 =?utf-8?B?SUpTUS9uSEQ4TFBLc1dzRjJkSEJ6RjhESlJpTWs3TEk4bWcwZkhwT3c2alg3?=
 =?utf-8?B?MnpLaVJVMys4RGUyKzFMWlhjZGJqN2pFc05wQWVsWEppNWw2R3M4YllrREdZ?=
 =?utf-8?B?ZWxtcjNycVVEREVXR2ROMVRhaDZrdEh6VXMyUnp4VVhhb1ZPaWVjOVpTUDNt?=
 =?utf-8?B?UFBMTnRGUFdRWVkva1M5eVBpYjhZNDl6Q2lDY2ExME4yRW9qMno2MTF6ZE5y?=
 =?utf-8?B?NmY5dkdsQThjYWViOWdiNWV0a3JvcDFaUzA5ZjB4VE05VUJqbVluRWFiRDJp?=
 =?utf-8?B?TVQvb1lBb0libjVZdDhpTzAvKzJUZVdXVTlWQk1hWldSNHZNRVB5RGxhT284?=
 =?utf-8?B?UTJWdzE0RmdjQ0VEN3NILzFKSHpsNG0zd3lEYjBkZkNUVXdYNnAvc3JObkxi?=
 =?utf-8?B?SDl6M3FmcFJidmF4SzRCRmg5M1NYSWptc2tldjdSemlodDN5aXUvY3hlL3BV?=
 =?utf-8?B?dnpOWTA4TXVCSkJUOWFHcjg1c1hMVTQvdWJFWW5UUDArS3hST2VHYnFUZzc2?=
 =?utf-8?B?bGQrN0RFNGRyUWI5ZGpack1pZysxeFo1OERjVnAwcVI0YnJlVHFsS0srK1hy?=
 =?utf-8?B?TjVGM0pnMnhkNEYrQzd4TTdoeEEzVjNlVUJoTm5jbG9rckZNVmhGUDhHNVVU?=
 =?utf-8?Q?8C4HhaHleADsSmRj15rHIjSZWXEJSHAJ?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR12MB5685.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?c3V6QWFFeXBQbDBWOGlwRDkzemhCbFpEK25xUzNoeVByVUVVS0s0bGtPY0pP?=
 =?utf-8?B?UUlWUVg1RmE0K1VCZnZsQUtObExQa04xc1M4T3FoVHhJakw2OGhJWXZGTmVG?=
 =?utf-8?B?WkZNU0g0aXJtbFNyeUl6ZnAvVGNDQ25ROXkwNlhNYkpLNVNFWTAwcXU4M2d0?=
 =?utf-8?B?V0k3Kyt6dTdacDRsbXVBNTZ5aWFwb3hMUmhOcVVoNTlCTmIyOEluRjVGb0hC?=
 =?utf-8?B?SmVwVk0yS0ZRbEdSTXcxaFYrODdxd1dSUS9FWG9TVVZyWm41L01wbm9KdFlH?=
 =?utf-8?B?WkpFRkFnY0NJZ1dDNWZBcFpJei95Qk1Bdkl6Y0dnMEpKRmRRWUk1bFVIUitG?=
 =?utf-8?B?c3pQYWFrb2Rzcy8vRkJydFNQdTJjSE1Xcmlub2hWQ25DbmlPdTM2bWdWeFla?=
 =?utf-8?B?T2V3MDIvTmd6YmJNQnluYk50amp1TGt4dUp1TlFZUG94WVBrMkg0bVVLMll3?=
 =?utf-8?B?YThMSTRSRXJ1bkQxWHA3Q2hJMXRGMEk5RUJZK3hEN2xYcEFqTnEralVWcTZT?=
 =?utf-8?B?TDQ1Q3V2QzhzVkhqWEtwclNnZWhTVGNpQXA5SkQ2NnpsdmRaQ3ZmUWJyelB4?=
 =?utf-8?B?amlENlhJdXpPalBRdndWZUV4aldEbXlmd3RKYmtYTjNhaTZTMzc5U1NDQWlh?=
 =?utf-8?B?anplSjBzVlJ2OXdUS2FFdVpscFl5Y0NhQkpXcHJGV1d6dnhOT3k4Zkd4a2hP?=
 =?utf-8?B?TEt0VkwvR3pnSFh3cmJaV1F6bWI3ajByRnlvbSt2YUd4ZDlrejJYc3JYenI0?=
 =?utf-8?B?WGk4azBTTE5MeWtXcm84b2gzTlF2OG5pWCtKWjkrYUU4ME5SeVhkYkNJRDRk?=
 =?utf-8?B?cjVVaEpMdWFVbzdxS3o3V1hKUzVlcEVlMS9xMGxONytLZkdCZlcyd0M0ZmRC?=
 =?utf-8?B?YnlETnFoaDFMdFVJUXAwRnZOQjdzdVR5am84WnNzNDBmMjVNbFZrMUJQK1Nj?=
 =?utf-8?B?RFJwYklLVDF5UFdYSGNHTWtRcDFHSjhQaFJYdndDM1pvcUtQS3kvbkNVRzQ2?=
 =?utf-8?B?Ni92TnJLdjYrMFZ2MDJJeHAyNllWWUJ2dCtTSXNlcTR5K056MzlJZ0lWNGtD?=
 =?utf-8?B?Nm9jdGMwZlBUSXhrRDBFOUh4NFZqNU1laU53UTU3dVV4K2ZaVDBTanBlRzVN?=
 =?utf-8?B?RkNSNGdUL1c5RE5HazhpMFhGMzBrMVFicHlnY0VJM3dtSGQ4dXh3T0FEU1BD?=
 =?utf-8?B?UFlCWVNFQk0yZHFNNFVMY0hONXI4VlA2Q0VqRDMzVGFERzhva1ludThMV1pJ?=
 =?utf-8?B?cG1tTElHek94V1I5S2lLZDIvVDJyZU9wMGhWZ2cydHMrUjE4V25ZWGFxWUxu?=
 =?utf-8?B?OWtqVHFrNHRodjl3N3BHQ09Ha0N6eHNPTG0yVTFJdXFWdy90T2d6cFQ4Mkpq?=
 =?utf-8?B?WCtpWkNmd01KbFlURlpvc2RWQUtzaEkwZ2tqTk12VFZqd21VQjl0MGZFSlZl?=
 =?utf-8?B?OENJakUrUVBFS1BBSFd5UUFIN0wvY3pXSndEWndMMStIdlhLVStZTkdVbGNk?=
 =?utf-8?B?T3ZlM21kT3Nacks0ak5RM1FkQzJoNHFsOVZYTm1zMHhEMlBhWTdHekFzU09t?=
 =?utf-8?B?MGc4eUttRW9wS3JBMjdzUGp1cVEyanJFZDVVSXN1amQ0ZURyY0t5c3FmdXF3?=
 =?utf-8?B?Sk9HR1dMcDFZbElIN0RDcGxQaFdSM29KWTJPeVJBM3BiT0ZUNTV5dzBkRlNT?=
 =?utf-8?B?MU5wWnorZUd0b2tmeTdwZ2NZSnVMZHUyRHc1MEVZNXE0S2dycWFlUndzMWtW?=
 =?utf-8?B?Q0hTNXh0MFkySDdkODFGa0dsdHVrUkFwTDBYMm9RRG9wVmNSdW5CZkNZODdN?=
 =?utf-8?B?d0lXU0R3WHVwTks0WmZFS2ZzbkljbFo4Tm1zdlVUdEgyRHNxSVc5WUpicTBF?=
 =?utf-8?B?RUI1c0xDdzZjOVFkSHFta1V6Yno4cjkyVUVXY2xLRHdrM1NXMDE1S3RtNnVt?=
 =?utf-8?B?VE1Ta3FYU3ZXZmFKOGNjeDg1VXlSWjNTd1RCVm1NYndvVjVFRjQ2U21EVkZh?=
 =?utf-8?B?eDh4dWI2YU9BdS8zbTd2M3hWeXZBR3p6Vmp4ckppNzlvWk52N2NkN3Zlancy?=
 =?utf-8?B?MFJuOEpkT1c1UUlZQ21EazRSbmZVWE5yWW1Mc3h3ZXJ6MmFJdWZMWTh5bzlz?=
 =?utf-8?Q?O6p/3p8CtZa4dPhrqLlDljly9?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: be49e4d0-fd5a-4a5b-afe9-08de0b39a144
X-MS-Exchange-CrossTenant-AuthSource: PH7PR12MB5685.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Oct 2025 15:52:08.3275
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VGUgW0vN2DC8Ehd4L/gD8Zj7d6fVfyKPmIQyTQsrGbHYMaCc1GIvyawhUYNr1lW9
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW6PR12MB9019
X-Rspamd-Queue-Id: 9EB8840017
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: x9ohszhckcsh581863rcobntb7jwfk7i
X-HE-Tag: 1760457132-580648
X-HE-Meta: U2FsdGVkX18rhQ9MIOuBU9V7KfsduPcqCpRsj5gZNSagT8BbMhytNvEiJ12LVF2ZDoou2XxebGj9Id9qp5Z1CQIir2zOAeuGcVy3sEZXd1W9gO6uE6hcoKrowFjhgJ6GRSjQ2G0jY0GYX1QdZ6U8NrOKe+il/jZDOuxiesfLOSFZoykqMKh4lhjdcPn2FP/PfEaqrEeKLSfKXcRBDXuu07r9F0IjMIF7d9FqqIiMSABdJKvC5DOkYe29PCLzKroac83KjF+MUzCjCn9TilDuE3rtlePOolxqCe5c8Ce9DPAA5Ms0nkVHKl/U0e8MFpzLd93N/J1sve7/75cH11ArOgrB63rTroGX5HqYUShWE/bVfDPnWAnXZAEJV/vKI/UqxdcVOkvYjlk4fjIGx4jh0o0wprLczFeesMxxc7VoAgiXFEgMd6ckX4BgUmDLpcFACr7ErOIItcGg5WcUTdBWqf4wd0GX+bT2Q8/Yn90LpXxKeh6dOO/vkIEicd6rXteS8gzADX6aqevl3WBYjj76bDcXR+lL+fG3/bc6it2Bt/ug++nf+0zRw1XpbVcvv6PlVa6G94CJpxwuy4R0qUeT7vz+h6a+0C+6zfpELm1lidbzHBkCb/Y1lGtMYSnLFE8Hvd1aIk6Ji6rRa4AKQlWGHAtZ0PU4z00Y5RslClWP5B/HdNKhrTg46Qb49F2ZtOYEHwC/qGGmbylGeo3PgBf5p9woh9K0gYLWRBDruzpkGoZ5ZIhdOOHHzOpbeHU4bQEnr6uSin55c1higI6xwK2ffj7jugBnlhLML18SPgr90Sxot9km8j3/gBn4H6pSjXvlInBl8oMwETCP9WzN2kbMy9DapRghJR+7ftbHF4pJIiIZkMlacQJg7CMtdAlTGYkbPNNUBWL5Uvudbawkiq0d4RjtwCv/KajvqHZbcnkknbxFTj9HmXZlQLV2SNV/abWLcafB7y9az8FlXwYjqpm
 BH3d27PR
 ojObis36taATqcPv2u4Fp1iizAqtUcIOVgnczA0pxl0FgBmyh6zlongn4y/S+B2A6aXdalmgHZFhTDKsm0V+sQ5rxlAAsNBcwwYnUUaDH5kriktuBkJHx85hchCOgalFZHmYGncKE0HTFlIxIcfstiXhwCZawbIN5PNxbvuNV15vSWm7ANK28Ka09aVnJyDCWRYyXcwG2byFHb98uZOUCtQBa8Hy6r70E7y/RrelAV+96R319Xh7F3+cwNCOFwa8QDHQxidXTxE0/ml7YtPVqRgJdAlaijT1H4oxYSlgwW6GSylMSnTjLP3VC+Ppe9YCroSevcZTrp3nx5YpuFsDfVgBNCnt5Ww9WOinIGYYn9QJGiqhuxx6s8gL8YBs12QJef3nGrpdEJgmF03ISqJzJfGSHFQ0rDkgdGilVCbRiCc35X07TiMAut3rpnenwWlisgu+9tZ09bczBDxA5HP8XvrZuXSq2V0orAM6h0lTAx7fZgxSkKFYWaYCQlD68VjJviWfPepQAg2NUP/HOtet2p1LizR4mOg9K483sUdQ5BOFNU9KFrm8Gxa+h4JbjDXuYYXisbH4DdmVE4zQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 14.10.25 17:10, Petr Tesarik wrote:
> On Tue, 14 Oct 2025 15:04:14 +0200
> Christian König <christian.koenig@amd.com> wrote:
> 
>> On 14.10.25 14:44, Zhaoyang Huang wrote:
>>> On Tue, Oct 14, 2025 at 7:59 PM Christian König
>>> <christian.koenig@amd.com> wrote:  
>>>>
>>>> On 14.10.25 10:32, zhaoyang.huang wrote:  
>>>>> From: Zhaoyang Huang <zhaoyang.huang@unisoc.com>
>>>>>
>>>>> The size of once dma-buf allocation could be dozens MB or much more
>>>>> which introduce a loop of allocating several thousands of order-0 pages.
>>>>> Furthermore, the concurrent allocation could have dma-buf allocation enter
>>>>> direct-reclaim during the loop. This commit would like to eliminate the
>>>>> above two affections by introducing alloc_pages_bulk_list in dma-buf's
>>>>> order-0 allocation. This patch is proved to be conditionally helpful
>>>>> in 18MB allocation as decreasing the time from 24604us to 6555us and no
>>>>> harm when bulk allocation can't be done(fallback to single page
>>>>> allocation)  
>>>>
>>>> Well that sounds like an absolutely horrible idea.
>>>>
>>>> See the handling of allocating only from specific order is *exactly* there to avoid the behavior of bulk allocation.
>>>>
>>>> What you seem to do with this patch here is to add on top of the behavior to avoid allocating large chunks from the buddy the behavior to allocate large chunks from the buddy because that is faster.  
>>> emm, this patch doesn't change order-8 and order-4's allocation
>>> behaviour but just to replace the loop of order-0 allocations into
>>> once bulk allocation in the fallback way. What is your concern about
>>> this?  
>>
>> As far as I know the bulk allocation favors splitting large pages into smaller ones instead of allocating smaller pages first. That's where the performance benefit comes from.
>>
>> But that is exactly what we try to avoid here by allocating only certain order of pages.
> 
> This is a good question, actually. Yes, bulk alloc will split large
> pages if there are insufficient pages on the pcp free list. But is
> dma-buf indeed trying to avoid it, or is it merely using an inefficient
> API? And does it need the extra speed? Even if it leads to increased
> fragmentation?

DMA-buf-heaps is completly intentionally trying rather hard to avoid splitting large pages. That's why you have the distinction between HIGH_ORDER_GFP and LOW_ORDER_GFP as well.

Keep in mind that this is mostly used on embedded system with only small amounts of memory.

Not entering direct reclaim and instead preferring to split large pages until they are used up is an absolutely no-go for most use cases as far as I can see.

Could be that we need to make this behavior conditional, but somebody would need to come up with some really good arguments to justify the complexity.

Regards,
Christian.

> 
> Petr T


