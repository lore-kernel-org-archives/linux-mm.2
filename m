Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6900CE9A03B
	for <linux-mm@archiver.kernel.org>; Thu, 19 Feb 2026 07:17:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8A1A46B0088; Thu, 19 Feb 2026 02:17:48 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 84F2B6B0089; Thu, 19 Feb 2026 02:17:48 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6DC4D6B008A; Thu, 19 Feb 2026 02:17:48 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 578CF6B0088
	for <linux-mm@kvack.org>; Thu, 19 Feb 2026 02:17:48 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 017891604A1
	for <linux-mm@kvack.org>; Thu, 19 Feb 2026 07:17:47 +0000 (UTC)
X-FDA: 84460351416.24.38B75EB
Received: from PH8PR06CU001.outbound.protection.outlook.com (mail-westus3azon11012034.outbound.protection.outlook.com [40.107.209.34])
	by imf23.hostedemail.com (Postfix) with ESMTP id EF283140005
	for <linux-mm@kvack.org>; Thu, 19 Feb 2026 07:17:44 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=AP2XeDEE;
	spf=pass (imf23.hostedemail.com: domain of Christian.Koenig@amd.com designates 40.107.209.34 as permitted sender) smtp.mailfrom=Christian.Koenig@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771485465;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=A5L03MVjMDi5lWrJvwAeARAlGm5FyUfDfX6LrKw568s=;
	b=ufZRxAljWoS2GNbO5D7OaPjL7v3AMX5KuPMgwJA9TWFgTdqCW2iMEwdtB9dvJZkGg33nfq
	Q6HOimzbuV5ZVoB162u0ZAkgj+LgC9iHlfTW3jMoy3FE5Nu1Mfu4FzzA6KK7+ueGu5JOyS
	RIpowcn+lQlSpoNTaJG01jZwnoma3H0=
ARC-Authentication-Results: i=2;
	imf23.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=AP2XeDEE;
	spf=pass (imf23.hostedemail.com: domain of Christian.Koenig@amd.com designates 40.107.209.34 as permitted sender) smtp.mailfrom=Christian.Koenig@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1771485465; a=rsa-sha256;
	cv=pass;
	b=aPY8osibtxhAY3fxb0T/sRJKs44puYRohZFHEIdsMTNq3QR985LjOp2sxmf5/uPi5A/pPk
	HO3jR0uAdzMaGu+ITqB+pXze9oKXiPPDJR2CnCxzTtYYEqskOsN5Ewm/ztHa8M7A694cIu
	X+0KNFhtq6S+/gy9gzwlth1P2XBe55g=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=h977hE/BgLDvjaN0lEFv6fTaR8rR8n7RB0yyKa/r+0XipCwIyxH8ahPVFJErctnRnj6Xd8txedMEdLmHOHYxN7CaEDTUotqqp3lcI9XvxwG3AykWXLfganaSHLSND+6QQxo4om9bAG+H9tniAdsTZvOX3nbsi3D56HS8OqR65avGEYsT+rUGZEJ62B849Od0w5I/SnmC1UE3DdP86mAxmbr2nFXNouUlBojibYQ8k7fkRZNpBQjKZ7DxUBBLe7HWuqzlz5eaouTQ8v1gipN9+TqD4yYOYRxonUwaVCEObyH+IqFC1lqGgL2V0Al4PYaAkTfGIqSTRXqS81u1CGw2sg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=A5L03MVjMDi5lWrJvwAeARAlGm5FyUfDfX6LrKw568s=;
 b=x/LUM8RitoLtoi4dBfc/P/SpJmmBlYRVO6q39r/5oxMFlpCtcWt23oKi2d++2D/Ei1hrSh9CTnuZ5FByLZKAt4rjKoXjkd3AtiPVbrJfdBlxlphpJnT3nSk2gZc5GXZIGwqWe1numkEsMQ3n6a2VnzxvFhET4Og3X6h4Hs8C+32EU5CIVk68KbObQlE7bjw8cDa+fx6UOZK04ZTSpABneChJBYbVOGwQDOrCvGz4z/Iat32miRLFTt7SZSeIgdoG8HBqA4MZWafw+kNHdLiV4g1j9fzJBHFVLJSBcO3IuDcfmvBNV2oSIyRieArda+o7HefC+3jNz/xasuh79XR5PA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=A5L03MVjMDi5lWrJvwAeARAlGm5FyUfDfX6LrKw568s=;
 b=AP2XeDEETI6Jf0EWfCDxMpTauvZVg20YJgSglLgZiWiRUEtBYy8rd/fIISx6gmBp/mubLfdWgRahUHdCbaecwPbPijbm+a/fH6Bvgs3nfTpm6y6W0aPYu7VaZhOzee+Zjrm7fQAPmT/50ZORKya3VMe6CMG7pIeye7MzNb7c+KU=
Received: from PH7PR12MB5685.namprd12.prod.outlook.com (2603:10b6:510:13c::22)
 by SA3PR12MB7832.namprd12.prod.outlook.com (2603:10b6:806:31f::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9632.15; Thu, 19 Feb
 2026 07:17:39 +0000
Received: from PH7PR12MB5685.namprd12.prod.outlook.com
 ([fe80::ce69:cfae:774d:a65c]) by PH7PR12MB5685.namprd12.prod.outlook.com
 ([fe80::ce69:cfae:774d:a65c%5]) with mapi id 15.20.9611.008; Thu, 19 Feb 2026
 07:17:39 +0000
Message-ID: <435330fd-ecdd-43c7-8527-f285c03c6421@amd.com>
Date: Thu, 19 Feb 2026 08:17:28 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 3/3] dma-buf: heaps: cma: charge each cma heap's dmem
To: Eric Chanudet <echanude@redhat.com>,
 Sumit Semwal <sumit.semwal@linaro.org>,
 Benjamin Gaignard <benjamin.gaignard@collabora.com>,
 Brian Starkey <Brian.Starkey@arm.com>, John Stultz <jstultz@google.com>,
 "T.J. Mercier" <tjmercier@google.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka
 <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>
Cc: linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
 linaro-mm-sig@lists.linaro.org, linux-kernel@vger.kernel.org,
 Maxime Ripard <mripard@redhat.com>, Albert Esteve <aesteve@redhat.com>,
 linux-mm@kvack.org
References: <20260218-dmabuf-heap-cma-dmem-v2-0-b249886fb7b2@redhat.com>
 <20260218-dmabuf-heap-cma-dmem-v2-3-b249886fb7b2@redhat.com>
Content-Language: en-US
From: =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>
In-Reply-To: <20260218-dmabuf-heap-cma-dmem-v2-3-b249886fb7b2@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR4P281CA0259.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:e8::9) To PH7PR12MB5685.namprd12.prod.outlook.com
 (2603:10b6:510:13c::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH7PR12MB5685:EE_|SA3PR12MB7832:EE_
X-MS-Office365-Filtering-Correlation-Id: 99e9e103-29d8-486d-e515-08de6f86f6ef
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|376014|7416014|1800799024|7053199007|921020;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?MDRMR3A5a2xSWHIyVEN5M2ZGOE1lcEN1RjVqcmZ2VUFrN0hvWjZjMEZPdS9V?=
 =?utf-8?B?NTlaUFpqejJURjhNczhwbmxsOU1SS1JKUnQ5YWg5OEFKam5lQ2dnZ2NabFJW?=
 =?utf-8?B?SWt4RzJDNEdMWTJ1SERHQ3Q2YUZCUDFDNGFnd3NCcXNwWFI0bzh2b0lFa0dO?=
 =?utf-8?B?S2pYOC9MeDNHRi9ZOXZmaENoK3dnd0FTeGwyRFhjZEVPNDF0OVpEUHlrL3Ju?=
 =?utf-8?B?akVSUitrcVMwOTVQZkpsNFNmTUlIKzZ6eUIveUZSRXA0RVpZUGtzSk44TGF5?=
 =?utf-8?B?b0pIdHI1b1JCOGhYdkFrUEpRN1FidDNlVWhndmIwSkFlNmhJNWV5TXJhTG5D?=
 =?utf-8?B?Q0drZFcwaS9PQVlKMXRUY2ZwWmU5ZExwT0wwc2lUanVUYWxOT3JocmVkNlBY?=
 =?utf-8?B?U3ZaL05hTGErUlgvb1g5WXJ5Sml1UXpqUVlCbDlWdkMwdEpUUXcwU25kMFg2?=
 =?utf-8?B?Ni9qam5TNWpzRHhJNkdQTXBWbmNrNGxqRnJSQXdoa0ZYTFFZK0w4a1BmZ3ZT?=
 =?utf-8?B?ajRBRmJjdWJweHBYTWlud3M5YTR4Yy9JS1BqYVB0WkVmclZGajgzMXY2bjZD?=
 =?utf-8?B?OCtQd2dVQzlDS0hRSS9DakgrdDhLUDRNdEtXZjd3ZndNYUplMkttWnhyR3Iy?=
 =?utf-8?B?bXJadk5tQ0RMZWR6N2RDc0EvS3NaZ2JtVjRYdUVRVVpYclQ4aUtURGtRUENn?=
 =?utf-8?B?MVcrU1NJS3RhN2ZZeFNPYTZMeWsrN2oxcXk1RStkUnBqRGdJcVh2M2pJZ0VY?=
 =?utf-8?B?MFF1Tnk0VVdyRGFtOVIrZDJoUUE5Ti92NDNlU1UrVWh1ZlB4SU43Yzl6UzNZ?=
 =?utf-8?B?NHlmb2VFQklzZ2lLWFhyWnUxYU5TTmxvSWZYZ0FQYVZKa2NKQVNtbnB3ajVw?=
 =?utf-8?B?MDc3endCWWNOM092THdaaWVmbmFNaHFjSzhmc2hTMHFWN3FKZ0RVaHovUVBn?=
 =?utf-8?B?c0tkVFFpTUpnWmpsT1BXSmk1MGxENDBRd2pOQk1jNFZOM3krMVVFbTQxMnhP?=
 =?utf-8?B?VEdhQjBhWGdHT1VkTkxNWnhBUUl2VDdhMS93L2NEVUtFaXFpV0pPUzBYSVZD?=
 =?utf-8?B?WElwR1pLdUVPWFA5V3hoQ1Q1Q3ZLM0syZ01iVCtVZVpnSVNZeHpncXVqSXpM?=
 =?utf-8?B?MldpQ2VZa1NUbFljTTUxRkczem1tVk5xa0tIOGZheFIwcFVEdkFFb3RMaHBl?=
 =?utf-8?B?UWw2M2syeURuQ2FOSCs0Rmttb2R0Y0FQWlJzTE40aFFGZnljcG9qbFNsUldi?=
 =?utf-8?B?WnRCWWZEc1VOT3pSNkhOa29pRlU0NkVhR0hrNDM5elRFZmRiTytqOHhjdktw?=
 =?utf-8?B?MG0zVmVsVml0dm11ekNsQmlobFVXVTIrWXV0YndocUVJT1cyZzFKalhGaDF6?=
 =?utf-8?B?dGtTU3pRc29laWJ4b3lMNkRXb0tQcUg5MmlhVEs5WUU2SDhaK254dGluWnV2?=
 =?utf-8?B?MnpMeGtvN3AxRHQ1SEhmK1c0S3R3R0pNOTZjTkZKc2wzRXRVd1JwOWhWYW5Q?=
 =?utf-8?B?dWlCNDhra1hXOHdrTnJBU3JqMHR0TFl3Y3ZVWC9aRFg2bDBPL0Y3amRMNUp4?=
 =?utf-8?B?L1NoL3ZMZmNwcWllNUE1a2t2U1FDdlVmRzNSWSsyREdyZnA3V2NkUU82RG1w?=
 =?utf-8?B?YmdsSVBIc2JhcUpzV0tzK1hCVzVoUnJBbTdrWE5LM1pMajJjQjlQL29oc1Fi?=
 =?utf-8?B?Q2h1MWx1UWU5SFl0V2JibWxBekI4Y05jb3JYd29SQWlVYXU0VWxmbURpQnpY?=
 =?utf-8?B?V3hLY0V4MmoySDYyWjN0bmxKbm5VWnIrWFROS1l2RnNVVDA1UHhjSHlEUU9Z?=
 =?utf-8?B?a2pEa1FyV1NKMm1BUDY2T2Jvbjlyc1c3U0Fab2p5Qk1yZndXRzV4M2FsOVF2?=
 =?utf-8?B?Y3k3N3pHRHI4TlBNWTlDM0IyNmNDdjhuTFRIZkNaYWZMaXFDaUdsWldGeDll?=
 =?utf-8?B?aU85UGlSY2xTaW5sRmhHN3l2ZVcybmJOcVEvOHJHTThUb1hCcjNUUlo4ejEv?=
 =?utf-8?B?cDlFVUpQV2hXQTRwL0IyVjNBL2FxdWUwdzFObkJLWTdkR1pyK3pwSkNzZzBL?=
 =?utf-8?B?OW5aOUwzVVlkR1hoWER4YnhGNUE1eU5wWDFKbTRuU2x0d3BRb3MyRURKM3hB?=
 =?utf-8?B?MzF0UnE1ZXFuVG1FSnk1YzNaSVBTblJBMnVIb0JMNTU2TGFqNmprZUp3QWVq?=
 =?utf-8?B?QkE9PQ==?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR12MB5685.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024)(7053199007)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?N2xHa3l4U1loNE14ek9OVGMwNUpMRTMwTnhzczdxWnB4bmo4L0NnQTRLVTZm?=
 =?utf-8?B?U21sNlhVMWVyWmpwbWtxQThOZ05yTjdRdWdWTjErV2FkcWxRSHFsRC9zK3g0?=
 =?utf-8?B?cVdDN3c2RlplNk95ZzNFNzhSYzBWL0xMazhvVEI2QmFZSDk5UzBuZ1lZZUNZ?=
 =?utf-8?B?ZHVCaURTelNFeURiRWdFaDl5bW94Q0hHR200Y0doQmVMM3dQRVduTExVYXBX?=
 =?utf-8?B?OFNTN3VRWTdqN3BKTDNKUWFHVUUwSll5Yngxckdxd3FGSDMwdENEMkNqQUlo?=
 =?utf-8?B?VHFXZk80ZWZiZENXaEs3Y0N6d20vUDdmOTNHN0N4d3ppczJJdE1yRWhLWWpC?=
 =?utf-8?B?azZvcXRyNFYvcTBibkZrRjJQYmZEbGdSdmllVk1ISjB3eldPdzVBU0Y2bnNt?=
 =?utf-8?B?S0I2UG41aGtkVGsrZHd3Y1pVZVFUSDJlYWxJYldSVEFqMnppbVN1VnZ2S3hh?=
 =?utf-8?B?ZnQwSHlrSjNzSnVROStpT3U2eU5lOEhWZGV5VklxU1JvbDg2UExIRFU3VGZC?=
 =?utf-8?B?dlU5MHZuZG9qdERFUE1xVEgzWmxlZ094SkwxVjhmOHVwQU5tVWhNQ1pTc0xy?=
 =?utf-8?B?VzFGRzRYNkdBUWlXai94Z09FVGZ6TzBFa0JMdWxPNEJnQUJ3dTQvUm1tdy82?=
 =?utf-8?B?TnFmL1JJTlI5TU11cG5oNnA1UWxXLzBVNFhPM1hPNWdKbXJMc0VKUkc4N3kv?=
 =?utf-8?B?d1JIVG1EenFZbzdRWTVMbTIxWkt4Uk9CL1ZMUEVsQXlET2FieEJGd2F0SWdl?=
 =?utf-8?B?Wm8wRmgvb1plR1pvK1VITFJnK2xwNGdjMDJLQVA2SGpwcVh4UlMxQzR6NCtF?=
 =?utf-8?B?SVlmajFiUnhsTEZsUytaWEd1aGg4M1JVMjByQ0lJZmsrRy9YNCtQQThvZERk?=
 =?utf-8?B?OFZDZm1IZEwrZTRIa1Q1dFRaSFhod1VCbkNaZGQ2clFiOWJTZTIzazhXbjVP?=
 =?utf-8?B?c1hYNy9ISkRZYXZCSkhkZFJXM0ZVZm14YW1EcnpkbWM2a05BZEZobU1lNlpl?=
 =?utf-8?B?RG1weGM5VDRqWnRGOVZCTnBKcUhRQTIvYzFpSkJQVmVoaTlObWdBTGV2SGN5?=
 =?utf-8?B?bWFta3ZTUytwVmlDelZoMXhzNDdmNDFQTHZWTlA2SUpJclgxWXpCaU50R25P?=
 =?utf-8?B?QjczT0JVSUVXTlRCMUdQRFRibnRTVFZST04vekt6c1FzY3hWU0Vna2U4RXU4?=
 =?utf-8?B?ckJuT2cxWHdpc0JpYjVScXN1WGU4MHh3eDAwenRpcUg3TEszUzJBZXVWeWNO?=
 =?utf-8?B?WVVYejkvQlpxbFh6d0xNaDlrNitOcDdkeFIzb2dVQ2hweTVjcmhyWWE0TFZF?=
 =?utf-8?B?T2diZ0d6S0tHblZaQnBoWlc1MlJCNnk4Z1Y5VlRLQU93TDJ4bVVpTmxwUU5l?=
 =?utf-8?B?U09meUl5ZGZiUHRrSmFrc3VzVFNUQjRUSXRPV2d4a2hMN25xQm9uMGtpRWZt?=
 =?utf-8?B?YzVDTUNubzBmRDhna2JOcXVSSCtWZ1dqcEFlS29pTmlJeldoemdZOEpIbjhr?=
 =?utf-8?B?bHZ3S3M3WTg0U3Y2UU5qSlV4bVd2cDBkQXVpUnd0M05VS09PcUxtSFN5NHRQ?=
 =?utf-8?B?ZDNIM0VHSlBOY0JvRGR1YklJRTRRKzNzclIrYVhrVlNUamQydlhNb2hWam5G?=
 =?utf-8?B?QUExYjdMYno0SFRCeHozdVNDUDhxRzZXRGtBYWpLQXV4anIxZlkwYmxJSnls?=
 =?utf-8?B?dDVselpHdC84Tm8yZ2FLcFFpbElGYWk5QytiZHVnaGRQdERGM1FpSTJ2NVl4?=
 =?utf-8?B?VmEyOUtoYnYvN1NtYU5US052bzJPQnR2a2QrMW00R29hVE52c2tsSUJhbjJ4?=
 =?utf-8?B?UXJVUkFiakhUT0d0eDM4cXNRZHJOR09qS0dXd0tENGo5aC8yTkFIdEMrSjBI?=
 =?utf-8?B?Y2lITFFzdllQKzJYOHE3Y0M4aGFvc2NYZW9WTFphOXFrNThLS1JUbE9CaldW?=
 =?utf-8?B?Q1R6SFZtT1oyMEhXVjRVQTVXdnZ0cytLK0REMExzbmRSeTJjRCtJY0h5aVgy?=
 =?utf-8?B?TGxqL2QwODAxVnZ6YklpelRpVmZNR1g2MitJZGg4S0JnbVV4bFo1VFp2YUhV?=
 =?utf-8?B?TElSNkVUWGI4ajBrT3oxZGx5MW9MYk84YVBRcTMwZWE5U09Vc0NOeDhodFl2?=
 =?utf-8?B?OHNQNW9wTW1LdzB0S1lQZWxBKzFQSU5QamVqeHQxa1oxTjBRblpDTHJ0ZzNI?=
 =?utf-8?B?Vm0wUGlreDloWXB5L1RjUnB6QzlIMzJhSVdObEVIWVJ5NVNmeWRIMnpGZTVF?=
 =?utf-8?B?NnNSV3VpQXVaUTB6ZjZva0VxSDI4TW16cGx5QVAvazlySkI0T24wU0tzL0ZW?=
 =?utf-8?Q?1+TeHUzmifwedA6hLw?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 99e9e103-29d8-486d-e515-08de6f86f6ef
X-MS-Exchange-CrossTenant-AuthSource: PH7PR12MB5685.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Feb 2026 07:17:39.5768
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: IoUDcTG8FIKhSMd+T2U9QzI1ymJvPz6UayAWk/LpRMP6UyPxeNZbBiyktEUFu3Ml
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR12MB7832
X-Rspam-User: 
X-Rspamd-Queue-Id: EF283140005
X-Rspamd-Server: rspam02
X-Stat-Signature: cfk45pezjzuggptedoy6wdonkb4a6s6k
X-HE-Tag: 1771485464-333857
X-HE-Meta: U2FsdGVkX18n5WE9bIZMisq9uiPiVr+S9KABVey6WaRG6U8xaW73MjIjW4d05Hh/NcJnuvB/xzvj55nK55Sr1tmGifzS/20idokZfwAP8xUNKRTU/9SS3QfTmSK+SgAZ7ntxSytACboQz6tl8+L/3LjOB5owc8UNYrMPPyguVr/kscGEtLMxnwrkcufSWzwOnhJOuzb9uEyKEZAmG8JfWM2rXkzCFl0er2lOFh9DhV92sTHoua/GXR34WBArUeBulhZFK1cc37zRVI0nhH9cSCyVJ0wYn7Jl4MTDslItM6KCESs+s6yPZ5i+vvgFzHqjEHCxuJAwZcOA30b6PQKHdLXwKnrNlavQvI2b9Nrf+EKH3WFIz7zExOv6W6tyTOvf7dlwBeLBYzEMqL5VTEdryy5hLu/CkQI4Nfxtri/R6ANM9pH8lf9hnZQ9LHwMLpjdsiAiMV2wOCNeh3dctFEUDSpMqQtgRYcgvJXKhzzDcQ2DcAhDVyJJE2j2m1M7yTyrmT+wJQ75xeAtl8a6TyewyBcYu7DhiYrR3PUZ3LqNN0964nw6p5JNwohAEz4fjz1tteFEBB1v+1MXPA4iFOY4ljJKMSAj822PswISb3jeGT6320Qzm3m0cDXT/y6DGc5fKZFCqUWZHTLEZ6Wh0y7m5f20ZseP5rZLhOumoWAYvGM3sPEe9IKx1V/j7/9Zl9iDo1UcNOsxO67gkUxABqUiy7zd7pz8zaUVoNPhc69c5K90J7gODW9YEu4wcfnGoXGk2z+DzWZ3Ecp9pP/Mf0RHLKRn0llJA1DcsWazHrfzWwF+V5EgPn6OjKxNAoaVxDpwfS2nMV8l/sYuejG43L2Fabvs/3Sm8Xq4Xg3vX17/JzEtTSIR1/2IOKYUZ8OyiW+rpmvY9zQoYF6bM1pJf39MLfLdPfve5fOeU+RCF3vDffOe8lHyP4QchRZ8X3hopOZD8CHJ3nKyf7HegHnk0iP
 IPTqKEu9
 LtXWHUL5QfYfgzXxPtUGOYrvOP3JDUGKsLr0DUuT+7OdsAzTedRkGVmnEMKi82Q34bjM1NVtdnqY/T3quw4BVTYJVqpzMpkC+b0MCb6aWOqR5R3HbjgoYhLjYnlwVKJX5eMr28GBVqKka1r6oc9znBCUCeIVdHfP379qNyZRr44igO+EZz7bF3k+XubehFFxIjq1nl0wU3G2H971xifQj3oUszfMzDDnJe9V0gZBRtFiRz0Isrk9zOnoIhgtJnDmEC1HS3BRzaM6C4SirrEXlfJU8hqHIicUaI0wh9MKxMZBv/x+bdJakN/pDEDsE7trpbeJpxUdEfuD91n/q8udhCepBLKgeHQSro1/Gn+4uJucURBj0THH8m+/ka8NyoNlHU9zlKJp9zeMi+QboL8c0XtRxvCDIU3V1SWVIVtpjcP+mbAL8cy+eAiEB3usiZRzg7KXuLUekm5aGdsK2SSaO3lIOq2gIKv7AZkQUcagjT2qyjAA=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2/18/26 18:14, Eric Chanudet wrote:
> The cma dma-buf heaps let userspace allocate buffers in CMA regions
> without enforcing limits. Since each cma region registers in dmem,
> charge against it when allocating a buffer in a cma heap.
> 
> Signed-off-by: Eric Chanudet <echanude@redhat.com>
> ---
>  drivers/dma-buf/heaps/cma_heap.c | 15 ++++++++++++++-
>  1 file changed, 14 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/dma-buf/heaps/cma_heap.c b/drivers/dma-buf/heaps/cma_heap.c
> index 49cc45fb42dd7200c3c14384bcfdbe85323454b1..bbd4f9495808da19256d97bd6a4dca3e1b0a30a0 100644
> --- a/drivers/dma-buf/heaps/cma_heap.c
> +++ b/drivers/dma-buf/heaps/cma_heap.c
> @@ -27,6 +27,7 @@
>  #include <linux/scatterlist.h>
>  #include <linux/slab.h>
>  #include <linux/vmalloc.h>
> +#include <linux/cgroup_dmem.h>
>  
>  #define DEFAULT_CMA_NAME "default_cma_region"
>  
> @@ -58,6 +59,7 @@ struct cma_heap_buffer {
>  	pgoff_t pagecount;
>  	int vmap_cnt;
>  	void *vaddr;
> +	struct dmem_cgroup_pool_state *pool;
>  };
>  
>  struct dma_heap_attachment {
> @@ -276,6 +278,7 @@ static void cma_heap_dma_buf_release(struct dma_buf *dmabuf)
>  	kfree(buffer->pages);
>  	/* release memory */
>  	cma_release(cma_heap->cma, buffer->cma_pages, buffer->pagecount);
> +	dmem_cgroup_uncharge(buffer->pool, buffer->len);
>  	kfree(buffer);
>  }
>  
> @@ -319,9 +322,17 @@ static struct dma_buf *cma_heap_allocate(struct dma_heap *heap,
>  	if (align > CONFIG_CMA_ALIGNMENT)
>  		align = CONFIG_CMA_ALIGNMENT;
>  
> +	if (mem_accounting) {

Since mem_accounting is a module parameter it is possible to make it changeable during runtime.

IIRC it currently is read only, but maybe add a one line comment that the cma heap now depends on that.

Apart from that the series looks totally sane to me.

Regards,
Christian.

> +		ret = dmem_cgroup_try_charge(
> +			cma_get_dmem_cgroup_region(cma_heap->cma), size,
> +			&buffer->pool, NULL);
> +		if (ret)
> +			goto free_buffer;
> +	}
> +
>  	cma_pages = cma_alloc(cma_heap->cma, pagecount, align, false);
>  	if (!cma_pages)
> -		goto free_buffer;
> +		goto uncharge_cgroup;
>  
>  	/* Clear the cma pages */
>  	if (PageHighMem(cma_pages)) {
> @@ -376,6 +387,8 @@ static struct dma_buf *cma_heap_allocate(struct dma_heap *heap,
>  	kfree(buffer->pages);
>  free_cma:
>  	cma_release(cma_heap->cma, cma_pages, pagecount);
> +uncharge_cgroup:
> +	dmem_cgroup_uncharge(buffer->pool, size);
>  free_buffer:
>  	kfree(buffer);
>  
> 


